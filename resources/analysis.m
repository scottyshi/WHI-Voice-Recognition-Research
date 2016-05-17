close all
clear all

% --------- piano sound -------------
[piano,Fs] = wavread('piano_A4.wav');
plot_spectrum(piano,Fs,'piano (several periods)',[0.15 0.17]);
plot_spectrum(piano,Fs,'piano (overall)');
% soundsc(piano,Fs);

% --------- violin sound ------------
[violin,Fs] = wavread('violin_A4.wav');
plot_spectrum(violin,Fs,'violin (several periods)',[0.15 0.17]);
plot_spectrum(violin,Fs,'violin (overall)');
% soundsc(violin,Fs);
