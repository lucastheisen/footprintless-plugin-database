use strict;
use warnings;

package Footprintless::Database::DefaultCommandHelper;

# ABSTRACT: The default implementation of command helper for db
# PODNAME: Footprintless::Database::DefaultCommandHelper
#
sub new {
    return bless({}, shift)->_init(@_);
}

sub allowed_destination {
    my ($self, $coordinate) = @_;
    return 1;
}

sub _init {
    my ($self, $footprintless) = @_;
    $self->{footprintless} = $footprintless;
    return $self;
}

sub locate_file {
    my ($self, $file) = @_;
    croak("file not found [$file]") unless (-f $file);
    return $file;
}

sub post_restore {
    my ($self, $from_coordinate, $to_coordinate) = @_;
    my $file;
    eval {
        $file = locate_file("$from_coordinate-$to_coordinate.sql");
    };
    return $file;
}

1;

__END__

=constructor new($footprintless)

Creates a new instance.

=method allowed_destination($coordinate)

Returns a I<truthy> value if C<$coordinate> is allowed as a destination.

=method locate_file($file)

Returns the path to C<$file>.  Croaks if the file cannot be found.

=method post_restore($from_coordinate, $to_coordinate)

Returns the path to a sql script file that should be run after a restore.

=head1 SEE ALSO

Footprintless::Database::DatabasePlugin
