//
//  Location.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 20.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

struct Location {
    
    let id: Int
    let name: String
    let city: String
    let address: String
    let country: String
    let latitude: Double
    let longitude: Double
    
    init(id: Int, name: String, city: String, address: String, country: String, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.city = city
        self.address = address
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init() {
        self.init(id: 0, name: "Name", city: "City", address: "Address", country: "UA", latitude: 0, longitude: 0)
    }
    
    init(withResult resultDictionary: [String: Any]) {
        
        let id = resultDictionary["id"] as? Int ?? 0
        let name = resultDictionary["name"] as? String ?? "Location"
        let city = resultDictionary["city"] as? String ?? "City"
        let address = resultDictionary["address"] as? String ?? "Address"
        let country = resultDictionary["country"] as? String ?? "UA"
        let latitude = resultDictionary["latitude"] as? Double ?? Constants.Location.defaultLatitude
        let longitude = resultDictionary["longitude"] as? Double ?? Constants.Location.defaultLongitude
        
        self.init(id: id, name: name, city: city, address: address, country: country, latitude: latitude, longitude: longitude)
    }
    
    public func getNameAndCity() -> String {
        return name + ", " + city
    }
    
    public func getGoogleMapsLink() -> String {
        let baseLink = "http://maps.google.com/maps?&z=10"
        let coordinates = "\(latitude)+\(longitude)"
        var searchName: String {
            let nameParts = name.components(separatedBy: [" ", "-", ",", "."])
            return nameParts.joined(separator: "+")
        }
        let linkWithCoordAndName = "\(baseLink)&ll=\(coordinates)&q=\(searchName)"
        let escapedLink = linkWithCoordAndName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return escapedLink ?? "\(baseLink)&ll=\(coordinates)"
    }
    
    public func getGoogleMapsURL() -> URL? {
        return URL(string: getGoogleMapsLink())
    }
}
