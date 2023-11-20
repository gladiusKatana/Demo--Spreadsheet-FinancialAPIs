import SwiftUI

struct NumberInputView: View {
    @Binding var nodeValue: Double
    @State private var textValue: String
    @Binding var isPresenting: Bool
    @FocusState private var isInputActive: Bool
    
    init(nodeValue: Binding<Double>, isPresenting: Binding<Bool>) {
        self._nodeValue = nodeValue
        self._textValue = State(initialValue: String(nodeValue.wrappedValue))
        self._isPresenting = isPresenting
    }
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Edit value", text: $textValue)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.center)
                .focused($isInputActive)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.isInputActive = true
                    }
                }
            Button("Done") {
                //print("tapped Done\n")
                isPresenting = false // Dismisses the entire sheet
                if let newValue = Double(textValue), newValue != nodeValue {
                    nodeValue = newValue
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            
        }
        .padding()
    }
    
}
