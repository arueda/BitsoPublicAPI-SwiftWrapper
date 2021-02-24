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
        
        bitso.getAvailableBooks()
        
        // Do any additional setup after loading the view.
    }


}

