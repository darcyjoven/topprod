# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: gnmq940.4gl
# Descriptions...: 現金流量表列印
# Date & Author..: 2003/10/14 By Winny Wu
# Modify.........: No.FUN-520004 05/03/04 By pengu 修改報表單價、金額欄位寬度
# Modify.........: No.FUN-580110 05/08/24 By Tracy 2.0憑証類報表修改,轉XML格式
# Modify.........: No.FUN-640004 06/04/05 By ice 新增傳參供gglp160(會計核算接口程序)調用
# Modify.........: No.FUN-660146 06/06/22 By Carrier cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680145 06/08/31 By Dxfwo  欄位類型定義
# Modify.........: No.CHI-6A0004 06/10/23 By atsea g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0098 06/10/26 By atsea l_time轉g_time
# Modify.........: No.MOD-6C0171 06/12/27 By Rayven 報表格式有點奇怪，參照.per檔修改
# Modify.........: No.FUN-710056 07/02/05 By Carrier 透過gglp160無法產生XJLLB_1.TXT
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-720013 07/03/01 By TSD.Ken #CR11
# Modify.........: No.TQC-720034 07/05/17 By Jackho 報表項目打印修正
# Modify.........: No.FUN-750144 07/06/04 By Sarah 資料調整,適當縮排
# Modify.........: No.TQC-780054 07/08/17 By zhoufeng 修改INSERT INTO temptable語法
# Modify.........: No.FUN-850030 08/05/13 By dxfwo    報表查詢化
# Modify.........: No.TQC-940068 09/05/07 By mike MSV BUG  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE tm  RECORD
           title      LIKE type_file.chr20,  #NO FUN-680145 VARCHAR(20)    #輸入報表名稱
           y1         LIKE type_file.num5,   #NO FUN-680145 SMALLINT    #輸入起始年度
           m1         LIKE type_file.num5,   #NO FUN-680145 SMALLINT    #Begin 期別
           y2         LIKE type_file.num5,   #NO FUN-680145 SMALLINT    #輸入截止年度
           m2         LIKE type_file.num5,   #NO FUN-680145 SMALLINT    #End   期別
           c          LIKE type_file.chr1,   #NO FUN-680145 VARCHAR(1)     #異動額及餘額為0者是否列印
           d          LIKE type_file.chr1,   #NO FUN-680145 VARCHAR(1)     #金額單位
           o          LIKE type_file.chr1,   #NO FUN-680145 VARCHAR(1)     #轉換幣別否
           r          LIKE azi_file.azi01,   #總帳幣別
           p          LIKE azi_file.azi01,   #轉換幣別
           q          LIKE azj_file.azj03,   #匯率
           more       LIKE type_file.chr1    #NO FUN-680145 VARCHAR(1)     #Input more condition(Y/N)
           END RECORD,
       bdate,edate    LIKE type_file.dat,    #NO FUN-680145 DATE
       l_za05         LIKE type_file.chr1000,#NO FUN-680145 VARCHAR(40)
       g_bookno       LIKE aah_file.aah00,   #帳別
       g_unit         LIKE type_file.num10,  #NO FUN-680145 INTEGER
       g_tot1         ARRAY[100] OF LIKE ade_file.ade05,    #NO FUN-680145 DEC(15,3)
       g_tot1_1       ARRAY[100] OF LIKE ade_file.ade05     #NO FUN-680145 DEC(15,3)
DEFINE g_i            LIKE type_file.num5    #NO FUN-680145 SMALLINT       #count/index for any purpose
DEFINE g_before_input_done  LIKE type_file.num5           #NO FUN-680145 SMALLINT
DEFINE p_cmd          LIKE type_file.chr1    #NO FUN-680145 VARCHAR(1)
DEFINE g_msg          LIKE type_file.chr1000 #NO FUN-680145 VARCHAR(100)
DEFINE g_name         LIKE type_file.chr1000 #FILENAME FUN-640004  #NO FUN-680145  VARCHAR(60)
DEFINE g_flag         LIKE type_file.chr1    #Y:產生接口數據 N:正常打印 FUN-640004  #NO FUN-680145 VARCHAR(01)
DEFINE g_ym           LIKE azj_file.azj02    #年期 FUN-640004      #NO FUN-680145  VARCHAR(06)
DEFINE l_zaa02        LIKE zaa_file.zaa02    #No.FUN-640004  
DEFINE l_zaa08        LIKE zaa_file.zaa08    #No.FUN-640004
DEFINE l_table        STRING,                #FUN-720013 add
       g_str          STRING,                #FUN-720013 add
       g_sql          STRING,                #FUN-720013 add
       g_cnt          LIKE type_file.num5    #FUN-720013 add
 
#No.FUN-850030  --Begin
DEFINE   g_yy2      LIKE type_file.num5
DEFINE   g_rec_b    LIKE type_file.num10
DEFINE   g_nml      DYNAMIC ARRAY OF RECORD
                    nml02  LIKE nml_file.nml02,
                    nml05  LIKE nml_file.nml05,
                    nme08a LIKE nme_file.nme08, 
                    nme08b LIKE nme_file.nme08
                    END RECORD
DEFINE   g_pr_ar    DYNAMIC ARRAY OF RECORD
                    line   LIKE type_file.num10,
                    nml02  LIKE nml_file.nml02,
                    nml05  LIKE nml_file.nml05,
                    nme08a LIKE nme_file.nme08, 
                    nme08b LIKE nme_file.nme08
                    END RECORD
