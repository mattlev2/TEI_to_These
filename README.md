# TEI_to_These

Ce dépôt Github contient les fichiers permettant de créer un article scientifique en LaTeX à partir d'un fichier XML encodé selon les normes XML-TEI/P5. Il est encore en cours de construction: il manque l'ODD et les schémas correspondants permettant de valider le document XML-base. 

Les fichiers LaTeX sont configurés et fonctionnels; ils devraient permettre d'afficher ce que nécessite un article de revue ou de journal en sciences humaines. La transformation du document XML via la feuille de transformation XSL, puis la compilation par un éditeur LaTeX, sont fonctionnelles. 

Le document LaTeX est divisé en plusieurs sous-documents, pour permettre de séparer au mieux les types de fichier:
* le document principal est Projet_de_these.tex, qui renvoie aux sous-documents suivants au moyen de la fonction \input (package *subfile*):
  * le préambule dans un dossier du même nom, qui renvoie elle-même à: 
   * la bibliographie dans un dossier séparé du même nom, dans un fichier au format .tex
  * le corps du document 
