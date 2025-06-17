<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
    <xsl:variable name="v_invoice_font">Helvetica, sans-serif, SansSerif</xsl:variable>
    <xsl:variable name="v_invoice_msg">
        <xsl:value-of disable-output-escaping="yes" select="/INVOICE/INVOICE_HEADER/INVOICE_MESSAGE"></xsl:value-of>
    </xsl:variable>
    <xsl:template match="INVOICE">
        <!-- Get all of the variables needed for header sections that exists in the detail.
           As well, retrieve Header Values that will be placed in the detail section.
      -->
        <xsl:variable name="vConferenceId"></xsl:variable>
        <xsl:variable name="vPassCode"></xsl:variable>
        <xsl:variable name="vReplayNum"></xsl:variable>
        <xsl:variable name="vCodeSpecifies"></xsl:variable>
        <xsl:variable name="vTerms"></xsl:variable>
        <xsl:variable name="vArranger"></xsl:variable>
        <xsl:variable name="vLeader"></xsl:variable>
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
                    <fo:region-before extent="3cm"/>
                    <fo:region-after region-name="after-first" extent="8.5cm"/>
                </fo:simple-page-master>


                <fo:simple-page-master master-name="restPages"
                                        page-width="279mm"
                                        page-height="216mm"
                                        margin-top="0.5cm"
                                        margin-bottom="0.5cm"
                                        margin-left="0.5cm"
                                        margin-right="0.5cm">
                    <fo:region-body margin-top="2cm" margin-bottom="0.3cm"/>
                    <fo:region-before extent="3cm" region-name="before-rest"/>
                    <fo:region-after region-name="after-rest" extent="0.3cm"/>
                </fo:simple-page-master>

            <fo:page-sequence-master master-name="INVOICE">
                <fo:repeatable-page-master-alternatives>
                    <!-- apply portrait on the very first page -->
                    <fo:conditional-page-master-reference master-reference="firstPage"
                                                          page-position="first"/>
                    <!-- then landscape on the rest -->
                    <fo:conditional-page-master-reference master-reference="restPages"
                                                          page-position="rest"/>
                </fo:repeatable-page-master-alternatives>
            </fo:page-sequence-master>
        </fo:layout-master-set>

            <fo:page-sequence master-reference="INVOICE" initial-page-number="1">
                <fo:static-content flow-name="after-first">

                    <!-- 1) Bank-details (left) + Invoice-summary (right)-->
                    <fo:table
                            width="100%"
                            table-layout="fixed"
                            border-collapse="collapse"
                            margin-bottom="0.5cm">
                        <fo:table-column column-width="50%"/>
                        <fo:table-column column-width="50%"/>
                        <fo:table-body>
                            <fo:table-row>

                                <!-- LEFT HALF: Bank details -->
                                <fo:table-cell>
                                    <fo:table
                                            width="100%"
                                            table-layout="fixed"
                                            border-collapse="collapse"
                                            font-family="{$v_invoice_font}"
                                            font-size="8pt"
                                            border="1.5pt solid black">
                                        <fo:table-column column-width="5cm"/>
                                        <fo:table-column column-width="4.5cm"/>
                                        <fo:table-body>
                                            <fo:table-row >
                                                <fo:table-cell background-color="#E0E0E0" padding="3pt" border-right="1.5pt solid black"><fo:block font-weight="bold" >Bank Name:</fo:block></fo:table-cell>
                                                <fo:table-cell padding="3pt"><fo:block>Barclays Bank</fo:block></fo:table-cell>
                                            </fo:table-row>
                                            <fo:table-row border-top="1.5pt solid black">
                                                <fo:table-cell background-color="#E0E0E0" padding="3pt" border-right="1.5pt solid black"><fo:block font-weight="bold">Bank Address:</fo:block></fo:table-cell>
                                                <fo:table-cell padding="3pt"><fo:block>Hatch Str, Dublin</fo:block></fo:table-cell>
                                            </fo:table-row>
                                            <fo:table-row border-top="1.5pt solid black">
                                                <fo:table-cell background-color="#E0E0E0" padding="3pt" border-right="1.5pt solid black"><fo:block font-weight="bold">Account No:</fo:block></fo:table-cell>
                                                <fo:table-cell padding="3pt"><fo:block>44284401</fo:block></fo:table-cell>
                                            </fo:table-row>
                                            <fo:table-row border-top="1.5pt solid black">
                                                <fo:table-cell background-color="#E0E0E0" padding="3pt" border-right="1.5pt solid black"><fo:block font-weight="bold">Account Name:</fo:block></fo:table-cell>
                                                <fo:table-cell padding="3pt"><fo:block>DHL Express Ireland Ltd</fo:block></fo:table-cell>
                                            </fo:table-row>
                                            <fo:table-row border-top="1.5pt solid black">
                                                <fo:table-cell background-color="#E0E0E0" padding="3pt" border-right="1.5pt solid black"><fo:block font-weight="bold">IBAN Code:</fo:block></fo:table-cell>
                                                <fo:table-cell padding="3pt"><fo:block>IE15BARC99021244284401</fo:block></fo:table-cell>
                                            </fo:table-row>
                                            <fo:table-row border-top="1.5pt solid black">
                                                <fo:table-cell background-color="#E0E0E0" padding="3pt" border-right="1.5pt solid black"><fo:block font-weight="bold">Swift Code:</fo:block></fo:table-cell>
                                                <fo:table-cell padding="3pt"><fo:block>BARCIE2D</fo:block></fo:table-cell>
                                            </fo:table-row>
                                        </fo:table-body>
                                    </fo:table>
                                </fo:table-cell>

                                <!-- RIGHT HALF: Invoice summary -->
                                <fo:table-cell>
                                    <fo:table
                                            width="70%"
                                            table-layout="fixed"
                                            border-collapse="collapse"
                                            font-family="{$v_invoice_font}"
                                            font-size="8pt"
                                            border="1.5pt solid black"
                                            background-color="#E0E0E0"
                                            font-weight="bold">
                                        <fo:table-column column-width="30%"/>
                                        <fo:table-column column-width="70%"/>
                                        <fo:table-body>
                                            <fo:table-row>
                                                <fo:table-cell  padding="3pt" border-right="1.5pt solid black"><fo:block font-weight="bold">Invoice No:</fo:block></fo:table-cell>
                                                <fo:table-cell padding="3pt"><fo:block>
                                                    <xsl:value-of select="INVOICE_HEADER/INVOICE_ID"/>
                                                </fo:block></fo:table-cell>
                                            </fo:table-row>
                                            <fo:table-row border-top="1.5pt solid black">
                                                <fo:table-cell padding="3pt" border-right="1.5pt solid black"><fo:block font-weight="bold">Account No:</fo:block></fo:table-cell>
                                                <fo:table-cell padding="3pt"><fo:block>
                                                    <xsl:value-of select="INVOICE_HEADER/BILL_TO/ACCOUNT/AccountNumber"/>
                                                </fo:block></fo:table-cell>
                                            </fo:table-row>
                                            <fo:table-row border-top="1.5pt solid black">
                                                <fo:table-cell padding="3pt" border-right="1.5pt solid black"><fo:block font-weight="bold">Amount:</fo:block></fo:table-cell>
                                                <fo:table-cell padding="3pt"><fo:block>
                                                    <xsl:value-of select="format-number(number(translate(INVOICE_HEADER/BALANCE_DUE,'€','')),'#,##0.00')"/>
                                                    <xsl:text> </xsl:text>
                                                    <xsl:value-of select="INVOICE_HEADER/INVOICE_CURRENCY"/>
                                                </fo:block></fo:table-cell>
                                            </fo:table-row>
                                        </fo:table-body>
                                    </fo:table>
                                </fo:table-cell>

                            </fo:table-row>
                        </fo:table-body>
                    </fo:table>


                    <!-- 2) "Remittance advices…" box -->
                    <fo:table
                            width="100%"
                            border="1.2pt solid black"
                            background-color="#E0E0E0"
                            table-layout="fixed"
                            font-family="{$v_invoice_font}"
                            font-size="8pt"
                            margin-top="5pt"
                            margin-bottom=".8cm">
                        <fo:table-column column-width="proportional-column-width(1)"/>
                        <fo:table-body>
                            <fo:table-row>
                                <fo:table-cell padding="5pt">
                                    <fo:block font-weight="bold">
                                        Remittance advices should be emailed to: ierpu@dhl.com
                                    </fo:block>
                                    <fo:block space-before="10pt">
                                        Please state your DHL Invoice Number and Account Number as a reference when making a payment.
                                    </fo:block>
                                    <fo:block space-before="2pt">
                                        If you have a query on this invoice you need to raise it within 21 days by emailing ie.invenq@dhl.com
                                    </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </fo:table-body>
                    </fo:table>

                    <!-- 3) DHL footer lines -->
                    <fo:block font-family="{$v_invoice_font}"
                              font-size="8pt"
                              text-align="center"
                              space-after="1pt"
                              font-weight="bold">
                        DHL EXPRESS IRELAND LTD, UNIT 3 DUBLIN AIRPORT LOGISTICS PARK, ST. MARGARETS, CO. DUBLIN
                    </fo:block>
                    <fo:block font-family="{$v_invoice_font}"
                              font-size="8pt"
                              text-align="center"
                              space-after="3pt">
                        • Tel: 0818 221188 • Company Reg. No: 106091 • DHL VAT No. IE4799587H • Crest Code: EIE001
                    </fo:block>

                </fo:static-content>


                <fo:static-content flow-name="after-rest">
                    <fo:block>
                    </fo:block>
                </fo:static-content>

                <fo:static-content flow-name="xsl-region-before">
                    <fo:block text-align="start">
                        <xsl:choose>
                            <xsl:when test="string-length(INVOICE_HEADER/INVOICE_LOGO) &gt; 1">
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

                <fo:flow flow-name="xsl-region-body">
                    <!-- Cover -->
                    <xsl:apply-templates select="INVOICE_HEADER"></xsl:apply-templates>
                    <!-- detail -->
                    <!--line item detail -->
                    <fo:block></fo:block>
                    fo:block-container width="19cm" top="7cm" left="0cm" position="absolute" padding-before="10pt"
                    <xsl:apply-templates select="GROUP[GROUP_HIDE_FLAG != 1]"/>
                    /fo:block-container
                    <fo:block id="lastPage"></fo:block>
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
                                        <fo:table-cell><fo:block >Invoice Number:</fo:block></fo:table-cell>
                                        <fo:table-cell text-align="end"><fo:block><xsl:value-of select="INVOICE_ID"/></fo:block></fo:table-cell>
                                    </fo:table-row>
                                    <fo:table-row>
                                        <fo:table-cell><fo:block >Account Number:</fo:block></fo:table-cell>
                                        <fo:table-cell text-align="end"><fo:block><xsl:value-of select="BILL_TO/GROUP_ID"/></fo:block></fo:table-cell>
                                    </fo:table-row>
                                    <fo:table-row>
                                        <fo:table-cell><fo:block >Invoice Date:</fo:block></fo:table-cell>
                                        <fo:table-cell text-align="end"><fo:block><xsl:value-of select="INVOICE_DATE"/></fo:block></fo:table-cell>
                                    </fo:table-row>
                                    <fo:table-row>
                                        <fo:table-cell><fo:block>Payment Terms:</fo:block></fo:table-cell>
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
                                For Invoice Enquiries
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

    <xsl:template match="GROUP[@ID='4']">
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


    <xsl:template match="GROUP">
        <xsl:variable name="level" select="count(ancestor-or-self::GROUP)"></xsl:variable>


        <xsl:variable name="headerFontSize">
            <xsl:choose>
                <xsl:when test="$level=1">10pt</xsl:when>
                <xsl:when test="$level=2">8pt</xsl:when>
                <xsl:when test="$level=3">8pt</xsl:when>
                <xsl:otherwise>6pt</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="pageBreak">
            <xsl:choose>
                <xsl:when test="string-length(@pageBreak) > 0">
                    <xsl:value-of select="@pageBreak"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>auto</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="headerUnderline">
            <xsl:choose>
                <xsl:when test="$level=1">.3mm</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <fo:block>
            <fo:block break-before="{$pageBreak}"> </fo:block>
        </fo:block>

        <!--<xsl:if test="GROUP_HEADER_ROW/COL !='' and GROUP_DATA_ROW/COL !=''">-->
        <xsl:if test="@label !=''">

            <fo:table width="19cm"  border-collapse="collapse" table-layout="fixed"
                      font-family="{$v_invoice_font}" font-size="{$headerFontSize}" space-before=".15cm">
                <fo:table-column column-width="19cm" ></fo:table-column>
                <fo:table-body>
                    <fo:table-row>
                        <fo:table-cell  font-weight="bold" border-bottom=" {$headerUnderline} solid black">
                            <!-- border-bottom=".4mm solid black"-->
                            <fo:block>
                                <xsl:value-of select="@label"></xsl:value-of>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>
        </xsl:if>
        <!--fo:block border=".1mm black solid" line-height="8pt" font-family="{$v_invoice_font}" font-weight="bold" font-size="8pt" background-color="rgb(200,200,200)" width="100%" padding-before="2pt" padding-after="1pt">
        <xsl:value-of select="@label"></xsl:value-of>
      </fo:block-->
        <xsl:if test="GROUP_DATA_ROW/COL !=''">
            <fo:table  width="19cm" break-before="{$pageBreak}" border-collapse="collapse" table-layout="fixed" table-omit-header-at-break="false" space-before=".1cm">

                <!-- add in the column definitions -->
                <xsl:for-each select="GROUP_HEADER_ROW/COL">

                    <fo:table-column column-width="{@width}" text-align="{@headerAlign}"
                                     background-color="white" font-family="{$v_invoice_font}" font-size="8pt"></fo:table-column>
                </xsl:for-each>

                <!--
                add in the header row
                -->
                <fo:table-header>
                    <xsl:apply-templates select="GROUP_HEADER_ROW/COL">
                        <xsl:with-param name="level"  select="$level"/>
                    </xsl:apply-templates>
                </fo:table-header>

                <fo:table-body>
                    <!--
                        Add in the Detail Rows
                       -->
                    <xsl:apply-templates select="GROUP_DATA_ROW"></xsl:apply-templates>

                    <xsl:apply-templates select="GROUP_SUBTOTAL_ROW">
                        <xsl:with-param name="parentLabel" select="@label"></xsl:with-param>
                    </xsl:apply-templates>

                </fo:table-body>

            </fo:table>
        </xsl:if>
        <xsl:apply-templates select="GROUP"></xsl:apply-templates>

    </xsl:template>
    <xsl:template match="GROUP/GROUP_HEADER_ROW/COL">
        <xsl:param name="level"></xsl:param>
        <xsl:variable name="vAlign" select="@headerAlign"></xsl:variable>

        <xsl:if test="$level=1">
            <fo:table-cell border-bottom=".1mm  solid black" font-size="8pt" font-weight="bold" text-align="{$vAlign}" >
                <fo:block padding-top=".4mm"  border-bottom=".1mm solid black" text-indent="0em" start-indent="0em" font-family="{$v_invoice_font}"  >
                    <xsl:value-of select="."></xsl:value-of>
                </fo:block>
            </fo:table-cell>
        </xsl:if>
        <xsl:if test="$level!=1">
            <fo:table-cell border-bottom=".1mm  solid black" font-size="8pt" font-weight="bold" text-align="{$vAlign}" >
                <fo:block border-bottom=".1mm solid black" text-indent="0em" start-indent="0em" font-family="{$v_invoice_font}" >
                    <xsl:value-of select="."></xsl:value-of>
                </fo:block>
            </fo:table-cell>
        </xsl:if>
    </xsl:template>
    <xsl:template match="GROUP/GROUP_DATA_ROW">
        <fo:table-row height=".5cm">
            <xsl:apply-templates select="COL"></xsl:apply-templates>
        </fo:table-row>
    </xsl:template>
    <xsl:template match="GROUP/GROUP_DATA_ROW/COL">
        <xsl:variable name="vPos" select="position()"></xsl:variable>
        <xsl:variable name="vAlign" select="../../GROUP_HEADER_ROW/COL[$vPos]/@headerAlign"></xsl:variable>
        <!--xsl:variable name="vFormat" select="../../GROUP_HEADER_ROW/COL[$vPos]/@headerFormat"></xsl:variable-->
        <fo:table-cell  font-weight="400" text-align="{$vAlign}" >
            <fo:block text-indent="0em" start-indent="0em" font-family="{$v_invoice_font}" font-size="8pt" padding=".5mm">
                <xsl:value-of select="."></xsl:value-of>
            </fo:block>
        </fo:table-cell>
    </xsl:template>
    <xsl:template match="GROUP/GROUP_SUBTOTAL_ROW">
        <xsl:param name="parentLabel"></xsl:param>
        <fo:table-row>
            <xsl:variable name="column_span" select="count(COL[.=''])"></xsl:variable>
            <fo:table-cell border-top=".2mm solid black" font-weight="400" text-align="right" number-columns-spanned="{$column_span}">
                <fo:block padding=".5mm" font-weight="bold" text-indent="0em" start-indent="0em" font-family="{$v_invoice_font}" font-size="8pt" >
                    Total:
                </fo:block>
            </fo:table-cell>
            <xsl:apply-templates select="COL"></xsl:apply-templates>
        </fo:table-row>
    </xsl:template>

    <xsl:template match="GROUP/GROUP_SUBTOTAL_ROW/COL">
        <xsl:variable name="v_val" select="."></xsl:variable>
        <xsl:if test="$v_val !=''">
            <xsl:variable name="vHeaderPos" select="position()"></xsl:variable>
            <!--xsl:variable name="vFormat" select="../../GROUP_HEADER_ROW/COL[$vHeaderPos]/@headerFormat"></xsl:variable-->
            <fo:table-cell border-top=".2mm solid black" border-bottom=".2mm solid black"  font-weight="400" text-align="end">
                <fo:block padding=".5mm" font-weight="bold" text-indent="0em" start-indent="0em" font-family="{$v_invoice_font}" font-size="8pt">
                    <xsl:value-of select="."></xsl:value-of>
                </fo:block>
            </fo:table-cell>
        </xsl:if>
    </xsl:template>

    <xsl:template match="ROLLUP"></xsl:template>

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


</xsl:stylesheet>
