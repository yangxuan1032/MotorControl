%% 系统仿真参数配置
% 创建人：      杨晅
% 创建时间：    2024.08.20
% 版本：        V0.0.1                    
% 更新记录：       
% 2024.09.29   更新一部分参数读取生成函数
%%
clear 
close all
clc

%%
ExeclName = "MotorContrlData.xlsx";
SheetNames = ["Input","Hardware","Simulink","Parameter","CodeGenerate"];
T = readtable(ExeclName,'Sheet',SheetNames(1));

%% function
function GetExecelData(FileName,SheetName)
    Data_Tabel = readtable(FileName,'Sheet',SheetName);
    [m,~] =  size(Data_Tabel.DataType);
    for i = 1:m
        ParamObj = Simulink.Parameter;
        ParamObj.Value = Data_Tabel.Data(i);
        ParamObj.DataType = Data_Tabel.DataType(i);
        ParamObj.Dimensions = [Data_Tabel.Dimensions(i) 1];
        ParamObj.Description = Data_Tabel.Description(i);
        ParamObj.Min = Data_Tabel.DataValueMin(i);
        ParamObj.Max = Data_Tabel.DataValueMax(i);
        ParamObj.CoderInfo.Identifier = Data_Tabel.SignalName(i);
    end
end
