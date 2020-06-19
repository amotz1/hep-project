function testing_raw()
%% loading the data and setting some constants
subjects = [43, 56 ,57]; % vector of subjects numbers

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
    EEG = ecgReference(EEG);
    EEG = eegReference(EEG);
    EEG = visualInspect(EEG);
    [hepMat,rejectedTrials] = hepTrialsHbd(EEG);
    disp('number of rejected channels');
    disp(rejectedTrials);
    disp('size of hepMat');
    disp(size(hepMat));
    disp(EEG);
    %visualize_matrix(hepMat,EEG)
    [dataChanInterpulated, interpsensvec]  = scadsAK_3dchan(hepMat, EEG.chanlocs(1:64));
    [dataClean, NGoodtrials, badTrialsIndex ] = scadsAK_3dtrials(dataChanInterpulated);
    disp('size of the clean data');
    disp(size(dataClean));
    disp('bad channels');
    disp(interpsensvec);
    %visualize_matrix(dataClean, EEG);
    ROI_average = calculate_ROI_average(baselineWindowInSamples, dataClean);
    cutoff = i;
    filename = sprintf('C:\\Users\\amotz\\amotz\\for_nava\\hep_project\\hbd_variables\\testingpipeline\\raw\\%0.1ROI_average.mat',cutoff);
    save(filename, 'ROI_average')
    group_hepERP(:,i) = ROI_average;
    figure 
    plot(ROI_average)
    finalHep = mean(ROI_average(500:600));
    %% saving the variable final hep
    cutoff = i;
    filename = sprintf('C:\\Users\\amotz\\amotz\\for_nava\\hep_project\\hbd_variables\\testingpipeline\\raw\\%0.1finalHep.mat',cutoff);
    save(filename, 'finalHep')
end
groupMean_hepERP = nanmean(group_hepERP(:,:),2);
plot(groupMean_hepERP)
