# TEI_to_These 
Ce dépôt Github contient les fichiers permettant de mettre en page un document scientifique, article, mémoire ou thèse, en LaTeX, à partir d'un fichier XML encodé selon les normes XML-TEI/P5. 

Les fichiers LaTeX sont configurés et fonctionnels; ils devraient permettre d'afficher ce que nécessite un article de revue ou de journal en sciences humaines. La transformation du document XML via la feuille de transformation XSL, puis la compilation par un éditeur LaTeX, sont fonctionnelles. Attention, certains chemins indiqués dans les différents fichiers sont absolus et non relatifs, le package subfile supportant apparement mal les chemins relatifs. Je tâcherai de résoudre ce problème plus tard.  

Le document LaTeX est divisé en plusieurs sous-documents, pour permettre de séparer au mieux les types de fichier:
* le document principal, Projet_de_these.tex, qui renvoie aux sous-documents suivants au moyen de la fonction \input{chemin} (package *subfile*):
  * le préambule dans un dossier du même nom, qui renvoie lui-même à: 
    * la bibliographie dans un dossier séparé du même nom, dans un fichier au format .tex
  * le corps du document: c'est le fichier de sortie de la transformation xsl. 


### Utilisation du dossier

Pour configurer votre dossier, il suffit de transformer votre document .xml (dans le dossier du même nom) _valide_ avec la feuille de transformation dans /XSL, et de désigner le dossier /Sortie_LaTeX/corps comme dossier de sortie du document dans votre éditeur XML. Ne pas oublier de changer les chemins !

Les noms de dossier et de fichiers sont arbitraire et peuvent être changés, mais cette structure me semble être la plus claire possible. Chaque type d'information est ainsi dans un document séparé, et les modifications sont facilitées. 
