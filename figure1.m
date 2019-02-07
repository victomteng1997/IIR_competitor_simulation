data=[1 1 1; 0.562768022 2 2; 0.519855282 3 0];
%First column is the sorted value
%Second column is the index for the YTickLabel
%Third column is the reaction direction
% Data(1,3) = 1 -> bar in red
% Data(1,3) = 0 -> bar in blue
uniNames = {'Competing Method 1','Competing Method 2','Proposed Algorithm'};
%This was the original script....
H = data(:, 1);
N = numel(H);
for i=1:N
  h = bar(i, H(i));
  if i == 1, hold on, end
  if data(i, 3) == 1
    col = [0, 0.4470, 0.7410];
  elseif data(i,3) == 2
    col = [0.8500, 0.3250, 0.0980];
  else
    col = [0.9290, 0.6940, 0.1250];
  end
  set(h, 'FaceColor', col) 
end
set(gca, 'XTickLabel', '')  
xlabetxt = uniNames(data(:,2));
ylim([0 1]); ypos = -max(ylim)/50;
text(1:N,repmat(ypos,N,1), ...
     xlabetxt','horizontalalignment','center')
text(.55,77.5,'A','FontSize',25)

title('Average Normalized Group Delay Deviation')