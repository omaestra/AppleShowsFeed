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
            ForEach(Storefront.allCases) { store in
                Text(store.displayName).tag(store)
            }
        }
        .pickerStyle(.menu)
    }
}

#Preview {
    LanguagePicker(selectedStore: .constant(.canada))
}
