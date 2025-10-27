% Define the custom physics layer as a function
classdef PhysicsLayer < nnet.layer.Layer
    methods
        function layer = PhysicsLayer(name)
            % Set layer name
            layer.Name = name;
        end
        
        function Z = predict(~, X)
            % PhysicsLayer forward function
            % Apply the physics constraint: T = k * ω
            k = 0.08;
            Z = k * X;
        end
    end
end