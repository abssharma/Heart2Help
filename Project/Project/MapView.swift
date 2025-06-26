import SwiftUI
import MapKit
import FirebaseFirestore

struct MapView: View
{
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
        span: MKCoordinateSpan(latitudeDelta: 180.0, longitudeDelta: 360.0)
    )

    @State private var locations: [Location] = []
    @State private var isLoading = true

    private let db = Firestore.firestore()

    var body: some View
    {
        ZStack
        {
            Map(coordinateRegion: $region, annotationItems: locations)
            { location in
                MapPin(coordinate: location.coordinate, tint: .green)
            }
            .edgesIgnoringSafeArea(.all)

            if isLoading
            {
                ProgressView("Loading map data...")
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
            }
        }
        .onAppear(perform: fetchLocations)
    }

    private func fetchLocations()
    {
        db.collection("events").getDocuments
        { snapshot, error in
            if let error = error
            {
                print("Error fetching events: \(error.localizedDescription)")
                isLoading = false
                return
            }

            guard let documents = snapshot?.documents else
            {
                print("No events found.")
                isLoading = false
                return
            }

            locations = documents.compactMap
            { doc -> Location? in
                let data = doc.data()
                guard
                    let name = data["title"] as? String,
                    let latitude = data["latitude"] as? Double,
                    let longitude = data["longitude"] as? Double
                else
                {
                    return nil
                }
                return Location(name: name, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
            }

            if let firstLocation = locations.first
            {
                region.center = firstLocation.coordinate
            }

            isLoading = false
        }
    }
}

struct Location: Identifiable
{
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct MapView_Previews: PreviewProvider
{
    static var previews: some View
    {
        MapView()
    }
}

