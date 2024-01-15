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


        function severity = getSeverity(self)
            severity = self.interpolant(...
                self.rateAdjusted*(1-rand));
        end

    end
end