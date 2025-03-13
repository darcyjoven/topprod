# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: aecp001.4gl
# Descriptions...: 工單工藝生成作業
# Date & Author..: 07/06/07 By grissom
# Memo...........: 根據產品大工藝段中的小工藝生成小的工單工藝序
# Modify.........: No.FUN-980002 09/08/20 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A70131 10/07/29 By destiny 平行工藝
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-A70095 11/06/10 By lixh1 撈取報工單(shb_file)的所有處理作業,必須過濾是已確認的單據
# Modify.........: No.CHI-C90006 12/11/13 By bart 失效判斷

DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE 
    g_oebislk01 LIKE type_file.chr8,
    g_ecb01     LIKE ecb_file.ecb01,
    g_ecb03     LIKE ecb_file.ecb03,
    g_cnt       LIKE type_file.num5,
    g_ecu01     LIKE ecu_file.ecu01,  
    g_msg       LIKE type_file.chr1000,      
    g_sql       STRING,
    g_sign      LIKE type_file.chr1
DEFINE
    g_sfb   RECORD LIKE sfb_file.*,
    tm      RECORD
            wc     LIKE type_file.chr1000
            END RECORD
DEFINE     
    g_type      LIKE type_file.chr1,
    g_track     LIKE type_file.chr1,
    g_lots      LIKE ima_file.ima56, #production lot size
    g_wono      LIKE sfb_file.sfb01, #work order nubmer
    g_wotype    LIKE sfb_file.sfb02, #work order type
    g_part      LIKE sfb_file.sfb05, #work order part number
    g_primary   LIKE sfb_file.sfb06, #work order primary code
    g_usedate   LIKE type_file.chr1,
    g_opt       LIKE type_file.num5,
    g_woq       LIKE sfb_file.sfb08  #Qty of W/O       
           
MAIN
    OPTIONS 
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AEC")) THEN
      EXIT PROGRAM
   END IF
 
   IF NOT s_industry("slk") THEN                                                                                                    
      CALL cl_err('','aec-113',1)                                                                                                   
      EXIT PROGRAM                                                                                                                  
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   OPEN WINDOW p001_w WITH FORM "aec/42f/aecp001"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()   

   CALL p001()
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p001()
DEFINE 
   l_str1                LIKE type_file.chr8,   
   tempint,l_cnt,l_cnt1  LIKE type_file.num5
   
   
WHILE TRUE    
   LET INT_FLAG =0
   INPUT g_oebislk01,g_ecb01,g_ecb03 FROM oebislk01,ecb01,ecb03
 
   AFTER FIELD oebislk01
      IF g_oebislk01=' ' OR g_oebislk01 IS NULL   THEN 
         DISPLAY ' ' to FORMONLY.oebislk01
         NEXT FIELD oebislk01
      END IF
 
   AFTER FIELD ecb01        
      LET l_cnt = 1
      SELECT count(*) INTO l_cnt FROM ecb_file WHERE ecb01 = g_ecb01
      IF l_cnt = 0 THEN 
         CALL cl_err('','aec-200',1)   #產品工藝不存在
         NEXT FIELD ecb01
      END IF
     
     #制單號和成品款號是否對應
#modify by chenyu --08/07/10-----begin
#      SELECT count(*) INTO l_cnt1 FROM sfb_file 
#       WHERE substr(sfb05,1,8) = g_ecb01 
#         AND substr(sfb85,5,6) = g_oebislk01 
#         AND ROWNUM = 1 
      SELECT COUNT(*) INTO l_cnt FROM sfb_file,sfc_file,sfci_file,ima_file
       WHERE sfb85 = sfc01
         AND sfc01 = sfci01
         AND ima01 = sfb05 AND ima571 = g_ecb01
         AND sfcislk01 = g_oebislk01
#         AND substr(sfb05,1,8) = g_ecb01 
#modify by chenyu --08/07/10-----end
      IF l_cnt = 0 THEN
         CALL cl_err('','aec-201',1)
         NEXT FIELD ecb01
      END IF    
     
     
   AFTER FIELD ecb03
      IF not cl_null(g_ecb03) THEN        
         LET l_cnt = 1
         SELECT count(*) INTO l_cnt FROM ecb_file 
          WHERE ecb01 = g_ecb01
            AND ecb03 = g_ecb03
         IF l_cnt = 0 THEN 
            CALL cl_err('','aec-200',1)   #產品工藝不存在 
            NEXT FIELD ecb03
         END IF
      END IF
     
    
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
   
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
   END INPUT
   
   IF NOT INT_FLAG THEN
 #    EXIT WHILE
   ELSE
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM   	  
   END IF     
   
   CALL p001_judge(g_oebislk01) RETURNING tempint
   
   IF tempint = 1 THEN
       #刪除工單工藝單元資料
