# SwiftUI Utility Views
Commonly used SwiftUI views

These are some reusable views I create for things that I think might be commonly desirable e.g. a grid view.

Included views:
- GridView

## Usage:
#### GridView
`GridView`s can be either row based or column based. Row based grids get filled row by roy, and column based
grids get filled column by column. To layout cells properly: `GridView`s need to have a `GeometryReader`
ancestor that's the same size as the parent view.

To create a `GridView` you need to provide the minimum desired cell size <sup>1</sup>, a`GeometryProxy` from the
ancestor `GeometryReader`, specify what the base axis is, and an array of views to layout inside the grid.

The reason to require prebuilt cells, instead of a cell builder (like a `ForEach`) and a collection of models is
to give the flexibility to provide different types of views as cells inside the grid.

<sub>1: I'll try to create a new version that doesn't needs this</sub>

##### Example
```Swift
// You must create your own cells, they can even be of different types
// In this example I use an array of data models and transform it
// into an array of MyCellViews wrapped inside AnyViews
var cells: [AnyView] {
  self.models.map { model in
    AnyView(
      MyCellView(model: model)
    )
  }
}

var body: some View {
  GeometryReader { geometry in
    ScrollView {
      GridView(
        cellSize: CGSize(width: 100, height: 100),
        geometry: geometry,
        base: .row,
        cells: self.cells
       )
    }
    // You can (sort of) animate when the parent view is resized
    .animation(.default)
  }
}
```
