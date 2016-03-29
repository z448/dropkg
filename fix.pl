#!/usr/bin/env perl
use 5.010;
use File::Find;
use File::Copy;

# quick packer to make correct .deb packages;
# $find is needed, otherwise dpkg will complain during install, even if installation will be started

my $packlist = '.packlist';

my $pack = sub {
    my $shell = <<"_PACK";
        cd DEBIAN/;
        tar czf ../../control.tar.gz *;
        cd ../..;
        echo 2.0 > debian-binary;
        perl /tmp/dropkg/ar r debian.deb debian-binary control.tar.gz data.tar.gz;
_PACK
    my $shot = system("$shell");
    return $shot;
};

my $find = sub {
    my $path = shift;
    my @filtered = ();
    unless(-f 'control'){
        print "need control\n" and die;
    } else {
        system("mkdir DEBIAN");
        move('control', 'DEBIAN');
    }

    find( sub { if( -f $_ ){ push @filtered, $File::Find::name }}, $path );
    open( my $ph, ">", $packlist );

    for (@filtered){
        unless(/DEBIAN/ or /\.packlist/){
            if(-f $_){
                say $_;
                say $ph $_;
            }
        } else { next }
    }
    close $ph;

    my $tar = system("tar cz -T $packlist -f ../data.tar.gz");
    $tar  = $pack->($ARGV[1]);
};

sub start {
    my $path = shift;
    my $s = $find->($path);
    $s = move('../debian.deb', '.');
    print "ok\n" unless $s;
}


start($ARGV[0]);



