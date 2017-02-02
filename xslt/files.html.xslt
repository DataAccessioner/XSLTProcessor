<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:da="http://dataaccessioner.org/schema/dda-1-1" xmlns:premis="info:lc/xmlns/premis-v2"
    xmlns:dcx="http://purl.org/dc/xml/" version="1.0">
    <xsl:output encoding="UTF-8" indent="yes" method="html" media-type="text/html"
        omit-xml-declaration="yes" doctype-system="about:legacy-compat"/>
    <xsl:template match="/">
        <html>
            <head>
                <xsl:if test="da:collection/@name != ''">
                    <title>
                        <xsl:value-of select="da:collection/@name"/>
                    </title>
                </xsl:if>
                <style>
                    .folder,
                    .file{
                        margin-left: 4em;
                        border: dashed 1px;
                    }
                    th{
                        text-transform: capitalize;
                        text-align: left;
                    }
                    td{
                        vertical-align: text-top;
                    }
                    table{
                        margin-bottom: 1em;
                    }</style>
            </head>
            <body>
                <div id="container">
                    <header> </header>
                    <div id="main">
                        <xsl:for-each select="da:collection/da:accession">
                            <div class="accession">
                                <h2>Accession: <xsl:value-of select="@number"/>
                                </h2>
                                <table>
                                    <xsl:if test="da:ingest_note">
                                        <tr>
                                            <th>Ingest Note</th>
                                            <td>
                                                <xsl:value-of select="da:ingest_note"/>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                    <xsl:if test="da:source_note">
                                        <tr>
                                            <th>Source Note</th>
                                            <td>
                                                <xsl:value-of select="da:source_note"/>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                    <xsl:if test="da:additional_notes">
                                        <tr>
                                            <th>Additional Notes</th>
                                            <td>
                                                <xsl:value-of select="da:additional_notes"/>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                    <tr>
                                        <th>Processing Duration</th>
                                        <td>
                                            <xsl:value-of select="da:ingest_time"/>
                                        </td>
                                    </tr>
                                </table>
                                <xsl:apply-templates select="dcx:description"/>
                                <details open="true">
                                    <summary>Disks/Folders &amp; Files</summary>
                                    <xsl:apply-templates select="da:folder"/>
                                    <xsl:apply-templates select="da:file"/>
                                </details>
                            </div>
                        </xsl:for-each>
                    </div>
                    <footer> </footer>
                </div>
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
            <xsl:apply-templates select="dcx:description"/>
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
            <xsl:apply-templates select="dcx:description"/>
            <xsl:apply-templates select="premis:object"/>
        </div>
    </xsl:template>

    <xsl:template match="premis:object">
        <details>
            <summary><strong>PREMIS Metadata</strong></summary>
            <xsl:if test="premis:objectIdentifier">
                <h4>Identifiers</h4>
                <table>
                    <xsl:for-each select="premis:objectIdentifier">
                        <tr>
                            <td>
                                <xsl:value-of select="premis:objectIdentifierType"/>
                            </td>
                            <td>
                                <xsl:value-of select="premis:objectIdentifierValue"/>
                            </td>
                        </tr>
                    </xsl:for-each>
                </table>
            </xsl:if>
            <xsl:if test="premis:objectCharacteristics/premis:fixity">
                <h4>Fixity</h4>
                <table>
                    <xsl:for-each select="premis:objectCharacteristics/premis:fixity">
                        <tr>
                            <td>
                                <xsl:value-of select="premis:messageDigestAlgorithm"/>
                            </td>
                            <td>
                                <xsl:value-of select="premis:messageDigest"/>
                            </td>
                            <td>
                                <xsl:value-of select="premis:messageDigestOriginator"/>
                            </td>
                        </tr>
                    </xsl:for-each>
                </table>
            </xsl:if>
            <xsl:if test="premis:objectCharacteristics/premis:format">
                <h4>Formats</h4>
                <table>
                    <xsl:for-each select="premis:objectCharacteristics/premis:format">
                        <tr>
                            <xsl:choose>
                                <xsl:when
                                    test="premis:formatDesignation/premis:formatName and premis:formatDesignation/premis:formatVersion">
                                    <th>Format/Version</th>
                                    <td>
                                        <xsl:value-of
                                            select="premis:formatDesignation/premis:formatName"/>
                                        <xsl:value-of
                                            select="premis:formatDesignation/premis:formatVersion"/>
                                    </td>
                                </xsl:when>
                                <xsl:when test="premis:formatDesignation/premis:formatName">
                                    <th>Format</th>
                                    <td>
                                        <xsl:value-of
                                            select="premis:formatDesignation/premis:formatName"/>
                                    </td>
                                </xsl:when>
                            </xsl:choose>
                        </tr>
                        <xsl:for-each
                            select="premis:formatNote[starts-with(text(), 'Identified by')]">
                            <tr>
                                <th>Identified by</th>
                                <td>
                                    <xsl:value-of select="substring(., 16)"/>
                                </td>
                            </tr>
                        </xsl:for-each>
                        <xsl:if test="premis:formatNote[starts-with(text(), 'DROID Identification Warning:')]">
                            <tr>
                                <th>Warning</th>
                                <td><xsl:value-of
                                    select="substring(premis:formatNote[starts-with(text(), 'DROID Identification Warning:')], 30)"/></td>
                            </tr>
                        </xsl:if>
                        <xsl:if test="premis:formatRegistry/premis:formatRegistryKey">
                            <tr>
                                <th>PUID/Registry</th>
                                <td><xsl:value-of
                                    select="premis:formatRegistry/premis:formatRegistryKey"/> (<xsl:value-of
                                        select="premis:formatRegistry/premis:formatRegistryName"/>)</td>
                            </tr>
                        </xsl:if>
                        <xsl:if test="premis:formatNote[1]">
                            <tr>
                                <th>MIME Type</th>
                                <td><xsl:value-of select="translate(premis:formatNote[1], ',', '')"/></td>
                            </tr>
                        </xsl:if>
                        <tr><th colspan="2">&#160;</th></tr>
                    </xsl:for-each>

                </table>
            </xsl:if>
        </details>
    </xsl:template>

    <xsl:template match="dcx:description">
        <h4>Description</h4>
        <table>
            <xsl:for-each select="*">
                <tr>
                    <th>
                        <xsl:value-of select="local-name()"/>
                    </th>
                    <td>
                        <xsl:value-of select="text()"/>
                    </td>
                </tr>
            </xsl:for-each>
        </table>
    </xsl:template>
</xsl:stylesheet>
