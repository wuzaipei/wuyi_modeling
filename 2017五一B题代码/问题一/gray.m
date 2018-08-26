function gml = gray(A,m)
syms a b;
c=[a b]';
B=cumsum(A);  %原始数据累加
n=length(A);  %A矩阵的长度。
for i=1:(n-1)
    C(i)=(B(i)+B(i+1))/2; %生成累加矩阵
end
%计算待定参数的值
D=A;D(1)=[];
D=D';
E=[-C;ones(1,n-1)];
c=inv(E*E')*E*D;
c=c';
a=c(1);b=c(2);
%预测后续数据
F=[];F(1)=A(1);
%m=1; %只预测原始数据后的10个数据。
for i=2:(n+m)  %只推测后10个数据，可以从此修改
    F(i)=(A(1)-b/a)/exp(a*(i-1))+b/a;  %灰色预测模型
end
G=[];G(1)=A(1);
for i=2:(n+m)  %只推测后10个数据，可以从此修改
    G(i)=F(i)-F(i-1);  %得到预测出来的数据
end
gml = G;


