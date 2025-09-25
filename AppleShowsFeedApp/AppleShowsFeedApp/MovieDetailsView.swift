//
//  MovieDetailsView.swift
//  AppleShowsFeedApp
//
//  Created by Oswaldo Maestra on 25/09/2025.
//

import SwiftUI
import AppleShowsFeed

struct MovieDetailsView: View {
    let movie: Movie
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                HStack(alignment: .top, spacing: 12) {
                    AsyncImage(url: movie.images.first?.url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 120, height: 170)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(movie.name)
                            .font(.title)
                        Text(movie.category)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        Text.init("**Released:** \(movie.releaseDate.formatted(date: .long, time: .omitted))")
                        Text.init("**By:** \(movie.artist)")
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
                        Text(movie.price.label)
                            .padding(8)
                            .background(Color.accentColor)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        if let rentalPrice = movie.rentalPrice {
                            Text(movie.rentalPrice?.label ?? "-")
                                .padding(8)
                                .background(Color.accentColor)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        } else {
                            Text("-")
                        }
                    }
                }
                
                if let summary = movie.summary {
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
        movie: Movie(
            id: "1",
            name: "Los 4 Fantásticos: Primeros pasos",
            summary: "Con un mundo retrofuturista inspirado en los años 60 como escenario, en \"Los 4 Fantásticos: Primeros pasos\", Marvel Studios presenta a la primera familia del universo Marvel: Reed Richards/Mister Fantástico, Sue Storm/la Mujer Invisible, Johnny Storm/la Antorcha Humana y Ben Grimm/La Cosa. Juntos se enfrentarán a un enorme desafío. Tendrán que defender la Tierra de Galactus, un voraz dios espacial, y su enigmático heraldo, Estela Plateada, mientras buscan el equilibrio entre su papel de héroes y sus estrechos vínculos familiares. Por si el plan de Galactus de devorar el planeta y a todos sus habitantes no fuera suficiente, de pronto la situación toma un cariz muy personal",
            title: "Los 4 Fantásticos: Primeros pasos - Matt Shakman",
            releaseDate: .distantPast,
            rights: "© 2025 20th Century Studios & ™ 2025 MARVEL",
            rentalPrice: nil,
            price: Price(
                label: "21.99$",
                amount: 21.99,
                currency: "USD"
            ),
            artist: "Matt Shakman",
            category: "Action & Adventure",
            contentType: .movie,
            duration: 12345,
            images: [
                ImageItem(
                    url: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Video221/v4/e2/30/a4/e230a45f-977d-87a3-719d-f476451b2289/tns.yplrzspf.jpg/113x170bb.png")!,
                    attributes: .init(height: 60)
                )
            ]
        )
    )
}
