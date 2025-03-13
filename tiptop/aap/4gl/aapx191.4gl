# Prog. Version..: '5.30.07-13.05.30(00003)'     #
#
# Pattern name...: aapx191.4gl
# Descriptions...: 廠商應付帳齡分析報表
# Date & Author..: #FUN-B60071 11/06/09  By  suncx
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.FUN-BB0038 11/11/14 By elva 简称由单据抓取
# Modify.........: No.FUN-BB0047 11/12/31 By fengrui 調整時間函數問題
# Modify.........: No.TQC-C30333 12/03/30 By zhangll 日期默認帶出月底日期
# Modify.........: No.TQC-C30349 12/04/06 By lujh 增加賬款性質和選項“按原幣打印”,若選項“按原幣打印”勾選時，畫面顯示幣別
# Modify.........: No.FUN-CC0093 13/03/14 By zhangweib CR轉XtraGrid
# Modify.........: No.TQC-D30063 13/03/25 By zhqngweib 補過4gl
# Modify.........: No.TQC-D40018 13/04/08 By zhangweib 補過到正式區
# Modify.........: No.FUN-D40128 13/05/15 By wangrr 更改最大天數g_max_aly04取值

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm  RECORD                         
          wc     LIKE type_file.chr1000,     # Where condition   #No.TQC-D30063 TQC-D40018
          aly01  LIKE aly_file.aly01,
          a      LIKE type_file.chr1,
          edate  LIKE type_file.dat,   
          detail LIKE type_file.chr1,  
          zr     LIKE type_file.chr1,
          org    LIKE type_file.chr1,        #TQC-C30349  add
          more   LIKE type_file.chr1         # Input more condition(Y/N)
       END RECORD

DEFINE   l_table STRING, 
         g_str   STRING,
         g_sql   STRING
DEFINE   g_aly   DYNAMIC ARRAY OF RECORD LIKE aly_file.*
DEFINE   g_field STRING
DEFINE   g_max_aly04      LIKE aly_file.aly04    #No.FUN-CC0093   Add
         
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
  # CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 MARK
   
   LET g_sql = "apa06.apa_file.apa06,",  #客戶
               "apa07.apa_file.apa07,",  #簡稱
               "apa02.apa_file.apa02,",  #Date
               "apa01.apa_file.apa01,",
               "apa13.apa_file.apa13,",     #TQC-C30349  add
               "num01.alz_file.alz09,",
               "num02.alz_file.alz09,",
               "num03.alz_file.alz09,",
               "num04.alz_file.alz09,",
               "num05.alz_file.alz09,",
               "num06.alz_file.alz09,",
               "num07.alz_file.alz09,",
               "num08.alz_file.alz09,",
               "num09.alz_file.alz09,",
               "num010.alz_file.alz09,",
               "num011.alz_file.alz09,",
               "num012.alz_file.alz09,",
               "num013.alz_file.alz09,",
               "num014.alz_file.alz09,",
               "num015.alz_file.alz09,",
               "num016.alz_file.alz09,",
               "num017.alz_file.alz09,",
               "num1.alz_file.alz09,",
               "num2.alz_file.alz09,",
               "num3.alz_file.alz09,",
               "num4.alz_file.alz09,",
               "num5.alz_file.alz09,",
               "num6.alz_file.alz09,",
               "num7.alz_file.alz09,",
               "num8.alz_file.alz09,",
               "num9.alz_file.alz09,",
               "num10.alz_file.alz09,",
               "num11.alz_file.alz09,",
               "num12.alz_file.alz09,",
               "num13.alz_file.alz09,",
               "num14.alz_file.alz09,",
               "num15.alz_file.alz09,",
               "num16.alz_file.alz09,",
               "num17.alz_file.alz09,",
               "tot.alz_file.alz09,",     #No.FUN-CC0093   Add
               "org.type_file.chr1"       #TQC-C30349  add

   LET l_table = cl_prt_temptable('aapx191',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time   #FUN-BB0047 ADD
   INITIALIZE tm.* TO NULL           
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.aly01 = ARG_VAL(8)
   LET tm.a = ARG_VAL(9)
   LET tm.edate = ARG_VAL(10)
   LET tm.detail = ARG_VAL(11)  
   LET tm.zr = ARG_VAL(12)
   LET tm.org = ARG_VAL(13)    #TQC-C30349  add
   #--TQC-C30349--mod--str--
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)
   #--TQC-C30349--mod--end--
 
   IF cl_null(tm.wc) THEN
      CALL x191_tm(0,0)
   ELSE
      CALL x191()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN 

