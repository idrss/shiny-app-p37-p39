# ---- LIBRAIRIES ----
library(shiny)
library(bs4Dash)
library(tidyverse)
library(DT)
library(openxlsx)
library(shinyWidgets)
library(shinyjs)
library(plotly)

# ---- DONNÉES ----
# Création manuelle des 3 tableaux P37, P38, P39

# P37: Organismes <12k et >12k logements
data_p37 <- tribble(
  ~Code, ~Libellé, 
  ~`<12k_Q1`, ~`<12k_Med`, ~`<12k_Q3`,
  ~`>12k_Q1`, ~`>12k_Med`, ~`>12k_Q3`,
  ~`Ensemble_Q1`, ~`Ensemble_Med`, ~`Ensemble_Q3`,
  "A1", "Nombre de logements et équivalents logements gérés", 1855, 4821, 8509, 14078, 18230, 27632, 2626, 6780, 13299,
  "D9", "Loyer moyen des logements familiaux gérés", 3838.1, 4255.7, 4732.5, 4005.0, 4322.3, 4668.9, 3861.7, 4271.5, 4713.6,
  "D10", "Produits financiers globaux par logement géré", 74, 122.8, 187.6, 71.8, 106.9, 170, 73, 116.6, 184.2,
  "D11", "Taux de vacance (%)", 1.7, 3.2, 5.4, 2.8, 3.9, 5.3, 2.0, 3.4, 5.4,
  "D31", "Taux de recouvrement (%)", 97.6, 98.3, 99, 97.4, 98.1, 98.5, 97.5, 98.3, 98.8,
  "D14", "Créances totales locataires / Loyers et charges", 12.1, 14.5, 17.5, 13, 15.3, 17.3, 12.4, 14.6, 17.4,
  "D8", "Coût de la maintenance au logement", 568.2, 695.7, 859.8, 635.2, 738.4, 833.7, 584.3, 712.8, 859.3,
  "D6", "Coût de gestion normalisé au logement", 1042, 1227.9, 1532, 1072.1, 1239.4, 1419.8, 1054.6, 1228.8, 1504.2,
  "D17", "Coût de personnel normalisé", 606.9, 732.9, 872.9, 676.6, 758.7, 880.3, 621.9, 740.4, 875.2,
  "D5", "TFPB au logement", 442.4, 571.3, 683.8, 485, 579, 672, 455.6, 573.8, 675.8,
  "D32", "Cotisations CGLLS / logement", 81.9, 101.9, 133, 91.4, 110.3, 130, 84.1, 104.3, 132.1,
  "D15", "Charges d'intérêts / CA locatif (%)", 12.5, 17.4, 23.7, 15.2, 18.4, 22.7, 13, 17.8, 23.3,
  "D7", "Annuités emprunts / Loyers (%)", 33.3, 41.7, 51, 38.6, 44, 49, 33.9, 42.7, 50.2,
  "D20", "CAF Brute / CA locatif (%)", 26.9, 33, 38.2, 29, 32.5, 36.2, 27.5, 32.9, 37.4,
  "D20G", "CAF Brute globale / CA locatif (%)", 31.9, 37.8, 45.7, 36.5, 40.7, 46, 33.1, 38.8, 45.9,
  "D1", "Autofinancement net HLM (%)", 3.3, 7.6, 12.9, 4.2, 7.5, 10.6, 3.5, 7.5, 12.1,
  "D1G", "Autofinancement global net (%)", 6.2, 13.5, 19.7, 11.5, 15, 19.9, 8.3, 13.9, 19.8,
  "D2", "FRNGT au logement", 2062.2, 3459.1, 5165.5, 1859.6, 3080.5, 4335.2, 1983.5, 3303.3, 5050.6,
  "D13", "Ressources propres / Ressources stables (%)", 54.1, 61.3, 70.3, 53.6, 59.1, 64.7, 53.9, 60.9, 68.6,
  "D4", "Trésorerie / logement", 1779.1, 3424.6, 5154.4, 1159.4, 2043.4, 3514.7, 1486.2, 2975.6, 4622.1,
  "D21", "Endettement / CAF courante (années)", 14.6, 21.9, 32.4, 19.3, 23.8, 31, 16.2, 22.2, 32.1,
  "D22", "VNC / Dotations aux amortissements (années)", 18.9, 22.3, 26.1, 20.3, 22.6, 25, 19.2, 22.4, 25.8,
  "D35", "Écart VNC/CAFC (années)", -8.6, 0, 4.8, -7.9, -1.4, 2, -8.2, -0.4, 4.2,
  "D33", "Constructions neuves + Foncier / Investissements (%)", 40.7, 72.2, 90.9, 54, 68.7, 82.1, 47.1, 69.4, 88,
  "D34", "Additions et remplacement composants / Investissements (%)", 5.5, 22.8, 50, 15.8, 28.9, 44.6, 7.7, 25.6, 47.3
)

