package source.nodes;

class StringLiteral extends Node {
	public var value: String;
	public function new(value: String) {
		this.value = value;
	}

	public function string(): String {
		return 'StringLiteral { value: ${this.value} }';
	}
}