# Prog. Version..: '5.30.07-13.05.30(00003)'     #
#
# Pattern name...: afax304.4gl
# Descriptions...: 檢核該月份該折未折報表 
# Modify.........: No.TQC-780083 07/09/21 By Smapmin 
# Modify.........: No.FUN-7C0082 07/12/24 By zhoufeng 報表打印改為Crystal Report
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A30125 10/03/19 By sabrina faj43條件要多增加"4" 
# Modify.........: No:MOD-A80235 10/08/30 By Dido g_ym 應可依畫面調整而重新給值 
# Modify.........: No.FUN-B80054 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: NO:FUN-B80081 11/11/01 By Sakura faj105相關程式段Mark
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
# Modify.........: No.FUN-CA0132 12/11/05 By zhangweib CR轉XtraGrid
# Modify.........: No.CHI-C80041 13/02/05 By bart 排除作廢
# Modify.........: No.FUN-D40129 13/05/17 By yangtt 添加名稱欄位（faj06）
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD                     #No.FUN-CA0132
       yy LIKE type_file.chr4,
       mm LIKE type_file.chr2,
       more LIKE type_file.chr1
       END RECORD,
       g_ym LIKE type_file.chr6
DEFINE g_sql    STRING         #No.FUN-7C0082
DEFINE g_str    STRING         #No.FUN-7C0082
DEFINE l_table  STRING         #No.FUN-7C0082
 
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
             "faj105.faj_file.faj105,faj57.faj_file.faj57,",
             "faj571.faj_file.faj571,faj30.faj_file.faj30,",
             "ze03.ze_file.ze03,",
             "faj06.faj_file.faj06"   #FUN-D40129
   LET l_table = cl_prt_temptable('afax304',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?)"    #FUN-D40129  add 1?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-7C0082 --end--
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET g_pdate = ARG_VAL(1)        
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.yy = ARG_VAL(7)
   LET tm.mm = ARG_VAL(8)
   LET g_rpt_name = ARG_VAL(9)  #No.FUN-7C0078
   LET g_ym = tm.yy,tm.mm
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80054--add-- #FUN-BB0047 mark
   IF cl_null(g_bgjob) OR g_bgjob = 'N'     
      THEN CALL afax304_tm()      
      ELSE CALL afax304()         
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80054--add--
END MAIN
   
FUNCTION afax304_tm()
   DEFINE lc_cmd LIKE type_file.chr1000,
          p_row,p_col LIKE type_file.num20_6
 
 
   OPEN WINDOW x304_w AT p_row,p_col WITH FORM "afa/42f/afax304"
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
   
