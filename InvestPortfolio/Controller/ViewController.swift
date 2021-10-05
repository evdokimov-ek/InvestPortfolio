//
//  ViewController.swift
//  InvestPortfolio
//
//  Created by 19336088 on 02.10.2021.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    
    var stockArray = [Stock]()
    
    let networkManager = NetworkManager()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

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
        cell.textLabel?.text = stock.name! + "   " + String(format: "%.02f", stock.lastPrice)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let stockTicker = stockArray[indexPath.row].ticker ?? ""
        
        networkManager.fetchData(tcr: stockTicker)
        
        let refreshAlert = UIAlertController(title: "Deleting", message: "Are you shure, you want to delete \(stockTicker)?", preferredStyle: .alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction) in
            self.context.delete(self.stockArray[indexPath.row])
            self.stockArray.remove(at: indexPath.row)
            self.loadStocks()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        
        present(refreshAlert, animated: true, completion: nil)
        
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Stock ticker", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Ticker", style: .default) { action in
            let newStock = Stock(context: self.context)
            if let ticker = textField.text {
                newStock.ticker = ticker
                newStock.name = ticker
                newStock.value = 1
                newStock.lastPrice = 12.21
                self.stockArray.append(newStock)
                self.saveStocks()
            }
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new ticker"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveStocks() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
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