#      LET l_str1 = '%',g_oebislk01 CLIPPED,'%'
      SELECT COUNT(*) INTO g_cnt FROM sgd_file,ima_file
       WHERE sgd00 in (SELECT sfb01 FROM sfb_file,sfc_file,sfci_file    #modify by chenyu --08/07/10
                        WHERE sfb85 = sfc01 AND sfc01=sfci01 AND sfcislk01 = g_oebislk01 )
#         AND substr(sgd01,1,8) = g_ecb01
         AND ima01 = sgd01 AND ima571 = g_ecb01
         AND sgd03 = g_ecb03
      IF g_cnt > 0 THEN
         DELETE FROM sgd_file 
          WHERE sgd00 in (SELECT sfb01 FROM sfb_file,sfc_file,sfci_file 
                           WHERE sfb85 = sfc01 AND sfc01=sfci01 AND sfcislk01 = g_oebislk01)
#            AND substr(sgd01,1,8) = g_ecb01
            AND sgd01 IN (SELECT ima01 FROM ima_file WHERE ima01 = sgd01 AND ima571 = g_ecb01)
            AND sgd03 = g_ecb03
         IF SQLCA.sqlerrd[3]=0 THEN
            CALL cl_err('','asf-026',1)
            RETURN
         END IF
      END IF
      #開始生成工藝制程
#modify by chenyu --08/07/10---begin
#      LET g_sql = "SELECT sfb_file.* FROM sfb_file,ecm_file ",
#                  " WHERE ecm01 = sfb01 ",
#                  "   AND ecm03 = ",g_ecb03,"",
#                  "   AND substr(ecm03_par,1,8) = '",g_ecb01,"'",
#                  "   AND substr(sfb85,5,6) = '",g_oebislk01,"'"
      LET g_sql = "SELECT sfb_file.* FROM sfb_file,ecm_file,sfc_file,sfci_file,ima_file ",
                  " WHERE ecm01 = sfb01 ",
                  "   AND ecm03 = ",g_ecb03,"",
                  "   AND ima01 = ecm03_par AND ima571 =  '",g_ecb01,"'",
                  "   AND sfb85 = sfc01 AND sfc01 = sfci01 ",
                  "   AND sfcislk01 = '",g_oebislk01,"'"
#modify by chenyu --08/07/10---end
      PREPARE p301_prepare FROM g_sql
      DECLARE p301_cs CURSOR FOR p301_prepare
      LET g_cnt = 1
      LET g_sign = 'Y'
      BEGIN WORK
      FOREACH p301_cs INTO g_sfb.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)   
            EXIT FOREACH
         END IF
         IF g_sign = 'N' THEN
      	    EXIT FOREACH         
         END IF
      
         CALL p001_crrut()
         IF g_cnt < 0 THEN
            EXIT FOREACH
         END IF        
         LET g_cnt = g_cnt + 1 
      END FOREACH
      IF g_sign = 'N' THEN
         ROLLBACK WORK
         CALL cl_err('','aec-202',1)              
      ELSE
         COMMIT WORK
         CALL cl_getmsg('asf-386',g_lang) RETURNING g_msg
         CALL cl_msgany(0,0,g_msg)
      END IF 
   END IF
END WHILE
 
END FUNCTION
 
#判斷是否可以產生制程，可以產生就返回TRUE，否則返回FALSE
FUNCTION p001_judge(p_oebislk01)
DEFINE 
    l_sfb01      LIKE sfb_file.sfb01,    
    l_sfb02      LIKE sfb_file.sfb02,
    l_sfb04      LIKE sfb_file.sfb04,
    l_sfb06      LIKE sfb_file.sfb06,
    l_sfb87      LIKE sfb_file.sfb87,
    p_oebislk01  LIKE type_file.chr8,
    tempstr      LIKE type_file.chr1000,
    li_result    LIKE type_file.num5,
    l_n          LIKE type_file.num5,
    l_sfb05      LIKE type_file.chr8,
    l_ecb06      LIKE ecb_file.ecb06    
    
   LET li_result = 1 
