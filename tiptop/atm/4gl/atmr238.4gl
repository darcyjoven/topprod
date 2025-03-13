# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: atmr238.4gl
# Descriptions...: 訂單預計返利表
# Date & Author..: 06/03/21 By wujie
# Modify.........: No.FUN-630056 06/04/18 By wujie   客戶欄位調整
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By Hellen 本原幣取位修改
# Modify.........: TQC-6A0079 06/11/01 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.FUN-6B0014 06/11/06 By bnlent l_time轉g_time
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-850132 08/05/23 By destiny 報表打印時資料有重復
# Modify.........: No.FUN-850152 08/06/06 By ChenMoyan 舊報表轉CR
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-A10003 10/04/15 By Summer 將l_table的變數定義成STRING
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
END GLOBALS
 
   DEFINE tm  RECORD                # Print condition RECORD
              wc      STRING, #CHAR(500),        # Where condition
              s       LIKE ade_file.ade04,        #TQC-840066
              t       LIKE ade_file.ade04,        #TQC-840066 
              u       LIKE ade_file.ade04,        #TQC-840066
              o       LIKE type_file.chr1,             #No.FUN-680120
              more    LIKE type_file.chr1              #No.FUN-680120         # Input more condition(Y/N)
              END RECORD,
          g_orderA        ARRAY[3] OF LIKE zaa_file.zaa08     #No.FUN-680120   #排序名稱
DEFINE    g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE    g_head1         STRING
DEFINE g_sma115         LIKE sma_file.sma115
DEFINE #l_sql            LIKE type_file.chr1000       #No.FUN-680120
       l_sql    STRING     #NO.FUN-910082
DEFINE l_zaa02          LIKE zaa_file.zaa02
DEFINE i                LIKE type_file.num10         #No.FUN-680120
#No.FUN-850152 --Begin
DEFINE g_str            LIKE type_file.chr1000
DEFINE l_table          STRING  #No.CHI-A10003 mod LIKE type_file.chr1000-->STRING
DEFINE #g_sql            LIKE type_file.chr1000
       g_sql    STRING     #NO.FUN-910082
#No.FUN-850152 --End
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
#No.FUN-850152 --Begin
  LET g_sql="oea01.oea_file.oea01,",
            "oea14.oea_file.oea14,",
            "gen02.gen_file.gen02,",
            "oea15.oea_file.oea15,",
            "gem02.gem_file.gem02,",
            "oea03.oea_file.oea03,",
            "oea032.oea_file.oea032,",
            "oeb14.oeb_file.oeb14,",
            "oeb14t.oeb_file.oeb14t,",
            "oeb1007.oeb_file.oeb1007"
  LET l_table=cl_prt_temptable('atmr238',g_sql)
  IF l_table=-1 THEN EXIT PROGRAM END IF
