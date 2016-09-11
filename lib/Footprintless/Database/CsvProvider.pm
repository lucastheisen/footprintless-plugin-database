use strict;
use warnings;

package Footprintless::Database::CsvProvider;

# ABSTRACT: A CSV file provider implementation
# PODNAME: Footprintless::Database::CsvProvider

use parent qw(Footprintless::Database::AbstractProvider);

use overload q{""} => 'to_string', fallback => 1;

use Footprintless::Util qw(dynamic_module_new);
use Log::Any;

my $logger = Log::Any->get_logger();

sub backup {
    die("not yet implemented");
}

sub _connection_string {
    my ($self) = @_;
    my ($hostname, $port) = $self->_hostname_port();
    return join( '',
        'DBI:CSV:',
        'f_dir=', $self->{f_dir}, ';',
        'csv_eol=', $self->{csv_eol}, ';');
}

sub _init {
    my ($self, %options) = @_;
    $self->Footprintless::Database::AbstractProvider::_init(%options);

    my $entity = $self->_entity($self->{coordinate});
    
    $self->{f_dir} = $entity->{f_dir};
    $self->{csv_eol} = $entity->{csv_eol} || "\n";

    return $self;
}

sub restore {
    die("not yet implemented");
}

sub to_string {
    my ($self) = @_;
    return $self->_connection_string();
}

1;
