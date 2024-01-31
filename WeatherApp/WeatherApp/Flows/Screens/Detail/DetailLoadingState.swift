//
//  DetailLoadingState.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 02.11.2023.
//

import SwiftUI

struct DetailLoadingState: View {
        
    var body: some View {
        NavigationView {
            ZStack {
                Color.customGradient
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 30) {
                    topTitle
                    hourDetailsScroll
                    middleTitle
                    dayDetailsScroll
                    bottomTitle
                }
                .padding(.top, 30)
            }
            .createToolBarBack(text: "back".localized) {}
            .createToolbarSettings(dismissAction: {})
        }
    }
}

private extension DetailLoadingState {
    
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
        HStack(spacing: 15) {
            ForEach(0..<5) { _ in
                ShimmerView()
                    .frame(width: 55, height: 153)
                    .cornerRadius(20)
            }
        }
        .padding()
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
        VStack(spacing: 15) {
            ForEach(0..<5) { _ in
                ShimmerView()
                    .frame(width: 330, height: 50)
                    .cornerRadius(20)
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

#Preview {
    DetailLoadingState()
}
