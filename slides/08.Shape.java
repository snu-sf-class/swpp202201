interface ShapeI {
  getArea()
}

interface RectangleI extends ShapeI{
   setWidth(width)
   setHeight(height)
}

class Rectangle implements RectangleI {
   // ...
}

interface SquareI extends ShapeI{
   setSide(side)
}

class Square implements SquareI {
   Rectangle base
   Square() { base = new Rectangle }
   setSide(side) { base.setWidth(side); base.setHeight(side) }
   getArea() { return base.getArea() }
}