clear all
clc
load('data_2.mat')
n=length(data_2(:,1));
x_2018=zeros(n,2);
for i = 1:n
    x = data_2(i,[1,3,5])/1000;
    gml = gray(x,1);
    x_2018(i,1)=gml(end);
end

for j = 1:n
    x = data_2(j,[2,4,6])/1000;
    gml = gray(x,1);
    x_2018(j,2)=gml(end);
end
D=x_2018*1000;
