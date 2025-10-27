function loss = customLoss(y_true, y_pred)
    mse_loss = mean((y_true - y_pred{1}).^2); % MSE loss for torque estimation
    physics_loss = mean((y_pred{1} - y_pred{2}).^2); % Physics-based loss
    total_loss = mse_loss + 0.01 * physics_loss; % Adjust weights as needed
    loss = total_loss;
end