#!/usr/bin/env python3
"""Cross-reference every send/receive/value name across all repo patch files."""
import json, glob, os, sys
from collections import defaultdict

root = sys.argv[1]
files = sorted(glob.glob(os.path.join(root, "patches", "*.maxpat")))
senders = defaultdict(list)
receivers = defaultdict(list)
values = defaultdict(list)


def walk(p, path, fname):
    for e in p.get("boxes", []):
        b = e["box"]
        t = (b.get("text") or "").split()
        if t:
            o = t[0]
            if o in ("s", "send", "forward") and len(t) > 1:
                senders[t[1]].append(f"{fname}{path}")
            elif o in ("r", "receive") and len(t) > 1:
                receivers[t[1]].append(f"{fname}{path}")
            elif o in ("v", "value", "pv") and len(t) > 1:
                values[t[1]].append(f"{fname}{path}")
        if "patcher" in b:
            name = " ".join(t[1:]) if t and t[0] == "p" else (t[0] if t else b.get("maxclass"))
            walk(b["patcher"], f"{path}/{name}", fname)


for f in files:
    d = json.load(open(f, encoding="utf-8"))
    walk(d["patcher"], "", os.path.basename(f).replace(".maxpat", ""))

names = sorted(set(senders) | set(receivers))
print(f"{'name':28s} {'senders':55s} receivers")
for n in names:
    s = sorted(set(senders.get(n, [])))
    r = sorted(set(receivers.get(n, [])))
    flag = ""
    if not s:
        flag = "  <-- NO SENDER anywhere (dead receive or set by UI/pattr)"
    if not r:
        flag = "  <-- NO RECEIVER anywhere (dead send)"
    print(f"{n:28s} {', '.join(s)[:55]:55s} {', '.join(r)}{flag}")
if values:
    print("\nvalue/pv objects:")
    for n, ps in sorted(values.items()):
        print(f"  {n}: {sorted(set(ps))}")
