classdef landslideFromRain < hazard

    properties

    end

    methods
        function self = landslideFromRain()
            self.isPrimary = false;
            self.isTriggered = true;
            
            self.severityThatTriggersFormula = @(severity)severity(3); 

            self.rateAdjusted = 1;

            self = self.buildSeverityInterpolant;
        end


        function self = buildSeverityInterpolant(self)
            % interpolant that always gives severity = I
            I = 3;
            self.interpolant = ...
                griddedInterpolant(...
                [0 1], I*[1 1], ...
                'linear', 'none');
        end


        function isTriggered = checkIfTriggered(self, primarySeverity)
            
            duration = self.severityThatTriggersFormula(primarySeverity);

            criticalDuration = ... % Liu and Wang, 2022
                9.00*1000*duration^(-2.149) + 1.61;

            if duration > criticalDuration
                isTriggered = true;
            else
                isTriggered = false;
            end
        end
    end
end