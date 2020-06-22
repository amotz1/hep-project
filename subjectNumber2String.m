function subjectString = subjectNumber2String(i)
subjectNumber = i; % Enter subject number here, if the script doesnt run following the previous one
    
    if subjectNumber<10
        subjectString = ['0' num2str(subjectNumber)];
    else
        subjectString = num2str(subjectNumber);
    end