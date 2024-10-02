import SwiftUI

struct HomeView: View {
    @State private var userEntries = [JournalEntry]() // List to store user entries
    @State private var newEntry = "" // Track new entry text
    @State private var lastEntryDate: Date? = nil // Track the last date entries were added
    @State private var showAlert = false // State variable to control alert display

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                // Title with a more professional look
                Text("ManifestMe")
                    .font(.system(size: 32, weight: .semibold, design: .default))
                    .foregroundColor(.primary)
                    .padding(.bottom, 10)
                
                // First part of the instructions
                Text("Write about an event you wish to experience, in past tense, as if it has already happened.  (Ex: Got a free coffee) Jot down the first positive things that come to your mind in as much or as little detail as you like. Use a seperate entry for each event. Write up to 15 events a day.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)

                // Text input area inside a rounded card with shadow and border
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
                    TextEditor(text: $newEntry)
                        .padding()
                }
                .frame(height: 100)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                .padding(.bottom, 10)
                
                // Button to submit an entry with gradient and seedling icon
                Button(action: {
                    checkForDailyReset() // Check and reset if necessary
                    if !newEntry.isEmpty && userEntries.count < 15 {
                        let newJournalEntry = JournalEntry(text: newEntry, completed: false, date: Date())
                        userEntries.append(newJournalEntry)
                        saveEntries() // Save to UserDefaults
                        newEntry = ""
                        
                        // Show alert if 15 entries are reached
                        if userEntries.count == 15 {
                            showAlert = true
                        }
                    }
                }) {
                    HStack {
                        Image(systemName: "leaf.fill") // Seedling icon
                        Text("Submit Entry")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]), startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                .disabled(userEntries.count >= 15) // Disable button after 15 entries
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Congratulations!"), message: Text("You have completed your 15 entries for today!"), dismissButton: .default(Text("OK")))
                }

                // Second part of the instructions below the button
                Text("After submitting, you've planted your seeds—let them grow! Move on with your day, and check back in a week in the Review tab to see which have blossomed into reality.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top, 20)

                // Progress indicator with circular progress bar
                HStack {
                    Text("\(userEntries.count)/15 entries submitted today")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    
                    Spacer()
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(userEntries.count) / 15)
                        .stroke(Color.blue, lineWidth: 5)
                        .frame(width: 30, height: 30)
                        .rotationEffect(.degrees(-90)) // Start progress from the top
                        .animation(.easeOut)
                }
                .padding(.top, 10)

                Spacer()
            }
            .padding()
        }
        .onAppear(perform: loadEntries)
    }

    // Save the entries to UserDefaults
    func saveEntries() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(userEntries) {
            UserDefaults.standard.set(encoded, forKey: "ManifestedEntries")
            print("Entries saved: \(userEntries.count)") // Debugging print statement
        } else {
            print("Failed to encode entries") // Debugging print statement
        }
        // Save the current date as the last entry date
        UserDefaults.standard.set(Date(), forKey: "LastEntryDate")
        print("Last entry date saved: \(Date())") // Debugging print statement
    }

    // Load the entries from UserDefaults
    func loadEntries() {
        if let savedEntries = UserDefaults.standard.object(forKey: "ManifestedEntries") as? Data {
            let decoder = JSONDecoder()
            if let decodedEntries = try? decoder.decode([JournalEntry].self, from: savedEntries) {
                userEntries = decodedEntries
                print("Entries loaded: \(userEntries.count)") // Debugging print statement
            } else {
                print("Failed to decode entries") // Debugging print statement
            }
        } else {
            print("No saved entries found") // Debugging print statement
        }
        // Load the last entry date
        if let savedDate = UserDefaults.standard.object(forKey: "LastEntryDate") as? Date {
            lastEntryDate = savedDate
            print("Last entry date loaded: \(lastEntryDate!)") // Debugging print statement
        } else {
            print("No last entry date found") // Debugging print statement
        }
    }

    // Check if it's a new day and reset entries if needed
    func checkForDailyReset() {
        if let lastDate = lastEntryDate {
            if !Calendar.current.isDateInToday(lastDate) {
                // It's a new day, reset entries
                userEntries.removeAll()
                saveEntries()
                print("Entries reset for new day") // Debugging print statement
            }
        } else {
            // No last date recorded, set today's date
            lastEntryDate = Date()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
