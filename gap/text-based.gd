############################################################################
##
## text-based.gd
##
############################################################################
##
## This file declares functions for regular expression matching using an NFA
## constructed by Thompson's construction algorithm
##
############################################################################


DeclareGlobalFunction( "thompsons_nfa" );
DeclareGlobalFunction( "set_nfa" );
DeclareGlobalFunction( "any_nfa" );
DeclareGlobalFunction( "literal_nfa" );
DeclareGlobalFunction( "concatenate_nfa" );
DeclareGlobalFunction( "question_nfa" );
DeclareGlobalFunction( "star_nfa" );
DeclareGlobalFunction( "union_nfa" );
DeclareGlobalFunction( "plus_nfa" );
DeclareGlobalFunction( "create_state" );
DeclareGlobalFunction( "simulate_nfa" );
DeclareGlobalFunction( "epsilon_transitions" );
DeclareGlobalFunction( "move_state" );
DeclareGlobalFunction( "convert_to_postfix" );
DeclareGlobalFunction( "is_operator" );
DeclareGlobalFunction( "precedence" );
DeclareGlobalFunction( "format_expression" );
DeclareGlobalFunction( "display_Automaton" );
DeclareGlobalFunction( "text_findall" );
DeclareGlobalFunction( "text_Match" );