<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
    
    <xsl:variable name="v_invoice_font">Helvetica, sans-serif, SansSerif</xsl:variable>
    <xsl:variable name="v_logo" select="/INVOICE/INVOICE_HEADER/INVOICE_LOGO" />
    <xsl:variable name="v_letter_spacing">0</xsl:variable>
    <xsl:variable name="v_border">0.5mm solid black</xsl:variable>
    
    <xsl:template match="INVOICE">
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
            <fo:layout-master-set>
                <fo:simple-page-master 
                    master-name="any" 
                    page-height="29.7cm" 
                    page-width="21cm" 
                    margin="1cm">
                    <fo:region-body margin-top="40mm" margin-bottom="2cm" />
                    <fo:region-before extent="2cm" />
                    <fo:region-after extent="1.3cm" />
                </fo:simple-page-master>
                
                <fo:page-sequence-master master-name="main">
                    <fo:repeatable-page-master-alternatives>
                        <fo:conditional-page-master-reference master-reference="any" page-position="any" />
                    </fo:repeatable-page-master-alternatives>
                </fo:page-sequence-master>

                <xsl:for-each select="//GROUP[@label='Description']/GROUP_DATA_ROW">
                    <xsl:variable name="index" select="position()" />
                    <xsl:variable name="page-id" select="concat('page-', $index)" />
					<xsl:if test="//GROUP[normalize-space(@label) = normalize-space(GROUP_DATA_ROW/COL[1])]">
						<fo:simple-page-master 
                            master-name="{$page-id}"
                            page-height="29.7cm" 
                            page-width="21cm" 
                            margin="1cm">
							<fo:region-body margin-top="40mm" margin-bottom="2cm" />
							<fo:region-before extent="2cm" />
							<fo:region-after extent="1.3cm" />
						</fo:simple-page-master>
					</xsl:if>
				</xsl:for-each>
            </fo:layout-master-set>

    
            <fo:page-sequence master-reference="main" id="cover-page" initial-page-number="1">
                <fo:static-content flow-name="xsl-region-before">
                    <xsl:call-template name="header" />
                </fo:static-content>    
                <fo:static-content flow-name="xsl-region-after">
                    <xsl:call-template name="footer" />
                </fo:static-content>    
                <fo:flow flow-name="xsl-region-body">
                    <xsl:call-template name="cover-page" />
                </fo:flow>
            </fo:page-sequence>

            <xsl:for-each select="//GROUP[@label='Description']/GROUP_DATA_ROW">
                <xsl:variable name="index" select="position()" />
                <xsl:variable name="page-id" select="concat('page-', $index)" />
                <xsl:variable name="last" select="position() = last()" />
                <xsl:if test="//GROUP[normalize-space(@label) = normalize-space(COL[1])]">
                    <fo:page-sequence id="{$page-id}" master-reference="{$page-id}">

                        <fo:static-content flow-name="xsl-region-before">
                            <xsl:call-template name="header" />
                        </fo:static-content>

                        <fo:static-content flow-name="xsl-region-after">
                            <xsl:call-template name="footer" />
                        </fo:static-content>

                        <fo:flow flow-name="xsl-region-body">
                            <fo:block>
                                <xsl:call-template name="invoice-detail-summaries">
                                    <xsl:with-param name="label" select="normalize-space(COL[1])" />
                                </xsl:call-template>
                                <xsl:if test="$last">
                                    <fo:block id="last-page"></fo:block>
                                </xsl:if>
                            </fo:block>
                        </fo:flow>

                    </fo:page-sequence>
                </xsl:if>
			</xsl:for-each>

        </fo:root>
    </xsl:template>

    <xsl:template name="bank_details_row">
        <xsl:param name="name"></xsl:param>
        <xsl:param name="value"></xsl:param>

        <fo:table-row>
            <fo:table-cell padding-bottom="1mm">
                <fo:block text-align="left" font-weight="bold">
                    <xsl:value-of select="$name" />
                </fo:block>
            </fo:table-cell>
            <fo:table-cell padding-bottom="1mm">
                <fo:block text-align="left">
                    <xsl:value-of select="$value" />
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
    </xsl:template>

    <xsl:template name="header">
        <fo:block font-size="11pt">
            <fo:table width="100%" table-layout="fixed">
                <fo:table-column column-width="60mm" />
                <fo:table-column column-width="proportional-column-width(1)" />
                <fo:table-body>
                    <fo:table-row>
                        <fo:table-cell padding-top="5mm">
                            <fo:block>
                                <fo:external-graphic src="{$v_logo}" content-width="scale-to-fit" width="60mm" />
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell text-align="right">
                            <fo:block>
                                <fo:block font-weight="bold">KARAMBA</fo:block>
                                <fo:block>Level 1-3 255 George Street, Sydney</fo:block>
                                <fo:block>NSW, 2000, Australia</fo:block>
                                <fo:block>
                                    <fo:inline font-weight="bold">E: </fo:inline> 
                                    <fo:inline>finance@auspayplus.com.au</fo:inline>
                                </fo:block>
                                <fo:block>
                                    <fo:inline font-weight="bold">W: </fo:inline> 
                                    <fo:inline>https://nppa.com.au/</fo:inline>
                                </fo:block>
                                <fo:block>
                                    <fo:inline font-weight="bold">ABN: </fo:inline> 
                                    <fo:inline>68 601 428 737</fo:inline>
                                </fo:block>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>
        </fo:block>
    </xsl:template>

    <xsl:template match="GROUP[@label='Description']">
        <fo:block font-size="10pt">
            <fo:block font-weight="bold" font-size="12pt" border-bottom="{$v_border}">Description</fo:block>
            <fo:table width="100%" table-layout="fixed">
                <fo:table-column column-width="50%" />
                <fo:table-column column-width="50%" />
                <fo:table-header>
                    <fo:table-row>
                        <fo:table-cell padding-top="2mm" padding-bottom="1mm" border-bottom="{$v_border}">
                            <fo:block font-weight="bold">Service Description</fo:block>
                        </fo:table-cell>
                        <fo:table-cell padding-top="2mm" padding-bottom="1mm" border-bottom="{$v_border}">
                            <fo:block font-weight="bold" text-align="right">Total</fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-header>
                <fo:table-body>
                    <xsl:for-each select="GROUP_DATA_ROW">
                        <fo:table-row>
                            <fo:table-cell padding="1mm 0">
                                <fo:block>
                                    <xsl:value-of select="COL[1]" />
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell padding="1mm 0">
                                <fo:block text-align="right">
                                    <xsl:value-of select="COL[2]" />
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </xsl:for-each>
                    <fo:table-row>
                        <fo:table-cell padding="1mm 0" border-top="{$v_border}">
                            <fo:block font-weight="bold" text-align="right">Total:</fo:block>
                        </fo:table-cell>
                        <fo:table-cell padding="1mm 0" border-top="{$v_border}">
                            <fo:block font-weight="bold" text-align="right">
                                <xsl:value-of select="GROUP_SUBTOTAL_ROW/COL[2]" />
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row>
                        <fo:table-cell padding="1mm 0">
                            <fo:block font-weight="bold" text-align="right">Tax Total:</fo:block>
                        </fo:table-cell>
                        <fo:table-cell padding="1mm 0">
                            <fo:block font-weight="bold" text-align="right">
                                <xsl:value-of select="/INVOICE/INVOICE_HEADER/TAX_TOTAL_AMOUNT" />
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row>
                        <fo:table-cell padding="1mm 0" >
                            <fo:block font-weight="bold" text-align="right">Total Due:</fo:block>
                        </fo:table-cell>
                        <fo:table-cell padding="1mm 0" border-bottom="{$v_border}">
                            <fo:block font-weight="bold" text-align="right">
                                <xsl:value-of select="/INVOICE/INVOICE_HEADER/BALANCE_DUE" />
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>
        </fo:block>
    </xsl:template>

    <xsl:template name="invoice-detail-summaries">
        <xsl:param name="label" />
        <xsl:for-each select="//GROUP[normalize-space(@label) = $label]/GROUP[1]">
            <fo:block font-size="10pt">
                <fo:block font-weight="bold" font-size="11pt" border-bottom="{$v_border}">
                    <xsl:value-of select="$label" />
                </fo:block>
                <fo:table width="100%" table-layout="fixed">
                    <xsl:for-each select="GROUP_HEADER_ROW/COL">
                        <fo:table-column column-width="{@width}" />
                    </xsl:for-each>
                    <fo:table-header>
                        <fo:table-row>
                            <xsl:for-each select="GROUP_HEADER_ROW/COL">
                                <fo:table-cell padding-top="2mm" padding-bottom="1mm" border-bottom="{$v_border}">
                                    <fo:block font-weight="bold" text-align="{@headerAlign}"><xsl:value-of select="." /></fo:block>
                                </fo:table-cell>
                            </xsl:for-each>
                        </fo:table-row>
                    </fo:table-header>
                    <fo:table-body>
                        <xsl:for-each select="GROUP_DATA_ROW">
                            <fo:table-row>
                                <xsl:for-each select="COL">
                                    <xsl:variable name="position" select="position()" />
                                    <xsl:variable name="align" select="../../GROUP_HEADER_ROW/COL[$position]/@headerAlign" />
                                    <fo:table-cell padding="1mm 0">
                                        <fo:block text-align="{$align}">
                                            <xsl:value-of select="." />
                                        </fo:block>
                                    </fo:table-cell>
                                </xsl:for-each>
                            </fo:table-row>
                        </xsl:for-each>
                        <fo:table-row>
                            <fo:table-cell number-columns-spanned="2" padding="1mm 0" border-top="{$v_border}">
                                <fo:block font-weight="bold" text-align="right">Total:</fo:block>
                            </fo:table-cell>
                            <fo:table-cell number-columns-spanned="4" padding="1mm 0" border-top="{$v_border}" border-bottom="{$v_border}">
                                <fo:block font-weight="bold" text-align="right">
                                    <xsl:value-of select="GROUP_SUBTOTAL_ROW/COL[6]" />
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            </fo:block>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="cover-header">
        <fo:block font-size="10pt">
            <fo:table width="100%" table-layout="fixed">
                <fo:table-column column-width="60mm" /> 
                <fo:table-column column-width="120mm" />
                <fo:table-body>
                    <fo:table-row>
                        <fo:table-cell>
                            <fo:block margin-left="5mm" margin-right="5mm">
                                <fo:block>
                                    <xsl:value-of select="/INVOICE/INVOICE_HEADER/BILL_TO/BILL_TO" />
                                </fo:block>
                                <fo:block>
                                    Attn: <xsl:value-of select="/INVOICE/INVOICE_HEADER/BILL_TO/ATTN" />
                                </fo:block>
                                <fo:block>
                                    <xsl:value-of select="/INVOICE/INVOICE_HEADER/BILL_TO/ADDR1" />
                                </fo:block>
                                <fo:block>
                                    <xsl:if test="/INVOICE/INVOICE_HEADER/BILL_TO/CITY">
                                        <xsl:value-of select="/INVOICE/INVOICE_HEADER/BILL_TO/CITY" />
                                        <fo:inline>,&#160;</fo:inline>
                                    </xsl:if>
                                    <xsl:value-of select="/INVOICE/INVOICE_HEADER/BILL_TO/STATE" />
                                    <fo:inline>&#160;</fo:inline>
                                    <xsl:value-of select="/INVOICE/INVOICE_HEADER/BILL_TO/ZIP" />
                                </fo:block>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell padding-left="50mm" text-align="right">
                            <fo:block text-align="left">
                                <fo:table width="100%" table-layout="fixed">
                                    <fo:table-column column-width="30mm" />
                                    <fo:table-column column-width="45mm" />
                                    <fo:table-body>
                                        <fo:table-row>
                                            <fo:table-cell padding-bottom="1mm">
                                                <fo:block font-weight="bold">Invoice Date:</fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell padding-bottom="1mm">
                                                <fo:block text-align="right">15/02/2024</fo:block>
                                            </fo:table-cell>
                                        </fo:table-row>
                                        <fo:table-row>
                                            <fo:table-cell padding-bottom="1mm">
                                                <fo:block font-weight="bold">Billing Period:</fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell padding-bottom="1mm">
                                                <fo:block text-align="right">January 2024</fo:block>
                                            </fo:table-cell>
                                        </fo:table-row>
                                        <fo:table-row>
                                            <fo:table-cell padding-bottom="1mm">
                                                <fo:block font-weight="bold">Customer ID:</fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell padding-bottom="1mm">
                                                <fo:block text-align="right">1914</fo:block>
                                            </fo:table-cell>
                                        </fo:table-row>
                                        <fo:table-row>
                                            <fo:table-cell padding-bottom="1mm">
                                                <fo:block font-weight="bold">Invoice number:</fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell padding-bottom="1mm">
                                                <fo:block text-align="right">5000036</fo:block>
                                            </fo:table-cell>
                                        </fo:table-row>
                                        <fo:table-row>
                                            <fo:table-cell padding-bottom="1mm">
                                                <fo:block font-weight="bold">Due date:</fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell padding-bottom="1mm">
                                                <fo:block text-align="right">16/03/2024</fo:block>
                                            </fo:table-cell>
                                        </fo:table-row>
                                    </fo:table-body>    
                                </fo:table>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>
        </fo:block>
    </xsl:template>

    <xsl:template name="cover-page">
        <xsl:call-template name="cover-header" />
        <fo:block margin-top="15mm" />
        <xsl:apply-templates select="//GROUP[@label='Description']" />
        <fo:block margin-top="15mm" />
        <fo:block font-size="10pt">
            <fo:block font-weight="bold">Instructions:</fo:block>
            <fo:block font-weight="bold">This Invoice is to be paid by the above Due date</fo:block>
            <fo:block border-bottom="{$v_border}" margin-top="2mm"></fo:block>
            <fo:block margin-top="20mm"></fo:block>
            <fo:block font-weight="bold">Payment methods:</fo:block>
            <fo:block margin-top="3mm">Prefered payment by EFT</fo:block>
            <fo:block border-bottom="{$v_border}" margin-top="2mm"></fo:block>
            <fo:block margin-top="7mm"></fo:block>
            <fo:block margin-left="2mm">
                <fo:table width="100%" table-layout="fixed">
                    <fo:table-column column-width="30%" />
                    <fo:table-column column-width="70%" />
                    <fo:table-body>
                        <xsl:call-template name="bank_details_row">
                            <xsl:with-param name="name">Bank:</xsl:with-param>
                            <xsl:with-param name="value">Commonwealth Bank of Australia</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="bank_details_row">
                            <xsl:with-param name="name">Bank Address:</xsl:with-param>
                            <xsl:with-param name="value">48 Martin Place, Sydney, NSW, 2000</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="bank_details_row">
                            <xsl:with-param name="name">BSB:</xsl:with-param>
                            <xsl:with-param name="value">062-000</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="bank_details_row">
                            <xsl:with-param name="name">Account Number:</xsl:with-param>
                            <xsl:with-param name="value">15936852</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="bank_details_row">
                            <xsl:with-param name="name">Account Name:</xsl:with-param>
                            <xsl:with-param name="value">NPP BLALBALBLBLB Limited</xsl:with-param>
                        </xsl:call-template>
                        <fo:table-row>
                            <fo:table-cell padding-top="5mm">
                                <fo:block />
                            </fo:table-cell>
                            <fo:table-cell padding-top="5mm">
                                <fo:block />
                            </fo:table-cell>
                        </fo:table-row>
                        <xsl:call-template name="bank_details_row">
                            <xsl:with-param name="name">PayID® (ABN):</xsl:with-param>
                            <xsl:with-param name="value">NPP Australia Limited</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="bank_details_row">
                            <xsl:with-param name="name">Reference:</xsl:with-param>
                            <xsl:with-param name="value">Invoice number</xsl:with-param>
                        </xsl:call-template>
                    </fo:table-body>
                </fo:table>
            </fo:block>
            <fo:block margin-left="4mm" margin-top="5mm" font-size="9pt">
                Please email your remittance advice or any addressee changes to: 
                <fo:inline font-weight="bold">finance@auspayplus.com.au</fo:inline>
            </fo:block>
        </fo:block>
    </xsl:template>

    <xsl:template name="footer">
        <fo:block>
            <fo:block margin-left="2mm" font-size="9pt">
                PayID is a registered trademark of NPP Australia Limited.
            </fo:block>
            <fo:block border-bottom="{$v_border}" margin-top="2mm"></fo:block>
            
            <fo:table margin-top="2mm" font-size="10pt">
                <fo:table-column column-width="50%" />
                <fo:table-column column-width="50%" />
                <fo:table-body>
                    <fo:table-row>
                        <fo:table-cell>
                            <fo:block>
                                NPP Australia Limited | <fo:inline font-weight="bold">Tax Invoice</fo:inline>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                            <fo:block text-align="right">
                                <fo:inline>Page&#160;</fo:inline>
                                <fo:page-number />/<fo:page-number-citation ref-id="last-page" />
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>
        </fo:block>
    </xsl:template>

</xsl:stylesheet>
