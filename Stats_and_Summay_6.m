% Experiment folder path
exp_folder = 'Z:\longevity_2024\';% path to analyse folder
output_folder_avg = 'Z:\longevity_2024\results\hana\eoi'; % where to find grand averaged data
avg_data_file = 'Z:\longevity_2024\results\hana\averages_hana'

% Initialize Fieldtrip
addpath(fullfile(exp_folder, 'analyses', 'plug-ins', 'fieldtrip-20231025'))
addpath(fullfile(exp_folder, 'analyses', 'functions'))
ft_defaults

baseline_data_file = 'Z:\longevity_2024\results\hana\Hana'; % where to find baseline corrected data

% Load Data
% go to the data folder
cd(baseline_data_file);

% file name
load('tfr_sync_all.mat');
load('tfr_desync_all.mat');


%%
frontal_parietal_electrodes = {'C4', 'C5', 'C7', 'C8', 'C11', 'C12', 'C15', 'C16', 'C17', 'C19', 'C21', 'C23', 'C24', 'C25', 'C28', 'C29', 'C30', ...
                               'D4', 'D5', 'D7', 'D8', 'D10', 'D12', 'A5', 'A7', 'A10', 'A15', 'A17', 'A19', 'A21', 'A23', 'A28', 'A30', 'A32', ...
                               'B2', 'B4', 'B7', 'B10', 'B11', 'B13', 'B16', 'B18', 'B20', 'B22', 'B24', 'B26', 'B27', 'B29'};


%% do some average  2
concatenated_sync = [];
concatenated_desync = [];

conds = {'tfr_sync_all', 'tfr_desync_all'};

% create avg
for iCond = 1:length(conds)
    condition = conds{iCond};
    c_data = eval(condition);

    for iPow = 1:length(c_data)
        % Select data for the specific electrodes
        cfg = [];
        cfg.channel = frontal_parietal_electrodes;
        selected_data = ft_selectdata(cfg, c_data{iPow});
        
        % Average over channels and frequencies
        cfg = [];
        cfg.avgoverchan = 'yes';
        cfg.avgoverfreq = 'yes';
        avg_pw = ft_selectdata(cfg, selected_data);

        % Store the averaged data
        avg_powerspectra{iCond, iPow} = squeeze(avg_pw.powspctrm)';
        if iCond == 1
            concatenated_sync = [concatenated_sync; avg_powerspectra{1, iPow}];
        else
            concatenated_desync = [concatenated_desync; avg_powerspectra{2, iPow}];
        end
    end
end

%% plot power x time  2
figure;
nGroups = 2;
colours = lines(nGroups);
aline_sync = stdshade(concatenated_sync,0.1,colours(1,:));
hold on;
aline_desync = stdshade(concatenated_desync,0.1,colours(2,:));
legend_names = {'synchronous trials', 'asychronous trials'};
legend([aline_sync, aline_desync], legend_names);
xlabel('Time (s)');
ylabel('Power (uV^2)');
time_labels = tfr_sync_all{1}.time;
time_idx = 1:round(0.5 / (time_labels(2) - time_labels(1))):length(time_labels);
time_labl = time_labels(time_idx);
set(gca, 'XTick', time_idx, 'XTickLabel', time_labl);


%% plot the power spectra   2
cd(avg_data_file);

addpath 'Z:\longevity_2024\results\hana\averages_hana'
% file name
load('GA_sync_combined.mat');
load('GA_desync_combined.mat');

% Define custom colors
sync_color = [0.1216, 0.4667, 0.7059]; 
desync_color = [0.1725, 0.6275, 0.1725]; 

% avg
cfg = [];
cfg.avgoverchan = 'yes'; % Average over channels
cfg.avgovertime = 'yes'; % Average over time
avg_pow_sync = ft_selectdata(cfg, GA_sync_combined);
avg_pow_desync = ft_selectdata(cfg, GA_desync_combined);

