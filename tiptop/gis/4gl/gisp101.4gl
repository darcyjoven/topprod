# Prog. Version..: '5.30.07-13.05.16(00000)'     #
#
# Pattern name...: gisp101.4gl
# Descriptions...: 銷項發票底稿產生作業
# Date & Author..: No:FUN-C60036 12/06/11 By xuxz 
# Modify.........: No:FUN-C60036 12/07/06 By minpp 修改isa00,isa04,isb02的赋值
# Modify.........: No:FUN-D10103 13/01/22 By zhangweib 修改isa10的赋值
# Modify.........: No:TQC-D20046 13/02/26 By xuxz 背景執行時候運行成功畫面漢化
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
DEFINE  p_row,p_col     LIKE type_file.num5#TQC-D20046 add by xuxz

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
   IF g_oaz92 != 'Y'  AND g_aza.aza47 = 'Y' THEN
      CALL cl_err('','gis-002',1)
      EXIT PROGRAM
   END IF

  #No.FUN-D50034 ---Add--- Start
   DROP TABLE p101_tmpb
   
   CREATE TEMP TABLE p101_tmpb(
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
         CALL p101_tm(0,0)
         IF cl_sure(21,21) THEN
            CALL cl_wait()
            LET g_success = 'Y'
            BEGIN WORK
            CALL s_showmsg_init()
            CALL p101()
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
               CLOSE WINDOW gisp101_w
               EXIT WHILE
            END IF
         END IF
      ELSE
         LET g_success = 'Y'
        #TQC-D20046--add--str--xuxz
        #open 畫面然後關閉，這樣使得後面運行成功否畫面顯示中文
         OPEN WINDOW gisp101_w AT p_row,p_col WITH FORM "gis/42f/gisp101"
            ATTRIBUTE (STYLE = g_win_style CLIPPED)
         CALL cl_ui_init()
         CLOSE WINDOW gisp101_w
        #TQC-D20046--add--end--xuxz
         BEGIN WORK
         CALL p101()
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

FUNCTION p101_tm(p_row,p_col)
   DEFINE  p_row,p_col     LIKE type_file.num5 
   DEFINE  lc_cmd          LIKE zz_file.zz08
   LET p_row = 4 LET p_col = 26

   OPEN WINDOW gisp101_w AT p_row,p_col WITH FORM "gis/42f/gisp101" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()
   CALL cl_opmsg('p')

   WHILE TRUE 
      IF s_shut(0) THEN RETURN END IF
      
      CONSTRUCT BY NAME g_wc ON omf05,omf13,omf03,omf01
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
               WHEN INFIELD(omf05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_omf05"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO omf05
                  NEXT FIELD omf05   
               WHEN INFIELD(omf13)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_omf13"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO omf13
                  NEXT FIELD omf13 
               WHEN INFIELD(omf01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_omf01"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO omf01
                  NEXT FIELD omf01 
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
         CLOSE WINDOW gisp101_w
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
         CLOSE WINDOW gisp101_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF

      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01= 'gisp101'
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('gisp101','9031',1)   
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " ''",
                         " '",g_wc CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('gisp101',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW gisp101_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF 
      
      EXIT WHILE
   END WHILE
END FUNCTION 

FUNCTION p101()
   DEFINE l_isa      RECORD LIKE isa_file.*
   DEFINE l_isb      RECORD LIKE isb_file.*
   DEFINE l_omf      RECORD LIKE omf_file.*
   DEFINE l_omf01      LIKE omf_file.omf01,
          l_omf02      LIKE omf_file.omf02,
          l_omf01_old  LIKE omf_file.omf01,
          l_omf00      LIKE omf_file.omf00,
          l_omf02_old  LIKE omf_file.omf02,
          l_omf13      LIKE omf_file.omf13,
          l_omf19_sum  LIKE type_file.num20_6,
          l_omf19t_sum LIKE type_file.num20_6,
          l_omf19x_sum LIKE type_file.num20_6,
          l_occ231     LIKE occ_file.occ231,
          l_occ261     LIKE occ_file.occ261,
          l_nmt02      LIKE nmt_file.nmt02,
          l_ocj03      LIKE ocj_file.ocj03,
          #isb
          l_omf02_b      LIKE omf_file.omf02
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
   DEFINE  l_gec07    LIKE gec_file.gec07
   DEFINE  l_omf18    LIKE omf_file.omf18

   DELETE FROM p101_tmpb
  #No.FUN-D50034 ---Add--- End
   
   #判斷是否存在符合條件的資料，如果不存在則報錯退出
   LET l_n = 0 
   LET g_sql = "SELECT count(*) ",
               "  FROM omf_file ",
               " WHERE omf08 = 'Y' ",
               "   AND ",g_wc CLIPPED 
   PREPARE p101_pre_cout FROM g_sql
   EXECUTE p101_pre_cout INTO l_n
   IF l_n = 0 THEN 
      CALL s_errmsg('','','SEL','aic-024',1)
      LET g_success='N' 
      RETURN 
   END IF
   LET l_n = 0
   LET g_sql = "SELECT omf00,omf01,omf02,SUM(omf19),SUM(omf19x),SUM(omf19t)",
               "  FROM omf_file ",
               " WHERE omf08 = 'Y' ",
               "   AND ",g_wc CLIPPED 
  #TQC-D20046--mark--str-by xuxz
  #IF g_oaz93 = 'Y' THEN 
  #   LET g_sql = g_sql CLIPPED," AND omfpost = 'Y' " 
  #END IF
  #TQC-D20046--mark--end--by xuxz
   LET g_sql = g_sql CLIPPED,
               " GROUP BY omf00,omf01,omf02 "
   PREPARE p101_pre1 FROM g_sql
   DECLARE p101_curs1 CURSOR FOR p101_pre1

   LET g_sql = "SELECT omf01,omf02,omf13,omf14,omf15,omf17,SUM(omf16),SUM(omf19),SUM(omf19x),SUM(omf19t),omf18",   #No.FUN-D50034  Add omf18
               "  FROM omf_file ",
               " WHERE omf08 = 'Y' ",
               "   AND omf01 = ? ",
               "   AND omf02 = ? ",
               "   AND omf00 = ? ",
               "   AND ",g_wc CLIPPED 
  #TQC-D20046--mark--str-by xuxz
  #IF g_oaz93 = 'Y' THEN
  #   LET g_sql = g_sql CLIPPED," AND omfpost = 'Y' "
  #END IF
  #TQC-D20046--mark--end--by xuxz
   LET g_sql = g_sql CLIPPED,
               " GROUP BY omf01,omf02,omf13,omf14,omf15,omf17,omf18 "   #No.FUN-D50034  Add  omf18
   PREPARE p101_pre2 FROM g_sql
   DECLARE p101_curs2 CURSOR FOR p101_pre2

  #No.FUN-D50034 ---Add--- Start
   LET g_sql = "SELECT * FROM p101_tmpb WHERE ish08 < 0"
   PREPARE p101_sel_tmpb FROM g_sql
   DECLARE p101_tmpb_dec CURSOR FOR p101_sel_tmpb
   LET g_sql = "SELECT * FROM p101_tmpb ORDER BY ish01"
   PREPARE p101_sel_tmpb1 FROM g_sql
   DECLARE p101_tmpb_dec1 CURSOR FOR p101_sel_tmpb1
   #初始化變量
   LET l_omf01 = ''
   LET l_omf01_old = ''
   LET l_omf02 = ''
   LET l_omf02_old = ''
   LET l_omf13 = ''
   LET l_omf19_sum = 0
   LET l_omf19t_sum = 0
   LET l_omf19x_sum = 0
   INITIALIZE l_isa.* TO NULL
   
   #單頭foreach
   FOREACH p101_curs1 INTO l_omf00, l_omf01,l_omf02,l_omf19_sum,
                           l_omf19x_sum,l_omf19t_sum
      #如果單頭isa01，isa02不同
      IF l_omf01 <> l_omf01_old OR l_omf02 <> l_omf01_old 
         OR cl_null(l_omf01_old) OR cl_null(l_omf02_old) THEN
         #判斷是否可以更新
         IF tm.a= 'Y' THEN
            DELETE FROM isb_file
             WHERE isb01 = l_omf01
               AND isb02 IN (SELECT DISTINCT isa04 FROM isa_file
                              WHERE isa01 = l_omf01 AND isa02 = l_omf02 AND isa04 =  l_omf00)
               
            DELETE FROM isa_file
             WHERE isa01 = l_omf01
               AND isa04 =  l_omf00
               AND isa02 = l_omf02

           #No.FUN-D50034 ---Add--- Start
            DELETE FROM isg_file WHERE isg01 = l_omf00
            DELETE FROM ish_file WHERE ish01 = l_omf00
           #No.FUN-D50034 ---Add--- End
            
         END IF 
         
         #isa_file 賦值
        #LET l_isa.isa00 = 0            #FUN-C60036-minpp
         LET l_isa.isa00 = '2'          #FUN-C60036-minpp
         LET l_omf01_old = l_omf01
         LET l_omf02_old = l_omf02
         
         #isa01,isa02,isa03,isa04,isa05,isa051,isa06,isa061
        #SELECT DISTINCT omf01,omf02,omf03,omf04,           #FUN-C60036-minpp
         SELECT DISTINCT omf01,omf02,omf03,omf00,           #FUN-C60036-minpp
                         omf30,                             #No.FUN-D10103   Add
                         omf05,omf051,omf06,omf061
           INTO l_isa.isa01,l_isa.isa02,l_isa.isa03,l_isa.isa04,
                l_isa.isa10,                                #No.FUN-D10103   Add
                l_isa.isa05,l_isa.isa051,l_isa.isa06,l_isa.isa061
           FROM omf_file
          WHERE omf01 = l_omf01
            AND omf02 = l_omf02
            AND omf00 = l_omf00
            
         #isa052,isa053,isa054,isa062
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

        #No.FUN-D50034 ---Add--- Start
         SELECT gec07 INTO l_gec07 FROM gec_file
          WHERE gec01 = l_isa.isa06
        #No.FUN-D50034 ---Add--- End

         #isa07,isa08,isa08x,isa08t
         LET l_isa.isa07 = 0
         LET l_isa.isa08 = l_omf19_sum
         LET l_isa.isa08x = l_omf19x_sum
         LET l_isa.isa08t = l_omf19t_sum         
        #No.FUN-D50034 ---Add--- Start
         LET l_isa.isa08 = cl_digcut(l_isa.isa08,t_azi04)
         LET l_isa.isa08x= cl_digcut(l_isa.isa08x,t_azi04)
         LET l_isa.isa08t= cl_digcut(l_isa.isa08t,t_azi04)
        #No.FUN-D50034 ---Add--- End
         #isa09
         SELECT COUNT(*) INTO l_isa.isa09 FROM omf_file 
          WHERE omf01 = l_omf01
            AND omf02 = l_omf02
            AND omf00 = l_omf00
            
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
         #FUN-C60036--add--str
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
         LET l_isg.isg02 = 0
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
         #FUN-C60036--add-end
      END IF 
      #isb_file
      #项次给初值及其他初始化
      LET l_n = 1
      INITIALIZE l_isb.* TO NULL
      LET l_omf02_b = NULL
      FOREACH p101_curs2 USING l_isa.isa01,l_isa.isa02 ,l_isa.isa04
         INTO l_isb.isb01,l_omf02_b,l_isb.isb04,l_isb.isb05,l_isb.isb06,
              l_isb.isb07,l_isb.isb08,l_isb.isb09,l_isb.isb09x,l_isb.isb09t,
              l_omf18   #No.FUN-D50034   Add
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
         #FUN-C60036--add--str
         ELSE
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
               LET g_showmsg=l_isb.isb01,"/",l_isb.isb02,"/",l_isb.isb03,"/",l_isb.isb11
               CALL s_errmsg('isb01,isb02,isb03,isb11',g_showmsg,'ins_isb',SQLCA.sqlcode,1)
               LET g_success='N'
            END IF
         #FUN-C60036--add-end
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
         LET l_ish.ish15 = l_omf18
         IF l_gec07 = 'Y' THEN
            LET l_ish.ish16 = '1'
         ELSE
            LET l_ish.ish16 = '0'
         END IF
         LET l_ish.ish08 = cl_digcut(l_ish.ish08,t_azi04) 
         LET l_ish.ish11 = cl_digcut(l_ish.ish11,t_azi04) 
         LET l_ish.ish12 = cl_digcut(l_ish.ish12,t_azi04) 
         LET l_ish.ish15 = cl_digcut(l_ish.ish15,t_azi04) 
         INSERT INTO p101_tmpb VALUES(l_ish.*)
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
      FOREACH p101_tmpb_dec INTO l_ish.*
         IF l_ish.ish03 = 'MISC' THEN
            SELECT MAX(ish08) INTO l_ish08 FROM p101_tmpb
             WHERE ish01 = l_ish.ish01
            IF cl_null(l_ish08) THEN LET l_ish08 = 0 END IF
            IF (l_ish08 + l_ish.ish08) > 0 THEN
               UPDATE p101_tmpb SET ish11 = (l_ish.ish08 + l_ish.ish12) * -1
                WHERE ish01 = l_ish.ish01
                  AND ish08 IN (SELECT MAX(ish08) FROM p101_tmpb WHERE ish01 = l_ish.ish01)
               DELETE FROM p101_tmpb WHERE ish01 = l_ish.ish01 AND ish02 = l_ish.ish02
            ELSE
               SELECT COUNT(*) INTO l_cnt FROM p101_tmpb WHERE ish01 = l_ish.ish01 AND ish08 > 0
               IF l_cnt > 0 THEN
                  LET t_ish08 = (l_ish.ish08 + l_ish.ish12) / l_cnt
                  LET t_ish08 =  cl_digcut(t_ish08,g_azi04)
                  LET t_ish08_1 = t_ish08 * l_cnt - (l_ish.ish08 + l_ish.ish12)
                  IF t_ish08_1 = 0 THEN LET t_ish08_1 = t_ish08 END IF
                  LET t_ish08 = t_ish08 * -1
                  LET t_ish08_1 = t_ish08_1 * -1
                  UPDATE p101_tmpb SET ish11 = t_ish08
                   WHERE ish01 = l_ish.ish01
                  UPDATE p101_tmpb SET ish11 = t_ish08_1
                   WHERE ish01 = l_ish.ish01
                     AND ish08 IN (SELECT MAX(ish08) FROM p101_tmpb WHERE ish01 = l_ish.ish01)
                  DELETE FROM p101_tmpb WHERE ish01 = l_ish.ish01 AND ish02 = l_ish.ish02
               END IF
            END IF
         ELSE
            SELECT MAX(ish08) INTO l_ish08 FROM p101_tmpb
             WHERE ish01 = l_ish.ish01
               AND ish03 = l_ish.ish03
            IF cl_null(l_ish08) THEN LET l_ish08 = 0 END IF
            IF (l_ish08 + l_ish.ish08) > 0 THEN
               UPDATE p101_tmpb SET ish11 = (l_ish.ish08 + l_ish.ish12) * -1
                WHERE ish01 = l_ish.ish01
                  AND ish03 = l_ish.ish03
                  AND ish08 IN (SELECT MAX(ish08) FROM p101_tmpb WHERE ish01 = l_ish.ish01 AND ish03 = l_ish.ish03)
               DELETE FROM p101_tmpb WHERE ish01 = l_ish.ish01 AND ish02 = l_ish.ish02
            ELSE
               SELECT COUNT(*) INTO l_cnt FROM p101_tmpb WHERE ish01 = l_ish.ish01 AND ish03 = l_ish.ish03 AND ish08 > 0
               IF l_cnt > 0 THEN
                  LET t_ish08 = (l_ish.ish08 + l_ish.ish12) / l_cnt
                  LET t_ish08 =  cl_digcut(t_ish08,g_azi04)
                  LET t_ish08_1 = t_ish08 * l_cnt - (l_ish.ish08 + l_ish.ish12)
                  IF t_ish08_1 = 0 THEN LET t_ish08_1 = t_ish08 END IF 
                  LET t_ish08 = t_ish08 * -1
                  LET t_ish08_1 = t_ish08_1 * -1
                  UPDATE p101_tmpb SET ish11 = t_ish08
                   WHERE ish01 = l_ish.ish01
                     AND ish03 = l_ish.ish03
                  UPDATE p101_tmpb SET ish11 = t_ish08_1
                   WHERE ish01 = l_ish.ish01
                     AND ish03 = l_ish.ish03
                     AND ish08 IN (SELECT MAX(ish08) FROM p101_tmpb WHERE ish01 = l_ish.ish01 AND ish03 = l_ish.ish03)
                  DELETE FROM p101_tmpb WHERE ish01 = l_ish.ish01 AND ish02 = l_ish.ish02
               END IF
            END IF
         END IF
      END FOREACH
      LET l_ish01 = ' '
      FOREACH p101_tmpb_dec1 INTO l_ish.*
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
#FUN-C60036
