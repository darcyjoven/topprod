# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: s_p_replang.4gl
# Descriptions...: p_replang共用的Function
# Date & Author..: 11/05/05 by jacklai
# Modify.........: No.FUN-B40095 11/05/05 By jacklai Genero Report
# Modify.........: No.FUN-C10044 12/01/13 By jacklai 表頭的公司地址等欄位說明寬度調整時，欄位值的定位點應跟隨調整 
# Modify.........: No.FUN-C20112 12/02/23 By jacklai 將共用程式段自p_replang搬出

IMPORT os
DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_chk_err_msg        STRING  #FUN-C10044 #檢查報表命名規則的錯誤訊息 #FUN-C20112

#No.FUN-B40095
#取出欄位所在行序
FUNCTION p_replang_get_lineno(p_node)
    DEFINE p_node       om.DomNode
    DEFINE l_parent     om.DomNode
    DEFINE l_nodename   STRING
    DEFINE l_tmpstr     STRING
    DEFINE l_no         LIKE type_file.num5

    LET l_no = 0

    #取上一層節點
    LET l_parent = p_node.getParent()

    IF l_parent IS NOT NULL THEN
        LET l_nodename = l_parent.getAttribute("name")
        LET l_tmpstr = cl_replace_str(l_nodename,"Master","")
        LET l_tmpstr = cl_replace_str(l_tmpstr,"DetailHeader","") #FUN-C10044
        LET l_tmpstr = cl_replace_str(l_tmpstr,"Detail","")
 
        #display "l_tmpstr=",l_tmpstr
        TRY
            LET l_no = l_tmpstr
        CATCH
            LET l_no = 0
        END TRY
        #display "l_no=",l_no
    END IF
    RETURN l_no
END FUNCTION

#取出單身欄位順序
FUNCTION p_replang_get_seqno(p_node)
    DEFINE p_node       om.DomNode
    DEFINE l_parent     om.DomNode
    DEFINE l_curnode    om.DomNode
    DEFINE l_nodename   STRING
    DEFINE l_i          LIKE type_file.num5
    DEFINE l_cnt        LIKE type_file.num5
    DEFINE l_index      LIKE type_file.num5

    LET l_parent = p_node.getParent()
    LET l_nodename = p_node.getAttribute("name")
    LET l_cnt = 0
    #DISPLAY (p_node IS NULL)||";"||(l_parent IS NULL)  #debug
    IF l_parent IS NOT NULL THEN
        #DISPLAY l_parent.getAttribute("name"),"[cnt]:",l_parent.getChildCount()    #debug
        FOR l_i = 1 TO l_parent.getChildCount()
            LET l_curnode = l_parent.getChildByIndex(l_i)
            IF l_curnode.getTagName() = "WORDBOX"
                OR l_curnode.getTagName() = "WORDWRAPBOX"
                OR l_curnode.getTagName() = "DECIMALFORMATBOX"
            THEN
                LET l_cnt = l_cnt + 1
                IF l_curnode.getAttribute("name") = l_nodename THEN
                    LET l_index = l_cnt
                    EXIT FOR
                END IF
            END IF
        END FOR
    END IF
    RETURN l_index
END FUNCTION

#取得需要與欄位一起搬移的變數節點
FUNCTION p_replang_get_varnodes(p_node)
    DEFINE p_node       om.DomNode
    DEFINE l_parent     om.DomNode
    DEFINE l_nodes      DYNAMIC ARRAY OF om.DomNode
    DEFINE l_current    om.DomNode
    DEFINE l_i          LIKE type_file.num5
    DEFINE l_j          LIKE type_file.num5
    DEFINE l_str        STRING
    DEFINE l_varname    STRING

    CALL l_nodes.clear()
    LET l_parent = p_node.getParent()
    FOR l_i = 1 TO l_parent.getChildCount()
        LET l_current = l_parent.getChildByIndex(l_i)
        LET l_varname = l_current.getAttribute("name")
        IF l_current.getTagName() = "rtl:input-variable" THEN
            FOR l_j = 1 TO p_node.getAttributesCount()
                LET l_str = p_node.getAttributeValue(l_j)
                IF l_str.getIndexOf("{{",1) > 0 AND l_str.getIndexOf(l_varname,1) > 0 THEN
                    CALL l_nodes.appendElement()
                    LET l_nodes[l_nodes.getLength()] = l_current
                END IF
            END FOR
        END IF
    END FOR

    RETURN l_nodes
