//
//  FileConfig.swift
//  DivideLayoutMaker
//
//  Created by See.Ku on 2016/04/02.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit
import SK4Toolkit

class FileConfig: SK4ConfigAdmin {

	let check = SK4LeakCheck(name: "FileConfig")

	var layoutFile: LayoutFile!

	init(layoutFile: LayoutFile) {
		super.init(title: "File info")
		self.layoutFile = layoutFile
		setup()
	}

	// /////////////////////////////////////////////////////////////

	let filename = SK4ConfigString(title: "Filename", value: "", maxLength: 32)
	let margin = ConfigMargin(title: "View Margin")
	var renameError = false

	override func onSetup() {
		let sec1 = addUserSection("")
		sec1.addConfig(filename)

		let sec2 = addUserSection("")
		sec2.addConfig(margin)
		margin.setupMargin()
	}

	override func onLoad() {
		filename.value = layoutFile.filename
		margin.setMargin(layoutFile.editViewMargin.insets)
	}

	override func onSave() {
		layoutFile.editViewMargin.insets = margin.getMargin()
		if layoutFile.filename != filename.value {
			renameError = layoutFile.renameFilename(filename.value)
		}
	}

}

// eof
