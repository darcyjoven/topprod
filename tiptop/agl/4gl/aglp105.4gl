# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglp105.4gl
# Descriptions...: 總號重新排列作業                   
# Input parameter: 
# Return code....: 
# Date & Author..: 92/03/27 BY DAVID WANG
# Modify.........: No.FUN-550028 05/05/16 By Will 單據編號放大
# Modify ........: No.FUN-570145 06/02/27 By Yiting 批次背景執行
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: No.FUN-680098 06/08/29 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-710023 07/01/18 By yjkhero 錯誤訊息匯整
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740020 07/04/13 By Carrier 會計科目加帳套 - 財務
# Modify.........: No.MOD-860159 08/06/26 By Sarah aglp105_p()段,l_str長度改成chr10
# Modify.........: No.FUN-8A0086 08/10/23 By zhaijie完善錯誤匯總
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A70007 10/07/13 By Summer 多帳期改用s_azmm,並依據畫面上的帳別傳遞使用
# Modify.........: No.CHI-C80041 12/12/24 By bart 排除作廢
# Modify.........: No:CHI-D10029 13/01/18 By apo 在輸入帳別後,以該帳別帶出現行年度期別 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
      tm        RECORD
               bookno LIKE aaa_file.aaa01,  #No.FUN-740020
               aaa04  LIKE aaa_file.aaa04,
               aaa05  LIKE aaa_file.aaa05,
               y1     LIKE aaa_file.aaa04,
               m2     LIKE aaa_file.aaa05,
#			   trn    VARCHAR(3),
                           trn    LIKE type_file.chr5,     #No.FUN-550028 #No.FUN-680098 VARCHAR(5)
			   tno    LIKE type_file.num10     #No.FUN-680098  INTEGER
               END RECORD,
     start_no,end_no   LIKE type_file.num10,        #No.FUN-680098   INTEGER
     g_aaa04   LIKE type_file.num5,                 #現行會計年度   #No.FUN-680098  SMALLINT
     g_aaa05   LIKE type_file.num5,       #現行期別       #No.FUN-680098   SMALLINT
     b_date    LIKE type_file.dat,        #期間起始日期   #No.FUN-680098 DATE
     e_date    LIKE type_file.dat,   	  #期間起始日期   #No.FUN-680098 DATE
     g_bookno   LIKE aea_file.aea00,      #帳別
     bno   	LIKE type_file.chr6,      #起始傳票編號   #No.FUN-680098  VARCHAR(6)
     eno   	LIKE type_file.chr6       #截止傳票編號   #No.FUN-680098  VARCHAR(6) 
DEFINE ls_date         STRING,                      #No.FUN-570145
       l_flag          LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1) 
       g_change_lang   LIKE type_file.chr1           #No.FUN-680098 VARCHAR(1)  
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0073
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    LET tm.bookno = ARG_VAL(1)  #No.FUN-740020
  #-->No.FUN-570145 --start
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.aaa04  = ARG_VAL(2)
   LET tm.aaa05  = ARG_VAL(3)
   LET tm.y1     = ARG_VAL(4)
   LET tm.m2     = ARG_VAL(5)
   LET tm.trn    = ARG_VAL(6)
   LET tm.tno    = ARG_VAL(7)
   LET g_bgjob   = ARG_VAL(8)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = 'N'
   END IF
  #--- No.FUN-570145 --end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
 
    #No.FUN-740020  --Begin
    IF tm.bookno IS NULL OR tm.bookno = ' ' THEN
