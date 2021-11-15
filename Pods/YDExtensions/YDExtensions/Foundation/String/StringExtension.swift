//
//  StringExtension.swift
//  YDExtensions
//
//  Created by Douglas Hennrich on 02/11/20.
//

import UIKit

public extension String {
  static func lorem(ofLength length: Int = 445) -> String {
    guard length > 0 else { return "" }

    // https://www.lipsum.com/
    let loremIpsum = """
          Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
          """
    if loremIpsum.count > length {
      return String(loremIpsum[loremIpsum.startIndex..<loremIpsum.index(loremIpsum.startIndex, offsetBy: length)])
    }
    return loremIpsum
  }

  func date(withFormat format: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.date(from: self)
  }

  func withQueryString(params: [String: String]) -> String? {
    var components = URLComponents(string: self)
    components?.queryItems = params.map { element in URLQueryItem(name: element.key, value: element.value) }

    return components?.url?.absoluteString
  }

  func applyPatternOnNumbers(pattern: String, replacmentCharacter: Character) -> String {
    var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
    for index in 0 ..< pattern.count {
      guard index < pureNumber.count else { return pureNumber }
      let stringIndex = String.Index(utf16Offset: index, in: self)
      let patternCharacter = pattern[stringIndex]
      guard patternCharacter != replacmentCharacter else { continue }
      pureNumber.insert(patternCharacter, at: stringIndex)
    }
    return pureNumber
  }

  var formattedNumberAsDouble: Double? {
    let formatter = NumberFormatter()
    formatter.usesGroupingSeparator = true
    formatter.locale = Locale(identifier: "pt_BR")
    return formatter.number(from: self)?.doubleValue
  }

  func format(with mask: String, maskOperator: Character) -> String {
    let numbers = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    var result = ""
    var index = numbers.startIndex // numbers iterator

    // iterate over the mask characters until the iterator of numbers ends
    for ch in mask where index < numbers.endIndex {
      if ch == maskOperator {
        // mask requires a number in this place, so take the next one
        result.append(numbers[index])

        // move numbers iterator to the next index
        index = numbers.index(after: index)

      } else {
        result.append(ch) // just append a mask character
      }
    }
    return result
  }
}

// MARK: Regex
public extension String {
  var phoneRegexPattern: String {
    return "/^(?:(?:\\+|00)?(55)\\s?)?(?:\\(?([1-9][0-9])\\)?\\s?)?(?:((?:9\\d|[2-9])\\d{3})\\-?(\\d{4}))$/"
  }

  var isValidEmail: Bool {
    matches("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
  }

  var containsOnlyDigits: Bool {
    let notDigits = NSCharacterSet.decimalDigits.inverted
    return rangeOfCharacter(from: notDigits, options: String.CompareOptions.literal, range: nil) == nil
  }

  var containsOnlyLetters: Bool {
    let notLetters = NSCharacterSet.letters.inverted
    return rangeOfCharacter(from: notLetters, options: String.CompareOptions.literal, range: nil) == nil
  }

  var isAlphanumeric: Bool {
    let notAlphanumeric = NSCharacterSet.decimalDigits.union(NSCharacterSet.letters).inverted
    return rangeOfCharacter(
      from: notAlphanumeric,
      options: String.CompareOptions.literal,
      range: nil
    ) == nil
  }

  func matches(_ expression: String) -> Bool {
    if let range = range(of: expression, options: .regularExpression, range: nil, locale: nil) {
      return range.lowerBound == startIndex && range.upperBound == endIndex
    } else {
      return false
    }
  }

}

// MARK: HTML
public extension String {
  var htmlToAttributed: NSMutableAttributedString? {
    do {
      guard let data = data(using: String.Encoding.utf8) else {
        return nil
      }
      return try NSMutableAttributedString(
        data: data,
        options: [
          .documentType: NSAttributedString.DocumentType.html,
          .characterEncoding: String.Encoding.utf8.rawValue
        ],
        documentAttributes: nil
      )
    } catch {
      print("error: ", error)
      return nil
    }
  }

  var htmlAttributed: (NSMutableAttributedString?, NSDictionary?) {
    do {
      guard let data = data(using: String.Encoding.utf8) else {
        return (nil, nil)
      }

      var dict: NSDictionary?
      dict = NSMutableDictionary()

      return try (NSMutableAttributedString(
        data: data,
        options: [
          .documentType: NSAttributedString.DocumentType.html,
          .characterEncoding: String.Encoding.utf8.rawValue
        ],
        documentAttributes: &dict
      ),
      dict
      )
    } catch {
      print("error: ", error)
      return (nil, nil)
    }
  }

  func htmlAttributed(using font: UIFont) -> NSMutableAttributedString? {
    do {
      let htmlCSSString = "<style>" +
        "html *" +
        "{" +
        "font-size: \(font.pointSize)pt !important;" +
        "font-family: \(font.familyName), Helvetica !important;" +
        "}</style> \(self)"

      guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
        return nil
      }

      return try NSMutableAttributedString(
        data: data,
        options: [
          .documentType: NSAttributedString.DocumentType.html,
          .characterEncoding: String.Encoding.utf8.rawValue
        ],
        documentAttributes: nil
      )
    } catch {
      print("error: ", error)
      return nil
    }
  }

  func htmlAttributed(family: String?, size: CGFloat) -> NSMutableAttributedString? {
    do {
      let htmlCSSString = "<style>" +
        "html *" +
        "{" +
        "font-size: \(size)pt !important;" +
        "font-family: \(family ?? "Helvetica"), Helvetica !important;" +
        "}</style> \(self)"

      guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
        return nil
      }

      return try NSMutableAttributedString(
        data: data,
        options: [
          .documentType: NSAttributedString.DocumentType.html,
          .characterEncoding: String.Encoding.utf8.rawValue
        ],
        documentAttributes: nil
      )
    } catch {
      print("error: ", error)
      return nil
    }
  }

  func htmlAttributed(size: CGFloat = 14) -> NSAttributedString? {
    let htmlFontSize = size*0.75

    do {
      let htmlCSSString = "<style>" +
        "html *" +
        "{" +
        "font-size: \(htmlFontSize)pt !important;" +
        "font-family: \("-apple-system"), Helvetica !important;" +
        "}</style> \(self)"

      guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
        return nil
      }

      let attributedString = try NSMutableAttributedString(
        data: data,
        options: [.documentType: NSAttributedString.DocumentType.html,
                  .characterEncoding: String.Encoding.utf8.rawValue],
        documentAttributes: nil
      )

      return attributedString
    } catch {
      print("htmlAttributed error: ", error)
      return nil
    }
  }
}
