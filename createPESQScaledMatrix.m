%adding my folder to the path
path(path, 'c:/Users/Scott S/Desktop/WHI Voice Recognition Research/');
filename = 'PESQ beg.xlsx';
A = xlsread(filename);
%A is now a 45 x 45 matrix
%making A a symmetric matrix
Atr = A.';
Atr = Atr - diag(diag(Atr));
A = A+Atr;
scaledMat = zeros(45, 45);
for i=1:45
    %scaling column by column
    scaledMat(:, i) = scalePESQScores(A(:, i));
end
%writing to an excel sheet

xlswrite('Scaled PESQ beg.xlsx', scaledMat);