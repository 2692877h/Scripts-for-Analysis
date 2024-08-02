%% Trial info

%% Setup the environment

% edit static list
subjects = {'subj01', 'subj02', 'subj04', 'subj05', 'subj08', 'subj09', 'subj10', ...
     'subj12', 'subj13', 'subj14', 'subj15', 'subj16', 'subj17', 'subj19', 'subj20', ...
     'subj21', 'subj22', 'subj23', 'subj24', 'subj25', 'subj26', 'subj27', 'subj28', ...
     'subj29','subj30', 'subj32', 'subj33', 'subj34', 'subj35', 'subj36', 'subj37', ...
     'subj38', 'subj40', 'subj41', 'subj43', 'subj46', 'subj47', 'subj49', 'subj52', ...
     'subj53', 'subj54', 'subj56', 'subj57', 'subj58', 'subj59', 'subj60', 'subj61', ...
     'subj62', 'subj63'};


preprocessed_eeg_file = 'Z:/longevity_2024/data/EEG_data';

%% Hits and Misses trial total
% Initialize counts matrix
numSubjects = length(subjects);
counts_matrix = zeros(numSubjects, 4); % 4 columns: hits_synch, hits_asynch, misses_synch, misses_asynch

% Loop through subjects
for i = 1:numSubjects
    subj_id = subjects{i};
    task = 'ratings_preprocessed';

    % File name
    filename = fullfile(preprocessed_eeg_file, [subj_id '_' task '.mat']);
    
    % Load only the 'trialinfo' variable from the file
    data = load(filename, 'data_clean');
    
    % Extract trialinfo from the loaded structure
    trialinfo = data.data_clean.trialinfo;

    % Determine hits and misses trials
    hits_trials_synch = find(trialinfo(:, 7) == 1 & trialinfo(:, 6) == 0); 
    hits_trials_asynch = find(trialinfo(:, 7) == 1 & trialinfo(:, 6) == 180); 
    misses_trials_synch = find(trialinfo(:, 7) == 0 & trialinfo(:, 6) == 0);
    misses_trials_asynch = find(trialinfo(:, 7) == 0 & trialinfo(:, 6) == 180);
    
    % Count hits and misses for each condition
    counts_matrix(i, 1) = numel(hits_trials_synch);
    counts_matrix(i, 2) = numel(hits_trials_asynch);
    counts_matrix(i, 3) = numel(misses_trials_synch);
    counts_matrix(i, 4) = numel(misses_trials_asynch);
end


%%
% Create a table with labeled columns
counts_table = array2table(counts_matrix, ...
                           'VariableNames', {'Hits_Synch', 'Hits_Asynch', 'Misses_Synch', 'Misses_Asynch'});

% Calculate mean number of trials for each condition
mean_hits_synch = mean(counts_table.Hits_Synch);
mean_hits_asynch = mean(counts_table.Hits_Asynch);
mean_misses_synch = mean(counts_table.Misses_Synch);
mean_misses_asynch = mean(counts_table.Misses_Asynch);

% Add mean row to the table
counts_table(end+1, :) = {mean_hits_synch, mean_hits_asynch, mean_misses_synch, mean_misses_asynch};

% Label the mean row (this assumes you can add a row identifier)
counts_table.Properties.RowNames{end} = 'Mean';

% Specify the folder to save the table
trialinfo_folder = 'Z:/longevity_2024/results/hana/trial info';

% Ensure the directory exists
if ~exist(trialinfo_folder, 'dir')
    mkdir(trialinfo_folder);
end

% Save the counts table as a CSV file
csv_filename = fullfile(trialinfo_folder, 'counts_table.csv');
writetable(counts_table, csv_filename, 'WriteRowNames', true);
