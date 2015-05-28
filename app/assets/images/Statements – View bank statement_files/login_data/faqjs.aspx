
var panelClosed = true;
var panelMinWidth = 0;
var panelMaxWidth = 485;
var panelHeight = 0;
var panelExpandedHeight;
var windowname = "help";
var inquiraCheckDone = false;
var inquiraTimeout;
var defaultQuestionFlag = true;
var defaultQuestion = "";
var helpID = "";
var inquiraCallTimedOut = false;

$(document).ready(function(){
	panelMinWidth = $(".box_faqPanel").css("width");
	panelHeight = $(".box_faqPanel").css("height");
	panelExpandedHeight = panelHeight;
	
	/* Create the expanded panel - has tab order issues if we create it when JS is switched off */
	var closeButtonUrl = "https://www.ulsterbankanytimebanking.ie/Brands/UBR/images/faq/close.png";
	var blankImage = "https://www.ulsterbankanytimebanking.ie/brands/UBR/images/blank.gif";
	$(".topFaqPanel").append("<h2>Frequently Asked Questions</h2><a href=\"javascript:void(0);\" class=\"closeIframeAnchor\"><img class=\"closeIframe\" src=\"" + closeButtonUrl + "\" alt=\"Close\" /></a><br clear=\"all\" /><iframe class=\"faqIframe\" src=\"" + blankImage + "\" frameborder=\"0\"></iframe>");
	
	/* Stops us triggering the auto next button code on log in pages */
	$(".faqQuestion").keypress(
		function(e) {
			var keycode;
			if (window.event) {//IE
				keycode = window.event.keyCode;
			}else if (e) {  //FF
				keycode = e.which;
			}else {
				return false;
			}
			if(keycode==13){
				$(".faqForm").submit();
				return false;   // stops propagating keypress event
			}
		}
	);
	
	$(".faqForm").submit(
		function() {
			window.open("",windowname,"top=70,left=100,width=600,height=615,resizable=yes,scrollbars=yes");
			$(".faqForm").attr("target",windowname);
			
			if (typeof(inquiraAvailable) != 'undefined' && !inquiraAvailable) {
				$(".faqForm").attr("action","https://www.ulsterbankanytimebanking.ie/help.aspx?id=" + faqPageId);
				$(".faqForm").attr("method","post");
			}
			
			return true;
		}
	);
	
	$(".faqQuestion").focus(
		function() {
			if (defaultQuestionFlag) {
				defaultQuestion = $(".faqQuestion").val();
				$(".faqQuestion").val("");
				defaultQuestionFlag = false;
			}
			$(".faqQuestion").select();
			if (inquiraCheckDone) {
				if (inquiraAvailable) {
					AnimatePanel(panelClosed, panelMaxWidth);
				}
			} 
			else 
			{
				$.ajax({
					type: "GET",
					url: "https://supportcentre.ulsterbank.ie/app/inquira_redirect/query/", 
					dataType: "script",
					async: false,
					success: function() 
					{
						clearTimeout(inquiraTimeout);
						inquiraCheckDone = true;
						if (!inquiraCallTimedOut)
							AnimatePanel(panelClosed, panelMaxWidth);
					}
				});
				inquiraTimeout = setTimeout("FAQFallback();",1500);
			}
		}
	);
	
	$(".faqQuestion").blur(
		function() {
			if (this.value == '') {
				this.value = (this.defaultValue ? this.defaultValue : '');
				defaultQuestionFlag = true;
			}
		}
	);
				

	$(".closeIframeAnchor").click(function() {
		$(".faqIframe").fadeOut("fast", function() {
			$(".box_faqPanel").animate({width: panelMinWidth}, "fast");
			$(".box_top_faqPanel").animate({width: panelMinWidth}, "fast");
		});
		panelClosed = true;
		$(".closeIframeAnchor").blur();
	});
	
	$(".helpLink").click(HelpLinkClick);
});

function HelpLinkClick() {
	helpID = faqPageId;
	
	if (typeof(inquiraAvailable) == 'undefined' || inquiraAvailable) {
		window.open("https://supportcentre.ulsterbank.ie/app/inquira_redirect/query/?page=search&brand=UBR&wc=" + faqWc + "&pageID=" + helpID,windowname,"top=70,left=100,width=600,height=615,resizable=yes,scrollbars=yes");
	} else {
		HelpLinkFallback();
	}
	return false;
}
 
function AnimatePanel(panelClosed, panelMaxWidth, panelExpandedHeight) {
	if (typeof(inquiraAvailable) != 'undefined' && inquiraAvailable == true) 
	{
		if (panelClosed) 
		{
			panelClosed = false;
			$(".faqIframe").attr("src","https://supportcentre.ulsterbank.ie/app/inquira_redirect/query/?page=list&brand=UBR&wc=" + faqWc + "&pageID=" + faqPageId + "&segmentCode=" + faqSegmentCode + "&ageCategory=" + faqAgeCategory);
			$(".box_faqPanel").animate({width: panelMaxWidth}, 'fast');
			$(".box_top_faqPanel").animate({width: panelMaxWidth}, 'fast', function() {
				$(".faqIframe").fadeIn("fast");
				$(".box_faqPanel").attr("overflow","auto");
			});
		}
	} else {
		FAQFallback();
	}
}

function FAQFallback() {
	inquiraCheckDone = true;
	inquiraAvailable = false;
	inquiraCallTimedOut = true;
	$(".faqForm").attr("action","https://www.ulsterbankanytimebanking.ie/help.aspx?id=" + faqPageId);
	if (typeof(inquiraTimeout) != 'undefined') {
		clearTimeout(inquiraTimeout);
	}
	$(".topFaqPanel").empty();
}

function FAQFormFallback() {
	inquiraCheckDone = true;
	inquiraAvailable = false;
	inquiraCallTimedOut = true;
	$(".faqForm").attr("action","https://www.ulsterbankanytimebanking.ie/help.aspx?id= + faqPageId");
	if (typeof(inquiraTimeout) != 'undefined') {
		clearTimeout(inquiraTimeout);
	}
	$(".faqForm").submit();
}

function HelpLinkFallback() {
	inquiraCheckDone = true;
	inquiraAvailable = false;
	inquiraCallTimedOut = true;
	window.open("https://www.ulsterbankanytimebanking.ie/help.aspx?id=" + faqPageId,"help","top=70,left=100,width=600,height=615,resizable=yes,scrollbars=yes");
	if (typeof(inquiraTimeout) != 'undefined') {
		clearTimeout(inquiraTimeout);
	}
}