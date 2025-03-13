# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: axrr191.4gl
# Descriptions...: 廠商應付帳齡分析報表
# Date & Author..: #FUN-B60071 11/06/09  By  suncx
# Modify.........: No:FUN-B80072 11/08/08 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-BB0038 11/11/14 By elva 简称由单据抓取
# Modify.........: No.TQC-C30333 12/03/30 By zhangll 日期默認帶出月底日期
# Modify.........: No.TQC-C30349 12/04/06 By lujh 增加賬款性質和選項“按原幣打印”,若選項“按原幣打印”勾選時，畫面顯示幣別

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm  RECORD                         
          wc     LIKE type_file.chr1000,     # Where condition  
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
DEFINE   g_comb           ui.ComboBox    #TQC-C30349  add
         
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time
   
   LET g_sql = "oma03.oma_file.oma03,",  #客戶
               "oma032.oma_file.oma032,",
               "oma02.oma_file.oma02,",  #Date
               "oma01.oma_file.oma01,",
               "oma23.oma_file.oma23,",     #TQC-C30349  add
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
               "org.type_file.chr1"       #TQC-C30349  add

   LET l_table = cl_prt_temptable('axrr191',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生

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
      CALL r191_tm(0,0)
   ELSE
      CALL r191()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN 

FUNCTION r191_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   LET p_row = 6 LET p_col = 16

 
   OPEN WINDOW axrr191_w AT p_row,p_col WITH FORM "axr/42f/axrr191" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
       
   CALL cl_ui_init()
   CALL cl_opmsg('p')

   #--TQC-C30349--add--str--
   IF g_azw.azw04 <> '2' THEN   
      LET g_comb = ui.ComboBox.forName("oma00")
      CALL g_comb.removeItem('15')
      CALL g_comb.removeItem('16')   
      CALL g_comb.removeItem('17')
      CALL g_comb.removeItem('18')
      CALL g_comb.removeItem('19')   
      CALL g_comb.removeItem('26')
      CALL g_comb.removeItem('27')
      CALL g_comb.removeItem('28')   
   END IF
   #--TQC-C30349--add--end--
   
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
   DISPLAY tm.aly01,tm.a,tm.edate,tm.detail,tm.zr,tm.org,tm.more   #TQC-C30349   add  tm.org
        TO tm.aly01,tm.a,tm.edate,tm.detail,tm.zr,tm.org,tm.more   #TQC-C30349   add  tm.org 
   CALL r191_get_datas()
   WHILE TRUE 
      DIALOG ATTRIBUTE(UNBUFFERED)
         CONSTRUCT BY NAME tm.wc ON oma15,oma14,occ03,oma03,oma00   #TQC-C30349   add  oma00

            BEFORE CONSTRUCT
               CALL cl_qbe_init()
               
            ON ACTION CONTROLP
               CASE
                  WHEN INFIELD(oma15)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gem3"
                     LET g_qryparam.plant = g_plant 
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO oma15
                     NEXT FIELD oma15
 
                  WHEN INFIELD(oma14)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gen5"
                     LET g_qryparam.plant = g_plant 
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO oma14
                     NEXT FIELD oma14

                  WHEN INFIELD(occ03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_oca"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO occ03
                     NEXT FIELD occ03

                  WHEN INFIELD(oma03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_occ02"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO oma03
                     NEXT FIELD oma03
                     
               END CASE 
         END CONSTRUCT
         
         INPUT BY NAME tm.aly01,tm.a,tm.edate,tm.detail,tm.zr,tm.org,tm.more   #TQC-C30349   add  tm.org 
            ATTRIBUTES (WITHOUT DEFAULTS)
            BEFORE INPUT
               CALL cl_qbe_display_condition(lc_qbe_sn)
               
            AFTER FIELD aly01
               CALL r191_get_datas()  

            ON CHANGE aly01
               CALL r191_get_datas()
               
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
                     CALL r191_get_datas()
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
            IF NOT r191_chk_datas() THEN
               IF g_field = "edate" THEN
                  NEXT FIELD edate
               END IF
               IF g_field = "aly01" THEN
                  NEXT FIELD aly01 
               END IF
               IF g_field = "oma15" THEN
                  NEXT FIELD oma15
               END IF
               LET g_field = ''
            END IF  
      END DIALOG 
      
      IF INT_FLAG THEN 
         LET INT_FLAG = 0
         CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80072   ADD
         EXIT PROGRAM
      END IF 
      CALL cl_wait()
      CALL r191()
      ERROR ""
   END WHILE 
   CLOSE WINDOW axrr191_w
END FUNCTION

FUNCTION r191()
   DEFINE l_sql    STRING,
          l_alz09  LIKE alz_file.alz09,   #金额 
          l_alz09f LIKE alz_file.alz09f,  #金额  #TQC-C30349  add   
          l_alz06  LIKE alz_file.alz06,   #立账日期
          l_alz07  LIKE alz_file.alz07,   #付款日期
          l_date   LIKE type_file.dat,
          l_bucket LIKE type_file.num5
   DEFINE sr RECORD 
             oma03  LIKE oma_file.oma03,  #客戶
             oma032 LIKE oma_file.oma032, #簡稱
             oma02  LIKE oma_file.oma02,  #Date
             oma01  LIKE oma_file.oma01,
             oma23  LIKE oma_file.oma23,    #TQC-C30349  add                          
             num01  LIKE alz_file.alz09,
             num02  LIKE alz_file.alz09,
             num03  LIKE alz_file.alz09,
             num04  LIKE alz_file.alz09,
             num05  LIKE alz_file.alz09,
             num06  LIKE alz_file.alz09,
             num07  LIKE alz_file.alz09,
             num08  LIKE alz_file.alz09,
             num09  LIKE alz_file.alz09,
             num010 LIKE alz_file.alz09,
             num011 LIKE alz_file.alz09,
             num012 LIKE alz_file.alz09,
             num013 LIKE alz_file.alz09,
             num014 LIKE alz_file.alz09,
             num015 LIKE alz_file.alz09,
             num016 LIKE alz_file.alz09,
             num017 LIKE alz_file.alz09,
             num1   LIKE alz_file.alz09,
             num2   LIKE alz_file.alz09,
             num3   LIKE alz_file.alz09,
             num4   LIKE alz_file.alz09,
             num5   LIKE alz_file.alz09,
             num6   LIKE alz_file.alz09,
             num7   LIKE alz_file.alz09,
             num8   LIKE alz_file.alz09,
             num9   LIKE alz_file.alz09,
             num10  LIKE alz_file.alz09,
             num11  LIKE alz_file.alz09,
             num12  LIKE alz_file.alz09,
             num13  LIKE alz_file.alz09,
             num14  LIKE alz_file.alz09,
             num15  LIKE alz_file.alz09,
             num16  LIKE alz_file.alz09,
             num17  LIKE alz_file.alz09,
             org    LIKE type_file.chr1    #TQC-C30349  add
         END RECORD

   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('omauser', 'omagrup')
   IF g_bgjob='Y' THEN
      CALL r191_get_datas()
   END IF

   CALL cl_del_data(l_table)
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
               " VALUES(?, ?, ?, ?, ?,    ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?,    ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?,    ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?,  ",
               "        ?, ?, ?, ?, ?, ?)"    #TQC-C30349  add  ?,?                                                                                                        
   PREPARE insert_prep FROM g_sql                                                                                                  
   IF STATUS THEN                                                                                                                   
       CALL cl_err('insert_prep:',status,1)      
       CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80072   ADD                                                                                  
       EXIT PROGRAM                                                                                                                 
   END IF
    
   #抓報表列印資料
   #--TQC-C30349--add--str--
   IF tm.org = 'Y' THEN 
      LET l_sql = "SELECT oma03, oma032,oma02, oma01,oma23,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,",    
                  "       0,0,0,0,0,0,0,0,0,0, 0,0,0,0,null, ",   #TQC-C30349   add null
                  "       alz09f,alz06,alz07 ",										
                  "  FROM omc_file,oma_file,alz_file,occ_file ",
                  "  LEFT OUTER JOIN oca_file ON(occ_file.occ03=oca_file.oca01)",										
                  " WHERE ",tm.wc CLIPPED," AND oma03 = occ01 AND oma01 = omc01 ",
                  "   AND oma03 = alz01 AND alz00 = '2' AND alz02 = ",YEAR(tm.edate),
                  "   AND alz03 = ",MONTH(tm.edate)," AND alz04 = oma01 ",
                  "   AND alz05 = omc02"
      #選擇扣除折讓資料            
      IF tm.zr = 'Y' THEN LET l_sql=l_sql CLIPPED," AND alz09f>0" END IF										
      IF tm.a = '2' THEN LET l_sql=l_sql CLIPPED,"  AND alz07 < '",tm.edate ,"'"  END IF
      PREPARE r191_prepare_01 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('r191_prepare_01:',SQLCA.sqlcode,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      DECLARE r191_curs_01 CURSOR FOR r191_prepare_01
      FOREACH r191_curs_01 INTO sr.*,l_alz09f,l_alz06,l_alz07
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         LET sr.org = 'Y'   #TQC-C30349  add
         #判斷應付賬款基準日期
         IF tm.a = '2' THEN 
            LET l_date = l_alz07 
         ELSE 
            LET l_date = l_alz06 
         END IF
         LET l_bucket = tm.edate-l_date
         CASE WHEN l_bucket<=g_aly[1].aly04  LET sr.num01=l_alz09f  LET sr.num1=l_alz09f * g_aly[1].aly05/100
              WHEN l_bucket<=g_aly[2].aly04  LET sr.num02=l_alz09f  LET sr.num2=l_alz09f * g_aly[2].aly05/100
              WHEN l_bucket<=g_aly[3].aly04  LET sr.num03=l_alz09f  LET sr.num3=l_alz09f * g_aly[3].aly05/100
              WHEN l_bucket<=g_aly[4].aly04  LET sr.num04=l_alz09f  LET sr.num4=l_alz09f * g_aly[4].aly05/100
              WHEN l_bucket<=g_aly[5].aly04  LET sr.num05=l_alz09f  LET sr.num5=l_alz09f * g_aly[5].aly05/100
              WHEN l_bucket<=g_aly[6].aly04  LET sr.num06=l_alz09f  LET sr.num6=l_alz09f * g_aly[6].aly05/100
              WHEN l_bucket<=g_aly[7].aly04  LET sr.num07=l_alz09f  LET sr.num7=l_alz09f * g_aly[7].aly05/100
              WHEN l_bucket<=g_aly[8].aly04  LET sr.num08=l_alz09f  LET sr.num8=l_alz09f * g_aly[8].aly05/100
              WHEN l_bucket<=g_aly[9].aly04  LET sr.num09=l_alz09f  LET sr.num9=l_alz09f * g_aly[9].aly05/100
              WHEN l_bucket<=g_aly[10].aly04 LET sr.num010=l_alz09f LET sr.num10=l_alz09f * g_aly[10].aly05/100
              WHEN l_bucket<=g_aly[11].aly04 LET sr.num011=l_alz09f LET sr.num11=l_alz09f * g_aly[11].aly05/100
              WHEN l_bucket<=g_aly[12].aly04 LET sr.num012=l_alz09f LET sr.num12=l_alz09f * g_aly[12].aly05/100
              WHEN l_bucket<=g_aly[13].aly04 LET sr.num013=l_alz09f LET sr.num13=l_alz09f * g_aly[13].aly05/100
              WHEN l_bucket<=g_aly[14].aly04 LET sr.num014=l_alz09f LET sr.num14=l_alz09f * g_aly[14].aly05/100
              WHEN l_bucket<=g_aly[15].aly04 LET sr.num015=l_alz09f LET sr.num15=l_alz09f * g_aly[15].aly05/100
              WHEN l_bucket<=g_aly[16].aly04 LET sr.num016=l_alz09f LET sr.num16=l_alz09f * g_aly[16].aly05/100
              OTHERWISE            LET sr.num017=l_alz09f LET sr.num17=l_alz09f      
         END CASE
         EXECUTE insert_prep USING sr.*
      END FOREACH 
   ELSE
   #--TQC-C30349--add--end-- 
       #LET l_sql = "SELECT oma03, occ02,oma02, oma01,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,", #FUN-BB0038
      LET l_sql = "SELECT oma03, oma032,oma02, oma01,oma23,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,", #FUN-BB0038    #TQC-C30349  add  oma23
                  "       0,0,0,0,0,0,0,0,0,0, 0,0,0,0,null, ",    #TQC-C30349   add null
                  "       alz09,alz06,alz07 ",										
                  "  FROM omc_file,oma_file,alz_file,occ_file ",
                  "  LEFT OUTER JOIN oca_file ON(occ_file.occ03=oca_file.oca01)",										
                  " WHERE ",tm.wc CLIPPED," AND oma03 = occ01 AND oma01 = omc01 ",
                  "   AND oma03 = alz01 AND alz00 = '2' AND alz02 = ",YEAR(tm.edate),
                  "   AND alz03 = ",MONTH(tm.edate)," AND alz04 = oma01 ",
                  "   AND alz05 = omc02"
      #選擇扣除折讓資料            
      IF tm.zr = 'Y' THEN LET l_sql=l_sql CLIPPED," AND alz09>0" END IF										
      IF tm.a = '2' THEN LET l_sql=l_sql CLIPPED,"  AND alz07 < '",tm.edate ,"'"  END IF
      PREPARE r191_prepare FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('r191_prepare:',SQLCA.sqlcode,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      DECLARE r191_curs1 CURSOR FOR r191_prepare
      FOREACH r191_curs1 INTO sr.*,l_alz09,l_alz06,l_alz07
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         LET sr.org = 'N'   #TQC-C30349  add
         #判斷應付賬款基準日期
         IF tm.a = '2' THEN 
            LET l_date = l_alz07 
         ELSE 
            LET l_date = l_alz06 
         END IF
         LET l_bucket = tm.edate-l_date
         CASE WHEN l_bucket<=g_aly[1].aly04  LET sr.num01=l_alz09  LET sr.num1=l_alz09 * g_aly[1].aly05/100
              WHEN l_bucket<=g_aly[2].aly04  LET sr.num02=l_alz09  LET sr.num2=l_alz09 * g_aly[2].aly05/100
              WHEN l_bucket<=g_aly[3].aly04  LET sr.num03=l_alz09  LET sr.num3=l_alz09 * g_aly[3].aly05/100
              WHEN l_bucket<=g_aly[4].aly04  LET sr.num04=l_alz09  LET sr.num4=l_alz09 * g_aly[4].aly05/100
              WHEN l_bucket<=g_aly[5].aly04  LET sr.num05=l_alz09  LET sr.num5=l_alz09 * g_aly[5].aly05/100
              WHEN l_bucket<=g_aly[6].aly04  LET sr.num06=l_alz09  LET sr.num6=l_alz09 * g_aly[6].aly05/100
              WHEN l_bucket<=g_aly[7].aly04  LET sr.num07=l_alz09  LET sr.num7=l_alz09 * g_aly[7].aly05/100
              WHEN l_bucket<=g_aly[8].aly04  LET sr.num08=l_alz09  LET sr.num8=l_alz09 * g_aly[8].aly05/100
              WHEN l_bucket<=g_aly[9].aly04  LET sr.num09=l_alz09  LET sr.num9=l_alz09 * g_aly[9].aly05/100
              WHEN l_bucket<=g_aly[10].aly04 LET sr.num010=l_alz09 LET sr.num10=l_alz09 * g_aly[10].aly05/100
              WHEN l_bucket<=g_aly[11].aly04 LET sr.num011=l_alz09 LET sr.num11=l_alz09 * g_aly[11].aly05/100
              WHEN l_bucket<=g_aly[12].aly04 LET sr.num012=l_alz09 LET sr.num12=l_alz09 * g_aly[12].aly05/100
              WHEN l_bucket<=g_aly[13].aly04 LET sr.num013=l_alz09 LET sr.num13=l_alz09 * g_aly[13].aly05/100
              WHEN l_bucket<=g_aly[14].aly04 LET sr.num014=l_alz09 LET sr.num14=l_alz09 * g_aly[14].aly05/100
              WHEN l_bucket<=g_aly[15].aly04 LET sr.num015=l_alz09 LET sr.num15=l_alz09 * g_aly[15].aly05/100
              WHEN l_bucket<=g_aly[16].aly04 LET sr.num016=l_alz09 LET sr.num16=l_alz09 * g_aly[16].aly05/100
              OTHERWISE            LET sr.num017=l_alz09 LET sr.num17=l_alz09      
         END CASE
         EXECUTE insert_prep USING sr.*
      END FOREACH 
   #--TQC-C30349--add--str--    
   END IF
   #--TQC-C30349--add--end-- 
 
   INITIALIZE g_str TO NULL
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   #是否列印選擇條件   
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'oma15,oma14,oca01,oma03,oma23')  #TQC-C30349  add  oma23
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   LET g_str = g_str CLIPPED,";",
       g_aly[1].aly04,";",g_aly[2].aly04,";",g_aly[3].aly04,";",g_aly[4].aly04,";",
       g_aly[5].aly04,";",g_aly[6].aly04,";",g_aly[7].aly04,";",g_aly[8].aly04,";",
       g_aly[9].aly04,";",g_aly[10].aly04,";",g_aly[11].aly04,";",g_aly[12].aly04,";",
       g_aly[13].aly04,";",g_aly[14].aly04,";",g_aly[15].aly04,";",g_aly[16].aly04,";",
       tm.a,";",tm.edate,";",tm.detail
   CALL cl_prt_cs3('axrr191','axrr191',l_sql,g_str)
END FUNCTION 

#栏位输入管控
FUNCTION r191_chk_datas()
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      LET g_field = "oma15"
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

FUNCTION r191_get_datas()
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
   DECLARE aly_curs1 CURSOR FOR aly_prepare
   FOREACH aly_curs1 INTO g_aly[l_i].*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF g_aly[l_i].aly05 IS NULL THEN
         LET g_aly[l_i].aly05 = 100
      END IF 
      LET l_i = l_i+1
   END FOREACH       
END FUNCTION 
#FUN-B60071
