% Author:   YangXiaoSheng
% Date:     2018/4/9
 
%init inputs and outputs of system
y_2 = 0;  %y*z^-2
y_1 = 0;  %y*z^-1
y_0 = 0;  %y*z^0
u_1 = 0;  %u*z^-1
u_0 = 0;  %u*z^0
Y_m = [];
Fai_m = [];
m = 6;
p = 0.95;
Y_data = [];
Y_data_noise = [];
Theta_data = [];

noise= 0.01*randn(1,101);
for i=0:100
    %input signal
    u_0 = u_0 + 1;
    if(u_0 > 10)
        u_0 = 5;
    end
%    u_0 = -5*cos(i*2*pi/5)+5;
    %cauclate output of system
    y_0 = [y_1,y_2,u_0,u_1]*[-2;-1;2;1];
    y_0 = [y_1,y_2,u_0,u_1]*[1.81;-0.8187;0.004377;0.004679];
    y_0_noise = y_0 + noise(i+1);
    
    if(i<=m)
        Y_m=[Y_m;y_0_noise];
        Fai_m = [Fai_m;y_1,y_2,u_0,u_1];
        if(i==m)
%            Theta_last = (Fai_m'*Fai_m)^(-1)*Fai_m'*Y_m;
%            P_last = (Fai_m'*Fai_m)^(-1);
            Theta_last = [0;0;0;0];
            P_last = 100*[1 0 0 0;0 1 0 0;0 0 1 0;0 0 0 1];
        end
    else
        Fai_now = [y_1;y_2;u_0;u_1];

        G_now = P_last*Fai_now/(p+Fai_now'*P_last*Fai_now);
        P_now = (P_last-G_now*Fai_now'*P_last)/p;
        Y_now = y_0_noise;
        Theta_now = Theta_last+G_now*(Y_now-Fai_now'*Theta_last);

        %save state for next time
        G_last = G_now;
        P_last = P_now;
        Fai_last = Fai_now;
        Theta_last = Theta_now;
        
        Theta_data = [Theta_data,Theta_now];
        Y_data = [Y_data;y_0];
        Y_data_noise = [Y_data_noise;y_0_noise];
    end
    
    %save state for next time
    y_2 = y_1;
    y_1 = y_0;
    u_1 = u_0;
end
figure(1);
plot(Theta_data(1,:));
hold on;
plot(Theta_data(2,:));
plot(Theta_data(3,:));
plot(Theta_data(4,:));
hold off;
figure(2);
plot(Y_data);
figure(3);
plot(noise);

