clc
%% ��Ե���
% ��ȡͼ��
A = imread('img.jpg');
 
% ת��Ϊ�Ҷ�ͼ��
A_gray = rgb2gray(A);
 
% Sobel edge detection
BW_sobel = edge(A_gray, 'sobel');
 
% Prewitt edge detection
BW_prewitt = edge(A_gray, 'prewitt');
 
% Canny edge detection
BW_canny = edge(A_gray, 'canny');
 
% ���չʾ
figure, subplot(2, 2, 1), imshow(A_gray), title('Original');
subplot(2, 2, 2), imshow(BW_sobel), title('Sobel');
subplot(2, 2, 3), imshow(BW_prewitt), title('Prewitt');
subplot(2, 2, 4), imshow(BW_canny), title('Canny');