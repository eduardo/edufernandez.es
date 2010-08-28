$(function(){
    $('.shr-bookmarks a.external').attr('target', '_blank');
    var c = $('.shr-bookmarks').height(), d = $('.shr-bookmarks ul.socials').height();

    d > c && $('.shr-bookmarks-expand').hover(function() {
        $(this).animate({
            height: d + 'px'
        },
        {
            duration: 400,
            queue: false
        })
    },
    function() {
        $(this).animate({
            height: c + 'px'
        },
        {
            duration: 400,
            queue: false
        })
    });
    if ($('.shr-bookmarks-center') || $('.shr-bookmarks-spaced')) {
        var a = $('.shr-bookmarks').width(),
        b = $('.shr-bookmarks:first ul.socials li').width(),
        e = $('.shr-bookmarks:first ul.socials li').length,
        f = Math.floor(a / b);
        b = Math.min(f, e) * b;
        if ($('.shr-bookmarks-spaced').length > 0) {
            a = Math.floor((a - b) / (Math.min(f, e) + 1));
            $('.shr-bookmarks ul.socials li').attr('style', 'margin-left:' + a + 'px !important')
        } else if ($(true)) {
            a = (a - b) / 2;
            $('.shr-bookmarks-center').attr('style', 'margin-left:' + a + 'px !important')
        }
    }
    /*
		click handler for SexyBookmarks
		Credit: Phong Thai Cao - http://www.JavaScriptBank.com
		Please keep this creadit when you use this code
	*/
    $('.shr-bookmarks a.external').click(function() {
        // get the current URL & encode it into the standard URI
        var url = encodeURIComponent(window.location.href), desc = '';

        // parse the description for the above URL by the text() method of jQuery
        // the text must be placed in the P tag with ID="shr-bookmarks-content"
        // so you can change the container of description with another tag and/or another ID
        if ($('p.shr-bookmarks-content').length) {
            desc = encodeURIComponent($('p.shr-bookmarks-content').text());
        }

        // detect the social bookmark site user want to share your URL
        // by checking the className of site that we'll declare in the HTML code
        // and assign the URL & description we got into the current anchor
        // then redirect to the clicked bookmark site, you can use window.open() method for opening the new window
        switch (this.parentNode.className) {
        	case 'shr-twittley':
	            this.href += '?title=' + document.title + '&url=' + url + '&desc=' + desc + '&pcat=Internet&tags=';
	            break;
	        case 'shr-digg':
	            this.href += '?phase=2&title=' + document.title + '&url=' + url + '&desc=' + desc;
	            break;
	        case 'shr-twitter':
	            this.href += '?status=RT+@thedersen:+' + document.title + '+-+' + url;
	            break;
	        case 'shr-scriptstyle':
	            this.href += '?title=' + document.title + '&url=' + url;
	            break;
	        case 'shr-reddit':
	            this.href += '?title=' + document.title + '&url=' + url;
	            break;
	        case 'shr-delicious':
	            this.href += '?title=' + document.title + '&url=' + url;
	            break;
	        case 'shr-stumbleupon':
	            this.href += '?title=' + document.title + '&url=' + url;
	            break;
	        case 'shr-technorati':
	            this.href += '?add=' + url;
	            break;
	        case 'shr-facebook':
	            this.href += '?t=' + document.title + '&u=' + url;
	            break;
	        case 'shr-mail':
	            this.href += '?subject=' + document.title + ';body=' + url;
	            break;
        }
    })
});
