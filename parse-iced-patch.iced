( ->

	promiseToIcedDeferral = (object, funcName) ->
		overridenFunc = object[funcName]
		newFunc = ->
			args = [].slice.call arguments
			cb = args.pop()
			promise = overridenFunc.apply this, args
			promise.then (result) ->
				cb result, undefined
			, (error) ->
				cb undefined, error
		object[funcName+'X'] = newFunc

	optionsToIcedDeferral = (object, funcName) ->
		overridenFunc = object[funcName]
		newFunc = ->
			args = [].slice.call arguments
			cb = args.pop()

			options = undefined

			if args.length > 0
				options = args.pop()
				if options is undefined or options.constructor isnt Object
					# not an option hash, push it back
					args.push options
					options = undefined

			options = {} if options is undefined
			options.success = (result) ->
				cb result, undefined
			options.error = (error) ->
				cb undefined, error

			args.push options
			overridenFunc.apply this, args
		object[funcName+'X'] = newFunc


	['count', 'each', 'find', 'first'].forEach (funcName) ->
		promiseToIcedDeferral Parse.Query.prototype, funcName

	['destroy', 'fetch', 'save'].forEach (funcName) ->
		promiseToIcedDeferral Parse.Object.prototype, funcName

	['destroyAll'].forEach (funcName) ->
		promiseToIcedDeferral Parse.Object, funcName

	['get'].forEach (funcName) ->
		optionsToIcedDeferral Parse.Query.prototype, funcName

	['saveAll'].forEach (funcName) ->
		optionsToIcedDeferral Parse.Object, funcName

)()