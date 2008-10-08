use strict;
use warnings;
use File::Spec;
use Test::More tests => 71;
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

my $smokebox =  POE::Component::SmokeBox->spawn( smokers => \@smokers, multiplicity => 1 );
isa_ok( $smokebox, 'POE::Component::SmokeBox' );
ok( $smokebox->multiplicity(), 'Multiplicity is on' );
ok( scalar $smokebox->queues() == 5, 'There are five jobqueues' );

POE::Session->create(
  package_states => [ 
    'main' => [qw(_start _stop _results)],
  ],
  options => { trace => 0 },
  heap => { smoker => shift @smokers, },
);

$poe_kernel->run();
exit 0;

sub _start {
  my $job = POE::Component::SmokeBox::Job->new();
  $poe_kernel->post( $smokebox->session_id(), 'submit', job => $job, event => '_results', );
  return;
}

sub _stop {
  pass('Poco let go of our reference');
  return;
}

sub _results {
  my ($kernel,$results) = @_[KERNEL,ARG0];
  isa_ok( $results->{job}, 'POE::Component::SmokeBox::Job' );
  isa_ok( $results->{result}, 'POE::Component::SmokeBox::Result' );
  ok( $results->{submitted}, 'There was a value for submitted' );
  ok( scalar $results->{result}->results() == 1, 'There was only one result' );
  foreach my $res ( $results->{result}->results() ) {
     ok( ref $res eq 'HASH', 'The result is a hashref' );
     ok( $res->{$_}, "There is a '$_' entry" ) for qw(PID status start_time end_time perl log type command);
  }
  if ( $_[HEAP]->{smoker} ) {
     $smokebox->del_smoker( delete $_[HEAP]->{smoker} );
     ok( scalar $smokebox->queues() == 4, 'There are four jobqueues' );
  }
  $smokebox->shutdown();
  return;
}