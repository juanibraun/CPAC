import requests
import pandas as pd
import mido
from typing import Tuple
import time
from pythonosc.osc_server import BlockingOSCUDPServer
from pythonosc.udp_client import SimpleUDPClient
from pythonosc.dispatcher import Dispatcher


def print_handler(address, *args):
    print(f"{address}: {args}")

def default_handler(address, *args):
    if args[0] == "uruguay":
        note_creation_uruguay(args[1])
    elif args[0] == "spain":
        note_creation_spain(args[1])
    elif args[0] == "italy":
        note_creation_italy(args[1])


def note_variation(
        original_note: int,
        original_duration: int,
        population: float,
        reference: float
        ) -> Tuple[int, float]:
    modified_note = original_note
    ratio = population / reference
    if population > reference:
        if original_note != 0:
            modified_note = int(original_note * ratio)
            modified_note = modified_note if modified_note > -1 else 0
            modified_note = modified_note if modified_note < 128 else 127
        modified_duration  = int(original_duration - (original_duration**ratio) / 3)
        modified_duration = modified_duration if modified_duration > 0 else 0
    else:
        if original_note != 0:
            modified_note = int(original_note * ratio)
            modified_note = modified_note if modified_note > -1 else 0
            modified_note = modified_note if modified_note < 128 else 127
        modified_duration  = int(original_duration + (original_duration**ratio) / 3)
    modified_duration = modified_duration if modified_duration > 0 else 0
    print(modified_note)
    return modified_note, modified_duration

def note_creation_uruguay(population_type: str):
    # Define variable to load the dataframe
    dataframe = pd.read_excel(io="uruguay.xls", sheet_name="Data", skiprows=3)
    headers = dataframe.columns.values[4:]
    smooth_transition = 240

    # Pick data row from the dataframe
    if population_type == "urban":
        row = 27
    elif population_type == "rural":
        row = 28
    data = dataframe.values[row][4:]

    # Creating a dictionary
    population = {headers[i]: data[i] for i in range(len(headers))}

    # Defining references
    reference = population["1960"]

    # Midi file

    cumparsita = mido.MidiFile("URUGUAY.mid", clip=True)
    # Removing first 4 messages of the track 1 (setup ones)
    # then, getting len(population) * 5 of the remaining
    song = cumparsita.tracks[1][4:]
    song = [midi_message for midi_message in song if 'note' in midi_message.type]
    song = song[:len(population) * 7]

    # Accces to specific year:
    # year = xxxx
    # urban_population[str(year)]
    song_changed = song
    index = 0
    for year in headers:
        year_popu = population[year]
        for note in range(5):
            original_note = song[index * 5 + note].note
            original_duration = song[index * 5 + note].time
            moded_note, moded_duration = note_variation(original_note, original_duration, year_popu, reference)
            song_changed[index * 5 + note].note = moded_note
            song_changed[index * 5 + note].time = moded_duration + smooth_transition 
            message = song_changed[index * 5 + note]
            client_s.send_message("/adress", ["/" + str(message.type) + "/" +
                                              str(message.channel) + "/" +
                                              str(message.note) + "/" +
                                              str(message.velocity) + "/" +
                                              str(message.time) + "/"]
                                              )
            print(song_changed[index * 5 + note])
            time.sleep(float(moded_duration / 1000))
        index += 1

