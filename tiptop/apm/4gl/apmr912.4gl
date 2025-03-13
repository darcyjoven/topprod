# Prog. Version..: '5.30.06-13.03.18(00010)'     #
#
# Pattern name...: apmr912.4gl
# Descriptions...: (采購）廠商對帳單
# Date & Author..: No.FUN-8A0076 08/10/17 by xiaofeizhu
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-970062 09/07/07 By sherry 含稅金額合計入庫金額和退貨金額直接加總不合理
# Modify.........: No.MOD-970140 09/07/16 By mike l_sql中應增加 AND rvuconf != 'X'
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A80030 10/07/29 By yinhy 畫面條件選項增加一個選項，列印廠商料號品名規格額外說明
# Modify.........: No:FUN-AA0081 10/10/29 By Smapmin 增加入庫量欄位
# Modify.........: No:CHI-AB0002 10/11/23 By Summer 增加"是否列印樣品"
# Modify.........: No:CHI-AC0007 10/12/09 By Summer 沒有收貨單的倉退資料也要一併印出
# Modify.........: No:MOD-AB0213 10/12/10 By Smapmin 若單用rvv23做為是否請款的條件,無法判斷到只折讓金額的部份.
#                                                    故改用是否存在帳款資料來做判斷.
# Modify.........: No:MOD-AC0112 10/12/21 By Smapmin 若已暫估入庫款但未沖暫估的話，報表會認定為已請款，故需排除
# Modify.........: No:MOD-B80047 11/08/03 By suncx 應只取已審核入庫的資料，未審核的資料需要過濾掉
# Modify.........: No.FUN-BA0053 11/10/31 By Sakura 加入取jit收貨資料 
# Modify.........: No.FUN-C30285 12/03/27 By bart 增加批號作業編號for ICD
# Modify.........: No.MOD-D30012 13/03/07 By Elise OUTER JOIN gec_file時增加條件
# Modify.........: No.MOD-D20167 13/03/08 By Elise 無收貨單之倉退單未帶出廠商、地址、付款條件、稅別、幣別未帶出問題
# Modify.........: No.MOD-D20153 13/03/08 By Elise sr.pmc091 報表顯示為地址，但在 4gl 抓取欄位 pmc901 的值
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm         RECORD
                     wc      STRING,                  
                     s       LIKE type_file.chr3,    
                     endday  DATE,               
                     c       LIKE type_file.chr1,     #No.FUN-A80030 VARCHAR(1)   
                     d       LIKE type_file.chr1,  
                     a       LIKE type_file.chr1, #CHI-AB0002 add 
                     more    LIKE type_file.chr1  
                  END RECORD
DEFINE g_i        LIKE type_file.num5          #count/index for any purpose 
DEFINE #l_sql      LIKE type_file.chr1000 
       l_sql        STRING       #NO.FUN-910082      
