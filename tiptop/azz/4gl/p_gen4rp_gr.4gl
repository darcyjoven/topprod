# Prog. Version..: '5.30.06-13.03.12(00002)'     #

#
# Pattern name...: p_gen4rp_gr.4gl
# Date & Author..: 12/06/29 By janet
# Descriptions...: 產生4rp樣板檔
# Modify.........: No.FUN-C60097 12/06/26 By janet 產生4rp
# Modify.........: No.EXT-D20130 13/02/22 By odyliao 字型預設為微軟正黑體

IMPORT os

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../4gl/p_gengr.global"

CONSTANT HGAP = "0.1"
CONSTANT VGAP = "0.05"
CONSTANT MAXLENGTH = "6.0"
CONSTANT CHARWIDTH = "0.2"

TYPE fldpos_t   RECORD
     fid        LIKE gaq_file.gaq01,
     hpos       LIKE type_file.num15_3,
     vpos       LIKE type_file.num15_3,
     len        LIKE type_file.num15_3,
     sformat    STRING
     END RECORD

DEFINE m_dst4rppath         STRING                                  #產生後的4rp檔路徑
DEFINE m_hgap               LIKE type_file.num15_3                  #欄位間距
DEFINE m_vgap               LIKE type_file.num15_3                  #行距
DEFINE m_maxlen             LIKE type_file.num15_3                  #欄位最大長度
DEFINE m_colidx2            DYNAMIC ARRAY OF LIKE type_file.num5    #單頭左邊(g_table2)的選取欄位與資料庫欄位的對應表
DEFINE m_colidx3            DYNAMIC ARRAY OF LIKE type_file.num5    #單頭右邊(g_table3)的選取欄位與資料庫欄位的對應表
DEFINE m_colidx4            DYNAMIC ARRAY OF LIKE type_file.num5    #單身第1行(g_table4)的選取欄位與資料庫欄位的對應表
DEFINE m_colidx5            DYNAMIC ARRAY OF LIKE type_file.num5    #單身第2行(g_table5)的選取欄位與資料庫欄位的對應表
DEFINE m_colidx6            DYNAMIC ARRAY OF LIKE type_file.num5    #單身第3行(g_table6)的選取欄位與資料庫欄位的對應表
DEFINE m_header_expected    STRING
DEFINE m_fldpos             DYNAMIC ARRAY OF fldpos_t
DEFINE m_paper_width        LIKE type_file.num15_3                  #紙張寬度
DEFINE m_paper_height       LIKE type_file.num15_3                  #紙張高度
DEFINE m_length_unit        LIKE type_file.chr1                     #紙張長度單位
DEFINE m_paper_rmargin      LIKE type_file.num15_3                  #紙張左邊界
DEFINE m_paper_lmargin      LIKE type_file.num15_3                  #紙張右邊界
DEFINE m_content_width      LIKE type_file.num15_3                  #紙張扣除左右邊界後的寬度
DEFINE m_doc                om.DomDocument
DEFINE m_doc_root           om.DomNode
DEFINE m_max_width          LIKE type_file.num15_3                  #紙張扣除左右邊界後的寬度

#產生4rp樣板檔 FUN-C60097
PUBLIC FUNCTION p_read4rp_gr()

    LET m_hgap = FGL_GETENV("HGAP")
    IF m_hgap IS NULL THEN
        LET m_hgap = HGAP
    END IF
    LET m_vgap = FGL_GETENV("VGAP")
    IF m_vgap IS NULL THEN
        LET m_vgap = VGAP
    END IF
    LET m_maxlen = FGL_GETENV("MAXLENGTH")
    IF m_maxlen IS NULL THEN
        LET m_maxlen = MAXLENGTH
    END IF

    #建立選取欄位與資料庫欄位的對應表
    CALL map_db_columns()

    IF g_sr.reporttype = "1" THEN
        #要放在create_voucher4rp()之前,create_voucher4rp()會用到此變數
        LET m_header_expected = "expectedBefore"

        #IF g_sr.sets = "N" THEN #非套表
            CALL create_voucher4rp()
        #ELSE    #套表
            #CALL create_vouchersets4rp()
        #END IF
    ELSE
        IF g_sr.reporttype MATCHES "[234]" THEN
            LET m_header_expected = "expectedHere"
            CALL create_detail4rp()
        END IF
    END IF
END FUNCTION

#建立基準的4rp
PRIVATE FUNCTION create_base4rp()
    DEFINE l_node_list  om.NodeList
    DEFINE l_cur_node   om.DomNode
    DEFINE l_width      STRING
    DEFINE l_length     STRING
    DEFINE l_tmp        STRING
    DEFINE l_str        STRING

    LET l_str = '<?xml version="1.0" encoding="UTF-8"?>',
                '<report:Report xmlns:rtl="http://www.4js.com/2004/RTL" xmlns:report="http://www.4js.com/2007/REPORT" xmlns="http://www.4js.com/2004/PXML" version="3.00">',
                '<report:Settings RWPageWidth="a4width" RWPageLength="a4length" RWLeftMargin="1.3cm" RWTopMargin="1.3cm" RWRightMargin="1.3cm" RWBottomMargin="1.3cm">',
                '<report:FormatList>',
                '<report:Format-SVG/>',
                '<report:Format-PDF/>',
                '<report:Format-image/>',
                '</report:FormatList>',
                '</report:Settings>',
                '<report:Data RWDataLocation="" RWFglReportName=""/>',
                '<rtl:stylesheet>',
                '<PXML name="Pxml1">',
                '<rtl:match nameConstraint="Report">',
                '</rtl:match>',
                '</PXML>',
                '</rtl:stylesheet>',
                '</report:Report>'
                
    LET m_doc = om.DomDocument.createFromString(l_str)
    LET m_doc_root = m_doc.getDocumentElement()
    LET m_max_width = 0

    LET m_dst4rppath = os.Path.join(FGL_GETENV(g_zz011),"4rp")
    LET m_dst4rppath = os.Path.join(m_dst4rppath,"src")
    LET m_dst4rppath = os.Path.join(m_dst4rppath,g_sr.prog||".4rp")

    #變更4rp版面設定
    LET l_node_list = m_doc_root.selectByTagName("report:Settings")
    IF l_node_list.getLength() >= 1 THEN
        LET l_cur_node = l_node_list.item(1)

        CASE
            #當紙張格式為s0或s1時,使用s0的寬與高
            WHEN g_sr.papersize = "s1" OR g_sr.papersize = "s0"
                CALL l_cur_node.removeAttribute("RWPageWidth")
                CALL l_cur_node.setAttribute("RWPageWidth","150cm")
                CALL l_cur_node.removeAttribute("RWPageLength")
                CALL l_cur_node.setAttribute("RWPageLength","84cm")
            #當紙張格式為x0時,使用x0的寬與高
            WHEN g_sr.papersize = "x0"
                CALL l_cur_node.removeAttribute("RWPageWidth")
                CALL l_cur_node.setAttribute("RWPageWidth","200cm")
                CALL l_cur_node.removeAttribute("RWPageLength")
                CALL l_cur_node.setAttribute("RWPageLength","84cm")
            #當紙張格式為x0時,使用x0的寬與高
            WHEN g_sr.papersize = "中一刀"
                CALL l_cur_node.removeAttribute("RWPageWidth")
                CALL l_cur_node.setAttribute("RWPageWidth","21.59cm")
                CALL l_cur_node.removeAttribute("RWPageLength")
                CALL l_cur_node.setAttribute("RWPageLength","13.97cm")
            #當紙張格式為x0時,使用x0的寬與高
            WHEN g_sr.papersize = "US Std Fanfold"
                CALL l_cur_node.removeAttribute("RWPageWidth")
                CALL l_cur_node.setAttribute("RWPageWidth","37.78cm")
                CALL l_cur_node.removeAttribute("RWPageLength")
                CALL l_cur_node.setAttribute("RWPageLength","27.94cm")
            OTHERWISE

                IF g_paper_ori = "L" THEN
                    LET l_width = DOWNSHIFT(g_sr.papersize),"length"
                    LET l_length = DOWNSHIFT(g_sr.papersize),"width"
                ELSE
                    LET l_width = DOWNSHIFT(g_sr.papersize),"width"
                    LET l_length = DOWNSHIFT(g_sr.papersize),"length"
                END IF
                CALL l_cur_node.removeAttribute("RWPageWidth")
                CALL l_cur_node.setAttribute("RWPageWidth",l_width)
                CALL l_cur_node.removeAttribute("RWPageLength")
                CALL l_cur_node.setAttribute("RWPageLength",l_length)
        END CASE

        #取得紙張左右邊界大小
        LET l_tmp = l_cur_node.getAttribute("RWLeftMargin")
        LET m_paper_lmargin = cl_gr_rm_unit(l_tmp)
        LET l_tmp = l_cur_node.getAttribute("RWRightMargin")
        LET m_paper_rmargin = cl_gr_rm_unit(l_tmp)

        #取得紙張寬度、高度、長度單位
        CALL cl_gr_get_paper_size(g_sr.papersize) RETURNING m_paper_width,m_paper_height,m_length_unit

        #取得紙張扣除左右邊界後的寬度
        LET m_content_width = m_paper_width - m_paper_lmargin - m_paper_rmargin
    END IF

    #變更4rp對應的rdd與report function
    LET l_node_list = m_doc_root.selectByTagName("report:Data")
    IF l_node_list.getLength() >= 1 THEN
        LET l_cur_node = l_node_list.item(1)
        CALL l_cur_node.removeAttribute("RWDataLocation")
        CALL l_cur_node.setAttribute("RWDataLocation",DOWNSHIFT(g_sr.prog)||".rdd")
        CALL l_cur_node.removeAttribute("RWFglReportName")
        CALL l_cur_node.setAttribute("RWFglReportName",DOWNSHIFT(g_sr.prog)||"_rep")
    END IF

    RETURN m_doc_root
