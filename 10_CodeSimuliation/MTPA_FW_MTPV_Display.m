%% 弱磁控制相关曲线绘制（理论）
% 创建人：      杨晅
% 创建时间：    2025.12.13
% 版本：        V0.0.1                    
% 更新记录：       
% 202501212      电压极限圆、电流圆、转矩曲线、MTPA曲线、MTPV曲线绘制（理论曲线）
%%
clear 
close all
clc
%% Basic Paramers
J = 6.9683e-5;
Pn = 4;
Psi_f = 2.6e-3;
Rs = 6e-3;
Ld = 2.1e-5;%2.1e-5
Lq = 3.3E-5;%3.3E-5
Vdc = 13.5;
Ip_max = 150;
Idc_max = 80;
Speed_max_Pro = 10000; % RPM Peak
Speed_max = 5000; % RPM
Te_max = 5;
PlotLimit = 200;
% T_load = 0.9;

%% Varibable Params
Is_Step = 30;
Te_Step = 1e-1;
Speed_Step = 1000;
Is = 0:Is_Step:Ip_max;
Te = 0:Te_Step:Te_max;
Speed = 3000:Speed_Step:Speed_max_Pro;
Irange = [-PlotLimit,PlotLimit];
text_pos_I = 0;
text_pos_T = 150:-300/length(Te):-150;
text_pos_V = -50;
text_pos_mtpa = -50;
text_pos_mtpv = -150;
%%
syms Id Iq
% 电流极限圆
for i = 1:length(Is)
    Is_temp = Is(i);
    eqn_I = Is_temp^2 == Id^2 + Iq^2;
    h = fimplicit(eqn_I,Irange);
    set(h,'Color','b');
    hold on;
    % 解算标志点坐标
    sol_i = solve(subs(eqn_I, Id, text_pos_I), Iq);
    text(text_pos_I, sol_i(2), ['Is= ', num2str(Is_temp)], 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'Color', 'b','FontSize', 8);
end
eqn_I = Is_temp^2 == Id^2 + Iq^2;
h = fimplicit(eqn_I,Irange);
set(h,'Color','k');
hold on;
% 解算标志点坐标
sol_i = solve(subs(eqn_I, Id, text_pos_I), Iq);
text(text_pos_I, sol_i(2), ['Is= ', num2str(Is_temp)], 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'Color', 'k','FontSize', 8);
clear eqn_I Is_temp sol_i h i;

% 电流极限圆
for i = 1:length(Speed)
    Speed_temp = Speed(i);
    Vs_temp = Vdc/sqrt(3);
    eqn_V = Vs_temp^2 == (Rs*Id - ((Speed_temp*2*pi*Pn/60)*Lq*Iq))^2 + (Rs*Iq+((Speed_temp*2*pi*Pn/60)*Ld*Id)+((Speed_temp*2*pi*Pn/60)*Psi_f))^2;
    h = fimplicit(eqn_V,Irange);
    set(h,'Color','g');
    hold on;
    % 解算标志点坐标
    sol_i = solve(subs(eqn_V, Id, text_pos_V), Iq);
    text(text_pos_V,sol_i(2), ['Speed= ', num2str(Speed_temp)], 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'Color', 'g','FontSize', 8);
end
clear eqn_V Speed_temp Vs_temp sol_i h i;

% 转矩曲线
for i = 1:length(Te)
    Te_temp = Te(i);
    eqn_T = Te_temp == (3*Pn*Iq*(Psi_f + (Ld - Lq)*Id))/2;
    h = fimplicit(eqn_T,Irange);
    set(h,'Color','r');
    hold on;
    % 解算标志点坐标
    sol_i = solve(subs(eqn_T, Id, text_pos_T(i)), Iq);
    text(text_pos_T(i),sol_i,['Te= ', num2str(Te_temp)], 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'Color', 'r','FontSize', 5);
end
clear eqn_T Te_temp sol_i h i;

% MTPA曲线
eqn_MTPA = Id == (sqrt(Psi_f^2+4*(Ld-Lq)^2*Iq^2) - Psi_f)/(2*(Ld-Lq));% (-phir+sqrt(phir^2+4*(Ld-Lq)^2*iq^2))/(2*(Ld-Lq));
h = fimplicit(eqn_MTPA,Irange);
set(h,'Color','c');
hold on;
% 解算标志点坐标
sol_i = solve(subs(eqn_MTPA, Id, text_pos_mtpa), Iq);
text(text_pos_mtpa,sol_i(2), ['MTPA'], 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'Color', 'c','FontSize', 10);
clear eqn_MTPA sol_i h i;

% MTPV曲线
eqn_MTPV = Id == (sqrt(Psi_f^2+4*(Ld-Lq)^2*Iq^2)*Lq-Lq*Psi_f)/(2*Ld*(Ld-Lq)) - (Psi_f/Ld);% -phir/Ld+(-Lq*phir+Lq*sqrt(phir^2+4*(Ld-Lq)^2*iq*iq))/(2*Ld*(Ld-Lq));
h = fimplicit(eqn_MTPV,Irange);
set(h,'Color','m');
hold on;
% 解算标志点坐标
sol_i = solve(subs(eqn_MTPV, Id, text_pos_mtpv), Iq);
text(text_pos_mtpv, sol_i(2),['MTPV'], 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'Color', 'm','FontSize', 10);
clear eqn_MTPV sol_i h i;

% 画点
plot(0, 0, 'ko', 'MarkerFaceColor', 'k');
plot(-Psi_f/Ld, 0, 'ko', 'MarkerFaceColor', 'r');

% 添加标题和坐标轴标签
title('Plot of MTPA');
xlabel('id');
ylabel('iq');
% 获取当前坐标轴对象
% 绘制 id = 0 的黑色竖线
xline(0, 'k', 'LineWidth', 1);
% 绘制 iq = 0 的黑色横线
yline(0, 'k', 'LineWidth', 1);
ax = gca;
% 设置坐标轴颜色为黑色
ax.XColor = 'k';
ax.YColor = 'k';
% 设置坐标轴线条宽度
ax.LineWidth = 1;
% 显示网格线
grid on; 
hold off;
