$.request = function(method, path, body, complete){
   console.log(body);
   console.log(path);
   $.ajax({
      url: path,
      type: method,
      data: JSON.stringify(body),
      contentType:"application/json; charset=utf-8",
      datatype:"json",
      complete : function(data){complete(data.responseJSON)}
   });  
}
$.lights = {};
$.lights.toggle = function(light){
   return function(){
      console.log("light is ",light);
      $.request("POST", "/Lights/"+light, {}, function(){});
   }
}
$.lights.updateLights = function(){
   $.request("GET", "/Lights", null, function(data){
      $("#globe").prop('checked', data['globe']);
      $("#ambient").prop('checked', data['ambient']);
      $("#reading").prop('checked', data['reading']);
   });
}

$.comet = function(){
   $.request("GET", "/Comet?id="+Math.floor(Math.random() * 1000000), null, function(data){
      if(data['path'] === "/Lights"){
         $.lights.updateLights();
      }else if(data['path'] == "/Cnvs/1/Msgs"){
         $.message.updateMessages();
      }
      $.comet();
   });
}

$.message= {};

$.message.updatemessages = function(){
   console.log("mess");
   $.request("get", "/cnvs/1/msgs", null, function(data){
      if(data.length != 0){
         $("#chatview").val("");
         data.foreach(function(e){
            $("#chatview").val($("#chatview").val()+(e.content+"\n"))
         });
      }
   });
}
$.message.send = function(){  
   $.request("POST", "/Cnvs/1/Msgs", {"content" : $("#compose").val()}, function(){}); 
}
$.user = {};
$.user.login = function(){
   var body = {};
   body['email'] = $("#username").val();
   body['password'] = $("#password").val();
   $.request("POST", "/Ssns", body, function(){});
}
$.makeToggles = function(where) {
   var temp = $("<div id='globediv'></div>"); 
   temp.append($('<label class="switch"><input id="globe" type="checkbox">'+
    '<span class="slider round"></span></label>'));
   temp.append($("</br>"));
   temp.append($("<span class='button-name'>globe</span>"));
   $("#globe").click($.lights.toggle("globe"));
   where.append(temp);

   var temp = $("<div id='readingdiv'></div>"); 
   temp.append($('<label class="switch"><input id="reading" type="checkbox">'+
    '<span class="slider round"></span></label>'));
   temp.append($("</br>"));
   temp.append($("<span class='button-name'>reading</span>"));
   $("#reading").click($.lights.toggle("reading"));
   where.append(temp);

   var temp = $("<div id='ambientdiv'></div>"); 
   temp.append($('<label class="switch"><input id="ambient" type="checkbox">'+
    '<span class="slider round"></span></label>'));
   temp.append($("</br>"));
   temp.append($("<span class='button-name'>ambient</span>"));
   $("#ambient").click($.lights.toggle("ambient"));
   where.append(temp);
}

$(document).ready(function(){
   var main = $("#togglediv");
   $("#login").click($.user.login);
   $.makeToggles(main);
   $.lights.updateLights();
   $.comet();

});

