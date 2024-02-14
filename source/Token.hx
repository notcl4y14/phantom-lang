package source;

class Token {
	public var type: TokenType;
	public var value: Any;
	public var pos: Array<Position>;

	public function new(type: TokenType, value: Any = null, ?pos: Array<Position>) {
		this.type = type;
		this.value = value;
		this.pos = pos;
	}

	///////////////////////

	public function matches(type: TokenType, value: Any): Bool {
		return this.type == type && this.value == value;
	}

	public function string(tab: Bool = false): String {
		var value = this.value;
		if (Std.isOfType(value, String)) value = '"${value}"';
		if (tab) return 'Token { type: ${this.type},	value: ${value} }';
		return 'Token { type: ${this.type}, value: ${value} }';
	}
}