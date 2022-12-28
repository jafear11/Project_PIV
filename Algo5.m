path = uigetdir;
directory = dir(strcat(path, '\*.bmp'));
errors = zeros(1,length(directory));
guesses = zeros(1, length(directory));
classError = zeros(6,6);

for k = 1:length(directory)
    file = strcat(path,'\' ,directory(k).name);
    image = ~imread(file);
    [M,N] = size(image);
    num = str2num(directory(k).name(1));
    %Busquem si podem separar palmell i braç en funció de la distància
    D = bwdist(~image);
    D = rescale(D);
    conjunts = D>0.7;
    labeledImage = bwlabel(conjunts);

    %Ordenem els conjunts de més gran a més petit
    measurements = regionprops(labeledImage, conjunts);
    T = struct2table(measurements);
    T = sortrows(T, 'Area', 'descend');
    measurements = table2struct(T);

    %CODI PER RETALLAR LA IMATGE
    %Comprovem que tenim més d'una àrea i que la segona és més gran que 10
    if(length(T.Area) > 1 && T.Area(2) >10)
        [armCenter, handCenter] = measurements.Centroid;

        %Si una part del conjunt toca la vora esquerra, llavors el
        %centroide més proper pertany al braç.
        if(any(image(:,1)))
            if(armCenter(1) > handCenter(1))
                aux = armCenter;
                armCenter = handCenter;
                handCenter = aux;
            end
        end

        %Si una part del conjunt toca la vora inferior, llavors el
        %centroide més proper pertany a braç.
        if(any(image(M,:)))
            if(armCenter(2) < handCenter(2))
                aux = armCenter;
                armCenter = handCenter;
                handCenter = aux;
            end
        end
        %Retallem la imatge i definim el centroide com a centre de la
        %imatge.
        image = cropImage(handCenter,image);
        D = bwdist(~image);
        D = rescale(D);
        conjunts = D>0.7; 
        labeledImage = bwlabel(conjunts);
        measurements = regionprops(labeledImage, conjunts);
        T = struct2table(measurements);
        T = sortrows(T, 'Area', 'descend');
        measurements = table2struct(T);
        handCenter = measurements.Centroid;
    else
        labeledImage = bwlabel(image);
        measurements = regionprops(labeledImage, image);
        T = struct2table(measurements);
        T = sortrows(T, 'Area', 'descend');
        measurements = table2struct(T);
        handCenter = measurements.Centroid;
    end
    [distances, guess] = distance(image,handCenter);
    
    figure(1); 
    imshow(image);
    hold on
    plot(handCenter(1), handCenter(2), 'r*')
    title("Estimation: " + guess);
    hold off
    guesses(k) = guess;
    errors(k) = guess - num;
    %%%% CLassification matrix
    classError(guess +1, num +1) = classError(guess +1,num +1) + 1;    
    pause();
end
fscore = zeros(1,6);
fprintf('\n \n')
for i= 1:6
    precision = classError(i,i)/sum(classError(i,:));
    recall = classError(i,i)/sum(classError(:,i));
    fscore(i) = 2*(precision*recall)/(recall+precision);
    fprintf("F-Score for finger %i : %1.2f  [P = %1.2f, R = %1.2f] \n",  i-1, fscore(i), precision, recall);
end
fprintf("\n   GENERAL F-SCORE: %1.2f \n", mean(fscore));
fprintf("\n   Geometric F-Score: %1.2f \n", geomean(fscore));
clear all
close all

