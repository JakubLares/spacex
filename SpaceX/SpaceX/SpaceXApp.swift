//
//  SpaceXApp.swift
//  SpaceX
//
//  Created by Jakub Lares on 17.03.2023.
//

import SwiftUI
import ComposableArchitecture

@main
struct SpaceXApp: App {
    var body: some Scene {
        WindowGroup {
            RocketListView(
                store:
                    Store(
                        initialState: RocketList.State(),
                        reducer: RocketList()
                    )
            )
        }
    }
}
