var Express = require('express');
var Tags = require('../Validator.js').Tags;
var ssnUtil = require('../Session.js');
var router = Express.Router({caseSensitive: true});

router.get('/', function(req, res) {
   req.cnn.release();
   var cometFun = function(body){
      console.log(body);
      res.status(200).json(body); 
   };
   console.log("did the comet thing");
   ssnUtil.addComet(cometFun);
});
router.get('/rel', function(req, res) {
   req.cnn.release();
   ssnUtil.cometEmitter.emit("comet", ["this is the body"]);
   res.status(200).end();
});

module.exports = router;

