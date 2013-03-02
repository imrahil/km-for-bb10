## Klient serwisu Kontomierz dla BlackBerry 10  
Copyright (c) 2013 pauluZ

*Ikonki menusow* - Subway Icons Set - [http://subway.pixle.pl/](http://subway.pixle.pl/)

*Ikonka aplikacji* - [http://www.iconfinder.com/icondetails/49718](http://www.iconfinder.com/icondetails/49718/256/money_piggybank_pink_icon)

*klasa DatePicker* - [http://supportforums.blackberry.com/t5/Adobe-AIR-Development/BB10-Date-Picker-class/m-p/1996999#M40295](http://supportforums.blackberry.com/t5/Adobe-AIR-Development/BB10-Date-Picker-class/m-p/1996999#M40295)

Wersje:
* 0.1.5 - poprawki formularza dodawania transakcji - ulepszona lista kategorii
* 0.1.4 - poprawiony formularz dodawania/edycji transakcji
* 0.1.3 - poprawione odswiezanie listy transakcji w portfelu
* 0.1.2 - mozliwosc uzywania aplikacji w trybie demo. Poprawione wyswietlanie listy kategorii.
* 0.1.1 - dodana mozliwosc usuwania transakcji
* 0.1.0 - dodana mozliwosc wprowadzania nowych wydatkow
* 0.0.4 - dodane wyswietlanie listy kategorii
* 0.0.3 - dodane wczytywanie transakcji dla portfela
* 0.0.2 - logowanie, zapamietywanie sesji, wczytywanie listy kont, wczytywanie transakcji dla wybranego konta
* 0.0.1 - init

>TODO:
>
* ~~edycja transakcji~~
* ~~wybor kategorii przy dodawaniu i edycji transakcji~~
* ~~obsluga przychodow (sa juz wydatki)~~
* ~~waluty ?~~
* dodac zapis danych lokalnie - tak zeby nie wymagane bylo polaczenie z internetem (przy braku synchronizacji -> zablokowac edycje i dodawanie)
* przy pierwszym starcie odczyt z sieci lub przy jej braku z danych lokalnych (sqlite?)
* przy kolejnych odczytach brac dane z sqlite, a z sieci dopiero na akcje "Odswiez" wywolana przez uzytkownika
* wykresy!
* wyszukiwanie po kategorii i dacie prosto ze szczegolow wybranej transakcji
* rozszerzyc TransactionListCellRenderer tak aby wyswietlal kwote i date

Scenariusz w przypadku braku sieci:
1. pierwsze uruchomienie
- sprawdzamy czy jest siec nim wyslemy login/haslo
    * jesli nie ma sieci to blokada programu
    * blokada trybu demo jesli nie ma sieci
- czyszczenie danych przy wylogowaniu

2. zapamietany login
    * jest siec
        * normalne logowanie 
        * sync danych jesli byly zmiany w trybie offline
        * pobranie swiezych danych (kategorie, waluty)
        * zapis danych do SQLite na wypadek przejscia w tryb offline
            * zapis do kolejki jesli nieudana proba zapisu/edycji
            * proba wyslania danych z kolejki przy nastepnym wywolaniu API
    * brak sieci - proba pobrania danych z SQLite
        * pobranie jesli byly wczesniej zapisane 
        * blokada jesli brak danych
        
        * zapis zmian do SQLite
        * sync jesli pojawi sie dostep do sieci
        