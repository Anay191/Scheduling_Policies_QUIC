% QUIC-EST (Value of Information with Sensor and Time Correlation)

% The script devises the schedule for haptic communication by taking into
% account the value of information provided by the different camera sensors
% on the car as well as the correlation of the packets between different
% sensors and correlation over time between the packets sent out by
% each sensor. The script also devises the schedule using FIFO.

% Capacity of the channel in kbps
C = 1000:100:5000;
num_of_objs = ones(1,44);
% Size of the packets in bits
size = 8*0.004*num_of_objs;
% Total number of objects to be sent out over the 1000 timesteps or 1
% second
total_num_of_objs = 1000*num_of_objs;
comp = 1;
final_result6 = {};
final_result7 = {};
final_y_haptic = [];
final_y_fifo = [];
%  Run the scheduling algorithm over 100 timesteps
for n = 1:100
    y6 = [];
    y7 = [];
%   Running the script for each capacity values
    for it=1:length(C)
        v = ones(1,44);
        val = zeros(1,44);
        result6 = [];
        sizes6 = [];
        seq6 = {};
        result7 = [];
        sizes7 = [];
        seq7 = {};
        total = C(it)/1000;
        new_v = v;
        for index=1:1000
            size_final = 0;
            size_final2 = 0;
            w = 0;
            w2 = 0;
            val = val + normrnd(0,1,[1,length(val)]);
%           Value of Information Update with respect to Haptic Model
            new_v = sigmoid_tele(abs(val));
%           QUIC-EST scheduler for Haptic Communication
            [sorted, indices] = sort(new_v,'descend');
            s = indices(cumsum(size) < total);
            rem = indices(length(s)+1:end);
            val(s) = 0;
%           QoE Calculation for QUIC-EST
            w = sum(new_v(rem));
            
            result6(index) = w;
            sizes6(index) = size_final;
            seq6{index} = s;
            
%           FIFO Scheduler for Haptic Communication
            ind = randperm(44);
            s2 = ind(cumsum(size) < total);
            rem2 = ind(length(s2)+1:end);
%           QoE Calculation for QUIC-EST
            w2 = sum(new_v(rem2));
            
            result7(index) = w2;
            sizes7(index) = size_final2;
            seq7{index} = s2;
        end
        final_result6{it} = result6;
        y6(it) = mean(result6);
        final_result7{it} = result7;
        y7(it) = mean(result7);
    end
    final_y_haptic(n,:) = y6;
    final_y_fifo(n,:) = y7;
end

