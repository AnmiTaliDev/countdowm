import SwiftUI
import WidgetKit

private let appGroupId = "group.dev.anmitali.countdown"

struct CountdownEntry: TimelineEntry {
    let date: Date
    let name: String?
    let cost: String?
    let chargeDate: Date?
    let emptyText: String
}

struct CountdownProvider: TimelineProvider {
    func placeholder(in context: Context) -> CountdownEntry {
        CountdownEntry(
            date: Date(),
            name: "Subscription",
            cost: "0.00",
            chargeDate: Date().addingTimeInterval(86400),
            emptyText: "No subscriptions"
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (CountdownEntry) -> Void) {
        completion(loadEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CountdownEntry>) -> Void) {
        completion(Timeline(entries: [loadEntry()], policy: .never))
    }

    private func loadEntry() -> CountdownEntry {
        let defaults = UserDefaults(suiteName: appGroupId)
        var chargeDate: Date? = nil
        if let text = defaults?.string(forKey: "next_charge_millis"), let millis = Double(text) {
            chargeDate = Date(timeIntervalSince1970: millis / 1000)
        }
        return CountdownEntry(
            date: Date(),
            name: defaults?.string(forKey: "next_name"),
            cost: defaults?.string(forKey: "next_cost"),
            chargeDate: chargeDate,
            emptyText: defaults?.string(forKey: "empty_text") ?? "No subscriptions"
        )
    }
}

struct CountdownWidgetView: View {
    let entry: CountdownEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let name = entry.name, let cost = entry.cost, let chargeDate = entry.chargeDate {
                Text(name)
                    .font(.headline)
                    .lineLimit(1)
                Text(chargeDate, style: .relative)
                    .font(.title2.bold())
                    .foregroundColor(.accentColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                Text(cost)
                    .font(.subheadline)
            } else {
                Text(entry.emptyText)
                    .font(.headline)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}

extension View {
    func widgetBackground() -> some View {
        if #available(iOS 17.0, *) {
            return containerBackground(.fill.tertiary, for: .widget)
        } else {
            return background(Color(UIColor.secondarySystemBackground))
        }
    }
}

@main
struct CountdownWidget: Widget {
    let kind: String = "CountdownWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CountdownProvider()) { entry in
            CountdownWidgetView(entry: entry)
                .padding()
                .widgetBackground()
        }
        .configurationDisplayName("Countdown")
        .description("Nearest upcoming subscription charge")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
