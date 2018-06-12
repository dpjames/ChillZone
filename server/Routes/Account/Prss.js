var Express = require('express');
var Tags = require('../Validator.js').Tags;
var router = Express.Router({caseSensitive: true});
var async = require('async');
var mysql = require('mysql');

router.baseURL = '/Prss';

router.get('/', function(req, res) {
   if (req.session.isAdmin()) {
      email = req.query.email + '%';
   } 
   else if (req.session.email.indexOf(req.query.email) === 0) {
      email = req.session.email;
   } 
   else {
      res.status(200).json([]);
      req.cnn.release();
      return;
   }
   var handler = function(err, prsArr) {
      res.json(prsArr);
      req.cnn.release();
   };

   if (email) {
      req.cnn.chkQry('select id, email, isHome from Person where email like ?', [email],
       handler);
   } 
   else {
      req.cnn.chkQry('select id, email from Person', handler);
   }
});

router.post('/', function(req, res) {
   var vld = req.validator;  // Shorthands
   var body = req.body;
   var admin = req.session && req.session.isAdmin();
   var cnn = req.cnn;
   
   if (admin && !("password" in body)) {
      body.password = "*";                       // Blocking password
   }
   body.whenRegistered = new Date();
   async.waterfall([
   function(cb) { // Check properties and search for Email duplicates
      if (vld.hasFields(body, ["email", "password", "lastName","role"], cb) &&
       vld.chain(body.password !== "", Tags.missingField, ["password"])
       .chain(body.role === 0 || admin, Tags.noPermission)
       .chain(body.termsAccepted || admin, Tags.noTerms)
       .check(body.role === 0 || (admin && body.role === 1), 
       Tags.badValue, ["role"], cb)) {
         cnn.chkQry('select * from Person where email = ?', body.email, cb);
      }
   },
   function(existingPrss, fields, cb) {  // If no duplicates, insert new Person
      if (vld.check(!existingPrss.length, Tags.dupEmail, null, cb)) {
         if (!body.termsAccepted) {
            delete body.termsAccepted;
         } 
         else {
            body.termsAccepted = body.termsAccepted && new Date();
         }
         body.isHome = 0;
         cnn.chkQry('insert into Person set ?;', body, cb);
      }
   },
   function(result, fields, cb) { // Return location of inserted Person
      res.location(router.baseURL + '/' + result.insertId).end();
      cb();
   }],
   function() {
      cnn.release();
   });
});
router.get('/:id', function(req, res) {
   var vld = req.validator;

   async.waterfall([
   function(cb) {
      if (vld.checkPrsOK(req.params.id, cb)) {
         req.cnn.query('select * from Person where id = ?', 
          [req.params.id], cb);
      }
   },
   function(prsArr, fields, cb) {
      if (vld.check(prsArr.length, Tags.notFound, null, cb)) {
         prsArr.map(function(element) {
            delete element.password;
            return element;
         });
         res.json(prsArr);
         cb();
      }
   }],
   function() {
      req.cnn.release();   
   });
});

router.delete('/:id', function(req, res) {
   var vld = req.validator;

   if (vld.checkAdmin()) {
      req.cnn.query('DELETE from Person where id = ?', [req.params.id],
      function (err, result) {
         if (!err && vld.check(result.affectedRows, Tags.notFound)) {
            res.status(200).end();
         }
         req.cnn.release();
      });
   } 
   else {
      req.cnn.release();
   }
});
router.put("/:id", function(req, res) {
   var vld = req.validator;
   var body = req.body;
   var admin = req.session.isAdmin();
   var id = req.params.id;
   var cnn = req.cnn;

   async.waterfall([
   function(cb) {
      if (vld.checkPrsOK(req.params.id, cb) 
       && vld.onlyHasFields(body, ["firstName", "lastName", "password", "role",
       "termsAccepted", "whenRegistered", "oldPassword", "isHome"], cb)
       && vld.chain(!("termsAccepted" in body), Tags.forbiddenField, 
       ["termsAccepted"])
       .chain(!("whenRegistered" in body), Tags.forbiddenField, 
       ['whenRegistered'])
       .chain(!("password" in body) || body.password, Tags.badValue, 
       ['password'])
       .chain(!("password" in body) || "oldPassword" in body || admin, 
       Tags.noOldPwd, null)
       .check(!req.body.role || admin, Tags.badValue, ["role"], cb)) {
         cnn.chkQry("select * from Person where id = ?;", [id], cb);
      }
   },
   function(result, fields, cb) {
      if (vld.check(result.length, Tags.notFound, null, cb) &&
       vld.check(!("password" in body) 
       || body.oldPassword === result[0].password || admin, 
       Tags.oldPwdMismatch, null, cb)) {
         delete body.oldPassword;
         if (Object.keys(body).length === 0) {
            cb(false, null, null);
            return;
         }
         cnn.chkQry("update Person set ? where id = ?;", [body, id], cb); 
      }
   },
   function(result, fields, cb) {
      res.status(200).end();
      cb();
   }],
   function(err) {
      req.cnn.release();
   });
});
 
module.exports = router;
