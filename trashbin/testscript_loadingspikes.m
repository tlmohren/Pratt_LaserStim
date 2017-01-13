% testscript


j = 22;
%     if exist( [par.SpikeName{j} ,'.txt'] )            % load spike times, 
Sp.(['M',num2str(j)]) = csvread( [par.SpikeName{j} ,'.txt']  , 1,0);

% exclude some columns 
Cols = size(Sp.(['M',num2str(j)]),2); 
for k = 1:Cols
end
