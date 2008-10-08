use strict;
use warnings;
use File::Spec;
use Test::More tests => 13;
use POE;
use_ok('POE::Component::SmokeBox::Backend');

my @path = qw(COMPLETELY MADE UP PATH TO PERL);
unshift @path, 'C:' if $^O eq 'MSWin32';
my $perl = File::Spec->catfile( @path );

POE::Session->create(
   package_states => [
	'main' => [qw(_start _stop _results _timeout)],
   ],
);

$poe_kernel->run();
exit 0;

sub _start {
  my ($kernel,$heap) = @_[KERNEL,HEAP];
  $heap->{backend} = POE::Component::SmokeBox::Backend->check( 
	event => '_results', 
	perl => $perl, 
	debug => 0,
	env => { 'PERL_POE_SOMETHING_WACKY', 'moooooooooo!' },
  );
  isa_ok( $heap->{backend}, 'POE::Component::SmokeBox::Backend' );
  $kernel->delay( '_timeout', 60 );
  return;
}

sub _stop {
  pass("Hey the poco let go of our refcount");
  undef;
}

sub _results {
  my ($kernel,$heap,$result) = @_[KERNEL,HEAP,ARG0];
  ok( $result->{$_}, "Found '$_'" ) for qw(command PID start_time end_time log status);
  ok( ref $result->{log} eq 'ARRAY', 'The log entry is an arrayref' );
  ok( $result->{command} eq 'check', "We're checking!" );
  ok( defined $result->{env}->{PERL_POE_SOMETHING_WACKY}, 'Environment setting okay' );
  ok( !$ENV{PERL_POE_SOMETHING_WACKY}, 'No lingering ENV values' ) or diag($ENV{PERL_POE_SOMETHING_WACKY});
  $kernel->delay( '_timeout' );
  return;
}

sub _timeout {
  die "Something went seriously wrong\n";
  return;
}