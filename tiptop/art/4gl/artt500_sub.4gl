# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Program name...: artt500_sub.4gl
# Description....: 提供artt500.4gl使用的sub routine
# Date & Author..: FUN-870007 08/11/10 by Zhangyajun
# Memo...........: copy from sapmt540_sub
# Modify ........: No.FUN-870008 08/08/25 By mike GP5.2
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960130 09/11/24 By bnlent get tra-db
# Modify.........: No:FUN-870007 09/12/09 By Cockroach PASS NO.
# Modify.........: No.FUN-A50102 10/06/10 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-C40089 12/04/30 By bart 原先以參數sma112來判斷採購單價可否為0的程式,全部改成判斷採購價格條件(apmi110)的pnz08
# Modify.........: No:FUN-C50076 12/05/18 By bart 更改錯誤訊息代碼mfg3522->axm-627

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  g_unalc      LIKE type_file.num5,     
        g_pmm22      LIKE pmm_file.pmm22,     # Curr
        g_pmm42      LIKE pmm_file.pmm42,     # Ex.Rate
        g_ima53      LIKE ima_file.ima53,
        g_ima531     LIKE ima_file.ima531,
        g_ima532     LIKE ima_file.ima532
DEFINE  g_pnz08      LIKE pnz_file.pnz08    #FUN-C40089
 
FUNCTION t500sub_azp(l_azp01)
   DEFINE l_azp01  LIKE azp_file.azp01,
          l_azp03  LIKE azp_file.azp03
 
    LET g_errno=' '
    #No.FUN-960130 ..begin
    #SELECT azp03 INTO l_azp03 FROM azp_file 
    # WHERE azp01=l_azp01
    LET g_plant_new = l_azp01
    CALL s_gettrandbs()
    LET l_azp03=g_dbs_tra
    #No.FUN-960130 ..end
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-025'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    RETURN l_azp03 CLIPPED
END FUNCTION
 
FUNCTION t500sub_y_chk(l_pmm)
  DEFINE l_flag   LIKE type_file.chr1      
  DEFINE l_cnt    LIKE type_file.num5     
  DEFINE l_pmn04  LIKE pmn_file.pmn04    
  DEFINE l_pmm      RECORD LIKE pmm_file.*
  DEFINE l_poz      RECORD LIKE poz_file.*     
  DEFINE l_poy      RECORD LIKE poy_file.*   
  DEFINE l_argv3  LIKE pmm_file.pmm02
  DEFINE l_ima915 LIKE ima_file.ima915   
  DEFINE l_pmn43  LIKE pmn_file.pmn43    
  DEFINE l_pmn41  LIKE pmn_file.pmn41  
  DEFINE l_status LIKE type_file.chr1   
  DEFINE l_sql    STRING
  DEFINE l_dbs    LIKE azp_file.azp03
  WHENEVER ERROR CONTINUE                #忽略一切錯誤  
  
  LET g_success = 'Y'
  IF cl_null(l_pmm.pmm01) THEN
     CALL cl_err('','-400',1)  
     LET g_success = 'N'   
     RETURN
  END IF
  CALL t500sub_azp(l_pmm.pmmplant) RETURNING l_dbs
  IF NOT cl_null(g_errno) THEN
     CALL cl_err('',g_errno,1)
     LET g_success = 'N'
     RETURN
  END IF
 
  LET l_argv3=l_pmm.pmm02 
 
  IF l_pmm.pmm18='X' THEN
     CALL cl_err('','9024',1)  
     LET g_success = 'N'   
     RETURN
  END IF
 
  IF l_pmm.pmmmksg='Y'   THEN
  END IF
  IF l_pmm.pmmacti='N' THEN
     CALL cl_err('','mfg0301',1)
     LET g_success = 'N'   
     RETURN
  END IF
 
  LET l_flag='N'
  IF cl_null(l_pmm.pmm09) THEN
     LET l_flag = 'Y'
  END IF
  IF cl_null(l_pmm.pmm04) THEN
     LET l_flag = 'Y'
  END IF
  IF cl_null(l_pmm.pmm20) THEN
     LET l_flag = 'Y'
  END IF
  IF cl_null(l_pmm.pmm21) THEN
     LET l_flag = 'Y'
  END IF
  IF cl_null(l_pmm.pmm02) THEN
     LET l_flag = 'Y'
  END IF
  IF l_flag='Y' THEN
     CALL cl_err('','mfg6138',1)
     LET g_success = 'N'  
     RETURN
  END IF
  IF l_pmm.pmm02='TAP' AND cl_null(l_pmm.pmm904) THEN
     CALL cl_err('','apm-017',1)
     LET g_success = 'N'  
     RETURN
  END IF
 
  IF l_pmm.pmm02='TAP' THEN
     SELECT * INTO l_poz.* FROM poz_file
      WHERE poz01 = l_pmm.pmm904 AND pozacti = 'Y'
 
     SELECT * INTO l_poy.* FROM poy_file
     WHERE poy01 = l_pmm.pmm904 AND poy02 = 1  
 
     IF l_poy.poy03 <> l_pmm.pmm09 THEN
        CALL cl_err('','apm-007',1)  
        LET g_success = 'N'  
        RETURN
     END IF
     #若不指定幣別，則不用對應流程代碼的幣別
     IF l_poz.poz09 = 'Y' THEN
        IF l_poy.poy05 <> l_pmm.pmm22 THEN
           CALL cl_err('','apm-008',1)  
           LET g_success = 'N'  
           RETURN
        END IF
     END IF
  END IF
  # 參數設定單價不可為零
  #FUN-C40089---begin
  SELECT pnz08 INTO g_pnz08 FROM pnz_file WHERE pnz01 = l_pmm.pmm41
  IF cl_null(g_pnz08) THEN 
     LET g_pnz08 = 'Y'
  END IF 
  IF g_pnz08 = 'N' AND l_argv3 != 'SUB' THEN
  #IF g_sma.sma112= 'N' AND l_argv3 != 'SUB' THEN
  #FUN-C40089---end
     #LET l_sql="SELECT COUNT(*) FROM ",s_dbstring(l_dbs CLIPPED),"pmn_file", #FUN-A50102
     LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_pmm.pmmplant, 'pmn_file'), #FUN-A50102
               " WHERE pmn01 = '",l_pmm.pmm01,
               "'  AND (pmn31 <=0 OR pmn44 <=0 )"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
     CALL cl_parse_qry_sql(l_sql, l_pmm.pmmplant) RETURNING l_sql  #FUN-A50102          
     PREPARE pmn31_cs FROM l_sql
     EXECUTE pmn31_cs INTO l_cnt
     IF l_cnt > 0 THEN
        CALL cl_err('','axm-627',1)  #FUN-C50076
        LET g_success = 'N'
        RETURN
     END IF
  END IF
 
