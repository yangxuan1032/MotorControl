%% MTPV代码仿真测试
% 创建人：      杨晅
% 创建时间：    2025.8.25
% 版本：        V0.0.1                    
% 更新记录：       
%
%%
clear 
close all
clc
%%
Pn = 4;
Phi_f = 0.03;
Ld = 2e-3;
Lq = 2.75E-3;
Imax = 1e-3:1e-3:1;
[~,len] = size(Imax);
MTPA_I = zeros(2,len);
MTPA_Te = zeros(1,len);

for i = 1:len
    Id = -Imax(i):Imax(i)/1e5:Imax(i);
    Iq = sqrt(Imax(i)^2 - Id.^2);
    Te = 3.*Pn.*Iq.*(Phi_f - ((Lq-Ld).*Id))/2;
    [~,index_max] = max(Te);
    MTPA_Te(i) = Te(index_max);
    MTPA_I(:,i) = [Id(index_max);Iq(index_max)];
    clear Iq Id Te index_max;
end


%% Display
figure(1)
plot(MTPA_I(1,:),MTPA_I(2,:));
figure(2)
plot3(MTPA_I(1,:),MTPA_I(2,:),MTPA_Te);
% title('');














