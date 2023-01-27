//
//  CreateEventView.swift
//  Agenda
//
//  Created by Abby Dominguez on 20/1/23.
//

import SwiftUI

struct CreateEventView: View {
    @Environment(\.dismiss) private var dismiss
    @State var datePicked: Date = Date()
    @State var eventName: String = ""
    
    @ObservedObject var vm = CreateEventViewModel()
    var completion: () -> () = {}
    
    var body: some View {
        ZStack{
            Color(uiColor: UIColor(named: "ColorSecondary") ?? UIColor.blue)
            VStack{
                Text("New Event")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(Color(uiColor: UIColor(named: "ColorPrimary") ?? UIColor.yellow))
                    .padding(20)
                    ZStack{
                        Rectangle()
                            .frame(width: UIScreen.main.bounds.width/1.1, height: 200)
                            .foregroundColor(Color.white)
                            .cornerRadius(20)
                            .padding(.horizontal, 20)
                        DatePicker("", selection: $datePicked, displayedComponents: .date)
                            .datePickerStyle(.wheel)
                            .cornerRadius(20)
                            .padding(.horizontal, 20)
                            .colorInvert()
                            .colorMultiply(Color(uiColor: UIColor(named: "ColorSecondary") ?? UIColor.blue))
                    }
 
                ZStack{
                    Rectangle()
                        .foregroundColor(Color(uiColor: UIColor(named: "ColorMonoLight") ?? UIColor.white))
                        .frame(height: 50)
                        .cornerRadius(20)
                    TextField("Event name:", text: $eventName)
                        .placeholder(when: eventName.isEmpty, placeholder: {
                            Text("Event name:")
                                .foregroundColor(Color(uiColor: UIColor(named: "ColorSecondary") ?? UIColor.blue))
                        })
                        .foregroundColor(Color(uiColor: UIColor(named: "ColorSecondary") ?? UIColor.blue))
                        .frame(height: 50)
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding(.horizontal, 20)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                
                Button {
                    vm.addEvent(evName: eventName, evDate: vm.dateToInt(date: datePicked))
                } label: {
                    Text("Add event")
                        .foregroundColor(Color(uiColor: UIColor(named: "ColorSecondary") ?? UIColor.blue))
                        .padding(20)
                        .background(Color(uiColor: UIColor(named: "ColorPrimary") ?? UIColor.yellow))
                        .cornerRadius(12)
                }
                Spacer()
            }
        }
        .alert(isPresented: $vm.showAlert) {
            Alert(
                title: Text("Oops!"),
                message: Text(vm.errorContent)
            )
        }
        .ignoresSafeArea()
        .onChange(of: vm.dismiss, perform: { newValue in
            if newValue == true {
                dismiss()
            }
        })
        .onDisappear(){
            completion()
        }
    }
}

struct CreateEventView_Previews: PreviewProvider {
    static var previews: some View {
        CreateEventView()
    }
}
