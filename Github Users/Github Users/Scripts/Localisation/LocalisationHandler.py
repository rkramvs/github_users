import json
import os
import sys
import copy

# Placeholder for the translators module.
import translators as ts

def translate_text(source_text, to_language):
    # Placeholder function for text translation. Implement actual translation here.
    
    translator = 'google'  # Example; replace with actual usage.
    translatorLanguage = to_language
    
    if to_language == "zh-Hant":
        translatorLanguage = "zh-TW"
        
    if to_language == "zh-Hans":
        translatorLanguage = "zh-CN"
    
    print("Localisation")
    return ts.translate_text(query_text=source_text, translator=translator, to_language=translatorLanguage)


def process_localization_file(file_path, target_languages):
    print(f"Processing file: {file_path}")
        
    if not os.path.exists(file_path):
        print(f"File not found: {file_path}. Skipping...")
        return
    
    # Load the localization file
    with open(file_path, "r") as file:
        data = json.load(file)
    
    for string_key, string_value in data['strings'].items():
        englishDict = string_value.get('localizations', {}).get('en', {})
        for lang in target_languages:
        # Pluralise words will handled here
            if englishDict:
                currentlanguage = string_value.get('localizations', {}).get(lang, {})
                if currentlanguage:
                    print("Handle existing localization case")
                    if currentlanguage.get('stringUnit', {}) and currentlanguage['stringUnit']["state"] != "translated":
                        string_value['localizations'][lang]['stringUnit']['value'] = translate_text(englishDict['stringUnit']['value'], lang)
#
                    variation = currentlanguage.get('variations', {})
                
                    if variation:
                        pluralVariation = variation.get('plural', {})
#
                        if pluralVariation.get('one', {}).get('stringUnit', {}).get('value') and pluralVariation['one']['stringUnit']['state'] != "translated":
                            string_value['localizations'][lang]['variations']['plural']['one']['stringUnit']['value'] = translate_text(englishDict['variations']['plural']['one']['stringUnit']['value'], lang)
#
                        if pluralVariation.get('other', {}).get('stringUnit', {}).get('value') and pluralVariation['other']['stringUnit']['state'] != "translated":

                            string_value['localizations'][lang]['variations']['plural']['other']['stringUnit']['value'] = translate_text(englishDict['variations']['plural']['other']['stringUnit']['value'], lang)
#
                else:
                    if string_value.get('localizations', {}).get(lang, {}).get('stringUnit', {}).get('value') and string_value['localizations'][lang]['stringUnit']['state'] != "translated":
                    
                        string_value['localizations'][lang] = copy.deepcopy(string_value['localizations']['en'])
                    
                        string_value['localizations'][lang] = copy.deepcopy(string_value['localizations']['en'])
                        string_value['localizations'][lang]['stringUnit']['value'] = translate_text(englishDict['stringUnit']['value'], lang)
                        string_value['localizations'][lang]['stringUnit']['state'] = 'translated'
                    
                        variation = string_value.get('localizations', {}).get(lang, {}).get('variations', {})
                        pluralVariation = variation.get('plural', {})
                    
                        if pluralVariation.get('one', {}).get('stringUnit', {}).get('value'):
                            string_value['localizations'][lang]['variations']['plural']['one']['stringUnit']['value'] = translate_text(englishDict['variations']['plural']['one']['stringUnit']['value'], lang)
                            string_value['localizations'][lang]['variations']['plural']['one']['stringUnit']['state'] = 'translated'
                    
                        if pluralVariation.get('other', {}).get('stringUnit', {}).get('value'):
                            string_value['localizations'][lang]['variations']['plural']['other']['stringUnit']['value'] = translate_text(englishDict['variations']['plural']['other']['stringUnit']['value'], lang)
                            string_value['localizations'][lang]['variations']['plural']['other']['stringUnit']['state'] = 'translated'
            else:
                if 'localizations' not in string_value:
                    string_value['localizations'] = {}
                source_text = string_value['localizations']['en']['stringUnit']['value'] if 'en' in string_value['localizations'] else string_key
                if lang not in string_value['localizations'] or string_value['localizations'][lang]['stringUnit']['state'] != 'translated':
                    translated_value = translate_text(source_text, lang)
                    string_value['localizations'][lang] = {"stringUnit": {"state": "translated", "value": translated_value}}

