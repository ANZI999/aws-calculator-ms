exports.divideHandler = function(event, context, callback) {
   console.log("a = " + event.a);
   console.log("b = " + event.b);
   let answer = event.a / event.b;
   console.log("answer = " + answer);
   callback(null, answer);
}