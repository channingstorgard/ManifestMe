import SwiftUI

struct OnboardingView: View {
    var body: some View {
        VStack {
            Image("AppLogo") // Replace with your actual image asset name
                .resizable()
                .frame(width: 100, height: 100)
                .padding(.top, 50)

            Text("Manifestor Journal")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 10)

            Text("Manifest your day, one thought at a time")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.top, 5)

            TabView {
                Text("Welcome to Manifestor Journal! Here, you write down what you want to manifest as if it’s already happened.")
                    .multilineTextAlignment(.center)
                    .padding()
                    .tabItem { Text("1") }

                Text("Every day, write 10-15 things you want to have happened.")
                    .multilineTextAlignment(.center)
                    .padding()
                    .tabItem { Text("2") }

                Text("Review your progress weekly and start crossing things off!")
                    .multilineTextAlignment(.center)
                    .padding()
                    .tabItem { Text("3") }
            }
            .tabViewStyle(PageTabViewStyle())
            .padding(.bottom, 30)

            Button(action: { /* Navigate to HomeView */ }) {
                Text("Get Started")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
            .padding(.top, 20)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
