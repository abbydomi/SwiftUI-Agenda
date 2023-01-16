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
    var body: some View {
            VStack {
                Text("Login")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(Color.blue)
                    .padding(20)
                Spacer()
                VStack(spacing: 20) {
                    TextField("Email", text: $email)
                        .padding(10)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(TextInputAutocapitalization.never)
                    SecureField("Password", text: $password)
                        .padding(10)
                }
                .background(Color.white)
                .cornerRadius(18)
                .padding(40)
                Spacer()
                Button {
                    //Login
                } label: {
                    ZStack{
                        Rectangle()
                            .frame(width: 200, height: 40)
                            .cornerRadius(20)
                        Text("Sign in")
                            .foregroundColor(Color.yellow)
                    }
                }
                Spacer()
                NavigationLink(destination: SignUpView()) {
                    Text("Don't have an account? Sign up")
                }
                
            }.background(Color.yellow)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
