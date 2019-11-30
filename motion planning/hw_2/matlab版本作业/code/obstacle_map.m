 function map = obstacle_map(xStart,yStart,xTarget,yTarget,MAX_X,MAX_Y)
%This function returns a map contains random distribution obstacles.
    %��ȡ0-1���ȷֲ����������[MAX_X,MAX_Y]
    rand_map = rand(MAX_X,MAX_Y);
    map = [];
    map(1,1) = xStart;
    map(1,2) = yStart;
    k=2;
    %�ϰ�����
    obstacle_ratio = 0.25;
    for i = 1:1:MAX_X
        for j = 1:1:MAX_Y
            %�ж��Ƿ�Ҫ����ϰ����Ҫ�����������ֵ
            %matlab��~=Ϊ�����ڵ���˼����C�е�!=
            if( (rand_map(i,j) < obstacle_ratio) && (i~= xStart || j~=yStart) && (i~= xTarget || j~=yTarget))
                map(k,1) = i;
                map(k,2) = j;
                k=k+1;
            end    
        end
    end
    %������ĩβ���Ŀ������
    map(k,1) = xTarget;
    map(k,2) = yTarget;
end