#No.FUN-850152 --End
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s = ARG_VAL(8)
   LET tm.t = ARG_VAL(9)
   LET tm.u = ARG_VAL(10)
   LET tm.o = ARG_VAL(11)
   LET tm.more = ARG_VAL(12)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL atmr238_tm(0,0)             # Input print condition
      ELSE CALL atmr238()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION atmr238_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680120 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680120
 
   LET p_row = 3 LET p_col = 13
 
   OPEN WINDOW atmr238_w AT p_row,p_col WITH FORM "atm/42f/atmr238"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies= '1'
   LET tm2.s1  = '1'
   LET tm2.s2  = '2'
   LET tm2.s3  = '3'
   LET tm2.u1  = 'N'
   LET tm2.u2  = 'N'
   LET tm2.u3  = 'N'
   LET tm2.t1  = 'N'
   LET tm2.t2  = 'N'
   LET tm2.t3  = 'N'
   LET tm.o    = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oea01,oea14,oea15,oea03   #No.FUN-630056
                             
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
       ON ACTION locale
         LET g_action_choice = "locale"
          CALL cl_show_fld_cont()      
         EXIT CONSTRUCT
 
       ON ACTION CONTROLP
           CASE
              WHEN INFIELD(oea01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_oea6"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oea01
                NEXT FIELD oea01
 
              WHEN INFIELD(oea03)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_occ"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oea03
                NEXT FIELD oea03
 
#No.FUN-630056--begin                
#             WHEN INFIELD(oea1001)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_occ"
#               LET g_qryparam.state = 'c'
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO oea1001
#               NEXT FIELD oea1001
#No.FUN-630056--end                  
 
              WHEN INFIELD(oea14)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gen"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oea14
                NEXT FIELD oea14
 
              WHEN INFIELD(oea15)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gem"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oea15
                NEXT FIELD oea15
 
           END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
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
      LET INT_FLAG = 0 CLOSE WINDOW atmr238_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
 
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,
                 tm2.t1,tm2.t2,tm2.t3,
                 tm2.u1,tm2.u2,tm2.u3,
                 tm.o,tm.more
       WITHOUT DEFAULTS
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD o
         IF cl_null(tm.o) OR tm.o NOT MATCHES '[12]' THEN
            NEXT FIELD o
         END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      #UI
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW atmr238_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='atmr238'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('atmr238','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.s CLIPPED,"'" ,
                         " '",tm.t CLIPPED,"'" ,
                         " '",tm.u CLIPPED,"'" ,
                         " '",tm.o CLIPPED,"'" ,
                         " '",tm.more CLIPPED,"'"  ,
                         " '",g_rep_user CLIPPED,"'",     
                         " '",g_rep_clas CLIPPED,"'",     
                         " '",g_template CLIPPED,"'"      
         CALL cl_cmdat('atmr238',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW atmr238_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL atmr238()
   ERROR ""
END WHILE
   CLOSE WINDOW atmr238_w
END FUNCTION
 
FUNCTION atmr238()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680120       # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6B0014
          l_sql     LIKE type_file.chr1000,       #No.FUN-680120
          l_za05    LIKE ima_file.ima01,          #No.FUN-680120 
          l_order    ARRAY[5] OF LIKE ima_file.ima01,  #No.FUN-680120 
          sr        RECORD
                      order1 LIKE ima_file.ima01,  #No.FUN-680120
                      order2 LIKE ima_file.ima01,  #No.FUN-680120
                      order3 LIKE ima_file.ima01,  #No.FUN-680120
                      oea01  LIKE oea_file.oea01,
                      oea14  LIKE oea_file.oea14,
                      gen02  LIKE gen_file.gen02,
                      oea15  LIKE oea_file.oea15,
                      gem02  LIKE gem_file.gem02,
#No.FUN-630056--begin                
#                     oea1001  LIKE oea_file.oea1001,
#                     oea1001_occ02 LIKE occ_file.occ02, 
#No.FUN-630056--end                  
                      oea03  LIKE oea_file.oea03,
                      oea032 LIKE oea_file.oea032,
                      oeb14  LIKE oeb_file.oeb14,
                      oeb14t LIKE oeb_file.oeb14t,
                      oeb03  LIKE oeb_file.oeb03, 
                      oeb1007 LIKE oeb_file.oeb1007 
                    END RECORD
 
#No.FUN-850152--Begin
     LET g_sql=" INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?)"
     PREPARE insert_prep FROM g_sql
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='atmr238'
#No.FUN-850152 --END
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang    #No.FUN-850152
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#NO.CHI-6A0004 --START
#    SELECT azi03,azi04,azi05
#      INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#      FROM azi_file
#     WHERE azi01=g_aza.aza17
#NO.CHI-6A0004 --END
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND oeauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND oeagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
     #End:FUN-980030
 
     LET l_sql ="SELECT '','','',oea01,oea14,gen02,oea15,gem02,",
                "       oea03,oea032,oeb14,oeb14t,oeb03,oeb1007",    #No.FUN-630056
                "  FROM oea_file,oeb_file,",
#               "       OUTER occ_file,OUTER gen_file,OUTER gem_file ", #No.FUN-850132
                "       OUTER gen_file,OUTER gem_file ",                #No.FUN-850132
                " WHERE oea01=oeb01 ",
#               "   AND oea1001=occ_file.occ01 ",    #No.FUN-630056
                "   AND oea_file.oea14=gen_file.gen01 ",
                "   AND oea_file.oea15=gem_file.gem01 ",
                "   AND oea00<>'0' ",    #合約不計
                "   AND oeaconf='Y' ",                        #已確認
                "   AND oeb70='N' ",
                "   AND (oeahold IS NULL OR oeahold=' ') ",   #未留置
                "   AND oeb1003 ='2' ",
                "   AND ",tm.wc CLIPPED,
                " ORDER BY oea01,oea03 "    #No.FUN-630056
 
     PREPARE atmr238_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
        EXIT PROGRAM
     END IF
     DECLARE atmr238_curs1 CURSOR FOR atmr238_prepare1
 
#    CALL cl_outnam('atmr238') RETURNING l_name        #No.FUN-850152
 
     SELECT sma115 INTO g_sma115 FROM sma_file
#No.FUN-850152 --Begin
#    IF g_sma115 = "Y"  THEN
#           LET g_zaa[47].zaa06 = "N"
#    ELSE
#           LET g_zaa[47].zaa06 = "Y"
#    END IF
#     CALL cl_prt_pos_len()
 
#    START REPORT atmr238_rep TO l_name
 
#    LET g_pageno = 0
#No.FUN-850152 --End
     FOREACH atmr238_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
      
       SELECT SUM(ogb14),SUM(ogb14t) FROM ogb_file,oga_file
        WHERE ogb31 =sr.oea01
          AND ogb32 =sr.oeb03
          AND ogb01 =oga01
          AND ogb1005 ='2'
#No.FUN-850152 --Begin
#      FOR g_i = 1 TO 3
#         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.oea01
#                                       LET g_orderA[g_i]= g_x[13]
#No.FUN-850152 --End
#              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.oea1001    #No.FUN-630056
#                                       LET g_orderA[g_i]= g_x[17]
#No.FUN-850152 --Begin
#              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.oea03
#                                       LET g_orderA[g_i]= g_x[16]
#              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.oea14
#                                       LET g_orderA[g_i]= g_x[14]
#              WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.oea15
#                                       LET g_orderA[g_i]= g_x[15]
#              OTHERWISE LET l_order[g_i] = '-'
#         END CASE
#      END FOR
#      LET sr.order1 = l_order[1]
#      LET sr.order2 = l_order[2]
#      LET sr.order3 = l_order[3]
 
       EXECUTE insert_prep USING sr.oea01,sr.oea14,sr.gen02,sr.oea15,sr.gem02,
                                 sr.oea03,sr.oea032,sr.oeb14,sr.oeb14t,sr.oeb1007
#      OUTPUT TO REPORT atmr238_rep(sr.*)
#No.FUN-850152 --End
     END FOREACH
 
#No.FUN-850152 --Begin
#    FINISH REPORT atmr238_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     LET g_sql=" SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN
         CALL cl_wcchp(tm.wc,'oea01,oea14,oea15,oea03')
                    RETURNING tm.wc
     ELSE
         LET tm.wc=""
     END IF
     LET g_str=tm.wc,';',tm.t[1,1],';',tm.t[2,2],';',tm.t[3,3],';',tm.u[1,1],';',
               tm.u[2,2],';',tm.u[3,3],';',tm.s[1,1],';',tm.s[2,2],';',tm.s[3,3],';',
               tm.o
               
     CALL cl_prt_cs3('atmr238','atmr238',g_sql,g_str)
#No.FUN-850152 --End
END FUNCTION
 
#No.FUN-850152 --Begin
#REPORT atmr238_rep(sr)
#  DEFINE l_last_sw    LIKE type_file.chr20,            #No.FUN-680120
#         sr        RECORD
#                     order1 LIKE ima_file.ima01,       #No.FUN-680120  
#                     order2 LIKE ima_file.ima01,       #No.FUN-680120 
#                     order3 LIKE ima_file.ima01,       #No.FUN-680120 
#                     oea01  LIKE oea_file.oea01,
#                     oea14  LIKE oea_file.oea14,
#                     gen02  LIKE gen_file.gen02,
#                     oea15  LIKE oea_file.oea15,
#                     gem02  LIKE gem_file.gem02,
#No.FUN-850152 --End
#No.FUN-630056--begin                
#                     oea1001  LIKE oea_file.oea1001,
#                     oea1001_occ02 LIKE occ_file.occ02, 
#No.FUN-630056--end                  
#No.FUN-850152 --Begin
#                     oea03  LIKE oea_file.oea03,
#                     oea032 LIKE oea_file.oea032,
#                     oeb14  LIKE oeb_file.oeb14,
#                     oeb14t LIKE oeb_file.oeb14t,
#                     oeb03  LIKE oeb_file.oeb03, 
#                     oeb1007 LIKE oeb_file.oeb1007
#                   END RECORD,
#        l_flag         LIKE type_file.num5             #No.FUN-680120
#  DEFINE  l_oeb915    STRING
#  DEFINE  l_oeb912    STRING
#  DEFINE  l_str2      STRING
#  DEFINE  l_ima906    LIKE ima_file.ima906
#  DEFINE  l_sum       LIKE oeb_file.oeb14    
#  DEFINE  l_sum_t     LIKE oeb_file.oeb14t   
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.order1,sr.order2,sr.order3
 
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<','/pageno'
#     PRINT g_head CLIPPED, pageno_total
#     IF tm.o ='2' THEN LET g_x[11]=g_x[12] END IF
#     LET g_head1 = g_x[10] CLIPPED,
#                   g_orderA[1] CLIPPED,'-',
#                   g_orderA[2] CLIPPED,'-',
#                   g_orderA[3] CLIPPED
#     PRINT g_dash[1,g_len]
#     PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[39],g_x[40],g_x[41],g_x[42]     #No.FUN-630056
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.order1
#     IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
#  BEFORE GROUP OF sr.order2
#     IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
#  BEFORE GROUP OF sr.order3
#     IF tm.t[3,3] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
#  ON EVERY ROW
#    SELECT azi03,azi04,azi05
#No.FUN-850152 --End
#      INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取 #NO.CHI-6A0004
#No.FUN-850152 --Begin
#      INTO t_azi03,t_azi04,t_azi05          #幣別檔小數位數讀取 #NO.CHI-6A0004
#      FROM azi_file
#     WHERE azi01 =(SELECT oea23 FROM oea_file
#                    WHERE oea01 =sr.oea01)
 
#     PRINT COLUMN g_c[31],sr.oea03, 
#           COLUMN g_c[42],sr.oea032,
#           COLUMN g_c[32],sr.oea01, 
#           COLUMN g_c[33],sr.oea14, 
#           COLUMN g_c[34],sr.gen02,
#           COLUMN g_c[35],sr.oea15,
#           COLUMN g_c[36],sr.gem02,
#No.FUN-850152 --End
#No.FUN-630056--begin                
#           COLUMN g_c[37],sr.oea1001,
#           COLUMN g_c[38],sr.oea1001_occ02,
#No.FUN-630056--end                  
#           COLUMN g_c[39],cl_numfor(sr.oeb14,39,g_azi04),  #NO.CHI-6A0004
#           COLUMN g_c[39],cl_numfor(sr.oeb14,39,t_azi04),  #NO.CHI-6A0004#No.FUN-850152
#           COLUMN g_c[40],cl_numfor(sr.oeb14t,40,g_azi04), #NO.CHI-6A0004
#No.FUN-850152 --Begin
#           COLUMN g_c[40],cl_numfor(sr.oeb14t,40,t_azi04), #NO.CHI-6A0004
#           COLUMN g_c[41],sr.oeb1007
#
#  AFTER GROUP OF sr.order1
#     IF tm.u[1,1] = 'Y' THEN
#        LET l_sum =GROUP SUM(sr.oeb14)
#        LET l_sum_t =GROUP SUM(sr.oeb14t)
#        PRINT
#No.FUN-850152 --End
#        PRINT COLUMN g_c[39],cl_numfor(l_sum,39,g_azi04),  #NO.CHI-6A0004
#        PRINT COLUMN g_c[39],cl_numfor(l_sum,39,t_azi04),  #NO.CHI-6A0004 #No.FUN-850152
#              COLUMN g_c[40],cl_numfor(l_sum_t,40,g_azi04) #NO.CHI-6A0004
#No.FUN-850152 --Begin
#              COLUMN g_c[40],cl_numfor(l_sum_t,40,t_azi04) #NO.CHI-6A0004
#     END IF
 
#  AFTER GROUP OF sr.order2
#     IF tm.u[2,2] = 'Y' THEN
#        LET l_sum =GROUP SUM(sr.oeb14)
#        LET l_sum_t =GROUP SUM(sr.oeb14t)
#        PRINT
#No.FUN-850152 --End
#        PRINT COLUMN g_c[39],cl_numfor(l_sum,39,g_azi04),  #NO.CHI-6A0004
#        PRINT COLUMN g_c[39],cl_numfor(l_sum,39,t_azi04),  #NO.CHI-6A0004 #No.FUN-850152
#              COLUMN g_c[40],cl_numfor(l_sum_t,40,g_azi04) #NO.CHI-6A0004
#No.FUN-850152--Begin
#              COLUMN g_c[40],cl_numfor(l_sum_t,40,t_azi04) #NO.CHI-6A0004
#     END IF
 
#  AFTER GROUP OF sr.order3
#     IF tm.u[3,3] = 'Y' THEN
#        LET l_sum =GROUP SUM(sr.oeb14)
#        LET l_sum_t =GROUP SUM(sr.oeb14t)
#        PRINT
#No.FUN-850152 --End
#        PRINT COLUMN g_c[39],cl_numfor(l_sum,39,g_azi04),  #NO.CHI-6A0004
#        PRINT COLUMN g_c[39],cl_numfor(l_sum,39,t_azi04),  #NO.CHI-6A0004 #No.FUN-850152
#              COLUMN g_c[40],cl_numfor(l_sum_t,40,g_azi04) #NO.CHI-6A0004
#No.FUN-850152 --Begin
#              COLUMN g_c[40],cl_numfor(l_sum_t,40,t_azi04) #NO.CHI-6A0004
#     END IF
 
#  ON LAST ROW
#     IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#        CALL cl_wcchp(tm.wc,'cti01,ima06')
#             RETURNING tm.wc
#        PRINT g_dash[1,g_len]
#      CALL cl_prt_pos_wc(tm.wc)
 
#     END IF
#     PRINT g_dash[1,g_len]
#     LET l_last_sw = 'y'
#     PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED  
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash[1,g_len]
#             PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED 
#        ELSE SKIP 2 LINE
#     END IF
##
#END REPORT
#No.FUN-850152 --End
