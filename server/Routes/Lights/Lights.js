var Express = require('express');
var Tags = require('../Validator.js').Tags;
var ssnUtil = require('../Session.js');
var router = Express.Router({caseSensitive: true});
var lightState = [false, false, false];
var util = require('util');
router.post('/:light', function(req, res) {
   var setLightState = function(globe, reading, ambient){
      lightState[0] = globe;
      lightState[2] = reading;
      lightState[1] = ambient;
   }
   var light = req.params.light; 
   var n;
   req.cnn.release();
   if (light === "ambient") {
      n = 5;
   } 
   else if (light === "globe") {
      n = 4;
   } 
   else if (light === "reading") {  
      n = 6;
   } else if (light == "off") {
      setLightState(false, false, false);
      n = 0;
   } else if (light == "study") {
      setLightState(true, true, false);
      n = 2
   } else if (light == "chill") {
      setLightState(true, false, false);
      n = 1
   } else if (light == "lights") {
      setLightState(false, false, true);
      n = 3
   }
   else {
      res.status(400).end();
      return;
   }

   const { exec } = require('child_process');
   exec('./lights '+n, (err, stdout, stderr) => {
     if (err) {
       // node couldn't execute the command
       return;
     }

     // the *entire* stdout and stderr (buffered)
     console.log(`stdout: ${stdout}`);
     console.log(`stderr: ${stderr}`);
   });


   lightState[n-4] = !lightState[n-4];
   /*
   ssnUtil.cometEmitter.emit("comet", 
    {"light" : light, "state" : lightState[n-4]});
   */
   console.log("look here");
   console.log(ssnUtil.cometEmitter.listeners("comet"));
   ssnUtil.cometEmitter.emit("comet", {"path" : "/Lights"});
   ssnUtil.cometEmitter.removeAllListeners(["comet"]);
   //console.log(lightState);
   res.status(200).end();
});

router.get('/', function(req, res) {
   req.cnn.release();
   res.json({
      "globe" : lightState[0],
      "ambient" : lightState[1],
      "reading" : lightState[2]
   }); 
});


module.exports = router;
