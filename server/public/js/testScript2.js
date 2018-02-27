var request = function(method, path, body, complete){
   console.log(body);
   console.log(path);
   $.ajax({
      url: path,
      type: method,
      data: JSON.stringify(body),
      contentType:"application/json; charset=utf-8",
      datatype:"json",
      complete : complete
   });  
}
var toggle = function(light){
   return function(){
      console.log("light is ",light);
      request("POST", "/Lights/"+light, {}, function(){});
   }
}
var updateLights = function(){
   console.log("update");
   request("GET", "/Lights", null, function(data){
      data = data.responseJSON;
      $("#globe").prop('checked', data['globe']);
      $("#ambient").prop('checked', data['ambient']);
      $("#reading").prop('checked', data['reading']);
   });
}
var updateMessages = function(){
   console.log("mess");
   request("GET", "/Cnvs/1/Msgs", null, function(data){
      console.log("data is", data.responseJSON);
      data = data.responseJSON;
      if(data.length != 0){
         $("#chatView").val("");
         data.forEach(function(e){
            $("#chatView").val($("#chatView").val()+(e.content+"\n"))
         });
      }
   });
}
var comet = function(){
   fetch("/Comet?id="+Math.floor(Math.random() * 1000000), {method: "GET"})
    .then((data) => data.json())
    .then(function(data){
      console.log(data);
      if(data['path'] === "/Lights"){
         updateLights();
      }else if(data['path'] == "/Cnvs/1/Msgs"){
         updateMessages();
      }
      comet();
    });
}

var send = function(){  
   request("POST", "/Cnvs/1/Msgs", {"content" : $("#compose").val()}, function(){}); 
}
$.makeToggles = function(where) {
   where.append($("<span>globe</span>"));
   where.append($('<label class="switch"><input id="globe" type="checkbox">'+
    '<span class="slider round"></span></label>'));
   $("#globe").click(toggle("globe"));
   where.append($("<span>reading</span>"));
   where.append($('<label class="switch"><input id="reading" type="checkbox">'+
    '<span class="slider round"></span></label>'));
   $("#reading").click(toggle("reading"));
   where.append($("<span>ambient</span>"));
   where.append($('<label class="switch"><input id="ambient" type="checkbox">'+
    '<span class="slider round"></span></label>'));
   $("#ambient").click(toggle("ambient"));
}
$.makeLoginFields = function (where) {
   $("#maindiv").after($("<textarea id=password></textarea>"));
   $("#maindiv").after($("<textarea id=username></textarea>"));
   var login = $("<Button>Login</Button>").click(dologin);
   $("#maindiv").after(login);
}
$(document).ready(function(){
   var main = $('#maindiv');
   $.makeToggles(main);
   $.makeLoginFields(main);
   main.append($("<textarea id='chatView'>vals</textarea>"));
   main.append($("<textarea id='compose'>enter text</textarea>"));
   main.append($("<button id='send'>send</button>").click(send));
   updateLights();
   comet();
   updateMessages();
});

var dologin = function(){
   console.log("login");
   var body = {};
   body['email'] = $("#username").val();
   body['password'] = $("#password").val();
   request("POST", "/Ssns", body, function(){});
}

