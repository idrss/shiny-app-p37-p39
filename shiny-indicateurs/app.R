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
library(uuid)

# ---- UTILISATEURS ----
users_file <- "users_p37_39.rds"
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



# ---- DONNÉES ----
# ================= P37 =================
data_p37 <- tribble(
  ~Code, ~Libellé, ~Type, ~Q1, ~Med, ~Q3,
  "A1","Nombre de logements et équivalents logements gérés","<12k",1855,4821,8509,
  "A1","Nombre de logements et équivalents logements gérés",">12k",14078,18230,27632,
  "A1","Nombre de logements et équivalents logements gérés","Ensemble",2626,6780,13299,
  "D9","Loyer moyen des logements familiaux gérés","<12k",3838.1,4255.7,4732.5,
  "D9","Loyer moyen des logements familiaux gérés",">12k",4005,4322.3,4668.9,
  "D9","Loyer moyen des logements familiaux gérés","Ensemble",3861.7,4271.5,4713.6,
  "D10","Produits financiers globaux par logement géré","<12k",74,122.8,187.6,
  "D10","Produits financiers globaux par logement géré",">12k",71.8,106.9,170,
  "D10","Produits financiers globaux par logement géré","Ensemble",73,116.6,184.2,
  "D11","Taux de vacance (%)","<12k",0.017,0.032,0.054,
  "D11","Taux de vacance (%)",">12k",0.028,0.039,0.053,
  "D11","Taux de vacance (%)","Ensemble",0.02,0.034,0.054,
  "D31","Taux de recouvrement (%)","<12k",0.976,0.983,0.99,
  "D31","Taux de recouvrement (%)",">12k",0.974,0.981,0.985,
  "D31","Taux de recouvrement (%)","Ensemble",0.975,0.983,0.988,
  "D14","Créances totales locataires / Loyers et charges","<12k",0.121,0.145,0.175,
  "D14","Créances totales locataires / Loyers et charges",">12k",0.13,0.153,0.173,
  "D14","Créances totales locataires / Loyers et charges","Ensemble",0.124,0.146,0.174,
  "D8","Coût de la maintenance au logement","<12k",568.2,695.7,859.8,
  "D8","Coût de la maintenance au logement",">12k",635.2,738.4,833.7,
  "D8","Coût de la maintenance au logement","Ensemble",584.3,712.8,859.3,
  "D6","Coût de gestion normalisé au logement et équivalent logement géré","<12k",1042,1227.9,1532,
  "D6","Coût de gestion normalisé au logement et équivalent logement géré",">12k",1072.1,1239.4,1419.8,
  "D6","Coût de gestion normalisé au logement et équivalent logement géré","Ensemble",1054.6,1228.8,1504.2,
  "D17","Coût de personnel normalisé au logement et équivalent logement géré","<12k",606.9,732.9,872.9,
  "D17","Coût de personnel normalisé au logement et équivalent logement géré",">12k",676.6,758.7,880.3,
  "D17","Coût de personnel normalisé au logement et équivalent logement géré","Ensemble",621.9,740.4,875.2,
  "D5","TFPB au logement","<12k",442.4,571.3,683.8,
  "D5","TFPB au logement",">12k",485,579,672,
  "D5","TFPB au logement","Ensemble",455.6,573.8,675.8,
  "D32","Cotisations CGLLS par logement","<12k",81.9,101.9,133,
  "D32","Cotisations CGLLS par logement",">12k",91.4,110.3,130,
  "D32","Cotisations CGLLS par logement","Ensemble",84.1,104.3,132.1,
  "D15","Charges d'intérêts et autres charges financières / C.A. locatif (%)","<12k",0.125,0.174,0.237,
  "D15","Charges d'intérêts et autres charges financières / C.A. locatif (%)",">12k",0.152,0.184,0.227,
  "D15","Charges d'intérêts et autres charges financières / C.A. locatif (%)","Ensemble",0.13,0.178,0.233,
  "D7","Annuités emprunts locatifs / Loyers (%)","<12k",0.333,0.417,0.51,
  "D7","Annuités emprunts locatifs / Loyers (%)",">12k",0.386,0.44,0.49,
  "D7","Annuités emprunts locatifs / Loyers (%)","Ensemble",0.339,0.427,0.502,
  "D20","CAF Brute / C.A. locatif (%)","<12k",0.269,0.33,0.382,
  "D20","CAF Brute / C.A. locatif (%)",">12k",0.29,0.325,0.362,
  "D20","CAF Brute / C.A. locatif (%)","Ensemble",0.275,0.329,0.374,
  "D20G","CAF Brute globale / C.A. locatif (%)","<12k",0.319,0.378,0.457,
  "D20G","CAF Brute globale / C.A. locatif (%)",">12k",0.365,0.407,0.46,
  "D20G","CAF Brute globale / C.A. locatif (%)","Ensemble",0.331,0.388,0.459,
  "D1","Autofinancement net HLM / Produits d'activité et financiers (%)","<12k",0.033,0.076,0.129,
  "D1","Autofinancement net HLM / Produits d'activité et financiers (%)",">12k",0.042,0.075,0.106,
  "D1","Autofinancement net HLM / Produits d'activité et financiers (%)","Ensemble",0.035,0.075,0.121,
  "D1G","Autofinancement global net / (CA + produits financiers)","<12k",0.062,0.135,0.197,
  "D1G","Autofinancement global net / (CA + produits financiers)",">12k",0.115,0.15,0.199,
  "D1G","Autofinancement global net / (CA + produits financiers)","Ensemble",0.083,0.139,0.198,
  "D2","FRNGT au logement","<12k",2062.2,3459.1,5165.5,
  "D2","FRNGT au logement",">12k",1859.6,3080.5,4335.2,
  "D2","FRNGT au logement","Ensemble",1983.5,3303.3,5050.6,
  "D13","Ressources propres / Ressources stables (%)","<12k",0.541,0.613,0.703,
  "D13","Ressources propres / Ressources stables (%)",">12k",0.536,0.591,0.647,
  "D13","Ressources propres / Ressources stables (%)","Ensemble",0.539,0.609,0.686,
  "D4","Trésorerie par logement et équivalent logement en propriété","<12k",1779.1,3424.6,5154.4,
  "D4","Trésorerie par logement et équivalent logement en propriété",">12k",1159.4,2043.4,3514.7,
  "D4","Trésorerie par logement et équivalent logement en propriété","Ensemble",1486.2,2975.6,4622.1,
  "D21","Endettement / CAF courante (en années)","<12k",14.6,21.9,32.4,
  "D21","Endettement / CAF courante (en années)",">12k",19.3,23.8,31,
  "D21","Endettement / CAF courante (en années)","Ensemble",16.2,22.2,32.1,
  "D22","Valeur nette comptable / Dotations aux amortissements (en années)","<12k",18.9,22.3,26.1,
  "D22","Valeur nette comptable / Dotations aux amortissements (en années)",">12k",20.3,22.6,25,
  "D22","Valeur nette comptable / Dotations aux amortissements (en années)","Ensemble",19.2,22.4,25.8,
  "D35","Ecart [VNC / Dotations] – [Endettement / CAFC] (en années)","<12k",-8.6,0,4.8,
  "D35","Ecart [VNC / Dotations] – [Endettement / CAFC] (en années)",">12k",-7.9,-1.4,2,
  "D35","Ecart [VNC / Dotations] – [Endettement / CAFC] (en années)","Ensemble",-8.2,-0.4,4.2,
  "D33","(Montant Constructions neuves + Foncier) / Investissements réalisés (%)","<12k",0.407,0.722,0.909,
  "D33","(Montant Constructions neuves + Foncier) / Investissements réalisés (%)",">12k",0.54,0.687,0.821,
  "D33","(Montant Constructions neuves + Foncier) / Investissements réalisés (%)","Ensemble",0.471,0.694,0.88,
  "D34","Additions et remplacement de composants / Investissements réalisés (%)","<12k",0.055,0.228,0.5,
  "D34","Additions et remplacement de composants / Investissements réalisés (%)",">12k",0.158,0.289,0.446,
  "D34","Additions et remplacement de composants / Investissements réalisés (%)","Ensemble",0.077,0.256,0.473
)

