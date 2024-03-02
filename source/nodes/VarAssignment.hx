package source.nodes;

class VarAssignment extends Node {
	// TODO: change Identifier to Node
	public var varname: Identifier;
	public var op: Token;
	public var value: Node;

	public function new(varname: Identifier, op: Token, value: Any) {
		this.varname = varname;
		this.op = op;
		this.value = value;
	}

	public function string(): String {
		return 'VarAssignment { varname: ${this.varname.string()}, op: ${this.op.string()}, value: ${this.value.string()} }';
	}
}