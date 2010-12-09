(function () {
var Sympan = (function(){

var Sympan = function(element_id) {
		return Sympan.fn.init(element_id);
	}

Sympan.fn = Sympan.prototype = {
	init: function(element_id) {
		var elem = window.document.getElementById(element_id);
		
		if ( !elem || !elem.tagName || elem.tagName.toLowerCase() != 'video' ) {
			// TODO: Allow 'audio', 'object' and 'href' tags
			return false;
		}
		
		this.elem = elem;
		this.bindDOMEvents();
		
		return this;
	}
}

return window.Sympan = window.sympan = Sympan;
})();

Sympan.extend = function() {
	var index, target = {}, data = {}
		
	if ( arguments.length == 1 && typeof this === 'object' ) {
		// Extend *this* with data given as first arg
		target = this;
		data = arguments[0];
	} else if ( arguments.length > 1 && typeof arguments[0] === 'object' && typeof arguments[1] === 'object' ) {
		// Extend the object given as first arg with data from the second arg
		target = arguments[0];
		data = arguments[1];
	}
	
	for ( index in data ) {
		if ( data[index] === undefined ) continue;
		target[index] = data[index];
	}
};

Sympan.each = function() {
	var index, target = {}, callback = function() {}
		
	if ( arguments.length == 1 && typeof this === 'function' ) {
		target = this;
		callback = arguments[0];
	} else if ( arguments.length > 1 && typeof arguments[0] === 'object' && typeof arguments[1] === 'function' ) {
		target = arguments[0];
		callback = arguments[1];
	}
	
	for ( index in target ) {
		if ( target[index] === undefined ) continue;
		if ( callback.call(target[index], index, target[index]) === false ) {
			break;			
		}
	}
};

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

})();


function _true() {
	return true;
};

function _false() {
	return false;
};

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
		
		trigger: function(elem, type, data) {
			var events = Sympan.data(elem, "__event__");
			if( events === undefined || events[type] === undefined ) return;
			
			var eventObject = Sympan.Event(type);
			
			eventObject.target = eventObject.currentTarget = elem;
			eventObject.timestamp = (new Date()).getTime();
			Sympan.extend(eventObject, data);
			
			for ( i=0; i < events[type].length && !eventObject.isPropagationStopped(); i++ ) {
				if ( events[type][i] && events[type][i].call(elem, eventObject) === false ) {
					break;
				}
			}
		}
	}
	
	Sympan.registerEvent = function () {
		var event = "", target = {};
		
		if ( arguments.length == 1 && typeof arguments[0] == 'string' ) {
			target = Sympan.fn;
			event = arguments[0];
		} else if( arguments.length == 2 && typeof arguments[0] == 'object' && typeof arguments[1] == 'string' ) {
			target = arguments[0];
			event = arguments[1];
		}
		
		// Allow multiple event registration using " " as a separator
		var events = event.split(" ")
		
		if(events.length <= 1) {
			// Implement the Event Dispatcher interface if not already done
			Sympan.each({
				bind: 'add',
				unbind: 'remove',
				trigger: 'trigger'
			}, function(public_method, event_method) {
				if( target[public_method] !== undefined ) {
					// Don't override exiting implementations
					return false;
				}
				target[public_method] = function(event, arg) {
					Sympan.event[event_method](this, event, arg);
				}
			});
		
			target[event] = function(callback) {
				if( callback ) {
					this.bind(event, callback);
				} else {
					this.trigger(event);
				}
				return this;
			};
		} else {
			for ( i in events) {
				Sympan.registerEvent(target, events[i]);
			}
		}
	}
	
	
	Sympan.fn.bind = function(event, callback) {
		Sympan.event.add(this.elem, event, callback);
	}
	
	Sympan.fn.unbind = function(event, callback) {
		Sympan.event.remove(this.elem, event, callback);
	}
	
	Sympan.fn.trigger = function(event, data) {
		Sympan.extend(data, {target: this});
		Sympan.event.trigger(this.elem, event, data);
	}
	
	Sympan.registerEvent('onPlay onPause onProgress onSeek');
})();

(function() {
	Sympan.fn.bindDOMEvents = function() {
		var self = this;
		
		if( this.data('__dom_binded__') ) {
			return;
		} 
		this.data('__dom_binded__', true);
		
		Sympan.each({
			timeupdate: 'onProgress',
			play: 'onPlay',
			pause: 'onPause',
			seeking: 'onSeek'
		}, function(dom_event, sympan_event) {
			self.elem.addEventListener(dom_event, function(time) {
				self.trigger(sympan_event, {
					currentTime: self.elem.currentTime
				});
			}, true);
		});
	};
})();

})();
