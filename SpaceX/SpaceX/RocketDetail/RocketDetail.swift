//
//  RocketDetail.swift
//  SpaceX
//
//  Created by Jakub Lares on 17.03.2023.
//

import SwiftUI

struct RocketDetail: View {

    let rocket: Rocket

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                RocketDetailOverview(text: rocket.description)
                RocketDetailParameters(height: rocket.height.meters ?? 0, diameter: rocket.diameter.meters ?? 0, mass: rocket.mass.kg)
                RocketDetailStageView(stage: StageViewModel(title: "First Stage", stage: rocket.firstStage))
                RocketDetailStageView(stage: StageViewModel(title: "Second Stage", stage: rocket.secondStage))
                RocketDetailImagesView(images: rocket.images)
            }
            .padding()
            .navigationTitle(rocket.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct RocketDetailOverview: View {

    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Overview")
                .fontWeight(.bold)
            Text(text)
        }
    }
}

struct RocketDetailParameters: View {
    let height: Double
    let diameter: Double
    let mass: Int

    var body: some View {
        Text("Parameters")
            .fontWeight(.bold)
        HStack(alignment: .top, spacing: 24) {
            ParameterRectangle(title: formatMeters(number: height), subtitle: "height")
            ParameterRectangle(title: formatMeters(number: diameter), subtitle: "diameter")
            ParameterRectangle(title: "\(mass / 1000)t", subtitle: "mass")
        }
    }

    private static var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        return formatter
    }()

    private func formatMeters(number: Double) -> String {
        return "\(Self.formatter.string(from: number as NSNumber) ?? "0")m"
    }
}

struct ParameterRectangle: View {
    let title: String
    let subtitle: String

    var body: some View {
        Rectangle()
            .frame(width: squareSize, height: squareSize)
            .foregroundColor(.darkPink)
            .cornerRadius(15)
            .overlay {
                VStack(spacing: 8) {
                    Text(title)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
    }

    private var squareSize: CGFloat {
        return (UIScreen.main.bounds.width - 80) / 3
    }
}

struct RocketDetailStageView: View {
    let stage: StageViewModel
    var body: some View {
        VStack(alignment: .leading) {
            Text(stage.title)
                .fontWeight(.bold)
            Label(stage.reusable, image: "Reusable")
            Label(stage.engines, image: "Engine")
            Label(stage.fuel, image: "Fuel")
            Label(stage.burn, image: "Burn")
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            Rectangle()
                .foregroundColor(.whiteSmoke)
                .cornerRadius(16)
        }
    }
}

struct StageViewModel {
    let title: String
    let reusable: String
    let engines: String
    let fuel: String
    let burn: String

    init(title: String, stage: Stage) {
        self.title = title
        reusable = stage.reusable ? "reusable" : "not reusable"
        engines = "\(stage.engines) \(stage.engines > 1 ? "engines" : "engine")"
        fuel = "\(Self.formatter.string(from: stage.fuelAmountTons as NSNumber) ?? "0") tons of fuel"
        burn = "\(stage.burnTimeSEC ?? 0) seconds burn time"
    }

    private static var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}

struct RocketDetailImagesView: View {
    let images: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Photos")
                .fontWeight(.bold)
            ForEach(images, id: \.self) { imageUrl in
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image.image?
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(16)
                }
            }
        }
    }
}

struct RocketDetail_Previews: PreviewProvider {
    static var previews: some View {
        RocketDetail(rocket: Rocket.mock)
    }
}
