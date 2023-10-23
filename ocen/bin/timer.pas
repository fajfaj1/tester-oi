{$M 8192,0,0}
program timer;
uses dos;

procedure Help;
begin
  Writeln('Sposob uzycia:');
  Writeln('  timer.exe plik_wykonywalny');
  halt(1);
end;

function Time2Long(h,m,s,s100:longint):longint;
begin
  Time2Long:=s100+s*100+m*100*60+h*100*60*60;
end;

var
  h,m,s,s100:word;
  t1:longint;
  t2:longint;

  res:integer;
  i:integer;
  cmd:string;
  f:text;
begin
  if ParamCount<1 then help;

  cmd:='';
  for i:=2 to ParamCount do begin
    if (i>2) then cmd:=cmd+' ';
    cmd:=cmd+ParamStr(i);
  end;

  GetTime(h,m,s,s100);
  t1:=Time2Long(h,m,s,s100);

  {uruchomienie programu}
  SwapVectors;
  if paramcount=1 then exec(paramstr(1),'')
  else exec(paramstr(1),cmd);
{  Exec(cmd, '');             }
  SwapVectors;

  res:=0;
  if (DosError<>0) then res:=DosError
  else res:=DosExitCode;

  GetTime(h,m,s,s100);
  t2:=Time2Long(h,m,s,s100);
  if (t2<t1) then t2:=t2+Time2Long(24,0,0,0);

  {wypisanie czasu wykonania}
  t1:=t2-t1;
  t2:=t1 mod 100;
  
  Assign(f,'timer.out');
  rewrite(f);
  Write(f,'Czas: ');
  Write(f,t1 div 100);
  Write(f,'.');
  if (t2<10) then Write(f,'0');
  Write(f,t2);
  Write(f,'s ');
  close(f);

  halt(res);
end.