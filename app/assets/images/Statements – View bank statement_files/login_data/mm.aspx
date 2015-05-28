


var rowCollapsed = "0";
var rowExpanded = "1";


// Set the cursor on the specified elem to be the type indicated by cursorType
function setCursor( elem, cursorType ) {
	elem.style.cursor = cursorType;
}
// Inserts into or updates the given name and value pair in the Tracking package Cookie
//0 = rowCollapsed, 1 = rowExpanded
function emitTrackingCookie( name, value, cookiePackageName ) {
	// Retrieve the Tracking package Cookie from the document.cookie collection
	var newPackageValue = "";
	var cookiePackageValue = GetCookieValue(cookiePackageName);
	if (cookiePackageValue != undefined) {
		// Tracking package was found - find the given name in the package
		// Split the package contents into an Array of Name and Value pairs
		var packageArray = SplitTrackingPackage(cookiePackageValue);
		if (packageArray.length > 0) {
			// Find the given name in the Array
			var nameFound = false;
			for (var i = 0; i < packageArray.length; i++) {
				if (packageArray[i] == name) {
					// The given name has been found, update the value
					packageArray[i+1] = value;
					nameFound = true;
					break;
				}
				// Skip the Value slot in the array and move to the next Name element
				i++;
			}
			
			// Build the new Tracking package Value from the elements in the packageArray
			for (var i = 0; i < packageArray.length; i++) {
				var newPackageElement = packageArray[i] + "|" + packageArray[i+1];
				if (i == 0) {
					// First element in the package
					newPackageValue = newPackageElement;
				}
				else {
					newPackageValue = newPackageValue + "|" + newPackageElement;
				}
				// Skip the Value slot in the array and move to the next Name element
				i++;
			}
			
			// Finally, if the given name was not found in the package initially then insert it now
			if (nameFound == false) {
				newPackageValue = newPackageValue + "|" + name + "|" + value;
			}
		}
		else {
			// Tracking package was found but was empty - insert the given Name and Value separated by a pipe delimiter
			newPackageValue = name + "|" + value;
		}
	}
	else {
		// Tracking package wasn't found - create one now with the given Name and Value separated by a pipe delimiter
		newPackageValue = name + "|" + value;
	}

	// Emit the Tracking package Cookie
	document.cookie = cookiePackageName + "=" + newPackageValue;
}

// Takes the given Tracking package and converts the Name / Value pairs within into an Array
// The Name / Value pairs are delimited by the pipe character i.e. name1|value1|name2|value2 etc
function SplitTrackingPackage( trackingPackage ) {
	var packageArray;
	var numberOfElements = 0;
	// Get the number of individual elements in the package and create the packageArray
	var pos = 0;
	var startPos = 0;
	for (;startPos < trackingPackage.length;) {
		pos = trackingPackage.indexOf('|', startPos);
		numberOfElements++;
		if (pos == -1) {
			break;
		}
		else {
			startPos = pos + 1;
		}
	}

	// Initialise the packageArray
	packageArray = new Array(numberOfElements);
	var packageIndex = 0;
	if (numberOfElements > 0) {
		// Build the array from the elements found
		var lastElement = false;
		startPos = 0;
		while (!lastElement) {
			// Get the Name then Value in turn
			pos = trackingPackage.indexOf('|', startPos);
			if (pos == -1) {
				// No more elements found
				break;
			}
			// otherwise get the name
			var name = trackingPackage.substring(startPos, pos);
			startPos = pos + 1;
			// then get the value
			pos = trackingPackage.indexOf('|', startPos);
			var value;
			if (pos == startPos) {
				// Name has no value assigned
				value = '';
			}
			else {
				if (pos == -1) {
					// This is the last element
					lastElement = true;
					value = trackingPackage.substring(startPos, trackingPackage.length);
				}
				else {
					value = trackingPackage.substring(startPos, pos);
				}
			}
			startPos = pos + 1;
			
			// Insert the name and value into the packageArray
			packageArray[packageIndex] = name;
			packageIndex++;
			packageArray[packageIndex] = value;
			packageIndex++;
		}		
	}

	return packageArray;
}

// Walks through all Cookies in the document.cookie element and returns the value of the requested Cookie
// If the requested Cookie does not exist then undefined is returned
function GetCookieValue ( cookieName ) {
	var name, value;
	var returnValue = undefined;
	var beginning, middle, end;

	beginning = 0;    // start at the beginning of the cookie string
	while (beginning < document.cookie.length) 
	{     
		// find the next equal sign
		middle = document.cookie.indexOf('=', beginning);
		// find the next semicolon  
		end = document.cookie.indexOf(';', beginning);    
		if (end == -1)    // if no semicolon exists, it's the last cookie...
			end = document.cookie.length;
 
		// if nothing is in the cookie, blank out its value
		if ( (middle > end) || (middle == -1) ) 
		{  
			name = document.cookie.substring(beginning, end); 
			value = "";                                        
		} 
		else
		{  // extract out the name and value
			name = document.cookie.substring(beginning, middle);   
			value = document.cookie.substring(middle + 1, end);     
		}

		// If the current cookie is the one we asked for then return it's value
		if (name == cookieName) {
			returnValue = value;
			break;
		}
		
		// Otherwise, step over the next space to the beginning of next cookie
		beginning = end + 2;
	}

	return returnValue;
}
if (true)
document.write('<script type="text/javascript" src="https://www.ulsterbankanytimebanking.ie/brands/UBR/javascript/pa.js" ></scr' + 'ipt>');

// Inserts into or updates the given name and value pair in the Tracking package Cookie
//0 = JS disabled or no transactions, 1 = Open, 2 = Closed
function emitInitialCountCookie( name, value, cookiePackageName ) {
	// Retrieve the Tracking package Cookie from the document.cookie collection
	var newPackageValue = "";
	var cookiePackageValue = GetCookieValue(cookiePackageName);
	if (cookiePackageValue != undefined) {
		// Tracking package was found - find the given name in the package
		// Split the package contents into an Array of Name and Value pairs
		var packageArray = SplitTrackingPackage(cookiePackageValue);
		if (packageArray.length > 0) {
			// Find the given name in the Array
			var nameFound = false;
			for (var i = 0; i < packageArray.length; i++) {
				if (packageArray[i] == name) {
					// The given name has been found, update the value
					packageArray[i+1] = value;
					nameFound = true;
					break;
				}
				// Skip the Value slot in the array and move to the next Name element
				i++;
			}
			
			// Build the new Tracking package Value from the elements in the packageArray
			for (var i = 0; i < packageArray.length; i++) {
				var newPackageElement = packageArray[i] + "|" + packageArray[i+1];
				if (i == 0) {
					// First element in the package
					newPackageValue = newPackageElement;
				}
				else {
					newPackageValue = newPackageValue + "|" + newPackageElement;
				}
				// Skip the Value slot in the array and move to the next Name element
				i++;
			}
			
			// Finally, if the given name was not found in the package initially then insert it now
			if (nameFound == false) {
				newPackageValue = newPackageValue + "|" + name + "|" + value;
			}
		}
		else {
			// Tracking package was found but was empty - insert the given Name and Value separated by a pipe delimiter
			newPackageValue = name + "|" + value;
		}
	}
	else {
		// Tracking package wasn't found - create one now with the given Name and Value separated by a pipe delimiter
		newPackageValue = name + "|" + value;
	}

	// Emit the Tracking package Cookie
	document.cookie = cookiePackageName + "=" + newPackageValue;
}