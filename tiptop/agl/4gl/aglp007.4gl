# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: aglp007.4gl
# Descriptions...: 資料匯入合併區作業(整批資料處理作業)_產生調整分錄
# Date & Author..: #FUN-B50001 11/05/09 By zhangweib
# Modify.........: No.FUN-B60134 11/06/27 By mpp  给g_axj.axj05赋值
# Modify.........: No.TQC-B70069 11/07/08 By zhangweib 差生調整分錄前,先刪除原資料
# Modify.........: NO.FUN-B70065 11/08/10 BY belle 追單,少數股權設定抓「累積換算調整數」做金額計算，但無法將換匯產生的累換數納入。
# Modify.........: No.FUN-B80135 11/08/22 By minpp    相關日期欄位不可小於關帳日期
# Modify.........: NO.MOD-BB0262 11/11/23 By xuxz 註釋中版本號修改

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm         RECORD  
                  yy        LIKE type_file.num5,   #匯入會計年度
                  bm        LIKE type_file.num5,   #起始期間
                  em        LIKE type_file.num5,   #截止期間
                  axa01     LIKE axa_file.axa01,   #族群代號
                  axa02     LIKE axa_file.axa02,   #上層公司編號
                  axa03     LIKE axa_file.axa03,   #帳別
                  gl        LIKE aac_file.aac01,   #調整單別
                  ver       LIKE axg_file.axg17,   #版本
                  hisyy     LIKE axg_file.axg06,   #歷史匯率年度
                  hismm     LIKE axg_file.axg07,    #歷史匯率期別
                  axa06     LIKE axa_file.axa06, 
                  q1        LIKE type_file.chr1,
                  h1        LIKE type_file.chr1
                  END RECORD,
       x_aaa03    LIKE aaa_file.aaa03,             #上層公司記帳幣別
       g_aaa04    LIKE aaa_file.aaa04,             #現行會計年度
       g_aaa05    LIKE aaa_file.aaa05,             #現行期別
       g_aaa07    LIKE aaa_file.aaa07,             #關帳日期
       g_bdate    LIKE type_file.dat,              #期間起始日期
       g_edate    LIKE type_file.dat,              #期間起始日期
       g_dbs_gl   LIKE type_file.chr21,
       g_bookno   LIKE aea_file.aea00,             #帳別
       ls_date         STRING,
       l_flag          LIKE type_file.chr1,
       g_change_lang   LIKE type_file.chr1,
       g_axk      RECORD LIKE axk_file.*,
       g_axg      RECORD LIKE axg_file.*,
       g_rate     LIKE type_file.num20_6,
       g_aac      RECORD LIKE aac_file.*,
       g_axi      RECORD LIKE axi_file.*,
       g_axj      RECORD LIKE axj_file.*,
       g_i        LIKE type_file.num5,
       g_amt      LIKE axg_file.axg08,
       g_axg04    LIKE axg_file.axg04,
       g_axk10_d  LIKE axk_file.axk10,
       g_axk10_c  LIKE axk_file.axk10,
       g_axf      RECORD LIKE axf_file.*,
       g_axt03    LIKE axt_file.axt03,
       g_axs03    LIKE axs_file.axs03,
       g_axu03    LIKE axu_file.axu03,
       g_affil    LIKE axj_file.axj05,
       g_dc       LIKE axj_file.axj06,
       g_flag_r   LIKE type_file.chr1,
       g_yy       LIKE type_file.num5,
       g_mm       LIKE type_file.num5,
       g_em       LIKE type_file.chr10
DEFINE g_aaw01        LIKE aaw_file.aaw01
DEFINE g_aaw05        LIKE aaw_file.aaw05
DEFINE g_dbs_axz03     LIKE type_file.chr21
DEFINE g_axz03         LIKE axz_file.axz03
DEFINE g_sql           STRING
DEFINE g_aaw01_axb04  LIKE aaw_file.aaw01
DEFINE g_dbs_axb04     LIKE type_file.chr21
DEFINE g_newno         LIKE axi_file.axi01
DEFINE g_axa        DYNAMIC ARRAY OF RECORD
                    axa01      LIKE axa_file.axa01,  #族群代號
                    axa02      LIKE axa_file.axa02,  #上層公司
                    axa03      LIKE axa_file.axa03   #帳別
                    END RECORD 
DEFINE g_axk09_o    LIKE axk_file.axk09,             #期別
       g_axk09_o1   LIKE axk_file.axk09,             #期別  
       g_axk07_o    LIKE axk_file.axk07,             #異動碼值
       g_axk07_o1   LIKE axk_file.axk07              #異動碼值 
DEFINE g_axg07_o    LIKE axg_file.axg07,             #期別
       g_axg07_o1   LIKE axg_file.axg07              #期別  
DEFINE g_axk07      LIKE axk_file.axk07
DEFINE g_axj07_total  LIKE axj_file.axj07
DEFINE g_date_e     LIKE type_file.dat
DEFINE g_cnt_axf09  LIKE type_file.num5
DEFINE g_cnt_axf10  LIKE type_file.num5
DEFINE g_dbs_axf09  LIKE azp_file.azp03
DEFINE g_dbs_axf10  LIKE azp_file.azp03
DEFINE g_aaw01_axf09 LIKE aaw_file.aaw01
DEFINE g_aaw01_axf10 LIKE aaw_file.aaw01
DEFINE g_aaw06       LIKE aaw_file.aaw06
DEFINE g_dept        DYNAMIC ARRAY OF RECORD        
                     axa01      LIKE axa_file.axa01,  #族群代號
                     axa02      LIKE axa_file.axa02,  #上層公司
                     axa03      LIKE axa_file.axa03,  #帳別
                     axb04      LIKE axb_file.axb04,  #下層公司
                     axb05      LIKE axb_file.axb05   #帳別  
                     END RECORD
DEFINE l_rate        LIKE axp_file.axp05             #功能幣別匯率    
DEFINE l_rate1       LIKE axp_file.axp05             #記帳幣別匯率   
DEFINE g_azw02      LIKE azw_file.azw02
DEFINE g_axf09_axz05 LIKE axz_file.axz05
DEFINE g_axf10_axz05 LIKE axz_file.axz05
DEFINE g_axz08       LIKE axz_file.axz08
DEFINE g_axz08_axf10 LIKE axz_file.axz08
DEFINE g_low_axf09        LIKE type_file.num5
DEFINE g_up_axf09         LIKE type_file.num5
DEFINE g_low_axf10        LIKE type_file.num5
DEFINE g_up_axf10         LIKE type_file.num5
DEFINE g_axa02_axf09      LIKE axa_file.axa02
DEFINE g_axa02_axf10      LIKE axa_file.axa02
DEFINE g_axa09_axf09      LIKE axa_file.axa09
DEFINE g_axa09_axf10      LIKE axa_file.axa09
DEFINE g_axz06_axf09      LIKE axz_file.axz06
DEFINE g_axz06_axf10      LIKE axz_file.axz06
DEFINE g_aej              RECORD 
                          aej04  LIKE aej_file.aej04,
                          aej05  LIKE aej_file.aej05,
                          aej07  LIKE aej_file.aej07,
                          aej08  LIKE aej_file.aej08,
                          aej09  LIKE aej_file.aej09,
                          aej10  LIKE aej_file.aej10,
                          aej11  LIKE aej_file.aej11
                          END RECORD
DEFINE g_aek              RECORD 
                          aek04  LIKE aek_file.aek04,
                          aek05  LIKE aek_file.aek05,
                          aek06  LIKE aek_file.aek06,
                          aek08  LIKE aek_file.aek08,
                          aek09  LIKE aek_file.aek09,
                          aek10  LIKE aek_file.aek10,
                          aek11  LIKE aek_file.aek11
                          END RECORD
DEFINE g_aem              RECORD 
                          aem04  LIKE aem_file.aem04,
                          aem05  LIKE aem_file.aem05,
                          aem06  LIKE aem_file.aem06,
                          aem07  LIKE aem_file.aem07,
                          aem08  LIKE aem_file.aem08,
                          aem09  LIKE aem_file.aem09,
                          aem11  LIKE aem_file.aem11,
                          aem12  LIKE aem_file.aem12,
                          aem13  LIKE aem_file.aem13,
                          aem14  LIKE aem_file.aem14,
                          aem15  LIKE aem_file.aem15
                          END RECORD
DEFINE g_axj1             RECORD 
                          axj06  LIKE axj_file.axj06,
                          axj07  LIKE axj_file.axj07
                          END RECORD
DEFINE g_axa06            LIKE axa_file.axa06
DEFINE g_axa05            LIKE axa_file.axa05
DEFINE g_type             LIKE type_file.chr1  
DEFINE g_flag             LIKE type_file.chr1
DEFINE g_aaz87            LIKE aaz_file.aaz87   #FUN-B70065
#FUN-B80135--add--str--
DEFINE g_year           LIKE  type_file.chr4
DEFINE g_month          LIKE  type_file.chr2
#FUN-B80135--add--end--


MAIN
DEFINE  l_axz03     LIKE axz_file.axz03

   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   LET g_bookno = ARG_VAL(1)
   IF g_bookno IS NULL OR g_bookno = ' ' THEN
      SELECT aaz64 INTO g_bookno FROM aaz_file    #總帳預設帳別
   END IF
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.axa01 = ARG_VAL(1)
   LET tm.axa02 = ARG_VAL(2)
   LET tm.axa03 = ARG_VAL(3)
   LET tm.yy    = ARG_VAL(4)
   LET tm.axa06 = ARG_VAL(5)
   LET tm.em    = ARG_VAL(6)
   LET tm.q1    = ARG_VAL(7)
   LET tm.h1    = ARG_VAL(8)
   LET tm.gl    = ARG_VAL(9)
   LET tm.ver   = ARG_VAL(10)
   LET tm.hisyy = ARG_VAL(11)
   LET tm.hismm = ARG_VAL(12)
   LET g_bgjob  = ARG_VAL(13)
   IF cl_null(g_bgjob) THEN LET g_bgjob= "N" END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   IF cl_null(tm.ver) THEN LET tm.ver = '00' END IF
  
   #FUN-B80135--add--str--
   SELECT aaa07 INTO g_aaa07 FROM aaa_file,aaw_file
    WHERE aaa01 = aaw01 AND aaw00 = '0'
   LET g_year = YEAR(g_aaa07)
   LET g_month= MONTH(g_aaa07)
   #FUN-B80135--add—end--
   SELECT aaw01 INTO g_aaw01 FROM aaw_file WHERE aaw00='0'  #FUN-B80135
  WHILE TRUE
     LET g_change_lang = FALSE
     IF g_bgjob = 'N' THEN
        CALL aglp007_tm(0,0)
        IF cl_sure(21,21) THEN
           SELECT axz06 INTO x_aaa03 FROM axz_file where axz01 = tm.axa02
           SELECT axz03 INTO l_axz03 FROM axz_file WHERE axz01 = tm.axa02
           SELECT azw02 INTO g_azw02 FROM azw_file WHERE azw01 = l_axz03
           CALL cl_wait()
           LET g_success = 'Y'
           BEGIN WORK
           CALL p007()
           CALL s_showmsg()  
           IF g_success='Y' THEN
              COMMIT WORK
              CALL cl_end2(1) RETURNING l_flag    #批次作業正確結束
           ELSE
              ROLLBACK WORK
              CALL cl_end2(2) RETURNING l_flag    #批次作業失敗
           END IF
           IF l_flag THEN
              CONTINUE WHILE
           ELSE
              CLOSE WINDOW aglp007_w
              EXIT WHILE
           END IF
        END IF
     ELSE
        SELECT aaa04,aaa05,aaa07 INTO g_aaa04,g_aaa05,g_aaa07
          FROM aaa_file 
        #WHERE aaa01 = g_bookno   #FUN-B80135
         WHERE aaa01 = g_aaw01    #FUN-B80135
        SELECT axz06 INTO x_aaa03 FROM axz_file where axz01 = tm.axa02
        SELECT axz03 INTO l_axz03 FROM axz_file WHERE axz01 = tm.axa02
        SELECT azw02 INTO g_azw02 FROM azw_file WHERE azw01 = l_axz03
       
        LET g_success = 'Y'
        BEGIN WORK
        CALL p007()
        CALL s_showmsg()
        IF g_success = 'Y' THEN
           COMMIT WORK
        ELSE
           ROLLBACK WORK
        END IF
        CALL cl_batch_bg_javamail(g_success)
        EXIT WHILE
     END  IF
  END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION aglp007_tm(p_row,p_col)
   DEFINE  p_row,p_col    LIKE type_file.num5,
           l_cnt          LIKE type_file.num5,
           l_axa03        LIKE axa_file.axa03
   DEFINE  lc_cmd         LIKE type_file.chr1000    
   DEFINE  l_axa09        LIKE axa_file.axa09
   DEFINE  l_aznn01       LIKE aznn_file.aznn01
   DEFINE  l_axz03        LIKE axz_file.axz03

   IF s_shut(0) THEN RETURN END IF
#  CALL s_dsmark(g_bookno)    #FUN-BB80135

   LET p_row = 4 LET p_col = 30

   OPEN WINDOW aglp007 AT p_row,p_col WITH FORM "agl/42f/aglp007" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()

# Prog. Version..: '5.30.06-13.03.12(0,0,g_bookno)  #FUN-B80135
   CALL cl_opmsg('q')
   WHILE TRUE 
      CLEAR FORM 
      INITIALIZE tm.* TO NULL
      SELECT aaa04,aaa05,aaa07 INTO g_aaa04,g_aaa05,g_aaa07
        FROM aaa_file 
#      WHERE aaa01 = g_bookno   #FUN-B80135
       WHERE aaa01 = g_aaw01   #FUN-B80135
      SELECT axz06 INTO x_aaa03 FROM axz_file where axz01 = tm.axa02

      LET tm.yy = g_aaa04  
      LET tm.bm = 0
      DISPLAY tm.bm TO FORMONLY.bm
      LET tm.em = g_aaa05
      LET tm.ver = '00'
      LET tm.hisyy = g_aaa04
      LET tm.hismm = g_aaa05
      LET g_bgjob = 'N'

      INPUT BY NAME tm.axa01,tm.axa02,tm.yy,tm.axa06,tm.em,tm.q1,tm.h1,tm.gl,g_bgjob,  
                    tm.ver,tm.hisyy,tm.hismm
            WITHOUT DEFAULTS 

         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT INPUT
         
         #No.FUN-B80135--add--str--
         AFTER FIELD   yy       #会计年度
            IF NOT cl_null(tm.yy) THEN
               IF tm.yy < 0 THEN
                  CALL cl_err(tm.yy,'apj-035',0)
                  NEXT FIELD yy
               END IF
               IF tm.yy < g_year THEN
                  CALL cl_err(tm.yy,'axm-164',0)
                  NEXT FIELD yy
               ELSE
                   IF tm.yy=g_year AND tm.em <= g_month THEN
                     CALL cl_err(tm.em,'axm-164',0)
                     NEXT FIELD  em
                   END IF
               END IF
            END IF 
         #No.FUN-B80135--add—end--

         AFTER FIELD em    
            IF NOT cl_null(tm.em) THEN
               IF tm.bm >tm.em  THEN 
                  CALL cl_err('','9011',0) NEXT FIELD em 
               END IF
               LET g_date_e = s_getlastday(MDY(tm.em ,'1',tm.yy))
           #No.FUN-B80135--add--str--
               SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = g_axq.axq06
            IF g_azm.azm02 = 1 THEN
               IF tm.em > 12 OR tm.em< 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em
               END IF
            ELSE
               IF tm.em > 13 OR tm.em < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em
               END IF
            END IF
            
            IF NOT  cl_null(tm.yy) AND (tm.yy=g_year 
               AND tm.em<=g_month) THEN
               CALL cl_err(tm.em,'axm-164',0)
               NEXT FIELD em
            END IF 
           #No.FUN-B80135--add—end--

            END IF

         AFTER FIELD q1
         IF cl_null(tm.q1) AND  g_axa06 = '2' THEN 
            NEXT FIELD q1 
         END IF
         IF cl_null(tm.q1) OR tm.q1 NOT MATCHES '[1234]' THEN
            NEXT FIELD q1
         END IF
 
         AFTER FIELD h1 #半年報
            IF (cl_null(tm.h1) OR tm.h1>2 OR tm.h1<0) AND tm.axa06='4' THEN
               NEXT FIELD h1
            END IF
           
         AFTER FIELD axa01
            IF NOT cl_null(tm.axa01) THEN
               SELECT DISTINCT axa01 FROM axa_file WHERE axa01=tm.axa01
               IF STATUS THEN
                  CALL cl_err3("sel","axa_file",tm.axa01,tm.axa02,"agl-11","","",0)
                  NEXT FIELD axa01 
               END IF
            END IF

         AFTER FIELD axa02  #公司編號
            IF NOT cl_null(tm.axa02) THEN
               SELECT count(*) INTO l_cnt FROM axa_file 
                WHERE axa01=tm.axa01 AND axa02=tm.axa02
               IF l_cnt = 0  THEN 
                  CALL cl_err('sel axa:','agl-118',0) NEXT FIELD axa02 
               END IF
               SELECT DISTINCT axa03 INTO l_axa03 FROM axa_file
                WHERE axa01=tm.axa01
                  AND axa02=tm.axa02
               LET tm.axa03 = l_axa03
               DISPLAY l_axa03 TO axa03

               LET g_sql = "SELECT aaw05,aaw06 FROM ",cl_get_target_table(g_plant_new,'aaw_file'),
                           " WHERE aaw00 = '0'"
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql
               CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
               PREPARE p007_pre_01 FROM g_sql
               DECLARE p007_cur_01 CURSOR FOR p007_pre_01
               OPEN p007_cur_01
               FETCH p007_cur_01 INTO g_aaw05,g_aaw06 #合併帳別
               CLOSE p007_cur_01
               CALL s_aaz641_dbs(tm.axa01,tm.axa02) RETURNING g_dbs_axz03
               CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaw01
            END IF
            DISPLAY l_axa03 TO axa03

            LET g_axa06 = '2'
            SELECT axa05,axa06 
              INTO g_axa05,g_axa06  #平均匯率計算方式 / 編制合併期別 1.月 2.季 3.半年 4.年
             FROM axa_file
            WHERE axa01 = tm.axa01     #族群編號
              AND axa04 = 'Y'   #最上層公司否
            LET tm.axa06 = g_axa06
            DISPLAY BY NAME tm.axa06
            CALL p007_set_entry()    
            CALL p007_set_no_entry()

            IF tm.axa06 = '1' THEN
                LET tm.q1 = '' 
                LET tm.h1 = '' 
                LET tm.em = g_aaa05
            END IF
            IF tm.axa06 = '2' THEN
                LET tm.h1 = '' 
                LET tm.em = '' 
            END IF
            IF tm.axa06 = '3' THEN
                LET tm.em = '' 
                LET tm.q1 = ''
            END IF
            IF tm.axa06 = '4' THEN
                LET tm.em = '' 
                LET tm.q1 = ''
                let tm.h1 = ''
            END IF
            DISPLAY BY NAME tm.em
            DISPLAY BY NAME tm.q1
            DISPLAY BY NAME tm.h1

         AFTER FIELD gl
            IF NOT cl_null(tm.gl) THEN
               SELECT *  FROM aac_file        #讀取單據性質資料
                WHERE aac01=tm.gl AND aacacti = 'Y' AND aac11='A'
               IF SQLCA.sqlcode THEN          #抱歉,讀不到
                  CALL cl_err3("sel","aac_file",tm.gl,"","agl-035","","",0)
                  NEXT FIELD gl
               END IF
            END IF
            IF NOT cl_null(tm.axa06) THEN
                CASE
                    WHEN tm.axa06 = '1'  #月 
                         LET tm.bm = 0
                    OTHERWISE      
                         CALL s_axz03_dbs(tm.axa02) RETURNING l_axz03 
                         CALL s_get_aznn01(l_axz03,tm.axa06,tm.axa03,tm.yy,tm.q1,tm.h1) RETURNING tm.em
                END CASE
            END IF

         AFTER FIELD ver      #版本 
            IF cl_null(tm.ver) THEN
               CALL cl_err('','mfg0037',0) NEXT FIELD ver 
            END IF

         AFTER FIELD hisyy    #歷史匯率年度 
            IF cl_null(tm.hisyy) THEN
               CALL cl_err('','mfg0037',0) NEXT FIELD hisyy 
            END IF

         AFTER FIELD hismm    #歷史匯率期別 
            IF cl_null(tm.hismm) THEN
               CALL cl_err('','mfg0037',0) NEXT FIELD hismm
            END IF

         ON ACTION CONTROLR
            CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask()

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(axa01) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_axa"
                  LET g_qryparam.default1 = tm.axa01
                  CALL cl_create_qry() RETURNING tm.axa01,tm.axa02,tm.axa03
                  DISPLAY BY NAME tm.axa01,tm.axa02,tm.axa03
                  NEXT FIELD axa01
               WHEN INFIELD(axa02) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_axz"
                  LET g_qryparam.default1 = tm.axa02
                  CALL cl_create_qry() RETURNING tm.axa02
                  DISPLAY BY NAME tm.axa02
                  NEXT FIELD axa02
               WHEN INFIELD(gl) #單據性質
                  CALL q_aac(FALSE,TRUE,tm.gl,'A',' ',' ','AGL')
                       RETURNING tm.gl         
                  DISPLAY  BY NAME tm.gl  
                  NEXT FIELD gl     
            END CASE

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
          ON ACTION about
             CALL cl_about()
 
          ON ACTION help
             CALL cl_show_help()

         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT

         BEFORE INPUT
             CALL cl_qbe_init()
             CALL p007_set_entry()
             CALL p007_set_no_entry()

         ON ACTION qbe_select
            CALL cl_qbe_select()

         ON ACTION qbe_save
            CALL cl_qbe_save()

   END INPUT
     IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()
        CONTINUE WHILE
     END IF
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW aglp007_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
    IF g_bgjob = 'Y' THEN
       SELECT zz08 INTO lc_cmd FROM zz_file
        WHERE zz01= 'aglp007'
       IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err('aglp007','9031',1)   
       ELSE
          LET lc_cmd = lc_cmd CLIPPED,
                       " ''",
                       " '",tm.axa01,"'", 
                       " '",tm.axa02,"'", 
                       " '",tm.axa03,"'", 
                       " '",tm.yy,"'",    
                       " '",tm.axa06,"'", 
                       " '",tm.em,"'",    
                       " '",tm.q1,"'",    
                       " '",tm.h1,"'",    
                       " '",tm.gl,"'",
                       " '",tm.gl CLIPPED,"'",
                       " '",tm.ver CLIPPED,"'",
                       " '",tm.hisyy CLIPPED,"'",
                       " '",tm.hismm CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'"
          CALL cl_cmdat('aglp007',g_time,lc_cmd CLIPPED)
       END IF
       CLOSE WINDOW aglp007_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
       EXIT PROGRAM
    END IF
    EXIT WHILE
