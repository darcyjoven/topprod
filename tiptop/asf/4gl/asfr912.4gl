# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: asfr912.4gl
# Descriptions...: 工單異動起訖一覽表
# Date & Author..: 00/01/26 By Snow
# Modify.........: No:9517 04/05/04 Melody g_yn組WHERE條件時,要加括號
# Modify.........: No:9684 04/07/22 Carol 比入庫日期時,call CALL r912_comp時,應該傳
#                                         l_cmin,l_dmin跟l_cmax,l_dmax.
# Modify.........: No.MOD-4A0338 04/11/02 By Smapmin 以za_file的方式取代PRINT中文字的部份
# Modify.........: No.FUN-4B0043 04/11/15 By Nicola 加入開窗功能
# Modify.........: NO.FUN-510029 05/01/13 By Carol 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: No.FUN-550067  05/05/31 By yoyo單據編號格式放大
# Modify.........: No.MOD-570394 05/08/01 By pengu  asfr912列印不出品名規格
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-610080 06/03/03 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.MOD-640229 06/04/10 By Sarah sr1與sr2裡的a2,a4應放大成16碼
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.FUN-680121 06/09/01 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0090 06/10/31 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.TQC-710016 07/01/08 By ray "接下頁"和"結束"位置有誤
# Modify.........: No.MOD-940310 09/06/17 By mike 已結案得條件錯了,且g_yn定義得寬度太小 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A50156 10/05/28 By Carrier MOD-A30121追单
# Modify.........: No.FUN-A70095 11/06/14 By lixh1 撈取報工單(shb_file)的所有處理作業,必須過濾是已確認的單據
# Modify.........: No.MOD-B90253 11/09/28 By destiny 无法抓取不走工艺时的报工资料
# Modify.........: No.TQC-C10115 12/01/30 By jason 31區rebuild的結果錯誤排除
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                      # Print condition RECORD
                 wc          LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(600)# Where condition
                 edate       LIKE type_file.dat,           #No.FUN-680121 DATE# 最後異動日
                 b           LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)# 列印(未結案/結案/全部)
                 s           LIKE type_file.chr3           #No.FUN-680121 VARCHAR(3)# 列印順序			
              END RECORD,
         #g_yn  LIKE ima_file.ima34,        #No.FUN-680121 VARCHAR(40)#是否結案  #MOD-940310
          g_yn  LIKE type_file.chr100,      #No.MOD-940310 VARCHAR(100) #是否結案
          g_sta LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123
 
 
   LET g_pdate = ARG_VAL(1)         # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)        #TQC-610080 以下順序調整
   LET tm.edate = ARG_VAL(8)
   LET tm.b = ARG_VAL(9)
   LET tm.s = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL r912_tm(0,0)        # Input print condition
      ELSE CALL r912()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
#--------------------------r912_tm()-----------------------------------
FUNCTION r912_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_cmd          LIKE type_file.chr1000        #No.FUN-680121 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 12
   END IF
 
   OPEN WINDOW r912_w AT p_row,p_col
        WITH FORM "asf/42f/asfr912"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.b ='3'
   LET tm.s ='123'
   LET tm.edate=TODAY
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON sfb01,sfb05,sfb81,sfb02
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
        ON ACTION CONTROLP    #FUN-4B0043
           IF INFIELD(sfb05) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ima"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO sfb05
              NEXT FIELD sfb05
           END IF
 
     ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE CONSTRUCT
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r912_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
         
   END IF
    IF tm.wc = ' 1=1' THEN
       CALL cl_err('','9046',0) CONTINUE WHILE
    END IF
 
   INPUT BY NAME tm.edate,tm.b,
                   tm2.s1,tm2.s2,tm2.s3 WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD edate
         IF cl_null(tm.edate) THEN
            NEXT FIELD edate
         END IF
      AFTER FIELD b
         IF tm.b NOT MATCHES '[123]' THEN
            NEXT FIELD b
         END IF
 
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r912_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='asfr912'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asfr912','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",tm.s CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('asfr912',g_time,l_cmd)     #No.7360
     END IF
     CLOSE WINDOW r912_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
     EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r912()
   ERROR ""
END WHILE
   CLOSE WINDOW r912_w
