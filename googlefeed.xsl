<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
  <?xml version="1.0"?>
  <rss version="2.0"
  xmlns:g="http://base.google.com/ns/1.0">
  <channel>
  <title>The name of your data feed</title>
  <link>http://www.example.com</link>
  <description>A description of your content</description>
    <xsl:for-each select="//object">
      <item>
        <title> <xsl:value-of select="@name"/> </title>
        <link> http://www.example.com/item1-info-page.html</link>
        <description> <xsl:value-of select="@description"/> </description>
        <g:image_link>http://www.example.com/image1.jpg</g:image_link>
        <g:price> <xsl:value-of select="@price"/> </g:price>
        <g:condition> <xsl:value-of select="@condition"/> </g:condition>
        <g:id> <xsl:value-of select="@id"/> </g:id>
      </item>
    </xsl:for-each>
  </channel>
  </rss>
</xsl:template>

</xsl:stylesheet>
