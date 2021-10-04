//
//  NetworkManager.swift
//  InvestPortfolio
//
//  Created by 19336088 on 03.10.2021.
//

import Foundation

struct NetworkManager {
    
    func fetchData(tcr: String) {
        if let url = URL(string: "https://query1.finance.yahoo.com/v10/finance/quoteSummary/\(tcr)?modules=price") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error == nil {
                    let decoder = JSONDecoder()
                    if let safeData = data {
                        do {
                        let results = try decoder.decode(Results.self, from: safeData)
                            DispatchQueue.main.async {
                                self.stocks = results.result
                            }

                        } catch {
                            print(error)
                        }
                    }
                }
            }
            task.resume()
        }

    }
    func parseJSON() {
        
    }
}