END WHILE

END FUNCTION
   
FUNCTION p007()
DEFINE l_sql        STRING,
       l_sql_axr    LIKE type_file.chr1000,
       i,g_no       LIKE type_file.num5,  
       l_aah         RECORD 
                     aah01      LIKE aah_file.aah01,  #科目編號
                     aah02      LIKE aah_file.aah02,  #會計年度
                     aah03      LIKE aah_file.aah03,  #期別
                     aah04      LIKE aah_file.aah04,  #借方金額
                     aah05      LIKE aah_file.aah05,  #貸方金額
                     aah06      LIKE aah_file.aah06,  #借方筆數
                     aah07      LIKE aah_file.aah07   #貸方筆數
                     END RECORD,
       l_aed         RECORD
                     aed01      LIKE aed_file.aed01,  #科目年度
                     aed011     LIKE aed_file.aed011, #異動碼順序
                     aed02      LIKE aed_file.aed02,  #異動碼值
                     aed03      LIKE aed_file.aed03,  #會計年度
                     aed04      LIKE aed_file.aed04,  #期別
                     aed05      LIKE aed_file.aed05,  #借方總金額
                     aed06      LIKE aed_file.aed06,  #貸方總金額
                     aed07      LIKE aed_file.aed07,  #借方總筆數
                     aed08      LIKE aed_file.aed08   #貸方總筆數
                     END RECORD,
       l_aeh         RECORD LIKE aeh_file.*,
       l_aei16       LIKE aei_file.aei16,
       l_aei17       LIKE aei_file.aei17,
       l_chg_aeii11_1 LIKE axr_file.axr13,
       l_chg_aeii12_1 LIKE axr_file.axr13,
       l_chg_aeii11   LIKE axr_file.axr13,
       l_chg_aeii12   LIKE axr_file.axr13,
       l_chg_aeii11_a LIKE axr_file.axr13,
       l_chg_aeii12_a LIKE axr_file.axr13,
       l_aeii        RECORD LIKE aeii_file.*,
       l_axq1        RECORD
                     axq05      LIKE axq_file.axq05,  #科目年度
                     axq06      LIKE axq_file.axq06,  #會計年度
                     axq07      LIKE axq_file.axq07,  #期別
                     axq08      LIKE axq_file.axq08,  #借方金額
                     axq09      LIKE axq_file.axq09,  #貸方金額
                     axq10      LIKE axq_file.axq10,  #借方筆數
                     axq11      LIKE axq_file.axq11,  #貸方筆數
                     axq13      LIKE axq_file.axq13   #關係人代號 
                     END RECORD,
       l_axq         RECORD          
                     axq00      LIKE axq_file.axq00,
                     axq01      LIKE axq_file.axq01,
                     axq02      LIKE axq_file.axq02,
                     axq03      LIKE axq_file.axq03,
                     axq04      LIKE axq_file.axq04,
                     axq041     LIKE axq_file.axq041,
                     axq05      LIKE axq_file.axq05,
                     axq06      LIKE axq_file.axq06,
                     axq07      LIKE axq_file.axq07,
                     axq08      LIKE axq_file.axq08,
                     axq09      LIKE axq_file.axq09,
                     axq10      LIKE axq_file.axq10,
                     axq11      LIKE axq_file.axq11,
                     axq12      LIKE axq_file.axq12,
                     axq13      LIKE axq_file.axq13
                     END RECORD,
       l_axe         RECORD
                     axe04      LIKE axe_file.axe04,
                     axe11      LIKE axe_file.axe11,  #再衡量匯率類別
                     axe12      LIKE axe_file.axe12   #換算匯率類別
                     END RECORD,
       l_axee        RECORD
                     axee04     LIKE axee_file.axee04,
                     axee11     LIKE axee_file.axee11,  #再衡量匯率類別
                     axee12     LIKE axee_file.axee12   #換算匯率類別
                     END RECORD,
       l_axh         RECORD LIKE axh_file.*,
       l_axkk        RECORD LIKE axkk_file.*,
       l_axe06       LIKE axe_file.axe06,             #合併後財報會計科目編號
       l_axee06      LIKE axee_file.axee06,           #合併後財報會計科目編號
       l_aaa03       LIKE aaa_file.aaa03,             #原工廠本國幣別
       l_chg_aed05   LIKE aed_file.aed05,             #功能幣別借方總金額
       l_chg_aed06   LIKE aed_file.aed06,             #功能幣別貸方總金額
       l_chg_aed05_1 LIKE aed_file.aed05,             #記帳幣別借方總金額
       l_chg_aed06_1 LIKE aed_file.aed06,             #記帳幣別貸方總金額
       l_chg_aed05_a LIKE aed_file.aed05,             #記帳幣別借方總金額
       l_chg_aed06_a LIKE aed_file.aed06,             #記帳幣別貸方總金額
       l_chg_aah04   LIKE aah_file.aah04,             #功能幣別借方金額
       l_chg_aah05   LIKE aah_file.aah05,             #功能幣別貸方金額
       l_chg_aah04_1 LIKE aah_file.aah04,             #記帳幣別借方金額
       l_chg_aah05_1 LIKE aah_file.aah05,             #記帳幣別貸方金額
       l_chg_aah04_a LIKE aah_file.aah04,             #記帳幣別借方金額
       l_chg_aah05_a LIKE aah_file.aah05,             #記帳幣別貸方金額
       l_chg_axq08   LIKE axq_file.axq08,             #功能幣別借方金額
       l_chg_axq09   LIKE axq_file.axq09,             #功能幣別貸方金額
       l_chg_axq08_1 LIKE axq_file.axq08,             #記帳幣別借方金額
       l_chg_axq09_1 LIKE axq_file.axq09,             #記帳幣別貸方金額
       l_chg_axq08_a LIKE axq_file.axq08,             #記帳幣別借方金額
       l_chg_axq09_a LIKE axq_file.axq09,             #記帳幣別貸方金額
       l_chg_axh08   LIKE axh_file.axh08,             #功能幣別借方金額
       l_chg_axh09   LIKE axh_file.axh09,             #功能幣別貸方金額
       l_chg_axh08_1 LIKE axh_file.axh08,             #記帳幣別借方金額
       l_chg_axh09_1 LIKE axh_file.axh09,             #記帳幣別貸方金額
       l_chg_axh08_a LIKE axh_file.axh08,             #記帳幣別借方金額
       l_chg_axh09_a LIKE axh_file.axh09,             #記帳幣別貸方金額
       l_chg_axkk10   LIKE axkk_file.axkk10,          #功能幣別借方金額
       l_chg_axkk11   LIKE axkk_file.axkk11,          #功能幣別貸方金額
       l_chg_axkk10_1 LIKE axkk_file.axkk10,          #記帳幣別借方金額
       l_chg_axkk11_1 LIKE axkk_file.axkk11,          #記帳幣別貸方金額
       l_chg_axkk10_a LIKE axkk_file.axkk10,          #記帳幣別借方金額
       l_chg_axkk11_a LIKE axkk_file.axkk11,          #記帳幣別貸方金額
       l_n           LIKE type_file.num5,
       l_cut         LIKE type_file.num5,             #幣別取位(功能幣別)
       l_cut1        LIKE type_file.num5,             #幣別取位(記帳幣別)
       l_axz04       LIKE axz_file.axz04,             #使用TIPTOP否
       l_axz06       LIKE axz_file.axz06,             #上層公司記帳幣別
       l_axz         RECORD LIKE axz_file.*,
       l_axp08       LIKE axp_file.axp08,
       l_axp09       LIKE axp_file.axp09,
       l_axz03       LIKE axz_file.axz03,
       l_axr05       LIKE axr_file.axr05,
       l_axr08       LIKE axr_file.axr08,
       l_axr09       LIKE axr_file.axr09,
       l_aag06       LIKE aag_file.aag06
DEFINE l_aag04       LIKE aag_file.aag04
DEFINE l_bs_yy       LIKE type_file.num5
DEFINE l_bs_mm       LIKE type_file.num5
DEFINE l_aaw01      LIKE aaw_file.aaw01
DEFINE l_axr_count   LIKE type_file.num5
DEFINE l_axr13       LIKE axr_file.axr13
DEFINE l_axg18       LIKE axg_file.axg18
DEFINE l_axg19       LIKE axg_file.axg19
DEFINE l_axk16       LIKE axk_file.axk16
DEFINE l_axk17       LIKE axk_file.axk17
DEFINE l_axq05       STRING
DEFINE l_axe04       LIKE axr_file.axr07
DEFINE l_axe04_cnt   LIKE type_file.num5
DEFINE l_axa09       LIKE axa_file.axa09
DEFINE l_aah04       LIKE aah_file.aah04
DEFINE l_chg_dr      LIKE aah_file.aah04              #借方金額
DEFINE l_chg_cr      LIKE aah_file.aah05              #貸方金額
DEFINE l_fun_dr      LIKE aah_file.aah04              #借方金額
DEFINE l_fun_cr      LIKE aah_file.aah04              #借方金額
DEFINE l_acc_dr      LIKE aah_file.aah05              #貸方金額
DEFINE l_acc_cr      LIKE aah_file.aah05              #貸方金額
DEFINE l_aah04_1     LIKE aah_file.aah04
DEFINE l_aah05_1     LIKE aah_file.aah05
DEFINE l_aed05       LIKE aed_file.aed05
DEFINE l_aed06       LIKE aed_file.aed06
DEFINE l_axq08       LIKE axq_file.axq08
DEFINE l_axq09       LIKE axq_file.axq09
DEFINE l_dr          LIKE aah_file.aah04
DEFINE l_cr          LIKE aah_file.aah05
DEFINE l_axh08       LIKE axh_file.axh08
DEFINE l_axh08_1     LIKE axh_file.axh08
DEFINE l_axh08_2     LIKE axh_file.axh08
DEFINE l_axh09       LIKE axh_file.axh09
DEFINE l_axh09_1     LIKE axh_file.axh09
DEFINE l_axh09_2     LIKE axh_file.axh09
DEFINE l_axkk10      LIKE axkk_file.axkk10
DEFINE l_axkk10_1    LIKE axkk_file.axkk10
DEFINE l_axkk10_2    LIKE axkk_file.axkk10
DEFINE l_axkk11      LIKE axkk_file.axkk11
DEFINE l_axkk11_1    LIKE axkk_file.axkk11
DEFINE l_axkk11_2    LIKE axkk_file.axkk11
DEFINE l_aeii11      LIKE aeii_file.aeii11
DEFINE l_aeii12      LIKE aeii_file.aeii12
DEFINE l_aeii11_1    LIKE aeii_file.aeii11
DEFINE l_aeii11_2    LIKE aeii_file.aeii11
DEFINE l_aeii12_1    LIKE aeii_file.aeii12
DEFINE l_aeii12_2    LIKE aeii_file.aeii12
DEFINE l_mm          LIKE type_file.chr4
DEFINE l_axq_cnt     LIKE type_file.num5
DEFINE l_aah_cnt     LIKE type_file.num5
DEFINE l_aed_cnt     LIKE type_file.num5
DEFINE l_aed01       LIKE aed_file.aed01
DEFINE l_aah01       LIKE aah_file.aah01
DEFINE l_aah02       LIKE aah_file.aah02
DEFINE l_aah03       LIKE aah_file.aah03
DEFINE l_aed02       LIKE aed_file.aed02
DEFINE l_axk         RECORD LIKE axk_file.*
DEFINE l_axg         RECORD LIKE axg_file.*
DEFINE l_chg_aem11_1 LIKE aem_file.aem11
DEFINE l_chg_aem12_1 LIKE aem_file.aem12
DEFINE l_chg_aem11   LIKE aem_file.aem11
DEFINE l_chg_aem12   LIKE aem_file.aem12
DEFINE l_chg_aem11_a LIKE aem_file.aem11
DEFINE l_chg_aem12_a LIKE aem_file.aem12
DEFINE l_num         LIKE type_file.num5


    #---FUN-B70065 start--
    #外幣換算損益(aaz86),換算調整數(aaz87)
    SELECT aaz87
      INTO g_aaz87
      FROM aaz_file 
    #---FUN-B70065 end---

   CALL p007_del()    #TQC-B70069   Add

# 先產生換匯差額分錄,並寫入p007_adj_tmp()  換匯分錄寫入
   CALL p007_adj()

# 產生調整分錄
#-->ref.axf_file insert into axi_file,axj_file
   CALL p007_modi()
   CALL p007_modi_adj()

END FUNCTION

