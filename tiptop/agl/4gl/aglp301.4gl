# Prog. Version..: '5.30.06-13.04.01(00008)'     #
#
# Pattern name...: aglp301.4gl
# Descriptions...: 關帳作業 
# Input parameter: 
# Return code....: 
# Date & Author..: 92/04/06 BY MAY
# Modify.........: 97/04/16 By Melody aaa07 改為關帳日期             
# Modify ........: No.FUN-570145 06/02/27 By yiting 批次背景執行
# Modify.........: No.FUN-680098 06/08/29 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-740065 07/04/13 By Carrier 會計科目加帳套 - 財務
# Modify.........: No.MOD-760057 07/06/13 By Smapmin 現行年度期別沒有顯示出來
# Modify.........: No.MOD-930185 09/03/19 By Sarah 輸入帳別後，應重新依帳別抓取aaa_file帳別參數檔
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No:FUN-D20046 13/03/21 By Lori 檢查關帳日是否小於合併報表關帳日 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
      tm        RECORD
               bookno LIKE aaa_file.aaa01,   #No.FUN-740065
               aaa04  LIKE aaa_file.aaa04,
               aaa05  LIKE aaa_file.aaa05,
               aaa07  LIKE aaa_file.aaa07 
               END RECORD,
     g_aaa04   LIKE aaa_file.aaa04,     #現行會計年度        #No.FUN-680098     smallint
     g_aaa05   LIKE aaa_file.aaa05,    	#現行期別            #No.FUN-680098     smallint
     g_aaa07   LIKE type_file.dat,      #現行關帳年度        #No.FUN-680098     date
     b_date    LIKE type_file.dat,      #期間起始日期        #No.FUN-680098     date
     e_date    LIKE type_file.dat,      #期間起始日期        #No.FUN-680098     date
     g_bookno   LIKE aea_file.aea00,    #帳別
     bno   	LIKE type_file.chr6,    #起始傳票編號         #No.FUN-680098 VARCHAR(6)    
     eno   	LIKE type_file.chr6     #截止傳票編號         #No.FUN-680098 VARCHAR(6)     
DEFINE ls_date         STRING,                  #No.FUN-570145
      l_flag           LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)
      g_change_lang    LIKE type_file.chr1           #No.FUN-680098  VARCHAR(1)     
DEFINE g_aaz642        LIKE aaz_file.aaz642          #FUN-D20046 add
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0073
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    LET tm.bookno = ARG_VAL(1)  #No.FUN-740065
#->No.FUN-570145 --start--
  INITIALIZE g_bgjob_msgfile TO NULL
  LET tm.bookno = ARG_VAL(1)    #No.FUN-740065
  LET tm.aaa07 = ARG_VAL(2)
  LET g_bgjob  = ARG_VAL(3)
  IF cl_null(g_bgjob) THEN LET g_bgjob= "N" END IF
#->No.FUN-570145 end--
 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
 
#    LET g_bookno = ARG_VAL(1)
    #No.FUN-740065  --Begin
    IF tm.bookno IS NULL OR tm.bookno = ' ' THEN
#      SELECT aaz64 INTO g_bookno FROM aaz_file
       LET tm.bookno = g_aza.aza81
    END IF
    #No.FUN-740065  --End  
 
  WHILE TRUE
     LET g_change_lang = FALSE
     IF g_bgjob = 'N' THEN
        CALL aglp301_tm(0,0)
        IF cl_sure(21,21) THEN
           CALL cl_wait()
           LET g_success = 'Y'
           BEGIN WORK
           UPDATE aaa_file SET aaa07 = tm.aaa07
            WHERE aaa01 = tm.bookno  #No.FUN-740065
           IF STATUS THEN LET g_success = 'N' END IF
           IF g_success='Y' THEN
              COMMIT WORK
              CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
           ELSE
              ROLLBACK WORK
              CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
           END IF
           IF l_flag THEN
              CONTINUE WHILE
           ELSE
              CLOSE WINDOW aglp301_w
              EXIT WHILE
           END IF
        END IF
     ELSE
        LET g_success = 'Y'
        BEGIN WORK
        UPDATE aaa_file SET aaa07 = tm.aaa07
         WHERE aaa01 = tm.bookno  #No.FUN-740065
        IF STATUS THEN LET g_success = 'N' END IF
 
        IF g_success = 'Y' THEN
           COMMIT WORK
        ELSE
           ROLLBACK WORK
        END IF
        CALL cl_batch_bg_javamail(g_success)
        EXIT WHILE
     END  IF
  END WHILE
#->No.FUN-570145 ---end---
 #   CALL aglp301_tm(0,0)
 CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION aglp301_tm(p_row,p_col)
   DEFINE  p_row,p_col     LIKE type_file.num5,        #No.FUN-680098   smallint
	    l_str          LIKE ze_file.ze03,          #No.FUN-680098   VARCHAR(30)    
            l_flag         LIKE type_file.chr1         #No.FUN-680098   VARCHAR(1) 
   DEFINE  lc_cmd          LIKE type_file.chr1000      #FUN-57014       #No.FUN-680098   VARCHAR(500)    
 
   CALL s_dsmark(tm.bookno)  #No.FUN-740065
 
   LET p_row = 4 LET p_col = 26
 
   OPEN WINDOW aglp301_w AT p_row,p_col WITH FORM "agl/42f/aglp301" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
   CALL  s_shwact(0,0,tm.bookno)  #No.FUN-740065
