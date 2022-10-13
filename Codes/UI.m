function varargout = UI(varargin)
% UI MATLAB code for UI.fig
%      UI, by itself, creates a new UI or raises the existing
%      singleton*.
%
%      H = UI returns the handle to a new UI or the handle to
%      the existing singleton*.
%
%      UI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UI.M with the given input arguments.
%
%      UI('Property','Value',...) creates a new UI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before UI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%

% Edit the above text to modify the response to help UI

% Last Modified by GUIDE v2.5 07-Dec-2020 00:46:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UI_OpeningFcn, ...
                   'gui_OutputFcn',  @UI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before UI is made visible.
function UI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% See also: GUIDE, GUIDATA, GUIHANDLES
set(handles.pushbutton2,'enable','off');
set(handles.pushbutton3,'enable','off');
global rand option;
rand=1;
option=1;
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to UI (see VARARGIN)

% Choose default command line output for UI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes UI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = UI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

set(handles.pushbutton1,'BackGroundColor',[.49 .18 0.56]);

%读文件
fatherfile_path = uigetdir('','请选择遥感影像总文件夹');%总文件夹路径
str_path = genpath(fatherfile_path);%获得fatherfile下所有子文件的路径，这些路径存在字符串p中，以';'分割
length_p = size(str_path,2);%字符串str_path的长度
file_path = {};%建立一个单元数组，数组的每个单元(行)中包含一个目录
temp_path = [];
for i = 1:length_p %寻找分割符';'，一旦找到，则将路径temp写入path数组中
    if str_path(i) ~= ';'
        temp_path = [temp_path str_path(i)];
    else 
        temp_path = [temp_path '\']; %在路径的最后加入 '\'
        file_path = [file_path ; temp_path];
        temp_path = [];
    end
end
file_path=file_path(2:end,:);%舍弃父文件夹目录
%至此获得data文件夹及其所有子文件夹（及子文件夹的子文件夹）的路径，存于数组path中。
%下面是逐一文件夹中读取图像

global all_img ;%储存所有图片，每一行代表一个图像文件中的所有图片
global file_num img_num
file_num = size(file_path,1);% 子文件夹的个数
all_img=[];
for i = 1:file_num
    temp_img=[];%临时存储一个图像文件中的图像
    temp_path =  file_path{i}; % 图像文件夹路径
    temp_img_path_list = dir(strcat(temp_path,'*.tif'));%列出文件夹内容(struct数组)
    img_num = length(temp_img_path_list); %该文件夹中图像数量
    if img_num > 0
        for j = 1:img_num
              temp_image=[];%创建结构体，包含彩色图像，灰度图像，灰度直方图，以及灰度直方图特征
              temp_image.name=temp_img_path_list(j).name;% 图像名
              temp_image.img = imread(strcat(temp_path,temp_image.name));%载入彩色图像
              %转化为灰度图像
              imgGray=rgb2gray(temp_image.img);
              temp_image.imgGray=imgGray;%载入
              %分配空间：灰度直方图、各种特征值、特征值向量
              temp_image.GrayHistEig=[];

              %分配空间：4个方向的灰度共生矩阵、各种特征值的均值和方差、特征值向量
              temp_image.GrayCoMtxEig=[];

              %分配空间：梯度方向直方图及其相关特征
              temp_image.GradHistEig=[];

              %分配空间：RGB三通道的直方图及其相关特征
              temp_image.RHistEig=[];
              temp_image.GHistEig=[];
              temp_image.BHistEig=[];

            temp_img=[temp_img temp_image]; 
        end
    end
    all_img=[all_img;temp_img]; 
end
set(handles.checkbox1,'value',1);
set(handles.checkbox1,'enable','on');
set(handles.pushbutton2,'enable','on');

%[file_name, file_path]=uigetfile('*.*','请选择文件');%filename为文件名，filepath为文件路径
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
set(handles.checkbox2,'enable','off');
set(handles.checkbox2,'value',0);
global rand option all_img tar_img
 if(rand)%如果随机
    x=randi(21);%行序号
    y=randi(100);%列序号
    tar_img=all_img(x,y);
 else
    [image_name,filepath]=uigetfile('*.*','请选择文件');%filename为文件名，filepath为文件路径
    tar_img.img = imread(strcat(filepath,image_name));
    tar_img.name=image_name;
 end
   axes(handles.axes1);
   tar_img.imgGray=rgb2gray(tar_img.img);
   imshow(tar_img.img);
    tar_img.GrayHistEig = fun_HofGL(tar_img.imgGray);
    tar_img.GrayCoMtxEig=fun_HofGCM(tar_img.imgGray);
    tar_img.GradHistEig=fun_HofOG(tar_img.imgGray);
    tar_img.RHistEig = fun_HofGL(tar_img.img(:,:,1));
    tar_img.GHistEig = fun_HofGL(tar_img.img(:,:,2));
    tar_img.BHistEig = fun_HofGL(tar_img.img(:,:,3));
   title(handles.axes1,tar_img.name);
 switch option
     case 1  %灰度直方图
          axes(handles.axes2);
          bar(tar_img.GrayHistEig.imgHist);
          title('灰度直方图');

     case 2  %灰度共生矩阵
          axes(handles.axes2);          
          plot(tar_img.GrayCoMtxEig.eigVec,'mo--');
          title('特征值向量');
          
     case 3  %梯度方向直方图
          axes(handles.axes2);          
          mesh( tar_img.GradHistEig.eigMtx);
          title('特征值矩阵');
          
     case 4  %RGB灰度直方图
          axes(handles.axes2);
          plot(tar_img.RHistEig.imgHist,'r');hold on;         
          plot(tar_img.GHistEig.imgHist,'g');hold on;         
          plot(tar_img.BHistEig.imgHist,'b');hold on;
          hold off;
          title('RGB三通道直方图');        
 end
  set(handles.pushbutton3,'enable','on');  
    

% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in pushbutton3.

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
set(handles.checkbox2,'value',0);
set(handles.checkbox2,'enable','off');
global option tar_img file_num img_num all_n2 all_img
all_n2=zeros(file_num,img_num);%为储存特征值差向量的二范数矩阵/向量预分配内存
switch option 
    %灰度直方图
    case 1
        for i=1:file_num
            for j=1:img_num
                all_img(i,j).GrayHistEig=fun_HofGL( all_img(i,j).imgGray);
                temp_eig=all_img(i,j).GrayHistEig;
                all_n2(i,j)=norm(tar_img.GrayHistEig.eigVec-temp_eig.eigVec);%将差向量的二范数载入矩阵
            end
        end
        %将范数矩阵转化为行向量
        n2Vec=[];
        for i=1:size(all_n2,1)
            n2Vec=[n2Vec all_n2(i,:)];
        end
        n2Sort=sort(n2Vec);%将所有二范数升序排列
        idx=zeros(2,6);%为存储相似影像下标的矩阵预分配内存
        %获取范数最小的6个矩阵的下标
        for i=2:6%前2-5个最小二范数
            [x,y]=find(all_n2==n2Sort(i));
            idx(i-1,1)=x;
            idx(i-1,2)=y;
        end
         t=tar_img.GrayHistEig.eigVec;
          axes(handles.axes4)
        imshow(all_img(idx(1,1),idx(1,2)).img);
        a=all_img(idx(1,1),idx(1,2)).GrayHistEig.eigVec;
        p=t*a'/norm(t)/norm(a)*100;
        title(['相似度：' '%' num2str(p)]);
          axes(handles.axes5)
        imshow(all_img(idx(2,1),idx(2,2)).img);
        a=all_img(idx(2,1),idx(2,2)).GrayHistEig.eigVec;
        p=t*a'/norm(t)/norm(a)*100;
        title(['相似度：' '%' num2str(p)]);
          axes(handles.axes6)
        imshow(all_img(idx(3,1),idx(3,2)).img);
        a=all_img(idx(3,1),idx(3,2)).GrayHistEig.eigVec;
        p=t*a'/norm(t)/norm(a)*100;
        title(['相似度：' '%' num2str(p)]);
          axes(handles.axes7)
        imshow(all_img(idx(4,1),idx(4,2)).img);
        a=all_img(idx(4,1),idx(4,2)).GrayHistEig.eigVec;
        p=t*a'/norm(t)/norm(a)*100;
        title(['相似度：' '%' num2str(p)]);
          axes(handles.axes8)
        imshow(all_img(idx(5,1),idx(5,2)).img);
        a=all_img(idx(5,1),idx(5,2)).GrayHistEig.eigVec;
        p=t*a'/norm(t)/norm(a)*100;
        title(['相似度：' '%' num2str(p)]);
          axes(handles.axes9)
        bar(all_img(idx(1,1),idx(1,2)).GrayHistEig.imgHist);
        title(['n2:' num2str(n2Sort(2))]);
          axes(handles.axes10)
        bar(all_img(idx(2,1),idx(2,2)).GrayHistEig.imgHist);
        title(['n2:' num2str(n2Sort(3))]);
          axes(handles.axes11)
        bar(all_img(idx(3,1),idx(3,2)).GrayHistEig.imgHist);
        title(['n2:' num2str(n2Sort(4))]);
          axes(handles.axes12)
        bar(all_img(idx(4,1),idx(4,2)).GrayHistEig.imgHist);
        title(['n2:' num2str(n2Sort(5))]);
          axes(handles.axes13)
        bar(all_img(idx(5,1),idx(5,2)).GrayHistEig.imgHist);
        title(['n2:' num2str(n2Sort(6))]);
    %灰度共生矩阵
    case 2
        for i=1:file_num
            for j=1:img_num
                all_img(i,j).GrayCoMtxEig=fun_HofGCM( all_img(i,j).imgGray);
                temp_eig=all_img(i,j).GrayCoMtxEig;
                all_n2(i,j)=norm(tar_img.GrayCoMtxEig.eigVec-temp_eig.eigVec);%将差向量的二范数载入矩阵
            end
        end
        %将范数矩阵转化为行向量
        n2Vec=[];
        for i=1:size(all_n2,1)
            n2Vec=[n2Vec all_n2(i,:)];
        end
        n2Sort=sort(n2Vec);%将所有二范数升序排列
        idx=zeros(2,6);%为存储相似影像下标的矩阵预分配内存
        %获取范数最小的6个矩阵的下标
        for i=2:6%前2-5个最小二范数
            [x,y]=find(all_n2==n2Sort(i));
            idx(i-1,1)=x;
            idx(i-1,2)=y;
        end
        t=tar_img.GrayCoMtxEig.eigVec;
          axes(handles.axes4)
        imshow(all_img(idx(1,1),idx(1,2)).img);
        a=all_img(idx(1,1),idx(1,2)).GrayCoMtxEig.eigVec;
        p=t*a'/norm(t)/norm(a)*100;
        title(['相似度：' '%' num2str(p)]);
          axes(handles.axes5)
        imshow(all_img(idx(2,1),idx(2,2)).img);
        a=all_img(idx(2,1),idx(2,2)).GrayCoMtxEig.eigVec;
        p=t*a'/norm(t)/norm(a)*100;
        title(['相似度：' '%' num2str(p)]);
          axes(handles.axes6)
        imshow(all_img(idx(3,1),idx(3,2)).img);
        a=all_img(idx(3,1),idx(3,2)).GrayCoMtxEig.eigVec;
        p=t*a'/norm(t)/norm(a)*100;
        title(['相似度：' '%' num2str(p)]);
          axes(handles.axes7)
        imshow(all_img(idx(4,1),idx(4,2)).img);
        a=all_img(idx(4,1),idx(4,2)).GrayCoMtxEig.eigVec;
        p=t*a'/norm(t)/norm(a)*100;
        title(['相似度：' '%' num2str(p)]);
          axes(handles.axes8)
        imshow(all_img(idx(5,1),idx(5,2)).img);
        a=all_img(idx(5,1),idx(5,2)).GrayCoMtxEig.eigVec;
        p=t*a'/norm(t)/norm(a)*100;
        title(['相似度：' '%' num2str(p)]);
          axes(handles.axes9)
        plot(all_img(idx(1,1),idx(1,2)).GrayCoMtxEig.eigVec,'mo--');
        title(['n2:' num2str(n2Sort(1))]);
          axes(handles.axes10)
         plot(all_img(idx(2,1),idx(2,2)).GrayCoMtxEig.eigVec,'mo--');
        title(['n2:' num2str(n2Sort(3))]);
          axes(handles.axes11)
         plot(all_img(idx(3,1),idx(3,2)).GrayCoMtxEig.eigVec,'mo--');
        title(['n2:' num2str(n2Sort(4))]);
          axes(handles.axes12)
         plot(all_img(idx(4,1),idx(4,2)).GrayCoMtxEig.eigVec,'mo--');
        title(['n2:' num2str(n2Sort(5))]);
          axes(handles.axes13)
        plot(all_img(idx(5,1),idx(5,2)).GrayCoMtxEig.eigVec,'mo--');
        title(['n2:' num2str(n2Sort(6))]);
    %梯度方向直方图
    case 3
        for i=1:file_num
            for j=1:img_num
                all_img(i,j).GradHistEig=fun_HofOG( all_img(i,j).imgGray);
                temp_eig=all_img(i,j).GradHistEig;
                all_n2(i,j)=norm(tar_img.GradHistEig.eigMtx-temp_eig.eigMtx);%将差向量的二范数载入矩阵
            end
        end
        %将范数矩阵转化为行向量
        n2Vec=[];
        for i=1:size(all_n2,1)
            n2Vec=[n2Vec all_n2(i,:)];
        end
        n2Sort=sort(n2Vec);%将所有二范数升序排列
        idx=zeros(2,6);%为存储相似影像下标的矩阵预分配内存
        %获取范数最小的6个矩阵的下标
        for i=2:6%前2-5个最小二范数
            [x,y]=find(all_n2==n2Sort(i));
            idx(i-1,1)=x;
            idx(i-1,2)=y;
        end
         t=sum(tar_img.GradHistEig.eigMtx);%将矩阵在行上求和
          axes(handles.axes4)
        imshow(all_img(idx(1,1),idx(1,2)).img);
        a=sum(all_img(idx(1,1),idx(1,2)).GradHistEig.eigMtx);
         p=t*a'/norm(t)/norm(a)*100;
        title(['相似度：' '%' num2str(p)]);
          axes(handles.axes5)
        imshow(all_img(idx(2,1),idx(2,2)).img);
        a=sum(all_img(idx(2,1),idx(2,2)).GradHistEig.eigMtx);
        p=t*a'/norm(t)/norm(a)*100;
        title(['相似度：' '%' num2str(p)]);
          axes(handles.axes6)
        imshow(all_img(idx(3,1),idx(3,2)).img);
        a=sum(all_img(idx(3,1),idx(3,2)).GradHistEig.eigMtx);
        p=t*a'/norm(t)/norm(a)*100;
        title(['相似度：' '%' num2str(p)]);
          axes(handles.axes7)
        imshow(all_img(idx(4,1),idx(4,2)).img);
        a=sum(all_img(idx(4,1),idx(4,2)).GradHistEig.eigMtx);
        p=t*a'/norm(t)/norm(a)*100;
        title(['相似度：' '%' num2str(p)]);
          axes(handles.axes8)
        imshow(all_img(idx(5,1),idx(5,2)).img);
       a=sum(all_img(idx(5,1),idx(5,2)).GradHistEig.eigMtx);
        p=t*a'/norm(t)/norm(a)*100;
        title(['相似度：' '%' num2str(p)]);
          axes(handles.axes9)         
        mesh(all_img(idx(1,1),idx(1,2)).GradHistEig.eigMtx);
        title(['n2:' num2str(n2Sort(2))]);
          axes(handles.axes10)
        mesh(all_img(idx(2,1),idx(2,2)).GradHistEig.eigMtx);
        title(['n2:' num2str(n2Sort(3))]);
          axes(handles.axes11)
        mesh(all_img(idx(3,1),idx(3,2)).GradHistEig.eigMtx);
        title(['n2:' num2str(n2Sort(4))]);
          axes(handles.axes12)
        mesh(all_img(idx(4,1),idx(4,2)).GradHistEig.eigMtx);
        title(['n2:' num2str(n2Sort(5))]);
          axes(handles.axes13)
        mesh(all_img(idx(5,1),idx(5,2)).GradHistEig.eigMtx);
        title(['n2:' num2str(n2Sort(6))]);
    %RGB三通道直方图
    case 4
        for i=1:file_num
            for j=1:img_num
                all_img(i,j).RHistEig=fun_HofGL( all_img(i,j).img(:,:,1));temp_eigR=all_img(i,j).RHistEig;
                all_img(i,j).GHistEig=fun_HofGL( all_img(i,j).img(:,:,2));temp_eigG=all_img(i,j).GHistEig;
                all_img(i,j).BHistEig=fun_HofGL( all_img(i,j).img(:,:,3));temp_eigB=all_img(i,j).BHistEig;
                %分别计算三个通道特征值向量差的二范数
                n1=norm(tar_img.RHistEig.eigVec-temp_eigR.eigVec);
                n2=norm(tar_img.GHistEig.eigVec-temp_eigG.eigVec);
                n3=norm(tar_img.BHistEig.eigVec-temp_eigB.eigVec);
                %三个二范数的二范数
                all_n2(i,j)=norm([n1 n2 n3]);
            end
        end
        %将范数矩阵转化为行向量
        n2Vec=[];
        for i=1:size(all_n2,1)
            n2Vec=[n2Vec all_n2(i,:)];
        end
        n2Sort=sort(n2Vec);%将所有二范数升序排列
        idx=zeros(2,6);%为存储相似影像下标的矩阵预分配内存
        %获取范数最小的6个矩阵的下标
        for i=2:6%前2-5个最小二范数
            [x,y]=find(all_n2==n2Sort(i));
            idx(i-1,1)=x;
            idx(i-1,2)=y;
        end
        t=[tar_img.RHistEig.eigVec,tar_img.GHistEig.eigVec,tar_img.BHistEig.eigVec];
          axes(handles.axes4)
        imshow(all_img(idx(1,1),idx(1,2)).img);
        a=[all_img(idx(1,1),idx(1,2)).RHistEig.eigVec,all_img(idx(1,1),idx(1,2)).GHistEig.eigVec,all_img(idx(1,1),idx(1,2)).BHistEig.eigVec];
        p=t*a'/norm(t)/norm(a)*100;
        title(['相似度：' '%' num2str(p)]);
          axes(handles.axes5)
        imshow(all_img(idx(2,1),idx(2,2)).img);
        a=[all_img(idx(2,1),idx(2,2)).RHistEig.eigVec,all_img(idx(2,1),idx(2,2)).GHistEig.eigVec,all_img(idx(2,1),idx(2,2)).BHistEig.eigVec];
        p=t*a'/norm(t)/norm(a)*100;
        title(['相似度：' '%' num2str(p)]);
          axes(handles.axes6)
        imshow(all_img(idx(3,1),idx(3,2)).img);
        a=[all_img(idx(3,1),idx(3,2)).RHistEig.eigVec,all_img(idx(3,1),idx(3,2)).GHistEig.eigVec,all_img(idx(3,1),idx(3,2)).BHistEig.eigVec];
        p=t*a'/norm(t)/norm(a)*100;
        title(['相似度：' '%' num2str(p)]);
          axes(handles.axes7)
        imshow(all_img(idx(4,1),idx(4,2)).img);
        a=[all_img(idx(4,1),idx(4,2)).RHistEig.eigVec,all_img(idx(4,1),idx(4,2)).GHistEig.eigVec,all_img(idx(4,1),idx(4,2)).BHistEig.eigVec];
        p=t*a'/norm(t)/norm(a)*100;
        title(['相似度：' '%' num2str(p)]);
          axes(handles.axes8)
        imshow(all_img(idx(5,1),idx(5,2)).img);
        a=[all_img(idx(5,1),idx(5,2)).RHistEig.eigVec,all_img(idx(5,1),idx(5,2)).GHistEig.eigVec,all_img(idx(5,1),idx(5,2)).BHistEig.eigVec];
        p=t*a'/norm(t)/norm(a)*100;
        title(['相似度：' '%' num2str(p)]);
          axes(handles.axes9)
        plot(all_img(idx(1,1),idx(1,2)).RHistEig.imgHist,'r');hold on;         
        plot(all_img(idx(1,1),idx(1,2)).GHistEig.imgHist,'g');hold on;         
        plot(all_img(idx(1,1),idx(1,2)).BHistEig.imgHist,'b');hold on;
          hold off;
        title(['n2:' num2str(n2Sort(2))]);
          axes(handles.axes10)
        plot(all_img(idx(2,1),idx(2,2)).RHistEig.imgHist,'r');hold on;         
        plot(all_img(idx(2,1),idx(2,2)).GHistEig.imgHist,'g');hold on;         
        plot(all_img(idx(2,1),idx(2,2)).BHistEig.imgHist,'b');hold on;
        title(['n2:' num2str(n2Sort(3))]);
          axes(handles.axes11)
        plot(all_img(idx(3,1),idx(4,2)).RHistEig.imgHist,'r');hold on;         
        plot(all_img(idx(3,1),idx(4,2)).GHistEig.imgHist,'g');hold on;         
        plot(all_img(idx(3,1),idx(4,2)).BHistEig.imgHist,'b');hold on;
        title(['n2:' num2str(n2Sort(4))]);
          axes(handles.axes12)
        plot(all_img(idx(4,1),idx(4,2)).RHistEig.imgHist,'r');hold on;         
        plot(all_img(idx(4,1),idx(4,2)).GHistEig.imgHist,'g');hold on;         
        plot(all_img(idx(4,1),idx(4,2)).BHistEig.imgHist,'b');hold on;
        title(['n2:' num2str(n2Sort(5))]);
          axes(handles.axes13)
        plot(all_img(idx(5,1),idx(5,2)).RHistEig.imgHist,'r');hold on;         
        plot(all_img(idx(5,1),idx(5,2)).GHistEig.imgHist,'g');hold on;         
        plot(all_img(idx(5,1),idx(5,2)).BHistEig.imgHist,'b');hold on;
        title(['n2:' num2str(n2Sort(6))]);       
        
end
set(handles.checkbox2,'value',1);
set(handles.checkbox2,'enable','on')
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
global rand
rand=1;%随机
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radiobutton1

% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
global rand
rand=0;%手动
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2







% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global option
option=get(handles.listbox1,'value');
% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
