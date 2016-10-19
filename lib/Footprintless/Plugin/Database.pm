use strict;
use warnings;

package Footprintless::Plugin::Database;

# ABSTRACT: A Footprintless plugin for working with databases
# PODNAME: Footprintless::Plugin::Database

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
        : dynamic_module_new('Footprintless::Plugin::Database::DefaultCommandHelper');
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

=head1 ENTITIES

As with all plugins, this must be registered on the C<footprintless> entity.  
Also, it is necessary to specify the providers you want made available:

    plugins => [
        'Footprintless::Plugin::Database',
    ],
    'Footprintless::Plugin::Database' => {
        providers => {
            csv => 'Footprintless::Plugin::Database::CsvProvider',
            mysql => 'Footprintless::Plugin::Database::MySqlProvider',
            postres => 'Footprintless::Plugin::Database::PostgreSqlProvider',
        }
    }

You may supply your own providers given thaty the implement they interface 
outlined by L<Footprintless::Plugin::Database::AbstractProvider>:

    'Footprintless::Plugin::Database' => {
        providers => {
            db2 => 'My::Database::Db2Provider',
        }
    }

Additional configuration is supported for specifying a default provider and a
custom command helper implementation class:


    'Footprintless::Plugin::Database' => {
        command_helper => 'My::Automation::CommandHelper',
        default_provider => 'mysql'
        providers => {
            csv => 'Footprintless::Plugin::Database::CsvProvider',
            mysql => 'Footprintless::Plugin::Database::MySqlProvider',
            postres => 'Footprintless::Plugin::Database::PostgreSqlProvider',
        }
    }
    
See L<Footprintless::Plugin::Database::AbstractProvider/ENTITIES> for example 
database entity configuration.

=method db($footprintless, $coordinate, %options)

Returns a new database provider instance.  See 
L<Footprintless::Plugin::Database::AbstractProvider>.

=method db_command_helper()

Returns a new command helper for the db command. See 
L<Footprintless::Plugin::Database::DefaultCommandHelper>.

=for Pod::Coverage factory_methods

=head1 SEE ALSO

DBI
Footprintless
Footprintless::MixableBase
Footprintless::Plugin::Database
Footprintless::Plugin::Database::AbstractProvider
Footprintless::Plugin::Database::CsvProvider
Footprintless::Plugin::Database::DefaultCommandHelper
Footprintless::Plugin::Database::MySqlProvider
Footprintless::Plugin::Database::PostgreSqlProvider
