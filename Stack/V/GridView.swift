import SwiftUI

struct GridView: View {
    var rowGridItems: [GridItem]
    @ObservedObject var viewModel: GridViewModel // TODO: rename this to 'viewModel'
    @State private var isPresentingKeyboard = false
    let gridColor = ViewModelSettings.showUIColors ? Color.gray : Color.clear
    let vStackColor = ViewModelSettings.showUIColors ? Color.red : Color.clear
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width, height = geometry.size.height
            VStack {
                let topGap = 0.2
                let widthFactor = 0.9  // 90% of the width of the screen
                Spacer(minLength: height * topGap) // Spacing top, to center the grid vertically
                
                LazyHGrid(rows: rowGridItems, spacing: 20) {
                    ForEach($viewModel.nodes) { $node in
                        let value = node.value == 0 ? "." : node.displayValue
                        Text(value)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                            .onTapGesture {
                                if node.dependency == nil && !node.isSetFromRestAPI {
                                    self.viewModel.selectedNode = node
                                    self.isPresentingKeyboard = true
                                }
                            }
                            .onLongPressGesture { /// probably wrap this in a 'developerMode' bool flag
                                let nodeHasCycle = node.hasCycle() ? "⚠️node has cycle\n" : ""
                                print("\n\(nodeHasCycle)long-pressed node \(label(for: node)) \nnode dependency: \(node.dependency?.nodes.map{label(for: $0)} ?? []) \n→ During this app session this node has been updated: \n\(node.changes.manual) time(s), manually; \n\(node.changes.viaFormula) time(s) via formula; and \n\(node.changes.viaAPI) time(s) via API calls\n")
                            }
                    }
                }
                .sheet(isPresented: $isPresentingKeyboard) {
                    if let selectedNode = self.viewModel.selectedNode {
                        NumberInputView(nodeValue: Binding(
                            get: { selectedNode.value },
                            set: { newValue in
                                print("[ tapped ] node \(label(for: selectedNode)) set to \(newValue)")
                                self.viewModel.selectedNode?.value = newValue
                                self.viewModel.selectedNode?.changes.manual += 1
                            }
                        ), isPresenting: $isPresentingKeyboard)
                    }
                }
                
                .background(gridColor)
                .frame(
                    width: width * widthFactor,
                    height: height * (1 - 2 * topGap)
                )
                
                Spacer(minLength: height * topGap) // Spacing bottom, to center the grid vertically
            }
            .background(vStackColor)
            .frame(width: width, height: height)
        }
    }
    
    func label(for node: Node) -> String {
        "\(node.index)\(viewModel.columnAndRow(from: node.index))"
    }
    
}
