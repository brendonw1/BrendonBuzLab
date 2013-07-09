function [StateInds,StateBounds]=ExtractStateBounds(states,statenumber,varargin)
%function [StateInds,StateBounds]=ExtractStateBounds(states,statenumber,minduration)
% Gets index number lists and boundaries for each state defined in
% StateEditor
% INPUTS:
% -'states' comes from StateEditor (loaded into matlab), has a 1-5 number
% for each behavioral state (waking, drowsy/freezing, nREM, Intermediate,
% REM)
% -'statenumber' signifies which of the above 5 states is being searched for
% -'minduration' optional specification of minimum duration for states to
% be included in 'StateBounds'
%
% OUTPUTS:
% -'StateInds': a list of all timepoints (one per second) where the animal
% is in the specified state 
% -'StateBounds': a series of pairs of points specifying the respective
% start and stop of each contiguous time period in the specified state

StateInds = find(states==statenumber);

jumps = find(diff(StateInds)>1);
starts = [1,jumps+1];
stops = [jumps,length(StateInds)];
StateBounds = [StateInds(starts)',StateInds(stops)'];

if ~isempty(varargin)%if a minumum duration entered, exclude too-short periods
    minduration = varargin{1};
    durations = diff(StateBounds,1,2);
    tooshort = find(durations<minduration);
    StateBounds(tooshort,:)=[];
end
    