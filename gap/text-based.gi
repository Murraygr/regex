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

    return stack;

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
    local nfa1, nfa2, start1, start2, end1, end2;

    nfa2:= Remove(stack);
    nfa1:= Remove(stack);
    
    start1:= nfa1.start;
    end1:= nfa1.end_state;
    start2:= nfa2.start;
    end2:= nfa2.end_state;
    
    Add(nfa1.transition, [end1, start2, "@"]);
    Add(nfa1.transition, nfa2.transition);

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
    local nfa1, nfa2, start, end_state;
    
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
    Add(nfa1.transition, nfa2.transition);
    
    Add(stack, rec(start:= start, end_state:= end_state, transition:= nfa1.transition));
end );

InstallGlobalFunction( create_state,
function(stateCounter)
    stateCounter:= stateCounter+1;
    return stateCounter;
end );