grammar EntityQL;

// Core building blocks
ID: [a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠƯàáâãèéêìíòóôõùúăđĩũơưẠ-ỹ_] 
    [a-zA-Z0-9ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠƯàáâãèéêìíòóôõùúăđĩũơưẠ-ỹ0-9-_]*;

DIGIT: [0-9];

// Bao gồm các ký tự tiếng Việt và ký tự đặc biệt khác
STRING_CHARS: [a-zA-Z0-9ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠƯàáâãèéêìíòóôõùúăđĩũơưẠ-ỹ \t`~!@#$%^&*()_+={}|\\:"'\u005B\u005D;<>?,./-];

// identity includes keywords too
identity: ID;

int: '-'? DIGIT+;
decimal: '-'? DIGIT+ '.' DIGIT+;
boolean: 'true' | 'false';
string: '"' ( '"' | ~('\n' | '\r') | STRING_CHARS)*? '"';
null: 'null';
constant: string
	| int
	| decimal
	| boolean
	| null
	| identity; // identity should end up being an enum

ws: ' ' | '\t' | '\n' | '\r';

args: expression (',' ws* expression)*;
call: method = identity '(' arguments = args? ')';
callPath: (identity | call) ('.' (identity | call))*;

expression: 
	'if ' (' ' | '\t')* test = expression (' ' | '\t')* 'then ' (' ' | '\t')* ifTrue = expression (' ' | '\t')* 'else ' (' ' | '\t')* ifFalse = expression # ifThenElse
	| test = expression ' '* '?' ' '* ifTrue = expression ' '* ':' ' '* ifFalse = expression #ifThenElseInline
	| left = expression ' '* op = ('*' | '/' | '%') ' '* right = expression # binary
	| left = expression ' '* op = ('+' | '-') ' '* right = expression # binary
	| left = expression ' '* op = ('<=' | '>=' | '<' | '>') ' '* right = expression # binary
	| left = expression ' '* op = ('==' | '!=') ' '* right = expression # binary
	| left = expression ' '* op = '^' ' '* right = expression # binary
	| left = expression ' '* op = ('and' | '&&') ' '* right = expression # logic
	| left = expression ' '* op = ('or' | '||') ' '* right = expression # logic
	| '(' body = expression ')' # expr
	| callPath # callOrId
	| constant # const
	;
	 
eqlStart: expr = expression EOF;