DEFINE bdate1       LIKE type_file.dat
DEFINE edate1       LIKE type_file.dat
#No.FUN-850030   --End
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GNM")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_trace = 'N'               # default trace off
   LET g_bookno = ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   #-----TQC-610056---------
   LET tm.title = ARG_VAL(8)
   LET tm.y1 = ARG_VAL(9)
   LET tm.y2 = ARG_VAL(10)
   LET tm.m1 = ARG_VAL(11)
   LET tm.m2 = ARG_VAL(12)
   LET tm.c = ARG_VAL(13)
   LET tm.d = ARG_VAL(14)
   LET tm.o = ARG_VAL(15)
   LET tm.r = ARG_VAL(16)
   LET tm.p = ARG_VAL(17)
   LET tm.q = ARG_VAL(18)
   #-----END TQC-610056-----
   #No.FUN-630090 --start--
   LET g_rep_user = ARG_VAL(19)
   LET g_rep_clas = ARG_VAL(20)
   LET g_template = ARG_VAL(21)
   LET g_rpt_name = ARG_VAL(22)  #No.FUN-7C0078
   #No.FUN-640004 --start--
   IF NOT (cl_null(tm.y1) OR cl_null(tm.m1)) THEN
      LET g_flag = 'Y'
      LET g_ym = tm.y1 USING '&&&&',tm.m1 USING '&&'
      SELECT aaa03 INTO tm.r FROM aaa_file WHERE aaa01 = g_nmz.nmz02b
      IF cl_null(tm.m2) THEN LET tm.m2 = tm.m1 END IF
      IF cl_null(tm.title) THEN LET tm.title = g_name END IF
      LET tm.c = 'Y'
      LET tm.d = '1'
      LET tm.o = 'N'
      LET tm.p = tm.r
      LET tm.q = 1
      LET tm.more = 'N'
      LET g_pdate  = g_today
      LET g_bgjob  = 'N'
      LET g_copies = '1'
      IF tm.d = '1' THEN LET g_unit = 1 END IF
      IF tm.d = '2' THEN LET g_unit = 1000 END IF
      IF tm.d = '3' THEN LET g_unit = 1000000 END IF
   ELSE
      LET g_flag = 'N'
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
   IF g_flag = 'N' THEN
 
      #No.FUN-850030  --Begin
      OPEN WINDOW q940_w AT 5,10                                                   
           WITH FORM "gnm/42f/gnmq940" ATTRIBUTE(STYLE = g_win_style)              
                                                                                
      CALL cl_ui_init() 
 
      IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
         THEN CALL q940_tm()         # Input print condition
         ELSE CALL q940()            # Read data and create out-file
      END IF
 
      CALL q940_menu()                                                             
      CLOSE WINDOW q940_w                                                          
      #No.FUN-850030  --End  
   ELSE
      CALL q940()                    # Read data and create out-file
   END IF
   #No.FUN-640004 --end--
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211

END MAIN
 
FUNCTION q940_menu()
   WHILE TRUE
      CALL q940_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q940_tm()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q940_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0021
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nml),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q940_tm()
   DEFINE p_row,p_col    LIKE type_file.num5,     #NO FUN-680145 SMALLINT
          l_sw           LIKE type_file.chr1,     # Prog. Version..: '5.30.06-13.03.12(01)  #重要欄位是否空白
          l_cmd          LIKE type_file.chr1000   #NO FUN-680145 VARCHAR(400)
 
   LET p_row = 4 LET p_col = 12
   OPEN WINDOW q940_w1 AT p_row,p_col WITH FORM "gnm/42f/gnmr940"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)                                            #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   SELECT aaa03 INTO tm.r FROM aaa_file WHERE aaa01 = g_nmz.nmz02b
   LET tm.title = g_x[1]
   LET tm.c = 'Y'
   LET tm.d = '1'
   LET tm.o = 'N'
   LET tm.p = tm.r
   LET tm.q = 1
   LET tm.more = 'N'
   LET g_pdate  = g_today
   LET g_bgjob  = 'N'
   LET g_copies = '1'
   LET g_rlang = g_lang   #No.MOD-6C0171 因為抓不到語言別，所以取不到zaa里維護的數據
 
WHILE TRUE
 INPUT BY NAME tm.title,tm.y1,tm.m1,tm.m2,
                  tm.d,tm.c,tm.o,tm.r,tm.p,tm.q,tm.more
                  WITHOUT DEFAULTS
 
      ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
 
      BEFORE INPUT
         CALL q940_set_entry(p_cmd)
         CALL q940_set_no_entry(p_cmd)
         #No.FUN-580031 --start--
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      AFTER FIELD y1
         IF NOT cl_null(tm.y1) THEN
            IF tm.y1 = 0 THEN
               NEXT FIELD y1
            END IF
            LET tm.y2=tm.y1
            LET g_yy2 = tm.y1 -1   #No.FUN-850030
         END IF
 
      AFTER FIELD m1
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.m1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.y1
            IF g_azm.azm02 = 1 THEN
               IF tm.m1 > 12 OR tm.m1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1
               END IF
            ELSE
               IF tm.m1 > 13 OR tm.m1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1
               END IF
            END IF
         END IF
#         IF tm.m1 <1 OR tm.m1 > 13 THEN
#            CALL cl_err('','agl-013',0) NEXT FIELD m1
#         END IF
#No.TQC-720032 -- end -- 
 
      AFTER FIELD m2
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.m2) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.y1
            IF g_azm.azm02 = 1 THEN
               IF tm.m2 > 12 OR tm.m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            ELSE
               IF tm.m2 > 13 OR tm.m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            END IF
         END IF
#         IF tm.m2 <1 OR tm.m2 > 13 THEN
#            CALL cl_err('','anm-013',0) NEXT FIELD m2
#         END IF
#No.TQC-720032 -- end --
         IF tm.y1*13+tm.m1 > tm.y2*13+tm.m2 THEN
            CALL cl_err('','9011',0) NEXT FIELD m1
         END IF
 
      BEFORE FIELD o
         CALL q940_set_entry(p_cmd)
 
      AFTER FIELD o
         IF tm.o IS NOT NULL THEN
            IF tm.o = 'N' THEN
               LET tm.q = 1
               LET tm.p = tm.r
               DISPLAY BY NAME tm.q,tm.p
            END IF
         END IF
         CALL q940_set_no_entry(p_cmd)
 
      AFTER FIELD p
         SELECT azi01 FROM azi_file WHERE azi01 = tm.p
         IF SQLCA.sqlcode THEN 
#           CALL cl_err(tm.p,'mfg3008',0)   #No.FUN-660146
            CALL cl_err3("sel","azi_file",tm.p,"","mfg3008","","",0)    #No.FUN-660146
            NEXT FIELD p 
         END IF
 
      AFTER FIELD q
         IF tm.q <= 0 THEN
            NEXT FIELD q
         END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
         IF tm.d = '1' THEN LET g_unit = 1 END IF
         IF tm.d = '2' THEN LET g_unit = 1000 END IF
         IF tm.d = '3' THEN LET g_unit = 1000000 END IF
         IF tm.o = 'N' THEN
            LET tm.q = 1
            LET tm.p = tm.r
         END IF
      ON ACTION CONTROLG 
         CALL cl_cmdask()    # Command execution
      ON ACTION CONTROLT 
         LET g_trace = 'Y'    # Trace on
      ON ACTION CONTROLP
         CASE
                 WHEN INFIELD(p)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azi"
                 LET g_qryparam.default1 = tm.p
                   CALL cl_create_qry() RETURNING tm.p
                   DISPLAY tm.p TO p
            NEXT FIELD p
         END CASE
 
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
      ON ACTION qbe_select
         CALL cl_qbe_select()
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
 
   END INPUT
  #-----TQC-610056---------
  IF g_bgjob = 'Y' THEN
     SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
            WHERE zz01='gnmq940'
     IF SQLCA.sqlcode OR l_cmd IS NULL THEN
        CALL cl_err('gnmq940','9031',1)
     ELSE
        LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                     " '",g_bookno CLIPPED,"'" ,
                     " '",g_pdate CLIPPED,"'",
                     " '",g_towhom CLIPPED,"'",
                     #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                     " '",g_bgjob CLIPPED,"'",
                     " '",g_prtway CLIPPED,"'",
                     " '",g_copies CLIPPED,"'",
                     " '",tm.title CLIPPED,"'",
                     " '",tm.y1 CLIPPED,"'",
                     " '",tm.y2 CLIPPED,"'",
                     " '",tm.m1 CLIPPED,"'",
                     " '",tm.m2 CLIPPED,"'",
                     " '",tm.c CLIPPED,"'",
                     " '",tm.d CLIPPED,"'",
                     " '",tm.o CLIPPED,"'",
                     " '",tm.r CLIPPED,"'",
                     " '",tm.p CLIPPED,"'",
                     " '",tm.q CLIPPED,"'",
                     " '",g_rep_user CLIPPED,"'",
                     " '",g_rep_clas CLIPPED,"'",
                     " '",g_template CLIPPED,"'"
         CALL cl_cmdat('gnmq940',g_time,l_cmd)    # Execute cmd at later time #
     END IF
     CLOSE WINDOW q940_w1
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
     EXIT PROGRAM
  END IF
  #-----END TQC-610056-----
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW q940_w1
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL q940()
   ERROR ""
   EXIT WHILE     #No.FUN-850030
