function [ psth ] = getPSTH( stim,fs, modelparam )
% This function computes the output of the Zilany's cat model, 2009 version.


%% RESAMPLE the input sound to ANmodel_Fs_Hz

dBSPL_before = 20*log10(sqrt(mean(stim.^2))/(20e-6));
sfreq = fs; % original input sampling rate
sfreqNEW = modelparam.ANModel_Fs; % Model sampling rate
P = round(sfreqNEW/10); Q = round(sfreq/10);  %Integers used to up-sample
if(P/Q*sfreq~=sfreqNEW)
    disp('Note: integer sfreq conversion not exact for wav upsample'); 
end
Nfir=30;  % proportional to FIR filter length used for resampling: higher Nfir, better accuracy & longer comp time

stim_model = resample(stim,P,Q,Nfir);

dBSPL_after = 20*log10(sqrt(mean(stim_model.^2))/(20e-6));

if abs(dBSPL_before-dBSPL_after)>2;
	error(sprintf('RESAMPLING CHANGED stim dB SPL by %f dB',dBSPL_after-dBSPL_before))
end

%% Scale stimuli to correct OALevel_dBSPL
OALevel_dBSPL = 75; % overall stimulus level

stim_model = stim_model*10^((OALevel_dBSPL - dBSPL_after)/20);
stim_model = stim_model';

%% Duration of stimulus for the model & PSTH parameters
T  = length(stim_model) / modelparam.ANModel_Fs;  % duration of stimuli for model

%% Run the Zilany model 

% fiberType: spontaneous rate (in spikes/s) of the fiber BEFORE refractory effects; "1" = Low; "2" = Medium; "3" = High

for s = 1:length(modelparam.CF)
    
    vihc(s,:) = catmodel_IHC(stim_model,modelparam.CF(s),modelparam.nrep,1/modelparam.ANModel_Fs,T+0.05,modelparam.cohc(s),modelparam.cihc(s)); 
%     [synout_high(s,:), psth100k_bf_high(s,:)] = catmodel_Synapse(vihc(s,:),modelparam.CF(s),modelparam.nrep,1/modelparam.ANModel_Fs,3,modelparam.implnt); 
    [~, high1] = catmodel_Synapse(vihc(s,:),modelparam.CF(s),modelparam.nrep,1/modelparam.ANModel_Fs,3,modelparam.implnt); 
    [~, high2] = catmodel_Synapse(vihc(s,:),modelparam.CF(s),modelparam.nrep,1/modelparam.ANModel_Fs,3,modelparam.implnt); 
    [~, high3] = catmodel_Synapse(vihc(s,:),modelparam.CF(s),modelparam.nrep,1/modelparam.ANModel_Fs,3,modelparam.implnt); 
    psth100k_bf_high(s,:) = (high1+high2+high3)/3;
%  [synout_medium(s,:), psth100k_bf_medium(s,:)] = catmodel_Synapse(vihc(s,:),modelparam.CF(s),modelparam.nrep,1/modelparam.ANModel_Fs,2,modelparam.implnt); 
    [~, mid1] = catmodel_Synapse(vihc(s,:),modelparam.CF(s),modelparam.nrep,1/modelparam.ANModel_Fs,2,modelparam.implnt); 
    [~, mid2] = catmodel_Synapse(vihc(s,:),modelparam.CF(s),modelparam.nrep,1/modelparam.ANModel_Fs,2,modelparam.implnt); 
    [~, mid3] = catmodel_Synapse(vihc(s,:),modelparam.CF(s),modelparam.nrep,1/modelparam.ANModel_Fs,2,modelparam.implnt); 
    psth100k_bf_medium(s,:) = (mid1+mid2+mid3)/3;
%  [synout_low(s,:), psth100k_bf_low(s,:)] = catmodel_Synapse(vihc(s,:),modelparam.CF(s),modelparam.nrep,1/modelparam.ANModel_Fs,1,modelparam.implnt); 
    [~, low1] = catmodel_Synapse(vihc(s,:),modelparam.CF(s),modelparam.nrep,1/modelparam.ANModel_Fs,1,modelparam.implnt); 
    [~, low2] = catmodel_Synapse(vihc(s,:),modelparam.CF(s),modelparam.nrep,1/modelparam.ANModel_Fs,1,modelparam.implnt); 
    [~, low3] = catmodel_Synapse(vihc(s,:),modelparam.CF(s),modelparam.nrep,1/modelparam.ANModel_Fs,1,modelparam.implnt); 
    psth100k_bf_low(s,:) = (low1+low2+low3)/3;
end

psth.psth100k_bf = 0.6*psth100k_bf_high + 0.2*psth100k_bf_medium + 0.2*psth100k_bf_low; %weighted matrix containing psth of high/med/low rates
psth.modelparam=modelparam;
end

