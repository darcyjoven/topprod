# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: axcr701.4gl
# Descriptions...: 材料進貨資料明細表-依傳票別
# Input parameter: 
# Return code....: 
# Date & Author..: 98/05/04 By Star
# Modify ........: No:8741 03/11/25 By Melody 修改PRINT段
# Modify ........: No.MOD-4B0037 03/11/11 By ching set_entry錯誤修改
# Modify.........: No.FUN-4C0099 04/12/31 By kim 報表轉XML功能
# Modify.........: No.MOD-530181 05/03/23 By kim Define金額單價位數改為DEC(20,6)
# Modify.........: No.FUN-550025 05/05/19 By elva 單據編號格式放大
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-570190 05/08/06 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.MOD-570081 05/07/05 By kim 沒有進行單位換算(tlf10->tlf10*tlf60)
# Modify.........: NO.FUN-5B0105 05/12/27 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610051 06/02/23 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換 
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-690007 06/12/27 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.FUN-730057 07/04/02 By bnlent 會計科目加帳套
# Modify.........: No.MOD-7C0212 07/12/27 By Pengu 調整sr.order1變數宣告的資料型態
# Modify.........: No.FUN-7C0101 08/01/30 By douzh 成本改善功能增加成本計算類型(type)
# Modify.........: No.FUN-830002 08/03/03 By lala    WHERE條件修改
# Modify.........: No.MOD-820016 08/03/23 By Pengu PRINT時加上CLIPPED
# Modify.........: No.TQC-970186 09/07/22 By destiny 修改GROUP BY 的寫法,用s_groupby去掉空字段                                      
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B10052 11/01/27 By lilingyu 科目查詢自動過濾
# Modify.........: No:CHI-C30012 12/07/30 By bart 金額取位改抓ccz26
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                    # Print condition RECORD
              wc      STRING,           # Where condition #TQC-630166
              abb03   LIKE abb_file.abb03,
              bdate,edate LIKE type_file.dat,        #No.FUN-680122DATE
              type    LIKE type_file.chr1,           #No.FUN-7C0101
              a       LIKE type_file.chr1,           #No.FUN-680122CHAR(01)
              n       LIKE type_file.chr1,           #No.FUN-680122CHAR(01)
              b       LIKE type_file.chr1,           #No.FUN-680122CHAR(01)
              s,t,u   LIKE type_file.chr4,           #No.FUN-680122CHAR(04)
              more    LIKE type_file.chr1            # Prog. Version..: '5.30.06-13.03.12(01)        # Input more condition(Y/N)
              END RECORD,
           g_wc   string, #For apa  #No.FUN-580092 HCN
           g_wc1  string, #For ale  #No.FUN-580092 HCN
          m_flag LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE   g_before_input_done LIKE type_file.num5          #No.FUN-680122 SMALLINT
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo 
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   LET tm.type  = ARG_VAL(19)       #No.FUN-7C0101
   LET tm.n     = ARG_VAL(10)
   LET tm.b     = ARG_VAL(11)
   LET tm.s     = ARG_VAL(12)
   LET tm.t     = ARG_VAL(13)
   LET tm.u     = ARG_VAL(14)
   LET tm.abb03 = ARG_VAL(15)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(16)
   LET g_rep_clas = ARG_VAL(17)
   LET g_template = ARG_VAL(18)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL axcr701_tm(0,0)        # Input print condition
      ELSE CALL axcr701()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr701_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col,l_cnt    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680122CHAR(400)
 
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 11 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 2 LET p_col = 20
   ELSE LET p_row = 3 LET p_col = 11
   END IF
   OPEN WINDOW axcr701_w AT p_row,p_col
        WITH FORM "axc/42f/axcr701" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   CALL s_azn01(g_ccz.ccz01,g_ccz.ccz02) RETURNING tm.bdate,tm.edate
   LET tm.s    = '123'
   LET tm.n    = 'Y'
   LET tm.b    = '4'
   LET tm.more = 'N'
   LET tm.type = g_ccz.ccz28          #No.FUN-7C0101
   LET g_pdate= g_today
   LET g_rlang= g_lang
   LET g_bgjob= 'N'
   LET g_copies= '1'
   #genero版本default 排序值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   LET tm2.u3   = tm.u[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ima12,ima57,ima08,
                              tlf01,tlf905,tlf906,tlf19,tlf65 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION locale
        #CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
         
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
#No.FUN-570240 --start                                                          
     ON ACTION controlp                                                      
        IF INFIELD(tlf01) THEN                                              
           CALL cl_init_qry_var()                                           
           LET g_qryparam.form = "q_tlf"                                    
           LET g_qryparam.state = "c"                                       
           CALL cl_create_qry() RETURNING g_qryparam.multiret               
           DISPLAY g_qryparam.multiret TO tlf01                             
           NEXT FIELD tlf01                                                 
        END IF                                                              
