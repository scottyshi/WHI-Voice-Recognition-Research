%
% main_example_create_neurograms.m
%
% This script will use the Zilany et al. AN Model to create PSTH outputs
% for 30 CFs using a sample speech input stimulus.
%
% It will then create ENV and TFS neurograms from the PSTH.
%
% Three examples neurogram sets are created, first for an unimpaired model
% (i.e. normal hearing) and then for simulations of a mild and moderate 
% hearing losss.
%
% This script will create neuro.mat which contains the neurograms used by
% the main_example_viewresults.m script.
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

%Set up AN Model params
modelparam.ANModel_Fs = 100000;
modelparam.CF = logspace(log10(250),log10(8000),30)'; % 30 CFs ranging between 250 and 8,000 Hz.
modelparam.cohc  = ones(length(modelparam.CF),1);   % normal ohc function
modelparam.cihc  = ones(length(modelparam.CF),1);   % normal ihc function
modelparam.implnt = 0;    % "0" for approximate or "1" for actual implementation of the power-law functions in the Synapse
modelparam.nrep = 50; % number of repetitions for the psth. 


%%
% unimpaired Model

unimpaired_psth = getPSTH(s, fs, modelparam);
unimpaired_neurogram = getNeurogram(unimpaired_psth);



%% mild_gentle audiogram
%define the hearing loss thresholds for a mild, gentle sloped audiogram
f_mg  =     [250 500 1000 2000 3000 4000 6000 10000];       
dBLoss_mg = [20	 20	 30	  40   45	50   50 50];
thresh = interp1(f_mg, dBLoss_mg, modelparam.CF, 'cubic');
[cohc,cihc]=fitaudiogram(modelparam.CF,thresh);

modelparam.cohc  = cohc;   % mild loss, gentle slope audiogram ohc function
modelparam.cihc  = cihc;   % mild loss, gentle slope audiogram ihc function


mild_psth = getPSTH(s, fs, modelparam);
mild_neurogram = getNeurogram(mild_psth);


%%
% moderate_steep
%define the hearing loss thresholds for a moderate, steep sloped audiogram
f_ms= [250	500	1000	1500	2000	3000	4000	6000 10000];      
dBLoss_ms = [25	30	55	65	80	85	90	90 90];
thresh = interp1(f_ms, dBLoss_ms, modelparam.CF, 'cubic');
[cohc,cihc]=fitaudiogram(modelparam.CF,thresh);

modelparam.cohc  = cohc; % moderate loss, steep slope audiogram ohc function
modelparam.cihc  = cihc; % moderate loss, steep slope audiogram ihc function

moderate_psth = getPSTH(s, fs, modelparam);
moderate_neurogram = getNeurogram(moderate_psth);

save neuro.mat  unimpaired_psth unimpaired_neurogram mild_psth mild_neurogram moderate_psth moderate_neurogram  
%%
