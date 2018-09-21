# Gjennomgang

library(tidyverse)
library(mlbench)


# Del 1 - Summary statistics, aggregering, filtrering ---------------------

# Laster inn data fra mlbench-pakken
data("PimaIndiansDiabetes2")

# Lag kopi av rådata
df <- as_tibble(PimaIndiansDiabetes2)

# Sjekk at alle kolonner har riktig format
print(df)

# Få summary av dataen ved å bruke summary
summary(df)

# Lag tabeller
table(df$diabetes)

# Endre datatypen til en kolonne
df$diabetes <- as.character(df$diabetes)

# Man kan også konverte flere typer på en gang:
# Via en "condition
df %>%
  mutate_if(is.numeric, as.character)

# Eller ved å spesifisere hvilke kolonner som skal endres
df %>%
  mutate_at(vars(insulin, triceps), as.character)

# Legg til variabler
# Enten med "base R" - metoden
# Logaritmen av insulin
df$logInsulin <- log(df$insulin)

# Faktorvariabler gammel/ung
df$isOld <- if_else(df$age > 60, "yes", "no")
df$isYoung <- if_else(df$age < 26, "yes", "no")

# ...eller med dplyr-metoden...(ofte enklere hvis man vil lage flere var. samtidig)
# Symbolet '%>%' skal leses som "THEN" og brukes til å chaine argumenter sammen
df <- df %>%
  mutate(isOld = if_else(age > 60, "yes", "no"),
         isYoung = if_else(age < 26, "yes", "no"))

# Dersom man skal kombinere flere enn to utfall, bruk case_when (istedenfor flere ifelse inni hverandre!)
df <- df %>%
  mutate(age_group = case_when(
    age < 27 ~ "young",
    age < 60 ~ "okish",
    TRUE ~ "old"
  ))

table(df$age_group)

# Filtrer dataen, beholder her alle eldre enn 60
d <- df %>%
  filter(age > 60)

# Uttrykket over skal dermed leses som: df_old settes først lik df, f_old
# THEN filtrer med age > 60

# Kan kombinere flere argumenter sammen, f.eks select (variabelseleksjon) + filter
df_old_pregnant <- df %>%
  select(age, pregnant, diabetes) %>%
  filter(age > 60 & pregnant > 1) %>%
  arrange(age) %>%
  print()

# Dette gjør at man slipper stygg og "uleselig" kode som under (men samme betydning)
df_old_pregnant <- print(arrange(select(filter(df, age > 60 & pregnant > 1),
                                        c("age", "pregnant", "diabetes"), age)
))

# Group by + Summarize -> Tilsvarende pivot-tabeller i Excel
# Eks: grupper etter diabetes, finn snittalder & ant. pasienter i hver gruppe
df_aggr <- df %>%
  group_by(diabetes) %>%
  summarise(snittAlder = mean(age),
            antallPasienter = n()) %>%
  print()

# Legg til en kolonne som avhenger av summarized kolonner ved å bruke mutate
df_aggr <- df %>%
  group_by(diabetes) %>%
  summarise(snittAlder = mean(age),
            antallPasienter = n()) %>%
  mutate(Total_alder = snittAlder * antallPasienter)

# Lag et aggregert datasett basert på flere summaries
df_aggr <- df %>%
  group_by(diabetes) %>%
  filter(age > 40 & pregnant > 0) %>%
  summarise(medianMass = median(mass, na.rm = T),
            maxMass = max(mass, na.rm = T),
            minMass = min(mass, na.rm = T),
            antallPasienter = n()) %>%
  print()

# OBS! Merk at na.rm (NA-REMOVE) må brukes for å ignorere NA-verdier
# Lag flere summaries på en gang med summarise_if
df %>%
  group_by(diabetes) %>%
  filter(age > 40 & pregnant > 0) %>%
  remove_missing() %>%
  summarise_if(is.numeric, mean) %>%
  print()


# Data visualisering med ggplot -------------------------------------------

# Bygg opp plots med "layers of vizualisation"
# For hvert plott må man definere "aestics" (aes) som bla er x, y-aksen og grupperinger
# Deretter legger man til layers med lines, points, barplots osv med "+"

# Eks: Tomt plot
ggplot(df, aes(x = age))

# Histogram av alder
ggplot(df, aes(x = age)) + 
  geom_histogram(fill = "cornflowerblue", color = "black")

# Density-plot
ggplot(df, aes(x = age)) +
  geom_density(fill = "cornflowerblue") +
  labs(title = "Density plot for age")

