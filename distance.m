
function [distances, numMax] = distance(image, centroid)
%     [M, N] = size(image);
%     M = round(0.01*M);
%     filter = ones(M,1);
%     image = imclose(image, filter);
%     imshow(image)
    boundaries = bwboundaries(image, 'noholes');
    %In case of more than one object, the hand is always the one with the
    %largest perimeter
    if(length(boundaries) > 1)
        for i=1:length(boundaries)
            [~, I] = sort(cellfun(@length, boundaries), 'descend');
            boundaries = boundaries(I);
        end
    end
    x=boundaries{1}(:,1);
    y=boundaries{1}(:,2);

    %We get the distance
    distances = sqrt((x - centroid(1)).^2 + (y - centroid(2)).^2);

    %We smooth the distance to take out some noise, and we also establish
    % a minimum threshold

    %smoothWindow = 70;
    smoothWindow = round(0.05*length(distances));
%     m = 0.0267;
%     n = 46.67;    
    %smoothWindow = m*length(distances)+n;
    smoothDistance = smooth(distances, smoothWindow);
    top = movmin(distances, 0.28*length(distances));
    top = distances - top;
    top = smooth(top, smoothWindow);
    threshold = min(top) + (max(top) - min(top))*0.25;
    top = top - threshold;
    top(top<0) = 0;
    max2 = islocalmax(top);
    thr = 0.2;
    threshold = min(smoothDistance) + (max(smoothDistance) - min(smoothDistance))*thr;
    smoothDistance(smoothDistance < threshold) = 0;

    %We get the maxima of the distance
    maxima = islocalmax(smoothDistance);

    %We establish that two maxima can appear in less than 10% of the
    %perimeter in separation, so we eliminate them.

    window = round(0.10 * length(maxima));
    for i = 1:5:(length(maxima)-window)
        if(sum(maxima(i : (i + window))) > 1)
            maxima(i : (i+window)) = 0;
        end
    end

    %We take out one maxima because it corresponds to the arm
    numMax = sum(nonzeros(maxima)) - 1;

    %The number of fingers can't be more than 5 or less than zero
    if(numMax >5)
        numMax = 5;
    end
    if(numMax <0)
        numMax =0;
    end

    %Plot the final result
    x = 1:length(distances);
    figure(2);
    plot(x,smoothDistance, 'b', x(maxima),smoothDistance(maxima), 'r*');
    hold on
    plot(x, distances, 'r--')
    plot(x, top, 'g', x(max2), top(max2), 'b*')
    hold off
end