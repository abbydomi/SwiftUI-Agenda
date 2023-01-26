//
//  SignUpViewModel.swift
//  Agenda
//
//  Created by Abby Dominguez on 26/1/23.
//

import SwiftUI

class SignUpViewModel: ObservableObject {
    @Published var showAlert:Bool = false
    @Published var errorContent:String = ""
    @Published var dismiss:Bool = false
    
    func signup(email: String, password: String, password2: String){
        //MARK: - Signup validation
        if email.isEmpty{
            showAlert = true
            errorContent = "Username cannot be empty"
            return
        }
        if password.isEmpty {
            showAlert = true
            errorContent = "Password cannot be empty"
            return
        }
        if password.count < 6 {
            showAlert = true
            errorContent = "Password cannot be shorter than 6 characters"
            return
        }
        if password != password2 {
            showAlert = true
            errorContent = "Passwords do not match"
            return
        }
        //MARK: - Sign up request
        let url = "https://superapi.netlify.app/api/register"
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
    func onSuccess(){
        dismiss = true
    }
    func onError(_ error: String){
        showAlert = true
        errorContent = error
    }
}
