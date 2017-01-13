% New laser stim analysis
% TMOHREN 2016-12-21

% to do: 
%   make overview figure
%   clean up code

clc;clear all;close all

%% Initialize, set up parameters

par.diagnostic_fig = 1 ;
par.w_moths = 1;                  % Select w(hich)_moth to analyze, any combination between 1 and 25
par.N_last = 2.05e7;                % last input to read 
par.figname = 'MeanSpikeResponse';  % give name to saved figure
% par.datafolder = '\data\Revised Stim';  % select which data folder to use
par.datafolder ='C:\Users\Daniellab\Documents\Thomas Mohren\Laseranalysis_Ephys_paper_NoLongerUpdated\data\Revised Stim';
par.loop_names = 1;                 % Either use a loop to create file names, or list them in a way

set(0,'DefaultlinelineWidth',2)
run('link_folders_laser')

%% Create filename library 

if par.loop_names == 1
    for j = par.w_moths
        if exist([ 'Corrected_Revised_Stim_M',num2str(j),'_sorted.txt' ])
            par.SpikeName{j} = ['Corrected_Revised_Stim_M',num2str(j),'_sorted.txt'];
        elseif exist([ 'Revised_Stim_M',num2str(j),'_sorted.txt'])        
            par.SpikeName{j} = ['Revised_Stim_M',num2str(j),'_sorted.txt'];
        else
            par.SpikeName{j} = 'Not Found';
        end
        if exist([ 'Revised_Stim_M',num2str(j),'.txt'])        
            par.StimName{j} = ['Revised_Stim_M',num2str(j),'.txt'];
        else
            par.StimName{j} = 'Not Found';
        end
    end
else
    par.SpikeName = {'Revised_Stim_M1_sorted.txt','Revised_Stim_M2_sorted.txt','Revised_Stim_M3_sorted.txt'  'Revised_Stim_M4_sorted.txt' };
    par.StimName = {'Revised_Stim_M1.txt','Revised_Stim_M2.txt','Revised_Stim_M3.txt' , 'Revised_Stim_M4.txt' }; 
end

%% Run analysis

[Sp,par]= LoadStimSpike(par);           % load stimulus and spike occurence into Sp
L       = LaserStim(par,Sp);                    % analyze stimulus, when is laser on? 
[NE,F]  = LaserFiringRate( par,Sp,L );          % when laser is on, what is firing rate? 
M       = FRanalyzeMean( par,NE );              % what is mean firing rate, and how does each individual occurence project onto mean

%%  Plot figures

run('Fig_MeanAnalysisMethod' )          % give overview of method
run('Fig_MeanAnalysisAll' )             % show response of all data 



