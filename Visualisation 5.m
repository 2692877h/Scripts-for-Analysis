
%% Load
load('stat_freq');

%% Topoplot 
% HANNING : Topographic Plot for Statistical Differeneces

cm = brewermap([],'YlGnBu');  % Load the colormap
cfg = [];
cfg.layout = 'biosemi128.lay';
layout = ft_prepare_layout(cfg);  % Prepare layout

% Configuration for topoplot
cfg = [];
cfg.parameter = 'stat';
cfg.layout = layout;  % Use the loaded layout
cfg.xlim = [0 3];  % Adjust xlim
cfg.colorbar = 'yes';  % Include a colorbar
cfg.colormap = cm;  % Apply the YlGnBu colormap

% Create the figure
figure;
ft_topoplotTFR(cfg, stat_freq);
title('Hanning: Topographic Plot of Statistical Differences');

% Overlay EEG channels
hold on;  % Keep the current plot
ft_plot_layout(layout, 'label', 'yes', 'box', 'no');

% Define the frontal and parietal electrodes
frontal_electrodes = {'C4', 'C5', 'C7', 'C8', 'C11', 'C12', 'C15', 'C16', 'C17', 'C19', 'C21', 'C23', 'C24', 'C25', 'C28', 'C29', 'C30', 'D4', 'D5', 'D7', 'D8', 'D10', 'D12'};
parietal_electrodes = {'A5', 'A7', 'A10', 'A15', 'A17', 'A19', 'A21', 'A23', 'A28', 'A30', 'A32', 'B2', 'B4', 'B7', 'B10', 'B11', 'B13', 'B16', 'B18', 'B20', 'B22', 'B24', 'B26', 'B27', 'B29'};

% Plot electrode positions
for i = 1:length(layout.label)
    if ismember(layout.label{i}, frontal_electrodes)
        plot(layout.pos(i,1), layout.pos(i,2), 'o', 'Color', [0.5 0 0], 'MarkerSize', 12, 'LineWidth', 3);  % Circle frontal electrodes in dark red
    elseif ismember(layout.label{i}, parietal_electrodes)
        plot(layout.pos(i,1), layout.pos(i,2), 'o', 'Color', [0 0 0.5], 'MarkerSize', 12, 'LineWidth', 3);  % Circle parietal electrodes in dark blue
    end
end

% Change the color of the electrode labels to white
textObjects = findobj(gca, 'Type', 'text');
for i = 1:length(textObjects)
    textObjects(i).Color = 'white';
end

hold off;


%% Topoplot TFR SYNC 

load('GA_sync')
load('GA_desync')
load('GA_diff')

% Load FieldTrip
ft_defaults;

% Load your data (replace with your actual data loading code)
% load('your_data.mat');

% Define colormap
cm = brewermap([], 'YlGnBu');  % Load the colormap

% Prepare layout
cfg = [];
cfg.layout = 'biosemi128.lay';
layout = ft_prepare_layout(cfg);  % Prepare layout

% Define the frontal and parietal electrodes
frontal_electrodes = {'C4', 'C5', 'C7', 'C8', 'C11', 'C12', 'C15', 'C16', 'C17', 'C19', 'C21', 'C23', 'C24', 'C25', 'C28', 'C29', 'C30', 'D4', 'D5', 'D7', 'D8', 'D10', 'D12'};
parietal_electrodes = {'A5', 'A7', 'A10', 'A15', 'A17', 'A19', 'A21', 'A23', 'A28', 'A30', 'A32', 'B2', 'B4', 'B7', 'B10', 'B11', 'B13', 'B16', 'B18', 'B20', 'B22', 'B24', 'B26', 'B27', 'B29'};

% Configuration for topoplot
cfg = [];
cfg.xlim = [0 3];  % Time window
cfg.ylim = [4 8];  % Theta band
cfg.zlim = 'maxabs';
cfg.layout = layout;  % Use the loaded layout
cfg.marker = 'on';
cfg.colorbar = 'yes';
cfg.colormap = cm;  % Apply the YlGnBu colormap

% Topographic plot - Sync
figure;
ft_topoplotTFR(cfg, GA_sync);
title('Theta Power Across Scalp - Synchronous Condition', 'FontSize', 19);
hold on;
ft_plot_layout(layout, 'label', 'yes', 'box', 'no');

% Plot electrode positions for Sync
for i = 1:length(layout.label)
    if ismember(layout.label{i}, frontal_electrodes)
        plot(layout.pos(i,1), layout.pos(i,2), 'o', 'Color', [0.5 0 0], 'MarkerSize', 14, 'LineWidth', 5);  % Circle frontal electrodes in dark red
    elseif ismember(layout.label{i}, parietal_electrodes)
        plot(layout.pos(i,1), layout.pos(i,2), 'o', 'Color', [0 0 0.5], 'MarkerSize', 14, 'LineWidth', 5);  % Circle parietal electrodes in dark blue
    end
