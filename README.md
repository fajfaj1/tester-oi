# Tester OI
Szybko i wygodnie przetestuje swoje rozwiązania do olimpiady informatycznej w pythonie.

## Użycie
1. Sklonuj to repozytorium, lub pobierz i rozpakuj [archiwum](https://github.com/fajfaj1/tester-oi/archive/refs/heads/main.zip).
2. W folderze 'rozwiazania' umieść swoje rozwiązania (nazwy plików powinny być takie jak w kryteriach zadani).
3. Uruchom skrypt `test.py` (testowany na wersji Pythona 3.11.0)
> ```bash
> py test.py --task [NAZWA ZADANIA] --test [NUMER TESTU/all]
> ```

Wyniki testów powinny zostać wyświetlone w następujący sposób:
![](./showcase.png)

### Zużycie pamięci
Przy każdym teście wyświetli się także zużycie pamięci przez twoje rozwiązanie (w MegaBajtach). Jest on kalkulowany przy użyciu biblioteki [psutil](https://pypi.org/project/psutil/) i nie ręczę za jego poprawność. 

### Konfiguracja
W pliku `config.py` możesz doprecyzować komendę startującą skrypt rozwiązani (domyślnie `py`)

## Błędy i Propozycje
Jeśli natrafisz na jakiś błąd, lub przyjdzie ci do głowy jakieś ulepszenie, zachęcam do pisania w [Issues](https://github.com/fajfaj1/tester-oi/issues) i wysyłania swoich [Pull requests](https://github.com/fajfaj1/tester-oi/pulls).