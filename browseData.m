function cleanData = browseData(data_set,visualInspection)
switch nargin
    case 1
        if isfield(data_set,'chanlocs')
            [data_set, ~] = eeglab2fieldtrip_lior(data_set,'preprocessing');
        end
        cfg = [];
        cfg .channel = {'all'};
        cfg.alim = 5e-5; 
        cfg.viewmode = 'vertical';
        cfg.continuous = 'yes';
        cfg.layout = 'biosemi64.lay';
        cfg.trl = [1 size(data_set.trial{1},2) 0];
        data_set.cfg = cfg;
        cfg = ft_databrowser(cfg, data_set);
    
    case 2 
        if strcmp(visualInspection,'visualInspection')   
            if isfield(data_set,'chanlocs')
                [data_set, ~] = eeglab2fieldtrip_lior(data_set,'preprocessing');
            end
            cfg = [];
            cfg .channel = {'all'};
            cfg.alim = 5e-5; 
            cfg.viewmode = 'vertical';
            cfg.continuous = 'yes';
            cfg.layout = 'biosemi64.lay';
            data_set.cfg = cfg;
            cfg = ft_databrowser(cfg, data_set);
            cfg.artfctdef.reject = 'partial';
            cleanData = ft_rejectartifact(cfg, data_set);
        else
            error('unspecified method for browseData')
        end
end
end
