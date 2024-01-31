//
//  Toolbar.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 16.10.2023.
//

import Foundation
import SwiftUI

extension View {
    
    func createToolBarBack(text: String, dismissAction: (() -> Void)?) -> some View {
        self.toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack(spacing: 0) {
                    Button(action: {
                        dismissAction?()
                    }, label: {
                        Image(systemName: "chevron.left")
                        Text(text)
                            .customShadow()
                            .font(.system(size: 24, weight: .semibold))
                    })
                    .foregroundColor(.white)
                }
            }
        })
    }
    
    func createToolbarSettings(dismissAction: (() -> Void)?) -> some View {
        self.toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    dismissAction?()
                }, label: {
                    Image.settingsButton
                })
                .customShadow()
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
            }
        })
    }
}