END FUNCTION

#產生憑證類樣板
PRIVATE FUNCTION create_voucher4rp()
    DEFINE l_root       om.DomNode
    DEFINE l_list       om.NodeList
    DEFINE l_node1      om.DomNode
    DEFINE l_node2      om.DomNode
    DEFINE l_node3      om.DomNode
    DEFINE l_pageroot   om.DomNode
    DEFINE l_pageheader om.DomNode
    DEFINE l_everyrow   om.DomNode
    DEFINE l_ordcnt     LIKE type_file.num5
    DEFINE l_i          LIKE type_file.num5
    DEFINE l_j          LIKE type_file.num5
    DEFINE l_flag       LIKE type_file.num5

    #取得排序欄位個數
    LET l_ordcnt = g_ord.getLength()

    #建立基本報表樣板
    LET l_root = create_base4rp()

    #尋找報表根節點
    LET l_list = l_root.selectByTagName("rtl:match")
    FOR l_i = 1 TO l_list.getLength()
        LET l_node1 = l_list.item(l_i)

        #找到報表根節點
        IF l_node1.getAttribute("nameConstraint") = "Report" THEN
            #產生群組節點
            LET l_node2 = l_node1
            LET l_flag = FALSE
            IF l_ordcnt > 0 THEN
                FOR l_j = 1 TO l_ordcnt
                    IF NOT cl_null(g_ord[l_j].fid1) THEN
                        LET l_flag = TRUE
                        LET l_node3 = createGroup(l_node2)
                        IF l_j = 1 THEN
                            LET l_pageroot = createPageRoot(l_node3)
                            CALL createFooter(l_pageroot,"P")
                            LET l_pageheader = createPageHeader(l_pageroot)
                            LET l_node3 = l_pageroot
                        END IF
                        LET l_node2 = l_node3
                    END IF
                END FOR
            END IF

            IF NOT l_flag THEN
                LET l_pageroot = createPageRoot(l_node1)
                CALL createFooter(l_pageroot,"P")
                LET l_pageheader = createPageHeader(l_pageroot)
                LET l_node2 = l_pageroot
            END IF

            #在最下層的Group節點下加入OnEveryRow
            LET l_everyrow = l_node2.createChild("rtl:match")
            CALL l_everyrow.setAttribute("nameConstraint","OnEveryRow")
            CALL l_everyrow.setAttribute("minOccurs","0")
            CALL l_everyrow.setAttribute("maxOccurs","unbounded")

            #呼叫產生單身
            CALL createDetailArea(l_pageheader,l_everyrow)

            CALL createFooter(l_pageroot,"R")
            EXIT FOR
        END IF
    END FOR

    CALL l_root.writeXML(m_dst4rppath)
END FUNCTION

#產生憑證類套表樣板
PRIVATE FUNCTION create_vouchersets4rp()
    DEFINE l_root       om.DomNode
    DEFINE l_list       om.NodeList
    DEFINE l_node1      om.DomNode
    DEFINE l_node2      om.DomNode
    DEFINE l_everyrow   om.DomNode
    DEFINE l_pageroot   om.DomNode
    DEFINE l_i          LIKE type_file.num5

    #建立基本報表樣板
    LET l_root = create_base4rp()

    #尋找報表根節點
    LET l_list = l_root.selectByTagName("rtl:match")
    FOR l_i = 1 TO l_list.getLength()
        LET l_node1 = l_list.item(l_i)

        #找到報表根節點
        IF l_node1.getAttribute("nameConstraint") = "Report" THEN
            #在最下層的Group節點下加入OnEveryRow
            LET l_everyrow = l_node1.createChild("rtl:match")
            CALL l_everyrow.setAttribute("nameConstraint","OnEveryRow")
            CALL l_everyrow.setAttribute("minOccurs","0")
            CALL l_everyrow.setAttribute("maxOccurs","unbounded")

            LET l_pageroot = createPageRoot(l_everyrow)


        END IF
    END FOR

    CALL l_root.writeXML(m_dst4rppath)
END FUNCTION

