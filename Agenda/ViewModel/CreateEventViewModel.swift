//
//  CreateEventViewModel.swift
//  Agenda
//
//  Created by Abby Dominguez on 27/1/23.
//

import Foundation

class CreateEventViewModel: ObservableObject {
    @Published var showAlert: Bool = false
    @Published var errorContent: String = ""
    @Published var dismiss = false
    
    func dateToInt(date: Date) -> Int{
        return Int(date.timeIntervalSince1970)
    }
    func onError(_ error:String){
        showAlert = true
        errorContent = error
    }
    func onSuccess(){
        dismiss = true
    }
    func addEvent(evName: String, evDate: Int){
        if evName.isEmpty{
            showAlert = true
            errorContent = "Please add an event name"
            return
        }
        
        let url = "https://superapi.netlify.app/api/db/eventos"
        let dictionary: [String: Any] = [
            "name": evName,
            "date": evDate
        ]
        NetworkHelper.shared.requestProvider(url: url, type: .POST, params: dictionary) { data, response, error in
            if let error = error {
                self.onError(error.localizedDescription)
            } else if let data = data, let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    self.onSuccess()
                } else {
                    self.onError(error?.localizedDescription ?? "Request error")
                }
            }
        }
    }
}
