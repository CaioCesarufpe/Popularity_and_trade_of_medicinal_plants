# =============================================================================
# 02_collect_google_trends.R
# Purpose : download the monthly Google Trends series (Brazil) for the 71 RENISUS entities.
# Input   : entity IDs from script 01 (hard-coded in the calls below).
# Output  : data/raw/gtrends_monthly_raw.xlsx and data/raw/gtrends_collection_date.txt
# Requires: package gtrendsAPI (Correia 2024) and environment variable GOOGLE_API_KEY.
# =============================================================================

### Packages ####

library(gtrendsAPI)
library(openxlsx)
library(dplyr)

#install.packages("gtrendsAPI")
#install.packages("devtools")

#devtools::install_github("racorreia/gtrendsAPI", build_vignettes = T)


### Collect Google Trends data ####

# The Google API key is read from an environment variable and is NEVER stored in the code.
# Set it once in your user-level .Renviron file (see .Renviron.example):  GOOGLE_API_KEY=your_key_here
key <- Sys.getenv("GOOGLE_API_KEY")
if (identical(key, "")) stop("GOOGLE_API_KEY is not set. See .Renviron.example.")


# Collect the monthly series for each search entity, using the IDs obtained with gkgraphR (script 01).
# The comment above each call is the Brazilian-Portuguese common name of the entity (data, kept in Portuguese).
# NOTE: no date range is passed to getGraph(), so the package default applies (check the gtrendsAPI documentation).
#       The original collection was made on 16 March 2024; the collection date is also saved at the end of the script.

# Milefólio 

achillea <- getGraph(terms = "/m/0jtc5", geo = "BR", api.key = key)

# Alho

allium <- getGraph(terms = "/m/0dbrl", geo = "BR", api.key = key)


# Babosa

aloe <- getGraph(terms = "/m/059h5_", geo = "BR", api.key = key)


# Alpinia

alpinia <- getGraph(terms = "/m/02l4h0", geo = "BR", api.key = key)


# Caju

anacardium <- getGraph(terms = "/m/0h259", geo = "BR", api.key = key)


# Abacaxi

ananas <- getGraph(terms = "/m/01drpv", geo = "BR", api.key = key)


# Apuleia 

apuleia <- getGraph(terms = "/m/026m3hg", geo = "BR", api.key = key)


# Arrabidaea

arrabidaea <- getGraph(terms = "/m/026sm1x", geo = "BR", api.key = key)


# Artemisia absinthium

artemisia <- getGraph(terms = "/m/0301w4", geo = "BR", api.key = key)


# Baccharis

baccharis <- getGraph(terms = "/g/121v7v84", geo = "BR", api.key = key)


# Bauhinia

bauhinia <- getGraph(terms = "/m/0c1j1b", geo = "BR", api.key = key)


# Bidens

bidens <- getGraph(terms = "/m/02qx47c", geo = "BR", api.key = key)


# Calêndula

calendula <- getGraph(terms = "/m/0dx4k5", geo = "BR", api.key = key)


# Carapa

carapa <- getGraph(terms = "/m/010wffhf", geo = "BR", api.key = key)


# Casearia

casearia <- getGraph(terms = "/g/122fpshs", geo = "BR", api.key = key)


# Camomila

chamomilla <- getGraph(terms = "/m/011bc8hg", geo = "BR", api.key = key)


# Chenopodium

chenopodium <- getGraph(terms = "/m/059zr0", geo = "BR", api.key = key)


# Copaifera

copaifera <- getGraph(terms = "/m/02vsywz", geo = "BR", api.key = key)


# Cordia

cordia <- getGraph(terms = "/g/124xvyrpw", geo = "BR", api.key = key)


# Costus

costus <- getGraph(terms = "/m/0b_dvz", geo = "BR", api.key = key)


# Croton

croton <- getGraph(terms = "/m/06bczx", geo = "BR", api.key = key)


# Curcuma

curcuma <- getGraph(terms = "/g/1214fwq8", geo = "BR", api.key = key)


# Cynara

cynara <- getGraph(terms = "/g/11f2snd2g_", geo = "BR", api.key = key)


# Dalbergia

