//
//  UnitConfig.swift
//  DivideLayoutMaker
//
//  Created by See.Ku on 2016/04/02.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit
import SK4Toolkit

class UnitConfig: SK4ConfigAdmin {

	let check = SK4LeakCheck(name: "UnitConfig")

	var unit: SK4DivideLayoutUnit!

	init(unit: SK4DivideLayoutUnit) {
		self.unit = unit
		super.init(title: "Unit Info")

		self.cancellation = false
		setup()
	}

	// /////////////////////////////////////////////////////////////

	let typeIndex = SK4ConfigIndex(title: "Type", value: 1)
	let typeName = SK4ConfigString(title: "Unit Name", value: "", maxLength: 16)
	let initSize = ConfigSize(title: "Unit Size")
	let unitHide = SK4ConfigBool(title: "Unit Hide", value: false)

	let divide = ConfigSize(title: "Divide Count")
	let sortChildren = SK4ConfigAction(title: "Sort Children")
	let viewMaxSize = ConfigSize(title: "View Max Size")
	let margin = ConfigMargin(title: "View Margin")

	let otherInfo = SK4ConfigString(title: "Other Info", value: "", maxLength: 32)

	override func onSetup() {

		// 先にコンフィグを全て準備
		typeIndex.cell = SK4ConfigCellSegmented()
		typeIndex.choices = [
			SK4DivideLayoutUnit.TypeName.space,
			SK4DivideLayoutUnit.TypeName.divide,
			"other"
		]

		initSize.setupSize()
		divide.setupDivide()
		sortChildren.segueId = "SortUnit"
		viewMaxSize.setupSize()
		margin.setupMargin()
	}

	override func onLoad() {

		// ユニットの情報をロード
		if unit.isSpace() {
			typeIndex.value = 0
		} else if unit.isDivide() {
			typeIndex.value = 1
		} else {
			typeIndex.value = 2
		}

		typeName.value = unit.unitType
		initSize.setSize(unit.unitInitSize)
		unitHide.value = unit.unitHidden

		divide.width = max(unit.divideWidth-1, 0)
		divide.height = max(unit.divideHeight-1, 0)
		viewMaxSize.setSize(unit.viewMaxSize)
		margin.setMargin(unit.margin.insets)

		otherInfo.value = unit.otherInfo

		// セクションを切り替え
		setupSection()
	}

	override func onSave() {

		// ユニットの情報を保存
		// →　typeIndexに応じて保存する情報が変わる
		switch typeIndex.value {
		case 0:		// space
			saveSpace()

		case 1:		// divide
			saveDivide()

		default:	// other
			saveOther()
		}
	}

	override func onChange(config: SK4ConfigValue) {
		if autoSave.flag {

			// 必要ならセクションを切り替え
			if config === typeIndex {
				setupSection()

				if let tv = cell.configTable?.tableView {
					tv.reloadData()
				}
			}

			// データを保存
			autoSaveConfig()

			// 更新を随時通知
			g_admin.unitUpdate()
		}
	}

	// /////////////////////////////////////////////////////////////

	/// typeIndex.valueにあわせてセクションを切り替え
	func setupSection() {
		removeUserSectionAll()

		let type = addUserSection("Unit type")
		type.addConfig(typeIndex)

		if typeIndex.value == 0 {

			// do nothing

		} else if typeIndex.value == 1 {
			let tmp = addUserSection("Divide")
			tmp.addConfig(divide)
			tmp.addConfig(sortChildren)

		} else if typeIndex.value == 2 {
			let tmp = addUserSection("Other")
			tmp.addConfig(typeName)
			tmp.addConfig(viewMaxSize)
			tmp.addConfig(margin)
			tmp.addConfig(otherInfo)
		}

		let info = addUserSection("Common Info")
		info.addConfig(initSize)
		info.addConfig(unitHide)
	}
	
	// /////////////////////////////////////////////////////////////

	/// unitType・initSize
	func saveSpace() {
		saveCommon(SK4DivideLayoutUnit.TypeName.space)
		saveClearDivide()
		saveClearOther()
	}

	// unitType・initSize・分割数・子ユニット
	func saveDivide() {
		saveCommon(SK4DivideLayoutUnit.TypeName.divide)

		let wx = divide.width + 1
		let wy = divide.height + 1
		unit.changeDivide(width: wx, height: wy)

		saveClearOther()
	}

	// unitType・initSize・viewMaxSize・margin・otherInfo
	func saveOther() {
		var str = typeName.value.sk4TrimSpace()
		if str.isEmpty || str == SK4DivideLayoutUnit.TypeName.space || str == SK4DivideLayoutUnit.TypeName.divide {
			str = "unit"
		}
		typeName.value = str

		saveCommon(str)
		saveClearDivide()

		unit.viewMaxSize = viewMaxSize.getSize()
		unit.margin.insets = margin.getMargin()
		unit.otherInfo = otherInfo.value.sk4TrimSpace()
	}

	// /////////////////////////////////////////////////////////////

	func saveCommon(unitType: String) {
		unit.unitType = unitType
		unit.unitInitSize = initSize.getSize()
		unit.unitHidden = unitHide.value
	}

	func saveClearDivide() {
		unit.divideWidth = 0
		unit.divideHeight = 0
		unit.children.removeAll()
	}

	func saveClearOther() {
		unit.viewMaxSize.clear()
		unit.margin.clear()
		unit.otherInfo = ""
	}

}

// eof
