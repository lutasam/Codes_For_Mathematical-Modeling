clc
%% ͼ��ֱ��ͼͳ��
% ��ȡͼ��
A = imread('img.jpg');
B = imread('img.jpg');
 
% ��ͼ��ת��Ϊ�Ҷ�ͨ��
A = rgb2gray(A);
 
% չ�ֻҶ�ͼֱ��ͼͳ��
figure, subplot(1,3,1),imhist(A), title('Histogram of read image');
        subplot(1,3,2),imshow(A),title('Grayscale image');
        subplot(1,3,3),imshow(B),title('RGB image');
        
% չ��RGBͼֱ��ͼͳ��
figure, imhist(B(:, :, 1)), title('Histogram of 1st channel of read image');
figure, imhist(B(:, :, 2)), title('Histogram of 2nd channel of read image');
figure, imhist(B(:, :, 3)), title('Histogram of 3rd channel of read image');

%% �Ҷ�ֱ��ͼ���⻯
% ��ȡͼ��
A = imread('img.jpg');

% ת���ɻҶ�ͼ��
A = rgb2gray(A);
 
% ֱ��ͼ���⻯
A_histeq = histeq(A);
 
% չ��ԭʼͼ��;��⻯ͼ��
figure, subplot(2, 2, 1), imshow(A), title('Original Image');
subplot(2, 2, 2), imshow(A_histeq), title('Equalized Image');
subplot(2, 2, 3), imhist(A), title('Histogram of Original Image');
subplot(2, 2, 4), imhist(A_histeq), title('Histogram of Equalized Image');

%% HSVͼ��ֱ��ͼ���⻯
%���̣�RGBͼƬת��ΪHSV ͼƬ��Ȼ���HSVͼƬ��V���о��⻯�����⻯������ת��ΪRGBͼƬ
A = imread('img.jpg');
 
% ת��ΪHSVͼ��
A_hsv = rgb2hsv(A);
 
% ��HSVͼƬ��V���о��⻯
A_hsv(:, :, 3) = histeq(A_hsv(:, :, 3));
 
% ��HSV��ת��ΪRGB
A_histeq = hsv2rgb(A_hsv);
 
% չ��ԭʼͼ��;��⻯ͼ��
figure, subplot(1, 2, 1), imshow(A), title('Original RGB image');
subplot(1, 2, 2), imshow(A_histeq), title('Equalized RGB image');