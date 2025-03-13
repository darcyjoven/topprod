# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: apsp701.4gl
# Descriptions...: APS TIPTOP佇列管理員
# Date & Author..: 08/07/11 By Kevin #FUN-870068 更新 vzy_file from vzv_file
# Modify.........: FUN-8B0086 08/11/19 By Duke  加入資料庫刪除 90 段
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0072 10/01/13 By vealxu 精簡程式碼
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B50020 GP5.1追版至GP5.25 ,以下為GP5.1 zl單號 ------
# Modify.........: TQC-930131 09/03/20 By Duke 原迴圈掃瞄資料改判斷當aps 資料回饋時即stop
# Modify.........: TQC-990036 09/09/09 By Mandy (1)程式無窮迴圈,離開FOREACH應寫EXIT FOREACH 非RETUR
#                                               (2)將DECLARE vaz_file_cs CURSOR搬出p701_scan_data()
# Modify.........: TQC-990063 09/09/15 By Mandy 新增和刪除成功時,g_success的改變
# Modify.........: FUN-9B0065 09/11/10 By Mandy (1)可接收外部傳入參數
#                                               (2)掃到刪除完成情況後,再刪除相關table資料
# Modify.........: No:CHI-A70049 10/07/28 By Pengu 將多餘的DISPLAY程式mark
# Modify.........: No:FUN-B50020 end ----------------------------------------
# Modify.........: No:FUN-BC0114 12/11/30 By Nina  在UPDATE vzv_file的地方，增加條件vzv03,vzv04,vzv06
# Modify.........: No:TQC-CC0080 12/12/14 By Nina  將DEFINE l_vzv03  LIKE vzv_file.vzv03改成DEFINE l_vzv03  DATETIME YEAR TO SECOND
 
DATABASE ds

GLOBALS "../../config/top.global"
 
DEFINE g_argv1       LIKE vzy_file.vzy01      #APS 版本     #FUN-9B0065 add
DEFINE g_argv2       LIKE vzy_file.vzy02      #APS 儲存版本 #FUN-9B0065 add


MAIN
   DEFINE   l_i          LIKE type_file.num5
   DEFINE   l_sql        STRING #TQC-990036 add
   
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT

   LET g_argv1 = ARG_VAL(1) #FUN-9B0065 add
   LET g_argv2 = ARG_VAL(2) #FUN-9B0065 add
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   LET l_i = 1
   LET g_success='N'   
  #WHILE l_i < 13
  #	    CALL p701_scan_data(l_i)
  #	    SLEEP 5
  #	    LET l_i = l_i + 1   	    
  #END WHILE

   #TQC-990036---add----str---
   LET l_sql = "SELECT vzv01,vzv02,vzv03,vzv04,vzv06 FROM vzv_file  ",
               " WHERE vzv07 ='N' ",
               "   AND vzv00 ='",g_plant,"'",
               "   AND vzv04 IN ('01','90') ",
               " ORDER BY vzv01,vzv02,vzv03,vzv04"
  #DISPLAY l_sql                                             #CHI-A70049 mark
   PREPARE aps_vzv_file FROM l_sql
   DECLARE vaz_file_cs CURSOR FOR aps_vzv_file
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','vzv_file','','',SQLCA.sqlcode,'','',0)
      EXIT PROGRAM
   END IF
   #TQC-990036---add----end---

   #TQC-930131  ADD  --STR--
   WHILE  g_success='N'
           CALL p701_scan_data(l_i)
          #DISPLAY "l_i=",l_i," ****** g_success=",g_success #TQC-990036 add  #CHI-A70049 mark
           SLEEP 5
           LET l_i = l_i + 1
           #FUN-9B0065---add----str----
           IF g_success = 'D' THEN
               CALL s_del_aps_data(g_plant,g_argv1,g_argv2)
           END IF
           #FUN-9B0065---add----end----
   END WHILE
   #TQC-930131   ADD  --END--

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
 
FUNCTION p701_scan_data(p_i)
DEFINE l_sql    STRING
DEFINE l_status LIKE type_file.chr1
DEFINE l_vzv01  LIKE vzv_file.vzv01,  
       l_vzv02  LIKE vzv_file.vzv02,
      #l_vzv03  LIKE vzv_file.vzv03,      #TQC-CC0080 mark
       l_vzv03  DATETIME YEAR TO SECOND,  #TQC-CC0080 add
       l_vzv04  LIKE vzv_file.vzv04,
       l_vzv06  LIKE vzv_file.vzv06,       
       l_vzu07  LIKE vzu_file.vzu07
