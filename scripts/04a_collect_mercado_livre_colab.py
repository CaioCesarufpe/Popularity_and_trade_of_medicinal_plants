# -*- coding: utf-8 -*-
"""
04a_collect_mercado_livre_colab.py

Purpose : collect Mercado Livre listings for the RENISUS species with the scraper
          Igor-Britoo/Mercado-Livre-Plants-Scraper (Brito 2026), restricted to the
          categories defined below, and convert the CSV output to one .xlsx per species.
Output  : one spreadsheet per species search term (input of 04b_unify_ml_sheets.R).
Format  : exported from Google Colab. Lines starting with "!" or "%" are Colab/IPython
          shell commands, so this file must be run as a notebook (Google Colab or Jupyter),
          not as a plain Python script. Paths below are Google Drive paths from the original run.
Notes   : the category names are the original Portuguese names of Mercado Livre categories
          (data, kept as is); the scraper search terms (species common names) are defined
          in the scraper repository, not in this file.
"""

from google.colab import drive
drive.mount('/content/drive')

# Commented out IPython magic to ensure Python compatibility.
# %cd '/content/drive/MyDrive/Colab_Notebooks/'

!mkdir -p '/content/drive/MyDrive/Colab_Notebooks/Mercado-Livre-Plants-Scraper'

!git clone https://github.com/Igor-Britoo/Mercado-Livre-Plants-Scraper.git

# Packages
! pip install virtualenv requests==2.32.3 selenium==4.14.0 webdriver-manager==4.0.1

import json

# Define the categories (IDs and names) to be searched. Names are the original Mercado Livre category names.
categories_data = {

    	"categories": [
		{
			"id": "MLB11033",
			"name": "Plantas",
			"picture": None,
			"permalink": None,
			"total_items_in_this_category": 107895,
			"path_from_root": [],
			"children_categories": [],
			"attribute_types": "attributes",
			"settings": {},
			"channels_settings": [],
			"meta_categ_id": None,
			"attributable": False,
			"date_created": "2018-04-25T08:12:56.000Z"
		},
    {
    "id": "MLB264586",
    "name": "Saude",
    "picture": None,
    "permalink": None,
    "total_items_in_this_category": 0,
    "path_from_root": [],
    "children_categories": [],
    "attribute_types": "attributes",
    "settings": {},
    "channels_settings": [],
    "meta_categ_id": None,
    "attributable": False,
    "date_created": None
    },
  {
            "id": "MLB456964",
            "name": "Sementes Agricolas",
            "picture": None,
            "permalink": None,
            "total_items_in_this_category": 0,
            "path_from_root": [],
            "children_categories": [],
            "attribute_types": "attributes",
            "settings": {},
            "channels_settings": [],
            "meta_categ_id": None,
            "attributable": False,
            "date_created": None
        },
   {
            "id": "MLB1621",
            "name": "Jardim e Ar Livre",
            "picture": None,
            "permalink": None,
            "total_items_in_this_category": 0,
            "path_from_root": [],
            "children_categories": [],
            "attribute_types": "attributes",
            "settings": {},
            "channels_settings": [],
            "meta_categ_id": None,
            "attributable": False,
            "date_created": None
    },

		{
			"id": "MLB247521",
			"name": "Cha",
			"picture": None,
			"permalink": None,
			"total_items_in_this_category": 44843,
			"path_from_root": [],
			"children_categories": [],
			"attribute_types": "attributes",
			"settings": {},
			"channels_settings": [],
			"meta_categ_id": None,
			"attributable": False,
			"date_created": "2018-04-25T08:12:56.000Z"
		},
		{
			"id": "MLB264201",
			"name": "Suplementos Alimentares",
			"picture": None,
			"permalink": None,
			"total_items_in_this_category": 524447,
			"path_from_root": [],
			"children_categories": [],
			"attribute_types": "variations",
			"settings": {},
			"channels_settings": [],
			"meta_categ_id": None,
			"attributable": False,
			"date_created": "2018-04-25T08:12:56.000Z"
		},
		{
			"id": "MLB271865",
			"name": "Especiarias",
			"picture": None,
			"permalink": None,
			"total_items_in_this_category": 16884,
			"path_from_root": [],
			"children_categories": [],
			"attribute_types": "attributes",
			"settings": {},
			"channels_settings": [],
			"meta_categ_id": None,
			"attributable": False,
			"date_created": "2018-05-28T12:11:00.000Z"
		},
		{
			"id": "MLB11045",
			"name": "Sementes",
			"picture": None,
			"permalink": None,
			"total_items_in_this_category": 121369,
			"path_from_root": [],
			"children_categories": [],
			"attribute_types": "attributes",
			"settings": {},
			"channels_settings": [],
			"meta_categ_id": None,
			"attributable": False,
			"date_created": "2018-04-25T08:12:56.000Z"
		},
		{
			"id": "MLB272147",
			"name": "Gengibre",
			"picture": None,
			"permalink": None,
			"total_items_in_this_category": 1246,
			"path_from_root": [],
			"children_categories": [],
			"attribute_types": "attributes",
			"settings": {},
			"channels_settings": [],
			"meta_categ_id": None,
			"attributable": False,
			"date_created": "2018-05-31T19:43:47.000Z"
		},
		{
			"id": "MLB270259",
			"name": "Pilulas e Capsulas",
			"picture": None,
			"permalink": None,
			"total_items_in_this_category": 3713,
			"path_from_root": [],
			"children_categories": [],
			"attribute_types": "attributes",
			"settings": {},
			"channels_settings": [],
			"meta_categ_id": None,
			"attributable": False,
			"date_created": "2018-04-25T08:12:56.000Z"
		}
	]
}

cd Mercado-Livre-Plants-Scraper

# Save `categories.json` in the scraper repository on Colab / Google Drive
with open('/content/drive/MyDrive/Colab_Notebooks/Mercado-Livre-Plants-Scraper/data/categories.json', 'w') as file:
    json.dump(categories_data, file, indent=4)

!ls '/content/drive/MyDrive'

import os
os.chdir ('/content/drive/MyDrive/Colab_Notebooks/Mercado-Livre-Plants-Scraper')

! virtualenv venv

!source venv/bin/activate

!ls /content/drive/MyDrive/Colab_Notebooks/Mercado-Livre-Plants-Scraper

# Commented out IPython magic to ensure Python compatibility.
# %cd /content/drive/MyDrive/Colab_Notebooks/Mercado-Livre-Plants-Scraper/src
!python3 main.py

!cat /content/Mercado-Livre-Plants-Scraper/data/categories.json

import pandas as pd
import os

# Connect to Google Drive
from google.colab import drive
drive.mount('/content/drive')

# Folder with the CSV files produced by the scraper
csv_dir = '/content/drive/MyDrive/Colab_Notebooks/Mercado-Livre-Plants-Scraper/outputs/csv'
excel_dir = '/content/drive/MyDrive/ml_excel_sheets'

# Create the output folder if it does not exist
os.makedirs(excel_dir, exist_ok=True)

# Convert each CSV file into a separate Excel file
for csv_name in os.listdir(csv_dir):
    if csv_name.endswith('.csv'):
        df = pd.read_csv(os.path.join(csv_dir, csv_name))
        # Output Excel file name
        excel_path = os.path.join(excel_dir, csv_name.replace('.csv', '.xlsx'))
        # Save the CSV content as Excel
        df.to_excel(excel_path, index=False)

print("Conversion finished. Excel files saved in:", excel_dir)