FUNCTION p007_adj()
DEFINE l_aaw02        LIKE aaw_file.aaw02   #外幣換算損益
DEFINE l_aaw04        LIKE aaw_file.aaw04   #換算調整數
DEFINE l_flag         LIKE type_file.chr1   #判斷是不是第一次進入迴圈
DEFINE l_axz08_axf10  LIKE axz_file.axz08
DEFINE l_axa09        LIKE axa_file.axa09
DEFINE l_aag04        LIKE aag_file.aag04
DEFINE l_amt_aaw05   LIKE axg_file.axg08
DEFINE l_amt_aaw06   LIKE axg_file.axg08
DEFINE l_aaw05       LIKE aaw_file.aaw05
DEFINE l_aaw06       LIKE aaw_file.aaw06
DEFINE l_amt_cnt      LIKE axg_file.axg08
DEFINE l_amt_tot      LIKE axg_file.axg08
DEFINE l_amt          LIKE axg_file.axg08
DEFINE l_axg19        LIKE axg_file.axg19
DEFINE l_axz06_axf16  LIKE axf_file.axf16
DEFINE l_cut          LIKE type_file.num5
DEFINE l_cnt          LIKE type_file.num5
DEFINE l_sql          STRING

   DROP TABLE p007_axj_tmp
   CREATE TEMP TABLE p007_axj_tmp(
      axj03   LIKE axj_file.axj03,
      axj06   LIKE axj_file.axj06,
      axj07   LIKE axj_file.axj07)

   DROP TABLE p007_adj_tmp
   CREATE TEMP TABLE p007_adj_tmp(
      axj03   LIKE axj_file.axj03,
      axj05   LIKE axj_file.axj05,
      axj06   LIKE axj_file.axj06,
      axj07   LIKE axj_file.axj07,
      axj071  LIKE axj_file.axj071)

   LET l_sql = "INSERT INTO p007_adj_tmp VALUES(?,?,?,?,?)"
   PREPARE insert_adj_prep FROM l_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:p007_adj_tmp',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

   #外幣換算損益(aaw02),換算調整數(aaw04)
   #本期損益-IS(aaw05),本期損益-BS(aaw06)
   SELECT aaw02,aaw04,aaw05,aaw06
     INTO l_aaw02,l_aaw04,l_aaw05,l_aaw06
     FROM aaw_file
    WHERE aaw00 = '0'

   SELECT axz06 INTO l_axz06_axf16
     FROM axz_file
    WHERE axz01 = g_axf.axf16

   LET l_amt_cnt = 0

   CALL s_ymtodate(tm.yy,tm.bm,tm.yy,tm.em)
   RETURNING g_bdate,g_edate
   LET g_yy=tm.yy
   LET g_mm=tm.em

   LET g_axg04 = ''
   LET g_amt = 0
   LET l_flag = "Y"

   SELECT axa09 INTO l_axa09 FROM axa_file                                     
    WHERE axa01= tm.axa01                                                      
     AND axa02= tm.axa02                                                      
     AND axa03= tm.axa03                                                      
  IF l_axa09 = 'Y' THEN  
     LET g_dbs_axz03 =  s_dbstring(g_dbs_axz03)                              
  ELSE                                                                        
     LET g_dbs_axz03 =  s_dbstring(g_dbs)                                    
  END IF                      

  INITIALIZE g_axi.* TO NULL
  INITIALIZE g_axj.* TO NULL

  #將累積換算調整數拆開依各子公司列示
                                                 
  LET g_sql =                                                                
      "SELECT axg04,SUM(axg09-axg08)",                      
      "  FROM axg_file,",cl_get_target_table(g_plant_new,'aag_file'),
      " WHERE axg00='",g_aaw01,"'",                                         
      "   AND axg01='",tm.axa01,"'",                                         
      "   AND axg02='",tm.axa02,"'",                                         
      "   AND axg17='",tm.ver,"'",                                           
      "   AND axg06='",tm.yy,"'",                                            
      "   AND aag00 ='",g_aaw01,"'",                                        
      "   AND axg05 = aag01",                                                
      "   AND aag04 != '1'",                                                 
      "   AND axg05 != '",l_aaw05,"'",                                      
      "   AND axg07 = '",tm.em,"'",
      " GROUP BY axg04",                                                     
      " ORDER BY axg04"                                                      
  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
  PREPARE p007_adj_p2 FROM g_sql                                              
  DECLARE p007_adj_c2 CURSOR FOR p007_adj_p2                                  
  LET l_cnt = 0
  FOREACH p007_adj_c2 INTO g_axg04,l_amt_aaw05                               
     IF SQLCA.sqlcode THEN                                                    
        LET g_axg04 = ' '                                                     
        LET l_amt_aaw05   = 0                                                
        CONTINUE FOREACH                                
     END IF                                                                   

    #判斷是不是第一次進入迴圈,若是的話才需做新增的動作
    IF l_flag = "Y" THEN
       CALL p007_ins_axi()
       IF g_success = 'N' THEN RETURN  END IF
       UPDATE axi_file set axi09='Y' 
        WHERE axi01=g_axi.axi01
          AND axi00=g_aaw01
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
          CALL s_errmsg('axi01',g_axi.axi01,'upd_axi',SQLCA.sqlcode,1) 
          RETURN 
       END IF
       LET l_flag = "N"
    END IF

    SELECT SUM(axg09-axg08)                                              
      INTO l_amt_aaw06                                                    
      FROM axg_file                                                        
     WHERE axg00=g_aaw01                                                  
       AND axg01=tm.axa01                                                  
       AND axg02=tm.axa02                                                  
       AND axg04=g_axg04                                                   
       AND axg17=tm.ver                                                    
       AND axg06=tm.yy                                                     
       AND axg05 =l_aaw06                                                 
       AND axg07 = tm.em                                                   

    IF cl_null(l_amt_aaw06) THEN LET l_amt_aaw06 = 0 END IF
    LET l_amt_cnt = l_amt_aaw05 - l_amt_aaw06                               

    IF l_amt_cnt <> 0 THEN
        #判斷是不是第一次進入迴圈,若是的話才需做新增的動作
        IF l_flag = "Y" THEN   
           CALL p007_ins_axi()
           IF g_success = 'N' THEN RETURN  END IF
           UPDATE axi_file set axi09='Y'
            WHERE axi01=g_axi.axi01
              AND axi00=g_aaw01
           #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
              CALL s_errmsg('axi01',g_axi.axi01,'upd_axi',SQLCA.sqlcode,1)
              RETURN
           END IF
           LET l_flag = "N"
        END IF 
    END IF
                                                                     
      LET g_axj.axj00=g_aaw01                                                  
      LET g_axj.axj01=g_axi.axi01                                               
      SELECT MAX(axj02)+1 INTO g_axj.axj02 FROM axj_file                        
       WHERE axj01=g_axj.axj01                                                  
         AND axj00=g_axj.axj00                                                  
      IF cl_null(g_axj.axj02) THEN LET g_axj.axj02 = 1 END IF                   
      LET g_axj.axj03=l_aaw06                    #科目
      LET g_axj.axj04=' '                         #摘要                         
      SELECT axz08 INTO g_axj.axj05 FROM axz_file #關系人                       
       WHERE axz01=g_axg04                                                      
                                                                                
      IF l_amt_cnt >0 THEN                                                      
         LET g_axj.axj06='2'                      #借貸別                       
         LET g_axj.axj07= l_amt_cnt               #金額                         
      ELSE                                                                      
         LET g_axj.axj06='1'                      #借貸別                       
         LET g_axj.axj07= l_amt_cnt*-1            #金額                         
      END IF                                                                    
      IF g_axj.axj07 IS NULL THEN LET g_axj.axj07=0 END IF                      
      LET g_axj.axjlegal=g_legal
      IF g_axj.axj07 != 0 THEN                                                  
         INSERT INTO axj_file VALUES (g_axj.*)                                  
      END IF                                                                    
                                                                                
      #--寫入一筆aaw04為對向科目的分錄和aaw02為一組---                          
      LET g_axj.axj00=g_aaw01                                                  
      LET g_axj.axj01=g_axi.axi01                                               
      SELECT MAX(axj02)+1 INTO g_axj.axj02 FROM axj_file                        
       WHERE axj01=g_axj.axj01
       AND axj00=g_axj.axj00
                                                                                
      IF cl_null(g_axj.axj02) THEN LET g_axj.axj02 = 1 END IF                   
                                                                                
      LET g_axj.axj03=l_aaw04                     #科目                         
      LET g_axj.axj04=' '                         #摘要                         
      SELECT axz08 INTO g_axj.axj05 FROM axz_file #關系人                       
       WHERE axz01=g_axg04

      SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_axz06_axf16
      IF cl_null(l_cut) THEN LET l_cut = 0 END IF
      LET g_axj.axj07=cl_digcut(g_axj.axj07,l_cut)

      IF l_amt_cnt >0 THEN                                                      
         LET g_axj.axj06='1'                      #借貸別                       
         LET g_axj.axj07= l_amt_cnt               #金額                         
      ELSE                                                                      
         LET g_axj.axj06='2'                      #借貸別                       
         LET g_axj.axj07= l_amt_cnt*-1            #金額                         
      END IF                                                                    
      IF g_axj.axj07 IS NULL THEN LET g_axj.axj07=0 END IF                      
      LET g_axj.axjlegal=g_legal
      IF g_axj.axj07 != 0 THEN                                                  
         INSERT INTO axj_file VALUES (g_axj.*)                               
         LET l_cnt = l_cnt + 1
      END IF                                                                    
   END FOREACH                                                                  

   IF l_cnt = 0 THEN
       DELETE FROM axi_file where axi00 = g_aaw01 AND axi01 = g_axi.axi01
       LET l_flag = 'Y'
   END IF

   IF l_amt_cnt = 0 THEN
      IF l_flag = "Y" THEN   
         CALL p007_ins_axi()
         IF g_success = 'N' THEN RETURN  END IF
         UPDATE axi_file set axi09='Y' 
          WHERE axi01=g_axi.axi01
            AND axi00=g_aaw01 
         #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
            CALL s_errmsg('axi01',g_axi.axi01,'upd_axi',SQLCA.sqlcode,1) 
            RETURN 
         END IF
         LET l_flag = "N"
      END IF  
   END IF

   LET g_sql =                                                                  
       "SELECT axg04,SUM(axg08-axg09)",                                     
       "  FROM axg_file,",cl_get_target_table(g_plant_new,'axg_file'),                     
       " WHERE axg00='",g_aaw01,"'",                                           
       "   AND axg01='",tm.axa01,"'",                                           
       "   AND axg02='",tm.axa02,"'",                                           
       "   AND axg17='",tm.ver,"'",                                             
       "   AND axg06='",tm.yy,"'",                                              
       "   AND axg07 ='",tm.em,"'",                                             
       "   AND aag00 ='",g_aaw01,"'",                                          
       "   AND axg05 = aag01",                                                  
       "   AND aag04 = '1'",                                                    
       " GROUP BY axg04",                                                       
       " ORDER BY axg04"                                                        
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   PREPARE p007_adj_p1 FROM g_sql                                               
   DECLARE p007_adj_c1 CURSOR FOR p007_adj_p1                                   
   LET l_cnt = 0
   FOREACH p007_adj_c1 INTO g_axg04,g_amt                                       
      IF SQLCA.sqlcode THEN
      LET g_axg04 = ' '                                                      
         LET g_amt   = 0                                                        
         CONTINUE FOREACH                                                       
      END IF                                                                    
      IF g_amt = 0 THEN                                                         
         CONTINUE FOREACH                                                       
      END IF                                                                    

      LET g_axj.axj00=g_aaw01
      LET g_axj.axj01=g_axi.axi01
      SELECT MAX(axj02)+1 INTO g_axj.axj02 FROM axj_file 
       WHERE axj01=g_axj.axj01
         AND axj00=g_axj.axj00
      IF cl_null(g_axj.axj02) THEN LET g_axj.axj02 = 1 END IF
      LET g_axj.axj03=l_aaw04                     #科目
      LET g_axj.axj04=' '                         #摘要
      SELECT axz08 INTO g_axj.axj05 FROM axz_file #關系人                                                                   
       WHERE axz01=g_axg04                                                                                                  
      IF g_amt >0 THEN
         LET g_axj.axj06='2'                      #借貸別
         LET g_axj.axj07=g_amt                    #金額
      ELSE
         LET g_axj.axj06='1'                      #借貸別
         LET g_axj.axj07=g_amt*-1                 #金額
      END IF
      IF g_axj.axj07 IS NULL THEN LET g_axj.axj07=0 END IF
      LET g_axj.axjlegal=g_legal
      IF g_axj.axj07 != 0 THEN
         INSERT INTO axj_file VALUES (g_axj.*)
         LET l_cnt = l_cnt + 1
         #先將資料寫TempTable裡,後續股本累換數使用
         CALL p007_adj_tmp(g_axj.*)
      END IF
   END FOREACH
   IF l_cnt = 0 THEN
       DELETE FROM axi_file where axi00 = g_aaw01 AND axi01 = g_axi.axi01
   END IF
   CALL upd_axi()
END FUNCTION 

FUNCTION p007_modi()   #產生調整分錄
DEFINE l_axk09_o    LIKE axk_file.axk09,             #期別
       l_axg07_m    LIKE axg_file.axg07,
       l_axk09_o1   LIKE axk_file.axk09,             #期別
       l_axg07_m1   LIKE axg_file.axg07,
       l_axk07_o    LIKE axk_file.axk07,             #異動碼值
       l_axk07_o1   LIKE axk_file.axk07,             #異動碼值
       l_axg07_o    LIKE axg_file.axg07,             #期別
       l_cnt        LIKE type_file.num5,
       l_sql,l_sql1 STRING,    
       i,g_no       LIKE type_file.num5  
