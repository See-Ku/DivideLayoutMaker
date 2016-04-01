//
//  LayoutListViewController.swift
//  DivideLayoutMaker
//
//  Created by See.Ku on 2016/04/02.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit
import SK4Toolkit

class LayoutListViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!

	func onAddItem(sender: AnyObject) {
		let alert = SK4ActionSheet(item: sender)

		alert.addDefault("Free Layout") { aa in
			g_admin.newLayout(.Free)
			self.performSegueWithIdentifier("LayoutEdit", sender: nil)
		}

		alert.addDefault("Status Bar Layout") { aa in
			g_admin.newLayout(.StatusBar)
			self.performSegueWithIdentifier("LayoutEdit", sender: nil)
		}

		alert.addDefault("Navigation Bar Layout") { aa in
			g_admin.newLayout(.NavigationBar)
			self.performSegueWithIdentifier("LayoutEdit", sender: nil)
		}

		alert.addCancel("Cancel")

		alert.presentAlertController(self)
	}

	var tableAdmin: LayoutListTableAdmin!

    override func viewDidLoad() {
        super.viewDidLoad()

		tableAdmin = LayoutListTableAdmin(tableView: tableView, parent: self)
		navigationItem.leftBarButtonItem = editButtonItem()

		let add = sk4BarButtonItem(system: .Add, target: self, action: #selector(LayoutListViewController.onAddItem(_:)))
		navigationItem.rightBarButtonItem = add
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		tableAdmin.viewWillAppear()
	}

	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)

		tableAdmin.viewWillDisappear()
	}

	override func setEditing(editing: Bool, animated: Bool) {
		super.setEditing(editing, animated: animated)

		tableView.setEditing(editing, animated: animated)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// eof
