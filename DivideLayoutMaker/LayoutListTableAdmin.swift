//
//  LayoutListTableAdmin.swift
//  DivideLayoutMaker
//
//  Created by See.Ku on 2016/04/02.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit
import SK4Toolkit

class LayoutListTableAdmin: SK4TableViewAdmin {

	struct LayoutInfo {
		let filename: String
		let detail: String
	}

	var layoutArray = [LayoutInfo]()
	var formatter = NSDateFormatter(dateStyle: .ShortStyle, timeStyle: .ShortStyle)

	override func viewWillAppear() {
		layoutArray.removeAll(keepCapacity: true)
		let path = sk4GetDocumentDirectory()

		do {
			let man = NSFileManager.defaultManager()
			let ar = try man.contentsOfDirectoryAtPath(path)

			for fn in ar {
				let full = path.nsString.stringByAppendingPathComponent(fn)
				let info = try man.attributesOfItemAtPath(full) as NSDictionary

				let md = info.fileModificationDate()
				let ms = formatter.sk4DateToString(md) ?? ""

				let detail = "Modified: \(ms)"
				let make = LayoutInfo(filename: fn, detail: detail)
				layoutArray.append(make)
			}
		} catch let error {
			sk4DebugLog("contentsOfDirectoryAtPath error \(path): \(error)")
		}

		tableView.reloadData()
	}

	// /////////////////////////////////////////////////////////////

	override func numberOfRows(section: Int) -> Int {
		return layoutArray.count
	}

	override func cellForRow(cell: UITableViewCell, indexPath: NSIndexPath) {
		cell.textLabel?.text = layoutArray[indexPath.row].filename
		cell.detailTextLabel?.text = layoutArray[indexPath.row].detail
	}

	override func didSelectRow(indexPath: NSIndexPath) {
		super.didSelectRow(indexPath)

		let filename = layoutArray[indexPath.row].filename
		g_admin.readLayout(filename)

		parent.performSegueWithIdentifier("LayoutEdit", sender: nil)
	}

	override func canEditRow(indexPath: NSIndexPath) -> Bool {
		return true
	}

	override func commitEditingDelete(indexPath: NSIndexPath) {
		let filename = layoutArray[indexPath.row].filename
		g_admin.deleteLayout(filename)

		layoutArray.removeAtIndex(indexPath.row)
		tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
	}

}

// eof
