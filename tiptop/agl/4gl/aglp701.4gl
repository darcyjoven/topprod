# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglp701.4gl
# Descriptions...: 遞延傳票拋轉作業
# Date & Author..: No.FUN-9A0036 10/08/10 By chenmoyan
# Modify.........: No.FUN-A10005 10/08/10 By chenmoyan 遞延收入金額要按azi04取小數位。依部門管理/項目管理/專案控制及異動碼預設值抓取
# Modify.........: No.FUN-A60007 10/08/11 By chenmoyan 原本在程式中處理四種類型遞延收入金額，產生至傳票現更改為只處理oct16='2' and '4'
# Modify.........: NO.MOD-A80025 10/08/14 BY chenmoyan 取沖轉科目時，需考慮遞延類型
# Modify.........: NO.CHI-A70058 10/08/16 BY chenmoyan GL->AR
# Modify.........: NO.MOD-A90034 10/09/06 BY Dido 日期重新抓取;異動碼預設參數傳遞比照axrt300
# Modify.........: No.TQC-AA0002 10/09/30 By suncx toolbar上增加語言功能鍵
# Modify.........: No.FUN-A50102 10/10/08 By lixia g_dbs_gl 修改為g_plant_gl
# Modify.........: No.FUN-AB0110 11/01/19 By chenmoyan 1.拋轉傳票時,遞延收科目傳票單身項次回寫oct22
#                                                      2.oct16='3'者加入在此產生傳票(因為應收折讓分錄并無拆分遞延科目)
#                                                      3.依照oct16<>'1'將相同年度/月份/出貨單號/售貨動作/科目為group,
#                                                        金額加總后借減貨,剩餘金額大於0放在借方,小於0放貸方
# Modify.........: NO.MOD-B10115 11/01/17 BY Dido 異動關係人預設值問題處理;不可在TRANSACTION中寫到BDL語法(如DROP TABLE) 
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No:FUN-B50105 11/05/23 By zhangweib aaz88範圍修改為0~4 添加azz125 營運部門資訊揭露使用異動碼數(5-8)
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file
# Modify.........: No:FUN-B50122 11/08/11 By belle 增加"傳票彙總方式"
# Modify.........: No:CHI-CB0004 12/11/12 By Belle 修改總號計算方式
# Modify.........: No.CHI-C80041 12/12/24 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_year             LIKE type_file.chr4,
       g_month            LIKE type_file.chr2,
       b_user             LIKE type_file.chr10,
       e_user             LIKE type_file.chr10,
       p_plant            LIKE azp_file.azp01,
       p_bookno,p_bookno1 LIKE aza_file.aza81,
       gl_no,gl_no1       LIKE aba_file.aba01,
       g_no1              LIKE aba_file.aba01,
       g_no2              LIKE aba_file.aba01,   #FUN-B50122 傳單別
       gl_date            LIKE type_file.dat
DEFINE g_bgjob            LIKE type_file.chr1
DEFINE g_sql              STRING
DEFINE l_flag             LIKE type_file.chr1
#DEFINE g_dbs_gl           LIKE azp_file.azp01
DEFINE g_plant_gl           LIKE azp_file.azp01   #FUN-A50102
DEFINE g_yy               LIKE type_file.chr4,
       g_mm               LIKE type_file.chr2
DEFINE g_aba       RECORD LIKE aba_file.*
DEFINE g_ooz       RECORD LIKE ooz_file.*
DEFINE g_debit            LIKE aba_file.aba08
DEFINE g_debit1           LIKE aba_file.aba08
DEFINE g_credit           LIKE aba_file.aba09
DEFINE g_credit1          LIKE aba_file.aba09
DEFINE g_dbs_oct17        LIKE type_file.chr20 #FUN-A30006
DEFINE g_oma03            LIKE oma_file.oma15  #MOD-B10115 
DEFINE gl_seq             LIKE type_file.chr1  #FUN-B50122

MAIN

   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_year   = ARG_VAL(1)
   LET g_month  = ARG_VAL(2)
   LET b_user   = ARG_VAL(3)
   LET e_user   = ARG_VAL(4)
   LET p_plant  = ARG_VAL(5)
   LET p_bookno = ARG_VAL(6)
   LET p_bookno1= ARG_VAL(7)
   LET gl_no    = ARG_VAL(8)
   LET gl_no1   = ARG_VAL(9)
   LET gl_date  = ARG_VAL(10)
   LET g_bgjob  = ARG_VAL(11)
   LET gl_seq   = ARG_VAL(12)        #FUN-B50122

   IF cl_null(g_bgjob) THEN LET g_bgjob= "N" END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
  
   CALL p701_create_temp_table()      #FUN-AB0110
   CALL p701_1_create_temp_table()    #FUN-B50122

   WHILE TRUE
      IF g_bgjob = 'N' THEN
         CALL aglp701_tm(0,0)
         IF cl_sure(21,21) THEN
            LET g_success = 'Y'
            BEGIN WORK
            CALL p701('0')
            IF g_aza.aza63 = 'Y' THEN
               CALL p701('1')
            END IF
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
               CLOSE WINDOW aglp701_w
               EXIT WHILE
            END IF
         END IF
      ELSE
         LET g_success = 'Y'
         BEGIN WORK
         CALL p701('0')
         IF g_aza.aza63 = 'Y' THEN
            CALL p701('1')
         END IF
         CALL s_showmsg()
         IF g_success = 'Y' THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         EXIT WHILE
      END  IF
   END WHILE
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

#-FUN-B50122-add-
FUNCTION p701_1_create_temp_table()

   DROP TABLE p701_1_tmp
   CREATE TEMP TABLE p701_1_tmp(
   abb00    LIKE abb_file.abb00,
   abb01    LIKE abb_file.abb01,
   abb02    LIKE abb_file.abb02,
   abb03    LIKE abb_file.abb03,
   abb04    LIKE abb_file.abb04,
   abb05    LIKE abb_file.abb05,
   abb06    LIKE abb_file.abb06,
   abb07f   LIKE abb_file.abb07f,
   abb07    LIKE abb_file.abb07,
   abb08    LIKE abb_file.abb08,
   abb11    LIKE abb_file.abb11,
   abb12    LIKE abb_file.abb12,
   abb13    LIKE abb_file.abb13,
   abb14    LIKE abb_file.abb14,
   abb15    LIKE abb_file.abb15,
   abb24    LIKE abb_file.abb24,
   abb25    LIKE abb_file.abb25,
   abb31    LIKE abb_file.abb31,
   abb32    LIKE abb_file.abb32,
   abb33    LIKE abb_file.abb33,
   abb34    LIKE abb_file.abb34,
   abb35    LIKE abb_file.abb35,
   abb36    LIKE abb_file.abb36,
   abb37    LIKE abb_file.abb37,
   abblegal LIKE abb_file.abblegal,
   l_order  LIKE type_file.chr30,
   oct00    LIKE oct_file.oct00,
   oct01    LIKE oct_file.oct01,
   oct02    LIKE oct_file.oct02,
   oct09    LIKE oct_file.oct09,
   oct10    LIKE oct_file.oct10,
   oct11    LIKE oct_file.oct11,
   oct16    LIKE oct_file.oct16,
   oct04    LIKE oct_file.oct04,
   oct13    LIKE oct_file.oct13,
   amt      LIKE type_file.chr30) 

END FUNCTION
#-FUN-B50122-end-

FUNCTION aglp701_tm(p_row,p_col)
DEFINE p_row,p_col       LIKE type_file.num5,
       l_cnt             LIKE type_file.num5
