package source;

class Lexer {
	public var code: String;
	public var pos: Int;

	public function new(code: String) {
		this.code = code;
		this.pos = -1;

		this.yum();
	}

	///////////////////////

	public function at(): String {
		return this.code.charAt(this.pos);
	}

	public function yum(): String {
		var prev = this.at();
		this.pos += 1;
		return prev;
	}

	public function notEOF(): Bool {
		return this.pos < this.code.length;
	}

	///////////////////////

	public function lexerize(): Array<Token> {
		var tokens: Array<Token> = [];

		while (this.notEOF()) {
			var char = this.at();

			if (StringTools.contains("+-*/%^", char)) {
				tokens.push(new Token(TokenType.Operator, char));
			} else if (StringTools.contains("1234567890", char)) {
				tokens.push(this.lexerizeNumber());
			}

			this.yum();
		}

		return tokens;
	}

	public function lexerizeNumber(): Token {
		var numStr: String = "";
		var float: Bool = false;

		while (this.notEOF() && StringTools.contains("1234567890.", this.at())) {
			numStr += this.at();

			if (this.at() == ".") {
				if (float) break;
				float = true;
			}

			this.yum();
		}

		if (float) return new Token(TokenType.Number, Std.parseFloat(numStr));
		return new Token(TokenType.Number, Std.parseInt(numStr));
	}
}