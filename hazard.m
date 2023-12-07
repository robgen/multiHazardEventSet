classdef hazard

    properties
        name
        rate % this can become a method getRate?
        severityCurve
        isPrimary = true
        drivesTriggered = {}
        drivesAltered = {}
        isTriggered = false
        isAltered = false
        isHomogeneus = true
        rateVStime = []
        isSlowonset = false
        rateNominalZero = 0.0001

        interpolant
        rateAdjusted % this can become a method getRate?
        severityCurveAdjusted = []
        indNullEvent = []
        timePrimary = []
        severityPrimary = []
        
        probTriggeredFormula
        severityThatTriggersFormula
    end

    properties(Access = 'private')

    end

    methods
        function self = hazard()

        end


        function self = buildSeverityInterpolant(self)

        end


        function severity = getSeverity(self)
            rateMin = self.rateAdjusted;
            severity = self.interpolant(rateMin*(1-rand));
        end

    end
end