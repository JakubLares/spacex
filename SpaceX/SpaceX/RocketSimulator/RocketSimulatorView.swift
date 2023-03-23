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
        var launched = false
        var rocketShaking = false
    }

    enum Action {
        case motionChanged(Double)
        case launch
        case rocketShaking
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
                        await send(.motionChanged(rotationRateX))
                    }
                })
            }
        case let .motionChanged(rotationRateX):
            if rotationRateX > 3 || rotationRateX < -3 {
                return EffectTask.concatenate(
                    .send(.changeImageAndText),
                    .send(.motionMonitorEnd),
                    .task {
                        withAnimation {
                            .launch
                        }
                    }
                        .receive(on: DispatchQueue.main.animation(.spring()))
                        .eraseToEffect(),
                    .task {
                        withAnimation {
                            .rocketShaking
                        }
                    }
                        .delay(for: .seconds(0.25), scheduler: DispatchQueue.main.animation(Animation.default.repeatForever().speed(10)))
                        .eraseToEffect()
                )
            }
            return .none
        case .launch:
            state.launched = true
            return .none
        case .rocketShaking:
            state.rocketShaking = true
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
            GeometryReader { proxy in
                VStack {
                    Image(viewStore.image)
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: proxy.size.height / 2 + 50,
                            alignment: viewStore.launched ? .top : .bottom
                        )
                        .offset(x: viewStore.rocketShaking ? -5 : 0)
                    Text(viewStore.text)
                        .frame(maxWidth: 200)
                        .multilineTextAlignment(.center)
                }
                .navigationTitle("Launch")
                .onAppear {
                    viewStore.send(.motionMonitorStart)
                }
                .onDisappear {
                    viewStore.send(.motionMonitorEnd)
                }
            }
        }
    }
}

struct RocketSimulatorView_Previews: PreviewProvider {
    static var previews: some View {
        RocketSimulatorView(store: Store(initialState: RocketSimulator.State(), reducer: RocketSimulator()))
    }
}
