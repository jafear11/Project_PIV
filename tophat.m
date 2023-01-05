function [numMax] = tophat(image, handCenter)
    boundaries = bwboundaries(image, 'noholes');
    if(length(boundaries) > 1)
        for i=1:length(boundaries)
            [~, I] = sort(cellfun(@length, boundaries), 'descend');
            boundaries = boundaries(I);
        end
    end
    x=boundaries{1}(:,1);
    y=boundaries{1}(:,2);
    distances = sqrt((x - handCenter(1)).^2 + (y - handCenter(2)).^2);
    minimum = find(distances == min(distances));
    conc = cat(1, distances, distances);
    distances = conc(minimum:minimum+length(distances));
    L = length(distances);
    topWindow = round(0.3*L);
    top = movmin(distances, topWindow);
    top = distances - top;
    smoothWindow = round(0.02*L);
    top = smooth(top, smoothWindow);
    threshold = min(top) + (max(top) - min(top))*0.3;
    top = top - threshold;
    top(top<0) = 0;
    figure(2);
    plot(distances, 'r--')
    hold on
    plot(top,'b');
    hold off
    numMax = 0;
    i= 0;
    while(i<L)
        i = i+1;
        if(top(i) ~= 0)
            ini = i;
            while(top(i) ~= 0 && i<L)
                i = i+1;
            end
            fin = i;
            cut = top(ini:fin);
            maxima = max(cut);
            if(maxima > 0.1*max(top) && maxima/(fin-ini)>0.1)
                numMax = numMax +1;
            end
        end
    end
end