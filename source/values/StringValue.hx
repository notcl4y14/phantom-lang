package source.values;

class StringValue extends Value {
	public function new(value: String) {
		this.type = "string";
		this.value = value;
	}

	public function operation(op: String, value: Value): Null<Value> {
		var result: String = "";
		var value1: String = cast(this.value, String);
		var value2: String = cast(value.value, String);

		if (!(value is StringValue)) {
			return null;
		}
		
		switch (op) {
			case "+": result = value1 + value2;
			default: return null;
		}

		return new StringValue(result);
	}

	public function string(): String {
		return 'StringValue { value: "${this.value}" }';
	}
}