function [index1,q,SerialCode] = PCM(y,t)
subplot 511
plot(t,y)
title("Handel Audio in Time Domain");xlabel("Time(s)");ylabel("y(t)");
subplot 512
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
subplot 513
stem(t,quantized)
title("Quantized Handel Audio Signal");xlabel("Time(s)");ylabel("y(n)");
%Since we performed quantization, we can continue with encoder
TransmittedSignal = de2bi(index,"left-msb");
SerialCode = reshape(TransmittedSignal',[1 size(TransmittedSignal,1)*size(TransmittedSignal,2)]);
subplot 514
grid on;
stairs(SerialCode(1:100));
title("First 100 bit of the PCM Signal");ylim([-2,2]);
%Now we can demodulate our signal
RecievedCode=reshape(SerialCode,nbits,length(SerialCode)/nbits);
index1 = bi2de(RecievedCode','left-msb');
q = (stepsize*index1); %Convert into Voltage Values
q = q + (Vmin+(stepsize/2)); % Above step gives a DC shifted version of Actual signal
subplot 515
plot(t,q)
title("Demodulated Signal");ylabel("y(t)");xlabel("Time(s)");
end