            function h=plotSpectrogram(sound, Fs)
			WINspec =  round(0.006 * Fs);    % 6ms window
            STEPspec = round(0.001 * Fs);    % 1ms step size
            NFFT = 4096;                     % FFT size
            preemph  = 0.97;                 % preemphasize factor
			maxFreq = 8000;					 % max freq to display
			
			nOverlap = WINspec-STEPspec;
			
			hold all
            % --------------- spectrogram ---------------- %
            [S,F,T] = spectrogram(filter([1 -preemph],1,sound), hamming(WINspec), nOverlap, NFFT, Fs);            
            
            maxFreqBin = round(maxFreq *NFFT/Fs);
            imagesc(T,F(1:maxFreqBin), 20*log(abs(S(1:maxFreqBin,:))));
%             cmap=colormap('gray');
%             colormap(flipud(cmap));
            axis xy
            
            ylim([0 maxFreq])
            ylabel('[Hz]');
            axis tight;
            %--------------------------------------------- %
			end