#產生明細類樣板
PRIVATE FUNCTION create_detail4rp()
    DEFINE l_root       om.DomNode
    DEFINE l_list       om.NodeList
    DEFINE l_node1      om.DomNode
    DEFINE l_node2      om.DomNode
    DEFINE l_node3      om.DomNode
    DEFINE l_pageroot   om.DomNode
    DEFINE l_pageheader om.DomNode
    DEFINE l_everyrow   om.DomNode
    DEFINE l_ordcnt     LIKE type_file.num5
    DEFINE l_i          LIKE type_file.num5
    DEFINE l_j          LIKE type_file.num5
    DEFINE l_k          LIKE type_file.num5
    DEFINE l_gidx       LIKE type_file.num5
    DEFINE l_groups     DYNAMIC ARRAY OF om.DomNode
    DEFINE l_gidxes     DYNAMIC ARRAY OF LIKE type_file.num10
    DEFINE l_fldname    STRING
    DEFINE l_varname    STRING
    DEFINE l_lbllen     LIKE type_file.num15_3

    #取得排序欄位個數
    LET l_ordcnt = g_ord.getLength()

    #建立基本報表樣板
    LET l_root = create_base4rp()

    #尋找報表根節點
    LET l_list = l_root.selectByTagName("rtl:match")
    FOR l_i = 1 TO l_list.getLength()
        LET l_node1 = l_list.item(l_i)

        #找到報表根節點
        IF l_node1.getAttribute("nameConstraint") = "Report" THEN
            LET l_pageroot = createPageRoot(l_node1)
            CALL createFooter(l_pageroot,"P")
            LET l_pageheader = createPageHeader(l_pageroot)
            #產生群組節點
            LET l_node1 = l_pageroot
            IF l_ordcnt > 0 THEN
                LET l_k = 1
                FOR l_j = 1 TO l_ordcnt
                    IF NOT cl_null(g_ord[l_j].fid1) THEN
                        LET l_node2 = createGroup(l_node1)
                        LET l_groups[l_k] = l_node2
                        LET l_gidxes[l_k] = l_j
                        LET l_k = l_k + 1
                        LET l_node1 = l_node2
                    END IF
                END FOR
            END IF

            #在最下層的Group節點下加入OnEveryRow
            LET l_everyrow = l_node1.createChild("rtl:match")
            CALL l_everyrow.setAttribute("nameConstraint","OnEveryRow")
            CALL l_everyrow.setAttribute("minOccurs","0")
            CALL l_everyrow.setAttribute("maxOccurs","unbounded")

            #呼叫產生單身
            CALL createDetailArea(l_pageheader,l_everyrow)

            #加入合計欄位和跳頁
            FOR l_i = 1 TO l_groups.getLength()
                LET l_node1 = l_groups[l_i]
                LET l_gidx = l_gidxes[l_i]
                LET l_node2 = createStripe(l_node1,"GroupFooter_"||g_ord[l_gidx].fid1)  
                FOR l_j = 1 TO g_comp.getLength()
                    #IF g_comp[l_j].gfid2 = g_ord[l_i].fid1 AND g_comp[l_j].disp2 != "3" THEN
                    IF g_comp[l_j].disp2 != "3" THEN
                        #顯示合計欄位名稱
                        LET l_varname = g_aggr_vars[l_j].g_var_name.trim()
                        IF g_comp[l_j].disp2 = "1" THEN #多顯示名稱
                            LET l_lbllen = 0
                            LET l_lbllen = get_lbllen(g_ord[l_i].fname1)
                            LET l_node3 = createLabel(l_node2,l_varname||"_Label",g_ord[l_i].fname1,NULL,NULL,l_lbllen||"cm")
                            #CALL l_node3.setAttribute("fontName","SimHei")
                            CALL l_node3.setAttribute("fontName",g_sr.fontname) #EXT-D20130
                        END IF                        
                        LET l_fldname = l_varname,"_Value"
                        LET l_node3 = createVar(l_node2,l_varname,"FGLNumeric","expectedAhead")
                        FOR l_k = 1 TO m_fldpos.getLength()
                            IF g_comp[l_j].fid2 = m_fldpos[l_k].fid THEN
                                LET l_node3 = createDecBox(l_node2,l_fldname,"{{"||l_varname||"}}",m_fldpos[l_k].sformat,NULL,NULL,m_fldpos[l_k].len||"cm")
                                #CALL l_node3.setAttribute("fontName","SimHei")
                                CALL l_node3.setAttribute("fontName",g_sr.fontname) #EXT-D20130
                                EXIT FOR
                            END IF
                        END FOR
                    END IF
                END FOR

                #非動態排序按排序頁設定
                IF g_sr.reporttype MATCHES "[234]" AND g_ord[l_gidx].nextpage1 = "Y" THEN
                    LET l_node2 = createPageBreak(l_node1,"skip_"||g_ord[l_gidx].fid1)
                END IF
            END FOR

            #加入總計欄位
            LET l_node1 = createStripe(l_pageroot,"Footers") #對應on last row
            FOR l_j = 1 TO g_comp.getLength()
                IF g_comp[l_j].aggr2 MATCHES "[CF]" AND g_comp[l_j].disp2 != "3" THEN
                    #顯示合計欄位名稱
                    LET l_varname = g_aggr_vars[l_j].t_var_name.trim()
                    IF g_comp[l_j].disp2 = "1" THEN
                        LET l_lbllen = 0
                        LET l_lbllen = get_lbllen(g_ord[l_i].fname1)
                        LET l_node2 = createLabel(l_node1,l_varname||"_Label",g_ord[l_i].fname1,NULL,NULL,l_lbllen||"cm")
                        #CALL l_node2.setAttribute("fontName","SimHei")
                        CALL l_node2.setAttribute("fontName",g_sr.fontname) #EXT-D20130
                    END IF
                    LET l_fldname = l_varname,"_Value"
                    LET l_node2 = createVar(l_node1,l_varname,"FGLNumeric","expectedAhead")
                    FOR l_k = 1 TO m_fldpos.getLength()
                        IF g_comp[l_j].fid2 = m_fldpos[l_k].fid THEN
                            LET l_node2 = createDecBox(l_node1,l_fldname,"{{"||l_varname||"}}",m_fldpos[l_k].sformat,NULL,NULL,m_fldpos[l_k].len||"cm")
                            #CALL l_node2.setAttribute("fontName","SimHei")
                            CALL l_node2.setAttribute("fontName",g_sr.fontname) #EXT-D20130
                            EXIT FOR
                        END IF
                    END FOR
                END IF
            END FOR

            CALL createFooter(l_pageroot,"R")
            EXIT FOR
        END IF
    END FOR

    CALL l_root.writeXML(m_dst4rppath)
END FUNCTION

#建立選取欄位與資料庫欄位的對應表
PRIVATE FUNCTION map_db_columns()
    DEFINE l_i          LIKE type_file.num5
    DEFINE l_j          LIKE type_file.num5
    DEFINE l_cname      STRING

    FOR l_i = 1 TO g_flddef.getLength()
        LET l_cname = get_fid(g_flddef[l_i].recno,g_flddef[l_i].field_name)

        FOR l_j = 1 TO g_table2.getLength()
            IF l_cname = g_table2[l_j].fldid THEN
                LET m_colidx2[l_j] = l_i
            END IF
        END FOR

        FOR l_j = 1 TO g_table3.getLength()
            IF l_cname = g_table3[l_j].fldid THEN
                LET m_colidx3[l_j] = l_i
            END IF
        END FOR

        FOR l_j = 1 TO g_table4.getLength()
            IF l_cname = g_table4[l_j].fldid THEN
                LET m_colidx4[l_j] = l_i
            END IF
        END FOR

        FOR l_j = 1 TO g_table5.getLength()
            IF l_cname = g_table5[l_j].fldid THEN
                LET m_colidx5[l_j] = l_i
            END IF
        END FOR

        FOR l_j = 1 TO g_table6.getLength()
            IF l_cname = g_table6[l_j].fldid THEN
                LET m_colidx6[l_j] = l_i
            END IF
        END FOR
    END FOR
END FUNCTION

PRIVATE FUNCTION createPageRoot(p_node)
    DEFINE p_node     om.DomNode
    DEFINE l_node     om.DomNode

    LET l_node = p_node.createChild("MINIPAGE")
    CALL l_node.setAttribute("name","Page Root")
    CALL l_node.setAttribute("width","max" )
    CALL l_node.setAttribute("length","max" )
    CALL l_node.setAttribute("hidePageFooterOnLastPage","true")
    RETURN l_node
END FUNCTION

