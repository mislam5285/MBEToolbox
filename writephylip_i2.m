function writephylip_i2(aln,filename)
%WRITEPHYLIP_I2 - Write into an interleaved PHYLIP formatted file in codon frame
%
% Syntax:  writephylip_i2(aln,'filename')
%
% Inputs:
%    aln         - Alignment structure
%    filename    - interleaved PHYLIP file.
%
% See also: READPHYLIP_I, WRITEPHYLIP_S, READPHYLIP_S

% Molecular Biology and Evolution Toolbox (MBEToolbox)
% Author: James Cai
% Email: jcai@tamu.edu
% Website: http://bioinformatics.org/mbetoolbox/
% 
% $LastChangedDate: 2013-01-05 12:04:29 -0600 (Sat, 05 Jan 2013) $
% $LastChangedRevision: 327 $
% $LastChangedBy: jcai $



if nargin < 2
    [filename, pathname, filterindex] = uiputfile( ...
       {'*.phylip;*.phy', 'Phylip Format Files (*.phylip, *.phy)';
        '*.*',  'All Files (*.*)'}, ...
        'Save as');
	if ~(filename), return; end
	filename=[pathname,filename];

	if (filterindex==1)
	if (isempty(find(filename=='.')))
		filename=[filename,'.phy'];
	end
	end
end

[n,m]=size(aln.seq);
p=1:n; q=1:m;
[NT,AA] = seqcode;

switch (aln.seqtype)
    case (3)	% Protein
	aln.seq(find(isnan(aln.seq)))=i_getcode4gap('PROTEIN');
	Seq(p,q)=AA(aln.seq(p,q));
    otherwise	% nucleotides
	aln.seq(find(isnan(aln.seq)))=i_getcode4gap('DNA');
	Seq(p,q)=NT(aln.seq(p,q));
end


fid = fopen(filename,'wt');
if fid == -1
   disp('Unable to open file.');
   return
end

fprintf(fid, [' %d %d\n'],n,m);
mt = 1:60:size(Seq,2);
mt = cat(1,mt',size(Seq,2)+1);

for j=1:length(mt)-1
for (i=1:n),
s=char(Seq(i,[mt(j):mt(j+1)-1]));


%gapstep=3;
gapstep=10;
if (0),
    idx=1:gapstep:length(s);
    idx = cat(1,idx',length(s)+1);
    ss='';
    for (k=1:length(idx)-1),
          ss=[ss,' ',char(s([idx(k):idx(k+1)-1]))];
    end
else
    ss=s;
end


	if (j==1)
		name=char(aln.seqnames(i));
		fprintf(fid, ['%10s%s\n'], i_name10(name), ss);
	else
		fprintf(fid, ['%10s%s\n'],' ', ss);
	end
end
	fprintf(fid,'\n');
end

fclose(fid);