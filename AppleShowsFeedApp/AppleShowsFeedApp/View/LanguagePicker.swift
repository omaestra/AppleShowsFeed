//
//  LanguagePicker.swift
//  AppleShowsFeedApp
//
//  Created by Oswaldo Maestra on 26/09/2025.
//

import SwiftUI

struct LanguagePicker: View {
    @Binding var selectedCountry: Country

    var body: some View {
        Picker("Country", selection: $selectedCountry) {
            ForEach(Country.allCases) { country in
                Text(country.displayName).tag(country)
            }
        }
        .pickerStyle(.menu)
    }
}

#Preview {
    LanguagePicker(selectedCountry: .constant(.canada))
}
