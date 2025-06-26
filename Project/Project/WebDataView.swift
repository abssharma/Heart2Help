import SwiftUI

struct WebDataView: View
{
    @StateObject private var webDataManager = WebDataManager()

    var body: some View
    {
        VStack
        {
            if webDataManager.isLoading
            {
                ProgressView("Fetching Community Centers...")
                    .padding()
            } else if let error = webDataManager.fetchError
            {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .padding()
            } else if webDataManager.volunteerCenters.isEmpty
            {
                Text("No Community Centers Found.")
                    .foregroundColor(.gray)
                    .padding()
            } else
            {
                List(webDataManager.volunteerCenters)
                { center in
                    VStack(alignment: .leading)
                    {
                        Text(center.name ?? "Unknown Center")
                            .font(.headline)
                        Text("Lat: \(center.latitude), Lon: \(center.longitude)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .onAppear
        {
            webDataManager.fetchVolunteerCenters()
        }
        .navigationTitle("Community Centers")
    }
}

struct WebDataView_Previews: PreviewProvider
{
    static var previews: some View
    {
        WebDataView()
    }
}