#無單身資料不可確認
  LET l_cnt=0
  #LET l_sql="SELECT COUNT(*) FROM ",s_dbstring(l_dbs CLIPPED),"pmn_file", #FUN-A50102
  LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_pmm.pmmplant, 'pmn_file'), #FUN-A50102
            " WHERE pmn01=?"
  CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
  CALL cl_parse_qry_sql(l_sql, l_pmm.pmmplant) RETURNING l_sql  #FUN-A50102
  PREPARE pmn_cs FROM l_sql
  EXECUTE pmn_cs USING l_pmm.pmm01 INTO l_cnt
  IF l_cnt=0 OR l_cnt IS NULL THEN
     CALL cl_err('','mfg-009',1)  
     LET g_success = 'N'
     RETURN
  END IF
 
#交貨日不可空白
  LET l_cnt=0
  #LET l_sql ="SELECT COUNT(*) FROM ",s_dbstring(l_dbs CLIPPED),"pmn_file", #FUN-A50102
  LET l_sql ="SELECT COUNT(*) FROM ",cl_get_target_table(l_pmm.pmmplant, 'pmn_file'), #FUN-A50102
             " WHERE pmn01 = ?",
             "   AND pmn33 IS NULL"
  CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
  CALL cl_parse_qry_sql(l_sql, l_pmm.pmmplant) RETURNING l_sql  #FUN-A50102           
  PREPARE pmn33_cs FROM l_sql
  EXECUTE pmn33_cs INTO l_cnt
  IF l_cnt > 0 THEN
     CALL cl_err('','mfg3226',1)
     LET g_success = 'N' 
     RETURN
  END IF
##
 
  #交貨日期不可小于采購日期。
  CALL t500_chk_date(l_pmm.*,l_dbs)
  IF g_success ='N' THEN
     RETURN
  END IF
 
  #採購料件/供應商控制
      #LET l_sql="SELECT pmn04,pmn41,pmn43 FROM ",s_dbstring(l_dbs CLIPPED),"pmn_file", #FUN-A50102
      LET l_sql="SELECT pmn04,pmn41,pmn43 FROM ",cl_get_target_table(l_pmm.pmmplant, 'pmn_file'), #FUN-A50102
                " WHERE pmn01=?"
       DECLARE pmn_cur_pmn04 CURSOR FROM l_sql
      FOREACH pmn_cur_pmn04 USING l_pmm.pmm01 INTO l_pmn04,l_pmn41,l_pmn43
      SELECT ima915 INTO l_ima915 FROM ima_file
       WHERE ima01=l_pmn04
      IF l_ima915='2' OR l_ima915='3' THEN
          IF (l_pmn04[1,4] != 'MISC') THEN
              IF l_pmm.pmm02 = 'SUB' THEN
                 CALL t500sub_pmh(l_pmn04,l_pmn41,l_pmn43,l_pmm.*,'2',l_dbs) 
              ELSE
                 CALL t500sub_pmh(l_pmn04,l_pmn41,l_pmn43,l_pmm.*,'1',l_dbs) 
              END IF
              IF NOT cl_null(g_errno) THEN
                  CALL cl_err(l_pmn04,g_errno,1)
                  LET g_success = 'N'
                  EXIT FOREACH
              END IF
          END IF 
      END IF     
      END FOREACH
 
END FUNCTION
 
#系統參數設料件/供應商須存在
FUNCTION t500sub_pmh(l_part,l_pmn41,l_pmn43,l_pmm,l_type,l_dbs)  #供應廠商  
 DEFINE l_pmhacti LIKE pmh_file.pmhacti,
        l_pmh05   LIKE pmh_file.pmh05,
        l_part    LIKE pmh_file.pmh01,
        l_pmm     RECORD LIKE pmm_file.*,
        l_dbs     LIKE azp_file.azp03
 DEFINE l_type    LIKE pmh_file.pmh22    
 DEFINE l_pmn41   LIKE pmn_file.pmn41    
 DEFINE l_pmn43   LIKE pmn_file.pmn43   
 DEFINE l_ecm04   LIKE ecm_file.ecm04   
 DEFINE l_sql     STRING
 
     LET g_errno = " "
     IF l_type = '1' THEN  
        #LET l_sql="SELECT pmhacti,pmh05 FROM ",s_dbstring(l_dbs CLIPPED),"pmh_file", #FUN-A50102
        LET l_sql="SELECT pmhacti,pmh05 FROM ",cl_get_target_table(l_pmm.pmmplant, 'pmh_file'), #FUN-A50102
                  " WHERE pmh01='",l_part,"' AND pmh02='",l_pmm.pmm09,
                  "'  AND pmh13='",l_pmm.pmm22,
                  "'  AND pmh21 = '' AND pmh22 = '",l_type,"'" 
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
        CALL cl_parse_qry_sql(l_sql, l_pmm.pmmplant) RETURNING l_sql  #FUN-A50102   
        PREPARE pmh_cs FROM l_sql
        EXECUTE pmh_cs INTO l_pmhacti,l_pmh05
 
     ELSE
         #委外製程時，找出製程作業編號
        #LET l_sql="SELECT ecm04 FROM ",s_dbstring(l_dbs CLIPPED),"ecm_file", #FUN-A50102
        LET l_sql="SELECT ecm04 FROM ",cl_get_target_table(l_pmm.pmmplant, 'ecm_file'), #FUN-A50102
                  " WHERE ecm01 = '",l_pmn41,
                  "'  AND ecm03 = '",l_pmn43,"'"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
        CALL cl_parse_qry_sql(l_sql, l_pmm.pmmplant) RETURNING l_sql  #FUN-A50102          
        PREPARE ecm_cs FROM l_sql
        EXECUTE ecm_cs INTO l_ecm04
         IF cl_null(l_ecm04) THEN LET l_ecm04 = ' ' END IF
        #LET l_sql="SELECT pmhacti,pmh05 FROM ",s_dbstring(l_dbs CLIPPED),"pmh_file", #FUN-A50102
        LET l_sql="SELECT pmhacti,pmh05 FROM ",cl_get_target_table(l_pmm.pmmplant, 'pmh_file'), #FUN-A50102
                  " WHERE pmh01='",l_part,"' AND pmh02='",l_pmm.pmm09,
                  "'  AND pmh13='",l_pmm.pmm22,
                  "'  AND pmh21 = '",l_ecm04,"' AND pmh22 = '",l_type,"'" 
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
        CALL cl_parse_qry_sql(l_sql, l_pmm.pmmplant) RETURNING l_sql  #FUN-A50102          
        PREPARE pmh_cs1 FROM l_sql
        EXECUTE pmh_cs1 INTO l_pmhacti,l_pmh05
     END IF
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0031'
                                   LET l_pmhacti = NULL
         WHEN l_pmhacti='N'        LET g_errno = 'apm-068'  
         WHEN l_pmh05 MATCHES '[12]' LET g_errno = 'mfg3043'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
