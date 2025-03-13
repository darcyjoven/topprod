# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: aimr409.4gl
# Descriptions...: 庫存數量表
# Input parameter:
# Return code....:
# Date & Author..: 95/02/10 By Nick
# Modify ........: No.FUN-4A0044 04/10/07 By Echo 料號, 倉庫,倉管員,計劃員開窗
# Modify.........: No.FUN-510017 05/01/11 By Mandy 報表轉XML
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-610072 06/03/08 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-660078 06/06/14 By rainy aim系統中，用char定義的變數，改為用LIKE
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.MOD-6C0030 06/12/06 By Sarah 選擇要做小計時，換算單位一定要輸入，否則不會列印小計資料
# Modify.........: No.MOD-710108 07/01/22 By pengu p500_抓不到換算單位, 應該先跳過該筆,繼續抓下面一筆
# Modify........:  NO.FUN-7A0036 07/10/30 By lilingyu 制作CR報表
# Modify........:  NO.CHI-980052 09/08/21 By mike 單位換算率抓不到的錯誤訊息請以s_errmsg的方式呈現                                  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-B30031 11/03/04 By destiny 输入完换算单位会进死循环
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                           # Print condition RECORD
           wc       STRING,                 # Where condition   #TQC-630166
           s        LIKE type_file.chr3,    # Order by sequence #No.FUN-690026 VARCHAR(4)
           t        LIKE type_file.chr3,    # Eject sw          #No.FUN-690026 VARCHAR(3)
           u        LIKE type_file.chr3,    # Group total sw    #No.FUN-690026 VARCHAR(3)
           #uom     VARCHAR(4),                # FUN-660078 remark 
           uom      LIKE gfe_file.gfe01,    # FUN-660078
           more     LIKE type_file.chr1     # Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
           END RECORD
 
DEFINE g_i LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE l_table STRING                   #暫存檔                  #FUN-7AOO36   
DEFINE g_str   STRING                   #組傳入cl_prt_cs3()參數  #FUN-7A0036       
DEFINE g_sql   STRING                   #抓取暫存盤資料sql       #FUN-7AOO36
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
 
   #NO.FUN-7A0036  --Begin
   #錄入CR所需的暫存檔
   LET g_sql="img01.img_file.img01,",
             "ima02.ima_file.ima02,",
             "ima021.ima_file.ima021,",
             "img04.img_file.img04,",
             "img02.img_file.img02,",                        
             "img03.img_file.img03,",
             "img09.img_file.img09,",
             "img10.img_file.img10,",
             "ima31_fac.ima_file.ima31_fac"
   LET l_table=cl_prt_temptable('aimr409',g_sql)CLIPPED
   IF  l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)EXIT PROGRAM
   END IF
   #NO.FUN-7A0036  --END      
 
   INITIALIZE tm.* TO NULL        #FUN-7A0036    
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   LET tm.uom  = ARG_VAL(11)      #TQC-610072 順序順推
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
  #IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
  # Prog. Version..: '5.30.06-13.03.12(0,0)        # Input print condition
  #ELSE CALL aimr409()            # Read data and create out-file
  #END IF
  #CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
   IF cl_null(tm.wc)
      THEN CALL aimr409_tm(0,0)
      ELSE CALL aimr409() 
   END IF  
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION aimr409_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_cmd          LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 17
 
   OPEN WINDOW aimr409_w AT p_row,p_col WITH FORM "aim/42f/aimr409"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '123'
   LET tm.u    = 'Y  '
   LET tm.uom  = ''
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
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
   CONSTRUCT BY NAME tm.wc ON img01,img02,img03,img04,ima23,ima67
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
        ON ACTION locale
            #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
         #### No.FUN-4A0044
        ON ACTION CONTROLP
             CASE
              WHEN INFIELD(img01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ima"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO img01
                NEXT FIELD img01
 
              WHEN INFIELD(img02)
                CALL cl_init_qry_var()
                LET g_qryparam.form="q_imd"
                LET g_qryparam.state = 'c'
                LET g_qryparam.arg1     = 'SW'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO img02
                NEXT FIELD img02
 
              WHEN INFIELD(ima23)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gen"
                LET g_qryparam.state = 'c'
                LET g_qryparam.arg1     = 'SW'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ima23
                NEXT FIELD ima23
 
              WHEN INFIELD(ima67)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gen"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ima67
                NEXT FIELD ima67
 
           END CASE
      ### END  No.FUN-4A0044
 
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
      LET INT_FLAG = 0 CLOSE WINDOW aimr409_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.more         # Condition
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,tm2.u1,tm2.u2,tm2.u3,tm.uom,tm.more WITHOUT DEFAULTS
      #No.B070 010322 by linda add----
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD uom
          IF NOT cl_null(tm.uom) THEN
             SELECT gfe01 FROM gfe_file
               WHERE gfe01=tm.uom
                 AND gfeacti IN ('y','Y')
             IF SQLCA.sqlcode THEN
#               CALL cl_err(tm.uom,'mfg1200',0) #No.FUN-660156
                CALL cl_err3("sel","gfe_file",tm.uom,"","mfg1200","","",0)  #No.FUN-660156
                 DISPLAY BY NAME tm.uom
                 NEXT FIELD uom
             END IF
          END IF
      #No.B070 end--------
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()    # Command execution
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(uom)
#              CALL q_gfe(10,3,tm.uom) RETURNING tm.uom
#              CALL FGL_DIALOG_SETBUFFER( tm.uom )
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_gfe'
               LET g_qryparam.default1 = tm.uom
               CALL cl_create_qry() RETURNING tm.uom
#               CALL FGL_DIALOG_SETBUFFER( tm.uom )
               DISPLAY BY NAME tm.uom
               NEXT FIELD uom
         END CASE
# BugNo.B070 end--------
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1[1,1],tm2.t2[1,1],tm2.t3[1,1]
         LET tm.u = tm2.u1[1,1],tm2.u2[1,1],tm2.u3[1,1]
        #start MOD-6C0030 add
         IF cl_null(tm.uom) AND
            (tm2.u1 != 'N' OR tm2.u2 != 'N' OR tm2.u3 != 'N') THEN   #要計算小計
            CALL cl_err('','mfg0037',0)
            NEXT FIELD uom
         END IF
        #end MOD-6C0030 add
 
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
      LET INT_FLAG = 0 CLOSE WINDOW aimr409_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aimr409'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr409','9031',1)
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
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",tm.uom CLIPPED,"'",               #TQC-610072
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr409',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW aimr409_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aimr409()
   ERROR ""
