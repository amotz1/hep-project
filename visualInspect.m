function EEG = visualInspect(EEG)
setname = EEG.setname;
chanlocs = EEG.chanlocs;
string = "";
visual_rejected = false;
while string ~= 'Y'
    if exist('visualInspectedData','var')
        disp('raw data for examination only');
        browseData(visualInspectedData)
%         cfg = [];
%         cfg.channel = {'all'};
%         cfg.alim = 5e-5; 
%         cfg.viewmode = 'vertical';
%         cfg.continuous = 'yes';
%         cfg.layout = 'biosemi64.lay';
%         ft_databrowser(cfg,visualInspectedData);
    else
        disp('raw data for examination only');
        browseData(EEG);
    end
    string = input('do you want to finish trial rejection? answer with Y for yes or any other key for no','s');
    if strcmp(string,'Y')
       break;
    else
        visual_rejected = true;
        if exist('visualInspectedData','var')
%                 cfg = [];
%                 cfg.channel = {'all'};
%                 cfg.alim = 5e-5; 
%                 cfg.viewmode = 'vertical';
%                 cfg.continuous = 'yes';
%                 cfg.layout = 'biosemi64.lay';
%                 cfg = ft_databrowser(cfg,visualInspectedData);
%                 cfg.artfctdef.reject = 'partial';
                visualInspectedData = browseData(visualInspectedData, 'visualInspection');
                visualInspectedData.trial = {[visualInspectedData.trial{:}]};
                visualInspectedData.time = {[visualInspectedData.time{:}]};
                if isfield(visualInspectedData,'sampleinfo')
                    visualInspectedData = rmfield(visualInspectedData,'sampleinfo');
                end
        else    
            visualInspectedData = browseData(EEG,'visualInspection');
            visualInspectedData.trial = {[visualInspectedData.trial{:}]};
            visualInspectedData.time = {[visualInspectedData.time{:}]};
            if isfield(visualInspectedData,'sampleinfo')
                visualInspectedData = rmfield(visualInspectedData,'sampleinfo');
            end
        end
    end
end
if visual_rejected 
    EEG = fieldtrip2eeglab_moran(visualInspectedData);
    
end
EEG.chanlocs = chanlocs;
EEG.setname = setname;
