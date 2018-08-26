clear all
clc
%xlsread('B������_������.xlsx');
 load('date.mat');
 x =date;
y=x(:,3)-x(:,4);

n = length(x(1,:));
bfj = [];
bfj_1 = [];
for i = 1:2:n
    x_c = x(:,i);
    x_q = x(:,i+1);
    bf_data=min_excess_reserve(x_c,x_q);
    n = length(x_c);
    b_f = zeros(n,1);
    y_e = zeros(n,1);
    for i = 1:n-1

        if x_c(i)<=x_q(i)
            b_f(i)= x_q(i) - x_c(i);
        else
            y_e(i)=x_c(i) - x_q(i);
            x_c(i+1) = x_c(i+1) + y_e(i);
        end
    end
    bfj = [bfj ;sum(b_f)];
    bfj_1 = [bfj_1 ;sum(bf_data)];    
end

x=date;
j1 = sum(x);
da_1=j1(1:2:end);
da_2=j1(2:2:end);
da = da_1-da_2;
plot(1:30,da,'b',1:30,bfj_1,'r--')
legend('������','�����ʽ�')
title('�������뱸���ʽ�ֲ�ͼ')
% �����ʽ��뾻���������߷���
s = corrcoef(bfj_1,da);