END WHILE
   CLOSE WINDOW aimr409_w
END FUNCTION
 
FUNCTION aimr409()
   DEFINE l_name    LIKE type_file.chr20,              # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
  #       l_time    LIKE type_file.chr8                #No.FUN-6A0074
          l_ima02   LIKE ima_file.ima02,               #FUN-7AOO36
          l_ima021  LIKE ima_file .ima021,             #FUN-7A0036  
          l_sql     STRING,                            # RDSQL STATEMENT   #TQC-630166
          l_chr     LIKE type_file.chr1,               #No.FUN-690026 VARCHAR(1)
          l_za05    LIKE za_file.za05,                 #No.FUN-690026 VARCHAR(40)
          l_i       LIKE type_file.num5,               #No.FUN-690026 SMALLINT
          l_order   ARRAY[5] OF LIKE ima_file.ima01,   #FUN-5B0105 10->40  #No.FUN-690026 VARCHAR(40)
          sr        RECORD order1 LIKE ima_file.ima01, #FUN-5B0105 10->40  #No.FUN-690026 VARCHAR(40)
                           order2 LIKE ima_file.ima01, #FUN-5B0105 10->40  #No.FUN-690026 VARCHAR(40)
                           order3 LIKE ima_file.ima01, #FUN-5B0105 10->40  #No.FUN-690026 VARCHAR(40)
                           img01 LIKE img_file.img01,  #
                           img02 LIKE img_file.img02,
                           img03 LIKE img_file.img03,
                           img04 LIKE img_file.img04,
                           img09 LIKE img_file.img09,
                           img10 LIKE img_file.img10,
                           rate  LIKE ima_file.ima31_fac,  #No.FUN-690026 DECIMAL(8,4)
                           m2    LIKE type_file.num10      #No.FUN-690026 INTEGER
                    END RECORD
    
     #清除暫存盤的資料
     CALL cl_del_data(l_table)                      #FUN-7A0036       
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #抓取是否打印條件
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='aimr409'  #FUN-7A0036 
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND imauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND imagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT '','','',",
                 "       img01,img02,img03,img04,img09,img10,1,0",
                 "  FROM img_file, ima_file ",
                 " WHERE ",tm.wc,
                 "   AND img10 > 0 ",
                 "   AND img01=ima01"
     PREPARE aimr409_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
           
     END IF
     DECLARE aimr409_curs1 CURSOR FOR aimr409_prepare1
 
