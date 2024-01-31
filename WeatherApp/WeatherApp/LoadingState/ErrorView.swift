//
//  ErrorView.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 20.11.2023.
//

import SwiftUI

struct ErrorView: View {
    
    let state: ErrorState
    
    var body: some View {
        VStack {
            Image.errorImage
                .resizable()
                .frame(width: 100, height: 100)
            Text(state.errorMessage)
                .foregroundColor(.white)
                .padding()
            Button(action: state.retryAction) {
                Text(state.buttonMessage)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.8))
    }
}

#Preview {
    ErrorView(
        state: ErrorState(
            buttonMessage: "Try again",
            errorMessage: "Something went wrong",
            retryAction: {}
        )
    )
}
