# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: gglp200.4gl
# Descriptions...: 期末結轉作業 (整批資料處理作業)
# Input parameter: 
# Return code....: 
# Date & Author..: 2011/08/03 BY wujie   #No.FUN-B80021
# Modify.........: No.TQC-B80132 11/08/16 By wujie 修改azm的bug   
# Modify.........: No:MOD-C40094 12/04/12 By wujie 还原CE凭证时,要对这期的所有凭证都要还原
# Modify.........: No:TQC-C50055 12/05/23 By Dido 過帳前先刪除 CE 傳票 
# Modify.........: FUN-C80094 12/10/16 By xuxz 添加axcp332產生資料的還原
# Modify.........: No.CHI-C80041 12/12/25 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE bookno         LIKE aaa_file.aaa01,     #No.FUN-740020
       close_y        LIKE type_file.num5,     #closing year & month   #No.FUN-680098 smallint
       close_m        LIKE type_file.num5,     #closing year & month   #No.FUN-680098 smallint
       g_aaa04        LIKE aaa_file.aaa04,     #現行會計年度           #No.FUN-680098 smallint
       g_aaa05        LIKE aaa_file.aaa05,     #現行期別               #No.FUN-680098 smallint
       b_date         LIKE type_file.dat,      #期間起始日期           #No.FUN-680098 date       
       e_date         LIKE type_file.dat,      #期間起始日期           #No.FUN-680098 date
       g_bookno       LIKE aea_file.aea00,     #帳別 
       bno            LIKE type_file.chr6,     #起始傳票編號           #No.FUN-680098 VARCHAR(6) 
       eno            LIKE type_file.chr6,     #截止傳票編號           #No.FUN-680098 VARCHAR(6)
       g_chr          LIKE type_file.chr1,     #No.FUN-680098CHAR(1)
       ls_date        STRING,                  #No.FUN-570145
       l_flag         LIKE type_file.chr1,     #No.FUN-680098 VARCHAR(01)
       g_change_lang  LIKE type_file.chr1      #No.FUN-680098 VARCHAR(01)
 
MAIN 
   #-TQC-C50055-add-
    DEFINE l_aba01_arr  DYNAMIC ARRAY OF RECORD            
                             aba01   LIKE aba_file.aba01  
                             END RECORD              
    DEFINE l_arr_i      LIKE type_file.num5      
    DEFINE l_arr_cnt    LIKE type_file.num5      
    DEFINE l_cmd        LIKE type_file.chr1000  
    DEFINE l_aba01_ce   LIKE aba_file.aba01    
   #-TQC-C50055-end-

    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
