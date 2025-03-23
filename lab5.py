import json
import pandas as pd

with open('data/schacon.repos.json', 'r') as file:
    data = json.load(file)
repos = []
for repo in data[0:5]:
    name = repo.get('name')
    html_url = repo.get('html_url')
    updated_at = repo.get('updated_at')
    visibility = repo.get('visibility')
    repos.append([name, html_url, updated_at, visibility])
df = pd.DataFrame(repos, columns=['name', 'html_url', 'updated_at', 'visibility'])
df.to_csv('chacon.csv', index=False, header=False)
print(df.head())
