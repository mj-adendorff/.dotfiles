#!/usr/bin/env python3
"""Convert Jira ADF (Atlassian Document Format) JSON on stdin to Markdown on stdout.

Handles the node set Jira actually emits; unknown nodes degrade to their text
content rather than vanishing, so nothing is silently lost.
"""
import json, sys

PANEL = {"info": "ℹ️", "note": "📝", "warning": "⚠️", "error": "🛑", "success": "✅"}


def esc(t):
    for c in ("\\", "`", "*", "_", "[", "]"):
        t = t.replace(c, "\\" + c)
    return t


def inline(nodes):
    out = []
    for n in nodes or []:
        t = n.get("type")
        if t == "text":
            s = esc(n.get("text", ""))
            for m in n.get("marks", []) or []:
                mt = m.get("type")
                if mt == "strong":         s = f"**{s}**"
                elif mt == "em":           s = f"*{s}*"
                elif mt == "code":         s = f"`{n.get('text','')}`"
                elif mt == "strike":       s = f"~~{s}~~"
                elif mt == "underline":    s = f"_{s}_"
                elif mt == "link":         s = f"[{s}]({m.get('attrs',{}).get('href','')})"
                elif mt == "subsup":       s = f"^{s}^" if m.get("attrs",{}).get("type")=="sup" else f"~{s}~"
            out.append(s)
        elif t == "hardBreak":   out.append("  \n")
        elif t == "mention":     out.append(f"**{n.get('attrs',{}).get('text','@?')}**")
        elif t == "emoji":       out.append(n.get("attrs", {}).get("text") or n.get("attrs", {}).get("shortName", ""))
        elif t == "date":        out.append(n.get("attrs", {}).get("timestamp", ""))
        elif t == "status":      out.append(f"`{n.get('attrs',{}).get('text','')}`")
        elif t == "inlineCard":
            u = n.get("attrs", {}).get("url", "")
            out.append(f"<{u}>" if u else "")
        else:
            out.append(inline(n.get("content", [])))
    return "".join(out)


def cell_text(cell):
    return inline_block(cell.get("content", [])).replace("\n", " ").strip() or " "


def inline_block(nodes):
    return "\n".join(block(n) for n in nodes or [])


def listing(node, ordered, depth):
    lines = []
    for i, item in enumerate(node.get("content", []) or [], 1):
        marker = f"{i}. " if ordered else "- "
        body = "\n".join(block(c, depth + 1) for c in item.get("content", []) or [])
        first, *rest = (body or "").split("\n")
        lines.append(f"{marker}{first}")
        lines += [f"  {r}" if r.strip() else "" for r in rest]
    return "\n".join(lines)


def block(n, depth=0):
    t = n.get("type")
    c = n.get("content", [])
    if t in ("doc", "listItem"):     return "\n\n".join(block(x, depth) for x in c)
    if t == "paragraph":             return inline(c)
    if t == "heading":               return "#" * n.get("attrs", {}).get("level", 1) + " " + inline(c)
    if t == "bulletList":            return listing(n, False, depth)
    if t == "orderedList":           return listing(n, True, depth)
    if t == "codeBlock":
        return "```" + (n.get("attrs", {}).get("language") or "") + "\n" + inline(c).replace("\\", "") + "\n```"
    if t == "blockquote":            return "\n".join("> " + l for l in inline_block(c).split("\n"))
    if t == "rule":                  return "---"
    if t == "panel":
        icon = PANEL.get(n.get("attrs", {}).get("panelType", ""), "ℹ️")
        return "\n".join(f"> {icon} " + l if i == 0 else "> " + l
                         for i, l in enumerate(inline_block(c).split("\n")))
    if t in ("mediaSingle", "mediaGroup"):
        names = [m.get("attrs", {}).get("alt") or m.get("attrs", {}).get("id", "attachment")
                 for m in c]
        return "\n".join(f"_[attachment: {x}]_" for x in names)
    if t in ("expand", "nestedExpand"):
        return f"**{n.get('attrs',{}).get('title','Details')}**\n\n" + inline_block(c)
    if t == "taskList":
        return "\n".join(
            ("- [x] " if x.get("attrs", {}).get("state") == "DONE" else "- [ ] ") + inline(x.get("content", []))
            for x in c)
    if t == "decisionList":
        return "\n".join("- ✔ " + inline(x.get("content", [])) for x in c)
    if t == "table":
        rows = [r.get("content", []) for r in c if r.get("type") == "tableRow"]
        if not rows: return ""
        out = ["| " + " | ".join(cell_text(x) for x in rows[0]) + " |",
               "|" + "|".join("---" for _ in rows[0]) + "|"]
        out += ["| " + " | ".join(cell_text(x) for x in r) + " |" for r in rows[1:]]
        return "\n".join(out)
    return inline_block(c) if c else inline([n])


def main():
    raw = sys.stdin.read().strip()
    if not raw or raw == "null":
        print("_No description._"); return
    try:
        doc = json.loads(raw)
    except json.JSONDecodeError:
        print(raw); return          # Server/DC returns a plain wiki-markup string
    if isinstance(doc, str):
        print(doc); return
    text = "\n\n".join(x for x in (block(n) for n in doc.get("content", [])) if x.strip())
    print(text or "_No description._")


main()
