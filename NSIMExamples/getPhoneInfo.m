function [ phoneInfo ] = getPhoneInfo( wav_filename )
      
          %find the filename from the wav file
          [pathstr, name] = fileparts(wav_filename);
          %get a handle to the .phn file corresponding to the TIMIT wav
          %file
          fid =fopen(fullfile(pathstr,[name '.phn']),'r');
          %read in the data, which is in the format <int> <int> <string>\n
          %and put it in an array called rawPhoneInfo
          phoneInfo = textscan(fid, '%d %d %s');
          fclose(fid);

          %phoneInfo{1} indices of start of phones
          %phoneInfo{2} indices of end of phones
          %phoneInfo{3} text of phone e.g. t, h#




end

