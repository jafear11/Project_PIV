
function[image, handCenter] = cropImage(handCenter, image)
    [M,N]=size(image);
   
    %We get k as a function of the area. This is because for large areas we
    %guess that the hand is the primary focus
    area = regionprops(image, 'Area');
    T = struct2table(area);
    T = sortrows(T, 'Area', 'descend');
    area = table2struct(T);
    k = (area(1).Area/(M*N))*2;

    %Now we get the values for cropping, where k is a percentage of the
    %size of the image. 
    handCenter = round(handCenter);
    x1 = round(handCenter(1)-M*k);
    x2 = round(handCenter(1)+M*k);
    y1 = round(handCenter(2)-M*k);
    y2 = round(handCenter(2)+M*k);

    %We check that the values are inside the image borders
    if(x1<1)
        x1=1;
    end
    if(x2>N)
        x2=N-1;
    end
    if(y1<1)
        y1=1;
    end
    if(y2>M)
        y2=M-1;
    end

    %We crop the image and add padding
    image = image(y1:y2,x1:x2);
    image = padarray(image,[3 3],0,'both');

    %Recompute hand center
    D = bwdist(~image);
    D = rescale(D);
    conjunts = D>0.7;
    labeledImage = logical(conjunts);
    measurements = regionprops(labeledImage, conjunts);
    T = struct2table(measurements);
    T = sortrows(T, 'Area', 'descend');
    measurements = table2struct(T);
    handCenter = measurements.Centroid;

end