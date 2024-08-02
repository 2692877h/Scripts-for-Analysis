
%% Clear all
clear all; clc

%% File names
load('tfr_sync_all.mat');
load('tfr_desync_all.mat');


%% 
cfg = [];
cfg.method           = 'montecarlo';
cfg.correctm         = 'cluster';  % Cluster-based correction
cfg.channel          = 'all';  % Use all EEG channels
cfg.latency          = 'all';  % Use all latencies
cfg.frequency        = [4 8]; % Frequency of interest 
cfg.statistic        = 'ft_statfun_depsamplesT';  % Independent samples t-test
cfg.clusteralpha     = 0.05;  % Alpha level for cluster formation
cfg.clusterstatistic = 'maxsum';  % Cluster statistic method
cfg.minnbchan        = 2;  % Minimum number of channels for a cluster
cfg.tail             = 1;  % One-tailed test (0 = two-tailed)
cfg.clustertail      = 1; 
cfg.alpha            = 0.05;  
cfg.numrandomization = 1000; 

% Define the neighbourhood structure
cfg_neighb.method = 'triangulation'; 
cfg_neighb.layout = 'biosemi128.lay'; 
cfg.neighbours = ft_prepare_neighbours(cfg_neighb,tfr_sync_all{1, 1});  


Nsub = 49; % change to length(grandavg_sync_all)
cfg.design(1,1:2*Nsub)  = [ones(1,Nsub) 2*ones(1,Nsub)];
cfg.design(2,1:2*Nsub)  = [1:Nsub 1:Nsub];
cfg.ivar                = 1; 
cfg.uvar                = 2; 


% Run the cluster-based permutation test
[stat_freq] = ft_freqstatistics(cfg, tfr_sync_all{:}, tfr_desync_all{:});

% Define the output file path
stat_freq_filename = fullfile(output_folder, 'stat_freq.mat');
save(stat_freq_filename, 'stat_freq');