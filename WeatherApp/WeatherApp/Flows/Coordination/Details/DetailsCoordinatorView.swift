//
//  DetailsCoordinatorView.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 18.12.2023.
//

import SwiftUI
import SwiftUINavigation

struct DetailsCoordinatorView: View {
    
    @ObservedObject var coordinator: DetailsCoordinator
    
    var body: some View {
        NavigationView {
            ZStack {
               DetailView(viewModel: coordinator.detailsViewModel)
            }
        }
    }
}