# P38: SAHLM / OPH / Ensemble
data_p38 <- tribble(
  ~Code, ~Libellé,
  ~`SAHLM_Q1`, ~`SAHLM_Med`, ~`SAHLM_Q3`,
  ~`OPH_Q1`, ~`OPH_Med`, ~`OPH_Q3`,
  ~`Ensemble_Q1`, ~`Ensemble_Med`, ~`Ensemble_Q3`,
  "A1", "Nombre de logements et équivalents logements gérés", 4873, 9126, 17390, 4809, 9284, 15461, 2626, 6780, 13299,
  "D9", "Loyer moyen des logements familiaux gérés", 4249.5, 4505.7, 4753.8, 3667.5, 3863.5, 4162.1, 3861.7, 4271.5, 4713.6
  # … ajouter tous les autres indicateurs comme dans P37
)

# P39: SEM / COOP / Ensemble
data_p39 <- tribble(
  ~Code, ~Libellé,
  ~`SEM_Q1`, ~`SEM_Med`, ~`SEM_Q3`,
  ~`COOP_Q1`, ~`COOP_Med`, ~`COOP_Q3`,
  ~`Ensemble_Q1`, ~`Ensemble_Med`, ~`Ensemble_Q3`,
  "A1", "Nombre de logements et équivalents logements gérés", 739, 2224, 7553, 211, 1726, 4345, 2626, 6780, 13299,
  "D9", "Loyer moyen des logements familiaux gérés", 4182.5, 4645.2, 5254.7, 4234.7, 4688.0, 5436.6, 3861.7, 4271.5, 4713.6
  # … ajouter tous les autres indicateurs comme dans P37
)

# ---- FUSIONNER LES TABLEAUX ----
data_all <- data_p37 %>%
  full_join(data_p38, by = c("Code","Libellé")) %>%
  full_join(data_p39, by = c("Code","Libellé"))

# ---- UI ----
ui <- bs4DashPage(
  title = "Données Logements",
  fullscreen = TRUE,
  dark = TRUE,
  header = bs4DashNavbar(title = "Données Logements"),
  sidebar = bs4DashSidebar(
    skin = "dark",
    status = "primary",
    title = "Menu",
    bs4SidebarMenu(
      bs4SidebarMenuItem("Tableau", tabName = "tableau", icon = icon("table")),
      bs4SidebarMenuItem("Graphique", tabName = "graphique", icon = icon("chart-bar")),
      bs4SidebarMenuItem("Télécharger", tabName = "download", icon = icon("download"))
    )
  ),
  body = bs4DashBody(
    useShinyjs(),
    bs4TabItems(
      bs4TabItem(tabName = "tableau",
                 DTOutput("table_all")),
      bs4TabItem(tabName = "graphique",
                 selectInput("var_plot", "Indicateur:", choices = data_all$Libellé),
                 plotlyOutput("plot_all", height = "600px")),
      bs4TabItem(tabName = "download",
                 downloadButton("download_excel", "Télécharger Excel"))
    )
  )
)

# ---- SERVER ----
server <- function(input, output, session) {
  
  output$table_all <- renderDT({
    datatable(data_all, options = list(pageLength = 15))
  })
  
  output$plot_all <- renderPlotly({
    req(input$var_plot)
    df_plot <- data_all %>%
      filter(Libellé == input$var_plot) %>%
      pivot_longer(-c(Code, Libellé), names_to = "Type", values_to = "Valeur")
    
    p <- ggplot(df_plot, aes(x = Type, y = Valeur, fill = Type)) +
      geom_col() +
      theme_minimal() +
      labs(title = input$var_plot, y = "Valeur", x = "")
    ggplotly(p)
  })
  
  output$download_excel <- downloadHandler(
    filename = function() paste0("donnees_logements_", Sys.Date(), ".xlsx"),
    content = function(file) write.xlsx(data_all, file)
  )
}

# ---- LANCER L'APP ----
shinyApp(ui, server)
