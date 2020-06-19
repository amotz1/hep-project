function EEG = downsample512(EEG)
downsrate = 512;
%--- resample to downsrate Hz
if EEG.srate ~= downsrate
    fEEG = pop_resample( EEG, downsrate );
    fEEG.chanlocs = EEG.chanlocs;
    EEG = fEEG;
end