#No.FUN-570240 --end     
 
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
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
    IF INT_FLAG THEN
       LET INT_FLAG = 0 CLOSE WINDOW axcr701_w 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
       EXIT PROGRAM
          
    END IF
 
    IF g_action_choice = "locale" THEN
       LET g_action_choice = ""
       CALL cl_dynamic_locale()
       CONTINUE WHILE
    END IF
 
#   DISPLAY BY NAME tm.bdate,tm.edate,tm.type,tm.n,tm.b,tm.s,tm.t,tm.u,tm.more      #No.FUN-7C0101     #No.TQC-970186
    DISPLAY BY NAME tm.bdate,tm.edate,tm.type,tm.n,tm.b,tm.more                     #No.TQC-970186                                   
     
   INPUT BY NAME tm.bdate,tm.edate,tm.type,tm.n,tm.abb03,tm.b,                    #No.FUN-7C0101 
                 tm2.s1,tm2.s2,tm2.s3,
                 tm2.t1,tm2.t2,tm2.t3,
                 tm2.u1,tm2.u2,tm2.u3,
                 tm.more 
   WITHOUT DEFAULTS 
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL r701_set_entry()
         CALL r701_set_no_entry()
         LET g_before_input_done = TRUE
 
         #No.FUN-580031 --start--
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD edate
         IF tm.edate IS NULL OR tm.edate < tm.bdate THEN NEXT FIELD edate END IF
 
       AFTER FIELD type                                                            #No.FUN-7C0101
         IF tm.type NOT MATCHES '[12345]' THEN NEXT FIELD type END IF              #No.FUN-7C0101
 
      BEFORE FIELD n 
         CALL r701_set_entry()
 
      AFTER FIELD n 
         IF cl_null(tm.n) THEN NEXT FIELD n END IF 
         IF tm.n NOT MATCHES '[YN]' THEN NEXT FIELD n END IF
         CALL r701_set_no_entry()
 
  
      AFTER FIELD abb03
         IF NOT cl_null(tm.abb03) THEN 
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM aag_file
             WHERE aag01 = tm.abb03 AND aagacti = 'Y'
                                    AND aag00 = g_aza.aza81   #No.FUN-730057
            IF l_cnt IS NULL THEN LET l_cnt = 0 END IF 
            IF STATUS OR l_cnt = 0 THEN
#FUN-B10052 --begin--
#              CALL cl_err(tm.abb03,'agl-001',1)
               CALL cl_err(tm.abb03,'agl-001',0)

                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_aag'
                   LET g_qryparam.default1 = tm.abb03
                   LET g_qryparam.arg1 = g_aza.aza81      
                   LET g_qryparam.construct = 'N'
                   LET g_qryparam.where = " aag01 LIKE '",tm.abb03 CLIPPED,"%'"
                   CALL cl_create_qry() RETURNING tm.abb03
                   DISPLAY BY NAME tm.abb03