def note_creation_spain(population_type: str):
    # Define variable to load the dataframe
    dataframe = pd.read_excel(io="spain.xls", sheet_name="Data", skiprows=3)
    headers = dataframe.columns.values[4:]
    smooth_transition = 240

    # Pick data row from the dataframe
    if population_type == "urban":
        row = 27
    elif population_type == "rural":
        row = 28
    data = dataframe.values[row][4:]

    # Creating a dictionary
    population = {headers[i]: data[i] for i in range(len(headers))}

    # Defining references
    reference = population["1960"]

    # Midi file

    macarena = mido.MidiFile("SPAIN.mid", clip=True)
    # Removing first 4 messages of the track 1 (setup ones)
    # then, getting len(population) * 5 of the remaining
    song = macarena.tracks[1][9:]
    song = [midi_message for midi_message in song if 'note' in midi_message.type]
    song = song[:len(population) * 7]

    # Accces to specific year:
    # year = xxxx
    # urban_population[str(year)]
    song_changed = song
    index = 0
    for year in headers:
        year_popu = population[year]
        for note in range(5):
            original_note = song[index * 5 + note].note
            original_duration = song[index * 5 + note].time
            moded_note, moded_duration = note_variation(original_note, original_duration, year_popu, reference)
            song_changed[index * 5 + note].note = moded_note
            song_changed[index * 5 + note].time = moded_duration + smooth_transition 
            message = song_changed[index * 5 + note]
            client_s.send_message("/adress", ["/" + str(message.type) + "/" +
                                              str(message.channel) + "/" +
                                              str(message.note) + "/" +
                                              str(message.velocity) + "/" +
                                              str(message.time) + "/"]
                                              )
            print(song_changed[index * 5 + note])
            time.sleep(float(moded_duration / 1000))
        index += 1

def note_creation_italy(population_type: str):
    # Define variable to load the dataframe
    dataframe = pd.read_excel(io="italy.xls", sheet_name="Data", skiprows=3)
    headers = dataframe.columns.values[4:]
    smooth_transition = 270

    # Pick data row from the dataframe
    if population_type == "urban":
        row = 1026
    elif population_type == "rural":
        row = 1027
    data = dataframe.values[row][4:]

    # Creating a dictionary
    population = {headers[i]: data[i] for i in range(len(headers))}

    # Defining references
    reference = population["1960"]

    # Midi file

    saraperche = mido.MidiFile("ITALY.mid", clip=True)
    # Removing first 4 messages of the track 1 (setup ones)
    # then, getting len(population) * 5 of the remaining
    song = saraperche.tracks[1][8:]
    song = [midi_message for midi_message in song if 'note' in midi_message.type]
    song = song[:len(population) * 7]

    # Accces to specific year:
    # year = xxxx
    # urban_population[str(year)]
    song_changed = song
    index = 0
    for year in headers:
        year_popu = population[year]
        for note in range(5):
            original_note = song[index * 5 + note].note
            original_duration = song[index * 5 + note].time          
            moded_note, moded_duration = note_variation(original_note, original_duration, year_popu, reference)
            song_changed[index * 5 + note].note = moded_note
            song_changed[index * 5 + note].time = moded_duration + smooth_transition 
            message = song_changed[index * 5 + note]
            client_s.send_message("/adress", ["/" + str(message.type) + "/" +
                                              str(message.channel) + "/" +
                                              str(message.note) + "/" +
                                              str(message.velocity) + "/" +
                                              str(message.time) + "/"]
                                              )
            print(song_changed[index * 5 + note])
            time.sleep(float(moded_duration / 1000))
        index += 1


# Download of the required excels
# Uruguay:
url = 'https://api.worldbank.org/v2/en/country/URY?downloadformat=excel'
r = requests.get(url, allow_redirects=True)
open('uruguay.xls', 'wb').write(r.content)

# Spain:
url = 'https://api.worldbank.org/v2/en/country/ESP?downloadformat=excel'
r = requests.get(url, allow_redirects=True)
open('spain.xls', 'wb').write(r.content)

# Italy:
url = 'https://api.worldbank.org/v2/en/country/ITA?downloadformat=excel'
r = requests.get(url, allow_redirects=True)
open('italy.xls', 'wb').write(r.content)

# UTC client receive
ip = "127.0.0.1"
dispatcher = Dispatcher()
dispatcher.map("/something/*", print_handler)
dispatcher.set_default_handler(default_handler)
port = 5005
server = BlockingOSCUDPServer((ip, port), dispatcher)

# UTC client sender 
ip_s = "127.0.0.1"
port_s = 7772
client_s = SimpleUDPClient(ip_s, port_s)  # Create client

server.serve_forever()  # Create datagram endpoint and start serving
