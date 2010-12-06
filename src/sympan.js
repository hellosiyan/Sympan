(function () {
var Sympan = (function(){

var Sympan = function(element_id) {
		return Sympan.fn.init(element_id);
	}

Sympan.fn = Sympan.prototype = {
	init: function(element_id) {
		var elem = window.document.getElementById(element_id);
		
		if ( !elem ) {
			return false;
		}
		
		this.elem = elem;
		return this;
	}
}

return window.Sympan = window.sympan = Sympan;
})();

(function() {
	// Unique id generator for new objects in the cache
	Sympan.uid = 0;
	
	Sympan.dataCache = {};
	
	Sympan.dataKey = "sympan" + Math.random();
	
	Sympan.data = function(elem, key, value) {
		var id;
		
		if( elem[Sympan.dataKey] === undefined) {
			id = elem[Sympan.dataKey] = ++Sympan.uid
		} else {
			id = elem[Sympan.dataKey];
		}
		
		if( Sympan.dataCache[id] === undefined ) {
			Sympan.dataCache[id] = {};
		}
		var cache = Sympan.dataCache[id];
		
		if( value !== undefined ) {
			cache[key] = value;
		}
		
		return cache[key];
	}
	
	Sympan.removeData = function(elem, key) {
		if( elem[Sympan.dataKey] === undefined) return;
		
		var id = elem[Sympan.dataKey];
		
		if( Sympan.dataCache[id] === undefined ) return;
		
		delete Sympan.dataCache[id][key];
	}
	
	Sympan.fn.data = function(key, value) {
		return Sympan.data(this.elem, key, value);
	}
	
	Sympan.fn.removeData = function(key) {
		return Sympan.removeData(this.elem, key);
	}
	
})()



})()