# Write the updated JSON back to the file
    with open(file_path, 'w') as file:
        json.dump(data, file, indent=4)
    
    print(f"Completed processing file: {file_path}")


print("Localization Migration Started")

srcroot = os.environ.get('SRCROOT')
file_name = "Localizable.xcstrings"
print(f"srcroot: {srcroot}")

localization_file_paths = [f"{srcroot}/Github Users/Localisation/{file_name}"]
                           
#Language Supported by the translators

#['aa', 'ab', 'ace', 'ach', 'af', 'ak', 'alz', 'am', 'ar', 'as', 'auto', 'av', 'awa', 'ay', 'az', 'ba', 'bal', 'ban', 'bbc', 'bci', 'be', 'bem', 'ber', 'ber-Latn', 'bew', 'bg', 'bho', 'bik', 'bm', 'bm-Nkoo', 'bn', 'bo', 'br', 'bs', 'bts', 'btx', 'bua', 'ca', 'ce', 'ceb', 'cgg', 'ch', 'chk', 'chm', 'ckb', 'cnh', 'co', 'crh', 'crs', 'cs', 'cv', 'cy', 'da', 'de', 'din', 'doi', 'dov', 'dv', 'dyu', 'dz', 'ee', 'el', 'en', 'en-US', 'eo', 'es', 'et', 'eu', 'fa', 'fa-AF', 'ff', 'fi', 'fj', 'fo', 'fon', 'fr', 'fur', 'fy', 'ga', 'gaa', 'gd', 'gl', 'gn', 'gom', 'gu', 'gv', 'ha', 'haw', 'hi', 'hil', 'hmn', 'hr', 'hrx', 'ht', 'hu', 'hy', 'iba', 'id', 'ig', 'ilo', 'is', 'it', 'iw', 'ja', 'jam', 'jw', 'ka', 'kac', 'kek', 'kg', 'kha', 'kk', 'kl', 'km', 'kn', 'ko', 'kr', 'kri', 'ktu', 'ku', 'kv', 'ky', 'la', 'lb', 'lg', 'li', 'lij', 'lmo', 'ln', 'lo', 'lt', 'ltg', 'luo', 'lus', 'lv', 'mad', 'mai', 'mak', 'mam', 'mfe', 'mg', 'mh', 'mi', 'min', 'mk', 'ml', 'mn', 'mni-Mtei', 'mr', 'ms', 'ms-Arab', 'mt', 'mwr', 'my', 'ndc-ZW', 'ne', 'new', 'nhe', 'nl', 'no', 'nr', 'nso', 'nus', 'ny', 'oc', 'om', 'or', 'os', 'pa', 'pa-Arab', 'pag', 'pam', 'pap', 'pl', 'ps', 'pt', 'pt-PT', 'qu', 'rn', 'ro', 'rom', 'ru', 'rw', 'sa', 'sah', 'sat-Latn', 'scn', 'sd', 'se', 'sg', 'shn', 'si', 'sk', 'sl', 'sm', 'sn', 'so', 'sq', 'sr', 'ss', 'st', 'su', 'sus', 'sv', 'sw', 'szl', 'ta', 'tcy', 'te', 'tet', 'tg', 'th', 'ti', 'tiv', 'tk', 'tl', 'tn', 'to', 'tpi', 'tr', 'trp', 'ts', 'tt', 'tum', 'ty', 'tyv', 'udm', 'ug', 'uk', 'ur', 'uz', 've', 'vec', 'vi', 'war', 'wo', 'xh', 'yi', 'yo', 'yua', 'yue', 'zap', 'zh-CN', 'zh-TW', 'zu']

target_languages = [ "ja"]
    
for file_path in localization_file_paths:
    process_localization_file(file_path, target_languages)

print("Localization migration completed successfully.")
sys.exit(0)

