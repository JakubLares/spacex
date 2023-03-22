//
//  RocketSimulatorView.swift
//  SpaceX
//
//  Created by Jakub Lares on 21.03.2023.
//

import SwiftUI
import Dependencies
import ComposableArchitecture

struct RocketSimulator: ReducerProtocol {
    struct State: Equatable {
        var image = "Rocket Idle"
        var text = "Move your phone up to launch the rocket"
        var offset: CGFloat = 0
    }

    enum Action {
        case launch(Double)
        case changeOffset
        case changeImageAndText
        case motionMonitorStart
        case motionMonitorEnd
    }

    @Dependency(\.motionRepository) var motionRepository

    struct RocketSimulatorId: Hashable {}

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .motionMonitorStart:
            return .run { send in
                await withTaskCancellation(id: RocketSimulatorId.self, operation: {
                    for await rotationRateX in await self.motionRepository.rotationRateX() {
                        await send(.launch(rotationRateX))
                    }
                })
            }
        case let .launch(rotationRateX):
            if rotationRateX > 3 || rotationRateX < -3 {
                return EffectTask.concatenate(
                    .send(.changeImageAndText),
                    .send(.motionMonitorEnd),
                    .task {
                        withAnimation() {
                            .changeOffset
                        }
                    }
                    .receive(on: DispatchQueue.main.animation(.easeIn(duration: 1)))
                    .eraseToEffect()
                )
            }
            return .none
        case .changeOffset:
            state.offset = -500
            return .none
        case .changeImageAndText:
            state.image = "Rocket Flying"
            state.text = "Launch successfull!"
            return .none
        case .motionMonitorEnd:
            return .cancel(id: RocketSimulatorId.self)
        }
    }
}

struct RocketSimulatorView: View {
    let store: StoreOf<RocketSimulator>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                Image(viewStore.image)
                    .offset(y: viewStore.offset)
                Text(viewStore.text)
                    .frame(maxWidth: 200)
                    .multilineTextAlignment(.center)
            }
            .onAppear {
                viewStore.send(.motionMonitorStart)
            }
            .onDisappear {
                viewStore.send(.motionMonitorEnd)
            }
        }
    }
}

struct RocketSimulatorView_Previews: PreviewProvider {
    static var previews: some View {
        RocketSimulatorView(store: Store(initialState: RocketSimulator.State(), reducer: RocketSimulator()))
    }
}