#FUN-B10052 --end--
               NEXT FIELD abb03 
            END IF 
            LET tm.b = '4' DISPLAY BY NAME tm.b NEXT FIELD more
         END IF
 
      AFTER FIELD b 
         IF cl_null(tm.b) THEN NEXT FIELD b END IF 
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      ON ACTION CONTROLP
         CASE WHEN INFIELD(abb03) # Account number
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_aag'
                   LET g_qryparam.default1 = tm.abb03
                   LET g_qryparam.arg1 = g_aza.aza81      #No.FUN-730057
                   CALL cl_create_qry() RETURNING tm.abb03
                   DISPLAY BY NAME tm.abb03 
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
 
      AFTER INPUT  
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1[1,1],tm2.t2[1,1],tm2.t3[1,1]
         LET tm.u = tm2.u1[1,1],tm2.u2[1,1],tm2.u3[1,1]
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr701_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axcr701'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr701','9031',1)   
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
                         #TQC-610051-begin
                         " '",tm.bdate CLIPPED,"'" ,                 
                         " '",tm.edate CLIPPED,"'" ,                 
                         #TQC-610051-end
                         " '",tm.type CLIPPED,"'"  ,            #No.FUN-7C0101
                         " '",tm.n CLIPPED,"'"  ,
                         " '",tm.b CLIPPED,"'"  ,
                         " '",tm.s CLIPPED,"'"  ,
                         " '",tm.t CLIPPED,"'"  ,
                         " '",tm.u CLIPPED,"'"  ,
                         #TQC-610051-begin
                         " '",tm.abb03 CLIPPED,"'" ,                 
                         #TQC-610051-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('axcr701',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr701_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr701()
   ERROR ""
END WHILE
   CLOSE WINDOW axcr701_w
END FUNCTION
 
FUNCTION axcr701()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680122CHAR(20)      #External(Disk) file name
#         l_time    LIKE type_file.chr8           #No.FUN-6A0146
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT           #No.FUN-680122CHAR(1500)
          l_chr     LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_flag    LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(40)
          l_title   LIKE type_file.chr1000,       #No.FUN-680122CHAR(100)
          l_order    ARRAY[5] OF LIKE type_file.chr50,       #No.FUN-680122CHAR(40)#No.FUN-550025 #FUN-5B0105 16->40  #No.MOD-7C0212 modify
          l_abb06   LIKE abb_file.abb06,
          l_abb07   LIKE abb_file.abb07,
          l_tlf21   LIKE tlf_file.tlf21,
          l_tlfc21  LIKE tlfc_file.tlfc21,         #FUN-7C0101
          l_tlf65   LIKE tlf_file.tlf65,
          l_tlf21x  LIKE tlf_file.tlf21,
          l_fromplant    LIKE azp_file.azp03,
          bdate,edate      LIKE type_file.dat,           #No.FUN-680122DATE
          sr               RECORD 
                                 #---------------No.MOD-7C0212 modify
                                  order1     LIKE type_file.chr50,       #No.FUN-680122 VARCHAR(40) #FUN-5B0105 20->40
                                  order2     LIKE type_file.chr50,       #No.FUN-680122 VARCHAR(40) #FUN-5B0105 20->40 
                                  order3     LIKE type_file.chr50,       #No.FUN-680122 VARCHAR(40) #FUN-5B0105 20->40
                                 #---------------No.MOD-7C0212 end
                                  tlf01      LIKE tlf_file.tlf01,    #料號
                                  tlfccost   LIKE tlfc_file.tlfccost,#類別編號    #No.FUN-7C0101
                                  ima12      LIKE ima_file.ima12,    #分群碼 
                                  tlf905     LIKE tlf_file.tlf905,   #入庫單號 
                                  tlf906     LIKE tlf_file.tlf906,   #項次 
                                  tlf19      LIKE tlf_file.tlf19,    #廠商
                                  pmc03      LIKE pmc_file.pmc03,    #廠商簡稱
                                  tlf65      LIKE tlf_file.tlf65,    #傳票
                                  tlf10      LIKE tlf_file.tlf10,    #入庫數量
                                  tlfc21     LIKE tlfc_file.tlfc21   #入庫金額    #No.FUN-7C0101
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #--->本功能用於抓帳
     DROP TABLE r701_tmp
