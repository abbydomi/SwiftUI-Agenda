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
    var body: some View {
        VStack {
            Text("Sign up")
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
                SecureField("Repeat password", text: $password2)
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
                    Text("Sign up")
                        .foregroundColor(Color.yellow)
                }
            }
            Spacer()
            NavigationLink {
                LoginView()
            } label: {
                Text("Already have an account? Sign in")
            }

        }.background(Color.yellow)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
