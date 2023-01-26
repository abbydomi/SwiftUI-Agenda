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
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm = SignUpViewModel()
    
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
                vm.signup(email: email, password: password, password2: password2)
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
            .alert(isPresented: $vm.showAlert) {
                Alert(
                    title: Text("Oops!"),
                    message: Text(vm.errorContent)
                )
            }
            .onChange(of: vm.dismiss) { newValue in
                if newValue == true{
                    dismiss()
                }
            }
            
        }
        .background(Color(uiColor: UIColor(named: "ColorPrimary")!))
        .navigationBarBackButtonHidden(true)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
