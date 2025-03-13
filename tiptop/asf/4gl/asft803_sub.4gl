# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: asft803_sub.4gl
# Descriptions...: 工單單身變更作業
# Date & Author..: FUN-920208 09/03/06 By sabrina 將簽核段判斷及處理簽核段拆解出sub
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A10013 10/03/15 By Lilan 修改sub的函式名稱
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE l_snb           RECORD LIKE snb_file.*
 
#作用:lock cursor
#回傳值:無

FUNCTION t803sub_lock_cl()
   DEFINE l_forupd_sql STRING
   LET l_forupd_sql = "SELECT * FROM snb_file WHERE snb01 = ? AND snb02 = ?  FOR UPDATE "
   LET l_forupd_sql=cl_forupd_sql(l_forupd_sql)

   DECLARE t803sub_cl CURSOR FROM l_forupd_sql
END FUNCTION
 
#FUNCTION t803_y_chk(p_snb01,p_snb02)      #FUN-A10013 mark
FUNCTION t803sub_y_chk(p_snb01,p_snb02)    #FUN-A10013 add
 DEFINE p_snb01   LIKE snb_file.snb01,
        p_snb02   LIKE snb_file.snb02
 
   LET g_success = 'Y'
 
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO l_snb.* FROM snb_file WHERE snb01 = p_snb01 AND snb02 = p_snb02
 
   IF cl_null(l_snb.snb01) THEN CALL cl_err('',-400,0) RETURN END IF
   IF l_snb.snbconf = 'X' THEN
      CALL cl_err(l_snb.snb01,'9024',0)
      LET g_success = 'N'   
      RETURN
   END IF
END FUNCTION

#FUNCTION t803_y_upd(p_snb01,p_snb02)      #FUN-A10013 mark
FUNCTION t803sub_y_upd(p_snb01,p_snb02)    #FUN-A10013 add 
 DEFINE p_snb01   LIKE snb_file.snb01,
        p_snb02   LIKE snb_file.snb02
 
   LET g_success = 'Y'
 
   SELECT * INTO l_snb.* FROM snb_file WHERE snb01 = p_snb01 AND snb02 = p_snb02
 
   BEGIN WORK
 
   CALL t803sub_lock_cl()
   OPEN t803sub_cl USING l_snb.snb01,l_snb.snb02
   IF STATUS THEN
      LET g_success = 'N'
      CALL cl_err("OPEN t803sub_cl:", STATUS, 1)
      CLOSE t803sub_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t803sub_cl INTO l_snb.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL cl_err(l_snb.snb01,SQLCA.sqlcode,0)
      CLOSE t803sub_cl
      ROLLBACK WORK
      RETURN
   END IF
   IF g_success = 'Y' THEN
      IF l_snb.snbmksg = 'Y' THEN
         CASE aws_efapp_formapproval()
              WHEN 0  #呼叫 EasyFlow 簽核失敗
                   LET g_success = "N"
                   ROLLBACK WORK
                   RETURN
              WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                   ROLLBACK WORK
                   RETURN
         END CASE
      END IF
      IF g_success='Y' THEN
         LET l_snb.snb99='1'
         COMMIT WORK
         CALL cl_flow_notify(l_snb.snb01,'Y')
      ELSE
         LET g_success = 'N'
         ROLLBACK WORK
      END IF
   ELSE
      LET g_success = 'N'
      ROLLBACK WORK
   END IF
 
END FUNCTION
 
FUNCTION t803sub_refresh(p_snb01)
  DEFINE p_snb01 LIKE snb_file.snb01
  DEFINE l_snb RECORD LIKE snb_file.*
 
  SELECT * INTO l_snb.* FROM snb_file WHERE snb01=p_snb01
  RETURN l_snb.*
END FUNCTION
