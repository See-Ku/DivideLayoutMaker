//
//  UnitListViewController.swift
//  DivideLayoutMaker
//
//  Created by See.Ku on 2016/04/02.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit
import SK4Toolkit

class UnitListViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!

	@IBAction func onDone(sender: AnyObject) {
		dismissViewControllerAnimated(true, completion: nil)
	}

	var tableAdmin: UnitListTableAdmin!

    override func viewDidLoad() {
        super.viewDidLoad()

		tableAdmin = UnitListTableAdmin(tableView: tableView, parent: self)
		tableAdmin.makeUnitList()

		AppEvent.UpdateUnit.recieveNotify(self) { [weak self] in
			self?.tableAdmin.makeUnitList()
			self?.tableView.reloadData()
		}

		navigationItem.backBarButtonItem = sk4BarButtonItem(title: "Back")
    }

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		tableAdmin.viewWillAppear()
	}

	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)

		tableAdmin.viewWillDisappear()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// eof