END WHILE
   CLOSE WINDOW q940_w1
END FUNCTION
 
FUNCTION q940()
     DEFINE l_name    LIKE type_file.chr20    #NO FUN-680145 VARCHAR(20)       # External(Disk) file name
#     DEFINE     l_time LIKE type_file.chr8        #No.FUN-6A0098
     DEFINE l_chr     LIKE type_file.chr1     #NO FUN-680145 VARCHAR(1)
     DEFINE l_sql     LIKE type_file.chr1000  #NO FUN-680145 VARCHAR(1000)     # RDSQL STATEMENT
     DEFINE l_bdate,l_edate    LIKE type_file.dat        #NO FUN-680145 DATE
     DEFINE sr        RECORD
                      chr      LIKE type_file.chr1,      #NO FUN-680145 VARCHAR(01)
                      type     LIKE type_file.chr1,      #NO FUN-680145 VARCHAR(01)
                      nml01    LIKE nml_file.nml01,
                      nml02    LIKE nml_file.nml02,
                      nml03    LIKE nml_file.nml03,
                      amt      LIKE nme_file.nme08
                      END RECORD
     #No.FUN-640004 --start--
     DEFINE sr1       RECORD
                      chr      LIKE type_file.chr1,      #NO FUN-680145 VARCHAR(01)  
                      type     LIKE type_file.chr1,      #NO FUN-680145 VARCHAR(01)
                      nml01    LIKE nml_file.nml01,
                      nml02    LIKE nml_file.nml02,
                      nml03    LIKE nml_file.nml03,
                      amt      LIKE nme_file.nme08
                      END RECORD,
     #No.FUN-640004 --end--
     #No.FUN-720013 --start---
                      l_type  LIKE type_file.chr1,
                      l_item1 LIKE nml_file.nml02,
                      l_amt1  LIKE nme_file.nme08,
                      l_azi04 LIKE azi_file.azi04,
                      l_cnt   LIKE type_file.num5
     #No.FUN-720013 --END --
     DEFINE l_nme08b  LIKE nme_file.nme08   #No.FUN-850030
     DEFINE l_i       LIKE type_file.num10  #No.FUN-850030
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0098
 
     LET g_prog = 'gnmr940'   #No.FUN-850030
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
     CALL s_azn01(tm.y1,tm.m1) RETURNING bdate,l_edate
     CALL s_azn01(tm.y1,tm.m2) RETURNING l_bdate,edate
 
     #No.FUN-850030  --Begin
     CALL s_azn01(g_yy2,tm.m1) RETURNING bdate1,l_edate
     CALL s_azn01(g_yy2,tm.m2) RETURNING l_bdate,edate1
     #No.FUN-850030  --End  
 
     SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = tm.r   #No.CHI-6A0004
     IF tm.d != '1' THEN LET t_azi04 = 0 END IF                   #No.CHI-6A0004
 
    #No.FUN-850030  --Begin  #用LEFT OUTER JOIN 方式
    ##No.FUN-710056  --Begin                                                     
    #IF g_flag = 'N' THEN                                                        
    #   LET l_sql = "SELECT '1','',nml01,nml02,nml03,SUM(nme08) ",               
    #               "  FROM nml_file,OUTER nme_file ",                           
    #               " WHERE nml01 = nme14 ",                                     
    #               "   AND nmlacti = 'Y' AND nmeacti = 'Y' ",                   
    #               "   AND nme16 BETWEEN '",bdate,"' AND '",edate,"'",          
    #               "   AND nme03 IN (SELECT nmc01 FROM nmc_file ",              
    #               "                  WHERE nmc03 = '1' and nmcacti='Y') ",     
    #               " GROUP BY 1,2,3,4,5 ",                                      
    #               " UNION ALL ",                                               
    #               "SELECT '2','',nml01,nml02,nml03,SUM(nme08) ",               
    #               "  FROM nml_file,OUTER nme_file ",                           
    #               " WHERE nml01 = nme14 ",                                     
    #               "   AND nmlacti = 'Y' AND nmeacti = 'Y' ",                   
    #               "   AND nme16 BETWEEN '",bdate,"' AND '",edate,"'",          
    #               "   AND nme03 IN (SELECT nmc01 FROM nmc_file ",              
    #               "                  WHERE nmc03 = '2' and nmcacti='Y') ",     
    #               " GROUP BY 1,2,3,4,5 ",                                      
    #               " ORDER BY nml03,nml01"                                      
    #ELSE                                                                        
       LET l_sql = "SELECT '1','',nml01,nml02,nml03,SUM(nme08) ",               
                   "  FROM nml_file LEFT OUTER JOIN nme_file ",
                   "    ON (nml01 = nme14 AND nmeacti = 'Y' ",                  
                   "   AND nme16 BETWEEN '",bdate,"' AND '",edate,"'",          
                   "   AND nme03 IN (SELECT nmc01 FROM nmc_file ",              
                   "                  WHERE nmc03 = '1' and nmcacti='Y')) ",    
                   " WHERE nmlacti = 'Y' ",                                     
                  #" GROUP BY '1','',nml01,nml02,nml03 ",   #TQC-940068                                                             
                   " GROUP BY nml01,nml02,nml03 ",          #TQC-940068                      
                   " UNION ALL ",                                               
                   "SELECT '2','',nml01,nml02,nml03,SUM(nme08) ",               
                   "  FROM nml_file LEFT OUTER JOIN nme_file ",                 
                   "    ON (nml01 = nme14 AND nmeacti = 'Y' ",                  
                   "   AND nme16 BETWEEN '",bdate,"' AND '",edate,"'",          
                   "   AND nme03 IN (SELECT nmc01 FROM nmc_file ",              
                   "                  WHERE nmc03 = '2' and nmcacti='Y')) ",    
                   " WHERE nmlacti = 'Y' ",                                     
                  #" GROUP BY '2','',nml01,nml02,nml03 ",   #TQC-940068                                                              
                   " GROUP BY nml01,nml02,nml03 ",          #TQC-940068                      
                   " ORDER BY nml03,nml01"                                      
    #END IF                                                                      
    ##No.FUN-710056  --End   
    #No.FUN-850030  --End
     PREPARE gnmq940_prepare FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
     DECLARE gnmq940_curs CURSOR FOR gnmq940_prepare
 
     #No.FUN-640004 --start--
     IF g_flag = 'Y' THEN
        LET l_name = g_name
        DECLARE q940_r2 CURSOR FOR
           SELECT zaa02,zaa08
             FROM zaa_file 
            WHERE zaa01 = g_prog
              AND zaa03 = g_lang
              AND ((zaa04='default' AND zaa17='default') 
                  OR zaa04=g_user OR zaa17 = g_clas)
              AND zaa10 = 'N'
        FOREACH q940_r2 INTO l_zaa02,l_zaa08
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           LET g_x[l_zaa02] = l_zaa08
        END FOREACH
        CALL cl_outnam('gnmr940') RETURNING l_name
        LET l_name = tm.title  #No.FUN-710056 
        START REPORT q940_rep1 TO l_name
     ELSE
        CALL cl_outnam('gnmr940') RETURNING l_name
        LET l_name = tm.title  #No.FUN-710056 
        START REPORT q940_rep TO l_name
        #No.FUN-850030  --Begin
        LET g_rec_b = 1
        CALL g_pr_ar.clear()
        CALL g_nml.clear()
        #No.FUN-850030  --End
     END IF
     #No.FUN-640004 --end--
 
     LET g_pageno = 0
     FOREACH gnmq940_curs INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        LET sr.type = sr.nml03[1,1]
        #No.FUN-640004 --start--
        IF g_flag = 'Y' THEN
           LET sr1.* = sr.*
           OUTPUT TO REPORT q940_rep1(sr1.*)
        ELSE
           #No.FUN-850030  --Begin
           SELECT SUM(nme08) INTO l_nme08b
             FROM nme_file
            WHERE nme14 = sr.nml01
              AND nmeacti = 'Y'
              AND nme16 BETWEEN bdate1 AND edate1
              AND nme03 IN (SELECT nmc01 FROM nmc_file
                             WHERE nmc03 = sr.chr and nmcacti='Y')
           IF cl_null(sr.amt) THEN LET sr.amt = 0 END IF
           IF cl_null(l_nme08b) THEN LET l_nme08b = 0 END IF
           IF tm.c = 'N' THEN
              #若一大類中沒有出現任何金額,則大類也可以被不打印出來
              IF sr.amt = 0 AND l_nme08b = 0 THEN
                 CONTINUE FOREACH
              END IF 
           END IF
           OUTPUT TO REPORT q940_rep(sr.*,l_nme08b)
           #No.FUN-850030  --End  
        END IF
        #No.FUN-640004 --end--
     END FOREACH
 
 
     #No.FUN-640004 --start--
     IF g_flag = 'Y' THEN
        FINISH REPORT q940_rep1
     ELSE
        FINISH REPORT q940_rep
        FOR l_i = 1 TO g_rec_b
            LET g_nml[l_i].nml02 = g_pr_ar[l_i].nml02 
            LET g_nml[l_i].nml05 = g_pr_ar[l_i].nml05 
            LET g_nml[l_i].nme08a= g_pr_ar[l_i].nme08a
            LET g_nml[l_i].nme08b= g_pr_ar[l_i].nme08b
        END FOR
        #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     END IF
     #No.FUN-640004 --end--
 
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0098
END FUNCTION
 
