var crypto = require('crypto');
var sessions = {};          
var Events = require('events');
var cometEmitter = new Events.EventEmitter();
var duration = 7200000;     
var cookieName = 'CHSAuth'; 

var Session = function Session(user) {
   this.firstName = user.firstName;
   this.lastName = user.lastName;
   this.id = user.id;
   this.email = user.email;
   this.role = user.role;
   this.loginTime = new Date().getTime();
   this.lastUsed = new Date().getTime();
};

Session.prototype.isAdmin = function() {
   return this.role == 1;
};

exports.makeSession = function makeSession(user, res) {
   var authToken = crypto.randomBytes(16).toString('hex');  
   var session = new Session(user);

   res.cookie(cookieName, authToken, {maxAge: duration, httpOnly: true}); 
   sessions[authToken] = session;

   return authToken;
};

exports.deleteSession = function(authToken) {
   delete sessions[authToken];
};

exports.router = function(req, res, next) {
   
   if (req.cookies[cookieName] && sessions[req.cookies[cookieName]]) {
      
      if (sessions[req.cookies[cookieName]].lastUsed < new Date().getTime() 
       - duration) {
         delete sessions[req.cookies[cookieName]];
      }
      else {
         req.session = sessions[req.cookies[cookieName]];
      }
   }
   next();
};
exports.addComet = function(callback){
   cometEmitter.on('comet', callback);
}
exports.cookieName = cookieName;
exports.sessions = sessions;
exports.cometEmitter = cometEmitter;
