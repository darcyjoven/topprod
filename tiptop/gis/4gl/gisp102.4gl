# Prog. Version..: '5.30.07-13.05.16(00000)'     #
#
# Pattern name...: gisp102.4gl
# Descriptions...: 銷項發票底稿產生作業(已開立應收賬款)
# Date & Author..: No:FUN-D10101 13/01/24 By lujh
# Modify.........: No:FUN-D50034 13/05/13 By zhangweib 发票咨询写入isg_file/ish_file,并调整负数行至正数行中

DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE g_wc            STRING 
DEFINE g_oaz92         LIKE oaz_file.oaz92
DEFINE g_oaz93         LIKE oaz_file.oaz93
DEFINE g_change_lang   LIKE type_file.chr1,
       l_flag          LIKE type_file.chr1
DEFINE g_sql           STRING 
DEFINE g_bgjob         LIKE type_file.chr1,
       tm              RECORD 
          a            LIKE type_file.chr1
                       END RECORD 

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
   LET g_wc = ARG_VAL(1)
   LET g_wc    = cl_replace_str(g_wc, "\\\"", "'")
   LET g_bgjob = ARG_VAL(2)
   LET tm.a  = ARG_VAL(3)
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("GIS")) THEN
      EXIT PROGRAM
   END IF

   SELECT oaz92,oaz93 INTO g_oaz92,g_oaz93 FROM oaz_file
   IF g_oaz92 = 'Y'  AND g_aza.aza47 = 'Y' THEN
      CALL cl_err('','gis-002',1)
      EXIT PROGRAM
   END IF

  #No.FUN-D50034 ---Add--- Start
   DROP TABLE p102_tmpb
   
   CREATE TEMP TABLE p102_tmpb(
         ish01      LIKE ish_file.ish01,
         ish02      LIKE ish_file.ish02,
         ish03      LIKE ish_file.ish03,
         ish04      LIKE ish_file.ish04,
         ish05      LIKE ish_file.ish05,
         ish06      LIKE ish_file.ish06,
         ish07      LIKE ish_file.ish07,
         ish08      LIKE ish_file.ish08,
         ish09      LIKE ish_file.ish09,
         ish10      LIKE ish_file.ish10,
         ish11      LIKE ish_file.ish11,
         ish12      LIKE ish_file.ish12,
         ish13      LIKE ish_file.ish13,
         ish14      LIKE ish_file.ish14,
         ish15      LIKE ish_file.ish15,
         ish16      LIKE ish_file.ish16)
  #No.FUN-D50034 ---Add--- End
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   IF cl_null(g_bgjob) THEN LET g_bgjob = 'N' END IF
   WHILE TRUE
      LET g_change_lang = FALSE
      IF g_bgjob = 'N' THEN 
         CALL p102_tm(0,0)
         IF cl_sure(21,21) THEN
            CALL cl_wait()
            LET g_success = 'Y'
            BEGIN WORK
            CALL s_showmsg_init()
            CALL p102()
            CALL s_showmsg()     
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
            ELSE
               ROLLBACK WORK
              CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW gisp102_w
               EXIT WHILE
            END IF
         END IF
      ELSE
         LET g_success = 'Y'
         BEGIN WORK
         CALL p102()
         CALL s_showmsg()                                
         IF g_success = 'Y' THEN
            COMMIT WORK
            CALL cl_err('','lib-284',1)
         ELSE
            ROLLBACK WORK
            CALL cl_err('','abm-020',1)
         END IF 
         EXIT WHILE
      END IF
   END WHILE
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION p102_tm(p_row,p_col)
   DEFINE  p_row,p_col     LIKE type_file.num5 
   DEFINE  lc_cmd          LIKE zz_file.zz08
   
   LET p_row = 4 LET p_col = 26

   OPEN WINDOW gisp102_w AT p_row,p_col WITH FORM "gis/42f/gisp102" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()
   CALL cl_opmsg('p')

   WHILE TRUE 
      IF s_shut(0) THEN RETURN END IF
      
      CONSTRUCT BY NAME g_wc ON omg04,omg14,omg03,omg01
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
          ON ACTION about         
             CALL cl_about()      
 
          ON ACTION help          
             CALL cl_show_help()  
 
          ON ACTION controlg      
             CALL cl_cmdask() 
            
          ON ACTION CONTROLP
            CASE
               WHEN INFIELD(omg04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_omg04"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO omg04
                  NEXT FIELD omg04   
               WHEN INFIELD(omg14)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_omg14"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO omg14
                  NEXT FIELD omg14 
               WHEN INFIELD(omg01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_omg01"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO omg01
                  NEXT FIELD omg01 
            END CASE 
         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT CONSTRUCT
      END CONSTRUCT
      
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()              
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW gisp102_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      LET tm.a = 'N'
      INPUT tm.a,g_bgjob FROM a,bgjob
         ON ACTION CONTROLZ
            CALL cl_show_req_fields()

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
            LET g_change_lang = TRUE
            EXIT INPUT
      END INPUT
      
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()           
         CONTINUE WHILE
      END IF
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW gisp102_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF

      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01= 'gisp102'
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('gisp102','9031',1)   
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " ''",
                         " '",g_wc CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('gisp102',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW gisp102_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF 
      
      EXIT WHILE
   END WHILE
END FUNCTION 

FUNCTION p102()
   DEFINE l_isa      RECORD LIKE isa_file.*
   DEFINE l_isb      RECORD LIKE isb_file.*
   DEFINE l_omg      RECORD LIKE omg_file.*
   DEFINE l_omg01      LIKE omg_file.omg01,
          l_omg02      LIKE omg_file.omg02,
          l_omg01_old  LIKE omg_file.omg01,
          l_omg00      LIKE omg_file.omg00,
          l_omg02_old  LIKE omg_file.omg02,
          l_omg14      LIKE omg_file.omg14,
          l_omg20_sum  LIKE type_file.num20_6,
          l_omg20t_sum LIKE type_file.num20_6,
          l_omg20x_sum LIKE type_file.num20_6,
          l_occ231     LIKE occ_file.occ231,
          l_occ261     LIKE occ_file.occ261,
          l_nmt02      LIKE nmt_file.nmt02,
          l_ocj03      LIKE ocj_file.ocj03,
          #isb
          l_omg02_b      LIKE omg_file.omg02
   DEFINE l_n          LIKE type_file.num10
   DEFINE l_isa07      LIKE isa_file.isa07
  #No.FUN-D50034 ---Add--- Start
   DEFINE  l_isg      RECORD LIKE isg_file.*
   DEFINE  l_ish      RECORD LIKE ish_file.*
   DEFINE  l_ish01    LIKE ish_file.ish01
   DEFINE  l_ish02    LIKE ish_file.ish02
   DEFINE  l_ish08    LIKE ish_file.ish08
   DEFINE  t_ish08    LIKE ish_file.ish08
   DEFINE  t_ish08_1  LIKE ish_file.ish08
   DEFINE  l_cnt      LIKE type_file.num5
   DEFINE  l_i        LIKE type_file.num5
   DEFINE  l_omb15    LIKE omb_file.omb15
   DEFINE  l_oma213   LIKE oma_file.oma213
  #No.FUN-D50034 ---Add--- End
   

   #判斷是否存在符合條件的資料，如果不存在則報錯退出
   LET l_n = 0 
   LET g_sql = "SELECT count(*) ",
               "  FROM omg_file ",
               " WHERE omg08 = 'Y' ",
               "   AND ",g_wc CLIPPED 
   PREPARE p102_pre_cout FROM g_sql
   EXECUTE p102_pre_cout INTO l_n
   IF l_n = 0 THEN 
      CALL s_errmsg('','','SEL','aic-024',1)
      LET g_success='N' 
      RETURN 
   END IF
   LET l_n = 0
   LET g_sql = "SELECT omg00,omg01,omg02,SUM(omg20),SUM(omg20x),SUM(omg20t)",
               "  FROM omg_file ",
               " WHERE omg08 = 'Y' ",
               "   AND ",g_wc CLIPPED 
   IF g_oaz93 = 'Y' THEN 
      LET g_sql = g_sql CLIPPED," AND omgpost = 'Y' " 
   END IF
   LET g_sql = g_sql CLIPPED,
               " GROUP BY omg00,omg01,omg02 "
   PREPARE p102_pre1 FROM g_sql
   DECLARE p102_curs1 CURSOR FOR p102_pre1

   LET g_sql = "SELECT omg01,omg02,omg14,omg15,omg16,omg18,SUM(omg17),SUM(omg20),SUM(omg20x),SUM(omg20t),omb15,oma213",  #No.FUN-D50034 Add omb15 oma213
               "  FROM omg_file,(SELECT omb01,omb03,omb15,oma213 FROM omb_file,omg_file,oma_file WHERE omb01 = omg11 AND omb03 = omg23 AND oma01 = omb01 ) b ", #No.FUN-D50034   Add
               " WHERE omg08 = 'Y' ",
               "   AND omg01 = ? ",
               "   AND omg02 = ? ",
               "   AND omg00 = ? ",
               "   AND omg11 = b.omb01 ",
               "   AND omg23 = b.omb03 ",
               "   AND ",g_wc CLIPPED 
   IF g_oaz93 = 'Y' THEN
      LET g_sql = g_sql CLIPPED," AND omgpost = 'Y' "
   END IF
   LET g_sql = g_sql CLIPPED,
               " GROUP BY omg01,omg02,omg14,omg15,omg16,omg18,omb15,oma213 " #No.FUN-D50034  Add omb15,oma213
   PREPARE p102_pre2 FROM g_sql
   DECLARE p102_curs2 CURSOR FOR p102_pre2
  #No.FUN-D50034 ---Add--- Start
   LET g_sql = "SELECT * FROM p102_tmpb WHERE ish08 < 0"
   PREPARE p102_sel_tmpb FROM g_sql
   DECLARE p102_tmpb_dec CURSOR FOR p102_sel_tmpb
   LET g_sql = "SELECT * FROM p102_tmpb ORDER BY ish01"
   PREPARE p102_sel_tmpb1 FROM g_sql
   DECLARE p102_tmpb_dec1 CURSOR FOR p102_sel_tmpb1
  #No.FUN-D50034 ---Add--- End
   
   #初始化變量
   LET l_omg01 = ''
   LET l_omg01_old = ''
   LET l_omg02 = ''
   LET l_omg02_old = ''
   LET l_omg14 = ''
   LET l_omg20_sum = 0
   LET l_omg20t_sum = 0
   LET l_omg20x_sum = 0
   INITIALIZE l_isa.* TO NULL
   
   #單頭foreach
   FOREACH p102_curs1 INTO l_omg00, l_omg01,l_omg02,l_omg20_sum,
                           l_omg20x_sum,l_omg20t_sum
      #如果單頭isa01，isa02不同
      IF l_omg01 <> l_omg01_old OR l_omg02 <> l_omg01_old 
         OR cl_null(l_omg01_old) OR cl_null(l_omg02_old) THEN
         #判斷是否可以更新
         IF tm.a= 'Y' THEN
            DELETE FROM isb_file
             WHERE isb01 = l_omg01
               AND isb02 IN (SELECT DISTINCT isa04 FROM isa_file
                              WHERE isa01 = l_omg01 AND isa02 = l_omg02 AND isa04 =  l_omg00)
               
            DELETE FROM isa_file
             WHERE isa01 = l_omg01
               AND isa04 = l_omg00
               AND isa02 = l_omg02

           #No.FUN-D50034 ---Add--- Start
            DELETE FROM isg_file WHERE isg01 = l_omg00
            DELETE FROM ish_file WHERE ish01 = l_omg00
           #No.FUN-D50034 ---Add--- End
           
         END IF 
         
         LET l_isa.isa00 = '3'          
         LET l_omg01_old = l_omg01
         LET l_omg02_old = l_omg02
         
         SELECT DISTINCT omg01,omg02,omg03,omg00,           
                         omg04,omg041,omg05,omg051
           INTO l_isa.isa01,l_isa.isa02,l_isa.isa03,l_isa.isa04,
                l_isa.isa05,l_isa.isa051,l_isa.isa06,l_isa.isa061
           FROM omg_file
          WHERE omg01 = l_omg01
            AND omg02 = l_omg02
            AND omg00 = l_omg00
            
         SELECT occ11,occ231,occ261 
           INTO l_isa.isa052,l_occ231,l_occ261
           FROM occ_file
          WHERE occ01 = l_isa.isa05
          
         LET l_isa.isa053 = l_occ231 CLIPPED,l_occ261 CLIPPED
         SELECT nmt02,ocj03 INTO l_nmt02,l_ocj03 
           FROM nmt_file,ocj_file
          WHERE ocj01 = l_isa.isa05
            AND nmt_file.nmt01 = ocj_file.ocj02
          
         LET l_isa.isa053 = l_occ231 CLIPPED,l_occ261 CLIPPED
         LET l_isa.isa054 = l_nmt02 CLIPPED,l_ocj03 CLIPPED
         
         SELECT gec05 INTO l_isa.isa062 FROM gec_file 
          WHERE gec01 = l_isa.isa06 
            AND gec011 = '2'  #销项
            
         #isa07,isa08,isa08x,isa08t
         LET l_isa.isa07 = 0
         LET l_isa.isa08 = l_omg20_sum
         LET l_isa.isa08x = l_omg20x_sum
         LET l_isa.isa08t = l_omg20t_sum         
         #isa09
         SELECT COUNT(*) INTO l_isa.isa09 FROM omg_file 
          WHERE omg01 = l_omg01
            AND omg02 = l_omg02
            AND omg00 = l_omg00
            
         #isauser,isagrup,isadate,isalegal
         LET l_isa.isauser = g_user
         LET l_isa.isagrup = g_grup
         LET l_isa.isadate = g_today
         LET l_isa.isalegal = g_legal
         LET l_isa.isaorig = g_grup
         LET l_isa.isaoriu = g_user
         #null值及其他值处理
         IF cl_null(l_isa.isa04) THEN LET l_isa.isa04 = ' ' END IF 
         LET l_isa.isamodd = ''
         LET l_isa.isa13 = ''
         LET l_isa.isaud13 = ''
         LET l_isa.isaud14 = ''
         LET l_isa.isaud15 = ''
         #單頭插入操作
         INSERT INTO isa_file VALUES (l_isa.*)  
         IF cl_sql_dup_value(SQLCA.SQLCODE) AND tm.a = 'Y' THEN   
                UPDATE isa_file SET * = l_isa.*
                 WHERE isa01 = l_isa.isa01 AND isa04 = l_isa.isa04
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
               LET g_showmsg=l_isa.isa01,"/",l_isa.isa02,"/",l_isa.isa03
               CALL s_errmsg('isa01,isa02,isa03',g_showmsg,'ins_isa',SQLCA.sqlcode,1)
               LET g_success='N' 
            END IF
         ELSE
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
               LET g_showmsg=l_isa.isa01,"/",l_isa.isa02,"/",l_isa.isa03
               CALL s_errmsg('isa01,isa02,isa03',g_showmsg,'ins_isa',SQLCA.sqlcode,1)
               LET g_success='N'
            END IF   
         END IF 
        #No.FUN-D50034 ---Add--- Start
         INITIALIZE l_isg.* TO NULL
         LET l_isg.isg01 = l_isa.isa04
         LET l_isg.isg02 = l_isa.isa09
         LET l_isg.isg03 = l_isa.isa051
         LET l_isg.isg04 = l_isa.isa052
         LET l_isg.isg05 = l_isa.isa053
         LET l_isg.isg06 = l_isa.isa054
         LET l_isg.isg07 = l_isa.isa10
         LET l_isg.isg08 = Null
         LET l_isg.isg09 = Null
         LET l_isg.isg10 = Null
         LET l_isg.isg11 = l_isa.isa13
         LET l_isg.isg12 = l_isa.isa15
         LET l_isg.isg13 = NULL
         INSERT INTO isg_file VALUES(l_isg.*)
         IF STATUS != 0 OR SQLCA.sqlerrd[3] < 1 THEN
            CALL cl_err3("ins","isg_file",l_isg.isg01,"",SQLCA.SQLCODE,"","ins isg",1)
            LET g_success='N'
         END IF
        #No.FUN-D50034 ---Add--- End
      END IF 
      #isb_file
      #项次给初值及其他初始化
      LET l_n = 1
      INITIALIZE l_isb.* TO NULL
      LET l_omg02_b = NULL
      FOREACH p102_curs2 USING l_isa.isa01,l_isa.isa02 ,l_isa.isa04
         INTO l_isb.isb01,l_omg02_b,l_isb.isb04,l_isb.isb05,l_isb.isb06,
              l_isb.isb07,l_isb.isb08,l_isb.isb09,l_isb.isb09x,l_isb.isb09t,l_omb15,l_oma213  #No.FUN-D50034 Add l_omb15,l_oma213
         LET l_isb.isb02 = l_isa.isa04
         LET l_isb.isb11 = l_isa.isa02
         LET l_isb.isb03 = l_n
         SELECT ima131 INTO l_isb.isb10 FROM ima_file
          WHERE ima01 = l_isb.isb04
         LET l_isb.isblegal = g_legal
         LET l_n = l_n + 1
         #null值及其他值处理
         IF cl_null(l_isb.isb02) THEN LET l_isb.isb02 = ' ' END IF 
         LET l_isb.isbud13 = ''
         LET l_isb.isbud14 = ''
         LET l_isb.isbud15 = ''
         #單身插入操作
         INSERT INTO isb_file VALUES (l_isb.*)
         IF cl_sql_dup_value(SQLCA.SQLCODE) AND tm.a = 'Y' THEN   
                UPDATE isb_file SET * = l_isb.*
                 WHERE isb01 = l_isb.isb01 AND isb02 = l_isb.isb02
                   AND isb03 = l_isb.isb03 AND isb11 = l_isb.isb11
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
               LET g_showmsg=l_isb.isb01,"/",l_isb.isb02,"/",l_isb.isb03,"/",l_isb.isb11
               CALL s_errmsg('isb01,isb02,isb03,isb11',g_showmsg,'ins_isb',SQLCA.sqlcode,1)
               LET g_success='N'
            END IF
         ELSE
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
               LET g_showmsg=l_isb.isb01,"/",l_isb.isb02,"/",l_isb.isb03,"/",l_isb.isb11
               CALL s_errmsg('isb01,isb02,isb03,isb11',g_showmsg,'ins_isb',SQLCA.sqlcode,1)
               LET g_success='N'
            END IF
         END IF
        #No.FUN-D50034 ---Add--- Start
         INITIALIZE l_ish.* TO NULL
         LET l_ish.ish01 = l_isg.isg01
         LET l_ish.ish02 = l_isb.isb03
         LET l_ish.ish03 = l_isb.isb04
         LET l_ish.ish04 = l_isb.isb05
         LET l_ish.ish05 = l_isb.isb07
         LET l_ish.ish06 = l_isb.isb06
         LET l_ish.ish07 = l_isb.isb08
         LET l_ish.ish08 = l_isb.isb09
         LET l_ish.ish09 = l_isa.isa061
         LET l_ish.ish10 = l_isb.isb10
         LET l_ish.ish11 = 0
         LET l_ish.ish12 = l_isb.isb09x
         LET l_ish.ish13 = 0
         LET l_ish.ish14 = 0
         LET l_ish.ish15 = l_omb15
         IF l_oma213 = 'Y' THEN LET l_ish.ish16 = '1' ELSE LET l_ish.ish16 = '0' END IF
         INSERT INTO p102_tmpb VALUES(l_ish.*)
         IF STATUS != 0 OR SQLCA.sqlerrd[3] < 1 THEN
            CALL cl_err3("ins","ish_file",l_ish.ish01,l_ish.ish02,SQLCA.SQLCODE,"","ins ish",1)
            LET g_success='N'
         END IF
        #No.FUN-D50034 ---Add--- End
      END FOREACH
   END FOREACH
  #No.FUN-D50034 ---Add--- Start
   IF g_success = 'Y' THEN
     #是否有負數金額
      FOREACH p102_tmpb_dec INTO l_ish.*
         IF l_ish.ish03 = 'MISC' THEN
            SELECT MAX(ish08) INTO l_ish08 FROM p102_tmpb
             WHERE ish01 = l_ish.ish01
            IF cl_null(l_ish08) THEN LET l_ish08 = 0 END IF
            IF (l_ish08 + l_ish.ish08) > 0 THEN
               UPDATE p102_tmpb SET ish11 = (l_ish.ish08 + l_ish.ish12) * -1
                WHERE ish01 = l_ish.ish01
                  AND ish08 IN (SELECT MAX(ish08) FROM p102_tmpb WHERE ish01 = l_ish.ish01)
               DELETE FROM p102_tmpb WHERE ish01 = l_ish.ish01 AND ish02 = l_ish.ish02
            ELSE
               SELECT COUNT(*) INTO l_cnt FROM p102_tmpb WHERE ish01 = l_ish.ish01 AND ish08 > 0
               IF l_cnt > 0 THEN
                  LET t_ish08 = (l_ish.ish08 + l_ish.ish12) / l_cnt
                  LET t_ish08 =  cl_digcut(t_ish08,g_azi04)
                  LET t_ish08_1 = t_ish08 * l_cnt - (l_ish.ish08 + l_ish.ish12)
                  IF t_ish08_1 = 0 THEN LET t_ish08_1 = t_ish08 END IF
                  LET t_ish08 = t_ish08 * -1
                  LET t_ish08_1 = t_ish08_1 * -1
                  UPDATE p102_tmpb SET ish11 = t_ish08
                   WHERE ish01 = l_ish.ish01
                  UPDATE p102_tmpb SET ish11 = t_ish08_1
                   WHERE ish01 = l_ish.ish01
                     AND ish08 IN (SELECT MAX(ish08) FROM p102_tmpb WHERE ish01 = l_ish.ish01)
                  DELETE FROM p102_tmpb WHERE ish01 = l_ish.ish01 AND ish02 = l_ish.ish02
               END IF
            END IF
         ELSE
            SELECT MAX(ish08) INTO l_ish08 FROM p102_tmpb
             WHERE ish01 = l_ish.ish01
               AND ish03 = l_ish.ish03
            IF cl_null(l_ish08) THEN LET l_ish08 = 0 END IF
            IF (l_ish08 + l_ish.ish08) > 0 THEN
               UPDATE p102_tmpb SET ish11 = (l_ish.ish08 + l_ish.ish12) * -1
                WHERE ish01 = l_ish.ish01
                  AND ish03 = l_ish.ish03
                  AND ish08 IN (SELECT MAX(ish08) FROM p102_tmpb WHERE ish01 = l_ish.ish01 AND ish03 = l_ish.ish03)
               DELETE FROM p102_tmpb WHERE ish01 = l_ish.ish01 AND ish02 = l_ish.ish02
            ELSE
               SELECT COUNT(*) INTO l_cnt FROM p102_tmpb WHERE ish01 = l_ish.ish01 AND ish03 = l_ish.ish03 AND ish08 > 0
               IF l_cnt > 0 THEN
                  LET t_ish08 = (l_ish.ish08 + l_ish.ish12) / l_cnt
                  LET t_ish08 =  cl_digcut(t_ish08,g_azi04)
                  LET t_ish08_1 = t_ish08 * l_cnt - (l_ish.ish08 + l_ish.ish12)
                  IF t_ish08_1 = 0 THEN LET t_ish08_1 = t_ish08 END IF
                  LET t_ish08 = t_ish08 * -1
                  LET t_ish08_1 = t_ish08_1 * -1
                  UPDATE p102_tmpb SET ish11 = t_ish08
                   WHERE ish01 = l_ish.ish01
                     AND ish03 = l_ish.ish03
                  UPDATE p102_tmpb SET ish11 = t_ish08_1
                   WHERE ish01 = l_ish.ish01
                     AND ish03 = l_ish.ish03
                     AND ish08 IN (SELECT MAX(ish08) FROM p102_tmpb WHERE ish01 = l_ish.ish01 AND ish03 = l_ish.ish03)
                  DELETE FROM p102_tmpb WHERE ish01 = l_ish.ish01 AND ish02 = l_ish.ish02
               END IF
            END IF
         END IF
      END FOREACH
      LET l_ish01 = ' '
      FOREACH p102_tmpb_dec1 INTO l_ish.*
         IF l_ish01 != l_ish.ish01 THEN
            LET l_i = 1
         END IF
         LET l_ish.ish02 = l_i
         INSERT INTO ish_file VALUES(l_ish.*)
         UPDATE isg_file SET isg02 = l_ish.ish02
          WHERE isg01 = l_ish.ish01
         LET l_i = l_i + 1
         LET l_ish01 = l_ish.ish01
      END FOREACH
   END IF
  #No.FUN-D50034 ---Add--- End
END FUNCTION
#FUN-D10101 add end
