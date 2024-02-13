package source;

class Token {
	public var type: TokenType;
	public var value: Any;

	public function new(type: TokenType, value: Any = null) {
		this.type = type;
		this.value = value;
	}

	///////////////////////

	public function matches(type: TokenType, value: Any): Bool {
		return this.type == type && this.value == value;
	}

	public function string(tab: Bool = true): String {
		var value = this.value;
		if (Std.isOfType(value, String)) value = '"${value}"';
		if (tab) return 'Token { type: ${this.type},	value: ${value} }';
		return 'Token { type: ${this.type}, value: ${value} }';
	}
}