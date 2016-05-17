%
% main_example_create_neurograms.m
%
% This script will use the Zilany et al. AN Model to create PSTH outputs
% for 30 CFs using a sample speech input stimulus.
%
% It will then create ENV and TFS neurograms from the PSTH.
%
% The plots show the signal and the output neurograms.
%
% Fig 1: ENV neurograms
% Fig 2: TFS neurograms
%
% The figures also show an example of calculating NSIM similarity between
% phonemes using neurograms
%
% Details on NSIM calcuation can be found in:
% [1] Hines A., Harte N. 2012. Speech intelligibility prediction using a
% Neurogram Similarity Index Measure. Speech Communication, 54(2):306-320.
%
%
% (c) Andrew Hines, May 2013. 
% Author: Andrew Hines
% email: andrew.hines@tcd.ie
%
clear
clc
path(path,fullfile(pwd,'zc2009model'));
wavfilename='qt010175.wav';
%% Read in the waveform
[s, fs] = audioread(wavfilename);
%load the neurograms
load neuro.mat

%%
% get the phoneme timings and calculate the NSIM per phoneme
phoneInfo= getPhoneInfo(wavfilename);

phoneStart=double(phoneInfo{1})/fs;
phoneEnd=double(phoneInfo{2})/fs;

nsim_mild_env_phone=zeros(5,1);
nsim_mild_tfs_phone=zeros(5,1);
nsim_moderate_env_phone=zeros(5,1);
nsim_moderate_tfs_phone=zeros(5,1);
for phoneidx=2:4
    t1=phoneStart(phoneidx);
    t2=phoneEnd(phoneidx);
    t1_env=find(unimpaired_neurogram.tsp_env>=t1,1,'first');
    t2_env=find(unimpaired_neurogram.tsp_env>=t2,1,'first');
    t1_tfs=find(unimpaired_neurogram.tsp_tfs>=t1,1,'first');
    t2_tfs=find(unimpaired_neurogram.tsp_tfs>=t2,1,'first');  
    
    nsim_mild_env_phone(phoneidx)=nsim_calc(unimpaired_neurogram.env(:,t1_env:t2_env), mild_neurogram.env(:,t1_env:t2_env));
    nsim_mild_tfs_phone(phoneidx)=nsim_calc(unimpaired_neurogram.tfs(:,t1_tfs:t2_tfs), mild_neurogram.tfs(:,t1_tfs:t2_tfs));    
    
    nsim_moderate_env_phone(phoneidx)=nsim_calc(unimpaired_neurogram.env(:,t1_env:t2_env), moderate_neurogram.env(:,t1_env:t2_env));
    nsim_moderate_tfs_phone(phoneidx)=nsim_calc(unimpaired_neurogram.tfs(:,t1_tfs:t2_tfs), moderate_neurogram.tfs(:,t1_tfs:t2_tfs));       
end
    

%%
%Plot the signal followed by 3 ENV neurograms for the signal with simulated
% hearing losses: none (unimpaired), mild and moderate.
% The white lines show the phoneme boundaries and the numbers are the NSIM
% scores calculated between the unimpaired and degraded phoneme neurogram
%loss

figure
subplot 411
plot((0:length(s)-1)/fs,s,'k');
xlim([0 unimpaired_neurogram.tsp_env(end)]);
for phoneidx=2:4
    line([phoneStart(phoneidx) phoneStart(phoneidx)],[-.1 .1],'color','red','linewidth',2);
    line([phoneEnd(phoneidx) phoneEnd(phoneidx)],[-.1 .1],'color','red','linewidth',2);
end

title('Signal: "Ship" ');
subplot 412
range_env=plotNeuro(unimpaired_neurogram.env,unimpaired_neurogram.CF,unimpaired_neurogram.tsp_env);
for phoneidx=2:4
    line([phoneStart(phoneidx) phoneStart(phoneidx)],[0 30],'color','white','linewidth',2);
    line([phoneEnd(phoneidx) phoneEnd(phoneidx)],[0 30],'color','white','linewidth',2);
end

title('Unimpaired');
subplot 413

plotNeuro(mild_neurogram.env,mild_neurogram.CF,mild_neurogram.tsp_env,range_env);
for phoneidx=2:4
    text(phoneStart(phoneidx)+(phoneEnd(phoneidx)-phoneStart(phoneidx))/2,3,num2str(nsim_mild_env_phone(phoneidx),3),'color','white','fontsize',10);
    line([phoneStart(phoneidx) phoneStart(phoneidx)],[0 30],'color','white','linewidth',2);
    line([phoneEnd(phoneidx) phoneEnd(phoneidx)],[0 30],'color','white','linewidth',2);
