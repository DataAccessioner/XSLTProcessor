<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:da="http://dataaccessioner.org/schema/dda-0-3-1" xmlns:premis="info:lc/xmlns/premis-v2" version="1.0">
  <xsl:output method="text" encoding="UTF-8" omit-xml-declaration="yes" />
  <xsl:strip-space elements="*"/>
  <xsl:template match="/">"directory path","file name","last modified","size (bytes)","md5","file format"
<xsl:for-each select="//da:file">"<xsl:for-each select="ancestor::da:folder"><xsl:value-of select="@name"/><xsl:text>/</xsl:text></xsl:for-each>","<xsl:value-of select="@name"/>","<xsl:value-of select="@last_modified"/>",<xsl:value-of select="@size"/>,"<xsl:value-of select="@MD5"/>","<xsl:value-of select="premis:object/premis:objectCharacteristics/premis:format/premis:formatDesignation/premis:formatName"/>"
</xsl:for-each>
  </xsl:template>
</xsl:stylesheet>