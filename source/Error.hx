package source;

class Error {
	public var details: String;
	public var pos: Array<Position>;
	
	public function new(details: String, pos: Array<Position>) {
		this.details = details;
		this.pos = pos;
	}

	public function string(): String {
		// This, is, Haxe Lang
		//////////
		// var leftPos = new Position("Unknown, what did you expect",0,0,0);
		// var rightPos = new Position("",0,0,0);

		// try { leftPos = this.pos[0]; }
		// catch (e) {}
		// try { rightPos = this.pos[1]; }
		// catch (e) {}
		//////////
		// Nvm
		
		var leftPos = this.pos[0];
		var rightPos = this.pos[1];

		var line = leftPos.line == rightPos.line
			? '${leftPos.line + 1}'
			: '${leftPos.line + 1}-${rightPos.line + 1}';

		var column = leftPos.column == rightPos.column
			? '${leftPos.column + 1}'
			: '${leftPos.column + 1}-${rightPos.column + 1}';
		
		return '${leftPos.filename}: ${line} : ${column} : ${this.details}';
	}
}