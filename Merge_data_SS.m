% Script to merge .mat results - based on example script
% "prepare_accumdata_for_sigmoids.m"
% populate_DDM_Sigmoids_struct

% clear the workspace
cch

% move to the folder where we want to save the data
cd('C:\Users\Sam\Documents\Coding\multi-DDM\Combined_results')

% prepare variables for populating data structure

% cell array of folder names. List all folders with the .mat you want to 
% aggregate in a single structure
analysis_folder = {'C:\Users\Sam\Documents\Coding\multi-DDM\Input_data_Analysis';};


% filtering string: of all files in the list of analysis_folder, only the ones 
% containing the imaging_string will be aggregated
imaging_string = '_HSV_80X';

% Filters to categorise data
% Files matching different combinations of the strings in the following arrays 
% will be categorised separately 
sampletypes = {'p53_KD';
    'Control'};
timepoints = '';
donors = {'21_052';'21_073';'21_120';'21_161';'21_166';'21_189';'22_069';'22_114'};
inserts = {'i1','i2','i3'};
positions = '';

% list of boxes used in the previous multiDDM analysis step
boxsizes_vector = [16 32 48 64 96 128 160 192 224 256 340 360];

% Only data within these wavenumber limits (in um^{-1}) will contribute towards
% the final measurement of the coordination length scale 
q_limits_1oum = [];

% if true, only categorises the data according to the filtering strings, but 
% doesn't actually load the data. Highly recommended to do a dry-run and then 
% check into the SampleType structure whether all the .mat files were 
% categorised as expected
flag_dryrun = true;

% if true, forces to recalculate which tiles showed movement. 
% Should only be useful if re-analysing data across a change in the motion 
% detection algorithm 
flag_recalculate_goodboxes = false;

% call to the actual aggregating function
[SampleType] = populate_DDM_Sigmoids_struct( analysis_folder,...
    imaging_string, sampletypes, timepoints, donors, inserts, positions,  ...
	boxsizes_vector, q_limits_1oum,...
    flag_dryrun, flag_recalculate_goodboxes);

% save the results
save('AccumData_from_func.mat')

return