#{
#作用:lock cursor
#回傳值:無
#}
#FUNCTION t500sub_lock_cl(l_dbs) #FUN-A50102
FUNCTION t500sub_lock_cl(l_plant) #FUN-A50102
   #DEFINE l_dbs LIKE azp_file.azp03 #FUN-A50102
   DEFINE l_forupd_sql STRING
   DEFINE l_plant LIKE pmm_file.pmmplant #FUN-A50102
   
   #LET l_forupd_sql = "SELECT * FROM ",s_dbstring(l_dbs CLIPPED),"pmm_file WHERE pmm01 = ? FOR UPDATE" #FUN-A50102
   LET l_forupd_sql = "SELECT * FROM ",cl_get_target_table(l_plant, 'pmm_file')," WHERE pmm01 = ? FOR UPDATE" #FUN-A50102
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)

   DECLARE t500sub_cl CURSOR FROM l_forupd_sql
END FUNCTION
 
FUNCTION t500sub_y_upd(l_pmm)
  DEFINE l_pmm RECORD LIKE pmm_file.*,
         l_cnt  LIKE type_file.num5,
         l_sta  LIKE ze_file.ze03,
         l_pmmmksg LIKE pmm_file.pmmmksg,
         l_pmm25   LIKE pmm_file.pmm25
  DEFINE l_dbs  LIKE azp_file.azp03
  DEFINE l_sql  STRING
  WHENEVER ERROR CONTINUE 
 
  LET g_success = 'Y'
  CALL t500sub_azp(l_pmm.pmmplant) RETURNING l_dbs
 
  LET g_success = 'Y'
  #CALL t500sub_lock_cl(l_dbs)  #FUN-A50102
  CALL t500sub_lock_cl(l_pmm.pmmplant)  #FUN-A50102
  OPEN t500sub_cl USING l_pmm.pmm01
  IF STATUS THEN
     CALL cl_err("OPEN t500sub_cl:", STATUS, 1)
     CLOSE t500sub_cl
     RETURN
  END IF
  FETCH t500sub_cl INTO l_pmm.*               # 對DB鎖定
  IF SQLCA.sqlcode THEN
     CALL cl_err(l_pmm.pmm01,SQLCA.sqlcode,1)  
     RETURN
  END IF
  #----檢查Blanket P/O是否為 null  -----
  IF g_smy.smy57[4,4] = 'Y' THEN
     LET l_cnt=0
     #LET l_sql="SELECT COUNT(*) FROM ",s_dbstring(l_dbs CLIPPED),"pmn_file", #FUN-A50102
     LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_pmm.pmmplant, 'pmn_file'), #FUN-A50102
               " WHERE pmn01 = '",l_pmm.pmm01,
               "'  AND ((pmn68 IS NULL OR pmn68 = ' ') OR",
               " (pmn69 IS NULL OR pmn69 = ' '))"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
     CALL cl_parse_qry_sql(l_sql, l_pmm.pmmplant) RETURNING l_sql  #FUN-A50102
     PREPARE pmn_cnt FROM l_sql
     EXECUTE pmn_cnt INTO l_cnt
     IF l_cnt > 0 THEN
         CALL cl_err('','apm-906',1) 
        LET g_success='N'
        RETURN
     END IF
  END IF
 
  CALL t500sub_y1(l_pmm.*,l_dbs)
 
  IF g_success = 'Y' THEN
     IF l_pmm.pmmmksg= 'Y' THEN #簽核模式
        CASE aws_efapp_formapproval()            #呼叫 EF 簽核功能
            WHEN 0  #呼叫 EasyFlow 簽核失敗
                 LET l_pmm.pmm18="N"
                 LET g_success = "N"
                 RETURN
            WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                 LET l_pmm.pmm18="N"
                 RETURN
        END CASE
     END IF
 
     LET l_cnt=0
     #LET l_sql="SELECT COUNT(*) FROM ",s_dbstring(l_dbs CLIPPED),"pmn_file", #FUN-A50102
     LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_pmm.pmmplant, 'pmn_file'), #FUN-A50102
               " WHERE pmn01 = '",l_pmm.pmm01,"'"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
     CALL cl_parse_qry_sql(l_sql, l_pmm.pmmplant) RETURNING l_sql  #FUN-A50102          
     PREPARE pmn_count FROM l_sql
     EXECUTE pmn_count INTO l_cnt
     IF l_cnt = 0 AND l_pmm.pmmmksg = 'Y' THEN
        CALL cl_err(' ','aws-065',1)
        LET g_success = 'N'
     END IF
     IF g_success = 'Y' THEN
        LET l_pmm.pmm18='Y'         #執行成功, 確認碼顯示為 'Y' 已確認
     END IF
  END IF
END FUNCTION
 
