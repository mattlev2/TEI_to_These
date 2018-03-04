<?xml version="1.0" encoding="ISO-8859-1"?>
<!--<?xml version="1.0" encoding="UTF-8"?>-->
<!--Esperluette sur et dans la biblio !!-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="text" omit-xml-declaration="no" encoding="ISO-8859-1"/>


    <xsl:template match="/">
        <xsl:text>\title{</xsl:text>
        <xsl:apply-templates select="/tei:TEI/tei:teiHeader//tei:titleStmt/tei:title"/>
        <xsl:text>\vspace{-6ex}}</xsl:text>
        <xsl:text>\begin{document}</xsl:text>
        <xsl:text>\auteur{</xsl:text>
        <xsl:value-of select="tei:TEI//tei:publisher/tei:persName"/>
        <xsl:text>\\</xsl:text>
        <xsl:value-of select="translate(tei:TEI//tei:publisher/tei:persName/@type, '_', ' ')"/>
        <xsl:text>}
       {\let\newpage\relax\maketitle}%voir https://tex.stackexchange.com/questions/86249/maketitle-text-before-title
       \legende{</xsl:text>
        <xsl:value-of select="//tei:sourceDesc/tei:p"/>
        <xsl:text>}</xsl:text>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:head"/>
    <!--Trouver un moyen d'appliquer les règles dans un head-->
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


    <!--Mise en page de la date-->
    <xsl:template match="tei:date">
        <xsl:text>\textsc{</xsl:text>
        <xsl:value-of select="text()"/>
        <xsl:text>}</xsl:text>
        <xsl:if test="tei:abbr">
            <xsl:text>\textsuperscript{</xsl:text>
            <xsl:value-of select="tei:abbr"/>
            <xsl:text>}</xsl:text>
        </xsl:if>
    </xsl:template>
    <!--Mise en page de la date-->

    <xsl:template match="tei:abbr">
                <xsl:apply-templates/>
    </xsl:template>

    <xsl:template name="titre" match="tei:title">
        <xsl:choose>
            <xsl:when test="parent::tei:hi">
                <xsl:text>``</xsl:text>
                <xsl:value-of select="."/>
                <xsl:text>''</xsl:text>
            </xsl:when>
            <xsl:when test="parent::tei:title">
                <xsl:text>}</xsl:text>
                <xsl:value-of select="."/>
                <xsl:text>\textit{</xsl:text>
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
        <!--Gérer la ponctuation: ajouter un point si il n'y en a pas en fin de note-->
        <xsl:if test="not(ends-with(., '.'))">
            <xsl:text>.</xsl:text>
        </xsl:if>
        <!--Gérer la ponctuation-->
        <xsl:text>}</xsl:text>
    </xsl:template>




    <xsl:template match="tei:ref">
        <xsl:if test="@target = 'biblio.biblatex'">
            <xsl:text>~ \printbibliography[heading=secbib]</xsl:text>
        </xsl:if>

        <!--gestion des lien de type url-->
        <xsl:if test="@type = 'url'">
            <!--Mettre les url sans texte de description en note de bas de page 
                [règle identique pour fermer la balise plus bas]-->
            <xsl:if test="not(text()) and not(parent::tei:note)">
                <xsl:text>\footnote{</xsl:text>
            </xsl:if>
            <!--Mettre les url sans texte de description en note de bas de page-->
            <xsl:text>\href{</xsl:text>
            <!--Échapper les caractères spéciaux pour les url-->
            <xsl:variable name="echappement1" select="replace(@target, '#', '\\#')"/>
            <xsl:value-of select="replace($echappement1, '_', '\\_')"/>
            <!--Échapper les caractères spéciaux pour les url-->
            <xsl:text>}</xsl:text>
            <xsl:text>{</xsl:text>
            <xsl:choose>
                <xsl:when test="node()">
                    <xsl:apply-templates/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="replace($echappement1, '_', '\\_')"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>}</xsl:text>
            <xsl:if test="not(text()) and not(parent::tei:note)">
                <xsl:text>}</xsl:text>
            </xsl:if>
        </xsl:if>
        <!--gestion des lien de type url-->

        <!--gestion des citations biblio-->
        <xsl:if test="@type = 'bibl'">
            <xsl:choose>
                <xsl:when test="not(parent::tei:note)">
                    <xsl:text> [</xsl:text>
                </xsl:when>
                <!--Gestion des espaces-->
                <xsl:otherwise>
                    <xsl:text> </xsl:text>
                </xsl:otherwise>
                <!--Gestion des espaces-->
            </xsl:choose>
            <xsl:text>\cite</xsl:text>
            <xsl:if test="tei:measure">
                <xsl:text>[</xsl:text>
                <xsl:value-of select="tei:measure/text()"/>
                <xsl:text>]</xsl:text>
            </xsl:if>
            <xsl:text>{</xsl:text>
            <xsl:value-of select="@n"/>
            <xsl:text>}</xsl:text>
            <xsl:if test="not(parent::tei:note)">
                <xsl:text>]</xsl:text>
            </xsl:if>
        </xsl:if>
        <!--gestion des citations biblio-->
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
        <xsl:call-template name="grand_remplacement"/>
        <xsl:text>}</xsl:text>
    </xsl:template>

    <!--Mise en valeur d'un morceau de texte (car rapporté tel quel, ou car plus important que les autres)-->
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
        <xsl:if test="@rend = 'brouillon'">
            <xsl:text>\textsc{\color{red}[</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>]\color{black}}</xsl:text>
        </xsl:if>
    </xsl:template>
    <!--Mise en valeur d'un morceau de texte-->

    <!--Remplacements divers de chaînes de caractère, échappement de certains caractères spéciaux, etc-->
    <xsl:template match="text()" name="grand_remplacement">
        <xsl:variable name="v1" select="replace(., 'LaTeX', '\\LaTeX~')"/>
        <xsl:variable name="v2" select="replace($v1, '~ ', '~')"/>
        <xsl:variable name="v3" select="replace($v2, '&amp;', '\\&amp;')"/>
        <xsl:value-of select="replace($v3, ' - ', ' -- ')"/>
    </xsl:template>
    <!--Remplacements divers de chaînes de caractère-->

</xsl:stylesheet>
