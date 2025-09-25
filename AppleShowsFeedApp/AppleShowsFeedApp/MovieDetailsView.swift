//
//  MovieDetailsView.swift
//  AppleShowsFeedApp
//
//  Created by Oswaldo Maestra on 25/09/2025.
//

import SwiftUI
import AppleShowsFeed

struct MovieDetailsView: View {
    let viewModel: MovieDetailsViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                HStack(alignment: .top, spacing: 12) {
                    AsyncImage(url: viewModel.imageURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 120, height: 170)
                    .background(Color.secondary.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(viewModel.name)
                            .font(.title)
                        Text(viewModel.category)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        Text.init("**Released:** \(viewModel.releaseDate.formatted(date: .long, time: .omitted))")
                        if let artist = viewModel.artist {
                            Text.init("**By:** \(artist)")
                        }
                    }
                    
                    Spacer()
                }
                
                Grid(alignment: .center) {
                    GridRow {
                        Text("Buy")
                            .fontWeight(.semibold)
                        Text("Rent")
                            .fontWeight(.semibold)
                    }
                    Spacer()
                    GridRow {
                        Text(viewModel.price)
                            .padding(8)
                            .background(Color.accentColor)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        if let rentalPrice = viewModel.rentalPrice {
                            Text(rentalPrice)
                                .padding(8)
                                .background(Color.accentColor)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        } else {
                            Text("-")
                        }
                    }
                }
                
                if let summary = viewModel.summary {
                    VStack(alignment: .leading, spacing: 24) {
                        Text("Summary:")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text(summary)
                            .lineSpacing(4)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    MovieDetailsView(
        viewModel: MovieDetailsViewModel(
            imageURL: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Video221/v4/e2/30/a4/e230a45f-977d-87a3-719d-f476451b2289/tns.yplrzspf.jpg/113x170bb.png"),
            name: "Los 4 Fantásticos: Primeros pasos",
            category: "Action & Adventure",
            releaseDate: .now,
            artist: "Matt Shakman",
            price: "21.99$",
            rentalPrice: nil,
            summary: "Con un mundo retrofuturista inspirado en los años 60 como escenario, en \"Los 4 Fantásticos: Primeros pasos\", Marvel Studios presenta a la primera familia del universo Marvel: Reed Richards/Mister Fantástico, Sue Storm/la Mujer Invisible, Johnny Storm/la Antorcha Humana y Ben Grimm/La Cosa. Juntos se enfrentarán a un enorme desafío. Tendrán que defender la Tierra de Galactus, un voraz dios espacial, y su enigmático heraldo, Estela Plateada, mientras buscan el equilibrio entre su papel de héroes y sus estrechos vínculos familiares. Por si el plan de Galactus de devorar el planeta y a todos sus habitantes no fuera suficiente, de pronto la situación toma un cariz muy personal"
        )
    )
}
