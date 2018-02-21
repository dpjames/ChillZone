var dologin = function(){
   console.log("login");
   var body = {};
   body['email'] = $("#emailField").val();
   body['password'] = $("#passwordField").val();
   $.ajax({
      url:"/Ssns",
      type:"post",
      data: JSON.stringify(body),
      contentType:"application/json; charset=utf-8",
      datatype:"json",
      complete : function(metadata, b){
         console.log(metadata);
         console.log(b);
      }
   });
/*
   $.post("/Ssns", {"email": "adm@11.com","password": "password"}, function(data,stat,other){
   });
   */
};
var doregister = function(){
   console.log("register");
   var body = {};
   $.ajax({
      url:"/Prss?email=adm@11.com",
      type:"get",
      xhrFields: { withCredentials: true },
      complete : function(metadata, b){
         console.log(metadata);
         console.log(b);
      }
   });
   console.log("register");
}

$(document).ready(function(){
   $("#maindiv").append("<div>hello again</div>");
   $.makeLightSwitch("#maindiv",toggle("globe"),"globe");
   $.makeLightSwitch("#maindiv",toggle("ambient"),"ambient");
   $.makeLightSwitch("#maindiv",toggle("reading"),"reading");
   var login = $("<Button>Login</Button>").click(dologin);
   $("#maindiv").after(login);
   var register = $("<Button>Register</Button>").click(doregister);
   $("#maindiv").after(register);
   updateLights();
   comet();
});
var updateLights = function(){
   $.get("/Lights", null, function(data){
      $("#globe").prop('checked', data['globe']);
      $("#ambient").prop('checked', data['ambient']);
      $("#reading").prop('checked', data['reading']);
   });
}
$.makeLightSwitch = function(where, what, label){
   var switchItem = $("<input type='checkbox'>"+label+"</input>").click(what).attr("id", label);
   $(where).append(switchItem);
}
var toggle = function(light){
   return function(){
      $.post("/Lights/"+light);
   }
}
var comet = function(){
   $.get("/Comet", null, function(data){
      //want to use events here b/c of stack overflow. Need to ask best way
      if(data['path'] === "/Lights"){
         updateLights();
      }
      comet();
   }); 
}
