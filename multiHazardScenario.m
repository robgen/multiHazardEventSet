classdef multiHazardScenario

    properties
        
        parameters
        hazards % triggered hazards MUST be at the end
        simulations

    end

    properties(Access = 'private')
        
        folderOutputs

        hazardNames
        rateEventPool
        
        currentTime
    end

    methods
        function self = multiHazardScenario(folderOutputs, options)

            if nargin == 1, options = struct; end
            self = setAllParameters(self, options);
            
            self.checkInputValidity;

            self = self.collectHazardNames;
            self = self.setInitialRates;
            
            self.folderOutputs = folderOutputs;
            rng(self.parameters.Analysis.seedNumber)
        end
        
        
        function self = checkInputValidity(self)
            % TODO: severity curves must be defined with frequencies in DESCENDING order
        end
        
        function self = collectHazardNames(self)
            self.hazards = self.parameters.Analysis.hazards;
            for p = 1 : numel(self.hazards)
                self.hazardNames{p} = self.hazards{p}.name;
            end
        end


        function self = setInitialRates(self)
            numHazards = numel(self.hazards);
            for p = 1 : numHazards
                if self.hazards{p}.isPrimary == true
                    self.rateEventPool(p) = ...
                        self.hazards{p}.rate;
                elseif self.hazards{p}.isHomogeneus == false
                    self.hazards{p}.indNullEvent = numHazards+1;
                    self.rateEventPool(numHazards+1) = 0;
                    self.hazardNames{numHazards+1} = ...
                        sprintf('%s_null', self.hazards{p}.name);
                else
                    self.rateEventPool(p) = 0;
                end
            end
        end
        
                
        function self = simulateScenarios(self, Nsim)
            % TODO add to the pool, if there are other scenarios already
            % this code does not seem parallelisable because the state is
            % saved only once (as opposed to one per simulation)
            
            for s = 1 : Nsim
                [self, self.simulations(s).scenario] = self.simulateScenario;
            end
            
        end
        
        
        function [self, scenario] = simulateScenario(self)
            % TODO smart preallocation with nans
            % TODO this function should only return self
            
            ev = 0; self.currentTime = 0;
            while self.currentTime < self.parameters.Analysis.timeHorizon
                [nextEvent, self] = self.simulateNext;
                
                if nextEvent.type <= numel(self.hazards) % don't save null events
                    ev = ev + 1;
                    scenario(ev).times = self.currentTime;
                    scenario(ev).types = nextEvent.type;
                    scenario(ev).severities = nextEvent.severity;

                    self = self.setRatesAltered(nextEvent, ...
                        self.hazards{nextEvent.type}.drivesAltered);

                    triggeredEvents = self.simulateTriggered(nextEvent, ...
                        self.hazards{nextEvent.type}.drivesTriggered);
                    if ~isempty(triggeredEvents)
                        for t = 1 : numel(triggeredEvents)
                            ev = ev + 1;
                            scenario(ev).times = triggeredEvents(t).time;
                            scenario(ev).types = triggeredEvents(t).type;
                            scenario(ev).severities = triggeredEvents(t).severity;
                        end
                    end
                end
                
                if self.currentTime >= self.parameters.Analysis.timeHorizon
                    break
                end
                
            end
            
        end
        
        
        function [nextEvent, self] = simulateNext(self)
            rateNextEvent = sum(self.rateEventPool);
            nextEvent.time = self.currentTime + exprnd(1/rateNextEvent);
            self.currentTime = nextEvent.time;

            self = self.adjustRateNonHomogeneusEvents;
            probEventPool = self.rateEventPool / sum(self.rateEventPool);

            nextEvent.type = randsrc(1, 1, ...
                [1:numel(probEventPool); ...
                probEventPool(:)']);
            n = nextEvent.type;
            
            if n <= numel(self.hazards) % no intensity for null events
                nextEvent.severity = ...
                    self.hazards{n}.getSeverity();
            end
        end

        
        function self = adjustRateNonHomogeneusEvents(self)
            for p = 1 : numel(self.hazards)
                if self.hazards{p}.isHomogeneus == false && ...
                        self.hazards{p}.rateAdjusted ~= 0
                    previousRate = self.hazards{p}.rateAdjusted;
                    
                    self.hazards{p} = self.hazards{p}.update(self.currentTime);
                    self.rateEventPool(p) = self.hazards{p}.rateAdjusted;
                    self.rateEventPool(self.hazards{p}.indNullEvent) = ...
                        previousRate - self.hazards{p}.rateAdjusted;
                end
            end
        end


        function self = setRatesAltered(self, primary, typeAltered)
            if ~isempty(typeAltered)
                indAltered = find(strcmp(self.hazardNames, typeAltered));
                for p = indAltered
                    self.hazards{p}.timePrimary = primary.time;
                    self.hazards{p}.severityPrimary = primary.severity;

                    self.hazards{p} = ...
                        self.hazards{p}.update(self.currentTime);
                    self.rateEventPool(p) = ...
                        self.hazards{p}.rateAdjusted;

                    indNull = self.hazards{p}.indNullEvent;
                    self.rateEventPool(indNull) = 0; % is this needed?
                end
            end
        end


        function triggered = simulateTriggered(self, primary, typeTriggered)
            %TODO add a time dependency of probTriggered (w/ hazard.update)
            triggered = [];
            if ~isempty(typeTriggered)
                k = 0;
                indTriggered = find(strcmp(self.hazardNames, typeTriggered));
                for p = indTriggered                    
                    if rand < self.hazards{p}.checkIfTriggered(primary.severity)
                        k = k + 1;
                        triggered(k).type = p;
                        triggered(k).time = self.currentTime;
                        triggered(k).severity = ...
                            self.hazards{p}.interpolant(...
                            self.hazards{p}.rateAdjusted*(1-rand) );
                    end
                end                
            end
        end


        function plotScenario(self, simToPlot)
            if nargin < 2; simToPlot = randi(numel(self.simulations)); end
            
            scenario = self.simulations(simToPlot).scenario;
            
            for e = numel(scenario) : -1 : 1 %TODO avoid this for loop
                severitiesForPlot(e) = scenario(e).severities(end);
            end

            maxBall = 1000; %TODO improve plot
            figure; hold on
            for p = 1 : numel(self.hazards)
                evToPlot = [scenario.types] == p;
                
                scatter([scenario(evToPlot).times], ...
                    p * ones(1,numel(scenario(evToPlot))), ...
                    maxBall * severitiesForPlot(evToPlot) / ...
                    max(severitiesForPlot(evToPlot)), ...
                    'LineWidth', 1.5)
            end
            xlabel(sprintf('Time [%s]', self.parameters.Analysis.timeUnit))
            yticks(1:numel(self.hazards))
            yticklabels(self.hazardNames)
            set(gca, 'FontSize', 18)
            title(sprintf('Scenario #%d', simToPlot))
        end


        function exportOverallOutputs(self, folderOut)
            overall_results = self.overall;
            save(fullfile(folderOut, ...
                [self.parameters.Analysis.Name '_overall_' date]), "overall_results")
        end


    end

    methods(Access = 'private')

        function self = setAllParameters(self, options)
            % setAllParameters deals with the optional parameters

            % build basic parameters
            macroFieldsPar = {'Analysis', 'Hazards'};

            microFieldsPar{1} = {'hazards', 'timeUnit', 'timeHorizon', 'Nsimulations', 'seedNumber'};
            microFieldsParVals{1} = {struct, 'd', 50, 1000, 'twister'};

            microFieldsPar{2} = {'rubbish', 'garbage'};
            microFieldsParVals{2} = {struct, NaN};

            for F = 1 : numel(macroFieldsPar)
                for f = 1 : numel(microFieldsPar{F})
                    self.parameters.(macroFieldsPar{F}).(microFieldsPar{F}{f}) = microFieldsParVals{F}{f};
                end
            end

            % overwrite fields if some parameter is specified
            macroFieldsOptional = fieldnames(options);
            for OF = 1 : numel(macroFieldsOptional)
                microFieldsOptional = fieldnames(options.(macroFieldsOptional{OF}));
                for of = 1 : numel(microFieldsOptional)
                    if isfield(self.parameters.(macroFieldsOptional{OF}), microFieldsOptional{of}) == 1
                        self.parameters.(macroFieldsOptional{OF}).(microFieldsOptional{of}) = options.(macroFieldsOptional{OF}).(microFieldsOptional{of});
                    else
                        error('Field %s.%s is not allowed', macroFieldsOptional{OF}, microFieldsOptional{of})
                    end
                end
            end

        end

    end

    methods(Static)
        
        function example = runExample(folderResults)

            example = multiHazardScenario(folderResults);

        end

        
        
    end
end