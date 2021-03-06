use Get::Sit;
use Test::More;
use Data::Printer;

my $searcher = Get::Sit->new(
  index => 'get_lo_test', 
  type  => 'get_lo_test'
);
my $search_word = 'linux';
my $result = $searcher->search_all($search_word);
ok(!$result->{errors});
$result = $searcher->search_query_string($search_word);
ok(!$result->{error});

done_testing;
