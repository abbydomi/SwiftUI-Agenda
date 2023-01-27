//
//  MainView.swift
//  Agenda
//
//  Created by Abby Dominguez on 19/1/23.
//

import SwiftUI

struct MainView: View {
    @State var username:String
    
    @ObservedObject var vm = MainViewModel()
    
    var body: some View {
        ZStack{
            Color(uiColor: UIColor(named: "ColorPrimary")!)
            VStack{
                Spacer()
                HStack{
                    AsyncImage(url: URL(string: "https://placekitten.com/100/100")) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .clipShape(Circle())
                    .padding(.leading, 20)
                    .frame(width: 100, height: 100)
                    Text(username+"'s Agenda")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(Color(uiColor: UIColor(named: "ColorSecondary")!))
                        .padding(.trailing, 10)
                        .minimumScaleFactor(0.4)
                        .lineLimit(1)
                }
                .padding(.top, 50)
                .padding(.bottom, 1)
                VStack{
                    ZStack{
                        ScrollView{
                            LazyVStack(spacing: 10){
                                ForEach(vm.events) { event in
                                    NavigationLink {
                                        DetailView(eventTitle: event.name, fullDate: "\(NSDate(timeIntervalSince1970: TimeInterval(event.date)))")
                                    } label: {
                                        VStack{
                                            HStack {
                                                Text(event.name)
                                                    .lineLimit(5)
                                                    .padding(10)
                                                    .foregroundColor(Color(uiColor: UIColor(named: "ColorSecondary")!))
                                                Spacer()
                                                Text(vm.getDate(event: event))
                                                    .padding(10)
                                                    .foregroundColor(Color(uiColor: UIColor(named: "ColorSecondary")!))
                                            }
                                            Rectangle()
                                                .frame(width: UIScreen.main.bounds.width, height: 1)
                                                .foregroundColor(Color(uiColor: UIColor(named: "ColorPrimary")!))
                                        }
                                    }
                                    
                                    
                                }
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(30)
                        .padding(10)
                        VStack{
                            Spacer()
                            HStack{
                                Spacer()
                                Button {
                                    vm.showNewEvent = true
                                } label: {
                                    ZStack{
                                        Circle()
                                            .foregroundColor(.white)
                                            .frame(width: 80, height: 80)
                                        Image(systemName: "plus.circle.fill")
                                            .font(.system(size: 85))
                                            .foregroundColor(Color(uiColor: UIColor(named: "ColorSecondary")!))
                                    }
                                    
                                }
                                .padding(10)
                            }
                        }
                    }
                    Spacer()
                }
            }

        }
        .sheet(isPresented: $vm.showNewEvent, content: {
            CreateEventView {
                vm.getEvents()
            }
        })
        .onAppear{
            vm.getEvents()
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView( username: "Abby")
    }
}
