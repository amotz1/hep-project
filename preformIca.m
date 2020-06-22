function EEG = preformIca(EEG,chanlocs)
[data, ~] = eeglab2fieldtrip_lior(EEG,'preprocessing');
cfg = [];
cfg.channel = {'all'};
cfg.method = 'sobi';
comp = ft_componentanalysis(cfg, data);
%% browse Ica
cfg = [];
cfg.layout = 'biosemi64';
cfg.viewmode = 'component';
trl = [1 size(comp.trial{1},2) 0];
comp.cfg.trl = trl;
ft_databrowser(cfg, comp);

%% rejecting components
cnt = 0;
componentsArray = zeros(1,10);
while 1
    cnt = cnt+ 1;
    stop = input('is this  the last component? answer with y or n','s');
    if strcmp(stop,'y')
        break;
    else
        componentsArray(cnt) = input('please etner the component you want to reject');
    end
end
componentsArray = componentsArray(1:cnt);
cfg.component = componentsArray;
[data] = ft_rejectcomponent(cfg, comp, data);
 EEG = fieldtrip2eeglab_moran(data);
 EEG.chanlocs = chanlocs(1:64);