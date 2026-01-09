%% 脚本测试
% 创建人：      杨晅
% 创建时间：    2025.12.12
% 版本：        V0.0.1                    
% 更新记录：       
% 202501212      代码初步测试脚本
%%

% 基本参数输入
Ld=0.00009;
Lq=0.00017;
Rs = 0.007;
phir= 0.019;
udc=48;
ulim=udc/sqrt(3);
imax=300;
np=5;

% 中间量处理
T_values = 0:5:65;
T_speed = 0:500:5000;
T_we = T_speed*pi./30*np;
range = [-400,400];
text_pos_mtpa =  range(1)/2;
text_pos_mtpv = range(1);
text_pos_t = 0;
text_pos_we =  range(1)/2;
% colors = hsv(length(T_values));
% 定义符号变量
syms id iq

% 创建图形窗口
figure;
% 循环绘制不同T值下的曲线
for i = 1:length(T_values)
    T = T_values(i);
    % 定义方程
    eqn = T == 1.5*np*(phir*iq + (Ld-Lq)*iq*id);
    h = ezplot(eqn, range);
    set(h, 'Color','r'); 
    hold on;
    sol_iq = solve(subs(eqn, id, text_pos_t), iq);
    text(text_pos_t, sol_iq, ['T = ', num2str(T)], 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'Color', 'r','FontSize', 8);
end

eqn = imax^2 == id^2+iq^2;
ezplot(eqn, range);
hold on;


for i = 1:length(T_we)
    we = T_we(i);
    n = T_speed(i);
    % 定义方程
    eqn = ulim^2 == (Rs*id-we*Lq*iq)^2+(Rs*iq+we*Ld*id+we*phir)^2;
    h = ezplot(eqn,range);
    set(h, 'Color', 'g'); 
    hold on;
    % 解算标志点坐标
    sol_iq = solve(subs(eqn, id, text_pos_we), iq);
    text(text_pos_we, sol_iq(2), ['n= ', num2str(n)], 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'Color', 'g','FontSize', 8);
end
% 画MTPA曲线
eqn = id == (-phir+sqrt(phir^2+4*(Ld-Lq)^2*iq^2))/(2*(Ld-Lq));
h = ezplot(eqn,range);
set(h, 'Color', 'b'); 
hold on;
sol_iq = solve(subs(eqn, id, text_pos_mtpa), iq);
text(text_pos_mtpa, sol_iq(2), 'MTPA', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'Color', 'b','FontSize', 8);


% 画MTPV曲线
eqn = id == -phir/Ld+(-Lq*phir+Lq*sqrt(phir^2+4*(Ld-Lq)^2*iq*iq))/(2*Ld*(Ld-Lq));
h = ezplot(eqn,range);
set(h, 'Color', 'm'); 
hold on;
sol_iq = solve(subs(eqn, id, text_pos_mtpv), iq);
text(text_pos_mtpv, sol_iq(2), 'MTPV', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'Color', 'm','FontSize', 8);


% 画点
plot(0, 0, 'ko', 'MarkerFaceColor', 'k');
plot(-phir/Ld, 0, 'ko', 'MarkerFaceColor', 'r');

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