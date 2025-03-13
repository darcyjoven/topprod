# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_table_exist_plant.4gl
# Descriptions...: 判斷Table是否具有Plant欄位.
# Date & Author..: 2009/08/04 by Hiko
# Usage..........: CALL cl_table_exist_plant("oea_file")
# Modify.........: FUN-980030 09/08/04 By Hiko 新建程式
# Modify.........: FUN-A10068 10/01/13 By Hiko cl_table_exist_plant增加判斷:in 要增加AXC模組
# Modify.........: FUN-A50080 10/05/25 By Hiko 1.AXC模組歸到標準判斷,並將財務模組的部分也改在這邊統一管理.
# Modify.........:                             2.Table清單不要與gat_file勾稽,單純以zta_file為主.
# Modify.........: FUN-A70029 10/07/12 By Kevin synonym判斷zta09
# Modify.........: FUN-A70129 10/07/26 By Hiko 財務模組改為判斷gao05='Y'來取得gao01
 
DATABASE ds
 
GLOBALS "../../config/top.global"

#FUN-980030
 
##########################################################################
# Private Func...: FALSE
# Descriptions...: FOR GP5.2:判斷Table是否具有Plant欄位
# Input parameter: p_table  資料表名稱
# Return code....: l_result TRUE/FALSE
# Usage..........: CALL cl_chk_gat_plant(gac05)
# Date & Author..: 2009/09/16 by Hiko
##########################################################################
FUNCTION cl_table_exist_plant(p_table)
   DEFINE p_table  LIKE gat_file.gat01
   DEFINE l_gat_sql STRING,
          l_gat_cnt SMALLINT,
          l_result  BOOLEAN

   #FUN-A10068:成本一律以法人層級來RUN，若各門店自己要RUN成本，應採用分倉成本.

   LET l_result = FALSE
 
   #Begin:FUN-A50080
   #LET l_gat_sql = "SELECT COUNT(gat01) FROM gat_file",
   #                " WHERE gat01='",p_table CLIPPED,"'",
   #                " AND gat07 IN ('T','S')",
   #                " AND gat06 NOT IN (",cl_get_view_not_in(),")" #FUN-A50080
   LET l_gat_sql = "SELECT COUNT(zta01) FROM zta_file",
                   " WHERE zta01='",p_table CLIPPED,"'",
                   " AND zta09 IN ('T','S')",
                   " AND zta03 NOT IN (",cl_get_view_not_in(),")"
   #End:FUN-A50080
   DECLARE gat_curs SCROLL CURSOR FROM l_gat_sql
   IF (SQLCA.SQLCODE) THEN
      RETURN FALSE
   END IF

   OPEN gat_curs
   FETCH FIRST gat_curs INTO l_gat_cnt
   IF l_gat_cnt>0 THEN
      LET l_result = TRUE
   END IF
      
   RETURN l_result
END FUNCTION

##########################################################################
# Private Func...: FALSE
# Descriptions...: FOR GP5.2:回傳不是View的模組清單的not in條件
# Input parameter: none
# Return code....: STRING
# Usage..........: CALL cl_get_view_not_in()
# Date & Author..: 2009/11/04 by Hiko
##########################################################################
FUNCTION cl_get_view_not_in()
   DEFINE l_view_not_in STRING

   LET l_view_not_in = cl_get_finance_in(),",'AXC','GXC','CXC','CGXC','AIN'" 
   RETURN l_view_not_in #FUN-A50080:AXC,GXC沒有xxxplant欄位.
END FUNCTION

