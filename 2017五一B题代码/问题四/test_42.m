clear all
clc
% date = xlsread('B题数据_附件四.xlsx');
load('date.mat')
x=date;
j1 = sum(x);
da_1=j1(1:2:end);
da_2=j1(2:2:end);
da = da_1-da_2;


y=x(:,1)-x(:,2);
% y = mapminmax(y,0,1); %返回一化mapminmax('reverse',B,PS) 
plot(y,'b')
title('资金净流量分布')

u = mean(y)
va_r = var(y)
% u=0.59; q=sqrt(50.18);
% y = -(1.786*q+u)
gg=(545-u)/va_r