#No.FUN-680122 
#     CREATE  TABLE r701_tmp
#            (part VARCHAR(20),
#             amt1 DEC(20,6));
     CREATE TEMP TABLE r701_tmp
            (part LIKE tlf_file.tlf01,
             amt1 LIKE type_file.num20_6);
#No.FUN-680122 
     create unique index r701_01 on r701_tmp (part);
 
     CASE tm.b
         WHEN '1' LET l_title = " tlf01,ima12,tlf905,tlf906,tlf19,pmc03,tlf65 "
         WHEN '2' LET l_title = "   ' ',' '  ,tlf905,tlf906,tlf19,pmc03,tlf65 "
         WHEN '3' LET l_title = "   ' ',' '  ,' '   ,'0'     ,tlf19,pmc03,tlf65 "   #FUN-830002
         WHEN '4' LET l_title = "   ' ',' '  ,' '   ,'0'     ,' '  ,' '  ,tlf65 "   #FUN-830002
     END CASE 
 
        LET l_sql = "SELECT '','','', ",l_title CLIPPED ,  
                  "       ,tlfccost,SUM(tlf10*tlf60*tlf907),SUM(tlfc21*tlf907) ", #MOD-570081 #No.FUN-7C0101 tlf21-->tlfc21,add tlfccost
                 "  FROM tlf_file LEFT OUTER JOIN  tlfc_file ON tlf01=tlfc01 AND tlf02=tlfc02 AND tlf03=tlfc03 AND tlf06=tlfc06 AND tlf13=tlfc13 AND tlf902=tlfc902 AND tlf903=tlfc903 AND tlf904=tlfc904 AND tlf905=tlfc905 AND tlf906=tlfc906 AND tlf907=tlfc907 AND tlfctype = '",tm.type,"' LEFT OUTER JOIN pmc_file ON tlf19=pmc01, ima_file",     #No.FUN-7C0101
                 " WHERE (tlf06 >= '",tm.bdate,"' AND tlf06 <= '",tm.edate,"') ",
                 "   AND tlf65 IS NOT NULL ",
                 "   AND tlf65 != ' ' AND ima01 = tlf01",
                 "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)", #JIT除外
                 "   AND ",tm.wc clipped,
#                " GROUP BY '','',''," ,l_title ,",tlfccost",             #No.FUN-7C0101           #No.TQC-970186                           
                 " GROUP BY ",s_groupby(l_title CLIPPED)," ,tlfccost ",                    #No.TQC-970186                           
#                " ORDER BY '','',''," ,l_title ,",tlfccost"              #No.FUN-7C0101           #No.TQC-970186                           
                 " ORDER BY ",s_groupby(l_title CLIPPED)," ,tlfccost "                     #No.TQC-970186                           
 
     PREPARE axcr701_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
       EXIT PROGRAM    
          
     END IF
     DECLARE axcr701_curs1 CURSOR FOR axcr701_prepare1
 
     SELECT azp03 into l_fromplant from azp_file where azp01 = g_plant
     LET l_fromplant = s_dbstring(l_fromplant CLIPPED)
 
     LET l_sql = "SELECT abb06,SUM(abb07) FROM aba_file,abb_file",
                 " WHERE aba00 = abb00 AND aba01= abb01 ",
                 " AND aba01 = ? ", 
                 " AND abb03 = '",tm.abb03,"' ",
                 " GROUP BY abb06 "
     PREPARE r020_preabb  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
       EXIT PROGRAM    
          
     END IF
     DECLARE r020_curabb CURSOR FOR r020_preabb 
 
     CALL cl_outnam('axcr701') RETURNING l_name
 
#No.FUN-7C0101--begin
     IF tm.type MATCHES '[12]' THEN
        LET g_zaa[38].zaa06 = "Y" 
     ELSE
        LET g_zaa[38].zaa06 = "N"
     END IF
     CALL cl_prt_pos_len()
