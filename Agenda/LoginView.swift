//
//  ContentView.swift
//  Agenda
//
//  Created by Abby Dominguez on 9/1/23.
//

import SwiftUI

struct LoginView: View {
    @State var email:String = ""
    @State var password:String=""
    @State var showAlert:Bool=false
    @State var errorContent:String = ""
    @State var gotomain:Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Login")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(Color(uiColor: UIColor(named: "ColorSecondary")!))
                    .padding(20)
                Spacer()
                VStack(spacing: 20) {
                    TextField("Username", text: $email)
                        .placeholder(when: email.isEmpty, placeholder: {
                            Text("Username")
                                .foregroundColor(Color(uiColor: UIColor(named: "ColorSecondary")!))
                        })
                        .padding(10)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(TextInputAutocapitalization.never)
                    SecureField("Password", text: $password)
                        .placeholder(when: password.isEmpty, placeholder: {
                            Text("Password")
                                .foregroundColor(Color(uiColor: UIColor(named: "ColorSecondary")!))
                        })
                        .padding(10)
                }
                .foregroundColor(Color(uiColor: UIColor(named: "ColorSecondary")!))
                .background(Color(uiColor: UIColor(named: "ColorMonoLight")!))
                .cornerRadius(18)
                .padding(40)
                Spacer()
                Button {
                    login(email: email, password: password)
                } label: {
                    ZStack{
                        Rectangle()
                            .frame(width: 200, height: 40)
                            .cornerRadius(20)
                            .foregroundColor(Color(uiColor: UIColor(named: "ColorSecondary")!))
                        Text("Sign in")
                            .foregroundColor(Color(uiColor: UIColor(named: "ColorPrimary")!))
                    }
                }
                .background(
                    NavigationLink(destination: MainView(username: email), isActive: $gotomain){
                        EmptyView()
                    }
                )
                .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Error loging in"),
                            message: Text(errorContent)
                        )
                }
                
                Spacer()
                NavigationLink(destination: SignUpView()) {
                    Text("Don't have an account? Sign up")
                        .foregroundColor(Color(uiColor: UIColor(named: "ColorSecondary")!))
                }
                
            }.background(Color(uiColor: UIColor(named: "ColorPrimary")!))
        }
        .accentColor(Color(uiColor: UIColor(named: "ColorPrimary")!))
            
            
    }
    private func login(email: String, password: String){
        let url = "https://superapi.netlify.app/api/login"
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
        gotomain = true
    }
    func onError(_ error: String){
        showAlert = true
        errorContent = error
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
