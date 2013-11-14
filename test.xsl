<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
  <html>
  <body>
  <h2>My CD Collection</h2>
    <xsl:for-each select="//object">
    <p>
      <h1 class="id"> <xsl:value-of select="@id"/></td>
      <h1 class="type"><xsl:value-of select="@type"/></td>
    </p>
    </xsl:for-each>
  </body>
  </html>
</xsl:template>

</xsl:stylesheet>
