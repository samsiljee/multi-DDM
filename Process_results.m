% script to process the multi-DDM results and export in .csv format for
% further processing in R

% Input directory
input_dir = 'Input_data_Analysis';

% Get list of results files
results_files = dir(fullfile(input_dir, '*.mat'));

% Get list of result types to save
result_types = ['detected_motion', ...
    'std_fs', ...
    'Kymograph', ...
    'SAVAlike.frequency_map', ...
    'SAVAlike.ind_good_bins', ...
    'SAVAlike.mean_frequency', ...
    'SAVAlike.std_frequency', ...
    'SAVAlike.err_frequency', ...
    'SAVAlike.median_frequency'];

% Iterate through and save results as .csv files
for i = 1:length(results_files)
    % Load the .mat results file
    load(append(input_dir, '\', results_files(i).name));
    
    % Loop through different result types to load
    for j = 1:length(result_types)
        % Load the specific result type
        result_data = eval(append('cilia.', result_types(j)));

        % Make a file name
        filename = fullfile(input_dir, append(erase(results_files(i).name, '.mat'), '_',  result_types(j), '.csv'));

        % Write the matrix to a CSV file
        writematrix(result_data, filename);
    end
end