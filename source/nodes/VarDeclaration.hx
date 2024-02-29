package source.nodes;

class VarDeclaration extends Node {
	public var ident: Identifier;
	public var value: Node;

	public function new(ident: Identifier, value: Any) {
		this.ident = ident;
		this.value = value;
	}

	public function string(): String {
		return 'VarDeclaration { ident: ${this.ident.string()}, value: ${this.value.string()} }';
	}
}