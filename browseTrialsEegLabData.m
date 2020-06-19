function browseTrialsEegLabData(data_set)
[data, ~] = eeglab2fieldtrip_lior(data_set,'preprocessing');
% peakSamples = R_peaks_detection_and_properties(data.trial{1}(67,:), data.fsample);
cfg = [];
% cfg.trialdef.prestim        = -0.2; 
% cfg.trialdef.poststim       = +0.6;
% cfg.dataset                 = 'C:\Users\amotz\amotz\for_nava\ecg\hbd_datasets\55\HBDshort_55.bdf';
% cfg.trialfun                = 'ft_trialfun_general'; 
% cfg.trialdef.eventtype      = 'ecg';
% cfg.trialdef.eventvalue     = [3 ,4]; 
%  
% [cfg] = ft_definetrial(cfg);
startTrial = (1:size(data.trial{1},2):size(data.trial{1},2)*size(data.trial,2))';
endTrial = (size(data.trial{1},2):size(data.trial{1},2):size(data.trial{1},2)*size(data.trial,2))';
offset = 200*ones(size(data.trial,2),1);
trl = [startTrial endTrial offset];
cfg.trl = trl;
cfg .channel = {'all'};
% cfg.channel = {'all', '-EXG1', '-EXG2', '-EXG3', '-EXG4', '-EXG4', '-EXG5', '-EXG6', '-EXG7', '-EXG8'};
cfg.alim = 5e-5; 
cfg.viewmode = 'vertical';
cfg.continuous = 'no';
cfg.layout = 'biosemi64.lay';
data.cfg = cfg;
ft_databrowser(cfg, data);