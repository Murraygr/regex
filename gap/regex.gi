#
# regex: Implements regular expression matching.
#
# Implementations
#
InstallGlobalFunction( regex_Example,
function()
end );

InstallGlobalFunction( reg_Alternative_Match,
function(exp, target)
	local options, found, i;
	options:= SplitString(exp[1]{ [2..Length(exp[1])-1] }, "|");

	for i in [1..Length(options)] do
		found:= reg_Individual_Match(Concatenation(options[i],exp[3]), target);
		if found then
			return found;
		fi;
	od;
	return false;

end );

InstallGlobalFunction( reg_Special_Match,
function(split_exp, target, min_match_num, infinite)
	local match_len, found, temp, matched, temp2;
	match_len:= 0;
	temp:= "";
	while infinite do
		found:= reg_Individual_Match(temp, target);
		if found then
			temp:= Concatenation(temp, String(split_exp[1]));
			match_len:= match_len+1;
		else break;
		fi;
	od;

	while match_len >= min_match_num do 
		#Print(temp);
		temp2:= Concatenation(temp, split_exp[3]);
		#Print(temp2);
		matched:= reg_Individual_Match(temp2, target);
		#Print(matched);
		if matched then
			return matched;
		fi;
		match_len:= match_len-1;
		temp:= temp{ [1..Length(temp)-Length(split_exp[1])]};
	od;
	return false;
end	);

InstallGlobalFunction( reg_Is_Special,
function(char)
	if char = '*' then
		return true;
	else return false;
	fi;
end );

InstallGlobalFunction( reg_Split,
function(exp)
	local start, end_of_start, special, rest, temp;

	special:= "";

	if exp[1] = '(' then
		temp:= reg_Match(")", exp);
		end_of_start:= temp[2];
		start:= String(exp{ [1..end_of_start] });
		end_of_start:= end_of_start+1; 
	else
		end_of_start:= 2;
		start:= [exp[1]];
	fi;

	if end_of_start < Length(exp) and reg_Is_Special(exp[end_of_start]) then
		special:= exp[end_of_start];
		end_of_start:= end_of_start+1;
	fi;

	rest:= exp{ [end_of_start..Length(exp)] };

	return [start, special, rest];

end	);

InstallGlobalFunction( reg_Char_Match,
function(exp, target)
	return exp[1] = target[1];
end );

InstallGlobalFunction( reg_Individual_Match,
function(exp, target)
	local split_exp;

	if (Length(exp)=1 and reg_Char_Match(exp,target)) or (exp = "") then
		return true;
	fi;
	
	split_exp:= reg_Split(exp);

	if reg_Is_Special(split_exp[2]) then
		return reg_Special_Match(split_exp, target, 0, true);
	fi;

	if (split_exp[1][1] = '(') and (split_exp[1][Length(split_exp[1])] = ')') then
		return reg_Alternative_Match(split_exp, target);
	fi;

	if reg_Char_Match(exp, target) then
		return reg_Individual_Match(exp{ [2..Length(exp)] }, target{ [2..Length(target)] });

	else return false;
	fi;

end ); 

InstallGlobalFunction( reg_Match,
function(exp, target)
	local position, found, max_pos;

	position:= 1;
	found:= false;
	max_pos:= Length(target);

	while (position <= max_pos) do
		if found <> reg_Individual_Match(exp, target{ [position..Length(target)] }) then
			#Print(position + '\n');
			return [true, position];
		fi;
		position:= position+1;
	od;

	return [false, 0];

end );
