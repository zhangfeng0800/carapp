//Set the id names of your tablinks (without a number at the end)
//修改tabID
var tablink_idname = new Array("tablink","tabline")
//Set the id names of your tabcontentareas (without a number at the end)
// tabID 对应区域内容
var tabcontent_idname = new Array("tabcontent","tablinebg") 
//Set the number of your tabs in each menu
//  设置选项卡数目
var tabcount = new Array("4","5")
//Set the Tabs wich should load at start (In this Example:Menu 1 -> Tab 2 visible on load, Menu 2 -> Tab 5 visible on load)
//设置选项卡 默认显示区域
var loadtabs = new Array("1","1")  
//Set the Number of the Menu which should autochange (if you dont't want to have a change menu set it to 0)
//设置选项卡 自动播放 2为第二个开始 0为不自动播放
var autochangemenu = 0;
//the speed in seconds when the tabs should change
//播放速度
var changespeed = 3;
//should the autochange stop if the user hover over a tab from the autochangemenu? 0=no 1=yes
var stoponhover = 0;
//END MENU SETTINGS


/*Swich EasyTabs Functions - no need to edit something here*/
function easytabs(menunr, active) {if (menunr == autochangemenu){currenttab=active;}if ((menunr == autochangemenu)&&(stoponhover==1)) {stop_autochange()} else if ((menunr == autochangemenu)&&(stoponhover==0))  {counter=0;} menunr = menunr-1;for (i=1; i <= tabcount[menunr]; i++){document.getElementById(tablink_idname[menunr]+i).className='tab'+i;document.getElementById(tabcontent_idname[menunr]+i).style.display = 'none';}document.getElementById(tablink_idname[menunr]+active).className='tab'+active+' tabactive';document.getElementById(tabcontent_idname[menunr]+active).style.display = 'block';}var timer; counter=0; var totaltabs=tabcount[autochangemenu-1];var currenttab=loadtabs[autochangemenu-1];function start_autochange(){counter=counter+1;timer=setTimeout("start_autochange()",1000);if (counter == changespeed+1) {currenttab++;if (currenttab>totaltabs) {currenttab=1}easytabs(autochangemenu,currenttab);restart_autochange();}}function restart_autochange(){clearTimeout(timer);counter=0;start_autochange();}function stop_autochange(){clearTimeout(timer);counter=0;}

window.onload=function(){
var menucount=loadtabs.length; var a = 0; var b = 1; do {easytabs(b, loadtabs[a]);  a++; b++;}while (b<=menucount);
if (autochangemenu!=0){start_autochange();}
}
