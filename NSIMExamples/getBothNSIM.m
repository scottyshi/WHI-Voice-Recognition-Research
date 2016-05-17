% function [nsimenv, nsimtfs] = getBothNSIM(sound1, sound2)
function [ nsimtfs] = getBothNSIM(sound1, sound2)
path(path,fullfile(pwd,'zc2009model'));

wavfilename=sound1;
wav2=sound2;

% Read in the waveform
[sound1, fs] = audioread(wavfilename);
[sound2, fs2] = audioread(wav2);


%making the audio files the same length
%N = length(sound);
%totaldur = N/fs;
%t = linspace(0,totaldur,N);
%seg1=sound(t>0 & t<0.5); %i want both sound files to contain data from 
                            %200 ms to 700 ms (500ms worth of data)
%N2 = length(sound2);
%totaldur2 = N2/fs2;
%t2 = linspace(0, totaldur2, N2);
%seg2 = sound2(t > 0 & t < 0.5);


%Set up AN Model params
modelparam.ANModel_Fs = 100000;
modelparam.CF = logspace(log10(250),log10(8000),30)'; % 30 CFs ranging between 250 and 8,000 Hz.
modelparam.cohc  = ones(length(modelparam.CF),1);   % normal ohc function
modelparam.cihc  = ones(length(modelparam.CF),1);   % normal ihc function
modelparam.implnt = 0;    % "0" for approximate or "1" for actual implementation of the power-law functions in the Synapse
modelparam.nrep = 50; % number of repetitions for the psth. 


% unimpaired Model
unimpaired_psth = getPSTH(sound1, fs, modelparam);
unimpaired_neurogram = getNeurogram(unimpaired_psth);

psth2 = getPSTH(sound2, fs2, modelparam);
neurogram2 = getNeurogram(psth2);

nsimtfs = nsim_calc(unimpaired_neurogram.tfs, neurogram2.tfs);
% nsimenv = nsim_calc(unimpaired_neurogram.env, neurogram2.env);
%plotNeuro(unimpaired_neurogram.env,unimpaired_neurogram.CF,unimpaired_neurogram.tsp_env);
%plotNeuro(neurogram2.env,neurogram2.CF,neurogram2.tsp_env);
end