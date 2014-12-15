%%
%
%
function shape_context_match(X, Y, n_iter, nbins_theta, nbins_r)

    if nargin ~= 5
        nbins_r = 5;
    end
    
    if nargin ~= 4
        nbins_theta = 12;
    end
    
    if nargin ~= 3
        n_iter = 5;
    end

    nsamp1 = size(X,1);
    nsamp2 = size(Y,1);
    ndum1  = 0;

    if nsamp2 > nsamp1
       % (as is the case in the outlier test)
       ndum1 = ndum1 + (nsamp2 - nsamp1);
    end

    eps_dum   = 0.15;
    r_inner   = 1 / 8;
    r_outer   = 2;
    r         = 1; % annealing rate
    beta_init = 1; % initial regularization parameter (normalized)

    % initialize transformed version of model pointset
    Xk = X;

    % initialize counter
    k = 1;
    s = 1;
    % out_vec_{1,2} are indicator vectors for keeping track of estimated
    % outliers on each iteration
    out_vec_1 = zeros(1,nsamp1); 
    out_vec_2 = zeros(1,nsamp2);

    while s

       disp(['iter=' int2str(k)])

       % compute shape contexts for (transformed) model
       [BH1,mean_dist] = sc_compute(Xk', zeros(1,nsamp1), [], nbins_theta, nbins_r, r_inner, r_outer, out_vec_1);

       % compute shape contexts for target, using the scale estimate from
       % the warped model
       % Note: this is necessary only because out_vec_2 can change on each
       % iteration, which affects the shape contexts.  Otherwise, Y does
       % not change.
       [BH2,~] = sc_compute(Y', zeros(1,nsamp2), mean_dist, nbins_theta, nbins_r, r_inner, r_outer, out_vec_2);

       % compute regularization parameter
       beta_k = (mean_dist ^ 2) * beta_init * r^(k-1);

       % compute pairwise cost between all shape contexts
       costmat = hist_cost_2(BH1, BH2);

       % pad the cost matrix with costs for dummies
       nptsd    = nsamp1 + ndum1;
       costmat2 = eps_dum * ones(nptsd, nptsd);
       costmat2(1:nsamp1,1:nsamp2) = costmat;

       % Run the Hungarian algorithm to obtain a 1-to-1 match between point
       % sets
       cost_vector = hungarian(costmat2);

       % update outlier indicator vectors
       [~,cvec2] = sort(cost_vector);
       out_vec_1 = cvec2(1:nsamp1)>nsamp2;
       out_vec_2 = cost_vector(1:nsamp2)>nsamp1;

       % Format versions of Xk and Y that can be plotted with outliers'
       % correspondences missing
       X2 = NaN(nptsd, 2);
       X2(1:nsamp1,:) = Xk;
       X2 = X2(cost_vector, :);
 
       Xnext = NaN(nptsd, 2);
       Xnext(1:nsamp1,:) = X;
       Xnext = Xnext(cost_vector,:);
 
       Y2 = NaN(nptsd, 2);
       Y2(1:nsamp2,:) = Y;

       % extract coordinates of non-dummy correspondences and use them
       % to estimate transformation
       ind_good = find(~isnan(Xnext(1:nsamp1,1)));

       % NOTE: Gianluca said he had to change nsamp1 to nsamp2 in the
       % preceding line to get it to work properly when nsamp1~=nsamp2 and
       % both sides have outliers...
       n_good = length(ind_good);
       X3b    = Xnext(ind_good,:);
       Y3     = Y2(ind_good,:);

       if true
          % show the correspondences between the untransformed images
          figure(3)
          plot(X(:,1),X(:,2),'b+',Y(:,1),Y(:,2),'ro')
          hold on
          plot([Xnext(:,1) Y2(:,1)]',[Xnext(:,2) Y2(:,2)]','g-')
          hold off
          title([int2str(n_good) ' correspondences (unwarped X)'])
          drawnow;
       end

       % Estimate regularized TPS transformation
       [cx,cy] = bookstein(X3b,Y3,beta_k);

       % warp each coordinate
       fx_aff=cx(n_good+1:n_good+3)'*[ones(1,nsamp1); X'];
       d2 = max(pdist2(X3b, X),0);
       U  = d2 .* log(d2 + eps);
       fx_wrp=cx(1:n_good)'*U;
       fx=fx_aff+fx_wrp;
       fy_aff=cy(n_good+1:n_good+3)'*[ones(1,nsamp1); X'];
       fy_wrp=cy(1:n_good)'*U;
       fy=fy_aff+fy_wrp;

       % update Xk for the next iteration
       Xk = [fx; fy]';

       % stop early if shape context score is sufficiently low
       if k >= n_iter
          s = 0;
       else
          k = k + 1;
       end
    end
