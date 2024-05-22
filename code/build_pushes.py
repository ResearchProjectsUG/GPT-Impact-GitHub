import pandas as pd
import pycountry
from countryinfo import CountryInfo as CInfo

import os

# Get the path to the directory of the current script
current_file_directory = os.path.dirname(__file__)

# Change the current working directory to the script's directory
os.chdir(current_file_directory)

# Now, the current directory is set to where the script is located
print("Current Working Directory is now:", os.getcwd())


# clean git pushes

pushes_data = pd.read_csv("https://raw.githubusercontent.com/github/innovationgraph/main/data/git_pushes.csv")

country_data_counts = pushes_data.groupby(["iso2_code"]).count().reset_index()

full_country_codes = country_data_counts[country_data_counts.git_pushes == country_data_counts.git_pushes.max()]["iso2_code"].reset_index(drop = True)

pushes_data_clean = pushes_data[pushes_data.iso2_code.isin(full_country_codes)]

pushes_data_clean = pushes_data_clean[pushes_data_clean.iso2_code != "EU"]

pushes_data_clean = pushes_data_clean[pushes_data_clean.iso2_code != "XK"]


# Convert country names to iso2 codes using pycountry
def country_to_iso2(country_name):
    try:
        return pycountry.countries.get(name=country_name).alpha_2
    except AttributeError:
        try:
            # Handle special cases where the country name doesn't match pycountry's database exactly
            special_cases = {
                "Czechia (Czech Republic)": "CZ",
                "Congo (Congo-Brazzaville)": "CG",
                "Holy See": "VA",
                "Timor-Leste (East Timor)": "TL",
                "Ukraine (with certain exceptions)": "UA",
                "Taiwan": "TW", 
                "Bolivia": "BO",
                "Tanzania": "TZ",
                "South Korea": "KR",
                "Moldova": "MD", 
                "Brunei": "BN"

            }
            return special_cases[country_name]
        except KeyError:
            return None

gpt_countries_list = [
    "Albania", "Algeria", "Andorra", "Angola", "Antigua and Barbuda", "Argentina", "Armenia", "Australia", "Austria",
    "Azerbaijan", "Bahamas", "Bangladesh", "Barbados", "Belgium", "Belize", "Benin", "Bhutan", "Bolivia",
    "Bosnia and Herzegovina", "Botswana", "Brazil", "Brunei", "Bulgaria", "Burkina Faso", "Cabo Verde", "Canada",
    "Chile", "Colombia", "Comoros", "Congo (Congo-Brazzaville)", "Costa Rica", "Côte d'Ivoire", "Croatia", "Cyprus",
    "Czechia", "Denmark", "Djibouti", "Dominica", "Dominican Republic", "Ecuador", "El Salvador", "Estonia", "Fiji",
    "Finland", "France", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Greece", "Grenada", "Guatemala", "Guinea",
    "Guinea-Bissau", "Guyana", "Haiti", "Holy See", "Honduras", "Hungary", "Iceland", "India", "Indonesia", "Iraq",
    "Ireland", "Israel", "Italy", "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "Kuwait",
    "Kyrgyzstan", "Latvia", "Lebanon", "Lesotho", "Liberia", "Liechtenstein", "Lithuania", "Luxembourg", "Madagascar",
    "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall Islands", "Mauritania", "Mauritius", "Mexico",
    "Micronesia", "Moldova", "Monaco", "Mongolia", "Montenegro", "Morocco", "Mozambique", "Myanmar", "Namibia",
    "Nauru", "Nepal", "Netherlands", "New Zealand", "Nicaragua", "Niger", "Nigeria", "North Macedonia", "Norway",
    "Oman", "Pakistan", "Palau", "Palestine, State of", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines",
    "Poland", "Portugal", "Qatar", "Romania", "Rwanda", "Saint Kitts and Nevis", "Saint Lucia",
    "Saint Vincent and the Grenadines", "Samoa", "San Marino", "Sao Tome and Principe", "Saudi Arabia", "Senegal",
    "Serbia", "Seychelles", "Sierra Leone", "Singapore", "Slovakia", "Slovenia", "Solomon Islands", "South Africa",
    "South Korea", "Spain", "Sri Lanka", "Suriname", "Sweden", "Switzerland", "Taiwan", "Tanzania", "Thailand",
    "Timor-Leste", "Togo", "Tonga", "Trinidad and Tobago", "Tunisia", "Turkey", "Tuvalu", "Uganda", "Ukraine",
    "United Arab Emirates", "United Kingdom", "United States", "Uruguay", "Vanuatu", "Zambia"
]

gpt_countries_iso = [country_to_iso2(country) for country in gpt_countries_list]

pushes_data_clean["gpt_available"] = pushes_data_clean["iso2_code"].apply(lambda row: 1 if row in gpt_countries_iso else 0)

# Create post_1 and post_2 variables
pushes_data_clean['post_1'] = ((pushes_data_clean['year'] == 2022) & (pushes_data_clean['quarter'] >= 4)) | (pushes_data_clean['year'] > 2022)
pushes_data_clean['post_2'] = pushes_data_clean['year'] >= 2023

# Convert post_1 and post_2 to binary dummies
pushes_data_clean['post_1'] = pushes_data_clean['post_1'].astype(int)
pushes_data_clean['post_2'] = pushes_data_clean['post_2'].astype(int)

pushes_data_clean.reset_index(drop = True, inplace = True)

pushes_data_clean["gpt_available_post1"] = pushes_data_clean["gpt_available"] * pushes_data_clean["post_1"]
pushes_data_clean["gpt_available_post2"] = pushes_data_clean["gpt_available"] * pushes_data_clean["post_2"]

pushes_data_clean["year_quarter_num"] = (pushes_data_clean["year"] - 2020) * 4 + pushes_data_clean["quarter"]

countries = pushes_data_clean.iso2_code.unique()

def create_populations_dictionary():
    country_populations = {}
    special_cases = {"MM": 54688774, "PS": 5483450, "ME": 602445}
    for country in countries:
        try:
            country_populations.update({country: CInfo(country).info()["population"]})
        except KeyError:
            try:
                fallback_name = pycountry.countries.lookup(country).name
                country_populations.update({country: CInfo(fallback_name).info()["population"]})
            except KeyError:
                country_populations.update({country: special_cases[country]})
                

    return country_populations

country_populations = create_populations_dictionary()

pushes_data_clean["population"] = pushes_data_clean["iso2_code"].map(country_populations)
pushes_data_clean["pushes_pc"] = pushes_data_clean["git_pushes"] / pushes_data_clean["population"]

developers = pd.read_csv("https://raw.githubusercontent.com/github/innovationgraph/main/data/developers.csv")
repositories = pd.read_csv("https://raw.githubusercontent.com/github/innovationgraph/main/data/repositories.csv")


push_dev_data = pd.merge(pushes_data_clean, developers, how="left", on=["iso2_code", "year", "quarter"])
main_data = pd.merge(push_dev_data, repositories, how="left", on=["iso2_code", "year", "quarter"])


main_data["developers_pc"] = main_data["developers"] / main_data["population"]
main_data["repositories_pc"] = main_data["repositories"] / main_data["population"]

main_data["pushes_perdev"] = main_data["git_pushes"] / main_data["developers"]


main_data.to_csv("../output/data/pushes.csv", index=False)

