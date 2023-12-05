classdef hazard

    properties
        name
        rate
        severityCurve
        isPrimary = true
        drivesTriggered = {}
        drivesSuccessive = {}
        isTriggered = false
        isSuccessive = false
        isPoisson = true
        rateVStime = []
        isSlowonset = false
        rateNominalZero = 0.0001

        interpolant
        rateAdjusted
        severityCurveAdjusted = []
        indNullEvent = []
        timePrimary = []
        severityPrimary = []
        
        probTriggered
        severityThatTriggers
    end

    properties(Access = 'private')

    end

    methods
        function self = hazard()

        end


        function self = buildInterpolant(self)

        end

    end
end