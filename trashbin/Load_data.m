% Load data 

% Dat_loc = 'C:\Users\Daniellab\Desktop\Revised Stim\';
% Dat_loc = [pwd,'\data\Revised Stim\'];
% Dat_loc = '';



% load spikes
% for j = 1:n_moths 
for j = w_moths
    if exist([ 'Corrected_Revised_Stim_M',num2str(j),'_sorted.txt' ])
        Sp.SpikeName{j} = ['Corrected_Revised_Stim_M',num2str(j),'_sorted.txt'];
        Sp.(['M',num2str(j)]) = csvread( [ 'Corrected_Revised_Stim_M',num2str(j),'_sorted.txt'], 1,0);
    elseif exist([ 'Revised_Stim_M',num2str(j),'_sorted.txt'])        
        Sp.SpikeName{j} = ['Revised_Stim_M',num2str(j),'_sorted.txt'];
        Sp.(['M',num2str(j)]) = csvread( [ 'Revised_Stim_M',num2str(j),'_sorted.txt'], 1,0);
    else
        Sp.(['M',num2str(j)]) = 0;        
        Sp.SpikeName{j} = 'Not Found';
    end
end

% load stimulus 
% for j = 1:n_moths 
for j = w_moths
    if exist([ 'Revised_Stim_M',num2str(j),'.txt'])        
        Sp.StimName{j} = ['Revised_Stim_M',num2str(j),'.txt'];
        fileID = fopen( [ Sp.StimName{j}]);
        formatSpec = '%f %f';
        TempSt = textscan(fileID,formatSpec,N_last,'Delimiter','\t');
        fclose(fileID);
        Sp.(['M',num2str(j),'stim']) = TempSt{2};
    else
        Sp.(['M',num2str(j)]) = 0;        
        Sp.FileName{j} = 'Not Found';
    end
end

MothN = [];
% for j = 1:n_moths         % Conversion table from Neuron to Moth
for j = w_moths
    Neurs = size(Sp.(['M',num2str(j)]),2)-1;    % subract 1 neuron 
    MothN = [MothN;  [repmat(j,Neurs,1), (1:Neurs)'] ];
end
display('data loaded')