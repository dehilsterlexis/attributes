Layout_Actors_Raw := RECORD
	STRING120 IMDB_Actor_Desc;
END;

File_Actors := DATASET([
	{'A.V., Subba Rao Chenchu Lakshmi (1958/I) <10>'},
	{' Jayabheri (1959) <17>'},
	{' Madalasa (1948) <3>'},
	{' Mangalya Balam (1958) <12>'},
	{' Mohini Bhasmasura (1938) <3>'},
	{' Palletoori Pilla (1950) [Kampanna Dora] <4>'},
	{' Peddamanushulu (1954) <6>'},
	{' Sarangadhara (1957) <12>'},
	{' Sri Seetha Rama Kalyanam (1961) <12>'},
	{' Sri Venkateswara Mahatmyam (1960) [Akasa Raju] <5>'},
	{' Vara Vikrayam (1939) [Judge] <12>'},
	{' Vindhyarani (1948) <7>'},
	{''},
	{'Aa, Brynjar Adjo solidaritet (1985) [Ponker] <40>'},
	{''},
	{'Aabel, Andreas Bor Borson Jr. (1938) [O.G. Hansen] <9>'},
	{' Jeppe pa bjerget (1933) [En skomakerlaerling]'},
	{' Kampen om tungtvannet (1948) <8>'},
	{' Prinsessen som ingen kunne maqlbinde (1932) [Espen Askeladd] <3>'},
	{' Spokelse forelsker seg, Et (1946) [Et spokelse] <6>'},
	{''},
	{'Aabel, Hauk (I) Alexander den store (1917) [Alexander Nyberg]'},
	{' Du har lovet mig en kone! (1935) [Professoren] <6>'},
	{' Glad gutt, En (1932) [Ola Nordistua] <1>'},
	{' Jeppe pa bjerget (1933) [Jeppe] <1>'},
	{' Morderen uten ansikt (1936)'},
	{' Store barnedapen, Den (1931) [Evensen, kirketjener] <5>'},
	{' Troll-Elgen (1927) [Piper, direktor] <9>'},
	{' Ungen (1938) [Krestoffer] <8>'},
	{' Valfangare (1939) [Jensen Sr.] <4>'},
	{''},
	{'Aabel, Per (I) Brudebuketten (1953) [Hoyland jr.] <3>'},
	{' Cafajestes, Os (1962)'},
	{' Farlige leken, Den (1942) [Fredrik Holm, doktor]'},
	{' Herre med bart, En (1942) [Ole Grong, advokat] <1>'},
	{' Kjaere Maren (1976) [Doktor]'},
	{' Kjaerlighet og vennskap (1941) [Anton Schack] <3>'},
	{' Ombyte fornojer (1939) [Gregor Ivanow] <2>'},
	{' Portrettet (1954) [Per Haug, provisor] <1>'}],
Layout_Actors_Raw);

//Basic patterns:
PATTERN arb := PATTERN('[-!.,\t a-zA-Z0-9]')+;

//all alphanumeric & certain special characters
PATTERN ws := [' ','\t']+; //word separators (space & tab)
PATTERN number := PATTERN('[0-9]')+; //numbers

//extended patterns:
PATTERN age := '(' number OPT('/I') ')';

//movie year -- OPT('/I') required for first rec
PATTERN role := '[' arb ']'; //character played
PATTERN m_rank := '<' number '>'; //credit appearance number
PATTERN actor := arb OPT(ws '(I)' ws);

//actor's name -- OPT(ws '(I)' ws)
// required for last two actors
//extended pattern to parse the actual text:
PATTERN line := actor '\t' arb ws OPT(age) ws OPT(role) ws OPT(m_rank) ws;

//output record structure:
NLP_layout_actor_movie := RECORD
	STRING30 actor_name := Std.Str.filterout(MATCHTEXT(actor),'\t');
	STRING50 movie_name := MATCHTEXT(arb[2]);
	UNSIGNED2 movie_year := (UNSIGNED)MATCHTEXT(age/number);
	STRING20 movie_role := MATCHTEXT(role/arb);
	UNSIGNED1 cast_rank := (UNSIGNED)MATCHTEXT(m_rank/number);
END;

//and the actual parsing operation
Actor_Movie_Init := PARSE(File_Actors,
						IMDB_Actor_Desc,
						line,
						NLP_layout_actor_movie,WHOLE,FIRST);

// then iterate to propagate actor name in each record
NLP_layout_actor_movie IterNames(NLP_layout_actor_movie L,
																	NLP_layout_actor_movie R) := TRANSFORM
	SELF.actor_name := IF(R.actor_Name='',L.actor_Name,R.actor_name);
	SELF:= R;
END;

NLP_Actor_Movie := ITERATE(Actor_Movie_Init,IterNames(LEFT,RIGHT));

// and output the result set
OUTPUT(NLP_Actor_Movie);