function equalHeight(group) {
	var tallest = 0;
	group.each(function() {
		var thisHeight = $(this).height();
		if(thisHeight > tallest) {
			tallest = thisHeight;
		}
	});
	group.height(tallest);
}

function initializeuebthesesenbretagne(){
    /*
    $('body.section-homepage #portal-column-one').toggleClass('span3').toggleClass('');
    $('body.section-homepage #portal-column-two').toggleClass('span3').toggleClass('span4');
    */
}
jQuery(initializeuebthesesenbretagne);