dalbergia <- getGraph(terms = "/g/12gh4cy2b", geo = "BR", api.key = key)


# Eleutherine

eleutherine <- getGraph(terms = "/g/1228xdzm", geo = "BR", api.key = key)


# cavalinha

equisetum <- getGraph(terms = "/m/027c535", geo = "BR", api.key = key)


# Mulungu

erythrina <- getGraph(terms = "/m/0bcnq2", geo = "BR", api.key = key)


# Eucalipto globulus

eucalyptus <- getGraph(terms = "/m/06wbnr", geo = "BR", api.key = key)


# Pitangueira

eugenia <- getGraph(terms = "/m/06dwlp", geo = "BR", api.key = key)


# Erva-doce

foeniculum <- getGraph(terms = "/m/017dqv", geo = "BR", api.key = key)


# Soja

glycine <- getGraph(terms = "/m/0gyv9", geo = "BR", api.key = key)


# Garra-do-diabo

harpagophytum <- getGraph(terms = "/g/1q6j1gqvj", geo = "BR", api.key = key)


# pinhão-roxo

jatropha <- getGraph(terms = "/m/0j_1xx2", geo = "BR", api.key = key)


# Chambá

justicia <- getGraph(terms = "/m/03m4zsv", geo = "BR", api.key = key)


# Folha da fortuna

kalanchoe <- getGraph(terms = "/m/03c84py", geo = "BR", api.key = key)


# Urtiga branca


lamium <- getGraph(terms = "/m/0cb683", geo = "BR", api.key = key)


# Alecrim-pimenta

lippia <- getGraph(terms = "/g/122723qh", geo = "BR", api.key = key)


# Malva

malva <- getGraph(terms = "/m/03c5zjp", geo = "BR", api.key = key)


# Espinheira-santa

maytenus <- getGraph(terms = "/g/12233nhq", geo = "BR", api.key = key)


# Poejo

menthapul <- getGraph(terms = "/m/0pyd5", geo = "BR", api.key = key)


# Menta

mentha <- getGraph(terms = "/g/121v8g7z", geo = "BR", api.key = key)


# Guaco

mikania <- getGraph(terms = "/m/053y43", geo = "BR", api.key = key)


# Melão-são-caetano

momordica <- getGraph(terms = "/g/11vjpd_gr", geo = "BR", api.key = key)


# Morus 

morus <- getGraph(terms = "/g/120z183t", geo = "BR", api.key = key)


# Alfavacão

ocimum <- getGraph(terms = "/m/09v5hq2", geo = "BR", api.key = key)


# Babaçu

orbignya <- getGraph(terms = "/m/026wh99", geo = "BR", api.key = key)


# Maracujá

passiflora <- getGraph(terms = "/g/11c6s0t46t", geo = "BR", api.key = key)


# abacate

persea <- getGraph(terms = "/m/01645p", geo = "BR", api.key = key)


# Salsa

petroselinum <- getGraph(terms = "/m/05s28", geo = "BR", api.key = key)


# Phyllanthus

phyllanthus <- getGraph(terms = "/m/05qxp_", geo = "BR", api.key = key)


# Plantago major

plantago <- getGraph(terms = "/m/091lk8", geo = "BR", api.key = key)


# Boldo de jardim

plectranthus <- getGraph(terms = "/m/0h7n35", geo = "BR", api.key = key)


# Polygonum

polygonum <- getGraph(terms = "/g/11j928_q3h", geo = "BR", api.key = key)


# Beldroega

portulaca <- getGraph(terms = "/m/080bnsq", geo = "BR", api.key = key)


# Goiaba

psidium <- getGraph(terms = "/m/02pt3p5", geo = "BR", api.key = key)


# Romã

punica <- getGraph(terms = "/m/0jwn_", geo = "BR", api.key = key)


# Cáscara-sagrada

rhamnus <- getGraph(terms = "/g/11bc5cjplm", geo = "BR", api.key = key)


# Arruda

ruta <- getGraph(terms = "/m/05y1s1", geo = "BR", api.key = key)


# Salgueiro

salix <- getGraph(terms = "/m/02zfch", geo = "BR", api.key = key)


# Aroeira

