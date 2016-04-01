//
//  ConfigSize.swift
//  DivideLayoutMaker
//
//  Created by See.Ku on 2016/04/03.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit
import SK4Toolkit

class ConfigSize: SK4ConfigMulti {

	init(title: String) {
		super.init(title: title, separater: " ")
	}

	// /////////////////////////////////////////////////////////////

	static let sizeArray: [String] = {
		let max = AppConst.sizeMax / AppConst.interval
		return (0...max).map() { no in (no == 0) ? "auto" : String(no * AppConst.interval) }
	}()

	func setupSize() {
		annotation = "Width x Height"
		addUnit(ConfigSize.sizeArray)
		addUnit("x", width: 24)
		addUnit(ConfigSize.sizeArray)
	}

	func setSize(size: CGSize) {
		unitArray[0].selectIndex = Int(size.width) / AppConst.interval
		unitArray[2].selectIndex = Int(size.height) / AppConst.interval
	}

	func getSize() -> CGSize {
		let wx = unitArray[0].selectIndex * AppConst.interval
		let wy = unitArray[2].selectIndex * AppConst.interval
		return CGSize(width: wx, height: wy)
	}

	// /////////////////////////////////////////////////////////////

	static let divideArray: [String] = {
		return (1...AppConst.divideMax).map() { no in String(no) }
	}()

	func setupDivide() {
		annotation = "Width x Height"
		addUnit(ConfigSize.divideArray)
		addUnit("x", width: 24)
		addUnit(ConfigSize.divideArray)
	}

	var width: Int {
		get {
			return unitArray[0].selectIndex
		}

		set {
			unitArray[0].selectIndex = newValue
		}
	}
	
	var height: Int {
		get {
			return unitArray[2].selectIndex
		}

		set {
			unitArray[2].selectIndex = newValue
		}
	}

}

// eof