clear all
clc
close all

data = xlsread('B������_����һ.xlsx');
% [data,ps] = mapminmax(data,0,1); %����һ��mapminmax('reverse',B,PS)  
data_cl = data(:,11:16);
%% ��ȱֵ���� ʹ�ò�ֵ����ϵķ�����
% gmcal=grey_prediction()
for i=[2,4,5]
    
    y = [data_cl(1:end-2,i);data_cl(end,i)];
    x = [1:31,33]';
    x1=1:33;
    y1=interp1(x,y,x1);
    data_cl(32,i) = y1(32);
    figure
    plot(x,y,'-',x1,y1,'o')
    title('��·������:ͬ��:��(%)')
end

for i = [1,3,6]
    if (i==1) 
        y = data_cl(25:31,i);
        x = [25:31]';
        x1=[25:33]';
        p=polyfit(x,y,1);
        y1=polyval(p,x1);
        figure
        h=plot(x,y,'o',x1,y1,'-r');
        set(h,'LineWidth',1.7);
        legend('ʵ��ֵ','Ԥ��ֵ')
        data_cl(32:33,i) = y1((end-1):end);
    elseif i==3
        y = data_cl(1:end-2,i);
        x = [1:length(y)]';
        x1=[1:33]';
        p=polyfit(x,y,2);
        y1=polyval(p,x1);
        figure
        h=plot(x,y,'o',x1,y1,'-r');
        set(h,'LineWidth',1.7);
        legend('ʵ��ֵ','Ԥ��ֵ')
        data_cl(32:33,i) = y1((end-1):end);
    else
        y = data_cl(1:end-1,i);
        x = [1:length(y)]';
        x1=[1:33]';
        p=polyfit(x,y,1);
        y1=polyval(p,x1);
        figure
        h=plot(x,y,'o',x1,y1,'-r');
        title('���ڻ�������Ҹ���������Ԫ��')
        set(h,'LineWidth',1.5);
        legend('ʵ��ֵ','Ԥ��ֵ')
        data_cl(33,i) = y1(33);
    end
end

data(:,11:16)=data_cl;

%% �����ݽ���Ԥ����
load('data.mat')
data(:,16) = data(:,16)/1000000;

% [coeff,score,latent,tsquared,explained]= pca(data);
% data=score(:,1:4);

% [data,ps] = mapminmax(data,0,10);
x_test = data(end,:);
x_2017 = data(32,:);
x_2016 = data(28,:);
x_2015 = data(24,:);
x_train=[x_2015;x_2016;x_2017];
%% ���Իع�
load('data_2.mat')

x_train = [ones(3,1),x_train];
x_test = [ones(1,1),x_test];

b_x=[];
n = length(data_2(:,1));
x_2018=zeros(n,2);

for i = 1:n
    Y=data_2(i,[1,3,5]);
    [b, bint,r,rint]=regress(Y',x_train);
    b_x=[b_x b];
    x_2018(i,1)=x_test*b;
end
    
for i = 1:n
    Y=data_2(i,[2,4,6]);
    [b, bint,r,rint]=regress(Y',x_train);
    b_x=[b_x b];
    x_2018(i,2)=x_test*b;
end


    
