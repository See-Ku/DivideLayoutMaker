//
//  ConfigMargin.swift
//  DivideLayoutMaker
//
//  Created by See.Ku on 2016/04/02.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit
import SK4Toolkit

class ConfigMargin: SK4ConfigMulti {

	static let marginArray: [String] = {
		let max = AppConst.marginMax / AppConst.interval
		return (0...max).map() { no in String(no * AppConst.interval) }
	}()

	init(title: String) {
		super.init(title: title, separater: ", ")
	}

	func setupMargin() {
		annotation = "Up, Right, Bottom, Left"

		addUnit(ConfigMargin.marginArray)
		addUnit(ConfigMargin.marginArray)
		addUnit(ConfigMargin.marginArray)
		addUnit(ConfigMargin.marginArray)
	}

	func setMargin(margin: [CGFloat]) {
		value = margin.map { no in Int(no) / AppConst.interval }
	}

	func getMargin() -> [CGFloat] {
		return value.map { no in CGFloat(no * AppConst.interval) }
	}

}

// eof