schinus <- getGraph(terms = "/m/06pc2k", geo = "BR", api.key = key)


# Jurubeba

solanum <- getGraph(terms = "/m/03mb3qd", geo = "BR", api.key = key)


# Arnica

solidago <- getGraph(terms = "/g/12gh48v2", geo = "BR", api.key = key)


# Barbatimão

stryphnodendron <- getGraph(terms = "/m/02vt5rp", geo = "BR", api.key = key)


# Jamelão

syzygium <- getGraph(terms = "/m/068kf5", geo = "BR", api.key = key)


# Ipê-roxo

tabebuia <- getGraph(terms = "/g/11ggs7bbn8", geo = "BR", api.key = key)


# Tagetes minuta

tagetes <- getGraph(terms = "/m/05zpkrs", geo = "BR", api.key = key)


# Trifolium pratense 

trifolium <- getGraph(terms = "/m/064tx6", geo = "BR", api.key = key)


# Unha-de-gato

uncaria <- getGraph(terms = "/m/09tk86", geo = "BR", api.key = key)


# Boldo-baiano

vernoniacon <- getGraph(terms = "/g/122r_j0t", geo = "BR", api.key = key)


# Vernonia

vernonia <- getGraph(terms = "/g/11x7vnc5p", geo = "BR", api.key = key)


# Gengibre

zingiber <- getGraph(terms = "/g/121d6gs3", geo = "BR", api.key = key)


### Rename the "value" column ####

# Rename "value" to the name of the data frame, so each column of the merged data frame identifies its species.

achillea <- rename(achillea, achillea = value)
allium <- rename(allium, allium = value)
aloe <- rename(aloe, aloe = value)
alpinia <- rename(alpinia, alpinia = value)
anacardium <- rename(anacardium, anacardium = value)
ananas <- rename(ananas, ananas = value)
apuleia <- rename(apuleia, apuleia = value)
arrabidaea <- rename(arrabidaea, arrabidaea = value)
artemisia <- rename(artemisia, artemisia = value)
baccharis <- rename(baccharis, baccharis = value)
bauhinia <- rename(bauhinia, bauhinia = value)
bidens <- rename(bidens, bidens = value)
calendula <- rename(calendula, calendula = value)
carapa <- rename(carapa, carapa = value)
casearia <- rename(casearia, casearia = value)
chamomilla <- rename(chamomilla, chamomilla = value)
chenopodium <- rename(chenopodium, chenopodium = value)
copaifera <- rename(copaifera, copaifera = value)
cordia <- rename(cordia, cordia = value)
costus <- rename(costus, costus = value)
croton <- rename(croton, croton = value)
curcuma <- rename(curcuma, curcuma = value)
cynara <- rename(cynara, cynara = value)
dalbergia <- rename(dalbergia, dalbergia = value)
eleutherine <- rename(eleutherine, eleutherine = value)
equisetum <- rename(equisetum, equisetum = value)
erythrina <- rename(erythrina, erythrina = value)
eucalyptus <- rename(eucalyptus, eucalyptus = value)
eugenia <- rename(eugenia, eugenia = value)
foeniculum <- rename(foeniculum, foeniculum = value)
glycine <- rename(glycine, glycine = value)
harpagophytum <- rename(harpagophytum, harpagophytum = value)
jatropha <- rename(jatropha, jatropha = value)
justicia <- rename(justicia, justicia = value)
kalanchoe <- rename(kalanchoe, kalanchoe = value)
lamium <- rename(lamium, lamium = value)
lippia <- rename(lippia, lippia = value)
malva <- rename(malva, malva = value)
maytenus <- rename(maytenus, maytenus = value)
menthapul <- rename(menthapul, menthapul = value)
mentha <- rename(mentha, mentha = value)
mikania <- rename(mikania, mikania = value)
momordica <- rename(momordica, momordica = value)
morus <- rename(morus, morus = value)
ocimum <- rename(ocimum, ocimum = value)
orbignya <- rename(orbignya, orbignya = value)
passiflora <- rename(passiflora, passiflora = value)
persea <- rename(persea, persea = value)
petroselinum <- rename(petroselinum, petroselinum = value)
phyllanthus <- rename(phyllanthus, phyllanthus = value)
plantago <- rename(plantago, plantago = value)
plectranthus <- rename(plectranthus, plectranthus = value)
polygonum <- rename(polygonum, polygonum = value)
portulaca <- rename(portulaca, portulaca = value)
psidium <- rename(psidium, psidium = value)
punica <- rename(punica, punica = value)
rhamnus <- rename(rhamnus, rhamnus = value)
ruta <- rename(ruta, ruta = value)
salix <- rename(salix, salix = value)
schinus <- rename(schinus, schinus = value)
solanum <- rename(solanum, solanum = value)
solidago <- rename(solidago, solidago = value)
stryphnodendron <- rename(stryphnodendron, stryphnodendron = value)
syzygium <- rename(syzygium, syzygium = value)
tabebuia <- rename(tabebuia, tabebuia = value)
tagetes <- rename(tagetes, tagetes = value)
trifolium <- rename(trifolium, trifolium = value)
uncaria <- rename(uncaria, uncaria = value)
vernoniacon <- rename(vernoniacon, vernoniacon = value)
vernonia <- rename(vernonia, vernonia = value)
zingiber <- rename(zingiber, zingiber = value)





