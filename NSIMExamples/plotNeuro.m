function range=plotNeuro(neuro,bfs,t_sp,range)
%
% (c) Andrew Hines, May 2013. 
% Author: Andrew Hines
% email: andrew.hines@tcd.ie
%
if nargin<4
    %this ensures that the color map for two neurograms are plotted to the
    %same range for visual comparison.
    range=[min(min(neuro)) max(max(neuro))];
end
fsize=14;
imagesc(t_sp,1:length(bfs),neuro, range);
ylabel('CF(Hz)','fontsize',fsize);    
flab=[1 8 16 30];
set(gca,'YTickLabel',round(bfs(flab)),'YTick',flab);
set(gca,'YDir','normal');    
 
xlabel('t(s)','fontsize',fsize);              
    
end
