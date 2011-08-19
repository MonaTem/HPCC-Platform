<?xml version="1.0" encoding="UTF-8"?>
<!--
################################################################################
#    Copyright (C) 2011 HPCC Systems.
#
#    All rights reserved. This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as
#    published by the Free Software Foundation, either version 3 of the
#    License, or (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
################################################################################
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xml:space="default">
<xsl:param name="process" select="'unknown'"/>
  
<xsl:strip-space elements="*"/>
<xsl:output method="text" indent="no" omit-xml-declaration="yes"/>
   
<xsl:template match="text()"/>
   
    <xsl:template match="/">
        <xsl:apply-templates select="Environment/Software/RoxieCluster[@name=$process]"/>
    </xsl:template>
   
   <xsl:template match="RoxieCluster">
      <xsl:if test="@name=$process"># roxievars file generated by roxievars_linux.xsl
export roxiedir=<xsl:call-template name="makeAbsolutePath"><xsl:with-param name="path" select="@directory"/></xsl:call-template>
export querydir=<xsl:call-template name="makeAbsolutePath"><xsl:with-param name="path" select="@queryDir"/></xsl:call-template>
export logdir=<xsl:choose>
                <xsl:when test="@logDir">
                    <xsl:call-template name="makeAbsolutePath"><xsl:with-param name="path" select="@logDir"/></xsl:call-template>
                </xsl:when>
                <xsl:otherwise>/c$/roxie_logs</xsl:otherwise>
            </xsl:choose>
       </xsl:if>
<xsl:variable name="MaxFilesOpen" select="2*(@maxLocalFilesOpen+@maxRemoteFilesOpen)"/>
<xsl:variable name="NumHandles">
    <xsl:choose>
        <xsl:when test="$MaxFilesOpen > 8192">
            <xsl:value-of select="$MaxFilesOpen"/>
        </xsl:when>
        <xsl:otherwise>8192</xsl:otherwise>
    </xsl:choose>
</xsl:variable>
export NUM_ROXIE_HANDLES=<xsl:value-of select="$NumHandles"/>
<xsl:if test="string(@SSHidentityfile) != ''">
export SSHidentityfile=<xsl:value-of select="@SSHidentityfile"/>
</xsl:if>
<xsl:if test="string(@SSHusername) != ''">
export SSHusername=<xsl:value-of select="@SSHusername"/>
</xsl:if>
<xsl:if test="string(@SSHpassword) != ''">
export SSHpassword=<xsl:value-of select="@SSHpassword"/>
</xsl:if>
<xsl:if test="string(@SSHtimeout) != ''">
export SSHtimeout=<xsl:value-of select="@SSHtimeout"/>
</xsl:if>
<xsl:if test="string(@SSHretries) != ''">
export SSHretries=<xsl:value-of select="@SSHretries"/>
</xsl:if>
<xsl:if test="string(@SSHsudomount) != ''">
export SSHsudomount=<xsl:value-of select="@SSHsudomount"/>
</xsl:if>
   </xsl:template>

    <xsl:template name="makeAbsolutePath">
        <xsl:param name="path"/>
        <xsl:variable name="newPath" select="translate($path, '\:', '/$')"/>
       <xsl:if test="not(starts-with($newPath, '/'))">/</xsl:if>            
       <xsl:value-of select="$newPath"/>
    </xsl:template>

</xsl:stylesheet>
