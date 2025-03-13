# Prog. Version..: '5.30.06-13.04.22(00001)'     #
# Pattern name...: s_ibj_ins_tlfb.4gl
# Descriptions...: 將出通掃描的條碼資料(ibj_file)拋至(tlfb_file)及異動imgb_file
# Date & Author..: No:DEV-D40016 13/04/22 By Mandy
# Usage..........: CALL s_ibj_ins_tlfb(p_prog,p_ibj06,p_oga01)
# Input Parameter: p_prog :程式代號
#                  p_ibj06:出通單據編號
#                  p_oga01:出貨單據編號
# Return Code....: 
# Modify.........: No:WEB-D40006 13/04/22 By Mandy 程式無調整,過單用

DATABASE ds
GLOBALS "../../config/top.global"
GLOBALS "../../aba/4gl/barcode.global"


FUNCTION s_ibj_ins_tlfb(p_prog,p_ibj06,p_oga01)
DEFINE p_prog     LIKE ibj_file.ibj11        #程式代號
DEFINE p_ibj06    LIKE ibj_file.ibj06        #來源單號=>出通單據編號
DEFINE p_oga01    LIKE oga_file.oga01        #來源單號=>出貨單據編號
DEFINE l_ibj      RECORD LIKE ibj_file.*
DEFINE l_tlfb     RECORD LIKE tlfb_file.*
DEFINE l_sql      STRING
DEFINE l_cnt      LIKE type_file.num10
DEFINE l_pdacnt   LIKE type_file.num10
DEFINE l_tlfb15   LIKE tlfb_file.tlfb15

   WHENEVER ERROR CALL cl_err_msg_log

   IF cl_null(p_prog) OR cl_null(p_ibj06) OR cl_null(p_oga01) THEN
      RETURN
   END IF

   SELECT * INTO g_ibd.* FROM ibd_file WHERE ibd01 = '0'
   IF SQLCA.SQLCODE THEN
       CALL cl_err('','aba-000',1)
       RETURN
   END IF

   #出通自動產生出貨單
   IF cl_null(g_ibd.ibd09) OR g_ibd.ibd09 = 'N' THEN
       RETURN
   END IF

   LET g_success = "Y"

   LET l_pdacnt = 0
   SELECT COUNT(*) INTO l_pdacnt
     FROM tlfb_file
    WHERE tlfb07 = p_oga01    
      AND tlfb11 = 'axmt620'
   IF cl_null(l_pdacnt) THEN
       LET l_pdacnt = 0
   END IF
   IF l_pdacnt >=1 THEN
       RETURN
   END IF

   LET l_sql = "SELECT * FROM ibj_file ",
               " WHERE ibj11 = '",p_prog, "'", #程式代號
               "   AND ibj06 = '",p_ibj06,"'"  #來源單號

   LET l_sql = l_sql CLIPPED," ORDER BY ibj06,ibj07 "

   PREPARE ibj_ins_tlfb_pre FROM l_sql
   DECLARE ibj_ins_tlfb_cur CURSOR FOR ibj_ins_tlfb_pre

   INITIALIZE l_ibj.* TO NULL
   LET l_tlfb15 = ''
   FOREACH ibj_ins_tlfb_cur INTO l_ibj.*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach ibj_ins_tlfb_cur:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF

      INITIALIZE g_tlfb.* TO NULL
      LET g_tlfb.tlfb01 = l_ibj.ibj02  #條碼編號
      LET g_tlfb.tlfb02 = l_ibj.ibj03  #倉庫
      LET g_tlfb.tlfb03 = l_ibj.ibj04  #儲位
      LET g_tlfb.tlfb04 = ' '          #批號
      LET g_tlfb.tlfb05 = l_ibj.ibj05  #異動數量
      LET g_tlfb.tlfb06 = -1           #異動類型:出:(-1)
      LET g_tlfb.tlfb07 = p_oga01      #來源單號
      LET g_tlfb.tlfb08 = l_ibj.ibj07  #來源項次
      LET g_tlfb.tlfb09 = ''
      LET g_tlfb.tlfb10 = ''
      LET g_tlfb.tlfb11 = 'axmt620'
      LET g_tlfb.tlfb15 = l_tlfb15  #時間(時:分:秒.毫秒)

      CALL s_tlfb('','','','','')

      IF g_success = 'Y' THEN
         #寫入imgb_file
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM imgb_file
          WHERE imgb01 = g_tlfb.tlfb01
            AND imgb02 = g_tlfb.tlfb02
            AND imgb03 = g_tlfb.tlfb03
            AND imgb04 = g_tlfb.tlfb04
         IF l_cnt = 0 THEN #没有imgb_file，新增imgb_file
            CALL s_ins_imgb(g_tlfb.tlfb01,
                            g_tlfb.tlfb02,g_tlfb.tlfb03,g_tlfb.tlfb04,
                            0,'','')
         END IF
      
         IF g_success = 'Y' THEN
            CALL s_up_imgb(g_tlfb.tlfb01,
                           g_tlfb.tlfb02,g_tlfb.tlfb03,g_tlfb.tlfb04,
                           g_tlfb.tlfb05,g_tlfb.tlfb06,'')
         END IF
      END IF
      INITIALIZE l_ibj.* TO NULL
      LET l_tlfb15 = g_tlfb.tlfb15
  END FOREACH
END FUNCTION
#WEB-D40006 add
