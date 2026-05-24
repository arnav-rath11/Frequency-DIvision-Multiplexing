%% =====================================================
%%   FREQUENCY DIVISION MULTIPLEXING (FDM) - MATLAB
%%   Communications Lab
%% =====================================================

clear; clc; close all;

%% ─── PARAMETERS ──────────────────────────────────────
Fs   = 10000;          % Sampling frequency (Hz)
T    = 1;              % Duration (seconds)
t    = 0:1/Fs:T-1/Fs; % Time vector

% Baseband signal frequencies (Hz)
f1 = 50;   % Signal 1
f2 = 120;  % Signal 2
f3 = 200;  % Signal 3

% Carrier frequencies (Hz)
fc1 = 1000;
fc2 = 2000;
fc3 = 3000;

%% ─── STEP 1: GENERATE BASEBAND SIGNALS ───────────────
m1 = sin(2*pi*f1*t);
m2 = sin(2*pi*f2*t) + 0.5*sin(2*pi*(f2*2)*t);
m3 = square(2*pi*f3*t, 50);

%% ─── STEP 2: DSB-SC MODULATION ───────────────────────
s1 = m1 .* cos(2*pi*fc1*t);
s2 = m2 .* cos(2*pi*fc2*t);
s3 = m3 .* cos(2*pi*fc3*t);

%% ─── STEP 3: MULTIPLEX (SUM ALL CHANNELS) ────────────
fdm_signal = s1 + s2 + s3;

%% ─── STEP 4: FREQUENCY DOMAIN ANALYSIS ───────────────
N       = length(fdm_signal);
f       = (-N/2:N/2-1) * (Fs/N);
FDM_FFT = fftshift(fft(fdm_signal)) / N;

%% ─── STEP 5: DEMULTIPLEX WITH BANDPASS FILTERS ───────
BW = 600;   % Bandwidth per channel (Hz)

[b1,a1] = butter(6, [(fc1-BW/2) (fc1+BW/2)] / (Fs/2), 'bandpass');
r1_mod  = filter(b1, a1, fdm_signal);

[b2,a2] = butter(6, [(fc2-BW/2) (fc2+BW/2)] / (Fs/2), 'bandpass');
r2_mod  = filter(b2, a2, fdm_signal);

[b3,a3] = butter(6, [(fc3-BW/2) (fc3+BW/2)] / (Fs/2), 'bandpass');
r3_mod  = filter(b3, a3, fdm_signal);

%% ─── STEP 6: DEMODULATION ────────────────────────────
Wn = 400 / (Fs/2);
[bl, al] = butter(5, Wn, 'low');

r1 = filter(bl, al, 2 * r1_mod .* cos(2*pi*fc1*t));
r2 = filter(bl, al, 2 * r2_mod .* cos(2*pi*fc2*t));
r3 = filter(bl, al, 2 * r3_mod .* cos(2*pi*fc3*t));

%% ─── STEP 7: SNR CALCULATION ─────────────────────────
delay = 150;
snr1 = snr(m1(1:end-delay), m1(1:end-delay) - r1(delay+1:end));
snr2 = snr(m2(1:end-delay), m2(1:end-delay) - r2(delay+1:end));
snr3 = snr(m3(1:end-delay), m3(1:end-delay) - r3(delay+1:end));

fprintf('\n=== FDM Signal Quality ===\n');
fprintf('Channel 1 SNR: %.2f dB\n', snr1);
fprintf('Channel 2 SNR: %.2f dB\n', snr2);
fprintf('Channel 3 SNR: %.2f dB\n', snr3);

%% ─── PLOTTING ────────────────────────────────────────
figure('Name','FDM', 'Position',[100 50 1200 900], 'Color','white');

%% Row 1: Original Baseband Signals
subplot(4,3,1);
plot(t(1:300), m1(1:300), 'b', 'LineWidth',1.5);
title('Signal 1 (50 Hz sine)','FontSize',10);
xlabel('Time (s)'); ylabel('Amplitude');
grid on; ylim([-1.5 1.5]);

subplot(4,3,2);
plot(t(1:300), m2(1:300), 'r', 'LineWidth',1.5);
title('Signal 2 (120 Hz composite)','FontSize',10);
xlabel('Time (s)'); ylabel('Amplitude');
grid on; ylim([-1.5 1.5]);

subplot(4,3,3);
plot(t(1:300), m3(1:300), 'm', 'LineWidth',1.5);
title('Signal 3 (200 Hz square)','FontSize',10);
xlabel('Time (s)'); ylabel('Amplitude');
grid on; ylim([-1.5 1.5]);

%% Row 2: Modulated Signals
subplot(4,3,4);
plot(t(1:200), s1(1:200), 'b', 'LineWidth',1);
title('Modulated Ch1 (fc=1000 Hz)','FontSize',10);
xlabel('Time (s)'); ylabel('Amplitude'); grid on;

subplot(4,3,5);
plot(t(1:200), s2(1:200), 'r', 'LineWidth',1);
title('Modulated Ch2 (fc=2000 Hz)','FontSize',10);
xlabel('Time (s)'); ylabel('Amplitude'); grid on;

subplot(4,3,6);
plot(t(1:200), s3(1:200), 'm', 'LineWidth',1);
title('Modulated Ch3 (fc=3000 Hz)','FontSize',10);
xlabel('Time (s)'); ylabel('Amplitude'); grid on;

%% Row 3: FDM Composite Signal + Spectrum
subplot(4,3,[7 8]);
plot(t(1:500), fdm_signal(1:500), 'k', 'LineWidth',1);
title('FDM Composite Signal (Time Domain)','FontSize',10);
xlabel('Time (s)'); ylabel('Amplitude'); grid on;

subplot(4,3,9);
plot(f, abs(FDM_FFT), 'k', 'LineWidth',1.2);
xlim([0 4000]);
title('FDM Spectrum (Frequency Domain)','FontSize',10);
xlabel('Frequency (Hz)'); ylabel('|X(f)|');
xline(fc1,'b--','Ch1','FontSize',8);
xline(fc2,'r--','Ch2','FontSize',8);
xline(fc3,'m--','Ch3','FontSize',8);
grid on;

%% Row 4: Recovered Signals
subplot(4,3,10);
plot(t(1:300), r1(1:300), 'b', 'LineWidth',1.5);
title(sprintf('Recovered Ch1 | SNR=%.1fdB',snr1),'FontSize',10);
xlabel('Time (s)'); ylabel('Amplitude');
grid on; ylim([-1.5 1.5]);

subplot(4,3,11);
plot(t(1:300), r2(1:300), 'r', 'LineWidth',1.5);
title(sprintf('Recovered Ch2 | SNR=%.1fdB',snr2),'FontSize',10);
xlabel('Time (s)'); ylabel('Amplitude');
grid on; ylim([-1.5 1.5]);

subplot(4,3,12);
plot(t(1:300), r3(1:300), 'm', 'LineWidth',1.5);
title(sprintf('Recovered Ch3 | SNR=%.1fdB',snr3),'FontSize',10);
xlabel('Time (s)'); ylabel('Amplitude');
grid on; ylim([-1.5 1.5]);

sgtitle('Frequency Division Multiplexing (FDM)', ...
        'FontSize',14, 'FontWeight','bold');
