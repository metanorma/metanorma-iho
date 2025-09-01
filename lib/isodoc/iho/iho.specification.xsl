<?xml version="1.0" encoding="UTF-8"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:mn="https://www.metanorma.org/ns/standoc" xmlns:mnx="https://www.metanorma.org/ns/xslt" xmlns:mathml="http://www.w3.org/1998/Math/MathML" xmlns:xalan="http://xml.apache.org/xalan" xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" xmlns:java="http://xml.apache.org/xalan/java" xmlns:redirect="http://xml.apache.org/xalan/redirect" exclude-result-prefixes="java xalan" extension-element-prefixes="redirect" version="1.0">

	<xsl:output method="xml" encoding="UTF-8" indent="no"/>

	<xsl:key name="kfn" match="mn:fn[not(ancestor::*[self::mn:table or self::mn:figure or self::mn:localized-strings] and not(ancestor::mn:fmt-name))]" use="@reference"/>

	<xsl:variable name="debug">false</xsl:variable>

	<!-- Example:
		<item level="1" id="Foreword" display="true">Foreword</item>
		<item id="term-script" display="false">3.2</item>
	-->
	<xsl:variable name="contents_">
		<xsl:variable name="bundle" select="count(//mn:metanorma) &gt; 1"/>
		<xsl:for-each select="//mn:metanorma">
			<xsl:variable name="num"><xsl:number level="any" count="mn:metanorma"/></xsl:variable>
			<xsl:variable name="docidentifier"><xsl:value-of select="mn:bibdata/mn:docidentifier[@type = 'IHO']"/></xsl:variable>
			<xsl:variable name="docnumber_">
				<xsl:choose>
					<xsl:when test="ancestor::*[local-name() = 'doc-container'] and       (preceding::mn:metanorma/mn:bibdata/mn:docidentifier[@type = 'IHO'] = $docidentifier or       following::mn:metanorma/mn:bibdata/mn:docidentifier[@type = 'IHO'] = $docidentifier)">
						<xsl:variable name="doc_container_id" select="ancestor::*[local-name() = 'doc-container']/@id"/>
						<xsl:value-of select="ancestor::*[local-name() = 'metanorma-collection']//*[local-name() = 'entry'][@target = $doc_container_id]/*[local-name() = 'identifier']"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$docidentifier"/>
						<xsl:if test="normalize-space($docidentifier) = ''">
							<xsl:value-of select="mn:bibdata/mn:docidentifier[1]"/>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="docnumber" select="normalize-space($docnumber_)"/>
			<xsl:variable name="current_document">
				<xsl:copy-of select="."/>
			</xsl:variable>

			<xsl:for-each select="xalan:nodeset($current_document)"> <!-- <xsl:for-each select="."> -->
				<mnx:doc num="{$num}" firstpage_id="firstpage_id_{$num}" title-part="{$docnumber}" bundle="{$bundle}"> <!-- 'bundle' means several different documents (not language versions) in one xml -->
					<mnx:contents>
						<xsl:call-template name="processPrefaceSectionsDefault_Contents"/>
						<xsl:call-template name="processMainSectionsDefault_Contents"/>

						<xsl:call-template name="processTablesFigures_Contents"/>
					</mnx:contents>
				</mnx:doc>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="contents" select="xalan:nodeset($contents_)"/>

	<xsl:template name="layout-master-set">
		<fo:layout-master-set>
			<!-- cover page -->
			<fo:simple-page-master master-name="cover-page" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="0mm" margin-bottom="5mm" margin-left="0mm" margin-right="5mm"/>
			</fo:simple-page-master>

			<fo:simple-page-master master-name="first" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
				<fo:region-before region-name="header" extent="{$marginTop}mm"/>
				<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
			</fo:simple-page-master>
			<fo:simple-page-master master-name="odd" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
				<fo:region-before region-name="header-odd" extent="{$marginTop}mm"/>
				<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
			</fo:simple-page-master>
			<fo:simple-page-master master-name="odd-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
				<fo:region-before region-name="header-odd" extent="{$marginTop}mm"/>
				<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
			</fo:simple-page-master>
			<fo:simple-page-master master-name="even" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight2}mm" margin-right="{$marginLeftRight1}mm"/>
				<fo:region-before region-name="header-even" extent="{$marginTop}mm"/>
				<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight2}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight1}mm"/>
			</fo:simple-page-master>
			<fo:simple-page-master master-name="even-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight2}mm" margin-right="{$marginLeftRight1}mm"/>
				<fo:region-before region-name="header-even" extent="{$marginTop}mm"/>
				<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight2}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight1}mm"/>
			</fo:simple-page-master>
			<fo:simple-page-master master-name="blankpage" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight2}mm" margin-right="{$marginLeftRight1}mm"/>
				<fo:region-before region-name="header-blank" extent="{$marginTop}mm"/>
				<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight2}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight1}mm"/>
			</fo:simple-page-master>
			<fo:simple-page-master master-name="blankpage-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight2}mm" margin-right="{$marginLeftRight1}mm"/>
				<fo:region-before region-name="header-blank" extent="{$marginTop}mm"/>
				<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight2}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight1}mm"/>
			</fo:simple-page-master>
			<!-- Preface pages -->
			<fo:page-sequence-master master-name="preface">
				<fo:repeatable-page-master-alternatives>
					<!-- <fo:conditional-page-master-reference master-reference="first" page-position="first"/> -->
					<fo:conditional-page-master-reference master-reference="blankpage" blank-or-not-blank="blank"/>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="even"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			<fo:page-sequence-master master-name="preface-landscape">
				<fo:repeatable-page-master-alternatives>
					<fo:conditional-page-master-reference master-reference="blankpage-landscape" blank-or-not-blank="blank"/>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="even-landscape"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-landscape"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			<!-- Document pages -->
			<fo:page-sequence-master master-name="document">
				<fo:repeatable-page-master-alternatives>
					<fo:conditional-page-master-reference master-reference="blankpage" blank-or-not-blank="blank"/>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="even"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			<fo:page-sequence-master master-name="document-portrait">
				<fo:repeatable-page-master-alternatives>
					<fo:conditional-page-master-reference master-reference="blankpage" blank-or-not-blank="blank"/>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="even"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			<fo:page-sequence-master master-name="document-landscape">
				<fo:repeatable-page-master-alternatives>
					<fo:conditional-page-master-reference master-reference="blankpage-landscape" blank-or-not-blank="blank"/>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="even-landscape"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-landscape"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
		</fo:layout-master-set>
	</xsl:template> <!-- END: layout-master-set -->

	<xsl:template match="/">

		<fo:root xml:lang="{$lang}">
			<xsl:variable name="root-style">
				<root-style xsl:use-attribute-sets="root-style"/>
			</xsl:variable>
			<xsl:call-template name="insertRootStyle">
				<xsl:with-param name="root-style" select="$root-style"/>
			</xsl:call-template>

			<xsl:call-template name="layout-master-set"/>

			<fo:declarations>
				<xsl:call-template name="addPDFUAmeta"/>
			</fo:declarations>

			<xsl:call-template name="addBookmarks">
				<xsl:with-param name="contents" select="$contents"/>
			</xsl:call-template>

			<xsl:variable name="updated_xml">
				<xsl:call-template name="updateXML"/>
			</xsl:variable>

			<xsl:if test="$debug = 'true'">
				<redirect:write file="updated_xml.xml">
					<xsl:copy-of select="$updated_xml"/>
				</redirect:write>
			</xsl:if>

			<!-- <xsl:for-each select="xalan:nodeset($updated_xml)/*"> -->
			<xsl:for-each select="xalan:nodeset($updated_xml)//mn:metanorma">
				<xsl:variable name="num"><xsl:number level="any" count="mn:metanorma"/></xsl:variable>

				<xsl:variable name="current_document">
					<xsl:copy-of select="."/>
				</xsl:variable>

				<xsl:for-each select="xalan:nodeset($current_document)">

					<xsl:variable name="title-en"><xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@language = 'en']/node()"/></xsl:variable>
					<xsl:variable name="title-main_"><xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@type = 'main']/node()"/></xsl:variable>

					<xsl:variable name="title_header">
						<xsl:copy-of select="$title-main_"/>
						<xsl:if test="normalize-space($title-main_) = ''"><xsl:copy-of select="$title-en"/></xsl:if>
					</xsl:variable>

					<xsl:variable name="docidentifier_parent" select="normalize-space(/mn:metanorma/mn:bibdata/mn:docidentifier[@type = 'IHO-parent-document'])"/>
					<xsl:variable name="docidentifier">
						<xsl:value-of select="$docidentifier_parent"/>
						<xsl:if test="$docidentifier_parent = ''"><xsl:value-of select="/mn:metanorma/mn:bibdata/mn:docidentifier[@type = 'IHO']"/></xsl:if>
					</xsl:variable>

					<xsl:variable name="copyrightText" select="concat('© International Hydrographic Association ', /mn:metanorma/mn:bibdata/mn:copyright/mn:from ,' – All rights reserved')"/>
					<xsl:variable name="edition"><xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:edition[normalize-space(@language) = '']"/></xsl:variable>
					<xsl:variable name="month_year"><xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:date[@type = 'published']"/></xsl:variable>

					<xsl:call-template name="cover-page">
						<xsl:with-param name="num" select="$num"/>
						<xsl:with-param name="docidentifier" select="$docidentifier"/>
						<xsl:with-param name="edition" select="$edition"/>
						<xsl:with-param name="month_year" select="$month_year"/>
					</xsl:call-template>

					<xsl:choose>
						<xsl:when test="/mn:metanorma/mn:boilerplate/*[not(self::mn:feedback-statement)]">
							<fo:page-sequence master-reference="preface" format="i" force-page-count="no-force">
								<xsl:call-template name="insertHeaderFooter">
									<xsl:with-param name="title_header" select="$title_header"/>
									<xsl:with-param name="docidentifier" select="$docidentifier"/>
									<xsl:with-param name="edition" select="$edition"/>
									<xsl:with-param name="month_year" select="$month_year"/>
									<xsl:with-param name="font-weight">normal</xsl:with-param>
								</xsl:call-template>
								<fo:flow flow-name="xsl-region-body">
									<fo:block-container margin-left="-1.5mm" margin-right="-1mm">
										<fo:block-container margin-left="0mm" margin-right="0mm" border="0.5pt solid black">
											<fo:block-container margin-top="6.5mm" margin-left="7.5mm" margin-right="8.5mm" margin-bottom="7.5mm">
												<fo:block-container margin="0">
													<fo:block text-align="justify">
														<xsl:apply-templates select="/mn:metanorma/mn:boilerplate/*[not(self::mn:feedback-statement)]"/>
													</fo:block>
												</fo:block-container>
											</fo:block-container>
										</fo:block-container>
									</fo:block-container>
								</fo:flow>
							</fo:page-sequence>
						</xsl:when>
						<xsl:otherwise>
							<!-- https://github.com/metanorma/metanorma-iho/issues/293:
								If the publication has no copyright boxed note (normally on page ii of the publication), page ii should be "Page intentionally left blank". -->
							<fo:page-sequence master-reference="blankpage" format="i" force-page-count="no-force">
								<xsl:call-template name="insertHeaderFooterBlank">
									<xsl:with-param name="title_header" select="$title_header"/>
									<xsl:with-param name="docidentifier" select="$docidentifier"/>
									<xsl:with-param name="edition" select="$edition"/>
									<xsl:with-param name="month_year" select="$month_year"/>
								</xsl:call-template>
								<fo:flow flow-name="xsl-region-body">
									<fo:block/>
								</fo:flow>
							</fo:page-sequence>
						</xsl:otherwise>
					</xsl:choose>

					<xsl:variable name="updated_xml_with_pages">
						<xsl:call-template name="processPrefaceAndMainSectionsIHO_items"/>
					</xsl:variable>

					<xsl:for-each select="xalan:nodeset($updated_xml_with_pages)"> <!-- set context to preface/sections -->

						<xsl:for-each select=".//mn:page_sequence[parent::mn:preface][normalize-space() != '' or .//mn:image or .//*[local-name() = 'svg']]">

							<!-- Preface Pages -->
							<fo:page-sequence master-reference="preface" format="i" force-page-count="end-on-even">

								<xsl:attribute name="master-reference">
									<xsl:text>preface</xsl:text>
									<xsl:call-template name="getPageSequenceOrientation"/>
								</xsl:attribute>

								<xsl:call-template name="insertFootnoteSeparatorCommon"/>
								<xsl:call-template name="insertHeaderFooter">
									<xsl:with-param name="title_header" select="$title_header"/>
									<xsl:with-param name="docidentifier" select="$docidentifier"/>
									<xsl:with-param name="edition" select="$edition"/>
									<xsl:with-param name="month_year" select="$month_year"/>
									<xsl:with-param name="font-weight">normal</xsl:with-param>
									<xsl:with-param name="orientation"><xsl:call-template name="getPageSequenceOrientation"/></xsl:with-param>
								</xsl:call-template>
								<fo:flow flow-name="xsl-region-body">

									<!-- <xsl:if test="position() = 1">
										<fo:block-container margin-left="-1.5mm" margin-right="-1mm">
											<fo:block-container margin-left="0mm" margin-right="0mm" border="0.5pt solid black" >
												<fo:block-container margin-top="6.5mm" margin-left="7.5mm" margin-right="8.5mm" margin-bottom="7.5mm">
													<fo:block-container margin="0">
														<fo:block text-align="justify">
															<xsl:apply-templates select="/mn:metanorma/mn:boilerplate/*[local-name() != 'feedback-statement']"/>
														</fo:block>
													</fo:block-container>
												</fo:block-container>
											</fo:block-container>
										</fo:block-container>
										<fo:block break-after="page"/>
									</xsl:if> -->

									<!-- Contents, Document History, ... except Foreword and Introduction -->
									<!-- <xsl:call-template name="processPrefaceSectionsDefault"/> -->
									<xsl:apply-templates select="*[not(self::mn:foreword) and not(self::mn:introduction)]">
										<xsl:with-param name="num" select="$num"/>
									</xsl:apply-templates>

								</fo:flow>
							</fo:page-sequence>
							<!-- End Preface Pages -->
							<!-- =========================== -->
							<!-- =========================== -->
						</xsl:for-each>

						<xsl:for-each select=".//mn:page_sequence[mn:foreword or mn:introduction][parent::mn:preface][normalize-space() != '' or .//mn:image or .//*[local-name() = 'svg']]">

							<!-- Preface Pages -->
							<fo:page-sequence master-reference="preface" format="i" force-page-count="end-on-even">

								<xsl:attribute name="master-reference">
									<xsl:text>preface</xsl:text>
									<xsl:call-template name="getPageSequenceOrientation"/>
								</xsl:attribute>

								<xsl:call-template name="insertFootnoteSeparatorCommon"/>
								<xsl:call-template name="insertHeaderFooter">
									<xsl:with-param name="title_header" select="$title_header"/>
									<xsl:with-param name="docidentifier" select="$docidentifier"/>
									<xsl:with-param name="edition" select="$edition"/>
									<xsl:with-param name="month_year" select="$month_year"/>
									<xsl:with-param name="font-weight">normal</xsl:with-param>
									<xsl:with-param name="orientation"><xsl:call-template name="getPageSequenceOrientation"/></xsl:with-param>
								</xsl:call-template>
								<fo:flow flow-name="xsl-region-body">

									<!-- Foreword, Introduction -->
									<xsl:apply-templates select="*[self::mn:foreword or self::mn:introduction]"/>

								</fo:flow>
							</fo:page-sequence>
							<!-- End Preface Pages -->
							<!-- =========================== -->
							<!-- =========================== -->
						</xsl:for-each>

						<xsl:for-each select=".//mn:page_sequence[not(parent::mn:preface)][normalize-space() != '' or .//mn:image or .//*[local-name() = 'svg']]">

							<fo:page-sequence master-reference="document" format="1" force-page-count="end-on-even">

								<xsl:attribute name="master-reference">
									<xsl:text>document</xsl:text>
									<xsl:call-template name="getPageSequenceOrientation"/>
								</xsl:attribute>

								<xsl:if test="position() = 1">
									<xsl:attribute name="initial-page-number">1</xsl:attribute>
								</xsl:if>

								<xsl:call-template name="insertFootnoteSeparatorCommon"/>
								<xsl:call-template name="insertHeaderFooter">
									<xsl:with-param name="title_header" select="$title_header"/>
									<xsl:with-param name="docidentifier" select="$docidentifier"/>
									<xsl:with-param name="edition" select="$edition"/>
									<xsl:with-param name="month_year" select="$month_year"/>
									<xsl:with-param name="orientation"><xsl:call-template name="getPageSequenceOrientation"/></xsl:with-param>
								</xsl:call-template>
								<fo:flow flow-name="xsl-region-body">
									<fo:block-container>

										<!-- <fo:block font-size="16pt" font-weight="bold" margin-bottom="18pt" role="H1"><xsl:value-of select="$title-en"/></fo:block> -->

										<!-- <xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name()='clause'][@type='scope']" /> -->
										<!-- Normative references  -->
										<!-- <xsl:apply-templates select="/*/*[local-name()='bibliography']/*[local-name()='references'][@normative='true']" /> -->
										<!-- Terms and definitions -->
										<!-- <xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name()='terms']" />
										<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name()='definitions']" />
										<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name() != 'terms' and local-name() != 'definitions' and not(@type='scope')]" /> -->

										<!-- <xsl:call-template name="processMainSectionsDefault"/> -->

										<xsl:apply-templates/>

										<xsl:if test="$table_if = 'true'"><fo:block/></xsl:if>
									</fo:block-container>
								</fo:flow>
							</fo:page-sequence>
					<!-- </xsl:if> -->
						</xsl:for-each>
					</xsl:for-each>
				</xsl:for-each>

					<!-- <xsl:if test="/mn:metanorma/mn:annex">
						<fo:page-sequence master-reference="document">
							<fo:static-content flow-name="xsl-footnote-separator">
								<fo:block>
									<fo:leader leader-pattern="rule" leader-length="30%"/>
								</fo:block>
							</fo:static-content>
							<xsl:call-template name="insertHeaderFooter"/>
							<fo:flow flow-name="xsl-region-body">
								<fo:block-container>								
									<xsl:apply-templates select="/*/*[local-name()='annex']" />
									
									<xsl:if test="$table_if = 'true'"><fo:block/></xsl:if>
								</fo:block-container>
							</fo:flow>
						</fo:page-sequence>
					</xsl:if> -->

					<!-- <xsl:if test="/*/*[local-name()='bibliography']/*[local-name()='references'][not(@normative='true')]">
						<fo:page-sequence master-reference="document">
							<fo:static-content flow-name="xsl-footnote-separator">
								<fo:block>
									<fo:leader leader-pattern="rule" leader-length="30%"/>
								</fo:block>
							</fo:static-content>
							<xsl:call-template name="insertHeaderFooter"/>
							<fo:flow flow-name="xsl-region-body">
								<fo:block-container>	 -->
									<!-- Bibliography -->
									<!-- <xsl:apply-templates select="/*/*[local-name()='bibliography']/*[local-name()='references'][not(@normative='true')]" />
									
									<xsl:if test="$table_if = 'true'"><fo:block/></xsl:if>
								</fo:block-container>
							</fo:flow>
						</fo:page-sequence>
					</xsl:if> -->

					<!-- =========================== -->
					<!-- End Document Pages -->
					<!-- =========================== -->
					<!-- =========================== -->
			</xsl:for-each>
		</fo:root>
	</xsl:template>

	<xsl:template name="cover-page">
		<xsl:param name="num"/>
		<xsl:param name="docidentifier"/>
		<xsl:param name="edition"/>
		<xsl:param name="month_year"/>

		<xsl:variable name="title-en"><xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@language = 'en']/node()"/></xsl:variable>
		<xsl:variable name="title-main_"><xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@type = 'main']/node()"/></xsl:variable>
		<xsl:variable name="title-main"><xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@type = 'title-main']/node()"/></xsl:variable>
		<xsl:variable name="title-appendix"><xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@type = 'title-appendix']/node()"/></xsl:variable>
		<xsl:variable name="title-annex"><xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@type = 'title-annex']/node()"/></xsl:variable>
		<xsl:variable name="title-part"><xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@type = 'title-part']/node()"/></xsl:variable>
		<xsl:variable name="title-supplement"><xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@type = 'title-supplement']/node()"/></xsl:variable>

		<!-- =========================== -->
		<!-- Cover Page -->
		<fo:page-sequence master-reference="cover-page">
			<fo:flow flow-name="xsl-region-body">

				<fo:block-container absolute-position="fixed" top="1mm">
					<xsl:if test="$num = 1">
						<xsl:attribute name="id">firstpage_id_0</xsl:attribute>
					</xsl:if>
					<fo:block id="firstpage_id_{$num}"> </fo:block>
				</fo:block-container>

				<xsl:variable name="isCoverPageImage" select="normalize-space(/mn:metanorma/mn:metanorma-extension/mn:presentation-metadata[mn:name = 'coverpage-image']/mn:value/mn:image and 1 = 1)"/>

				<xsl:variable name="document_scheme" select="normalize-space(/mn:metanorma/mn:metanorma-extension/mn:presentation-metadata[mn:name = 'document-scheme']/mn:value)"/>

				<xsl:choose>
					<xsl:when test="$document_scheme != '' and $document_scheme != '2019' and $isCoverPageImage = 'true'">
						<xsl:call-template name="insertBackgroundPageImage"/>
					</xsl:when>
					<xsl:otherwise>

						<fo:block-container position="absolute" left="14.25mm" top="12mm" id="__internal_layout__coverpage_{$num}_{generate-id()}">
							<fo:table table-layout="fixed" width="181.1mm">
									<fo:table-column column-width="26mm"/>
									<fo:table-column column-width="19.4mm"/>
									<fo:table-column column-width="135.7mm"/>
									<fo:table-body>
										<fo:table-row>
											<fo:table-cell><fo:block> </fo:block></fo:table-cell>
											<fo:table-cell>
												<fo:block-container width="19.4mm" height="21mm" background-color="rgb(241, 234, 202)" border-bottom="0.05pt solid rgb(0, 21, 50)" text-align="center" display-align="center" font-size="10pt" font-weight="bold">
													<xsl:if test="$isCoverPageImage = 'true'">
														<xsl:attribute name="width">42.5mm</xsl:attribute>
													</xsl:if>
													<fo:block>
														<xsl:value-of select="$docidentifier"/>
														<xsl:if test="$isCoverPageImage = 'true'">
															<xsl:text> </xsl:text><xsl:value-of select="$edition"/>
														</xsl:if>
													</fo:block>
												</fo:block-container>
											</fo:table-cell>
											<fo:table-cell><fo:block> </fo:block></fo:table-cell>
										</fo:table-row>
										<fo:table-row>
											<fo:table-cell display-align="after" text-align="right">
												<fo:block font-size="1">
													<fo:instream-foreign-object content-width="25.9mm" fox:alt-text="Image IHO">
														<xsl:copy-of select="$Image-IHO-SVG"/>
													</fo:instream-foreign-object>
												</fo:block>
											</fo:table-cell>

											<!-- https://github.com/metanorma/metanorma-iho/issues/288 -->
											<xsl:choose>
												<xsl:when test="$isCoverPageImage = 'true'">
													<fo:table-cell number-columns-spanned="2">
														<fo:block-container font-size="0"> <!-- height="168mm" width="115mm"  -->
															<fo:block>
																<xsl:for-each select="/mn:metanorma/mn:metanorma-extension/mn:presentation-metadata[mn:name = 'coverpage-image'][1]/mn:value/mn:image[1]">

																	<xsl:call-template name="insertPageImage">
																		<xsl:with-param name="bitmap_width">155.5</xsl:with-param>
																	</xsl:call-template>

																</xsl:for-each>
															</fo:block>
														</fo:block-container>
													</fo:table-cell>
												</xsl:when>
												<xsl:otherwise>
													<fo:table-cell number-columns-spanned="2" border="0.5pt solid rgb(0, 21, 50)" font-weight="bold" color="rgb(0, 0, 76)" padding-top="3mm">
														<fo:block-container height="165mm" width="115mm">
															<fo:block-container margin-left="10mm">
																<fo:block-container margin-left="0mm">

																	<!-- <fo:block-container display-align="center" height="90mm"> -->
																	<fo:table table-layout="fixed" width="100%">
																		<fo:table-body>
																			<fo:table-row min-height="90mm"> <!-- for debug: border="1pt solid blue" -->
																				<fo:table-cell display-align="center">
																					<xsl:if test="normalize-space($title-annex) != '' or                        normalize-space($title-appendix) != '' or                       normalize-space($title-supplement) != ''">
																						<fo:block font-size="14pt" role="H1" line-height="115%" margin-top="35mm">
																							<fo:block><xsl:copy-of select="$title-annex"/></fo:block>
																							<fo:block><xsl:copy-of select="$title-appendix"/></fo:block>
																							<fo:block><xsl:copy-of select="$title-supplement"/></fo:block>
																						</fo:block>
																						<fo:block font-size="28pt" role="SKIP" line-height="115%"> </fo:block>
																					</xsl:if>
																					<fo:block font-size="28pt" role="H1" line-height="115%">
																						<xsl:copy-of select="$title-main"/>
																						<xsl:if test="normalize-space($title-main) = ''">
																							<xsl:copy-of select="$title-main_"/>
																							<xsl:if test="normalize-space($title-main_) = ''"><xsl:copy-of select="$title-en"/></xsl:if>
																						</xsl:if>
																					</fo:block>
																					<xsl:if test="normalize-space($title-part) != ''">
																						<fo:block font-size="28pt" role="SKIP" line-height="115%"> </fo:block>
																						<fo:block font-size="18pt" role="H2" line-height="115%" margin-bottom="10mm">
																							<xsl:copy-of select="$title-part"/>
																						</fo:block>
																					</xsl:if>
																				</fo:table-cell>
																			</fo:table-row>
																		</fo:table-body>
																	</fo:table>
																	<!-- </fo:block-container> -->

																	<fo:block font-size="14pt">
																		<xsl:value-of select="$edition"/>
																		<xsl:if test="normalize-space($month_year) != ''">
																			<xsl:text> – </xsl:text>
																			<xsl:value-of select="$month_year"/>
																		</xsl:if>
																	</fo:block>
																</fo:block-container>
															</fo:block-container>
														</fo:block-container>
													</fo:table-cell>
												</xsl:otherwise>
											</xsl:choose>
										</fo:table-row>
										<fo:table-row>
											<fo:table-cell>
												<fo:block font-size="1">
													<fo:instream-foreign-object content-width="25.9mm" fox:alt-text="Image Logo IHO">
														<xsl:copy-of select="$Image-Logo-IHO-SVG"/>
													</fo:instream-foreign-object>
												</fo:block>
											</fo:table-cell>
											<fo:table-cell>
												<fo:block font-size="1">
													<fo:instream-foreign-object content-width="25.8mm" fox:alt-text="Image Logo IHO">
														<xsl:copy-of select="$Image-Text-IHO-SVG"/>
													</fo:instream-foreign-object>
												</fo:block>
											</fo:table-cell>
											<fo:table-cell number-rows-spanned="2">
												<fo:block-container width="79mm" height="72mm" margin-left="56.8mm" background-color="rgb(0, 172, 158)" text-align="right" display-align="after">
													<fo:block-container margin-left="0mm">
														<fo:block font-size="8pt" color="white" margin-right="5mm" margin-bottom="5mm" line-height-shift-adjustment="disregard-shifts">
															<xsl:apply-templates select="/mn:metanorma/mn:boilerplate/mn:feedback-statement"/>
														</fo:block>
													</fo:block-container>
												</fo:block-container>
											</fo:table-cell>
										</fo:table-row>
										<fo:table-row>
											<fo:table-cell number-columns-spanned="2" padding-top="2mm">
												<fo:block-container width="51.5mm">
													<fo:block>
														<xsl:for-each select="/mn:metanorma/mn:bibdata/mn:contributor[mn:role/@type = 'publisher']/mn:organization[not(mn:abbreviation = 'IHO')]">
															<xsl:apply-templates select="mn:logo/mn:image">
																<xsl:with-param name="logo_width">25.8mm</xsl:with-param>
															</xsl:apply-templates>
															<xsl:if test="position() != last()"><fo:inline> </fo:inline></xsl:if>
														</xsl:for-each>
													</fo:block>
												</fo:block-container>
											</fo:table-cell>
										</fo:table-row>
									</fo:table-body>
								</fo:table>
						</fo:block-container>
					</xsl:otherwise>
				</xsl:choose>
			</fo:flow>
		</fo:page-sequence>
		<!-- End Cover Page -->
		<!-- =========================== -->
		<!-- =========================== -->
	</xsl:template>

	<xsl:template name="insertListOf_Title">
		<xsl:param name="title"/>
		<fo:block xsl:use-attribute-sets="toc-listof-title-style">
			<xsl:value-of select="$title"/>
		</fo:block>
	</xsl:template>

	<xsl:template name="insertListOf_Item">
		<fo:block xsl:use-attribute-sets="toc-listof-item-style">
			<fo:basic-link internal-destination="{@id}">
				<xsl:call-template name="setAltText">
					<xsl:with-param name="value" select="@alt-text"/>
				</xsl:call-template>
				<xsl:apply-templates select="." mode="contents"/>
				<fo:inline keep-together.within-line="always">
					<fo:leader xsl:use-attribute-sets="toc-leader-style"/>
					<fo:inline><fo:page-number-citation ref-id="{@id}"/></fo:inline>
				</fo:inline>
			</fo:basic-link>
		</fo:block>
	</xsl:template>

	<xsl:template name="processPrefaceAndMainSectionsIHO_items">

		<xsl:variable name="updated_xml_step_move_pagebreak">
			<xsl:element name="{$root_element}" namespace="{$namespace_full}">
				<xsl:call-template name="copyCommonElements"/>
				<xsl:call-template name="insertPrefaceSectionsPageSequences"/>

				<!-- <xsl:call-template name="insertMainSectionsPageSequences"/> -->

				<xsl:call-template name="insertSectionsInPageSequence"/>
				<xsl:call-template name="insertAnnexInSeparatePageSequences"/>
				<xsl:call-template name="insertBibliographyInSeparatePageSequences"/>
				<xsl:call-template name="insertIndexInSeparatePageSequences"/>

			</xsl:element>
		</xsl:variable>

		<xsl:variable name="updated_xml_step_move_pagebreak_filename" select="concat($output_path,'_main_', java:getTime(java:java.util.Date.new()), '.xml')"/>

		<redirect:write file="{$updated_xml_step_move_pagebreak_filename}">
			<xsl:copy-of select="$updated_xml_step_move_pagebreak"/>
		</redirect:write>

		<xsl:copy-of select="document($updated_xml_step_move_pagebreak_filename)"/>

		<xsl:if test="$debug = 'true'">
			<redirect:write file="page_sequence_preface_and_main.xml">
				<xsl:copy-of select="$updated_xml_step_move_pagebreak"/>
			</redirect:write>
		</xsl:if>

		<xsl:call-template name="deleteFile">
			<xsl:with-param name="filepath" select="$updated_xml_step_move_pagebreak_filename"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mn:preface//mn:clause[@type = 'toc']" name="toc" priority="4">
		<xsl:param name="num"/>
		<!-- Table of Contents -->
		<fo:block>

			<xsl:apply-templates/>

			<xsl:if test="$debug = 'true'">
				<redirect:write file="contents_.xml"> <!-- {java:getTime(java:java.util.Date.new())} -->
					<xsl:copy-of select="$contents"/>
				</redirect:write>
			</xsl:if>

			<xsl:if test="count(*) = 1 and mn:fmt-title"> <!-- if there isn't user ToC -->

				<fo:block role="TOC" xsl:use-attribute-sets="toc-style">

					<xsl:for-each select="$contents/mnx:doc[@num = $num]//mnx:item[@display = 'true']"><!-- [not(@level = 2 and starts-with(@section, '0'))] skip clause from preface -->
						<fo:block role="TOCI">
							<fo:list-block xsl:use-attribute-sets="toc-item-block-style">

								<xsl:call-template name="refine_toc-item-block-style"/>

								<fo:list-item>
									<fo:list-item-label end-indent="label-end()">
										<fo:block id="__internal_layout__toc_sectionnum_{$num}_{generate-id()}">
											<xsl:if test="@section != '' and not(@type = 'annex')"> <!-- output below   -->
												<xsl:value-of select="@section"/>
											</xsl:if>
										</fo:block>
									</fo:list-item-label>
										<fo:list-item-body start-indent="body-start()">
											<fo:block xsl:use-attribute-sets="toc-item-style">
												<fo:basic-link internal-destination="{@id}" fox:alt-text="{mnx:title}">
													<xsl:apply-templates select="mnx:title"/>
													<fo:inline keep-together.within-line="always">
														<fo:leader xsl:use-attribute-sets="toc-leader-style"/>
														<fo:inline><fo:page-number-citation ref-id="{@id}"/></fo:inline>
													</fo:inline>
												</fo:basic-link>
											</fo:block>
										</fo:list-item-body>
								</fo:list-item>
							</fo:list-block>
						</fo:block>
					</xsl:for-each>

					<!-- List of Tables -->
					<xsl:for-each select="$contents//mnx:tables/mnx:table">
						<xsl:if test="position() = 1">
							<xsl:call-template name="insertListOf_Title">
								<xsl:with-param name="title" select="$title-list-tables"/>
							</xsl:call-template>
						</xsl:if>
						<xsl:call-template name="insertListOf_Item"/>
					</xsl:for-each>

					<!-- List of Figures -->
					<xsl:for-each select="$contents//mnx:figures/mnx:figure">
						<xsl:if test="position() = 1">
							<xsl:call-template name="insertListOf_Title">
								<xsl:with-param name="title" select="$title-list-figures"/>
							</xsl:call-template>
						</xsl:if>
						<xsl:call-template name="insertListOf_Item"/>
					</xsl:for-each>
				</fo:block>
			</xsl:if>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:preface//mn:clause[@type = 'toc']/mn:fmt-title" priority="3">
		<fo:block xsl:use-attribute-sets="toc-title-style">
			<fo:block-container width="18.3mm" border-bottom="1.25pt solid black" role="SKIP">
				<fo:block line-height="75%">
					<!-- <xsl:call-template name="getLocalizedString">
						<xsl:with-param name="key">table_of_contents</xsl:with-param>
					</xsl:call-template> -->
					<xsl:apply-templates/>
				</fo:block>
			</fo:block-container>
		</fo:block>
	</xsl:template>

	<!-- ============================= -->
	<!-- CONTENTS                                       -->
	<!-- ============================= -->

	<!-- element with title -->
	<xsl:template match="*[mn:title or mn:fmt-title]" mode="contents">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="mn:fmt-title/@depth | mn:title/@depth"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="display">
			<xsl:choose>
				<xsl:when test="@id = '_document_history' or mn:title = 'Document History'">false</xsl:when>
				<xsl:when test="$level &lt;= $toc_level">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="skip">
			<xsl:choose>
				<xsl:when test="@type = 'toc'">true</xsl:when>
				<xsl:when test="ancestor-or-self::mn:bibitem">true</xsl:when>
				<xsl:when test="ancestor-or-self::mn:term">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:if test="$skip = 'false'">

			<xsl:variable name="section">
				<xsl:call-template name="getSection"/>
			</xsl:variable>

			<xsl:variable name="title">
				<xsl:call-template name="getName"/>
			</xsl:variable>

			<xsl:variable name="type">
				<xsl:value-of select="local-name()"/>
			</xsl:variable>

			<xsl:variable name="root">
				<xsl:if test="ancestor-or-self::mn:preface">preface</xsl:if>
				<xsl:if test="ancestor-or-self::mn:annex">annex</xsl:if>
			</xsl:variable>

			<mnx:item id="{@id}" level="{$level}" section="{$section}" type="{$type}" root="{$root}" display="{$display}">
				<mnx:title>
					<xsl:apply-templates select="xalan:nodeset($title)" mode="contents_item"/>
				</mnx:title>
				<xsl:apply-templates mode="contents"/>
			</mnx:item>

		</xsl:if>

	</xsl:template>

	<xsl:template match="mn:strong" mode="contents_item" priority="2">
		<xsl:apply-templates mode="contents_item"/>
	</xsl:template>

	<!-- ============================= -->
	<!-- END CONTENTS                                 -->
	<!-- ============================= -->
	<!-- ============================= -->

	<xsl:template match="mn:requirement | mn:recommendation | mn:permission" priority="2" mode="update_xml_step1">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:requirement | mn:recommendation | mn:permission" priority="2">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block-container id="{@id}" xsl:use-attribute-sets="recommendation-style">
			<fo:block-container margin="2mm">
				<fo:block-container margin="0">
					<fo:block>
						<xsl:apply-templates/>
					</fo:block>
				</fo:block-container>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>

	<xsl:template match="mn:fmt-provision" priority="2" mode="update_xml_step1">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:fmt-provision/mn:div" priority="2">
		<fo:inline><xsl:copy-of select="@id"/><xsl:apply-templates/></fo:inline>
	</xsl:template>

	<xsl:template match="mn:metanorma/mn:bibdata/mn:edition">
		<xsl:call-template name="capitalize">
			<xsl:with-param name="str">
				<xsl:call-template name="getLocalizedString">
					<xsl:with-param name="key">edition</xsl:with-param>
				</xsl:call-template>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:text> </xsl:text>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="mn:metanorma/mn:bibdata/mn:date[@type = 'published']">
		<xsl:call-template name="convertDate">
			<xsl:with-param name="date" select="."/>
			<xsl:with-param name="format" select="'short'"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mn:feedback-statement//mn:br" priority="2">
		<fo:block/>
	</xsl:template>

	<xsl:template match="mn:feedback-statement//mn:sup" priority="2">
		<fo:inline font-size="62%" baseline-shift="35%">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="node()">
		<xsl:apply-templates/>
	</xsl:template>

	<!-- ====== -->
	<!-- title      -->
	<!-- ====== -->

	<xsl:template match="mn:annex/mn:fmt-title" name="annex_title">
		<fo:block xsl:use-attribute-sets="annex-title-style">

			<xsl:call-template name="refine_annex-title-style"/>

			<xsl:apply-templates/>
			<xsl:apply-templates select="following-sibling::*[1][mn:variant-title][@type = 'sub']" mode="subtitle"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:bibliography/mn:references[not(@normative='true')]/mn:fmt-title">
		<fo:block xsl:use-attribute-sets="references-non-normative-title-style">

			<xsl:call-template name="refine_references-non-normative-title-style"/>

			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:clause" priority="3">
		<xsl:if test="parent::mn:preface or (parent::mn:page_sequence and local-name(../..) = 'preface')">
			<fo:block break-after="page"/>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="mn:fmt-title">
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:otherwise>
				<fo:block>
					<xsl:call-template name="setId"/>
					<xsl:call-template name="addReviewHelper"/>
					<xsl:apply-templates/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mn:fmt-title" name="title">

		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>

		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="$level = 1">12pt</xsl:when>
				<xsl:when test="$level = 2">11pt</xsl:when>
				<xsl:when test="$level &gt;= 3">10pt</xsl:when>
				<xsl:otherwise>12pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="../@inline-header = 'true'">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:element name="{$element-name}">
			<xsl:for-each select="parent::mn:clause">
				<xsl:call-template name="setId"/>
			</xsl:for-each>
			<xsl:attribute name="font-size"><xsl:value-of select="$font-size"/></xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="space-before">
				<xsl:choose>
					<xsl:when test="$level = 1">24pt</xsl:when>
					<xsl:when test="$level = 2 and ../preceding-sibling::*[1][self::mn:fmt-title]">10pt</xsl:when>
					<xsl:when test="$level = 2">24pt</xsl:when>
					<xsl:when test="$level &gt;= 3">6pt</xsl:when>
					<xsl:when test="ancestor::mn:preface">8pt</xsl:when>
					<xsl:when test="$level = ''">6pt</xsl:when><!-- 13.5pt -->
					<xsl:otherwise>12pt</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="space-after">
				<xsl:choose>
					<xsl:when test="$level &gt;= 3">6pt</xsl:when>
					<xsl:otherwise>10pt</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<!-- <xsl:attribute name="margin-bottom">10pt</xsl:attribute> -->

			<xsl:attribute name="keep-with-next">always</xsl:attribute>

			<xsl:attribute name="role">H<xsl:value-of select="$level"/></xsl:attribute>

			<xsl:if test="../@id = '_document_history' or . = 'Document History'">
				<xsl:attribute name="text-align">center</xsl:attribute>
			</xsl:if>

			<xsl:apply-templates/>
			<xsl:apply-templates select="following-sibling::*[1][mn:variant-title][@type = 'sub']" mode="subtitle"/>
		</xsl:element>

		<xsl:if test="$element-name = 'fo:inline' and not(following-sibling::mn:p)">
			<fo:block> <!-- margin-bottom="12pt" -->
				<xsl:value-of select="$linebreak"/>
			</fo:block>
		</xsl:if>

	</xsl:template>
	<!-- ====== -->
	<!-- ====== -->

	<xsl:template match="mn:p" name="paragraph">
		<xsl:param name="inline" select="'false'"/>
		<xsl:param name="split_keep-within-line"/>
		<xsl:variable name="previous-element" select="local-name(preceding-sibling::*[1])"/>
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="$inline = 'true'">fo:inline</xsl:when>
				<xsl:when test="../@inline-header = 'true' and $previous-element = 'fmt-title'">fo:inline</xsl:when> <!-- first paragraph after inline title -->
				<xsl:when test="parent::mn:admonition">fo:inline</xsl:when>
				<xsl:when test="ancestor::*[self::mn:recommendation or self::mn:requirement or self::mn:permission] and not(preceding-sibling::mn:p)">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="{$element-name}">
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="ancestor::mn:quote">justify</xsl:when>
					<xsl:when test="ancestor::mn:feedback-statement">right</xsl:when>
					<xsl:when test="ancestor::mn:boilerplate and not(@align)">justify</xsl:when>
					<xsl:when test="@align = 'justified'">justify</xsl:when>
					<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
					<xsl:when test="ancestor::mn:td/@align"><xsl:value-of select="ancestor::mn:td/@align"/></xsl:when>
					<xsl:when test="ancestor::mn:th/@align"><xsl:value-of select="ancestor::mn:th/@align"/></xsl:when>
					<xsl:otherwise>justify</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:call-template name="setKeepAttributes"/>
			<xsl:attribute name="space-after">6pt</xsl:attribute>
			<xsl:if test="parent::mn:dd">
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::*[2][self::mn:license-statement] and not(following-sibling::mn:p)">
				<xsl:attribute name="space-after">0pt</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="line-height">115%</xsl:attribute>
			<!-- <xsl:attribute name="border">1pt solid red</xsl:attribute> -->
			<xsl:if test="ancestor::mn:boilerplate and not(ancestor::mn:feedback-statement)">
				<xsl:attribute name="line-height">125%</xsl:attribute>
				<xsl:attribute name="space-after">14pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="following-sibling::*[1][self::mn:ol or self::mn:ul or self::mn:note or self::mn:termnote or self::mn:example or self::mn:dl]">
				<xsl:attribute name="space-after">3pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="following-sibling::*[1][self::mn:dl]">
				<xsl:attribute name="space-after">6pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::mn:quote">
				<xsl:attribute name="line-height">130%</xsl:attribute>
				<!-- <xsl:attribute name="margin-bottom">12pt</xsl:attribute> -->
			</xsl:if>

			<xsl:if test="ancestor::*[self::mn:recommendation or self::mn:requirement or self::mn:permission] and    not(following-sibling::*)">
				<xsl:attribute name="space-after">0pt</xsl:attribute>
			</xsl:if>

			<xsl:if test="ancestor::mn:li and ancestor::mn:table">
				<xsl:attribute name="space-after">0pt</xsl:attribute>
			</xsl:if>

			<xsl:if test=".//mn:fn">
				<xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
			</xsl:if>

			<xsl:copy-of select="@id"/>

			<xsl:apply-templates>
				<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
			</xsl:apply-templates>
		</xsl:element>
		<xsl:if test="$element-name = 'fo:inline' and not($inline = 'true') and not(parent::mn:admonition) and   not(ancestor::*[self::mn:recommendation or self::mn:requirement or self::mn:permission])">
			<fo:block margin-bottom="12pt">
				<!--  <xsl:if test="ancestor::mn:annex">
					<xsl:attribute name="margin-bottom">0</xsl:attribute>
				 </xsl:if> -->
				<xsl:value-of select="$linebreak"/>
			</fo:block>
		</xsl:if>
		<xsl:if test="$inline = 'true'">
			<fo:block> </fo:block>
		</xsl:if>
	</xsl:template>

	<!-- note in list item -->
	<!-- <xsl:template match="mn:ul//mn:note  | mn:ol//mn:note" priority="2">
		<fo:block id="{@id}">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template> -->

	<xsl:template match="mn:li//mn:p//text()">
		<xsl:choose>
			<xsl:when test="contains(., '&#9;')">
				<fo:inline white-space="pre"><xsl:value-of select="."/></fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- <xsl:template match="mn:example/mn:p" priority="2">
			<fo:block-container xsl:use-attribute-sets="example-p-style">
				<fo:block-container margin-left="0mm">
					<fo:block>
						<xsl:apply-templates />
					</fo:block>
				</fo:block-container>
			</fo:block-container>
	</xsl:template> -->

	<xsl:template match="mn:pagebreak" priority="2">
		<xsl:copy-of select="."/>
	</xsl:template>

	<!-- https://github.com/metanorma/mn-native-pdf/issues/214 -->
	<xsl:template match="mn:index"/>

	<xsl:template name="insertHeaderFooter">
		<xsl:param name="title_header"/>
		<xsl:param name="docidentifier"/>
		<xsl:param name="edition"/>
		<xsl:param name="month_year"/>
		<xsl:param name="font-weight" select="'bold'"/>
		<xsl:param name="orientation"/>
		<fo:static-content flow-name="header-odd" role="artifact">
			<fo:block-container height="100%" font-size="8pt">
				<fo:block padding-top="12.5mm">
					<fo:table table-layout="fixed" width="100%">
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-column column-width="proportional-column-width(10)"/>
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell><fo:block> </fo:block></fo:table-cell>
								<fo:table-cell text-align="center"><fo:block><xsl:copy-of select="$title_header"/></fo:block></fo:table-cell>
								<fo:table-cell text-align="right"><fo:block><fo:page-number/></fo:block></fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="header-even" role="artifact">
			<fo:block-container height="100%" font-size="8pt">
				<fo:block padding-top="12.5mm">
					<fo:table table-layout="fixed" width="100%">
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-column column-width="proportional-column-width(10)"/>
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell><fo:block><fo:page-number/></fo:block></fo:table-cell>
								<fo:table-cell text-align="center"><fo:block><xsl:copy-of select="$title_header"/></fo:block></fo:table-cell>
								<fo:table-cell><fo:block> </fo:block></fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
		<xsl:call-template name="insertHeaderBlank">
			<xsl:with-param name="title_header" select="$title_header"/>
			<xsl:with-param name="orientation" select="$orientation"/>
		</xsl:call-template>
		<xsl:call-template name="insertFooter">
			<xsl:with-param name="docidentifier" select="$docidentifier"/>
			<xsl:with-param name="edition" select="$edition"/>
			<xsl:with-param name="month_year" select="$month_year"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="insertHeaderBlank">
		<xsl:param name="title_header"/>
		<xsl:param name="orientation"/>
		<fo:static-content flow-name="header-blank" role="artifact">
			<fo:block-container height="100%" font-size="8pt">
				<fo:block padding-top="12.5mm">
					<fo:table table-layout="fixed" width="100%">
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-column column-width="proportional-column-width(10)"/>
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell><fo:block><fo:page-number/></fo:block></fo:table-cell>
								<fo:table-cell text-align="center"><fo:block><xsl:copy-of select="$title_header"/></fo:block></fo:table-cell>
								<fo:table-cell><fo:block> </fo:block></fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
				</fo:block>
			</fo:block-container>
			<fo:block-container position="absolute" left="40.5mm" top="130mm" height="4mm" width="79mm" border="0.75pt solid black" text-align="center" display-align="center" line-height="100%">
				<xsl:if test="$orientation = '-landscape'">
					<xsl:attribute name="left">84mm</xsl:attribute>
					<xsl:attribute name="top">87mm</xsl:attribute>
				</xsl:if>
				<fo:block>Page intentionally left blank</fo:block>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>
	<xsl:template name="insertFooter">
		<xsl:param name="docidentifier"/>
		<xsl:param name="edition"/>
		<xsl:param name="month_year"/>
		<fo:static-content flow-name="footer" role="artifact">
			<fo:block-container height="100%" display-align="after">
				<fo:block padding-bottom="12.5mm" font-size="8pt" text-align-last="justify">
					<fo:inline><xsl:value-of select="$docidentifier"/></fo:inline>
					<fo:inline keep-together.within-line="always">
						<fo:leader leader-pattern="space"/>
						<fo:inline>       <xsl:value-of select="$month_year"/></fo:inline>
					</fo:inline>
					<fo:inline keep-together.within-line="always">
						<fo:leader leader-pattern="space"/>
						<fo:inline><xsl:value-of select="$edition"/></fo:inline>
					</fo:inline>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>
	<xsl:template name="insertHeaderFooterBlank">
		<xsl:param name="title_header"/>
		<xsl:param name="docidentifier"/>
		<xsl:param name="edition"/>
		<xsl:param name="month_year"/>
		<xsl:call-template name="insertHeaderBlank">
			<xsl:with-param name="title_header" select="$title_header"/>
		</xsl:call-template>
		<xsl:call-template name="insertFooter">
			<xsl:with-param name="docidentifier" select="$docidentifier"/>
			<xsl:with-param name="edition" select="$edition"/>
			<xsl:with-param name="month_year" select="$month_year"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:variable name="Image-IHO-SVG">
		<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="100px" height="100px" viewBox="0 0 100 100" version="1.1">
			<g>
					<polygon fill="#00AAA9" points="0 100 100 100 100 0 0 0"/>
					<g transform="translate(20.000000, 36.000000)" fill="#FEFEFE">
							<polygon points="0.510089944 25.6344052 8.07929262 25.6344052 8.07929262 1.10633647 0.510089944 1.10633647"/>
							<polygon points="11.970913 1.1068918 19.5401156 1.1068918 19.5401156 9.62685265 26.628734 9.62685265 26.628734 1.1068918 34.1979367 1.1068918 34.1979367 25.6349606 26.628734 25.6349606 26.628734 15.9132532 19.5401156 15.9132532 19.5401156 25.6349606 11.970913 25.6349606"/>
							<path d="M48.3801795,20.104372 C50.3069666,20.104372 53.2661199,18.8326531 53.2661199,13.3714815 C53.2661199,7.90919922 50.3069666,6.63748039 48.3801795,6.63748039 C46.4533925,6.63748039 43.4942392,7.90919922 43.4942392,13.3714815 C43.4942392,18.8326531 46.4533925,20.104372 48.3801795,20.104372 M48.3801795,0.523233944 C55.8459231,0.523233944 60.8353226,5.88222379 60.8353226,13.3714815 C60.8353226,20.8607392 55.8459231,26.2186184 48.3801795,26.2186184 C40.9133235,26.2186184 35.9239241,20.8607392 35.9239241,13.3714815 C35.9239241,5.88222379 40.9133235,0.523233944 48.3801795,0.523233944"/>
					</g>
			</g>
		</svg>
	</xsl:variable>

	<xsl:variable name="Image-Logo-IHO-SVG">
		<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="100px" height="100px" viewBox="0 0 100 100" version="1.1">
			<g>
				<polygon fill="#05164D" points="0 100 100 100 100 0 0 0"/>
				<g transform="translate(19.811321, 15.277778)" fill="#FEDC5B">
					<path d="M28.7238836,10.581 C28.5202673,10.5876667 28.3749843,10.7354444 28.3815881,10.9365556 C28.3881918,11.1343333 28.5433805,11.2721111 28.7480975,11.2643333 C28.9528145,11.2565556 29.0958962,11.1076667 29.0892925,10.911 C29.0826887,10.7098889 28.9286006,10.5732222 28.7238836,10.581"/>
					<path d="M30.2124843,35.6943333 L30.5393711,33.2898889 C30.5778931,33.0098889 30.6615409,32.7465556 30.765,32.4921111 L24.4705031,32.4921111 L24.4705031,24.2676667 L20.2396855,24.2676667 L20.2396855,44.8998889 L24.4705031,44.8998889 L24.4705031,36.471 L30.201478,36.471 C30.1761635,36.2176667 30.1761635,35.9576667 30.2124843,35.6943333"/>
					<path d="M33.993805,26.334 C33.8474214,25.704 33.4677044,25.1717778 32.9250943,24.8328889 L32.3538679,24.4762222 L32.3538679,25.824 C32.6246226,26.0028889 32.8161321,26.274 32.8920755,26.5962222 C32.9691195,26.9284444 32.9151887,27.2695556 32.7379874,27.5573333 C32.6400314,27.7195556 32.5046541,27.8451111 32.3538679,27.9462222 L32.3538679,29.1895556 C32.9151887,29.0195556 33.391761,28.664 33.7010377,28.1584444 C34.0367296,27.6117778 34.1401887,26.9628889 33.993805,26.334"/>
					<path d="M28.2444497,47.4391111 L28.6043553,46.8035556 C28.4733805,46.6046667 28.3578145,46.3946667 28.2697642,46.1657778 C27.9538836,45.3468889 27.9725943,44.4546667 28.3214937,43.6557778 L29.2889465,41.4335556 C29.7038836,40.4802222 30.5381604,39.8057778 31.5166195,39.5702222 L31.5166195,38.7924444 C31.0587579,38.4524444 30.6966509,37.9968889 30.4655189,37.4746667 L27.641305,37.4746667 L27.641305,47.4735556 C27.8063994,47.448 27.9725943,47.4302222 28.1420912,47.4302222 C28.1762107,47.4302222 28.2103302,47.438 28.2444497,47.4391111"/>
					<path d="M29.5788522,20.4073333 C28.9206761,20.4073333 28.2746069,20.4562222 27.6417453,20.5462222 L27.6417453,31.4884444 L31.4257075,31.4884444 C31.4290094,31.4851111 31.4323113,31.4817778 31.4356132,31.4784444 L31.5170597,31.4784444 L31.5170597,31.3862222 L31.5170597,30.9673333 L31.5170597,21.1562222 L31.5170597,20.5462222 C30.8830975,20.4562222 30.2370283,20.4073333 29.5788522,20.4073333"/>
					<path d="M44.0848113,55.2396667 C43.7953459,55.4474444 43.7381132,55.8074444 43.9549371,56.1152222 C44.1706604,56.423 44.5261635,56.4896667 44.8167296,56.2807778 C45.106195,56.0741111 45.162327,55.7141111 44.9466038,55.4052222 C44.7297799,55.0974444 44.3753774,55.0318889 44.0848113,55.2396667"/>
					<polygon points="31.5727516 60.0921111 32.4015252 60.0132222 31.8787264 58.891"/>
					<path d="M14.1195283,55.3286667 C13.9016038,55.6364444 13.9566352,55.9997778 14.2461006,56.2075556 C14.535566,56.4164444 14.8932704,56.3531111 15.111195,56.0453333 C15.3302201,55.7364444 15.2740881,55.3753333 14.9846226,55.1664444 C14.6940566,54.9564444 14.3374528,55.0208889 14.1195283,55.3286667"/>
					<path d="M38.4392453,57.2156667 C37.9219497,57.4223333 37.7040252,57.9501111 37.9197484,58.499 C38.1365723,59.049 38.6527673,59.2823333 39.1711635,59.0756667 C39.6884591,58.8678889 39.9063836,58.3401111 39.6895597,57.7912222 C39.4738365,57.2401111 38.9565409,57.0078889 38.4392453,57.2156667"/>
					<path d="M51.7951572,46.8437778 C51.4803774,47.4226667 51.1413836,47.986 50.7847799,48.5371111 L52.0725157,49.376 L36.1255031,54.6782222 C34.6539623,55.1671111 33.1119811,55.4993333 31.5171698,55.6482222 L31.5171698,54.326 C30.878805,54.3893333 30.2327358,54.4237778 29.5789623,54.4237778 C29.5041195,54.4237778 29.4303774,54.4182222 29.3555346,54.4171111 L29.1618239,54.6615556 C28.7920126,55.1226667 28.313239,55.4582222 27.7761321,55.6604444 C26.1890252,55.5226667 24.6536478,55.2037778 23.1865094,54.7293333 L7.08540881,49.376 L8.37424528,48.5371111 C8.01764151,47.986 7.67754717,47.4226667 7.3627673,46.8437778 L0.140440252,50.836 C0.549874214,51.5904444 0.991226415,52.3226667 1.45459119,53.0404444 L3.62503145,51.6282222 L29.5789623,68.4337778 L55.5328931,51.6282222 L57.7033333,53.0404444 C58.1666981,52.3226667 58.6080503,51.5893333 59.0174843,50.836 L51.7951572,46.8437778 Z"/>
					<path d="M32.2681289,41.4832222 C32.2219025,41.4832222 32.1756761,41.4854444 32.1305503,41.4898889 C31.6814937,41.5398889 31.2918711,41.8287778 31.1113679,42.2432222 L30.1439151,44.4643333 C30.0096384,44.7732222 30.001934,45.1187778 30.1252044,45.4365556 C30.2484748,45.7554444 30.4840094,46.0054444 30.7899843,46.1398889 C30.9506761,46.2121111 31.120173,46.2487778 31.2940723,46.2487778 C31.4503616,46.2487778 31.6055503,46.2187778 31.7541352,46.161 C32.0689151,46.0365556 32.3165566,45.7976667 32.451934,45.4876667 L33.4193868,43.2665556 C33.6989465,42.6243333 33.4083805,41.8732222 32.772217,41.5898889 C32.6126258,41.5187778 32.4431289,41.4832222 32.2681289,41.4832222 M31.2929717,47.391 C30.9616824,47.391 30.6391981,47.3232222 30.3343239,47.1876667 C29.7509906,46.9276667 29.301934,46.4543333 29.0697013,45.8521111 C28.8374686,45.2487778 28.8506761,44.5921111 29.1071226,44.0043333 L30.0745755,41.7832222 C30.4564937,40.9054444 31.3182862,40.3398889 32.2692296,40.3398889 C32.6016195,40.3398889 32.9241038,40.4076667 33.2278774,40.5432222 C34.4363679,41.0798889 34.9866824,42.5087778 34.4561792,43.7287778 L33.4887264,45.9487778 C33.2311792,46.5387778 32.7623113,46.991 32.1646698,47.2254444 C31.9665566,47.3032222 31.7596384,47.3543333 31.5516195,47.3776667 C31.4657704,47.3865556 31.3788208,47.391 31.2929717,47.391"/>
					<path d="M33.7427516,32.4657778 C33.4752987,32.4691111 33.2177516,32.558 33.0009277,32.7257778 C32.7312736,32.9313333 32.5573742,33.2291111 32.5122484,33.5646667 L32.184261,35.968 C32.1380346,36.3046667 32.2260849,36.6391111 32.4297013,36.9102222 C32.6333176,37.1813333 32.9293868,37.3568889 33.2617767,37.4024444 C33.3201101,37.4113333 33.3784434,37.4146667 33.4356761,37.4146667 C34.0608333,37.4146667 34.5968396,36.9424444 34.6826887,36.3157778 L35.0095755,33.9113333 C35.0558019,33.5746667 34.9688522,33.2402222 34.7652358,32.9691111 C34.5616195,32.698 34.2655503,32.5235556 33.9320597,32.4768889 C33.8781289,32.4691111 33.8219969,32.4657778 33.7669654,32.4657778 L33.7647642,32.4657778 L33.7427516,32.4657778 Z M33.4279717,38.558 C33.3223113,38.558 33.2155503,38.5502222 33.1076887,38.5346667 C32.4759277,38.4468889 31.9135063,38.1146667 31.5271855,37.6013333 C31.1408648,37.0857778 30.9757704,36.4502222 31.0627201,35.8124444 L31.3907075,33.4091111 C31.4765566,32.7713333 31.8056447,32.2057778 32.3163365,31.8146667 C32.7367767,31.4924444 33.2364623,31.3213333 33.7581604,31.3213333 C33.8671226,31.3213333 33.9771855,31.3291111 34.0861478,31.3446667 C34.7190094,31.4313333 35.2803302,31.7635556 35.6677516,32.2791111 C36.0540723,32.7935556 36.2191667,33.4291111 36.1311164,34.0668889 L35.8042296,36.4702222 C35.6446384,37.6446667 34.6397642,38.5413333 33.4675943,38.558 L33.4279717,38.558 Z"/>
					<path d="M23.9811635,17.3453333 C23.8644969,17.3453333 23.7467296,17.362 23.6344654,17.3953333 C22.9663836,17.5908889 22.5800629,18.2975556 22.772673,18.9708889 L23.4396541,21.302 C23.5948428,21.8431111 24.0945283,22.2208889 24.6525472,22.2208889 C24.7703145,22.2208889 24.8869811,22.2053333 25.0003459,22.172 C25.3228302,22.0775556 25.590283,21.8608889 25.7531761,21.562 C25.9160692,21.2631111 25.9545912,20.9197778 25.8621384,20.5953333 L25.1951572,18.2642222 C25.1027044,17.9408889 24.8880818,17.6708889 24.5920126,17.5053333 C24.4951572,17.4508889 24.3905975,17.4097778 24.2805346,17.382 C24.1825786,17.3575556 24.0813208,17.3453333 23.9811635,17.3453333 M24.6525472,23.3642222 C24.4610377,23.3642222 24.2684277,23.3408889 24.0813208,23.2942222 C23.2514465,23.0875556 22.5888679,22.4464444 22.3522327,21.6197778 L21.6852516,19.2886667 C21.3187421,18.0097778 22.051761,16.6675556 23.3185849,16.2975556 C23.5365094,16.2342222 23.7610377,16.202 23.9844654,16.202 C24.3839937,16.202 24.783522,16.3053333 25.1390252,16.5042222 C25.7003459,16.8164444 26.106478,17.3286667 26.2825786,17.9475556 L26.9506604,20.2786667 C27.126761,20.8964444 27.0541195,21.5486667 26.7448428,22.1142222 C26.4344654,22.6808889 25.9281761,23.0908889 25.3151258,23.2697778 C25.0994025,23.3331111 24.8759748,23.3642222 24.6525472,23.3642222"/>
					<path d="M22.1641352,8.82855556 C22.3677516,8.54744444 22.6704245,8.34633333 23.0270283,8.30411111 C23.075456,8.29855556 23.1238836,8.29633333 23.1734119,8.29633333 C23.2669654,8.29633333 23.3616195,8.30633333 23.4540723,8.32744444 C23.6830031,8.37966667 23.8866195,8.49855556 24.0517138,8.66188889 L25.329544,8.54966667 C25.2877201,8.45855556 25.2502987,8.36744444 25.1963679,8.28188889 C24.855173,7.73411111 24.3246698,7.35522222 23.7028145,7.213 C23.5289151,7.17188889 23.3495126,7.153 23.1723113,7.153 C22.0980975,7.153 21.1482547,7.90188889 20.868695,8.943 L22.1641352,8.82855556 Z"/>
					<path d="M29.6740566,5.19522222 C29.4033019,4.83855556 28.8827044,4.76077778 28.5128931,5.02188889 L23.236478,8.73411111 L26.4558176,8.44966667 L29.4935535,6.31188889 C29.8644654,6.05188889 29.9448113,5.55188889 29.6740566,5.19522222"/>
					<path d="M20.2831604,13.9051111 C20.313978,13.9662222 20.3370912,14.0295556 20.3745126,14.0884444 C20.7157075,14.6351111 21.2451101,15.0151111 21.8669654,15.1573333 C22.0441667,15.1984444 22.2235692,15.2184444 22.4018711,15.2184444 C22.4932233,15.2184444 22.5856761,15.2128889 22.6770283,15.2017778 C23.0303302,15.1595556 23.3638208,15.0395556 23.6708962,14.844 C23.9185377,14.6873333 24.125456,14.4862222 24.2971541,14.2595556 L20.2831604,13.9051111 Z"/>
					<path d="M21.1678459,12.52 L21.5211478,10.95 C21.2834119,10.9455556 21.0456761,10.9433333 20.8068396,10.9366667 C20.660456,10.9322222 20.5173742,10.9066667 20.3753931,10.8822222 L20.0639151,12.2666667 C20.0088836,12.5122222 20.0033805,12.7588889 20.0231918,13.0022222 L21.1799528,13.1044444 C21.1326258,12.9133333 21.1238208,12.7155556 21.1678459,12.52"/>
					<path d="M25.2779245,10.8554444 C24.8894025,10.8876667 24.5008805,10.911 24.1112579,10.9276667 L23.6269811,13.0832222 C23.6082704,13.1632222 23.5818553,13.2398889 23.5510377,13.3132222 L24.7044969,13.4154444 C24.7122013,13.3887778 24.7254088,13.3643333 24.7309119,13.3365556 L25.2636164,10.971 C25.2724214,10.9321111 25.2713208,10.8943333 25.2779245,10.8554444"/>
					<path d="M34.6886321,24.268 L34.6886321,30.5957778 C36.1997956,31.0502222 37.2035692,32.5613333 36.9823428,34.1857778 L36.655456,36.5891111 C36.4958648,37.7568889 35.7177201,38.7168889 34.6886321,39.1602222 L34.6886321,40.5713333 C35.5086006,41.5024444 35.7694497,42.8646667 35.2411478,44.0768889 L34.8834434,44.9002222 L38.9183491,44.9002222 L38.9183491,24.268 L34.6886321,24.268 Z"/>
					<path d="M29.5788522,15.8918889 C28.4165881,15.8918889 27.2818396,16.0052222 26.1801101,16.2118889 C26.6148585,16.6141111 26.9406447,17.1218889 27.1079403,17.7063333 L27.5845126,19.3752222 C28.2382862,19.2885556 28.903066,19.2396667 29.5788522,19.2396667 C37.9678459,19.2396667 44.7686321,26.1041111 44.7686321,34.573 C44.7686321,42.4685556 38.8571541,48.9685556 31.2595126,49.8118889 C31.3090409,49.9907778 31.3519654,50.1741111 31.3717767,50.3618889 C31.4642296,51.2363333 31.2154874,52.0907778 30.6706761,52.7718889 L30.2997642,53.2363333 C40.1856132,52.8541111 48.0837264,44.6474444 48.0837264,34.573 C48.0837264,24.2552222 39.7992925,15.8918889 29.5788522,15.8918889"/>
					<path d="M24.0999214,50.5392222 L25.1378145,49.2403333 C18.9159591,47.3214444 14.3890723,41.4825556 14.3890723,34.5736667 C14.3890723,29.1203333 17.2110849,24.3358889 21.4584119,21.617 L20.8607704,19.5292222 C20.7264937,19.0625556 20.7033805,18.5914444 20.7705189,18.1403333 C14.9955189,21.3025556 11.073978,27.4747778 11.073978,34.5736667 C11.073978,42.7081111 16.226022,49.6247778 23.4142296,52.1881111 C23.4879717,51.5892222 23.7158019,51.0203333 24.0999214,50.5392222"/>
					<path d="M29.0833491,51.4821111 L27.6107075,53.3998889 C27.4048899,53.6665556 27.1077201,53.8376667 26.7720283,53.881 C26.6135377,53.901 26.4561478,53.8921111 26.304261,53.8532222 C26.1358648,53.811 25.9795755,53.7332222 25.8419969,53.6254444 C25.5778459,53.4187778 25.4094497,53.1187778 25.3665252,52.7787778 C25.3225,52.4398889 25.4138522,52.1065556 25.6185692,51.8398889 L27.0912107,49.9232222 C27.3652673,49.5643333 27.8143239,49.3798889 28.2600786,49.4421111 C28.3052044,49.4498889 28.3514308,49.4576667 28.3965566,49.4687778 C28.5660535,49.5121111 28.7212421,49.5887778 28.8599214,49.6965556 C29.4080346,50.1265556 29.5092925,50.9276667 29.0833491,51.4821111 M29.5533176,48.7932222 C29.2902673,48.5876667 28.9941981,48.4421111 28.6728145,48.3598889 C27.7504874,48.1265556 26.7775314,48.4654444 26.1952987,49.2221111 L24.7237579,51.1387778 C24.3330346,51.6465556 24.1613365,52.281 24.242783,52.9232222 C24.3231289,53.5643333 24.6445126,54.1354444 25.1475,54.5276667 C25.1519025,54.531 25.156305,54.5332222 25.1607075,54.5365556 C25.8937264,54.701 26.6333491,54.8265556 27.3773742,54.9087778 C27.8220283,54.7587778 28.2127516,54.481 28.5055189,54.0998889 L29.9781604,52.1832222 C30.786022,51.131 30.5967138,49.6098889 29.5533176,48.7932222"/>
					<path d="M33.8245283,34.0461111 C33.7441824,34.0461111 33.6649371,34.0305556 33.591195,34.0016667 C33.4294025,33.9383333 33.3017296,33.8138889 33.2323899,33.6516667 L32.3397799,31.5594444 L32.345283,28.2361111 L34.427673,33.1105556 C34.5718553,33.445 34.4199686,33.8394444 34.0886792,33.9883333 C34.0050314,34.0261111 33.9158805,34.0461111 33.8245283,34.0461111"/>
					<path d="M24.4374843,21.7246667 C24.3175157,21.5991111 24.2536792,21.4335556 24.2558805,21.2591111 C24.2591824,21.0846667 24.328522,20.9213333 24.4539937,20.7991111 C24.5750629,20.6802222 24.7335535,20.6146667 24.9019497,20.6146667 C25.0802516,20.6146667 25.2464465,20.6857778 25.3708176,20.8157778 L26.8148428,22.328 L26.8148428,24.2135556 L24.4374843,21.7246667 Z"/>
					<path d="M32.2858491,43.0652222 C32.2484277,43.0652222 32.2121069,43.0618889 32.1735849,43.0552222 C31.8070755,42.9785556 31.5858491,42.6474444 31.645283,42.2996667 L32.6699686,36.3496667 C32.7238994,36.0352222 32.9924528,35.8074444 33.3083333,35.8074444 C33.3446541,35.8074444 33.3820755,35.8096667 33.4194969,35.8174444 C33.5867925,35.8418889 33.7320755,35.933 33.8333333,36.073 C33.9356918,36.2163333 33.9775157,36.3985556 33.9477987,36.573 L32.9231132,42.523 C32.8691824,42.8363333 32.6017296,43.0652222 32.2858491,43.0652222"/>
					<path d="M26.5785377,54.7134444 C26.1052673,54.6423333 25.6804245,54.5645556 25.2863994,54.479 L25.8928459,52.7212222 C25.9830975,52.459 26.2296384,52.2823333 26.5058962,52.2823333 C26.5785377,52.2823333 26.648978,52.2945556 26.7183176,52.319 C26.8823113,52.3756667 27.0143868,52.4945556 27.0881289,52.6523333 C27.1640723,52.809 27.1750786,52.9867778 27.1178459,53.1523333 L26.5785377,54.7134444 Z"/>
					<path d="M28.1730189,51.1153333 C28.0607547,51.1153333 27.9506918,51.0853333 27.8516352,51.0286667 C27.7019497,50.942 27.5940881,50.8008889 27.5489623,50.632 C27.5027358,50.4642222 27.5258491,50.2875556 27.6116981,50.1353333 L30.5800943,44.8931111 C30.6956604,44.6908889 30.9113836,44.5642222 31.144717,44.5642222 C31.2558805,44.5642222 31.367044,44.5942222 31.465,44.6508889 C31.7753774,44.8297778 31.883239,45.2308889 31.7049371,45.5431111 L28.7365409,50.7853333 C28.6220755,50.9886667 28.4074528,51.1142222 28.1763208,51.1153333 L28.1730189,51.1153333 Z"/>
					<path d="M23.9289937,18.8638889 C23.6417296,18.8583333 23.3885849,18.6572222 23.3148428,18.3772222 L22.2538365,14.3172222 L23.5977044,14.3261111 L24.5684591,18.0416667 C24.6135849,18.2116667 24.5893711,18.3872222 24.5024214,18.5383333 C24.4143711,18.6894444 24.2745912,18.7972222 24.1072956,18.8416667 C24.0533648,18.8561111 23.9972327,18.8638889 23.9411006,18.8638889 L23.9289937,18.8638889 Z"/>
					<path d="M32.2675786,12.7185556 L32.4822013,11.0318889 L31.9197799,11.1685556 L31.9913208,10.6163333 L33.1370755,10.3318889 L32.8222956,12.7907778 L32.2675786,12.7185556 Z M31.6072013,12.103 L31.5796855,12.6263333 L29.9342453,12.5418889 L29.9562579,12.0996667 L30.8334591,11.3174444 C30.9567296,11.2085556 31.0227673,11.0918889 31.0293711,10.9596667 C31.0392767,10.7774444 30.9127044,10.6485556 30.73,10.6396667 C30.5109748,10.6285556 30.3623899,10.7496667 30.2259119,10.8852222 L29.914434,10.4852222 C30.0729245,10.3096667 30.3546855,10.0796667 30.8158491,10.1041111 C31.3243396,10.1296667 31.6369182,10.4596667 31.6127044,10.933 C31.5983962,11.223 31.477327,11.4007778 31.2142767,11.6407778 L30.7542138,12.0596667 L31.6072013,12.103 Z M29.4587736,11.5685556 L28.8501258,12.5641111 L28.1765409,12.5874444 L28.7268553,11.7441111 L28.689434,11.7463333 C28.1468239,11.7652222 27.8089308,11.4152222 27.793522,10.9618889 C27.7759119,10.4707778 28.1677358,10.0952222 28.7059434,10.0763333 C29.2408491,10.0563333 29.6623899,10.3952222 29.6788994,10.8796667 C29.6877044,11.1096667 29.6051572,11.333 29.4587736,11.5685556 Z M26.9999686,12.7041111 L26.8106604,11.0185556 L26.2977673,11.2852222 L26.2361321,10.7341111 L27.2795283,10.1818889 L27.5546855,12.6407778 L26.9999686,12.7041111 Z M46.8454088,10.5496667 L31.5169497,9.19633333 L31.5169497,8.29522222 C32.7452516,7.60744444 33.5784277,6.28522222 33.5784277,4.76633333 C33.5784277,2.53855556 31.788805,0.733 29.5831447,0.733 C27.3763836,0.733 25.586761,2.53855556 25.586761,4.76633333 C25.586761,5.26633333 25.684717,5.74188889 25.8498113,6.183 L27.677956,4.89633333 C27.6735535,4.853 27.6647484,4.81077778 27.6647484,4.76633333 C27.6647484,3.69744444 28.523239,2.83077778 29.5831447,2.83077778 C30.6419497,2.83077778 31.5004403,3.69744444 31.5004403,4.76633333 C31.5004403,4.86855556 31.4861321,4.96522222 31.4707233,5.063 C31.4542138,5.17077778 31.4266981,5.27522222 31.3936792,5.37633333 C31.3903774,5.38744444 31.3870755,5.39966667 31.3837736,5.40966667 C31.3507547,5.503 31.3100314,5.59077778 31.2649057,5.67744444 C31.255,5.69633333 31.2450943,5.71522222 31.2351887,5.73411111 C31.1911635,5.81077778 31.1416352,5.883 31.088805,5.953 C31.0689937,5.97855556 31.0480818,6.00411111 31.0271698,6.02855556 C30.9765409,6.08744444 30.9226101,6.14411111 30.8653774,6.19633333 C30.8323585,6.22633333 30.7971384,6.25411111 30.7630189,6.283 C30.7090881,6.32522222 30.6562579,6.36633333 30.5990252,6.40188889 C30.5494969,6.433 30.4988679,6.45966667 30.4471384,6.48522222 C30.3965094,6.51188889 30.3458805,6.53966667 30.2919497,6.56188889 C30.2237107,6.58966667 30.1521698,6.60855556 30.0806289,6.62855556 C30.0465094,6.63744444 30.0145912,6.64744444 29.9804717,6.65633333 C29.9309434,6.703 29.8825157,6.75077778 29.8241824,6.79188889 L27.6416352,8.32744444 L27.6416352,9.22411111 L12.2977673,10.5796667 L13.6350314,12.4385556 L27.6416352,13.6752222 L27.6416352,14.8207778 C28.2788994,14.7574444 28.9249686,14.723 29.5787421,14.723 C30.2325157,14.723 30.8785849,14.7574444 31.5169497,14.8207778 L31.5169497,13.7041111 L45.4619182,12.4718889 L46.8454088,10.5496667 Z"/>
				</g>
			</g>
		</svg>
	</xsl:variable>

	<xsl:variable name="Image-Text-IHO-SVG">
		<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="100px" height="100px" viewBox="0 0 100 100" version="1.1">
			<polygon fill="#F5EED6" points="0 100 100 100 100 0 0 0"/>
			<polygon fill="#2F4565" points="16 41 17 41 17 33 16 33"/>
			<g>
				<path d="M18.9185915,35.2588028 L19.6073239,35.2588028 L19.6073239,36.231338 L19.6284507,36.231338 C19.8805634,35.5538732 20.6340845,35.0947183 21.4312676,35.0947183 C23.0164789,35.0947183 23.4967606,35.9257042 23.4967606,37.2693662 L23.4967606,40.896831 L22.8080282,40.896831 L22.8080282,37.3785211 C22.8080282,36.4059859 22.491831,35.6735915 21.3770423,35.6735915 C20.2840845,35.6735915 19.6284507,36.5038732 19.6073239,37.6080986 L19.6073239,40.896831 L18.9185915,40.896831 L18.9185915,35.2588028 Z" fill="#2F4565"/>
				<path d="M26.4402113,35.2588028 L27.5873944,35.2588028 L27.5873944,35.8383803 L26.4402113,35.8383803 L26.4402113,39.6397887 C26.4402113,40.0890845 26.5057042,40.3503521 26.9972535,40.3841549 C27.1944366,40.3841549 27.3902113,40.3728873 27.5873944,40.3503521 L27.5873944,40.940493 C27.3789437,40.940493 27.183169,40.9623239 26.9754225,40.9623239 C26.0585211,40.9623239 25.7409155,40.6566901 25.7514789,39.6954225 L25.7514789,35.8383803 L24.7683803,35.8383803 L24.7683803,35.2588028 L25.7514789,35.2588028 L25.7514789,33.5651408 L26.4402113,33.5651408 L26.4402113,35.2588028 Z" fill="#2F4565"/>
				<path d="M33.1842958,37.6847183 C33.1519014,36.6466901 32.506831,35.6741549 31.3927465,35.6741549 C30.2673944,35.6741549 29.6441549,36.6579577 29.535,37.6847183 L33.1842958,37.6847183 Z M29.535,38.2628873 C29.5455634,39.2685211 30.0702113,40.4819014 31.3927465,40.4819014 C32.3976761,40.4819014 32.9448592,39.8917606 33.1624648,39.0396479 L33.8511972,39.0396479 C33.5561268,40.3178169 32.813169,41.0600704 31.3927465,41.0600704 C29.600493,41.0600704 28.8469718,39.6847183 28.8469718,38.0783803 C28.8469718,36.5917606 29.600493,35.0945775 31.3927465,35.0945775 C33.2061268,35.0945775 33.9272535,36.6790845 33.8730282,38.2628873 L29.535,38.2628873 Z" fill="#2F4565"/>
				<path d="M35.3523239,35.2588028 L35.9847183,35.2588028 L35.9847183,36.581338 L36.0072535,36.581338 C36.3565493,35.6735915 37.1227465,35.1390845 38.1389437,35.1827465 L38.1389437,35.8707746 C36.8924648,35.8045775 36.0410563,36.7228873 36.0410563,37.8919014 L36.0410563,40.896831 L35.3523239,40.896831 L35.3523239,35.2588028 Z" fill="#2F4565"/>
				<path d="M39.5288732,35.2588028 L40.2176056,35.2588028 L40.2176056,36.231338 L40.2387324,36.231338 C40.4894366,35.5538732 41.243662,35.0947183 42.0415493,35.0947183 C43.6253521,35.0947183 44.1070423,35.9257042 44.1070423,37.2693662 L44.1070423,40.896831 L43.4183099,40.896831 L43.4183099,37.3785211 C43.4183099,36.4059859 43.1021127,35.6735915 41.9873239,35.6735915 C40.893662,35.6735915 40.2387324,36.5038732 40.2176056,37.6080986 L40.2176056,40.896831 L39.5288732,40.896831 L39.5288732,35.2588028 Z" fill="#2F4565"/>
				<path d="M49.5626761,37.8154225 L49.5408451,37.8154225 C49.4535211,37.979507 49.1478873,38.0344366 48.9619718,38.066831 C47.7922535,38.2752817 46.3394366,38.2633099 46.3394366,39.3675352 C46.3394366,40.0562676 46.9514085,40.4823239 47.5964789,40.4823239 C48.6450704,40.4823239 49.5732394,39.8154225 49.5626761,38.7119014 L49.5626761,37.8154225 Z M45.8915493,36.9851408 C45.9570423,35.6626056 46.8859155,35.0942958 48.1746479,35.0942958 C49.1690141,35.0942958 50.2514085,35.4006338 50.2514085,36.9090845 L50.2514085,39.9027465 C50.2514085,40.1647183 50.3830986,40.3175352 50.656338,40.3175352 C50.7323944,40.3175352 50.8197183,40.2957042 50.8739437,40.2738732 L50.8739437,40.8534507 C50.721831,40.8865493 50.6119718,40.8971127 50.4267606,40.8971127 C49.7267606,40.8971127 49.6183099,40.5041549 49.6183099,39.9133099 L49.5964789,39.9133099 C49.1147887,40.6457042 48.6239437,41.060493 47.5415493,41.060493 C46.5035211,41.060493 45.6507042,40.5471127 45.6507042,39.4111972 C45.6507042,37.8266901 47.1922535,37.7717606 48.678169,37.5971127 C49.2464789,37.5309155 49.5626761,37.4548592 49.5626761,36.8316197 C49.5626761,35.9034507 48.8971831,35.6738732 48.0873239,35.6738732 C47.2359155,35.6738732 46.6014085,36.066831 46.5802817,36.9851408 L45.8915493,36.9851408 Z" fill="#2F4565"/>
				<path d="M53.2709155,35.2588028 L54.4188028,35.2588028 L54.4188028,35.8383803 L53.2709155,35.8383803 L53.2709155,39.6397887 C53.2709155,40.0890845 53.3364085,40.3503521 53.828662,40.3841549 C54.0244366,40.3841549 54.2216197,40.3728873 54.4188028,40.3503521 L54.4188028,40.940493 C54.2110563,40.940493 54.0138732,40.9623239 53.806831,40.9623239 C52.8885211,40.9623239 52.5716197,40.6566901 52.5821831,39.6954225 L52.5821831,35.8383803 L51.5983803,35.8383803 L51.5983803,35.2588028 L52.5821831,35.2588028 L52.5821831,33.5651408 L53.2709155,33.5651408 L53.2709155,35.2588028 Z" fill="#2F4565"/>
				<g/>
				<path d="M55.9725352,40.8971831 L56.6612676,40.8971831 L56.6612676,35.2591549 L55.9725352,35.2591549 L55.9725352,40.8971831 Z M55.9725352,34.1985915 L56.6612676,34.1985915 L56.6612676,33.0950704 L55.9725352,33.0950704 L55.9725352,34.1985915 Z" fill="#2F4565"/>
				<path d="M58.9352817,38.0780986 C58.9352817,39.279507 59.5909155,40.4823239 60.9127465,40.4823239 C62.2352817,40.4823239 62.8909155,39.279507 62.8909155,38.0780986 C62.8909155,36.8759859 62.2352817,35.6738732 60.9127465,35.6738732 C59.5909155,35.6738732 58.9352817,36.8759859 58.9352817,38.0780986 M63.5789437,38.0780986 C63.5789437,39.6957042 62.6388028,41.060493 60.9127465,41.060493 C59.1859859,41.060493 58.2465493,39.6957042 58.2465493,38.0780986 C58.2465493,36.460493 59.1859859,35.0942958 60.9127465,35.0942958 C62.6388028,35.0942958 63.5789437,36.460493 63.5789437,38.0780986" fill="#2F4565"/>
				<path d="M65.1457746,35.2588028 L65.834507,35.2588028 L65.834507,36.231338 L65.8556338,36.231338 C66.1077465,35.5538732 66.8612676,35.0947183 67.6584507,35.0947183 C69.243662,35.0947183 69.7239437,35.9257042 69.7239437,37.2693662 L69.7239437,40.896831 L69.0352113,40.896831 L69.0352113,37.3785211 C69.0352113,36.4059859 68.7190141,35.6735915 67.6042254,35.6735915 C66.5112676,35.6735915 65.8556338,36.5038732 65.834507,37.6080986 L65.834507,40.896831 L65.1457746,40.896831 L65.1457746,35.2588028 Z" fill="#2F4565"/>
				<path d="M75.1806338,37.8154225 L75.1588028,37.8154225 C75.0714789,37.979507 74.7658451,38.0344366 74.5799296,38.066831 C73.4102113,38.2752817 71.9573944,38.2633099 71.9573944,39.3675352 C71.9573944,40.0562676 72.5693662,40.4823239 73.2144366,40.4823239 C74.2637324,40.4823239 75.1919014,39.8154225 75.1806338,38.7119014 L75.1806338,37.8154225 Z M71.509507,36.9851408 C71.575,35.6626056 72.5038732,35.0942958 73.7926056,35.0942958 C74.7869718,35.0942958 75.8693662,35.4006338 75.8693662,36.9090845 L75.8693662,39.9027465 C75.8693662,40.1647183 76.0010563,40.3175352 76.2742958,40.3175352 C76.3503521,40.3175352 76.4376761,40.2957042 76.4919014,40.2738732 L76.4919014,40.8534507 C76.3397887,40.8865493 76.2299296,40.8971127 76.0447183,40.8971127 C75.3447183,40.8971127 75.2362676,40.5041549 75.2362676,39.9133099 L75.2144366,39.9133099 C74.7327465,40.6457042 74.2419014,41.060493 73.159507,41.060493 C72.1214789,41.060493 71.268662,40.5471127 71.268662,39.4111972 C71.268662,37.8266901 72.8102113,37.7717606 74.2961268,37.5971127 C74.8644366,37.5309155 75.1806338,37.4548592 75.1806338,36.8316197 C75.1806338,35.9034507 74.5151408,35.6738732 73.7059859,35.6738732 C72.8538732,35.6738732 72.2193662,36.066831 72.1982394,36.9851408 L71.509507,36.9851408 Z" fill="#2F4565"/>
				<polygon fill="#2F4565" points="77.8070423 40.8971831 78.4957746 40.8971831 78.4957746 33.0950704 77.8070423 33.0950704"/>
				<polygon fill="#2F4565" points="16.0861972 47.4462676 16.8305634 47.4462676 16.8305634 50.8328873 21.4629577 50.8328873 21.4629577 47.4462676 22.2059155 47.4462676 22.2059155 55.2483803 21.4629577 55.2483803 21.4629577 51.4666901 16.8305634 51.4666901 16.8305634 55.2483803 16.0861972 55.2483803"/>
				<path d="M23.565493,49.6094366 L24.2978873,49.6094366 L26.156338,54.4178873 L27.893662,49.6094366 L28.5823944,49.6094366 L26.1338028,56.1108451 C25.7408451,57.0615493 25.5112676,57.335493 24.6471831,57.335493 C24.3746479,57.3242254 24.2323944,57.3242254 24.1232394,57.2805634 L24.1232394,56.7009859 C24.2866197,56.7340845 24.4401408,56.7552113 24.5929577,56.7552113 C25.2049296,56.7552113 25.3464789,56.3953521 25.5760563,55.8714085 L25.8169014,55.226338 L23.565493,49.6094366 Z" fill="#2F4565"/>
				<path d="M32.1028873,54.8330282 C33.5669718,54.8330282 34.0810563,53.5978169 34.0810563,52.4288028 C34.0810563,51.2597887 33.5669718,50.0245775 32.1028873,50.0245775 C30.7909155,50.0245775 30.2564085,51.2597887 30.2564085,52.4288028 C30.2564085,53.5978169 30.7909155,54.8330282 32.1028873,54.8330282 Z M34.7697887,55.2478169 L34.1352817,55.2478169 L34.1352817,54.1773944 L34.1134507,54.1773944 C33.8183803,54.9090845 32.9233099,55.4111972 32.1028873,55.4111972 C30.3866901,55.4111972 29.5676761,54.0245775 29.5676761,52.4288028 C29.5676761,50.8330282 30.3866901,49.445 32.1028873,49.445 C32.9444366,49.445 33.7641549,49.8724648 34.0592254,50.6809155 L34.0810563,50.6809155 L34.0810563,47.4464085 L34.7697887,47.4464085 L34.7697887,55.2478169 Z" fill="#2F4565"/>
				<path d="M36.6311972,49.6094366 L37.2635915,49.6094366 L37.2635915,50.9319718 L37.2861268,50.9319718 C37.6354225,50.0242254 38.4016197,49.4897183 39.4178169,49.5333803 L39.4178169,50.2221127 C38.171338,50.1552113 37.3199296,51.0735211 37.3199296,52.2425352 L37.3199296,55.248169 L36.6311972,55.248169 L36.6311972,49.6094366 Z" fill="#2F4565"/>
				<path d="M40.8293662,52.4288028 C40.8293662,53.6302113 41.485,54.8330282 42.806831,54.8330282 C44.1293662,54.8330282 44.785,53.6302113 44.785,52.4288028 C44.785,51.2273944 44.1293662,50.0245775 42.806831,50.0245775 C41.485,50.0245775 40.8293662,51.2273944 40.8293662,52.4288028 M45.4730282,52.4288028 C45.4730282,54.0464085 44.5328873,55.4111972 42.806831,55.4111972 C41.0800704,55.4111972 40.1406338,54.0464085 40.1406338,52.4288028 C40.1406338,50.8111972 41.0800704,49.445 42.806831,49.445 C44.5328873,49.445 45.4730282,50.8111972 45.4730282,52.4288028" fill="#2F4565"/>
				<path d="M51.1269014,52.3634507 C51.1269014,51.2599296 50.6128169,50.0247183 49.3128169,50.0247183 C48.0015493,50.0247183 47.4550704,51.1937324 47.4550704,52.3634507 C47.4550704,53.4993662 48.0452113,54.6028873 49.3128169,54.6028873 C50.503662,54.6028873 51.1269014,53.5106338 51.1269014,52.3634507 Z M51.8156338,54.789507 C51.8043662,56.4711972 51.1592958,57.498662 49.3128169,57.498662 C48.1867606,57.498662 47.0726761,56.9965493 46.9747887,55.7951408 L47.6628169,55.7951408 C47.8149296,56.6247183 48.5473239,56.920493 49.3128169,56.920493 C50.5804225,56.920493 51.1269014,56.1662676 51.1269014,54.789507 L51.1269014,54.0247183 L51.1050704,54.0247183 C50.788169,54.7120423 50.1212676,55.1824648 49.3128169,55.1824648 C47.5092958,55.1824648 46.766338,53.8930282 46.766338,52.2873944 C46.766338,50.7345775 47.6846479,49.4451408 49.3128169,49.4451408 C50.1325352,49.4451408 50.831831,49.9592254 51.1050704,50.5824648 L51.1269014,50.5824648 L51.1269014,49.6092254 L51.8156338,49.6092254 L51.8156338,54.789507 Z" fill="#2F4565"/>
				<path d="M53.6759859,49.6094366 L54.3097887,49.6094366 L54.3097887,50.9319718 L54.3316197,50.9319718 C54.6816197,50.0242254 55.4464085,49.4897183 56.4626056,49.5333803 L56.4626056,50.2221127 C55.2175352,50.1552113 54.3647183,51.0735211 54.3647183,52.2425352 L54.3647183,55.248169 L53.6759859,55.248169 L53.6759859,49.6094366 Z" fill="#2F4565"/>
				<path d="M61.2728873,52.1664085 L61.2510563,52.1664085 C61.1644366,52.330493 60.8580986,52.3854225 60.6714789,52.4178169 C59.503169,52.6262676 58.0496479,52.6142958 58.0496479,53.7185211 C58.0496479,54.4072535 58.6609155,54.8333099 59.3059859,54.8333099 C60.3545775,54.8333099 61.2841549,54.1664085 61.2728873,53.0628873 L61.2728873,52.1664085 Z M57.6010563,51.3361268 C57.6672535,50.0135915 58.5954225,49.4452817 59.8855634,49.4452817 C60.8799296,49.4452817 61.9616197,49.7509155 61.9616197,51.2600704 L61.9616197,54.2530282 C61.9616197,54.5157042 62.0926056,54.6685211 62.3658451,54.6685211 C62.4419014,54.6685211 62.5299296,54.6466901 62.5848592,54.6248592 L62.5848592,55.2044366 C62.431338,55.236831 62.3221831,55.2480986 62.1362676,55.2480986 C61.4362676,55.2480986 61.3278169,54.8544366 61.3278169,54.2642958 L61.3059859,54.2642958 C60.825,54.9966901 60.3334507,55.4114789 59.2510563,55.4114789 C58.2130282,55.4114789 57.3609155,54.8980986 57.3609155,53.7621831 C57.3609155,52.1769718 58.9017606,52.1227465 60.3876761,51.9480986 C60.9559859,51.8819014 61.2728873,51.8058451 61.2728873,51.1826056 C61.2728873,50.2544366 60.6066901,50.0241549 59.7982394,50.0241549 C58.9454225,50.0241549 58.3109155,50.4178169 58.2890845,51.3361268 L57.6010563,51.3361268 Z" fill="#2F4565"/>
				<path d="M66.5542254,50.024507 C65.0359155,50.024507 64.5767606,51.1498592 64.5767606,52.4287324 C64.5767606,53.5977465 65.0901408,54.8329577 66.5542254,54.8329577 C67.865493,54.8329577 68.4021127,53.5977465 68.4021127,52.4287324 C68.4021127,51.2597183 67.865493,50.024507 66.5542254,50.024507 Z M63.8887324,49.6097183 L64.5211268,49.6097183 L64.5211268,50.6808451 L64.543662,50.6808451 C64.8605634,49.9160563 65.6478873,49.4449296 66.5542254,49.4449296 C68.2697183,49.4449296 69.0894366,50.8329577 69.0894366,52.4287324 C69.0894366,54.024507 68.2697183,55.4111268 66.5542254,55.4111268 C65.7133803,55.4111268 64.8929577,54.9850704 64.5985915,54.1773239 L64.5767606,54.1773239 L64.5767606,57.3350704 L63.8887324,57.3350704 L63.8887324,49.6097183 Z" fill="#2F4565"/>
				<path d="M70.6990845,47.4462676 L71.3878169,47.4462676 L71.3878169,50.5821831 L71.4089437,50.5821831 C71.6610563,49.9047183 72.4152817,49.4448592 73.2117606,49.4448592 C74.7969718,49.4448592 75.2772535,50.2765493 75.2772535,51.6209155 L75.2772535,55.2483803 L74.5892254,55.2483803 L74.5892254,51.7293662 C74.5892254,50.756831 74.2723239,50.0244366 73.1575352,50.0244366 C72.0652817,50.0244366 71.4089437,50.8547183 71.3878169,51.9596479 L71.3878169,55.2483803 L70.6990845,55.2483803 L70.6990845,47.4462676 Z" fill="#2F4565"/>
				<path d="M77.1394366,55.2478873 L77.828169,55.2478873 L77.828169,49.6091549 L77.1394366,49.6091549 L77.1394366,55.2478873 Z M77.1394366,48.55 L77.828169,48.55 L77.828169,47.4464789 L77.1394366,47.4464789 L77.1394366,48.55 Z" fill="#2F4565"/>
				<path d="M83.6753521,51.3796479 C83.4901408,50.5388028 82.9760563,50.0247183 82.0802817,50.0247183 C80.7577465,50.0247183 80.1021127,51.2275352 80.1021127,52.4289437 C80.1021127,53.6303521 80.7577465,54.833169 82.0802817,54.833169 C82.9323944,54.833169 83.6316901,54.1662676 83.7197183,53.2261268 L84.4084507,53.2261268 C84.221831,54.5810563 83.3380282,55.411338 82.0802817,55.411338 C80.3542254,55.411338 79.4140845,54.0465493 79.4140845,52.4289437 C79.4140845,50.811338 80.3542254,49.4451408 82.0802817,49.4451408 C83.2816901,49.4451408 84.2112676,50.0902113 84.3640845,51.3796479 L83.6753521,51.3796479 Z" fill="#2F4565"/>
				<path d="M19.3542254,69.1293662 C21.4084507,69.1293662 22.2823944,67.4026056 22.2823944,65.6976761 C22.2823944,63.9934507 21.4084507,62.2666901 19.3542254,62.2666901 C17.2887324,62.2666901 16.4140845,63.9934507 16.4140845,65.6976761 C16.4140845,67.4026056 17.2887324,69.1293662 19.3542254,69.1293662 M19.3542254,61.6321831 C21.8021127,61.6321831 23.0253521,63.5673944 23.0253521,65.6976761 C23.0253521,67.828662 21.8021127,69.7624648 19.3542254,69.7624648 C16.8957746,69.7624648 15.6711268,67.828662 15.6711268,65.6976761 C15.6711268,63.5673944 16.8957746,61.6321831 19.3542254,61.6321831" fill="#2F4565"/>
				<path d="M24.6046479,63.960493 L25.2377465,63.960493 L25.2377465,65.2830282 L25.2595775,65.2830282 C25.6088732,64.3752817 26.3750704,63.8407746 27.3912676,63.8844366 L27.3912676,64.573169 C26.145493,64.5062676 25.2933803,65.4245775 25.2933803,66.5935915 L25.2933803,69.5985211 L24.6046479,69.5985211 L24.6046479,63.960493 Z" fill="#2F4565"/>
				<path d="M32.6702113,66.7144366 C32.6702113,65.6109155 32.156831,64.3757042 30.8561268,64.3757042 C29.5448592,64.3757042 28.9990845,65.5440141 28.9990845,66.7144366 C28.9990845,67.8503521 29.5885211,68.9538732 30.8561268,68.9538732 C32.0469718,68.9538732 32.6702113,67.8616197 32.6702113,66.7144366 Z M33.3589437,69.140493 C33.3476761,70.8221831 32.7026056,71.8496479 30.8561268,71.8496479 C29.7314789,71.8496479 28.6166901,71.3475352 28.5180986,70.1461268 L29.2061268,70.1461268 C29.3596479,70.9757042 30.0920423,71.2707746 30.8561268,71.2707746 C32.1244366,71.2707746 32.6702113,70.5172535 32.6702113,69.140493 L32.6702113,68.3757042 L32.6483803,68.3757042 C32.3314789,69.0630282 31.6645775,69.5334507 30.8561268,69.5334507 C29.0533099,69.5334507 28.3110563,68.2440141 28.3110563,66.6383803 C28.3110563,65.0855634 29.2279577,63.7961268 30.8561268,63.7961268 C31.6758451,63.7961268 32.3751408,64.3102113 32.6483803,64.9334507 L32.6702113,64.9334507 L32.6702113,63.9602113 L33.3589437,63.9602113 L33.3589437,69.140493 Z" fill="#2F4565"/>
				<path d="M38.8259859,66.5170423 L38.8041549,66.5170423 C38.716831,66.681831 38.4111972,66.7360563 38.2259859,66.7684507 C37.0555634,66.9769014 35.6027465,66.9649296 35.6027465,68.0698592 C35.6027465,68.7578873 36.2147183,69.1839437 36.8597887,69.1839437 C37.9090845,69.1839437 38.8372535,68.5170423 38.8259859,67.4135211 L38.8259859,66.5170423 Z M35.1548592,65.6867606 C35.2203521,64.3642254 36.1499296,63.7959155 37.4379577,63.7959155 C38.4330282,63.7959155 39.5147183,64.1022535 39.5147183,65.6107042 L39.5147183,68.6043662 C39.5147183,68.8670423 39.6464085,69.0191549 39.9196479,69.0191549 C39.9964085,69.0191549 40.0830282,68.9973239 40.1379577,68.975493 L40.1379577,69.5550704 C39.9851408,69.588169 39.8752817,69.5987324 39.6900704,69.5987324 C38.9907746,69.5987324 38.8816197,69.2057746 38.8816197,68.6149296 L38.8597887,68.6149296 C38.3780986,69.3473239 37.8872535,69.7621127 36.8055634,69.7621127 C35.7675352,69.7621127 34.9140141,69.2494366 34.9140141,68.1128169 C34.9140141,66.5283099 36.4555634,66.4733803 37.9414789,66.2994366 C38.510493,66.2325352 38.8259859,66.1564789 38.8259859,65.5339437 C38.8259859,64.6057746 38.160493,64.375493 37.351338,64.375493 C36.4992254,64.375493 35.8654225,64.7691549 35.8435915,65.6867606 L35.1548592,65.6867606 Z" fill="#2F4565"/>
				<path d="M41.4307746,63.960493 L42.119507,63.960493 L42.119507,64.9330282 L42.1406338,64.9330282 C42.3927465,64.2555634 43.1462676,63.7964085 43.9434507,63.7964085 C45.528662,63.7964085 46.0089437,64.6273944 46.0089437,65.9710563 L46.0089437,69.5985211 L45.3209155,69.5985211 L45.3209155,66.0802113 C45.3209155,65.1076761 45.0040141,64.3752817 43.8892254,64.3752817 C42.7969718,64.3752817 42.1406338,65.2055634 42.119507,66.3097887 L42.119507,69.5985211 L41.4307746,69.5985211 L41.4307746,63.960493 Z" fill="#2F4565"/>
				<path d="M47.8711268,69.5985915 L48.5598592,69.5985915 L48.5598592,63.9605634 L47.8711268,63.9605634 L47.8711268,69.5985915 Z M47.8711268,62.9007042 L48.5598592,62.9007042 L48.5598592,61.7971831 L47.8711268,61.7971831 L47.8711268,62.9007042 Z" fill="#2F4565"/>
				<polygon fill="#2F4565" points="50.7685915 69.0193662 54.6474648 69.0193662 54.6474648 69.5989437 49.9376056 69.5989437 49.9376056 69.0411972 53.6207042 64.5397887 50.1890141 64.5397887 50.1890141 63.9602113 54.4939437 63.9602113 54.4939437 64.4517606"/>
				<path d="M59.6443662,66.5170423 L59.6225352,66.5170423 C59.5359155,66.681831 59.2295775,66.7360563 59.0429577,66.7684507 C57.8739437,66.9769014 56.4211268,66.9649296 56.4211268,68.0698592 C56.4211268,68.7578873 57.0323944,69.1839437 57.6774648,69.1839437 C58.7260563,69.1839437 59.6556338,68.5170423 59.6443662,67.4135211 L59.6443662,66.5170423 Z M55.9725352,65.6867606 C56.0387324,64.3642254 56.9669014,63.7959155 58.256338,63.7959155 C59.2514085,63.7959155 60.3330986,64.1022535 60.3330986,65.6107042 L60.3330986,68.6043662 C60.3330986,68.8670423 60.4640845,69.0191549 60.7373239,69.0191549 C60.8133803,69.0191549 60.9014085,68.9973239 60.956338,68.975493 L60.956338,69.5550704 C60.8028169,69.588169 60.693662,69.5987324 60.5070423,69.5987324 C59.8077465,69.5987324 59.6992958,69.2057746 59.6992958,68.6149296 L59.6767606,68.6149296 C59.1964789,69.3473239 58.7042254,69.7621127 57.6225352,69.7621127 C56.584507,69.7621127 55.7323944,69.2494366 55.7323944,68.1128169 C55.7323944,66.5283099 57.2732394,66.4733803 58.7591549,66.2994366 C59.3274648,66.2325352 59.6443662,66.1564789 59.6443662,65.5339437 C59.6443662,64.6057746 58.978169,64.375493 58.1697183,64.375493 C57.3161972,64.375493 56.6823944,64.7691549 56.6605634,65.6867606 L55.9725352,65.6867606 Z" fill="#2F4565"/>
				<path d="M63.3525352,63.960493 L64.4997183,63.960493 L64.4997183,64.5400704 L63.3525352,64.5400704 L63.3525352,68.3421831 C63.3525352,68.7907746 63.4180282,69.0520423 63.9095775,69.0858451 C64.1060563,69.0858451 64.3025352,69.0752817 64.4997183,69.0520423 L64.4997183,69.6421831 C64.2912676,69.6421831 64.095493,69.6647183 63.8877465,69.6647183 C62.9701408,69.6647183 62.6532394,69.3583803 62.6638028,68.3971127 L62.6638028,64.5400704 L61.68,64.5400704 L61.68,63.960493 L62.6638028,63.960493 L62.6638028,62.266831 L63.3525352,62.266831 L63.3525352,63.960493 Z" fill="#2F4565"/>
				<path d="M66.0535211,69.5985915 L66.7422535,69.5985915 L66.7422535,63.9605634 L66.0535211,63.9605634 L66.0535211,69.5985915 Z M66.0535211,62.9007042 L66.7422535,62.9007042 L66.7422535,61.7971831 L66.0535211,61.7971831 L66.0535211,62.9007042 Z" fill="#2F4565"/>
				<path d="M69.0159155,66.7797887 C69.0159155,67.9811972 69.6722535,69.1840141 70.9940845,69.1840141 C72.3166197,69.1840141 72.9729577,67.9811972 72.9729577,66.7797887 C72.9729577,65.5783803 72.3166197,64.3755634 70.9940845,64.3755634 C69.6722535,64.3755634 69.0159155,65.5783803 69.0159155,66.7797887 M73.6609859,66.7797887 C73.6609859,68.3973944 72.7208451,69.7621831 70.9940845,69.7621831 C69.2673239,69.7621831 68.3271831,68.3973944 68.3271831,66.7797887 C68.3271831,65.1621831 69.2673239,63.7959859 70.9940845,63.7959859 C72.7208451,63.7959859 73.6609859,65.1621831 73.6609859,66.7797887" fill="#2F4565"/>
				<path d="M75.2273944,63.960493 L75.9161268,63.960493 L75.9161268,64.9330282 L75.9379577,64.9330282 C76.1879577,64.2555634 76.9421831,63.7964085 77.7407746,63.7964085 C79.3245775,63.7964085 79.8055634,64.6273944 79.8055634,65.9710563 L79.8055634,69.5985211 L79.1175352,69.5985211 L79.1175352,66.0802113 C79.1175352,65.1076761 78.8006338,64.3752817 77.6858451,64.3752817 C76.5921831,64.3752817 75.9379577,65.2055634 75.9161268,66.3097887 L75.9161268,69.5985211 L75.2273944,69.5985211 L75.2273944,63.960493 Z" fill="#2F4565"/>
			</g>
		</svg>
	</xsl:variable>

	<!-- https://www.metanorma.org/ns/standoc -->
	<xsl:variable name="namespace_full" select="namespace-uri(//mn:metanorma[1])"/>

	<!-- https://www.metanorma.org/ns/xsl -->
	<xsl:variable name="namespace_mn_xsl">https://www.metanorma.org/ns/xslt</xsl:variable>

	<xsl:variable name="root_element">metanorma</xsl:variable>

	<!---examples: 2013, 2024 -->
	<xsl:variable name="document_scheme" select="normalize-space(//mn:metanorma/mn:metanorma-extension/mn:presentation-metadata[mn:name = 'document-scheme']/mn:value)"/>

	<!-- external parameters -->
	<xsl:param name="svg_images"/> <!-- svg images array -->
	<xsl:variable name="images" select="document($svg_images)"/>
	<xsl:param name="basepath"/> <!-- base path for images -->
	<xsl:param name="inputxml_basepath"/> <!-- input xml file path -->
	<xsl:param name="inputxml_filename"/> <!-- input xml file name -->
	<xsl:param name="output_path"/> <!-- output PDF file name -->
	<xsl:param name="outputpdf_basepath"/> <!-- output PDF folder -->
	<xsl:param name="external_index"/><!-- path to index xml, generated on 1st pass, based on FOP Intermediate Format -->
	<xsl:param name="syntax-highlight">false</xsl:param> <!-- syntax highlighting feature, default - off -->
	<xsl:param name="add_math_as_text">true</xsl:param> <!-- add math in text behind svg formula, to copy-paste formula from PDF as text -->

	<xsl:param name="table_if">false</xsl:param> <!-- generate extended table in IF for autolayout-algorithm -->
	<xsl:param name="table_widths"/> <!-- (debug: path to) xml with table's widths, generated on 1st pass, based on FOP Intermediate Format -->
	<!-- Example: <tables>
		<table page-width="509103" id="table1" width_max="223561" width_min="223560">
			<column width_max="39354" width_min="39354"/>
			<column width_max="75394" width_min="75394"/>
			<column width_max="108813" width_min="108813"/>
			<tbody>
				<tr>
					<td width_max="39354" width_min="39354">
						<p_len>39354</p_len>
						<word_len>39354</word_len>
					</td>
					
		OLD:
			<tables>
					<table id="table_if_tab-symdu" page-width="75"> - table id prefixed by 'table_if_' to simple search in IF 
						<tbody>
							<tr>
								<td id="tab-symdu_1_1">
									<p_len>6</p_len>
									<p_len>100</p_len>  for 2nd paragraph
									<word_len>6</word_len>
									<word_len>20</word_len>
								...
	-->

	<!-- for command line debug: <xsl:variable name="table_widths_from_if" select="document($table_widths)"/> -->
	<xsl:variable name="table_widths_from_if" select="xalan:nodeset($table_widths)"/>

	<xsl:variable name="table_widths_from_if_calculated_">
		<xsl:for-each select="$table_widths_from_if//table">
			<xsl:copy>
				<xsl:copy-of select="@*"/>
				<xsl:call-template name="calculate-column-widths-autolayout-algorithm"/>
			</xsl:copy>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="table_widths_from_if_calculated" select="xalan:nodeset($table_widths_from_if_calculated_)"/>

	<xsl:param name="table_if_debug">false</xsl:param> <!-- set 'true' to put debug width data before table or dl -->

	<!-- for table auto-layout algorithm, see <xsl:template match="*[local-name()='table']" priority="2"> -->
	<xsl:param name="table_only_with_id"/> <!-- Example: 'table1' -->
	<xsl:param name="table_only_with_ids"/> <!-- Example: 'table1 table2 table3 ' -->

	<!-- don't remove and rename this variable, it's using in mn2pdf tool -->
	<xsl:variable name="isApplyAutolayoutAlgorithm_">true
	</xsl:variable>
	<xsl:variable name="isApplyAutolayoutAlgorithm" select="normalize-space($isApplyAutolayoutAlgorithm_)"/>

	<xsl:variable name="isGenerateTableIF"><xsl:value-of select="$table_if"/></xsl:variable>
	<!-- <xsl:variable name="isGenerateTableIF" select="normalize-space(normalize-space($table_if) = 'true' and 1 = 1)"/> -->

	<xsl:variable name="lang">
		<xsl:call-template name="getLang"/>
	</xsl:variable>

	<xsl:variable name="inputxml_filename_prefix">
		<xsl:choose>
			<xsl:when test="contains($inputxml_filename, '.presentation.xml')">
				<xsl:value-of select="substring-before($inputxml_filename, '.presentation.xml')"/>
			</xsl:when>
			<xsl:when test="contains($inputxml_filename, '.xml')">
				<xsl:value-of select="substring-before($inputxml_filename, '.xml')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$inputxml_filename"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- Note 1: Each xslt has declated variable `namespace` that allows to set some properties, processing logic, etc. for concrete xslt.
	You can put such conditions by using xslt construction `xsl:if test="..."` or <xsl:choose><xsl:when test=""></xsl:when><xsl:otherwiste></xsl:otherwiste></xsl:choose>,
	BUT DON'T put any another conditions together with $namespace = '...' (such conditions will be ignored). For another conditions, please use nested xsl:if or xsl:choose -->

	<!-- Note 2: almost all localized string determined in the element //localized-strings in metanorma xml, but there are a few cases when:
	 - string didn't determined yet
	 - we need to put the string on two-languages (for instance, on English and French both), but xml contains only localized strings for one language
	 - there is a difference between localized string value and text that should be displayed in PDF
	-->
	<xsl:variable name="titles_">
		<!-- These titles of Table of contents renders different than determined in localized-strings -->
		<!-- <title-toc lang="en">
			<xsl:if test="$namespace = 'csd' or $namespace = 'ieee' or $namespace = 'iho' or $namespace = 'mpfd' or $namespace = 'ogc' or $namespace = 'unece-rec'">
				<xsl:text>Contents</xsl:text>
			</xsl:if>
			<xsl:if test="$namespace = 'csa' or $namespace = 'm3d' or $namespace = 'nist-sp' or $namespace = 'ogc-white-paper'">
				<xsl:text>Table of Contents</xsl:text>
			</xsl:if>
			<xsl:if test="$namespace = 'gb'">
				<xsl:text>Table of contents</xsl:text>
			</xsl:if>
		</title-toc> -->
		<title-toc lang="en">Table of contents</title-toc>
		<!-- <title-toc lang="fr">
			<xsl:text>Sommaire</xsl:text>
		</title-toc> -->
		<!-- <title-toc lang="zh">
			<xsl:choose>
				<xsl:when test="$namespace = 'gb'">
					<xsl:text>目次</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Contents</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</title-toc> -->
		<title-toc lang="zh">目次</title-toc>

		<title-part lang="en">
		</title-part>
		<title-part lang="fr">
		</title-part>
		<title-part lang="ru">
		</title-part>
		<title-part lang="zh">第 # 部分:</title-part>
	</xsl:variable>
	<xsl:variable name="titles" select="xalan:nodeset($titles_)"/>

	<xsl:variable name="ace_tag">ace-tag_</xsl:variable>

	<xsl:variable name="title-list-tables">
		<xsl:variable name="toc_table_title" select="//mn:metanorma/mn:metanorma-extension/mn:toc[@type='table']/mn:title"/>
		<xsl:value-of select="$toc_table_title"/>
		<xsl:if test="normalize-space($toc_table_title) = ''">
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">toc_tables</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="title-list-figures">
		<xsl:variable name="toc_figure_title" select="//mn:metanorma/mn:metanorma-extension/mn:toc[@type='figure']/mn:title"/>
		<xsl:value-of select="$toc_figure_title"/>
		<xsl:if test="normalize-space($toc_figure_title) = ''">
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">toc_figures</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="title-list-recommendations">
		<xsl:variable name="toc_requirement_title" select="//mn:metanorma/mn:metanorma-extension/mn:toc[@type='requirement']/mn:title"/>
		<xsl:value-of select="$toc_requirement_title"/>
		<xsl:if test="normalize-space($toc_requirement_title) = ''">
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">toc_recommendations</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="bibdata">
		<xsl:copy-of select="//mn:metanorma/mn:bibdata"/>
		<xsl:copy-of select="//mn:metanorma/mn:localized-strings"/>
	</xsl:variable>

	<xsl:template name="getTitle">
		<xsl:param name="name"/>
		<xsl:param name="lang"/>
		<xsl:variable name="lang_">
			<xsl:choose>
				<xsl:when test="$lang != ''">
					<xsl:value-of select="$lang"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="getLang"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="language" select="normalize-space($lang_)"/>
		<xsl:variable name="title_" select="$titles/*[local-name() = $name][@lang = $language]"/>
		<xsl:choose>
			<xsl:when test="normalize-space($title_) != ''">
				<xsl:value-of select="$title_"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$titles/*[local-name() = $name][@lang = 'en']"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Characters -->
	<xsl:variable name="linebreak">&#8232;</xsl:variable>
	<xsl:variable name="tab_zh">　</xsl:variable>
	<xsl:variable name="non_breaking_hyphen">‑</xsl:variable>
	<xsl:variable name="thin_space"> </xsl:variable>
	<xsl:variable name="zero_width_space">​</xsl:variable>
	<xsl:variable name="hair_space"> </xsl:variable>
	<xsl:variable name="en_dash">–</xsl:variable>
	<xsl:variable name="em_dash">—</xsl:variable>
	<xsl:variable name="nonbreak_space_em_dash_space"> — </xsl:variable>
	<xsl:variable name="cr">&#13;</xsl:variable>
	<xsl:variable name="lf">
</xsl:variable>

	<xsl:variable name="lower">abcdefghijklmnopqrstuvwxyz</xsl:variable>
	<xsl:variable name="upper">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>

	<xsl:variable name="en_chars" select="concat($lower,$upper,',.`1234567890-=~!@#$%^*()_+[]{}\|?/')"/>

	<!--
	<metanorma-extension>
		<presentation-metadata>
			<papersize>letter</papersize>
		</presentation-metadata>
	</metanorma-extension>
	-->

	<xsl:variable name="papersize" select="java:toLowerCase(java:java.lang.String.new(normalize-space(//mn:metanorma/mn:metanorma-extension/mn:presentation-metadata/mn:papersize)))"/>
	<xsl:variable name="papersize_width_">
		<xsl:choose>
			<xsl:when test="$papersize = 'letter'">215.9</xsl:when>
			<xsl:when test="$papersize = 'a4'">210</xsl:when>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="papersize_width" select="normalize-space($papersize_width_)"/>
	<xsl:variable name="papersize_height_">
		<xsl:choose>
			<xsl:when test="$papersize = 'letter'">279.4</xsl:when>
			<xsl:when test="$papersize = 'a4'">297</xsl:when>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="papersize_height" select="normalize-space($papersize_height_)"/>

	<!-- page width in mm -->
	<xsl:variable name="pageWidth_">
		<xsl:choose>
			<xsl:when test="$papersize_width != ''"><xsl:value-of select="$papersize_width"/></xsl:when>
			<xsl:otherwise>210
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="pageWidth" select="normalize-space($pageWidth_)"/>

	<!-- page height in mm -->
	<xsl:variable name="pageHeight_">
		<xsl:choose>
			<xsl:when test="$papersize_height != ''"><xsl:value-of select="$papersize_height"/></xsl:when>
			<xsl:otherwise>297
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="pageHeight" select="normalize-space($pageHeight_)"/>

	<!-- Page margins in mm (just digits, without 'mm')-->
	<!-- marginLeftRight1 and marginLeftRight2 - is left or right margin depends on odd/even page,
	for example, left margin on odd page and right margin on even page -->
	<xsl:variable name="marginLeftRight1_">24.5
	</xsl:variable>
	<xsl:variable name="marginLeftRight1" select="normalize-space($marginLeftRight1_)"/>

	<xsl:variable name="marginLeftRight2_">25
	</xsl:variable>
	<xsl:variable name="marginLeftRight2" select="normalize-space($marginLeftRight2_)"/>

	<xsl:variable name="marginTop_">25.4
	</xsl:variable>
	<xsl:variable name="marginTop" select="normalize-space($marginTop_)"/>

	<xsl:variable name="marginBottom_">25.4
	</xsl:variable>
	<xsl:variable name="marginBottom" select="normalize-space($marginBottom_)"/>

	<xsl:variable name="layout_columns_default">1</xsl:variable>
	<xsl:variable name="layout_columns_" select="normalize-space((//mn:metanorma)[1]/mn:metanorma-extension/mn:presentation-metadata/mn:layout-columns)"/>
	<xsl:variable name="layout_columns">
		<xsl:choose>
			<xsl:when test="$layout_columns_ != ''"><xsl:value-of select="$layout_columns_"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$layout_columns_default"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="font_noto_sans">Noto Sans, Noto Sans HK, Noto Sans JP, Noto Sans KR, Noto Sans SC, Noto Sans TC</xsl:variable>
	<xsl:variable name="font_noto_sans_mono">Noto Sans Mono, Noto Sans Mono CJK HK, Noto Sans Mono CJK JP, Noto Sans Mono CJK KR, Noto Sans Mono CJK SC, Noto Sans Mono CJK TC</xsl:variable>
	<xsl:variable name="font_noto_serif">Noto Serif, Noto Serif HK, Noto Serif JP, Noto Serif KR, Noto Serif SC, Noto Serif TC</xsl:variable>
	<xsl:attribute-set name="root-style">
		<xsl:attribute name="font-family">Arial, Cambria Math, <xsl:value-of select="$font_noto_sans"/></xsl:attribute>
		<xsl:attribute name="font-family-generic">Sans</xsl:attribute>
		<xsl:attribute name="font-size">10pt</xsl:attribute>
	</xsl:attribute-set> <!-- root-style -->

	<xsl:template name="insertRootStyle">
		<xsl:param name="root-style"/>
		<xsl:variable name="root-style_" select="xalan:nodeset($root-style)"/>

		<xsl:variable name="additional_fonts_">
			<xsl:for-each select="//mn:metanorma[1]/mn:metanorma-extension/mn:presentation-metadata[mn:name = 'fonts']/mn:value |       //mn:metanorma[1]/mn:presentation-metadata[mn:name = 'fonts']/mn:value">
				<xsl:value-of select="."/><xsl:if test="position() != last()">, </xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="additional_fonts" select="normalize-space($additional_fonts_)"/>

		<xsl:variable name="font_family_generic" select="$root-style_/root-style/@font-family-generic"/>

		<xsl:for-each select="$root-style_/root-style/@*">

			<xsl:choose>
				<xsl:when test="local-name() = 'font-family-generic'"><!-- skip, it's using for determine 'sans' or 'serif' --></xsl:when>
				<xsl:when test="local-name() = 'font-family'">

					<xsl:variable name="font_regional_prefix">
						<xsl:choose>
							<xsl:when test="$font_family_generic = 'Sans'">Noto Sans</xsl:when>
							<xsl:otherwise>Noto Serif</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:attribute name="{local-name()}">

						<xsl:variable name="font_extended">
							<xsl:choose>
								<xsl:when test="$lang = 'zh'"><xsl:value-of select="$font_regional_prefix"/> SC</xsl:when>
								<xsl:when test="$lang = 'hk'"><xsl:value-of select="$font_regional_prefix"/> HK</xsl:when>
								<xsl:when test="$lang = 'jp'"><xsl:value-of select="$font_regional_prefix"/> JP</xsl:when>
								<xsl:when test="$lang = 'kr'"><xsl:value-of select="$font_regional_prefix"/> KR</xsl:when>
								<xsl:when test="$lang = 'sc'"><xsl:value-of select="$font_regional_prefix"/> SC</xsl:when>
								<xsl:when test="$lang = 'tc'"><xsl:value-of select="$font_regional_prefix"/> TC</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<xsl:if test="normalize-space($font_extended) != ''">
							<xsl:value-of select="$font_regional_prefix"/><xsl:text>, </xsl:text>
							<xsl:value-of select="$font_extended"/><xsl:text>, </xsl:text>
						</xsl:if>

						<xsl:variable name="font_family" select="."/>

						<xsl:choose>
							<xsl:when test="$additional_fonts = ''">
								<xsl:value-of select="$font_family"/>
							</xsl:when>
							<xsl:otherwise> <!-- $additional_fonts != '' -->
								<xsl:choose>
									<xsl:when test="contains($font_family, ',')">
										<xsl:value-of select="substring-before($font_family, ',')"/>
										<xsl:text>, </xsl:text><xsl:value-of select="$additional_fonts"/>
										<xsl:text>, </xsl:text><xsl:value-of select="substring-after($font_family, ',')"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$font_family"/>
										<xsl:text>, </xsl:text><xsl:value-of select="$additional_fonts"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="."/>
				</xsl:otherwise>
			</xsl:choose>

			<!-- <xsl:choose>
				<xsl:when test="local-name() = 'font-family'">
					<xsl:attribute name="{local-name()}">
						<xsl:value-of select="."/>, <xsl:value-of select="$additional_fonts"/>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="."/>
				</xsl:otherwise>
			</xsl:choose> -->
		</xsl:for-each>
	</xsl:template> <!-- insertRootStyle -->

	<!-- ===================================== -->
	<!-- Update xml -->
	<!-- ===================================== -->

	<xsl:template name="updateXML">
		<xsl:if test="$debug = 'true'"><xsl:message>START updated_xml_step1</xsl:message></xsl:if>
		<xsl:variable name="startTime1" select="java:getTime(java:java.util.Date.new())"/>

		<!-- STEP1: Re-order elements in 'preface', 'sections' based on @displayorder -->
		<xsl:variable name="updated_xml_step1">
			<xsl:if test="$table_if = 'false'">
				<xsl:apply-templates mode="update_xml_step1"/>
			</xsl:if>
		</xsl:variable>

		<xsl:variable name="endTime1" select="java:getTime(java:java.util.Date.new())"/>
		<xsl:if test="$debug = 'true'">
			<xsl:message>DEBUG: processing time <xsl:value-of select="$endTime1 - $startTime1"/> msec.</xsl:message>
			<xsl:message>END updated_xml_step1</xsl:message>
			<!-- <redirect:write file="updated_xml_step1_{java:getTime(java:java.util.Date.new())}.xml">
				<xsl:copy-of select="$updated_xml_step1"/>
			</redirect:write> -->
		</xsl:if>

		<xsl:if test="$debug = 'true'"><xsl:message>START updated_xml_step2</xsl:message></xsl:if>
		<xsl:variable name="startTime2" select="java:getTime(java:java.util.Date.new())"/>

		<!-- STEP2: add 'fn' after 'eref' and 'origin', if referenced to bibitem with 'note' = Withdrawn.' or 'Cancelled and replaced...'  -->
		<xsl:variable name="updated_xml_step2">
			<xsl:if test="$table_if = 'false'">
				<xsl:copy-of select="$updated_xml_step1"/>
			</xsl:if>
		</xsl:variable>

		<xsl:variable name="endTime2" select="java:getTime(java:java.util.Date.new())"/>
		<xsl:if test="$debug = 'true'">
			<xsl:message>DEBUG: processing time <xsl:value-of select="$endTime2 - $startTime2"/> msec.</xsl:message>
			<xsl:message>END updated_xml_step2</xsl:message>
			<!-- <redirect:write file="updated_xml_step2_{java:getTime(java:java.util.Date.new())}.xml">
				<xsl:copy-of select="$updated_xml_step2"/>
			</redirect:write> -->
		</xsl:if>

		<xsl:if test="$debug = 'true'"><xsl:message>START updated_xml_step3</xsl:message></xsl:if>
		<xsl:variable name="startTime3" select="java:getTime(java:java.util.Date.new())"/>

		<xsl:variable name="updated_xml_step3">
			<xsl:choose>
				<xsl:when test="$table_if = 'false'">
					<xsl:apply-templates select="xalan:nodeset($updated_xml_step2)" mode="update_xml_enclose_keep-together_within-line"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="." mode="update_xml_enclose_keep-together_within-line"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="endTime3" select="java:getTime(java:java.util.Date.new())"/>
		<xsl:if test="$debug = 'true'">
			<xsl:message>DEBUG: processing time <xsl:value-of select="$endTime3 - $startTime3"/> msec.</xsl:message>
			<xsl:message>END updated_xml_step3</xsl:message>
			<!-- <redirect:write file="updated_xml_step3_{java:getTime(java:java.util.Date.new())}.xml">
				<xsl:copy-of select="$updated_xml_step3"/>
			</redirect:write> -->
		</xsl:if>

		<!-- <xsl:if test="$debug = 'true'"><xsl:message>START copying updated_xml_step3</xsl:message></xsl:if>
		<xsl:variable name="startTime4" select="java:getTime(java:java.util.Date.new())"/>  -->
		<xsl:copy-of select="$updated_xml_step3"/>
		<!-- <xsl:variable name="endTime4" select="java:getTime(java:java.util.Date.new())"/>
		<xsl:if test="$debug = 'true'">
			<xsl:message>DEBUG: processing time <xsl:value-of select="$endTime4 - $startTime4"/> msec.</xsl:message>
			<xsl:message>END copying updated_xml_step3</xsl:message>
		</xsl:if> -->

	</xsl:template>

	<!-- =========================================================================== -->
	<!-- STEP1:  -->
	<!--   - Re-order elements in 'preface', 'sections' based on @displayorder -->
	<!--   - Put Section title in the correct position -->
	<!--   - Ignore 'span' without style -->
	<!--   - Remove semantic xml part -->
	<!--   - Remove image/emf (EMF vector image for Word) -->
	<!--   - add @id, redundant for table auto-layout algorithm -->
	<!--   - process 'passthrough' element -->
	<!--   - split math by element with @linebreak into maths -->
	<!--   - rename fmt-title to title, fmt-name to name and another changes to convert new presentation XML to  -->
	<!--   - old XML without significant changes in XSLT -->
	<!-- =========================================================================== -->
	<xsl:template match="@*|node()" mode="update_xml_step1">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>

	<!-- change section's order based on @displayorder value -->
	<xsl:template match="mn:preface" mode="update_xml_step1">
		<xsl:copy>
			<xsl:copy-of select="@*"/>

			<xsl:variable name="nodes_preface_">
				<xsl:for-each select="*">
					<node id="{@id}"/>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="nodes_preface" select="xalan:nodeset($nodes_preface_)"/>

			<xsl:for-each select="*">
				<xsl:sort select="@displayorder" data-type="number"/>

				<!-- process Section's title -->
				<xsl:variable name="preceding-sibling_id" select="$nodes_preface/node[@id = current()/@id]/preceding-sibling::node[1]/@id"/>
				<xsl:if test="$preceding-sibling_id != ''">
					<xsl:apply-templates select="parent::*/*[@type = 'section-title' and @id = $preceding-sibling_id and not(@displayorder)]" mode="update_xml_step1"/>
				</xsl:if>

				<xsl:choose>
					<xsl:when test="@type = 'section-title' and not(@displayorder)"><!-- skip, don't copy, because copied in above 'apply-templates' --></xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="update_xml_step1"/>
					</xsl:otherwise>
				</xsl:choose>

			</xsl:for-each>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:sections" mode="update_xml_step1">
		<xsl:copy>
			<xsl:copy-of select="@*"/>

			<xsl:variable name="nodes_sections_">
				<xsl:for-each select="*">
					<node id="{@id}"/>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="nodes_sections" select="xalan:nodeset($nodes_sections_)"/>

			<!-- move section 'Normative references' inside 'sections' -->
			<xsl:for-each select="* |      ancestor::mn:metanorma/mn:bibliography/mn:references[@normative='true'] |     ancestor::mn:metanorma/mn:bibliography/mn:clause[mn:references[@normative='true']]">
				<xsl:sort select="@displayorder" data-type="number"/>

				<!-- process Section's title -->
				<xsl:variable name="preceding-sibling_id" select="$nodes_sections/node[@id = current()/@id]/preceding-sibling::node[1]/@id"/>
				<xsl:if test="$preceding-sibling_id != ''">
					<xsl:apply-templates select="parent::*/*[@type = 'section-title' and @id = $preceding-sibling_id and not(@displayorder)]" mode="update_xml_step1"/>
				</xsl:if>

				<xsl:choose>
					<xsl:when test="@type = 'section-title' and not(@displayorder)"><!-- skip, don't copy, because copied in above 'apply-templates' --></xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="update_xml_step1"/>
					</xsl:otherwise>
				</xsl:choose>

			</xsl:for-each>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:bibliography" mode="update_xml_step1">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<!-- copy all elements from bibliography except 'Normative references' (moved to 'sections') -->
			<xsl:for-each select="*[not(@normative='true') and not(*[@normative='true'])]">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:apply-templates select="." mode="update_xml_step1"/>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>

	<!-- Example with 'class': <span class="stdpublisher">ISO</span> <span class="stddocNumber">10303</span>-<span class="stddocPartNumber">1</span>:<span class="stdyear">1994</span> -->
	<xsl:template match="mn:span[@style or @class = 'stdpublisher' or @class = 'stddocNumber' or @class = 'stddocPartNumber' or @class = 'stdyear' or @class = 'fmt-hi' or @class = 'horizontal' or @class = 'norotate' or @class = 'halffontsize']" mode="update_xml_step1" priority="2">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>
	<!-- Note: to enable the addition of character span markup with semantic styling for DIS Word output -->
	<xsl:template match="mn:span" mode="update_xml_step1">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>
	<xsl:template match="mn:sections/mn:p[starts-with(@class, 'zzSTDTitle')]/mn:span[@class] | mn:sourcecode//mn:span[@class]" mode="update_xml_step1" priority="2">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>

	<!-- remove semantic xml -->
	<xsl:template match="mn:metanorma-extension/mn:metanorma/mn:source" mode="update_xml_step1"/>

	<!-- remove UnitML elements, big section especially in BIPM xml -->
	<xsl:template match="mn:metanorma-extension/*[local-name() = 'UnitsML']" mode="update_xml_step1"/>

	<!-- remove image/emf -->
	<xsl:template match="mn:image/mn:emf" mode="update_xml_step1"/>

	<!-- remove preprocess-xslt -->
	<xsl:template match="mn:preprocess-xslt" mode="update_xml_step1"/>

	<xsl:template match="mn:stem" mode="update_xml_step1"/>

	<xsl:template match="mn:fmt-stem" mode="update_xml_step1">
		<!-- <xsl:element name="stem" namespace="{$namespace_full}"> -->
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:choose>
				<xsl:when test="mn:semx and count(node()) = 1">
					<xsl:choose>
						<xsl:when test="not(.//mn:passthrough) and not(.//*[@linebreak])">
							<xsl:copy-of select="mn:semx/node()"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="mn:semx/node()" mode="update_xml_step1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="not(.//mn:passthrough) and not(.//*[@linebreak])">
							<xsl:copy-of select="node()"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="node()" mode="update_xml_step1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
		<!-- </xsl:element> -->
	</xsl:template>

	<xsl:template match="mn:image[not(.//mn:passthrough)] |        mn:bibdata[not(.//mn:passthrough)] |        mn:localized-strings" mode="update_xml_step1">
		<xsl:copy-of select="."/>
	</xsl:template>

	<!-- https://github.com/metanorma/isodoc/issues/651 -->
	<!-- mn:sourcecode[not(.//mn:passthrough) and not(.//mn:fmt-name)] -->
	<xsl:template match="mn:sourcecode" mode="update_xml_step1">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="mn:fmt-name" mode="update_xml_step1"/>
			<xsl:choose>
				<xsl:when test="mn:fmt-sourcecode">
					<xsl:choose>
						<xsl:when test="mn:fmt-sourcecode[not(.//mn:passthrough)] and not(.//mn:fmt-name)">
							<xsl:copy-of select="mn:fmt-sourcecode/node()"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="mn:fmt-sourcecode/node()" mode="update_xml_step1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise> <!-- If fmt-sourcecode is not present -->
					<xsl:choose>
						<xsl:when test="not(.//mn:passthrough) and not(.//mn:fmt-name)">
							<xsl:copy-of select="node()"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="node()[not(self::mn:fmt-name)]" mode="update_xml_step1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>

	<!-- https://github.com/metanorma/isodoc/issues/651 -->
	<xsl:template match="mn:figure[mn:fmt-figure]" mode="update_xml_step1" priority="2">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="mn:fmt-name" mode="update_xml_step1"/>
			<xsl:apply-templates select="mn:fmt-figure/node()" mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>

	<!-- https://github.com/metanorma/isodoc/issues/652 -->
	<xsl:template match="mn:quote/mn:source" mode="update_xml_step1"/>
	<xsl:template match="mn:quote/mn:author" mode="update_xml_step1"/>
	<xsl:template match="mn:amend" mode="update_xml_step1"/>
	<!-- https://github.com/metanorma/isodoc/issues/687 -->
	<xsl:template match="mn:source" mode="update_xml_step1"/>

	<xsl:template match="mn:metanorma-extension/mn:attachment" mode="update_xml_step1">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:if test="1 = 2"> <!-- remove attachment/text(), because attachments added in the template 'addPDFUAmeta' before applying 'update_xml_step1' -->
				<xsl:variable name="name_filepath" select="concat($inputxml_basepath, @name)"/>
				<xsl:variable name="file_exists" select="normalize-space(java:exists(java:java.io.File.new($name_filepath)))"/>
				<xsl:if test="$file_exists = 'false'"> <!-- copy attachment content only if file on disk doesnt exist -->
					<xsl:value-of select="normalize-space(.)"/>
				</xsl:if>
			</xsl:if>
		</xsl:copy>
	</xsl:template>

	<!-- add @id, mandatory for table auto-layout algorithm -->
	<xsl:template match="*[self::mn:dl or self::mn:table][not(@id)]" mode="update_xml_step1">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:call-template name="add_id"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>

	<!-- prevent empty thead processing in XSL-FO, remove it -->
	<xsl:template match="mn:table/mn:thead[count(*) = 0]" mode="update_xml_step1"/>

	<xsl:template name="add_id">
		<xsl:if test="not(@id)">
			<!-- add @id - first element with @id plus '_element_name' -->
			<xsl:variable name="prefix_id_" select="(.//*[@id])[1]/@id"/>
			<xsl:variable name="prefix_id"><xsl:value-of select="$prefix_id_"/><xsl:if test="normalize-space($prefix_id_) = ''"><xsl:value-of select="generate-id()"/></xsl:if></xsl:variable>
			<xsl:variable name="document_suffix" select="ancestor::mn:metanorma/@document_suffix"/>
			<xsl:attribute name="id"><xsl:value-of select="concat($prefix_id, '_', local-name(), '_', $document_suffix)"/></xsl:attribute>
		</xsl:if>
	</xsl:template>

	<!-- optimization: remove clause if table_only_with_id isn't empty and clause doesn't contain table or dl with table_only_with_id -->
	<xsl:template match="*[self::mn:clause or self::mn:p or self::mn:definitions or self::mn:annex]" mode="update_xml_step1">
		<xsl:choose>
			<xsl:when test="($table_only_with_id != '' or $table_only_with_ids != '') and self::mn:p and (ancestor::*[self::mn:table or self::mn:dl or self::mn:toc])">
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:apply-templates mode="update_xml_step1"/>
				</xsl:copy>
			</xsl:when>
			<!-- for table auto-layout algorithm -->
			<xsl:when test="$table_only_with_id != '' and not(.//*[self::mn:table or self::mn:dl][@id = $table_only_with_id])">
				<xsl:copy>
					<xsl:copy-of select="@*"/>
				</xsl:copy>
			</xsl:when>
			<!-- for table auto-layout algorithm -->
			<xsl:when test="$table_only_with_ids != '' and not(.//*[self::mn:table or self::mn:dl][contains($table_only_with_ids, concat(@id, ' '))])">
				<xsl:copy>
					<xsl:copy-of select="@*"/>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:apply-templates mode="update_xml_step1"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:variable name="regex_passthrough">.*\bpdf\b.*</xsl:variable>
	<xsl:template match="mn:passthrough" mode="update_xml_step1">
		<!-- <xsl:if test="contains(@formats, ' pdf ')"> -->
		<xsl:if test="normalize-space(java:matches(java:java.lang.String.new(@formats), $regex_passthrough)) = 'true'">
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:if>
	</xsl:template>

	<!-- split math by element with @linebreak into maths -->
	<xsl:template match="mathml:math[.//mathml:mo[@linebreak] or .//mathml:mspace[@linebreak]]" mode="update_xml_step1">
		<xsl:variable name="maths">
			<xsl:apply-templates select="." mode="mathml_linebreak"/>
		</xsl:variable>
		<xsl:copy-of select="$maths"/>
	</xsl:template>

	<!-- update new Presentation XML -->
	<xsl:template match="mn:title[following-sibling::*[1][self::mn:fmt-title]]" mode="update_xml_step1"/>
	<xsl:template match="mn:name[following-sibling::*[1][self::mn:fmt-name]]" mode="update_xml_step1"/>
	<xsl:template match="mn:section-title[following-sibling::*[1][self::mn:p][@type = 'section-title' or @type = 'floating-title']]" mode="update_xml_step1"/>
	<!-- <xsl:template match="mn:preferred[following-sibling::*[not(local-name() = 'preferred')][1][local-name() = 'fmt-preferred']]" mode="update_xml_step1"/> -->
	<xsl:template match="mn:preferred" mode="update_xml_step1"/>
	<!-- <xsl:template match="mn:admitted[following-sibling::*[not(local-name() = 'admitted')][1][local-name() = 'fmt-admitted']]" mode="update_xml_step1"/> -->
	<xsl:template match="mn:admitted" mode="update_xml_step1"/>
	<!-- <xsl:template match="mn:deprecates[following-sibling::*[not(local-name() = 'deprecates')][1][local-name() = 'fmt-deprecates']]" mode="update_xml_step1"/> -->
	<xsl:template match="mn:deprecates" mode="update_xml_step1"/>
	<xsl:template match="mn:related" mode="update_xml_step1"/>
	<!-- <xsl:template match="mn:definition[following-sibling::*[1][local-name() = 'fmt-definition']]" mode="update_xml_step1"/> -->
	<xsl:template match="mn:definition" mode="update_xml_step1"/>
	<!-- <xsl:template match="mn:termsource[following-sibling::*[1][local-name() = 'fmt-termsource']]" mode="update_xml_step1"/> -->
	<xsl:template match="mn:termsource" mode="update_xml_step1"/>

	<xsl:template match="mn:term[@unnumbered = 'true'][not(.//*[starts-with(local-name(), 'fmt-')])]" mode="update_xml_step1"/>

	<xsl:template match="mn:p[@type = 'section-title' or @type = 'floating-title'][preceding-sibling::*[1][self::mn:section-title]]" mode="update_xml_step1">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="update_xml_step1"/>
			<xsl:copy-of select="preceding-sibling::*[1][self::mn:section-title]/@depth"/>
			<xsl:apply-templates select="node()" mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:fmt-title" mode="update_xml_step1">
		<!-- <xsl:element name="title" namespace="{$namespace_full}"> -->
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:call-template name="addNamedDestinationAttribute"/>

			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:copy>
		<!-- </xsl:element> -->
	</xsl:template>

	<xsl:template name="addNamedDestinationAttribute">
	</xsl:template>

	<xsl:template match="mn:fmt-name" mode="update_xml_step1">
		<xsl:choose>
			<xsl:when test="local-name(..) = 'p' and ancestor::mn:table">
				<xsl:apply-templates mode="update_xml_step1"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- <xsl:element name="name" namespace="{$namespace_full}"> -->
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:call-template name="addNamedDestinationAttribute"/>

					<xsl:apply-templates mode="update_xml_step1"/>
				</xsl:copy>
				<!-- </xsl:element> -->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- li/fmt-name -->
	<xsl:template match="mn:li/mn:fmt-name" priority="2" mode="update_xml_step1">
		<xsl:attribute name="label"><xsl:value-of select="."/></xsl:attribute>
		<xsl:attribute name="full">true</xsl:attribute>
	</xsl:template>

	<xsl:template match="mn:fmt-preferred[mn:p]" mode="update_xml_step1">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>
	<xsl:template match="mn:fmt-preferred[not(mn:p)] | mn:fmt-preferred/mn:p" mode="update_xml_step1">
		<xsl:element name="fmt-preferred" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="mn:fmt-admitted[mn:p]" mode="update_xml_step1">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>
	<xsl:template match="mn:fmt-admitted[not(mn:p)] | mn:fmt-admitted/mn:p" mode="update_xml_step1">
		<xsl:element name="fmt-admitted" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="mn:fmt-deprecates[mn:p]" mode="update_xml_step1">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>
	<xsl:template match="mn:fmt-deprecates[not(mn:p)] | mn:fmt-deprecates/mn:p" mode="update_xml_step1">
		<xsl:element name="fmt-deprecates" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template>

	<!-- <xsl:template match="mn:fmt-definition" mode="update_xml_step1">
		<xsl:element name="definition" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="mn:fmt-termsource" mode="update_xml_step1">
		<xsl:element name="termsource" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="mn:fmt-source" mode="update_xml_step1">
		<xsl:element name="source" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template> -->

	<xsl:template match="mn:span[                @class = 'fmt-caption-label' or                 @class = 'fmt-element-name' or                @class = 'fmt-caption-delim' or                @class = 'fmt-autonum-delim']" mode="update_xml_step1" priority="3">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>

	<xsl:template match="mn:semx" mode="update_xml_step1">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>

	<xsl:template match="mn:fmt-xref-label" mode="update_xml_step1"/>

	<xsl:template match="mn:requirement | mn:recommendation | mn:permission" mode="update_xml_step1">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>

	<xsl:template match="mn:requirement/*[not(starts-with(local-name(), 'fmt-'))] |             mn:recommendation/*[not(starts-with(local-name(), 'fmt-'))] |              mn:permission/*[not(starts-with(local-name(), 'fmt-'))]" mode="update_xml_step1"/>

	<xsl:template match="mn:fmt-provision" mode="update_xml_step1">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>

	<xsl:template match="mn:identifier" mode="update_xml_step1"/>
	<!-- <xsl:template match="mn:fmt-identifier" mode="update_xml_step1">
		<xsl:element name="identifier" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template> -->

	<xsl:template match="mn:concept" mode="update_xml_step1"/>

	<xsl:template match="mn:fmt-concept" mode="update_xml_step1">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>

	<xsl:template match="mn:eref" mode="update_xml_step1"/>

	<!-- <xsl:template match="mn:fmt-eref" mode="update_xml_step1">
		<xsl:element name="eref" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template> -->

	<xsl:template match="mn:xref" mode="update_xml_step1"/>

	<!-- <xsl:template match="mn:fmt-xref" mode="update_xml_step1">
		<xsl:element name="xref" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template> -->

	<xsl:template match="mn:link" mode="update_xml_step1"/>

	<!-- <xsl:template match="mn:fmt-link" mode="update_xml_step1">
		<xsl:element name="link" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template> -->

	<xsl:template match="mn:origin" mode="update_xml_step1"/>

	<!-- <xsl:template match="mn:fmt-origin" mode="update_xml_step1">
		<xsl:element name="origin" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template> -->

	<xsl:template match="mn:erefstack" mode="update_xml_step1"/>

	<xsl:template match="mn:svgmap" mode="update_xml_step1"/>

	<xsl:template match="mn:annotation-container" mode="update_xml_step1"/>

	<xsl:template match="mn:fmt-identifier[not(ancestor::*[local-name() = 'bibdata'])]//text()" mode="update_xml_step1">
		<xsl:element name="{$element_name_keep-together_within-line}" namespace="{$namespace_full}">
			<xsl:value-of select="."/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="@semx-id | @anchor" mode="update_xml_step1"/>

	<!-- END: update new Presentation XML -->

	<!-- =========================================================================== -->
	<!-- END STEP1: update_xml_step1 -->
	<!-- =========================================================================== -->

	<!-- =========================================================================== -->
	<!-- STEP MOVE PAGEBREAK: move <pagebreak/> at top level under 'preface' and 'sections' -->
	<!-- =========================================================================== -->
	<xsl:template match="@*|node()" mode="update_xml_step_move_pagebreak">
		<xsl:param name="page_sequence_at_top">false</xsl:param>
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="update_xml_step_move_pagebreak">
				<xsl:with-param name="page_sequence_at_top" select="$page_sequence_at_top"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<!-- replace 'pagebreak' by closing tags + page_sequence and  opening page_sequence + tags -->
	<xsl:template match="mn:pagebreak[not(following-sibling::*[1][self::mn:pagebreak])]" mode="update_xml_step_move_pagebreak">
		<xsl:param name="page_sequence_at_top"/>
		<!-- <xsl:choose>
			<xsl:when test="ancestor::mn:sections">
			
			</xsl:when>
			<xsl:when test="ancestor::mn:annex">
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose> -->

		<!-- determine pagebreak is last element before </fo:flow> or not -->
		<xsl:variable name="isLast">
			<xsl:for-each select="ancestor-or-self::*[ancestor::mn:preface or ancestor::mn:sections or ancestor-or-self::mn:annex]">
				<xsl:if test="following-sibling::*">false</xsl:if>
			</xsl:for-each>
		</xsl:variable>

		<xsl:if test="contains($isLast, 'false')">

			<xsl:variable name="orientation" select="normalize-space(@orientation)"/>

			<xsl:variable name="tree_">
				<xsl:call-template name="makeAncestorsElementsTree">
					<xsl:with-param name="page_sequence_at_top" select="$page_sequence_at_top"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="tree" select="xalan:nodeset($tree_)"/>

			<!-- close fo:page-sequence (closing preceding fo elements) -->
			<xsl:call-template name="insertClosingElements">
				<xsl:with-param name="tree" select="$tree"/>
			</xsl:call-template>

			<xsl:text disable-output-escaping="yes">&lt;/page_sequence&gt;</xsl:text>

			<!-- create a new page_sequence (opening elements) -->
			<xsl:text disable-output-escaping="yes">&lt;page_sequence xmlns="</xsl:text><xsl:value-of select="$namespace_full"/>"<xsl:if test="$orientation != ''"> orientation="<xsl:value-of select="$orientation"/>"</xsl:if><xsl:text disable-output-escaping="yes">&gt;</xsl:text>

			<xsl:call-template name="insertOpeningElements">
				<xsl:with-param name="tree" select="$tree"/>
			</xsl:call-template>

		</xsl:if>
	</xsl:template>

	<xsl:template name="makeAncestorsElementsTree">
		<xsl:param name="page_sequence_at_top"/>

		<xsl:choose>
			<xsl:when test="$page_sequence_at_top = 'true'">
				<xsl:for-each select="ancestor::*[ancestor::mn:metanorma]">
					<element pos="{position()}">
						<xsl:copy-of select="@*[local-name() != 'id']"/>
						<xsl:value-of select="name()"/>
					</element>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="ancestor::*[ancestor::mn:preface or ancestor::mn:sections or ancestor-or-self::mn:annex]">
					<element pos="{position()}">
						<xsl:copy-of select="@*[local-name() != 'id']"/>
						<xsl:value-of select="name()"/>
					</element>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="insertClosingElements">
		<xsl:param name="tree"/>
		<xsl:for-each select="$tree//element">
			<xsl:sort data-type="number" order="descending" select="@pos"/>
			<xsl:text disable-output-escaping="yes">&lt;/</xsl:text>
				<xsl:value-of select="."/>
			<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
			<xsl:if test="$debug = 'true'">
				<xsl:message>&lt;/<xsl:value-of select="."/>&gt;</xsl:message>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="insertOpeningElements">
		<xsl:param name="tree"/>
		<xsl:param name="xmlns"/>
		<xsl:param name="add_continue">true</xsl:param>
		<xsl:for-each select="$tree//element">
			<xsl:text disable-output-escaping="yes">&lt;</xsl:text>
				<xsl:value-of select="."/>
				<xsl:for-each select="@*[local-name() != 'pos']">
					<xsl:text> </xsl:text>
					<xsl:value-of select="local-name()"/>
					<xsl:text>="</xsl:text>
					<xsl:value-of select="."/>
					<xsl:text>"</xsl:text>
				</xsl:for-each>
				<xsl:if test="position() = 1 and $add_continue = 'true'"> continue="true"</xsl:if>
				<xsl:if test="position() = 1 and $xmlns != ''"> xmlns="<xsl:value-of select="$xmlns"/>"</xsl:if>
			<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
			<xsl:if test="$debug = 'true'">
				<xsl:message>&lt;<xsl:value-of select="."/>&gt;</xsl:message>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<!-- move full page width figures, tables at top level -->
	<xsl:template match="*[self::mn:figure or self::mn:table][normalize-space(@width) != 'text-width']" mode="update_xml_step_move_pagebreak">
		<xsl:param name="page_sequence_at_top">false</xsl:param>
		<xsl:choose>
			<xsl:when test="$layout_columns != 1">

				<xsl:variable name="tree_">
					<xsl:call-template name="makeAncestorsElementsTree">
						<xsl:with-param name="page_sequence_at_top" select="$page_sequence_at_top"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="tree" select="xalan:nodeset($tree_)"/>

				<xsl:call-template name="insertClosingElements">
					<xsl:with-param name="tree" select="$tree"/>
				</xsl:call-template>

				<!-- <xsl:copy-of select="."/> -->
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:attribute name="top-level">true</xsl:attribute>
					<xsl:copy-of select="node()"/>
				</xsl:copy>

				<xsl:call-template name="insertOpeningElements">
					<xsl:with-param name="tree" select="$tree"/>
				</xsl:call-template>

			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- =========================================================================== -->
	<!-- END STEP MOVE PAGEBREAK: move <pagebreak/> at top level under 'preface' and 'sections' -->
	<!-- =========================================================================== -->

	<!-- =========================================================================== -->
	<!-- XML UPDATE STEP: enclose standard's name into tag 'keep-together_within-line'  -->
	<!-- keep-together_within-line for: a/b, aaa/b, a/bbb, /b -->
	<!-- keep-together_within-line for: a.b, aaa.b, a.bbb, .b  in table's cell ONLY  -->
	<!-- =========================================================================== -->
	<!-- Example: <keep-together_within-line>ISO 10303-51</keep-together_within-line> -->
	<xsl:template match="@*|node()" mode="update_xml_enclose_keep-together_within-line">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="update_xml_enclose_keep-together_within-line"/>
		</xsl:copy>
	</xsl:template>

	<xsl:variable name="express_reference_separators">_.\</xsl:variable>
	<xsl:variable name="express_reference_characters" select="concat($upper,$lower,'1234567890',$express_reference_separators)"/>
	<xsl:variable name="regex_express_reference">(^([A-Za-z0-9_.\\]+)$)</xsl:variable>

	<xsl:variable name="element_name_keep-together_within-line">keep-together_within-line</xsl:variable>
	<xsl:variable name="tag_keep-together_within-line_open">###<xsl:value-of select="$element_name_keep-together_within-line"/>###</xsl:variable>
	<xsl:variable name="tag_keep-together_within-line_close">###/<xsl:value-of select="$element_name_keep-together_within-line"/>###</xsl:variable>

	<!-- \S matches any non-whitespace character (equivalent to [^\r\n\t\f\v ]) -->
	<!-- <xsl:variable name="regex_solidus_units">((\b((\S{1,3}\/\S+)|(\S+\/\S{1,3}))\b)|(\/\S{1,3})\b)</xsl:variable> -->
	<!-- add &lt; and &gt; to \S -->
	<xsl:variable name="regex_S">[^\r\n\t\f\v \&lt;&gt;\u3000-\u9FFF]</xsl:variable>
	<xsl:variable name="regex_solidus_units">((\b((<xsl:value-of select="$regex_S"/>{1,3}\/<xsl:value-of select="$regex_S"/>+)|(<xsl:value-of select="$regex_S"/>+\/<xsl:value-of select="$regex_S"/>{1,3}))\b)|(\/<xsl:value-of select="$regex_S"/>{1,3})\b)</xsl:variable>

	<xsl:variable name="non_white_space">[^\s\u3000-\u9FFF]</xsl:variable>
	<xsl:variable name="regex_dots_units">((\b((<xsl:value-of select="$non_white_space"/>{1,3}\.<xsl:value-of select="$non_white_space"/>+)|(<xsl:value-of select="$non_white_space"/>+\.<xsl:value-of select="$non_white_space"/>{1,3}))\b)|(\.<xsl:value-of select="$non_white_space"/>{1,3})\b)</xsl:variable>

	<xsl:template match="text()[not(ancestor::mn:bibdata or      ancestor::mn:fmt-link[not(contains(normalize-space(),' '))] or      ancestor::mn:sourcecode or      ancestor::*[local-name() = 'math'] or     ancestor::*[local-name() = 'svg'] or     ancestor::mn:name or ancestor::mn:fmt-name or     starts-with(., 'http://') or starts-with(., 'https://') or starts-with(., 'www.') or normalize-space() = '' )]" name="keep_together_standard_number" mode="update_xml_enclose_keep-together_within-line">

		<xsl:variable name="parent" select="local-name(..)"/>

		<xsl:if test="1 = 2"> <!-- alternative variant -->

			<xsl:variable name="regexs">
				<!-- enclose standard's number into tag 'keep-together_within-line' -->
				<xsl:if test="not(ancestor::mn:table)"><regex><xsl:value-of select="$regex_standard_reference"/></regex></xsl:if>
				<!-- if EXPRESS reference -->
				<!-- keep-together_within-line for: a/b, aaa/b, a/bbb, /b -->
				<regex><xsl:value-of select="$regex_solidus_units"/></regex>
				<!-- keep-together_within-line for: a.b, aaa.b, a.bbb, .b  in table's cell ONLY -->
				<xsl:if test="ancestor::*[self::mn:td or self::mn:th]">
					<regex><xsl:value-of select="$regex_dots_units"/></regex>
				</xsl:if>
			</xsl:variable>

			<xsl:variable name="regex_replacement"><xsl:text>(</xsl:text>
				<xsl:for-each select="xalan:nodeset($regexs)/regex">
					<xsl:value-of select="."/>
					<xsl:if test="position() != last()">|</xsl:if>
				</xsl:for-each>
				<xsl:text>)</xsl:text>
			</xsl:variable>

			<!-- regex_replacement='<xsl:value-of select="$regex_replacement"/>' -->

			<xsl:variable name="text_replaced" select="java:replaceAll(java:java.lang.String.new(.), $regex_replacement, concat($tag_keep-together_within-line_open,'$1',$tag_keep-together_within-line_close))"/>

			<!-- text_replaced='<xsl:value-of select="$text_replaced"/>' -->

			<xsl:call-template name="replace_text_tags">
				<xsl:with-param name="tag_open" select="$tag_keep-together_within-line_open"/>
				<xsl:with-param name="tag_close" select="$tag_keep-together_within-line_close"/>
				<xsl:with-param name="text" select="$text_replaced"/>
			</xsl:call-template>
		</xsl:if>

		<xsl:if test="1 = 1">

		<!-- enclose standard's number into tag 'keep-together_within-line' -->
		<xsl:variable name="text">
			<xsl:element name="text" namespace="{$namespace_full}">
				<xsl:choose>
					<xsl:when test="ancestor::mn:table"><xsl:value-of select="."/></xsl:when> <!-- no need enclose standard's number into tag 'keep-together_within-line' in table cells -->
					<xsl:otherwise>
						<xsl:variable name="text_" select="java:replaceAll(java:java.lang.String.new(.), $regex_standard_reference, concat($tag_keep-together_within-line_open,'$1',$tag_keep-together_within-line_close))"/>
						<!-- <xsl:value-of select="$text__"/> -->

						<xsl:call-template name="replace_text_tags">
							<xsl:with-param name="tag_open" select="$tag_keep-together_within-line_open"/>
							<xsl:with-param name="tag_close" select="$tag_keep-together_within-line_close"/>
							<xsl:with-param name="text" select="$text_"/>
						</xsl:call-template>

					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:variable>

		<xsl:variable name="text2">
			<xsl:element name="text" namespace="{$namespace_full}">
				<xsl:for-each select="xalan:nodeset($text)/*[local-name() = 'text']/node()"><xsl:copy-of select="."/>
				</xsl:for-each>
			</xsl:element>
		</xsl:variable>

		<!-- keep-together_within-line for: a/b, aaa/b, a/bbb, /b -->
		<xsl:variable name="text3">
			<xsl:element name="text" namespace="{$namespace_full}">
				<xsl:for-each select="xalan:nodeset($text2)/*[local-name() = 'text']/node()">
					<xsl:choose>
						<xsl:when test="self::text()">
							<xsl:variable name="text_units" select="java:replaceAll(java:java.lang.String.new(.),$regex_solidus_units,concat($tag_keep-together_within-line_open,'$1',$tag_keep-together_within-line_close))"/>
							<!-- <xsl:variable name="text_units">
								<xsl:element name="text" namespace="{$namespace_full}"> -->
									<xsl:call-template name="replace_text_tags">
										<xsl:with-param name="tag_open" select="$tag_keep-together_within-line_open"/>
										<xsl:with-param name="tag_close" select="$tag_keep-together_within-line_close"/>
										<xsl:with-param name="text" select="$text_units"/>
									</xsl:call-template>
								<!-- </xsl:element>
							</xsl:variable>
							<xsl:copy-of select="xalan:nodeset($text_units)/*[local-name() = 'text']/node()"/> -->
						</xsl:when>
						<xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise> <!-- copy 'as-is' for <fo:inline keep-together.within-line="always" ...  -->
					</xsl:choose>
				</xsl:for-each>
			</xsl:element>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="ancestor::*[local-name() = 'td' or local-name() = 'th']">
				<!-- keep-together_within-line for: a.b, aaa.b, a.bbb, .b  in table's cell ONLY -->
				<xsl:for-each select="xalan:nodeset($text3)/*[local-name() = 'text']/node()">
					<xsl:choose>
						<xsl:when test="self::text()">
							<xsl:variable name="text_dots" select="java:replaceAll(java:java.lang.String.new(.),$regex_dots_units,concat($tag_keep-together_within-line_open,'$1',$tag_keep-together_within-line_close))"/>
							<!-- <xsl:variable name="text_dots">
								<xsl:element name="text" namespace="{$namespace_full}"> -->
									<xsl:call-template name="replace_text_tags">
										<xsl:with-param name="tag_open" select="$tag_keep-together_within-line_open"/>
										<xsl:with-param name="tag_close" select="$tag_keep-together_within-line_close"/>
										<xsl:with-param name="text" select="$text_dots"/>
									</xsl:call-template>
								<!-- </xsl:element>
							</xsl:variable>
							<xsl:copy-of select="xalan:nodeset($text_dots)/*[local-name() = 'text']/node()"/> -->
						</xsl:when>
						<xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise> <!-- copy 'as-is' for <fo:inline keep-together.within-line="always" ...  -->
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise><xsl:copy-of select="xalan:nodeset($text3)/*[local-name() = 'text']/node()"/></xsl:otherwise>
		</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:fmt-stem | mn:image" mode="update_xml_enclose_keep-together_within-line">
		<xsl:copy-of select="."/>
	</xsl:template>

	<xsl:template name="replace_text_tags">
		<xsl:param name="tag_open"/>
		<xsl:param name="tag_close"/>
		<xsl:param name="text"/>
		<xsl:choose>
			<xsl:when test="contains($text, $tag_open)">
				<xsl:value-of select="substring-before($text, $tag_open)"/>
				<xsl:variable name="text_after" select="substring-after($text, $tag_open)"/>

				<xsl:element name="{substring-before(substring-after($tag_open, '###'),'###')}" namespace="{$namespace_full}">
					<xsl:value-of select="substring-before($text_after, $tag_close)"/>
				</xsl:element>

				<xsl:call-template name="replace_text_tags">
					<xsl:with-param name="tag_open" select="$tag_open"/>
					<xsl:with-param name="tag_close" select="$tag_close"/>
					<xsl:with-param name="text" select="substring-after($text_after, $tag_close)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$text"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ===================================== -->
	<!-- END XML UPDATE STEP: enclose standard's name into tag 'keep-together_within-line'  -->
	<!-- ===================================== -->

	<!-- Example:
	<metanorma>
		<preface>
			<page_sequence>
				<clause...
			</page_sequence>
			<page_sequence>
				<clause...
			</page_sequence>
		</preface>
		<sections>
			<page_sequence>
				<clause...
			</page_sequence>
			<page_sequence>
				<clause...
			</page_sequence>
		</sections>
		<page_sequence>
			<annex ..
		</page_sequence>
		<page_sequence>
			<annex ..
		</page_sequence>
	</metanorma>
	-->
	<xsl:template name="processPrefaceAndMainSectionsDefault_items">

		<xsl:variable name="updated_xml_step_move_pagebreak">
			<xsl:element name="{$root_element}" namespace="{$namespace_full}">
				<xsl:call-template name="copyCommonElements"/>
				<xsl:call-template name="insertPrefaceSectionsPageSequences"/>
				<xsl:call-template name="insertMainSectionsPageSequences"/>
			</xsl:element>
		</xsl:variable>

		<xsl:variable name="updated_xml_step_move_pagebreak_filename" select="concat($output_path,'_main_', java:getTime(java:java.util.Date.new()), '.xml')"/>

		<redirect:write file="{$updated_xml_step_move_pagebreak_filename}">
			<xsl:copy-of select="$updated_xml_step_move_pagebreak"/>
		</redirect:write>

		<xsl:copy-of select="document($updated_xml_step_move_pagebreak_filename)"/>

		<xsl:if test="$debug = 'true'">
			<redirect:write file="page_sequence_preface_and_main.xml">
				<xsl:copy-of select="$updated_xml_step_move_pagebreak"/>
			</redirect:write>
		</xsl:if>

		<xsl:call-template name="deleteFile">
			<xsl:with-param name="filepath" select="$updated_xml_step_move_pagebreak_filename"/>
		</xsl:call-template>
	</xsl:template> <!-- END: processPrefaceAndMainSectionsDefault_items -->

	<xsl:template name="insertPrefaceSectionsPageSequences">
		<xsl:element name="preface" namespace="{$namespace_full}"> <!-- save context element -->
			<xsl:element name="page_sequence" namespace="{$namespace_full}">
				<xsl:for-each select="/*/mn:preface/*[not(self::mn:note or self::mn:admonition)]">
					<xsl:sort select="@displayorder" data-type="number"/>
					<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
	</xsl:template> <!-- END: insertPrefaceSectionsPageSequences -->

	<xsl:template name="insertMainSectionsPageSequences">

		<xsl:call-template name="insertSectionsInPageSequence"/>

		<xsl:element name="page_sequence" namespace="{$namespace_full}">
			<xsl:for-each select="/*/mn:annex">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
			</xsl:for-each>
		</xsl:element>

		<xsl:element name="page_sequence" namespace="{$namespace_full}">
			<xsl:element name="bibliography" namespace="{$namespace_full}"> <!-- save context element -->
				<xsl:for-each select="/*/mn:bibliography/*[not(@normative='true')] |            /*/mn:bibliography/mn:clause[mn:references[not(@normative='true')]]">
					<xsl:sort select="@displayorder" data-type="number"/>
					<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
	</xsl:template> <!-- END: insertMainSectionsPageSequences -->

	<xsl:template name="insertSectionsInPageSequence">
		<xsl:element name="sections" namespace="{$namespace_full}"> <!-- save context element -->
			<xsl:element name="page_sequence" namespace="{$namespace_full}">
				<xsl:for-each select="/*/mn:sections/* | /*/mn:bibliography/mn:references[@normative='true']">
					<xsl:sort select="@displayorder" data-type="number"/>
					<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template name="insertMainSectionsInSeparatePageSequences">
		<xsl:element name="sections" namespace="{$namespace_full}"> <!-- save context element -->
			<xsl:for-each select="/*/mn:sections/* | /*/mn:bibliography/mn:references[@normative='true']">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:element name="page_sequence" namespace="{$namespace_full}">
					<xsl:attribute name="main_page_sequence"/>
					<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>

		<xsl:call-template name="insertAnnexAndBibliographyInSeparatePageSequences"/>

		<!-- <xsl:call-template name="insertBibliographyInSeparatePageSequences"/> -->

		<!-- <xsl:call-template name="insertIndexInSeparatePageSequences"/> -->
	</xsl:template> <!-- END: insertMainSectionsInSeparatePageSequences -->

	<xsl:template name="insertAnnexAndBibliographyInSeparatePageSequences">
		<xsl:for-each select="/*/mn:annex |           /*/mn:bibliography/*[not(@normative='true')] |           /*/mn:bibliography/mn:clause[mn:references[not(@normative='true')]] |          /*/mn:indexsect">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:choose>
				<xsl:when test="self::mn:annex or self::mn:indexsect">
					<xsl:element name="page_sequence" namespace="{$namespace_full}">
						<xsl:attribute name="main_page_sequence"/>
						<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise> <!-- bibliography -->
					<xsl:element name="bibliography" namespace="{$namespace_full}"> <!-- save context element -->
						<xsl:element name="page_sequence" namespace="{$namespace_full}">
							<xsl:attribute name="main_page_sequence"/>
							<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
						</xsl:element>
					</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="insertAnnexInSeparatePageSequences">
		<xsl:for-each select="/*/mn:annex">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:element name="page_sequence" namespace="{$namespace_full}">
				<xsl:attribute name="main_page_sequence"/>
				<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="insertBibliographyInSeparatePageSequences">
		<xsl:element name="bibliography" namespace="{$namespace_full}"> <!-- save context element -->
			<xsl:for-each select="/*/mn:bibliography/*[not(@normative='true')] |           /*/mn:bibliography/mn:clause[mn:references[not(@normative='true')]]">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:element name="page_sequence" namespace="{$namespace_full}">
					<xsl:attribute name="main_page_sequence"/>
					<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template name="insertIndexInSeparatePageSequences">
		<xsl:for-each select="/*/mn:indexsect">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:element name="page_sequence" namespace="{$namespace_full}">
				<xsl:attribute name="main_page_sequence"/>
				<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="processAllSectionsDefault_items">
		<xsl:variable name="updated_xml_step_move_pagebreak">
			<xsl:element name="{$root_element}" namespace="{$namespace_full}">
				<xsl:call-template name="copyCommonElements"/>
				<xsl:element name="page_sequence" namespace="{$namespace_full}">
					<xsl:call-template name="insertPrefaceSections"/>
					<xsl:call-template name="insertMainSections"/>
				</xsl:element>
			</xsl:element>
		</xsl:variable>

		<xsl:variable name="updated_xml_step_move_pagebreak_filename" select="concat($output_path,'_preface_and_main_', java:getTime(java:java.util.Date.new()), '.xml')"/>
		<!-- <xsl:message>updated_xml_step_move_pagebreak_filename=<xsl:value-of select="$updated_xml_step_move_pagebreak_filename"/></xsl:message>
		<xsl:message>start write updated_xml_step_move_pagebreak_filename</xsl:message> -->
		<redirect:write file="{$updated_xml_step_move_pagebreak_filename}">
			<xsl:copy-of select="$updated_xml_step_move_pagebreak"/>
		</redirect:write>
		<!-- <xsl:message>end write updated_xml_step_move_pagebreak_filename</xsl:message> -->

		<xsl:copy-of select="document($updated_xml_step_move_pagebreak_filename)"/>

		<!-- TODO: instead of 
		<xsl:for-each select=".//mn:page_sequence[normalize-space() != '' or .//image or .//svg]">
		in each template, add removing empty page_sequence here
		-->

		<xsl:if test="$debug = 'true'">
			<redirect:write file="page_sequence_preface_and_main.xml">
				<xsl:copy-of select="$updated_xml_step_move_pagebreak"/>
			</redirect:write>
		</xsl:if>

		<!-- <xsl:message>start delete updated_xml_step_move_pagebreak_filename</xsl:message> -->
		<xsl:call-template name="deleteFile">
			<xsl:with-param name="filepath" select="$updated_xml_step_move_pagebreak_filename"/>
		</xsl:call-template>
		<!-- <xsl:message>end delete updated_xml_step_move_pagebreak_filename</xsl:message> -->
	</xsl:template> <!-- END: processAllSectionsDefault_items -->

	<xsl:template name="insertPrefaceSections">
		<xsl:element name="preface" namespace="{$namespace_full}"> <!-- save context element -->
			<xsl:for-each select="/*/mn:preface/*[not(self::mn:note or self::mn:admonition)]">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak">
					<xsl:with-param name="page_sequence_at_top">true</xsl:with-param>
				</xsl:apply-templates>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>

	<xsl:template name="insertMainSections">
		<xsl:element name="sections" namespace="{$namespace_full}"> <!-- save context element -->

			<xsl:for-each select="/*/mn:sections/* | /*/mn:bibliography/mn:references[@normative='true']">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak">
					<xsl:with-param name="page_sequence_at_top">true</xsl:with-param>
				</xsl:apply-templates>
			</xsl:for-each>
		</xsl:element>

		<xsl:for-each select="/*/mn:annex">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak">
					<xsl:with-param name="page_sequence_at_top">true</xsl:with-param>
				</xsl:apply-templates>
		</xsl:for-each>

		<xsl:element name="bibliography" namespace="{$namespace_full}"> <!-- save context element -->
			<xsl:for-each select="/*/mn:bibliography/*[not(@normative='true')] |           /*/mn:bibliography/mn:clause[mn:references[not(@normative='true')]]">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak">
					<xsl:with-param name="page_sequence_at_top">true</xsl:with-param>
				</xsl:apply-templates>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>

	<!-- boilerplate sections styles -->
	<xsl:attribute-set name="copyright-statement-style">
	</xsl:attribute-set> <!-- copyright-statement-style -->

	<xsl:template name="refine_copyright-statement-style">
	</xsl:template>

	<xsl:attribute-set name="copyright-statement-title-style">
	</xsl:attribute-set> <!-- copyright-statement-title-style -->

	<xsl:template name="refine_copyright-statement-title-style">
	</xsl:template>

	<xsl:attribute-set name="copyright-statement-p-style">
	</xsl:attribute-set> <!-- copyright-statement-p-style -->

	<xsl:template name="refine_copyright-statement-p-style">

	</xsl:template>

	<xsl:attribute-set name="license-statement-style">
	</xsl:attribute-set> <!-- license-statement-style -->

	<xsl:template name="refine_license-statement-style">
	</xsl:template>

	<xsl:attribute-set name="license-statement-title-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
	</xsl:attribute-set> <!-- license-statement-title-style -->

	<xsl:template name="refine_license-statement-title-style">
	</xsl:template>

	<xsl:attribute-set name="license-statement-p-style">
	</xsl:attribute-set> <!-- license-statement-p-style -->

	<xsl:template name="refine_license-statement-p-style">

	</xsl:template>

	<xsl:attribute-set name="legal-statement-style">
	</xsl:attribute-set> <!-- legal-statement-style -->

	<xsl:template name="refine_legal-statement-style">
	</xsl:template>

	<xsl:attribute-set name="legal-statement-title-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
	</xsl:attribute-set> <!-- legal-statement-title-style -->

	<xsl:template name="refine_legal-statement-title-style">
	</xsl:template>

	<xsl:attribute-set name="legal-statement-p-style">
	</xsl:attribute-set> <!-- legal-statement-p-style -->

	<xsl:template name="refine_legal-statement-p-style">
		<xsl:if test="@align">
			<xsl:attribute name="text-align">
				<xsl:value-of select="@align"/>
			</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:attribute-set name="feedback-statement-style">
	</xsl:attribute-set> <!-- feedback-statement-style -->

	<xsl:template name="refine_feedback-statement-style">
	</xsl:template>

	<xsl:attribute-set name="feedback-statement-title-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
	</xsl:attribute-set> <!-- feedback-statement-title-style -->

	<xsl:template name="refine_feedback-statement-title-style">

	</xsl:template>

	<xsl:attribute-set name="feedback-statement-p-style">
	</xsl:attribute-set> <!-- feedback-statement-p-style -->

	<xsl:template name="refine_feedback-statement-p-style">
	</xsl:template>

	<!-- End boilerplate sections styles -->

	<!-- ================================= -->
	<!-- Preface boilerplate sections processing -->
	<!-- ================================= -->
	<xsl:template match="mn:copyright-statement">
		<fo:block xsl:use-attribute-sets="copyright-statement-style" role="SKIP">
			<xsl:call-template name="refine_copyright-statement-style"/>

			<xsl:apply-templates/>
		</fo:block>
	</xsl:template> <!-- copyright-statement -->

	<xsl:template match="mn:copyright-statement//mn:fmt-title">
		<!-- process in the template 'title' -->
		<xsl:call-template name="title"/>
	</xsl:template> <!-- copyright-statement//title -->

	<xsl:template match="mn:copyright-statement//mn:p">
		<!-- process in the template 'paragraph' -->
		<xsl:call-template name="paragraph"/>
	</xsl:template> <!-- copyright-statement//p -->

	<xsl:template match="mn:license-statement">
		<fo:block xsl:use-attribute-sets="license-statement-style">
			<xsl:call-template name="refine_license-statement-style"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template> <!-- license-statement -->

	<xsl:template match="mn:license-statement//mn:fmt-title">
		<!-- process in the template 'title' -->
		<xsl:call-template name="title"/>
	</xsl:template> <!-- license-statement/title -->

	<xsl:template match="mn:license-statement//mn:p">
		<!-- process in the template 'paragraph' -->
		<xsl:call-template name="paragraph"/>
	</xsl:template> <!-- license-statement/p -->

	<xsl:template match="mn:legal-statement">
		<xsl:param name="isLegacy">false</xsl:param>
		<fo:block xsl:use-attribute-sets="legal-statement-style">
			<xsl:call-template name="refine_legal-statement-style"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template> <!-- legal-statement -->

	<xsl:template match="mn:legal-statement//mn:fmt-title">
		<!-- process in the template 'title' -->
		<xsl:call-template name="title"/>

	</xsl:template> <!-- legal-statement/title -->

	<xsl:template match="mn:legal-statement//mn:p">
		<xsl:param name="margin"/>
		<!-- process in the template 'paragraph' -->
		<xsl:call-template name="paragraph">
			<xsl:with-param name="margin" select="$margin"/>
		</xsl:call-template>
	</xsl:template> <!-- legal-statement/p -->

	<xsl:template match="mn:feedback-statement">
		<fo:block xsl:use-attribute-sets="feedback-statement-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template> <!-- feedback-statement -->

	<xsl:template match="mn:feedback-statement//mn:fmt-title">
		<!-- process in the template 'title' -->
		<xsl:call-template name="title"/>
	</xsl:template>

	<xsl:template match="mn:feedback-statement//mn:p">
		<xsl:param name="margin"/>
		<!-- process in the template 'paragraph' -->
		<xsl:call-template name="paragraph">
			<xsl:with-param name="margin" select="$margin"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ================================= -->
	<!-- END Preface boilerplate sections processing -->
	<!-- ================================= -->

	<xsl:attribute-set name="link-style">
		<xsl:attribute name="color">blue</xsl:attribute>
		<xsl:attribute name="text-decoration">underline</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_link-style">
	</xsl:template> <!-- refine_link-style -->

	<xsl:template match="mn:fmt-link" name="link">
		<xsl:variable name="target_normalized" select="translate(@target, '\', '/')"/>
		<xsl:variable name="target_attachment_name" select="substring-after($target_normalized, '_attachments/')"/>
		<xsl:variable name="isLinkToEmbeddedFile" select="normalize-space(@attachment = 'true' and $pdfAttachmentsList//attachment[@filename = current()/@target])"/>
		<xsl:variable name="target">
			<xsl:choose>
				<xsl:when test="@updatetype = 'true'">
					<xsl:value-of select="concat(normalize-space(@target), '.pdf')"/>
				</xsl:when>
				<!-- link to the PDF attachment -->
				<xsl:when test="$isLinkToEmbeddedFile = 'true'">
					<xsl:variable name="target_file" select="java:org.metanorma.fop.Util.getFilenameFromPath(@target)"/>
					<xsl:value-of select="concat('url(embedded-file:', $target_file, ')')"/>
				</xsl:when>
				<!-- <xsl:when test="starts-with($target_normalized, '_') and contains($target_normalized, '_attachments/') and $pdfAttachmentsList//attachment[@filename = $target_attachment_name]">
					<xsl:value-of select="concat('url(embedded-file:', $target_attachment_name, ')')"/>
				</xsl:when>
				<xsl:when test="contains(@target, concat('_', $inputxml_filename_prefix, '_attachments'))">
					<xsl:variable name="target_" select="translate(@target, '\', '/')"/>
					<xsl:variable name="target__" select="substring-after($target_, concat('_', $inputxml_filename_prefix, '_attachments', '/'))"/>
					<xsl:value-of select="concat('url(embedded-file:', $target__, ')')"/>
				</xsl:when> -->

				<!-- <xsl:when test="not(starts-with(@target, 'http:') or starts-with(@target, 'https') or starts-with(@target, 'www') or starts-with(@target, 'mailto') or starts-with(@target, 'ftp'))">
					<xsl:variable name="target_" select="translate(@target, '\', '/')"/>
					<xsl:variable name="filename">
						<xsl:call-template name="substring-after-last">
							<xsl:with-param name="value" select="$target_"/>
							<xsl:with-param name="delimiter" select="'/'"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:variable name="target_filepath" select="concat($inputxml_basepath, @target)"/>
					<xsl:variable name="file_exists" select="normalize-space(java:exists(java:java.io.File.new($target_filepath)))"/>
					<xsl:choose>
						<xsl:when test="$file_exists = 'true'">
							<xsl:value-of select="concat('url(embedded-file:', $filename, ')')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="normalize-space(@target)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when> -->

				<xsl:otherwise>
					<xsl:value-of select="normalize-space(@target)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="target_text">
			<xsl:choose>
				<xsl:when test="starts-with(normalize-space(@target), 'mailto:')">
					<xsl:value-of select="normalize-space(substring-after(@target, 'mailto:'))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(@target)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:inline xsl:use-attribute-sets="link-style">

			<xsl:if test="starts-with(normalize-space(@target), 'mailto:') and not(ancestor::*[local-name() = 'td'])">
				<xsl:attribute name="keep-together.within-line">always</xsl:attribute>
			</xsl:if>

			<xsl:if test="$isLinkToEmbeddedFile = 'true'">
				<xsl:attribute name="color">inherit</xsl:attribute>
				<xsl:attribute name="text-decoration">none</xsl:attribute>
			</xsl:if>

			<xsl:call-template name="refine_link-style"/>

			<xsl:choose>
				<xsl:when test="$target_text = ''">
					<xsl:apply-templates/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="alt_text">
						<xsl:call-template name="getAltText"/>
					</xsl:variable>
					<xsl:call-template name="insert_basic_link">
						<xsl:with-param name="element">
							<fo:basic-link external-destination="{$target}" fox:alt-text="{$alt_text}">
								<xsl:if test="$isLinkToEmbeddedFile = 'true'">
									<xsl:attribute name="role">Annot</xsl:attribute>
								</xsl:if>
								<xsl:choose>
									<xsl:when test="normalize-space(.) = ''">
										<xsl:call-template name="add-zero-spaces-link-java">
											<xsl:with-param name="text" select="$target_text"/>
										</xsl:call-template>
									</xsl:when>
									<xsl:otherwise>
										<!-- output text from <link>text</link> -->
										<xsl:choose>
											<xsl:when test="starts-with(., 'http://') or starts-with(., 'https://') or starts-with(., 'www.')">
												<xsl:call-template name="add-zero-spaces-link-java">
													<xsl:with-param name="text" select="."/>
												</xsl:call-template>
											</xsl:when>
											<xsl:otherwise>
												<xsl:apply-templates/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
							</fo:basic-link>
							<xsl:if test="$isLinkToEmbeddedFile = 'true'">
								<!-- reserve space at right for PaperClip icon -->
								<fo:inline keep-with-previous.within-line="always">        </fo:inline>
							</xsl:if>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</fo:inline>
	</xsl:template> <!-- link -->

	<xsl:attribute-set name="sourcecode-container-style">
	</xsl:attribute-set>

	<xsl:template name="refine_sourcecode-container-style">
		<xsl:if test="not(ancestor::mn:li) or ancestor::mn:example">
			<xsl:attribute name="margin-left">0mm</xsl:attribute>
		</xsl:if>

		<xsl:if test="ancestor::mn:example">
			<xsl:attribute name="margin-right">0mm</xsl:attribute>
		</xsl:if>

		<xsl:copy-of select="@id"/>

		<xsl:if test="parent::mn:note">
			<xsl:attribute name="margin-left">
				<xsl:choose>
					<xsl:when test="not(ancestor::mn:table)"><xsl:value-of select="$note-body-indent"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:attribute-set name="sourcecode-style">
		<xsl:attribute name="white-space">pre</xsl:attribute>
		<xsl:attribute name="wrap-option">wrap</xsl:attribute>
		<xsl:attribute name="role">Code</xsl:attribute>
		<xsl:attribute name="font-family">Fira Code, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>
		<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="line-height">113%</xsl:attribute>
	</xsl:attribute-set> <!-- sourcecode-style -->

	<xsl:template name="refine_sourcecode-style">
	</xsl:template> <!-- refine_sourcecode-style -->

	<xsl:attribute-set name="sourcecode-name-style">
		<xsl:attribute name="font-size">11pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:attribute name="keep-with-previous">always</xsl:attribute>
	</xsl:attribute-set> <!-- sourcecode-name-style -->

	<xsl:template name="refine_sourcecode-name-style">
	</xsl:template>

	<xsl:template name="add-zero-spaces-equal">
		<xsl:param name="text" select="."/>
		<xsl:variable name="zero-space-after-equals">==========</xsl:variable>
		<xsl:variable name="regex_zero-space-after-equals">(==========)</xsl:variable>
		<xsl:variable name="zero-space-after-equal">=</xsl:variable>
		<xsl:variable name="regex_zero-space-after-equal">(=)</xsl:variable>
		<xsl:variable name="zero-space">​</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($text, $zero-space-after-equals)">
				<!-- <xsl:value-of select="substring-before($text, $zero-space-after-equals)"/>
				<xsl:value-of select="$zero-space-after-equals"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces-equal">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-equals)"/>
				</xsl:call-template> -->
				<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),$regex_zero-space-after-equals,concat('$1',$zero_width_space))"/>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-equal)">
				<!-- <xsl:value-of select="substring-before($text, $zero-space-after-equal)"/>
				<xsl:value-of select="$zero-space-after-equal"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces-equal">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-equal)"/>
				</xsl:call-template> -->
				<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),$regex_zero-space-after-equal,concat('$1',$zero_width_space))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- add-zero-spaces-equal -->

	<!-- =============== -->
	<!-- sourcecode  -->
	<!-- =============== -->

	<xsl:variable name="source-highlighter-css_" select="//mn:metanorma/mn:metanorma-extension/mn:source-highlighter-css"/>
	<xsl:variable name="sourcecode_css_" select="java:org.metanorma.fop.Util.parseCSS($source-highlighter-css_)"/>
	<xsl:variable name="sourcecode_css" select="xalan:nodeset($sourcecode_css_)"/>

	<xsl:template match="*[local-name() = 'property']" mode="css">
		<xsl:attribute name="{@name}">
			<xsl:value-of select="@value"/>
		</xsl:attribute>
	</xsl:template>

	<xsl:template name="get_sourcecode_attributes">
		<xsl:element name="sourcecode_attributes" use-attribute-sets="sourcecode-style">
			<xsl:variable name="_font-size">9.5<!-- inherit -->
			</xsl:variable>

			<xsl:variable name="font-size" select="normalize-space($_font-size)"/>
			<xsl:if test="$font-size != ''">
				<xsl:attribute name="font-size">
					<xsl:choose>
						<xsl:when test="$font-size = 'inherit'"><xsl:value-of select="$font-size"/></xsl:when>
						<xsl:when test="contains($font-size, '%')"><xsl:value-of select="$font-size"/></xsl:when>
						<xsl:when test="ancestor::mn:note"><xsl:value-of select="$font-size * 0.91"/>pt</xsl:when>
						<xsl:otherwise><xsl:value-of select="$font-size"/>pt</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="$sourcecode_css//class[@name = 'sourcecode']" mode="css"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="mn:sourcecode" name="sourcecode">

		<xsl:variable name="sourcecode_attributes">
			<xsl:call-template name="get_sourcecode_attributes"/>
		</xsl:variable>

    <!-- <xsl:copy-of select="$sourcecode_css"/> -->

		<xsl:choose>
			<xsl:when test="$isGenerateTableIF = 'true' and (ancestor::*[local-name() = 'td'] or ancestor::*[local-name() = 'th'])">
				<xsl:for-each select="xalan:nodeset($sourcecode_attributes)/sourcecode_attributes/@*">
					<xsl:attribute name="{local-name()}">
						<xsl:value-of select="."/>
					</xsl:attribute>
				</xsl:for-each>
				<xsl:apply-templates select="node()[not(self::mn:fmt-name)]"/>
			</xsl:when>

			<xsl:otherwise>
				<fo:block-container xsl:use-attribute-sets="sourcecode-container-style" role="SKIP">

					<xsl:call-template name="refine_sourcecode-container-style"/>

					<fo:block-container margin-left="0mm" role="SKIP">

						<fo:block xsl:use-attribute-sets="sourcecode-style">

							<xsl:for-each select="xalan:nodeset($sourcecode_attributes)/sourcecode_attributes/@*">
								<xsl:attribute name="{local-name()}">
									<xsl:value-of select="."/>
								</xsl:attribute>
							</xsl:for-each>

							<xsl:call-template name="refine_sourcecode-style"/>

							<!-- remove margin between rows in the table with sourcecode line numbers -->
							<xsl:if test="ancestor::mn:sourcecode[@linenums = 'true'] and ancestor::mn:tr[1]/following-sibling::mn:tr">
								<xsl:attribute name="margin-top">0pt</xsl:attribute>
								<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
							</xsl:if>

							<xsl:apply-templates select="node()[not(self::mn:fmt-name or self::mn:dl)]"/>
						</fo:block>

						<xsl:apply-templates select="mn:dl"/> <!-- Key table -->
						<xsl:apply-templates select="mn:fmt-name"/> <!-- show sourcecode's name AFTER content -->

					</fo:block-container>
				</fo:block-container>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mn:sourcecode/text() | mn:sourcecode//mn:span/text()" priority="2">
		<xsl:choose>
			<!-- disabled -->
			<xsl:when test="1 = 2 and normalize-space($syntax-highlight) = 'true' and normalize-space(../@lang) != ''"> <!-- condition for turn on of highlighting -->
				<xsl:variable name="syntax" select="java:org.metanorma.fop.Util.syntaxHighlight(., ../@lang)"/>
				<xsl:choose>
					<xsl:when test="normalize-space($syntax) != ''"><!-- if there is highlighted result -->
						<xsl:apply-templates select="xalan:nodeset($syntax)" mode="syntax_highlight"/> <!-- process span tags -->
					</xsl:when>
					<xsl:otherwise> <!-- if case of non-succesfull syntax highlight (for instance, unknown lang), process without highlighting -->
						<xsl:call-template name="add_spaces_to_sourcecode"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="add_spaces_to_sourcecode"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- add sourcecode highlighting -->
	<xsl:template match="mn:sourcecode//mn:span[@class]" priority="2">
		<xsl:variable name="class" select="@class"/>

		<!-- Example: <1> -->
		<xsl:variable name="is_callout">
			<xsl:if test="parent::mn:dt">
				<xsl:variable name="dt_id" select="../@id"/>
				<xsl:if test="ancestor::mn:sourcecode//mn:callout[@target = $dt_id]">true</xsl:if>
			</xsl:if>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$sourcecode_css//class[@name = $class]">
				<fo:inline>
					<xsl:apply-templates select="$sourcecode_css//class[@name = $class]" mode="css"/>
					<xsl:if test="$is_callout = 'true'">&lt;</xsl:if>
					<xsl:apply-templates/>
					<xsl:if test="$is_callout = 'true'">&gt;</xsl:if>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- outer table with line numbers for sourcecode -->
	<xsl:template match="mn:sourcecode[@linenums = 'true']/mn:table" priority="2"> <!-- *[local-name()='table'][@type = 'sourcecode'] |  -->
		<fo:block>
			<fo:table width="100%" table-layout="fixed">
				<xsl:copy-of select="@id"/>
					<fo:table-column column-width="8%"/>
					<fo:table-column column-width="92%"/>
					<fo:table-body>
						<xsl:apply-templates/>
					</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>
	<xsl:template match="mn:sourcecode[@linenums = 'true']/mn:table/mn:tbody" priority="2"> <!-- *[local-name()='table'][@type = 'sourcecode']/*[local-name() = 'tbody'] |  -->
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="mn:sourcecode[@linenums = 'true']/mn:table//mn:tr" priority="2"> <!-- *[local-name()='table'][@type = 'sourcecode']//*[local-name()='tr'] |  -->
		<fo:table-row>
			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template>
	<!-- first td with line numbers -->
	<xsl:template match="mn:sourcecode[@linenums = 'true']/mn:table//mn:tr/*[local-name() = 'td'][not(preceding-sibling::*)]" priority="2"> <!-- *[local-name()='table'][@type = 'sourcecode'] -->
		<fo:table-cell>
			<fo:block>

				<!-- set attibutes for line numbers - same as sourcecode -->
				<xsl:variable name="sourcecode_attributes">
					<xsl:for-each select="following-sibling::*[local-name() = 'td']/mn:sourcecode">
						<xsl:call-template name="get_sourcecode_attributes"/>
					</xsl:for-each>
				</xsl:variable>
				<xsl:for-each select="xalan:nodeset($sourcecode_attributes)/sourcecode_attributes/@*[not(starts-with(local-name(), 'margin-') or starts-with(local-name(), 'space-'))]">
					<xsl:attribute name="{local-name()}">
						<xsl:value-of select="."/>
					</xsl:attribute>
				</xsl:for-each>

				<xsl:apply-templates/>
			</fo:block>
		</fo:table-cell>
	</xsl:template>

	<!-- second td with sourcecode -->
	<xsl:template match="mn:sourcecode[@linenums = 'true']/mn:table//mn:tr/*[local-name() = 'td'][preceding-sibling::*]" priority="2"> <!-- *[local-name()='table'][@type = 'sourcecode'] -->
		<fo:table-cell>
			<fo:block role="SKIP">
				<xsl:apply-templates/>
			</fo:block>
		</fo:table-cell>
	</xsl:template>
	<!-- END outer table with line numbers for sourcecode -->

	<xsl:template name="add_spaces_to_sourcecode">
		<xsl:variable name="text_step1">
			<xsl:call-template name="add-zero-spaces-equal"/>
		</xsl:variable>
		<xsl:variable name="text_step2">
			<xsl:call-template name="add-zero-spaces-java">
				<xsl:with-param name="text" select="$text_step1"/>
			</xsl:call-template>
		</xsl:variable>

		<!-- <xsl:value-of select="$text_step2"/> -->

		<!-- add zero-width space after space -->
		<xsl:variable name="text_step3" select="java:replaceAll(java:java.lang.String.new($text_step2),' ',' ​')"/>

		<!-- split text by zero-width space -->
		<xsl:variable name="text_step4">
			<xsl:call-template name="split_for_interspers">
				<xsl:with-param name="pText" select="$text_step3"/>
				<xsl:with-param name="sep" select="$zero_width_space"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:for-each select="xalan:nodeset($text_step4)/node()">
			<xsl:choose>
				<xsl:when test="local-name() = 'interspers'"> <!-- word with length more than 30 will be interspersed with zero-width space -->
					<xsl:call-template name="interspers-java">
						<xsl:with-param name="str" select="."/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>

	</xsl:template> <!-- add_spaces_to_sourcecode -->

	<xsl:variable name="interspers_tag_open">###interspers123###</xsl:variable>
	<xsl:variable name="interspers_tag_close">###/interspers123###</xsl:variable>
	<!-- split string by separator for interspers -->
	<xsl:template name="split_for_interspers">
		<xsl:param name="pText" select="."/>
		<xsl:param name="sep" select="','"/>
		<!-- word with length more than 30 will be interspersed with zero-width space -->
		<xsl:variable name="regex" select="concat('([^', $zero_width_space, ']{31,})')"/> <!-- sequence of characters (more 31), that doesn't contains zero-width space -->
		<xsl:variable name="text" select="java:replaceAll(java:java.lang.String.new($pText),$regex,concat($interspers_tag_open,'$1',$interspers_tag_close))"/>
		<xsl:call-template name="replace_tag_interspers">
			<xsl:with-param name="text" select="$text"/>
		</xsl:call-template>
	</xsl:template> <!-- end: split string by separator for interspers -->

	<xsl:template name="replace_tag_interspers">
		<xsl:param name="text"/>
		<xsl:choose>
			<xsl:when test="contains($text, $interspers_tag_open)">
				<xsl:value-of select="substring-before($text, $interspers_tag_open)"/>
				<xsl:variable name="text_after" select="substring-after($text, $interspers_tag_open)"/>
				<interspers>
					<xsl:value-of select="substring-before($text_after, $interspers_tag_close)"/>
				</interspers>
				<xsl:call-template name="replace_tag_interspers">
					<xsl:with-param name="text" select="substring-after($text_after, $interspers_tag_close)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$text"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="interspers-java">
		<xsl:param name="str"/>
		<xsl:param name="char" select="$zero_width_space"/>
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new($str),'([^ -.:=_—])',concat('$1', $char))"/> <!-- insert $char after each char excep space, - . : = _ etc. -->
	</xsl:template>

	<xsl:template match="*" mode="syntax_highlight">
		<xsl:apply-templates mode="syntax_highlight"/>
	</xsl:template>

	<xsl:variable name="syntax_highlight_styles_">
		<style class="hljs-addition" xsl:use-attribute-sets="hljs-addition"/>
		<style class="hljs-attr" xsl:use-attribute-sets="hljs-attr"/>
		<style class="hljs-attribute" xsl:use-attribute-sets="hljs-attribute"/>
		<style class="hljs-built_in" xsl:use-attribute-sets="hljs-built_in"/>
		<style class="hljs-bullet" xsl:use-attribute-sets="hljs-bullet"/>
		<style class="hljs-char_and_escape_" xsl:use-attribute-sets="hljs-char_and_escape_"/>
		<style class="hljs-code" xsl:use-attribute-sets="hljs-code"/>
		<style class="hljs-comment" xsl:use-attribute-sets="hljs-comment"/>
		<style class="hljs-deletion" xsl:use-attribute-sets="hljs-deletion"/>
		<style class="hljs-doctag" xsl:use-attribute-sets="hljs-doctag"/>
		<style class="hljs-emphasis" xsl:use-attribute-sets="hljs-emphasis"/>
		<style class="hljs-formula" xsl:use-attribute-sets="hljs-formula"/>
		<style class="hljs-keyword" xsl:use-attribute-sets="hljs-keyword"/>
		<style class="hljs-link" xsl:use-attribute-sets="hljs-link"/>
		<style class="hljs-literal" xsl:use-attribute-sets="hljs-literal"/>
		<style class="hljs-meta" xsl:use-attribute-sets="hljs-meta"/>
		<style class="hljs-meta_hljs-string" xsl:use-attribute-sets="hljs-meta_hljs-string"/>
		<style class="hljs-meta_hljs-keyword" xsl:use-attribute-sets="hljs-meta_hljs-keyword"/>
		<style class="hljs-name" xsl:use-attribute-sets="hljs-name"/>
		<style class="hljs-number" xsl:use-attribute-sets="hljs-number"/>
		<style class="hljs-operator" xsl:use-attribute-sets="hljs-operator"/>
		<style class="hljs-params" xsl:use-attribute-sets="hljs-params"/>
		<style class="hljs-property" xsl:use-attribute-sets="hljs-property"/>
		<style class="hljs-punctuation" xsl:use-attribute-sets="hljs-punctuation"/>
		<style class="hljs-quote" xsl:use-attribute-sets="hljs-quote"/>
		<style class="hljs-regexp" xsl:use-attribute-sets="hljs-regexp"/>
		<style class="hljs-section" xsl:use-attribute-sets="hljs-section"/>
		<style class="hljs-selector-attr" xsl:use-attribute-sets="hljs-selector-attr"/>
		<style class="hljs-selector-class" xsl:use-attribute-sets="hljs-selector-class"/>
		<style class="hljs-selector-id" xsl:use-attribute-sets="hljs-selector-id"/>
		<style class="hljs-selector-pseudo" xsl:use-attribute-sets="hljs-selector-pseudo"/>
		<style class="hljs-selector-tag" xsl:use-attribute-sets="hljs-selector-tag"/>
		<style class="hljs-string" xsl:use-attribute-sets="hljs-string"/>
		<style class="hljs-strong" xsl:use-attribute-sets="hljs-strong"/>
		<style class="hljs-subst" xsl:use-attribute-sets="hljs-subst"/>
		<style class="hljs-symbol" xsl:use-attribute-sets="hljs-symbol"/>
		<style class="hljs-tag" xsl:use-attribute-sets="hljs-tag"/>
		<!-- <style class="hljs-tag_hljs-attr" xsl:use-attribute-sets="hljs-tag_hljs-attr"></style> -->
		<!-- <style class="hljs-tag_hljs-name" xsl:use-attribute-sets="hljs-tag_hljs-name"></style> -->
		<style class="hljs-template-tag" xsl:use-attribute-sets="hljs-template-tag"/>
		<style class="hljs-template-variable" xsl:use-attribute-sets="hljs-template-variable"/>
		<style class="hljs-title" xsl:use-attribute-sets="hljs-title"/>
		<style class="hljs-title_and_class_" xsl:use-attribute-sets="hljs-title_and_class_"/>
		<style class="hljs-title_and_class__and_inherited__" xsl:use-attribute-sets="hljs-title_and_class__and_inherited__"/>
		<style class="hljs-title_and_function_" xsl:use-attribute-sets="hljs-title_and_function_"/>
		<style class="hljs-type" xsl:use-attribute-sets="hljs-type"/>
		<style class="hljs-variable" xsl:use-attribute-sets="hljs-variable"/>
		<style class="hljs-variable_and_language_" xsl:use-attribute-sets="hljs-variable_and_language_"/>
	</xsl:variable>
	<xsl:variable name="syntax_highlight_styles" select="xalan:nodeset($syntax_highlight_styles_)"/>

	<xsl:template match="span" mode="syntax_highlight" priority="2">
		<!-- <fo:inline color="green" font-style="italic"><xsl:apply-templates mode="syntax_highlight"/></fo:inline> -->
		<fo:inline>
			<xsl:variable name="classes_">
				<xsl:call-template name="split">
					<xsl:with-param name="pText" select="@class"/>
					<xsl:with-param name="sep" select="' '"/>
				</xsl:call-template>
				<!-- a few classes together (_and_ suffix) -->
				<xsl:if test="contains(@class, 'hljs-char') and contains(@class, 'escape_')">
					<item>hljs-char_and_escape_</item>
				</xsl:if>
				<xsl:if test="contains(@class, 'hljs-title') and contains(@class, 'class_')">
					<item>hljs-title_and_class_</item>
				</xsl:if>
				<xsl:if test="contains(@class, 'hljs-title') and contains(@class, 'class_') and contains(@class, 'inherited__')">
					<item>hljs-title_and_class__and_inherited__</item>
				</xsl:if>
				<xsl:if test="contains(@class, 'hljs-title') and contains(@class, 'function_')">
					<item>hljs-title_and_function_</item>
				</xsl:if>
				<xsl:if test="contains(@class, 'hljs-variable') and contains(@class, 'language_')">
					<item>hljs-variable_and_language_</item>
				</xsl:if>
				<!-- with parent classes (_ suffix) -->
				<xsl:if test="contains(@class, 'hljs-keyword') and contains(ancestor::*/@class, 'hljs-meta')">
					<item>hljs-meta_hljs-keyword</item>
				</xsl:if>
				<xsl:if test="contains(@class, 'hljs-string') and contains(ancestor::*/@class, 'hljs-meta')">
					<item>hljs-meta_hljs-string</item>
				</xsl:if>
			</xsl:variable>
			<xsl:variable name="classes" select="xalan:nodeset($classes_)"/>

			<xsl:for-each select="$classes/*[local-name() = 'item']">
				<xsl:variable name="class_name" select="."/>
				<xsl:for-each select="$syntax_highlight_styles/style[@class = $class_name]/@*[not(local-name() = 'class')]">
					<xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
				</xsl:for-each>
			</xsl:for-each>

			<!-- <xsl:variable name="class_name">
				<xsl:choose>
					<xsl:when test="@class = 'hljs-attr' and ancestor::*/@class = 'hljs-tag'">hljs-tag_hljs-attr</xsl:when>
					<xsl:when test="@class = 'hljs-name' and ancestor::*/@class = 'hljs-tag'">hljs-tag_hljs-name</xsl:when>
					<xsl:when test="@class = 'hljs-string' and ancestor::*/@class = 'hljs-meta'">hljs-meta_hljs-string</xsl:when>
					<xsl:otherwise><xsl:value-of select="@class"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:for-each select="$syntax_highlight_styles/style[@class = $class_name]/@*[not(local-name() = 'class')]">
				<xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
			</xsl:for-each> -->

		<xsl:apply-templates mode="syntax_highlight"/></fo:inline>
	</xsl:template>

	<xsl:template match="text()" mode="syntax_highlight" priority="2">
		<xsl:call-template name="add_spaces_to_sourcecode"/>
	</xsl:template>

	<!-- end mode="syntax_highlight" -->

	<xsl:template match="mn:sourcecode/mn:fmt-name">
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="sourcecode-name-style">
				<xsl:call-template name="refine_sourcecode-name-style"/>
				<xsl:apply-templates/>
			</fo:block>
		</xsl:if>
	</xsl:template>
	<!-- =============== -->
	<!-- END sourcecode  -->
	<!-- =============== -->

	<xsl:template match="mn:callout">
		<xsl:choose>
			<xsl:when test="normalize-space(@target) = ''">&lt;<xsl:apply-templates/>&gt;</xsl:when>
			<xsl:otherwise><fo:basic-link internal-destination="{@target}" fox:alt-text="{normalize-space()}">&lt;<xsl:apply-templates/>&gt;</fo:basic-link></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mn:callout-annotation">
		<xsl:variable name="annotation-id" select="@id"/>
		<xsl:variable name="callout" select="//*[@target = $annotation-id]/text()"/>
		<fo:block id="{$annotation-id}" white-space="nowrap">
			<fo:inline>
				<xsl:apply-templates>
					<xsl:with-param name="callout" select="concat('&lt;', $callout, '&gt; ')"/>
				</xsl:apply-templates>
			</fo:inline>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:callout-annotation/mn:p">
		<xsl:param name="callout"/>
		<fo:inline id="{@id}">
			<xsl:call-template name="setNamedDestination"/>
			<!-- for first p in annotation, put <x> -->
			<xsl:if test="not(preceding-sibling::mn:p)"><xsl:value-of select="$callout"/></xsl:if>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<!-- pre, strong, em, underline -->

	<!-- ========================= -->
	<!-- Rich text formatting -->
	<!-- ========================= -->

	<xsl:attribute-set name="pre-style">
		<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>
		<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		<xsl:attribute name="font-family">Fira Code, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>
		<xsl:attribute name="line-height">113%</xsl:attribute>
	</xsl:attribute-set> <!-- pre-style -->

	<xsl:template name="refine_pre-style">
	</xsl:template>

	<xsl:attribute-set name="tt-style">
		<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_tt-style">
		<xsl:variable name="_font-size">9.5 <!-- inherit -->
		</xsl:variable>
		<xsl:variable name="font-size" select="normalize-space($_font-size)"/>
		<xsl:if test="$font-size != ''">
			<xsl:attribute name="font-size">
				<xsl:choose>
					<xsl:when test="$font-size = 'inherit'"><xsl:value-of select="$font-size"/></xsl:when>
					<xsl:when test="contains($font-size, '%')"><xsl:value-of select="$font-size"/></xsl:when>
					<xsl:when test="ancestor::mn:note or ancestor::mn:example"><xsl:value-of select="$font-size * 0.91"/>pt</xsl:when>
					<xsl:otherwise><xsl:value-of select="$font-size"/>pt</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:variable name="color-added-text">
		<xsl:text>rgb(0, 255, 0)</xsl:text>
	</xsl:variable>
	<xsl:attribute-set name="add-style">
		<xsl:attribute name="color">red</xsl:attribute>
		<xsl:attribute name="text-decoration">underline</xsl:attribute>
		<!-- <xsl:attribute name="color">black</xsl:attribute>
				<xsl:attribute name="background-color"><xsl:value-of select="$color-added-text"/></xsl:attribute>
				<xsl:attribute name="padding-top">1mm</xsl:attribute>
				<xsl:attribute name="padding-bottom">0.5mm</xsl:attribute> -->
	</xsl:attribute-set>

	<xsl:template name="refine_add-style">
	</xsl:template>

	<xsl:variable name="add-style">
		<add-style xsl:use-attribute-sets="add-style">
			<xsl:call-template name="refine_add-style"/>
		</add-style>
	</xsl:variable>
	<xsl:template name="append_add-style">
		<xsl:copy-of select="xalan:nodeset($add-style)/add-style/@*"/>
	</xsl:template>

	<xsl:variable name="color-deleted-text">
		<xsl:text>red</xsl:text>
	</xsl:variable>
	<xsl:attribute-set name="del-style">
		<xsl:attribute name="color"><xsl:value-of select="$color-deleted-text"/></xsl:attribute>
		<xsl:attribute name="text-decoration">line-through</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_del-style">
	</xsl:template>

	<xsl:attribute-set name="strong-style">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_strong_style">
		<xsl:if test="ancestor::*['preferred']">
			<xsl:attribute name="role">SKIP</xsl:attribute>
		</xsl:if>
	</xsl:template> <!-- refine_strong_style -->

	<xsl:attribute-set name="em-style">
		<xsl:attribute name="font-style">italic</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_em_style">
	</xsl:template> <!-- refine_em_style -->

	<xsl:attribute-set name="sup-style">
		<xsl:attribute name="font-size">80%</xsl:attribute>
		<xsl:attribute name="vertical-align">super</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_sup-style">
	</xsl:template>

	<xsl:attribute-set name="sub-style">
		<xsl:attribute name="font-size">80%</xsl:attribute>
		<xsl:attribute name="vertical-align">sub</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_sub-style">
	</xsl:template>

	<xsl:attribute-set name="underline-style">
		<xsl:attribute name="text-decoration">underline</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_underline-style">
	</xsl:template>

	<xsl:attribute-set name="hi-style">
		<xsl:attribute name="background-color">yellow</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_hi-style">
	</xsl:template>

	<xsl:attribute-set name="strike-style">
		<xsl:attribute name="text-decoration">line-through</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_strike-style">
	</xsl:template>

	<xsl:template match="mn:br">
		<xsl:value-of select="$linebreak"/>
	</xsl:template>

	<xsl:template match="mn:em">
		<fo:inline xsl:use-attribute-sets="em-style">
			<xsl:call-template name="refine_em_style"/>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="mn:strong | *[local-name()='b']">
		<xsl:param name="split_keep-within-line"/>
		<fo:inline xsl:use-attribute-sets="strong-style">
			<xsl:call-template name="refine_strong_style"/>

			<xsl:apply-templates>
				<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
			</xsl:apply-templates>
		</fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name()='padding']">
		<fo:inline padding-right="{@value}"> </fo:inline>
	</xsl:template>

	<xsl:template match="mn:sup">
		<fo:inline xsl:use-attribute-sets="sup-style">
			<xsl:call-template name="refine_sup-style"/>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="mn:sub">
		<fo:inline xsl:use-attribute-sets="sub-style">
			<xsl:call-template name="refine_sub-style"/>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="mn:tt">
		<fo:inline xsl:use-attribute-sets="tt-style">
			<xsl:call-template name="refine_tt-style"/>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template> <!-- tt -->

	<xsl:variable name="regex_url_start">^(http://|https://|www\.)?(.*)</xsl:variable>
	<xsl:template match="mn:tt/text()" priority="2">
		<xsl:choose>
			<xsl:when test="java:replaceAll(java:java.lang.String.new(.), $regex_url_start, '$2') != ''">
				 <!-- url -->
				<xsl:call-template name="add-zero-spaces-link-java"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="add_spaces_to_sourcecode"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mn:underline">
		<fo:inline xsl:use-attribute-sets="underline-style">
			<xsl:call-template name="refine_underline-style"/>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<!-- ================= -->
	<!-- Added,deleted text -->
	<!-- ================= -->
	<xsl:template match="mn:add | mn:change-open-tag | mn:change-close-tag" name="tag_add">
		<xsl:param name="skip">true</xsl:param>
		<xsl:param name="block">false</xsl:param>
		<xsl:param name="type"/>
		<xsl:param name="text-align"/>
		<xsl:choose>
			<xsl:when test="starts-with(., $ace_tag) or self::mn:change-open-tag or self::mn:change-close-tag"> <!-- examples: ace-tag_A1_start, ace-tag_A2_end, C1_start, AC_start, or
							<change-open-tag>A<sub>1</sub></change-open-tag>, <change-close-tag>A<sub>1</sub></change-close-tag> -->
				<xsl:choose>
					<xsl:when test="$skip = 'true' and       ((local-name(../..) = 'note' and not(preceding-sibling::node())) or       (parent::mn:fmt-title and preceding-sibling::node()[1][self::mn:tab]) or      local-name(..) = 'formattedref' and not(preceding-sibling::node()))      and       ../node()[last()][self::mn:add][starts-with(text(), $ace_tag)]"><!-- start tag displayed in template name="note" and title --></xsl:when>
					<xsl:otherwise>
						<xsl:variable name="tag">
							<xsl:call-template name="insertTag">
								<xsl:with-param name="type">
									<xsl:choose>
										<xsl:when test="self::mn:change-open-tag">start</xsl:when>
										<xsl:when test="self::mn:change-close-tag">end</xsl:when>
										<xsl:when test="$type = ''"><xsl:value-of select="substring-after(substring-after(., $ace_tag), '_')"/> <!-- start or end --></xsl:when>
										<xsl:otherwise><xsl:value-of select="$type"/></xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
								<xsl:with-param name="kind">
									<xsl:choose>
										<xsl:when test="self::mn:change-open-tag or self::mn:change-close-tag">
											<xsl:value-of select="text()"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="substring(substring-before(substring-after(., $ace_tag), '_'), 1, 1)"/> <!-- A or C -->
										</xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
								<xsl:with-param name="value">
									<xsl:choose>
										<xsl:when test="self::mn:change-open-tag or self::mn:change-close-tag">
											<xsl:value-of select="mn:sub"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="substring(substring-before(substring-after(., $ace_tag), '_'), 2)"/> <!-- 1, 2, C -->
										</xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="$block = 'false'">
								<fo:inline>
									<xsl:copy-of select="$tag"/>
								</fo:inline>
							</xsl:when>
							<xsl:otherwise>
								<fo:block> <!-- for around figures -->
									<xsl:if test="$text-align != ''">
										<xsl:attribute name="text-align"><xsl:value-of select="$text-align"/></xsl:attribute>
									</xsl:if>
									<xsl:copy-of select="$tag"/>
								</fo:block>
							</xsl:otherwise>
						</xsl:choose>

					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@amendment">
				<fo:inline>
					<xsl:call-template name="insertTag">
						<xsl:with-param name="kind">A</xsl:with-param>
						<xsl:with-param name="value"><xsl:value-of select="@amendment"/></xsl:with-param>
					</xsl:call-template>
					<xsl:apply-templates/>
					<xsl:call-template name="insertTag">
						<xsl:with-param name="type">closing</xsl:with-param>
						<xsl:with-param name="kind">A</xsl:with-param>
						<xsl:with-param name="value"><xsl:value-of select="@amendment"/></xsl:with-param>
					</xsl:call-template>
				</fo:inline>
			</xsl:when>
			<xsl:when test="@corrigenda">
				<fo:inline>
					<xsl:call-template name="insertTag">
						<xsl:with-param name="kind">C</xsl:with-param>
						<xsl:with-param name="value"><xsl:value-of select="@corrigenda"/></xsl:with-param>
					</xsl:call-template>
					<xsl:apply-templates/>
					<xsl:call-template name="insertTag">
						<xsl:with-param name="type">closing</xsl:with-param>
						<xsl:with-param name="kind">C</xsl:with-param>
						<xsl:with-param name="value"><xsl:value-of select="@corrigenda"/></xsl:with-param>
					</xsl:call-template>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline xsl:use-attribute-sets="add-style">
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- add -->

	<xsl:template name="insertTag">
		<xsl:param name="type"/>
		<xsl:param name="kind"/>
		<xsl:param name="value"/>
		<xsl:variable name="add_width" select="string-length($value) * 20"/>
		<xsl:variable name="maxwidth" select="60 + $add_width"/>
			<fo:instream-foreign-object fox:alt-text="OpeningTag" baseline-shift="-10%"><!-- alignment-baseline="middle" -->
				<xsl:attribute name="height">3.5mm</xsl:attribute> <!-- 5mm -->
				<xsl:attribute name="content-width">100%</xsl:attribute>
				<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
				<xsl:attribute name="scaling">uniform</xsl:attribute>
				<!-- <svg xmlns="http://www.w3.org/2000/svg" width="{$maxwidth + 32}" height="80">
					<g>
						<xsl:if test="$type = 'closing' or $type = 'end'">
							<xsl:attribute name="transform">scale(-1 1) translate(-<xsl:value-of select="$maxwidth + 32"/>,0)</xsl:attribute>
						</xsl:if>
						<polyline points="0,0 {$maxwidth},0 {$maxwidth + 30},40 {$maxwidth},80 0,80 " stroke="black" stroke-width="5" fill="white"/>
						<line x1="0" y1="0" x2="0" y2="80" stroke="black" stroke-width="20"/>
					</g>
					<text font-family="Arial" x="15" y="57" font-size="40pt">
						<xsl:if test="$type = 'closing' or $type = 'end'">
							<xsl:attribute name="x">25</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="$kind"/><tspan dy="10" font-size="30pt"><xsl:value-of select="$value"/></tspan>
					</text>
				</svg> -->
				<svg xmlns="http://www.w3.org/2000/svg" width="{$maxwidth + 32}" height="80">
					<g>
						<xsl:if test="$type = 'closing' or $type = 'end'">
							<xsl:attribute name="transform">scale(-1 1) translate(-<xsl:value-of select="$maxwidth + 32"/>,0)</xsl:attribute>
						</xsl:if>
						<polyline points="0,2.5 {$maxwidth},2.5 {$maxwidth + 20},40 {$maxwidth},77.5 0,77.5" stroke="black" stroke-width="5" fill="white"/>
						<line x1="9.5" y1="0" x2="9.5" y2="80" stroke="black" stroke-width="19"/>
					</g>
					<xsl:variable name="text_x">
						<xsl:choose>
							<xsl:when test="$type = 'closing' or $type = 'end'">28</xsl:when>
							<xsl:otherwise>22</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<text font-family="Arial" x="{$text_x}" y="50" font-size="40pt">
						<xsl:value-of select="$kind"/>
					</text>
					<text font-family="Arial" x="{$text_x + 33}" y="65" font-size="38pt">
						<xsl:value-of select="$value"/>
					</text>
				</svg>
			</fo:instream-foreign-object>
	</xsl:template>

	<xsl:template match="mn:del">
		<fo:inline xsl:use-attribute-sets="del-style">
			<xsl:call-template name="refine_del-style"/>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>
	<!-- ================= -->
	<!-- END Added,deleted text -->
	<!-- ================= -->

	<!-- highlight text -->
	<xsl:template match="mn:hi | mn:span[@class = 'fmt-hi']" priority="3">
		<fo:inline xsl:use-attribute-sets="hi-style">
			<xsl:call-template name="refine_hi-style"/>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="text()[ancestor::mn:smallcap]" name="smallcaps">
		<xsl:param name="txt"/>
		<!-- <xsl:variable name="text" select="normalize-space(.)"/> --> <!-- https://github.com/metanorma/metanorma-iso/issues/1115 -->
		<xsl:variable name="text">
			<xsl:choose>
				<xsl:when test="$txt != ''">
					<xsl:value-of select="$txt"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="ratio_">0.75
		</xsl:variable>
		<xsl:variable name="ratio" select="number(normalize-space($ratio_))"/>
		<fo:inline font-size="{$ratio * 100}%" role="SKIP">
				<xsl:if test="string-length($text) &gt; 0">
					<xsl:variable name="smallCapsText">
						<xsl:call-template name="recursiveSmallCaps">
							<xsl:with-param name="text" select="$text"/>
							<xsl:with-param name="ratio" select="$ratio"/>
						</xsl:call-template>
					</xsl:variable>
					<!-- merge neighboring fo:inline -->
					<xsl:for-each select="xalan:nodeset($smallCapsText)/node()">
						<xsl:choose>
							<xsl:when test="self::fo:inline and preceding-sibling::node()[1][self::fo:inline]"><!-- <xsl:copy-of select="."/> --></xsl:when>
							<xsl:when test="self::fo:inline and @font-size">
								<xsl:variable name="curr_pos" select="count(preceding-sibling::node()) + 1"/>
								<!-- <curr_pos><xsl:value-of select="$curr_pos"/></curr_pos> -->
								<xsl:variable name="next_text_" select="count(following-sibling::node()[not(local-name() = 'inline')][1]/preceding-sibling::node())"/>
								<xsl:variable name="next_text">
									<xsl:choose>
										<xsl:when test="$next_text_ = 0">99999999</xsl:when>
										<xsl:otherwise><xsl:value-of select="$next_text_ + 1"/></xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<!-- <next_text><xsl:value-of select="$next_text"/></next_text> -->
								<fo:inline>
									<xsl:copy-of select="@*"/>
									<xsl:copy-of select="./node()"/>
									<xsl:for-each select="following-sibling::node()[position() &lt; $next_text - $curr_pos]"> <!-- [self::fo:inline] -->
										<xsl:copy-of select="./node()"/>
									</xsl:for-each>
								</fo:inline>
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy-of select="."/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:if>
			</fo:inline>
	</xsl:template>

	<xsl:template name="recursiveSmallCaps">
    <xsl:param name="text"/>
    <xsl:param name="ratio">0.75</xsl:param>
    <xsl:variable name="char" select="substring($text,1,1)"/>
    <!-- <xsl:variable name="upperCase" select="translate($char, $lower, $upper)"/> -->
		<xsl:variable name="upperCase" select="java:toUpperCase(java:java.lang.String.new($char))"/>
    <xsl:choose>
      <xsl:when test="$char=$upperCase">
        <fo:inline font-size="{100 div $ratio}%" role="SKIP">
          <xsl:value-of select="$upperCase"/>
        </fo:inline>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$upperCase"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="string-length($text) &gt; 1">
      <xsl:call-template name="recursiveSmallCaps">
        <xsl:with-param name="text" select="substring($text,2)"/>
        <xsl:with-param name="ratio" select="$ratio"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

	<xsl:template match="mn:strike">
		<fo:inline xsl:use-attribute-sets="strike-style">
			<xsl:call-template name="refine_strike-style"/>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<!-- Example: <span style="font-family:&quot;Noto Sans JP&quot;">styled text</span> -->
	<xsl:template match="mn:span[@style]" priority="2">
		<xsl:variable name="styles__">
			<xsl:call-template name="split">
				<xsl:with-param name="pText" select="concat(@style,';')"/>
				<xsl:with-param name="sep" select="';'"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="quot">"</xsl:variable>
		<xsl:variable name="styles_">
			<xsl:for-each select="xalan:nodeset($styles__)/mnx:item">
				<xsl:variable name="key" select="normalize-space(substring-before(., ':'))"/>
				<xsl:variable name="value_" select="normalize-space(substring-after(translate(.,$quot,''), ':'))"/>
				<xsl:variable name="value">
					<xsl:choose>
						<!-- if font-size is digits only -->
						<xsl:when test="$key = 'font-size' and translate($value_, '0123456789', '') = ''"><xsl:value-of select="$value_"/>pt</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$value_"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:if test="$key = 'font-family' or           $key = 'font-size' or          $key = 'color' or          $key = 'baseline-shift' or          $key = 'line-height'          ">
					<style name="{$key}"><xsl:value-of select="$value"/></style>
				</xsl:if>
				<xsl:if test="$key = 'text-indent'">
					<style name="padding-left"><xsl:value-of select="$value"/></style>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="styles" select="xalan:nodeset($styles_)"/>
		<xsl:choose>
			<xsl:when test="$styles/style">
				<fo:inline>
					<xsl:for-each select="$styles/style">
						<xsl:attribute name="{@name}"><xsl:value-of select="."/></xsl:attribute>
					</xsl:for-each>
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- END: span[@style] -->

	<!-- Note: to enable the addition of character span markup with semantic styling for DIS Word output -->
	<xsl:template match="mn:span">
		<xsl:apply-templates/>
	</xsl:template>

	<!-- Don't break standard's numbers -->
	<!-- Example : <span class="stdpublisher">ISO</span> <span class="stddocNumber">10303</span>-<span class="stddocPartNumber">1</span>:<span class="stdyear">1994</span> -->
	<xsl:template match="mn:span[@class = 'stdpublisher' or @class = 'stddocNumber' or @class = 'stddocPartNumber' or @class = 'stdyear']" priority="2">
		<xsl:choose>
			<xsl:when test="ancestor::mn:table"><xsl:apply-templates/></xsl:when>
			<xsl:when test="following-sibling::*[2][self::mn:span][@class = 'stdpublisher' or @class = 'stddocNumber' or @class = 'stddocPartNumber' or @class = 'stdyear']">
				<fo:inline keep-with-next.within-line="always" role="SKIP"><xsl:apply-templates/></fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="text()[not(ancestor::mn:table) and preceding-sibling::*[1][self::mn:span][@class = 'stdpublisher' or @class = 'stddocNumber' or @class = 'stddocPartNumber' or @class = 'stdyear'] and   following-sibling::*[1][self::mn:span][@class = 'stdpublisher' or @class = 'stddocNumber' or @class = 'stddocPartNumber' or @class = 'stdyear']]" priority="2">
		<fo:inline keep-with-next.within-line="always" role="SKIP"><xsl:value-of select="."/></fo:inline>
	</xsl:template>

	<xsl:template match="mn:span[contains(@style, 'text-transform:none')]//text()" priority="5">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="mn:pre" name="pre">
		<fo:block xsl:use-attribute-sets="pre-style">
			<xsl:call-template name="refine_pre-style"/>
			<xsl:copy-of select="@id"/>
			<xsl:choose>

				<xsl:when test="ancestor::mn:sourcecode[@linenums = 'true'] and ancestor::*[local-name() = 'td'][1][not(preceding-sibling::*)]"> <!-- pre in the first td in the table with @linenums = 'true' -->
					<xsl:if test="ancestor::mn:tr[1]/following-sibling::mn:tr"> <!-- is current tr isn't last -->
						<xsl:attribute name="margin-top">0pt</xsl:attribute>
						<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
					</xsl:if>
					<fo:instream-foreign-object fox:alt-text="{.}" content-width="95%">
						<math xmlns="http://www.w3.org/1998/Math/MathML">
							<mtext><xsl:value-of select="."/></mtext>
						</math>
					</fo:instream-foreign-object>
				</xsl:when>

				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>

			</xsl:choose>
		</fo:block>
	</xsl:template> <!-- pre -->

	<!-- ========================= -->
	<!-- END Rich text formatting -->
	<!-- ========================= -->

	<xsl:attribute-set name="permission-style">
	</xsl:attribute-set>

	<xsl:template name="refine_permission-style">
	</xsl:template>

	<xsl:attribute-set name="permission-name-style">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_permission-name-style">
	</xsl:template>

	<xsl:attribute-set name="permission-label-style">
	</xsl:attribute-set>

	<xsl:template name="refine_permission-label-style">
	</xsl:template>

	<xsl:attribute-set name="requirement-style">
	</xsl:attribute-set>

	<xsl:template name="refine_requirement-style">
	</xsl:template>

	<xsl:attribute-set name="requirement-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_requirement-name-style">
	</xsl:template>

	<xsl:attribute-set name="requirement-label-style">
	</xsl:attribute-set>

	<xsl:template name="refine_requirement-label-style">
	</xsl:template>

	<xsl:attribute-set name="subject-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="inherit-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="description-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="specification-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="measurement-target-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="verification-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="import-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="component-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="recommendation-style">
		<xsl:attribute name="border">1pt solid black</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_recommendation-style">
	</xsl:template>

	<xsl:attribute-set name="recommendation-name-style">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_recommendation-name-style">
	</xsl:template>

	<xsl:attribute-set name="recommendation-label-style">
	</xsl:attribute-set>

	<xsl:template name="refine_recommendation-label-style">
	</xsl:template>

	<!-- ========== -->
	<!-- permission -->
	<!-- ========== -->
	<xsl:template match="mn:permission">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}" xsl:use-attribute-sets="permission-style">
			<xsl:call-template name="refine_permission-style"/>
			<xsl:apply-templates select="mn:fmt-name"/>
			<xsl:apply-templates select="node()[not(self::mn:fmt-name)]"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:permission/mn:fmt-name">
		<xsl:if test="normalize-space() != ''">
			<fo:inline xsl:use-attribute-sets="permission-name-style">
				<xsl:call-template name="refine_permission-name-style"/>
				<xsl:apply-templates/><xsl:text>:</xsl:text>
			</fo:inline>

		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:permission/mn:label">
		<fo:block xsl:use-attribute-sets="permission-label-style">
			<xsl:call-template name="refine_permission-label-style"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<!-- ========== -->
	<!-- ========== -->

	<!-- ========== -->
	<!-- requirement -->
	<!-- ========== -->
	<xsl:template match="mn:requirement">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}" xsl:use-attribute-sets="requirement-style">
			<xsl:call-template name="refine_requirement-style"/>
			<xsl:apply-templates select="mn:fmt-name"/>
			<xsl:apply-templates select="mn:label"/>
			<xsl:apply-templates select="@obligation"/>
			<xsl:apply-templates select="mn:subject"/>
			<xsl:apply-templates select="node()[not(self::mn:fmt-name) and not(self::mn:label) and not(self::mn:subject)]"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:requirement/mn:fmt-name">
		<xsl:if test="normalize-space() != ''">
			<fo:inline xsl:use-attribute-sets="requirement-name-style">
				<xsl:call-template name="refine_requirement-name-style"/>
				<xsl:apply-templates/><xsl:text>:</xsl:text>
			</fo:inline>

		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:requirement/mn:label">
		<fo:block xsl:use-attribute-sets="requirement-label-style">
			<xsl:call-template name="refine_requirement-label-style"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:requirement/@obligation">
			<fo:block>
				<fo:inline padding-right="3mm">Obligation</fo:inline><xsl:value-of select="."/>
			</fo:block>
	</xsl:template>

	<xsl:template match="mn:requirement/mn:subject" priority="2">
		<fo:block xsl:use-attribute-sets="subject-style">
			<xsl:text>Target Type </xsl:text><xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- ========== -->
	<!-- ========== -->

	<!-- ========== -->
	<!-- recommendation -->
	<!-- ========== -->
	<xsl:template match="mn:recommendation">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}" xsl:use-attribute-sets="recommendation-style">
			<xsl:call-template name="refine_recommendation-style"/>
			<xsl:apply-templates select="mn:fmt-name"/>
			<xsl:apply-templates select="node()[not(self::mn:fmt-name)]"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:recommendation/mn:fmt-name">
		<xsl:if test="normalize-space() != ''">
			<fo:inline xsl:use-attribute-sets="recommendation-name-style">
				<xsl:call-template name="refine_recommendation-name-style"/>
				<xsl:apply-templates/><xsl:text>:</xsl:text>
			</fo:inline>

		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:recommendation/mn:label">
		<fo:block xsl:use-attribute-sets="recommendation-label-style">
			<xsl:call-template name="refine_recommendation-label-style"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<!-- ========== -->
	<!-- END recommendation -->
	<!-- ========== -->

	<!-- ========== -->
	<!-- ========== -->

	<xsl:template match="mn:subject">
		<fo:block xsl:use-attribute-sets="subject-style">
			<xsl:text>Target Type </xsl:text><xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:div">
		<fo:block><xsl:apply-templates/></fo:block>
	</xsl:template>

	<xsl:template match="mn:inherit | mn:component[@class = 'inherit'] |           mn:div[@type = 'requirement-inherit'] |           mn:div[@type = 'recommendation-inherit'] |           mn:div[@type = 'permission-inherit']">
		<fo:block xsl:use-attribute-sets="inherit-style">
			<xsl:text>Dependency </xsl:text><xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:description | mn:component[@class = 'description'] |           mn:div[@type = 'requirement-description'] |           mn:div[@type = 'recommendation-description'] |           mn:div[@type = 'permission-description']">
		<fo:block xsl:use-attribute-sets="description-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:specification | mn:component[@class = 'specification'] |           mn:div[@type = 'requirement-specification'] |           mn:div[@type = 'recommendation-specification'] |           mn:div[@type = 'permission-specification']">
		<fo:block xsl:use-attribute-sets="specification-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:measurement-target | mn:component[@class = 'measurement-target'] |           mn:div[@type = 'requirement-measurement-target'] |           mn:div[@type = 'recommendation-measurement-target'] |           mn:div[@type = 'permission-measurement-target']">
		<fo:block xsl:use-attribute-sets="measurement-target-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:verification | mn:component[@class = 'verification'] |           mn:div[@type = 'requirement-verification'] |           mn:div[@type = 'recommendation-verification'] |           mn:div[@type = 'permission-verification']">
		<fo:block xsl:use-attribute-sets="verification-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:import | mn:component[@class = 'import'] |           mn:div[@type = 'requirement-import'] |           mn:div[@type = 'recommendation-import'] |           mn:div[@type = 'permission-import']">
		<fo:block xsl:use-attribute-sets="import-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:div[starts-with(@type, 'requirement-component')] |           mn:div[starts-with(@type, 'recommendation-component')] |           mn:div[starts-with(@type, 'permission-component')]">
		<fo:block xsl:use-attribute-sets="component-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<!-- ========== -->
	<!-- END  -->
	<!-- ========== -->

	<!-- ========== -->
	<!-- requirement, recommendation, permission table -->
	<!-- ========== -->
	<xsl:template match="mn:table[@class = 'recommendation' or @class='requirement' or @class='permission']">
		<fo:block-container margin-left="0mm" margin-right="0mm" margin-bottom="12pt" role="SKIP">
			<xsl:if test="ancestor::mn:table[@class = 'recommendation' or @class='requirement' or @class='permission']">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<xsl:call-template name="setNamedDestination"/>
			<fo:block-container margin-left="0mm" margin-right="0mm" role="SKIP">
				<fo:table id="{@id}" table-layout="fixed" width="100%"> <!-- border="1pt solid black" -->
					<xsl:if test="ancestor::mn:table[@class = 'recommendation' or @class='requirement' or @class='permission']">
						<!-- <xsl:attribute name="border">0.5pt solid black</xsl:attribute> -->
					</xsl:if>
					<xsl:variable name="simple-table">
						<xsl:call-template name="getSimpleTable">
							<xsl:with-param name="id" select="@id"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:variable name="cols-count" select="count(xalan:nodeset($simple-table)//mn:tr[1]/mn:td)"/>
					<xsl:if test="$cols-count = 2 and not(ancestor::*[local-name()='table'])">
						<fo:table-column column-width="30%"/>
						<fo:table-column column-width="70%"/>
					</xsl:if>
					<xsl:apply-templates mode="requirement"/>
				</fo:table>
				<!-- fn processing -->
				<xsl:if test=".//mn:fn">
					<xsl:for-each select="mn:tbody">
						<fo:block font-size="90%" border-bottom="1pt solid black">
							<xsl:call-template name="table_fn_display"/>
						</fo:block>
					</xsl:for-each>
				</xsl:if>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>

	<xsl:template match="*[local-name()='thead']" mode="requirement">
		<fo:table-header>
			<xsl:apply-templates mode="requirement"/>
		</fo:table-header>
	</xsl:template>

	<xsl:template match="*[local-name()='tbody']" mode="requirement">
		<fo:table-body>
			<xsl:apply-templates mode="requirement"/>
		</fo:table-body>
	</xsl:template>

	<xsl:template match="*[local-name()='tr']" mode="requirement">
		<fo:table-row height="7mm" border-bottom="0.5pt solid grey">

			<xsl:if test="parent::*[local-name()='thead'] or starts-with(*[local-name()='td' or local-name()='th'][1], 'Requirement ') or starts-with(*[local-name()='td' or local-name()='th'][1], 'Recommendation ')">
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:if>

			<xsl:apply-templates mode="requirement"/>
		</fo:table-row>
	</xsl:template>

	<xsl:template match="*[local-name()='th']" mode="requirement">
		<fo:table-cell text-align="{@align}" display-align="center" padding="1mm" padding-left="2mm"> <!-- border="0.5pt solid black" -->
			<xsl:call-template name="setTextAlignment">
				<xsl:with-param name="default">left</xsl:with-param>
			</xsl:call-template>

			<xsl:call-template name="setTableCellAttributes"/>

			<fo:block role="SKIP">
				<xsl:apply-templates/>
			</fo:block>
		</fo:table-cell>
	</xsl:template>

	<xsl:template match="*[local-name()='td']" mode="requirement">
		<fo:table-cell text-align="{@align}" display-align="center" padding="1mm" padding-left="2mm"> <!-- border="0.5pt solid black" -->
			<xsl:if test="mn:table[@class = 'recommendation' or @class='requirement' or @class='permission']">
				<xsl:attribute name="padding">0mm</xsl:attribute>
				<xsl:attribute name="padding-left">0mm</xsl:attribute>
			</xsl:if>
			<xsl:call-template name="setTextAlignment">
				<xsl:with-param name="default">left</xsl:with-param>
			</xsl:call-template>

			<xsl:if test="following-sibling::*[local-name()='td'] and not(preceding-sibling::*[local-name()='td'])">
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:if>

			<xsl:call-template name="setTableCellAttributes"/>

			<fo:block role="SKIP">
				<xsl:apply-templates/>
			</fo:block>
		</fo:table-cell>
	</xsl:template>

	<xsl:template match="mn:p[@class='RecommendationTitle' or @class = 'RecommendationTestTitle']" priority="2">
		<fo:block font-size="11pt">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'p2'][ancestor::mn:table[@class = 'recommendation' or @class='requirement' or @class='permission']]">
		<fo:block>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<!-- ========== -->
	<!-- END requirement, recommendation, permission table -->
	<!-- ========== -->

	<xsl:attribute-set name="term-style">
		<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
	</xsl:attribute-set> <!-- term-style -->

	<xsl:template name="refine_term-style">
	</xsl:template>

	<xsl:attribute-set name="term-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set> <!-- term-name-style -->

	<xsl:template name="refine_term-name-style">
	</xsl:template>

	<xsl:attribute-set name="preferred-block-style">
		<xsl:attribute name="line-height">1.1</xsl:attribute>
	</xsl:attribute-set> <!-- preferred-block-style -->

	<xsl:template name="refine_preferred-block-style">
	</xsl:template>

	<xsl:attribute-set name="preferred-term-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set> <!-- preferred-term-style -->

	<xsl:template name="refine_preferred-term-style">
		<xsl:if test="mn:strong">
			<xsl:attribute name="font-weight">normal</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:attribute-set name="domain-style">
	</xsl:attribute-set> <!-- domain-style -->

	<xsl:template name="refine_domain-style">
	</xsl:template>

	<xsl:attribute-set name="admitted-style">
	</xsl:attribute-set> <!-- admitted-style -->

	<xsl:template name="refine_admitted-style">
	</xsl:template>

	<xsl:attribute-set name="deprecates-style">
	</xsl:attribute-set> <!-- deprecates-style -->

	<xsl:template name="refine_deprecates-style">
	</xsl:template>

	<xsl:attribute-set name="related-block-style" use-attribute-sets="preferred-block-style">
	</xsl:attribute-set>

	<xsl:template name="refine_related-block-style">
	</xsl:template>

	<xsl:attribute-set name="definition-style">
		<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
	</xsl:attribute-set> <!-- definition-style -->

	<xsl:template name="refine_definition-style">
	</xsl:template>

	<xsl:attribute-set name="termsource-style">
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
	</xsl:attribute-set> <!-- termsource-style -->

	<xsl:template name="refine_termsource-style">
	</xsl:template> <!-- refine_termsource-style -->

	<xsl:attribute-set name="termsource-text-style">
	</xsl:attribute-set> <!-- termsource-text-style -->

	<xsl:template name="refine_termsource-text-style">
	</xsl:template>

	<xsl:attribute-set name="origin-style">
		<xsl:attribute name="color">blue</xsl:attribute>
		<xsl:attribute name="text-decoration">underline</xsl:attribute>
	</xsl:attribute-set> <!-- origin-style -->

	<xsl:template name="refine_origin-style">
	</xsl:template>

	<!-- ====== -->
	<!-- term      -->
	<!-- ====== -->

	<xsl:template match="mn:terms">
		<!-- <xsl:message>'terms' <xsl:number/> processing...</xsl:message> -->
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:term">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}" xsl:use-attribute-sets="term-style">
			<xsl:call-template name="refine_term-style"/>

			<xsl:apply-templates select="node()[not(self::mn:fmt-name)]"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:term/mn:fmt-name">
		<xsl:if test="normalize-space() != ''">
			<!-- <xsl:variable name="level">
				<xsl:call-template name="getLevelTermName"/>
			</xsl:variable>
			<fo:inline role="H{$level}">
				<xsl:apply-templates />
			</fo:inline> -->
			<xsl:apply-templates/>
		</xsl:if>
	</xsl:template>
	<!-- ====== -->
	<!-- ====== -->

	<!-- ====== -->
	<!-- termsource -->
	<!-- origin -->
	<!-- modification -->
	<!-- ====== -->
	<xsl:template match="mn:fmt-termsource" name="termsource">
		<fo:block xsl:use-attribute-sets="termsource-style">

			<xsl:call-template name="refine_termsource-style"/>

			<!-- Example: [SOURCE: ISO 5127:2017, 3.1.6.02] -->
			<xsl:variable name="termsource_text">
				<xsl:apply-templates/>
			</xsl:variable>
			<xsl:copy-of select="$termsource_text"/>
			<!-- <xsl:choose>
				<xsl:when test="starts-with(normalize-space($termsource_text), '[')">
					<xsl:copy-of select="$termsource_text"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="$namespace = 'bsi'">
						<xsl:choose>
							<xsl:when test="$document_type = 'PAS' and starts-with(mn:origin/@citeas, '[')"><xsl:text>{</xsl:text></xsl:when>
							<xsl:otherwise><xsl:text>[</xsl:text></xsl:otherwise>
						</xsl:choose>
					</xsl:if>
					<xsl:if test="$namespace = 'gb' or $namespace = 'iso' or $namespace = 'iec' or $namespace = 'itu' or $namespace = 'unece' or $namespace = 'unece-rec' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'ogc-white-paper' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'm3d' or $namespace = 'iho' or $namespace = 'bipm' or $namespace = 'jcgm'">
						<xsl:text>[</xsl:text>
					</xsl:if>
					<xsl:copy-of select="$termsource_text"/>
					<xsl:if test="$namespace = 'bsi'">
						<xsl:choose>
							<xsl:when test="$document_type = 'PAS' and starts-with(mn:origin/@citeas, '[')"><xsl:text>}</xsl:text></xsl:when>
							<xsl:otherwise><xsl:text>]</xsl:text></xsl:otherwise>
						</xsl:choose>
					</xsl:if>
					<xsl:if test="$namespace = 'gb' or $namespace = 'iso' or $namespace = 'iec' or $namespace = 'itu' or $namespace = 'unece' or $namespace = 'unece-rec' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'ogc-white-paper' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'm3d' or $namespace = 'iho' or $namespace = 'bipm' or $namespace = 'jcgm'">
						<xsl:text>]</xsl:text>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose> -->
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:fmt-termsource/text()[starts-with(., '[SOURCE: Adapted from: ') or     starts-with(., '[SOURCE: Quoted from: ') or     starts-with(., '[SOURCE: Modified from: ')]" priority="2">
		<xsl:text>[</xsl:text><xsl:value-of select="substring-after(., '[SOURCE: ')"/>
	</xsl:template>

	<xsl:template match="mn:fmt-termsource/text()">
		<xsl:if test="normalize-space() != ''">
			<xsl:value-of select="."/>
		</xsl:if>
	</xsl:template>

	<!-- text SOURCE: -->
	<xsl:template match="mn:fmt-termsource/mn:strong[1][following-sibling::*[1][self::mn:fmt-origin]]/text()">
		<fo:inline xsl:use-attribute-sets="termsource-text-style">
			<xsl:call-template name="refine_termsource-text-style"/>
			<xsl:value-of select="."/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="mn:fmt-origin">
		<xsl:call-template name="insert_basic_link">
			<xsl:with-param name="element">
				<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
					<xsl:if test="normalize-space(@citeas) = ''">
						<xsl:attribute name="fox:alt-text"><xsl:value-of select="@bibitemid"/></xsl:attribute>
					</xsl:if>
					<fo:inline xsl:use-attribute-sets="origin-style">
						<xsl:call-template name="refine_origin-style"/>
						<xsl:apply-templates/>
					</fo:inline>
				</fo:basic-link>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- not using, see https://github.com/glossarist/iev-document/issues/23 -->
	<xsl:template match="mn:modification">
		<xsl:variable name="title-modified">
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">modified</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="text"><xsl:apply-templates/></xsl:variable>
		<xsl:choose>
			<xsl:when test="$lang = 'zh'"><xsl:text>、</xsl:text><xsl:value-of select="$title-modified"/><xsl:if test="normalize-space($text) != ''"><xsl:text>—</xsl:text></xsl:if></xsl:when>
			<xsl:otherwise><xsl:text>, </xsl:text><xsl:value-of select="$title-modified"/><xsl:if test="normalize-space($text) != ''"><xsl:text> — </xsl:text></xsl:if></xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="mn:modification/mn:p">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>

	<xsl:template match="mn:modification/text()">
		<xsl:if test="normalize-space() != ''">
			<!-- <xsl:value-of select="."/> -->
			<xsl:call-template name="text"/>
		</xsl:if>
	</xsl:template>

	<!-- ====== -->
	<!-- ====== -->

	<!-- Preferred, admitted, deprecated -->
	<xsl:template match="mn:fmt-preferred">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<xsl:variable name="font-size">inherit
		</xsl:variable>
		<xsl:variable name="levelTerm">
			<xsl:call-template name="getLevelTermName"/>
		</xsl:variable>
		<fo:block font-size="{normalize-space($font-size)}" role="H{$levelTerm}" xsl:use-attribute-sets="preferred-block-style">

			<xsl:call-template name="refine_preferred-block-style"/>

			<xsl:if test="parent::mn:term and not(preceding-sibling::mn:fmt-preferred)"> <!-- if first preffered in term, then display term's name -->

				<fo:block xsl:use-attribute-sets="term-name-style" role="SKIP">
					<xsl:call-template name="refine_term-name-style"/>

					<xsl:for-each select="ancestor::mn:term[1]/mn:fmt-name"><!-- change context -->
						<xsl:call-template name="setIDforNamedDestination"/>
					</xsl:for-each>

					<xsl:apply-templates select="ancestor::mn:term[1]/mn:fmt-name"/>
				</fo:block>
			</xsl:if>

			<fo:block xsl:use-attribute-sets="preferred-term-style" role="SKIP">
				<xsl:call-template name="refine_preferred-term-style"/>

				<xsl:apply-templates/>
			</fo:block>
		</fo:block>
	</xsl:template>

	<!-- <xsl:template match="mn:domain"> -->
		<!-- https://github.com/metanorma/isodoc/issues/607 
		<fo:inline xsl:use-attribute-sets="domain-style">&lt;<xsl:apply-templates/>&gt;</fo:inline>
		<xsl:text> </xsl:text> -->
		<!-- <xsl:if test="not(@hidden = 'true')">
			<xsl:apply-templates/>
		</xsl:if>
	</xsl:template> -->

	<!-- https://github.com/metanorma/isodoc/issues/632#issuecomment-2567163931 -->
	<xsl:template match="mn:domain"/>

	<xsl:template match="mn:fmt-admitted">
		<fo:block xsl:use-attribute-sets="admitted-style">
			<xsl:call-template name="refine_admitted-style"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:fmt-deprecates">
		<fo:block xsl:use-attribute-sets="deprecates-style">
			<xsl:call-template name="refine_deprecates-style"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- regarding ISO 10241-1:2011,  If there is more than one preferred term, each preferred term follows the previous one on a new line. -->
	<!-- in metanorma xml preferred terms delimited by semicolons -->
	<xsl:template match="mn:fmt-preferred/text()[contains(., ';')] | mn:fmt-preferred/mn:strong/text()[contains(., ';')]">
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.), ';', $linebreak)"/>
	</xsl:template>
	<!--  End Preferred, admitted, deprecated -->

	<xsl:template match="mn:fmt-related">
		<fo:block role="SKIP" xsl:use-attribute-sets="related-block-style">
			<xsl:call-template name="refine_related-block-style"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<xsl:template match="mn:fmt-related/mn:p" priority="4">
		<fo:block>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- ========== -->
	<!-- definition -->
	<!-- ========== -->
	<xsl:template match="mn:fmt-definition">
		<fo:block xsl:use-attribute-sets="definition-style" role="SKIP">
			<xsl:call-template name="refine_definition-style"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:fmt-definition[preceding-sibling::mn:domain]">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="mn:fmt-definition[preceding-sibling::mn:domain]/mn:p[1]">
		<fo:inline> <xsl:apply-templates/></fo:inline>
		<fo:block/>
	</xsl:template>
	<!-- ========== -->
	<!-- END definition -->
	<!-- ========== -->

	<xsl:template match="mn:definitions">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:attribute-set name="termexample-style">
		<xsl:attribute name="font-size">10pt</xsl:attribute>
		<xsl:attribute name="margin-top">8pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		<xsl:attribute name="text-align">justify</xsl:attribute>
	</xsl:attribute-set> <!-- termexample-style -->

	<xsl:template name="refine_termexample-style">
	</xsl:template> <!-- refine_termexample-style -->

	<xsl:attribute-set name="termexample-name-style">
		<xsl:attribute name="padding-right">5mm</xsl:attribute>
	</xsl:attribute-set> <!-- termexample-name-style -->

	<xsl:template name="refine_termexample-name-style">
	</xsl:template>

	<xsl:attribute-set name="example-style">
		<!-- <xsl:attribute name="font-size">11pt</xsl:attribute> -->
		<xsl:attribute name="margin-top">4pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		<xsl:attribute name="text-align">justify</xsl:attribute>
	</xsl:attribute-set> <!-- example-style -->

	<xsl:template name="refine_example-style">
	</xsl:template> <!-- refine_example-style -->

	<xsl:attribute-set name="example-body-style">
	</xsl:attribute-set> <!-- example-body-style -->

	<xsl:template name="refine_example-body-style">
	</xsl:template>

	<xsl:attribute-set name="example-name-style">
		<!-- <xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute> -->
	</xsl:attribute-set> <!-- example-name-style -->

	<xsl:template name="refine_example-name-style">
	</xsl:template>

	<xsl:attribute-set name="example-p-style">
		<!-- <xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="margin-left">12.7mm</xsl:attribute> -->
		<xsl:attribute name="space-before">2pt</xsl:attribute>

	</xsl:attribute-set> <!-- example-p-style -->

	<xsl:template name="refine_example-p-style">
	</xsl:template> <!-- refine_example-p-style -->

	<!-- ====== -->
	<!-- termexample -->
	<!-- ====== -->
	<xsl:template match="mn:termexample">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}" xsl:use-attribute-sets="termexample-style">
			<xsl:call-template name="refine_termexample-style"/>
			<xsl:call-template name="setBlockSpanAll"/>

			<xsl:apply-templates select="mn:fmt-name"/>
			<xsl:apply-templates select="node()[not(self::mn:fmt-name)]"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:termexample/mn:fmt-name">
		<xsl:if test="normalize-space() != ''">
			<fo:inline xsl:use-attribute-sets="termexample-name-style">
				<xsl:call-template name="refine_termexample-name-style"/>
				<xsl:apply-templates/> <!-- commented $namespace = 'ieee', https://github.com/metanorma/isodoc/issues/614-->
			</fo:inline>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:termexample/mn:p">
		<xsl:variable name="element">inline

		</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($element, 'block')">
				<fo:block xsl:use-attribute-sets="example-p-style">

					<xsl:call-template name="refine_example-p-style"/>

					<xsl:apply-templates/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline><xsl:apply-templates/></fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ====== -->
	<!-- ====== -->

	<!-- ====== -->
	<!-- example -->
	<!-- ====== -->

	<!-- There are a few cases:
	1. EXAMPLE text
	2. EXAMPLE
	        text
	3. EXAMPLE text line 1
	     text line 2
	4. EXAMPLE
	     text line 1
			 text line 2
	-->
	<xsl:template match="mn:example" name="example">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block-container id="{@id}" xsl:use-attribute-sets="example-style" role="SKIP">

			<xsl:call-template name="setBlockSpanAll"/>

			<xsl:call-template name="refine_example-style"/>

			<xsl:variable name="fo_element">
				<xsl:if test=".//mn:table or .//mn:dl or *[not(self::mn:fmt-name)][1][self::mn:sourcecode]">block</xsl:if>inline
			</xsl:variable>

			<fo:block-container margin-left="0mm" role="SKIP">

				<xsl:choose>

					<xsl:when test="contains(normalize-space($fo_element), 'block')">

						<!-- display name 'EXAMPLE' in a separate block  -->
						<fo:block>
							<xsl:apply-templates select="mn:fmt-name">
								<xsl:with-param name="fo_element" select="$fo_element"/>
							</xsl:apply-templates>
						</fo:block>

						<fo:block-container xsl:use-attribute-sets="example-body-style" role="SKIP">
							<xsl:call-template name="refine_example-body-style"/>
							<fo:block-container margin-left="0mm" margin-right="0mm" role="SKIP">
								<xsl:variable name="example_body">
									<xsl:apply-templates select="node()[not(self::mn:fmt-name)]">
										<xsl:with-param name="fo_element" select="$fo_element"/>
									</xsl:apply-templates>
								</xsl:variable>
								<xsl:choose>
									<xsl:when test="xalan:nodeset($example_body)/*">
										<xsl:copy-of select="$example_body"/>
									</xsl:when>
									<xsl:otherwise><fo:block/><!-- prevent empty block-container --></xsl:otherwise>
								</xsl:choose>
							</fo:block-container>
						</fo:block-container>
					</xsl:when> <!-- end block -->

					<xsl:when test="contains(normalize-space($fo_element), 'list')">

						<xsl:variable name="provisional_distance_between_starts_">7
						</xsl:variable>
						<xsl:variable name="provisional_distance_between_starts" select="normalize-space($provisional_distance_between_starts_)"/>
						<xsl:variable name="indent_">0
						</xsl:variable>
						<xsl:variable name="indent" select="normalize-space($indent_)"/>

						<fo:list-block provisional-distance-between-starts="{$provisional_distance_between_starts}mm">
							<fo:list-item>
								<fo:list-item-label start-indent="{$indent}mm" end-indent="label-end()">
									<fo:block>
										<xsl:apply-templates select="mn:fmt-name">
											<xsl:with-param name="fo_element">block</xsl:with-param>
										</xsl:apply-templates>
									</fo:block>
								</fo:list-item-label>
								<fo:list-item-body start-indent="body-start()">
									<fo:block>
										<xsl:apply-templates select="node()[not(self::mn:fmt-name)]">
											<xsl:with-param name="fo_element" select="$fo_element"/>
										</xsl:apply-templates>
									</fo:block>
								</fo:list-item-body>
							</fo:list-item>
						</fo:list-block>
					</xsl:when> <!-- end list -->

					<xsl:otherwise> <!-- inline -->

						<!-- display 'EXAMPLE' and first element in the same line -->
						<fo:block>
							<xsl:apply-templates select="mn:fmt-name">
								<xsl:with-param name="fo_element" select="$fo_element"/>
							</xsl:apply-templates>
							<fo:inline>
								<xsl:apply-templates select="*[not(self::mn:fmt-name)][1]">
									<xsl:with-param name="fo_element" select="$fo_element"/>
								</xsl:apply-templates>
							</fo:inline>
						</fo:block>

						<xsl:if test="*[not(self::mn:fmt-name)][position() &gt; 1]">
							<!-- display further elements in blocks -->
							<fo:block-container xsl:use-attribute-sets="example-body-style" role="SKIP">
								<xsl:call-template name="refine_example-body-style"/>
								<fo:block-container margin-left="0mm" margin-right="0mm" role="SKIP">
									<xsl:apply-templates select="*[not(self::mn:fmt-name)][position() &gt; 1]">
										<xsl:with-param name="fo_element" select="'block'"/>
									</xsl:apply-templates>
								</fo:block-container>
							</fo:block-container>
						</xsl:if>
					</xsl:otherwise> <!-- end inline -->

				</xsl:choose>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>

	<!-- example/name -->
	<xsl:template match="mn:example/mn:fmt-name">
		<xsl:param name="fo_element">block</xsl:param>

		<xsl:choose>
			<xsl:when test="ancestor::mn:appendix">
				<fo:inline>
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:when>
			<xsl:when test="contains(normalize-space($fo_element), 'block')">
				<fo:block xsl:use-attribute-sets="example-name-style">
					<xsl:apply-templates/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline xsl:use-attribute-sets="example-name-style">
					<xsl:call-template name="refine_example-name-style"/>
					<xsl:apply-templates/>:  <!-- $namespace = 'ieee', see https://github.com/metanorma/isodoc/issues/614  -->
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<!-- table/example/name, table/tfoot//example/name -->
	<xsl:template match="mn:table/mn:example/mn:fmt-name |  mn:table/mn:tfoot//mn:example/mn:fmt-name">
		<fo:inline xsl:use-attribute-sets="example-name-style">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="mn:example/mn:p">
		<xsl:param name="fo_element">block</xsl:param>

		<xsl:variable name="num"><xsl:number/></xsl:variable>
		<xsl:variable name="element">
			<xsl:value-of select="$fo_element"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="starts-with(normalize-space($element), 'block')">
				<fo:block-container role="SKIP">
					<xsl:if test="ancestor::mn:li and contains(normalize-space($fo_element), 'block')">
						<xsl:attribute name="margin-left">0mm</xsl:attribute>
						<xsl:attribute name="margin-right">0mm</xsl:attribute>
					</xsl:if>
					<fo:block xsl:use-attribute-sets="example-p-style">

						<xsl:call-template name="refine_example-p-style"/>

						<xsl:apply-templates/>
					</fo:block>
				</fo:block-container>
			</xsl:when>
			<xsl:when test="starts-with(normalize-space($element), 'list')">
				<fo:block xsl:use-attribute-sets="example-p-style">
					<xsl:apply-templates/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline xsl:use-attribute-sets="example-p-style">
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- example/p -->

	<!-- ====== -->
	<!-- ====== -->

	<!-- ========================== -->
	<!-- Table styles -->
	<!-- ========================== -->
	<xsl:variable name="table-border_">0.5pt solid black
	</xsl:variable>
	<xsl:variable name="table-border" select="normalize-space($table-border_)"/>

	<xsl:variable name="table-cell-border_">
	</xsl:variable>
	<xsl:variable name="table-cell-border" select="normalize-space($table-cell-border_)"/>

	<xsl:attribute-set name="table-container-style">
		<xsl:attribute name="margin-left">0mm</xsl:attribute>
		<xsl:attribute name="margin-right">0mm</xsl:attribute>
		<xsl:attribute name="font-size">9pt</xsl:attribute>
		<xsl:attribute name="space-after">18pt</xsl:attribute>
	</xsl:attribute-set> <!-- table-container-style -->

	<xsl:template name="refine_table-container-style">
		<xsl:param name="margin-side"/>
		<xsl:if test="contains(translate(@style, ' ', ''), 'border:none')">
			<xsl:attribute name="font-size">inherit</xsl:attribute>
		</xsl:if>
		<!-- end table block-container attributes -->
	</xsl:template> <!-- refine_table-container-style -->

	<xsl:attribute-set name="table-style">
		<xsl:attribute name="table-omit-footer-at-break">true</xsl:attribute>
		<xsl:attribute name="table-layout">fixed</xsl:attribute>
		<xsl:attribute name="border"><xsl:value-of select="$table-border"/></xsl:attribute>
	</xsl:attribute-set><!-- table-style -->

	<xsl:template name="refine_table-style">
		<xsl:param name="margin-side"/>

		<xsl:call-template name="setBordersTableArray"/>
	</xsl:template> <!-- refine_table-style -->

	<xsl:attribute-set name="table-name-style">
		<xsl:attribute name="role">Caption</xsl:attribute>
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="font-size">10pt</xsl:attribute>
	</xsl:attribute-set> <!-- table-name-style -->

	<xsl:template name="refine_table-name-style">
		<xsl:param name="continued"/>
		<xsl:if test="$continued = 'true'">
			<xsl:attribute name="role">SKIP</xsl:attribute>
		</xsl:if>
	</xsl:template> <!-- refine_table-name-style -->

	<xsl:attribute-set name="table-row-style">
		<xsl:attribute name="min-height">4mm</xsl:attribute>
		<xsl:attribute name="min-height">3mm</xsl:attribute> <!-- + padding-top + padding-bottom -->
	</xsl:attribute-set>

	<xsl:attribute-set name="table-header-row-style" use-attribute-sets="table-row-style">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="background-color">rgb(217, 217, 217)</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_table-header-row-style">

		<xsl:call-template name="setBordersTableArray"/>
	</xsl:template> <!-- refine_table-header-row-style -->

	<xsl:attribute-set name="table-footer-row-style" use-attribute-sets="table-row-style">
	</xsl:attribute-set>

	<xsl:template name="refine_table-footer-row-style">
	</xsl:template> <!-- refine_table-footer-row-style -->

	<xsl:attribute-set name="table-body-row-style" use-attribute-sets="table-row-style">

	</xsl:attribute-set>

	<xsl:template name="refine_table-body-row-style">

		<xsl:call-template name="setBordersTableArray"/>
	</xsl:template> <!-- refine_table-body-row-style -->

	<xsl:attribute-set name="table-header-cell-style">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="padding-left">1mm</xsl:attribute>
		<xsl:attribute name="padding-right">1mm</xsl:attribute>
		<xsl:attribute name="display-align">center</xsl:attribute>
		<xsl:attribute name="padding-top">1.5mm</xsl:attribute>
		<xsl:attribute name="padding-left">2mm</xsl:attribute>
		<xsl:attribute name="padding-bottom">1.5mm</xsl:attribute>
		<xsl:attribute name="padding-right">1.5mm</xsl:attribute>
		<xsl:attribute name="border"><xsl:value-of select="$table-border"/></xsl:attribute>
	</xsl:attribute-set> <!-- table-header-cell-style -->

	<xsl:template name="refine_table-header-cell-style">

		<xsl:call-template name="setBordersTableArray"/>

		<xsl:if test="$lang = 'ar'">
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
		</xsl:if>

		<xsl:call-template name="setTableCellAttributes"/>
	</xsl:template> <!-- refine_table-header-cell-style -->

	<xsl:attribute-set name="table-cell-style">
		<xsl:attribute name="display-align">center</xsl:attribute>
		<xsl:attribute name="padding-left">1mm</xsl:attribute>
		<xsl:attribute name="padding-right">1mm</xsl:attribute>
		<xsl:attribute name="padding-top">1.5mm</xsl:attribute>
		<xsl:attribute name="padding-left">2mm</xsl:attribute>
		<xsl:attribute name="padding-bottom">1.5mm</xsl:attribute>
		<xsl:attribute name="padding-right">1.5mm</xsl:attribute>
		<xsl:attribute name="border"><xsl:value-of select="$table-border"/></xsl:attribute>
	</xsl:attribute-set> <!-- table-cell-style -->

	<xsl:template name="refine_table-cell-style">

		<xsl:if test="$lang = 'ar'">
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="contains(translate(ancestor::mn:table/@style, ' ', ''), 'border:none')">
			<xsl:attribute name="padding-left">0mm</xsl:attribute>
		</xsl:if>

		<xsl:call-template name="setBordersTableArray"/>

	</xsl:template> <!-- refine_table-cell-style -->

	<xsl:attribute-set name="table-footer-cell-style">
		<xsl:attribute name="border">solid black 1pt</xsl:attribute>
		<xsl:attribute name="padding-left">1mm</xsl:attribute>
		<xsl:attribute name="padding-right">1mm</xsl:attribute>
		<xsl:attribute name="padding-top">1mm</xsl:attribute>
		<xsl:attribute name="border"><xsl:value-of select="$table-border"/></xsl:attribute>
	</xsl:attribute-set> <!-- table-footer-cell-style -->

	<xsl:template name="refine_table-footer-cell-style">
	</xsl:template> <!-- refine_table-footer-cell-style -->

	<xsl:attribute-set name="table-note-style">
		<xsl:attribute name="font-size">10pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:attribute name="font-size">inherit</xsl:attribute>
		<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
		<xsl:attribute name="space-after">6pt</xsl:attribute>
	</xsl:attribute-set><!-- table-note-style -->

	<xsl:template name="refine_table-note-style">
	</xsl:template> <!-- refine_table-note-style -->

	<xsl:attribute-set name="table-fn-style">
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
	</xsl:attribute-set> <!-- table-fn-style -->

	<xsl:template name="refine_table-fn-style">
	</xsl:template>

	<xsl:attribute-set name="table-fn-number-style">
		<!-- <xsl:attribute name="padding-right">5mm</xsl:attribute> -->
	</xsl:attribute-set> <!-- table-fn-number-style -->

	<xsl:template name="refine_table-fn-number-style">
	</xsl:template>

	<xsl:attribute-set name="table-fmt-fn-label-style">
		<xsl:attribute name="font-size">80%</xsl:attribute>
		<xsl:attribute name="vertical-align">super</xsl:attribute>
	</xsl:attribute-set> <!-- table-fmt-fn-label-style -->

	<xsl:template name="refine_table-fmt-fn-label-style">
	</xsl:template>

	<xsl:attribute-set name="table-fn-body-style">
	</xsl:attribute-set>

	<xsl:template name="refine_table-fn-body-style">
	</xsl:template>

	<!-- ========================== -->
	<!-- END Table styles -->
	<!-- ========================== -->

	<xsl:template match="*[local-name()='table']" priority="2">
		<xsl:choose>
			<xsl:when test="$table_only_with_id != '' and @id = $table_only_with_id">
				<xsl:call-template name="table"/>
			</xsl:when>
			<xsl:when test="$table_only_with_id != ''"><fo:block/><!-- to prevent empty fo:block-container --></xsl:when>
			<xsl:when test="$table_only_with_ids != '' and contains($table_only_with_ids, concat(@id, ' '))">
				<xsl:call-template name="table"/>
			</xsl:when>
			<xsl:when test="$table_only_with_ids != ''"><fo:block/><!-- to prevent empty fo:block-container --></xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="table"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*[local-name()='table']" name="table">

		<xsl:variable name="table-preamble">
		</xsl:variable>

		<xsl:variable name="table">

			<xsl:variable name="simple-table">
				<xsl:if test="$isGenerateTableIF = 'true' and $isApplyAutolayoutAlgorithm = 'true'">
					<xsl:call-template name="getSimpleTable">
						<xsl:with-param name="id" select="@id"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:variable>

			<xsl:if test="$debug = 'true' and normalize-space($simple-table) != ''">
				<!-- <redirect:write file="simple-table_{@id}.xml">
					<xsl:copy-of select="$simple-table"/>
				</redirect:write> -->
			</xsl:if>
			<!-- <xsl:variable name="simple-table" select="xalan:nodeset($simple-table_)"/> -->

			<!-- simple-table=<xsl:copy-of select="$simple-table"/> -->

			<!-- Display table's name before table as standalone block -->
			<!-- $namespace = 'iso' or  -->
			<xsl:apply-templates select="mn:fmt-name"/> <!-- table's title rendered before table -->
			<xsl:call-template name="table_name_fn_display"/>

			<xsl:variable name="cols-count" select="count(xalan:nodeset($simple-table)/*/mn:tr[1]/mn:td)"/>

			<xsl:variable name="colwidths">
				<xsl:if test="not(mn:colgroup/mn:col) and not(@class = 'dl')">
					<xsl:call-template name="calculate-column-widths">
						<xsl:with-param name="cols-count" select="$cols-count"/>
						<xsl:with-param name="table" select="$simple-table"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:variable>
			<!-- <xsl:variable name="colwidths" select="xalan:nodeset($colwidths_)"/> -->

			<!-- DEBUG -->
			<xsl:if test="$table_if_debug = 'true'">
				<fo:block font-size="60%">
					<xsl:apply-templates select="xalan:nodeset($colwidths)" mode="print_as_xml"/>
				</fo:block>
			</xsl:if>

			<!-- <xsl:copy-of select="$colwidths"/> -->

			<!-- <xsl:text disable-output-escaping="yes">&lt;!- -</xsl:text>
			DEBUG
			colwidths=<xsl:copy-of select="$colwidths"/>
		<xsl:text disable-output-escaping="yes">- -&gt;</xsl:text> -->

			<xsl:variable name="margin-side">
				<xsl:choose>
					<xsl:when test="$isApplyAutolayoutAlgorithm = 'true'">0</xsl:when>
					<xsl:when test="$isApplyAutolayoutAlgorithm = 'skip'">0</xsl:when>
					<xsl:when test="sum(xalan:nodeset($colwidths)//column) &gt; 75">15</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:call-template name="setNamedDestination"/>

			<fo:block-container xsl:use-attribute-sets="table-container-style" role="SKIP">

				<xsl:for-each select="mn:fmt-name">
					<xsl:call-template name="setIDforNamedDestination"/>
				</xsl:for-each>

				<xsl:call-template name="refine_table-container-style">
					<xsl:with-param name="margin-side" select="$margin-side"/>
				</xsl:call-template>

				<!-- display table's name before table for PAS inside block-container (2-columnn layout) -->

				<xsl:variable name="table_width_default">100%</xsl:variable>
				<xsl:variable name="table_width">
					<!-- for centered table always 100% (@width will be set for middle/second cell of outer table) --><xsl:value-of select="$table_width_default"/>
				</xsl:variable>

				<xsl:variable name="table_attributes">

					<xsl:element name="table_attributes" use-attribute-sets="table-style">

						<xsl:if test="$margin-side != 0">
							<xsl:attribute name="margin-left">0mm</xsl:attribute>
							<xsl:attribute name="margin-right">0mm</xsl:attribute>
						</xsl:if>

						<xsl:attribute name="width"><xsl:value-of select="normalize-space($table_width)"/></xsl:attribute>

						<xsl:call-template name="refine_table-style">
							<xsl:with-param name="margin-side" select="$margin-side"/>
						</xsl:call-template>

						<xsl:call-template name="setTableStyles">
							<xsl:with-param name="scope">table</xsl:with-param>
						</xsl:call-template>

					</xsl:element>
				</xsl:variable>

				<xsl:if test="$isGenerateTableIF = 'true'">
					<!-- to determine start of table -->
					<fo:block id="{concat('table_if_start_',@id)}" keep-with-next="always" font-size="1pt">Start table '<xsl:value-of select="@id"/>'.</fo:block>
				</xsl:if>

				<fo:table id="{@id}">

					<xsl:if test="$isGenerateTableIF = 'true'">
						<xsl:attribute name="wrap-option">no-wrap</xsl:attribute>
					</xsl:if>

					<xsl:for-each select="xalan:nodeset($table_attributes)/table_attributes/@*">
						<xsl:attribute name="{local-name()}">
							<xsl:value-of select="."/>
						</xsl:attribute>
					</xsl:for-each>

					<xsl:variable name="isNoteOrFnExist" select="./mn:note[not(@type = 'units')] or ./mn:example or .//mn:fn[not(parent::mn:fmt-name)] or ./mn:fmt-source"/>
					<xsl:if test="$isNoteOrFnExist = 'true'">
						<!-- <xsl:choose>
							<xsl:when test="$namespace = 'plateau'"></xsl:when>
							<xsl:otherwise>
								
							</xsl:otherwise>
						</xsl:choose> -->
						<xsl:attribute name="border-bottom">0pt solid black</xsl:attribute><!-- set 0pt border, because there is a separete table below for footer -->
					</xsl:if>

					<xsl:choose>
						<xsl:when test="$isGenerateTableIF = 'true'">
							<!-- generate IF for table widths -->
							<!-- example:
								<tr>
									<td valign="top" align="left" id="tab-symdu_1_1">
										<p>Symbol</p>
										<word id="tab-symdu_1_1_word_1">Symbol</word>
									</td>
									<td valign="top" align="left" id="tab-symdu_1_2">
										<p>Description</p>
										<word id="tab-symdu_1_2_word_1">Description</word>
									</td>
								</tr>
							-->
							<!-- <debug-simple-table><xsl:copy-of select="$simple-table"/></debug-simple-table> -->

							<xsl:apply-templates select="xalan:nodeset($simple-table)" mode="process_table-if"/>

						</xsl:when>
						<xsl:otherwise>

							<xsl:choose>
								<xsl:when test="mn:colgroup/mn:col">
									<xsl:for-each select="mn:colgroup/mn:col">
										<fo:table-column column-width="{@width}"/>
									</xsl:for-each>
								</xsl:when>
								<xsl:when test="@class = 'dl'">
									<xsl:for-each select=".//*[local-name()='tr'][1]/*">
										<fo:table-column column-width="{@width}"/>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="insertTableColumnWidth">
										<xsl:with-param name="colwidths" select="$colwidths"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>

							<xsl:choose>
								<xsl:when test="not(*[local-name()='tbody']) and *[local-name()='thead']">
									<xsl:apply-templates select="*[local-name()='thead']" mode="process_tbody"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:apply-templates select="node()[not(self::mn:fmt-name) and not(self::mn:note) and not(self::mn:example) and not(self::mn:dl) and not(self::mn:fmt-source) and not(self::mn:p)          and not(self::mn:thead) and not(self::mn:tfoot) and not(self::mn:fmt-footnote-container)]"/> <!-- process all table' elements, except name, header, footer, note, source and dl which render separaterely -->
								</xsl:otherwise>
							</xsl:choose>

						</xsl:otherwise>
					</xsl:choose>

				</fo:table>

				<xsl:variable name="colgroup" select="mn:colgroup"/>

				<!-- https://github.com/metanorma/metanorma-plateau/issues/171 -->

				<xsl:for-each select="*[local-name()='tbody']"><!-- select context to tbody -->
					<xsl:call-template name="insertTableFooterInSeparateTable">
						<xsl:with-param name="table_attributes" select="$table_attributes"/>
						<xsl:with-param name="colwidths" select="$colwidths"/>
						<xsl:with-param name="colgroup" select="$colgroup"/>
					</xsl:call-template>
				</xsl:for-each>

				<!-- https://github.com/metanorma/metanorma-plateau/issues/171
				<xsl:if test="$namespace = 'plateau'">
					<xsl:apply-templates select="*[not(local-name()='thead') and not(local-name()='tbody') and not(local-name()='tfoot') and not(local-name()='name')]" />
					<xsl:for-each select="*[local-name()='tbody']"> - select context to tbody -
						<xsl:variable name="table_fn_block">
							<xsl:call-template name="table_fn_display" />
						</xsl:variable>
						<xsl:copy-of select="$table_fn_block"/>
					</xsl:for-each>
				</xsl:if> -->

				<xsl:if test="*[local-name()='bookmark']"> <!-- special case: table/bookmark -->
					<fo:block keep-with-previous="always" line-height="0.1">
						<xsl:for-each select="*[local-name()='bookmark']">
							<xsl:call-template name="bookmark"/>
						</xsl:for-each>
					</fo:block>
				</xsl:if>

			</fo:block-container>
		</xsl:variable> <!-- END: variable name="table" -->

		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>

		<xsl:choose>
			<xsl:when test="@width and @width != 'full-page-width' and @width != 'text-width'">

				<!-- centered table when table name is centered (see table-name-style) -->
				<fo:table table-layout="fixed" width="100%" xsl:use-attribute-sets="table-container-style" role="SKIP">
					<fo:table-column column-width="proportional-column-width(1)"/>
					<fo:table-column column-width="{@width}"/>
					<fo:table-column column-width="proportional-column-width(1)"/>
					<fo:table-body role="SKIP">
						<fo:table-row role="SKIP">
							<fo:table-cell column-number="2" role="SKIP">
								<xsl:copy-of select="$table-preamble"/>
								<fo:block role="SKIP">
									<xsl:call-template name="setTrackChangesStyles">
										<xsl:with-param name="isAdded" select="$isAdded"/>
										<xsl:with-param name="isDeleted" select="$isDeleted"/>
									</xsl:call-template>
									<xsl:copy-of select="$table"/>
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>

			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$isAdded = 'true' or $isDeleted = 'true'">
						<xsl:copy-of select="$table-preamble"/>
						<fo:block>
							<xsl:call-template name="setTrackChangesStyles">
								<xsl:with-param name="isAdded" select="$isAdded"/>
								<xsl:with-param name="isDeleted" select="$isDeleted"/>
							</xsl:call-template>
							<xsl:copy-of select="$table"/>
						</fo:block>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$table-preamble"/>
						<xsl:copy-of select="$table"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<xsl:template name="setBordersTableArray">
	</xsl:template>

	<!-- table/name-->
	<xsl:template match="*[local-name()='table']/mn:fmt-name">
		<xsl:param name="continued"/>
		<xsl:param name="cols-count"/>
		<xsl:if test="normalize-space() != ''">

			<fo:block xsl:use-attribute-sets="table-name-style">

				<xsl:call-template name="refine_table-name-style">
					<xsl:with-param name="continued" select="$continued"/>
				</xsl:call-template>

				<xsl:choose>
					<xsl:when test="$continued = 'true'">
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates/>
					</xsl:otherwise>
				</xsl:choose>

			</fo:block>

			<!-- <xsl:if test="$namespace = 'bsi' or $namespace = 'iec' or $namespace = 'iso'"> -->
			<xsl:if test="$continued = 'true'">

				<!-- to prevent the error 'THead element may contain only TR elements' -->

				<xsl:choose>
					<xsl:when test="string(number($cols-count)) != 'NaN'">
						<fo:table width="100%" table-layout="fixed" role="SKIP">
							<fo:table-body role="SKIP">
								<fo:table-row>
									<fo:table-cell role="TH" number-columns-spanned="{$cols-count}">
										<fo:block text-align="right" role="SKIP">
											<xsl:apply-templates select="../mn:note[@type = 'units']/node()"/>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</fo:table-body>
						</fo:table>
					</xsl:when>
					<xsl:otherwise>
						<fo:block text-align="right">
							<xsl:apply-templates select="../mn:note[@type = 'units']/node()"/>
						</fo:block>
					</xsl:otherwise>
				</xsl:choose>

			</xsl:if>
			<!-- </xsl:if> -->

		</xsl:if>
	</xsl:template> <!-- table/name -->

	<!-- workaround solution for https://github.com/metanorma/metanorma-iso/issues/1151#issuecomment-2033087938 -->
	<xsl:template match="*[local-name()='table']/mn:note[@type = 'units']/mn:p/text()" priority="4">
		<xsl:choose>
			<xsl:when test="preceding-sibling::mn:br">
				<!-- remove CR or LF at start -->
				<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),'^(&#13;&#10;|&#13;|&#10;)', '')"/>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- SOURCE: ... -->
	<xsl:template match="*[local-name()='table']/mn:fmt-source" priority="2">
		<xsl:call-template name="termsource"/>
	</xsl:template>

	<xsl:template name="calculate-columns-numbers">
		<xsl:param name="table-row"/>
		<xsl:variable name="columns-count" select="count($table-row/*)"/>
		<xsl:variable name="sum-colspans" select="sum($table-row/*/@colspan)"/>
		<xsl:variable name="columns-with-colspan" select="count($table-row/*[@colspan])"/>
		<xsl:value-of select="$columns-count + $sum-colspans - $columns-with-colspan"/>
	</xsl:template>

	<xsl:template name="calculate-column-widths">
		<xsl:param name="table"/>
		<xsl:param name="cols-count"/>
		<xsl:choose>
			<xsl:when test="$isApplyAutolayoutAlgorithm = 'true'">
				<xsl:call-template name="get-calculated-column-widths-autolayout-algorithm"/>
			</xsl:when>
			<xsl:when test="$isApplyAutolayoutAlgorithm = 'skip'"/>
			<xsl:otherwise>
				<xsl:call-template name="calculate-column-widths-proportional">
					<xsl:with-param name="cols-count" select="$cols-count"/>
					<xsl:with-param name="table" select="$table"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ================================================== -->
	<!-- Calculate column's width based on text string max widths -->
	<!-- ================================================== -->
	<xsl:template name="calculate-column-widths-proportional">
		<xsl:param name="table"/>
		<xsl:param name="cols-count"/>
		<xsl:param name="curr-col" select="1"/>
		<xsl:param name="width" select="0"/>

		<!-- table=<xsl:copy-of select="$table"/> -->

		<xsl:if test="$curr-col &lt;= $cols-count">
			<xsl:variable name="widths">
				<xsl:choose>
					<xsl:when test="not($table)"><!-- this branch is not using in production, for debug only -->
						<xsl:for-each select="*[local-name()='thead']//*[local-name()='tr']">
							<xsl:variable name="words">
								<xsl:call-template name="tokenize">
									<xsl:with-param name="text" select="translate(*[local-name()='th'][$curr-col],'- —:', '    ')"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="max_length">
								<xsl:call-template name="max_length">
									<xsl:with-param name="words" select="xalan:nodeset($words)"/>
								</xsl:call-template>
							</xsl:variable>
							<width>
								<xsl:value-of select="$max_length"/>
							</width>
						</xsl:for-each>
						<xsl:for-each select="*[local-name()='tbody']//*[local-name()='tr']">
							<xsl:variable name="words">
								<xsl:call-template name="tokenize">
									<xsl:with-param name="text" select="translate(*[local-name()='td'][$curr-col],'- —:', '    ')"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="max_length">
								<xsl:call-template name="max_length">
									<xsl:with-param name="words" select="xalan:nodeset($words)"/>
								</xsl:call-template>
							</xsl:variable>
							<width>
								<xsl:value-of select="$max_length"/>
							</width>

						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<!-- <curr_col><xsl:value-of select="$curr-col"/></curr_col> -->

						<!-- <table><xsl:copy-of select="$table"/></table>
						 -->
						<xsl:for-each select="xalan:nodeset($table)/*/*[local-name()='tr']">
							<xsl:variable name="td_text">
								<xsl:apply-templates select="*[local-name()='td'][$curr-col]" mode="td_text"/>
							</xsl:variable>
							<!-- <td_text><xsl:value-of select="$td_text"/></td_text> -->
							<xsl:variable name="words">
								<xsl:variable name="string_with_added_zerospaces">
									<xsl:call-template name="add-zero-spaces-java">
										<xsl:with-param name="text" select="$td_text"/>
									</xsl:call-template>
								</xsl:variable>
								<!-- <xsl:message>string_with_added_zerospaces=<xsl:value-of select="$string_with_added_zerospaces"/></xsl:message> -->
								<xsl:call-template name="tokenize">
									<!-- <xsl:with-param name="text" select="translate(td[$curr-col],'- —:', '    ')"/> -->
									<!-- 2009 thinspace -->
									<!-- <xsl:with-param name="text" select="translate(normalize-space($td_text),'- —:', '    ')"/> -->
									<xsl:with-param name="text" select="normalize-space(translate($string_with_added_zerospaces, '​­', '  '))"/> <!-- replace zero-width-space and soft-hyphen to space -->
								</xsl:call-template>
							</xsl:variable>
							<!-- words=<xsl:copy-of select="$words"/> -->
							<xsl:variable name="max_length">
								<xsl:call-template name="max_length">
									<xsl:with-param name="words" select="xalan:nodeset($words)"/>
								</xsl:call-template>
							</xsl:variable>
							<!-- <xsl:message>max_length=<xsl:value-of select="$max_length"/></xsl:message> -->
							<width>
								<xsl:variable name="divider">
									<xsl:choose>
										<xsl:when test="*[local-name()='td'][$curr-col]/@divide">
											<xsl:value-of select="*[local-name()='td'][$curr-col]/@divide"/>
										</xsl:when>
										<xsl:otherwise>1</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:value-of select="$max_length div $divider"/>
							</width>

						</xsl:for-each>

					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<!-- widths=<xsl:copy-of select="$widths"/> -->

			<column>
				<xsl:for-each select="xalan:nodeset($widths)//width">
					<xsl:sort select="." data-type="number" order="descending"/>
					<xsl:if test="position()=1">
							<xsl:value-of select="."/>
					</xsl:if>
				</xsl:for-each>
			</column>
			<xsl:call-template name="calculate-column-widths-proportional">
				<xsl:with-param name="cols-count" select="$cols-count"/>
				<xsl:with-param name="curr-col" select="$curr-col +1"/>
				<xsl:with-param name="table" select="$table"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template> <!-- calculate-column-widths-proportional -->

	<!-- ================================= -->
	<!-- mode="td_text" -->
	<!-- ================================= -->
	<!-- replace each each char to 'X', just to process the tag 'keep-together_within-line' as whole word in longest word calculation -->
	<xsl:template match="*[@keep-together.within-line or local-name() = 'keep-together_within-line']/text()" priority="2" mode="td_text">
		<!-- <xsl:message>DEBUG t1=<xsl:value-of select="."/></xsl:message>
		<xsl:message>DEBUG t2=<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),'.','X')"/></xsl:message> -->
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),'.','X')"/>

		<!-- if all capitals english letters or digits -->
		<xsl:if test="normalize-space(translate(., concat($upper,'0123456789'), '')) = ''">
			<xsl:call-template name="repeat">
				<xsl:with-param name="char" select="'X'"/>
				<xsl:with-param name="count" select="string-length(normalize-space(.)) * 0.5"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="text()" mode="td_text">
		<xsl:value-of select="translate(., $zero_width_space, ' ')"/><xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="mn:fmt-termsource" mode="td_text">
		<xsl:value-of select="mn:fmt-origin/@citeas"/>
	</xsl:template>

	<xsl:template match="mn:fmt-link" mode="td_text">
		<xsl:value-of select="@target"/>
	</xsl:template>

	<xsl:template match="*[local-name()='math']" mode="td_text" name="math_length">
		<xsl:if test="$isGenerateTableIF = 'false'">
			<xsl:variable name="mathml_">
				<xsl:for-each select="*">
					<xsl:if test="local-name() != 'unit' and local-name() != 'prefix' and local-name() != 'dimension' and local-name() != 'quantity'">
						<xsl:copy-of select="."/>
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="mathml" select="xalan:nodeset($mathml_)"/>

			<xsl:variable name="math_text">
				<xsl:value-of select="normalize-space($mathml)"/>
				<xsl:for-each select="$mathml//@open"><xsl:value-of select="."/></xsl:for-each>
				<xsl:for-each select="$mathml//@close"><xsl:value-of select="."/></xsl:for-each>
			</xsl:variable>
			<xsl:value-of select="translate($math_text, ' ', '#')"/><!-- mathml images as one 'word' without spaces -->
		</xsl:if>
	</xsl:template>
	<!-- ================================= -->
	<!-- END mode="td_text" -->
	<!-- ================================= -->
	<!-- ================================================== -->
	<!-- END Calculate column's width based on text string max widths -->
	<!-- ================================================== -->

	<!-- ================================================== -->
	<!-- Calculate column's width based on HTML4 algorithm -->
	<!-- (https://www.w3.org/TR/REC-html40/appendix/notes.html#h-B.5.2) -->
	<!-- ================================================== -->

	<!-- INPUT: table with columns widths, generated by table_if.xsl  -->
	<xsl:template name="calculate-column-widths-autolayout-algorithm">
		<xsl:param name="parent_table_page-width"/> <!-- for nested tables, in re-calculate step -->

		<!-- via intermediate format -->

		<!-- The algorithm uses two passes through the table data and scales linearly with the size of the table -->

		<!-- In the first pass, line wrapping is disabled, and the user agent keeps track of the minimum and maximum width of each cell. -->

		<!-- Since line wrap has been disabled, paragraphs are treated as long lines unless broken by BR elements. -->

		<xsl:variable name="page_width">
			<xsl:choose>
				<xsl:when test="$parent_table_page-width != ''">
					<xsl:value-of select="$parent_table_page-width"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@page-width"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:if test="$table_if_debug = 'true'">
			<page_width><xsl:value-of select="$page_width"/></page_width>
		</xsl:if>

		<!-- There are three cases: -->
		<xsl:choose>
			<!-- 1. The minimum table width is equal to or wider than the available space -->
			<xsl:when test="@width_min &gt;= $page_width and 1 = 2"> <!-- this condition isn't working see case 3 below -->
				<!-- call old algorithm -->
				<case1/>
				<!-- <xsl:variable name="cols-count" select="count(xalan:nodeset($table)/*/tr[1]/td)"/>
				<xsl:call-template name="calculate-column-widths-proportional">
					<xsl:with-param name="cols-count" select="$cols-count"/>
					<xsl:with-param name="table" select="$table"/>
				</xsl:call-template> -->
			</xsl:when>
			<!-- 2. The maximum table width fits within the available space. In this case, set the columns to their maximum widths. -->
			<xsl:when test="@width_max &lt;= $page_width">
				<case2/>
				<autolayout/>
				<xsl:for-each select="column/@width_max">
					<column divider="100"><xsl:value-of select="."/></column>
				</xsl:for-each>
			</xsl:when>
			<!-- 3. The maximum width of the table is greater than the available space, but the minimum table width is smaller. 
			In this case, find the difference between the available space and the minimum table width, lets call it W. 
			Lets also call D the difference between maximum and minimum width of the table. 
			For each column, let d be the difference between maximum and minimum width of that column. 
			Now set the column's width to the minimum width plus d times W over D. 
			This makes columns with large differences between minimum and maximum widths wider than columns with smaller differences. -->
			<xsl:when test="(@width_max &gt; $page_width and @width_min &lt; $page_width) or (@width_min &gt;= $page_width)">
				<!-- difference between the available space and the minimum table width -->
				<_width_min><xsl:value-of select="@width_min"/></_width_min>
				<xsl:variable name="W" select="$page_width - @width_min"/>
				<W><xsl:value-of select="$W"/></W>
				<!-- difference between maximum and minimum width of the table -->
				<xsl:variable name="D" select="@width_max - @width_min"/>
				<D><xsl:value-of select="$D"/></D>
				<case3/>
				<autolayout/>
				<xsl:if test="@width_min &gt;= $page_width">
					<split_keep-within-line>true</split_keep-within-line>
				</xsl:if>
				<xsl:for-each select="column">
					<!-- difference between maximum and minimum width of that column.  -->
					<xsl:variable name="d" select="@width_max - @width_min"/>
					<d><xsl:value-of select="$d"/></d>
					<width_min><xsl:value-of select="@width_min"/></width_min>
					<e><xsl:value-of select="$d * $W div $D"/></e>
					<!-- set the column's width to the minimum width plus d times W over D.  -->
					<xsl:variable name="column_width_" select="round(@width_min + $d * $W div $D)"/> <!--  * 10 -->
					<xsl:variable name="column_width" select="$column_width_*($column_width_ &gt;= 0) - $column_width_*($column_width_ &lt; 0)"/> <!-- absolute value -->
					<column divider="100">
						<xsl:value-of select="$column_width"/>
					</column>
				</xsl:for-each>

			</xsl:when>
			<xsl:otherwise><unknown_case/></xsl:otherwise>
		</xsl:choose>

	</xsl:template> <!-- calculate-column-widths-autolayout-algorithm -->

	<xsl:template name="get-calculated-column-widths-autolayout-algorithm">

		<!-- if nested 'dl' or 'table' -->
		<xsl:variable name="parent_table_id" select="normalize-space(ancestor::*[local-name() = 'table' or local-name() = 'dl'][1]/@id)"/>
		<parent_table_id><xsl:value-of select="$parent_table_id"/></parent_table_id>

		<parent_element><xsl:value-of select="local-name(..)"/></parent_element>

		<ancestor_tree>
			<xsl:for-each select="ancestor::*">
				<ancestor><xsl:value-of select="local-name()"/></ancestor>
			</xsl:for-each>
		</ancestor_tree>

		<xsl:variable name="parent_table_page-width_">
			<xsl:if test="$parent_table_id != ''">
				<!-- determine column number in the parent table -->
				<xsl:variable name="parent_table_column_number">
					<xsl:choose>
						<!-- <xsl:when test="parent::mn:dd">2</xsl:when> -->
						<xsl:when test="(ancestor::*[local-name() = 'dd' or local-name() = 'table' or local-name() = 'dl'])[last()][local-name() = 'dd' or local-name() = 'dl']">2</xsl:when>
						<xsl:otherwise> <!-- parent is table -->
							<xsl:value-of select="count(ancestor::*[local-name() = 'td'][1]/preceding-sibling::*[local-name() = 'td']) + 1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<!-- find table by id in the file 'table_widths' and get all Nth `<column>...</column> -->

				<xsl:variable name="parent_table_column_" select="$table_widths_from_if_calculated//table[@id = $parent_table_id]/column[number($parent_table_column_number)]"/>
				<xsl:variable name="parent_table_column" select="xalan:nodeset($parent_table_column_)"/>
				<!-- <xsl:variable name="divider">
					<xsl:value-of select="$parent_table_column/@divider"/>
					<xsl:if test="not($parent_table_column/@divider)">1</xsl:if>
				</xsl:variable> -->
				<xsl:value-of select="$parent_table_column/text()"/> <!--  * 10 -->
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="parent_table_page-width" select="normalize-space($parent_table_page-width_)"/>

		<parent_table_page-width><xsl:value-of select="$parent_table_page-width"/></parent_table_page-width>

		<!-- get current table id -->
		<xsl:variable name="table_id" select="@id"/>

		<xsl:choose>
			<xsl:when test="$parent_table_id = '' or $parent_table_page-width = ''">
				<!-- find table by id in the file 'table_widths' and get all `<column>...</column> -->
				<xsl:copy-of select="$table_widths_from_if_calculated//table[@id = $table_id]/node()"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- recalculate columns width based on parent table width -->
				<xsl:for-each select="$table_widths_from_if//table[@id = $table_id]">
					<xsl:call-template name="calculate-column-widths-autolayout-algorithm">
						<xsl:with-param name="parent_table_page-width" select="$parent_table_page-width"/> <!-- padding-left = 2mm  = 50000-->
					</xsl:call-template>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template> <!-- get-calculated-column-widths-autolayout-algorithm -->

	<!-- ================================================== -->
	<!-- END: Calculate column's width based on HTML4 algorithm -->
	<!-- ================================================== -->

	<xsl:template match="mn:thead">
		<xsl:param name="cols-count"/>
		<fo:table-header>
			<xsl:apply-templates/>
		</fo:table-header>
	</xsl:template> <!-- thead -->

	<!-- template is using for iec, iso, jcgm, bsi only -->
	<xsl:template name="table-header-title">
		<xsl:param name="cols-count"/>
		<!-- row for title -->
		<fo:table-row role="SKIP">
			<fo:table-cell number-columns-spanned="{$cols-count}" border-left="1.5pt solid white" border-right="1.5pt solid white" border-top="1.5pt solid white" border-bottom="1.5pt solid black" role="SKIP">

				<xsl:call-template name="refine_table-header-title-style"/>

				<xsl:apply-templates select="ancestor::mn:table/mn:fmt-name">
					<xsl:with-param name="continued">true</xsl:with-param>
					<xsl:with-param name="cols-count" select="$cols-count"/>
				</xsl:apply-templates>

				<xsl:if test="not(ancestor::mn:table/mn:fmt-name)"> <!-- to prevent empty fo:table-cell in case of missing table's name -->
					<fo:block role="SKIP"/>
				</xsl:if>

			</fo:table-cell>
		</fo:table-row>
	</xsl:template> <!-- table-header-title -->

	<xsl:template name="refine_table-header-title-style">
	</xsl:template> <!-- refine_table-header-title-style -->

	<xsl:template match="*[local-name()='thead']" mode="process_tbody">
		<fo:table-body>
			<xsl:apply-templates/>
		</fo:table-body>
	</xsl:template>

	<xsl:template match="mn:tfoot">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template name="insertTableFooter">
		<xsl:param name="cols-count"/>
		<xsl:if test="../mn:tfoot">
			<fo:table-footer>
				<xsl:apply-templates select="../mn:tfoot"/>
			</fo:table-footer>
		</xsl:if>
	</xsl:template>

	<xsl:template name="insertTableFooterInSeparateTable">
		<xsl:param name="table_attributes"/>
		<xsl:param name="colwidths"/>
		<xsl:param name="colgroup"/>

		<xsl:variable name="isNoteOrFnExist" select="../mn:note[not(@type = 'units')] or ../mn:example or ../mn:dl or ..//mn:fn[not(parent::mn:fmt-name)] or ../mn:fmt-source or ../mn:p"/>

		<xsl:variable name="isNoteOrFnExistShowAfterTable">
		</xsl:variable>

		<xsl:if test="$isNoteOrFnExist = 'true' or normalize-space($isNoteOrFnExistShowAfterTable) = 'true'">

			<xsl:variable name="cols-count">
				<xsl:choose>
					<xsl:when test="xalan:nodeset($colgroup)//mn:col">
						<xsl:value-of select="count(xalan:nodeset($colgroup)//mn:col)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="count(xalan:nodeset($colwidths)//column)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="table_fn_block">
				<xsl:call-template name="table_fn_display"/>
			</xsl:variable>

			<xsl:variable name="tableWithNotesAndFootnotes">

				<fo:table keep-with-previous="always" role="SKIP">
					<xsl:for-each select="xalan:nodeset($table_attributes)/table_attributes/@*">
						<xsl:variable name="name" select="local-name()"/>
						<xsl:choose>
							<xsl:when test="$name = 'border-top'">
								<xsl:attribute name="{$name}">0pt solid black</xsl:attribute>
							</xsl:when>
							<xsl:when test="$name = 'border'">
								<xsl:attribute name="{$name}"><xsl:value-of select="."/></xsl:attribute>
								<xsl:attribute name="border-top">0pt solid black</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="{$name}"><xsl:value-of select="."/></xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>

					<xsl:for-each select="ancestor::mn:table[1]">
						<xsl:call-template name="setTableStyles">
							<xsl:with-param name="scope">table</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>

					<xsl:choose>
						<xsl:when test="xalan:nodeset($colgroup)//mn:col">
							<xsl:for-each select="xalan:nodeset($colgroup)//mn:col">
								<fo:table-column column-width="{@width}"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<!-- $colwidths=<xsl:copy-of select="$colwidths"/> -->
							<xsl:call-template name="insertTableColumnWidth">
								<xsl:with-param name="colwidths" select="$colwidths"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>

					<fo:table-body role="SKIP">
						<fo:table-row role="SKIP">
							<xsl:for-each select="ancestor::mn:table[1]">
								<xsl:call-template name="setTableStyles">
									<xsl:with-param name="scope">ancestor_table</xsl:with-param>
								</xsl:call-template>
							</xsl:for-each>

							<fo:table-cell xsl:use-attribute-sets="table-footer-cell-style" number-columns-spanned="{$cols-count}" role="SKIP">

								<xsl:call-template name="refine_table-footer-cell-style"/>

								<xsl:for-each select="ancestor::mn:table[1]">
									<xsl:call-template name="setTableStyles">
										<xsl:with-param name="scope">ancestor_table_borders_only</xsl:with-param>
									</xsl:call-template>
								</xsl:for-each>

								<xsl:call-template name="setBordersTableArray"/>

								<!-- fn will be processed inside 'note' processing -->
								<xsl:apply-templates select="../mn:p"/>
								<xsl:apply-templates select="../mn:dl"/>
								<xsl:apply-templates select="../mn:note[not(@type = 'units')]"/>
								<xsl:apply-templates select="../mn:example"/>
								<xsl:apply-templates select="../mn:fmt-source"/>

								<xsl:variable name="isDisplayRowSeparator">
								</xsl:variable>

								<!-- horizontal row separator -->
								<xsl:if test="normalize-space($isDisplayRowSeparator) = 'true'">
									<xsl:if test="(../mn:note[not(@type = 'units')] or ../mn:example) and normalize-space($table_fn_block) != ''">
										<fo:block-container border-top="0.5pt solid black" padding-left="1mm" padding-right="1mm">
											<xsl:call-template name="setBordersTableArray"/>
											<fo:block font-size="1pt"> </fo:block>
										</fo:block-container>
									</xsl:if>
								</xsl:if>

								<!-- fn processing -->
								<!-- <xsl:call-template name="table_fn_display" /> -->
								<xsl:copy-of select="$table_fn_block"/>

							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>

				</fo:table>
			</xsl:variable>

			<xsl:if test="normalize-space($tableWithNotesAndFootnotes) != ''">
				<xsl:copy-of select="$tableWithNotesAndFootnotes"/>
			</xsl:if>

		</xsl:if>
	</xsl:template> <!-- insertTableFooterInSeparateTable -->

	<xsl:template match="mn:tbody">

		<xsl:variable name="cols-count">
			<xsl:choose>
				<xsl:when test="../mn:thead">
					<xsl:call-template name="calculate-columns-numbers">
						<xsl:with-param name="table-row" select="../mn:thead/mn:tr[1]"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="calculate-columns-numbers">
						<xsl:with-param name="table-row" select="./mn:tr[1]"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:apply-templates select="../mn:thead">
			<xsl:with-param name="cols-count" select="$cols-count"/>
		</xsl:apply-templates>

		<xsl:call-template name="insertTableFooter">
			<xsl:with-param name="cols-count" select="$cols-count"/>
		</xsl:call-template>

		<fo:table-body>

			<xsl:apply-templates/>

		</fo:table-body>

	</xsl:template> <!-- tbody -->

	<!-- ======================================== -->
	<!-- mode="process_table-if"                  -->
	<!-- ======================================== -->
	<xsl:template match="/" mode="process_table-if">
		<xsl:param name="table_or_dl">table</xsl:param>
		<xsl:apply-templates mode="process_table-if">
			<xsl:with-param name="table_or_dl" select="$table_or_dl"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="*[local-name()='tbody']" mode="process_table-if">
		<xsl:param name="table_or_dl">table</xsl:param>

		<fo:table-body>
			<xsl:for-each select="*[local-name() = 'tr']">
				<xsl:variable name="col_count" select="count(*)"/>

				<!-- iteration for each tr/td -->

				<xsl:choose>
					<xsl:when test="$table_or_dl = 'table'">
						<xsl:for-each select="*[local-name() = 'td' or local-name() = 'th']/*">
							<fo:table-row number-columns-spanned="{$col_count}">
								<xsl:copy-of select="../@font-weight"/>
								<!-- <test_table><xsl:copy-of select="."/></test_table> -->
								<xsl:call-template name="td"/>
							</fo:table-row>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise> <!-- $table_or_dl = 'dl' -->
						<xsl:for-each select="*[local-name() = 'td' or local-name() = 'th']">
							<xsl:variable name="is_dt" select="position() = 1"/>

							<xsl:for-each select="*">
								<!-- <test><xsl:copy-of select="."/></test> -->
								<fo:table-row number-columns-spanned="{$col_count}">
									<xsl:choose>
										<xsl:when test="$is_dt">
											<xsl:call-template name="insert_dt_cell"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="insert_dd_cell"/>
										</xsl:otherwise>
									</xsl:choose>
								</fo:table-row>
							</xsl:for-each>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>

			</xsl:for-each>
		</fo:table-body>
	</xsl:template> <!-- process_table-if -->
	<!-- ======================================== -->
	<!-- END: mode="process_table-if"             -->
	<!-- ======================================== -->

	<!-- ===================== -->
	<!-- Table's row processing -->
	<!-- ===================== -->
	<!-- row in table header (thead) thead/tr -->
	<xsl:template match="mn:thead/mn:tr" priority="2">
		<fo:table-row xsl:use-attribute-sets="table-header-row-style">

			<xsl:call-template name="refine_table-header-row-style"/>

			<xsl:call-template name="setTableRowAttributes"/>

			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template>

	<xsl:template name="setBorderUnderRow">
		<xsl:variable name="border_under_row_" select="normalize-space(ancestor::mn:table[1]/@border-under-row)"/>
		<xsl:choose>
			<xsl:when test="$border_under_row_ != ''">
				<xsl:variable name="table_id" select="ancestor::mn:table[1]/@id"/>
				<xsl:variable name="row_num_"><xsl:number level="any" count="mn:table[@id = $table_id]//mn:tr"/></xsl:variable>
				<xsl:variable name="row_num" select="number($row_num_) - 1"/> <!-- because values in border-under-row start with 0 -->
				<xsl:variable name="border_under_row">
					<xsl:call-template name="split">
						<xsl:with-param name="pText" select="$border_under_row_"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="xalan:nodeset($border_under_row)/mnx:item[. = normalize-space($row_num)]">
					<xsl:attribute name="border-bottom"><xsl:value-of select="$table-border"/></xsl:attribute>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="border-bottom"><xsl:value-of select="$table-border"/></xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- row in table footer (tfoot), tfoot/tr -->
	<xsl:template match="mn:tfoot/mn:tr" priority="2">
		<fo:table-row xsl:use-attribute-sets="table-footer-row-style">

			<xsl:call-template name="refine_table-footer-row-style"/>

			<xsl:call-template name="setTableRowAttributes"/>
			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template>

	<!-- row in table's body (tbody) -->
	<xsl:template match="*[local-name()='tr']">
		<fo:table-row xsl:use-attribute-sets="table-body-row-style">

			<xsl:if test="count(*) = count(*[local-name() = 'th'])"> <!-- row contains 'th' only -->
				<xsl:attribute name="keep-with-next">always</xsl:attribute>
			</xsl:if>

			<xsl:call-template name="refine_table-body-row-style"/>

			<xsl:call-template name="setTableRowAttributes"/>

			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template>

	<xsl:template name="setTableRowAttributes">

		<xsl:for-each select="ancestor::mn:table[1]">
			<xsl:call-template name="setTableStyles">
				<xsl:with-param name="scope">ancestor_table</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:call-template name="setTableStyles"/>

	</xsl:template> <!-- setTableRowAttributes -->
	<!-- ===================== -->
	<!-- END Table's row processing -->
	<!-- ===================== -->

	<!-- cell in table header row -->
	<xsl:template match="*[local-name()='th']">
		<fo:table-cell xsl:use-attribute-sets="table-header-cell-style"> <!-- text-align="{@align}" -->
			<xsl:call-template name="setTextAlignment">
				<xsl:with-param name="default">center</xsl:with-param>
			</xsl:call-template>

			<xsl:copy-of select="@keep-together.within-line"/>

			<xsl:call-template name="refine_table-header-cell-style"/>

			<!-- experimental feature, see https://github.com/metanorma/metanorma-plateau/issues/30#issuecomment-2145461828 -->
			<!-- <xsl:choose>
				<xsl:when test="count(node()) = 1 and mn:span[contains(@style, 'text-orientation')]">
					<fo:block-container reference-orientation="270">
						<fo:block role="SKIP" text-align="start">
							<xsl:apply-templates />
						</fo:block>
					</fo:block-container>
				</xsl:when>
				<xsl:otherwise>
					<fo:block role="SKIP">
						<xsl:apply-templates />
					</fo:block>
				</xsl:otherwise>
			</xsl:choose> -->

			<fo:block role="SKIP">
				<xsl:apply-templates/>
				<xsl:if test="$isGenerateTableIF = 'false' and count(node()) = 0"> </xsl:if>
			</fo:block>
		</fo:table-cell>
	</xsl:template> <!-- cell in table header row - 'th' -->

	<xsl:template name="setTableCellAttributes">
		<xsl:if test="@colspan">
			<xsl:attribute name="number-columns-spanned">
				<xsl:value-of select="@colspan"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:if test="@rowspan">
			<xsl:attribute name="number-rows-spanned">
				<xsl:value-of select="@rowspan"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:call-template name="display-align"/>

		<xsl:for-each select="ancestor::mn:table[1]">
			<xsl:call-template name="setTableStyles">
				<xsl:with-param name="scope">ancestor_table_borders_only</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:call-template name="setTableStyles"/>
	</xsl:template>

	<xsl:template name="display-align">
		<xsl:if test="@valign">
			<xsl:attribute name="display-align">
				<xsl:choose>
					<xsl:when test="@valign = 'top'">before</xsl:when>
					<xsl:when test="@valign = 'middle'">center</xsl:when>
					<xsl:when test="@valign = 'bottom'">after</xsl:when>
					<xsl:otherwise>before</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:template name="setTableStyles">
		<xsl:param name="scope">cell</xsl:param>
		<xsl:variable name="styles__">
			<xsl:call-template name="split">
				<xsl:with-param name="pText" select="concat(@style,';')"/>
				<xsl:with-param name="sep" select="';'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="quot">"</xsl:variable>
		<xsl:variable name="styles_">
			<!-- PDF: Borderless tables https://github.com/metanorma/metanorma-jis/issues/344 -->
			<xsl:if test="@plain = 'true' or ancestor::mn:table/@plain = 'true'">
				<style name="border-top">none</style>
				<style name="border-right">none</style>
				<style name="border-left">none</style>
				<style name="border-bottom">none</style>
				<style name="color">inherit</style>
				<style name="background-color">transparent</style>
			</xsl:if>

			<xsl:for-each select="xalan:nodeset($styles__)/mnx:item">
				<xsl:variable name="key" select="normalize-space(substring-before(., ':'))"/>
				<xsl:variable name="value" select="normalize-space(substring-after(translate(.,$quot,''), ':'))"/>
				<xsl:if test="($key = 'color' and ($scope = 'cell' or $scope = 'table')) or       ($key = 'background-color' and ($scope = 'cell' or $scope = 'ancestor_table')) or      $key = 'border' or      $key = 'border-top' or      $key = 'border-right' or      $key = 'border-left' or      $key = 'border-bottom' or      $key = 'border-style' or      $key = 'border-width' or      $key = 'border-color' or      $key = 'border-top-style' or      $key = 'border-top-width' or      $key = 'border-top-color' or      $key = 'border-right-style' or      $key = 'border-right-width' or      $key = 'border-right-color' or      $key = 'border-left-style' or      $key = 'border-left-width' or      $key = 'border-left-color' or      $key = 'border-bottom-style' or      $key = 'border-bottom-width' or      $key = 'border-bottom-color'">
					<style name="{$key}"><xsl:value-of select="java:replaceAll(java:java.lang.String.new($value), 'currentColor', 'inherit')"/></style>
				</xsl:if>
				<xsl:if test="$key = 'border' and ($scope = 'table' or $scope = 'ancestor_table' or $scope = 'ancestor_table_borders_only')">
					<style name="{$key}-top"><xsl:value-of select="$value"/></style>
					<style name="{$key}-right"><xsl:value-of select="$value"/></style>
					<style name="{$key}-left"><xsl:value-of select="$value"/></style>
					<style name="{$key}-bottom"><xsl:value-of select="$value"/></style>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="styles" select="xalan:nodeset($styles_)"/>
		<xsl:for-each select="$styles/style">
			<xsl:attribute name="{@name}"><xsl:value-of select="."/></xsl:attribute>
		</xsl:for-each>
	</xsl:template> <!-- setTableStyles -->

	<!-- cell in table body, footer -->
	<xsl:template match="*[local-name()='td']" name="td">
		<fo:table-cell xsl:use-attribute-sets="table-cell-style"> <!-- text-align="{@align}" -->
			<xsl:call-template name="setTextAlignment">
				<xsl:with-param name="default">left</xsl:with-param>
			</xsl:call-template>

			<xsl:copy-of select="@keep-together.within-line"/>

			<xsl:call-template name="refine_table-cell-style"/>

			<xsl:call-template name="setTableCellAttributes"/>

			<xsl:if test=".//mn:table"> <!-- if there is nested table -->
				<xsl:attribute name="padding-right">1mm</xsl:attribute>
			</xsl:if>

			<xsl:if test="$isGenerateTableIF = 'true'">
				<xsl:attribute name="border">1pt solid black</xsl:attribute> <!-- border is mandatory, to determine page width -->
				<xsl:attribute name="text-align">left</xsl:attribute>
			</xsl:if>

			<xsl:if test="$isGenerateTableIF = 'false'">
				<xsl:if test="@colspan and mn:note[@type = 'units']">
					<xsl:attribute name="text-align">right</xsl:attribute>
					<xsl:attribute name="border">none</xsl:attribute>
					<xsl:attribute name="border-bottom"><xsl:value-of select="$table-border"/></xsl:attribute>
					<xsl:attribute name="border-top">1pt solid white</xsl:attribute>
					<xsl:attribute name="border-left">1pt solid white</xsl:attribute>
					<xsl:attribute name="border-right">1pt solid white</xsl:attribute>
				</xsl:if>
			</xsl:if>

			<fo:block role="SKIP">

				<xsl:if test="$isGenerateTableIF = 'true'">
					<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
				</xsl:if>

				<xsl:apply-templates/>

				<xsl:if test="$isGenerateTableIF = 'true'"> <fo:inline id="{@id}_end">end</fo:inline></xsl:if> <!-- to determine width of text --> <!-- <xsl:value-of select="$hair_space"/> -->

				<xsl:if test="$isGenerateTableIF = 'false' and count(node()) = 0"> </xsl:if>

			</fo:block>
		</fo:table-cell>
	</xsl:template> <!-- td -->

	<!-- table/note, table/example, table/tfoot//note, table/tfoot//example -->
	<xsl:template match="mn:table/*[self::mn:note or self::mn:example] |       mn:table/mn:tfoot//*[self::mn:note or self::mn:example]" priority="2">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block xsl:use-attribute-sets="table-note-style">
			<xsl:copy-of select="@id"/>

			<xsl:call-template name="refine_table-note-style"/>

			<!-- Table's note/example name (NOTE, for example) -->
			<fo:inline xsl:use-attribute-sets="table-note-name-style">

				<xsl:call-template name="refine_table-note-name-style"/>

				<xsl:apply-templates select="mn:fmt-name"/>

			</fo:inline>

			<xsl:apply-templates select="node()[not(self::mn:fmt-name)]"/>
		</fo:block>
	</xsl:template> <!-- table/note -->

	<xsl:template match="mn:table/*[self::mn:note or self::mn:example]/mn:p |  mn:table/mn:tfoot//*[self::mn:note or self::mn:example]/mn:p" priority="2">
		<xsl:apply-templates/>
	</xsl:template>

	<!-- ============================ -->
	<!-- table's footnotes rendering -->
	<!-- ============================ -->

	<!-- table/fmt-footnote-container -->
	<xsl:template match="mn:table/mn:fmt-footnote-container"/>

	<xsl:template match="mn:table/mn:tfoot//mn:fmt-footnote-container">
		<xsl:for-each select=".">
			<xsl:call-template name="table_fn_display"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="table_fn_display">
		<!-- <xsl:variable name="references">
			<xsl:if test="$namespace = 'bsi'">
				<xsl:for-each select="..//mn:fn[local-name(..) = 'name']">
					<xsl:call-template name="create_fn" />
				</xsl:for-each>
			</xsl:if>
			<xsl:for-each select="..//mn:fn[local-name(..) != 'name']">
				<xsl:call-template name="create_fn" />
			</xsl:for-each>
		</xsl:variable> -->
		<!-- <xsl:for-each select="xalan:nodeset($references)//fn">
			<xsl:variable name="reference" select="@reference"/>
			<xsl:if test="not(preceding-sibling::*[@reference = $reference])">  --> <!-- only unique reference puts in note-->
		<xsl:for-each select="..//mn:fmt-footnote-container/mn:fmt-fn-body">
				<fo:block xsl:use-attribute-sets="table-fn-style">
					<xsl:copy-of select="@id"/>
					<xsl:call-template name="refine_table-fn-style"/>

					<xsl:apply-templates select=".//mn:fmt-fn-label">
						<xsl:with-param name="process">true</xsl:with-param>
					</xsl:apply-templates>

					<fo:inline xsl:use-attribute-sets="table-fn-body-style">
						<xsl:call-template name="refine_table-fn-body-style"/>
						<!-- <xsl:copy-of select="./node()"/> -->
						<xsl:apply-templates/>
					</fo:inline>

				</fo:block>

			<!-- </xsl:if> -->
		</xsl:for-each>
	</xsl:template> <!-- table_fn_display -->

	<!-- fmt-fn-body/fmt-fn-label in text -->
	<xsl:template match="mn:fmt-fn-body//mn:fmt-fn-label"/>

	<!-- table//fmt-fn-body//fmt-fn-label -->
	<xsl:template match="mn:table//mn:fmt-fn-body//mn:fmt-fn-label"> <!-- mn:fmt-footnote-container/ -->
		<xsl:param name="process">false</xsl:param>
		<xsl:if test="$process = 'true'">
			<fo:inline xsl:use-attribute-sets="table-fn-number-style" role="SKIP">
				<xsl:call-template name="refine_table-fn-number-style"/>

				<!-- tab is padding-right -->
				<xsl:apply-templates select=".//mn:tab">
					<xsl:with-param name="process">true</xsl:with-param>
				</xsl:apply-templates>

				<!-- <xsl:if test="$namespace = 'bipm'">
					<fo:inline font-style="normal">(</fo:inline>
				</xsl:if> -->

				<!-- <xsl:if test="$namespace = 'plateau'">
					<xsl:text>※</xsl:text>
				</xsl:if> -->

				<!-- <xsl:value-of select="@reference"/> -->
				<!-- <xsl:value-of select="normalize-space()"/> -->
				<xsl:apply-templates/>

				<!-- <xsl:if test="$namespace = 'bipm'">
					<fo:inline font-style="normal">)</fo:inline>
				</xsl:if> -->

				<!-- commented https://github.com/metanorma/isodoc/issues/614 -->
				<!-- <xsl:if test="$namespace = 'itu'">
					<xsl:text>)</xsl:text>
				</xsl:if> -->

				<!-- <xsl:if test="$namespace = 'plateau'">
					<xsl:text>：</xsl:text>
				</xsl:if> -->

			</fo:inline>
		</xsl:if>
	</xsl:template> <!--  fmt-fn-body//fmt-fn-label -->

	<xsl:template match="mn:table//mn:fmt-fn-body//mn:fmt-fn-label//mn:tab" priority="5">
		<xsl:param name="process">false</xsl:param>
		<xsl:if test="$process = 'true'">
			<xsl:attribute name="padding-right">5mm</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:table//mn:fmt-fn-body//mn:fmt-fn-label//mn:sup" priority="5">
		<fo:inline xsl:use-attribute-sets="table-fmt-fn-label-style" role="SKIP">
			<xsl:call-template name="refine_table-fmt-fn-label-style"/>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<!-- <xsl:template match="mn:fmt-footnote-container/mn:fmt-fn-body//mn:fmt-fn-label//mn:tab"/> -->
	<!-- 
	<xsl:template name="create_fn">
		<fn reference="{@reference}" id="{@reference}_{ancestor::*[@id][1]/@id}">
			<xsl:if test="ancestor::*[local-name()='table'][1]/@id">  - for footnotes in tables -
				<xsl:attribute name="id">
					<xsl:value-of select="concat(@reference, '_', ancestor::*[local-name()='table'][1]/@id)"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'itu'">
				<xsl:if test="ancestor::mn:preface">
					<xsl:attribute name="preface">true</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
				<xsl:attribute name="id">
					<xsl:value-of select="@reference"/>
					<xsl:text>_</xsl:text>
					<xsl:value-of select="ancestor::*[local-name()='table'][1]/@id"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</fn>
	</xsl:template> -->

	<!-- footnotes for table's name rendering -->
	<xsl:template name="table_name_fn_display">
		<xsl:for-each select="mn:fmt-name//mn:fn">
			<xsl:variable name="reference" select="@reference"/>
			<fo:block id="{@reference}_{ancestor::*[@id][1]/@id}"><xsl:value-of select="@reference"/></fo:block>
			<fo:block margin-bottom="12pt">
				<xsl:apply-templates/>
			</fo:block>
		</xsl:for-each>
	</xsl:template>
	<!-- ============================ -->
	<!-- EMD table's footnotes rendering -->
	<!-- ============================ -->

	<!-- fn reference in the table rendering (for instance, 'some text 1) some text' ) -->
	<!-- fn --> <!-- in table --> <!-- for figure see <xsl:template match="mn:figure/mn:fn" priority="2"/> -->
	<xsl:template match="mn:fn">
		<xsl:variable name="target" select="@target"/>
		<xsl:choose>
			<!-- case for footnotes in Requirement tables (https://github.com/metanorma/metanorma-ogc/issues/791) -->
			<xsl:when test="not(ancestor::mn:table[1]//mn:fmt-footnote-container/mn:fmt-fn-body[@id = $target]) and        $footnotes/mn:fmt-fn-body[@id = $target]">
				<xsl:call-template name="fn">
					<xsl:with-param name="footnote_body_from_table">true</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>

				<fo:inline xsl:use-attribute-sets="fn-reference-style">

					<xsl:call-template name="refine_fn-reference-style"/>

					<!-- <fo:basic-link internal-destination="{@reference}_{ancestor::*[@id][1]/@id}" fox:alt-text="footnote {@reference}"> --> <!-- @reference   | ancestor::mn:clause[1]/@id-->
					<fo:basic-link internal-destination="{@target}" fox:alt-text="footnote {@reference}">
						<!-- <xsl:if test="ancestor::*[local-name()='table'][1]/@id"> --> <!-- for footnotes in tables -->
						<!-- 	<xsl:attribute name="internal-destination">
								<xsl:value-of select="concat(@reference, '_', ancestor::*[local-name()='table'][1]/@id)"/>
							</xsl:attribute>
						</xsl:if>
						<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
							<xsl:attribute name="internal-destination">
								<xsl:value-of select="@reference"/><xsl:text>_</xsl:text>
								<xsl:value-of select="ancestor::*[local-name()='table'][1]/@id"/>
							</xsl:attribute>
						</xsl:if> -->
						<!-- <xsl:if test="$namespace = 'plateau'">
							<xsl:text>※</xsl:text>
						</xsl:if> -->
						<!-- <xsl:value-of select="@reference"/> -->
						<xsl:value-of select="normalize-space(mn:fmt-fn-label)"/>

						<!-- <xsl:if test="$namespace = 'bsi'">
							<xsl:text>)</xsl:text>
						</xsl:if> -->
						<!-- commented, https://github.com/metanorma/isodoc/issues/614 -->
						<!-- <xsl:if test="$namespace = 'jis'">
							<fo:inline font-weight="normal">)</fo:inline>
						</xsl:if> -->
					</fo:basic-link>
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- fn -->

	<!-- split string 'text' by 'separator' -->
	<xsl:template name="tokenize">
		<xsl:param name="text"/>
		<xsl:param name="separator" select="' '"/>
		<xsl:choose>

			<xsl:when test="$isGenerateTableIF = 'true' and not(contains($text, $separator))">
				<word><xsl:value-of select="normalize-space($text)"/></word>
			</xsl:when>
			<xsl:when test="not(contains($text, $separator))">
				<word>
					<xsl:variable name="len_str_tmp" select="string-length(normalize-space($text))"/>
					<xsl:choose>
						<xsl:when test="normalize-space(translate($text, 'X', '')) = ''"> <!-- special case for keep-together.within-line -->
							<xsl:value-of select="$len_str_tmp"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="str_no_en_chars" select="normalize-space(translate($text, $en_chars, ''))"/>
							<xsl:variable name="len_str_no_en_chars" select="string-length($str_no_en_chars)"/>
							<xsl:variable name="len_str">
								<xsl:choose>
									<xsl:when test="normalize-space(translate($text, $upper, '')) = ''"> <!-- english word in CAPITAL letters -->
										<xsl:value-of select="$len_str_tmp * 1.5"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$len_str_tmp"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>

							<!-- <xsl:if test="$len_str_no_en_chars div $len_str &gt; 0.8">
								<xsl:message>
									div=<xsl:value-of select="$len_str_no_en_chars div $len_str"/>
									len_str=<xsl:value-of select="$len_str"/>
									len_str_no_en_chars=<xsl:value-of select="$len_str_no_en_chars"/>
								</xsl:message>
							</xsl:if> -->
							<!-- <len_str_no_en_chars><xsl:value-of select="$len_str_no_en_chars"/></len_str_no_en_chars>
							<len_str><xsl:value-of select="$len_str"/></len_str> -->
							<xsl:choose>
								<xsl:when test="$len_str_no_en_chars div $len_str &gt; 0.8"> <!-- means non-english string -->
									<xsl:value-of select="$len_str - $len_str_no_en_chars"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$len_str"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</word>
			</xsl:when>
			<xsl:otherwise>
				<word>
					<xsl:variable name="word" select="normalize-space(substring-before($text, $separator))"/>
					<xsl:choose>
						<xsl:when test="$isGenerateTableIF = 'true'">
							<xsl:value-of select="$word"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string-length($word)"/>
						</xsl:otherwise>
					</xsl:choose>
				</word>
				<xsl:call-template name="tokenize">
					<xsl:with-param name="text" select="substring-after($text, $separator)"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- split string 'text' by 'separator', enclosing in formatting tags -->
	<xsl:template name="tokenize_with_tags">
		<xsl:param name="tags"/>
		<xsl:param name="text"/>
		<xsl:param name="separator" select="' '"/>
		<xsl:choose>

			<xsl:when test="not(contains($text, $separator))">
				<word>
					<xsl:if test="ancestor::mn:p[@from_dl = 'true']">
						<xsl:text>
 </xsl:text> <!-- to add distance between dt and dd -->
					</xsl:if>
					<xsl:call-template name="enclose_text_in_tags">
						<xsl:with-param name="text" select="normalize-space($text)"/>
						<xsl:with-param name="tags" select="$tags"/>
					</xsl:call-template>
				</word>
			</xsl:when>
			<xsl:otherwise>
				<word>
					<xsl:if test="ancestor::mn:p[@from_dl = 'true']">
						<xsl:text>
 </xsl:text> <!-- to add distance between dt and dd -->
					</xsl:if>
					<xsl:call-template name="enclose_text_in_tags">
						<xsl:with-param name="text" select="normalize-space(substring-before($text, $separator))"/>
						<xsl:with-param name="tags" select="$tags"/>
					</xsl:call-template>
				</word>
				<xsl:call-template name="tokenize_with_tags">
					<xsl:with-param name="text" select="substring-after($text, $separator)"/>
					<xsl:with-param name="tags" select="$tags"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="enclose_text_in_tags">
		<xsl:param name="text"/>
		<xsl:param name="tags"/>
		<xsl:param name="num">1</xsl:param> <!-- default (start) value -->

		<xsl:variable name="tag_name" select="normalize-space(xalan:nodeset($tags)//tag[$num])"/>

		<xsl:choose>
			<xsl:when test="$tag_name = ''"><xsl:value-of select="$text"/></xsl:when>
			<xsl:otherwise>
				<xsl:element name="{$tag_name}" namespace="{$namespace_full}">
					<xsl:call-template name="enclose_text_in_tags">
						<xsl:with-param name="text" select="$text"/>
						<xsl:with-param name="tags" select="$tags"/>
						<xsl:with-param name="num" select="$num + 1"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- get max value in array -->
	<xsl:template name="max_length">
		<xsl:param name="words"/>
		<xsl:for-each select="$words//word">
				<xsl:sort select="." data-type="number" order="descending"/>
				<xsl:if test="position()=1">
						<xsl:value-of select="."/>
				</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="add-zero-spaces-java">
		<xsl:param name="text" select="."/>

		<!-- add zero-width space (#x200B) after dot with next non-digit -->
		<xsl:variable name="text1" select="java:replaceAll(java:java.lang.String.new($text),'(\.)([^\d\s])','$1​$2')"/>
		<!-- add zero-width space (#x200B) after characters: dash, equal, underscore, em dash, thin space, arrow right, ;   -->
		<xsl:variable name="text2" select="java:replaceAll(java:java.lang.String.new($text1),'(-|=|_|—| |→|;)','$1​')"/>
		<!-- add zero-width space (#x200B) after characters: colon, if there aren't digits after -->
		<xsl:variable name="text3" select="java:replaceAll(java:java.lang.String.new($text2),'(:)(\D)','$1​$2')"/>
		<!-- add zero-width space (#x200B) after characters: 'great than' -->
		<xsl:variable name="text4" select="java:replaceAll(java:java.lang.String.new($text3), '(\u003e)(?!\u003e)', '$1​')"/><!-- negative lookahead: 'great than' not followed by 'great than' -->
		<!-- add zero-width space (#x200B) before characters: 'less than' -->
		<xsl:variable name="text5" select="java:replaceAll(java:java.lang.String.new($text4), '(?&lt;!\u003c)(\u003c)', '​$1')"/> <!-- (?<!\u003c)(\u003c) --> <!-- negative lookbehind: 'less than' not preceeded by 'less than' -->
		<!-- add zero-width space (#x200B) before character: { -->
		<xsl:variable name="text6" select="java:replaceAll(java:java.lang.String.new($text5), '(?&lt;!\W)(\{)', '​$1')"/> <!-- negative lookbehind: '{' not preceeded by 'punctuation char' -->
		<!-- add zero-width space (#x200B) after character: , -->
		<xsl:variable name="text7" select="java:replaceAll(java:java.lang.String.new($text6), '(\,)(?!\d)', '$1​')"/> <!-- negative lookahead: ',' not followed by digit -->
		<!-- add zero-width space (#x200B) after character: '/' -->
		<xsl:variable name="text8" select="java:replaceAll(java:java.lang.String.new($text7), '(\u002f)(?!\u002f)', '$1​')"/><!-- negative lookahead: '/' not followed by '/' -->

		<xsl:variable name="text9">
			<xsl:choose>
				<xsl:when test="$isGenerateTableIF = 'true'">
					<xsl:value-of select="java:replaceAll(java:java.lang.String.new($text8), '([\u3000-\u9FFF])', '$1​')"/> <!-- 3000 - CJK Symbols and Punctuation ... 9FFF CJK Unified Ideographs-->
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="$text8"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- replace sequence #x200B to one &#x200B -->
		<xsl:variable name="text10" select="java:replaceAll(java:java.lang.String.new($text9), '\u200b{2,}', '​')"/>

		<!-- replace sequence #x200B and space TO space -->
		<xsl:variable name="text11" select="java:replaceAll(java:java.lang.String.new($text10), '\u200b ', ' ')"/>

		<xsl:value-of select="$text11"/>
	</xsl:template> <!-- add-zero-spaces-java -->

	<xsl:template name="add-zero-spaces-link-java">
		<xsl:param name="text" select="."/>

		<xsl:value-of select="java:replaceAll(java:java.lang.String.new($text), $regex_url_start, '$1')"/> <!-- http://. https:// or www. -->
		<xsl:variable name="url_continue" select="java:replaceAll(java:java.lang.String.new($text), $regex_url_start, '$2')"/>
		<!-- add zero-width space (#x200B) after characters: dash, dot, colon, equal, underscore, em dash, thin space, comma, slash, @  -->
		<xsl:variable name="url" select="java:replaceAll(java:java.lang.String.new($url_continue),'(-|\.|:|=|_|—| |,|/|@)','$1​')"/>

		<!-- replace sequence #x200B to one &#x200B -->
		<xsl:variable name="url2" select="java:replaceAll(java:java.lang.String.new($url), '\u200b{2,}', '​')"/>

		<!-- remove zero-width space at the end -->
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new($url2), '​$', '')"/>
	</xsl:template> <!-- add-zero-spaces-link-java -->

	<!-- Table normalization (colspan,rowspan processing for adding TDs) for column width calculation -->
	<xsl:template name="getSimpleTable">
		<xsl:param name="id"/>

		<!-- <test0>
			<xsl:copy-of select="."/>
		</test0> -->

		<xsl:variable name="simple-table">

			<xsl:variable name="table_without_semantic_elements">
				<xsl:apply-templates mode="update_xml_step1"/>
			</xsl:variable>

			<!-- Step 0. replace <br/> to <p>...</p> -->
			<xsl:variable name="table_without_br">
				<!-- <xsl:apply-templates mode="table-without-br"/> -->
				<xsl:apply-templates select="xalan:nodeset($table_without_semantic_elements)" mode="table-without-br"/>
			</xsl:variable>
			<!-- <debug-table_without_br><xsl:copy-of select="$table_without_br"/></debug-table_without_br> -->

			<!-- Step 1. colspan processing -->
			<xsl:variable name="simple-table-colspan">
				<mn:tbody>
					<xsl:apply-templates select="xalan:nodeset($table_without_br)" mode="simple-table-colspan"/>
				</mn:tbody>
			</xsl:variable>
			<!-- <debug-simple-table-colspan><xsl:copy-of select="$simple-table-colspan"/></debug-simple-table-colspan> -->

			<!-- Step 2. rowspan processing -->
			<xsl:variable name="simple-table-rowspan">
				<xsl:apply-templates select="xalan:nodeset($simple-table-colspan)" mode="simple-table-rowspan"/>
			</xsl:variable>
			<!-- <debug-simple-table-rowspan><xsl:copy-of select="$simple-table-rowspan"/></debug-simple-table-rowspan> -->

			<!-- Step 3: add id to each cell -->
			<!-- add <word>...</word> for each word, image, math -->
			<xsl:variable name="simple-table-id">
				<xsl:apply-templates select="xalan:nodeset($simple-table-rowspan)" mode="simple-table-id">
					<xsl:with-param name="id" select="$id"/>
				</xsl:apply-templates>
			</xsl:variable>
			<!-- <debug-simple-table-id><xsl:copy-of select="$simple-table-id"/></debug-simple-table-id> -->

			<xsl:copy-of select="xalan:nodeset($simple-table-id)"/>

		</xsl:variable>
		<xsl:copy-of select="$simple-table"/>
	</xsl:template>

	<!-- ================================== -->
	<!-- Step 0. replace <br/> to <p>...</p> -->
	<!-- ================================== -->
	<xsl:template match="@*|node()" mode="table-without-br">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="table-without-br"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name() = 'td'][not(mn:br) and not(mn:p) and not(mn:sourcecode) and not(mn:ul) and not(mn:ol)]" mode="table-without-br">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<mn:p>
				<xsl:copy-of select="node()"/>
			</mn:p>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name()='td'][mn:br]" mode="table-without-br">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:for-each select="mn:br">
				<xsl:variable name="current_id" select="generate-id()"/>
				<mn:p>
					<xsl:for-each select="preceding-sibling::node()[following-sibling::mn:br[1][generate-id() = $current_id]][not(local-name() = 'br')]">
						<xsl:copy-of select="."/>
					</xsl:for-each>
				</mn:p>
				<xsl:if test="not(following-sibling::mn:br)">
					<mn:p>
						<xsl:for-each select="following-sibling::node()">
							<xsl:copy-of select="."/>
						</xsl:for-each>
					</mn:p>
				</xsl:if>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name()='td']/mn:p[mn:br]" mode="table-without-br">
		<xsl:for-each select="mn:br">
			<xsl:variable name="current_id" select="generate-id()"/>
			<mn:p>
				<xsl:for-each select="preceding-sibling::node()[following-sibling::mn:br[1][generate-id() = $current_id]][not(local-name() = 'br')]">
					<xsl:copy-of select="."/>
				</xsl:for-each>
			</mn:p>
			<xsl:if test="not(following-sibling::mn:br)">
				<mn:p>
					<xsl:for-each select="following-sibling::node()">
						<xsl:copy-of select="."/>
					</xsl:for-each>
				</mn:p>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name()='td']/mn:sourcecode" mode="table-without-br">
		<xsl:apply-templates mode="table-without-br"/>
	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name()='td']/mn:sourcecode/text()[contains(., '&#13;') or contains(., '&#10;')]" mode="table-without-br">

		<xsl:variable name="sep">###SOURCECODE_NEWLINE###</xsl:variable>
		<xsl:variable name="sourcecode_text" select="java:replaceAll(java:java.lang.String.new(.),'(&#13;&#10;|&#13;|&#10;)', $sep)"/>
		<xsl:variable name="items">
			<xsl:call-template name="split">
				<xsl:with-param name="pText" select="$sourcecode_text"/>
				<xsl:with-param name="sep" select="$sep"/>
				<xsl:with-param name="normalize-space">false</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:for-each select="xalan:nodeset($items)/*">
			<mn:p>
				<mn:sourcecode><xsl:copy-of select="node()"/></mn:sourcecode>
			</mn:p>
		</xsl:for-each>
	</xsl:template>

	<!-- remove redundant white spaces -->
	<xsl:template match="text()[not(ancestor::mn:sourcecode)]" mode="table-without-br">
		<xsl:variable name="text" select="translate(.,'&#9;&#10;&#13;','')"/>
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new($text),' {2,}',' ')"/>
	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name()='td']//*[local-name() = 'ol' or local-name() = 'ul']" mode="table-without-br">
		<xsl:apply-templates mode="table-without-br"/>
	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name()='td']//mn:li" mode="table-without-br">
		<xsl:apply-templates mode="table-without-br"/>
	</xsl:template>

	<!-- mode="table-without-br" -->
	<!-- ================================== -->
	<!-- END: Step 0. replace <br/> to <p>...</p> -->
	<!-- ================================== -->

	<!-- ===================== -->
	<!-- 1. mode "simple-table-colspan" 
			1.1. remove thead, tbody, fn
			1.2. rename th -> td
			1.3. repeating N td with colspan=N
			1.4. remove namespace
			1.5. remove @colspan attribute
			1.6. add @divide attribute for divide text width in further processing 
	-->
	<!-- ===================== -->
	<xsl:template match="*[local-name()='thead'] | *[local-name()='tbody']" mode="simple-table-colspan">
		<xsl:apply-templates mode="simple-table-colspan"/>
	</xsl:template>
	<xsl:template match="mn:fn" mode="simple-table-colspan"/>

	<xsl:template match="*[local-name()='th'] | *[local-name()='td']" mode="simple-table-colspan">
		<xsl:choose>
			<xsl:when test="@colspan">
				<xsl:variable name="td">
					<xsl:element name="{local-name()}" namespace="{$namespace_full}">
						<xsl:attribute name="divide"><xsl:value-of select="@colspan"/></xsl:attribute>
						<xsl:if test="local-name()='th'">
							<xsl:attribute name="font-weight">bold</xsl:attribute>
						</xsl:if>
						<xsl:apply-templates select="@*" mode="simple-table-colspan"/>
						<xsl:apply-templates mode="simple-table-colspan"/>
					</xsl:element>
				</xsl:variable>
				<xsl:call-template name="repeatNode">
					<xsl:with-param name="count" select="@colspan"/>
					<xsl:with-param name="node" select="$td"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="{local-name()}" namespace="{$namespace_full}">
					<xsl:apply-templates select="@*" mode="simple-table-colspan"/>
					<xsl:if test="local-name()='th'">
						<xsl:attribute name="font-weight">bold</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates mode="simple-table-colspan"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="@colspan" mode="simple-table-colspan"/>

	<xsl:template match="*[local-name()='tr']" mode="simple-table-colspan">
		<mn:tr>
			<xsl:apply-templates select="@*" mode="simple-table-colspan"/>
			<xsl:apply-templates mode="simple-table-colspan"/>
		</mn:tr>
	</xsl:template>

	<xsl:template match="@*|node()" mode="simple-table-colspan">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="simple-table-colspan"/>
		</xsl:copy>
	</xsl:template>

	<!-- repeat node 'count' times -->
	<xsl:template name="repeatNode">
		<xsl:param name="count"/>
		<xsl:param name="node"/>

		<xsl:if test="$count &gt; 0">
			<xsl:call-template name="repeatNode">
				<xsl:with-param name="count" select="$count - 1"/>
				<xsl:with-param name="node" select="$node"/>
			</xsl:call-template>
			<xsl:copy-of select="$node"/>
		</xsl:if>
	</xsl:template>
	<!-- End mode simple-table-colspan  -->
	<!-- ===================== -->
	<!-- ===================== -->

	<!-- ===================== -->
	<!-- 2. mode "simple-table-rowspan" 
	Row span processing, more information http://andrewjwelch.com/code/xslt/table/table-normalization.html	-->
	<!-- ===================== -->
	<xsl:template match="@*|node()" mode="simple-table-rowspan">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="simple-table-rowspan"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:tbody" mode="simple-table-rowspan">
		<xsl:copy>
				<xsl:copy-of select="mn:tr[1]"/>
				<xsl:apply-templates select="mn:tr[2]" mode="simple-table-rowspan">
						<xsl:with-param name="previousRow" select="mn:tr[1]"/>
				</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:tr" mode="simple-table-rowspan">
		<xsl:param name="previousRow"/>
		<xsl:variable name="currentRow" select="."/>

		<xsl:variable name="normalizedTDs">
				<xsl:for-each select="xalan:nodeset($previousRow)//*[self::mn:td or self::mn:th]">
						<xsl:choose>
								<xsl:when test="@rowspan &gt; 1">
										<xsl:copy>
												<xsl:attribute name="rowspan">
														<xsl:value-of select="@rowspan - 1"/>
												</xsl:attribute>
												<xsl:copy-of select="@*[not(name() = 'rowspan')]"/>
												<xsl:copy-of select="node()"/>
										</xsl:copy>
								</xsl:when>
								<xsl:otherwise>
										<xsl:copy-of select="$currentRow/*[self::mn:td or self::mn:th][1 + count(current()/preceding-sibling::*[self::mn:td or self::mn:th][not(@rowspan) or (@rowspan = 1)])]"/>
								</xsl:otherwise>
						</xsl:choose>
				</xsl:for-each>
		</xsl:variable>

		<xsl:variable name="newRow">
				<xsl:copy>
						<xsl:copy-of select="$currentRow/@*"/>
						<xsl:copy-of select="xalan:nodeset($normalizedTDs)"/>
				</xsl:copy>
		</xsl:variable>
		<xsl:copy-of select="$newRow"/>

		<!-- optimize to prevent StackOverflowError, just copy next 'tr' -->
		<xsl:variable name="currrow_num" select="count(preceding-sibling::mn:tr) + 1"/>
		<xsl:variable name="nextrow_without_rowspan_" select="count(following-sibling::mn:tr[*[@rowspan and @rowspan != 1]][1]/preceding-sibling::mn:tr) + 1"/>
		<xsl:variable name="nextrow_without_rowspan" select="$nextrow_without_rowspan_ - $currrow_num"/>
		<xsl:choose>
			<xsl:when test="not(xalan:nodeset($newRow)/*/*[@rowspan and @rowspan != 1]) and $nextrow_without_rowspan &lt;= 0">
				<xsl:copy-of select="following-sibling::mn:tr"/>
			</xsl:when>
			<!-- <xsl:when test="xalan:nodeset($newRow)/*[not(@rowspan) or (@rowspan = 1)] and $nextrow_without_rowspan &gt; 0">
				<xsl:copy-of select="following-sibling::tr[position() &lt;= $nextrow_without_rowspan]"/>
				
				<xsl:copy-of select="following-sibling::tr[$nextrow_without_rowspan + 1]"/>
				<xsl:apply-templates select="following-sibling::tr[$nextrow_without_rowspan + 2]" mode="simple-table-rowspan">
						<xsl:with-param name="previousRow" select="following-sibling::tr[$nextrow_without_rowspan + 1]"/>
				</xsl:apply-templates>
			</xsl:when> -->
			<xsl:otherwise>
				<xsl:apply-templates select="following-sibling::mn:tr[1]" mode="simple-table-rowspan">
						<xsl:with-param name="previousRow" select="$newRow"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- End mode simple-table-rowspan  -->

	<!-- Step 3: add id for each cell -->
	<!-- mode: simple-table-id -->
	<xsl:template match="/" mode="simple-table-id">
		<xsl:param name="id"/>
		<xsl:variable name="id_prefixed" select="concat('table_if_',$id)"/> <!-- table id prefixed by 'table_if_' to simple search in IF  -->
		<xsl:apply-templates select="@*|node()" mode="simple-table-id">
			<xsl:with-param name="id" select="$id_prefixed"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="@*|node()" mode="simple-table-id">
		<xsl:param name="id"/>
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="simple-table-id">
					<xsl:with-param name="id" select="$id"/>
				</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name()='tbody']" mode="simple-table-id">
		<xsl:param name="id"/>
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
			<xsl:apply-templates select="node()" mode="simple-table-id">
				<xsl:with-param name="id" select="$id"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name()='td']" mode="simple-table-id">
		<xsl:param name="id"/>
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:variable name="row_number" select="count(../preceding-sibling::*) + 1"/>
			<xsl:variable name="col_number" select="count(preceding-sibling::*) + 1"/>
			<xsl:variable name="divide">
				<xsl:choose>
					<xsl:when test="@divide"><xsl:value-of select="@divide"/></xsl:when>
					<xsl:otherwise>1</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:attribute name="id">
				<xsl:value-of select="concat($id,'@',$row_number,'_',$col_number,'_',$divide)"/>
			</xsl:attribute>

			<xsl:for-each select="*[local-name() = 'p']">
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:variable name="p_num" select="count(preceding-sibling::*[local-name() = 'p']) + 1"/>
					<xsl:attribute name="id">
						<xsl:value-of select="concat($id,'@',$row_number,'_',$col_number,'_p_',$p_num,'_',$divide)"/>
					</xsl:attribute>

					<!-- <xsl:copy-of select="node()" /> -->
					<xsl:apply-templates mode="simple-table-noid"/>

				</xsl:copy>
			</xsl:for-each>

			<xsl:if test="$isGenerateTableIF = 'true'"> <!-- split each paragraph to words, image, math -->

				<xsl:variable name="td_text">
					<xsl:apply-templates select="." mode="td_text_with_formatting"/>
				</xsl:variable>

				<!-- td_text='<xsl:copy-of select="$td_text"/>' -->

				<xsl:variable name="words_with_width">
					<!-- calculate width for 'word' which contain text only (without formatting tags inside) -->
					<xsl:for-each select="xalan:nodeset($td_text)//*[local-name() = 'word'][normalize-space() != ''][not(*)]">
						<xsl:copy>
							<xsl:copy-of select="@*"/>
							<xsl:attribute name="width">
								<xsl:value-of select="java:org.metanorma.fop.Util.getStringWidth(., $font_main)"/> <!-- Example: 'Times New Roman' -->
							</xsl:attribute>
							<xsl:copy-of select="node()"/>
						</xsl:copy>
					</xsl:for-each>
				</xsl:variable>

				<xsl:variable name="words_with_width_sorted">
					<xsl:for-each select="xalan:nodeset($words_with_width)//*[local-name() = 'word']">
						<xsl:sort select="@width" data-type="number" order="descending"/>
						<!-- select word maximal width only -->
						<xsl:if test="position() = 1">
							<xsl:copy-of select="."/>
						</xsl:if>
					</xsl:for-each>
					<!-- add 'word' with formatting tags inside -->
					<xsl:for-each select="xalan:nodeset($td_text)//*[local-name() = 'word'][normalize-space() != ''][*]">
						<xsl:copy-of select="."/>
					</xsl:for-each>
				</xsl:variable>

				<!-- <xsl:if test="$debug = 'true'">
					<redirect:write file="{generate-id()}_words_with_width_sorted.xml">
						<td_text><xsl:copy-of select="$td_text"/></td_text>
						<words_with_width><xsl:copy-of select="$words_with_width"/></words_with_width>
						<xsl:copy-of select="$words_with_width_sorted"/>
					</redirect:write>
				</xsl:if> -->

				<xsl:variable name="words">
					<xsl:for-each select=".//*[local-name() = 'image' or local-name() = 'fmt-stem']">
						<word>
							<xsl:copy-of select="."/>
						</word>
					</xsl:for-each>

					<xsl:for-each select="xalan:nodeset($words_with_width_sorted)//*[local-name() = 'word'][normalize-space() != '']">
						<xsl:copy-of select="."/>
					</xsl:for-each>
					<!-- <xsl:for-each select="xalan:nodeset($td_text)//*[local-name() = 'word'][normalize-space() != '']">
						<xsl:copy-of select="."/>
					</xsl:for-each> -->

				</xsl:variable>

				<xsl:for-each select="xalan:nodeset($words)/word">
					<xsl:variable name="num" select="count(preceding-sibling::word) + 1"/>
					<xsl:copy>
						<xsl:attribute name="id">
							<xsl:value-of select="concat($id,'@',$row_number,'_',$col_number,'_word_',$num,'_',$divide)"/>
						</xsl:attribute>
						<xsl:copy-of select="node()"/>
					</xsl:copy>
				</xsl:for-each>
			</xsl:if>
		</xsl:copy>

	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name()='td']/*[local-name() = 'p']//*" mode="simple-table-noid">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="$isGenerateTableIF = 'true'">
					<xsl:copy-of select="@*[local-name() != 'id']"/> <!-- to prevent repeat id in colspan/rowspan cells -->
					<!-- <xsl:if test="local-name() = 'dl' or local-name() = 'table'">
						<xsl:copy-of select="@id"/>
					</xsl:if> -->
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="@*"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="node()" mode="simple-table-noid"/>
		</xsl:copy>
	</xsl:template>

	<!-- End mode: simple-table-id -->
	<!-- ===================== -->
	<!-- ===================== -->

	<!-- =============================== -->
	<!-- mode="td_text_with_formatting" -->
	<!-- =============================== -->
	<xsl:template match="@*|node()" mode="td_text_with_formatting">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="td_text_with_formatting"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name() = 'fmt-stem' or local-name() = 'image']" mode="td_text_with_formatting"/>

	<xsl:template match="*[local-name() = 'keep-together_within-line']/text()" mode="td_text_with_formatting">
		<xsl:variable name="formatting_tags">
			<xsl:call-template name="getFormattingTags"/>
		</xsl:variable>
		<word>
			<xsl:call-template name="enclose_text_in_tags">
				<xsl:with-param name="text" select="normalize-space(.)"/>
				<xsl:with-param name="tags" select="$formatting_tags"/>
			</xsl:call-template>
		</word>
	</xsl:template>

	<xsl:template match="*[local-name() != 'keep-together_within-line']/text()" mode="td_text_with_formatting">

		<xsl:variable name="td_text" select="."/>

		<xsl:variable name="string_with_added_zerospaces">
			<xsl:call-template name="add-zero-spaces-java">
				<xsl:with-param name="text" select="$td_text"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="formatting_tags">
			<xsl:call-template name="getFormattingTags"/>
		</xsl:variable>

		<!-- <word>text</word> -->
		<xsl:call-template name="tokenize_with_tags">
			<xsl:with-param name="tags" select="$formatting_tags"/>
			<xsl:with-param name="text" select="normalize-space(translate($string_with_added_zerospaces, '​­', '  '))"/> <!-- replace zero-width-space and soft-hyphen to space -->
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mn:fmt-link[normalize-space() = '']" mode="td_text_with_formatting">
		<xsl:variable name="link">
			<link_updated>
				<xsl:variable name="target_text">
					<xsl:choose>
						<xsl:when test="starts-with(normalize-space(@target), 'mailto:')">
							<xsl:value-of select="normalize-space(substring-after(@target, 'mailto:'))"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="normalize-space(@target)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:value-of select="$target_text"/>
			</link_updated>
		</xsl:variable>
		<xsl:for-each select="xalan:nodeset($link)/*">
			<xsl:apply-templates mode="td_text_with_formatting"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="getFormattingTags">
		<tags>
			<xsl:if test="ancestor::mn:strong"><tag>strong</tag></xsl:if>
			<xsl:if test="ancestor::mn:em"><tag>em</tag></xsl:if>
			<xsl:if test="ancestor::mn:sub"><tag>sub</tag></xsl:if>
			<xsl:if test="ancestor::mn:sup"><tag>sup</tag></xsl:if>
			<xsl:if test="ancestor::mn:tt"><tag>tt</tag></xsl:if>
			<xsl:if test="ancestor::mn:sourcecode"><tag>sourcecode</tag></xsl:if>
			<xsl:if test="ancestor::*[local-name() = 'keep-together_within-line']"><tag>keep-together_within-line</tag></xsl:if>
			<xsl:if test="ancestor::*[local-name() = 'font_en_vertical']"><tag>font_en_vertical</tag></xsl:if>
		</tags>
	</xsl:template>
	<!-- =============================== -->
	<!-- END mode="td_text_with_formatting" -->
	<!-- =============================== -->

	<!-- ========================== -->
	<!-- Definition's list styles -->
	<!-- ========================== -->

	<xsl:attribute-set name="dl-block-style">
	</xsl:attribute-set>

	<xsl:template name="refine_dl-block-style">
		<xsl:if test="@key = 'true' and ancestor::mn:figure">
			<xsl:attribute name="keep-together.within-column">always</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:attribute-set name="dt-row-style">
	</xsl:attribute-set>

	<xsl:template name="refine_dt-row-style">
	</xsl:template>

	<xsl:attribute-set name="dt-cell-style">
	</xsl:attribute-set>

	<xsl:template name="refine_dt-cell-style">
	</xsl:template> <!-- refine_dt-cell-style -->

	<xsl:attribute-set name="dt-block-style">
		<xsl:attribute name="margin-top">0pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_dt-block-style">
	</xsl:template> <!-- refine_dt-block-style -->

	<xsl:attribute-set name="dl-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		<xsl:attribute name="font-weight">normal</xsl:attribute>
	</xsl:attribute-set> <!-- dl-name-style -->

	<xsl:template name="refine_dl-name-style">
	</xsl:template>

	<xsl:attribute-set name="dd-cell-style">
		<xsl:attribute name="padding-left">2mm</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_dd-cell-style">
	</xsl:template> <!-- refine_dd-cell-style -->

	<!-- ========================== -->
	<!-- END Definition's list styles -->
	<!-- ========================== -->

	<!-- ===================== -->
	<!-- Definition List -->
	<!-- ===================== -->

	<!-- for table auto-layout algorithm -->
	<xsl:template match="mn:dl" priority="2">
		<xsl:choose>
			<xsl:when test="$table_only_with_id != '' and @id = $table_only_with_id">
				<xsl:call-template name="dl"/>
			</xsl:when>
			<xsl:when test="$table_only_with_id != ''"><fo:block/><!-- to prevent empty fo:block-container --></xsl:when>
			<xsl:when test="$table_only_with_ids != '' and contains($table_only_with_ids, concat(@id, ' '))">
				<xsl:call-template name="dl"/>
			</xsl:when>
			<xsl:when test="$table_only_with_ids != ''"><fo:block/><!-- to prevent empty fo:block-container --></xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="dl"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- dl -->

	<xsl:template match="mn:dl" name="dl">
		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>
		<!-- <dl><xsl:copy-of select="."/></dl> -->
		<fo:block-container xsl:use-attribute-sets="dl-block-style" role="SKIP">

			<xsl:call-template name="refine_dl-block-style"/>

			<xsl:call-template name="setBlockSpanAll"/>
			<xsl:if test="not(ancestor::mn:quote)">
				<xsl:attribute name="margin-left">0mm</xsl:attribute>
			</xsl:if>

			<xsl:if test="ancestor::mn:sourcecode">
				<!-- set font-size as sourcecode font-size -->
				<xsl:variable name="sourcecode_attributes">
					<xsl:call-template name="get_sourcecode_attributes"/>
				</xsl:variable>
				<xsl:for-each select="xalan:nodeset($sourcecode_attributes)/sourcecode_attributes/@font-size">
					<xsl:attribute name="{local-name()}">
						<xsl:value-of select="."/>
					</xsl:attribute>
				</xsl:for-each>
			</xsl:if>

			<xsl:if test="parent::mn:note">
				<xsl:attribute name="margin-left">
					<xsl:choose>
						<xsl:when test="not(ancestor::mn:table)"><xsl:value-of select="$note-body-indent"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>

			<xsl:call-template name="setTrackChangesStyles">
				<xsl:with-param name="isAdded" select="$isAdded"/>
				<xsl:with-param name="isDeleted" select="$isDeleted"/>
			</xsl:call-template>

			<fo:block-container margin-left="0mm" role="SKIP">
				<xsl:attribute name="margin-right">0mm</xsl:attribute>

				<xsl:variable name="parent" select="local-name(..)"/>

				<xsl:variable name="key_iso"> <!-- and  (not(../@class) or ../@class !='pseudocode') -->
				</xsl:variable>

				<xsl:variable name="onlyOneComponent" select="normalize-space($parent = 'formula' and count(mn:dt) = 1)"/>

				<xsl:choose>
					<xsl:when test="$onlyOneComponent = 'true'"> <!-- only one component -->
						<fo:block margin-bottom="12pt" text-align="left">
							<!-- <xsl:variable name="title-where">
										<xsl:call-template name="getLocalizedString">
											<xsl:with-param name="key">where</xsl:with-param>
										</xsl:call-template>
									</xsl:variable>
									<xsl:value-of select="$title-where"/> -->
							<xsl:apply-templates select="preceding-sibling::*[1][self::mn:p and @keep-with-next = 'true']/node()"/>
							<xsl:text> </xsl:text>
							<xsl:apply-templates select="mn:dt/*"/>
							<xsl:if test="mn:dd/node()[normalize-space() != ''][1][self::text()]">
								<xsl:text> </xsl:text>
							</xsl:if>
							<xsl:apply-templates select="mn:dd/node()" mode="inline"/>
						</fo:block>
					</xsl:when> <!-- END: only one component -->
					<xsl:when test="$parent = 'formula'"> <!-- a few components -->
						<fo:block margin-bottom="12pt" text-align="left">

							<xsl:call-template name="refine_dl_formula_where_style"/>

							<!-- <xsl:variable name="title-where">
								<xsl:call-template name="getLocalizedString">
									<xsl:with-param name="key">where</xsl:with-param>
								</xsl:call-template>
							</xsl:variable>
							<xsl:value-of select="$title-where"/><xsl:if test="$namespace = 'bsi' or $namespace = 'itu'">:</xsl:if> -->
							<!-- preceding 'p' with word 'where' -->
							<xsl:apply-templates select="preceding-sibling::*[1][self::mn:p and @keep-with-next = 'true']/node()"/>
						</fo:block>
					</xsl:when>  <!-- END: a few components -->
					<xsl:when test="$parent = 'figure' and  (not(../@class) or ../@class !='pseudocode')"> <!-- definition list in a figure -->
						<!-- Presentation XML contains 'Key' caption, https://github.com/metanorma/isodoc/issues/607 -->
						<xsl:if test="not(preceding-sibling::*[1][self::mn:p and @keep-with-next])"> <!-- for old Presentation XML -->
							<fo:block font-weight="bold" text-align="left" margin-bottom="12pt" keep-with-next="always">

								<xsl:call-template name="refine_figure_key_style"/>

								<xsl:variable name="title-key">
									<xsl:call-template name="getLocalizedString">
										<xsl:with-param name="key">key</xsl:with-param>
									</xsl:call-template>
								</xsl:variable>
								<xsl:value-of select="$title-key"/>
							</fo:block>
						</xsl:if>
					</xsl:when>  <!-- END: definition list in a figure -->
				</xsl:choose>

				<!-- a few components -->
				<xsl:if test="$onlyOneComponent = 'false'">
					<fo:block role="SKIP">

						<xsl:call-template name="refine_multicomponent_style"/>

						<xsl:if test="ancestor::*[self::mn:dd or self::mn:td]">
							<xsl:attribute name="margin-top">0</xsl:attribute>
						</xsl:if>

						<fo:block role="SKIP">

							<xsl:call-template name="refine_multicomponent_block_style"/>

							<xsl:apply-templates select="mn:fmt-name">
								<xsl:with-param name="process">true</xsl:with-param>
							</xsl:apply-templates>

							<xsl:if test="$isGenerateTableIF = 'true'">
								<!-- to determine start of table -->
								<fo:block id="{concat('table_if_start_',@id)}" keep-with-next="always" font-size="1pt">Start table '<xsl:value-of select="@id"/>'.</fo:block>
							</xsl:if>

							<fo:table width="95%" table-layout="fixed">

								<xsl:if test="$isGenerateTableIF = 'true'">
									<xsl:attribute name="wrap-option">no-wrap</xsl:attribute>
								</xsl:if>
								<xsl:choose>
									<xsl:when test="normalize-space($key_iso) = 'true' and $parent = 'formula'"/>
									<xsl:when test="normalize-space($key_iso) = 'true'">
										<xsl:attribute name="font-size">10pt</xsl:attribute>
									</xsl:when>
								</xsl:choose>
								<xsl:attribute name="width">100%</xsl:attribute>

								<xsl:choose>
									<xsl:when test="$isGenerateTableIF = 'true'">
										<!-- generate IF for table widths -->
										<!-- example:
											<tr>
												<td valign="top" align="left" id="tab-symdu_1_1">
													<p>Symbol</p>
													<word id="tab-symdu_1_1_word_1">Symbol</word>
												</td>
												<td valign="top" align="left" id="tab-symdu_1_2">
													<p>Description</p>
													<word id="tab-symdu_1_2_word_1">Description</word>
												</td>
											</tr>
										-->

										<!-- create virtual html table for dl/[dt and dd] -->
										<xsl:variable name="simple-table">
											<!-- initial='<xsl:copy-of select="."/>' -->
											<xsl:variable name="dl_table">
												<mn:tbody>
													<xsl:apply-templates mode="dl_if">
														<xsl:with-param name="id" select="@id"/>
													</xsl:apply-templates>
												</mn:tbody>
											</xsl:variable>

											<!-- dl_table='<xsl:copy-of select="$dl_table"/>' -->

											<!-- Step: replace <br/> to <p>...</p> -->
											<xsl:variable name="table_without_br">
												<xsl:apply-templates select="xalan:nodeset($dl_table)" mode="table-without-br"/>
											</xsl:variable>

											<!-- table_without_br='<xsl:copy-of select="$table_without_br"/>' -->

											<!-- Step: add id to each cell -->
											<!-- add <word>...</word> for each word, image, math -->
											<xsl:variable name="simple-table-id">
												<xsl:apply-templates select="xalan:nodeset($table_without_br)" mode="simple-table-id">
													<xsl:with-param name="id" select="@id"/>
												</xsl:apply-templates>
											</xsl:variable>

											<!-- simple-table-id='<xsl:copy-of select="$simple-table-id"/>' -->

											<xsl:copy-of select="xalan:nodeset($simple-table-id)"/>

										</xsl:variable>

										<!-- DEBUG: simple-table<xsl:copy-of select="$simple-table"/> -->

										<xsl:apply-templates select="xalan:nodeset($simple-table)" mode="process_table-if">
											<xsl:with-param name="table_or_dl">dl</xsl:with-param>
										</xsl:apply-templates>

									</xsl:when>
									<xsl:otherwise>

										<xsl:variable name="simple-table">

											<xsl:variable name="dl_table">
												<mn:tbody>
													<xsl:apply-templates mode="dl">
														<xsl:with-param name="id" select="@id"/>
													</xsl:apply-templates>
												</mn:tbody>
											</xsl:variable>

											<xsl:copy-of select="$dl_table"/>
										</xsl:variable>

										<xsl:variable name="colwidths">
											<xsl:choose>
												<!-- dl from table[@class='dl'] -->
												<xsl:when test="mn:colgroup">
													<autolayout/>
													<xsl:for-each select="mn:colgroup/mn:col">
														<column><xsl:value-of select="translate(@width,'%m','')"/></column>
													</xsl:for-each>
												</xsl:when>
												<xsl:otherwise>
													<xsl:call-template name="calculate-column-widths">
														<xsl:with-param name="cols-count" select="2"/>
														<xsl:with-param name="table" select="$simple-table"/>
													</xsl:call-template>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>

										<!-- <xsl:text disable-output-escaping="yes">&lt;!- -</xsl:text>
											DEBUG
											colwidths=<xsl:copy-of select="$colwidths"/>
										<xsl:text disable-output-escaping="yes">- -&gt;</xsl:text> -->

										<!-- colwidths=<xsl:copy-of select="$colwidths"/> -->

										<xsl:variable name="maxlength_dt">
											<xsl:call-template name="getMaxLength_dt"/>
										</xsl:variable>

										<xsl:variable name="isContainsKeepTogetherTag_">false
										</xsl:variable>
										<xsl:variable name="isContainsKeepTogetherTag" select="normalize-space($isContainsKeepTogetherTag_)"/>
										<!-- isContainsExpressReference=<xsl:value-of select="$isContainsExpressReference"/> -->
										<xsl:call-template name="setColumnWidth_dl">
											<xsl:with-param name="colwidths" select="$colwidths"/>
											<xsl:with-param name="maxlength_dt" select="$maxlength_dt"/>
											<xsl:with-param name="isContainsKeepTogetherTag" select="$isContainsKeepTogetherTag"/>
										</xsl:call-template>

										<fo:table-body>

											<!-- DEBUG -->
											<xsl:if test="$table_if_debug = 'true'">
												<fo:table-row>
													<fo:table-cell number-columns-spanned="2" font-size="60%">
														<xsl:apply-templates select="xalan:nodeset($colwidths)" mode="print_as_xml"/>
													</fo:table-cell>
												</fo:table-row>
											</xsl:if>

											<xsl:apply-templates>
												<xsl:with-param name="key_iso" select="normalize-space($key_iso)"/>
												<xsl:with-param name="split_keep-within-line" select="xalan:nodeset($colwidths)/split_keep-within-line"/>
											</xsl:apply-templates>

										</fo:table-body>
									</xsl:otherwise>
								</xsl:choose>
							</fo:table>
						</fo:block>
					</fo:block>
				</xsl:if> <!-- END: a few components -->
			</fo:block-container>
		</fo:block-container>

		<xsl:if test="$isGenerateTableIF = 'true'"> <!-- process nested 'dl' -->
			<xsl:apply-templates select="mn:dd/mn:dl"/>
		</xsl:if>

	</xsl:template> <!-- END: dl -->

	<xsl:template match="@*|node()" mode="dt_clean">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="dt_clean"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="mn:asciimath" mode="dt_clean"/>

	<xsl:template name="refine_dl_formula_where_style">
	</xsl:template> <!-- refine_dl_formula_where_style -->

	<xsl:template name="refine_multicomponent_style">
		<xsl:variable name="parent" select="local-name(..)"/>
		<!-- <xsl:attribute name="margin-left">7mm</xsl:attribute> -->
	</xsl:template> <!-- refine_multicomponent_style -->

	<xsl:template name="refine_multicomponent_block_style">
		<xsl:variable name="parent" select="local-name(..)"/>
		<!-- <xsl:attribute name="margin-left">-3.5mm</xsl:attribute> -->
	</xsl:template> <!-- refine_multicomponent_block_style -->

	<!-- dl/name -->
	<xsl:template match="mn:dl/mn:fmt-name">
		<xsl:param name="process">false</xsl:param>
		<xsl:if test="$process = 'true'">
			<fo:block xsl:use-attribute-sets="dl-name-style">

				<xsl:call-template name="refine_dl-name-style"/>

				<xsl:apply-templates/>
			</fo:block>
		</xsl:if>
	</xsl:template>

	<xsl:template name="setColumnWidth_dl">
		<xsl:param name="colwidths"/>
		<xsl:param name="maxlength_dt"/>
		<xsl:param name="isContainsKeepTogetherTag"/>

		<!-- <colwidths><xsl:copy-of select="$colwidths"/></colwidths> -->

		<xsl:choose>
			<!-- <xsl:when test="@class = 'formula_dl' and local-name(..) = 'figure'">
				<fo:table-column column-width="10%"/>
				<fo:table-column column-width="90%"/>
			</xsl:when> -->
			<xsl:when test="xalan:nodeset($colwidths)/autolayout">
				<xsl:call-template name="insertTableColumnWidth">
					<xsl:with-param name="colwidths" select="$colwidths"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="ancestor::mn:dl"><!-- second level, i.e. inlined table -->
				<fo:table-column column-width="50%"/>
				<fo:table-column column-width="50%"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="xalan:nodeset($colwidths)/autolayout">
						<xsl:call-template name="insertTableColumnWidth">
							<xsl:with-param name="colwidths" select="$colwidths"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$isContainsKeepTogetherTag">
						<xsl:call-template name="insertTableColumnWidth">
							<xsl:with-param name="colwidths" select="$colwidths"/>
						</xsl:call-template>
					</xsl:when>
					<!-- to set width check most wide chars like `W` -->
					<xsl:when test="normalize-space($maxlength_dt) != '' and number($maxlength_dt) &lt;= 2"> <!-- if dt contains short text like t90, a, etc -->
						<fo:table-column column-width="7%"/>
						<fo:table-column column-width="93%"/>
					</xsl:when>
					<xsl:when test="normalize-space($maxlength_dt) != '' and number($maxlength_dt) &lt;= 5"> <!-- if dt contains short text like ABC, etc -->
						<fo:table-column column-width="15%"/>
						<fo:table-column column-width="85%"/>
					</xsl:when>
					<xsl:when test="normalize-space($maxlength_dt) != '' and number($maxlength_dt) &lt;= 7"> <!-- if dt contains short text like ABCDEF, etc -->
						<fo:table-column column-width="20%"/>
						<fo:table-column column-width="80%"/>
					</xsl:when>
					<xsl:when test="normalize-space($maxlength_dt) != '' and number($maxlength_dt) &lt;= 10"> <!-- if dt contains short text like ABCDEFEF, etc -->
						<fo:table-column column-width="25%"/>
						<fo:table-column column-width="75%"/>
					</xsl:when>
					<!-- <xsl:when test="xalan:nodeset($colwidths)/column[1] div xalan:nodeset($colwidths)/column[2] &gt; 1.7">
						<fo:table-column column-width="60%"/>
						<fo:table-column column-width="40%"/>
					</xsl:when> -->
					<xsl:when test="xalan:nodeset($colwidths)/column[1] div xalan:nodeset($colwidths)/column[2] &gt; 1.3">
						<fo:table-column column-width="50%"/>
						<fo:table-column column-width="50%"/>
					</xsl:when>
					<xsl:when test="xalan:nodeset($colwidths)/column[1] div xalan:nodeset($colwidths)/column[2] &gt; 0.5">
						<fo:table-column column-width="40%"/>
						<fo:table-column column-width="60%"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="insertTableColumnWidth">
							<xsl:with-param name="colwidths" select="$colwidths"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="insertTableColumnWidth">
		<xsl:param name="colwidths"/>

		<xsl:for-each select="xalan:nodeset($colwidths)//column">
			<xsl:choose>
				<xsl:when test=". = 1 or . = 0">
					<fo:table-column column-width="proportional-column-width(2)"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- <fo:table-column column-width="proportional-column-width({.})"/> -->
					<xsl:variable name="divider">
						<xsl:value-of select="@divider"/>
						<xsl:if test="not(@divider)">1</xsl:if>
					</xsl:variable>
					<fo:table-column column-width="proportional-column-width({round(. div $divider)})"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="getMaxLength_dt">
		<xsl:variable name="lengths">
			<xsl:for-each select="mn:dt">
				<xsl:variable name="maintext_length" select="string-length(normalize-space(.))"/>
				<xsl:variable name="attributes">
					<xsl:for-each select=".//@open"><xsl:value-of select="."/></xsl:for-each>
					<xsl:for-each select=".//@close"><xsl:value-of select="."/></xsl:for-each>
				</xsl:variable>
				<length><xsl:value-of select="string-length(normalize-space(.)) + string-length($attributes)"/></length>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="maxLength">
			<xsl:for-each select="xalan:nodeset($lengths)/length">
				<xsl:sort select="." data-type="number" order="descending"/>
				<xsl:if test="position() = 1">
					<xsl:value-of select="."/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<!-- <xsl:message>DEBUG:<xsl:value-of select="$maxLength"/></xsl:message> -->
		<xsl:value-of select="$maxLength"/>
	</xsl:template>

	<!-- note in definition list: dl/note -->
	<!-- renders in the 2-column spanned table row -->
	<xsl:template match="mn:dl/mn:note" priority="2">
		<xsl:param name="key_iso"/>
		<!-- <tr>
			<td>NOTE</td>
			<td>
				<xsl:apply-templates />
			</td>
		</tr>
		 -->
		<!-- OLD Variant -->
		<!-- <fo:table-row>
			<fo:table-cell>
				<fo:block margin-top="6pt">
					<xsl:if test="normalize-space($key_iso) = 'true'">
						<xsl:attribute name="margin-top">0</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates select="mn:name" />
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block>
					<xsl:apply-templates select="node()[not(local-name() = 'name')]" />
				</fo:block>
			</fo:table-cell>
		</fo:table-row> -->
		<!-- <tr>
			<td number-columns-spanned="2">NOTE <xsl:apply-templates /> </td>
		</tr> 
		-->
		<fo:table-row>
			<fo:table-cell number-columns-spanned="2">
				<fo:block role="SKIP">
					<xsl:call-template name="note"/>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template> <!-- END: dl/note -->

	<!-- virtual html table for dl/[dt and dd]  -->
	<xsl:template match="mn:dt" mode="dl">
		<xsl:param name="id"/>
		<xsl:variable name="row_number" select="count(preceding-sibling::mn:dt) + 1"/>
		<mn:tr>
			<mn:td>
				<xsl:attribute name="id">
					<xsl:value-of select="concat($id,'@',$row_number,'_1')"/>
				</xsl:attribute>
				<xsl:apply-templates/>
			</mn:td>
			<mn:td>
				<xsl:attribute name="id">
					<xsl:value-of select="concat($id,'@',$row_number,'_2')"/>
				</xsl:attribute>
				<xsl:apply-templates select="following-sibling::mn:dd[1]">
					<xsl:with-param name="process">true</xsl:with-param>
				</xsl:apply-templates>
			</mn:td>
		</mn:tr>
	</xsl:template>

	<!-- Definition's term -->
	<xsl:template match="mn:dt">
		<xsl:param name="key_iso"/>
		<xsl:param name="split_keep-within-line"/>

		<fo:table-row xsl:use-attribute-sets="dt-row-style">
			<xsl:call-template name="refine_dt-row-style"/>

			<xsl:call-template name="insert_dt_cell">
				<xsl:with-param name="key_iso" select="$key_iso"/>
				<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
			</xsl:call-template>
			<xsl:for-each select="following-sibling::mn:dd[1]">
				<xsl:call-template name="insert_dd_cell">
					<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
				</xsl:call-template>
			</xsl:for-each>
		</fo:table-row>
	</xsl:template> <!-- END: dt -->

	<xsl:template name="insert_dt_cell">
		<xsl:param name="key_iso"/>
		<xsl:param name="split_keep-within-line"/>
		<fo:table-cell xsl:use-attribute-sets="dt-cell-style">

			<xsl:if test="$isGenerateTableIF = 'true'">
				<!-- border is mandatory, to calculate real width -->
				<xsl:attribute name="border">0.1pt solid black</xsl:attribute>
				<xsl:attribute name="text-align">left</xsl:attribute>
			</xsl:if>

			<xsl:call-template name="refine_dt-cell-style"/>

			<xsl:call-template name="setNamedDestination"/>
			<fo:block xsl:use-attribute-sets="dt-block-style" role="SKIP">

				<xsl:choose>
					<xsl:when test="$isGenerateTableIF = 'true'">
					<xsl:copy-of select="@id"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="@id"/>
					</xsl:otherwise>
				</xsl:choose>

				<xsl:if test="normalize-space($key_iso) = 'true'">
					<xsl:attribute name="margin-top">0</xsl:attribute>
				</xsl:if>

				<xsl:call-template name="refine_dt-block-style"/>

				<xsl:apply-templates>
					<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
				</xsl:apply-templates>

				<xsl:if test="$isGenerateTableIF = 'true'"><fo:inline id="{@id}_end">end</fo:inline></xsl:if> <!-- to determine width of text --> <!-- <xsl:value-of select="$hair_space"/> -->

			</fo:block>
		</fo:table-cell>
	</xsl:template> <!-- insert_dt_cell -->

	<xsl:template name="insert_dd_cell">
		<xsl:param name="split_keep-within-line"/>
		<fo:table-cell xsl:use-attribute-sets="dd-cell-style">

			<xsl:if test="$isGenerateTableIF = 'true'">
				<!-- border is mandatory, to calculate real width -->
				<xsl:attribute name="border">0.1pt solid black</xsl:attribute>
			</xsl:if>

			<xsl:call-template name="refine_dd-cell-style"/>

			<fo:block role="SKIP">

				<xsl:if test="$isGenerateTableIF = 'true'">
					<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
				</xsl:if>

				<xsl:choose>
					<xsl:when test="$isGenerateTableIF = 'true'">
						<xsl:apply-templates> <!-- following-sibling::mn:dd[1] -->
							<xsl:with-param name="process">true</xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="."> <!-- following-sibling::mn:dd[1] -->
							<xsl:with-param name="process">true</xsl:with-param>
							<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
						</xsl:apply-templates>
					</xsl:otherwise>

				</xsl:choose>

				<xsl:if test="$isGenerateTableIF = 'true'"><fo:inline id="{@id}_end">end</fo:inline></xsl:if> <!-- to determine width of text --> <!-- <xsl:value-of select="$hair_space"/> -->

			</fo:block>
		</fo:table-cell>
	</xsl:template> <!-- insert_dd_cell -->

	<!-- END Definition's term -->

	<xsl:template match="mn:dd" mode="dl"/>
	<xsl:template match="mn:dd" mode="dl_process">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="mn:dd">
		<xsl:param name="process">false</xsl:param>
		<xsl:param name="split_keep-within-line"/>
		<xsl:if test="$process = 'true'">
			<xsl:apply-templates select="@language"/>
			<xsl:apply-templates>
				<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:dd/*" mode="inline">
		<xsl:variable name="is_inline_element_after_where">
			<xsl:if test="self::mn:p and not(preceding-sibling::node()[normalize-space() != ''])">true</xsl:if>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$is_inline_element_after_where = 'true'">
				<fo:inline><xsl:text> </xsl:text><xsl:apply-templates/></fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- =============================== -->
	<!-- mode="dl_if" -->
	<!-- =============================== -->
	<!-- virtual html table for dl/[dt and dd] for IF (Intermediate Format) -->
	<xsl:template match="mn:dt" mode="dl_if">
		<xsl:param name="id"/>
		<mn:tr>
			<mn:td>
				<xsl:copy-of select="node()"/>
			</mn:td>
			<mn:td>
				<!-- <xsl:copy-of select="following-sibling::mn:dd[1]/node()[not(local-name() = 'dl')]"/> -->
				<xsl:apply-templates select="following-sibling::mn:dd[1]/node()[not(local-name() = 'dl')]" mode="dl_if"/>
				<!-- get paragraphs from nested 'dl' -->
				<xsl:apply-templates select="following-sibling::mn:dd[1]/mn:dl" mode="dl_if_nested"/>
			</mn:td>
		</mn:tr>
	</xsl:template>
	<xsl:template match="mn:dd" mode="dl_if"/>

	<xsl:template match="*" mode="dl_if">
		<xsl:copy-of select="."/>
	</xsl:template>

	<xsl:template match="mn:p" mode="dl_if">
		<xsl:param name="indent"/>
		<mn:p>
			<xsl:copy-of select="@*"/>
			<xsl:value-of select="$indent"/>
			<xsl:copy-of select="node()"/>
		</mn:p>
	</xsl:template>

	<xsl:template match="*[local-name() = 'ul' or local-name() = 'ol']" mode="dl_if">
		<xsl:variable name="list_rendered_">
			<xsl:apply-templates select="."/>
		</xsl:variable>
		<xsl:variable name="list_rendered" select="xalan:nodeset($list_rendered_)"/>

		<xsl:variable name="indent">
			<xsl:for-each select="($list_rendered//fo:block[not(.//fo:block)])[1]">
				<xsl:apply-templates select="ancestor::*[@provisional-distance-between-starts]/@provisional-distance-between-starts" mode="dl_if"/>
			</xsl:for-each>
		</xsl:variable>

		<xsl:apply-templates mode="dl_if">
			<xsl:with-param name="indent" select="$indent"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="mn:li" mode="dl_if">
		<xsl:param name="indent"/>
		<xsl:apply-templates mode="dl_if">
			<xsl:with-param name="indent" select="$indent"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="@provisional-distance-between-starts" mode="dl_if">
		<xsl:variable name="value" select="round(substring-before(.,'mm'))"/>
		<!-- emulate left indent for list item -->
		<xsl:call-template name="repeat">
			<xsl:with-param name="char" select="'x'"/>
			<xsl:with-param name="count" select="$value"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mn:dl" mode="dl_if_nested">
		<xsl:for-each select="mn:dt">
			<mn:p>
				<xsl:copy-of select="node()"/>
				<xsl:text> </xsl:text>
				<xsl:copy-of select="following-sibling::mn:dd[1]/mn:p/node()"/>
			</mn:p>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="mn:dd" mode="dl_if_nested"/>
	<!-- =============================== -->
	<!-- END mode="dl_if" -->
	<!-- =============================== -->
	<!-- ===================== -->
	<!-- END Definition List -->
	<!-- ===================== -->

	<xsl:attribute-set name="appendix-style">
	</xsl:attribute-set>

	<xsl:template name="refine_appendix-style">
	</xsl:template>

	<xsl:attribute-set name="appendix-example-style">
	</xsl:attribute-set>

	<xsl:template name="refine_appendix-example-style">
	</xsl:template>

	<!-- ======================== -->
	<!-- Appendix processing -->
	<!-- ======================== -->
	<xsl:template match="mn:appendix">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}" xsl:use-attribute-sets="appendix-style">
			<xsl:call-template name="refine_appendix-style"/>
			<xsl:apply-templates select="mn:fmt-title"/>
		</fo:block>
		<xsl:apply-templates select="node()[not(self::mn:fmt-title)]"/>
	</xsl:template>

	<xsl:template match="mn:appendix/mn:fmt-title" priority="2">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<fo:inline role="H{$level}"><xsl:call-template name="setIDforNamedDestination"/><xsl:apply-templates/></fo:inline>
	</xsl:template>
	<!-- ======================== -->
	<!-- END Appendix processing -->
	<!-- ======================== -->

	<xsl:template match="mn:appendix//mn:example" priority="2">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}" xsl:use-attribute-sets="appendix-example-style">
			<xsl:call-template name="refine_appendix-example-style"/>
			<xsl:apply-templates select="mn:fmt-name"/>
		</fo:block>
		<xsl:apply-templates select="node()[not(self::mn:fmt-name)]"/>
	</xsl:template>

	<xsl:attribute-set name="xref-style">
		<xsl:attribute name="color">blue</xsl:attribute>
		<xsl:attribute name="text-decoration">underline</xsl:attribute>
	</xsl:attribute-set> <!-- xref-style -->

	<xsl:template name="refine_xref-style">
		<xsl:if test="string-length(normalize-space()) &lt; 30 and not(contains(normalize-space(), 'http://')) and not(contains(normalize-space(), 'https://')) and not(ancestor::*[self::mn:table or self::mn:dl])">
			<xsl:attribute name="keep-together.within-line">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="parent::mn:add">
			<xsl:call-template name="append_add-style"/>
		</xsl:if>
	</xsl:template> <!-- refine_xref-style -->

	<xsl:template match="mn:fmt-xref">
		<xsl:call-template name="insert_basic_link">
			<xsl:with-param name="element">
				<xsl:variable name="alt_text">
					<xsl:call-template name="getAltText"/>
				</xsl:variable>
				<fo:basic-link internal-destination="{@target}" fox:alt-text="{$alt_text}" xsl:use-attribute-sets="xref-style">
					<xsl:call-template name="refine_xref-style"/>

					<xsl:apply-templates/>
				</fo:basic-link>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template> <!-- xref -->

	<!-- command between two xref points to non-standard bibitem -->
	<xsl:template match="text()[. = ','][preceding-sibling::node()[1][self::mn:sup][mn:fmt-xref[@type = 'footnote']] and    following-sibling::node()[1][self::mn:sup][mn:fmt-xref[@type = 'footnote']]]"><xsl:value-of select="."/>
	</xsl:template>

	<xsl:attribute-set name="eref-style">
	</xsl:attribute-set>

	<xsl:template name="refine_eref-style">
		<xsl:variable name="citeas" select="java:replaceAll(java:java.lang.String.new(@citeas),'^\[?(.+?)\]?$','$1')"/> <!-- remove leading and trailing brackets -->
		<xsl:variable name="text" select="normalize-space()"/>
	</xsl:template> <!-- refine_eref-style -->

	<xsl:variable name="bibitems_">
		<xsl:for-each select="//mn:bibitem">
			<xsl:copy-of select="."/>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="bibitems" select="xalan:nodeset($bibitems_)"/>

	<!-- get all hidden bibitems to exclude them from eref/origin processing -->
	<xsl:variable name="bibitems_hidden_">
		<xsl:for-each select="//mn:bibitem[@hidden='true']">
			<xsl:copy-of select="."/>
		</xsl:for-each>
		<xsl:for-each select="//mn:references[@hidden='true']//mn:bibitem">
			<xsl:copy-of select="."/>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="bibitems_hidden" select="xalan:nodeset($bibitems_hidden_)"/>
	<!-- ====== -->
	<!-- eref -->
	<!-- ====== -->
	<xsl:template match="mn:fmt-eref" name="eref">
		<xsl:variable name="current_bibitemid" select="@bibitemid"/>
		<!-- <xsl:variable name="external-destination" select="normalize-space(key('bibitems', $current_bibitemid)/mn:uri[@type = 'citation'])"/> -->
		<xsl:variable name="external-destination" select="normalize-space($bibitems/mn:bibitem[@id = $current_bibitemid]/mn:uri[@type = 'citation'])"/>
		<xsl:choose>
			<!-- <xsl:when test="$external-destination != '' or not(key('bibitems_hidden', $current_bibitemid))"> --> <!-- if in the bibliography there is the item with @bibitemid (and not hidden), then create link (internal to the bibitem or external) -->
			<xsl:when test="$external-destination != '' or not($bibitems_hidden/mn:bibitem[@id = $current_bibitemid])"> <!-- if in the bibliography there is the item with @bibitemid (and not hidden), then create link (internal to the bibitem or external) -->
				<fo:inline xsl:use-attribute-sets="eref-style">
					<xsl:if test="@type = 'footnote'">
						<xsl:attribute name="keep-together.within-line">always</xsl:attribute>
						<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
						<xsl:attribute name="vertical-align">super</xsl:attribute>
						<xsl:attribute name="font-size">80%</xsl:attribute>
					</xsl:if>

					<xsl:call-template name="refine_eref-style"/>

					<xsl:call-template name="insert_basic_link">
						<xsl:with-param name="element">
							<fo:basic-link fox:alt-text="{@citeas}">
								<xsl:if test="normalize-space(@citeas) = ''">
									<xsl:attribute name="fox:alt-text"><xsl:value-of select="."/></xsl:attribute>
								</xsl:if>
								<xsl:if test="@type = 'inline'">

									<xsl:call-template name="refine_basic_link_style"/>

								</xsl:if>

								<xsl:choose>
									<xsl:when test="$external-destination != ''"> <!-- external hyperlink -->
										<xsl:attribute name="external-destination"><xsl:value-of select="$external-destination"/></xsl:attribute>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="internal-destination"><xsl:value-of select="@bibitemid"/></xsl:attribute>
									</xsl:otherwise>
								</xsl:choose>

								<xsl:apply-templates/>
							</fo:basic-link>
						</xsl:with-param>
					</xsl:call-template>

				</fo:inline>
			</xsl:when>
			<xsl:otherwise> <!-- if there is key('bibitems_hidden', $current_bibitemid) -->

				<!-- if in bibitem[@hidden='true'] there is url[@type='src'], then create hyperlink  -->
				<xsl:variable name="uri_src" select="normalize-space($bibitems_hidden/mn:bibitem[@id = $current_bibitemid]/mn:uri[@type = 'src'])"/>
				<xsl:choose>
					<xsl:when test="$uri_src != ''">
						<fo:basic-link external-destination="{$uri_src}" fox:alt-text="{$uri_src}"><xsl:apply-templates/></fo:basic-link>
					</xsl:when>
					<xsl:otherwise><fo:inline><xsl:apply-templates/></fo:inline></xsl:otherwise>
				</xsl:choose>

			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="refine_basic_link_style">
		<xsl:attribute name="color">blue</xsl:attribute>
		<xsl:attribute name="text-decoration">underline</xsl:attribute>
	</xsl:template> <!-- refine_basic_link_style -->

	<!-- ====== -->
	<!-- END eref -->
	<!-- ====== -->

	<xsl:attribute-set name="note-style">
		<!-- <xsl:attribute name="font-size">11pt</xsl:attribute> -->
		<xsl:attribute name="margin-top">4pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		<xsl:attribute name="text-align">justify</xsl:attribute>
	</xsl:attribute-set> <!-- note-style -->

	<xsl:template name="refine_note-style">
	</xsl:template> <!-- refine_note-style -->

	<xsl:variable name="note-body-indent">10mm</xsl:variable>
	<xsl:variable name="note-body-indent-table">5mm</xsl:variable>

	<xsl:attribute-set name="note-name-style">
		<!-- <xsl:attribute name="font-size">11pt</xsl:attribute> -->
		<xsl:attribute name="padding-right">2mm</xsl:attribute>
	</xsl:attribute-set> <!-- note-name-style -->

	<xsl:template name="refine_note-name-style">
	</xsl:template> <!-- refine_note-name-style -->

	<xsl:attribute-set name="table-note-name-style">
		<xsl:attribute name="padding-right">2mm</xsl:attribute>
		<!-- <xsl:attribute name="font-size">11pt</xsl:attribute> -->
	</xsl:attribute-set>

	<xsl:template name="refine_table-note-name-style">
	</xsl:template> <!-- refine_table-note-name-style -->

	<xsl:attribute-set name="note-p-style">
		<xsl:attribute name="margin-top">8pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
	</xsl:attribute-set> <!-- note-p-style -->

	<xsl:template name="refine_note-p-style">
	</xsl:template>

	<xsl:attribute-set name="termnote-style">
		<xsl:attribute name="font-size">10pt</xsl:attribute>
		<xsl:attribute name="margin-top">8pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		<xsl:attribute name="text-align">justify</xsl:attribute>
	</xsl:attribute-set> <!-- termnote-style -->

	<xsl:template name="refine_termnote-style">
	</xsl:template> <!-- refine_termnote-style -->

	<xsl:attribute-set name="termnote-name-style">
	</xsl:attribute-set> <!-- termnote-name-style -->

	<xsl:template name="refine_termnote-name-style">
	</xsl:template>

	<xsl:attribute-set name="termnote-p-style">
	</xsl:attribute-set>

	<xsl:template name="refine_termnote-p-style">
	</xsl:template>

	<!-- ====== -->
	<!-- note      -->
	<!-- termnote -->
	<!-- ====== -->

	<xsl:template match="mn:note" name="note">

		<xsl:call-template name="setNamedDestination"/>

		<fo:block-container xsl:use-attribute-sets="note-style" role="SKIP">
			<xsl:if test="not(parent::mn:references)">
				<xsl:copy-of select="@id"/>
			</xsl:if>

			<xsl:call-template name="setBlockSpanAll"/>

			<xsl:call-template name="refine_note-style"/>

			<fo:block-container margin-left="0mm" margin-right="0mm" role="SKIP">
						<fo:block>

							<xsl:call-template name="refine_note_block_style"/>

							<fo:inline xsl:use-attribute-sets="note-name-style" role="SKIP">

								<xsl:apply-templates select="mn:fmt-name/mn:tab" mode="tab"/>

								<xsl:call-template name="refine_note-name-style"/>

								<!-- if 'p' contains all text in 'add' first and last elements in first p are 'add' -->
								<!-- <xsl:if test="*[not(local-name()='name')][1][node()[normalize-space() != ''][1][local-name() = 'add'] and node()[normalize-space() != ''][last()][local-name() = 'add']]"> -->
								<xsl:if test="*[not(self::mn:fmt-name)][1][count(node()[normalize-space() != '']) = 1 and mn:add]">
									<xsl:call-template name="append_add-style"/>
								</xsl:if>

								<!-- if note contains only one element and first and last childs are `add` ace-tag, then move start ace-tag before NOTE's name-->
								<xsl:if test="count(*[not(self::mn:fmt-name)]) = 1 and *[not(self::mn:fmt-name)]/node()[last()][self::mn:add][starts-with(text(), $ace_tag)]">
									<xsl:apply-templates select="*[not(self::mn:fmt-name)]/node()[1][self::mn:add][starts-with(text(), $ace_tag)]">
										<xsl:with-param name="skip">false</xsl:with-param>
									</xsl:apply-templates>
								</xsl:if>

								<xsl:apply-templates select="mn:fmt-name"/>

							</fo:inline>

							<xsl:apply-templates select="node()[not(self::mn:fmt-name)]"/>
						</fo:block>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>

	<xsl:template name="refine_note_block_style">
	</xsl:template> <!-- refine_note_block_style -->

	<xsl:template match="mn:note/mn:p">
		<xsl:variable name="num"><xsl:number/></xsl:variable>
		<xsl:choose>
			<xsl:when test="$num = 1"> <!-- display first NOTE's paragraph in the same line with label NOTE -->
				<fo:inline xsl:use-attribute-sets="note-p-style" role="SKIP">
					<xsl:call-template name="refine_note-p-style"/>
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="note-p-style" role="SKIP">
					<xsl:call-template name="refine_note-p-style"/>
					<xsl:apply-templates/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mn:termnote">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}" xsl:use-attribute-sets="termnote-style">

			<xsl:call-template name="setBlockSpanAll"/>

			<xsl:call-template name="refine_termnote-style"/>

			<fo:inline xsl:use-attribute-sets="termnote-name-style">

				<xsl:call-template name="refine_termnote-name-style"/>

				<!-- if 'p' contains all text in 'add' first and last elements in first p are 'add' -->
				<!-- <xsl:if test="*[not(local-name()='name')][1][node()[normalize-space() != ''][1][local-name() = 'add'] and node()[normalize-space() != ''][last()][local-name() = 'add']]"> -->
				<xsl:if test="*[not(self::mn:fmt-name)][1][count(node()[normalize-space() != '']) = 1 and mn:add]">
					<xsl:call-template name="append_add-style"/>
				</xsl:if>

				<xsl:apply-templates select="mn:fmt-name"/>

			</fo:inline>

			<xsl:apply-templates select="node()[not(self::mn:fmt-name)]"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:note/mn:fmt-name">
		<xsl:param name="sfx"/>
		<xsl:variable name="suffix">
			<xsl:choose>
				<xsl:when test="$sfx != ''">
					<xsl:value-of select="$sfx"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- https://github.com/metanorma/isodoc/issues/607 -->
					<!-- <xsl:if test="$namespace = 'ieee'">
						<xsl:text>—</xsl:text> em dash &#x2014;
					</xsl:if> -->
					<!-- <xsl:if test="$namespace = 'iho' or $namespace = 'gb' or $namespace = 'm3d' or $namespace = 'unece-rec' or $namespace = 'unece'  or $namespace = 'rsd'">
						<xsl:text>:</xsl:text>
					</xsl:if> -->
					<!-- <xsl:if test="$namespace = 'itu' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp'">				
						<xsl:text> – </xsl:text> en dash &#x2013;
					</xsl:if> -->
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="normalize-space() != ''">
			<xsl:apply-templates/>
			<xsl:value-of select="$suffix"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:termnote/mn:fmt-name">
		<xsl:param name="sfx"/>
		<xsl:variable name="suffix">
			<xsl:choose>
				<xsl:when test="$sfx != ''">
					<xsl:value-of select="$sfx"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- https://github.com/metanorma/isodoc/issues/607 -->
					<!-- <xsl:if test="$namespace = 'ieee'">
						<xsl:text>—</xsl:text> em dash &#x2014;
					</xsl:if> -->
					<!-- <xsl:if test="$namespace = 'gb' or $namespace = 'iso' or $namespace = 'iec' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd' or $namespace = 'jcgm'">
						<xsl:text>:</xsl:text>
					</xsl:if> -->
					<!-- <xsl:if test="$namespace = 'itu' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'unece-rec' or $namespace = 'unece'">				
						<xsl:text> – </xsl:text> en dash &#x2013;
					</xsl:if> -->
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="normalize-space() != ''">
			<xsl:apply-templates/>
			<xsl:value-of select="$suffix"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:termnote/mn:p">
		<xsl:variable name="num"><xsl:number/></xsl:variable>
		<xsl:choose>
			<xsl:when test="$num = 1"> <!-- first paragraph renders in the same line as titlenote name -->
				<fo:inline xsl:use-attribute-sets="termnote-p-style">
					<xsl:call-template name="refine_termnote-p-style"/>
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="termnote-p-style">
					<xsl:call-template name="refine_termnote-p-style"/>
					<xsl:apply-templates/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ====== -->
	<!-- ====== -->

	<xsl:attribute-set name="quote-style">
		<xsl:attribute name="margin-left">12mm</xsl:attribute>
		<xsl:attribute name="margin-right">12mm</xsl:attribute>
		<xsl:attribute name="font-family">Calibri</xsl:attribute>
		<xsl:attribute name="margin-left">4.5mm</xsl:attribute>
		<xsl:attribute name="margin-right">9mm</xsl:attribute>
	</xsl:attribute-set> <!-- quote-style -->

	<xsl:template name="refine_quote-style">
	</xsl:template>

	<xsl:attribute-set name="quote-source-style">
		<xsl:attribute name="text-align">right</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_quote-source-style">
	</xsl:template>

	<!-- ====== -->
	<!-- quote -->
	<!-- source -->
	<!-- author  -->
	<!-- ====== -->
	<xsl:template match="mn:quote">
		<fo:block-container margin-left="0mm" role="SKIP">

			<xsl:call-template name="setBlockSpanAll"/>

			<xsl:if test="parent::mn:note">
				<xsl:if test="not(ancestor::mn:table)">
					<xsl:attribute name="margin-left">5mm</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<fo:block-container margin-left="0mm" role="SKIP">
				<fo:block-container xsl:use-attribute-sets="quote-style" role="SKIP">

					<xsl:call-template name="refine_quote-style"/>

					<fo:block-container margin-left="0mm" margin-right="0mm" role="SKIP">
						<fo:block role="BlockQuote">
							<xsl:apply-templates select="./node()[not(self::mn:author) and         not(self::mn:fmt-source) and         not(self::mn:attribution)]"/> <!-- process all nested nodes, except author and source -->
						</fo:block>
					</fo:block-container>
				</fo:block-container>
				<xsl:if test="mn:author or mn:fmt-source or mn:attribution">
					<fo:block xsl:use-attribute-sets="quote-source-style">
						<xsl:call-template name="refine_quote-source-style"/>
						<!-- — ISO, ISO 7301:2011, Clause 1 -->
						<xsl:apply-templates select="mn:author"/>
						<xsl:apply-templates select="mn:fmt-source"/>
						<!-- added for https://github.com/metanorma/isodoc/issues/607 -->
						<xsl:apply-templates select="mn:attribution/mn:p/node()"/>
					</fo:block>
				</xsl:if>

			</fo:block-container>
		</fo:block-container>
	</xsl:template>

	<xsl:template match="mn:fmt-source">
		<xsl:if test="../mn:author">
			<xsl:text>, </xsl:text>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="not(parent::quote)">
				<fo:block>
					<xsl:call-template name="insert_basic_link">
						<xsl:with-param name="element">
							<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
								<xsl:apply-templates/>
							</fo:basic-link>
						</xsl:with-param>
					</xsl:call-template>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="insert_basic_link">
					<xsl:with-param name="element">
						<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
							<xsl:apply-templates/>
						</fo:basic-link>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mn:author">
		<xsl:if test="local-name(..) = 'quote'"> <!-- for old Presentation XML, https://github.com/metanorma/isodoc/issues/607 -->
			<xsl:text>— </xsl:text>
		</xsl:if>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="mn:quote//mn:referenceFrom"/>
	<!-- ====== -->
	<!-- ====== -->

	<xsl:attribute-set name="figure-block-style">
		<xsl:attribute name="role">SKIP</xsl:attribute>
		<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_figure-block-style">
	</xsl:template>

	<xsl:attribute-set name="figure-style">
	</xsl:attribute-set>

	<xsl:template name="refine_figure-style">
	</xsl:template>

	<xsl:attribute-set name="figure-name-style">
		<xsl:attribute name="role">Caption</xsl:attribute>
		<!-- <xsl:attribute name="font-size">11pt</xsl:attribute> -->
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="margin-top">2pt</xsl:attribute>
		<xsl:attribute name="space-after">6pt</xsl:attribute>
		<xsl:attribute name="keep-with-previous">always</xsl:attribute>
	</xsl:attribute-set> <!-- figure-name-style -->

	<xsl:template name="refine_figure-name-style">
	</xsl:template> <!-- refine_figure-name-style -->

	<xsl:attribute-set name="image-style">
		<xsl:attribute name="role">SKIP</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
	</xsl:attribute-set> <!-- image-style -->

	<xsl:template name="refine_image-style">
	</xsl:template>

	<xsl:attribute-set name="image-graphic-style">
		<xsl:attribute name="width">100%</xsl:attribute>
		<xsl:attribute name="content-height">100%</xsl:attribute>
		<xsl:attribute name="scaling">uniform</xsl:attribute>
		<xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
	</xsl:attribute-set> <!-- image-graphic-style -->

	<xsl:template name="refine_image-graphic-style">
	</xsl:template>

	<xsl:attribute-set name="figure-source-style">
	</xsl:attribute-set>

	<xsl:template name="refine_figure-source-style">
	</xsl:template>

	<xsl:attribute-set name="figure-pseudocode-p-style">
	</xsl:attribute-set>

	<xsl:template name="refine_figure-pseudocode-p-style">
	</xsl:template>

	<xsl:attribute-set name="figure-fn-number-style">
		<xsl:attribute name="padding-right">5mm</xsl:attribute>
	</xsl:attribute-set> <!-- figure-fn-number-style -->

	<xsl:template name="refine_figure-fn-number-style">
	</xsl:template>

	<xsl:attribute-set name="figure-fmt-fn-label-style">
		<xsl:attribute name="font-size">80%</xsl:attribute>
		<xsl:attribute name="vertical-align">super</xsl:attribute>
	</xsl:attribute-set> <!-- figure-fmt-fn-label-style -->

	<xsl:template name="refine_figure-fmt-fn-label-style">
	</xsl:template>

	<xsl:attribute-set name="figure-fn-body-style">
		<xsl:attribute name="text-align">justify</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_figure-fn-body-style">
		<xsl:variable name="key_iso">
		</xsl:variable>
		<xsl:if test="normalize-space($key_iso) = 'true'">
			<xsl:attribute name="margin-bottom">0</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<!-- ============================ -->
	<!-- figure's footnotes rendering -->
	<!-- ============================ -->

	<!-- figure/fmt-footnote-container -->
	<xsl:template match="mn:figure//mn:fmt-footnote-container"/>

	<!-- TO DO: remove, now the figure fn in figure/dl/... https://github.com/metanorma/isodoc/issues/658 -->
	<xsl:template name="figure_fn_display">

		<xsl:variable name="references">
			<xsl:for-each select="./mn:fmt-footnote-container/mn:fmt-fn-body">
				<xsl:variable name="curr_id" select="@id"/>
				<!-- <curr_id><xsl:value-of select="$curr_id"/></curr_id>
				<curr><xsl:copy-of select="."/></curr>
				<ancestor><xsl:copy-of select="ancestor::mn:figure[.//mn:name[.//mn:fn]]"/></ancestor> -->
				<xsl:choose>
					<!-- skip figure/name/fn -->
					<xsl:when test="ancestor::mn:figure[.//mn:fmt-name[.//mn:fn[@target = $curr_id]]]"><!-- skip --></xsl:when>
					<xsl:otherwise>
						<xsl:element name="figure" namespace="{$namespace_full}">
							<xsl:element name="fmt-footnote-container" namespace="{$namespace_full}">
								<xsl:copy-of select="."/>
							</xsl:element>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:variable>
		<!-- <references><xsl:copy-of select="$references"/></references> -->

		<xsl:if test="xalan:nodeset($references)//mn:fmt-fn-body">

			<xsl:variable name="key_iso">
			</xsl:variable>

			<fo:block>
				<!-- current hierarchy is 'figure' element -->
				<xsl:variable name="following_dl_colwidths">
					<xsl:if test="mn:dl"><!-- if there is a 'dl', then set the same columns width as for 'dl' -->
						<xsl:variable name="simple-table">
							<!-- <xsl:variable name="doc_ns">
								<xsl:if test="$namespace = 'bipm'">bipm</xsl:if>
							</xsl:variable>
							<xsl:variable name="ns">
								<xsl:choose>
									<xsl:when test="normalize-space($doc_ns)  != ''">
										<xsl:value-of select="normalize-space($doc_ns)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="substring-before(name(/*), '-')"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable> -->

							<xsl:for-each select="mn:dl[1]">
								<mn:tbody>
									<xsl:apply-templates mode="dl"/>
								</mn:tbody>
							</xsl:for-each>
						</xsl:variable>

						<xsl:call-template name="calculate-column-widths">
							<xsl:with-param name="cols-count" select="2"/>
							<xsl:with-param name="table" select="$simple-table"/>
						</xsl:call-template>

					</xsl:if>
				</xsl:variable>

				<xsl:variable name="maxlength_dt">
					<xsl:for-each select="mn:dl[1]">
						<xsl:call-template name="getMaxLength_dt"/>
					</xsl:for-each>
				</xsl:variable>

				<fo:table width="95%" table-layout="fixed">
					<xsl:if test="normalize-space($key_iso) = 'true'">
						<xsl:attribute name="font-size">10pt</xsl:attribute>
					</xsl:if>
					<xsl:choose>
						<!-- if there 'dl', then set same columns width -->
						<xsl:when test="xalan:nodeset($following_dl_colwidths)//column">
							<xsl:call-template name="setColumnWidth_dl">
								<xsl:with-param name="colwidths" select="$following_dl_colwidths"/>
								<xsl:with-param name="maxlength_dt" select="$maxlength_dt"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<fo:table-column column-width="5%"/>
							<fo:table-column column-width="95%"/>
						</xsl:otherwise>
					</xsl:choose>
					<fo:table-body>
						<!-- <xsl:for-each select="xalan:nodeset($references)//fn"> -->
						<xsl:for-each select="xalan:nodeset($references)//mn:fmt-fn-body">

							<xsl:variable name="reference" select="@reference"/>
							<!-- <xsl:if test="not(preceding-sibling::*[@reference = $reference])"> --> <!-- only unique reference puts in note-->
								<fo:table-row>
									<fo:table-cell>
										<fo:block>
											<fo:inline id="{@id}" xsl:use-attribute-sets="figure-fmt-fn-label-style">
												<!-- <xsl:attribute name="padding-right">0mm</xsl:attribute> -->
												<!-- <xsl:value-of select="@reference"/> -->
												<xsl:value-of select="normalize-space(.//mn:fmt-fn-label)"/>
											</fo:inline>

										</fo:block>
									</fo:table-cell>
									<fo:table-cell>
										<fo:block xsl:use-attribute-sets="figure-fn-body-style">
											<xsl:call-template name="refine_figure-fn-body-style"/>

											<!-- <xsl:copy-of select="./node()"/> -->
											<xsl:apply-templates/>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							<!-- </xsl:if> -->
						</xsl:for-each>
					</fo:table-body>
				</fo:table>
			</fo:block>
		</xsl:if>
	</xsl:template> <!-- figure_fn_display -->

	<xsl:template match="mn:figure//mn:fmt-fn-body//mn:fmt-fn-label"> <!-- mn:fmt-footnote-container/ -->
		<xsl:param name="process">false</xsl:param>
		<xsl:if test="$process = 'true'">
			<fo:inline xsl:use-attribute-sets="figure-fn-number-style" role="SKIP">
				<xsl:call-template name="refine_figure-fn-number-style"/>
				<xsl:attribute name="padding-right">0mm</xsl:attribute>

				<!-- tab is padding-right -->
				<xsl:apply-templates select=".//mn:tab">
					<xsl:with-param name="process">true</xsl:with-param>
				</xsl:apply-templates>

				<xsl:apply-templates/>

			</fo:inline>
		</xsl:if>
	</xsl:template> <!--  figure//fmt-fn-body//fmt-fn-label -->

	<xsl:template match="mn:figure//mn:fmt-fn-body//mn:fmt-fn-label//mn:tab" priority="5">
		<xsl:param name="process">false</xsl:param>
		<xsl:if test="$process = 'true'">

		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:figure//mn:fmt-fn-body//mn:fmt-fn-label//mn:sup" priority="5">
		<fo:inline xsl:use-attribute-sets="figure-fmt-fn-label-style" role="SKIP">
			<xsl:call-template name="refine_figure-fmt-fn-label-style"/>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<!-- added for https://github.com/metanorma/isodoc/issues/607 -->
	<!-- figure's footnote label -->
	<!-- figure/dl[@key = 'true']/dt/p/sup -->
	<xsl:template match="mn:figure/mn:dl[@key = 'true']/mn:dt/     mn:p[count(node()[normalize-space() != '']) = 1]/mn:sup" priority="3">
		<xsl:variable name="key_iso">
		</xsl:variable>
		<xsl:if test="normalize-space($key_iso) = 'true'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
		</xsl:if>
		<fo:inline xsl:use-attribute-sets="figure-fn-number-style figure-fmt-fn-label-style"> <!-- id="{@id}"  -->
			<xsl:call-template name="refine_figure-fn-number-style"/>
			<!-- <xsl:value-of select="@reference"/> -->
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<!-- ============================ -->
	<!-- END: figure's footnotes rendering -->
	<!-- ============================ -->

	<!-- caption for figure key and another caption, https://github.com/metanorma/isodoc/issues/607 -->
	<xsl:template match="mn:figure/mn:p[@keep-with-next = 'true' and mn:strong]" priority="3">
		<fo:block text-align="left" margin-bottom="12pt" keep-with-next="always" keep-with-previous="always">
			<xsl:call-template name="refine_figure_key_style"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template name="refine_figure_key_style">
	</xsl:template> <!-- refine_figure_key_style -->

	<!-- ====== -->
	<!-- figure    -->
	<!-- image    -->
	<!-- ====== -->

	<xsl:template match="mn:figure" name="figure">
		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>
		<xsl:call-template name="setNamedDestination"/>
		<fo:block-container id="{@id}" xsl:use-attribute-sets="figure-block-style">
			<xsl:call-template name="refine_figure-block-style"/>

			<xsl:call-template name="setTrackChangesStyles">
				<xsl:with-param name="isAdded" select="$isAdded"/>
				<xsl:with-param name="isDeleted" select="$isDeleted"/>
			</xsl:call-template>

			<!-- Example: Dimensions in millimeters -->
			<xsl:apply-templates select="mn:note[@type = 'units']"/>

			<xsl:variable name="show_figure_key_in_block_container">true
			</xsl:variable>

			<fo:block xsl:use-attribute-sets="figure-style" role="SKIP">

				<xsl:call-template name="refine_figure-style"/>

				<xsl:for-each select="mn:fmt-name"> <!-- set context -->
					<xsl:call-template name="setIDforNamedDestination"/>
				</xsl:for-each>

				<xsl:apply-templates select="node()[not(self::mn:fmt-name) and not(self::mn:note and @type = 'units')]"/>
			</fo:block>

			<xsl:if test="normalize-space($show_figure_key_in_block_container) = 'true'">
				<xsl:call-template name="showFigureKey"/>
			</xsl:if>
			<xsl:apply-templates select="mn:fmt-name"/> <!-- show figure's name AFTER image -->

		</fo:block-container>
	</xsl:template>

	<xsl:template name="showFigureKey">
		<xsl:for-each select="*[(self::mn:note and not(@type = 'units')) or self::mn:example]">
			<xsl:choose>
				<xsl:when test="self::mn:note">
					<xsl:call-template name="note"/>
				</xsl:when>
				<xsl:when test="self::mn:example">
					<xsl:call-template name="example"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<!-- TO DO: remove, now the figure fn in figure/dl/... https://github.com/metanorma/isodoc/issues/658 -->
		<xsl:call-template name="figure_fn_display"/>
	</xsl:template>

	<xsl:template match="mn:figure[@class = 'pseudocode']">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}">
			<xsl:apply-templates select="node()[not(self::mn:fmt-name)]"/>
		</fo:block>
		<xsl:apply-templates select="mn:fmt-name"/>
	</xsl:template>

	<xsl:template match="mn:figure[@class = 'pseudocode']//mn:p">
		<fo:block xsl:use-attribute-sets="figure-pseudocode-p-style">
			<xsl:call-template name="refine_figure-pseudocode-p-style"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- SOURCE: ... -->
	<!-- figure/source -->
	<xsl:template match="mn:figure/mn:fmt-source" priority="2">
		<xsl:call-template name="termsource"/>
	</xsl:template>

	<xsl:template match="mn:image">
		<xsl:param name="indent">0</xsl:param>
		<xsl:param name="logo_width"/>
		<xsl:variable name="isAdded" select="../@added"/>
		<xsl:variable name="isDeleted" select="../@deleted"/>
		<xsl:choose>
			<xsl:when test="ancestor::mn:fmt-title or not(parent::mn:figure) or parent::mn:p"> <!-- inline image ( 'image:path' in adoc, with one colon after image) -->
				<fo:inline padding-left="1mm" padding-right="1mm">
					<xsl:if test="not(parent::mn:figure) or parent::mn:p">
						<xsl:attribute name="padding-left">0mm</xsl:attribute>
						<xsl:attribute name="padding-right">0mm</xsl:attribute>
					</xsl:if>
					<xsl:variable name="src">
						<xsl:call-template name="image_src"/>
					</xsl:variable>

					<xsl:variable name="scale">
						<xsl:call-template name="getImageScale">
							<xsl:with-param name="indent" select="$indent"/>
						</xsl:call-template>
					</xsl:variable>

					<!-- debug scale='<xsl:value-of select="$scale"/>', indent='<xsl:value-of select="$indent"/>' -->

					<fo:external-graphic src="{$src}" fox:alt-text="Image {@alt}" vertical-align="middle">

						<xsl:if test="parent::mn:logo"> <!-- publisher's logo -->
							<xsl:attribute name="scaling">uniform</xsl:attribute>
							<xsl:choose>
								<xsl:when test="@width and not(@height)">
									<xsl:attribute name="width">100%</xsl:attribute>
									<xsl:attribute name="content-height">100%</xsl:attribute>
								</xsl:when>
								<xsl:when test="@height and not(@width)">
									<xsl:attribute name="height">100%</xsl:attribute>
									<xsl:attribute name="content-height"><xsl:value-of select="@height"/></xsl:attribute>
								</xsl:when>
								<xsl:when test="not(@width) and not(@height)">
									<xsl:attribute name="content-height">100%</xsl:attribute>
								</xsl:when>
							</xsl:choose>

							<xsl:if test="normalize-space($logo_width) != ''">
								<xsl:attribute name="width"><xsl:value-of select="$logo_width"/></xsl:attribute>
							</xsl:if>
							<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
							<xsl:attribute name="vertical-align">top</xsl:attribute>
						</xsl:if>

						<xsl:variable name="width">
							<xsl:call-template name="setImageWidth"/>
						</xsl:variable>
						<xsl:if test="$width != ''">
							<xsl:attribute name="width"><xsl:value-of select="$width"/></xsl:attribute>
						</xsl:if>
						<xsl:variable name="height">
							<xsl:call-template name="setImageHeight"/>
						</xsl:variable>
						<xsl:if test="$height != ''">
							<xsl:attribute name="height"><xsl:value-of select="$height"/></xsl:attribute>
						</xsl:if>

						<xsl:if test="$width = '' and $height = ''">
							<xsl:if test="number($scale) &lt; 100">
								<xsl:attribute name="content-width"><xsl:value-of select="number($scale)"/>%</xsl:attribute>
								<!-- <xsl:attribute name="content-width">scale-to-fit</xsl:attribute>
								<xsl:attribute name="content-height">100%</xsl:attribute>
								<xsl:attribute name="width">100%</xsl:attribute>
								<xsl:attribute name="scaling">uniform</xsl:attribute> -->
							</xsl:if>
						</xsl:if>

					</fo:external-graphic>

				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="image-style">

					<xsl:call-template name="refine_image-style"/>

					<xsl:variable name="src">
						<xsl:call-template name="image_src"/>
					</xsl:variable>

					<xsl:choose>
						<xsl:when test="$isDeleted = 'true'">
							<!-- enclose in svg -->
							<fo:instream-foreign-object fox:alt-text="Image {@alt}">
								<xsl:attribute name="width">100%</xsl:attribute>
								<xsl:attribute name="content-height">100%</xsl:attribute>
								<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
								<xsl:attribute name="scaling">uniform</xsl:attribute>

								<xsl:apply-templates select="." mode="cross_image"/>

							</fo:instream-foreign-object>
						</xsl:when>
						<xsl:otherwise>
							<!-- <fo:block>debug block image:
							<xsl:variable name="scale">
								<xsl:call-template name="getImageScale">
									<xsl:with-param name="indent" select="$indent"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:value-of select="concat('scale=', $scale,', indent=', $indent)"/>
							</fo:block> -->

							<fo:external-graphic src="{$src}" fox:alt-text="Image {@alt}">

								<xsl:choose>
									<!-- default -->
									<xsl:when test="((@width = 'auto' or @width = 'text-width' or @width = 'full-page-width' or @width = 'narrow') and @height = 'auto') or            (normalize-space(@width) = '' and normalize-space(@height) = '') ">
										<!-- add attribute for automatic scaling -->
										<xsl:variable name="image-graphic-style_attributes">
											<attributes xsl:use-attribute-sets="image-graphic-style"/>
										</xsl:variable>
										<xsl:copy-of select="xalan:nodeset($image-graphic-style_attributes)/attributes/@*"/>

										<xsl:call-template name="refine_image-graphic-style"/>

										<xsl:if test="not(@mimetype = 'image/svg+xml') and not(ancestor::mn:table)">
											<xsl:variable name="scale">
												<xsl:call-template name="getImageScale">
													<xsl:with-param name="indent" select="$indent"/>
												</xsl:call-template>
											</xsl:variable>

											<xsl:variable name="scaleRatio">1
											</xsl:variable>

											<xsl:if test="number($scale) &lt; 100">
												<xsl:attribute name="content-width"><xsl:value-of select="number($scale) * number($scaleRatio)"/>%</xsl:attribute>
											</xsl:if>
										</xsl:if>

									</xsl:when> <!-- default -->
									<xsl:otherwise>

										<xsl:variable name="width_height_">
											<attributes>
												<xsl:call-template name="setImageWidthHeight"/>
											</attributes>
										</xsl:variable>
										<xsl:variable name="width_height" select="xalan:nodeset($width_height_)"/>

										<xsl:copy-of select="$width_height/attributes/@*"/>

										<xsl:if test="$width_height/attributes/@content-width != '' and             $width_height/attributes/@content-height != ''">
											<xsl:attribute name="scaling">non-uniform</xsl:attribute>
										</xsl:if>

									</xsl:otherwise>
								</xsl:choose>

								<!-- 
								<xsl:if test="not(@mimetype = 'image/svg+xml') and (../mn:name or parent::mn:figure[@unnumbered = 'true']) and not(ancestor::mn:table)">
								-->

							</fo:external-graphic>
						</xsl:otherwise>
					</xsl:choose>

				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="setImageWidth">
		<xsl:if test="@width != '' and @width != 'auto' and @width != 'text-width' and @width != 'full-page-width' and @width != 'narrow'">
			<xsl:value-of select="@width"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="setImageHeight">
		<xsl:if test="@height != '' and @height != 'auto'">
			<xsl:value-of select="@height"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="setImageWidthHeight">
		<xsl:variable name="width">
			<xsl:call-template name="setImageWidth"/>
		</xsl:variable>
		<xsl:if test="$width != ''">
			<xsl:attribute name="content-width">
				<xsl:value-of select="$width"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:variable name="height">
			<xsl:call-template name="setImageHeight"/>
		</xsl:variable>
		<xsl:if test="$height != ''">
			<xsl:attribute name="content-height">
				<xsl:value-of select="$height"/>
			</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:template name="getImageSrc">
		<xsl:choose>
			<xsl:when test="not(starts-with(@src, 'data:'))">
				<xsl:call-template name="getImageSrcExternal"/>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="@src"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="getImageSrcExternal">
		<xsl:choose>
			<xsl:when test="@extracted = 'true'"> <!-- added in mn2pdf v1.97 -->
				<xsl:value-of select="@src"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="src_with_basepath" select="concat($basepath, @src)"/>
				<xsl:variable name="file_exists" select="normalize-space(java:exists(java:java.io.File.new($src_with_basepath)))"/>
				<xsl:choose>
					<xsl:when test="$file_exists = 'true'">
						<xsl:value-of select="$src_with_basepath"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@src"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="getImageScale">
		<xsl:param name="indent"/>
		<xsl:variable name="indent_left">
			<xsl:choose>
				<xsl:when test="$indent != ''"><xsl:value-of select="$indent"/></xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="img_src">
			<xsl:call-template name="getImageSrc"/>
		</xsl:variable>

		<xsl:variable name="image_width_effective">
			<xsl:value-of select="$width_effective - number($indent_left)"/>
		</xsl:variable>
		<xsl:variable name="image_height_effective" select="$height_effective - number($indent_left)"/>
		<!-- <xsl:message>width_effective=<xsl:value-of select="$width_effective"/></xsl:message>
		<xsl:message>indent_left=<xsl:value-of select="$indent_left"/></xsl:message>
		<xsl:message>image_width_effective=<xsl:value-of select="$image_width_effective"/></xsl:message> --> <!--  for <xsl:value-of select="ancestor::mn:p[1]/@id"/> -->
		<xsl:variable name="scale">
			<xsl:value-of select="java:org.metanorma.fop.utils.ImageUtils.getImageScale($img_src, $image_width_effective, $height_effective)"/>
		</xsl:variable>
		<!-- <xsl:message>scale=<xsl:value-of select="$scale"/></xsl:message> -->
		<xsl:value-of select="$scale"/>
	</xsl:template>

	<xsl:template name="image_src">
		<xsl:choose>
			<xsl:when test="@mimetype = 'image/svg+xml' and $images/images/image[@id = current()/@id]">
				<xsl:value-of select="$images/images/image[@id = current()/@id]/@src"/>
			</xsl:when>
			<!-- in WebP format, then convert image into PNG -->
			<xsl:when test="starts-with(@src, 'data:image/webp')">
				<xsl:variable name="src_png" select="java:org.metanorma.fop.utils.ImageUtils.convertWebPtoPNG(@src)"/>
				<xsl:value-of select="$src_png"/>
			</xsl:when>
			<xsl:when test="not(starts-with(@src, 'data:')) and        (java:endsWith(java:java.lang.String.new(@src), '.webp') or       java:endsWith(java:java.lang.String.new(@src), '.WEBP'))">
				<xsl:variable name="src_png" select="java:org.metanorma.fop.utils.ImageUtils.convertWebPtoPNG(@src)"/>
				<xsl:value-of select="concat('url(file:///',$basepath, $src_png, ')')"/>
			</xsl:when>
			<xsl:when test="not(starts-with(@src, 'data:'))">
				<xsl:variable name="src_external"><xsl:call-template name="getImageSrcExternal"/></xsl:variable>
				<xsl:variable name="file_protocol"><xsl:if test="not(starts-with($src_external, 'http:')) and not(starts-with($src_external, 'https:')) and not(starts-with($src_external, 'www.'))">file:///</xsl:if></xsl:variable>
				<xsl:value-of select="concat('url(', $file_protocol, $src_external, ')')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="@src"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mn:image" mode="cross_image">
		<xsl:choose>
			<xsl:when test="@mimetype = 'image/svg+xml' and $images/images/image[@id = current()/@id]">
				<xsl:variable name="src">
					<xsl:value-of select="$images/images/image[@id = current()/@id]/@src"/>
				</xsl:variable>
				<xsl:variable name="width" select="document($src)/@width"/>
				<xsl:variable name="height" select="document($src)/@height"/>
				<svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" style="enable-background:new 0 0 595.28 841.89;" height="{$height}" width="{$width}" viewBox="0 0 {$width} {$height}" y="0px" x="0px" id="Layer_1" version="1.1">
					<image xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="{$src}" style="overflow:visible;"/>
				</svg>
			</xsl:when>
			<xsl:when test="not(starts-with(@src, 'data:'))">
				<xsl:variable name="src_external"><xsl:call-template name="getImageSrcExternal"/></xsl:variable>
				<xsl:variable name="src" select="concat('url(file:///', $src_external, ')')"/>
				<xsl:variable name="file" select="java:java.io.File.new(@src)"/>
				<xsl:variable name="bufferedImage" select="java:javax.imageio.ImageIO.read($file)"/>
				<xsl:variable name="width" select="java:getWidth($bufferedImage)"/>
				<xsl:variable name="height" select="java:getHeight($bufferedImage)"/>
				<svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" style="enable-background:new 0 0 595.28 841.89;" height="{$height}" width="{$width}" viewBox="0 0 {$width} {$height}" y="0px" x="0px" id="Layer_1" version="1.1">
					<image xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="{$src}" style="overflow:visible;"/>
				</svg>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="base64String" select="substring-after(@src, 'base64,')"/>
				<xsl:variable name="decoder" select="java:java.util.Base64.getDecoder()"/>
				<xsl:variable name="fileContent" select="java:decode($decoder, $base64String)"/>
				<xsl:variable name="bis" select="java:java.io.ByteArrayInputStream.new($fileContent)"/>
				<xsl:variable name="bufferedImage" select="java:javax.imageio.ImageIO.read($bis)"/>
				<xsl:variable name="width" select="java:getWidth($bufferedImage)"/>
				<xsl:variable name="height" select="java:getHeight($bufferedImage)"/>
				<svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" style="enable-background:new 0 0 595.28 841.89;" height="{$height}" width="{$width}" viewBox="0 0 {$width} {$height}" y="0px" x="0px" id="Layer_1" version="1.1">
					<image xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="{@src}" height="{$height}" width="{$width}" style="overflow:visible;"/>
					<xsl:call-template name="svg_cross">
						<xsl:with-param name="width" select="$width"/>
						<xsl:with-param name="height" select="$height"/>
					</xsl:call-template>
				</svg>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<xsl:template name="svg_cross">
		<xsl:param name="width"/>
		<xsl:param name="height"/>
		<line xmlns="http://www.w3.org/2000/svg" x1="0" y1="0" x2="{$width}" y2="{$height}" style="stroke: rgb(255, 0, 0); stroke-width:4px; "/>
		<line xmlns="http://www.w3.org/2000/svg" x1="0" y1="{$height}" x2="{$width}" y2="0" style="stroke: rgb(255, 0, 0); stroke-width:4px; "/>
	</xsl:template>

	<!-- =================== -->
	<!-- SVG images processing -->
	<!-- =================== -->
	<xsl:variable name="figure_name_height">14</xsl:variable>
	<xsl:variable name="width_effective" select="$pageWidth - $marginLeftRight1 - $marginLeftRight2"/><!-- paper width minus margins -->
	<xsl:variable name="height_effective" select="$pageHeight - $marginTop - $marginBottom - $figure_name_height"/><!-- paper height minus margins and title height -->
	<xsl:variable name="image_dpi" select="96"/>
	<xsl:variable name="width_effective_px" select="$width_effective div 25.4 * $image_dpi"/>
	<xsl:variable name="height_effective_px" select="$height_effective div 25.4 * $image_dpi"/>

	<xsl:template match="mn:figure[not(mn:image) and *[local-name() = 'svg']]/mn:fmt-name/mn:bookmark" priority="2"/>
	<xsl:template match="mn:figure[not(mn:image)]/*[local-name() = 'svg']" priority="2" name="image_svg">
		<xsl:param name="name"/>

		<xsl:variable name="svg_content">
			<xsl:apply-templates select="." mode="svg_update"/>
		</xsl:variable>

		<xsl:variable name="alt-text">
			<xsl:choose>
				<xsl:when test="normalize-space(../mn:fmt-name) != ''">
					<xsl:value-of select="../mn:fmt-name"/>
				</xsl:when>
				<xsl:when test="normalize-space($name) != ''">
					<xsl:value-of select="$name"/>
				</xsl:when>
				<xsl:otherwise>Figure</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="isPrecedingTitle" select="normalize-space(ancestor::mn:figure/preceding-sibling::*[1][self::mn:fmt-title] and 1 = 1)"/>

		<xsl:choose>
			<xsl:when test=".//*[local-name() = 'a'][*[local-name() = 'rect'] or *[local-name() = 'polygon'] or *[local-name() = 'circle'] or *[local-name() = 'ellipse']]">
				<fo:block>
					<xsl:variable name="width" select="@width"/>
					<xsl:variable name="height" select="@height"/>

					<xsl:variable name="scale_x">
						<xsl:choose>
							<xsl:when test="$width &gt; $width_effective_px">
								<xsl:value-of select="$width_effective_px div $width"/>
							</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="scale_y">
						<xsl:choose>
							<xsl:when test="$height * $scale_x &gt; $height_effective_px">
								<xsl:value-of select="$height_effective_px div ($height * $scale_x)"/>
							</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="scale">
						<xsl:choose>
							<xsl:when test="$scale_y != 1">
								<xsl:value-of select="$scale_x * $scale_y"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$scale_x"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="width_scale" select="round($width * $scale)"/>
					<xsl:variable name="height_scale" select="round($height * $scale)"/>

					<fo:table table-layout="fixed" width="100%">
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-column column-width="{$width_scale}px"/>
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell column-number="2">
									<fo:block>
										<fo:block-container width="{$width_scale}px" height="{$height_scale}px">
											<xsl:if test="../mn:fmt-name/mn:bookmark">
												<fo:block line-height="0" font-size="0">
													<xsl:for-each select="../mn:fmt-name/mn:bookmark">
														<xsl:call-template name="bookmark"/>
													</xsl:for-each>
												</fo:block>
											</xsl:if>
											<fo:block text-depth="0" line-height="0" font-size="0">

												<fo:instream-foreign-object fox:alt-text="{$alt-text}">
													<xsl:attribute name="width">100%</xsl:attribute>
													<xsl:attribute name="content-height">100%</xsl:attribute>
													<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
													<xsl:attribute name="scaling">uniform</xsl:attribute>

													<xsl:apply-templates select="xalan:nodeset($svg_content)" mode="svg_remove_a"/>
												</fo:instream-foreign-object>
											</fo:block>

											<xsl:apply-templates select=".//*[local-name() = 'a'][*[local-name() = 'rect'] or *[local-name() = 'polygon'] or *[local-name() = 'circle'] or *[local-name() = 'ellipse']]" mode="svg_imagemap_links">
												<xsl:with-param name="scale" select="$scale"/>
											</xsl:apply-templates>
										</fo:block-container>
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
				</fo:block>

			</xsl:when>
			<xsl:otherwise>

				<xsl:variable name="image_class" select="ancestor::mn:image/@class"/>
				<xsl:variable name="ancestor_table_cell" select="normalize-space(ancestor::*[local-name() = 'td'] or ancestor::*[local-name() = 'th'])"/>

				<xsl:variable name="element">
					<xsl:choose>
						<xsl:when test="ancestor::*[local-name() = 'tr'] and $isGenerateTableIF = 'true'">
							<fo:inline xsl:use-attribute-sets="image-style" text-align="left"/>
						</xsl:when>
						<xsl:when test="not(ancestor::mn:figure)">
							<fo:inline xsl:use-attribute-sets="image-style" text-align="left"/>
						</xsl:when>
						<xsl:otherwise>
							<fo:block xsl:use-attribute-sets="image-style">
								<xsl:if test="ancestor::mn:dt">
									<xsl:attribute name="text-align">left</xsl:attribute>
								</xsl:if>
							</fo:block>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:for-each select="xalan:nodeset($element)/*">
					<xsl:copy>
						<xsl:copy-of select="@*"/>
					<!-- <fo:block xsl:use-attribute-sets="image-style"> -->
						<fo:instream-foreign-object fox:alt-text="{$alt-text}">

							<xsl:choose>
								<xsl:when test="$image_class = 'corrigenda-tag'">
									<xsl:attribute name="fox:alt-text">CorrigendaTag</xsl:attribute>
									<xsl:attribute name="baseline-shift">-10%</xsl:attribute>
									<xsl:if test="$ancestor_table_cell = 'true'">
										<xsl:attribute name="baseline-shift">-25%</xsl:attribute>
									</xsl:if>
									<xsl:attribute name="height">3.5mm</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:if test="$isGenerateTableIF = 'false'">
										<xsl:attribute name="width">100%</xsl:attribute>
									</xsl:if>
									<xsl:attribute name="content-height">100%</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>

							<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
							<xsl:variable name="svg_width_" select="xalan:nodeset($svg_content)/*/@width"/>
							<xsl:variable name="svg_width" select="number(translate($svg_width_, 'px', ''))"/>
							<xsl:variable name="svg_height_" select="xalan:nodeset($svg_content)/*/@height"/>
							<xsl:variable name="svg_height" select="number(translate($svg_height_, 'px', ''))"/>

							<!-- Example: -->
							<!-- effective height 297 - 27.4 - 13 =  256.6 -->
							<!-- effective width 210 - 12.5 - 25 = 172.5 -->
							<!-- effective height / width = 1.48, 1.4 - with title -->

							<xsl:variable name="scale_x">
								<xsl:choose>
									<xsl:when test="$svg_width &gt; $width_effective_px">
										<xsl:value-of select="$width_effective_px div $svg_width"/>
									</xsl:when>
									<xsl:otherwise>1</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="scale_y">
								<xsl:choose>
									<xsl:when test="$svg_height * $scale_x &gt; $height_effective_px">
										<xsl:variable name="height_effective_px_">
											<xsl:choose>
												<!-- title is 'keep-with-next' with following figure -->
												<xsl:when test="$isPrecedingTitle = 'true'"><xsl:value-of select="$height_effective_px - 80"/></xsl:when>
												<xsl:otherwise><xsl:value-of select="$height_effective_px"/></xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
										<xsl:value-of select="$height_effective_px_ div ($svg_height * $scale_x)"/>
									</xsl:when>
									<xsl:otherwise>1</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>

							 <!-- for images with big height -->
							<!-- <xsl:if test="$svg_height &gt; ($svg_width * 1.4)">
								<xsl:variable name="width" select="(($svg_width * 1.4) div $svg_height) * 100"/>
								<xsl:attribute name="width"><xsl:value-of select="$width"/>%</xsl:attribute>
							</xsl:if> -->
							<xsl:attribute name="scaling">uniform</xsl:attribute>

							<xsl:if test="$scale_y != 1">
								<xsl:attribute name="content-height"><xsl:value-of select="round($scale_x * $scale_y * 100)"/>%</xsl:attribute>
							</xsl:if>

							<xsl:copy-of select="$svg_content"/>
						</fo:instream-foreign-object>
					<!-- </fo:block> -->
					</xsl:copy>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ============== -->
	<!-- svg_update     -->
	<!-- ============== -->
	<xsl:template match="@*|node()" mode="svg_update">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="svg_update"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:image/@href" mode="svg_update">
		<xsl:attribute name="href" namespace="http://www.w3.org/1999/xlink">
			<xsl:value-of select="."/>
		</xsl:attribute>
	</xsl:template>

	<xsl:variable name="regex_starts_with_digit">^[0-9].*</xsl:variable>

	<xsl:template match="*[local-name() = 'svg'][not(@width and @height)]" mode="svg_update">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="svg_update"/>
			<xsl:variable name="viewbox_">
				<xsl:call-template name="split">
					<xsl:with-param name="pText" select="@viewBox"/>
					<xsl:with-param name="sep" select="' '"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="viewbox" select="xalan:nodeset($viewbox_)"/>
			<xsl:variable name="width" select="normalize-space($viewbox//mnx:item[3])"/>
			<xsl:variable name="height" select="normalize-space($viewbox//mnx:item[4])"/>

			<xsl:variable name="parent_image_width" select="normalize-space(ancestor::*[1][self::mn:image]/@width)"/>
			<xsl:variable name="parent_image_height" select="normalize-space(ancestor::*[1][self::mn:image]/@height)"/>

			<xsl:attribute name="width">
				<xsl:choose>
					<!-- width is non 'auto', 'text-width', 'full-page-width' or 'narrow' -->
					<xsl:when test="$parent_image_width != '' and normalize-space(java:matches(java:java.lang.String.new($parent_image_width), $regex_starts_with_digit)) = 'true'"><xsl:value-of select="$parent_image_width"/></xsl:when>
					<xsl:when test="$width != ''">
						<xsl:value-of select="round($width)"/>
					</xsl:when>
					<xsl:otherwise>400</xsl:otherwise> <!-- default width -->
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="height">
				<xsl:choose>
					<!-- height non 'auto', 'text-width', 'full-page-width' or 'narrow' -->
					<xsl:when test="$parent_image_height != '' and normalize-space(java:matches(java:java.lang.String.new($parent_image_height), $regex_starts_with_digit)) = 'true'"><xsl:value-of select="$parent_image_height"/></xsl:when>
					<xsl:when test="$height != ''">
						<xsl:value-of select="round($height)"/>
					</xsl:when>
					<xsl:otherwise>400</xsl:otherwise> <!-- default height -->
				</xsl:choose>
			</xsl:attribute>

			<xsl:apply-templates mode="svg_update"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name() = 'svg']/@width" mode="svg_update">
		<!-- image[@width]/svg -->
		<xsl:variable name="parent_image_width" select="normalize-space(ancestor::*[2][self::mn:image]/@width)"/>
		<xsl:attribute name="width">
			<xsl:choose>
				<xsl:when test="$parent_image_width != '' and normalize-space(java:matches(java:java.lang.String.new($parent_image_width), $regex_starts_with_digit)) = 'true'"><xsl:value-of select="$parent_image_width"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>

	<xsl:template match="*[local-name() = 'svg']/@height" mode="svg_update">
		<!-- image[@height]/svg -->
		<xsl:variable name="parent_image_height" select="normalize-space(ancestor::*[2][self::mn:image]/@height)"/>
		<xsl:attribute name="height">
			<xsl:choose>
				<xsl:when test="$parent_image_height != '' and normalize-space(java:matches(java:java.lang.String.new($parent_image_height), $regex_starts_with_digit)) = 'true'"><xsl:value-of select="$parent_image_height"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>

	<!-- regex for 'display: inline-block;' -->
	<xsl:variable name="regex_svg_style_notsupported">display(\s|\h)*:(\s|\h)*inline-block(\s|\h)*;</xsl:variable>
	<xsl:template match="*[local-name() = 'svg']//*[local-name() = 'style']/text()" mode="svg_update">
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.), $regex_svg_style_notsupported, '')"/>
	</xsl:template>

	<!-- replace
			stroke="rgba(r, g, b, alpha)" to 
			stroke="rgb(r,g,b)" stroke-opacity="alpha", and
			fill="rgba(r, g, b, alpha)" to 
			fill="rgb(r,g,b)" fill-opacity="alpha" -->
	<xsl:template match="@*[local-name() = 'stroke' or local-name() = 'fill'][starts-with(normalize-space(.), 'rgba')]" mode="svg_update">
		<xsl:variable name="components_">
			<xsl:call-template name="split">
				<xsl:with-param name="pText" select="substring-before(substring-after(., '('), ')')"/>
				<xsl:with-param name="sep" select="','"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="components" select="xalan:nodeset($components_)"/>
		<xsl:variable name="att_name" select="local-name()"/>
		<xsl:attribute name="{$att_name}"><xsl:value-of select="concat('rgb(', $components/mnx:item[1], ',', $components/mnx:item[2], ',', $components/mnx:item[3], ')')"/></xsl:attribute>
		<xsl:attribute name="{$att_name}-opacity"><xsl:value-of select="$components/mnx:item[4]"/></xsl:attribute>
	</xsl:template>

	<!-- ============== -->
	<!-- END: svg_update -->
	<!-- ============== -->

	<!-- image with svg and emf -->
	<xsl:template match="mn:figure/mn:image[*[local-name() = 'svg']]" priority="3">
		<xsl:variable name="name" select="ancestor::mn:figure/mn:fmt-name"/>
		<xsl:for-each select="*[local-name() = 'svg']">
			<xsl:call-template name="image_svg">
				<xsl:with-param name="name" select="$name"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<!-- For the structures like: <dt><image src="" mimetype="image/svg+xml" height="" width=""><svg xmlns="http://www.w3.org/2000/svg" ... -->
	<xsl:template match="*[not(self::mn:figure)]/mn:image[*[local-name() = 'svg']]" priority="3">
		<xsl:for-each select="*[local-name() = 'svg']">
			<xsl:call-template name="image_svg"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="mn:figure/mn:image[@mimetype = 'image/svg+xml' and @src[not(starts-with(., 'data:image/'))]]" priority="2">
		<xsl:variable name="svg_content" select="document(@src)"/>
		<xsl:variable name="name" select="ancestor::mn:figure/mn:fmt-name"/>
		<xsl:for-each select="xalan:nodeset($svg_content)/node()">
			<xsl:call-template name="image_svg">
				<xsl:with-param name="name" select="$name"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="@*|node()" mode="svg_remove_a">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="svg_remove_a"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name() = 'a']" mode="svg_remove_a">
		<xsl:apply-templates mode="svg_remove_a"/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'a']" mode="svg_imagemap_links">
		<xsl:param name="scale"/>
		<xsl:variable name="dest">
			<xsl:choose>
				<xsl:when test="starts-with(@href, '#')">
					<xsl:value-of select="substring-after(@href, '#')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@href"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:for-each select="./*[local-name() = 'rect']">
			<xsl:call-template name="insertSVGMapLink">
				<xsl:with-param name="left" select="floor(@x * $scale)"/>
				<xsl:with-param name="top" select="floor(@y * $scale)"/>
				<xsl:with-param name="width" select="floor(@width * $scale)"/>
				<xsl:with-param name="height" select="floor(@height * $scale)"/>
				<xsl:with-param name="dest" select="$dest"/>
			</xsl:call-template>
		</xsl:for-each>

		<xsl:for-each select="./*[local-name() = 'polygon']">
			<xsl:variable name="points">
				<xsl:call-template name="split">
					<xsl:with-param name="pText" select="@points"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="x_coords">
				<xsl:for-each select="xalan:nodeset($points)//mnx:item[position() mod 2 = 1]">
					<xsl:sort select="." data-type="number"/>
					<x><xsl:value-of select="."/></x>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="y_coords">
				<xsl:for-each select="xalan:nodeset($points)//mnx:item[position() mod 2 = 0]">
					<xsl:sort select="." data-type="number"/>
					<y><xsl:value-of select="."/></y>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="x" select="xalan:nodeset($x_coords)//x[1]"/>
			<xsl:variable name="y" select="xalan:nodeset($y_coords)//y[1]"/>
			<xsl:variable name="width" select="xalan:nodeset($x_coords)//x[last()] - $x"/>
			<xsl:variable name="height" select="xalan:nodeset($y_coords)//y[last()] - $y"/>
			<xsl:call-template name="insertSVGMapLink">
				<xsl:with-param name="left" select="floor($x * $scale)"/>
				<xsl:with-param name="top" select="floor($y * $scale)"/>
				<xsl:with-param name="width" select="floor($width * $scale)"/>
				<xsl:with-param name="height" select="floor($height * $scale)"/>
				<xsl:with-param name="dest" select="$dest"/>
			</xsl:call-template>
		</xsl:for-each>

		<xsl:for-each select="./*[local-name() = 'circle']">
			<xsl:call-template name="insertSVGMapLink">
				<xsl:with-param name="left" select="floor((@cx - @r) * $scale)"/>
				<xsl:with-param name="top" select="floor((@cy - @r) * $scale)"/>
				<xsl:with-param name="width" select="floor(@r * 2 * $scale)"/>
				<xsl:with-param name="height" select="floor(@r * 2 * $scale)"/>
				<xsl:with-param name="dest" select="$dest"/>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:for-each select="./*[local-name() = 'ellipse']">
			<xsl:call-template name="insertSVGMapLink">
				<xsl:with-param name="left" select="floor((@cx - @rx) * $scale)"/>
				<xsl:with-param name="top" select="floor((@cy - @ry) * $scale)"/>
				<xsl:with-param name="width" select="floor(@rx * 2 * $scale)"/>
				<xsl:with-param name="height" select="floor(@ry * 2 * $scale)"/>
				<xsl:with-param name="dest" select="$dest"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="insertSVGMapLink">
		<xsl:param name="left"/>
		<xsl:param name="top"/>
		<xsl:param name="width"/>
		<xsl:param name="height"/>
		<xsl:param name="dest"/>
		<fo:block-container position="absolute" left="{$left}px" top="{$top}px" width="{$width}px" height="{$height}px">
		 <fo:block font-size="1pt">
			<xsl:call-template name="insert_basic_link">
				<xsl:with-param name="element">
					<fo:basic-link internal-destination="{$dest}" fox:alt-text="svg link">
						<fo:inline-container inline-progression-dimension="100%">
							<fo:block-container height="{$height - 1}px" width="100%">
								<!-- DEBUG <xsl:if test="local-name()='polygon'">
									<xsl:attribute name="background-color">magenta</xsl:attribute>
								</xsl:if> -->
							<fo:block> </fo:block></fo:block-container>
						</fo:inline-container>
					</fo:basic-link>
				</xsl:with-param>
			</xsl:call-template>
		 </fo:block>
	  </fo:block-container>
	</xsl:template>
	<!-- =================== -->
	<!-- End SVG images processing -->
	<!-- =================== -->

	<!-- ignore emf processing (Apache FOP doesn't support EMF) -->
	<xsl:template match="mn:emf"/>

	<!-- figure/name -->
	<xsl:template match="mn:figure/mn:fmt-name |         mn:image/mn:fmt-name">
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="figure-name-style">

				<xsl:call-template name="refine_figure-name-style"/>

				<xsl:apply-templates/>
			</fo:block>
		</xsl:if>
	</xsl:template>

	<!-- figure/fn -->
	<xsl:template match="mn:figure[not(@class = 'pseudocode')]/mn:fn" priority="2"/>
	<!-- figure/note -->
	<xsl:template match="mn:figure[not(@class = 'pseudocode')]/mn:note" priority="2"/>
	<!-- figure/example -->
	<xsl:template match="mn:figure[not(@class = 'pseudocode')]/mn:example" priority="2"/>

	<!-- figure/note[@type = 'units'] -->
	<!-- image/note[@type = 'units'] -->
	<xsl:template match="mn:figure/mn:note[@type = 'units'] |         mn:image/mn:note[@type = 'units']" priority="2">
		<fo:block text-align="right" keep-with-next="always">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- Formula's styles -->
	<xsl:attribute-set name="formula-style">
		<xsl:attribute name="margin-top">6pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
	</xsl:attribute-set> <!-- formula-style -->

	<xsl:template name="refine_formula-style">
	</xsl:template>

	<xsl:attribute-set name="formula-stem-block-style">
		<xsl:attribute name="text-align">center</xsl:attribute>
	</xsl:attribute-set> <!-- formula-stem-block-style -->

	<xsl:template name="refine_formula-stem-block-style">
	</xsl:template> <!-- refine_formula-stem-block-style -->

	<xsl:attribute-set name="formula-stem-number-style">
		<xsl:attribute name="text-align">right</xsl:attribute>
	</xsl:attribute-set> <!-- formula-stem-number-style -->
	<!-- End Formula's styles -->

	<xsl:template name="refine_formula-stem-number-style">
	</xsl:template>

	<xsl:attribute-set name="mathml-style">
		<xsl:attribute name="font-family">STIX Two Math</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_mathml-style">
	</xsl:template>

	<!-- ====== -->
	<!-- formula  -->
	<!-- ====== -->
	<xsl:template match="mn:formula" name="formula">
		<fo:block-container margin-left="0mm" role="SKIP">
			<xsl:if test="parent::mn:note">
				<xsl:attribute name="margin-left">
					<xsl:choose>
						<xsl:when test="not(ancestor::mn:table)"><xsl:value-of select="$note-body-indent"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
			<fo:block-container margin-left="0mm" role="SKIP">
				<xsl:call-template name="setNamedDestination"/>
				<fo:block id="{@id}">
					<xsl:apply-templates select="node()[not(self::mn:fmt-name)]"/> <!-- formula's number will be process in 'stem' template -->
				</fo:block>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>

	<xsl:template match="mn:formula/mn:dt/mn:fmt-stem">
		<fo:inline>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="mn:fmt-admitted/mn:fmt-stem">
		<fo:inline>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="mn:formula/mn:fmt-name"> <!-- show in 'stem' template -->
		<!-- https://github.com/metanorma/isodoc/issues/607 
		<xsl:if test="normalize-space() != ''">
			<xsl:text>(</xsl:text><xsl:apply-templates /><xsl:text>)</xsl:text>
		</xsl:if> -->
		<xsl:apply-templates/>
	</xsl:template>

	<!-- stem inside formula with name (with formula's number) -->
	<xsl:template match="mn:formula[mn:fmt-name]/mn:fmt-stem">
		<fo:block xsl:use-attribute-sets="formula-style">

			<xsl:call-template name="refine_formula-style"/>

			<fo:table table-layout="fixed" width="100%">
				<fo:table-column column-width="95%"/>
				<fo:table-column column-width="5%"/>
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell display-align="center">
							<fo:block xsl:use-attribute-sets="formula-stem-block-style" role="SKIP">

								<xsl:call-template name="refine_formula-stem-block-style"/>

								<xsl:apply-templates/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center">

							<fo:block xsl:use-attribute-sets="formula-stem-number-style" role="SKIP">

								<xsl:for-each select="../mn:fmt-name">
									<xsl:call-template name="setIDforNamedDestination"/>
								</xsl:for-each>

								<xsl:call-template name="refine_formula-stem-number-style"/>

								<xsl:apply-templates select="../mn:fmt-name"/>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>

	<!-- stem inside formula without name (without formula's number) -->
	<xsl:template match="mn:formula[not(mn:fmt-name)]/mn:fmt-stem">
		<fo:block xsl:use-attribute-sets="formula-style">
			<fo:block xsl:use-attribute-sets="formula-stem-block-style">
				<xsl:apply-templates/>
			</fo:block>
		</fo:block>
	</xsl:template>

	<!-- ====== -->
	<!-- ====== -->

	<!-- ignore 'p' with 'where' in formula, before 'dl' -->
	<xsl:template match="mn:formula/*[self::mn:p and @keep-with-next = 'true' and following-sibling::*[1][self::mn:dl]]"/>

	<!-- ======================================= -->
	<!-- math -->
	<!-- ======================================= -->
	<xsl:template match="mn:stem[following-sibling::*[1][self::mn:fmt-stem]]"/> <!-- for tablesonly.xml generated by mn2pdf -->

	<xsl:template match="mathml:math">
		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>

		<fo:inline xsl:use-attribute-sets="mathml-style">

			<!-- DEBUG -->
			<!-- <xsl:copy-of select="ancestor::mn:stem/@font-family"/> -->

			<xsl:call-template name="refine_mathml-style"/>

			<xsl:if test="$isGenerateTableIF = 'true' and ancestor::*[local-name() = 'td' or local-name() = 'th' or local-name() = 'dl'] and not(following-sibling::node()[not(self::comment())][normalize-space() != ''])"> <!-- math in table cell, and math is last element -->
				<!-- <xsl:attribute name="padding-right">1mm</xsl:attribute> -->
			</xsl:if>

			<xsl:call-template name="setTrackChangesStyles">
				<xsl:with-param name="isAdded" select="$isAdded"/>
				<xsl:with-param name="isDeleted" select="$isDeleted"/>
			</xsl:call-template>

			<xsl:if test="$add_math_as_text = 'true'">
				<!-- insert helper tag -->
				<!-- set unique font-size (fiction) -->
				<xsl:variable name="font-size_sfx"><xsl:number level="any"/></xsl:variable>
				<fo:inline color="white" font-size="1.{$font-size_sfx}pt" font-style="normal" font-weight="normal"><xsl:value-of select="$zero_width_space"/></fo:inline> <!-- zero width space -->
			</xsl:if>

			<xsl:variable name="mathml_content">
				<xsl:apply-templates select="." mode="mathml_actual_text"/>
			</xsl:variable>
			<xsl:call-template name="mathml_instream_object">
				<xsl:with-param name="mathml_content" select="$mathml_content"/>
			</xsl:call-template>

		</fo:inline>
	</xsl:template>

	<xsl:template name="getMathml_comment_text">
		<xsl:variable name="comment_text_following" select="following-sibling::node()[1][self::comment()]"/>
		<xsl:variable name="comment_text_">
			<xsl:choose>
				<xsl:when test="normalize-space($comment_text_following) != ''">
					<xsl:value-of select="$comment_text_following"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(translate(.,' ⁢','  '))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="comment_text_2" select="java:org.metanorma.fop.Util.unescape($comment_text_)"/>
		<xsl:variable name="comment_text" select="java:trim(java:java.lang.String.new($comment_text_2))"/>
		<xsl:value-of select="$comment_text"/>
	</xsl:template>

	<xsl:template match="mn:asciimath">
		<xsl:param name="process" select="'false'"/>
		<xsl:if test="$process = 'true'">
			<xsl:apply-templates/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:latexmath"/>

	<xsl:template name="getMathml_asciimath_text">
		<xsl:variable name="asciimath" select="../mn:asciimath"/>
		<xsl:variable name="latexmath">
		</xsl:variable>
		<xsl:variable name="asciimath_text_following">
			<xsl:choose>
				<xsl:when test="normalize-space($latexmath) != ''">
					<xsl:value-of select="$latexmath"/>
				</xsl:when>
				<xsl:when test="normalize-space($asciimath) != ''">
					<xsl:value-of select="$asciimath"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="following-sibling::node()[1][self::comment()]"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="asciimath_text_">
			<xsl:choose>
				<xsl:when test="normalize-space($asciimath_text_following) != ''">
					<xsl:value-of select="$asciimath_text_following"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(translate(.,' ⁢','  '))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="asciimath_text_2" select="java:org.metanorma.fop.Util.unescape($asciimath_text_)"/>
		<xsl:variable name="asciimath_text" select="java:trim(java:java.lang.String.new($asciimath_text_2))"/>
		<xsl:value-of select="$asciimath_text"/>
	</xsl:template>

	<xsl:template name="mathml_instream_object">
		<xsl:param name="asciimath_text"/>
		<xsl:param name="mathml_content"/>

		<xsl:variable name="asciimath_text_">
			<xsl:choose>
				<xsl:when test="normalize-space($asciimath_text) != ''"><xsl:value-of select="$asciimath_text"/></xsl:when>
				<!-- <xsl:otherwise><xsl:call-template name="getMathml_comment_text"/></xsl:otherwise> -->
				<xsl:otherwise><xsl:call-template name="getMathml_asciimath_text"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="mathml">
			<xsl:apply-templates select="." mode="mathml"/>
		</xsl:variable>

		<fo:instream-foreign-object fox:alt-text="Math" fox:actual-text="Math">

			<xsl:call-template name="refine_mathml_insteam_object_style"/>

			<xsl:if test="$isGenerateTableIF = 'false'">
				<!-- put MathML in Actual Text -->
				<!-- DEBUG: mathml_content=<xsl:value-of select="$mathml_content"/> -->
				<xsl:attribute name="fox:actual-text">
					<xsl:value-of select="$mathml_content"/>
				</xsl:attribute>

				<!-- <xsl:if test="$add_math_as_text = 'true'"> -->
				<xsl:if test="normalize-space($asciimath_text_) != ''">
				<!-- put Mathin Alternate Text -->
					<xsl:attribute name="fox:alt-text">
						<xsl:value-of select="$asciimath_text_"/>
					</xsl:attribute>
				</xsl:if>
				<!-- </xsl:if> -->
			</xsl:if>

			<xsl:copy-of select="xalan:nodeset($mathml)"/>

		</fo:instream-foreign-object>
	</xsl:template>

	<xsl:template name="refine_mathml_insteam_object_style">
	</xsl:template> <!-- refine_mathml_insteam_object_style -->

	<xsl:template match="mathml:*" mode="mathml_actual_text">
		<!-- <xsl:text>a+b</xsl:text> -->
		<xsl:text>&lt;</xsl:text>
		<xsl:value-of select="local-name()"/>
		<xsl:if test="local-name() = 'math'">
			<xsl:text> xmlns="http://www.w3.org/1998/Math/MathML"</xsl:text>
		</xsl:if>
		<xsl:for-each select="@*">
			<xsl:text> </xsl:text>
			<xsl:value-of select="local-name()"/>
			<xsl:text>="</xsl:text>
			<xsl:value-of select="."/>
			<xsl:text>"</xsl:text>
		</xsl:for-each>
		<xsl:text>&gt;</xsl:text>
		<xsl:apply-templates mode="mathml_actual_text"/>
		<xsl:text>&lt;/</xsl:text>
		<xsl:value-of select="local-name()"/>
		<xsl:text>&gt;</xsl:text>
	</xsl:template>

	<xsl:template match="text()" mode="mathml_actual_text">
		<xsl:value-of select="normalize-space()"/>
	</xsl:template>

	<xsl:template match="@*|node()" mode="mathml">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="mathml"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mathml:mtext" mode="mathml">
		<xsl:copy>
			<!-- replace start and end spaces to non-break space -->
			<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),'(^ )|( $)',' ')"/>
		</xsl:copy>
	</xsl:template>

	<!-- <xsl:template match="mathml:mi[. = ',' and not(following-sibling::*[1][local-name() = 'mtext' and text() = '&#xa0;'])]" mode="mathml">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="mathml"/>
		</xsl:copy>
		<xsl:choose>
			if in msub, then don't add space
			<xsl:when test="ancestor::mathml:mrow[parent::mathml:msub and preceding-sibling::*[1][self::mathml:mrow]]"></xsl:when>
			if next char in digit,  don't add space
			<xsl:when test="translate(substring(following-sibling::*[1]/text(),1,1),'0123456789','') = ''"></xsl:when>
			<xsl:otherwise>
				<mathml:mspace width="0.5ex"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> -->

	<xsl:template match="mathml:math/*[local-name()='unit']" mode="mathml"/>
	<xsl:template match="mathml:math/*[local-name()='prefix']" mode="mathml"/>
	<xsl:template match="mathml:math/*[local-name()='dimension']" mode="mathml"/>
	<xsl:template match="mathml:math/*[local-name()='quantity']" mode="mathml"/>

	<!-- patch: slash in the mtd wrong rendering -->
	<xsl:template match="mathml:mtd/mathml:mo/text()[. = '/']" mode="mathml">
		<xsl:value-of select="."/><xsl:value-of select="$zero_width_space"/>
	</xsl:template>

	<!-- special case for:
		<math xmlns="http://www.w3.org/1998/Math/MathML">
			<mstyle displaystyle="true">
				<msup>
					<mi color="#00000000">C</mi>
					<mtext>R</mtext>
				</msup>
				<msubsup>
					<mtext>C</mtext>
					<mi>n</mi>
					<mi>k</mi>
				</msubsup>
			</mstyle>
		</math>
	-->
	<xsl:template match="mathml:msup/mathml:mi[. = '‌' or . = ''][not(preceding-sibling::*)][following-sibling::mathml:mtext]" mode="mathml">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:variable name="next_mtext" select="ancestor::mathml:msup/following-sibling::*[1][self::mathml:msubsup or self::mathml:msub or self::mathml:msup]/mathml:mtext"/>
			<xsl:if test="string-length($next_mtext) != ''">
				<xsl:attribute name="color">#00000000</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
			<xsl:value-of select="$next_mtext"/>
		</xsl:copy>
	</xsl:template>

	<!-- special case for:
				<msup>
					<mtext/>
					<mn>1</mn>
				</msup>
		convert to (add mspace after mtext and enclose them into mrow):
			<msup>
				<mrow>
					<mtext/>
					<mspace height="1.47ex"/>
				</mrow>
				<mn>1</mn>
			</msup>
	-->
	<xsl:template match="mathml:msup/mathml:mtext[not(preceding-sibling::*)]" mode="mathml">
		<mathml:mrow>
			<xsl:copy-of select="."/>
			<mathml:mspace height="1.47ex"/>
		</mathml:mrow>
	</xsl:template>

	<!-- add space around vertical line -->
	<xsl:template match="mathml:mo[normalize-space(text()) = '|']" mode="mathml">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="mathml"/>
			<xsl:if test="not(@lspace)">
				<xsl:attribute name="lspace">0.2em</xsl:attribute>
			</xsl:if>
			<xsl:if test="not(@rspace) and not(following-sibling::*[1][self::mathml:mo and normalize-space(text()) = '|'])">
				<xsl:attribute name="rspace">0.2em</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates mode="mathml"/>
		</xsl:copy>
	</xsl:template>

	<!-- decrease fontsize for 'Circled Times' char -->
	<xsl:template match="mathml:mo[normalize-space(text()) = '⊗']" mode="mathml">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="mathml"/>
			<xsl:if test="not(@fontsize)">
				<xsl:attribute name="fontsize">55%</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates mode="mathml"/>
		</xsl:copy>
	</xsl:template>

	<!-- increase space before '(' -->
	<xsl:template match="mathml:mo[normalize-space(text()) = '(']" mode="mathml">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="mathml"/>
			<xsl:if test="(preceding-sibling::* and not(preceding-sibling::*[1][self::mathml:mo])) or (../preceding-sibling::* and not(../preceding-sibling::*[1][self::mathml:mo]))">
				<xsl:if test="not(@lspace)">
					<xsl:attribute name="lspace">0.4em</xsl:attribute>
					<xsl:choose>
						<xsl:when test="preceding-sibling::*[1][self::mathml:mi or self::mathml:mstyle]">
							<xsl:attribute name="lspace">0.2em</xsl:attribute>
						</xsl:when>
						<xsl:when test="../preceding-sibling::*[1][self::mathml:mi or self::mathml:mstyle]">
							<xsl:attribute name="lspace">0.2em</xsl:attribute>
						</xsl:when>
					</xsl:choose>
				</xsl:if>
			</xsl:if>
			<xsl:apply-templates mode="mathml"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="@*|node()" mode="mathml_linebreak">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="mathml_linebreak"/>
		</xsl:copy>
	</xsl:template>

	<!-- split math into two math -->
	<xsl:template match="mathml:mo[@linebreak] | mathml:mspace[@linebreak]" mode="mathml_linebreak">
		<xsl:variable name="math_elements_tree_">
			<xsl:for-each select="ancestor::*[ancestor-or-self::mathml:math]">
				<element pos="{position()}">
					<xsl:copy-of select="@*[local-name() != 'id']"/>
					<xsl:value-of select="name()"/>
				</element>
			</xsl:for-each>
		</xsl:variable>

		<xsl:variable name="math_elements_tree" select="xalan:nodeset($math_elements_tree_)"/>

		<xsl:call-template name="insertClosingElements">
			<xsl:with-param name="tree" select="$math_elements_tree"/>
		</xsl:call-template>

		<xsl:element name="br" namespace="{$namespace_full}"/>

		<xsl:call-template name="insertOpeningElements">
			<xsl:with-param name="tree" select="$math_elements_tree"/>
			<xsl:with-param name="xmlns">http://www.w3.org/1998/Math/MathML</xsl:with-param>
			<xsl:with-param name="add_continue">false</xsl:with-param>
		</xsl:call-template>

	</xsl:template>

	<!-- Examples: 
		<stem type="AsciiMath">x = 1</stem> 
		<stem type="AsciiMath"><asciimath>x = 1</asciimath></stem>
		<stem type="AsciiMath"><asciimath>x = 1</asciimath><latexmath>x = 1</latexmath></stem>
	-->
	<xsl:template match="mn:fmt-stem[@type = 'AsciiMath'][count(*) = 0]/text() | mn:fmt-stem[@type = 'AsciiMath'][mn:asciimath]" priority="3">
		<fo:inline xsl:use-attribute-sets="mathml-style">

			<xsl:call-template name="refine_mathml-style"/>

			<xsl:choose>
				<xsl:when test="self::text()"><xsl:value-of select="."/></xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates>
						<xsl:with-param name="process">true</xsl:with-param>
					</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>

		</fo:inline>
	</xsl:template>
	<!-- ======================================= -->
	<!-- END: math -->
	<!-- ======================================= -->

	<xsl:attribute-set name="list-style">
		<xsl:attribute name="provisional-distance-between-starts">6mm</xsl:attribute>
	</xsl:attribute-set> <!-- list-style -->

	<xsl:template name="refine_list-style">
	</xsl:template> <!-- refine_list-style -->

	<xsl:attribute-set name="list-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="font-weight">normal</xsl:attribute>
	</xsl:attribute-set> <!-- list-name-style -->

	<xsl:template name="refine_list-name-style">
	</xsl:template>

	<xsl:attribute-set name="list-item-style">
		<xsl:attribute name="margin-bottom">3pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_list-item-style">
		<xsl:if test="ancestor::mn:table">
			<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
		</xsl:if>
	</xsl:template> <!-- refine_list-item-style -->

	<xsl:attribute-set name="list-item-label-style">
		<xsl:attribute name="line-height">115%</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_list-item-label-style">
	</xsl:template> <!-- refine_list-item-label-style -->

	<xsl:attribute-set name="list-item-body-style">
	</xsl:attribute-set>

	<xsl:template name="refine_list-item-body-style">
	</xsl:template> <!-- refine_list-item-body-style -->

	<!-- ===================================== -->
	<!-- Lists processing -->
	<!-- ===================================== -->
	<xsl:variable name="ul_labels_">
		<!-- <label>&#x2014;</label> --> <!-- em dash -->
		<label level="1" font-size="150%" line-height="80%">•</label>
		<label level="2">—</label><!-- em dash -->
		<label level="3" font-size="75%">o</label> <!-- white circle -->

	</xsl:variable>
	<xsl:variable name="ul_labels" select="xalan:nodeset($ul_labels_)"/>

	<xsl:template name="setULLabel">
		<xsl:variable name="list_level__"><xsl:value-of select="count(ancestor::mn:ul) + count(ancestor::mn:ol)"/>
		</xsl:variable>
		<xsl:variable name="list_level_" select="number($list_level__)"/>
		<xsl:variable name="list_level">
			<xsl:choose>
				<xsl:when test="$list_level_ &lt;= 3"><xsl:value-of select="$list_level_"/></xsl:when>
				<xsl:when test="$ul_labels/label[@level = 3]"><xsl:value-of select="$list_level_ mod 3"/></xsl:when>
				<xsl:when test="$list_level_ mod 2 = 0">2</xsl:when>
				<xsl:otherwise><xsl:value-of select="$list_level_ mod 2"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$ul_labels/label[not(@level)]"> <!-- one label for all levels -->
				<xsl:apply-templates select="$ul_labels/label[not(@level)]" mode="ul_labels"/>
			</xsl:when>
			<xsl:when test="$list_level mod 3 = 0 and $ul_labels/label[@level = 3]">
				<xsl:apply-templates select="$ul_labels/label[@level = 3]" mode="ul_labels"/>
			</xsl:when>
			<xsl:when test="$list_level mod 3 = 0">
				<xsl:apply-templates select="$ul_labels/label[@level = 1]" mode="ul_labels"/>
			</xsl:when>
			<xsl:when test="$list_level mod 2 = 0">
				<xsl:apply-templates select="$ul_labels/label[@level = 2]" mode="ul_labels"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="$ul_labels/label[@level = 1]" mode="ul_labels"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="label" mode="ul_labels">
		<xsl:copy-of select="@*[not(local-name() = 'level')]"/>
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template name="getListItemFormat">
		<!-- Example: for BSI <?list-type loweralpha?> -->
		<xsl:variable name="processing_instruction_type" select="normalize-space(../preceding-sibling::*[1]/processing-instruction('list-type'))"/>
		<xsl:choose>
			<xsl:when test="local-name(..) = 'ul'">
				<xsl:choose>
					<xsl:when test="normalize-space($processing_instruction_type) = 'simple'"/>
					<!-- https://github.com/metanorma/isodoc/issues/675 -->
					<xsl:when test="@label"><xsl:value-of select="@label"/></xsl:when>
					<xsl:otherwise><xsl:call-template name="setULLabel"/></xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<!-- https://github.com/metanorma/isodoc/issues/675 -->
			<xsl:when test="local-name(..) = 'ol' and @label and @full = 'true'"> <!-- @full added in the template li/fmt-name -->
				<xsl:value-of select="@label"/>
			</xsl:when>
			<xsl:when test="local-name(..) = 'ol' and @label"> <!-- for ordered lists 'ol', and if there is @label, for instance label="1.1.2" -->

				<xsl:variable name="type" select="../@type"/>

				<xsl:variable name="label">

					<xsl:variable name="style_prefix_">
						<xsl:if test="$type = 'roman'"> <!-- Example: (i) -->
						</xsl:if>
						<xsl:if test="$type = 'alphabet'">
						</xsl:if>
					</xsl:variable>
					<xsl:variable name="style_prefix" select="normalize-space($style_prefix_)"/>

					<xsl:variable name="style_suffix_">
						<xsl:choose>
							<xsl:when test="$type = 'arabic'">)
							</xsl:when>
							<xsl:when test="$type = 'alphabet' or $type = 'alphabetic'">)
							</xsl:when>
							<xsl:when test="$type = 'alphabet_upper' or $type = 'alphabetic_upper'">.
							</xsl:when>
							<xsl:when test="$type = 'roman'">)
							</xsl:when>
							<xsl:when test="$type = 'roman_upper'">.</xsl:when> <!-- Example: I. -->
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="style_suffix" select="normalize-space($style_suffix_)"/>

					<xsl:if test="$style_prefix != '' and not(starts-with(@label, $style_prefix))">
						<xsl:value-of select="$style_prefix"/>
					</xsl:if>

					<xsl:value-of select="@label"/>

					<xsl:if test="not(java:endsWith(java:java.lang.String.new(@label),$style_suffix))">
						<xsl:value-of select="$style_suffix"/>
					</xsl:if>
				</xsl:variable>
				<xsl:value-of select="normalize-space($label)"/>

			</xsl:when>
			<xsl:otherwise> <!-- for ordered lists 'ol' -->

				<!-- Example: for BSI <?list-start 2?> -->
				<xsl:variable name="processing_instruction_start" select="normalize-space(../preceding-sibling::*[1]/processing-instruction('list-start'))"/>

				<xsl:variable name="start_value">
					<xsl:choose>
						<xsl:when test="normalize-space($processing_instruction_start) != ''">
							<xsl:value-of select="number($processing_instruction_start) - 1"/><!-- if start="3" then start_value=2 + xsl:number(1) = 3 -->
						</xsl:when>
						<xsl:when test="normalize-space(../@start) != ''">
							<xsl:value-of select="number(../@start) - 1"/><!-- if start="3" then start_value=2 + xsl:number(1) = 3 -->
						</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="curr_value"><xsl:number/></xsl:variable>

				<xsl:variable name="type">
					<xsl:choose>
						<xsl:when test="normalize-space($processing_instruction_type) != ''"><xsl:value-of select="$processing_instruction_type"/></xsl:when>
						<xsl:when test="normalize-space(../@type) != ''"><xsl:value-of select="../@type"/></xsl:when>

						<xsl:otherwise> <!-- if no @type or @class = 'steps' -->

							<xsl:variable name="list_level_" select="count(ancestor::mn:ul) + count(ancestor::mn:ol)"/>
							<xsl:variable name="list_level">
								<xsl:choose>
									<xsl:when test="$list_level_ &lt;= 5"><xsl:value-of select="$list_level_"/></xsl:when>
									<xsl:otherwise><xsl:value-of select="$list_level_ mod 5"/></xsl:otherwise>
								</xsl:choose>
							</xsl:variable>

							<xsl:choose>
								<xsl:when test="$list_level mod 5 = 0">roman_upper</xsl:when> <!-- level 5 -->
								<xsl:when test="$list_level mod 4 = 0">alphabet_upper</xsl:when> <!-- level 4 -->
								<xsl:when test="$list_level mod 3 = 0">roman</xsl:when> <!-- level 3 -->
								<xsl:when test="$list_level mod 2 = 0 and ancestor::*/@class = 'steps'">alphabet</xsl:when> <!-- level 2 and @class = 'steps'-->
								<xsl:when test="$list_level mod 2 = 0">arabic</xsl:when> <!-- level 2 -->
								<xsl:otherwise> <!-- level 1 -->
									<xsl:choose>
										<xsl:when test="ancestor::*/@class = 'steps'">arabic</xsl:when>
										<xsl:otherwise>alphabet</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>

						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="format">
					<xsl:choose>
						<xsl:when test="$type = 'arabic'">1)
						</xsl:when>
						<xsl:when test="$type = 'alphabet' or $type = 'alphabetic'">a)
						</xsl:when>
						<xsl:when test="$type = 'alphabet_upper' or $type = 'alphabetic_upper'">A.
						</xsl:when>
						<xsl:when test="$type = 'roman'">i)
						</xsl:when>
						<xsl:when test="$type = 'roman_upper'">I.</xsl:when>
						<xsl:otherwise>1.</xsl:otherwise> <!-- for any case, if $type has non-determined value, not using -->
					</xsl:choose>
				</xsl:variable>

				<xsl:number value="$start_value + $curr_value" format="{normalize-space($format)}" lang="en"/>

			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- getListItemFormat -->

	<xsl:template match="mn:ul | mn:ol">
		<xsl:param name="indent">0</xsl:param>
		<xsl:choose>
			<xsl:when test="parent::mn:note or parent::mn:termnote">
				<fo:block-container role="SKIP">
					<xsl:attribute name="margin-left">
						<xsl:choose>
							<xsl:when test="not(ancestor::mn:table)"><xsl:value-of select="$note-body-indent"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>

					<xsl:call-template name="refine_list_container_style"/>

					<fo:block-container margin-left="0mm" role="SKIP">
						<fo:block>
							<xsl:apply-templates select="." mode="list">
								<xsl:with-param name="indent" select="$indent"/>
							</xsl:apply-templates>
						</fo:block>
					</fo:block-container>
				</fo:block-container>
			</xsl:when>
			<xsl:otherwise>
				<fo:block role="SKIP">
					<xsl:apply-templates select="." mode="list">
						<xsl:with-param name="indent" select="$indent"/>
					</xsl:apply-templates>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="refine_list_container_style">
	</xsl:template> <!-- refine_list_container_style -->

	<xsl:template match="mn:ul | mn:ol" mode="list" name="list">

		<xsl:apply-templates select="mn:fmt-name">
			<xsl:with-param name="process">true</xsl:with-param>
		</xsl:apply-templates>

		<fo:list-block xsl:use-attribute-sets="list-style">

			<xsl:variable name="provisional_distance_between_starts_">
				<attributes xsl:use-attribute-sets="list-style">
					<xsl:call-template name="refine_list-style_provisional-distance-between-starts"/>
				</attributes>
			</xsl:variable>
			<xsl:variable name="provisional_distance_between_starts" select="normalize-space(xalan:nodeset($provisional_distance_between_starts_)/attributes/@provisional-distance-between-starts)"/>
			<xsl:if test="$provisional_distance_between_starts != ''">
				<xsl:attribute name="provisional-distance-between-starts"><xsl:value-of select="$provisional_distance_between_starts"/></xsl:attribute>
			</xsl:if>
			<xsl:variable name="provisional_distance_between_starts_value" select="substring-before($provisional_distance_between_starts, 'mm')"/>

			<!-- increase provisional-distance-between-starts for long lists -->
			<xsl:if test="self::mn:ol">
				<!-- Examples: xiii), xviii), xxviii) -->
				<xsl:variable name="item_numbers">
					<xsl:for-each select="mn:li">
						<item><xsl:call-template name="getListItemFormat"/></item>
					</xsl:for-each>
				</xsl:variable>

				<xsl:variable name="max_length">
					<xsl:for-each select="xalan:nodeset($item_numbers)/item">
						<xsl:sort select="string-length(.)" data-type="number" order="descending"/>
						<xsl:if test="position() = 1"><xsl:value-of select="string-length(.)"/></xsl:if>
					</xsl:for-each>
				</xsl:variable>

				<!-- base width (provisional-distance-between-starts) for 4 chars -->
				<xsl:variable name="addon" select="$max_length - 4"/>
				<xsl:if test="$addon &gt; 0">
					<xsl:attribute name="provisional-distance-between-starts"><xsl:value-of select="$provisional_distance_between_starts_value + $addon * 2"/>mm</xsl:attribute>
				</xsl:if>
				<!-- DEBUG -->
				<!-- <xsl:copy-of select="$item_numbers"/>
				<max_length><xsl:value-of select="$max_length"/></max_length>
				<addon><xsl:value-of select="$addon"/></addon> -->
			</xsl:if>

			<xsl:call-template name="refine_list-style"/>

			<xsl:if test="mn:fmt-name">
				<xsl:attribute name="margin-top">0pt</xsl:attribute>
			</xsl:if>

			<xsl:apply-templates select="node()[not(self::mn:note)]"/>
		</fo:list-block>
		<!-- <xsl:for-each select="./iho:note">
			<xsl:call-template name="note"/>
		</xsl:for-each> -->
		<xsl:apply-templates select="./mn:note"/>
	</xsl:template>

	<xsl:template name="refine_list-style_provisional-distance-between-starts">
	</xsl:template> <!-- refine_list-style_provisional-distance-between-starts -->

	<xsl:template match="*[self::mn:ol or self::mn:ul]/mn:fmt-name">
		<xsl:param name="process">false</xsl:param>
		<xsl:if test="$process = 'true'">
			<fo:block xsl:use-attribute-sets="list-name-style">
				<xsl:call-template name="refine_list-name-style"/>
				<xsl:apply-templates/>
			</fo:block>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:li">
		<xsl:param name="indent">0</xsl:param>
		<!-- <fo:list-item xsl:use-attribute-sets="list-item-style">
			<fo:list-item-label end-indent="label-end()"><fo:block>x</fo:block></fo:list-item-label>
			<fo:list-item-body start-indent="body-start()" xsl:use-attribute-sets="list-item-body-style">
				<fo:block>debug li indent=<xsl:value-of select="$indent"/></fo:block>
			</fo:list-item-body>
		</fo:list-item> -->
		<fo:list-item xsl:use-attribute-sets="list-item-style">
			<xsl:copy-of select="@id"/>

			<xsl:call-template name="refine_list-item-style"/>

			<fo:list-item-label end-indent="label-end()">
				<fo:block xsl:use-attribute-sets="list-item-label-style" role="SKIP">

					<xsl:call-template name="refine_list-item-label-style"/>

					<xsl:if test="local-name(..) = 'ul'">
						<xsl:variable name="li_label" select="@label"/>
						<xsl:copy-of select="$ul_labels//label[. = $li_label]/@*[not(local-name() = 'level')]"/>
					</xsl:if>

					<!-- if 'p' contains all text in 'add' first and last elements in first p are 'add' -->
					<xsl:if test="*[1][count(node()[normalize-space() != '']) = 1 and mn:add]">
						<xsl:call-template name="append_add-style"/>
					</xsl:if>

					<xsl:call-template name="getListItemFormat"/>

				</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()" xsl:use-attribute-sets="list-item-body-style">
				<fo:block role="SKIP">

					<xsl:call-template name="refine_list-item-body-style"/>

					<xsl:apply-templates>
						<xsl:with-param name="indent" select="$indent"/>
					</xsl:apply-templates>

					<!-- <xsl:apply-templates select="node()[not(local-name() = 'note')]" />
					
					<xsl:for-each select="./mn:note">
						<xsl:call-template name="note"/>
					</xsl:for-each> -->
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>

	<!-- ===================================== -->
	<!-- END Lists processing -->
	<!-- ===================================== -->

	<xsl:attribute-set name="footnote-separator-leader-style">
	</xsl:attribute-set>

	<xsl:template name="refine_footnote-separator-leader-style">
	</xsl:template>

	<xsl:attribute-set name="fn-container-body-style">
		<xsl:attribute name="text-indent">0</xsl:attribute>
		<xsl:attribute name="start-indent">0</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_fn-container-body-style">
	</xsl:template>

	<xsl:attribute-set name="fn-reference-style">
		<xsl:attribute name="font-size">80%</xsl:attribute>
		<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
	</xsl:attribute-set> <!-- fn-reference-style -->

	<xsl:template name="refine_fn-reference-style">
		<!-- https://github.com/metanorma/metanorma-ieee/issues/595 -->
		<xsl:if test="preceding-sibling::node()[normalize-space() != ''][1][self::mn:fn]">,</xsl:if>
	</xsl:template> <!-- refine_fn-reference-style -->

	<xsl:attribute-set name="fn-style">
		<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_fn-style">
	</xsl:template>

	<xsl:attribute-set name="fn-num-style">
		<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
		<xsl:attribute name="font-size">70%</xsl:attribute>
		<xsl:attribute name="vertical-align">super</xsl:attribute>
	</xsl:attribute-set> <!-- fn-num-style -->

	<xsl:template name="refine_fn-num-style">
	</xsl:template>

	<xsl:attribute-set name="fn-body-style">
		<xsl:attribute name="font-weight">normal</xsl:attribute>
		<xsl:attribute name="font-style">normal</xsl:attribute>
		<xsl:attribute name="text-indent">0</xsl:attribute>
		<xsl:attribute name="start-indent">0</xsl:attribute>
		<xsl:attribute name="font-size">10pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
	</xsl:attribute-set> <!-- fn-body-style" -->

	<xsl:template name="refine_fn-body-style">
	</xsl:template> <!-- refine_fn-body-style -->

	<xsl:attribute-set name="fn-body-num-style">
		<xsl:attribute name="keep-with-next.within-line">always</xsl:attribute>
		<xsl:attribute name="font-size">60%</xsl:attribute>
		<xsl:attribute name="vertical-align">super</xsl:attribute>
		<xsl:attribute name="padding-right">1mm</xsl:attribute>
	</xsl:attribute-set> <!-- fn-body-num-style -->

	<xsl:template name="refine_fn-body-num-style">
	</xsl:template> <!-- refine_fn-body-num-style -->

	<!-- ===================== -->
	<!-- Footnotes processing  -->
	<!-- ===================== -->

	<!-- document text (not figures, or tables) footnotes -->
	<xsl:variable name="footnotes_">
		<xsl:for-each select="//mn:fmt-footnote-container/mn:fmt-fn-body"> <!-- commented mn:metanorma/, because there are fn in figure or table name -->
			<!-- <xsl:copy-of select="."/> -->
			<xsl:variable name="update_xml_step1">
				<xsl:apply-templates select="." mode="update_xml_step1"/>
			</xsl:variable>
			<xsl:apply-templates select="xalan:nodeset($update_xml_step1)" mode="update_xml_enclose_keep-together_within-line"/>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="footnotes" select="xalan:nodeset($footnotes_)"/>

	<!--
	<fn reference="1">
			<p id="_8e5cf917-f75a-4a49-b0aa-1714cb6cf954">Formerly denoted as 15 % (m/m).</p>
		</fn>
	-->
	<!-- footnotes in text (title, bibliography, main body), not for tables, figures and names --> <!-- table's, figure's names -->
	<!-- fn in text -->
	<xsl:template match="mn:fn[not(ancestor::*[(self::mn:table or self::mn:figure)] and not(ancestor::mn:fmt-name))]" priority="2" name="fn">
		<xsl:param name="footnote_body_from_table">false</xsl:param>

		<!-- list of unique footnotes -->
		<xsl:variable name="p_fn_">
			<xsl:call-template name="get_fn_list"/>
		</xsl:variable>
		<xsl:variable name="p_fn" select="xalan:nodeset($p_fn_)"/>

		<xsl:variable name="gen_id" select="generate-id(.)"/>

		<!-- fn sequence number in document -->
		<xsl:variable name="current_fn_number" select="@reference"/>

		<xsl:variable name="current_fn_number_text">
			<xsl:value-of select="$current_fn_number"/>
		</xsl:variable>

		<xsl:variable name="ref_id" select="@target"/>

		<xsl:variable name="footnote_inline">
			<fo:inline role="Reference">

				<xsl:variable name="fn_styles">
					<xsl:choose>
						<xsl:when test="ancestor::mn:bibitem">
							<fn_styles xsl:use-attribute-sets="bibitem-note-fn-style">
								<xsl:call-template name="refine_bibitem-note-fn-style"/>
							</fn_styles>
						</xsl:when>
						<xsl:otherwise>
							<fn_styles xsl:use-attribute-sets="fn-num-style">
								<xsl:call-template name="refine_fn-num-style"/>
							</fn_styles>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:for-each select="xalan:nodeset($fn_styles)/fn_styles/@*">
					<xsl:copy-of select="."/>
				</xsl:for-each>

				<!-- https://github.com/metanorma/metanorma-ieee/issues/595 -->
				<!-- <xsl:if test="following-sibling::node()[normalize-space() != ''][1][self::mn:fn]">
					<xsl:attribute name="padding-right">0.5mm</xsl:attribute>
				</xsl:if> -->

				<xsl:if test="preceding-sibling::node()[normalize-space() != ''][1][self::mn:fn]">,</xsl:if>

				<xsl:call-template name="insert_basic_link">
					<xsl:with-param name="element">
						<fo:basic-link internal-destination="{$ref_id}" fox:alt-text="footnote {$current_fn_number}"> <!-- note: role="Lbl" removed in https://github.com/metanorma/mn2pdf/issues/291 -->
							<fo:inline role="Lbl"> <!-- need for https://github.com/metanorma/metanorma-iso/issues/1003 -->
								<xsl:copy-of select="$current_fn_number_text"/>

							</fo:inline>
						</fo:basic-link>
					</xsl:with-param>
				</xsl:call-template>
			</fo:inline>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="normalize-space(@skip_footnote_body) = 'true'">
				<xsl:copy-of select="$footnote_inline"/>
			</xsl:when>
			<!-- <xsl:when test="$footnotes//mn:fmt-fn-body[@id = $ref_id] or normalize-space(@skip_footnote_body) = 'false'"> -->
			<xsl:when test="$p_fn//fn[@gen_id = $gen_id] or normalize-space(@skip_footnote_body) = 'false' or $footnote_body_from_table = 'true'">

				<fo:footnote xsl:use-attribute-sets="fn-style" role="SKIP">
					<xsl:call-template name="refine_fn-style"/>
					<xsl:copy-of select="$footnote_inline"/>
					<fo:footnote-body role="Note">

						<fo:block-container xsl:use-attribute-sets="fn-container-body-style" role="SKIP">
							<xsl:call-template name="refine_fn-container-body-style"/>

							<xsl:variable name="fn_block">
								<xsl:call-template name="refine_fn-body-style"/>

								<fo:inline id="{$ref_id}" xsl:use-attribute-sets="fn-body-num-style" role="Lbl">

									<xsl:call-template name="refine_fn-body-num-style"/>

									<xsl:value-of select="$current_fn_number_text"/>

								</fo:inline>
								<!-- <xsl:apply-templates /> -->
								<!-- <ref_id><xsl:value-of select="$ref_id"/></ref_id>
								<here><xsl:copy-of select="$footnotes"/></here> -->
								<xsl:apply-templates select="$footnotes/mn:fmt-fn-body[@id = $ref_id]"/>
							</xsl:variable>
							<fo:block xsl:use-attribute-sets="fn-body-style" role="SKIP">
								<xsl:copy-of select="$fn_block"/>
							</fo:block>

						</fo:block-container>
					</fo:footnote-body>
				</fo:footnote>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$footnote_inline"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- fn in text -->

	<xsl:template name="get_fn_list">
		<xsl:choose>
			<xsl:when test="@current_fn_number"> <!-- for BSI, footnote reference number calculated already -->
				<fn gen_id="{generate-id(.)}">
					<xsl:copy-of select="@*"/>
					<xsl:copy-of select="node()"/>
				</fn>
			</xsl:when>
			<xsl:otherwise>
				<!-- itetation for:
				footnotes in bibdata/title
				footnotes in bibliography
				footnotes in document's body (except table's head/body/foot and figure text) 
				-->
				<xsl:for-each select="ancestor::mn:metanorma/mn:bibdata/mn:note[@type='title-footnote']">
					<fn gen_id="{generate-id(.)}">
						<xsl:copy-of select="@*"/>
						<xsl:copy-of select="node()"/>
					</fn>
				</xsl:for-each>
				<xsl:for-each select="ancestor::mn:metanorma/mn:boilerplate/* |       ancestor::mn:metanorma//mn:preface/* |      ancestor::mn:metanorma//mn:sections/* |       ancestor::mn:metanorma//mn:annex |      ancestor::mn:metanorma//mn:bibliography/*">
					<xsl:sort select="@displayorder" data-type="number"/>
					<!-- commented:
					 .//mn:bibitem[ancestor::mn:references]/mn:note |
					 because 'fn' there is in biblio-tag -->
					<xsl:for-each select=".//mn:fn[not(ancestor::*[(self::mn:table or self::mn:figure)] and not(ancestor::mn:fmt-name))][generate-id(.)=generate-id(key('kfn',@reference)[1])]">
						<!-- copy unique fn -->
						<fn gen_id="{generate-id(.)}">
							<xsl:copy-of select="@*"/>
							<xsl:copy-of select="node()"/>
						</fn>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- fn/text() -->
	<xsl:template match="mn:fn/text()[normalize-space() != '']">
		<fo:inline role="SKIP"><xsl:value-of select="."/></fo:inline>
	</xsl:template>

	<!-- fn//p fmt-fn-body//p -->
	<xsl:template match="mn:fn//mn:p | mn:fmt-fn-body//mn:p">
		<fo:inline role="P">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template name="insertFootnoteSeparatorCommon">
		<xsl:param name="leader_length">30%</xsl:param>
		<fo:static-content flow-name="xsl-footnote-separator" role="artifact">
			<fo:block>
				<fo:leader leader-pattern="rule" leader-length="{$leader_length}"/>
			</fo:block>
		</fo:static-content>
	</xsl:template>

	<!-- ===================== -->
	<!-- END Footnotes processing  -->
	<!-- ===================== -->

	<!-- admonition -->
	<xsl:attribute-set name="admonition-style">
		<xsl:attribute name="border">0.5pt solid rgb(79, 129, 189)</xsl:attribute>
		<xsl:attribute name="color">rgb(79, 129, 189)</xsl:attribute>
		<xsl:attribute name="margin-left">16mm</xsl:attribute>
		<xsl:attribute name="margin-right">16mm</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
	</xsl:attribute-set> <!-- admonition-style -->

	<xsl:template name="refine_admonition-style">
	</xsl:template>

	<xsl:attribute-set name="admonition-container-style">
		<xsl:attribute name="margin-left">0mm</xsl:attribute>
		<xsl:attribute name="margin-right">0mm</xsl:attribute>
		<xsl:attribute name="padding">2mm</xsl:attribute>
		<xsl:attribute name="padding-top">3mm</xsl:attribute>
	</xsl:attribute-set> <!-- admonition-container-style -->

	<xsl:template name="refine_admonition-container-style">
	</xsl:template>

	<xsl:attribute-set name="admonition-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="font-size">11pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="font-style">italic</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
	</xsl:attribute-set> <!-- admonition-name-style -->

	<xsl:template name="refine_admonition-name-style">
	</xsl:template>

	<xsl:attribute-set name="admonition-p-style">
		<xsl:attribute name="font-style">italic</xsl:attribute>
	</xsl:attribute-set> <!-- admonition-p-style -->

	<xsl:template name="refine_admonition-p-style">
	</xsl:template>

	<!-- end admonition -->

	<!-- ================ -->
	<!-- Admonition -->
	<!-- ================ -->
	<xsl:template match="mn:admonition"> <!-- text in the box -->
		<xsl:call-template name="setNamedDestination"/>
		<fo:block-container id="{@id}" xsl:use-attribute-sets="admonition-style">

			<xsl:call-template name="refine_admonition-style"/>

			<xsl:call-template name="setBlockSpanAll"/>
					<fo:block-container xsl:use-attribute-sets="admonition-container-style" role="SKIP">

						<xsl:call-template name="refine_admonition-container-style"/>
								<fo:block xsl:use-attribute-sets="admonition-name-style">
									<xsl:call-template name="refine_admonition-name-style"/>
									<xsl:call-template name="displayAdmonitionName"/>
								</fo:block>
								<fo:block xsl:use-attribute-sets="admonition-p-style">
									<xsl:call-template name="refine_admonition-p-style"/>
									<xsl:apply-templates select="node()[not(self::mn:fmt-name)]"/>
								</fo:block>

					</fo:block-container>
		</fo:block-container>
	</xsl:template>

	<xsl:template name="displayAdmonitionName">
		<xsl:param name="sep"/> <!-- Example: ' - ' -->
		<!-- <xsl:choose>
			<xsl:when test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
				<xsl:choose>
					<xsl:when test="@type='important'"><xsl:apply-templates select="@type"/></xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="mn:name"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="mn:name"/>
				<xsl:if test="not(mn:name)">
					<xsl:apply-templates select="@type"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose> -->
		<xsl:variable name="name">
			<xsl:apply-templates select="mn:fmt-name"/>
		</xsl:variable>
		<xsl:copy-of select="$name"/>
		<xsl:if test="normalize-space($name) != ''">
			<xsl:value-of select="$sep"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:admonition/mn:fmt-name">
		<xsl:apply-templates/>
	</xsl:template>

	<!-- <xsl:template match="mn:admonition/@type">
		<xsl:variable name="admonition_type_">
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">admonition.<xsl:value-of select="."/></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="admonition_type" select="normalize-space(java:toUpperCase(java:java.lang.String.new($admonition_type_)))"/>
		<xsl:value-of select="$admonition_type"/>
		<xsl:if test="$admonition_type = ''">
			<xsl:value-of select="java:toUpperCase(java:java.lang.String.new(.))"/>
		</xsl:if>
	</xsl:template> -->

	<xsl:template match="mn:admonition/mn:p"> <!-- processing for admonition/p found in the template for 'p' -->
		<xsl:call-template name="paragraph"/>

	</xsl:template>

	<!-- ================ -->
	<!-- END Admonition -->
	<!-- ================ -->

	<xsl:attribute-set name="references-non-normative-title-style">
		<xsl:attribute name="font-size">16pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="margin-top">6pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">36pt</xsl:attribute>
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="role">H1</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_references-non-normative-title-style">

	</xsl:template>

	<!-- bibitem in Normative References (references/@normative="true") -->
	<xsl:attribute-set name="bibitem-normative-style">
	</xsl:attribute-set> <!-- bibitem-normative-style -->

	<xsl:template name="refine_bibitem-normative-style">
	</xsl:template>

	<!-- bibitem in Normative References (references/@normative="true"), renders as list -->
	<xsl:attribute-set name="bibitem-normative-list-style">
		<xsl:attribute name="provisional-distance-between-starts">12mm</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<!-- <xsl:attribute name="line-height">115%</xsl:attribute> -->
		<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
	</xsl:attribute-set> <!-- bibitem-normative-list-style -->

	<xsl:template name="refine_bibitem-normative-list-style">
		<xsl:variable name="docidentifier">
			<xsl:apply-templates select="mn:biblio-tag">
				<xsl:with-param name="biblio_tag_part">first</xsl:with-param>
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:attribute name="provisional-distance-between-starts">
			<xsl:choose>
				<xsl:when test="string-length($docidentifier) = 0">0mm</xsl:when>
				<xsl:when test="string-length($docidentifier) &gt; 19">46.5mm</xsl:when>
				<xsl:when test="string-length($docidentifier) &gt; 10">37mm</xsl:when>
				<xsl:otherwise>24.5mm</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>

	<xsl:attribute-set name="bibitem-non-normative-style">
	</xsl:attribute-set> <!-- bibitem-non-normative-style -->

	<xsl:template name="refine_bibitem-non-normative-style">
	</xsl:template>

	<!-- bibitem in bibliography section (references/@normative="false"), renders as list -->
	<xsl:attribute-set name="bibitem-non-normative-list-style">
		<xsl:attribute name="provisional-distance-between-starts">12mm</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:attribute name="line-height">115%</xsl:attribute>
	</xsl:attribute-set> <!-- bibitem-non-normative-list-style -->

	<xsl:template name="refine_bibitem-non-normative-list-style">
	</xsl:template>

	<xsl:attribute-set name="bibitem-non-normative-list-item-style">
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_bibitem-non-normative-list-item-style">
	</xsl:template>

	<!-- bibitem in bibliography section (references/@normative="false"), list body -->
	<xsl:attribute-set name="bibitem-normative-list-body-style">
	</xsl:attribute-set>

	<xsl:template name="refine_bibitem-normative-list-body-style">
	</xsl:template>

	<xsl:attribute-set name="bibitem-non-normative-list-body-style">
	</xsl:attribute-set> <!-- bibitem-non-normative-list-body-style -->

	<xsl:template name="refine_bibitem-non-normative-list-body-style">
	</xsl:template>

	<!-- footnote reference number for bibitem, in the text  -->
	<xsl:attribute-set name="bibitem-note-fn-style">
		<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
		<xsl:attribute name="font-size">65%</xsl:attribute>
		<xsl:attribute name="font-size">8pt</xsl:attribute>
		<xsl:attribute name="baseline-shift">30%</xsl:attribute>
	</xsl:attribute-set> <!-- bibitem-note-fn-style -->

	<xsl:template name="refine_bibitem-note-fn-style">
	</xsl:template>

	<!-- footnote number on the page bottom -->
	<xsl:attribute-set name="bibitem-note-fn-number-style">
		<xsl:attribute name="keep-with-next.within-line">always</xsl:attribute>
		<xsl:attribute name="alignment-baseline">hanging</xsl:attribute>
		<xsl:attribute name="padding-right">3mm</xsl:attribute>
	</xsl:attribute-set> <!-- bibitem-note-fn-number-style -->

	<!-- footnote body (text) on the page bottom -->
	<xsl:attribute-set name="bibitem-note-fn-body-style">
		<xsl:attribute name="font-size">10pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:attribute name="start-indent">0pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
	</xsl:attribute-set> <!-- bibitem-note-fn-body-style -->

	<xsl:attribute-set name="references-non-normative-style">
	</xsl:attribute-set> <!-- references-non-normative-style -->

	<xsl:template name="refine_references-non-normative-style">
	</xsl:template>

		<!-- ======================= -->
	<!-- Bibliography rendering -->
	<!-- ======================= -->

	<!-- ========================================================== -->
	<!-- Reference sections (Normative References and Bibliography) -->
	<!-- ========================================================== -->
	<xsl:template match="mn:references[@hidden='true']" priority="3"/>
	<xsl:template match="mn:bibitem[@hidden='true']" priority="3">
		<xsl:param name="skip" select="normalize-space(preceding-sibling::*[1][self::mn:bibitem] and 1 = 1)"/>
	</xsl:template>
	<!-- don't display bibitem with @id starts with '_hidden', that was introduced for references integrity -->
	<xsl:template match="mn:bibitem[starts-with(@id, 'hidden_bibitem_')]" priority="3"/>

	<!-- Normative references -->
	<xsl:template match="mn:references[@normative='true']" priority="2">

		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- Bibliography (non-normative references) -->
	<xsl:template match="mn:references">
		<xsl:if test="not(ancestor::mn:annex)">
		</xsl:if>

		<!-- <xsl:if test="ancestor::mn:annex">
			<xsl:if test="$namespace = 'csa' or $namespace = 'csd' or $namespace = 'gb' or $namespace = 'iec' or $namespace = 'iso' or $namespace = 'itu'">
				<fo:block break-after="page"/>
			</xsl:if>
		</xsl:if> -->

		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}"/>

		<xsl:apply-templates select="mn:fmt-title[@columns = 1]"/>

		<fo:block xsl:use-attribute-sets="references-non-normative-style">
			<xsl:call-template name="refine_references-non-normative-style"/>
			<xsl:apply-templates select="node()[not(self::mn:fmt-title and @columns = 1)]"/>
		</fo:block>
	</xsl:template> <!-- references -->

	<xsl:template match="mn:bibitem">
		<xsl:call-template name="bibitem"/>
	</xsl:template>

	<!-- Normative references -->
	<xsl:template match="mn:references[@normative='true']/mn:bibitem" name="bibitem" priority="2">
		<xsl:param name="skip" select="normalize-space(preceding-sibling::*[1][self::mn:bibitem] and 1 = 1)"/> <!-- current bibiitem is non-first -->
		<xsl:call-template name="setNamedDestination"/>
		<fo:list-block id="{@id}" xsl:use-attribute-sets="bibitem-normative-list-style">

			<xsl:call-template name="refine_bibitem-normative-list-style"/>

			<xsl:variable name="docidentifier">
				<xsl:apply-templates select="mn:biblio-tag">
					<xsl:with-param name="biblio_tag_part">first</xsl:with-param>
				</xsl:apply-templates>
			</xsl:variable>

			<fo:list-item>
				<fo:list-item-label end-indent="label-end()">
					<fo:block>
						<fo:inline>
							<xsl:copy-of select="$docidentifier"/>
						</fo:inline>
					</fo:block>
				</fo:list-item-label>
				<fo:list-item-body start-indent="body-start()">
					<fo:block xsl:use-attribute-sets="bibitem-normative-list-body-style">
						<xsl:call-template name="refine_bibitem-normative-list-body-style"/>
						<xsl:call-template name="processBibitem">
							<xsl:with-param name="biblio_tag_part">last</xsl:with-param>
						</xsl:call-template>
					</fo:block>
				</fo:list-item-body>
			</fo:list-item>
		</fo:list-block>

	</xsl:template> <!-- bibitem -->

	<!-- Bibliography (non-normative references) -->
	<xsl:template match="mn:references[not(@normative='true')]/mn:bibitem" name="bibitem_non_normative" priority="2">
		<xsl:param name="skip" select="normalize-space(preceding-sibling::*[not(self::mn:note)][1][self::mn:bibitem] and 1 = 1)"/> <!-- current bibiitem is non-first -->
		<xsl:call-template name="bibitem"/>

	</xsl:template> <!-- references[not(@normative='true')]/bibitem -->

	<!-- bibitem's notes will be processing in 'processBibitemFollowingNotes' -->
	<xsl:template match="mn:references/mn:note" priority="2"/> <!-- [not(@normative='true')] -->

	<xsl:template name="insertListItem_Bibitem">
		<xsl:choose>
			<xsl:when test="@hidden = 'true'"><!-- skip --></xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="setNamedDestination"/>
				<fo:list-item id="{@id}" xsl:use-attribute-sets="bibitem-non-normative-list-item-style">
					<xsl:call-template name="refine_bibitem-non-normative-list-item-style"/>

					<fo:list-item-label end-indent="label-end()">
						<fo:block role="SKIP">
							<fo:inline role="SKIP">
								<xsl:apply-templates select="mn:biblio-tag">
									<xsl:with-param name="biblio_tag_part">first</xsl:with-param>
								</xsl:apply-templates>
							</fo:inline>
						</fo:block>
					</fo:list-item-label>
					<fo:list-item-body start-indent="body-start()">
						<fo:block xsl:use-attribute-sets="bibitem-non-normative-list-body-style"> <!-- role="SKIP" -->
							<xsl:call-template name="refine_bibitem-non-normative-list-body-style"/>
							<xsl:call-template name="processBibitem">
								<xsl:with-param name="biblio_tag_part">last</xsl:with-param>
							</xsl:call-template>
						</fo:block>
						<xsl:call-template name="processBibitemFollowingNotes"/>
					</fo:list-item-body>
				</fo:list-item>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates select="following-sibling::*[self::mn:bibitem][1]">
			<xsl:with-param name="skip">false</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template name="processBibitem">
		<xsl:param name="biblio_tag_part">both</xsl:param>
		<!-- start bibitem processing -->
		<xsl:if test=".//mn:fn">
			<xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
		</xsl:if>

		<xsl:apply-templates select="mn:biblio-tag">
			<xsl:with-param name="biblio_tag_part" select="$biblio_tag_part"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="mn:formattedref"/>
				<xsl:call-template name="processBibitemFollowingNotes"/>
		<!-- end bibitem processing -->
	</xsl:template> <!-- processBibitem (bibitem) -->

	<xsl:template name="processBibitemFollowingNotes">
		<!-- current context is bibitem element -->
		<xsl:variable name="bibitem_id" select="@id"/>
		<xsl:for-each select="following-sibling::mn:note[preceding-sibling::mn:bibitem[1][@id = $bibitem_id] and     preceding-sibling::*[1][self::mn:note or self::mn:bibitem]]">
			<xsl:call-template name="note"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="mn:title" mode="title">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>

	<xsl:template match="mn:bibitem/mn:docidentifier"/>

	<xsl:template match="mn:formattedref">
		<!-- <xsl:if test="$namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:text>, </xsl:text>
		</xsl:if> -->
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="mn:biblio-tag">
		<xsl:param name="biblio_tag_part">both</xsl:param>
		<xsl:choose>
			<xsl:when test="$biblio_tag_part = 'first' and mn:tab">
				<xsl:apply-templates select="./mn:tab[1]/preceding-sibling::node()"/>
			</xsl:when>
			<xsl:when test="$biblio_tag_part = 'last'">
				<xsl:apply-templates select="./mn:tab[1]/following-sibling::node()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mn:biblio-tag/mn:tab" priority="2">
		<xsl:text> </xsl:text>
	</xsl:template>

	<!-- ======================= -->
	<!-- END Bibliography rendering -->
	<!-- ======================= -->

	<!-- ========================================================== -->
	<!-- END Reference sections (Normative References and Bibliography) -->
	<!-- ========================================================== -->

	<!-- Highlight.js syntax GitHub styles -->
	<xsl:attribute-set name="hljs-doctag">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-keyword">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-meta_hljs-keyword">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-template-tag">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-template-variable">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-type">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-variable_and_language_">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-title">
		<xsl:attribute name="color">#6f42c1</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-title_and_class_">
		<xsl:attribute name="color">#6f42c1</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-title_and_class__and_inherited__">
		<xsl:attribute name="color">#6f42c1</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-title_and_function_">
		<xsl:attribute name="color">#6f42c1</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-attr">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-attribute">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-literal">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-meta">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-number">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-operator">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-variable">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-selector-attr">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-selector-class">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-selector-id">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-regexp">
		<xsl:attribute name="color">#032f62</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-string">
		<xsl:attribute name="color">#032f62</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-meta_hljs-string">
		<xsl:attribute name="color">#032f62</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-built_in">
		<xsl:attribute name="color">#e36209</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-symbol">
		<xsl:attribute name="color">#e36209</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-comment">
		<xsl:attribute name="color">#6a737d</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-code">
		<xsl:attribute name="color">#6a737d</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-formula">
		<xsl:attribute name="color">#6a737d</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-name">
		<xsl:attribute name="color">#22863a</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-quote">
		<xsl:attribute name="color">#22863a</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-selector-tag">
		<xsl:attribute name="color">#22863a</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-selector-pseudo">
		<xsl:attribute name="color">#22863a</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-subst">
		<xsl:attribute name="color">#24292e</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-section">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-bullet">
		<xsl:attribute name="color">#735c0f</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-emphasis">
		<xsl:attribute name="color">#24292e</xsl:attribute>
		<xsl:attribute name="font-style">italic</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-strong">
		<xsl:attribute name="color">#24292e</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-addition">
		<xsl:attribute name="color">#22863a</xsl:attribute>
		<xsl:attribute name="background-color">#f0fff4</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-deletion">
		<xsl:attribute name="color">#b31d28</xsl:attribute>
		<xsl:attribute name="background-color">#ffeef0</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-char_and_escape_">
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-link">
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-params">
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-property">
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-punctuation">
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-tag">
	</xsl:attribute-set>
	<!-- End Highlight syntax styles -->

	<!-- Index section styles -->
	<xsl:attribute-set name="indexsect-title-style">
		<xsl:attribute name="role">H1</xsl:attribute>
	</xsl:attribute-set> <!-- indexsect-title-style -->

	<xsl:template name="refine_indexsect-title-style">
	</xsl:template>

	<xsl:attribute-set name="indexsect-clause-title-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
	</xsl:attribute-set> <!-- indexsect-clause-title-style -->

	<xsl:template name="refine_indexsect-clause-title-style">
	</xsl:template>
	<!-- End Index section styles -->

	<!-- =================== -->
	<!-- Index section processing -->
	<!-- =================== -->

	<xsl:variable name="index" select="document($external_index)"/>

	<xsl:variable name="bookmark_in_fn">
		<xsl:for-each select="//mn:bookmark[ancestor::mn:fn]">
			<bookmark><xsl:value-of select="@id"/></bookmark>
		</xsl:for-each>
	</xsl:variable>

	<xsl:template match="@*|node()" mode="index_add_id">
		<xsl:param name="docid"/>
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="index_add_id">
				<xsl:with-param name="docid" select="$docid"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:xref" mode="index_add_id"/>
	<xsl:template match="mn:fmt-xref" mode="index_add_id">
		<xsl:param name="docid"/>
		<xsl:variable name="id">
			<xsl:call-template name="generateIndexXrefId">
				<xsl:with-param name="docid" select="$docid"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:copy> <!-- add id to xref -->
			<xsl:apply-templates select="@*" mode="index_add_id"/>
			<xsl:attribute name="id">
				<xsl:value-of select="$id"/>
			</xsl:attribute>
			<xsl:apply-templates mode="index_add_id">
				<xsl:with-param name="docid" select="$docid"/>
			</xsl:apply-templates>
		</xsl:copy>
		<!-- split <xref target="bm1" to="End" pagenumber="true"> to two xref:
		<xref target="bm1" pagenumber="true"> and <xref target="End" pagenumber="true"> -->
		<xsl:if test="@to">
			<xsl:value-of select="$en_dash"/>
			<xsl:copy>
				<xsl:copy-of select="@*"/>
				<xsl:attribute name="target"><xsl:value-of select="@to"/></xsl:attribute>
				<xsl:attribute name="id">
					<xsl:value-of select="$id"/><xsl:text>_to</xsl:text>
				</xsl:attribute>
				<xsl:apply-templates mode="index_add_id">
					<xsl:with-param name="docid" select="$docid"/>
				</xsl:apply-templates>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template match="@*|node()" mode="index_update">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="index_update"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:indexsect//mn:li" mode="index_update">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="index_update"/>
		<xsl:apply-templates select="node()[not(self::mn:fmt-name)][1]" mode="process_li_element"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:indexsect//mn:li/node()" mode="process_li_element" priority="2">
		<xsl:param name="element"/>
		<xsl:param name="remove" select="'false'"/>
		<xsl:param name="target"/>
		<!-- <node></node> -->
		<xsl:choose>
			<xsl:when test="self::text()  and (normalize-space(.) = ',' or normalize-space(.) = $en_dash) and $remove = 'true'">
				<!-- skip text (i.e. remove it) and process next element -->
				<!-- [removed_<xsl:value-of select="."/>] -->
				<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element">
					<xsl:with-param name="target"><xsl:value-of select="$target"/></xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="self::text()">
				<xsl:value-of select="."/>
				<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element"/>
			</xsl:when>
			<xsl:when test="self::* and local-name(.) = 'fmt-xref'">
				<xsl:variable name="id" select="@id"/>

				<xsl:variable name="id_next" select="following-sibling::mn:fmt-xref[1]/@id"/>
				<xsl:variable name="id_prev" select="preceding-sibling::mn:fmt-xref[1]/@id"/>

				<xsl:variable name="pages_">
					<xsl:for-each select="$index/index/item[@id = $id or @id = $id_next or @id = $id_prev]">
						<xsl:choose>
							<xsl:when test="@id = $id">
								<page><xsl:value-of select="."/></page>
							</xsl:when>
							<xsl:when test="@id = $id_next">
								<page_next><xsl:value-of select="."/></page_next>
							</xsl:when>
							<xsl:when test="@id = $id_prev">
								<page_prev><xsl:value-of select="."/></page_prev>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="pages" select="xalan:nodeset($pages_)"/>

				<!-- <xsl:variable name="page" select="$index/index/item[@id = $id]"/> -->
				<xsl:variable name="page" select="$pages/page"/>
				<!-- <xsl:variable name="page_next" select="$index/index/item[@id = $id_next]"/> -->
				<xsl:variable name="page_next" select="$pages/page_next"/>
				<!-- <xsl:variable name="page_prev" select="$index/index/item[@id = $id_prev]"/> -->
				<xsl:variable name="page_prev" select="$pages/page_prev"/>

				<xsl:choose>
					<!-- 2nd pass -->
					<!-- if page is equal to page for next and page is not the end of range -->
					<xsl:when test="$page != '' and $page_next != '' and $page = $page_next and not(contains($page, '_to'))">  <!-- case: 12, 12-14 -->
						<!-- skip element (i.e. remove it) and remove next text ',' -->
						<!-- [removed_xref] -->

						<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element">
							<xsl:with-param name="remove">true</xsl:with-param>
							<xsl:with-param name="target">
								<xsl:choose>
									<xsl:when test="$target != ''"><xsl:value-of select="$target"/></xsl:when>
									<xsl:otherwise><xsl:value-of select="@target"/></xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>

					<xsl:when test="$page != '' and $page_prev != '' and $page = $page_prev and contains($page_prev, '_to')"> <!-- case: 12-14, 14, ... -->
						<!-- remove xref -->
						<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element">
							<xsl:with-param name="remove">true</xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>

					<xsl:otherwise>
						<xsl:apply-templates select="." mode="xref_copy">
							<xsl:with-param name="target" select="$target"/>
						</xsl:apply-templates>
						<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="self::* and local-name(.) = 'ul'">
				<!-- ul -->
				<xsl:apply-templates select="." mode="index_update"/>
			</xsl:when>
			<xsl:otherwise>
			 <xsl:apply-templates select="." mode="xref_copy">
					<xsl:with-param name="target" select="$target"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="@*|node()" mode="xref_copy">
		<xsl:param name="target"/>
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="xref_copy"/>
			<xsl:if test="$target != '' and not(xalan:nodeset($bookmark_in_fn)//bookmark[. = $target])">
				<xsl:attribute name="target"><xsl:value-of select="$target"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="node()" mode="xref_copy"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template name="generateIndexXrefId">
		<xsl:param name="docid"/>

		<xsl:variable name="level" select="count(ancestor::mn:ul)"/>

		<xsl:variable name="docid_curr">
			<xsl:value-of select="$docid"/>
			<xsl:if test="normalize-space($docid) = ''"><xsl:call-template name="getDocumentId"/></xsl:if>
		</xsl:variable>

		<xsl:variable name="item_number">
			<xsl:number count="mn:li[ancestor::mn:indexsect]" level="any"/>
		</xsl:variable>
		<xsl:variable name="xref_number"><xsl:number count="mn:fmt-xref"/></xsl:variable>
		<xsl:value-of select="concat($docid_curr, '_', $item_number, '_', $xref_number)"/> <!-- $level, '_',  -->
	</xsl:template>

	<xsl:template match="mn:indexsect/mn:fmt-title | mn:indexsect/mn:title" priority="4">
		<fo:block xsl:use-attribute-sets="indexsect-title-style">
			<xsl:call-template name="refine_indexsect-title-style"/>
			<!-- Index -->
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:indexsect/mn:clause/mn:fmt-title | mn:indexsect/mn:clause/mn:title" priority="4">
		<!-- Letter A, B, C, ... -->
		<fo:block xsl:use-attribute-sets="indexsect-clause-title-style">
			<xsl:call-template name="refine_indexsect-clause-title-style"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:indexsect/mn:clause" priority="4">
		<xsl:apply-templates/>
		<fo:block>
			<xsl:if test="following-sibling::mn:clause">
				<fo:block> </fo:block>
			</xsl:if>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:indexsect//mn:ul" priority="4">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="mn:indexsect//mn:li" priority="4">
		<xsl:variable name="level" select="count(ancestor::mn:ul)"/>
		<fo:block start-indent="{5 * $level}mm" text-indent="-5mm">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:indexsect//mn:li/text()">
		<!-- to split by '_' and other chars -->
		<xsl:call-template name="add-zero-spaces-java"/>
	</xsl:template>

	<xsl:template match="mn:table/mn:bookmark" priority="2"/>

	<xsl:template match="mn:bookmark" name="bookmark">
		<xsl:variable name="bookmark_id" select="@id"/>
		<xsl:choose>
			<!-- Example:
				<fmt-review-start id="_7ef81cf7-3f6c-4ed4-9c1f-1ba092052bbd" source="_dda23915-8574-ef1e-29a1-822d465a5b97" target="_ecfb2210-3b1b-46a2-b63a-8b8505be6686" end="_dda23915-8574-ef1e-29a1-822d465a5b97" author="" date="2025-03-24T00:00:00Z"/>
				<bookmark id="_dda23915-8574-ef1e-29a1-822d465a5b97"/>
				<fmt-review-end id="_f336a8d0-08a8-4b7f-a1aa-b04688ed40c1" source="_dda23915-8574-ef1e-29a1-822d465a5b97" target="_ecfb2210-3b1b-46a2-b63a-8b8505be6686" start="_dda23915-8574-ef1e-29a1-822d465a5b97" author="" date="2025-03-24T00:00:00Z"/> -->
			<xsl:when test="1 = 2 and preceding-sibling::node()[self::mn:fmt-annotation-start][@source = $bookmark_id] and        following-sibling::node()[self::mn:fmt-annotation-end][@source = $bookmark_id]">
				<!-- skip here, see the template 'fmt-review-start' -->
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="parent::mn:example or parent::mn:termexample or parent::mn:note or parent::mn:termnote">
						<fo:block font-size="1pt" line-height="0.1">
							<xsl:call-template name="fo_inline_bookmark">
								<xsl:with-param name="bookmark_id" select="$bookmark_id"/>
							</xsl:call-template>
						</fo:block>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="fo_inline_bookmark">
							<xsl:with-param name="bookmark_id" select="$bookmark_id"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="fo_inline_bookmark">
		<xsl:param name="bookmark_id"/>
		<!-- <fo:inline id="{@id}" font-size="1pt"/> -->
		<fo:inline id="{@id}" font-size="1pt"><xsl:if test="preceding-sibling::node()[self::mn:fmt-annotation-start][@source = $bookmark_id] and      following-sibling::node()[self::mn:fmt-annotation-end][@source = $bookmark_id]"><xsl:attribute name="line-height">0.1</xsl:attribute></xsl:if><xsl:value-of select="$hair_space"/></fo:inline>
		<!-- we need to add zero-width space, otherwise this fo:inline is missing in IF xml -->
		<xsl:if test="not(following-sibling::node()[normalize-space() != ''])"><fo:inline font-size="1pt"> </fo:inline></xsl:if>
	</xsl:template>
	<!-- =================== -->
	<!-- End of Index processing -->
	<!-- =================== -->

		<!-- =================== -->
	<!-- Form's elements processing -->
	<!-- =================== -->
	<xsl:template match="mn:form">
		<fo:block>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:form//mn:label">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>

	<xsl:template match="mn:form//mn:input[@type = 'text' or @type = 'date' or @type = 'file' or @type = 'password']">
		<fo:inline>
			<xsl:call-template name="text_input"/>
		</fo:inline>
	</xsl:template>

	<xsl:template name="text_input">
		<xsl:variable name="count">
			<xsl:choose>
				<xsl:when test="normalize-space(@maxlength) != ''"><xsl:value-of select="@maxlength"/></xsl:when>
				<xsl:when test="normalize-space(@size) != ''"><xsl:value-of select="@size"/></xsl:when>
				<xsl:otherwise>10</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:call-template name="repeat">
			<xsl:with-param name="char" select="'_'"/>
			<xsl:with-param name="count" select="$count"/>
		</xsl:call-template>
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="mn:form//mn:input[@type = 'button']">
		<xsl:variable name="caption">
			<xsl:choose>
				<xsl:when test="normalize-space(@value) != ''"><xsl:value-of select="@value"/></xsl:when>
				<xsl:otherwise>BUTTON</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:inline>[<xsl:value-of select="$caption"/>]</fo:inline>
	</xsl:template>

	<xsl:template match="mn:form//mn:input[@type = 'checkbox']">
		<fo:inline padding-right="1mm">
			<fo:instream-foreign-object fox:alt-text="Box" baseline-shift="-10%">
				<xsl:attribute name="height">3.5mm</xsl:attribute>
				<xsl:attribute name="content-width">100%</xsl:attribute>
				<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
				<xsl:attribute name="scaling">uniform</xsl:attribute>
				<svg xmlns="http://www.w3.org/2000/svg" width="80" height="80">
					<polyline points="0,0 80,0 80,80 0,80 0,0" stroke="black" stroke-width="5" fill="white"/>
				</svg>
			</fo:instream-foreign-object>
		</fo:inline>
	</xsl:template>

	<xsl:template match="mn:form//mn:input[@type = 'radio']">
		<fo:inline padding-right="1mm">
			<fo:instream-foreign-object fox:alt-text="Box" baseline-shift="-10%">
				<xsl:attribute name="height">3.5mm</xsl:attribute>
				<xsl:attribute name="content-width">100%</xsl:attribute>
				<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
				<xsl:attribute name="scaling">uniform</xsl:attribute>
				<svg xmlns="http://www.w3.org/2000/svg" width="80" height="80">
					<circle cx="40" cy="40" r="30" stroke="black" stroke-width="5" fill="white"/>
					<circle cx="40" cy="40" r="15" stroke="black" stroke-width="5" fill="white"/>
				</svg>
			</fo:instream-foreign-object>
		</fo:inline>
	</xsl:template>

	<xsl:template match="mn:form//mn:select">
		<fo:inline>
			<xsl:call-template name="text_input"/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="mn:form//mn:textarea">
		<fo:block-container border="1pt solid black" width="50%">
			<fo:block> </fo:block>
		</fo:block-container>
	</xsl:template>

	<!-- =================== -->
	<!-- End Form's elements processing -->
	<!-- =================== -->

	<xsl:attribute-set name="toc-style">
		<xsl:attribute name="line-height">115%</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_toc-style">
	</xsl:template>

	<xsl:attribute-set name="toc-title-style">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="font-size">12pt</xsl:attribute>
		<xsl:attribute name="margin-top">4pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">7.5pt</xsl:attribute>
		<xsl:attribute name="role">SKIP</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_toc-title-style">
	</xsl:template>

	<xsl:attribute-set name="toc-title-page-style">
	</xsl:attribute-set> <!-- toc-title-page-style -->

	<xsl:template name="refine_toc-title-page-style">
	</xsl:template>

	<xsl:attribute-set name="toc-item-block-style">
		<xsl:attribute name="provisional-distance-between-starts">10mm</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_toc-item-block-style">
		<xsl:attribute name="provisional-distance-between-starts">
			<xsl:choose>
				<xsl:when test="@level &gt;= 1 and @root = 'preface'">0mm</xsl:when>
				<xsl:when test="@level &gt;= 1 and @root = 'annex' and not(@type = 'annex')">13mm</xsl:when>
				<xsl:when test="@level &gt;= 1 and not(@type = 'annex')">
					<xsl:choose>
						<xsl:when test="$toc_level = 3">12.9mm</xsl:when>
						<xsl:when test="$toc_level &gt; 3">15mm</xsl:when>
						<xsl:otherwise>10mm</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>0mm</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>

	<xsl:attribute-set name="toc-item-style">
		<xsl:attribute name="role">TOCI</xsl:attribute>
		<xsl:attribute name="role">SKIP</xsl:attribute>
		<xsl:attribute name="text-align-last">justify</xsl:attribute>
		<xsl:attribute name="margin-left">12mm</xsl:attribute>
		<xsl:attribute name="text-indent">-12mm</xsl:attribute>
	</xsl:attribute-set> <!-- END: toc-item-style -->

	<xsl:template name="refine_toc-item-style">
	</xsl:template> <!-- END: refine_toc-item-style -->

	<xsl:attribute-set name="toc-leader-style">
		<xsl:attribute name="font-size">9pt</xsl:attribute>
		<xsl:attribute name="font-weight">normal</xsl:attribute>
		<xsl:attribute name="leader-pattern">dots</xsl:attribute>
	</xsl:attribute-set> <!-- END: toc-leader-style -->

	<xsl:template name="refine_toc-leader-style">
	</xsl:template>

	<xsl:attribute-set name="toc-pagenumber-style">
	</xsl:attribute-set>

	<xsl:template name="refine_toc-pagenumber-style">
	</xsl:template>

	<!-- List of Figures, Tables -->
	<xsl:attribute-set name="toc-listof-title-style">
		<xsl:attribute name="role">TOCI</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="margin-top">6pt</xsl:attribute>
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_toc-listof-title-style">
	</xsl:template>

	<xsl:attribute-set name="toc-listof-item-block-style">
	</xsl:attribute-set>

	<xsl:template name="refine_toc-listof-item-block-style">
	</xsl:template>

	<xsl:attribute-set name="toc-listof-item-style">
		<xsl:attribute name="role">TOCI</xsl:attribute>
		<xsl:attribute name="text-align-last">justify</xsl:attribute>
		<xsl:attribute name="margin-left">12mm</xsl:attribute>
		<xsl:attribute name="text-indent">-12mm</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_toc-listof-item-style">
	</xsl:template>

	<xsl:template name="processPrefaceSectionsDefault_Contents">
		<xsl:variable name="nodes_preface_">
			<xsl:for-each select="/*/mn:preface/*[not(self::mn:note or self::mn:admonition or @type = 'toc')]">
				<node id="{@id}"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="nodes_preface" select="xalan:nodeset($nodes_preface_)"/>

		<xsl:for-each select="/*/mn:preface/*[not(self::mn:note or self::mn:admonition or @type = 'toc')]">
			<xsl:sort select="@displayorder" data-type="number"/>

			<!-- process Section's title -->
			<xsl:variable name="preceding-sibling_id" select="$nodes_preface/node[@id = current()/@id]/preceding-sibling::node[1]/@id"/>
			<xsl:if test="$preceding-sibling_id != ''">
				<xsl:apply-templates select="parent::*/*[@type = 'section-title' and @id = $preceding-sibling_id and not(@displayorder)]" mode="contents_no_displayorder"/>
			</xsl:if>

			<xsl:apply-templates select="." mode="contents"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="processMainSectionsDefault_Contents">

		<xsl:variable name="nodes_sections_">
			<xsl:for-each select="/*/mn:sections/*">
				<node id="{@id}"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="nodes_sections" select="xalan:nodeset($nodes_sections_)"/>

		<xsl:for-each select="/*/mn:sections/* | /*/mn:bibliography/mn:references[@normative='true'] |    /*/mn:bibliography/mn:clause[mn:references[@normative='true']]">
			<xsl:sort select="@displayorder" data-type="number"/>

			<!-- process Section's title -->
			<xsl:variable name="preceding-sibling_id" select="$nodes_sections/node[@id = current()/@id]/preceding-sibling::node[1]/@id"/>
			<xsl:if test="$preceding-sibling_id != ''">
				<xsl:apply-templates select="parent::*/*[@type = 'section-title' and @id = $preceding-sibling_id and not(@displayorder)]" mode="contents_no_displayorder"/>
			</xsl:if>

			<xsl:apply-templates select="." mode="contents"/>
		</xsl:for-each>

		<!-- <xsl:for-each select="/*/mn:annex">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="." mode="contents"/>
		</xsl:for-each> -->

		<xsl:for-each select="/*/mn:annex | /*/mn:bibliography/*[not(@normative='true') and not(mn:references[@normative='true'])][count(.//mn:bibitem[not(@hidden) = 'true']) &gt; 0] |          /*/mn:bibliography/mn:clause[mn:references[not(@normative='true')]][count(.//mn:bibitem[not(@hidden) = 'true']) &gt; 0]">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="." mode="contents"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="processTablesFigures_Contents">
		<xsl:param name="always"/>
		<xsl:if test="(//mn:metanorma/mn:metanorma-extension/mn:toc[@type='table']/mn:title) or normalize-space($always) = 'true'">
			<xsl:call-template name="processTables_Contents"/>
		</xsl:if>
		<xsl:if test="(//mn:metanorma/mn:metanorma-extension/mn:toc[@type='figure']/mn:title) or normalize-space($always) = 'true'">
			<xsl:call-template name="processFigures_Contents"/>
		</xsl:if>
	</xsl:template>

	<xsl:template name="processTables_Contents">
		<mnx:tables>
			<xsl:for-each select="//mn:table[not(ancestor::mn:metanorma-extension)][@id and mn:fmt-name and normalize-space(@id) != '']">
				<xsl:choose>
					<xsl:when test="mn:fmt-name">
						<xsl:variable name="fmt_name">
							<xsl:apply-templates select="mn:fmt-name" mode="update_xml_step1"/>
						</xsl:variable>
						<mnx:table id="{@id}" alt-text="{normalize-space($fmt_name)}">
							<xsl:copy-of select="$fmt_name"/>
						</mnx:table>
					</xsl:when>
					<xsl:otherwise>
						<mnx:table id="{@id}" alt-text="{mn:name}">
							<xsl:copy-of select="mn:name"/>
						</mnx:table>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</mnx:tables>
	</xsl:template>

	<xsl:template name="processFigures_Contents">
		<mnx:figures>
			<xsl:for-each select="//mn:figure[@id and mn:fmt-name and not(@unnumbered = 'true') and normalize-space(@id) != ''] | //*[@id and starts-with(mn:name, 'Figure ') and normalize-space(@id) != '']">
				<xsl:choose>
					<xsl:when test="mn:fmt-name">
						<xsl:variable name="fmt_name">
							<xsl:apply-templates select="mn:fmt-name" mode="update_xml_step1"/>
						</xsl:variable>
						<mnx:figure id="{@id}" alt-text="{normalize-space($fmt_name)}">
							<xsl:copy-of select="$fmt_name"/>
						</mnx:figure>
					</xsl:when>
					<xsl:otherwise>
						<mnx:figure id="{@id}" alt-text="{mn:name}">
							<xsl:copy-of select="mn:name"/>
						</mnx:figure>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</mnx:figures>
	</xsl:template>

	<xsl:template match="mn:figure/mn:name | mnx:figure/mn:name |                mn:table/mn:name | mnx:table/mn:name |               mn:permission/mn:name | mnx:permission/mn:name |               mn:recommendation/mn:name | mnx:recommendation/mn:name |               mn:requirement/mn:name | mnx:requirement/mn:name" mode="contents">
		<xsl:if test="not(following-sibling::*[1][self::mn:fmt-name])">
			<xsl:apply-templates mode="contents"/>
			<xsl:text> </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:title[following-sibling::*[1][self::mn:fmt-title]]" mode="contents"/>

	<xsl:template match="mn:figure/mn:fmt-name | mnx:figure/mn:fmt-name |               mn:table/mn:fmt-name | mnx:table/mn:fmt-name |               mn:permission/mn:fmt-name | mnx:permission/mn:fmt-name |               mn:recommendation/mn:fmt-name | mnx:recommendation/mn:fmt-name |               mn:requirement/mn:fmt-name | mnx:requirement/mn:fmt-name" mode="contents">
		<xsl:apply-templates mode="contents"/>
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="mn:figure/mn:name | mnx:figure/mn:name |                mn:table/mn:name | mnx:table/mn:name |               mn:permission/mn:name | mnx:permission/mn:name |               mn:recommendation/mn:name | mnx:recommendation/mn:name |               mn:requirement/mn:name | mnx:requirement/mn:name |               mn:sourcecode/mn:name" mode="bookmarks">
		<xsl:if test="not(following-sibling::*[1][self::mn:fmt-name])">
			<xsl:apply-templates mode="bookmarks"/>
			<xsl:text> </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:figure/mn:fmt-name | mnx:figure/mn:fmt-name |                mn:table/mn:fmt-name | mnx:table/mn:fmt-name |                mn:permission/mn:fmt-name | mnx:permission/mn:fmt-name |                mn:recommendation/mn:fmt-name | mnx:recommendation/mn:fmt-name |                mn:requirement/mn:fmt-name | mnx:requirement/mn:fmt-name |                mn:sourcecode/mn:fmt-name | mnx:sourcecode/mn:fmt-name" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="*[self::mn:figure or self::mn:table or self::mn:permission or self::mn:recommendation or self::mn:requirement]/mn:name/text() |    *[self::mnx:figure or self::mnx:table or self::mnx:permission or self::mnx:recommendation or self::mnx:requirement]/mn:name/text()" mode="contents" priority="2">
		<xsl:if test="not(../following-sibling::*[1][self::mn:fmt-name])">
			<xsl:value-of select="."/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[self::mn:figure or self::mn:table or self::mn:permission or self::mn:recommendation or self::mn:requirement]/mn:fmt-name/text() |   *[self::mnx:figure or self::mnx:table or self::mnx:permission or self::mnx:recommendation or self::mnx:requirement]/mn:fmt-name/text()" mode="contents" priority="2">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="*[self::mn:figure or self::mn:table or self::mn:permission or self::mn:recommendation or self::mn:requirement or self::mn:sourcecode]/mn:name//text() |    *[self::mnx:figure or self::mnx:table or self::mnx:permission or self::mnx:recommendation or self::mnx:requirement or self::mnx:sourcecode]/mn:name//text()" mode="bookmarks" priority="2">
		<xsl:if test="not(../following-sibling::*[1][self::mn:fmt-name])">
			<xsl:value-of select="."/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[self::mn:figure or self::mn:table or self::mn:permission or self::mn:recommendation or self::mn:requirement or self::mn:sourcecode]/mn:fmt-name//text() |    *[self::mnx:figure or self::mnx:table or self::mnx:permission or self::mnx:recommendation or self::mnx:requirement or self::mnx:sourcecode]/mn:fmt-name//text()" mode="bookmarks" priority="2">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="mn:add/text()" mode="bookmarks" priority="3"> <!-- mn:add[starts-with(., $ace_tag)] -->
		<xsl:choose>
			<xsl:when test="starts-with(normalize-space(..), $ace_tag)"><!-- skip --></xsl:when>
			<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="node()" mode="contents">
		<xsl:apply-templates mode="contents"/>
	</xsl:template>

	<!-- special case: ignore preface/section-title and sections/section-title without @displayorder  -->
	<xsl:template match="*[self::mn:preface or self::mn:sections]/mn:p[@type = 'section-title' and not(@displayorder)]" priority="3" mode="contents"/>
	<!-- process them by demand (mode="contents_no_displayorder") -->
	<xsl:template match="mn:p[@type = 'section-title' and not(@displayorder)]" mode="contents_no_displayorder">
		<xsl:call-template name="contents_section-title"/>
	</xsl:template>
	<xsl:template match="mn:p[@type = 'section-title']" mode="contents_in_clause">
		<xsl:call-template name="contents_section-title"/>
	</xsl:template>

	<!-- special case: ignore section-title if @depth different than @depth of parent clause, or @depth of parent clause = 1 -->
	<xsl:template match="mn:clause/mn:p[@type = 'section-title' and (@depth != ../*[self::mn:title or self::mn:fmt-title]/@depth or ../*[self::mn:title or self::mn:fmt-title]/@depth = 1)]" priority="3" mode="contents"/>

	<xsl:template match="mn:p[@type = 'floating-title' or @type = 'section-title']" priority="2" name="contents_section-title" mode="contents">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="@depth"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="section">
			<xsl:choose>
				<xsl:when test="@type = 'section-title'"/>
				<xsl:when test="mn:span[@class = 'fmt-caption-delim']">
					<xsl:value-of select="mn:span[@class = 'fmt-caption-delim'][1]/preceding-sibling::node()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="mn:tab[1]/preceding-sibling::node()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="type"><xsl:value-of select="@type"/></xsl:variable>

		<xsl:variable name="display">
			<xsl:choose>
				<xsl:when test="normalize-space(@id) = ''">false</xsl:when>
				<xsl:when test="$level &lt;= $toc_level">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="skip">false</xsl:variable>

		<xsl:if test="$skip = 'false'">

			<xsl:variable name="title">
				<xsl:choose>
					<!-- https://github.com/metanorma/mn-native-pdf/issues/770 -->
					<xsl:when test="mn:span[@class = 'fmt-caption-delim']">
						<xsl:choose>
							<xsl:when test="@type = 'section-title'">
								<xsl:value-of select="mn:span[@class = 'fmt-caption-delim'][1]/preceding-sibling::node()"/>
								<xsl:text>: </xsl:text>
								<xsl:copy-of select="mn:span[@class = 'fmt-caption-delim'][1]/following-sibling::node()[not(self::mn:fmt-xref-label)]"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy-of select="mn:span[@class = 'fmt-caption-delim'][1]/following-sibling::node()[not(self::mn:fmt-xref-label)]"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="mn:tab">
						<xsl:choose>
							<xsl:when test="@type = 'section-title'">
								<xsl:value-of select="mn:tab[1]/preceding-sibling::node()"/>
								<xsl:text>: </xsl:text>
								<xsl:copy-of select="mn:tab[1]/following-sibling::node()"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy-of select="mn:tab[1]/following-sibling::node()"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="node()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="root">
				<xsl:if test="ancestor-or-self::mn:preface">preface</xsl:if>
				<xsl:if test="ancestor-or-self::mn:annex">annex</xsl:if>
			</xsl:variable>

			<mnx:item id="{@id}" level="{$level}" section="{$section}" type="{$type}" root="{$root}" display="{$display}">
				<mnx:title>
					<xsl:apply-templates select="xalan:nodeset($title)" mode="contents_item"/>
				</mnx:title>
			</mnx:item>
		</xsl:if>
	</xsl:template>

	<xsl:template match="node()" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template>

	<xsl:template match="mn:stem" mode="contents"/>

	<xsl:template match="*[self::mn:title or self::mn:name or self::mn:fmt-title or self::mn:fmt-name]//mn:fmt-stem" mode="contents">
		<xsl:apply-templates select="."/>
	</xsl:template>

	<!-- prevent missing stem for table and figures in ToC -->
	<xsl:template match="*[self::mn:name or self::mn:fmt-name]//mn:stem" mode="contents">
		<xsl:if test="not(following-sibling::*[1][self::mn:fmt-stem])">
			<xsl:apply-templates select="."/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:references[@hidden='true']" mode="contents" priority="3"/>

	<xsl:template match="mn:references/mn:bibitem" mode="contents"/>

	<!-- Note: to enable the addition of character span markup with semantic styling for DIS Word output -->
	<xsl:template match="mn:span" mode="contents">
		<xsl:apply-templates mode="contents"/>
	</xsl:template>

	<xsl:template match="mn:semx" mode="contents">
		<xsl:apply-templates mode="contents"/>
	</xsl:template>

	<xsl:template match="mn:concept" mode="contents"/>
	<xsl:template match="mn:eref" mode="contents"/>
	<xsl:template match="mn:xref" mode="contents"/>
	<xsl:template match="mn:link" mode="contents"/>
	<xsl:template match="mn:origin" mode="contents"/>
	<xsl:template match="mn:erefstack" mode="contents"/>

	<xsl:template match="mn:requirement |             mn:recommendation |              mn:permission" mode="contents" priority="3"/>

	<xsl:template match="mn:stem" mode="bookmarks"/>
	<xsl:template match="mn:fmt-stem" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template>

	<!-- Note: to enable the addition of character span markup with semantic styling for DIS Word output -->
	<xsl:template match="mn:span" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template>

	<xsl:template match="mn:semx" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template>

	<xsl:template match="mn:concept" mode="bookmarks"/>
	<xsl:template match="mn:eref" mode="bookmarks"/>
	<xsl:template match="mn:xref" mode="bookmarks"/>
	<xsl:template match="mn:link" mode="bookmarks"/>
	<xsl:template match="mn:origin" mode="bookmarks"/>
	<xsl:template match="mn:erefstack" mode="bookmarks"/>

	<xsl:template match="mn:requirement |             mn:recommendation |              mn:permission" mode="bookmarks" priority="3"/>

	<!-- Bookmarks -->
	<xsl:template name="addBookmarks">
		<xsl:param name="contents"/>
		<xsl:param name="contents_addon"/>
		<xsl:variable name="contents_nodes" select="xalan:nodeset($contents)"/>
		<xsl:if test="$contents_nodes//mnx:item">
			<fo:bookmark-tree>
				<xsl:choose>
					<xsl:when test="$contents_nodes/mnx:doc">
						<xsl:choose>
							<xsl:when test="count($contents_nodes/mnx:doc) &gt; 1">

								<xsl:if test="$contents_nodes/collection">
									<fo:bookmark internal-destination="{$contents/collection/@firstpage_id}">
										<fo:bookmark-title>collection.pdf</fo:bookmark-title>
									</fo:bookmark>
								</xsl:if>

								<xsl:for-each select="$contents_nodes/mnx:doc">
									<fo:bookmark internal-destination="{mnx:contents/mnx:item[@display = 'true'][1]/@id}" starting-state="hide">
										<xsl:if test="@bundle = 'true'">
											<xsl:attribute name="internal-destination"><xsl:value-of select="@firstpage_id"/></xsl:attribute>
										</xsl:if>
										<fo:bookmark-title>
											<xsl:choose>
												<xsl:when test="not(normalize-space(@bundle) = 'true')"> <!-- 'bundle' means several different documents (not language versions) in one xml -->
													<xsl:variable name="bookmark-title_">
														<xsl:call-template name="getLangVersion">
															<xsl:with-param name="lang" select="@lang"/>
															<xsl:with-param name="doctype" select="@doctype"/>
															<xsl:with-param name="title" select="@title-part"/>
														</xsl:call-template>
													</xsl:variable>
													<xsl:choose>
														<xsl:when test="normalize-space($bookmark-title_) != ''">
															<xsl:value-of select="normalize-space($bookmark-title_)"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:choose>
																<xsl:when test="@lang = 'en'">English</xsl:when>
																<xsl:when test="@lang = 'fr'">Français</xsl:when>
																<xsl:when test="@lang = 'de'">Deutsche</xsl:when>
																<xsl:otherwise><xsl:value-of select="@lang"/> version</xsl:otherwise>
															</xsl:choose>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="@title-part"/>
												</xsl:otherwise>
											</xsl:choose>
										</fo:bookmark-title>

										<xsl:apply-templates select="mnx:contents/mnx:item" mode="bookmark"/>

										<xsl:call-template name="insertFigureBookmarks">
											<xsl:with-param name="contents" select="mnx:contents"/>
										</xsl:call-template>

										<xsl:call-template name="insertTableBookmarks">
											<xsl:with-param name="contents" select="mnx:contents"/>
											<xsl:with-param name="lang" select="@lang"/>
										</xsl:call-template>

									</fo:bookmark>

								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="$contents_nodes/mnx:doc">

									<xsl:apply-templates select="mnx:contents/mnx:item" mode="bookmark"/>

									<xsl:call-template name="insertFigureBookmarks">
										<xsl:with-param name="contents" select="mnx:contents"/>
									</xsl:call-template>

									<xsl:call-template name="insertTableBookmarks">
										<xsl:with-param name="contents" select="mnx:contents"/>
										<xsl:with-param name="lang" select="@lang"/>
									</xsl:call-template>

								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="$contents_nodes/mnx:contents/mnx:item" mode="bookmark"/>

						<xsl:call-template name="insertFigureBookmarks">
							<xsl:with-param name="contents" select="$contents_nodes/mnx:contents"/>
						</xsl:call-template>

						<xsl:call-template name="insertTableBookmarks">
							<xsl:with-param name="contents" select="$contents_nodes/mnx:contents"/>
							<xsl:with-param name="lang" select="@lang"/>
						</xsl:call-template>

					</xsl:otherwise>
				</xsl:choose>

				<!-- for $namespace = 'nist-sp' $namespace = 'ogc' $namespace = 'ogc-white-paper' -->
				<xsl:copy-of select="$contents_addon"/>

			</fo:bookmark-tree>
		</xsl:if>
	</xsl:template>

	<xsl:template name="insertFigureBookmarks">
		<xsl:param name="contents"/>
		<xsl:variable name="contents_nodes" select="xalan:nodeset($contents)"/>
		<xsl:if test="$contents_nodes/mnx:figure">
			<fo:bookmark internal-destination="{$contents_nodes/mnx:figure[1]/@id}" starting-state="hide">
				<fo:bookmark-title>Figures</fo:bookmark-title>
				<xsl:for-each select="$contents_nodes/mnx:figure">
					<fo:bookmark internal-destination="{@id}">
						<fo:bookmark-title>
							<xsl:value-of select="normalize-space(mnx:title)"/>
						</fo:bookmark-title>
					</fo:bookmark>
				</xsl:for-each>
			</fo:bookmark>
		</xsl:if>
		<xsl:if test="$contents_nodes//mnx:figures/mnx:figure">
			<fo:bookmark internal-destination="empty_bookmark" starting-state="hide">

				<xsl:variable name="bookmark-title">
							<xsl:value-of select="$title-list-figures"/>
				</xsl:variable>
				<fo:bookmark-title><xsl:value-of select="normalize-space($bookmark-title)"/></fo:bookmark-title>
				<xsl:for-each select="$contents_nodes//mnx:figures/mnx:figure">
					<fo:bookmark internal-destination="{@id}">
						<fo:bookmark-title><xsl:value-of select="normalize-space(.)"/></fo:bookmark-title>
					</fo:bookmark>
				</xsl:for-each>
			</fo:bookmark>
		</xsl:if>
	</xsl:template> <!-- insertFigureBookmarks -->

	<xsl:template name="insertTableBookmarks">
		<xsl:param name="contents"/>
		<xsl:param name="lang"/>
		<xsl:variable name="contents_nodes" select="xalan:nodeset($contents)"/>
		<xsl:if test="$contents_nodes/mnx:table">
			<fo:bookmark internal-destination="{$contents_nodes/mnx:table[1]/@id}" starting-state="hide">
				<fo:bookmark-title>
					<xsl:choose>
						<xsl:when test="$lang = 'fr'">Tableaux</xsl:when>
						<xsl:otherwise>Tables</xsl:otherwise>
					</xsl:choose>
				</fo:bookmark-title>
				<xsl:for-each select="$contents_nodes/mnx:table">
					<fo:bookmark internal-destination="{@id}">
						<fo:bookmark-title>
							<xsl:value-of select="normalize-space(mnx:title)"/>
						</fo:bookmark-title>
					</fo:bookmark>
				</xsl:for-each>
			</fo:bookmark>
		</xsl:if>
		<xsl:if test="$contents_nodes//mnx:tables/mnx:table">
			<fo:bookmark internal-destination="empty_bookmark" starting-state="hide">

				<xsl:variable name="bookmark-title">
							<xsl:value-of select="$title-list-tables"/>
				</xsl:variable>

				<fo:bookmark-title><xsl:value-of select="$bookmark-title"/></fo:bookmark-title>

				<xsl:for-each select="$contents_nodes//mnx:tables/mnx:table">
					<fo:bookmark internal-destination="{@id}">
						<!-- <fo:bookmark-title><xsl:value-of select="normalize-space(.)"/></fo:bookmark-title> -->
						<fo:bookmark-title><xsl:apply-templates mode="bookmark_clean"/></fo:bookmark-title>
					</fo:bookmark>
				</xsl:for-each>
			</fo:bookmark>
		</xsl:if>
	</xsl:template> <!-- insertTableBookmarks -->
	<!-- End Bookmarks -->

	<!-- ============================ -->
	<!-- mode="bookmark_clean" -->
	<!-- ============================ -->
	<xsl:template match="node()" mode="bookmark_clean">
		<xsl:apply-templates select="node()" mode="bookmark_clean"/>
	</xsl:template>

	<xsl:template match="text()" mode="bookmark_clean">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'math']" mode="bookmark_clean">
		<xsl:value-of select="normalize-space(.)"/>
	</xsl:template>

	<xsl:template match="mn:asciimath" mode="bookmark_clean"/>
	<!-- ============================ -->
	<!-- END: mode="bookmark_clean" -->
	<!-- ============================ -->

	<xsl:template name="getLangVersion">
		<xsl:param name="lang"/>
		<xsl:param name="doctype" select="''"/>
		<xsl:param name="title" select="''"/>
		<xsl:choose>
			<xsl:when test="$lang = 'en'">
				</xsl:when>
			<xsl:when test="$lang = 'fr'">
			</xsl:when>
			<xsl:when test="$lang = 'de'">Deutsche</xsl:when>
			<xsl:otherwise><xsl:value-of select="$lang"/> version</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mnx:item" mode="bookmark">
		<xsl:choose>
			<xsl:when test="@id != ''">
				<fo:bookmark internal-destination="{@id}" starting-state="hide">
					<fo:bookmark-title>
						<xsl:if test="@section != ''">
							<xsl:value-of select="@section"/>
							<xsl:text> </xsl:text>
						</xsl:if>
						<xsl:variable name="title">
							<xsl:for-each select="mnx:title/node()">
								<xsl:choose>
									<xsl:when test="local-name() = 'add' and starts-with(., $ace_tag)"><!-- skip --></xsl:when>
									<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</xsl:variable>
						<xsl:value-of select="normalize-space($title)"/>
					</fo:bookmark-title>
					<xsl:apply-templates mode="bookmark"/>
				</fo:bookmark>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="bookmark"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mnx:title" mode="bookmark"/>
	<xsl:template match="text()" mode="bookmark"/>

	<!-- ====== -->
	<!-- ====== -->
	<xsl:template match="mn:title" mode="contents_item">
		<xsl:param name="mode">bookmarks</xsl:param>
		<xsl:if test="not(following-sibling::*[1][self::mn:fmt-title])">
			<xsl:apply-templates mode="contents_item">
				<xsl:with-param name="mode" select="$mode"/>
			</xsl:apply-templates>
			<!-- <xsl:text> </xsl:text> -->
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:fmt-title" mode="contents_item">
		<xsl:param name="mode">bookmarks</xsl:param>
		<xsl:apply-templates mode="contents_item">
			<xsl:with-param name="mode" select="$mode"/>
		</xsl:apply-templates>
		<!-- <xsl:text> </xsl:text> -->
	</xsl:template>

	<xsl:template match="mn:span[                @class = 'fmt-caption-label' or                 @class = 'fmt-element-name' or                @class = 'fmt-caption-delim']" mode="contents_item" priority="3">
		<xsl:apply-templates mode="contents_item"/>
	</xsl:template>

	<xsl:template match="mn:semx" mode="contents_item">
		<xsl:apply-templates mode="contents_item"/>
	</xsl:template>

	<xsl:template match="mn:fmt-xref-label" mode="contents_item"/>

	<xsl:template match="mn:concept" mode="contents_item"/>
	<xsl:template match="mn:eref" mode="contents_item"/>
	<xsl:template match="mn:xref" mode="contents_item"/>
	<xsl:template match="mn:link" mode="contents_item"/>
	<xsl:template match="mn:origin" mode="contents_item"/>
	<xsl:template match="mn:erefstack" mode="contents_item"/>

	<!-- fn -->
	<xsl:template match="mn:fn" mode="contents"/>
	<xsl:template match="mn:fn" mode="bookmarks"/>

	<xsl:template match="mn:fn" mode="contents_item"/>

	<xsl:template match="mn:xref | mn:eref" mode="contents">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="mn:annotation" mode="contents_item"/>

	<xsl:template match="mn:tab" mode="contents_item">
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="mn:strong" mode="contents_item">
		<xsl:param name="element"/>
		<xsl:copy>
			<xsl:apply-templates mode="contents_item">
				<xsl:with-param name="element" select="$element"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:em" mode="contents_item">
		<xsl:copy>
			<xsl:apply-templates mode="contents_item"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:sub" mode="contents_item">
		<xsl:copy>
			<xsl:apply-templates mode="contents_item"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:sup" mode="contents_item">
		<xsl:copy>
			<xsl:apply-templates mode="contents_item"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:stem" mode="contents_item"/>
	<xsl:template match="mn:fmt-stem" mode="contents_item">
		<xsl:copy-of select="."/>
	</xsl:template>

	<xsl:template match="mn:br" mode="contents_item">
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="mn:name" mode="contents_item">
		<xsl:param name="mode">bookmarks</xsl:param>
		<xsl:if test="not(following-sibling::*[1][self::mn:fmt-name])">
			<xsl:apply-templates mode="contents_item">
				<xsl:with-param name="mode" select="$mode"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:fmt-name" mode="contents_item">
		<xsl:param name="mode">bookmarks</xsl:param>
		<xsl:apply-templates mode="contents_item">
			<xsl:with-param name="mode" select="$mode"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="mn:add" mode="contents_item">
		<xsl:param name="mode">bookmarks</xsl:param>
		<xsl:choose>
			<xsl:when test="starts-with(text(), $ace_tag)">
				<xsl:if test="$mode = 'contents'">
					<xsl:copy>
						<xsl:apply-templates mode="contents_item"/>
					</xsl:copy>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise><xsl:apply-templates mode="contents_item"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="text()" mode="contents_item">
		<xsl:variable name="text">
			<!-- to split by '_' and other chars -->
			<mnx:text><xsl:call-template name="add-zero-spaces-java"/></mnx:text>
		</xsl:variable>
		<xsl:for-each select="xalan:nodeset($text)/mnx:text/text()">
			<xsl:call-template name="keep_together_standard_number"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="mn:add/text()" mode="contents_item" priority="2"> <!-- mn:add[starts-with(., $ace_tag)]/text() -->
		<xsl:if test="starts-with(normalize-space(..), $ace_tag)"><xsl:value-of select="."/></xsl:if>
	</xsl:template>

	<!-- Note: to enable the addition of character span markup with semantic styling for DIS Word output -->
	<xsl:template match="mn:span" mode="contents_item">
		<xsl:param name="element"/>
		<xsl:apply-templates mode="contents_item">
			<xsl:with-param name="element" select="$element"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- =================== -->
	<!-- Table of Contents (ToC) processing -->
	<!-- =================== -->

	<xsl:variable name="toc_level">
		<!-- https://www.metanorma.org/author/ref/document-attributes/ -->
		<xsl:variable name="pdftoclevels" select="normalize-space(//mn:metanorma-extension/mn:presentation-metadata[mn:name/text() = 'PDF TOC Heading Levels']/mn:value)"/> <!-- :toclevels-pdf  Number of table of contents levels to render in PDF output; used to override :toclevels:-->
		<xsl:variable name="toclevels" select="normalize-space(//mn:metanorma-extension/mn:presentation-metadata[mn:name/text() = 'TOC Heading Levels']/mn:value)"/> <!-- Number of table of contents levels to render -->
		<xsl:choose>
			<xsl:when test="$pdftoclevels != ''"><xsl:value-of select="number($pdftoclevels)"/></xsl:when> <!-- if there is value in xml -->
			<xsl:when test="$toclevels != ''"><xsl:value-of select="number($toclevels)"/></xsl:when>  <!-- if there is value in xml -->
			<xsl:otherwise><!-- default value -->2
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:template match="mn:toc">
		<xsl:param name="colwidths"/>
		<xsl:variable name="colwidths_">
			<xsl:choose>
				<xsl:when test="not($colwidths)">
					<xsl:variable name="toc_table_simple">
						<mn:tbody>
							<xsl:apply-templates mode="toc_table_width"/>
						</mn:tbody>
					</xsl:variable>
					<!-- <debug_toc_table_simple><xsl:copy-of select="$toc_table_simple"/></debug_toc_table_simple> -->
					<xsl:variable name="cols-count" select="count(xalan:nodeset($toc_table_simple)/*/mn:tr[1]/mn:td)"/>
					<xsl:call-template name="calculate-column-widths-proportional">
						<xsl:with-param name="cols-count" select="$cols-count"/>
						<xsl:with-param name="table" select="$toc_table_simple"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="$colwidths"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- <debug_colwidth><xsl:copy-of select="$colwidths_"/></debug_colwidth> -->
		<fo:block role="TOCI" space-after="16pt">
			<fo:table width="100%" table-layout="fixed">
				<xsl:for-each select="xalan:nodeset($colwidths_)/column">
					<fo:table-column column-width="proportional-column-width({.})"/>
				</xsl:for-each>
				<fo:table-body>
					<xsl:apply-templates/>
				</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:toc//mn:li" priority="2">
		<fo:table-row min-height="5mm">
			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template>

	<xsl:template match="mn:toc//mn:li/mn:p">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="mn:toc//mn:xref | mn:toc//mn:fmt-xref" priority="3">
		<!-- <xref target="cgpm9th1948r6">1.6.3<tab/>&#8220;9th CGPM, 1948:<tab/>decision to establish the SI&#8221;</xref> -->
		<!-- New format: one tab <xref target="cgpm9th1948r6">&#8220;9th CGPM, 1948:<tab/>decision to establish the SI&#8221;</xref> -->
		<!-- <test><xsl:copy-of select="."/></test> -->

		<xsl:variable name="target" select="@target"/>

		<xsl:for-each select="mn:tab">

			<xsl:if test="position() = 1">
				<!-- first column (data before first `tab`) -->
				<fo:table-cell>
					<fo:block line-height-shift-adjustment="disregard-shifts" role="SKIP">
						<xsl:call-template name="insert_basic_link">
							<xsl:with-param name="element">
								<fo:basic-link internal-destination="{$target}" fox:alt-text="{.}">
									<xsl:for-each select="preceding-sibling::node()">
										<xsl:choose>
											<xsl:when test="self::text()"><xsl:value-of select="."/></xsl:when>
											<xsl:otherwise><xsl:apply-templates select="."/></xsl:otherwise>
										</xsl:choose>
									</xsl:for-each>
								</fo:basic-link>
							</xsl:with-param>
						</xsl:call-template>
					</fo:block>
				</fo:table-cell>
			</xsl:if>

			<xsl:variable name="current_id" select="generate-id()"/>
			<fo:table-cell>
				<fo:block line-height-shift-adjustment="disregard-shifts" role="SKIP">
					<xsl:call-template name="insert_basic_link">
						<xsl:with-param name="element">
							<fo:basic-link internal-destination="{$target}" fox:alt-text="{.}">
								<xsl:for-each select="following-sibling::node()[not(self::mn:tab) and preceding-sibling::mn:tab[1][generate-id() = $current_id]]">
									<xsl:choose>
										<xsl:when test="self::text()"><xsl:value-of select="."/></xsl:when>
										<xsl:otherwise><xsl:apply-templates select="."/></xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
							</fo:basic-link>
						</xsl:with-param>
					</xsl:call-template>
				</fo:block>
			</fo:table-cell>
		</xsl:for-each>
		<!-- last column - for page numbers -->
		<fo:table-cell text-align="right" font-size="10pt" font-weight="bold" font-family="Arial">
			<fo:block role="SKIP">
				<xsl:call-template name="insert_basic_link">
					<xsl:with-param name="element">
						<fo:basic-link internal-destination="{$target}" fox:alt-text="{.}">
							<fo:page-number-citation ref-id="{$target}"/>
						</fo:basic-link>
					</xsl:with-param>
				</xsl:call-template>
			</fo:block>
		</fo:table-cell>
	</xsl:template>

	<!-- ================================== -->
	<!-- calculate ToC table columns widths -->
	<!-- ================================== -->
	<xsl:template match="*" mode="toc_table_width">
		<xsl:apply-templates mode="toc_table_width"/>
	</xsl:template>

	<xsl:template match="mn:clause[@type = 'toc']/mn:fmt-title" mode="toc_table_width"/>
	<xsl:template match="mn:clause[not(@type = 'toc')]/mn:fmt-title" mode="toc_table_width"/>

	<xsl:template match="mn:li" mode="toc_table_width">
		<mn:tr>
			<xsl:apply-templates mode="toc_table_width"/>
		</mn:tr>
	</xsl:template>

	<xsl:template match="mn:fmt-xref" mode="toc_table_width">
		<!-- <xref target="cgpm9th1948r6">1.6.3<tab/>&#8220;9th CGPM, 1948:<tab/>decision to establish the SI&#8221;</xref> -->
		<!-- New format - one tab <xref target="cgpm9th1948r6">&#8220;9th CGPM, 1948:<tab/>decision to establish the SI&#8221;</xref> -->
		<xsl:for-each select="mn:tab">
			<xsl:if test="position() = 1">
				<mn:td>
					<xsl:for-each select="preceding-sibling::node()">
						<xsl:choose>
							<xsl:when test="self::text()"><xsl:value-of select="."/></xsl:when>
							<xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</mn:td>
			</xsl:if>
			<xsl:variable name="current_id" select="generate-id()"/>
			<mn:td>
				<xsl:for-each select="following-sibling::node()[not(self::mn:tab) and preceding-sibling::mn:tab[1][generate-id() = $current_id]]">
					<xsl:choose>
						<xsl:when test="self::text()"><xsl:value-of select="."/></xsl:when>
						<xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</mn:td>
		</xsl:for-each>
		<mn:td>333</mn:td> <!-- page number, just for fill -->
	</xsl:template>

	<!-- ================================== -->
	<!-- END: calculate ToC table columns widths -->
	<!-- ================================== -->

	<!-- =================== -->
	<!-- End Table of Contents (ToC) processing -->
	<!-- =================== -->

	<!-- Tabulation processing -->
	<xsl:template match="mn:tab">
		<!-- zero-space char -->
		<xsl:variable name="depth">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="../@depth"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="padding">
			<xsl:choose>
				<xsl:when test="$depth = 2">3</xsl:when>
				<xsl:when test="$depth = 3">3</xsl:when>
				<xsl:otherwise>4</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="padding-right">
			<xsl:choose>
				<xsl:when test="normalize-space($padding) = ''">0</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space($padding)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$lang = 'zh'">
				<fo:inline role="SKIP"><xsl:value-of select="$tab_zh"/></fo:inline>
			</xsl:when>
			<xsl:when test="../../@inline-header = 'true'">
				<fo:inline font-size="90%" role="SKIP">
					<xsl:call-template name="insertNonBreakSpaces">
						<xsl:with-param name="count" select="$padding-right"/>
					</xsl:call-template>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="direction"><xsl:if test="$lang = 'ar'"><xsl:value-of select="$RLM"/></xsl:if></xsl:variable>
				<fo:inline padding-right="{$padding-right}mm" role="SKIP"><xsl:value-of select="$direction"/>​</fo:inline>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template> <!-- tab -->

	<xsl:template match="mn:note/mn:fmt-name/mn:tab" priority="2"/>
	<xsl:template match="mn:termnote/mn:fmt-name/mn:tab" priority="2"/>

	<xsl:template match="mn:note/mn:fmt-name/mn:tab" mode="tab">
		<xsl:attribute name="padding-right">2mm</xsl:attribute>
	</xsl:template>

	<xsl:template name="insertNonBreakSpaces">
		<xsl:param name="count"/>
		<xsl:if test="$count &gt; 0">
			<xsl:text> </xsl:text>
			<xsl:call-template name="insertNonBreakSpaces">
				<xsl:with-param name="count" select="$count - 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:variable name="reviews_">
		<xsl:for-each select="//mn:annotation[not(parent::mn:annotation-container)][@from]">
			<xsl:copy>
				<xsl:copy-of select="@from"/>
				<xsl:copy-of select="@id"/>
			</xsl:copy>
		</xsl:for-each>
		<xsl:for-each select="//mn:fmt-annotation-start[@source]">
			<xsl:copy>
				<xsl:copy-of select="@source"/>
				<xsl:copy-of select="@id"/>
			</xsl:copy>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="reviews" select="xalan:nodeset($reviews_)"/>

	<xsl:template name="addReviewHelper">
		<xsl:if test="$isGenerateTableIF = 'false'">
			<!-- if there is review with from="...", then add small helper block for Annot tag adding, see 'review' template -->
			<xsl:variable name="curr_id" select="@id"/>
			<!-- <xsl:variable name="review_id" select="normalize-space(/@id)"/> -->
			<xsl:for-each select="$reviews//mn:annotation[@from = $curr_id]"> <!-- $reviews//mn:fmt-review-start[@source = $curr_id] -->
				<xsl:variable name="review_id" select="normalize-space(@id)"/>
				<xsl:if test="$review_id != ''"> <!-- i.e. if review found -->
					<fo:block keep-with-next="always" line-height="0.1" id="{$review_id}" font-size="1pt" role="SKIP"><xsl:value-of select="$hair_space"/><fo:basic-link internal-destination="{$review_id}" fox:alt-text="Annot___{$review_id}" role="Annot"><xsl:value-of select="$hair_space"/></fo:basic-link></fo:block>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
		<!-- <fo:block>
			<curr_id><xsl:value-of select="$curr_id"/></curr_id>
			<xsl:copy-of select="$reviews"/>
		</fo:block> -->
	</xsl:template>

	<!-- document text (not figures, or tables) footnotes -->
	<xsl:variable name="reviews_container_">
		<xsl:for-each select="//mn:annotation-container/mn:fmt-annotation-body">
			<xsl:variable name="update_xml_step1">
				<xsl:apply-templates select="." mode="update_xml_step1"/>
			</xsl:variable>
			<xsl:apply-templates select="xalan:nodeset($update_xml_step1)" mode="update_xml_enclose_keep-together_within-line"/>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="reviews_container" select="xalan:nodeset($reviews_container_)"/>

	<xsl:template match="mn:annotation-container"/>

	<!-- for old Presentation XML (before https://github.com/metanorma/isodoc/issues/670) -->
	<xsl:template match="mn:annotation[not(parent::mn:annotation-container)]">  <!-- 'review' will be processed in mn2pdf/review.xsl -->
		<xsl:variable name="id_from" select="normalize-space(current()/@from)"/>
		<xsl:if test="$isGenerateTableIF = 'false'">
		<xsl:choose>
			<!-- if there isn't the attribute '@from', then -->
			<xsl:when test="$id_from = ''">
				<fo:block id="{@id}" font-size="1pt" role="SKIP"><xsl:value-of select="$hair_space"/><fo:basic-link internal-destination="{@id}" fox:alt-text="Annot___{@id}" role="Annot"><xsl:value-of select="$hair_space"/></fo:basic-link></fo:block>
			</xsl:when>
			<!-- if there isn't element with id 'from', then create 'bookmark' here -->
			<xsl:when test="ancestor::mn:metanorma and not(ancestor::mn:metanorma//*[@id = $id_from])">
				<fo:block id="{@from}" font-size="1pt" role="SKIP"><xsl:value-of select="$hair_space"/><fo:basic-link internal-destination="{@from}" fox:alt-text="Annot___{@id}" role="Annot"><xsl:value-of select="$hair_space"/></fo:basic-link></fo:block>
			</xsl:when>
			<xsl:when test="not(/*[@id = $id_from]) and not(/*//*[@id = $id_from]) and not(preceding-sibling::*[@id = $id_from])">
				<fo:block id="{@from}" font-size="1pt" role="SKIP"><xsl:value-of select="$hair_space"/><fo:basic-link internal-destination="{@from}" fox:alt-text="Annot___{@id}" role="Annot"><xsl:value-of select="$hair_space"/></fo:basic-link></fo:block>
			</xsl:when>
		</xsl:choose>
		</xsl:if>
	</xsl:template>

	<!-- for new Presentation XML (https://github.com/metanorma/isodoc/issues/670) -->
	<xsl:template match="mn:fmt-annotation-start" name="fmt-annotation-start"> <!-- 'review' will be processed in mn2pdf/review.xsl -->
		<!-- comment 2019-11-29 -->
		<!-- <fo:block font-weight="bold">Review:</fo:block>
		<xsl:apply-templates /> -->

		<xsl:variable name="id_from" select="normalize-space(current()/@source)"/>

		<xsl:variable name="source" select="normalize-space(@source)"/>

		<xsl:if test="$isGenerateTableIF = 'false'">
		<!-- <xsl:variable name="id_from" select="normalize-space(current()/@from)"/> -->

		<!-- <xsl:if test="@source = @end"> -->
		<!-- following-sibling::node()[1][local-name() = 'bookmark'][@id = $source] and
				following-sibling::node()[2][local-name() = 'fmt-review-end'][@source = $source] -->
			<!-- <fo:block id="{$source}" font-size="1pt" role="SKIP"><xsl:value-of select="$hair_space"/><fo:basic-link internal-destination="{$source}" fox:alt-text="Annot___{$source}" role="Annot"><xsl:value-of select="$hair_space"/></fo:basic-link></fo:block> -->
			<xsl:call-template name="setNamedDestination"/>
			<fo:block id="{@id}" font-size="1pt" role="SKIP" keep-with-next="always" line-height="0.1"><xsl:value-of select="$hair_space"/><fo:basic-link internal-destination="{@id}" fox:alt-text="Annot___{@id}" role="Annot"><xsl:value-of select="$hair_space"/></fo:basic-link></fo:block>
		<!-- </xsl:if> -->
		</xsl:if>

		<xsl:if test="1 = 2">
		<xsl:choose>
			<!-- if there isn't the attribute '@from', then -->
			<xsl:when test="$id_from = ''">
				<fo:block id="{@id}" font-size="1pt" role="SKIP"><xsl:value-of select="$hair_space"/><fo:basic-link internal-destination="{@id}" fox:alt-text="Annot___{@id}" role="Annot"><xsl:value-of select="$hair_space"/></fo:basic-link></fo:block>
			</xsl:when>
			<!-- if there isn't element with id 'from', then create 'bookmark' here -->
			<xsl:when test="ancestor::mn:metanorma and not(ancestor::mn:metanorma//*[@id = $id_from])">
				<fo:block id="{$id_from}" font-size="1pt" role="SKIP"><xsl:value-of select="$hair_space"/><fo:basic-link internal-destination="{$id_from}" fox:alt-text="Annot___{@id}" role="Annot"><xsl:value-of select="$hair_space"/></fo:basic-link></fo:block>
			</xsl:when>
			<xsl:when test="not(/*[@id = $id_from]) and not(/*//*[@id = $id_from]) and not(preceding-sibling::*[@id = $id_from])">
				<fo:block id="{$id_from}" font-size="1pt" role="SKIP"><xsl:value-of select="$hair_space"/><fo:basic-link internal-destination="{$id_from}" fox:alt-text="Annot___{@id}" role="Annot"><xsl:value-of select="$hair_space"/></fo:basic-link></fo:block>
			</xsl:when>
		</xsl:choose>
		</xsl:if>

    <xsl:if test="1 = 2">
		<xsl:choose>
			<!-- if there isn't the attribute '@from', then -->
			<xsl:when test="$id_from = ''">
				<fo:block id="{@id}" font-size="1pt" role="SKIP"><fo:wrapper role="artifact"><xsl:value-of select="$hair_space"/></fo:wrapper></fo:block>
			</xsl:when>
			<!-- if there isn't element with id 'from', then create 'bookmark' here -->
			<xsl:when test="ancestor::mn:metanorma and not(ancestor::mn:metanorma//*[@id = $id_from])">
				<fo:block id="{@from}" font-size="1pt" role="SKIP"><fo:wrapper role="artifact"><xsl:value-of select="$hair_space"/></fo:wrapper></fo:block>
			</xsl:when>
			<xsl:when test="not(/*[@id = $id_from]) and not(/*//*[@id = $id_from]) and not(preceding-sibling::*[@id = $id_from])">
				<fo:block id="{@from}" font-size="1pt" role="SKIP"><fo:wrapper role="artifact"><xsl:value-of select="$hair_space"/></fo:wrapper></fo:block>
			</xsl:when>
		</xsl:choose>
    </xsl:if>

	</xsl:template>

	<!-- https://github.com/metanorma/mn-samples-bsi/issues/312 -->
	<xsl:template match="mn:annotation[@type = 'other']"/>

	<!-- ============ -->
	<!-- errata -->
	<!-- ============ -->
	<xsl:template match="mn:errata">
		<!-- <row>
					<date>05-07-2013</date>
					<type>Editorial</type>
					<change>Changed CA-9 Priority Code from P1 to P2 in <xref target="tabled2"/>.</change>
					<pages>D-3</pages>
				</row>
		-->
		<fo:table table-layout="fixed" width="100%" font-size="10pt" border="1pt solid black">
			<fo:table-column column-width="20mm"/>
			<fo:table-column column-width="23mm"/>
			<fo:table-column column-width="107mm"/>
			<fo:table-column column-width="15mm"/>
			<fo:table-body>
				<fo:table-row text-align="center" font-weight="bold" background-color="black" color="white">
					<fo:table-cell border="1pt solid black"><fo:block role="SKIP">Date</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block role="SKIP">Type</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block role="SKIP">Change</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block role="SKIP">Pages</fo:block></fo:table-cell>
				</fo:table-row>
				<xsl:apply-templates/>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<xsl:template match="mn:errata/mn:row">
		<fo:table-row>
			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template>

	<xsl:template match="mn:errata/mn:row/*">
		<fo:table-cell border="1pt solid black" padding-left="1mm" padding-top="0.5mm">
			<fo:block role="SKIP"><xsl:apply-templates/></fo:block>
		</fo:table-cell>
	</xsl:template>
	<!-- ============ -->
	<!-- END errata -->
	<!-- ============ -->

	<!-- ===================================== -->
	<!-- ===================================== -->
	<!-- Ruby text (CJK languages) rendering -->
	<!-- ===================================== -->
	<!-- ===================================== -->

	<xsl:attribute-set name="ruby-style">
		<xsl:attribute name="text-indent">0mm</xsl:attribute>
		<xsl:attribute name="last-line-end-indent">0mm</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_ruby-style">
		<xsl:if test="not(ancestor::mn:ruby)">
			<xsl:attribute name="alignment-baseline">central</xsl:attribute>
		</xsl:if>
		<xsl:variable name="rt_text" select="mn:rt"/>
		<xsl:variable name="rb_text" select=".//mn:rb[not(mn:ruby)]"/>
		<!-- Example: width="2em"  -->
		<xsl:variable name="text_rt_width" select="java:org.metanorma.fop.Util.getStringWidthByFontSize($rt_text, $font_main, 6)"/>
		<xsl:variable name="text_rb_width" select="java:org.metanorma.fop.Util.getStringWidthByFontSize($rb_text, $font_main, 10)"/>
		<xsl:variable name="text_width">
			<xsl:choose>
				<xsl:when test="$text_rt_width &gt;= $text_rb_width"><xsl:value-of select="$text_rt_width"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$text_rb_width"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:attribute name="width"><xsl:value-of select="$text_width div 10"/>em</xsl:attribute>
	</xsl:template> <!-- refine_ruby-style -->

	<xsl:attribute-set name="rb-style">
		<xsl:attribute name="line-height">1em</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_rb-style">
	</xsl:template>

	<xsl:attribute-set name="rt-style">
		<xsl:attribute name="font-size">0.5em</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="line-height">1.2em</xsl:attribute>
		<xsl:attribute name="space-before">-1.4em</xsl:attribute>
		<xsl:attribute name="space-before.conditionality">retain</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_rt-style">
		<xsl:if test="ancestor::mn:ruby[last()]//mn:ruby or     ancestor::mn:rb">
			<xsl:attribute name="space-before">0em</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:ruby">
		<fo:inline-container xsl:use-attribute-sets="ruby-style">
			<xsl:call-template name="refine_ruby-style"/>

			<xsl:choose>
				<xsl:when test="ancestor::mn:ruby">
					<xsl:apply-templates select="mn:rb"/>
					<xsl:apply-templates select="mn:rt"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="mn:rt"/>
					<xsl:apply-templates select="mn:rb"/>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:apply-templates select="node()[not(self::mn:rt) and not(self::mn:rb)]"/>
		</fo:inline-container>
	</xsl:template>

	<xsl:template match="mn:rb">
		<fo:block xsl:use-attribute-sets="rb-style"><xsl:call-template name="refine_rb-style"/><xsl:apply-templates/></fo:block>
	</xsl:template>

	<xsl:template match="mn:rt">
		<fo:block xsl:use-attribute-sets="rt-style"> <!--  -->
			<xsl:call-template name="refine_rt-style"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- ===================================== -->
	<!-- ===================================== -->
	<!-- END: Ruby text (CJK languages) rendering -->
	<!-- ===================================== -->
	<!-- ===================================== -->

	<xsl:attribute-set name="annex-title-style">
		<xsl:attribute name="font-size">12pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="role">H1</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_annex-title-style">
	</xsl:template>

	<xsl:attribute-set name="p-zzSTDTitle1-style">
	</xsl:attribute-set>

	<xsl:template name="refine_p-zzSTDTitle1-style">
	</xsl:template>

	<xsl:template name="processPrefaceSectionsDefault">
		<xsl:for-each select="/*/mn:preface/*[not(self::mn:note or self::mn:admonition)]">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="."/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="copyCommonElements">
		<!-- copy bibdata, localized-strings, metanorma-extension and boilerplate -->
		<xsl:copy-of select="/*/*[not(self::mn:preface) and not(self::mn:sections) and not(self::mn:annex) and not(self::mn:bibliography) and not(self::mn:indexsect)]"/>
	</xsl:template>

	<xsl:template name="processMainSectionsDefault">
		<xsl:for-each select="/*/mn:sections/* | /*/mn:bibliography/mn:references[@normative='true']">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="."/>
		</xsl:for-each>

		<xsl:for-each select="/*/mn:annex">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="."/>
		</xsl:for-each>

		<xsl:for-each select="/*/mn:bibliography/*[not(@normative='true')] |          /*/mn:bibliography/mn:clause[mn:references[not(@normative='true')]]">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="."/>
		</xsl:for-each>
	</xsl:template><!-- END: processMainSectionsDefault -->

	<xsl:template name="deleteFile">
		<xsl:param name="filepath"/>
		<xsl:variable name="xml_file" select="java:java.io.File.new($filepath)"/>
		<xsl:variable name="xml_file_path" select="java:toPath($xml_file)"/>
		<xsl:variable name="deletefile" select="java:java.nio.file.Files.deleteIfExists($xml_file_path)"/>
	</xsl:template>

	<xsl:template name="getPageSequenceOrientation">
		<xsl:variable name="previous_orientation" select="preceding-sibling::mn:page_sequence[@orientation][1]/@orientation"/>
		<xsl:choose>
			<xsl:when test="@orientation = 'landscape'">-<xsl:value-of select="@orientation"/></xsl:when>
			<xsl:when test="$previous_orientation = 'landscape' and not(@orientation = 'portrait')">-<xsl:value-of select="$previous_orientation"/></xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:variable name="regex_standard_reference">([A-Z]{2,}(/[A-Z]{2,})* \d+(-\d+)*(:\d{4})?)</xsl:variable> <!-- example: ISO 1234:2000 -->
	<xsl:variable name="tag_fo_inline_keep-together_within-line_open">###fo:inline keep-together_within-line###</xsl:variable>
	<xsl:variable name="tag_fo_inline_keep-together_within-line_close">###/fo:inline keep-together_within-line###</xsl:variable>
	<xsl:template match="text()" name="text">
		<xsl:choose>
			<xsl:when test="ancestor::mn:table"><xsl:value-of select="."/></xsl:when>
			<xsl:otherwise>
				<xsl:variable name="text" select="java:replaceAll(java:java.lang.String.new(.),$regex_standard_reference,concat($tag_fo_inline_keep-together_within-line_open,'$1',$tag_fo_inline_keep-together_within-line_close))"/>
				<xsl:call-template name="replace_fo_inline_tags">
					<xsl:with-param name="tag_open" select="$tag_fo_inline_keep-together_within-line_open"/>
					<xsl:with-param name="tag_close" select="$tag_fo_inline_keep-together_within-line_close"/>
					<xsl:with-param name="text" select="$text"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="replace_fo_inline_tags">
		<xsl:param name="tag_open"/>
		<xsl:param name="tag_close"/>
		<xsl:param name="text"/>
		<xsl:choose>
			<xsl:when test="contains($text, $tag_open)">
				<xsl:value-of select="substring-before($text, $tag_open)"/>
				<!-- <xsl:text disable-output-escaping="yes">&lt;fo:inline keep-together.within-line="always"&gt;</xsl:text> -->
				<xsl:variable name="text_after" select="substring-after($text, $tag_open)"/>
				<xsl:choose>
					<xsl:when test="local-name(..) = 'keep-together_within-line'"> <!-- prevent two nested <fo:inline keep-together.within-line="always"><fo:inline keep-together.within-line="always" -->
						<xsl:value-of select="substring-before($text_after, $tag_close)"/>
					</xsl:when>
					<xsl:otherwise>
						<fo:inline keep-together.within-line="always" role="SKIP">
							<xsl:value-of select="substring-before($text_after, $tag_close)"/>
						</fo:inline>
					</xsl:otherwise>
				</xsl:choose>
				<!-- <xsl:text disable-output-escaping="yes">&lt;/fo:inline&gt;</xsl:text> -->
				<xsl:call-template name="replace_fo_inline_tags">
					<xsl:with-param name="tag_open" select="$tag_open"/>
					<xsl:with-param name="tag_close" select="$tag_close"/>
					<xsl:with-param name="text" select="substring-after($text_after, $tag_close)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$text"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- keep-together for standard's name (ISO 12345:2020), added in mode="update_xml_enclose_keep-together_within-line" -->
	<xsl:template match="*[local-name() = 'keep-together_within-line']">
		<xsl:param name="split_keep-within-line"/>

		<!-- <fo:inline>split_keep-within-line='<xsl:value-of select="$split_keep-within-line"/>'</fo:inline> -->
		<xsl:choose>

			<xsl:when test="normalize-space($split_keep-within-line) = 'true'">
				<xsl:variable name="sep">_</xsl:variable>
				<xsl:variable name="items">
					<xsl:call-template name="split">
						<xsl:with-param name="pText" select="."/>
						<xsl:with-param name="sep" select="$sep"/>
						<xsl:with-param name="normalize-space">false</xsl:with-param>
						<xsl:with-param name="keep_sep">true</xsl:with-param>
					</xsl:call-template>
				</xsl:variable>
				<xsl:for-each select="xalan:nodeset($items)/mnx:item">
					<xsl:choose>
						<xsl:when test=". = $sep">
							<xsl:value-of select="$sep"/><xsl:value-of select="$zero_width_space"/>
						</xsl:when>
						<xsl:otherwise>
							<fo:inline keep-together.within-line="always" role="SKIP"><xsl:apply-templates/></fo:inline>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>

			<xsl:otherwise>
				<fo:inline keep-together.within-line="always" role="SKIP"><xsl:apply-templates/></fo:inline>
			</xsl:otherwise>

		</xsl:choose>
	</xsl:template>

	<!-- add zero spaces into table cells text -->
	<xsl:template match="*[local-name() = 'td']//text() | *[local-name() = 'th']//text() | *[local-name() = 'dt']//text() | *[local-name() = 'dd']//text()" priority="1">
		<xsl:choose>
			<xsl:when test="parent::*[local-name() = 'keep-together_within-line']">
				<xsl:value-of select="."/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="addZeroWidthSpacesToTextNodes"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="addZeroWidthSpacesToTextNodes">
		<xsl:variable name="text"><text><xsl:call-template name="text"/></text></xsl:variable>
		<!-- <xsl:copy-of select="$text"/> -->
		<xsl:for-each select="xalan:nodeset($text)/text/node()">
			<xsl:choose>
				<xsl:when test="self::text()"><xsl:call-template name="add-zero-spaces-java"/></xsl:when>
				<xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise> <!-- copy 'as-is' for <fo:inline keep-together.within-line="always" ...  -->
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<!-- default: ignore title in sections/p -->
	<xsl:template match="mn:sections/mn:p[starts-with(@class, 'zzSTDTitle')]" priority="3"/>

	<xsl:template match="mn:pagebreak">
		<fo:block break-after="page"/>
		<fo:block> </fo:block>
		<fo:block break-after="page"/>
	</xsl:template>

	<xsl:variable name="font_main_root_style">
		<root-style xsl:use-attribute-sets="root-style">
		</root-style>
	</xsl:variable>
	<xsl:variable name="font_main_root_style_font_family" select="xalan:nodeset($font_main_root_style)/root-style/@font-family"/>
	<xsl:variable name="font_main">
		<xsl:choose>
			<xsl:when test="contains($font_main_root_style_font_family, ',')"><xsl:value-of select="substring-before($font_main_root_style_font_family, ',')"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$font_main_root_style_font_family"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:template name="getLang">
		<xsl:variable name="language_current" select="normalize-space(//mn:bibdata//mn:language[@current = 'true'])"/>
		<xsl:variable name="language">
			<xsl:choose>
				<xsl:when test="$language_current != ''">
					<xsl:value-of select="$language_current"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="language_current_2" select="normalize-space(xalan:nodeset($bibdata)//mn:bibdata//mn:language[@current = 'true'])"/>
					<xsl:choose>
						<xsl:when test="$language_current_2 != ''">
							<xsl:value-of select="$language_current_2"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="language_current_3" select="normalize-space(//mn:bibdata//mn:language)"/>
							<xsl:choose>
								<xsl:when test="$language_current_3 != ''">
									<xsl:value-of select="$language_current_3"/>
								</xsl:when>
								<xsl:otherwise>en</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$language = 'English'">en</xsl:when>
			<xsl:otherwise><xsl:value-of select="$language"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="getLang_fromCurrentNode">
		<xsl:variable name="language_current" select="normalize-space(.//mn:bibdata//mn:language[@current = 'true'])"/>
		<xsl:variable name="language">
			<xsl:choose>
				<xsl:when test="$language_current != ''">
					<xsl:value-of select="$language_current"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="language_current_2" select="normalize-space(xalan:nodeset($bibdata)//mn:bibdata//mn:language[@current = 'true'])"/>
					<xsl:choose>
						<xsl:when test="$language_current_2 != ''">
							<xsl:value-of select="$language_current_2"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select=".//mn:bibdata//mn:language"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$language = 'English'">en</xsl:when>
			<xsl:otherwise><xsl:value-of select="$language"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="capitalizeWords">
		<xsl:param name="str"/>
		<xsl:variable name="str2" select="translate($str, '-', ' ')"/>
		<xsl:choose>
			<xsl:when test="contains($str2, ' ')">
				<xsl:variable name="substr" select="substring-before($str2, ' ')"/>
				<xsl:call-template name="capitalize">
					<xsl:with-param name="str" select="$substr"/>
				</xsl:call-template>
				<xsl:text> </xsl:text>
				<xsl:call-template name="capitalizeWords">
					<xsl:with-param name="str" select="substring-after($str2, ' ')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="capitalize">
					<xsl:with-param name="str" select="$str2"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="capitalize">
		<xsl:param name="str"/>
		<xsl:value-of select="java:toUpperCase(java:java.lang.String.new(substring($str, 1, 1)))"/>
		<xsl:value-of select="substring($str, 2)"/>
	</xsl:template>

	<xsl:template match="mn:localityStack"/>

	<xsl:variable name="pdfAttachmentsList_">
		<xsl:for-each select="//mn:metanorma/mn:metanorma-extension/mn:attachment">
			<attachment filename="{@name}"/>
		</xsl:for-each>
		<xsl:if test="not(//mn:metanorma/mn:metanorma-extension/mn:attachment)">
			<xsl:for-each select="//mn:bibitem[@hidden = 'true'][mn:uri[@type = 'attachment']]">
				<xsl:variable name="attachment_path" select="mn:uri[@type = 'attachment']"/>
				<attachment filename="{$attachment_path}"/>
			</xsl:for-each>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="pdfAttachmentsList" select="xalan:nodeset($pdfAttachmentsList_)"/>

	<xsl:template name="getAltText">
		<xsl:choose>
			<xsl:when test="normalize-space(.) = ''"><xsl:value-of select="@target"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="normalize-space(translate(normalize-space(), ' —', ' -'))"/></xsl:otherwise>
			<!-- <xsl:otherwise><xsl:value-of select="@target"/></xsl:otherwise> -->
		</xsl:choose>
	</xsl:template>

	<xsl:template name="setBlockSpanAll">
		<xsl:if test="@columns = 1 or     (local-name() = 'p' and *[@columns = 1])"><xsl:attribute name="span">all</xsl:attribute></xsl:if>
	</xsl:template>

	<xsl:template name="getSection">
		<xsl:choose>
			<xsl:when test="mn:fmt-title">
				<xsl:variable name="fmt_title_section">
					<xsl:copy-of select="mn:fmt-title//mn:span[@class = 'fmt-caption-delim'][mn:tab][1]/preceding-sibling::node()[not(self::mn:annotation)]"/>
				</xsl:variable>
				<xsl:value-of select="normalize-space($fmt_title_section)"/>
				<xsl:if test="normalize-space($fmt_title_section) = ''">
					<xsl:value-of select="mn:fmt-title/mn:tab[1]/preceding-sibling::node()"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="mn:title/mn:tab[1]/preceding-sibling::node()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="getName">
		<xsl:choose>
			<xsl:when test="mn:fmt-title//mn:span[@class = 'fmt-caption-delim'][mn:tab]">
				<xsl:copy-of select="mn:fmt-title//mn:span[@class = 'fmt-caption-delim'][mn:tab][1]/following-sibling::node()"/>
			</xsl:when>
			<xsl:when test="mn:fmt-title/mn:tab">
				<xsl:copy-of select="mn:fmt-title/mn:tab[1]/following-sibling::node()"/>
			</xsl:when>
			<xsl:when test="mn:fmt-title">
				<xsl:copy-of select="mn:fmt-title/node()"/>
			</xsl:when>
			<xsl:when test="mn:title/mn:tab">
				<xsl:copy-of select="mn:title/mn:tab[1]/following-sibling::node()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="mn:title/node()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="extractSection">
		<xsl:value-of select="mn:tab[1]/preceding-sibling::node()"/>
	</xsl:template>

	<xsl:template name="extractTitle">
		<xsl:choose>
				<xsl:when test="mn:tab">
					<xsl:apply-templates select="mn:tab[1]/following-sibling::node()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
	</xsl:template>

	<!-- main sections -->
	<xsl:template match="/*/mn:sections/*" name="sections_node" priority="2">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block>
			<xsl:call-template name="setId"/>

			<xsl:call-template name="sections_element_style"/>

			<xsl:call-template name="addReviewHelper"/>

			<xsl:apply-templates/>
		</fo:block>

	</xsl:template>

	<!-- note: @top-level added in mode=" update_xml_step_move_pagebreak" -->
	<xsl:template match="mn:sections/mn:page_sequence/*[not(@top-level)]" priority="2">
		<xsl:choose>
			<xsl:when test="self::mn:clause and normalize-space() = '' and count(*) = 0"/>
			<xsl:otherwise>
				<xsl:call-template name="sections_node"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- page_sequence/sections/clause -->
	<xsl:template match="mn:page_sequence/mn:sections/*[not(@top-level)]" priority="2">
		<xsl:choose>
			<xsl:when test="self::mn:clause and normalize-space() = '' and count(*) = 0"/>
			<xsl:otherwise>
				<xsl:call-template name="sections_node"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="sections_element_style">
	</xsl:template> <!-- sections_element_style -->

	<xsl:template match="//mn:metanorma/mn:preface/*" priority="2" name="preface_node"> <!-- /*/mn:preface/* -->
		<fo:block break-after="page"/>
		<xsl:call-template name="setNamedDestination"/>
		<fo:block>
			<xsl:call-template name="setId"/>
			<xsl:call-template name="addReviewHelper"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- preface/ page_sequence/clause -->
	<xsl:template match="mn:preface/mn:page_sequence/*[not(@top-level)]" priority="2"> <!-- /*/mn:preface/* -->
		<xsl:choose>
			<xsl:when test="self::mn:clause and normalize-space() = '' and count(*) = 0"/>
			<xsl:otherwise>
				<xsl:call-template name="preface_node"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- page_sequence/preface/clause -->
	<xsl:template match="mn:page_sequence/mn:preface/*[not(@top-level)]" priority="2"> <!-- /*/mn:preface/* -->
		<xsl:choose>
			<xsl:when test="self::mn:clause and normalize-space() = '' and count(*) = 0"/>
			<xsl:otherwise>
				<xsl:call-template name="preface_node"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mn:clause[normalize-space() != '' or mn:figure or @id]" name="template_clause"> <!-- if clause isn't empty -->
		<xsl:call-template name="setNamedDestination"/>
		<fo:block>
			<xsl:if test="parent::mn:copyright-statement">
				<xsl:attribute name="role">SKIP</xsl:attribute>
			</xsl:if>

			<xsl:call-template name="setId"/>

			<xsl:call-template name="setBlockSpanAll"/>

			<xsl:call-template name="refine_clause_style"/>

			<xsl:call-template name="addReviewHelper"/>

			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template name="refine_clause_style">
	</xsl:template> <!-- refine_clause_style -->

	<xsl:template match="mn:annex[normalize-space() != '']">
		<xsl:choose>
			<xsl:when test="@continue = 'true'"> <!-- it's using for figure/table on top level for block span -->
				<fo:block>
					<xsl:apply-templates/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>

				<fo:block break-after="page"/>
				<xsl:call-template name="setNamedDestination"/>

				<fo:block id="{@id}">

					<xsl:call-template name="setBlockSpanAll"/>

					<xsl:call-template name="refine_annex_style"/>

				</fo:block>

				<xsl:apply-templates select="mn:fmt-title[@columns = 1]"/>

				<fo:block>
					<xsl:apply-templates select="node()[not(self::mn:fmt-title and @columns = 1)]"/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="refine_annex_style">
	</xsl:template>

	<xsl:template match="mn:name/text() | mn:fmt-name/text()">
		<!-- 0xA0 to space replacement -->
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),' ',' ')"/>
	</xsl:template>

	<!-- insert fo:basic-link, if external-destination or internal-destination is non-empty, otherwise insert fo:inline -->
	<xsl:template name="insert_basic_link">
		<xsl:param name="element"/>
		<xsl:variable name="element_node" select="xalan:nodeset($element)"/>
		<xsl:variable name="external-destination" select="normalize-space(count($element_node/fo:basic-link/@external-destination[. != '']) = 1)"/>
		<xsl:variable name="internal-destination" select="normalize-space(count($element_node/fo:basic-link/@internal-destination[. != '']) = 1)"/>
		<xsl:choose>
			<xsl:when test="$external-destination = 'true' or $internal-destination = 'true'">
				<xsl:copy-of select="$element_node"/>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline>
					<xsl:for-each select="$element_node/fo:basic-link/@*[local-name() != 'external-destination' and local-name() != 'internal-destination' and local-name() != 'alt-text']">
						<xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
					</xsl:for-each>
					<xsl:copy-of select="$element_node/fo:basic-link/node()"/>
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mn:variant-title"/> <!-- [@type = 'sub'] -->
	<xsl:template match="mn:variant-title[@type = 'sub']" mode="subtitle">
		<fo:inline padding-right="5mm"> </fo:inline>
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>

	<xsl:template match="mn:blacksquare" name="blacksquare">
		<fo:inline padding-right="2.5mm" baseline-shift="5%">
			<fo:instream-foreign-object content-height="2mm" content-width="2mm" fox:alt-text="Quad">
					<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xml:space="preserve" viewBox="0 0 2 2">
						<rect x="0" y="0" width="2" height="2" fill="black"/>
					</svg>
				</fo:instream-foreign-object>
		</fo:inline>
	</xsl:template>

	<xsl:template match="@language">
		<xsl:copy-of select="."/>
	</xsl:template>

	<xsl:template match="mn:p[@type = 'floating-title' or @type = 'section-title']" priority="4">
		<xsl:call-template name="title"/>
	</xsl:template>

	<!-- https://github.com/metanorma/isodoc/issues/652 -->
	<xsl:template match="mn:quote/mn:source"/>
	<xsl:template match="mn:quote/mn:author"/>
	<xsl:template match="mn:amend"/>

	<!-- fmt-title renamed to title in update_xml_step1 -->
	<!-- <xsl:template match="mn:fmt-title" /> -->

	<!-- fmt-name renamed to name in update_xml_step1 -->
	<!-- <xsl:template match="mn:fmt-name" /> -->

	<!-- fmt-preferred renamed to preferred in update_xml_step1 -->
	<!-- <xsl:template match="mn:fmt-preferred" /> -->

	<!-- fmt-admitted renamed to admitted in update_xml_step1 -->
	<!-- <xsl:template match="mn:fmt-admitted" /> -->

	<!-- fmt-deprecates renamed to deprecates in update_xml_step1 -->
	<!-- <xsl:template match="mn:fmt-deprecates" /> -->

	<!-- fmt-definition renamed to definition in update_xml_step1 -->
	<!-- <xsl:template match="mn:fmt-definition" /> -->

	<!-- fmt-termsource renamed to termsource in update_xml_step1 -->
	<!-- <xsl:template match="mn:fmt-termsource" /> -->

	<!-- fmt-source renamed to source in update_xml_step1 -->
	<!-- <xsl:template match="mn:fmt-source" /> -->

	<xsl:template match="mn:semx">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="mn:fmt-xref-label"/>

	<xsl:template match="mn:concept"/>

	<xsl:template match="mn:fmt-concept">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="mn:erefstack"/>

	<xsl:template match="mn:svgmap"/>

	<xsl:template match="mn:name[following-sibling::*[1][self::mn:fmt-name]]"/>

	<!-- for correct rendering combining chars, added in mode="update_xml_step2" -->
	<xsl:template match="*[local-name() = 'lang_none']">
		<fo:inline xml:lang="none"><xsl:value-of select="."/></fo:inline>
	</xsl:template>

	<xsl:template name="addTagElementT">
		<xsl:variable name="title_">
			<xsl:apply-templates select="mn:fmt-title"/>
		</xsl:variable>
		<xsl:variable name="title__">
			<xsl:for-each select="xalan:nodeset($title_)/*/node()">
				<xsl:choose>
					<xsl:when test="self::text()"><xsl:text> </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text></xsl:when>
					<xsl:otherwise><xsl:text> </xsl:text><xsl:copy-of select="."/><xsl:text> </xsl:text></xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="title" select="normalize-space($title__)"/>
		<xsl:if test="$title != ''">
			<xsl:attribute name="fox:title">
				<xsl:if test="ancestor::mn:sections">
					<xsl:text>Section </xsl:text>
				</xsl:if>
				<xsl:value-of select="$title"/></xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:template name="replaceChar">
		<xsl:param name="text"/>
		<xsl:param name="replace"/>
		<xsl:param name="by"/>
		<xsl:choose>
			<xsl:when test="$text = '' or $replace = '' or not($replace)">
				<xsl:value-of select="$text"/>
			</xsl:when>
			<xsl:when test="contains($text, $replace)">
				<xsl:value-of select="substring-before($text,$replace)"/>
				<xsl:element name="inlineChar" namespace="{$namespace_full}"><xsl:value-of select="$by"/></xsl:element>
				<xsl:call-template name="replaceChar">
						<xsl:with-param name="text" select="substring-after($text,$replace)"/>
						<xsl:with-param name="replace" select="$replace"/>
						<xsl:with-param name="by" select="$by"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- inlineChar added in the template replaceChar -->
	<xsl:template match="mn:inlineChar">
		<fo:inline><xsl:value-of select="."/></fo:inline>
	</xsl:template>

	<xsl:template name="printEdition">
		<xsl:variable name="edition_i18n" select="normalize-space((//mn:metanorma)[1]/mn:bibdata/mn:edition[normalize-space(@language) != ''])"/>
		<xsl:choose>
			<xsl:when test="$edition_i18n != ''">
				<!-- Example: <edition language="fr">deuxième édition</edition> -->
				<xsl:call-template name="capitalize">
					<xsl:with-param name="str" select="$edition_i18n"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="edition" select="normalize-space((//mn:metanorma)[1]/mn:bibdata/mn:edition)"/>
				<xsl:if test="$edition != ''"> <!-- Example: 1.3 -->
					<xsl:call-template name="capitalize">
						<xsl:with-param name="str">
							<xsl:call-template name="getLocalizedString">
								<xsl:with-param name="key">edition</xsl:with-param>
							</xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:text> </xsl:text>
					<xsl:value-of select="$edition"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- convert YYYY-MM-DD to 'Month YYYY' or 'Month DD, YYYY' or DD Month YYYY -->
	<xsl:template name="convertDate">
		<xsl:param name="date"/>
		<xsl:param name="format" select="'short'"/>
		<xsl:variable name="year" select="substring($date, 1, 4)"/>
		<xsl:variable name="month" select="substring($date, 6, 2)"/>
		<xsl:variable name="day" select="substring($date, 9, 2)"/>
		<xsl:variable name="monthStr">
			<xsl:call-template name="getMonthByNum">
				<xsl:with-param name="num" select="$month"/>
				<xsl:with-param name="lowercase" select="'true'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="monthStr_localized">
			<xsl:if test="normalize-space($monthStr) != ''"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_<xsl:value-of select="$monthStr"/></xsl:with-param></xsl:call-template></xsl:if>
		</xsl:variable>
		<xsl:variable name="result">
			<xsl:choose>
				<xsl:when test="$format = 'ddMMyyyy'"> <!-- convert date from format 2007-04-01 to 1 April 2007 -->
					<xsl:if test="$day != ''"><xsl:value-of select="number($day)"/></xsl:if>
					<xsl:text> </xsl:text>
					<xsl:value-of select="normalize-space(concat($monthStr_localized, ' ' , $year))"/>
				</xsl:when>
				<xsl:when test="$format = 'ddMM'">
					<xsl:if test="$day != ''"><xsl:value-of select="number($day)"/></xsl:if>
					<xsl:text> </xsl:text><xsl:value-of select="$monthStr_localized"/>
				</xsl:when>
				<xsl:when test="$format = 'short' or $day = ''">
					<xsl:value-of select="normalize-space(concat($monthStr_localized, ' ', $year))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(concat($monthStr_localized, ' ', $day, ', ' , $year))"/> <!-- January 01, 2022 -->
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$result"/>
	</xsl:template> <!-- convertDate -->

	<!-- return Month's name by number -->
	<xsl:template name="getMonthByNum">
		<xsl:param name="num"/>
		<xsl:param name="lang">en</xsl:param>
		<xsl:param name="lowercase">false</xsl:param> <!-- return 'january' instead of 'January' -->
		<xsl:variable name="monthStr_">
			<xsl:choose>
				<xsl:when test="$lang = 'fr'">
					<xsl:choose>
						<xsl:when test="$num = '01'">Janvier</xsl:when>
						<xsl:when test="$num = '02'">Février</xsl:when>
						<xsl:when test="$num = '03'">Mars</xsl:when>
						<xsl:when test="$num = '04'">Avril</xsl:when>
						<xsl:when test="$num = '05'">Mai</xsl:when>
						<xsl:when test="$num = '06'">Juin</xsl:when>
						<xsl:when test="$num = '07'">Juillet</xsl:when>
						<xsl:when test="$num = '08'">Août</xsl:when>
						<xsl:when test="$num = '09'">Septembre</xsl:when>
						<xsl:when test="$num = '10'">Octobre</xsl:when>
						<xsl:when test="$num = '11'">Novembre</xsl:when>
						<xsl:when test="$num = '12'">Décembre</xsl:when>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$num = '01'">January</xsl:when>
						<xsl:when test="$num = '02'">February</xsl:when>
						<xsl:when test="$num = '03'">March</xsl:when>
						<xsl:when test="$num = '04'">April</xsl:when>
						<xsl:when test="$num = '05'">May</xsl:when>
						<xsl:when test="$num = '06'">June</xsl:when>
						<xsl:when test="$num = '07'">July</xsl:when>
						<xsl:when test="$num = '08'">August</xsl:when>
						<xsl:when test="$num = '09'">September</xsl:when>
						<xsl:when test="$num = '10'">October</xsl:when>
						<xsl:when test="$num = '11'">November</xsl:when>
						<xsl:when test="$num = '12'">December</xsl:when>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="normalize-space($lowercase) = 'true'">
				<xsl:value-of select="java:toLowerCase(java:java.lang.String.new($monthStr_))"/>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$monthStr_"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- getMonthByNum -->

	<!-- return Month's name by number from localized strings -->
	<xsl:template name="getMonthLocalizedByNum">
		<xsl:param name="num"/>
		<xsl:variable name="monthStr">
			<xsl:choose>
				<xsl:when test="$num = '01'">january</xsl:when>
				<xsl:when test="$num = '02'">february</xsl:when>
				<xsl:when test="$num = '03'">march</xsl:when>
				<xsl:when test="$num = '04'">april</xsl:when>
				<xsl:when test="$num = '05'">may</xsl:when>
				<xsl:when test="$num = '06'">june</xsl:when>
				<xsl:when test="$num = '07'">july</xsl:when>
				<xsl:when test="$num = '08'">august</xsl:when>
				<xsl:when test="$num = '09'">september</xsl:when>
				<xsl:when test="$num = '10'">october</xsl:when>
				<xsl:when test="$num = '11'">november</xsl:when>
				<xsl:when test="$num = '12'">december</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:call-template name="getLocalizedString">
			<xsl:with-param name="key">month_<xsl:value-of select="$monthStr"/></xsl:with-param>
		</xsl:call-template>
	</xsl:template> <!-- getMonthLocalizedByNum -->

	<xsl:template name="insertKeywords">
		<xsl:param name="sorting" select="'true'"/>
		<xsl:param name="meta" select="'false'"/>
		<xsl:param name="charAtEnd" select="'.'"/>
		<xsl:param name="charDelim" select="', '"/>
		<xsl:choose>
			<xsl:when test="$sorting = 'true' or $sorting = 'yes'">
				<xsl:for-each select="//mn:metanorma/mn:bibdata//mn:keyword">
					<xsl:sort data-type="text" order="ascending"/>
					<xsl:call-template name="insertKeyword">
						<xsl:with-param name="meta" select="$meta"/>
						<xsl:with-param name="charAtEnd" select="$charAtEnd"/>
						<xsl:with-param name="charDelim" select="$charDelim"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="//mn:metanorma/mn:bibdata//mn:keyword">
					<xsl:call-template name="insertKeyword">
						<xsl:with-param name="meta" select="$meta"/>
						<xsl:with-param name="charAtEnd" select="$charAtEnd"/>
						<xsl:with-param name="charDelim" select="$charDelim"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="insertKeyword">
		<xsl:param name="charAtEnd"/>
		<xsl:param name="charDelim"/>
		<xsl:param name="meta"/>
		<xsl:choose>
			<xsl:when test="$meta = 'true'">
				<xsl:value-of select="."/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="position() != last()"><xsl:value-of select="$charDelim"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$charAtEnd"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="addPDFUAmeta">
		<pdf:catalog xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf">
			<pdf:dictionary type="normal" key="ViewerPreferences">
				<pdf:boolean key="DisplayDocTitle">true</pdf:boolean>
			</pdf:dictionary>
		</pdf:catalog>
		<x:xmpmeta xmlns:x="adobe:ns:meta/">
			<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
				<!-- Commented after upgrade to Apache FOP 2.10
				<rdf:Description xmlns:pdfaExtension="http://www.aiim.org/pdfa/ns/extension/" xmlns:pdfaProperty="http://www.aiim.org/pdfa/ns/property#" xmlns:pdfaSchema="http://www.aiim.org/pdfa/ns/schema#" rdf:about="">
					<pdfaExtension:schemas>
						<rdf:Bag>
							<rdf:li rdf:parseType="Resource">
								<pdfaSchema:namespaceURI>http://www.aiim.org/pdfua/ns/id/</pdfaSchema:namespaceURI>
								<pdfaSchema:prefix>pdfuaid</pdfaSchema:prefix>
								<pdfaSchema:schema>PDF/UA identification schema</pdfaSchema:schema>
								<pdfaSchema:property>
									<rdf:Seq>
										<rdf:li rdf:parseType="Resource">
											<pdfaProperty:category>internal</pdfaProperty:category>
											<pdfaProperty:description>PDF/UA version identifier</pdfaProperty:description>
											<pdfaProperty:name>part</pdfaProperty:name>
											<pdfaProperty:valueType>Integer</pdfaProperty:valueType>
										</rdf:li>
										<rdf:li rdf:parseType="Resource">
											<pdfaProperty:category>internal</pdfaProperty:category>
											<pdfaProperty:description>PDF/UA amendment identifier</pdfaProperty:description>
											<pdfaProperty:name>amd</pdfaProperty:name>
											<pdfaProperty:valueType>Text</pdfaProperty:valueType>
										</rdf:li>
										<rdf:li rdf:parseType="Resource">
											<pdfaProperty:category>internal</pdfaProperty:category>
											<pdfaProperty:description>PDF/UA corrigenda identifier</pdfaProperty:description>
											<pdfaProperty:name>corr</pdfaProperty:name>
											<pdfaProperty:valueType>Text</pdfaProperty:valueType>
										</rdf:li>
									</rdf:Seq>
								</pdfaSchema:property>
							</rdf:li>
						</rdf:Bag>
					</pdfaExtension:schemas>
				</rdf:Description> -->
				<rdf:Description xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:pdf="http://ns.adobe.com/pdf/1.3/" rdf:about="">
				<!-- Dublin Core properties go here -->
					<dc:title>
						<xsl:variable name="title">
							<xsl:for-each select="(//mn:metanorma)[1]/mn:bibdata">
								<xsl:value-of select="mn:title[@language = $lang]"/>

							</xsl:for-each>
						</xsl:variable>
						<rdf:Alt>
							<rdf:li xml:lang="x-default">
								<xsl:choose>
									<xsl:when test="normalize-space($title) != ''">
										<xsl:value-of select="$title"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text> </xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</rdf:li>
						</rdf:Alt>
					</dc:title>
					<xsl:variable name="dc_creator">
						<xsl:for-each select="(//mn:metanorma)[1]/mn:bibdata">
							<rdf:Seq>
								<xsl:for-each select="mn:contributor[mn:role[not(mn:description)]/@type='author']">
									<rdf:li>
										<xsl:value-of select="mn:organization/mn:name"/>
									</rdf:li>
									<!-- <xsl:if test="position() != last()">; </xsl:if> -->
								</xsl:for-each>
							</rdf:Seq>
						</xsl:for-each>
					</xsl:variable>
					<xsl:if test="normalize-space($dc_creator) != ''">
						<dc:creator>
							<xsl:copy-of select="$dc_creator"/>
						</dc:creator>
					</xsl:if>

					<xsl:variable name="dc_description">
						<xsl:variable name="abstract">
							<xsl:copy-of select="//mn:metanorma/mn:preface/mn:abstract//text()[not(ancestor::mn:fmt-title) and not(ancestor::mn:title) and not(ancestor::mn:fmt-xref-label)]"/>
						</xsl:variable>
						<rdf:Alt>
							<rdf:li xml:lang="x-default">
								<xsl:value-of select="normalize-space($abstract)"/>
							</rdf:li>
						</rdf:Alt>
					</xsl:variable>
					<xsl:if test="normalize-space($dc_description)">
						<dc:description>
							<xsl:copy-of select="$dc_description"/>
						</dc:description>
					</xsl:if>

					<pdf:Keywords>
						<xsl:call-template name="insertKeywords">
							<xsl:with-param name="meta">true</xsl:with-param>
						</xsl:call-template>
					</pdf:Keywords>
				</rdf:Description>
				<rdf:Description xmlns:xmp="http://ns.adobe.com/xap/1.0/" rdf:about="">
					<!-- XMP properties go here -->
					<xmp:CreatorTool/>
				</rdf:Description>
			</rdf:RDF>
		</x:xmpmeta>
		<!-- add attachments -->
		<xsl:for-each select="//mn:metanorma/mn:metanorma-extension/mn:attachment">
			<xsl:variable name="bibitem_attachment_" select="//mn:bibitem[@hidden = 'true'][mn:uri[@type = 'attachment'] = current()/@name]"/>
			<xsl:variable name="bibitem_attachment" select="xalan:nodeset($bibitem_attachment_)"/>
			<xsl:variable name="description" select="normalize-space($bibitem_attachment/mn:formattedref)"/>
			<xsl:variable name="filename" select="java:org.metanorma.fop.Util.getFilenameFromPath(@name)"/>
			<!-- Todo: need update -->
			<xsl:variable name="afrelationship" select="normalize-space($bibitem_attachment//mn:classification[@type = 'pdf-AFRelationship'])"/>
			<xsl:variable name="volatile" select="normalize-space($bibitem_attachment//mn:classification[@type = 'pdf-volatile'])"/>

			<pdf:embedded-file xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf" filename="{$filename}" link-as-file-annotation="true">
				<xsl:attribute name="src">
					<xsl:choose>
						<xsl:when test="normalize-space() != ''">
							<xsl:variable name="src_attachment" select="java:replaceAll(java:java.lang.String.new(.),'(&#13;&#10;|&#13;|&#10;)', '')"/> <!-- remove line breaks -->
							<xsl:value-of select="$src_attachment"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="url" select="concat('url(file:///',$inputxml_basepath , @name, ')')"/>
							<xsl:value-of select="$url"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:if test="$description != ''">
					<xsl:attribute name="description"><xsl:value-of select="$description"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="$afrelationship != ''">
					<xsl:attribute name="afrelationship"><xsl:value-of select="$afrelationship"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="$volatile != ''">
					<xsl:attribute name="volatile"><xsl:value-of select="$volatile"/></xsl:attribute>
				</xsl:if>
			</pdf:embedded-file>
		</xsl:for-each>
		<!-- references to external attachments (no binary-encoded within the Metanorma XML file) -->
		<xsl:if test="not(//mn:metanorma/mn:metanorma-extension/mn:attachment)">
			<xsl:for-each select="//mn:bibitem[@hidden = 'true'][mn:uri[@type = 'attachment']]">
				<xsl:variable name="attachment_path" select="mn:uri[@type = 'attachment']"/>
				<xsl:variable name="attachment_name" select="java:org.metanorma.fop.Util.getFilenameFromPath($attachment_path)"/>
				<!-- <xsl:variable name="url" select="concat('url(file:///',$basepath, $attachment_path, ')')"/> -->
				<!-- See https://github.com/metanorma/metanorma-iso/issues/1369 -->
				<xsl:variable name="url" select="concat('url(file:///',$outputpdf_basepath, $attachment_path, ')')"/>
				<xsl:variable name="description" select="normalize-space(mn:formattedref)"/>
				<!-- Todo: need update -->
				<xsl:variable name="afrelationship" select="normalize-space(.//mn:classification[@type = 'pdf-AFRelationship'])"/>
				<xsl:variable name="volatile" select="normalize-space(.//mn:classification[@type = 'pdf-volatile'])"/>
				<pdf:embedded-file xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf" src="{$url}" filename="{$attachment_name}" link-as-file-annotation="true">
					<xsl:if test="$description != ''">
						<xsl:attribute name="description"><xsl:value-of select="$description"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="$afrelationship != ''">
						<xsl:attribute name="afrelationship"><xsl:value-of select="$afrelationship"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="$volatile != ''">
						<xsl:attribute name="volatile"><xsl:value-of select="$volatile"/></xsl:attribute>
					</xsl:if>
				</pdf:embedded-file>
			</xsl:for-each>
		</xsl:if>
	</xsl:template> <!-- addPDFUAmeta -->

	<xsl:template name="getId">
		<xsl:choose>
			<xsl:when test="../@id">
				<xsl:value-of select="../@id"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat(generate-id(..), '_', text())"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Get or calculate depth of the element -->
	<xsl:template name="getLevel">
		<xsl:param name="depth"/>
		<!-- <xsl:message>
			<xsl:choose>
				<xsl:when test="local-name() = 'title'">title=<xsl:value-of select="."/></xsl:when>
				<xsl:when test="local-name() = 'clause'">clause/title=<xsl:value-of select="mn:title"/></xsl:when>
			</xsl:choose>
		</xsl:message> -->
		<xsl:choose>
			<xsl:when test="normalize-space(@depth) != ''">
				<xsl:value-of select="@depth"/>
			</xsl:when>
			<xsl:when test="normalize-space($depth) != ''">
				<xsl:value-of select="$depth"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="level_total" select="count(ancestor::*[local-name() != 'page_sequence'])"/>
				<xsl:variable name="level">
					<xsl:choose>
						<xsl:when test="parent::mn:preface">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="ancestor::mn:preface and not(ancestor::mn:foreword) and not(ancestor::mn:introduction)"> <!-- for preface/clause -->
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="ancestor::mn:preface">
							<xsl:value-of select="$level_total - 2"/>
						</xsl:when>
						<xsl:when test="ancestor::mn:sections and self::mn:fmt-title">
							<!-- determine 'depth' depends on upper clause with title/@depth -->
							<!-- <xsl:message>title=<xsl:value-of select="."/></xsl:message> -->
							<xsl:variable name="clause_with_depth_depth" select="ancestor::mn:clause[mn:fmt-title/@depth][1]/mn:fmt-title/@depth"/>
							<!-- <xsl:message>clause_with_depth_depth=<xsl:value-of select="$clause_with_depth_depth"/></xsl:message> -->
							<xsl:variable name="clause_with_depth_level" select="count(ancestor::mn:clause[mn:fmt-title/@depth][1]/ancestor::*)"/>
							<!-- <xsl:message>clause_with_depth_level=<xsl:value-of select="$clause_with_depth_level"/></xsl:message> -->
							<xsl:variable name="curr_level" select="count(ancestor::*) - 1"/>
							<!-- <xsl:message>curr_level=<xsl:value-of select="$curr_level"/></xsl:message> -->
							<!-- <xsl:variable name="upper_clause_depth" select="normalize-space(ancestor::mn:clause[2]/mn:title/@depth)"/> -->
							<xsl:variable name="curr_clause_depth" select="number($clause_with_depth_depth) + (number($curr_level) - number($clause_with_depth_level)) "/>
							<!-- <xsl:message>curr_clause_depth=<xsl:value-of select="$curr_clause_depth"/></xsl:message> -->
							<xsl:choose>
								<xsl:when test="string(number($curr_clause_depth)) != 'NaN'">
									<xsl:value-of select="number($curr_clause_depth)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$level_total - 2"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="ancestor::mn:sections and self::mn:fmt-name and parent::mn:term">
							<xsl:variable name="upper_terms_depth" select="normalize-space(ancestor::mn:terms[1]/mn:fmt-title/@depth)"/>
							<xsl:choose>
								<xsl:when test="string(number($upper_terms_depth)) != 'NaN'">
									<xsl:value-of select="number($upper_terms_depth + 1)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$level_total - 2"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="ancestor::mn:sections">
							<xsl:variable name="upper_clause_depth" select="normalize-space(ancestor::*[self::mn:clause or self::mn:terms][1]/mn:fmt-title/@depth)"/>
							<xsl:choose>
								<xsl:when test="string(number($upper_clause_depth)) != 'NaN'">
									<xsl:value-of select="number($upper_clause_depth + 1)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$level_total - 1"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="ancestor::mn:bibliography">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="parent::mn:annex">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="ancestor::mn:annex and self::mn:fmt-title">
							<xsl:variable name="upper_clause_depth" select="normalize-space(ancestor::mn:clause[2]/mn:fmt-title/@depth)"/>
							<xsl:choose>
								<xsl:when test="string(number($upper_clause_depth)) != 'NaN'">
									<xsl:value-of select="number($upper_clause_depth + 1)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$level_total - 1"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="ancestor::mn:annex">
							<xsl:value-of select="$level_total"/>
						</xsl:when>
						<xsl:when test="self::mn:annex">1</xsl:when>
						<xsl:when test="local-name(ancestor::*[1]) = 'annex'">1</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$level_total - 1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:value-of select="$level"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- getLevel -->

	<!-- Get or calculate depth of term's name -->
	<xsl:template name="getLevelTermName">
		<xsl:choose>
			<xsl:when test="normalize-space(../@depth) != ''">
				<xsl:value-of select="../@depth"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="title_level_">
					<xsl:for-each select="../preceding-sibling::mn:fmt-title[1]">
						<xsl:call-template name="getLevel"/>
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="title_level" select="normalize-space($title_level_)"/>
				<xsl:choose>
					<xsl:when test="$title_level != ''"><xsl:value-of select="$title_level + 1"/></xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="getLevel"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- getLevelTermName -->

	<!-- split string by separator -->
	<xsl:template name="split">
		<xsl:param name="pText" select="."/>
		<xsl:param name="sep" select="','"/>
		<xsl:param name="normalize-space" select="'true'"/>
		<xsl:param name="keep_sep" select="'false'"/>
		<xsl:if test="string-length($pText) &gt;0">
			<xsl:element name="item" namespace="{$namespace_mn_xsl}">
				<xsl:choose>
					<xsl:when test="$normalize-space = 'true'">
						<xsl:value-of select="normalize-space(substring-before(concat($pText, $sep), $sep))"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring-before(concat($pText, $sep), $sep)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
			<xsl:if test="$keep_sep = 'true' and contains($pText, $sep)"><xsl:element name="item" namespace="{$namespace_mn_xsl}"><xsl:value-of select="$sep"/></xsl:element></xsl:if>
			<xsl:call-template name="split">
				<xsl:with-param name="pText" select="substring-after($pText, $sep)"/>
				<xsl:with-param name="sep" select="$sep"/>
				<xsl:with-param name="normalize-space" select="$normalize-space"/>
				<xsl:with-param name="keep_sep" select="$keep_sep"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template> <!-- split -->

	<xsl:template name="getDocumentId">
		<xsl:call-template name="getLang"/><xsl:value-of select="//mn:p[1]/@id"/>
	</xsl:template>

	<xsl:template name="getDocumentId_fromCurrentNode">
		<xsl:call-template name="getLang_fromCurrentNode"/><xsl:value-of select=".//mn:p[1]/@id"/>
	</xsl:template>

	<xsl:template name="setId">
		<xsl:param name="prefix"/>
		<xsl:attribute name="id">
			<xsl:choose>
				<xsl:when test="@id">
					<xsl:value-of select="concat($prefix, @id)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat($prefix, generate-id())"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>

	<xsl:template name="setIDforNamedDestination">
		<xsl:if test="@named_dest">
			<xsl:attribute name="id"><xsl:value-of select="@named_dest"/></xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:template name="setIDforNamedDestinationInline">
		<xsl:if test="@named_dest">
			<fo:inline><xsl:call-template name="setIDforNamedDestination"/></fo:inline>
		</xsl:if>
	</xsl:template>

	<xsl:template name="setNamedDestination">
		<xsl:if test="$isGenerateTableIF = 'false'">
			<!-- skip GUID, e.g. _33eac3cb-9663-4291-ae26-1d4b6f4635fc -->
			<xsl:if test="@id and       normalize-space(java:matches(java:java.lang.String.new(@id), '_[0-9a-z]{8}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{12}')) = 'false'">
				<fox:destination internal-destination="{@id}"/>
			</xsl:if>
			<xsl:for-each select=". | mn:fmt-title | mn:fmt-name">
				<xsl:if test="@named_dest">
					<fox:destination internal-destination="{@named_dest}"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

	<xsl:template name="add-letter-spacing">
		<xsl:param name="text"/>
		<xsl:param name="letter-spacing" select="'0.15'"/>
		<xsl:if test="string-length($text) &gt; 0">
			<xsl:variable name="char" select="substring($text, 1, 1)"/>
			<fo:inline padding-right="{$letter-spacing}mm">
				<xsl:if test="$char = '®'">
					<xsl:attribute name="font-size">58%</xsl:attribute>
					<xsl:attribute name="baseline-shift">30%</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="$char"/>
			</fo:inline>
			<xsl:call-template name="add-letter-spacing">
				<xsl:with-param name="text" select="substring($text, 2)"/>
				<xsl:with-param name="letter-spacing" select="$letter-spacing"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="repeat">
		<xsl:param name="char" select="'*'"/>
		<xsl:param name="count"/>
		<xsl:if test="$count &gt; 0">
			<xsl:value-of select="$char"/>
			<xsl:call-template name="repeat">
				<xsl:with-param name="char" select="$char"/>
				<xsl:with-param name="count" select="$count - 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="getLocalizedString">
		<xsl:param name="key"/>
		<xsl:param name="formatted">false</xsl:param>
		<xsl:param name="lang"/>
		<xsl:param name="returnEmptyIfNotFound">false</xsl:param>
		<xsl:param name="bibdata_updated"/>

		<xsl:variable name="curr_lang">
			<xsl:choose>
				<xsl:when test="$lang != ''"><xsl:value-of select="$lang"/></xsl:when>
				<xsl:when test="$returnEmptyIfNotFound = 'true'"/>
				<xsl:otherwise>
					<xsl:call-template name="getLang"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="data_value">
			<xsl:choose>
				<xsl:when test="$formatted = 'true' and string-length($bibdata_updated) != 0">
					<xsl:apply-templates select="xalan:nodeset($bibdata_updated)//mn:localized-string[@key = $key and @language = $curr_lang]"/>
				</xsl:when>
				<xsl:when test="string-length($bibdata_updated) != 0">
					<xsl:value-of select="xalan:nodeset($bibdata_updated)//mn:localized-string[@key = $key and @language = $curr_lang]"/>
				</xsl:when>
				<xsl:when test="$formatted = 'true'">
					<xsl:apply-templates select="xalan:nodeset($bibdata)//mn:localized-string[@key = $key and @language = $curr_lang]"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(xalan:nodeset($bibdata)//mn:localized-string[@key = $key and @language = $curr_lang])"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="normalize-space($data_value) != ''">
				<xsl:choose>
					<xsl:when test="$formatted = 'true'"><xsl:copy-of select="$data_value"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="$data_value"/></xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/*/mn:localized-strings/mn:localized-string[@key = $key and @language = $curr_lang]">
				<xsl:choose>
					<xsl:when test="$formatted = 'true'">
						<xsl:apply-templates select="/*/mn:localized-strings/mn:localized-string[@key = $key and @language = $curr_lang]"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="/*/mn:localized-strings/mn:localized-string[@key = $key and @language = $curr_lang]"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$returnEmptyIfNotFound = 'true'"/>
			<xsl:otherwise>
				<xsl:variable name="key_">
					<xsl:call-template name="capitalize">
						<xsl:with-param name="str" select="translate($key, '_', ' ')"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="$key_"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- getLocalizedString -->

	<xsl:template name="setTrackChangesStyles">
		<xsl:param name="isAdded"/>
		<xsl:param name="isDeleted"/>

		<xsl:variable name="border-block-added">2.5pt solid rgb(0, 176, 80)</xsl:variable>
		<xsl:variable name="border-block-deleted">2.5pt solid rgb(255, 0, 0)</xsl:variable>

		<xsl:choose>
			<xsl:when test="local-name() = 'math'">
				<xsl:if test="$isAdded = 'true'">
					<xsl:attribute name="background-color"><xsl:value-of select="$color-added-text"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="$isDeleted = 'true'">
					<xsl:attribute name="background-color"><xsl:value-of select="$color-deleted-text"/></xsl:attribute>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$isAdded = 'true'">
					<xsl:attribute name="border"><xsl:value-of select="$border-block-added"/></xsl:attribute>
					<xsl:attribute name="padding">2mm</xsl:attribute>
				</xsl:if>
				<xsl:if test="$isDeleted = 'true'">
					<xsl:attribute name="border"><xsl:value-of select="$border-block-deleted"/></xsl:attribute>
					<xsl:if test="local-name() = 'table'">
						<xsl:attribute name="background-color">rgb(255, 185, 185)</xsl:attribute>
					</xsl:if>
					<xsl:attribute name="padding">2mm</xsl:attribute>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- setTrackChangesStyles -->

	<!--  see https://xmlgraphics.apache.org/fop/2.5/complexscripts.html#bidi_controls-->
	<xsl:variable name="LRM" select="'‎'"/> <!-- U+200E - LEFT-TO-RIGHT MARK (LRM) -->
	<xsl:variable name="RLM" select="'‏'"/> <!-- U+200F - RIGHT-TO-LEFT MARK (RLM) -->
	<xsl:template name="setWritingMode">
		<xsl:if test="$lang = 'ar'">
			<xsl:attribute name="writing-mode">rl-tb</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:template name="setAlignment">
		<xsl:param name="align" select="normalize-space(@align)"/>
		<xsl:choose>
			<xsl:when test="$lang = 'ar' and $align = 'left'">start</xsl:when>
			<xsl:when test="$lang = 'ar' and $align = 'right'">end</xsl:when>
			<xsl:when test="$align != ''">
				<xsl:value-of select="$align"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="setTextAlignment">
		<xsl:param name="default">left</xsl:param>
		<xsl:variable name="align" select="normalize-space(@align)"/>
		<xsl:attribute name="text-align">
			<xsl:choose>
				<xsl:when test="$lang = 'ar' and $align = 'left'">start</xsl:when>
				<xsl:when test="$lang = 'ar' and $align = 'right'">end</xsl:when>
				<xsl:when test="$align = 'justified'">justify</xsl:when>
				<xsl:when test="$align != '' and not($align = 'indent')"><xsl:value-of select="$align"/></xsl:when>
				<xsl:when test="ancestor::mn:td/@align"><xsl:value-of select="ancestor::mn:td/@align"/></xsl:when>
				<xsl:when test="ancestor::mn:th/@align"><xsl:value-of select="ancestor::mn:th/@align"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$default"/></xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:if test="$align = 'indent'">
			<xsl:attribute name="margin-left">7mm</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:template name="setBlockAttributes">
		<xsl:param name="text_align_default">left</xsl:param>
		<xsl:call-template name="setTextAlignment">
			<xsl:with-param name="default" select="$text_align_default"/>
		</xsl:call-template>
		<xsl:call-template name="setKeepAttributes"/>
		<xsl:if test="node()[1][self::mn:span][contains(@style, 'line-height')]">
			<xsl:variable name="styles">
				<xsl:apply-templates select="*[1]"/>
			</xsl:variable>
			<!-- move attribute line-height from inline to block -->
			<xsl:attribute name="line-height"><xsl:value-of select="xalan:nodeset($styles)//*/@line-height"/></xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:template name="setKeepAttributes">
		<!-- https://www.metanorma.org/author/topics/document-format/text/#avoiding-page-breaks -->
		<!-- Example: keep-lines-together="true" -->
		<xsl:if test="@keep-lines-together = 'true'">
			<xsl:attribute name="keep-together.within-column">always</xsl:attribute>
		</xsl:if>
		<!-- Example: keep-with-next="true" -->
		<xsl:if test="@keep-with-next =  'true'">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<!-- insert cover page image -->
	<!-- background cover image -->
	<xsl:template name="insertBackgroundPageImage">
		<xsl:param name="number">1</xsl:param>
		<xsl:param name="name">coverpage-image</xsl:param>
		<xsl:param name="suffix"/>
		<xsl:variable name="num" select="number($number)"/>
		<!-- background image -->
		<fo:block-container absolute-position="fixed" left="0mm" top="0mm" font-size="0" id="__internal_layout__coverpage{$suffix}_{$name}_{$number}_{generate-id()}">
			<fo:block>
				<xsl:for-each select="/mn:metanorma/mn:metanorma-extension/mn:presentation-metadata[mn:name = $name][1]/mn:value/mn:image[$num]">

					<xsl:call-template name="insertPageImage"/>

				</xsl:for-each>
			</fo:block>
		</fo:block-container>
	</xsl:template>

	<xsl:template name="insertPageImage">
		<xsl:param name="svg_content_height" select="$pageHeight"/>
		<xsl:param name="bitmap_width" select="$pageWidth"/>
		<xsl:choose>
			<xsl:when test="*[local-name() = 'svg'] or java:endsWith(java:java.lang.String.new(@src), '.svg')">
				<fo:instream-foreign-object fox:alt-text="Image Front">
					<xsl:attribute name="content-height"><xsl:value-of select="$svg_content_height"/>mm</xsl:attribute>
					<xsl:call-template name="getSVG"/>
				</fo:instream-foreign-object>
			</xsl:when>
			<xsl:when test="starts-with(@src, 'data:application/pdf;base64')">
				<fo:external-graphic src="{@src}" fox:alt-text="Image Front"/>
			</xsl:when>
			<xsl:otherwise> <!-- bitmap image -->
				<xsl:variable name="coverimage_src" select="normalize-space(@src)"/>
				<xsl:if test="$coverimage_src != ''">
					<xsl:variable name="coverpage">
						<xsl:call-template name="getImageURL">
							<xsl:with-param name="src" select="$coverimage_src"/>
						</xsl:call-template>
					</xsl:variable>
					<fo:external-graphic src="{$coverpage}" width="{$bitmap_width}mm" content-height="scale-to-fit" scaling="uniform" fox:alt-text="Image Front"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="getImageURL">
		<xsl:param name="src"/>
		<xsl:choose>
			<xsl:when test="starts-with($src, 'data:image')">
				<xsl:value-of select="$src"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="src_external"><xsl:call-template name="getImageSrcExternal"/></xsl:variable>
				<xsl:value-of select="concat('url(file:///', $src_external, ')')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="getSVG">
		<xsl:choose>
			<xsl:when test="*[local-name() = 'svg']">
				<xsl:apply-templates select="*[local-name() = 'svg']" mode="svg_update"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="svg_content" select="document(@src)"/>
				<xsl:for-each select="xalan:nodeset($svg_content)/node()">
					<xsl:apply-templates select="." mode="svg_update"/>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- END: insert cover page image -->

	<!-- https://github.com/metanorma/docs/blob/main/109.adoc -->
	<xsl:variable name="regex_ja_spec_half_width_">
		\u0028  <!-- U+0028 LEFT PARENTHESIS (() -->
		\u0029 <!-- U+0029 RIGHT PARENTHESIS ()) -->
		\u007B <!-- U+007B LEFT CURLY BRACKET ({) -->
		\u007D <!-- U+007D RIGHT CURLY BRACKET (}) -->
		\uFF62 <!-- U+FF62 HALFWIDTH LEFT CORNER BRACKET (｢) -->
		\uFF63 <!-- U+FF63 HALFWIDTH RIGHT CORNER BRACKET (｣) -->
		\u005B <!-- U+005B LEFT SQUARE BRACKET ([) -->
		\u005D <!-- U+005D RIGHT SQUARE BRACKET (]) -->
	</xsl:variable>
	<xsl:variable name="regex_ja_spec_half_width" select="translate(normalize-space($regex_ja_spec_half_width_), ' ', '')"/>
	<xsl:variable name="regex_ja_spec_">[
		<!-- Rotate 90° clockwise -->
		<xsl:value-of select="$regex_ja_spec_half_width"/>
		\uFF08 <!-- U+FF08 FULLWIDTH LEFT PARENTHESIS (（) -->
		\uFF09 <!-- U+FF09 FULLWIDTH RIGHT PARENTHESIS (）) -->
		\uFF5B <!-- U+FF5B FULLWIDTH LEFT CURLY BRACKET (｛) -->
		\uFF5D <!-- U+FF5D FULLWIDTH RIGHT CURLY BRACKET (｝) -->
		\u3014 <!-- U+3014 LEFT TORTOISE SHELL BRACKET (〔) -->
		\u3015 <!-- U+3015 RIGHT TORTOISE SHELL BRACKET (〕) -->
		\u3010 <!-- U+3010 LEFT BLACK LENTICULAR BRACKET (【) -->
		\u3011 <!-- U+3011 RIGHT BLACK LENTICULAR BRACKET (】) -->
		\u300A <!-- U+300A LEFT DOUBLE ANGLE BRACKET (《) -->
		\u300B <!-- U+300B RIGHT DOUBLE ANGLE BRACKET (》) -->
		\u300C <!-- U+300C LEFT CORNER BRACKET (「) -->
		\u300D <!-- U+300D RIGHT CORNER BRACKET (」) -->
		\u300E <!-- U+300E LEFT WHITE CORNER BRACKET (『) -->
		\u300F <!-- U+300F RIGHT WHITE CORNER BRACKET (』) -->
		\uFF3B <!-- U+FF3B FULLWIDTH LEFT SQUARE BRACKET (［) -->
		\uFF3D <!-- U+FF3D FULLWIDTH RIGHT SQUARE BRACKET (］) -->
		\u3008 <!-- U+3008 LEFT ANGLE BRACKET (〈) -->
		\u3009 <!-- U+3009 RIGHT ANGLE BRACKET (〉) -->
		\u3016 <!-- U+3016 LEFT WHITE LENTICULAR BRACKET (〖) -->
		\u3017 <!-- U+3017 RIGHT WHITE LENTICULAR BRACKET (〗) -->
		\u301A <!-- U+301A LEFT WHITE SQUARE BRACKET (〚) -->
		\u301B <!-- U+301B RIGHT WHITE SQUARE BRACKET (〛) -->
		\u301C <!-- U+301C WAVE DASH (〜) -->
		\u3030 <!-- U+3030 WAVY DASH (〰 )-->
		\u30FC <!-- U+30FC KATAKANA-HIRAGANA PROLONGED SOUND MARK (ー) -->
		\u2329 <!-- U+2329 LEFT-POINTING ANGLE BRACKET (〈) -->
		\u232A <!-- U+232A RIGHT-POINTING ANGLE BRACKET (〉) -->
		\u3018 <!-- U+3018 LEFT WHITE TORTOISE SHELL BRACKET (〘) -->
		\u3019 <!-- U+3019 RIGHT WHITE TORTOISE SHELL BRACKET (〙) -->
		\u30A0 <!-- U+30A0 KATAKANA-HIRAGANA DOUBLE HYPHEN (゠) -->
		\uFE59 <!-- U+FE59 SMALL LEFT PARENTHESIS (﹙) -->
		\uFE5A <!-- U+FE5A SMALL RIGHT PARENTHESIS (﹚) -->
		\uFE5B <!-- U+FE5B SMALL LEFT CURLY BRACKET (﹛) -->
		\uFE5C <!-- U+FE5C SMALL RIGHT CURLY BRACKET (﹜) -->
		\uFE5D <!-- U+FE5D SMALL LEFT TORTOISE SHELL BRACKET (﹝) -->
		\uFE5E <!-- U+FE5E SMALL RIGHT TORTOISE SHELL BRACKET (﹞) -->
		\uFF5C <!-- U+FF5C FULLWIDTH VERTICAL LINE (｜) -->
		\uFF5F <!-- U+FF5F FULLWIDTH LEFT WHITE PARENTHESIS (｟) -->
		\uFF60 <!-- U+FF60 FULLWIDTH RIGHT WHITE PARENTHESIS (｠) -->
		\uFFE3 <!-- U+FFE3 FULLWIDTH MACRON (￣) -->
		\uFF3F <!-- U+FF3F FULLWIDTH LOW LINE (＿) -->
		\uFF5E <!-- U+FF5E FULLWIDTH TILDE (～) -->
		<!-- Rotate 180° -->
		\u309C <!-- U+309C KATAKANA-HIRAGANA SEMI-VOICED SOUND MARK (゜) -->
		\u3002 <!-- U+3002 IDEOGRAPHIC FULL STOP (。) -->
		\uFE52 <!-- U+FE52 SMALL FULL STOP (﹒) -->
		\uFF0E <!-- U+FF0E FULLWIDTH FULL STOP (．) -->
		]</xsl:variable>
	<xsl:variable name="regex_ja_spec"><xsl:value-of select="translate(normalize-space($regex_ja_spec_), ' ', '')"/></xsl:variable>
	<xsl:template name="insertVerticalChar">
		<xsl:param name="str"/>
		<xsl:param name="char_prev"/>
		<xsl:param name="writing-mode">lr-tb</xsl:param>
		<xsl:param name="reference-orientation">90</xsl:param>
		<xsl:param name="add_zero_width_space">false</xsl:param>
		<xsl:choose>
			<xsl:when test="ancestor::mn:span[@class = 'norotate']">
				<xsl:value-of select="$str"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="string-length($str) &gt; 0">

					<!-- <xsl:variable name="horizontal_mode" select="normalize-space(ancestor::mn:span[@class = 'horizontal'] and 1 = 1)"/> -->
					<xsl:variable name="char" select="substring($str,1,1)"/>
					<xsl:variable name="char_next" select="substring($str,2,1)"/>

					<xsl:variable name="char_half_width" select="normalize-space(java:matches(java:java.lang.String.new($char), concat('([', $regex_ja_spec_half_width, ']{1,})')))"/>

					<xsl:choose>
						<xsl:when test="$char_half_width = 'true'">
							<fo:inline>
								<xsl:attribute name="baseline-shift">7%</xsl:attribute>
								<xsl:value-of select="$char"/>
							</fo:inline>
						</xsl:when>
						<xsl:otherwise>
							<!--  namespace-uri(ancestor::mn:title) != '' to skip title from $contents  -->
							<xsl:if test="namespace-uri(ancestor::mn:fmt-title) != '' and ($char_prev = '' and ../preceding-sibling::node())">
								<fo:inline padding-left="1mm"><xsl:value-of select="$zero_width_space"/></fo:inline>
							</xsl:if>
							<fo:inline-container text-align="center" alignment-baseline="central" width="1em" margin="0" padding="0" text-indent="0mm" last-line-end-indent="0mm" start-indent="0mm" end-indent="0mm" role="SKIP" text-align-last="center">
								<xsl:if test="normalize-space($writing-mode) != ''">
									<xsl:attribute name="writing-mode"><xsl:value-of select="$writing-mode"/></xsl:attribute>
									<xsl:attribute name="reference-orientation">90</xsl:attribute>
								</xsl:if>
								<xsl:if test="normalize-space(java:matches(java:java.lang.String.new($char), concat('(', $regex_ja_spec, '{1,})'))) = 'true'">
									<xsl:attribute name="reference-orientation">0</xsl:attribute>
								</xsl:if>
								<xsl:if test="$char = '゜' or $char = '。' or $char = '﹒' or $char = '．'">
									<!-- Rotate 180°: 
										U+309C KATAKANA-HIRAGANA SEMI-VOICED SOUND MARK (゜)
										U+3002 IDEOGRAPHIC FULL STOP (。)
										U+FE52 SMALL FULL STOP (﹒)
										U+FF0E FULLWIDTH FULL STOP (．)
									-->
									<xsl:attribute name="reference-orientation">-90</xsl:attribute>
								</xsl:if>
								<fo:block-container width="1em" role="SKIP"><!-- border="0.5pt solid blue" -->
									<fo:block line-height="1em" role="SKIP">
										<!-- <xsl:choose>
											<xsl:when test="$horizontal_mode = 'true'">
												<xsl:value-of select="$str"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$char"/>
											</xsl:otherwise>
										</xsl:choose> -->
										<xsl:value-of select="$char"/>
									</fo:block>
								</fo:block-container>
							</fo:inline-container>
							<xsl:if test="namespace-uri(ancestor::mn:fmt-title) != '' and ($char_next != '' or ../following-sibling::node())">
								<fo:inline padding-left="1mm"><xsl:value-of select="$zero_width_space"/></fo:inline>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>

					<xsl:if test="$add_zero_width_space = 'true' and ($char = ',' or $char = '.' or $char = ' ' or $char = '·' or $char = ')' or $char = ']' or $char = '}' or $char = '/')"><xsl:value-of select="$zero_width_space"/></xsl:if>
						<!-- <xsl:if test="$horizontal_mode = 'false'"> -->
							<xsl:call-template name="insertVerticalChar">
								<xsl:with-param name="str" select="substring($str, 2)"/>
								<xsl:with-param name="char_prev" select="$char"/>
								<xsl:with-param name="writing-mode" select="$writing-mode"/>
								<xsl:with-param name="reference-orientation" select="$reference-orientation"/>
								<xsl:with-param name="add_zero_width_space" select="$add_zero_width_space"/>
							</xsl:call-template>
						<!-- </xsl:if> -->
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="insertHorizontalChars">
		<xsl:param name="str"/>
		<xsl:param name="writing-mode">lr-tb</xsl:param>
		<xsl:param name="reference-orientation">90</xsl:param>
		<xsl:param name="add_zero_width_space">false</xsl:param>
		<fo:inline-container text-align="center" alignment-baseline="central" width="1em" margin="0" padding="0" text-indent="0mm" last-line-end-indent="0mm" start-indent="0mm" end-indent="0mm" role="SKIP">
			<xsl:if test="normalize-space($writing-mode) != ''">
				<xsl:attribute name="writing-mode"><xsl:value-of select="$writing-mode"/></xsl:attribute>
				<xsl:attribute name="reference-orientation">90</xsl:attribute>
			</xsl:if>
			<fo:block-container width="1em" role="SKIP"> <!-- border="0.5pt solid green" -->
				<fo:block line-height="1em" role="SKIP">
					<xsl:value-of select="$str"/>
				</fo:block>
			</fo:block-container>
		</fo:inline-container>
	</xsl:template>

	<xsl:template name="number-to-words">
		<xsl:param name="number"/>
		<xsl:param name="first"/>
		<xsl:if test="$number != ''">
			<xsl:variable name="words">
				<words>
					<xsl:choose>
						<xsl:when test="$lang = 'fr'"> <!-- https://en.wiktionary.org/wiki/Appendix:French_numbers -->
							<word cardinal="1">Une-</word>
							<word ordinal="1">Première </word>
							<word cardinal="2">Deux-</word>
							<word ordinal="2">Seconde </word>
							<word cardinal="3">Trois-</word>
							<word ordinal="3">Tierce </word>
							<word cardinal="4">Quatre-</word>
							<word ordinal="4">Quatrième </word>
							<word cardinal="5">Cinq-</word>
							<word ordinal="5">Cinquième </word>
							<word cardinal="6">Six-</word>
							<word ordinal="6">Sixième </word>
							<word cardinal="7">Sept-</word>
							<word ordinal="7">Septième </word>
							<word cardinal="8">Huit-</word>
							<word ordinal="8">Huitième </word>
							<word cardinal="9">Neuf-</word>
							<word ordinal="9">Neuvième </word>
							<word ordinal="10">Dixième </word>
							<word ordinal="11">Onzième </word>
							<word ordinal="12">Douzième </word>
							<word ordinal="13">Treizième </word>
							<word ordinal="14">Quatorzième </word>
							<word ordinal="15">Quinzième </word>
							<word ordinal="16">Seizième </word>
							<word ordinal="17">Dix-septième </word>
							<word ordinal="18">Dix-huitième </word>
							<word ordinal="19">Dix-neuvième </word>
							<word cardinal="20">Vingt-</word>
							<word ordinal="20">Vingtième </word>
							<word cardinal="30">Trente-</word>
							<word ordinal="30">Trentième </word>
							<word cardinal="40">Quarante-</word>
							<word ordinal="40">Quarantième </word>
							<word cardinal="50">Cinquante-</word>
							<word ordinal="50">Cinquantième </word>
							<word cardinal="60">Soixante-</word>
							<word ordinal="60">Soixantième </word>
							<word cardinal="70">Septante-</word>
							<word ordinal="70">Septantième </word>
							<word cardinal="80">Huitante-</word>
							<word ordinal="80">Huitantième </word>
							<word cardinal="90">Nonante-</word>
							<word ordinal="90">Nonantième </word>
							<word cardinal="100">Cent-</word>
							<word ordinal="100">Centième </word>
						</xsl:when>
						<xsl:when test="$lang = 'ru'">
							<word cardinal="1">Одна-</word>
							<word ordinal="1">Первое </word>
							<word cardinal="2">Две-</word>
							<word ordinal="2">Второе </word>
							<word cardinal="3">Три-</word>
							<word ordinal="3">Третье </word>
							<word cardinal="4">Четыре-</word>
							<word ordinal="4">Четвертое </word>
							<word cardinal="5">Пять-</word>
							<word ordinal="5">Пятое </word>
							<word cardinal="6">Шесть-</word>
							<word ordinal="6">Шестое </word>
							<word cardinal="7">Семь-</word>
							<word ordinal="7">Седьмое </word>
							<word cardinal="8">Восемь-</word>
							<word ordinal="8">Восьмое </word>
							<word cardinal="9">Девять-</word>
							<word ordinal="9">Девятое </word>
							<word ordinal="10">Десятое </word>
							<word ordinal="11">Одиннадцатое </word>
							<word ordinal="12">Двенадцатое </word>
							<word ordinal="13">Тринадцатое </word>
							<word ordinal="14">Четырнадцатое </word>
							<word ordinal="15">Пятнадцатое </word>
							<word ordinal="16">Шестнадцатое </word>
							<word ordinal="17">Семнадцатое </word>
							<word ordinal="18">Восемнадцатое </word>
							<word ordinal="19">Девятнадцатое </word>
							<word cardinal="20">Двадцать-</word>
							<word ordinal="20">Двадцатое </word>
							<word cardinal="30">Тридцать-</word>
							<word ordinal="30">Тридцатое </word>
							<word cardinal="40">Сорок-</word>
							<word ordinal="40">Сороковое </word>
							<word cardinal="50">Пятьдесят-</word>
							<word ordinal="50">Пятидесятое </word>
							<word cardinal="60">Шестьдесят-</word>
							<word ordinal="60">Шестидесятое </word>
							<word cardinal="70">Семьдесят-</word>
							<word ordinal="70">Семидесятое </word>
							<word cardinal="80">Восемьдесят-</word>
							<word ordinal="80">Восьмидесятое </word>
							<word cardinal="90">Девяносто-</word>
							<word ordinal="90">Девяностое </word>
							<word cardinal="100">Сто-</word>
							<word ordinal="100">Сотое </word>
						</xsl:when>
						<xsl:otherwise> <!-- default english -->
							<word cardinal="1">One-</word>
							<word ordinal="1">First </word>
							<word cardinal="2">Two-</word>
							<word ordinal="2">Second </word>
							<word cardinal="3">Three-</word>
							<word ordinal="3">Third </word>
							<word cardinal="4">Four-</word>
							<word ordinal="4">Fourth </word>
							<word cardinal="5">Five-</word>
							<word ordinal="5">Fifth </word>
							<word cardinal="6">Six-</word>
							<word ordinal="6">Sixth </word>
							<word cardinal="7">Seven-</word>
							<word ordinal="7">Seventh </word>
							<word cardinal="8">Eight-</word>
							<word ordinal="8">Eighth </word>
							<word cardinal="9">Nine-</word>
							<word ordinal="9">Ninth </word>
							<word ordinal="10">Tenth </word>
							<word ordinal="11">Eleventh </word>
							<word ordinal="12">Twelfth </word>
							<word ordinal="13">Thirteenth </word>
							<word ordinal="14">Fourteenth </word>
							<word ordinal="15">Fifteenth </word>
							<word ordinal="16">Sixteenth </word>
							<word ordinal="17">Seventeenth </word>
							<word ordinal="18">Eighteenth </word>
							<word ordinal="19">Nineteenth </word>
							<word cardinal="20">Twenty-</word>
							<word ordinal="20">Twentieth </word>
							<word cardinal="30">Thirty-</word>
							<word ordinal="30">Thirtieth </word>
							<word cardinal="40">Forty-</word>
							<word ordinal="40">Fortieth </word>
							<word cardinal="50">Fifty-</word>
							<word ordinal="50">Fiftieth </word>
							<word cardinal="60">Sixty-</word>
							<word ordinal="60">Sixtieth </word>
							<word cardinal="70">Seventy-</word>
							<word ordinal="70">Seventieth </word>
							<word cardinal="80">Eighty-</word>
							<word ordinal="80">Eightieth </word>
							<word cardinal="90">Ninety-</word>
							<word ordinal="90">Ninetieth </word>
							<word cardinal="100">Hundred-</word>
							<word ordinal="100">Hundredth </word>
						</xsl:otherwise>
					</xsl:choose>
				</words>
			</xsl:variable>

			<xsl:variable name="ordinal" select="xalan:nodeset($words)//word[@ordinal = $number]/text()"/>

			<xsl:variable name="value">
				<xsl:choose>
					<xsl:when test="$ordinal != ''">
						<xsl:value-of select="$ordinal"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$number &lt; 100">
								<xsl:variable name="decade" select="concat(substring($number,1,1), '0')"/>
								<xsl:variable name="digit" select="substring($number,2)"/>
								<xsl:value-of select="xalan:nodeset($words)//word[@cardinal = $decade]/text()"/>
								<xsl:value-of select="xalan:nodeset($words)//word[@ordinal = $digit]/text()"/>
							</xsl:when>
							<xsl:otherwise>
								<!-- more 100 -->
								<xsl:variable name="hundred" select="substring($number,1,1)"/>
								<xsl:variable name="digits" select="number(substring($number,2))"/>
								<xsl:value-of select="xalan:nodeset($words)//word[@cardinal = $hundred]/text()"/>
								<xsl:value-of select="xalan:nodeset($words)//word[@cardinal = '100']/text()"/>
								<xsl:call-template name="number-to-words">
									<xsl:with-param name="number" select="$digits"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$first = 'true'">
					<xsl:variable name="value_lc" select="java:toLowerCase(java:java.lang.String.new($value))"/>
					<xsl:call-template name="capitalize">
						<xsl:with-param name="str" select="$value_lc"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$value"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template> <!-- number-to-words -->

	<!-- st for 1, nd for 2, rd for 3, th for 4, 5, 6, ... -->
	<xsl:template name="number-to-ordinal">
		<xsl:param name="number"/>
		<xsl:param name="curr_lang"/>
		<xsl:choose>
			<xsl:when test="$curr_lang = 'fr'">
				<xsl:choose>
					<xsl:when test="$number = '1'">re</xsl:when>
					<xsl:otherwise>e</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$number = 1">st</xsl:when>
					<xsl:when test="$number = 2">nd</xsl:when>
					<xsl:when test="$number = 3">rd</xsl:when>
					<xsl:otherwise>th</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- number-to-ordinal -->

	<!-- add the attribute fox:alt-text, required for PDF/UA -->
	<xsl:template name="setAltText">
		<xsl:param name="value"/>
		<xsl:attribute name="fox:alt-text">
			<xsl:choose>
				<xsl:when test="normalize-space($value) != ''">
					<xsl:value-of select="$value"/>
				</xsl:when>
				<xsl:otherwise>_</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>

	<xsl:template name="getCharByCodePoint">
		<xsl:param name="codepoint"/>
		<xsl:param name="radix">16</xsl:param>
		<xsl:variable name="codepointInt" select="java:java.lang.Integer.parseInt($codepoint,$radix)"/>
		<xsl:variable name="chars" select="java:java.lang.Character.toChars($codepointInt)"/>
		<xsl:value-of select="java:java.lang.String.new($chars)"/>
	</xsl:template>

	<xsl:template name="substring-after-last">
		<xsl:param name="value"/>
		<xsl:param name="delimiter"/>
		<xsl:choose>
			<xsl:when test="contains($value, $delimiter)">
				<xsl:call-template name="substring-after-last">
					<xsl:with-param name="value" select="substring-after($value, $delimiter)"/>
					<xsl:with-param name="delimiter" select="$delimiter"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$value"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ============================================= -->
	<!--  mode="print_as_xml", for debug purposes -->
	<!-- ============================================= -->
	<xsl:template match="*" mode="print_as_xml">
		<xsl:param name="level">0</xsl:param>

		<fo:block margin-left="{2*$level}mm">
			<xsl:text>
&lt;</xsl:text>
			<xsl:value-of select="local-name()"/>
			<xsl:for-each select="@*">
				<xsl:text> </xsl:text>
				<xsl:value-of select="local-name()"/>
				<xsl:text>="</xsl:text>
				<xsl:value-of select="."/>
				<xsl:text>"</xsl:text>
			</xsl:for-each>
			<xsl:text>&gt;</xsl:text>

			<xsl:if test="not(*)">
				<fo:inline font-weight="bold"><xsl:value-of select="."/></fo:inline>
				<xsl:text>&lt;/</xsl:text>
					<xsl:value-of select="local-name()"/>
					<xsl:text>&gt;</xsl:text>
			</xsl:if>
		</fo:block>

		<xsl:if test="*">
			<fo:block>
				<xsl:apply-templates mode="print_as_xml">
					<xsl:with-param name="level" select="$level + 1"/>
				</xsl:apply-templates>
			</fo:block>
			<fo:block margin-left="{2*$level}mm">
				<xsl:text>&lt;/</xsl:text>
				<xsl:value-of select="local-name()"/>
				<xsl:text>&gt;</xsl:text>
			</fo:block>
		</xsl:if>
	</xsl:template>
	<!-- ============================================= -->
	<!-- END: mode="print_as_xml", for debug purposes -->
	<!-- ============================================= -->

	<!-- ============================================= -->
	<!-- mode="set_table_role_skip" -->
	<!-- ============================================= -->
	<xsl:template match="@*|node()" mode="set_table_role_skip">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="set_table_role_skip"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[starts-with(local-name(), 'table')]" mode="set_table_role_skip">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="set_table_role_skip"/>
			<xsl:attribute name="role">SKIP</xsl:attribute>
			<xsl:apply-templates select="node()" mode="set_table_role_skip"/>
		</xsl:copy>
	</xsl:template>
	<!-- ============================================= -->
	<!-- END: mode="set_table_role_skip" -->
	<!-- ============================================= -->

</xsl:stylesheet>