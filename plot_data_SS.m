% Example script to plot all data aggregated by populate_DDM_Sigmoids_struct

% clear workspace
cch

% move to the folder where we want to save the data
cd('C:\Users\sam.siljee\OneDrive - GMRI\Documents\Coding\multi-DDM\Input_data_Analysis')

% load aggregated data
aggregated_data = 'Merged_data_inserts.mat';

load(aggregated_data,...
    'SampleType',...
    'sampletypes',...
    'timepoints',...
    'donors',...
    'inserts',...
    'positions',...
    'boxsizes_vector',...
    'q_limits_1oum');

% Add figures_folder to the structure
for i = 1:length(SampleType)
    SampleType(i).figures_folder = 'C:\Users\sam.siljee\OneDrive - GMRI\Documents\Coding\multi-DDM\Input_data_Analysis\plots';
end

%% Simple use of the MergedData structure:

% plot a sigmoidal curve and a CBF distribution for data from each
% sampletype, timepoint, insert, position, donors combination

% in this case, we have different donors, and inserts, that we want to keep
% separate, but we do not have positions that we want to keep separate.
        
for stc = 1:numel(sampletypes) % sampletype counter
    for tpc = 1:numel(timepoints) % timepoint counter
        for dc = 1:numel(donors) % donor counter
            for ic = 1:numel(inserts) % insert counter
                
                % output stuff
                disp_C = {sampletypes{stc},...
                    timepoints{tpc},...
                    donors{dc},...
                    inserts{ic}};
                disp_str = strjoin(disp_C,', ');
                disp('Plotting data from: ')
                disp(disp_str)
                
                % Add debugging: check if data exists in SampleType structure
                try
                    if dc <= length(SampleType(stc).TimePoint(tpc).Data)
                        current_data = SampleType(stc).TimePoint(tpc).Data(dc);
                        fprintf('FileList length: %d\n', length(current_data.FileList));
                        fprintf('Donor: %s, Insert: %s\n', current_data.Donor, current_data.Insert);
                    else
                        fprintf('Data index %d exceeds available data length\n', dc);
                        continue;
                    end
                catch ME
                    fprintf('Error accessing data: %s\n', ME.message);
                    continue;
                end
                
                % invoke function that extracts data from the SampleType
                % structure for easier plotting
                try
                    MergedData = merge_SampleType_data(SampleType,...
                        stc, tpc, donors{dc}, inserts{ic}, '');
                    
                    % Check if MergedData was actually returned
                    if ~exist('MergedData', 'var') || isempty(MergedData)
                        fprintf('MergedData is empty or not returned\n');
                        continue;
                    end
                    
                catch ME
                    fprintf('Error in merge_SampleType_data: %s\n', ME.message);
                    continue;
                end
                
                % do not attempt a plot if empty MergedData
                if isempty(MergedData)
                    continue
                end
                
                % plot sigmoidal curve and CBF distribution
                try
                    plot_single_sigmoid_errorbar(MergedData, true, 'left')
                    plot_single_CBF_histogram(MergedData, [], 0:0.5:60, 1)
                catch ME
                    fprintf('Error in plotting: %s\n', ME.message);
                end
                
            end % for ic
        end % for dc
    end % for tpc
end %for stc


% It is also possible to use merge_SampleType_data to pool together data
% taken on different inserts, or at different positions, or even from
% different donors. Just pass an array as the relevant input:
% if one wanted to pool together all donors and inserts:
% MergedData =  merge_SampleType_data(SampleType, stc, tpc, donors{dc}, inserts, '');
% if one wanted to pool together all donors and inserts:
% MergedData =  merge_SampleType_data(SampleType, stc, tpc, donors, inserts, '');
% (of course, this requires tweaking the for loops above)
        
% It is then possible to use an array of MergedData structures to create
% figures where multiple sigmoids or multiple CBF distributions are
% overlaid, but that means writing code that is quite specialised to the
% task/experiment, and is beyond the scope of this commit
