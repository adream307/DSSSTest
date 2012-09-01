function [sig,msg]=dsss_modulation(primdf,init_states,sample_fs,carry_fs,chip_bps,src_bps,src)
% Direct-sequence spread spectrum test with matlab
% input:
%      primdf      -- primitive polynomials for a Galois field
%      ini_states  -- the initial states for commsrc.pn
%      sample_fs   -- sample frequence for the output signal
%      carry_fs    -- carry frequence
%      chip_bps    -- chip bps
%      src_bps     -- the information source pbs
%      src         -- the information which will be modulated
% output:
%      sig         -- the output signal which has been modulated
%      msg         -- the message which modulated into the carrier
x=zeros(size(init_states));
x(length(x))=1;
chip_len=chip_bps/src_bps*length(src);
h=commsrc.pn('GenPoly',primdf,...
    'InitialStates',init_states,...
    'CurrentStates',init_states,...
    'Mask',x,...
    'NumBitsOut',chip_len);
s=generate(h)';
x=repmat(src,chip_bps/src_bps,1);
x=reshape(x,1,length(s));
msg=bitxor(s,x);
sig=bpsk_modulatlion(sample_fs,carry_fs,chip_bps,msg);
    