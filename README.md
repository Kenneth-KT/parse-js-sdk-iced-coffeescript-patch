# Parse JS SDK IcedCoffeeScript Patch
A small patch that adds IcedCoffeeScript style deferral to Parse JS SDK.

## Usage
Compile `parse-iced-patch.iced` with IcedCoffeeScript compiler and include it after including Parse JS SDK.
You can use it in both Parse Cloud Code and browser client.

It wraps Parse JS SDK methods and generate `X` methods.
For example, to use `Parse.Object.saveAll()` with Iced syntax, you call `Parse.Object.saveAllX()`.

## Convertion
Conside this sample code which adds 100 to the field `stock` to all `Product` rows that having `stock == 0`:
### Original Code
```coffee
productQuery = new Parse.Query 'Product'
productQuery.equalTo 'stock', 0
productQuery.find
	success: (products) ->
		for product in products
			product.increment 'stock', 100
		Parse.Object.saveAll products,
			success: ->
				console.log 'Completed!'
			error: ->
				console.log 'Error!'
	error: (error) ->
		console.log 'Error!'
```
### After Convertion
```coffee
productQuery = new Parse.Query 'Product'
productQuery.equalTo 'stock', 0

await productQuery.findX defer products, error
return console.log 'Error!' if error?

for product in products
	product.increment 'stock', 100

await Parse.Object.saveAllX products, defer result, error
return console.log 'Error!' if error?

console.log 'Completed!'
```

## Methods Wrapped
* Parse.Query.prototype
  * count
  * each
  * find
  * first
  * get

* Parse.Object.prototype
  * destroy
  * fetch
  * save

* Parse.Object
  * destroyAll
  * saveAll
