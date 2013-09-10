# tiny util
wait = (time) ->
  return $.Deferred (defer) ->
    setTimeout ->
      defer.resolve()
    , time

describe "foo", ->
  
  it "should be true", ->
    (expect true).to.be true

