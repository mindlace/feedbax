#!/usr/bin/env python3
"""maxdiff — structural diff of two Max patchers.

Usage: maxdiff.py A.maxpat[::subpath] B.maxpat[::subpath] [--deep]

subpath selects a nested subpatcher by the `p NAME` text, e.g. ::picsVid or ::picsVid/chro.
Compares boxes (by id → (maxclass,text,key attrs)) and lines (by id tuple), recursively.
"""
import json
import sys

IGNORE = {"patching_rect", "presentation_rect", "fontsize", "fontname", "fontface", "linecount",
          "presentation_linecount", "patching_linecount", "id", "patcher", "textcolor", "bgcolor",
          "color", "style", "saved_attribute_attributes", "parameter_enable", "bordercolor",
          "presentation", "outlettype", "numinlets", "numoutlets", "hidden", "annotation",
          "annotation_name", "varname"}


def load(spec):
    path, _, sub = spec.partition("::")
    doc = json.load(open(path, encoding="utf-8"))
    p = doc["patcher"]
    if sub:
        for part in sub.split("/"):
            found = None
            for e in p["boxes"]:
                b = e["box"]
                t = b.get("text", "")
                if t == f"p {part}" or t == part or t.split(" ")[0] == part:
                    if "patcher" in b:
                        found = b["patcher"]
                        break
            if not found:
                sys.exit(f"subpatcher {part} not found in {path}")
            p = found
    return p


def canon_box(b):
    t = b.get("text")
    d = {k: v for k, v in b.items() if k not in IGNORE}
    if "saved_object_attributes" in d:
        d["saved_object_attributes"] = {k: v for k, v in d["saved_object_attributes"].items()}
    return json.dumps(d, sort_keys=True)


def label(b):
    t = b.get("text")
    if t is None:
        t = b.get("maxclass")
        if b.get("maxclass") == "attrui":
            t = "attrui " + str(b.get("attr"))
    return t.replace("\n", " ")[:70]


def diff(pa, pb, path, out, deep):
    ba = {e["box"]["id"]: e["box"] for e in pa.get("boxes", [])}
    bb = {e["box"]["id"]: e["box"] for e in pb.get("boxes", [])}
    la = {(l["patchline"]["source"][0], l["patchline"]["source"][1], l["patchline"]["destination"][0], l["patchline"]["destination"][1]) for l in pa.get("lines", [])}
    lb = {(l["patchline"]["source"][0], l["patchline"]["source"][1], l["patchline"]["destination"][0], l["patchline"]["destination"][1]) for l in pb.get("lines", [])}
    hdr = f"## {path}  A: {len(ba)} boxes/{len(la)} lines   B: {len(bb)} boxes/{len(lb)} lines"
    lines = []
    for i in sorted(set(ba) - set(bb)):
        lines.append(f"  - box only in A: [{i}] {label(ba[i])}")
    for i in sorted(set(bb) - set(ba)):
        lines.append(f"  + box only in B: [{i}] {label(bb[i])}")
    for i in sorted(set(ba) & set(bb)):
        a, b = ba[i], bb[i]
        if label(a) != label(b):
            lines.append(f"  ~ text changed [{i}]: {label(a)!r} -> {label(b)!r}")
        elif deep and canon_box(a) != canon_box(b):
            da = {k: v for k, v in a.items() if k not in IGNORE}
            db = {k: v for k, v in b.items() if k not in IGNORE}
            ch = {k: (da.get(k), db.get(k)) for k in set(da) | set(db) if da.get(k) != db.get(k)}
            s = json.dumps(ch)
            lines.append(f"  ~ attrs changed [{i}] {label(a)}: {s[:300]}")
    def fl(l, boxes):
        s, so, d, di = l
        return f"[{s} {label(boxes[s]) if s in boxes else '?'}]:{so} -> [{d} {label(boxes[d]) if d in boxes else '?'}]:{di}"
    for l in sorted(la - lb):
        lines.append(f"  - line only in A: {fl(l, ba)}")
    for l in sorted(lb - la):
        lines.append(f"  + line only in B: {fl(l, bb)}")
    if lines:
        out.append(hdr)
        out.extend(lines)
    else:
        out.append(hdr + "   (identical)")
    # recurse into shared subpatchers
    for i in sorted(set(ba) & set(bb)):
        a, b = ba[i], bb[i]
        if "patcher" in a and "patcher" in b:
            diff(a["patcher"], b["patcher"], f"{path}/{label(a)}#{i}", out, deep)
        elif "patcher" in a and "patcher" not in b:
            out.append(f"  ! [{i}] {label(a)}: A has inline patcher, B does not")
        elif "patcher" in b and "patcher" not in a:
            out.append(f"  ! [{i}] {label(b)}: B has inline patcher, A does not")


if __name__ == "__main__":
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    deep = "--deep" in sys.argv
    pa, pb = load(args[0]), load(args[1])
    out = []
    diff(pa, pb, "/", out, deep)
    print("\n".join(out))
