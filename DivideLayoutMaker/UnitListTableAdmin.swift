//
//  UnitListTableAdmin.swift
//  DivideLayoutMaker
//
//  Created by See.Ku on 2016/04/02.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit
import SK4Toolkit

class UnitListTableAdmin: UnitTableAdmin {

	func makeUnitList() {
		units.removeAll(keepCapacity: true)

		if let unit = g_admin.currentLayout?.layoutAdmin.currentMode {
			makeUnitList(unit, indent: 0)
		}
	}

	func makeUnitList(unit: SK4DivideLayoutUnit, indent: Int) {
		let detail = getDetail(unit)
		let ui = Unit(title: unit.unitKey, detail: detail, indent: indent, unit: unit)
		units.append(ui)

		if unit.isDivide() {
			for child in unit.children {
				makeUnitList(child, indent: indent+1)
			}
		}
	}

	// /////////////////////////////////////////////////////////////

	override func didSelectRow(indexPath: NSIndexPath) {
		super.didSelectRow(indexPath)

		g_admin.currentUnit = units[indexPath.row].unit
		parent.performSegueWithIdentifier("UnitConfig", sender: nil)
	}

}

// eof
