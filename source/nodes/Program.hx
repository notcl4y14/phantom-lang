package source.nodes;

class Program extends Node {
	public var body: Array<Node>;

	public function new() {
		this.body = [];
	}

	public function add(node: Node) {
		this.body.push(node);
	}

	public function string(): String {
		var body = [];
		for (node in this.body) body.push(node.string());
		return 'Program { body: ${body} }';
	}
}