#    CALL cl_outnam('aimr409') RETURNING l_name   #FUN-7A0036
 
#    START REPORT aimr409_rep TO l_name           #FUN-7A0036   
     CALL s_showmsg_init() #MOD-B30031
     FOREACH aimr409_curs1 INTO sr.*             
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
      #NO.FUN-7A0036   --Begin--
      SELECT ima02,ima021 INTO l_ima02,l_ima021                                                                             
        FROM ima_file                                                                                                       
        WHERE ima01 = sr.img01                                                                                               
      IF SQLCA.sqlcode THEN                                                                                                 
      LET l_ima02  = NULL                                                                                               
      LET l_ima021 = NULL                                                                                               
      END IF 
      #NO.FUN-7A0036  --End
 
      #-----做單位換算
       IF NOT cl_null(tm.uom) OR tm.uom !=' ' THEN
          CALL s_umfchk(sr.img01,sr.img09,tm.uom) RETURNING l_i,sr.rate
         #CHI-980052   ----start    
         #IF l_i THEN CALL cl_err('','abm-731',1)
          IF l_i THEN                                                                                                                
             LET g_showmsg=sr.img01,"/",sr.img09,"/",tm.uom                                                                          
             CALL s_errmsg('img01,img09,uom',g_showmsg,'','abm-731',1)                                                               
         #CHI-980052     ---end              
            #------No.MOD-710108 modify
            #EXIT FOREACH 
             CONTINUE FOREACH 
            #------No.MOD-710108 end
         END IF
       END IF
       LET sr.m2 = sr.img10 * sr.rate
      
      #NO.FUN-7A0036  --Begin-- 
      { FOR g_i = 1 TO 3
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.img01
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.img02
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.img03
               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.img04
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
      }
      #NO.FUN-7A0036  --End--
 
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
     
#      OUTPUT TO REPORT aimr409_rep(sr.*)  #NO.FUN-7A0036 
       
       EXECUTE insert_prep USING           #NO.FUN-7A0036
         sr.img01,l_ima02,l_ima021,
         sr.img04,sr.img02,sr.img03,
         sr.img09,sr.img10,sr.rate    
    END FOREACH
    CALL s_showmsg()          #No.MOD-B30031
    # FINISH REPORT aimr409_rep         #NO.FUN-7A0036 
   
   #NO.FUN-7A0036  --Begin--  
   #准備抓取暫存盤里的資料的SQL
   LET g_sql ="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   
   #是否打印選擇條件
   IF g_zz05='Y' THEN
      CALL cl_wcchp(tm.wc,'img01,img02,img03,img04,ima23,ima67')
      RETURNING tm.wc
      LET g_str=tm.wc  
   END IF
 
   #傳遞參數（最多可傳20組，有多個參數時用；區隔開）
   LET g_str=g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],
             ";",tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",
             tm.u[1,1],";",tm.u[2,2],";",tm.u[3,3],";",tm.uom           
                
   #  CALL cl_prt(l_name,g_prtway,g_copies,g_len)     #FUN-7A0036
   #與Crystal Reports串接
    CALL cl_prt_cs3('aimr409','aimr409',g_sql,g_str)  #FUN-7A0036
   #NO.FUN-7A0036  --End
END FUNCTION
 
