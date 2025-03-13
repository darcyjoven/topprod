# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aapr105.4gl
# Descriptions...: 入庫帳款明細表列印作業
# Date & Author..: 97/10/30 By yen
# Modify.........: no:7819 03/08/29 By Nicola:驗退顯示負值
# Modify.........: No.FUN-4C0097 04/12/23 By Nicola 報表架構修改
#                                                   增加列印規格ima021
# Modify.........: No.FUN-560089 05/06/21 By Smapmin 單位數量改抓計價單位計價數量
# Modify.........: No.MOD-570350 05/07/28 By Smapmin aapr105  若選擇 (2)AP立帳金額 ...:
#                                                              [ ] ，若有做暫做的話，金額會double
# Modify.........: No.FUN-580003 05/08/02 By jackie 雙單位報表修改
# Modify.........: No.FUN-5B0013 05/11/01 By Rosayu 將料號/品名/規格 欄位設成[1,,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.MOD-5B0004 05/11/29 By Smapmin 將 rva_file,rvb_file改用OUTER的方式
# Modify.........: NO.FUN-630043 06/03/14 By Melody 多工廠帳務中心功能修改
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.FUN-660117 06/06/16 By Rainy Char改為 Like
# Modify.........: No.FUN-660122 06/06/27 By Hellen cl_err --> cl_err3
# Modify.........: No.TQC-610053 06/07/03 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-860021 08/06/10 By Sarah INPUT段漏了ON IDLE控制
# Modify.........: No.FUN-940102 09/04/20 By dxfwo  新增使用者對營運中心的權限管控
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A10098 10/01/19 By chenls 拿掉plant,跨DB改為不跨DB,拿掉aza53程序段
# Modify.........: No.FUN-A60056 10/06/21 By lutingting GP5.2財務串前段問題整批調整  
# Modify.........: No.FUN-A70139 10/07/29 By lutingting 修正FUN-A60056問題
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.FUN-BB0002 12/01/11 By pauline rvb22無資料時進入取rvv22
DATABASE ds
 
GLOBALS "../../config/top.global"

GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
  DEFINE g_seq_item     LIKE type_file.num5        # No.FUN-690028 SMALLINT
END GLOBALS
 
DEFINE tm  RECORD
              wc      LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(600)
              LC_sw   LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
              amt_sw  LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
              more    LIKE type_file.chr1     # No.FUN-690028 VARCHAR(1)
           END RECORD
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
DEFINE   g_sma115        LIKE sma_file.sma115
#No.FUN-A10098 ----------mark start
#DEFINE source    LIKE azp_file.azp01              #FUN-660117
#DEFINE g_azp02   LIKE azp_file.azp02  #FUN-630043
#No.FUN-A10098 ----------mark end
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #-----TQC-610053---------
   LET tm.amt_sw = ARG_VAL(8)
   LET tm.LC_sw = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL aapr105_tm(0,0)                     # Input print condition
   ELSE
      CALL aapr105()                           # Read data and create out-file
   END IF

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
 
END MAIN
 
FUNCTION aapr105_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_cmd          LIKE type_file.chr1000  #No.FUN-690028 VARCHAR(400)
   DEFINE li_result      LIKE type_file.num5     #No.FUN-940102 
 
   OPEN WINDOW aapr105_w WITH FORM "aap/42f/aapr105"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   LET tm.amt_sw= '1'
   LET tm.LC_sw= '3'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