#No.FUN-B80021 
   LET bookno = ARG_VAL(1)  #No.FUN-740020
   INITIALIZE g_bgjob_msgfile TO NULL
   LET close_y  = ARG_VAL(2)
   LET close_m  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   IF cl_null(g_bgjob) THEN LET g_bgjob = 'N' END IF
    IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   IF bookno IS NULL OR bookno = ' ' THEN
      LET bookno = g_aza.aza81
   END IF
   WHILE TRUE
      LET g_change_lang = FALSE
      IF g_bgjob = 'N' THEN
         CALL gglp200_tm(0,0)
         IF cl_sure(21,21) THEN
            CALL cl_wait()
            LET g_success = 'Y'   #MOD-7B0215
           #-TQC-C50055-add-
            DECLARE aba01_arr CURSOR FOR
             SELECT aba01 FROM aba_file
                WHERE aba00 = bookno AND aba02 = e_date AND aba06 = 'CE'
                  AND abapost = 'Y' 
            LET l_arr_i = 1
            CALL l_aba01_arr.clear()
            FOREACH aba01_arr INTO l_aba01_ce
               LET l_aba01_arr[l_arr_i].aba01 = l_aba01_ce
               LET l_arr_i = l_arr_i + 1
            END FOREACH
            LET l_arr_cnt = l_arr_i - 1
            FOR l_arr_i = 1 TO l_arr_cnt
               #已有CE类凭证时，需先还原过账
               IF NOT cl_null(l_aba01_arr[l_arr_i].aba01) THEN
                  LET l_cmd = "aglp109 '",bookno,"' '",e_date,"' '",l_aba01_arr[l_arr_i].aba01,"' ''  'Y'" 
                  CALL cl_cmdrun_wait(l_cmd)   
               END IF
            END FOR
           #-TQC-C50055-end-
            BEGIN WORK
            CALL s_showmsg_init()       #NO.FUN-710023
            CALL p200_process()
            CALL s_showmsg()            #NO.FUN-710023
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
               CLOSE WINDOW gglp200_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         IF g_aza.aza63 = 'Y' THEN
            CALL s_azmm(close_y,close_m,g_plant,bookno) RETURNING l_flag,b_date,e_date
         ELSE
            CALL s_azm(close_y,close_m) RETURNING  l_flag,b_date,e_date
         END IF
         #CHI-A70007 add --end--
         LET g_success = 'Y'
         BEGIN WORK
         CALL s_showmsg_init()       #NO.FUN-8A0086
         CALL p200_process()
         CALL s_showmsg()                           #NO.FUN-710023     
         IF g_success = 'Y' THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION gglp200_tm(p_row,p_col)
   DEFINE  p_row,p_col    LIKE type_file.num5     #No.FUN-680098 SMALLINT
   DEFINE  lc_cmd         LIKE type_file.chr1000   #No.FUN-570145 #No.FUN-680098 VARCHAR(500)
   DEFINE  l_aaa07        LIKE aaa_file.aaa07     #MOD-990010         
   DEFINE  l_azm02        LIKE azm_file.azm02 
   
   CALL s_dsmark(bookno)  #No.FUN-740020
 
   LET p_row = 4 LET p_col = 26
 
   OPEN WINDOW gglp200_w AT p_row,p_col WITH FORM "ggl/42f/gglp200" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL s_shwact(0,0,bookno)  #No.FUN-740020
   WHILE TRUE 
      IF s_shut(0) THEN RETURN END IF
      CLEAR FORM 
      LET bookno = g_aza.aza81  #No.FUN-740020
      DISPLAY BY NAME bookno    #No.FUN-740020
      SELECT aaa04,aaa05 INTO g_aaa04,g_aaa05 FROM aaa_file
       WHERE aaa01 = bookno  #No.FUN-740020
      IF g_aaa05 - 1 >0 THEN  
         LET g_aaa05 = g_aaa05 - 1
      ELSE 
         LET g_aaa04 = g_aaa04 -1
