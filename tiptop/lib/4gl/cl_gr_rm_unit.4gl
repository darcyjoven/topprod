# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Library name...: cl_gr_rm_unit
# Descriptions...: 移除長度單位字串,並將英吋轉為公分
# Input parameter: p_position           長度
# Return code....: type_file.num15_3    轉換後的長度
# Usage..........: LET l_new_pos = cl_gr_rm_unit("16.18in")
#                  #l_new_pos 的值為 41.097
# Modify.........: No.FUN-B40095 11/05/05 By jacklai Genero Report

IMPORT os
DATABASE ds
 
GLOBALS "../../config/top.global"

#No.FUN-B40095
FUNCTION cl_gr_rm_unit(p_position)
    DEFINE p_position   STRING
    DEFINE l_strbuf     base.StringBuffer
    DEFINE l_str        STRING
    DEFINE l_val        LIKE type_file.num15_3

    LET l_val = -1
    IF p_position IS NOT NULL THEN
        LET l_strbuf = base.StringBuffer.create()
        
        IF p_position.getIndexOf("cm",1) > 0 THEN
            CALL l_strbuf.append(p_position)
            CALL l_strbuf.replace("cm","",0)
            LET l_str = l_strbuf.toString()
            LET l_val = l_str
        ELSE
            IF p_position.getIndexOf("in",1) > 0 
                OR p_position.getIndexOf("inch",1) > 0 
            THEN
                CALL l_strbuf.append(p_position)
                CALL l_strbuf.replace("inch","",0)
                CALL l_strbuf.replace("in","",0)
                LET l_str = l_strbuf.toString()
                LET l_val = l_str
                LET l_val = l_val * 2.54
            ELSE
                TRY
                    LET l_val = p_position
                    LET l_val = l_val * 2.54 / 72
                CATCH
                    LET l_val = -1
                END TRY
            END IF            
        END IF
    END IF
    RETURN l_val
END FUNCTION
