//
//  LanguagePicker.swift
//  AppleShowsFeedApp
//
//  Created by Oswaldo Maestra on 26/09/2025.
//

import SwiftUI

struct LanguagePicker: View {
    @Binding var countryCode: String

    var body: some View {
        Picker("Language", selection: $countryCode) {
            Text("🇨🇦 Canada").tag("ca")
            Text("🇪🇸 Spain").tag("es")
        }
        .pickerStyle(.menu)
    }
}

#Preview {
    LanguagePicker(countryCode: .constant("es"))
}
