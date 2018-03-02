var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');

var bodyParser = require('body-parser');
var Session = require('./Routes/Session.js');
var Validator = require('./Routes/Validator.js');
var CnnPool = require('./Routes/CnnPool.js');

var async = require('async');

var app = express();

app.use(express.static(path.join(__dirname, 'public')));
app.use(express.static(path.join(__dirname, 'public/js')));
app.use(express.static(path.join(__dirname, 'public/css')));

app.use(bodyParser.json());

app.use(cookieParser());

app.use(Session.router);

app.use(function(req, res, next) {
   console.log(req.path);
   console.log(req.body);
   if (req.session 
    || req.method === 'GET' && req.path.indexOf('/Comet') === 0 
    || req.path.indexOf('/Lights') === 0
    || (req.method === 'POST' &&
    (req.path === '/Prss' || req.path === '/Ssns'))) {
      req.validator = new Validator(req, res);
      next();
   } 
   else
      res.status(401).end();
});

app.use(CnnPool.router);
app.use('/Prss',   require('./Routes/Account/Prss.js'));
app.use('/Ssns',   require('./Routes/Account/Ssns.js'));
app.use('/Cnvs',   require('./Routes/Conversation/Cnvs.js'));
app.use('/Msgs',   require('./Routes/Conversation/Msgs.js'));
app.use('/Comet',  require('./Routes/Comet/Comet.js'));
app.use('/Lights', require('./Routes/Lights/Lights.js'));
app.use('/Chores', require('./Routes/Chores/Chores.js'));

app.delete('/DB', function(req, res) {
   if (!req.session.isAdmin()){
      req.cnn.release();
      res.status(403).end();
      return;
   }
   
   var cbs = ["Conversation", "Message", "Person", "Chores"].map(function(tblName) {
      return function(cb) {
         req.cnn.query("delete from " + tblName, cb);
      };
   });

   
   cbs = cbs.concat(["Conversation", "Message", "Person", "Chores"].map(function(tblName) {
      return function(cb) {
         req.cnn.query("alter table " + tblName + " auto_increment = 1", cb);
      };
   }));

   
   cbs.push(function(cb) {
      req.cnn.query('INSERT INTO Person (firstName, lastName, email,' +
          ' password, whenRegistered, role) VALUES ' +
          '("Joe", "Admin", "adm@11.com","password", NOW(), 1);', cb);
   });

   
   cbs.push(function(callback){
      for (var session in Session.sessions)
         delete Session.sessions[session];
      callback();
   });

   async.series(cbs, function(err) {
      req.cnn.release();
      if (err)
         res.status(400).json(err);
      else
         res.status(200).end();
   });
});


app.use(function(req, res) {
   res.status(404).end();
   req.cnn.release();
});

app.use(function(err, req, res, next) {
   res.status(500).json("general error: " + err.stack);
   req.cnn && req.cnn.release();
});
port = "4011";
for (var i = 0; i < process.argv.length; i++){
   if (process.argv[i] === "-p"){
      port = process.argv[i+1];
      break;
   }
}
if (!parseInt(port)){
   process.exit();
}
app.listen(port, function () {
   var util = require('util');
   const { exec } = require('child_process');
   exec('./lights 0', (err, stdout, stderr) => {
     if (err) {
       // node couldn't execute the command
       return;
     }

     // the *entire* stdout and stderr (buffered)
     //console.log(`stdout: ${stdout}`);
     //console.log(`stderr: ${stderr}`);
   });
   console.log('App Listening on port ' + port);
});