DEFINE l_axz08      LIKE axz_file.axz08
DEFINE l_axf09_axz05      LIKE axz_file.axz05
DEFINE l_axf10_axz05      LIKE axz_file.axz05
DEFINE l_axk10_axk11_sum  LIKE axk_file.axk10
DEFINE l_i                LIKE type_file.num5
DEFINE l_aag04            LIKE aag_file.aag04
DEFINE l_axf01            STRING
DEFINE l_axf02            STRING

   #建立TempTable以便處理科目為MISC的資料
   DROP TABLE p007_tmp
   CREATE TEMP TABLE p007_tmp(
      axg06   LIKE axg_file.axg06,
      axg07   LIKE axg_file.axg07,
      axg05   LIKE axg_file.axg05,
      axg02   LIKE axg_file.axg02,
      axg04   LIKE axg_file.axg04,
      axg08   LIKE axg_file.axg08,
      axg12   LIKE axg_file.axg12,
      affil   LIKE axj_file.axj05,
      dc      LIKE axj_file.axj06,
      flag_r  LIKE type_file.chr1)   

   DELETE FROM p007_tmp
   LET l_sql = "INSERT INTO p007_tmp VALUES(?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

   LET l_sql = "INSERT INTO p007_axj_tmp VALUES(?,?,?)" 
   PREPARE insert_axj_prep FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

   LET l_sql1=
    "SELECT axa01,axa02,axa03 FROM axa_file ",
    " WHERE axa01='",tm.axa01,"'",
    " UNION ",
    "SELECT axb01,axb04,axb05 ",
    "  FROM axb_file,axa_file ",
    " WHERE axa01=axb01 AND axa02=axb02 AND axa03=axb03 ",
    "   AND axa01='",tm.axa01,"'"

   PREPARE p007_axa_p1 FROM l_sql1
	   DECLARE p007_axa_c1 CURSOR FOR p007_axa_p1

   LET g_no = 1
   FOREACH p007_axa_c1 INTO g_axa[g_no].*
      IF g_success='N' THEN                                                    
        LET g_totsuccess='N'                                                   
        LET g_success='Y'                                                      
      END IF  
      IF SQLCA.SQLCODE THEN
         LET g_showmsg=tm.axa01,"/",tm.axa02,"/",tm.axa03
         CALL s_errmsg('axa01,axa02,axa03',g_showmsg,'for_axa_c1:',STATUS,1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
      LET g_no=g_no+1
   END FOREACH
   IF g_totsuccess="N" THEN LET g_success="N" END IF
   LET g_no=g_no-1

   INITIALIZE g_axi.* TO NULL
   INITIALIZE g_axj.* TO NULL

   FOR i =1 TO g_no
     IF g_success='N' THEN                                                    
        LET g_totsuccess='N'                                                   
        LET g_success='Y'                                                      
     END IF 

#配合agli003己開放非股本資料也能設為MISC對沖
#1.先抓來源會科，如果是MISC時，則來源為axs_file，
#接著處理對沖科目，如果亦為MISC則來源為axt_file
#其它狀況可能會一對一 ，一對多，多對一，多對多，所以在程式上要配合
#如果一對多時，axf<->axt, 一對一 axf<->axf, 多對一 axs<->axf, 多對多 axs<->axt
#2.資料來源又可分為axg_file,axk_file,依axf15,axf17決定

     DECLARE p007_axf_cs1 CURSOR FOR
        SELECT *
          FROM axf_file 
          WHERE axf13=g_axa[i].axa01   #族群
           AND axf09=g_axa[i].axa02   #來源公司               
           AND axfacti='Y'            #有效的資料
         ORDER BY axf12,axf10,axf01,axf02,axf03,axf04
     FOREACH p007_axf_cs1 INTO g_axf.*
     IF g_axf.axf16 <> tm.axa02 THEN CONTINUE FOREACH END IF

     LET l_axf01 = g_axf.axf01
     LET l_axf02 = g_axf.axf02
     LET l_axf01 = l_axf01.substring(1,4)
     LET l_axf02 = l_axf02.substring(1,4)
    
     #抓出下層公司axf10在agli009中設定的關係人異動碼值--
     SELECT axz08 INTO g_axz08
       FROM axz_file
      WHERE axz01 = g_axf.axf09

     CALL p007_modi_axf_misc(l_axf01,l_axf02,g_axf.axf15,g_axf.axf17,i)
     
     END FOREACH
   END FOR

   IF g_totsuccess="N" THEN                                                                                                         
      LET g_success="N"                                                                                                             
   END IF 
END FUNCTION

FUNCTION p007_modi_adj()
DEFINE l_axj03   LIKE axj_file.axj03
DEFINE l_axj06   LIKE axj_file.axj06
DEFINE l_axj07   LIKE axj_file.axj07
DEFINE l_aag06   LIKE aag_file.aag06
DEFINE li_result LIKE type_file.num5     
DEFINE l_cnt     LIKE type_file.num5

   INITIALIZE g_axi.* TO NULL
   INITIALIZE g_axj.* TO NULL

   CALL s_ymtodate(tm.yy,tm.bm,tm.yy,tm.em)
   RETURNING g_bdate,g_edate
   LET g_yy=tm.yy 
   LET g_mm=tm.em 

    SELECT * INTO g_aac.* FROM aac_file         #讀取單據性質資料
     WHERE aac01=tm.gl AND aacacti = 'Y' AND aac11='A'
    IF SQLCA.sqlcode THEN 
       LET g_showmsg= tm.gl,"/",'Y',"/",'A'     
       CALL s_errmsg('aac01,aacacti,aac11',g_showmsg,'sel aac',SQLCA.sqlcode,0)
       RETURN 
    END IF
    LET g_axi.axi00  = g_aaw01      #帳別      
    LET g_axi.axi01  = tm.gl         #傳票編號
    LET g_axi.axi02  = g_edate       #單據日期
    LET g_axi.axi03  = g_yy          #調整年度 
    LET g_axi.axi04  = g_mm          #調整月份 
    LET g_axi.axi05  = tm.axa01      #族群編號
    LET g_axi.axi06  = tm.axa02      #上層公司編號
    LET g_axi.axi07  = tm.axa03      #上層帳別
    LET g_axi.axi08  = '2'           #來源碼
    LET g_axi.axi09  = 'N'           #換匯差額調整否    
    LET g_axi.axiconf= 'Y'           #確認碼
    LET g_axi.axiuser= g_user        #資料所有者
    LET g_axi.axigrup= g_grup        #資料所有群
    LET g_axi.axidate= g_today       #最近修改日
    LET g_axi.axi21  = tm.ver        #版本   
    #LET g_axi.axi081 = '1'   #luttb
    LET g_axi.axi081 = '7'
    LET g_axi.axilegal = g_legal 
    LET g_axi.axioriu = g_user    
    LET g_axi.axiorig = g_grup  
    LET g_axj.axjlegal=g_legal

    CALL s_auto_assign_no("agl",g_axi.axi01,g_axi.axi02,"A",
                         #"axi_file","axi01",g_dbs,"2",g_aaw01) 
                          "axi_file","axi01",g_plant,"2",g_aaw01) 
    RETURNING li_result,g_axi.axi01
    DISPLAY g_axi.axi01
    IF g_success='N' THEN 
        LET g_showmsg= tm.axa03,"/",tm.gl,"/",g_edate  
        CALL s_errmsg('axi00,axi01,axi02',g_showmsg,g_axi.axi01,'mfg-059',1)
        RETURN 
    END IF

   #--取出此上層公司的調整分錄非換匯者 ----
     DECLARE p007_axj_cs CURSOR FOR
        SELECT axj03,axj06,axj07
          FROM p007_axj_tmp
     LET l_cnt = 0
     FOREACH p007_axj_cs INTO l_axj03,l_axj06,l_axj07
        IF SQLCA.sqlcode THEN 
           LET g_showmsg= l_axj03,"/",l_axj06,"/"
           CALL s_errmsg('axj03,axj06',g_showmsg,'p007_axj_cs',SQLCA.sqlcode,1) 
           LET g_success = 'N'
           CONTINUE FOREACH 
        END IF
        LET l_cnt = l_cnt + 1

##. 取沖銷調整分錄中換匯差額否[axi09<>'Y']者的分錄
#1. 當沖銷銷調整分錄中有借方科目[axj06=1]且科目性質為損益科目[aag04='2']且餘額型態為貸餘[aag06='2']者
#   則切一筆本期損益沖銷分錄
#   D : 本期損益BS [aaw06] ==> 目的調整資產負債表上本期損益金額等於損益表上本期損益
#           C : 本期損益IS [aaw05]==>僅配合借貸平衡暫存科目
#2. 當沖銷銷調整分錄中有貸方科目[axj06=2]且科目性質為損益科目[aag04='2']且餘額型態為貸餘[aag06='2']者
#   則切一筆本期損益沖銷分錄
#   D : 本期損益IS [aaw05]==>僅配合借貸平衡暫存科目
#           C : 本期損益BS [aaw06] ==> 目的調整資產負債表上本期損益金額等於損益表上本期損益
#3. 當沖銷銷調整分錄中有借方科目[axj06=1]且科目性質為損益科目[aag04='2']且餘額型態為貸餘[aag06='1']者
#   則切一筆本期損益沖銷分錄
#   D : 本期損益BS [aaw06] ==> 目的調整資產負債表上本期損益金額等於損益表上本期損益
#           C : 本期損益IS [aaw05]==>僅配合借貸平衡暫存科目
#4. 當沖銷銷調整分錄中有貸方科目[axj06=2]且科目性質為損益科目[aag04='2']且餘額型態為貸餘[aag06='1']者
#   D : 本期損益IS [aaw05]==>僅配合借貸平衡暫存科目
#          C : 本期損益BS [aaw06] ==> 目的調整資產負債表上本期損益金額等於損益表上本期損益

      LET g_axj.axj00=g_aaw01                                                  
      LET g_axj.axj01=g_axi.axi01                                               

      CASE 
          WHEN l_axj06 = '1'
               SELECT MAX(axj02)+1 INTO g_axj.axj02 FROM axj_file                        
                WHERE axj01=g_axj.axj01                                                  
                  AND axj00=g_axj.axj00                                                  
               IF cl_null(g_axj.axj02) THEN LET g_axj.axj02 = 1 END IF                   
               LET g_axj.axj03=g_aaw06
               LET g_axj.axj04=' '                      #摘要                         
               LET g_axj.axj06='1'                      #借貸別                       
               LET g_axj.axj07= l_axj07
               IF g_axj.axj07 IS NULL THEN LET g_axj.axj07=0 END IF                      
               IF g_axj.axj07 != 0 THEN                                                  
                  INSERT INTO axj_file VALUES (g_axj.*)                                  
               END IF                                                                    

               SELECT MAX(axj02)+1 INTO g_axj.axj02 FROM axj_file                        
                WHERE axj01=g_axj.axj01                                                  
                  AND axj00=g_axj.axj00                                                  
               IF cl_null(g_axj.axj02) THEN LET g_axj.axj02 = 1 END IF                   
               LET g_axj.axj03=g_aaw05
               LET g_axj.axj04=' '                      #摘要                         
               LET g_axj.axj06='2'                      #借貸別                       
               LET g_axj.axj07= l_axj07
               IF g_axj.axj07 IS NULL THEN LET g_axj.axj07=0 END IF                      
               IF g_axj.axj07 != 0 THEN                                                  
                  INSERT INTO axj_file VALUES (g_axj.*)                                  
               END IF                                                                    
          WHEN l_axj06 = '2'
               SELECT MAX(axj02)+1 INTO g_axj.axj02 FROM axj_file                        
                WHERE axj01=g_axj.axj01                                                  
                  AND axj00=g_axj.axj00                                                  
               IF cl_null(g_axj.axj02) THEN LET g_axj.axj02 = 1 END IF                   
               LET g_axj.axj03=g_aaw05
               LET g_axj.axj04=' '                      #摘要                         
               LET g_axj.axj06='1'                      #借貸別                       
               LET g_axj.axj07= l_axj07
               IF g_axj.axj07 IS NULL THEN LET g_axj.axj07=0 END IF                      
               IF g_axj.axj07 != 0 THEN                                                  
                  INSERT INTO axj_file VALUES (g_axj.*)                                  
               END IF                                                                    

               SELECT MAX(axj02)+1 INTO g_axj.axj02 FROM axj_file                        
                WHERE axj01=g_axj.axj01                                                  
                  AND axj00=g_axj.axj00                                                  
               IF cl_null(g_axj.axj02) THEN LET g_axj.axj02 = 1 END IF                   
               LET g_axj.axj03=g_aaw06
               LET g_axj.axj04=' '                      #摘要                         
               LET g_axj.axj06='2'                      #借貸別                       
               LET g_axj.axj07= l_axj07
               IF g_axj.axj07 IS NULL THEN LET g_axj.axj07=0 END IF                      
               IF g_axj.axj07 != 0 THEN                                                  
                  INSERT INTO axj_file VALUES (g_axj.*)                                  
               END IF                                                                    
      END CASE
   END FOREACH

   #--先寫完單身再寫單頭，避免單身無值
   IF l_cnt > 0 THEN
   #FUN-B80135--add--str--
      IF g_axi.axi03 <g_year OR (g_axi.axi03=g_year AND g_axi.axi04<=g_month) THEN
         CALL cl_err('','axm-164',1)
         RETURN
      END IF
  #FUN-B80135--add—end--
       INSERT INTO axi_file VALUES(g_axi.*)
       IF SQLCA.sqlcode THEN 
          LET g_showmsg= tm.axa03,"/",tm.gl,"/",g_edate
          CALL s_errmsg('axi00,axi01,axi02 ',g_showmsg,'ins axi',SQLCA.sqlcode,1)                                     #NO.FUN-710023 
          RETURN 
       END IF
       IF NOT cl_null(g_axi.axi01) THEN CALL upd_axi() END IF   
   END IF
END FUNCTION

FUNCTION p007_set_entry() 
    CALL cl_set_comp_entry("q1,em,h1",TRUE) 
END FUNCTION

FUNCTION p007_set_no_entry() 

      CALL cl_set_comp_entry("axa06",FALSE) 

      IF tm.axa06 ="1" THEN  #月
         CALL cl_set_comp_entry("q1,h1",FALSE) 
      END IF
      IF tm.axa06 ="2" THEN  #季
         CALL cl_set_comp_entry("em,h1",FALSE) 
      END IF
      IF tm.axa06 ="3" THEN  #半年
         CALL cl_set_comp_entry("em,q1",FALSE) 
      END IF
      IF tm.axa06 ="4" THEN  #年
         CALL cl_set_comp_entry("q1,em,h1",FALSE) 
      END IF
END FUNCTION

FUNCTION p007_ins_axi()
DEFINE li_result  LIKE type_file.num5

    INITIALIZE g_axi.* TO NULL

    SELECT * INTO g_aac.* FROM aac_file         #讀取單據性質資料
     WHERE aac01=tm.gl AND aacacti = 'Y' AND aac11='A'
    IF SQLCA.sqlcode THEN 
       LET g_showmsg= tm.gl,"/",'Y',"/",'A'     
       CALL s_errmsg('aac01,aacacti,aac11',g_showmsg,'sel aac',SQLCA.sqlcode,0)
       RETURN 
    END IF
    LET g_axi.axi00  = g_aaw01      #帳別
    LET g_axi.axi01  = tm.gl         #傳票編號
    LET g_axi.axi02  = g_edate       #單據日期
    LET g_axi.axi03  = g_yy          #調整年度
    LET g_axi.axi04  = g_mm          #調整月份
    LET g_axi.axi05  = tm.axa01      #族群編號
    LET g_axi.axi06  = tm.axa02      #上層公司編號
    LET g_axi.axi07  = tm.axa03      #上層帳別
    LET g_axi.axi08  = '2'           #來源碼 (1.調整作業  2.沖銷 3.會計師調整)
    LET g_axi.axi09  = 'N'           #換匯差額調整否
    LET g_axi.axiconf= 'Y'           #確認碼
    LET g_axi.axiuser= g_user        #資料所有者
    LET g_axi.axigrup= g_grup        #資料所有群
    LET g_axi.axidate= g_today       #最近修改日
    LET g_axi.axi21  = tm.ver        #版本
    LET g_axi.axi081 = '7' 
    LET g_axi.axilegal = g_legal

    CALL s_auto_assign_no("agl",g_axi.axi01,g_axi.axi02,"A",
                          "axi_file","axi01",g_plant,"2",g_aaw01)
    RETURNING li_result,g_axi.axi01
    DISPLAY g_axi.axi01
    IF g_success='N' THEN 
        LET g_showmsg= tm.axa03,"/",tm.gl,"/",g_edate  
        CALL s_errmsg('axi00,axi01,axi02',g_showmsg,g_axi.axi01,'mfg-059',1)
        RETURN 
    END IF

    LET g_axi.axioriu = g_user
    LET g_axi.axiorig = g_grup
   
    #FUN-B80135--add--str--
    IF g_axi.axi03 <g_year OR (g_axi.axi03=g_year AND g_axi.axi04<=g_month) THEN
       CALL cl_err('','axm-164',1)
       RETURN
    END IF
  #FUN-B80135--add—end--

    INSERT INTO axi_file VALUES(g_axi.*)
    IF SQLCA.sqlcode THEN 
       LET g_showmsg= tm.axa03,"/",tm.gl,"/",g_edate
       CALL s_errmsg('axi00,axi01,axi02 ',g_showmsg,'ins axi',SQLCA.sqlcode,1)                                     #NO.FUN-710023 
       RETURN 
    END IF

END FUNCTION

FUNCTION p007_adj_tmp(p_axj)
DEFINE p_axj  RECORD LIKE axj_file.*
DEFINE l_axj  RECORD 
              axj03    VARCHAR(24),
              axj05    VARCHAR(15),               
              axj06    VARCHAR(1),
              axj07    DECIMAL(20,6),             
              axj071    DECIMAL(20,6)             
              END RECORD
DEFINE l_x    LIKE type_file.num5

   SELECT COUNT(*) INTO l_x FROM p007_adj_tmp
    WHERE axj03 = p_axj.axj03
      AND axj05 = p_axj.axj05

   LET l_axj.axj03 = p_axj.axj03
   LET l_axj.axj05 = p_axj.axj05
   LET l_axj.axj06 = ''

   IF l_x = 0 THEN
      IF p_axj.axj06 = '1' THEN
         LET l_axj.axj07 = p_axj.axj07
         LET l_axj.axj071 = 0
      ELSE
         LET l_axj.axj07 =  0
         LET l_axj.axj071 = p_axj.axj07
      END IF
      EXECUTE insert_adj_prep USING l_axj.axj03,l_axj.axj05,p_axj.axj06,l_axj.axj07,l_axj.axj071    #TQC-AA0098
   ELSE
      SELECT * INTO l_axj.*  FROM  p007_adj_tmp
       WHERE axj03 = p_axj.axj03
         AND axj05 = p_axj.axj05

      IF p_axj.axj06 = '1' THEN
         LET l_axj.axj07 = l_axj.axj07 + p_axj.axj07
      ELSE
         LET l_axj.axj071 = l_axj.axj071 + p_axj.axj07
      END IF

      UPDATE p007_adj_tmp SET axj07  =  l_axj.axj07,
                              axj071 =  l_axj.axj071,
                              axj06 = p_axj.axj06
       WHERE axj03 = p_axj.axj03
         AND axj05 = p_axj.axj05
   END IF

END FUNCTION

FUNCTION upd_axi()
DEFINE l_sum_tot    LIKE axj_file.axj07

    LET l_sum_tot=0
    SELECT SUM(axj07) INTO l_sum_tot  FROM axj_file 
     WHERE axj01=g_axi.axi01 AND axj06='1'
       AND axj00=g_aaw01
    IF cl_null(l_sum_tot) THEN LET l_sum_tot=0 END IF
    IF STATUS OR cl_null(l_sum_tot) THEN 
       RETURN
    END IF
    UPDATE axi_file SET axi11 = l_sum_tot 
     WHERE axi01=g_axi.axi01
       AND axi00=g_aaw01
    IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
       RETURN
    END IF

    LET l_sum_tot=0
    SELECT SUM(axj07) INTO l_sum_tot FROM axj_file 
     WHERE axj01=g_axi.axi01 AND axj06='2'
       AND axj00=g_aaw01
    IF cl_null(l_sum_tot) THEN LET l_sum_tot=0 END IF
    IF STATUS OR cl_null(l_sum_tot) THEN
       RETURN
    END IF
    UPDATE axi_file SET axi12 = l_sum_tot 
     WHERE axi01=g_axi.axi01
       AND axi00=g_aaw01
    IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
       RETURN
    END IF
END FUNCTION

FUNCTION p007_modi_axf_misc(p_axf01,p_axf02,p_axf15,p_axf17,i)
DEFINE p_axf01   STRING
DEFINE p_axf02   STRING
DEFINE p_axf17   LIKE axf_file.axf17
DEFINE p_axf15   LIKE axf_file.axf15,
       l_cnt        LIKE type_file.num5,
       l_sql,l_sql1 STRING,  
       i,g_no       LIKE type_file.num5
DEFINE l_axz08      LIKE axz_file.axz08
DEFINE l_axf09_axz05      LIKE axz_file.axz05
DEFINE l_axf10_axz05      LIKE axz_file.axz05
DEFINE l_axk10_axk11_sum  LIKE axk_file.axk10
DEFINE l_i                LIKE type_file.num5
DEFINE l_aag04            LIKE aag_file.aag04
DEFINE l_axz08_axf10      LIKE axz_file.axz08
DEFINE l_axz03_axf09      LIKE axz_file.axz03
DEFINE l_axz03_axf10      LIKE axz_file.axz03
DEFINE g_dbs_axf09        LIKE azp_file.azp03
DEFINE g_dbs_axf10        LIKE azp_file.azp03
DEFINE l_axb02            LIKE axb_file.axb02
DEFINE l_low_axf09        LIKE type_file.num5
DEFINE l_up_axf09         LIKE type_file.num5
DEFINE l_low_axf10        LIKE type_file.num5
DEFINE l_up_axf10         LIKE type_file.num5
DEFINE l_axa02_axf09      LIKE axa_file.axa02
DEFINE l_axa02_axf10      LIKE axa_file.axa02
DEFINE l_axz06_axf16      LIKE axz_file.axz06
DEFINE l_axj03            LIKE axj_file.axj03
DEFINE l_axj05            LIKE axj_file.axj05
DEFINE l_axj06            LIKE axj_file.axj06
DEFINE l_axj07            LIKE axj_file.axj07
DEFINE l_axj07_d          LIKE axj_file.axj07
DEFINE l_axj07_c          LIKE axj_file.axj07
DEFINE l_axt03            LIKE axt_file.axt03
DEFINE l_axf03            LIKE axf_file.axf03    #FUN-B50001 luttb

     DELETE FROM p007_tmp

     #抓出上層公司axf10在agli009中設定帳別
     SELECT axz05 INTO g_axf09_axz05
       FROM axz_file
      WHERE axz01 = g_axf.axf09
      SELECT axz05 INTO g_axf10_axz05
       FROM axz_file
      WHERE axz01 = g_axf.axf10

     #抓出下層公司axf10在agli009中設定的關係人異動碼值--
     SELECT axz08 INTO g_axz08
       FROM axz_file
      WHERE axz01 = g_axf.axf09
      SELECT axz08 INTO g_axz08_axf10
       FROM axz_file WHERE axz01 = g_axf.axf10

     #因系統目前在處理沖銷分錄時己經不再限於只有上下層公司的關係才能沖銷
     #之前的應用方式為tm.axa02上層公司輸入之後抓取的axg,axk資料都是自己本身
     #或是下層資料,但側流時不一定合併主體和來源/目的公司為同一顆tree，
     #SQL抓資料時分為以下狀況 ：
     #A.來源(目的)公司=合併主體：(順流)
     #  A1.axg02 = 自己, axg04 = 自己
     #  A2.axg02 = 不用加入此條件, axg04 = 自己
     #B.來源(目的)公司 <> 合併主體：(側流或逆流)
     #  IF 屬於上層公司
     #    1.最上層公司：條件=>axg02 = 自己, axg04 = 自己
     #    2.中間層(有上層也有下層),條件=> axg02 = 自己的上層公司,axg04 = 自己 
     #  ELSE
     #    1.最下層公司: 條件=>axg02 = 不用加入此條件, axg04 = 自己
     #  END IF
  
     #--先判斷g_axf.axf09(來源)/g_axf.axf10(目的)各自是否為上層公司--
     LET g_cnt_axf09 = 0
     SELECT COUNT(*) INTO g_cnt_axf09 
       FROM axa_file
      WHERE axa01 = g_axf.axf13   #群組
        AND axa02 = g_axf.axf09   #上層公司 

     LET g_cnt_axf10 = 0
     SELECT COUNT(*) INTO g_cnt_axf10 
       FROM axa_file
      WHERE axa01 = g_axf.axf13   #群組
        AND axa02 = g_axf.axf10   #上層公司

     IF g_cnt_axf09 > 0 THEN    #代表為上層公司
        #判斷是否存在下層
        SELECT COUNT(*) INTO g_low_axf09
          FROM axb_file
         WHERE axb01 = tm.axa01
           AND axb04 = g_axf.axf09
        IF g_low_axf09 > 0 THEN
             #--如果l_up_axf09 = 0 代表是最下層
             SELECT COUNT(*) INTO g_up_axf09
               FROM axa_file 
              WHERE axa01 = tm.axa01
                AND axa02 = g_axf.axf09
            IF g_up_axf09 <> 0 THEN
                SELECT axb02 INTO g_axa02_axf09
                  FROM axb_file
                 WHERE axb01 = tm.axa01
                   AND axb04 = g_axf.axf09
                #--如果g_up_axf09 = 0 代表是最下層
                SELECT COUNT(*) INTO g_up_axf09
                  FROM axa_file 
                 WHERE axa01 = tm.axa01
                   AND axa02 = g_axf.axf09
             END IF
         END IF
     ELSE
         SELECT axb02 INTO g_axa02_axf09
           FROM axb_file
          WHERE axb01 = tm.axa01
            AND axb04 = g_axf.axf09
     END IF   

     IF g_cnt_axf10 > 0 THEN   #代表為上層公司
         #判斷是否存在下層
         SELECT COUNT(*) INTO g_low_axf10
           FROM axb_file
          WHERE axb01 = tm.axa01
            AND axb04 = g_axf.axf10
         IF g_low_axf10 > 0 THEN
             #--如果l_up_axf10 = 0 代表是最下層
             SELECT COUNT(*) INTO g_up_axf10
               FROM axa_file 
              WHERE axa01 = tm.axa01
                AND axa02 = g_axf.axf10
            IF g_up_axf10 <> 0 THEN
                SELECT axb02 INTO g_axa02_axf10
                  FROM axb_file
                 WHERE axb01 = tm.axa01
                   AND axb04 = g_axf.axf10
            END IF
         END IF
     ELSE
         SELECT axb02 INTO g_axa02_axf10
           FROM axb_file
          WHERE axb01 = tm.axa01
            AND axb04 = g_axf.axf10
     END IF

     #合併帳別取法： 
     #是上層公司-->判斷是否做獨立合併會科
     #IF 'Y' -->則為目前公司的合併帳別
     #IF 'N' -->則為當下營運中心合併帳別
     #不是上層公司-->判斷是否做獨立合併會科
     #IF 'Y' -->則為目前公司的上層公司的合併帳別
     #IF 'N' -->則為當下營運中心的合併帳別
     
     IF g_cnt_axf09 > 0 THEN   #為上層公司
         SELECT axa09 INTO g_axa09_axf09
           FROM axa_file 
          WHERE axa01 = tm.axa01
            AND axa02 = g_axf.axf09
         SELECT axz03 INTO l_axz03_axf09 
           FROM axz_file 
          WHERE axz01 = g_axf.axf09
         SELECT azp03 INTO g_dbs_axf09 FROM azp_file
          WHERE azp01 = l_axz03_axf09
         IF g_axa09_axf09 = 'Y' THEN     #來源公司合併帳別
             LET g_dbs_axf09 = s_dbstring(g_dbs_axf09)
         ELSE
             LET g_dbs_axf09 = s_dbstring(g_dbs)
         END IF
     ELSE    #為下層公司時找自己的媽媽的公司是哪個DB取aaw01
         SELECT axb02 INTO l_axb02
           FROM axb_file 
          WHERE axb01 = tm.axa01
            AND axb04 = g_axf.axf09
         SELECT axa09,axa02 INTO g_axa09_axf09,g_axa02_axf09
           FROM axa_file 
          WHERE axa01 = tm.axa01
            AND axa02 = l_axb02
         SELECT axz03 INTO l_axz03_axf09 
           FROM axz_file 
          WHERE axz01 = l_axb02
         SELECT azp03 INTO g_dbs_axf09 FROM azp_file
          WHERE azp01 = l_axz03_axf09
         IF g_axa09_axf09 = 'Y' THEN     #來源公司合併帳別
             LET g_dbs_axf09 = s_dbstring(g_dbs_axf09)
         ELSE
             LET g_dbs_axf09 = s_dbstring(g_dbs)
         END IF
     END IF        
     CALL s_aaz641_dbs(tm.axa01,g_axf.axf09) RETURNING g_dbs_axz03
     CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaw01_axf09
     IF g_cnt_axf10 > 0 THEN   #為上層公司
         SELECT axa09 INTO g_axa09_axf10
           FROM axa_file 
          WHERE axa01 = tm.axa01
            AND axa02 = g_axf.axf10
         SELECT axz03 INTO l_axz03_axf10 
           FROM axz_file 
          WHERE axz01 = g_axf.axf10
         SELECT azp03 INTO g_dbs_axf10 FROM azp_file
          WHERE azp01 = l_axz03_axf10
         IF g_axa09_axf10 = 'Y' THEN     #來源公司合併帳別
             LET g_dbs_axf10 = s_dbstring(g_dbs_axf10)
         ELSE
             LET g_dbs_axf10 = s_dbstring(g_dbs)
         END IF
     ELSE    #為下層公司時找自己的媽媽的公司是哪個DB取aaw01
         SELECT axb02 INTO l_axb02
           FROM axb_file 
          WHERE axb01 = tm.axa01
            AND axb04 = g_axf.axf10
         SELECT axa09 INTO g_axa09_axf10
           FROM axa_file 
          WHERE axa01 = tm.axa01
            AND axa02 = l_axb02
         SELECT axz03 INTO l_axz03_axf10 
           FROM axz_file 
          WHERE axz01 = l_axb02
         SELECT azp03 INTO g_dbs_axf10 FROM azp_file
          WHERE azp01 = l_axz03_axf10
         IF g_axa09_axf10 = 'Y' THEN     #來源公司合併帳別
             LET g_dbs_axf10 = s_dbstring(g_dbs_axf10)
         ELSE
             LET g_dbs_axf10 = s_dbstring(g_dbs)
         END IF
     END IF        
     CALL s_aaz641_dbs(tm.axa01,g_axf.axf10) RETURNING g_dbs_axz03
     CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaw01_axf10

     #取出來源及目的公司各自的記帳幣別供後續沖銷時轉換幣別匯率使用
     SELECT axz06 INTO g_axz06_axf09
       FROM axz_file
      WHERE axz01 = g_axf.axf09   #來源公司記帳幣別
     SELECT axz06 INTO g_axz06_axf10
       FROM axz_file
      WHERE axz01 = g_axf.axf10   #目的公司記帳幣別

     #--#資料來源為axg_file---start----
     IF p_axf15 = '1' THEN        
         LET l_sql =" SELECT 'A','1',axg06,axg07,axg05,axg02,axg04,(axg08-axg09),",
                    "         axg12,'",g_axz08_axf10,"','2','N','' "
         LET l_sql = l_sql CLIPPED,
                    "   FROM axg_file ",
                    "  WHERE axg01 ='",g_axa[i].axa01,"' ",   #群組
                    "     AND axg00 ='",g_aaw01_axf09,"' ",  #合併帳別
                    "    AND axg04 ='",g_axf.axf09,"' ",      #來源公司
                    "    AND axg041='",g_axf09_axz05,"' ",    #來源帳別
                    "    AND axg06 = ",tm.yy,                 #年度
                    "    AND axg07 = '",tm.em,"'"             #只抓截止期別的金額
                    #A.來源公司=合併主體：(順流)
                    #  來源:axg02 = 自己(axf09), axg04 = 自己(axf09)
                    #  目的:axg02 = 不用加入此條件, axg04 = 自己(axf10)
                    #B.來源公司 <> 合併主體：(側流或逆流)
                    #  IF 來源屬於上層公司(g_cnt_axf09 > 0)
                    #    1.最上層公司：條件=>axg02 = 自己(axf09), axg04 = 自己(axf09)
                    #    2.中間層(有上層也有下層),
                    #       a.股本:條件=> axg02 = 自己的上層公司(l_axa_axf09),axg04 = 自己(axf09) 
                    #       b.關係人交易:條件=>axg02 = 自己(axf09),axg04 = 自己(axf09)
                    #  ELSE
                    #    1.最下層公司: 條件=>axg02 = 不用加入此條件, axg04 = 自己(axf09)
                    #  END IF
                    #FUN-B50001--luttb--mark--str--
                    #IF g_axf.axf09 = g_axf.axf16 THEN
                    #    IF g_axf.axf14 = 'Y' THEN
                    #        LET l_sql = l_sql CLIPPED,
                    #            "    AND axg02 = '",g_axa02_axf10,"'"
                    #    ELSE
                    #        LET l_sql = l_sql CLIPPED,
                    #        "    AND axg02 = '",g_axf.axf09,"'" 
                    #    END IF
                    #ELSE
                    #    IF g_cnt_axf09 > 0 THEN
                    #        IF g_low_axf09 = 0 THEN #最上層
                    #            LET l_sql = l_sql CLIPPED,
                    #                "    AND axg02 = '",g_axf.axf09,"'" 
                    #        ELSE
                    #            IF g_axf.axf14 = 'Y' THEN
                    #                LET l_sql = l_sql CLIPPED,
                    #                    "    AND axg02 = '",g_axa02_axf09,"'"
                    #            ELSE
                    #                LET l_sql = l_sql CLIPPED,
                    #                    "    AND axg02 = '",g_axf.axf09,"'"
                    #            END IF 
                    #        END IF
                    #    ELSE
                    #        LET l_sql = l_sql CLIPPED,
                    #        "    AND axg02 = '",g_axa02_axf09,"'"
                    #    END IF  
                    #END IF
                    #FUN-B50001--mark--end
#axf15 = '2' 來源科目檔案資料來源:axk_file
     ELSE
         LET l_sql =" SELECT 'A','2',axk08,axk09,axk05,axk02,axk04,(axk10-axk11), ",
                    "        axk14,'",g_axz08_axf10,"','2','N',axk07 ",
                    "   FROM axk_file ",
                    "  WHERE axk01 ='",g_axa[i].axa01,"' ",    #群組
                    "    AND axk00 ='",g_aaw01_axf09,"' ",   
                    "    AND axk04 ='",g_axf.axf09,"' ",       #來源公司
                    "    AND axk041='",g_axf09_axz05,"' ",     #來源帳別
                    "    AND axk08 = ",tm.yy,                  #年度
                    "    AND axk07 = '",g_axz08_axf10 ,"'",
                    "    AND axk09 = '",tm.em,"'"           
         #A.來源公司=合併主體：(順流)
         #  來源:axg02 = 自己(axf09), axg04 = 自己(axf09)
         #  目的:axg02 = 不用加入此條件, axg04 = 自己(axf10)
         #B.來源公司 <> 合併主體：(側流或逆流)
         #  IF 來源屬於上層公司(g_cnt_axf09 > 0)
         #    1.最上層公司：條件=>axg02 = 自己(axf09), axg04 = 自己(axf09)
         #    2.中間層(有上層也有下層):
         #       a.股本:條件=> axg02 = 自己的上層公司(l_axa_axf09),axg04 = 自己(axf09) 
         #       b.關係人交易:條件=>axg02 = 自己(axf09),axg04 = 自己(axf09)
         #  ELSE
         #    1.最下層公司: 條件=>axg02 = 不用加入此條件, axg04 = 自己(axf09)
         #  END IF
        #FUN-B50001--mark--str--luttb
        #IF g_axf.axf09 = g_axf.axf16 THEN
        #    IF g_axf.axf14 = 'Y' THEN
        #        LET l_sql = l_sql CLIPPED,
        #        "    AND axk02 = '",g_axa02_axf09,"'"
        #    ELSE
        #        LET l_sql = l_sql CLIPPED,
        #        "    AND axk02 = '",g_axf.axf09,"'" 
        #    END IF
        #ELSE
        #    IF g_cnt_axf09 > 0 THEN
        #         IF g_low_axf09 = 0 THEN #最上層
        #            LET l_sql = l_sql CLIPPED,
        #                "    AND axk02 = '",g_axf.axf09,"'" 
        #        ELSE
        #            IF g_axf.axf14 = 'Y' THEN     
        #                LET l_sql = l_sql CLIPPED,
        #                    "    AND axk02 = '",g_axa02_axf09,"'"
        #            ELSE                         
        #                LET l_sql = l_sql CLIPPED, 
        #                    "    AND axk02 = '",g_axf.axf09,"'"   
        #            END IF                                       
        #        END IF
        #    ELSE
        #         LET l_sql = l_sql CLIPPED,
        #         "    AND axk02 = '",g_axa02_axf09,"'"
        #    END IF  
        #END IF
        #FUN-B50001--mark--end
     END IF

     IF p_axf15 = '1' THEN  #判斷來源檔是否為單一科目或MISC--
         CASE 
           WHEN p_axf01 = 'MISC' 
             LET l_sql = l_sql CLIPPED,
             "    AND axg05 IN (SELECT DISTINCT axs03 FROM axs_file ",
             "                   WHERE axs00 = '",g_aaw01_axf09,"'",   
             "                     AND axs01 = '",g_axf.axf01,"'",
             "                     AND axs09 = '",g_axf.axf09,"'",
             "                     AND axs10 = '",g_axf.axf10,"'",
             "                     AND axs12 = '",g_aaw01_axf10,"'",  
             "                     AND axs13 = '",g_axf.axf13,"')" 
           WHEN p_axf01 != 'MISC'
             LET l_sql = l_sql CLIPPED,
             "    AND axg05 = '",g_axf.axf01,"'"
         END CASE
     ELSE   #axf15 = '2'
         CASE WHEN p_axf01 = 'MISC' 
               LET l_sql = l_sql CLIPPED,
               "    AND axk05 IN (SELECT DISTINCT axs03 FROM axs_file ",
               "                   WHERE axs00 = '",g_aaw01_axf09,"'",  
               "                     AND axs01 = '",g_axf.axf01,"'",
               "                     AND axs09 = '",g_axf.axf09,"'",
               "                     AND axs10 = '",g_axf.axf10,"'",
               "                     AND axs12 = '",g_aaw01_axf10,"'",  
               "                     AND axs13 = '",g_axf.axf13,"')"  
              WHEN p_axf01 != 'MISC'
                LET l_sql = l_sql CLIPPED,
                "    AND axk05 = '",g_axf.axf01,"'"
         END CASE
     END IF

     IF p_axf17 = '1' THEN    #目的檔案資料來源 axf17 = '1'-->axg_file
         LET l_sql = l_sql CLIPPED,   
         "  UNION ",
         " SELECT 'B','1',axg06,axg07,axg05,axg02,axg04,(axg08-axg09)*-1,",
         "        axg12,'",g_axz08,"','1','N','' ",   
         "   FROM axg_file ",
         "  WHERE axg01 ='",g_axa[i].axa01,"' ",
         "    AND axg00 ='",g_aaw01_axf10,"' ",               
         "    AND axg04 ='",g_axf.axf10,"' ",                   #對沖公司
         "    AND axg041='",g_axf10_axz05,"' ",                 #對沖帳別  
         "    AND axg06 = ",tm.yy,
         "    AND axg07 = '",tm.em,"'"                         
         CASE 
           WHEN p_axf02 = 'MISC' 
             LET l_sql = l_sql CLIPPED,
             "    AND axg05 IN (SELECT DISTINCT axt03 FROM axt_file ",
             "                   WHERE axt00 = '",g_aaw01_axf09,"'", 
             "                     AND axt01 = '",g_axf.axf02,"'",
             "                     AND axt09 = '",g_axf.axf09,"'",
             "                     AND axt10 = '",g_axf.axf10,"'",
             "                     AND axt12 = '",g_aaw01_axf10,"'",  
             "                     AND axt13 = '",g_axf.axf13,"'",  
             "                     AND axt04 != 'Y') "  #是否依據公式設定
           WHEN p_axf02 != 'MISC'
             LET l_sql = l_sql CLIPPED,
             "    AND axg05 = '",g_axf.axf02,"'"
         END CASE

         #A.來源公司=合併主體：(順流)
         #  目的:axg02 = 自己的上層公司(g_axa02_axf10), axg04 = 自己
         #B.來源公司 <> 合併主體：(側流或逆流)
         #  IF 目的屬於上層公司
         #    1.最上層公司：條件=>axg02 = 自己(axf10), axg04 = 自己(axf10)
         #    2.中間層(有上層也有下層):
         #       a.股本:條件=> axg02 = 自己的上層公司(l_axa_axf10),axg04 = 自己(axf10) 
         #       b.關係人交易:條件=>axg02 = 自己(axf10),axg04 = 自己(axf10)
         #  ELSE
         #    1.最下層公司: 條件=>axg02 = 不用加入此條件, axg04 = 自己(axf10)
         #  END IF
        #FUN-B50001--mark-str--
        #IF g_cnt_axf10 > 0 THEN
        #    IF g_low_axf10 = 0 THEN #最上層
        #        LET l_sql = l_sql CLIPPED,
        #            "    AND axg02 = '",g_axf.axf10,"'"
        #    ELSE
        #        IF g_up_axf10 > 0 THEN    #大於0代表不是最下層
        #            IF g_axf.axf14 = 'Y' THEN             
        #                LET l_sql = l_sql CLIPPED,
        #                    "    AND axg02 = '",g_axa02_axf10,"'"
        #            ELSE                                 
        #                LET l_sql = l_sql CLIPPED,      
        #                    "    AND axg02 = '",g_axf.axf10,"'" 
        #            END IF                                      
        #        END IF                
        #    END IF
        #ELSE
        #    LET l_sql = l_sql CLIPPED,
        #    "    AND axg02 = '",g_axa02_axf10,"'"
        #END IF
        #FUN-B50001--mark--end
     ELSE                             #axf17 = '2' -->axk_file        
         LET l_sql = l_sql CLIPPED,       
         "  UNION ",
         " SELECT 'B','2',axk08,axk09,axk05,axk02,axk04,(axk10-axk11)*-1, ",
         "        axk14,'",g_axz08,"','1','N',axk07 ",                  
         "   FROM axk_file ",
         "  WHERE axk01 ='",g_axa[i].axa01,"' ",
         "    AND axk00 ='",g_aaw01_axf10,"' ",   
         "    AND axk04 ='",g_axf.axf10,"' ",      #對沖公司
         "    AND axk041='",g_axf10_axz05,"' ",    #對沖帳別  
         "    AND axk08 = ",tm.yy,
         "    AND axk07 = '",g_axz08,"'",         
         "    AND axk09 = '",tm.em,"'"
         CASE 
           WHEN p_axf02 = 'MISC' 
             LET l_sql = l_sql CLIPPED,
             "    AND axk05 IN (SELECT DISTINCT axt03 FROM axt_file ",
             "                   WHERE axt00 = '",g_aaw01_axf09,"'",   
             "                     AND axt01 = '",g_axf.axf02,"'",
             "                     AND axt09 = '",g_axf.axf09,"'",
             "                     AND axt10 = '",g_axf.axf10,"'",
             "                     AND axt12 = '",g_aaw01_axf10,"'",  
             "                     AND axt13 = '",g_axf.axf13,"'",
             "                     AND axt04 != 'Y') "    #是否依據公式設定
           WHEN p_axf02 != 'MISC' 
             LET l_sql = l_sql CLIPPED,
             "    AND axk05 = '",g_axf.axf02,"'"   
         END CASE
         #A.來源公司=合併主體：(順流)
         #  目的:axg02 = 不用加入此條件, axg04 = 自己
         #B.來源公司 <> 合併主體：(側流或逆流)
         #  IF 目的屬於上層公司
         #    1.最上層公司：條件=>axg02 = 自己(axf10), axg04 = 自己(axf10)
         #    2.中間層(有上層也有下層):
         #       a.股本:條件=> axg02 = 自己的上層公司(l_axa_axf10),axg04 = 自己(axf10) 
         #       b.關係人交易:條件=>axg02 = 自己(axf10),axg04 = 自己(axf10)
         #  ELSE
         #    1.最下層公司: 條件=>axg02 = 不用加入此條件, axg04 = 自己(axf10)
         #  END IF
        #FUN-B50001--mark--str--luttb
        #IF g_cnt_axf10 > 0 THEN
        #    IF g_low_axf10 = 0 THEN #最上層
        #        LET l_sql = l_sql CLIPPED,
        #            "    AND axk02 = '",g_axf.axf10,"'"
        #    ELSE
        #        IF g_up_axf10 > 0 THEN
        #            IF g_axf.axf14 = 'Y' THEN 
        #                LET l_sql = l_sql CLIPPED,
        #                    "    AND axk02 = '",g_axa02_axf10,"'"
        #            ELSE                   
        #                LET l_sql = l_sql CLIPPED,                
        #                    "    AND axk02 = '",g_axf.axf10,"'"  
        #            END IF                                      
        #        END IF   
        #    END IF
        #ELSE
        #    LET l_sql = l_sql CLIPPED,
        #       "    AND axk02 = '",g_axa02_axf10,"'"
        #END IF
        #FUN-B50001--mark--end
     END IF
     PREPARE p007_axg_misc_p1 FROM l_sql
     IF STATUS THEN 
        LET g_showmsg=g_axa[i].axa01,"/",g_axa[i].axa02,"/",g_axa[i].axa03,"/",tm.yy                                  
        CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'prepare:6',STATUS,1)  
        LET g_success = 'N'  
     END IF 
     DECLARE p007_axg_misc_c1 CURSOR FOR p007_axg_misc_p1
     
     FOREACH p007_axg_misc_c1 INTO g_type,g_flag,g_axg.axg06,g_axg.axg07,g_axg.axg05,
                              g_axg.axg02,g_axg.axg04,g_axg.axg08,
                              g_axg.axg12,
                              g_affil,g_dc,g_flag_r,g_axk07
       IF SQLCA.sqlcode THEN 
          LET g_showmsg=g_axa[i].axa01,"/",g_axa[i].axa01,"/",g_axa[i].axa01,"/",tm.yy
          CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'p007_axg_misc_1',SQLCA.sqlcode,1) 
          LET g_success = 'N' 
          CONTINUE FOREACH  
       END IF
   
       IF g_axg.axg08=0 THEN CONTINUE FOREACH END IF

       #---FUN-A90026 start--寫入temp table之前先判斷幣別是否同於合併主體
       #不相同時如果為損益類科目且axa05 = '1'要取子公司科餘金額:記帳-->功能-->合併主體幣別)
       SELECT axz06 INTO l_axz06_axf16 
         FROM axz_file
        WHERE axz01 = g_axf.axf16   #合併主體幣別
       IF g_axg.axg12 != l_axz06_axf16 THEN 
           SELECT aag04 INTO l_aag04
            FROM aag_file
            WHERE aag00=g_aaw01
              AND aag01=g_axg.axg05
           #依科目性質來判斷取"現時"或"平均"匯率
           IF l_aag04 = '1' THEN   
               CALL p007_getrate('1',tm.yy,tm.em,
                                 g_axg.axg12,l_axz06_axf16)  
               RETURNING l_rate
               LET g_axg.axg08 = g_axg.axg08  * l_rate
           ELSE 
               IF g_axa05 <> '1' THEN
                   CALL p007_getrate('3',tm.yy,tm.em,
                                     g_axg.axg12,l_axz06_axf16)
                   RETURNING l_rate
                   IF cl_null(l_rate) THEN LET l_rate = 1 END IF
                   LET g_axg.axg08 = g_axg.axg08  * l_rate
               ELSE
                   IF g_type = 'A' THEN
                       IF g_cnt_axf09 > 0 THEN
                           CALL p007_ins_axj1_chg1(g_type,g_flag,l_axz06_axf16) RETURNING g_axg.axg08
                       ELSE
                           #損益科目-取下層公司記帳金額期別計算各月異動額轉換至上層公司合併金額 , 再轉換至合併個體金額
                           #來源或目的/aej_file or aek_file/合併主體幣別
                           CALL p007_ins_axj1_chg(g_type,g_flag,l_axz06_axf16) RETURNING g_axg.axg08
                       END IF
                   ELSE
                       IF g_cnt_axf10 > 0 THEN    #大於0代表不是最下層,資料來源->axkk_file or axh_file  
                           CALL p007_ins_axj1_chg1(g_type,g_flag,l_axz06_axf16) RETURNING g_axg.axg08
                       ELSE
                           #損益科目-取下層公司記帳金額期別計算各月異動額轉換至上層公司合併金額 , 再轉換至合併個體金額
                           #來源或目的/aej_file or aek_file/合併主體幣別
                           CALL p007_ins_axj1_chg(g_type,g_flag,l_axz06_axf16) RETURNING g_axg.axg08
                       END IF
                   END IF
               END IF
           END IF
       END IF

       #先將資料寫進TempTable裡 
       EXECUTE insert_prep USING g_axg.axg06,g_axg.axg07,g_axg.axg05,
                                 g_axg.axg02,g_axg.axg04,g_axg.axg08,
                                 g_axg.axg12,
                                 g_affil,g_dc,g_flag_r
     END FOREACH

     IF p_axf02 = 'MISC' THEN
         IF p_axf17 = '1' THEN
             #貸 子公司 少數股權,少數股權淨利
             #依據公式設定(對沖科目中axt04=Y)
             DECLARE p007_axt_cs CURSOR FOR
                SELECT DISTINCT axt03,axt04,axt05 FROM axt_file
                 WHERE axt00 = g_aaw01_axf09
                   AND axt01 = g_axf.axf02
                   AND axt09 = g_axf.axf09
                   AND axt10 = g_axf.axf10
                   AND axt12 =  g_aaw01_axf10
                   AND axt04 = 'Y'             #是否依據公式設定]
                   AND axt13 = g_axf.axf13
             FOREACH p007_axt_cs INTO g_axu03
                      LET l_sql =
                      " SELECT axg06,axg07,axg05,axg02,axg04,(axg08-axg09),",
                      "        axg12,'",g_axz08_axf10,"','2','Y' "
                   LET l_sql = l_sql CLIPPED,
                   "   FROM axg_file ",
                   "  WHERE axg01 ='",g_axa[i].axa01,"' ",
                   "    AND axg00 ='",g_aaw01_axf10,"' ",
                   "    AND axg04 ='",g_axf.axf10,"' ",   #對沖公司
                   "    AND axg041='",g_axf10_axz05,"' ", #對沖帳別
                   "    AND axg06 = ",tm.yy,
                   "    AND axg07 = '",tm.em,"'"
                       IF g_cnt_axf10 > 0 THEN
                           IF g_low_axf10 = 0 THEN #最上層
                               LET l_sql = l_sql CLIPPED,
                                   "    AND axg02 = '",g_axf.axf10,"'"
                           ELSE
                               IF g_up_axf10 > 0 THEN
                                   LET l_sql = l_sql CLIPPED,
                                       "    AND axg02 = '",g_axa02_axf10,"'"
                               END IF
                          END IF
                       ELSE
                           LET l_sql = l_sql CLIPPED,
                           "    AND axg02 = '",g_axa02_axf10,"'"
                       END IF
                   LET l_sql = l_sql CLIPPED,
                           "  UNION ",
                           " SELECT axg06,axg07,axg05,axg02,axg04,(axg13-axg14)*-1,",
                           "        '",g_axz06_axf10,"','",g_axz08_axf10,"','2','Y' "
                   LET l_sql = l_sql CLIPPED,    
                   "   FROM axg_file ",
                   "  WHERE axg01 ='",g_axa[i].axa01,"' ",
                   "    AND axg00 ='",g_aaw01_axf10,"' ",
                   "    AND axg04 ='",g_axf.axf10,"' ",   #對沖公司
                   "    AND axg041='",g_axf10_axz05,"' ", #對沖帳別
                   "    AND axg06 = ",tm.yy,
                   "    AND axg07 = '",tm.em,"'",
                   "    AND axg05 IN (SELECT DISTINCT axu04 FROM axu_file ",
                   "                   WHERE axu00 = '",g_aaw01_axf09,"'",
                   "                     AND axu01 = '",g_axf.axf02,"'",
                   "                     AND axu09 = '",g_axf.axf09,"'",
                   "                     AND axu10 = '",g_axf.axf10,"'",
                   "                     AND axu12 = '",g_aaw01_axf10,"'",
                   "                     AND axu13 = '",g_axf.axf13,"'",
                   "                     AND axu05 = '-'",
                   "                     AND axu03 = '",g_axu03,"')"
                   #FUN-B50001--mark--str--
                   #   IF g_cnt_axf10 > 0 THEN
                   #       IF g_low_axf10 = 0 THEN #最上層
                   #           LET l_sql = l_sql CLIPPED,
                   #               "    AND axg02 = '",g_axf.axf10,"'" ,
                   #               "   ORDER BY axg06,axg07,axg05,axg02,axg04 "
                   #       ELSE
                   #           IF g_up_axf10 > 0 THEN
                   #               LET l_sql = l_sql CLIPPED,
                   #                   " AND axg02 = '",g_axa02_axf10,"'",
                   #                   " ORDER BY axg06,axg07,axg05,axg02,axg04 "
                   #           END IF
                   #      END IF
                   #   ELSE
                   #       LET l_sql = l_sql CLIPPED,
                   #       "    AND axg02 = '",g_axa02_axf10,"'",
                   #       "   ORDER BY axg06,axg07,axg05,axg02,axg04 "
                   #   END IF
                   #FUN-B50001--mark--end
                   PREPARE p007_misc_p2 FROM l_sql
                   IF STATUS THEN 
                      LET g_showmsg=g_axa[i].axa01,"/",g_axa[i].axa02,"/",g_axa[i].axa03,"/",tm.yy
                      CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'prepare:7',STATUS,1)  LET g_success = 'N' END IF
                   DECLARE p007_misc_c2 CURSOR FOR p007_misc_p2
                   FOREACH p007_misc_c2 INTO g_axg.axg06,g_axg.axg07,g_axg.axg05,
                                             g_axg.axg02,g_axg.axg04,g_axg.axg08,
                                             g_axg.axg12,
                                             g_affil,g_dc,g_flag_r
                      IF SQLCA.sqlcode THEN 
                         LET g_showmsg=g_axa[i].axa01,"/",g_axa[i].axa01,"/",g_axa[i].axa01,"/",tm.yy
                         CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'p007_misc_c2',SQLCA.sqlcode,1)
                         LET g_success = 'N' 
                         CONTINUE FOREACH  
                      END IF
 
                      IF g_axg.axg08=0 THEN CONTINUE FOREACH END IF
 
                      #先將資料寫進TempTable裡 
                      EXECUTE insert_prep USING g_axg.axg06,g_axg.axg07,g_axu03,
                                                g_axg.axg02,g_axg.axg04,g_axg.axg08,
                                                g_axg.axg12,
                                                g_affil,g_dc,g_flag_r
                   END FOREACH
                   #----------------FUN-B70065 start-------------
                   #依對沖設定中有勾選依公式設定之科目，如有累換數科目
                   #取出調整沖銷分錄中屬於累換數科目的借貸方，相減
                   LET l_sql =
                   " SELECT SUM(axj07) FROM axi_file,axj_file ",
                   "  WHERE axi01=axj01 ",
                   "    AND axi03 = '",tm.yy,"'",
                   "    AND axi04 = '",tm.em,"'",
                   "    AND axj06 = '1' ",
                   "    AND axi05 ='",g_axa[i].axa01,"' ", 
                   "    AND axi06 ='",g_axf.axf16,"'",     #合併主體
                   "    AND axi00 ='",g_aaw01,"'",
                   "    AND axi00 =axj00 ",
                   "    AND axiconf ='Y' ",
                   "    AND axi09 = 'Y' ",
                   "    AND axi08 = '2' ",
                   "    AND axj03 = '",g_aaz87,"'", 
                   "    AND axj05 = '",g_axz08_axf10,"'",     #關係人
                   "    AND axj03 IN (SELECT DISTINCT axu04 FROM axu_file ",
                   "                   WHERE axu00 = '",g_aaw01_axf09,"'", 
                   "                     AND axu01 = '",g_axf.axf02,"'",
                   "                     AND axu09 = '",g_axf.axf09,"'",
                   "                     AND axu10 = '",g_axf.axf10,"'",
                   "                     AND axu12 = '",g_aaw01_axf10,"'",
                   "                     AND axu13 = '",g_axf.axf13,"'",
                   "                     AND axu05 = '+'",
                   "                     AND axu03 = '",g_axu03,"')",
                   "  UNION ",
                   " SELECT SUM(axj07) FROM axi_file,axj_file ",
                   "  WHERE axi01=axj01 ",
                   "    AND axi03 = '",tm.yy,"'",
                   "    AND axi04 = '",tm.em,"'",
                   "    AND axj06 = '1' ",
                   "    AND axi05 ='",g_axa[i].axa01,"' ", 
                   "    AND axi06 ='",tm.axa02,"'",
                   "    AND axi00 ='",g_aaw01,"'",
                   "    AND axi00 =axj00 ",
                   "    AND axiconf ='Y' ",
                   "    AND axi09 ='Y' ",
                   "    AND axi08 ='2' ",
                   "    AND axj03 = '",g_aaz87,"'", 
                   "    AND axj05 = '",g_axz08_axf10,"'",     #關係人
                   "    AND axj03 IN (SELECT DISTINCT axu04 FROM axu_file ",
                   "                   WHERE axu00 = '",g_aaw01_axf09,"'", 
                   "                     AND axu01 = '",g_axf.axf02,"'",
                   "                     AND axu09 = '",g_axf.axf09,"'",
                   "                     AND axu10 = '",g_axf.axf10,"'",
                   "                     AND axu12 = '",g_aaw01_axf10,"'",
                   "                     AND axu13 = '",g_axf.axf13,"'",
                   "                     AND axu05 = '-'",
                   "                     AND axu03 = '",g_axu03,"')"

                   PREPARE p001_misc_aaz87_p1 FROM l_sql
                   IF STATUS THEN 
                      LET g_showmsg=g_axa[i].axa01,"/",g_axa[i].axa02,"/",g_axa[i].axa03,"/",tm.yy                                    #NO.FUN-710023
                      CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'prepare:7',STATUS,1)  LET g_success = 'N' END IF  #NO.FUN-710023
                   DECLARE p001_misc_aaz87_c1 CURSOR FOR p001_misc_aaz87_p1
                   OPEN p001_misc_aaz87_c1
                   FETCH p001_misc_aaz87_c1 INTO l_axj07_d
                   IF cl_null(l_axj07_d) THEN LET l_axj07_d = 0 END IF

                   LET l_sql =
                   " SELECT SUM(axj07) FROM axi_file,axj_file ",
                   "  WHERE axi01=axj01 ",
                   "    AND axi03 = '",tm.yy,"'",
                   "    AND axi04 = '",tm.em,"'",
                   "    AND axj06 = '2' ",
                   "    AND axi05 ='",g_axa[i].axa01,"' ", 
                   "    AND axi06 ='",g_axf.axf16,"'",     #合併主體
                   "    AND axi00 ='",g_aaw01,"'",
                   "    AND axi00 =axj00 ",
                   "    AND axiconf ='Y' ",
                   "    AND axi09 ='Y' ",
                   "    AND axi08 ='2' ",
                   "    AND axj03 ='",g_aaz87,"'", 
                   "    AND axj05 ='",g_axz08_axf10,"'",     #關係人
                   "    AND axj03 IN (SELECT DISTINCT axu04 FROM axu_file ",
                   "                   WHERE axu00 = '",g_aaw01_axf09,"'", 
                   "                     AND axu01 = '",g_axf.axf02,"'",
                   "                     AND axu09 = '",g_axf.axf09,"'",
                   "                     AND axu10 = '",g_axf.axf10,"'",
                   "                     AND axu12 = '",g_aaw01_axf10,"'",
                   "                     AND axu13 = '",g_axf.axf13,"'",
                   "                     AND axu05 = '+'",
                   "                     AND axu03 = '",g_axu03,"')",
                   "  UNION ",
                   " SELECT SUM(axj07) FROM axi_file,axj_file ",
                   "  WHERE axi01=axj01 ",
                   "    AND axi03 = '",tm.yy,"'",
                   "    AND axi04 = '",tm.em,"'",
                   "    AND axj06 = '2' ",
                   "    AND axi05 ='",g_axa[i].axa01,"' ", 
                   "    AND axi06 ='",g_axf.axf16,"'",     #合併主體
                   "    AND axi00 ='",g_aaw01,"'",
                   "    AND axi00 =axj00 ",
                   "    AND axiconf ='Y' ",
                   "    AND axi09 ='Y' ",
                   "    AND axi08 ='2' ",
                   "    AND axj03 ='",g_aaz87,"'", 
                   "    AND axj05 ='",g_axz08_axf10,"'",     #關係人
                   "    AND axj03 IN (SELECT DISTINCT axu04 FROM axu_file ",
                   "                   WHERE axu00 = '",g_aaw01_axf09,"'", 
                   "                     AND axu01 = '",g_axf.axf02,"'",
                   "                     AND axu09 = '",g_axf.axf09,"'",
                   "                     AND axu10 = '",g_axf.axf10,"'",
                   "                     AND axu12 = '",g_aaw01_axf10,"'",
                   "                     AND axu13 = '",g_axf.axf13,"'",
                   "                     AND axu05 = '-'",
                   "                     AND axu03 = '",g_axu03,"')"
                   PREPARE p001_misc_aaz87_p2 FROM l_sql
                   IF STATUS THEN 
                      LET g_showmsg=g_axa[i].axa01,"/",g_axa[i].axa02,"/",g_axa[i].axa03,"/",tm.yy                                    #NO.FUN-710023
                      CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'prepare:7',STATUS,1)  LET g_success = 'N' END IF  #NO.FUN-710023
                   DECLARE p001_misc_aaz87_c2 CURSOR FOR p001_misc_aaz87_p2
                   OPEN p001_misc_aaz87_c2
                   FETCH p001_misc_aaz87_c2 INTO l_axj07_c
                   IF cl_null(l_axj07_c) THEN LET l_axj07_c = 0 END IF

                   LET l_axj07 = l_axj07_d - l_axj07_c

                   IF l_axj07 <> 0 THEN
                      #先將資料寫進TempTable裡 
                      EXECUTE insert_prep USING tm.yy,tm.em,g_axu03,  
                                                g_axf.axf16,g_axz08_axf10,l_axj07,
                                                x_aaa03,
                                                g_axz08_axf10,'2','Y'
                   END IF
                   #---FUN-B70065 end-----------------------
              END FOREACH
             IF g_axf.axf14 = 'Y' THEN 
                 #換匯差額的累換數是否加入沖銷分錄需依對沖設定
                 DECLARE p007_axt_cs2 CURSOR FOR
                    SELECT DISTINCT axt03 FROM axt_file
                     WHERE axt00 = g_aaw01_axf09
                       AND axt01 = g_axf.axf02
                       AND axt09 = g_axf.axf09
                       AND axt10 = g_axf.axf10
                       AND axt12 = g_aaw01_axf10
                       AND axt13 = g_axf.axf13
                 FOREACH p007_axt_cs2 INTO l_axt03
                     DECLARE p007_adj_cs CURSOR FOR
                      SELECT axj03,axj05,axj06,(axj07-axj071) FROM p007_adj_tmp
                           WHERE axj05 = g_axz08_axf10
                             AND axj03 = l_axt03

                      FOREACH p007_adj_cs INTO l_axj03,l_axj05,l_axj06,g_axg.axg08

                        IF g_axg.axg08=0 THEN CONTINUE FOREACH END IF

                        LET g_affil  = l_axj05
                        LET g_flag_r = 'N'
                            #借貸需與換匯差額的累換相反加入對沖分錄 
                            IF g_axg.axg08 < 0 THEN
                                IF l_axj06 = '1' THEN LET g_dc = '1' ELSE LET g_dc = '2' END IF
                            ELSE
                                IF l_axj06 = '1' THEN LET g_dc = '2' ELSE LET g_dc = '1' END IF
                            END IF
                        #先將資料進TempTable
                        EXECUTE insert_prep USING g_axg.axg06,g_axg.axg07,l_axj03,
                                                  g_axg.axg02,g_axg.axg04,g_axg.axg08,
                                                  g_axg.axg12,
                                                  g_affil,g_dc,g_flag_r
                      END FOREACH
                  END FOREACH
              END IF                 
             #取出換匯差額的累換數值
          ELSE
              #貸 子公司 少數股權,少數股權淨利
              #依據公式設定(對沖科目中axt04=Y)
              DECLARE p007_axt_cs1 CURSOR FOR
                 SELECT DISTINCT axt03,axt04,axt05 FROM axt_file 
                  WHERE axt00 = g_aaw01_axf09
                    AND axt01 = g_axf.axf02
                    AND axt09 = g_axf.axf09
                    AND axt10 = g_axf.axf10
                    AND axt12 = g_aaw01_axf10
                    AND axt04 = 'Y'             #是否依據公式設定]
                    AND axt13 = g_axf.axf13
              FOREACH p007_axt_cs1 INTO g_axu03
                       LET l_sql =
                       " SELECT axk08,axk09,axk05,axk02,axk04,(axk10-axk11),",  
                       "        axk14,'",g_axf.axf10,"','2','Y' "
                   LET l_sql = l_sql CLIPPED,
                   "   FROM axk_file ",
                   "  WHERE axk01 ='",g_axa[i].axa01,"' ",
                   "    AND axk00 ='",g_aaw01_axf10,"' ",
                   "    AND axk04 ='",g_axf.axf10,"' ",   #對沖公司
                   "    AND axk041='",g_axf10_axz05,"' ", #對沖帳別
                   "    AND axk07 = '",g_axz08,"'",
                   "    AND axk08 = ",tm.yy,
                   "    AND axk09 = '",tm.em,"'"
                   #FUN-B50001--mark--str--
                   #   IF g_cnt_axf10 > 0 THEN
                   #       IF g_low_axf10 = 0 THEN #最上層 
                   #           LET l_sql = l_sql CLIPPED,
                   #               "    AND axk02 = '",g_axf.axf10,"'"
                   #       ELSE
                   #           IF g_up_axf10 > 0 THEN
                   #               LET l_sql = l_sql CLIPPED,
                   #                   "    AND axk02 = '",g_axa02_axf10,"'"
                   #           END IF
                   #       END IF
                   #   ELSE
                   #       LET l_sql = l_sql CLIPPED,
                   #       "    AND axk02 = '",g_axa02_axf10,"'"
                   #   END IF
                   #FUN-B50001--mark--end
                   LET l_sql = l_sql CLIPPED,
                   "    AND axk05 IN (SELECT DISTINCT axu04 FROM axu_file ",
                   "                   WHERE axu00 = '",g_aaw01_axf09,"'",
                   "                     AND axu01 = '",g_axf.axf02,"'",
                   "                     AND axu09 = '",g_axf.axf09,"'",
                   "                     AND axu10 = '",g_axf.axf10,"'",
                   "                     AND axu12 = '",g_aaw01_axf10,"'",
                   "                     AND axu13 = '",g_axf.axf13,"'",　
                   "                     AND axu05 = '+'",
                   "                     AND axu03 = '",g_axu03,"')"
                       LET l_sql = l_sql CLIPPED,
                       "  UNION ",
                       " SELECT axk08,axk09,axk05,axk02,axk04,(axk08-axk09)*-1,",
                       "        axk14,'",g_axz08_axf10,"','2','Y' "
                   LET l_sql = l_sql CLIPPED,
                   "   FROM axk_file ",
                   "  WHERE axk01 ='",g_axa[i].axa01,"' ",
                   "    AND axk00 ='",g_aaw01_axf10,"' ",
                   "    AND axk04 ='",g_axf.axf10,"' ",   #對沖公司
                   "    AND axk041='",g_axf10_axz05,"' ", #對沖帳別
                   "    AND axk08 = ",tm.yy,
                   "    AND axk07 = '",g_axz08,"'",
                   "    AND axk09 = '",tm.em,"'",
                   "    AND axk05 IN (SELECT DISTINCT axu04 FROM axu_file ",
                   "                   WHERE axu00 = '",g_aaw01_axf09,"'",
                   "                     AND axu01 = '",g_axf.axf02,"'",
                   "                     AND axu09 = '",g_axf.axf09,"'",
                   "                     AND axu10 = '",g_axf.axf10,"'",
                   "                     AND axu12 = '",g_aaw01_axf10,"'",
                   "                     AND axu13 = '",g_axf.axf13,"'",
                   "                     AND axu05 = '-'",
                   "                     AND axu03 = '",g_axu03,"')"
                   #FUN-B50001--mark--str--luttb
                   #   IF g_cnt_axf10 > 0 THEN
                   #       IF g_low_axf10 = 0 THEN #最上層
                   #           LET l_sql = l_sql CLIPPED,
                   #               "    AND axk02 = '",g_axf.axf10,"'" ,
                   #               "  ORDER BY axk08,axk09,axk05,axk02,axk04 "
                   #       ELSE
                   #           IF g_up_axf10 > 0 THEN
                   #               LET l_sql = l_sql CLIPPED,
                   #                   "    AND axk02 = '",g_axa02_axf10,"'",
                   #                   "  ORDER BY axk08,axk09,axk05,axk02,axk04 "
                   #           END IF
                   #       END IF
                   #   ELSE
                   #       LET l_sql = l_sql CLIPPED,
                   #       "    AND axk02 = '",g_axa02_axf10,"'"
                   #   END IF
                   #FUN-B50001--mark--end

                  PREPARE p007_misc_p3 FROM l_sql
                  IF STATUS THEN 
                     LET g_showmsg=g_axa[i].axa01,"/",g_axa[i].axa02,"/",g_axa[i].axa03,"/",tm.yy
                     CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'prepare:7',STATUS,1)  LET g_success = 'N' END IF
                  DECLARE p007_misc_c3 CURSOR FOR p007_misc_p3
     
                  FOREACH p007_misc_c3 INTO g_axg.axg06,g_axg.axg07,g_axg.axg05,
                                            g_axg.axg02,g_axg.axg04,g_axg.axg08,
                                            g_axg.axg12,
                                            g_affil,g_dc,g_flag_r
                     IF SQLCA.sqlcode THEN 
                        LET g_showmsg=g_axa[i].axa01,"/",g_axa[i].axa01,"/",g_axa[i].axa01,"/",tm.yy
                        CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'p007_misc_c3',SQLCA.sqlcode,1)
                        LET g_success = 'N' 
                        CONTINUE FOREACH  
                     END IF

                     IF g_axg.axg08=0 THEN CONTINUE FOREACH END IF

                     #先將資料寫進TempTable裡 
                     EXECUTE insert_prep USING g_axg.axg06,g_axg.axg07,g_axu03,
                                               g_axg.axg02,g_axg.axg04,g_axg.axg08,
                                               g_axg.axg12,
                                               g_affil,g_dc,g_flag_r
                  END FOREACH

                  #----------------FUN-B70065 start-------------
                  #依對沖設定中有勾選依公式設定之科目，如有累換數科目
                  #取出調整沖銷分錄中屬於累換數科目的借貸方，相減
                  LET l_sql =
                  " SELECT SUM(axj07) FROM axi_file,axj_file ",
                  "  WHERE axi01=axj01 ",
                  "    AND axi03 = '",tm.yy,"'",
                  "    AND axi04 = '",tm.em,"'",
                  "    AND axj06 = '1' ",
                  "    AND axi05 ='",g_axa[i].axa01,"' ", 
                  "    AND axi06 ='",g_axf.axf16,"'",     #合併主體
                  "    AND axi00 ='",g_aaw01,"'",
                  "    AND axi00 =axj00 ",
                  "    AND axiconf ='Y' ",
                  "    AND axi09 = 'Y' ",
                  "    AND axi08 = '2' ",
                  "    AND axj03 = '",g_aaz87,"'", 
                  "    AND axj05 = '",g_axz08_axf10,"'",     #關係人
                  "    AND axj03 IN (SELECT DISTINCT axu04 FROM axu_file ",
                  "                   WHERE axu00 = '",g_aaw01_axf09,"'", 
                  "                     AND axu01 = '",g_axf.axf02,"'",
                  "                     AND axu09 = '",g_axf.axf09,"'",
                  "                     AND axu10 = '",g_axf.axf10,"'",
                  "                     AND axu12 = '",g_aaw01_axf10,"'",
                  "                     AND axu13 = '",g_axf.axf13,"'",
                  "                     AND axu05 = '+'",
                  "                     AND axu03 = '",g_axu03,"')",
                  "  UNION ",
                  " SELECT SUM(axj07) FROM axi_file,axj_file ",
                  "  WHERE axi01=axj01 ",
                  "    AND axi03 = '",tm.yy,"'",
                  "    AND axi04 = '",tm.em,"'",
                  "    AND axj06 = '1' ",
                  "    AND axi05 ='",g_axa[i].axa01,"' ", 
                  "    AND axi06 ='",tm.axa02,"'",
                  "    AND axi00 ='",g_aaw01,"'",
                  "    AND axi00 =axj00 ",
                  "    AND axiconf ='Y' ",
                  "    AND axi09 ='Y' ",
                  "    AND axi08 ='2' ",
                  "    AND axj03 = '",g_aaz87,"'", 
                  "    AND axj05 = '",g_axz08_axf10,"'",     #關係人
                  "    AND axj03 IN (SELECT DISTINCT axu04 FROM axu_file ",
                  "                   WHERE axu00 = '",g_aaw01_axf09,"'", 
                  "                     AND axu01 = '",g_axf.axf02,"'",
                  "                     AND axu09 = '",g_axf.axf09,"'",
                  "                     AND axu10 = '",g_axf.axf10,"'",
                  "                     AND axu12 = '",g_aaw01_axf10,"'",
                  "                     AND axu13 = '",g_axf.axf13,"'",
                  "                     AND axu05 = '-'",
                  "                     AND axu03 = '",g_axu03,"')"

                  PREPARE p001_misc_aaz87_p3 FROM l_sql
                  IF STATUS THEN 
                     LET g_showmsg=g_axa[i].axa01,"/",g_axa[i].axa02,"/",g_axa[i].axa03,"/",tm.yy                                    #NO.FUN-710023
                     CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'prepare:7',STATUS,1)  LET g_success = 'N' END IF  #NO.FUN-710023
                  DECLARE p001_misc_aaz87_c3 CURSOR FOR p001_misc_aaz87_p3
                  OPEN p001_misc_aaz87_c3
                  FETCH p001_misc_aaz87_c3 INTO l_axj07_d
                  IF cl_null(l_axj07_d) THEN LET l_axj07_d = 0 END IF

                  LET l_sql =
                  " SELECT SUM(axj07) FROM axi_file,axj_file ",
                  "  WHERE axi01=axj01 ",
                  "    AND axi03 = '",tm.yy,"'",
                  "    AND axi04 = '",tm.em,"'",
                  "    AND axj06 = '2' ",
                  "    AND axi05 ='",g_axa[i].axa01,"' ", 
                  "    AND axi06 ='",g_axf.axf16,"'",     #合併主體
                  "    AND axi00 ='",g_aaw01,"'",
                  "    AND axi00 =axj00 ",
                  "    AND axiconf ='Y' ",
                  "    AND axi09 ='Y' ",
                  "    AND axi08 ='2' ",
                  "    AND axj03 ='",g_aaz87,"'", 
                  "    AND axj05 ='",g_axz08_axf10,"'",     #關係人
                  "    AND axj03 IN (SELECT DISTINCT axu04 FROM axu_file ",
                  "                   WHERE axu00 = '",g_aaw01_axf09,"'", 
                  "                     AND axu01 = '",g_axf.axf02,"'",
                  "                     AND axu09 = '",g_axf.axf09,"'",
                  "                     AND axu10 = '",g_axf.axf10,"'",
                  "                     AND axu12 = '",g_aaw01_axf10,"'",
                  "                     AND axu13 = '",g_axf.axf13,"'",
                  "                     AND axu05 = '+'",
                  "                     AND axu03 = '",g_axu03,"')",
                  "  UNION ",
                  " SELECT SUM(axj07) FROM axi_file,axj_file ",
                  "  WHERE axi01=axj01 ",
                  "    AND axi03 = '",tm.yy,"'",
                  "    AND axi04 = '",tm.em,"'",
                  "    AND axj06 = '2' ",
                  "    AND axi05 ='",g_axa[i].axa01,"' ", 
                  "    AND axi06 ='",g_axf.axf16,"'",     #合併主體
                  "    AND axi00 ='",g_aaw01,"'",
                  "    AND axi00 =axj00 ",
                  "    AND axiconf ='Y' ",
                  "    AND axi09 ='Y' ",
                  "    AND axi08 ='2' ",
                  "    AND axj03 ='",g_aaz87,"'", 
                  "    AND axj05 ='",g_axz08_axf10,"'",     #關係人
                  "    AND axj03 IN (SELECT DISTINCT axu04 FROM axu_file ",
                  "                   WHERE axu00 = '",g_aaw01_axf09,"'", 
                  "                     AND axu01 = '",g_axf.axf02,"'",
                  "                     AND axu09 = '",g_axf.axf09,"'",
                  "                     AND axu10 = '",g_axf.axf10,"'",
                  "                     AND axu12 = '",g_aaw01_axf10,"'",
                  "                     AND axu13 = '",g_axf.axf13,"'",
                  "                     AND axu05 = '-'",
                  "                     AND axu03 = '",g_axu03,"')"
                  PREPARE p001_misc_aaz87_p4 FROM l_sql
                  IF STATUS THEN 
                     LET g_showmsg=g_axa[i].axa01,"/",g_axa[i].axa02,"/",g_axa[i].axa03,"/",tm.yy                                    #NO.FUN-710023
                     CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'prepare:7',STATUS,1)  LET g_success = 'N' END IF  #NO.FUN-710023
                  DECLARE p001_misc_aaz87_c4 CURSOR FOR p001_misc_aaz87_p4
                  OPEN p001_misc_aaz87_c4
                  FETCH p001_misc_aaz87_c4 INTO l_axj07_c
                  IF cl_null(l_axj07_c) THEN LET l_axj07_c = 0 END IF

                  LET l_axj07 = l_axj07_d - l_axj07_c

                  IF l_axj07 <> 0 THEN
                     #先將資料寫進TempTable裡 
                     EXECUTE insert_prep USING tm.yy,tm.em,g_axu03,  
                                               g_axf.axf16,g_axz08_axf10,l_axj07,
                                               x_aaa03,
                                               g_axz08_axf10,'2','Y'
                  END IF
                  #---FUN-B70065 end-----------------------
             END FOREACH 
         END IF          
     END IF    

     DECLARE p007_tmp_cs CURSOR FOR
        SELECT axg06,axg07,axg05,axg02,axg04,SUM(axg08),axg12,affil,dc,flag_r
          FROM p007_tmp
         GROUP BY axg06,axg07,axg05,axg02,axg04,axg12,affil,dc,flag_r
         ORDER BY axg06,axg07,axg05,axg02,axg04,axg12,affil,dc,flag_r
                 #年    月
     LET g_axg07_o = '' 
     FOREACH p007_tmp_cs INTO g_axg.axg06,g_axg.axg07,g_axg.axg05,
                              g_axg.axg02,g_axg.axg04,g_axg.axg08,
                              g_axg.axg12,
                              g_affil,g_dc,g_flag_r
        IF SQLCA.sqlcode THEN 
           LET g_showmsg=g_axa[i].axa01,"/",g_axa[i].axa01,"/",g_axa[i].axa01,"/",tm.yy
           CALL s_errmsg('axk01,axk04,axk041,axk08',g_showmsg,'p007_tmp_cs',SQLCA.sqlcode,1)
           LET g_success = 'N'
           CONTINUE FOREACH 
        END IF

        CALL s_ymtodate(g_axg.axg06,g_axg.axg07,g_axg.axg06,g_axg.axg07)
               RETURNING g_bdate,g_edate

        IF NOT cl_null(g_axg07_o) AND g_axg07_o<>g_axg.axg07 AND 
           NOT cl_null(g_axi.axi01) THEN
           CALL p007_ins_axj2()   #寫入差異分錄
           IF NOT cl_null(g_axi.axi01) THEN CALL upd_axi() END IF
        END IF

        #--a抓持股比率
        CALL get_rate()  
        
        #FUN-B50001 add--str--luttb
        SELECT axf03 INTO l_axf03
          FROM axf_file
         WHERE axf02 = g_axg.axg05
           AND axf13 = g_axf.axf13
           AND axf16 = g_axf.axf16
           AND axf00 = g_axf.axf00
           AND axf01 = g_axf.axf01
           AND axf02 = g_axf.axf02
           AND axf09 = g_axf.axf09
           AND axf10 = g_axf.axf10
           AND axf12 = g_axf.axf12
        IF cl_null(l_axf03) THEN
           SELECT axt05 INTO l_axf03
            FROM  axt_file,axf_file
           WHERE axt03 = g_axg.axg05
             AND axt00 = g_axf.axf00
             AND axt09 = g_axf.axf09
             AND axt10 = g_axf.axf10
             AND axt12 = g_axf.axf12
             AND axt13 = g_axf.axf13
             AND axt01 = g_axf.axf02
             AND axt00 = axf00
             AND axt09 = axf09
             AND axt10 = axf10
             AND axt12 = axf12
             AND axt13 = axf13
             AND axt01 = axf02
        END IF
        IF l_axf03 = 'Y' THEN
           LET g_axg.axg08 = g_axg.axg08 * g_rate
        END IF
        #FUN-B50001--add--end

        LET l_cnt = 0
        
        SELECT COUNT(*) INTO l_cnt FROM axi_file  #判斷是否已存在單頭
         WHERE axi00 = g_aaw01      #帳別
           AND axi02 = g_edate       #單據日期
           AND axi03 = g_axg.axg06   #調整年度
           AND axi04 = g_axg.axg07   #調整月份
           AND axi05 = tm.axa01      #族群編號
           AND axi06 = g_axf.axf16   #合併主體公司編號
           AND axi07 = tm.axa03      #上層帳別
           AND axi08 = '2'           #資料來源-2.資料匯入
           AND axi21 = tm.ver        
           #AND axi081 = '1'
           AND axi081 = '7'
           AND axi09 = 'N'
        IF l_cnt = 0 THEN     #沒有符合的資料才要新增
           LET g_yy=g_axg.axg06 
           LET g_mm=g_axg.axg07 
           CALL p007_ins_axi() 
        ELSE                  #取出單頭資料以供後續寫入axj時用
           SELECT * INTO g_axi.* FROM axi_file
            WHERE axi00 = g_aaw01
              AND axi02 = g_edate
              AND axi03 = g_axg.axg06
              AND axi04 = g_axg.axg07
              AND axi05 = tm.axa01
              AND axi06 = g_axf.axf16
              AND axi07 = tm.axa03
              AND axi08 = '2'
              #AND axi081 = '1'
              AND axi081 = '7'
              AND axi21 = tm.ver
              AND axi09 = 'N'
        END IF
        
        #-->寫入調整與銷除分錄底稿單身
        IF NOT cl_null(g_axi.axi01) THEN    #當單頭檔(axi_file)的傳票號碼(axi01)有值石才需計算差異
           CALL p007_ins_axj1()
        END IF
        IF g_success = 'N' THEN RETURN  END IF
        LET g_axg07_o=g_axg.axg07   #期別舊值備份
     END FOREACH

     #當單頭檔(axi_file)的傳票號碼(axi01)有值時才需計算差異
     IF NOT cl_null(g_axi.axi01) THEN    
        CALL p007_ins_axj2()   #寫入差異分錄
     END IF
     IF NOT cl_null(g_axi.axi01) THEN CALL upd_axi() END IF
     LET p_axf01 = ''
     LET p_axf02 = ''
