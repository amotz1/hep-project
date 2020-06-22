function EEG = loadData(subjectNumberString)
    baseDirectory =  'C:\Users\amotz\amotz\for_nava\hep_project\hbd_datasets_fileio' ; % 'E:\IOA_backup_03102019\';
    folderName = [baseDirectory '\']; % enter folder's name % InwardsOutwardsAttention\ProcessedData\restingState\
    filename = ['HBD_' subjectNumberString]; % change filename ass needed %'_IOA_resting_state'
    
    fprintf('Loading %s.mat ...', filename)
    load([folderName filename '.mat'], 'EEG');
    fprintf(' Done.\n')