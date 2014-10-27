// a simple mustache.js template loader originally designed for use in confluence

// this is where you define your template substitutions
var substitutions = {
        'foo': 'bar',
        'baz': 'candy {{foo}}',
};

// below this is the meat and can be pulled in separately
function bindReferences(mustache_vars) {
    // this is in polynomial time, feel free to improve it
    var i = 0;
    var unbound = Object.keys(mustache_vars);
    var passes = unbound.length;
    while (i < passes && unbound.length > 0) {
        var still_unbound = []
        unbound.forEach(function (key) {
            rendered = Mustache.render(mustache_vars[key], mustache_vars);
            if (mustache_vars[key] !== rendered) {
                still_unbound.push(key);
            }
            mustache_vars[key] = rendered;
        });
        unbound = still_unbound;
        i++;
    }
    return mustache_vars
}

window.onload = function(){
  substitutions = bindReferences(substitutions)
  // use {{foo}} for variables in most places, but this breaks links, so use __foo__ in links
  document.body.innerHTML = Mustache.render("{{=__ __=}}".concat(document.body.innerHTML), substitutions)
  document.body.innerHTML = Mustache.render(document.body.innerHTML, substitutions)
};