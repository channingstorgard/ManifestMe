import SwiftUI

struct WeeklyReviewView: View {
    @State private var pastEntries: [JournalEntry] = [] // Initialize with an empty array
    @State private var message: String = "Entries will appear here one week from submission."

    var body: some View {
        VStack {
            Text("Review your progress by marking past entries as occurred or not.")
                .font(.title2)
                .padding()

            if pastEntries.isEmpty {
                // Display message if no entries from a week ago
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                // Display list of entries from a week ago
                List {
                    ForEach(pastEntries.indices, id: \.self) { index in
                        HStack {
                            Text(pastEntries[index].text)
                                .strikethrough(pastEntries[index].completed, color: .green)
                            Spacer()
                            Button(action: {
                                pastEntries[index].completed.toggle() // Toggle completed state
                                saveEntries() // Save the updated state
                            }) {
                                Image(systemName: pastEntries[index].completed ? "checkmark.square" : "square")
                                    .foregroundColor(.green)
                                    .animation(.easeInOut) // Added animation for toggling
                            }
                        }
                        .padding(.vertical, 5)
                        .background(pastEntries[index].completed ? Color.green.opacity(0.1) : Color.clear) // Highlight completed entries
                    }
                }
            }
        }
        .padding()
        .onAppear(perform: loadEntries)
    }

    // Load entries saved at least one week ago
    func loadEntries() {
        if let savedEntries = UserDefaults.standard.object(forKey: "ManifestedEntries") as? Data {
            if let decodedEntries = try? JSONDecoder().decode([JournalEntry].self, from: savedEntries) {
                // Calculate the date exactly one week ago
                let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
                // Filter entries that are at least one week old
                pastEntries = decodedEntries.filter { entry in
                    entry.date <= oneWeekAgo // Keep entries that are one week old or older
                }
            } else {
                // Handle decoding error
                print("Failed to decode entries")
            }
        } else {
            // Handle loading error
            print("Failed to load entries")
        }
    }

    // Save the updated entries back to UserDefaults
    func saveEntries() {
        if let encoded = try? JSONEncoder().encode(pastEntries) {
            UserDefaults.standard.set(encoded, forKey: "ManifestedEntries")
        } else {
            // Handle encoding error
            print("Failed to encode entries")
        }
    }
}

struct JournalEntry: Identifiable, Codable {
    var id = UUID()
    var text: String
    var completed: Bool
    var date: Date // Store the date when the entry was made
}

struct WeeklyReviewView_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyReviewView()
    }
}