DEFINE i          LIKE type_file.num10         
DEFINE l_table        STRING,  
       l_table1       STRING,    #No.FUN-A80030
       g_str          STRING, 
       g_sql          STRING 
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
 
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.s     = ARG_VAL(8)
   LET tm.endday= ARG_VAL(9)
   LET tm.c = ARG_VAL(10)
   LET tm.d = ARG_VAL(11)        #No.FUN-A80030
   LET tm.a = ARG_VAL(12) #CHI-AB0002 add
   #CHI-AB0002 mod +1 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   #CHI-AB0002 mod +1 --end--
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   #FUN-C30285---begin
   IF s_industry("icd") THEN
      LET g_sql = "rva05.rva_file.rva05,",
                  "pmc03.pmc_file.pmc03,",
                  "pmc091.pmc_file.pmc091,",
                  "endday.rva_file.rva06,",
                  "pmm20.pmm_file.pmm20,",
                  "pma02.pma_file.pma02,",
                  "pmm21.pmm_file.pmm21,",
                  "gec02.gec_file.gec02,",
                  "pmm22.pmm_file.pmm22,",
                  "rva06.rva_file.rva06,",
                  "rvv04.rvv_file.rvv04,",
                  "rvv01.rvv_file.rvv01,",
                  "rvb22.rvb_file.rvb22,",
                  "rvv36.rvv_file.rvv36,",
                  "rvv31.rvv_file.rvv31,",
                  "ima021.ima_file.ima021,",	
                  "rvv031.rvv_file.rvv031,",
                  "rvb07.rvb_file.rvb07,",
                  "rvv17.rvv_file.rvv17,",   #FUN-AA0081
                  "rvb80.rvb_file.rvb80,",
                  "rvv23.rvv_file.rvv23,",
                  "rvv38.rvv_file.rvv38,",
                  "rvv38t.rvv_file.rvv38t,",	
                  "rvv39.rvv_file.rvv39,",		
                  "rvv39t.rvv_file.rvv39t,",	
                  "amt.rvv_file.rvv38,",
                  "rvw06f.rvw_file.rvw06f,",
                  "tax.rvw_file.rvw06f,",
                  "azi03.azi_file.azi03,",
                  "azi04.azi_file.azi04,",
                  "azi05.azi_file.azi05,",
                  "rvv02.rvv_file.rvv02,",     #No.FUN-A80030
                  "l_count.type_file.num5,",   #No.FUN-A80030
                  "rvv34.rvv_file.rvv34,",         #FUN-C30285
                  "rvviicd01.rvvi_file.rvviicd01"  #FUN-C30285
   ELSE 
   #FUN-C30285---end
      LET g_sql = "rva05.rva_file.rva05,",
                  "pmc03.pmc_file.pmc03,",
                  "pmc091.pmc_file.pmc091,",
                  "endday.rva_file.rva06,",
                  "pmm20.pmm_file.pmm20,",
                  "pma02.pma_file.pma02,",
                  "pmm21.pmm_file.pmm21,",
                  "gec02.gec_file.gec02,",
                  "pmm22.pmm_file.pmm22,",
                  "rva06.rva_file.rva06,",
                  "rvv04.rvv_file.rvv04,",
                  "rvv01.rvv_file.rvv01,",
                  "rvb22.rvb_file.rvb22,",
                  "rvv36.rvv_file.rvv36,",
                  "rvv31.rvv_file.rvv31,",
                  "ima021.ima_file.ima021,",	
                  "rvv031.rvv_file.rvv031,",
                  "rvb07.rvb_file.rvb07,",
                  "rvv17.rvv_file.rvv17,",   #FUN-AA0081
                  "rvb80.rvb_file.rvb80,",
                  "rvv23.rvv_file.rvv23,",
                  "rvv38.rvv_file.rvv38,",
                  "rvv38t.rvv_file.rvv38t,",	
                  "rvv39.rvv_file.rvv39,",		
                  "rvv39t.rvv_file.rvv39t,",	
                  "amt.rvv_file.rvv38,",
                  "rvw06f.rvw_file.rvw06f,",
                  "tax.rvw_file.rvw06f,",
                  "azi03.azi_file.azi03,",
                  "azi04.azi_file.azi04,",
                  "azi05.azi_file.azi05,",
                  "rvv02.rvv_file.rvv02,",     #No.FUN-A80030
                  "l_count.type_file.num5"   #No.FUN-A80030
   END IF        #FUN-C30285
   LET l_table = cl_prt_temptable('apmr912',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   
   #No.FUN-A80030  --start
   LET g_sql= "pmq01.pmq_file.pmq01,",
              "pmq02.pmq_file.pmq02,",
              "pmq03.pmq_file.pmq03,",
              "pmq04.pmq_file.pmq04,",
              "pmq05.pmq_file.pmq05," , 
              "rvv01.rvv_file.rvv01,",
              "rvv02.rvv_file.rvv02" 
   LET l_table1 = cl_prt_temptable('apmr9121',g_sql) CLIPPED
   IF  l_table1 = -1 THEN EXIT PROGRAM END IF
   #No.FUN-A80030  --end         
   IF NOT cl_null(tm.wc) THEN
      CALL r912()
   ELSE
      CALL r912_tm(0,0)
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION r912_tm(p_row,p_col)
DEFINE p_row,p_col    LIKE type_file.num5          
DEFINE l_cmd          LIKE type_file.chr1000       
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
 
   LET p_row = 3 LET p_col = 11
   OPEN WINDOW r912_w AT p_row,p_col WITH FORM "apm/42f/apmr912"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
 
   INITIALIZE tm.* TO NULL
   LET tm2.s1  = '3'
   LET tm2.s2  = '1'
   LET tm2.s3  = '6'
   LET tm.c = 'N'          #No.FUN-A80030
   LET tm.d = '1'
   LET tm.a = 'N'  #CHI-AB0002 add
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON rva01,rva05,rva06,rvb04,
                                 rvb05,rvv01,rvb22 #CHI-AC0007 mod rvw01->rvb22 
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()  
            EXIT CONSTRUCT
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(rva01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rva"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rva01
                 NEXT FIELD rva01
 
               WHEN INFIELD(rva05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pmc4"
                 LET g_qryparam.arg1 = "1"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rva05
                 NEXT FIELD rva05
 
               WHEN INFIELD(rvb04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pmm"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rvb04
                 NEXT FIELD rvb04
 
               WHEN INFIELD(rvb05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ima01"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rvb05
                 NEXT FIELD rvb05
 
               WHEN INFIELD(rvv01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rvu4"
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.where = " rvu00 !='2'" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rvv01
                 NEXT FIELD rvv01
 
               WHEN INFIELD(rvb22) #CHI-AC0007 mod rvw01->rvb22
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rvb2" #CHI-AC0007 mod q_qvw->q_rvb2
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rvb22 #CHI-AC0007 mod rvw01->rvb22
                 NEXT FIELD rvb22 #CHI-AC0007 mod rvw01->rvb22
 
            END CASE
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about         
            CALL cl_about()      
 
         ON ACTION help          
            CALL cl_show_help()  
 
         ON ACTION controlg      
            CALL cl_cmdask()     
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
      END CONSTRUCT
 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r912_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,
                    tm.endday,tm.c,tm.d,tm.a,tm.more   #No.FUN-A80030 add tm.c #CHI-AB0002 add tm.a
            WITHOUT DEFAULTS
 
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-A80030 --start 
         AFTER FIELD c
           IF tm.c NOT MATCHES "[YN]" OR tm.c IS NULL
              THEN NEXT FIELD c
           END IF
         #No.FUN-A80030 --end
         #CHI-AB0002 add --start--
         AFTER FIELD a 
            IF tm.a NOT MATCHES "[YN]" OR tm.a=' ' THEN
               NEXT FIELD a
            END IF
         #CHI-AB0002 add --end--
         AFTER FIELD more 
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         AFTER INPUT
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about        
            CALL cl_about()    
 
         ON ACTION help        
            CALL cl_show_help()
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r912_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='apmr912'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('apmr912','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_lang CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.s CLIPPED,"'",
                        " '",tm.endday CLIPPED,"'",
                        " '",tm.c CLIPPED,"'",         #No.FUN-A80030
                        " '",tm.d CLIPPED,"'",
                        " '",tm.a CLIPPED,"'",  #CHI-AB0002 add
                        " '",g_rep_user CLIPPED,"'",  
                        " '",g_rep_clas CLIPPED,"'", 
                        " '",g_template CLIPPED,"'" 
            CALL cl_cmdat('apmr912',g_time,l_cmd)
         END IF
 
         CLOSE WINDOW r912_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
 
      CALL r912()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r912_w
 
END FUNCTION
 
FUNCTION r912()
DEFINE l_name    LIKE type_file.chr20           # External(Disk) file name
DEFINE #l_sql     LIKE type_file.chr1000         # SQL STATEMENT 
       l_sql        STRING       #NO.FUN-910082   
DEFINE l_num     DEC(20,6)
DEFINE l_gec04   LIKE gec_file.gec04
DEFINE l_gec07   LIKE gec_file.gec07
DEFINE l_count   LIKE type_file.num5            #No.FUN-A80030
DEFINE l_cnt     LIKE type_file.num5   #MOD-AB0213
DEFINE sr        RECORD
                 rvu00          LIKE rvu_file.rvu00,  #TQC-970062 add
                 rva05          LIKE rva_file.rva05,
                 pmc03          LIKE pmc_file.pmc03,
                 pmc091         LIKE pmc_file.pmc091,
                 endday         DATE,
                 pmm20          LIKE pmm_file.pmm20,
                 pma02          LIKE pma_file.pma02,
                 pmm21          LIKE pmm_file.pmm21,
                 gec02          LIKE gec_file.gec02,
                 pmm22          LIKE pmm_file.pmm22,
                 rva06          LIKE rva_file.rva06,
                 rvv04          LIKE rvv_file.rvv04,
                 rvv01          LIKE rvv_file.rvv01,
                 rvb22          LIKE rvb_file.rvb22,
                 rvv36          LIKE rvv_file.rvv36,
                 rvv31          LIKE rvv_file.rvv31,
                 ima021         LIKE ima_file.ima021,	
                 rvv031         LIKE rvv_file.rvv031,
                 rvb07          LIKE rvb_file.rvb07,
                 rvv17          LIKE rvv_file.rvv17,   #FUN-AA0081
                 rvb80          LIKE rvb_file.rvb80,
                 rvv23          LIKE rvv_file.rvv23,
                 rvv38          LIKE rvv_file.rvv38, 
                 rvv38t         LIKE rvv_file.rvv38t, 	
                 rvv39          LIKE rvv_file.rvv39, 	
                 rvv39t         LIKE rvv_file.rvv39t, 	
                 amt            LIKE rvv_file.rvv38,
                 rvw06f         LIKE rvw_file.rvw06f,
                 tax            LIKE rvw_file.rvw06f,
                 rvv02          LIKE rvv_file.rvv02     #FUN-A80030 add
                 END RECORD,
        #No.FUN-A80030  --start
         sr1     RECORD
                 pmq01          LIKE pmq_file.pmq01,
                 pmq02          LIKE pmq_file.pmq02,
                 pmq03          LIKE pmq_file.pmq03,
                 pmq04          LIKE pmq_file.pmq04,
                 pmq05          LIKE pmq_file.pmq05
                 END RECORD
         #No.FUN-A80030  --end
DEFINE l_flag    LIKE type_file.chr1 #CHI-AC0007 add
DEFINE l_tm_wc   STRING         #CHI-AC0007 add
DEFINE l_rvv34     LIKE rvv_file.rvv34       #FUN-C30285
DEFINE l_rvviicd01 LIKE rvvi_file.rvviicd01  #FUN-C30285

   CALL cl_del_data(l_table) 
   CALL cl_del_data(l_table1) 
   #FUN-C30285---begin
   IF s_industry("icd") THEN
      LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
                  " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
                  "        ?,?,?,?,?, ?,?,?,?,?, ",
                  "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?) "		 #No.FUN-A80030 加两個?   #FUN-AA0081 add ? #FUN-C30285 add 2?
   ELSE 
   #FUN-C30285---end
      LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
                  " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
                  "        ?,?,?,?,?, ?,?,?,?,?, ",
                  "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?) "	     #No.FUN-A80030 加两個?   #FUN-AA0081 add ?
   END IF #FUN-C30285
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM                                                                             
   END IF    
   #No.FUN-A80030   --start 
   LET g_sql ="INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,  
              " VALUES(?,?,?,?,?,?,?)"        
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep1:",STATUS,1)
   END IF
   #No.FUN-A80030   --end   
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   
   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN             
   #      LET tm.wc = tm.wc clipped," AND rvauser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN            
   #      LET tm.wc = tm.wc clipped," AND rvagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    
   #      LET tm.wc = tm.wc clipped," AND rvagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('rvauser', 'rvagrup')
   #End:FUN-980030
   
   #No.FUN-BA0053---Begin---mark                     
   ##LET l_sql = "SELECT rva05,pmc03,pmc901,'',pmm20,pma02,pmm21,gec02,pmm22, ",   #TQC-970062 mark
   #LET l_sql = "SELECT rvu00,rva05,pmc03,pmc901,'',pmm20,pma02,pmm21,gec02,pmm22, ",#TQC-970062 add rvu00
   #            "       rva06,rvv04,rvv01,rvb22,rvv36,rvv31,ima021,rvv031,rvb07,rvv17, ",   #FUN-AA0081 add rvv17
   #            #"       rvv35,rvv23,rvv38,rvv38t,rvv39,rvv39t,0,rvw06f,0,0,0,0 ",	#CHI-AC0007  
   #            #"       rvv35,rvv23,rvv38,rvv38t,rvv39,rvv39t,0,0,0,0,'N' ",	#CHI-AC0007   #MOD-AB0213
   #            "       rvv35,rvv23,rvv38,rvv38t,rvv39,rvv39t,0,0,0,rvv02,'N' ",	#MOD-AB0213
   #            "  FROM rva_file, rvb_file ,rvv_file, rvu_file, pmm_file, ",
   #           #"       OUTER rvw_file, OUTER pmc_file, ", #CHI-AC0007 mark
   #           "       OUTER pmc_file, ",                 #CHI-AC0007 mod
   #            "       OUTER pma_file, OUTER gec_file, OUTER ima_file ",	
   #           #CHI-AC0007 mod --start--
   #           #" WHERE rvv_file.rvv04 = rvw_file.rvw08 ",
   #           #"   AND rvb01 = rvv04 ",		
   #            " WHERE rvb01 = rvv04 ",		
   #           #CHI-AC0007 mod --end--
   #            "   AND rvb02 = rvv05 ",
   #            "   AND rva01 = rvb01 ",
   #           "   AND rvv36 = pmm01 ",
   #            "   AND rvv_file.rvv31 = ima_file.ima01 ",			
   #            "   AND rvv01 = rvu01 ",
   #            "   AND rva_file.rva05 = pmc_file.pmc01 ",
   #            "   AND pmm_file.pmm20 = pma_file.pma01 ",
   #            "   AND pmm_file.pmm21 = gec_file.gec01 ",
   #            "   AND rvu00 != '2' ",
   #           #"   AND rvuconf != 'X' ", #MOD-970140   #MOD-B80047 mark 
   #            "   AND rvuconf = 'Y' ",   #MOD-B80047 add
   #            "   AND rvu03 <= '",tm.endday, "'",
   #            "   AND ", tm.wc CLIPPED
   #No.FUN-BA0053---End-----mark

   #FUN-C30285----begin
   IF s_industry("icd") THEN
     #LET l_sql = "SELECT rvu00,rva05,pmc03,pmc901,'',pmm20,pma02,pmm21,gec02,pmm22, ", #MOD-D20153 mark
      LET l_sql = "SELECT rvu00,rva05,pmc03,pmc091,'',pmm20,pma02,pmm21,gec02,pmm22, ", #MOD-D20153 add
                  "       rva06,rvv04,rvv01,rvb22,rvv36,rvv31,ima021,rvv031,rvb07,rvv17, ",
                  "       rvv35,rvv23,rvv38,rvv38t,rvv39,rvv39t,0,0,0,rvv02,'N',rvv34,rvviicd01 ",  #FUN-C30285
                  "  FROM rva_file ", 
                  "  INNER JOIN rvb_file ON rva_file.rva01 = rvb_file.rvb01",
                  "  INNER JOIN rvv_file ON rvb_file.rvb01 = rvv_file.rvv04",
                  "  AND rvb_file.rvb02 = rvv_file.rvv05",
                  "  INNER JOIN rvu_file ON rvv_file.rvv01 = rvu_file.rvu01", 
                  "  INNER JOIN pmm_file ON rvv_file.rvv36 = pmm_file.pmm01",
                  "  INNER JOIN rvvi_file ON (rvv_file.rvv01 = rvvi_file.rvvi01 AND rvv_file.rvv02 = rvvi_file.rvvi02)", #FUN-C30285
                  "  LEFT OUTER JOIN pmc_file ON rva_file.rva05 = pmc_file.pmc01",
                  "  LEFT OUTER JOIN pma_file ON pmm_file.pmm20 = pma_file.pma01",
                  "  LEFT OUTER JOIN gec_file ON pmm_file.pmm21 = gec_file.gec01",
                  "                           AND gec_file.gec011='1'",  #進項 #MOD-D30012 add
                  "  LEFT OUTER JOIN ima_file ON rvv_file.rvv31 = ima_file.ima01",	
                  " WHERE rvu00 != '2' ",
                  "   AND rvuconf = 'Y' ",
                  "   AND rvu03 <= '",tm.endday, "'",
                  "   AND rva00 ='1' ",
                  "   AND ", tm.wc CLIPPED   
   ELSE 
   #FUN-C30285----end
   #No.FUN-BA0053---Begin---add
     #LET l_sql = "SELECT rvu00,rva05,pmc03,pmc901,'',pmm20,pma02,pmm21,gec02,pmm22, ", #MOD-D20153 mark
      LET l_sql = "SELECT rvu00,rva05,pmc03,pmc091,'',pmm20,pma02,pmm21,gec02,pmm22, ", #MOD-D20153 add
                  "       rva06,rvv04,rvv01,rvb22,rvv36,rvv31,ima021,rvv031,rvb07,rvv17, ",
                  "       rvv35,rvv23,rvv38,rvv38t,rvv39,rvv39t,0,0,0,rvv02,'N','','' ",  #FUN-C30285 add ,'',''
                  "  FROM rva_file ", 
                  "  INNER JOIN rvb_file ON rva_file.rva01 = rvb_file.rvb01",
                  "  INNER JOIN rvv_file ON rvb_file.rvb01 = rvv_file.rvv04",
                  "  AND rvb_file.rvb02 = rvv_file.rvv05",
                  "  INNER JOIN rvu_file ON rvv_file.rvv01 = rvu_file.rvu01", 
                  "  INNER JOIN pmm_file ON rvv_file.rvv36 = pmm_file.pmm01",
                  "  LEFT OUTER JOIN pmc_file ON rva_file.rva05 = pmc_file.pmc01",
                  "  LEFT OUTER JOIN pma_file ON pmm_file.pmm20 = pma_file.pma01",
                  "  LEFT OUTER JOIN gec_file ON pmm_file.pmm21 = gec_file.gec01",
                  "                           AND gec_file.gec011='1'",  #進項 #MOD-D30012 add
                  "  LEFT OUTER JOIN ima_file ON rvv_file.rvv31 = ima_file.ima01",	
                  " WHERE rvu00 != '2' ",
                  "   AND rvuconf = 'Y' ",
                  "   AND rvu03 <= '",tm.endday, "'",
                  "   AND rva00 ='1' ",
                  "   AND ", tm.wc CLIPPED   
   #No.FUN-BA0053---End-----add   
   END IF #FUN-C30285
   #-----MOD-AB0213---------
   #IF tm.d='2' THEN
   #   LET l_sql=l_sql CLIPPED, " AND rvv23 > 0 "
   #END IF
   #IF tm.d='3' THEN
   #   LET l_sql=l_sql CLIPPED, " AND rvv23 = 0 "
   #END IF
   #-----END MOD-AB0213-----
   #CHI-AB0002 add --start--
   IF tm.a='N' THEN
      LET l_sql=l_sql CLIPPED, " AND rvv25 = 'N' "
   END IF
   #CHI-AB0002 add --end--
   #FUN-C30285----begin
   IF s_industry("icd") THEN
      LET l_sql = l_sql,
                 #"UNION SELECT rvu00,rva05,pmc03,pmc901,'',rvu111,pma02,rvu115,gec02,rvu113, ", #MOD-D20153 mark
                  "UNION SELECT rvu00,rva05,pmc03,pmc091,'',rvu111,pma02,rvu115,gec02,rvu113, ", #MOD-D20153 add
                  "       rva06,rvv04,rvv01,rvb22,rvv36,rvv31,ima021,rvv031,rvb07,rvv17, ",
                  "       rvv35,rvv23,rvv38,rvv38t,rvv39,rvv39t,0,0,0,rvv02,'N',rvv34,rvviicd01 ",  #FUN-C30285
                  "  FROM rva_file ", 
                  "  INNER JOIN rvb_file ON rva_file.rva01 = rvb_file.rvb01",
                  "  INNER JOIN rvv_file ON rvb_file.rvb01 = rvv_file.rvv04",
                  "  AND rvb_file.rvb02 = rvv_file.rvv05", 
                  "  INNER JOIN rvu_file ON rvv_file.rvv01 = rvu_file.rvu01 ",
                  "  INNER JOIN rvvi_file ON (rvv_file.rvv01 = rvvi_file.rvvi01 AND rvv_file.rvv02 = rvvi_file.rvvi02)", #FUN-C30285
                  "  LEFT OUTER JOIN pmc_file ON rva_file.rva05 = pmc_file.pmc01",  
                  "  LEFT OUTER JOIN pma_file ON rvu_file.rvu111 = pma_file.pma01",
                  "  LEFT OUTER JOIN gec_file ON rvu_file.rvu115 = gec_file.gec01", 
                  "                           AND gec_file.gec011='1'",  #進項 #MOD-D30012 add
                  "  LEFT OUTER JOIN ima_file ON rvv_file.rvv31 = ima_file.ima01",
                  " WHERE rvu00 != '2' ",
                  "   AND rvuconf = 'Y' ",
                  "   AND rvu03 <= '",tm.endday, "'",
                  "   AND rva00='2'",
                  "   AND ", tm.wc CLIPPED
   ELSE 
   #FUN-C30285----end
   #No.FUN-BA0053---Begin---add
      LET l_sql = l_sql,
                 #"UNION SELECT rvu00,rva05,pmc03,pmc901,'',rvu111,pma02,rvu115,gec02,rvu113, ", #MOD-D20153 mark
                  "UNION SELECT rvu00,rva05,pmc03,pmc091,'',rvu111,pma02,rvu115,gec02,rvu113, ", #MOD-D20153 add
                  "       rva06,rvv04,rvv01,rvb22,rvv36,rvv31,ima021,rvv031,rvb07,rvv17, ",
                  "       rvv35,rvv23,rvv38,rvv38t,rvv39,rvv39t,0,0,0,rvv02,'N','','' ",  #FUN-C30285 add ,'',''
                  "  FROM rva_file ", 
                  "  INNER JOIN rvb_file ON rva_file.rva01 = rvb_file.rvb01",
                  "  INNER JOIN rvv_file ON rvb_file.rvb01 = rvv_file.rvv04",
                  "  AND rvb_file.rvb02 = rvv_file.rvv05", 
                  "  INNER JOIN rvu_file ON rvv_file.rvv01 = rvu_file.rvu01 ",
                  "  LEFT OUTER JOIN pmc_file ON rva_file.rva05 = pmc_file.pmc01",  
                  "  LEFT OUTER JOIN pma_file ON rvu_file.rvu111 = pma_file.pma01",
                  "  LEFT OUTER JOIN gec_file ON rvu_file.rvu115 = gec_file.gec01", 
                  "                           AND gec_file.gec011='1'",  #進項 #MOD-D30012 add
                  "  LEFT OUTER JOIN ima_file ON rvv_file.rvv31 = ima_file.ima01",
                  " WHERE rvu00 != '2' ",
                  "   AND rvuconf = 'Y' ",
                  "   AND rvu03 <= '",tm.endday, "'",
                  "   AND rva00='2'",
                  "   AND ", tm.wc CLIPPED
   END IF     #FUN-C30285 
   IF tm.a='N' THEN
      LET l_sql=l_sql CLIPPED, " AND rvv25 = 'N' "
   END IF   
   #No.FUN-BA0053---End-----add
   
   #CHI-AC0007 add --start--
   LET l_cnt = 0
   LET l_cnt = tm.wc.getIndexOf('rva01','1') 
   IF l_cnt = 0 THEN LET l_cnt = tm.wc.getIndexOf('rva06','1') END IF
   IF l_cnt = 0 THEN LET l_cnt = tm.wc.getIndexOf('rvb04','1') END IF
   IF l_cnt = 0 THEN LET l_cnt = tm.wc.getIndexOf('rvb22','1') END IF
   IF l_cnt = 0 THEN
      CALL cl_replace_str(tm.wc,"rva05","rvu04") RETURNING l_tm_wc
      CALL cl_replace_str(l_tm_wc,"rvb05","rvv31") RETURNING l_tm_wc
      #FUN-C30285---begin
      IF s_industry("icd") THEN
         LET l_sql = l_sql, " UNION ",
                    #"SELECT rvu00,'','','','','','','','','', ",  #MOD-D20167 mark
                     "SELECT rvu00,rvu04,pmc03,pmc091,'',rvu111,pma02,rvu115,gec02,rvu113, ", #MOD-D20167 add
                     "       rvv09,rvv04,rvv01,'',rvv36,rvv31,'',rvv031,0,rvv17, ", 
                     "       rvv35,rvv23,rvv38,rvv38t,rvv39,rvv39t,0,0,0,rvv02,'Y',rvv34,rvviicd01 ",   #MOD-AB0213  #FUN-C30285
                     "  FROM rvv_file, rvu_file, rvvi_file ",
                    #MOD-D20167 add start -----
                     "  LEFT OUTER JOIN pmc_file ON rvu_file.rvu04 = pmc_file.pmc01 ",
                     "  LEFT OUTER JOIN pma_file ON rvu_file.rvu111= pma_file.pma01",
                     "  LEFT OUTER JOIN gec_file ON rvu_file.rvu115= gec_file.gec01",
                     "                           AND gec_file.gec011='1'",  #進項 #MOD-D30012 add
                    #MOD-D20167 add end   -----
                     " WHERE rvv01 = rvu01 ",
                     "   AND rvv_file.rvv01 = rvvi_file.rvvi01 AND rvv_file.rvv02 = rvvi_file.rvvi02 ",
                     "   AND rvu00 != '2' ",
                     "   AND rvuconf = 'Y' ",
                     "   AND rvu03 <= '",tm.endday, "'",
                     "   AND ( rvu02 = '' OR rvu02 is null ", 
                     "    OR rvv04 = '' OR rvv04 is null )", 
                     "   AND ", l_tm_wc CLIPPED
      ELSE 
      #FUN-C30285---end 
         LET l_sql = l_sql, " UNION ",
                    #"SELECT rvu00,'','','','','','','','','', ",  #MOD-D20167 mark
                     "SELECT rvu00,rvu04,pmc03,pmc091,'',rvu111,pma02,rvu115,gec02,rvu113, ", #MOD-D20167 add
                     "       rvv09,rvv04,rvv01,'',rvv36,rvv31,'',rvv031,0,rvv17, ", 
                     #"       rvv35,rvv23,rvv38,rvv38t,rvv39,rvv39t,0,0,0,0,'Y' ",   #MOD-AB0213
                     "       rvv35,rvv23,rvv38,rvv38t,rvv39,rvv39t,0,0,0,rvv02,'Y','','' ",   #MOD-AB0213  #FUN-C30285 add ,'',''
                     "  FROM rvv_file, rvu_file ",
                    #MOD-D20167 add start -----
                     "  LEFT OUTER JOIN pmc_file ON rvu_file.rvu04 = pmc_file.pmc01 ",
                     "  LEFT OUTER JOIN pma_file ON rvu_file.rvu111= pma_file.pma01",
                     "  LEFT OUTER JOIN gec_file ON rvu_file.rvu115= gec_file.gec01",
                     "                           AND gec_file.gec011='1'",  #進項 #MOD-D30012 add
                    #MOD-D20167 add end   -----
                     " WHERE rvv01 = rvu01 ",
                     "   AND rvu00 != '2' ",
                     #"   AND rvuconf != 'X' ",  #MOD-B80047 mark
                     "   AND rvuconf = 'Y' ",   #MOD-B80047 add
                     "   AND rvu03 <= '",tm.endday, "'",
                     "   AND ( rvu02 = '' OR rvu02 is null ", 
                     "    OR rvv04 = '' OR rvv04 is null )", 
                     "   AND ", l_tm_wc CLIPPED
      #-----MOD-AB0213---------
      END IF   #FUN-C30285
      #IF tm.d='2' THEN
      #   LET l_sql=l_sql CLIPPED, " AND rvv23 > 0 "
      #END IF
      #IF tm.d='3' THEN
      #   LET l_sql=l_sql CLIPPED, " AND rvv23 = 0 "
      #END IF
      #-----END MOD-AB0213----- 
      IF tm.a='N' THEN
         LET l_sql=l_sql CLIPPED, " AND rvv25 = 'N' "
      END IF
   END IF
   #CHI-AC0007 add --end--
 
   PREPARE r912_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   DECLARE r912_curs1 CURSOR FOR r912_prepare1
   #FUN-C30285---begin
   IF s_industry("icd") THEN  
      LET l_name='apmr912_1' 
   ELSE 
   #FUN-C30285---end 
      LET l_name='apmr912'
   END IF   #FUN-C30285

   FOREACH r912_curs1 INTO sr.*,l_flag,l_rvv34,l_rvviicd01   #CHI-AC0007 add l_flag #FUN-C30285 add l_rvv34,l_rvviicd01
 
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      #-----MOD-AB0213---------
      IF tm.d = '2' OR tm.d = '3' THEN
         LET l_cnt = 0 
         SELECT COUNT(*) INTO l_cnt FROM apa_file,apb_file
          WHERE apa01 = apb01 
            AND apa42 = 'N'
            AND (apa00 = '11' OR apa00 = '21')  #MOD-AC0112
            AND apb21 = sr.rvv01
            AND apb22 = sr.rvv02
         IF tm.d = '2' AND l_cnt = 0 THEN
            CONTINUE FOREACH
         END IF 
         IF tm.d = '3' AND l_cnt > 0 THEN
            CONTINUE FOREACH
         END IF 
      END IF
      #-----END MOD-AB0213-----

      #CHI-AC0007 add --start--
      IF l_flag = 'Y' THEN
         LET sr.rva06 = ''
      END IF

      SELECT rvw06f INTO sr.rvw06f
        FROM rvw_file
       WHERE rvw01 = sr.rvb22
      #CHI-AC0007 add --end--
 
      IF cl_null(sr.rvb22) THEN
         LET l_gec04 = NULL
         LET l_gec07 = NULL
         SELECT gec04,gec07 INTO l_gec04,l_gec07
           FROM gec_file
          WHERE gec01 = sr.pmm21
            AND gec011 = '1'
            AND gec06 = '1'
         IF SQLCA.SQLCODE THEN
            IF SQLCA.SQLCODE = 100 THEN
               LET sr.tax = 0 
            ELSE
               EXIT FOREACH
            END IF
         ELSE
            IF l_gec07 = 'Y' THEN
               LET l_num = 0
               LET l_num =  sr.rvb07 * sr.rvv38 / (1+(l_gec04/100))
               LET sr.tax = sr.rvb07 * sr.rvv38 - l_num
            ELSE 
               LET sr.tax = sr.rvb07 * sr.rvv38 * (l_gec04/100)
            END IF
         END IF 
      END IF
      LET sr.amt = sr.rvv23 * sr.rvv38
 
      SELECT azi03,azi04,azi05   
        INTO t_azi03,t_azi04,t_azi05
        FROM azi_file 
       WHERE azi01=sr.pmm22    
      IF cl_null(sr.rvw06f) THEN LET sr.rvw06f = 0 END IF     
      IF cl_null(sr.tax) THEN LET sr.tax = 0 END IF     
 
      #TQC-970062---Begin
      IF sr.rvu00 = '3' THEN
         LET sr.rvv39 = sr.rvv39 * (-1)
         LET sr.rvv39t= sr.rvv39t * (-1)
      END IF            
      #TQC-970062---End 
      #No.FUN-A80030  --start
      IF tm.c = 'Y' THEN
          SELECT COUNT(*) INTO l_count FROM pmq_file
             WHERE pmq01=sr.rvv31 AND pmq02=sr.rva05
          IF l_count !=0  THEN
            DECLARE pmq_cur CURSOR FOR
            SELECT * FROM pmq_file    
              WHERE pmq01=sr.rvv31 AND pmq02=sr.rva05 
            ORDER BY pmq04                                        
            FOREACH pmq_cur INTO sr1.*                            
              EXECUTE insert_prep1 USING sr1.pmq01,sr1.pmq02,sr1.pmq03,sr1.pmq04,sr1.pmq05,sr.rvv01,sr.rvv02
            END FOREACH
          END IF
       END IF    
       #No.FUN-A80030  --end
      #FUN-C30285---begin
      IF s_industry("icd") THEN
         EXECUTE insert_prep USING  
                 sr.rva05,sr.pmc03,sr.pmc091,tm.endday,sr.pmm20,
                 sr.pma02,sr.pmm21,sr.gec02,sr.pmm22,sr.rva06,
                 sr.rvv04,sr.rvv01,sr.rvb22,sr.rvv36,sr.rvv31,sr.ima021,	
                 sr.rvv031,sr.rvb07,sr.rvv17,sr.rvb80,sr.rvv23,sr.rvv38,   #FUN-AA0081 add sr.rvv17
                 sr.rvv38t,sr.rvv39,sr.rvv39t,	
                 sr.amt,sr.rvw06f,sr.tax,
                 t_azi03,t_azi04,t_azi05,sr.rvv02,l_count,   #No.FUN-A80030 add sr.rvv02,l_count
                 l_rvv34, l_rvviicd01  #FUN-C30285
      ELSE 
      #FUN-C30285---end
         EXECUTE insert_prep USING  
                 sr.rva05,sr.pmc03,sr.pmc091,tm.endday,sr.pmm20,
                 sr.pma02,sr.pmm21,sr.gec02,sr.pmm22,sr.rva06,
                 sr.rvv04,sr.rvv01,sr.rvb22,sr.rvv36,sr.rvv31,sr.ima021,	
                 sr.rvv031,sr.rvb07,sr.rvv17,sr.rvb80,sr.rvv23,sr.rvv38,   #FUN-AA0081 add sr.rvv17
                 sr.rvv38t,sr.rvv39,sr.rvv39t,	
                 sr.amt,sr.rvw06f,sr.tax,
                 t_azi03,t_azi04,t_azi05,sr.rvv02,l_count   #No.FUN-A80030 add sr.rvv02,l_count
      END IF   #FUN-C30285
   END FOREACH
      IF g_zz05 = 'Y' THEN 
         CALL cl_wcchp(tm.wc,'rva01,rva05,rva06,rvb04,rvb05,rvv01,rvb22') #CHI-AC0007 mod rvw01->rvb22
              RETURNING tm.wc    
      END IF
      LET g_str=tm.wc ,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
                           tm.endday,";",tm.c
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED,"|",
               "SELECT DISTINCT * FROM ", g_cr_db_str CLIPPED,l_table1 CLIPPED

   CALL cl_prt_cs3('apmr912',l_name,l_sql,g_str) 

END FUNCTION
#FUN-8A0076
