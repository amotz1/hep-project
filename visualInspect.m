function EEG = visualInspect(EEG)
setname = EEG.setname;
chanlocs = EEG.chanlocs;
disp('please reject artifacts if needed');
string = "";
visual_rejected = false;
while string ~= 'Y'
    if exist('visualInspectedData','var')
        browseData(visualInspectedData)
%         cfg = [];
%         cfg.channel = {'all'};
%         cfg.alim = 5e-5; 
%         cfg.viewmode = 'vertical';
%         cfg.continuous = 'yes';
%         cfg.layout = 'biosemi64.lay';
%         ft_databrowser(cfg,visualInspectedData);
    else
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
                visualInspectedData = browseData(cfg, visualInspectedData);
                visualInspectedData.trial = {[visualInspectedData.trial{:}]};
                visualInspectedData.time = {[visualInspectedData.time{:}]};
                if isfield(visualInspectedData,'sampleinfo')
                    visualInspectedData = rmfield(visualInspectedData,'sampleinfo');
                end
        else    
            visualInspectedData = browseData(EEG);
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