DEFINE lc_cmd            LIKE type_file.chr1000
DEFINE li_chk_bookno     LIKE type_file.chr1
DEFINE li_chk_bookno1    LIKE type_file.chr1
DEFINE li_result         LIKE type_file.num5
DEFINE l_sql             LIKE type_file.chr1000 
DEFINE l_no,l_no1        LIKE smy_file.smyslip
DEFINE l_aac03,l_aac03_1 LIKE aac_file.aac03
DEFINE l_aaa07           LIKE aaa_file.aaa07
  

   SELECT * INTO g_ooz.* 
     FROM ooz_file
    WHERE ooz00='0'
   LET g_year = YEAR(g_today)
   LET g_month = MONTH(g_today)
   LET p_plant = g_ooz.ooz02p
   LET p_bookno   = g_ooz.ooz02b
   LET p_bookno1  = g_ooz.ooz02c 
   LET b_user  = g_user
   LET e_user  = g_user
   LET gl_date = g_today
   LET g_bgjob = 'N'
   LET gl_seq  = '0'         #FUN-B50122
           
   IF s_shut(0) THEN RETURN END IF
   CALL s_dsmark(p_bookno)

   LET p_row = 4 LET p_col = 30

   OPEN WINDOW aglp701_w AT p_row,p_col WITH FORM "agl/42f/aglp701" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()

   CALL s_shwact(0,0,p_bookno)
   CALL cl_opmsg('q')
   IF g_aza.aza63='N' THEN
      CALL cl_set_comp_visible("p_bookno1,gl_no1",FALSE)
   END IF
   WHILE TRUE 
      CLEAR FORM 
      INPUT BY NAME g_year,g_month,b_user,e_user,
                    p_plant,p_bookno,gl_no,p_bookno1,gl_no1,gl_date,g_bgjob
                    ,gl_seq                                                     #FUN-B50122
            WITHOUT DEFAULTS 

         ON ACTION CONTROLR
            CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask()

         AFTER FIELD p_plant
            SELECT azp01 FROM azp_file WHERE azp01 = p_plant
            IF STATUS <> 0 THEN
               NEXT FIELD p_plant
            END IF
            LET g_plant_new= p_plant
           #CALL s_getdbs()        
            #LET g_dbs_gl=g_dbs_new CLIPPED
            LET g_plant_gl = g_plant_new  #FUN-A50102
    
         AFTER FIELD p_bookno
            IF p_bookno IS NULL THEN
               NEXT FIELD p_bookno
            END IF
            CALL s_check_bookno(p_bookno,g_user,p_plant)
                 RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
                 NEXT FIELD p_bookno
            END IF
            LET g_plant_new= p_plant
     #      CALL s_getdbs()
            LET l_sql = "SELECT COUNT(*)",
                        "  FROM ",cl_get_target_table(g_plant_new,'aaa_file'),
                        " WHERE aaa01 = '",p_bookno,"' ",
                        "   AND aaaacti IN ('Y','y') "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql
            PREPARE p700_pre1 FROM l_sql
            DECLARE p700_cur1 CURSOR FOR p700_pre1
            OPEN p700_cur1
            FETCH p700_cur1 INTO l_cnt
            IF l_cnt=0 THEN
                CALL cl_err('sel aaa',100,0)
                NEXT FIELD p_bookno
            END IF
    
         AFTER FIELD p_bookno1
            IF p_bookno1 IS NULL THEN
               NEXT FIELD p_bookno1
            END IF
            CALL s_check_bookno(p_bookno1,g_user,p_plant)
                 RETURNING li_chk_bookno1
            IF (NOT li_chk_bookno1) THEN
                 NEXT FIELD p_bookno1
            END IF
            LET g_plant_new= p_plant
           #CALL s_getdbs()
            LET l_sql = "SELECT COUNT(*)",
                        "  FROM ",cl_get_target_table(g_plant_new,'aaa_file'),
                        " WHERE aaa01 = '",p_bookno1,"' ",
                        "   AND aaaacti IN ('Y','y') "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql
            PREPARE p700_pre2 FROM l_sql
            DECLARE p700_cur2 CURSOR FOR p700_pre2
            OPEN p700_cur2
            FETCH p700_cur2 INTO l_cnt
            IF l_cnt=0 THEN
               CALL cl_err('sel aaa',100,0)
               NEXT FIELD p_bookno1
            END IF
    
         AFTER FIELD gl_no
            #LET g_dbs_gl = g_plant_new
            #CALL s_check_no("agl",gl_no,"","1","aba_file","aba01",g_dbs_gl) 
            LET g_plant_gl = g_plant_new  #FUN-A50102
            CALL s_check_no("agl",gl_no,"","1","aba_file","aba01",g_plant_gl) 
                  RETURNING li_result,gl_no
            IF (NOT li_result) THEN
               NEXT FIELD gl_no
            END IF
            LET l_no = gl_no
            SELECT aac03 INTO l_aac03 FROM aac_file WHERE aac01= l_no
            IF l_aac03 != '0' THEN
               CALL cl_err(gl_no,'agl-991',0)
               NEXT FIELD gl_no
            END IF
    
         AFTER FIELD gl_no1
            #LET g_dbs_gl = g_plant_new
            #CALL s_check_no("agl",gl_no1,"","1","aba_file","aba01",g_dbs_gl)  
            LET g_plant_gl = g_plant_new  #FUN-A50102
            CALL s_check_no("agl",gl_no1,"","1","aba_file","aba01",g_plant_gl)  
                  RETURNING li_result,gl_no1
            IF (NOT li_result) THEN
               NEXT FIELD gl_no1
            END IF
            LET l_no1 = gl_no1
            SELECT aac03 INTO l_aac03_1 FROM aac_file WHERE aac01= l_no1
            IF l_aac03_1 != '0' THEN
               CALL cl_err(gl_no1,'agl-991',0)
               NEXT FIELD gl_no1
            END IF
    
         AFTER FIELD b_user
            IF b_user IS NULL THEN
               NEXT FIELD b_user
            END IF
    
         AFTER FIELD e_user
            IF e_user IS NULL THEN
               NEXT FIELD e_user
            END IF
            IF e_user = 'Z' THEN
               LET e_user='z'
               DISPLAY BY NAME e_user
            END IF
    
         AFTER FIELD gl_date
            IF NOT cl_null(gl_date) THEN
               SELECT aaa07 INTO l_aaa07 FROM aaa_file
                WHERE aaa01 = p_bookno
               IF gl_date <= l_aaa07 THEN
                  NEXT FIELD gl_date
               END IF 
               SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file
                WHERE azn01 = gl_date
               IF STATUS THEN
                  CALL cl_err3("sel","azn_file",gl_date,"",SQLCA.sqlcode,"","read azn:",0)
                  NEXT FIELD gl_date
               END IF
              #-MOD-A90034-add-
               LET g_year  = g_yy 
               LET g_month = g_mm
               DISPLAY BY NAME g_year 
               DISPLAY BY NAME g_month 
              #-MOD-A90034-end-
            END IF

        #FUN-B50122--begin--
         AFTER FIELD gl_seq  
            IF cl_null(gl_seq) OR gl_seq NOT MATCHES '[0123]' THEN
               NEXT FIELD gl_seq 
            END IF
        #FUN-B50122---end---

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(gl_no)
               #  CALL s_getdbs()
                  #LET g_dbs_gl=g_plant_new
                  #CALL q_m_aac(FALSE,TRUE,g_dbs_gl,gl_no,'1','0',' ','AGL')
                  LET g_plant_gl = g_plant_new  #FUN-A50102
                  CALL q_m_aac(FALSE,TRUE,g_plant_gl,gl_no,'1','0',' ','AGL')#FUN-A50102
                  RETURNING gl_no
                  DISPLAY BY NAME gl_no
                  NEXT FIELD gl_no
               WHEN INFIELD(gl_no1)
               #  CALL s_getdbs()
                  #LET g_dbs_gl=g_plant_new
                  #CALL q_m_aac(FALSE,TRUE,g_dbs_gl,gl_no1,'1','0',' ','AGL')   
                  LET g_plant_gl = g_plant_new  #FUN-A50102
                  CALL q_m_aac(FALSE,TRUE,g_plant_gl,gl_no1,'1','0',' ','AGL')  #FUN-A50102  
                  RETURNING gl_no1
                  DISPLAY BY NAME gl_no1
                  NEXT FIELD gl_no1
            END CASE

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
         
         #TQC-AA0002--- add-begin---- 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
         #TQC-AA0002--- add--end-----

         ON ACTION about
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()

         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT

         BEFORE INPUT
            CALL cl_qbe_init()

         ON ACTION qbe_select
            CALL cl_qbe_select()

         ON ACTION qbe_save
            CALL cl_qbe_save()

   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW aglp701_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
  #-MOD-A90034-add-
   LET g_year  = g_yy 
   LET g_month = g_mm 
  #-MOD-A90034-end-
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01= 'aglp701'
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
          CALL cl_err('aglp701','9031',1)   
      ELSE
         LET lc_cmd = lc_cmd CLIPPED,
                      " ''",
                      " '",g_year CLIPPED,"'",
                      " '",g_month CLIPPED,"'",
                      " '",b_user CLIPPED,"'",
                      " '",e_user CLIPPED,"'",
                      " '",p_plant CLIPPED,"'",
                      " '",p_bookno CLIPPED,"'",
                      " '",p_bookno1 CLIPPED,"'",
                      " '",gl_no CLIPPED,"'",
                      " '",gl_no1 CLIPPED,"'",
                      " '",gl_date CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'",
                      " '",gl_seq CLIPPED,"'"     #FUN-B50122
         CALL cl_cmdat('aglp701',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW aglp701_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   EXIT WHILE
END WHILE
END FUNCTION
   
FUNCTION p701(l_npptype)
DEFINE l_npptype        LIKE npp_file.npptype
DEFINE l_sql            LIKE type_file.chr1000
DEFINE l_aaa07          LIKE aaa_file.aaa07
DEFINE l_aba11          LIKE aba_file.aba11
DEFINE l_aaz85          LIKE aaz_file.aaz85
DEFINE l_yy1            LIKE type_file.num5          #CHI-CB0004
DEFINE l_mm1            LIKE type_file.num5          #CHI-CB0004
#FUN-AB0110 --Begin
   DELETE FROM p701_tmp
   LET l_sql = "INSERT INTO p701_tmp VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?)"     #FUN-B50122
   PREPARE insert_prep FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
#FUN-AB0110 --End
   IF g_aza.aza63 = 'Y' THEN
      IF l_npptype = '0' THEN
         LET l_sql = " SELECT aznn02,aznn04 FROM ",
                     #cl_get_target_table(g_dbs_gl,'aznn_file'),
                     cl_get_target_table(g_plant_gl,'aznn_file'),  #FUN-A50102
                     "  WHERE aznn01 = '",gl_date,"' ",
                     "    AND aznn00 = '",p_bookno,"' "
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql            
         #CALL cl_parse_qry_sql(l_sql,g_dbs_gl) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,g_plant_gl) RETURNING l_sql    #FUN-A50102
         PREPARE aznn_pre1 FROM l_sql
         DECLARE aznn_cs1 CURSOR FOR aznn_pre1
         OPEN aznn_cs1
         FETCH aznn_cs1 INTO g_yy,g_mm
      ELSE
         LET l_sql = " SELECT aznn02,aznn04 FROM ",
                     #cl_get_target_table(g_dbs_gl,'aznn_file'),
                     cl_get_target_table(g_plant_gl,'aznn_file'),    #FUN-A50102
                     "  WHERE aznn01 = '",gl_date,"' ",
                     "    AND aznn00 = '",p_bookno1,"' "
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql            
         #CALL cl_parse_qry_sql(l_sql,g_dbs_gl) RETURNING l_sql  
         CALL cl_parse_qry_sql(l_sql,g_plant_gl) RETURNING l_sql    #FUN-A50102    
         PREPARE aznn_pre2 FROM l_sql
         DECLARE aznn_cs2 CURSOR FOR aznn_pre2
         OPEN aznn_cs2
         FETCH aznn_cs2 INTO g_yy,g_mm
      END IF
   ELSE
      SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file
       WHERE azn01 = gl_date
   END IF
   LET g_year  = g_yy                     #MOD-A90034 
   LET g_month = g_mm                     #MOD-A90034
   IF NOT cl_null(gl_date) THEN 
      IF l_npptype ='0' THEN
         SELECT aaa07 INTO l_aaa07 FROM aaa_file
                WHERE aaa01 = p_bookno
      ELSE
         SELECT aaa07 INTO l_aaa07 FROM aaa_file
                WHERE aaa01 = p_bookno1
      END IF
      IF gl_date <= l_aaa07 THEN
         IF g_bgjob = 'Y' THEN
            CALL s_errmsg('','','','axr-164',1)
         ELSE
            CALL cl_err('','axr-164',0)
         END IF
         LET g_success = 'N'
         RETURN
      END IF
   END IF
   IF g_aaz.aaz81 = 'Y' THEN
      LET l_yy1 = YEAR(gl_date)    #CHI-CB0004
      LET l_mm1 = MONTH(gl_date)   #CHI-CB0004
      IF g_aza.aza63 = 'Y' THEN
         IF l_npptype = '0' THEN
            LET g_sql = "SELECT MAX(aba11)+1 FROM ",
                        #cl_get_target_table(g_dbs_gl,'aba_file'),
                        cl_get_target_table(g_plant_gl,'aba_file'),   #FUN-A50102
                        " WHERE aba00 =  '",p_bookno,"'"
                       ,"   AND aba19 <> 'X' "  #CHI-C80041
                       ,"   AND YEAR(aba02) = '",l_yy1,"' AND MONTH(aba02) = '",l_mm1,"'"  #CHI-CB0004
         ELSE
            LET g_sql = "SELECT MAX(aba11)+1 FROM ",
                        #cl_get_target_table(g_dbs_gl,'aba_file'),
                        cl_get_target_table(g_plant_gl,'aba_file'),   #FUN-A50102
                        " WHERE aba00 =  '",p_bookno1,"'"
                       ,"   AND aba19 <> 'X' "  #CHI-C80041
                       ,"   AND YEAR(aba02) = '",l_yy1,"' AND MONTH(aba02) = '",l_mm1,"'"  #CHI-CB0004
         END IF

         CALL cl_replace_sqldb(g_sql) RETURNING g_sql            
         #CALL cl_parse_qry_sql(g_sql,g_dbs_gl) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql    #FUN-A50102
         PREPARE aba11_pre FROM g_sql
         EXECUTE aba11_pre INTO l_aba11
      ELSE
        SELECT MAX(aba11)+1 INTO l_aba11 FROM aba_file
          WHERE aba00 = p_bookno
            AND aba19 <> 'X'  #CHI-C80041
            AND YEAR(aba02) = l_yy1 AND MONTH(aba02) = l_mm1  #CHI-CB0004
      END IF
     #CHI-CB0004--(B)
      IF cl_null(l_aba11) OR l_aba11 = 1 THEN
         LET l_aba11 = YEAR(gl_date)*1000000+MONTH(gl_date)*10000+1
      END IF
     #CHI-CB0004--(E)
     #IF cl_null(l_aba11) THEN LET l_aba11 = 1 END IF  #CHI-CB0004
      LET g_aba.aba11 = l_aba11
   ELSE
      LET g_aba.aba11 = ' '
   END IF

   LET g_sql = "SELECT aaz85 FROM ",
               #         cl_get_target_table(g_dbs_gl,'aaz_file'),
                        cl_get_target_table(g_plant_gl,'aaz_file'), #FUN-A50102
               " WHERE aaz00 = '0' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql          
   #CALL cl_parse_qry_sql(g_sql,g_dbs_gl) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql    #FUN-A50102
   PREPARE aaz85_pre FROM g_sql
   DECLARE aaz85_cs CURSOR FOR aaz85_pre
   OPEN aaz85_cs
   FETCH aaz85_cs INTO l_aaz85
   IF STATUS THEN
      CALL cl_err('sel aaz85',STATUS,1)
      RETURN
   END IF
   LET g_sql="SELECT * FROM oct_file ",
             " WHERE oct09 = '",g_year,"'",
             "   AND oct10 = '",g_month,"'",
             "   AND oct08 IS NULL ",
            #"   AND (oct16 = '2' OR oct16 = '4') ",  #<--ADD BY dxfwo #NO.FUN-A60007
             "   AND oct16 <> '1'",                   #FUN-AB0110
             "   AND oct00 = '",l_npptype,"'"         #FUN-A60007
            #" ORDER BY oct17,oct16,oct01,oct02,oct03,oct09,oct10 "    #FUN-B50122

   #FUN-B50122--begin--
   CASE WHEN gl_seq = '0' 
        LET g_sql = g_sql CLIPPED," ORDER BY oct17,oct16,oct01,oct02,oct03,oct09,oct10 "
        WHEN gl_seq = '1'
        LET g_sql = g_sql CLIPPED," ORDER BY oct13,oct17,oct16,oct01,oct02,oct03,oct09,oct10 "
        WHEN gl_seq = '2'
        LET g_sql = g_sql CLIPPED," ORDER BY oct23,oct17,oct16,oct01,oct02,oct03,oct09,oct10 "
        OTHERWISE 
        LET g_sql = g_sql CLIPPED," ORDER BY oct17,oct16,oct01,oct02,oct03,oct09,oct10 "
   END CASE
  #FUN-B50122---end---
 
   PREPARE p701_1_p0 FROM g_sql
   IF STATUS THEN
      CALL cl_err('p701_1_p0',STATUS,1)
      CALL cl_batch_bg_javamail("N") 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
   DECLARE p701_1_c0 CURSOR WITH HOLD FOR p701_1_p0


#--FUN-A60007 mark--
#   LET g_sql="SELECT * FROM oct_file ",
#             " WHERE oct09 = '",g_year,"'",
#             "   AND oct10 = '",g_month,"'",
#             "   AND oct081 IS NULL ",
#             "   AND (oct16 = '2' OR oct16 = '4') ",  #<--ADD BY dxfwo #NO.FUN-A60007
#             "   AND oct00 = '",l_npptype,"'",        #FUN-A60007
#             " ORDER BY oct17,oct16,oct01,oct02,oct03,oct09,oct10 "
# 
#   PREPARE p701_1_p1 FROM g_sql
#   IF STATUS THEN
#      CALL cl_err('p701_1_p1',STATUS,1)
#      CALL cl_batch_bg_javamail("N") 
#      EXIT PROGRAM
#   END IF
#   DECLARE p701_1_c1 CURSOR WITH HOLD FOR p701_1_p1
#--FUN-A60007 mark---

   CALL s_showmsg_init() 
   IF l_npptype = '0' THEN  
      CALL p701_1()
   ELSE
      CALL p701_2()
   END IF
   IF STATUS THEN
      CALL s_errmsg('','','foreach:',STATUS,1)    
      LET g_success = 'N'
   END IF
END FUNCTION

FUNCTION p701_1()
DEFINE l_abb          RECORD LIKE abb_file.*
DEFINE l_oba          RECORD LIKE oba_file.*
DEFINE l_oct          RECORD LIKE oct_file.*        
DEFINE l_aac          RECORD LIKE aac_file.*        
DEFINE l_seq                 LIKE type_file.num5
DEFINE ar_user               LIKE oma_file.omauser
DEFINE l_p1                  LIKE aba_file.aba06
DEFINE l_p2                  LIKE aba_file.aba08
DEFINE l_p3,l_p4             LIKE type_file.chr1
DEFINE li_result             LIKE type_file.num5
DEFINE l_aba01t              LIKE aba_file.aba01
DEFINE l_sql                 STRING #FUN-A30006
DEFINE l_ool41               LIKE ool_file.ool41  #FUN-A30006
DEFINE l_omb33               LIKE omb_file.omb33  #FUN-A30006
DEFINE l_oma33               LIKE oma_file.oma33  #FUN-A60007 
#FUN-A10005 --Begin
DEFINE l_oma930              LIKE oma_file.oma930
DEFINE l_oma15               LIKE oma_file.oma15 
DEFINE l_oma63               LIKE oma_file.oma63 
DEFINE l_omb40               LIKE omb_file.omb40
#FUN-A10005 --End
DEFINE l_oma34               LIKE oma_file.oma34  #MOD-A80025
DEFINE l_ool42               LIKE ool_file.ool42  #MOD-A80025
DEFINE l_ool47               LIKE ool_file.ool47  #MOD-A80025
DEFINE l_omalegal            LIKE oma_file.omalegal
DEFINE l_omblegal            LIKE omb_file.omblegal
DEFINE l_aag05               LIKE aag_file.aag05  #FUN-AB0110
DEFINE l_aag21               LIKE aag_file.aag21  #FUN-AB0110
DEFINE l_aag23               LIKE aag_file.aag23  #FUN-AB0110
DEFINE l_oct04               LIKE oct_file.oct04  #FUN-AB0110
DEFINE l_oct09               LIKE oct_file.oct09  #FUN-AB0110
DEFINE l_oct10               LIKE oct_file.oct10  #FUN-AB0110
DEFINE l_oct11               LIKE oct_file.oct11  #FUN-AB0110
DEFINE l_oct13               LIKE oct_file.oct13  #FUN-AB0110
DEFINE l_amt                 LIKE oct_file.oct14  #FUN-AB0110
DEFINE l_amt_f               LIKE oct_file.oct14f #FUN-AB0110
DEFINE l_type                LIKE type_file.chr1  #FUN-AB0110
DEFINE l_order               LIKE type_file.chr30 #FUN-B50122
DEFINE l_abb03               LIKE abb_file.abb03  #FUN-B50122
DEFINE l_abb06               LIKE abb_file.abb06  #FUN-B50122
DEFINE l_abb24               LIKE abb_file.abb24  #FUN-B50122
DEFINE l_abb25               LIKE abb_file.abb25  #FUN-B50122
DEFINE l_oct23               LIKE oct_file.oct23  #FUN-B50122
DEFINE l_order_t             LIKE type_file.chr30 #FUN-B50122
DEFINE li_count              SMALLINT             #FUN-B50122

   LET g_debit = 0
   LET g_credit = 0
   LET g_plant_new= p_plant
  #CALL s_getdbs()
  #LET g_dbs_gl=g_plant_new CLIPPED
  #CALL s_auto_assign_no("agl",gl_no,gl_date,"1","","",g_dbs_gl,"",g_ooz.ooz02b)
   LET g_plant_gl=g_plant_new CLIPPED    #FUN-A50102
   LET g_no2 = gl_no              #FUN-B50122 傳單別
  #FUN-B50122--Begin Mark--
  #CALL s_auto_assign_no("agl",gl_no,gl_date,"1","","",g_plant_gl,"",g_ooz.ooz02b)   #FUN-A50102
  #    RETURNING li_result,gl_no
  #IF li_result = 0 THEN LET g_success = 'N' END IF
  #IF g_bgjob = "N" THEN            
  #    MESSAGE    "Insert G/L voucher no:",gl_no
  #    CALL ui.Interface.refresh()
  #END IF
  #FUN-B50122---END Mark--- 

   LET l_seq = 0
   FOREACH p701_1_c0 INTO l_oct.*
#FUN-A30006 --Begin
#     SELECT * INTO l_oba.*
#       FROM oba_file,ima_file
#      WHERE ima01 = l_oct.oct03
#        AND ima131 = oba01
#     SELECT azp03 INTO g_dbs_new FROM azp_file
#      WHERE azp01 = l_oct.oct17
#     IF STATUS THEN
#        LET g_dbs_new = NULL
#     END IF
#     LET g_dbs_oct17 = s_dbstring(g_dbs_new CLIPPED)
      IF l_oct.oct16 = '2' THEN #FUN-AB0110 #銷貨收入類遞延才要找原始單據是否有拋傳票
  ##NO.FUN-A60007   --begin                                                                                                         
         LET l_sql = " SELECT oma33,omalegal FROM ",
                     cl_get_target_table(l_oct.oct17,'oma_file,'),
                     cl_get_target_table(l_oct.oct17,'omb_file'),
                     "  WHERE oma01 = omb01 ",
                     "    AND omb01= '",l_oct.oct01,"'",
                     "    AND omb03= '",l_oct.oct02,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
         CALL cl_parse_qry_sql(l_sql,l_oct.oct17) RETURNING l_sql #FUN-A50102           
         PREPARE p701_pre10 FROM l_sql
         DECLARE p701_cs10 CURSOR FOR p701_pre10
         OPEN p701_cs10
         FETCH p701_cs10 INTO l_oma33,l_omalegal
         CLOSE p701_cs10
         IF cl_null(l_oma33) THEN
             LET g_showmsg=l_oct.oct01,'/',l_oct.oct02
             CALL s_errmsg('oma01,oma02',g_showmsg,'','agl-257',1)
             CONTINUE FOREACH
         END IF
  ##NO.FUN-A60007   --end
      END IF                                           #FUN-AB0110 add

      LET l_sql = " SELECT omb33,omb40,omblegal FROM ",#FUN-A10005 add omb40
                 cl_get_target_table(l_oct.oct17,'omb_file'),
                  "  WHERE omb01= '",l_oct.oct01,"'",
                  "    AND omb03= '",l_oct.oct02,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,l_oct.oct17) RETURNING l_sql
      DECLARE p701_omb33 SCROLL CURSOR FROM l_sql
      OPEN p701_omb33
      FETCH p701_omb33 INTO l_omb33,l_omb40,l_omblegal #FUN-A10005 add l_omb40
      CLOSE p701_omb33
      #IF cl_null(l_omb33) THEN  #MOD-A80025
         #LET l_sql = "SELECT ool41 FROM ",g_dbs_oct17,"ool_file,",g_dbs_oct17,"oma_file",
         LET l_sql = "SELECT oma34,ool41,ool42,ool47 FROM ",   #MOD-A80025
                      cl_get_target_table(l_oct.oct17,'ool_file,'),
                      cl_get_target_table(l_oct.oct17,'oma_file'),
                     " WHERE oma01 = '",l_oct.oct01,"'",
                     "   AND oma13 = ool01 "
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_oct.oct17) RETURNING l_sql
        
         DECLARE p701_ool41 SCROLL CURSOR FROM l_sql
         OPEN p701_ool41
         #FETCH p701_ool41 INTO l_ool41
         FETCH p701_ool41 INTO l_oma34,l_ool41,l_ool42,l_ool47  #MOD-A80025
         CLOSE p701_ool41
         IF cl_null(l_omb33) THEN   #MOD-A80025
