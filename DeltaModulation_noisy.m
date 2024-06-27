function [dmDecoded,dmEncoded] = DeltaModulation_noisy(t,y)
subplot 511
plot(t,y)
title("Handel Audio in Time Domain");xlabel("Time(s)");ylabel("y(t)");
delta = 0.01;
dmEncoded = zeros(size(y));
previousSample = 0;
for i = 1:length(y)
    if y(i) > previousSample
        dmEncoded(i) = 1;
        previousSample = previousSample + delta;
    else
        dmEncoded(i) = 0;
        previousSample = previousSample - delta;
    end
end
subplot 512
stairs(dmEncoded(1:100));ylim([-2 2]);
title("Dela Modulated Signal");

%Adding noise
noisy_signal = awgn(dmEncoded,10);
noise = dmEncoded - noisy_signal;
subplot 513
stairs(noisy_signal(1:100));title("First 100 bit of Noisy Signal");ylim([-2,2]);

noisy_signal = double(noisy_signal>0.5);

dmDecoded = zeros(size(noisy_signal));
previousSample = 0;

for i = 1:length(noisy_signal)
    if noisy_signal(i) == 1
        previousSample = previousSample + delta;
    else
        previousSample = previousSample - delta;
    end
    dmDecoded(i) = previousSample;
end
subplot 514
plot(t,dmDecoded)
title("Delta Demodulated Signal")

subplot 515
stairs(dmDecoded(1:200),"r")
hold on;
plot(y(1:200), 'b');
hold off;
title('Staircase Approximation vs Original Signal');
%Calculating SNR and BER
[ber_delta,ratio_delta] = biterr(dmEncoded,noisy_signal); %Obtaining bit errors and bit error rate with built in biterr function for PCM
fprintf('Bit Error of Delta Modulation: %d\n', ber_delta);
fprintf('Bit Error Rate (BER) of Delta Modulation: %.2f\n', ratio_delta*100);
SNR_delta = snr(dmEncoded,noise);
fprintf('Signal to Noise Ratio (SNR) of Delta Modulation: %.2f\n', SNR_delta);
end