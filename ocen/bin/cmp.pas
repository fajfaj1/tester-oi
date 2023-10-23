{
   cmp.pas, wersja 1.1
   -------------------
    wersja znacznie liberalniejsza, teraz ignoruje biale znaki
    w obrebie jednej linii, pliki moga sie roznic dowolna liczba
    bialych znakow na koncach plikow
}
{paramstr(1) - plik wygenerowany przez uzytkownika
 paramstr(2) - prawidlowa odpowiedz}
const
  white  = [#0,#9,#13,' '];
  white2 = [#0,#9,#10,#13,' '];
  max_token_len = 100;
var
  file1,file2 : string;
  f1,f2       : text;
  t1,t2       : string;
  line_no     : longint;

  function read_token(var f:text;to_eol:boolean):string;
  var
    tmp : string;
    ch  : char;
    i   : integer;
  begin
    ch:=#0;
    if (to_eol) then
      while (not eof(f)) and (ch in white) do read(f,ch)
    else
      while (not eof(f)) and (ch in white2) do read(f,ch);

    if (not to_eol) and (ch in white2) then read_token:=#0
    else if (ch in white) then read_token:=#0
    else begin
      if (ch<>#10) then begin {jesli to nie jest przejscie do nastepnej linii}
        i:=0;
        tmp:='';
        while (not (ch in white)) do begin      
          tmp:=tmp+ch;
          i:=i+1;
          if (eoln(f)) then break;
	  if (eof(f)) then break;
          if (i=max_token_len) then break;
          read(f,ch);
        end;
	read_token:=tmp;
      end else read_token:=ch;
    end;
  end;

  procedure blad(tt1,tt2:string);
  begin
    if (tt1=#0) then tt1:='EOF';
    if (tt1=#10) then tt1:='EOLN';
    if (tt2=#0) then tt2:='EOF';
    if (tt2=#10) then tt2:='EOLN';

    Writeln('ZLE! Linia=',line_no,', oczekiwano="',tt1,'", a wczytano="',tt2,'"');
    close(f1);
    close(f2);
    halt(1);
  end;

  procedure blad2(msg:string);
  begin
    Writeln('BLAD! ',msg);
    halt(2);
  end;

begin
  file1:=paramstr(1);
  file2:=paramstr(2);
  assign(f1,file1);
  {$I-}
  reset(f1);
  {$I+}
  if IORESULT<>0 then blad2('Nie mozna otworzyc pliku: '+file1);
  assign(f2,file2);
  {$I-}
  reset(f2);
  {$I+}
  if IORESULT<>0 then blad2('Nie mozna otworzyc pliku: '+file2);

  line_no:=1;
  while ((not eof(f1)) and (not eof(f2))) do
  begin
    t1:=read_token(f1,true);
    t2:=read_token(f2,true);
{    Writeln('t1=',t1,' t2=',t2); }
    if (t1=#0) and (t2=#10) then t2:=read_token(f2,false);
    if (t1=#10) and (t2=#0) then t1:=read_token(f1,false);
    if (t1<>t2) then blad(t2,t1);
    if (t1=#10) then inc(line_no);
  end;

  if (eof(f1)) and (not eof(f2)) then begin
     t2:=read_token(f2,false);
     if (t2<>#0) then blad(t2,#0);
  end else if (not eof(f1)) and (eof(f2)) then begin
     t1:=read_token(f1,false);
     if (t1<>#0) then blad(#0,t1);
  end;

  close(f1);
  close(f2);
  Writeln('OK');
  halt(0);
end.