#           IF l_oct.oct16 = '2' THEN    #MOD-A80025 #FUN-AB0110 mark
                IF NOT cl_null(l_ool41) THEN LET l_omb33 = l_ool41 END IF
#           END IF   #MOD-A80025                     #FUN-AB0110 mark
         END IF      #MOD-A80025
#FUN-AB0110 --Begin
#折讓類遞延反向科目先取oct_file中本身資料的oct20
#如果取不到資料則用科目類別預設
         IF l_oct.oct16 <> '2' THEN
            IF cl_null(l_oct.oct20) THEN
               SELECT oct20 INTO l_oct.oct20
                 FROM oct_file
                WHERE oct00 = l_oct.oct00
                  AND oct04 = l_oct.oct04 #出貨單號
                  AND oct05 = l_oct.oct05 #出貨項次
                  AND oct11 = l_oct.oct11
                  AND oct16 = '1'
               IF cl_null(l_oct.oct20) THEN
                  LET l_oct.oct20 = l_omb33
               END IF
            END IF
         END IF
#FUN-AB0110 --End

#FUN-AB0110 --Begin mark
#        #--MOD-A80025 start--
#        IF l_oct.oct16 = '4' THEN
#            IF l_oma34 ='5' THEN
#               LET l_omb33=l_ool47
#            ELSE
#               LET l_omb33=l_ool42
#            END IF
#        END IF  
#        #--MOD-A80025 end--
#     #END IF  #MOD-A80025
#FUN-AB0110 --End mark
#FUN-A30006 --End
#     LET l_seq = l_seq + 1    #FUN-AB0110
      
      LET g_oma03 = ''          #MOD-B10115 
#FUN-A30006 --Begin
#     SELECT omauser INTO ar_user
#       FROM oma_file WHERE oma01= l_oct.oct01
     #LET l_sql = " SELECT omauser,oma930,oma15,oma63 FROM ",#FUN-A10005 add oma930,oma15,oma63       #MOD-B10115 mark
      LET l_sql = " SELECT omauser,oma930,oma15,oma63,oma03 FROM ",#FUN-A10005 add oma930,oma15,oma63 #MOD-B10115
                      cl_get_target_table(l_oct.oct17,'oma_file'),
                  "  WHERE oma01= '",l_oct.oct01,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,l_oct.oct17) RETURNING l_sql
      DECLARE p701_omauser SCROLL CURSOR FROM l_sql
      OPEN p701_omauser
      FETCH p701_omauser INTO ar_user,l_oma930,l_oma15,l_oma63,g_oma03 #FUN-A10005 add l_oma930,l_oma15,l_oma63 #MOD-B10115 add oma03
      CLOSE p701_omauser
#FUN-A30006 --End
      IF ar_user<b_user OR ar_user>e_user THEN CONTINUE FOREACH END IF
      
      IF g_success = 'Y' THEN  #FUN-A60007 add
#FUN-AB0110 --Begin mark
#         UPDATE oct_file SET oct08 = gl_no
#          WHERE oct01 = l_oct.oct01
#            AND oct02 = l_oct.oct02
#            AND oct09 = l_oct.oct09
#            AND oct10 = l_oct.oct10
#            AND oct11 = l_oct.oct11
#            AND oct16 = l_oct.oct16
#            AND oct00 = l_oct.oct00   #FUN-A60007
#         IF SQLCA.sqlcode THEN
#            CALL cl_err3("upd","oct_file",l_oct.oct01,l_oct.oct02,SQLCA.sqlcode,"","upd oct08/glno:",1)
#            LET g_success = 'N'
#         END IF
#FUN-AB0110 --End mark
  
          LET g_sql="INSERT INTO ",
                    " p701_1_tmp ",                                #FUN-B50122
                   # cl_get_target_table(g_dbs_gl,'abb_file'),
                   # cl_get_target_table(g_plant_gl,'abb_file'),   #FUN-B50122 Mark  #FUN-A50102
                    "(abb00,abb01,abb02,abb03,abb04,",
                    " abb05,abb06,abb07f,abb07,",
                    " abb08,abb11,abb12,abb13,abb14,abb15,abb24,abb25,",
                    " abb31,abb32,abb33,abb34,abb35,abb36,abb37,abblegal,",
                    " l_order,oct00,oct01,oct02,oct09,",               #FUN-B50122
                    " oct10,oct11,oct16,oct04,oct13,",                 #FUN-B50122
                    " amt)",                                           #FUN-B50122
                    " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                    "       ,?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",        #FUN-B50122
                    "       ,?,?,?,?,?, ?)"                            #FUN-B50122
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql     
          #CALL cl_parse_qry_sql(g_sql,g_dbs_gl) RETURNING l_sql
          CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql      #FUN-A50102 
          PREPARE p701_1_p5 FROM g_sql
   
          #--寫入傳票單身--
          #oct16 =1.總遞延收入      (借:銷貨收入oba11,貸:遞延收入oct13,金額:oct12,oct12f)
          #oct16 =2.衝轉每期遞延收入(借:遞延收入oct13,貸:銷貨收入oba11,金額:oct14,oct14f)
          #oct16 =3.總遞延收入(折讓)(借:遞延收入oct13,貸:銷貨收入oba11,金額:oct12,oct12f)
          #oct16 =4.如有折讓時,需每期做銷貨收入回轉
          #(借:銷貨收入oba11,貸:遞延收入oct13,金額:oct15,oct15f)
   
          LET l_abb.abb00 = g_ooz.ooz02b
          LET l_abb.abb01 = gl_no
#         LET l_abb.abb02 = l_seq    #FUN-AB0110 mark
          LET l_abb.abb04 = l_oct.oct01,'/',l_oct.oct02,'/',l_oct.oct03  #摘要
          LET l_abb.abb06 = '1'            #借/貸
          LET l_abb.abb24 = l_oct.oct18    #原幣幣別
          LET l_abb.abb25 = l_oct.oct19    #匯率
          CASE
             WHEN l_oct.oct16 = '1'    
#               LET l_abb.abb03 = l_oba.oba11 #FUN-A30006
#               LET l_abb.abb03 = l_omb33     #FUN-A30006
                LET l_abb.abb03 = l_oct.oct20 #FUN-AB0110
                LET l_abb.abb07 = l_oct.oct12
                LET l_abb.abb07f= l_oct.oct12f
             WHEN l_oct.oct16 = '2'
                LET l_abb.abb03 = l_oct.oct13
                LET l_abb.abb07 = l_oct.oct14
                LET l_abb.abb07f= l_oct.oct14f
                LET l_type = '1'     #FUN-AB0110
             WHEN l_oct.oct16 = '3'    
                LET l_abb.abb03 = l_oct.oct13
                LET l_abb.abb07 = l_oct.oct12
                LET l_abb.abb07f= l_oct.oct12f
             WHEN l_oct.oct16 = '4'
#               LET l_abb.abb03 = l_oba.oba11 #FUN-A30006
#               LET l_abb.abb03 = l_omb33     #FUN-A30006
                LET l_abb.abb03 = l_oct.oct20 #FUN-AB0110
                LET l_abb.abb07 = l_oct.oct15
                LET l_abb.abb07f= l_oct.oct15f
                LET l_type = '2'     #FUN-AB0110
          END CASE
        #FUN-B50122--begin--
         CASE WHEN gl_seq = '0' LET l_order = ' '         # 傳票區分項目
              WHEN gl_seq = '1' LET l_order = l_abb.abb03 # 依會計科目
              WHEN gl_seq = '2' LET l_order = l_oct.oct23 # 依客戶
              OTHERWISE         LET l_order = ' '
         END CASE
        #FUN-B50122---end---
#FUN-A10005 --Begin
          CALL p701_set_values(l_abb.*,l_oma930,l_oma15,l_oma63,l_omb40,l_oct.oct01) 
          RETURNING l_abb.*
#         LET l_abb.abb05 = ''
#         LET l_abb.abb15 = ''
#         LET l_abb.abb08 = ''
#         SELECT aag05,aag21,aag23 
#           INTO l_aag05,l_aag21,l_aag23
#           FROM aag_file
#          WHERE aag00 = l_abb.abb00
#            AND aag01 = l_abb.abb03

#         IF l_aag05 = 'Y' THEN
#            IF g_aaz.aaz90='Y' THEN
#               LET l_abb.abb05 = l_oma930
#            ELSE
#               LET l_abb.abb05 = l_oma15
#            END IF
#         END IF
#
#         IF l_aag21 = 'Y' THEN
#            LET l_abb.abb15 = l_omb40
#         END IF

#         IF l_aag23 = 'Y' THEN
#            LET l_abb.abb08 = l_oma63
#         END IF
#             
#         CALL p701_def_abb(l_abb.abb03,'aglp701',l_abb.*,l_abb.abb01,'','',l_abb.abb00)
#         RETURNING l_abb.*
#FUN-A10005 --End
          IF l_oct.oct16 = '3' THEN          #FUN-AB0110
             LET l_seq = l_seq + 1           #FUN-AB0110
             LET l_abb.abb02 = l_seq         #FUN-AB0110
             LET l_abb.abblegal = l_omblegal
             EXECUTE p701_1_p5 USING
                l_abb.abb00,l_abb.abb01,l_abb.abb02,l_abb.abb03,l_abb.abb04,
                l_abb.abb05,l_abb.abb06,l_abb.abb07f,l_abb.abb07,l_abb.abb08,
                l_abb.abb11,l_abb.abb12,l_abb.abb13,l_abb.abb14,l_abb.abb15,
                l_abb.abb24,l_abb.abb25,l_abb.abb31,l_abb.abb32,l_abb.abb33,
                l_abb.abb34,l_abb.abb35,l_abb.abb36,l_abb.abb37,l_abb.abblegal,
                l_order,l_oct.oct00,l_oct.oct01,l_oct.oct02,l_oct.oct09,         #FUN-B50122
                l_oct.oct10,l_oct.oct11,l_oct.oct16,'','',''                     #FUN-B50122
             IF SQLCA.sqlcode THEN
               #CALL cl_err3("ins","abb_file",gl_no,l_seq,SQLCA.sqlcode,"","ins abb:",1)    #FUN-B50122
                CALL cl_err3("ins","p701_1_tmp",gl_no,l_seq,SQLCA.sqlcode,"","ins abb:",1)  #FUN-B50122
                LET g_success = 'N'
             END IF
            #FUN-B50122--Begin Mark--  
            #---FUN-AB0110 start--
            #IF g_success = 'Y' THEN
            #    UPDATE oct_file SET oct08 = gl_no,
            #                        oct22 = l_abb.abb02
            #     WHERE oct01 = l_oct.oct01
            #       AND oct02 = l_oct.oct02
            #       AND oct09 = l_oct.oct09
            #       AND oct10 = l_oct.oct10
            #       AND oct11 = l_oct.oct11
            #       AND oct16 = l_oct.oct16
            #       AND oct00 = l_oct.oct00   #FUN-A60007
            #    IF SQLCA.sqlcode THEN
            #       CALL cl_err3("upd","oct_file",l_oct.oct01,l_oct.oct02,SQLCA.sqlcode,"","upd oct08/glno:",1)
            #       LET g_success = 'N'
            #    END IF
            #END IF
            #--FUN-AB0110 end--
            #FUN-B50122---End Mark---

             LET g_debit  =g_debit  + l_abb.abb07   #No.FUN-9A0036 借方

            #FUN-AB0110 --Begin mark
            #LET l_seq = l_seq + 1
            #LET l_abb.abb02 = l_seq 
            #LET l_abb.abb06 = '2'
            #FUN-AB0110 --End mark
#FUN-AB0110 --Begin
          ELSE
             EXECUTE insert_prep USING l_oct.oct00,
                                       l_oct.oct09,l_oct.oct10,
                                       l_oct.oct04,l_oct.oct11,
                                       l_abb.abb03,l_oct.oct14,
                                       l_oct.oct14f,l_oct.oct15,
                                       l_oct.oct15f,l_oct.oct16,l_type,
                                       l_oct.oct23                       #FUN-B50122
          END IF
          LET l_abb.abb06 = '2' 
#FUN-AB0110 --End
          CASE
             WHEN l_oct.oct16 = '1'    
                LET l_abb.abb03 = l_oct.oct13
                LET l_abb.abb07 = l_oct.oct12
                LET l_abb.abb07f= l_oct.oct12f
             WHEN l_oct.oct16 = '2'
#               LET l_abb.abb03 = l_oba.oba11 #FUN-A30006
#               LET l_abb.abb03 = l_omb33     #FUN-A30006
                LET l_abb.abb03 = l_oct.oct20 #FUN-AB0110
                LET l_abb.abb07 = l_oct.oct14
                LET l_abb.abb07f= l_oct.oct14f
                LET l_type = '2'              #FUN-AB0110
             WHEN l_oct.oct16 = '3'    
#               LET l_abb.abb03 = l_oba.oba11 #FUN-A30006
#               LET l_abb.abb03 = l_omb33     #FUN-A30006
                LET l_abb.abb03 = l_oct.oct20 #FUN-AB0110
                LET l_abb.abb07 = l_oct.oct12
                LET l_abb.abb07f= l_oct.oct12f
             WHEN l_oct.oct16 = '4'
                LET l_abb.abb03 = l_oct.oct13
                LET l_abb.abb07 = l_oct.oct15
                LET l_abb.abb07f= l_oct.oct15f
                LET l_type = '1'              #FUN-AB0110 
          END CASE
        #FUN-B50122--begin--
         CASE WHEN gl_seq = '0' LET l_order = ' '         # 傳票區分項目
              WHEN gl_seq = '1' LET l_order = l_abb.abb03 # 依會計科目
              WHEN gl_seq = '2' LET l_order = l_oct.oct23 # 依客戶
              OTHERWISE         LET l_order = ' '
         END CASE
        #FUN-B50122---end---
          CALL p701_set_values(l_abb.*,l_oma930,l_oma15,l_oma63,l_omb40,l_oct.oct01) #FUN-A10005
          RETURNING l_abb.*
          #--FUN-AB0110 start--
          IF l_oct.oct16 = '3' THEN
              LET l_seq = l_seq + 1
              LET l_abb.abb02 = l_seq
          #--FUN-AB0110  end--
              EXECUTE p701_1_p5 USING
                  l_abb.abb00,l_abb.abb01,l_abb.abb02,l_abb.abb03,l_abb.abb04,
                  l_abb.abb05,l_abb.abb06,l_abb.abb07f,l_abb.abb07,l_abb.abb08,
                  l_abb.abb11,l_abb.abb12,l_abb.abb13,l_abb.abb14,l_abb.abb15,
                  l_abb.abb24,l_abb.abb25,l_abb.abb31,l_abb.abb32,l_abb.abb33,
                  l_abb.abb34,l_abb.abb35,l_abb.abb36,l_abb.abb37,l_abb.abblegal,
                  l_order,l_oct.oct00,l_oct.oct01,l_oct.oct02,l_oct.oct09,       #FUN-B50122
                  l_oct.oct10,l_oct.oct11,l_oct.oct16,'','',''                   #FUN-B50122
              IF SQLCA.sqlcode THEN
                #CALL cl_err3("ins","abb_file",gl_no,l_seq,SQLCA.sqlcode,"","ins abb:",1)     #FUN-B50122
                 CALL cl_err3("ins","p701_1_tmp",gl_no,l_seq,SQLCA.sqlcode,"","ins abb:",1)   #FUN-B50122
                 LET g_success = 'N'
              END IF
              LET g_credit = g_credit + l_abb.abb07     #No.FUN-9A0036 貸方
#FUN-AB0110 --Begin
           ELSE
              EXECUTE insert_prep USING l_oct.oct00,
                                        l_oct.oct09,l_oct.oct10,
                                        l_oct.oct04,l_oct.oct11,
                                        l_abb.abb03,l_oct.oct14,
                                        l_oct.oct14f,l_oct.oct15,
                                        l_oct.oct15f,l_oct.oct16,l_type,
                                        l_oct.oct23                        #FUN-B50122
           END IF
