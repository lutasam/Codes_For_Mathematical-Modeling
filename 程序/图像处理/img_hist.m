clc
%% 图像直方图统计
% 读取图像
A = imread('img.jpg');
B = imread('img.jpg');
 
% 将图像转化为灰度通道
A = rgb2gray(A);
 
% 展现灰度图直方图统计
figure, subplot(1,3,1),imhist(A), title('Histogram of read image');
        subplot(1,3,2),imshow(A),title('Grayscale image');
        subplot(1,3,3),imshow(B),title('RGB image');
        
% 展现RGB图直方图统计
figure, imhist(B(:, :, 1)), title('Histogram of 1st channel of read image');
figure, imhist(B(:, :, 2)), title('Histogram of 2nd channel of read image');
figure, imhist(B(:, :, 3)), title('Histogram of 3rd channel of read image');

%% 灰度直方图均衡化
% 读取图像
A = imread('img.jpg');

% 转化成灰度图像
A = rgb2gray(A);
 
% 直方图均衡化
A_histeq = histeq(A);
 
% 展现原始图像和均衡化图像
figure, subplot(2, 2, 1), imshow(A), title('Original Image');
subplot(2, 2, 2), imshow(A_histeq), title('Equalized Image');
subplot(2, 2, 3), imhist(A), title('Histogram of Original Image');
subplot(2, 2, 4), imhist(A_histeq), title('Histogram of Equalized Image');

%% HSV图像直方图均衡化
%流程：RGB图片转化为HSV 图片，然后对HSV图片的V进行均衡化，均衡化后重新转化为RGB图片
A = imread('img.jpg');
 
% 转化为HSV图像
A_hsv = rgb2hsv(A);
 
% 对HSV图片的V进行均衡化
A_hsv(:, :, 3) = histeq(A_hsv(:, :, 3));
 
% 将HSV再转化为RGB
A_histeq = hsv2rgb(A_hsv);
 
% 展现原始图像和均衡化图像
figure, subplot(1, 2, 1), imshow(A), title('Original RGB image');
subplot(1, 2, 2), imshow(A_histeq), title('Equalized RGB image');