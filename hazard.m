classdef hazard

    properties
        name
        rate
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


        function self = buildSeverityInterpolant(self)

        end

    end
end