import SwiftUI
import FirebaseFirestore

struct CreateView: View
{
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var showCreateView: Bool
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var category: String = ""
    @State private var perks: String = ""
    @State private var sponsor: String = ""
    @State private var latitude: String = ""
    @State private var longitude: String = ""
    @State private var date: Date = Date()
    @State private var isSaving = false
    @State private var saveError: String?

    private let db = Firestore.firestore()

    var body: some View
    {
        VStack
        {
            HStack
            {
                Button(action:
                        {
                    showCreateView = false
                }) {
                    HStack {
                        
                    }
                    
                }
                Spacer()
            }
            .padding()

            

            Spacer()

            VStack(spacing: 20)
            {
                TextField("Title", text: $title)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)

                TextField("Description", text: $description)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)

                TextField("Category", text: $category)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)

                TextField("Perks", text: $perks)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)

                TextField("Sponsor", text: $sponsor) // Sponsor input field
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)

                TextField("Latitude", text: $latitude) // Latitude input field
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)

                TextField("Longitude", text: $longitude) // Longitude input field
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)

                DatePicker("Date and Time", selection: $date, displayedComponents: [.date, .hourAndMinute])
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
            }
            .padding()

            Spacer()

            if isSaving
            {
                ProgressView("Saving...")
                    .padding()
            } else if let saveError = saveError
            {
                Text("Error: \(saveError)")
                    .foregroundColor(.red)
                    .padding()
            }

            Button(action: saveEvent)
            {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }

    private func saveEvent()
    {
        guard !title.isEmpty, !description.isEmpty, !category.isEmpty, !latitude.isEmpty, !longitude.isEmpty, !sponsor.isEmpty else
        {
            saveError = "All fields are required."
            return
        }

        isSaving = true
        saveError = nil

        guard let lat = Double(latitude), let long = Double(longitude) else
        {
            saveError = "Invalid latitude or longitude values."
            return
        }

        let eventData: [String: Any] =
        [
            "title": title,
            "description": description,
            "category": category,
            "perks": perks,
            "sponsor": sponsor,
            "latitude": lat,
            "longitude": long,
            "date": date
        ]

        db.collection("events").addDocument(data: eventData)
        { error in
            isSaving = false
            if let error = error
            {
                saveError = "Failed to save event: \(error.localizedDescription)"
            } else
            {
                print("Event successfully saved!")
                showCreateView = false
            }
        }
    }
}

struct CreateView_Previews: PreviewProvider
{
    static var previews: some View
    {
        CreateView(showCreateView: .constant(true))
            .environmentObject(AuthViewModel())
    }
}