FUNCTION t500sub_y1(l_pmm,l_dbs)
   DEFINE l_pmm     RECORD LIKE pmm_file.*
   DEFINE l_cmd     LIKE type_file.chr1000 
   DEFINE l_str     LIKE gsb_file.gsb05    
   DEFINE l_wc		  LIKE type_file.chr1000
   DEFINE l_pmn04   LIKE pmn_file.pmn04
   DEFINE l_imaacti LIKE ima_file.imaacti
   DEFINE l_ima140  LIKE ima_file.ima140
   DEFINE l_ima1401 LIKE ima_file.ima1401 
   DEFINE l_sql STRING
   DEFINE l_dbs LIKE azp_file.azp03
 
    #無效料件或Phase Out者不可以請購
    #LET l_sql = "SELECT pmn04 FROM ",s_dbstring(l_dbs CLIPPED),"pmn_file", #FUN-A50102
    LET l_sql = "SELECT pmn04 FROM ",cl_get_target_table(l_pmm.pmmplant, 'pmn_file'), #FUN-A50102
                " WHERE pmn01='",l_pmm.pmm01,"'"
    DECLARE pmn_cur1 CURSOR FROM l_sql
    FOREACH pmn_cur1 INTO l_pmn04
       LET l_str = l_pmn04[1,4]  
       IF l_str = 'MISC' THEN CONTINUE FOREACH END IF
       SELECT imaacti,ima140,ima1401
         INTO l_imaacti,l_ima140,l_ima1401
         FROM ima_file
        WHERE ima01 = l_pmn04
       IF SQLCA.sqlcode THEN
          IF l_pmn04[1,4] <>'MISC' THEN
              LET l_imaacti = 'N'
              LET l_ima140 = 'Y'
          END IF
       END IF
       IF l_imaacti = 'N' OR (l_ima140 = 'Y' AND l_ima1401 <= l_pmm.pmm04)  THEN
          CALL cl_err(l_pmn04,'apm-006',1) 
          LET g_success = 'N'
        RETURN
       END IF
    END FOREACH
   IF l_pmm.pmmmksg='N' AND l_pmm.pmm25='0' THEN
      LET l_pmm.pmm25='1'
      #LET l_sql="UPDATE ",s_dbstring(l_dbs CLIPPED),"pmn_file SET pmn16='",l_pmm.pmm25, #FUN-A50102
      LET l_sql="UPDATE ",cl_get_target_table(l_pmm.pmmplant, 'pmn_file')," SET pmn16='",l_pmm.pmm25, #FUN-A50102
                "' WHERE pmn01='",l_pmm.pmm01,"' AND pmn16 ='0'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
      CALL cl_parse_qry_sql(l_sql, l_pmm.pmmplant) RETURNING l_sql  #FUN-A50102           
      PREPARE pmn16_upd FROM l_sql
      EXECUTE pmn16_upd 
      IF STATUS THEN
         CALL cl_err3("upd","pmn_file",l_pmm.pmm01,"",STATUS,"","upd pmn16",1)
         LET g_success = 'N' RETURN
      END IF
   END IF
 
   #LET l_sql = "UPDATE ",s_dbstring(l_dbs CLIPPED),"pmm_file SET pmm25='",l_pmm.pmm25, #FUN-A50102
   LET l_sql = "UPDATE ",cl_get_target_table(l_pmm.pmmplant, 'pmm_file')," SET pmm25='",l_pmm.pmm25, #FUN-A50102
               "',pmm18='Y',pmmconu='",g_user,"',pmmcond = '",g_today,"' WHERE pmm01 = '",l_pmm.pmm01,"'"      
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
   CALL cl_parse_qry_sql(l_sql, l_pmm.pmmplant) RETURNING l_sql  #FUN-A50102            
   PREPARE pmm_upd1 FROM l_sql
   EXECUTE pmm_upd1 
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","pmm_file",l_pmm.pmm01,"",STATUS,"","upd pmn18",1)
      LET g_success = 'N' RETURN
   END IF
 
END FUNCTION
 
#p_flag=TRUE =>開窗詢問是否執行  ;  p_flag=FALSE=>不詢問直接執行
FUNCTION t500sub_issue(l_pmm,p_flag)
   DEFINE l_cmd    LIKE type_file.chr1000   
   DEFINE l_pmm    RECORD LIKE pmm_file.*   
   DEFINE p_flag   LIKE type_file.num5      
   DEFINE l_argv3  LIKE pmm_file.pmm02     
   DEFINE l_cnt    LIKE type_file.num5    
   DEFINE l_dbs    LIKE azp_file.azp03
   DEFINE l_sql    STRING
  IF cl_null(l_pmm.pmm01) THEN CALL cl_err('','-400',1) RETURN END IF 
  
  CALL t500sub_azp(l_pmm.pmmplant) RETURNING l_dbs
  IF l_pmm.pmm18 = 'N' THEN CALL cl_err('pmm18=N','aap-717',1) RETURN END IF 
 
  #委外採購單供應商未輸入不可發出.........
  IF cl_null(l_pmm.pmm09) THEN
     CALL cl_err('','apm-197',1) RETURN END IF
 
  IF p_flag THEN
     IF NOT cl_confirm('mfg2747') THEN
        RETURN
     END IF
  END IF
  DISPLAY " confirm in"
 
  LET l_argv3=l_pmm.pmm02  
  CALL t500sub_update(l_pmm.*)
 
  DISPLAY "STATUS=",STATUS
 
END FUNCTION
 
FUNCTION t500_chk_date(l_pmm,l_dbs)
DEFINE   l_pmn33  LIKE pmn_file.pmn33
DEFINE   l_pmn02  LIKE pmn_file.pmn02
DEFINE   l_pmm    RECORD LIKE pmm_file.*
DEFINE   l_msg    LIKE type_file.chr1000
DEFINE   l_dbs    LIKE azp_file.azp03
DEFINE   l_sql STRING
 
     #LET l_sql = "SELECT pmn02,pmn33 FROM ",s_dbstring(l_dbs CLIPPED),"pmn_file WHERE pmn01='",l_pmm.pmm01,"'" #FUN-A50102
     LET l_sql = "SELECT pmn02,pmn33 FROM ",cl_get_target_table(l_pmm.pmmplant, 'pmn_file')," WHERE pmn01='",l_pmm.pmm01,"'" #FUN-A50102
     DECLARE t500_cs CURSOR FROM l_sql
     FOREACH t500_cs INTO l_pmn02,l_pmn33
         IF l_pmn33 < l_pmm.pmm04 THEN
            LET l_msg = l_pmm.pmm01,'-',l_pmn02
            CALL cl_err(l_msg,'apm-029',1)
            LET g_success='N'
            EXIT FOREACH
         END IF
     END FOREACH
 
