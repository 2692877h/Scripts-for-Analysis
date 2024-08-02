%% Clear all
clear all; clc;

%% Start

% Set up folder
exp_folder = 'Z:/longevity_2024/'; % path to analysis folder
preprocessed_eeg_file = 'Z:/longevity_2024/data/EEG_data'; % where to find preprocessed data

% Edit static list
subjects = {'subj01', 'subj02', 'subj04', 'subj05', 'subj08', 'subj09', 'subj10', ...
     'subj12', 'subj13', 'subj14', 'subj15', 'subj16', 'subj17', 'subj19', 'subj20', ...
     'subj21', 'subj22', 'subj23', 'subj24', 'subj25', 'subj26', 'subj27', 'subj28', ...
     'subj29','subj30', 'subj32', 'subj33', 'subj35', 'subj36', 'subj37', ...
     'subj38', 'subj40', 'subj41', 'subj43', 'subj46', 'subj47', 'subj49', 'subj52', ...
     'subj53', 'subj54', 'subj56', 'subj57', 'subj58', 'subj59', 'subj60', 'subj61', ...
     'subj62', 'subj63'};

% Initialize Fieldtrip
addpath(fullfile(exp_folder, 'analyses', 'plug-ins', 'fieldtrip-20231025'));
addpath(fullfile(exp_folder, 'analyses', 'functions'));
ft_defaults;

%% Loop
for i = 1:length(subjects)

    subj_id = subjects{i};
    task = 'ratings_preprocessed';

    % Load Data
    % Go to the data folder
    cd(preprocessed_eeg_file)

    % File name
    filename = [subj_id '_' task '.mat'];
    load(filename)

    cfg = [];
    cfg.dataset = filename;

    %% Preprocess the data for sync/desync
    cfg.trials = find(data_clean.trialinfo(:, 6) == 0); % Sync column
    sync_trials = ft_preprocessing(cfg, data_clean);

    cfg.trials = find(data_clean.trialinfo(:, 6) == 180); % Desync column
    desync_trials = ft_preprocessing(cfg, data_clean);

    %% Time frequency analysis with a Hanning taper and fixed window length
    cfg = [];
    cfg.output = 'pow';
    cfg.channel = 'all';
    cfg.method = 'mtmconvol';
    cfg.taper = 'hanning';
    cfg.toi = -1 : 0.05 : 4; 
    cfg.foi = 4:8;
    cfg.t_ftimwin = 6 ./ cfg.foi;
    cfg.keeptrials = 'no';  
    tfr_sync = ft_freqanalysis(cfg, sync_trials);
    tfr_desync = ft_freqanalysis(cfg, desync_trials);

    %% Baseline correction
 % Apply baseline correction
cfg = [];
cfg.baseline = [-0.5 -0.1]; % Baseline period
cfg.baselinetype = 'relchange';  % We use a relative baseline
cfg.xlim = [0 3]; % Time window to look at
cfg.ylim = [4 8];  
cfg.zlim = 'maxabs';
cfg.marker = 'on';
cfg.channel = 'all';
cfg.colorbar = 'yes';
cfg.layout = 'biosemi128.lay';

tfr_sync_baseline = ft_freqbaseline(cfg, tfr_sync);
tfr_desync_baseline = ft_freqbaseline(cfg, tfr_desync);


    %% Save individual subject results
    output_folder = fullfile(exp_folder, 'results', 'hana', 'Hana');

    % Ensure the output directory exists
    if ~exist(output_folder, 'dir')
        mkdir(output_folder);
    end

    sync_filename = fullfile(output_folder, [subj_id '_tfr_sync.mat']);
    save(sync_filename, 'tfr_sync_baseline');

    desync_filename = fullfile(output_folder, [subj_id '_tfr_desync.mat']);
    save(desync_filename, 'tfr_desync_baseline');

    % Store the baseline corrected data in the cell arrays
    tfr_sync_all{i} = tfr_sync_baseline;
    tfr_desync_all{i} = tfr_desync_baseline;

    disp(['Processed subject: ' subj_id]);

end




%% Save the baseline corrected data for all participants
% Ensure the output directory exists
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% Save tfr_sync_all
sync_all_filename = fullfile(output_folder, 'tfr_sync_all.mat');
save(sync_all_filename, 'tfr_sync_all');

% Save tfr_desync_all
desync_all_filename = fullfile(output_folder, 'tfr_desync_all.mat');
save(desync_all_filename, 'tfr_desync_all');

disp('All data saved successfully.');

 