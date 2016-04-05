//
//  LayoutEditViewController.swift
//  DivideLayoutMaker
//
//  Created by See.Ku on 2016/04/02.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit
import SK4Toolkit

class LayoutEditViewController: UIViewController, SK4DivideLayoutAdminDelegate, UIDocumentInteractionControllerDelegate {

	let check = SK4LeakCheck(name: "LayoutEditViewController")

	@IBOutlet weak var baseView: UIView!

	@IBOutlet weak var baseViewTop: NSLayoutConstraint!
	@IBOutlet weak var baseViewRight: NSLayoutConstraint!
	@IBOutlet weak var baseViewBottom: NSLayoutConstraint!
	@IBOutlet weak var baseViewLeft: NSLayoutConstraint!

	@IBAction func onToggleBar(sender: AnyObject) {
		let flag = navigationController?.navigationBarHidden ?? true
		navigationController?.setNavigationBarHidden(!flag, animated: true)

		if let btn = sender as? UIButton {
			let title = flag ? "▲" : "▼"
			btn.setTitle(title, forState: .Normal)
		}
	}

	/// ユニットが選択された
	func onSelectUnit(view: LayoutEditView) {
		if let unit = view.layoutUnit, vc = storyboard?.instantiateViewControllerWithIdentifier("EditUnit") as? UnitConfigViewController {
			g_admin.currentUnit = unit
			vc.aloneEdit = true

			let nav = UINavigationController(rootViewController: vc)
			nav.modalPresentationStyle = .FormSheet
			presentViewController(nav, animated: true, completion: nil)
		}
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - メニュー処理

	func onMenu(sender: AnyObject) {
		let alert = SK4ActionSheet(item: sender)

		alert.addDefault("File Config") { aa in
			self.editFileConfig()
		}

		alert.addDefault("Export Layout") { aa in
			self.exportLayout()
		}

		alert.addDefault("Import Layout") { aa in
			self.importLayout()
		}

		alert.addDefault("Share Layout") { aa in
			self.shareLayout()
		}

		alert.addCancel("Cancel")

		alert.presentAlertController(self)
	}

	func editFileConfig() {
		let config = FileConfig(layoutFile: layoutFile)
		config.openConfigViewController(self) { cancel in
			if cancel {
				return
			}

			self.setupLayoutView()
			g_admin.unitUpdate()

			if config.renameError {
				sk4AsyncMain(0.5) {
					sk4AlertView(title: "Failed to change filename.", message: config.filename.value, vc: self)
				}
			}
		}
	}

	func exportLayout() {
		let vc = SK4TextExportViewController()
		vc.title = "Export Layout"
		vc.exportText = self.layoutFile.exportLayout()
		navigationController?.pushViewController(vc, animated: true)
	}

	func importLayout() {
		let vc = SK4TextImportViewController()
		vc.title = "Import Layout"
		vc.importExec = { text in
			self.layoutFile.importLayout(text)
			self.setupLayoutAdmin()
			self.setupLayoutView()
			g_admin.unitUpdate()
			return nil
		}
		navigationController?.pushViewController(vc, animated: true)
	}

	var shareDoc: UIDocumentInteractionController!

	func shareLayout() {
		let url = NSURL(fileURLWithPath: layoutFile.fullpath)
		shareDoc = UIDocumentInteractionController(URL: url)
		shareDoc.presentOptionsMenuFromRect(CGRect(), inView: view, animated: true)
	}

	// /////////////////////////////////////////////////////////////

	func setupLayoutAdmin() {
		layoutAdmin = layoutFile.layoutAdmin
		layoutAdmin.delegate = self
		layoutAdmin.setBaseView(baseView)
	}

	func setupLayoutView() {
		navigationItem.title = layoutFile.filename

		baseViewTop.constant = layoutFile.editViewMargin.top
		baseViewRight.constant = layoutFile.editViewMargin.right
		baseViewBottom.constant = layoutFile.editViewMargin.bottom
		baseViewLeft.constant = layoutFile.editViewMargin.left
	}

	// /////////////////////////////////////////////////////////////

	var layoutFile: LayoutFile!
	var layoutAdmin: SK4DivideLayoutAdmin!

    override func viewDidLoad() {
        super.viewDidLoad()

		AppEvent.UpdateUnit.recieveNotify(self) { [weak self] in
			self?.layoutAdmin.updateLayoutAuto()
		}

		assert(g_admin.currentLayout != nil)
		layoutFile = g_admin.currentLayout

		setupLayoutAdmin()
		setupLayoutView()

		let menu = sk4BarButtonItem(title: "Menu", target: self, action: #selector(LayoutEditViewController.onMenu(_:)))
		navigationItem.rightBarButtonItem = menu
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		layoutAdmin.updateLayoutAuto(self)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	// /////////////////////////////////////////////////////////////
	// MARK: - SK4DivideLayoutAdminDelegate

	/// 対応するViewを作成する
	func createDivideLayoutView(unit: SK4DivideLayoutUnit) -> UIView {
		let vi = LayoutEditView()
		vi.parent = self
		return vi
	}
	
}

// eof