#No.FUN-7C0101--end
 
     START REPORT axcr701_rep TO l_name
 
     LET g_pageno = 0  LET l_tlfc21 = 0 
     FOREACH axcr701_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH 
       END IF
       IF sr.tlf65 IS NULL THEN LET sr.tlf65 = ' ' END IF 
       IF sr.tlf10 IS NULL THEN LET sr.tlf10 = 0 END IF 
       IF sr.tlfc21 IS NULL THEN LET sr.tlfc21 = 0 END IF                  #No.FUN-7C0101
       MESSAGE 'TRS+Vendor->',sr.tlf65,"|",sr.tlf905
       CALL ui.Interface.refresh()
       IF tm.n = 'Y' THEN # 僅以傳票彙總比較
          LET l_abb06 = '' LET l_abb07 = 0 LET l_tlfc21 = 0                #No.FUN-7C0101
          FOREACH r020_curabb USING sr.tlf65 INTO l_abb06,l_abb07
              IF l_abb06 = '2' THEN LET l_abb07 = l_abb07 * -1 END IF 
              LET l_tlfc21 = l_tlfc21 + l_abb07                            #No.FUN-7C0101 
          END FOREACH 
          IF l_tlfc21 IS NULL THEN LET l_tlfc21 = 0 END IF                 #No.FUN-7C0101
          IF sr.tlfc21 = l_tlfc21 THEN CONTINUE FOREACH END IF             #No.FUN-7C0101
       END IF 
 
       FOR g_i = 1 TO 3
           CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.tlf01
                WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.tlf905 #,
                                #            sr.tlf906 USING '&&&'
                WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.tlf19
                WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.tlf65
                OTHERWISE LET l_order[g_i] = '-'
           END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
 
       #--->本功能用於抓帳
       INSERT INTO r701_tmp VALUES(sr.tlf01,sr.tlfc21) #No.FUN-7C0101
       IF SQLCA.sqlcode THEN 
          UPDATE r701_tmp SET amt1 = amt1 + sr.tlfc21 #No.FUN-7C0101
                          WHERE part = sr.tlf01
       END IF
      
       OUTPUT TO REPORT axcr701_rep(sr.*,l_tlfc21)  #No.FUN-7C0101
     END FOREACH
     FINISH REPORT axcr701_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
