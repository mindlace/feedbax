#!/usr/bin/env python3
"""maxpat2txt — render a Max .maxpat JSON file as a readable dataflow listing.

Usage:
  maxpat2txt.py PATCH.maxpat [--summary] [--patcher NAME] [--maxdepth N] [--no-lines]

Walks the patcher recursively (subpatchers `p foo`, gen/jit.gl.pix/jit.gen/gen~
embedded patchers, poly~, bpatcher with inline patcher). For each patcher prints:
  * boxes:  [id] maxclass "text"  {notable attributes}
  * lines:  [src-id "text"]:outlet -> [dst-id "text"]:inlet
and a summary of external references (files, send/receive names, jit.gl contexts).
"""
import json
import re
import sys
from collections import Counter, defaultdict

NOISE_KEYS = {
    "id", "maxclass", "numinlets", "numoutlets", "patching_rect", "presentation_rect",
    "presentation", "outlettype", "text", "patcher", "fontname", "fontsize", "fontface",
    "style", "textcolor", "bgcolor", "color", "hidden", "ignoreclick", "linecount",
    "saved_attribute_attributes", "parameter_enable", "varname", "bordercolor",
    "background", "presentation_linecount", "patching_linecount", "gradient",
    "textjustification", "fontweight", "rounded", "border", "htricolor", "htabcolor",
    "tabcolor", "bgfillcolor_type", "bgfillcolor_color", "bgfillcolor_color1",
    "bgfillcolor_color2", "bgfillcolor_angle", "bgfillcolor_proportion",
    "bgfillcolor_autogradient", "bgfillcolor_pic", "bgoncolor", "outlinecolor",
    "knobcolor", "elementcolor", "slidercolor", "tricolor", "tricolor2", "hltcolor",
    "accentcolor", "bubbleside", "bubble", "bubblepoint", "bubbletextmargin",
    "arrows", "arrowlink", "autofit", "pic", "mode", "bordercolor", "textcolor",
    "floatoutput", "shape", "autosize", "blinktime", "checkedcolor", "uncheckedcolor",
    "textoncolor", "textoffcolor", "numcols", "numrows", "interpinlet", "interp",
    "appearance", "activebgcolor", "activebgoncolor", "activeneedlecolor",
    "needlecolor", "activeslidercolor", "activetricolor", "activetricolor2",
    "orientation", "thickness", "proportion", "spacing", "margin", "annotation",
    "annotation_name", "hint", "comment", "hintcolor", "prototypename", "fontnamestyle",
    "arrowcolor", "arrowframecolor", "arrowbgcolor", "arrowlinkcolor",
    "showname", "showtext", "triscale", "trianglecolor", "offset", "mouseup", "pattrmode",
    "format", "allowdrag", "keymode", "tabletmode", "hbgcolor", "htextcolor", "htricolor",
    "linecolor", "framecolor", "textbgcolor", "activebordercolor", "activetextcolor",
    "activetextoncolor", "trackborder", "tracking", "gridlines", "bgsteps", "grid",
    "boxgroups", "gradientcolor", "borderoncolor", "activeborderoncolor",
    "scale", "showcross", "ignoreclick", "visible", "enablehscroll", "enablevscroll",
    "openinpresentation", "default_fontsize", "default_fontname", "default_fontface",
    "gridonopen", "gridsize", "gridsnaponopen", "objectsnaponopen", "statusbarvisible",
    "toolbarvisible", "lefttoolbarpinned", "toptoolbarpinned", "righttoolbarpinned",
    "bottomtoolbarpinned", "toolbars_unpinned_last_save", "tallnewobj", "boxanimatetime",
    "enablehscroll", "enablevscroll", "devicewidth", "description", "digest", "tags",
    "rect", "bglocked", "fileversion", "appversion", "classnamespace", "autosave",
    "dependency_cache", "assistshowspatchername", "bgbits", "fontnames", "showontab",
    "parameters", "data", "embed", "showsnapshot", "editor_rect", "saved_object_attributes",
}

EXT_RE = re.compile(r"[\w./\-+~ ]+\.(jxs|jxp|png|jpg|jpeg|gif|mov|mp4|m4v|js|json|txt|coll|maxpat|genjit|gendsp|maxhelp|aif|aiff|wav|mp3|svg|pdf|bmp|tif|tiff|mxo|mxe)\b", re.I)


