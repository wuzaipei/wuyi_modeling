clear all
clc
data_lv=xlsread('B题数据_附件二','I:J');
data_cd=data_lv;

load('data_lv.mat') %利率


n=length(data_lv(:,1));
x_2018=zeros(n,2);
for i = 1:n
    x = data_lv(i,[1,3,5]);
    gml = gray(x,1);
    x_2018(i,1)=gml(end);
end

for j = 1:n
    x = data_lv(j,[2,4,6]);
    gml = gray(x,1);
    x_2018(j,2)=gml(end);
end

x_2018(3,1)=2.35/100;

data_rate=x_2018;

