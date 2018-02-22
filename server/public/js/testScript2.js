var toggle = function(light){
   return function(){
      $.post("/Lights/"+light, null, function(a,b,c){console.log("res", a,b,c.getAllResponseHeaders())});
   }
}
var updateLights = function(){
   console.log("update");
   $.get("/Lights", null, function(data){
      $("#globe").prop('checked', data['globe']);
      $("#ambient").prop('checked', data['ambient']);
      $("#reading").prop('checked', data['reading']);
   });
}
var comet = function(){
   /*
   $("#maindiv").append("</br><span>DOING out</span>");
   $.get("/Comet", null, function(data, stat){
      //want to use events here b/c of stack overflow. Need to ask best way
      $("#maindiv").append("</br><span>"+stat+"</span>");
      if(data['path'] === "/Lights"){
         $("#maindiv").append("</br><span>DOING light</span>");
         updateLights();
      }
      comet();
   })
   */
   fetch("/Comet?id="+Math.floor(Math.random() * 1000000), {method: "GET"})
    .then((data) => data.json())
    .then(function(data){
      console.log(data);
      if(data['path'] === "/Lights"){
         $("#maindiv").append("</br><span>DOING light</span>");
         updateLights();
      }
      comet();
    });
   
}
$.makeToggles = function(where) {
   where.append($("<span>globe</span>"));
   where.append($('<label class="switch"><input id="globe" type="checkbox">'+
    '<span class="slider round"></span></label>'));
   $("#globe").click(toggle("globe"));
   where.append($("<span>ambient</span>"));
   where.append($('<label class="switch"><input id="ambient" type="checkbox">'+
    '<span class="slider round"></span></label>'));
   $("#ambient").click(toggle("ambient"));
   where.append($("<span>reading</span>"));
   where.append($('<label class="switch"><input id="reading" type="checkbox">'+
    '<span class="slider round"></span></label>'));
   $("#reading").click(toggle("reading"));
}
$.makeLoginFields = function (where) {

}
$(document).ready(function(){
   var main = $('#maindiv');
   $.makeToggles(main);
   $.makeLoginFields(main);
   updateLights();
   comet();
});