% Plot the average power spectrum for sync and desync
figure; hold on;
plot(avg_pow_sync.freq, avg_pow_sync.powspctrm, 'Color', sync_color, 'LineWidth', 1.5);
plot(avg_pow_desync.freq, avg_pow_desync.powspctrm, 'Color', desync_color, 'LineWidth', 1.5);
legend('Synchronous', 'Asynchronous');
xlabel('Frequency (Hz)');
ylabel('absolute power (uV^2)');
xlim([min(avg_pow_sync.freq) max(avg_pow_sync.freq)]);

%% adapted code from Guillaume
%% ADD LIMO_EEG TO YOUR PATH 2

% for some of the examples you will need the LIMO EEG toolbox:
% https://gforge.dcn.ed.ac.uk/gf/project/limo_eeg/
% see also: 
% www.hindawi.com/journals/cin/2011/831409/
% https://github.com/LIMO-EEG-Toolbox/limo_eeg

% add the folders to your path:
addpath('Z:\longevity_2024\analyses\scripts\Hana\limo_tools-4.0');

% alternatively go to >Home >Set Path > Add with subfolders and choose the
% limo_eeg folder

%%

Csync = mean(concatenated_sync, 1)'; % average across subjects for condition 1
Cdesync = mean(concatenated_desync, 1)'; % average across subjects for condition 2

Xf = time_labels;


%% STATS

% We do a t-test at each time point & plot the results on the figure.
% This is done in one step using the function limo_yuend_ttest
% from the LIMO_EEG toolbox.
% >> help limo_yuend_ttest % to learn more about this function

c1 = zeros(1,101,48); % 1  x time points x num of subjects 
c2 = c1; 

% reformat data so that dimension 1 = 1 electrode
% if we had say 100 electrodes, c1 would have dimensions 100,451,20

concatenated_data = cat(3, concatenated_sync', concatenated_desync');

% check
disp(['Size of concatenated_data:' num2str(size(concatenated_data))]);

c1(1,:,:) = concatenated_data(:,:,1); 
c2(1,:,:) = concatenated_data(:,:,2);
percent = 0; % regular t-test
alpha = 0.05;
[Ty, diff, se, CI, p, tcrit, df] = limo_yuend_ttest(c1, c2, percent, alpha);


% Number of comparisons
num_comparisons = length(p);

% Adjusted alpha for Bonferroni correction
alpha_bonferroni = alpha / num_comparisons;

% Find significant p-values after Bonferroni correction
significant = p <= alpha_bonferroni;

% Define custom colors
sync_color = [0.1216, 0.4667, 0.7059]; % Blue color
desync_color = [0.1725, 0.6275, 0.1725]; % Green color

% Filter Xf to include only the desired time range (0 to 3)
valid_indices = (Xf >= 0 & Xf <= 3);
Xf_filtered = Xf(valid_indices);
Csync_filtered = Csync(valid_indices);
Cdesync_filtered = Cdesync(valid_indices);
p_filtered = p(valid_indices);
significant_filtered = significant(valid_indices);

% Plotting with the adjusted time range
figure('Name', 'Power Spectrum - Sync vs Desync with Stats', 'Color', 'w', 'NumberTitle', 'off'); % make blank figure
hold on; % we're going to plot several elements
plot(Xf_filtered, Csync_filtered, 'Color', sync_color, 'LineStyle', '-', 'LineWidth', 3);
plot(Xf_filtered, Cdesync_filtered, 'Color', desync_color, 'LineStyle', '-', 'LineWidth', 3);

% Add only few elements
set(gca, 'LineWidth', 1, 'FontSize', 14, 'YGrid', 'on', 'Layer', 'Top');
xlabel('Time in ms', 'FontSize', 16);
ylabel('Power (uV^2)', 'FontSize', 16);
title('Power Spectrum - Synchronous vs Asynchronous (Statistical Significance)'); % Add a title to the plot
box on;

