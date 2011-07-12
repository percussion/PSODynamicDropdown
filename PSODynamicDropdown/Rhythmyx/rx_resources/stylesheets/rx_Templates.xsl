<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:psxctl="URN:percussion.com/control" xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="psxi18n" xmlns:psxi18n="urn:www.percussion.com/i18n" >

<!--  Supporting templates only add if they do not already exist -->
<xsl:template name="parametersToAttributes">
		<xsl:param name="controlClassName"/>
		<xsl:param name="controlNode"/>
		<xsl:param name="paramType" select="'generic'"/>
		<xsl:param name="source" select="document('')"/>
		<!-- apply any control parameter defaults defined in the metadata -->
		<xsl:apply-templates select="$source/*/psxctl:ControlMeta[@name=$controlClassName]/psxctl:ParamList/psxctl:Param[@paramtype=$paramType and psxctl:DefaultValue]" mode="internal">
			<xsl:with-param name="controlClassName" select="$controlClassName"/>
		</xsl:apply-templates>
		<!-- apply control parameters that have been defined in the metadata (will override defaults) -->
		<xsl:apply-templates select="$controlNode/ParamList/Param[@name = $source/*/psxctl:ControlMeta[@name=$controlClassName]/psxctl:ParamList/psxctl:Param[@paramtype=$paramType]/@name]" mode="internal">
			<xsl:with-param name="controlname" select="$controlNode/@paramName"/>
		</xsl:apply-templates>
	</xsl:template>
<xsl:template match="ParamList/Param[@name='alt']" mode="internal" priority="10">
		<xsl:param name="controlname"/>
		<xsl:variable name="keyval">
			<xsl:choose>
				<xsl:when test="@sourceType='sys_system'">
					<xsl:value-of select="concat('psx.ce.system.', $controlname, '.alt@', .)"/>
				</xsl:when>
				<xsl:when test="@sourceType='sys_shared'">
					<xsl:value-of select="concat('psx.ce.shared.', $controlname, '.alt@', .)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat('psx.ce.local.', /ContentEditor/@contentTypeId, '.', $controlname, '.alt@', .)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:attribute name="{@name}">
<xsl:call-template name="getLocaleString">
<xsl:with-param name="key" select="$keyval"/>
<xsl:with-param name="lang" select="$lang"/>
</xsl:call-template>
</xsl:attribute>
	</xsl:template>
<xsl:template match="ParamList/Param" mode="internal" priority="5">
		<xsl:attribute name="{@name}">
<xsl:value-of select="."/>
</xsl:attribute>
	</xsl:template>
<xsl:template match="psxctl:ParamList/psxctl:Param[@name='alt']" mode="internal" priority="10">
		<xsl:param name="controlClassName"/>
		<xsl:attribute name="{@name}">
<xsl:call-template name="getLocaleString">
<xsl:with-param name="key" select="concat('psx.contenteditor.sys_templates.',$controlClassName,'.alt@',psxctl:DefaultValue)"/>
<xsl:with-param name="lang" select="$lang"/>
</xsl:call-template>
</xsl:attribute>
	</xsl:template>
<xsl:template match="psxctl:ParamList/psxctl:Param" mode="internal" priority="5">
		<xsl:attribute name="{@name}">
<xsl:value-of select="psxctl:DefaultValue"/>
</xsl:attribute>
	</xsl:template>
<xsl:template name="parameterToValue">
		<xsl:param name="controlClassName"/>
		<xsl:param name="controlNode"/>
		<xsl:param name="paramName"/>
		<xsl:param name="source" select="document('')"/>
		<xsl:choose>
			<xsl:when test="$controlNode/ParamList/Param[@name = $paramName]">
				<!-- apply control parameters that have been defined in the metadata (will override defaults) -->
				<xsl:apply-templates select="$controlNode/ParamList/Param[@name = $paramName]" mode="internal-value"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- apply any control parameter defaults defined in the metadata -->
				<xsl:apply-templates select="$source/*/psxctl:ControlMeta[@name=$controlClassName]/psxctl:ParamList/psxctl:Param[@name=$paramName and psxctl:DefaultValue]" mode="internal-value"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
<xsl:template match="ParamList/Param" mode="internal-value">
		<xsl:value-of select="."/>
	</xsl:template>
<xsl:template match="psxctl:ParamList/psxctl:Param" mode="internal-value">
		<xsl:value-of select="psxctl:DefaultValue"/>
	</xsl:template>
