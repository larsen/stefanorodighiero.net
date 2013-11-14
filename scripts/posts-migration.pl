use strict;
use warnings;

use DBI;
use IO::File;
use String::Dirify qw/ :all /;
use Data::Dumper;

my $dbh = DBI->connect(
  '', '', ''
);

my $sql = q{
  select post_date, post_title, post_content
    from wp_posts
   where post_status = 'publish'
     and post_title not like 'links for %'
};

my $posts = $dbh->selectall_arrayref( $sql, {Slice => {}} );

foreach my $p ( @$posts ) {
  my $dirified_title = dirify( $p->{post_title} );
  printf "%s\t%s\n\t%s\n", $p->{post_date}, $p->{post_title}, $dirified_title;

  my ($ymd, undef) = split / /, $p->{post_date};

  my $fh = IO::File->new( sprintf( "%s-%s.markdown", $ymd, $dirified_title ), 'w') or die "$@\n";
  $fh->binmode(':utf8');
  print $fh <<"EOT";
---
title: $p->{post_title}
---

$p->{post_content}
EOT
  $fh->close;
}
