import source.*;

class Main {

	public function outputResultToString(name: String, result: Array<Token>, lineWidth: Int = 40) {
		var strings: Array<String> = [];
		
		for (token in result) {
			strings.push(token.string());
		}

		this.outputResult(name, strings, lineWidth);
	}
	
	public function outputResult(name: String, result: Array<String>, lineWidth: Int = 40) {
		var topLineWidth = (lineWidth - (name.length + 1));

		Sys.print('${name} ');
		for (i in 0...topLineWidth) Sys.print("-");
		Sys.print("\n");

		for (str in result) Sys.println(str);
		for (i in 0...lineWidth) Sys.print("-");
		Sys.print("\n");
	}

	///////////////////////
	
	public function new() {
		// Sys.println("Hello World!");
		// var token = new Token(TokenType.Operator, "+");
		// Sys.println("Tokens ---------------------------------");
		// Sys.println(token.string());
		// Sys.println("----------------------------------------");
		// this.outputResult("Tokens", [token.string()]);
		var lexer = new Lexer("+-*/%^ 10 + 4 - 5");
		var tokens = lexer.lexerize();

		this.outputResultToString("Tokens", tokens);
	}

	static public function main() {
		new Main();
	}
}