<xsl:template name="getLocaleDisplayLabel">
		<xsl:param name="displayVal"/>
		<xsl:param name="sourceType"/>
		<xsl:param name="paramName"/>
		<xsl:variable name="keyval">
			<xsl:choose>
				<xsl:when test="$sourceType='sys_system'">
					<xsl:value-of select="concat('psx.ce.system.', $paramName, '@', $displayVal)"/>
				</xsl:when>
				<xsl:when test="@sourceType='sys_shared'">
					<xsl:value-of select="concat('psx.ce.shared.', $paramName, '@', $displayVal)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat('psx.ce.local.', /ContentEditor/@contentTypeId, '.', $paramName,             '@', $displayVal)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:call-template name="getLocaleString">
			<xsl:with-param name="key" select="$keyval"/>
			<xsl:with-param name="lang" select="$lang"/>
		</xsl:call-template>
	</xsl:template>

<!-- end supporting templates -->
	<!-- 
    rx_DynamicDropDownSingle
     
<!ATTLIST select
%attrs;
name        CDATA          #IMPLIED
size        %Number;       #IMPLIED
multiple    (multiple)     #IMPLIED
disabled    (disabled)     #IMPLIED
tabindex    %Number;       #IMPLIED
onfocus     %Script;       #IMPLIED
onblur      %Script;       #IMPLIED
onchange    %Script;       #IMPLIED
>
  -->
	<psxctl:ControlMeta name="rx_DynamicDropDownSingle" dimension="single" choiceset="required">
		<psxctl:Description>a drop down combo box for selecting a single value</psxctl:Description>
		<psxctl:ParamList>
			<psxctl:Param name="id" datatype="String" paramtype="generic">
				<psxctl:Description>This parameter assigns a name to an element. This name must be unique in a document.</psxctl:Description>
			</psxctl:Param>
			<psxctl:Param name="class" datatype="String" paramtype="generic">
				<psxctl:Description>This parameter assigns a class name or set of class names to an element. Any number of elements may be assigned the same class name or names. Multiple class names must be separated by white space characters.  The default value is "datadisplay".</psxctl:Description>
				<psxctl:DefaultValue>datadisplay</psxctl:DefaultValue>
			</psxctl:Param>
			<psxctl:Param name="style" datatype="String" paramtype="generic">
				<psxctl:Description>This parameter specifies style information for the current element. The syntax of the value of the style attribute is determined by the default style sheet language.</psxctl:Description>
			</psxctl:Param>
			<psxctl:Param name="size" datatype="Number" paramtype="generic">
				<psxctl:Description>If the element is presented as a scrolled list box, This parameter specifies the number of rows in the list that should be visible at the same time.</psxctl:Description>
			</psxctl:Param>
			<psxctl:Param name="multiple" datatype="String" paramtype="generic">
				<psxctl:Description>If set, this boolean attribute allows multiple selections. If not set, the element only permits single selections.</psxctl:Description>
			</psxctl:Param>
			<psxctl:Param name="tabindex" datatype="Number" paramtype="generic">
				<psxctl:Description>This parameter specifies the position of the current element in the tabbing order for the current document. This value must be a number between 0 and 32767.</psxctl:Description>
			</psxctl:Param>
			<psxctl:Param name="disabled" datatype="String" paramtype="generic">
				<psxctl:Description>If set, this boolean attribute disables the control for user input.</psxctl:Description>
			</psxctl:Param>
		   <psxctl:Param name="dlg_width" datatype="Number" paramtype="generic">
		      <psxctl:Description>This parameter specifies the width of the dialog box that is opened during field editing in Active Assembly.</psxctl:Description>
		      <psxctl:DefaultValue>400</psxctl:DefaultValue>
		   </psxctl:Param>
		   <psxctl:Param name="dlg_height" datatype="Number" paramtype="generic">
		      <psxctl:Description>This parameter specifies the height of the dialog box that is opened during field editing in Active Assembly.</psxctl:Description>
		      <psxctl:DefaultValue>125</psxctl:DefaultValue>
		   </psxctl:Param>
		   <psxctl:Param name="aarenderer" datatype="String" paramtype="generic">
		      <psxctl:Description>This parameter specifies whether the field editing in Active Assembly takes place in a modal dialog or in a popup. Applicable values are MODAL, POPUP and INPLACE_TEXT, any other value is treated as POPUP. The recommended values are MODAL and POPUP.</psxctl:Description>
		      <psxctl:DefaultValue>MODAL</psxctl:DefaultValue>
		   </psxctl:Param>
