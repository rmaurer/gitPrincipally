//
//  ReverseParkedTextField.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 7/26/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit

class ReverseParkedTextField: UITextField {

    // MARK: Properties
    
    /// Constant part of the text. Defaults to "".
    @IBInspectable internal var parkedText: String {
        get {
            return _parkedText
        }
        set {
            if !text.isEmpty {
                let typed = text[text.startIndex..<advance(text.endIndex, -count(parkedText))]
                text = newValue + typed
                
                prevText =  text
                _parkedText = newValue
                
                textChanged(self)
            } else {
                _parkedText = newValue
            }
            
            // Force update placeholder to get the new value of parkedText
            placeholder = parkedText + placeholderText
        }
    }
    var _parkedText = ""
    
    /// Variable part of the text. Defaults to "".
    @IBInspectable internal var typedText: String {
        get {
            if text.hasSuffix(parkedText) {
                return text[text.startIndex..<advance(text.endIndex, -count(parkedText))]
            } else {
                return text
            }
        }
        set {
            text =  parkedText + newValue
            textChanged(self)
        }
    }
    
    /// Placeholder before parkedText. Defaults to "".
    @IBInspectable internal var placeholderText: String = "" {
        didSet {
            placeholder =  parkedText + placeholderText
        }
    }
    
    
    /// Constant part of the text. Defaults to the text field's font.
    internal var parkedTextFont: UIFont! {
        didSet {
            parkedText += ""
        }
    }
    
    /// Constant part of the text. Defaults to the text field's textColor.
    @IBInspectable internal var parkedTextColor: UIColor! {
        didSet {
            parkedText += ""
        }
    }
    
    /// Attributes wrapper for font and color of parkedText
    var parkedTextAttributes: [String: NSObject] {
        return [
            NSFontAttributeName: parkedTextFont,
            NSForegroundColorAttributeName: parkedTextColor ?? textColor
        ]
    }
    
    internal override var placeholder: String? {
        didSet {
            if let placeholder = placeholder {
                let attributedString = NSMutableAttributedString(string: placeholder)
                let parkedTextRange = NSMakeRange(count(placeholderText), count(parkedText))
                if placeholder.hasSuffix(parkedText) {
                    attributedString.addAttributes(parkedTextAttributes, range: parkedTextRange)
                    attributedPlaceholder = attributedString
                }
            }
        }
    }
    
    enum TypingState {
        case Start, Typed
    }
    var typingState = TypingState.Start
    
    var beginningOfParkedText: UITextPosition? {
        get {
            return positionFromPosition(endOfDocument, offset: count(parkedText))
        }
    }
    
    var prevText = ""
    
    
    // MARK: Initialization
    
    internal required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        if let boldFont = bold(font) {
            parkedTextFont = boldFont
        } else {
            parkedTextFont = font
        }
        
        parkedTextColor = textColor
        
        addTarget(self, action: "textChanged:", forControlEvents: .EditingChanged)
        
        text = ""
        prevText = text
        
        typingState = .Start
    }
    
    
    // MARK: EditingChanged handler
    
    func textChanged(sender: UITextField) {
        switch typingState {
        case .Start where count(text) > 0:
            text = parkedText + typedText
            updateAttributedTextWith(text)
            prevText = text
            //goToBeginningOfParkedText()
            
            typingState = .Typed
            
        case .Typed:
            if text == parkedText {
                typingState = .Start
                text = ""
                return
            }
            
            // If the parkedText has changed, don't update prevText.
            if text.hasSuffix(parkedText) {
                prevText = text
            }
            updateAttributedTextWith(prevText)
            //goToBeginningOfParkedText()
            
        default:
            break
            
        }
    }
    
    // MARK: Utilites
    func updateAttributedTextWith(text: String) {
        if let parkedTextRange = text.rangeOfString(parkedText, options: NSStringCompareOptions.BackwardsSearch, range: nil, locale: nil) {
            let nsRange = NSRangeFromRange(text, range: parkedTextRange)
            
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttributes(parkedTextAttributes, range: nsRange)
            
            attributedText = attributedString
        }
    }
    
    /// http://stackoverflow.com/questions/25138339/nsrange-to-rangestring-index
    func NSRangeFromRange(text:String, range : Range<String.Index>) -> NSRange {
        let utf16view = text.utf16
        let from = String.UTF16View.Index(range.startIndex, within: utf16view)
        let to = String.UTF16View.Index(range.endIndex, within: utf16view)
        return NSMakeRange(from - utf16view.startIndex, to - from)
    }
    
    func goToBeginningOfParkedText() {
        if let position = beginningOfParkedText {
            goToTextPosition(position)
        }
    }
    
    func goToTextPosition(textPosition: UITextPosition!) {
        selectedTextRange = textRangeFromPosition(textPosition, toPosition: textPosition)
    }
    
    func bold(font: UIFont) -> UIFont? {
        let descriptor = font.fontDescriptor().fontDescriptorWithSymbolicTraits(UIFontDescriptorSymbolicTraits.TraitBold)
        
        if let descriptor = descriptor {
            return UIFont(descriptor: descriptor, size: 0)
        } else {
            return nil
        }
    }

}
