//
//  ViewController.swift
//  BitsoAPITestClient
//
//  Created by Angel Alberto Rueda Mejia on 2/22/21.
//

import UIKit
import BitsoPublicAPI

protocol CellDataProvider {
    var title: String { get }
}

class ADelegate: NSObject,UITableViewDelegate {
    
}

class BooksData: NSObject,UITableViewDataSource {
    typealias CELL_CONFIGURATOR = (UIListContentConfiguration, CellDataProvider) -> UIListContentConfiguration
    
    let cellIdentifier: String
    private var cellConfigurator: CELL_CONFIGURATOR?
    var cellDataProvider: CellDataProvider?
    var data: [Book] = []
    
    init(cellIdentifier: String = "aCell") {
        self.cellIdentifier = cellIdentifier
        super.init()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    func onCellForRow(cellConfigurator: @escaping CELL_CONFIGURATOR) {
        self.cellConfigurator = cellConfigurator
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        if let cellConfigurator = self.cellConfigurator,
           let cellDataProvider = self.cellDataProvider {
            
            cell.contentConfiguration = cellConfigurator(cell.defaultContentConfiguration(),
                                                         cellDataProvider)
        }

        return cell
    }

    func addBook(_ book: Book) {
        data.append(book)
    }
}

class ViewController: UIViewController {

    let bitso: BitsoAPI = .init()

    var firstBook: Book? {
        didSet {
            guard let firstBook = firstBook else { return }
            print("\nFIRST BOOK\n")
            print(firstBook)

            print("\nCALLING GET TICKER...")
            bitso.getTicker(book: firstBook.name) { result in

                switch result {
                case .success(let tickerResult):
                    print("\nTICKER RESULT\n")
                    if tickerResult.success {
                        print(tickerResult.payload)
                    }
                case.failure(let error):
                    print("Error \(error)")
                }

            }

            print("\nCALLING GET ORDER BOOK..")
            bitso.getOrderBook(book: firstBook.name) { result in
                switch result {
                case .success(let orderBookResult):
                    print("\nORDER BOOK RESULT\n")
                    if orderBookResult.success {
                        print(orderBookResult.payload)
                    }
                case .failure(let error):
                    print("Error \(error)")
                }
            }
        }
    }
    
    let tableView: UITableView = .init(frame: .zero)
    let aDataSource: BooksData = BooksData()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()

        bitso.getAvailableBooks() { result in

            switch result {
            case .success(let bookResult):
                
                if bookResult.success {
 
                    DispatchQueue.main.async {

                        for book in bookResult.payload {
                            self.tableView.beginUpdates()
                            let indexPath: IndexPath = .init(row: 0, section: 0)
                            self.tableView.insertRows(at: [indexPath], with: .fade)
                            self.aDataSource.addBook(book)
                            self.tableView.endUpdates()
                        }

                    }

                }
            case .failure(let error):
                print("Error \(error)")
            }
        }
    }
    
    func setup() {
        setupDataSource()
        setupTableView()
    }

}

extension ViewController {
    private func setupDataSource() {
        aDataSource.onCellForRow { contentConfiguration, cellDataProvider in
            var mutatedContentConfiguration = contentConfiguration
            mutatedContentConfiguration.text = cellDataProvider.title
            return mutatedContentConfiguration
        }
        
        aDataSource.cellDataProvider = {
            struct _CellDataProvider: CellDataProvider {
                var title: String { "HOLA MUNDO" }
            }
            
            return _CellDataProvider()
        }()
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "aCell")
        tableView.dataSource = aDataSource
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        let left: NSLayoutConstraint  = .init(item: tableView,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .leading,
                                              multiplier: 1,
                                              constant: 0)
        
        let right: NSLayoutConstraint  = .init(item: tableView,
                                               attribute: .trailing,
                                               relatedBy: .equal,
                                               toItem: view,
                                               attribute: .trailing,
                                               multiplier: 1,
                                               constant: 0)
        
        let top: NSLayoutConstraint  = .init(item: tableView,
                                             attribute: .top,
                                             relatedBy: .equal,
                                             toItem: view,
                                             attribute: .top,
                                             multiplier: 1,
                                             constant: 0)
        
        let bottom: NSLayoutConstraint  = .init(item: tableView,
                                                attribute: .bottom,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: .bottom,
                                                multiplier: 1,
                                                constant: 0)
        
        NSLayoutConstraint.activate([left, right, top, bottom])
        
    }
}

