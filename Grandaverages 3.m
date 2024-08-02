%% Clear all
clear all; clc

%% Setup the environment

% Load the baseline-corrected data
load('tfr_sync_all.mat');
load('tfr_desync_all.mat');


%% Create grand average with ft_freqgrandaverage
% Within Subjects: test difference between average power spectra 

cfg = [];
cfg.foilim = [4 8]; % specify theta band frequencies
cfg.toilim = [0 3]; % specify subset of latencies
cfg.channel = 'all'; 
cfg.parameter = 'powspctrm';



GA_sync = ft_freqgrandaverage(cfg, tfr_sync_all{:});
GA_desync = ft_freqgrandaverage(cfg, tfr_desync_all{:});
GA_diff = GA_sync;
GA_diff.powspctrm = GA_sync.powspctrm - GA_desync.powspctrm;


%% Save Data

% Save grand average for sync and desync
output_folder_avg = fullfile(exp_folder, 'results', 'hana', 'averages_hana');

% Ensure the output directory exists
if ~exist(output_folder_avg, 'dir')
    mkdir(output_folder_avg);
end

% Save grandavg_sync
grandavg_sync_filename = fullfile(output_folder_avg, 'GA_sync.mat');
save(grandavg_sync_filename, 'GA_sync');

% Save grandavg_desync
grandavg_desync_filename = fullfile(output_folder_avg, 'GA_desync.mat');
save(grandavg_desync_filename, 'GA_desync');

% Save grandavg_diff
grandavg_diff_filename = fullfile(output_folder_avg, 'GA_diff.mat');
save(grandavg_diff_filename, 'GA_diff');



%% Define the electrodes of interest (combined frontal and parietal)
frontal_parietal_electrodes = {'C4', 'C5', 'C7', 'C8', 'C11', 'C12', 'C15', 'C16', 'C17', 'C19', 'C21', 'C23', 'C24', 'C25', 'C28', 'C29', 'C30', ...
                               'D4', 'D5', 'D7', 'D8', 'D10', 'D12', 'A5', 'A7', 'A10', 'A15', 'A17', 'A19', 'A21', 'A23', 'A28', 'A30', 'A32', ...
                               'B2', 'B4', 'B7', 'B10', 'B11', 'B13', 'B16', 'B18', 'B20', 'B22', 'B24', 'B26', 'B27', 'B29'};

%% Create grand average with ft_freqgrandaverage
% Within Subjects: test difference between average power spectra 

cfg = [];
cfg.foilim = [4 8]; % specify theta band frequencies
cfg.toilim = [0 3]; % specify subset of latencies
cfg.channel = frontal_parietal_electrodes; % use combined frontal and parietal electrodes
cfg.parameter = 'powspctrm';

GA_sync_combined = ft_freqgrandaverage(cfg, tfr_sync_all{:});
GA_desync_combined = ft_freqgrandaverage(cfg, tfr_desync_all{:});
GA_diff_combined = GA_sync_combined;
GA_diff_combined.powspctrm = GA_sync_combined.powspctrm - GA_desync_combined.powspctrm;

%% Save Data


% Define the output folder
output_folder_avg = 'Z:\longevity_2024\results\hana\averages_hana';

% Ensure the output directory exists
if ~exist(output_folder_avg, 'dir')
    mkdir(output_folder_avg);
end

% Save grandavg_sync_combined
grandavg_sync_combined_filename = fullfile(output_folder_avg, 'GA_sync_combined.mat');
save(grandavg_sync_combined_filename, 'GA_sync_combined');

% Save grandavg_desync_combined
grandavg_desync_combined_filename = fullfile(output_folder_avg, 'GA_desync_combined.mat');
save(grandavg_desync_combined_filename, 'GA_desync_combined');

% Save grandavg_diff_combined
grandavg_diff_combined_filename = fullfile(output_folder_avg, 'GA_diff_combined.mat');
save(grandavg_diff_combined_filename, 'GA_diff_combined');


