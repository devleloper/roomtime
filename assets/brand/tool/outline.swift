// usage: outline <font.ttf> <text> <wght> <unitsPerEmSize> <trackingEm>
// Prints JSON: per-glyph SVG path data (y down, baseline at 0) and pen x.
import Foundation
import CoreText
import AppKit
let a = CommandLine.arguments
let url = URL(fileURLWithPath: a[1]) as CFURL
let descs = CTFontManagerCreateFontDescriptorsFromURL(url) as! [CTFontDescriptor]
let size = CGFloat(Double(a[4])!)
let tracking = CGFloat(Double(a[5])!) * size
let wghtTag = 0x77676874
let varDesc = CTFontDescriptorCreateCopyWithAttributes(descs[0], [kCTFontVariationAttribute: [wghtTag: Double(a[3])!]] as CFDictionary)
let font = CTFontCreateWithFontDescriptor(varDesc, size, nil)
// Glyph positions come from a CTLine so the font's kerning applies; tracking
// is added on top, per glyph.
let attr = NSAttributedString(string: a[2], attributes: [kCTFontAttributeName as NSAttributedString.Key: font])
let line = CTLineCreateWithAttributedString(attr)
var glyphs: [CGGlyph] = []
var positions: [CGPoint] = []
var chars: [String] = []
for run in CTLineGetGlyphRuns(line) as! [CTRun] {
  let n = CTRunGetGlyphCount(run)
  var g = [CGGlyph](repeating: 0, count: n)
  var p = [CGPoint](repeating: .zero, count: n)
  var idx = [CFIndex](repeating: 0, count: n)
  CTRunGetGlyphs(run, CFRange(location: 0, length: n), &g)
  CTRunGetPositions(run, CFRange(location: 0, length: n), &p)
  CTRunGetStringIndices(run, CFRange(location: 0, length: n), &idx)
  glyphs += g
  positions += p
  let u = Array(a[2].utf16)
  chars += idx.map { String(utf16CodeUnits: [u[$0]], count: 1) }
}
var adv = [CGSize](repeating: .zero, count: glyphs.count)
CTFontGetAdvancesForGlyphs(font, .horizontal, glyphs, &adv, glyphs.count)
func f(_ v: CGFloat) -> String { String(format: "%.2f", Double(v)).replacingOccurrences(of: ".00", with: "") }
var out: [[String: Any]] = []
var pen: CGFloat = 0
for (i, g) in glyphs.enumerated() {
  pen = positions[i].x + CGFloat(i) * tracking
  var subpaths: [String] = []
  var cur = ""
  if let p = CTFontCreatePathForGlyph(font, g, nil) {
    p.applyWithBlock { e in
      let el = e.pointee
      let pts = el.points
      func P(_ k: Int) -> String { "\(f(pts[k].x + pen)) \(f(-pts[k].y))" }
      switch el.type {
      case .moveToPoint: if !cur.isEmpty { subpaths.append(cur) }; cur = "M\(P(0))"
      case .addLineToPoint: cur += "L\(P(0))"
      case .addQuadCurveToPoint: cur += "Q\(P(0)) \(P(1))"
      case .addCurveToPoint: cur += "C\(P(0)) \(P(1)) \(P(2))"
      case .closeSubpath: cur += "Z"
      @unknown default: break
      }
    }
  }
  if !cur.isEmpty { subpaths.append(cur) }
  let b = CTFontGetBoundingRectsForGlyphs(font, .horizontal, [g], nil, 1)
  out.append(["char": chars[i], "x": Double(pen), "advance": Double(adv[i].width), "subpaths": subpaths,
              "bbox": [Double(b.minX + pen), Double(-b.maxY), Double(b.maxX + pen), Double(-b.minY)]])
}
pen += adv[glyphs.count - 1].width + tracking
let meta: [String: Any] = ["glyphs": out, "width": Double(pen - tracking), "capHeight": Double(CTFontGetCapHeight(font)), "xHeight": Double(CTFontGetXHeight(font)), "ascent": Double(CTFontGetAscent(font)), "descent": Double(CTFontGetDescent(font))]
let data = try! JSONSerialization.data(withJSONObject: meta, options: [.prettyPrinted, .sortedKeys])
print(String(data: data, encoding: .utf8)!)
