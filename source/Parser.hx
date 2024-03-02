package source;

import haxe.Constraints.Function;
import source.nodes.*;

class Parser {
	public var tokens: Array<Token>;
	public var pos: Int;

	public function new(tokens: Array<Token>) {
		this.tokens = tokens;
		this.pos = -1;

		this.yum();
	}

	///////////////////////

	public function at(): Token {
		return this.tokens[this.pos];
	}

	public function yum(): Token {
		var prev = this.at();
		this.pos += 1;
		return prev;
	}

	public function yumIfThereIsOne(type: TokenType, value: Any): Null<Token> {
		var prev = this.at();

		if (prev.type != type || prev.value != value) {
			return null;
		}

		this.pos += 1;
		return prev;
	}

	public function notEOF(): Bool {
		return this.at().type != TokenType.EOF;
	}

	///////////////////////
	
	public function parse() {
		var program = new Program();

		while (this.notEOF()) {
			if (this.at().type == TokenType.Comment) {
				this.yum();
				continue;
			}
			
			var expr = this.parse_stmt();
			if (expr != null) program.add(expr);
		}

		return program;
	}
	
	///////////////////////

	public function parse_binaryExpr(ops: Array<String>, func: Function) {
		var left = func();

		while
			(this.notEOF() &&
			this.at().type == TokenType.Operator &&
			ops.contains(this.at().value))
		{
			var op = this.yum();
			var right = func();

			left = new BinaryExpr(left, op, right).setPos(left.pos[0], right.pos[1]);
		}

		return left;
	}

	///////////////////////

	public function parse_stmt(): Node {
		if (this.at().matches(TokenType.Keyword, "let")) {
			return this.parse_varDeclaration();
		}

		return this.parse_expr();
	}

	public function parse_varDeclaration(): Node {
		var keyword = this.yum();
		var ident = this.parse_primaryExpr();

		if (!(ident is Identifier)) {
			throw new Error("Expected an identifier", ident.pos);
		}

		if (!this.at().matches(TokenType.Operator, "=")) {
			var ident = cast (ident, Identifier);
	
			return new VarDeclaration(ident, new Literal("null"))
				.setPos(keyword.pos[0], this.at().pos[1]);
		}

		this.yum();

		var _ident = cast (ident, Identifier);
		var value = this.parse_expr();
		var semicolon = this.yumIfThereIsOne(TokenType.Symbol, ";");

		// var rightPos = (semicolon == null ? value : semicolon).pos[1];
		var rightPos = value.pos[1];

		if (semicolon != null) {
			rightPos = semicolon.pos[1];
		}

		return new VarDeclaration(_ident, value)
			.setPos(keyword.pos[0], rightPos);
	}

	///////////////////////

	public function parse_expr(): Node {
		return this.parse_assignmentExpr();
	}

	public function parse_assignmentExpr() {
		var left = this.parse_compExpr();

		if (this.at().type == TokenType.Operator && StringTools.contains(this.at().value, "=")) {
			var op = this.yum();
			var value = this.parse_expr();

			left = new VarAssignment(cast (left, Identifier), op, value).setPos(left.pos[0], value.pos[1]);
		}

		return left;
	}
	
	///////////////////////

	public function parse_compExpr() {
		return this.parse_binaryExpr(["<", ">", "==", "!=", "<=", ">="], this.parse_additiveExpr);
	}

	public function parse_additiveExpr() {
		return this.parse_binaryExpr(["+", "-"], this.parse_multExpr);
	}
	
	public function parse_multExpr() {
		return this.parse_binaryExpr(["*", "/", "%"], this.parse_powerExpr);
	}
	
	public function parse_powerExpr() {
		return this.parse_binaryExpr(["^"], this.parse_primaryExpr);
	}
	
	///////////////////////

	public function parse_primaryExpr(): Node {
		var token = this.yum();

		if (token.type == TokenType.Number) {
			return new NumericLiteral(token.value).setPos(token.pos[0], token.pos[1]);
		} else if (token.type == TokenType.String) {
			return new StringLiteral(token.value).setPos(token.pos[0], token.pos[1]);
		} else if (token.type == TokenType.Literal) {
			return new Literal(token.value).setPos(token.pos[0], token.pos[1]);
		} else if (token.type == TokenType.Identifier) {
			return new Identifier(token.value).setPos(token.pos[0], token.pos[1]);
		} else if
			(token.type == TokenType.Closure &&
			token.value == "(")
		{
			var value = this.parse_expr();

			if (!this.at().matches(TokenType.Closure, ")")) {
				throw new source.Error('Expected closing parenthesis', this.at().pos);
			}

			this.yum();

			return value;
		} else if (token.matches(TokenType.Symbol, ";")) {
			return null;
		}

		throw new source.Error('Unexpected token "${token.value}"', token.pos);
	}
}