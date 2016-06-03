#!/usr/bin/env perl
# works for deb<->undeb + gets dependencies on init for control or .deb in ./
use warnings;
use strict;
use File::Copy;
use File::Find;
use Getopt::Std;
use Term::ANSIColor;

# makes debian binary package (.deb) without need of dpkg

# parse control file to get Package name used as final .deb filename
##todo parse all fields for additional features
##then use Version and Architecture in final string

# 
my  $switch = {};
getopts('i', $switch);

my $parse = sub {
	my $c = shift;	
    my $control = {};
	open( my $C, "<", "$c");
	while(<$C>){
		if(/\:/){
            s/(.*?)(:\ )(.*)/$1$3/;
            $control->{$1} = $3;
		}
	}
    if($c eq 'control'){
        my $file_name = $control->{Package} . '-' . $control->{Architecture} . '-' . $control->{Version};
        return $file_name;
    } else {
        return $control;
    }
};


##todo: quick draft, needs rewrite! 
my $unpack = sub {
    my $name = shift;
    system("perl -I /tmp/dropkg /tmp/dropkg/ar -x ./$name &>/dev/null");

    system("tar -xf control.tar.gz");
    system("tar -xf data.tar.gz");
    system("rm control.tar.gz debian-binary data.tar.gz");

    unless( $switch->{i} ){
        system("rm $name"); 
    } else {
        move( "$name", "$ENV{HOME}/.dropkg"); 
        move( "control", "$ENV{HOME}/.dropkg");
        system("cp -r * $ENV{HOME}");
    }
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
    
    ##todo: get rid of curl, use HTTP::Tiny (CORE since 5.13.9) fallback on curl/wget if (< 5.13.9)
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


my $url_base = 'https://api.metacpan.org/source';
my $control = 'control';
my $stash = '/tmp/dropkg';
my $tree = "perl -I $stash /tmp/dropkg/tree .";
my $dir = '.';


# get perl dependencies  on first run; tar & Filesys::Tree not necessary but tree is quite usefull for this stuff + it's not on iOS; geting tar makes it all pure-perl therefore might work on win.. 
my $init = sub {
    my $libs = [];
    
#quick draft, needs proper handling when using -i switch for custom install to keep track of installation paths etc; kind of what dpkg does with control files/.list 
    unless( -d "$ENV{HOME}/.dropkg" ){
        system("mkdir $ENV{HOME}/.dropkg");
    }

    #todo: URL should go to DATA and curl replaced with HTTP::Tiny
    unless( -d "$stash/Filesys" ){
        system("mkdir -p $stash/Filesys");
        print "\nUsing curl to get dependencies\n $stash <<<getopts.pl ";
        system("curl -#kL $url_base/ZEFRAM/Perl4-CoreLibs-0.003/lib/getopts.pl > $stash/getopts.pl");
        print " $stash <<<ar";
        system("curl -#kL $url_base/BDFOY/PerlPowerTools-1.007/bin/ar > $stash/ar");

        print " $stash <<<tree";
        system("curl -#kL $url_base/COG/Filesys-Tree-0.02/lib/Filesys/Tree.pm > $stash/Filesys/Tree.pm");
        system("curl -#kL $url_base/COG/Filesys-Tree-0.02/tree > $stash/tree");
        print " $stash <<<tar";
        system("curl -#kL $url_base/BDFOY/PerlPowerTools-1.007/bin/tar > $stash/tar");


        print "   tree|ar|tar>>>$stash/dropkg->" . colored(['green'],"ok") . "\n\n";

    }
    find( sub { push @$libs, $File::Find::name if (-f $_) }, $stash ); 
    return $libs;
};

my $mode = sub {
    my $path = shift;
    my( $status ) = ();
    my $libs = $init->();
    my $file = [];

    # if we see 'control' here (.) -> making package
    find( sub { if(/^control$/){
                my $deb = $ARGV[0] || $parse->($control);
                $status = $pack->($deb);
                print "\nstatus->" . colored(['green'],"ok") . "\n\n" unless $status;

    # if we see '*.deb' here (.) -> unpacking package
            } elsif (/\.deb$/){

    # unpack closure needs to check if we're installing or just unpacking, if there is -i switch from user -> doing custom install and data pack needs to be unpacked into $HOME (defaul) directory
                $status = $unpack->($_);

                # bookeeper; needs .storage (JSON, Dumper or Storable..?)
                if( $switch->{i} ){
                    my $tracker = $_ . '.control';
                    $status = move('./control', "$ENV{HOME}/.dropkg/$tracker");
                }
                print "\nstatus->" . colored(['green'],"ok") . "\n\n" unless $status;
            }}, $path);
    system("$tree");
};

#print 'init-> ';  for( @{$init->()} ){ print $_ . '   '}; print "\n\n";
#print 'mode-> ';  for( @{$mode->($dir)} ){ print $_ . '   '}; print "\n";

$mode->($dir);


__DATA__
Name,Version,Author,Architecture,Package,Section,Maintainer,Homepage,Description,Depends
rm -rf DEBIAN && mv control .control && tar czf ../data.tar.gz *;mkdir DEBIAN && cd DEBIAN && mv ../.control control && tar czf ../../control.tar.gz *;cd ../..; echo '2.0' > debian-binary && perl -I/tmp/dropkg /tmp/dropkg/ar r debian.deb debian-binary control.tar.gz data.tar.gz
perl /tmp/dropkg/ar -x *.deb
Name: XML-SAX   #name of whatever you are packaging  used in Cydia to search# ; Version: 0.99-1#nr before dash is tool versioon  nr after dash is your build number, increase it after each build#; Author: AuthorName; Architecture: iphoneos-arm; Package: libxml-sax-p5  #deb name will use this value in filename.deb  can be overiden on CLI -n <debname>#; Section: Perl; Maintainer: yourName (nickname) <your@email.com>; Homepage: https://some.website.com  #in Cydia shows up as as button pointing to some.website.com; Depiction: https://some.website.com #like Homepage but renders directly in Cydia package tab#; Depends: libxml-namespacesupport-p5, libxml-sax-base-p5, perl (= 5.14.4) #dependencies with optional version#; Description: Simple API for XML #short description of what you are packaging#;     This optional long description is one line after Description field prepended by whitespace  It will show up in Cydia package tab unless you add 'Depiction' field in which case Depiction value will be used instead
