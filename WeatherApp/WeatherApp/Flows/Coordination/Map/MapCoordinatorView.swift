//
//  MapCoordinatorView.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 18.12.2023.
//

import SwiftUI
import SwiftUINavigation

struct MapCoordinatorView: View {
    
    @ObservedObject var coordinator: MapCoordinator
    
    var body: some View {
        NavigationView {
            ZStack {
                MapView(viewModel: coordinator.mapViewModel)
            }
        }
    }
}
