//
//  WeatherApp
//
//  Created by Albert Kristian on 10.10.2023.
//

import SwiftUI

@main
struct WeatherApp: App {
    
    let locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            HomeCoordinatorView(
                coordinator: .init(
                    homeViewModel: HomeViewModel(
                        locationManager: locationManager
                    )
                )
            )
        }
    }
}
