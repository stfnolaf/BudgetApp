//
//  TaxBrackets.swift
//  Paycheck Planner
//
//  Created by Stephen O'Loughlin on 7/8/25.
//

// TaxBracket.swift
import Foundation

struct TaxBracket: Codable, Identifiable {
    let id = UUID()
    let lowerBound: Double
    let upperBound: Double?
    let rate: Double

    private enum CodingKeys: String, CodingKey {
        case lowerBound, upperBound, rate
    }
}

class TaxBrackets: Codable {
    let year: Int
    var brackets: [TaxBracket]

    init(year: Int, brackets: [TaxBracket]) {
        self.year = year
        self.brackets = brackets
    }
}

extension TaxBrackets {
    static func loadFromCSV(named fileName: String, year: Int) -> TaxBrackets? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "csv"),
              let content = try? String(contentsOf: url, encoding: .utf8) else {
            return nil
        }
        
        let lines = content.components(separatedBy: .newlines).filter { !$0.isEmpty }
        guard lines.count > 1 else { return nil } // Ensure there's at least a header and one row
        
        var brackets: [TaxBracket] = []
        for line in lines.dropFirst() { // Skip header
            let fields = line.split(separator: ",").map { String($0) }
            guard fields.count >= 3,
                  let lower = Double(fields[0]),
                  let rate = Double(fields[2]) else { continue }
            let upper = fields[1].isEmpty ? nil : Double(fields[1])
            brackets.append(TaxBracket(lowerBound: lower, upperBound: upper, rate: rate))
        }
        return TaxBrackets(year: year, brackets: brackets)
    }
}
