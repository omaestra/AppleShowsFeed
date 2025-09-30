//
//  LanguagePicker.swift
//  AppleShowsFeedApp
//
//  Created by Oswaldo Maestra on 26/09/2025.
//

import SwiftUI

struct LanguagePicker: View {
    @Binding var selectedCountry: Storefront

    var body: some View {
        Picker("Country", selection: $selectedCountry) {
            ForEach(Storefront.allCases) { country in
                Text(country.displayName).tag(country)
            }
        }
        .pickerStyle(.menu)
    }
}

#Preview {
    LanguagePicker(selectedCountry: .constant(.canada))
}
