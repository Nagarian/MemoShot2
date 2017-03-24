//
//  MemoTextTableViewCell.swift
//  MemoShot
//
//  Created by Developer on 23/03/2017.
//  Copyright © 2017 Nagarian. All rights reserved.
//

import UIKit

protocol TextMemoCellDelegate: class {
    func textChanged(str: String, at index: Int)
}

class MemoTextTableViewCell: UITableViewCell {

    @IBOutlet weak var textContent: UITextView!
    
    weak var delegate: TextMemoCellDelegate?
    
    var indexRow: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        textContent.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension MemoTextTableViewCell: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("toto")
        delegate?.textChanged(str: textView.text, at: indexRow!)
    }
}