REPORT q940_rep(sr)  #No.FUN-850030
   DEFINE l_last_sw   LIKE type_file.chr1      #NO FUN-680145 VARCHAR(01)
   DEFINE l_amt       LIKE nme_file.nme08
   DEFINE l_amt2      LIKE nme_file.nme08
   DEFINE l_cash      LIKE nme_file.nme08
   DEFINE cash_in     LIKE nme_file.nme08
   DEFINE cash_out    LIKE nme_file.nme08
   DEFINE l_count     LIKE nme_file.nme08
   DEFINE l_count_in  LIKE nme_file.nme08
   DEFINE l_count_out LIKE nme_file.nme08
   #No.FUN-850030  --Begin
   DEFINE l_amt1       LIKE nme_file.nme08
   DEFINE l_amt21      LIKE nme_file.nme08
   DEFINE l_cash1      LIKE nme_file.nme08
   DEFINE cash_in1     LIKE nme_file.nme08
   DEFINE cash_out1    LIKE nme_file.nme08
   DEFINE l_count1     LIKE nme_file.nme08
   #No.FUN-850030  --End  
   DEFINE l_unit      LIKE type_file.chr4      #NO FUN-680145 VARCHAR(04)
   DEFINE l_x         LIKE type_file.num5      #NO FUN-680145 SMALLINT
   DEFINE l_tmpstr    LIKE nml_file.nml02      #No.FUN-720013
   DEFINE sr          RECORD
                      chr      LIKE type_file.chr1,    #NO FUN-680145 VARCHAR(01)
                      type     LIKE type_file.chr1,    #NO FUN-680145 VARCHAR(01)
                      nml01    LIKE nml_file.nml01,
                      nml02    LIKE nml_file.nml02,
                      nml03    LIKE nml_file.nml03,
                      amt      LIKE nme_file.nme08,
                      amt1     LIKE nme_file.nme08     #No.FUN-850030
                      END RECORD
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.type,sr.nml03,sr.nml01,sr.chr
  FORMAT
   PAGE HEADER
      #報表結構,報表名稱,幣別,單位
      CASE tm.d
           WHEN '1'  LET l_unit = g_x[19]
           WHEN '2'  LET l_unit = g_x[20]
           WHEN '3'  LET l_unit = g_x[21]
           OTHERWISE LET l_unit = ' '
      END CASE
      LET g_pageno = g_pageno + 1
      IF g_pageno = 1 THEN
         LET l_count  = 0
         LET cash_in  = 0
         LET cash_out = 0
         #No.FUN-850030  --Begin
         LET l_count1 = 0
         LET cash_in1 = 0
         LET cash_out1= 0
         #No.FUN-850030  --End  
      END IF
 
   BEFORE GROUP OF sr.type
      CASE sr.type
        WHEN '1' 
                 INITIALIZE g_pr_ar[g_rec_b].* TO NULL
                 LET g_pr_ar[g_rec_b].line = g_rec_b
                 LET g_pr_ar[g_rec_b].nml02 = g_x[9]
                 LET g_rec_b = g_rec_b + 1
        WHEN '2' 
                 INITIALIZE g_pr_ar[g_rec_b].* TO NULL
                 LET g_pr_ar[g_rec_b].line = g_rec_b
                 LET g_pr_ar[g_rec_b].nml02 = g_x[11]
                 LET g_rec_b = g_rec_b + 1
        WHEN '3' 
                 INITIALIZE g_pr_ar[g_rec_b].* TO NULL
                 LET g_pr_ar[g_rec_b].line = g_rec_b
                 LET g_pr_ar[g_rec_b].nml02 = g_x[13]
                 LET g_rec_b = g_rec_b + 1
        WHEN '4' 
                 INITIALIZE g_pr_ar[g_rec_b].* TO NULL
                 LET g_pr_ar[g_rec_b].line = g_rec_b
                 LET g_pr_ar[g_rec_b].nml02 = g_x[15]
                 LET g_rec_b = g_rec_b + 1
        OTHERWISE EXIT CASE
      END CASE
 
   AFTER GROUP OF sr.nml01
      LET l_amt  = GROUP SUM(sr.amt) WHERE sr.chr = '1'    #存入
      LET l_amt2 = GROUP SUM(sr.amt) WHERE sr.chr = '2'    #提出
      IF cl_null(l_amt) THEN LET l_amt = 0 END IF
      IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
      LET l_amt1  = GROUP SUM(sr.amt1) WHERE sr.chr = '1'    #存入              
      LET l_amt21 = GROUP SUM(sr.amt1) WHERE sr.chr = '2'    #提出              
      IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF                             
      IF cl_null(l_amt21) THEN LET l_amt21 = 0 END IF
 
      IF sr.nml03[2,2]='0' THEN     #流入
         LET l_amt = l_amt - l_amt2
         LET cash_in = cash_in + l_amt
         LET l_count = l_count + l_amt
         LET l_amt1 = l_amt1 - l_amt21                                          
         LET cash_in1 = cash_in1 + l_amt1                                       
         LET l_count1 = l_count1 + l_amt1
      ELSE                          #流出
         LET l_amt = l_amt2 - l_amt
         LET cash_out = cash_out + l_amt
         LET l_count = l_count - l_amt
         LET l_amt1 = l_amt21 - l_amt1                                          
         LET cash_out1 = cash_out1 + l_amt1                                     
         LET l_count1 = l_count1 - l_amt1
      END IF
      LET l_amt = l_amt * tm.q / g_unit
      LET l_amt1 = l_amt1 * tm.q / g_unit
 
      IF tm.c = 'Y' OR l_amt != 0 OR l_amt1 != 0 THEN
         INITIALIZE g_pr_ar[g_rec_b].* TO NULL
         LET g_pr_ar[g_rec_b].line = g_rec_b
         LET g_pr_ar[g_rec_b].nml02 = 8 SPACES,sr.nml02
         SELECT nml05 INTO g_pr_ar[g_rec_b].nml05 FROM nml_file
          WHERE nml01 = sr.nml01
         LET g_pr_ar[g_rec_b].nme08a = l_amt
         LET g_pr_ar[g_rec_b].nme08b = l_amt1
         LET g_rec_b = g_rec_b + 1
      END IF
 
   AFTER GROUP OF sr.nml03
      IF sr.nml03 <> '40' THEN
         CASE
           WHEN sr.nml03='1' OR sr.nml03='3'
                INITIALIZE g_pr_ar[g_rec_b].* TO NULL
                LET g_pr_ar[g_rec_b].line = g_rec_b
                LET g_pr_ar[g_rec_b].nml02 = 4 SPACES,g_x[18]
           WHEN sr.nml03='2'
                INITIALIZE g_pr_ar[g_rec_b].* TO NULL
                LET g_pr_ar[g_rec_b].line = g_rec_b
                LET g_pr_ar[g_rec_b].nml02 = 4 SPACES,g_x[17]
           OTHERWISE 
                INITIALIZE g_pr_ar[g_rec_b].* TO NULL
                LET g_pr_ar[g_rec_b].line = g_rec_b
                LET g_pr_ar[g_rec_b].nml02 = 4 SPACES,g_x[sr.nml03 MOD 10 + 17]
         END CASE
         IF sr.nml03[2,2] = '0' THEN
             LET cash_in = cash_in * tm.q / g_unit
             LET cash_in1 = cash_in1 * tm.q / g_unit
             LET g_pr_ar[g_rec_b].nme08a = cash_in
             LET g_pr_ar[g_rec_b].nme08b = cash_in1
             LET g_rec_b = g_rec_b + 1
         ELSE
             LET cash_out = cash_out * tm.q / g_unit
             LET cash_out1 = cash_out1 * tm.q / g_unit
             LET g_pr_ar[g_rec_b].nme08a = cash_out
             LET g_pr_ar[g_rec_b].nme08b = cash_out1
             LET g_rec_b = g_rec_b + 1
         END IF
      END IF
 
   AFTER GROUP OF sr.type
      CASE sr.type
        WHEN '1'
             LET l_cash = (cash_in - cash_out) * tm.q / g_unit
             LET l_cash1 = (cash_in1 - cash_out1) * tm.q / g_unit
             INITIALIZE g_pr_ar[g_rec_b].* TO NULL
             LET g_pr_ar[g_rec_b].line = g_rec_b
             LET g_pr_ar[g_rec_b].nml02 = g_x[10]
             LET g_pr_ar[g_rec_b].nme08a= l_cash
             LET g_pr_ar[g_rec_b].nme08b= l_cash1
             LET g_rec_b = g_rec_b + 1
             LET cash_in = 0
             LET cash_out = 0
             LET cash_in1= 0
             LET cash_out1= 0
        WHEN '2'
             LET l_cash = (cash_in - cash_out) * tm.q / g_unit
             LET l_cash1 = (cash_in1 - cash_out1) * tm.q / g_unit
             INITIALIZE g_pr_ar[g_rec_b].* TO NULL
             LET g_pr_ar[g_rec_b].line = g_rec_b
             LET g_pr_ar[g_rec_b].nml02 = g_x[12]
             LET g_pr_ar[g_rec_b].nme08a= l_cash
             LET g_pr_ar[g_rec_b].nme08b= l_cash1
             LET g_rec_b = g_rec_b + 1
             LET cash_in = 0
             LET cash_out = 0
             LET cash_in1= 0
             LET cash_out1= 0
        WHEN '3'
             LET l_cash = (cash_in - cash_out) * tm.q / g_unit
             LET l_cash1 = (cash_in1 - cash_out1) * tm.q / g_unit
             INITIALIZE g_pr_ar[g_rec_b].* TO NULL
             LET g_pr_ar[g_rec_b].line = g_rec_b
             LET g_pr_ar[g_rec_b].nml02 = g_x[14]
             LET g_pr_ar[g_rec_b].nme08a= l_cash
             LET g_pr_ar[g_rec_b].nme08b= l_cash1
             LET g_rec_b = g_rec_b + 1
             LET cash_in = 0
             LET cash_out = 0
             LET cash_in1= 0
             LET cash_out1= 0
        OTHERWISE EXIT CASE
      END CASE
 
   ON LAST ROW
      LET l_count = l_count * tm.q / g_unit
      LET l_count1 = l_count1 * tm.q / g_unit
      INITIALIZE g_pr_ar[g_rec_b].* TO NULL
      LET g_pr_ar[g_rec_b].line = g_rec_b
      LET g_pr_ar[g_rec_b].nml02 = g_x[16]
      LET g_pr_ar[g_rec_b].nme08a= l_count
      LET g_pr_ar[g_rec_b].nme08b= l_count1
 
