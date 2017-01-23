<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:da="http://dataaccessioner.org/schema/dda-1-1"
                xmlns:premis="info:lc/xmlns/premis-v2" version="1.0">
  <xsl:output method="text" encoding="UTF-8" omit-xml-declaration="yes"/>
  <xsl:strip-space elements="*"/>
  <xsl:variable name="eol" select="'&#10;'"/>
  <xsl:template match="/">
    <xsl:text>"directory path","file name","file extension","last modified","size (bytes)","md5","file format","format version","format registry key/PUID","Identified By","MIME Type","ID Warning"</xsl:text>
    <xsl:value-of select="$eol"/>
    <xsl:for-each select="//da:file">
      <!-- directory path -->
      <xsl:text>"</xsl:text>
      <xsl:for-each select="ancestor::da:folder">
        <xsl:value-of select="@name"/>
        <xsl:text>/</xsl:text>
      </xsl:for-each>
      <xsl:text>",</xsl:text>

      <!-- file name -->
      <xsl:text>"</xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text>",</xsl:text>

      <!-- file extension -->
      <xsl:text>"</xsl:text>
      <xsl:variable name="extension">
        <xsl:call-template name="get-file-extension">
          <xsl:with-param name="path" select="@name" />
        </xsl:call-template>
      </xsl:variable>
      <xsl:value-of select="$extension"/>
      <xsl:text>",</xsl:text>

      <!-- last modified -->
      <xsl:text>"</xsl:text>
      <xsl:value-of select="@last_modified"/>
      <xsl:text>",</xsl:text>

      <!-- size (bytes) -->
      <xsl:text>"</xsl:text>
      <xsl:value-of select="@size"/>
      <xsl:text>",</xsl:text>

      <!-- md5 -->
      <xsl:text>"</xsl:text>
      <xsl:value-of select="@MD5"/>
      <xsl:text>",</xsl:text>

      <!-- file format -->
      <xsl:text>"</xsl:text>
      <xsl:value-of select="premis:object/premis:objectCharacteristics/premis:format/premis:formatDesignation/premis:formatName"/>
      <xsl:text>",</xsl:text>

      <!-- format version -->
      <xsl:text>"</xsl:text>
      <xsl:value-of select="premis:object/premis:objectCharacteristics/premis:format/premis:formatDesignation/premis:formatVersion"/>
      <xsl:text>",</xsl:text>

      <!-- format registry key/PUID -->
      <xsl:text>"</xsl:text>
      <xsl:value-of select="premis:object/premis:objectCharacteristics/premis:format/premis:formatRegistry/premis:formatRegistryKey"/>
      <xsl:text>",</xsl:text>

      <!-- Identified by -->
      <xsl:text>"</xsl:text>
      <xsl:value-of select="substring(premis:object/premis:objectCharacteristics/premis:format/premis:formatNote[starts-with(text(), 'Identified by:')][1], 16)"/>
      <xsl:text>",</xsl:text>

      <!-- MIME Type -->
      <xsl:text>"</xsl:text>
      <xsl:value-of select="translate(premis:object/premis:objectCharacteristics/premis:format/premis:formatNote[1], ',', '')"/>
      <xsl:text>",</xsl:text>

      <!-- ID Warning -->
      <xsl:text>"</xsl:text>
      <xsl:for-each select="premis:object/premis:objectCharacteristics/premis:format/premis:formatNote[contains(., 'Identification Warning')]">
        <xsl:value-of select="."/>
        <xsl:if test="not(position() = last())">
          <xsl:text>|</xsl:text>
        </xsl:if>
      </xsl:for-each>
      <xsl:text>"</xsl:text>

      <xsl:value-of select="$eol"/>
    </xsl:for-each>
    <xsl:value-of select="$eol"/>
  </xsl:template>

  <!-- Get file extension -->
  <xsl:template name="get-file-extension">
    <xsl:param name="path"/>
    <xsl:choose>
        <xsl:when test="contains($path, '/')">
            <xsl:call-template name="get-file-extension">
                <xsl:with-param name="path" select="substring-after($path, '/')"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($path, '.')">
            <xsl:call-template name="getlastdot">
                <xsl:with-param name="tempstr" select="substring-after($path, '.')"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text/>
        </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="getlastdot">
    <xsl:param name="tempstr" />
    <xsl:choose>
      <xsl:when test="contains($tempstr, '.')">
        <xsl:call-template name="getlastdot">
          <xsl:with-param name="tempstr" select="substring-after($tempstr, '.')" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$tempstr" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>