### Clean the data frames ####

# Loop that drops all columns except date and value.

# Names of the data frames

species_list <- c("achillea", "allium", "aloe", "alpinia", "anacardium", "ananas", "apuleia", "arrabidaea", "artemisia", "baccharis", "bauhinia", "bidens", "calendula", "carapa", "casearia", "chamomilla", "chenopodium", "copaifera", "cordia", "costus", "croton", "curcuma", "cynara", "dalbergia", "eleutherine", "equisetum", "erythrina", "eucalyptus", "eugenia", "foeniculum", "glycine", "harpagophytum", "jatropha", "justicia", "kalanchoe", "lamium", "lippia", "malva", "maytenus", "menthapul", "mentha", "mikania", "momordica", "morus", "ocimum", "orbignya", "passiflora", "persea", "petroselinum", "phyllanthus", "plantago", "plectranthus", "polygonum", "portulaca", "psidium", "punica", "rhamnus", "ruta", "salix", "schinus", "solanum", "solidago", "stryphnodendron", "syzygium", "tabebuia", "tagetes", "trifolium", "uncaria", "vernoniacon", "vernonia", "zingiber")


for (species in species_list) {
  assign(species, subset(get(species), select = -c(geo, time, keyword, gprop, category)))
}






### Merge all data frames into one ####



dataframes_list <- list(achillea, allium, aloe, alpinia, anacardium, ananas,
  apuleia, arrabidaea, artemisia, baccharis, bauhinia, bidens,
  calendula, carapa, casearia, chamomilla, chenopodium, copaifera,
  cordia, costus, croton, curcuma, cynara, dalbergia, eleutherine,
  equisetum, erythrina, eucalyptus, eugenia, foeniculum, glycine,
  harpagophytum, jatropha, justicia, kalanchoe, lamium, lippia, malva, maytenus,
  menthapul, mentha, mikania, momordica, morus, ocimum, orbignya, passiflora,
  persea, petroselinum, phyllanthus, plantago, plectranthus, polygonum, portulaca,
  psidium, punica, rhamnus, ruta, salix, schinus, solanum, solidago, stryphnodendron,
  syzygium, tabebuia, tagetes, trifolium, uncaria, vernoniacon, vernonia, zingiber)


 data_final <- Reduce(function(x, y) merge(x, y, by = "date", all = TRUE), dataframes_list)
 
 
# Save the merged data frame (one date column + one column per species)
# NOTE: in the dataset used in the study, two columns were later renamed by hand:
#       menthapul -> mentha_pulegium and vernoniacon -> vernonia_condensata.
dir.create(file.path("data","raw"), recursive = TRUE, showWarnings = FALSE)
write.xlsx(data_final, file.path("data","raw","gtrends_monthly_raw.xlsx"), rowNames = FALSE)
# Record when the data were collected (Google Trends values are sampled and can change between requests)
writeLines(as.character(Sys.Date()), file.path("data","raw","gtrends_collection_date.txt"))
