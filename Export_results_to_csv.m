% script to process the multi-DDM results and export in .csv format for
% further processing in R

% Input directory
input_dir = 'Test_input_Analysis';

% Get list of results files
results_files = dir(fullfile(input_dir, '*.mat'));

% Get list of result types to save
result_types = { ...
    'detected_motion', ...
    'std_fs', ...
    'Kymograph', ...
    'SAVAlike.frequency_map', ...
    'SAVAlike.ind_good_bins', ...
    'SAVAlike.mean_frequency', ...
    'SAVAlike.std_frequency', ...
    'SAVAlike.err_frequency', ...
    'SAVAlike.median_frequency' ...
    };

% Iterate through and save results as .csv files
for i = 1:length(results_files)
    % Load the .mat results file
    load(fullfile(input_dir, results_files(i).name));

    % Loop through different result types to load
    for j = 1:length(result_types)
        % Access the specific result type, ensuring to handle nested properties
        if contains(result_types{j}, '.')
            % Split the result type into parts
            parts = split(result_types{j}, '.');
            result_data = cilia.(parts{1}).(parts{2});
        else
            result_data = cilia.(result_types{j});
        end

        % Make a file name
        filename = fullfile( ...
            input_dir, ...
            append(erase(results_files(i).name, '.mat'), ...
            '_', ...
            replace(result_types{j}, '.', '_'), ...
            '.csv'));

        % Write the matrix to a CSV file
        writematrix(result_data, filename);
    end
end
