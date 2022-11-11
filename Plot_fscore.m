estimations = dir('.\Masks\*.bmp');
masks = dir('Validation-Dataset\Masks-Ideal\*.bmp');
path_2 = what('Validation-Dataset\Masks-Ideal\').path;


F_score = zeros(length(estimations));
Precision = zeros(length(estimations));
Recall = zeros(length(estimations));

for k = 1:length(estimations)
    file = strcat('Masks\' ,estimations(k).name);
    estimation = imread(file);
    estimation = ~estimation;
    estimation = im2double(estimation);
    file = strcat(path_2,'\' ,masks(k).name);
    real_mask = imread(file);
    [M,N]= size(estimation);
    TP=0;
    T=0;
    P=0;
    for i=1:M
        for j=1:N
            if(estimation(i,j) == 0)
                P=P+1;
            end
            if(estimation(i,j) == real_mask(i,j))
                if(estimation(i,j) == 0)
                    TP=TP+1;
                end
            end
            if(real_mask(i,j) == 0)
                T=T+1;
            end

        end
    end
    Precision(k) = TP/P;
    Recall(k) = TP/T;
    F_score (k) = 2*Precision(k)*Recall(k)/(Precision(k)+Recall(k));
%     if(F_score(k) < 0.4)
%         figure(1);imshow(estimation);
%         figure(2);imshow(real_mask);
%         pause(0.3);
%     end
end
close all;

plot(F_score)
title("Individual statistics")
hold on
plot(Precision, '-r')
plot(Recall, '-g')
hold off
legend({'F-Score', 'Precision', 'Recall'}, 'Location', 'southeast')


