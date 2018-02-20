var Express = require('express');
var router = Express.Router({caseSensitive: true});

router.get('/:id', function(req, res, next) {
   var cnn = req.cnn;
   var id = req.params.id;

   cnn.chkQry("select whenMade, content, p.email from Message m join Person p "
    +"on p.id = prsId where m.id = ?", [id], 
   function(err, tab) {
      cnn.release();
      res.json(tab[0]);
   });
});

module.exports = router;
