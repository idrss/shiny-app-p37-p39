# ---- LIBRAIRIES ----
library(shiny)
library(bs4Dash)
library(tidyverse)
library(DT)
library(shinyWidgets)
library(openxlsx)
library(plotly)
library(shinyjs)
library(digest)

# ---- UTILISATEURS ----
users_file <- "users.rds"
if (file.exists(users_file)) {
  users <- readRDS(users_file)
} else {
  users <- data.frame(
    user = "admin",
    password = digest("admin123", algo = "sha256"),
    role = "admin",
    stringsAsFactors = FALSE
  )
  saveRDS(users, users_file)
}

# ---- DONNEES TABLEAU COMPLET A1-D34 ----
data_tableau <- tibble::tribble(
  ~Libelle, ~Famille, ~Q1, ~Med, ~Q3,
  "A1- Nombre de logements et équivalents logements gérés", "OLS", 1855, 4821, 8509,
  "A1- Nombre de logements et équivalents logements gérés", "OLS+", 14078, 18230, 27632,
  "A1- Nombre de logements et équivalents logements gérés", "SAHLM", 4873, 9126, 17390,
  "A1- Nombre de logements et équivalents logements gérés", "OPH", 4809, 9284, 15461,
  "A1- Nombre de logements et équivalents logements gérés", "SEM", 739, 2224, 7553,
  "A1- Nombre de logements et équivalents logements gérés", "COOP", 211, 1726, 4345,
  "A1- Nombre de logements et équivalents logements gérés", "Ensemble", 2626, 6780, 13299,
  
  "D9- Loyer moyen des logements familiaux gérés", "OLS", 3838.1, 4255.7, 4732.5,
  "D9- Loyer moyen des logements familiaux gérés", "OLS+", 4005.0, 4322.3, 4668.9,
  "D9- Loyer moyen des logements familiaux gérés", "SAHLM", 4249.5, 4505.7, 4753.8,
  "D9- Loyer moyen des logements familiaux gérés", "OPH", 3667.5, 3863.5, 4162.1,
  "D9- Loyer moyen des logements familiaux gérés", "SEM", 4182.5, 4645.2, 5254.7,
  "D9- Loyer moyen des logements familiaux gérés", "COOP", 4234.7, 4688.0, 5436.6,
  "D9- Loyer moyen des logements familiaux gérés", "Ensemble", 3861.7, 4271.5, 4713.6,
  
  "D10- Produits financiers globaux par logement géré", "OLS", 74.0, 122.8, 187.6,
  "D10- Produits financiers globaux par logement géré", "OLS+", 71.8, 106.9, 170.0,
  "D10- Produits financiers globaux par logement géré", "SAHLM", 74.1, 123.7, 180.9,
  "D10- Produits financiers globaux par logement géré", "OPH", 71.8, 108.2, 149.6,
  "D10- Produits financiers globaux par logement géré", "SEM", 55.0, 103.5, 221.3,
  "D10- Produits financiers globaux par logement géré", "COOP", 124.3, 232.1, 591.1,
  "D10- Produits financiers globaux par logement géré", "Ensemble", 73.0, 116.6, 184.2,
  
  "D11- Taux de vacance (%)", "OLS", 1.7, 3.2, 5.4,
  "D11- Taux de vacance (%)", "OLS+", 2.8, 3.9, 5.3,
  "D11- Taux de vacance (%)", "SAHLM", 1.9, 3.2, 4.7,
  "D11- Taux de vacance (%)", "OPH", 2.7, 4.4, 6.5,
  "D11- Taux de vacance (%)", "SEM", 1.4, 3.0, 5.2,
  "D11- Taux de vacance (%)", "COOP", 0.8, 1.9, 4.9,
  "D11- Taux de vacance (%)", "Ensemble", 2.0, 3.4, 5.4,
  
  "D31- Taux de recouvrement (%)", "OLS", 97.6, 98.3, 99.0,
  "D31- Taux de recouvrement (%)", "OLS+", 97.4, 98.1, 98.5,
  "D31- Taux de recouvrement (%)", "SAHLM", 97.6, 98.2, 98.9,
  "D31- Taux de recouvrement (%)", "OPH", 97.7, 98.3, 98.7,
  "D31- Taux de recouvrement (%)", "SEM", 96.8, 98.1, 98.9,
  "D31- Taux de recouvrement (%)", "COOP", 96.9, 98.5, 99.1,
  "D31- Taux de recouvrement (%)", "Ensemble", 97.5, 98.3, 98.8,
  
  "D14- Créances totales locataires (c411 et 416) / Loyers et charges", "OLS", 12.1, 14.5, 17.5,
  "D14- Créances totales locataires (c411 et 416) / Loyers et charges", "OLS+", 13.0, 15.3, 17.3,
  "D14- Créances totales locataires (c411 et 416) / Loyers et charges", "SAHLM", 12.2, 14.3, 17.3,
  "D14- Créances totales locataires (c411 et 416) / Loyers et charges", "OPH", 13.2, 14.9, 17.1,
  "D14- Créances totales locataires (c411 et 416) / Loyers et charges", "SEM", 11.8, 15.0, 17.7,
  "D14- Créances totales locataires (c411 et 416) / Loyers et charges", "COOP", 10.5, 14.2, 17.7,
  "D14- Créances totales locataires (c411 et 416) / Loyers et charges", "Ensemble", 12.4, 14.6, 17.4,
  
  "D8- Coût de la maintenance au logement", "OLS", 568.2, 695.7, 859.8,
  "D8- Coût de la maintenance au logement", "OLS+", 635.2, 738.4, 833.7,
  "D8- Coût de la maintenance au logement", "SAHLM", 602.2, 727.2, 855.6,
  "D8- Coût de la maintenance au logement", "OPH", 613.3, 723.7, 859.8,
  "D8- Coût de la maintenance au logement", "SEM", 572.9, 702.0, 1008.4,
  "D8- Coût de la maintenance au logement", "COOP", 438.2, 568.6, 728.0,
  "D8- Coût de la maintenance au logement", "Ensemble", 584.3, 712.8, 859.3,
  
  "D6- Coût de gestion normalisé au logement et équivalent logement géré", "OLS", 1042.0, 1227.9, 1532.0,
  "D6- Coût de gestion normalisé au logement et équivalent logement géré", "OLS+", 1072.1, 1239.4, 1419.8,
  "D6- Coût de gestion normalisé au logement et équivalent logement géré", "SAHLM", 1044.9, 1212.1, 1392.4,
  "D6- Coût de gestion normalisé au logement et équivalent logement géré", "OPH", 1041.1, 1145.2, 1291.5,
  "D6- Coût de gestion normalisé au logement et équivalent logement géré", "SEM", 1145.9, 1520.3, 1994.4,
  "D6- Coût de gestion normalisé au logement et équivalent logement géré", "COOP", 1122.4, 1598.8, 4173.5,
  "D6- Coût de gestion normalisé au logement et équivalent logement géré", "Ensemble", 1054.6, 1228.8, 1504.2,
  
  "D17- Coût de personnel normalisé au logement et équivalent logement géré", "OLS", 606.9, 732.9, 872.9,
  "D17- Coût de personnel normalisé au logement et équivalent logement géré", "OLS+", 676.6, 758.7, 880.3,
  "D17- Coût de personnel normalisé au logement et équivalent logement géré", "SAHLM", 582.7, 700.9, 811.7,
  "D17- Coût de personnel normalisé au logement et équivalent logement géré", "OPH", 689.5, 758.2, 848.7,
  "D17- Coût de personnel normalisé au logement et équivalent logement géré", "SEM", 600.3, 819.1, 1036.8,
  "D17- Coût de personnel normalisé au logement et équivalent logement géré", "COOP", 380.9, 848.5, 1315.3,
  "D17- Coût de personnel normalisé au logement et équivalent logement géré", "Ensemble", 621.9, 740.4, 875.2,
  
  "D5- TFPB au logement", "OLS", 442.4, 571.3, 683.8,
  "D5- TFPB au logement", "OLS+", 485.0, 579.0, 672.0,
  "D5- TFPB au logement", "SAHLM", 433.3, 558.3, 667.9,
  "D5- TFPB au logement", "OPH", 497.4, 579.4, 657.8,
  "D5- TFPB au logement", "SEM", 464.3, 625.0, 724.2,
  "D5- TFPB au logement", "COOP", 188.7, 455.3, 724.4,
  "D5- TFPB au logement", "Ensemble", 455.6, 573.8, 675.8,
  
  "D32- Cotisations CGLLS (hors dispositif de lissage) par logement équivalent logement gérés", "OLS", 81.9, 101.9, 133.0,
  "D32- Cotisations CGLLS (hors dispositif de lissage) par logement équivalent logement gérés", "OLS+", 91.4, 110.3, 130.0,
  "D32- Cotisations CGLLS (hors dispositif de lissage) par logement équivalent logement gérés", "SAHLM", 98.4, 117.0, 143.7,
  "D32- Cotisations CGLLS (hors dispositif de lissage) par logement équivalent logement gérés", "OPH", 82.0, 97.3, 115.3,
  "D32- Cotisations CGLLS (hors dispositif de lissage) par logement équivalent logement gérés", "SEM", 65.2, 90.4, 132.9,
  "D32- Cotisations CGLLS (hors dispositif de lissage) par logement équivalent logement gérés", "COOP", 78.0, 110.1, 143.0,
  "D32- Cotisations CGLLS (hors dispositif de lissage) par logement équivalent logement gérés", "Ensemble", 84.1, 104.3, 132.1,
  
  "D15- Charges d'intérêts et autres charges financières / C.A. locatif (%)", "OLS", 12.5, 17.4, 23.7,
  "D15- Charges d'intérêts et autres charges financières / C.A. locatif (%)", "OLS+", 15.2, 18.4, 22.7,
  "D15- Charges d'intérêts et autres charges financières / C.A. locatif (%)", "SAHLM", 17.7, 21.5, 26.4,
  "D15- Charges d'intérêts et autres charges financières / C.A. locatif (%)", "OPH", 11.5, 15.3, 18.4,
  "D15- Charges d'intérêts et autres charges financières / C.A. locatif (%)", "SEM", 11.3, 15.5, 20.7,
  "D15- Charges d'intérêts et autres charges financières / C.A. locatif (%)", "COOP", 13.5, 21.9, 37.6,
  "D15- Charges d'intérêts et autres charges financières / C.A. locatif (%)", "Ensemble", 13.0, 17.8, 23.3,
  
  "D7- Annuités emprunts locatifs / Loyers (%)", "OLS", 33.3, 41.7, 51.0,
  "D7- Annuités emprunts locatifs / Loyers (%)", "OLS+", 38.6, 44.0, 49.0,
  "D7- Annuités emprunts locatifs / Loyers (%)", "SAHLM", 42.3, 47.5, 54.1,
  "D7- Annuités emprunts locatifs / Loyers (%)", "OPH", 32.8, 38.9, 45.2,
  "D7- Annuités emprunts locatifs / Loyers (%)", "SEM", 28.4, 38.1, 49.8,
  "D7- Annuités emprunts locatifs / Loyers (%)", "COOP", 31.6, 48.2, 65.3,
  "D7- Annuités emprunts locatifs / Loyers (%)", "Ensemble", 33.9, 42.7, 50.2,
  
  "D20- CAF Brute / C.A. locatif (%)", "OLS", 26.9, 33.0, 38.2,
  "D20- CAF Brute / C.A. locatif (%)", "OLS+", 29.0, 32.5, 36.2,
  "D20- CAF Brute / C.A. locatif (%)", "SAHLM", 30.0, 34.0, 38.9,
  "D20- CAF Brute / C.A. locatif (%)", "OPH", 26.8, 33.0, 36.2,
  "D20- CAF Brute / C.A. locatif (%)", "SEM", 25.9, 32.1, 36.3,
  "D20- CAF Brute / C.A. locatif (%)", "COOP", 20.3, 29.7, 38.1,
  "D20- CAF Brute / C.A. locatif (%)", "Ensemble", 27.5, 32.9, 37.4,
  
  "D20G- CAF Brute globale / C.A. locatif (%)", "OLS", 31.9, 37.8, 45.7,
  "D20G- CAF Brute globale / C.A. locatif (%)", "OLS+", 36.5, 40.7, 46.0,
  "D20G- CAF Brute globale / C.A. locatif (%)", "SAHLM", 37.1, 43.1, 48.8,
  "D20G- CAF Brute globale / C.A. locatif (%)", "OPH", 33.0, 38.0, 43.1,
  "D20G- CAF Brute globale / C.A. locatif (%)", "SEM", 31.1, 35.6, 42.0,
  "D20G- CAF Brute globale / C.A. locatif (%)", "COOP", 23.5, 36.0, 47.2,
  "D20G- CAF Brute globale / C.A. locatif (%)", "Ensemble", 33.1, 38.8, 45.9,
  
  "D1- Autofinancement net HLM / Produits d'activité et financiers (%)", "OLS", 3.3, 7.6, 12.9,
  "D1- Autofinancement net HLM / Produits d'activité et financiers (%)", "OLS+", 4.2, 7.5, 10.6,
  "D1- Autofinancement net HLM / Produits d'activité et financiers (%)", "SAHLM", 3.5, 7.0, 11.1,
  "D1- Autofinancement net HLM / Produits d'activité et financiers (%)", "OPH", 5.4, 8.8, 13.2,
  "D1- Autofinancement net HLM / Produits d'activité et financiers (%)", "SEM", 0.4, 7.7, 12.9,
  "D1- Autofinancement net HLM / Produits d'activité et financiers (%)", "COOP", 1.1, 4.6, 10.0,
  "D1- Autofinancement net HLM / Produits d'activité et financiers (%)", "Ensemble", 3.5, 7.5, 12.1,
  
  "D1G- Autofinancement global net / (CA + produits financiers)", "OLS", 6.2, 13.5, 19.7,
  "D1G- Autofinancement global net / (CA + produits financiers)", "OLS+", 11.5, 15.0, 19.9,
  "D1G- Autofinancement global net / (CA + produits financiers)", "SAHLM", 13.9, 19.8, 24.5,
  "D1G- Autofinancement global net / (CA + produits financiers)", "OPH", 12.5, 16.6, 21.7,
  "D1G- Autofinancement global net / (CA + produits financiers)", "SEM", 8.0, 14.6, 19.9,
  "D1G- Autofinancement global net / (CA + produits financiers)", "COOP", 6.0, 9.1, 12.4,
  "D1G- Autofinancement global net / (CA + produits financiers)", "Ensemble", 8.3, 13.9, 19.8,
  
  "D2- FRNGT au logement", "OLS", 2062.2, 3459.1, 5165.5,
  "D2- FRNGT au logement", "OLS+", 1859.6, 3080.5, 4335.2,
  "D2- FRNGT au logement", "SAHLM", 2455.6, 3677.7, 5162.1,
  "D2- FRNGT au logement", "OPH", 2154.2, 3040.2, 4311.5,
  "D2- FRNGT au logement", "SEM", 1288.8, 3027.5, 5927.0,
  "D2- FRNGT au logement", "COOP", 1823.6, 3929.3, 21659.5,
  "D2- FRNGT au logement", "Ensemble", 1983.5, 3303.3, 5050.6,
  
  "D13- Ressources propres / Ressources stables (%)", "OLS", 54.1, 61.3, 70.3,
  "D13- Ressources propres / Ressources stables (%)", "OLS+", 53.6, 59.1, 64.7,
  "D13- Ressources propres / Ressources stables (%)", "SAHLM", 49.6, 55.8, 60.2,
  "D13- Ressources propres / Ressources stables (%)", "OPH", 59.1, 63.6, 69.8,
  "D13- Ressources propres / Ressources stables (%)", "SEM", 55.2, 64.0, 71.4,
  "D13- Ressources propres / Ressources stables (%)", "COOP", 49.8, 62.8, 74.2,
  "D13- Ressources propres / Ressources stables (%)", "Ensemble", 53.9, 60.9, 68.6,
  
  "D4- Trésorerie par logement et équivalent logement en propriété", "OLS", 1779.1, 3424.6, 5154.4,
  "D4- Trésorerie par logement et équivalent logement en propriété", "OLS+", 1159.4, 2043.4, 3514.7,
  "D4- Trésorerie par logement et équivalent logement en propriété", "SAHLM", 1237.5, 2399.2, 4346.8,
  "D4- Trésorerie par logement et équivalent logement en propriété", "OPH", 1753.0, 2892.3, 4007.3,
  "D4- Trésorerie par logement et équivalent logement en propriété", "SEM", 1527.9, 3112.2, 6046.8,
  "D4- Trésorerie par logement et équivalent logement en propriété", "COOP", 1904.6, 3921.5, 17744.8,
  "D4- Trésorerie par logement et équivalent logement en propriété", "Ensemble", 1486.2, 2975.6, 4622.1,
  
  "D21- Endettement / CAF courante (en années)", "OLS", 14.6, 21.9, 32.4,
  "D21- Endettement / CAF courante (en années)", "OLS+", 19.3, 23.8, 31.0,
  "D21- Endettement / CAF courante (en années)", "SAHLM", 20.6, 27.0, 35.2,
  "D21- Endettement / CAF courante (en années)", "OPH", 17.0, 20.6, 27.6,
  "D21- Endettement / CAF courante (en années)", "SEM", 11.4, 18.2, 31.7,
  "D21- Endettement / CAF courante (en années)", "COOP", 0.0, 21.9, 32.2,
  "D21- Endettement / CAF courante (en années)", "Ensemble", 16.2, 22.2, 32.1,
  
  "D22- Valeur nette comptable / Dotations aux amortissements (en années)", "OLS", 18.9, 22.3, 26.1,
  "D22- Valeur nette comptable / Dotations aux amortissements (en années)", "OLS+", 20.3, 22.6, 25.0,
  "D22- Valeur nette comptable / Dotations aux amortissements (en années)", "SAHLM", 20.3, 23.3, 26.3,
  "D22- Valeur nette comptable / Dotations aux amortissements (en années)", "OPH", 19.0, 21.3, 24.2,
  "D22- Valeur nette comptable / Dotations aux amortissements (en années)", "SEM", 17.5, 21.1, 24.5,
  "D22- Valeur nette comptable / Dotations aux amortissements (en années)", "COOP", 23.2, 27.1, 33.5,
  "D22- Valeur nette comptable / Dotations aux amortissements (en années)", "Ensemble", 19.2, 22.4, 25.8,
  
  "D35- Ecart [VNC / Dotations aux amortissements] – [Endettement / CAFC] (en années)", "OLS", -8.6, 0.0, 4.8,
  "D35- Ecart [VNC / Dotations aux amortissements] – [Endettement / CAFC] (en années)", "OLS+", -7.9, -1.4, 2.0,
  "D35- Ecart [VNC / Dotations aux amortissements] – [Endettement / CAFC] (en années)", "SAHLM", -12.3, -3.3, 1.5,
  "D35- Ecart [VNC / Dotations aux amortissements] – [Endettement / CAFC] (en années)", "OPH", -5.6, 0.0, 3.9,
  "D35- Ecart [VNC / Dotations aux amortissements] – [Endettement / CAFC] (en années)", "SEM", -6.4, 1.9, 7.0,
  "D35- Ecart [VNC / Dotations aux amortissements] – [Endettement / CAFC] (en années)", "COOP", -4.7, 1.5, 6.9,
  "D35- Ecart [VNC / Dotations aux amortissements] – [Endettement / CAFC] (en années)", "Ensemble", -8.2, -0.4, 4.2,
  
  "D33- (Montant Constructions neuves + Foncier) / Investissements réalisés (%)", "OLS", 40.7, 72.2, 90.9,
  "D33- (Montant Constructions neuves + Foncier) / Investissements réalisés (%)", "OLS+", 54.0, 68.7, 82.1,
  "D33- (Montant Constructions neuves + Foncier) / Investissements réalisés (%)", "SAHLM", 57.8, 75.6, 87.3,
  "D33- (Montant Constructions neuves + Foncier) / Investissements réalisés (%)", "OPH", 42.2, 62.0, 78.5,
  "D33- (Montant Constructions neuves + Foncier) / Investissements réalisés (%)", "SEM", 36.2, 74.1, 95.8,
  "D33- (Montant Constructions neuves + Foncier) / Investissements réalisés (%)", "COOP", 48.2, 86.9, 98.8,
  "D33- (Montant Constructions neuves + Foncier) / Investissements réalisés (%)", "Ensemble", 47.1, 69.4, 88.0,
  
  "D34- Additions et remplacement de composants / Investissements réalisés (%)", "OLS", 5.5, 22.8, 50.0,
  "D34- Additions et remplacement de composants / Investissements réalisés (%)", "OLS+", 15.8, 28.9, 44.6,
  "D34- Additions et remplacement de composants / Investissements réalisés (%)", "SAHLM", 10.8, 22.6, 39.5,
  "D34- Additions et remplacement de composants / Investissements réalisés (%)", "OPH", 19.2, 36.5, 53.2,
  "D34- Additions et remplacement de composants / Investissements réalisés (%)", "SEM", 0.5, 15.7, 59.3,
  "D34- Additions et remplacement de composants / Investissements réalisés (%)", "COOP", 0.0, 4.0, 32.1,
  "D34- Additions et remplacement de composants / Investissements réalisés (%)", "Ensemble", 7.7, 25.6, 47.3
  
)