#No.FUN-A10098 ----------mark start
#      #FUN-630043
#      LET source=g_plant 
#      LET g_azp02=''
#      DISPLAY BY NAME source
#      SELECT azp02 INTO g_azp02 FROM azp_file WHERE azp01=source
#      DISPLAY g_azp02 TO FORMONLY.azp02
#      LET g_plant_new=source
#      CALL s_getdbs()
#      IF g_aza.aza53='Y' THEN
#         INPUT BY NAME source WITHOUT DEFAULTS
#            AFTER FIELD source 
#               LET g_azp02=''
#               SELECT azp02 INTO g_azp02 FROM azp_file
#                  WHERE azp01=source
#               IF STATUS THEN
##                 CALL cl_err(source,'100',0) #No.FUN-660122
#                  CALL cl_err3("sel","azp_file",source,"","100","","",0)  #No.FUN-660122
#                  NEXT FIELD source
#               END IF
#               DISPLAY g_azp02 TO FORMONLY.azp02
#     #No.FUN-940102 --begin--                                                                                                       
#               CALL s_chk_demo(g_user,source) RETURNING li_result                                                                   
#                 IF not li_result THEN                                                                                              
#                    NEXT FIELD source                                                                                               
#                 END IF                                                                                                             
#     #No.FUN-940102 --end-- 
#               LET g_plant_new=source
#               CALL s_getdbs()
# 
#            AFTER INPUT
#               IF INT_FLAG THEN EXIT INPUT END IF  
# 
#            ON ACTION CONTROLP
#               CASE
#                  WHEN INFIELD(source)
#                       CALL cl_init_qry_var()
#    #                  LET g_qryparam.form = "q_azp"    #No.FUN-940102
#                       LET g_qryparam.form = "q_zxy"    #No.FUN-940102                                                              
#                       LET g_qryparam.arg1 = g_user     #No.FUN-940102    
#                       LET g_qryparam.default1 = source
#                       CALL cl_create_qry() RETURNING source 
#                       DISPLAY BY NAME source
#                       NEXT FIELD source
#               END CASE
# 
#            ON ACTION exit              #加離開功能genero
#               LET INT_FLAG = 1
#               EXIT INPUT
# 
#            ON ACTION controlg       #TQC-860021
#               CALL cl_cmdask()      #TQC-860021
# 
#            ON IDLE g_idle_seconds   #TQC-860021
#               CALL cl_on_idle()     #TQC-860021
#               CONTINUE INPUT        #TQC-860021
# 
#            ON ACTION about          #TQC-860021
#               CALL cl_about()       #TQC-860021
# 
#            ON ACTION help           #TQC-860021
#               CALL cl_show_help()   #TQC-860021
#         END INPUT
#         IF INT_FLAG THEN
#            LET INT_FLAG = 0 
#            CLOSE WINDOW r105_w 
#            EXIT PROGRAM
#         END IF
#      END IF
#      #FUN-630043
#No.FUN-A10098 ----------mark end
      CONSTRUCT BY NAME tm.wc ON rvu04,rvu00,rvu01,rvu03,rvb22
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
            LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            EXIT CONSTRUCT
 
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
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
      END CONSTRUCT
 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW aapr105_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      DISPLAY BY NAME tm.amt_sw,tm.LC_sw,tm.more
 
      INPUT BY NAME tm.amt_sw,tm.LC_sw,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD amt_sw
            IF cl_null(tm.amt_sw) OR tm.amt_sw NOT MATCHES '[12]' THEN
               NEXT FIELD amt_sw
            END IF
 
         AFTER FIELD LC_sw
            IF cl_null(tm.LC_sw) OR tm.LC_sw NOT MATCHES '[123]' THEN
               NEXT FIELD LC_sw
            END IF
 
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
            CALL cl_cmdask()    # Command execution
 
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
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW aapr105_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aapr105'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aapr105','9031',1)
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
                        #-----TQC-610053---------
                        " '",tm.amt_sw CLIPPED,"'" ,
                        " '",tm.LC_sw CLIPPED,"'" ,
                        #-----END TQC-610053-----
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('aapr105',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW aapr105_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL aapr105()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW aapr105_w
 
END FUNCTION
 
FUNCTION aapr105()
   DEFINE l_name        LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#         l_time        LIKE type_file.chr8,           # Used time for running the job  #No.FUN-690028 VARCHAR(8)
          l_sql         LIKE type_file.chr1000,     # RDSQL STATEMENT  #No.FUN-690028 VARCHAR(1200)
          l_chr         LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          l_order       ARRAY[5] OF LIKE faj_file.faj02,      # No.FUN-690028 VARCHAR(10),
          i,j,k         LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          amt1          LIKE apb_file.apb10,
          rvu		RECORD LIKE rvu_file.*,
          rvv		RECORD LIKE rvv_file.*,
          sr            RECORD
                        rva04	LIKE rva_file.rva04,
                        rvb22	LIKE rvb_file.rvb22,
                        rvw05	LIKE rvw_file.rvw05,
                        pmc03	LIKE pmc_file.pmc03,
                        pmm22   LIKE pmm_file.pmm22,
                        ima021  LIKE ima_file.ima021,
                        rvv80   LIKE rvv_file.rvv80,               #FUN-580003
                        rvv82   LIKE rvv_file.rvv82,               #FUN-580003
                        rvv83   LIKE rvv_file.rvv83,               #FUN-580003
                        rvv85   LIKE rvv_file.rvv85                #FUN-580003
                        END RECORD
#No.FUN-580003 --start--
   DEFINE l_i,l_cnt          LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE l_zaa02            LIKE zaa_file.zaa02
#No.FUN-580003 --end--
   DEFINE l_azw01            LIKE azw_file.azw01    #FUN-A60056 

   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   SELECT sma115 INTO g_sma115 FROM sma_file   #FUN-580003
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND rvuuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND rvugrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND rvugrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('rvuuser', 'rvugrup')
 
   CALL cl_outnam('aapr105') RETURNING l_name    #FUN-A70139
   START REPORT aapr105_rep TO l_name    #FUN-A70139
   #FUN-A60056--add--str--
   LET l_sql = "SELECT azw01 FROM azw_file ",
               " WHERE azwacti = 'Y' ",
               "   AND azw02 = '",g_legal,"'"
   PREPARE sel_azw01 FROM l_sql 
   DECLARE sel_azw CURSOR FOR sel_azw01
   FOREACH sel_azw INTO l_azw01
   #FUN-A60056--add--end
 
      LET l_sql = "SELECT rvu_file.*, rvv_file.*,",
                  "       rva04, rvb22, ' ', pmc03,' ',' ',rvv80,rvv82,rvv83,rvv85",   #No.FUN-580003   #MOD-5B0004
                  #FUN-630043
   #No.FUN-A10098 ----------mark start
   #               "  FROM ",g_dbs_new CLIPPED,"rvu_file ",
   #               "       LEFT OUTER JOIN ",g_dbs_new CLIPPED,"pmc_file ",
   #                "   ON rvu04=pmc01,",
   #               "       ",g_dbs_new CLIPPED,"rvv_file ",
   #               "       LEFT OUTER JOIN ",g_dbs_new CLIPPED,"rva_file ",
   #                "   ON rvv04=rva01 AND rvaconf !='X' ",
   #               "       LEFT OUTER JOIN ",g_dbs_new CLIPPED,"rvb_file ",
   #No.FUN-A10098 ----------mark end
   #FUN-A60056--mod--str--
   ##No.FUN-A10098 ----------add start
   #              "  FROM rvu_file ",
   #              "       LEFT OUTER JOIN pmc_file ",
   #              "   ON rvu04=pmc01,",
   #              "       rvv_file ",
   #              "       LEFT OUTER JOIN rva_file ",
   #              "   ON rvv04=rva01 AND rvaconf !='X' ",
   #              "       LEFT OUTER JOIN rvb_file ",
   ##No.FUN-A10098 ----------add end
                  "  FROM ",cl_get_target_table(l_azw01,'rvu_file'),
                  "  LEFT OUTER JOIN ",cl_get_target_table(l_azw01,'pmc_file') ,
                  "               ON rvu04=pmc01,",
                     cl_get_target_table(l_azw01,'rvv_file'),
                  "  LEFT OUTER JOIN ",cl_get_target_table(l_azw01,'rva_file'),
                  "          ON rvv04=rva01 AND rvaconf !='X' ",
                  "  LEFT OUTER JOIN ",cl_get_target_table(l_azw01,'rvb_file'),
   #FUN-A60056--mod--end
                  "   ON rvv04=rvb01 AND rvv05=rvb02 ",
                  " WHERE rvu01=rvv01 AND rvuconf !='X' ",
                  "   AND ",tm.wc
 
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      CALL cl_parse_qry_sql(l_sql,l_azw01) RETURNING l_sql   #FUN-A60056
      PREPARE aapr105_prepare1 FROM l_sql
      IF STATUS THEN
         CALL cl_err('prepare:',STATUS,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
      DECLARE aapr105_curs1 CURSOR FOR aapr105_prepare1
    
     #CALL cl_outnam('aapr105') RETURNING l_name   #FUN-A70139

      IF g_sma115 = "Y" THEN
             LET g_zaa[38].zaa06 = "N"
      ELSE
             LET g_zaa[38].zaa06 = "Y"
      END IF
      CALL cl_prt_pos_len()
   #No.FUN-580003  --end--
 
     #START REPORT aapr105_rep TO l_name    #FUN-A70139
 
      LET g_pageno = 0
      FOREACH aapr105_curs1 INTO rvu.*, rvv.*, sr.*
   #FUN-BB0002 add START
        IF cl_null(sr.rvb22) THEN
           LET sr.rvb22 = rvv.rvv22
        END IF
   #FUN-BB0002 add END
   #MOD-5B0004
        SELECT SUM(rvw05) INTO sr.rvw05 FROM rvw_file
           WHERE rvw01 = sr.rvb22
   #END MOD-5B0004
         SELECT ima021 INTO sr.ima021 FROM ima_file
          WHERE ima01 = rvv.rvv31
         IF sr.rvw05 IS NULL THEN
            LET sr.rvw05 = 0
         END IF
         IF sr.rva04 IS NULL THEN
            LET sr.rva04 = 'N'
         END IF
         IF tm.LC_sw='1' AND sr.rva04= 'Y' THEN
            CONTINUE FOREACH
         END IF
         IF tm.LC_sw='2' AND sr.rva04<>'Y' THEN
            CONTINUE FOREACH
         END IF
         IF tm.amt_sw='1' THEN
           #FUN-A60056--mod--str--
           #SELECT pmm22 INTO sr.pmm22 FROM pmm_file
           # WHERE pmm01 = rvv.rvv36
            LET l_sql = "SELECT pmm22 FROM ",cl_get_target_table(l_azw01,'pmm_file'),
                        " WHERE pmm01 = '",rvv.rvv36,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,l_azw01) RETURNING l_sql
            PREPARE sel_pmm22_cs FROM l_sql
            EXECUTE sel_pmm22_cs INTO sr.pmm22
           #FUN-A60056--mod--end
         END IF
         IF tm.amt_sw='2' THEN
    #MOD-570350
{
         SELECT SUM(apb10) INTO amt1 FROM apb_file
          WHERE apb21=rvv.rvv01 AND apb22=rvv.rvv02
}
            SELECT SUM(apb10) INTO amt1 FROM apb_file,apa_file
             WHERE apb21=rvv.rvv01 AND apb22=rvv.rvv02
               AND apa01 = apb01 AND apa00 != '12'
    #END MOD-570350
            IF amt1 IS NULL THEN
               LET amt1=0
            END IF
            LET rvv.rvv39 = amt1
            #IF rvv.rvv17 <> 0 THEN    #FUN-560089
            IF rvv.rvv87 <> 0 THEN    #FUN-560089
               #LET rvv.rvv38 = rvv.rvv39 / rvv.rvv17   #FUN-560089
               LET rvv.rvv38 = rvv.rvv39 / rvv.rvv87   #FUN-560089
            END IF
         END IF
         IF rvu.rvu00 MATCHES '[23]' THEN       #bugno:7819
            #LET rvv.rvv17 = rvv.rvv17 * -1   #FUN-560089
            LET rvv.rvv87 = rvv.rvv87 * -1   #FUN-560089
           LET rvv.rvv39 = rvv.rvv39 * -1
         END IF
         OUTPUT TO REPORT aapr105_rep(rvu.*, rvv.*, sr.*,l_azw01)   #FUN-A60056 add l_azw01
      END FOREACH
   END FOREACH   #FUN-A60056
 
      FINISH REPORT aapr105_rep
 
      CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 
END FUNCTION
 
REPORT aapr105_rep(rvu, rvv, sr,l_azw01)   #FUN-A60056  add azw01
   DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          rvu		RECORD LIKE rvu_file.*,
          rvv		RECORD LIKE rvv_file.*,
          sr            RECORD
                        rva04	LIKE rva_file.rva04,
                        rvb22	LIKE rvb_file.rvb22,
                        rvw05	LIKE rvw_file.rvw05,
                        pmc03	LIKE pmc_file.pmc03,
                        pmm22   LIKE pmm_file.pmm22,
                        ima021  LIKE ima_file.ima021,
                        rvv80   LIKE rvv_file.rvv80,               #FUN-580003
                        rvv82   LIKE rvv_file.rvv82,               #FUN-580003
                        rvv83   LIKE rvv_file.rvv83,               #FUN-580003
                        rvv85   LIKE rvv_file.rvv85                #FUN-580003
                        END RECORD,
          alow			LIKE rvu_file.rvu10,     # No.FUN-690028 VARCHAR(4),
          l_pmm22       LIKE pmm_file.pmm22,
          amt1,tot1,tot2	LIKE rvv_file.rvv39
   DEFINE g_head1        STRING
#No.FUN-580003 --start--
   DEFINE l_ima906      LIKE ima_file.ima906
   DEFINE l_str2        LIKE type_file.chr1000     # No.FUN-690028 VARCHAR(100)
   DEFINE l_rvv85        STRING
   DEFINE l_rvv82        STRING
#No.FUN-580003 --end--
   DEFINE l_azw01       LIKE azw_file.azw01   #FUN-A60056
   DEFINE l_sql         STRING                #FUN-A60056
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY rvu.rvu04,sr.rvb22,rvu.rvu00, rvu.rvu01
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         PRINT
         PRINT g_dash[1,g_len]
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
               g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44]  #No.FUN-580003
         PRINT g_dash1
         LET l_last_sw = 'n'
         IF PAGENO = 1 THEN
            LET tot2 = 0
         END IF
 
      BEFORE GROUP OF rvu.rvu04
         PRINT COLUMN g_c[31],g_x[13] CLIPPED,rvu.rvu04,
               COLUMN g_c[32],sr.pmc03
         PRINT
 
      BEFORE GROUP OF sr.rvb22
         PRINT COLUMN g_c[31],sr.rvb22,
    #NIC            COLUMN g_c[32],cl_numfor(sr.rvw05,32,g_azi04)
               COLUMN g_c[32],cl_numfor(sr.rvw05,32,g_azi04);
 
      ON EVERY ROW
         LET alow=' '
         IF rvu.rvu00 MATCHES '[23]' THEN
            IF rvu.rvu10 = 'Y' THEN
               LET alow = 'Y'
            ELSE
               LET alow = 'N'
            END IF
         END IF
         IF cl_null(rvv.rvv031) THEN
            SELECT ima02 INTO rvv.rvv031 FROM ima_file WHERE ima01 = rvv.rvv31
            IF SQLCA.sqlcode THEN
               LET rvv.rvv031 = ' '
            END IF
         END IF
        #FUN-A60056--mod--str--
        #SELECT pmm22 INTO l_pmm22 FROM pmm_file WHERE pmm01 = rvv.rvv36
         LET l_sql = "SELECT pmm22 FROM ",cl_get_target_table(l_azw01,'pmm_file'),
                     " WHERE pmm01 = '",rvv.rvv36,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_azw01) RETURNING l_sql   #FUN-A60056
         PREPARE sel_pmm22_cs1 FROM l_sql
         EXECUTE sel_pmm22_cs1 INTO l_pmm22
        #FUN-A60056--mod--end
         IF SQLCA.sqlcode THEN
            LET l_pmm22 = ' '
         END IF
