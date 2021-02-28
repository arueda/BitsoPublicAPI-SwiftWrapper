//
//  ViewController.swift
//  BitsoAPITestClient
//
//  Created by Angel Alberto Rueda Mejia on 2/22/21.
//

import UIKit
import BitsoPublicAPI

class ADelegate: NSObject, UITableViewDelegate {
    
    private var onDidSelect: ((IndexPath) -> Void)?
    var data: [Book]?
    
    func onDidSelect(handler: @escaping ((IndexPath) -> Void)) {
        self.onDidSelect = handler
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onDidSelect?(indexPath)
    }
}

class BooksDataSource: NSObject, UITableViewDataSource {
    
    typealias CELL_CONFIGURATOR = (UIListContentConfiguration,
                                   IndexPath,
                                   [Book]) -> UIListContentConfiguration
    
    let cellIdentifier: String
    
    private var cellConfigurator: CELL_CONFIGURATOR?
    private var data: [Book] = []
    
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
        
        if let cellConfigurator = self.cellConfigurator {
            cell.contentConfiguration = cellConfigurator(cell.defaultContentConfiguration(),
                                                         indexPath,
                                                         data)
        }

        return cell
    }

    func addBook(_ book: Book) {
        data.insert(book, at: 0)
    }
    
    func book(for indexPath: IndexPath) -> Book {
        data[indexPath.row]
    }
}

class ViewController: UIViewController {

    let bitso: BitsoAPI = .init()

    let tableView: UITableView = .init(frame: .zero)
    let booksData: BooksDataSource = BooksDataSource()
    let delegate: ADelegate = .init()

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
                            self.booksData.addBook(book)
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
        booksData.onCellForRow { contentConfiguration, indexPath, data in
            var mutatedContentConfiguration = contentConfiguration
            mutatedContentConfiguration.text = data[indexPath.row].name
            return mutatedContentConfiguration
        }
    }
    
    private func setupTableView() {
        
        delegate.onDidSelect { [weak self] indexPath in
            guard let book = self?.booksData.book(for: indexPath) else { return }
            
            self?.bitso.getTicker(book: book.name) { result in

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
            
        }
        
        tableView.delegate = delegate
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "aCell")
        tableView.dataSource = booksData
        
        
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

