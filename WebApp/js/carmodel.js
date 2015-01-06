// JavaScript Document
var lanrenzhijia = function(val){
	var mem_div = $("."+val);
	var memli = mem_div.find("li.memLI");
	var mem_len = memli.length;
	var pop_info = mem_div.find(".popInfo");
	var layer_Mode = mem_div.find(".layerMode");
	var thumb1 = [];//缓存数组
	var thumb2 = [];//缓存数组
	var init_left,init_top;
	var hovertime;

	memli.bind({
		mouseover : function(){ 
			THIS = $(this);
			hovertime = setTimeout(function(){
				pop_info.css({"display":"block"});
				var addinfo = THIS.find(".addInfo").html();
				pop_info.html(addinfo);
				var position = THIS.position();
				var new_left,new_top;
				var cssShadow;
				var _margin;
				
				if(position.left <= mem_div.width() - pop_info.width()){
					new_left = position.left;
					cssShadow = "imgShadow1";
					_margin = "left";
					pop_info.find("img").css("float","left");
					pop_info.find("p").css({"float":"left","margin-left":"-50px"});
				}
				if(position.left > mem_div.width() - pop_info.width()){
					new_left = position.left - THIS.width()*1-64;
					cssShadow = "imgShadow2";
					_margin = "right";
					pop_info.find("img").css("float","right");
					pop_info.find("p").css({"float":"right","margin-right":"-50px","text-align":"right"});
				}
				if(position.top <= mem_div.height() - pop_info.height()){
					new_top = position.top;
				}
				if(position.top > mem_div.height() - pop_info.height()){
					new_top = position.top - THIS.height()*2 - 4;	
				}
				pop_info.css({"top":new_top,"left":new_left});
				pop_info.find("img").addClass(cssShadow);
				if(_margin == "left"){
					pop_info.find("p").animate({			   
						marginLeft: "0px"					   
					},
					300
					);	
				}
				else if(_margin == "right"){
					pop_info.find("p").animate({			   
						marginRight: "0px"
					},
					300
					);		
				}
				layer_Mode.fadeTo("fast", 0.6);
			},300);
		},
		mouseout: function(){
			clearTimeout(hovertime);
		}
		
	})
	
	pop_info.bind('mouseout',function(){
		layer_Mode.css({"display":"none"});
		pop_info.css({"display":"none","top":0,"left":0});
		pop_info.html("");
	})
}
$(document).ready(function(){
	lanrenzhijia("lanrenzhijia");
})