import SwiftUI
import Firebase

@main
struct Spin2DineApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: RestaurantPickerViewModel())
        }
    }
}
