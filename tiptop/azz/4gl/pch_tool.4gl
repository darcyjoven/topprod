# Description....: GP5.3 Patch 第8包 解包前檢查db資料小程式
# Date & Author..: 13/04/23 By apo 

IMPORT os

DATABASE ds

DEFINE g_dblist             DYNAMIC ARRAY OF STRING 
DEFINE g_cnt                LIKE type_file.num10
DEFINE g_db_type            LIKE type_file.chr3 
DEFINE g_dbs                LIKE type_file.chr21
DEFINE g_tcp_servername     LIKE type_file.chr30
DEFINE g_msg                base.Channel
DEFINE g_file               STRING

MAIN
   WHENEVER ERROR CONTINUE
   DISPLAY "============== 執行中，請稍候... ================="
   CALL g_dblist.clear()
   CALL get_dblist() #取得DB
   CALL get_pchlog() #建立log檔

   CALL tool_update_axa()
   
   DISPLAY "============== 檢查完成 =================" 
   IF os.Path.size(g_file) = 0 THEN
      CALL g_msg.write("檢核完成，沒有需要手動調整的資料")
   END IF
   DISPLAY "請至 ", g_file ," 查看執行結果!"
   CALL g_msg.close()
END MAIN

FUNCTION tool_update_axa()
   DEFINE l_cnt  LIKE type_file.num5
   DEFINE l_msg  STRING
   DEFINE l_pth07 LIKE pth_file.pth07 

   SELECT MAX(pth07) INTO l_pth07 FROM pth_file WHERE pth07 LIKE 'A%'
   IF l_pth07 = 'A-0000000007-5.30.06-ORA_1_UN.tar' THEN 
       FOR g_cnt = 1 TO g_dblist.getLength()
          # 轉換資料庫
          LET g_dbs = g_dblist[g_cnt] CLIPPED
          CALL tool_set_erpdb()
          IF SQLCA.sqlcode THEN
             DISPLAY '轉換資料庫失敗，請檢查資料庫密碼設定，營運中心:',g_dbs
             LET l_msg = '轉換資料庫失敗，請檢查資料庫密碼設定，營運中心:',g_dbs
             CALL g_msg.write(l_msg)
             CONTINUE FOR
          ELSE
             DISPLAY '檢核營運中心[',g_dbs,']此次alter成NOT NULL的欄位，是否有為NULL的資料'
             
             SELECT COUNT(*) INTO l_cnt FROM cdm_file WHERE cdm11 IS NULL
             IF l_cnt > 0 THEN
                DISPLAY '   cdm_file.cdm11:',l_cnt,'筆'
                UPDATE cdm_file SET cdm11 = ' ' WHERE cdm11 IS NULL
             END IF

             DISPLAY '營運中心[',g_dbs,']檢核完成'
          END IF
       END FOR

       FOR g_cnt = 1 TO g_dblist.getLength()
          # 轉換資料庫
          LET g_dbs = g_dblist[g_cnt] CLIPPED
          CALL tool_set_erpdb()
          IF SQLCA.sqlcode THEN
             DISPLAY '轉換資料庫失敗，請檢查資料庫密碼設定，營運中心:',g_dbs
             LET l_msg = '檢轉換資料庫失敗，請檢查資料庫密碼設定，營運中心:',g_dbs
             CALL g_msg.write(l_msg)
             CONTINUE FOR
          ELSE
             DISPLAY '檢核營運中心[',g_dbs,']是否有重複資料'

             SELECT COUNT(*) INTO l_cnt 
               FROM icz_file a 
                WHERE a.rowid != (SELECT MAX(b.rowid) FROM icz_file b 
                                   WHERE a.icz01 = b.icz01 AND a.icz02 = b.icz02 AND a.icz03= b.icz03 
                                     AND a.icz04 = b.icz04 AND a.icz11 = b.icz11)
                                                 
             IF l_cnt > 0 THEN
                DISPLAY '檢核營運中心[',g_dbs,'] icz_file 有[',l_cnt,']筆重複資料，需手動調整資料！'
                LET l_msg = '檢核營運中心[',g_dbs,']檢核 icz_file 有[',l_cnt,']筆重複資料，需手動調整資料！'
                CALL g_msg.write(l_msg)
             END IF

             LET l_cnt = 0
             SELECT COUNT(*) INTO l_cnt
               FROM ayf_file a
                WHERE a.rowid != (SELECT MAX(b.rowid) FROM ayf_file b
                                   WHERE a.ayf00 = b.ayf00 AND a.ayf01 = b.ayf01 AND a.ayf02 = b.ayf02
                                     AND a.ayf03 = b.ayf03 AND a.ayf04 = b.ayf04 AND a.ayf09 = b.ayf09
                                     AND a.ayf10 = b.ayf10 AND a.ayf11 = b.ayf11)
             IF l_cnt > 0 THEN
                DISPLAY '檢核營運中心[',g_dbs,'] ayf_file 有[',l_cnt,']筆重複資料，需手動調整資料！'
                LET l_msg = '檢核營運中心[',g_dbs,']檢核 ayf_file 有[',l_cnt,']筆重複資料，需手動調整資料！'
                CALL g_msg.write(l_msg)
             END IF

             LET l_cnt = 0
             SELECT COUNT(*) INTO l_cnt
               FROM cdm_file a
                WHERE a.rowid != (SELECT MAX(b.rowid) FROM cdm_file b
                                   WHERE a.cdm00 = b.cdm00 AND a.cdm01 = b.cdm01 AND a.cdm02 = b.cdm02
                                     AND a.cdm03 = b.cdm03 AND a.cdm04 = b.cdm04 AND a.cdm05 = b.cdm05 
                                     AND a.cdm06 = b.cdm06 AND a.cdm11 = b.cdm11)
             IF l_cnt > 0 THEN
                DISPLAY '檢核營運中心[',g_dbs,'] cdm_file 有[',l_cnt,']筆重複資料，需手動調整資料！'
                LET l_msg = '檢核營運中心[',g_dbs,']檢核 cdm_file 有[',l_cnt,']筆重複資料，需手動調整資料！'
                CALL g_msg.write(l_msg)
             END IF

             DISPLAY '營運中心[',g_dbs,']檢核完成'

          END IF
       END FOR
       
       LET g_dbs = 'ds'
       CALL tool_set_erpdb()
       IF SQLCA.sqlcode THEN
          DISPLAY '轉換資料庫失敗，請檢查資料庫密碼設定，營運中心:',g_dbs
          RETURN
       END IF
    ELSE
       FOR g_cnt = 1 TO g_dblist.getLength()
          # 轉換資料庫
          LET g_dbs = g_dblist[g_cnt] CLIPPED
          CALL tool_set_erpdb()
          IF SQLCA.sqlcode THEN
             DISPLAY '轉換資料庫失敗，請檢查資料庫密碼設定，營運中心:',g_dbs
             LET l_msg = '檢轉換資料庫失敗，請檢查資料庫密碼設定，營運中心:',g_dbs
             CALL g_msg.write(l_msg)
             CONTINUE FOR
          ELSE
             DISPLAY '更新營運中心[',g_dbs,']資料'
             UPDATE pod_file SET pod08 = (SELECT sma96 FROM sma_file)
             DISPLAY '營運中心[',g_dbs,']更新完成'
          END IF
       END FOR
    END IF
