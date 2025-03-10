InstallGlobalFunction( THOMPSONS_NFA,
function(exp)
    local stack, stateCounter, char, i;

    stack:= [];
    stateCounter:= 0;
    i:= 1;


    while i <= Length(exp) do
        if exp[i] = '\\' and i+1 <= Length(exp) then
            LITERAL_NFA(exp[i+1], stack, stateCounter);
            stateCounter:=stateCounter+2;
            i:= i+1;
        elif exp[i] = '|' then
            UNION_NFA(stack, stateCounter);
            stateCounter:= stateCounter+2;
        elif exp[i] = '-' then
            SET_NFA(stack, stateCounter);
        elif exp[i] = '*' then
            STAR_NFA(stack, stateCounter);
            stateCounter:= stateCounter+2;
        elif exp[i] = '?' then
            QUESTION_NFA(stack, stateCounter);
            stateCounter:= stateCounter+2;
        elif exp[i] = '.' then
            ANY_NFA(stack, stateCounter);
            stateCounter:= stateCounter+2;
        elif exp[i] = '`' then
            CONCATENATE_NFA(stack);
        elif exp[i] = '+' then
            PLUS_NFA(stack, stateCounter);
            stateCounter:= stateCounter+2;
        else
            LITERAL_NFA(exp[i], stack, stateCounter);
            stateCounter:=stateCounter+2;
        fi;
        i:= i+1;
    od;

    return stack[1];

end );

InstallGlobalFunction( SET_NFA,
function(stack, stateCounter)
    local start, end_state, nfa1, nfa2, transitions, endOfSet, startOfSet, i;

    nfa1:= Remove(stack);
    nfa2:= Remove(stack);
    
    start:= nfa1.start;
    end_state:= nfa1.end_state;
    
    endOfSet:= IntChar(nfa1.transition[1][3]);
    startOfSet:= IntChar(nfa2.transition[1][3]);

    transitions:= [];

    for i in [startOfSet..endOfSet] do
        Add(transitions, [start, end_state, CharInt(i)]);
    od;

    Add(stack, rec(start:=start, end_state:= end_state, transition:= transitions));
end );

InstallGlobalFunction( ANY_NFA,
function(stack, stateCounter)
    local start, end_state, transitions;
    
    start:= stateCounter+1;
    stateCounter:= stateCounter+1;
    end_state:= stateCounter+1;
    stateCounter:= stateCounter+1;
    
    transitions:= [[start, end_state, '~']];

    Add(stack, rec(start:=start, end_state:= end_state, transition:= transitions));
end );

InstallGlobalFunction( LITERAL_NFA,
function(char, stack, stateCounter)
    local start, end_state, transition;

    start:= stateCounter+1;
    stateCounter:= stateCounter+1;
    end_state:= stateCounter+1;
    stateCounter:= stateCounter+1;
    transition:= [[start, end_state, char]];

    Add(stack, rec(start:=start, end_state:= end_state, transition:= transition));
end );

InstallGlobalFunction( CONCATENATE_NFA,
function(stack)
    local nfa1, nfa2, start1, start2, end1, end2, transition;

    nfa2:= Remove(stack);
    nfa1:= Remove(stack);
    
    start1:= nfa1.start;
    end1:= nfa1.end_state;
    start2:= nfa2.start;
    end2:= nfa2.end_state;
    
    Add(nfa1.transition, [end1, start2, '@']);
    for transition in nfa2.transition do
        Add(nfa1.transition, transition);
    od;

    Add(stack, rec(start:= start1, end_state:= end2, transition:= nfa1.transition));
end );

InstallGlobalFunction( QUESTION_NFA,
function(stack, stateCounter)
    local nfa, start, end_state;
    
    nfa:= Remove(stack);
    start:= stateCounter+1;
    stateCounter:= stateCounter+1;
    end_state:= stateCounter+1;
    stateCounter:= stateCounter+1;
    
    Add(nfa.transition, [start, nfa.start, '@']);
    Add(nfa.transition, [start, end_state, '@']);
    Add(nfa.transition, [nfa.end_state, end_state, '@']);
    
    Add(stack, rec(start:= start, end_state:= end_state, transition:= nfa.transition));
end );