##########################################################################
# Private Func...: FALSE
# Descriptions...: FOR GP5.2:取得財務模組in條件
# Input parameter: none
# Return code....: STRING
# Usage..........: CALL cl_get_finance_in()
# Date & Author..: 2010/05/27 by Hiko
##########################################################################
FUNCTION cl_get_finance_in()
   DEFINE l_finance_in STRING
   #Begin:#FUN-A70129
   DEFINE l_gao_arr DYNAMIC ARRAY OF RECORD
                    gao01 LIKE gao_file.gao01
                    END RECORD,
          l_i SMALLINT
   DEFINE l_gao_buf base.StringBuffer

   LET l_gao_buf = base.StringBuffer.create()

   DECLARE gao_cs CURSOR FOR SELECT gao01 FROM gao_file WHERE gao05='Y' ORDER BY gao01
   LET l_i = 1
   FOREACH gao_cs INTO l_gao_arr[l_i].*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('FOREACH:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF

      LET l_finance_in = "'",l_gao_arr[l_i].gao01 CLIPPED,"'"
      IF l_gao_buf.getLength()>0 THEN
         LET l_finance_in = ",",l_finance_in
      END IF

      CALL l_gao_buf.append(l_finance_in)

      LET l_i = l_i + 1
   END FOREACH

   #LET l_finance_in = "'AAP','AXR','AFA','ANM','AGL','AMD',",
   #                   "'GAP','GXR','GFA','GNM','GGL','GIS',",            
   #                   "'CAP','CXR','CFA','CNM','CGL','CMD',",            
   #                   "'CGAP','CGXR','CGFA','CGNM','CGGL','CGIS',",            
   #                   "'AOO','GOO','COO','CGOO'" #AOO並非財務模組,但因為作法相同,所以在這邊設定.
   #RETURN l_finance_in #FUN-A50080:AXC,GXC和一般的財務模組不同,不需要Synonym for法人DB.
   LET l_finance_in = l_gao_buf.toString(),",'AOO','GOO','COO','CGOO'" #AOO並非財務模組,但因為作法相同,所以在這邊設定.
   #End:#FUN-A70129
   RETURN l_finance_in
END FUNCTION

##########################################################################
# Private Func...: FALSE
# Descriptions...: FOR GP5.2:回傳取得View清單的SQL
# Input parameter: p_zta02 STRING
# Return code....: STRING
# Usage..........: CALL cl_get_view_sql
# Date & Author..: 2009/11/04 by Hiko
##########################################################################
FUNCTION cl_get_view_sql(p_zta02)
   DEFINE p_zta02 LIKE zta_file.zta02
   DEFINE l_view_sql STRING

   #Begin:FUN-A50080
   #LET l_view_sql = "SELECT gat01 FROM gat_file",
   #                 " WHERE gat07 IN('T','S')",
   #                 "   AND gat02='",g_lang,"'",
   #                 "   AND gat06 NOT IN(",cl_get_view_not_in(),")",
   #                 " ORDER BY 1"
   LET l_view_sql = "SELECT zta01 FROM zta_file",
                    " WHERE zta02='",p_zta02 CLIPPED,"'",
                    "   AND zta09 IN('T','S')",
                    "   AND zta03 NOT IN(",cl_get_view_not_in(),")",
                    " ORDER BY 1"
   #End:FUN-A50080
   RETURN l_view_sql
END FUNCTION

##########################################################################
# Private Func...: FALSE
# Descriptions...: FOR GP5.2:回傳取得Synonym清單的SQL
# Input parameter: p_zta02 STRING
# Return code....: STRING
# Usage..........: CALL cl_get_syn_sql
# Date & Author..: 2009/11/04 by Hiko
##########################################################################
FUNCTION cl_get_syn_sql(p_zta02)
   DEFINE p_zta02 LIKE zta_file.zta02
   DEFINE l_syn_sql STRING

   #Begin:FUN-A50080
   #LET l_syn_sql = "SELECT gat01 FROM gat_file",
   #                " WHERE gat01 NOT IN(",
   #                        "SELECT gat01 FROM gat_file",
   #                        " WHERE gat07 IN('T','S')",
   #                        "   AND gat02='",g_lang,"'",
   #                        "   AND gat06 NOT IN(",cl_get_view_not_in(),"))",
   #                "   AND gat02='",g_lang,"'",
   #                " ORDER BY 1"
   LET l_syn_sql = "SELECT zta01,zta09 FROM zta_file", #FUN-A70029
                   " WHERE zta01 NOT IN(",
                           "SELECT zta01 FROM zta_file",
                           " WHERE zta02='",p_zta02 CLIPPED,"'",
                           "   AND zta09 IN('T','S')",
                           "   AND zta03 NOT IN(",cl_get_view_not_in(),"))",
                   "   AND zta02='",p_zta02 CLIPPED,"'",
                   " ORDER BY 1"
   #End:FUN-A50080
   RETURN l_syn_sql
END FUNCTION