END FUNCTION

FUNCTION p007_getrate(l_value,l_axp01,l_axp02,l_axp03,l_axp04)
DEFINE l_value LIKE axe_file.axe11,
       l_axp01 LIKE axp_file.axp01,
       l_axp02 LIKE axp_file.axp02,
       l_axp03 LIKE axp_file.axp03,
       l_axp04 LIKE axp_file.axp04,
       l_axp05 LIKE axp_file.axp05,
       l_axp06 LIKE axp_file.axp06,
       l_axp07 LIKE axp_file.axp07,
       l_rate  LIKE axp_file.axp05

   SELECT axp05,axp06,axp07 
     INTO l_axp05,l_axp06,l_axp07 
     FROM axp_file
    WHERE axp01=l_axp01
      AND axp02=(SELECT max(axp02) FROM axp_file
                  WHERE axp01 = l_axp01
                    AND axp02 <=l_axp02
                    AND axp03 = l_axp03
                    AND axp04 = l_axp04)
      AND axp03=l_axp03 
      AND axp04=l_axp04

   CASE
      WHEN l_value='1'   #1.現時匯率
         LET l_rate=l_axp05
      WHEN l_value='2'   #2.歷史匯率
         LET l_rate=l_axp06
      WHEN l_value='3'   #3.平均匯率
         LET l_rate=l_axp07
      OTHERWISE      
         LET l_rate=1
   END CASE

   IF l_rate = 0 THEN LET l_rate = 1 END IF

   RETURN l_rate
