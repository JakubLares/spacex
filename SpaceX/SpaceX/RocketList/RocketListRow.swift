//
//  RocketListRow.swift
//  SpaceX
//
//  Created by Jakub Lares on 17.03.2023.
//

import SwiftUI
import ComposableArchitecture

struct RocketListRow: View {

    let store: StoreOf<RocketDetail>

    var body: some View {

        WithViewStore(self.store) { viewStore in
            HStack(spacing: 18) {
                Image("Rocket")
                    .resizable()
                    .frame(width: 30, height: 30)
                VStack(alignment: .leading, spacing: 2) {
                    Text(viewStore.name)
                        .fontWeight(.bold)
                    Text("First flight: " + viewStore.firstFlight)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .frame(height: 44)
            .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
        }
    }
}

struct RocketListRow_Previews: PreviewProvider {
    static var previews: some View {
        RocketDetailView(store: Store(initialState: RocketDetail.State.mock, reducer: Reducer(RocketDetail()), environment: ()))
    }
}