END FUNCTION

#取得單身或單頭欄位變更的目的行節點
FUNCTION p_replang_get_dstnode(p_node,p_lineno)
    DEFINE p_node       om.DomNode
    DEFINE p_lineno     LIKE type_file.num5
    DEFINE l_parent     om.DomNode
    DEFINE l_parent2    om.DomNode
    DEFINE l_curnode    om.DomNode
    DEFINE l_i          LIKE type_file.num10
    DEFINE l_flag       LIKE type_file.num5
    DEFINE l_nodeName   STRING
    DEFINE l_name1      STRING
    DEFINE l_name2      STRING
    DEFINE l_name3      STRING
    DEFINE l_sno        STRING
    
    LET l_flag = FALSE
    TRY
        LET l_sno = p_lineno USING "&&" 
        LET l_name1 = "Master",l_sno
        LET l_name2 = "Detail",l_sno
        LET l_name3 = "DetailHeader",l_sno
        
        LET l_parent = p_node.getParent()
        LET l_parent2 = l_parent.getParent()

        FOR l_i = 1 TO l_parent2.getChildCount()
            LET l_curnode = l_parent2.getChildByIndex(l_i)
            LET l_nodeName = l_curnode.getAttribute("name")
            IF l_nodeName = l_name1 OR l_nodeName = l_name2 OR l_nodeName = l_name3 THEN
                DISPLAY "node=",l_nodename
                LET l_flag = TRUE
                EXIT FOR
            END IF
        END FOR

        IF NOT l_flag THEN
            LET l_curnode = NULL
        END IF
    CATCH
        DISPLAY base.Application.getStackTrace()
        LET l_curnode = NULL
    END TRY
    RETURN l_curnode
END FUNCTION

#取得變更的單身欄位目的節點
FUNCTION p_replang_get_seqnode(p_node,p_seqno)
    DEFINE p_node       om.DomNode
    DEFINE p_seqno      LIKE type_file.num5
    DEFINE l_parent     om.DomNode
    DEFINE l_curnode    om.DomNode
    DEFINE l_cnt        LIKE type_file.num5
    DEFINE l_i          LIKE type_file.num5
    DEFINE l_resnode    om.DomNode

    INITIALIZE l_resnode TO NULL
    LET l_parent = p_node.getParent()
    LET l_cnt = 0
    FOR l_i = 1 TO l_parent.getChildCount()
        LET l_curnode = l_parent.getChildByIndex(l_i)
        IF l_curnode.getTagName() = "WORDBOX"
            OR l_curnode.getTagName() = "WORDWRAPBOX"
            OR l_curnode.getTagName() = "DECIMALFORMATBOX"
        THEN
            LET l_cnt = l_cnt + 1
            IF l_cnt = p_seqno THEN
                LET l_resnode = l_curnode
                EXIT FOR
            END IF
        END IF
    END FOR
    RETURN l_resnode
END FUNCTION

#設定顏色屬性
FUNCTION p_replang_setcolor(p_node,p_color)
    DEFINE p_node   om.DomNode
    DEFINE p_color  STRING
    DEFINE l_colval STRING

    IF p_color IS NOT NULL THEN
        CALL p_node.removeAttribute("color")
        IF p_color.getCharAt(1) = "#" THEN
            LET l_colval = p_color
        ELSE
            LET l_colval = p_color
        END IF
        CALL p_node.setAttribute("color",l_colval)
    END IF
END FUNCTION

#將資料欄位值Y|N轉為4RP屬性值true|false
FUNCTION p_replang_char2boolstr(p_val)
    DEFINE p_val    STRING
    DEFINE l_res    STRING

    INITIALIZE l_res TO NULL
    CASE p_val
        WHEN "Y"
            LET l_res = "true"
        WHEN "N"
            LET l_res = "false"
    END CASE
    RETURN l_res
END FUNCTION

#將4RP屬性值true|false轉為資料欄位值Y|N
FUNCTION p_replang_bool2char(p_val)
    DEFINE p_val STRING
    DEFINE l_str STRING

    INITIALIZE l_str TO NULL
    CASE
        WHEN p_val.equalsIgnoreCase("true")
            LET l_str = "Y"
        WHEN p_val.equalsIgnoreCase("false")
            LET l_str = "N"
        OTHERWISE
            LET l_str = "N"
    END CASE
    RETURN l_str
