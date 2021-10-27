import SwiftUI

struct DrawingView: View {
    
    @State private var lines = [Line]()
    
    @State private var selectedColor: Color = .black
    @State private var selectedLineWidth: CGFloat = 1
    
    let engine = DrawingEngine()
    
    let xSize:CGFloat = 20;
    let ySize:CGFloat = 20;
    
    var body: some View {
        
        VStack {
        Canvas { context, size in

            context.scaleBy(x: xSize, y: ySize)
            for line in lines {

                let path = engine.createPath(for: line.points)

                
                context.stroke(path, with: .color(line.color), style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .square, lineJoin: .bevel))
                
            }
        }
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged({ value in
            let xPointCoord = value.location.x / xSize
            let yPointCoord = value.location.y / ySize
            let newPoint = CGPoint(x:xPointCoord ,y: yPointCoord)
          
            if value.translation.width + value.translation.height == 0 {
                //TODO: use selected color and linewidth
                lines.append(Line(points: [newPoint], color: selectedColor, lineWidth: selectedLineWidth))
            } else {
                let index = lines.count - 1
                lines[index].points.append(newPoint)
            }
            
        }).onEnded({ value in
            if let last = lines.last?.points, last.isEmpty {
                lines.removeLast()
            }
        })
        
        ).scaledToFit()
            
        }
    }
}

struct DrawingView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingView()
    }
}
