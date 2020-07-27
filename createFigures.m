function createFigures(subjectList, nCleanTrials,badSensors,groupMean_hepERP)
figure
bar(subjectList,nCleanTrials);
xlabel('subject index');
ylabel('number of clean trials for averaging');
figure
for i = 1:length(subjectList)
    disp(subjectList(i));
    disp(badSensors{i});
end

plot(groupMean_hepERP)