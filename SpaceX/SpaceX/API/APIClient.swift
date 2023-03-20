//
//  APIClient.swift
//  SpaceX
//
//  Created by Jakub Lares on 20.03.2023.
//

import Foundation

class APIClient {

    func fetchRockets() async throws -> Rockets? {
        guard let url = URL(string: "https://api.spacexdata.com/v4/rockets") else { return nil }

        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Rockets.self, from: data)
    }

}
