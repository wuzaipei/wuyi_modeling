clear all
clc
%% �����
load('data_rate.mat') %2018������
load('data_cd') %2018��ȡ��

% c=[-3;-2];
c=-1*data_rate(:,2);
% A=[2 3;5 -2];
A=[eye(30,30)*-1;ones(1,30);eye(30,30)];
% b=[14;9];
b= [data_cd(:,2)*(-1);sum(data_cd(:,1));data_cd(:,1)];
Aeq=[];
beq=[];
lb=ones(30,1);
ub=[];
M=[]; %M��ȷ��������λ�ã����������������Ϊ0.
Tol=1e-10;
[x_date,fval]=intprog(c,A,b,Aeq,beq,lb,ub,M,Tol)

% x_date ��������Ĵ�����䷽�����
%%
load('x_date.mat')
gl = x_date-data_cd(:,2);
gl = 500*gl/sum(gl)+data_cd(:,1);

%% ������
c=-1*data_rate(:,2);
A=[eye(30,30)*-1;ones(1,30);ones(1,30)*(-1);eye(30,30)];
b= [x_date*(-1);sum(gl)+500;-46670;gl];
Aeq=[];
beq=[];
lb=ones(30,1);
ub=[];
M=[]; %M��ȷ��������λ�ã����������������Ϊ0.
Tol=1e-10;
[x_date_1,max_f]=intprog(c,A,b,Aeq,beq,lb,ub,M,Tol)

% x_date ���������Ĵ�����䷽�����