END FUNCTION

FUNCTION p007_ins_axj1_chg1(p_type,p_flag,p_axz06)
DEFINE p_axz06     LIKE axz_file.axz06
DEFINE p_axg12     LIKE axg_file.axg12
DEFINE l_axg08     LIKE axg_file.axg08
DEFINE l_axg09     LIKE axg_file.axg09
DEFINE l_axg08_b   LIKE axg_file.axg08
DEFINE l_axg09_b   LIKE axg_file.axg09
DEFINE l_tot_amt   LIKE axg_file.axg08
DEFINE i           LIKE type_file.num5
DEFINE l_sql       STRING
DEFINE l_cut       LIKE type_file.num5
DEFINE l_axg12     LIKE axg_file.axg12   
DEFINE l_r         LIKE axp_file.axp05   
DEFINE l_r1        LIKE axp_file.axp05   
DEFINE p_flag      LIKE type_file.chr1   
DEFINE p_type      LIKE type_file.chr1   
DEFINE l_axz07     LIKE axf_file.axf09   
DEFINE l_month     LIKE type_file.num5
DEFINE l_amt2      LIKE axh_file.axh08
DEFINE l_amt1      LIKE axh_file.axh08
DEFINE l_amt       LIKE axh_file.axh08

     #取下層公司記帳金額期別計算各月異動額
     #轉換為合併幣別金額後加總
     #各期各自先計算出當月金額後累加
     #沖銷金額=1-9月各期餘額加總
     #各期餘額計算方式：例:(9月合併異動(貸)-8月合併異動(貸)*9月匯率) - (9月合併異動(借)-8月合併異動(借) * 9月匯率)

     LET l_tot_amt = 0
     LET l_amt2 = 0
     LET l_amt1 = 0
     LET l_amt  = 0

     SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=p_axz06
     IF cl_null(l_cut) THEN LET l_cut = 0 END IF

     #先依來源為axkk_file or axh_file取各期餘額
     LET l_sql=
     " SELECT axh07,axh12",
     "   FROM axh_file ",
     "  WHERE axh00 = '",g_aaw01,"'",          #合併帳別  
     "    AND axh01 = '",tm.axa01,"'", #族群
     "    AND axh02 = '",g_axg.axg02,"'", #公司
     "    AND axh05 = '",g_axg.axg05,"'",
     "    AND axh06= '",tm.yy,"'",
     "    AND axh07 BETWEEN '",tm.bm,"' AND '",tm.em,"'"
     PREPARE p007_axh_p3 FROM l_sql
     DECLARE p007_axh_c3 CURSOR FOR p007_axh_p3
     FOREACH p007_axh_c3 INTO l_month,l_axg12
        IF l_month = 0 THEN CONTINUE FOREACH END IF
        SELECT axz07 INTO l_axz07 FROM axz_file WHERE axz01 = g_axg.axg02
        CASE 
           WHEN p_flag = '1'        #axh_file
               SELECT SUM(axh08-axh09) INTO l_amt2
                 FROM axh_file 
                WHERE axh00 = g_aaw01        #合併帳別 
                  AND axh01 = tm.axa01        #族群
                  AND axh02 = g_axg.axg02     #公司
                  AND axh05 = g_axg.axg05
                  AND axh06 = tm.yy
                  AND axh07 = l_month
           WHEN p_flag = '2'        #axkk_file
               SELECT SUM(axkk10-axkk11) INTO l_amt2
                 FROM axkk_file
                WHERE axkk00 = g_aaw01
                  AND axkk01 = tm.axa01
                  AND axkk02 = g_axg.axg02
                  AND axkk05 = g_axg.axg05
                  AND axkk07 = g_axk07
                  AND axkk08 = tm.yy
                  AND axkk09 = l_month
        END CASE
        CASE 
           WHEN p_flag = '1'        #axh_file
               SELECT SUM(axh08-axh09) INTO l_amt1
                 FROM axh_file
                WHERE axh00 = g_aaw01        #合併帳別 
                  AND axh01 = tm.axa01        #族群
                  AND axh02 = g_axg.axg02     #公司
                  AND axh05 = g_axg.axg05
                  AND axh06 = tm.yy
                  AND axh07 = (SELECT MAX(axh07) FROM axh_file
                                WHERE axh00 = g_aaw01        #合併帳別 
                                  AND axh01 = tm.axa01        #族群
                                  AND axh02 = g_axg.axg02     #公司
                                  AND axh05 = g_axg.axg05
                                  AND axh06 = tm.yy
                                  AND axh07 < l_month)
           WHEN p_flag = '2'        #axkk_file
               SELECT SUM(axkk10-axkk11) INTO l_amt1
                 FROM axkk_file
                WHERE axkk00 = g_aaw01
                  AND axkk01 = tm.axa01
                  AND axkk02 = g_axg.axg02
                  AND axkk05 = g_axg.axg05
                  AND axkk07 = g_axk07
                  AND axkk08 = tm.yy
                  AND axkk09 = (SELECT MAX(axkk09) FROM axkk_file
                                 WHERE axkk00 = g_aaw01
                                   AND axkk01 = tm.axa01
                                   AND axkk02 = g_axg.axg02
                                   AND axkk05 = g_axg.axg05
                                   AND axkk07 = g_axk07
                                   AND axkk08 = tm.yy
                                   AND axkk09 < l_month)
        END CASE
        IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
        IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
        LET l_amt = l_amt2 - l_amt1

        LET l_r = 1
        LET l_r1 = 1
        CALL p007_getrate('3',tm.yy,l_month,l_axg12,l_axz07)  #取起始月份至當下月份的匯率
        RETURNING l_r   
        IF cl_null(l_r) THEN LET l_r = 1 END IF

        CALL p007_getrate('3',tm.yy,l_month,l_axz07,p_axz06) 
        RETURNING l_r1   
        IF cl_null(l_r1) THEN LET l_r1 = 1 END IF

        LET l_amt = l_amt * l_r * l_r1
        LET l_tot_amt = l_tot_amt + l_amt
     END FOREACH

     RETURN l_tot_amt 
