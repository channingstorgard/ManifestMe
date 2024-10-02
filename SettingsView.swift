import SwiftUI
import UserNotifications

struct SettingsView: View {
    @State private var dailyReminderEnabled = false

    var body: some View {
        VStack(alignment: .leading) {
            Text("Settings")
                .font(.largeTitle)
                .padding(.top, 20)
            
            Toggle("Enable Daily Reminder", isOn: $dailyReminderEnabled)
                .padding()
                .onChange(of: dailyReminderEnabled) { newValue in
                    if newValue {
                        scheduleDailyReminder()
                    } else {
                        cancelDailyReminder()
                    }
                    saveReminderSetting(enabled: newValue)
                }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .onAppear(perform: loadReminderSetting)
    }

    func scheduleDailyReminder() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = "Don't Forget!"
                content.body = "Write your 15 manifestation entries for today!"
                content.sound = .default

                var dateComponents = DateComponents()
                dateComponents.hour = 9

                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                let request = UNNotificationRequest(identifier: "DailyReminder", content: content, trigger: trigger)

                center.add(request) { error in
                    if let error = error {
                        print("Error scheduling daily reminder: \(error.localizedDescription)")
                    }
                }
            } else {
                print("Notification permission denied.")
            }
        }
    }

    func cancelDailyReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["DailyReminder"])
    }

    func saveReminderSetting(enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: "DailyReminderEnabled")
    }

    func loadReminderSetting() {
        dailyReminderEnabled = UserDefaults.standard.bool(forKey: "DailyReminderEnabled")
    }
}
