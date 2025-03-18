#
# regex: Implements regular expression matching.
#
#! @Chapter Introduction
#!
#! regex is a package that implements regular expression matching. Currently
#! the package covers the formal definition of regular languages as well as
#! some operators found in most other regular expression engines.
#! <P/>
#! Most characters are treated as literals and can be concatenated implicitly.
#! The following characters are the special characters for this engine:
#! * '*' Matches 0 or more of the preceding regular expression
#! * '(x|y)' Matches x or y
#! * '.' Matches any character
#! * '+' Matches 1 or more of the preceding regular expression
#! * '?' Matches 0 or 1 of the preceding regular expression
#! * '[A-Z]' Matches a range of characters between the ASCII values for A and Z
#! * '\\' Escapes the following character so it is treated as a literal
#! Only for the regular expression based engine:
#! * '^' Only matches if the regular expression matches at the start of the input string
#! * '\$' Only matches if the regular expression matches at the end of the input string
#! This package also converts these regular expressions to non deterministic automaton
#! and can return an automaton object from the 'automata' package. Allowing for all of
#! utility in the automaton package to be used on the desired regular expression.
#!
#! @Chapter Functionality
#!
#! Primarily the text_Match(exp, input) function should be used and this function will only
#! match if the input string matches exactly, however, this can be avoided by starting and
#! ending the expression with '.*'.
#! <P/>
#! reg_Match(exp, input) is a more incomplete solution but still covers the formal definition
#! of a regular expression, explicitly, the empty word; the empty set; concatenation; union;
#! literals and Kleene star. This different style of regular expression engine can be used to
#! show the difference of time complexity when in the worst case. For example, the regular
#! expression '(a|aa)*b' against the input 'a'^n will match in exponential time with respect
#! to n for the reg_Match() function but polynomial time for the text_Match() function.
#! <P/>
#! Note neither of the two implementations are optimised for speed and are written with
#! clarity in mind.
#!
#! @Section Regular expression based methods
#!
#! This section will describe the methods for a regular expression
#! based approach to a regex engine. Primarily this implementation should be avoided
#! and the implementation outlined at Section 1.2 should be utilised.

DeclareGlobalFunction( "REG_IS_QUESTION" );
DeclareGlobalFunction( "REG_IS_STAR" );
DeclareGlobalFunction( "REG_IS_PLUS" );

#! @Description
#!  This function takes part of the regular expression and splits it by the '|'
#!  character. The function then matches the individual options against the
#!  target string.
DeclareGlobalFunction( "REG_ALTERNATIVE_MATCH" );

#! @Description
#!  This function takes part of the regular expression as a string, the input as
#!  a string, the minimum matches required, the maximum matches required and
#!  a boolean variable for if the matches should be infinite or not. Depending on
#!  the special operator desired these parameters change. The regular expression
#!  is then matched following how the operator is defined. For example, 'a*' would
#!  match 0 or more instances of 'a'.
DeclareGlobalFunction( "REG_SPECIAL_MATCH" );

DeclareGlobalFunction( "REG_IS_SPECIAL" );

#! @Description
#!  This function takes the regular expression as a string and parses it to find
#!  the next operator to match.
DeclareGlobalFunction( "REG_SPLIT" );

DeclareGlobalFunction( "REG_CHAR_MATCH" );
DeclareGlobalFunction( "REG_INDIVIDUAL_MATCH" );

#! @Description
#!  This function takes the regular expression and an input as strings. The function
#!  then matches the given regular expression against the input string in a way that
#!  loops through the regular expression against each character of the input.
DeclareGlobalFunction( "reg_Match" );