package source.nodes;

class NumericLiteral extends Node {
	public var value: Float;

	public function new (value: Float) {
		this.value = value;
	}

	public function string(): String {
		return 'Number: { value: ${this.value} }';
	}
}