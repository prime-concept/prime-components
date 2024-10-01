extension RandomAccessCollection {
    
    /// Returns the element at the given index, if it exists.
    public subscript(safe index: Index) -> Element? {
        // `endIndex` is the collection’s “past the end” position—that is,
        // the position one greater than the last valid subscript argument.
        guard index >= startIndex, index < endIndex else { return nil }
        return self[index]
    }
    
}