#modify by chenyu --08/07/10---------begin     
#   SELECT sfb01,sfb02,sfb04,sfb06,sfb87 
#     INTO l_sfb01,l_sfb02,l_sfb04,l_sfb06,l_sfb87 
#     FROM sfb_file 
#    WHERE rownum = 1 
#      AND substr(sfb85,5,6) = p_oebislk01
    SELECT sfb01,sfb02,sfb04,sfb06,sfb87
      INTO l_sfb01,l_sfb02,l_sfb04,l_sfb06,l_sfb87
      FROM sfb_file,sfc_file,sfci_file
     WHERE ROWNUM = 1
       AND sfb85 = sfc01
       AND sfc01 = sfci01
       AND sfcislk01 = p_oebislk01
#modify by chenyu --08/07/10----------end    
      #判斷是否存在小工藝資料
      LET l_n = 0
      SELECT COUNT(*) INTO l_n
        FROM sgc_file
       WHERE sgc01 = g_ecb01
         AND sgc02 = l_sfb06
         AND sgc03 = g_ecb03
      IF cl_null(l_n) THEN LET l_n = 0 END IF
      IF l_n <= 0 THEN
      	 CALL cl_err('','aec-203',1)
      	 LET g_sign = 'N'
         LET li_result = 0
      END IF
     	
   #判斷是否有轉移資料
   IF li_result = 1 THEN
      SELECT ecb06 INTO l_ecb06
        FROM ecb_file
       WHERE ecb01 = g_ecb01
         AND ecb02 = l_sfb06
         AND ecb03 = g_ecb03
      LET l_n = 0   
      SELECT COUNT(*) INTO l_n
        FROM shx_file,shy_file
       WHERE shx01 = shy01
         AND shx05 = l_ecb06
         AND shy03 = l_sfb01
   	     
      IF l_n > 0 THEN
      	 LET g_sign = 'N'
     	 LET li_result = 0
     	 CALL cl_err('','aec-201',1)
      END IF
   END IF  
 
  #委外工單不產生制程
  IF li_result = 1 THEN
     IF l_sfb02 MATCHES '[78]' THEN
        LET g_sign = 'N'
        LET li_result = 0  	
     	  CALL cl_err('','mfg-022',1)
     END IF  
  END IF
  #工單已發料不可以重新產生制程
{  IF li_result = 1 THEN
      IF l_sfb04 >= '4' THEN
         LET g_sign = 'N'
         LET li_result = 0
         CALL cl_err('','aec-204',1)
      END IF 
   END IF}
  
  IF li_result = 1 THEN
     IF l_sfb87 = 'X'  THEN 
   	    LET g_sign = 'N'
     	  LET li_result = 0
     	  CALL cl_err('','9024',1) 
     END IF
  END IF
  IF li_result = 1 THEN
     IF cl_null(l_sfb06) THEN   #制程編號
        LET g_sign = 'N'
     	  LET li_result = 0
       	CALL cl_err('','aec-205',1) 	
     END IF
  END IF  
 
#mark by chenyu --08/07/10---begin  
#  #存在待發放不能生成工單工藝
#  LET tempstr = '%',g_oebislk01,'%'
#  SELECT COUNT(*) INTO g_cnt FROM ecb_file,sfb_file
#  WHERE ecb01 = substr(sfb05,1,8) 
#    AND ecb08 IN ('SC001','SC002','SC003','SC004','SUB01') 
#    AND sfb85 LIKE tempstr
#          
#  IF g_cnt > 0 THEN
#     LET li_result = 0
#     CALL cl_err('','aec-206',1)
#  END IF #mark by chenyu --08/07/10----end 
 
 
#  #存在車縫為新正新，但無產品明細單元資料時不能產生
#  SELECT COUNT(*) INTO g_cnt 
#    FROM ecb_file,sfb_file
#   WHERE sfb85 LIKE tempstr AND substr(sfb05,1,8)=ecb01
#     AND ecb06 LIKE 'WK002%' 
#     AND ecb08 IN ('5032','5033','5034','5035','5036','5037','5038','5039') 
#  IF g_cnt > 0 THEN
     SELECT COUNT(*) INTO g_cnt 
       FROM ecb_file,sgc_file,sfb_file,sfc_file,sfci_file,ima_file
      WHERE ima01 = sfb85 AND ima571 = ecb01 
