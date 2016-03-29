function [cutoff] = cutoffDetection(peaks)
for cutoff = 2:12
    [h1,h2] = hist(peaks,cutoff);
    if(sum(h1<1) > 0)
        break;
    end
end

end