% Add a horizontal line showing time points at which a significant mean difference was observed
v = axis; % get current axis limits
plot(Xf_filtered, (significant_filtered) * 100 - 100 + v(3) * .95, 'r.', 'MarkerSize', 10);
axis(v) % restore axis limits to hide non-significant points

% Display the new time range
disp(['Time range in Xf_filtered: ', num2str(min(Xf_filtered)), ' to ', num2str(max(Xf_filtered))]);


% Assuming you have the p-values stored in the variable 'p'
min_p = min(p);
max_p = max(p);

% Display the range of p-values
disp(['The p-values from the paired t-tests ranged from ', num2str(min_p), ' to ', num2str(max_p), '.']);


%% Display Stats

% Time points of interest
selectedTimePoints = [10, 25, 50, 75, 100];

% Initialize arrays to store results
tStats = zeros(1, length(selectedTimePoints));
pValues_corrected = zeros(1, length(selectedTimePoints));

% Extract t-statistics and corrected p-values for selected time points
for i = 1:length(selectedTimePoints)
    timePoint = selectedTimePoints(i);
    tStats(i) = Ty(1, timePoint);
    pValues_corrected(i) = p(timePoint) * num_comparisons; % Bonferroni correction
end

% Display results
for i = 1:length(selectedTimePoints)
    fprintf('Time Point %d: t(%d) = %.4f, corrected p = %.4f\n', selectedTimePoints(i), df, tStats(i), pValues_corrected(i));
end




% Initialize array to store Cohen's d values
cohensD = zeros(1, num_comparisons);

% Calculate Cohen's d for each time point
for t = 1:num_comparisons
    % Extract data for current time point
    syncData = squeeze(c1(1, t, :));
    desyncData = squeeze(c2(1, t, :));
    
    % Calculate mean and standard deviation of differences
    mean_diff = mean(syncData - desyncData);
    std_diff = std(syncData - desyncData);
    
    % Compute Cohen's d
    cohensD(t) = mean_diff / std_diff;
end

% Display results for selected time points (10, 25, 50, 75, 100)
selectedTimePoints = [10, 25, 50, 75, 100];
for i = 1:length(selectedTimePoints)
    timePoint = selectedTimePoints(i);
    fprintf('Time Point %d: t(%d) = %.4f, corrected p = %.4f, Cohen''s d = %.4f\n', ...
        timePoint, df, Ty(1, timePoint), min(p(timePoint) * num_comparisons, 1), cohensD(timePoint));
end

% Optionally, save the detailed results to a file for comprehensive reporting
detailedResults = table((1:num_comparisons)', Ty(1, :)', p', cohensD', ...
    'VariableNames', {'TimePoint', 'TStatistic', 'PValue', 'CohensD'});
writetable(detailedResults, 'detailed_results.csv');


% Plotting Cohen's d over time
figure;
plot(1:num_comparisons, cohensD, 'LineWidth', 1.5);
xlabel('Time Point', 'FontSize', 25);  % Increased font size for x-axis label
ylabel('Cohen''s d', 'FontSize', 25);  % Increased font size for y-axis label
title('Effect Size (Cohen''s d) Over Time', 'FontSize', 33);
set(gca, 'FontSize', 22);  % Increase font size of tick labels
grid on;



%% HOW MANY SUBJECTS SHOW AN EFFECT IN THE SAME DIRECTION AS THE GROUP?


figure('Color', 'w', 'NumberTitle', 'off'); % make blank figure

hold on;

% proportion of subjects with ERP>0
% prop=sum(squeeze(c1-c2)>0,2)./size(c1,3);

% plot proportion of subjects with difference in the same direction as the group
prop = sum(sign(squeeze(c1-c2)) == squeeze(repmat(sign(diff), [1 1 size(c1,3)])), 2) ./ size(c1,3);

plot(Xf, prop, 'Color', [1 0 0], 'LineStyle', '-', 'LineWidth', 3);

