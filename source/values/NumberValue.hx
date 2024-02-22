package source.values;

class NumberValue extends Value {
	// public var value: Float;
	public function new(value: Float) {
		this.type = "number";
		this.value = value;
	}

	public function operation(op: String, value: Value): Null<Value> {
		var result: Float = 0;
		var value1: Float = cast (this.value, Float);
		var value2: Float = cast (value.value, Float);

		if (!(value is NumberValue)) {
			return null;
		}
		
		switch (op) {
			case "+": result = value1 + value2;
			case "-": result = value1 - value2;
			case "*": result = value1 * value2;
			case "/": result = value1 / value2;
			case "%": result = value1 % value2;
			case "^": result = Math.pow(value1, value2);
		}

		return new NumberValue(result);
	}

	public function string(): String {
		return 'NumberValue { value: ${this.value} }';
	}
}