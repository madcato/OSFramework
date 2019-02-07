//
//  ViewController.swift
//  Pru
//
//  Created by Daniel Vela Angulo on 31/10/2018.
//  Copyright © 2018 veladan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var waitButton: WaitButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func buttonTouched(_ sender: Any, forEvent event: UIEvent) {
        _ = 3
    }

    @IBAction func resetTapped(_ sender: Any) {
        waitButton.reset()
    }
}