PRIVATE FUNCTION createPageHeader(p_node)
    DEFINE p_node       om.DomNode
    DEFINE l_node       om.DomNode
    DEFINE l_node1      om.DomNode
    DEFINE l_node2      om.DomNode
    DEFINE l_vpos       LIKE type_file.num15_3
    DEFINE l_img_width  LIKE type_file.num5
    #DEFINE l_tmp_hpos   LIKE type_file.num15_3

    CALL cl_gre_init_pageheader()
    LET l_node = createLayoutNode(p_node,"PageHeaderGroups")
    CALL l_node.setAttribute("port","anyPageHeader")

    #PageHeader1
    #LET l_node1 = createStripe(l_node,"PageHeader1") # FUN-C40064 mrak
    LET l_node1 = createStripe(l_node,"PageHeader01") # FUN-C40064 add
    LET g_grPageHeader.title2 = cl_get_progdesc(g_sr.prog,g_rlang)
    LET l_node2 = createVar(l_node1,"g_grPageHeader.title1","FGLString",m_header_expected)
    LET l_node2 = createTitle(l_node1,"title1_Value","{{g_grPageHeader.title1}}","0.3cm","14")
    #CALL setFont(l_node2,"標楷體",NULL)  #FUN-C40064 mark
    #CALL setFont(l_node2,"SimHei",NULL)    # FUN-C40064 add
    CALL setFont(l_node2,g_sr.fontname,NULL)    #EXT-D20130
    LET l_node2 = createVar(l_node1,"g_grPageHeader.title2","FGLString",m_header_expected)
    #LET l_node2 = createTitle(l_node1,"title2_Value","{{g_grPageHeader.title2}}","1.3cm","14")  #FUN-C40064 mark
    LET l_node2 = createTitle(l_node1,"title2_Value","{{g_grPageHeader.title2}}","1.3cm","12")   #FUN-C40064 add  "12":字型大小
    #CALL setFont(l_node2,"微軟正黑體",NULL)  #FUN-C40064 mark
     #CALL setFont(l_node2,"SimHei",NULL)    # FUN-C40064 add
     CALL setFont(l_node2,g_sr.fontname,NULL)  #EXT-D20130
    #ImageBox
    LET l_img_width = 100
    LET l_node2 = createVar(l_node1,"g_grPageHeader.logo","FGLString",m_header_expected)
    #LET l_node2 = createImgBox(l_node1,"logo_Value","1cm","max-"||l_img_width,l_img_width,42,"{{g_grPageHeader.logo}}") #FUN-C40064 mark
    LET l_node2 = createImgBox(l_node1,"logo_Value","0.300cm","0.000cm",NULL,NULL,"{{g_grPageHeader.logo}}") #FUN-C40064 ADD

    #憑證類報表須顯示公司資訊
    IF g_sr.reporttype = 1 THEN
       # LET l_vpos = 1.5  #FUN-C40064 mark
        LET l_vpos = 2.0  #FUN-C40064 add
        #LET l_node2 = createLabel(l_node1,"CoAdr_Label","Company Address:",l_vpos||"cm","0cm","1.35cm")   #FUN-C60077 y屬性從0改為0cm
        #CALL setFont(l_node2,"SimHei",7.5)  #setFont([欄位節點],[字型名稱字串],[字型大小]) [字型大小] #FUN-C40064 mark
        #CALL setFont(l_node2,"SimHei",9)   #FUN-C40064 add
        #LET l_node2 = createVar(l_node1,"g_grPageHeader.co_adr","FGLString",m_header_expected)
        #LET l_node2 = createWordBox(l_node1,"CoAdr_Value","{{g_grPageHeader.co_adr}}",l_vpos||"cm","1.5cm","6cm")
        #CALL setFont(l_node2,"SimHei",7.5) #FUN-C40064 mark 
        #CALL setFont(l_node2,"SimHei",9)   #FUN-C40064 add
        #
        #LET l_vpos = 2.5  #FUN-C40064 mark    
        #LET l_vpos = 2.45  #FUN-C40064 add
        #LET l_node2 = createLabel(l_node1,"CoTel_Label","Company Tel:",l_vpos||"cm","0cm","1.35cm")      #FUN-C60077 y屬性從0改為0cm
        #CALL setFont(l_node2,"SimHei",7.5)   #FUN-C40064 mark 
        #CALL setFont(l_node2,"SimHei",9)   #FUN-C40064 add
        #LET l_node2 = createVar(l_node1,"g_grPageHeader.co_tel","FGLString",m_header_expected)
        #LET l_node2 = createWordBox(l_node1,"CoTel_Value","{{g_grPageHeader.co_tel}}",l_vpos||"cm","1.5cm","3cm")
        #CALL setFont(l_node2,"SimHei",7.5)  #FUN-C40064 mark 
        #CALL setFont(l_node2,"SimHei",9)   #FUN-C40064 add
        #
        #LET l_vpos = 3   #FUN-C40064 mark     
        #LET l_vpos = 2.9  #FUN-C40064 add
        #LET l_node2 = createLabel(l_node1,"CoFax_Label","Company Fax:",l_vpos||"cm","0cm","1.35cm")      #FUN-C60077 y屬性從0改為0cm
       # CALL setFont(l_node2,"SimHei",7.5)  #FUN-C40064 mark
        #CALL setFont(l_node2,"SimHei",9)  #FUN-C40064 add
        #LET l_node2 = createVar(l_node1,"g_grPageHeader.co_fax","FGLString",m_header_expected)
        #LET l_node2 = createWordBox(l_node1,"CoFax_Value","{{g_grPageHeader.co_fax}}",l_vpos||"cm","1.5cm","3cm")
        #CALL setFont(l_node2,"SimHei",7.5)  #FUN-C40064 mark
        #CALL setFont(l_node2,"SimHei",9)  #FUN-C40064 add
    END IF

    #PageHeader2
    #LET l_node1 = createStripe(l_node,"PageHeader2")#FUN-C40064 MARK    
    LET l_node1 = createStripe(l_node,"PageHeader02") #FUN-C40064 ADD
   # CALL l_node1.setAttribute("borderBottomWidth","1")   #FUN-C40064 MARK
    CALL l_node1.setAttribute("borderBottomWidth","1.5")  #FUN-C40064 ADD
    CALL l_node1.setAttribute("borderBottomStyle","solid")
    CALL l_node1.setAttribute("marginTopWidth","0.3cm")

    #製表日期
    LET l_node2 = createLabel(l_node1,"RDate_Label","Date Printed:",NULL,"0cm","1.5cm")   #FUN-C60077 y屬性從0改為0cm
    #CALL setFont(l_node2,"SimHei",NULL)
    CALL setFont(l_node2,g_sr.fontname,NULL) #EXT-D20130
    LET l_node2 = createVar(l_node1,"g_pdate","FGLString",m_header_expected)
    LET l_node2 = createVar(l_node1,"g_ptime","FGLString",m_header_expected)  #FUN-C40064 ADD
    #LET l_node2 = createWordBox(l_node1,"RDate_Value","{{g_pdate}}",NULL,"1.5cm","6cm") #FUN-C40064 MARK
    #LET l_node2 = createWordBox(l_node1,"RDate_Value","{{g_pdate+&quot; &quot;+g_ptime}}",NULL,"1.5cm","6cm")  #FUN-C40064 ADD 製表日期改為g_pdate+" "+g_ptime #FUN-C40064 mark
    LET l_node2 = createWordBox(l_node1,"RDate_Value","{{g_pdate+\" \"+g_ptime}}",NULL,"1.5cm","6cm")  #FUN-C40064 ADD 製表日期改為g_pdate+" "+g_ptime #FUN-C40064 mark
    
    #CALL setFont(l_node2,"SimHei",NULL)
    CALL setFont(l_node2,g_sr.fontname,NULL) #EXT-D20130

    #計算製表者欄位定位點
    #LET l_tmp_hpos = m_content_width - 6
    #LET l_node2 = createLabel(l_node1,"Reporter_Label","Reporter:",NULL,"max-7.1cm","1.7cm") #FUN-C40064 MARK
    LET l_node2 = createLabel(l_node1,"Reporter_Label","Reporter:",NULL,"max-5.45cm","1.5cm")  #FUN-C40064 ADD
    #CALL setFont(l_node2,"SimHei",NULL)
    CALL setFont(l_node2,g_sr.fontname,NULL) #EXT-D20130
   # LET l_node2 = createVar(l_node1,"g_user","FGLString",m_header_expected) #FUN-C40064 MARK
    LET l_node2 = createVar(l_node1,"g_user_name","FGLString",m_header_expected)  #FUN-C40064 ADD
    #LET l_tmp_hpos = m_content_width - 4.5
    #LET l_node2 = createWordBox(l_node1,"Reporter_Value","{{g_user}}",NULL,"max-5.3cm","1.7cm")  #FUN-C40064 MARK
    LET l_node2 = createWordBox(l_node1,"Reporter_Value","{{g_user_name}}",NULL,"max-4.25cm","1.5cm")  #FUN-C40064 ADD
    #CALL setFont(l_node2,"SimHei",NULL)
    CALL setFont(l_node2,g_sr.fontname,NULL) #EXT-D20130

    #頁次
    #LET l_tmp_hpos = m_content_width - 3
    #LET l_node2 = createLabel(l_node1,"PageNo_Label","PageNo",NULL,"max-3.5cm","1.7cm") #FUN-C40064 MARK
    LET l_node2 = createLabel(l_node1,"PageNo_Label","PageNo",NULL,"max-2cm","0.85cm")  #FUN-C40064 ADD
    #CALL setFont(l_node2,"SimHei",NULL)
    CALL setFont(l_node2,g_sr.fontname,NULL) #EXT-D20130
    #PageBox
    #LET l_tmp_hpos = m_content_width - 1.5
    #LET l_node2 = createPageNoBox(l_node1,"PageNo_Value",NULL,l_tmp_hpos||"cm")
    LET l_node2 = createPageNoBox(l_node1,"PageNo_Value")

    IF g_table2.getLength() > 0 OR g_table3.getLength() > 0 THEN
        #加入單頭與分隔線
        LET l_node1 = createLayoutNode(l_node,"Masters")

        CALL createMaster(l_node1,g_table2,g_table3,m_colidx2,m_colidx3)
    END IF
    RETURN l_node
END FUNCTION

