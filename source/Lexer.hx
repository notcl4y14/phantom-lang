package source;

class Lexer {
	public var code: String;
	public var pos: Position;

	public function new(filename: String, code: String) {
		this.code = code;
		this.pos = new Position(filename, -1, 0, -1);

		this.yum();
	}

	///////////////////////

	public function at(range: Int = 1): String {
		if (range > 1) {
			return this.code.substr(this.pos.index, range);
		}
		
		return this.code.charAt(this.pos.index);
	}

	public function yum(delta: Int = 1): String {
		var prev = this.at();
		// this.pos += delta;
		this.pos.advance(this.at(), delta);
		return prev;
	}

	// public function yumRange(range: Int = 1): String {
	// 	var prev = this.at(range);
	// 	this.pos += range;
	// 	return prev;
	// }

	public function notEOF(): Bool {
		return this.pos.index < this.code.length;
	}

	///////////////////////

	public function lexerize(): Array<Token> {
		var tokens: Array<Token> = [];

		while (this.notEOF()) {
			var char = this.at();

			if (StringTools.contains(" \t\r\n", char)) {
				// Do nothing
			} else if ((["//", "/*"]).contains(this.at(2))) {
				tokens.push(this.lexerizeComment());
			} else if (StringTools.contains("+-*/%^=<>", char)) {
				tokens.push(new Token(TokenType.Operator, char, [this.pos.clone(), this.pos.clone().advance()]));
			} else if (StringTools.contains(".,:;!&|", char)) {
				tokens.push(new Token(TokenType.Symbol, char, [this.pos.clone(), this.pos.clone().advance()]));
			} else if (StringTools.contains("()[]{}", char)) {
				tokens.push(new Token(TokenType.Closure, char, [this.pos.clone(), this.pos.clone().advance()]));
			} else if (StringTools.contains("1234567890", char)) {
				tokens.push(this.lexerizeNumber());
			} else if (StringTools.contains("\"'", char)) {
				tokens.push(this.lexerizeString());
			} else {
				tokens.push(this.lexerizeIdentifier());
			}

			this.yum();
		}

		tokens.push(new Token(TokenType.EOF, null, [this.pos.clone(), this.pos.clone()]));

		return tokens;
	}

	public function lexerizeComment(): Token {
		var line = this.at(2) == "//";
		var token: Token;

		switch (line) {
			case true: token = this.lexerizeComment_line();
			case false: token = this.lexerizeComment_multiline();
		}

		return token;
	}

	public function lexerizeComment_line(): Token {
		var comStr: String = "";

		while (this.notEOF() && this.at() != "\n") {
			if (this.at() == "\r") break;
			comStr += this.yum();
		}

		return new Token(TokenType.Comment, comStr);
	}
	
	public function lexerizeComment_multiline(): Token {
		var leftPos: Position = this.pos.clone();
		var comStr: String = "";
		// var count: Int = 1;          // This is for multiline comment nesting

		// while (this.notEOF() && count <= 0) {
		while (this.notEOF() && this.at(2) != "*/") {
			// if (this.at(2) == "/*") {
			// 	count += 1;
			// 	comStr += this.yumRange(2);
			// 	continue;
			// } else if (this.at(2) == "*/") {
			// 	count -= 1;
			// 	comStr += this.yumRange(2);
			// 	continue;
			// }

			comStr += this.yum();
		}

		return new Token(TokenType.Comment, comStr, [leftPos, this.pos.clone()]);
	}

	public function lexerizeNumber(): Token {
		var leftPos: Position = this.pos.clone();
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

		var rightPos: Position = this.pos.clone();
		this.yum(-1);

		if (float) return new Token(TokenType.Number, Std.parseFloat(numStr));
		return new Token(TokenType.Number, Std.parseInt(numStr), [leftPos, rightPos]);
	}

	public function lexerizeString(): Token {
		var leftPos: Position = this.pos.clone();
		var str: String = "";
		var quote: String = this.yum();

		while (this.notEOF() && this.at() != quote) {
			str += this.yum();
		}

		return new Token(TokenType.String, str, [leftPos, this.pos.clone()]);
	}

	public function lexerizeIdentifier(): Token {
		var leftPos: Position = this.pos.clone();
		var identStr: String = "";

		while (this.notEOF() && !StringTools.contains(" \t\r\n+-*/%^=<>\\.,:;!&|()[]{}\"'", this.at())) {
			identStr += this.yum();
		}

		var rightPos: Position = this.pos.clone();
		this.yum(-1);

		// switch (identStr) {
		// 	case "let":
		// 	case "var":
		// 	case "if":
		// 	case "else":
		// 	case "for":
		// 	case "while":
		// 	case "function":
		// 		return new Token(TokenType.Keyword, identStr);
			
		// 	case "null":
		// 	case "true":
		// 	case "false":
		// 		return new Token(TokenType.Literal, identStr);
		// }

		if ((["let", "var", "if", "else", "for", "while", "function"].contains(identStr))) {
			return new Token(TokenType.Keyword, identStr, [leftPos, rightPos]);
		} else if ((["null", "true", "false"]).contains(identStr)) {
			return new Token(TokenType.Literal, identStr, [leftPos, rightPos]);
		}

		return new Token(TokenType.Identifier, identStr, [leftPos, rightPos]);
	}
}