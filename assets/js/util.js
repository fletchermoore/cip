import _ from 'lodash'

export function applyDict(original, dict) {
  let keys = _.keys(dict)

  // collect all the start and end positions of the terms that are found
  var map = []
  _.each(keys, function(term) {
    let pattern = '\\b'+term+'\\b';
    let regex = new RegExp(pattern, "gi")
    var result;
    while((result = regex.exec(original)) !== null) {
      let match = { index: result.index, term: term, isEnd: false}
      let endPos = { index: result.index + term.length, term: term, isEnd: true}
      map = map.concat([match, endPos])
    }
  })
  // abort if no matches
  if (map.length == 0) {
    return original
  }
  // iterate backwards from the furthest match
  let sortedMap = _.sortBy(map, ['index'])
  var doctored = original
  for (var i = (sortedMap.length - 1); i > -1; i--) {
    let match = sortedMap[i]
    let tail = doctored.slice(match.index)
    let head = doctored.slice(0, match.index)
    if (match.isEnd) {
      doctored = head + "</span>" + tail
    } else {
      doctored = head + "<span class=\"dict-term\" title=\""+dict[match.term]+"\" uk-tooltip>" + tail
    }
  }

  return doctored
}