#產生單頭區段
PRIVATE FUNCTION createMaster(p_node,p_ltable,p_rtable,p_lcolidx,p_rcolidx)
    DEFINE p_node       om.DomNode
    DEFINE p_ltable     DYNAMIC ARRAY OF field_t
    DEFINE p_rtable     DYNAMIC ARRAY OF field_t
    DEFINE p_lcolidx    DYNAMIC ARRAY OF LIKE type_file.num5
    DEFINE p_rcolidx    DYNAMIC ARRAY OF LIKE type_file.num5
    DEFINE l_i          LIKE type_file.num5
    DEFINE l_lblname    STRING
    DEFINE l_label      STRING
    DEFINE l_valname    STRING
    DEFINE l_value      STRING
    DEFINE l_text       STRING
    DEFINE l_stripe     om.DomNode
    DEFINE l_node       om.DomNode
    DEFINE l_type       STRING
    DEFINE l_format     STRING
    DEFINE l_lbllen     LIKE type_file.num15_3
    DEFINE l_fldlen     LIKE type_file.num15_3
    DEFINE l_rmaxlen    LIKE type_file.num15_3
    DEFINE l_lmaxlen    LIKE type_file.num15_3
    DEFINE l_hpos       LIKE type_file.num15_3
    DEFINE l_index      LIKE type_file.num5
    DEFINE l_pos        STRING
    DEFINE li_pos       LIKE type_file.num15_3

    LET l_lmaxlen = 0
    FOR l_i = 1 TO p_ltable.getLength()
        LET l_lbllen = FGL_WIDTH(p_ltable[l_i].fldid) * CHARWIDTH
        IF l_lmaxlen < l_lbllen THEN
            LET l_lmaxlen = l_lbllen
        END IF
    END FOR

    IF l_lmaxlen > MAXLENGTH/2 THEN
        LET l_lmaxlen = MAXLENGTH/2
    END IF


    #設定單頭左區塊
    FOR l_i = 1 TO p_ltable.getLength()
        LET l_stripe = createStripe(p_node,l_i USING "Master&&")
        LET l_index =  p_lcolidx[l_i]
        CALL get_fldattr(g_flddef[l_index].datatype,g_flddef[l_index].length)
            RETURNING l_fldlen,l_type,l_format
        LET l_label = p_ltable[l_i].fldid
        LET l_lblname = l_label,"_Label"
        LET l_value = p_ltable[l_i].fldid
        LET l_valname = l_label,"_Value"
        LET l_text = "{{"||p_ltable[l_i].fldid||"}}"

        LET l_lbllen = l_lmaxlen
        LET l_hpos = 0

        LET l_node = createLabel(l_stripe,l_lblname,l_label,null,"0cm",l_lbllen||"cm")
        CALL l_node.setAttribute("fontBold","true")
        CALL l_node.setAttribute("fontName","微軟正黑體")

        LET l_node = createVar(l_stripe,l_value,l_type,"expectedAhead")
        LET l_hpos = l_lbllen + m_hgap

        IF l_fldlen > MAXLENGTH THEN
            LET l_fldlen = MAXLENGTH
        END IF
        IF l_type = "FGLNumeric" THEN
            LET l_node = createDecBox(l_stripe,l_valname,l_text,l_format,NULL,l_hpos||"cm",l_fldlen||"cm")
        ELSE
            LET l_node = createWordBox(l_stripe,l_valname,l_text,NULL,l_hpos||"cm",l_fldlen||"cm")
        END IF
        CALL l_node.setAttribute("fontName","微軟正黑體")
    END FOR

    LET l_rmaxlen = 0
    FOR l_i = 1 TO p_rtable.getLength()
        LET l_lbllen = FGL_WIDTH(p_rtable[l_i].fldid) * CHARWIDTH
        IF l_rmaxlen < l_lbllen THEN
            LET l_rmaxlen = l_lbllen
        END IF
    END FOR

    IF l_rmaxlen > MAXLENGTH/2 THEN
        LET l_rmaxlen = MAXLENGTH/2
    END IF

    #設定單頭右區塊
    FOR l_i = 1 TO p_rtable.getLength()
        IF l_i > p_ltable.getLength() THEN
            LET l_stripe = createStripe(p_node,l_i USING "Master&&")
        ELSE
            LET l_stripe = p_node.getChildByIndex(l_i)
        END IF

        LET l_index =  p_rcolidx[l_i]
        CALL get_fldattr(g_flddef[l_index].datatype,g_flddef[l_index].length)
            RETURNING l_fldlen,l_type,l_format
        LET l_label = p_rtable[l_i].fldid
        LET l_lblname = l_label,"_Label"
        LET l_value = p_rtable[l_i].fldid
        LET l_valname = l_label,"_Value"
        LET l_text = "{{"||p_rtable[l_i].fldid||"}}"

        LET l_lbllen = l_rmaxlen
        LET l_hpos = 0
        LET li_pos = m_content_width/2 + l_hpos
        #LET l_pos = li_pos||"cm"
        LET l_pos = "max/2"
        LET l_node = createLabel(l_stripe,l_lblname,l_label,null,l_pos,l_lbllen||"cm")
        CALL l_node.setAttribute("fontBold","true")
        CALL l_node.setAttribute("fontName","微軟正黑體")

        LET l_node = createVar(l_stripe,l_value,l_type,"expectedAhead")
        LET l_hpos = l_lbllen + m_hgap

        LET li_pos = m_content_width/2 + l_hpos
        LET l_pos = li_pos||"cm"
        LET l_pos = "max/2+"||l_hpos||"cm"

        IF l_fldlen > MAXLENGTH THEN
            LET l_fldlen = MAXLENGTH
        END IF
        IF l_type = "FGLNumeric" THEN
            LET l_node = createDecBox(l_stripe,l_valname,l_text,l_format,NULL,l_pos,l_fldlen||"cm")
        ELSE
            LET l_node = createWordBox(l_stripe,l_valname,l_text,NULL,l_pos,l_fldlen||"cm")
        END IF
        CALL l_node.setAttribute("fontName","微軟正黑體")
    END FOR
END FUNCTION

#建立單身區域
PRIVATE FUNCTION createDetailArea(p_pageheader,p_everyrow)
    DEFINE p_pageheader om.DomNode
    DEFINE p_everyrow   om.DomNode
    DEFINE l_dhs        om.DomNode
    DEFINE l_dh1        om.DomNode
    DEFINE l_dh2        om.DomNode
    DEFINE l_dh3        om.DomNode
    DEFINE l_details    om.DomNode
    DEFINE l_detail1    om.DomNode
    DEFINE l_detail2    om.DomNode
    DEFINE l_detail3    om.DomNode
    DEFINE l_var_node   om.DomNode
    DEFINE l_dh_last    STRING        #FUN-C60077 紀錄最後一行DetailHeader

    #加入單身欄位說明區段
    LET l_dhs = createLayoutNode(p_pageheader,"DetailHeaders")
    #CALL l_dh.setAttribute("color","#ffffff")
    #CALL l_dh.setAttribute("bgColor","#f5a940")
    #CALL l_dhs.setAttribute("borderTopWidth","0.5")       #FUN-C40064 mark
    CALL l_dhs.setAttribute("borderTopWidth","1.5")        #FUN-C40064 ADD
    CALL l_dhs.setAttribute("borderTopStyle","solid")
    #CALL l_dhs.setAttribute("borderBottomWidth","1")      #FUN-C60077 mark
    #CALL l_dhs.setAttribute("borderBottomStyle","solid")  #FUN-C60077 mark

    #加入單身區段
    LET l_var_node = createVar(p_everyrow,"l_lineno","FGLNumeric","expectedHere")
    LET l_details = createLayoutNode(p_everyrow,"Details")
    #CALL l_details.setAttribute("borderBottomWidth","1")   #FUN-C40064 mark
    #CALL l_details.setAttribute("borderBottomStyle","solid")  #FUN-C40064 mark
    CALL l_details.setAttribute("bgColor","{{l_lineno%2==1?Color.WHITE:Color.LIGHT_GRAY}}")

    LET l_dh_last = ""                                      #FUN-C60077 add

    IF g_table4.getLength() > 0 THEN
        #LET l_dh1 = createStripe(l_dhs,"DetailHeader1")    #FUN-C40064 mark
        #LET l_detail1 = createStripe(l_details,"Detail1")  #FUN-C40064 mark
        LET l_dh1 = createStripe(l_dhs,"DetailHeader01")    #FUN-C40064 add
        LET l_detail1 = createStripe(l_details,"Detail01")  #FUN-C40064 add
    END IF

    IF g_table5.getLength() > 0 THEN
        LET l_dh2 = createStripe(l_dhs,"DetailHeaderi02")   #FUN-C60077 
        LET l_detail2 = createStripe(l_details,"Detail02")  #FUN-C60077
    END IF

    IF g_table6.getLength() > 0 THEN
        LET l_dh3 = createStripe(l_dhs,"DetailHeader03")    #FUN-C60077
        LET l_detail3 = createStripe(l_details,"Detail03")  #FUN-C60077
    END IF

    CALL createDetailPart(l_dh1,l_detail1,g_table4,m_colidx4,"01")   #FUN-C60077 add "01" 
    CALL createDetailPart(l_dh2,l_detail2,g_table5,m_colidx5,"02")   #FUN-C60077 add "02"
    CALL createDetailPart(l_dh3,l_detail3,g_table6,m_colidx6,"03")   #FUN-C60077 add "03"

    #CALL calc_paper_width()
