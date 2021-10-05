//
//  StockData.swift
//  InvestPortfolio
//
//  Created by 19336088 on 05.10.2021.
//

import Foundation

struct Results: Decodable {
    let quoteSummary: QuoteSummary
}

struct QuoteSummary: Decodable {
    let result: [Result]

}

struct Result: Decodable {
    let price: Price
}

struct Price: Decodable {
    let regularMarketPrice: RegularMarketPrice
    let shortName: String
}

struct RegularMarketPrice: Decodable{
    let fmt: String
}