<psxctl:Param name="updategroup" datatype="String" paramtype="generic">
		      <psxctl:Description>This parameter specifies a group name.  Every field that specifies this group name will be updated when any of the other fields in the group are modified.</psxctl:Description>
		      <psxctl:DefaultValue>default</psxctl:DefaultValue>
		   </psxctl:Param>
		<psxctl:Param name="updateurl" datatype="String" paramtype="generic">
		      <psxctl:Description>This parameter specifies the url location of a lookup application conforming to the sys_Lookup.dtd.  The current form values are sent to the query and are available for use in filtering the results.</psxctl:Description>
		      <psxctl:DefaultValue>default</psxctl:DefaultValue>
		   </psxctl:Param>
		</psxctl:ParamList>
		<psxctl:AssociatedFileList>
		    <psxctl:FileDescriptor name="jquery.js" type="script" mimetype="text/javascript">
				<psxctl:FileLocation>../sys_resources/js/jquery/jquery.js</psxctl:FileLocation>
				<psxctl:Timestamp/>
			</psxctl:FileDescriptor>
			  <psxctl:FileDescriptor name="jquery.form.js" type="script" mimetype="text/javascript">
				<psxctl:FileLocation>../rx_resources/js/jquery/jquery.form.js</psxctl:FileLocation>
				<psxctl:Timestamp/>
			</psxctl:FileDescriptor>			
         <psxctl:FileDescriptor name="dynamicDropdown.js" type="script" mimetype="text/javascript">
            <psxctl:FileLocation>../rx_resources/js/dynamicDropdown.js</psxctl:FileLocation>
            <psxctl:Timestamp/>
         </psxctl:FileDescriptor>
      </psxctl:AssociatedFileList>
	</psxctl:ControlMeta>
	<xsl:template match="Control[@name='rx_DynamicDropDownSingle']" mode="psxcontrol">
		<xsl:variable name="updategroup">
			<xsl:choose>
				<xsl:when test="ParamList/Param[@name='updategroup']">
					<xsl:value-of select="ParamList/Param[@name='updategroup']"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="document('')/*/psxctl:ControlMeta[@name='rx_DynamicDropDownSingle']/psxctl:ParamList/psxctl:Param[@name='updategroup']/psxctl:DefaultValue"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="updateurl">
			<xsl:choose>
				<xsl:when test="ParamList/Param[@name='updateurl']">
					<xsl:value-of select="ParamList/Param[@name='updateurl']"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="document('')/*/psxctl:ControlMeta[@name='rx_DynamicDropDownSingle']/psxctl:ParamList/psxctl:Param[@name='updateurl']/psxctl:DefaultValue"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="name">
			<xsl:value-of select="@paramName"/>
		</xsl:variable>
		<div>
			<select name="{@paramName}" >
				<!-- following attribute required to trigger update -->
				<xsl:attribute name="onChange"><xsl:text>psoOptionUpdater.updateGroup('</xsl:text>
					<xsl:value-of select="$updategroup"/>
					<xsl:text>')</xsl:text>
				</xsl:attribute>
				<xsl:if test="@accessKey!=''">
					<xsl:attribute name="accesskey"><xsl:call-template name="getaccesskey"><xsl:with-param name="label" select="preceding-sibling::DisplayLabel"/><xsl:with-param name="sourceType" select="preceding-sibling::DisplayLabel/@sourceType"/><xsl:with-param name="paramName" select="@paramName"/><xsl:with-param name="accessKey" select="@accessKey"/></xsl:call-template></xsl:attribute>
				</xsl:if>
				<xsl:call-template name="parametersToAttributes">
					<xsl:with-param name="controlClassName" select="'rx_DynamicDropDownSingle'"/>
					<xsl:with-param name="controlNode" select="."/>
				</xsl:call-template>
				<xsl:apply-templates select="DisplayChoices" mode="psxcontrol-dynamicdropdownsingle">
					<xsl:with-param name="controlValue" select="Value"/>
					<xsl:with-param name="paramName" select="@paramName"/>
				</xsl:apply-templates>
			</select>
			<!-- following script tag is added to standard dropdown single control-->
			<script type="text/javascript"><xsl:text>psoOptionUpdater.addSelectToUpdateGroup("</xsl:text>
				<xsl:value-of select="$updategroup"/><xsl:text>","</xsl:text>
				<xsl:value-of select="$name"/><xsl:text>","</xsl:text>
				<xsl:value-of select="$updateurl"/><xsl:text>");</xsl:text>
			</script>
		</div>
	</xsl:template>
	<xsl:template match="DisplayChoices" mode="psxcontrol-dynamicdropdownsingle">
		<xsl:param name="controlValue"/>
		<xsl:param name="paramName"/>
		<!-- local/global and external can both be in the same control -->
		<!-- external is assumed to use a DTD compatible with sys_ContentEditor.dtd (items in <DisplayEntry>s) -->
		<xsl:apply-templates select="DisplayEntry" mode="psxcontrol-dynamicdropdownsingle">
			<xsl:with-param name="controlValue" select="$controlValue"/>
			<xsl:with-param name="paramName" select="$paramName"/>
		</xsl:apply-templates>
		<xsl:if test="string(@href)">
			<xsl:apply-templates select="document(@href)/*/DisplayEntry" mode="psxcontrol-dynamicdropdownsingle">
				<xsl:with-param name="controlValue" select="$controlValue"/>
				<xsl:with-param name="paramName" select="$paramName"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	<xsl:template match="DisplayEntry" mode="psxcontrol-dynamicdropdownsingle">
		<xsl:param name="controlValue"/>
		<xsl:param name="paramName"/>
		<option value="{Value}">
			<xsl:if test="Value = $controlValue">
				<xsl:attribute name="selected"><xsl:value-of select="'selected'"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="@selected='yes'">
				<xsl:attribute name="selected"><xsl:value-of select="'selected'"/></xsl:attribute>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="@sourceType">
					<xsl:call-template name="getLocaleDisplayLabel">
						<xsl:with-param name="sourceType" select="@sourceType"/>
						<xsl:with-param name="paramName" select="$paramName"/>
						<xsl:with-param name="displayVal" select="DisplayLabel"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="DisplayLabel"/>
				</xsl:otherwise>
			</xsl:choose>
		</option>
	</xsl:template>
	<!-- read only template for dropdown single -->
	<xsl:template match="Control[@name='rx_DynamicDropDownSingle' and @isReadOnly='yes']" priority="10" mode="psxcontrol">
		<div class="datadisplay">
			<xsl:variable name="Val" select="Value"/>
			<xsl:variable name="paramName" select="@paramName"/>
			<xsl:choose>
				<xsl:when test="not($Val)">
					<xsl:variable name="displayValue">
						<xsl:choose>
							<xsl:when test="DisplayChoices/DisplayEntry[@selected='yes']">
								<xsl:value-of select="DisplayChoices/DisplayEntry[@selected='yes']/DisplayLabel"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="DisplayChoices/DisplayEntry/DisplayLabel"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="@sourceType">
							<xsl:call-template name="getLocaleDisplayLabel">
								<xsl:with-param name="sourceType" select="@sourceType"/>
								<xsl:with-param name="paramName" select="$paramName"/>
								<xsl:with-param name="displayVal" select="$displayValue"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$displayValue"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="DisplayChoices/DisplayEntry[Value=$Val]">
						<xsl:choose>
							<xsl:when test="@sourceType">
								<xsl:call-template name="getLocaleDisplayLabel">
									<xsl:with-param name="sourceType" select="@sourceType"/>
									<xsl:with-param name="paramName" select="$paramName"/>
									<xsl:with-param name="displayVal" select="DisplayLabel"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="DisplayLabel"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</div>
		<input type="hidden" name="{@paramName}">
			<xsl:attribute name="value"><xsl:choose><xsl:when test="Value!=''"><xsl:value-of select="Value"/></xsl:when><xsl:when test="DisplayChoices/DisplayEntry[@selected='yes']"><xsl:value-of select="DisplayChoices/DisplayEntry[@selected='yes']/Value"/></xsl:when><xsl:otherwise><xsl:value-of select="DisplayChoices/DisplayEntry/Value"/></xsl:otherwise></xsl:choose></xsl:attribute>
		</input>
	</xsl:template>

	<xsl:template match="Control[@name='rx_DynamicDropDownSingle']" mode="psxcontrol-body-onload">
		<xsl:if test="not(preceding::Control[@name='rx_DynamicDropDownSingle'])">
			<xsl:text>psoOptionUpdater.updateAllGroups();</xsl:text>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
