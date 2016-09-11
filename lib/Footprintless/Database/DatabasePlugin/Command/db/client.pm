use strict;
use warnings;

package Footprintless::Database::DatabasePlugin::Command::db::client;

# ABSTRACT: start a command line client
# PODNAME: Footprintless::Database::DatabasePlugin::Command::db::client

use parent qw(Footprintless::App::Action);

use Carp;
use Footprintless::App -ignore;
use Log::Any;

my $logger = Log::Any->get_logger();

sub execute {
    my ($self, $footprintless, $coordinate, $opts, $args) = @_;

    $self->{db}->client(in_file => $self->{in_file}, client_options => $args);

    $logger->info('Done...');
}

sub opt_spec {
    return (
        ['in-file=s', 'a sql script to pipe as input to the client']
    );
}

sub validate_args {
    my ($self, $footprintless, $coordinate, $opts, $args) = @_;

    eval {
        $self->{db} = $footprintless->db($coordinate);
    };
    croak("invalid coordinate [$coordinate]: $@") if ($@);

    my $command_helper = $footprintless->db_command_helper();
    $self->{in_file} = $command_helper->locate_file($opts->{in_file});
}

1;

__END__

=for Pod::Coverage execute opt_spec usage_desc validate_args
