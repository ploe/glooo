#! /usr/bin/perl

package Glooo::Lexer;

use warnings;
use strict;

sub new {
	my ($class, $src) = @_;
	my $self = {};

	bless($self, $class);
	$self->_init($src);

	return $self;
}

sub _init {
	my ($self, $src) = @_;

	$self->{src} = $src;
	$self->{start} = 0;
	$self->{len} = 0;
	$self->{last} = length $src;
}

sub _length {
	my ($self) = @_;
	return $self->{start} + $self->{len}, 
}

# Next()
# Returns the next char from the Lexer and increments the length.
sub next {
	my ($self) = @_;

	# Get the next char from the src.
	my $c = substr($self->{src}, $self->_length, 1);
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
sub prev {
	my ($self) = @_;
	return "" if ($self->{len} <= 0);
	return substr($self->{src}, $self->_length - 1, 1);
}

sub peek {
	my ($self) = @_;
	return "" if (($self->{last} > 0) && (($self->_length + 1) > $self->{last}));
	return substr($self->{src}, $self->_length, 1);
}

sub _accept {
	my ($self, $valid) = @_;
	my $c = $self->next;
	for my $i (split(//, $valid)) {
		return 1 if ($i eq $c);
	}
	return 0;
}

sub Accept {
	my ($self, $valid) = @_;
	while ($self->_accept($valid)) {
		return "" if ($self->peek eq "");
	}
	return $self->prev;
}

sub Deny {

}

sub Match {

}

sub Ditch {

}

package main;

use Data::Dumper;

my $lexer = Glooo::Lexer->new("yum! yum!");
print Dumper $lexer;

$lexer->Accept("yum");
print "prev: " . $lexer->prev . "\n";
print "next: " . $lexer->next . "\n";
print "peek: " . $lexer->peek . "\n";
