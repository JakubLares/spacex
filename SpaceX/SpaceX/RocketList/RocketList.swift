//
//  RocketList.swift
//  SpaceX
//
//  Created by Jakub Lares on 17.03.2023.
//

import SwiftUI

struct Rocket: Identifiable, Hashable {
    var id = UUID()
}

struct RocketList: View {

    @State private var rockets = [Rocket(), Rocket(), Rocket()]

    var body: some View {
        NavigationStack {
            List(rockets) { rocket in
                NavigationLink(value: rocket) {
                    RocketListRow()
                }
            }
            .navigationDestination(for: Rocket.self) { rocket in
                RocketDetail()
            }
            .navigationTitle("Rockets")
        }
    }
}

struct RocketList_Previews: PreviewProvider {
    static var previews: some View {
        RocketList()
    }
}
