classdef mainshock < hazard

    properties

    end

    methods
        function self = mainshock(gutembergRichter)

            self.drivesSuccessive = {'Aftershock'};
            
            self.severityCurve = gutembergRichter;
            self.rate = self.severityCurve(1,2);
            self.rateAdjusted = self.severityCurve(1,2);

            self = self.buildInterpolant;
        end
        
        function self = buildInterpolant(self)
            % interpolant wants X values in ascending order
            severityCurveAscendingFrequencies = ...
                flipud(self.severityCurve);

            self.interpolant = ...
                griddedInterpolant(...
                severityCurveAscendingFrequencies(:,2), ...
                severityCurveAscendingFrequencies(:,1), ...
                'linear', 'none');
        end
    end
end