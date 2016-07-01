package Lexer;
use Data::Dumper;

use warnings;
use strict;

# new(src)
# Creates a new Lexer object with src as the string to lex.
sub new {
	my ($class, $src) = @_;
	my $self = {};

	bless($self, $class);
	$self->_init($src);

	return $self;
}

# _init(src)
# A private sub that initialises the lexer with the defaults to lex src.
sub _init {
	my ($self, $src) = @_;

	$self->{src} = $src;
	$self->{start} = 0;
	$self->{len} = 0;
	$self->{last} = length $src;
}

# _length
# A private sub that gives us the length of the current chunk we are lexing.
sub _length {
	my ($self) = @_;
	return $self->{start} + $self->{len}, 
}

# next
# Returns the next char from the Lexer and increments the len.
sub next {
	my ($self) = @_;

	# Get the next char from the src.
	my $c = substr($self->{src}, $self->_length, 1);
	$self->{len} += 1;

	# If len is bigger than the string just return an empty string.
	if ($self->_length > $self->{last}) {
		$self->{len} = $self->{last};
		return "";
	}

	return $c;
}

# prev
# Returns the previous char from the Lexer.
sub prev {
	my ($self) = @_;
	# If there are no characters before we return an empty string.
	return "" if ($self->{len} <= 0);
	return substr($self->{src}, $self->_length - 1, 1);
}

# peek
# Returns the next char from the Lexer, without incrementing the len.
sub peek {
	my ($self) = @_;
	# If we go over the last char return an empty string.
	return "" if (($self->{last} > 0) && (($self->_length + 1) > $self->{last}));
	return substr($self->{src}, $self->_length, 1);
}

# _validate(valid)
# A private sub that takes a string of chars, if any of the chars appear 
# in the src it returns true. It also increments the lexer.
sub _validate {
	my ($self, $valid) = @_;
	my $c = $self->next;
	for my $i (split(//, $valid)) {
		return 1 if ($i eq $c);
	}
	return 0;
}

# accept(str)
# Returns the first char that isn't in str.
sub accept {
	my ($self, $str) = @_;
	while ($self->_validate($str)) {
		return "" if ($self->peek eq "");
	}
	return $self->prev;
}

# deny(str)
# Returns the first char that is in str.
sub deny {
	my ($self, $str) = @_;
	while (!$self->_validate($str)) {
		return "" if ($self->peek eq "");
	}
	return $self->prev;
}

# match(str)
# Checks to see if the ensuing pattern in src matches length.
sub match {
	my ($self, $str) = @_;
	my $src = substr($self->{src}, $self->_length, (length $str));
	return ($str eq $src);
}

# ditch()
# Start lexing src from this point.
sub ditch {
	my ($self) = @_;
	$self->{start} += $self->{len};
	$self->{len} = 0;
}

# token()
# Gets the current token from the lexer.
sub token {
	my ($self) = @_;
	return substr($self->{src}, $self->{start}, $self->{len});
}

sub _status {
	my ($self) = @_;
	$self->{_token} = $self->token;
	$self->{_length} = $self->_length;
	print STDERR Dumper $self;
}

1;
