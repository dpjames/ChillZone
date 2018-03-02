var Express = require('express');
var Tags = require('../Validator.js').Tags;
var ssnUtil = require('../Session.js');
var async = require('async');
var router = Express.Router({caseSensitive: true});

router.get("/", function(req,res){
   var cnn = req.cnn;
   cnn.chkQry("select * from Chores", null, function(err, tab){
      cnn.release();
      res.json(tab[0]); 
   });
});
router.post('/:person', function(req, res){
   var person = req.params.person;
   var cnn = req.cnn;
   var vld = req.validator;
   var body = req.body;
   async.waterfall([
   function(cb){
      if(vld.onlyHasFields(body, ["name","description","duration", "isRecurring"], cb)){
         body.startTime = new Date();  
         body.owner = person;
         cnn.chkQry("insert into Chores set name=?, description=?, " +
               "duration=?, isRecurring=?, startTime=?, owner=?;",
               [body.name, body.description, body.duration, body.isRecurring, 
               body.startTime, body.owner], cb);
      }
   },
   function(results, fields, cb){
      res.status(200).end();
      cb()
   }
   ], 
   function(err){
      console.log("here!!!!!!!!!", err);
      cnn.release(); 
   });
});

router.delete('/:id', function(req,res){
   var choreId = req.params.id;
   var cnn = req.cnn;

   async.waterfall([
   function(cb){
      cnn.chkQry("delete from Chores where id = ?", [choreId], cb);  
   },
   function(result,fields,cb){
      res.status(200).end();
      cb();
   }
   ],
   function(error){
      cnn.release(); 
   });
   
});



module.exports = router;
