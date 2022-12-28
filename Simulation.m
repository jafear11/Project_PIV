directory = dir('Merge-Dataset\Masks-Ideal\*.bmp');
path = what('Merge-Dataset\Masks-Ideal').path;
errors = zeros(1,length(directory));
guesses = zeros(1, length(directory));
classError = zeros(6,6);
smoothWindow = 1:10:100;
maxWindow = 0.001:0.05:0.21;
threshold = 0.05:0.05:0.3;
simlength = length(smoothWindow)*length(maxWindow)*length(threshold);
ERROR = zeros(1,simlength);
for a=1:length(smoothWindow)
    for b=1:length(maxWindow)
        for c=1:length(threshold)

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            for k = 1:length(directory)
                file = strcat(path,'\' ,directory(k).name);
                image = ~imread(file);
                [M,N] = size(image);
                num = str2num(directory(k).name(1));
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
                [distances, guess] = distance(image,handCenter, smoothWindow(a), maxWindow(b), threshold(c));
                guesses(k) = guess;
                errors(k) = guess - num;
                classError(guess +1, num +1) = classError(guess +1,num +1) + 1;
            end
            fscore = zeros(1,6);
            fprintf('\n \n')
            for i= 1:6
                precision = classError(i,i)/sum(classError(i,:));
                recall = classError(i,i)/sum(classError(:,i));
                fscore(i) = 2*(precision*recall)/(recall+precision);
            end
            fprintf("\n   GENERAL F-SCORE: %1.2f \n", mean(fscore));
            ERROR(a*b*c) = geomean(fscore);
        end
    end
end