FUNCTION x191_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   LET p_row = 6 LET p_col = 16

 
   OPEN WINDOW aapx191_w AT p_row,p_col WITH FORM "aap/42f/aapx191" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
       
   CALL cl_ui_init()
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.a    = '1'
   LET tm.more = 'N'
  #LET tm.edate = g_today
   LET tm.edate = s_last(g_today)  #TQC-C30333 mod
   LET tm.detail = 'N'
   LET tm.zr = 'N' 
   LET tm.org = 'N'  #TQC-C30349   add
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   SELECT MIN(aly01) INTO tm.aly01 FROM aly_file
   DISPLAY tm.aly01,tm.a,tm.edate,tm.detail,tm.zr,tm.org,tm.more  #TQC-C30349   add  tm.org
        TO tm.aly01,tm.a,tm.edate,tm.detail,tm.zr,tm.org,tm.more  #TQC-C30349   add  tm.org
   CALL x191_get_datas()
   WHILE TRUE 
      DIALOG ATTRIBUTE(UNBUFFERED)
         CONSTRUCT BY NAME tm.wc ON apa22,apa21,pmy01,apa06,apa00  #TQC-C30349   add  apa00

            BEFORE CONSTRUCT
               CALL cl_qbe_init()
               
            ON ACTION CONTROLP
               CASE
                  WHEN INFIELD(apa22)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gem3"
                     LET g_qryparam.plant = g_plant 
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO apa22
                     NEXT FIELD apa22
 
                  WHEN INFIELD(apa21)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gen5"
                     LET g_qryparam.plant = g_plant 
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO apa21
                     NEXT FIELD apa21

                  WHEN INFIELD(pmy01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_pmy"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO pmy01
                     NEXT FIELD pmy01

                  WHEN INFIELD(apa06)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_pmc"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO apa06
                     NEXT FIELD apa06
                     
               END CASE 
         END CONSTRUCT
         
         INPUT BY NAME tm.aly01,tm.a,tm.edate,tm.detail,tm.zr,tm.org,tm.more   #TQC-C30349   add  tm.org 
            ATTRIBUTES (WITHOUT DEFAULTS)
            BEFORE INPUT
               CALL cl_qbe_display_condition(lc_qbe_sn)
               
            AFTER FIELD aly01
               CALL x191_get_datas()  

            ON CHANGE aly01
               CALL x191_get_datas()
               
            AFTER FIELD edate
               IF tm.edate IS NULL THEN
                  CALL cl_err('','aap1000',0)
                  NEXT FIELD edate
               END IF
               IF MONTH(tm.edate) = MONTH(tm.edate+1) THEN
                  CALL cl_err('','aap-993',1)
                  NEXT FIELD edate
               END IF
               
            AFTER FIELD MORE
               IF tm.more = 'Y' THEN 
                  CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
               END IF

            ON ACTION CONTROLP
               CASE
                  WHEN INFIELD(aly01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = 'q_aly01'
                     LET g_qryparam.default1 = tm.aly01
                     CALL cl_create_qry() RETURNING tm.aly01
                     DISPLAY BY NAME tm.aly01
                     CALL x191_get_datas()
                     NEXT FIELD aly01
               END CASE 
         END INPUT
         

         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()
            CALL cl_dynamic_locale()
            CONTINUE DIALOG

         ON ACTION ACCEPT
            LET INT_FLAG = 0
            ACCEPT DIALOG
            
         ON ACTION CANCEL
            LET INT_FLAG = 1
            EXIT DIALOG
            
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
 
         ON ACTION about          
            CALL cl_about()
            CONTINUE DIALOG       
 
         ON ACTION help           
            CALL cl_show_help()
            CONTINUE DIALOG   
 
         ON ACTION controlg       
            CALL cl_cmdask()
            CONTINUE DIALOG    
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT DIALOG
            
         ON ACTION close
            LET INT_FLAG = 1
            EXIT DIALOG 
            
         ON ACTION qbe_select
            CALL cl_qbe_select()

         AFTER DIALOG 
            IF NOT x191_chk_datas() THEN
               IF g_field = "edate" THEN
                  NEXT FIELD edate
               END IF
               IF g_field = "aly01" THEN
                  NEXT FIELD aly01 
               END IF
               IF g_field = "apa22" THEN
                  NEXT FIELD apa22
               END IF
               LET g_field = ''
            END IF  
      END DIALOG 
      
      IF INT_FLAG THEN 
         LET INT_FLAG = 0 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF 
      CALL cl_wait()
      CALL x191()
      ERROR ""
   END WHILE 
   CLOSE WINDOW aapx191_w
END FUNCTION

FUNCTION x191()
   DEFINE l_sql    STRING,
          l_alz09  LIKE alz_file.alz09,   #金额 
          l_alz09f LIKE alz_file.alz09f,  #金额  #TQC-C30349  add 
          l_alz06  LIKE alz_file.alz06,   #立账日期
          l_alz07  LIKE alz_file.alz07,   #付款日期
          l_date   LIKE type_file.dat,
          l_bucket LIKE type_file.num5
   DEFINE i        LIKE type_file.num5    #No.FUN-CC0093   Add
   DEFINE l_str    STRING                 #No.FUN-CC0093   Add 
   DEFINE sr RECORD 
             apa06 LIKE apa_file.apa06,  #客戶
             apa07 LIKE apa_file.apa07,  #簡稱
             apa02 LIKE apa_file.apa02,  #Date
             apa01 LIKE apa_file.apa01,
             apa13 LIKE apa_file.apa13,    #TQC-C30349  add 
             num01 LIKE alz_file.alz09,
             num02 LIKE alz_file.alz09,
             num03 LIKE alz_file.alz09,
             num04 LIKE alz_file.alz09,
             num05 LIKE alz_file.alz09,
             num06 LIKE alz_file.alz09,
             num07 LIKE alz_file.alz09,
             num08 LIKE alz_file.alz09,
             num09 LIKE alz_file.alz09,
             num010 LIKE alz_file.alz09,
             num011 LIKE alz_file.alz09,
             num012 LIKE alz_file.alz09,
             num013 LIKE alz_file.alz09,
             num014 LIKE alz_file.alz09,
             num015 LIKE alz_file.alz09,
             num016 LIKE alz_file.alz09,
             num017 LIKE alz_file.alz09,
             num1 LIKE alz_file.alz09,
             num2 LIKE alz_file.alz09,
             num3 LIKE alz_file.alz09,
             num4 LIKE alz_file.alz09,
             num5 LIKE alz_file.alz09,
             num6 LIKE alz_file.alz09,
             num7 LIKE alz_file.alz09,
             num8 LIKE alz_file.alz09,
             num9 LIKE alz_file.alz09,
             num10 LIKE alz_file.alz09,
             num11 LIKE alz_file.alz09,
             num12 LIKE alz_file.alz09,
             num13 LIKE alz_file.alz09,
             num14 LIKE alz_file.alz09,
             num15 LIKE alz_file.alz09,
             num16 LIKE alz_file.alz09,
             num17 LIKE alz_file.alz09,
             tot    LIKE alz_file.alz09,   #No.FUN-CC0093    Add
             org    LIKE type_file.chr1    #TQC-C30349  add
         END RECORD

   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('apauser', 'apagrup')
   IF g_bgjob='Y' THEN
      CALL x191_get_datas()
   END IF
   CALL cl_del_data(l_table)
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
               " VALUES(?, ?, ?, ?, ?,    ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?,    ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?,    ?, ?, ?, ?, ?, ",
               "        ?, ",                                   #No.FUN-CC0093   Add
               "        ?, ?, ?, ?, ?,    ?, ?, ?, ?, ?)"       #TQC-C30349  add  ?,?                                                                                                   
   PREPARE insert_prep FROM g_sql                                                                                                  
   IF STATUS THEN                                                                                                                   
       CALL cl_err('insert_prep:',status,1)                                                                                        
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
       EXIT PROGRAM                                                                                                                 
   END IF
    
   #抓報表列印資料
   #--TQC-C30349--add--str--
   IF tm.org = 'Y' THEN 
       LET l_sql = "SELECT apa06, apa07,apa02, apa01,apa13,0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0,", 
                   "       0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0,null,alz09f,alz06,alz07 ",   #No.FUN-C0093   Add 0
                   "  FROM apc_file,apa_file,alz_file,pmc_file ",
                   "  LEFT OUTER JOIN pmy_file ON(pmc_file.pmc02=pmy_file.pmy01)",										
                   " WHERE ",tm.wc CLIPPED," AND apa06 = pmc01 AND apa01 = apc01 ",
                   "   AND apa06 = alz01 AND alz00 = '1' AND alz02 = ",YEAR(tm.edate),
                   "   AND alz03 = ",MONTH(tm.edate)," AND alz04 = apa01 ",
                   "   AND alz05 = apc02"
      #選擇扣除折讓資料            
      IF tm.zr = 'Y' THEN LET l_sql=l_sql CLIPPED," AND alz09f>0" END IF
      IF tm.a = '2' THEN  LET l_sql=l_sql CLIPPED," AND alz07<'",tm.edate,"'" END IF								
      PREPARE x191_prepare_01 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('x191_prepare_01:',SQLCA.sqlcode,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      DECLARE x191_curs_01 CURSOR FOR x191_prepare_01
      FOREACH x191_curs_01 INTO sr.*,l_alz09f,l_alz06,l_alz07
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         #判斷應付賬款基準日期
         LET sr.org = 'Y'   
         IF tm.a = '2' THEN LET l_date = l_alz07 ELSE LET l_date = l_alz06 END IF  
         LET l_bucket = tm.edate-l_date
         CASE WHEN l_bucket<=g_aly[1].aly04 LET sr.num01=l_alz09f LET sr.num1=l_alz09f * g_aly[1].aly05/100
                                             LET sr.tot = sr.num01    #No.FUN-CC0093   Add
              WHEN l_bucket<=g_aly[2].aly04 LET sr.num02=l_alz09f LET sr.num2=l_alz09f * g_aly[2].aly05/100
                                             LET sr.tot = sr.num02    #No.FUN-CC0093   Add
              WHEN l_bucket<=g_aly[3].aly04 LET sr.num03=l_alz09f LET sr.num3=l_alz09f * g_aly[3].aly05/100
                                             LET sr.tot = sr.num03    #No.FUN-CC0093   Add
              WHEN l_bucket<=g_aly[4].aly04 LET sr.num04=l_alz09f LET sr.num4=l_alz09f * g_aly[4].aly05/100
                                             LET sr.tot = sr.num04    #No.FUN-CC0093   Add
              WHEN l_bucket<=g_aly[5].aly04 LET sr.num05=l_alz09f LET sr.num5=l_alz09f * g_aly[5].aly05/100
                                             LET sr.tot = sr.num05    #No.FUN-CC0093   Add
              WHEN l_bucket<=g_aly[6].aly04 LET sr.num06=l_alz09f LET sr.num6=l_alz09f * g_aly[6].aly05/100
                                             LET sr.tot = sr.num06    #No.FUN-CC0093   Add
              WHEN l_bucket<=g_aly[7].aly04 LET sr.num07=l_alz09f LET sr.num7=l_alz09f * g_aly[7].aly05/100
                                             LET sr.tot = sr.num07    #No.FUN-CC0093   Add
              WHEN l_bucket<=g_aly[8].aly04 LET sr.num08=l_alz09f LET sr.num8=l_alz09f * g_aly[8].aly05/100
                                             LET sr.tot = sr.num08    #No.FUN-CC0093   Add
              WHEN l_bucket<=g_aly[9].aly04 LET sr.num09=l_alz09f LET sr.num9=l_alz09f * g_aly[9].aly05/100
                                             LET sr.tot = sr.num09    #No.FUN-CC0093   Add
              WHEN l_bucket<=g_aly[10].aly04 LET sr.num010=l_alz09f LET sr.num10=l_alz09f * g_aly[10].aly05/100
                                             LET sr.tot = sr.num10    #No.FUN-CC0093   Add
              WHEN l_bucket<=g_aly[11].aly04 LET sr.num011=l_alz09f LET sr.num11=l_alz09f * g_aly[11].aly05/100
                                             LET sr.tot = sr.num11    #No.FUN-CC0093   Add
              WHEN l_bucket<=g_aly[12].aly04 LET sr.num012=l_alz09f LET sr.num12=l_alz09f * g_aly[12].aly05/100
                                             LET sr.tot = sr.num12    #No.FUN-CC0093   Add
              WHEN l_bucket<=g_aly[13].aly04 LET sr.num013=l_alz09f LET sr.num13=l_alz09f * g_aly[13].aly05/100
                                             LET sr.tot = sr.num13    #No.FUN-CC0093   Add
              WHEN l_bucket<=g_aly[14].aly04 LET sr.num014=l_alz09f LET sr.num14=l_alz09f * g_aly[14].aly05/100
                                             LET sr.tot = sr.num14    #No.FUN-CC0093   Add
              WHEN l_bucket<=g_aly[15].aly04 LET sr.num015=l_alz09f LET sr.num15=l_alz09f * g_aly[15].aly05/100
                                             LET sr.tot = sr.num15    #No.FUN-CC0093   Add
              WHEN l_bucket<=g_aly[16].aly04 LET sr.num016=l_alz09f LET sr.num16=l_alz09f * g_aly[16].aly05/100
                                             LET sr.tot = sr.num16    #No.FUN-CC0093   Add
              OTHERWISE            LET sr.num017=l_alz09f LET sr.num17=l_alz09f
                                             LET sr.tot = sr.num17    #No.FUN-CC0093   Add
         END CASE
         EXECUTE insert_prep USING sr.*
      END FOREACH 	
   ELSE 
   #--TQC-C30349--add--end-- 
      #LET l_sql = "SELECT apa06, pmc03,apa02, apa01,0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0,", #FUN-BB0038
      LET l_sql = "SELECT apa06, apa07,apa02, apa01,apa13,0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0,", #FUN-BB0038   #TQC-C30349   add  apa13
                  "       0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0,null,alz09,alz06,alz07 ",		#TQC-C30349   add null #No.FUN-CC0093 Add 0
                  "  FROM apc_file,apa_file,alz_file,pmc_file ",
                  "  LEFT OUTER JOIN pmy_file ON(pmc_file.pmc02=pmy_file.pmy01)",										
                  " WHERE ",tm.wc CLIPPED," AND apa06 = pmc01 AND apa01 = apc01 ",
                  "   AND apa06 = alz01 AND alz00 = '1' AND alz02 = ",YEAR(tm.edate),
                  "   AND alz03 = ",MONTH(tm.edate)," AND alz04 = apa01 ",
                  "   AND alz05 = apc02"
      #選擇扣除折讓資料            
      IF tm.zr = 'Y' THEN LET l_sql=l_sql CLIPPED," AND alz09>0" END IF
      IF tm.a = '2' THEN  LET l_sql=l_sql CLIPPED," AND alz07<'",tm.edate,"'" END IF								
      PREPARE x191_prepare FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('x191_prepare:',SQLCA.sqlcode,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      DECLARE x191_curs1 CURSOR FOR x191_prepare
      FOREACH x191_curs1 INTO sr.*,l_alz09,l_alz06,l_alz07
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         #判斷應付賬款基準日期
         LET sr.org = 'N'   #TQC-C30349  add
         IF tm.a = '2' THEN LET l_date = l_alz07 ELSE LET l_date = l_alz06 END IF  
         LET l_bucket = tm.edate-l_date
         CASE WHEN l_bucket<=g_aly[1].aly04 LET sr.num01=l_alz09 LET sr.num1=l_alz09 * g_aly[1].aly05/100
                                             LET sr.tot=sr.num01    #No.FUN-CC0093   Add
              WHEN l_bucket<=g_aly[2].aly04 LET sr.num02=l_alz09 LET sr.num2=l_alz09 * g_aly[2].aly05/100
                                             LET sr.tot=sr.num02    #No.FUN-CC0093   Add
              WHEN l_bucket<=g_aly[3].aly04 LET sr.num03=l_alz09 LET sr.num3=l_alz09 * g_aly[3].aly05/100
                                             LET sr.tot=sr.num03    #No.FUN-CC0093   Add
              WHEN l_bucket<=g_aly[4].aly04 LET sr.num04=l_alz09 LET sr.num4=l_alz09 * g_aly[4].aly05/100
                                             LET sr.tot=sr.num04    #No.FUN-CC0093   Add
              WHEN l_bucket<=g_aly[5].aly04 LET sr.num05=l_alz09 LET sr.num5=l_alz09 * g_aly[5].aly05/100
                                             LET sr.tot=sr.num05    #No.FUN-CC0093   Add
              WHEN l_bucket<=g_aly[6].aly04 LET sr.num06=l_alz09 LET sr.num6=l_alz09 * g_aly[6].aly05/100
                                             LET sr.tot=sr.num06    #No.FUN-CC0093   Add
              WHEN l_bucket<=g_aly[7].aly04 LET sr.num07=l_alz09 LET sr.num7=l_alz09 * g_aly[7].aly05/100
                                             LET sr.tot=sr.num07    #No.FUN-CC0093   Add
              WHEN l_bucket<=g_aly[8].aly04 LET sr.num08=l_alz09 LET sr.num8=l_alz09 * g_aly[8].aly05/100
                                             LET sr.tot=sr.num08    #No.FUN-CC0093   Add
              WHEN l_bucket<=g_aly[9].aly04 LET sr.num09=l_alz09 LET sr.num9=l_alz09 * g_aly[9].aly05/100
                                             LET sr.tot=sr.num09    #No.FUN-CC0093   Add
              WHEN l_bucket<=g_aly[10].aly04 LET sr.num010=l_alz09 LET sr.num10=l_alz09 * g_aly[10].aly05/100
                                             LET sr.tot=sr.num10    #No.FUN-CC0093   Add
              WHEN l_bucket<=g_aly[11].aly04 LET sr.num011=l_alz09 LET sr.num11=l_alz09 * g_aly[11].aly05/100
                                             LET sr.tot=sr.num11    #No.FUN-CC0093   Add
              WHEN l_bucket<=g_aly[12].aly04 LET sr.num012=l_alz09 LET sr.num12=l_alz09 * g_aly[12].aly05/100
                                             LET sr.tot=sr.num12    #No.FUN-CC0093   Add
              WHEN l_bucket<=g_aly[13].aly04 LET sr.num013=l_alz09 LET sr.num13=l_alz09 * g_aly[13].aly05/100
                                             LET sr.tot=sr.num13    #No.FUN-CC0093   Add
              WHEN l_bucket<=g_aly[14].aly04 LET sr.num014=l_alz09 LET sr.num14=l_alz09 * g_aly[14].aly05/100
                                             LET sr.tot=sr.num14    #No.FUN-CC0093   Add
              WHEN l_bucket<=g_aly[15].aly04 LET sr.num015=l_alz09 LET sr.num15=l_alz09 * g_aly[15].aly05/100
                                             LET sr.tot=sr.num15    #No.FUN-CC0093   Add
              WHEN l_bucket<=g_aly[16].aly04 LET sr.num016=l_alz09 LET sr.num16=l_alz09 * g_aly[16].aly05/100
                                             LET sr.tot=sr.num16    #No.FUN-CC0093   Add
              OTHERWISE            LET sr.num017=l_alz09 LET sr.num17=l_alz09
                                             LET sr.tot=sr.num17    #No.FUN-CC0093   Add
         END CASE
         EXECUTE insert_prep USING sr.*
      END FOREACH 	
   #--TQC-C30349--add--str-- 
   END IF 
   #--TQC-C30349--add--end-- 
   
   INITIALIZE g_str TO NULL
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
###XtraGrid###   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   #是否列印選擇條件   
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'oma15,oma14,oca01,oma03')
           RETURNING tm.wc
   END IF
   LET g_str = tm.wc
###XtraGrid###   LET g_str = g_str CLIPPED,";",
###XtraGrid###       g_aly[1].aly04,";",g_aly[2].aly04,";",g_aly[3].aly04,";",g_aly[4].aly04,";",
###XtraGrid###       g_aly[5].aly04,";",g_aly[6].aly04,";",g_aly[7].aly04,";",g_aly[8].aly04,";",
###XtraGrid###       g_aly[9].aly04,";",g_aly[10].aly04,";",g_aly[11].aly04,";",g_aly[12].aly04,";",
###XtraGrid###       g_aly[13].aly04,";",g_aly[14].aly04,";",g_aly[15].aly04,";",g_aly[16].aly04,";",
###XtraGrid###       tm.a,";",tm.edate,";",tm.detail
###XtraGrid###   CALL cl_prt_cs3('aapx191','aapx191',l_sql,g_str)
    LET g_xgrid.table = l_table    ###XtraGrid###
   #No.FUN-CC0093 ---start--- Add
   #動態標題  
    FOR i = 1 TO 16  
        IF NOT cl_null(g_aly[i].aly04) THEN
           CASE i    
              WHEN 1 LET l_str = "0-",g_aly[i].aly04 USING '<<<<',cl_getmsg('axr1007',g_lang) #組合成 0-30帳款金額
                     LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,"num01",l_str,"") #放入動態標題變數
                     LET l_str = "0-",g_aly[i].aly04 USING '<<<<',cl_getmsg('axr1008',g_lang) #組合成 0-30呆帳金額
                     LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,"num1",l_str,"")
              WHEN 2 LET l_str = g_aly[i-1].aly04 USING '<<<<',"-",g_aly[i].aly04 USING '<<<<',cl_getmsg('axr1007',g_lang)
                     LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,"num02",l_str,"")
                     LET l_str = g_aly[i-1].aly04 USING '<<<<',"-",g_aly[i].aly04 USING '<<<<',cl_getmsg('axr1008',g_lang)
                     LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,"num2",l_str,"")
              WHEN 3 LET l_str = g_aly[i-1].aly04 USING '<<<<',"-",g_aly[i].aly04 USING '<<<<',cl_getmsg('axr1007',g_lang)
                     LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,"num03",l_str,"")
                     LET l_str = g_aly[i-1].aly04 USING '<<<<',"-",g_aly[i].aly04 USING '<<<<',cl_getmsg('axr1008',g_lang)
                     LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,"num3",l_str,"")
              WHEN 4 LET l_str = g_aly[i-1].aly04 USING '<<<<',"-",g_aly[i].aly04 USING '<<<<',cl_getmsg('axr1007',g_lang)
                     LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,"num04",l_str,"")
                     LET l_str = g_aly[i-1].aly04 USING '<<<<',"-",g_aly[i].aly04 USING '<<<<',cl_getmsg('axr1008',g_lang)
                     LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,"num4",l_str,"")
              WHEN 5 LET l_str = g_aly[i-1].aly04 USING '<<<<',"-",g_aly[i].aly04 USING '<<<<',cl_getmsg('axr1007',g_lang)
                     LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,"num05",l_str,"")
                     LET l_str = g_aly[i-1].aly04 USING '<<<<',"-",g_aly[i].aly04 USING '<<<<',cl_getmsg('axr1008',g_lang)
                     LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,"num5",l_str,"")
              WHEN 6 LET l_str = g_aly[i-1].aly04 USING '<<<<',"-",g_aly[i].aly04 USING '<<<<',cl_getmsg('axr1007',g_lang)
                     LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,"num06",l_str,"")
                     LET l_str = g_aly[i-1].aly04 USING '<<<<',"-",g_aly[i].aly04 USING '<<<<',cl_getmsg('axr1008',g_lang)
                     LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,"num6",l_str,"")
              WHEN 7 LET l_str = g_aly[i-1].aly04 USING '<<<<',"-",g_aly[i].aly04 USING '<<<<',cl_getmsg('axr1007',g_lang)
                     LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,"num07",l_str,"")
                     LET l_str = g_aly[i-1].aly04 USING '<<<<',"-",g_aly[i].aly04 USING '<<<<',cl_getmsg('axr1008',g_lang)
                     LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,"num7",l_str,"")
              WHEN 8 LET l_str = g_aly[i-1].aly04 USING '<<<<',"-",g_aly[i].aly04 USING '<<<<',cl_getmsg('axr1007',g_lang)
                     LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,"num08",l_str,"")
                     LET l_str = g_aly[i-1].aly04 USING '<<<<',"-",g_aly[i].aly04 USING '<<<<',cl_getmsg('axr1008',g_lang)
                     LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,"num8",l_str,"")
              WHEN 9 LET l_str = g_aly[i-1].aly04 USING '<<<<',"-",g_aly[i].aly04 USING '<<<<',cl_getmsg('axr1007',g_lang)
                     LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,"num09",l_str,"")
                     LET l_str = g_aly[i-1].aly04 USING '<<<<',"-",g_aly[i].aly04 USING '<<<<',cl_getmsg('axr1008',g_lang)
                     LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,"num9",l_str,"")
              WHEN 10 LET l_str = g_aly[i-1].aly04 USING '<<<<',"-",g_aly[i].aly04 USING '<<<<',cl_getmsg('axr1007',g_lang)
                     LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,"num010",l_str,"")
                     LET l_str = g_aly[i-1].aly04 USING '<<<<',"-",g_aly[i].aly04 USING '<<<<',cl_getmsg('axr1008',g_lang)
                     LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,"num10",l_str,"")
              WHEN 11 LET l_str = g_aly[i-1].aly04 USING '<<<<',"-",g_aly[i].aly04 USING '<<<<',cl_getmsg('axr1007',g_lang)
                     LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,"num011",l_str,"")
                     LET l_str = g_aly[i-1].aly04 USING '<<<<',"-",g_aly[i].aly04 USING '<<<<',cl_getmsg('axr1008',g_lang)
                     LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,"num11",l_str,"")
              WHEN 12 LET l_str = g_aly[i-1].aly04 USING '<<<<',"-",g_aly[i].aly04 USING '<<<<',cl_getmsg('axr1007',g_lang)
                     LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,"num012",l_str,"")
                     LET l_str = g_aly[i-1].aly04 USING '<<<<',"-",g_aly[i].aly04 USING '<<<<',cl_getmsg('axr1008',g_lang)
                     LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,"num12",l_str,"")
              WHEN 13 LET l_str = g_aly[i-1].aly04 USING '<<<<',"-",g_aly[i].aly04 USING '<<<<',cl_getmsg('axr1007',g_lang)
                     LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,"num013",l_str,"")
                     LET l_str = g_aly[i-1].aly04 USING '<<<<',"-",g_aly[i].aly04 USING '<<<<',cl_getmsg('axr1008',g_lang)
                     LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,"num13",l_str,"")
              WHEN 14 LET l_str = g_aly[i-1].aly04 USING '<<<<',"-",g_aly[i].aly04 USING '<<<<',cl_getmsg('axr1007',g_lang)
                     LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,"num014",l_str,"")
                     LET l_str = g_aly[i-1].aly04 USING '<<<<',"-",g_aly[i].aly04 USING '<<<<',cl_getmsg('axr1008',g_lang)
                     LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,"num14",l_str,"")
              WHEN 15 LET l_str = g_aly[i-1].aly04 USING '<<<<',"-",g_aly[i].aly04 USING '<<<<',cl_getmsg('axr1007',g_lang)
                     LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,"num015",l_str,"")
                     LET l_str = g_aly[i-1].aly04 USING '<<<<',"-",g_aly[i].aly04 USING '<<<<',cl_getmsg('axr1008',g_lang)
                     LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,"num15",l_str,"")
              WHEN 16 LET l_str = g_aly[i-1].aly04 USING '<<<<',"-",g_aly[i].aly04 USING '<<<<',cl_getmsg('axr1007',g_lang)
                     LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,"num016",l_str,"")
                     LET l_str = g_aly[i-1].aly04 USING '<<<<',"-",g_aly[i].aly04 USING '<<<<',cl_getmsg('axr1008',g_lang)
                     LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,"num16",l_str,"")
           END CASE
        ELSE
           CASE i
              WHEN 1 LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"num01","N")
                     LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"num1","N")
              WHEN 2 LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"num02","N")
                     LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"num2","N")
              WHEN 3 LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"num03","N")
                     LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"num3","N")
              WHEN 4 LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"num04","N")
                     LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"num4","N")
              WHEN 5 LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"num05","N")
                     LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"num5","N")
              WHEN 6 LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"num06","N")
                     LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"num6","N")
              WHEN 7 LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"num07","N")
                     LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"num7","N")
              WHEN 8 LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"num08","N")
                     LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"num8","N")
              WHEN 9 LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"num09","N")
                     LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"num9","N")
              WHEN 10 LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"num010","N")
                      LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"num10","N")
              WHEN 11 LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"num011","N")
                      LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"num11","N")
              WHEN 12 LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"num012","N")
                      LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"num12","N")
              WHEN 13 LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"num013","N")
                      LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"num13","N")
              WHEN 14 LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"num014","N")
                      LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"num14","N")
              WHEN 15 LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"num015","N")
                      LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"num15","N")
              WHEN 16 LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"num016","N")
                      LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"num16","N")
           END CASE

        END IF
    END FOR
   #17是用來放超過日期區間的 (ex : >120天帳款日期), 額外處理
    #FUN-D40128--add--str--
    CASE
       WHEN g_aly[2].aly04=0 OR cl_null(g_aly[2].aly04)
          LET g_max_aly04=g_aly[1].aly04+1
       WHEN g_aly[3].aly04=0 OR cl_null(g_aly[3].aly04)
          LET g_max_aly04=g_aly[2].aly04+1
       WHEN g_aly[4].aly04=0 OR cl_null(g_aly[4].aly04)
          LET g_max_aly04=g_aly[3].aly04+1
       WHEN g_aly[5].aly04=0 OR cl_null(g_aly[5].aly04)
          LET g_max_aly04=g_aly[3].aly04+1
       WHEN g_aly[6].aly04=0 OR cl_null(g_aly[6].aly04)
          LET g_max_aly04=g_aly[5].aly04+1
       WHEN g_aly[7].aly04=0 OR cl_null(g_aly[7].aly04)
          LET g_max_aly04=g_aly[6].aly04+1
       WHEN g_aly[8].aly04=0 OR cl_null(g_aly[8].aly04)
          LET g_max_aly04=g_aly[7].aly04+1
       WHEN g_aly[9].aly04=0 OR cl_null(g_aly[9].aly04)
          LET g_max_aly04=g_aly[8].aly04+1
       WHEN g_aly[10].aly04=0 OR cl_null(g_aly[10].aly04)
          LET g_max_aly04=g_aly[9].aly04+1
       WHEN g_aly[11].aly04=0 OR cl_null(g_aly[11].aly04)
          LET g_max_aly04=g_aly[10].aly04+1
       WHEN g_aly[12].aly04=0 OR cl_null(g_aly[12].aly04)
          LET g_max_aly04=g_aly[11].aly04+1
       WHEN g_aly[13].aly04=0 OR cl_null(g_aly[13].aly04)
          LET g_max_aly04=g_aly[12].aly04+1
       WHEN g_aly[14].aly04=0 OR cl_null(g_aly[14].aly04)
          LET g_max_aly04=g_aly[13].aly04+1
       WHEN g_aly[15].aly04=0 OR cl_null(g_aly[15].aly04)
          LET g_max_aly04=g_aly[14].aly04+1
       WHEN g_aly[16].aly04=0 OR cl_null(g_aly[16].aly04)
          LET g_max_aly04=g_aly[15].aly04+1
       OTHERWISE
          LET g_max_aly04=g_aly[16].aly04+1
    END CASE
    #FUN-D40128--add--end
    LET l_str = ">=",g_max_aly04 USING '<<<<',cl_getmsg('axr1007',g_lang)
    LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,"num017",l_str,"")
    LET l_str =  ">=",g_max_aly04 USING '<<<<',cl_getmsg('axr1008',g_lang)
    LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,"num17",l_str,"")
   #No.FUN-CC0093 ---end  --- Add
    CALL cl_xg_view()    ###XtraGrid###
