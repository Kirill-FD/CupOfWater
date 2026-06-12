// Добавь target «Widget Extension» (WaterWidget) в Xcode, как в шаге 1 инструкции, и
// вложи эту папку в target WaterWidget (с App Group group.com.mycompany.watertracker).

import WidgetKit
import SwiftUI
import AppIntents
import UIKit

struct WaterEntry: TimelineEntry {
  let date: Date
  let currentMl: Int
  let goalMl: Int
  var progress: Double { goalMl > 0 ? min(Double(currentMl) / Double(goalMl), 1.0) : 0 }
}

struct Provider: TimelineProvider {
  let suiteName = "group.com.mycompany.watertracker"

  func placeholder(in context: Context) -> WaterEntry {
    WaterEntry(date: Date(), currentMl: 1250, goalMl: 2000)
  }

  func getSnapshot(in context: Context, completion: @escaping (WaterEntry) -> Void) {
    completion(readEntry())
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<WaterEntry>) -> Void) {
    let entry = readEntry()
    let next = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
    completion(Timeline(entries: [entry], policy: .after(next)))
  }

  private func todayDateKey() -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = .current
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: Date())
  }

  private func readEntry() -> WaterEntry {
    let ud = UserDefaults(suiteName: suiteName)
    let today = todayDateKey()
    let storedDay = ud?.string(forKey: "current_day") ?? ""
    let current = storedDay == today ? (ud?.integer(forKey: "current_ml") ?? 0) : 0
    let goal = ud?.integer(forKey: "goal_ml") ?? 2000
    return WaterEntry(date: Date(), currentMl: current, goalMl: goal)
  }
}

@available(iOS 17.0, *)
struct AddWaterIntent: AppIntent {
  static var title: LocalizedStringResource = "Добавить 250 мл воды"
  static var description = IntentDescription("Добавляет 250 мл к дневной норме воды")

  func perform() async throws -> some IntentResult {
    let suiteName = "group.com.mycompany.watertracker"
    let ud = UserDefaults(suiteName: suiteName)
    let today = {
      let formatter = DateFormatter()
      formatter.locale = Locale(identifier: "en_US_POSIX")
      formatter.timeZone = .current
      formatter.dateFormat = "yyyy-MM-dd"
      return formatter.string(from: Date())
    }()
    let storedDay = ud?.string(forKey: "current_day") ?? ""
    let current = storedDay == today ? (ud?.integer(forKey: "current_ml") ?? 0) : 0
    let newValue = current + 250
    ud?.set(today, forKey: "current_day")
    ud?.set(newValue, forKey: "current_ml")
    ud?.set(true, forKey: "pending_sync")

    WidgetCenter.shared.reloadAllTimelines()
    return .result()
  }
}

struct WaterWidgetEntryView: View {
  var entry: Provider.Entry
  @Environment(\.widgetFamily) var family

  var body: some View {
    switch family {
    case .systemSmall: smallView
    case .systemMedium: mediumView
    default: smallView
    }
  }

  private var smallView: some View {
    VStack(spacing: 6) {
      ZStack {
        Circle().stroke(Color.blue.opacity(0.2), lineWidth: 8)
        Circle()
          .trim(from: 0, to: entry.progress)
          .stroke(
            LinearGradient(
              colors: [Color.cyan, Color.blue],
              startPoint: .top,
              endPoint: .bottom
            ),
            style: StrokeStyle(lineWidth: 8, lineCap: .round)
          )
          .rotationEffect(.degrees(-90))
        VStack(spacing: 0) {
          Text("\(Int(entry.progress * 100))%")
            .font(.system(size: 18, weight: .bold))
          Text("\(entry.currentMl)мл")
            .font(.system(size: 10))
            .foregroundColor(.secondary)
        }
      }
      .frame(width: 70, height: 70)

      if #available(iOS 17.0, *) {
        Button(intent: AddWaterIntent()) {
          Label("+250", systemImage: "drop.fill")
            .font(.system(size: 12, weight: .semibold))
        }
        .buttonStyle(.borderedProminent)
        .tint(.blue)
      } else {
        Link(destination: URL(string: "waterwidget://add?ml=250")!) {
          Label("+250", systemImage: "drop.fill")
            .font(.system(size: 12, weight: .semibold))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
      }
    }
    .containerBackground(for: .widget) {
      Color(UIColor.systemBackground)
    }
  }

  private var mediumView: some View {
    HStack(spacing: 16) {
      ZStack {
        Circle().stroke(Color.blue.opacity(0.2), lineWidth: 10)
        Circle()
          .trim(from: 0, to: entry.progress)
          .stroke(
            LinearGradient(
              colors: [Color.cyan, Color.blue],
              startPoint: .top,
              endPoint: .bottom
            ),
            style: StrokeStyle(lineWidth: 10, lineCap: .round)
          )
          .rotationEffect(.degrees(-90))
        Text("\(Int(entry.progress * 100))%")
          .font(.system(size: 22, weight: .bold))
      }
      .frame(width: 90, height: 90)

      VStack(alignment: .leading, spacing: 8) {
        Label("Вода сегодня", systemImage: "drop.fill")
          .font(.caption)
          .foregroundColor(.secondary)
        Text("\(entry.currentMl) / \(entry.goalMl) мл")
          .font(.title3)
          .fontWeight(.bold)

        if #available(iOS 17.0, *) {
          Button(intent: AddWaterIntent()) {
            Label("+ 250 мл", systemImage: "plus.circle.fill")
          }
          .buttonStyle(.borderedProminent)
          .tint(.blue)
        } else {
          Link(destination: URL(string: "waterwidget://add?ml=250")!) {
            Label("+ 250 мл", systemImage: "plus.circle.fill")
              .padding(.horizontal, 12)
              .padding(.vertical, 6)
              .background(Color.blue)
              .foregroundColor(.white)
              .cornerRadius(8)
          }
        }
      }
      Spacer()
    }
    .padding()
    .containerBackground(for: .widget) {
      Color(UIColor.systemBackground)
    }
  }
}

@main
struct WaterWidget: Widget {
  let kind: String = "WaterWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      WaterWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("CupOfWater")
    .description("Следи за нормой воды и добавляй прямо с экрана")
    .supportedFamilies([.systemSmall, .systemMedium])
  }
}
