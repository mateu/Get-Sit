#!/usr/bin/env perl
use 5.010;
 
package GetSit;
use Web::Simple;
use Get::Sit;
use Data::Dumper;

has gs => (
  is => 'lazy',
  builder => sub { 
    Get::Sit->new(
      index => 'get_lo_test', 
      type  => 'get_lo_test'
    )
  },
);
 
sub dispatch_request {
  sub (GET + /favicon.ico) {
    my ($self, ) = @_;
    [ 200, [ 'Content-type', 'text/plain' ], [ '' ] ]
  },
  sub (GET + /**.*) {
    my ($self, $query) = @_;
    warn "Query: $query\n";

    my $results = $self->gs->search_query_string($query);
    my $hits = $results->{hits}{hits};
    my $output = '';
    foreach my $hit (@{$hits}) {
        $output .= $self->add_hit_content($hit);
    }
    my $page = $self->html_wrapper($output);
    [ 200, [ 'Content-type', 'text/html' ], [ $page ] ]
  },
  sub () {
    [ 405, [ 'Content-type', 'text/plain' ], [ 'Method not allowed' ] ]
  }
}

sub add_hit_content {
    my ($self, $hit) = @_;

    my $name = $hit->{_source}->{title};
    my $url  = $hit->{_source}->{link};
    my $content = $hit->{_source}->{description};
    $content = substr($content, 0, 256);
    my $output .= "<h2><a href='${url}'>${name}</a></h2>\n";
    $output .= "<p>${content} ...</p>\n";
    return $output;
}

sub html_wrapper {
    my ($self, $content) = @_;

    $content //= 'No Hits';
    my $highlight_css = $self->highlight_css;
 
    my $head =<<"EOH";
<html>
<head>
<style media="screen" type="text/css">
$highlight_css
</style>
</head>
EOH

    my $body =<<"EOB";
 <body>
${content}
</body>
</html>
EOB

    my $page = $head . $body;
    return $page;
}

sub highlight_css {
    my ($self, ) = @_;

    my @highlight_css;
    my @font = ('font-weight:bold', 'font-style:normal'); 
    my $highlight_colors = 'green,' x 3 . 'orange,' x 3 . 'purple,' x 3 . 'red';
    my @highlight_colors = split /,/, $highlight_colors;
    foreach my $n (1..10) {
        my $class = 'em.hlt' . $n;
        my $color = 'color:' . $highlight_colors[$n - 1];
        my $attributes = join '; ', $color, @font;
        my $css_line = $class . ' { ' . $attributes . '; }';
        push @highlight_css, $css_line;
    } 
    return join "\n", @highlight_css;
}
 
GetSit->run_if_script;
