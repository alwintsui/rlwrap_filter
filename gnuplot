#!/usr/bin/env perl
#Shun Xu <alwintsui@gmail.com>, Dec. 12, 2014.

use lib ($ENV{RLWRAP_FILTERDIR} or ".");
use RlwrapFilter;
use strict;

my @gb_words=("cd","clear","EOF","exit","fit","load","pause","plot","print","pwd","quit","replot","save","set","shell","show","splot","unset",
"abs","acos","arg","asin","atan","besj0","besj1","besy0","besy1","ceil","cos","cosh","erf","erfc","exp","floor","gamma",
"ibeta","igamma","imag","int","inverf","invnorm","lgamma","log","log10","norm","rand","real","sgn","sin","sinh","sqrt","tan","tanh");
#+@fc_words

my @set_words=("angles","arrow","autoscale","bars","bmargin","border","boxwidth","cbdata","cbdtics","cblabel","cbmtics","cbrange","cbtics",
"clabel","clip","cntrparam","colorbox","contour","data","datafile","date_specifiers","decimalsign","dgrid3d","dummy","encoding","fit",
"fontpath","format","function","grid","hidden3d","historysize","isosamples","key","label","linetype","lmargin","loadpath","locale","log",
"logscale","macros","mapping","margin","missing","mouse","multiplot","mx2tics","mxtics","my2tics","mytics","mztics","object","offsets",
"origin","output","palette","parametric","pm3d","pointintervalbox","pointsize","polar","print","psdir","rmargin","rrange","rtics","samples",
"size","style","surface","table","term","terminal","termoption","tics","ticscale","ticslevel","timefmt","time_specifiers","timestamp","title",
"tmargin","trange","urange","view","vrange","x2data","x2dtics","x2label","x2mtics","x2range","x2tics","x2zeroaxis","xdata","xdtics",
"xlabel","xmtics","xrange","xtics","xyplane","xzeroaxis","y2data","y2dtics","y2label","y2mtics","y2range","y2tics","y2zeroaxis","ydata",
"ydtics","ylabel","ymtics","yrange","ytics","yzeroaxis","zdata","zdtics","zero","zeroaxis","zlabel","zmtics","zrange","ztics","zzeroaxis");

my @set_styles=("arrow","boxplot","circle","data","ellipse","fill","function","increment","line","rectangle");
#same as @unset_styles,show_styles

my @unset_words=("arrow","autoscale","border","cbdtics","cbmtics","cbtics","clabel","clip","colorbox","contour","decimalsign","dgrid3d","grid",
"hidden3d","historysize","key","label","linetype","logscale","mouse","multiplot","mx2tics","mxtics","my2tics","mytics","mztics","offsets",
"parametric","polar","style","surface","terminal","tics","timestamp","x2dtics","x2mtics","x2tics","x2zeroaxis","xdtics","xmtics","xtics",
"xzeroaxis","y2dtics","y2mtics","y2tics","y2zeroaxis","ydtics","ymtics","ytics","yzeroaxis","zdtics","zeroaxis","zmtics","ztics","zzeroaxis");

my @show_words=("all","angles","arrow","autoscale","bars","bind","border","boxwidth","cbdata","cbdtics","cblabel","cbmtics","cbrange","cbtics",
"clabel","clip","cntrparam","colorbox","colornames","contour","datafile","decimalsign","dgrid3d","dummy","encoding","fit","fontpath","format",
"functions","grid","hidden3d","isosamples","key","label","linetype","loadpath","logscale","macros","mapping","margin","mx2tics","mxtics","my2tics",
"mytics","mztics","object","offsets","origin","output","palette","parametric","plot","pm3d","pointsize","polar","print","psdir","rrange","rtics",
"samples","size","style","surface","term","terminal","tics","ticscale","ticslevel","timefmt","timestamp","title","trange","urange","variables",
"version","view","vrange","x2data","x2dtics","x2label","x2mtics","x2range","x2tics","x2zeroaxis","xdata","xdtics","xlabel","xmtics","xrange","xtics",
"xyplane","xzeroaxis","y2data","y2dtics","y2label","y2mtics","y2range","y2tics","y2zeroaxis","ydata","ydtics","ylabel","ymtics","yrange","ytics",
"yzeroaxis","zdata","zdtics","zero","zeroaxis","zlabel","zmtics","zrange","ztics","zzeroaxis");

my $filter = new RlwrapFilter;
my $name = $filter -> name;

$filter -> help_text("Usage: rlwrap -a -A -z $name -c -pBlue gnuplot'\n".
                     "filter gnuplot, DONOT use -f include completion file");
$filter -> completion_handler(\&complete_set);
$filter -> run;

sub complete_set {
	my($line, $prefix, @completions) = @_;
        if ($line =~ /^\s*(unset|set|show)\s+style\s+(\w*)$/) {
		my $t=$1;
        	my $k=$2;
		my @expan_words=();
		my @my_words=@set_styles;
		foreach my $w (@my_words) {
			if ($k eq "" || $w =~ /^$k\w*/) {
				push @expan_words,$w;
			}
		}
		return @expan_words;
	}elsif ($line =~ /^\s*(unset|set|show)\s+(\w*)$/) {
		my $t=$1;
        	my $k=$2;
		my @expan_words=();
		my @my_words;
		if ($t eq "set"){ @my_words=@set_words;
		}elsif ($t eq "unset"){ @my_words=@unset_words;
		}else{ @my_words=@show_words
		}
		foreach my $w (@my_words) {
			if ($k eq "" || $w =~ /^$k\w*/) {
				push @expan_words,$w;
			}
		}
                #print STDERR "<@expan_words> <$line> <$k>\n";
		return @expan_words;
	}elsif ( $prefix =~ /(\w*)/) {
		my $k=$1;
		my @expan_words=();
		my @my_words=@gb_words;
                foreach my $w (@my_words) {
                        if ($w =~ /^$k\w*/) {
                                push @expan_words,$w;
                        }
                }
                unshift @completions, @expan_words if @expan_words;
        	return @completions;

        }else{
        	return @completions;
	}
}

