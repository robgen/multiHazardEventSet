classdef landslideFromEQ < hazard

    properties

    end

    methods
        function self = landslideFromEQ(probTrigParam, severityTriggeringParam)
            
            self.isPrimary = false;
            self.isTriggered = true;

            self.probTriggered = @(PGA) 1 / ...
                (1 + exp(-(-7.0207 + 10.9946*PGA + 0.099*probTrigParam(1) + 1.114*probTrigParam(2))));

            R = severityTriggeringParam(1); % GMPEparam
            self.severityThatTriggers = @(Mw) ... % GMPE
                0.0159*exp(0.868*Mw)*(R + 0.0606*exp(0.70*Mw))^(-1.09);
            
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
    end
end