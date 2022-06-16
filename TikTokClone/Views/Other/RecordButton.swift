//
//  RecordButton.swift
//  TikTokClone
//
//  Created by Caleb Ngai on 6/15/22.
//

import UIKit

class RecordButton: UIButton {
    
    enum State {
        case recording
        case notRecording
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = nil
        layer.masksToBounds = true
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2.5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = height/2
    }
    
    public func toggle(for state: State) {
        
        switch state {
        case .recording:
            backgroundColor = .red
        case .notRecording:
            backgroundColor = nil
        }
        
    }

}
