// Generated from FHIRPath.g4 by ANTLR 4.13.1
import Antlr4

/**
 * This interface defines a complete generic visitor for a parse tree produced
 * by {@link FHIRPathParser}.
 *
 * @param <T> The return type of the visit operation. Use {@link Void} for
 * operations with no return type.
 */
open class FHIRPathVisitor<T>: ParseTreeVisitor<T> {
	/**
	 * Visit a parse tree produced by the {@code indexerExpression}
	 * labeled alternative in {@link FHIRPathParser#expression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitIndexerExpression(_ ctx: FHIRPathParser.IndexerExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code polarityExpression}
	 * labeled alternative in {@link FHIRPathParser#expression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitPolarityExpression(_ ctx: FHIRPathParser.PolarityExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code additiveExpression}
	 * labeled alternative in {@link FHIRPathParser#expression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitAdditiveExpression(_ ctx: FHIRPathParser.AdditiveExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code multiplicativeExpression}
	 * labeled alternative in {@link FHIRPathParser#expression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitMultiplicativeExpression(_ ctx: FHIRPathParser.MultiplicativeExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code unionExpression}
	 * labeled alternative in {@link FHIRPathParser#expression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitUnionExpression(_ ctx: FHIRPathParser.UnionExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code orExpression}
	 * labeled alternative in {@link FHIRPathParser#expression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitOrExpression(_ ctx: FHIRPathParser.OrExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code andExpression}
	 * labeled alternative in {@link FHIRPathParser#expression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitAndExpression(_ ctx: FHIRPathParser.AndExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code membershipExpression}
	 * labeled alternative in {@link FHIRPathParser#expression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitMembershipExpression(_ ctx: FHIRPathParser.MembershipExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code inequalityExpression}
	 * labeled alternative in {@link FHIRPathParser#expression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitInequalityExpression(_ ctx: FHIRPathParser.InequalityExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code invocationExpression}
	 * labeled alternative in {@link FHIRPathParser#expression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitInvocationExpression(_ ctx: FHIRPathParser.InvocationExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code equalityExpression}
	 * labeled alternative in {@link FHIRPathParser#expression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitEqualityExpression(_ ctx: FHIRPathParser.EqualityExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code impliesExpression}
	 * labeled alternative in {@link FHIRPathParser#expression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitImpliesExpression(_ ctx: FHIRPathParser.ImpliesExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code termExpression}
	 * labeled alternative in {@link FHIRPathParser#expression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitTermExpression(_ ctx: FHIRPathParser.TermExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code typeExpression}
	 * labeled alternative in {@link FHIRPathParser#expression}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitTypeExpression(_ ctx: FHIRPathParser.TypeExpressionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code invocationTerm}
	 * labeled alternative in {@link FHIRPathParser#term}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitInvocationTerm(_ ctx: FHIRPathParser.InvocationTermContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code literalTerm}
	 * labeled alternative in {@link FHIRPathParser#term}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitLiteralTerm(_ ctx: FHIRPathParser.LiteralTermContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code externalConstantTerm}
	 * labeled alternative in {@link FHIRPathParser#term}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitExternalConstantTerm(_ ctx: FHIRPathParser.ExternalConstantTermContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code parenthesizedTerm}
	 * labeled alternative in {@link FHIRPathParser#term}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitParenthesizedTerm(_ ctx: FHIRPathParser.ParenthesizedTermContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code nullLiteral}
	 * labeled alternative in {@link FHIRPathParser#literal}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitNullLiteral(_ ctx: FHIRPathParser.NullLiteralContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code booleanLiteral}
	 * labeled alternative in {@link FHIRPathParser#literal}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitBooleanLiteral(_ ctx: FHIRPathParser.BooleanLiteralContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code stringLiteral}
	 * labeled alternative in {@link FHIRPathParser#literal}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitStringLiteral(_ ctx: FHIRPathParser.StringLiteralContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code numberLiteral}
	 * labeled alternative in {@link FHIRPathParser#literal}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitNumberLiteral(_ ctx: FHIRPathParser.NumberLiteralContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code dateTimeLiteral}
	 * labeled alternative in {@link FHIRPathParser#literal}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitDateTimeLiteral(_ ctx: FHIRPathParser.DateTimeLiteralContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code timeLiteral}
	 * labeled alternative in {@link FHIRPathParser#literal}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitTimeLiteral(_ ctx: FHIRPathParser.TimeLiteralContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code quantityLiteral}
	 * labeled alternative in {@link FHIRPathParser#literal}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitQuantityLiteral(_ ctx: FHIRPathParser.QuantityLiteralContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link FHIRPathParser#externalConstant}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitExternalConstant(_ ctx: FHIRPathParser.ExternalConstantContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code memberInvocation}
	 * labeled alternative in {@link FHIRPathParser#invocation}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitMemberInvocation(_ ctx: FHIRPathParser.MemberInvocationContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code functionInvocation}
	 * labeled alternative in {@link FHIRPathParser#invocation}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitFunctionInvocation(_ ctx: FHIRPathParser.FunctionInvocationContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code thisInvocation}
	 * labeled alternative in {@link FHIRPathParser#invocation}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitThisInvocation(_ ctx: FHIRPathParser.ThisInvocationContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code indexInvocation}
	 * labeled alternative in {@link FHIRPathParser#invocation}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitIndexInvocation(_ ctx: FHIRPathParser.IndexInvocationContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by the {@code totalInvocation}
	 * labeled alternative in {@link FHIRPathParser#invocation}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitTotalInvocation(_ ctx: FHIRPathParser.TotalInvocationContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link FHIRPathParser#function}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitFunction(_ ctx: FHIRPathParser.FunctionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link FHIRPathParser#paramList}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitParamList(_ ctx: FHIRPathParser.ParamListContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link FHIRPathParser#quantity}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitQuantity(_ ctx: FHIRPathParser.QuantityContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link FHIRPathParser#unit}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitUnit(_ ctx: FHIRPathParser.UnitContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link FHIRPathParser#dateTimePrecision}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitDateTimePrecision(_ ctx: FHIRPathParser.DateTimePrecisionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link FHIRPathParser#pluralDateTimePrecision}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitPluralDateTimePrecision(_ ctx: FHIRPathParser.PluralDateTimePrecisionContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link FHIRPathParser#typeSpecifier}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitTypeSpecifier(_ ctx: FHIRPathParser.TypeSpecifierContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link FHIRPathParser#qualifiedIdentifier}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitQualifiedIdentifier(_ ctx: FHIRPathParser.QualifiedIdentifierContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

	/**
	 * Visit a parse tree produced by {@link FHIRPathParser#identifier}.
	- Parameters:
	  - ctx: the parse tree
	- returns: the visitor result
	 */
	open func visitIdentifier(_ ctx: FHIRPathParser.IdentifierContext) -> T {
	 	fatalError(#function + " must be overridden")
	}

}