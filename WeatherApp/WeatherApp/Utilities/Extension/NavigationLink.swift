//
//  NavigationLink.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 18.12.2023.
//

import SwiftUINavigation
import SwiftUI

extension NavigationLink {
    
    init<Enum, Case, WrappedDestination> (
        unwrapping enum: Binding<Enum?>,
        case casePath: CasePath<Enum, Case>,
        @ViewBuilder destination: @escaping (Binding<Case>) -> WrappedDestination
    ) where Destination == WrappedDestination?, Label == EmptyView {
        self.init(
            unwrapping: `enum`.case(casePath),
            destination: destination,
            onNavigate: { _ in },
            label: {}
        )
    }
}
