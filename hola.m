x = 1:50:500;
llindar = 0.00001:0.0001:0.001;
fscore = zeros(3,length(x));
for i=1:length(x)
    Algo1(x,y);
    Algo3;
    fscore(:,i) = Algo4();
end
plot(fscore(:,1))