set(gca, 'LineWidth', 1, 'FontSize', 32, 'YGrid', 'on', 'Layer', 'Top'); % Increased font size for tick labels
xlabel('Time in ms', 'FontSize', 28); % Increased font size for x-axis label
ylabel({'Proportion'; 'of subjects'}, 'FontSize', 28); % Increased font size for y-axis label
title('Proportion of Subjects Consistent with Group Effect Over Time', 'FontSize', 36); % Add title with increased font size
box on;
plot([v(1) v(2)], [0.5 0.5], 'k--'); % add horizontal line at 0.5

xlim([0 3]); % Set the x-axis limits from 0 to 3 ms



%% EVERYTHING TOGETHER: SUMMARY FIGURE

% Define custom colors for the conditions and confidence intervals
sync_color = [0.1216, 0.4667, 0.7059]; % Blue color for sync condition
async_color = [0.1725, 0.6275, 0.1725]; % Green color for async condition
ci_sync_color = [0.3, 0.3, 0.3]; % Grey color for sync CI
ci_async_color = [0.9, 0.9, 0.9]; % Light grey color for async CI

% Define the time range for plotting
time_range = [0, 3]; % 0 to 3 seconds

figure('Color','w','NumberTitle','off','Units','normalized','Position',[0 0 .6 1]) % make blank figure

% --------------------------------------------------------------------------
subplot(3,2,1); hold on  % standard figure **********************
text(0.02, .94, 'A', 'FontSize', 24, 'FontWeight', 'bold', 'Units', 'normalized')
plot(Xf, Csync, 'Color', sync_color, 'LineStyle', '-', 'LineWidth', 3)
plot(Xf, Cdesync, 'Color', async_color, 'LineStyle', '-', 'LineWidth', 3)
% Add elements
set(gca, 'LineWidth', 1, 'FontSize', 14, 'YGrid', 'on', 'Layer', 'Top')
xlabel('Time in ms', 'FontSize', 16)
ylabel('Relative Change', 'FontSize', 16) % Corrected y-axis label
title('Power Spectrum - Sync vs Async', 'FontSize', 18)
legend({'Sync', 'Async'}, 'Location', 'Northeast')
box on
xlim(time_range)
axis tight

% --------------------------------------------------------------------------
subplot(3,2,2); hold on  % plot confidence intervals + sig points **********************
text(0.02, .94, 'B', 'FontSize', 24, 'FontWeight', 'bold', 'Units', 'normalized')
plot(Xf, Csync, 'Color', sync_color, 'LineStyle', '-', 'LineWidth', 3)
plot(Xf, Cdesync, 'Color', async_color, 'LineStyle', '-', 'LineWidth', 3)
set(gca, 'LineWidth', 1, 'FontSize', 14, 'YGrid', 'on', 'Layer', 'Top')
xlabel('Time in ms', 'FontSize', 16)
ylabel('Relative Change', 'FontSize', 16) % Corrected y-axis label
title('Confidence Intervals with Significant Points', 'FontSize', 18)
box on
% Get confidence intervals for each condition
percent = 0;
alpha = 0.05; % to get a 95% confidence interval
nullvalue = 0;
[t, tmdata, trimci_c1, p, tcrit, df] = limo_trimci(c1, percent, alpha, nullvalue);
[t, tmdata, trimci_c2, p, tcrit, df] = limo_trimci(c2, percent, alpha, nullvalue);
% Plot confidence intervals for sync condition
x = Xf; % time vector
y = mean(squeeze(trimci_c1(:, :, 1)), 1); % CI lower bound
z = mean(squeeze(trimci_c1(:, :, 2)), 1); % CI upper bound
c = ci_sync_color; % set color
t = 0.1; % set transparency [0, 1]
X_sync = [x, fliplr(x)]; % create x values
Y_sync = [y, fliplr(z)]; % create y values
hf = fill(X_sync, Y_sync, c); % plot filled area
set(hf, 'FaceAlpha', t, 'EdgeColor', sync_color);
% Plot confidence intervals for async condition
y = mean(squeeze(trimci_c2(:, :, 1)), 1); % CI lower bound
z = mean(squeeze(trimci_c2(:, :, 2)), 1); % CI upper bound
c = ci_async_color; % set color
X_async = [x, fliplr(x)]; % create x values
Y_async = [y, fliplr(z)]; % create y values
hf = fill(X_async, Y_async, c); % plot filled area
set(hf, 'FaceAlpha', t, 'EdgeColor', async_color);
% Add significant points after Bonferroni correction
num_comparisons = length(p);
alpha_bonferroni = alpha / num_comparisons;
significant = p <= alpha_bonferroni;
v = axis; % get current axis limits
plot(Xf, (significant) * 100 - 100 + v(3) * .95, 'k.', 'MarkerSize', 15)
axis(v) % restore axis limits to hide non-significant points
xlim(time_range)
legend({'Sync', 'Async'}, 'Location', 'Northeast')

