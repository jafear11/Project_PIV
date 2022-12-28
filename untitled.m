directory = dir('Training-Dataset\Masks-Ideal\*.bmp');
path = what('Training-Dataset\Masks-Ideal').path;
for k = 1:length(directory)
    file = strcat(path,'\' ,directory(k).name);
    image = ~imread(file);
    [M,N] = size(image);
    D = bwdist(~image);
    D = rescale(D);
    conjunts = D>0.7;
    labeledImage = bwlabel(conjunts);
    measurements = regionprops(labeledImage, conjunts);
    T = struct2table(measurements);
    T = sortrows(T, 'Area', 'descend');
    measurements = table2struct(T);
    if(length(T.Area) > 1 && T.Area(2) >10)
        [armCenter, handCenter] = measurements.Centroid;
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
        [cropped, handCenter] = cropImage(handCenter,image);
        figure(1); imshow(image);
        hold on
        plot(armCenter(1), armCenter(2), 'b*')
        plot(handCenter(1), handCenter(2), 'r*')
        hold off
        %distance(image,handCenter);
        distance(cropped,center);
        figure(3); imshow(cropped);
        hold on
        plot(center(1), center(2), 'r*')
        hold off

    else
        labeledImage = bwlabel(image);
        measurements = regionprops(labeledImage, image);
        T = struct2table(measurements);
        T = sortrows(T, 'Area', 'descend');
        measurements = table2struct(T);
        handCenter = measurements.Centroid;
        figure(1); imshow(image);
        hold on
        plot(handCenter(1), handCenter(2), 'r*')
        hold off
        %distance(image, handCenter);
    end
    pause;
end