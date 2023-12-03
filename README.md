# Project for Engeto Academy
- - -
## Struktura projektu
- Soubory s odpovědi ve MarkDown formátu *.md, jež obsahují:
	- Průvodní listinu s popisem kroků
	- Informace ve výstupních datech 
- Soubory s tabulkami ve SQL formátu *.sql

## Zadání projektu
Připravit datové podklady pro analytické oddělení týkající se dostupnosti základních potravin veřejnosti a to s ohledem na průměrné příjmy občanů v určitém časovém období. Kromě toho také vytvořit tabulku s údaji o HDP, GINI koeficientu a populaci dalších evropských států ve stejném období jako primární přehled pro Českou republiku.

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
	Lineární regrese na získaných hodnotách ukázala závislost HDP = 0.203 (Ceny potravin) + 2.576, tedy zvýšením cen potravin dochází ke zvýšení HDP a vice versa. Tato závislost nemusí být úplně pravdivá, přesnější by byla polynomická regrese 2. či 3. stupně nebo získání více dat. 