end

% Change the color and size of the electrode labels and other text labels
textObjects = findobj(gca, 'Type', 'text');
for i = 1:length(textObjects)
    textObjects(i).Color = 'black';
    textObjects(i).FontSize = 18;  % Increase font size of all labels
end

% Remove the "COMNT" text
delete(findobj(gcf, 'String', 'COMNT'));

% Change the color of the colorbar labels to black
hcb = colorbar;
hcb.Label.Color = 'black';  % Change color of the colorbar label
set(hcb, 'YColor', 'black');  % Change color of the colorbar ticks

% Find all text objects in the colorbar and set their color to black
colorbarTextObjects = findall(hcb, 'Type', 'text');
for i = 1:length(colorbarTextObjects)
    colorbarTextObjects(i).Color = 'black';
end

hold off;





%% Topoplot TFR  ASYNC

% Load FieldTrip
ft_defaults;

% Load your data (replace with your actual data loading code)
% load('your_data.mat');

% Define colormap
cm = brewermap([], 'YlGnBu');  % Load the colormap

% Prepare layout
cfg = [];
cfg.layout = 'biosemi128.lay';
layout = ft_prepare_layout(cfg);  % Prepare layout

% Define the frontal and parietal electrodes
frontal_electrodes = {'C4', 'C5', 'C7', 'C8', 'C11', 'C12', 'C15', 'C16', 'C17', 'C19', 'C21', 'C23', 'C24', 'C25', 'C28', 'C29', 'C30', 'D4', 'D5', 'D7', 'D8', 'D10', 'D12'};
parietal_electrodes = {'A5', 'A7', 'A10', 'A15', 'A17', 'A19', 'A21', 'A23', 'A28', 'A30', 'A32', 'B2', 'B4', 'B7', 'B10', 'B11', 'B13', 'B16', 'B18', 'B20', 'B22', 'B24', 'B26', 'B27', 'B29'};

% Configuration for topoplot
cfg = [];
cfg.xlim = [0 3];  % Time window
cfg.ylim = [4 8];  % Theta band
cfg.zlim = 'maxabs';
cfg.layout = layout;  % Use the loaded layout
cfg.marker = 'on';
cfg.colorbar = 'yes';
cfg.colormap = cm;  % Apply the YlGnBu colormap

% Topographic plot - Desync
figure;
ft_topoplotTFR(cfg, GA_desync);
title('Theta Power Across Scalp - Asynchronous Condition', 'FontSize', 16);
hold on;
ft_plot_layout(layout, 'label', 'yes', 'box', 'no');

% Plot electrode positions for Desync
for i = 1:length(layout.label)
    if ismember(layout.label{i}, frontal_electrodes)
        plot(layout.pos(i,1), layout.pos(i,2), 'o', 'Color', [0.5 0 0], 'MarkerSize', 12, 'LineWidth', 3);  % Circle frontal electrodes in dark red
    elseif ismember(layout.label{i}, parietal_electrodes)
        plot(layout.pos(i,1), layout.pos(i,2), 'o', 'Color', [0 0 0.5], 'MarkerSize', 12, 'LineWidth', 3);  % Circle parietal electrodes in dark blue
    end
end

% Change the color and size of the electrode labels and other text labels
textObjects = findobj(gca, 'Type', 'text');
for i = 1:length(textObjects)
    textObjects(i).Color = 'black';
    textObjects(i).FontSize = 14;  % Increase font size of all labels
end

% Remove the "COMNT" text
delete(findobj(gcf, 'String', 'COMNT'));

% Change the color of the colorbar labels to black
hcb = colorbar;
hcb.Label.Color = 'black';  % Change color of the colorbar label
set(hcb, 'YColor', 'black');  % Change color of the colorbar ticks

% Find all text objects in the colorbar and set their color to black
colorbarTextObjects = findall(hcb, 'Type', 'text');
for i = 1:length(colorbarTextObjects)
    colorbarTextObjects(i).Color = 'black';
end

hold off;



%% Topoplot Difference

% Define colormap
cm = brewermap([], 'YlGnBu');  % Load the colormap

% Prepare layout
cfg = [];
cfg.layout = 'biosemi128.lay';
layout = ft_prepare_layout(cfg);  % Prepare layout

