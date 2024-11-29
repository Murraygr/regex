#
# regex: Implements regular expression matching.
#
# Implementations
#
InstallGlobalFunction( regex_Example,
function()
end );

InstallGlobalFunction( reg_Is_Star,
function(char)
	if char = '*' then return true;
	else return false;
	fi;
end );

InstallGlobalFunction( reg_Is_Question,
function(char)
	if char = '?' then return true;
	else return false;
	fi;
end );

InstallGlobalFunction( reg_Is_Plus,
function(char)
	if char = '+' then return true;
	else return false;
	fi;
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
function(split_exp, target, min_match_num, max_match_num, infinite)
	local match_len, found, temp, matched, temp2;
	match_len:= 0;
	temp:= "";

	if min_match_num <> 0 then
		temp:= Concatenation(temp, String(split_exp[1]));
		match_len:= 1;
	fi;

	while infinite or (match_len < max_match_num) do
		found:= reg_Individual_Match(temp, target);
		if found then
			temp:= Concatenation(temp, String(split_exp[1]));
			match_len:= match_len+1;
		else break;
		fi;
	od;

	while match_len >= min_match_num do 
		temp2:= Concatenation(temp, split_exp[3]);
		matched:= reg_Individual_Match(temp2, target);
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
	if reg_Is_Star(char) or reg_Is_Question(char) or reg_Is_Plus(char) then
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
	elif exp[1] = '\\' then
		end_of_start:= 2;
		start:= String(exp{ [2..end_of_start] });
		end_of_start:= 3;
	else
		end_of_start:= 2;
		start:= [exp[1]];
	fi;

	if end_of_start <= Length(exp) and reg_Is_Special(exp[end_of_start]) then
		special:= exp[end_of_start];
		end_of_start:= end_of_start+1;
	fi;

	rest:= exp{ [end_of_start..Length(exp)] };

	return [start, special, rest];

end	);

InstallGlobalFunction( reg_Char_Match,
function(exp, target)
	if exp = "." then
		return true;
	fi;
	return exp[1] = target[1];
end );

#Fix bug where "\\." matches any character
InstallGlobalFunction( reg_Individual_Match,
function(exp, target)
	local split_exp;

	if (exp = "") or (exp = ".") then
		return true;
	elif (target = "") then
		return false;
	elif (Length(exp)=2) then
		if (exp[2]='$') then
			if (Length(target) = 1) then
				return true;
			else 
				return false;
			fi;
		fi;
	fi;
	
	split_exp:= reg_Split(exp);

	if reg_Is_Star(split_exp[2]) then
		return reg_Special_Match(split_exp, target, 0, 0, true);
	
	elif reg_Is_Question(split_exp[2]) then
		return reg_Special_Match(split_exp, target, 0, 1, false);
	
	elif reg_Is_Plus(split_exp[2]) then
		return reg_Special_Match(split_exp, target, 1, 0, true);

	elif (split_exp[1][1] = '(') and (split_exp[1][Length(split_exp[1])] = ')') then
		return reg_Alternative_Match(split_exp, target);
	fi;

	if reg_Char_Match(split_exp[1], target) then
		return reg_Individual_Match(split_exp[3], target{ [2..Length(target)] });

	else return false;
	fi;

end ); 

InstallGlobalFunction( reg_Match,
function(exp, target)
	local position, found, max_pos;

	position:= 1;
	found:= false;

	if (exp[1]='^') then
		max_pos:= 1;
		exp:= exp{ [2..Length(exp)] };
	else
		max_pos:= Length(target);
	fi;

	while (position <= max_pos) do
		if found <> reg_Individual_Match(exp, target{ [position..Length(target)] }) then
			#Print(position + '\n');
			return [true, position];
		fi;
		position:= position+1;
	od;

	return [false, 0];

end );
