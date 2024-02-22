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
			
			var expr = this.parse_expr();
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

	public function parse_expr() {
		return this.parse_compExpr();
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
		}

		throw new source.Error('Unexpected token "${token.value}"', token.pos);
	}
}