END FUNCTION

#建立log檔
FUNCTION get_pchlog()
   LET g_file = os.Path.join(FGL_GETENV('TEMPDIR'),"pch_tool.log")
   LET g_msg = base.Channel.create()
   CALL g_msg.openFile(g_file,"w")
   CALL g_msg.setDelimiter("")
END FUNCTION

#取得DB清單
FUNCTION get_dblist()
DEFINE l_azp03    LIKE azp_file.azp03 #法人DB
DEFINE lc_azp03   LIKE azp_file.azp03 #法人DB下所屬DB
DEFINE lv_azp03   LIKE azp_file.azp03 #虛擬DB
DEFINE li_i       LIKE type_file.num5 
DEFINE l_sql      STRING
   LET g_dblist[1] = 'ds'
   #找法人DB
   DECLARE erp_db_cur CURSOR FOR
      SELECT DISTINCT azw09 FROM azw_file
       INNER JOIN all_users ON username = UPPER(azw09)
       WHERE azw09 <> 'ds'
   FOREACH erp_db_cur INTO l_azp03
      LET g_dblist[g_dblist.getLength() + 1] = l_azp03
      # 找法人DB下所屬的DB清單
      SELECT COUNT(*) INTO li_i FROM azw_file
       inner join all_users on username = UPPER(azw05)
        WHERE azw05 = azw06
         AND azw05 <> azw09
          AND azw09 = l_azp03
      IF li_i > 0 THEN
         LET l_sql ="SELECT DISTINCT azw05 FROM azw_file",
                    " inner join all_users on username = UPPER(azw05)",
                    " WHERE azw05 = azw06",
                    " AND azw05 <> azw09",
                    " AND azw09 = '",l_azp03 CLIPPED,"'"
         DECLARE erp_db_cur2 CURSOR FROM l_sql
         FOREACH erp_db_cur2 INTO lc_azp03
            LET g_dblist[g_dblist.getLength() + 1] = lc_azp03
         END FOREACH
      END IF   
      # 找虛擬DB
      LET li_i = 0
      SELECT COUNT(*) INTO li_i FROM azw_file
       inner join all_users on username = UPPER(azw06)
        WHERE azw05 <> azw06
         AND azw09 = l_azp03 
      IF li_i > 0 THEN
         LET l_sql = "SELECT DISTINCT azw06 FROM azw_file",
                     " inner join all_users on username = UPPER(azw06)",
                     " WHERE azw05 <> azw06",
                     " AND azw09 = '",l_azp03 CLIPPED,"'"
         DECLARE erp_db_cur3 CURSOR FROM l_sql
         FOREACH erp_db_cur3 INTO lv_azp03
            LET g_dblist[g_dblist.getLength() + 1] = lv_azp03
         END FOREACH
      END IF
   END FOREACH
