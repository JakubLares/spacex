//
//  RocketsRepository.swift
//  SpaceX
//
//  Created by Jakub Lares on 21.03.2023.
//

import ComposableArchitecture
import Dependencies

extension DependencyValues {
    var rocketRepository: RocketRepository {
        get { self[RocketRepository.self] }
        set { self[RocketRepository.self] = newValue }
    }
}

struct RocketRepository: DependencyKey {

    let fetchRockets: () async throws -> [Rocket]

    static var liveValue: RocketRepository {
        return Self {
            try await APIClient().fetchRockets()
        }
    }

    static var previewValue: RocketRepository {
        return Self {
            [Rocket.mock, Rocket.mock, Rocket.mock]
        }
    }
}