END FUNCTION

FUNCTION p007_ins_axj1_chg(p_type,p_flag,p_axz06)
DEFINE p_axz06     LIKE axz_file.axz06
DEFINE p_axg12     LIKE axg_file.axg12
DEFINE l_axg08     LIKE axg_file.axg08
DEFINE l_axg09     LIKE axg_file.axg09
DEFINE l_axg08_b   LIKE axg_file.axg08
DEFINE l_axg09_b   LIKE axg_file.axg09
DEFINE l_month_amt LIKE axg_file.axg08
DEFINE l_tot_amt   LIKE axg_file.axg08
DEFINE i           LIKE type_file.num5
DEFINE l_sql       STRING
DEFINE l_cut       LIKE type_file.num5
DEFINE l_axg12     LIKE axg_file.axg12
DEFINE l_r         LIKE axp_file.axp05
DEFINE l_r1        LIKE axp_file.axp05
DEFINE p_flag      LIKE type_file.chr1
DEFINE p_type      LIKE type_file.chr1
DEFINE l_axz07     LIKE axf_file.axf09

     #取下層公司記帳金額期別計算各月異動額
     #轉換為合併幣別金額後加總
     #各期各自先計算出當月金額後累加
     #沖銷金額=1-9月各期餘額加總
     #各期餘額計算方式：例:(9月合併異動(貸)-8月合併異動(貸)*9月匯率) - (9月合併異動(借)-8月合併異動(借) * 9月匯率)
      LET l_axg08 = 0
      LET l_axg09 = 0
      LET l_axg08_b = 0
      LET l_axg09_b = 0
      LET l_month_amt = 0
      LET l_tot_amt = 0
      SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=p_axz06
      IF cl_null(l_cut) THEN LET l_cut = 0 END IF

     #先依來源為axk_file or axg_file取各月餘額
     FOR i = 0 TO tm.em
         SELECT axz07 INTO l_axz07 FROM axz_file WHERE axz01 = g_axg.axg04
         IF p_type = 'A' THEN       #來源公司 
             CASE 
                WHEN p_flag = '1'        #aej_file
                    LET l_sql =
                    " SELECT SUM(aej07-aej08),aej11",
                    "   FROM aej_file ",
                    "  WHERE aej00 = '",g_aaw01,"'",        #合併帳別 
                    "    AND aej01 = '",tm.axa01,"'",        #族群
                    "    AND aej02 = '",g_axg.axg04,"'",     #公司
                    "    AND aej04 = '",g_axg.axg05,"'",
                    "    AND aej05 = '",tm.yy,"'",
                    "    AND aej06 = '",i,"'",
                    "  GROUP BY aej11 "
                WHEN p_flag = '2'        #aek_file
                    LET l_sql=
                    " SELECT SUM(aek08-aek09),aek12",
                    "   FROM aek_file",
                    "  WHERE aek00 = '",g_aaw01,"'",
                    "    AND aek01 = '",tm.axa01,"'",
                    "    AND aek02 = '",g_axg.axg04,"'",
                    "    AND aek04 = '",g_axg.axg05,"'",
                    "    AND aek05 = '",g_axk07,"'",
                    "    AND aek06 = '",tm.yy,"'",
                    "    AND aek07 = '",i,"'",
                    "  GROUP BY aek12"
            END CASE
        ELSE        #目的公司
            CASE
              WHEN p_flag = '1'        #aej_file
                 LET l_sql =
                 " SELECT SUM(aej07-aej08),aej11",
                 "   FROM aej_file ",
                 "  WHERE aej00 = '",g_aaw01,"'",        #合併帳別 
                 "    AND aej01 = '",tm.axa01,"'",        #族群
                 "    AND aej02 = '",g_axg.axg04,"'",     #公司
                 "    AND aej04 = '",g_axg.axg05,"'",
                 "    AND aej05 = '",tm.yy,"'",
                 "    AND aej06 = '",i,"'",
                 "  GROUP BY aej11 "
              WHEN p_flag = '2'        #aek_file
                 LET l_sql=
                 " SELECT SUM(aek08-aek09),aek12",
                 "   FROM aek_file",
                 "  WHERE aek00 = '",g_aaw01,"'",
                 "    AND aek01 = '",tm.axa01,"'",
                 "    AND aek02 = '",g_axg.axg04,"'",
                 "    AND aek04 = '",g_axg.axg05,"'",
                 "    AND aek05 = '",g_axk07,"'",
                 "    AND aek06 = '",tm.yy,"'",
                 "    AND aek07 = '",i,"'",
                 "  GROUP BY aek12"
            END CASE
        END IF

        PREPARE p007_ins_axj1_p1 FROM l_sql
        IF STATUS THEN
           LET g_showmsg=g_axa[i].axa01,"/",g_axa[i].axa02,"/",g_axa[i].axa03,"/",tm.yy
           CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'pre:ins_axj1_p1',STATUS,1)
           LET g_success = 'N'
        END IF
        DECLARE p007_ins_axj1_c1 CURSOR FOR p007_ins_axj1_p1
        FOREACH p007_ins_axj1_c1 INTO l_month_amt,l_axg12    #借-貸/幣別
            LET l_r = 1
            LET l_r1 = 1
            IF i = 0 THEN LET i = 1 END IF  #0期沒有匯率，直接取1期的匯率計算
            CALL p007_getrate('3',tm.yy,i,l_axg12,l_axz07)  #取起始月份至當下月份的匯率
            RETURNING l_r   
            IF cl_null(l_r) THEN LET l_r = 1 END IF
            CALL p007_getrate('3',tm.yy,i,l_axz07,p_axz06) 
            RETURNING l_r1   
            IF cl_null(l_r1) THEN LET l_r1 = 1 END IF
            LET l_month_amt = l_month_amt * l_r * l_r1
            LET l_tot_amt = l_tot_amt + l_month_amt
        END FOREACH
     END FOR
     RETURN l_tot_amt 
