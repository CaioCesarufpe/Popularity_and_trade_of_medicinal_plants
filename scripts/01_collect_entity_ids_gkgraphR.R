# =============================================================================
# 01_collect_entity_ids_gkgraphR.R
# Purpose : query the Google Knowledge Graph (package gkgraphR) to obtain the entity ID
#           (e.g. "/m/0h259") that identifies each RENISUS species (or the search term
#           chosen for it) in Google Trends.
# Input   : none (queries are written below; the comment above each query is the
#           Brazilian-Portuguese common name used as search term).
# Output  : one R object per query; the selected IDs were recorded manually
#           (see Table S1 of the manuscript and data/raw/renisus_knowledge_graph_ids.csv).
# Requires: environment variable GOOGLE_API_KEY.
# Note    : search terms are in Portuguese on purpose; they are data, not documentation.
# =============================================================================

### Packages ####

library(gkgraphR)




 ### Collect Google Knowledge Graph entity IDs ####
  
  
  # Atribuindo a chave da api do google  para um objeto chamado Key
  
  # The Google API key is read from an environment variable and is NEVER stored in the code.
# Set it once in your user-level .Renviron file (see .Renviron.example):  GOOGLE_API_KEY=your_key_here
key <- Sys.getenv("GOOGLE_API_KEY")
if (identical(key, "")) stop("GOOGLE_API_KEY is not set. See .Renviron.example.")
  
 # Milefolio

  query_milefolio <- querygkg(query = "milefólio", api.key = {key})


  # Alho
  
  query_alho <- querygkg(query = "alho", api.key = {key})

  
  # Babosa
  
  query_babosa <- querygkg(query = "babosa", api.key = {key})
    
  
  # Colônia
  
  query_colonia <- querygkg(query = "colônia", api.key = {key})
  
  # Caju

  query_caju <- querygkg(query = "caju", api.key = {key})
  
  # Abacaxi
  
  query_abacaxi <- querygkg(query = "abacaxi", api.key = {key})

  # Apuleia 
  
  query_apuleia <- querygkg(query = "pau-ferro", api.key = {key})
  
  # Arrabidaea
  
  query_arrabidaea <- querygkg(query = "Arrabidaea chica", api.key = {key})
  
  
  # Artemisia absinthium
  
  query_absinthium <- querygkg(query = "absinto", api.key = {key})
  
  
  # Carqueja
  
  query_carqueja <- querygkg(query = "carqueja", api.key = {key})
  
  
  # Pata-de-vaca
  
  query_bauhinia <- querygkg(query = "pata-de-vaca", api.key = {key})
  
  
  # Fura-capa
  
  query_bidens <- querygkg(query = "picão-preto", api.key = {key})
  
  # Calêndula
  
  query_calendula <- querygkg(query = "calêndula", api.key = {key})

  # Andiroba
  
  query_andiroba <- querygkg(query = "andiroba", api.key = {key})

  
  # Guaçatonga
  
  query_guaçatonga <- querygkg(query = "guaçatonga", api.key = {key})

  # Camomila
  
  query_camomila <- querygkg(query = "camomila", api.key = {key})

  # Mastruço
  
  query_mastruço <- querygkg(query = "mastruço", api.key = {key})
  
  
  # Copaifera
  
  query_copaifera <- querygkg(query = "copaifera", api.key = {key})
  
  
  # Córdia
  
  query_cordia <- querygkg(query = "cordia", api.key = {key})

  # Costus
  
  query_costus <- querygkg(query = "costus", api.key = {key})

  
  # Croton

  query_croton <- querygkg(query = "croton", api.key = {key})

  
  # açafrão
  
  query_curcuma <- querygkg(query = "curcuma longa", api.key = {key})

  
  # Alcachofra
  
  query_alcachofra <- querygkg(query = "alcachofra", api.key = {key})
  
  
  # Verônica
  
  query_dalbergia <- querygkg(query = "dalbergia subcymosa", api.key = {key})
  
  
  # Marupá
  
  query_marupa <- querygkg(query = "marupa", api.key = {key})
  
  # cavalinha
  
  query_cavalinha <- querygkg(query = "equisetum arvense", api.key = {key})
  
  # Mulungu
  
  query_mulungu <- querygkg(query = "mulungu", api.key = {key})
  
  # Eucalipto globulus
  
  query_eucalipto <- querygkg(query = "eucalyptus globulus", api.key = {key})
  
  
  # Pitangueira
  
  query_pitangueira <- querygkg(query = "pitangueira", api.key = {key})
  
  # Erva-doce
  
  query_foeniculum <- querygkg(query = "foeniculum vulgare", api.key = {key})
  
  # Soja
  
  query_soja <- querygkg(query = "soja", api.key = {key})
  
  
  # Garra-do-diabo
  
  query_harpagophytum <- querygkg(query = "garra-do-diabo", api.key = {key})
  
  
  # pinhão-roxo
  
  query_jatropha <- querygkg(query = "pinhão-roxo", api.key = {key})
  
  # Chambá
  
  query_chamba <- querygkg(query = "justicia pectoralis", api.key = {key})
  
  
  # Folha da fortuna
  
  query_kalanchoe <- querygkg(query = "kalanchoe pinnata", api.key = {key})

  
  # Urtiga branca
  
  query_lamium <- querygkg(query = "lamium album", api.key = {key})
  
  # Alecrim-pimenta
  
  query_lippia <- querygkg(query = "lippia sidoides", api.key = {key})
  
  # Malva
  
  query_malva <- querygkg(query = "malva sylvestris", api.key = {key})

  
  # Espinheira-santa
  
  query_espinheira <- querygkg(query = "espinheira-santa", api.key = {key})
  
  # Poejo
  
  query_poejo <- querygkg(query = "poejo", api.key = {key})

  
  # Menta
  
  query_menta <- querygkg(query = "menta", api.key = {key})
  
  
  # Guaco
  
  query_guaco <- querygkg(query = "guaco", api.key = {key})

  
  # Melão-são-caetano
  
  query_momordica <- querygkg(query = "momordica charantia", api.key = {key})

  
  # Morus 
  
  query_amora <- querygkg(query = "amora", api.key = {key})
  
  # Alfavacão
  
  query_alfavacao <- querygkg(query = "ocimum gratissimum", api.key = {key})
  
  
  # Babaçu
  
  query_babaçu <- querygkg(query = "babaçu", api.key = {key})
  
  # Maracujá
  
  query_maracuja <- querygkg(query = "maracujá", api.key = {key})
  
  
  # abacate
  
  query_abacate <- querygkg(query = "abacate", api.key = {key})
  
  # Salsa
  
  query_salsa <- querygkg(query = "Petroselinum sativum", api.key = {key})
  
  # Phyllanthus
  
  query_phyllanthus <- querygkg(query = "phyllanthus", api.key = {key})
  
  # Plantago major
  
  query_plantago <- querygkg(query = "plantago major", api.key = {key})
  
  # Boldo de jardim
  
  query_plectranthus <- querygkg(query = "plectranthus barbatus", api.key = {key})
  
  # Polygonum
  
  query_polygonum <- querygkg(query = "polygonum acre", api.key = {key})
  
  # Beldroega
  
  query_beldroega <- querygkg(query = "portulaca pilosa", api.key = {key})
  
  
  # Goiaba
  
  query_goiaba <- querygkg(query = "goiaba", api.key = {key})
  
  # Romã
  
  query_punica <- querygkg(query = "punica granatum", api.key = {key})
  
  # Cáscara-sagrada
  
  query_rhamnus <- querygkg(query = "rhamnus purshiana", api.key = {key})
  
  # Arruda
  
  query_arruda <- querygkg(query = "arruda", api.key = {key})
  
  # Salgueiro
  
  query_salix <- querygkg(query = "salix alba", api.key = {key})
  
  # Aroeira
  
  query_Aroeira <- querygkg(query = "aroeira", api.key = {key})
  
  # Jurubeba
  
  query_jurubeba <- querygkg(query = "jurubeba", api.key = {key})
  
  # Arnica
  
  query_Arnica <- querygkg(query = "solidago microglossa", api.key = {key})


  # Barbatimão
  
  query_barbatimao <- querygkg(query = "barbatimão", api.key = {key})
  
  # Jamelão
  
  query_jamelao <- querygkg(query = "jamelão", api.key = {key})
  
  # Ipê-roxo
  
  query_tabebuia <- querygkg(query = "Tabebuia avellanedae", api.key = {key})
   
  # Tagetes minuta
  
  query_tagetes <- querygkg(query = "tagetes minuta", api.key = {key})
  
  # Trifolium pratense 
  
  query_trifolium <- querygkg(query = "trifolium pratense", api.key = {key})
  
  # Unha-de-gato
  
  query_uncaria <- querygkg(query = "Uncaria tomentosa", api.key = {key})
               
  # Boldo-baiano
  
  query_boldo <- querygkg(query = "Vernonia condensata", api.key = {key})
  
  # Vernonia
  
  query_vernonia <- querygkg(query = "assa-peixe", api.key = {key})
  
  
  # Gengibre
  
  query_gengibre <- querygkg(query = "gengibre", api.key = {key})
                            
                            