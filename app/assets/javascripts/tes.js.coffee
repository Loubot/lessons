typeaheadGo = ->
  bestPictures = new Bloodhound(
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace("name")
    queryTokenizer: Bloodhound.tokenizers.whitespace
    prefetch: "http://localhost:3000/subject-search"
  )
  bestPictures.initialize()
  $(".typeahead").typeahead null,
    name: "best-pictures"
    displayKey: "name"
    source: bestPictures.ttAdapter()

  return

$(document).ready(typeaheadGo)
$(document).on('page:load', typeaheadGo)