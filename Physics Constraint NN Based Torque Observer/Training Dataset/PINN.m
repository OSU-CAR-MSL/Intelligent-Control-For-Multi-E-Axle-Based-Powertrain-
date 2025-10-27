speed =load('speed_SMC.mat', 'speed_sm');
true_torque = 0.08*speed.speed_sm;
rng(0); % Set the random seed for reproducibility
% Define the PINN model
inputLayer = imageInputLayer([1, 1], 'Name', 'input_layer'); % Motor speed as input
physicsLayer = PhysicsLayer('physics_layer'); % Physics layer enforces the constraint
fullyConnectedLayer = fullyConnectedLayer(8, 'Name', 'fully_connected', 'WeightLearnRateFactor', 1, 'BiasLearnRateFactor', 1);
outputLayer = regressionLayer('Name', 'output_layer');

layers = [
    inputLayer
    physicsLayer
    fullyConnectedLayer
    outputLayer
];

pinnNet = trainNetwork(speed_sm', [true_torque'; true_torque'], layers);

% Compile the PINN model with the custom loss function
options = trainingOptions('adam', ...
    'MaxEpochs', 1000, ...
    'MiniBatchSize', 32, ...
    'Verbose', false);

% Train the PINN model
X_train = speed;
y_train = true_torque;
pinnNet = trainNetwork(speed', [true_torque'; true_torque'], layers, options);
% Predict torque for new speed values
speed_values = linspace(0, 10, 100);
predicted_torque = predict(pinnNet, speed_values')';
% Plot the results
figure;
scatter(speed, true_torque, 'DisplayName', 'True Torque');
hold on;
plot(speed_values, predicted_torque, 'r', 'LineWidth', 2, 'DisplayName', 'Predicted Torque');
xlabel('Motor Speed (ω)');
ylabel('Torque (T)');
legend('show');
grid on;
title('PINN for Torque Observer');