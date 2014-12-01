package Get::Sit::Role::Elasticsearch;
use Moo::Role;
use 5.014;
use Elastijk;

has es => (
  is      => 'lazy',
  builder => sub {
    my $self = shift;
    return Elastijk->new(%{ $self->es_arguments });
  },
);

has es_arguments => (
  is      => 'lazy',
  builder => sub {
    my $self = shift;
    my %args = (
      host    => $self->host,
      port    => $self->port,
      'index' => $self->index,
      type    => $self->type,
    );
    return {%args};
  },
);

has host => (
  is      => 'lazy',
  builder => sub { 'localhost' },
);
has port => (
  is      => 'lazy',
  builder => sub { 9200 },
);
has 'index' => (
  is      => 'lazy',
  builder => sub { 'get_sit_index' },
);
has type => (
  is      => 'lazy',
  builder => sub { 'get_sit_type' },
);

1;