END FUNCTION
#------------------------------FUNCTION r912()-------------------------------
FUNCTION r912()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680121 CAHR(1200)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
          l_i       LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_order ARRAY[3] OF LIKE sfb_file.sfb05,               #No.FUN-680121 VARCHAR(40)#排序 #FUN-5B0105 20->40
          sr        RECORD
                            order1 LIKE sfb_file.sfb05,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                            order2 LIKE sfb_file.sfb05,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                            order3 LIKE sfb_file.sfb05,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                            fno    LIKE sfb_file.sfb05,        #No.FUN-680121 SMALLINT#流水號
                            sfb01 LIKE sfb_file.sfb01,  #工號
                            sfb05 LIKE sfb_file.sfb05,  #成品
                            sfb08 LIKE sfb_file.sfb08,  #量
                            sfb09 LIKE sfb_file.sfb09,  #入庫量
                            sfb24 LIKE sfb_file.sfb24,  #製程追蹤檔案產生否
                            sfb28 LIKE sfb_file.sfb28,  #結案狀
                            sfb38 LIKE sfb_file.sfb38,  #成會結案日
                            sfb81 LIKE sfb_file.sfb81,  #輸入日期
                            amin  LIKE sfb_file.sfb81,  #起領退日
                            amax  LIKE sfb_file.sfb81,  #訖領退日
                            bmin  LIKE sfb_file.sfb81,  #起報工日
                            bmax  LIKE sfb_file.sfb81,  #訖報工日
                            cmin  LIKE sfb_file.sfb81,  #起完退日
                            cmax  LIKE sfb_file.sfb81,  #訖完退日
                            dmin  LIKE sfb_file.sfb81,  #開始異動
                            dmax  LIKE sfb_file.sfb81   #最後異動
                    END RECORD,
          l_n       like type_file.num5,          
          sr1       RECORD
                          a1 LIKE type_file.dat,           #No.FUN-680121 DATE
                          a2 LIKE oea_file.oea01,          #No.FUN-680121 VARCHAR(16)#CHAR(10),  #MOD-640229 modify
                          a3 LIKE type_file.chr8,          #No.FUN-680121 VARCHAR(08)
                          a4 LIKE oea_file.oea01           #No.FUN-680121 VARCHAR(16)#CHAR(10)   #MOD-640229 modify
                    END RECORD,
          sr2       RECORD
                          a1 LIKE type_file.dat,           #No.FUN-680121 DATE
                          a2 LIKE oea_file.oea01           #No.FUN-680121 VARCHAR(16)#CHAR(10)   #MOD-640229 modify
                    END RECORD
                   
     #--------------------------CREATE TEMP TABLE-------------------
     DROP TABLE temp_tlf
    #No.FUN-680121-BEGIN
      CREATE TEMP TABLE temp_tlf(
               tlft1  LIKE type_file.dat,   
               tlft2  LIKE oea_file.oea01,
               tlft3  LIKE type_file.chr8,
               tlft4  LIKE oea_file.oea01);
     #No.FUN-680121-END       
     CREATE INDEX r912_t_01 ON temp_tlf (tlft2,tlft4,tlft3);
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('CREATE TEMP TABLE temp_tlf err:',SQLCA.sqlcode,1) RETURN
     END IF
 
     DROP TABLE temp_shb
   #No.FUN-680121-BEGIN 
    CREATE TEMP TABLE temp_shb(
               shbt1  LIKE type_file.dat,   
               shbt2  LIKE oea_file.oea01);
   #No.FUN-680121-END          
     CREATE INDEX r912_s_01 ON temp_shb (shbt2,shbt1);
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('CREATE TEMP TABLE temp_shb err:',SQLCA.sqlcode,1) RETURN
     END IF
     #--------------------------------------------------------------
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND sfbuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND sfbgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND sfbgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
     #End:FUN-980030
 
     #--------------------------l_sql-------------------------------
     #是否要列印結案資料..
     CASE
         WHEN tm.b='1' #未結案
              LET g_yn=" AND ( sfb28 IS NULL OR sfb28='' ) "  #No:9517
         WHEN tm.b='2' #已結案
             #LET g_yn=" AND sfb28 IS NOT NULL AND sfb28<>''"   #MOD-940310
              LET g_yn=" AND sfb28 IS NOT NULL OR sfb28<>''"   #MOD-940310
         WHEN tm.b='3' #全部
              LET g_yn=" AND 1=1"
         OTHERWISE EXIT CASE
     END CASE
     LET l_sql="SELECT '','','','',",
               " sfb01,sfb05,sfb08,sfb09,sfb24,sfb28,sfb38,sfb81,",
               " '','','','','','','',''",
               " FROM sfb_file",
               " WHERE sfbacti='Y' AND sfb87='Y'",
               " AND ",tm.wc CLIPPED, g_yn CLIPPED,
               " ORDER BY sfb01"
 
     PREPARE r912_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('prepare1:',SQLCA.sqlcode,1)
           RETURN
     END IF
     DECLARE r912_curs1 CURSOR FOR r912_prepare1
     #---------------------------------------------------
     #tlf....
     LET l_sql="SELECT tlf06,tlf036,tlf13,tlf62",
               "  FROM tlf_file",
               " WHERE ((tlf036=? ",
               "   AND (tlf13='asft6201' OR tlf13='asft660')) ",
               "    OR (tlf62=? AND tlf13='asft6201')) ",
               #No.TQC-A50156  --Begin
