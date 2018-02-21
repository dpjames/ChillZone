var mysql = require('mysql');

var CnnPool = function() {
   var poolCfg = require('./connection.json');

   poolCfg.connectionLimit = CnnPool.PoolSize;
   this.pool = mysql.createPool(poolCfg);
};

CnnPool.PoolSize = 1;

CnnPool.prototype.getConnection = function(cb) {
   this.pool.getConnection(cb);
};

CnnPool.router = function(req, res, next) {
   console.log("Getting connection");
   CnnPool.singleton.getConnection(function(err, cnn) {
      if (err) {
         res.status(500).json('Failed to get connection ' + err);
      } 
      else {
         console.log("Connection acquired");
         cnn.chkQry = function(qry, prms, cb) {
            this.query(qry, prms, function(err, rep, fields) {
               if (err)
                  res.status(500).json('Failed query ' + qry);
               cb(err, rep, fields);
            });
         };
         req.cnn = cnn;
         next();
      }
   });
};

CnnPool.singleton = new CnnPool();

module.exports = CnnPool;
