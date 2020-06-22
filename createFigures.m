function createFigures(subjectList,nCleanTrials,nBadChannels,groupMean_hepERP)
figure
bar(subjectList,nCleanTrials);
xlabel('subject index');
ylabel('number of clean trials for averaging');
figure
bar(subjectList,nBadChannels)
xlabel('subjects index')
ylabel('bad channels number')
figure
plot(groupMean_hepERP)