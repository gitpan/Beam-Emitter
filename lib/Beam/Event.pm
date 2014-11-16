package Beam::Event;
# ABSTRACT: Base Event class
$Beam::Event::VERSION = '0.003';
use strict;
use warnings;

use Moo;
use Types::Standard qw(:all);


has name => (
    is          => 'ro',
    isa         => Str,
    required    => 1,
);


has emitter => (
    is          => 'ro',
    isa         => ConsumerOf['Beam::Emitter'],
    required    => 1,
);


has is_default_stopped => (
    is          => 'rw',
    isa         => Bool,
    default     => sub { 0 },
);


has is_stopped => (
    is          => 'rw',
    isa         => Bool,
    default     => sub { 0 },
);


sub stop_default {
    my ( $self ) = @_;
    $self->is_default_stopped( 1 );
}


sub stop {
    my ( $self ) = @_;
    $self->stop_default;
    $self->is_stopped( 1 );
}

1;

__END__

=pod

=head1 NAME

Beam::Event - Base Event class

=head1 VERSION

version 0.003

=head1 SYNOPSIS

    # My::Emitter consumes the Beam::Emitter role
    my $emitter = My::Emitter->new;
    $emitter->on( "foo", sub {
        my ( $event ) = @_;
        print "Foo happened!\n";
        # stop this event from continuing
        $event->stop;
    } );
    my $event = $emitter->emit( "foo" );

=head1 DESCRIPTION

This is the base event class for C<Beam::Emitter> objects.

The base class is only really useful for notifications. Create a subclass
to add data attributes.

=head1 ATTRIBUTES

=head2 name

The name of the event. This is the string that is given to C<Beam::Emitter::on>.

=head2 emitter

The emitter of this event. This is the object that created the event.

=head2 is_default_stopped

This is true if anyone called L</stop_default> on this event.

Your L<Beam::Emitter|emitter> should check this attribute before trying to do
what the event was notifying about.

=head2 is_stopped

This is true if anyone called L</stop> on this event.

When using L<Beam::Emitter/emit|the emit method>, this is checked automatically
after every callback, and event processing is stopped if this is true.

=head1 METHODS

=head2 stop_default ()

Calling this will cause the default behavior of this event to be stopped.

B<NOTE:> Your event-emitting object must check L</is_default_stopped> for this
behavior to work.

=head2 stop ()

Calling this will immediately stop any further processing of this event.
Also calls L</stop_default>.

=head1 AUTHOR

Doug Bell <preaction@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Doug Bell.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
