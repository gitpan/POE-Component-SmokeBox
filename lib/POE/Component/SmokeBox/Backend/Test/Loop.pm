package POE::Component::SmokeBox::Backend::Test::Loop;

use strict;
use warnings;
use base qw(POE::Component::SmokeBox::Backend::Base);
use vars qw($VERSION);

$VERSION = '0.48';

sub _data {
  my $self = shift;
  $self->{_data} =
  {
	check => [ '-e', 1 ],
	index => [ '-e', 1 ],
	smoke => [ '-e', '$|=1; my $module = shift; while (1) { print $module, qq{\n}; }' ],
  };
  return;
}

1;
__END__

=head1 NAME

POE::Component::SmokeBox::Backend::Test::Loop - a backend to test looping output kills.

=head1 DESCRIPTION

POE::Component::SmokeBox::Backend::Test::Loop is a L<POE::Component::SmokeBox::Backend> plugin used during the
L<POE::Component::SmokeBox> tests.

It contains no moving parts.

=head1 AUTHOR

Chris C<BinGOs> Williams

=head1 LICENSE

Copyright C<(c)> Chris Williams.

This module may be used, modified, and distributed under the same terms as Perl itself. Please see the license that came with your Perl distribution for details.

=head1 SEE ALSO

L<POE::Component::SmokeBox::Backend>

=cut

