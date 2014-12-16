%% Thin-plate parameter estimation run-wrapper
function [output,Ppad,Qpad] = morph_tps_wrapper(im1, im2, P, Q, warp_frac, dissolve_frac)
    
    [im1,im2,Ppad,Qpad] = matchdim(im1, im2, @zeropad);

    P(:,1) = P(:,1) + Ppad.S;
    P(:,2) = P(:,2) + Ppad.W;
    Q(:,1) = Q(:,1) + Qpad.S;
    Q(:,2) = Q(:,2) + Qpad.W;
    P      = [P ; borders(size(im1),3)];
    Q      = [Q ; borders(size(im2),3)];

    I       = lerp(P, Q, warp_frac);
    [r,c,~] = size(im1);
    
    [PR_a1, PR_ax, PR_ay, PR_w] = est_tps(I, P(:,1));
    [PC_a1, PC_ax, PC_ay, PC_w] = est_tps(I, P(:,2));

    S = morph_tps(im1 ...
                 ,PR_a1, PR_ax, PR_ay, PR_w ...
                 ,PC_a1, PC_ax, PC_ay, PC_w ...
                 ,I ...
                 ,[r c]);
             
    [QR_a1, QR_ax, QR_ay, QR_w] = est_tps(I, Q(:,1));
    [QC_a1, QC_ax, QC_ay, QC_w] = est_tps(I, Q(:,2));

    T = morph_tps(im2 ...
                 ,QR_a1, QR_ax, QR_ay, QR_w ...
                 ,QC_a1, QC_ax, QC_ay, QC_w ...
                 ,I ...
                 ,[r c]);
    
    output = lerp(S, T, dissolve_frac);
end