END FUNCTION

PRIVATE FUNCTION calc_paper_width()
    DEFINE l_gdo02      LIKE gdo_file.gdo02
    DEFINE l_gdo03      LIKE gdo_file.gdo03
    DEFINE l_gdo04      LIKE gdo_file.gdo04
    DEFINE l_cur_node   om.DomNode
    DEFINE l_node_list  om.NodeList
    DEFINE l_src_width  STRING
    DEFINE l_src_length STRING
    DEFINE l_dst_width  STRING
    DEFINE l_dst_length STRING

    IF m_max_width > m_content_width THEN
        LET l_node_list = m_doc_root.selectByTagName("report:Settings")
        IF l_node_list.getLength() >= 1 THEN
            LET l_cur_node = l_node_list.item(1)
            LET l_src_width = l_cur_node.getAttribute("RWPageWidth")
            LET l_src_length = l_cur_node.getAttribute("RWPageLength")
            
            IF l_src_width.getIndexOf("width",1) >= 1 THEN
                LET l_dst_width = "width"
            ELSE
                IF l_src_width.getIndexOf("length",1) >= 1 THEN
                    LET l_dst_width = "length"
                END IF
            END IF
            IF l_src_length.getIndexOf("width",1) >= 1 THEN
                LET l_dst_length = "width"
            ELSE
                IF l_src_length.getIndexOf("length",1) >= 1 THEN
                    LET l_dst_length = "length"
                END IF
            END IF
        END IF

        SELECT gdo02,gdo03,gdo04 INTO l_gdo02,l_gdo03,l_gdo04
        FROM gdo_file WHERE gdo03=(SELECT MIN(gdo03)
        FROM gdo_file WHERE gdo03 >= m_max_width)
        IF l_gdo03 > 0 THEN
            CALL l_cur_node.removeAttribute("RWPageWidth")
            CALL l_cur_node.removeAttribute("RWPageLength")
            IF l_gdo02 = "s0" OR l_gdo02 = "s1" OR l_gdo02 = "x0" THEN
                CALL l_cur_node.setAttribute("RWPageWidth",l_gdo03||"cm")
                CALL l_cur_node.setAttribute("RWPageLength",l_gdo04||"cm")
            ELSE
                LET l_dst_width = downshift(l_gdo02)||l_dst_width
                LET l_dst_length = downshift(l_gdo02)||l_dst_length
                CALL l_cur_node.setAttribute("RWPageWidth",l_dst_width)
                CALL l_cur_node.setAttribute("RWPageLength",l_dst_length)
            END IF
        END IF
    END IF
END FUNCTION



#建立單身部分
PRIVATE FUNCTION createDetailPart(p_dh,p_detail,p_table,p_colidx,p_dh_last)
    DEFINE p_dh         om.DomNode
    DEFINE p_detail     om.DomNode
    DEFINE p_table      DYNAMIC ARRAY OF field_t
    DEFINE p_colidx     DYNAMIC ARRAY OF LIKE type_file.num5
    DEFINE p_dh_last    STRING   #FUN-C60077 紀錄最後一行DetailHeader流水編號
    DEFINE l_i          LIKE type_file.num5
    DEFINE l_lblname    STRING
    DEFINE l_label      STRING
    DEFINE l_valname    STRING
    DEFINE l_value      STRING
    DEFINE l_text       STRING
    DEFINE l_node       om.DomNode
    DEFINE l_type       STRING
    DEFINE l_fldlen     LIKE type_file.num15_3
    DEFINE l_lbllen     LIKE type_file.num15_3
    DEFINE l_vpos       LIKE type_file.num15_3
    DEFINE l_hpos       LIKE type_file.num15_3
    DEFINE l_index      LIKE type_file.num5
    DEFINE l_format     STRING
    DEFINE l_fldpos     fldpos_t
    DEFINE l_width      LIKE type_file.num15_3  #Detail各欄位合計寬度

    LET l_width = 0
    LET l_vpos = 0
    LET l_hpos = 0
    FOR l_i = 1 TO p_table.getLength()
        LET l_index =  p_colidx[l_i]
        LET l_label = p_table[l_i].fldid
        LET l_lblname = l_label,"_Label"
        LET l_value = p_table[l_i].fldid
        LET l_valname = l_label,"_Value"
        LET l_text = "{{",l_value,"}}"

        CALL get_fldattr(g_flddef[l_index].datatype,g_flddef[l_index].length)
            RETURNING l_fldlen,l_type,l_format

        LET l_lbllen = FGL_WIDTH(l_label) * CHARWIDTH
        IF l_lbllen > l_fldlen THEN
            LET l_fldlen = l_lbllen
        END IF
        IF l_fldlen > MAXLENGTH THEN
            LET l_fldlen = MAXLENGTH
        END IF

        #產生欄位說明
        LET l_node = createLabel(p_dh,l_lblname,l_label,NULL,NULL,l_fldlen||"cm")
        CALL l_node.setAttribute("marginRightWidth",HGAP||"cm")
        IF l_type = "FGLNumeric" THEN
            CALL l_node.setAttribute("textAlignment","right")
        ELSE
            CALL l_node.setAttribute("textAlignment","left")
        END IF
        #CALL l_node.setAttribute("fontName","SimHei")
        CALL l_node.setAttribute("fontName",g_sr.fontname) #EXT-D20130

        #產生欄位底線 FUN-C60077  --START--
        IF (g_table6.getLength() > 0 AND p_dh_last = "03") THEN
            CALL l_node.setAttribute("borderBottomWidth","1")
            CALL l_node.setAttribute("borderBottomStyle","solid")    
        END IF
 
        IF NOT (g_table6.getLength() > 0) THEN
            IF (g_table5.getLength() > 0 AND p_dh_last = "02") THEN
                CALL l_node.setAttribute("borderBottomWidth","1")
                CALL l_node.setAttribute("borderBottomStyle","solid")
            END IF

            IF NOT (g_table5.getLength() > 0) THEN
               IF p_dh_last = "01" THEN
                  CALL l_node.setAttribute("borderBottomWidth","1")
                  CALL l_node.setAttribute("borderBottomStyle","solid")
               END IF
            END IF
        END IF        
        #產生欄位底線 FUN-C60077  ---END---
        


        #將欄位說明的寬度與右邊界加入細目寬度
        LET l_width = l_width + l_fldlen + HGAP

        #產生4rp變數
        LET l_node = createVar(p_detail,l_value,l_type,"expectedHere")

        #產生欄位
        CASE l_type
            WHEN "FGLNumeric"
                LET l_node = createDecBox(p_detail,l_valname,l_text,l_format,NULL,NULL,l_fldlen||"cm")
            OTHERWISE
                LET l_node = createWordBox(p_detail,l_valname,l_text,NULL,NULL,l_fldlen||"cm")
        END CASE
        CALL l_node.setAttribute("marginRightWidth",HGAP||"cm")
        #CALL l_node.setAttribute("fontName","SimHei")
        CALL l_node.setAttribute("fontName",g_sr.fontname) #EXT-D20130

        #將欄位說明的寬度與右邊界加入細目寬度
        LET l_width = l_width + l_fldlen + HGAP

        #記錄明細欄位版面位置
        LET l_fldpos.fid = p_table[l_i].fldid
        LET l_fldpos.hpos = l_hpos
        LET l_fldpos.vpos = l_vpos
        LET l_fldpos.len = l_fldlen
        LET l_fldpos.sformat = l_format
        LET m_fldpos[m_fldpos.getLength() + 1].* = l_fldpos.*
        LET l_hpos = l_hpos + l_fldlen + m_hgap
    END FOR
    DISPLAY l_width
    IF m_max_width < l_width THEN
        LET m_max_width = l_width
    END IF
END FUNCTION

