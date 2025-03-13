# Prog. Version..: '5.30.06-13.03.12(00006)'     #
# Pattern name...: afap111.4gl
# Descriptions...: 資產整批確認/取消確認作業 
# Date & Author..: 10/01/26 By lutingting   #FUN-A10129 
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-AB0088 11/04/07 By lixiang 固定资料財簽二功能
# Modify.........: No.FUN-B50090 11/05/17 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No:FUN-B60140 11/09/06 By minpp "財簽二二次改善"追單
# Modify.........: No:MOD-C70262 12/07/31 By Polly 取消確認的部份增加關帳日期控卡

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_wc,g_sql   string                                
DEFINE i,j          LIKE type_file.num5                   
DEFINE tm RECORD    check  LIKE type_file.chr1              
          END RECORD       
DEFINE g_faj               RECORD LIKE faj_file.*
DEFINE g_cnt               LIKE type_file.num10   
DEFINE g_change_lang       LIKE type_file.chr1    
DEFINE p_row,p_col         LIKE type_file.num5
MAIN
   DEFINE      ls_date       STRING,               
               l_flag        LIKE type_file.chr1   

   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT


   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.check     = ARG_VAL(1)      #INPUT條件
   LET g_wc         = ARG_VAL(2)      #QBE條件
   LET g_bgjob      = ARG_VAL(3)      #背景作業
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF



   CALL  cl_used(g_prog,g_time,1) RETURNING g_time 

   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p111()
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
            IF tm.check = '1' THEN  
               CALL p111_process1()  #確認
            ELSE
               CALL p111_process2()  #取消確認
            END IF 
            CALL s_showmsg()  
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p111_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         BEGIN WORK
         IF tm.check = '1' THEN   
            CALL p111_process1()  #確認
         ELSE
            CALL p111_process2()  #取消確認
         END IF
         CALL s_showmsg()   
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION p111()
   DEFINE   l_str    LIKE type_file.chr8       
   DEFINE   l_str4   LIKE type_file.chr4       
   DEFINE   lc_cmd   LIKE type_file.chr1000    

   OPEN WINDOW p111_w AT p_row,p_col WITH FORM "afa/42f/afap111"
      ATTRIBUTE (STYLE = g_win_style)

    CALL cl_ui_init()


   CLEAR FORM
   CALL cl_opmsg('w')

   WHILE TRUE

   LET g_bgjob = 'N' 
   LET tm.check = '1'

   INPUT BY NAME tm.check,g_bgjob WITHOUT DEFAULTS 
      AFTER FIELD check
         IF NOT cl_null(tm.check) THEN
            IF tm.check NOT MATCHES '[12]' THEN
               NEXT FIELD check
            END IF 
         END IF 

      ON ACTION locale
         CALL cl_show_fld_cont()
         LET g_change_lang = "locale"
         EXIT INPUT

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about     
         CALL cl_about()  

      ON ACTION help         
         CALL cl_show_help() 

      ON ACTION controlg    
         CALL cl_cmdask()  


      ON ACTION exit                            #加離開功能
         LET INT_FLAG = 1
         EXIT INPUT

   END INPUT

   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p111_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF

   DISPLAY BY NAME g_bgjob  

   CONSTRUCT BY NAME g_wc ON faj01,faj02,faj022 

        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(faj02) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_faj02"
                 IF tm.check = '1' THEN
                    LET g_qryparam.arg1 = 'N'
                 ELSE
                    LET g_qryparam.arg1 = 'Y'
                 END IF 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO faj02
                 NEXT FIELD faj02
              WHEN INFIELD(faj022)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_faj"
                 LET g_qryparam.multiret_index = 2
                 CALL cl_create_qry() RETURNING g_qryparam.multiret 
                 DISPLAY g_qryparam.multiret TO faj022 
                 NEXT FIELD faj022
           END CASE

       ON ACTION locale
           LET g_change_lang = TRUE    
           EXIT CONSTRUCT             

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about     
         CALL cl_about()   
 
      ON ACTION help         
         CALL cl_show_help() 
 
      ON ACTION controlg    
         CALL cl_cmdask()   
 

      ON ACTION exit                            #加離開功能
         LET INT_FLAG = 1
         EXIT CONSTRUCT 

    END CONSTRUCT
    IF g_change_lang THEN
       LET g_change_lang = FALSE
       CALL cl_dynamic_locale()
       CONTINUE WHILE
    END IF
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLOSE WINDOW p111_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM
    END IF

   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "afap111"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('afap111','9031',1)  
      ELSE
         LET g_wc=cl_replace_str(g_wc, "'", "\"")
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",tm.check CLIPPED,"'",
                      " '",g_wc CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('afap111',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p111_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
   EXIT WHILE
END WHILE
END FUNCTION
   
FUNCTION p111_process1()
   LET g_sql=" SELECT * FROM faj_file ",
             "  WHERE  fajconf = 'N' AND ",g_wc CLIPPED,
             "  ORDER BY faj01 " 
   PREPARE p111_pre FROM g_sql
   DECLARE p111_cur CURSOR FOR p111_pre
   LET g_success = 'Y'
   CALL s_showmsg_init()
   LET g_cnt = 0
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
   FOREACH p111_cur INTO g_faj.* 
      IF STATUS THEN 
         CALL s_errmsg('','','p111(foreach):',STATUS,0) 
         EXIT FOREACH
      END IF

      IF g_success='N' THEN
         LET g_totsuccess='N'
         LET g_success="Y"
      END IF

      IF cl_null(g_faj.faj02) THEN
         CALL s_errmsg('faj02',g_faj.faj02,'IS NULL','',1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF 

      IF g_faj.faj37 ='Y' THEN
         IF g_faj.faj26 <= g_faa.faa09 THEN
            CALL s_errmsg('faj26',g_faj.faj26,'','afa-517',1)
            LET g_success = 'N'
            CONTINUE FOREACH
         END IF
         #-----No:FUN-AB0088-----
         IF g_faa.faa31 = 'Y' THEN
            #IF g_faj.faj262 <= g_faa.faa09 THEN
            IF g_faj.faj262 <= g_faa.faa092 THEN  #No:FUN-B60140
               CALL s_errmsg('faj262',g_faj.faj262,'','afa-517',1)
               LET g_success = 'N'
               CONTINUE FOREACH
            END IF
         END IF
         #-----No:FUN-AB0088 END-----
      END IF 

      UPDATE faj_file SET fajconf = 'Y'
       WHERE faj02 = g_faj.faj02
         AND faj01 = g_faj.faj01
         AND faj022 = g_faj.faj022
      IF STATUS THEN        
         CALL s_errmsg('faj01,faj02,faj022',g_faj.faj01,'upd fajconf','',1)
         LET g_success = 'N'
      END IF 

      ## other_data維護作業,若是否直接資本化為'Y',
      ##資產狀態應為'1'資本化
      IF g_faj.faj37 = 'Y' AND 
        (g_faj.faj43 <> '4' OR g_faj.faj31 <> g_faj.faj33) THEN 
          UPDATE faj_file SET faj43 = '1',
                              faj201 = '1'
           WHERE faj02 = g_faj.faj02
             AND faj01 = g_faj.faj01
             AND faj022 = g_faj.faj022
           IF STATUS THEN  
             CALL s_errmsg('faj01',g_faj.faj01,'upd faj43','',1)
             LET g_success = 'N'
           END IF
      END IF

      #-----No:FUN-AB0088-----
      IF g_faa.faa31 = 'Y' THEN
         IF g_faj.faj37 = 'Y' AND
           (g_faj.faj432 <> '4' OR g_faj.faj312 <> g_faj.faj332) THEN
             UPDATE faj_file SET faj432 = '1',
                                 faj2012 = '1'
              WHERE faj02 = g_faj.faj02
                AND faj01 = g_faj.faj01
                AND faj022 = g_faj.faj022
              IF STATUS THEN
                CALL s_errmsg('faj01',g_faj.faj01,'upd faj432','',1)
                LET g_success = 'N'
              END IF
         END IF
      END IF
      #-----No:FUN-AB0088 END-----

      IF g_success = 'Y' THEN
         LET g_cnt = g_cnt+1
      END IF 
   END FOREACH
   DISPLAY g_cnt TO FORMONLY.cnt
   IF g_totsuccess = 'N' THEN
      LET g_success = 'N'
   END IF
   #genero若g_cnt>1筆表是有1筆以上成功
   IF g_cnt>0 THEN
      LET g_success = "Y"        #批次作業正確結束
   ELSE
      LET g_success = "N"        #批次作業失敗
   END IF 
END FUNCTION 

FUNCTION p111_process2()
DEFINE l_cnt LIKE type_file.num5
   LET g_sql=" SELECT * FROM faj_file ",
             "  WHERE  fajconf = 'Y' AND ",g_wc CLIPPED,
             "  ORDER BY faj01 "
   PREPARE p111_pre1 FROM g_sql
   DECLARE p111_cur1 CURSOR FOR p111_pre1
   LET g_success = 'Y'
   CALL s_showmsg_init()
   LET g_cnt = 0
   FOREACH p111_cur1 INTO g_faj.*
      IF STATUS THEN
         CALL s_errmsg('','','p111_cur1(foreach):',STATUS,0)
         EXIT FOREACH
      END IF

      IF g_success='N' THEN
         LET g_totsuccess='N'
         LET g_success="Y"
      END IF

      IF g_faj.faj37 = 'N' AND g_faj.faj43 != '0' THEN
         CALL s_errmsg('faj02',g_faj.faj02,'','afa-315',1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF

     #---------------------MOD-C70262------------------------(S)
      IF g_faj.faj26 <= g_faa.faa09 THEN
         CALL s_errmsg('faj02',g_faj.faj02,'','afa-517',1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
      IF g_faa.faa31 = 'Y' THEN
         IF g_faj.faj262 <= g_faa.faa092 THEN
            CALL s_errmsg('faj02',g_faj.faj02,'','afa-517',1)
            LET g_success = 'N'
            CONTINUE FOREACH
         END IF
      END IF
     #---------------------MOD-C70262------------------------(E)

      IF g_faj.faj37 = 'Y' AND g_faj.faj43 NOT MATCHES'[01]' THEN
         CALL s_errmsg('faj02',g_faj.faj02,'','afa-315',1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF

      IF g_faj.faj42 NOT MATCHES'[01]' THEN
         CALL s_errmsg('faj02',g_faj.faj02,'','afa-316',1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
   
      #-----No:FUN-AB0088-----
      IF g_faa.faa31 = 'Y' THEN
         IF g_faj.faj37 = 'N' AND g_faj.faj432 != '0' THEN
            CALL s_errmsg('faj02',g_faj.faj02,'','afa-315',1)
            LET g_success = 'N'
            CONTINUE FOREACH
         END IF

         IF g_faj.faj37 = 'Y' AND g_faj.faj432 NOT MATCHES'[01]' THEN
            CALL s_errmsg('faj02',g_faj.faj02,'','afa-315',1)
            LET g_success = 'N'
            CONTINUE FOREACH
         END IF
      END IF
      #-----No:FUN-AB0088 END-----

      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM fap_file
       WHERE fap02 = g_faj.faj02
         AND fap021= g_faj.faj022
      IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
      IF l_cnt > 0 THEN
         CALL s_errmsg('faj02',g_faj.faj02,'','afa-192',1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF

      IF g_faj.faj37 = 'Y' AND g_faj.faj43 MATCHES '[1]' THEN
         UPDATE faj_file SET faj43 = '0',
                             faj201 = '0'
          WHERE faj01 = g_faj.faj01
            AND faj02 = g_faj.faj02
            AND faj022 = g_faj.faj022
          IF STATUS  THEN       
             CALL s_errmsg('faj01',g_faj.faj01,'upd faj43',STATUS,1)        
             LET g_success = 'N'
          END IF 
      END IF

      #-----No:FUN-AB0088-----
      IF g_faa.faa31 = 'Y' THEN
         IF g_faj.faj37 = 'Y' AND g_faj.faj432 MATCHES '[1]' THEN
            UPDATE faj_file SET faj432 = '0',
                                faj2012 = '0'
             WHERE faj01 = g_faj.faj01
               AND faj02 = g_faj.faj02
               AND faj022 = g_faj.faj022
             IF STATUS  THEN
                CALL s_errmsg('faj01',g_faj.faj01,'upd faj432',STATUS,1)
                LET g_success = 'N'
             END IF
         END IF
      END IF
      #-----No:FUN-AB0088 END-----

      UPDATE faj_file SET fajconf = 'N'
       WHERE faj01 = g_faj.faj01
         AND faj02 = g_faj.faj02
         AND faj022 = g_faj.faj022
      IF STATUS THEN
         CALL s_errmsg('faj01,faj02,faj022',g_faj.faj01,'upd fajconf',STATUS,1)
         LET g_success = 'N'
      END IF

      IF g_success = 'Y' THEN
         LET g_cnt = g_cnt+1
      END IF
   END FOREACH
   DISPLAY g_cnt TO FORMONLY.cnt
   IF g_totsuccess = 'N' THEN
      LET g_success = 'N'
   END IF
   #genero若g_cnt>1筆表是有1筆以上成功
   IF g_cnt>0 THEN
      LET g_success = "Y"        #批次作業正確結束
   ELSE
      LET g_success = "N"        #批次作業失敗
   END IF
END FUNCTION
#FUN-A10129
