//
//  MapScreen.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 06.11.2023.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @ObservedObject var viewModel: MapViewModel
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.selectedLocation.map { [$0] } ?? []) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    VStack {
                        Image.mapImage
                            .resizable()
                            .foregroundColor(.red)
                            .frame(width: 44, height: 44)
                        Text(location.name)
                    }
                }
            }
            .ignoresSafeArea()
            mappin
            saveButton
            rectangleInfo
        }
    }
}

private extension MapView {
    
    var mappin: some View {
        Image(systemName: "mappin")
            .foregroundColor(.red)
            .font(.title)
    }
    
    var rectangleInfo: some View {
        VStack {
            VStack(alignment: .leading, spacing: 30) {
                searchButton
                Text("recent_search".localized)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Color.buttonText)
                ForEach(viewModel.searchLocations, id: \.id) { cityReport in
                    Text(cityReport.name)
                        .foregroundColor(.black)
                        .onTapGesture {
                            viewModel.selectCity(cityReport)
                        }
                        .padding(.vertical, 5)
                }
            }
            .padding([.trailing, .leading], 35)
            .background {
                Rectangle()
                    .fill(Color.white)
                    .cornerRadius(30)
                    .edgesIgnoringSafeArea(.top)
                    .padding(.bottom, -30)
            }
            Spacer()
        }
    }
    
    var searchButton: some View {
        HStack {
            Button {
                viewModel.navigateBack()
            } label: {
                Image.backButton
                    .foregroundColor(.buttonText)
                    .padding(.leading, 10)
            }
            TextField("Search City", text: $viewModel.searchText)
                .onChange(of: viewModel.searchText) { newValue in
                    viewModel.getSearchCity(forCity: newValue)
                }
                .padding(17)
            Button {} label: {
                Image.mic
                    .foregroundColor(.buttonText)
                    .padding(.trailing, 20)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 3, x: -3, y: 5)
        )
    }
    
    func resultSearch(location: String) -> some View {
        HStack {
            Button(action: {}, label: {
                HStack {
                    Image.clock
                    Text(location)
                }
            })
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(Color.buttonText)
        }
    }
    
    var saveButton: some View {
        VStack {
            HStack {
                Button(action: {
                    let center = viewModel.mapRegion.center
                    viewModel.reverseGeocodeLocation(latitude: center.latitude, longitude: center.longitude)
                    viewModel.showHomeView = true
                }, label: {
                    Image(systemName: "plus")
                })
                .padding()
                .background(Color.black.opacity(0.7))
                .foregroundColor(.white)
                .font(.title)
                .clipShape(Circle())
                .padding(.trailing)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
    }
}


#Preview {
    MapView(viewModel: .init( locationManager: LocationManager()))
}

