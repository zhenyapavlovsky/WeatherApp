//
//  DetailView.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 16.10.2023.
//


import SwiftUI
import SDWebImageSwiftUI

struct DetailView: View {
    
    @ObservedObject var viewModel: DetailViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.customGradient
                    .edgesIgnoringSafeArea(.all)
                if viewModel.loadingState {
                    DetailLoadingState()
                } else if let errorState = viewModel.errorState {
                    ErrorView(state: errorState)
                } else {
                    VStack(spacing: 30) {
                        topTitle
                        hourDetailsScroll
                        middleTitle
                        dayDetailsScroll
                        bottomTitle
                    }
                    .padding(.top, 30)
                    .createToolBarBack(text: "back".localized) {
                        viewModel.navigateBack()
                    }
                    .createToolbarSettings(dismissAction: {})
                }
            }
            .onAppear {
                viewModel.getForecastWeather()
            }
        }
    }
}

private extension DetailView {
    
    var topTitle: some View {
        HStack {
            Text("today".localized)
                .font(Font.custom("Overpass", size: 24).weight(.black))
            Spacer()
            Text(Date().dayMonth)
                .font(Font.custom("Overpass", size: 18))
        }
        .customShadow()
        .foregroundColor(.white)
        .padding([.leading, .trailing], 30)
    }
    
    var hourDetailsScroll: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 1) {
                    ForEach(viewModel.forecast?.first?.hourlyReports ?? [], id: \.time) { hour in
                        VStack(alignment: .center, spacing: 20) {
                            Text("\(hour.temperature)°C")
                                .font(Font.custom("Overpass", size: 18))
                                .foregroundColor(.white)
                            
                            if let fixedURL = hour.iconURL?.urlFixed {
                                WebImage(url: fixedURL)
                                    .resizable()
                                    .placeholder {
                                        Image(systemName: "cloud")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 43, height: 43)
                                            .foregroundColor(.white)
                                    }
                                    .indicator(.activity)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 43, height: 43)
                            } else {
                                Image(systemName: "cloud")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 43, height: 43)
                                    .foregroundColor(.white)
                            }
                            
                            Text(hour.time.hourFormatted())
                                .font(Font.custom("Overpass", size: 18))
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(hour.time.isCurrentHour() ? Color.white.opacity(0.2) : Color.clear)
                        .cornerRadius(hour.time.isCurrentHour() ? 20 : 0)
                        .id(hour.time)
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        if let currentHourTime = viewModel.forecast?.first?.hourlyReports.first(where: { $0.time.isCurrentHour() })?.time {
                            proxy.scrollTo(currentHourTime, anchor: .center)
                        }
                    }
                }
            }
        }
    }
    
    var middleTitle: some View {
        HStack {
            Text("next_forecast".localized)
                .font(Font.custom("Overpass", size: 24).weight(.black))
            Spacer()
            Image.calendar
        }
        .customShadow()
        .foregroundColor(.white)
        .padding([.leading, .trailing], 30)
    }
    
    var dayDetailsScroll: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                ForEach(viewModel.forecast ?? [], id: \.id) { day in
                    HStack(spacing: 90) {
                        Text(day.date.formattedDate())
                            .font(Font.custom("Overpass", size: 18))
                            .foregroundColor(.white)
                        
                        if let fixedURL = day.iconURL?.urlFixed  {
                            WebImage(url: fixedURL)
                                .resizable()
                                .placeholder {
                                    Image(systemName: "cloud")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 43, height: 43)
                                        .foregroundColor(.white)
                                }
                                .indicator(.activity)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 43, height: 43)
                        } else {
                            Image(systemName: "cloud")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 43, height: 43)
                                .foregroundColor(.white)
                        }
                        
                        Text("\(day.averageTemperature)°C")
                            .font(Font.custom("Overpass", size: 18))
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
    
    var bottomTitle: some View {
        HStack {
            Image.sun
            Text("accuWeather")
                .font(Font.custom("Overpass", size: 18))
        }
        .customShadow()
        .foregroundColor(.white)
    }
}


struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(viewModel: .init( locationManager: LocationManager()))
    }
}


