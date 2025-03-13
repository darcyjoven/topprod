# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: armg160.4gl
# Descriptions...: RMA出廠放行單列印
# Date & Author..: 98/05/01 by plum
# Modify.........: No.MOD-4A0037 04/10/18 By Mandy ima133 由CHAR(15) 改為CHAR(20) 的影響
# Modify.........: No.FUN-4B0045 04/11/15 By Smapmin 客戶編號開窗
# Modify.........: No.FUN-550122 05/05/30 By echo 新增報表備註
# Modify.........: No.TQC-610048 06/01/13 By cl 維護打印表格線
# Modify.........: No.TQC-610087 06/04/03 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-660152 06/06/27 By rainy CREATE TEMP TABLE 單號部份改char(16)
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-730010 07/03/16 By chenl 報表輸出至Crystal Reports功能
# Modify.........: No.FUN-710080 07/04/04 By Sarah CR報表串cs3()增加傳一個參數
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B40092 11/06/01 By xujing 憑證報表轉GRW
# Modify.........: No.FUN-B80073 11/08/03 By minpp程序撰寫規範修改	
# Modify.........: No.FUN-B40092 11/08/17 By xujing 程式規範修改 
# Modify.........: No.FUN-C10036 12/01/11 By qirl FUN-BB0047追單
# Modify.........: No.FUN-C10036 12/01/16 By xuxz 程序規範修改
# Modify.........: No:FUN-C40026 12/04/11 By xumm GR動態簽核
# Modify.........: No.FUN-C50008 12/05/14 By wangrr GR程式優化
# Modify.........: No.CHI-C80041 12/12/20 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc      LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(600),             # Where condition
              footer  LIKE type_file.chr20,   #No.FUN-690010 VARCHAR(20),              # 表尾
              rdare   LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),               # update rme021 condition
              rme021  LIKE rme_file.rme021,   #No.FUN-690010 DATE,
              spec    LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),               # print rmf06,rmf061
              misc    LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),               # print rmf06 替代rmf03
              more    LIKE type_file.chr1     #No.FUN-690010 VARCHAR(1)                # Input more condition
              END RECORD,
          l_rme011     LIKE rme_file.rme011,
          l_rmf31      LIKE rmf_file.rmf31,
          l_rmf33      LIKE rmf_file.rmf33,
          g_rme01      LIKE rme_file.rme01,
          g_prin       LIKE type_file.num5,    #No.FUN-690010 smallint,
          g_rme03 LIKE rme_file.rme03
 
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
#No.FUN-730010--begin--
DEFINE   l_table  STRING
DEFINE   g_sql    STRING
DEFINE   g_str    STRING
#No.FUN-730010--end--
###GENGRE###START
TYPE sr1_t RECORD
    rme01_1 LIKE rme_file.rme01,
    rme011_1 LIKE rme_file.rme011,
    rme03_1 LIKE rme_file.rme03,
    rme04_1 LIKE rme_file.rme04,
    rme11_1 LIKE rme_file.rme11,
    rme21_1 LIKE rme_file.rme21,
    rmf03_1 LIKE rmf_file.rmf03,
    rmf04_1 LIKE rmf_file.rmf04,
    rmf06_1 LIKE rmf_file.rmf06,
    rmf061_1 LIKE rmf_file.rmf061,
    rmf22_1 LIKE rmf_file.rmf22,
    ima131_1 LIKE ima_file.ima131,
    ima133_1 LIKE ima_file.ima133,
    rme01_2 LIKE rme_file.rme01,
    rme011_2 LIKE rme_file.rme011,
    rme03_2 LIKE rme_file.rme03,
    rme04_2 LIKE rme_file.rme04,
    rme11_2 LIKE rme_file.rme11,
    rme21_2 LIKE rme_file.rme21,
    rmf03_2 LIKE rmf_file.rmf03,
    rmf04_2 LIKE rmf_file.rmf04,
    rmf06_2 LIKE rmf_file.rmf06,
    rmf061_2 LIKE rmf_file.rmf061,
    rmf22_2 LIKE rmf_file.rmf22,
    ima131_2 LIKE ima_file.ima131,
    ima133_2 LIKE ima_file.ima133,
    rme01_3 LIKE rme_file.rme01,
    rme011_3 LIKE rme_file.rme011,
    rme03_3 LIKE rme_file.rme03,
    rme04_3 LIKE rme_file.rme04,
    rme11_3 LIKE rme_file.rme11,
    rme21_3 LIKE rme_file.rme21,
    rmf03_3 LIKE rmf_file.rmf03,
    rmf04_3 LIKE rmf_file.rmf04,
    rmf06_3 LIKE rmf_file.rmf06,
    rmf061_3 LIKE rmf_file.rmf061,
    rmf22_3 LIKE rmf_file.rmf22,
    ima131_3 LIKE ima_file.ima131,
    ima133_3 LIKE ima_file.ima133,
    plt LIKE type_file.num5,
    cno LIKE type_file.num5,      #FUN-C40026 add,
#FUN-C40026----add---str---
    sign_type LIKE type_file.chr1,
    sign_img  LIKE type_file.blob,
    sign_show LIKE type_file.chr1,
    sign_str  LIKE type_file.chr1000