#  CALL cl_opmsg('q')
  #CALL cl_getmsg('agl-070',g_lang) RETURNING l_str
 ##DISPLAY l_str AT 2,1                          #CHI-A70049 mark
      INITIALIZE tm.* TO NULL			# Defaealt condition
      LET tm.bookno = g_aza.aza81                #No.FUN-740065
      DISPLAY BY NAME tm.bookno                  #No.FUN-740065
      SELECT aaa04,aaa05,aaa07 INTO g_aaa04,g_aaa05,g_aaa07
          FROM aaa_file WHERE aaa01 = tm.bookno  #No.FUN-740065
      LET tm.aaa04 = g_aaa04
      LET tm.aaa05 = g_aaa05
      LET tm.aaa07 = g_aaa07
   WHILE TRUE 
	  IF s_aglshut(0) THEN RETURN END IF
      CLEAR FORM 
     DISPLAY BY NAME tm.aaa04,tm.aaa05,tm.aaa07    #MOD-760057
     LET g_bgjob = 'N'   # NO.FUN-570145
     INPUT BY NAME tm.bookno,tm.aaa07,g_bgjob WITHOUT DEFAULTS  #No.FUN-740065
 
       ON ACTION locale
          LET g_change_lang = TRUE
          #CALL cl_dynamic_locale()
          #CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          EXIT INPUT
       #->FUN-570145-end------------
 
 
        #No.FUN-740065  --Begin
        AFTER FIELD bookno
           IF NOT cl_null(tm.bookno) THEN
              CALL p301_bookno(tm.bookno)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(tm.bookno,g_errno,0)
                 LET tm.bookno = g_aza.aza81
                 DISPLAY BY NAME tm.bookno
                 NEXT FIELD bookno
              END IF
           END IF
        #No.FUN-740065  --End  
 
 
      AFTER FIELD aaa07
         IF tm.aaa07  IS NULL OR tm.aaa07 = ' ' THEN
            NEXT FIELD aaa07
         END IF

         #FUN-D20046 add begin---
         IF NOT cl_null(tm.aaa07) THEN
            IF tm.aaa07 < g_aaz642 THEN
               CALL cl_err(tm.aaa07,'agl1060',1)
               NEXT FIELD aaa07
            END IF
         END IF
         #FUN-D20046 add end-----
 
      #No.FUN-740065  --Begin
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(bookno) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aaa"
               LET g_qryparam.default1 = tm.bookno
               CALL cl_create_qry() RETURNING tm.bookno
               DISPLAY BY NAME tm.bookno
               NEXT FIELD bookno
         END CASE
      #No.FUN-740065  --End  
 
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
 
   END INPUT
#NO.FUN-570145 START---
#   IF INT_FLAG THEN LET INT_FLAG = 0 EXIT PROGRAM  END IF
#   IF cl_sure(21,21) THEN
#	  CALL cl_wait()
#	  UPDATE aaa_file SET aaa07 = tm.aaa07
#          CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#          IF l_flag THEN
#             CONTINUE WHILE
#          ELSE
#             EXIT WHILE
#          END IF
#   END IF
     IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        CONTINUE WHILE
     END IF
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW aglp301_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        EXIT PROGRAM
     END IF
 
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01= 'aglp301'
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err('aglp301','9031',1)   
        ELSE
           LET lc_cmd = lc_cmd CLIPPED,
                        " ''",
                        " '",tm.aaa07 CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'"
           CALL cl_cmdat('aglp301',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW aglp301_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        EXIT PROGRAM
     END IF
     EXIT WHILE
#No.FUN-570145 ---end---
 
   ERROR ""
   END WHILE
#   CLOSE WINDOW aglp301_w
END FUNCTION
 
#No.FUN-740065  --Begin
FUNCTION p301_bookno(p_bookno)
  DEFINE p_bookno   LIKE aaa_file.aaa01,
         l_aaaacti  LIKE aaa_file.aaaacti
  DEFINE l_aaa17    LIKE aaa_file.aaa17      #FUN-D20046 add
  DEFINE l_sql      STRING                   #FUN-D20046 add 

   LET g_errno = ' '
  #str MOD-930185 mod
  #SELECT aaaacti INTO l_aaaacti FROM aaa_file WHERE aaa01=p_bookno
   SELECT aaaacti,aaa04,aaa05,aaa07,aaa17 INTO l_aaaacti,g_aaa04,g_aaa05,g_aaa07,l_aaa17     #FUN-D20046 add aaa17
     FROM aaa_file
    WHERE aaa01 = p_bookno
   LET tm.aaa04 = g_aaa04
   LET tm.aaa05 = g_aaa05
   LET tm.aaa07 = g_aaa07
  #end MOD-930185 mod
   CASE
      WHEN l_aaaacti = 'N' LET g_errno = '9028'
      WHEN STATUS=100      LET g_errno = 'anm-062' #No.7926
      OTHERWISE            LET g_errno = SQLCA.sqlcode USING'-------'
   END CASE
  #str MOD-930185 add
   IF cl_null(g_errno) THEN
      DISPLAY BY NAME tm.aaa04,tm.aaa05,tm.aaa07
   END IF
  #end MOD-930185 add

   #FUN-D20046 add begin---
   IF NOT cl_null(l_aaa17) THEN
      LET l_sql = "SELECT aaz642 FROM ",cl_get_target_table(l_aaa17,'aaz_file'),
                  " WHERE aaz00 = '0' "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      PREPARE p301_aaa_p1 FROM l_sql
      EXECUTE p301_aaa_p1 INTO g_aaz642
   END IF
   #FUN-D20046 add end-----

END FUNCTION
#No.FUN-740065  --End
