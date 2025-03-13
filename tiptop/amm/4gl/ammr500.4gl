# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: ammr500.4gl
#
# Descriptions...: 開發案單據追蹤明細表
#
# Date & Author..: 01/01/03 By plum
# Modify.........: No.FUN-550054 05/05/17 By yoyo單據編號格式放大
# Modify.........: No.FUN-570240 05/07/26 By vivien 料件編號欄位增加controlp
# Modify.........: No.FUN-580014 05/08/17 By jackie 轉XML
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: NO.FUN-590118 06/01/04 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-660094 06/06/14 By CZH cl_err-->cl_err3
# Modify.........: No.FUN-680100 06/08/28 By huchenghao 類型轉換
 
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.TQC-6A0079 06/10/30 By king 改正被誤定義為apm08類型的
# Modify.........: No.TQC-6A0080 06/11/20 By xumin 報表標題居中
# Modify.........: No.FUN-750093 07/06/19 By zhoufeng 報表輸出改為Crystal Reports
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No.FUN-B80065 11/08/05 By fengrui  程式撰寫規範修正

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           wc      STRING,                       #No.FUN-680100 # Where Condition  #TQC-630166
           more    LIKE type_file.chr1           #No.FUN-680100 VARCHAR(1)
           END RECORD,
          l_str    LIKE oea_file.oea01,          #No.FUN-680100 VARCHAR(14)
          l_nname  LIKE type_file.chr8,          #No.FUN-680100 VARCHAR(7)   #No.TQC-6A0079
          l_mmb    RECORD LIKE mmb_file.*,
          l_mmf    RECORD LIKE mmf_file.*,
          l_pml    RECORD LIKE pml_file.*,
          l_pmn    RECORD LIKE pmn_file.*,
          l_rvb    RECORD LIKE rvb_file.*,
          l_rvv    RECORD LIKE rvv_file.*,
          l_sfb    RECORD LIKE sfb_file.*,
          l_sfs    RECORD LIKE sfs_file.*,
          l_sfv    RECORD LIKE sfv_file.*,
          l_inb    RECORD LIKE inb_file.*
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680100 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680100 SMALLINT
DEFINE   g_sql           STRING                  #No.FUN-750093
DEFINE   g_str           STRING                  #No.FUN-750093
DEFINE   l_table         STRING                  #No.FUN-750093
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMM")) THEN
      EXIT PROGRAM
   END IF
 
#No.FUN-750093 --start--
   LET g_sql="mmg01.mmg_file.mmg01,mmg02.mmg_file.mmg02,mmg03.mmg_file.mmg03,",
             "mmg04.mmg_file.mmg04,mmg05.mmg_file.mmg05,mmi02.mmi_file.mmi02,",
             "mmg06.mmg_file.mmg06,mmg10.mmg_file.mmg10,mmg09.mmg_file.mmg09,",
             "mmh02.mmh_file.mmh02,mmh03.mmh_file.mmh03,mmh06.mmh_file.mmh06,",
             "mmh12.mmh_file.mmh12,ima08.ima_file.ima08,chr8.type_file.chr8,",
