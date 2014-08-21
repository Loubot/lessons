$(document).ready(function(){
  var bestPictures = new Bloodhound({
datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
queryTokenizer: Bloodhound.tokenizers.whitespace,
prefetch: 'http://localhost:3000/display-subjects'
});
 
bestPictures.initialize();
 
$('.typeahead').typeahead(null, {
  name: 'best-pictures',
displayKey: 'name',
source: bestPictures.ttAdapter()
});
  });