function [dmDecoded,dmEncoded] = DeltaModulation(t,y)
subplot 411
plot(t,y)
title("Handel Audio in Time Domain");xlabel("Time(s)");ylabel("y(t)");
delta = 0.01; %Defining stepsize
dmEncoded = zeros(size(y)); %Creating encoded signal variable with size actual signal
previousSample = 0; %Defining previous sample as 0
%Creating the encoder
%For loop compares the actual value of signal and previous sample.
%If actual signal is bigger, it increases signal by stepsize
%If actual signal is less, it decreases signal by stepsize
for i = 1:length(y)
    if y(i) > previousSample
        dmEncoded(i) = 1;
        previousSample = previousSample + delta;
    else
        dmEncoded(i) = 0;
        previousSample = previousSample - delta;
    end
end
subplot 412
stairs(dmEncoded(1:100));ylim([-2 2]); %Plotting encoded signal
title("Dela Modulated Signal"); 


dmDecoded = zeros(size(dmEncoded)); %Defining decoded signal variable with size Encoded signal
previousSample = 0; %Defining previous sample 0 again

%Creating Decoder
%If encoded signal is 1, decoded signal is increased by delta
%If encoded signal is 0, decoded signal is decreased by delta
for i = 1:length(dmEncoded)
    if dmEncoded(i) == 1
        previousSample = previousSample + delta;
    else
        previousSample = previousSample - delta;
    end
    dmDecoded(i) = previousSample;
end
subplot 413
plot(t,dmDecoded) %Plotting decoded signal
title("Delta Demodulated Signal")

%Plotting decoded signal vs staircase approximation
subplot 414
stairs(dmDecoded(1:200),"r")
hold on;
plot(y(1:200), 'b');
hold off;
title('Staircase Approximation vs Original Signal');
end