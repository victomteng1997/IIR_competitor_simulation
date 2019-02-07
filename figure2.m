data = [1 0.783764869	0.644399973; 1 0.786905777	0.698938178];
uniNames = {'Competing Method 1','Competing Method 2','Proposed Algorithm'};
b = bar(data);
legend(b,uniNames);
x = {'Average Normalized FPGA Area','Average Normalized ASIC Area'};
set(gca, 'XTickLabel', x)
