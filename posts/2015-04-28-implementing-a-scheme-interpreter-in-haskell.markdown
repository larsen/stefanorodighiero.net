---
title: Implementing a Scheme interpreter in Haskell
tags: haskell, scheme, interpreter
---

I started this project with a few goals in mind:

* Implement enough Scheme to assist a student following the
  examples in [The Little
  Schemer](https://mitpress.mit.edu/books/little-schemer)
* Understand what's the minimal Scheme core that *must* be
  implemented, and on the other hand how much can be defined in
  terms of these primitives
* Produce some stylistically sound Haskell code
* Learn more Haskell in the process

There's still work to do for the first three points, but I'm
definitely learning a lot.

## The implementation

My implementation is still a work in progress but I guess the core
won't be subject to radical changes, so here a quick review of its
main parts.

I'm following the design described in [Chapter
4](https://mitpress.mit.edu/sicp/full-text/book/book-Z-H-4.html#%_toc_start)
of [Structure and Interpretation of Computer
Programs](https://mitpress.mit.edu/sicp/): if you're familiar with the
book I'm sure you won't find anything new.

Types were the trickiest part to write -- at least for me -- so I'll
start from them.

### Types

A `Program` is a collection of `Form`s:

~~~~ {.haskell}
data Program = Program [Form]
~~~~

A `Form` can be either a `Definition` or an `Expression`:

~~~~ {.haskell}
data Form = FDef Definition | FExpr Expression
  deriving (Show)
~~~~

A `Definition` binds a `Symbol` (represented as a `String`) to an
`Expression`.

~~~~ {.haskell}
data Definition = Definition String Expression
  deriving (Show)
~~~~

`Expression`s are more complex and have many faces:

~~~~ {.haskell}
data Expression = Number Integer
                | Boolean Bool
                | Operator Char
                | Symbol String
                | Quote Expression
                | If Expression Expression Expression
                | Lambda Formals Expression
                | List [Expression]
                  deriving (Eq)
~~~~

### Eval/Apply

In order to perform something useful we must be able to evaluate
`Form`s. Evaluation happens in an `Environment`, which is a
mapping from `Symbol`s to `Expression`s.

~~~~ {.haskell}
data Environment = Environment (Map.Map String Expression)
                   deriving (Eq)
~~~~

In other words, the `Environment` tells us
what `Expression` we need to evaluate to know the value of a `Symbol`
(notice the recursive nature of this notion).

`eval` is the only function exported by the `Wiz.EvalApply` module.
It takes an `Environment` and a `Form`, and returns a pair composed by
a possibly new `Environment` and an `Expression` representing the
return value of the `Form`.

~~~~ {.haskell}
eval :: Form -> Environment -> (Environment, Maybe Expression)
eval form env =
  case form of
    FDef def   -> (evalDefinition def env, Nothing)
    FExpr expr -> (env, Just $ evalExpr env expr)
~~~~

Evaluating a `Definition` adds a new mapping in the
`Environment`. It's the only thing that produces a side-ezffect,
namely a variation in the `Environment` in which we'll evaluate
future forms.

~~~~ {.haskell}
evalDefinition :: Definition -> Environment -> Environment
evalDefinition (Definition symbol expr) (Environment env) =
  Environment (Map.insert symbol expr env)
~~~~

Evaluating an `Expression` yields another simpler `Expression`, until
we reach an atomic value (so far they are `Number`s, `Boolean`s and
procedures) that we are able to display.

~~~~ {.haskell}
evalExpr :: Environment -> Expression -> Expression
~~~~

A special case is evaluating a procedure application (e.g. `(fact
10)`).  Assuming `fact` refers (in the current `Environment`) to a
procedure, we invoke `apply`.

~~~~ {.haskell}
apply :: Environment -> Expression -> [Expression] -> Expression
~~~~

To `apply` (or invoke) a procedure we must evaluate its body in a new
fabricated enviroment based on the original one but extended with
new symbols. These symbols are the formals parameters of the
procedure, their values are given by the expressions passed as
arguments in the procedure call.

~~~~ {.haskell}
apply env (Lambda (Formals formals) body) arguments =
  evalExpr env' body
  where env' = extendEnvironment env (zip formals evaledArguments)
        extendEnvironment (Environment env) newElems =
          Environment (Map.union (Map.fromList newElems) env)
        evaledArguments = map (evalExpr env) arguments
~~~~

### The main loop

After reading some Scheme code in `init.scm` to initialize the
environment, we enter the main loop (I'm in love with this idea of
building basic language utilities expressed in the language itself).

The main loop is relatively simple. It receives a new form from user
input (I used
[Haskeline](https://hackage.haskell.org/package/haskeline) to
implement the commandline), it parses it to obtain an internal
representation tree, and it `eval`s it. And so on.

## Some thoughts

As I said at the beginning my main goal is to learn: there's plenty of
Scheme implementations already, and many are written in Haskell. In
that respect designing and writing the interpreter has been so far
very rewarding. It's my first "real" Haskell program, and although
there are parts I want to reconsider profoundly (the parser
implementation is difficult to maintain, aesthetically orrible and in
a word suboptimal, to say the least) I am satisfied with the results.

Reasoning about types was difficult at the beginning: I expected that
but I didn't foresee all the false starts I had to discard before
arriving at something reasonable and working. Now that I'm more
proficient I experimented their immense usefulness for refactoring,
and generally speaking for reasoning about the program.

## Todo

There surely are many things yet to be done: `let`, `define-syntax`, a
certain dose of I/O functions (I'm curious about the changes they will
require in the core!), proper testing, debugging aids… just to name a
few. But one particular idea I have in mind is implementing some sort
of graphical primitives in the language in order to obtain a system
useful to experiment with geometry.
