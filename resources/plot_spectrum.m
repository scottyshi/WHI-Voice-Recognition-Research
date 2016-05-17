function plot_spectrum(x, Fs, TITLE, tRange)

if nargin<4
    AUTO_T_RANGE = 1;
    
    if nargin<3
        TITLE = [];
    end
else 
    AUTO_T_RANGE = 0;
end

%-------- fourier transform -------
X = fftshift(20*log10(abs(fft(x))));

%-------------- plot --------------
tt = (1:length(x)).'/Fs;
halfLen = round(length(X)/2);
ff= [halfLen-length(X)+1:1:halfLen]*Fs/length(X)/1000;

figure
h(1) = subplot(2,1,1);
plot(tt,x);
if AUTO_T_RANGE
    xlim([0 tt(end)])
else
    xlim(tRange);
end
xlabel('[sec]')
ylabel('time domain signal')
title(TITLE);

h(2) = subplot(2,1,2);
plot(ff, X);
xlim([0 Fs/2/1000]);
xlabel('[kHz]');
ylabel('magnitude spectrum [dB]')

end