#FUN-AB00110 --End
       END IF   #FUN-A60007 add
   END FOREACH
     
#FUN-AB0110 --Begin
   #將p701_tmp的資料依年/月/出貨單/售貨動作/科目為GROUP,SUM(oct14-oct15)
   #金額大於0才切分錄進傳票,金額=0則不處理(代表銷退額為全退)
   DECLARE p701_tmp_cs1 CURSOR FOR
      SELECT oct09,oct10,oct04,oct11,oct13,SUM(oct14-oct15),SUM(oct14f-oct15f),oct23   #FUN-B50122
        FROM p701_tmp
       WHERE type = '1'
         AND oct00 = '0'
       GROUP BY oct09,oct10,oct04,oct11,oct13,oct23                                    #FUN-B50122
       ORDER BY oct13
   FOREACH p701_tmp_cs1 INTO l_oct09,l_oct10,l_oct04,l_oct11,l_oct13,l_amt,l_amt_f,l_oct23     #FUN-B50122
      IF SQLCA.sqlcode THEN
         LET g_showmsg= l_oct04,l_oct11,l_oct13
         CALL s_errmsg('oct04,oct11,oct13',g_showmsg,'p701_tmp_cs1',SQLCA.sqlcode,1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
      IF l_amt <> 0 THEN
         #LET g_sql = "INSERT INTO ",cl_get_target_table(g_plant_gl,'abb_file'),       #FUN-B50122
          LET g_sql = "INSERT INTO p701_1_tmp",                                        #FUN-B50122
                                   "(abb00,abb01,abb02,abb03,abb04,",
                                   " abb05,abb06,abb07f,abb07,",
                                   " abb08,abb11,abb12,abb13,abb14,abb15,abb24,abb25,",
                                   " abb31,abb32,abb33,abb34,abb35,abb36,abb37,abblegal,",
                                   " l_order,oct00,oct01,oct02,oct09,",                #FUN-B50122
                                   " oct10,oct11,oct16,oct04,oct13,",                  #FUN-B50122
                                   " amt)",                                            #FUN-B50122
                      " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?",
                      "       ,?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?",                       #FUN-B50122
                      "       ,?,?,?,?,?, ?)"                                          #FUN-B50122
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql
          CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql
          PREPARE p701_1_p5_3 FROM g_sql

          LET l_abb.abb00 = g_ooz.ooz02b
          LET l_abb.abb01 = gl_no
          LET l_abb.abb04 = l_oct.oct04
          LET l_abb.abb06 = '1'
          LET l_abb.abb24 = l_oct.oct18
          LET l_abb.abb25 = l_oct.oct19
          LET l_abb.abb07 = l_amt
          LET l_abb.abb07f= l_amt_f
          LET l_order = l_oct23             #FUN-B50122
          IF l_amt < 0 THEN
              LET l_abb.abb03 = l_oct.oct20
              LET l_abb.abb07 = l_abb.abb07 * -1
              LET l_abb.abb07f= l_abb.abb07f * -1
          ELSE
              LET l_abb.abb03 = l_oct.oct13
          END IF
         #-MOD-B10115-mark-
         #LET l_abb.abb05 = ''
         #LET l_abb.abb15 = ''
         #LET l_abb.abb08 = ''
         #SELECT aag05,aag21,aag23
         #  INTO l_aag05,l_aag21,l_aag23
         #  FROM aag_file
         # WHERE aag00 = l_abb.abb00
         #   AND aag01 = l_abb.abb03

         #IF l_aag05 = 'Y' THEN
         #   IF g_aaz.aaz90='Y' THEN
         #      LET l_abb.abb05 = l_oma930
         #   ELSE
         #      LET l_abb.abb05 = l_oma15
         #   END IF
         #END IF

         #IF l_aag21 = 'Y' THEN
         #   LET l_abb.abb15 = l_omb40
         #END IF

         #IF l_aag23 = 'Y' THEN
         #   LET l_abb.abb08 = l_oma63
         #END IF

         #CALL p701_def_abb(l_abb.abb03,'aglp701',l_abb.*,l_abb.abb01,'','',l_abb.abb00)
         #RETURNING l_abb.*
         #-MOD-B10115-end-
          CALL p701_set_values(l_abb.*,l_oma930,l_oma15,l_oma63,l_omb40,l_oct.oct01)
          RETURNING l_abb.*

          LET l_seq = l_seq + 1
          LET l_abb.abb02 = l_seq
          LET l_abb.abblegal = l_oct.octlegal

          EXECUTE p701_1_p5_3 USING
             l_abb.abb00,l_abb.abb01,l_abb.abb02,l_abb.abb03,l_abb.abb04,
             l_abb.abb05,l_abb.abb06,l_abb.abb07f,l_abb.abb07,l_abb.abb08,
             l_abb.abb11,l_abb.abb12,l_abb.abb13,l_abb.abb14,l_abb.abb15,
             l_abb.abb24,l_abb.abb25,l_abb.abb31,l_abb.abb32,l_abb.abb33,
             l_abb.abb34,l_abb.abb35,l_abb.abb36,l_abb.abb37,l_abb.abblegal,
             l_order,'0','','',l_oct09,l_oct10,l_oct11,'',l_oct04,l_oct13,l_amt             #FUN-B50122 add
          IF SQLCA.sqlcode THEN
            #CALL cl_err3("ins","abb_file",gl_no,l_seq,SQLCA.sqlcode,"","ins abb:",1)       #FUN-B50122
             CALL cl_err3("ins","p701_1_tmp",gl_no,l_seq,SQLCA.sqlcode,"","ins abb:",1)     #FUN-B50122
             LET g_success = 'N'
          END IF

         #FUN-B50122--Begin Mark--
         #IF l_amt > 0 THEN
         #   UPDATE oct_file SET oct08 = gl_no,oct22 = l_seq
         #    WHERE oct09 = l_oct09
         #      AND oct10 = l_oct10
         #      AND oct04 = l_oct04
         #      AND oct11 = l_oct11
         #      AND oct13 = l_oct13
         #      AND oct00 = '0'
         #      AND (oct16 = '2' OR oct16 = '4')
         #   IF SQLCA.sqlcode THEN
         #      CALL cl_err3("upd","oct_file",l_oct04,l_oct11,SQLCA.sqlcode,"","upd oct08/gl_no",1)
         #      LET g_success = 'N'
         #   END IF
         #END IF
         #FUN-B50122---End Mark---

          LET g_debit  =g_debit  + l_abb.abb07   #No.FUN-9A0036 借方

          #貸方
          LET l_abb.abb06 = '2'
          LET l_abb.abb07 = l_amt
          LET l_abb.abb07f= l_amt_f
          IF l_amt < 0 THEN
              LET l_abb.abb03 = l_oct.oct13
              LET l_abb.abb07 = l_abb.abb07 * -1
              LET l_abb.abb07f = l_abb.abb07f * -1
          ELSE
              LET l_abb.abb03 = l_oct.oct20
          END IF
          CALL p701_set_values(l_abb.*,l_oma930,l_oma15,l_oma63,l_omb40,l_oct.oct01)
          RETURNING l_abb.*
          LET l_seq = l_seq + 1
          LET l_abb.abb02 = l_seq

          EXECUTE p701_1_p5_3 USING
             l_abb.abb00,l_abb.abb01,l_abb.abb02,l_abb.abb03,l_abb.abb04,
             l_abb.abb05,l_abb.abb06,l_abb.abb07f,l_abb.abb07,l_abb.abb08,
             l_abb.abb11,l_abb.abb12,l_abb.abb13,l_abb.abb14,l_abb.abb15,
             l_abb.abb24,l_abb.abb25,l_abb.abb31,l_abb.abb32,l_abb.abb33,
             l_abb.abb34,l_abb.abb35,l_abb.abb36,l_abb.abb37,l_abb.abblegal,
             l_order,'0','','',l_oct09,l_oct10,l_oct11,'',l_oct04,l_oct13,l_amt                   #FUN-B50122
          IF SQLCA.sqlcode THEN
            #CALL cl_err3("ins","abb_file",gl_no,l_seq,SQLCA.sqlcode,"","ins abb:",1)             #FUN-B50122
             CALL cl_err3("ins","p701_1_tmp",gl_no,l_seq,SQLCA.sqlcode,"","ins abb:",1)           #FUN-B50122
             LET g_success = 'N'
          END IF
         #FUN-B50122--Begin Mark--
         #IF l_amt < 0 THEN
         #   UPDATE oct_file SET oct08 = gl_no,oct22 = l_seq
         #    WHERE oct09 = l_oct09
         #      AND oct10 = l_oct10
         #      AND oct04 = l_oct04
         #      AND oct11 = l_oct11
         #      AND oct13 = l_oct13
         #      AND oct00 = '0'
         #      AND (oct16 = '2' OR oct16 = '4')
         #   IF SQLCA.sqlcode THEN
         #      CALL cl_err3("upd","oct_file",l_oct04,l_oct11,SQLCA.sqlcode,"","upd oct08/gl_no",1)
         #      LET g_success = 'N'
         #   END IF
         #END IF
         #FUN-B50122---End Mark---
          LET g_credit = g_credit + l_abb.abb07     #No.FUN-9A0036 貸方
       END IF
   END FOREACH

#FUN-AB0110 --End
#FUN-B50122--Begin--
   LET g_sql="INSERT INTO ",cl_get_target_table(g_plant_gl,'abb_file'),
             "(abb00,abb01,abb02,abb03,abb04,",
             " abb05,abb06,abb07f,abb07,",
             " abb08,abb11,abb12,abb13,abb14,abb15,abb24,abb25,",
             " abb31,abb32,abb33,abb34,abb35,abb36,abb37,abblegal"," )",
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,? ",
             "       ,?,?,?,?,?, ?,?,?,?,?)"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql     
   PREPARE p701_1_p6 FROM g_sql
 
   CASE WHEN gl_seq = '0' 
        LET l_sql = "SELECT abb00,abb01,abb02,abb03,abb04,abb05,abb06,",
                          " abb07f,abb07,abb08,abb11,abb12,abb13,abb14,",
                          " abb15,abb24,abb25,abb31,abb32,abb33,abb34,",
                          " abb35,abb36,abb37,abblegal,'',oct00,oct01,oct02,",
                          " oct09,oct10,oct11,oct16,oct04,oct13,amt",
                    " FROM p701_1_tmp"
        WHEN gl_seq = '1'
        LET l_sql = "SELECT abb00,abb01,'',abb03,abb04,abb05,abb06,",
                           "sum(abb07f),sum(abb07),abb08,abb11,abb12,abb13,abb14,",
                           "abb15,abb24,abb25,abb31,abb32,abb33,abb34,",
                           "abb35,abb36,abb37,abblegal,''",
                    " FROM p701_1_tmp",
                    " GROUP BY abb00,abb01,abb03,abb04,abb05,",
                              "abb06,abb08,abb11,abb12,abb13,",
                              "abb14,abb15,abb24,abb25,abb31,",
                              "abb32,abb33,abb34,abb35,abb36,",
                              "abb37,abblegal"
        WHEN gl_seq = '2'
        LET l_sql = "SELECT abb00,abb01,'',abb03,abb04,abb05,abb06,",
                          " abb07f,abb07,abb08,abb11,abb12,abb13,abb14,",
                          " abb15,abb24,abb25,abb31,abb32,abb33,abb34,",
                          " abb35,abb36,abb37,abblegal,l_order,",
                          " oct00,oct01,oct02,oct09,oct10,oct11,oct16,oct04,oct13,amt",
                    " FROM p701_1_tmp",
                    " ORDER BY l_order"
        OTHERWISE 
        LET l_sql = "SELECT abb00,abb01,abb02,abb03,abb04,abb05,abb06,",
                          " abb07f,abb07,abb08,abb11,abb12,abb13,abb14,",
                          " abb15,abb24,abb25,abb31,abb32,abb33,abb34,",
                          " abb35,abb36,abb37,abblegal,''",
                          " oct00,oct01,oct02,oct09,oct10,oct11,oct16,oct04,oct13,amt",
                    " FROM p701_1_tmp"
   END CASE
   LET li_count = 0
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   PREPARE p701_1_pre1 FROM l_sql
   DECLARE p701_1_cur1 CURSOR FOR p701_1_pre1
   FOREACH p701_1_cur1 INTO l_abb.abb00,l_abb.abb01,l_abb.abb02,l_abb.abb03,
                            l_abb.abb04,l_abb.abb05,l_abb.abb06,l_abb.abb07f,
                            l_abb.abb07,l_abb.abb08,l_abb.abb11,l_abb.abb12,
                            l_abb.abb13,l_abb.abb14,l_abb.abb15,l_abb.abb24,
                            l_abb.abb25,l_abb.abb31,l_abb.abb32,l_abb.abb33,
                            l_abb.abb34,l_abb.abb35,l_abb.abb36,l_abb.abb37,
                            l_abb.abblegal,l_order,l_oct.oct00,l_oct.oct01,l_oct.oct02,
                            l_oct.oct09,l_oct.oct10,l_oct.oct11,l_oct.oct16,
                            l_oct.oct04,l_oct.oct13,l_amt
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      IF cl_null(l_order_t) THEN LET l_order_t = l_order END IF
      IF li_count = 0 OR l_order_t <> l_order THEN
         LET l_order_t = l_order
         LET li_count = li_count + 1
         LET l_seq = 0
         CALL p701_insaba_values("1",l_order,l_omalegal)
      END IF
      LET l_seq = l_seq + 1
      LET l_abb.abb02 = l_seq
      IF gl_seq = '2' THEN
         EXECUTE p701_1_p6 USING
             l_abb.abb00,gl_no,l_abb.abb02,l_abb.abb03,l_order,
             l_abb.abb05,l_abb.abb06,l_abb.abb07f,l_abb.abb07,l_abb.abb08,
             l_abb.abb11,l_abb.abb12,l_abb.abb13,l_abb.abb14,l_abb.abb15,
             l_abb.abb24,l_abb.abb25,l_abb.abb31,l_abb.abb32,l_abb.abb33,
             l_abb.abb34,l_abb.abb35,l_abb.abb36,l_abb.abb37,l_abb.abblegal
      ELSE
         EXECUTE p701_1_p6 USING
             l_abb.abb00,gl_no,l_abb.abb02,l_abb.abb03,l_abb.abb04,
             l_abb.abb05,l_abb.abb06,l_abb.abb07f,l_abb.abb07,l_abb.abb08,
             l_abb.abb11,l_abb.abb12,l_abb.abb13,l_abb.abb14,l_abb.abb15,
             l_abb.abb24,l_abb.abb25,l_abb.abb31,l_abb.abb32,l_abb.abb33,
             l_abb.abb34,l_abb.abb35,l_abb.abb36,l_abb.abb37,l_abb.abblegal
      END IF
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","abb_file",gl_no,l_seq,SQLCA.sqlcode,"","ins abb:",1)
         LET g_success = 'N'
      END IF
      IF g_success = 'Y' THEN
        #會計科目groupby之後，無法正確知道原來的單號,因此分開處理
         IF gl_seq <> '1' THEN
            IF l_oct.oct16 = '3' THEN
               UPDATE oct_file SET oct08 = gl_no,oct22 = l_seq
                WHERE oct01 = l_oct.oct01
                  AND oct02 = l_oct.oct02
                  AND oct09 = l_oct.oct09
                  AND oct10 = l_oct.oct10
                  AND oct11 = l_oct.oct11
                  AND oct16 = l_oct.oct16
                  AND oct00 = l_oct.oct00
            ELSE
               IF l_amt > 0 THEN
                  UPDATE oct_file SET oct08 = gl_no,oct22 = l_seq  
                   WHERE oct09 = l_oct.oct09
                     AND oct10 = l_oct.oct10
                     AND oct04 = l_oct.oct04
                     AND oct11 = l_oct.oct11
                     AND oct13 = l_oct.oct13
                     AND oct00 = '0'
                     AND (oct16 = '2' OR oct16 = '4')
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("upd","oct_file",l_oct.oct04,l_oct.oct11,SQLCA.sqlcode,"","upd oct08/gl_no",1) 
                     LET g_success = 'N'
                  END IF
               END IF
               IF l_amt < 0 THEN
                  UPDATE oct_file SET oct08 = gl_no,oct22 = l_seq
                   WHERE oct09 = l_oct.oct09
                     AND oct10 = l_oct.oct10
                     AND oct04 = l_oct.oct04
                     AND oct11 = l_oct.oct11
                     AND oct13 = l_oct.oct13
                     AND oct00 = '0'
                     AND (oct16 = '2' OR oct16 = '4')
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("upd","oct_file",l_oct.oct04,l_oct.oct11,SQLCA.sqlcode,"","upd oct08/gl_no",1) 
                     LET g_success = 'N'
                  END IF
               END IF
            END IF
         END IF
      END IF
   END FOREACH
   IF g_success = 'Y' THEN
     #會計科目groupby之後，無法正確知道原來的單號,因此分開處理
      IF gl_seq = '1' THEN
         LET l_sql = "SELECT oct00,oct01,oct02,oct09,oct10,oct11,oct16,",
                           " oct04,oct13,amt",
                      " FROM p701_1_tmp"
         PREPARE p701_1_pre2 FROM l_sql
         DECLARE p701_1_cur2 CURSOR FOR p701_1_pre2
         FOREACH p701_1_cur2 INTO l_oct.oct00,l_oct.oct01,l_oct.oct02,
                                  l_oct.oct09,l_oct.oct10,l_oct.oct11,
                                  l_oct.oct16,l_oct.oct04,l_oct.oct13,l_amt 
            IF l_oct.oct16 = '3' THEN
               UPDATE oct_file SET oct08 = gl_no
                WHERE oct01 = l_oct.oct01
                  AND oct02 = l_oct.oct02
                  AND oct09 = l_oct.oct09
                  AND oct10 = l_oct.oct10
                  AND oct11 = l_oct.oct11
                  AND oct16 = l_oct.oct16
                  AND oct00 = l_oct.oct00
            ELSE
               IF l_amt > 0 THEN
                  UPDATE oct_file SET oct08 = gl_no 
                   WHERE oct09 = l_oct.oct09
                     AND oct10 = l_oct.oct10
                     AND oct04 = l_oct.oct04
                     AND oct11 = l_oct.oct11
                     AND oct13 = l_oct.oct13
                     AND oct00 = '0'
                     AND (oct16 = '2' OR oct16 = '4')
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("upd","oct_file",l_oct.oct04,l_oct.oct11,SQLCA.sqlcode,"","upd oct08/gl_no",1) 
                     LET g_success = 'N'
                  END IF
               END IF
               IF l_amt < 0 THEN
                  UPDATE oct_file SET oct08 = gl_no
                   WHERE oct09 = l_oct.oct09
                     AND oct10 = l_oct.oct10
                     AND oct04 = l_oct.oct04
                     AND oct11 = l_oct.oct11
                     AND oct13 = l_oct.oct13
                     AND oct00 = '0'
                     AND (oct16 = '2' OR oct16 = '4')
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("upd","oct_file",l_oct.oct04,l_oct.oct11,SQLCA.sqlcode,"","upd oct08/gl_no",1) 
                     LET g_success = 'N'
                  END IF
               END IF
            END IF
         END FOREACH
      END IF
   END IF
  #FUN-B50122---End---

  #FUN-B50122--Begin Mark--
  #IF g_success ='Y' THEN  #FUN-A60007 add10 
  #    LET g_sql="INSERT INTO ",
  #              #cl_get_target_table(g_dbs_gl,'aba_file'),
  #              cl_get_target_table(g_plant_gl,'aba_file'),     #FUN-A50102 
  #              "(aba00,aba01,aba02,aba03,aba04,aba05,",
  #              " aba06,aba07,aba08,aba09,aba12,aba19,aba20,",
  #              " abamksg,abapost,",
  #              " abaprno,abaacti,abauser,abagrup,abadate,",
  #              " abasign,abadays,abaprit,abasmax,abasseq,aba24,aba11,abalegal)",
  #              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
  #              "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"
  #    CALL cl_replace_sqldb(g_sql) RETURNING g_sql         
  #    #CALL cl_parse_qry_sql(g_sql,g_dbs_gl) RETURNING l_sql
  #    CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql      #FUN-A50102 
  #    PREPARE p701_1_p4 FROM g_sql
  #    LET g_aba.aba01=gl_no
  #    CALL s_get_doc_no(gl_no) RETURNING l_aba01t   
  #    SELECT aac08,aacatsg,aacdays,aacprit,aacsign
  #      INTO g_aba.abamksg,l_aac.aacatsg,g_aba.abadays,
  #           g_aba.abaprit,g_aba.abasign
  #      FROM aac_file WHERE aac01 = l_aba01t
  #    IF g_aba.abamksg MATCHES  '[Yy]' THEN
  #       IF l_aac.aacatsg matches'[Yy]' THEN
  #          CALL s_sign(g_aba.aba01,4,'aba01','aba_file')
  #               RETURNING g_aba.abasign
  #       END IF
  #       SELECT COUNT(*) INTO g_aba.abasmax
  #         FROM azc_file
  #        WHERE azc01=g_aba.abasign
  #    END IF
  #    #LET l_p1='GL'
  #    LET l_p1='AR'   #CHI-A70058
  #    LET l_p2='0'
  #    LET l_p3='N'
  #    LET l_p4='Y'
  #    LET g_aba.abalegal = l_omalegal
  #    EXECUTE p701_1_p4 USING p_bookno,gl_no,gl_date,g_yy,g_mm,g_today,
  #                            l_p1,'',g_debit,g_credit,l_p3,l_p3,
  #                            l_p2,g_aba.abamksg,l_p3,l_p2,l_p4,g_user,
  #                            g_grup,g_today,g_aba.abasign,g_aba.abadays,g_aba.abaprit,g_aba.abasmax,
  #                            l_p2,g_user,g_aba.aba11,g_aba.abalegal  
  #    IF SQLCA.sqlcode THEN
  #       CALL cl_err('ins aba:',SQLCA.sqlcode,1)
  #       LET g_success = 'N'
  #    END IF
  #    CALL s_flows('2',g_ooz.ooz02b,gl_no,gl_date,l_p3,'',TRUE)   #No.TQC-B70021  
  #    DELETE FROM tmn_file 
  #     WHERE tmn01 = p_plant AND tmn02 = gl_no 
  #       AND tmn06 = p_bookno
  #    LET g_no1 = gl_no  
  #END IF   #FUN-A60007 add
  #FUN-B50122---End Mark---
END FUNCTION

FUNCTION p701_2()
DEFINE l_abb          RECORD LIKE abb_file.*
DEFINE l_oba          RECORD LIKE oba_file.*
DEFINE l_oct          RECORD LIKE oct_file.*        
DEFINE l_aac          RECORD LIKE aac_file.*        
DEFINE gl_no                 LIKE smy_file.smyslip
DEFINE l_seq                 LIKE type_file.num5
DEFINE ar_user               LIKE oma_file.omauser
DEFINE l_p1                  LIKE aba_file.aba06
DEFINE l_p2                  LIKE aba_file.aba08
DEFINE l_p3,l_p4             LIKE type_file.chr1
DEFINE li_result             LIKE type_file.num5
DEFINE l_aba01t              LIKE aba_file.aba01
DEFINE l_sql                 STRING #FUN-A30006
DEFINE l_ool411              LIKE ool_file.ool41 #FUN-A30006
DEFINE l_omb331              LIKE omb_file.omb33 #FUN-A30006
DEFINE l_oma33               LIKE oma_file.oma33 #FUN-A60007 
#FUN-A10005 --Begin
DEFINE l_oma930              LIKE oma_file.oma930
DEFINE l_oma15               LIKE oma_file.oma15 
DEFINE l_oma63               LIKE oma_file.oma63 
DEFINE l_aag05               LIKE aag_file.aag05 
DEFINE l_aag21               LIKE aag_file.aag21 
DEFINE l_aag23               LIKE aag_file.aag23 
DEFINE l_omb40               LIKE omb_file.omb40
#FUN-A10005 --End
DEFINE l_oma34               LIKE oma_file.oma34  #MOD-A80025
DEFINE l_ool421              LIKE ool_file.ool42  #MOD-A80025
DEFINE l_ool471              LIKE ool_file.ool47  #MOD-A80025
DEFINE l_omalegal            LIKE oma_file.omalegal
DEFINE l_omblegal            LIKE omb_file.omblegal
DEFINE l_oct04               LIKE oct_file.oct04  #FUN-AB0110                  
DEFINE l_oct09               LIKE oct_file.oct09  #FUN-AB0110                  
DEFINE l_oct10               LIKE oct_file.oct10  #FUN-AB0110                  
DEFINE l_oct11               LIKE oct_file.oct11  #FUN-AB0110                  
DEFINE l_oct13               LIKE oct_file.oct13  #FUN-AB0110                  
DEFINE l_amt                 LIKE oct_file.oct14  #FUN-AB0110                  
DEFINE l_amt_f               LIKE oct_file.oct14f #FUN-AB0110                 
DEFINE l_type                LIKE type_file.chr1  #FUN-AB0110
DEFINE l_order               LIKE type_file.chr30 #FUN-B50122
DEFINE l_abb03               LIKE abb_file.abb03  #FUN-B50122
DEFINE l_abb06               LIKE abb_file.abb06  #FUN-B50122
DEFINE l_abb24               LIKE abb_file.abb24  #FUN-B50122
DEFINE l_abb25               LIKE abb_file.abb25  #FUN-B50122
DEFINE l_oct23               LIKE oct_file.oct23  #FUN-B50122
DEFINE l_order_t             LIKE type_file.chr30 #FUN-B50122
DEFINE li_count              SMALLINT             #FUN-B50122

      LET g_debit1 = 0
      LET g_credit1 = 0
      LET g_plant_new= p_plant
      LET g_no2 = gl_no              #FUN-B50122 傳單別
     #CALL s_getdbs()
     #LET g_dbs_gl=g_plant_new CLIPPED
     #CALL s_auto_assign_no("agl",gl_no1,gl_date,"1","","",g_dbs_gl,"",g_ooz.ooz02c)
     #FUN-B50122--Begin Mark--
     #LET g_plant_gl=g_plant_new CLIPPED    #FUN-A50102
     #CALL s_auto_assign_no("agl",gl_no1,gl_date,"1","","",g_plant_gl,"",g_ooz.ooz02c)   #FUN-A50102
     #   RETURNING li_result,gl_no1
     #IF li_result = 0 THEN LET g_success = 'N' END IF
     #IF g_bgjob = "N" THEN            
     #    MESSAGE    "Insert G/L voucher no:",gl_no1
     #    CALL ui.Interface.refresh()
     #END IF                    
     #FUN-B50122---End Mark---
      LET l_seq = 0
      #FOREACH p701_1_c1 INTO l_oct.*
      FOREACH p701_1_c0 INTO l_oct.*   #FUN-A60007 mod
#FUN-A30006 --Begin
#        SELECT * INTO l_oba.*
#          FROM oba_file,ima_file
#         WHERE ima01 = l_oct.oct03
#           AND ima131 = oba01
#        SELECT azp03 INTO g_dbs_new FROM azp_file
#         WHERE azp01 = l_oct.oct17
#        IF STATUS THEN
#            LET g_dbs_new = NULL
#        END IF
#        LET g_dbs_oct17 = s_dbstring(g_dbs_new CLIPPED)
         IF l_oct.oct16 = '2' THEN   #FUN-AB0110
  ##NO.FUN-A60007   --begin                                                                                                         
            LET l_sql = " SELECT oma33,omalegal FROM ", 
                          cl_get_target_table(l_oct.oct17,'oma_file,'),
                          cl_get_target_table(l_oct.oct17,'omb_file'),
                        "  WHERE oma01 = omb01 ", 
                        "    AND omb01= '",l_oct.oct01,"'",                                                                                
                        "    AND omb03= '",l_oct.oct02,"'"                                                                                 
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
            CALL cl_parse_qry_sql(l_sql,l_oct.oct17) RETURNING l_sql
            PREPARE p701_pre11 FROM l_sql
            DECLARE p701_cs11 CURSOR FOR p701_pre11
            OPEN p701_cs11
            FETCH p701_cs11 INTO l_oma33,l_omalegal  
            CLOSE p701_cs11                                                                                                           
            IF cl_null(l_oma33) THEN                                                                                                       
                LET g_showmsg=l_oct.oct01,'/',l_oct.oct01                                                                                          
                CALL s_errmsg('oma01,oma02',g_showmsg,'','agl-257',1)                                                                      
                LET g_success = 'N'
                CONTINUE FOREACH                                                                                                           
            END IF     　      　      　      　      　      　      　      　                                                          
  ##NO.FUN-A60007   --end 
         END IF             #FUN-AB0110
         LET l_sql = " SELECT omb331,omb40,omblegal FROM ",#FUN-A10005 add omb40
                       cl_get_target_table(l_oct.oct17,'omb_file'),
                     "  WHERE omb01= '",l_oct.oct01,"'",
                     "    AND omb03= '",l_oct.oct02,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
         CALL cl_parse_qry_sql(l_sql,l_oct.oct17) RETURNING l_sql
         PREPARE p701_omb331_pre FROM l_sql
         DECLARE p701_omb331 SCROLL CURSOR FOR p701_omb331_pre
         OPEN p701_omb331
         FETCH p701_omb331 INTO l_omb331,l_omb40,l_omblegal #FUN-A10005 add l_omb40
         CLOSE p701_omb331
    
         #IF cl_null(l_omb331) THEN   #MOD-A80025 mark
            #LET l_sql = "SELECT ool411 FROM ",g_dbs_oct17,"ool_file,",g_dbs_oct17,"oma_file",
            LET l_sql = "SELECT oma34,ool411,ool421,ool471 FROM ",   #MOD-A80025
                         cl_get_target_table(l_oct.oct17,'ool_file,'),
                         cl_get_target_table(l_oct.oct17,'oma_file'),
                        " WHERE oma01 = '",l_oct.oct01,"'",
                        "   AND oma13 = ool01 "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
            CALL cl_parse_qry_sql(l_sql,l_oct.oct17) RETURNING l_sql
            PREPARE p701_ool411_pre FROM l_sql
            DECLARE p701_ool411 SCROLL CURSOR FOR p701_ool411 
            OPEN p701_ool411
            #FETCH p701_ool411 INTO l_ool411
            FETCH p701_ool411 INTO l_oma34,l_ool411,l_ool421,l_ool471  #MOD-A80025
            CLOSE p701_ool411
            IF NOT cl_null(l_ool411) THEN LET l_omb331 = l_ool411 END IF
         #END IF   #MOD-A80025 mark

#FUN-A30006 --End
         IF cl_null(l_omb331) THEN   #MOD-A80025
#           IF l_oct.oct16 = '2' THEN    #MOD-A80025 #FUN-AB0110 mark
                IF NOT cl_null(l_ool411) THEN LET l_omb331 = l_ool411 END IF
#           END IF   #MOD-A80025         #FUN-AB0110 mark
         END IF      #MOD-A80025
#FUN-AB0110 --Begin
#折讓類遞延反向科目先取oct_file中本身資料的oct20
#如果取不到則以帳別+出貨單號+項次+售貨動作取12類應收的oct20
#再取不到資料則用科目類別預設
         IF l_oct.oct16 <> '2' THEN
            IF cl_null(l_oct.oct20) THEN
               SELECT oct20 INTO l_oct.oct20
                 FROM oct_file
                WHERE oct00 = l_oct.oct00
                  AND oct04 = l_oct.oct04  #出貨單號
                  AND oct05 = l_oct.oct05  #出貨項次
                  AND oct11 = l_oct.oct11
                  AND oct16 = '1'
               IF cl_null(l_oct.oct20) THEN
                  LET l_oct.oct20 = l_omb331
               END IF
            END IF
         END IF
#FUN-AB0110 --End

#FUN-AB0110 --Begin mark
#        #--MOD-A80025 start--
#        IF l_oct.oct16 = '4' THEN
#            IF l_oma34 ='5' THEN
#               LET l_omb331=l_ool471
#            ELSE
#               LET l_omb331=l_ool421
#            END IF
#        END IF  
#        #--MOD-A80025 end--
#        #--------------------------------------#
#        LET l_seq = l_seq + 1
#FUN-AB0110 --End mark
#FUN-A30006 --Begin
#        SELECT omauser INTO ar_user
#          FROM oma_file WHERE oma01= l_oct.oct01
         LET g_oma03 = ''          #MOD-B10115 
        #LET l_sql = " SELECT omauser,oma15,oma930,oma63 FROM ",#FUN-A10005 add oma15,oma930       #MOD-B10115 mark
         LET l_sql = " SELECT omauser,oma15,oma930,oma63,oma03 FROM ",#FUN-A10005 add oma15,oma930 #MOD-B10115
                         cl_get_target_table(l_oct.oct17,'oma_file'),
                     "  WHERE oma01= '",l_oct.oct01,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
         CALL cl_parse_qry_sql(l_sql,l_oct.oct17) RETURNING l_sql
         PREPARE p701_omauser1_pre FROM l_sql
         DECLARE p701_omauser1 SCROLL CURSOR FOR p701_omauser1_pre
         OPEN p701_omauser1
         FETCH p701_omauser1 INTO ar_user,l_oma15,l_oma930,l_oma63,g_oma03 #FUN-A10005 add l_oma15,l_oma930 #MOD-B10115 add oma03
         CLOSE p701_omauser1
#FUN-A30006 --End
         IF ar_user<b_user OR ar_user>e_user THEN CONTINUE FOREACH END IF
        
         IF g_success = 'Y' THEN  #FUN-A60007        
#FUN-AB0110 --Begin mark
#            #UPDATE oct_file SET oct081 = gl_no1
#            UPDATE oct_file SET oct08 = gl_no1   #FUN-A60007 mod
#             WHERE oct01 = l_oct.oct01
#               AND oct02 = l_oct.oct02
#               AND oct09 = l_oct.oct09
#               AND oct10 = l_oct.oct10
#               AND oct11 = l_oct.oct11
#               AND oct16 = l_oct.oct16
#               AND oct00 = l_oct.oct00   #FUN0-A60007
#            IF SQLCA.sqlcode THEN
#               #CALL cl_err3("upd","oct_file",l_oct.oct01,l_oct.oct02,SQLCA.sqlcode,"","upd oct081/glno1",1)
#               CALL cl_err3("upd","oct_file",l_oct.oct01,l_oct.oct02,SQLCA.sqlcode,"","upd oct08/glno1",1)   #FUN-A60007 
#               LET g_success = 'N'
#            END IF
#FUN-AB0110 --End mark
  
             LET g_sql = "INSERT INTO ",
                                " p701_1_tmp ",                               #FUN-B50122
                                #cl_get_target_table(g_dbs_gl,'abb_file'),
                                #cl_get_target_table(g_plant_gl,'abb_file'),  #FUN-B50122 Mark  #FUN-A50102
                                "(abb00,abb01,abb02,abb03,abb04,",
                                " abb05,abb06,abb07f,abb07,",
                                " abb08,abb11,abb12,abb13,abb14,abb15,abb24,abb25,",
                                " abb31,abb32,abb33,abb34,abb35,abb36,abb37,abblegal,",
                                " l_order,oct00,oct01,oct02,oct09,oct10,oct11,oct16,oct04,oct13,amt)",   #FUN-B50122
                         " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
                         "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",                                    #FUN-B50122 
                         "        ?,?,?,?,?, ?)"                                                         #FUN-B50122
             CALL cl_replace_sqldb(g_sql) RETURNING g_sql     
             #CALL cl_parse_qry_sql(g_sql,g_dbs_gl) RETURNING l_sql
             CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql    #FUN-A50102
             PREPARE p701_1_p5_1 FROM g_sql
  
             LET l_abb.abb00 = g_ooz.ooz02c
             LET l_abb.abb01 = gl_no1
#            LET l_abb.abb02 = l_seq     #FUN-AB0110 mark
             LET l_abb.abb04 = l_oct.oct01,'/',l_oct.oct02,'/',l_oct.oct03  #摘要
             LET l_abb.abb06 = '1'
             LET l_abb.abb24 = l_oct.oct18
             LET l_abb.abb25 = l_oct.oct19
             CASE
                WHEN l_oct.oct16 = '1'    
#                  LET l_abb.abb03 = l_oba.oba111#FUN-A30006
#                  LET l_abb.abb03 = l_omb331    #FUN-A30006
                   LET l_abb.abb03 = l_oct.oct20 #FUN-AB0110
                   LET l_abb.abb07 = l_oct.oct12
                   LET l_abb.abb07f= l_oct.oct12f
                WHEN l_oct.oct16 = '2'
                   #LET l_abb.abb03 = l_oct.oct131
                   LET l_abb.abb03 = l_oct.oct13    #FUN-A60007
                   LET l_abb.abb07 = l_oct.oct14
                   LET l_abb.abb07f= l_oct.oct14f
                   LET l_type = '1'                 #FUN-AB0110
                WHEN l_oct.oct16 = '3'    
                   #LET l_abb.abb03 = l_oct.oct131
                   LET l_abb.abb03 = l_oct.oct13    #FUN-A60007
                   LET l_abb.abb07 = l_oct.oct12
                   LET l_abb.abb07f= l_oct.oct12f
                WHEN l_oct.oct16 = '4'
#                  LET l_abb.abb03 = l_oba.oba111#FUN-A30006
#                  LET l_abb.abb03 = l_omb331    #FUN-A30006
                   LET l_abb.abb03 = l_oct.oct20 #FUN-AB0110 
                   LET l_abb.abb07 = l_oct.oct15
                   LET l_abb.abb07f= l_oct.oct15f
                   LET l_type = '2'              #FUN-AB0110
             END CASE
        #FUN-B50122--begin--
         CASE WHEN gl_seq = '0' LET l_order = ' '         # 傳票區分項目
              WHEN gl_seq = '1' LET l_order = l_abb.abb03 # 依會計科目
              WHEN gl_seq = '2' LET l_order = l_oct.oct23 # 依客戶
              OTHERWISE         LET l_order = ' '
         END CASE
        #FUN-B50122---end---
#FUN-A10005 --Begin
#            LET l_abb.abb05 = ''
#            LET l_abb.abb15 = ''
#            LET l_abb.abb08 = ''
#            SELECT aag05,aag21,aag23 
#              INTO l_aag05,l_aag21,l_aag23
#              FROM aag_file
#             WHERE aag00 = l_abb.abb00
#               AND aag01 = l_abb.abb03

#            IF l_aag05 = 'Y' THEN
#               IF g_aaz.aaz90='Y' THEN
#                  LET l_abb.abb05 = l_oma930
#               ELSE
#                  LET l_abb.abb05 = l_oma15
#               END IF
#            END IF
#
#            IF l_aag21 = 'Y' THEN
#               LET l_abb.abb15 = l_omb40
#            END IF

#            IF l_aag23 = 'Y' THEN
#               LET l_abb.abb08 = l_oma63
#            END IF
#                
#            CALL p701_def_abb(l_abb.abb03,'aglp701',l_abb.*,l_abb.abb01,'','',l_abb.abb00)
#            RETURNING l_abb.*
             CALL p701_set_values(l_abb.*,l_oma930,l_oma15,l_oma63,l_omb40,l_oct.oct01) #FUN-A10005
             RETURNING l_abb.*
#FUN-A10005 --End
             LET l_abb.abblegal = l_omblegal
             IF l_oct.oct16 = '3' THEN    #FUN-AB0110
                LET l_seq = l_seq + 1     #FUN-AB0110
                LET l_abb.abb02 = l_seq   #FUN-AB0110
                EXECUTE p701_1_p5_1 USING
                   l_abb.abb00,l_abb.abb01,l_abb.abb02,l_abb.abb03,l_abb.abb04,
                   l_abb.abb05,l_abb.abb06,l_abb.abb07f,l_abb.abb07,l_abb.abb08,
                   l_abb.abb11,l_abb.abb12,l_abb.abb13,l_abb.abb14,l_abb.abb15,
                   l_abb.abb24,l_abb.abb25,l_abb.abb31,l_abb.abb32,l_abb.abb33,
                   l_abb.abb34,l_abb.abb35,l_abb.abb36,l_abb.abb37,l_abb.abblegal,
                   l_order,l_oct.oct00,l_oct.oct01,l_oct.oct02,l_oct.oct09,          #FUN-B50122
                   l_oct.oct10,l_oct.oct11,l_oct.oct16,'','',''                      #FUN-B50122
                IF SQLCA.sqlcode THEN
                  #CALL cl_err3("ins","abb_file",gl_no,l_seq,SQLCA.sqlcode,"","ins abb:",1)    #FUN-B50122
                   CALL cl_err3("ins","p701_1_tmp",gl_no,l_seq,SQLCA.sqlcode,"","ins abb:",1)  #FUN-B50122
                   LET g_success = 'N'
                END IF
               #FUN-B50122--Begin Mark--
               #FUN-AB0110 -Begin
               #UPDATE oct_file SET oct08 = gl_no1,
               #       oct22 = l_seq
               # WHERE oct01 = l_oct.oct01
               #   AND oct02 = l_oct.oct02
               #   AND oct09 = l_oct.oct09
               #   AND oct10 = l_oct.oct10
               #   AND oct11 = l_oct.oct11
               #   AND oct16 = l_oct.oct16
               #   AND oct00 = l_oct.oct00
               #IF SQLCA.sqlcode THEN
               #   CALL cl_err3("upd","oct_file",l_oct.oct01,l_oct.oct02,SQLCA.sqlcode,"","upd oct08/glno1",1)
               #   LET g_success = 'N'
               #END IF
               #FUN-AB0110 --End
               #FUN-B50122---End Mark---
                LET g_debit1  =g_debit1  + l_abb.abb07  
#FUN-AB0110 --Begin
             ELSE
                 EXECUTE insert_prep USING l_oct.oct00,
                                           l_oct.oct09,l_oct.oct10,
                                           l_oct.oct04,l_oct.oct11,
                                           l_abb.abb03,l_oct.oct14,
                                           l_oct.oct14f,l_oct.oct15,
                                           l_oct.oct15f,l_oct.oct16,l_type
             END IF
#FUN-AB0110 --End
            #LET l_seq = l_seq + 1     #FUN-AB0110 mark
            #LET l_abb.abb02 = l_seq   #FUN-AB0110 mark
             LET l_abb.abb06 = '2'
             CASE
                 WHEN l_oct.oct16 = '1'    
                    #LET l_abb.abb03 = l_oct.oct131
                    LET l_abb.abb03 = l_oct.oct13     #FUN-A60007
                    LET l_abb.abb07 = l_oct.oct12
                    LET l_abb.abb07f= l_oct.oct12f
                 WHEN l_oct.oct16 = '2'
#                   LET l_abb.abb03 = l_oba.oba111#FUN-A30006
#                   LET l_abb.abb03 = l_omb331    #FUN-A30006
                    LET l_abb.abb03 = l_oct.oct02 #FUN-AB0110
                    LET l_abb.abb07 = l_oct.oct14
                    LET l_abb.abb07f= l_oct.oct14f
                    LET l_type = '2'              #FUN-AB0110
                 WHEN l_oct.oct16 = '3'    
#                   LET l_abb.abb03 = l_oba.oba111#FUN-A30006
#                   LET l_abb.abb03 = l_omb331    #FUN-A30006
                    LET l_abb.abb03 = l_oct.oct20 #FUN-AB0110
                    LET l_abb.abb07 = l_oct.oct12
                    LET l_abb.abb07f= l_oct.oct12f
                 WHEN l_oct.oct16 = '4'
                    #LET l_abb.abb03 = l_oct.oct131
                    LET l_abb.abb03 = l_oct.oct13    #FUN-A60007 
                    LET l_abb.abb07 = l_oct.oct15
                    LET l_abb.abb07f= l_oct.oct15f
                    LET l_type = '1'                 #FUN-AB0110
             END CASE
            #FUN-B50122--begin--
             CASE WHEN gl_seq = '0' LET l_order = ' '         # 傳票區分項目
                  WHEN gl_seq = '1' LET l_order = l_abb.abb03 # 依會計科目
                  WHEN gl_seq = '2' LET l_order = l_oct.oct23 # 依客戶
                  OTHERWISE         LET l_order = ' '
              END CASE
            #FUN-B50122---end---
             CALL p701_set_values(l_abb.*,l_oma930,l_oma15,l_oma63,l_omb40,l_oct.oct01) #FUN-A10005
             RETURNING l_abb.*
             LET l_abb.abblegal = l_omblegal
#FUN-AB0110 --Begin
             IF l_oct.oct16 = '3' THEN
                LET l_seq = l_seq + 1
                LET l_abb.abb02 = l_seq
#FUN-AB0110 --End
                EXECUTE p701_1_p5_1 USING
                   l_abb.abb00,l_abb.abb01,l_abb.abb02,l_abb.abb03,l_abb.abb04,
                   l_abb.abb05,l_abb.abb06,l_abb.abb07f,l_abb.abb07,l_abb.abb08,
                   l_abb.abb11,l_abb.abb12,l_abb.abb13,l_abb.abb14,l_abb.abb15,
                   l_abb.abb24,l_abb.abb25,l_abb.abb31,l_abb.abb32,l_abb.abb33,
                   l_abb.abb34,l_abb.abb35,l_abb.abb36,l_abb.abb37,l_abb.abblegal,
                   l_order,l_oct.oct00,l_oct.oct01,l_oct.oct02,l_oct.oct09,          #FUN-B50122
                   l_oct.oct10,l_oct.oct11,l_oct.oct16,'','',''                      #FUN-B50122
                IF SQLCA.sqlcode THEN
                  #CALL cl_err3("ins","abb_file",gl_no,l_seq,SQLCA.sqlcode,"","ins abb:",1)     #FUN-B50122
                   CALL cl_err3("ins","p701_1_tmp",gl_no,l_seq,SQLCA.sqlcode,"","ins abb:",1)   #FUN-B50122 
                   LET g_success = 'N'
                END IF
                LET g_credit1 = g_credit1 + l_abb.abb07   
#FUN-AB0110 --Begin
             ELSE
                EXECUTE insert_prep USING l_oct.oct00,
                                          l_oct.oct09,l_oct.oct10,
                                          l_oct.oct04,l_oct.oct14,
                                          l_oct.oct14f,l_oct.oct15,
                                          l_oct.oct15f,l_oct.oct16,l_type
             END IF
#FUN-AB0110 --End
          END IF  #FUN-A60007 add
      END FOREACH

#FUN-AB0110 --Begin
      #將p701_tmp的資料依年/月/齣貨單/售貨動作/科目為GROUP,SUM(oct14-oct15)
      #金額大於0才切分錄進傳票,金額=0則不處理(代表銷退額為全退)
      DECLARE p701_tmp_cs CURSOR FOR
         SELECT oct09,oct10,oct04,oct11,oct13,SUM(oct14-oct15),SUM(oct14f-oct15f),oct23          #FUN-B50122
           FROM p701_tmp
          WHERE type = '1'
            AND oct00 = '1'
          GROUP BY oct00,oct09,oct10,oct04,oct11,oct13,oct23                                     #FUN-B50122
          ORDER BY oct13
      FOREACH p701_tmp_cs INTO l_oct09,l_oct10,l_oct04,l_oct11,l_oct13,l_amt,l_amt_f,l_oct23     #FUN-B50122
         IF SQLCA.sqlcode THEN 
            LET g_showmsg= l_oct04,l_oct11,l_oct13
            CALL s_errmsg('oct04,oct11,oct13',g_showmsg,'p701_tmp_cs',SQLCA.sqlcode,1)  
            LET g_success = 'N'
            CONTINUE FOREACH 
         END IF
         IF l_amt <> 0 THEN
            #LET g_sql = "INSERT INTO ",cl_get_target_table(g_plant_gl,'abb_file'),               #FUN-B50122
             LET g_sql = "INSERT INTO  p701_1_tmp",                                               #FUN-B50122
                                      "(abb00,abb01,abb02,abb03,abb04,",
                                      " abb05,abb06,abb07f,abb07,",
                                      " abb08,abb11,abb12,abb13,abb14,abb15,abb24,abb25,",
                                      " abb31,abb32,abb33,abb34,abb35,abb36,abb37,abblegal,",
                                      " l_order,oct00,oct01,oct02,oct09,oct10,oct11,oct16,oct04,oct13,amt)", #FUN-B50122
                         " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                         "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",                                         #FUN-B50122
                         "        ?,?,?,?,?, ?)"                                                             #FUN-B50122
             CALL cl_replace_sqldb(g_sql) RETURNING g_sql     
             CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql
             PREPARE p701_1_p5_4 FROM g_sql
  
             LET l_abb.abb00 = g_ooz.ooz02c
             LET l_abb.abb01 = gl_no1
             LET l_abb.abb04 = l_oct.oct04
             LET l_abb.abb06 = '1'
             LET l_abb.abb24 = l_oct.oct18
             LET l_abb.abb25 = l_oct.oct19
             LET l_abb.abb07 = l_amt
             LET l_abb.abb07f= l_amt_f
             LET l_order = l_oct23             #FUN-B50122
             IF l_amt < 0 THEN
                 LET l_abb.abb07 = l_abb.abb07 * -1
                 LET l_abb.abb07f= l_abb.abb07f * -1
                 LET l_abb.abb03 = l_oct.oct20
             ELSE
                 LET l_abb.abb03 = l_oct.oct13   
             END IF
            #-MOD-B10115-mark-
            #LET l_abb.abb05 = ''
            #LET l_abb.abb15 = ''
            #LET l_abb.abb08 = ''
            #SELECT aag05,aag21,aag23 
            #  INTO l_aag05,l_aag21,l_aag23
            #  FROM aag_file
            # WHERE aag00 = l_abb.abb00
            #   AND aag01 = l_abb.abb03

            #IF l_aag05 = 'Y' THEN
            #   IF g_aaz.aaz90='Y' THEN
            #      LET l_abb.abb05 = l_oma930
            #   ELSE
            #      LET l_abb.abb05 = l_oma15
            #   END IF
            #END IF

            #IF l_aag21 = 'Y' THEN
            #   LET l_abb.abb15 = l_omb40
            #END IF

            #IF l_aag23 = 'Y' THEN
            #   LET l_abb.abb08 = l_oma63
            #END IF
            #    
            #CALL p701_def_abb(l_abb.abb03,'aglp701',l_abb.*,l_abb.abb01,'','',l_abb.abb00)
            #RETURNING l_abb.*
            #-MOD-B10115-end-
             CALL p701_set_values(l_abb.*,l_oma930,l_oma15,l_oma63,l_omb40,l_oct.oct01) 
             RETURNING l_abb.*

             LET l_seq = l_seq + 1     
             LET l_abb.abb02 = l_seq  
             LET l_abb.abblegal = l_oct.octlegal

             EXECUTE p701_1_p5_4 USING
                l_abb.abb00,l_abb.abb01,l_abb.abb02,l_abb.abb03,l_abb.abb04,
                l_abb.abb05,l_abb.abb06,l_abb.abb07f,l_abb.abb07,l_abb.abb08,
                l_abb.abb11,l_abb.abb12,l_abb.abb13,l_abb.abb14,l_abb.abb15,
                l_abb.abb24,l_abb.abb25,l_abb.abb31,l_abb.abb32,l_abb.abb33,
                l_abb.abb34,l_abb.abb35,l_abb.abb36,l_abb.abb37,l_abb.abblegal,
                l_order,'0','','',l_oct09,l_oct10,l_oct11,'',l_oct04,l_oct13,l_amt             #FUN-B50122
             IF SQLCA.sqlcode THEN
               #CALL cl_err3("ins","abb_file",gl_no,l_seq,SQLCA.sqlcode,"","ins abb:",1)       #FUN-B50122
                CALL cl_err3("ins","p701_1_tmp",gl_no,l_seq,SQLCA.sqlcode,"","ins abb:",1)     #FUN-B50122
                LET g_success = 'N'
             END IF
            #FUN-B50122--Begin Mark--
            #IF l_amt > 0 THEN
            #    UPDATE oct_file SET oct08 = gl_no1,oct22 = l_seq
            #     WHERE oct09 = l_oct09
            #       AND oct10 = l_oct10
            #       AND oct04 = l_oct04
            #       AND oct11 = l_oct11
            #       AND oct13 = l_oct13
            #       AND oct00 = '1'
            #       AND (oct16 = '2' OR oct16 = '4')
            #    IF SQLCA.sqlcode THEN
            #       CALL cl_err3("upd","oct_file",l_oct04,l_oct11,SQLCA.sqlcode,"","upd oct08/gl_no1",1) 
            #       LET g_success = 'N'
            #    END IF
            #END IF
            #FUN-B50122---End Mark---
             LET g_debit1  =g_debit1  + l_abb.abb07  

             #貸方
             LET l_abb.abb06 = '2'
             LET l_abb.abb07 = l_amt
             LET l_abb.abb07f= l_amt_f
             IF l_amt < 0 THEN
                 LET l_abb.abb07 = l_abb.abb07 * -1
                 LET l_abb.abb07f= l_abb.abb07f * -1
                 LET l_abb.abb03 = l_oct.oct13
             ELSE
                 LET l_abb.abb03 = l_oct.oct20
             END IF
             CALL p701_set_values(l_abb.*,l_oma930,l_oma15,l_oma63,l_omb40,l_oct.oct01) #FUN-A10005
             RETURNING l_abb.*

             LET l_seq = l_seq + 1
             LET l_abb.abb02 = l_seq 

             EXECUTE p701_1_p5_4 USING
                l_abb.abb00,l_abb.abb01,l_abb.abb02,l_abb.abb03,l_abb.abb04,
                l_abb.abb05,l_abb.abb06,l_abb.abb07f,l_abb.abb07,l_abb.abb08,
                l_abb.abb11,l_abb.abb12,l_abb.abb13,l_abb.abb14,l_abb.abb15,
                l_abb.abb24,l_abb.abb25,l_abb.abb31,l_abb.abb32,l_abb.abb33,
                l_abb.abb34,l_abb.abb35,l_abb.abb36,l_abb.abb37,l_abb.abblegal,
                l_order,'0','','',l_oct09,l_oct10,l_oct11,'',l_oct04,l_oct13,l_amt          #FUN-B50122
             IF SQLCA.sqlcode THEN
               #CALL cl_err3("ins","abb_file",gl_no,l_seq,SQLCA.sqlcode,"","ins abb:",1)    #FUN-B50122
                CALL cl_err3("ins","p701_1_tmp",gl_no,l_seq,SQLCA.sqlcode,"","ins abb:",1)  #FUN-B50122
                LET g_success = 'N'
             END IF
            #FUN-B50122--Begin Mark--
            #IF l_amt < 0 THEN
            #    UPDATE oct_file SET oct08 = gl_no1,oct22 = l_seq  
            #     WHERE oct09 = l_oct09
            #       AND oct10 = l_oct10
            #       AND oct04 = l_oct04
            #       AND oct11 = l_oct11
            #       AND oct13 = l_oct13
            #       AND oct00 = '1'
            #       AND (oct16 = '2' OR oct16 = '4')
            #    IF SQLCA.sqlcode THEN
            #       CALL cl_err3("upd","oct_file",l_oct04,l_oct11,SQLCA.sqlcode,"","upd oct08/gl_no1",1) 
            #       LET g_success = 'N'
            #    END IF
            #END IF
            #FUN-B50122---End Mark---
             LET g_credit1 = g_credit1 + l_abb.abb07   
          END IF
      END FOREACH
      #--FUN-AB0110 end--
      #FUN-B50122--begin--
      LET g_sql="INSERT INTO ",g_plant_gl CLIPPED,"abb_file",
                "(abb00,abb01,abb02,abb03,abb04,",
                " abb05,abb06,abb07f,abb07,",
                " abb08,abb11,abb12,abb13,abb14,abb15,abb24,abb25,",
                " abb31,abb32,abb33,abb34,abb35,abb36,abb37,abblegal"," )",
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,? ",
                "       ,?,?,?,?,?, ?,?,?,?,?)"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql     
      PREPARE p701_2_p6 FROM g_sql
    
      CASE WHEN gl_seq = '0' 
           LET l_sql = "SELECT abb00,abb01,abb02,abb03,abb04,abb05,abb06,",
                             " abb07f,abb07,abb08,abb11,abb12,abb13,abb14,",
                             " abb15,abb24,abb25,abb31,abb32,abb33,abb34,",
                             " abb35,abb36,abb37,'',abblegal,oct00,oct01,oct02,",
                             " oct09,oct10,oct11,oct16,oct04,oct13,amt",
                       " FROM p701_1_tmp"
           WHEN gl_seq = '1'
           LET l_sql = "SELECT abb00,abb01,'',abb03,abb04,abb05,abb06,",
                              "sum(abb07f),sum(abb07),abb08,abb11,abb12,abb13,abb14,",
                              "abb15,abb24,abb25,abb31,abb32,abb33,abb34,",
                              "abb35,abb36,abb37,abblegal,''",
                       " FROM p701_1_tmp",
                       " GROUP BY abb00,abb01,abb03,abb04,abb05,",
                                 "abb06,abb08,abb11,abb12,abb13,",
                                 "abb14,abb15,abb24,abb25,abb31,",
                                 "abb32,abb33,abb34,abb35,abb36,",
                                 "abb37,abblegal"
           WHEN gl_seq = '2'
           LET l_sql = "SELECT abb00,abb01,'',abb03,abb04,abb05,abb06,",
                             " abb07f,abb07,abb08,abb11,abb12,abb13,abb14,",
                             " abb15,abb24,abb25,abb31,abb32,abb33,abb34,",
                             " abb35,abb36,abb37,abblegal,l_order,",
                             " oct00,oct01,oct02,oct09,oct10,oct11,oct16,oct04,oct13,amt",
                       " FROM p701_1_tmp",
                       " ORDER BY l_order"
           OTHERWISE 
           LET l_sql = "SELECT abb00,abb01,abb02,abb03,abb04,abb05,abb06,",
                             " abb07f,abb07,abb08,abb11,abb12,abb13,abb14,",
                             " abb15,abb24,abb25,abb31,abb32,abb33,abb34,",
                             " abb35,abb36,abb37,abblegal,''",
                             " oct00,oct01,oct02,oct09,oct10,oct11,oct16,oct04,oct13,amt",
                       " FROM p701_1_tmp"
      END CASE
      LET li_count = 0
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      PREPARE p701_2_pre1 FROM l_sql
      DECLARE p701_2_cur1 CURSOR FOR p701_2_pre1
      FOREACH p701_2_cur1 INTO l_abb.abb00,l_abb.abb01,l_abb.abb02,l_abb.abb03,
                               l_abb.abb04,l_abb.abb05,l_abb.abb06,l_abb.abb07f,
                               l_abb.abb07,l_abb.abb08,l_abb.abb11,l_abb.abb12,
                               l_abb.abb13,l_abb.abb14,l_abb.abb15,l_abb.abb24,
                               l_abb.abb25,l_abb.abb31,l_abb.abb32,l_abb.abb33,
                               l_abb.abb34,l_abb.abb35,l_abb.abb36,l_abb.abb37,l_abb.abblegal,
                               l_order,l_oct.oct00,l_oct.oct01,l_oct.oct02,
                               l_oct.oct09,l_oct.oct10,l_oct.oct11,l_oct.oct16,
                               l_oct.oct04,l_oct.oct13,l_amt
         IF STATUS THEN
            CALL cl_err('foreach:',STATUS,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         IF cl_null(l_order_t) THEN LET l_order_t = l_order END IF
         IF li_count = 0 OR l_order_t <> l_order THEN
            LET l_order_t = l_order
            LET li_count = li_count + 1
            LET l_seq = 0
            CALL p701_insaba_values('2',l_order,l_omalegal)
         END IF
         LET l_seq = l_seq + 1
         LET l_abb.abb02 = l_seq
         IF gl_seq = '2' THEN
            EXECUTE p701_2_p6 USING
                l_abb.abb00,gl_no,l_abb.abb02,l_abb.abb03,l_order,
                l_abb.abb05,l_abb.abb06,l_abb.abb07f,l_abb.abb07,l_abb.abb08,
                l_abb.abb11,l_abb.abb12,l_abb.abb13,l_abb.abb14,l_abb.abb15,
                l_abb.abb24,l_abb.abb25,l_abb.abb31,l_abb.abb32,l_abb.abb33,
                l_abb.abb34,l_abb.abb35,l_abb.abb36,l_abb.abb37,l_abb.abblegal
         ELSE
            EXECUTE p701_2_p6 USING
                l_abb.abb00,gl_no,l_abb.abb02,l_abb.abb03,l_abb.abb04,
                l_abb.abb05,l_abb.abb06,l_abb.abb07f,l_abb.abb07,l_abb.abb08,
                l_abb.abb11,l_abb.abb12,l_abb.abb13,l_abb.abb14,l_abb.abb15,
                l_abb.abb24,l_abb.abb25,l_abb.abb31,l_abb.abb32,l_abb.abb33,
                l_abb.abb34,l_abb.abb35,l_abb.abb36,l_abb.abb37,l_abb.abblegal
         END IF
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","abb_file",gl_no,l_seq,SQLCA.sqlcode,"","ins abb:",1)
            LET g_success = 'N'
         END IF
         IF g_success = 'Y' THEN
           #會計科目groupby之後，無法正確知道原來的單號,因此分開處理
            IF gl_seq <> '1' THEN
               IF l_oct.oct16 = '3' THEN
                  UPDATE oct_file SET oct08 = gl_no,oct22 = l_seq
                   WHERE oct01 = l_oct.oct01
                     AND oct02 = l_oct.oct02
                     AND oct09 = l_oct.oct09
                     AND oct10 = l_oct.oct10
                     AND oct11 = l_oct.oct11
                     AND oct16 = l_oct.oct16
                     AND oct00 = l_oct.oct00
               ELSE
                  IF l_amt > 0 THEN
                     UPDATE oct_file SET oct08 = gl_no,oct22 = l_seq  
                      WHERE oct09 = l_oct.oct09
                        AND oct10 = l_oct.oct10
                        AND oct04 = l_oct.oct04
                        AND oct11 = l_oct.oct11
                        AND oct13 = l_oct.oct13
                        AND oct00 = '1'
                        AND (oct16 = '2' OR oct16 = '4')
                     IF SQLCA.sqlcode THEN
                        CALL cl_err3("upd","oct_file",l_oct.oct04,l_oct.oct11,SQLCA.sqlcode,"","upd oct08/gl_no",1) 
                        LET g_success = 'N'
                     END IF
                  END IF
                  IF l_amt < 0 THEN
                     UPDATE oct_file SET oct08 = gl_no,oct22 = l_seq
                      WHERE oct09 = l_oct.oct09
                        AND oct10 = l_oct.oct10
                        AND oct04 = l_oct.oct04
                        AND oct11 = l_oct.oct11
                        AND oct13 = l_oct.oct13
                        AND oct00 = '1'
                        AND (oct16 = '2' OR oct16 = '4')
                     IF SQLCA.sqlcode THEN
                        CALL cl_err3("upd","oct_file",l_oct.oct04,l_oct.oct11,SQLCA.sqlcode,"","upd oct08/gl_no",1) 
                        LET g_success = 'N'
                     END IF
                  END IF
               END IF
            END IF
         END IF
      END FOREACH
      IF g_success = 'Y' THEN
        #會計科目groupby之後，無法正確知道原來的單號,因此分開處理
         IF gl_seq = '1' THEN
            LET l_sql = "SELECT oct00,oct01,oct02,oct09,oct10,oct11,oct16,",
                              " oct04,oct13,amt",
                         " FROM p701_1_tmp"
            PREPARE p701_2_pre2 FROM l_sql
            DECLARE p701_2_cur2 CURSOR FOR p701_2_pre2
            FOREACH p701_2_cur2 INTO l_oct.oct00,l_oct.oct01,l_oct.oct02,
                                     l_oct.oct09,l_oct.oct10,l_oct.oct11,
                                     l_oct.oct16,l_oct.oct04,l_oct.oct13,l_amt 
               IF l_oct.oct16 = '3' THEN
                  UPDATE oct_file SET oct08 = gl_no
                   WHERE oct01 = l_oct.oct01
                     AND oct02 = l_oct.oct02
                     AND oct09 = l_oct.oct09
                     AND oct10 = l_oct.oct10
                     AND oct11 = l_oct.oct11
                     AND oct16 = l_oct.oct16
                     AND oct00 = l_oct.oct00
               ELSE
                  IF l_amt > 0 THEN
                     UPDATE oct_file SET oct08 = gl_no 
                      WHERE oct09 = l_oct.oct09
                        AND oct10 = l_oct.oct10
                        AND oct04 = l_oct.oct04
                        AND oct11 = l_oct.oct11
                        AND oct13 = l_oct.oct13
                        AND oct00 = '1'
                        AND (oct16 = '2' OR oct16 = '4')
                     IF SQLCA.sqlcode THEN
                        CALL cl_err3("upd","oct_file",l_oct.oct04,l_oct.oct11,SQLCA.sqlcode,"","upd oct08/gl_no",1) 
                        LET g_success = 'N'
                     END IF
                  END IF
                  IF l_amt < 0 THEN
                     UPDATE oct_file SET oct08 = gl_no
                      WHERE oct09 = l_oct.oct09
                        AND oct10 = l_oct.oct10
                        AND oct04 = l_oct.oct04
                        AND oct11 = l_oct.oct11
                        AND oct13 = l_oct.oct13
                        AND oct00 = '1'
                        AND (oct16 = '2' OR oct16 = '4')
                     IF SQLCA.sqlcode THEN
                        CALL cl_err3("upd","oct_file",l_oct.oct04,l_oct.oct11,SQLCA.sqlcode,"","upd oct08/gl_no",1) 
                        LET g_success = 'N'
                     END IF
                  END IF
               END IF
            END FOREACH
         END IF
      END IF
     #FUN-B50122---End---
     #FUN-B50122--Begin Mark--
     #改由FUNCTION p701_insaba_values處理
     #IF g_success = 'Y' THEN  #FUN-A60007 
     #   LET g_sql="INSERT INTO ",
     #              #cl_get_target_table(g_dbs_gl,'aba_file'),
     #              cl_get_target_table(g_plant_gl,'aba_file'),
     #             "(aba00,aba01,aba02,aba03,aba04,aba05,",
     #             " aba06,aba07,aba08,aba09,aba12,aba19,aba20,",
     #             " abamksg,abapost,",
     #             " abaprno,abaacti,abauser,abagrup,abadate,",
     #             " abasign,abadays,abaprit,abasmax,abasseq,aba24,aba11,abalegal)",
     #             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
     #             "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"
     #   CALL cl_replace_sqldb(g_sql) RETURNING g_sql         
     #  #CALL cl_parse_qry_sql(g_sql,g_dbs_gl) RETURNING l_sql
     #   CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql    #FUN-A50102
     #   PREPARE p701_1_p4_1 FROM g_sql
     #   LET g_aba.aba01=gl_no1
     #   CALL s_get_doc_no(gl_no1) RETURNING l_aba01t   
     #   SELECT aac08,aacatsg,aacdays,aacprit,aacsign
     #     INTO g_aba.abamksg,l_aac.aacatsg,g_aba.abadays,
     #          g_aba.abaprit,g_aba.abasign
     #     FROM aac_file 
     #    WHERE aac01 = l_aba01t
     #   IF g_aba.abamksg MATCHES  '[Yy]' THEN
     #      IF l_aac.aacatsg matches'[Yy]' THEN
     #         CALL s_sign(g_aba.aba01,4,'aba01','aba_file')
     #              RETURNING g_aba.abasign
     #      END IF
     #      SELECT COUNT(*) INTO g_aba.abasmax
     #        FROM azc_file
     #       WHERE azc01=g_aba.abasign
     #   END IF
     #  #LET l_p1='GL'
     #   LET l_p1='AR'   #CHI-A70058
     #   LET l_p2='0'
     #   LET l_p3='N'
     #   LET l_p4='Y'
     #   LET g_aba.abalegal = l_omalegal
     #   EXECUTE p701_1_p4_1 USING 
     #       p_bookno1,gl_no1,gl_date,g_yy,g_mm,g_today,
     #       l_p1,g_no1,g_debit1,g_credit1,l_p3,l_p3,
     #       l_p2,g_aba.abamksg,l_p3,l_p2,l_p4,g_user,
     #       g_grup,g_today,g_aba.abasign,g_aba.abadays,
     #       g_aba.abaprit,g_aba.abasmax,
     #       l_p2,g_user,g_aba.aba11,l_omalegal  
     #   IF SQLCA.sqlcode THEN
     #      CALL cl_err('ins aba:',SQLCA.sqlcode,1)
     #      LET g_success = 'N'
     #   END IF
     #   CALL s_flows('2',g_ooz.ooz02c,gl_no1,gl_date,l_p3,'',TRUE)   #No.TQC-B70021
     #   DELETE FROM tmn_file 
     #    WHERE tmn01 = p_plant 
     #      AND tmn02 = gl_no1
     #      AND tmn06 = p_bookno1
     #END IF  #FUN-A60007 add
     #FUN-B50122---End Mark---
END FUNCTION
#No.FUN-9A0036

#FUN-A10005 --Begin
FUNCTION p701_def_abb(p_ahf01,p_ahf02,p_abb,p_key1,p_key2,p_key3,p_bookno)
DEFINE p_ahf01    LIKE ahf_file.ahf01      # 科目  
DEFINE p_ahf02    LIKE ahf_file.ahf02      # 程式代號  傳 g_prog
DEFINE p_abb      RECORD LIKE abb_file.*   # 
DEFINE p_key1     LIKE type_file.chr1000   #LIKE ahf_file.ahf01
DEFINE p_key2     LIKE type_file.chr1000   #LIKE ahf_file.ahf01
DEFINE p_key3     LIKE type_file.chr1000   #LIKE ahf_file.ahf01
DEFINE p_bookno   LIKE aag_file.aag00
DEFINE l_aag      RECORD LIKE aag_file.*
DEFINE l_ahf      RECORD LIKE ahf_file.*
DEFINE l_sql      LIKE type_file.chr1000
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_seq      LIKE type_file.num5
DEFINE p_ahf00    LIKE ahf_file.ahf00
   WHENEVER ERROR CALL cl_err_msg_log

   #將上一科目的預設值清空
   LET p_abb.abb11=''
   LET p_abb.abb12=''
   LET p_abb.abb13=''
   LET p_abb.abb14=''
   LET p_abb.abb31=''
   LET p_abb.abb32=''
   LET p_abb.abb33=''
   LET p_abb.abb34=''
   LET p_abb.abb35=''
   LET p_abb.abb36=''
   LET p_abb.abb37=''

   SELECT COUNT(*) INTO l_cnt   FROM ahf_file
    WHERE ahf01=p_ahf01 
      AND ahf02=p_ahf02
      AND ahf00=p_bookno
   IF l_cnt = 0 THEN RETURN p_abb.* END IF

   FOR l_seq = 1 TO g_aaz.aaz88
     INITIALIZE l_aag.* TO NULL
     INITIALIZE l_ahf.* TO NULL
     SELECT * INTO l_aag.* FROM aag_file WHERE aag01=p_abb.abb03
                                           AND aag00=p_bookno
     CASE l_seq
        WHEN 1
             SELECT * INTO l_ahf.* FROM ahf_file
              WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='1'
                AND ahf00=p_bookno
             CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)
             RETURNING p_abb.abb11

        WHEN 2
             SELECT * INTO l_ahf.* FROM ahf_file
              WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='2'
                AND ahf00=p_bookno
             CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)
             RETURNING p_abb.abb12

        WHEN 3
             SELECT * INTO l_ahf.* FROM ahf_file
              WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='3'
                AND ahf00=p_bookno
             CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)
             RETURNING p_abb.abb13

        WHEN 4
             SELECT * INTO l_ahf.* FROM ahf_file
              WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='4'
                AND ahf00=p_bookno
             CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)
             RETURNING p_abb.abb14
