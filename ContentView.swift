import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: RestaurantPickerViewModel

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Picker("Select Category", selection: $viewModel.selectedCategory) {
                    ForEach(RestaurantCategory.allCases) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())

                Toggle("Spin Favorites Only", isOn: $viewModel.spinFavoritesOnly)
                    .padding(.horizontal)

                Button(action: viewModel.spinWheel) {
                    Text("Spin the Wheel")
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }

                if let restaurant = viewModel.selectedRestaurant {
                    VStack(spacing: 10) {
                        Text("🎯 \(restaurant.name)")
                            .font(.title2)
                            .fontWeight(.bold)

                        if let urlString = restaurant.offerURL, let url = URL(string: urlString) {
                            Link("Check out specials", destination: url)
                        }
                    }
                    .padding()
                    .background(Color.yellow.opacity(0.2))
                    .cornerRadius(10)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Spin2Dine")
        }
    }
}
