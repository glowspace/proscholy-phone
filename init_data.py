import requests
import json
import time

url = 'https://zpevnik.proscholy.cz/graphql'

headers = {'Content-type': 'application/json'}

all_data = {
    'query': '''query {
        authors {
            id
            name
        }
        tags_enum {
            id
            name
            type_enum
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
            name
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
                lilypond_svg
                lang
                lang_string
                type_enum
                has_chords
                song {
                    id
                }
                songbook_records {
                    pivot {
                        id
                        number
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
    song_lyrics_data['variables']['page'] = i + 1
    song_lyrics = json.loads(requests.post(url, headers=headers, data=json.dumps(song_lyrics_data)).content)['data']['search_song_lyrics']['data']

    if len(song_lyrics) == 0:
        break

    data['data']['song_lyrics'] += song_lyrics

    time.sleep(5)

with open('assets/data.json', 'w') as file:
    json.dump(data, file)