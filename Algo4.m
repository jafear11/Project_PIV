
%%%%%%%%%%%%%%%% Algorithm 4 %%%%%%%%%%%%%%%%

estimations = dir('.\Masks\*.bmp');
masks = dir('Validation-Dataset\Masks-Ideal\*.bmp');
path_2 = what('Validation-Dataset\Masks-Ideal\').path;

TP=0;
P=0;
T=0;

for k = 1:length(estimations)

    %Load the masks (real and estimated)
    file = strcat('Masks\' ,estimations(k).name);
    estimation = imread(file);
    estimation = im2double(estimation);
    file = strcat(path_2,'\' ,masks(k).name);
    real_mask = imread(file);
    [M,N]= size(estimation);

    for i=1:M
        for j=1:N
            if(estimation(i,j) == 0)
                P=P+1;
                if(estimation(i,j) == real_mask(i,j))
                    TP=TP+1;

                end
            end
            if(real_mask(i,j) == 0)
                T=T+1;
            end

        end
    end
end

%Compute the quality measurements
Precision = TP/P;
Recall = TP/T;
F_score = 2*Precision*Recall/(Precision+Recall);

%Display the results
fprintf("Precision: " + Precision + '\n' ...
    +"Recall: " + Recall + '\n' ...
    + "F-Score: " +  F_score + '\n')
clear



