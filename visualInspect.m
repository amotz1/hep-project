function EEG = visualInspect(EEG)
setname = EEG.setname;
chanlocs = EEG.chanlocs;
string = "";
visual_rejected = false;
while string ~= 'Y'
    if exist('visualInspectedData','var')
        disp('raw data for examination only');
        browseData(visualInspectedData)
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
