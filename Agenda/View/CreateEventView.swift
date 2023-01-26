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
    @State var showAlert: Bool = false
    @State var errorContent: String = ""
    var completion: () -> () = {}
    
    var body: some View {
        ZStack{
            
            Color(uiColor: UIColor(named: "ColorSecondary")!)
            VStack{
                Text("New Event")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(Color(uiColor: UIColor(named: "ColorPrimary")!))
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
                            .colorMultiply(Color(uiColor: UIColor(named: "ColorSecondary")!))
                    }
 
                ZStack{
                    Rectangle()
                        .foregroundColor(Color(uiColor: UIColor(named: "ColorMonoLight")!))
                        .frame(height: 50)
                        .cornerRadius(20)
                    TextField("Event name:", text: $eventName)
                        .placeholder(when: eventName.isEmpty, placeholder: {
                            Text("Event name:")
                                .foregroundColor(Color(uiColor: UIColor(named: "ColorSecondary")!))
                        })
                        .foregroundColor(Color(uiColor: UIColor(named: "ColorSecondary")!))
                        .frame(height: 50)
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding(.horizontal, 20)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                
                Button {
                    addEvent(evName: eventName, evDate: dateToInt(date: datePicked))
                } label: {
                    Text("Add event")
                        .foregroundColor(Color(uiColor: UIColor(named: "ColorSecondary")!))
                        .padding(20)
                        .background(Color(uiColor: UIColor(named: "ColorPrimary")!))
                        .cornerRadius(12)
                
                    
                }
                Spacer()
                .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Oops!"),
                            message: Text(errorContent)
                        )
                }
            }
        }
        .ignoresSafeArea()
        .onDisappear(){
            completion()
        }
    }
    func dateToInt(date: Date) -> Int{
        return Int(date.timeIntervalSince1970)
    }
    func onError(_ error:String){
        showAlert = true
        errorContent = error
    }
    func onSuccess(){
        dismiss()
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
}

struct CreateEventView_Previews: PreviewProvider {
    static var previews: some View {
        CreateEventView()
    }
}
