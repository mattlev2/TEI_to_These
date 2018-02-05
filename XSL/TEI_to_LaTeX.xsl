<?xml version="1.0" encoding="ISO-8859-1"?>
<!--<?xml version="1.0" encoding="UTF-8"?>-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="text" omit-xml-declaration="no" encoding="ISO-8859-1"/>


    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:teiHeader"/>

    <xsl:template match="tei:div">
        <xsl:choose>
            <xsl:when test="@type = 'introduction'">
                <xsl:text>\section*{</xsl:text>
            </xsl:when>
            <xsl:when test="parent::tei:div">
                <xsl:text>\subsection{</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>\section{</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="tei:head"/>
        <xsl:text>}</xsl:text>
        <xsl:apply-templates/>
    </xsl:template>


    <xsl:template match="tei:p">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:title">
        <xsl:text>\textit{</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>}</xsl:text>
    </xsl:template>

    <xsl:template match="tei:note">
        <xsl:text>\footnote{</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>}</xsl:text>
    </xsl:template>

    <xsl:template match="tei:ref">
        <xsl:if test="@target = 'biblio.biblatex'">
            <xsl:text>\printbibliography</xsl:text>
        </xsl:if>
        <xsl:if test="@type = 'url'">
            <xsl:text>\url{</xsl:text>
            <xsl:value-of select="@target"/>
            <xsl:text>}</xsl:text>
        </xsl:if>
        <xsl:if test="@type = 'bibl'">
            <xsl:text>\cite</xsl:text>
            <xsl:if test="tei:measure">
                <xsl:text>[</xsl:text>
                <xsl:value-of select="tei:measure/text()"/>
                <xsl:text>]</xsl:text>
            </xsl:if>
            <xsl:text>{</xsl:text>
            <xsl:value-of select="@n"/>
            <xsl:text>}</xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="tei:list">
        <xsl:text>
            \begin{itemize}</xsl:text>
        <xsl:for-each select="tei:item">
            <xsl:text>\item </xsl:text>
            <xsl:apply-templates/>
        </xsl:for-each>
        <xsl:text>\end{itemize}</xsl:text>
    </xsl:template>

    <xsl:template match="tei:foreign">
        <xsl:text>\textit{</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>}</xsl:text>
    </xsl:template>

    <xsl:template match="tei:hi">
        <xsl:text>\textit{</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
    </xsl:template>
    <!--Liste des éléments à transformer:

        -chaîne de caractères Latex > \LaTeX-->
</xsl:stylesheet>
