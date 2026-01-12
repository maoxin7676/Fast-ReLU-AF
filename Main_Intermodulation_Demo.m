clc; clear; close all;

%% 1. Parameter Initialization
L1 = 512;               % Filter length
u1 = 0.0005;            % Step size for stability and convergence
numberOfSamples = 40000;
fs = 16000;             % Sampling frequency

%% 2. Signal Generation (Intermodulation Distortion Modeling)
t = (0:numberOfSamples-1)' / fs;
% Input signal x(n): Sum of two sinusoids (500Hz and 800Hz)
x = sin(2*pi*800*t) + sin(2*pi*500*t);

% Desired signal d(n): Modeling intermodulation distortion as x(n)*x(n-1)
% Theoretical frequencies: 0Hz(DC), 300Hz(800-500), 1300Hz(800+500), 1000Hz(2*500), 1600Hz(2*800)
d = [0; x(2:end) .* x(1:end-1)];

%% 3. ReLU-based Adaptive Filtering Process (The Proposed Framework)
X = zeros(L1, 1);       % Input buffer (delay line)
Hs1 = zeros(L1, 1);     % Adaptive filter weights
e = zeros(numberOfSamples, 1);
relu_X_history = zeros(numberOfSamples, 1); 

for i = 1:numberOfSamples
    % Update delay line
    X = [x(i); X(1:end-1)];
    
    % Core Nonlinear Transformation: ReLU(x) = max(0, x)
    X_relu = max(0, X); 
    relu_X_history(i) = X_relu(1); % Record for visualization
    
    % Filtering output
    Y_i = X_relu' * Hs1;
    
    % Error calculation
    e(i) = d(i) - Y_i;
    
    % Weight update (LMS-style)
    Hs1 = Hs1 + 2 * u1 * e(i) * X_relu;
end

%% 4. Power Spectral Density (PSD) Analysis
[Pxx, f] = pwelch(x(30000:end), 1024, 512, 1024, fs);          % Original Input
[Pdd, ~] = pwelch(d(30000:end), 1024, 512, 1024, fs);          % Desired (Distortion)
[Prr, ~] = pwelch(relu_X_history(30000:end), 1024, 512, 1024, fs); % ReLU-transformed
[Pee, ~] = pwelch(e(30000:end), 1024, 512, 1024, fs);          % Residual Error

% Convert to Decibels
Pxx_dB = 10*log10(Pxx);
Pdd_dB = 10*log10(Pdd);
Prr_dB = 10*log10(Prr);
Pee_dB = 10*log10(Pee);

% Unified Y-axis scale for consistent perception
y_lim = [-100 10]; 

%% 5. Plotting Spectrum Analysis (Standard Manual Style)
figure('Color', 'w', 'Name', 'Nonlinear Adaptive Filter Performance Analysis', 'Position', [100 100 800 900]);

% Subplot 1: Original Input Source
subplot(4,1,1);
plot(f, Pxx_dB, 'b', 'LineWidth', 1.2); hold on;
freq_in = [500, 800];
for fi = freq_in
    [~, idx] = min(abs(f - fi));
    plot(f(idx), Pxx_dB(idx), 'ro', 'MarkerSize', 6);
    text(f(idx)+20, Pxx_dB(idx)+5, sprintf('%d Hz', fi), 'Color', 'r', 'FontWeight', 'bold');
end
title('1. Spectrum of Original Input x(n)'); grid on; ylabel('dB/Hz'); xlim([0 2000]); ylim(y_lim);

% Subplot 2: Desired Signal (Distortion Source)
subplot(4,1,2);
plot(f, Pdd_dB, 'k', 'LineWidth', 1.2); hold on;
% Label intermodulation distortion frequencies in d(n)
freq_dist = [0, 300, 1000, 1300, 1600];
for fd = freq_dist
    [~, idx] = min(abs(f - fd));
    plot(f(idx), Pdd_dB(idx), 'bo', 'MarkerSize', 5);
    text(f(idx)+20, Pdd_dB(idx)+5, sprintf('%d Hz', fd), 'Color', 'b', 'FontSize', 9);
end
title('2. Spectrum of Desired Signal d(n) (Target Distortion)'); grid on; ylabel('dB/Hz'); xlim([0 2000]); ylim(y_lim);

% Subplot 3: ReLU-transformed Input (Nonlinear Basis)
subplot(4,1,3);
plot(f, Prr_dB, 'm', 'LineWidth', 1.2);
title('3. Spectrum of ReLU-transformed Input max(0, x(n))'); grid on; ylabel('dB/Hz'); xlim([0 2000]); ylim(y_lim);

% Subplot 4: Residual Error (Performance Evaluation)
subplot(4,1,4);
plot(f, Pee_dB, 'g', 'LineWidth', 1.2);
title('4. Spectrum of Residual Error e(n) (After Cancellation)'); grid on; ylabel('dB/Hz'); 
xlabel('Frequency (Hz)'); xlim([0 2000]); ylim(y_lim);