END FUNCTION

#將欄位轉換為折行或不折行
FUNCTION p_replang_convertwrap(p_node,p_iswrap)
    DEFINE p_node   om.DomNode
    DEFINE p_iswrap STRING
    DEFINE l_newtag STRING
    DEFINE l_parent om.DomNode
    DEFINE l_tmp    om.DomNode
    DEFINE l_i      LIKE type_file.num5

    INITIALIZE l_newtag TO NULL
    CASE p_iswrap
        WHEN "Y"
            IF p_node.getTagName() = "WORDBOX" THEN
                LET l_newtag = "WORDWRAPBOX"
            END IF
        WHEN "N"
            IF p_node.getTagName() = "WORDWRAPBOX" THEN
                LET l_newtag = "WORDBOX"
            END IF
    END CASE

    IF l_newtag IS NOT NULL THEN
        LET l_parent = p_node.getParent()
        LET l_tmp = l_parent.createChild(l_newtag)
        FOR l_i = 1 TO p_node.getAttributesCount()
            CALL l_tmp.setAttribute(p_node.getAttributeName(l_i),p_node.getAttributeValue(l_i))
        END FOR
        CALL l_parent.replaceChild(l_tmp,p_node)
    END IF
END FUNCTION

#移除定位點及寬度欄位等的長度單位
FUNCTION p_replang_rmunit(p_pos)
    DEFINE p_pos    STRING
    DEFINE l_strbuf base.StringBuffer
    DEFINE l_str    STRING
    DEFINE l_val    LIKE type_file.num15_3

    LET l_val = -1
    IF p_pos IS NOT NULL THEN
        IF p_pos.getIndexOf("cm",1) > 0 THEN
            LET l_strbuf = base.StringBuffer.create()
            CALL l_strbuf.append(p_pos)
            CALL l_strbuf.replace("cm","",0)
            LET l_str = l_strbuf.toString()
            LET l_val = l_str
        ELSE
            TRY
                LET l_val = p_pos
                LET l_val = l_val * 2.54 / 72
            CATCH
                LET l_val = -1
            END TRY
        END IF
    END IF
    RETURN l_val
END FUNCTION

