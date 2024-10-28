#
# regex: Implements regular expression matching.
#
# Implementations
#
InstallGlobalFunction( regex_Example,
function()
	Print( "This is a placeholder function, replace it with your own code.\n" );
end );

InstallGlobalFunction( reg_Char_Match,
function(a, b)
	#Print(a[1] = b[1]);
	return a[1] = b[1];
end );

InstallGlobalFunction( reg_Individual_Match,
function(a, b)
	#Print(a,"\n");
	#Print(Length(a),"\n");
	#Print(b,"\n");
	#Print(Length(b),"\n");
	#Print(IsChar(a),"\n");
	#Print(IsChar(b),"\n"); 

	if Length(a)=1 and reg_Char_Match(a,b) then
		return true;

	elif reg_Char_Match(a, b) then
		return reg_Individual_Match(a{ [2..Length(a)] }, b{ [2..Length(b)] });

	else return false;

	fi;
end ); 

InstallGlobalFunction( reg_Match,
function(a, b)
	local position, found, max_pos;
	position:= 1;
	found:= false;
	max_pos:= Length(b);
	while (position <= max_pos) do
		if found <> reg_Individual_Match(a, b{ [position..Length(b)] }) then
			Print(position + '\n');
			return true;
		fi;
		position:= position+1;
	od;
	return false;
end );

InstallGlobalFunction( RegularExpression,
function()
	#TODO
end );