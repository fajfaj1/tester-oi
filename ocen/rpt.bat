@echo off
:rpt_err
if "%R_RUNERR%"=="" goto rpt_e1
echo.
echo Jeden z testow zakonczyl sie komunikatem RUNTIME ERROR:
echo Sprawdz czy:
echo 1. W przypadku C, w funkcji main zwracasz wartosc 0
echo 2. Prawidlowo wczytujesz dane wejsciowe (ze standardowego wejscia)
echo 3. Prawidlowo zapisujesz dane wyjsciowe (na standardowe wyjscie)
echo 4. W kodzie programu nie ma zadnych bledow powodujacych blad wykonania
:rpt_e1
if "%R_BRAK%"=="" goto rpt_e2
echo.
echo Jeden z testow zakonczyl sie komunikatem BRAK PLIKU OUT:
echo Sprawdz czy:
echo 1. Prawidlowo wczytujesz dane wejsciowe (ze standardowego wejscia)
echo 2. Prawidlowo zapisujesz dane wyjsciowe (na standardowe wyjscie)
:rpt_e2
if "%R_ZLE%"=="" goto rpt_ok
echo.
echo Jeden z testow zakonczyl sie komunikatem ZLA ODPOWIEDZ:
echo Sprawdz czy:
echo 1. Program udziela prawidlowej odpowiedzi
echo 2. Plik wyjsciowy ma prawidlowy format (np. nie zawiera zadnych upiekszen)
goto end

:rpt_ok
if "%R_OK%"=="" goto end
echo.
echo Gratulacje. Twoje rozwiazanie dobrze rozwiazalo wszystkie testy z zestawu.
echo Pamietaj jednak, ze ostatecznie bedzie oceniane na zupelnie innym
echo zestawie testow.
goto end

:end