###*
 * State manager for individuals filters.
###
class Filterbar extends Evented
    constructor: (options) ->
        @options = options

    render: ->
    remove: ->

    addFilter: (filter) ->
    removeFilter: (filter) ->


###*
 * Individual filter.
###
class Filter extends Evented
    constructor: (options) ->
        @options = options

    render: ->
    remove: ->


###*
 * Events object, lifted from Backbone.js.
 * @type {object}
###
Evented =
    on: (name, callback, context) ->
        if not eventsApi(@, 'on', name, [callback, context]) or not callback
            return @

        @_events ?= {}
        events = @_events[name] or (@_events[name] = [])
        events.push
            callback: callback
            context: context
            ctx: context or @

        return @

    off: (name, callback, context) ->
        if not @_events or not eventsApi(@, 'off', name, [callback, context])
            return @
        if not name and not callback and not context
            @_events = {}
            return @

        i = 0
        names = (if name then [name] else utils.keys(@_events))

        for name in names
            if events = @_events[name]
                @_events[name] = retain = []
                if callback or context
                    for ev in events
                        if (callback and callback isnt ev.callback and callback isnt ev.callback._callback) or (context and context isnt ev.context)
                            retain.push ev
                unless retain.length
                    delete @_events[name]

        return @

    trigger: (name, args...) ->
        return @ unless @_events
        return @ unless eventsApi(@, 'trigger', name, args)

        events = @_events[name]
        allEvents = @_events.all

        if events
            triggerEvents events, args
        if allEvents
            triggerEvents allEvents, arguments

        return @

# Regular expression used to split event strings.
eventSplitter = /\s+/

eventsApi = (obj, action, name, rest) ->
    return true unless name

    # Handle event maps.
    if typeof name is 'object'
        for key of name
            obj[action].apply obj, [key, name[key]].concat(rest)
        return false

    # Handle space separated event names.
    if eventSplitter.test(name)
        names = name.split(eventSplitter)
        for name in names
            obj[action].apply obj, [name].concat(rest)

        return false

    return true

triggerEvents = (events, args) ->
    i = -1
    l = events.length
    a1 = args[0]
    a2 = args[1]
    a3 = args[2]

    switch args.length
        when 0
            while ++i < l
                (ev = events[i]).callback.call ev.ctx
            return
        when 1
            while ++i < l
                (ev = events[i]).callback.call ev.ctx, a1
            return
        when 2
            while ++i < l
                (ev = events[i]).callback.call ev.ctx, a1, a2
            return
        when 3
            while ++i < l
                (ev = events[i]).callback.call ev.ctx, a1, a2, a3
            return
        else
            while ++i < l
                (ev = events[i]).callback.apply ev.ctx, args

utils =
    keys: Object.keys or (obj) ->
        if (obj isnt Object(obj))
            throw new TypeError('Invalid object')

        keys = []
        for key of obj
            if Object::hasOwnProperty.call(obj, key)
                keys.push(key)

        return keys