# Skill mellom diabetes og ikke-diabetes: merk at fill angis inni aes()!
ggplot(df, aes(x = age, fill = diabetes)) +
  geom_density(alpha = 0.5) +
  labs(title = "Density plot for age")

# Insulin
ggplot(df, aes(x = insulin, fill = diabetes)) +
  geom_density(alpha = 0.5) +
  labs(title = "Density plot for insulin")

# La oss studere sammenhengen mellom alder og antall graviditeter
ggplot(df, aes(x = age, y = pregnant)) +
  geom_point()

# Ikke enkelt å se noen sammenheng - hvordan kan denne visualiseringen forbedres?
# Jitter punktene
ggplot(df, aes(x = age, y = pregnant)) +
  geom_jitter()

# Legg til trend
ggplot(df, aes(x = age, y = pregnant)) +
  geom_jitter() +
  geom_smooth()

# Fjern outliers - kombiner pipeline med ggplot!
df %>%
  filter(age < 80) %>%
  ggplot(aes(x = age, y = pregnant)) +
  geom_jitter(color = "grey", alpha = 0.7) +
  geom_smooth()

# Noen forskjell på de som har og ikke har diabetes?
df %>%
  filter(age < 80) %>%
  ggplot(aes(x = age, y = pregnant, color = diabetes)) +
  geom_jitter(alpha = 0.3) +
  geom_smooth(se = FALSE)

# Dårlig barplot
ggplot(df_aggr, aes(x = diabetes, y = medianMass)) +
  geom_bar(stat = "identity", fill = "cornflowerblue", color = "black") +
  geom_label(aes(label = medianMass), vjust = 0.2)

# Strekplott
ggplot(df, aes(x = diabetes, y = mass)) +
  stat_summary(fun.ymin = min,
               fun.ymax = max,
               fun.y = median)

# Boxplot
ggplot(df, aes(x = diabetes, y = mass)) +
  geom_boxplot(fill = "cornflowerblue")

# Lag flere vinduer med facet_wrap
ggplot(df, aes(x = diabetes, y = mass)) +
  geom_boxplot(fill = "cornflowerblue") +
  facet_wrap(~age_group)

# Introduksjon til modellering --------------------------------------------

### 1 - Vanlig regresjon (kontinuerlig utfallsvariabel)

# Lag enkel regresjon ved bruk av "lm"
model <- lm(pregnant ~ age, data = df)
summary(model)

# Lagre prediksjon med "predict"
df$prediction <- predict(model)

# Plott prediksjon
ggplot(df, aes(x = age, y = pregnant)) +
  geom_point(alpha = 0.5, color = "grey") +
  geom_line(aes(y = prediction, x = age), color = "blue")

# Alternativt: gjør det direkte
ggplot(df, aes(x = age, y = pregnant)) +
  geom_point(alpha = 0.5, color = "grey") +
  geom_smooth(method = "lm", color = "blue")

# Modellen er åpenbart ingen god fit med kun alder - forsøk å legge til polynom
model <- lm(pregnant ~ poly(age, 2), data = df)
summary(model)

# Plot ny model
ggplot(df, aes(x = age, y = pregnant)) +
  geom_jitter(alpha = 0.5) +
  geom_smooth(method = "lm", formula = y ~ poly(x, 2))

# Merk at hvis man legger til flere blir regresjonen voldsomt overtilpasset!
ggplot(df, aes(x = age, y = pregnant)) +
  geom_jitter(alpha = 0.5) +
  geom_smooth(method = "lm", formula = y ~ poly(x, 5))

# For å legge til flere variabler, pluss sammen
model <- lm(pregnant ~ age + diabetes + insulin + mass, data = df)
summary(model)

# For å lagre modellens koeffisienter, bruk broom
library(broom)
model_summary <- tidy(model)

### 2 - Logistisk regresjon, binær utfallsvariabel

# Lag utfallsvariabel
df$harDiabetes <- ifelse(df$diabetes == "pos", 1, 0)

# Lag glm-modell
model <- glm(harDiabetes ~ insulin, data = df, family = binomial)
summary(model)

# Lag prediksjoner
df$diabetes_prediction <- predict(model, type = "response", newdata = df)

# Plot resultat
ggplot(df, aes(x = insulin, y = harDiabetes)) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "glm", method.args = list(family = "binomial"))

# Sjekk modellresultat
library(yardstick)

df %>%
  mutate(diabetes = as.factor(diabetes)) %>%
  roc_auc(diabetes, diabetes_prediction)

# Jo høyere ROC - jo bedre er modellen til å skille de som har og ikke har diabetes
