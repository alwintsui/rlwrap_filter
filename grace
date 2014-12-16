#!/usr/bin/env perl
#Shun Xu <alwintsui@gmail.com>, Dec. 12, 2014.

use lib ($ENV{RLWRAP_FILTERDIR} or ".");
use RlwrapFilter;
use strict;

my @top_words=("arrange","autoscale","autoticks","background","block","clear","copy","date","default","define","device","exit","focus","hardcopy",
"help","histogram","interpolate","kill","linconv","link","load","map","move","page","print","redraw","reference","restrict","runave","runmax",
"runmed","runmin","runstd","saveall","sleep","stack","swap","timestamp","type","updateall","version","with","write","xcor","znorm",
"view","world","xaxis","yaxis","altxaxis","altyaxis","subtitle","title","xaxes","yaxes","read","legend","frame");

my @fn_words=("abs","acos","acosh","ai","asin","asinh","atan","atan2","atanh","avg","beta","bi","ceil","chdtr","chdtrc","chdtri","chi","ci","cos","cosh",
"dawsn","ellie","ellik","ellpe","ellpk","erf","erfc","exp","expn","fac","fdtr","fdtrc","fdtri","floor","fresnlc","fresnls","gamma","gdtr","gdtrc","hyp2f1",
"hyperg","i0e","i1e","igam","igamc","igami","imax","imin","incbet","incbi","int","irand","iv","jv","k0e","k1e","kn","lbeta","lgamma","ln","log10",
"log2","max","maxof","mesh","min","minof","mod","ndtr","ndtri","norm","pdtr","pdtrc","pdtri","pi","psi","rand","rgamma","rint","rnorm","rsum",
"sd","sgn","shi","si","sin","sinh","spence","sqr","sqrt","stdtr","stdtri","struve","sum","tan","tanh","voigt","yv","zeta","zetac");

my @world_view_words=("xmin","xmax","ymin","ymax");
my @g_num_words=("bar","fixedpoint","hidden","on","off","stacked","type");
my @s_num_words=("avalue","baseline","comment","dropline","errorbar","fill","hidden","legend","line","link","symbol","type");
my @r_num_words=("color","line","linestyle","linewidth","off","on","type");
my @x_yaxis_words=("bar","label","offset","on","off","tick","ticklabel","type");
my @altx_yaxis_words=("on","off");
my @x_yaxes_words=("scale","invert");
my @sub_title_words=("font","size","color");
my @read_words=("xy","nxy","block");
my @legend_words=("box","char","color","font","hgap","invert","length","loctype","on","off","vgap");
my @legend_box_words=("color","fill","linestyle","linewidth","on","off","pattern");
my @frame_words=("background","color","linestyle","linewidth","pattern","type");

my $filter = new RlwrapFilter;
my $name = $filter -> name;

$filter -> help_text("Usage: rlwrap -a -A -z $name -c -pBlue grace'\n".
                     "filter grace, DONOT use -f include completion file");
$filter -> completion_handler(\&complete_set);
$filter -> run;

sub complete_set {
        my($line, $prefix, @completions) = @_;
        if ($line =~ /^\s*legend\s+box\s+(\w*)$/i) {
                my $k=$1;
                my @expan_words=();
                foreach my $w (@legend_box_words) {
                        if ($k eq "" || $w =~ /^$k\w*/i) {
                                push @expan_words,$w;
                        }
                }
                return @expan_words;
        }elsif ($line =~ /^\s*(view|world|xaxis|yaxis|altxaxis|altyaxis|subtitle|title|xaxes|yaxes|read|legend|frame)\s+(\w*)$/i) {
                my $t=lc($1);
                my $k=$2;
                my @expan_words=();
                my @my_words;
                if ($t eq "view" || $t eq "world"){ @my_words=@world_view_words;
                }elsif ($t eq "xaxis" || $t eq "yaxis"){ @my_words=@x_yaxis_words;
                }elsif ($t eq "altxaxis" || $t eq "altyaxis"){ @my_words=@altx_yaxis_words;
                }elsif ($t eq "xaxes" || $t eq "yaxes"){ @my_words=@x_yaxes_words;
                }elsif ($t eq "subtitle" || $t eq "title"){ @my_words=@sub_title_words;
                }elsif ($t eq "read"){ @my_words=@read_words;
                }elsif ($t eq "legend"){ @my_words=@legend_words;
                }else{ @my_words=@frame_words
                }
                foreach my $w (@my_words) {
                        if ($k eq "" || $w =~ /^$k\w*/i) {
                                push @expan_words,$w;
                        }
                }
                #print STDERR "<@expan_words> <$line> <$k>\n";
                return @expan_words;
        }elsif ($line =~ /^\s*(r|g|s)\d+\s+(\w*)$/i) {
                my $t=lc($1);
                my $k=$2;
                my @expan_words=();
                my @my_words;
                if ($t eq "r" ){ @my_words=@r_num_words;
                }elsif ($t eq "g"){ @my_words=@g_num_words;
                }elsif ($t eq "s"){ @my_words=@s_num_words;
		}
                foreach my $w (@my_words) {
                        if ($k eq "" || $w =~ /^$k\w*/i) {
                                push @expan_words,$w;
                        }
                }
                return @expan_words;
        }elsif ($line =~ /^\s*(\w+)$/i) {
                my $k=$1;
                my @expan_words=();
                foreach my $w (@top_words) {
                        if ($k eq "" || $w =~ /^$k\w*/i) {
                                push @expan_words,$w;
                        }
                }
                unshift @completions, @expan_words if @expan_words;
                return @completions;
        }elsif ( $prefix =~ /(\w*)/i) {
                my $k=$1;
                my @expan_words=();
		if ($k eq "") {
	                unshift @completions, @top_words;
                } else {
			foreach my $w (@fn_words) {
                        	if ($w =~ /^$k\w*/i) {
                                push @expan_words,$w;
                        	}
                	}
              		unshift @completions, @expan_words if @expan_words;
		}
                return @completions;

        }else{
                return @completions;
        }
}

