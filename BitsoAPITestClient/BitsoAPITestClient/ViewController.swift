//
//  ViewController.swift
//  BitsoAPITestClient
//
//  Created by Angel Alberto Rueda Mejia on 2/22/21.
//

import UIKit
import BitsoPublicAPI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bitso: BitsoAPI = .init()
        
        bitso.getAvailableBooks() { result in
            
            switch result {
            case .success(let bookResult):
                if bookResult.success {
                    for book in bookResult.payload {
                        print("==========")
                        print(book)
                        print("==========\n")
                    }
                    
                }
            case .failure(let error):
                print("Error \(error)")
            }
            
        }
        
        // Do any additional setup after loading the view.
    }


}

