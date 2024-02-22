package source.values;

class NullValue extends Value {
	public function new() {
		this.type = "null";
		this.value = null;
	}

	public function operation(op: String, value: Value): Null<Value> {
		return null;
	}

	public function string(): String {
		return 'NullLiteral { value: ${this.value} }';
	}
}