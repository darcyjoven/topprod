# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_costcenter.4gl
# Descriptions...: 此函數用來取得新增時,預設的成本中心
# Date & Author..: 06/07/13 by kim
# Memo...........: GP3.5利潤中心,採購為例:先依採購單單身的請購單的部門為優先的成本中心,
#                                         若無,則以採購單單頭的採購部門所屬的成本中心
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6C0017 06/12/14 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_costcenter(p_dept)
DEFINE p_dept    LIKE gem_file.gem10,
       l_res     LIKE gem_file.gem10
 
   IF (g_aaz.aaz90<>'Y') OR (g_aaz.aaz90 IS NULL) THEN
      RETURN NULL
   END IF
   SELECT gem10 INTO l_res FROM gem_file
                          WHERE gem01=p_dept
   IF SQLCA.sqlcode THEN
      LET l_res=NULL
   END IF
   RETURN l_res
END FUNCTION
 
# Descriptions...: 檢查Cost Center,Reture True->check pass! Else Return g_errno and raise it!
 
FUNCTION s_costcenter_chk(p_costcenter)
DEFINE p_costcenter LIKE gem_file.gem01
DEFINE l_gem09   LIKE gem_file.gem09
DEFINE l_gemacti LIKE gem_file.gemacti
 
   IF cl_null(p_costcenter) THEN
      RETURN TRUE
   END IF
   LET g_errno=NULL
   SELECT gemacti,gem09 INTO l_gemacti,l_gem09 FROM gem_file
                                              WHERE gem01=p_costcenter
   CASE
      WHEN SQLCA.sqlcode
         LET g_errno=SQLCA.sqlcode
      WHEN l_gemacti='N'
         LET g_errno='9028'
      WHEN l_gem09 NOT MATCHES '[1,2]'
         LET g_errno='aoo-026'
      OTHERWISE
         RETURN TRUE
   END CASE
   CALL cl_err3("sel","gem_file",p_costcenter,"",g_errno,"","",1)
   RETURN FALSE
END FUNCTION
 
# Descriptions...: 取得成本中心的簡稱
 
FUNCTION s_costcenter_desc(p_costcenter)
DEFINE p_costcenter LIKE gem_file.gem01
DEFINE l_gem02      LIKE gem_file.gem02
 
   IF cl_null(p_costcenter) THEN
      RETURN NULL
   END IF
   SELECT gem02 INTO l_gem02 FROM gem_file 
                            WHERE gem01=p_costcenter
   IF SQLCA.sqlcode THEN
      LET l_gem02=NULL
   END IF
   RETURN l_gem02
END FUNCTION
 
# Descriptions...: For AAP Get apa903 ->IF apa51='STOCK' return p_rvv930,else RETURN p_dept所屬成本中心
 
FUNCTION s_costcenter_stock_apa(p_apa22,p_rvv930,p_apa51)
 
DEFINE p_apa22    LIKE gem_file.gem10,
       p_rvv930  LIKE rvv_file.rvv930,
       p_apa51   LIKE apa_file.apa51
 
   IF (g_aaz.aaz90<>'Y') OR (g_aaz.aaz90 IS NULL) THEN
      RETURN NULL
   END IF
   CASE
      WHEN (p_apa51='STOCK') OR (p_apa51='stock')
         RETURN p_rvv930
      OTHERWISE
         RETURN s_costcenter(p_apa22)
   END CASE
END FUNCTION
 
# Descriptions...: For AAP Get apb903 ->IF apa51='STOCK' return p_rvv930,else RETURN p_apa930
 
FUNCTION s_costcenter_stock_apb(p_apa930,p_rvv930,p_apa51)
 
DEFINE p_apa930  LIKE apa_file.apa930,
       p_rvv930  LIKE rvv_file.rvv930,
       p_apa51   LIKE apa_file.apa51
 
   IF (g_aaz.aaz90<>'Y') OR (g_aaz.aaz90 IS NULL) THEN
      RETURN NULL
   END IF
   CASE
      WHEN (p_apa51='STOCK') OR (p_apa51='stock')
         RETURN p_rvv930
      OTHERWISE
         RETURN p_apa930
   END CASE
END FUNCTION
