<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
     <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    
    <xsl:variable name="doc1" select="/" />
	<xsl:variable name="doc2" select="document('Rhythmyx/rx_resources/stylesheets/rx_Templates.xsl')" />
<!-- need a better way of preventing template conflicts -->
	<xsl:template match="xsl:stylesheet">
		<xsl:copy>
			<xsl:copy-of select="node()"/>
			  <xsl:if test="not(//xsl:template[@match=&quot;Control[@name='rx_DynamicDropDownSingle']&quot;])">
          			<xsl:copy-of select="$doc2/*/node()"/>			  
			  </xsl:if>
			
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>