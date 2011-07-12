Last Updated: 8/28/2009

Install this control with install.bat or install.sh. 

You will also need to copy he body of the <xsl:stylesheet> node of 
Rhythmyx/rx_Resources/stylesheets/rx_Templates.xsl into the same file
of the Rhythmyx installation:  

$RHYTHMYX_HOME/rx_resources/stylesheets/rx_Templates.xsl

Only include the templates within the supporting templates section if 
they do not already exist within the file on the server.

This version of the control requires jQuery, which was included in a 
patch for 6.5.2. Please verify that this file exists: 

$RHYTHMYX_HOME/sys_resources/js/jquery/jquery.js

If it does not, apply the latest patch. All builds of 6.6 and 6.7 
should already include this file.  


