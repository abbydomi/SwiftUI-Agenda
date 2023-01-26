//
//  LoginViewModel.swift
//  Agenda
//
//  Created by Abby Dominguez on 26/1/23.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var gotomain:Bool = false
    @Published var showAlert:Bool=false
    @Published var errorContent:String = ""
    
    private func onSuccess(){
        gotomain = true
    }
    private func onError(_ error: String){
        showAlert = true
        errorContent = error
    }
    func login(email: String, password: String){
        let url = "https://superapi.netlify.app/api/login"
        let dictionary = [
            "user" : email,
            "pass" : password
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
