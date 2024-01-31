//
//  HomeLoadingState.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 02.11.2023.
//

import SwiftUI

struct HomeLoadingView: View {
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor
                VStack(alignment: .center) {
                    weatherImage
                    Spacer()
                    detail
                    Spacer()
                    bottomButton
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
    }
}

private extension HomeLoadingView {
    
    var backgroundColor: some View {
        LinearGradient(
            gradient: Gradient(colors: [.linearGradientFirst, .linearGradientSecond]),
            startPoint: .top,
            endPoint: .bottom
        )
        .edgesIgnoringSafeArea(.all)
    }
    
    var toolBarLeading: some View {
        ShimmerView()
            .frame(width: 300, height: 25)
            .cornerRadius(15)
            .padding(.leading, 5)
    }
    
    var weatherImage: some View {
        ShimmerView()
            .cornerRadius(15)
            .frame(width: 200, height: 200)
            .padding(.top)
    }
    
    var toolBarTrailing: some View {
        Button(action: {}, label: {
            ZStack {
                Image.frameImage
                Image.ellipseImage
                    .offset(x: 8, y: -5)
            }
        })
        .padding(.horizontal, 5)
    }
    
    var detail: some View {
        ShimmerView()
            .frame(width: 327, height: 310)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.4), lineWidth: 2)
            )
    }
    
    var bottomButton: some View {
        Button(action: {}, label: {
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
}

#Preview {
    HomeLoadingView()
}