END REPORT
 
FUNCTION q940_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1     #NO FUN-680145 VARCHAR(01)
 
    CALL cl_set_comp_entry("p,q",TRUE)
 
END FUNCTION
 
FUNCTION q940_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1     #NO FUN-680145 VARCHAR(01)
 
    IF tm.o = 'N' THEN
       CALL cl_set_comp_entry("p,q",FALSE)
    END IF
 
END FUNCTION
 
#Patch....NO.TQC-610037 <> #
#No.FUN-640004 --start--
REPORT q940_rep1(sr1)
   DEFINE l_amt1       LIKE nme_file.nme08
   DEFINE l_amt21      LIKE nme_file.nme08
   DEFINE l_cash1      LIKE nme_file.nme08
   DEFINE cash_in1     LIKE nme_file.nme08
   DEFINE cash_out1    LIKE nme_file.nme08
   DEFINE l_count1     LIKE nme_file.nme08
   DEFINE l_count_in1  LIKE nme_file.nme08
   DEFINE l_count_out1 LIKE nme_file.nme08
   DEFINE l_unit1      LIKE type_file.chr4     #NO FUN-680145 VARCHAR(04)
   DEFINE l_nml05      LIKE nml_file.nml05     #行次
   DEFINE l_sharp      LIKE type_file.num5     #NO FUN-680145 SMALLINT
   DEFINE i            LIKE type_file.num5     #NO FUN-680145 SMALLINT
   DEFINE l_n          LIKE type_file.num5     #NO FUN-680145 SMALLINT
   DEFINE sr1          RECORD
                       chr      LIKE type_file.chr1,    #NO FUN-680145 VARCHAR(01)
                       type     LIKE type_file.chr1,    #NO FUN-680145 VARCHAR(01)
                       nml01    LIKE nml_file.nml01,
                       nml02    LIKE nml_file.nml02,
                       nml03    LIKE nml_file.nml03,
                       amt      LIKE nme_file.nme08
                       END RECORD
 
   OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
   ORDER BY sr1.type,sr1.nml03,sr1.nml01,sr1.chr
   FORMAT
      PAGE HEADER
         #報表結構,報表名稱,幣別,單位
         CASE tm.d
            WHEN '1'  LET l_unit1 = g_x[19]
            WHEN '2'  LET l_unit1 = g_x[20]
            WHEN '3'  LET l_unit1 = g_x[21]
            OTHERWISE LET l_unit1 = ' '
         END CASE
         LET g_pageno = g_pageno + 1
         IF g_pageno = 1 THEN
            LET l_count1 = 0
            LET cash_in1 = 0
            LET cash_out1= 0
         END IF
         LET t_azi04 = 2    #取兩位小數   #No.CHI-6A0004
         LET g_x[9]  = g_x[26]
         LET g_x[11] = g_x[27]
         LET g_x[13] = g_x[28]
         LET g_x[15] = g_x[29]
         LET g_x[16] = g_x[30]
         LET g_x[10] = g_x[33]
         LET g_x[12] = g_x[34]
         LET g_x[14] = g_x[35]
 
      BEFORE GROUP OF sr1.type
         CASE sr1.type
            WHEN '1' 
               PRINT '\"',g_x[5] CLIPPED,'\"',                    #報表編號
                     '\t',
                     '\"',g_company CLIPPED,'\"',  #編制單位
                     '\t',
                     '\"',g_ym CLIPPED,'\"',       #報告期
                     '\t',
                     '\"',l_unit1 CLIPPED,'\"',     #貨幣單位
                     '\t',
                     '\"',g_x[9] CLIPPED,'\"',    #項目
                     '\t','\t'
            WHEN '2'
               PRINT '\"',g_x[5] CLIPPED,'\"',                    #報表編號
                     '\t',
                     '\"',g_company CLIPPED,'\"',  #編制單位
                     '\t',
                     '\"',g_ym CLIPPED,'\"',       #報告期
                     '\t',
                     '\"',l_unit1 CLIPPED,'\"',     #貨幣單位
                     '\t',
                     '\"',g_x[11] CLIPPED,'\"',   #項目
                     '\t','\t'
            WHEN '3'
               PRINT '\"',g_x[5] CLIPPED,'\"',                    #報表編號
                     '\t',
                     '\"',g_company CLIPPED,'\"',  #編制單位
                     '\t',
                     '\"',g_ym CLIPPED,'\"',       #報告期
                     '\t',
                     '\"',l_unit1 CLIPPED,'\"',     #貨幣單位
                     '\t',
                     '\"',g_x[13] CLIPPED,'\"',   #項目
                     '\t','\t'
