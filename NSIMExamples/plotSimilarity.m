
% copy your similarity matrix into a variable "simMatOrig"
% change the "soundDir" to where your sound files are
% then run!
% feel free to adjust it
%C:\Users\Scott S\Desktop\WHI Voice Recognition Research\FEMALE_AA_SET21_mid
soundDir = 'C:\Users\Scott S\Desktop\WHI Voice Recognition Research\FEMALE_AA_SET21_mid\';
orderFile = 'permFile.txt';

fid_r = fopen([soundDir orderFile], 'r');
tmp = textscan(fid_r, '%s %s %s');
fclose(fid_r);

numFiles = length(tmp{3});

% --- get permutation indices
permIdx = NaN*ones(numFiles,1);
for i=1:numFiles
    string = tmp{3}{i};
    permIdx(i) = str2double(string(end-1:end));
end

% --- sort into similarity matrix
simMat = NaN*ones(numFiles, numFiles);
for i=1:numFiles
    for j=1:numFiles
        simMat(i,j)=simMatOrig(permIdx(i), permIdx(j));        
    end
end

% ----- plot -----
fig=figure;

h=imagesc(1:numFiles, 1:numFiles, simMat);
axis ij
axis equal
axis tight

set(h,'AlphaData',double(~(simMat==0)));
colorbar

colormap cool
grid on

set(gca,'xtick',[9.5 18.5 27.5],'ytick',[9.5 18.5 27.5])
set(gca,'xtickLabel',[], 'ytickLabel',[]);

xlabel('predicted')
ylabel('ground truth')
title('confusion matrix')
