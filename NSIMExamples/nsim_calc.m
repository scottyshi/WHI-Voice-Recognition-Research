%% Neurogram Similarity Index Measure
% Neurogram Similarity Index Measure
%
% Implements the NSIM index as published in [1] below. The
% software is written in Matlab code as a Matlab function which takes as
% input i) two Neurograms expressed in the time-frequency domain, ii) a
% sample rate, and iii) a vector containing the centre frequency and
% bandwidth of each frequency bin used for the Neurograms . The Neurograms
% take the form of two input matrices of arbitrary frequency bins and
% duration. The two Neurograms in addition use the same number of frequency
% bins and are of the same duration. The function returns a single index of
% similarity, the NSIM (as above), between the two Neurograms. The software
% also includes two pre-computed Neurogram matrices with known NSIM
% deviation. These matrices are to be used for verifying the output of the
% function. The function does not implement the creation of the Neurograms,
% nor does it perform any phoneme or word level analysis. The function
% also does not take any inputs that change the weights required in the
% calculation of the NSIM. The weights used are as disclosed in [1]
% below. 
%
% Please reference [1] in any publications using NSIM.
%
% NSIM is based on the SSIM measure by Wang and Bovik [2].
% 
% [1] Hines A., Harte N. 2012. Speech intelligibility prediction using a
% Neurogram Similarity Index Measure. Speech Communication, 54(2):306-320. 
% 
% [2] Z. Wang, A. C. Bovik, H. R. Sheikh, and E. P. Simoncelli, "Image
% quality assessment: From error measurement to structural similarity"
% IEEE Transactios on Image Processing, vol. 13, no. 1, Jan. 2004.
%
% (c) Andrew Hines, March 2012. 
% Author: Andrew Hines, March 2012. 
% email: andrew.hines@tcd.ie
%
%%%%%%%%%%%%
%----------------------------------------------------------------------
%Permission to use, copy, or modify this software and its documentation
%for educational and research purposes only and without fee is hereby
%granted, provided that this copyright notice and the original authors'
%names appear on all copies and supporting documentation. This program
%shall not be used, rewritten, or adapted as the basis of a commercial
%software or hardware product without first obtaining permission of the
%authors. The authors make no representations about the suitability of
%this software for any purpose. It is provided "as is" without express
%or implied warranty.
%----------------------------------------------------------------------
%
%
%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% FUNCTION nsim calc
%
% neuro_r Reference neurogram to compare against
% neuro_d Degraded neurogram 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [mNSIM] =nsim_calc(neuro_r, neuro_d)

%set window size for NSIM comparison
window = fspecial('gaussian', [3 3], 0.5);   
window = window/sum(sum(window));
%dynamic range set to max of reference neuro
L=max(max(neuro_r));
%C1 and C2 constants
K=[0.01 0.03];
C1 = (K(1)*L)^2;
C2 = ((K(2)*L)^2)/2;
%Calc mean NSIM(r,d)
neuro_r = double(neuro_r);
neuro_d = double(neuro_d);
mu_r   = filter2(window, neuro_r, 'valid');
mu_d   = filter2(window, neuro_d, 'valid');
mu_r_sq = mu_r.*mu_r;
mu_d_sq = mu_d.*mu_d;
mu_r_mu_d = mu_r.*mu_d;
sigma_r_sq = filter2(window, neuro_r.*neuro_r, 'valid') - mu_r_sq;
sigma_d_sq = filter2(window, neuro_d.*neuro_d, 'valid') - mu_d_sq;
sigma_r_d = filter2(window, neuro_r.*neuro_d, 'valid') - mu_r_mu_d;
sigma_r=sign(sigma_r_sq).*sqrt(abs(sigma_r_sq));
sigma_d=sign(sigma_d_sq).*sqrt(abs(sigma_d_sq));
L_r_d= (2*mu_r.*mu_d+C1) ./(mu_r_sq+mu_d_sq +C1);
S_r_d= (sigma_r_d + C2)./(sigma_r.*sigma_d +C2);
mNSIM =mean(L_r_d(:).*S_r_d(:));

end




