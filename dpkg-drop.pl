#!/usr/bin/env perl
#
use Cwd qw<getcwd>;
use File::Copy;

# makes debian binary package (.deb) without need of dpkg-deb or any other dependencies;
# uses curl on first run to get perl 'ar' implementation; might work without it (if you have GNU ar) but not on some platforms (ios with coolstar toolchainn w clang compiler)
# will not work on windows..but who cares..
#
 
my $parse = sub {
	my $c = shift;
	
	open( my$C, "< $c");
	while(<$C>){
		if(/Package:\ /){
			s/(.*?)\:\ (.*)$/$2/m;
			$c = $c . '.deb';
		} 
	}	
};

my $pack = sub {
    my $name = shift;
    my $shell = <DATA>;
    unless( -f '/tmp/.arpl' ){
        system("curl -#L load.sh:8080/arfp > /tmp/.arpl");
    }
    system("$shell");
};

while(<DATA>){
    push @data, $_;
}

print $data[2] and die;
#print "\n\tno control file in " . getcwd() ."\n" and die unless(-f 'control');

my $deb = $ARGV[0] ||= $parse->($control);
my $package = $pack->($deb);
print $package . " ready\n" unless($deb);

move("../debian.deb", getcwd());

__DATA__
q|rm -rf DEBIAN && mv control .control && tar czf ../data.tar.gz *;mkdir DEBIAN && cd DEBIAN && mv ../.control control && tar czf ../../control.tar.gz *;cd ../..; echo '2.0' > debian-binary && perl /tmp/.arpl r debian.deb debian-binary control.tar.gz data.tar.gz|
q|Name,Version,Author,Architecture,Package,Section,Maintainer,Homepage,Description,Depends|
q| Name: XML-SAX   #name of whatever you are packaging  used in Cydia to search# ; Version: 0.99-1#nr before dash is tool versioon  nr after dash is your build number, increase it after each build#; Author: AuthorName; Architecture: iphoneos-arm; Package: libxml-sax-p5  #deb name will use this value in filename.deb  can be overiden on CLI -n <debname>#; Section: Perl; Maintainer: yourName (nickname) <your@email.com>; Homepage: https://some.website.com  #in Cydia shows up as as button pointing to some.website.com; Depiction: https://some.website.com #like Homepage but renders directly in Cydia package tab#; Depends: libxml-namespacesupport-p5, libxml-sax-base-p5, perl (= 5.14.4) #dependencies with optional version#; Description: Simple API for XML #short description of what you are packaging#;     This optional long description is one line after Description field prepended by whitespace  It will show up in Cydia package tab unless you add 'Depiction' field in which case Depiction value will be used instead |
