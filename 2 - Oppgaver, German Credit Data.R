#install.packages("tidyverse")

library(tidyverse)

# Last inn datasettet (se 00 - Lag datasett)
load("germancredit.rds")

# 1 - Oppgaver om databehandling ----------------------------------------

# Oppgave 1.1:
# a) Lag en kopi av datasettet df og gi det et valgfritt navn 
# b) Velg variabelen utenlandsk ved bruk av select
# c) Velg utenlandsk og KjonnSivilstatus samtidig, ved bruk av select

# Oppgave 1.2:
# a) Lag en variabel som er TRUE hvis utenlandsk = 1 og FALSE ellers (bruk mutate i kombinasjon med if_else)

# Oppgave 1.3:
# a) Finn antallet kunder som er kredittverdig ved å bruke filter
# b) Finn antallet kunder som er kredittverdig ved å bruke  group_by og summarise 

# Oppgave 1.4: 
# a) Identifiser de 4 sivilstatusene som eksisterer i datasettet (bruk table)
# b) Lag en variabel "sivilstatus" som enten er "singel" eller "ikke singel", basert på a)
# c) Lag en variabel som splitter saldo opp i tre grupper:  < 1000, 1000-2000, og 2000+
    # Bruk case_when

# Bonus 
# a) Finn gjennomsnittlig saldo og alder for alle yrker. Bruk summarise med mean som argument 
# b) Samme som a), men ta kun med de som er utenlandsk


# 2 - Oppgaver om visualisering -------------------------------------------

# Oppgave 2.1:
# a) Lag et histogram for alder. Bruk "geom_histogram"
# b) Som i a), men sett bins = 20 i histogrammet
# b) Erstatt "geom_histogram" med "geom_freqpoly" fra oppgave b)
# d) Lag et density-plot av alder, men fargelegg de som er kredittverdig og 
# ikke kredittverdig i forskjellig farge.


# Oppgave 2.2:
# a) Illustrer sammenhengen mellom saldo og alder. 
# b) Samme som over, men lag egne plots for alle yrker. Bruk facet_wrap!

# Oppgave 2.3
# a) Illustrer sammenhengen mellom saldo og lengde på kreditt
# b) Fargelegg observasjoner som er kredittverdig og ikke kredittverdig i forskjellig farge.


# Oppgave 2.4:
# Illustrer sammenhengen mellom kredittverdighet og yrke. 


# 3 - Oppgaver om modellering ---------------------------------------------

# Oppgave 3.1:
# Lag en modell der Saldo forklares ved hjelp av øvrige forklaringsvariabler. Bruk lm.
# a) Se hvor høy R-squared dere kan oppnå
# b) Lagre prediksjonene og sammenligne med observert saldo. Plott mot hverandre. 

# Oppgave 3.2. 
# Lag en modell der kredittverdighet forklares ved hjelp av øvrige forklaringsvariabler. Bruk glm. 
# Se hvor høy ROC dere kan oppnå