DEFINE p_i    LIKE type_file.num5       
 
   FOREACH vaz_file_cs INTO l_vzv01,l_vzv02,l_vzv03,l_vzv04,l_vzv06
       IF l_vzv04='01' THEN
          UPDATE vzy_file      #更新多廠資料
             SET vzy10=l_vzv06
           WHERE vzy00=g_plant
             AND vzy01=l_vzv01
             AND vzy02=l_vzv02

          IF SQLCA.SQLCODE THEN
             CALL cl_err3('upd','vzy_file','','',SQLCA.sqlcode,'','',1)
          END IF

         UPDATE vzv_file
            SET vzv07= 'Y'         #回寫狀態碼
         #WHERE ROWID= g_vzv_rowid #FUN-B50020 mark      
           WHERE vzv00=g_plant     #FUN-B50020 add
             AND vzv01=l_vzv01     #FUN-B50020 add
             AND vzv02=l_vzv02     #FUN-B50020 add
             AND vzv03=l_vzv03     #FUN-BC0114 add
             AND vzv04=l_vzv04     #FUN-BC0114 add
             AND vzv06=l_vzv06     #FUN-BC0114 add

         IF SQLCA.SQLCODE THEN
            CALL cl_err3('upd','vzv_file','','',SQLCA.sqlcode,'','',1)
         END IF

         IF l_vzv06 = "Y" OR l_vzv06 = "F" THEN
            LET g_success = 'A'                             #TQC-990063 mod
           #RETURN                          #TQC-990036 mark
           #EXIT FOREACH                    #TQC-990036     #TQC-990063 mark
         END IF
       END IF

       #FUN-8B0086 ADD---------------------------------------------------
       IF l_vzv04='90' THEN
          IF l_vzv06='Y' THEN            #FUN-9B0065 mark
             UPDATE vzy_file      #更新多廠資料
                SET vzy10='D',    #D:APS刪除完成
                    vzy12=sysdate
              WHERE vzy00=g_plant
                AND vzy01=l_vzv01
                AND vzy02=l_vzv02
          ELSE
            #IF l_vzv06='F'THEN             #FUN-9B0065 mark
             IF l_vzv06 MATCHES "[FN]" THEN #FUN-9B0065 add
                UPDATE vzy_file      #更新多廠資料
                   SET vzy10='L', #L:APS刪除失敗
                       vzy12=sysdate
                 WHERE vzy00=g_plant
                   AND vzy01=l_vzv01
                   AND vzy02=l_vzv02
             END IF
          END IF

         #IF SQLCA.SQLCODE THEN                                              #FUN-9B0065 mark
          IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3] = 0 THEN                      #FUN-9B0065 add
             CALL cl_err3('UPDATE','vzy_file','','',SQLCA.sqlcode,'','',1)   #FUN-9B0065 mod
          END IF

          UPDATE vzv_file
             SET vzv07= 'Y'      #回寫狀態碼
           WHERE vzv00=g_plant   
             AND vzv01=l_vzv01   
             AND vzv02=l_vzv02   
             AND vzv03=l_vzv03     #FUN-BC0114 add
             AND vzv04=l_vzv04     #FUN-BC0114 add
             AND vzv06=l_vzv06     #FUN-BC0114 add

         #IF SQLCA.SQLCODE THEN                                              #FUN-9B0065 mark
          IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3] = 0 THEN                      #FUN-9B0065 add
             CALL cl_err3('upd','vzv_file','','',SQLCA.sqlcode,'','',1)
          END IF

         #IF l_vzv06 = "Y" OR l_vzv06 = "F" THEN  #FUN-9B0065 mark
          IF l_vzv06 MATCHES "[YNF]" THEN           #FUN-9B0065 add
            #FUN-9B0065 ---add----str---
             IF g_argv2 <> '0' THEN
                 LET g_success='D'
             ELSE
                 IF l_vzv02 = '0' THEN
                     #由apss300按"APS資料庫刪除"時,
                     #一定要等到接收到APS回傳儲存版本為'0'的訊息後才去停止apsp701
                     LET g_success='D'
                 END IF
             END IF
            #FUN-9B0065 ---add----end---
            #LET g_success='D'             #TQC-990063 mod #FUN-9B0065 mark
            #RETURN       #TQC-990036 mark
            #EXIT FOREACH #TQC-990036 add  #TQC-990063 mark
          END IF
       END IF
       #FUN-8B0086 -----------------------------------------------------


       IF p_i = 12 AND g_success = 'N' THEN
          UPDATE vzv_file
             SET vzv07= 'F' ##Timeout回寫狀態碼失敗
           WHERE vzv00=g_plant
             AND vzv01=l_vzv01
             AND vzv02=l_vzv02
             AND vzv03=l_vzv03     #FUN-BC0114 add
             AND vzv04=l_vzv04     #FUN-BC0114 add
             AND vzv06=l_vzv06     #FUN-BC0114 add

          IF SQLCA.SQLCODE THEN
             CALL cl_err3('upd','vzv_file','','',SQLCA.sqlcode,'','',1)
          END IF
       END IF
   END FOREACH
      
END FUNCTION  
#No.FUN-9C0072 精簡程式碼
