# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: afat300_sub.4gl
# Description....: 提供afat300.4gl使用的sub routine
# Date & Author..: 09/02/26 by sabrina
# Modify.........: FUN-910038 09/02/26 By sabrina 新建立
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
FUNCTION t300sub_y_chk(p_fec01) 
DEFINE     p_fec01         LIKE fec_file.fec01      #FUN-910038 add
DEFINE     l_feb12_t       LIKE feb_file.feb12
DEFINE     l_feb12         LIKE feb_file.feb12
DEFINE     l_fec           RECORD LIKE fec_file.*   #FUN-910038 add
DEFINE     l_cnt           LIKE type_file.num5      #FUN-910038 add 
 
   SELECT * INTO l_fec.* FROM fec_file WHERE fec01 = p_fec01    #FUN-910038
 
   LET g_success = 'Y'    #FUN-910038 add
 
   IF l_fec.fec01 IS NULL THEN
      CALL cl_err('',-400,0)
      LET g_success = 'N'     #FUN-910038 add
      RETURN
   END IF
   IF l_fec.fecconf !='N' THEN
      CALL cl_err('','9023',0)      
      LET g_success = 'N'     #FUN-910038 add
      RETURN
   END IF
   IF l_fec.fecacti = 'N' THEN
      CALL cl_err('','9028',0)      
      LET g_success = 'N'     #FUN-910038 add
      RETURN
   END IF
 
  #FUN-910038---easyflow---add---start---
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt
     FROM fed_file
    WHERE fed01 = p_fec01
   
   IF l_cnt = 0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',1)
      LET g_success = 'N'
      RETURN
   END IF
  #FUN-910038---easyflow---add---end---
END FUNCTION
 
#FUN-910038---easyflow---add---start---
FUNCTION t300sub_lock_cl()
  DEFINE l_forupd_sql STRING
  LET l_forupd_sql = "SELECT * FROM fec_file ",
                     "WHERE fec01 = ? FOR UPDATE "
  LET l_forupd_sql=cl_forupd_sql(l_forupd_sql)
  DECLARE t300sub_cl CURSOR FROM l_forupd_sql
END FUNCTION
 