#           WHEN '4' 
#              PRINT '\"',g_x[15] CLIPPED,'\"';   #項目
#           OTHERWISE PRINT '';
         END CASE
 
   AFTER GROUP OF sr1.nml01
      LET l_amt1  = GROUP SUM(sr1.amt) WHERE sr1.chr = '1'    #存入
      LET l_amt21 = GROUP SUM(sr1.amt) WHERE sr1.chr = '2'    #提出
      SELECT nml05 INTO l_nml05 FROM nml_file WHERE nml01 = sr1.nml01
      IF NOT cl_null(l_nml05) THEN
         LET l_sharp = FGL_WIDTH(l_nml05)
      END IF
      IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
      IF cl_null(l_amt21) THEN LET l_amt21 = 0 END IF
      IF sr1.nml03[2,2]='0' THEN     #流入
         LET l_amt1 = l_amt1 - l_amt21
         LET cash_in1 = cash_in1 + l_amt1
#        LET l_count1 = l_count1 + l_amt1
      ELSE                          #流出
         LET l_amt1 = l_amt21 - l_amt1
         LET cash_out1 = cash_out1 + l_amt1
#        LET l_count1 = l_count1 - l_amt1
      END IF
      LET l_amt1 = l_amt1 * tm.q / g_unit
      IF tm.c = 'Y' OR sr1.amt != 0 THEN
         PRINT '\"',g_x[5] CLIPPED,'\"',                    #報表編號
               '\t',
               '\"',g_company CLIPPED,'\"',  #編制單位
               '\t',
               '\"',g_ym CLIPPED,'\"',       #報告期
               '\t',
               '\"',l_unit1 CLIPPED,'\"',     #貨幣單位
               '\t',
               '\"',sr1.nml02 CLIPPED,'\"',   #項目
               '\t';
         IF cl_null(l_nml05) THEN
            PRINT '\"','\"';                     #行次
         ELSE
            CASE l_sharp
               WHEN "1"
                  PRINT '\"',l_nml05 USING '#','\"';  #行次
               WHEN "2"
                  PRINT '\"',l_nml05 USING '##','\"';  #行次
               WHEN "3"
                  PRINT '\"',l_nml05 USING '###','\"';  #行次
               WHEN "4"
                  PRINT '\"',l_nml05 USING '####','\"';  #行次
               WHEN "5"
                  PRINT '\"',l_nml05 USING '#####','\"';  #行次
               OTHERWISE 
                  PRINT ;
            END CASE
         END IF
         PRINT '\t',
               q940_numfor(l_amt1,t_azi04)  #No.CHI-6A0004
      END IF
 
   AFTER GROUP OF sr1.nml03
      IF sr1.nml03 <> '40' THEN
         SELECT MAX(nml05) +1 INTO l_n 
           FROM nml_file
          WHERE nml03 = sr1.nml03
      IF sr1.nml03 = '11' THEN
         LET l_n = l_n + 1
      END IF
      IF NOT cl_null(l_n) THEN
         LET l_sharp = FGL_WIDTH(l_n)
      END IF
      PRINT '\"',g_x[5] CLIPPED,'\"',                    #報表編號
            '\t',
            '\"',g_company CLIPPED,'\"',  #編制單位
            '\t',
            '\"',g_ym CLIPPED,'\"',       #報告期
            '\t',
            '\"',l_unit1 CLIPPED,'\"',     #貨幣單位
            '\t',
            '\"',g_x[sr1.nml03 MOD 10 + 17] CLIPPED,'\"',     #項目
            '\t';
      CASE l_sharp
         WHEN "1"
            PRINT '\"',l_n USING '#','\"';  #行次
         WHEN "2"
            PRINT '\"',l_n USING '##','\"';  #行次
         WHEN "3"
            PRINT '\"',l_n USING '###','\"';  #行次
         WHEN "4"
            PRINT '\"',l_n USING '####','\"';  #行次
         WHEN "5"
            PRINT '\"',l_n USING '#####','\"';  #行次
         OTHERWISE 
            PRINT ;
      END CASE
      PRINT '\t';
          IF sr1.nml03[2,2] = '0' THEN
              LET cash_in1 = cash_in1 * tm.q / g_unit
              PRINT q940_numfor(cash_in1,t_azi04)   #No.CHI-6A0004
          ELSE
              LET cash_out1 = cash_out1 * tm.q / g_unit
              PRINT q940_numfor(cash_out1,t_azi04)    #No.CHI-6A0004
          END IF
      END IF
 
   AFTER GROUP OF sr1.type
      SELECT MAX(nml05) + 2 INTO l_n
        FROM nml_file
       WHERE nml03[1,1] = sr1.type
      IF sr1.nml03 = '11' THEN
         LET l_n = l_n + 1
      END IF
      IF NOT cl_null(l_n) THEN
         LET l_sharp = FGL_WIDTH(l_n)
      END IF
      CASE sr1.type
         WHEN '1'
            LET l_cash1 = (cash_in1 - cash_out1) * tm.q / g_unit
            PRINT '\"',g_x[5] CLIPPED,'\"',                    #報表編號
                        '\t',
                  '\"',g_company CLIPPED,'\"',  #編制單位
                  '\t',
                  '\"',g_ym CLIPPED,'\"',       #報告期
                  '\t',
                  '\"',l_unit1 CLIPPED,'\"',     #貨幣單位
                  '\t',
                  '\"',g_x[10] CLIPPED,'\"',     #項目
                  '\t';
            CASE l_sharp
               WHEN "1"
                  PRINT '\"',l_n USING '#','\"';  #行次
               WHEN "2"
                  PRINT '\"',l_n USING '##','\"';  #行次
               WHEN "3"
                  PRINT '\"',l_n USING '###','\"';  #行次
               WHEN "4"
                  PRINT '\"',l_n USING '####','\"';  #行次
               WHEN "5"
                  PRINT '\"',l_n USING '#####','\"';  #行次
               OTHERWISE 
                  PRINT ;
            END CASE
            PRINT '\t',
                  q940_numfor(l_cash1,t_azi04)    #No.CHI-6A0004
            LET cash_in1 = 0
            LET cash_out1 = 0
            LET l_count1 = l_count1 + l_cash1
         WHEN '2'
            LET l_cash1 = (cash_in1 - cash_out1) * tm.q / g_unit
            PRINT '\"',g_x[5] CLIPPED,'\"',                    #報表編號
                        '\t',
                  '\"',g_company CLIPPED,'\"',  #編制單位
                  '\t',
                  '\"',g_ym CLIPPED,'\"',       #報告期
                  '\t',
                  '\"',l_unit1 CLIPPED,'\"',     #貨幣單位
                  '\t';
            PRINT '\"',g_x[12] CLIPPED,'\"',     #項目
                  '\t';
