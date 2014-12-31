<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:da="http://dataaccessioner.org/schema/dda-0-3-1" xmlns:premis="info:lc/xmlns/premis-v2" version="1.0">
  <xsl:output encoding="UTF-8" indent="yes" method="html" media-type="text/html" omit-xml-declaration="yes" doctype-system="about:legacy-compat"/>
  <xsl:template match="/">
    <html>
      <head>
      <xsl:if test="da:collection/@name != ''">
        <title>
          <xsl:value-of select="da:collection/@name"/>
        </title>
        </xsl:if>
        <style>
	.folder, .file {
	  margin-left: 4em; 
	  border: dashed 1px;
	}
	th {
  	text-transform: capitalize;
	}
	</style>
      </head>
      <body>
        <div id="container">
          <header>
			    </header>
          <div id="main">
            <xsl:for-each select="da:collection/da:accession">
              <div class="accession">
                <h2>Accession: <xsl:value-of select="@number"/></h2>
                <details open="true">
                  <summary>Disks/Folders &amp; Files</summary>
                  <xsl:apply-templates select="da:folder"/>
                  <xsl:apply-templates select="da:file"/>
                </details>
              </div>
            </xsl:for-each>
          </div>
          <footer>
			    </footer>
        </div>
        <!-- Javascript, when I get to it, at the bottom for fast page loading -->
      </body>
    </html>
  </xsl:template>

  <xsl:template match="da:folder">
    <div class="folder">
      <table>
        <xsl:for-each select="@*">
          <tr>
            <th>
              <xsl:value-of select="name()"/>
            </th>
            <td>
              <xsl:value-of select="."/>
            </td>
          </tr>
        </xsl:for-each>
      </table>
      <details open="true">
        <summary>Files &amp; Folders</summary>
        <xsl:apply-templates select="da:folder"/>
        <xsl:apply-templates select="da:file"/>
      </details>
    </div>
  </xsl:template>

  <xsl:template match="da:file">
    <div class="file">
      <table>
        <xsl:for-each select="@*">
          <tr>
            <th>
              <xsl:value-of select="name()"/>
            </th>
            <td>
              <xsl:value-of select="."/>
            </td>
          </tr>
        </xsl:for-each>
      </table>
      <xsl:apply-templates select="premis:object" />
    </div>
  </xsl:template>
  
  <xsl:template match="premis:object">

  <details><summary>PREMIS Metadata</summary>
  <xsl:if test="premis:objetIdentifier">

  <h3>Identifiers</h3>
  <table>

  <xsl:for-each select="premis:objetIdentifier"><tr><td><xsl:value-of select="premis:objectIdentifierType" /></td><td><xsl:value-of select="premis:objectIdentifierValue" /></td></tr></xsl:for-each></table></xsl:if>
  <xsl:if test="premis:objectCharacteristics/premis:fixity">

  <h3>Fixity</h3>

  <table>

  <xsl:for-each select="premis:objectCharacteristics/premis:fixity"><tr><td><xsl:value-of select="premis:messageDigestAlgorithm" /></td><td><xsl:value-of select="premis:messageDigest" /></td><td><xsl:value-of select="premis:messageDigestOriginator" /></td></tr></xsl:for-each>

  </table></xsl:if>

  <xsl:if test="premis:objectCharacteristics/premis:format">

  <h3>Formats</h3>

  <table>

  <xsl:for-each select="premis:objectCharacteristics/premis:format"><tr>
    <td><xsl:value-of select="premis:formatDesignation/premis:formatName" /></td>
    <td><xsl:value-of select="premis:formatRegistry/premis:formatRegistryKey" /></td>
    <td><xsl:value-of select="premis:formatRegistry/premis:formatRegistryName" /></td>
    <td><xsl:for-each select="premis:formatNote"><xsl:value-of select="text()" /><br /></xsl:for-each></td>
  </tr></xsl:for-each>

  </table></xsl:if>
  </details>

  </xsl:template>
</xsl:stylesheet>
