clc
%% 图像二值化
% 流程：灰度 - double - im2bw，第2个参数要 ∈[0,1] ，阈值除以 255 带入 。
% 读取图片
A = imread('img.jpg');
 
% 转化为灰度图像
A_gray = rgb2gray(A);
 
figure,imhist(A_gray),title('hist of A_grey');
 
% 将矩阵数值转化为double数值
A_gray = im2double(A_gray);
 
% 是用Otsu算法生成阈值
otsu_level = graythresh(A_gray);
 
% Otsu算法和周期性取阈值生成二值化图像
B_otsu_thresh = im2bw(A_gray, otsu_level);
B_thresh_50 = im2bw(A_gray, 50/255);
B_thresh_100 = im2bw(A_gray, 100/255);
B_thresh_150 = im2bw(A_gray, 150/255);
B_thresh_200 = im2bw(A_gray, 200/255);
 
% 结果展示
figure, subplot(2, 3, 1), imshow(A_gray), title('Original image');
subplot(2, 3, 2), imshow(B_otsu_thresh), title('Binary image using Otsu threshold value');
subplot(2, 3, 3), imshow(B_thresh_50), title('Binary image using threshold value = 50');
subplot(2, 3, 4), imshow(B_thresh_100), title('Binary image using threshold value = 100');
subplot(2, 3, 5), imshow(B_thresh_150), title('Binary image using threshold value = 150');
subplot(2, 3, 6), imshow(B_thresh_200), title('Binary image using threshold value = 200');