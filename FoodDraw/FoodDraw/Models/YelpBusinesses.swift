//
//  YelpBusiness.swift
//  YelpBusiness
//
//  Created by Hao Qin on 7/17/21.
//

import Foundation

struct YelpBusinesses: Codable {
  let businesses: [YelpBusiness]
}

struct YelpBusiness: Codable {
  let image_url: String
}
