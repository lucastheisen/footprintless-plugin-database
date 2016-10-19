use strict;
use warnings;

package Footprintless::Plugin::Database::Command::db::client;

# ABSTRACT: start a command line client
# PODNAME: Footprintless::Plugin::Database::Command::db::client

use parent qw(Footprintless::App::Action);

use Carp;
use Footprintless::App -ignore;
use Log::Any;

my $logger = Log::Any->get_logger();

sub execute {
    my ($self, $opts, $args) = @_;

    $self->{db}->client(in_file => $self->{in_file}, client_options => $args);
}

sub opt_spec {
    return (
        ['in-file=s', 'a sql script to pipe as input to the client']
    );
}

sub usage_desc {
    return 'fpl db DB_COORD client %o';
}

sub validate_args {
    my ($self, $opts, $args) = @_;

    eval {
        $self->{db} = $self->{footprintless}->db($self->{coordinate});
    };
    croak("invalid coordinate [$self->{coordinate}]: $@") if ($@);

    if ($opts->{in_file}) {
        my $command_helper = $self->{footprintless}->db_command_helper();
        $self->{in_file} = $command_helper->locate_file($opts->{in_file});
    }
}

1;

__END__

=for Pod::Coverage execute opt_spec usage_desc validate_args
