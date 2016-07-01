#! /usr/bin/perl

package Glooo::Lexer;

use warnings;
use strict;

sub new {
	my ($class, $src) = @_;
	my $self = {};

	bless($self, $class);
	$self->init($src);

	return $self;
}

sub init {
	my ($self, $src) = @_;

	$self->{src} = $src;
	$self->{start} = 0;
	$self->{len} = 0;
	$self->{last} = length $src;
}

sub length {
	my ($self) = @_;
	return $self->{start} + $self->{len}, 
}

# Next()
# Returns the next char from the Lexer and increments the length.
sub Next {
	my ($self) = @_;

	# Get the next char from the src.
	my $c = substr($self->{src}, $self->length, 1);
	$self->{len} += 1;

	# If len is bigger than the string just return a NULL character.
	if ($self->{len} > $self->{last}) {
		$self->{len} = $self->{last};
		return "";
	}

	return $c;
}

# Prev()
# Returns the previous char from the Lexer.
sub Prev {
	my ($self) = @_;
	return "" if ($self->{len} <= 0);
	return substr($self->{src}, $self->length - 1, 1);
}

sub Peek {

}

sub Accept {

}

sub Deny {

}

sub Match {

}

sub Ditch {

}

package main;

use Data::Dumper;

my $lexer = Glooo::Lexer->new("yum yum");
print Dumper $lexer;

for (1..10) {
	print "prev: " . $lexer->Prev . "\n";
	print "next: " . $lexer->Next . "\n";
}
