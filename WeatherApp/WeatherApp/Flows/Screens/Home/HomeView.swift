//
//  HomeView.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 26.10.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor
                if viewModel.loadingState {
                    HomeLoadingView()
                } else if let errorState = viewModel.errorState {
                    ErrorView(state: errorState)
                } else {
                    VStack(alignment: .center) {
                        weatherImage
                        Spacer()
                        detail
                        Spacer()
                        bottomButton
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    toolBarLeading
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    toolBarTrailing
                }
            }
        }
        .blur(radius: viewModel.showingNotificationView ? 10 : 0)
        .onAppear {
            viewModel.getRealtimeWeather()
        }
        .sheet(isPresented: $viewModel.showingNotificationView) {
            NotificationView(viewModel: NotificationViewModel(dataProvider: NotificationsDataProviderImpl()))
                .presentationDetents([.height(380)])
        }
    }
}

private extension HomeView {
    
    var backgroundColor: some View {
        LinearGradient(
            gradient: Gradient(colors: [.linearGradientFirst, .linearGradientSecond]),
            startPoint: .top,
            endPoint: .bottom
        )
        .edgesIgnoringSafeArea(.all)
    }
    
    var weatherImage: some View {
        VStack {
            if let fixedURL = viewModel.weatherReport?.iconURL?.urlFixed {
                WebImage(url: fixedURL)
                    .resizable()
                    .placeholder {
                        ProgressView()
                    }
                    .indicator(.activity)
                    .frame(width: 200, height: 200)
                    .padding(.top)
            } else {
                ProgressView()
            }
        }
    }
    
    var bottomButton: some View {
        Button(action: {
            viewModel.selectDetails()
        }, label: {
            HStack {
                Text("forecast_report".localized)
                    .font(.system(size: 18, weight: .regular))
                    .padding()
                Image.upImage
            }
        })
        .foregroundColor(Color.buttonText)
        .padding(.horizontal, 20)
        .padding(.vertical, 5)
        .background(Color.white)
        .cornerRadius(20)
        .padding(.bottom, 5)
    }
    
    var toolBarLeading: some View {
        Button(action: {
            viewModel.selectMap()
        }, label: {
            HStack(spacing: 25) {
                Image.locationImage
                Text(viewModel.cityName)
                    .font(.system(size: 24))
                    .fontWeight(.semibold)
                Image.optImage
            }
        })
        .padding(.leading, 5)
        .foregroundColor(Color.white)
    }
    
    var toolBarTrailing: some View {
        Button(action: {
            viewModel.onNotificationBadgeClicked()
        }, label: {
            ZStack {
                Image.frameImage
                if viewModel.unreadCount > 0 {
                    Image.ellipseImage
                        .offset(x: 8, y: -5)
                }
            }
        })
        .padding(.horizontal, 5)
    }
    
    var detail: some View {
        VStack(alignment: .center) {
            Text("today".localized + ", \(Date().formattedDate)")
                .foregroundColor(Color.white)
                .font(Font.custom("Overpass", size: 18))
                .shadow(color: Color.black.opacity(0.10), radius: 1, x: -2, y: 3)
                .padding(.top, 10)
            
            HStack(alignment: .top) {
                Text("\(viewModel.weatherReport?.temperature ?? 0)")
                    .font(Font.custom("Overpass", size: 100))
                Text("°")
                    .font(Font.custom("Overpass", size: 70))
            }
            .padding(.leading, 25)
            .foregroundColor(Color.white)
            .shadow(color: Color.black, radius: 50, x: -4, y: 8)
            
            Text("cloudy".localized)
                .foregroundColor(.white)
                .font(Font.custom("Overpass", size: 24))
            
            VStack(alignment: .leading) {
                HStack(spacing: 5) {
                    Image.windyImage
                    Text("wind".localized)
                        .font(Font.custom("Overpass", size: 18))
                    Text("|")
                        .font(Font.custom("Raleway", size: 18).weight(.light))
                    Text("\(viewModel.weatherReport?.windSpeed ?? 0, specifier: "%.0f") km/h")
                        .font(Font.custom("Overpass", size: 18))
                }
                
                HStack(spacing: 7) {
                    Image.humImage
                    Text("hum".localized)
                        .font(Font.custom("Overpass", size: 18))
                    Text("|")
                        .font(Font.custom("Raleway", size: 18).weight(.light))
                    Text("\(viewModel.weatherReport?.humidity ?? 0, specifier: "%.0f") %")
                        .font(Font.custom("Overpass", size: 18))
                }
            }
            .shadow(color: Color.black.opacity(0.10), radius: 1, x: -2, y: 3)
            .foregroundColor(.white)
            .padding()
        }
        .padding(.horizontal, 80)
        .background(Color.detailBackground)
        .cornerRadius(20)
        
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.4), lineWidth: 2)
        )
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: .init( locationManager: LocationManager()))
    }
}
