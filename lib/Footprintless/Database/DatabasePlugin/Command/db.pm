use strict;
use warnings;

package Footprintless::Database::DatabasePlugin::Command::db;

# ABSTRACT: Provides support for databases
# PODNAME: Footprintless::Database::DatabasePlugin::Command::db

use parent qw(Footprintless::App::ActionCommand);

my %actions = (
    'backup' => 'Footprintless::Database::DatabasePlugin::Command::db::backup',
    'client' => 'Footprintless::Database::DatabasePlugin::Command::db::client',
    'copy-to' => 'Footprintless::Database::DatabasePlugin::Command::db::copy_to',
    'restore' => 'Footprintless::Database::DatabasePlugin::Command::db::restore',
);

sub _action_implementation {
    my ($self, $action) = @_;
    return $actions{$action};
}

1;

__END__

=head1 SYNOPSIS

    fpl db asias.dev.liferay.db backup

=head1 DESCRIPTION

Performs actions on a database instance.  The available actions are:

    backup       creates a backup of the database
    client       start a command line client
    copy-to      copy's the database to the specified destination
    restore      restore a database from a backup

The currently availble providers are:
    
    CSV          experimental
    MySql        fully implemented
    PostgreSQL   experimental
