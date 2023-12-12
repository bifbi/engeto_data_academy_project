# Project for Engeto Academy
- - -
## Struktura projektu
- Soubor s odpovědí ve formátu MarkDown *.md
- Soubory s query ve formátu SQL *.sql

## Zadání projektu
Připravit datové podklady pro analytické oddělení týkající se dostupnosti základních potravin veřejnosti a to s ohledem na průměrné příjmy občanů v určitém časovém období. Kromě toho také vytvořit tabulku s údaji o HDP, GINI koeficientu a populaci dalších evropských států ve stejném období jako primární přehled pro Českou republiku.

## Použité datové sady
**Primární tabulky:**

czechia_payroll – Informace o mzdách v různých odvětvích za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.
czechia_payroll_calculation – Číselník kalkulací v tabulce mezd.
czechia_payroll_industry_branch – Číselník odvětví v tabulce mezd.
czechia_payroll_unit – Číselník jednotek hodnot v tabulce mezd.
czechia_payroll_value_type – Číselník typů hodnot v tabulce mezd.
czechia_price – Informace o cenách vybraných potravin za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.
czechia_price_category – Číselník kategorií potravin, které se vyskytují v našem přehledu.

**Číselníky sdílených informací o ČR:**

czechia_region – Číselník krajů České republiky dle normy CZ-NUTS 2.
czechia_district – Číselník okresů České republiky dle normy LAU.

**Dodatečné tabulky:**

countries - Všemožné informace o zemích na světě, například hlavní město, měna, národní jídlo nebo průměrná výška populace.
economies - HDP, GINI, daňová zátěž, atd. pro daný stát a rok.

## Zpracování projektu
Projekt je zpracován formou přímých dotazů z datových sad. U každého úkolu jsem popsal mezidotazy, které vedly postupně k finálnímu dotazu, díky němuž jsem mohl zodpovědět na výzkumnou otázku.
V zadání je sice požadováno, aby byla vytvořena primární a sekundární tabulka, ze které by jednotlivé SQL skripty čerpaly data, nicméně tento mezikrok by odfiltroval značnou část dat hned na počátku a ovlivnil by tak i úkoly, u kterých to není požadováno (sjednocení na totožné porovnatelné období), naopak je u nich výhodnější mít širší datovou bázi pro analýzu. Používal jsem tedy subqueries, díky čemuž jsem mohl filtrovat data před JOIN operací, vyvarovat duplicitním sloupcům a zlepšit čitelnost kódu kvůli následnému debuggingu.


## Výzkumné otázky
1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?

## Odpovědi na výzkumné otázky
1. Bohužel mzdy nerostou v průběhu let ve většině odvětvích, a to s výjimkou:
	- Doprava a skladování
	- Administrativní a podpůrné činnosti
	- Zdravotní a sociální péče
	- Ostatních činností
2. Za první srovnatelné období (2006) bylo možné si koupit 1403 litrů polotučného mléka a 1257 kg chleba.
	Za poslední srovnatelné období (2018) bylo možné si koupit 1611 litrů polotučného mléka a 1317 kg chleba.
    V roce 2018 bylo tak možné koupit si více mléka i chleba za průměrný plat, což je způsobené nárůstem průměrného platu o 57,53% oproti roce 2016.
3. Průměrně nejpomaleji zdražují banány žluté, a to o 0,81 % za rok. Zajímavá situace nastává u cukru krystalového, který dokonce zlevňuje, a to průměrně o 1,92 % za rok.
4. V žádném roce nedošlo ke výraznému zvýšení cen potravin vůči růstu mezd. Největší rozdíl byl dosažen v roce 2013, kdy ceny potravin se zvýšily o 5.55 % a mzdy klesly o 1.56 %, rozdíl byl tedy 7.11 %.
5. Výška HDP nemá vliv na vývoj výše mezd, avšak má určitý vliv na vývoj cen potravin. Samotné hodnoty vypadají nahodile, a je tak těžké říci zda má HDP nějaký vliv. Proto jsem získané hodnoty vložil do Excelu a vizualizoval data na grafu.
	Lineární regrese na získaných hodnotách ukázala závislost růst_HDP = 0.7411 (růst_cen_potravin) + 1.3261, tedy růstem cen potravin dochází ke vzrůstu HDP a vice versa. 
    Stejná situace nastává u růstu mezd, kde rovnice linární regrese je růst_HDP = 0.4311*(růst_mezd) + 0.4547. Závislost je tedy poloviční oproti závislosti růst_HDP/růst_cen_potravin.

