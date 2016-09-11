use strict;
use warnings;

package Footprintless::Database::DatabasePlugin::Command::db::copy_to;

# ABSTRACT: copy's the database to the specified destination
# PODNAME: Footprintless::Database::DatabasePlugin::Command::db::copy_to

use parent qw(Footprintless::App::Action);

use Carp;
use Footprintless::App -ignore;
use Log::Any;

my $logger = Log::Any->get_logger();

sub execute {
    my ($self, $footprintless, $coordinate, $opts, $args) = @_;

    $logger->debugf('options=%s', $opts);
    eval {
        $self->{db}->connect();
        $self->{destination_db}->connect();

        $self->{db}->backup($self->{destination_db}, %$opts,
            post_restore => $self->{post_restore});
    };
    my $error = $@;
    $self->{db}->disconnect();
    $self->{destination_db}->disconnect();
    die($error) if ($error);

    $logger->info('Done...');
}

sub opt_spec {
    return (
        ['clean', 'drop all data on the target before restoring'],
        ['file=s', 'the output file'],
        ['ignore-all-views', 'will ignore all views'],
        ['ignore-deny', 'will allow running on denied coordinates'],
        ['ignore-table=s@', 'will ignore the specified table'],
        ['live', 'will backup live'],
        ['only-table=s@', 'will only backup the specified table'],
        ['single-transaction', 'perform the restore in a single transaction'],
        ['where=s', 'a where clause'],
    );
}

sub validate_args {
    my ($self, $footprintless, $coordinate, $opts, $args) = @_;

    eval {
        $self->{db} = $footprintless->db($coordinate);
    };
    croak("invalid coordinate [$coordinate]: $@") if ($@);

    my $command_helper = $footprintless->db_command_helper();
    my ($destination_coordinate) = @$args;
    croak("destination [$destination_coordinate] not allowed")
        unless $opts->{ignore_deny} 
            || $command_helper->allowed_destination($destination_coordinate);
    $self->usage_error('destination coordinate required for copy') 
    unless ($destination_coordinate);
    eval {
        $self->{destination_db} = $footprintless->db($destination_coordinate);
    };
    croak("invalid destination coordinate [$destination_coordinate]: $@") if ($@);

    $self->{post_restore} = $command_helper->post_restore(
        $coordinate, $destination_coordinate);
}

1;

__END__

=for Pod::Coverage execute opt_spec usage_desc validate_args
