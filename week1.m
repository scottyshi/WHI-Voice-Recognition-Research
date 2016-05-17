close all
clear all

%THIS SECTION GRABS THE 20ms PORTION OF THE SOUND
[female, fs] = audioread('35B_vowels_2_AA.wav');
%fs is the sampling rate of the audio file
%female holds the sample data
N = length(female);
totaldur = N/fs;
t = linspace(0,totaldur,N);
%creating a time vector
segment=female(t>1.0 & t<1.02);
%grabbing 20 milliseconds of data
%plot(segment);

%to get the hamming window, simply multiply the window length by the 
%sampling frequency
%I used the hamming function to create a hamming window
%i needed to use .* to do elementwise multiplication (instead of matrix)
hamseg = segment .* hamming(fs * 0.02);
%using hamming window
plot_spectrum(hamseg, fs,'original segment plot',[0, 0.02]);

%using rectangular window
plot_spectrum(segment, fs,'original segment plot',[0, 0.02]);
%fourth argument is the time relative to segment

soundsc(segment, fs);