# ================= P38 =================
data_p38 <- tribble(
  ~Code, ~Libellé, ~Type, ~Q1, ~Med, ~Q3,
  "A1","Nombre de logements et équivalents logements gérés","SAHLM",4873,9126,17390,
  "A1","Nombre de logements et équivalents logements gérés","OPH",4809,9284,15461,
  "A1","Nombre de logements et équivalents logements gérés","Ensemble",2626,6780,13299,
  "D9","Loyer moyen des logements familiaux gérés","SAHLM",4249.5,4505.7,4753.8,
  "D9","Loyer moyen des logements familiaux gérés","OPH",3667.5,3863.5,4162.1,
  "D9","Loyer moyen des logements familiaux gérés","Ensemble",3861.7,4271.5,4713.6,
  "D10","Produits financiers globaux par logement géré","SAHLM",74.1,123.7,180.9,
  "D10","Produits financiers globaux par logement géré","OPH",71.8,108.2,149.6,
  "D10","Produits financiers globaux par logement géré","Ensemble",73,116.6,184.2,
  "D11","Taux de vacance (%)","SAHLM",0.019,0.032,0.047,
  "D11","Taux de vacance (%)","OPH",0.027,0.044,0.065,
  "D11","Taux de vacance (%)","Ensemble",0.02,0.034,0.054,
  "D31","Taux de recouvrement (%)","SAHLM",0.976,0.982,0.989,
  "D31","Taux de recouvrement (%)","OPH",0.977,0.983,0.987,
  "D31","Taux de recouvrement (%)","Ensemble",0.975,0.983,0.988,
  "D14","Créances totales locataires / Loyers et charges","SAHLM",0.122,0.143,0.173,
  "D14","Créances totales locataires / Loyers et charges","OPH",0.132,0.149,0.171,
  "D14","Créances totales locataires / Loyers et charges","Ensemble",0.124,0.146,0.174,
  "D8","Coût de la maintenance au logement","SAHLM",602.2,727.2,855.6,
  "D8","Coût de la maintenance au logement","OPH",613.3,723.7,859.8,
  "D8","Coût de la maintenance au logement","Ensemble",584.3,712.8,859.3,
  "D6","Coût de gestion normalisé au logement et équivalent logement géré","SAHLM",1044.9,1212.1,1392.4,
  "D6","Coût de gestion normalisé au logement et équivalent logement géré","OPH",1041.1,1145.2,1291.5,
  "D6","Coût de gestion normalisé au logement et équivalent logement géré","Ensemble",1054.6,1228.8,1504.2,
  "D17","Coût de personnel normalisé au logement et équivalent logement géré","SAHLM",582.7,700.9,811.7,
  "D17","Coût de personnel normalisé au logement et équivalent logement géré","OPH",689.5,758.2,848.7,
  "D17","Coût de personnel normalisé au logement et équivalent logement géré","Ensemble",621.9,740.4,875.2,
  "D5","TFPB au logement","SAHLM",433.3,558.3,667.9,
  "D5","TFPB au logement","OPH",497.4,579.4,657.8,
  "D5","TFPB au logement","Ensemble",455.6,573.8,675.8,
  "D32","Cotisations CGLLS","SAHLM",98.4,117,143.7,
  "D32","Cotisations CGLLS","OPH",82,97.3,115.3,
  "D32","Cotisations CGLLS","Ensemble",84.1,104.3,132.1,
  "D15","Charges d'intérêts et autres charges financières / C.A. locatif (%)","SAHLM",0.177,0.215,0.264,
  "D15","Charges d'intérêts et autres charges financières / C.A. locatif (%)","OPH",0.115,0.153,0.184,
  "D15","Charges d'intérêts et autres charges financières / C.A. locatif (%)","Ensemble",0.13,0.178,0.233,
  "D7","Annuités emprunts locatifs / Loyers (%)","SAHLM",0.423,0.475,0.541,
  "D7","Annuités emprunts locatifs / Loyers (%)","OPH",0.328,0.389,0.452,
  "D7","Annuités emprunts locatifs / Loyers (%)","Ensemble",0.339,0.427,0.502,
  "D20","CAF Brute / C.A. locatif (%)","SAHLM",0.3,0.34,0.389,
  "D20","CAF Brute / C.A. locatif (%)","OPH",0.268,0.33,0.362,
  "D20","CAF Brute / C.A. locatif (%)","Ensemble",0.275,0.329,0.374,
  "D20G","CAF Brute globale / C.A. locatif (%)","SAHLM",0.371,0.431,0.488,
  "D20G","CAF Brute globale / C.A. locatif (%)","OPH",0.33,0.38,0.431,
  "D20G","CAF Brute globale / C.A. locatif (%)","Ensemble",0.331,0.388,0.459,
  "D1","Autofinancement net HLM / Produits d'activité et financiers (%)","SAHLM",0.035,0.07,0.111,
  "D1","Autofinancement net HLM / Produits d'activité et financiers (%)","OPH",0.054,0.088,0.132,
  "D1","Autofinancement net HLM / Produits d'activité et financiers (%)","Ensemble",0.035,0.075,0.121,
  "D1G","Autofinancement global net / (CA + produits financiers)","SAHLM",0.139,0.198,0.245,
  "D1G","Autofinancement global net / (CA + produits financiers)","OPH",0.125,0.166,0.217,
  "D1G","Autofinancement global net / (CA + produits financiers)","Ensemble",0.083,0.139,0.198,
  "D2","FRNGT au logement","SAHLM",2455.6,3677.7,5162.1,
  "D2","FRNGT au logement","OPH",2154.2,3040.2,4311.5,
  "D2","FRNGT au logement","Ensemble",1983.5,3303.3,5050.6,
  "D13","Ressources propres / Ressources stables (%)","SAHLM",0.496,0.558,0.602,
  "D13","Ressources propres / Ressources stables (%)","OPH",0.591,0.636,0.698,
  "D13","Ressources propres / Ressources stables (%)","Ensemble",0.539,0.609,0.686,
  "D4","Trésorerie par logement et équivalent logement en propriété","SAHLM",1237.5,2399.2,4346.8,
  "D4","Trésorerie par logement et équivalent logement en propriété","OPH",1753,2892.3,4007.3,
  "D4","Trésorerie par logement et équivalent logement en propriété","Ensemble",1486.2,2975.6,4622.1,
  "D21","Endettement / CAF courante (en années)","SAHLM",20.6,27,35.2,
  "D21","Endettement / CAF courante (en années)","OPH",17,20.6,27.6,
  "D21","Endettement / CAF courante (en années)","Ensemble",16.2,22.2,32.1,
  "D22","Valeur nette comptable / Dotations aux amortissements (en années)","SAHLM",20.3,23.3,26.3,
  "D22","Valeur nette comptable / Dotations aux amortissements (en années)","OPH",19,21.3,24.2,
  "D22","Valeur nette comptable / Dotations aux amortissements (en années)","Ensemble",19.2,22.4,25.8,
  "D35","Ecart [VNC / Dotations] – [Endettement / CAFC] (en années)","SAHLM",-12.3,-3.3,1.5,
  "D35","Ecart [VNC / Dotations] – [Endettement / CAFC] (en années)","OPH",-5.6,0,3.9,
  "D35","Ecart [VNC / Dotations] – [Endettement / CAFC] (en années)","Ensemble",-8.2,-0.4,4.2,
  "D33","(Montant Constructions neuves + Foncier) / Investissements réalisés (%)","SAHLM",0.578,0.756,0.873,
  "D33","(Montant Constructions neuves + Foncier) / Investissements réalisés (%)","OPH",0.422,0.62,0.785,
  "D33","(Montant Constructions neuves + Foncier) / Investissements réalisés (%)","Ensemble",0.471,0.694,0.88,
  "D34","Additions et remplacement de composants / Investissements réalisés (%)","SAHLM",0.108,0.226,0.395,
  "D34","Additions et remplacement de composants / Investissements réalisés (%)","OPH",0.192,0.365,0.532,
  "D34","Additions et remplacement de composants / Investissements réalisés (%)","Ensemble",0.077,0.256,0.473
)

