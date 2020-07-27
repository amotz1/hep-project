function EEG = createNewEEG(EEG,c)
tempEEG = EEG; 
data = [];
for i = 1:length(c)
   data = [data c{i}];
end
tempEEG.data = data;
newTimes = 1:size(tempEEG.data,2);
tempEEG.times = newTimes/tempEEG.srate*1000;
tempEEG.pnts = size(tempEEG.data,2);
tempEEG.xmax = size(tempEEG.data,2)/EEG.srate;
tempEEG.setname = EEG.setname;
EEG = tempEEG;