#      SELECT aaz64 INTO g_bookno FROM aaz_file
       LET tm.bookno = g_aza.aza81
    END IF
    #No.FUN-740020  --End  
  #--- No.FUN-570145 --start---
   #CALL aglp105_tm(0,0)
   WHILE TRUE
     LET g_change_lang = FALSE
     IF g_bgjob = 'N' THEN
        CALL aglp105_tm(0,0)
        IF cl_sure(21,21) THEN
           CALL cl_wait()
           LET g_success = "Y"
           BEGIN WORK
           #CALL s_azm(tm.y1,tm.m2) RETURNING  l_flag,b_date,e_date #CHI-A70007 mark
           #CHI-A70007 add --start--
           IF g_aza.aza63 = 'Y' THEN
              CALL s_azmm(tm.y1,tm.m2,g_plant,tm.bookno) RETURNING l_flag,b_date,e_date
           ELSE
              CALL s_azm(tm.y1,tm.m2) RETURNING l_flag,b_date,e_date
           END IF
           #CHI-A70007 add --end--
           CALL aglp105_p(b_date,e_date)    #處理
           CALL s_showmsg()                 #NO.FUN-710023    
           #MESSAGE "From:",start_no," To:",end_no
           #CALL ui.Interface.refresh()
           IF g_success = 'Y' THEN
              COMMIT WORK
              CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
           ELSE
              ROLLBACK WORK
              CALL cl_end2(2) RETURNING l_flag
           END IF
           IF l_flag THEN
              CONTINUE WHILE
           ELSE
              CLOSE WINDOW aglp105_w
              EXIT WHILE
           END IF
        ELSE
           CONTINUE WHILE
        END IF
        CLOSE WINDOW aglp105_w
     ELSE
        LET g_success = 'Y'
        BEGIN WORK
        #CALL s_azm(tm.y1,tm.m2) RETURNING  l_flag,b_date,e_date #CHI-A70007 mark
        #CHI-A70007 add --start--
        IF g_aza.aza63 = 'Y' THEN
           CALL s_azmm(tm.y1,tm.m2,g_plant,tm.bookno) RETURNING l_flag,b_date,e_date
        ELSE
           CALL s_azm(tm.y1,tm.m2) RETURNING l_flag,b_date,e_date
        END IF
        #CHI-A70007 add --end--
        CALL aglp105_p(b_date,e_date)    #處理
        CALL s_showmsg()                 #NO.FUN-710023 
        IF g_success = 'Y' THEN
           COMMIT WORK
        ELSE
           ROLLBACK WORK
        END IF
        CALL cl_batch_bg_javamail(g_success)
        EXIT WHILE
     END IF
   END WHILE
#FUN-570145 end------
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION aglp105_tm(p_row,p_col)
   DEFINE  p_row,p_col    LIKE type_file.num5,     #No.FUN-680098 SMALLINT
        	l_str     LIKE ze_file.ze03        #No.FUN-680098 VARCHAR(30)  
#            l_flag         LIKE type_file.chr1     #no.fun-570145 mark        #No.FUN-680098 VARCHAR(1) 
   DEFINE  lc_cmd      LIKE type_file.chr1000     #FUN-570145    #No.FUN-680098 VARCHAR(500)  
   CALL s_dsmark(tm.bookno)  #No.FUN-740020
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW aglp105_w AT p_row,p_col WITH FORM "agl/42f/aglp105" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
 
   CALL s_shwact(3,2,tm.bookno)  #No.FUN-740020
   CALL cl_getmsg('agl-050',g_lang) RETURNING l_str 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      #MESSAGE l_str
      #CALL ui.Interface.refresh()
   ELSE 
      DISPLAY l_str AT 2,1
   END IF
   INITIALIZE tm.* TO NULL			# Defaealt condition
   LET tm.bookno = g_aza.aza81  #No.FUN-740020
      SELECT aaa04,aaa05 INTO tm.aaa04,tm.aaa05 FROM aaa_file
             WHERE aaa01 = tm.bookno  #No.FUN-740020
   WHILE TRUE 
	  IF s_aglshut(0) THEN RETURN END  IF
      CLEAR FORM 
	  IF tm.y1 IS NULL OR tm.y1 = ' ' THEN
         LET tm.y1 = tm.aaa04
         LET tm.m2 = tm.aaa05
      END IF
     LET g_bgjob = 'N'                                   #FUN-570145
     DISPLAY BY NAME tm.aaa04,tm.aaa05,tm.y1,tm.m2,
                         tm.trn,tm.tno,g_bgjob           #FUN-570145
     DISPLAY BY NAME tm.bookno  #No.FUN-740020
     INPUT BY NAME tm.bookno,tm.y1,tm.m2,tm.trn,tm.tno,g_bgjob     #FUN-570145  #No.FUN-740020
              WITHOUT DEFAULTS
 