#No.8741
REPORT axcr701_rep(sr,l_tlfc21)
   DEFINE l_last_sw    LIKE type_file.chr1,          #No.FUN-680122CHAR(01)
          l_tlfc21      LIKE tlfc_file.tlfc21,        #No.FUN-7C0101
          l_ima02      LIKE ima_file.ima02,
          l_ima021      LIKE ima_file.ima021,
          l_tmpstr   STRING,
       sr               RECORD 
                                 #---------------No.MOD-7C0212 modify
                                  order1     LIKE type_file.chr50,       #No.FUN-680122CHAR(40) #FUN-5B0105 20->40
                                  order2     LIKE type_file.chr50,       #No.FUN-680122CHAR(40) #FUN-5B0105 20->40
                                  order3     LIKE type_file.chr50,       #No.FUN-680122CHAR(40) #FUN-5B0105 20->40
                                 #---------------No.MOD-7C0212 end
                                  tlf01 LIKE tlf_file.tlf01,   #料號
                                  ima12 LIKE ima_file.ima12,   #分群碼 
                                  tlf905 LIKE tlf_file.tlf905, #入庫單號 
                                  tlf906 LIKE tlf_file.tlf906, #項次 
                                  tlf19 LIKE tlf_file.tlf19,   #廠商
                                  pmc03 LIKE pmc_file.pmc03,   #廠商簡稱
                                  tlf65 LIKE tlf_file.tlf65,   #傳票
                                  tlfccost   LIKE tlfc_file.tlfccost,#類別編號    #No.FUN-7C0101
                                  tlf10 LIKE tlf_file.tlf10,   #入庫數量
                                  tlfc21 LIKE tlfc_file.tlfc21  #入庫金額         #No.FUN-7C0101
                        END RECORD,
      l_chr        LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_x[16],tm.type
      PRINT g_head CLIPPED,pageno_total
      LET l_tmpstr=g_x[15] CLIPPED,tm.bdate ,' - ' ,tm.edate
      PRINT COLUMN ((g_len-FGL_WIDTH(l_tmpstr))/2)+3,l_tmpstr
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
            g_x[41],g_x[42]                                #No.FUN-7C0101
      PRINT g_dash1 
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
   BEFORE GROUP OF sr.order3
      IF tm.t[3,3] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   ON EVERY ROW
      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file 
         WHERE ima01=sr.tlf01
      IF SQLCA.sqlcode THEN 
         LET l_ima02 = NULL 
         LET l_ima021 = NULL 
      END IF
 
      PRINT COLUMN g_c[31],sr.ima12 CLIPPED,     #No.MOD-820016 add clipped
            COLUMN g_c[32],sr.tlf65 CLIPPED,     #No.MOD-820016 add clipped
            COLUMN g_c[33],sr.tlf19 CLIPPED,     #No.MOD-820016 add clipped
            COLUMN g_c[34],sr.pmc03 CLIPPED,     #No.MOD-820016 add clipped
            COLUMN g_c[35],sr.tlf01 CLIPPED,     #No.MOD-820016 add clipped
            COLUMN g_c[36],l_ima02  CLIPPED,     #No.MOD-820016 add clipped
            COLUMN g_c[37],l_ima021 CLIPPED,     #No.MOD-820016 add clipped
            COLUMN g_c[38],sr.tlfccost CLIPPED,  #No.FUN-7C0101
            COLUMN g_c[39],sr.tlf905 CLIPPED,    #No.MOD-820016 add clipped
            COLUMN g_c[40],sr.tlf906 USING '###&', #FUN-590118
            COLUMN g_c[41],cl_numfor(sr.tlf10,41,g_ccz.ccz27), #CHI-690007
            COLUMN g_c[42],cl_numfor(sr.tlfc21,42,g_ccz.ccz26)      #FUN-570190 #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
      IF tm.n = 'Y' THEN 
         PRINT COLUMN g_c[31],g_x[13] CLIPPED,
               COLUMN g_c[32],cl_numfor(l_tlfc21,32,g_ccz.ccz26), #CHI-690007 2->g_azi03  #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
               COLUMN g_c[33],g_x[14] CLIPPED,
               COLUMN g_c[34],cl_numfor(l_tlfc21-sr.tlfc21,34,g_ccz.ccz26)  #FUN-570190 #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
      END IF 
 
   AFTER GROUP OF sr.order1
      IF tm.u[1,1] = 'Y' THEN
         PRINT COLUMN g_c[40],g_x[11] CLIPPED,
               COLUMN g_c[41],cl_numfor(GROUP SUM(sr.tlf10),41,g_ccz.ccz27), #CHI-690007
               COLUMN g_c[42],cl_numfor(GROUP SUM(sr.tlfc21),42,g_ccz.ccz26)      #FUN-570190    #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
      END IF
 
   AFTER GROUP OF sr.order2
      IF tm.u[2,2] = 'Y' THEN
         PRINT COLUMN g_c[40],g_x[11] CLIPPED,
               COLUMN g_c[41],cl_numfor(GROUP SUM(sr.tlf10),41,g_ccz.ccz27), #CHI-690007
               COLUMN g_c[42],cl_numfor(GROUP SUM(sr.tlfc21),42,g_ccz.ccz26)      #FUN-570190    #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
      END IF
 
   AFTER GROUP OF sr.order3
      IF tm.u[3,3] = 'Y' THEN
         PRINT COLUMN g_c[40],g_x[11] CLIPPED,
               COLUMN g_c[41],cl_numfor(GROUP SUM(sr.tlf10),41,g_ccz.ccz27), #CHI-690007
               COLUMN g_c[42],cl_numfor(GROUP SUM(sr.tlfc21),42,g_ccz.ccz26)      #FUN-570190    #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
      END IF
 
   ON LAST ROW  
         PRINT COLUMN g_c[40],g_x[12] CLIPPED;
         PRINT COLUMN g_c[41],cl_numfor(SUM(sr.tlf10),41,g_ccz.ccz27), #CHI-690007
               COLUMN g_c[42],cl_numfor(SUM(sr.tlfc21),42,g_ccz.ccz26)      #FUN-570190          #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
      IF tm.n = 'Y' THEN 
         PRINT COLUMN g_c[31],g_x[13] CLIPPED,
               COLUMN g_c[32],cl_numfor(SUM(l_tlfc21),32,g_ccz.ccz26), #CHI-690007 0->azi03      #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
               COLUMN g_c[33],g_x[19] CLIPPED,
               COLUMN g_c[34],cl_numfor(SUM(l_tlfc21-sr.tlfc21),34,g_ccz.ccz26)     #FUN-570190  #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
      END IF 
 
         PRINT g_dash
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'ima01,apa44,tlf19')
              RETURNING tm.wc
         PRINT g_dash2
              #TQC-630166 Start
              #IF tm.wc[001,80] > ' ' THEN     
         #PRINT g_x[8] CLIPPED,tm.wc[001,80] CLIPPED END IF
              CALL cl_prt_pos_wc(tm.wc)
              #TQC-630166 End
      END IF
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED #CHI-690007
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #CHI-690007
         ELSE SKIP 2 LINE
      END IF
