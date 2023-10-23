@echo off
if "%1" == "" goto help

set C=
set I=
set T=
call cfg.bat %1 %2

if "%I%" == "" goto unk
if "%1" == "_chk_" goto check
if "%1" == "_gen_" goto generate
if "%2" == "gen" goto gen
goto test

:unk
echo.
echo %T% - NIEZNANE ZADANIE!
echo.
goto end


:help
echo.
echo Sposob uzycia:
echo   ocen.bat id_zadania [ nr_testu ]
echo.
goto end

:generate
set I=%2
set N=%3
set N=%3
if not exist %I%.exe goto err_exe
if not exist %DIR%IN\%I%%N%.in goto err_in
if exist %I%.in  del %I%.in
if exist %I%.out del %I%.out
copy %DIR%IN\%I%%N%.in %I%.in > nul
break on
%DIR%BIN\timer.exe %I%.exe
echo.
if errorlevel 1 goto err_3
if not exist %I%.out goto err_2
copy %I%.out %DIR%OUT\%I%%N%.out > nul
if exist %I%.in del %I%.in
if exist %I%.out del %I%.out
goto end

:check
set I=%2
set N=%3
set RES=

rem Sprawdzenie czy sa wszystkie potrzebne pliki
if not exist %I%.exe goto err_exe
if not exist %DIR%IN\%I%%N%.in goto err_in
if not exist %DIR%OUT\%I%%N%.out goto err_out

rem Czy jes sprawdzaczka
if exist %DIR%%C% goto chk_ok
:chk_no
echo *** BRAK PROGRAMU SPRAWDZAJACEGO: %C%!!! (uzywam: bin\cmp.exe) ***
set C=BIN\cmp.exe
:chk_ok

rem Kasowanie niepotrzebnych plikow in/out
if exist %I%.out del %I%.out

if exist %DIR%BIN\res.exe %DIR%BIN\res.exe
break on
if "%W32%"=="1" goto w32
%DIR%BIN\timer.exe %I%.exe < %DIR%IN\%I%%N%.in > %I%.out
goto run_ok
:w32
%DIR%BIN\timer.exe %DIR%BIN\start.exe /w %I%.exe < %DIR%IN\%I%%N%.in > %I%.out
:run_ok
type timer.out
if exist timer.out del timer.out
if errorlevel 1 goto err_3
if not exist %I%.out goto err_2

if exist %DIR%BIN\res.exe %DIR%BIN\res.exe

if "%V%"=="1" goto v
rem Interesuje na tylko wynik
%DIR%%C% %I%.out %DIR%OUT\%I%%N%.out %I%.in  > nul
goto chk
:v
rem Pozwalamy sprawdzaczce wypisywac cos na ekran
%DIR%%C% %I%.out %DIR%OUT\%I%%N%.out %I%.in
:chk
if errorlevel 1 goto err_1

:err_0
set RES=OK
set R_OK=1
if exist %I%.in  del %I%.in
if exist %I%.out del %I%.out
goto check_end
:err_1
set RES=ZLA ODPOWIEDZ
set R_ZLE=1
goto check_end
:err_2
set RES=BRAK PLIKU %I%.out
set R_BRAK=1
goto check_end
:err_3
set RES=RUNTIME ERROR
set R_RUNERR=1
goto check_end

:check_end
echo TEST NR %N%, WYNIK=%RES%
if exist %DIR%BIN\res.exe %DIR%BIN\res.exe

goto end

:test
set R_ZLE=
set R_BRAK=
set R_RUNERR=
if not exist "%I%.exe" goto err_exe
if "%2" == "" goto test_all
set V=1
call ocen.bat _chk_ %I% %2
if "%R_ZLE%"=="1" goto rpt
if "%R_BRAK%"=="1" goto rpt
if "%R_RUNERR%"=="1" goto rpt
goto end

:gen
shift
if not exist "%I%.exe" goto err_exe
if "%2" == "" goto gen_all
call ocen.bat _gen_ %I% %2
goto end

:test_all
set R_OK=
set R_ZLE=
set R_BRAK=
set R_RUNERR=
set V=0

FOR %%i IN (%T%) DO call ocen.bat _chk_ %I% %%i

if "%R_ZLE%"=="1" goto rpt
if "%R_BRAK%"=="1" goto rpt
if "%R_RUNERR%"=="1" goto rpt
if "%R_OK%"=="1" goto rpt
goto end

:gen_all
FOR %%i IN (%T%) DO call ocen.bat _gen_ %I% %%i
goto end

:rpt
call rpt.bat
goto end

rem
rem Komunikaty o bledach
rem

:err_exe
echo * Brak pliku %I%.exe *
goto end

:err_in
echo * TEST NR %N%: Brak pliku IN\%I%%N%.in *
goto end

:err_out
echo * TEST NR %N%: Brak pliku OUT\%I%%N%.out *
goto end

:end