% Define the frontal and parietal electrodes
frontal_electrodes = {'C4', 'C5', 'C7', 'C8', 'C11', 'C12', 'C15', 'C16', 'C17', 'C19', 'C21', 'C23', 'C24', 'C25', 'C28', 'C29', 'C30', 'D4', 'D5', 'D7', 'D8', 'D10', 'D12'};
parietal_electrodes = {'A5', 'A7', 'A10', 'A15', 'A17', 'A19', 'A21', 'A23', 'A28', 'A30', 'A32', 'B2', 'B4', 'B7', 'B10', 'B11', 'B13', 'B16', 'B18', 'B20', 'B22', 'B24', 'B26', 'B27', 'B29'};

% Configuration for topoplot
cfg = [];
cfg.xlim = [0 3];  % Time window
cfg.ylim = [4 8];  % Theta band
cfg.zlim = 'maxabs';
cfg.layout = layout;  % Use the loaded layout
cfg.marker = 'on';
cfg.colorbar = 'yes';
cfg.colormap = cm;  % Apply the YlGnBu colormap

% Topographic plot - Difference (Sync - Desync)
figure;
ft_topoplotTFR(cfg, GA_diff);
title('Theta Power Difference (Sync - Desync)', 'FontSize', 16);
hold on;
ft_plot_layout(layout, 'label', 'yes', 'box', 'no');

% Plot electrode positions for Difference
for i = 1:length(layout.label)
    if ismember(layout.label{i}, frontal_electrodes)
        plot(layout.pos(i,1), layout.pos(i,2), 'o', 'Color', [0.5 0 0], 'MarkerSize', 12, 'LineWidth', 3);  % Circle frontal electrodes in dark red
    elseif ismember(layout.label{i}, parietal_electrodes)
        plot(layout.pos(i,1), layout.pos(i,2), 'o', 'Color', [0 0 0.5], 'MarkerSize', 12, 'LineWidth', 3);  % Circle parietal electrodes in dark blue
    end
end

% Change the color and size of the electrode labels and other text labels
textObjects = findobj(gca, 'Type', 'text');
for i = 1:length(textObjects)
    textObjects(i).Color = 'black';
    textObjects(i).FontSize = 14;  % Increase font size of all labels
end

% Remove the "COMNT" text
delete(findobj(gcf, 'String', 'COMNT'));

% Change the color of the colorbar labels to black
hcb = colorbar;
hcb.Label.Color = 'black';  % Change color of the colorbar label
set(hcb, 'YColor', 'black');  % Change color of the colorbar ticks

% Find all text objects in the colorbar and set their color to black
colorbarTextObjects = findall(hcb, 'Type', 'text');
for i = 1:length(colorbarTextObjects)
    colorbarTextObjects(i).Color = 'black';
end

hold off;



%% Singleplot GA SYNC 

% Load the grand average combined data
load('Z:\longevity_2024\results\hana\averages_hana\GA_sync_combined.mat');

% Configuration for singleplotTFR
cfg = [];
cfg.baseline     = [-0.5 0]; % baseline correction
cfg.baselinetype = 'relative'; % type of baseline correction
cfg.showlabels   = 'yes'; % show labels of channels
cfg.layout       = 'biosemi128.lay'; % specify layout
cfg.xlim         = [0 3]; % time range for plotting
cfg.ylim         = [4 8]; % frequency range for plotting
cfg.zlim         = 'maxabs'; % automatic scaling based on data
cfg.colorbar     = 'yes'; % show colorbar
cfg.colormap     = cm;
% Plot the TFR
figure;
ft_singleplotTFR(cfg, GA_sync_combined);
title('Synchronous Conditions: Theta Band Time-Frequency Representation Across Selected Electrodes', 'FontSize', 12);


% Add axes labels
xlabel('Time (s)', 'FontSize', 19);
ylabel('Frequency (Hz)', 'FontSize', 19);

% Make labels larger
set(gca, 'FontSize', 20); % Increase font size for axis labels and ticks

% Find all text objects in the current figure and set their font size
textObjects = findall(gcf, 'Type', 'text');
for i = 1:length(textObjects)
    set(textObjects(i), 'FontSize', 28); % Set font size for all text objects
end

%

cfg = [];
cfg.baseline     = [-0.5 0]; % baseline correction
cfg.baselinetype = 'relative'; % type of baseline correction
cfg.showlabels   = 'no'; % do not show labels of channels
cfg.layout       = 'biosemi128.lay'; % specify layout
cfg.xlim         = [0 3]; % time range for plotting
cfg.ylim         = [4 8]; % frequency range for plotting
cfg.zlim         = 'maxabs'; % automatic scaling based on data
cfg.colorbar     = 'yes'; % show colorbar
cfg.colormap     = cm;

