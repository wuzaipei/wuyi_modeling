% 下面是调用命令的方法。
%********************************
% c=[-3;-2];
% A=[2 3;5 -2];
% b=[14;9];
% Aeq=[];
% beq=[];
% lb=[0;0];
% ub=[];
% M=1; %M是确定整数的位置，如果不是整数的则为0.
% Tol=1e-8;
%  [x,fval]=intprog(c,A,b,Aeq,beq,lb,ub,M,Tol)
%**************************************
%整数规划的MATLAB实现
%Originally Designed By Sherif A. Tawfik, Faculty of Engineering, Cairo University
%Revised By LiMing, 2009-12-29
%函数调用形式[x,fval,exitflag]=intprog(f,A,b,Aeq,beq,lb,ub,M,TolXInteger)
%函数求解如下形式的整数规划问题
%min f'*x
%subject to
%           A*x<=b
%           Aeq*x=beq
%           lb<=x<=ub
%           M存储有整数约束的变量编号的向量
%           TolXInteger是判定整数的误差限
%
%函数返回变量
%x:整数规划的最优解
%fval:目标函数在最优解处的函数值
%exitflag =	1 	收敛到解x
%        	0 	达到线性规划的最大迭代次数
%        	-1 	无解
%
function [x,fval,exitflag]=intprog(f,A,b,Aeq,beq,lb,ub,M,TolXInteger)
%设置不显示求解线性规划过程中的提示信息
options = optimset('display','off');
%上界的初始值
bound=inf;      
%求解原问题P0的松弛线性规划Q0，首先获得问题的初始解
[x0,fval0]=linprog(f,A,b,Aeq,beq,lb,ub,[],options); 
%利用递归法进行二叉树的遍历，实现分枝定界法对整数规划的求解
[x,fval,exitflag,b]=rec_BranchBound(f,A,b,Aeq,beq,lb,ub,x0,fval0,M,TolXInteger,bound);

%分枝定界法的递归算法
%x为问题的初始解，v是目标函数在x处的取值
function [xx,fval,exitflag,bb]=rec_BranchBound(f,A,b,Aeq,beq,lb,ub,x,v,M,TolXInteger,bound)
options = optimset('display','off');
%求解不考虑整数约束的松弛线性规划
[x0,fval0,exitflag0]=linprog(f,A,b,Aeq,beq,lb,ub,[],options);
%如果算法结束状态指示变量为负值，即表示无可行解，返回初始输入
%或者所目标函数值大于已经获得的上界，返回初始输入
if exitflag0<=0 | fval0>bound
    xx=x;
    fval=v;
    exitflag=exitflag0;
    bb=bound;
    return;
end

%确定所有变量是否均为整数，如是，则返回
%该条件表示x0(M)不是整数
ind=find(abs(x0(M)-round(x0(M)))>TolXInteger);
%如果都是整数
if isempty(ind)
    exitflag=1;
%如果当前的解优于已知的最优解，则将当前解作为最优解
    if fval0<bound
        x0(M)=round(x0(M));
        xx=x0;
        fval=fval0;
        bb=fval0;
%否则，返回原来的解
    else
        xx=x;
        fval=v;
        bb=bound;
    end
    return;
end

%程序运行至此，说明松弛线性规划的解是一个可行解且目标函数值比当前记录的上界要
%小，只是某些变量的值并非整数，于是在此选择合适的变量进行分枝形成两个子问题，分
%别进行递归求解

%该处选择与整数值相差最大的非整数变量首先进行分枝形成两个子问题
%第一个非整数变量的序号，且记录该变量与其最邻近的整数之差的绝对值
[row col]=size(ind);
br_var=M(ind(1));
br_value=x(br_var);
flag=abs(br_value-floor(br_value)-0.5);
%用于查找非整数设计变量中整数值相差最大的设计变量，即每当遇到与其最邻近的整数差
%别更大的非整数设计变量之时，即记录下该设计变量的序号，直至遍历完所有非整数变量
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

%分枝后第一个子问题的参数设置
%添加约束条件Xi <= floor(Xi)，i即为上面找到的设计变量的序号
A1=[A;zeros(1,c)];
A1(end,br_var)=1;
b1=[b;floor(br_value)];
    
%分枝后第二个子问题的参数设置
%添加约束条件Xi >= ceil(Xi) ，i即为上面找到的设计变量的序号    
A2=[A;zeros(1,c)];
A2(end,br_var)=-1;
b2=[b;-ceil(br_value)];    
    
%分枝后的第一个子问题的递归求解
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

%分枝后的第二个子问题的递归求解
[x2,fval2,exitflag2,bound2]=rec_BranchBound(f,A2,b2,Aeq,beq,lb,ub,x0,fval0,M,TolXInteger,bound);
if exitflag2>0 & bound2<bound
    exitflag=exitflag2;
    xx=x2;
    fval=fval2;       
    bb=bound2;
end