#FUN-C20112 --start--
#讀出4rp中的資料欄位
FUNCTION p_replang_readnodes(p_gdm,p_node,p_tagname,p_lang,p_gdm01)
    DEFINE p_gdm        DYNAMIC ARRAY OF RECORD LIKE gdm_file.*
    DEFINE p_node       om.DomNode
    DEFINE p_tagname    STRING
    DEFINE p_lang       LIKE gdm_file.gdm03
    DEFINE p_gdm01      LIKE gdm_file.gdm01
    DEFINE l_nodes      om.NodeList
    DEFINE l_i          LIKE type_file.num10
    DEFINE l_j          LIKE type_file.num10
    DEFINE l_curnode    om.DomNode
    DEFINE l_parent     om.DomNode
    DEFINE l_nodename   STRING
    DEFINE l_colname    STRING
    DEFINE l_tagtype    LIKE type_file.chr1
    DEFINE l_index      LIKE type_file.num10
    DEFINE l_exist      LIKE type_file.num5
    DEFINE l_node2      om.DomNode              #FUN-C10044
    DEFINE l_k          LIKE type_file.num10    #FUN-C10044
    DEFINE l_node3      om.DomNode              #FUN-C10044
    DEFINE l_cmpname    STRING                  #FUN-C10044
    DEFINE l_err_msg    STRING                  #FUN-C10044 #錯誤訊息
    DEFINE l_strbuf     base.StringBuffer       #FUN-C10044 #組錯誤訊息的字串緩衝區
    DEFINE l_prev       LIKE type_file.num10    #FUN-C10044 #前一個_Label位置
    DEFINE l_flag       LIKE type_file.num10    #FUN-C10044 #找到成對的_Label與_Value

    LET l_strbuf = base.StringBuffer.create()
    LET l_nodes = p_node.selectByTagName(p_tagname)
    FOR l_i = 1 TO l_nodes.getLength()
        LET l_curnode = l_nodes.item(l_i)
        LET l_nodename = l_curnode.getAttribute("name")
        LET l_parent = l_curnode.getParent()

        #FUN-C10044 --start--
        #若為IMAGEBOX物件時，限定名稱為logo_Value才處理
        IF p_tagname = "IMAGEBOX" AND l_nodename != "logo_Value" THEN
            CONTINUE FOR
        END IF
        #FUN-C10044 --end--

        #取得欄位類別
        CASE
            WHEN l_nodename.getIndexOf("_Label",1) > 0  #欄位說明
                LET l_tagtype = "L"
                LET l_colname = cl_replace_str(l_nodename,"_Label","")
            WHEN l_nodename.getIndexOf("_Value",1) > 0  #欄位
                LET l_tagtype = "V"
                LET l_colname = cl_replace_str(l_nodename,"_Value","")
            #FUN-C10044 --start--
            WHEN l_nodename.getIndexOf("_LValue",1) > 0  #動態欄位說明
                LET l_tagtype = "L"
                LET l_colname = cl_replace_str(l_nodename,"_LValue","")
            #FUN-C10044 --end--
            OTHERWISE                                   #其他
                LET l_colname =  l_nodename
                LET l_tagtype = "V"
        END CASE

        #尋找p_gdm中是否已有相同欄位名稱的資料
        LET l_index = 0
        LET l_exist = FALSE
        FOR l_j = 1 TO p_gdm.getLength()
            IF p_gdm[l_j].gdm04 = l_colname THEN
                LET l_index = l_j
                LET l_exist = TRUE
                EXIT FOR
            END IF
        END FOR

        #在p_gdm中未找到,新增一筆
        IF l_index <= 0 THEN
            CALL p_gdm.appendElement()
            LET l_index = p_gdm.getLength()

            LET p_gdm[l_index].gdm01 = p_gdm01  #FUN-C20112
            LET p_gdm[l_index].gdm02 = l_index
            LET p_gdm[l_index].gdm03 = p_lang
            LET p_gdm[l_index].gdm06 = "D"

            #取欄位名稱
            LET p_gdm[l_index].gdm04 = l_colname

            #取欄位屬性
            LET p_gdm[l_index].gdm05 = p_replang_get_category(l_curnode)

            #取行序
            IF p_gdm[l_index].gdm05 MATCHES "[12]" THEN
                LET p_gdm[l_index].gdm09 = p_replang_get_lineno(l_curnode)
            END IF

            #取單身欄位順序
            IF p_gdm[l_index].gdm05 = "2" THEN
                LET p_gdm[l_index].gdm10 = p_replang_get_seqno(l_curnode)
            END IF

            #設定折行否
            IF l_curnode.getTagName() = "WORDWRAPBOX" THEN
                LET p_gdm[l_index].gdm20 = "Y"
            ELSE
                LET p_gdm[l_index].gdm20 = "N"
            END IF

            #設定隱藏否
            CASE l_curnode.getAttribute("rtl:condition")
                WHEN "Boolean.FALSE" LET p_gdm[l_index].gdm21 = "Y"
                WHEN "Boolean.TRUE" LET p_gdm[l_index].gdm21 = "N"
                OTHERWISE LET p_gdm[l_index].gdm21 = "N"
            END CASE

        END IF

        CASE p_replang_has_label(p_node,p_gdm[l_index].gdm04)
            WHEN "Y" LET p_gdm[l_index].gdm22 = "N"
            WHEN "N" LET p_gdm[l_index].gdm22 = "Y"
        END CASE

        CASE l_tagtype
            WHEN "L"    #欄位說明
                #單頭需設定定位點
                IF p_gdm[l_index].gdm05 MATCHES "[1345]" THEN #FUN-C10044 add gdm05=3,4,5
                    LET p_gdm[l_index].gdm07 = p_replang_rmunit(l_curnode.getAttribute("y"))
                END IF
                LET p_gdm[l_index].gdm15 = p_replang_rmunit(l_curnode.getAttribute("width"))
                LET p_gdm[l_index].gdm16 = l_curnode.getAttribute("fontName")
                LET p_gdm[l_index].gdm17 = l_curnode.getAttribute("fontSize")
                LET p_gdm[l_index].gdm18 = p_replang_bool2char(l_curnode.getAttribute("fontBold"))
                LET p_gdm[l_index].gdm19 = l_curnode.getAttribute("color")
                LET p_gdm[l_index].gdm23 = l_curnode.getAttribute("text")  #FUN-C20112 add
            WHEN "V"    #欄位
                #取行序
                IF p_gdm[l_index].gdm05 MATCHES "[12]" THEN
                    LET p_gdm[l_index].gdm09 = p_replang_get_lineno(l_curnode)
                END IF
                LET p_gdm[l_index].gdm08 = p_replang_rmunit(l_curnode.getAttribute("width"))
                LET p_gdm[l_index].gdm11 = l_curnode.getAttribute("fontName")
                LET p_gdm[l_index].gdm12 = l_curnode.getAttribute("fontSize")
                LET p_gdm[l_index].gdm13 = p_replang_bool2char(l_curnode.getAttribute("fontBold"))
                LET p_gdm[l_index].gdm14 = l_curnode.getAttribute("color")

                IF (p_gdm[l_index].gdm05 MATCHES "[1345]") AND p_gdm[l_index].gdm22 = "Y" THEN #FUN-C10044 add gdm05=3,4,5
                    LET p_gdm[l_index].gdm07 = p_replang_rmunit(l_curnode.getAttribute("y"))
                END IF
        END CASE

        IF p_gdm[l_index].gdm13 IS NULL THEN
            LET p_gdm[l_index].gdm13 = "N"
        END IF

        IF p_gdm[l_index].gdm18 IS NULL THEN
            LET p_gdm[l_index].gdm18 = "N"
        END IF

        #FUN-C10044 --start--
        #檢查命名規則
        CASE 
            WHEN p_gdm[l_index].gdm05 = "1"
                IF l_nodename.getIndexOf("_Label",1) <= 0 AND
                    l_nodename.getIndexOf("_Value",1) <= 0
                THEN
                    LET l_err_msg = cl_getmsg_parm("azz1192", g_lang, l_nodename)
                    IF l_err_msg IS NOT NULL THEN
                        CALL l_strbuf.append(l_err_msg)
                        CALL l_strbuf.append("\r\n")
                    END IF
                END IF

                #檢查單身欄位說明與欄位值是否相連
                IF l_nodename.getIndexOf("_Value",1) >= 1 THEN
                    LET l_prev = 0
                    LET l_flag = FALSE
                    FOR l_j = 1 TO l_parent.getChildCount()
                        LET l_node2 = l_parent.getChildByIndex(l_j)
                        IF l_node2 = l_curnode THEN
                            FOR l_k = l_j - 1 TO 1 STEP -1
                                LET l_node3 = l_parent.getChildByIndex(l_k)
                                IF l_node3.getTagName() = "WORDBOX" OR l_node3.getTagName() = "WORDWRAPBOX" THEN
                                    LET l_prev = l_prev + 1
                                    LET l_cmpname = l_node3.getAttribute("name")
                                    IF l_cmpname = l_colname||"_Label" THEN
                                        LET l_flag = TRUE
                                        EXIT FOR
                                    END IF
                                END IF
                            END FOR
                        END IF
                    END FOR 
                END IF

                IF l_flag AND l_prev > 1 THEN
                    LET l_err_msg = cl_getmsg_parm("azz1192", g_lang, l_nodename)
                    IF l_err_msg IS NOT NULL THEN
                        CALL l_strbuf.append(l_err_msg)
                        CALL l_strbuf.append("\r\n")
                    END IF
                END IF
            WHEN p_gdm[l_index].gdm05 = "2"
                IF l_nodename.getIndexOf("_Label",1) <= 0 AND
                    l_nodename.getIndexOf("_Value",1) <= 0 AND
                    l_nodename.getIndexOf("_LValue",1) <= 0 AND
                    l_nodename.getIndexOf("DHspacer",1) <= 0 AND
                    l_nodename.getIndexOf("Dspacer",1) <= 0 
                THEN
                    LET l_err_msg = cl_getmsg_parm("azz1192", g_lang, l_nodename)
                    IF l_err_msg IS NOT NULL THEN
                        CALL l_strbuf.append(l_err_msg)
                        CALL l_strbuf.append("\r\n")
                    END IF
                END IF
            OTHERWISE
                IF l_nodename.getIndexOf("_Label",1) <= 0 AND
                    l_nodename.getIndexOf("_Value",1) <= 0
                THEN
                    LET l_err_msg = cl_getmsg_parm("azz1192", g_lang, l_nodename)
                    IF l_err_msg IS NOT NULL THEN
                        CALL l_strbuf.append(l_err_msg)
                        CALL l_strbuf.append("\r\n")
                    END IF
                END IF
        END CASE
        #FUN-C10044 --end--
    END FOR
    #FUN-C10044 --start--
    #將錯誤訊息附加到紀錄檢查命名規則錯誤的變數中
    IF l_strbuf.getLength() > 0 THEN
        IF g_chk_err_msg IS NULL THEN
            LET g_chk_err_msg = l_strbuf.toString()
        ELSE
            LET g_chk_err_msg = g_chk_err_msg,l_strbuf.toString()
        END IF
    END IF
    #FUN-C10044 --end--
