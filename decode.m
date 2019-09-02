%% SIMPLE: Single-Frame based Physical Layer Identification for
%% Intrusion Detection and Prevention on In-Vehicle Networks

% Please cite this script and the dataset using the following bibtex:

% @inproceedings{foruhandeh19_simple,
% title= {SIMPLE: Single-Frame based Physical Layer Identification for
% 	Intrusion Detection and Prevention on In-Vehicle Networks},
% booktitle= {Proceedings of the 35th Annual Computer Security Applications Conference},
% author= {Mahsa Foruhandeh, Yanmao Man, Ryan Gerdes, Ming Li, Thidapat Chantem},
% year= {2019},
% }

function [bin, id] = decode(canh, ack_thr, dom_thr)
%% decode a can frame into bits
% input:
% 		canh: 		CAN high voltage samples
%		ack_thr:	ACK threshold 
%		dom_thr:	dominate voltage threshold
% output:
%		bin:		binary array of the frame
%		id:			id of the frame

% indices of all dominant signals
up  = diff(find(canh > dom_thr & canh < ack_thr));
% indices where there is an edge
jmp = find(up > 1);

% the indices of jumps are dominant bits
dom = diff([0; jmp]);
% the values at jumps are recessive bits
rec = up(jmp) - 1;

% samples per bit (based on the ack at the end)
spb = length(canh(canh > ack_thr));

% merge dom and rec
seg = round([dom, rec] / spb);
seg = seg';
seg = cumsum(seg(:));

% construct binary array
bin = zeros([1, seg(end)]);
for i = 1:2:length(seg)
	% fill dominant segment with ones
	bin(seg(i)+1:seg(i+1)) = 1;
end

% convert ID from binary into decimal
bin = bin(1:end-1);
if bin(14) == 0
	id = bi2de(bin(2:12), 'left-msb');
else
	id = bi2de([bin(2:12), bin(15:32)], 'left-msb');
end
