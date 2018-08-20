% % NaN제거
OBS_stn(~isfinite(OBS_stn))=0;


% % 연적산값 만들기, 100사이트별
s_stn = zeros(33,100);
for i = 1:33
    for j = 1:365
        for k = 1:100
            s_stn(i,k) = s_stn(i,k)+OBS_stn((i-1)*365+j,k+1);
        end
        clear k
    end
    clear j
end
clear i

% % 가까운 사이트 10곳 찾기, 100사이트별
n_stn = zeros(100,10);
for i = 1:100
    temp = zeros(100,2);
    for j = 1:100
        temp(j,1) = ((a_stn(j,1)-a_stn(i,1))^2+(a_stn(j,2)-a_stn(i,2))^2)^0.5;
        temp(j,2) = j;
    end
    clear j
    for j = 1:10
        [a b] = min(temp(:,1));
        n_stn(i,j) = temp(b,2);
        temp(b,:) =[];
    end
    clear j temp a b
end
clear i

% % 강수량 결측 가까운 사이트 값으로 채우기
OBS_stn_raw = OBS_stn;
for i = 1:33
    for j = 1:100
        if s_stn(i,j)<600
            if s_stn(i,n_stn(j,2))>600
                for k = 1:365
                    OBS_stn((i-1)*365+k,j+1)=OBS_stn((i-1)*365+k,n_stn(j,2)+1);
                end
                clear k
            elseif s_stn(i,n_stn(j,3))>600
                for k = 1:365
                    OBS_stn((i-1)*365+k,j+1)=OBS_stn((i-1)*365+k,n_stn(j,3)+1);
                end
                clear k
            elseif s_stn(i,n_stn(j,4))>600
                for k = 1:365
                    OBS_stn((i-1)*365+k,j+1)=OBS_stn((i-1)*365+k,n_stn(j,4)+1);
                end
                clear k
            elseif s_stn(i,n_stn(j,5))>600
                for k = 1:365
                    OBS_stn((i-1)*365+k,j+1)=OBS_stn((i-1)*365+k,n_stn(j,5)+1);
                end
                clear k
            end
        end
    end
end
clear i j

% % 연적산값 확인하기, 100사이트별
s_stn_raw = s_stn;
s_stn = zeros(33,100);
for i = 1:33
    for j = 1:365
        for k = 1:100
            s_stn(i,k) = s_stn(i,k)+OBS_stn((i-1)*365+j,k+1);
        end
        clear k
    end
    clear j
end
clear i

% % OBS_city 만들기 (230곳 시군구에서 가까운 100사이트 값 가져오기)
OBS_city = zeros(12053,230);
for i = 1:230
    temp2 = zeros(100,1);
    for j = 1:100
        temp2(j,1) = ((a_stn(j,1)-a_city(i,1))^2+(a_stn(j,2)-a_city(i,2))^2)^0.5;
    end
    clear j
    [a b] = min(temp2(:,1));
    clear a
    temp2 = b;
    %clear b
    OBS_city(:,i) = OBS_stn(:,temp2+1);
    clear temp2
end
clear i