#      substr(sfb05,1,8)=ecb01 
#        AND sfb85 like tempstr
        AND sfb85 = sfc01 AND sfc01=sfci01 AND sfcislk01 = p_oebislk01
        AND sgc01 = ecb01 AND sgc02=ecb02 AND sgc03=ecb03 
                  
#        AND ecb06 like 'WK002%' 
#        AND ecb08 in ('5032','5033','5034','5035','5036','5037','5038','5039')
           
     IF g_cnt = 0 THEN     	
        LET li_result = 0     
        CALL cl_err('','aec-207',1)
     END IF
#  END IF     
     
  #生產日報已有資料
  SELECT COUNT(*) INTO g_cnt FROM shb_file WHERE shb05 = l_sfb01
                                             AND shbconf = 'Y'   #FUN-A70098
  IF li_result = 1 THEN
     IF g_cnt > 0 THEN 
        LET g_sign = 'N'
    	LET li_result = 0
     	CALL cl_err('','asf-025',1) 
     END IF
  END IF  
  RETURN li_result
 
END FUNCTION
 
FUNCTION p001_crrut()
  DEFINE l_ecb     RECORD LIKE ecb_file.*
  DEFINE l_ima571  LIKE ima_file.ima571
  DEFINE l_ecu02   LIKE ecu_file.ecu02
  DEFINE l_code    LIKE type_file.chr1
  DEFINE l_ecm03   LIKE ecm_file.ecm03
 
  IF NOT cl_null(g_sfb.sfb06) THEN
     SELECT ima571 INTO l_ima571 FROM ima_file
      WHERE ima01=g_sfb.sfb05
     IF l_ima571 IS NULL THEN 
        LET l_ima571=' ' 
     END IF 
     SELECT ecu01 FROM ecu_file
      WHERE ecu01=l_ima571 AND ecu02=g_sfb.sfb06
        AND ecuacti = 'Y'  #CHI-C90006
     IF STATUS THEN
        SELECT ecu01 FROM ecu_file
#         WHERE ecu01=substr(g_sfb.sfb05,1,8) AND ecu02=g_sfb.sfb06
         WHERE ecu01=l_ima571 AND ecu02=g_sfb.sfb06
           AND ecuacti = 'Y'  #CHI-C90006
        IF STATUS THEN
           CALL cl_err('sel ecu:',STATUS,1)
           LET g_sign = 'N'
           RETURN
        ELSE
           LET g_ecu01=g_sfb.sfb05
        END IF
     ELSE
        LET g_ecu01=l_ima571
     END IF
     CALL p001_schdat(0,g_sfb.sfb13,g_sfb.sfb15,g_sfb.sfb071,g_sfb.sfb01,
                      g_sfb.sfb06,g_sfb.sfb02,g_ecu01,g_sfb.sfb08,2,g_ecb03)
          RETURNING g_cnt,g_sfb.sfb13,g_sfb.sfb15,g_sfb.sfb32,g_sfb.sfb24 
      IF g_cnt < 0 THEN
      	 LET g_sign = 'N'
      END IF     
   END IF
END FUNCTION
 
FUNCTION p001_schdat(p_opt,p_strtdat,p_duedat,p_bomdat,p_wono,
                     p_primary,p_wotype,p_part,p_woq,p_usedate,p_ecb03)
