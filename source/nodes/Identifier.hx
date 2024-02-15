package source.nodes;

class Identifier extends Node {
	public var value: String;
	public function new(value: String) {
		this.value = value;
	}

	public function string(): String {
		return 'Identifier { value: ${this.value} }';
	}
}