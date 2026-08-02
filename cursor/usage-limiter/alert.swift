#!/usr/bin/env swift
import AppKit

let args = CommandLine.arguments
guard args.count == 8 else {
    fputs("Usage: alert.swift <threshold> <today_cents> <daily_target_cents> <daily_pct> <cycle_cents> <cycle_limit_cents> <cycle_pct>\n", stderr)
    exit(1)
}

let threshold    = Int(args[1]) ?? 60
let todayCents   = Int(args[2]) ?? 0
let targetCents  = Int(args[3]) ?? 1
let dailyPct     = Double(args[4]) ?? 0
let cycleCents   = Int(args[5]) ?? 0
let cycleLimit   = Int(args[6]) ?? 1
let cyclePct     = Double(args[7]) ?? 0

func dollars(_ cents: Int) -> String {
    String(format: "$%.2f", Double(cents) / 100.0)
}

// Title
let title: String
if threshold >= 100 {
    title = "Cursor — Daily budget reached"
} else {
    title = "Cursor — \(threshold)% of daily budget"
}

// Body
let body = "Today:   \(dollars(todayCents)) / \(dollars(targetCents))  (\(String(format: "%.1f", dailyPct))%)\nCycle:   \(dollars(cycleCents)) / \(dollars(cycleLimit))  (\(String(format: "%.1f", cyclePct))%)"

// Icon — SF Symbol tinted by severity
let symbolName: String
let iconColor: NSColor
if threshold >= 100 {
    symbolName = "xmark.octagon.fill"
    iconColor = NSColor.systemRed
} else if threshold >= 80 {
    symbolName = "exclamationmark.triangle.fill"
    iconColor = NSColor.systemOrange
} else {
    symbolName = "exclamationmark.triangle.fill"
    iconColor = NSColor.systemYellow
}

let app = NSApplication.shared
app.setActivationPolicy(.accessory)

let alert = NSAlert()
alert.messageText = title
alert.informativeText = body
alert.alertStyle = threshold >= 100 ? .critical : .warning
alert.addButton(withTitle: "OK")

// SF Symbol icon with tint color
if let symbolImage = NSImage(systemSymbolName: symbolName, accessibilityDescription: nil) {
    let size = NSSize(width: 48, height: 48)
    let tinted = NSImage(size: size, flipped: false) { rect in
        iconColor.setFill()
        symbolImage.draw(in: rect)
        return true
    }
    alert.icon = tinted
}

// Custom attributed informative text for better readability
let style = NSMutableParagraphStyle()
style.lineSpacing = 4

let attrBody = NSAttributedString(
    string: body,
    attributes: [
        .font: NSFont.monospacedSystemFont(ofSize: 13, weight: .regular),
        .paragraphStyle: style,
    ]
)
alert.accessoryView = {
    let label = NSTextField(wrappingLabelWithString: "")
    label.attributedStringValue = attrBody
    label.frame = NSRect(x: 0, y: 0, width: 280, height: 50)
    label.alignment = .left
    return label
}()
// Clear informativeText so it doesn't duplicate
alert.informativeText = ""

app.activate(ignoringOtherApps: true)
alert.runModal()
