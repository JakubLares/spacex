//
//  Rocket.swift
//  SpaceX
//
//  Created by Jakub Lares on 20.03.2023.
//

typealias Rockets = [Rocket]

struct Rocket: Codable, Hashable, Equatable, Identifiable {
    let id: String
    let name: String
    let description: String
    let firstFlight: String
    let images: [String]
    let height: Dimension
    let diameter: Dimension
    let mass: Mass
    let firstStage: Stage
    let secondStage: Stage

    enum CodingKeys: String, CodingKey {
        case height, diameter, mass
        case firstStage = "first_stage"
        case secondStage = "second_stage"
        case images = "flickr_images"
        case name
        case firstFlight = "first_flight"
        case description, id
    }

    static let mock = Rocket(
        id: "0",
        name: "Falcon 9",
        description: "Falcon 9 is a two-stage rocket designed and manufactured by Space for the reliable and safe transport of satellites and the Dragon spacecraft into orbit.",
        firstFlight: "1.1.2023",
        images: ["https://farm5.staticflickr.com/4599/38583829295_581f34dd84_b.jpg", "https://farm5.staticflickr.com/4645/38583830575_3f0f7215e6_b.jpg", "https://farm5.staticflickr.com/4696/40126460511_b15bf84c85_b.jpg"],
        height: Dimension(meters: 90, feet: nil),
        diameter: Dimension(meters: 40, feet: nil),
        mass: Mass(kg: 500_000, lb: 0),
        firstStage: Stage(reusable: true, engines: 1, fuelAmountTons: 20.0, burnTimeSEC: 1000),
        secondStage: Stage(reusable: false, engines: 4, fuelAmountTons: 20.1, burnTimeSEC: 1000)
    )
}

struct Dimension: Codable, Hashable {
    let meters, feet: Double?
}

struct Stage: Codable, Hashable {
    let reusable: Bool
    let engines: Int
    let fuelAmountTons: Double
    let burnTimeSEC: Int?

    enum CodingKeys: String, CodingKey {
        case reusable, engines
        case fuelAmountTons = "fuel_amount_tons"
        case burnTimeSEC = "burn_time_sec"
    }
}

struct Mass: Codable, Hashable {
    let kg, lb: Int
}