#FUN-B50105   ---start   Add
     END CASE
   END FOR
        
   FOR l_seq = 1 TO g_aaz.aaz125
     INITIALIZE l_aag.* TO NULL
     INITIALIZE l_ahf.* TO NULL
     SELECT * INTO l_aag.* FROM aag_file WHERE aag01=p_abb.abb03
                                           AND aag00=p_bookno
     CASE l_seq
#FUN-B50105   ---end     Add
        WHEN 5
             SELECT * INTO l_ahf.* FROM ahf_file
              WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='5'
                AND ahf00=p_bookno
             CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)
             RETURNING p_abb.abb31

        WHEN 6
             SELECT * INTO l_ahf.* FROM ahf_file
              WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='6'
                AND ahf00=p_bookno
             CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)
             RETURNING p_abb.abb32

        WHEN 7
             SELECT * INTO l_ahf.* FROM ahf_file
              WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='7'
                AND ahf00=p_bookno
             CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)
             RETURNING p_abb.abb33

        WHEN 8
             SELECT * INTO l_ahf.* FROM ahf_file
              WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='8'
                AND ahf00=p_bookno
             CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)
             RETURNING p_abb.abb34

        WHEN 9
             SELECT * INTO l_ahf.* FROM ahf_file
              WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='9'
                AND ahf00=p_bookno
             CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)
             RETURNING p_abb.abb35

        WHEN 10
             SELECT * INTO l_ahf.* FROM ahf_file
              WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='10'
                AND ahf00=p_bookno
             CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)
             RETURNING p_abb.abb36
     END CASE
   END FOR
   #for 關係人
   INITIALIZE l_ahf.* TO NULL
   SELECT * INTO l_ahf.* FROM ahf_file
    WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='99'
      AND ahf00=p_bookno
   CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)
   RETURNING p_abb.abb37
   RETURN p_abb.*