#NO.FUN-570145 MARK---
#       ON ACTION locale
#           CALL cl_dynamic_locale()
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#NO.FUN-570145 MARK---
      #No.FUN-740020  --Begin
      AFTER FIELD bookno
         IF NOT cl_null(tm.bookno) THEN
            CALL p105_bookno(tm.bookno)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(tm.bookno,g_errno,0)
               LET tm.bookno = g_aza.aza81
               DISPLAY BY NAME tm.bookno
               NEXT FIELD bookno
            END IF
          #CHI-D10029--str
            SELECT aaa04,aaa05 INTO tm.aaa04,tm.aaa05 FROM aaa_file WHERE aaa01 = tm.bookno
            DISPLAY BY NAME tm.aaa04,tm.aaa05
           #CHI-D10029--end
         END IF
      #No.FUN-740020  --End  
 
      AFTER FIELD y1
         IF tm.y1  IS NULL OR tm.y1 = ' ' THEN
            NEXT FIELD y1
         END IF
         IF tm.y1 > tm.aaa04 THEN
            CALL cl_err(tm.y1,'agl-030',0)
            NEXT FIELD y1
         END IF
 
      AFTER FIELD m2 
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.m2) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.y1
            IF g_azm.azm02 = 1 THEN
               IF tm.m2 > 12 OR tm.m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            ELSE
               IF tm.m2 > 13 OR tm.m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
         IF tm.m2 IS NULL OR tm.m2 = ' ' THEN
             NEXT FIELD m2
         ELSE
             IF tm.y1 = tm.aaa04 AND tm.m2 > tm.aaa05 THEN 
                CALL cl_err(tm.m2,'agl-023',0)
                NEXT FIELD m2
             END IF
         END IF
    
      AFTER FIELD tno
         IF tm.tno IS NULL OR tm.tno= ' ' THEN
            NEXT FIELD tno
         END IF
 
       ON ACTION controlp                  
           CASE
              WHEN INFIELD(trn) 
                 #CALL q_aac(FALSE,TRUE,tm.trn,'2','',g_user,g_sys) #TQC-670008 remark
                 CALL q_aac(FALSE,TRUE,tm.trn,'2','',g_user,'AGL')  #TQC-670008 
                 RETURNING tm.trn         
                 DISPLAY  BY NAME tm.trn         
                 NEXT FIELD trn   
              #No.FUN-740020  --Begin
              WHEN INFIELD(bookno) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aaa"
                 LET g_qryparam.default1 = tm.bookno
                 CALL cl_create_qry() RETURNING tm.bookno
                 DISPLAY BY NAME tm.bookno
                 NEXT FIELD bookno
              #No.FUN-740020  --End  
           END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
        CALL cl_cmdask()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
   
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   #-->No.FUN-570145 --start--
    ON ACTION locale
       CALL cl_show_fld_cont()
       LET g_change_lang = TRUE
       EXIT INPUT
   #---No.FUN-570145 --end--
 
 
   END INPUT
     #-->No.FUN-570145 --start--
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CONTINUE WHILE
      END IF
 
      #IF INT_FLAG THEN LET INT_FLAG = 0 EXIT PROGRAM  END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW aglp105_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
 
