//
//  RocketList.swift
//  SpaceX
//
//  Created by Jakub Lares on 17.03.2023.
//

import SwiftUI
import ComposableArchitecture

struct RocketList: ReducerProtocol {

    struct State: Equatable {
        var rockets: IdentifiedArrayOf<RocketDetail.State> = []
    }

    enum Action: Equatable {
        case getRockets
        case rockets(TaskResult<[Rocket]>)
        case rocket(id: RocketDetail.State.ID, action: RocketDetail.Action)
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .getRockets:
            return EffectTask.task {
                await .rockets(
                    TaskResult {
                        try await APIClient().fetchRockets()
                    }
                )
            }
        case let .rockets(.success(rockets)):
            state.rockets = IdentifiedArrayOf(uniqueElements: rockets)
            return .none
        case .rockets(.failure(_)):
            print("Failure")
            return .none
        }
    }
}

struct RocketListView: View {

    let store: StoreOf<RocketList>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationStack {
                List {
                    ForEachStore(self.store.scope(state: \.rockets, action: RocketList.Action.rocket(id:action:))) { rocket in
                        NavigationLink {
                            RocketDetailView(store: rocket)
                        } label: {
                            RocketListRow(store: rocket)
                        }
                    }
                }
                .navigationTitle("Rockets")
            }
            .onAppear {
                viewStore.send(.getRockets)
            }
        }
    }
}

struct RocketList_Previews: PreviewProvider {
    static var previews: some View {
        RocketListView(
            store:
                Store(
                    initialState: RocketList.State(),
                    reducer: Reducer(RocketList()),
                    environment: ()
                )
        )
    }
}
