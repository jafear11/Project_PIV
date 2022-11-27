directory = dir('Validation-Dataset\Masks-Ideal\*.bmp');
path = what('Validation-Dataset\Masks-Ideal').path;

for k = 1:length(directory)
    file = strcat(path,'\' ,directory(k).name);
    image = ~imread(file);
    T = bwconvhull(image);
    boundaries_in = bwboundaries(image, 'noholes');
    boundaries_out = bwboundaries(T, 'noholes');
    interior = edge(image);
    exterior = edge(T);
    imshow(interior+exterior);   
    pause(0.3);
end