end

%% Histogram cost
%
function HC = hist_cost_2(BH1,BH2)

    [nsamp1,~]     = size(BH1);
    [nsamp2,nbins] = size(BH2);

    BH1n=BH1./repmat(sum(BH1,2)+eps,[1 nbins]);
    BH2n=BH2./repmat(sum(BH2,2)+eps,[1 nbins]);
    tmp1=repmat(permute(BH1n,[1 3 2]),[1 nsamp2 1]);
    tmp2=repmat(permute(BH2n',[3 2 1]),[nsamp1 1 1]);
    HC=0.5*sum(((tmp1-tmp2).^2)./(tmp1+tmp2+eps),3);
end

%% [cx,cy,E,L]=bookstein(X,Y,beta_k);
%
% Bookstein PAMI89
function [cx,cy] = bookstein(X,Y,beta_k)

    N  = size(X,1);
    Nb = size(Y,1);

    if N ~= Nb
       error('number of landmarks must be equal')
    end

    % compute distances between left points
    r2 = pdist2(X, X);

    K = r2.*log(r2+eye(N,N)); % add identity matrix to make K zero on the diagonal
    P = [ones(N,1) X];
    L = [K  P
         P' zeros(3,3)];
    V = [Y' zeros(2,3)];

    if nargin > 2
       % regularization
       L(1:N,1:N) = L(1:N,1:N) + beta_k * eye(N,N);
    end

    c  = L \ V';
    cx = c(:,1);
    cy = c(:,2);
end

%% [BH,mean_dist] = sc_compute(Bsamp,Tsamp,mean_dist,nbins_theta,nbins_r,r_inner,r_outer,out_vec);
%
% compute (r,theta) histograms for points along boundary 
%
% Bsamp is 2 x nsamp (x and y coords.)
% Tsamp is 1 x nsamp (tangent theta)
% out_vec is 1 x nsamp (0 for inlier, 1 for outlier)
%
% mean_dist is the mean distance, used for length normalization
% if it is not supplied, then it is computed from the data
%
% outliers are not counted in the histograms, but they do get
% assigned a histogram
%
function [BH,mean_dist]=sc_compute(Bsamp,Tsamp,mean_dist,nbins_theta,nbins_r,r_inner,r_outer,out_vec)

    nsamp=size(Bsamp,2);
    in_vec=out_vec==0;

    % compute r,theta arrays
    r_array = sqrt(pdist2(Bsamp',Bsamp'));
 
    theta_array_abs = atan2(Bsamp(2,:)' * ones(1,nsamp)-ones(nsamp,1)*Bsamp(2,:),Bsamp(1,:)'*ones(1,nsamp)-ones(nsamp,1)*Bsamp(1,:))';
    theta_array     = theta_array_abs - Tsamp' * ones(1, nsamp);

    % create joint (r,theta) histogram by binning r_array and
    % theta_array

    % normalize distance by mean, ignoring outliers
    if isempty(mean_dist)
       tmp=r_array(in_vec,:);
       tmp=tmp(:,in_vec);
       mean_dist=mean(tmp(:));
    end
    r_array_n=r_array/mean_dist;

    % use a log. scale for binning the distances
    r_bin_edges=logspace(log10(r_inner),log10(r_outer),5);
    r_array_q=zeros(nsamp,nsamp);
    for m=1:nbins_r
       r_array_q=r_array_q+(r_array_n<r_bin_edges(m));
    end
    fz=r_array_q>0; % flag all points inside outer boundary

    % put all angles in [0,2pi) range
    theta_array_2 = rem(rem(theta_array,2*pi)+2*pi,2*pi);
    % quantize to a fixed set of angles (bin edges lie on 0,(2*pi)/k,...2*pi
    theta_array_q = 1+floor(theta_array_2/(2*pi/nbins_theta));

    nbins=nbins_theta*nbins_r;
    BH=zeros(nsamp,nbins);
    for n=1:nsamp
       fzn=fz(n,:)&in_vec;
       Sn=sparse(theta_array_q(n,fzn),r_array_q(n,fzn),1,nbins_theta,nbins_r);
       BH(n,:)=Sn(:)';
    end
end
