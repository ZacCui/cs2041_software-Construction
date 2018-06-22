#!/usr/bin/perl -w

use strict;

my @list = ();
my @indent = ();
my %dic = ();
my @read = ();
$dic{ARGV} = "\@";

while (my $line = <>) {
    #translate the header
    $line = "#!/usr/bin/perl -w\n" if ($line =~ /^#!/ && $. == 1);

    #ignore import
    next if($line =~ /^import/);

    # Blank & comment lines can be passed unchanged
    if($line =~ /^\s*(#|$)/ ) {
        push @list, $line; next; 
    }
    
    #translate break and continue, wirte , argv and read
    $line =~ s/break$/last/g;
    $line =~ s/continue$/next/g;
    $line =~ s/(.*)sys.stdout.write\((.*)\)(.*)/$1print\($2,end=''\)$3/g;
    $line =~ s/sys.argv/ARGV/g;
    $line =~ s/ARGV\[\s*(\w+)\s*(:?)/ARGV\[$1-1$2/g;
    $line =~ s/(ARGV\[.*?:\s*)(\w+)/$1$2-1/g;

    #handle [.*:.*]
    if($line =~ /(\w+)\[(.*?):(.*?)\]/){
        my $name = $1; 
        my $first = $2;
        my $second = $3;
        $first =~ s/\s//g if($first);
        $second =~ s/\s//g if($second);
        $first = 0 if(!$first);
        if($name && !$second){
            $second = "\$\#$name" 
        }else{
            $second =~ s/(\w+)$/$1-1/g; 
        }
        $line =~ s/\[.*?:.*?\]/\[$first\.\.$second\]/g;
    }

    #handle len()
    if($line =~ /len\((.*)\)/){
        if(!@read){
            $line =~ s/(.*)len\(\s*(\"?\w+\"?)\s*\)(.*)/$1length\($2\)$3/g;
            my $temp = $2;
            if($temp && $temp !~ /\"/){
                my $type = "\$";
                $temp =~ s/\"//g;
                $type = $dic{$temp} if(exists $dic{$temp});
                $line =~ s/(length\(\s*)(\w+)(\s*\))/$1$type$2$3/g;
                $line =~ s/length/scalar/g if($type eq "\@");
            }
        }else{
            $line =~ s/\s*=\s*len\((.*)\)/$1/g;
            $line =~ s/^(\s*\w+)/$1 += 1/g;
        }
    }

    if(@read && $line =~ /$read[-1]/){
        $line =~ s/^(.*)/   $1/g;
        $line =~ s/$read[-1]//g;
        pop @read;
    }

    #handle readlines()
    if($line =~ /in\s*sys.stdin.readlines\(\s*\)(.*)/){
        $line =~ s/sys.stdin.readlines\(\s*\)/<STDIN>/g;
    }
    if($line =~ /(.*)sys.stdin.readlines\(\s*\)(.*)/){
        $line =~ s/\s*(\w+)\s*=\s*sys.stdin.readlines\(\s*\)(.*)/while <STDIN>:/g;
        push @read, $1 if($1);
    }

    #idenity var type
    #list
    if($line =~ /\s*(\w+)\s*=\s*\[\]\s*/){
        $dic{$1} = "\@" if($1);
        $line =~ s/\s*\w+\s*=\s*\[\]\s*//g;
    }
    if($line =~ /\s*(\w+)\s*=\s*\[(.*),(.*)\]\s*/){
        $dic{$1} = "\@" if($1);
        $line =~ s/(\s*)(\w+)(\s*=\s*)\[(.*)\](\s*)/$1\@$2$3\($4\)$5/g;
    }
    if($line =~ /\s*(\w+)\s*=\s*range\(.*\)/){
        $dic{$1} = "\@" if($1);
        $line =~ s/(\s*)(\w+)(\s*=\s*)/$1\@$2$3/g;
    }
    #hash
    if($line =~ /\s*(\w+)\s*=\s*\{\}\s*/){
        $dic{$1} = "\%" if($1);
        $line =~ s/\s*\w+\s*=\s*\{\}\s*//g;
    }
    if($line =~ /(\w+)\[.*\]\s*/){
        if($1 and exists $dic{$1} and $dic{$1} eq "\%"){
            $line =~ s/(\w+)\[(.*)\](\s*)/\$$1\{$2\}$3/g;
        }else{
            $line =~ s/(\w+\[.*\])(\s*)/\$$1$2/g;
        }
    }
    if($line =~ /\s*sorted\(\s*(\w+)\s*\)/){
        if($1 and exists $dic{$1} and $dic{$1} eq "\@"){
            $line =~ s/sorted\(\s*(\w+)\s*\)/sort $1/g;
        }elsif($1 and $dic{$1} eq "\%"){
            $line =~ s/sorted\(\s*(\w+)\s*\)/sort keys $1/g;
        }else{

        }
    }
   
    #handle append
    if( $line =~ /(\s*)(\w+)\.append\(\s*(\w+)\s*\)/){
        my $type = "\$";
        $type = $dic{$3} if(exists $dic{$3});
        $line =~ s/(\s*)(\w+)\.append\(\s*(\w+)\s*\)/$1push \@$2, $type$3/g;
        $dic{$2} = "\@" if(! exists $dic{$2});
    }

    #handle pop
    if( $line =~ /(\s*)(\w+)\.pop\(\s*\)/){
        $line =~ s/(\s*)(\w+)\.pop\(\s*\)/$1pop \@$2/g;
    }

    #handle range() for 1,2 args
    if($line =~ /(.*)range\((.*)\)(.*)/ ){
        my $temp = $2;
        my $beg = 0;
        my $end = 0;
        my $add = 0;
        if($temp =~ /,/){
            $temp =~ /(.*?),(.*)/ or die;
            $beg = $1;
            $end = $2 ;
        }else{
            $temp =~ /(.*)/;
            $end = $1;
        }
        $add = 1 if($end =~ /ARGV[^\[]/);
        $line =~ s/(.*)range\(.*\)(.*)/$1\($beg..$end-1+$add\)$2/g;
    }

    # tranlate : to {} by using stack
    if(@indent){
        $line =~ /(\s*)\w+/;
        while(@indent && $1 le $indent[$#indent]){
            $line =~ /^(\s*)(.*)/;
            push @list, "$indent[$#indent]}\n";
            pop @indent;
        }
    }
    if($line =~ /(\s*)(while|for|if|else|elif).*?:/){
        my $ind = "";
        $ind = $1 if($1);
        $line =~ s/(\s*)for\s*(\w+)\s*in\s*fileinput.input\(\)/$1while $2 = <>/g;
        $line =~ s/elif/elsif/g;
        $line =~ s/for/foreach/g;
        push @indent,$ind;
        chomp $line;
        $line =~ s/\s+not\s+/!/g;
        if($line =~ /(\w+\s*)([a-z_0-9]+)(\s*:.*)/i){
            my $type = "\$";
            $type = $dic{$2} if(exists $dic{$2});
            $line =~ s/(\w+\s*)([a-z_0-9]+)(\s*:.*)/$1$type$2$3/gi if($line !~ /else/);
        }
        $line =~ s/(\s*else)(.*?):(.*)/$1$2\{\n/g;
        $line =~ s/(\s*while|foreach|if|elsif)(.*?):(.*)/$1\($2\){\n/g if($line !~ /else/);
        my $temp = $3;
        $line =~ s/(.*{\n)/$1    $ind$temp\n/g if($temp);
        if($line =~ /(\s*foreach\s*)\(\s*(\w+)\s*in\s*(.*)\)(.*)/){
            $line =~ s/(\s*foreach\s*)\(\s*(\w+)\s*in\s*(.*)\)(.*)/$1 \$$2 \($3\)$4/g;
        }
    }

    #translate the partten x () y to $x () $y
    if($line !~ /^\s*print\(/ and $line !~ /re\./){
        varConvert(\$line);
    }

    #handle join,split
    if($line =~ /(\w+|'.*?'|".*?")\.join\((.*?)\)/){
        if($1 and $1 =~ /["']/){
            $line =~ s/(\w+|'.*?'|".*?")\.join\((.*?)\)/join($1 , $2)/g;
        }else{
            $line =~ s/(\w+|'.*?'|".*?")\.join\((.*?)\)/join(\$$1 , $2)/g;
        }
    }
    if($line =~ /(\w+|'.*?'|".*?")\.split\((.*?)\)/){
        if($1 and $1 =~ /["']/){
            $line =~ s/(\w+|'.*?'|".*?")\.split\((.*?)\)/split(\/$2\/ , $1)/g;
        }else{
            $line =~ s/(\w+|'.*?'|".*?")\.split\((.*?)\)/split(\/$2\/ , \$$1)/g;
        }
    }   

    #handle re
    #print $line if ($line =~ /re.sub/);
    $line =~ s/(\s*)\$?\w+\s*=\s*\$?re.sub\(\s*r?\'(.*?)\'\s*,\s*\'(.*?)\',\s*\$?(\w+)\s*\)/$1\$$4 =~ s\/$2\/$3\/g/g;
    $line =~ s/(\s*)\$?\w+\s*=\s*\$?re.(match|search)\(\s*r?\'(.*?)\'\s*,\s*\$?(\w+)\s*\)/$1\$$4 =~ \/$3\//g;

    #translate int() and sys.stdin.readline
    $line =~ s/(.*)[^r]int\((.*)\)(.*)/$1$2$3/g;
    $line =~ s/(.*)sys.stdin.readline\(\)(.*)/$1<STDIN>$2/g;
    $line =~ s/(\$?\w+\s*)\/\/(\s*\$?\w+)/int\($1\/$2\)/g;
    $line =~ s/(.*)sys.stdi\$n(.*)/$1<STDIN>$2/g;


    # Python's print outputs a new-line character by default
    # so we need to add it explicitly to the Perl print statement
    if ($line =~ /\s*print\((.*)\)/){
        chomp $line;
        my $end = "\\n"; 
        my $temp = $1 if(defined $1);
        #non-printf case
        if($temp !~ /\"\s*% /){
            my @a = printTranslate(\$temp,\$end);
            $temp = join '," ",',@a;
            $line =~ s/(\s*print)\((.*)\)/$1 $temp, \"$end\"\n/g;
            $line =~ s/print , \"\\n\"/print "\\n"/g;
        }else{
            $line =~ /\((\".*?\")\s*%(.*)\)/;
            my $first = $1;
            my $second = $2;
            my @a = printTranslate(\$second,\$end);
            foreach my $word (@a){
                $second =~ s/\w+/$word/;
            }
            $first =~ s/\"$/$end\"/g;
            $line =~ /(^\s*)/;
            $line = "$1printf $first, $second\n";
        }
    }

    #add ; at the back
    if($line =~ /[\)|=]|print|\w+/ and $line !~ /{\s*\n$/){
        $line =~ s/\n$/\;\n/g;
    }

    #in case the mutiple : at end
    #wrong translation handle
    $line =~ s/;;\n$/\;\n/g;
    $line =~ s/(join|split)(\(.*?),\" \"(.*?\))/$1$2$3/g;
    $line =~ s/\@[\@\$]/\@/g;
    $line =~ s/\$\$/\$/g;
    $line =~ s/%\s*%/%/g;
    $line =~ s/\$(keys|sort)/$1/g;
    $line =~ s/[\$\@\%](\w+\()/$1/g;
    $line =~ s/(\[)(.*?)(\@|\%)(.*?)(\])/$1$2$4$5/g;
    $line =~ s/[\@\%\$ ]*(\w+\[.*\])/ \$$1/g;
    $line =~ s/(\w+[\[\{]\s*)[\$\@\% ]*(w+\s*\])/$1\$$2/gi;
    $line =~ s/([\[\{])(\w+)/$1\$$2/g if($line !~ /=~\s*s?\/.*\//);
    $line =~ s/\$(\w+\[.*\.\.)/\@$1/g;   
    $line =~ s/[\$\@](\d+)/$1/g;
    push @list,$line;
}
if(@indent){
    push @list, "}\n";
}
print @list;


sub varConvert{
    my ($ref) = @_;
    my $type = "\$";
    $$ref =~ /(\s*)(\w+)\s*([\+\-\*!~<>=\/%\|\&\^]{1,2})/;
    $type = $dic{$2} if($2 && exists $dic{$2});
    $$ref =~ s/(\s*)(\w+)\s*([\+\-\*!~<>=\/%\|\&\^]{1,2})/$1$type$2 $3/g;
    $type = "\$";
    $$ref =~ /([\+\-\*!~<>=\/%\|\&\^]{1,2})\s*(\w+)/;
    $type = $dic{$2} if($2 && exists $dic{$2});
    $$ref =~ s/([\+\-\*!~<>=\/%\|\&\^]{1,2})\s*(\w+)/$1 $type$2/g;
    $$ref =~ s/\$(\w+\(.*\))/$1/g;
    $$ref =~ s/\$?<\$?STDIN\s*>/<STDIN>/g;
    $$ref =~ s/\$?([\@\%])\$?/$1/g;
}

sub printTranslate{
    my($temp,$end) = @_;
    my @a = split /,/,$$temp;
    foreach my $word (@a){
        if($word !~ /[\"\+\-\*\/<>=~!\d]/){
            my $type = "\$";
            $word =~ /\s*(\w+)/;
            $type = $dic{$1} if(exists $dic{$1});
            $word =~ s/\s*(\w+)/$type$1/g;
        }elsif($word =~ /end\s*=\s*/){
            $word =~ s/end\s*=\s*[\"\'](.*)[\"\']/$1/g;
            $word =~ s/^ //;
            $$end = $word;
            pop @a;
        }elsif($word =~ /[\+\-\*\/<>=~!]/ and $word !~ /\"/){
            varConvert(\$word);
        }
    }
    return @a;
}


