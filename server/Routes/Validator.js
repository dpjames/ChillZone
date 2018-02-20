
var Validator = function(req, res) {
   this.errors = [];   
   this.session = req.session;
   this.res = res;
};


Validator.Tags = {
   noLogin: "noLogin",              
   noPermission: "noPermission",    
   missingField: "missingField",    
   badValue: "badValue",            
   notFound: "notFound",            
   badLogin: "badLogin",            
   dupEmail: "dupEmail",            
   noTerms: "noTerms",              
   forbiddenRole: "forbiddenRole",  
   noOldPwd: "noOldPwd",            
   dupTitle: "dupTitle",            
   dupEnrollment: "dupEnrollment",  
   queryFailed: "queryFailed",
   forbiddenField: "forbiddenField",
   oldPwdMismatch:"oldPwdMismatch"
};

Validator.prototype.check = function(test, tag, params, cb) {
   if (!test)
      this.errors.push({tag: tag, params: params});
   if (this.errors.length) {
      if (this.res) {
         if (this.errors[0].tag === Validator.Tags.noPermission)
            this.res.status(403).end();
         else
            this.res.status(400).json(this.errors);
         this.res = null;   
      }
      if (cb)
         cb(this);
   }
   return !this.errors.length;
};



Validator.prototype.chain = function(test, tag, params) {
   if (!test) {
      this.errors.push({tag: tag, params: params});
   }
   return this;
};

Validator.prototype.checkAdmin = function(cb) {
   return this.check(this.session && this.session.isAdmin(),
    Validator.Tags.noPermission, null, cb);
};


Validator.prototype.checkPrsOK = function(prsId, cb) {
   return this.check(this.session.id !== undefined &&
    (this.session.isAdmin() || this.session.id == prsId),
    Validator.Tags.noPermission, null, cb);
};


Validator.prototype.hasFields = function(obj, fieldList, cb) {
   var self = this;

   fieldList.forEach(function(name) {
      self.chain(obj.hasOwnProperty(name), Validator.Tags.missingField, [name]);
   });

   return this.check(true, null, null, cb);
};
Validator.prototype.onlyHasFields = function(obj, fieldList, cb) {
   var self = this; 
   Object.keys(obj).forEach(function(key,index) {
      self.chain(fieldList.indexOf(key) > -1, 
       Validator.Tags.forbiddenField, [key]); 
   });
   return this.check(true, null, null, cb);
}

module.exports = Validator;
