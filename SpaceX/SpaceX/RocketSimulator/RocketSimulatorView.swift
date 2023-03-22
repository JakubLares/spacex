//
//  RocketSimulatorView.swift
//  SpaceX
//
//  Created by Jakub Lares on 21.03.2023.
//

import SwiftUI
import ComposableArchitecture

struct RocketSimulator: ReducerProtocol {
    struct State: Equatable {
        var launched = false
    }

    enum Action {
        case launch
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .launch:
            return .none
        }
    }
}

struct RocketSimulatorView: View {
    let store: StoreOf<RocketSimulator>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                Image("Rocket Idle")
                Text("Move your phone up to launch the rocket")
                    .frame(maxWidth: 200)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

struct RocketSimulatorView_Previews: PreviewProvider {
    static var previews: some View {
        RocketSimulatorView(store: Store(initialState: RocketSimulator.State(), reducer: RocketSimulator()))
    }
}
