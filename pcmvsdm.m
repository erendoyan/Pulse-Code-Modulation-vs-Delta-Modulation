clc;clear;close all;

%Basic Operations with Audio Signal
[y,fs] = audioread("handel_audio.wav"); %Reading Handel audio file
sound(y,fs) %Sounding audio signal
t = (0:length(y)-1)/fs; %Defining time domain
figure('Name','Normal Signal','NumberTitle','off');
subplot 311;
plot(t,y) %Plotting Handel signal in Time Domain
title("Handel Audio in Time Domain");xlabel("Time(s)");ylabel("y(t)");
subplot 312;
l = length(t);
fz = (-l/2 : l/2 -1) * (fs/l); %Defining frequency domain
y_f = fft(y); %Converting time domain signal to frequency domain signal with Fast Fourier Transform
plot(fz,abs(fftshift(y_f))) %Plotting Frequency domain signal
title("Handel Audio in Frequency Domain");xlabel("Frequency(Hz)");ylabel("Y(f)");
subplot 313;
downsamplingfactor = 100; %Defining downsampling factor
sampledIndices = 1:downsamplingfactor:l; %Defining sampled indices
sampledSignal = y(sampledIndices); %Sampling audio signal
sampledTime = t(sampledIndices); %Sampling time
stem(sampledTime,sampledSignal) %Plotting sampled signal
title("Sampled Version of Handel");ylabel("y(n)");xlabel("n");

%Pulse Code Modulation Signal
figure('Name','Pulse Code Modulation Normal','NumberTitle','off');
[index1,q1,SerialCode1] = PCM(y,t); %Calling PCM function

%Delta Modulation
figure('Name','Delta Modulation Normal','NumberTitle','off');
[dmDecoded1,dmEncoded1] = DeltaModulation(t,y); %Calling Delta Modulation function

%Noisy Signal Operation with PCM
figure('Name','Pulse Code Modulation Noisy','NumberTitle','off');
[index2,q2] = PCM_noisy(y,t); %Calling PCM function with noisy signal

%Noisy Signal Operation with Delta Modulation
figure('Name','Delta Modulation Noisy','NumberTitle','off');
[dmDecoded2,dmEncoded2] = DeltaModulation_noisy(t,y); %Calling Delta Modulation function with noisy signal

%MSE Comparison
mse_pcm = immse(y,q2);
mse_dm = immse(y,dmDecoded2);
fprintf('Mean Squarred Error (MSE) of Pulse Code Modulation: %.2f\n', mse_pcm);
fprintf('Mean Squarred Error (MSE) of Pulse Code Modulation: %.2f\n', mse_dm);