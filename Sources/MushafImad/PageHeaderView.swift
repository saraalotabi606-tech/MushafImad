//
//  PageHeader.swift
//  MushafImad
//
//  Created by Ibrahim Qraiqe on 31/10/2025.
//

import SwiftUI

public struct PageHeaderView: View {
    public let page: Page
    public var horizentalPadding: CGFloat = 16
    
    public init(page: Page, horizentalPadding: CGFloat = 16) {
        self.page = page
        self.horizentalPadding = horizentalPadding
    }
    
    public var body: some View {
        HStack {
            let headerDisplay = getPageHeaderDisplay(page: page)
            
            if let juz = headerDisplay.juz {
                Text(juz)
                    .font(.chapterNames(size: 20))
            }
            
            Spacer()
            
            ForEach(headerDisplay.titles, id:\.self) { title in
                Text("سورة \(title)")
                    .font(.chapterNames(size: 24))
            }
        }
        .foregroundColor(.brand900)
        .padding(.horizontal, horizentalPadding)
        .padding(.vertical, 4)
        .environment(\.layoutDirection, .rightToLeft)
    }
    
    public func getPageHeaderDisplay(page: Page) -> (juz: String?, titles: [String]) {
        guard let header = page.header1441 else {
            return (nil, [])
        }
        let titles: [String] = header.chapters.map { $0.arabicTitle }
        
        let juzDisplay: String? = header.part.map {
            "الجزء \(arabicSpelled($0.number))"
        }
        
        return (juzDisplay, titles)
    }
    
    // MARK: - تحويل الأرقام لكتابة عربية
    private func arabicSpelled(_ number: Int) -> String {
        let ones = [
            "", "الأوّل", "الثاني", "الثالث", "الرابع", "الخامس",
            "السادس", "السابع", "الثامن", "التاسع", "العاشر",
            "الحادي عشر", "الثاني عشر", "الثالث عشر", "الرابع عشر", "الخامس عشر",
            "السادس عشر", "السابع عشر", "الثامن عشر", "التاسع عشر"
        ]
        
        if number <= 0 { return "" }
        if number < 20 { return ones[number] }
        
        let tenPart = number / 10
        let onePart = number % 10
        
        // ٢٠ → العشرون، ٣٠ → الثلاثون
        let tensOnly = ["", "", "العشرون", "الثلاثون"]
        if onePart == 0 && tenPart < tensOnly.count {
            return tensOnly[tenPart]
        }
        
        // ٢١ → الحادي والعشرون، ٢٤ → الرابع والعشرون
        let onesCompound = [
            "", "الحادي", "الثاني", "الثالث", "الرابع", "الخامس",
            "السادس", "السابع", "الثامن", "التاسع"
        ]
        let tensCompound = ["", "", "والعشرون", "والثلاثون"]
        
        if tenPart < tensCompound.count && onePart < onesCompound.count {
            return "\(onesCompound[onePart]) \(tensCompound[tenPart])"
        }
        
        return "\(number)"
    }
}
