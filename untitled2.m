
directory = dir('Validation-Dataset\Masks-Ideal\*.bmp');
path = what('Validation-Dataset\Masks-Ideal').path;

for k = 1:length(directory)
    file = strcat(path,'\' ,directory(k).name);
    image = ~imread(file);
    measurements = regionprops(image, 'BoundingBox');
    if(measurements(1).BoundingBox(3) < measurements(1).BoundingBox(4))
        counts = sum(image,2);
        j = find(counts>mean(nonzeros(counts))*1.3);
        if(length(j))
            test = image((1:j(1)),:);
        else
            test = image;
        end

    else
        counts = sum(image, 1);
        j = find(counts>mean(nonzeros(counts))*1.3);
        if(length(j))
            test = image(:,(j(1):size(image)(1)));
        else
            test = image;
        end
    end

    imshow(test)
    pause(0.3)
end