#                 '\"','\"',                     #行次
            CASE l_sharp
               WHEN "1"
                  PRINT '\"',l_n USING '#','\"';  #行次
               WHEN "2"
                  PRINT '\"',l_n USING '##','\"';  #行次
               WHEN "3"
                  PRINT '\"',l_n USING '###','\"';  #行次
               WHEN "4"
                  PRINT '\"',l_n USING '####','\"';  #行次
               WHEN "5"
                  PRINT '\"',l_n USING '#####','\"';  #行次
               OTHERWISE 
                  PRINT ;
            END CASE
            PRINT '\t',
                  q940_numfor(l_cash1,t_azi04)    #No.CHI-6A0004
            LET cash_in1 = 0
            LET cash_out1 = 0
            LET l_count1 = l_count1 + l_cash1
         WHEN '3'
            LET l_cash1 = (cash_in1 - cash_out1) * tm.q / g_unit
            PRINT '\"',g_x[5] CLIPPED,'\"',                    #報表編號
                        '\t',
                  '\"',g_company CLIPPED,'\"',  #編制單位
                  '\t',
                  '\"',g_ym CLIPPED,'\"',       #報告期
                  '\t',
                  '\"',l_unit1 CLIPPED,'\"',     #貨幣單位
                  '\t';
            PRINT '\"',g_x[14] CLIPPED,'\"',     #項目
                  '\t';
