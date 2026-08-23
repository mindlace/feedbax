#!/usr/bin/env python3
"""maxedit — surgical, diff-friendly edits to a Max .maxpat JSON file.

Max cannot save patches in unlicensed/runtime mode, so patch fixes are made by
editing the .maxpat JSON directly. This module load/saves with Max's exact
tab-indented, one-element-per-line formatting so edits produce minimal git diffs
(verified byte-identical round-trip on patches/Feedbax.maxpat).

import maxedit as me
doc = me.load('patches/Feedbax.maxpat')
p = me.top(doc)                      # the top-level patcher dict
me.add_box(p, 'obj-fbnode', 'jit.gl.node foo @name fb @capture 1', [700, 120, 300, 22],
           numinlets=1, numoutlets=3, outlettype=['jit_gl_texture', '', ''])
me.add_line(p, 'obj-50', 2, 'obj-fbnode', 0)
me.remove_box(p, 'obj-37')           # also drops every line touching it
me.set_text(p, 'obj-12', 'jit.gl.videoplane fb @automatic 1 @layer 10')
me.save(doc, 'patches/Feedbax.maxpat')
"""
import json


def load(path):
    with open(path, encoding='utf-8') as f:
        return json.load(f)


def save(doc, path, trailing_newline=None):
    """Write `doc` back as Max-formatted JSON (tab indent, one element per line).

    Max files vary in whether they end with a trailing newline. If `trailing_newline`
    is None we preserve whatever the file currently at `path` uses (so re-saving a
    file produces a minimal diff); pass True/False to force it.
    """
    if trailing_newline is None:
        try:
            with open(path, 'rb') as f:
                f.seek(-1, 2)
                trailing_newline = f.read(1) == b'\n'
        except (OSError, ValueError):
            trailing_newline = False
    text = json.dumps(doc, indent='\t', ensure_ascii=False)
    if trailing_newline:
        text += '\n'
    with open(path, 'w', encoding='utf-8') as f:
        f.write(text)


def top(doc):
    return doc['patcher']


def subpatcher(p, box_id):
    """Return the embedded patcher dict of box `box_id` (a `p foo` / gen / jit.gl.pix box)."""
    return box(p, box_id)['patcher']


def boxes(p):
    return p.setdefault('boxes', [])


def lines(p):
    return p.setdefault('lines', [])


def box(p, box_id):
    for b in boxes(p):
        if b['box']['id'] == box_id:
            return b['box']
    raise KeyError(box_id)


def find_text(p, prefix):
    """All boxes whose text starts with `prefix`."""
    return [b['box'] for b in boxes(p) if b['box'].get('text', '').startswith(prefix)]


def add_box(p, box_id, text, rect, maxclass='newobj', numinlets=1, numoutlets=1,
            outlettype=None, **attrs):
    if any(b['box']['id'] == box_id for b in boxes(p)):
        raise ValueError(f'duplicate id {box_id}')
    bx = {'id': box_id, 'maxclass': maxclass, 'numinlets': numinlets, 'numoutlets': numoutlets,
          'patching_rect': [float(v) for v in rect]}
    if outlettype is not None:
        bx['outlettype'] = outlettype
    bx['text'] = text
    bx.update(attrs)
    boxes(p).append({'box': bx})
    return bx


def remove_box(p, box_id):
    box(p, box_id)  # raises if absent
    p['boxes'] = [b for b in boxes(p) if b['box']['id'] != box_id]
    p['lines'] = [l for l in lines(p)
                  if l['patchline']['source'][0] != box_id
                  and l['patchline']['destination'][0] != box_id]


def set_text(p, box_id, text):
    box(p, box_id)['text'] = text


def has_line(p, src, outlet, dst, inlet):
    return any(l['patchline']['source'] == [src, outlet] and
               l['patchline']['destination'] == [dst, inlet] for l in lines(p))


def add_line(p, src, outlet, dst, inlet, **extra):
    box(p, src); box(p, dst)
    if has_line(p, src, outlet, dst, inlet):
        return
    pl = {'destination': [dst, inlet], 'source': [src, outlet]}
    pl.update(extra)
    lines(p).append({'patchline': pl})


def remove_line(p, src, outlet, dst, inlet):
    before = len(lines(p))
    p['lines'] = [l for l in lines(p)
                  if not (l['patchline']['source'] == [src, outlet] and
                          l['patchline']['destination'] == [dst, inlet])]
    if len(p['lines']) == before:
        raise KeyError(f'no line {src}:{outlet} -> {dst}:{inlet}')


def lines_touching(p, box_id):
    return [l['patchline'] for l in lines(p)
            if l['patchline']['source'][0] == box_id or l['patchline']['destination'][0] == box_id]
