//
//  MainViewModel.swift
//  Agenda
//
//  Created by Abby Dominguez on 27/1/23.
//

import Foundation

class MainViewModel: ObservableObject {
    @Published var events: [EventPresentationModel] = []
    @Published var showNewEvent = false
    func getEvents(){
        let url = "https://superapi.netlify.app/api/db/eventos"
        
        NetworkHelper.shared.requestProvider(url: url, type: .GET) { data, response, error in
            if let error = error {
                self.onError(error.localizedDescription)
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
