//
//  Movie.swift
//  AppleShowsFeed
//
//  Created by Oswaldo Maestra on 23/09/2025.
//

import Foundation

public enum FeedContentType: String, Decodable {
    case movie = "Movie"
}

public struct ImageItem: Decodable {
    public struct ImageAttributes: Decodable {
        public let height: Int?
        
        public init(height: Int) {
            self.height = height
        }
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let heightString = try container.decode(String.self, forKey: .height)
            self.height = Int(heightString)
        }
        
        private enum CodingKeys: String, CodingKey {
            case height
        }
    }
    
    public let url: URL
    public let attributes: ImageAttributes
    
    private enum CodingKeys: String, CodingKey {
        case url = "label"
        case attributes
    }
    
    public init(
        url: URL,
        attributes: ImageAttributes
    ) {
        self.url = url
        self.attributes = attributes
    }
}

public struct PriceWrapper: Decodable {
    public struct PriceAttributes: Decodable {
        let amount: String
        let currency: String
    }

    let label: String
    let attributes: PriceAttributes
}

public struct Price {
    public let label: String
    public let amount: Double
    public let currency: String
    
    public init(
        label: String,
        amount: Double,
        currency: String
    ) {
        self.label = label
        self.amount = amount
        self.currency = currency
    }
}

public struct IDWrapper: Decodable {
    struct IDAttributes: Decodable {
        let id: String
        
        private enum CodingKeys: String, CodingKey {
            case id = "im:id"
        }
    }
    
    let value: String
    
    enum CodingKeys: CodingKey {
        case attributes
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let attributes = try container.decode(IDAttributes.self, forKey: .attributes)
        self.value = attributes.id
    }
}

public struct CategoryWrapper: Decodable {
    struct CategoryAttributes: Decodable {
        let label: String
    }
    
    let attributes: CategoryAttributes
}

public struct ContentTypeWrapper: Decodable {
    struct ContentTypeAttributes: Decodable {
        let term: FeedContentType
    }
    
    let attributes: ContentTypeAttributes
}

public struct Movie: Equatable {
    public let id: String
    public let name: String
    public let summary: String?
    public let title: String
    public let releaseDate: Date
    public let rights: String?
    public let rentalPrice: Price?
    public let price: Price
    public let artist: String
    public let category: String
    public let contentType: FeedContentType
    public let images: [ImageItem]
    
    public init(
        id: String,
        name: String,
        summary: String?,
        title: String,
        releaseDate: Date,
        rights: String?,
        rentalPrice: Price?,
        price: Price,
        artist: String,
        category: String,
        contentType: FeedContentType,
        images: [ImageItem]
    ) {
        self.id = id
        self.name = name
        self.summary = summary
        self.title = title
        self.releaseDate = releaseDate
        self.rights = rights
        self.rentalPrice = rentalPrice
        self.price = price
        self.artist = artist
        self.category = category
        self.contentType = contentType
        self.images = images
    }
    
    public static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.id == rhs.id
    }
}

extension Movie: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case name = "im:name"
        case summary
        case title
        case releaseDate = "im:releaseDate"
        case rights
        case rentalPrice = "im:rentalPrice"
        case price = "im:price"
        case artist = "im:artist"
        case category
        case contentType = "im:contentType"
        case images = "im:image"
        
    }
    
    private enum LabelKeys: String, CodingKey {
        case label
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(IDWrapper.self, forKey: .id).value
        
        let nameContainer = try container.nestedContainer(keyedBy: LabelKeys.self, forKey: .name)
        self.name = try nameContainer.decode(String.self, forKey: .label)
        
        if let summaryContainer = try? container.nestedContainer(keyedBy: LabelKeys.self, forKey: .summary) {
            self.summary = try summaryContainer.decodeIfPresent(String.self, forKey: .label)
        } else {
            self.summary = nil
        }
        
        let titleContainer = try container.nestedContainer(keyedBy: LabelKeys.self, forKey: .title)
        self.title = try titleContainer.decode(String.self, forKey: .label)
        
        let releaseDateContainer = try container.nestedContainer(keyedBy: LabelKeys.self, forKey: .releaseDate)
        self.releaseDate = try releaseDateContainer.decode(Date.self, forKey: .label)
        
        let rightsContainer = try? container.nestedContainer(keyedBy: LabelKeys.self, forKey: .rights)
        self.rights = try rightsContainer?.decodeIfPresent(String.self, forKey: .label)
        
        let priceWrapper = try container.decode(PriceWrapper.self, forKey: .price)
        self.price = Price(label: priceWrapper.label, amount: Double(priceWrapper.attributes.amount) ?? 0.0, currency: priceWrapper.attributes.currency)
        
        self.rentalPrice = try container.decodeIfPresent(PriceWrapper.self, forKey: .rentalPrice)
            .map { wrapper in
                Price(
                    label: wrapper.label,
                    amount: Double(wrapper.attributes.amount) ?? 0.0,
                    currency: wrapper.attributes.currency
                )
            }
        
        let artistContainer = try container.nestedContainer(keyedBy: LabelKeys.self, forKey: .artist)
        self.artist = try artistContainer.decode(String.self, forKey: .label)
        
        let categoryWrapper = try container.decode(CategoryWrapper.self, forKey: .category)
        self.category = categoryWrapper.attributes.label
        
        let contentTypeWrapper = try container.decode(ContentTypeWrapper.self, forKey: .contentType)
        self.contentType = contentTypeWrapper.attributes.term
        
        self.images = try container.decode([ImageItem].self, forKey: .images)
    }
}
