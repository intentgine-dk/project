from func.t_analysis import reader, cleaner, compute, file
from func import gdrive
import os

def word_count(directory_id, output_path, elements):
    g_auth = gdrive.google_auth()
    cwd = os.getcwd()
    special_characters = cwd + "\\files\\conf\\special_chars.txt"
    excluded_words = cwd + "\\files\\conf\\excluded_words.txt"
    file.check_file(special_characters)
    file.check_file(excluded_words)
 
    titles = gdrive.dl_dir_files(g_auth, directory_id)
    for title in titles:
        info = reader.pdf_info(title)
        file.check_file(title)
        input_string = reader.convert_pdf_to_txt(title)
        sc_dict = reader.file_to_dict(special_characters, " ")
        ew_dict = reader.file_to_dict(excluded_words, " ")
        output_string = cleaner.remove_special_character(input_string, sc_dict)
        output_string = cleaner.remove_excluded_words(output_string, ew_dict)
        word_dict = compute.string_counter(output_string, elements)
        results = compute.filter_word_count(word_dict)
        file.pdf_report(output_path, results, info, title)
        os.remove(title)

word_count('1Ub6DCJTIw0U5XGUEPChydn6bmKV8VCD_', 'C:\\Users\\donnv\\Desktop\\', 2)
