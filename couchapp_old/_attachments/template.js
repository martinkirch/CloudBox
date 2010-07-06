// Simple JavaScript Templating
// John Resig - http://ejohn.org/ - MIT Licensed

// I did a little variant to use named templates - Martin Kirchgessner

var cache = {};

var templates = {
	"songRow" : "<tr class='song' id='song_<%= id %>'>\
			<td class='artist'><%= artist %></td>\
			<td class='title'><%= title %></td>\
		</tr>\n",	
}


function template(name, data){
	if(!templates[name]) return;
	
  // Figure out if we're getting a template, or if we need to
  // load the template - and be sure to cache the result.
  var fn = cache[name] ||

  // Generate a reusable function that will serve as a template
  // generator (and which will be cached).
    new Function("obj",
      "var p=[],print=function(){p.push.apply(p,arguments);};" +
          
            // Introduce the data as local variables using with(){}
            "with(obj){p.push('" +
          
            // Convert the template into pure JavaScript
            templates[name]
            .replace(/\n/g, "\\n")
            .replace(/[\r\t]/g, " ")
            .replace(/'(?=[^%]*%>)/g,"\t")
            .split("'").join("\\'")
            .split("\t").join("'")
            .replace(/<%=(.+?)%>/g, "',$1,'")
            .split("<%").join("');")
            .split("%>").join("p.push('")
            + "');}return p.join('');");
  cache[name] = fn;
  
  // Provide some basic currying to the user
  return data ? fn( data ) : fn;
};