end
title('Mild');

subplot 414
plotNeuro(moderate_neurogram.env,moderate_neurogram.CF,moderate_neurogram.tsp_env,range_env);
for phoneidx=2:4
    text(phoneStart(phoneidx)+(phoneEnd(phoneidx)-phoneStart(phoneidx))/2,3,num2str(nsim_moderate_env_phone(phoneidx),3),'color','white','fontsize',10);
    line([phoneStart(phoneidx) phoneStart(phoneidx)],[0 30],'color','white','linewidth',2);
    line([phoneEnd(phoneidx) phoneEnd(phoneidx)],[0 30],'color','white','linewidth',2);
end
title('Moderate');

% set(gcf,'PaperOrientation', 'landscape')
% print('-dpdf','nsim_envexample.pdf')
%%
figure
subplot 411
plot((0:length(s)-1)/fs,s,'k');
xlim([0 unimpaired_neurogram.tsp_tfs(end)]);
for phoneidx=2:4
    line([phoneStart(phoneidx) phoneStart(phoneidx)],[-.1 .1],'color','red','linewidth',2);
    line([phoneEnd(phoneidx) phoneEnd(phoneidx)],[-.1 .1],'color','red','linewidth',2);
end

title('Signal: "Ship" ');

subplot 412
range_tfs=plotNeuro(unimpaired_neurogram.tfs,unimpaired_neurogram.CF,unimpaired_neurogram.tsp_tfs);
for phoneidx=2:4
    line([phoneStart(phoneidx) phoneStart(phoneidx)],[0 30],'color','white','linewidth',2);
    line([phoneEnd(phoneidx) phoneEnd(phoneidx)],[0 30],'color','white','linewidth',2);
end
title('Unimpaired')


subplot 413
plotNeuro(mild_neurogram.tfs,mild_neurogram.CF,mild_neurogram.tsp_tfs,range_tfs);
for phoneidx=2:4
    text(phoneStart(phoneidx)+(phoneEnd(phoneidx)-phoneStart(phoneidx))/2,3,num2str(nsim_mild_tfs_phone(phoneidx),3),'color','white','fontsize',10);
    line([phoneStart(phoneidx) phoneStart(phoneidx)],[0 30],'color','white','linewidth',2);
    line([phoneEnd(phoneidx) phoneEnd(phoneidx)],[0 30],'color','white','linewidth',2);
end
title('Mild')

subplot 414
plotNeuro(moderate_neurogram.tfs,moderate_neurogram.CF,moderate_neurogram.tsp_tfs,range_tfs);
for phoneidx=2:4
    text(phoneStart(phoneidx)+(phoneEnd(phoneidx)-phoneStart(phoneidx))/2,3,num2str(nsim_moderate_tfs_phone(phoneidx),3),'color','white','fontsize',10);
    line([phoneStart(phoneidx) phoneStart(phoneidx)],[0 30],'color','white','linewidth',2);
    line([phoneEnd(phoneidx) phoneEnd(phoneidx)],[0 30],'color','white','linewidth',2);
end
title('Moderate')

% set(gcf,'PaperOrientation', 'landscape')
% print('-dpdf','nsim_tfsexample.pdf')
%%
% 
 
 
 figure
subplot 411
plot((0:length(s)-1)/fs,s,'k');
xlim([.1 .95]);
title('Signal: "Ship" ');

subplot 412
plotNeuro(unimpaired_neurogram.env,unimpaired_neurogram.CF,unimpaired_neurogram.tsp_env);
xlim([.1 .95]);

title('ENV Neurogram');

subplot 413
plotNeuro(unimpaired_neurogram.tfs,unimpaired_neurogram.CF,unimpaired_neurogram.tsp_tfs);

title('TFS Neurogram (/ih/)');
xlim([phoneStart(3) phoneEnd(3)]); %zoom to show TFS detatil, only plot the vowel

subplot 414
plotNeuro(unimpaired_neurogram.tfs,unimpaired_neurogram.CF,unimpaired_neurogram.tsp_tfs);

title('TFS Neurogram (/p/)');
xlim([phoneStart(4) phoneEnd(4)]); %zoom to show TFS detatil, only plot the plosive

% set(gcf,'PaperOrientation', 'landscape')
% print('-dpdf','neurogram_examples.pdf')

