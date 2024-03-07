classdef rain < hazard

    properties(Access = 'private')

    end

    methods
        function self = rain(intensityDurationFrequency)

            self.drivesTriggered = {'Landslide'};
            
            self.severityCurve = intensityDurationFrequency;
            self.rate = max(max(self.severityCurve.frequency));
            self.rateAdjusted = self.rate;

            self = self.buildSeverityInterpolant;
        end
        
        function self = buildSeverityInterpolant(self)

            self.interpolant.CDF = ...
                griddedInterpolant(...
                self.severityCurve.ECDFintensity(:,2), ...
                self.severityCurve.ECDFintensity(:,1), ...
                'linear', 'none');
        end


        function severity = getSeverity(self)
            
            intensity = self.interpolant.CDF(rand);
            [durationsGivenIntensity, frequencyDurationGivenIntensity] = ...
                self.getAllDurationsGivenIntensity(intensity);

            duration = self.simulateDuration(...
                durationsGivenIntensity, frequencyDurationGivenIntensity);

            totalWater = intensity*duration;

            severity = [totalWater, intensity, duration];
        end


        function [durations, frequencyDurations] = ...
                getAllDurationsGivenIntensity(self,intensity)
            
            allFrequenciesGivenIntensity = interp2(...
                self.severityCurve.intensity, ...
                self.severityCurve.duration, ...
                self.severityCurve.frequency, ...
                intensity, self.severityCurve.duration);
            
            % Make vector unique
            index1 = find(allFrequenciesGivenIntensity == 0, 1, 'last');
            index2 = find(allFrequenciesGivenIntensity == self.rate, 1, 'first');
            if isempty(index1) == 1
                frequencyDurations = allFrequenciesGivenIntensity(1:index2);
                durations = self.severityCurve.duration(1:index2);
            elseif isempty(index2) == 1
                frequencyDurations = allFrequenciesGivenIntensity(index1:end);
                durations = self.severityCurve.duration(index1:end);
            else
                frequencyDurations = allFrequenciesGivenIntensity(index1:index2);
                durations = self.severityCurve.duration(index1:index2);
            end
            [frequencyDurations,ia] = unique(frequencyDurations);
            durations = durations(ia);
        end


        function duration = simulateDuration(~, ...
                durationsGivenIntensity, frequencyDurationGivenIntensity)

            rateDuration = max(frequencyDurationGivenIntensity)*(1-rand);
            if length(durationsGivenIntensity) == 1
                duration = 2;
            else
                duration = interp1(frequencyDurationGivenIntensity, ...
                    durationsGivenIntensity, rateDuration); % doesn't make sense to build an interpolator
                if isnan(duration)
                    duration = 2;
                end
            end
        end
    end
end