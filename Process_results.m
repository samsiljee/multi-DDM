% script to process the multi-DDM results and export in .csv format for
% further processing in R

% Input directory
input_dir = "../DDM/Input_data_Analysis";

% Get list of results files
results_files = dir(fullfile(input_dir, '*.mat'));

% Iterate through and save results as .csv files
for i = 1:length(results_files)
    disp(matFiles(k).name);
end