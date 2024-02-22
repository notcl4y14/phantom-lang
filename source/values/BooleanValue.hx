package source.values;

class BooleanValue extends Value {
	public function new(value: Bool) {
		this.type = "boolean";
		this.value = value;
	}

	public function operation(op: String, value: Value): Null<Value> {
		return null;
	}

	public function string(): String {
		return 'BooleanValue { value: ${this.value} }';
	}
}