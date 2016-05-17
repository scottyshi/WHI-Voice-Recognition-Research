function [neurogram] = getNeurogram(psth)

%% Neurogram Creation using PSTH from AN Model

% PSTH and MODEL parameters
ANModel_Fs = psth.modelparam.ANModel_Fs; % must be 100e3 Hz or above
CF = psth.modelparam.CF; % 30 CFs ranging between 250 and 8,000 Hz.
nrep= psth.modelparam.nrep;
psth100k_bf=psth.psth100k_bf;
timeout = (1:length(psth100k_bf))*1/ANModel_Fs;

%ENV neurogram parameters
psthbinwidth_env = 100e-6;
env_windowsize=128;
env_overlap=64;
psthbins_env = round(psthbinwidth_env*ANModel_Fs);  % number of psth100k bins per psth bin
psthtime_env = timeout(1:psthbins_env:end); % time vector for psth

w_env = hamming(env_windowsize,'periodic');

%TFS neurogram parameters
psthbinwidth_tfs = 10e-6;
tfs_windowsize=32;
tfs_overlap=16;
psthbins_tfs = round(psthbinwidth_tfs*ANModel_Fs);  % number of psth100k bins per psth bin
psthtime_tfs = timeout(1:psthbins_tfs:end); % time vector for psth

w_tfs = hamming(tfs_windowsize,'periodic');

for s = 1:length(CF)
    
    % compute ENV neurogram 
    psth100k_env = psth100k_bf(s,1:psthbins_env*floor(length(psth100k_bf(s,:))/psthbins_env));
    pr_env = sum(reshape(psth100k_env,psthbins_env,length(psth100k_env)/psthbins_env))/nrep; % pr of spike in each bin
    psth_env = pr_env/psthbinwidth_env; % psth in units of spikes/s
    
    [b_sp_env f tsp_env]= spectrogram(psth_env,w_env,env_overlap,env_windowsize,1/psthbinwidth_env);
    synrate_env = abs(b_sp_env/env_windowsize/sqrt(sum(w_env.^2)/length(w_env)));
    cf_env_neurogram = synrate_env(1,:); % get the dc value which is 
    env_neurogram(s,:)=cf_env_neurogram;   
    
    % compute TFS neurogram 
    psth100k_tfs = psth100k_bf(s,1:psthbins_tfs*floor(length(psth100k_bf)/psthbins_tfs));
                    
    if(psthbins_tfs>1)
        pr_tfs = sum(reshape(psth100k_tfs,psthbins_tfs,length(psth100k_tfs)/psthbins_tfs))/nrep; % pr of spike in each bin
    else
        % summation not sensitive to direction; if binwidth == 1
        pr_tfs = psth100k_tfs/nrep;
    end
    psth_tfs = pr_tfs/psthbinwidth_tfs; % psth in units of spikes/s
    
    
    [b_sp_tfs, f, tsp_tfs] = spectrogram(psth_tfs,w_tfs,tfs_overlap,tfs_windowsize,1/psthbinwidth_tfs);
    synrate_tfs = abs(b_sp_tfs/tfs_windowsize/sqrt(sum(w_env.^2)/length(w_tfs)));
    cf_tfs_neurogram = synrate_tfs(1,:); % get the dc value which is 
    tfs_neurogram(s,:)=cf_tfs_neurogram;    
    
end


neurogram.env=env_neurogram;
neurogram.tsp_env=tsp_env;
neurogram.tfs=tfs_neurogram;
neurogram.tsp_tfs=tsp_tfs;
neurogram.CF=CF;