# ================= P39 =================
data_p39 <- tribble(
  ~Code, ~Libellé, ~Type, ~Q1, ~Med, ~Q3,
  "A1","Nombre de logements et équivalents logements gérés","SEM",739,2224,7553,
  "A1","Nombre de logements et équivalents logements gérés","COOP",211,1726,4345,
  "A1","Nombre de logements et équivalents logements gérés","Ensemble",2626,6780,13299,
  "D9","Loyer moyen des logements familiaux gérés","SEM",4182.5,4645.2,5254.7,
  "D9","Loyer moyen des logements familiaux gérés","COOP",4234.7,4688,5436.6,
  "D9","Loyer moyen des logements familiaux gérés","Ensemble",3861.7,4271.5,4713.6,
  "D10","Produits financiers globaux par logement géré","SEM",55,103.5,221.3,
  "D10","Produits financiers globaux par logement géré","COOP",124.3,232.1,591.1,
  "D10","Produits financiers globaux par logement géré","Ensemble",73,116.6,184.2,
  "D11","Taux de vacance (%)","SEM",0.014,0.03,0.052,
  "D11","Taux de vacance (%)","COOP",0.008,0.019,0.049,
  "D11","Taux de vacance (%)","Ensemble",0.02,0.034,0.054,
  "D31","Taux de recouvrement (%)","SEM",0.968,0.981,0.989,
  "D31","Taux de recouvrement (%)","COOP",0.969,0.985,0.991,
  "D31","Taux de recouvrement (%)","Ensemble",0.975,0.983,0.988,
  "D14","Créances totales locataires / Loyers et charges","SEM",0.118,0.15,0.177,
  "D14","Créances totales locataires / Loyers et charges","COOP",0.105,0.142,0.177,
  "D14","Créances totales locataires / Loyers et charges","Ensemble",0.124,0.146,0.174,
  "D8","Coût de la maintenance au logement","SEM",572.9,702,1008.4,
  "D8","Coût de la maintenance au logement","COOP",438.2,568.6,728,
  "D8","Coût de la maintenance au logement","Ensemble",584.3,712.8,859.3,
  "D6","Coût de gestion normalisé au logement et équivalent logement géré","SEM",1145.9,1520.3,1994.4,
  "D6","Coût de gestion normalisé au logement et équivalent logement géré","COOP",1122.4,1598.8,4173.5,
  "D6","Coût de gestion normalisé au logement et équivalent logement géré","Ensemble",1054.6,1228.8,1504.2,
  "D17","Coût de personnel normalisé au logement et équivalent logement géré","SEM",600.3,819.1,1036.8,
  "D17","Coût de personnel normalisé au logement et équivalent logement géré","COOP",380.9,848.5,1315.3,
  "D17","Coût de personnel normalisé au logement et équivalent logement géré","Ensemble",621.9,740.4,875.2,
  "D5","TFPB au logement","SEM",464.3,625,724.2,
  "D5","TFPB au logement","COOP",188.7,455.3,724.4,
  "D5","TFPB au logement","Ensemble",455.6,573.8,675.8,
  "D32","Cotisations CGLLS","SEM",65.2,90.4,132.9,
  "D32","Cotisations CGLLS","COOP",78,110.1,143,
  "D32","Cotisations CGLLS","Ensemble",84.1,104.3,132.1,
  "D15","Charges d'intérêts et autres charges financières / C.A. locatif (%)","SEM",0.113,0.155,0.207,
  "D15","Charges d'intérêts et autres charges financières / C.A. locatif (%)","COOP",0.135,0.219,0.376,
  "D15","Charges d'intérêts et autres charges financières / C.A. locatif (%)","Ensemble",0.13,0.178,0.233,
  "D7","Annuités emprunts locatifs / Loyers (%)","SEM",0.284,0.381,0.498,
  "D7","Annuités emprunts locatifs / Loyers (%)","COOP",0.316,0.482,0.653,
  "D7","Annuités emprunts locatifs / Loyers (%)","Ensemble",0.339,0.427,0.502,
  "D20","CAF Brute / C.A. locatif (%)","SEM",0.259,0.321,0.363,
  "D20","CAF Brute / C.A. locatif (%)","COOP",0.203,0.297,0.381,
  "D20","CAF Brute / C.A. locatif (%)","Ensemble",0.275,0.329,0.374,
  "D20G","CAF Brute globale / C.A. locatif (%)","SEM",0.311,0.356,0.42,
  "D20G","CAF Brute globale / C.A. locatif (%)","COOP",0.235,0.36,0.472,
  "D20G","CAF Brute globale / C.A. locatif (%)","Ensemble",0.331,0.388,0.459,
  "D1","Autofinancement net HLM / Produits d'activité et financiers (%)","SEM",0.004,0.077,0.129,
  "D1","Autofinancement net HLM / Produits d'activité et financiers (%)","COOP",0.011,0.046,0.1,
  "D1","Autofinancement net HLM / Produits d'activité et financiers (%)","Ensemble",0.035,0.075,0.121,
  "D1G","Autofinancement global net / (CA + produits financiers)","SEM",0.08,0.146,0.199,
  "D1G","Autofinancement global net / (CA + produits financiers)","COOP",0.06,0.091,0.124,
  "D1G","Autofinancement global net / (CA + produits financiers)","Ensemble",0.083,0.139,0.198,
  "D2","FRNGT au logement","SEM",1288.8,3027.5,5927,
  "D2","FRNGT au logement","COOP",1823.6,3929.3,21659.5,
  "D2","FRNGT au logement","Ensemble",1983.5,3303.3,5050.6,
  "D13","Ressources propres / Ressources stables (%)","SEM",0.552,0.64,0.714,
  "D13","Ressources propres / Ressources stables (%)","COOP",0.498,0.628,0.742,
  "D13","Ressources propres / Ressources stables (%)","Ensemble",0.539,0.609,0.686,
  "D4","Trésorerie par logement et équivalent logement en propriété","SEM",1527.9,3112.2,6046.8,
  "D4","Trésorerie par logement et équivalent logement en propriété","COOP",1904.6,3921.5,17744.8,
  "D4","Trésorerie par logement et équivalent logement en propriété","Ensemble",1486.2,2975.6,4622.1,
  "D21","Endettement / CAF courante (en années)","SEM",11.4,18.2,31.7,
  "D21","Endettement / CAF courante (en années)","COOP",0,21.9,32.2,
  "D21","Endettement / CAF courante (en années)","Ensemble",16.2,22.2,32.1,
  "D22","Valeur nette comptable / Dotations aux amortissements (en années)","SEM",17.5,21.1,24.5,
  "D22","Valeur nette comptable / Dotations aux amortissements (en années)","COOP",23.2,27.1,33.5,
  "D22","Valeur nette comptable / Dotations aux amortissements (en années)","Ensemble",19.2,22.4,25.8,
  "D35","Ecart [VNC / Dotations] – [Endettement / CAFC] (en années)","SEM",-6.4,1.9,7,
  "D35","Ecart [VNC / Dotations] – [Endettement / CAFC] (en années)","COOP",-4.7,1.5,6.9,
  "D35","Ecart [VNC / Dotations] – [Endettement / CAFC] (en années)","Ensemble",-8.2,-0.4,4.2,
  "D33","(Montant Constructions neuves + Foncier) / Investissements réalisés (%)","SEM",0.362,0.741,0.958,
  "D33","(Montant Constructions neuves + Foncier) / Investissements réalisés (%)","COOP",0.482,0.869,0.988,
  "D33","(Montant Constructions neuves + Foncier) / Investissements réalisés (%)","Ensemble",0.471,0.694,0.88,
  "D34","Additions et remplacement de composants / Investissements réalisés (%)","SEM",0.005,0.157,0.593,
  "D34","Additions et remplacement de composants / Investissements réalisés (%)","COOP",0,0.04,0.321,
  "D34","Additions et remplacement de composants / Investissements réalisés (%)","Ensemble",0.077,0.256,0.473
)


