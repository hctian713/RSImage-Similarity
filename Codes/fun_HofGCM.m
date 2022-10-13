function y = fun_HofGCM(imgGray)
%参数为灰度图像
%函数返回4个方向的灰度共生矩阵、各种特征值的均值和方差、特征值向量的结构体

%计算4个方向的灰度共生矩阵
[glcm] = graycomatrix(imgGray, 'N', 16, 'G', [],'O',[0,1;-1,1;-1,0;-1,-1]); 

%求特征值“对比度”“同质性”“自相关”“能量”
eig = graycoprops(glcm,{'contrast','homogeneity','correlation','energy'});

%求特征值均值                                                                 
y.ConM=mean(eig.Contrast,2);
y.HomM=mean(eig.Homogeneity,2);
y.CorM=mean(eig.Correlation,2);
y.EnerM=mean(eig.Energy,2);    
%求特征值方差
y.ConS=std(eig.Contrast,0,2)^2;
y.HomS=std(eig.Homogeneity,0,2)^2;
y.CorS=std(eig.Correlation,0,2)^2;
y.EnerS=std(eig.Energy,0,2)^2;      

%构造特征值向量
y.eigVec=[y.ConM,y.HomM,y.CorM,y.EnerM,y.ConS,y.HomS,y.CorS,y.EnerS];    
end

