function [ Sp,par ] = LoadStimSpike( par)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

fprintf('Loading data...  \n');

tic 
for j = par.w_moths
    if exist( par.SpikeName{j} )            % load spike times, 
        Sp.(['M',num2str(j)]) = csvread( par.SpikeName{j}  , 1,0);
    else
        Sp.SpikeName{j} = 'Not Found';
        display([ par.SpikeName{j} ,'.txt, does not exist' ]);
    end
    
    if exist( par.StimName{j})             %  load Stimulus 
        fileID = fopen( [ par.StimName{j}]);
        formatSpec = '%f %f';
        TempSt = textscan(fileID,formatSpec,par.N_last,'Delimiter','\t'); % load stimulus up to par.N_last (end of laserphase)
        fclose(fileID);
        Sp.(['M',num2str(j),'stim']) = TempSt{2};                         % If file contains 2 columns, 2nd column is stimulus (1st is raw recording) 
        fprintf('   Data for Moth %d loaded \n', j);
    else
        Sp.(['M',num2str(j)]) = 0;      
        display([ par.StimName{j},'.txt, does not exist' ]);
    end
end

par.MothN = [];
for j = par.w_moths
    Neurs = size(Sp.(['M',num2str(j)]),2)-1;    % subract 1 neuron 
    par.MothN = [par.MothN;  [repmat(j,Neurs,1), (1:Neurs)'] ];
end
fprintf('Data loaded, loading took %d seconds \n',round(toc,0))

end

