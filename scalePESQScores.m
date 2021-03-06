function [newscore] = scalePESQScores(original)
%Takes in a 1D vector and converts all the scores in it
len = length(original);
newscore = zeros(1, len);
for i=1:len
    newscore(i) = 1 + 9 * ((-original(i) + 4.5) / 5 );
end