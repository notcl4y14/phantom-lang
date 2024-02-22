package source.nodes;

abstract class Node {
	public var pos: Array<Position> = [];

	public function setPos(left: Position, right: Position) {
		this.pos[0] = left;
		this.pos[1] = right;

		return this;
	}

	public abstract function string(): String;
}