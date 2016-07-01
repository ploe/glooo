#! /usr/bin/perl

package main;
use Data::Dumper;
use Lexer;

my $lexer = Lexer->new("    'hello'world");
$lexer->_status;

$lexer->deny("'");
print STDERR "Match\n" if ($lexer->match("hello"));
$lexer->_status;
$lexer->ditch;
$lexer->accept("helo'");
$lexer->_status;
print STDERR "prev: " . $lexer->prev . "\n";
print STDERR "next: " . $lexer->next . "\n";
print STDERR "peek: " . $lexer->peek . "\n";
