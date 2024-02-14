package source.nodes;

class BinaryExpr extends Node {
	public var left: Node;
	public var op: Token;
	public var right: Node;

	public function new(left: Node, op: Token, right: Node) {
		this.left = left;
		this.op = op;
		this.right = right;
	}

	public function string(): String {
		// return 'BinaryExpr {\n\tleft: (${this.left.string()})\n\top: (${this.op.string()}), \n\tright: (${this.right.string()})\n}';
		return 'BinaryExpr { left: (${this.left.string()}), op: (${this.op.string()}), right: (${this.right.string()}) }';
	}
}