function [ rotation, translation ] = amm_solver( iterations, M , initial_translation, initial_rotation)
    %AMM_SOLVER Summary of this function goes here
    %   Detailed explanation goes here
    %Consider the first state for both the translation and rotation:
    translation = initial_translation;
    rotation = initial_rotation;
    previous_rotation = zeros(1,9);
    interation = 0;
    %for i = 1:iterations
    while norm(previous_rotation - rotation, 'fro') > 1e-15
        % Minimize the of according to the rotation, knowing the translation
        fun = @(x)objective_function( M, translation, x);
        nonlcon = @orthogonal_restriction;
        options = optimoptions('fmincon', 'Display', 'iter','ConstraintTolerance',1e-9, ...
        'FunctionTolerance',1e-12);
        A = [];
        b = [];
        Aeq = [];
        beq = [];
        lb = [];
        ub = [];
        previous_rotation = rotation;
        rotation = fmincon(fun,rotation,A,b,Aeq,beq,lb,ub,nonlcon, options);
        % Minimize the of according to the translation, knowing the rotation
        fun = @(x)objective_function( M, x, rotation);
        translation = fminunc(fun,translation);
        interation = interation + 1
    end
    rotation = reshape(rotation, 3, 3);
end

