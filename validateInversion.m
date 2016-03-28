function flag = validateInversion(bpfSSS)

% flag = 1;
% peaks = findpeaks(bpfSSS);
% peaks = peaks(peaks > 0);
% l1 = sum(abs(diff(peaks)));
% 
% peaks = [];
% bpfSSS = bpfSSS .*-1;
% peaks = findpeaks(bpfSSS);
% peaks = peaks(peaks > 0);
% l2 = sum(abs(diff(peaks)));
% 
% if(l1 < l2)
%     flag = 0;
% end

flag = 1;
[peaks,ind] = findpeaks(bpfSSS,'MinPeakHeight',max(bpfSSS)/6);
l1 = length(ind);

peaks = [];
ind = [];
bpfSSS = bpfSSS .*-1;
[peaks,ind] = findpeaks(bpfSSS,'MinPeakHeight',max(bpfSSS)/6);
l2 = length(ind);


if(l1 > l2)
    flag = 0;
end