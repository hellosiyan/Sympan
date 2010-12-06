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


function _true() {
	return true;
}

function _false() {
	return false;
}

Sympan.Event = function(type) {
	// Create event without using the 'new' keyword
	if ( !this.preventDefault ) {
		return new Sympan.Event( type );
	}
	
	this.timestamp = (new Date()).getTime();
	this.type = type
};

Sympan.Event.prototype = {
	preventDefault: function() {
		this.isDefaultPrevented = _true;
	},
	stopPropagation: function() {
		this.isPropagationStopped = _true;
	},
	isDefaultPrevented: _false,
	isPropagationStopped: _false
};

(function() {
	Sympan.event = {
		add: function(elem, type, callback) {
			var events = Sympan.data(elem, "__event__");
			
			if( events === undefined ) {
				events = {}
			}
			
			if( events[type] === undefined ) {
				events[type] = []
			}
			
			events[type].push(callback);
			Sympan.data(elem, "__event__", events);
		},
		
		remove: function(elem, type, callback) {
			var events = Sympan.data(elem, "__event__");
			if( events === undefined || events[type] === undefined ) return;
			
			for ( i=0; i < events[type].length; i++ ) {
				if ( events[type][i] === callback ) {
					delete events[type][i]
					break;
				}
			}
		},
		
		trigger: function(elem, type) {
			var events = Sympan.data(elem, "__event__");
			if( events === undefined || events[type] === undefined ) return;
			
			var eventObject = Sympan.Event(type);
			
			eventObject.target = elem;
			eventObject.timestamp = (new Date()).getTime();
			
			for ( i=0; i < events[type].length && !eventObject.isPropagationStopped(); i++ ) {
				if ( events[type][i] && events[type][i](eventObject) === false ) {
					break;
				}
			}
		}
	}
	
	Sympan.registerEvent = function (event) {
		// Allow multiple event registration using " " as a separator
		var events = event.split(" ")
		
		if(events.length <= 1) {
			Sympan.fn[event] = function(callback) {
				if( callback ) {
					this.bind(event, callback);
				} else {
					this.trigger(event);
				}
			};
		} else {
			for ( i in events) {
				Sympan.registerEvent(events[i]);
			}
		}
	}
	
	
	Sympan.fn.bind = function(event, callback) {
		Sympan.event.add(this.elem, event, callback);
	}
	
	Sympan.fn.unbind = function(event, callback) {
		Sympan.event.remove(this.elem, event, callback);
	}
	
	Sympan.fn.trigger = function(event) {
		Sympan.event.trigger(this.elem, event);
	}
	
	Sympan.registerEvent('onPlay onStop onSeek');
})()

})()