InstallGlobalFunction( STAR_NFA,
function(stack, stateCounter)
    local nfa, start, end_state;
    
    nfa:= Remove(stack);
    
    start:= stateCounter+1;
    stateCounter:= stateCounter+1;
    end_state:= stateCounter+1;
    stateCounter:= stateCounter+1;
    
    Add(nfa.transition, [start, nfa.start, '@']);
    Add(nfa.transition, [start, end_state, '@']);
    Add(nfa.transition, [nfa.end_state, nfa.start, '@']);
    Add(nfa.transition, [nfa.end_state, end_state, '@']);
    
    Add(stack, rec(start:= start, end_state:= end_state, transition:= nfa.transition));
end );

InstallGlobalFunction( UNION_NFA,
function(stack, stateCounter)
    local nfa1, nfa2, start, end_state, transition;
    
    nfa2:= Remove(stack);
    nfa1:= Remove(stack);
    
    start:= stateCounter+1;
    stateCounter:= stateCounter+1;
    end_state:= stateCounter+1;
    stateCounter:= stateCounter+1;
    
    Add(nfa1.transition, [start, nfa1.start, '@']);
    Add(nfa1.transition, [start, nfa2.start, '@']);
    Add(nfa1.transition, [nfa1.end_state, end_state, '@']);
    Add(nfa1.transition, [nfa2.end_state, end_state, '@']);
    for transition in nfa2.transition do
        Add(nfa1.transition, transition);
    od;
    
    Add(stack, rec(start:= start, end_state:= end_state, transition:= nfa1.transition));
end );

InstallGlobalFunction( PLUS_NFA,
function(stack, stateCounter)
    local nfa, start, end_state, transition;
    
    nfa:= Remove(stack);
    
    start:= stateCounter+1;
    stateCounter:= stateCounter+1;
    end_state:= stateCounter+1;
    stateCounter:= stateCounter+1;
    
    Add(nfa.transition, [start, nfa.start, '@']);
    Add(nfa.transition, [nfa.end_state, end_state, '@']);
    Add(nfa.transition, [nfa.end_state, nfa.start, '@']);
    Add(stack, rec(start:= start, end_state:= end_state, transition:= nfa.transition));
end );

InstallGlobalFunction( SIMULATE_NFA,
function(nfa, input)
    local startStates, transitions, currentStates, char, state;

    transitions:= nfa.transition;

    currentStates:= EPSILON_TRANSITIONS([nfa.start], transitions);

    for char in input do

        currentStates:= MOVE_STATE(currentStates, char, transitions);

        currentStates:= EPSILON_TRANSITIONS(currentStates, transitions);
    
    od;

    for state in currentStates do
        if state = nfa.end_state then
            return true;
        fi;
    od;

    return false;

end );

InstallGlobalFunction( EPSILON_TRANSITIONS,
function(currentStates, transitions)
    local reachable_states, stack, current, transition;

    reachable_states:= Set(currentStates);
    stack:= ShallowCopy(reachable_states);
    
    while Length(stack) > 0 do
        current:= Remove(stack);
        for transition in transitions do
            if (transition[1] = current) and (transition[3] = '@') and (not transition[2] in reachable_states) then
                Add(reachable_states, transition[2]);
                Add(stack, transition[2]);
            fi;
        od;
    od;

    return reachable_states;
end );

InstallGlobalFunction( MOVE_STATE,
function(currentStates, symbol, transitions)
    local nextStates, transition, state;
    
    nextStates:= [];
    
    for state in currentStates do
        for transition in transitions do
            if (transition[1] = state) and (transition[3] = symbol) then
                Add(nextStates, transition[2]);

            elif (transition[1] = state) and (transition[3] = '~') then
                Add(nextStates, transition[2]);
            fi;
        od;
    od;
    
    return nextStates;
end );

InstallGlobalFunction(PRECEDENCE,
function(operator)
    if operator = '*' or operator = '?' or operator = '+' then
        return 4;
    elif operator = '`' then
        return 3;
    elif operator = '|' or operator = '-' then
        return 2;
    elif operator = '(' or operator = '[' then
        return 1;
    else
        return 0;
    fi;
end );