#            "chr20.type_file.chr20,num5.type_file.num5,ima26.ima_file.ima26,",                             #NO.FUN-A20044
             "chr20.type_file.chr20,num5.type_file.num5,avl_stk_mpsmrp.type_file.num15_3,",  #NO.FUN-A20044
             "mmh03_1.mmh_file.mmh03,ze03.ze_file.ze03" #TQC-840066
 
   LET l_table = cl_prt_temptable('ammr500',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#No.FUN-750093 --end--
 
  #io: 順序:mmb:1,mmf:2,pml,sfb:3,pmn,inb:4,rvb,sfs:5,rvv,sfv:6,rvv:7
   DROP TABLE x
 #FUN-680100-BEGIN
   CREATE TEMP TABLE x(
          nog    LIKE mmg_file.mmg01,
          nog1   LIKE mmg_file.mmg02,
          itg    LIKE type_file.num5,  
          io     LIKE type_file.num5,  
          nname  LIKE type_file.chr8,  
          no     LIKE mmg_file.mmg01,
          it     LIKE type_file.num5,  
          qty    LIKE type_file.num15_3)            #NO.FUN-A20044
 #FUN-680100-END     
    
   IF STATUS THEN CALL cl_err('create',STATUS,1) EXIT PROGRAM END IF
   CREATE UNIQUE INDEX r500_01 ON x(nog,nog1,itg,io,no,it);
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80065--add--
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r500_tm(0,0)
      ELSE CALL r500()
   END IF
   DROP TABLE r500_tmp_1
   DROP TABLE r500_tmp_2
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
END MAIN
 
FUNCTION r500_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680100 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000       #No.FUN-680100 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 8 LET p_col = 15
   ELSE LET p_row = 5 LET p_col = 14
   END IF
 
   OPEN WINDOW r500_w AT p_row,p_col
        WITH FORM "amm/42f/ammr500"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON mmg01,mmg03,mmg06,mmh03,mmg02,mmg04,mmg09
 
#No.FUN-570240 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION controlp
         IF INFIELD(mmg04) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO mmg04
            NEXT FIELD mmg04
         END IF
#No.FUN-570240 --end
 
     ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
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
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('mmguser', 'mmggrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r500_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()
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
      CLOSE WINDOW r500_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='ammr500'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('ammr500','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('ammr500',g_time,l_cmd)
      END IF
      CLOSE WINDOW r500_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r500()
   ERROR ""
END WHILE
   CLOSE WINDOW r500_w
END FUNCTION
 
FUNCTION r500()
DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680100 VARCHAR(20)
#       l_time       LIKE type_file.chr8        #No.FUN-6A0076
       l_sql     STRING,           # RDSQL STATEMENT     #TQC-630166        #No.FUN-680100
       l_flag,l_flag1,l_flag2,l_flag3,l_flag4,l_flag5  LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
       l_order   ARRAY[5] OF LIKE type_file.chr20,                                   #No.FUN-680100 VARCHAR(20)
       sr        RECORD
                        mmg       RECORD LIKE mmg_file.*,
                        mmh       RECORD LIKE mmh_file.*,
                        ima08            LIKE ima_file.ima08,    #來源
                        mmi02            LIKE mmi_file.mmi02     #需求類別
                        END RECORD
#No.FUN-750093 --start--
DEFINE sr2       RECORD                                   
                        nog        LIKE mmg_file.mmg01,  
                        nog1       LIKE mmg_file.mmg02,  
                        itg        LIKE type_file.num5,  
                        io         LIKE type_file.num5,  
                        nname      LIKE type_file.chr8,  
                        no         LIKE mmg_file.mmg01,  
                        it         LIKE type_file.num5,  
#                       qty        LIKE ima_file.ima26   
                        qty        LIKE type_file.num15_3    ###GP5.2  #NO.FUN-A20044   
                        END RECORD,                                             
        l_desc                     LIKE ze_file.ze03, #TQC-840066
        l_mmh03                    LIKE mmh_file.mmh03  
 
        LET l_mmh03 =''
#No.FUN-750093
 
     CALL cl_del_data(l_table)                       #No.FUN-750093
 
     #No.FUN-B80065--mark--Begin---
     #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
     #No.FUN-B80065--mark--End-----
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
     LET l_sql = "SELECT mmg_file.*,mmh_file.*,ima08,mmi02 ",
                 "  FROM mmh_file,mmg_file LEFT OUTER JOIN ima_file ON (mmg04 = ima01)  LEFT OUTER JOIN mmi_file ON (mmg05 = mmi01) AND mmi_file.mmi03 ='1' ",
                 
                 " WHERE mmg01 = mmh01 AND mmg02 = mmh011 ",
                 "   AND ", tm.wc CLIPPED,
                 " ORDER BY mmg01,mmg02,mmg03 "
 
     PREPARE r500_pr1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('pr:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
        EXIT PROGRAM
     END IF
     DECLARE r500_cs1 CURSOR FOR r500_pr1
 
    #模具零件需求單mmb_file: mmg01,mmg02,mmh02
   #LET l_sql =" SELECT mmb01,mmb02,mmb18,mmb131,mmb132 FROM mma_file,mmb_file",
    LET l_sql =" SELECT mmb_file.* FROM mma_file,mmb_file",
                "  WHERE mma02 = ? AND mma021=?  AND mma03=? ",
                "    AND mma01=mmb01  "
     PREPARE r500_prmmb FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('pr 2:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
        EXIT PROGRAM
     END IF
     DECLARE r500_csmmb CURSOR FOR r500_prmmb
 
    #加工通知單mmf_file: mmb131,mmb132
    #LET l_sql =" SELECT mmf01,mmf02,mmf10 FROM mmf_file",
     LET l_sql =" SELECT * FROM mmf_file",
                "  WHERE mmf01 = ? AND mmf02=? "
     PREPARE r500_pra FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('pr a:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
        EXIT PROGRAM
     END IF
     DECLARE r500_csmmf CURSOR FOR r500_pra
 
    #請購單pml_file:mmb141
    #LET l_sql =" SELECT pml01,pml02,pml20 FROM pml_file",
     LET l_sql =" SELECT * FROM pml_file",
                "  WHERE pml01 = ?  "
     PREPARE r500_prb FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('pr b:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
        EXIT PROGRAM
     END IF
     DECLARE r500_cspml CURSOR FOR r500_prb
 
    #for: ima08=P,採購單pmn_file:pml01,pml02
    #LET l_sql =" SELECT pmn01,pmn02,pmn20 FROM pmn_file",
     LET l_sql =" SELECT * FROM pmn_file",
                "  WHERE pmn24 = ?  AND pmn25=?  "
     PREPARE r500_prc FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('pr c:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
        EXIT PROGRAM
     END IF
     DECLARE r500_cspmn CURSOR FOR r500_prc
 
    #for: ima08=S,採購單pmn_file:pml01,pml02
    #LET l_sql =" SELECT pmn01,pmn02,pmn20 FROM pmn_file",
     LET l_sql =" SELECT * FROM pmn_file",
                "  WHERE pmn24 = ?  AND pmn25=?  "
     PREPARE r500_prc1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('pr c1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
        EXIT PROGRAM
     END IF
     DECLARE r500_cspmn1 CURSOR FOR r500_prc1
 
    #for: ima08=P,驗收單rvb_file:pmn01,pmn02
    #LET l_sql =" SELECT rvb01,rvb02,rvb07 FROM rvb_file",
     LET l_sql =" SELECT * FROM rvb_file",
                "  WHERE rvb04 = ?  AND rvb03=?  "
     PREPARE r500_prd FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('pr d:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
        EXIT PROGRAM
     END IF
     DECLARE r500_csrvb CURSOR FOR r500_prd
 
    #for: ima08=S,驗收單rvb_file:pmn01,pmn02
    #LET l_sql =" SELECT rvb01,rvb02,rvb07 FROM rvb_file",
     LET l_sql =" SELECT * FROM rvb_file",
                "  WHERE rvb04 = ?  AND rvb03=?  "
     PREPARE r500_prd1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('pr d1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
        EXIT PROGRAM
     END IF
     DECLARE r500_csrvb1 CURSOR FOR r500_prd1
 
    #for: ima08=P,入庫單rvv_file:rvb01,rvb03
    #LET l_sql =" SELECT rvv01,rvv02,rvv17 FROM rvv_file",
     LET l_sql =" SELECT * FROM rvv_file",
                "  WHERE rvv04 = ?  AND rvv05=?  "
     PREPARE r500_pre FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('pr e:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
        EXIT PROGRAM
     END IF
     DECLARE r500_csrvv CURSOR FOR r500_pre
 
    #for: ima08=S,入庫單rvv_file:rvb01,rvb03
    #LET l_sql =" SELECT rvv01,rvv02,rvv17 FROM rvv_file",
     LET l_sql =" SELECT * FROM rvv_file",
                "  WHERE rvv04 = ?  AND rvv05=?  "
     PREPARE r500_pre1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('pr e1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
        EXIT PROGRAM
     END IF
     DECLARE r500_csrvv1 CURSOR FOR r500_pre1
 
    #for: ima08=M,工單sfb_file:mmb141
    #LET l_sql =" SELECT sfb01,0,sfb08 FROM sfb_file",
     LET l_sql =" SELECT * FROM sfb_file",
                "  WHERE sfb01 = ?  "
     PREPARE r500_prfa FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('pr fa:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
        EXIT PROGRAM
     END IF
     DECLARE r500_cssfba CURSOR FOR r500_prfa
 
    #for: ima08=S,工單sfb_file:mmb141
    #LET l_sql =" SELECT sfb01,0,sfb08 FROM sfb_file",
     LET l_sql =" SELECT * FROM sfb_file",
                "  WHERE sfb01 = ?  "
     PREPARE r500_prfb FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('pr fb:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
        EXIT PROGRAM
     END IF
     DECLARE r500_cssfbb CURSOR FOR r500_prfb
 
    #for: ima08=M,發料單sfs_file:sfb01
    #LET l_sql =" SELECT sfs01,sfs02,sfs05 FROM sfs_file",
     LET l_sql =" SELECT * FROM sfs_file",
                "  WHERE sfs03 = ?  "
     PREPARE r500_prg FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('pr g:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
        EXIT PROGRAM
     END IF
     DECLARE r500_cssfs CURSOR FOR r500_prg
 
    #for: ima08=S,發料單sfs_file:sfb01
    #LET l_sql =" SELECT sfs01,sfs02,sfs05 FROM sfs_file",
     LET l_sql =" SELECT * FROM sfs_file",
                "  WHERE sfs03 = ?  "
     PREPARE r500_prg1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('pr g1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
        EXIT PROGRAM
     END IF
     DECLARE r500_cssfs1 CURSOR FOR r500_prg1
 
    #完工入庫單sfv_file:sfb01
    #LET l_sql =" SELECT sfv01,sfv03,sfv09 FROM sfv_file",
     LET l_sql =" SELECT * FROM sfv_file",
                "  WHERE sfv11 = ?  "
     PREPARE r500_prh FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('pr h:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
        EXIT PROGRAM
     END IF
     DECLARE r500_cssfva CURSOR FOR r500_prh
 
    #雜收單inb_file:sfb01
    #LET l_sql =" SELECT inb01,inb03,inb09 FROM inb_file",
     LET l_sql =" SELECT * FROM inb_file",
                "  WHERE inb11 = ?  "
     PREPARE r500_pri FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('pr i:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
        EXIT PROGRAM
     END IF
     DECLARE r500_csinb CURSOR FOR r500_pri
#     CALL cl_outnam('ammr500') RETURNING l_name        #No.FUN-750093
#     START REPORT r500_rep TO l_name                   #No.FUN-750093
#     LET g_pageno = 0                                  #No.FUN-750093
     FOREACH r500_cs1 INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
        IF cl_null(sr.mmg.mmg18) THEN LET sr.mmg.mmg18=0 END IF
        IF cl_null(sr.mmg.mmg19) THEN LET sr.mmg.mmg19=0 END IF
        IF cl_null(sr.mmg.mmg191) THEN LET sr.mmg.mmg191=0 END IF
        LET l_flag='Y'  LET l_flag1='Y' LET l_flag2='Y' LET l_flag3='Y'
        LET l_flag4='Y' LET l_flag5='Y' LET l_nname=' '
       #mmb_file: io=1
        FOREACH r500_csmmb USING sr.mmg.mmg01,sr.mmg.mmg02,sr.mmh.mmh02
           INTO l_mmb.*
           LET l_nname=' '
           IF l_flag='Y' THEN LET l_nname='需求單:' LET l_flag='N' END IF
           IF cl_null(l_mmb.mmb18) THEN LET l_mmb.mmb18=0 END IF
          #INSERT INTO x VALUES(sr.mmg.mmg01,sr.mmg.mmg02,sr.mmh.mmh02,'mmb',
           INSERT INTO x VALUES(sr.mmg.mmg01,sr.mmg.mmg02,sr.mmh.mmh02,1,
                                l_nname,l_mmb.mmb01,l_mmb.mmb02,l_mmb.mmb18)
           IF SQLCA.SQLERRD[3]=0 THEN
#              CALL cl_err('mmb ins x: ',SQLCA.SQLCODE,0) #No.FUN-660094
               CALL cl_err3("ins","x","","",SQLCA.SQLCODE,"","mmb ins x:",0)        #NO.FUN-660094
              EXIT FOREACH
           END IF
           FOREACH r500_csmmf  USING l_mmb.mmb131,l_mmb.mmb132
             INTO l_mmf.*
             LET l_nname=' '
             IF l_flag1='Y' THEN LET l_nname='通知單:' LET l_flag1='N' END IF
             IF cl_null(l_mmf.mmf10) THEN LET l_mmf.mmf10=0 END IF
             INSERT INTO x VALUES(sr.mmg.mmg01,sr.mmg.mmg02,sr.mmh.mmh02,2,
                                  l_nname,l_mmf.mmf01,l_mmf.mmf02,l_mmf.mmf10)
             IF SQLCA.SQLERRD[3]=0 THEN
#                CALL cl_err('mmf ins x: ',SQLCA.SQLCODE,0) #No.FUN-660094
                 CALL cl_err3("ins","x","","",SQLCA.SQLCODE,"","mmf ins x:",0)        #NO.FUN-660094
                EXIT FOREACH
             END IF
           END FOREACH
           CASE
            WHEN sr.ima08='P'  #mmf:2,pml:3,pmn:4,rvb:5,rvv:6
              FOREACH r500_cspml USING l_mmb.mmb141 INTO l_pml.*
                LET l_nname=' '
                IF l_flag2='Y' THEN LET l_nname='請購單:' LET l_flag2='N' END IF
                IF cl_null(l_pml.pml20) THEN LET l_pml.pml20=0 END IF
                INSERT INTO x VALUES(sr.mmg.mmg01,sr.mmg.mmg02,sr.mmh.mmh02,3,
                                     l_nname,l_pml.pml01,l_pml.pml02,l_pml.pml20)
                IF SQLCA.SQLCODE THEN
#                   CALL cl_err('pml ins x: ',SQLCA.SQLCODE,0) #No.FUN-660094
                    CALL cl_err3("ins","x","","",SQLCA.SQLCODE,"","pml ins x:",0)        #NO.FUN-660094
                   EXIT FOREACH
                END IF
                FOREACH r500_cspmn USING l_pml.pml01,l_pml.pml02
                  INTO l_pmn.*
                  LET l_nname=' '
                  IF l_flag3='Y' THEN
                     LET l_nname='採購單:' LET l_flag3='N'
                  END IF
                  IF cl_null(l_pmn.pmn20) THEN LET l_pmn.pmn20=0 END IF
                  INSERT INTO x VALUES(sr.mmg.mmg01,sr.mmg.mmg02,sr.mmh.mmh02,4,
                                  l_nname,l_pmn.pmn01,l_pmn.pmn02,l_pmn.pmn20)
                  IF SQLCA.SQLCODE THEN
#                     CALL cl_err('pmn ins x: ',SQLCA.SQLCODE,0) #No.FUN-660094
                      CALL cl_err3("ins","x","","",SQLCA.SQLCODE,"","pmn ins x:",0)        #NO.FUN-660094
                     EXIT FOREACH
                  END IF
                  FOREACH r500_csrvb USING l_pmn.pmn01,l_pmn.pmn02
                   INTO l_rvb.*
                   LET l_nname=' '
                   IF l_flag4='Y' THEN
                      LET l_nname='收貨單:' LET l_flag4='N'
                   END IF
                   IF cl_null(l_rvb.rvb07) THEN LET l_rvb.rvb07=0 END IF
                   INSERT INTO x VALUES(sr.mmg.mmg01,sr.mmg.mmg02,sr.mmh.mmh02,
                                  5,l_nname,l_rvb.rvb01,l_rvb.rvb02,l_rvb.rvb07)
                   IF SQLCA.SQLCODE THEN
#                      CALL cl_err('rvb ins x: ',SQLCA.SQLCODE,0) #No.FUN-660094
                       CALL cl_err3("ins","x","","",SQLCA.SQLCODE,"","rvb ins x:",0)        #NO.FUN-660094
                      EXIT FOREACH
                   END IF
                  END FOREACH
                  FOREACH r500_csrvv USING l_rvb.rvb01,l_rvb.rvb03
                   INTO l_rvv.*
                   LET l_nname=' '
                   IF l_flag5='Y' THEN
                      LET l_nname='入庫單:' LET l_flag5='N'
                   END IF
                   IF cl_null(l_rvv.rvv17) THEN LET l_rvv.rvv17=0 END IF
                   INSERT INTO x VALUES(sr.mmg.mmg01,sr.mmg.mmg02,sr.mmh.mmh02,
                                 6,l_nname,l_rvv.rvv01,l_rvv.rvv02,l_rvv.rvv17)
                   IF SQLCA.SQLCODE THEN
#                      CALL cl_err('rvv ins x: ',SQLCA.SQLCODE,0) #No.FUN-660094
                       CALL cl_err3("ins","x","","",SQLCA.SQLCODE,"","rvv ins x:",0)        #NO.FUN-660094
                      EXIT FOREACH
                   END IF
                  END FOREACH
                END FOREACH
              END FOREACH
            WHEN sr.ima08='M'
              FOREACH r500_cssfba USING l_mmb.mmb141
                INTO l_sfb.*
                LET l_nname=' '
                IF l_flag2='Y' THEN LET l_nname='工  單:' LET l_flag2='N' END IF
                IF cl_null(l_sfb.sfb08) THEN LET l_sfb.sfb08=0 END IF
                INSERT INTO x VALUES(sr.mmg.mmg01,sr.mmg.mmg02,sr.mmh.mmh02,3,
                                     l_nname,l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb08)
                IF SQLCA.SQLCODE THEN
#                   CALL cl_err('sfb ins x: ',SQLCA.SQLCODE,0) #No.FUN-660094
                    CALL cl_err3("ins","x","","",SQLCA.SQLCODE,"","sfb ins x:",0)        #NO.FUN-660094
                   EXIT FOREACH
                END IF
                FOREACH r500_csinb USING l_sfb.sfb01 INTO l_inb.*
                  LET l_nname=' '
                  IF l_flag3='Y' THEN
                     LET l_nname='雜收單:' LET l_flag3='N'
                  END IF
                  IF cl_null(l_inb.inb09) THEN LET l_inb.inb09=0 END IF
                  INSERT INTO x VALUES(sr.mmg.mmg01,sr.mmg.mmg02,sr.mmh.mmh02,4,
                                  l_nname,l_inb.inb01,l_inb.inb03,l_inb.inb09)
                  IF SQLCA.SQLCODE THEN
#                     CALL cl_err('inb ins x: ',SQLCA.SQLCODE,0) #No.FUN-660094
                      CALL cl_err3("ins","x","","",SQLCA.SQLCODE,"","inb ins x:",0)        #NO.FUN-660094
                     EXIT FOREACH
                  END IF
                  FOREACH r500_cssfs USING l_sfb.sfb01 INTO l_sfs.*
                   LET l_nname=' '
                   IF l_flag4='Y' THEN
                      LET l_nname='發料單:' LET l_flag4='N'
                   END IF
                   IF cl_null(l_sfs.sfs05) THEN LET l_sfs.sfs05=0 END IF
                   INSERT INTO x VALUES(sr.mmg.mmg01,sr.mmg.mmg02,sr.mmh.mmh02,
                                  5,l_nname,l_sfs.sfs01,l_sfs.sfs02,l_sfs.sfs05)
                   IF SQLCA.SQLCODE THEN
#                      CALL cl_err('sfs ins x: ',SQLCA.SQLCODE,0) #No.FUN-660094
                       CALL cl_err3("ins","x","","",SQLCA.SQLCODE,"","sfs ins x:",0)        #NO.FUN-660094
                      EXIT FOREACH
                   END IF
                  END FOREACH
                  FOREACH r500_cssfva USING l_sfb.sfb01 INTO l_sfv.*
                   LET l_nname=' '
                   IF l_flag5='Y' THEN
                      LET l_nname='入庫單:' LET l_flag5='N'
                   END IF
                   IF cl_null(l_sfv.sfv09) THEN LET l_sfv.sfv09=0 END IF
                   INSERT INTO x VALUES(sr.mmg.mmg01,sr.mmg.mmg02,sr.mmh.mmh02,
                                 6,l_nname,l_sfv.sfv01,l_sfv.sfv03,l_sfv.sfv09)
                   IF SQLCA.SQLCODE THEN
#                      CALL cl_err('sfv ins x: ',SQLCA.SQLCODE,0) #No.FUN-660094
                       CALL cl_err3("ins","x","","",SQLCA.SQLCODE,"","sfv ins x:",0)        #NO.FUN-660094
                      EXIT FOREACH
                   END IF
                  END FOREACH
                END FOREACH
              END FOREACH
            WHEN sr.ima08='S'
              FOREACH r500_cssfbb USING l_mmb.mmb141 INTO l_sfb.*
                LET l_nname=' '
                IF l_flag2='Y' THEN LET l_nname='工  單:' LET l_flag2='N' END IF
                IF cl_null(l_sfb.sfb08) THEN LET l_sfb.sfb08=0 END IF
                INSERT INTO x VALUES(sr.mmg.mmg01,sr.mmg.mmg02,sr.mmh.mmh02,3,
                                     l_nname,l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb08)
                IF SQLCA.SQLCODE THEN
#                   CALL cl_err('sfb ins x2: ',SQLCA.SQLCODE,0) #No.FUN-660094
                    CALL cl_err3("ins","x","","",SQLCA.SQLCODE,"","sfb ins x2:",0)        #NO.FUN-660094
                   EXIT FOREACH
                END IF
                FOREACH r500_cspmn1 USING l_sfb.sfb01 INTO l_pmn.*
                  LET l_nname=' '
                  IF l_flag3='Y' THEN
                     LET l_nname='採購單:' LET l_flag3='N'
                  END IF
                  IF cl_null(l_pmn.pmn20) THEN LET l_pmn.pmn20=0 END IF
                  INSERT INTO x VALUES(sr.mmg.mmg01,sr.mmg.mmg02,sr.mmh.mmh02,4,
                                  l_nname,l_pmn.pmn01,l_pmn.pmn02,l_pmn.pmn20)
                  IF SQLCA.SQLCODE THEN
#                     CALL cl_err('pmn ins x2: ',SQLCA.SQLCODE,0) #No.FUN-660094
                      CALL cl_err3("ins","x","","",SQLCA.SQLCODE,"","pmn ins x2:",0)        #NO.FUN-660094
                     EXIT FOREACH
                  END IF
                  FOREACH r500_cssfs1  USING l_sfb.sfb01 INTO l_sfs.*
                    LET l_nname=' '
                    IF l_flag4='Y' THEN
                       LET l_nname='發料單:' LET l_flag4='N'
                    END IF
                    IF cl_null(l_sfs.sfs05) THEN LET l_sfs.sfs05=0 END IF
                    INSERT INTO x VALUES(sr.mmg.mmg01,sr.mmg.mmg02,sr.mmh.mmh02,
                                  5,l_nname,l_sfs.sfs01,l_sfs.sfs02,l_sfs.sfs05)
                    IF SQLCA.SQLCODE THEN
#                       CALL cl_err('sfs ins x2: ',SQLCA.SQLCODE,0) #No.FUN-660094
                        CALL cl_err3("ins","x","","",SQLCA.SQLCODE,"","sfs ins x2:",0)        #NO.FUN-660094
                       EXIT FOREACH
                    END IF
                  END FOREACH
                  FOREACH r500_csrvb1 USING l_pmn.pmn01,l_pmn.pmn02
                    INTO l_rvb.*
                    LET l_nname=' '
                    IF l_flag4='Y' THEN
                       LET l_nname='收貨單:' LET l_flag4='N'
                    END IF
                    IF cl_null(l_rvb.rvb07) THEN LET l_rvb.rvb07=0 END IF
                    INSERT INTO x VALUES(sr.mmg.mmg01,sr.mmg.mmg02,sr.mmh.mmh02,
                                6,l_nname,l_rvb.rvb01,l_rvb.rvb02,l_rvb.rvb07)
                    IF SQLCA.SQLCODE THEN
#                       CALL cl_err('rvb ins x2: ',SQLCA.SQLCODE,0) #No.FUN-660094
                        CALL cl_err3("ins","x","","",SQLCA.SQLCODE,"","rvb ins x2:",0)        #NO.FUN-660094
                       EXIT FOREACH
                    END IF
                    FOREACH r500_csrvv1 USING l_rvb.rvb01,l_rvb.rvb03
                      INTO l_rvv.*
                      LET l_nname=' '
                      IF l_flag5='Y' THEN
                         LET l_nname='入庫單:' LET l_flag5='N'
                      END IF
                      IF cl_null(l_rvv.rvv17) THEN LET l_rvv.rvv17=0 END IF
                      INSERT INTO x VALUES(sr.mmg.mmg01,sr.mmg.mmg02,
                                    sr.mmh.mmh02,7,l_nname,l_rvv.rvv01,
                                    l_rvv.rvv02,l_rvv.rvv17)
                      IF SQLCA.SQLCODE THEN
#                         CALL cl_err('rvv ins x2: ',SQLCA.SQLCODE,0) #No.FUN-660094
                          CALL cl_err3("ins","x","","",SQLCA.SQLCODE,"","rvv ins x2:",0)        #NO.FUN-660094
                         EXIT FOREACH
                      END IF
                    END FOREACH
                  END FOREACH
                END FOREACH
              END FOREACH
        END CASE
        END FOREACH
#        OUTPUT TO REPORT r500_rep(sr.*)              #No.FUN-750093
#No.FUN-750093 --start--
        CASE sr.mmg.mmg03                                                         
             WHEN '1'   LET l_desc='1' CLIPPED                                
             WHEN '2'   LET l_desc='2' CLIPPED                                
             WHEN '3'   LET l_desc='3' CLIPPED                                
             WHEN '4'   LET l_desc='4' CLIPPED                                
             OTHERWISE  LET l_desc='  '                                         
        END CASE                                                           
        LET g_cnt = 0
        SELECT COUNT(*) INTO g_cnt FROM x
           WHERE x.nog=sr.mmg.mmg01 AND x.nog1=sr.mmg.mmg02                   
             AND x.itg=sr.mmh.mmh02                             
        IF g_cnt = 0 THEN
           EXECUTE insert_prep USING sr.mmg.mmg01,sr.mmg.mmg02,sr.mmg.mmg03,         
                                     sr.mmg.mmg04,sr.mmg.mmg05,sr.mmi02,                      
                                     sr.mmg.mmg06,sr.mmg.mmg10,sr.mmg.mmg09,
                                     sr.mmh.mmh02,sr.mmh.mmh03,sr.mmh.mmh06,   
                                     sr.mmh.mmh12,sr.ima08,'','','','',l_mmh03,
                                     l_desc
          LET l_mmh03 = sr.mmh.mmh03              
        ELSE               
          DECLARE r500_c2 CURSOR FOR                                                
          SELECT * FROM x                                                         
             WHERE x.nog=sr.mmg.mmg01 AND x.nog1=sr.mmg.mmg02                       
               AND x.itg=sr.mmh.mmh02                                               
          ORDER BY nog,nog1,itg,io,no,it                                    
          FOREACH r500_c2 INTO sr2.*                                                
          IF cl_null(sr2.qty) THEN LET sr2.qty=0 END IF                      
          EXECUTE insert_prep USING sr.mmg.mmg01,sr.mmg.mmg02,sr.mmg.mmg03,
                                    sr.mmg.mmg04,sr.mmg.mmg05,sr.mmi02,
                                    sr.mmg.mmg06,sr.mmg.mmg10,sr.mmg.mmg09,
                                    sr.mmh.mmh02,sr.mmh.mmh03,sr.mmh.mmh06,
                                    sr.mmh.mmh12,sr.ima08,sr2.nname,
                                    sr2.no,sr2.it,sr2.qty,l_mmh03,l_desc
          LET l_mmh03 = sr.mmh.mmh03
          END FOREACH
      END IF
#No.FUN-750093 --end--
     END FOREACH
 
#     FINISH REPORT r500_rep                                 #No.FUN-750093
#
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)            #No.FUN-750093
#No.FUN-750093 --start--
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    CALL cl_wcchp(tm.wc,'mmg01,mmg02,mmg03,mmg04,mmg06,mmg09,mmh03')
         RETURNING tm.wc
    LET g_str = tm.wc
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    CALL cl_prt_cs3('ammr500','ammr500',l_sql,g_str)
#No.FUN-750093 --end--
       
       #No.FUN-B80067--mark--Begin---
       #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
       #No.FUN-B80067--mark--End-----
END FUNCTION
#No.FUN-750093 --start--
{REPORT r500_rep(sr)
DEFINE l_last_sw    LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
       sr        RECORD
                        mmg       RECORD LIKE mmg_file.*,
                        mmh       RECORD LIKE mmh_file.*,
                        ima08            LIKE ima_file.ima08,    #來源
                        mmi02            LIKE mmi_file.mmi02     #需求類別
                        END RECORD,
       sr2       RECORD
#                       nog        VARCHAR(10),    #mmg01
                        nog        LIKE mmg_file.mmg01,        #No.FUN-680100 VARCHAR(16)#No.FUN-550054
#                       nog1       VARCHAR(10),    #mmg02
                        nog1       LIKE mmg_file.mmg02,        #No.FUN-680100 VARCHAR(16)#No.FUN-550054
                        itg        LIKE type_file.num5,        #No.FUN-680100 SMALLINT#mmh02
                        io         LIKE type_file.num5,        #No.FUN-680100 SMALLINT#1,2,3,4,5,6
                        nname      LIKE type_file.chr8,        # Prog. Version..: '5.30.06-13.03.12(07)#單別名
#                        no        LIKE apm_file.apm08,        #No.FUN-680100 VARCHAR(10)#單號
                        no         LIKE mmg_file.mmg01,        #No.FUN-680100 VARCHAR(16)#No.FUN-550054
                        it         LIKE type_file.num5,        #No.FUN-680100 SMALLINT#項次
#                       qty        LIKE ima_file.ima26         #No.FUN-680100 DEC(15,3)#數量
                        qty        LIKE type_file.num15_3      ###GP5.2  #NO.FUN-A20044
                        END RECORD,
                l_desc      LIKE ze_file.ze03,        #No.FUN-680100 DEC(15,3) #TQC-840066
                l_mmg18     LIKE mmg_file.mmg18,
                l_mmg19     LIKE mmg_file.mmg19,
                l_amt       LIKE mmg_file.mmg19
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 
  ORDER BY sr.mmg.mmg01,sr.mmg.mmg02,sr.mmg.mmg03,sr.mmh.mmh02
  FORMAT
   PAGE HEADER
#No.FUN-580014 --start--
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company  #TQC-6A0080
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2+1),g_x[1]   #TQC-6A0080
      PRINT
      PRINT g_dash[1,g_len]
      PRINTX name=H1 g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],g_x[51],g_x[52],g_x[53],g_x[54],g_x[55],g_x[56],g_x[57]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.mmg.mmg01
      SKIP TO TOP OF PAGE
 
   BEFORE GROUP OF sr.mmg.mmg02
      SKIP TO TOP OF PAGE
      CASE sr.mmg.mmg03
           WHEN '1'   LET l_desc=g_x[39] CLIPPED
           WHEN '2'   LET l_desc=g_x[40] CLIPPED
           WHEN '3'   LET l_desc=g_x[41] CLIPPED
           WHEN '4'   LET l_desc=g_x[42] CLIPPED
           OTHERWISE  LET l_desc='    '
      END CASE
      PRINTX name=D1
            COLUMN g_c[41],sr.mmg.mmg01 CLIPPED,
#No.FUN-550054  --start--
            COLUMN g_c[42],sr.mmg.mmg02 CLIPPED,
            COLUMN g_c[43],sr.mmg.mmg03 CLIPPED,l_desc clipped,
            COLUMN g_c[44],sr.mmg.mmg04 CLIPPED,  #FUN-5B0014 [1,20] CLIPPED,
            COLUMN g_c[45],sr.mmg.mmg05,sr.mmi02,
            COLUMN g_c[46],sr.mmg.mmg06,
            COLUMN g_c[47],sr.mmg.mmg10 USING '##############&',
            COLUMN g_c[48],sr.mmg.mmg09 CLIPPED;
#No.FUN-550054  --end--
#      PRINT COLUMN 23,g_x[19] CLIPPED,
#            COLUMN 63,g_x[20] CLIPPED
#      PRINT COLUMN 35,g_x[19] CLIPPED,     #No.FUN-550054
#            COLUMN 75,g_x[20] CLIPPED,     #No.FUN-550054
#            COLUMN 87,g_x[35] CLIPPED,     #No.FUN-550054
#            COLUMN 104,g_x[36] CLIPPED,    #No.FUN-550054
#            COLUMN 110,g_x[37] CLIPPED     #No.FUN-550054
#      PRINT COLUMN 23,g_dash[1,76]
#      PRINT COLUMN 35,g_dash[1,82]         #No.FUN-550054
 
 
   ON EVERY ROW
#No.FUN-550054  --start--
#      PRINT COLUMN 23,sr.mmh.mmh02 USING '###&',
#            COLUMN 28,sr.mmh.mmh03,
#            COLUMN 49,sr.mmh.mmh06 USING '#######&',
#            COLUMN 58,sr.mmh.mmh12,
#            COLUMN 63,sr.ima08;
      PRINTX name=D1
            COLUMN g_c[49],sr.mmh.mmh02 USING '###&', #FUN-590118
            COLUMN g_c[50],sr.mmh.mmh03,
            COLUMN g_c[51],sr.mmh.mmh06 USING '##############&',
            COLUMN g_c[52],sr.mmh.mmh12,
            COLUMN g_c[53],sr.ima08;
      LET g_cnt=0
      DECLARE r500_c1 CURSOR FOR
        SELECT * FROM x
         WHERE x.nog=sr.mmg.mmg01 AND x.nog1=sr.mmg.mmg02
           AND x.itg=sr.mmh.mmh02
         ORDER BY nog,nog1,itg,io,no,it
      FOREACH r500_c1 INTO sr2.*
        IF cl_null(sr2.qty) THEN LET sr2.qty=0 END IF
#        PRINT COLUMN 68,sr2.nname,
#              COLUMN 75,sr2.no,'-',
#              COLUMN 85,sr2.it  USING '###',
#              COLUMN 91,sr2.qty USING '#######&'
        PRINTX name=D1
              COLUMN g_c[54],sr2.nname CLIPPED,
              COLUMN g_c[55],sr2.no CLIPPED,
              COLUMN g_c[56],sr2.it  USING '###&', #FUN-590118
              COLUMN g_c[57],sr2.qty USING '##############&'
#No.FUN-550054  --end--
#No.FUN-580014 --end--
        LET g_cnt=g_cnt+1
      END FOREACH
      IF g_cnt=0 THEN PRINT END IF
 
   ON LAST ROW
#No.TQC-6A0116  --start--
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300    
         CALL cl_wcchp(tm.wc,'mmg01,mmg02,mmg03,mmg04,mmg09')                   
              RETURNING tm.wc                                                   
         PRINT g_dash[1,g_len]                                                  
#TQC-630166                                                                     
#        PRINT g_x[8] CLIPPED,tm.wc[001,132] CLIPPED                            
         CALL cl_prt_pos_wc(tm.wc)                                              
      END IF
      PRINT g_dash[1,g_len] 
#No.TQC-6A0116  --end-- 
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED #No.TQC-6A0116      
 
   PAGE TRAILER
#No.TQC-6A0116  --start-- 
#     IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#         CALL cl_wcchp(tm.wc,'mmg01,mmg02,mmg03,mmg04,mmg09')
#              RETURNING tm.wc
#         PRINT g_dash[1,g_len]
#TQC-630166
#        PRINT g_x[8] CLIPPED,tm.wc[001,132] CLIPPED
#         CALL cl_prt_pos_wc(tm.wc)
#      ELSE
#         SKIP 1 LINE
#      END IF
#     PRINT g_dash[1,g_len]
#No.TQC-6A0116  --end-- 
      IF l_last_sw = 'n' THEN
         PRINT g_dash[1,g_len]
         PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE
    #    PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED  #No.TQC-6A0116 
         SKIP 2 LINE                 #No.TQC-6A0116 
      END IF
END REPORT}
#No.FUN-750093 --end--
#Patch....NO.TQC-610035 <> #
