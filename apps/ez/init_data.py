import gzip
import io
import requests
import json
import time
import zipfile

url = 'https://zpevnik.proscholy.cz/graphql'

headers = {'Content-type': 'application/json', 'Filter-Content': 'ez'}

all_data = {
    'query': '''query {
        authors {
            id
            name
        }
        songbooks {
            id
            name
            shortcut
            color
            color_text
            is_private
        }
        songs {
            id
        }
    }'''
}
song_lyrics_data = {
    'query': '''query($page: Int, $per_page: Int, $search_params: String) {
        search_song_lyrics(page: $page, per_page: $per_page, search_params: $search_params) {
            data {
                id
                name
                secondary_name_1
                secondary_name_2
                lyrics
                hymnology
                lang
                lang_string
                type_enum
                is_arrangement
                has_chords
                song {
                    id
                }
                songbook_records {
                    pivot {
                        id
                        number
                        song_name
                        song_lyric {
                            id
                        }
                        songbook {
                            id
                        }
                    }
                }
                externals {
                    id
                    public_name
                    url
                    media_id
                    media_type
                }
                authors_pivot {
                    pivot {
                        author {
                            id
                        }
                    }
                }
                tags {
                    id
                }
            }
        }
    }''',
    'variables': {
        'page': 1,
        'per_page': 100,
        'search_params': '{"sort":[{"song_number_integer":{"order":"asc"}}],"query":{"bool":{"must":[],"should":[],"filter":[{"term":{"is_arrangement":{"value":false}}}]}},"min_score":0}'
    }
}

data = json.loads(requests.post(url, headers=headers, data=json.dumps(all_data)).content)
data['data']['song_lyrics'] = []

for i in range(100):
    print(i)
    song_lyrics_data['variables']['page'] = i + 1
    song_lyrics = json.loads(requests.post(url, headers=headers, data=json.dumps(song_lyrics_data)).content)['data']['search_song_lyrics']['data']

    if len(song_lyrics) == 0:
        break

    data['data']['song_lyrics'] += song_lyrics

    time.sleep(0.1)

# only authors of song lyrics in the app
author_ids = {
    author['pivot']['author']['id'] for song_lyric in data['data']['song_lyrics'] for author in song_lyric['authors_pivot']
}
data['data']['authors'] = [author for author in data['data']['authors'] if author['id'] in author_ids]

# compressed and without escaped characters, as the app keeps it in its assets
with gzip.open('assets/data.json.gz', 'wt', encoding='utf-8') as file:
    json.dump(data, file, ensure_ascii=False, separators=(',', ':'))

# server exports empty archive at the moment, the archive in assets is kept then
svgs = requests.get('https://zpevnik.proscholy.cz/download-svgs', headers=headers).content

if not zipfile.ZipFile(io.BytesIO(svgs)).namelist():
    with open('assets/svg.zip', 'rb') as file:
        svgs = file.read()

# only music notes of song lyrics in the app
song_lyric_ids = {song_lyric['id'] for song_lyric in data['data']['song_lyrics']}

with zipfile.ZipFile(io.BytesIO(svgs)) as source, zipfile.ZipFile('assets/svg.zip', 'w') as target:
    # archive might contain a file more times, the app keeps the last one
    for info in {info.filename: info for info in source.infolist()}.values():
        if info.filename.split('.')[0] in song_lyric_ids:
            target.writestr(info, source.read(info))