#MOD-5B0004
        IF cl_null(l_pmm22) THEN
           SELECT pmc22 INTO l_pmm22 FROM pmc_file WHERE pmc01 = rvu.rvu04
        END IF
#END MOD-5B0004
 
#No.FUN-580003 --start--
      SELECT ima906 INTO l_ima906 FROM ima_file
                         WHERE ima01=rvv.rvv31
      LET l_str2 = ""
      IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
                CALL cl_remove_zero(sr.rvv85) RETURNING l_rvv85
                LET l_str2 = l_rvv85 , sr.rvv83 CLIPPED
                IF cl_null(sr.rvv85) OR sr.rvv85 = 0 THEN
                    CALL cl_remove_zero(sr.rvv82) RETURNING l_rvv82
                    LET l_str2 = l_rvv82, sr.rvv80 CLIPPED
                ELSE
                   IF NOT cl_null(sr.rvv82) AND sr.rvv82 > 0 THEN
                      CALL cl_remove_zero(sr.rvv82) RETURNING l_rvv82
                      LET l_str2 = l_str2 CLIPPED,',',l_rvv82, sr.rvv80 CLIPPED
                   END IF
                END IF
            WHEN "3"
                IF NOT cl_null(sr.rvv85) AND sr.rvv85 > 0 THEN
                    CALL cl_remove_zero(sr.rvv85) RETURNING l_rvv85
                    LET l_str2 = l_rvv85 , sr.rvv83 CLIPPED
                END IF
         END CASE
      ELSE
      END IF
 
