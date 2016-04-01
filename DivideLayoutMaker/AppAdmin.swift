//
//  AppAdmin.swift
//  DivideLayoutMaker
//
//  Created by See.Ku on 2016/04/02.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit
import SK4Toolkit

// /////////////////////////////////////////////////////////////

/// 各種通知
enum AppEvent: SK4Notify {
	case UpdateUnit

}

/// 各種定数
struct AppConst {

	/// 数値を指定する間隔
	static let interval = 4

	/// マージンの最大値
	static let marginMax = 200

	/// サイズの最大値
	static let sizeMax = 1000

	/// 最大分割数
	static let divideMax = 20

}

// /////////////////////////////////////////////////////////////

let g_admin = AppAdmin()

class AppAdmin {

	let writeTimer = SK4LazyTimer()
	var currentLayout: LayoutFile?
	var currentUnit: SK4DivideLayoutUnit?

	init() {
		writeTimer.setup(hold: 1.0) { [weak self] in
			self?.currentLayout?.writeLayout()
		}
	}

	/// ユニットが更新された
	func unitUpdate() {
		if let admin = currentLayout?.layoutAdmin {
			admin.modePortrait?.setupMode()
			admin.modeLandscape?.setupMode()
			admin.removeHideView()
		}

		writeTimer.fire()
		AppEvent.UpdateUnit.postNotify()
	}

	// /////////////////////////////////////////////////////////////

	func newLayout(base: LayoutFile.BaseType) {
		let layout = LayoutFile()
		layout.filename = findFilename()
		layout.makeLayout(base)
		layout.writeLayout()
		currentLayout = layout
	}

	func readLayout(filename: String) {
		currentLayout = LayoutFile(filename: filename)
	}

	func deleteLayout(filename: String) {
		let path = sk4GetDocumentDirectory() + filename
		sk4DeleteFile(path)
	}

	// /////////////////////////////////////////////////////////////

	func makeFilelist() -> [String] {
		let path = sk4GetDocumentDirectory()
		return sk4FileListAtPath(path)
	}

	func findFilename() -> String {
		let path = sk4GetDocumentDirectory()
		let ar = sk4FileListAtPath(path)

		// まだ使われてないファイル名を検索
		var no = 1
		var name = ""
		repeat {
			let str = String(format: "item%02d", no)
			no += 1
			name = makeFilename(str)
		} while ar.indexOf(name) != nil

		return name
	}

	func makeFilename(name: String) -> String {
		let hard = sk4IsPhone() ? "iPhone" : "iPad"
		return "\(name)-\(hard).divlay"
	}

}

// eof
