#!/usr/bin/env perl
#
use warnings;
use strict;
use File::Copy;
use Getopt::Std;

# makes debian binary package (.deb) without need of dpkg

# parse control file to get Package name used as final .deb filename
##todo parse all fields for additional features
##then use Version and Architecture in final string

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

my $unpack = sub {
    my $name = shift;
    $name = system("perl /tmp/dropkg/ar -x *.deb");
    system("rm -rf *.deb");
    system("tar -xf ./data.tar.gz"); 
    system("tar -xf ./control.tar.gz"); system("rm 'data.tar.gz' 'control.tar.gz' 'debian-binary'");
};

my $pack = sub {
    my $name = shift;
    my @shell =();

    while(<DATA>){
        push @shell, $_;
    }
    my $shell = \@shell;;

    unless( $name =~/\.deb/){
        $name .= '.deb';
    };
    
    # array ref to hold inline DATA at the tail
    
    # get perl archiver on first run
    ##todo: get rid of curl, use HTTP::Tiny (CORE since 5.13.9) fallback on curl/wget if (< 5.13.9)
    unless( -e '/tmp/dropkg/Perl4' ){
        system("mkdir -p /tmp/dropkg/Perl4");
        print "\nUsing curl to get dependencies\n /tmp/dropkg <<<getopts.pl ";
        system("curl -#kL https://api.metacpan.org/source/ZEFRAM/Perl4-CoreLibs-0.003/lib/getopts.pl > /tmp/dropkg/getopts.pl");
        print " /tmp/dropkg <<<ar";
        system("curl -#kL https://api.metacpan.org/source/BDFOY/PerlPowerTools-1.007/bin/ar > /tmp/dropkg/ar");
        print " /tmp/dropkg << CoreLibs.pm";
        system("curl -#kL https://api.metacpan.org/source/ZEFRAM/Perl4-CoreLibs-0.003/lib/Perl4/CoreLibs.pm > /tmp/dropkg/Perl4/CoreLibs.pm");
        print ">>>/tmp/dropkg->ok\n";
    }
    
    my $shoot = sub {
        my $packer = shift;
        my $p = system("$packer");
        system("rm -rf *");
        $p = move('../debian.deb', "$name");
        $p = unlink '../debian-binary', '../data.tar.gz', '../control.tar.gz', './DEBIAN/control'; 
        $p = rmdir('DEBIAN');
    };
    $shoot->($shell->[1]);
};


# die if no control file in ./


my $control = 'control';

unless(-f 'control' or defined $ARGV[0]){
    my $unpacked = $unpack->() and die;
} else {
    print "\n\tmissing control file" . "\n" and die unless(-f 'control');
    
    # get .deb filename from user or parse control file 
    ##todo: use Getopt::Std when time is right
    my $deb = $ARGV[0] || $parse->($control);

    # pack all stuff; using shell for now..eventually will use Archive::Tar
    my $d = $pack->($deb);
    print "status->$d \n" unless $d;
}


__DATA__
Name,Version,Author,Architecture,Package,Section,Maintainer,Homepage,Description,Depends
rm -rf DEBIAN && mv control .control && tar czf ../data.tar.gz *;mkdir DEBIAN && cd DEBIAN && mv ../.control control && tar czf ../../control.tar.gz *;cd ../..; echo '2.0' > debian-binary && perl -I/tmp/dropkg /tmp/dropkg/ar r debian.deb debian-binary control.tar.gz data.tar.gz
perl /tmp/dropkg/ar -x *.deb
Name: XML-SAX   #name of whatever you are packaging  used in Cydia to search# ; Version: 0.99-1#nr before dash is tool versioon  nr after dash is your build number, increase it after each build#; Author: AuthorName; Architecture: iphoneos-arm; Package: libxml-sax-p5  #deb name will use this value in filename.deb  can be overiden on CLI -n <debname>#; Section: Perl; Maintainer: yourName (nickname) <your@email.com>; Homepage: https://some.website.com  #in Cydia shows up as as button pointing to some.website.com; Depiction: https://some.website.com #like Homepage but renders directly in Cydia package tab#; Depends: libxml-namespacesupport-p5, libxml-sax-base-p5, perl (= 5.14.4) #dependencies with optional version#; Description: Simple API for XML #short description of what you are packaging#;     This optional long description is one line after Description field prepended by whitespace  It will show up in Cydia package tab unless you add 'Depiction' field in which case Depiction value will be used instead
