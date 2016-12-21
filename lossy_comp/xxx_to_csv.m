csvxxx = [];
for i = 1:1800
    for j  = 1:10
        csvxxx = [csvxxx;xxx(xxx(:,2)==j & xxx(:,3) ==i,:)];
    end
end

i = 4;
j = 5;
csvxxx = csvxxx(:,[1:i-1,j,i+1:j-1,i,j+1:end]);
csvxxx(:,6) = 12;
csvxxx(:,5) = 0;
csvxxx = [csvxxx,zeros(18000,4)];