class Summary:
    def __init__(self):
        self.files = Counter()
        self.sends = defaultdict(set)     # name -> {patcher paths}
        self.receives = defaultdict(set)
        self.values = defaultdict(set)
        self.glctx = defaultdict(set)     # context -> {objects}
        self.classes = Counter()
        self.patchers = []
        self.js_objects = []
        self.missing_bpatchers = []

    def note_text(self, text, path):
        for m in EXT_RE.finditer(text):
            self.files[m.group(0).strip()] += 1

    def note_box(self, box, text, path):
        cls = box.get("maxclass", "?")
        head = text.split(" ")[0] if text else cls
        self.classes[head if cls == "newobj" else cls] += 1
        toks = text.split() if text else []
        if not toks:
            return
        obj = toks[0]
        if obj in ("s", "send", "forward") and len(toks) > 1:
            self.sends[toks[1]].add(path)
        elif obj in ("r", "receive") and len(toks) > 1:
            self.receives[toks[1]].add(path)
        elif obj in ("v", "value", "pv", "pattr") and len(toks) > 1:
            self.values[toks[1]].add(path)
        elif obj.startswith("jit.gl.") or obj in ("jit.window", "jit.pwindow"):
            ctx = None
            for t in toks[1:]:
                if not t.startswith("@"):
                    ctx = t
                    break
            if obj == "jit.window" or obj == "jit.gl.render":
                ctx = toks[1] if len(toks) > 1 and not toks[1].startswith("@") else ctx
            self.glctx[ctx or "(none)"].add(obj)
        if obj in ("js", "jsui", "node.script", "mxj", "coll", "text", "dict", "table", "buffer~", "jit.gl.lua"):
            self.js_objects.append((path, text))


def attrs_of(box):
    out = {}
    for k, v in box.items():
        if k in NOISE_KEYS:
            continue
        if isinstance(v, (dict, list)) and len(json.dumps(v)) > 300:
            out[k] = f"<{type(v).__name__} len={len(v)}>"
        else:
            out[k] = v
    # keep a few interesting ones even though they are "noise"
    for k in ("varname", "text"):
        pass
    if "varname" in box:
        out["varname"] = box["varname"]
    soa = box.get("saved_object_attributes")
    if soa:
        small = {k: v for k, v in soa.items() if len(json.dumps(v)) < 200}
        if small:
            out["saved_object_attributes"] = small
    if "saved_attribute_attributes" in box:
        saa = box["saved_attribute_attributes"]
        try:
            exprs = {k: v.get("expression") for k, v in saa.items() if isinstance(v, dict) and v.get("expression")}
            if exprs:
                out["param_expr"] = exprs
        except Exception:
            pass
    return out


def fmt_attrs(a):
    if not a:
        return ""
    parts = []
    for k, v in a.items():
        s = json.dumps(v) if not isinstance(v, str) else v
        if len(s) > 160:
            s = s[:157] + "..."
        parts.append(f"{k}={s}")
    return "  {" + ", ".join(parts) + "}"


def box_label(box):
    cls = box.get("maxclass", "?")
    text = box.get("text")
    if text is None:
        # UI objects: give a useful label
        if cls == "comment":
            text = box.get("text", "")
        elif cls in ("flonum", "number"):
            text = f"{cls}"
        elif cls == "attrui":
            text = f"attrui {box.get('attr', '')}"
        elif cls == "umenu":
            items = box.get("items")
            text = f"umenu {items}" if items else "umenu"
        elif cls == "message":
            text = ""
        elif cls == "bpatcher":
            text = f"bpatcher {box.get('name', '')}"
        else:
            text = cls
    else:
        if cls == "message":
            text = f'msg "{text}"'
        elif cls == "comment":
            text = f"// {text}"
        elif cls == "attrui":
            text = f"attrui {box.get('attr', '')} [{text}]"
    text = text.replace("\n", "⏎")
    return text