#建立頁尾或表尾
# p_name: "P" or "p" 頁尾; "R" or "r" 表尾
PRIVATE FUNCTION createFooter(p_node,p_name)
    DEFINE p_node   om.DomNode
    DEFINE p_name   LIKE type_file.chr1
    DEFINE l_footer om.DomNode
    DEFINE l_node1  om.DomNode
    DEFINE l_node2  om.DomNode
    DEFINE l_name   STRING
    #DEFINE li_pos   LIKE type_file.num15_3
    DEFINE l_stat   STRING

    CASE
        WHEN p_name MATCHES "[Pp]"
            LET l_name = "PageFooter"
            LET l_stat = "(Continue)"
        WHEN p_name MATCHES "[Rr]"
            LET l_name = "ReportFooter"
            LET l_stat = "(End)"
    END CASE
    LET l_footer = createLayoutNode(p_node,l_name||"s")
    IF p_name MATCHES "[Pp]" THEN
        CALL l_footer.setAttribute("port","anyPageFooter")
    ELSE
        CALL l_footer.setAttribute("y","max-0.8cm")
    END IF
    #CALL l_footer.setAttribute("borderTopWidth","1")  #FUN-C40064 mark   
    CALL l_footer.setAttribute("borderTopWidth","1.5")   #FUN-C40064 add
    CALL l_footer.setAttribute("borderTopStyle","solid")

    #LET l_node1 = createStripe(l_footer,l_name||"1")   #FUN-C40064 mark
    LET l_node1 = createStripe(l_footer,l_name||"01")   #FUN-C40064 add
    CALL l_node1.setAttribute("borderBottomWidth","1")
    CALL l_node1.setAttribute("borderBottomStyle","solid")

    LET l_node2 = createLabel(l_node1,l_name||"Cond_Label","Condition:",NULL,NULL,"2.5cm")
    #CALL l_node2.setAttribute("fontName","SimHei")
    CALL l_node2.setAttribute("fontName",g_sr.fontname) #EXT-D20130

    LET l_node2 = createVar(l_node1,"tm.wc","FGLString",m_header_expected)
    LET l_node2 = createWordBox(l_node1,l_name||"Cond_Value","{{tm.wc}}",NULL,NULL,"12.0cm")
    #CALL l_node2.setAttribute("fontName","SimHei")
    CALL l_node2.setAttribute("fontName",g_sr.fontname) #EXT-D20130

    #LET l_node1 = createStripe(l_footer,l_name||"2") #FUN-C40064 mark
    LET l_node1 = createStripe(l_footer,l_name||"02")   #FUN-C40064 add
    LET l_node2 = createVar(l_node1,"g_prog","FGLString",m_header_expected)
    LET l_node2 = createWordBox(l_node1,l_name||"Prog_Value","{{\"(\"+g_prog+\")\"}}",NULL,NULL,"2.5cm")
    #CALL l_node2.setAttribute("fontName","SimHei")
    CALL l_node2.setAttribute("fontName",g_sr.fontname) #EXT-D20130

    #LET li_pos = m_content_width - 2.5
    LET l_node2 = createLabel(l_node1,l_name||"Status_Label",l_stat,NULL,"max-2.5cm","2.5cm")
    #CALL l_node2.setAttribute("fontName","SimHei")
    CALL l_node2.setAttribute("fontName",g_sr.fontname) #EXT-D20130
END FUNCTION

PRIVATE FUNCTION createStripe(p_node,p_name)
    DEFINE p_node     om.DomNode
    DEFINE p_name     STRING
    DEFINE l_node     om.DomNode

    LET l_node = p_node.createChild("MINIPAGE")
    CALL l_node.setAttribute("name",p_name)
    CALL l_node.setAttribute("width","min")
    CALL l_node.setAttribute("length","max")
    CALL l_node.setAttribute("layoutDirection","leftToRight")
    RETURN l_node
END FUNCTION

PRIVATE FUNCTION createPageBreak(p_node,p_name)
    DEFINE p_node     om.DomNode
    DEFINE p_name     STRING
    DEFINE l_node     om.DomNode

    LET l_node = p_node.createChild("MINIPAGE")
    CALL l_node.setAttribute("name",p_name)
    CALL l_node.setAttribute("width","rest")
    CALL l_node.setAttribute("length","max")
    CALL l_node.setAttribute("layoutDirection","leftToRight")
    RETURN l_node
END FUNCTION

PRIVATE FUNCTION createLayoutNode(p_node,p_name)
    DEFINE p_node     om.DomNode
    DEFINE p_name     STRING
    DEFINE l_node     om.DomNode

    LET l_node = p_node.createChild("LAYOUTNODE")
    CALL l_node.setAttribute("name",p_name)
    CALL l_node.setAttribute("width","max")
    CALL l_node.setAttribute("length","min")
    CALL l_node.setAttribute("floatingBehavior","enclosed")
    RETURN l_node
END FUNCTION

PRIVATE FUNCTION createGroup(p_node)
    DEFINE p_node     om.DomNode
    DEFINE l_node     om.DomNode

    LET l_node = p_node.createChild("rtl:match")
    CALL l_node.setAttribute("nameConstraint","Group")
    CALL l_node.setAttribute("minOccurs","0")
    CALL l_node.setAttribute("maxOccurs","unbounded")
    RETURN l_node
END FUNCTION

PRIVATE FUNCTION createVar(p_node,p_name,p_type,p_exceptedLocation)
    DEFINE p_node               om.DomNode
    DEFINE p_name               STRING
    DEFINE p_type               STRING
    DEFINE p_exceptedLocation   STRING
    DEFINE l_node               om.DomNode

    LET l_node = p_node.createChild("rtl:input-variable")
    CALL l_node.setAttribute("name",p_name)
    CALL l_node.setAttribute("type",p_type)
    CALL l_node.setAttribute("expectedLocation",p_exceptedLocation)
    RETURN l_node
END FUNCTION

PRIVATE FUNCTION createTitle(p_node,p_name,p_text,p_x,p_fontsize)
    DEFINE p_node       om.DomNode
    DEFINE p_name       STRING
    DEFINE p_x          STRING
    DEFINE p_text       STRING
    DEFINE p_fontsize   STRING
    DEFINE l_node       om.DomNode

    LET l_node = p_node.createChild("WORDWRAPBOX")
    CALL l_node.setAttribute("name",p_name)
    CALL l_node.setAttribute("x",p_x)
    #CALL l_node.setAttribute("y","0")   #FUN-C60077 註解 
    CALL l_node.setAttribute("y","0cm")  #FUN-C60077 將Y座標設置為0cm
    #CALL l_node.setAttribute("width",m_content_width||"cm")
    CALL l_node.setAttribute("width","max")
    CALL l_node.setAttribute("fontSize",p_fontsize)
    CALL l_node.setAttribute("floatingBehavior","enclosed")
    CALL l_node.setAttribute("trimText","compress")
    CALL l_node.setAttribute("textAlignment","center")
    CALL l_node.setAttribute("fidelity","true")
    CALL l_node.setAttribute("text",p_text)
    RETURN l_node
END FUNCTION

PRIVATE FUNCTION createLabel(p_node,p_name,p_text,p_x,p_y,p_width)
    DEFINE p_node       om.DomNode
    DEFINE p_name       STRING
    DEFINE p_x          STRING
    DEFINE p_y          STRING
    DEFINE p_width      STRING
    DEFINE p_text       STRING
    DEFINE l_node       om.DomNode

    LET l_node = createWordBox(p_node,p_name,p_text,p_x,p_y,p_width)
    CALL l_node.setAttribute("localizeText","true")
    RETURN l_node
END FUNCTION

#建立文字欄位
PRIVATE FUNCTION createWordBox(p_node,p_name,p_text,p_x,p_y,p_width)
    DEFINE p_node       om.DomNode
    DEFINE p_name       STRING
    DEFINE p_text       STRING
    DEFINE p_x          STRING
    DEFINE p_y          STRING
    DEFINE p_width      STRING
    DEFINE l_node       om.DomNode

    LET l_node = p_node.createChild("WORDWRAPBOX")
    CALL l_node.setAttribute("name",p_name)
    IF p_x IS NOT NULL THEN
        CALL l_node.setAttribute("x",p_x)
    END IF
    IF p_y IS NOT NULL THEN
        CALL l_node.setAttribute("y",p_y)
    END IF
    CALL l_node.setAttribute("width",p_width)
    CALL l_node.setAttribute("fontSize","9")
    CALL l_node.setAttribute("floatingBehavior","enclosed")
    CALL l_node.setAttribute("trimText","compress")
    CALL l_node.setAttribute("fidelity","true")
    CALL l_node.setAttribute("text",p_text)
    CALL l_node.setAttribute("textAlignment","left")  #TSD.odyliao 120427 add
    RETURN l_node
