//
//  UnitConfigViewController.swift
//  DivideLayoutMaker
//
//  Created by See.Ku on 2016/04/02.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit
import SK4Toolkit

class UnitConfigViewController: SK4TableViewController {

	var aloneEdit = false

	func onDone(sender: AnyObject) {
		dismissViewControllerAnimated(true, completion: nil)
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		assert(g_admin.currentUnit != nil)

		if let unit = g_admin.currentUnit {
			let admin = UnitConfig(unit: unit)
			setup(configAdmin: admin)
		}

		if aloneEdit {
			navigationItem.rightBarButtonItem = sk4BarButtonItem(system: .Done, target: self, action: #selector(SK4ConfigViewController.onDone(_:)))
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// eof
