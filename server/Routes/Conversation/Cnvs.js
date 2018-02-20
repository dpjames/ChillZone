var Express = require('express');
var Tags = require('../Validator.js').Tags;
var router = Express.Router({caseSensitive: true});
var async = require('async');

router.baseURL = '/Cnvs';

router.get('/:id', function(req, res) {
   var vld = req.validator;
   var cnn = req.cnn;
   var id = req.params.id;

   cnn.chkQry("select id, title, lastMessage, ownerId from Conversation "+
    "where id = ?", [id], 
   function(err, fields) {
      cnn.release();
      if (err !== null) {
         res.status(500).end();
      }
      if (vld.check(fields.length, Tags.notFound)) {
         fields[0].lastMessage = fields[0].lastMessage === null ? 
          null : new Date(fields[0].lastMessage).getTime();

         res.json(fields[0]);
      }
   });

});

router.get('/', function(req, res, next) {
   var cnn = req.cnn;

   cnn.chkQry("select id, title, lastMessage, ownerId from Conversation", null,
   function(err, fields) {
      cnn.release();  
      if (err !== null) {
         res.status(500).end();
      }
      fields.map(function(val) {
         val.lastMessage = val.lastMessage === null ? 
          null : new Date(val.lastMessage).getTime();

         return val;
      });
      res.json(fields);
   });
});

router.post('/', function(req, res) {
   var vld = req.validator;
   var body = req.body;
   var cnn = req.cnn;

   async.waterfall([
   function(cb) {
      if (vld.check(("title" in body), Tags.missingField, ["title"], cb)) {
         cnn.chkQry('select * from Conversation where title = ?', 
          body.title, cb);
      }
   },
   function(existingCnv, fields, cb) {
      if (vld.check(!existingCnv.length, Tags.dupTitle, null, cb)) {
         body.ownerId = req.session.id;
         cnn.chkQry("insert into Conversation set ?", body, cb);
      }
   },
   function(insRes, fields, cb) {
      res.location(router.baseURL + '/' + insRes.insertId).end();
      cb();
   }],
   function() {
      cnn.release();
   });
});

router.put('/:cnvId', function(req, res) {
   var vld = req.validator;
   var body = req.body;
   var cnn = req.cnn;
   var cnvId = req.params.cnvId;

   async.waterfall([
   function(cb) {
      cnn.chkQry('select * from Conversation where id = ?', [cnvId], cb);
   },
   function(cnvs, fields, cb) {
      if (vld.check(cnvs.length, Tags.notFound, null, cb) &&
       vld.checkPrsOK(cnvs[0].ownerId, cb)) {
         cnn.chkQry('select * from Conversation where id <> ? && title = ?',
          [cnvId, body.title], cb);
      }
   },
   function(sameTtl, fields, cb) {
      if (vld.chain("title" in body, Tags.missingField, ["title"])
       .check(!sameTtl.length, Tags.dupTitle, null, cb)) {
         cnn.chkQry("update Conversation set title = ? where id = ?",
          [body.title, cnvId], cb);
      }
   }],
   function(err) {
      if (!err) {
         res.status(200).end();
      }
      req.cnn.release();
   });
});

router.delete('/:cnvId', function(req, res) {
   var vld = req.validator;
   var cnvId = req.params.cnvId;
   var cnn = req.cnn;

   async.waterfall([
   function(cb) {
      cnn.chkQry('select * from Conversation where id = ?', [cnvId], cb);
   },
   function(cnvs, fields, cb) {
      if (vld.check(cnvs.length, Tags.notFound, null, cb) &&
       vld.checkPrsOK(parseInt(cnvs[0].ownerId), cb)) {
         cnn.chkQry('delete from Conversation where id = ?', [cnvId], cb);
      }
   }],
   function(err) {
      if (!err) {
         res.status(200).end();
      }
      cnn.release();
   });
});

router.get('/:cnvId/Msgs', function(req, res) {
   var vld = req.validator;
   var cnvId = req.params.cnvId;
   var cnn = req.cnn;
   var query = 'select whenMade, email, content, m.id from Conversation c' +
    ' join Message m on cnvId = c.id join Person p on prsId = p.id ' +
    'where c.id = ? order by whenMade desc';
   var params = [cnvId];

   async.waterfall([
   function(cb) {  // Check for existence of conversation
      cnn.chkQry('select * from Conversation where id = ?', [cnvId], cb);
   },
   function(cnvs, fields, cb) { // Get indicated messages
      if (vld.check(cnvs.length, Tags.notFound, null, cb)) {
         cnn.chkQry(query, params, cb);
      }
   },
   function(msgs, fields, cb) { // Return retrieved messages
      msgs.map(function(element) {
         element.whenMade = new Date(element.whenMade).getTime();
         return element;
      });
      msgs = msgs.filter(function(element) {
         return !(req.query.dateTime !== undefined 
               && !isNaN(parseInt(req.query.dateTime))
               && parseInt(req.query.dateTime) < parseInt(element.whenMade));
      });
      msgs.sort(function(first, second) {
         if (first.whenMade === second.whenMade) {
            return first.id < second.id ? -1 : 1;
         } 
         else {
            return first.whenMade < second.whenMade ? -1 : 1;
         }
      });
      msgs = msgs.splice(0, req.query.num || msgs.length);

      res.json(msgs);
      cb();
   }],
   function(err) {
      cnn.release();
   });
});

router.post('/:cnvId/Msgs', function(req, res) {
   var vld = req.validator;
   var cnn = req.cnn;
   var cnvId = req.params.cnvId;
   var now;

   async.waterfall([
   function(cb) {
      if (vld.check("content" in req.body, Tags.missingField, ["content"], cb)) {
         cnn.chkQry('select * from Conversation where id = ?', [cnvId], cb);
      }
   },
   function(cnvs, fields, cb) {
      if (vld.check(cnvs.length, Tags.notFound, null, cb)) {
         cnn.chkQry('insert into Message set ?',
          {cnvId: cnvId, prsId: req.session.id,
          whenMade: now = new Date(), content: req.body.content}, cb);
      }
   },
   function(insRes, fields, cb) {
      res.location(router.baseURL + '/' + insRes.insertId);
      cnn.chkQry("update Conversation set lastMessage = ? where id = ?",
       [now, cnvId], cb);
   },
   function(inRes, fields, cb) {
      res.end();
      cb();
   }],
   function(err) {
      cnn.release();
   });
});

module.exports = router;
