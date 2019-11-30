% Used for Motion Planning for Mobile Robots
% Thanks to HKUST ELEC 5660 
close all; clear all; clc;

% Renderer(ɨ����)��һ��ͼ������ת������ͨ��������򣬿��԰�ͼ������ת��ΪMatlab����������ͼ�����ݡ�
% ����������⣺Renderer(��Ⱦ���������)��matlab������ͼ����������ת��Ϊͼ�񣩵ķ�ʽ��
% �����ַ�ʽ��1��Painters   2)  Z-buffer  3)  OpenGL
% 
% 2.���ַ�ʽ�ıȽ�
% 1)painters  �ٻ��򵥵�ͼ��ʱ���ȽϿ죻
% 2)z-buffer �ֳ���Ȼ��弼�������������ڴ��л�ͼ��Ȼ���ٽ����յ�ͼ����ʾ����ʾ�նˡ������Ļ�������һ�����ص㣬�������θ�ֵ�Ļ�����ֻ����ʾ��߲��ͼ��
% 3) opengl ������Ӳ�����л�ͼ�ķ�ʽ��
set(gcf, 'Renderer', 'painters');
% ����ͼ��Ĵ�С���ֱ����x�᳤�ȣ�y�᳤�ȣ�ͼ�񳤶ȣ�ͼ��߶ȡ�
set(gcf, 'Position', [500, 50, 700, 700]);

% Environment map in 2D space 
xStart = 1.0;
yStart = 1.0;
xTarget = 9.0;
yTarget = 9.0;
MAX_X = 10;
MAX_Y = 10;
map = obstacle_map(xStart, yStart, xTarget, yTarget, MAX_X, MAX_Y);

% Waypoint Generator Using the A* 
% path = A_star_search(map, MAX_X,MAX_Y);
path=[];
% visualize the 2D grid map
visualize_map(map, path);
