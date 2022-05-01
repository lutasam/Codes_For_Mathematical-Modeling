clc
%% 图像形态学
% Erosion 腐蚀 ：imerode 分离相连物体，去毛刺，让物体变小；
% Dilation 膨胀 imdilate，拼接物体，填表面小坑，物体变大。
% 开运算：先腐蚀再膨胀，分离物体、去毛刺、去小点（物体点），去小部件，表面坑变小。
% 闭运算：先膨胀再腐蚀，表面坑被填，内部背景点消失，表面坑被填，毛刺不变。
% 读取图片
A = imread('img.jpg');
 
% 转化为灰度图像
A = rgb2gray(A);
 
% 生成结构元素
se = strel('disk', 15);
 
% 腐蚀
B_eroded = imerode(A, se);
 
% 膨胀
B_dilated = imdilate(A, se);
 
% 开运算
B_open = imopen(A, se);
 
% 闭运算
B_close = imclose(A, se);

% 结果展示
figure, subplot(2, 3, 1), imshow(A), title('Original read image');
subplot(2, 3, 2), imshow(B_eroded), title('Original image after Erosion');
subplot(2, 3, 3), imshow(B_dilated), title('Original image after Dilation');
subplot(2, 3, 4), imshow(B_open), title('Original image after Opening');
subplot(2, 3, 5), imshow(B_close), title('Original image after Closing');

%% 利用膨胀得到物体边缘
% Read an input image
A = imread('img.jpg');
 
% Convert the read image to single channel image
A = rgb2gray(A);
 
% Generate structuring element for use
se = strel('disk', 5);
 
% Perform image dilation
% To get the object boundary, subtract the original image from the dilated
% version of the orginal image
B_dilated = imdilate(A, se);
 
% Subtract the original image from dilated image
B_boundary = B_dilated - A;
 
% Display images side by side
figure, subplot(1, 3, 1), imshow(A), title('Original image');
subplot(1, 3, 2), imshow(B_dilated), title('Original image after Dilation');
subplot(1, 3, 3), imshow(B_boundary), title('Original image with highlighted binary object boundaries');

%% 利用腐蚀得到物体边缘
% Read an input image
A = imread('img.jpg');
 
% Convert the read image to single channel image
A = rgb2gray(A);
 
% Generate structuring element for use
se = strel('disk', 5);
 
% Perform image erosion
B_eroded = imerode(A, se);
 
% Subtract the eroded image from original image
B_boundary = A - B_eroded;
 
% Display images side by side
figure, subplot(1, 3, 1), imshow(A), title('Original image');
subplot(1, 3, 2), imshow(B_eroded), title('Original image after Erosion');
subplot(1, 3, 3), imshow(B_boundary), title('Original image with highlighted binary object boundaries');