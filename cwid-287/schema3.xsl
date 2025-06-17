<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format">
    <xsl:variable name="v_invoice_font">Helvetica, sans-serif, SansSerif</xsl:variable>
    <xsl:template match="INVOICE">
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
            <fo:layout-master-set>
                <fo:simple-page-master master-name="firstPage"
                                       page-width="216mm"
                                       page-height="279mm"
                                       margin-top="0.5cm"
                                       margin-bottom="0.5cm"
                                       margin-left="0.5cm"
                                       margin-right="0.5cm">
                    <fo:region-body margin-top="2cm" margin-bottom="0cm"/>
                    <fo:region-before region-name="xsl-region-before-firstPage" extent="0cm"/>
                    <fo:region-after region-name="xsl-region-after-firstPage" extent="8cm"/>
                </fo:simple-page-master>

                <fo:simple-page-master master-name="restPages"
                                       page-width="279mm"
                                       page-height="216mm"
                                       margin-top="0.5cm"
                                       margin-bottom="0.5cm">
                    <fo:region-body margin-top="3.05cm" margin-bottom="0cm"
                                    margin-left="0.55cm"
                                    margin-right="0.5cm"/>
                    <fo:region-before region-name="xsl-region-before-restPages" extent="3cm" />
                    <fo:region-after region-name="xsl-region-after-restPages" extent="0.3cm"/>
                    <fo:region-start region-name="sideLeft" extent="0.5cm"/>
                    <fo:region-end region-name="sideRight" extent="0.5cm"/>
                </fo:simple-page-master>

                <fo:page-sequence-master master-name="INVOICE">
                    <fo:repeatable-page-master-alternatives>

                        <fo:conditional-page-master-reference
                                master-reference="firstPage"
                                page-position="first"/>

                        <fo:conditional-page-master-reference
                                master-reference="restPages"
                                page-position="rest"/>

                    </fo:repeatable-page-master-alternatives>
                </fo:page-sequence-master>
            </fo:layout-master-set>

            <fo:page-sequence master-reference="firstPage" initial-page-number="1">
                <fo:static-content flow-name="xsl-region-before-firstPage">
                    <fo:block text-align="start">
                        <xsl:choose>
                            <xsl:when test="string-length(INVOICE_HEADER/INVOICE_LOGO) > 1">
                                <fo:external-graphic
                                        src="{concat(INVOICE_HEADER/IMAGE_PATH,'/',INVOICE_HEADER/INVOICE_LOGO)}"
                                        width="100%"
                                        content-height="scale-to-fit"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <fo:block font-family="{$v_invoice_font}"
                                          font-size="14pt"
                                          font-weight="bold"
                                          line-height="3cm">
                                    <xsl:value-of select="INVOICE_HEADER/BILL_FROM/ACCOUNT_NAME"/>
                                </fo:block>
                            </xsl:otherwise>
                        </xsl:choose>
                    </fo:block>
                </fo:static-content>

                <fo:static-content flow-name="xsl-region-after-firstPage">
                    <xsl:call-template name="callingTariff"/>
                    <xsl:call-template name="portugueseReceipt"/>

                </fo:static-content>

                <fo:flow flow-name="xsl-region-body">
                    <xsl:apply-templates select="INVOICE_HEADER"/>

                    <xsl:apply-templates select="GROUP[@label='Summary of Charges']"/>

                    <xsl:call-template name="combinedExtras"/>

                    <xsl:apply-templates select="GROUP[@label='Analysis of VAT']"/>

                </fo:flow>
            </fo:page-sequence>

            <fo:page-sequence master-reference="restPages">
                <!-- [1] HEADER -->
                <fo:static-content flow-name="xsl-region-before-restPages">
                    <fo:block-container
                            height="100%"
                            width="100%"
                            border-bottom="1.5pt solid #000000">
                        <fo:block>
                            <fo:table width="100%" table-layout="fixed"
                                      font-family="{$v_invoice_font}" font-size="10pt">
                                <fo:table-column column-width="30%"/>
                                <fo:table-column column-width="40%"/>
                                <fo:table-column column-width="30%"/>
                                <fo:table-body>
                                    <fo:table-row>
                                        <!-- left: invoice details box -->
                                        <fo:table-cell>
                                            <fo:block border="1.5pt solid #C9C9C9" padding="5pt">
                                                <fo:table width="100%" table-layout="fixed" font-size="9pt">
                                                    <fo:table-column column-width="60%"/>
                                                    <fo:table-column column-width="40%"/>
                                                    <fo:table-body>
                                                        <fo:table-row>
                                                            <fo:table-cell font-weight="bold">
                                                                <fo:block>Número da Fatura:</fo:block>
                                                            </fo:table-cell>
                                                            <fo:table-cell text-align="end">
                                                                <fo:block>
                                                                    <xsl:value-of select="INVOICE_HEADER/INVOICE_ID"/>
                                                                </fo:block>
                                                            </fo:table-cell>
                                                        </fo:table-row>
                                                        <fo:table-row>
                                                            <fo:table-cell font-weight="bold">
                                                                <fo:block>Número da Conta:</fo:block>
                                                            </fo:table-cell>
                                                            <fo:table-cell text-align="end">
                                                                <fo:block>
                                                                    <xsl:value-of select="INVOICE_HEADER/BILL_TO/ACCOUNT/AccountNumber"/>
                                                                </fo:block>
                                                            </fo:table-cell>
                                                        </fo:table-row>
                                                        <fo:table-row>
                                                            <fo:table-cell font-weight="bold">
                                                                <fo:block>Data da Fatura:</fo:block>
                                                            </fo:table-cell>
                                                            <fo:table-cell text-align="end">
                                                                <fo:block>
                                                                    <xsl:value-of select="INVOICE_HEADER/INVOICE_DATE"/>
                                                                </fo:block>
                                                            </fo:table-cell>
                                                        </fo:table-row>
                                                    </fo:table-body>
                                                </fo:table>
                                            </fo:block>
                                        </fo:table-cell>

                                        <!-- centre: word “INVOICE” -->
                                        <fo:table-cell display-align="center">
                                            <fo:block text-align="center" font-size="18pt" font-weight="bold">
                                                Extrato de Conferência
                                            </fo:block>
                                        </fo:table-cell>

                                        <!-- right: logo -->
                                        <fo:table-cell text-align="end">
                                            <fo:block>
                                                <fo:external-graphic
                                                        src="{concat(INVOICE_HEADER/IMAGE_PATH,'/',INVOICE_HEADER/INVOICE_LOGO)}"
                                                        content-width="scale-to-fit"
                                                        width="100%"
                                                        content-height="4cm"/>
                                            </fo:block>
                                        </fo:table-cell>
                                    </fo:table-row>
                                </fo:table-body>
                            </fo:table>
                        </fo:block>
                    </fo:block-container>
                </fo:static-content>

                <!-- [2] FOOTER LINE UNDER BODY REGION -->
                <fo:static-content flow-name="xsl-region-after-restPages">
                    <fo:block border-top="1.5pt solid black" line-height="0"/>
                </fo:static-content>

                <!-- [3] LEFT “rail” -->
                <fo:static-content flow-name="sideLeft">
                    <fo:block-container
                            width="100%"
                            height="17.3cm"
                            margin-top="3cm"
                            border-right="1.5pt solid black">
                        <fo:block/>
                    </fo:block-container>
                </fo:static-content>

                <!-- [4] RIGHT “rail” -->
                <fo:static-content flow-name="sideRight">
                    <fo:block-container
                            width="100%"
                            height="17.3cm"
                            margin-top="3cm"
                            border-left="1.5pt solid black">
                        <fo:block/>
                    </fo:block-container>
                </fo:static-content>

                <!-- [5] BODY -->
                <fo:flow flow-name="xsl-region-body">
                    <!-- your shipment‐delivery table only -->
                    <xsl:apply-templates select="GROUP[@label='Shipment delivery']"/>
                    <fo:block>
                        <xsl:call-template name="qrCode"/>
                    </fo:block>

                </fo:flow>
            </fo:page-sequence>

        </fo:root>
    </xsl:template>

    <xsl:template match="INVOICE_HEADER">
        <!-- HEADER: "Bill To" on the left, invoice details on the right -->
        <fo:table
                width="100%"
                table-layout="fixed"
                border-collapse="collapse">
            <fo:table-column column-width="13cm"/>
            <fo:table-column column-width="7.6cm"/>

            <fo:table-body>
                <fo:table-row>

                    <!-- LEFT HALF: Bill To  -->
                    <fo:table-cell padding="0pt 0.5cm">
                        <fo:block font-family="{$v_invoice_font}" font-size="10pt" text-transform="uppercase">
                            <xsl:value-of select="BILL_TO/BILL_TO"/>
                        </fo:block>
                        <xsl:if test="string-length(BILL_TO/ATTN) &gt; 0">
                            <fo:block font-family="{$v_invoice_font}" font-size="10pt" text-transform="uppercase">
                                Attn: <xsl:value-of select="BILL_TO/ATTN"/>
                            </fo:block>
                        </xsl:if>
                        <fo:block font-family="{$v_invoice_font}" font-size="10pt" text-transform="uppercase">
                            <xsl:value-of select="BILL_TO/ACCOUNT/Name"/>
                        </fo:block>
                        <xsl:if test="string-length(BILL_TO/ADDR2) &gt; 0">
                            <fo:block font-family="{$v_invoice_font}" font-size="10pt" text-transform="uppercase">
                                <xsl:value-of select="BILL_TO/ADDR2"/>
                            </fo:block>
                        </xsl:if>
                        <xsl:if test="string-length(BILL_TO/COUNTRY) &gt; 0">
                            <fo:block font-family="{$v_invoice_font}" font-size="10pt" text-transform="uppercase">
                                <xsl:value-of select="BILL_TO/COUNTRY"/>
                            </fo:block>
                        </xsl:if>
                        <fo:block font-family="{$v_invoice_font}" font-size="10pt" text-transform="uppercase">
                            <xsl:value-of select="concat(BILL_TO/CITY, ', ', BILL_TO/STATE)"/>
                        </fo:block>
                        <xsl:if test="string-length(BILL_TO/ZIP) &gt; 0">
                            <fo:block font-family="{$v_invoice_font}" font-size="10pt" text-transform="uppercase">
                                <xsl:value-of select="BILL_TO/ZIP"/>
                            </fo:block>
                        </xsl:if>
                    </fo:table-cell>

                    <!-- RIGHT HALF: invoice details -->
                    <fo:table-cell  >
                        <fo:block text-align="start">
                            <fo:table
                                    width="100%"
                                    table-layout="fixed"
                                    border-collapse="collapse"
                                    font-family="{$v_invoice_font}"
                                    font-size="10pt">
                                <fo:table-column column-width="4cm"/>
                                <fo:table-column column-width="3cm"/>
                                <fo:table-body>
                                    <fo:table-row>
                                        <fo:table-cell><fo:block >Número da Fatura:</fo:block></fo:table-cell>
                                        <fo:table-cell text-align="end"><fo:block><xsl:value-of select="INVOICE_ID"/></fo:block></fo:table-cell>
                                    </fo:table-row>
                                    <fo:table-row>
                                        <fo:table-cell><fo:block >Referência DHL:</fo:block></fo:table-cell>
                                        <fo:table-cell text-align="end"><fo:block><xsl:value-of select="BILL_TO/GROUP_ID"/></fo:block></fo:table-cell>
                                    </fo:table-row>
                                    <fo:table-row>
                                        <fo:table-cell><fo:block >Data Da Fatura:</fo:block></fo:table-cell>
                                        <fo:table-cell text-align="end"><fo:block><xsl:value-of select="INVOICE_DATE"/></fo:block></fo:table-cell>
                                    </fo:table-row>
                                    <fo:table-row>
                                        <fo:table-cell><fo:block>Termos de Pagamento:</fo:block></fo:table-cell>
                                        <fo:table-cell text-align="end">
                                            <fo:block>Net <xsl:value-of select="BILL_TO/PAYMENT_TERMS"/></fo:block>
                                        </fo:table-cell>
                                    </fo:table-row>


                                </fo:table-body>
                            </fo:table>
                            <fo:block
                                    space-before="6pt"
                                    font-family="{$v_invoice_font}"
                                    font-size="9pt"
                                    font-weight="bold"
                                    margin-top="0.5cm">
                                Para Informações de Faturas
                            </fo:block>

                            <fo:table
                                    table-layout="fixed"
                                    width="100%"
                                    font-family="{$v_invoice_font}"
                                    font-size="10pt">
                                <fo:table-column column-width="4cm"/>
                                <fo:table-column column-width="3cm"/>
                                <fo:table-body>
                                    <fo:table-row>
                                        <fo:table-cell>
                                            <fo:block>Telephone:</fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell>
                                            <fo:block text-align="end">0818 221188</fo:block>
                                        </fo:table-cell>
                                    </fo:table-row>
                                    <fo:table-row>
                                        <fo:table-cell>
                                            <fo:block>Email:</fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell>
                                            <fo:block text-align="end">ie.invenq@dhl.com</fo:block>
                                        </fo:table-cell>
                                    </fo:table-row>
                                </fo:table-body>
                            </fo:table>
                        </fo:block>
                    </fo:table-cell>

                </fo:table-row>
            </fo:table-body>
        </fo:table>
    </xsl:template>

    <xsl:template match="GROUP[@label='Analysis of VAT']">
        <fo:table
                width="100%"
                table-layout="fixed"
                border-collapse="collapse"
                font-family="{$v_invoice_font}"
                font-size="8pt"
                space-before="5mm">

            <xsl:for-each select="GROUP_HEADER_ROW/COL">
                <fo:table-column/>
            </xsl:for-each>

            <fo:table-header>
                <!-- grey banner row -->
                <fo:table-row background-color="#E0E0E0">
                    <!-- span all but the last column -->
                    <fo:table-cell
                            number-columns-spanned="{count(GROUP_HEADER_ROW/COL) - 1}"
                            padding="3pt">
                        <fo:block font-weight="bold">
                            <xsl:value-of select="@label"/>
                        </fo:block>
                    </fo:table-cell>
                    <!-- the last column for “Total” -->
                    <fo:table-cell padding="3pt">
                        <fo:block text-align="end" font-weight="bold">
                            Total
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>

                <!-- column headings row -->
                <fo:table-row>
                    <xsl:for-each select="GROUP_HEADER_ROW/COL">
                        <fo:table-cell padding="2pt 5pt">
                            <fo:block text-align="{@headerAlign}">
                                <xsl:value-of select="."/>
                            </fo:block>
                        </fo:table-cell>
                    </xsl:for-each>
                </fo:table-row>
            </fo:table-header>

            <fo:table-body>
                <!-- data row -->
                <fo:table-row>
                    <xsl:for-each select="GROUP_DATA_ROW/COL">
                        <fo:table-cell padding="2pt 5pt">
                            <xsl:attribute name="text-align">
                                <xsl:choose>
                                    <xsl:when test="position() = 1">start</xsl:when>
                                    <xsl:otherwise>end</xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                            <fo:block>
                                <xsl:value-of select="."/>
                            </fo:block>
                        </fo:table-cell>
                    </xsl:for-each>
                </fo:table-row>

                <fo:table-row height="3mm">
                    <fo:table-cell>
                        <fo:block>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>

                <!-- total-VAT row -->
                <fo:table-row>
                    <fo:table-cell
                            number-columns-spanned="{count(GROUP_HEADER_ROW/COL) - 1}"
                            padding="2pt 5pt">
                        <fo:block font-weight="bold">Total VAT</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="2pt 5pt" text-align="end">
                        <fo:block font-weight="bold">
                            <xsl:value-of select="GROUP_SUBTOTAL_ROW/COL[last()]"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
    </xsl:template>

    <xsl:template name="combinedExtras">
        <fo:table
                width="100%"
                table-layout="fixed"
                border-collapse="collapse"
                font-family="{$v_invoice_font}"
                font-size="8pt"
                space-before="5mm">
            <!-- two fixed columns -->
            <fo:table-column column-width="9cm"/>
            <fo:table-column column-width="2cm"/>

            <fo:table-body>
                <!-- banner -->
                <fo:table-row background-color="#E0E0E0">
                    <fo:table-cell number-columns-spanned="1" padding="3pt">
                        <fo:block font-weight="bold">Análise das Sobretaxas</fo:block>
                    </fo:table-cell>
                    <fo:table-cell number-columns-spanned="1" padding="3pt" text-align="end">
                        <fo:block font-weight="bold">Total</fo:block>
                    </fo:table-cell>

                </fo:table-row>

                <!-- data from both labels -->
                <xsl:for-each select="/INVOICE/GROUP[
                       @label='Analysis of Extras 1'
                       or @label='Analysis of Extras 2'
                     ]/GROUP_DATA_ROW">
                    <fo:table-row>
                        <fo:table-cell padding="2pt 5pt">
                            <fo:block><xsl:value-of select="COL[1]"/></fo:block>
                        </fo:table-cell>
                        <fo:table-cell padding="2pt 5pt" text-align="end">
                            <fo:block>
                                <xsl:choose>
                                    <xsl:when test="number(COL[2]) = number(COL[2])"> <!-- Check if numeric -->
                                        <xsl:value-of select="format-number(number(COL[2]), '#,##0.00')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="COL[2]"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </xsl:for-each>
                <fo:table-row height="3mm">
                    <fo:table-cell>
                        <fo:block>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <!-- grand total -->
                <fo:table-row>
                    <fo:table-cell padding="2pt 5pt" font-weight="bold">
                        <fo:block>
                            Total sobretaxas
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="2pt 5pt" text-align="end" font-weight="bold">
                        <fo:block>
                            <xsl:value-of
                                    select="format-number(
                                sum(/INVOICE/GROUP[
                                  @label='Analysis of Extras 1'
                                  or @label='Analysis of Extras 2'
                                ]/GROUP_SUBTOTAL_ROW/COL[2]),
                                '#,##0.00'
                              )"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
    </xsl:template>

    <xsl:template match="GROUP[@label='Summary of Charges']">
        <fo:table
                width="100%"
                table-layout="fixed"
                border-collapse="collapse"
                font-family="{$v_invoice_font}"
                font-size="8pt"
                space-before="5mm">

            <fo:table-column column-width="30%" text-align="start"/>  <!-- Type of Service -->
            <fo:table-column column-width="10%" text-align="end"/>    <!-- Number of Shipments -->
            <fo:table-column column-width="10%" text-align="end"/>    <!-- Total Weight -->
            <fo:table-column column-width="10%" text-align="end"/>    <!-- Number of Items -->
            <fo:table-column column-width="10%"   text-align="end"/>    <!-- Standard Shipping Charge -->
            <fo:table-column column-width="10%"   text-align="end"/>    <!-- Total Extra Charges -->
            <fo:table-column column-width="10%" text-align="end"/>    <!-- VAT -->
            <fo:table-column column-width="10%" text-align="end"/>    <!-- Total Amount Inc VAT -->

            <!-- 2) Header row -->
            <fo:table-header>
                <fo:table-row background-color="#E0E0E0">
                    <xsl:for-each select="GROUP_HEADER_ROW/COL">
                        <fo:table-cell padding="2pt 5pt">
                            <fo:block font-weight="bold"
                                      text-align="{@headerAlign}">
                                <xsl:value-of select="."/>
                            </fo:block>
                        </fo:table-cell>
                    </xsl:for-each>
                </fo:table-row>
            </fo:table-header>

            <!-- 3) Data row -->
            <fo:table-body>
                <fo:table-row>
                    <xsl:for-each select="GROUP_DATA_ROW/COL">
                        <fo:table-cell padding="2pt 5pt">
                            <xsl:attribute name="text-align">
                                <xsl:choose>
                                    <xsl:when test="position() = 1">start</xsl:when>
                                    <xsl:otherwise>end</xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                            <fo:block>
                                <xsl:value-of select="."/>
                            </fo:block>
                        </fo:table-cell>
                    </xsl:for-each>
                </fo:table-row>
                <fo:table-row height="3mm">
                    <fo:table-cell>
                        <fo:block>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <!-- 4) Subtotal row -->
                <fo:table-row>
                    <xsl:for-each select="GROUP_SUBTOTAL_ROW/COL">
                        <fo:table-cell padding="2pt 5pt" font-weight="bold">
                            <!-- text-align attribute -->
                            <xsl:attribute name="text-align">
                                <xsl:choose>
                                    <xsl:when test="position() = 1">start</xsl:when>
                                    <xsl:otherwise>end</xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>

                            <fo:block>
                                <xsl:choose>
                                    <xsl:when test="position() = 1">
                                        Total
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="."/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </fo:block>
                        </fo:table-cell>
                    </xsl:for-each>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
    </xsl:template>

    <xsl:template match="GROUP[@label='Shipment delivery']">
        <fo:table
                width="100%"
                table-layout="fixed"
                border-collapse="collapse"
                font-family="{$v_invoice_font}"
                font-size="6pt">

            <!-- 1) Define your columns -->
            <!-- Air Waybill # -->
            <fo:table-column column-width="2.5cm" text-align="start"/>
            <!-- Shippers Reference -->
            <fo:table-column column-width="2.5cm" text-align="start"/>
            <!-- Shipment Date -->
            <fo:table-column column-width="2.5cm" text-align="start"/>
            <!-- Shipper Address (collapsed) -->
            <fo:table-column column-width="2.5cm" text-align="start"/>
            <!-- Receiver Address (collapsed) -->
            <fo:table-column column-width="2.5cm" text-align="start"/>
            <!-- Type of Service -->
            <fo:table-column column-width="3.3cm" text-align="start"/>
            <!-- Weight in Kg -->
            <fo:table-column column-width="1.5cm" text-align="end"/>
            <!-- Number of items -->
            <fo:table-column column-width="1.45cm" text-align="end"/>
            <!-- Standard Charge -->
            <fo:table-column column-width="1.7cm" text-align="end"/>
            <!-- Extra Charges Description -->
            <fo:table-column column-width="2.2cm" text-align="start"/>
            <!-- Extra Charges Amount -->
            <fo:table-column column-width="1.4cm" text-align="end"/>
            <!-- VAT / Code -->
            <fo:table-column column-width="1.3cm" text-align="center"/>
            <!-- Total amount (incl. VAT) -->
            <fo:table-column column-width="1.5cm" text-align="end"/>

            <!-- 2) Header row -->
            <fo:table-header>
                <fo:table-row background-color="#E0E0E0">
                    <fo:table-cell padding="3pt">
                        <fo:block font-weight="bold">Número de
                            Carta de
                            Porte</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="3pt">
                        <fo:block font-weight="bold">Número de
                            Carta de
                            Porte</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="3pt">
                        <fo:block font-weight="bold">Data
                            Envio</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="3pt">
                        <fo:block font-weight="bold">Origem/ Expedidor</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="3pt">
                        <fo:block font-weight="bold">Destino/ Destinatário</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="3pt">
                        <fo:block font-weight="bold">Serviço
                            DHL</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="3pt">
                        <fo:block font-weight="bold">Peso
                            (Kg)</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="3pt">
                        <fo:block font-weight="bold">Numero
                            de Peças</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="3pt">
                        <fo:block font-weight="bold">Portes</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="3pt">
                        <fo:block font-weight="bold">Sobretaxas</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="3pt">
                        <fo:block font-weight="bold">Quantia
                            Sobreta-
                            xas</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="3pt">
                        <fo:block font-weight="bold">IVA / código</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="3pt">
                        <fo:block font-weight="bold">Valor
                            total
                            (incl.IVA)</fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-header>

            <!-- 3) Data rows -->
            <fo:table-body>
                <xsl:for-each select="GROUP_DATA_ROW">
                    <fo:table-row
                            keep-together.within-page="always"
                            border-bottom="1pt solid grey"
                            space-after="5mm">

                        <!-- Air Waybill Number -->
                        <fo:table-cell padding="2pt">
                            <fo:block text-align="start">
                                <xsl:value-of select="COL[1]"/>
                            </fo:block>
                        </fo:table-cell>

                        <!-- Shippers Reference -->
                        <fo:table-cell padding="2pt">
                            <fo:block text-align="start">
                                <xsl:value-of select="COL[2]"/>
                            </fo:block>
                        </fo:table-cell>

                        <!-- Shipment Date -->
                        <fo:table-cell padding="2pt">
                            <fo:block text-align="start">
                                <xsl:value-of select="COL[3]"/>
                            </fo:block>
                        </fo:table-cell>

                        <!-- Shipper Address (cols 5–15 collapsed) -->
                        <fo:table-cell padding="2pt">
                            <fo:block text-align="start">
                                <xsl:for-each select="COL[position() &gt;= 6 and position() &lt;= 14]">
                                    <xsl:if test="normalize-space(.)">
                                        <xsl:value-of select="normalize-space(.)"/>
                                        <fo:block/>
                                    </xsl:if>
                                </xsl:for-each>
                            </fo:block>
                        </fo:table-cell>

                        <!-- Receiver Address (cols 16–27 collapsed) -->
                        <fo:table-cell padding="2pt">
                            <fo:block text-align="start">
                                <xsl:for-each select="COL[position() &gt;= 17 and position() &lt;= 25]">
                                    <xsl:if test="normalize-space(.)">
                                        <xsl:value-of select="normalize-space(.)"/>
                                        <fo:block/>
                                    </xsl:if>
                                </xsl:for-each>
                            </fo:block>
                        </fo:table-cell>

                        <!-- Type of Service -->
                        <fo:table-cell padding="2pt">
                            <fo:block text-align="start">
                                <xsl:value-of select="COL[26]"/>
                            </fo:block>
                        </fo:table-cell>

                        <!-- Weight in Kg -->
                        <fo:table-cell padding="2pt">
                            <fo:block text-align="start">
                                <xsl:value-of select="COL[27]"/>
                            </fo:block>
                        </fo:table-cell>

                        <!-- Number of items -->
                        <fo:table-cell padding="2pt">
                            <fo:block text-align="start">
                                <xsl:value-of select="COL[29]"/>
                            </fo:block>
                        </fo:table-cell>

                        <!-- Standard Charge -->
                        <fo:table-cell padding="2pt">
                            <fo:block text-align="start">
                                <xsl:value-of select="COL[30]"/>
                            </fo:block>
                        </fo:table-cell>

                        <!-- Extra Charges Description (assumes only one; adapt if multiple) -->
                        <fo:table-cell padding="2pt">
                            <fo:block text-align="start">
                                <xsl:value-of select="COL[31]"/>
                            </fo:block>
                            <fo:block text-align="start">
                                <xsl:value-of select="COL[35]"/>
                            </fo:block>
                        </fo:table-cell>

                        <!-- Extra Charges Amount -->
                        <fo:table-cell padding="2pt">
                            <fo:block text-align="start">
                                <xsl:value-of select="COL[34]"/>
                            </fo:block>
                        </fo:table-cell>

                        <!-- VAT / Code -->
                        <fo:table-cell padding="2pt">
                            <fo:block text-align="start">
                                <xsl:value-of select="COL[35]"/>
                            </fo:block>
                        </fo:table-cell>

                        <!-- Total amount (incl. VAT) -->
                        <fo:table-cell padding="2pt">
                            <fo:block text-align="start">
                                <!-- raw conversions -->
                                <xsl:variable name="stdRaw"   select="number(COL[30])"/>
                                <xsl:variable name="extraRaw" select="number(COL[34])"/>
                                <xsl:variable name="vatRaw"   select="number(COL[35])"/>

                                <!-- guard each one -->
                                <xsl:variable name="std">
                                    <xsl:choose>
                                        <xsl:when test="$stdRaw = $stdRaw"><xsl:value-of select="$stdRaw"/></xsl:when>
                                        <xsl:otherwise>0</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="extra">
                                    <xsl:choose>
                                        <xsl:when test="$extraRaw = $extraRaw"><xsl:value-of select="$extraRaw"/></xsl:when>
                                        <xsl:otherwise>0</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="vat">
                                    <xsl:choose>
                                        <xsl:when test="$vatRaw = $vatRaw"><xsl:value-of select="$vatRaw"/></xsl:when>
                                        <xsl:otherwise>0</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>

                                <!-- final sum, formatted -->
                                <xsl:value-of select="format-number($std + $extra + $vat, '#,##0.00')"/>
                            </fo:block>
                        </fo:table-cell>

                    </fo:table-row>
                </xsl:for-each>
            </fo:table-body>
        </fo:table>
    </xsl:template>

    <xsl:template name="createNameValRow">
        <xsl:param name="string" />
        <xsl:choose>
            <!-- if the string contains a tilda... -->
            <xsl:when test="contains($string, '~')">
                <!-- give the part before the line break... -->
                <xsl:variable name="rowData" select="substring-before($string, '~')" />
                <!-- then a create a name/value row -->
                <fo:table-row>
                    <fo:table-cell>
                        <fo:block text-align="start" font-family="{$v_invoice_font}" font-size="8pt" >
                            <xsl:value-of select="substring-before($rowData, ':')"/>:
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block text-align="start" font-family="{$v_invoice_font}" font-size="8pt" >
                            <xsl:value-of select="substring-after($rowData, ':')"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <!-- and then call the template recursively on the rest of the string -->
                <xsl:call-template name="createNameValRow">
                    <xsl:with-param name="string" select="substring-after($string, '~')" />
                </xsl:call-template>
            </xsl:when>
            <!-- if the string doesn't contain a tilda, just a name value row -->
            <xsl:otherwise>
                <fo:table-row>
                    <fo:table-cell>
                        <fo:block text-align="start" font-family="{$v_invoice_font}" font-size="8pt" >
                            <xsl:value-of select="substring-before($string, ':')"/>:
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block text-align="start" font-family="{$v_invoice_font}" font-size="8pt" >
                            <xsl:value-of select="substring-after($string, ':')"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="getPastDueInvoices"  match="/INVOICE/INVOICE_PAST_DUE">
        <fo:table width="19cm"  border-collapse="collapse" table-layout="fixed" font-family="{$v_invoice_font}" font-size="8pt" space-before="5mm">
            <fo:table-column column-width="3cm" text-align="start" font-weight="bold" ></fo:table-column>
            <fo:table-column column-width="4cm" text-align="start"></fo:table-column>
            <fo:table-column column-width="4cm" text-align="start"></fo:table-column>
            <fo:table-column column-width="4cm" text-align="end"></fo:table-column>
            <fo:table-column column-width="4cm" text-align="end" font-weight="bold" ></fo:table-column>
            <fo:table-body>
                <fo:table-row >
                    <fo:table-cell font-size="9pt"  font-weight="bold"
                                   number-columns-spanned="5" padding-after="2mm">
                        <fo:block border-bottom=".4mm solid black">Past Due Invoices</fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                    <fo:table-cell background-color="lightgrey">
                        <fo:block   border-bottom=".1mm solid black" text-align="start" font-family="{$v_invoice_font}" font-size="8pt" font-weight="bold" space-after="2mm">
                            Invoice ID
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell background-color="lightgrey" >
                        <fo:block border-bottom=".1mm solid black" text-align="start" font-family="{$v_invoice_font}" font-size="8pt" font-weight="bold" space-after="2mm">
                            Call Date
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell background-color="lightgrey">
                        <fo:block  border-bottom=".1mm solid black" text-align="start" font-family="{$v_invoice_font}" font-size="8pt" font-weight="bold" space-after="2mm">
                            Bill Date
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell background-color="lightgrey">
                        <fo:block  border-bottom=".1mm solid black" text-align="end" font-family="{$v_invoice_font}" font-size="8pt" font-weight="bold" space-after="2mm">
                            Invoice Total
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell background-color="lightgrey">
                        <fo:block  border-bottom=".1mm solid black" text-align="end" font-family="{$v_invoice_font}" font-size="8pt" font-weight="bold" space-after="2mm">
                            Balance Remaining
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <xsl:for-each select="/INVOICE/INVOICE_PAST_DUE/INVOICE_ITEM">
                    <xsl:for-each select="INVOICE_LIST/INVOICE">
                        <fo:table-row>
                            <fo:table-cell>
                                <fo:block text-align="start" font-family="{$v_invoice_font}" font-size="8pt">
                                    <xsl:value-of select="INVOICE_ID"/>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell>
                                <fo:block text-align="start" font-family="{$v_invoice_font}" font-size="8pt" padding=".4mm">
                                    <xsl:value-of select="ACTIVITY_START_DATE"/>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell>
                                <fo:block text-align="start" font-family="{$v_invoice_font}" font-size="8pt" padding=".4mm">
                                    <xsl:value-of select="CLOSED_DATE"/>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell>
                                <fo:block text-align="end" font-family="{$v_invoice_font}" font-size="8pt" padding=".4mm">
                                    <xsl:value-of select="GRAND_TOTAL_AMOUNT"/>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell>
                                <fo:block text-align="end" font-family="{$v_invoice_font}" font-size="8pt" padding=".4mm">
                                    <xsl:value-of select="OUTSTANDING_BALANCE"/>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </xsl:for-each>
                </xsl:for-each>
                <fo:table-row>
                    <fo:table-cell border-top=".4mm solid black"  font-weight="400" text-align="right" number-columns-spanned="4">
                        <fo:block text-align="end" font-family="{$v_invoice_font}"
                                  font-size="8pt" font-weight="bold"  padding-after="2pt">
                            Total Past Due:
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell font-weight="400" text-align="right"
                                   border-top=".4mm solid black"  border-bottom=".2mm solid black">
                        <fo:block text-align="end" font-family="{$v_invoice_font}" font-size="8pt" font-weight="bold">
                            <xsl:value-of select="/INVOICE/INVOICE_PAST_DUE/INVOICE_PAST_DUE_AMOUNT"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
    </xsl:template>

    <xsl:template name="createAging" match="/INVOICE/INVOICE_AGING">
        <fo:table width="10cm"  border-collapse="collapse" table-layout="fixed" font-family="{$v_invoice_font}" font-size="8pt">
            <fo:table-column column-width="3.5cm" text-align="start"  ></fo:table-column>
            <fo:table-column column-width="3.5cm" text-align="end"></fo:table-column>
            <fo:table-body>
                <fo:table-row >
                    <fo:table-cell font-size="9pt"  font-weight="bold"
                                   number-columns-spanned="2" padding-after="2pt">
                        <fo:block border-bottom=".4mm solid black">Aging</fo:block>
                    </fo:table-cell>
                </fo:table-row>

                <xsl:for-each select="/INVOICE/INVOICE_AGING/AGING">
                    <fo:table-row>
                        <fo:table-cell>
                            <fo:block text-align="start" font-family="{$v_invoice_font}" font-weight="bold"
                                      font-size="8pt" border-bottom=".2mm dotted black">
                                <xsl:value-of select="AGING_LABEL"/>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                            <fo:block text-align="end" font-family="{$v_invoice_font}" font-size="8pt" border-bottom=".2mm dotted black">
                                <xsl:value-of select="AGING_AMOUNT"/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </xsl:for-each>

            </fo:table-body>
        </fo:table>
    </xsl:template >

    <xsl:template name="createRollupLabels">
        <xsl:for-each select="/INVOICE/ROLLUP/GROUP_HEADER_ROW/COL">
            <xsl:variable name="vPos"  select="position()"/>
            <xsl:variable name="vData" select="../../GROUP_DATA_ROW/COL[$vPos]"/>
            <xsl:if test="$vData !=''">
                <xsl:choose>
                    <xsl:when test="contains($vData, ':')" >
                        <xsl:call-template name="createNameValRow">
                            <xsl:with-param name="string" select="$vData" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:table-row>
                            <fo:table-cell>
                                <fo:block text-align="start" font-family="{$v_invoice_font}" font-size="8pt" >
                                    <xsl:value-of select="."/>:
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell>
                                <fo:block text-align="start" font-family="{$v_invoice_font}" font-size="8pt" >
                                    <xsl:value-of select="$vData"/>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
        <xsl:if test="/INVOICE/ROLLUP/GROUP_HEADER_ROW/COL[1] = ''">
            <fo:table-row>
                <fo:table-cell>
                    <fo:block text-align="start" font-family="{$v_invoice_font}" font-size="8pt" >

                    </fo:block>
                </fo:table-cell>
                <fo:table-cell>
                    <fo:block text-align="start" font-family="{$v_invoice_font}" font-size="8pt" >

                    </fo:block>
                </fo:table-cell>
            </fo:table-row>
        </xsl:if>
    </xsl:template>

    <xsl:template name="getRollupValue">
        <xsl:param name="p_fieldName"/>
        <xsl:for-each select="/INVOICE/ROLLUP/GROUP_HEADER_ROW/COL">
            <xsl:variable name="vPos"  select="position()"/>
            <xsl:variable name="vData" select="../../GROUP_DATA_ROW/COL[$vPos]"/>

            <xsl:if test="$vData !='' and @fieldName = $p_fieldName">
                <xsl:value-of select="$vData"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="getTaxData">
        <xsl:for-each select="/INVOICE/TAX_FEE_DETAIL/DETAIL_ITEM">
            <fo:table-row>
                <fo:table-cell>
                    <fo:block >
                        <xsl:value-of select="LABEL"/>:
                    </fo:block>
                </fo:table-cell>
                <fo:table-cell text-align="end" padding-right="2pt">
                    <fo:block>
                        <xsl:value-of select="AMOUNT"></xsl:value-of>
                    </fo:block>
                </fo:table-cell>
            </fo:table-row>

        </xsl:for-each>
    </xsl:template>

    <xsl:template name="getSubscriptionData">
        <xsl:if test="/INVOICE/SUBSCRIPTION_FEE_DETAIL/DETAIL_ITEM[1] != ''">
            <fo:table width="19cm"  border-collapse="collapse" table-layout="fixed"
                      font-family="{$v_invoice_font}" font-size="10pt" space-before=".8cm">
                <fo:table-column column-width="19cm" ></fo:table-column>
                <fo:table-body>
                    <fo:table-row>
                        <fo:table-cell  font-weight="bold" border-bottom=".3mm solid black">
                            <fo:block>Subscriptions and Fees</fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>
            <fo:table width="10cm"  border-collapse="collapse" table-layout="fixed"
                      font-family="{$v_invoice_font}" font-size="8pt" space-before=".4cm">
                <fo:table-column column-width="7cm" text-align="start" font-weight="bold"></fo:table-column>
                <fo:table-column column-width="3cm" text-align="end"></fo:table-column>
                <fo:table-body>
                    <xsl:for-each select="/INVOICE/SUBSCRIPTION_FEE_DETAIL/DETAIL_ITEM">
                        <fo:table-row>
                            <fo:table-cell>
                                <fo:block >
                                    <xsl:value-of select="LABEL"/>:
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell text-align="end" padding-right="2pt">
                                <fo:block>
                                    <xsl:value-of select="AMOUNT"></xsl:value-of>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </xsl:for-each>
                </fo:table-body>
            </fo:table>
        </xsl:if>
    </xsl:template>

    <xsl:template name="paymentInstructions">
        <!-- 1) Remittances header -->
        <fo:block
                font-family="{$v_invoice_font}"
                font-size="8pt"
                font-weight="bold"
                text-align="center"
                space-after="2pt"
                space-before="1.5cm">
            PLEASE SEND YOUR REMITTANCES TO DHL EXPRESS (MALAYSIA) SDN BHD, LEVELS 11, IMAZIUM, NO. 8, JALAN SS21/37, DAMANSARA UPTOWN, 47400 PETALING JAYA
        </fo:block>
        <fo:block font-family="{$v_invoice_font}" font-size="8pt" text-align="center">
            DHL Express (Malaysia) Sdn Bhd
        </fo:block>
        <fo:block font-family="{$v_invoice_font}" font-size="8pt" text-align="center">
            Level 27 Menara TM Off Jalan Pantai Baharu, 50672 Kuala Lumpur, Malaysia
        </fo:block>
        <fo:block font-family="{$v_invoice_font}" font-size="8pt" text-align="center">
            • Tel: +603‐22418600/+6 03‐22418600 • Fax: None
        </fo:block>
        <fo:block font-family="{$v_invoice_font}" font-size="8pt" text-align="center" space-after="4pt">
            Company Registration Number: 23332-X • SST Registration No. W10-1808-31021055
        </fo:block>

        <!-- 2) Divider line -->
        <fo:block border-bottom="1pt solid black"/>

        <!-- 3) “Payment Instructions” title -->
        <fo:block
                font-family="{$v_invoice_font}"
                font-size="10pt"
                font-weight="bold"
                text-align="center"
                space-before="2mm"
                space-after="2mm">
            Payment Instructions
        </fo:block>

        <!-- 4) By Credit/Debit/etc -->
        <fo:block font-family="{$v_invoice_font}" font-size="8pt" space-after="2pt">
            <fo:block font-weight="bold">By Credit / Debit Card / DuitNow / FPX</fo:block>
            <fo:block space-before="2pt">
                Pay online through our DHL MyBill portal. Go to https://mybill.dhl.com/login/ to login and make payment.
            </fo:block>
        </fo:block>

        <!-- 5) By Check -->
        <fo:block font-family="{$v_invoice_font}" font-size="8pt" space-before="4pt">
            <fo:block font-weight="bold">By Check</fo:block>
            <fo:block space-before="2pt">
                Send check and remittance details to DHL EXPRESS (MALAYSIA) SDN BHD, Levels 11, Imazium, No. 8, Jalan SS21/37, Damansara Uptown, 47400 Petaling Jaya
            </fo:block>
        </fo:block>
    </xsl:template>

    <xsl:template name="remittanceFooter">
        <!-- 1) Remittance advice lines -->
        <fo:block
                font-family="{$v_invoice_font}"
                font-size="10pt"
                line-height="1.2"
                space-after="2pt">
            Remittance advices should be emailed to: myrcpt@dhl.com
        </fo:block>
        <fo:block
                font-family="{$v_invoice_font}"
                font-size="10pt"
                line-height="1.2"
                space-after="4mm">
            Please state your DHL Invoice Number and Account Number as a reference when making a payment.
        </fo:block>

        <!-- 2) Thank-you message -->
        <fo:block
                font-family="{$v_invoice_font}"
                font-size="14pt"
                font-weight="bold"
                text-align="center"
                space-before="2mm">
            THANK YOU FOR CHOOSING DHL
        </fo:block>
    </xsl:template>

    <xsl:template name="qrCode">
        <fo:block text-align="right">
            <fo:instream-foreign-object width="15mm" height="15mm">
                <svg xmlns="http://www.w3.org/2000/svg" width="100" height="100">
                    <rect x="5" y="5" width="90" height="90" fill="none" stroke="black" stroke-width="2"/>
                    <text x="50" y="50" text-anchor="middle" dominant-baseline="middle"
                          font-family="Arial" font-size="10">QR CODE</text>
                </svg>
            </fo:instream-foreign-object>
        </fo:block>
    </xsl:template>

    <xsl:template name="portugueseReceipt">
        <!-- full-width 3-column table -->
        <fo:table
                table-layout="fixed"
                width="100%"
                font-family="{$v_invoice_font}"
                font-size="9pt"
                space-after="5mm">

            <!-- adjust these percentages to taste -->
            <fo:table-column column-width="45%"/>
            <fo:table-column column-width="35%"/>
            <fo:table-column column-width="20%"/>

            <fo:table-body>
                <fo:table-row>

                    <!-- LEFT column: address and web link -->
                    <fo:table-cell padding-right="5mm">
                        <fo:block font-weight="bold">DHL Express Portugal, Lda.</fo:block>
                        <fo:block>Aeroporto de Lisboa Rua C Edifício</fo:block>
                        <fo:block>69 3 Piso Gabinete 306 30 8</fo:block>
                        <fo:block>1700-008 Lisboa</fo:block>
                        <fo:block>
                            <fo:basic-link external-destination="https://www.dhl.pt">
                                www.dhl.pt
                            </fo:basic-link>
                        </fo:block>
                    </fo:table-cell>

                    <!-- MIDDLE column: company footer details -->
                    <fo:table-cell padding-right="5mm">
                        <fo:block>Sociedade Por Quotas – Capital Social 3.086.328,03 euros</fo:block>
                        <fo:block>Mat. Na Cons. do Reg. Com. da Maia</fo:block>
                        <fo:block>Sob o nº 57.701</fo:block>
                        <fo:block>NIPC PT 500 731 993</fo:block>
                    </fo:table-cell>

                    <!-- RIGHT column: ATCUD + QR code -->
                    <fo:table-cell text-align="start" vertical-align="top">
                        <!-- dynamic ATCUD from your XML -->
                        <fo:block font-weight="bold" space-after="2mm">
                            ATCUD: <xsl:value-of select="/INVOICE/PORTUGUESE_RECEIPT/ATCUD"/>
                        </fo:block>
                        <!-- call your existing qrCode template -->
                        <fo:block>
                            <xsl:call-template name="qrCode"/>
                        </fo:block>
                    </fo:table-cell>

                </fo:table-row>
            </fo:table-body>
        </fo:table>
    </xsl:template>


    <xsl:template name="callingTariff">
        <fo:block font-family="Helvetica" font-size="9pt" space-after="5mm">
            <!-- First line in uppercase -->
            <fo:block font-weight="bold" text-align="start" text-transform="uppercase">
                ESTE DOCUMENTO É VALIDO COMO RECIBO APÓS BOA COBRANÇA
            </fo:block>

            <!-- Second line about tariffs -->
            <fo:block text-align="start" >
                Custo chamada 707 (faturada ao seg. após 1 min) da rede fixa: 0,09EUR/min, da rede móvel: 0,13EUR/min
            </fo:block>

            <!-- Certificate number in smaller font -->
            <fo:block text-align="start" font-size="8pt">
                kvzH-Processado por programa certificado n.º 2843/AT
            </fo:block>

            <!-- ... other existing blocks ... -->
        </fo:block>
    </xsl:template>





</xsl:stylesheet>
