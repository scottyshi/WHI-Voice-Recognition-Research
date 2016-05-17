clear 
clc
%I am testing with sound files of 500ms in duration.
%There are 3 different people, each with 9 recordings making a total of
%27 sound files to be compared.
% env = zeros(27,1);
tfs = zeros(45,1);
tokens = cellstr(['token01.wav'; 'token02.wav'; 'token03.wav'; 'token04.wav'; 'token05.wav'; 'token06.wav'; 'token07.wav'; 'token08.wav'; 'token09.wav'; 'token10.wav'; 'token11.wav'; 'token12.wav'; 'token13.wav'; 'token14.wav'; 'token15.wav'; 'token16.wav'; 'token17.wav'; 'token18.wav'; 'token19.wav'; 'token20.wav'; 'token21.wav'; 'token22.wav'; 'token23.wav'; 'token24.wav'; 'token25.wav'; 'token26.wav'; 'token27.wav'; 'token28.wav'; 'token29.wav'; 'token30.wav'; 'token31.wav'; 'token32.wav'; 'token33.wav'; 'token34.wav'; 'token35.wav'; 'token36.wav'; 'token37.wav'; 'token38.wav'; 'token39.wav'; 'token40.wav'; 'token41.wav'; 'token42.wav'; 'token43.wav'; 'token44.wav'; 'token45.wav']);

% filling in the array of NSIM values
% I only want to do 27 at a time (as opposed to all 27*27 computations)
%because I don't keep my computer on for that long at a time
for n=29:45
%     [env(n), tfs(n)] = getBothNSIM('token01.wav', tokens{n});
      [tfs(n)] = getBothNSIM('token29.wav', tokens{n});
end