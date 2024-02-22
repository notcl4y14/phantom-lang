package source.values;

abstract class Value {
	public var type: String;
	public var value: Any;

	public abstract function operation(op: String, value: Value): Null<Any>;
	
	public abstract function string(): String;
}