END FUNCTION
FUNCTION p701_set_values(p_abb,p_oma930,p_oma15,p_oma63,p_omb40,p_key)
DEFINE p_key                 LIKE oct_file.oct01
DEFINE p_oma930              LIKE oma_file.oma930
DEFINE p_oma15               LIKE oma_file.oma15 
DEFINE p_oma63               LIKE oma_file.oma63 
DEFINE p_omb40               LIKE omb_file.omb40
DEFINE p_abb    RECORD LIKE abb_file.*
DEFINE l_abb    RECORD LIKE abb_file.*
DEFINE l_aag05               LIKE aag_file.aag05 
DEFINE l_aag21               LIKE aag_file.aag21 
DEFINE l_aag23               LIKE aag_file.aag23 
DEFINE l_aag371              LIKE aag_file.aag371 #MOD-B10115 
DEFINE l_occ37               LIKE occ_file.occ37  #MOD-B10115

   LET l_abb.*=p_abb.*
   LET l_abb.abb05 = ''
   LET l_abb.abb15 = ''
   LET l_abb.abb08 = ''

   LET l_aag05 = ''                        #MOD-B10115 
   LET l_aag21 = ''                        #MOD-B10115
   LET l_aag23 = ''                        #MOD-B10115
   LET l_aag371 = ''                       #MOD-B10115

   SELECT aag05,aag21,aag23,aag371         #MOD-B10115 add aag371 
     INTO l_aag05,l_aag21,l_aag23,l_aag371 #MOD-B10115 add aag371
     FROM aag_file
    WHERE aag00 = l_abb.abb00
      AND aag01 = l_abb.abb03

   IF l_aag05 = 'Y' THEN
      IF g_aaz.aaz90='Y' THEN
         LET l_abb.abb05 = p_oma930
      ELSE
         LET l_abb.abb05 = p_oma15
      END IF
   END IF
 
   IF l_aag21 = 'Y' THEN
      LET l_abb.abb15 = p_omb40
   END IF

   IF l_aag23 = 'Y' THEN
      LET l_abb.abb08 = p_oma63
   END IF
       
  #CALL p701_def_abb(l_abb.abb03,'aglp701',l_abb.*,p_key,'','',l_abb.abb00)   #MOD-A90034 mark
   CALL p701_def_abb(l_abb.abb03,'axrt300',l_abb.*,p_key,'','',l_abb.abb00)   #MOD-A90034
   RETURNING l_abb.*

  #-MOD-B10115-add-
   IF l_aag371 MATCHES '[234]' THEN         
      SELECT occ37 INTO l_occ37
        FROM occ_file
       WHERE occ01 = g_oma03
      IF cl_null(l_abb.abb37) THEN
         IF l_occ37 = 'Y' THEN
            LET l_abb.abb37 = g_oma03 
         END IF 
      END IF 
   END IF 
  #-MOD-B10115-end-

   RETURN l_abb.*