#FUN-C40026----add---end---
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  # CALL cl_used(g_prog,g_time,1) RETURNING g_time     #FUN-C10036 MARK
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ARM")) THEN
      EXIT PROGRAM
   END IF
 
#No.FUN-730010--begin--
   LET g_sql = "rme01_1.rme_file.rme01,",
               "rme011_1.rme_file.rme011,",
               "rme03_1.rme_file.rme03,",
               "rme04_1.rme_file.rme04,",
               "rme11_1.rme_file.rme11,",
               "rme21_1.rme_file.rme21,",
               "rmf03_1.rmf_file.rmf03,",
               "rmf04_1.rmf_file.rmf04,",
               "rmf06_1.rmf_file.rmf06,",
               "rmf061_1.rmf_file.rmf061,",
               "rmf22_1.rmf_file.rmf22,",
               "ima131_1.ima_file.ima131,",
               "ima133_1.ima_file.ima133,",
               "rme01_2.rme_file.rme01,",
               "rme011_2.rme_file.rme011,",
               "rme03_2.rme_file.rme03,",
               "rme04_2.rme_file.rme04,",
               "rme11_2.rme_file.rme11,",
               "rme21_2.rme_file.rme21,",
               "rmf03_2.rmf_file.rmf03,",
               "rmf04_2.rmf_file.rmf04,",
               "rmf06_2.rmf_file.rmf06,",
               "rmf061_2.rmf_file.rmf061,",
               "rmf22_2.rmf_file.rmf22,",
               "ima131_2.ima_file.ima131,",
               "ima133_2.ima_file.ima133,",
               "rme01_3.rme_file.rme01,",
               "rme011_3.rme_file.rme011,",
               "rme03_3.rme_file.rme03,",
               "rme04_3.rme_file.rme04,",
               "rme11_3.rme_file.rme11,",
               "rme21_3.rme_file.rme21,",
               "rmf03_3.rmf_file.rmf03,",
               "rmf04_3.rmf_file.rmf04,",
               "rmf06_3.rmf_file.rmf06,",
               "rmf061_3.rmf_file.rmf061,",
               "rmf22_3.rmf_file.rmf22,",
               "ima131_3.ima_file.ima131,",
               "ima133_3.ima_file.ima133,",
               "plt.type_file.num5,",
               "cno.type_file.num5,",      #FUN-C40026 add 2,
               #FUN-C40026----add---str----
               "sign_type.type_file.chr1,",  #簽核方式
               "sign_img.type_file.blob,",   #簽核圖檔
               "sign_show.type_file.chr1,",
               "sign_str.type_file.chr1000"
               #FUN-C40026----add---end----
 
    LET l_table = cl_prt_temptable('armg160',g_sql) CLIPPED
    IF l_table = -1 THEN
       #CALL cl_used(g_prog, g_time,2) RETURNING g_time  #FUN-B40092#FUN-C10036 mark
       #CALL cl_gre_drop_temptable(l_table)              #FUN-B40092#FUN-C10036 mark
       EXIT PROGRAM 
    END IF
    LET g_sql = " INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                "  VALUES(?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?, ",
                "         ?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?, ",
                "         ?,?,?,?,?)"                    #FUN-C40026 add 4?
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',STATUS,1)
       #CALL cl_used(g_prog, g_time,2) RETURNING g_time  #FUN-B40092#FUN-C10036 mark
       #CALL cl_gre_drop_temptable(l_table)              #FUN-B40092#FUN-C10036 mark
       EXIT PROGRAM
    END IF
#No.FUN-730010--end--
 
   IF s_shut(0) THEN CALL cl_err('',9037,0) EXIT PROGRAM END IF
#-----------------No.TQC-610087 modify
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6) 
   LET tm.wc    = ARG_VAL(7)
  # LET g_rme01  = ARG_VAL(1)
  # LET g_prin   = ARG_VAL(2)
  #IF  g_prin is null then LET g_prin=2 end if
  # LET g_rlang = g_lang
   LET tm.footer = ARG_VAL(8)
   LET tm.rdare  = ARG_VAL(9)
   LET tm.rme021 = ARG_VAL(10)
   LET tm.spec   = ARG_VAL(11)
   LET tm.misc   = ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#-----------------No.TQC-610087 end
#FUN-B40092------mod------str
#No.FUN-690010-BEGIN
#   CREATE TEMP TABLE armg160_temp(
#   rme03   LIKE rme_file.rme03,
#   rme011  LIKE rme_file.rme011,
#   rmf31   LIKE rmf_file.rmf31,
#   rmf33   LIKE rmf_file.rmf33,
#   total   LIKE type_file.num5);
#No.FUN-690010-END
#   create unique index armg160_01 on armg160_temp (rme03,rme011,rmf31,rmf33);
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #FUN-C10036 ADD
#FUN-B40092------mod------end 
   IF cl_null(tm.wc) THEN
      CALL armg160_tm(0,0)        # Input print condition
   ELSE
     #LET tm.wc = "rme01='",tm.wc CLIPPED,"'"     #No.TQC-610087 mark
      CALL armg160()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
END MAIN
 
