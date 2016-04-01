//
//  UnitSortViewController.swift
//  DivideLayoutMaker
//
//  Created by See.Ku on 2016/04/03.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

class UnitSortViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!

	var tableAdmin: UnitSortTableAdmin!

    override func viewDidLoad() {
        super.viewDidLoad()

		tableAdmin = UnitSortTableAdmin(tableView: tableView, parent: self)
		tableAdmin.makeSortUnitList()
		tableAdmin.clearSeparator()

		tableView.setEditing(true, animated: false)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// eof
