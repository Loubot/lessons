

function on(obj) {
    while (obj.tagName.toLowerCase() != "tr") { obj = obj.parentElement; } eval(obj).className = "dton";
}


function off(obj) {
    while (obj.tagName.toLowerCase() != "tr") { obj = obj.parentElement; } eval(obj).className = "dt";
}

function css(obj, css) {
    while (obj.tagName.toLowerCase() != "tr") { obj = obj.parentElement; } eval(obj).className = css;
}

function cssQT(obj, css) {
    eval(obj).className = css;
}

/* Fix flickering background images in IE6 */
try {
    document.execCommand("BackgroundImageCache", false, true);
} catch (err) { }


/* Following functions are required for rowOver on AS5*/
function onAccountRow(obj) {
    var siblingElement1 = obj.nextSibling;   
    while (obj.tagName.toLowerCase() != "tr") {
        obj = obj.parentElement;
        siblingElement1 = obj.nextSibling;        
    }
    eval(obj).className = changeClassName(obj, "dt", "dto", "dton");
    eval(obj).style.cursor = "pointer";
    eval(siblingElement1).className = eval(siblingElement1).className + "_on";

    var siblingElement2 = siblingElement1.nextSibling;   
    if (siblingElement2.id.substring(0, 10) == "AccountNBA") {
        eval(siblingElement2).className = changeClassName(siblingElement2, "dt", "dto", "dton");
    }
}

function offAccountRow(obj, css, nbacss) {
    var siblingElement1 = obj.nextSibling;    
    while (obj.tagName.toLowerCase() != "tr") {
        obj = obj.parentElement;
        siblingElement1 = obj.nextSibling;        
    }
    eval(obj).className = changeClassName(obj, "dton", "false", css);
    eval(siblingElement1).className = css + "_ad";

    var siblingElement2 = siblingElement1.nextSibling;
    if (siblingElement2.id.substring(0, 10) == "AccountNBA") {
        eval(siblingElement2).className = changeClassName(siblingElement2, "dton", "false", nbacss);
    }
    
}


if(false && true)
document.write('<script type="text/javascript" src="" ></scr' + 'ipt>'); 

function onAccountDetailsRow(obj) {
    var siblingElement1 = obj.previousSibling;
    
    while (obj.tagName.toLowerCase() != "tr") {
        obj = obj.parentElement;
        siblingElement1 = obj.previousSibling;
    }
    eval(obj).className = eval(obj).className + "_on";
    eval(siblingElement1).className = changeClassName(siblingElement1, "dt", "dto", "dton");

    var siblingElement2 = obj.nextSibling;
    if (siblingElement2.id.substring(0, 10) == "AccountNBA") {
        eval(siblingElement2).className = changeClassName(siblingElement2, "dt", "dto", "dton");
    }
}

function offAccountDetailsRow(obj, css, nbacss) {
    var siblingElement1 = obj.previousSibling;
    while (obj.tagName.toLowerCase() != "tr") {
        obj = obj.parentElement;
        siblingElement1 = obj.previousSibling;
    }
    eval(obj).className = css + "_ad";
    eval(siblingElement1).className = changeClassName(siblingElement1, "dton", "false", css);

    var siblingElement2 = obj.nextSibling;
    if (siblingElement2.id.substring(0, 10) == "AccountNBA") {
        eval(siblingElement2).className = changeClassName(siblingElement2, "dton", "false", nbacss);
    }
}

function onAccountNBARow(obj) {
    var siblingElement1 = obj.previousSibling;
    while (obj.tagName.toLowerCase() != "tr") {
        obj = obj.parentElement;
        siblingElement1 = obj.previousSibling;
    }
    eval(obj).className =  changeClassName(obj, "dt", "dto", "dton");
    eval(siblingElement1).className = eval(siblingElement1).className + "_on";

    var siblingElement2 = siblingElement1.previousSibling;
    eval(siblingElement2).className = changeClassName(siblingElement2, "dt", "dto", "dton");  
}

function offAccountNBARow(obj, css, nbacss) {
    var siblingElement1 = obj.previousSibling;
    while (obj.tagName.toLowerCase() != "tr") {
        obj = obj.parentElement;
        siblingElement1 = obj.previousSibling;
    }
    eval(obj).className = changeClassName(obj, "dton", "false", nbacss);
    eval(siblingElement1).className = css + "_ad";

    var siblingElement2 = siblingElement1.previousSibling;
    eval(siblingElement2).className = changeClassName(siblingElement2, "dton", "false", css);    
}

function changeClassName(obj, searchClass1, searchClass2, newClass) {
    var ClassNamesArray = eval(obj).className.split(" ");
    var classNames = "";
    for (var i = 0; i < ClassNamesArray.length; i++) {
        if (ClassNamesArray[i] == searchClass1 || ClassNamesArray[i] == searchClass2) {
            ClassNamesArray[i] = newClass;
        }

        if (i == ClassNamesArray.length - 1) {
            classNames = classNames + ClassNamesArray[i];
        }
        else {
            classNames = classNames + ClassNamesArray[i] + " ";
        }
    }
    return classNames;
}
if(false && true)
document.write('<script type="text/javascript" src="" ></scr' + 'ipt>');