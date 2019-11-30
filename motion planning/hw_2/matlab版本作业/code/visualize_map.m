function visualize_map(map,path)
%This function visualizes the 2D grid map 
%consist of obstacles/start point/target point/optimal path.

    % obstacles
    % size(map, 1)���ص�ͼ(�ϰ���+��ʼ��Ŀ���)�ĸ�����������map�����һͨ������Ŀ
    % ������ʼ�㿪ʼ���
    for obs_cnt = 2: size(map, 1) - 1
        % ����ɢ��ͼ�������ɵ�
        % scatter(x,y,��Ĵ�С����ɫ��'���')
        % -0.5��Ϊ�˱�֤��ӵ��ϰ����ڷ�������
        scatter(map(obs_cnt, 1)-0.5,map(obs_cnt, 2)-0.5,250,155,'filled');
        % ����ͼ������������
        hold on;
        grid on;
        %grid minor;
        % axis equal ����������Ķ���ϵ�������ֵͬ ,����λ������ͬ
        axis equal;        
        % �趨�������귶Χ
        axis ([0 10 0 10 ]);
        hold on;
    end
    % start point
    % ��ʼ����Ϊ��ɫ�Ǻ�
    scatter(map(1, 1)-0.5, map(1, 2)-0.5,'b','*');
    hold on;
    % target point
    % �յ���Ϊ��ɫ�Ǻ�
	scatter(map(size(map, 1), 1)-0.5, map(size(map, 1), 2)-0.5, 'r','*');
    hold on;
    %optimal path
    % ����or�滮��·��
    for path_cnt = 2:size(path,1)-1
        scatter(path(path_cnt,1),path(path_cnt,2),'b');
        hold on;
    end

end