#              "    OR (tlf036=? AND (tlf13 MATCHES 'asfi51*' ",
               "    OR (tlf62=? AND (tlf13 LIKE 'asfi51%' ", 
               #No.TQC-A50156  --End
               "    OR tlf13 MATCHES 'asfi52*'))"
 
     PREPARE tlf_prepapre FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('tlf_prepapre:',SQLCA.sqlcode,1) RETURN
     END IF
     DECLARE tlf_curs CURSOR FOR tlf_prepapre
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('declare_tlf:',SQLCA.sqlcode,1) RETURN
     END IF
     #---------------------------------------------------
     #shb....
     
      LET l_sql="SELECT shb03,shb05",
                "  FROM shb_file",
                " WHERE shb05=? AND shbacti='Y' AND shbconf = 'Y' "   #FUN-A70095 add shbconf 
     PREPARE shb_prepapre FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('shb_prepapre:',SQLCA.sqlcode,1) RETURN
     END IF
     DECLARE shb_curs CURSOR FOR shb_prepapre
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('declare_shb:',SQLCA.sqlcode,1) RETURN
     END IF
     #MOD-B90253--begin
     LET l_sql= " SELECT srf05,srg16 FROM srg_file,srf_file WHERE srg01=srf01 AND srg16=? AND srfconf='Y' "   #TQC-C10115 add "
     PREPARE srg_prepapre FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('srg_prepapre:',SQLCA.sqlcode,1) RETURN
     END IF
     DECLARE srg_curs CURSOR FOR srg_prepapre
     #MOD-B90253--end
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('declare_srg:',SQLCA.sqlcode,1) RETURN
     END IF
     #------------------START REPORT--------------------------
     CALL cl_outnam('asfr912') RETURNING l_name
     START REPORT r912_rep TO l_name
     LET g_pageno = 0
 
     #by工號取出符合的所有日期，並insert到temptable
     FOREACH r912_curs1 INTO sr.*
        IF SQLCA.sqlcode!=0 THEN
           CALL cl_err('foreach:r912_curs1',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
 
        FOREACH tlf_curs USING sr.sfb01,sr.sfb01,sr.sfb01 INTO sr1.*
           IF SQLCA.sqlcode!=0 THEN
              CALL cl_err('foreach:tlf_curs',SQLCA.sqlcode,1)
              RETURN
           END IF
           INSERT INTO temp_tlf
           VALUES (sr1.a1,sr1.a2,sr1.a3,sr1.a4)
           IF SQLCA.sqlcode!=0 THEN
   #           CALL cl_err('insert temp_tlf:',SQLCA.sqlcode,1)   #No.FUN-660128
              CALL cl_err3("ins","temp_tlf","","",SQLCA.sqlcode,"","insert temp_tlf:",1)    #No.FUN-660128
              #EXIT FOREACH
              RETURN
           END IF
        END FOREACH
 
        FOREACH shb_curs USING sr.sfb01 INTO sr2.*
           IF SQLCA.sqlcode!=0 THEN
              CALL cl_err('foreach:shb_curs',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           #MOD-B90253--begin
           SELECT COUNT(*) INTO l_n FROM temp_shb WHERE shbt1=sr2.a1 AND   
               shbt2 =sr2.a2 
           IF l_n>0 THEN 
              CONTINUE FOREACH 
           END IF 
           #MOD-B90253--end
           INSERT INTO temp_shb
           VALUES (sr2.a1,sr2.a2)
           IF SQLCA.sqlcode!=0 THEN
    #         CALL cl_err('insert temp_shb',SQLCA.sqlcode,1) 
              CALL cl_err3("ins","temp_shb","","",SQLCA.sqlcode,"","insert temp_shb",1)      #No.FUN-660128 
              #EXIT FOREACH
              RETURN
           END IF
        END FOREACH
        
        #MOD-B90253--begin
        FOREACH srg_curs USING sr.sfb01 INTO sr2.*
           IF SQLCA.sqlcode!=0 THEN
              CALL cl_err('foreach:shb_curs',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
          
           SELECT COUNT(*) INTO l_n FROM temp_shb WHERE shbt1=sr2.a1 AND   
               shbt2 =sr2.a2 
           IF l_n>0 THEN 
              CONTINUE FOREACH 
           END IF 
           INSERT INTO temp_shb
           VALUES (sr2.a1,sr2.a2)
           IF SQLCA.sqlcode!=0 THEN
              CALL cl_err3("ins","temp_shb","","",SQLCA.sqlcode,"","insert temp_shb",1)      #No.FUN-660128 
              RETURN
           END IF
        END FOREACH
        #MOD-B90253--end
        #================================================
        CALL r912_getdate(sr.sfb01,sr.sfb24)
             RETURNING sr.amin,sr.amax,
                       sr.bmin,sr.bmax,
                       sr.cmin,sr.cmax,
                       sr.dmin,sr.dmax,
                       g_sta
        IF g_sta='n' THEN CONTINUE FOREACH END IF
        IF g_sta='x' THEN RETURN END IF#@@@@@@@@@@@@@@@@@@@@@@@@
        #=================================================
        #delete temp date..
        DELETE FROM temp_tlf
        IF SQLCA.sqlcode != 0 THEN
#          CALL cl_err('delete temp_tlf:',SQLCA.sqlcode,1)  #No.FUN-660128
           CALL cl_err3("del","temp_tlf","","",SQLCA.sqlcode,"","delete temp_tlf:",1)    #No.FUN-660128
                RETURN  
        END IF
        DELETE FROM temp_shb
        IF SQLCA.sqlcode != 0 THEN
#          CALL cl_err('delete temp_shb:',SQLCA.sqlcode,1) #No.FUN-660128
           CALL cl_err3("del","temp_shb","","",SQLCA.sqlcode,"","delete temp_shb:",1)    #No.FUN-660128
            RETURN              
        END IF
     #----------------------------
     #排序方式
     FOR l_i=1 TO 3
         IF tm.s[l_i,l_i]='1' THEN LET l_order[l_i]=sr.sfb01 END IF
         IF tm.s[l_i,l_i]='2' THEN LET l_order[l_i]=sr.sfb05 END IF
         IF tm.s[l_i,l_i]='3' THEN LET l_order[l_i]=sr.sfb81 END IF
     END FOR
     LET sr.order1=l_order[1]
     LET sr.order2=l_order[2]
     LET sr.order3=l_order[3]
     #----------------------------
       OUTPUT TO REPORT r912_rep(sr.*)
     END FOREACH
 
     FINISH REPORT r912_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
#----------------------------REPORT r912_rep()----------------------------------
REPORT r912_rep(sr)
   DEFINE l_last_sw  LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_str      LIKE ima_file.ima34,          #No.FUN-680121 CAHR(40)
          l_j        LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_ima02    LIKE ima_file.ima02,
          l_ima021   LIKE ima_file.ima021,
          sr        RECORD
                            order1 LIKE sfb_file.sfb05,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                            order2 LIKE sfb_file.sfb05,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                            order3 LIKE sfb_file.sfb05,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                            fno    LIKE type_file.num5,        #No.FUN-680121 SMALLINT#流水號
                            sfb01 LIKE sfb_file.sfb01,  #工號
                            sfb05 LIKE sfb_file.sfb05,  #成品
                            sfb08 LIKE sfb_file.sfb08,  #量
                            sfb09 LIKE sfb_file.sfb09,  #入庫量
                            sfb24 LIKE sfb_file.sfb24,  #製程追蹤檔案產生否
                            sfb28 LIKE sfb_file.sfb28,  #結案狀
                            sfb38 LIKE sfb_file.sfb38,  #成會結案日
                            sfb81 LIKE sfb_file.sfb81,  #輸入日期
                            amin  LIKE sfb_file.sfb81,  #起領退日
                            amax  LIKE sfb_file.sfb81,  #訖領退日
                            bmin  LIKE sfb_file.sfb81,  #起報工日
                            bmax  LIKE sfb_file.sfb81,  #訖報工日
                            cmin  LIKE sfb_file.sfb81,  #起完退日
                            cmax  LIKE sfb_file.sfb81,  #訖完退日
                            dmin  LIKE sfb_file.sfb81,  #開始異動
                            dmax  LIKE sfb_file.sfb81   #最後異動
                    END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
   ORDER BY sr.order1,sr.order2,sr.order3
#----------------------------PAGE HEADER-----------------------------
  FORMAT
   PAGE HEADER
      LET l_j =0
 
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED, pageno_total
      PRINT ''
 
      PRINT g_dash
      PRINT g_x[31],
            g_x[32],
            g_x[33],
            g_x[34],
            g_x[35],
            g_x[36],
            g_x[37],
            g_x[38],
            g_x[39],
            g_x[40],
            g_x[41],
            g_x[42],
            g_x[43],
            g_x[44],
            g_x[45],
            g_x[46],
            g_x[47],
            g_x[48],
            g_x[49]
      PRINT g_dash1
      LET l_last_sw = 'n'
#-------------------------ON EVERY ROW------------------------------
   ON EVERY ROW
       #給流水號
       LET l_j=l_j+1
       LET sr.fno=l_j
       CASE sr.sfb28
            WHEN '1'   LET l_str = g_x[09]
            WHEN '2'   LET l_str = g_x[10]
            WHEN '3'   LET l_str = g_x[11]
            OTHERWISE  LET l_str = ''
       END CASE
        SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file WHERE ima01=sr.sfb05  #No.MOD-570394 add
       PRINT COLUMN g_c[31],sr.fno USING '####' CLIPPED,   #項次
#            COLUMN g_c[32],sr.sfb01[1,10] CLIPPED, #工號
             COLUMN g_c[32],sr.sfb01 CLIPPED, #No.FUN-550067
             COLUMN g_c[33],sr.sfb81 CLIPPED, #開單日期
             COLUMN g_c[34],sr.sfb05 CLIPPED, #機種
             COLUMN g_c[35],l_ima02,
             COLUMN g_c[36],l_ima021,
             COLUMN g_c[37],sr.sfb24 CLIPPED, #製
             COLUMN g_c[38],sr.sfb08 USING '---------------' CLIPPED, #工號量
             COLUMN g_c[39],sr.sfb09 USING '---------------' CLIPPED, #入庫量
             COLUMN g_c[40],l_str CLIPPED,
             COLUMN g_c[41],sr.sfb38 CLIPPED, #
             COLUMN g_c[42],sr.amin CLIPPED,  #起領退日
             COLUMN g_c[43],sr.amax CLIPPED,  #訖領退日
             COLUMN g_c[44],sr.bmin CLIPPED,  #起報工日
             COLUMN g_c[45],sr.bmax CLIPPED,  #訖報工日
             COLUMN g_c[46],sr.cmin CLIPPED,  #起完退日
             COLUMN g_c[47],sr.cmax CLIPPED,  #訖完退日
             COLUMN g_c[48],sr.dmin CLIPPED,  #開始異動
             COLUMN g_c[49],sr.dmax CLIPPED   #最後異動
      #每五行印一分格線
       IF (sr.fno MOD 5)=0 THEN
          PRINT g_dash2
       END IF
 
       LET l_last_sw = 'n'
#-------------------------ON LASR ROW---------------------------------
   ON LAST ROW
      PRINT g_dash
      CALL cl_wcchp(tm.wc,'sfb01,sfb05,sfb81,sfb02') RETURNING tm.wc
       PRINT g_x[8],COLUMN 10,tm.wc  #MOD-4A0338
      PRINT g_dash
      LET l_last_sw = 'y'
#     PRINT g_x[4] CLIPPED, COLUMN g_c[48],g_x[7] CLIPPED     #No.TQC-710016
      PRINT g_x[4] CLIPPED, COLUMN g_len-9,g_x[7] CLIPPED     #No.TQC-710016
#-------------------------PAGE TRAILER--------------------------------
   PAGE TRAILER
      IF l_last_sw ='n' THEN
         PRINT g_dash
#        PRINT g_x[4] CLIPPED, COLUMN g_c[48],g_x[6] CLIPPED     #No.TQC-710016
         PRINT g_x[4] CLIPPED, COLUMN g_len-9,g_x[6] CLIPPED     #No.TQC-710016
         ELSE SKIP 2 LINE
      END IF
END REPORT
 
#---------------------FUNCTION r912_getdate()------------------------------
FUNCTION r912_getdate(p_sfb01,p_sfb24)
  DEFINE p_sfb01 LIKE sfb_file.sfb01,
         p_sfb24 LIKE sfb_file.sfb24,
         l_amin  LIKE sfb_file.sfb81,  #起領退日
         l_amax  LIKE sfb_file.sfb81,  #訖領退日
         l_bmin  LIKE sfb_file.sfb81,  #起報工日
         l_bmax  LIKE sfb_file.sfb81,  #訖報工日
         l_cmin  LIKE sfb_file.sfb81,  #起完退日
         l_cmax  LIKE sfb_file.sfb81,  #訖完退日
         l_dmin  LIKE sfb_file.sfb81,  #開始異動
         l_dmax  LIKE sfb_file.sfb81   #最後異動
 
        LET g_sta='Y'
        LET l_amin=NULL
        LET l_amax=NULL
        LET l_bmin=NULL
        LET l_bmax=NULL
        LET l_cmin=NULL
        LET l_cmax=NULL
        LET l_dmin=NULL
        LET l_dmax=NULL
        #----------------------------------------------
        #A.計算最小/最大『領退日』
        SELECT MIN(tlft1),MAX(tlft1) INTO l_amin,l_amax
        FROM temp_tlf
        #No.TQC-A50156  --Begin
#       WHERE tlft2=p_sfb01
        WHERE tlft4=p_sfb01
        #No.TQC-A50156  --End  
          AND (tlft3 MATCHES 'asfi51*' OR tlft3 MATCHES 'asfi52*')
        IF STATUS <> 0 THEN
#          CALL cl_err('select A:',SQLCA.sqlcode,1)   #No.FUN-660128
           CALL cl_err3("sel","temp_tlf",p_sfb01,"",SQLCA.sqlcode,"","select A:",1)    #No.FUN-660128
           LET g_sta='x'
           RETURN l_amin,l_amax,l_bmin,l_bmax,l_cmin,l_cmax,l_dmin,l_dmax,g_sta
        END IF
        #---------------------
        #若最後異動日 > edate 則不列印此筆資料
        IF NOT cl_null(l_dmax) AND l_dmax > tm.edate THEN
           LET g_sta='n'
           RETURN l_amin,l_amax,l_bmin,l_bmax,l_cmin,l_cmax,l_dmin,l_dmax,g_sta
        END IF
        #D.-------------------
        CALL r912_comp('1',l_amin,l_amin) RETURNING l_dmin  #取最小日
        CALL r912_comp('99',l_amax,l_amax) RETURNING l_dmax #取最大日
        #------------------------------------------------
        #B.計算最小/最大『報工日』
        #IF p_sfb24='Y' THEN  #MOD-B90253
           SELECT MIN(shbt1),MAX(shbt1) INTO l_bmin,l_bmax
             FROM temp_shb
            WHERE shbt2=p_sfb01
            #  AND shbacti='Y'
           IF STATUS <> 0 THEN
#             CALL cl_err('select B:',SQLCA.sqlcode,1)   #No.FUN-660128
              CALL cl_err3("sel","temp_shb",p_sfb01,"",SQLCA.sqlcode,"","select B:",1)    #No.FUN-660128
              LET g_sta='x'
              RETURN l_amin,l_amax,l_bmin,l_bmax,l_cmin,l_cmax,l_dmin,l_dmax,g_sta
           END IF
        #END IF #MOD-B90253
        #---------------------
        #若最後異動日 > edate 則不列印此筆資料
        IF l_dmax >tm.edate THEN
           LET g_sta='n'
           RETURN l_amin,l_amax,l_bmin,l_bmax,l_cmin,l_cmax,l_dmin,l_dmax,g_sta
        END IF
        #D.-------------------
        CALL r912_comp('1',l_bmin,l_dmin) RETURNING l_dmin  #取最小日
        CALL r912_comp('99',l_bmax,l_dmax) RETURNING l_dmax #取最大日                   #------------------------------------------------
        #C.計算最小/最大『入庫日』
        SELECT MIN(tlft1),MAX(tlft1) INTO l_cmin,l_cmax
          FROM temp_tlf
         WHERE (tlft2=p_sfb01 AND
               (tlft3 = 'asft6201' OR tlft3 = 'asft660'))
           OR  (tlft4=p_sfb01 AND tlft3='asft6201')
        IF STATUS <> 0 THEN
#          CALL cl_err('select C:',SQLCA.sqlcode,1)   #No.FUN-660128
           CALL cl_err3("sel","temp_tlf",p_sfb01,"",SQLCA.sqlcode,"","select C:",1)    #No.FUN-660128
           LET g_sta='x'
           RETURN l_amin,l_amax,l_bmin,l_bmax,l_cmin,l_cmax,l_dmin,l_dmax,g_sta
        END IF
        #---------------------
        #若最後異動日 > edate 則不列印此筆資料
        IF l_dmax >tm.edate THEN
           LET g_sta='n'
           RETURN l_amin,l_amax,l_bmin,l_bmax,l_cmin,l_cmax,l_dmin,l_dmax,g_sta
        END IF
        #D.-------------------
        CALL r912_comp('1',l_cmin,l_dmin) RETURNING l_dmin  #取最小日  No:9684
        CALL r912_comp('99',l_cmax,l_dmax) RETURNING l_dmax #取最大日  No:9684                 #------------------------------------------------
        #若最後異動日為null，就不列印此筆資料
        IF cl_null(l_dmax) THEN
           LET g_sta='n'
           RETURN l_amin,l_amax,l_bmin,l_bmax,l_cmin,l_cmax,l_dmin,l_dmax,g_sta
        ELSE
           RETURN l_amin,l_amax,l_bmin,l_bmax,l_cmin,l_cmax,l_dmin,l_dmax,g_sta
        END IF
END FUNCTION
#---------------------FUNCTION r912_comp()------------------------------
#傳入欲比較的兩個日期，以p_s來識別要比大或比小，回傳最大或最小的結果。
#有四種狀況需分別判斷..
FUNCTION r912_comp(p_s,p_x,p_d)
  DEFINE p_s LIKE type_file.num5,          #No.FUN-680121 SMALLINT#1 表示比小(起日) ; 99表示比大(訖日)
         p_x LIKE sfb_file.sfb81,  #A/B/C的日期
         p_d LIKE sfb_file.sfb81   #D的日期
 
  #1.  x= null and d=null
  #2.  x<>null and d=null
  IF (cl_null(p_x) AND cl_null(p_d)) AND
     ((NOT cl_null(p_x)) AND (cl_null(p_d))) THEN
      RETURN p_x
  END IF
  #3, x= null and d<>null
  IF (cl_null(p_x)) AND (NOT cl_null(p_d)) THEN
      RETURN p_d
  #4. x<>null and d<>null
  ELSE
     CASE p_s
         WHEN '1'  #比小
             IF p_x<=p_d THEN
                RETURN p_x
             ELSE
                RETURN p_d
             END IF
         WHEN '99' #比大
             IF p_x>=p_d THEN
                RETURN p_x
             ELSE
                RETURN p_d
             END IF
     END CASE
  END IF
END FUNCTION