#No.FUN-580003 --end--
         PRINT COLUMN g_c[33],rvu.rvu00,
               COLUMN g_c[34],rvu.rvu01,
               #COLUMN g_c[35],rvv.rvv31[1,20],  #No.FUN-580003 #FUN-5B0013 mark
               COLUMN g_c[35],rvv.rvv31 CLIPPED,  #No.FUN-580003 #FUN-5B0013 add
               COLUMN g_c[36],rvv.rvv031 CLIPPED, #FUN-5B0013 add CLIPPED
               COLUMN g_c[37],sr.ima021 CLIPPED, #FUN-5B0013 add CLIPPED
               COLUMN g_c[38],l_str2 CLIPPED,   #No.FUN-580003
               #COLUMN g_c[38],rvv.rvv17 USING '-----------.--&',   #FUN-560089
               COLUMN g_c[39],rvv.rvv87 USING '-----------.--&',   #FUN-560089
               #COLUMN g_c[39],rvv.rvv35,   #FUN-560089
               COLUMN g_c[40],rvv.rvv86,   #FUN-560089
               COLUMN g_c[41],cl_numfor(rvv.rvv38,41,g_azi03),
               COLUMN g_c[42],l_pmm22,
               COLUMN g_c[43],cl_numfor(rvv.rvv39,43,g_azi04),
               COLUMN g_c[44],alow
 
      AFTER GROUP OF sr.rvb22
         LET amt1 = GROUP SUM(rvv.rvv39)
         LET tot1 = tot1 + (sr.rvw05-amt1)
         IF tm.amt_sw = '2' THEN
            LET tot2 = tot2 + (sr.rvw05-amt1)
         END IF
         IF GROUP COUNT(*) > 1 OR sr.rvw05<>amt1 THEN
            PRINT COLUMN g_c[39],g_x[9] CLIPPED,
                  COLUMN g_c[40],cl_numfor(sr.rvw05-amt1,40,g_azi05),
                  COLUMN g_c[41],g_x[10] CLIPPED,
                  COLUMN g_c[42],cl_numfor(GROUP SUM(rvv.rvv39),42,g_azi05)
         END IF
 
      AFTER GROUP OF rvu.rvu04
         PRINT
          PRINT COLUMN g_c[39],g_x[9] CLIPPED,
                COLUMN g_c[40],cl_numfor(tot1,40,g_azi05),
                COLUMN g_c[41],g_x[11] CLIPPED,
                COLUMN g_c[42],cl_numfor(GROUP SUM(rvv.rvv39),42,g_azi05)
         PRINT g_dash[1,g_len]
 
      ON LAST ROW
         IF tm.amt_sw='2' THEN
            PRINT COLUMN g_c[39],g_x[9] CLIPPED,
                  COLUMN g_c[40],cl_numfor(tot2,40,g_azi05),
                  COLUMN g_c[41],g_x[12] CLIPPED,
                  COLUMN g_c[42],cl_numfor(SUM(rvv.rvv39),42,g_azi05)
            PRINT g_dash[1,g_len]
         ELSE
            PRINT g_dash[1,g_len]
            PRINT
         END IF
         LET l_last_sw = 'y'
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),g_x[7] CLIPPED   #No.FUN-580003
 
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
         ELSE
            SKIP 2 LINE
         END IF
END REPORT
