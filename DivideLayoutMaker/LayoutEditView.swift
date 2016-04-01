//
//  LayoutEditView.swift
//  DivideLayoutMaker
//
//  Created by See.Ku on 2016/04/02.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit
import SK4Toolkit

class LayoutEditView: SK4DivideLayoutView {

	weak var parent: LayoutEditViewController?

	override init() {
		super.init()

		debugDraw = true
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		parent?.onSelectUnit(self)
	}

}

// eof