# ---- COULEURS ----
famille_colors <- c(
  "OLS" = "orange",
  "OLS+" = "blue",
  "SAHLM" = "purple",
  "OPH" = "red",
  "SEM" = "cyan",
  "COOP" = "green",
  "Ensemble" = "grey"
)

# ---- UI ----
ui <- bs4DashPage(
  title = "Analyse Structure Financière",
  fullscreen = TRUE,
  dark = TRUE,
  
  header = bs4DashNavbar(
    title = "Analyse Structure Financière",
    status = "primary",
    skin = "dark"
  ),
  
  sidebar = bs4DashSidebar(disable = TRUE),
  
  body = bs4DashBody(
    useShinyjs(),
    fluidPage(
      tabsetPanel(
        id = "main_tabs",
        type = "tabs",
        
        # ---- LOGIN ----
        tabPanel("Connexion",
                 div(class = "login-box",
                     h2("Connexion"),
                     textInput("login_user", "Nom d'utilisateur"),
                     passwordInput("login_pwd", "Mot de passe"),
                     actionButton("login_btn", "Se connecter"),
                     uiOutput("login_error")
                 )
        ),
        
        # ---- CHANGER MOT DE PASSE ----
        tabPanel("Changer Mot de Passe",
                 bs4Card(
                   title = "Changer mot de passe", width = 6,
                   passwordInput("old_pwd", "Mot de passe actuel"),
                   passwordInput("new_pwd", "Nouveau mot de passe"),
                   passwordInput("confirm_pwd", "Confirmer"),
                   actionButton("change_btn", "Changer"),
                   verbatimTextOutput("change_msg")
                 )
        ),
        
        # ---- TABLEAUX ET GRAPHIQUES ----
        tabPanel("Tableaux et Graphiques",
                 fluidRow(
                   bs4Card(
                     width = 3, title = "Filtres et Export",
                     pickerInput("filter_libelle", "Indicateur:", choices = NULL, multiple = TRUE,
                                 options = list(`actions-box`=TRUE)),
                     pickerInput("filter_famille", "Famille:", choices = NULL, multiple = TRUE,
                                 options = list(`actions-box`=TRUE)),
                     downloadButton("download_table", "Télécharger Excel")
                   ),
                   bs4Card(
                     width = 9,
                     tabsetPanel(
                       tabPanel("Barres", plotlyOutput("plot_bar", height = "450px")),
                       tabPanel("Boxplot", plotlyOutput("plot_box", height = "450px")),
                       tabPanel("Lignes", plotlyOutput("plot_line", height = "450px")),
                       tabPanel("Histogramme", plotlyOutput("plot_hist", height = "450px")),
                       tabPanel("Heatmap", plotlyOutput("plot_heatmap", height = "450px")),
                       tabPanel("Scatter", plotlyOutput("plot_scatter", height = "450px"))
                     ),
                     br(),
                     DTOutput("tableau_complet"),
                     br(),
                     DTOutput("tableau_stats")
                   )
                 )
        ),
        
        # ---- DECONNEXION ----
        tabPanel("Déconnexion",
                 bs4Card(
                   title = "Déconnexion",
                   width = 12,
                   actionButton("logout_btn", "Se déconnecter", class = "btn-danger")
                 )
        )
      )
    )
  ),
  
  footer = bs4DashFooter(left = "© 2025", right = "Version 2.0")
)

