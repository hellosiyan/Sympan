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

})()
