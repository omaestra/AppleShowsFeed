//
//  LanguagePicker.swift
//  AppleShowsFeedApp
//
//  Created by Oswaldo Maestra on 26/09/2025.
//

import SwiftUI

struct LanguagePicker: View {
    @Binding var selectedStore: Storefront

    var body: some View {
        Picker("storefront.title", selection: $selectedStore) {
            ForEach(Storefront.allCases) { country in
                Text(country.displayName).tag(country)
            }
        }
        .pickerStyle(.menu)
    }
}

#Preview {
    LanguagePicker(selectedStore: .constant(.canada))
}