#        SELECT azm02 INTO l_azm02 FROM azm_file WHERE azm00 = bookno AND azm01 = g_aaa04
         SELECT azmm02 INTO l_azm02 FROM azmm_file WHERE azmm00 = bookno AND azmm01 = g_aaa04   #No.TQC-B80132
         IF l_azm02 ='1' THEN LET g_aaa05 =12 END IF 
         IF l_azm02 ='2' THEN LET g_aaa05 =13 END IF
      END IF 
      LET close_y = g_aaa04
      LET close_m = g_aaa05
      LET g_bgjob = 'N'   #No.FUN-570145
      INPUT bookno,close_y,close_m,g_bgjob WITHOUT DEFAULTS FROM bookno,aaa04,aaa05,g_bgjob  #No.FUN-740020
 
         AFTER FIELD bookno
            IF NOT cl_null(bookno) THEN
               CALL p200_bookno(bookno)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(bookno,g_errno,0)
                  LET bookno = g_aza.aza81
                  DISPLAY BY NAME bookno
                  NEXT FIELD bookno
               END IF
            END IF
         #No.FUN-740020  --End  
 
         AFTER FIELD aaa04
            IF close_y  IS NULL OR close_y = ' ' THEN
               NEXT FIELD aaa04
            END IF
 
         AFTER FIELD aaa05 
            IF NOT cl_null(close_m) THEN
               SELECT azm02 INTO g_azm.azm02 FROM azm_file
                 WHERE azm01 = close_y
               IF g_azm.azm02 = 1 THEN
                  IF close_m > 12 OR close_m < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD aaa05
                  END IF
               ELSE
                  IF close_m > 13 OR close_m < 1 THEN
                     NEXT FIELD aaa05
                  END IF
               END IF
            END IF
            IF close_m IS NULL OR close_m = ' ' THEN
               NEXT FIELD aaa05
            END IF
	    #取得會計年度,期別之起始,截止日期
            IF g_aza.aza63 = 'Y' THEN
               CALL s_azmm(close_y,close_m,g_plant,bookno) RETURNING l_flag,b_date,e_date
            ELSE
               CALL s_azm(close_y,close_m) RETURNING  l_flag,b_date,e_date
            END IF
            #CHI-A70007 add --end--
            SELECT aaa07 INTO l_aaa07 FROM aaa_file        #MOD-990010                                                              
             WHERE aaa01=bookno                            #MOD-990010                                                              
            IF b_date<l_aaa07 THEN CALL cl_err('','agl-993',0) NEXT FIELD aaa05 END IF #MOD-990010  
 
          ON ACTION CONTROLP
            CASE
               WHEN INFIELD(bookno) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aaa"
                  LET g_qryparam.default1 = bookno
                  CALL cl_create_qry() RETURNING bookno
                  DISPLAY BY NAME bookno
                  NEXT FIELD bookno
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
 
         #-->No.FUN-570145 --start--
         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT INPUT
 
         #MOD-510058  --begin
         AFTER INPUT
            IF g_aza.aza63 = 'Y' THEN
               CALL s_azmm(close_y,close_m,g_plant,bookno) RETURNING l_flag,b_date,e_date
            ELSE
               CALL s_azm(close_y,close_m) RETURNING  l_flag,b_date,e_date
            END IF
            #CHI-A70007 add --end--
         #MOD-510058  --end   
 
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
 
     #-->No.FUN-570145 --start--
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW gglp200_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = "Y" THEN
         LET lc_cmd = NULL
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "gglp200"
         IF SQLCA.sqlcode OR cl_null(lc_cmd) THEN
            CALL cl_err('gglp200','9031',1)  
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " ''",
                         " '",close_y CLIPPED,"'",
                         " '",close_m CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('gglp200',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW gglp200_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
      EXIT WHILE
      #-- No.FUN-570145 --end---
      ERROR ""
   END WHILE
END FUNCTION
 
FUNCTION p200_bookno(p_bookno)
   DEFINE p_bookno   LIKE aaa_file.aaa01,
          l_aaaacti  LIKE aaa_file.aaaacti
   DEFINE l_azm02    LIKE azm_file.azm02 
    
   LET g_errno = ' '
   SELECT aaaacti,aaa04,aaa05 INTO l_aaaacti,g_aaa04,g_aaa05
     FROM aaa_file
    WHERE aaa01 = p_bookno
      IF g_aaa05 - 1 >0 THEN  
         LET g_aaa05 = g_aaa05 - 1
      ELSE 
         LET g_aaa04 = g_aaa04 -1
         SELECT azmm02 INTO l_azm02 FROM azmm_file WHERE azmm00 = bookno AND azmm01 = g_aaa04   #No.TQC-B80132
         IF l_azm02 ='1' THEN LET g_aaa05 =12 END IF 
         IF l_azm02 ='2' THEN LET g_aaa05 =13 END IF
      END IF
   LET close_y = g_aaa04
   LET close_m = g_aaa05
   CASE
      WHEN l_aaaacti = 'N' LET g_errno = '9028'
      WHEN STATUS=100      LET g_errno = 'anm-062' #No.7926
      OTHERWISE            LET g_errno = SQLCA.sqlcode USING'-------'
   END CASE
  #str MOD-930186 add
   IF cl_null(g_errno) THEN
      DISPLAY g_aaa04,g_aaa05 TO aaa04,aaa05
   END IF
  #end MOD-930186 add
END FUNCTION
#No.FUN-740020  --End  
 
#FUN-570145 ----start---
FUNCTION p200_process()
  DEFINE l_azm02        LIKE azm_file.azm02   #MOD-720067
  #FUN-C80094 add--str
  SELECT oaz92,oaz93,oaz107 INTO g_oaz.oaz92,g_oaz.oaz93,g_oaz.oaz107 FROM oaz_file
  CALL p200_d_axcp332()  
  #FUN-C80094 add--end 
  #-----------------------------月結
  CALL p200_d_CE()  
  IF g_success ='Y' THEN
     UPDATE aaa_file SET aaa04 = close_y,
                         aaa05 = close_m
      WHERE aaa01 = bookno 
  END IF 
  IF g_success = 'N' THEN
     IF g_bgjob = 'N' THEN CALL cl_rbmsg(1) END IF
     RETURN
  END IF 
END FUNCTION
#NO.FUN-570145 END---------
FUNCTION p200_d_CE() 			#刪除當期來源碼為'CE'者傳票 
 DEFINE l_abh             RECORD LIKE abh_file.*     #MOD-A30032 add 
 DEFINE l_abh09,l_abh09_2 LIKE abh_file.abh09        #MOD-A30032 add 
 DEFINE g_sql             STRING                     #MOD-A30032 add
 DEFINE g_min_eom_no LIKE aba_file.aba01
 DEFINE l_cmd        LIKE type_file.chr1000
 DEFINE l_cnt        LIKE type_file.num5
 DEFINE l_n          LIKE type_file.num5 
  #No.MOD-C40094  --begin
 DEFINE l_arr_i           LIKE type_file.num5
 DEFINE l_arr_cnt         LIKE type_file.num5
 DEFINE l_aba01_ce        LIKE aba_file.aba01
 DEFINE l_aba01_arr       DYNAMIC ARRAY OF RECORD
                          aba01   LIKE aba_file.aba01
                          END RECORD
 #No.MOD-C40094  --end 
 
#        "Get max no of 'CE' type"
         LET l_n = 0 
#No.MOD-C40094  --begin
#         SELECT MIN(aba01) INTO g_min_eom_no FROM aba_file
#            WHERE aba00 = bookno AND aba02 = e_date AND aba06 = 'CE'
#              AND abapost = 'Y' #TQC-B30141

        #-TQC-C50055-mark-
        #DECLARE aba01_arr CURSOR FOR
        # SELECT aba01 FROM aba_file
        #    WHERE aba00 = bookno AND aba02 = e_date AND aba06 = 'CE'
        #      AND abapost = 'Y' #TQC-B30141
        #LET l_arr_i = 1
        #CALL l_aba01_arr.clear()
        #FOREACH aba01_arr INTO l_aba01_ce
        #   LET l_aba01_arr[l_arr_i].aba01 = l_aba01_ce
        #   LET l_arr_i = l_arr_i + 1
        #END FOREACH
        #LET l_arr_cnt = l_arr_i - 1
        #FOR l_arr_i = 1 TO l_arr_cnt
        #   #TQC-B30141 --begin
        #   #已有CE类凭证时，需先还原过账
        #   #IF NOT cl_null(g_min_eom_no) THEN
        #     #LET l_cmd = "aglp109 '",bookno,"' '",e_date,"' '",g_min_eom_no,"' '' ,'Y'"    
        #     #CALL cl_cmdrun_wait(l_cmd)
        #   #END IF
        #   #TQC-B30141 --end
        #   IF NOT cl_null(l_aba01_arr[l_arr_i].aba01) THEN
        #      LET l_cmd = "aglp109 '",bookno,"' '",e_date,"' '",l_aba01_arr[l_arr_i].aba01,"' ''  'Y'"
        #     #CALL cl_cmdrun_wait(l_cmd)      #MOD-C20169 mark
        #      CALL cl_cmdrun(l_cmd)           #MOD-C20169 add
        #   END IF
        #END FOR
        #-TQC-C50055-end-
#No.MOD-C40094  --end
        #需一併刪除abh_file
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM abb_file,aag_file
          WHERE abb03=aag01 AND abb00=aag00
            AND aag20='Y'
            AND abb00 = bookno
            AND abb01 IN (SELECT aba01 FROM aba_file
                           WHERE aba00 = bookno
                             AND aba02 = e_date
                             AND aba19 <> 'X'  #CHI-C80041
                             AND aba06 = 'CE')
         IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
         IF l_cnt > 0 THEN
#          "Delete abh of 'CE' type"
            LET g_sql =  "SELECT * FROM abh_file ",
                         " WHERE abh00 = ",bookno,
                         "   AND abh01 IN (SELECT aba01 FROM aba_file ",
                         "                  WHERE aba00 = ",bookno,
                         "                    AND aba02 = '",e_date,"'",
                         "                    AND aba19 <> 'X' ",  #CHI-C80041
                         "                    AND aba06 = 'CE') "
            PREPARE abh_pre FROM g_sql
            DECLARE abh_curs1 CURSOR FOR abh_pre
            FOREACH abh_curs1 INTO l_abh.*
              IF SQLCA.sqlcode THEN
                 CALL cl_err('',SQLCA.sqlcode,0)
                 EXIT FOREACH
              END IF
  
 {ckp#2a}     DELETE FROM abh_file WHERE abh00=l_abh.abh00
                                     AND abh01=l_abh.abh01
                                     AND abh02=l_abh.abh02
           #MOD-A30032---modify---end---
              IF SQLCA.sqlcode THEN
                 IF g_bgerr THEN
                    CALL s_errmsg('abh00',bookno,'(s_eom:ckp#2a)',SQLCA.sqlcode,1)
                 ELSE
                    CALL cl_err3("del","abh_file",bookno,"",SQLCA.sqlcode,"","(s_eom:ckp#2a)",1)
                 END IF
                 LET g_success='N' RETURN
              END IF
              IF SQLCA.sqlerrd[3] >0 THEN LET l_n = l_n +1 END IF  
           #MOD-A30032---add---start---
              SELECT SUM(abh09) INTO l_abh09 FROM abh_file
               WHERE abhconf='Y' AND abh07=l_abh.abh07
                 AND abh08=l_abh.abh08
                 AND abh00=l_abh.abh00               #MOD-AA0047
              IF cl_null(l_abh09) THEN LET l_abh09=0 END IF
              SELECT SUM(abh09) INTO l_abh09_2 FROM abh_file
               WHERE abhconf='N' AND abh07=l_abh.abh07
                 AND abh08=l_abh.abh08
                 AND abh00=l_abh.abh00               #MOD-AA0047
              IF cl_null(l_abh09_2) THEN LET l_abh09_2=0 END IF
              UPDATE abg_file SET abg072=l_abh09,
                                  abg073=l_abh09_2
                            WHERE abg00=bookno
                              AND abg01=l_abh.abh07 AND abg02=l_abh.abh08
              IF SQLCA.sqlerrd[3] >0 THEN LET l_n = l_n +1 END IF 
            END FOREACH
           #MOD-A30032---add---end---
         END IF
         
         #FUN-B40056 -begin
#       "Delete tic of 'CE' type"
{ckp#21} DELETE FROM tic_file
         WHERE tic00 = bookno
           AND tic04 IN (SELECT aba01 FROM aba_file
                          WHERE aba00 = bookno
                            AND aba02 = e_date
                            AND aba19 <> 'X'  #CHI-C80041
                            AND aba06 = 'CE')
        IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
              CALL s_errmsg('abb00',bookno,'(s_eom:ckp#21)',SQLCA.sqlcode,1)
            ELSE
              CALL cl_err3("del","tic_file",bookno,"",SQLCA.sqlcode,"","(s_eom:ckp#21)",1)
            END IF
            LET g_success='N' RETURN
        END IF
        IF SQLCA.sqlerrd[3] >0 THEN LET l_n = l_n +1 END IF 
       #FUN-B40056 -end
         
#        "Delete abb of 'CE' type"
{ckp#21} DELETE FROM abb_file
         WHERE abb00 = bookno
           AND abb01 IN (SELECT aba01 FROM aba_file
                          WHERE aba00 = bookno
                            AND aba02 = e_date
                            AND aba19 <> 'X'  #CHI-C80041
                            AND aba06 = 'CE')
        IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
              CALL s_errmsg('abb00',bookno,'(s_eom:ckp#21)',SQLCA.sqlcode,1)
            ELSE
              CALL cl_err3("del","abb_file",bookno,"",SQLCA.sqlcode,"","(s_eom:ckp#21)",1)
            END IF
            LET g_success='N' RETURN
        END IF
        IF SQLCA.sqlerrd[3] >0 THEN LET l_n = l_n +1 END IF 
#        "Delete aba of 'CE' type"
{ckp#22} DELETE FROM aba_file
         WHERE aba00 = bookno
           AND aba02 = e_date
           AND aba19 <> 'X'  #CHI-C80041
           AND aba06 = 'CE'
        IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
              LET g_showmsg=bookno,"/",e_date,"/",'CE'
              CALL s_errmsg('abb00,aba02,aba06',g_showmsg,'(s_eom:ckp#22)',SQLCA.sqlcode,1)
            ELSE
              CALL cl_err3("del","aba_file",bookno,e_date,SQLCA.sqlcode,"","(s_eom:ckp#22)",1)
            END IF
            LET g_success='N' RETURN
        END IF
        IF SQLCA.sqlerrd[3] >0 THEN LET l_n = l_n +1 END IF
       
        IF l_n =0 THEN LET g_success ='N' END IF  
END FUNCTION
#FUN-C80094--add--str
FUNCTION p200_d_axcp332()
   DEFINE l_aba00 LIKE aba_file.aba00
   DEFINE l_aba02 LIKE aba_file.aba02
   DEFINE l_after_year     LIKE type_file.num5,      
          l_after_month    LIKE type_file.num5,
          l_bdate         LIKE type_file.dat,      
          l_edate         LIKE type_file.dat
   DEFINE l_aba01         LIKE aba_file.aba01,
          l_aba19         LIKE aba_file.aba19,
          l_abapost       LIKE aba_file.abapost,
          l_flag          LIKE type_file.chr1,
          l_flag1          LIKE type_file.chr1,
          l_n             LIKE type_file.num5
   LET l_flag = 'Y' 
   IF g_aza.aza02 = 1 THEN 
      IF close_m = 12 THEN
         LET l_after_year = close_y+1
         LET l_after_month = 1
      ELSE
         LET l_after_year = close_y
         LET l_after_month = close_m+1 
      END IF 
   END IF 
   IF g_aza.aza02 = 2 THEN 
      IF close_m = 13 THEN
         LET l_after_year = close_y+1
         LET l_after_month = 1
      ELSE
         LET l_after_year = close_y
         LET l_after_month = close_m+1      
      END IF
   END IF 
   CALL s_azm(l_after_year,l_after_month) 
         RETURNING l_flag1,l_bdate,l_edate
   LET l_aba02=l_bdate
   SELECT COUNT(*) INTO l_n FROM aba_file 
    WHERE aba00 = bookno AND aba02 = l_aba02 
      AND aba03 = l_after_year AND aba04 =l_after_month 
      AND aba06 = 'RA'
      AND aba19 <> 'X'  #CHI-C80041
    
   IF l_n > 0 THEN 
         DECLARE p332_chk_cs CURSOR FOR  
          SELECT aba01,aba19,abapost  FROM aba_file 
           WHERE aba00 = bookno AND aba02 = l_aba02 
             AND aba03 = l_after_year AND aba04 =l_after_month
             AND aba06 = 'RA'
             AND aba19 <> 'X'  #CHI-C80041
         FOREACH p332_chk_cs INTO l_aba01,l_aba19,l_abapost
            IF l_aba19 = 'Y' AND l_abapost = 'Y' THEN 
               LET l_flag = 'N'
               CALL s_errmsg('aba01',g_showmsg,l_aba01,'aar-347',1)
            END IF 
         END FOREACH 
         IF l_flag = 'Y' THEN 
            DECLARE p332_del_cs CURSOR FOR  
               SELECT aba00,aba01  FROM aba_file 
                WHERE aba00 = bookno AND aba02 = l_aba02 
                  AND aba03 = l_after_year AND aba04 =l_after_month
                  AND aba06 = 'RA'
                  AND aba19 <> 'X'  #CHI-C80041
            FOREACH p332_del_cs INTO l_aba00,l_aba01
               DELETE FROM aba_file WHERE aba00 = l_aba00 AND aba01 = l_aba01
               DELETE FROM abb_file WHERE abb00 = l_aba00 AND abb01 = l_aba01
            END FOREACH
         END IF 
   END IF
END FUNCTION
#FUN-C80094--add--end
