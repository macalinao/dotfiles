#!/usr/bin/env python3
"""Convert a darktable .dtstyle file into an .xmp sidecar.

darktable-cli can apply a sidecar directly (`darktable-cli IMG STYLE.xmp OUT`),
which lets us apply any style fully headlessly with no GUI import and no
dependency on darktable's data.db. The op_params/blendop_params base64 blobs
are byte-identical between the two formats; only the XML wrapper differs.

usage: dtstyle2xmp.py INPUT.dtstyle OUTPUT.xmp
"""
import sys
import xml.etree.ElementTree as ET
from xml.sax.saxutils import escape


def convert(dtstyle_path: str, xmp_path: str) -> int:
    root = ET.parse(dtstyle_path).getroot()
    plugins = root.findall("./style/plugin")
    items = []
    for p in plugins:
        def field(tag, default=""):
            el = p.find(tag)
            return el.text if (el is not None and el.text is not None) else default

        attrs = {
            "darktable:num": field("num"),
            "darktable:operation": field("operation"),
            "darktable:enabled": field("enabled", "1"),
            "darktable:modversion": field("module"),
            "darktable:params": field("op_params"),
            "darktable:multi_name": field("multi_name"),
            "darktable:multi_priority": field("multi_priority", "0"),
            "darktable:blendop_version": field("blendop_version", "0"),
            "darktable:blendop_params": field("blendop_params"),
        }
        attr_str = "\n      ".join(
            '{}="{}"'.format(k, escape(v, {'"': "&quot;"})) for k, v in attrs.items()
        )
        items.append("     <rdf:li\n      {}/>".format(attr_str))

    n = len(plugins)
    seq = "\n".join(items)
    xmp = (
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        '<x:xmpmeta xmlns:x="adobe:ns:meta/" x:xmptk="darktable">\n'
        ' <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">\n'
        '  <rdf:Description rdf:about=""\n'
        '    xmlns:darktable="http://darktable.sf.net/"\n'
        '   darktable:xmp_version="4"\n'
        '   darktable:history_end="{n}"\n'
        '   darktable:auto_presets_applied="1">\n'
        "   <darktable:history>\n"
        "    <rdf:Seq>\n"
        "{seq}\n"
        "    </rdf:Seq>\n"
        "   </darktable:history>\n"
        "  </rdf:Description>\n"
        " </rdf:RDF>\n"
        "</x:xmpmeta>\n"
    ).format(n=n, seq=seq)

    with open(xmp_path, "w") as f:
        f.write(xmp)
    return n


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print(__doc__, file=sys.stderr)
        sys.exit(64)
    count = convert(sys.argv[1], sys.argv[2])
    print("wrote {} ({} modules)".format(sys.argv[2], count))
