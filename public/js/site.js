$(function(){
	$('.slide-out-div').tabSlideOut({
    	tabHandle: '.handle',
    	pathToTabImage: '/gfx/about-me.png',
    	imageHeight: '95px',
    	imageWidth: '25px', 
    	tabLocation: 'left',
    	speed: 300,
    	action: 'click',
    	topPos: '150px',
    	fixedPosition: false
	});
});
