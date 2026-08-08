import json
from pathlib import Path

def read_json(p):
    raw = Path(p).read_bytes()
    for enc in ('utf-8-sig', 'utf-16', 'utf-8'):
        try:
            return json.loads(raw.decode(enc))
        except (UnicodeDecodeError, json.JSONDecodeError):
            continue
    raise ValueError(f'cannot decode {p}')

detect = read_json('graphify-out/.graphify_detect.json')
excluded_root = 'tools'

def keep(p):
    parts = Path(p).parts
    return not any(part == excluded_root for part in parts)

new_files = {}
for cat, lst in detect['files'].items():
    new_files[cat] = [p for p in lst if keep(p)]

# also drop unclassified entries under tools (they are not extracted anyway, but keep honest)
new_unclass = [p for p in detect.get('unclassified', []) if keep(p)]

detect['files'] = new_files
detect['unclassified'] = new_unclass
detect['total_files'] = sum(len(v) for v in new_files.values())
detect['total_words'] = 0  # recompute below

import re
total_words = 0
for cat, lst in new_files.items():
    if cat == 'code':
        continue  # words counted by AST not needed here
    for p in lst:
        try:
            text = Path(p).read_text(encoding='utf-8', errors='ignore')
            total_words += len(re.findall(r'\b\w+\b', text))
        except Exception:
            pass
# estimate code words too (rough)
for p in new_files.get('code', []):
    try:
        text = Path(p).read_text(encoding='utf-8', errors='ignore')
        total_words += len(re.findall(r'\b\w+\b', text))
    except Exception:
        pass
detect['total_words'] = total_words
detect.pop('warning', None)
detect['needs_graph'] = True
detect['warning'] = None

Path('graphify-out/.graphify_detect.json').write_text(json.dumps(detect, ensure_ascii=False, indent=2), encoding='utf-8')
print("Filtered detect:")
print("total_files:", detect['total_files'])
print("total_words:", detect['total_words'])
for cat, lst in new_files.items():
    print(f"  {cat}: {len(lst)}")
