//
//  FoursquareModels.swift
//  RestaurantFinder
//
//  Created by Luu Tien Thanh on 7/6/16.
//  Copyright © 2016 Thanh Luu. All rights reserved.
//

import Foundation

struct Coordinate {
    let latitude: Double
    let longitude: Double
}

extension Coordinate: CustomStringConvertible {
    var description: String {
        return "\(latitude),\(longitude)"
    }
}

private struct ParameterKeys {
    static let clientID = "client_id"
    static let clientSecret = "client_secret"
    static let version = "v"
    static let category = "categoryId"
    static let location = "ll"
    static let query = "query"
    static let limit = "limit"
    static let searchRadius = "radius"
}

private struct DefaultValues {
    static let version = "20160301"
    static let limit = "50"
    static let searchRadius = "2000"
}

struct Location {
    let coordinate: Coordinate?
    let distance: Double?
    let countryCode: String?
    let country: String?
    let state: String?
    let city: String?
    let streetAddress: String?
    let crossStreet: String?
    let postalCode: String?
}

extension Location: JSONDecodable {
    init?(JSON: [String: AnyObject]) {
        if let lat = JSON["lat"] as? Double, lon = JSON["lng"] as? Double {
            coordinate = Coordinate(latitude: lat, longitude: lon)
        } else {
            coordinate = nil
        }

        distance = JSON["distance"] as? Double
        countryCode = JSON["cc"] as? String
        country = JSON["country"] as? String
        state = JSON["state"] as? String
        city = JSON["city"] as? String
        streetAddress = JSON["address"] as? String
        crossStreet = JSON["crossStreet"] as? String
        postalCode = JSON["postalCode"] as? String
    }
}

struct Venue {
    let id: String
    let name: String
    let location: Location?
    let categoryName: String
    let checkins: Int
}

extension Venue: JSONDecodable {
    init?(JSON: [String: AnyObject]) {
        guard let id = JSON["id"] as? String, name = JSON["name"] as? String else {
            return nil
        }
        
        guard let categories = JSON["categories"] as? [[String: AnyObject]], let category = categories.first, let categoryName = category["shortName"] as? String else {
            return nil
        }
        
        guard let stats = JSON["stats"] as? [String: AnyObject], let checkinsCount = stats["checkinsCount"] as? Int else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.categoryName = categoryName
        self.checkins = checkinsCount
        
        if let locationDict = JSON["location"] as? [String: AnyObject] {
            self.location = Location(JSON: locationDict)
        } else {
            self.location = nil
        }
    }
}