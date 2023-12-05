classdef aftershock < hazard

    properties

    end

    methods
        function self = aftershock(severityCurve, omoriPar)

            self.isPrimary = false;
            self.isSuccessive = true;
            self.isPoisson = false;
            
            self.severityCurve = severityCurve;
            self.rate = self.severityCurve(1,2);
            self.rateAdjusted = 0;
            self.rateVStime = @(severityPrimary,timeFromPrimary) ...
                ( 10^(omoriPar(1)+omoriPar(2) * ...
                (severityPrimary - omoriPar(5)))-10^omoriPar(1) ) / ...
                ((timeFromPrimary + omoriPar(3))^omoriPar(4));

            self = self.buildInterpolant;
        end

        function self = update(self, currentTime)
            self.rateAdjusted = self.rateVStime(...
                self.severityPrimary, currentTime-self.timePrimary);
            
            if self.rateAdjusted >= self.rateNominalZero
                self = self.limitToMagnitudeMS(self.severityPrimary);
                self = scaleToAdjustedRate(self);
            else
                self.rateAdjusted = 0;
            end

            self = self.buildInterpolant;
        end


        function self = limitToMagnitudeMS(self, magnitudeMS)
            %TODO what happens when there is less than two points in the
            %curve? FIX
            self.severityCurveAdjusted = self.severityCurve(...
               self.severityCurve(:,1) < magnitudeMS, :);
        end


        function self = scaleToAdjustedRate(self)
            self.severityCurveAdjusted(:,2) = self.severityCurveAdjusted(:,2) .* ...
                (self.rateAdjusted/self.severityCurveAdjusted(1,2));
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