# ---- SERVER ----
server <- function(input, output, session) {
  
  creds <- reactiveValues(auth = FALSE, user = NULL, role = NULL)
  
  # ---- LOGIN ----
  observeEvent(input$login_btn, {
    req(input$login_user, input$login_pwd)
    hash_input <- digest(input$login_pwd, algo = "sha256")
    user_row <- users %>% filter(user == input$login_user & password == hash_input)
    if(nrow(user_row) == 1) {
      creds$auth <- TRUE
      creds$user <- input$login_user
      creds$role <- user_row$role
      output$login_error <- renderUI(NULL)
      updateTabsetPanel(session, "main_tabs", selected = "Tableaux et Graphiques")
    } else {
      output$login_error <- renderUI(div(style="color:red;", "Login ou mot de passe incorrect."))
    }
  })
  
  observeEvent(input$logout_btn, {
    creds$auth <- FALSE
    creds$user <- NULL
    creds$role <- NULL
    updateTabsetPanel(session, "main_tabs", selected = "Connexion")
  })
  
  # ---- CHANGER MOT DE PASSE ----
  observeEvent(input$change_btn, {
    req(creds$auth)
    idx <- which(users$user == creds$user)
    if(users$password[idx] != digest(input$old_pwd, algo = "sha256")) {
      output$change_msg <- renderText("Mot de passe actuel incorrect.")
    } else if(input$new_pwd != input$confirm_pwd) {
      output$change_msg <- renderText("Les mots de passe ne correspondent pas.")
    } else {
      users$password[idx] <- digest(input$new_pwd, algo = "sha256")
      saveRDS(users, users_file)
      output$change_msg <- renderText("Mot de passe modifié avec succès.")
    }
  })
  
  # ---- Initialiser filtres ----
  observe({
    req(creds$auth)
    updatePickerInput(session, "filter_libelle", choices = unique(data_tableau$Libelle), selected = unique(data_tableau$Libelle))
    updatePickerInput(session, "filter_famille", choices = unique(data_tableau$Famille), selected = unique(data_tableau$Famille))
  })
  
  # ---- Filtrage ----
  filtered_tableau <- reactive({
    req(creds$auth)
    data_tableau %>% filter(Libelle %in% input$filter_libelle, Famille %in% input$filter_famille)
  })
  
  # ---- TABLEAU ----
  output$tableau_complet <- renderDT({
    datatable(filtered_tableau(), options = list(pageLength = 10))
  })
  
  # ---- STATISTIQUES ----
  output$tableau_stats <- renderDT({
    df <- filtered_tableau() %>%
      group_by(Famille) %>%
      summarise(across(c(Q1, Med, Q3), list(mean = mean, sd = sd, median = median)))
    datatable(df, options = list(pageLength = 10))
  })
  
  # ---- GRAPHIQUES ----
  output$plot_bar <- renderPlotly({
    df <- filtered_tableau()
    plot_ly(df, x = ~Famille, y = ~Q1, type = 'bar', name = 'Q1', color = ~Famille, colors = famille_colors) %>%
      add_trace(y = ~Med, name = 'Med') %>%
      add_trace(y = ~Q3, name = 'Q3') %>%
      layout(barmode = 'group', title = "Barres")
  })
  
  output$plot_box <- renderPlotly({
    df <- filtered_tableau()
    plot_ly(df, x = ~Famille, y = ~Q1, type = 'box', boxpoints = "all", color = ~Famille, colors = famille_colors) %>%
      add_trace(y = ~Med, type = 'scatter', mode = 'markers+lines', name = 'Med') %>%
      add_trace(y = ~Q3, type = 'scatter', mode = 'markers+lines', name = 'Q3') %>%
      layout(title = "Boxplot")
  })
  
  output$plot_line <- renderPlotly({
    df <- filtered_tableau() %>% pivot_longer(cols = c(Q1, Med, Q3), names_to = "Stat", values_to = "Valeur")
    plot_ly(df, x = ~Famille, y = ~Valeur, type = 'scatter', mode = 'lines+markers', color = ~Stat,
            colors = c("Q1"="orange","Med"="blue","Q3"="red")) %>%
      layout(title = "Lignes")
  })
  
  output$plot_hist <- renderPlotly({
    df <- filtered_tableau()
    plot_ly(df, x = ~Q1, type = "histogram", color = ~Famille, colors = famille_colors) %>%
      layout(title = "Histogramme des Q1")
  })
  
  output$plot_heatmap <- renderPlotly({
    df <- filtered_tableau() %>% pivot_wider(names_from = Libelle, values_from = Q1)
    plot_ly(z = as.matrix(df[,-1]), x = colnames(df)[-1], y = df$Famille,
            type = "heatmap", colorscale = "Viridis") %>%
      layout(title = "Heatmap des indicateurs")
  })
  
  output$plot_scatter <- renderPlotly({
    df <- filtered_tableau()
    plot_ly(df, x = ~Q1, y = ~Med, type = 'scatter', mode = 'markers', color = ~Famille,
            colors = famille_colors, text = ~Libelle) %>%
      layout(title = "Scatter Q1 vs Med")
  })
  
  # ---- TELECHARGEMENT ----
  output$download_table <- downloadHandler(
    filename = "Tableau.xlsx",
    content = function(file) { write.xlsx(filtered_tableau(), file) }
  )
}

# ---- RUN APP ----
shinyApp(ui, server)