#      INPUT BY NAME tm.more WITHOUT DEFAULTS             #No.FUN-7C0082
      INPUT BY NAME tm.yy,tm.mm,tm.more WITHOUT DEFAULTS  #No.FUN-7C0082
   
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
         CLOSE WINDOW x304_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80054--add--
         EXIT PROGRAM
      END IF
   
      LET g_ym = tm.yy,tm.mm     #MOD-A80235
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "afax304"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('afax304','9031',1)  
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
            CALL cl_cmdat('afax304',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW x304_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80054--add--
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afax304()
   END WHILE
   CLOSE WINDOW x304_w
END FUNCTION
 
FUNCTION afax304()
   DEFINE g_sql   STRING,
          l_name  LIKE type_file.chr20,
          g_faj   RECORD LIKE faj_file.*,
          g_cnt   LIKE type_file.num20_6,
          l_fbi02 LIKE fbi_file.fbi02
   DEFINE l_ze01  LIKE ze_file.ze01                      #No.FUN-7C0082
   DEFINE l_ze03  LIKE ze_file.ze03                      #No.FUN-7C0082
   DEFINE l_sql   LIKE type_file.chr1000                 #No.FUN-7C0082
 
   CALL cl_del_data(l_table)                             #No.FUN-7C0082
   #No.FUN-B80054--mark--Begin---
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   #No.FUN-B80054--mark--End-----
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #------------------ 資產主檔 SQL ----------------------------------
   # 判斷 資產狀態, 開始折舊年月, 確認碼, 折舊方法, 剩餘月數
   LET g_sql="SELECT faj_file.* FROM faj_file ",
             " WHERE faj43 NOT IN ('0','4','5','6','7','X') ",   #MOD-A30125 add 4
             " AND faj27 <= '",g_ym CLIPPED,"'",
             " AND fajconf='Y' " 
   IF g_aza.aza26 = '2' THEN                                                   
      LET g_sql = g_sql CLIPPED," AND faj28 IN ('1','2','3','4')"                 
   ELSE                                                                        
      LET g_sql = g_sql CLIPPED," AND faj28 IN ('1','2','3')"                  
   END IF                                                                      
   #已停用資產是否提列折舊                                                       
   IF g_faa.faa30 = 'N' THEN                                                   
      #LET g_sql = g_sql CLIPPED," AND (faj105 = 'N' OR faj105 IS NULL)" #No.FUN-B80081 mark
       LET g_sql = g_sql CLIPPED," AND faj43 <> 'Z' " #No.FUN-B80081 add        
   END IF                                                                      
   LET g_sql = g_sql CLIPPED," UNION ALL ", 
               "SELECT faj_file.* FROM faj_file ",   #折畢再提/續提
               " WHERE faj43 IN ('7') ",  
               " AND faj28 = '1' ",
               " AND fajconf='Y' " 
   #已停用資產是否提列折舊                                                       
   IF g_faa.faa30 = 'N' THEN                                                   
      #LET g_sql = g_sql CLIPPED," AND (faj105 = 'N' OR faj105 IS NULL)" #No.FUN-B80081 mark
       LET g_sql = g_sql CLIPPED," AND faj43 <> 'Z' " #No.FUN-B80081 add      
   END IF                                                                      
   LET g_sql = g_sql CLIPPED," ORDER BY 2,3,4 "  
 
   PREPARE x304_pre FROM g_sql
   IF STATUS THEN 
      CALL cl_err('x304_pre',STATUS,0) 
      RETURN 
   END IF
   DECLARE x304_cur CURSOR WITH HOLD FOR x304_pre
#   CALL cl_outnam('afax304') RETURNING l_name          #No.FUN-7C0082
#   START REPORT afax304_rep TO l_name                  #No.FUN-7C0082
   FOREACH x304_cur INTO g_faj.*
      IF SQLCA.sqlcode THEN 
         CALL cl_err('x304_cur foreach:',STATUS,1) 
         EXIT FOREACH 
      END IF

      #FUN-B80081-----start------
      IF g_faj.faj43 = "Z" THEN
        LET g_faj.faj105 = "Y" 
      ELSE
        LET g_faj.faj105 = "N" 
      END IF
      #FUN-B80081-----end------
 
      #--折舊月份已提列折舊,則不再提列(訊息不列入清單中)
      LET g_cnt = 0 
      SELECT COUNT(*) INTO g_cnt FROM fan_file 
        WHERE fan01=g_faj.faj02 AND fan02=g_faj.faj022
          AND (fan03>tm.yy OR (fan03=tm.yy AND fan04>=tm.mm))
          AND fan05 <> '3' AND fan041='1'
      IF g_cnt > 0 THEN
         CONTINUE FOREACH
      END IF
      #--
 
      #--已全額提列減值準備的固定資產,不再提列折舊                              
      IF g_faj.faj33 - (g_faj.faj101 - g_faj.faj102) <= 0 THEN                 
#         OUTPUT TO REPORT afax304_rep(g_faj.*,'afa-177')      #No.FUN-7C0082
         #No.FUN-7C0082 --start--
         LET l_ze01 = 'afa-177'
         CALL cl_getmsg(l_ze01,g_lang) RETURNING l_ze03
         EXECUTE insert_prep USING g_faj.faj02,g_faj.faj022,g_faj.faj105,
                                   g_faj.faj57,g_faj.faj571,g_faj.faj30,l_ze03,
                                   g_faj.faj06    #FUN-D40129
         #No.FUN-7C0082 --end--
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
#         OUTPUT TO REPORT afax304_rep(g_faj.*,'afa-180')      #No.FUN-7C0082
         #No.FUN-7C0082 --start--                                               
         LET l_ze01 = 'afa-180'                                                 
         CALL cl_getmsg(l_ze01,g_lang) RETURNING l_ze03                         
         EXECUTE insert_prep USING g_faj.faj02,g_faj.faj022,g_faj.faj105,       
                                   g_faj.faj57,g_faj.faj571,g_faj.faj30,l_ze03  
                                   ,g_faj.faj06   #FUN-D40129
         #No.FUN-7C0082 --end-- 
         CONTINUE FOREACH                                                      
      END IF
 
      LET g_cnt=0
      SELECT COUNT(*) INTO g_cnt FROM fba_file,fbb_file
        WHERE fba01=fbb01 AND fbb03=g_faj.faj02 AND fbb031=g_faj.faj022
          AND fbapost<>'Y' AND YEAR(fba02)=tm.yy AND MONTH(fba02)=tm.mm
          AND fbaconf<>'X' 
      IF g_cnt > 0 THEN
#         OUTPUT TO REPORT afax304_rep(g_faj.*,'afa-181')      #No.FUN-7C0082
         #No.FUN-7C0082 --start--                                               
         LET l_ze01 = 'afa-181'                                                 
         CALL cl_getmsg(l_ze01,g_lang) RETURNING l_ze03                         
         EXECUTE insert_prep USING g_faj.faj02,g_faj.faj022,g_faj.faj105,       
                                   g_faj.faj57,g_faj.faj571,g_faj.faj30,l_ze03  
                                   ,g_faj.faj06   #FUN-D40129
         #No.FUN-7C0082 --end-- 
         CONTINUE FOREACH                                                      
      END IF
 
      LET g_cnt=0
      SELECT COUNT(*) INTO g_cnt FROM fbc_file,fbd_file
        WHERE fbc01=fbd01 AND fbd03=g_faj.faj02 AND fbd031=g_faj.faj022
          AND fbcpost<>'Y' AND YEAR(fbc02)=tm.yy AND MONTH(fbc02)=tm.mm
          AND fbcconf<>'X'
      IF g_cnt > 0 THEN
#         OUTPUT TO REPORT afax304_rep(g_faj.*,'afa-182')      #No.FUN-7C0082
         #No.FUN-7C0082 --start--                                               
         LET l_ze01 = 'afa-182'                                                 
         CALL cl_getmsg(l_ze01,g_lang) RETURNING l_ze03                         
         EXECUTE insert_prep USING g_faj.faj02,g_faj.faj022,g_faj.faj105,       
                                   g_faj.faj57,g_faj.faj571,g_faj.faj30,l_ze03  
                                   ,g_faj.faj06   #FUN-D40129
         #No.FUN-7C0082 --end-- 
         CONTINUE FOREACH                                                      
      END IF
 
      LET g_cnt=0
      SELECT COUNT(*) INTO g_cnt FROM fgh_file,fgi_file
        WHERE fgh01=fgi01 AND fgi06=g_faj.faj02 AND fgi07=g_faj.faj022
          AND fghconf<>'Y' AND YEAR(fgh02)=tm.yy AND MONTH(fgh02)=tm.mm
          AND fghconf<>'X'  #CHI-C80041
      IF g_cnt > 0 THEN
#         OUTPUT TO REPORT afax304_rep(g_faj.*,'afa-183')      #No.FUN-7C0082
         #No.FUN-7C0082 --start--                                               
         LET l_ze01 = 'afa-183'                                                 
         CALL cl_getmsg(l_ze01,g_lang) RETURNING l_ze03                         
         EXECUTE insert_prep USING g_faj.faj02,g_faj.faj022,g_faj.faj105,       
                                   g_faj.faj57,g_faj.faj571,g_faj.faj30,l_ze03  
                                   ,g_faj.faj06   #FUN-D40129
         #No.FUN-7C0082 --end-- 
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
#            OUTPUT TO REPORT afax304_rep(g_faj.*,'afa-184')   #No.FUN-7C0082
            #No.FUN-7C0082 --start--                                               
         LET l_ze01 = 'afa-184'                                                 
         CALL cl_getmsg(l_ze01,g_lang) RETURNING l_ze03                         
         EXECUTE insert_prep USING g_faj.faj02,g_faj.faj022,g_faj.faj105,       
                                   g_faj.faj57,g_faj.faj571,g_faj.faj30,l_ze03  
                                   ,g_faj.faj06   #FUN-D40129
         #No.FUN-7C0082 --end-- 
            CONTINUE FOREACH                                                      
         END IF
         
         LET g_cnt=0
         SELECT COUNT(*) INTO g_cnt FROM fbe_file,fbf_file
           WHERE fbe01=fbf01 AND fbf03=g_faj.faj02 AND fbf031=g_faj.faj022
             AND YEAR(fbe02)=tm.yy AND MONTH(fbe02)=tm.mm
             AND fbeconf<>'X'
         IF g_cnt > 0 THEN
#            OUTPUT TO REPORT afax304_rep(g_faj.*,'afa-185')   #No.FUN-7C0082
            #No.FUN-7C0082 --start--                                               
            LET l_ze01 = 'afa-185'                                                 
            CALL cl_getmsg(l_ze01,g_lang) RETURNING l_ze03                         
            EXECUTE insert_prep USING g_faj.faj02,g_faj.faj022,g_faj.faj105,       
                                      g_faj.faj57,g_faj.faj571,g_faj.faj30,l_ze03  
                                      ,g_faj.faj06   #FUN-D40129
         #No.FUN-7C0082 --end-- 
            CONTINUE FOREACH                                                      
         END IF
      END IF
 
      #--折舊提列時，再檢查/設定折舊科目
      IF g_faa.faa20 = '2' THEN  
         IF g_faj.faj23='1' THEN 
            DECLARE x304_fbi CURSOR FOR
            SELECT fbi02 FROM fbi_file WHERE fbi01=g_faj.faj24 AND fbi03= g_faj.faj04  
            FOREACH x304_fbi INTO l_fbi02
               IF SQLCA.sqlcode THEN
                  EXIT FOREACH
               END IF
               IF NOT cl_null(l_fbi02) THEN
                  EXIT FOREACH
               END IF
            END FOREACH
            IF cl_null(l_fbi02) THEN
#               OUTPUT TO REPORT afax304_rep(g_faj.*,'afa-317')  #No.FUN-7C0082
               #No.FUN-7C0082 --start--                                               
               LET l_ze01 = 'afa-317'                                                 
               CALL cl_getmsg(l_ze01,g_lang) RETURNING l_ze03                         
               EXECUTE insert_prep USING g_faj.faj02,g_faj.faj022,g_faj.faj105,       
                                         g_faj.faj57,g_faj.faj571,g_faj.faj30,l_ze03  
                                         ,g_faj.faj06   #FUN-D40129
               #No.FUN-7C0082 --end-- 
               CONTINUE FOREACH
            END IF
         END IF
      ELSE
         IF cl_null(g_faj.faj55) THEN
#            OUTPUT TO REPORT afax304_rep(g_faj.*,'afa-361')     #No.FUN-7C0082
            #No.FUN-7C0082 --start--                                               
            LET l_ze01 = 'afa-361'                                                 
            CALL cl_getmsg(l_ze01,g_lang) RETURNING l_ze03                         
            EXECUTE insert_prep USING g_faj.faj02,g_faj.faj022,g_faj.faj105,       
                                      g_faj.faj57,g_faj.faj571,g_faj.faj30,l_ze03  
                                      ,g_faj.faj06   #FUN-D40129
            #No.FUN-7C0082 --end-- 
            CONTINUE FOREACH
         END IF
      END IF
#      OUTPUT TO REPORT afax304_rep(g_faj.*,'afa-155')           #No.FUN-7C0082
       #No.FUN-7C0082 --start--                                               
       LET l_ze01 = 'afa-155'                                                 
       CALL cl_getmsg(l_ze01,g_lang) RETURNING l_ze03                         
       EXECUTE insert_prep USING g_faj.faj02,g_faj.faj022,g_faj.faj105,       
                                 g_faj.faj57,g_faj.faj571,g_faj.faj30,l_ze03  
                                 ,g_faj.faj06   #FUN-D40129
       #No.FUN-7C0082 --end-- 
   END FOREACH
#   FINISH REPORT afax304_rep                                    #No.FUN-7C0082
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)                  #No.FUN-7C0082
   #No.FUN-7C0082 --start--
