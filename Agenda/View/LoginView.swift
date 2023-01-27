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
    @ObservedObject var vm = LoginViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Login")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(Color(uiColor: UIColor(named: "ColorSecondary") ?? UIColor.yellow))
                    .padding(20)
                Spacer()
                VStack(spacing: 20) {
                    TextField("Username", text: $email)
                        .placeholder(when: email.isEmpty, placeholder: {
                            Text("Username")
                                .foregroundColor(Color(uiColor: UIColor(named: "ColorSecondary") ?? UIColor.blue))
                        })
                        .padding(10)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(TextInputAutocapitalization.never)
                    SecureField("Password", text: $password)
                        .placeholder(when: password.isEmpty, placeholder: {
                            Text("Password")
                                .foregroundColor(Color(uiColor: UIColor(named: "ColorSecondary") ?? UIColor.yellow))
                        })
                        .padding(10)
                }
                .foregroundColor(Color(uiColor: UIColor(named: "ColorSecondary") ?? UIColor.yellow))
                .background(Color(uiColor: UIColor(named: "ColorMonoLight") ?? UIColor.white))
                .cornerRadius(18)
                .padding(40)
                Spacer()
                Button {
                    vm.login(email: email, password: password)
                } label: {
                    ZStack{
                        Rectangle()
                            .frame(width: 200, height: 40)
                            .cornerRadius(20)
                            .foregroundColor(Color(uiColor: UIColor(named: "ColorSecondary") ?? UIColor.blue))
                        Text("Sign in")
                            .foregroundColor(Color(uiColor: UIColor(named: "ColorPrimary") ?? UIColor.yellow))
                    }
                }
                .background(
                    NavigationLink(destination: MainView(username: email), isActive: $vm.gotomain){
                        EmptyView()
                    }
                )
                .alert(isPresented: $vm.showAlert) {
                        Alert(
                            title: Text("Error loging in"),
                            message: Text(vm.errorContent)
                        )
                }
                
                Spacer()
                NavigationLink(destination: SignUpView()) {
                    Text("Don't have an account? Sign up")
                        .foregroundColor(Color(uiColor: UIColor(named: "ColorSecondary") ?? UIColor.blue))
                }
                
            }.background(Color(uiColor: UIColor(named: "ColorPrimary") ?? UIColor.yellow))
        }
        .accentColor(Color(uiColor: UIColor(named: "ColorPrimary") ?? UIColor.yellow))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
