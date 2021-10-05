//
//  NetworkManager.swift
//  InvestPortfolio
//
//  Created by 19336088 on 03.10.2021.
//

import UIKit

struct NetworkManager {
    
    func fetchData(tcr: String) {
        if let url = URL(string: "https://query1.finance.yahoo.com/v10/finance/quoteSummary/\(tcr)?modules=price") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error == nil {
                    if let safeData = data {
                        let decoder = JSONDecoder()
                        do {
                            let decodedData = try decoder.decode(Results.self, from: safeData)
                            
                            let price = Double(decodedData.quoteSummary.result[0].price.regularMarketPrice.fmt) ?? 0
                            
                            let name = decodedData.quoteSummary.result[0].price.shortName
                            
                            print(name, price)
                            
                        } catch {
                            print(error)
                        }
                        
                    }
                }
            }
            task.resume()
        }
        
    }
    
    
}
