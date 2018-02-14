<?xml version="1.0" encoding="UTF-8"?>
<!--À faire:
Bien ordonner les articles par date de parution en cas d'articles de mêmes auteurs = repenser l'organisation des règles. La faire après la règle sort? 
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs" version="2.0">

    <xsl:template match="/">
        <html>
            <head>
                <title>Bibliographie plus exhaustive du projet de thèse</title>
                <link rel="stylesheet" type="text/css"
                    href="../css/cssextern-a-jour.css"
                />
            </head>
            <front>
                <h3 class="biblio">Bibliographie plus exhaustive du projet de thèse</h3>
            </front>
            <body>
                <p class="biblio">
                    <xsl:apply-templates/>
                </p>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="tei:teiHeader"/>

    <xsl:template match="tei:listBibl">
        <xsl:for-each select="tei:biblStruct">
            <!--Pour trier par nom du premier auteur plutôt que par xml:id choisi par Zotero-->
            <!--Que faire quand il n'y a pas d'auteur (éditeur): voir
            https://stackoverflow.com/questions/3590194/xslsort-an-xml-file-using-multiple-elements-->
            <xsl:sort
                select="concat(translate(.//tei:author[1]/tei:surname, 'ÁÉÍÓÚ- ', 'AEIOU'), translate(.//tei:editor[1]/tei:surname, 'ÁÉÍÓÚ- ', 'AEIOU'), translate(.//tei:author[1]/tei:forename, 'ÁÉÍÓÚ- ', 'AEIOU'), translate(.//tei:editor[1]/tei:forename, 'ÁÉÍÓÚ- ', 'AEIOU'))"/>

            <!--Pour trier par nom du premier auteur plutôt que par xml:id choisi par Zotero-->

            <xsl:variable name="repetition_nom" select=".//tei:author[1]/tei:surname"/>


            <!--Si on est face à des actes de conférence,des artciles collectifs-->

            <xsl:if test="@type = 'conferencePaper'">
                <div class="entree">
                    <!--Nom du/des auteurs-->
                    <xsl:choose>
                        <!--éviter les doublets des noms (ne pas répéter le nom si l'auteur est cité plus haut-->
                        <xsl:when
                            test="preceding-sibling::tei:biblStruct//tei:author[1]/tei:surname = tei:biblStruct//tei:author[1]/tei:surname">
                            <span class="espace"/>
                            <xsl:text>-</xsl:text>
                            <span class="espace"/>
                        </xsl:when>
                        <!--éviter les doublets des noms-->

                        <!--Si l'auteur n'est pas cité plus haut-->
                        <xsl:otherwise>
                            <xsl:for-each select="tei:analytic/tei:author">
                                <span class="smallcaps">
                                    <xsl:value-of select="translate(./tei:surname, '-', ' ')"/>
                                </span>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="./tei:forename"/>

                                <!--Ajouter des virgules et "et" devant le dernier auteur d'un article s'il y en a plus d'un-->
                                <xsl:if test="following-sibling::tei:author">
                                    <xsl:if test="count(following-sibling::tei:author) > 1">
                                        <xsl:text>, </xsl:text>
                                    </xsl:if>
                                    <xsl:if test="count(following-sibling::tei:author) = 1">
                                        <xsl:text> et </xsl:text>
                                    </xsl:if>
                                </xsl:if>
                                <!--Règle qui permet d'ajouter "et" devant le dernier auteur d'un article s'il y en a plus d'un-->
                            </xsl:for-each>
                            <xsl:text>, </xsl:text>
                        </xsl:otherwise>
                        <!--Si l'auteur n'est pas cité plus haut-->
                    </xsl:choose>
                    <!--Nom du/des auteurs-->

                    <!--Titre-->
                    <xsl:text>"</xsl:text>
                    <xsl:value-of select="tei:analytic/tei:title[@level = 'a']"/>
                    <xsl:text>"</xsl:text>
                    <!--Titre-->

                    <xsl:text>, </xsl:text>

                    <!--Publication-->
                    <i>in: </i>
                    <!--Éditeurs-->
                    <xsl:for-each select="tei:monogr/tei:editor">
                        <span class="smallcaps">
                            <xsl:value-of select="translate(./tei:surname, '-', ' ')"/>
                        </span>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="./tei:forename"/>
                        <xsl:if test="count(following-sibling::tei:editor) > 1">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                        <xsl:if test="count(following-sibling::tei:editor) = 1">
                            <xsl:text> et </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                    <!--Éditeurs-->
                    <xsl:text> (dir.), </xsl:text>
                    <!--Titre-->
                    <i>
                        <xsl:value-of select="tei:monogr/tei:title[@level = 'm']"/>
                    </i>
                    <!--Titre-->
                    <!--Publication-->

                    <!--Lieu de publication-->
                    <xsl:if test=".//tei:imprint/tei:pubPlace">
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select=".//tei:imprint/tei:pubPlace"/>
                    </xsl:if>
                    <!--Lieu de publication-->

                    <!--Maison d'édition-->
                    <xsl:if test=".//tei:imprint/tei:publisher">
                        <xsl:text> : </xsl:text>
                        <xsl:value-of select=".//tei:imprint/tei:publisher"/>
                    </xsl:if>
                    <!--Maison d'édition-->

                    <!--Date-->
                    <xsl:if test="//tei:imprint/tei:date">
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select=".//tei:imprint/tei:date"/>
                    </xsl:if>
                    <!--Date-->
                    <xsl:text>.</xsl:text>
                </div>
            </xsl:if>

            <!--Si on est face à des actes de conférence,des artciles collectifs-->

            <!--Si on est face à des articles-->

            <xsl:if test="@type = 'journalArticle'">
                <div class="entree">
                    <!--Auteur/auteurs/autrices/autrice-->
                    <xsl:choose>
                        <xsl:when
                            test="preceding-sibling::tei:biblStruct//tei:author[1]/tei:surname = $repetition_nom">
                            <span class="espace"/>
                            <xsl:text>-</xsl:text>
                            <span class="espace"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each select="tei:analytic/tei:author">
                                <span class="smallcaps">
                                    <xsl:value-of select="translate(./tei:surname, '-', ' ')"/>
                                </span>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="./tei:forename"/>
                                <xsl:if test="count(following-sibling::tei:author) > 1">
                                    <xsl:text>, </xsl:text>
                                </xsl:if>
                                <xsl:if test="count(following-sibling::tei:author) = 1">
                                    <xsl:text> et </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                            <xsl:text>, </xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                    <!--Auteur/auteurs/autrices/autrice-->

                    <!--Titre-->
                    <xsl:text>"</xsl:text>
                    <xsl:value-of select="tei:analytic/tei:title[@level = 'a']"/>
                    <xsl:text>"</xsl:text>
                    <!--Titre-->



                    <!--Titre de la revue: la condition est nécessaire pour l'apparition ou non de la virgule-->
                    <xsl:if test=".//tei:title[@level != 'a']">
                        <xsl:text>, </xsl:text>
                        <i>
                            <xsl:value-of select=".//tei:title[@level = 'j']"/>
                            <xsl:value-of select=".//tei:title[@level = 'm']"/>
                        </i>
                    </xsl:if>
                    <!--Titre de la revue-->

                    <!--Volume/numéro-->
                    <xsl:if test=".//tei:biblScope[@unit = 'volume']">
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select=".//tei:biblScope[@unit = 'volume']"/>
                    </xsl:if>
                    <xsl:if test="number(.//tei:biblScope[@unit = 'issue']) > 0">
                        <xsl:text>-</xsl:text>
                        <xsl:value-of select=".//tei:biblScope[@unit = 'issue']"/>
                    </xsl:if>
                    <!--Volume/numéro-->

                    <!--Date-->
                    <xsl:if test=".//tei:imprint/tei:date">
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select=".//tei:imprint/tei:date"/>
                    </xsl:if>
                    <!--Date-->

                    <!--Numéro de page-->
                    <xsl:if test=".//tei:biblScope[@unit = 'page']">
                        <xsl:text>, p. </xsl:text>
                        <xsl:value-of select=".//tei:biblScope[@unit = 'page']"/>
                    </xsl:if>
                    <!--Numéro de page-->
                    <xsl:text>. </xsl:text>
                </div>
            </xsl:if>

            <!--Si on est face à des articles-->

            <!--Si on est face à des livres, des pages web, des thèses-->

            <xsl:if
                test="@type = 'book' or @type = 'webpage' or @type = 'blogPost' or @type = 'thesis'">
                <div class="entree">
                    <!--Noms/prénoms du/des auteurs-->
                    <xsl:choose>
                        <!--Si l'auteur est déjà cité plus haut: ne pas répéter le nom/prénom de l'auteur 
                            (cas de l'éditeur à rajouter, mais plus rare)-->
                        <xsl:when
                            test="preceding-sibling::tei:biblStruct//tei:author[1]/tei:surname = $repetition_nom">
                            <span class="espace"/>
                            <xsl:text>-</xsl:text>
                            <span class="espace"/>
                        </xsl:when>
                        <!--Si l'auteur est déjà cité plus haut-->

                        <!--Si c'est la première occurrence de l'auteur: écrire le nom/prénom-->
                        <xsl:otherwise>
                            <xsl:choose>
                                <!--Quand il y a un auteur-->
                                <xsl:when test="tei:monogr/tei:author">
                                    <xsl:for-each select="tei:monogr/tei:author">
                                        <span class="smallcaps">
                                            <xsl:value-of
                                                select="translate(./tei:surname, '-', ' ')"/>
                                        </span>
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="./tei:forename"/>
                                        <xsl:if test="following-sibling::tei:author">
                                            <xsl:if test="count(following-sibling::tei:author) > 1">
                                                <xsl:text>, </xsl:text>
                                            </xsl:if>
                                            <xsl:if test="count(following-sibling::tei:author) = 1">
                                                <xsl:text> et </xsl:text>
                                            </xsl:if>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:when>
                                <!--Quand il y a un auteur-->

                                <!--Quand il n'y a qu'un éditeur-->
                                <xsl:otherwise>
                                    <xsl:for-each select="tei:monogr/tei:editor">
                                        <span class="smallcaps">
                                            <xsl:value-of
                                                select="translate(./tei:surname, '-', ' ')"/>
                                        </span>
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="./tei:forename"/>
                                        <xsl:if test="following-sibling::tei:editor">
                                            <xsl:variable name="nombre_editeur"
                                                select="count(following-sibling::tei:editor)"/>
                                            <xsl:if test="$nombre_editeur > 1">
                                                <xsl:text>, </xsl:text>
                                            </xsl:if>
                                            <xsl:if test="$nombre_editeur = 1">
                                                <xsl:text> et </xsl:text>
                                            </xsl:if>
                                        </xsl:if>
                                    </xsl:for-each>
                                    <xsl:choose>
                                        <xsl:when test="count(tei:monogr/tei:editor) = 1">
                                            <xsl:text> (éd.)</xsl:text>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text> (éds.)</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                                <!--Quand il n'y a qu'un éditeur-->
                            </xsl:choose>
                            <xsl:text>, </xsl:text>
                        </xsl:otherwise>
                        <!--Si c'est la première occurrence de l'auteur-->
                    </xsl:choose>
                    <!--Noms/prénoms du/des auteurs-->

                    <!--Titre-->
                    <xsl:if test="@type = 'webpage' or @type = 'blogPost'">
                        <xsl:text>"</xsl:text>
                        <xsl:value-of select="tei:monogr/tei:title"/>
                        <xsl:text>"</xsl:text>
                    </xsl:if>
                    <xsl:if test="@type = 'thesis'">
                        <xsl:text>"</xsl:text>
                        <xsl:value-of select="tei:monogr/tei:title[@level = 'm']"/>
                        <xsl:text>", thèse de doctorat</xsl:text>
                    </xsl:if>
                    <xsl:if test="@type = 'book'">
                        <i>
                            <xsl:value-of select="tei:monogr/tei:title[@level = 'm']"/>
                        </i>
                    </xsl:if>
                    <!--Titre-->

                    <!--Lieu de publication-->
                    <xsl:if test=".//tei:pubPlace">
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select=".//tei:pubPlace"/>
                    </xsl:if>
                    <!--Lieu de publication-->

                    <!--Gestion de la ponctuation en fonction des informations données-->
                    <xsl:if test=".//tei:publisher and .//tei:pubPlace">
                        <xsl:text> :</xsl:text>
                    </xsl:if>
                    <xsl:if test=".//tei:publisher and not(.//tei:pubPlace)">
                        <xsl:text>, </xsl:text>
                    </xsl:if>
                    <!--Gestion de la ponctuation en fonction des informations données-->
                    
                    <!--Maison d'édition-->
                    <xsl:if test=".//tei:publisher">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select=".//tei:publisher"/>
                    </xsl:if>
                    <!--Maison d'édition-->


                    <!--URL de l'article + date de lecture si article publié en ligne-->
                    <xsl:if test="@type = 'webpage' or @type = 'blogPost'">
                        <xsl:text>, </xsl:text>
                        <xsl:element name="a">
                            <xsl:attribute name="href">
                                <xsl:value-of select="tei:monogr//tei:note[@type = 'url']"/>
                            </xsl:attribute>
                            <xsl:value-of select="tei:monogr//tei:note[@type = 'url']"/>
                        </xsl:element>
                        <xsl:text>, lu le </xsl:text>
                        <xsl:value-of select="tei:monogr//tei:note[@type = 'accessed']"/>
                    </xsl:if>
                    <!--URL de l'article + date de lecture si article publié en ligne-->

                    <!--Date-->
                    <xsl:if test=".//tei:imprint/tei:date">
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select=".//tei:imprint/tei:date"/>
                    </xsl:if>
                    <!--Date-->

                    <xsl:text>.</xsl:text>

                </div>
            </xsl:if>
            <!--Si on est face à des livres, des pages web, des thèses-->

        </xsl:for-each>


    </xsl:template>

</xsl:stylesheet>
