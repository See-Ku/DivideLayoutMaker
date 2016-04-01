//
//  UnitSortTableAdmin.swift
//  DivideLayoutMaker
//
//  Created by See.Ku on 2016/04/03.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit
import SK4Toolkit

class UnitSortTableAdmin: UnitTableAdmin {

	func makeSortUnitList() {
		if let unit = g_admin.currentUnit {
			for unit in unit.children {
				makeSortUnitList(unit)
			}
		}
	}

	func makeSortUnitList(unit: SK4DivideLayoutUnit) {
		let detail = getDetail(unit)
		let ui = Unit(title: unit.unitKey, detail: detail, indent: 0, unit: unit)
		units.append(ui)
	}

	// /////////////////////////////////////////////////////////////

	override func canEditRow(indexPath: NSIndexPath) -> Bool {
		return true
	}

	override func canMoveRow(indexPath: NSIndexPath) -> Bool {
		return true
	}

	override func moveRow(src: NSIndexPath, dst: NSIndexPath) {
		if let unit = g_admin.currentUnit {
			let tmp0 = units[src.row]
			let tmp1 = unit.children[src.row]

			units.removeAtIndex(src.row)
			unit.children.removeAtIndex(src.row)

			units.insert(tmp0, atIndex: dst.row)
			unit.children.insert(tmp1, atIndex: dst.row)
		}

		g_admin.unitUpdate()
	}

	// /////////////////////////////////////////////////////////////

	func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
		return .None
	}

}

// eof
