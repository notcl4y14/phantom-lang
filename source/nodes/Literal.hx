package source.nodes;

class Literal extends Node {
	public var value: String;
	public function new(value: String) {
		this.value = value;
	}

	public function string(): String {
		return 'Literal { value: ${this.value} }';
	}
}