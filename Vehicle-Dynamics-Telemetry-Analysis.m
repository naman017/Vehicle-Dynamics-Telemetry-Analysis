% =========================================================================
% Project: Vehicle Dynamics & Cornering Performance Analysis
% Goal: Generate a Traction Circle (G-G Diagram) from telemetry data.
% =========================================================================

clear; clc; close all;

%% STEP 1: Generate Synthetic Telemetry Data
% Simulating 60 seconds of a lap with acceleration, braking, and cornering
time = 0:0.02:60; % 50Hz data logging rate
g = 9.81; % Acceleration due to gravity (m/s^2)

% Simulate speed (m/s) with realistic race car variations
% Base speed + sine wave for corners + random noise for sensor vibration
speed = 40 + 20*sin(2*pi*time/15) + 1.5*randn(size(time)); 

% Simulate yaw rate (rad/s) peaking when speed is lowest (mid-corner)
yaw_rate = 0.6*cos(2*pi*time/15) + 0.08*randn(size(time)); 

%% STEP 2: Signal Processing (Noise Filtering)
% Raw telemetry is unusable without filtering. Applying a moving average.
window_size = 15; % 15 samples smoothing window
smooth_speed = movmean(speed, window_size);
smooth_yaw = movmean(yaw_rate, window_size);

%% STEP 3: Vehicle Dynamics Calculations
% Calculate delta time for differentiation
dt = gradient(time);

% 1. Longitudinal Acceleration (Ax) = dv/dt
ax_ms2 = gradient(smooth_speed) ./ dt;
ax_g = ax_ms2 / g;

% 2. Lateral Acceleration (Ay) = V * YawRate
ay_ms2 = smooth_speed .* smooth_yaw;
ay_g = ay_ms2 / g; % This MUST be here before Step 4
%% STEP 4: Data Visualization (The G-G Diagram)
figure('Name', 'Vehicle Traction Circle Analysis', 'Position', [100, 100, 800, 700]);

% Create scatter plot colored by vehicle speed
% This shows *where* the grip is happening (Aero vs Mechanical)
scatter(ay_g, ax_g, 15, smooth_speed * 3.6, 'filled'); % Speed converted to km/h for colorbar
colormap(turbo); % High-contrast color map
c = colorbar;
c.Label.String = 'Vehicle Speed (km/h)';

hold on;

% Draw a theoretical friction ellipse limit (e.g., 1.5G mechanical limit)
theta = linspace(0, 2*pi, 100);
limit_g = 1.5; 
plot(limit_g * cos(theta), limit_g * sin(theta), 'r--', 'LineWidth', 2);

% Formatting the plot for professional presentation
title('Vehicle Traction Circle (G-G Diagram)', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('Lateral Acceleration (G)', 'FontSize', 12);
ylabel('Longitudinal Acceleration (G)', 'FontSize', 12);

% Set axes limits to be symmetrical
axis([-2.5 2.5 -2.5 2.5]);
grid on;
axis square; % Crucial: Ensures the circle looks like a circle, not an oval
xline(0, 'k-', 'LineWidth', 1); % Y-axis line
yline(0, 'k-', 'LineWidth', 1); % X-axis line

% Add textual insights based on data spread
text(1.2, 2.0, 'Accel Limit', 'Color', 'black', 'FontSize', 10);
text(1.2, -2.0, 'Brake Limit', 'Color', 'black', 'FontSize', 10);

hold off;
%% STEP 5: Generate the Track Map
% To draw the track, we must calculate the car's X and Y coordinates.
% We do this by integrating the Yaw Rate to get the Heading Angle, 
% and then integrating Speed to get distance traveled in X and Y directions.

% 1. Calculate Heading Angle (Integration of Yaw Rate)
% cumtrapz is MATLAB's cumulative trapezoidal numerical integration function
heading_angle = cumtrapz(time, smooth_yaw); 

% 2. Calculate X and Y coordinates (Integration of Velocity)
% X = velocity * cos(heading), Y = velocity * sin(heading)
X_pos = cumtrapz(time, smooth_speed .* cos(heading_angle));
Y_pos = cumtrapz(time, smooth_speed .* sin(heading_angle));

% 3. Visualize the Track Map color-coded by Braking/Acceleration
figure('Name', 'Track Map Analysis', 'Position', [920, 100, 800, 700]);

% Scatter plot where the color is determined by Longitudinal G (ax_g)
scatter(X_pos, Y_pos, 20, ax_g, 'filled');

% Customizing the color map: Red/Yellow/Blue is great for Accel/Coast/Brake
colormap(turbo); 
c2 = colorbar;
c2.Label.String = 'Longitudinal G (Accel/Brake)';

title('Track Map: Braking and Acceleration Zones', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('X Position (meters)', 'FontSize', 12);
ylabel('Y Position (meters)', 'FontSize', 12);

% axis equal is CRITICAL. Without it, your corners will look stretched!
axis equal; 
grid on;