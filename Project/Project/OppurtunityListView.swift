import SwiftUI
import FirebaseFirestore

struct OpportunityListView: View
{
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var showOpportunityListView: Bool
    @State private var events: [Event] = []
    @State private var isLoading = true
    @State private var fetchError: String?

    private let db = Firestore.firestore()

    var body: some View
    {
        VStack
        {
            HStack
            {
                Button(action:
                        {
                    showOpportunityListView = false
                })
                {
                    HStack {}
                }
                Spacer()
            }
            .padding()

            Text("OPPORTUNITIES")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            if isLoading
            {
                ProgressView("Loading...")
                    .padding()
            } else if let fetchError = fetchError
            {
                Text("Error: \(fetchError)")
                    .foregroundColor(.red)
                    .padding()
            } else if events.isEmpty
            {
                Text("No events available.")
                    .foregroundColor(.gray)
                    .padding()
            } else
            {
                TableView(events: $events)
            }
        }
        .onAppear(perform: fetchEvents)
    }

    private func fetchEvents()
    {
        isLoading = true
        fetchError = nil

        db.collection("events").getDocuments
        { snapshot, error in
            isLoading = false

            if let error = error
            {
                fetchError = "Failed to fetch events: \(error.localizedDescription)"
                return
            }

            guard let documents = snapshot?.documents else
            {
                fetchError = "No data found."
                return
            }

            events = documents.compactMap
            { doc -> Event? in
                let data = doc.data()
                return Event(
                    id: doc.documentID,
                    title: data["title"] as? String ?? "",
                    description: data["description"] as? String ?? "",
                    sponsor: data["sponsor"] as? String ?? "",
                    category: data["category"] as? String ?? "",
                    perks: data["perks"] as? String ?? "",
                    location: data["location"] as? String ?? "",
                    date: (data["date"] as? Timestamp)?.dateValue() ?? Date()
                )
            }
        }
    }
}

struct TableView: View
{
    @Binding var events: [Event]
    @State private var expandedIndex: Int?

    var body: some View
    {
        List(events.indices, id: \.self)
        { index in
            let event = events[index]

            VStack(alignment: .leading, spacing: 10)
            {
                HStack
                {
                    VStack(alignment: .leading, spacing: 5)
                    {
                        Text(" \(event.sponsor)")
                            .font(.footnote)
                            .foregroundColor(.blue)

                        Text(event.title)
                            .font(.headline)

                        Text(event.description)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    Button(action:
                    {
                        expandedIndex = expandedIndex == index ? nil : index
                    })
                    {
                        Image(systemName: expandedIndex == index ? "chevron.up.circle" : "chevron.down.circle")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.blue)
                    }
                }

                if expandedIndex == index
                {
                    VStack(alignment: .leading, spacing: 5)
                    {
                        Text("Category: \(event.category)")
                            .font(.footnote)

                        Text("Perks: \(event.perks)")
                            .font(.footnote)

                        Text("Location: \(event.location)")
                            .font(.footnote)

                        Text("Date: \(event.date, formatter: eventDateFormatter)")
                            .font(.footnote)
                    }
                    .padding(.top, 10)
                    .cornerRadius(5)
                }
            }
            .padding()
        }
    }
}

struct Event: Identifiable
{
    var id: String?
    var title: String
    var description: String
    var sponsor: String
    var category: String
    var perks: String
    var location: String
    var date: Date
}

let eventDateFormatter: DateFormatter =
{
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()

struct OpportunityListView_Previews: PreviewProvider
{
    static var previews: some View
    {
        OpportunityListView(showOpportunityListView: .constant(true))
            .environmentObject(AuthViewModel())
    }
}

