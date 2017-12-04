% First step: Create the data
create_data

% Create block matrix
use_noise = input('Is noise to be used?');
noise1 = zeros(6, NPoints);
noise2 = zeros(6, NPoints);
std_var_d = 0.1;
std_var_m = 1;
if use_noise ~= 0
    noise1(1:3,:) = std_var_d * randn(3,NPoints);
    noise1(4:6,:) = std_var_m * randn(3,NPoints);
    noise2(1:3,:) = std_var_d * randn(3,NPoints);
    noise2(4:6,:) = std_var_m * randn(3,NPoints);
end
M = block_matrix( LPluckerC1, LPluckerW2, noise1, noise2 )
%Solve problem
iterations = input('Iterations')
initial_translation = ones(3,1); 
initial_rotation = reshape(EgtSideOper(1:3,4:6), 9, 1); %reshape(eye(3), 9, 1);
[ rotation, translation ] = amm_solver( iterations, M , initial_translation, initial_rotation);

diffR = reshape(rotation, 3, 3) - EgtSideOper(4:6,1:3)
skew_t = EgtSideOper(4:6,1:3) * EgtSideOper(1:3,1:3)';