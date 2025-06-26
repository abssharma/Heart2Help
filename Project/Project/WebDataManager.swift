import Foundation
import CoreLocation

final class WebDataManager: ObservableObject
{
    @Published var isLoading = false
    @Published var fetchError: String?
    @Published var volunteerCenters: [VolunteerCenter] = []

    func fetchVolunteerCenters()
    {
        isLoading = true
        fetchError = nil

        let urlString = """
        https://overpass-api.de/api/interpreter?data=[out:json];node["amenity"="social_facility"](24.396308,-125.0,49.384358,-66.93457);out;
        """
        
        guard let url = URL(string: urlString) else
        {
            fetchError = "Invalid URL."
            isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url)
        { [weak self] data, _, error in
            DispatchQueue.main.async
            {
                self?.isLoading = false

                if let error = error
                {
                    self?.fetchError = "Network error: \(error.localizedDescription)"
                    return
                }

                guard let data = data else
                {
                    self?.fetchError = "No data received."
                    return
                }

                do
                {
                    let response = try JSONDecoder().decode(OverpassResponse.self, from: data)
                    self?.volunteerCenters = response.elements.map
                    {
                        VolunteerCenter(
                            id: UUID(),
                            name: $0.tags?["name"],
                            latitude: $0.lat,
                            longitude: $0.lon
                        )
                    }
                } catch
                {
                    self?.fetchError = "Failed to decode response: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}

struct VolunteerCenter: Identifiable
{
    let id: UUID
    let name: String?
    let latitude: Double
    let longitude: Double
}

struct OverpassResponse: Codable
{
    let elements: [Element]

    struct Element: Codable
    {
        let lat: Double
        let lon: Double
        let tags: [String: String]?
    }
}

