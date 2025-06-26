import SwiftUI

struct HomeView: View
{
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var showHomeView: Bool
    var username: String = "USERNAME"

    var body: some View
    {
        NavigationView
        {
            ZStack
            {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack
                {

                    Spacer()
                    
                    HStack(spacing: 40)
                    {
                        NavigationLink(destination: OpportunityListView(showOpportunityListView: .constant(true)))
                        {
                            Image(systemName: "play.circle.fill")
                                .resizable()
                                .frame(width: 70, height: 70)
                                .foregroundColor(.black)
                        }

                        NavigationLink(destination: MapView())
                        {
                            Image(systemName: "map.fill")
                                .resizable()
                                .frame(width: 70, height: 70)
                                .foregroundColor(.black)
                        }

                        NavigationLink(destination: WebDataView())
                        {
                            Image(systemName: "network")
                                .resizable()
                                .frame(width: 70, height: 70)
                                .foregroundColor(.black)
                        }
                    }
                    .padding()

                    NavigationLink(destination: CreateView(showCreateView: .constant(true)))
                    {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .foregroundColor(.blue)
                    }
                    .padding()

                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct HomeView_Previews: PreviewProvider
{
    static var previews: some View
    {
        HomeView(showHomeView: .constant(true))
            .environmentObject(AuthViewModel())
    }
}

