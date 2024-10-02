
import SwiftUI

struct ProgressTrackerView: View {
    @State private var totalEntries = 0
    @State private var completedEntries = 0
    @State private var successRate: Int? = nil // Success rate percentage
    @State private var currentStreak = 0
    @State private var bestStreak = 0

    var body: some View {
        VStack {
            Text("Your Manifestation Progress")
                .font(.title2)
                .padding()

            // Success Rate Display
            if let rate = successRate {
                Text("Success Rate: \(rate)%")
                    .font(.largeTitle)
                    .foregroundColor(.green)
                    .padding()
            } else {
                Text("No entries to calculate success rate.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding()
            }

            // Streak Tracker
            Text("Current Streak: \(currentStreak) Days")
                .font(.headline)
                .padding(.top, 5)

            Text("Best Streak: \(bestStreak) Days")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.top, 2)

            Spacer()
        }
        .padding()
        .onAppear(perform: loadEntries)
    }

    // Load entries from UserDefaults and calculate progress data
    func loadEntries() {
        if let savedEntries = UserDefaults.standard.object(forKey: "ManifestedEntries") as? Data {
            if let decodedEntries = try? JSONDecoder().decode([JournalEntry].self, from: savedEntries) {
                // Update the count of total and completed entries
                totalEntries = decodedEntries.count
                completedEntries = decodedEntries.filter { $0.completed }.count

                // Calculate success rate
                successRate = calculateSuccessRate(total: totalEntries, completed: completedEntries)

                // Calculate streaks
                currentStreak = calculateCurrentStreak(from: decodedEntries)
                bestStreak = calculateBestStreak(from: decodedEntries)
            }
        }
    }

    // Calculate success rate percentage
    func calculateSuccessRate(total: Int, completed: Int) -> Int? {
        guard total > 0 else { return nil } // Prevent division by zero
        return Int(Double(completed) / Double(total) * 100)
    }

    // Calculate the current streak of consecutive days
    func calculateCurrentStreak(from entries: [JournalEntry]) -> Int {
        let sortedEntries = entries.sorted(by: { $0.date < $1.date })
        var streak = 0
        var previousDate: Date?

        for entry in sortedEntries {
            let entryDate = Calendar.current.startOfDay(for: entry.date)
            if let lastDate = previousDate {
                if Calendar.current.isDate(entryDate, inSameDayAs: lastDate.addingTimeInterval(86400)) {
                    streak += 1
                } else if !Calendar.current.isDate(entryDate, inSameDayAs: lastDate) {
                    streak = 1
                }
            } else {
                streak = 1
            }
            previousDate = entryDate
        }
        return streak
    }

    // Calculate the longest streak of consecutive days
    func calculateBestStreak(from entries: [JournalEntry]) -> Int {
        let sortedEntries = entries.sorted(by: { $0.date < $1.date })
        var currentStreak = 0
        var bestStreak = 0
        var previousDate: Date?

        for entry in sortedEntries {
            let entryDate = Calendar.current.startOfDay(for: entry.date)
            if let lastDate = previousDate {
                if Calendar.current.isDate(entryDate, inSameDayAs: lastDate.addingTimeInterval(86400)) {
                    currentStreak += 1
                } else if !Calendar.current.isDate(entryDate, inSameDayAs: lastDate) {
                    currentStreak = 1
                }
            } else {
                currentStreak = 1
            }
            bestStreak = max(bestStreak, currentStreak)
            previousDate = entryDate
        }
        return bestStreak
    }
}

struct ProgressTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressTrackerView()
    }
}
