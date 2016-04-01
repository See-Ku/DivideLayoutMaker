//
//  UnitTableAdmin.swift
//  DivideLayoutMaker
//
//  Created by See.Ku on 2016/04/02.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit
import SK4Toolkit

class UnitTableAdmin: SK4TableViewAdmin {

	struct Unit {
		let title: String
		let detail: String
		let indent: Int
		let unit: SK4DivideLayoutUnit
	}

	var units = [Unit]()

	// /////////////////////////////////////////////////////////////

	func getDetail(unit: SK4DivideLayoutUnit) -> String {

		var ar = [String]()

		if unit.unitHidden {
			ar.append("hidden")
		}

		if unit.unitInitSize.isEmpty == false {
			let str = "unit size: \(getCGSize(unit.unitInitSize))"
			ar.append(str)
		}

		if unit.isDivide() {
			let str = "divide: \(unit.divideWidth) x \(unit.divideHeight)"
			ar.append(str)
		}

		if unit.viewMaxSize.isEmpty == false {
			let str = "view max: \(getCGSize(unit.viewMaxSize))"
			ar.append(str)
		}

		if unit.otherInfo.isEmpty == false {
			ar.append("other: \"\(unit.otherInfo)\"")
		}

		return ar.joinWithSeparator(" ")
	}

	func getCGSize(size: CGSize) -> String {
		let wx = getSizeString(size.width)
		let wy = getSizeString(size.height)
		return "\(wx)x\(wy)"
	}

	func getSizeString(size: CGFloat) -> String {
		if size == 0 {
			return "auto"
		} else {
			return String(Int(size))
		}
	}

	// /////////////////////////////////////////////////////////////

	func tableView(tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
		return units[indexPath.row].indent
	}

	override func numberOfRows(section: Int) -> Int {
		return units.count
	}

	override func cellForRow(cell: UITableViewCell, indexPath: NSIndexPath) {
		let unit = units[indexPath.row]
		cell.textLabel?.text = unit.title
		cell.detailTextLabel?.text = unit.detail

		let image: String
		if unit.unit.isSpace() {
			image = "space"
		} else if unit.unit.isDivide() {
			image = "divide"
		} else {
			image = "other"
		}
		cell.imageView?.image = UIImage(named: image)
	}
	
}

// eof
