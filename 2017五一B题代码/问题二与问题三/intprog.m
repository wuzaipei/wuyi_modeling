% �����ǵ�������ķ�����
%********************************
% c=[-3;-2];
% A=[2 3;5 -2];
% b=[14;9];
% Aeq=[];
% beq=[];
% lb=[0;0];
% ub=[];
% M=1; %M��ȷ��������λ�ã����������������Ϊ0.
% Tol=1e-8;
%  [x,fval]=intprog(c,A,b,Aeq,beq,lb,ub,M,Tol)
%**************************************
%�����滮��MATLABʵ��
%Originally Designed By Sherif A. Tawfik, Faculty of Engineering, Cairo University
%Revised By LiMing, 2009-12-29
%����������ʽ[x,fval,exitflag]=intprog(f,A,b,Aeq,beq,lb,ub,M,TolXInteger)
%�������������ʽ�������滮����
%min f'*x
%subject to
%           A*x<=b
%           Aeq*x=beq
%           lb<=x<=ub
%           M�洢������Լ���ı�����ŵ�����
%           TolXInteger���ж������������
%
%�������ر���
%x:�����滮�����Ž�
%fval:Ŀ�꺯�������Ž⴦�ĺ���ֵ
%exitflag =	1 	��������x
%        	0 	�ﵽ���Թ滮������������
%        	-1 	�޽�
%
function [x,fval,exitflag]=intprog(f,A,b,Aeq,beq,lb,ub,M,TolXInteger)
%���ò���ʾ������Թ滮�����е���ʾ��Ϣ
options = optimset('display','off');
%�Ͻ�ĳ�ʼֵ
bound=inf;      
%���ԭ����P0���ɳ����Թ滮Q0�����Ȼ������ĳ�ʼ��
[x0,fval0]=linprog(f,A,b,Aeq,beq,lb,ub,[],options); 
%���õݹ鷨���ж������ı�����ʵ�ַ�֦���編�������滮�����
[x,fval,exitflag,b]=rec_BranchBound(f,A,b,Aeq,beq,lb,ub,x0,fval0,M,TolXInteger,bound);

%��֦���編�ĵݹ��㷨
%xΪ����ĳ�ʼ�⣬v��Ŀ�꺯����x����ȡֵ
function [xx,fval,exitflag,bb]=rec_BranchBound(f,A,b,Aeq,beq,lb,ub,x,v,M,TolXInteger,bound)
options = optimset('display','off');
%��ⲻ��������Լ�����ɳ����Թ滮
[x0,fval0,exitflag0]=linprog(f,A,b,Aeq,beq,lb,ub,[],options);
%����㷨����״ָ̬ʾ����Ϊ��ֵ������ʾ�޿��н⣬���س�ʼ����
%������Ŀ�꺯��ֵ�����Ѿ���õ��Ͻ磬���س�ʼ����
if exitflag0<=0 | fval0>bound
    xx=x;
    fval=v;
    exitflag=exitflag0;
    bb=bound;
    return;
end

%ȷ�����б����Ƿ��Ϊ���������ǣ��򷵻�
%��������ʾx0(M)��������
ind=find(abs(x0(M)-round(x0(M)))>TolXInteger);
%�����������
if isempty(ind)
    exitflag=1;
%�����ǰ�Ľ�������֪�����Ž⣬�򽫵�ǰ����Ϊ���Ž�
    if fval0<bound
        x0(M)=round(x0(M));
        xx=x0;
        fval=fval0;
        bb=fval0;
%���򣬷���ԭ���Ľ�
    else
        xx=x;
        fval=v;
        bb=bound;
    end
    return;
end

%�����������ˣ�˵���ɳ����Թ滮�Ľ���һ�����н���Ŀ�꺯��ֵ�ȵ�ǰ��¼���Ͻ�Ҫ
%С��ֻ��ĳЩ������ֵ���������������ڴ�ѡ����ʵı������з�֦�γ����������⣬��
%����еݹ����

%�ô�ѡ��������ֵ������ķ������������Ƚ��з�֦�γ�����������
%��һ����������������ţ��Ҽ�¼�ñ����������ڽ�������֮��ľ���ֵ
[row col]=size(ind);
br_var=M(ind(1));
br_value=x(br_var);
flag=abs(br_value-floor(br_value)-0.5);
%���ڲ��ҷ�������Ʊ���������ֵ���������Ʊ�������ÿ�������������ڽ���������
%�����ķ�������Ʊ���֮ʱ������¼�¸���Ʊ�������ţ�ֱ�����������з���������
for i=2:col
    tempbr_var=M(br_var);
    tempbr_value=x(br_var);
    temp_flag=abs(tempbr_value-floor(tempbr_value)-0.5);
    if temp_flag>flag
        br_var=tempbr_var;
        br_value=tempbr_value;
        flag=temp_flag;
    end
end

if isempty(A)
    [r c]=size(Aeq);
else
    [r c]=size(A);
end

%��֦���һ��������Ĳ�������
%���Լ������Xi <= floor(Xi)��i��Ϊ�����ҵ�����Ʊ��������
A1=[A;zeros(1,c)];
A1(end,br_var)=1;
b1=[b;floor(br_value)];
    
%��֦��ڶ���������Ĳ�������
%���Լ������Xi >= ceil(Xi) ��i��Ϊ�����ҵ�����Ʊ��������    
A2=[A;zeros(1,c)];
A2(end,br_var)=-1;
b2=[b;-ceil(br_value)];    
    
%��֦��ĵ�һ��������ĵݹ����
[x1,fval1,exitflag1,bound1]=rec_BranchBound(f,A1,b1,Aeq,beq,lb,ub,x0,fval0,M,TolXInteger,bound);
exitflag=exitflag1;
if exitflag1>0 & bound1<bound
    xx=x1;
    fval=fval1;
    bound=bound1;
    bb=bound1;
else
    xx=x0;
    fval=fval0;
    bb=bound;        
end

%��֦��ĵڶ���������ĵݹ����
[x2,fval2,exitflag2,bound2]=rec_BranchBound(f,A2,b2,Aeq,beq,lb,ub,x0,fval0,M,TolXInteger,bound);
if exitflag2>0 & bound2<bound
    exitflag=exitflag2;
    xx=x2;
    fval=fval2;       
    bb=bound2;
end
