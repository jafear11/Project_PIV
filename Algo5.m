directory = dir('Validation-Dataset\Masks-Ideal\*.bmp');
path = what('Validation-Dataset\Masks-Ideal').path;

for k = 1:length(directory)
    file = strcat(path,'\' ,directory(k).name);
    image = imread(file);

    %Calculate distance
    D= bwdist(image);
    Final= D>20;
    %Get centroid
    labeledImage = bwlabel(Final);
    measurements = regionprops(labeledImage, Final, 'Centroid');
    centerOfMass = measurements.Centroid;
    %Plot centroid
    contorns = edge(image);
    figure(1);
    imshow(contorns);
    hold on
    plot(centerOfMass(1),centerOfMass(2),'ro');
    hold off
    
    %Calculate distance to centroid
    boundaries = bwboundaries(image, 'noholes');
    boundaries = boundaries{1};
    x=boundaries(:,1);
    y=boundaries(:,2);
    distances = sqrt((x - centerOfMass(1)).^2 + (y - centerOfMass(2)).^2);

    %Plot distance
    figure(2);
    plot(distances);
    pause(3);
end

