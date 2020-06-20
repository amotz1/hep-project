function saveSubjectsHep()
%% loading the data and setting some constants
subjects = [55, 43, 56]; % vector of subjects numbers 
nCleanTrials = [];
nBadChannels = [];
subjectList = [];
stringFormatAddition = [];
for i=subjects
    
    subjectNumber = i; % Enter subject number here, if the script doesnt run following the previous one
    
    if subjectNumber<10
        subjectNumberString = ['0' num2str(subjectNumber)];
    else
        subjectNumberString = num2str(subjectNumber);
    end

    %% Load file
    
    baseDirectory =  'C:\Users\amotz\amotz\for_nava\hep_project\hbd_datasets_fileio' ; % 'E:\IOA_backup_03102019\';
    folderName = [baseDirectory '\']; % enter folder's name % InwardsOutwardsAttention\ProcessedData\restingState\
    filename = ['HBD_' subjectNumberString]; % change filename ass needed %'_IOA_resting_state'
    
    fprintf('Loading %s.mat ...', filename)
    load([folderName filename '.mat'], 'EEG')
    fprintf(' Done.\n')
    baselineTimeWindow = [-200 -50];  % in ms'. for baseline correction
    rPeak = 200; %in ms' 
    baselineWindowInSamples= ceil((baselineTimeWindow + rPeak) * EEG.srate/1000) +1;
    chanlocs = EEG.chanlocs;
    setname = EEG.setname;
    events = EEG.event;
    % EEG = baseline_removal(EEG);
    %%
    % EEG = downsample512(EEG);
    ecg = EEG.data(69,:);
    EEG = convert2_EEGWithoutECG(EEG);
    EEG = pop_eegfiltnew(EEG,0.5,0,[],0,[]);
    EEG = pop_eegfiltnew(EEG,0,30,[],0,[]);
    EEG = convert2_73_EEG(EEG,ecg,chanlocs,events,setname);
    EEG = ecgReference(EEG);
    EEG = eegReference(EEG);
    EEG = visualInspect(EEG);
    ecg = EEG.data(69,:);
    EEG = convert2_64_electrodes(EEG);
    data = preformIca(EEG);
    EEG = fieldtrip2eeglab_moran(data);
    EEG.chanlocs = chanlocs(1:64);
    [hepMat] = hepTrialsHbd2(EEG,ecg);
    %visualize_matrix(hepMat,EEG)
    [dataChanInterpulated, interpsensvec]  = scadsAK_3dchan_reporting_failed_interpolation(hepMat, EEG.chanlocs(1:64),i);
    [dataClean, NGoodtrials, badTrialsIndex ] = scadsAK_3dtrials(dataChanInterpulated);
    nCleanTrials = [nCleanTrials NGoodtrials];
    if size(nBadChannels,2) < length(interpsensvec)
        nBadChannels = [nBadChannels  zeros(size(nBadChannels,1),length(interpsensvec)- size(nBadChannels,2))'];
    else
        interpsensvec = [interpsensvec zeros(size(nBadChannels,2)-length(interpsensvec),1)'];
    end
    nBadChannels = [nBadChannels ; interpsensvec];
    subjectList = [subjectList subjectNumber];
    %visualize_matrix(dataClean, EEG);
    ROI_average = calculate_ROI_average(baselineWindowInSamples, dataClean);
    filename = sprintf('C:\\Users\\amotz\\amotz\\for_nava\\hep_project\\hbd_variables\\testingpipeline\\%dROI_average.mat',subjectNumber);
    save(filename, 'ROI_average')
    group_hepERP(:,i) = ROI_average;
    figure 
    plot(ROI_average)
    finalHep = mean(ROI_average(500:600));
    %% saving the variable final hep
    filename = sprintf('C:\\Users\\amotz\\amotz\\for_nava\\hep_project\\hbd_variables\\testingpipeline\\%dfinalHep.mat',subjectNumber);
    save(filename, 'finalHep')
end
figure
bar(subjectList,nCleanTrials);
xlabel('subject index');
ylabel('number of clean trials for averaging');
figure
bar(subjectList,nBadChannels)
xlabel('subjects index')
ylabel('bad channels number')
groupMean_hepERP = nanmean(group_hepERP(:,:),2);
for i = 1:size(subjectList,2)
 stringFormatAddition = [stringFormatAddition " %d" + " %d"]; 
end
stringFormatAddition = stringFormatAddition.join;
filename = sprintf('C:\\Users\\amotz\\amotz\\for_nava\\hep_project\\hbd_variables\\saveSubjectsHep\\groupMean_hepERP for subjects' + stringFormatAddition +".mat",subjectList);
save(filename, 'groupMean_hepERP')
figure
plot(groupMean_hepERP)
