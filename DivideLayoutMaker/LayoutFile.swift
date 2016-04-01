//
//  LayoutFile.swift
//  DivideLayoutMaker
//
//  Created by See.Ku on 2016/04/02.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit
import SK4Toolkit

/// 実際のレイアウトとファイル名をあわせて管理するためのクラス
class LayoutFile {

	/// ファイル名
	var filename = ""

	/// レイアウト
	var layoutAdmin = SK4DivideLayoutAdmin()

	/// 編集用Viewで使用するマージン
	var editViewMargin = UIEdgeInsets()

	init() {
	}

	convenience init(filename: String) {
		self.init()
		self.filename = filename

		readLayout()
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - レイアウトを指定してユニットを作成

	enum BaseType {
		case Free
		case StatusBar
		case NavigationBar

		// TODO: ToolBarが必要？
		// TODO: TabBarも別に必要？
	}

	func makeLayout(base: BaseType) {
		let portrait: SK4DivideLayoutUnit
		let landscape: SK4DivideLayoutUnit

		switch base {
		case .Free:
			portrait = SK4DivideLayoutUnit()
			landscape = SK4DivideLayoutUnit()

		case .StatusBar:
			// 縦向き、上下2分割、ステータスバーの高さは決め打ち
			portrait = SK4DivideLayoutUnit.makeDivideUnit(width: 1, height: 2)
			portrait.addChildSpace(width: 0, height: 20)

			if sk4IsPhone() {

				// iPhoneの横向きは分割無し
				landscape = SK4DivideLayoutUnit()

			} else {

				// その他の横向きは分割
				landscape = SK4DivideLayoutUnit.makeDivideUnit(width: 1, height: 2)
				landscape.addChildSpace(width: 0, height: 20)
			}

		case .NavigationBar:
			// 縦向き、上下3分割
			portrait = SK4DivideLayoutUnit.makeDivideUnit(width: 1, height: 3)
			portrait.addChildSpace(width: 0, height: 20)
			portrait.addChildSpace(width: 0, height: 40)

			if sk4IsPhone() {

				// 横向き、上下2分割
				landscape = SK4DivideLayoutUnit.makeDivideUnit(width: 1, height: 2)
				landscape.addChildSpace(width: 0, height: 32)

			} else {

				// 横向き、上下3分割
				landscape = SK4DivideLayoutUnit.makeDivideUnit(width: 1, height: 3)
				landscape.addChildSpace(width: 0, height: 20)
				landscape.addChildSpace(width: 0, height: 40)
			}
		}

		// 不足している子ユニットを充填
		portrait.fillChild()
		landscape.fillChild()

		layoutAdmin.modePortrait = portrait
		layoutAdmin.modeLandscape = landscape
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - インポート／エクスポート

	func importLayout(json: String) {
		layoutAdmin = SK4DivideLayoutAdmin()
		if let dic = json.sk4JsonToDic() {
			dic.sk4Get("EditViewMargin", value: &editViewMargin.insets)
			layoutAdmin.readLayoutFromDictionary(dic)
		}
	}

	func exportLayout() -> String {
		let dic = layoutAdmin.writeLayoutToDictionary()
		if editViewMargin.isEmpty == false {
			dic["EditViewMargin"] = editViewMargin.insets
		}
		return dic.sk4DicToJson()!
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - ファイル入出力

	var fullpath: String {
		return sk4GetDocumentDirectory() + filename
	}

	/// ファイルから読み込み
	func readLayout() {
		if let json = String.sk4ReadFile(fullpath) {
			importLayout(json)
		}
	}

	/// ファイルに保存
	func writeLayout() {
		let json = exportLayout()
		json.sk4WriteFile(fullpath)
	}

	/// ファイル名を変更
	func renameFilename(filename: String) -> Bool {
		let keep = self.filename
		let src = fullpath

		self.filename = filename
		let dst = fullpath

		if sk4MoveFile(src: src, dst: dst) == false {
			self.filename = keep
			return true
		} else {
			return false
		}
	}

}

// eof
