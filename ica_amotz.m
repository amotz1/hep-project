
% hi Amotz
% this script converts data from EEGlab 2 fieldtrip for data inspection ica
% then, it converts the data back to EEGlab format 

[data, tmpchanlocs, setname] = eeglab2fieldtrip_lior(EEG,'preprocessing');

cfg = [];
cfg.channel = {'Fp1' , 'Fp2' , 'Fpz' , 'O1', 'O2', 'Oz', 'EXG1', 'EXG2', 'EXG3', 'EXG7'};%cfg.channel = {'all'};
cfg.continuous = 'no';
cfg.layout = 'biosemi64.lay';

ft_databrowser(cfg, data);
%% ------ run ica

cfg = [];
cfg.channel = {'all', '-EXG4',  '-EXG5', '-EXG6', '-EXG8', '-Status'};
cfg.method = 'sobi';
comp = ft_componentanalysis(cfg, data);


%% -----browse components

cfg = [];
cfg.layout = 'biosemi64.lay';
cfg.viewmode = 'component';
dataview = ft_databrowser(cfg, comp);

%% ----- see one component

seeOneComp(comp);

% % to further view a specific component 
% cfg = [];
% cfg.component = [5];
% cfg.markers = 'labels';
% cfg.layout = 'biosemi64.lay';
% ft_topoplotIC(cfg,comp);

%% ---- reject components

compi = input('which component would you like to reject?\n');
cfg = [];
cfg.component = [compi];
dataica = ft_rejectcomponent(cfg, comp, data);


%% -- inspect data after ica
cfg = [];
cfg.channel = {'Fp1' , 'Fp2' , 'Fpz' , 'O1', 'O2', 'Oz', 'EXG1', 'EXG2', 'EXG3', 'EXG7'};%{'all', '-EXG4',  '-EXG5', '-EXG6', '-EXG8', 'Status'};
cfg.continuous = 'no';
cfg.layout = 'biosemi64.lay';
dataview = ft_databrowser(cfg, dataica);

%% ------ fieldtrip to eeglab

[EEG] = fieldtrip2eeglab_moran(dataica);
% EEG.chanlocs = tmpchanlocs;
EEG.chanlocs = readlocs('D:\Dropbox\Experiments\InwardsOutwardsAttention\Analysis\biosemi_channelloc_ 64.ced');
EEG.setname = setname;

close all;

%% ------ save data after ica
filenameSave = [filename '_ica'];
EEG.setname = [EEG.setname '_ica'];
fprintf('\nSaving %s ...', filenameSave)
save([folderName filenameSave '.mat'], 'EEG', 'trialInfo');
fprintf(' Done.\n\n\n')


function seeOneComp(comp_dummy)
global badTrials
% This function gets the components data from the ICA (comp_dummy)
comp=input('Which component would you like to check now?');
m=zeros(length(comp_dummy.trial),length(comp_dummy.time{1,1}));

for i=1:length(comp_dummy.trial)
    m(i,:)=comp_dummy.trial{1,i}(comp,:);
end
figure;mesh(m)
xlabel('Time resampled (X)')
ylabel('Trials (Y)')
eval(['title(''comp: ',num2str(comp),''')'])
cut = input('Do you want to enter a cutoff? [1 - yes ; 0 - no] \n');
if cut == 1
    cutOff=input('What is the cutoff (for example 1*10^(-13))? \n');
    for i=1:size(m,1)
        if sum(m(i,:)>cutOff)>0
            remTrial(i)=1;
        end
    end
    badTrials=find(remTrial==1);
    disp(['trials above threshold limitis are saved in BadTrials']);
    n=length(badTrials);
    disp(['number of trials above threshold: ',num2str(n)]);
end

end
