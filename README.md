# DiceExpression [![Build Status](https://travis-ci.org/marcoconti83/DiceExpression.svg?branch=master)](https://travis-ci.org/marcoconti83/DiceExpression)

A Swift library to simulate dice rolls, as in board games or pen-and-paper role playing games. Available as a framework for iOS and OSX, Carthage compatible.

## Example usage
```
do {
	let roll = try DiceExpression("3d6+20").roll()
	print("Result: \(roll.result)")
} catch {
	print("Invalid expression: \(error)")
}

```



