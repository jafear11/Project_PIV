
%%%%%%%%%%%%%%%% Algorithm 2 %%%%%%%%%%%%%%%%

function [mask] = Algo2(image)
    image = im2double(image);
    image = rgb2ycbcr(image);
    mask = 0.65>image(:,:,2)>0.6;
    imshow(mask)
end


%%%%%TODO%%%%%%%%%
% 1. Trobar els thresholds de crominancia del algo1
% 2. Passar la imatge de rgb a ycbcr
% 3. Comprobar quins pixels de la imatge argument son de pell, i els posem
% A ZERO
% 4. Retornar la imatge de màscara, 1 ÚNIC CANAL
%
%
%
%
%
%