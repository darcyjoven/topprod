# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: afar404.4gl
# Descriptions...: 稅簽應折未折資產簽核表 
# Date & Author..: 2009/02/13 By ve007 
#No.FUN-8C0075
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80054 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: NO:FUN-B80081 11/11/01 By Sakura faj105相關程式段Mark
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
# Modify.........: No.CHI-C80041 13/02/05 By bart 排除作廢
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD
       yy LIKE type_file.chr4,
       mm LIKE type_file.chr2,
       more LIKE type_file.chr1
       END RECORD,
       g_ym LIKE type_file.chr6
DEFINE g_sql    STRING         
DEFINE g_str    STRING        
DEFINE l_table  STRING       
 
MAIN
 
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
   #No.FUN-7C0082 --start--
   LET g_sql="faj02.faj_file.faj02,faj022.faj_file.faj022,",
             "faj105.faj_file.faj105,faj74.faj_file.faj74,",
             "faj741.faj_file.faj741,faj65.faj_file.faj65,",
             "ze03.ze_file.ze03"
   LET l_table = cl_prt_temptable('afar404',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-7C0082 --end--
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   LET g_pdate = ARG_VAL(1)        
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.yy = ARG_VAL(7)
   LET tm.mm = ARG_VAL(8)
   LET g_rpt_name = ARG_VAL(9)  
   LET g_ym = tm.yy,tm.mm
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80054--add-- #FUN-BB0047 mark
   IF cl_null(g_bgjob) OR g_bgjob = 'N'     
      THEN CALL afar404_tm()      
      ELSE CALL afar404()         
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80054--add--
END MAIN
   
FUNCTION afar404_tm()
   DEFINE lc_cmd LIKE type_file.chr1000,
          p_row,p_col LIKE type_file.num20_6
 
 
   OPEN WINDOW r404_w AT p_row,p_col WITH FORM "afa/42f/afar404"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
   CALL cl_ui_init()
 
   CLEAR FORM
 
   WHILE TRUE
      LET g_pdate = g_today
      LET g_rlang = g_lang
      LET g_bgjob = 'N'
      LET g_copies = '1'
      LET tm.more = "N"
      SELECT faa07,faa08 INTO tm.yy,tm.mm FROM faa_file WHERE faa00='0'
      LET tm.yy = tm.yy USING '&&&&'
      LET tm.mm = tm.mm USING '&&'
      DISPLAY tm.yy TO FORMONLY.yy
      DISPLAY tm.mm TO FORMONLY.mm
      LET g_ym = tm.yy,tm.mm
   
      INPUT BY NAME tm.yy,tm.mm,tm.more WITHOUT DEFAULTS 
   
         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" THEN
               NEXT FIELD FORMONLY.more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
            END IF
   
         ON ACTION CONTROLG
            CALL cl_cmdask()
   
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
    
         ON ACTION about         
            CALL cl_about()      
    
         ON ACTION help          
            CALL cl_show_help()  
    
         ON ACTION locale                          
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()
           EXIT INPUT
   
         ON ACTION qbe_save
            CALL cl_qbe_save()
   
         ON ACTION exit                          
            LET INT_FLAG = 1
            EXIT INPUT 
      END INPUT
   
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r404_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80054--add--
         EXIT PROGRAM
      END IF
   
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "afar404"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('afar404','9031',1)  
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'"
            CALL cl_cmdat('afar404',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW r404_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80054--add-- 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar404()
   END WHILE
   CLOSE WINDOW r404_w
END FUNCTION
 
FUNCTION afar404()
   DEFINE g_sql   STRING,
          l_name  LIKE type_file.chr20,
          g_faj   RECORD LIKE faj_file.*,
          g_cnt   LIKE type_file.num20_6,
          l_fbi02 LIKE fbi_file.fbi02
   DEFINE l_ze01  LIKE ze_file.ze01                     
   DEFINE l_ze03  LIKE ze_file.ze03                     
   DEFINE l_sql   LIKE type_file.chr1000                
 
   CALL cl_del_data(l_table)                           
   #No.FUN-B80054--mark--Begin---  
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   #No.FUN-B80054--mark--End-----
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #------------------ 資產主檔 SQL ----------------------------------
   # 判斷 資產狀態, 開始折舊年月, 確認碼, 折舊方法, 剩餘月數
   LET g_ym = tm.yy,tm.mm
   LET g_sql="SELECT faj_file.* FROM faj_file ",
             " WHERE faj43 NOT IN ('0','5','6','7','X') ",   
             " AND faj27 <= '",g_ym CLIPPED,"'",
             " AND fajconf='Y' " 
   IF g_aza.aza26 = '2' THEN                                                   
      LET g_sql = g_sql CLIPPED," AND faj61 IN ('1','2','3','4') "                 
   ELSE                                                                        
      LET g_sql = g_sql CLIPPED," AND faj61 IN ('1','2','3','4') "                  
   END IF                                                                      
   #已停用資產是否提列折舊                                                       
   IF g_faa.faa30 = 'N' THEN                                                   
      #LET g_sql = g_sql CLIPPED," AND (faj105 = 'N' OR faj105 IS NULL)" #No.FUN-B80081 mark
       LET g_sql = g_sql CLIPPED," AND faj43 <> 'Z' " #No.FUN-B80081 add   
   END IF                                                                      
   LET g_sql = g_sql CLIPPED," UNION ALL ", 
               "SELECT faj_file.* FROM faj_file ",   #折畢再提/續提
               " WHERE faj43 ='7' ",  
               " AND faj61 = '1' ",
               " AND fajconf='Y' " 
   #已停用資產是否提列折舊                                                       
   IF g_faa.faa30 = 'N' THEN                                                   
      #LET g_sql = g_sql CLIPPED," AND (faj105 = 'N' OR faj105 IS NULL)" #No.FUN-B80081 mark
       LET g_sql = g_sql CLIPPED," AND faj43 <> 'Z' " #No.FUN-B80081 add     
   END IF                                                                      
   LET g_sql = g_sql CLIPPED," ORDER BY 2,3,4 "  
 
   PREPARE r404_pre FROM g_sql
   IF STATUS THEN 
      CALL cl_err('r404_pre',STATUS,0) 
      RETURN 
   END IF
   DECLARE r404_cur CURSOR WITH HOLD FOR r404_pre
   FOREACH r404_cur INTO g_faj.*
      IF SQLCA.sqlcode THEN 
         CALL cl_err('r404_cur foreach:',STATUS,1) 
         EXIT FOREACH 
      END IF

      #FUN-B80081-----start-----
      IF g_faj.faj43 = "Z" THEN
        LET g_faj.faj105 = "Y"
      ELSE
        LET g_faj.faj105 = "N"
      END IF
      #FUN-B80081-----end-----
 
      #--折舊月份已提列折舊,則不再提列(訊息不列入清單中)
      LET g_cnt = 0 
      SELECT COUNT(*) INTO g_cnt FROM fao_file 
        WHERE fao01=g_faj.faj02 AND fao02=g_faj.faj022
          AND (fao03>tm.yy OR (fao03=tm.yy AND fao04>=tm.mm))
          AND fao05 <> '3' AND fao041='1'
      IF g_cnt > 0 THEN
         CONTINUE FOREACH
      END IF
      #--
 
      #--已全額提列減值準備的固定資產,不再提列折舊                              
      IF g_faj.faj68 - (g_faj.faj101 - g_faj.faj102) <= 0 THEN                 
         LET l_ze01 = 'afa-177'
         CALL cl_getmsg(l_ze01,g_lang) RETURNING l_ze03
         EXECUTE insert_prep USING g_faj.faj02,g_faj.faj022,g_faj.faj105,
                                   g_faj.faj74,g_faj.faj741,g_faj.faj65,l_ze03
         CONTINUE FOREACH                                                      
      END IF                                                                   
      #--
 
      #--檢核異動未過帳
      LET g_cnt=0
      SELECT COUNT(*) INTO g_cnt FROM fay_file,faz_file
        WHERE fay01=faz01 AND faz03=g_faj.faj02 AND faz031=g_faj.faj022
          AND faypost<>'Y' AND YEAR(fay02)=tm.yy AND MONTH(fay02)=tm.mm
          AND fayconf<>'X'
      IF g_cnt > 0 THEN                                             
         LET l_ze01 = 'afa-180'                                                 
         CALL cl_getmsg(l_ze01,g_lang) RETURNING l_ze03                         
         EXECUTE insert_prep USING g_faj.faj02,g_faj.faj022,g_faj.faj105,       
                                   g_faj.faj74,g_faj.faj741,g_faj.faj65,l_ze03  
         CONTINUE FOREACH                                                      
      END IF
 
      LET g_cnt=0
      SELECT COUNT(*) INTO g_cnt FROM fba_file,fbb_file
        WHERE fba01=fbb01 AND fbb03=g_faj.faj02 AND fbb031=g_faj.faj022
          AND fbapost<>'Y' AND YEAR(fba02)=tm.yy AND MONTH(fba02)=tm.mm
          AND fbaconf<>'X' 
      IF g_cnt > 0 THEN                                             
         LET l_ze01 = 'afa-181'                                                 
         CALL cl_getmsg(l_ze01,g_lang) RETURNING l_ze03                         
         EXECUTE insert_prep USING g_faj.faj02,g_faj.faj022,g_faj.faj105,       
                                   g_faj.faj74,g_faj.faj741,g_faj.faj65,l_ze03  
         CONTINUE FOREACH                                                      
      END IF
 
      LET g_cnt=0
      SELECT COUNT(*) INTO g_cnt FROM fbc_file,fbd_file
        WHERE fbc01=fbd01 AND fbd03=g_faj.faj02 AND fbd031=g_faj.faj022
          AND fbcpost<>'Y' AND YEAR(fbc02)=tm.yy AND MONTH(fbc02)=tm.mm
          AND fbcconf<>'X'
      IF g_cnt > 0 THEN                                             
         LET l_ze01 = 'afa-182'                                                 
         CALL cl_getmsg(l_ze01,g_lang) RETURNING l_ze03                         
         EXECUTE insert_prep USING g_faj.faj02,g_faj.faj022,g_faj.faj105,       
                                   g_faj.faj74,g_faj.faj741,g_faj.faj65,l_ze03  
         CONTINUE FOREACH                                                      
      END IF
 
      LET g_cnt=0
      SELECT COUNT(*) INTO g_cnt FROM fgh_file,fgi_file
        WHERE fgh01=fgi01 AND fgi06=g_faj.faj02 AND fgi07=g_faj.faj022
          AND fghconf<>'Y' AND YEAR(fgh02)=tm.yy AND MONTH(fgh02)=tm.mm
          AND fghconf<>'X'  #CHI-C80041
      IF g_cnt > 0 THEN                                             
         LET l_ze01 = 'afa-183'                                                 
         CALL cl_getmsg(l_ze01,g_lang) RETURNING l_ze03                         
         EXECUTE insert_prep USING g_faj.faj02,g_faj.faj022,g_faj.faj105,       
                                   g_faj.faj74,g_faj.faj741,g_faj.faj65,l_ze03  
         CONTINUE FOREACH                                                      
      END IF
      #--
 
      #--檢核當月處份應提列折舊='N',已存在處份資料,不可進行折舊 
      IF g_faa.faa23 = 'N' THEN
         LET g_cnt=0
         SELECT COUNT(*) INTO g_cnt FROM fbg_file,fbh_file
           WHERE fbg01=fbh01 AND fbh03=g_faj.faj02 AND fbh031=g_faj.faj022
             AND YEAR(fbg02)=tm.yy AND MONTH(fbg02)=tm.mm
             AND fbgconf<>'X'
         IF g_cnt > 0 THEN                                            
         LET l_ze01 = 'afa-184'                                                 
         CALL cl_getmsg(l_ze01,g_lang) RETURNING l_ze03                         
         EXECUTE insert_prep USING g_faj.faj02,g_faj.faj022,g_faj.faj105,       
                                   g_faj.faj74,g_faj.faj741,g_faj.faj65,l_ze03  
            CONTINUE FOREACH                                                      
         END IF
         
         LET g_cnt=0
         SELECT COUNT(*) INTO g_cnt FROM fbe_file,fbf_file
           WHERE fbe01=fbf01 AND fbf03=g_faj.faj02 AND fbf031=g_faj.faj022
             AND YEAR(fbe02)=tm.yy AND MONTH(fbe02)=tm.mm
             AND fbeconf<>'X'
         IF g_cnt > 0 THEN                                             
            LET l_ze01 = 'afa-185'                                                 
            CALL cl_getmsg(l_ze01,g_lang) RETURNING l_ze03                         
            EXECUTE insert_prep USING g_faj.faj02,g_faj.faj022,g_faj.faj105,       
                                      g_faj.faj74,g_faj.faj741,g_faj.faj65,l_ze03  
            CONTINUE FOREACH                                                      
         END IF
      END IF
 
      #--折舊提列時，再檢查/設定折舊科目
      IF g_faa.faa20 = '2' THEN  
         IF g_faj.faj23='1' THEN 
            DECLARE r404_fbi CURSOR FOR
            SELECT fbi02 FROM fbi_file WHERE fbi01=g_faj.faj24 AND fbi03= g_faj.faj04  
            FOREACH r404_fbi INTO l_fbi02
               IF SQLCA.sqlcode THEN
                  EXIT FOREACH
               END IF
               IF NOT cl_null(l_fbi02) THEN
                  EXIT FOREACH
               END IF
            END FOREACH
            IF cl_null(l_fbi02) THEN                                             
               LET l_ze01 = 'afa-317'                                                 
               CALL cl_getmsg(l_ze01,g_lang) RETURNING l_ze03                         
               EXECUTE insert_prep USING g_faj.faj02,g_faj.faj022,g_faj.faj105,       
                                         g_faj.faj74,g_faj.faj741,g_faj.faj65,l_ze03  
               CONTINUE FOREACH
            END IF
         END IF
      ELSE
         IF cl_null(g_faj.faj55) THEN                                           
            LET l_ze01 = 'afa-361'                                                 
            CALL cl_getmsg(l_ze01,g_lang) RETURNING l_ze03                         
            EXECUTE insert_prep USING g_faj.faj02,g_faj.faj022,g_faj.faj105,       
                                      g_faj.faj74,g_faj.faj741,g_faj.faj65,l_ze03  
            CONTINUE FOREACH
         END IF
      END IF                                             
       LET l_ze01 = 'afa-155'                                                 
       CALL cl_getmsg(l_ze01,g_lang) RETURNING l_ze03                         
       EXECUTE insert_prep USING g_faj.faj02,g_faj.faj022,g_faj.faj105,       
                                 g_faj.faj74,g_faj.faj741,g_faj.faj65,l_ze03  
   END FOREACH
   LET g_str=''
   LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   CALL cl_prt_cs3('afar404','afar404',l_sql,g_str)
   #No.FUN-BB0047--mark--Begin---
   #CALL cl_used(g_prog,g_time,2) RETURNING g_time 
   #No.FUN-BB0047--mark--End-----
END FUNCTION
#No.FUN-8C0075