DEFINE
    p_opt      LIKE type_file.num5,    #add by liuxqa 091019
    p_strtdat  LIKE type_file.dat,  #Start Date
    p_duedat   LIKE type_file.dat,  #Due Date
    p_bomdat   LIKE type_file.dat,  #BOM Effective Date
    p_wono     LIKE sfb_file.sfb01, #W/O
    p_part     LIKE sfb_file.sfb05, #work order part number
    p_wotype   LIKE sfb_file.sfb02, #work order type
    p_woq      LIKE sfb_file.sfb08, #Qty of W/O
    p_primary  LIKE ecb_file.ecb02, #Primary Code
    p_ecb03    LIKE ecb_file.ecb03,
    p_usedate  LIKE type_file.chr1,    #
    l_part     LIKE ima_file.ima01,
    l_exit     LIKE type_file.num5,
    l_irr      LIKE type_file.num5
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    MESSAGE ' Scheduling ' ATTRIBUTE(REVERSE)
    #Check if all anytings available
    LET g_errno=' '
    LET g_track='N'
    LET g_ecb03 = p_ecb03
    SELECT * INTO g_sfb.* FROM sfb_file WHERE sfb01=p_wono 
 
    IF g_sfb.sfb93='N' AND g_sma.sma28='2' THEN
       LET g_errno='mfg5106'
       RETURN -1,p_strtdat,p_duedat,g_type,g_track
    END IF
 
    #scehduling method not defined
    IF g_sma.sma28 IS NULL        
        OR g_sma.sma28 NOT MATCHES '[12]' THEN  #out of range
        LET g_errno='mfg5100'
        RETURN -1,p_strtdat,p_duedat,g_type,g_track
    END IF
 
    #tracking method not defined
    IF g_sma.sma26 IS NULL       
        OR g_sma.sma26 NOT MATCHES '[123]' THEN #out of range
        LET g_errno='mfg5101'
        RETURN -2,p_strtdat,p_duedat,g_type,g_track
    END IF
   
    LET g_wono=p_wono
    LET g_wotype=p_wotype
    LET g_part=p_part
    LET g_primary=p_primary
    LET g_woq=p_woq
    LET g_usedate=p_usedate
    LET g_opt=p_opt
    LET g_errno= ' '
 
    IF (g_sfb.sfb93='Y' AND g_sma.sma28='2')         #使用制程排程
            OR (g_sma.sma26 MATCHES '[23]') THEN     #產生制程追蹤
        LET g_cnt=0
        SELECT COUNT(*) INTO g_cnt FROM sgd_file
         WHERE sgd00=g_wono
           AND sgd03 = g_ecb03
        IF SQLCA.sqlcode OR g_cnt=0 OR g_cnt IS NULL THEN #record not exist
           LET l_part=p_part
           LET l_exit=FALSE
           WHILE TRUE
               #add new record to tracing file
               CALL p001_put(l_part) RETURNING g_cnt 
           EXIT WHILE  #成功
	         END WHILE
        ELSE  #追蹤資料已存在，不可繼續
           CALL cl_err('','asf-016',1)
           RETURN -99,p_strtdat,p_duedat,g_type,g_track
        END IF
    END IF
    MESSAGE ""
    RETURN g_cnt,p_strtdat,p_duedat,g_type,g_track
END FUNCTION
 
FUNCTION p001_put(p_part)
DEFINE
    p_bomdat LIKE type_file.dat,
    p_part   LIKE ima_file.ima01,
    l_ima55  LIKE ima_file.ima55,
    l_ecb    RECORD LIKE ecb_file.*, #routing detail file
    l_ecm    RECORD LIKE ecm_file.*, #routing detail file
    l_sgc    RECORD LIKE sgc_file.*, #routing detail file
    l_sgd    RECORD LIKE sgd_file.*, #routing detail file
    l_sql    LIKE type_file.chr1000,
    l_n      LIKE type_file.num5
            
    IF NOT cl_null(g_ecb03) THEN
       #大工藝已存在，不可產生小工藝
       LET l_n = 0
       SELECT count(*) INTO l_n
         FROM ecm_file
        WHERE ecm01 = g_wono
          AND ecm03 = g_ecb03
       IF cl_null(l_n) THEN LET l_n = 0 END IF
       IF l_n <= 0 THEN
          CALL cl_err('','aec-208',1)
          LET g_success = 'N'
          RETURN -1
       END IF
    END IF
    IF NOT cl_null(g_ecb03) THEN
       LET l_sql = " SELECT * FROM ecb_file ",
                   "  WHERE ecb01 = '",g_part,"'",
                   "    AND ecb02 = '",g_primary,"'",
                   "    AND ecbacti='Y' ",
                   "    AND ecb03 = ",g_ecb03,""
    ELSE
       LET l_sql = " SELECT * FROM ecb_file ",
                   "  WHERE ecb01 = '",g_part,"'",
                   "    AND ecb02 = '",g_primary,"'",
                   "    AND ecbacti='Y' "
    END IF
 
    PREPARE c_put_prepare FROM l_sql
    DECLARE c_put_cs CURSOR FOR c_put_prepare
    LET g_cnt=0
    FOREACH c_put_cs INTO l_ecb.*
        IF SQLCA.sqlcode THEN EXIT FOREACH END IF
        LET l_n = 0
        SELECT count(*) INTO l_n
          FROM ecm_file,ima_file           #modify by chenyu  --08/07/10
         WHERE ecm03_par = ima01 AND ima571 = l_ecb.ecb01
