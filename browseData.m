function cleanData = browseData(data_set,visualInspection)
switch nargin
    case 1
        if isfield(data_set,'data')
            [data, ~] = eeglab2fieldtrip_lior(data_set,'preprocessing');
        end
        cfg = [];
        cfg .channel = {'all'};
        cfg.alim = 5e-5; 
        cfg.viewmode = 'vertical';
        cfg.continuous = 'yes';
        cfg.layout = 'biosemi64.lay';
        data.cfg = cfg;
        cfg = ft_databrowser(cfg, data);
    
    case 2 
        if cmprstr(visualInspection,'visualInspection')
            
            if isfield(data_set,'data')
                [data, ~] = eeglab2fieldtrip_lior(data_set,'preprocessing');
            end
            cfg = [];
            cfg .channel = {'all'};
            cfg.alim = 5e-5; 
            cfg.viewmode = 'vertical';
            cfg.continuous = 'yes';
            cfg.layout = 'biosemi64.lay';
            data.cfg = cfg;
            cfg = ft_databrowser(cfg, data);
            cfg.artfctdef.reject = 'partial';
            cleanData = ft_rejectartifact(cfg, data);
        else
            error('unspecified method for browseData')
        end
end
end