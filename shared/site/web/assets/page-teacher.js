/* 2015-09-03 15:09:31 */
var app;app={init:function(){return app.initScrollHook(),helpers.initTooltip(),app.initPageBackground()},initScrollHook:function(){return window.onscroll=function(){return helpers.scrollHook()},window.onscroll()},initPageBackground:function(){var a;return teacher.background_image?(a=document.getElementById("bg-image"),a.style.backgroundImage="url("+teacher.background_image+")"):void 0}},app.init();