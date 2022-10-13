function y = fun_HofGL(imgGray)
%参数为灰度图像，
%函数返回灰度直方图、各种特征值、特征值向量的结构体

%计算灰度直方图
imgHist=imhist(imgGray);%计算灰度直方图
L_r=size(imgGray,1);%素数的行数
L_l=size(imgGray,2);%像素的列数
imgHist_Per=(imgHist/(L_r*L_l));%转化为百分比形式
y.imgHist=imgHist_Per;%载入

%计算“灰度均值”
GrayLevel=0:255;
imgGrayAve=sum(GrayLevel'.*y.imgHist);
y.Ave=imgGrayAve;%载入
%计算“灰度方差”
Aver=mean(GrayLevel);
imgGrayVar=sum((GrayLevel-Aver).^2'.*y.imgHist);
y.Var=imgGrayVar;%载入
%计算“歪斜度”
Aver=mean(GrayLevel);
imgGraySkew=imgGrayVar^-1.5*sum((GrayLevel-Aver).^3'.*y.imgHist);
y.Skew=imgGraySkew;%载入
%计算“陡峭度”
GrayLevel=0:255;
Aver=mean(GrayLevel);
imgGrayKur=imgGrayVar^-2*sum((GrayLevel-Aver).^4'.*y.imgHist)-3;
y.Kur=imgGrayKur;%载入
%计算“能量”
imgGrayEner=sum(y.imgHist.^2);
y.Ener=imgGrayEner;%载入

%构造特征值向量
imgEigVec=[imgGrayAve imgGrayVar imgGraySkew imgGrayKur imgGrayEner];
y.eigVec=imgEigVec;
end

