
struct SafeArray<Element: Numeric> {
    
    private var array: [Element]
    private let defaultValue: Element
    
    init(_ array: [Element], defaultValue: Element = 0) {
        self.array = array
        self.defaultValue = defaultValue
    }
    
    subscript(index: Int) -> Element {
        if (index >= 0 && index < array.count) {
            //print("returning from SafeArray, index \(index)")
            return array[index]
        }
        else {
            print("⚠️invalid array index - index was \(index); min. index: 0; max. index: \(array.count-1)\n")
            return defaultValue
        }
    }
}
