//
//  RocketList.swift
//  SpaceX
//
//  Created by Jakub Lares on 17.03.2023.
//

import SwiftUI

struct RocketList: View {

    @State private var rockets = Rockets()

    var body: some View {
        NavigationStack {
            List(rockets) { rocket in
                NavigationLink(value: rocket) {
                    RocketListRow(rocket: rocket)
                }
            }
            .navigationDestination(for: Rocket.self) { rocket in
                RocketDetail(rocket: rocket)
            }
            .navigationTitle("Rockets")
        }
        .task {
            do {
                rockets = try await APIClient().fetchRockets() ?? []
            } catch {
                print("Error", error)
            }
        }
    }
}

struct RocketList_Previews: PreviewProvider {
    static var previews: some View {
        RocketList()
    }
}
