//
//  HomeCoordinatorView.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 18.12.2023.
//

import SwiftUI
import SwiftUINavigation

struct HomeCoordinatorView: View {
    
    @ObservedObject var coordinator: HomeCoordinator
    
    var body: some View {
        NavigationView {
            ZStack {
                HomeView(viewModel: coordinator.homeViewModel)
                
                NavigationLink(
                    unwrapping: $coordinator.route,
                    case: /HomeCoordinator.Route.details,
                    destination: {(coordinator: Binding<DetailsCoordinator>) in
                        DetailsCoordinatorView(coordinator: coordinator.wrappedValue)
                            .navigationBarBackButtonHidden(true)
                    }
                )
                
                NavigationLink(
                    unwrapping: $coordinator.route,
                    case: /HomeCoordinator.Route.map,
                    destination: {(coordinator: Binding<MapCoordinator>) in
                        MapCoordinatorView(coordinator: coordinator.wrappedValue)
                            .navigationBarBackButtonHidden(true)
                    }
                )
            }
        }
    }
}