#   IF cl_sure(21,21) THEN
#      CALL cl_wait()
#      CALL s_azm(tm.y1,tm.m2) RETURNING  l_flag,b_date,e_date
#      CALL aglp105_p(b_date,e_date)    #處理
#      MESSAGE "From:",start_no," To:",end_no
#      CALL ui.Interface.refresh()
#      CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#      IF l_flag THEN
#         CONTINUE WHILE
#      ELSE
#         EXIT WHILE
#      END IF
#   END IF
   ERROR ""
      IF g_bgjob = "Y" THEN
         LET lc_cmd = NULL
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "aglp105"
        IF SQLCA.sqlcode OR cl_null(lc_cmd) THEN
           CALL cl_err('aglp105','9031',1)   
        ELSE
           LET lc_cmd = lc_cmd CLIPPED,
                        " ''",
                        " '",tm.aaa04 CLIPPED,"'",
                        " '",tm.aaa05 CLIPPED,"'",
                        " '",tm.y1 CLIPPED,"'",
                        " '",tm.m2 CLIPPED,"'",
                        " '",tm.trn CLIPPED,"'",
                        " '",tm.tno CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'"
           CALL cl_cmdat('aglp105',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW aglp105_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        EXIT PROGRAM
      END IF
      EXIT WHILE
      #-- No.FUN-570145 --end---
 
   END WHILE
#   CLOSE WINDOW aglp105_w
END FUNCTION
 
#No.FUN-740020  --Begin
FUNCTION p105_bookno(p_bookno)
  DEFINE p_bookno   LIKE aaa_file.aaa01,
         l_aaaacti  LIKE aaa_file.aaaacti
 
    LET g_errno = ' '
    SELECT aaaacti INTO l_aaaacti FROM aaa_file WHERE aaa01=p_bookno
    CASE
        WHEN l_aaaacti = 'N' LET g_errno = '9028'
        WHEN STATUS=100      LET g_errno = 'anm-062' #No.7926
        OTHERWISE LET g_errno = SQLCA.sqlcode USING'-------'
	END CASE
END FUNCTION
#No.FUN-740020  --End  
 
FUNCTION aglp105_p(b_date,e_date)
#     DEFINE   l_time LIKE type_file.chr8       #No.FUN-6A0073
      DEFINE
          l_str    LIKE type_file.chr10,    #No.FUN-680098  VARCHAR(4)  #MOD-860159 mod chr4->chr10
          l_str1   LIKE ze_file.ze03,       #No.FUN-680098  VARCHAR(30)   
          l_sql    LIKE type_file.chr1000,  #No.FUN-680098  VARCHAR(400) 
          l_aba01   LIKE aba_file.aba01,
          l_aba02   LIKE aba_file.aba02,
          b_date,e_date  LIKE type_file.dat        #No.FUN-680098 DATE
 
     # show message on screen
     OPEN WINDOW aglp105_g_w AT 18,26 WITH 5 rows, 30 COLUMNS 
     CALL cl_getmsg('agl-066',g_lang) RETURNING l_str1
     LET start_no=tm.tno
    
    IF g_bgjob = 'N' THEN           #FUN-570145
        DISPLAY l_str1 AT 1,1
        DISPLAY '---- ---- -------------------' AT 2,1
    END IF
    
     IF tm.trn IS NULL THEN
	LET l_str = "%"
     ELSE
	LET l_str = tm.trn,"%"
     END IF
     LET l_sql = "SELECT aba01,aba02 FROM aba_file ",
                 " WHERE aba02 BETWEEN '",b_date,"' AND '", e_date,"'",
                 " AND aba01 LIKE '",l_str,"'",
                 " AND aba00 = '",tm.bookno,"'",  #No.FUN-740020
              #  " AND aba01 NOT MATCHES '",g_aaz.aaz65,"'",
                 " AND aba01 NOT LIKE '",g_aaz.aaz65,"*'",  #NO:2769
                 " AND aba19 <> 'X' ",  #CHI-C80041
                 " ORDER BY aba02,aba01"
 
 
    PREPARE p501_precs   FROM l_sql
    DECLARE p501_cs SCROLL CURSOR WITH HOLD FOR p501_precs 
    CALL s_showmsg_init()                  #NO.FUN-710023 
    FOREACH p501_cs INTO l_aba01,l_aba02
#NO.FUN-710023--BEGIN                                                           
       IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y' 
       END IF                                                     
#NO.FUN-710023--END
        IF SQLCA.sqlcode THEN 
#          CALL cl_err('p501_cs',SQLCA.sqlcode,0)     #NO.FUN-710023
           CALL s_errmsg(' ',' ','p501_cs',SQLCA.sqlcode,0) #NO.FUN-710023
           LET g_success='N'                          #FUN-8A0086 
           EXIT FOREACH                              
        END IF
        IF g_bgjob = 'N' THEN           #FUN-570145
            DISPLAY tm.y1,'  ',tm.m2,'    ',l_aba01 AT 3,1
        END IF
        UPDATE  aba_file SET aba11 = tm.tno WHERE aba01 = l_aba01 AND aba02 = l_aba02  
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#         CALL cl_err(l_aba01,SQLCA.sqlcode,0)   #No.FUN-660123
#         CALL cl_err3("upd","aba_file",l_aba01,l_aba02,SQLCA.sqlcode,"","",0)  #No.FUN-660123 #NO.FUN-710023
          CALL s_errmsg('aba02',l_aba02,l_aba01,SQLCA.sqlcode,0) #NO.FUN-710023
#         EXIT FOREACH                                                          #NO.FUN-710023   
          CONTINUE FOREACH                                                      #NO.FUN-710023  
        END IF
        LET tm.tno = tm.tno + 1
     END FOREACH
#NO.FUN-710023--BEGIN                                                           
    IF g_totsuccess="N" THEN                                                        
     LET g_success="N"                                                           
    END IF                                                                          
#NO.FUN-710023--END
     LET end_no=tm.tno-1
     IF g_bgjob = 'N' THEN         #FUN-570145
         CLOSE WINDOW aglp105_g_w
     END IF
END FUNCTION
