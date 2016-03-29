function flag = validateInversion(bpfSSS)

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
