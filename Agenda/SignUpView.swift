//
//  SignUpView.swift
//  Agenda
//
//  Created by Abby Dominguez on 12/1/23.
//

import SwiftUI

struct SignUpView: View {
    @State var email:String = ""
    @State var password:String=""
    @State var password2:String=""
    
    @State var showAlert:Bool=false
    @State var errorContent:String = ""
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Text("Sign up")
                .font(.system(size: 60, weight: .bold))
                .foregroundColor(Color(uiColor: UIColor(named: "ColorSecondary")!))
                .padding(20)
            Spacer()
            VStack(spacing: 20) {
                TextField("Username", text: $email)
                    .padding(10)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(TextInputAutocapitalization.never)
                    .foregroundColor(Color(uiColor: UIColor(named: "ColorSecondary")!))
                    .placeholder(when: email.isEmpty) {
                       Text("Username")
                            .foregroundColor(Color(uiColor: UIColor(named: "ColorSecondary")!))
                            .padding(10)
                    }
                SecureField("Password", text: $password)
                    .padding(10)
                    .foregroundColor(Color(uiColor: UIColor(named: "ColorSecondary")!))
                    .placeholder(when: password.isEmpty) {
                   Text("Password")
                        .foregroundColor(Color(uiColor: UIColor(named: "ColorSecondary")!))
                        .padding(10)
                }
                SecureField("Repeat password", text: $password2)
                    .padding(10)
                    .foregroundColor(Color(uiColor: UIColor(named: "ColorSecondary")!))
                    .placeholder(when: password2.isEmpty) {
                   Text("Repeat password")
                        .foregroundColor(Color(uiColor: UIColor(named: "ColorSecondary")!))
                        .padding(10)
                }
            }
            .background(Color(uiColor: UIColor(named: "ColorMonoLight")!))
            .cornerRadius(18)
            .padding(40)
            Spacer()
            Button {
                signup(email: email, password: password, password2: password2)
            } label: {
                ZStack{
                    Rectangle()
                        .frame(width: 200, height: 40)
                        .cornerRadius(20)
                        .foregroundColor(Color(uiColor: UIColor(named: "ColorSecondary")!))
                    Text("Sign up")
                        .foregroundColor(Color(uiColor: UIColor(named: "ColorPrimary")!))
                }
            }
            Spacer()
            Button {
                dismiss()
            } label: {
                Text("Already have an account? Sign in")
                    .foregroundColor(Color(uiColor: UIColor(named: "ColorSecondary")!))
            }
            .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Oops!"),
                        message: Text(errorContent)
                    )
            }

        }
        .background(Color(uiColor: UIColor(named: "ColorPrimary")!))
        .navigationBarBackButtonHidden(true)
    }
    
    private func signup(email: String, password: String, password2: String){
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
        if password.count <= 6 {
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
                onError(error.localizedDescription)
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
        dismiss()
    }
    func onError(_ error: String){
        showAlert = true
        errorContent = error
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
