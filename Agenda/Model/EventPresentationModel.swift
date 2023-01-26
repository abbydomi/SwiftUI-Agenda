//
//  EventPresentationModel.swift
//  Agenda
//
//  Created by Abby Dominguez on 26/1/23.
//

import Foundation

struct EventPresentationModel: Identifiable {
    let id = UUID()
    let name: String
    let date: Int
}