END FUNCTION 

#栏位输入管控
FUNCTION x191_chk_datas()
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      LET g_field = "apa22"
      RETURN FALSE  
   END IF
   IF tm.aly01 IS NULL THEN
      CALL cl_err('','aap1001',0)
      LET g_field = "aly01"
      RETURN FALSE
   END IF
   IF tm.edate IS NULL THEN
      CALL cl_err('','aap1000',0)
      LET g_field = "edate" 
      RETURN FALSE 
   END IF
   IF MONTH(tm.edate) = MONTH(tm.edate+1) THEN
      CALL cl_err('','aap-993',1)
      LET g_field = "edate" 
      RETURN FALSE
   END IF
   RETURN TRUE 
END FUNCTION 

FUNCTION x191_get_datas()
   DEFINE l_i      LIKE type_file.num5
   #根據賬齡類型抓取賬齡資料
   LET l_i = 1 
   LET g_sql = "SELECT * FROM aly_file WHERE aly01='",tm.aly01,"' ORDER BY aly02"
   PREPARE aly_prepare FROM g_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('aly_prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   CALL g_aly.clear()
   INITIALIZE g_aly[16].* TO NULL
   DECLARE aly_curs1 CURSOR FOR aly_prepare
   FOREACH aly_curs1 INTO g_aly[l_i].*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF g_aly[l_i].aly05 IS NULL THEN
         LET g_aly[l_i].aly05=100
      END IF 
      LET l_i = l_i+1
   END FOREACH  
END FUNCTION 
#FUN-B60071


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
