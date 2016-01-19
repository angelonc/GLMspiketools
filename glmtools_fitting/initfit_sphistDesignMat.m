function Xstruct = initfit_sphistDesignMat(gg,Xstruct)
%  Xstruct = initfit_sphistDesignMat(gg,Xstruct)
%
%  Sets parameters relating to optimization of
%  spike-filter terms in the point process GLM and inserts them into design
%  matrix structure 'Xstruct'



% --- Recurrent (self) post-spike filter -----------------
if ~isempty(gg.ihw), 
    Xstruct.nh=size(gg.ihbas,2);
    Xstruct.ihbas = gg.ihbas;
else
    Xstruct.nh=0;   % Number of basis vectors describing ih
    Xstruct.ihbas = []; % Number of basis vectors describing ih
end

% --- Coupling Filters -----------------------------------
Xstruct.ncpl = length(gg.couplednums); % Number of coupled cells

% set basis for coupling filters
if ~isempty(gg.ihw2)  
    Xstruct.nh2 = size(gg.ihbas2,2);  % # params describing coupling filters
    Xstruct.ihbas2 = gg.ihbas2; % relevant basis
else  % No coupling terms
    Xstruct.nh2=0;
    Xstruct.ihbas2 = []; % relevant basis
end

% Flag for whether or not to worry about ih params
if (Xstruct.nh2 == 0) && (Xstruct.nh == 0)
    Xstruct.ihflag = 0;
else
    Xstruct.ihflag = 1;
end

% ----------------------

% ------ Construct design matrix ----------------------------
Ih = zeros(ilen,nh+nh2*nCoupled);
Ih(:,1:nh) = spikeconv_mex(SPNDS, OPRS.ihbas, iwin1);
for jcpl = 1:nCoupled
    Ih(:,nh+nh2*(jcpl-1)+1:nh+nh2*jcpl) = ...
        spikeconv_mex(SPNDS2{jcpl}, OPRS.ihbas2, iwin1);
end