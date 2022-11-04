f_score = zeros(100);
precision = zeros(100);
recall = zeros(100);
reduccio = 1:10;
llindar = 0.00001:0.00001:0.0001;
index=0;
for a=1:length(llindar)
    for b=1:length(reduccio)
        index = index +1;
        Algo3(llindar(a),reduccio(b));
        Algo4;
        f_score(index) = F_score;
        precision(index) = Precision;
        recall(index) = Recall;
    end
end