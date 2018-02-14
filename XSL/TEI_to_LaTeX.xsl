<?xml version="1.0" encoding="ISO-8859-1"?>
<!--<?xml version="1.0" encoding="UTF-8"?>-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="text" omit-xml-declaration="no" encoding="ISO-8859-1"/>


    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:head"/>
    <xsl:template match="tei:teiHeader"/>


    <!--Structure du texte-->
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
    <!--Structure du texte-->


    <xsl:template match="tei:p">
        <xsl:text>
            
        </xsl:text>
        <xsl:if test="@rend = 'sans_indentation'">
            <xsl:text>\noindent </xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:title">
        <xsl:choose>
            <xsl:when test="parent::tei:hi">
                <xsl:text>``</xsl:text>
                <xsl:value-of select="."/>
                <xsl:text>''</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>\textit{</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>}</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:note">
        <xsl:text>\footnote{</xsl:text>
        <xsl:apply-templates/>
        <xsl:if test="not(ends-with(., '.'))">
            <xsl:text>.</xsl:text>
        </xsl:if>
        <!--<xsl:if test="not(text())">
            <xsl:text>.</xsl:text>
        </xsl:if>-->
        <xsl:text>}</xsl:text>
    </xsl:template>

    <xsl:template match="tei:abbr">
        <xsl:apply-templates/>
    </xsl:template>


    <xsl:template match="tei:ref">
        <xsl:if test="@target = 'biblio.biblatex'">
            <xsl:text>~ \printbibliography[heading=secbib]</xsl:text>
        </xsl:if>
        <xsl:if test="@type = 'url'">
            <xsl:text>\href{</xsl:text>
            <xsl:variable name="echappement1" select="replace(@target, '#', '\\#')"/>
            <xsl:value-of select="replace($echappement1, '_', '\\_')"/>
            <xsl:text>}</xsl:text>
            <xsl:text>{</xsl:text>
            <xsl:choose>
                <xsl:when test="text()">
                    <xsl:value-of select="text()"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="replace($echappement1, '_', '\\_')"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>}</xsl:text>
        </xsl:if>
        <xsl:if test="@type = 'bibl'">
            <xsl:choose>
                <xsl:when test="not(preceding-sibling::text()[1])">
                    <xsl:text>\textsuperscript{,}\footnote{\cite</xsl:text>
                    <xsl:if test="tei:measure">
                        <xsl:text>[</xsl:text>
                        <xsl:value-of select="tei:measure/text()"/>
                        <xsl:text>]</xsl:text>
                    </xsl:if>
                    <xsl:text>{</xsl:text>
                    <xsl:value-of select="@n"/>
                    <xsl:text>}.}</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="parent::tei:note">
                            <xsl:text> \cite</xsl:text>
                            <xsl:if test="tei:measure">
                                <xsl:text>[</xsl:text>
                                <xsl:value-of select="tei:measure/text()"/>
                                <xsl:text>]</xsl:text>
                            </xsl:if>
                            <xsl:text>{</xsl:text>
                            <xsl:value-of select="@n"/>
                            <xsl:text>}.</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>\footnote{\cite</xsl:text>
                            <xsl:if test="tei:measure">
                                <xsl:text>[</xsl:text>
                                <xsl:value-of select="tei:measure/text()"/>
                                <xsl:text>]</xsl:text>
                            </xsl:if>
                            <xsl:text>{</xsl:text>
                            <xsl:value-of select="@n"/>
                            <xsl:text>}.}</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
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

    <xsl:template match="tei:quote">
        <xsl:text>``</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>''</xsl:text>
    </xsl:template>

    <xsl:template match="tei:foreign">
        <xsl:text>\textit{</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>}</xsl:text>
    </xsl:template>

    <!--Mise en valeur d'un morceau de texte (car rapporté tel quel, ou car plus important que les autres-->
    <xsl:template match="tei:hi">
        <xsl:if test="@rend = 'italique'">
            <xsl:text>\textit{</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>}</xsl:text>
        </xsl:if>
        <xsl:if test="@rend = 'petites_capitales'">
            <xsl:text>\textsc{</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>}</xsl:text>
        </xsl:if>
    </xsl:template>
    <!--Mise en valeur d'un morceau de texte-->

    <!--Remplacements divers de chaînes de caractère, échappement de certains caractères spéciaux, etc-->
    <xsl:template match="text()">
        <xsl:variable name="v1" select="replace(., 'LaTeX', '\\LaTeX~')"/>
        <xsl:variable name="v2" select="replace($v1, '~ ', '~')"/>
        <xsl:value-of select="replace($v2, '&amp;', '\\&amp;')"/>
    </xsl:template>
    <!--Remplacements divers de chaînes de caractère-->

</xsl:stylesheet>
