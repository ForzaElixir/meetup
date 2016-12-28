# Merry Christmas edition

In this meetup, we mostly [mob-programmed](https://en.wikipedia.org/wiki/Mob_programming) some small exercises from [exercism.io](http://exercism.io).

One that many found particularly interesting was "Bracket push": in this exercise, we had to write a program (or function in our case) that determined if a given string input contained brackets that were balanced and nested correctly. For example, `"{([]{})}"` would pass this test, while `"{{}}}"` would not.

We wrote a solution in Elixir that takes advantage of compile-time code generation, and it looks like this:

```elixir
defmodule BracketPush do
  @matching_parens [
    {"{", "}"},
    {"[", "]"},
    {"(", ")"},
  ]

  @doc """
  Checks that all the brackets and braces in the string are matched and nested correctly.
  """
  @spec check_brackets(String.t) :: boolean
  def check_brackets(str) do
    str
    |> String.codepoints()
    |> check_brackets([])
  end

  for {opening, closing} <- @matching_parens do
    # We push in the stack if we find an opening parens
    defp check_brackets([opening = unquote(opening) | rest], stack),
      do: check_brackets(rest, [opening | stack])
    # We pop from the stack if we find a closing parens that matches the opening
    # parens on top of the stack
    defp check_brackets([unquote(closing) | rest], [unquote(opening) | rest_of_stack]),
      do: check_brackets(rest, rest_of_stack)
    # We fail if we find a closing parens that does not match the top of the
    # stack
    defp check_brackets([unquote(closing) | _rest], _stack),
      do: false
  end

  # We ignore all non-brackets codepoints
  defp check_brackets([_codepoint | rest], stack),
    do: check_brackets(rest, stack)

  # If we consumed all input, then brackets were balanced only if there are none
  # left in the stack.
  defp check_brackets([], stack),
    do: stack == []
end
```

Then, a few participants of the meetup came up with solutions in other languages as well. We had a version in C:

```c
bool matching_parens(char *text) {
    char *parens = "([{)]}";
    char *end_parens = &parens[3];

    char stack[255];
    int stack_i = 0;

    for (int i = 0; i < strlen(text); i++) {
        char *matched_paren = strchr(parens, text[i]);
        if (matched_paren && matched_paren < end_parens) {
            stack[stack_i++] = *matched_paren;
        } else if (matched_paren && (stack_i == 0 || stack[--stack_i] != matched_paren[-3])) {
            return false;
        }
    }

    return stack_i == 0;
}
```

A version in Swift:

```swift
let openers = ["{", "[", "("].map(Character.init)
let closers = ["}", "]", ")"].map(Character.init)

func checkMatchingParanthesis(_ input: String) -> Bool {
    var stack: Array<Int> = []

    for char in input.characters {
        if let parenType = openers.index(of: char) {
            stack.append(parenType)
        } else if let parenType = closers.index(of: char), stack.popLast() != parenType {
            return false
        }
    }

    return stack.count == 0
}
```

A version in Erlang ([here](https://gist.github.com/jesperp/9ab60cddd3a3a50f4ecaf3df7e712959) are implementation and tests):

```erlang
-module(bracketpush).
-export([check_brackets/1]).

check_brackets(Str) ->
    check_brackets(Str, []).

% Base cases
check_brackets([], []) -> true;
check_brackets([], _Acc) -> false;

% Opening brackets
check_brackets([Bracket | Tail], Acc) when Bracket == ${ ; Bracket == $( ; Bracket == $[ ->
    check_brackets(Tail, [Bracket|Acc]);

% Closing brackets
check_brackets([Bracket | Tail], [Prev | Acc]) when
    Prev == $( andalso Bracket == $) ;
    Prev == $[ andalso Bracket == $] ;
    Prev == ${ andalso Bracket == $}
    -> check_brackets(Tail, Acc);
check_brackets([Bracket | _Tail], _Acc) when Bracket == $} ; Bracket == $) ; Bracket == $] ->
    false;

% Ignore other cases
check_brackets([_|Tail], Acc) -> check_brackets(Tail, Acc).
```
