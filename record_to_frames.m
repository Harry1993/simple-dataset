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

function record_to_frames(record_filename)
%% The function takes the filename of a record as input, and splits the record
% into several frames. Finally, each frame is stored in a separate .mat file.

%% Some parameters specific to datasets
% two frames must be away from each other for offset samples
offset = 300;
% voltage greater than thr_head is considered as the beginning of a frame
thr_head = 3;		
% voltage greater than thr_tail is the end of a frame (ACK)
thr_tail = 4;		
% a frame should be at least 5000 samples; shorter ones will be discarded
min_len = 5000;		

%% Reading all samples from a record
data = load(record_filename);
canh = data.ch1 * data.yinc; % can high voltage samples
canl = data.ch2 * data.yinc; % can low  voltage samples

%% Adjust the recessive voltage to 2.5 V
% The adjustment is based on the samples within the recessive range 
% (please make sure that recessive_range contains recessive samples only).
recessive_range = 1:1e4;
mh = mean(canh(recessive_range));
ml = mean(canl(recessive_range));
canh = canh - mh + 2.5;
canl = canl - ml + 2.5;

%% go through the entire record
frm_ind = 0; % frame index
while(1)

	% indices of all dominant samples
	one = find(canh>thr_head & canh<thr_tail);
	% indices of all ACK samples
	two = find(canh>thr_tail);
	
	% if there is no valid frame left
	if isempty(one) || isempty(two)
		break;
	end

	% focus on the first frame at this iteration; the next frame will be
	% extracted next iteration;
	head = one(1) - offset;
	tail = two(1) + offset;

	% if this is an incomplete frame (or simply too short)
	if tail > length(canh) || tail - head < min_len
		break;
	end

	% this frame is too close to the last one (closer than offset), so
	% cut it out of the record and continue to the next frame
	if head < 1
		canh = canh(tail:end); 
		canl = canl(tail:end);
		continue;
	end

	% now we have a good frame
	ch = canh(head:tail);
	cl = canl(head:tail);
	% so decode it...
	[bin, id] = decode(ch, thr_tail, thr_head);

	% sometimes id is 0...
	if ~id
		canh = canh(tail:end);
		canl = canl(tail:end);
		continue;
	end

	% save this frame to a .mat file
	t = data.curt;
	s = data.s;
	save([num2str(frm_ind), '.mat'], 'ch', 'cl', 't', 's', 'bin', 'id');
	fprintf('%s %i\n', record_filename, frm_ind);

	% continue with the rest of the record
	canh = canh(tail:end);
	canl = canl(tail:end);
	frm_ind = frm_ind + 1;
end
