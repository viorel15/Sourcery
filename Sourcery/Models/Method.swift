import Foundation

//typealias used to avoid types ambiguty in tests
typealias SourceryMethod = Method

final class Method: NSObject, AutoDiffable, NSCoding {

    final class Parameter: NSObject, AutoDiffable, Typed, NSCoding {
        /// Parameter external name
        var argumentLabel: String

        /// Parameter internal name
        let name: String

        /// Parameter type name
        let typeName: TypeName

        /// Actual parameter type, if known
        var type: Type?

        init(argumentLabel: String? = nil, name: String, typeName: String) {
            self.typeName = TypeName(typeName)
            self.argumentLabel = argumentLabel ?? name
            self.name = name
        }

        // Method.Parameter.NSCoding {
        required init?(coder aDecoder: NSCoder) {
             guard let argumentLabel: String = aDecoder.decode(forKey: "argumentLabel") else { return nil }; self.argumentLabel = argumentLabel
             guard let name: String = aDecoder.decode(forKey: "name") else { return nil }; self.name = name
             guard let typeName: TypeName = aDecoder.decode(forKey: "typeName") else { return nil }; self.typeName = typeName
             self.type = aDecoder.decode(forKey: "type")

        }

        func encode(with aCoder: NSCoder) {

            aCoder.encode(self.argumentLabel, forKey: "argumentLabel")
            aCoder.encode(self.name, forKey: "name")
            aCoder.encode(self.typeName, forKey: "typeName")
            aCoder.encode(self.type, forKey: "type")

        }
        // } Method.Parameter.NSCoding
    }

    /// Method name including arguments names, i.e. `foo(bar:)`
    let selectorName: String

    /// All method parameters
    var parameters: [Parameter]

    /// Method name without arguments names and parenthesis
    var shortName: String {
        return selectorName.range(of: "(").map({ selectorName.substring(to: $0.lowerBound) }) ?? selectorName
    }

    /// Name of the return type
    var returnTypeName: TypeName

    /// Actual method return type, if known.
    // sourcery: skipEquality
    // sourcery: skipDescription
    //weak to avoid reference cycle between type and its initializers
    weak var returnType: Type?

    // sourcery: skipEquality
    // sourcery: skipDescription
    var isOptionalReturnType: Bool {
        return returnTypeName.isOptional || isFailableInitializer
    }

    // sourcery: skipEquality
    // sourcery: skipDescription
    var unwrappedReturnTypeName: String {
        return returnTypeName.unwrappedTypeName
    }

    /// Method access level
    let accessLevel: AccessLevel

    /// Whether this is a static method
    let isStatic: Bool

    /// Whether this is a class method
    let isClass: Bool

    /// Whether this is a constructor
    var isInitializer: Bool {
        return selectorName.hasPrefix("init(")
    }

    /// Whether this is a failable initializer
    let isFailableInitializer: Bool

    /// Annotations, that were created with // sourcery: annotation1, other = "annotation value", alterantive = 2
    let annotations: [String: NSObject]

    /// Underlying parser data, never to be used by anything else
    // sourcery: skipEquality, skipDescription
    internal var __parserData: Any?

    init(selectorName: String,
         parameters: [Parameter] = [],
         returnTypeName: String = "Void",
         accessLevel: AccessLevel = .internal,
         isStatic: Bool = false,
         isClass: Bool = false,
         isFailableInitializer: Bool = false,
         annotations: [String: NSObject] = [:]) {

        self.selectorName = selectorName
        self.parameters = parameters
        self.returnTypeName = TypeName(returnTypeName)
        self.accessLevel = accessLevel
        self.isStatic = isStatic
        self.isClass = isClass
        self.isFailableInitializer = isFailableInitializer
        self.annotations = annotations
    }

    // Method.NSCoding {
        required init?(coder aDecoder: NSCoder) {
             guard let selectorName: String = aDecoder.decode(forKey: "selectorName") else { return nil }; self.selectorName = selectorName
             guard let parameters: [Parameter] = aDecoder.decode(forKey: "parameters") else { return nil }; self.parameters = parameters
             guard let returnTypeName: TypeName = aDecoder.decode(forKey: "returnTypeName") else { return nil }; self.returnTypeName = returnTypeName

             guard let accessLevel: AccessLevel = aDecoder.decode(forKey: "accessLevel") else { return nil }; self.accessLevel = accessLevel
            self.isStatic = aDecoder.decodeBool(forKey: "isStatic")
            self.isClass = aDecoder.decodeBool(forKey: "isClass")
            self.isFailableInitializer = aDecoder.decodeBool(forKey: "isFailableInitializer")
             guard let annotations: [String: NSObject] = aDecoder.decode(forKey: "annotations") else { return nil }; self.annotations = annotations

        }

        func encode(with aCoder: NSCoder) {

            aCoder.encode(self.selectorName, forKey: "selectorName")
            aCoder.encode(self.parameters, forKey: "parameters")
            aCoder.encode(self.returnTypeName, forKey: "returnTypeName")
            aCoder.encode(self.accessLevel, forKey: "accessLevel")
            aCoder.encode(self.isStatic, forKey: "isStatic")
            aCoder.encode(self.isClass, forKey: "isClass")
            aCoder.encode(self.isFailableInitializer, forKey: "isFailableInitializer")
            aCoder.encode(self.annotations, forKey: "annotations")

        }
        // } Method.NSCoding
}
