use strict;
use warnings;

package Footprintless::Database::DatabasePlugin;

# ABSTRACT: A Footprintless plugin for working with databases
# PODNAME: Footprintless::Database::DatabasePlugin

use Footprintless::Util qw(dynamic_module_new);

use parent qw(Footprintless::Plugin);

sub db {
    my ($self, $footprintless, $coordinate, @rest) = @_;
    die ("database plugin config required") unless ($self->{config});

    my $entity = $footprintless->entities()->get_entity($coordinate);

    my $provider = $entity->{provider}
        ? $self->{config}{providers}{$entity->{provider}}
        : $self->{config}{default_provider}
            ? $self->{config}{providers}{$self->{config}{default_provider}}
            : undef;
    if ($provider) {
        return dynamic_module_new($provider, 
            $footprintless, $coordinate, @rest);
    }
    else {
        if ($entity->{provider}) {
            die("unsupported database provider: $entity->{provider}");
        }
        else {
            die("provider not specified and no default configured");
        }
    }
}

sub db_command_helper {
    my ($self, $footprintless, $coordinate, @rest) = @_;
    return $self->{config}{command_helper}
        ? dynamic_module_new($self->{config}{command_helper})
        : dynamic_module_new('Footprintless::Database::DefaultCommandHelper');
}

sub factory_methods {
    my ($self) = @_;
    return {
        db => sub {
            return $self->db(@_);
        },
        db_command_helper => sub {
            return $self->db_command_helper(@_);
        }
    }
}

1;

__END__

=head1 DESCRIPTION

Provides the C<db> factory method to the framework as well as the C<db> command to
the CLI.

=method db($footprintless, $coordinate, %options)

Returns a new database provider instance.  See 
L<Footprintless::Database::AbstractProvider>.

=method db_command_helper()

Returns a new command helper for the db command. See 
L<Footprintless::Database::DefaultCommandHelper>.

=for Pod::Coverage factory_methods

=head1 SEE ALSO

DBI
Footprintless
Footprintless::MixableBase
Footprintless::Database::DatabasePlugin
Footprintless::Database::AbstractProvider
Footprintless::Database::CsvProvider
Footprintless::Database::DefaultCommandHelper
Footprintless::Database::MySqlProvider
Footprintless::Database::PostgreSqlProvider