#                 '\"','\"',                     #行次
            CASE l_sharp
               WHEN "1"
                  PRINT '\"',l_n USING '#','\"';  #行次
               WHEN "2"
                  PRINT '\"',l_n USING '##','\"';  #行次
               WHEN "3"
                  PRINT '\"',l_n USING '###','\"';  #行次
               WHEN "4"
                  PRINT '\"',l_n USING '####','\"';  #行次
               WHEN "5"
                  PRINT '\"',l_n USING '#####','\"';  #行次
               OTHERWISE 
                  PRINT ;
            END CASE
            PRINT '\t',
                  q940_numfor(l_cash1,t_azi04)  #No.CHI-6A0004
            LET cash_in1 = 0
            LET cash_out1 = 0
            LET l_count1 = l_count1 + l_cash1
#        OTHERWISE PRINT
      END CASE
 
   ON LAST ROW
      SELECT MAX(nml05)+1 INTO l_n FROM nml_file  #尋求最大行次
      LET l_count1 = l_count1 * tm.q / g_unit
      IF NOT cl_null(l_n) THEN
         LET l_sharp = FGL_WIDTH(l_n)
      END IF
         PRINT '\"',g_x[5] CLIPPED,'\"',     #報表編號
               '\t',
               '\"',g_company CLIPPED,'\"',  #編制單位
               '\t',
               '\"',g_ym CLIPPED,'\"',       #報告期
               '\t',
               '\"',l_unit1 CLIPPED,'\"',     #貨幣單位
               '\t',
               '\"',g_x[16] CLIPPED,'\"',     #項目
               '\t';
         CASE l_sharp
            WHEN "1"
               PRINT '\"',l_n USING '#','\"';  #行次
            WHEN "2"
               PRINT '\"',l_n USING '##','\"';  #行次
            WHEN "3"
               PRINT '\"',l_n USING '###','\"';  #行次
            WHEN "4"
               PRINT '\"',l_n USING '####','\"';  #行次
            WHEN "5"
               PRINT '\"',l_n USING '#####','\"';  #行次
            OTHERWISE 
               PRINT ;
         END CASE
         PRINT '\t',
               q940_numfor(l_count1,t_azi04)   #No.CHI-6A0004
END REPORT
 
FUNCTION q940_numfor(p_value,p_n)
   DEFINE p_value	LIKE type_file.num26_10, #NO FUN-680145 DECIMAL(26,10)
          p_len,p_n     LIKE type_file.num5,     #NO FUN-680145	SMALLINT
          l_len 	LIKE type_file.num5,     #NO FUN-680145 SMALLINT
          l_str		LIKE type_file.chr1000,  #NO FUN-680145 VARCHAR(37)
          l_str1        LIKE type_file.chr1,     #NO FUN-680145 VARCHAR(37)    
          l_length      LIKE type_file.num5,     #NO FUN-680145 SMALLINT
          i,j,k         LIKE type_file.num5      #NO FUN-680145 SMALLINT
     
   LET p_value = cl_digcut(p_value,p_n)
   CASE WHEN p_n = 0  LET l_str = p_value USING '------------------------------------&'
        WHEN p_n = 10 LET l_str = p_value USING '-------------------------&.&&&&&&&&&&'
        WHEN p_n = 9  LET l_str = p_value USING '--------------------------&.&&&&&&&&&'
        WHEN p_n = 8  LET l_str = p_value USING '---------------------------&.&&&&&&&&'
        WHEN p_n = 7  LET l_str = p_value USING '----------------------------&.&&&&&&&'
        WHEN p_n = 6  LET l_str = p_value USING '-----------------------------&.&&&&&&'
        WHEN p_n = 5  LET l_str = p_value USING '------------------------------&.&&&&&'
        WHEN p_n = 4  LET l_str = p_value USING '-------------------------------&.&&&&'
        WHEN p_n = 3  LET l_str = p_value USING '--------------------------------&.&&&'
        WHEN p_n = 2  LET l_str = p_value USING '---------------------------------&.&&'
        WHEN p_n = 1  LET l_str = p_value USING '----------------------------------&.&'
   END CASE
   LET j=37                    #TQC-640038 
#  LET p_len = FGL_WIDTH(p_value)+p_n+1
   LET p_len = FGL_WIDTH(p_value)
   LET i = j - p_len + 9
   IF i < 0 THEN               #FUN-560048
        IF not cl_null(g_xml_rep) THEN
          LET i = 0
        ELSE
          LET i = 1
        END IF
   END IF
 
   LET l_length = 0
   #當傳進的金額位數實際上大於所要求回傳的位數時，該欄位應show"*****" NO:0508
   FOR k = 37 TO 1 STEP -1                        #MOD-590093 #TQC-640038
       LET l_str1 = l_str[k,k]
       IF cl_null(l_str1) THEN EXIT FOR END IF
       LET l_length = l_length + 1
   END FOR
   IF l_length > p_len THEN
      LET i = j - l_length
      IF i < 0 THEN
            RETURN l_str
      END IF
   END IF
   IF not cl_null(g_xml_rep) THEN
      RETURN l_str[i+1,j]
   ELSE 
      RETURN l_str[i,j]
   END IF
END FUNCTION
#No.FUN-640004 --end--
 
FUNCTION q940_bp(p_ud)
DEFINE
    p_ud   LIKE type_file.chr1    #No.FUN-680061 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   DISPLAY tm.p TO FORMONLY.azi01
   DISPLAY tm.y1 TO FORMONLY.yy
   DISPLAY tm.m1 TO FORMONLY.mm1
   DISPLAY tm.m2 TO FORMONLY.mm2
   DISPLAY tm.d  TO FORMONLY.unit
   
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nml TO s_nml.* ATTRIBUTE(COUNT=g_rec_b)
      #BEFORE DISPLAY
      #   CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
      #  LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION close
      LET g_action_choice="exit"
      EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0021
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#No.FUN-850030  --Begin
FUNCTION q940_out()
  DEFINE l_i     LIKE type_file.num10
 
   LET g_prog = 'gnmq940'
 
   LET g_sql = " line.type_file.num10,",
               " nml02.nml_file.nml02,",
               " nml05.nml_file.nml05,",
               " nme08a.nme_file.nme08,",
               " nme08b.nme_file.nme08 "
 
   LET l_table = cl_prt_temptable('gnmq940',g_sql) CLIPPED
   IF l_table = -1 THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM 
   END IF 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,#No.TQC-780054
               " VALUES(?, ?, ?, ?, ?) "
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
   CALL cl_del_data(l_table)
 
   FOR l_i=1 TO g_rec_b
       EXECUTE insert_prep USING g_pr_ar[l_i].*
   END FOR
  
   LET g_str = ''
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = g_str,";",tm.title,";",tm.p,";",tm.d,";",t_azi04
   CALL cl_prt_cs3('gnmq940','gnmq940',g_sql,g_str)
 
END FUNCTION
#No.FUN-850030  --End  
