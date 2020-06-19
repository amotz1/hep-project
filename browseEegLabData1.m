function browseEegLabData1(data_set)
if isfield(data_set,'data')
    [data, ~] = eeglab2fieldtrip_lior(data_set,'preprocessing');
end
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
cfg .channel = {'all'};
cfg.alim = 5e-5; 
cfg.viewmode = 'vertical';
cfg.continuous = 'yes';
cfg.layout = 'biosemi64.lay';
% cfg.trl = [1 size(data.trial{1},2) 0];
data.cfg = cfg;
ft_databrowser(cfg, data);