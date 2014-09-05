#!/usr/bin/perl -w

use Getopt::Std;
 
# declare the perl command line flags/options we want to allow
%options=();
getopts("hi:n:a", \%options);
 
if ($options{h}) {
    do_help();
}
 
 
sub do_help {
    print "Usage: perl Trim_phylip_alignment.pl options\n
            options: -i [string] is your input alignment in phylip format\n
                     -n [integer] number of sites to trim from N-terminal or 5' end\n
                     -h shows this help\n
                     -a automatically decides how to trim so you have complete ORFs";
    exit();
 }
 
 
 
if ($options{i} and ($options{n} or $options{a})) {
    
    #open file
    open(INPUT, "<$options{i}");
    
    #read first line of the file
    $header = <INPUT>;
    @parameters = split(/ /, $header);
    
    if($options{n}){
        $new_length = ($parameters[1]-$options{n});
        print "$parameters[0] $new_length I\n";

    }
    
    
    if($options{a}){
        $new_length = ($parameters[1]-($parameters[1] % 3));
        print "$parameters[0] $new_length I\n";

    }
    
    for(my $i = 0; $i < $parameters[0]; $i++){
        $line = <INPUT>;
        my @split_line = split(/    /, $line);
        

        if($options{n}){
            $trimmed_alignment = substr($split_line[1], 0, length($split_line[1])-$options{n});
            print "$split_line[0]    $trimmed_alignment\n";
        }
        
        if($options{a}){
            
            $trimmed_alignment = substr($split_line[1], 0, length($split_line[1])-($parameters[1] % 3));
            print "$split_line[0]    $trimmed_alignment\n";
        }
        
    }
    
    while ($line = <INPUT>){
        
        print "$line";
        
    }
    
    
    
}else{    
    do_help();
}
 
 