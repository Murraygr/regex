InstallGlobalFunction( reg_Example,
function()
    Print(reg_Match("abc", "abc"));
end );

InstallGlobalFunction( thompsons_nfa,
function(exp)
    local stack, stateCounter, char, i;

    stack:= [];
    stateCounter:= 0;
    i:= 1;


    for char in exp do
        if char = '|' then
            union_nfa(stack, stateCounter);
            stateCounter:= stateCounter+2;
        elif char = '*' then
            star_nfa(stack, stateCounter);
            stateCounter:= stateCounter+2;
        elif char = '?' then
            question_nfa(stack, stateCounter);
            stateCounter:= stateCounter+2;
        elif char = '.' then
            concatenate_nfa(stack);
        else
            literal_nfa(char, stack, stateCounter);
            stateCounter:=stateCounter+2;
        fi;
        i:= i+1;
    od;

    return stack[1];

end );

InstallGlobalFunction( literal_nfa,
function(char, stack, stateCounter)
    local start, end_state, transition;

    start:= stateCounter+1;
    stateCounter:= stateCounter+1;
    end_state:= stateCounter+1;
    stateCounter:= stateCounter+1;
    transition:= [[start, end_state, char]];

    Add(stack, rec(start:=start, end_state:= end_state, transition:= transition));
end );

InstallGlobalFunction( concatenate_nfa,
function(stack)
    local nfa1, nfa2, start1, start2, end1, end2, transition;

    nfa2:= Remove(stack);
    nfa1:= Remove(stack);
    
    start1:= nfa1.start;
    end1:= nfa1.end_state;
    start2:= nfa2.start;
    end2:= nfa2.end_state;
    
    Add(nfa1.transition, [end1, start2, "@"]);
    for transition in nfa2.transition do
        Add(nfa1.transition, transition);
    od;

    Add(stack, rec(start:= start1, end_state:= end2, transition:= nfa1.transition));
end );

InstallGlobalFunction( question_nfa,
function(stack, stateCounter)
    local nfa, start, end_state;
    
    nfa:= Remove(stack);
    start:= stateCounter+1;
    stateCounter:= stateCounter+1;
    end_state:= stateCounter+1;
    stateCounter:= stateCounter+1;
    
    Add(nfa.transition, [start, nfa.start, "@"]);
    Add(nfa.transition, [start, end_state, "@"]);
    Add(nfa.transition, [nfa.end_state, end_state, "@"]);
    
    Add(stack, rec(start:= start, end_state:= end_state, transition:= nfa.transition));
end );

InstallGlobalFunction( star_nfa,
function(stack, stateCounter)
    local nfa, start, end_state;
    
    nfa:= Remove(stack);
    
    start:= stateCounter+1;
    stateCounter:= stateCounter+1;
    end_state:= stateCounter+1;
    stateCounter:= stateCounter+1;
    
    Add(nfa.transition, [start, nfa.start, "@"]);
    Add(nfa.transition, [start, end_state, "@"]);
    Add(nfa.transition, [nfa.end_state, nfa.start, "@"]);
    Add(nfa.transition, [nfa.end_state, end_state, "@"]);
    
    Add(stack, rec(start:= start, end_state:= end_state, transition:= nfa.transition));
end );

InstallGlobalFunction( union_nfa,
function(stack, stateCounter)
    local nfa1, nfa2, start, end_state, transition;
    
    nfa2:= Remove(stack);
    nfa1:= Remove(stack);
    
    start:= stateCounter+1;
    stateCounter:= stateCounter+1;
    end_state:= stateCounter+1;
    stateCounter:= stateCounter+1;
    
    Add(nfa1.transition, [start, nfa1.start, "@"]);
    Add(nfa1.transition, [start, nfa2.start, "@"]);
    Add(nfa1.transition, [nfa1.end_state, end_state, "@"]);
    Add(nfa1.transition, [nfa2.end_state, end_state, "@"]);
    for transition in nfa2.transition do
        Add(nfa1.transition, transition);
    od;
    
    Add(stack, rec(start:= start, end_state:= end_state, transition:= nfa1.transition));
end );

InstallGlobalFunction( create_state,
function(stateCounter)
    stateCounter:= stateCounter+1;
    return stateCounter;
end );

InstallGlobalFunction( simulate_nfa,
function(nfa, input)
    local startStates, transitions, currentStates, char, state;

    transitions:= nfa.transition;

    currentStates:= epsilon_transitions([nfa.start], transitions);

    for char in input do

        currentStates:= move_state(currentStates, char, transitions);

        currentStates:= epsilon_transitions(currentStates, transitions);
    
    od;

    for state in currentStates do
        if state = nfa.end_state then
            return true;
        fi;
    od;

    return false;

end );

InstallGlobalFunction( epsilon_transitions,
function(currentStates, transitions)
    local reachable_states, stack, current, transition;

    reachable_states:= Set(currentStates);
    stack:= ShallowCopy(reachable_states);
    
    while Length(stack) > 0 do
        current:= Remove(stack);
        for transition in transitions do
            if (transition[1] = current) and (transition[3] = "@") and (not transition[2] in reachable_states) then
                Add(reachable_states, transition[2]);
                Add(stack, transition[2]);
            fi;
        od;
    od;

    return reachable_states;
end );

InstallGlobalFunction( move_state,
function(currentStates, symbol, transitions)
    local nextStates, transition, state;
    
    nextStates:= [];
    
    for state in currentStates do
        for transition in transitions do
            if (transition[1] = state) and (transition[3] = symbol) then
                Add(nextStates, transition[2]);
            fi;
        od;
    od;
    
    return nextStates;
end );

InstallGlobalFunction( convert_to_postfix,
function(exp)
    local output, stack, top, char, asciiChar, temp;

    output:= [];
    stack:= [];

    for char in exp do
        asciiChar:= IntChar(char);

        if (asciiChar in [97..122]) or (asciiChar in [65..90]) or (asciiChar in [48..57]) then
            Add(output, char);

        elif char = '(' then
            Add(stack, char);
            Print(stack);
        
        elif char = ')' then

            while (Length(stack) > 0) and (stack[Length(stack)] <> '(') do
                Add(output, Remove(stack));
            od;

            if (Length(stack) = 0) or (stack[Length(stack)] <> '(') then
                Print("Invalid parentheses");
            fi;
            Remove(stack);
        
        elif is_operator(char) then
            Print(stack);
            while (Length(stack) > 0) and (is_operator(stack[1])) do
                Add(output, Remove(stack));
            od;
            Add(stack, char);
        fi;
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

InstallGlobalFunction( is_operator,
function(char)
    if (char = '*') or (char = '.') or (char = '?') or (char = '|') then
        return true;
    else return false;
    fi;
end );

InstallGlobalFunction( text_Match,
function(exp, input)
    
    return simulate_nfa(thompsons_nfa(convert_to_postfix(exp)), input);

end );