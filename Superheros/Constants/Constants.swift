//
//  Constants.swift
//  Superheros
//
//  Created by Mbusi Hlatshwayo on 7/28/21.
//

import Foundation

struct Constants
{
    static let kTimeoutInterval: Double = 15
    static let kCharactersUserDefaults: String = "characters"
    static let kPlaceholderImage: String = "marvel-icon-cinema-and-tv-icon"
    static let kMediumImageSize: String = "portrait_medium"
    static let kLargeImageSize: String =  "portrait_xlarge"
    static let kHeroCollectionViewCellNibName: String = "HeroCollectionViewCell"
    static let kHeroCellReuseId: String = "heroCell"
    static let kContentTypeHeader: String = "Content-Type"
    static let kDefaultContentType: String = "application/x-www-form-urlencoded; charset=utf-8"
    static let kJSONContentType: String = "application/json"
    static let kMarvelPublicAPIKey: String = "dd486762c5a13d571f6e000cf8c07ad3"
    static let kMarvelPrivateAPIKey: String = "3b2cbab7a04597b734003ffec3846b87c444e934"
    static let kMarvelDefaultBaseURL: String = "https://gateway.marvel.com/v1/public/"
}
