clear all
clc
% date = xlsread('B������_������.xlsx');
load('date.mat')
x=date;
j1 = sum(x);
da_1=j1(1:2:end);
da_2=j1(2:2:end);
da = da_1-da_2;


y=x(:,1)-x(:,2);
% y = mapminmax(y,0,1); %����һ��mapminmax('reverse',B,PS) 
plot(y,'b')
title('�ʽ������ֲ�')

u = mean(y)
va_r = var(y)
% u=0.59; q=sqrt(50.18);
% y = -(1.786*q+u)
gg=(545-u)/va_r

