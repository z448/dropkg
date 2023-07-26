use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'App::dropkg',
    VERSION_FROM      => 'dropkg', # finds $VERSION, requires EU::MM from perl >= 5.5
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ABSTRACT_FROM     => 'dropkg', # retrieve abstract from module
    AUTHOR            => q{Zdeněk Bohuněk <zdenek@cpan.org>},
    LICENSE           => 'artistic_2',
    'EXE_FILES'	      => ['dropkg'],
    MIN_PERL_VERSION  => 5.010,
    CONFIGURE_REQUIRES => {
	    'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
	    'Test::More' => 0,
    },
    dist => { COMPRESS => 'gzip -9f', SUFFIX => 'gz' },
);
