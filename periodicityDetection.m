%BPF based Pitch Extraction
function avgPitch = periodicityDetection(bpfSSS)
%syms x1;
%syms x2;

%     posPeaks = findpeaks(bpfSSS);
%     posPeaks = posPeaks(posPeaks > 0);
%     temp1 = bpfSSS .* -1;
%     negPeaks = findpeaks(temp1);
%     negPeaks = negPeaks(negPeaks > 0);
%     if(length(negPeaks) < length(posPeaks))
%         bpfSSS = bpfSSS .* -1;
%     end
if(length(bpfSSS) > 300)
    flag = validateInversion(bpfSSS);
    if(flag == 0)
        bpfSSS = bpfSSS .* -1;
    end
    frame = 300; %in samples
    bpfSSS(bpfSSS<0) = 0;
    bpfSSS = bpfSSS .* bpfSSS;
    t1 = floor(size(bpfSSS,1)/frame);
    energy = sum(reshape(bpfSSS(1:frame*t1),[frame t1]));
    
    [h1,h2] = hist(energy);
    
    for i = size(h1,2):-1:1
        t1 = sum(h1(i:(size(h1,2))));
        if(t1 > 2)
            break;
        end
    end
    minHeight = h2(i);
    
    [~,index] = find(energy > minHeight);
    index = (index-1)*frame+1;
    
    
    t1 = 1;
    pitchCandidate = [];
    for i = 1:size(index,2)
        
        if((index(1,i)+400) > length(bpfSSS))
            temp1 = bpfSSS;
        elseif(((index(1,i)+1000) < length(bpfSSS)))
            temp1 = bpfSSS(index(1,i):index(1,i)+1000);    
        else
            temp1 = bpfSSS(index(1,i):index(1,i)+400);
        end
        peaks = findpeaks(temp1);
        cutoff = cutoffDetection(peaks);
        [h1,h2] = hist(peaks,cutoff);
        ind1 = find(h1 == 0);
        if(sum(h1(ind1:end)) < 3)
            peaks = peaks(peaks < h2(ind1));
            cutoff = cutoffDetection(peaks);
            [h1,h2] = hist(peaks,cutoff);
            ind1 = find(h1 == 0);
            threshold = h2(ind1(end));
            if(sum(h1(ind1(end):end)) > 10)
                peaks = peaks(peaks > threshold);
                cutoff = cutoffDetection(peaks);
                [h1,h2] = hist(peaks,cutoff);
                ind1 = find(h1 == 0);
                threshold = h2(ind1(end));
            end
            
        else
            %if(sum(h1(ind1:end)) < 6)
            threshold = h2(ind1(end));
            if(sum(h1(ind1(end):end)) > 9)
                peaks = peaks(peaks > threshold);
                cutoff = cutoffDetection(peaks);
                [h1,h2] = hist(peaks,cutoff);
                ind1 = find(h1 == 0);
                threshold = h2(ind1(end));
            end
            
        end
        %figure;
        %findpeaks(temp1,'MinPeakHeight',threshold)
        [~,ind] = findpeaks(temp1,'MinPeakHeight',threshold);
        diffInd = diff(ind);
        
        medianDiffInd = median(diffInd);
        deviation = sum(abs(medianDiffInd - diffInd))/length(diffInd);
        if(deviation > 5)
            dev = diffInd - medianDiffInd;
            diffInd  = diffInd((abs(dev) < 10));
            
        end
        
        diffDiffInd = diff(diffInd);
        diffDiffInd = diffDiffInd(abs(diffDiffInd) > 2);
        signDiffDiffInd = sign(diffDiffInd);
        signDiffDiffInd(2:2:end) = signDiffDiffInd(2:2:end)*-1;
        sumSign = sum(signDiffDiffInd);
        if(sumSign > length(diffInd)/2)
            diffInd = [];
        end
        
        
        pitchCandidate(t1:t1+length(diffInd)-1) = diffInd;
        t1 = t1 + length(diffInd);
        
    end
    
    medianPitchCandidate = median(pitchCandidate);
    pitchCandidate = pitchCandidate(abs(pitchCandidate - medianPitchCandidate) < 20);
    pitchDeviation = max(pitchCandidate) - min(pitchCandidate);
    avgPitch = sum(pitchCandidate)/length(pitchCandidate);
    
else
    avgPitch = -1;
end
end