#No.8741(END)
END REPORT
FUNCTION change_string(old_string, old_sub, new_sub)
DEFINE query_text   LIKE type_file.chr1000       #No.FUN-680122char(300)
DEFINE AA           LIKE type_file.chr1          #No.FUN-680122CHAR(01)
 
DEFINE old_string   LIKE type_file.chr1000,       #No.FUN-680122char(300)
       xxx_string   LIKE type_file.chr1000,       #No.FUN-680122char(300)
       old_sub      LIKE type_file.chr1000,       #No.FUN-680122char(128)
       new_sub      LIKE type_file.chr1000,       #No.FUN-680122char(128)
       first_byte   LIKE type_file.chr1,          #No.FUN-680122CHAR(01)
       nowx_byte    LIKE type_file.chr1,          #No.FUN-680122CHAR(01)
       next_byte    LIKE type_file.chr1,          #No.FUN-680122CHAR(01)
       this_byte    LIKE type_file.chr1,          #No.FUN-680122CHAR(01)
       length1, length2, length3   LIKE type_file.num5,           #No.FUN-680122smallint
                     pu1, pu2      LIKE type_file.num5,           #No.FUN-680122smallint
       ii, jj, kk, ff, tt          LIKE type_file.num5            #No.FUN-680122smallint
 
LET length1 = length(old_string)
LET length2 = length(old_sub)
LET length3 = length(new_sub)
LET first_byte = old_sub[1,1]
LET xxx_string = " "
let pu1 = 0
 
FOR ii = 1 TO length1
    LET this_byte = old_string[ii, ii]
    LET nowx_byte = this_byte
    IF this_byte = first_byte THEN
        FOR jj = 2 TO length2
            let this_byte = old_string[ ii + jj - 1, ii + jj - 1]
            let next_byte = old_sub[ jj, jj]
            IF this_byte <> next_byte THEN
                let jj = 29999
                exit for
            END IF
        END FOR
        IF jj < 29999 THEN
           let pu1 = pu1 + 1
           let pu2 = pu1 + length3 - 1
           LET xxx_string[pu1, pu2] = new_sub CLIPPED
           LET ii = ii + length2 - 1
           LET pu1 = pu2
        ELSE
            let pu1 = pu1 + 1
            LET xxx_string[pu1,pu1] = nowx_byte
        END IF
    ELSE
        LET pu1 = pu1 + 1
        LET xxx_string[pu1,pu1] = nowx_byte
    END IF
end for
let query_text = xxx_string
RETURN query_text
END FUNCTION
 
 #MOD-4B0073
FUNCTION r701_set_entry()
 
   CALL cl_set_comp_entry("abb03",TRUE)
 
END FUNCTION
 
FUNCTION r701_set_no_entry()
 
   IF tm.n='N' THEN
      CALL cl_set_comp_entry("abb03",FALSE)
   END IF
 
END FUNCTION
#--
 
