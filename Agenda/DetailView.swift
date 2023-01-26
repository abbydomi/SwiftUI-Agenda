//
//  DetailView.swift
//  Agenda
//
//  Created by Abby Dominguez on 26/1/23.
//

import SwiftUI

struct DetailView: View {
    @State var eventTitle:String
    @State var fullDate:String
    var body: some View {
        ZStack{
            Color(uiColor: UIColor(named: "ColorSecondary")!)
            VStack{
                Spacer()
                Text(eventTitle)
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(Color(uiColor: UIColor(named: "ColorPrimary")!))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 50)
                    .minimumScaleFactor(0.4)
                    .lineLimit(2)
                AsyncImage(url: URL(string: "https://placekitten.com/1000/1000")) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .cornerRadius(20)
                .padding(20)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                Text(fullDate)
                    .font(.system(size: 24))
                    .foregroundColor(Color(uiColor: UIColor(named: "ColorPrimary")!))
                Spacer()
            }
        }.ignoresSafeArea()
            
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(eventTitle: "Test", fullDate: "Ok")
    }
}