# ---- TEXTE EXPLICATIF DES INDICATEURS ----
explications_indic_html <- "
<b>A1 :</b> Nombre de logements et équivalents logements gérés<br>
Indique le nombre total de logements gérés selon la taille ou le type d'organisme.<br><br>
<b>D9 :</b> Loyer moyen des logements familiaux gérés<br>
Montant moyen du loyer pour les logements familiaux, en euros.<br><br>
<b>D10 :</b> Produits financiers globaux par logement géré<br>
Revenus financiers générés par logement, incluant loyers et autres produits.<br><br>
<b>D11 :</b> Taux de vacance (%)<br>
Pourcentage de logements inoccupés par rapport au total des logements gérés.<br><br>
<b>D31 :</b> Taux de recouvrement (%)<br>
Pourcentage des loyers et charges effectivement recouvrés sur le montant total dû.<br><br>
<b>D14 :</b> Créances totales locataires / Loyers et charges<br>
Ratio des créances clients par rapport aux loyers et charges facturés.<br><br>
<b>D8 :</b> Coût de la maintenance au logement<br>
Dépenses liées à la maintenance et à l'entretien par logement.<br><br>
<b>D6 :</b> Coût de gestion normalisé au logement et équivalent logement géré<br>
Coût de gestion administrative par logement, normalisé pour comparaison.<br><br>
<b>D17 :</b> Coût de personnel normalisé au logement et équivalent logement géré<br>
Dépenses de personnel par logement, normalisées pour comparaison.<br><br>
<b>D5 :</b> TFPB au logement<br>
Taxe Foncière sur les Propriétés Bâties par logement.<br><br>
<b>D32 :</b> Cotisations CGLLS par logement<br>
Cotisations au Centre de Gestion des Locataires et du Logement Social par logement.<br><br>
<b>D15 :</b> Charges d'intérêts et autres charges financières / C.A. locatif (%)<br>
Pourcentage des charges financières sur le chiffre d'affaires locatif.<br><br>
<b>D7 :</b> Annuités emprunts locatifs / Loyers (%)<br>
Proportion des remboursements d’emprunt sur les loyers encaissés.<br><br>
<b>D20 :</b> CAF Brute / C.A. locatif (%)<br>
Capacité d’autofinancement brute en pourcentage du chiffre d'affaires locatif.<br><br>
<b>D20G :</b> CAF Brute globale / C.A. locatif (%)<br>
Capacité d’autofinancement globale (CAF + produits financiers) par rapport au chiffre d'affaires locatif.<br><br>
<b>D1 :</b> Autofinancement net HLM / Produits d'activité et financiers (%)<br>
Capacité d’autofinancement net spécifique aux HLM, en pourcentage des produits totaux.<br><br>
<b>D1G :</b> Autofinancement global net / (CA + produits financiers)<br>
Capacité d’autofinancement net globale incluant tous types d'activités.<br><br>
<b>D2 :</b> FRNGT au logement<br>
Fonds de Roulement Net Global par logement.<br><br>
<b>D13 :</b> Ressources propres / Ressources stables (%)<br>
Pourcentage des ressources propres par rapport aux ressources stables.<br><br>
<b>D4 :</b> Trésorerie par logement et équivalent logement en propriété<br>
Montant de trésorerie disponible par logement en propriété.<br><br>
<b>D21 :</b> Endettement / CAF courante (en années)<br>
Nombre d’années nécessaires pour rembourser la dette avec la CAF courante.<br><br>
<b>D22 :</b> Valeur nette comptable / Dotations aux amortissements (en années)<br>
Indicateur de la durée de vie comptable des biens par rapport aux amortissements.<br><br>
<b>D35 :</b> Ecart [VNC / Dotations] – [Endettement / CAFC] (en années)<br>
Différence entre valeur nette comptable / dotations et endettement / CAF courante.<br><br>
<b>D33 :</b> (Montant Constructions neuves + Foncier) / Investissements réalisés (%)<br>
Proportion des investissements consacrés aux nouvelles constructions et au foncier.<br><br>
<b>D34 :</b> Additions et remplacement de composants / Investissements réalisés (%)<br>
Proportion des investissements pour rénovation et remplacement des composants existants.
"
# ---- UI ----
ui <- bs4DashPage(
  title = "Tableaux P37-P39",
  fullscreen = TRUE,
  dark = TRUE,
  
  header = bs4DashNavbar(title = "Tableaux P37-P39"),
  
  sidebar = bs4DashSidebar(
    skin = "dark",
    status = "primary",
    title = "Menu",
    bs4SidebarMenu(
      bs4SidebarMenuItem("Connexion", tabName = "login", icon = icon("sign-in")),
      bs4SidebarMenuItem("Changer Mot de Passe", tabName = "change_pwd", icon = icon("key")),
      bs4SidebarMenuItem("P37", tabName = "p37", icon = icon("table")),
      bs4SidebarMenuItem("P38", tabName = "p38", icon = icon("table")),
      bs4SidebarMenuItem("P39", tabName = "p39", icon = icon("table")),
      bs4SidebarMenuItem("Déconnexion", tabName = "logout", icon = icon("sign-out"))
    )
  ),
  
  body = bs4DashBody(
    useShinyjs(),
    bs4TabItems(
      bs4TabItem(tabName = "login",
                 div(class = "login-box",
                     h2("Connexion"),
                     textInput("login_user", "Nom d'utilisateur"),
                     passwordInput("login_pwd", "Mot de passe"),
                     actionButton("login_btn", "Se connecter"),
                     uiOutput("login_error")
                 )
      ),
      
      bs4TabItem(tabName = "change_pwd",
                 bs4Card(title = "Changer mot de passe", width = 6,
                         passwordInput("old_pwd", "Mot de passe actuel"),
                         passwordInput("new_pwd", "Nouveau mot de passe"),
                         passwordInput("confirm_pwd", "Confirmer"),
                         actionButton("change_btn", "Changer"),
                         verbatimTextOutput("change_msg"))
      ),
      
      bs4TabItem(tabName = "p37",
                 fluidRow(
                   bs4Card(width = 3,
                           pickerInput("filter_code_p37", "Code:", choices = unique(data_p37$Code), multiple = TRUE),
                           pickerInput("filter_type_p37", "Type:", choices = unique(data_p37$Type), multiple = TRUE),
                           downloadButton("download_p37", "Télécharger Excel")
                   ),
                   bs4Card(width = 9,
                           DTOutput("table_p37"),
                           plotlyOutput("plot_p37", height = "400px"))
                 )
      ),
      
      bs4TabItem(tabName = "p38",
                 fluidRow(
                   bs4Card(width = 3,
                           pickerInput("filter_code_p38", "Code:", choices = unique(data_p38$Code), multiple = TRUE),
                           pickerInput("filter_type_p38", "Type:", choices = unique(data_p38$Type), multiple = TRUE),
                           downloadButton("download_p38", "Télécharger Excel")
                   ),
                   bs4Card(width = 9,
                           DTOutput("table_p38"),
                           plotlyOutput("plot_p38", height = "400px"))
                 )
      ),
      
      bs4TabItem(tabName = "p39",
                 fluidRow(
                   bs4Card(width = 3,
                           pickerInput("filter_code_p39", "Code:", choices = unique(data_p39$Code), multiple = TRUE),
                           pickerInput("filter_type_p39", "Type:", choices = unique(data_p39$Type), multiple = TRUE),
                           downloadButton("download_p39", "Télécharger Excel")
                   ),
                   bs4Card(width = 9,
                           DTOutput("table_p39"),
                           plotlyOutput("plot_p39", height = "400px"))
                 )
      ),
      
      bs4TabItem(tabName = "logout",
                 bs4Card(title = "Déconnexion", width = 12,
                         actionButton("logout_btn", "Se déconnecter", class = "btn-danger"))
      )
    )
  ),
  
  footer = bs4DashFooter(left = "© 2025", right = "Version 1.0")
)

