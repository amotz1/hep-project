function EEG = ecgReference(EEG)
reference = 'heart';
if strcmp(reference,'heart')
   EEG.data(69,:) =  EEG.data(69, :) -  EEG.data(68, :);
   EEG.data(68, :) =  EEG.data(68, :) -  EEG.data(68, :);
   disp('success')
elseif strcmp(reference,'right_mastoid')
       EEG.data(69,:) =  EEG.data(69, :) -  EEG.data(66, :);
else
    error('unspecified reference');
end