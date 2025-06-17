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
                <fo:simple-page-master master-name="any" page-height="279mm" page-width="216mm" margin-top=".5cm" margin-bottom=".5cm" margin-left=".5cm + 0.5cm" margin-right=".5cm + 0.5cm">
                    <fo:region-body margin-top=".5cm" margin-bottom=".5cm"></fo:region-body>
                    <fo:region-before extent=".3cm"></fo:region-before>
                    <fo:region-after extent=".3cm"></fo:region-after>
                </fo:simple-page-master>

                <fo:page-sequence-master master-name="INVOICE">
                    <fo:repeatable-page-master-alternatives>
                        <fo:conditional-page-master-reference master-reference="any" page-position="any"></fo:conditional-page-master-reference>
                    </fo:repeatable-page-master-alternatives>
                </fo:page-sequence-master>
            </fo:layout-master-set>

            <fo:page-sequence master-reference="INVOICE" initial-page-number="1">
                <fo:static-content flow-name="xsl-region-after">
                    <fo:table border-collapse="collapse" font-size="8pt" font-family="{$v_invoice_font}" color="grey" table-layout="fixed" width="100%">
                        <fo:table-column column-width="30%" text-align="start"></fo:table-column>
                        <fo:table-column column-width="40%" text-align="center"></fo:table-column>
                        <fo:table-column column-width="30%" text-align="end"></fo:table-column>
                        <fo:table-body>
                            <fo:table-row>
                                <fo:table-cell>
                                    <fo:block>
                                        Billing Questions? <xsl:value-of select="/INVOICE/INVOICE_HEADER/BILL_FROM/CONTACT_NUMBER"></xsl:value-of>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block text-align="center" font-family="{$v_invoice_font}">
                                        page <fo:page-number />
                                        of <fo:page-number-citation ref-id="lastPage"/>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block font-family="{$v_invoice_font}">
                                        Invoice Number: <xsl:value-of select="/INVOICE/INVOICE_HEADER/INVOICE_ID"></xsl:value-of>
                                    </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </fo:table-body>
                    </fo:table>
                </fo:static-content>
                <fo:flow flow-name="xsl-region-body">
                    <!-- Cover -->
                    <xsl:apply-templates select="INVOICE_HEADER"></xsl:apply-templates>
                    <!-- detail -->
                    <!--line item detail -->
                    <fo:block></fo:block>
                    <!--fo:block-container width="19cm" top="7cm" left="0cm" position="absolute" padding-before="10pt"-->
                    <xsl:apply-templates select="GROUP[GROUP_HIDE_FLAG != 1]"/>
                    <!--/fo:block-container-->
                    <fo:block id="lastPage"></fo:block>

                </fo:flow>

            </fo:page-sequence>
        </fo:root>
    </xsl:template>
    <xsl:template match="INVOICE_HEADER">
        <!-- header summary and cut-away payment stub-->
        <fo:table width="19cm"  border-collapse="collapse" table-layout="fixed">
            <fo:table-column column-width="11cm" text-align="start" ></fo:table-column>
            <fo:table-column column-width="9cm" text-align="start"></fo:table-column>
            <fo:table-body>
                <fo:table-row>
                    <fo:table-cell >
                        <!-- to and from address plus change-of-address form-->
                        <fo:table width="11cm"   border-collapse="collapse" table-layout="fixed">
                            <fo:table-column column-width="5.4cm" text-align="start" font-size="8pt" font-family="{$v_invoice_font}"></fo:table-column>
                            <fo:table-column column-width="5cm" text-align="start" font-size="8pt" font-family="{$v_invoice_font}" ></fo:table-column>
                            <fo:table-body>
                                <fo:table-row>
                                    <fo:table-cell>
                                        <xsl:variable name="v_logo" select="INVOICE_LOGO"></xsl:variable>
                                        <!-- INVOICE Header -->
                                        <fo:block margin-left=".5cm" margin-top="2.3cm">
                                            <xsl:if test="string-length($v_logo) &gt; 1">
                                                <fo:external-graphic  content-height="scale-to-fit"
                                                                      content-width="scale-to-fit"
                                                                      scaling="uniform" height="18mm" src="{$v_logo}" ></fo:external-graphic>

                                            </xsl:if>
                                            <xsl:if test="string-length($v_logo) &lt; 2 ">
                                                <fo:block margin-top="2.3cm" text-align="start" line-height="1.5cm" font-family="{$v_invoice_font}" font-weight="bold" font-size="14pt">
                                                    <xsl:value-of select="BILL_FROM/ACCOUNT_NAME"></xsl:value-of>
                                                </fo:block>
                                            </xsl:if>
                                        </fo:block>
                                    </fo:table-cell>
                                    <!--  <fo:table-cell display-align="after" font-size="8pt" font-family="{$v_invoice_font}">

                                          <fo:block margin-top="2cm">
                                              <xsl:value-of select="BILL_FROM/ACCOUNT_NAME"></xsl:value-of>
                                          </fo:block>
                                          <fo:block>
                                              <xsl:value-of select="BILL_FROM/ADDR1"></xsl:value-of>
                                          </fo:block>
                                          <fo:block>
                                              <xsl:value-of select="BILL_FROM/ADDR2"></xsl:value-of>
                                          </fo:block>
                                          <fo:block>
                                              <xsl:value-of select="concat(BILL_FROM/CITY,', ',BILL_FROM/STATE,' ',BILL_FROM/ZIP)"></xsl:value-of>
                                          </fo:block>
                                      </fo:table-cell> -->
                                </fo:table-row>
                                <fo:table-row number-columns-spanned="2"  >
                                    <fo:table-cell font-size="8pt" font-family="{$v_invoice_font}" column-width="5cm">
                                        <!-- To Address-->
                                        <!--fo:block font-weight="bold" margin-left=".5cm" margin-top=".4cm">Bill To:</fo:block -->
                                        <fo:block margin-left=".8cm"  margin-top=".1cm">
                                            <xsl:value-of select="BILL_TO/BILL_TO"></xsl:value-of>
                                        </fo:block>
                                        <xsl:if test="BILL_TO/ATTN !=''">
                                            <fo:block margin-left=".8cm" >
                                                <xsl:value-of select="concat('Attn: ',BILL_TO/ATTN)"></xsl:value-of>
                                            </fo:block>
                                        </xsl:if>
                                        <fo:block margin-left=".8cm" >
                                            <xsl:value-of select="BILL_TO/ADDR1"></xsl:value-of>
                                        </fo:block>
                                        <fo:block margin-left=".8cm" >
                                            <xsl:value-of select="BILL_TO/ADDR2"></xsl:value-of>
                                        </fo:block>
                                        <fo:block margin-left=".8cm" >
                                            <xsl:value-of select="concat(BILL_TO/CITY,', ',BILL_TO/STATE,' ',BILL_TO/ZIP)"></xsl:value-of>
                                        </fo:block>
                                    </fo:table-cell>
                                </fo:table-row>
                            </fo:table-body>
                        </fo:table>

                    </fo:table-cell>
                    <fo:table-cell >
                        <!-- INVOICE info and billing payment address-->
                        <fo:table font-family="{$v_invoice_font}"
                                  table-layout="fixed" width="7cm">
                            <fo:table-column column-width="3.5cm" text-align="start" ></fo:table-column>
                            <fo:table-column column-width="4.5cm" text-align="end"></fo:table-column>
                            <fo:table-body>
                                <fo:table-row>
                                    <fo:table-cell >
                                        <fo:block margin-top="1.5cm">
                                            <fo:block  font-family="{$v_invoice_font}"
                                                       font-weight="bold" font-size="8pt" >
                                                Invoice Number:
                                            </fo:block>
                                        </fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell >
                                        <fo:block font-family="{$v_invoice_font}"
                                                  font-size="8pt" text-align="end" margin-top="1.5cm">
                                            <xsl:value-of select="INVOICE_ID"/>
                                        </fo:block>
                                    </fo:table-cell >
                                </fo:table-row>
                                <fo:table-row>
                                    <fo:table-cell >
                                        <fo:block >
                                            <fo:block  font-family="{$v_invoice_font}"
                                                       font-weight="bold" font-size="8pt" >
                                                Invoice Date:
                                            </fo:block>
                                        </fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell >
                                        <fo:block  font-family="{$v_invoice_font}"
                                                   font-size="8pt" text-align="end">
                                            <xsl:value-of select="INVOICE_DATE"/>
                                        </fo:block>
                                    </fo:table-cell >
                                </fo:table-row>
                                <fo:table-row>
                                    <fo:table-cell >
                                        <fo:block >
                                            <fo:block  font-family="{$v_invoice_font}"
                                                       font-weight="bold" font-size="8pt" >
                                                Account Number:
                                            </fo:block>
                                        </fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell >
                                        <fo:block  font-family="{$v_invoice_font}"
                                                   font-size="8pt" text-align="end">
                                            <xsl:value-of select="BILL_TO/GROUP_ID"></xsl:value-of>
                                        </fo:block>
                                    </fo:table-cell >
                                </fo:table-row>
                                <fo:table-row>
                                    <fo:table-cell >
                                        <fo:block >
                                            <fo:block  font-family="{$v_invoice_font}"
                                                       font-weight="bold" font-size="8pt" >
                                                Amount Due:
                                            </fo:block>
                                        </fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell >
                                        <fo:block font-family="{$v_invoice_font}"
                                                  font-size="8pt" text-align="end">
                                            <xsl:value-of select="BALANCE_DUE"></xsl:value-of>
                                        </fo:block>
                                    </fo:table-cell >
                                </fo:table-row>
                                <fo:table-row>
                                    <fo:table-cell >
                                        <fo:block >
                                            <fo:block  font-family="{$v_invoice_font}"
                                                       font-weight="bold" font-size="8pt" >
                                                Amount Enclosed:
                                            </fo:block>
                                        </fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell >
                                        <fo:block padding-left=".8mm" padding-bottom=".2mm" padding-top=".4mm" font-family="{$v_invoice_font}"
                                                  font-size="7pt" text-align="start" height=".5cm"  border=".1mm solid black">
                                            $
                                        </fo:block>
                                    </fo:table-cell >
                                </fo:table-row>
                                <fo:table-row>
                                    <fo:table-cell >
                                        <fo:block >
                                            <fo:block  font-family="{$v_invoice_font}"
                                                       font-weight="bold" font-size="8pt" >
                                                Payment Terms:
                                            </fo:block>
                                        </fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell >
                                        <fo:block font-family="{$v_invoice_font}"
                                                  font-size="8pt" text-align="end">
                                            Net <xsl:value-of select="BILL_TO/PAYMENT_TERMS"></xsl:value-of>
                                        </fo:block>
                                    </fo:table-cell >
                                </fo:table-row>
                            </fo:table-body>
                        </fo:table>
                        <!-- Payment Address-->

                        <fo:table font-family="{$v_invoice_font}" width="8.5cm" table-layout="fixed" space-before=".3cm">
                            <fo:table-column column-width="8cm" text-align="start" font-family="{$v_invoice_font}"></fo:table-column>
                            <fo:table-body>
                                <fo:table-row >
                                    <fo:table-cell font-weight="bold" font-size="9pt"
                                                   text-align="start" border-bottom=".4mm solid black">
                                        <fo:block>Please Mail Payments to</fo:block>
                                    </fo:table-cell>
                                </fo:table-row>
                                <fo:table-row>
                                    <fo:table-cell  padding-before="10pt" padding-after="10pt"
                                                    text-align="start" font-family="{$v_invoice_font}" font-size="8pt">
                                        <fo:block margin-left=".5cm">
                                            <xsl:value-of select="BILL_FROM/ACCOUNT_NAME"></xsl:value-of>
                                        </fo:block>
                                        <xsl:if test="BILL_FROM/ATTN !=''">
                                            <fo:block margin-left=".5cm">
                                                <xsl:value-of select="concat('Attn: ',BILL_FROM/ATTN)"></xsl:value-of>
                                            </fo:block>
                                        </xsl:if>
                                        <fo:block margin-left=".5cm">
                                            <xsl:value-of select="BILL_FROM/ADDR1"></xsl:value-of>
                                        </fo:block>
                                        <xsl:if test="BILL_FROM/ADDR2 !=''">
                                            <fo:block margin-left=".5cm">
                                                <xsl:value-of select="BILL_FROM/ADDR2"></xsl:value-of>
                                            </fo:block>
                                        </xsl:if>
                                        <fo:block margin-left=".5cm">
                                            <xsl:value-of select="concat(BILL_FROM/CITY,', ')"></xsl:value-of>
                                            <xsl:value-of select="concat(BILL_FROM/STATE,' ')"></xsl:value-of>
                                            <xsl:value-of select="BILL_FROM/ZIP"></xsl:value-of>
                                        </fo:block>
                                    </fo:table-cell>
                                </fo:table-row>
                                <xsl:choose>
                                    <xsl:when test="EBPP_URL = '-1'">
                                        <fo:table-row>
                                            <fo:table-cell padding-after="1pt">
                                                <fo:block line-height="11pt"></fo:block>
                                            </fo:table-cell>
                                        </fo:table-row>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <fo:table-row>
                                            <fo:table-cell text-align="start" color="#127698" padding-before="1pt" padding-after="1pt"
                                                           font-family="{$v_invoice_font}" font-size="8pt"
                                                           padding-left="6pt" border-top=".2mm solid #127698" border-bottom=".2mm solid #127698">


                                                <fo:block text-align="center" font-family="{$v_invoice_font}" font-size="8pt" line-height="11pt">
                                                    View online at <xsl:value-of select="EBPP_URL"/>
                                                </fo:block>

                                            </fo:table-cell>
                                        </fo:table-row>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </fo:table-body>
                        </fo:table>
                    </fo:table-cell>
                </fo:table-row>

            </fo:table-body>
        </fo:table>
        <!-- End Header-->
        <!--Roll-up-->

        <!-- INVOICE messages-->
        <fo:table width="19cm"  border-collapse="collapse" table-layout="fixed" font-family="{$v_invoice_font}"
                  font-size="8pt" space-before=".2cm" space-after=".1cm">
            <fo:table-column column-width="19cm" ></fo:table-column>
            <fo:table-body>
                <fo:table-row>
                    <fo:table-cell  padding-top=".3cm" height="1.6cm" border-bottom=".4mm dashed black">
                        <fo:block color="#127698" linefeed-treatment="preserve">
                            <xsl:value-of select="INVOICE_MESSAGE" />
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>


        <!-- end INVOICE messages-->
        <!-- roll-ups -->
        <fo:table width="19cm" space-before=".4cm"  border-collapse="collapse" table-layout="fixed" >
            <fo:table-column column-width="7cm" ></fo:table-column>
            <fo:table-column column-width="4cm" ></fo:table-column>
            <fo:table-column column-width="8cm" ></fo:table-column>
            <fo:table-body>
                <fo:table-row>
                    <fo:table-cell >
                        <!-- Invoice Summary-->
                        <fo:table width="6.6cm"  border-collapse="collapse" table-layout="fixed" font-family="{$v_invoice_font}" font-size="8pt">
                            <fo:table-column column-width="4.6cm" text-align="start" font-weight="bold"></fo:table-column>
                            <fo:table-column column-width="3cm" text-align="end"></fo:table-column>
                            <fo:table-body>
                                <fo:table-row >
                                    <fo:table-cell font-size="9pt"  font-weight="bold" number-columns-spanned="2">
                                        <fo:block border-bottom=".4mm solid black">Invoice Summary</fo:block>
                                    </fo:table-cell>
                                </fo:table-row>
                                <fo:table-row>
                                    <fo:table-cell padding-before="2pt">
                                        <fo:block>Current Charges:</fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell text-align="end" padding-before="2pt" padding-right="2pt">
                                        <fo:block>
                                            <xsl:value-of select="TOTAL_AMOUNT"></xsl:value-of>
                                        </fo:block>
                                    </fo:table-cell>
                                </fo:table-row>
                                <fo:table-row>
                                    <fo:table-cell>
                                        <fo:block>Previous Balance:</fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell text-align="end" padding-right="2pt">
                                        <fo:block>
                                            <xsl:value-of select="PREVIOUS_BALANCE"></xsl:value-of>
                                        </fo:block>
                                    </fo:table-cell>
                                </fo:table-row>

                                <fo:table-row>
                                    <fo:table-cell>
                                        <fo:block>Payments:</fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell text-align="end" padding-right="2pt">
                                        <fo:block>
                                            <xsl:value-of select="LAST_PAYMENT"></xsl:value-of>
                                        </fo:block>
                                    </fo:table-cell>
                                </fo:table-row>

                                <fo:table-row>
                                    <fo:table-cell>
                                        <fo:block>Credit:</fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell text-align="end" padding-right="2pt">
                                        <fo:block>
                                            <xsl:value-of select="CREDIT_CHARGES"></xsl:value-of>
                                        </fo:block>
                                    </fo:table-cell>
                                </fo:table-row>

                                <!-- get the Tax Rows -->
                                <xsl:call-template name="getTaxData"/>
                                <fo:table-row border=".2mm solid black">
                                    <fo:table-cell text-align="center" padding-before="2pt">
                                        <fo:block>Total Due:</fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell text-align="end" padding-before="2pt" padding-right="2pt">
                                        <fo:block>
                                            <xsl:value-of select="BALANCE_DUE"></xsl:value-of>
                                        </fo:block>
                                    </fo:table-cell>
                                </fo:table-row>
                            </fo:table-body>
                        </fo:table>
                    </fo:table-cell>
                    <fo:table-cell >
                        <fo:block></fo:block>
                    </fo:table-cell>
                    <fo:table-cell >
                        <fo:block>
                            <!-- Aging-->
                            <xsl:if test="/INVOICE/INVOICE_AGING !=''">
                                <xsl:call-template name="createAging"/>
                            </xsl:if>
                        </fo:block>
                    </fo:table-cell>

                </fo:table-row>
            </fo:table-body>
        </fo:table>
        <!-- end roll-ups -->

        <!-- INVOICE Leagal messages-->
        <fo:table width="19cm" border-collapse="collapse" table-layout="fixed" font-family="{$v_invoice_font}"
                  font-size="7pt" space-before=".2cm" space-after=".1cm">
            <fo:table-column column-width="19cm" ></fo:table-column>
            <fo:table-body>
                <fo:table-row>
                    <fo:table-cell padding-top=".3cm" >
                        <fo:block color="grey"  break-after="page" linefeed-treatment="preserve">
                            <xsl:value-of select="INVOICE_MESSAGE1" disable-output-escaping="no" />
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
        <!-- Past Due Invoices section-->

        <!--xsl:if test="/INVOICE/INVOICE_PAST_DUE !=''">
            <xsl:call-template name="getPastDueInvoices"/>

        </xsl:if-->

        <!-- Subscriptions and Fees -->
        <xsl:call-template name="getSubscriptionData"/>

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
