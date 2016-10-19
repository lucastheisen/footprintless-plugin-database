use strict;
use warnings;

package Footprintless::Plugin::Database::Command::db;

# ABSTRACT: Provides support for databases
# PODNAME: Footprintless::Plugin::Database::Command::db

use parent qw(Footprintless::App::ActionCommand);

sub _actions {
    return (
        'backup' => 'Footprintless::Plugin::Database::Command::db::backup',
        'client' => 'Footprintless::Plugin::Database::Command::db::client',
        'copy-to' => 'Footprintless::Plugin::Database::Command::db::copy_to',
        'restore' => 'Footprintless::Plugin::Database::Command::db::restore',
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