FUNCTION armg160_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_cmd          LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 14
   ELSE LET p_row = 5 LET p_col = 14
   END IF
   OPEN WINDOW armg160_w AT p_row,p_col
        WITH FORM "arm/42f/armg160"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                        #Default condition
   LET tm.more = 'N'
   LET tm.rdare= 'N'
   LET tm.spec = 'Y'
   LET tm.misc = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   CASE g_lang
     WHEN '0'
       LET tm.footer='此批已完稅'
     WHEN '2'
       LET tm.footer='此批已完稅'
     OTHERWISE
       LET tm.footer='Lot Taxed'
   END CASE
   LET tm.rme021=g_today
 
WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON rme01,rme02,rme03
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
       ON ACTION CONTROLP
               IF INFIELD(rme03) THEN #客戶編號    #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_occ"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rme03
                  NEXT FIELD rme03
               END IF
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
      # CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80073 MARK
       LET INT_FLAG = 0 CLOSE WINDOW armg160_w 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073 ADD
       CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
       EXIT PROGRAM
    END IF
    IF tm.wc=" 1=1" THEN
       CALL cl_err('','9046',0) CONTINUE WHILE
    END IF
 
   INPUT BY NAME tm.footer,tm.rdare,tm.rme021,tm.spec,tm.misc,tm.more
         WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD rdare IF cl_null(tm.rdare) THEN NEXT FIELD rdare END IF
      BEFORE FIELD rme021
             IF tm.rdare='N' THEN NEXT FIELD spec END IF
      AFTER FIELD rme021
             IF cl_null(tm.rme021) THEN NEXT FIELD rme021 END IF
      AFTER FIELD spec IF cl_null(tm.spec) THEN NEXT FIELD spec END IF
      AFTER FIELD misc IF cl_null(tm.misc) THEN NEXT FIELD misc END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
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
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80073 MARK
      LET INT_FLAG = 0 CLOSE WINDOW armg160_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
      CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='armg160'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('armg160','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.footer CLIPPED,"'" ,       #No.TQC-610087 add 
                         " '",tm.rdare CLIPPED,"'" ,        #No.TQC-610087 add
                         " '",tm.rme021 CLIPPED,"'" ,       #No.TQC-610087 add 
                         " '",tm.spec CLIPPED,"'" ,         #No.TQC-610087 add 
                         " '",tm.misc CLIPPED,"'" ,         #No.TQC-610087 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('armg160',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW armg160_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL armg160()
   ERROR ""
END WHILE
   CLOSE WINDOW armg160_w
END FUNCTION
 
FUNCTION armg160()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0085
          l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT  #No.FUN-690010 VARCHAR(1000)
          l_za05    LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(40)
          sr        RECORD
                    rme RECORD LIKE rme_file.*,
                    rmf RECORD LIKE rmf_file.*,
                    ima133  LIKE ima_file.ima133, #機種
                    ima131  LIKE ima_file.ima131  #分類
                 END RECORD
#No.FUN-730010--begin-- 
    DEFINE sr1      ARRAY[3] OF RECORD
                    rme RECORD LIKE rme_file.*,
                    rmf RECORD LIKE rmf_file.*,
                    ima133  LIKE ima_file.ima133,
                    ima131  LIKE ima_file.ima131
                    END RECORD
    DEFINE l_plt,l_cno  LIKE type_file.num5
    DEFINE l_rmf22   LIKE rmf_file.rmf22
    DEFINE l_rmf121  LIKE rmf_file.rmf121
    DEFINE l_i       LIKE type_file.num5
    DEFINE l_rme03   LIKE rme_file.rme03
    DEFINE l_rme03_t LIKE rme_file.rme03
    DEFINE l_img_blob   LIKE type_file.blob  #FUN-C40026 add

 
    INITIALIZE sr.*   TO NULL
    CALL sr1.clear()
    LET l_i = 0
    LET l_rme03   = ""
    LET l_rme03_t = ""
#No.FUN-730010--end--
 
#     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085 #FUN-B40092 mark
 
     LOCATE l_img_blob      IN MEMORY            #FUN-C40026 add
     CALL cl_del_data(l_table)  #No.FUN-730010
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    #SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'armg160'  #No.FUN-730010 mark
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'armg160'             #No.FUN-730010 
    #No.FUN-730010--begin-- mark
    #IF g_len = 0 OR g_len IS NULL THEN LET g_len = 90 END IF
    #FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '-' END FOR
    #No.FUN-730010--end-- mark
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc CLIPPED," AND rmeuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc CLIPPED," AND rmegrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc CLIPPED," AND rmegrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('rmeuser', 'rmegrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT rme_file.*,rmf_file.*,ima133,ima131 ",
                #"  FROM rme_file,rmf_file,OUTER ima_file ",  #FUN-C50008 mark--
                 "  FROM rme_file,rmf_file LEFT OUTER JOIN ima_file ON rmf03=ima01 ", #FUN-C50008 add LEFT OUTER
                 " WHERE rme01 = rmf01 ",
                #"   AND rmf_file.rmf03 = ima_file.ima01 ",  #FUN-C50008 mark--
                 "   AND rmeconf <> 'X' ",  #CHI-C80041
                 "   AND rmevoid='Y' AND  ",tm.wc CLIPPED ,
                 " ORDER BY rme03,rme011,rmf03,rmf06 "
     PREPARE armg160_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        #CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80073     MARK
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
        CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
        EXIT PROGRAM
     END IF
     DECLARE armg160_curs1 CURSOR FOR armg160_prepare1
 
    #No.FUN-730010--begin-- mark
    #CALL cl_outnam('armg160') RETURNING l_name
    #START REPORT armg160_rep TO l_name
 
    #LET g_pageno = 0
    #No.FUN-730010--end-- mark
     DELETE FROM armg160_temp
     BEGIN WORK
     FOREACH armg160_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       #更新列印碼
       UPDATE rme_file SET rmeprin = 'Y' WHERE rme01 = sr.rme.rme01
       #更新覆出日期
       IF tm.rdare = 'Y' AND NOT cl_null(sr.rme.rme021) THEN
          UPDATE rme_file SET rme021 = tm.rme021
                   WHERE rme01 = sr.rme.rme01
       END IF
 
        IF sr.rmf.rmf31 IS NULL THEN LET sr.rmf.rmf31=0 END IF
        SELECT count(*) INTO g_cnt FROM armg160_temp
        WHERE rme03=sr.rme.rme03 AND rme011 = sr.rme.rme011
          AND rmf31  = sr.rmf.rmf31 AND rmf33  = sr.rmf.rmf33
       IF g_cnt=0 THEN
          INSERT INTO armg160_temp
          VALUES(sr.rme.rme03,sr.rme.rme011,sr.rmf.rmf31,sr.rmf.rmf33,1)
       END IF
    #No.FUN-730010--begin--
       LET l_i = l_i + 1           # 用于計數，每3筆同一退貨客戶記錄合并為1筆記錄
       IF l_rme03 = sr.rme.rme03 OR l_i=1 THEN  #第一筆資料或是同組資料
          LET l_rme03 = sr.rme.rme03     
          CASE l_i
            WHEN 1
              LET sr1[l_i].* = sr.*
            WHEN 2
              LET sr1[l_i].* = sr.*
            WHEN 3
              LET sr1[l_i].* = sr.*
              SELECT MAX(rmq03) INTO l_plt FROM rmq_file WHERE rmq01=sr.rme.rme01
              SELECT COUNT(*) INTO l_cno FROM rmq_file
                  WHERE rmq01=sr.rme.rme01 AND rmq03=0
              EXECUTE insert_prep USING sr1[1].rme.rme01,sr1[1].rme.rme011,sr1[1].rme.rme03,sr1[1].rme.rme04,sr1[1].rme.rme11,
                                        sr1[1].rme.rme21,sr1[1].rmf.rmf03,sr1[1].rmf.rmf04,sr1[1].rmf.rmf06,sr1[1].rmf.rmf061,
                                        sr1[1].rmf.rmf22,sr1[1].ima131,sr1[1].ima133,   
                                        sr1[2].rme.rme01,sr1[2].rme.rme011,sr1[2].rme.rme03,sr1[2].rme.rme04,sr1[2].rme.rme11,
                                        sr1[2].rme.rme21,sr1[2].rmf.rmf03,sr1[2].rmf.rmf04,sr1[2].rmf.rmf06,sr1[2].rmf.rmf061,
                                        sr1[2].rmf.rmf22,sr1[2].ima131,sr1[2].ima133,
                                        sr1[3].rme.rme01,sr1[3].rme.rme011,sr1[3].rme.rme03,sr1[3].rme.rme04,sr1[3].rme.rme11,
                                        sr1[3].rme.rme21,sr1[3].rmf.rmf03,sr1[3].rmf.rmf04,sr1[3].rmf.rmf06,sr1[3].rmf.rmf061,
                                        sr1[3].rmf.rmf22,sr1[3].ima131,sr1[3].ima133,   
                                        #l_plt,l_cno   #FUN-C40026 mark
                                        l_plt,l_cno,"",l_img_blob,"N",""                    #FUN-C40026 add
              LET l_i = 0
              CALL sr1.clear()
          END CASE
       END IF
       IF l_i<>1 AND l_rme03 <> sr.rme.rme03 THEN  #非第一筆資料,或是非同組資料
          SELECT MAX(rmq03) INTO l_plt FROM rmq_file WHERE rmq01=sr.rme.rme01
          SELECT COUNT(*) INTO l_cno FROM rmq_file
              WHERE rmq01=sr.rme.rme01 AND rmq=0
          EXECUTE insert_prep USING sr1[1].rme.rme01,sr1[1].rme.rme011,sr1[1].rme.rme03,sr1[1].rme.rme04,sr1[1].rme.rme11,
                                    sr1[1].rme.rme21,sr1[1].rmf.rmf03,sr1[1].rmf.rmf04,sr1[1].rmf.rmf06,sr1[1].rmf.rmf061,
                                    sr1[1].rmf.rmf22,sr1[1].ima131,sr1[1].ima133,   
                                    sr1[2].rme.rme01,sr1[2].rme.rme011,sr1[2].rme.rme03,sr1[2].rme.rme04,sr1[2].rme.rme11,
                                    sr1[2].rme.rme21,sr1[2].rmf.rmf03,sr1[2].rmf.rmf04,sr1[2].rmf.rmf06,sr1[2].rmf.rmf061,
                                    sr1[2].rmf.rmf22,sr1[2].ima131,sr1[2].ima133,
                                    sr1[3].rme.rme01,sr1[3].rme.rme011,sr1[3].rme.rme03,sr1[3].rme.rme04,sr1[3].rme.rme11,
                                    sr1[3].rme.rme21,sr1[3].rmf.rmf03,sr1[3].rmf.rmf04,sr1[3].rmf.rmf06,sr1[3].rmf.rmf061,
                                    sr1[3].rmf.rmf22,sr1[3].ima131,sr1[3].ima133,   
                                    #l_plt,l_cno    #FUN-C40026 mark
                                    l_plt,l_cno,"",l_img_blob,"N",""                    #FUN-C40026 add
          LET l_rme03 = sr.rme.rme03
          LET l_i = 1
          LET sr1[l_i].* = sr.*
       END IF
      #OUTPUT TO REPORT armg160_rep(sr.*)   
     END FOREACH
     LET g_cr_table = l_table                 #FUN-C40026 add
     LET g_cr_apr_key_f = "rme01_1"             #FUN-C40026 add
     IF l_i > 0 THEN 
        SELECT MAX(rmq03) INTO l_plt FROM rmq_file WHERE rmq01=sr.rme.rme01
        SELECT COUNT(*) INTO l_cno FROM rmq_file
            WHERE rmq01=sr.rme.rme01 AND rmq=0
        EXECUTE insert_prep USING sr1[1].rme.rme01,sr1[1].rme.rme011,sr1[1].rme.rme03,sr1[1].rme.rme04,sr1[1].rme.rme11,
                                  sr1[1].rme.rme21,sr1[1].rmf.rmf03,sr1[1].rmf.rmf04,sr1[1].rmf.rmf06,sr1[1].rmf.rmf061,
                                  sr1[1].rmf.rmf22,sr1[1].ima131,sr1[1].ima133,   
                                  sr1[2].rme.rme01,sr1[2].rme.rme011,sr1[2].rme.rme03,sr1[2].rme.rme04,sr1[2].rme.rme11,
                                  sr1[2].rme.rme21,sr1[2].rmf.rmf03,sr1[2].rmf.rmf04,sr1[2].rmf.rmf06,sr1[2].rmf.rmf061,
                                  sr1[2].rmf.rmf22,sr1[2].ima131,sr1[2].ima133,
                                  sr1[3].rme.rme01,sr1[3].rme.rme011,sr1[3].rme.rme03,sr1[3].rme.rme04,sr1[3].rme.rme11,
                                  sr1[3].rme.rme21,sr1[3].rmf.rmf03,sr1[3].rmf.rmf04,sr1[3].rmf.rmf06,sr1[3].rmf.rmf061,
                                  sr1[3].rmf.rmf22,sr1[3].ima131,sr1[3].ima133,   
                                  #l_plt,l_cno     #FUN-C40026 mark
                                  l_plt,l_cno,"",l_img_blob,"N",""                    #FUN-C40026 add
        LET l_i = 0
        CALL sr1.clear()
     END IF
     COMMIT WORK
     
    CALL cl_wcchp(tm.wc,'rme01,rme02,rme03') RETURNING tm.wc     #FUN-C40026 add
    #FINISH REPORT armg160_rep   #No.FUN-730010 mark
###GENGRE###     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
###GENGRE###     LET g_str = tm.spec,';',tm.misc,';',tm.footer
###GENGRE###     CALL cl_prt_cs3('armg160','armg160',l_sql,g_str)   #FUN-710080 modify
    CALL armg160_grdata()    ###GENGRE###
    #CALL cl_prt(l_name,g_prtway,g_copies,g_len)    #No.FUN-730010 mark
    #  CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085  #No.FUN-730010 mark
    #No.FUN-730010--end--
END FUNCTION
 
##No.FUN-730010--begin-- mark
#REPORT armg160_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),
#          l_str        LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(68),
#          l_str1       LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(68),
#          l_str2       LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(68),    #No.TQC-610048
#          l_p          LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(01),
#          l_plt,l_cno  LIKE type_file.num5,    #No.FUN-690010 smallint,
#          l_rmf22      LIKE rmf_file.rmf22,
#          l_rmf121     LIKE rmf_file.rmf121,
#          l_total      LIKE type_file.num5,    #No.FUN-690010 SMALLINT,
#          sr        RECORD
#                    rme RECORD LIKE rme_file.*,
#                    rmf RECORD LIKE rmf_file.*,
#                    ima133  LIKE ima_file.ima133, #機種
#                    ima131  LIKE ima_file.ima131  #分類
#                 END RECORD
#
#  OUTPUT TOP MARGIN 0
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN 5
#         PAGE LENGTH g_page_line
# #by 覆出單,RMA單,料件
#  ORDER BY sr.rme.rme03,sr.rme.rme011,sr.rmf.rmf03,sr.rmf.rmf06
#
#  FORMAT
#   PAGE HEADER
#      PRINT (g_len-FGL_WIDTH(g_company))/2 SPACES,g_company
#      IF cl_null(g_towhom)
#         THEN PRINT '';
#         ELSE PRINT 'TO:',g_towhom;
#      END IF
#      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#      PRINT ' '
#      LET g_pageno = g_pageno + 1
#      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.rme.rme03
#      LET l_total=0
#      SELECT COUNT(*) INTO l_total
#             FROM armg160_temp WHERE rme03=sr.rme.rme03
#      PRINT g_x[10],
#             COLUMN 41,g_x[11] CLIPPED,COLUMN 65,g_x[12] CLIPPED #MOD-4A0037
#       PRINT g_x[13] CLIPPED,COLUMN 65,g_x[14] CLIPPED           #MOD-4A0037
#       PRINT g_x[10],g_x[11] CLIPPED,COLUMN 65,g_x[12] CLIPPED   #MOD-4A0037
#      LET l_p='3'
#      SELECT MAX(rmq03) INTO l_plt FROM rmq_file WHERE rmq01=sr.rme.rme01
#      SELECT COUNT(*)   INTO l_cno FROM rmq_file
#                  WHERE rmq01=sr.rme.rme01 AND rmq03=0
#      IF cl_null(l_plt) THEN LET l_plt=0 END IF
#      IF cl_null(l_cno) THEN LET l_cno=0 END IF
#
#   BEFORE GROUP OF sr.rme.rme011
#      IF l_p='3' THEN
#         #PRINT '|',sr.rme.rme04,COLUMN 12,'|',COLUMN 62,g_x[21] CLIPPED;
#           PRINT g_x[26],sr.rme.rme04 CLIPPED,COLUMN 12,g_x[26],COLUMN 65,g_x[21] CLIPPED; #MOD-4A0037 #No.TQC-610048
#          IF l_plt!=0 THEN
#             PRINT ' ',l_plt USING '##&',g_x[23] CLIPPED,' ';
#             IF l_cno!=0 THEN
#                PRINT l_cno USING '##&',g_x[24] CLIPPED,g_x[27]  #No.TQC-610048
#             ELSE
#                PRINT g_x[28]   #No.TQC-610048
#             END IF
#          ELSE
#             PRINT '       ';
#             IF l_cno!=0 THEN
#                PRINT l_cno USING '##&',g_x[24] CLIPPED,g_x[27]  #No.TQC-610048
#             ELSE
#                PRINT g_x[28]   #No.TQC-610048
#             END IF
#          END IF
#      END IF
#      LET l_p="1"
# 
#  #AFTER GROUP OF sr.rmf.rmf03
#   AFTER GROUP OF sr.rmf.rmf06
#      LET l_str = sr.rmf.rmf06 CLIPPED
#      LET l_str1= sr.rmf.rmf061 CLIPPED             #No.TQC-610048
#      LET l_rmf22 = GROUP SUM(sr.rmf.rmf22)
#      IF l_p=g_x[26] THEN                           #No.TQC-610048
#         LET l_str2=g_x[26],sr.rme.rme011,g_x[26]   #No.TQC-610048
#         LET l_p='2'
#      ELSE
#         LET l_str2=g_x[9] CLIPPED
#      END IF
#      IF tm.misc = 'Y' AND sr.rmf.rmf03 = 'MISC'  THEN
#        PRINT l_str1 CLIPPED,l_str CLIPPED;
#        PRINT COLUMN 65,g_x[26],l_rmf22 USING '##&',' ',   #No.TQC-610048
#              sr.rmf.rmf04,
#              COLUMN 73,g_x[27],g_x[22] CLIPPED            #No.TQC-610048
#        PRINT l_str2 CLIPPED,l_str1 CLIPPED;
#        PRINT COLUMN 65,g_x[26],COLUMN 73,g_x[27],g_x[22] CLIPPED #No.TQC-610048
#        IF tm.spec = 'Y' AND sr.rmf.rmf03 != 'MISC' THEN
#            PRINT g_x[9] CLIPPED,l_str CLIPPED,COLUMN 65,g_x[21] CLIPPED,COLUMN 88,g_x[26]  #MOD-4A0037  #No.TQC-610048
#            PRINT g_x[9] CLIPPED,l_str1 CLIPPED,COLUMN 65,g_x[21] CLIPPED,COLUMN 88,g_x[26] #No.TQC-610048
#        END IF
#      ELSE
#        PRINT l_str2 CLIPPED,
#               COLUMN 13,sr.rmf.rmf03,      #MOD-4A0037
#               COLUMN 34,sr.ima133 CLIPPED, #MOD-4A0037
#               COLUMN 55,sr.ima131 CLIPPED; #MOD-4A0037
#         PRINT COLUMN 65,g_x[26],l_rmf22 USING '##&',#MOD-4A0037   #No.TQC-610048
#              COLUMN 69,sr.rmf.rmf04,
#              COLUMN 73,g_x[27],g_x[22] CLIPPED   #No.TQC-610048
#        IF tm.spec = 'Y' AND sr.rmf.rmf03 != 'MISC' THEN
#            PRINT g_x[9] CLIPPED,l_str CLIPPED,COLUMN 65,g_x[21] CLIPPED,COLUMN 88,g_x[26]  #MOD-4A0037  #No.TQC-610048
#            PRINT g_x[9] CLIPPED,l_str1 CLIPPED,COLUMN 65,g_x[21] CLIPPED,COLUMN 88,g_x[26] #No.TQC-610048
#        END IF
#      END IF
#
#   AFTER GROUP OF sr.rme.rme03
#      PRINT g_x[9] CLIPPED,tm.footer;
#      IF NOT cl_null(sr.rme.rme21) THEN
#          PRINT ' ',g_x[29],sr.rme.rme21 CLIPPED ,g_x[30],COLUMN 65,g_x[21] CLIPPED,COLUMN 88,g_x[26]         #MOD-4A0037 #No.TQC-610048
#      ELSE
#          PRINT COLUMN 65,g_x[21] CLIPPED,g_x[22] CLIPPED      #MOD-4A0037
#      END IF
#       PRINT g_x[15],COLUMN 65,g_x[21] CLIPPED,g_x[22] CLIPPED #MOD-4A0037
#       PRINT g_x[15],COLUMN 65,g_x[21] CLIPPED,g_x[22] CLIPPED #MOD-4A0037
#       PRINT g_x[15],COLUMN 65,g_x[21] CLIPPED,g_x[22] CLIPPED #MOD-4A0037
#       PRINT g_x[10],g_x[11] CLIPPED,COLUMN 65,g_x[12] CLIPPED #MOD-4A0037
#      PRINT PRINT
### FUN-550122
#ON LAST ROW
#      LET l_last_sw = 'y'
#
#PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#             PRINT g_x[25]
#             PRINT g_memo
#         ELSE
#             PRINT
#             PRINT
#         END IF
#      ELSE
#             PRINT g_x[25]
#             PRINT g_memo
#      END IF
### END FUN-550122
#
#END REPORT
##Patch....NO.TQC-610037 <001> #
##No.FUN-730010--end--

###GENGRE###START
FUNCTION armg160_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
   
    LOCATE sr1.sign_img IN MEMORY    #FUN-C40026 add
    CALL cl_gre_init_apr()           #FUN-C40026 add
 
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("armg160")
        IF handler IS NOT NULL THEN
            START REPORT armg160_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
          
            DECLARE armg160_datacur1 CURSOR FROM l_sql
            FOREACH armg160_datacur1 INTO sr1.*
                OUTPUT TO REPORT armg160_rep(sr1.*)
            END FOREACH
            FINISH REPORT armg160_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT armg160_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B40092------add------str
    DEFINE l_footer   STRING
    DEFINE l_str1_1   STRING 
    DEFINE l_str1_2   STRING
    DEFINE l_str1_3   STRING
    DEFINE l_str2_1   STRING
    DEFINE l_str2_2   STRING
    DEFINE l_str2_3   STRING
    DEFINE l_str3_1   STRING
    DEFINE l_str3_2   STRING
    DEFINE l_str3_3   STRING
    DEFINE l_plt_cno  STRING
    DEFINE l_plt      STRING
    DEFINE l_cno      STRING
    DEFINE l_option   STRING
    DEFINE l_option1  STRING
    DEFINE l_rme21    STRING
    DEFINE l_rmf22_1  STRING
    DEFINE l_option2  STRING
    DEFINE l_rmf22_2  STRING
    DEFINE l_option3  STRING
    DEFINE l_rmf22_3  STRING
    DEFINE l_option4  STRING
    #FUN-B40092------add------end

    
#    ORDER EXTERNAL BY sr1.rme01_1    #FUN-B40092 mark
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
            LET l_lineno = 0          #FUN-B40092 add
              
#        BEFORE GROUP OF sr1.rme01_1  #FUN-B40092 mark
#            LET l_lineno = 0         #FUN-B40092 mark
        
        ON EVERY ROW
            #FUN-B40092------add------str
            LET L_rme21 =" "
            LET l_plt_cno =" "
            LET l_str2_1 =" "
            LET l_str2_2 =" "
            LET l_str2_3 =" "
            LET l_str1_3 =" "
            LET l_str1_2 =" "
            LET l_str1_1 =" "
            LET l_str3_2 =" "
            LET l_str3_3 =" "
            LET l_option3 = sr1.rmf22_2 USING '--,---,---,---,---,--&'
            LET l_rmf22_2 = l_option3,sr1.rmf04_2
            PRINTX l_rmf22_2   
 
            LET l_option4 = sr1.rmf22_3 USING '--,---,---,---,---,--&'
            LET l_rmf22_3 = l_option4,sr1.rmf04_3
            PRINTX l_rmf22_3

            LET l_option2 = sr1.rmf22_1 USING '--,---,---,---,---,--&'
            LET l_rmf22_1 = l_option2,sr1.rmf04_1
            PRINTX l_rmf22_1 
                        
            IF NOT cl_null(sr1.rme21_1) THEN
               LET l_rme21 = sr1.rme21_1
            END IF
            IF NOT cl_null(sr1.rme21_2) THEN
               LET l_rme21 = l_rme21,sr1.rme21_2
            END IF            
            IF NOT cl_null(sr1.rme21_3) THEN
               LET l_rme21 = l_rme21,sr1.rme21_3
            END IF
            PRINTX l_rme21

            LET l_cno = sr1.cno USING '--,---,---,---,---,--&'
            LET l_plt = sr1.plt USING '--,---,---,---,---,--&'
            LET l_option = cl_gr_getmsg("gre-039",g_lang,'0') 
            LET l_option1 = cl_gr_getmsg("gre-039",g_lang,'1') 
            

            IF sr1.plt != 0 THEN
               IF sr1.cno != 0 THEN
                  LET l_plt_cno = l_plt,l_option,' ',l_cno,l_option1
               ELSE
                  LET l_plt_cno = l_plt,l_option
               END IF
            ELSE
               IF sr1.cno != 0 THEN
                  LET l_plt_cno = l_cno,l_option1
               ELSE
                  LET l_plt_cno = ' '
               END IF
            END IF
            PRINTX l_plt_cno    

       
            IF tm.misc = 'Y' AND sr1.rmf03_3 = "MISC" THEN
               IF tm.spec = 'Y' AND sr1.rmf03_3 != "MISC" THEN
                  LET l_str3_3 = sr1.rmf061_3
               END IF
            ELSE
               IF tm.spec = 'Y' AND sr1.rmf03_3 != "MISC" THEN
                  LET l_str3_3 = sr1.rmf061_3
               END IF
            END IF
            PRINTX l_str3_3
 
            IF tm.misc = 'Y' AND sr1.rmf03_3 = "MISC" THEN
               IF tm.spec = 'Y' AND sr1.rmf03_3 != "MISC" THEN
                  LET l_str3_2 = sr1.rmf06_3
               END IF
            ELSE
               IF tm.spec = 'Y' AND sr1.rmf03_3 != "MISC" THEN
                  LET l_str3_2 = sr1.rmf06_3
               END IF
            END IF
            PRINTX l_str3_2

            IF tm.misc = 'Y' AND sr1.rmf03_3 = "MISC" THEN
               LET l_str3_1 = sr1.rmf061_3,' ',sr1.rmf06_3
            ELSE
               LET l_str3_1 = sr1.rmf03_3,' ',sr1.ima133_3,' ',sr1.ima131_3
            END IF
            PRINTX l_str3_1

            IF tm.misc = 'Y' AND sr1.rmf03_2 = "MISC" THEN
               IF tm.spec = 'Y' AND sr1.rmf03_2 != "MISC" THEN
                  LET l_str2_3 = sr1.rmf061_2
               END IF
            ELSE
               IF tm.spec = 'Y' AND sr1.rmf03_2 != "MISC" THEN
                  LET l_str2_3 = sr1.rmf061_2
               END IF
            END IF
            PRINTX l_str2_3

            IF tm.misc = 'Y' AND sr1.rmf03_2 = "MISC" THEN
               IF tm.spec = 'Y' AND sr1.rmf03_2 != "MISC" THEN
                  LET l_str2_2 = sr1.rmf06_2
               END IF
            ELSE
               IF tm.spec = 'Y' AND sr1.rmf03_2 != "MISC" THEN
                  LET l_str2_2 = sr1.rmf06_2
               END IF
            END IF
            PRINTX l_str2_2

            IF tm.misc = 'Y' AND sr1.rmf03_2 = "MISC" THEN
               LET l_str2_1 = sr1.rmf061_2,' ',sr1.rmf06_2
            ELSE 
               LET l_str2_1 = sr1.rmf03_2,' ',sr1.ima133_2,' ',sr1.ima131_2
            END IF
            PRINTX l_str2_1

            IF tm.misc = 'Y' AND sr1.rmf03_1 = "MISC" THEN
               IF tm.spec = 'Y' AND sr1.rmf03_1 != "MISC" THEN
                  LET l_str1_3 = sr1.rmf061_1
               END IF
            ELSE
               IF tm.spec = 'Y' AND sr1.rmf03_1 != "MISC" THEN
                  LET l_str1_3 = sr1.rmf061_1
               END IF
            END IF
            PRINTX l_str1_3

            IF tm.misc = 'Y' AND sr1.rmf03_1 = "MISC" THEN
               IF tm.spec = 'Y' AND sr1.rmf03_1 != "MISC" THEN
                  LET l_str1_2 = sr1.rmf06_1
               END IF
            ELSE
               IF tm.spec = 'Y' AND sr1.rmf03_1 != "MISC" THEN
                  LET l_str1_2 = sr1.rmf06_1
               END IF 
            END IF
            PRINTX l_str1_2

            IF tm.misc = 'Y' AND sr1.rmf03_1 = "MISC" THEN
               LET l_str1_1 = sr1.rmf061_1,' ',sr1.rmf06_1
            ELSE
               LET l_str1_1 = sr1.rmf03_1,' ',sr1.ima133_1,' ',sr1.ima131_1
            END IF
            PRINTX l_str1_1

            IF NOT cl_null(sr1.rme01_1) THEN
               LET l_footer = tm.footer
            ELSE
               LET l_footer = ' '
            END IF
            PRINTX l_footer
            #FUN-B40092------add------end
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

#        AFTER GROUP OF sr1.rme01_1         #FUN-B40092 mark

        
#        ON LAST ROW                        #FUN-B40092 mark

END REPORT
###GENGRE###END
#FUN-B40092
