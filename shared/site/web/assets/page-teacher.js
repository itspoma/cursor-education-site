/* 2015-03-30 20:03:30 */
var app;app={init:function(){return app.initScrollHook(),helpers.initTooltip()},initScrollHook:function(){return window.onscroll=function(){return helpers.scrollHook()},window.onscroll()}},app.init();