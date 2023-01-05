path = uigetdir;
directory = dir(strcat(path, '\*.bmp'));
classError = zeros(6,6);
fscore = zeros(1,6);
fileID = fopen('resultats.csv', 'w');
for k = 1:length(directory)
    name = directory(k).name;
    fprintf(fileID, '%s, ', name);
    file = strcat(path,'\' ,name);
    image = ~imread(file);
    num = str2double(name(1));

    %Get rid of rings
    [~,numRegions] = bwlabel(image);
    if(numRegions >1)
        image = imclose(image,ones(6,1));
    end

    %Compute distance, then get pixels over a threshold
    D = bwdist(~image);
    D = rescale(D);
    conjunts = D>0.7;
    image = D>0.1;

    %Find the regions and compute centroids (order by region area)
    labeledImage = logical(conjunts);
    measurements = regionprops(labeledImage, conjunts);
    T = struct2table(measurements);
    T = sortrows(T, 'Area', 'descend');
    measurements = table2struct(T);

    %%%%%%%%%CROPPING%%%%%%%%%%%%
    %Only when there are two regions larger than 10 pixels
    if(length(T.Area) > 1 && T.Area(2) >10)
        [armCenter, handCenter] = measurements.Centroid;

        %The hand centroid is the one fartherst away from edges
        [M,N] = size(image);
        if(any(image(:,1)))
            if(armCenter(1) > handCenter(1))
                aux = armCenter;
                armCenter = handCenter;
                handCenter = aux;
            end
        end
        if(any(image(M,:)))
            if(armCenter(2) < handCenter(2))
                aux = armCenter;
                armCenter = handCenter;
                handCenter = aux;
            end
        end

        [image, handCenter] = cropImage(handCenter,image); %See cropImage
        guess = tophat(image, handCenter); %See tophat

        %Because we detected an arm, substract its maximum
        guess = guess -1;
        if(guess < 0)
            guess = 0;
        end
    else
        %In case of no arm, compute general centroid
        labeledImage = logical(image);
        measurements = regionprops(labeledImage, image);
        T = struct2table(measurements);
        T = sortrows(T, 'Area', 'descend');
        measurements = table2struct(T);
        handCenter = measurements.Centroid;

        guess = tophat(image, handCenter); %See tophat
        if(guess > 5)
            guess = 5;
        end

    end
    fprintf(fileID, '%d\n', guess);
    
    %Plot the cropped hand
    figure(1); 
    imshow(image);
    hold on
    plot(handCenter(1), handCenter(2), 'r*')
    title("Estimation: " + guess);
    hold off
    classError(guess +1, num +1) = classError(guess +1,num +1) + 1;   
end
for i= 1:6
    precision = classError(i,i)/sum(classError(i,:));
    recall = classError(i,i)/sum(classError(:,i));
    fscore(i) = 2*(precision*recall)/(recall+precision);
    fprintf("F-Score for finger %i : %1.2f  [P = %1.2f, R = %1.2f] \n",  i-1, fscore(i), precision, recall);
end
fprintf('\n \n')
fprintf("GENERAL F-SCORE: %1.2f \n\n", mean(fscore));
fprintf("GEOMETRIC F-SCORE: %1.2f \n\n", geomean(fscore));
fprintf("Classification Error: \n");
disp(classError);
fclose(fileID);
clear
close all


