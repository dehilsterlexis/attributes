infile := DATASET([
	{'5619994581'},{'15619994581'},
	{'(561) 999-4581'},{'(561)999-4581'},
	{'561-999-4581'},{'561 999 4581'},
	{'561.999.4581'},{'561/999/4581'},
	{'561 999-4581'},{'9994581'},
	{'999-4581'}],
	{STRING20 rawnumber});

PATTERN numbers := PATTERN('[0-9]')+;
PATTERN alpha := PATTERN('[A-Za-z]')+;
PATTERN ws := [' ','\t']*;
PATTERN sepchar := PATTERN('[-./ ]');
PATTERN Seperator := ws sepchar ws;

// Area Code
PATTERN OpenParen := ['[','(','{','<'];
PATTERN CloseParen := [']',')','}','>'];
PATTERN FrontDigit := ['1', '0'] OPT(Seperator);
PATTERN areacode := OPT(FrontDigit) OPT(OpenParen) numbers length(3) OPT(CloseParen

// Last Seven digits
PATTERN exchange := numbers length(3);
PATTERN lastfour := numbers length(4);
PATTERN seven := exchange OPT(Seperator) lastfour;

// Extension
PATTERN extension := ws alpha ws numbers;

// Phone Number
PATTERN phonenumber := OPT(areacode) OPT(Seperator) seven opt(extension) ws;

layout_phone_append := RECORD
	infile;
	STRING10 clean_phone := MAP(NOT MATCHED(phonenumber) => '',
	NOT MATCHED(areacode) => '000' + MATCHTEXT(exchange) + MATCHTEXT(lastfour),
	MATCHTEXT(areacode/numbers) + MATCHTEXT(exchange) + MATCHTEXT(lastfour));
END;

outfile := PARSE(infile, rawnumber, phonenumber, layout_phone_append,FIRST, NOT MATCHED, WHOLE);

OUTPUT(outfile);