#NO.FUN-7A0036  --Begin
{ REPORT aimr409_rep(sr)                             
   DEFINE l_ima02      LIKE ima_file.ima02                 #FUN-510017
   DEFINE l_ima021     LIKE ima_file.ima021                #FUN-510017
   DEFINE l_last_sw    LIKE type_file.chr1,                #No.FUN-690026 VARCHAR(1)
          sr           RECORD order1 LIKE ima_file.ima01,  #FUN-5B0105 10->40  #No.FUN-690026 VARCHAR(40)
                              order2 LIKE ima_file.ima01,  #FUN-5B0105 10->40  #No.FUN-690026 VARCHAR(40)
                              order3 LIKE ima_file.ima01,  #FUN-5B0105 10->40  #No.FUN-690026 VARCHAR(40)
                              img01 LIKE img_file.img01,   #
                              img02 LIKE img_file.img02,
                              img03 LIKE img_file.img03,
                              img04 LIKE img_file.img04,
                              img09 LIKE img_file.img09,
                              img10 LIKE img_file.img10,
                              rate  LIKE ima_file.ima31_fac,  #No.FUN-690026 DECIMAL(8,4)
                              m2    LIKE type_file.num10      #No.FUN-690026 INTEGER
                       END RECORD,
          l_qty        LIKE type_file.num10,   #No.FUN-690026 INTEGER
          l_chr        LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   BEFORE GROUP OF sr.order3
      IF tm.t[3,3] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   ON EVERY ROW
      SELECT ima02,ima021 INTO l_ima02,l_ima021
        FROM ima_file
       WHERE ima01 = sr.img01
      IF SQLCA.sqlcode THEN
          LET l_ima02  = NULL
          LET l_ima021 = NULL
      END IF
      PRINT COLUMN g_c[31],sr.img01,
            COLUMN g_c[32],l_ima02,
            COLUMN g_c[33],l_ima021,
            COLUMN g_c[34],sr.img04,
            COLUMN g_c[35],sr.img02,
            COLUMN g_c[36],sr.img03,
            COLUMN g_c[37],sr.img09,
            COLUMN g_c[38],cl_numfor(sr.img10,38,3),
            COLUMN g_c[39],sr.rate  USING '####.####',
            COLUMN g_c[40],cl_numfor(sr.m2,40,3)
 
   AFTER GROUP OF sr.order1
    IF NOT cl_null(tm.uom) OR tm.uom !=' ' THEN
      IF tm.u[1,1] = 'Y' THEN
         PRINT
         PRINT COLUMN g_c[36],g_x[21] CLIPPED,
               COLUMN g_c[38],cl_numfor(GROUP SUM(sr.img10),38,3),
               COLUMN g_c[40],cl_numfor(GROUP SUM(sr.m2   ),40,3)
         PRINT g_dash2
      END IF
    END IF
 
   AFTER GROUP OF sr.order2
    IF NOT cl_null(tm.uom) OR tm.uom !=' ' THEN
      IF tm.u[2,2] = 'Y' THEN
         PRINT
         PRINT COLUMN g_c[36],g_x[21] CLIPPED,
               COLUMN g_c[38],cl_numfor(GROUP SUM(sr.img10),38,3),
               COLUMN g_c[40],cl_numfor(GROUP SUM(sr.m2   ),40,3)
         PRINT g_dash2
      END IF
     END IF
 
  #start MOD-6C0030 add
   AFTER GROUP OF sr.order3
    IF NOT cl_null(tm.uom) OR tm.uom !=' ' THEN
       IF tm.u[3,3] = 'Y' THEN
          PRINT
          PRINT COLUMN g_c[36],g_x[21] CLIPPED,
                COLUMN g_c[38],cl_numfor(GROUP SUM(sr.img10),38,3),
                COLUMN g_c[40],cl_numfor(GROUP SUM(sr.m2   ),40,3)
          PRINT g_dash2
       END IF
    END IF
  #end MOD-6C0030 add
 
   ON LAST ROW
    IF NOT cl_null(tm.uom) OR tm.uom !=' ' THEN
         PRINT COLUMN g_c[36],g_x[22] CLIPPED,
               COLUMN g_c[38],cl_numfor(SUM(sr.img10),38,3),
               COLUMN g_c[40],cl_numfor(SUM(sr.m2   ),40,3)
         PRINT g_dash2
    END IF
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'img01,img02,img03,img04,img23,img15')
              RETURNING tm.wc
         PRINT g_dash
       #TQC-630166
       #       IF tm.wc[001,070] > ' ' THEN            # for 80
       #  PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
       #       IF tm.wc[071,140] > ' ' THEN
       #  PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
       #       IF tm.wc[141,210] > ' ' THEN
       #  PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
       #       IF tm.wc[211,280] > ' ' THEN
       #  PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
       CALL cl_prt_pos_wc(tm.wc)
       #END TQC-630166
 
      END IF
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[40], g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[40], g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
}                      
#NO.FUN-7A0036   --End--
