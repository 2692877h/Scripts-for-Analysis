%% clear all
clear all, clc

%% loading

% Set up folder
exp_folder = 'Z:/longevity_2024/'; % path to analyse folder
preprocessed_eeg_file = fullfile(exp_folder, '/data/EEG_data'); % individual preprocesed data folder
baseline_data_file = fullfile('Z:\longevity_2024\results\hana\Hana'); % baseline corrected data folder
output_folder_avg = fullfile('Z:\longevity_2024\results\hana\averages_hana'); % grand average for sync and async folder
tfr_data_file = fullfile('Z:\longevity_2024\results\hana\Hana') % individual tfr data folder
stat_file = fullfile('Z:\longevity_2024\results\hana\averages_hana') % stat_freq 

% Colormap
addpath(fullfile('Z:\longevity_2024\analyses\scripts\Hana')) % brewermap folder
cm = brewermap([],'YlGnBu');

%% initialize Fieldtrip
addpath(fullfile(exp_folder, '\analyses\plug-ins\fieldtrip-20231025'))
addpath(fullfile(exp_folder, '\analyses\functions'))
ft_defaults
