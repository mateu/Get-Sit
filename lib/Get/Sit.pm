package Get::Sit;

use utf8;
use 5.014;
use warnings;
use warnings qw( FATAL utf8 );
use open qw(:std :utf8);

use Moo;
with('Get::Sit::Role::Elasticsearch');

sub search_all {
  my ($self, $search) = @_;
  my $cerca = { query => { match => { '_all' => $search } }, };
  return $self->es->search(body => $cerca);
}


1;

