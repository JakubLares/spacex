//
//  MotionRepository.swift
//  SpaceX
//
//  Created by Jakub Lares on 22.03.2023.
//

import ComposableArchitecture
import Dependencies
import CoreMotion

extension DependencyValues {
    var motionRepository: MotionRepository {
        get { self[MotionRepository.self] }
        set { self[MotionRepository.self] = newValue }
    }
}

struct MotionRepository: DependencyKey {

    let rotationRateX: () async -> AsyncStream<Double>

    static var liveValue: MotionRepository {

        let motionManager = CMMotionManager()

        return Self {
            AsyncStream<Double> { continuation in
                motionManager.deviceMotionUpdateInterval = 1/60
                motionManager.startDeviceMotionUpdates(to: .main) { motionData, error in
                    guard error == nil else { return }

                    if let motionData = motionData {
                        print(motionData.rotationRate.x)
                        continuation.yield(motionData.rotationRate.x)
                    }
                }
                continuation.onTermination = { _ in motionManager.stopDeviceMotionUpdates() }
            }
        }
    }
}
