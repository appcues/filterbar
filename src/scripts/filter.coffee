define [
    'backbone'
], (Backbone) ->

    ###*
     * Individual filter.
    ###
    class Filter extends Backbone.View
        constructor: (options) ->
            @options = options

        render: ->
        remove: ->