% Plot the TFR
figure;
ft_singleplotTFR(cfg, GA_sync_combined);

% Add axes labels
xlabel('Time (s)', 'FontSize', 14);
ylabel('Frequency (Hz)', 'FontSize', 14);

% Make labels larger
set(gca, 'FontSize', 23); % Increase font size for axis labels and ticks

% Remove unwanted text labels
textLabels = findall(gcf, 'Type', 'text');
delete(textLabels);







%%  Singleplot GA ASYNC 

load('Z:\longevity_2024\results\hana\averages_hana\GA_desync_combined.mat');

% Configuration for singleplotTFR
cfg = [];
cfg.baseline     = [-0.5 0]; % baseline correction
cfg.baselinetype = 'relative'; % type of baseline correction
cfg.showlabels   = 'no'; % do not show labels of channels
cfg.layout       = 'biosemi128.lay'; % specify layout
cfg.xlim         = [0 3]; % time range for plotting
cfg.ylim         = [4 8]; % frequency range for plotting
cfg.zlim         = 'maxabs'; % automatic scaling based on data
cfg.colorbar     = 'yes'; % show colorbar
cfg.colormap     = cm;

% Plot the TFR
figure;
ft_singleplotTFR(cfg, GA_desync_combined);

% Add axes labels
xlabel('Time (s)', 'FontSize', 14);
ylabel('Frequency (Hz)', 'FontSize', 14);

% Make labels larger
set(gca, 'FontSize', 14); % Increase font size for axis labels and ticks

% Find all text objects in the current figure and set their font size
textObjects = findall(gcf, 'Type', 'text');
for i = 1:length(textObjects)
    set(textObjects(i), 'FontSize', 14); % Set font size for all text objects
end

% Save the figure as an SVG file
saveas(gcf, 'Z:\longevity_2024\results\hana\singleplot_async_no_title.svg');


%


% Configuration for singleplotTFR
cfg = [];
cfg.baseline     = [-0.5 0]; % baseline correction
cfg.baselinetype = 'relative'; % type of baseline correction
cfg.showlabels   = 'no'; % do not show labels of channels
cfg.layout       = 'biosemi128.lay'; % specify layout
cfg.xlim         = [0 3]; % time range for plotting
cfg.ylim         = [4 8]; % frequency range for plotting
cfg.zlim         = 'maxabs'; % automatic scaling based on data
cfg.colorbar     = 'yes'; % show colorbar
cfg.colormap     = cm;

% Plot the TFR
figure;
ft_singleplotTFR(cfg, GA_desync_combined);

% Add axes labels
xlabel('Time (s)', 'FontSize', 14);
ylabel('Frequency (Hz)', 'FontSize', 14);

% Make labels larger
set(gca, 'FontSize', 23); % Increase font size for axis labels and ticks

% Remove unwanted text labels
textLabels = findall(gcf, 'Type', 'text');
delete(textLabels);

% Save the figure as an SVG file
saveas(gcf, 'Z:\longevity_2024\results\hana\singleplot_async_no_title.svg');

%% Singleplot GA SYNC - ASYNC
% Configuration for singleplotTFR
cfg = [];
cfg.baseline     = [-0.5 0]; % baseline correction
cfg.baselinetype = 'relative'; % type of baseline correction
cfg.showlabels   = 'yes'; % show labels of channels
cfg.layout       = 'biosemi128.lay'; % specify layout
cfg.xlim         = [0 3]; % time range for plotting
cfg.ylim         = [4 8]; % frequency range for plotting
cfg.zlim         = 'maxabs'; % automatic scaling based on data
cfg.colorbar     = 'yes'; % show colorbar

% Plot the TFR for difference condition
figure;
ft_singleplotTFR(cfg, GA_diff_combined);
title('Difference between Synchronous and Desynchronized conditions (Specific channels)');

% Make labels larger
set(gca, 'FontSize', 14); % Increase font size for axis labels and ticks

% Find all text objects in the current figure and set their font size
textObjects = findall(gcf, 'Type', 'text');
for i = 1:length(textObjects)
    set(textObjects(i), 'FontSize', 14); % Set font size for all text objects
end



%% plot the power spectra 

% Plot the power spectra 
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
legend('Synchronous', 'Asynchronous', 'FontSize', 20);
xlabel('Frequency (Hz)', 'FontSize', 24);
ylabel('Relative Change', 'FontSize', 24);
xlim([min(avg_pow_sync.freq) max(avg_pow_sync.freq)]);

% Increase font size for tick labels
set(gca, 'FontSize', 22);

































