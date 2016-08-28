// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree .


function MultiMapMaker() {
	this.map = {};
}

MultiMapMaker.prototype.set = function(key, value) {
	if(!(key in this.map)) {
		var array = [];
		this.map[key] = array;
	} else {
		array = this.map[key];
	}
	array.push(value);
}

MultiMapMaker.prototype.getMap = function() {
	return this.map;
}


var toCountKey = 'js-characters-to-count'
var counterKey = 'js-character-counter'
var maxCount = 140;

window.addEventListener('load', function() {

	function registerByKey(key) {
		var eArray = document.getElementsByClassName(key);
		var eMultiMapMaker = new MultiMapMaker();
		var keyPrefix = key + '-';
		var keyPrefixLength = keyPrefix.length;
		for(var i = 0; i < eArray.length; ++i) {
			var e = eArray[i];
			var className = e.className;
			var classes = className.split(/\s+/);
			for(var j = 0; j < classes.length; ++j) {
				var _class = classes[j];
				if(_class.startsWith(keyPrefix)) {
					var key = _class.substring(keyPrefixLength);
					eMultiMapMaker.set(key, e);
				}
			}
		}
		var eMultiMap = eMultiMapMaker.getMap();
		return eMultiMap;
	}

	function linkToCountsToCounters(eToCountMultiMap, eCounterMultiMap) {
		for(var key in eToCountMultiMap) {
			if(key in eCounterMultiMap) {
				eToCountArray = eToCountMultiMap[key];
				eCounterArray = eCounterMultiMap[key]
				if(eToCountArray.length === 1) {
					eToCount = eToCountArray[0];
					linkCount(eToCount, eCounterArray);
				}else {
					throw new Error();
				}
			}
		}
	}

	function linkCount(eToCount, eCounterArray) {
		function updateCount() {
			var characterCount = eToCount.value.length;
			for(var i = 0; i < eCounterArray.length; ++i) {
				var leftCharacterCount = 140 - characterCount;

				if(leftCharacterCount === 1) {
					var leftCharacterCountText = leftCharacterCount + ' character';
				} else {
					leftCharacterCountText = leftCharacterCount + ' characters';
				}
				
				eCounterArray[i].innerHTML = leftCharacterCountText;
			}
		}

		eToCount.addEventListener('input', updateCount);
	}

	eToCountMultiMap = registerByKey(toCountKey);
	eCounterMultiMap = registerByKey(counterKey);
	linkToCountsToCounters(eToCountMultiMap, eCounterMultiMap);

})