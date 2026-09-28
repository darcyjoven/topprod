# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_gr_get_paper_size
# Descriptions...: 取得紙張格式的寬、高、長度單位
# Input parameter: p_papername      紙張格式
# Return code....: gdo_file.gdo03   紙張寬度
#                  gdo_file.gdo04   紙張高度
#                  gdo_file.gdo05   紙張長度單位
# Usage .........: call cl_gr_get_paper_size(l_gdo02) RETURING l_gdo03,l_gdo04,l_gdo05
# Date & Author..: 11/05/05 By jacklai
# Modify.........: No.FUN-B40095 11/05/05 By jacklai Genero Report
# Modify.........: No.FUN-CC0005 12/12/10 By janet mark紙張方向段

IMPORT os
DATABASE ds
 
GLOBALS "../../config/top.global"

#No.FUN-B40095
FUNCTION cl_gr_get_paper_size(p_papername)
    DEFINE p_papername  LIKE gdo_file.gdo02
    DEFINE l_width      LIKE gdo_file.gdo03
    DEFINE l_height     LIKE gdo_file.gdo04
    DEFINE l_unit       LIKE gdo_file.gdo05

    SELECT gdo03,gdo04,gdo05 INTO l_width,l_height,l_unit 
    FROM gdo_file WHERE gdo02=p_papername

    RETURN l_width,l_height,l_unit
END FUNCTION

##################################################
# Library name...: cl_gr_get_4rp_paper_size
# Descriptions...: 取得4rp樣板檔的紙張格式名稱與紙張方向
# Input parameter: p_doc_root       om.DomNode(4rp XML文件的根節點)
# Return code....: gdo_file.gdo02   紙張格式名稱
#                  STRING           紙張方向
# Usage .........: call cl_gr_get_4rp_paper_size(l_gdo02) RETURING l_gdo03,l_gdo04,l_gdo05
##################################################
FUNCTION cl_gr_get_4rp_paper_size(p_doc_root)
    DEFINE p_doc_root       om.DomNode
    DEFINE l_node_list      om.NodeList
    DEFINE l_cur_node       om.DomNode
    DEFINE l_gdo02          LIKE gdo_file.gdo02
    DEFINE l_gdo03          LIKE gdo_file.gdo03
    DEFINE l_gdo04          LIKE gdo_file.gdo04
    DEFINE l_gdo05          LIKE gdo_file.gdo05
    DEFINE l_src_width      STRING
    DEFINE l_src_length     STRING
    DEFINE l_orientation    STRING
    DEFINE l_pos            LIKE type_file.num10

    IF p_doc_root IS NOT NULL THEN
        LET l_node_list = p_doc_root.selectByTagName("report:Settings")
        IF l_node_list IS NOT NULL AND l_node_list.getLength() >= 1 THEN
            LET l_cur_node = l_node_list.item(1)
            LET l_src_width = l_cur_node.getAttribute("RWPageWidth")
            LET l_src_length = l_cur_node.getAttribute("RWPageLength")
                    
            LET l_pos = l_src_width.getIndexOf("width",1)
            IF l_pos >= 1 THEN
                LET l_gdo02 = l_src_width.subString(1,l_pos-1) 
                LET l_orientation = "P"
            ELSE
                LET l_pos = l_src_width.getIndexOf("length",1)
                IF l_pos >= 1 THEN
                    LET l_gdo02 = l_src_width.subString(1,l_pos-1) 
                    LET l_orientation = "L"
                ELSE
                    LET l_pos = l_src_width.getIndexOf("cm",1)
                    IF l_pos >= 1 THEN
                        LET l_gdo03 = l_src_width.subString(1,l_pos-1)
                        LET l_gdo05 = "C"
                    ELSE
                        LET l_pos = l_src_width.getIndexOf("in",1)
                        IF l_pos >= 1 THEN
                            LET l_gdo03 = l_src_width.subString(1,l_pos-1)
                            LET l_gdo05 = "I"
                        END IF
                    END IF
                END IF
            END IF

            IF l_gdo05 = "C" THEN
                LET l_pos = l_src_length.getIndexOf("cm",1)
                IF l_pos >= 1 THEN
                    LET l_gdo04 = l_src_length.subString(1,l_pos-1)
                END IF
            END IF

            IF l_gdo05 = "I" THEN
                LET l_pos = l_src_length.getIndexOf("in",1)
                IF l_pos >= 1 THEN
                    LET l_gdo04 = l_src_length.subString(1,l_pos-1)
                END IF
            END IF

            IF l_gdo05 = "C" OR l_gdo05 = "I" THEN
                LET l_gdo02=NULL  #FUN-CC0005 add
                SELECT gdo02,gdo03,gdo04 INTO l_gdo02,l_gdo03,l_gdo04
                FROM gdo_file WHERE gdo03=l_gdo03 AND gdo04=l_gdo04
                AND gdo05=l_gdo05
                #IF NOTFOUND THEN  #FUN-CC0005 mark
                IF l_gdo02 IS NULL THEN  #FUN-CC0005 add
                    SELECT gdo02,gdo03,gdo04 INTO l_gdo02,l_gdo03,l_gdo04
                    FROM gdo_file WHERE gdo03=l_gdo04 AND gdo04=l_gdo03
                    AND gdo05=l_gdo05
                    #FUN-CC0005 ADD---(S)
                    #IF NOTFOUND THEN   #FUN-CC0005 mark
                    IF l_gdo02 IS NULL THEN  
                       LET l_orientation = NULL 
                    ELSE 
                       LET l_orientation = "L"
                    END IF 

                ELSE
                   LET l_orientation = "P"
                   #FUN-CC0005 ADD---(E)
                END IF
            ELSE
                #從4rp抓取紙張大小時需轉換為英文大寫
                LET l_gdo02 = UPSHIFT(l_gdo02)
            END IF

            #FUN-CC0005 mark-(s)
            #IF l_orientation IS NULL THEN
                #IF l_gdo03 >= l_gdo04 THEN
                    #LET l_orientation = "L"
                #ELSE
                    #LET l_orientation = "P"
                #END IF                
            #END IF 
            #FUN-CC0005 mark-(e)
        END IF
    END IF
    RETURN l_gdo02,l_orientation
END FUNCTION