END FUNCTION

#轉換資料庫(參考p_zta寫法)
FUNCTION tool_set_erpdb()
   DEFINE l_dbs     LIKE type_file.chr50
   DEFINE l_ch     base.Channel
 
################ for informix synonym ##############
    IF g_db_type="IFX" THEN
       DISCONNECT ALL
       DATABASE g_dbs
    END IF
####################################################
 
    CLOSE DATABASE
    DATABASE g_dbs
 
    IF g_db_type="IFX" THEN
       LET l_ch = base.Channel.create()
       CALL l_ch.openPipe("cat $INFORMIXDIR/etc/$ONCONFIG|grep DBSERVERALIASES|awk '{ print $2 }'","r")
       WHILE l_ch.read(g_tcp_servername)
             DISPLAY "tcp_servername:",g_tcp_servername
       END WHILE
       LET l_dbs=g_dbs CLIPPED,"@",g_tcp_servername CLIPPED
       CONNECT TO l_dbs AS "MAIN"
       IF status THEN
          CALL l_ch.openPipe("cat $INFORMIXDIR/etc/$ONCONFIG|grep DBSERVERNAME|awk '{ print $2 }'","r")
          WHILE l_ch.read(g_tcp_servername)
                DISPLAY "tcp_servername:",g_tcp_servername
          END WHILE
          LET l_dbs=g_dbs CLIPPED,"@",g_tcp_servername CLIPPED
          CONNECT TO l_dbs AS "MAIN"
       END IF
    END IF
END FUNCTION
