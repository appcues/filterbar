define [
    'backbone'
], (Backbone) ->

    ###*
     * State manager for individuals filters.
    ###
    class Filterbar extends Backbone.View
        constructor: (options) ->
            @options = options

        render: ->
        remove: ->

        addFilter: (filter) ->
        removeFilter: (filter) ->
