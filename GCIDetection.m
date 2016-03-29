function [GCILoc] = GCIDetection(filename)
% filename - wav file is given as input
b = load('filter.mat');
[speechSig,Fs] = audioread(filename);

% Peak Emphasis

timeAxis = (1:length(speechSig))/Fs;
speechSig = [speechSig;zeros(4938,1)];
bpfSSS = filter(b,1,speechSig);
flag = validateInversion(bpfSSS);

speechSig = speechSig(1:end-4936);
bpfSSS = bpfSSS(4937:end);
minHeight = max(bpfSSS)/12;
if(flag == 0)
    bpfSSS = bpfSSS .* -1;
    minHeight = max(bpfSSS)/12;
end

[peaks,ind] = findpeaks(bpfSSS,'MinPeakHeight',minHeight);
%findpeaks(bpfSSS,'MinPeakHeight',max(bpfSSS)/9)

diffInd = diff(ind);
% minimum 62.5 ms there should not be any voice
silThreshold = Fs * 0.0625;
% Location of Index
locInd(1,:) = [ind(1); ind(find(diffInd > silThreshold)+1)];
locInd(2,:) = [ind(diffInd > silThreshold); ind(end)];

previous = 0;
GCILoc = [];
for i = 1:size(locInd,2)
    if((locInd(1,i) - 32) < 0)
        segment = bpfSSS(locInd(1,i)-3:locInd(2,i)+32);
    else
        segment = bpfSSS(locInd(1,i)-32:locInd(2,i)+32);
    end
    avgPitch = periodicityDetection(segment);
    if(avgPitch > 0)
        if(isnan(avgPitch))
            avgPitch = previous;
        else
            previous = avgPitch;
        end
        [~,ind1] = findpeaks(segment,'MinPeakDistance',avgPitch*0.8,'MinPeakHeight',minHeight);
        ind1 = ind1 + locInd(1,i) - 32 + 1;
        GCILoc = [GCILoc;ind1];
    end
end

end