% --------------------------------------------------------------------------
subplot(3,2,3); hold on % plot difference ********************************
text(0.02, .94, 'C', 'FontSize', 24, 'FontWeight', 'bold', 'Units', 'normalized')
plot(Xf, squeeze(c1 - c2), 'Color', [0.7, 0.7, 0.7]) % PLOT DIFFERENCE FOR EVERY SUBJECT <<<<
plot(Xf, diff, 'Color', async_color, 'LineStyle', '-', 'LineWidth', 3) % Green line for mean difference
plot(Xf, squeeze(CI), 'Color', sync_color, 'LineStyle', '-', 'LineWidth', 1) % Blue line for 95% CI
% Add elements
v = axis; % get current axis limits
alpha_bonferroni = alpha / num_comparisons; % Bonferroni corrected alpha level
significant = p <= alpha_bonferroni;
plot(Xf, (significant) * 100 - 100 + v(3) * .95, 'k.', 'MarkerSize', 15)
axis(v) % restore axis limits to hide non-significant points
xlim(time_range)
plot([v(1) v(2)], [0 0], 'k--') % add horizontal line at zero
set(gca, 'LineWidth', 1, 'FontSize', 14, 'YGrid', 'on', 'Layer', 'Top')
xlabel('Time in ms', 'FontSize', 16)
ylabel('Relative Change', 'FontSize', 16) % Corrected y-axis label
title('Difference Between Conditions (All Subjects)', 'FontSize', 18)
box on
legend({'Mean Difference', '95% CI'}, 'Location', 'Northeast')

% --------------------------------------------------------------------------
subplot(3,2,4); hold on % plot individual differences only ********************************
Ns = size(tfr_sync_all, 2); % number of participants
cc = viridis(Ns); % set viridis colormap
text(0.02, .94, 'D', 'FontSize', 24, 'FontWeight', 'bold', 'Units', 'normalized')
for S = 1:Ns
    plot(Xf, squeeze(c1(:, :, S) - c2(:, :, S)), 'Color', cc(S, :)) % PLOT DIFFERENCE FOR EVERY SUBJECT <<<<
end
% Add elements
v = axis; % get current axis limits
plot(Xf, (significant) * 100 - 100 + v(3) * .95, 'k.', 'MarkerSize', 15)
axis(v) % restore axis limits to hide non-significant points
xlim(time_range)
plot([v(1) v(2)], [0 0], 'k--') % add horizontal line at zero
set(gca, 'LineWidth', 1, 'FontSize', 14, 'YGrid', 'on', 'Layer', 'Top')
xlabel('Time in ms', 'FontSize', 16)
ylabel('Relative Change', 'FontSize', 16) % Corrected y-axis label
title('Individual Differences Between Conditions', 'FontSize', 18)
box on

% Save the figure as SVG
saveas(gcf, 'Z:\longevity_2024\results\hana\summary_figure.svg')
