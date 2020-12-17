% Value of Information with No correlation

% The script devises the schedule for v2x communication by taking into
% account the value of information provided by the different camera sensors
% on the car.

% Size of the packets in bits
size = 8*[1300, 180, 180, 140, 140];
% Capacity of the channel in kbps
C = 20000:5000:120000;
% Number of objects created by the sensors per second
num_of_objs = [10,10,10,10,10];
% Total number of objects to be sent out over the 10000 timesteps
total_num_of_objs = 1000*num_of_objs;
comp = 1;
final_result3 = {};
pkts_sent3 = zeros(length(C),5);
y3 = [];
% Running the script for each capacity values
for it=1:length(C)
%   Value of information vector predefined by the application
    v = [1, 0.7, 0.7, 0.4, 0.4];
%   Correlation Matrix between different sensors as predefined by the application
    W = [1 0.7 0.7 0.7 0.7; 0.7 1 0 0.5 0.5; 0.7 0 1 0 0; 0.7 0.5 0 1 0.1; 0.7 0.5 0 0.1 1];
    p = 0;
    w = 0;
    objs_to_be_txs = zeros(1,5);
    last_sent = ones(1,5);
    result3 = [];
    sizes3 = [];
    seq3 = {};
    total = C(it);
    new_v = v;
%   Run the scheduling algorithm over 10000 timesteps
    for index=1:1000
        w = 0;
        s = [];
        final_size = 0;
        size_final = 0;
        rem_num_of_objs = num_of_objs;
        while final_size < total
            [maximum, ind] = max(new_v);
            if (ind == 2 || ind == 3)
                t_ind = randperm(2,1);
                if t_ind == 1
                    ind = 2;
                end
                if t_ind == 2
                    ind = 3;
                end
            end
            if (ind == 4 || ind == 5)
                t_ind = randperm(2,1);
                if t_ind == 1
                    ind = 4;
                end
                if t_ind == 2
                    ind = 5;
                end
            end
            while (rem_num_of_objs(ind) == 0)
                check = rem_num_of_objs ~= 0;
                if sum(check) > 1
                    new_v(ind) = -inf;
                    [m,ind] = max(new_v);
                else
                    ind = find(rem_num_of_objs);
                    break;
                end
                
            end
            if final_size+size(ind) > total
                break;
            else
                s = [s ind];
                rem_num_of_objs(ind) = rem_num_of_objs(ind) - 1;
                pkts_sent3(it,ind) = pkts_sent3(it,ind) + 1;
                
                if (ind == 1)
                    new_v(ind) = 0;
                else
                    if (ind == 2 || ind == 3)
                        new_v(ind) = 0;
                    else
                        if (ind == 4)
                            new_v(ind) = 0;
                        else
                            new_v = v;
                        end
                    end
                    
                end
                final_size = final_size +size(ind);
            end
            
            
        end
%       Calculate the value of information for the schedule defined
        for k=1:length(s)-1
            if s(k) == s(k+1)
                w = w + 0;
            else
                w = w+(1-W(s(k),s(k+1)))*v(s(k))*v(s(k+1));
            end
            size_final = size_final + size(s(k));
        end
        result3(index) = w;
        sizes3(index) = final_size;
        seq3{index} = s;
        
    end
    final_result3{it} = result3;
    y3(it) = mean(result3);
    
end
