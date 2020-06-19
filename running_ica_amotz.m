function running_ica_amotz()
load('C:\Users\amotz\amotz\for_nava\hep_project\hbd_datasets\hbd_mat\HBD_54.mat','EEG');
[data, ~] = eeglab2fieldtrip_lior(EEG,'preprocessing');
cfg = [];
cfg.channel = {'all', '-EXG1',  '-EXG2', '-EXG3', '-EXG4','-EXG5','-EXG6','-EXG7','-EXG8'};
cfg.method = 'sobi';
comp = ft_componentanalysis(cfg, data);
cfg = [];
cfg.layout = 'biosemi64.lay';
cfg.viewmode = 'component';
ft_databrowser(cfg, comp);