# ---- SERVER ----
server <- function(input, output, session) {
  creds <- reactiveValues(auth = FALSE, user = NULL, role = NULL)
  
  # ---- LOGIN ----
  observeEvent(input$login_btn, {
    req(input$login_user, input$login_pwd)
    hash_input <- digest(input$login_pwd, algo = "sha256")
    user_row <- users %>% filter(user == input$login_user & password == hash_input)
    if (nrow(user_row) == 1) {
      creds$auth <- TRUE
      creds$user <- input$login_user
      creds$role <- user_row$role
      output$login_error <- renderUI(NULL)
      updateTabItems(session, "sidebar", "p37")
    } else {
      output$login_error <- renderUI(div(style = "color:red;", "Login ou mot de passe incorrect."))
    }
  })
  
  observeEvent(input$logout_btn, {
    creds$auth <- FALSE
    creds$user <- NULL
    creds$role <- NULL
    updateTabItems(session, "sidebar", "login")
  })
  
  # ---- CHANGER MOT DE PASSE ----
  observeEvent(input$change_btn, {
    req(creds$auth)
    idx <- which(users$user == creds$user)
    if (users$password[idx] != digest(input$old_pwd, algo = "sha256")) {
      output$change_msg <- renderText("Mot de passe actuel incorrect.")
    } else if (input$new_pwd != input$confirm_pwd) {
      output$change_msg <- renderText("Les mots de passe ne correspondent pas.")
    } else {
      users$password[idx] <- digest(input$new_pwd, algo = "sha256")
      saveRDS(users, users_file)
      output$change_msg <- renderText("Mot de passe modifié avec succès.")
    }
  })
  
  # ---- FILTRAGE ----
  filter_data <- function(data, code_sel, type_sel) {
    data %>% filter(Code %in% code_sel, Type %in% type_sel)
  }
  
  # ---- P37 ----
  filtered_p37 <- reactive({ req(creds$auth); filter_data(data_p37, input$filter_code_p37, input$filter_type_p37) })
  output$table_p37 <- renderDT({ datatable(filtered_p37(), options = list(pageLength = 10)) })
  output$plot_p37 <- renderPlotly({
    df <- filtered_p37()
    plot_ly(df, x = ~Type, y = ~Q1, type = 'bar', name = 'Q1') %>%
      add_trace(y = ~Med, name = 'Med') %>%
      add_trace(y = ~Q3, name = 'Q3') %>%
      layout(barmode = 'group')
  })
  output$download_p37 <- downloadHandler(filename = "P37.xlsx", content = function(file){ write.xlsx(filtered_p37(), file) })
  
  # ---- P38 ----
  filtered_p38 <- reactive({ req(creds$auth); filter_data(data_p38, input$filter_code_p38, input$filter_type_p38) })
  output$table_p38 <- renderDT({ datatable(filtered_p38(), options = list(pageLength = 10)) })
  output$plot_p38 <- renderPlotly({
    df <- filtered_p38()
    plot_ly(df, x = ~Type, y = ~Q1, type = 'bar', name = 'Q1') %>%
      add_trace(y = ~Med, name = 'Med') %>%
      add_trace(y = ~Q3, name = 'Q3') %>%
      layout(barmode = 'group')
  })
  output$download_p38 <- downloadHandler(filename = "P38.xlsx", content = function(file){ write.xlsx(filtered_p38(), file) })
  
  # ---- P39 ----
  filtered_p39 <- reactive({ req(creds$auth); filter_data(data_p39, input$filter_code_p39, input$filter_type_p39) })
  output$table_p39 <- renderDT({ datatable(filtered_p39(), options = list(pageLength = 10)) })
  output$plot_p39 <- renderPlotly({
    df <- filtered_p39()
    plot_ly(df, x = ~Type, y = ~Q1, type = 'bar', name = 'Q1') %>%
      add_trace(y = ~Med, name = 'Med') %>%
      add_trace(y = ~Q3, name = 'Q3') %>%
      layout(barmode = 'group')
  })
  output$download_p39 <- downloadHandler(filename = "P39.xlsx", content = function(file){ write.xlsx(filtered_p39(), file) })
}

# ---- LANCER APP ----
shinyApp(ui, server)