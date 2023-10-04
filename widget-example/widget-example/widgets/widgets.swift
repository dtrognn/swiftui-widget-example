//
//  widgets.swift
//  widgets
//
//  Created by dtrognn on 03/10/2023.
//

import AppIntents
import Intents
import SwiftUI
import WidgetKit

struct DemoIntent: AppIntent {
    static var title: LocalizedStringResource = "dtrognn"

    func perform() async throws -> some IntentResult {
        // TODO: - Handle something
        return .result()
    }
}

// data input for widget
struct SimpleEntry: TimelineEntry {
    let date: Date = .init() // is required
    let configuration: ConfigurationIntent
    var count: Int
}

struct Provider: IntentTimelineProvider {
    var manager = DataManager.shared

    // init data default or when loading data
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(configuration: ConfigurationIntent(), count: 0)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        completion(SimpleEntry(configuration: ConfigurationIntent(), count: 0))
    }

    // update data for widget
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        guard let count = manager.readDataFromUserDefaults() else { return }
        entries.append(SimpleEntry(configuration: configuration, count: count))

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct widgetsEntryView: View {
    var entry: Provider.Entry
    @StateObject private var manager = DataManager.shared

    var body: some View {
        VStack {
            Text("count: \(entry.count)")

            Button {
                manager.count -= 1
                manager.saveDataWithUserDefaults()
            } label: {
                Text("Decrease")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.orange)
                    .cornerRadius(8)
            }
        }
    }
}

struct widgets: Widget {
    let kind: String = "widgets"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            widgetsEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium, .systemSmall, .systemLarge])
    }
}

struct widgets_Previews: PreviewProvider {
    static var previews: some View {
        widgetsEntryView(entry: SimpleEntry(configuration: ConfigurationIntent(), count: 0))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