FUNCTION t300sub_y_upd(l_fec01,p_action_choice)
  DEFINE     l_fec01         LIKE fec_file.fec01
  DEFINE     p_action_choice STRING
  DEFINE     l_feb12         LIKE feb_file.feb12
  DEFINE     l_fec           RECORD LIKE fec_file.*
  DEFINE     l_fed           RECORD LIKE fed_file.*
  DEFINE     l_cnt           LIKE type_file.num5
  WHENEVER ERROR CONTINUE
 
   LET g_success = 'Y'
 
   SELECT * INTO l_fec.* FROM fec_file WHERE fec01 = l_fec01
   IF p_action_choice CLIPPED = "confirm" THEN     #按「確認」時
      IF l_fec.fecmksg = 'Y' THEN
         IF l_fec.fec06 != '1' THEN
            CALL cl_err('','aws-078',1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
      IF NOT cl_confirm('axm-108') THEN RETURN END IF
   END IF
 #FUN-910038---easyflow---add---end---
   BEGIN WORK
 
   CALL t300sub_lock_cl()              #FUN-910038 add
   OPEN t300sub_cl USING l_fec.fec01
   IF STATUS THEN
       CALL cl_err("OPEN t300sub_cl:", STATUS, 1)
       CLOSE t300sub_cl
       ROLLBACK WORK
       RETURN
   END IF
   FETCH t300sub_cl INTO l_fec.*               # 勤DB坶隅
   LET l_fec.fecconf = 'Y'
   LET l_fec.fec06 = '1'
 
   UPDATE fec_file SET fecconf = l_fec.fecconf, fec06 = l_fec.fec06    
                    WHERE fec01 = l_fec.fec01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fec_file",l_fec.fec01,"",SQLCA.sqlcode,"","",0)
      ROLLBACK WORK
      RETURN
   ELSE
     #FUN-910038---start---
      #要使用FOREACH寫法，不然單身的資料沒辦法每筆回傳給afai300
       SELECT * INTO l_fed.* FROM fed_file WHERE fed01 = l_fec01
 
       DECLARE fed_cl CURSOR FOR SELECT * FROM fed_file WHERE fed01 = l_fec01
 
       FOREACH fed_cl INTO l_fed.*
          SELECT feb12 INTO l_feb12 FROM feb_file
           WHERE feb02 = l_fed.fed03
          IF l_feb12 IS NULL THEN
             LET l_feb12 = 0
          END IF
 
          IF l_fed.fed03 IS NOT NULL THEN
             UPDATE feb_file SET feb12 = l_feb12 + l_fed.fed04
              WHERE feb02 = l_fed.fed03
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                CALL cl_err3("upd","feb_file",l_fed.fed03,"",SQLCA.sqlcode,"","",1)
             END IF
          END IF
       END FOREACH
   END IF
        # IF l_fed03 = l_fed03t THEN
        #    SELECT feb12 INTO l_feb12_t FROM feb_file
        #     WHERE feb02=l_fed03t
        #    IF l_feb12_t IS NULL THEN
        #       LET l_feb12_t = 0
        #    END IF
        #    UPDATE feb_file SET feb12
        #          =l_feb12_t + l_fed04 - l_fed04t
        #     WHERE feb02=l_fed03t
        # ELSE
        #     SELECT feb12 INTO l_feb12_t FROM feb_file
        #      WHERE feb02=l_fed03t
        #     IF l_feb12_t IS NULL THEN
        #        LET l_feb12_t = 0
        #     END IF
        #     SELECT feb12 INTO l_feb12 FROM feb_file
        #      WHERE feb02=l_fed03
        #     IF l_feb12 IS NULL THEN
        #         LET l_feb12 = 0
        #     END IF
        #     UPDATE feb_file SET feb12
        #          = l_feb12 + l_fed04
        #      WHERE feb02=l_fed03
        #      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
        #         CALL cl_err3("upd","feb_file",l_fed03,"",SQLCA.sqlcode,"","",1)  # FUN-660136
        #      ELSE
        #        { UPDATE feb_file SET feb12
        #              = l_feb12_t - l_fed04t
        #          WHERE feb02=l_fed03t
        #         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
        #            CALL cl_err3("upd","feb_file",l_fed03t,"",SQLCA.sqlcode,"","",1)  # FUN-660136           
        #         ELSE
        #            COMMIT WORK
        #         END IF}
        #      END IF
        # END IF
 
   IF l_fec.fecmksg = 'N' AND l_fec.fec06 = '0' THEN
      LET l_fec.fec06 = '1'
      UPDATE fec_file SET fec06 = l_fec.fec06 WHERE fec01 = l_fec.fec01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","fec_file",l_fec.fec01,"","apm-266","","upd fec_file",1) 
         LET g_success = 'N'
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      SELECT COUNT(*) INTO l_cnt FROM fed_file
       WHERE fed01 = l_fec.fec01
      IF l_cnt = 0 AND l_fec.fecmksg = 'Y' THEN
         CALL cl_err(' ','aws-065',0)
         LET g_success = 'N'
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      IF l_fec.fecmksg = 'Y' THEN
         CASE aws_efapp_formapproval()
            WHEN 0  #呼叫 EasyFlow 簽核失敗
               LET l_fec.fecconf="N"
               LET g_success = "N"
               ROLLBACK WORK
               RETURN
            WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
               LET l_fec.fecconf="N"
               ROLLBACK WORK
               RETURN
         END CASE
      END IF
      IF g_success='Y' THEN
         LET l_fec.fec06='1'
         LET l_fec.fecconf='Y'
         COMMIT WORK
         CALL cl_flow_notify(l_fec.fec01,'Y')
         DISPLAY BY NAME l_fec.fec06
         DISPLAY BY NAME l_fec.fecconf
      ELSE
         LET l_fec.fecconf='N'
         LET g_success = 'N'
         ROLLBACK WORK
      END IF
   ELSE
      LET l_fec.fecconf='N'
      LET g_success = 'N'
      ROLLBACK WORK
   END IF
     #FUN-910038---end---
   CLOSE t300sub_cl
   COMMIT WORK
   DISPLAY BY NAME l_fec.fecconf
   DISPLAY BY NAME l_fec.fec06
  #CALL cl_set_field_pic("Y","","","","","")       #FUN-910038
END FUNCTION 
 
FUNCTION t300sub_refresh(p_fec01)
DEFINE p_fec01 LIKE fec_file.fec01
DEFINE l_fec RECORD LIKE fec_file.*
 
SELECT * INTO l_fec.* FROM fec_file WHERE fec01 = p_fec01
RETURN l_fec.*
END FUNCTION
 
