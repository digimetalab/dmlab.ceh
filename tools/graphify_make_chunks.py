import json, pathlib

uncached = pathlib.Path('graphify-out/.graphify_uncached.txt').read_text(encoding='utf-8').splitlines()
uncached = [l for l in uncached if l]

# order: skills alphabetical, then root docs, then report, then results
skills = sorted([p for p in uncached if 'offensive-' in p])
others = [p for p in uncached if 'offensive-' not in p]
files = skills + others
print('total:', len(files))

# 3 chunks, group adjacent (skills stay together)
chunks = [files[0:22], files[22:44], files[44:]]
for i, chunk in enumerate(chunks, start=1):
    path = f'graphify-out/.graphify_chunk_list_{i:02d}.txt'
    pathlib.Path(path).write_text('\n'.join(chunk), encoding='utf-8')
    print(f'chunk {i}: {len(chunk)} files')
