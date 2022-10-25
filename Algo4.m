
%%%%%%%%%%%%%%%% Algorithm 4 %%%%%%%%%%%%%%%%

estimations = dir('.\Masks\*.bmp');
masks = dir('Validation-Dataset\Masks-Ideal\*.bmp');
path_2 = what('Validation-Dataset\Masks-Ideal\').path;


TP=0;
FP=0;
FN=0;

for k = 1:length(estimations)
    file = strcat('Masks\' ,estimations(k).name);
    image = imread(file);
    file = strcat(path_2,'\' ,masks(k).name);
    mask = imread(file);
    [M,N]= size(image);

    for i=1:M
        for j=1:N
            if (image(i,j) == mask(i,j) && ~image(i,j))
                    TP=TP+1;
            elseif(image(i,j))
                FN=FN+1;
            else
                FP=FP+1;
            end
        end
    end

end

Precision = TP/(TP+FP);
Recall = TP/(TP+FN);
F_score = 2*(Precision*Recall)/(Precision+Recall);

fprintf("Precision: " + Precision + '\n'+"Recall: " + Recall + '\n'+ "F-Score: " +  F_score + '\n')