def walk(patcher, path, out, summ, depth, opts):
    boxes = patcher.get("boxes", [])
    lines = patcher.get("lines", [])
    summ.patchers.append((path, len(boxes), len(lines)))
    ids = {}
    for entry in boxes:
        box = entry["box"]
        ids[box["id"]] = box
    if opts["patcher"] is None or opts["patcher"].lower() in path.lower():
        out.append("")
        out.append("=" * 100)
        out.append(f"PATCHER {path}   ({len(boxes)} boxes, {len(lines)} lines)")
        out.append("=" * 100)
        # Sort boxes by position (y then x) to approximate reading order
        ordered = sorted(boxes, key=lambda e: (round(e["box"].get("patching_rect", [0, 0])[1] / 40), e["box"].get("patching_rect", [0, 0])[0]))
        out.append("-- boxes (sorted top-to-bottom, left-to-right) --")
        for entry in ordered:
            box = entry["box"]
            label = box_label(box)
            cls = box.get("maxclass", "?")
            a = attrs_of(box)
            rect = box.get("patching_rect", [0, 0, 0, 0])
            pos = f"@({int(rect[0])},{int(rect[1])})"
            inl = box.get("numinlets", "?")
            outl = box.get("numoutlets", "?")
            out.append(f"  [{box['id']}] {cls:10s} {label}   io={inl}/{outl} {pos}{fmt_attrs(a)}")
            # codebox / gen code
            if "code" in box and isinstance(box["code"], str):
                for ln in box["code"].splitlines():
                    out.append(f"        | {ln}")
            if "text" in box and cls == "newobj" and box["text"].startswith("jit.gl.slab") is False and ("patcher" in box) and box.get("text", "").split(" ")[0] in ("jit.gl.pix", "jit.pix", "jit.gen", "gen~", "gen"):
                pass
        if not opts["no_lines"]:
            out.append("-- connections --")
            for entry in lines:
                pl = entry["patchline"]
                s, so = pl["source"]
                d, di = pl["destination"]
                sb = ids.get(s, {})
                db = ids.get(d, {})
                sl = box_label(sb)[:50]
                dl = box_label(db)[:50]
                extra = ""
                if pl.get("midpoints") and opts.get("midpoints"):
                    extra = f"  mid={pl['midpoints']}"
                if pl.get("disabled"):
                    extra += "  (DISABLED)"
                if pl.get("hidden"):
                    extra += "  (hidden)"
                out.append(f"  [{s} {sl}]:{so} -> [{d} {dl}]:{di}{extra}")
    for entry in boxes:
        box = entry["box"]
        text = box.get("text") or ""
        summ.note_text(json.dumps(box), path)
        summ.note_box(box, text, path)
        if box.get("maxclass") == "bpatcher" and "name" in box and "patcher" not in box:
            summ.missing_bpatchers.append((path, box.get("name")))
        sub = box.get("patcher")
        if sub and depth < opts["maxdepth"]:
            name = text.split(" ", 1)[1] if text.startswith("p ") else (text.split(" ")[0] if text else box.get("maxclass"))
            name = name.replace(" ", "_")
            walk(sub, f"{path}/{name}#{box['id']}", out, summ, depth + 1, opts)


def main():
    args = sys.argv[1:]
    if not args:
        print(__doc__)
        sys.exit(1)
    opts = {"summary": False, "patcher": None, "maxdepth": 99, "no_lines": False, "midpoints": False}
    files = []
    i = 0
    while i < len(args):
        a = args[i]
        if a == "--summary":
            opts["summary"] = True
        elif a == "--patcher":
            i += 1
            opts["patcher"] = args[i]
        elif a == "--maxdepth":
            i += 1
            opts["maxdepth"] = int(args[i])
        elif a == "--no-lines":
            opts["no_lines"] = True
        elif a == "--midpoints":
            opts["midpoints"] = True
        else:
            files.append(a)
        i += 1
    for f in files:
        with open(f, "r", encoding="utf-8") as fh:
            doc = json.load(fh)
        top = doc["patcher"]
        out = []
        summ = Summary()
        av = top.get("appversion", {})
        out.append(f"FILE {f}")
        out.append(f"Saved with Max {av.get('major')}.{av.get('minor')}.{av.get('revision')}  fileversion={top.get('fileversion')}")
        body = []
        walk(top, "/", body, summ, 0, opts)
        if not opts["summary"]:
            out.extend(body)
        out.append("")
        out.append("#" * 100)
        out.append("SUMMARY")
        out.append("#" * 100)
        out.append("Patchers:")
        for p, nb, nl in summ.patchers:
            out.append(f"  {p}  boxes={nb} lines={nl}")
        out.append("Referenced files (by token scan):")
        for k, v in sorted(summ.files.items()):
            out.append(f"  {k}  x{v}")
        out.append("send/forward names -> receivers:")
        names = sorted(set(summ.sends) | set(summ.receives))
        for n in names:
            s = sorted(summ.sends.get(n, []))
            r = sorted(summ.receives.get(n, []))
            flag = "" if (s and r) else ("  [NO RECEIVER IN FILE]" if s else "  [NO SENDER IN FILE]")
            out.append(f"  {n}: sent-from={s} received-in={r}{flag}")
        if summ.values:
            out.append("value/pv/pattr names:")
            for n, ps in sorted(summ.values.items()):
                out.append(f"  {n}: {sorted(ps)}")
        out.append("jit.gl contexts:")
        for c, objs in sorted(summ.glctx.items()):
            out.append(f"  {c}: {sorted(objs)}")
        if summ.js_objects:
            out.append("script/data objects:")
            for p, t in summ.js_objects:
                out.append(f"  {p}: {t}")
        if summ.missing_bpatchers:
            out.append("bpatchers referencing external files:")
            for p, n in summ.missing_bpatchers:
                out.append(f"  {p}: {n}")
        out.append("object class histogram (top 40):")
        for k, v in summ.classes.most_common(40):
            out.append(f"  {v:4d} {k}")
        print("\n".join(out))


if __name__ == "__main__":
    main()