###XtraGrid###   LET g_str=''
###XtraGrid###   LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
###XtraGrid###   CALL cl_prt_cs3('afax304','afax304',l_sql,g_str)
    LET g_xgrid.table = l_table    ###XtraGrid###
    CALL cl_xg_view()    ###XtraGrid###
   #No.FUN-7C0082 --end--
   #No.FUN-BB0047--mark--Begin---
   #CALL cl_used(g_prog,g_time,2) RETURNING g_time 
   #No.FUN-BB0047--mark--End-----
END FUNCTION
#No.FUN-7C0082 --start-- mark
#REPORT afax304_rep(sr,l_ze01)
#  DEFINE sr RECORD LIKE faj_file.*,
#         l_ze01 LIKE ze_file.ze01,
#         l_ze03 LIKE ze_file.ze03,
#         l_trailer_sw    LIKE type_file.chr1
#  
#  OUTPUT TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#  FORMAT 
#   PAGE HEADER
#       PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#       PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1 ,g_x[1] CLIPPED 
#       LET g_pageno=g_pageno+1
#       LET pageno_total=PAGENO USING '<<<',"/pageno"
#       PRINT g_head CLIPPED,pageno_total
#       PRINT g_dash[1,g_len]
#       PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#             g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED
#       PRINT g_dash1
#       LET l_trailer_sw = 'y' 
 
#   ON EVERY ROW
#       CALL cl_getmsg(l_ze01,g_lang) RETURNING l_ze03
#       PRINT COLUMN g_c[31],sr.faj02,
#             COLUMN g_c[32],sr.faj022,
#             COLUMN g_c[33],sr.faj105,
#             COLUMN g_c[34],sr.faj57,
#             COLUMN g_c[35],sr.faj571,
#             COLUMN g_c[36],sr.faj30,
#             COLUMN g_c[37],l_ze03
#       
#   ON LAST ROW
#       PRINT g_dash[1,g_len]
#       PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#       LET l_trailer_sw = 'n' 
 
#   PAGE TRAILER
#       IF l_trailer_sw = 'y' THEN
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED 
#       ELSE
#           SKIP 2 LINE
#       END IF
#END REPORT 
#No.FUN-7C0082 --end--
#TQC-780083


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
