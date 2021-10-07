//
//  ViewController.swift
//  InvestPortfolio
//
//  Created by 19336088 on 02.10.2021.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    
    //MARK: variables
    
    var stockArray = [Stock]()
    
    let networkManager = NetworkManager()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: func
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStocks()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell", for: indexPath)
        let stock = stockArray[indexPath.row]
        let name = stock.name ?? ""
        cell.textLabel?.text = String(indexPath.row + 1) + "     " + name + "   " + String(format: "%.02f", stock.lastPrice)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let stockTicker = stockArray[indexPath.row].ticker ?? ""
        
        let refreshAlert = UIAlertController(title: "Deleting", message: "Are you shure, you want to delete \(stockTicker)?", preferredStyle: .alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction) in
            self.context.delete(self.stockArray[indexPath.row])
            self.stockArray.remove(at: indexPath.row)
            self.loadStocks()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        
        present(refreshAlert, animated: true, completion: nil)
        
    }
    
    //MARK: actions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Stock ticker", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Ticker", style: .default) { action in
            let newStock = Stock(context: self.context)
            if let ticker = textField.text {
           
                self.networkManager.fetchData(tcr: ticker) { price, name in
                    
                    newStock.ticker = ticker
                    newStock.lastPrice = price
                    newStock.name = name
                    newStock.value = 1
                    self.stockArray.append(newStock)
                    self.saveStocks()
                    
                }
                
                self.tableView.reloadData()
                
            }
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new ticker"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: SaveLoad
    
    func saveStocks() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
    }
    
    func loadStocks() {
        
        let request = Stock.fetchRequest()
        
        do {
            stockArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
}

