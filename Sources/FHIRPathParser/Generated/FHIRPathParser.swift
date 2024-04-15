// Generated from FHIRPath.g4 by ANTLR 4.13.1
import Antlr4

open class FHIRPathParser: Parser {

	internal static var _decisionToDFA: [DFA] = {
          var decisionToDFA = [DFA]()
          let length = FHIRPathParser._ATN.getNumberOfDecisions()
          for i in 0..<length {
            decisionToDFA.append(DFA(FHIRPathParser._ATN.getDecisionState(i)!, i))
           }
           return decisionToDFA
     }()

	internal static let _sharedContextCache = PredictionContextCache()

	public
	enum Tokens: Int {
		case EOF = -1, T__0 = 1, T__1 = 2, T__2 = 3, T__3 = 4, T__4 = 5, T__5 = 6, 
                 T__6 = 7, T__7 = 8, T__8 = 9, T__9 = 10, T__10 = 11, T__11 = 12, 
                 T__12 = 13, T__13 = 14, T__14 = 15, T__15 = 16, T__16 = 17, 
                 T__17 = 18, T__18 = 19, T__19 = 20, T__20 = 21, T__21 = 22, 
                 T__22 = 23, T__23 = 24, T__24 = 25, T__25 = 26, T__26 = 27, 
                 T__27 = 28, T__28 = 29, T__29 = 30, T__30 = 31, T__31 = 32, 
                 T__32 = 33, T__33 = 34, T__34 = 35, T__35 = 36, T__36 = 37, 
                 T__37 = 38, T__38 = 39, T__39 = 40, T__40 = 41, T__41 = 42, 
                 T__42 = 43, T__43 = 44, T__44 = 45, T__45 = 46, T__46 = 47, 
                 T__47 = 48, T__48 = 49, T__49 = 50, T__50 = 51, T__51 = 52, 
                 T__52 = 53, T__53 = 54, DATETIME = 55, TIME = 56, IDENTIFIER = 57, 
                 DELIMITEDIDENTIFIER = 58, STRING = 59, NUMBER = 60, WS = 61, 
                 COMMENT = 62, LINE_COMMENT = 63
	}

	public
	static let RULE_expression = 0, RULE_term = 1, RULE_literal = 2, RULE_externalConstant = 3, 
            RULE_invocation = 4, RULE_function = 5, RULE_paramList = 6, 
            RULE_quantity = 7, RULE_unit = 8, RULE_dateTimePrecision = 9, 
            RULE_pluralDateTimePrecision = 10, RULE_typeSpecifier = 11, 
            RULE_qualifiedIdentifier = 12, RULE_identifier = 13

	public
	static let ruleNames: [String] = [
		"expression", "term", "literal", "externalConstant", "invocation", "function", 
		"paramList", "quantity", "unit", "dateTimePrecision", "pluralDateTimePrecision", 
		"typeSpecifier", "qualifiedIdentifier", "identifier"
	]

	private static let _LITERAL_NAMES: [String?] = [
		nil, "'.'", "'['", "']'", "'+'", "'-'", "'*'", "'/'", "'div'", "'mod'", 
		"'&'", "'is'", "'as'", "'|'", "'<='", "'<'", "'>'", "'>='", "'='", "'~'", 
		"'!='", "'!~'", "'in'", "'contains'", "'and'", "'or'", "'xor'", "'implies'", 
		"'('", "')'", "'{'", "'}'", "'true'", "'false'", "'%'", "'$this'", "'$index'", 
		"'$total'", "','", "'year'", "'month'", "'week'", "'day'", "'hour'", "'minute'", 
		"'second'", "'millisecond'", "'years'", "'months'", "'weeks'", "'days'", 
		"'hours'", "'minutes'", "'seconds'", "'milliseconds'"
	]
	private static let _SYMBOLIC_NAMES: [String?] = [
		nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 
		nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 
		nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 
		nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "DATETIME", 
		"TIME", "IDENTIFIER", "DELIMITEDIDENTIFIER", "STRING", "NUMBER", "WS", 
		"COMMENT", "LINE_COMMENT"
	]
	public
	static let VOCABULARY = Vocabulary(_LITERAL_NAMES, _SYMBOLIC_NAMES)

	override open
	func getGrammarFileName() -> String { return "FHIRPath.g4" }

	override open
	func getRuleNames() -> [String] { return FHIRPathParser.ruleNames }

	override open
	func getSerializedATN() -> [Int] { return FHIRPathParser._serializedATN }

	override open
	func getATN() -> ATN { return FHIRPathParser._ATN }


	override open
	func getVocabulary() -> Vocabulary {
	    return FHIRPathParser.VOCABULARY
	}

	override public
	init(_ input:TokenStream) throws {
	    RuntimeMetaData.checkVersion("4.13.1", RuntimeMetaData.VERSION)
		try super.init(input)
		_interp = ParserATNSimulator(self,FHIRPathParser._ATN,FHIRPathParser._decisionToDFA, FHIRPathParser._sharedContextCache)
	}