InstallGlobalFunction( FORMAT_EXPRESSION,
function(exp)
    local operators, binaryOperators, i, res, c1, c2;

    operators:= ['|', '?', '*', '+', '^', '-'];
    binaryOperators:= ['^', '|', '-'];
    i:= 1;
    res:= "";

    while i < Length(exp) do
        c1:= exp[i];
        i:= i+1;
        c2:= exp[i];

        res:= Concatenation(res, [c1]);

        if not (((c1 <> '(') and (c2 <> ')')) <> ((c1 <> '[') and (c2 <> ']'))) and (not c2 in operators) and (not c1 in binaryOperators) then
            res:= Concatenation(res, "`");
        fi;
    od;

    res:= Concatenation(res, [exp[Length(exp)]]);

    return res;

end );

InstallGlobalFunction( CONVERT_TO_POSTFIX,
function(exp)
    local output, stack, top, char, asciiChar, temp, i;

    output:= [];
    stack:= [];
    i:= 1;

    exp:= FORMAT_EXPRESSION(exp);

    while i <= Length(exp) do
        asciiChar:= IntChar(exp[i]);

        if (asciiChar in [97..122]) or (asciiChar in [65..90]) or (asciiChar in [48..57]) or (asciiChar = 32) or (exp[i] = '.') then
            Add(output, exp[i]);

        elif exp[i] = '\\' then
            Add(output, exp[i]);
            if i+1 <= Length(exp) then
                Add(output, exp[i+1]);
                i:= i+1;
            fi;

        elif exp[i] = '(' or exp[i] = '[' then
            Add(stack, exp[i]);
        
        elif exp[i] = ')' or exp[i] = ']' then

            while (Length(stack) > 0) and not ((stack[Length(stack)] <> '(') <> (stack[Length(stack)] <> '[')) do
                Add(output, Remove(stack));
            od;

            if (Length(stack) = 0) or not ((stack[Length(stack)] <> '(') <> (stack[Length(stack)] <> '[')) then
                Print("Invalid parentheses");
            fi;
            Remove(stack);
        
        elif IS_OPERATOR(exp[i]) then
            while (Length(stack) > 0) and (PRECEDENCE(stack[Length(stack)]) >PRECEDENCE(exp[i])) do
                Add(output, Remove(stack));
            od;
            Add(stack, exp[i]);
        fi;
        i:= i+1;
    od;

    while Length(stack) > 0 do
        top:= Remove(stack);
        if top = '(' or top = ')' then
            Print("Invalid parentheses 2");
        fi;
        Add(output, top);
    od;

    return output;
end );

InstallGlobalFunction( IS_OPERATOR,
function(char)
    if (char = '*') or (char = '`') or (char = '?') or (char = '|') or (char = '+') or (char = '-') then
        return true;
    else return false;
    fi;
end );

InstallGlobalFunction( display_Automaton,
function(exp)
    local aut, alphabet, reformatedTransitions, tempTransition, char, transitions, transition, automaton, transitionTable, i;
    
    LoadPackage("automata");

    aut:= THOMPSONS_NFA(CONVERT_TO_POSTFIX(exp));
    transitions:= aut.transition;
    alphabet:= [];
    reformatedTransitions:= [];
    transitionTable:= [];
    tempTransition:= [];

    for transition in transitions do
        if not (transition[3] in alphabet) then
            Add(alphabet, transition[3]);
        fi;
    od;

    for char in alphabet do
        for i in [1..aut.end_state] do
            for transition in transitions do
                if (transition[3] = char) and (transition[1] = i) then
                    Add(tempTransition,transition[2]);
                fi;
            od;
            Add(reformatedTransitions, tempTransition);
            tempTransition:= [];
        od;
        Add(transitionTable, reformatedTransitions);
        reformatedTransitions:= [];
    od;

    automaton:= Automaton("nondet", aut.end_state, alphabet, transitionTable, [aut.start], [aut.end_state]);

    return automaton;
end );

InstallGlobalFunction( text_findall,
function(exp, input)
    Print("todo");
end );

InstallGlobalFunction( text_Match,
function(exp, input)
    
    return SIMULATE_NFA(THOMPSONS_NFA(CONVERT_TO_POSTFIX(exp)), input);

end );