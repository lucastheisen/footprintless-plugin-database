use strict;
use warnings;

package Footprintless::Database::DatabasePlugin::Command::db::restore;

# ABSTRACT: restore a database from a backup
# PODNAME: Footprintless::Database::DatabasePlugin::Command::db::restore

use parent qw(Footprintless::App::Action);

use Carp;
use Footprintless::App -ignore;
use Log::Any;

my $logger = Log::Any->get_logger();

sub execute {
    my ($self, $opts, $args) = @_;

    $logger->info('Performing restore...');
    eval {
        $self->{db}->connect();
        $self->{db}->restore(
            (delete($opts->{file}) || \*STDIN),
            %$opts);
    };
    my $error = $@;
    $self->{db}->disconnect();
    die($error) if ($error);
    $logger->info('Done...');
}

sub opt_spec {
    return (
        ['clean', 'drop all data on the target before restoring'],
        ['file=s', 'the input file'],
        ['ignore-deny', 'will allow running on denied coordinates'],
        ['post-restore=s', 'a sql script to run after the restore'],
    );
}

sub usage_desc {
    return 'fpl db DB_COORD restore %o';
}

sub validate_args {
    my ($self, $opts, $args) = @_;

    my $command_helper = $self->{footprintless}->db_command_helper();
    croak("destination [$self->{coordinate}] not allowed")
        unless $opts->{ignore_deny} 
            || $command_helper->allowed_destination($self->{coordinate});

    eval {
        $self->{db} = $self->{footprintless}->db($self->{coordinate});
    };
    croak("invalid coordinate [$self->{coordinate}]: $@") if ($@);
}

1;

__END__

=for Pod::Coverage execute opt_spec usage_desc validate_args
