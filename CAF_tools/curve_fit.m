function [tau,doppler] = curve_fit(A,tau_vec,dopp_vec);
% SYNTAX: [tau,doppler] = curve_fit(A,tau_vec,dopp_vec);
%
% DESCRIPTION:
% The function curve_fit takes a cross-ambiguity surface
% and applies a curve fit in the Tau direction and Doppler direction
% to obtain Tau and Doppler from the surface. The Tau and Doppler
% are returned.
%
% INPUTS:
% A - cross-ambiguity surface (Tau X Doppler)
% tau_vec - vector of time-delays used in computing surface (1xTau)
% dopp_vec - vector of Doppler frequenices used in computing surface
% (1xDoppler)
%
% OUTPUTS:
% tau - Tau measured off the surface (scalar)
% doppler - Doppler measured off the surface (scalar)
%
% ASSUMPTIONS:
% There is enough room to the right and left of the surface peak
% to be able to pick points (e.g. surface peak not at edge)
%
% Interpolation to peak has already been taken care of
%
% AUTHOR:
% C. Yatrakis
% Get peak indices
[j1,dopp_pk_index] = max(max(A));
[j2,tau_pk_index] = max(max(A,[],2));
% Get Tau values to apply curve fit to
tau_values = A(tau_pk_index-2:tau_pk_index+2,dopp_pk_index);
% Get Tau curve fit coefficients
[tau_cf_coefs] = polyfit([tau_vec(tau_pk_index-2:tau_pk_index+2)],tau_values.',2);
% Get Doppler values to apply curve fit to
dopp_values = A(tau_pk_index,dopp_pk_index-2:dopp_pk_index+2);
% Get Doppler curve fit coefficients
[dopp_cf_coefs,s,mu] = polyfit([dopp_vec(dopp_pk_index-2:dopp_pk_index+2)],dopp_values,2);
% Calculate Tau and Doppler from the surface peak
tau = -tau_cf_coefs(2)/(2*tau_cf_coefs(1));
doppler = -dopp_cf_coefs(2)/(2*dopp_cf_coefs(1));