END FUNCTION
 
FUNCTION t500sub_bud(p_afc00,p_afc01,p_afc02,p_afc03,p_afc04,p_afc041,
                     p_afc042,p_afc05,p_flag,p_cmd,p_sum1,p_sum2,p_flag1)
  DEFINE p_afc00     LIKE afc_file.afc00  #帳套編號
  DEFINE p_afc01     LIKE afc_file.afc01  #費用原因
  DEFINE p_afc02     LIKE afc_file.afc02  #會計科目
  DEFINE p_afc03     LIKE afc_file.afc03  #會計年度
  DEFINE p_afc04     LIKE afc_file.afc04  #WBS
  DEFINE p_afc041    LIKE afc_file.afc041 #部門編號
  DEFINE p_afc042    LIKE afc_file.afc042 #項目編號
  DEFINE p_afc05     LIKE afc_file.afc05  #期別
  DEFINE p_flag      LIKE type_file.chr1  #0.第一科目 1.第二科目
  DEFINE p_flag1     LIKE type_file.chr1  #1.單筆檢查 2.單身total檢查
  DEFINE p_cmd       LIKE type_file.chr1
  DEFINE p_sum1      LIKE afc_file.afc06 
  DEFINE p_sum2      LIKE afc_file.afc06 
  DEFINE l_flag      LIKE type_file.num5
  DEFINE l_afb07     LIKE afb_file.afb07
  DEFINE l_over      LIKE afc_file.afc07
 
      CALL s_budchk1(p_afc00,p_afc01,p_afc02,p_afc03,p_afc04,        
                     p_afc041,p_afc042,p_afc05,p_flag,p_cmd,p_sum1,p_sum2)
          RETURNING l_flag,l_afb07,l_over
      IF l_flag = FALSE THEN
         LET g_success = 'N'
         LET g_showmsg = p_afc00,'/',p_afc01,'/',p_afc02,'/',
                         p_afc03 USING "<<<&",'/',p_afc04,'/',
                         p_afc041,'/',p_afc042,'/',
                         p_afc05 USING "<&",p_sum2,'/',l_over
         IF p_flag1 = '2' THEN
            LET g_errno = 'agl-232'
         END IF
         IF g_bgerr THEN
            CALL s_errmsg('afc01',g_showmsg,'t420sub_bud',g_errno,1)
         ELSE
            CALL cl_err(g_showmsg,g_errno,1)
         END IF
      ELSE
         IF l_afb07 = '2' AND l_over < 0 THEN
            IF p_flag1 = '2' THEN
               LET g_errno = 'agl-232'
            END IF
            LET g_showmsg = p_afc00,'/',p_afc01,'/',p_afc02,'/',
                            p_afc03 USING "<<<&",'/',p_afc04,'/',
                            p_afc041,'/',p_afc042,'/',
                            p_afc05 USING "<&",p_sum2,'/',l_over
            IF g_bgerr THEN
               CALL s_errmsg('afc01',g_showmsg,'t420sub_bud',g_errno,1)
            ELSE
               CALL cl_err(g_showmsg,g_errno,1)
            END IF
            LET g_errno = ' '
         END IF
      END IF
END FUNCTION
 
