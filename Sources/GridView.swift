//
//  GridView.swift
//  SUIUtilityView
//
//  Created by Jorge on 4/19/20.
//

import SwiftUI

struct GridView: View {
    enum Base { case row, column }
    
    var minCellSize: CGSize
    var geometry: GeometryProxy
    var base: Base
    var cells: [AnyView]
    
    /// Minimum cell size in the base axis
    fileprivate var minBaseSize: CGFloat {
        switch base {
        case .column:
            return minCellSize.height
        case .row:
            return minCellSize.width
        }
    }
    
    /// Minimum cell size in the cross axis
    fileprivate var minCrossSize: CGFloat {
        switch base {
        case .column:
            return minCellSize.width
        case .row:
            return minCellSize.height
        }
    }
    
    var body: some View {
        self.generateCanvas(geometry: geometry)
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
    }
    
    fileprivate func generateCanvas(geometry: GeometryProxy) -> AnyView {
        //Max number of cells that fit in the base axis
        let maxColumns = max(1, Int(viewBaseSize(geometry) / minBaseSize))
        //Number of cells that fit in the cross axis without scrolling
        let targetRows = max(1, Int(viewCrossSize(geometry) / minCrossSize))
        
        // Actual number of cells in the base axis
        let columns = min(maxColumns, cells.count)
        // Actual number of cells in the cross axis
        let rows = columns == 0 ? 0 : 1 + (cells.count - 1) / columns
        
        let cellSize = self.cellSize(for: geometry, with: maxColumns)
        
        var index = 0
        //Didn't find a way arround repeating the code
        switch base {
        case .row:
            return AnyView(VStack(alignment: .leading, spacing: 0) {
                ForEach(0..<rows, id: \.self) { _ in
                    self.generateRow(maxCellCount: maxColumns, cellSize: cellSize, startAt: &index)
                }
                
                if rows < targetRows {
                    Spacer()
                }
            })
        case .column:
            return AnyView(HStack(alignment: .top, spacing: 0) {
                ForEach(0..<rows, id: \.self) { _ in
                    self.generateRow(maxCellCount: maxColumns, cellSize: cellSize, startAt: &index)
                }
                
                if rows < targetRows {
                    Spacer()
                }
            })
        }
    }
    
    fileprivate func generateRow(maxCellCount: Int, cellSize: CGSize, startAt index: inout Int) -> AnyView {
        let startIndex = index
        let cellCount = min(maxCellCount, cells.count - startIndex)
        index += cellCount
        
        //Didn't find a way arround repeating the code
        switch base {
        case .row:
            return AnyView(HStack(alignment: .top, spacing: 0) {
                ForEach(0..<cellCount, id: \.self) { column in
                    self.cells[startIndex + column]
                        .frame(
                            width: cellSize.width,
                            height: cellSize.height
                        )
                }

                if cellCount < maxCellCount {
                    Spacer()
                }
            })
        case .column:
            return AnyView(VStack(alignment: .leading, spacing: 0) {
                ForEach(0..<cellCount, id: \.self) { column in
                    self.cells[startIndex + column]
                        .frame(
                            width: cellSize.width,
                            height: cellSize.height
                        )
                }

                if cellCount < maxCellCount {
                    Spacer()
                }
            })
        }
    }
    
    fileprivate func cellSize(for geometry: GeometryProxy, with baseCount: Int) -> CGSize {
        let baseSize = self.viewBaseSize(geometry) / CGFloat(baseCount)
        
        switch base {
        case .row:
            return CGSize(
                width: max(minBaseSize, baseSize), height: minCellSize.height
            )
        case .column:
            return CGSize(
                width: minCellSize.width, height: max(minBaseSize, baseSize)
            )
        }
    }
    
    fileprivate func viewBaseSize(_ geometry: GeometryProxy) -> CGFloat {
        switch base {
        case .column:
            return geometry.size.height
        case .row:
            return geometry.size.width
        }
    }
    
    fileprivate func viewCrossSize(_ geometry: GeometryProxy) -> CGFloat {
        switch base {
        case .column:
            return geometry.size.width
        case .row:
            return geometry.size.height
        }
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GeometryReader { geometry in
                GridView(
                    minCellSize: CGSize(width: 100, height: 100),
                    geometry: geometry,
                    base: .row,
                    cells: cells
                )
            }
            GeometryReader { geometry in
                GridView(
                    minCellSize: CGSize(width: 100, height: 100),
                    geometry: geometry,
                    base: .column,
                    cells: cells
                )
            }
        }
    }
}

let cells = [
    AnyView(
        GeometryReader { geometry in
            Text("Red")
                .foregroundColor(Color.white)
                .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                .background(Color.red)
        }
    ),AnyView(
        GeometryReader { geometry in
            Text("Orange")
                .foregroundColor(Color.white)
                .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                .background(Color.orange)
        }
    ),AnyView(
        GeometryReader { geometry in
            Text("Yellow")
                .foregroundColor(Color.black)
                .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                .background(Color.yellow)
        }
    ),AnyView(
        GeometryReader { geometry in
            Text("Green")
                .foregroundColor(Color.black)
                .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                .background(Color.green)
        }
    ),AnyView(
        GeometryReader { geometry in
            Text("Cyan")
                .foregroundColor(Color.black)
                .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                .background(Color(red: 0, green: 1, blue: 1))
        }
    ),AnyView(
        GeometryReader { geometry in
            Text("Blue")
                .foregroundColor(Color.white)
                .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                .background(Color.blue)
        }
    ),AnyView(
        GeometryReader { geometry in
            Text("Purple")
                .foregroundColor(Color.white)
                .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                .background(Color.purple)
        }
    ),AnyView(
        GeometryReader { geometry in
            Text("Black")
                .foregroundColor(Color.white)
                .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                .background(Color.black)
        }
    ),AnyView(
        GeometryReader { geometry in
            Text("White")
                .foregroundColor(Color.black)
                .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                .background(Color.white)
        }
    ),
]
