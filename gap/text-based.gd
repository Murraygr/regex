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

############################################################################
##
## THOMPSONS_NFA(exp)
##
## Takes a regular expression, exp, in the form of a string and converts
## it into a corresponding nondeterministic finite automaton through
## Thompson's construction algorthim. The exp parameter is expected to be in
## reverse Polish form. Each character in the expression then calls a
## corresponding function to create an NFA for the expected action. The
## final automaton is returned as a record containing a start node, end node
## and a transition table where each transition is of the format
## [start_node, next_node, character]. The '@' character is used to
## represent epsilon transitions.
##
############################################################################
DeclareGlobalFunction( "THOMPSONS_NFA" );

############################################################################
##
## SET_NFA(stack, stateCounter)
##
## Takes the stack of automatons as a list and the current stateCounter as
## an integer. The top two automatons on the stack will be two literals -
## from these automatons this function takes the two literals and adds
## transitions for the characters between the given ascii values of the two
## literals. For example, a regular expression of format "[a-z]" will match
## all characters of the ascii values between a and z.
##
############################################################################
DeclareGlobalFunction( "SET_NFA" );

############################################################################
##
## ANY_NFA(stack, stateCounter)
##
## Takes the stack of automatons as a list and the current stateCounter as 
## an integer. This function creates two new states and connects them by the
## '~' character. In the logic for simulating the nfa if this character is
## seen it matches any given input. The new nfa is then pushed onto the
## stack.
##
############################################################################
DeclareGlobalFunction( "ANY_NFA" );

############################################################################
##
## LITERAL_NFA(char, stack, stateCounter)
##
## Takes a character, the stack of automatons as a list and the current
## stateCounter as an integer. Two new states are created and is connected
## by the character parameter of the function. The new nfa is then pushed
## onto the stack.
##
############################################################################
DeclareGlobalFunction( "LITERAL_NFA" );

############################################################################
##
## CONCATENATE_NFA(stack)
##
## Takes the stack of automatons as a list. This function concatenates the
## top two automatons on the stack.
##
############################################################################
DeclareGlobalFunction( "CONCATENATE_NFA" );

############################################################################
##
## QUESTION_NFA(stack, stateCounter)
##
## Takes the stack of automatons as a list and the current stateCounter as
## an integer. This function takes the top automaton from the stack and
## modifies it with epsilon transititions so the nfa accepts 0 or 1 of the
## corresponding regular expression. For example, a regular expression of
## form "a?" would accept the empty string or "a".
##
############################################################################
DeclareGlobalFunction( "QUESTION_NFA" );

############################################################################
##
## STAR_NFA(stack, stateCounter)
##
## Takes the stack of automatons as a list and the current stateCounter as
## an integer. This function takes the top automaton from the stack and
## modifies it with epsilon transitions so the nfa accepts 0 or infinite of
## the corresponding regular expression. For example, a regular expression
## of form "a*" would accept the empty string, "a", "aa", etc.
##
############################################################################
DeclareGlobalFunction( "STAR_NFA" );

############################################################################
##
## UNION_NFA(stack, stateCounter)
##
## Takes the stack of automatons as a list and the current stateCounter as
## an integer. This function takes the top two automatons from the stack
## and modifies the automaton with epsilon transitions so either of the
## two automatons can be accepted. For example, a regular expression of form
## "(a|b)" will accept "a" or "b".
##
############################################################################
DeclareGlobalFunction( "UNION_NFA" );

############################################################################
##
## PLUS_NFA(stack, stateCounter)
##
## Takes the stack of automatons as a list and the current stateCounter as
## an integer. This function takes the top automaton from the stack and
## modifies it with epsilon transitions so the new automaton will accept 1
## or infinite of the corresponding regular expression. For example, a
## regular expression of "a+" will accept "a", "aa", "aaa", etc.
##
############################################################################
DeclareGlobalFunction( "PLUS_NFA" );

############################################################################
##
## SIMULATE_NFA(nfa, input)
##
## Takes an NFA of the format created by the THOMPSONS_NFA(exp) function and
## an input as a string. The function then simulates the nfa against the
## given input. Each character of the input is looked at and the next
## possible states are found. Every state that can be reached from epsilon
## transitions are also considered as the current state. After this if the
## end state of the NFA is in the set of current states then the expression 
## has been matched and true is returned, otherwise false.
##
############################################################################
DeclareGlobalFunction( "SIMULATE_NFA" );

############################################################################
##
## EPSILON_TRANSITIONS(currentStates, transitions)
##
## This function takes the currentStates as a list and the transition table
## for the current NFA. The states that can be reached by only epsilon 
## transitions are found. These states can be added to the current states
## as an epsilon transition accepts the empty word which can be applied at
## any time.
##
############################################################################
DeclareGlobalFunction( "EPSILON_TRANSITIONS" );

############################################################################
##
## MOVE_STATE(currentStates, symbol, transitions)
##
## This function takes the currentStates as a list, the current character of 
## the input to be analysed and the transition table of the NFA. The
## function then loops through the states and transitions to find which
## states the NFA could be in.
##
############################################################################
DeclareGlobalFunction( "MOVE_STATE" );

############################################################################
##
## CONVERT_TO_POSTFIX(exp)
##
## This function takes a regular expression, exp, as a string. The function
## then parses the string and converts the expression to reverse polish form
## using the shunting yard algorithm.
##
############################################################################
DeclareGlobalFunction( "CONVERT_TO_POSTFIX" );

############################################################################
##
## IS_OPERATOR(char)
##
## This function takes a character and checks it against a list of operators
## if the character belongs to the list true is returned, otherwise false.
##
############################################################################
DeclareGlobalFunction( "IS_OPERATOR" );
############################################################################
##
## PRECEDENCE(char)
##
## This function takes a character and returns the corresponding precedence
## the operator has.
##
############################################################################
DeclareGlobalFunction( "PRECEDENCE" );

############################################################################
##
## FORMAT_EXPRESSION(exp)
##
## This function parses and inserts explicit concatenation characters where 
## appropriate in the given string before the CONVERT_TO_POSTFIX(exp)
## function sees it.
##
############################################################################
DeclareGlobalFunction( "FORMAT_EXPRESSION" );

############################################################################
##
## display_Automaton(exp)
##
## This function takes a regular expression, exp, as a string. This regular
## expression is converted into a Thompson NFA of the format described in
## the THOMPSONS_NFA(exp) function. This NFA is then converted into an
## automaton object from the 'automata' package. From this the user can use
## the functions declared in the 'automata' package, for example, 
## DrawAutomaton(aut) can be used to easily visualise the NFAs created by
## this package.
############################################################################
DeclareGlobalFunction( "display_Automaton" );

############################################################################
##
## text_Findall(exp, input)
##
## todo
##
############################################################################
DeclareGlobalFunction( "text_findall" );

############################################################################
##
## text_Match(exp, input)
##
## This function takes a regular expression, exp, and an input as strings.
## The function then calls the relavent functions to convert the expression
## to the appropriate format; create a corresponding NFA and simulates the
## NFA against the given input and return true if there is a match,
## otherwise false.
##
############################################################################
DeclareGlobalFunction( "text_Match" );