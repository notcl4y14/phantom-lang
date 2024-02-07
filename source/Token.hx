package source;

class Token {
	public var type: TokenType;
	public var value: Any;

	public function new(type: TokenType, value: Any) {
		this.type = type;
		this.value = value;
	}

	public function matches(type: TokenType, value: Any): Bool {
		return this.type == type && this.value == value;
	}

	public function string(): String {
		return 'Token { type: ${this.type}, value: ${this.value} }';
	}
}