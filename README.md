# Synonym & Antonym Finder (Assembly Language)

## Overview
A Console Application developed in x86 Assembly Language (MASM) that allows users to search for synonyms and antonyms of English words using text-based datasets.

The project demonstrates low-level programming concepts including file handling, string processing, memory management, user input validation, and procedural programming in Assembly Language.

## Features

- Search synonyms of a word
- Search antonyms of a word
- Input validation for English alphabet characters
- File-based dictionary lookup
- Interactive menu-driven interface
- Word normalization (uppercase to lowercase conversion)
- Error handling for invalid inputs and missing files

## Tech Stack

- x86 Assembly Language (MASM)
- Irvine32 Library
- Windows Console Application

## Project Structure

- `code 1.asm` – Main Assembly source code
- `synonyms.txt` – Dataset containing synonym mappings
- `antonyms.txt` – Dataset containing antonym mappings

## How It Works

1. User selects:
   - Find Synonyms
   - Find Antonyms
   - Exit

2. Program reads the entered word.

3. Input validation ensures only English alphabet characters are accepted.

4. The corresponding text file is loaded into memory.

5. The program searches for the word and extracts its synonym or antonym.

6. Results are displayed in the console.

## Learning Outcomes

- File I/O in Assembly Language
- String manipulation at low level
- Memory and buffer management
- Procedure creation and calling conventions
- Input validation techniques
- Assembly-based application development

## Future Improvements

- Larger dictionary datasets
- Multiple synonyms/antonyms per word
- Binary search for faster lookup
- GUI-based interface
- Support for phrases and sentences

## Authors

COAL (Computer Organization & Assembly Language) Semester Project
