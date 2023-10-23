@echo off

if "%1"=="_chk_" shift

rem --- Konfiguracja ocen.bat ---
rem W przypadku opracowania wlasnego zestawu testow nalezy zmienic
rem zawartosc zmiennej TESTS a testy zappiowac do kataloguw IN\, OUT\
rem nazwy testow powinny analogiczne do przykladowych

if "%1"=="bud" goto bud
if "%1"=="BUD" goto bud

if "%1"=="cza" goto cza
if "%1"=="CZA" goto cza

if "%1"=="prz" goto prz
if "%1"=="PRZ" goto prz

if "%1"=="sat" goto sat
if "%1"=="SAT" goto sat

if "%1"=="zap" goto zap
if "%1"=="ZAP" goto zap

set T=%1
goto end

rem Zadanie "Budowa lotniska"
:bud
set I=bud
set T=0 1ocen 2ocen 3ocen 4ocen 5ocen
set C=bin\cmp.exe
goto end

rem Zadanie "CzatBBB"
:cza
set I=cza
set T=0 1ocen 2ocen 3ocen
set C=bin\cmp.exe
goto end

rem Zadanie "Przyciski"
:prz
set I=prz
set T=0 1ocen 2ocen 3ocen
set C=bin\cmp.exe
goto end

rem Zadanie "Satelity"
:sat
set I=sat
set T=0 1ocen 2ocen 3ocen
set C=bin\cmp.exe
goto end

rem Zadanie "Zapobiegliwy student"
:zap
set I=zap
set T=0 1ocen 2ocen
set C=bin\cmp.exe
goto end

rem --- Koniec konfiguracji

:end

if "%C%"=="" goto def_chk
goto new_chk
:def_chk
set C=bin\cmp.exe
:new_chk

:real_end
