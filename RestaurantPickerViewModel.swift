import Foundation
import FirebaseFirestore
import FirebaseAuth

class RestaurantPickerViewModel: ObservableObject {
    @Published var allRestaurants: [Restaurant] = []
    @Published var selectedCategory: RestaurantCategory = .casual
    @Published var selectedRestaurant: Restaurant?
    @Published var spinFavoritesOnly: Bool = false

    private var db = Firestore.firestore()
    private var userID: String {
        Auth.auth().currentUser?.uid ?? "unknown"
    }

    var filteredRestaurants: [Restaurant] {
        let categoryFiltered = allRestaurants.filter { $0.category == selectedCategory }
        return spinFavoritesOnly ? categoryFiltered.filter { $0.isFavorite } : categoryFiltered
    }

    init() {
        fetchRestaurants()
    }

    func fetchRestaurants() {
        db.collection("users").document(userID).collection("restaurants")
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else { return }
                self.allRestaurants = documents.compactMap { try? $0.data(as: Restaurant.self) }
            }
    }

    func spinWheel() {
        let totalWeight = filteredRestaurants.reduce(0) { $0 + $1.adWeight }
        let randomValue = Int.random(in: 1...totalWeight)
        var cumulative = 0

        for restaurant in filteredRestaurants {
            cumulative += restaurant.adWeight
            if randomValue <= cumulative {
                selectedRestaurant = restaurant
                break
            }
        }

        if let restaurant = selectedRestaurant, let id = restaurant.id {
            db.collection("users").document(userID)
              .collection("restaurants").document(id)
              .updateData(["spinCount": FieldValue.increment(Int64(1))])
        }
    }
}
