//
//  ViewController.swift
//  BitsoAPITestClient
//
//  Created by Angel Alberto Rueda Mejia on 2/22/21.
//

import UIKit
import BitsoPublicAPI

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

    override func viewDidLoad() {
        super.viewDidLoad()

        print("\nGET AVAILABLE BOOKS:")
        bitso.getAvailableBooks() { result in

            switch result {
            case .success(let bookResult):
                if bookResult.success {
                    self.firstBook = bookResult.payload[0]
                }
            case .failure(let error):
                print("Error \(error)")
            }
        }
        // Do any additional setup after loading the view.
    }


}