END FUNCTION

#檢查欄位是否有欄位說明
FUNCTION p_replang_has_label(p_node,p_name)
    DEFINE p_node   om.DomNode
    DEFINE p_name   STRING
    DEFINE l_nodes  om.NodeList
    DEFINE l_len    LIKE type_file.num5
    DEFINE l_str    STRING
    DEFINE l_res    STRING

    LET l_str = "//WORDWRAPBOX[@name=\""||p_name.trim()||"_Label\"]"
    LET l_nodes = p_node.selectByPath(l_str)
    LET l_len = l_nodes.getLength()

    IF l_len <= 0 THEN
        LET l_str = "//WORDBOX[@name=\""||p_name.trim()||"_Label\"]"
        LET l_nodes = p_node.selectByPath(l_str)
        LET l_len = l_nodes.getLength()
    END IF

    IF l_len >= 1 THEN
        LET l_res = "Y"
    ELSE
        LET l_res = "N"
    END IF
    RETURN l_res
END FUNCTION

#取得欄位類別(1:單頭,2:單身,3:其他)
FUNCTION p_replang_get_category(p_node)
    DEFINE p_node       om.DomNode
    DEFINE l_parent     om.DomNode
    DEFINE l_name       STRING
    DEFINE l_parent2    om.DomNode
    DEFINE l_name2      STRING
    DEFINE l_res        STRING

    LET l_res = "3"

    #取上一層節點
    LET l_parent = p_node.getParent()
    LET l_name = l_parent.getAttribute("name")

    #取上兩層節點
    LET l_parent2 = l_parent.getParent()
    LET l_name2 = l_parent2.getAttribute("name")

    #欄位在單頭
    IF l_name.getIndexOf("Master",1) > 0 AND l_name2.getIndexOf("Masters",1) > 0 THEN
        LET l_res = "1"
    END IF

    #欄位在單身
    IF l_name.getIndexOf("Detail",1) > 0 AND l_name2.getIndexOf("Details",1) > 0 THEN #FUN-C10044
        LET l_res = "2"
    END IF
    
    #FUN-C10044 --start--
    #欄位在單身
    IF l_name.getIndexOf("DetailHeader",1) > 0 AND l_name2.getIndexOf("DetailHeaders",1) > 0 THEN
        LET l_res = "2"
    END IF
    
    #欄位在群組首
    IF l_name.getIndexOf("GroupHeader",1) > 0 THEN
        LET l_res = "4"
    END IF

    #欄位在群組尾
    IF l_name.getIndexOf("GroupFooter",1) > 0 THEN
        LET l_res = "5"
    END IF
    #FUN-C10044 --end--

    RETURN l_res
END FUNCTION

#取RECORD member的名稱
FUNCTION p_replang_getcolname(p_name)
    DEFINE p_name   STRING
    DEFINE l_name   STRING
    DEFINE l_pos1   LIKE type_file.num10
    DEFINE l_pos2   LIKE type_file.num10
    DEFINE l_i      LIKE type_file.num10

    INITIALIZE l_name TO NULL
    IF p_name IS NOT NULL THEN
        LET l_pos1 = p_name.getIndexOf("_Label",1) - 1
        IF l_pos1 <= 0 THEN
            LET l_pos1 = p_name.getLength()
        END IF

        LET l_pos2 = -1
        FOR l_i = p_name.getLength() TO 1 STEP -1
            IF p_name.getCharAt(l_i) = '.' THEN
                LET l_pos2 = l_i
                EXIT FOR
            END IF
        END FOR
        IF l_pos2 > 0 AND l_pos1 > l_pos2 THEN
            LET l_name = p_name.subString(l_pos2 + 1,l_pos1)
        ELSE
            LET l_name = p_name
        END IF
    END IF
    RETURN l_name
END FUNCTION
#FUN-C20112 --end--
