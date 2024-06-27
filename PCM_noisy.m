function [index1,q] = PCM_noisy(y,t)
subplot 611
plot(t,y)
title("Handel Audio in Time Domain");xlabel("Time(s)");ylabel("y(t)");
subplot 612
stem(t,y) %Plotting sampled signal
title("Sampled Version of Handel");ylabel("y(n)");xlabel("n");
Vmax = max(y); %Defining maximum amplitude of the signal
Vmin = -Vmax; %Defining minimum amplitude of the signal
nbits = 16; %Number of bits per sample
L = 2^nbits; %Number of Quantization Level
Vpp = Vmax-Vmin;
stepsize = Vpp/L; %Quantization interval size
quantizationlevels = Vmin:stepsize:Vmax; %Quantization Levels
codebook = Vmin-(stepsize/2):stepsize:Vmax+(stepsize/2); %Quantisation Values - As Final Input of quantiz
[index,quantized] = quantiz(y,quantizationlevels,codebook); %Making quantization process
NonZeroInd = find(index ~= 0);
index(NonZeroInd) = index(NonZeroInd) - 1; %MATLAB indexing from 1 to N. However we need to convert it 0 from N-1
BelowVminInd = find(quantized == Vmin-(stepsize/2));
quantized(BelowVminInd) = Vmin+(stepsize/2);
%This is for correction, as signal values cannot go beyond Vmin
%But quantiz may suggest it, since it return the Values lower than Actual
subplot 613
stem(t,quantized)
title("Quantized Handel Audio Signal");xlabel("Time(s)");ylabel("y(n)");
%Since we performed quantization, we can continue with encoder
TransmittedSignal = de2bi(index,"left-msb");
SerialCode = reshape(TransmittedSignal',[1 size(TransmittedSignal,1)*size(TransmittedSignal,2)]);
subplot 614
grid on;
stairs(SerialCode(1:100));
title("First 100 bit of the PCM Signal");ylim([-2,2]);
%Adding noise
noisy_signal = awgn(SerialCode,10);
noise = SerialCode - noisy_signal;
subplot 615
stairs(noisy_signal(1:100));title("First 100 bit of Noisy Signal");ylim([-2,2]);
%Now we can demodulate our signal
noisy_signal = double(noisy_signal>0.5);
RecievedCode=reshape(noisy_signal,nbits,length(noisy_signal)/nbits);
index1 = bi2de(RecievedCode','left-msb');
q = (stepsize*index1); %Convert into Voltage Values
q = q + (Vmin+(stepsize/2)); % Above step gives a DC shifted version of Actual signal
subplot 616
plot(t,q)
title("Demodulated Signal");ylabel("y(t)");xlabel("Time(s)");
%Calculating SNR and BER
[ber_pcm,ratio_pcm] = biterr(SerialCode,noisy_signal); %Obtaining bit errors and bit error rate with built in biterr function for PCM
fprintf('Bit Error of Pulse Code Modulation: %d\n', ber_pcm);
fprintf('Bit Error Rate (BER) of Pulse Code Modulation: %.2f\n', ratio_pcm*100);
SNR_pcm = snr(SerialCode,noise);
fprintf('Signal to Noise Ratio (SNR) of Pulse Code Modulation: %.2f\n', SNR_pcm);
end