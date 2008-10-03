use strict;
use warnings;
use File::Spec;
use Test::More tests => 104;
use_ok('POE::Component::SmokeBox');
use POE qw(Component::SmokeBox::Smoker Component::SmokeBox::Job);

my @smokers;
for ( 0 .. 4 ) {
    my @path = qw(COMPLETELY MADE UP PATH TO PERL);
    unshift @path, 'C:' if $^O eq 'MSWin32';
    my $perl = File::Spec->catfile( @path );
    my $smoker = POE::Component::SmokeBox::Smoker->new( perl => $perl );
    push @smokers, $smoker;
}
my $smokebox =  POE::Component::SmokeBox->spawn( smokers => \@smokers );
isa_ok( $smokebox, 'POE::Component::SmokeBox' );
ok( scalar $smokebox->queues() == 1, 'There is one jobqueue' );

POE::Session->create(
  package_states => [ 
    'main' => [qw(_start _stop _results _time_out)],
  ],
  options => { trace => 0 },
  heap => { smoker => shift @smokers },
);

$poe_kernel->run();
exit 0;

sub _start {
  for ( 0 .. 1 ) {
     my $job = POE::Component::SmokeBox::Job->new();
     $poe_kernel->post( $smokebox->session_id(), 'submit', job => $job, event => '_results', );
     $_[HEAP]->{_jobs}++;
  }
  $poe_kernel->delay( '_time_out', 30 );
  return;
}

sub _stop {
  pass('Poco let go of our reference');
  return;
}

sub _time_out {
  die;
}

sub _results {
  my ($kernel,$heap,$results) = @_[KERNEL,HEAP,ARG0];
  isa_ok( $results->{job}, 'POE::Component::SmokeBox::Job' );
  isa_ok( $results->{result}, 'POE::Component::SmokeBox::Result' );
  ok( $results->{submitted}, 'There was a value for submitted' );
  ok( scalar $results->{result}->results() == 5, 'There was only one result' );
  foreach my $res ( $results->{result}->results() ) {
     ok( ref $res eq 'HASH', 'The result is a hashref' );
     ok( $res->{$_}, "There is a '$_' entry" ) for qw(PID status start_time end_time perl log type command);
  }
  $smokebox->del_smoker( $_[HEAP]->{smoker} );
  ok( scalar $smokebox->queues() == 1, 'There is one jobqueue' );
  $heap->{_jobs}--;
  return if $heap->{_jobs};
  $kernel->delay( '_time_out' );
  $smokebox->shutdown();
  return;
}