END FUNCTION
#FUN-A10005 --End
#-MOD-B10115-add-
FUNCTION p701_create_temp_table()

   DROP TABLE p701_tmp
   CREATE TEMP TABLE p701_tmp(
   oct00  LIKE oct_file.oct00,
   oct09  LIKE oct_file.oct09,
   oct10  LIKE oct_file.oct10,
   oct04  LIKE oct_file.oct04,
   oct11  LIKE oct_file.oct11,
   oct13  LIKE oct_file.oct13,
   oct14  LIKE oct_file.oct14,
   oct14f LIKE oct_file.oct14f,
   oct15  LIKE oct_file.oct15,
   oct15f LIKE oct_file.oct15f,
   oct16  LIKE oct_file.oct16,
   type   LIKE type_file.chr1,
   oct23  LIKE oct_file.oct23)    #FUN-B50122

END FUNCTION 
#-MOD-B10115-end-
#FUN-B50122--begin--
FUNCTION p701_insaba_values(l_type,l_order,l_omalegal)
DEFINE l_aac          RECORD LIKE aac_file.*  
DEFINE l_aba01t              LIKE aba_file.aba01
DEFINE l_p1                  LIKE aba_file.aba06
DEFINE l_p2                  LIKE aba_file.aba08
DEFINE l_p3,l_p4             LIKE type_file.chr1
DEFINE li_result             LIKE type_file.num5
DEFINE l_order               LIKE type_file.chr30
DEFINE l_sql                 LIKE type_file.chr1000 
DEFINE l_type                LIKE type_file.chr1
DEFINE l_omalegal            LIKE oma_file.omalegal

   IF l_type = "1" THEN
      CALL s_auto_assign_no("agl",g_no2,gl_date,"1","","",g_plant_gl,"",g_ooz.ooz02b)
           RETURNING li_result,gl_no
   ELSE
      CALL s_auto_assign_no("agl",g_no2,gl_date,"1","","",g_plant_gl,"",g_ooz.ooz02c)
           RETURNING li_result,gl_no1
   END IF
   IF li_result = 0 THEN LET g_success = 'N' END IF
   IF g_bgjob = "N" THEN
      MESSAGE    "Insert G/L voucher no:",gl_no
      CALL ui.Interface.refresh()
   END IF
   LET g_sql="INSERT INTO ",
             cl_get_target_table(g_plant_gl,'aba_file'),
             "(aba00,aba01,aba02,aba03,aba04,aba05,",
             " aba06,aba07,aba08,aba09,aba12,aba19,aba20,",
             " abamksg,abapost,",
             " abaprno,abaacti,abauser,abagrup,abadate,",
             " abasign,abadays,abaprit,abasmax,abasseq,aba24,aba11,abalegal)",
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
             "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   PREPARE p701_1_p4 FROM g_sql
   LET g_aba.aba01=gl_no
   CALL s_get_doc_no(gl_no) RETURNING l_aba01t   
   SELECT aac08,aacatsg,aacdays,aacprit,aacsign
     INTO g_aba.abamksg,l_aac.aacatsg,g_aba.abadays,
          g_aba.abaprit,g_aba.abasign
     FROM aac_file WHERE aac01 = l_aba01t
   IF g_aba.abamksg MATCHES  '[Yy]' THEN
      IF l_aac.aacatsg matches'[Yy]' THEN
         CALL s_sign(g_aba.aba01,4,'aba01','aba_file')
              RETURNING g_aba.abasign
      END IF
      SELECT COUNT(*) INTO g_aba.abasmax
        FROM azc_file
       WHERE azc01=g_aba.abasign
   END IF
   LET l_p1='AR'
   LET l_p2='0'
   LET l_p3='N'
   LET l_p4='Y'
   IF gl_seq = '2' THEN
      LET l_sql = "SELECT sum(abb07)",
                   " FROM p701_1_tmp",
                  " WHERE abb06 = '1' AND l_order = '",l_order,"'", 
                  " GROUP BY l_order"
      DECLARE p701_abadebit SCROLL CURSOR FROM l_sql
      OPEN p701_abadebit
      FETCH p701_abadebit INTO g_debit
      CLOSE p701_abadebit

      LET l_sql = "SELECT sum(abb07)",
                   " FROM p701_1_tmp",
                  " WHERE abb06 = '2' AND l_order = '",l_order,"'", 
                  " GROUP BY l_order"
      DECLARE p701_abacredit SCROLL CURSOR FROM l_sql
      OPEN p701_abacredit
      FETCH p701_abacredit INTO g_credit
      CLOSE p701_abacredit
   END IF 
   EXECUTE p701_1_p4 USING p_bookno,gl_no,gl_date,g_yy,g_mm,g_today,
                           l_p1,'',g_debit,g_credit,l_p3,l_p3,
                           l_p2,g_aba.abamksg,l_p3,l_p2,l_p4,g_user,
                           g_grup,g_today,g_aba.abasign,g_aba.abadays,g_aba.abaprit,g_aba.abasmax,
                           l_p2,g_user,g_aba.aba11,l_omalegal
   IF SQLCA.sqlcode THEN
      CALL cl_err('ins aba:',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   IF l_type = "1" THEN
      CALL s_flows('2',g_ooz.ooz02b,gl_no,gl_date,l_p3,'',TRUE)  
   ELSE
      CALL s_flows('2',g_ooz.ooz02c,gl_no,gl_date,l_p3,'',TRUE)
   END IF
   DELETE FROM tmn_file 
      WHERE tmn01 = p_plant AND tmn02 = gl_no 
        AND tmn06 = p_bookno
   LET g_no1 = gl_no 
END FUNCTION
#FUN-B50122---end---
