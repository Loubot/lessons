$(document).ready(function(){
  var countries = new Bloodhound({
datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
queryTokenizer: Bloodhound.tokenizers.whitespace,
limit: 10,
remote: 'http://localhost:3000/display-subjects',
prefetch: {

url: 'http://localhost:3000/display-subjects',

filter: function(list) {
return $.map(list, function(country) { return { name: country }; });
}
}
});
 
countries.initialize();
 

$('.typeahead').typeahead(null, {
name: 'countries',
displayKey: 'name',

source: countries.ttAdapter()

});
alert(countries.ttAdapter())
  });