END FUNCTION

FUNCTION p007_ins_axj2()   #差異科目
DEFINE l_sumd  LIKE axj_file.axj07,
       l_sumc  LIKE axj_file.axj07,
       l_sumdc LIKE axj_file.axj07
DEFINE l_aag04 LIKE aag_file.aag04

   INITIALIZE g_axj.* TO NULL

   SELECT SUM(axj07) INTO l_sumd FROM axj_file
    WHERE axj00=g_aaw01 AND axj01=g_axi.axi01 AND axj06='1'   #借方合計
   IF cl_null(l_sumd) THEN LET l_sumd = 0 END IF
   SELECT SUM(axj07) INTO l_sumc FROM axj_file
    WHERE axj00=g_aaw01 AND axj01=g_axi.axi01 AND axj06='2'   #貸方合計
   IF cl_null(l_sumc) THEN LET l_sumc = 0 END IF
   LET l_sumdc=l_sumd-l_sumc   
   IF l_sumdc = 0 THEN RETURN END IF

   LET g_axj.axj00=g_aaw01        #帳別
   LET g_axj.axj01=g_axi.axi01     #傳票編號   

   SELECT MAX(axj02)+1 INTO g_axj.axj02 
     FROM axj_file
    WHERE axj01=g_axj.axj01
      AND axj00=g_axj.axj00
   IF cl_null(g_axj.axj02)  THEN LET g_axj.axj02 = 1 END IF
   LET g_axj.axj03=g_axf.axf04     #科目
   LET g_axj.axj04=' '             #摘要
 # LET g_axj.axj05=' '             #關係人 #FUN-B60134  MARK
   LET g_axj.axj05= g_axf.axf09    #FUN-B60134 ADD
   IF l_sumdc >0 THEN              #借貸別
      LET g_axj.axj06='2' 
   ELSE 
      LET g_axj.axj06='1' 
   END IF
   LET g_axj.axj07=l_sumdc         #金額
   IF g_axj.axj07<0 THEN LET g_axj.axj07=g_axj.axj07*-1 END IF
   IF g_axj.axj07 IS NULL THEN LET g_axj.axj07=0 END IF 
   LET g_axj.axjlegal=g_legal
   IF g_axj.axj07 != 0 THEN
      INSERT INTO axj_file VALUES (g_axj.*)
      IF SQLCA.sqlcode THEN 
         LET g_showmsg=g_axi.axi07,"/",g_axi.axi01
         CALL s_errmsg('axj00,axj01',g_showmsg ,'ins axj',SQLCA.sqlcode,1)
         LET g_success = 'N' 
         RETURN 
      END IF
      LET l_aag04 = ''
      SELECT aag04 INTO l_aag04
        FROM aag_file
       WHERE aag00 = g_aaw01
         AND aag01 = g_axj.axj03
      IF l_aag04 = '2' THEN
           EXECUTE insert_axj_prep USING g_axj.axj03,
                                         g_axj.axj06,g_axj.axj07
      END IF
   END IF

END FUNCTION

FUNCTION get_rate()#持股比率
DEFINE l_axb07    LIKE axb_file.axb07,
       l_axb08    LIKE axb_file.axb08,
       l_axd07b   LIKE axd_file.axd07b,
       l_axd08b   LIKE axd_file.axd08b,
       l_count    LIKE type_file.num5,
       l_sql      LIKE type_file.chr1000,
       l_axz05    LIKE axz_file.axz05

    SELECT axz05 INTO l_axz05 FROM axz_file WHERE axz01=g_axf.axf10
    SELECT axb07,axb08 INTO l_axb07,l_axb08 FROM axb_file 
     WHERE axb01=tm.axa01 AND axb02=tm.axa02 AND axb03=tm.axa03
       AND axb04=g_axf.axf10 AND axb05=l_axz05 
    IF STATUS THEN LET g_rate=0 RETURN END IF
    IF g_edate >= l_axb08 OR cl_null(l_axb08) THEN LET g_rate=l_axb07/100 RETURN END IF
    
    LET l_count=0
    LET g_rate =0
    LET l_sql="SELECT axd07b,axd08b  FROM axd_file ",
              " WHERE axd01='",tm.axa01,"'",
              "   AND axd02='",tm.axa02,"' AND axd03='",tm.axa03,"'",
              "   AND axd04b='",g_axf.axf10,"' AND axd05b='",l_axz05,"'",
              " ORDER BY axd08b desc"
    PREPARE p007_axd_p FROM l_sql
    IF STATUS THEN 
        CALL s_errmsg(' ',' ','prepare:6',STATUS,1) LET g_success = 'N'  RETURN
    END IF
    DECLARE p007_axd_c CURSOR FOR p007_axd_p

    FOREACH p007_axd_c INTO l_axd07b,l_axd08b
       IF SQLCA.sqlcode  THEN LET g_rate=0 EXIT FOREACH END IF
       LET l_count=l_count+1
       IF g_edate>=l_axd08b THEN LET g_rate=l_axd07b/100 EXIT FOREACH END IF
    END FOREACH       
    IF l_count=0 THEN LET g_rate=0 RETURN END IF
END FUNCTION

FUNCTION p007_ins_axj1()
DEFINE l_axz06_axf16   LIKE axz_file.axz06
DEFINE l_aag04         LIKE aag_file.aag04
DEFINE l_rate          LIKE axp_file.axp05   #各公司與合併主體公司匯率
DEFINE l_cut           LIKE type_file.num5

   INITIALIZE g_axj.* TO NULL
 
   LET g_axj.axj00=g_aaw01        #帳別
   LET g_axj.axj01=g_axi.axi01     #傳票編號   

   SELECT MAX(axj02)+1 INTO g_axj.axj02 
     FROM axj_file 
    WHERE axj01=g_axj.axj01
      AND axj00=g_axj.axj00
   IF g_axj.axj02 IS NULL THEN LET g_axj.axj02 = 1 END IF   #項次
   LET g_axj.axj03=g_axg.axg05                              #科目
   LET g_axj.axj04=' '                                      #摘要
   LET g_axj.axj05=g_affil                                  #關係人
   IF g_axg.axg08 < 0 THEN 
      IF g_dc='1' THEN LET g_dc='2' ELSE LET g_dc='1' END IF
   END IF
   LET g_axj.axj06=g_dc                                     #借貸別
   LET l_rate = 1
   IF g_axf.axf03='N' OR (g_axf.axf03='Y' AND g_rate=0) THEN
      LET g_axj.axj07=g_axg.axg08                           #金額
   ELSE
      IF g_flag_r='Y' THEN
         LET g_axj.axj07=g_axg.axg08*(1-g_rate)          #金額
         IF g_axj.axj07 > 0 THEN
             LET g_axj.axj06 = '1'
         ELSE
             LET g_axj.axj06 = '2'
         END IF
      ELSE
         LET g_axj.axj07=g_axg.axg08                        #金額
      END IF
   END IF
   #原本都是以tm.axa02為上層公司寫入對沖分錄
   #改以"合併主體(axf16)"寫入對沖分錄上層公司(axi06),
   #對沖金額(axj07)的值原本是以上層公司的幣別計算
   #改以合併主體幣別
   #(axg08,axg09為捲算過後的上層公司記帳幣金額不可直接拿來使用)
   #當要產生對沖分錄時，tm.axa02取axf_file的值(axf16 = tm.axa02)再進行對沖產生
   #並且要把對沖金額換算為合併主體公司記帳幣，才能算出差額科目金額
   #一一將對沖的科目寫入分錄之後(要換算成合併主體幣別)，再計算差額額目(同一組分錄借-貸)
 
   SELECT axz06 INTO l_axz06_axf16 
     FROM axz_file
    WHERE axz01 = g_axf.axf16   #合併主體幣別
  
   #將來源/目的公司的幣別和合併主體幣別做比較
   #幣別相同者不用換，不相同時將幣別換成合併主體幣別and金額
   LET l_rate = 1

   SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_axz06_axf16
   IF cl_null(l_cut) THEN LET l_cut = 0 END IF
   LET g_axj.axj07=cl_digcut(g_axj.axj07,l_cut)
   IF g_axj.axj07<0 THEN LET g_axj.axj07=g_axj.axj07*-1 END IF
   LET g_axj.axjlegal=g_legal   
   IF g_axj.axj07 IS NULL THEN LET g_axj.axj07=0 END IF
   IF g_axj.axj07 != 0 THEN
      INSERT INTO axj_file VALUES (g_axj.*)
      IF SQLCA.sqlcode THEN 
         LET g_showmsg=g_axi.axi07,"/",g_axi.axi01
         CALL s_errmsg('axj00,axj01',g_showmsg ,'ins axj',SQLCA.sqlcode,1)
         LET g_success = 'N' 
         RETURN 
      END IF
      LET l_aag04 = ''
      SELECT aag04 INTO l_aag04
        FROM aag_file
       WHERE aag00 = g_aaw01
         AND aag01 = g_axj.axj03
      IF l_aag04 = '2' THEN
           EXECUTE insert_axj_prep USING g_axj.axj03,g_axj.axj06,g_axj.axj07
                                         
      END IF
   END IF

END FUNCTION
#FUN-B50001

#TQC-B70069   ---start   Add
FUNCTION p007_del()
  LET g_em = tm.em    #TQC-B70069   Add
  #-->delete axj_file(調整與銷除分錄底稿單身檔)
  DELETE FROM axj_file
        WHERE axj00=g_aaw01
          AND axj01 IN (SELECT axi01 FROM axi_file
                         WHERE axi00=g_aaw01 AND axi05=tm.axa01
                           AND axi06=tm.axa02 AND axi07=tm.axa03
                           AND axi03=tm.yy AND axi04 = tm.em
                           AND (axi21=tm.ver OR axi21=g_em)
                           AND axi08='2')
  IF SQLCA.sqlcode THEN
     CALL cl_err3("del","axj_file",g_aaw01,"",SQLCA.sqlcode,"","del axj_file",1)
     LET g_success = 'N'
     RETURN
  END IF

  #-->delete axi_file
  #-->delete axi_file(調整與銷除分錄底稿單頭檔)
  DELETE FROM axi_file
        WHERE axi00=g_aaw01
          AND axi05=tm.axa01 AND axi06=tm.axa02 AND axi07=tm.axa03
          AND axi03=tm.yy AND axi04 = tm.em 
          AND (axi21=tm.ver OR axi21=g_em) 
          AND axi08='2'
  IF SQLCA.sqlcode THEN
     CALL cl_err3("del","axi_file",tm.axa03,"",SQLCA.sqlcode,"","del axi_file",1)
     LET g_success = 'N'
     RETURN
  END IF
END FUNCTION
#TQC-B70069   ---end     Add

#MOD-BB0262