#         substr(ecm03_par,1,8) = l_ecb.ecb01
           AND ecm11 = l_ecb.ecb02
           AND ecm03 = l_ecb.ecb03
           AND ecm04 = l_ecb.ecb06
           AND ecm01 = g_wono
        IF cl_null(l_n) THEN LET l_n = 0 END IF
        IF l_n <= 0 THEN
           CONTINUE FOREACH
        END IF
        #大工藝不存在，不能產生小工藝
        LET l_n = 0
        SELECT count(*) INTO l_n
          FROM ecm_file
         WHERE ecm01 = g_wono
           AND ecm03 = l_ecb.ecb03
        IF cl_null(l_n) THEN LET l_n = 0 END IF
        IF l_n <= 0 THEN
           CALL cl_err('','aec-208',1)
           LET g_success = 'N'
           EXIT FOREACH
        END IF
        #已產生轉移資料不能產生
        LET l_n = 0 
        SELECT count(*) INTO l_n
          FROM shb_file
         WHERE shb05 = g_wono
           AND shb06 = l_ecb.ecb03
           AND shbconf = 'Y'    #FUN-A70095
        IF cl_null(l_n) THEN LET l_n = 0 END IF
        IF l_n > 0 THEN
           CALL cl_err('','aec-209',1)
           LET g_success = 'N'
           EXIT FOREACH
        END IF 
        
        #----->工單制程單元資料
        DECLARE sgc_cur CURSOR FOR
           SELECT * FROM sgc_file 
            WHERE sgc01 = l_ecb.ecb01
              AND sgc02 = l_ecb.ecb02
              AND sgc03 = l_ecb.ecb03
              AND sgc04 = l_ecb.ecb08
        FOREACH sgc_cur INTO l_sgc.*
           IF SQLCA.sqlcode THEN EXIT FOREACH END IF
           INITIALIZE l_sgd.* TO NULL  
           LET l_sgd.sgd00 = g_wono
           LET l_sgd.sgd01 = l_sgc.sgc01
           LET l_sgd.sgd02 = l_sgc.sgc02
           LET l_sgd.sgd03 = l_sgc.sgc03
           LET l_sgd.sgd04 = l_sgc.sgc04
           LET l_sgd.sgd05 = l_sgc.sgc05
           LET l_sgd.sgd06 = l_sgc.sgc06
           LET l_sgd.sgd07 = l_sgc.sgc07
           LET l_sgd.sgd08 = l_sgc.sgc08
           LET l_sgd.sgd09 = l_sgc.sgc09
           LET l_sgd.sgd10 = l_sgc.sgc10
           LET l_sgd.sgd11 = l_sgc.sgc11
       #   LET l_sgd.sgd12 = l_sgc.sgc12
           LET l_sgd.sgd13 = l_sgc.sgc13
           LET l_sgd.sgdslk02 = l_sgc.sgcslk02
           LET l_sgd.sgdslk03 = l_sgc.sgcslk03 
           LET l_sgd.sgdslk04 = l_sgc.sgcslk04
           LET l_sgd.sgdslk05 = l_sgc.sgcslk05
           LET l_sgd.sgd14 = l_sgc.sgc14
           
           LET l_sgd.sgdplant = g_plant #FUN-980002
           LET l_sgd.sgdlegal = g_legal #FUN-980002
           #No.FUN-A70131--begin
            IF cl_null(l_sgd.sgd012) THEN 
               LET l_sgd.sgd012=' '
            END IF 
            IF cl_null(l_sgd.sgd03) THEN 
               LET l_sgd.sgd03=0
            END IF 
            #No.FUN-A70131--end               
           INSERT INTO sgd_file VALUES(l_sgd.*)
        END FOREACH
        LET g_cnt=g_cnt+1
    END FOREACH
    #---------------------------------------->
    IF g_success = 'N' THEN 
    	 RETURN -1
    END IF
    IF g_cnt > 0 THEN LET g_track='Y' END IF
    RETURN g_cnt
END FUNCTION
