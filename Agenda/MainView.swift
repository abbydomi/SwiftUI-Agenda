//
//  MainView.swift
//  Agenda
//
//  Created by Abby Dominguez on 19/1/23.
//

import SwiftUI

struct EventResponseModel: Decodable {

    let name: String?
    let date: Int?

    enum CodingKeys: String, CodingKey {
        case name
        case date
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let date = try? values.decodeIfPresent(Int.self, forKey: .date) {
            self.date = Int(date)
        } else if let date = try? values.decodeIfPresent(String.self, forKey: .date) {
            self.date = Int(date)
        } else if let _ = try? values.decodeIfPresent(Float.self, forKey: .date) {
            self.date = nil //<-- WTF!!!
        }
        else {
            self.date = try values.decodeIfPresent(Int.self, forKey: .date)
        }
        self.name = try values.decodeIfPresent(String.self, forKey: .name)
    }
}

struct EventPresentationModel: Identifiable {
    let id = UUID()
    let name: String
    let date: Int
}

struct MainView: View {
    
    @State var events: [EventPresentationModel] = []
    @State private var showNewEvent = false
    @State var username:String
    
    var body: some View {
        ZStack{
            Color(uiColor: UIColor(named: "ColorPrimary")!)
            VStack{
                Spacer()
                HStack{
                    AsyncImage(url: URL(string: "https://placekitten.com/100/100")) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .clipShape(Circle())
                    .padding(.leading, 20)
                    .frame(width: 100, height: 100)
                    Text(username+"'s Agenda")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(Color(uiColor: UIColor(named: "ColorSecondary")!))
                        .padding(.trailing, 10)
                        .minimumScaleFactor(0.4)
                        .lineLimit(1)
                }
                .padding(.top, 50)
                .padding(.bottom, 1)
                VStack{
                    ZStack{
                        ScrollView{
                            LazyVStack(spacing: 10){
                                ForEach(events) { event in
                                    NavigationLink {
                                        DetailView(eventTitle: event.name, fullDate: "\(NSDate(timeIntervalSince1970: TimeInterval(event.date)))")
                                    } label: {
                                        VStack{
                                            HStack {
                                                Text(event.name)
                                                    .padding(10)
                                                    .foregroundColor(Color(uiColor: UIColor(named: "ColorSecondary")!))
                                                Spacer()
                                                Text(getDate(event: event))
                                                    .padding(10)
                                                    .foregroundColor(Color(uiColor: UIColor(named: "ColorSecondary")!))
                                            }
                                            Rectangle()
                                                .frame(width: UIScreen.main.bounds.width, height: 1)
                                                .foregroundColor(Color(uiColor: UIColor(named: "ColorPrimary")!))
                                        }
                                    }
                                    
                                    
                                }
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(30)
                        .padding(10)
                        VStack{
                            Spacer()
                            HStack{
                                Spacer()
                                Button {
                                   showNewEvent = true
                                } label: {
                                    ZStack{
                                        Circle()
                                            .foregroundColor(.white)
                                            .frame(width: 80, height: 80)
                                        Image(systemName: "plus.circle.fill")
                                            .font(.system(size: 85))
                                            .foregroundColor(Color(uiColor: UIColor(named: "ColorSecondary")!))
                                    }
                                    
                                }
                                .padding(10)
                            }
                        }
                    }
                    Spacer()
                }
            }

        }
        .sheet(isPresented: $showNewEvent, content: {
            CreateEventView {
                getEvents()
            }
        })
        .onAppear{
            getEvents()
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
    }
    private func getEvents(){
        let url = "https://superapi.netlify.app/api/db/eventos"
        
        NetworkHelper.shared.requestProvider(url: url, type: .GET) { data, response, error in
            if let error = error {
                onError(error.localizedDescription)
            } else if let data = data, let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    self.onSuccess(data: data)
                } else {
                    self.onError(error?.localizedDescription ?? "Request error")
                }
            }
        }
    }
    func onError(_ error: String){
        print(error)
    }
    func onSuccess(data: Data){
        do {
            let eventsUnfiltered = try JSONDecoder().decode([EventResponseModel?].self, from: data)
            self.events = eventsUnfiltered.compactMap({ event in
                guard let date = event?.date else {return nil}
                return EventPresentationModel(name: event?.name ?? "Unnamed Event", date: date)
            })
        } catch {
            onError(error.localizedDescription)
        }
    }
    func getDate(event: EventPresentationModel) -> String{
        let date = NSDate(timeIntervalSince1970: TimeInterval(event.date))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_ES")
        dateFormatter.dateFormat = "dd-MM-YYYY"
        let converted = dateFormatter.string(from: date as Date)
        
        return converted
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView( username: "Abby")
    }
}