FUNCTION t500sub_update(l_pmm)
   DEFINE
      l_pmm     RECORD LIKE pmm_file.*,
      p_pmm01   LIKE pmm_file.pmm01,    #採購單號
      p_pmm02   LIKE pmm_file.pmm02,
      p_pmm04   LIKE pmm_file.pmm04,    #採購日期
      p_pmm09   LIKE pmm_file.pmm09,    #廠商編號
      p_pmmplant  LIKE pmm_file.pmmplant,
      l_pmn20   LIKE pmn_file.pmn20,
      l_pmn04   LIKE pmn_file.pmn04,
      l_pmn31   LIKE pmn_file.pmn31,
      l_pmn31t  LIKE pmn_file.pmn31t,   
      l_pmn43   LIKE pmn_file.pmn43,    
      l_pmm21   LIKE pmm_file.pmm21,    
      l_pmm43   LIKE pmm_file.pmm43,  
      l_pmn35   LIKE pmn_file.pmn35,
      l_pmn44   LIKE pmn_file.pmn44,
      l_pmn09   LIKE pmn_file.pmn09,
      l_ima37   LIKE ima_file.ima37,
      l_pmn07   LIKE pmn_file.pmn07,      #採購單位
      l_ima44   LIKE ima_file.ima44,    
      l_ima908  LIKE ima_file.ima908,    
      l_pmn86   LIKE pmn_file.pmn86,      #計價單位
      l_pmn87   LIKE pmn_file.pmn87,      #計價單位
      l_unitrate LIKE pmn_file.pmn121,  
      l_sw      LIKE type_file.num10,               
      l_ima44_fac   LIKE ima_file.ima44_fac,
      l_sql     STRING, 
      l_dbs     LIKE azp_file.azp03
   
   LET p_pmm01 = l_pmm.pmm01
   LET p_pmm04 = l_pmm.pmm04
   LET p_pmm02 = l_pmm.pmm02
   LET p_pmm09 = l_pmm.pmm09
   LET p_pmmplant = l_pmm.pmmplant
   CALL t500sub_azp(p_pmmplant) RETURNING l_dbs
 
   #==>更改廠商資料檔中的最近採購日期
   #LET l_sql = "UPDATE ",s_dbstring(l_dbs CLIPPED),"pmc_file SET pmc40 = '",g_today,   #最近採購日期 #FUN-A50102
   LET l_sql = "UPDATE ",cl_get_target_table(l_pmm.pmmplant, 'pmc_file')," SET pmc40 = '",g_today,   #最近採購日期 #FUN-A50102
               "' WHERE pmc01 = '",l_pmm.pmm09,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
   CALL cl_parse_qry_sql(l_sql, l_pmm.pmmplant) RETURNING l_sql  #FUN-A50102            
   PREPARE pmc_upd FROM l_sql
   EXECUTE pmc_upd
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      LET g_success = 'N'
      CALL cl_err3("upd","pmc_file",l_pmm.pmm09,"",SQLCA.sqlcode,"","(ckp#3)",1)  
      RETURN
   END IF
 
   #==>更新[料件主檔]最近採購單價,在外量
   LET l_sql = " SELECT pmn04,pmn31,pmn31t,pmn20,pmn09,",    
               "ima53,ima531,ima532,ima37,pmm22,pmm42,pmn44,pmn35,pmn43 ",  
               ",pmn07,ima44,ima908,pmn86,pmn87 ",  
               #" FROM ",s_dbstring(l_dbs CLIPPED),"pmn_file,ima_file,",s_dbstring(l_dbs CLIPPED),"pmm_file", #FUN-A50102
               " FROM ",cl_get_target_table(l_pmm.pmmplant, 'pmn_file'),",","ima_file,",cl_get_target_table(l_pmm.pmmplant, 'pmm_file'), #FUN-A50102
               " WHERE pmn01 = '",l_pmm.pmm01,"'",
               "   AND pmm02 != 'SUB' ",
               "   AND pmn01 = pmm01 AND ima01 = pmn04 "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
   CALL cl_parse_qry_sql(l_sql, l_pmm.pmmplant) RETURNING l_sql  #FUN-A50102
   PREPARE ima_pl FROM l_sql
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL cl_err('prepare ima_p1 :',SQLCA.sqlcode,1)
      RETURN
   END IF
   DECLARE ima_cur2  CURSOR FOR ima_pl
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL cl_err('declare ima_cur2 :',SQLCA.sqlcode,1)
      RETURN
   END IF
 
   FOREACH ima_cur2 INTO l_pmn04,l_pmn31,l_pmn31t,l_pmn20,l_pmn09,   #No.FUN-610018
                          g_ima53,g_ima531,g_ima532,
                          l_ima37,g_pmm22,g_pmm42,l_pmn44,l_pmn35,l_pmn43  #No.FUN-670099
                          ,l_pmn07,l_ima44,l_ima908,l_pmn86,l_pmn87 #MOD-730044
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         IF g_bgerr THEN
            CALL s_errmsg("","","Foreach ima_cur2 :",SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("","","","",SQLCA.sqlcode,"","Foreach ima_cur2 :",1)
            END IF
         EXIT FOREACH
      END IF
      IF g_totsuccess="N" THEN
         LET g_success="N"
      END IF
 
      # if 為期間採購料件 then 更新 最近期間採購日期
         UPDATE ima_file SET ima881 = p_pmm04
           WHERE ima01 = l_pmn04
         IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            IF g_bgerr THEN
               CALL s_errmsg("ima01",l_pmn04,"Update ima881 Error",SQLCA.sqlcode,1)
               CONTINUE FOREACH
            ELSE
               CALL cl_err3("upd","ima_file",l_pmn04,"",SQLCA.sqlcode,"","Update ima881 Error",1)
               EXIT FOREACH
            END IF
         END IF
 
      #轉換成庫存單位
      # 更改單價 , 在外量
      LET l_pmn20 = l_pmn20*l_pmn09
      IF cl_null(l_pmn20) THEN LET l_pmn20=0 END IF   
      IF cl_null(l_pmn31) THEN LET l_pmn31=0 END IF   
      IF cl_null(l_pmn31t) THEN LET l_pmn31t=0 END IF 
      #LET l_sql="SELECT pmm21,pmm43 FROM ",s_dbstring(l_dbs CLIPPED),"pmm_file", #FUN-A50102
      LET l_sql="SELECT pmm21,pmm43 FROM ",cl_get_target_table(l_pmm.pmmplant, 'pmn_file'), #FUN-A50102
                " WHERE pmm01 = '",p_pmm01,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
      CALL cl_parse_qry_sql(l_sql, l_pmm.pmmplant) RETURNING l_sql  #FUN-A50102          
      PREPARE pmm_sel FROM l_sql
      EXECUTE pmm_sel  INTO l_pmm21,l_pmm43
      IF cl_null(l_ima908) THEN LET l_ima908 = l_ima44  END IF
      IF g_sma.sma116 MATCHES '[13]' THEN   
         LET l_ima44 = l_ima908
      END IF   
        IF NOT cl_null(l_pmn86) AND l_pmn86 <> l_ima44 THEN
           LET l_unitrate = 1
           CALL s_umfchk(l_pmn04,l_pmn86,l_ima44)
           RETURNING l_sw,l_unitrate
           IF l_sw THEN
              #單位換算率抓不到 ---#
              CALL cl_err(l_pmn04,'abm-731',1)
              IF NOT cl_confirm('lib-005') THEN 
                 LET g_success = 'N'
                 EXIT FOREACH
              END IF
           END IF
           LET l_pmn31  = l_pmn31/l_unitrate
           LET l_pmn31t = l_pmn31t/l_unitrate
        END IF
      #CALL up_price(l_pmn04,l_pmn87,l_pmn31,l_pmn31t,p_pmm09,l_pmm21,l_pmm43,l_pmn43,l_dbs) #No.FUN-610018  #No.FUN-670099  #MOD-730044 modify #FUN-A50102
      CALL up_price(l_pmn04,l_pmn87,l_pmn31,l_pmn31t,p_pmm09,l_pmm21,l_pmm43,l_pmn43,l_pmm.pmmplant) #No.FUN-610018  #No.FUN-670099  #MOD-730044 modify #FUN-A50102
      IF g_success = 'N' THEN
         EXIT FOREACH
      END IF
   END FOREACH
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
   DISPLAY 'update ok'
 
END FUNCTION
 
#FUNCTION up_price(p_part,p_qty,p_price,pt_price,p_pmm09,p_pmm21,p_pmm43,p_pmn43,l_dbs)    #No.FUN-610018  #No.FUN-670099 #FUN-A50102
FUNCTION up_price(p_part,p_qty,p_price,pt_price,p_pmm09,p_pmm21,p_pmm43,p_pmn43,l_plant)    #No.FUN-610018  #No.FUN-670099 #FUN-A50102
   DEFINE
      p_part       LIKE pmn_file.pmn04,   #料件編號
      p_qty        LIKE pmn_file.pmn20,   #數量
      p_price      LIKE pmn_file.pmn31,   #本幣單價
      pt_price     LIKE pmn_file.pmn31t,  #本幣含稅單價 
      p_pmm09      LIKE pmm_file.pmm09,
      p_pmm21      LIKE pmm_file.pmm21,   
      p_pmm43      LIKE pmm_file.pmm43,  
      p_pmn43      LIKE pmn_file.pmn43,   
      l_ecm04      LIKE ecm_file.ecm04,   
      l_new        LIKE pmn_file.pmn31,   # 更新後 Price
      lt_new       LIKE pmn_file.pmn31t,  # 更新後 Tax Price
      l_curr       LIKE pmm_file.pmm22,   # 更新後 Currency
      l_rate       LIKE pmm_file.pmm42,
      l_date       LIKE type_file.chr1,   #DATE
      l_pmh12      LIKE pmh_file.pmh12,
      l_pmh17      LIKE pmh_file.pmh17,   
      l_pmh18      LIKE pmh_file.pmh18,   
      l_pmh19      LIKE pmh_file.pmh19,   
      ln_pmh17     LIKE pmh_file.pmh17,  
      ln_pmh18     LIKE pmh_file.pmh18,   
      l_pmh13      LIKE pmh_file.pmh13,
      l_pmh14      LIKE pmh_file.pmh14,
      l_price1     LIKE ima_file.ima53,
      l_price2     LIKE ima_file.ima531
   DEFINE l_pmh    RECORD LIKE pmh_file.*
   #DEFINE l_dbs    LIKE azp_file.azp03 #FUN-A50102
   DEFINE l_plant    LIKE pmm_file.pmmplant #FUN-A50102
   DEFINE l_sql    STRING
   
   IF p_pmn43 = 0 OR cl_null(p_pmn43) THEN
      LET l_ecm04 = " "
   ELSE
      #LET l_sql="SELECT ecm04 FROM ",s_dbstring(l_dbs CLIPPED),"ecm_file", #FUN-A50102
      LET l_sql="SELECT ecm04 FROM ",cl_get_target_table(l_plant, 'ecm_file'), #FUN-A50102
                " WHERE ecm03 = '",p_pmn43,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql  #FUN-A50102           
      PREPARE ecm_cs1 FROM l_sql
      EXECUTE ecm_cs1  INTO l_ecm04
   END IF
 
   LET l_price1 =0
   LET l_price2 =0
   CASE  g_sma.sma843
      WHEN '1'
         LET l_price1 = p_price*g_pmm42
         IF l_price1 <=0 THEN
            LET l_price1 = g_ima53
         END IF
      WHEN '2'
         IF cl_null(g_ima53) THEN
             LET g_ima53 = 0
         END IF
         IF (p_price*g_pmm42 < g_ima53) OR (g_ima53=0) THEN
            LET l_price1 = p_price*g_pmm42
            #-->值為零則不變動
            IF l_price1 <=0 THEN
               LET l_price1 = g_ima53
            END IF
         ELSE
            LET l_price1 = g_ima53
         END IF
      OTHERWISE
         LET l_price1 = g_ima53
   END CASE
   CASE  g_sma.sma844 #採購單發出時, 更新料件主檔市價方式
      WHEN '1'      #無條件
         LET l_price2 = p_price*g_pmm42
         LET l_date   = g_today
         IF l_price2 <= 0 THEN        #單價為零不更新
            LET l_price2 = g_ima531
            LET l_date   = g_ima532
         END IF
      WHEN '2'      #較低
         IF cl_null(g_ima531) THEN
             LET g_ima531 = 0
         END IF
         IF (p_price*g_pmm42 < g_ima531) OR (g_ima531 = 0) THEN
            LET l_price2 = p_price*g_pmm42
            LET l_date   = g_today
            IF l_price2 <= 0 THEN        #單價為零不更新
               LET l_price2 = g_ima531
               LET l_date   = g_ima532
            END IF
         ELSE       #不更新
            LET l_price2 = g_ima531
            LET l_date   = g_ima532
         END IF
      OTHERWISE  #不更新
         LET l_price2 = g_ima531
         LET l_date   = g_ima532
   END CASE
 
   {ckp#4}
   #==>更新料件主檔中的
   UPDATE ima_file SET ima53  = l_price1,
                       ima531 = l_price2,
                       ima532 = l_date
     WHERE ima01  = p_part
   IF SQLCA.sqlerrd[3] = 0 THEN
      LET g_success = 'N'
     IF g_bgerr THEN
         CALL s_errmsg("ima01",p_part,"(ckp#4)",SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3("","","","",SQLCA.sqlcode,"","(ckp#4)",1)
      END IF
      RETURN
   END IF
 
   {ckp#5}
   #==>如存在[料件/供應商檔]中則更新其最近採購單價
   LET l_sql="SELECT pmh12,pmh17,pmh18,pmh19,pmh13,pmh14", 
             #"  FROM ",s_dbstring(l_dbs CLIPPED),"pmh_file", #FUN-A50102
             "  FROM ",cl_get_target_table(l_plant, 'pmh_file'), #FUN-A50102
             " WHERE pmh01 = '",p_part,"' AND pmh02 = '",p_pmm09,"' AND pmh13='",g_pmm22,
             "' AND pmh21 = '",l_ecm04,"' AND pmh22 ='1'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
   CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql  #FUN-A50102          
   PREPARE pmh_cs2 FROM l_sql
   EXECUTE pmh_cs2 INTO l_pmh12,l_pmh17,l_pmh18,l_pmh19,l_pmh13,l_pmh14
   IF SQLCA.sqlcode = 0 THEN
      CASE
         WHEN g_sma.sma842 = '1'
            LET l_new = p_price
            LET lt_new = pt_price  
            LET ln_pmh17 = p_pmm21  
            LET ln_pmh18 = p_pmm43  
            LET l_curr= g_pmm22
            LET l_rate= g_pmm42
            IF l_new <= 0 THEN
               LET l_new = l_pmh12
               LET lt_new = l_pmh19  
               LET ln_pmh17=l_pmh17  
               LET ln_pmh18=l_pmh18  
               LET l_curr= l_pmh13
               LET l_rate= l_pmh14
            END IF
         WHEN g_sma.sma842 = '2' AND g_pmm22 != l_pmh13
            IF p_price*g_pmm42 < l_pmh12*l_pmh14 THEN
               LET l_new = p_price
               LET lt_new = pt_price  
               LET ln_pmh17 = p_pmm21  
               LET ln_pmh18 = p_pmm43  
               LET l_curr= g_pmm22
               LET l_rate= g_pmm42
               IF l_new <= 0 THEN
                  LET l_new = l_pmh12
                  LET lt_new = l_pmh19  
                  LET ln_pmh17=l_pmh17  
                  LET ln_pmh18=l_pmh18  
                  LET l_curr= l_pmh13
                  LET l_rate= l_pmh14
               END IF
            ELSE
               LET l_new = l_pmh12
               LET lt_new = l_pmh19  
               LET ln_pmh17=l_pmh17  
               LET ln_pmh18=l_pmh18  
               LET l_curr= l_pmh13
               LET l_rate= l_pmh14
            END IF
         WHEN g_sma.sma842 = '2' AND g_pmm22 = l_pmh13
            IF p_price < l_pmh12 OR pt_price < l_pmh19 OR l_pmh12 = 0 THEN  
               LET l_new = p_price
               LET lt_new = pt_price  
               LET ln_pmh17 = p_pmm21  
               LET ln_pmh18 = p_pmm43  
               LET l_curr= g_pmm22
               LET l_rate= g_pmm42
               IF l_new <= 0 THEN
                  LET l_new = l_pmh12
                  LET lt_new = l_pmh19  
                  LET ln_pmh17=l_pmh17  
                  LET ln_pmh18=l_pmh18 
                  LET l_curr= l_pmh13
                  LET l_rate= l_pmh14
               END IF
            ELSE
               LET l_new = l_pmh12
               LET lt_new = l_pmh19  
               LET ln_pmh17=l_pmh17  
               LET ln_pmh18=l_pmh18  
               LET l_curr= l_pmh13
               LET l_rate= l_pmh14
            END IF
        OTHERWISE
            LET l_new = l_pmh12
            LET lt_new = l_pmh19  
            LET ln_pmh17=l_pmh17  
            LET ln_pmh18=l_pmh18  
            LET l_curr= l_pmh13
            LET l_rate= l_pmh14
      END CASE
      IF p_part[1,4] <>'MISC' THEN
         #LET l_sql="UPDATE ",s_dbstring(l_dbs CLIPPED),"pmh_file SET pmh12 = '",l_new, #FUN-A50102
         LET l_sql="UPDATE ",cl_get_target_table(l_plant, 'pmh_file')," SET pmh12 = '",l_new, #FUN-A50102
                             "', pmh17 = '",ln_pmh17, 
                             "', pmh18 = '",ln_pmh18, 
                             "', pmh19 = '",lt_new,   
                             "', pmh13 = '",l_curr,
                             "', pmh14 = '",l_rate,       
                             "' WHERE pmh01 = '",p_part,"' AND pmh02 = '",p_pmm09,"' AND pmh13='",g_pmm22,
                             "' AND pmh21 = '",l_ecm04, 
                             "' AND pmh22 = '1'"  
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
         CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql  #FUN-A50102                    
         PREPARE pmh_upd FROM l_sql
         EXECUTE pmh_upd
         IF SQLCA.sqlerrd[3] = 0 THEN
            LET g_success = 'N'
           IF g_bgerr THEN
               LET g_showmsg = p_part,"/",p_pmm09
               CALL s_errmsg("pmh01,pmh21,pmh22",g_showmsg,"(ckp#5)",SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("upd","pmh_file",p_part,p_pmm09,SQLCA.sqlcode,"","(ckp#5)",1)
            END IF
         END IF
      END IF
    ELSE
      LET l_pmh.pmh01=p_part
      LET l_pmh.pmh02=p_pmm09
      LET l_pmh.pmh03='N'
      IF g_sma.sma102 = 'Y' THEN
         LET l_pmh.pmh05='1'
      ELSE
         LET l_pmh.pmh05='0'
      END IF
      LET l_pmh.pmh06=NULL
      LET l_pmh.pmh10=NULL
      LET l_pmh.pmh11=0
      LET l_pmh.pmh12=p_price
      LET l_pmh.pmh19=pt_price  
      LET l_pmh.pmh17=p_pmm21  
      LET l_pmh.pmh18=P_pmm43   
      LET l_pmh.pmh13=g_pmm22
      LET l_pmh.pmh14=g_pmm42
      LET l_pmh.pmh21=l_ecm04  
      LET l_pmh.pmh22="1"    
      LET l_pmh.pmh23 = ' '    
      LET l_pmh.pmhacti='Y'
      LET l_pmh.pmhuser=g_user
      LET l_pmh.pmhoriu = g_user #FUN-980030
      LET l_pmh.pmhorig = g_grup #FUN-980030
      LET l_pmh.pmhgrup=g_grup
      LET l_pmh.pmhdate = g_today
      LET l_pmh.pmh24='N'
      SELECT ima100,ima24,ima101,ima102
        INTO l_pmh.pmh09,l_pmh.pmh08,l_pmh.pmh15,l_pmh.pmh16
        FROM ima_file
       WHERE ima01=p_part
      IF cl_null(l_pmh.pmh13) THEN LET l_pmh.pmh13=' ' END IF
      #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"pmh_file", #FUN-A50102
      LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant, 'pmh_file'), #FUN-A50102
                  " VALUES (?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                  "         ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?  ,?)"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql  #FUN-A50102            
      PREPARE pmh_ins FROM l_sql
      EXECUTE pmh_ins USING l_pmh.*
      IF STATUS THEN
         LET g_success='N'
         IF g_bgerr THEN
            LET g_showmsg = l_pmh.pmh01,"/",l_pmh.pmh02,"/",l_pmh.pmh13,"/",l_pmh.pmh21,"/",l_pmh.pmh22
            CALL s_errmsg("pmh01,pmh02,pmh13,pmh21,pmh22",g_showmsg,"(artt500_sub:ins#)",SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("ins","pmh_file","","",STATUS,"","(ins#)",1)
         END IF
      END IF
   END IF
END FUNCTION
#FUN-870007 PASS NO.