END FUNCTION

#建立數字欄位
PRIVATE FUNCTION createDecBox(p_node,p_name,p_text,p_format,p_x,p_y,p_width)
    DEFINE p_node       om.DomNode
    DEFINE p_name       STRING
    DEFINE p_text       STRING
    DEFINE p_format     STRING
    DEFINE p_x          STRING
    DEFINE p_y          STRING
    DEFINE p_width      STRING
    DEFINE l_node       om.DomNode

    LET l_node = p_node.createChild("DECIMALFORMATBOX")
    IF p_format IS NULL THEN
        CALL l_node.setAttribute("format","---,---,---,---,--&.&&")
    ELSE
        CALL l_node.setAttribute("format",p_format)
    END IF
    CALL l_node.setAttribute("textAlignment","right")
    CALL l_node.setAttribute("value",p_text)
    CALL l_node.setAttribute("name",p_name)
    IF p_x IS NOT NULL THEN
        CALL l_node.setAttribute("x",p_x)
    END IF
    IF p_y IS NOT NULL THEN
        CALL l_node.setAttribute("y",p_y)
    END IF
    CALL l_node.setAttribute("width",p_width)
    CALL l_node.setAttribute("fontSize","9")
    CALL l_node.setAttribute("floatingBehavior","enclosed")
    CALL l_node.setAttribute("fidelity","true")
    RETURN l_node
END FUNCTION

#建立頁次欄位
PRIVATE FUNCTION createPageNoBox(p_node,p_name)
    DEFINE p_node       om.DomNode
    DEFINE p_name       STRING
    DEFINE l_node       om.DomNode
    DEFINE l_width      LIKE type_file.num15_3

    #LET l_width = 1.7  #FUN-C40064 mark
    LET l_width = 1.5  #FUN-C40064 add
    LET l_node = p_node.createChild("PAGENOBOX")
    CALL l_node.setAttribute("name",p_name)
    CALL l_node.setAttribute("y","max-"||l_width||"cm")
    #CALL l_node.setAttribute("fontName","SimHei")
    CALL l_node.setAttribute("fontName",g_sr.fontname) #EXT-D20130
    CALL l_node.setAttribute("fontSize","9")
    CALL l_node.setAttribute("width",l_width||"cm")
    CALL l_node.setAttribute("floatingBehavior","enclosed")
    CALL l_node.setAttribute("textAlignment","right")   #FUN-C60077 增加靠右對齊屬性
    CALL l_node.setAttribute("textExpression","format(getPageNumber(\"Page Root\"),ARABIC)+\"/\"+format(getTotalNumberOfPages(\"Page Root\"),ARABIC)")
    CALL l_node.setAttribute("fidelity","true") #FUN-C50031 add
    RETURN l_node
END FUNCTION

#建立圖片欄位
PRIVATE FUNCTION createImgBox(p_node,p_name,p_x,p_y,p_width,p_length,p_url)
    DEFINE p_node       om.DomNode
    DEFINE p_name       STRING
    DEFINE p_x          STRING
    DEFINE p_y          STRING
    DEFINE p_width      STRING
    DEFINE p_length     STRING
    DEFINE p_url        STRING
    DEFINE l_node       om.DomNode

    LET l_node = p_node.createChild("IMAGEBOX")
    CALL l_node.setAttribute("name",p_name)
    CALL l_node.setAttribute("x",p_x)
    CALL l_node.setAttribute("y",p_y)
    IF NOT cl_null(p_width) THEN   #FUN-C40064 add 
       CALL l_node.setAttribute("width",p_width)
    END IF  #FUN-C40064 add
    IF NOT cl_null(p_length) THEN #FUN-C40064 add
       CALL l_node.setAttribute("length",p_length)
    END IF     #FUN-C40064 add
    CALL l_node.setAttribute("url",p_url)
    CALL l_node.setAttribute("floatingBehavior","enclosed")
    RETURN l_node
END FUNCTION

PRIVATE FUNCTION setFont(p_node,p_fontname,p_fontsize)
    DEFINE p_node       om.DomNode
    DEFINE p_fontname   STRING
    DEFINE p_fontsize   STRING

    IF NOT cl_null(p_fontname) THEN
        CALL p_node.removeAttribute("fontName")
        CALL p_node.setAttribute("fontName",p_fontname)
    END IF
    IF NOT cl_null(p_fontsize) THEN
        CALL p_node.removeAttribute("fontSize")
        CALL p_node.setAttribute("fontSize",p_fontsize)
    END IF
END FUNCTION

#取得欄位的寬度、資料型別、數字型別的格式字串
PRIVATE FUNCTION get_fldattr(p_datatype,p_length)
    DEFINE p_datatype   LIKE type_file.chr20
    DEFINE p_length     LIKE type_file.chr20
    DEFINE l_fldlen     LIKE type_file.num15_3
    DEFINE l_typestr    STRING
    DEFINE l_format     STRING
    DEFINE l_prec       LIKE type_file.num10
    DEFINE l_scal       LIKE type_file.num10
    DEFINE l_strbuf     base.StringBuffer
    DEFINE l_i          LIKE type_file.num10
    DEFINE l_strtok     base.StringTokenizer
    DEFINE l_datatype   LIKE type_file.chr20

    LET l_datatype = UPSHIFT(p_datatype)
    INITIALIZE l_format TO NULL
    CASE
        WHEN l_datatype = "DATETIME" OR l_datatype = "DATE"
            LET l_fldlen = 10 * CHARWIDTH
            LET l_typestr = "FGLString"
        WHEN l_datatype = "SMALLINT" OR l_datatype = "INT" OR l_datatype = "INTEGER"
          OR l_datatype = "BIGINT" OR l_datatype = "TINYINT"
            LET l_prec = p_length
            LET l_strbuf = base.StringBuffer.create()
            FOR l_i = l_prec TO 2 STEP -1
                CALL l_strbuf.append("-")
                IF l_i > 1 AND (l_i MOD 3 = 1) THEN
                    CALL l_strbuf.append(",")
                END IF
            END FOR
            CALL l_strbuf.append("&")
            LET l_format = l_strbuf.toString()
            LET l_fldlen = l_prec * CHARWIDTH / 2
            LET l_typestr = "FGLNumeric"
        WHEN l_datatype = "NUMBER" OR l_datatype = "DECIMAL" OR l_datatype = "MONEY"
          OR l_datatype = "FLOAT" OR l_datatype = "SMALLFLOAT"
            LET l_strtok = base.StringTokenizer.create(p_length,",")
            IF l_strtok.hasMoreTokens() THEN
                LET l_prec = l_strtok.nextToken()
            END IF
            IF l_strtok.hasMoreTokens() THEN
                LET l_scal = l_strtok.nextToken()
            END IF
            LET l_strbuf = base.StringBuffer.create()
            FOR l_i = l_prec TO 2 STEP -1
                CALL l_strbuf.append("-")
                IF l_i > 1 AND (l_i MOD 3 = 1) THEN
                    CALL l_strbuf.append(",")
                END IF
            END FOR
            CALL l_strbuf.append("&")
            IF l_scal > 0 THEN
                CALL l_strbuf.append(".")
            END IF
            FOR l_i = 1 TO l_scal
                CALL l_strbuf.append("&")
            END FOR
            LET l_format = l_strbuf.toString()
            LET l_fldlen = (l_prec + l_scal + 1)/2* CHARWIDTH
            LET l_typestr = "FGLNumeric"
        OTHERWISE
            LET l_prec = p_length
            LET l_fldlen = l_prec * CHARWIDTH
            LET l_typestr = "FGLString"
    END CASE

    RETURN l_fldlen,l_typestr,l_format
END FUNCTION

#取得欄位說明長度
PRIVATE FUNCTION get_lbllen(p_label)
    DEFINE p_label  STRING
    DEFINE l_lbllen LIKE type_file.num15_3

    LET l_lbllen = FGL_WIDTH(p_label) * CHARWIDTH
    IF l_lbllen > MAXLENGTH THEN
        LET l_lbllen = MAXLENGTH
    END IF
    RETURN l_lbllen
END FUNCTION