	public class ExpressionContext: ParserRuleContext {
		override open
		func getRuleIndex() -> Int {
			return FHIRPathParser.RULE_expression
		}
	}
	public class IndexerExpressionContext: ExpressionContext {
			open
			func expression() -> [ExpressionContext] {
				return getRuleContexts(ExpressionContext.self)
			}
			open
			func expression(_ i: Int) -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, i)
			}

		public
		init(_ ctx: ExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitIndexerExpression(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitIndexerExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class PolarityExpressionContext: ExpressionContext {
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}

		public
		init(_ ctx: ExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitPolarityExpression(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitPolarityExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class AdditiveExpressionContext: ExpressionContext {
			open
			func expression() -> [ExpressionContext] {
				return getRuleContexts(ExpressionContext.self)
			}
			open
			func expression(_ i: Int) -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, i)
			}

		public
		init(_ ctx: ExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitAdditiveExpression(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitAdditiveExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class MultiplicativeExpressionContext: ExpressionContext {
			open
			func expression() -> [ExpressionContext] {
				return getRuleContexts(ExpressionContext.self)
			}
			open
			func expression(_ i: Int) -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, i)
			}

		public
		init(_ ctx: ExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitMultiplicativeExpression(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitMultiplicativeExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class UnionExpressionContext: ExpressionContext {
			open
			func expression() -> [ExpressionContext] {
				return getRuleContexts(ExpressionContext.self)
			}
			open
			func expression(_ i: Int) -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, i)
			}

		public
		init(_ ctx: ExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitUnionExpression(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitUnionExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class OrExpressionContext: ExpressionContext {
			open
			func expression() -> [ExpressionContext] {
				return getRuleContexts(ExpressionContext.self)
			}
			open
			func expression(_ i: Int) -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, i)
			}

		public
		init(_ ctx: ExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitOrExpression(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitOrExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class AndExpressionContext: ExpressionContext {
			open
			func expression() -> [ExpressionContext] {
				return getRuleContexts(ExpressionContext.self)
			}
			open
			func expression(_ i: Int) -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, i)
			}

		public
		init(_ ctx: ExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitAndExpression(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitAndExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class MembershipExpressionContext: ExpressionContext {
			open
			func expression() -> [ExpressionContext] {
				return getRuleContexts(ExpressionContext.self)
			}
			open
			func expression(_ i: Int) -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, i)
			}

		public
		init(_ ctx: ExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitMembershipExpression(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitMembershipExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class InequalityExpressionContext: ExpressionContext {
			open
			func expression() -> [ExpressionContext] {
				return getRuleContexts(ExpressionContext.self)
			}
			open
			func expression(_ i: Int) -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, i)
			}

		public
		init(_ ctx: ExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitInequalityExpression(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitInequalityExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class InvocationExpressionContext: ExpressionContext {
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
			open
			func invocation() -> InvocationContext? {
				return getRuleContext(InvocationContext.self, 0)
			}

		public
		init(_ ctx: ExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitInvocationExpression(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitInvocationExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class EqualityExpressionContext: ExpressionContext {
			open
			func expression() -> [ExpressionContext] {
				return getRuleContexts(ExpressionContext.self)
			}
			open
			func expression(_ i: Int) -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, i)
			}

		public
		init(_ ctx: ExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitEqualityExpression(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitEqualityExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class ImpliesExpressionContext: ExpressionContext {
			open
			func expression() -> [ExpressionContext] {
				return getRuleContexts(ExpressionContext.self)
			}
			open
			func expression(_ i: Int) -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, i)
			}

		public
		init(_ ctx: ExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitImpliesExpression(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitImpliesExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class TermExpressionContext: ExpressionContext {
			open
			func term() -> TermContext? {
				return getRuleContext(TermContext.self, 0)
			}

		public
		init(_ ctx: ExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitTermExpression(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitTermExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class TypeExpressionContext: ExpressionContext {
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
			open
			func typeSpecifier() -> TypeSpecifierContext? {
				return getRuleContext(TypeSpecifierContext.self, 0)
			}

		public
		init(_ ctx: ExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitTypeExpression(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitTypeExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}

	 public final  func expression( ) throws -> ExpressionContext   {
		return try expression(0)
	}
	@discardableResult
	private func expression(_ _p: Int) throws -> ExpressionContext   {
		let _parentctx: ParserRuleContext? = _ctx
		let _parentState: Int = getState()
		var _localctx: ExpressionContext
		_localctx = ExpressionContext(_ctx, _parentState)
		var _prevctx: ExpressionContext = _localctx
        _ = _prevctx // manual addition to silence compiler warning
		let _startState: Int = 0
		try enterRecursionRule(_localctx, 0, FHIRPathParser.RULE_expression, _p)
		var _la: Int = 0
		defer {
	    		try! unrollRecursionContexts(_parentctx)
	    }
		do {
			var _alt: Int
			try enterOuterAlt(_localctx, 1)
			setState(32)
			try _errHandler.sync(self)
			switch (FHIRPathParser.Tokens(rawValue: try _input.LA(1))!) {
			case .T__10:fallthrough
			case .T__11:fallthrough
			case .T__21:fallthrough
			case .T__22:fallthrough
			case .T__27:fallthrough
			case .T__29:fallthrough
			case .T__31:fallthrough
			case .T__32:fallthrough
			case .T__33:fallthrough
			case .T__34:fallthrough
			case .T__35:fallthrough
			case .T__36:fallthrough
			case .DATETIME:fallthrough
			case .TIME:fallthrough
			case .IDENTIFIER:fallthrough
			case .DELIMITEDIDENTIFIER:fallthrough
			case .STRING:fallthrough
			case .NUMBER:
				_localctx = TermExpressionContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx

				setState(29)
				try term()

				break
			case .T__3:fallthrough
			case .T__4:
				_localctx = PolarityExpressionContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx
				setState(30)
				_la = try _input.LA(1)
				if (!(_la == FHIRPathParser.Tokens.T__3.rawValue || _la == FHIRPathParser.Tokens.T__4.rawValue)) {
				try _errHandler.recoverInline(self)
				}
				else {
					_errHandler.reportMatch(self)
					try consume()
				}
				setState(31)
				try expression(11)

				break
			default:
				throw ANTLRException.recognition(e: NoViableAltException(self))
			}
			_ctx!.stop = try _input.LT(-1)
			setState(74)
			try _errHandler.sync(self)
			_alt = try getInterpreter().adaptivePredict(_input,2,_ctx)
			while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
				if ( _alt==1 ) {
					if _parseListeners != nil {
					   try triggerExitRuleEvent()
					}
					_prevctx = _localctx
					setState(72)
					try _errHandler.sync(self)
					switch(try getInterpreter().adaptivePredict(_input,1, _ctx)) {
					case 1:
						_localctx = MultiplicativeExpressionContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, FHIRPathParser.RULE_expression)
						setState(34)
						if (!(precpred(_ctx, 10))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 10)"))
						}
						setState(35)
						_la = try _input.LA(1)
						if (!(((Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 960) != 0))) {
						try _errHandler.recoverInline(self)
						}
						else {
							_errHandler.reportMatch(self)
							try consume()
						}
						setState(36)
						try expression(11)

						break
					case 2:
						_localctx = AdditiveExpressionContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, FHIRPathParser.RULE_expression)
						setState(37)
						if (!(precpred(_ctx, 9))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 9)"))
						}
						setState(38)
						_la = try _input.LA(1)
						if (!(((Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 1072) != 0))) {
						try _errHandler.recoverInline(self)
						}
						else {
							_errHandler.reportMatch(self)
							try consume()
						}
						setState(39)
						try expression(10)

						break
					case 3:
						_localctx = UnionExpressionContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, FHIRPathParser.RULE_expression)
						setState(40)
						if (!(precpred(_ctx, 7))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 7)"))
						}
						setState(41)
						try match(FHIRPathParser.Tokens.T__12.rawValue)
						setState(42)
						try expression(8)

						break
					case 4:
						_localctx = InequalityExpressionContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, FHIRPathParser.RULE_expression)
						setState(43)
						if (!(precpred(_ctx, 6))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 6)"))
						}
						setState(44)
						_la = try _input.LA(1)
						if (!(((Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 245760) != 0))) {
						try _errHandler.recoverInline(self)
						}
						else {
							_errHandler.reportMatch(self)
							try consume()
						}
						setState(45)
						try expression(7)

						break
					case 5:
						_localctx = EqualityExpressionContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, FHIRPathParser.RULE_expression)
						setState(46)
						if (!(precpred(_ctx, 5))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 5)"))
						}
						setState(47)
						_la = try _input.LA(1)
						if (!(((Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 3932160) != 0))) {
						try _errHandler.recoverInline(self)
						}
						else {
							_errHandler.reportMatch(self)
							try consume()
						}
						setState(48)
						try expression(6)

						break
					case 6:
						_localctx = MembershipExpressionContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, FHIRPathParser.RULE_expression)
						setState(49)
						if (!(precpred(_ctx, 4))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 4)"))
						}
						setState(50)
						_la = try _input.LA(1)
						if (!(_la == FHIRPathParser.Tokens.T__21.rawValue || _la == FHIRPathParser.Tokens.T__22.rawValue)) {
						try _errHandler.recoverInline(self)
						}
						else {
							_errHandler.reportMatch(self)
							try consume()
						}
						setState(51)
						try expression(5)

						break
					case 7:
						_localctx = AndExpressionContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, FHIRPathParser.RULE_expression)
						setState(52)
						if (!(precpred(_ctx, 3))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 3)"))
						}
						setState(53)
						try match(FHIRPathParser.Tokens.T__23.rawValue)
						setState(54)
						try expression(4)

						break
					case 8:
						_localctx = OrExpressionContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, FHIRPathParser.RULE_expression)
						setState(55)
						if (!(precpred(_ctx, 2))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 2)"))
						}
						setState(56)
						_la = try _input.LA(1)
						if (!(_la == FHIRPathParser.Tokens.T__24.rawValue || _la == FHIRPathParser.Tokens.T__25.rawValue)) {
						try _errHandler.recoverInline(self)
						}
						else {
							_errHandler.reportMatch(self)
							try consume()
						}
						setState(57)
						try expression(3)

						break
					case 9:
						_localctx = ImpliesExpressionContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, FHIRPathParser.RULE_expression)
						setState(58)
						if (!(precpred(_ctx, 1))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 1)"))
						}
						setState(59)
						try match(FHIRPathParser.Tokens.T__26.rawValue)
						setState(60)
						try expression(2)

						break
					case 10:
						_localctx = InvocationExpressionContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, FHIRPathParser.RULE_expression)
						setState(61)
						if (!(precpred(_ctx, 13))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 13)"))
						}
						setState(62)
						try match(FHIRPathParser.Tokens.T__0.rawValue)
						setState(63)
						try invocation()

						break
					case 11:
						_localctx = IndexerExpressionContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, FHIRPathParser.RULE_expression)
						setState(64)
						if (!(precpred(_ctx, 12))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 12)"))
						}
						setState(65)
						try match(FHIRPathParser.Tokens.T__1.rawValue)
						setState(66)
						try expression(0)
						setState(67)
						try match(FHIRPathParser.Tokens.T__2.rawValue)

						break
					case 12:
						_localctx = TypeExpressionContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, FHIRPathParser.RULE_expression)
						setState(69)
						if (!(precpred(_ctx, 8))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 8)"))
						}
						setState(70)
						_la = try _input.LA(1)
						if (!(_la == FHIRPathParser.Tokens.T__10.rawValue || _la == FHIRPathParser.Tokens.T__11.rawValue)) {
						try _errHandler.recoverInline(self)
						}
						else {
							_errHandler.reportMatch(self)
							try consume()
						}
						setState(71)
						try typeSpecifier()

						break
					default: break
					}
			 
				}
				setState(76)
				try _errHandler.sync(self)
				_alt = try getInterpreter().adaptivePredict(_input,2,_ctx)
			}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx;
	}

	public class TermContext: ParserRuleContext {
		override open
		func getRuleIndex() -> Int {
			return FHIRPathParser.RULE_term
		}
	}
	public class ExternalConstantTermContext: TermContext {
			open
			func externalConstant() -> ExternalConstantContext? {
				return getRuleContext(ExternalConstantContext.self, 0)
			}

		public
		init(_ ctx: TermContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitExternalConstantTerm(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitExternalConstantTerm(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class LiteralTermContext: TermContext {
			open
			func literal() -> LiteralContext? {
				return getRuleContext(LiteralContext.self, 0)
			}

		public
		init(_ ctx: TermContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitLiteralTerm(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitLiteralTerm(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class ParenthesizedTermContext: TermContext {
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}

		public
		init(_ ctx: TermContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitParenthesizedTerm(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitParenthesizedTerm(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class InvocationTermContext: TermContext {
			open
			func invocation() -> InvocationContext? {
				return getRuleContext(InvocationContext.self, 0)
			}

		public
		init(_ ctx: TermContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitInvocationTerm(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitInvocationTerm(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func term() throws -> TermContext {
		var _localctx: TermContext
		_localctx = TermContext(_ctx, getState())
		try enterRule(_localctx, 2, FHIRPathParser.RULE_term)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(84)
		 	try _errHandler.sync(self)
		 	switch (FHIRPathParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .T__10:fallthrough
		 	case .T__11:fallthrough
		 	case .T__21:fallthrough
		 	case .T__22:fallthrough
		 	case .T__34:fallthrough
		 	case .T__35:fallthrough
		 	case .T__36:fallthrough
		 	case .IDENTIFIER:fallthrough
		 	case .DELIMITEDIDENTIFIER:
		 		_localctx =  InvocationTermContext(_localctx);
		 		try enterOuterAlt(_localctx, 1)
		 		setState(77)
		 		try invocation()

		 		break
		 	case .T__29:fallthrough
		 	case .T__31:fallthrough
		 	case .T__32:fallthrough
		 	case .DATETIME:fallthrough
		 	case .TIME:fallthrough
		 	case .STRING:fallthrough
		 	case .NUMBER:
		 		_localctx =  LiteralTermContext(_localctx);
		 		try enterOuterAlt(_localctx, 2)
		 		setState(78)
		 		try literal()

		 		break

		 	case .T__33:
		 		_localctx =  ExternalConstantTermContext(_localctx);
		 		try enterOuterAlt(_localctx, 3)
		 		setState(79)
		 		try externalConstant()

		 		break

		 	case .T__27:
		 		_localctx =  ParenthesizedTermContext(_localctx);
		 		try enterOuterAlt(_localctx, 4)
		 		setState(80)
		 		try match(FHIRPathParser.Tokens.T__27.rawValue)
		 		setState(81)
		 		try expression(0)
		 		setState(82)
		 		try match(FHIRPathParser.Tokens.T__28.rawValue)

		 		break
		 	default:
		 		throw ANTLRException.recognition(e: NoViableAltException(self))
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class LiteralContext: ParserRuleContext {
		override open
		func getRuleIndex() -> Int {
			return FHIRPathParser.RULE_literal
		}
	}
	public class TimeLiteralContext: LiteralContext {
			open
			func TIME() -> TerminalNode? {
				return getToken(FHIRPathParser.Tokens.TIME.rawValue, 0)
			}

		public
		init(_ ctx: LiteralContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitTimeLiteral(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitTimeLiteral(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class NullLiteralContext: LiteralContext {

		public
		init(_ ctx: LiteralContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitNullLiteral(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitNullLiteral(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class DateTimeLiteralContext: LiteralContext {
			open
			func DATETIME() -> TerminalNode? {
				return getToken(FHIRPathParser.Tokens.DATETIME.rawValue, 0)
			}

		public
		init(_ ctx: LiteralContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitDateTimeLiteral(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitDateTimeLiteral(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class StringLiteralContext: LiteralContext {
			open
			func STRING() -> TerminalNode? {
				return getToken(FHIRPathParser.Tokens.STRING.rawValue, 0)
			}

		public
		init(_ ctx: LiteralContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitStringLiteral(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitStringLiteral(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class BooleanLiteralContext: LiteralContext {

		public
		init(_ ctx: LiteralContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitBooleanLiteral(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitBooleanLiteral(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class NumberLiteralContext: LiteralContext {
			open
			func NUMBER() -> TerminalNode? {
				return getToken(FHIRPathParser.Tokens.NUMBER.rawValue, 0)
			}

		public
		init(_ ctx: LiteralContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitNumberLiteral(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitNumberLiteral(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class QuantityLiteralContext: LiteralContext {
			open
			func quantity() -> QuantityContext? {
				return getRuleContext(QuantityContext.self, 0)
			}

		public
		init(_ ctx: LiteralContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitQuantityLiteral(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitQuantityLiteral(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func literal() throws -> LiteralContext {
		var _localctx: LiteralContext
		_localctx = LiteralContext(_ctx, getState())
		try enterRule(_localctx, 4, FHIRPathParser.RULE_literal)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(94)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,4, _ctx)) {
		 	case 1:
		 		_localctx =  NullLiteralContext(_localctx);
		 		try enterOuterAlt(_localctx, 1)
		 		setState(86)
		 		try match(FHIRPathParser.Tokens.T__29.rawValue)
		 		setState(87)
		 		try match(FHIRPathParser.Tokens.T__30.rawValue)

		 		break
		 	case 2:
		 		_localctx =  BooleanLiteralContext(_localctx);
		 		try enterOuterAlt(_localctx, 2)
		 		setState(88)
		 		_la = try _input.LA(1)
		 		if (!(_la == FHIRPathParser.Tokens.T__31.rawValue || _la == FHIRPathParser.Tokens.T__32.rawValue)) {
		 		try _errHandler.recoverInline(self)
		 		}
		 		else {
		 			_errHandler.reportMatch(self)
		 			try consume()
		 		}

		 		break
		 	case 3:
		 		_localctx =  StringLiteralContext(_localctx);
		 		try enterOuterAlt(_localctx, 3)
		 		setState(89)
		 		try match(FHIRPathParser.Tokens.STRING.rawValue)

		 		break
		 	case 4:
		 		_localctx =  NumberLiteralContext(_localctx);
		 		try enterOuterAlt(_localctx, 4)
		 		setState(90)
		 		try match(FHIRPathParser.Tokens.NUMBER.rawValue)

		 		break
		 	case 5:
		 		_localctx =  DateTimeLiteralContext(_localctx);
		 		try enterOuterAlt(_localctx, 5)
		 		setState(91)
		 		try match(FHIRPathParser.Tokens.DATETIME.rawValue)

		 		break
		 	case 6:
		 		_localctx =  TimeLiteralContext(_localctx);
		 		try enterOuterAlt(_localctx, 6)
		 		setState(92)
		 		try match(FHIRPathParser.Tokens.TIME.rawValue)

		 		break
		 	case 7:
		 		_localctx =  QuantityLiteralContext(_localctx);
		 		try enterOuterAlt(_localctx, 7)
		 		setState(93)
		 		try quantity()

		 		break
		 	default: break
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ExternalConstantContext: ParserRuleContext {
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			open
			func STRING() -> TerminalNode? {
				return getToken(FHIRPathParser.Tokens.STRING.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return FHIRPathParser.RULE_externalConstant
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitExternalConstant(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitExternalConstant(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func externalConstant() throws -> ExternalConstantContext {
		var _localctx: ExternalConstantContext
		_localctx = ExternalConstantContext(_ctx, getState())
		try enterRule(_localctx, 6, FHIRPathParser.RULE_externalConstant)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(96)
		 	try match(FHIRPathParser.Tokens.T__33.rawValue)
		 	setState(99)
		 	try _errHandler.sync(self)
		 	switch (FHIRPathParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .T__10:fallthrough
		 	case .T__11:fallthrough
		 	case .T__21:fallthrough
		 	case .T__22:fallthrough
		 	case .IDENTIFIER:fallthrough
		 	case .DELIMITEDIDENTIFIER:
		 		setState(97)
		 		try identifier()

		 		break

		 	case .STRING:
		 		setState(98)
		 		try match(FHIRPathParser.Tokens.STRING.rawValue)

		 		break
		 	default:
		 		throw ANTLRException.recognition(e: NoViableAltException(self))
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class InvocationContext: ParserRuleContext {
		override open
		func getRuleIndex() -> Int {
			return FHIRPathParser.RULE_invocation
		}
	}
	public class TotalInvocationContext: InvocationContext {

		public
		init(_ ctx: InvocationContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitTotalInvocation(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitTotalInvocation(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class ThisInvocationContext: InvocationContext {

		public
		init(_ ctx: InvocationContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitThisInvocation(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitThisInvocation(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class IndexInvocationContext: InvocationContext {

		public
		init(_ ctx: InvocationContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitIndexInvocation(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitIndexInvocation(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class FunctionInvocationContext: InvocationContext {
			open
			func function() -> FunctionContext? {
				return getRuleContext(FunctionContext.self, 0)
			}

		public
		init(_ ctx: InvocationContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitFunctionInvocation(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitFunctionInvocation(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class MemberInvocationContext: InvocationContext {
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}

		public
		init(_ ctx: InvocationContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitMemberInvocation(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitMemberInvocation(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func invocation() throws -> InvocationContext {
		var _localctx: InvocationContext
		_localctx = InvocationContext(_ctx, getState())
		try enterRule(_localctx, 8, FHIRPathParser.RULE_invocation)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(106)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,6, _ctx)) {
		 	case 1:
		 		_localctx =  MemberInvocationContext(_localctx);
		 		try enterOuterAlt(_localctx, 1)
		 		setState(101)
		 		try identifier()

		 		break
		 	case 2:
		 		_localctx =  FunctionInvocationContext(_localctx);
		 		try enterOuterAlt(_localctx, 2)
		 		setState(102)
		 		try function()

		 		break
		 	case 3:
		 		_localctx =  ThisInvocationContext(_localctx);
		 		try enterOuterAlt(_localctx, 3)
		 		setState(103)
		 		try match(FHIRPathParser.Tokens.T__34.rawValue)

		 		break
		 	case 4:
		 		_localctx =  IndexInvocationContext(_localctx);
		 		try enterOuterAlt(_localctx, 4)
		 		setState(104)
		 		try match(FHIRPathParser.Tokens.T__35.rawValue)

		 		break
		 	case 5:
		 		_localctx =  TotalInvocationContext(_localctx);
		 		try enterOuterAlt(_localctx, 5)
		 		setState(105)
		 		try match(FHIRPathParser.Tokens.T__36.rawValue)

		 		break
		 	default: break
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class FunctionContext: ParserRuleContext {
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			open
			func paramList() -> ParamListContext? {
				return getRuleContext(ParamListContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return FHIRPathParser.RULE_function
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitFunction(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitFunction(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func function() throws -> FunctionContext {
		var _localctx: FunctionContext
		_localctx = FunctionContext(_ctx, getState())
		try enterRule(_localctx, 10, FHIRPathParser.RULE_function)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(108)
		 	try identifier()
		 	setState(109)
		 	try match(FHIRPathParser.Tokens.T__27.rawValue)
		 	setState(111)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (((Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 2269814484132436016) != 0)) {
		 		setState(110)
		 		try paramList()

		 	}

		 	setState(113)
		 	try match(FHIRPathParser.Tokens.T__28.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ParamListContext: ParserRuleContext {
			open
			func expression() -> [ExpressionContext] {
				return getRuleContexts(ExpressionContext.self)
			}
			open
			func expression(_ i: Int) -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return FHIRPathParser.RULE_paramList
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitParamList(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitParamList(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func paramList() throws -> ParamListContext {
		var _localctx: ParamListContext
		_localctx = ParamListContext(_ctx, getState())
		try enterRule(_localctx, 12, FHIRPathParser.RULE_paramList)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(115)
		 	try expression(0)
		 	setState(120)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (_la == FHIRPathParser.Tokens.T__37.rawValue) {
		 		setState(116)
		 		try match(FHIRPathParser.Tokens.T__37.rawValue)
		 		setState(117)
		 		try expression(0)


		 		setState(122)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class QuantityContext: ParserRuleContext {
			open
			func NUMBER() -> TerminalNode? {
				return getToken(FHIRPathParser.Tokens.NUMBER.rawValue, 0)
			}
			open
			func unit() -> UnitContext? {
				return getRuleContext(UnitContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return FHIRPathParser.RULE_quantity
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitQuantity(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitQuantity(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func quantity() throws -> QuantityContext {
		var _localctx: QuantityContext
		_localctx = QuantityContext(_ctx, getState())
		try enterRule(_localctx, 14, FHIRPathParser.RULE_quantity)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(123)
		 	try match(FHIRPathParser.Tokens.NUMBER.rawValue)
		 	setState(125)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,9,_ctx)) {
		 	case 1:
		 		setState(124)
		 		try unit()

		 		break
		 	default: break
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class UnitContext: ParserRuleContext {
			open
			func dateTimePrecision() -> DateTimePrecisionContext? {
				return getRuleContext(DateTimePrecisionContext.self, 0)
			}
			open
			func pluralDateTimePrecision() -> PluralDateTimePrecisionContext? {
				return getRuleContext(PluralDateTimePrecisionContext.self, 0)
			}
			open
			func STRING() -> TerminalNode? {
				return getToken(FHIRPathParser.Tokens.STRING.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return FHIRPathParser.RULE_unit
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitUnit(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitUnit(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func unit() throws -> UnitContext {
		var _localctx: UnitContext
		_localctx = UnitContext(_ctx, getState())
		try enterRule(_localctx, 16, FHIRPathParser.RULE_unit)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(130)
		 	try _errHandler.sync(self)
		 	switch (FHIRPathParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .T__38:fallthrough
		 	case .T__39:fallthrough
		 	case .T__40:fallthrough
		 	case .T__41:fallthrough
		 	case .T__42:fallthrough
		 	case .T__43:fallthrough
		 	case .T__44:fallthrough
		 	case .T__45:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(127)
		 		try dateTimePrecision()

		 		break
		 	case .T__46:fallthrough
		 	case .T__47:fallthrough
		 	case .T__48:fallthrough
		 	case .T__49:fallthrough
		 	case .T__50:fallthrough
		 	case .T__51:fallthrough
		 	case .T__52:fallthrough
		 	case .T__53:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(128)
		 		try pluralDateTimePrecision()

		 		break

		 	case .STRING:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(129)
		 		try match(FHIRPathParser.Tokens.STRING.rawValue)

		 		break
		 	default:
		 		throw ANTLRException.recognition(e: NoViableAltException(self))
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class DateTimePrecisionContext: ParserRuleContext {
		override open
		func getRuleIndex() -> Int {
			return FHIRPathParser.RULE_dateTimePrecision
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitDateTimePrecision(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitDateTimePrecision(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func dateTimePrecision() throws -> DateTimePrecisionContext {
		var _localctx: DateTimePrecisionContext
		_localctx = DateTimePrecisionContext(_ctx, getState())
		try enterRule(_localctx, 18, FHIRPathParser.RULE_dateTimePrecision)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(132)
		 	_la = try _input.LA(1)
		 	if (!(((Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 140187732541440) != 0))) {
		 	try _errHandler.recoverInline(self)
		 	}
		 	else {
		 		_errHandler.reportMatch(self)
		 		try consume()
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class PluralDateTimePrecisionContext: ParserRuleContext {
		override open
		func getRuleIndex() -> Int {
			return FHIRPathParser.RULE_pluralDateTimePrecision
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitPluralDateTimePrecision(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitPluralDateTimePrecision(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func pluralDateTimePrecision() throws -> PluralDateTimePrecisionContext {
		var _localctx: PluralDateTimePrecisionContext
		_localctx = PluralDateTimePrecisionContext(_ctx, getState())
		try enterRule(_localctx, 20, FHIRPathParser.RULE_pluralDateTimePrecision)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(134)
		 	_la = try _input.LA(1)
		 	if (!(((Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 35888059530608640) != 0))) {
		 	try _errHandler.recoverInline(self)
		 	}
		 	else {
		 		_errHandler.reportMatch(self)
		 		try consume()
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class TypeSpecifierContext: ParserRuleContext {
			open
			func qualifiedIdentifier() -> QualifiedIdentifierContext? {
				return getRuleContext(QualifiedIdentifierContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return FHIRPathParser.RULE_typeSpecifier
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitTypeSpecifier(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitTypeSpecifier(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func typeSpecifier() throws -> TypeSpecifierContext {
		var _localctx: TypeSpecifierContext
		_localctx = TypeSpecifierContext(_ctx, getState())
		try enterRule(_localctx, 22, FHIRPathParser.RULE_typeSpecifier)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(136)
		 	try qualifiedIdentifier()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class QualifiedIdentifierContext: ParserRuleContext {
			open
			func identifier() -> [IdentifierContext] {
				return getRuleContexts(IdentifierContext.self)
			}
			open
			func identifier(_ i: Int) -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return FHIRPathParser.RULE_qualifiedIdentifier
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitQualifiedIdentifier(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitQualifiedIdentifier(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func qualifiedIdentifier() throws -> QualifiedIdentifierContext {
		var _localctx: QualifiedIdentifierContext
		_localctx = QualifiedIdentifierContext(_ctx, getState())
		try enterRule(_localctx, 24, FHIRPathParser.RULE_qualifiedIdentifier)
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	try enterOuterAlt(_localctx, 1)
		 	setState(138)
		 	try identifier()
		 	setState(143)
		 	try _errHandler.sync(self)
		 	_alt = try getInterpreter().adaptivePredict(_input,11,_ctx)
		 	while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 		if ( _alt==1 ) {
		 			setState(139)
		 			try match(FHIRPathParser.Tokens.T__0.rawValue)
		 			setState(140)
		 			try identifier()

		 	 
		 		}
		 		setState(145)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,11,_ctx)
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class IdentifierContext: ParserRuleContext {
			open
			func IDENTIFIER() -> TerminalNode? {
				return getToken(FHIRPathParser.Tokens.IDENTIFIER.rawValue, 0)
			}
			open
			func DELIMITEDIDENTIFIER() -> TerminalNode? {
				return getToken(FHIRPathParser.Tokens.DELIMITEDIDENTIFIER.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return FHIRPathParser.RULE_identifier
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? FHIRPathVisitor {
			    return visitor.visitIdentifier(self)
			}
			else if let visitor = visitor as? FHIRPathBaseVisitor {
			    return visitor.visitIdentifier(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func identifier() throws -> IdentifierContext {
		var _localctx: IdentifierContext
		_localctx = IdentifierContext(_ctx, getState())
		try enterRule(_localctx, 26, FHIRPathParser.RULE_identifier)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(146)
		 	_la = try _input.LA(1)
		 	if (!(((Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 432345564240156672) != 0))) {
		 	try _errHandler.recoverInline(self)
		 	}
		 	else {
		 		_errHandler.reportMatch(self)
		 		try consume()
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	override open
	func sempred(_ _localctx: RuleContext?, _ ruleIndex: Int,  _ predIndex: Int)throws -> Bool {
		switch (ruleIndex) {
		case  0:
			return try expression_sempred(_localctx?.castdown(ExpressionContext.self), predIndex)
	    default: return true
		}
	}
	private func expression_sempred(_ _localctx: ExpressionContext!,  _ predIndex: Int) throws -> Bool {
		switch (predIndex) {
		    case 0:return precpred(_ctx, 10)
		    case 1:return precpred(_ctx, 9)
		    case 2:return precpred(_ctx, 7)
		    case 3:return precpred(_ctx, 6)
		    case 4:return precpred(_ctx, 5)
		    case 5:return precpred(_ctx, 4)
		    case 6:return precpred(_ctx, 3)
		    case 7:return precpred(_ctx, 2)
		    case 8:return precpred(_ctx, 1)
		    case 9:return precpred(_ctx, 13)
		    case 10:return precpred(_ctx, 12)
		    case 11:return precpred(_ctx, 8)
		    default: return true
		}
	}

	static let _serializedATN:[Int] = [
		4,1,63,149,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,6,7,6,2,7,
		7,7,2,8,7,8,2,9,7,9,2,10,7,10,2,11,7,11,2,12,7,12,2,13,7,13,1,0,1,0,1,
		0,1,0,3,0,33,8,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,
		0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,
		1,0,1,0,1,0,1,0,1,0,1,0,1,0,5,0,73,8,0,10,0,12,0,76,9,0,1,1,1,1,1,1,1,
		1,1,1,1,1,1,1,3,1,85,8,1,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,3,2,95,8,2,1,
		3,1,3,1,3,3,3,100,8,3,1,4,1,4,1,4,1,4,1,4,3,4,107,8,4,1,5,1,5,1,5,3,5,
		112,8,5,1,5,1,5,1,6,1,6,1,6,5,6,119,8,6,10,6,12,6,122,9,6,1,7,1,7,3,7,
		126,8,7,1,8,1,8,1,8,3,8,131,8,8,1,9,1,9,1,10,1,10,1,11,1,11,1,12,1,12,
		1,12,5,12,142,8,12,10,12,12,12,145,9,12,1,13,1,13,1,13,0,1,0,14,0,2,4,
		6,8,10,12,14,16,18,20,22,24,26,0,12,1,0,4,5,1,0,6,9,2,0,4,5,10,10,1,0,
		14,17,1,0,18,21,1,0,22,23,1,0,25,26,1,0,11,12,1,0,32,33,1,0,39,46,1,0,
		47,54,3,0,11,12,22,23,57,58,167,0,32,1,0,0,0,2,84,1,0,0,0,4,94,1,0,0,0,
		6,96,1,0,0,0,8,106,1,0,0,0,10,108,1,0,0,0,12,115,1,0,0,0,14,123,1,0,0,
		0,16,130,1,0,0,0,18,132,1,0,0,0,20,134,1,0,0,0,22,136,1,0,0,0,24,138,1,
		0,0,0,26,146,1,0,0,0,28,29,6,0,-1,0,29,33,3,2,1,0,30,31,7,0,0,0,31,33,
		3,0,0,11,32,28,1,0,0,0,32,30,1,0,0,0,33,74,1,0,0,0,34,35,10,10,0,0,35,
		36,7,1,0,0,36,73,3,0,0,11,37,38,10,9,0,0,38,39,7,2,0,0,39,73,3,0,0,10,
		40,41,10,7,0,0,41,42,5,13,0,0,42,73,3,0,0,8,43,44,10,6,0,0,44,45,7,3,0,
		0,45,73,3,0,0,7,46,47,10,5,0,0,47,48,7,4,0,0,48,73,3,0,0,6,49,50,10,4,
		0,0,50,51,7,5,0,0,51,73,3,0,0,5,52,53,10,3,0,0,53,54,5,24,0,0,54,73,3,
		0,0,4,55,56,10,2,0,0,56,57,7,6,0,0,57,73,3,0,0,3,58,59,10,1,0,0,59,60,
		5,27,0,0,60,73,3,0,0,2,61,62,10,13,0,0,62,63,5,1,0,0,63,73,3,8,4,0,64,
		65,10,12,0,0,65,66,5,2,0,0,66,67,3,0,0,0,67,68,5,3,0,0,68,73,1,0,0,0,69,
		70,10,8,0,0,70,71,7,7,0,0,71,73,3,22,11,0,72,34,1,0,0,0,72,37,1,0,0,0,
		72,40,1,0,0,0,72,43,1,0,0,0,72,46,1,0,0,0,72,49,1,0,0,0,72,52,1,0,0,0,
		72,55,1,0,0,0,72,58,1,0,0,0,72,61,1,0,0,0,72,64,1,0,0,0,72,69,1,0,0,0,
		73,76,1,0,0,0,74,72,1,0,0,0,74,75,1,0,0,0,75,1,1,0,0,0,76,74,1,0,0,0,77,
		85,3,8,4,0,78,85,3,4,2,0,79,85,3,6,3,0,80,81,5,28,0,0,81,82,3,0,0,0,82,
		83,5,29,0,0,83,85,1,0,0,0,84,77,1,0,0,0,84,78,1,0,0,0,84,79,1,0,0,0,84,
		80,1,0,0,0,85,3,1,0,0,0,86,87,5,30,0,0,87,95,5,31,0,0,88,95,7,8,0,0,89,
		95,5,59,0,0,90,95,5,60,0,0,91,95,5,55,0,0,92,95,5,56,0,0,93,95,3,14,7,
		0,94,86,1,0,0,0,94,88,1,0,0,0,94,89,1,0,0,0,94,90,1,0,0,0,94,91,1,0,0,
		0,94,92,1,0,0,0,94,93,1,0,0,0,95,5,1,0,0,0,96,99,5,34,0,0,97,100,3,26,
		13,0,98,100,5,59,0,0,99,97,1,0,0,0,99,98,1,0,0,0,100,7,1,0,0,0,101,107,
		3,26,13,0,102,107,3,10,5,0,103,107,5,35,0,0,104,107,5,36,0,0,105,107,5,
		37,0,0,106,101,1,0,0,0,106,102,1,0,0,0,106,103,1,0,0,0,106,104,1,0,0,0,
		106,105,1,0,0,0,107,9,1,0,0,0,108,109,3,26,13,0,109,111,5,28,0,0,110,112,
		3,12,6,0,111,110,1,0,0,0,111,112,1,0,0,0,112,113,1,0,0,0,113,114,5,29,
		0,0,114,11,1,0,0,0,115,120,3,0,0,0,116,117,5,38,0,0,117,119,3,0,0,0,118,
		116,1,0,0,0,119,122,1,0,0,0,120,118,1,0,0,0,120,121,1,0,0,0,121,13,1,0,
		0,0,122,120,1,0,0,0,123,125,5,60,0,0,124,126,3,16,8,0,125,124,1,0,0,0,
		125,126,1,0,0,0,126,15,1,0,0,0,127,131,3,18,9,0,128,131,3,20,10,0,129,
		131,5,59,0,0,130,127,1,0,0,0,130,128,1,0,0,0,130,129,1,0,0,0,131,17,1,
		0,0,0,132,133,7,9,0,0,133,19,1,0,0,0,134,135,7,10,0,0,135,21,1,0,0,0,136,
		137,3,24,12,0,137,23,1,0,0,0,138,143,3,26,13,0,139,140,5,1,0,0,140,142,
		3,26,13,0,141,139,1,0,0,0,142,145,1,0,0,0,143,141,1,0,0,0,143,144,1,0,
		0,0,144,25,1,0,0,0,145,143,1,0,0,0,146,147,7,11,0,0,147,27,1,0,0,0,12,
		32,72,74,84,94,99,106,111,120,125,130,143
	]

	public
	static let _ATN = try! ATNDeserializer().deserialize(_serializedATN)
}
