function bf_data=min_excess_reserve(x_c,y_q)
n = length(x_c);
y_e =zeros(n,1);
b_f =zeros(n,1);
for i= 1:n-1
    if x_c(i) > y_q(i)
        y_e(i) =  x_c(i)-y_q(i);
        x_c(i+1)=x_c(i+1)+y_e(i);
    else
        b_f(i) = y_q(i) - x_c(i);
    end
end
bf_data = b_f;
