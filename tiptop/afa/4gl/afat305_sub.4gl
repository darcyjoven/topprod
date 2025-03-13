# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: afat305_sub.4gl
# Description....: 提供afat305.4gl使用的sub routine
# Date & Author..: 09/02/26 by sabrina
# Modify.........: FUN-910038 09/02/26 By sabrina 新建立
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
FUNCTION t305sub_y_chk(p_fee01)
DEFINE     p_fee01         LIKE fee_file.fee01
DEFINE     l_fee           RECORD LIKE fee_file.*
DEFINE     l_cnt           LIKE type_file.num5
 
   SELECT * INTO l_fee.* FROM fee_file WHERE fee01 = p_fee01
 
   LET g_success = 'Y'
 
   IF l_fee.fee01 IS NULL THEN
      CALL cl_err('',-400,0)
      LET g_success = 'N'
      RETURN
   END IF
   IF l_fee.feeconf !='N' THEN
      CALL cl_err('','9023',0)      
      LET g_success = 'N'
      RETURN
   END IF
   IF l_fee.feeacti = 'N' THEN
      CALL cl_err('','9028',0)      
      LET g_success = 'N'
      RETURN
   END IF
 
 #FUN-910038---easyflow---add---start---
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt
     FROM fef_file
    WHERE fef01 = p_fee01
 
   IF l_cnt = 0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',1)
      LET g_success = 'N'
      RETURN
   END IF
 #FUN-910038---easyflow---add---end---
END FUNCTION
 
FUNCTION t305sub_lock_cl()
 DEFINE l_forupd_sql STRING
 LET l_forupd_sql = "SELECT * FROM fee_file ",
                    "WHERE fee01 = ? FOR UPDATE "
 LET l_forupd_sql=cl_forupd_sql(l_forupd_sql)
 DECLARE t305sub_cl CURSOR FROM l_forupd_sql
END FUNCTION
 
FUNCTION t305sub_y_upd(l_fee01,p_action_choice)
 DEFINE     l_fee01         LIKE fee_file.fee01
 DEFINE     p_action_choice STRING
 DEFINE     l_feb12         LIKE feb_file.feb12
 DEFINE     l_fef           RECORD LIKE fef_file.*
 DEFINE     l_fef_t         RECORD LIKE fef_file.*
 DEFINE     l_fee           RECORD LIKE fee_file.*
 DEFINE     l_cnt           LIKE type_file.num5
 WHENEVER ERROR CONTINUE
 
  LET g_success = 'Y'
 
  SELECT * INTO l_fee.* FROM fee_file WHERE fee01 = l_fee01
  IF p_action_choice CLIPPED = "confirm" THEN     #按「確認」時
     IF l_fee.feemksg = 'Y' THEN
        IF l_fee.fee06 != '1' THEN
           CALL cl_err('','aws-078',1)
           LET g_success = 'N'
           RETURN
        END IF
     END IF
     IF NOT cl_confirm('axm-108') THEN RETURN END IF
  END IF
   BEGIN WORK
 
   CALL t305sub_lock_cl()
   OPEN t305sub_cl USING l_fee.fee01
   IF STATUS THEN
       CALL cl_err("OPEN t305sub_cl:", STATUS, 1)
       CLOSE t305sub_cl
       ROLLBACK WORK
       RETURN
   END IF
   FETCH t305sub_cl INTO l_fee.*               # 勤DB坶隅
   LET l_fee.feeconf = 'Y'
   UPDATE fee_file SET feeconf = l_fee.feeconf
                 WHERE fee01 = l_fee.fee01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fee_file",l_fee.fee01,"",SQLCA.sqlcode,"","",0)
      ROLLBACK WORK
      LET g_success = 'N'
      RETURN
   ELSE
      SELECT * INTO l_fef.* FROM fef_file WHERE fef01 = l_fee01
      SELECT feb12 INTO l_feb12 FROM feb_file
       WHERE feb02=l_fef.fef03
      DECLARE fef_cl CURSOR FOR SELECT * FROM fef_file WHERE fef01 = l_fee01
      FOREACH fef_cl INTO l_fef.* 
            IF l_feb12 IS NULL THEN 
               LET l_feb12 = 0 
            END IF
            IF l_fef.fef03 IS NOT NULL THEN   
              UPDATE feb_file SET feb12 = l_feb12-l_fef.fef04,
                                  feb09 = feb09 + 1
               WHERE feb02=l_fef.fef03
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                  CALL cl_err3("upd","feb_file",l_fef.fef03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660127
                  LET l_fef.* = l_fef_t.*
                  LET g_success='N'
               END IF
            END IF
      END FOREACH
   END IF   
   IF l_fee.feemksg = 'N' AND l_fee.fee06 = '0' THEN
      LET l_fee.fee06 = '1'
      UPDATE fee_file SET fee06 = l_fee.fee06 WHERE fee01 = l_fee.fee01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","fee_file",l_fee.fee01,"","apm-266","","upd fee_file",1)  #No.FUN-660129
         LET g_success = 'N'
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      SELECT COUNT(*) INTO l_cnt FROM fef_file
       WHERE fef01 = l_fee.fee01
      IF l_cnt = 0 AND l_fee.feemksg = 'Y' THEN
         CALL cl_err(' ','aws-065',0)
         LET g_success = 'N'
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      IF l_fee.feemksg = 'Y' THEN
         CASE aws_efapp_formapproval()
            WHEN 0  #呼叫 EasyFlow 簽核失敗
               LET l_fee.feeconf="N"
               LET g_success = "N"
               ROLLBACK WORK
               RETURN
            WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
               LET l_fee.feeconf="N"
               ROLLBACK WORK
               RETURN
         END CASE
      END IF
      IF g_success='Y' THEN
         LET l_fee.fee06='1'
         LET l_fee.feeconf='Y'
         COMMIT WORK
         CALL cl_flow_notify(l_fee.fee01,'Y')
         DISPLAY BY NAME l_fee.fee06
         DISPLAY BY NAME l_fee.feeconf
      ELSE
         LET l_fee.feeconf='N'
         LET g_success = 'N'
         ROLLBACK WORK
      END IF
   ELSE
      LET l_fee.feeconf='N'
      LET g_success = 'N'
      ROLLBACK WORK
   END IF
 
    CLOSE t305sub_cl
    COMMIT WORK
    DISPLAY BY NAME l_fee.feeconf
    DISPLAY BY NAME l_fee.fee06
   #CALL cl_set_field_pic("Y","","","","","")
END FUNCTION 
 
FUNCTION t305sub_refresh(p_fee01)
  DEFINE p_fee01 LIKE fee_file.fee01
  DEFINE l_fee RECORD LIKE fee_file.*
 
  SELECT * INTO l_fee.* FROM fee_file WHERE fee01 = p_fee01
  RETURN l_fee.*
END FUNCTION
 
