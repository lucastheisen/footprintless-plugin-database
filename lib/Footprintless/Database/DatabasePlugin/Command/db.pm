use strict;
use warnings;

package Footprintless::Database::DatabasePlugin::Command::db;

# ABSTRACT: Provides support for databases
# PODNAME: Footprintless::Database::DatabasePlugin::Command::db

use parent qw(Footprintless::App::ActionCommand);

sub _actions {
    return (
        'backup' => 'Footprintless::Database::DatabasePlugin::Command::db::backup',
        'client' => 'Footprintless::Database::DatabasePlugin::Command::db::client',
        'copy-to' => 'Footprintless::Database::DatabasePlugin::Command::db::copy_to',
        'restore' => 'Footprintless::Database::DatabasePlugin::Command::db::restore',
    );
}

sub _default_action {
    return 'client';
}

sub usage_desc {
    return 'fpl db DB_COORD ACTION %o';
}

1;

__END__

=head1 SYNOPSIS

    fpl db pastdev.dev.app.db backup

=head1 DESCRIPTION

Performs actions on a database instance.

The currently availble providers are:
    
    CSV          experimental
    MySql        fully implemented
    PostgreSQL   experimental
