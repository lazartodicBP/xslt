<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format">

    <xsl:output method="xml" indent="yes"/>

    <!-- ============ Root: layout & footer ============ -->
    <xsl:template match="/">
        <fo:root>
            <fo:layout-master-set>
                <fo:simple-page-master master-name="A4"
                                       page-width="21cm" page-height="29.7cm"
                                       margin="1cm">
                    <fo:region-body margin="1.5cm"/>
                    <fo:region-before extent="2cm"/>
                    <fo:region-after extent="1.5cm"/>
                </fo:simple-page-master>
            </fo:layout-master-set>

            <fo:page-sequence master-reference="A4">
                <!-- Footer -->
                <fo:static-content flow-name="xsl-region-after">
                    <fo:block text-align="center" font-size="8pt"
                              font-family="Helvetica" color="#666666"
                              border-top="1pt solid #cccccc" padding-top="5pt">
                        <xsl:value-of select="RCTI/Footer/Brand"/> |
                        <xsl:value-of select="RCTI/Footer/DocumentType"/>
                        Page <fo:page-number/> of
                        <xsl:value-of select="RCTI/Footer/TotalPages"/>
                    </fo:block>
                </fo:static-content>

                <fo:flow flow-name="xsl-region-body">
                    <!-- Page 1: header & summary line -->
                    <fo:block font-size="18pt" font-weight="bold"
                              color="#2c3e50" space-after="5mm" text-align="center">
                        <xsl:value-of select="RCTI/Header/Title"/>
                    </fo:block>

                    <fo:block font-weight="bold" space-after="2mm">Attention</fo:block>
                    <fo:block><xsl:value-of select="RCTI/Header/Attention"/></fo:block>
                    <fo:block>E: <xsl:value-of select="RCTI/Header/Email"/></fo:block>
                    <fo:block space-after="5mm"/>

                    <fo:block font-weight="bold">
                        <xsl:value-of select="RCTI/Header/Recipient/Name"/>
                    </fo:block>
                    <fo:block>
                        ABN / ACN:
                        <xsl:value-of select="RCTI/Header/Recipient/ABN"/>
                    </fo:block>
                    <fo:block>
                        <xsl:value-of select="RCTI/Header/Recipient/Address"/>
                    </fo:block>
                    <fo:block space-after="5mm">
                        <xsl:value-of select="RCTI/Header/Recipient/City"/>
                    </fo:block>

                    <!-- one-row summary table -->
                    <fo:block font-weight="bold" space-after="2mm">Description</fo:block>
                    <fo:table table-layout="fixed" width="100%" font-size="10pt">
                        <fo:table-column column-width="70%"/>
                        <fo:table-column column-width="30%"/>
                        <fo:table-body>
                            <fo:table-row>
                                <fo:table-cell padding="2mm">
                                    <fo:block>
                                        Revenue share for
                                        <xsl:value-of select="RCTI/Header/BillingPeriod"/>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell padding="2mm" text-align="right">
                                    <fo:block>
                                        $<xsl:value-of select="RCTI/Summary/RevenueShareExGST"/>
                                    </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </fo:table-body>
                    </fo:table>
                    <fo:block space-after="5mm"/>

                    <!-- instructions & issuer info -->
                    <fo:block font-weight="bold" space-after="2mm">Instructions: N/A</fo:block>
                    <fo:block font-weight="bold" space-after="10mm">
                        <xsl:value-of select="RCTI/Header/PaymentTerms"/>
                    </fo:block>

                    <fo:block text-align="center">
                        <fo:leader leader-pattern="rule" leader-length="100%"/>
                    </fo:block>

                    <fo:block font-weight="bold" space-after="2mm">
                        <xsl:value-of select="RCTI/Header/Issuer/Name"/>
                    </fo:block>
                    <fo:block>ABN <xsl:value-of select="RCTI/Header/Issuer/ABN"/></fo:block>
                    <fo:block>E <xsl:value-of select="RCTI/Header/Issuer/Email"/></fo:block>
                    <fo:block><xsl:value-of select="RCTI/Header/Issuer/Address"/></fo:block>
                    <fo:block space-after="5mm">
                        <xsl:value-of select="RCTI/Header/Issuer/City"/>
                    </fo:block>

                    <fo:block>
                        <fo:inline font-weight="bold">Date: </fo:inline>
                        <xsl:value-of select="RCTI/Header/Date"/>
                    </fo:block>
                    <fo:block>
                        <fo:inline font-weight="bold">Billing period: </fo:inline>
                        <xsl:value-of select="RCTI/Header/BillingPeriod"/>
                    </fo:block>
                    <fo:block space-after="5mm">
                        <fo:inline font-weight="bold">Document number: </fo:inline>
                        <xsl:value-of select="RCTI/Header/DocumentNumber"/>
                    </fo:block>

                    <fo:block space-after="5mm">
                        Please email your remittance advice or any addressee change to:
                        <fo:inline font-weight="bold">
                            <xsl:value-of select="RCTI/Header/RemittanceEmail"/>
                        </fo:inline>
                    </fo:block>

                    <fo:block break-after="page"/>

                    <!-- Page 2: summary-page -->
                    <xsl:call-template name="summary-page"/>

                    <!-- Page 3: companies-page -->
                    <xsl:call-template name="companies-page"/>

                    <!-- Page 4: simulator-page -->
                    <xsl:call-template name="simulator-page"/>
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>


    <!-- ============ summary-page ============ -->
    <xsl:template name="summary-page">
        <fo:block font-size="14pt" font-weight="bold"
                  color="#2c3e50" space-after="5mm">
            <xsl:value-of select="RCTI/Header/Issuer/Name"/>
        </fo:block>
        <fo:block>ABN <xsl:value-of select="RCTI/Header/Issuer/ABN"/></fo:block>
        <fo:block>E <xsl:value-of select="RCTI/Header/Issuer/Email"/></fo:block>
        <fo:block space-after="10mm">
            <xsl:value-of select="RCTI/Header/Issuer/Address"/>
        </fo:block>

        <fo:block font-size="12pt" font-weight="bold"
                  space-after="5mm" border-bottom="1pt solid #cccccc">
            Summary of transactions served
        </fo:block>

        <fo:table table-layout="fixed" width="100%" font-size="10pt" space-after="10mm">
            <fo:table-column column-width="25%"/>
            <fo:table-column column-width="15%"/>
            <fo:table-column column-width="15%"/>
            <fo:table-column column-width="15%"/>
            <fo:table-column column-width="15%"/>
            <fo:table-column column-width="15%"/>
            <fo:table-header>
                <fo:table-row font-weight="bold" background-color="#f5f5f5">
                    <fo:table-cell padding="3mm" border="1pt solid #cccccc">
                        <fo:block/>
                    </fo:table-cell>
                    <fo:table-cell padding="3mm" border="1pt solid #cccccc" text-align="center">
                        <fo:block>April</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="3mm" border="1pt solid #cccccc" text-align="center">
                        <fo:block>May</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="3mm" border="1pt solid #cccccc" text-align="center">
                        <fo:block>June</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="3mm" border="1pt solid #cccccc" text-align="center">
                        <fo:block>Total</fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-header>
            <fo:table-body>
                <xsl:for-each select="RCTI/Summary/SummaryTable/Category">
                    <fo:table-row>
                        <fo:table-cell padding="3mm" border="1pt solid #cccccc">
                            <fo:block font-weight="bold">
                                <xsl:value-of select="@name"/>
                            </fo:block>
                        </fo:table-cell>
                        <xsl:for-each select="Month">
                            <fo:table-cell padding="3mm" border="1pt solid #cccccc" text-align="center">
                                <fo:block><xsl:value-of select="."/></fo:block>
                            </fo:table-cell>
                        </xsl:for-each>
                        <fo:table-cell padding="3mm" border="1pt solid #cccccc" text-align="center">
                            <fo:block><xsl:value-of select="Total"/></fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </xsl:for-each>
            </fo:table-body>
        </fo:table>

        <fo:block break-after="page"/>
    </xsl:template>


    <!-- ============ companies-page ============ -->
    <xsl:template name="companies-page">
        <fo:block font-size="14pt" font-weight="bold"
                  color="#2c3e50" space-after="5mm">
            <xsl:value-of select="RCTI/Header/Issuer/Name"/>
        </fo:block>
        <fo:block>ABN <xsl:value-of select="RCTI/Header/Issuer/ABN"/></fo:block>
        <fo:block>E <xsl:value-of select="RCTI/Header/Issuer/Email"/></fo:block>
        <fo:block space-after="10mm">
            <xsl:value-of select="RCTI/Header/Issuer/Address"/>
        </fo:block>

        <xsl:for-each select="RCTI/Companies/Company">
            <fo:block font-weight="bold" space-before="10mm">
                <xsl:value-of select="@name"/>
            </fo:block>

            <xsl:for-each select="Product">
                <fo:block font-weight="bold" space-after="2mm">
                    <xsl:value-of select="@id"/> – <xsl:value-of select="@name"/>
                </fo:block>
                <fo:block font-weight="bold" space-after="2mm">
                    <xsl:value-of select="concat(@id, ' 2024')"/>
                </fo:block>

                <fo:table table-layout="fixed" width="100%" font-size="10pt" space-after="5mm">
                    <fo:table-column column-width="25%"/>
                    <fo:table-column column-width="35%"/>
                    <fo:table-column column-width="20%"/>
                    <fo:table-column column-width="20%"/>
                    <fo:table-header>
                        <fo:table-row font-weight="bold" background-color="#f5f5f5">
                            <fo:table-cell padding="2mm" border="1pt solid #cccccc">
                                <fo:block>Product ID</fo:block>
                            </fo:table-cell>
                            <fo:table-cell padding="2mm" border="1pt solid #cccccc">
                                <fo:block>Description</fo:block>
                            </fo:table-cell>
                            <fo:table-cell padding="2mm" border="1pt solid #cccccc">
                                <fo:block>Quantity</fo:block>
                            </fo:table-cell>
                            <fo:table-cell padding="2mm" border="1pt solid #cccccc">
                                <fo:block>Network revenue</fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-header>
                    <fo:table-body>
                        <xsl:for-each select="Item">
                            <fo:table-row>
                                <fo:table-cell padding="2mm" border="1pt solid #eeeeee">
                                    <fo:block><xsl:value-of select="@code"/></fo:block>
                                </fo:table-cell>
                                <fo:table-cell padding="2mm" border="1pt solid #eeeeee">
                                    <fo:block><xsl:value-of select="@description"/></fo:block>
                                </fo:table-cell>
                                <fo:table-cell padding="2mm" border="1pt solid #eeeeee">
                                    <fo:block><xsl:value-of select="@quantity"/></fo:block>
                                </fo:table-cell>
                                <fo:table-cell padding="2mm" border="1pt solid #eeeeee">
                                    <fo:block>$<xsl:value-of select="@revenue"/></fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </xsl:for-each>
                    </fo:table-body>
                </fo:table>

                <fo:block font-weight="bold" space-after="5mm">
                    Total Transactions: <xsl:value-of select="../TotalTransactions"/>
                </fo:block>
            </xsl:for-each>
        </xsl:for-each>

        <fo:block break-after="page"/>
    </xsl:template>


    <!-- ============ simulator-page ============ -->
    <xsl:template name="simulator-page">
        <fo:block font-size="14pt" font-weight="bold"
                  color="#2c3e50" space-after="5mm">
            <xsl:value-of select="RCTI/Header/Issuer/Name"/>
        </fo:block>
        <fo:block>ABN <xsl:value-of select="RCTI/Header/Issuer/ABN"/></fo:block>
        <fo:block>E <xsl:value-of select="RCTI/Header/Issuer/Email"/></fo:block>
        <fo:block space-after="10mm">
            <xsl:value-of select="RCTI/Header/Issuer/Address"/>
        </fo:block>

        <fo:block font-size="12pt" font-weight="bold"
                  color="#2c3e50" space-after="5mm">
            ConnectID RP Simulator
        </fo:block>
        <fo:block font-weight="bold" space-after="5mm">
            <xsl:value-of select="RCTI/Simulator/Company"/>
        </fo:block>

        <xsl:for-each select="RCTI/Simulator/Month">
            <fo:block font-weight="bold" space-after="2mm">
                <xsl:value-of select="@name"/>
            </fo:block>
            <xsl:for-each select="Product">
                <fo:block font-weight="bold" space-after="2mm">
                    <xsl:value-of select="@id"/> – <xsl:value-of select="@name"/>
                </fo:block>
                <fo:table table-layout="fixed" width="100%" font-size="10pt" space-after="5mm">
                    <fo:table-column column-width="30%"/>
                    <fo:table-column column-width="40%"/>
                    <fo:table-column column-width="30%"/>
                    <fo:table-header>
                        <fo:table-row font-weight="bold" background-color="#f5f5f5">
                            <fo:table-cell padding="2mm" border="1pt solid #cccccc">
                                <fo:block>Product ID</fo:block>
                            </fo:table-cell>
                            <fo:table-cell padding="2mm" border="1pt solid #cccccc">
                                <fo:block>Description</fo:block>
                            </fo:table-cell>
                            <fo:table-cell padding="2mm" border="1pt solid #cccccc">
                                <fo:block>Quantity</fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-header>
                    <fo:table-body>
                        <xsl:for-each select="Item">
                            <fo:table-row>
                                <fo:table-cell padding="2mm" border="1pt solid #eeeeee">
                                    <fo:block><xsl:value-of select="@code"/></fo:block>
                                </fo:table-cell>
                                <fo:table-cell padding="2mm" border="1pt solid #eeeeee">
                                    <fo:block><xsl:value-of select="@description"/></fo:block>
                                </fo:table-cell>
                                <fo:table-cell padding="2mm" border="1pt solid #eeeeee">
                                    <fo:block><xsl:value-of select="@quantity"/></fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </xsl:for-each>
                    </fo:table-body>
                </fo:table>
            </xsl:for-each>
        </xsl:for-each>

        <fo:block font-weight="bold" space-before="5mm">
            Total Transactions: <xsl:value-of select="RCTI/Simulator/TotalTransactions"/>
        </fo:block>
    </xsl:template>

</xsl:stylesheet>
