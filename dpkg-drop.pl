#!/usr/bin/env perl
#
use warnings;
use strict;
use File::Copy;

# makes debian binary package (.deb) without need of dpkg

# parse control file to get Package name used as final .deb filename

my $parse = sub {
	my $c = shift;	
	open( my $C, "<", "$c");
	while(<$C>){
        my( $pkg_name )= ();
		if(/Package:\ /){
			s/(.*?\:\ )(.*)$/$2/m;
            $pkg_name = $2;
            return $pkg_name;
		}
	}	
};

my $pack = sub {
    my $name = shift;
    unless( $name =~/\.deb/){
        $name .= '.deb';
    };
    
    # array ref to hold inline DATA at the tail
    my $shell = [];

    while(<DATA>){
        push $shell, $_;
    }
    unless( -e '/tmp/.arpl' ){
        system("curl -#kL https://api.metacpan.org/source/BDFOY/PerlPowerTools-1.007/bin/ar > /tmp/.arpl");
        print "\nUsing curl to get archiver\n";
    }
    
    my $shoot = sub {
        my $packer = shift;
        my $status = system("$packer");
        move('../debian.deb', "$name");
    };
    my $s = $shoot->($shell->[1]);
    return $s;
};


# die if no control file in ./

my $control = 'control';
print "\n\tmissing control file" . "\n" and die unless(-f 'control');

my $deb = $ARGV[0] || $parse->($control);
my $package = $pack->($deb);
print $package . " ready\n" if ($package);

__DATA__
Name,Version,Author,Architecture,Package,Section,Maintainer,Homepage,Description,Depends
rm -rf DEBIAN && mv control .control && tar czf ../data.tar.gz *;mkdir DEBIAN && cd DEBIAN && mv ../.control control && tar czf ../../control.tar.gz *;cd ../..; echo '2.0' > debian-binary && perl /tmp/.arpl r debian.deb debian-binary control.tar.gz data.tar.gz
Name: XML-SAX   #name of whatever you are packaging  used in Cydia to search# ; Version: 0.99-1#nr before dash is tool versioon  nr after dash is your build number, increase it after each build#; Author: AuthorName; Architecture: iphoneos-arm; Package: libxml-sax-p5  #deb name will use this value in filename.deb  can be overiden on CLI -n <debname>#; Section: Perl; Maintainer: yourName (nickname) <your@email.com>; Homepage: https://some.website.com  #in Cydia shows up as as button pointing to some.website.com; Depiction: https://some.website.com #like Homepage but renders directly in Cydia package tab#; Depends: libxml-namespacesupport-p5, libxml-sax-base-p5, perl (= 5.14.4) #dependencies with optional version#; Description: Simple API for XML #short description of what you are packaging#;     This optional long description is one line after Description field prepended by whitespace  It will show up in Cydia package tab unless you add 'Depiction' field in which case Depiction value will be used instead
