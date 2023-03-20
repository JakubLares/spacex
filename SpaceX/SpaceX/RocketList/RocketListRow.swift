//
//  RocketListRow.swift
//  SpaceX
//
//  Created by Jakub Lares on 17.03.2023.
//

import SwiftUI

struct RocketListRow: View {
    var body: some View {
        HStack(spacing: 18) {
            Image("Rocket")
                .resizable()
                .frame(width: 30, height: 30)
            VStack(alignment: .leading) {
                Text("Falcon 1")
                    .fontWeight(.bold)
                Text("First flight: 24.3.2006")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .frame(height: 44)
        .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
    }
}

struct RocketListRow_Previews: PreviewProvider {
    static var previews: some View {
        RocketListRow()
    }
}
