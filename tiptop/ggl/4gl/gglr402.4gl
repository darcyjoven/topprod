# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: gglr402.4gl
# Descriptions...: 總分類帳
# Input parameter:
# Return code....:
# Date & Author..: 06/10/12 By chenl
# Modify.........: 06/12/21 No.FUN-6C0012 By chenl 修正程序編輯日期，規範作者名稱標注。
# Modify.........: No.FUN-6C0012 06/12/29 By Judy 報表打印額外名稱
# Modify.........: No.FUN-710090 07/02/01 By chenl 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730113 07/03/26 By Nicole 增加CR參數
# Modify.........: No.FUN-740055 07/04/13 By sherry 會計科目加帳套
# Modify.........: No.MOD-860252 08/07/03 By chenl  增加打印時是否打印貨幣性科目或全部科目的選擇。
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A40020 10/04/09 By Carrier 独立科目层及设置为1
# Modify.........: No.FUN-B20010 11/02/18 By yinhy 先選擇帳套，根據帳套判斷科目開窗開哪個帳套的科目資料
# Modify.........: No.TQC-B30147 11/03/18 By yinhy 查詢條件為空，跳到科目編號欄位
# Modify.........: No.CHI-B40058 11/05/16 By JoHung 修改有使用到apy/gpy模組p_ze資料的程式
# Modify.........: No:FUN-B80096 11/08/10 By Lujh 模組程序撰寫規範修正
# Modify.........: No.TQC-C10039 12/01/13 By JinJJ  CR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.MOD-C20064 12/02/09 By JinJJ  CR報表列印TIPTOP與EasyFlow簽核圖片还原
# Modify.........: No.TQC-C30136 12/03/08 By fengrui 處理ON ACITON衝突問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD
	     wc        STRING,		
             a         LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
             lvl1      LIKE type_file.num10,
             lvl2      LIKE type_file.num10,
             b         LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
             c         LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)   #TQC-610056
             d         LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
             e         LIKE type_file.chr1,    #NO FUN-690009   SMALLINT
             f         LIKE type_file.chr1,    #FUN-6C0012
             h         LIKE type_file.chr1,    #MOD-860252
             more      LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)
          END RECORD,
     yy,mm1,mm2        LIKE type_file.num10,   #NO FUN-690009   INTEGER
     y1,mm             LIKE type_file.num10,   #NO FUN-690009   INTEGER
     bookno            LIKE aaa_file.aaa01,    #帳別
     l_flag            LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)
DEFINE   g_t           LIKE type_file.num5
DEFINE   g_aag01       LIKE aag_file.aag01
DEFINE   g_aaa03       LIKE aaa_file.aaa03
DEFINE   g_cnt         LIKE type_file.num10    #NO FUN-690009   INTEGER
DEFINE   g_i           LIKE type_file.num5     #NO FUN-690009   SMALLINT   #count/index for any purpose   
#No.FUN-710090--begin-- 
DEFINE   g_sql         STRING
DEFINE   g_str         STRING
DEFINE   l_table       STRING
#No.FUN-710090--end--
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
 
  #No.FUN-710090--begin--
   LET g_sql="aag01.aag_file.aag01,",
             "aag02.aag_file.aag02,",
             "mm.aah_file.aah03,",
             "debit.aah_file.aah04,",
             "credit.aah_file.aah05,",
             "qmye.aah_file.aah05,",
             "stat.type_file.chr1,",
             "yy.type_file.num10,",
             "azi04.azi_file.azi04,",
             "i.type_file.num10"
#              ,"sign_type.type_file.chr1, sign_img.type_file.blob,",    #簽核方式, 簽核圖檔     #TQC-C10039 #MOD-C20064 Mark TQC-C10039
#              "sign_show.type_file.chr1,sign_str.type_file.chr1000"    #是否顯示簽核資料(Y/N)  #TQC-C10039  #MOD-C20064 Mark TQC-C10039
 
   LET l_table = cl_prt_temptable('gglr402',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
#               " VALUES(?,?,?,?,?,?,?,?,?,?, ?,?,?,?)"  #TQC-C10039 add 4?  #MOD-C20064 Mark TQC-C10039
                " VALUES(?,?,?,?,?,?,?,?,?,?)" 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
  #No.FUN-710090--end--
 
  #LET g_t = 2.5
   LET bookno= ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)            # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc = ARG_VAL(8)
   LET tm.a  = ARG_VAL(9)
   LET tm.b  = ARG_VAL(10)
   LET tm.c  = ARG_VAL(11)   
   LET tm.d  = ARG_VAL(12)
   LET tm.e  = ARG_VAL(13)
   LET yy    = ARG_VAL(14)   
   LET mm1   = ARG_VAL(15)  
   LET mm2   = ARG_VAL(16)
   LET tm.lvl1  = ARG_VAL(17)
   LET tm.lvl2  = ARG_VAL(18) 
   LET g_rep_user = ARG_VAL(19)
   LET g_rep_clas = ARG_VAL(20)
   LET g_template = ARG_VAL(21)
   LET g_rpt_name = ARG_VAL(22)  #No.FUN-7C0078
 
   IF bookno IS  NULL OR bookno = ' ' THEN
#     LET bookno = g_aaz.aaz64
      LET bookno = g_aza.aza81      #No.FUN-740055
   END IF
 
   #-->使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = bookno
   IF SQLCA.sqlcode THEN
      LET g_aaa03 = g_aza.aza17
   END IF
 
   SELECT azi04,azi05 INTO g_azi04,g_azi05 FROM azi_file WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","",0)   
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80096   ADD 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL gglr402_tm()
   ELSE
      CALL gglr402()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
END MAIN
 
FUNCTION gglr402_tm()
DEFINE p_row,p_col         LIKE type_file.num5,    
       l_cmd               LIKE type_file.chr1000  
DEFINE l_aaaacti           LIKE aaa_file.aaaacti
DEFINE li_chk_bookno LIKE type_file.num5   #FUN-B20010
 
   CALL s_dsmark(bookno)
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW gglr402_w AT p_row,p_col
     WITH FORM "ggl/42f/gglr402"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   CALL s_shwact(0,0,bookno)
   CALL cl_opmsg('p')
   SELECT azn02,azn04 INTO y1,mm FROM azn_file WHERE azn01 = g_today
   INITIALIZE tm.* TO NULL                  # Default condition
   LET bookno = g_aza.aza81     #FUN-B20010
   LET yy      = y1
   LET mm1     = mm
   LET mm2     = mm
   LET tm.a    = 'N'
   LET tm.b    = 'N' 
   LET tm.c    = 'N'
   LET tm.d    = 'Y'
   LET tm.e    = 'Y'
   LET tm.f    = 'N'  #FUN-6C0012
   LET tm.h    = 'Y'  #MOD-860252
   LET tm.more = 'N'
   LET tm.lvl1    = NULL
   LET tm.lvl2    = NULL
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'

   WHILE TRUE
      #No.FUN-B20010  --End      
      DIALOG ATTRIBUTE(unbuffered)
         INPUT BY NAME bookno ATTRIBUTE(WITHOUT DEFAULTS)
     
            BEFORE INPUT
              CALL gglr402_set_entry()
              CALL gglr402_set_no_entry()
    
              AFTER FIELD bookno
                  IF NOT cl_null(bookno) THEN
   	                CALL s_check_bookno(bookno,g_user,g_plant) 
                         RETURNING li_chk_bookno
                     IF (NOT li_chk_bookno) THEN
                         NEXT FIELD bookno
                     END IF
                     SELECT aaa02 FROM aaa_file WHERE aaa01 = bookno
                     IF STATUS THEN 
                        CALL cl_err3("sel","aaa_file",bookno,"","agl-043","","",0)
                        NEXT FIELD bookno 
                     END IF
                  END IF
              
#TQC-C30136--mark--str--
##TQC-C10039--START--
#        ON ACTION locale
#           CALL cl_show_fld_cont()
#           LET g_action_choice = "locale"
#           EXIT DIALOG
##TQC-C10039--END--
#TQC-C30136--mark--end-- 
         END INPUT
      #No.FUN-B20010  --End  
      
      CONSTRUCT BY NAME tm.wc ON aag01
 
         BEFORE CONSTRUCT
#No.FUN-B20010  --Mark Begin 
#TQC-C30136--mark--str--
# #No.TQC-C10039--cancle mark begin--   
#          ON ACTION locale
#             LET g_action_choice = "locale"
#             CALL cl_show_fld_cont()                  
# #            EXIT CONSTRUCT
#              EXIT DIALOG
# #No.TQC-C10039--cancle mark end--
#TQC-C30136--mark--end--
# 
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE CONSTRUCT
# 
#          ON ACTION about         
#             CALL cl_about()      
# 
#          ON ACTION help          
#             CALL cl_show_help()  
# 
#          ON ACTION controlg      
#             CALL cl_cmdask()     
# 
#         ON ACTION exit
#            LET INT_FLAG = 1
#            EXIT CONSTRUCT
 
         
#         ON ACTION controlp
#            CASE
#              WHEN INFIELD(aag01)
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = 'q_aag02'
#                LET g_qryparam.state= "c"
#                LET g_qryparam.default1 = g_aag01
#                CALL cl_create_qry() RETURNING g_qryparam.multiret 
#                DISPLAY g_qryparam.multiret TO aag01
#                NEXT FIELD aag01
#            END CASE
#No.FUN-B20010  --Mark End         
            
      END CONSTRUCT
      
    
      
#      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup') #FUN-980030  #FUN-B20010 

#No.FUN-B20010  --Mark Begin
#      IF g_action_choice = "locale" THEN
#         LET g_action_choice = ""
#         CALL cl_dynamic_locale()
#         CONTINUE WHILE
#      END IF

#      IF INT_FLAG THEN
#         LET INT_FLAG = 0
#         CLOSE WINDOW gglr402_w
#         EXIT PROGRAM
#      END IF

#      IF tm.wc = ' 1=1' THEN
#         CALL cl_err('','9046',0)
#         CONTINUE WHILE
#      END IF
#No.FUN-B20010  --Mark End
 
      #INPUT BY NAME bookno,yy,mm1,mm2,tm.a,tm.lvl1,tm.lvl2,    #No.FUN-B20010
      INPUT BY NAME yy,mm1,mm2,tm.a,tm.lvl1,tm.lvl2,            #No.FUN-B20010
                    tm.b,tm.c,tm.d,tm.e,tm.f,tm.h,tm.more 
                    ATTRIBUTE(WITHOUT DEFAULTS)                 #No.FUN-B20010
                    #WITHOUT DEFAULTS  #FUN-6C0012  #No.MOD-860252 add tm.h
 
         BEFORE INPUT
           CALL gglr402_set_entry()
           CALL gglr402_set_no_entry()
#No.FUN-B20010  --Mark Begin
#           AFTER FIELD bookno
#             IF cl_null(bookno) THEN
#                NEXT FIELD bookno
#             ELSE
#                SELECT aaaacti INTO l_aaaacti FROM aaa_file
#                 WHERE aaa01=bookno
#                IF SQLCA.sqlcode THEN
#                   IF SQLCA.sqlcode =100 THEN
#                      CALL cl_err("sel aaa01","anm-062",1)
#                   ELSE
#                   #   CALL cl_err3("sel","aaa_file",bookno,"",SQLCA.sqlcode,"","",1)
#                       CALL cl_err("sel",SQLCA.sqlcode,"1")
#                   END IF
#                   NEXT FIELD bookno
#                ELSE
#                   IF l_aaaacti='N' THEN
#                       CALL cl_err("","ggl-999",1)
#                       NEXT FIELD bookno
#                   END IF
#                END IF
#             END IF
#No.FUN-B20010  --Mark End
             
           AFTER FIELD yy
             IF cl_null(yy) THEN
                LET yy=YEAR(today)
                NEXT FIELD yy
             END IF
           
           AFTER FIELD mm1
             IF cl_null(mm1) THEN
                LET mm1 = 1
                NEXT FIELD mm1
             ELSE
                IF mm1<0 OR mm1>13 THEN
                   CALL cl_err("","anm-088",1)
                   NEXT FIELD mm1
                END IF
             END IF
            
           AFTER FIELD mm2
             IF cl_null(mm2) THEN
                LET mm2 = MONTH(today)
                NEXT FIELD mm2
             ELSE
                IF mm2<0 OR mm2>13 THEN
                   CALL cl_err("","anm-088",1)
                   NEXT FIELD mm2
                END IF
                IF mm2<mm1 THEN
#                   CALL cl_err("","apy-034",1)    #CHI-B40058
                   CALL cl_err("","aim-403",1)     #CHI-B40058
                   NEXT FIELD mm2
                END IF
             END IF
           
            AFTER FIELD a
              CALL gglr402_set_entry()
              CALL gglr402_set_no_entry()
 
           AFTER FIELD lvl2
             IF (NOT cl_null(tm.lvl1)) AND (NOT cl_null(tm.lvl2)) THEN
                IF tm.lvl1>tm.lvl2 THEN
                   CALL cl_err("","ggl-996",1)
                   NEXT FIELD lvl2
                END IF
             END IF
             
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
 
       AFTER INPUT 
         #IF INT_FLAG THEN EXIT WHILE END IF
         IF tm.a = 'N' THEN
            IF ( cl_null(tm.lvl1) AND ( NOT cl_null(tm.lvl2)) ) OR
               ( cl_null(tm.lvl2) AND ( NOT cl_null(tm.lvl1)) ) THEN
               CALL cl_err("","ggl-997",1)
               IF cl_null(tm.lvl1) THEN
                  NEXT FIELD lvl1
               ELSE
                  NEXT FIELD lvl2
               END IF
            END IF
            IF (NOT cl_null(tm.lvl1)) AND (NOT cl_null(tm.lvl2)) THEN
               IF tm.lvl1>tm.lvl2 THEN
                  CALL cl_err("","ggl-996",1)
                  NEXT FIELD lvl2
               END IF
            END IF
         END IF
       
 

#No.FUN-B20010  --Mark Begin  
#         ON ACTION CONTROLP
#            CASE
#              WHEN INFIELD(bookno)
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = 'q_aaa3'
#                LET g_qryparam.default1 = bookno
#                CALL cl_create_qry() RETURNING bookno
#                DISPLAY BY NAME bookno
#                NEXT FIELD bookno
#            END CASE 
#No.FUN-B20010  --Mark End
 
      END INPUT
      #No.FUN-B20010  --Begin          
         ON ACTION CONTROLP
            CASE
              WHEN INFIELD(bookno)
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_aaa3'
                LET g_qryparam.default1 = bookno
                CALL cl_create_qry() RETURNING bookno
                DISPLAY BY NAME bookno
                NEXT FIELD bookno               
              WHEN INFIELD(aag01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_aag02'
                LET g_qryparam.state= "c"
                LET g_qryparam.default1 = g_aag01
                LET g_qryparam.where = " aag00 = '",bookno CLIPPED,"'"  #FUN-B20010
                CALL cl_create_qry() RETURNING g_qryparam.multiret 
                DISPLAY g_qryparam.multiret TO aag01
                NEXT FIELD aag01
            END CASE
            
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
            
          ON ACTION about         
             CALL cl_about()      
 
          ON ACTION help          
             CALL cl_show_help()  
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT DIALOG 
            
         ON ACTION accept
            #No.TQC-B30147 --Begin
            IF cl_null(tm.wc) OR tm.wc = ' 1=1' THEN
               CALL cl_err('','9046',0)
               NEXT FIELD aag01
            END IF
            #No.TQC-B30147 --End
            EXIT DIALOG
         
         ON ACTION cancel
            LET INT_FLAG=1
            EXIT DIALOG          

#TQC-C10039--START--
        ON ACTION locale
           CALL cl_show_fld_cont()
           LET g_action_choice = "locale"
           EXIT DIALOG
#TQC-C10039--END--     
      END DIALOG 
      IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
      END IF 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW gglr402_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
         EXIT PROGRAM
      END IF
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF      
      #No.FUN-B20010  --End
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file      
          WHERE zz01='gglr402'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
             CALL cl_err('gglr402','9031',1)   
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,            
                        " '",bookno CLIPPED,"' ",
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.a CLIPPED,"'",
                        " '",tm.b CLIPPED,"'",
                        " '",tm.c CLIPPED,"'",   
                        " '",tm.d CLIPPED,"'",
                        " '",tm.e CLIPPED,"'",
                        " '",yy CLIPPED,"'",   
                        " '",mm1 CLIPPED,"'",   
                        " '",mm2 CLIPPED,"'",  
                        " '",tm.lvl1 CLIPPED,"'",
                        " '",tm.lvl2 CLIPPED,"'", 
                        " '",g_rep_user CLIPPED,"'",         
                        " '",g_rep_clas CLIPPED,"'",         
                        " '",g_template CLIPPED,"'"          
            CALL cl_cmdat('gglr402',g_time,l_cmd)     
         END IF
 
         CLOSE WINDOW gglr402_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL gglr402()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW gglr402_w
 
END FUNCTION
 
FUNCTION gglr402()
   DEFINE l_name        LIKE type_file.chr20,   #NO FUN-690009   VARCHAR(20)   # External(Disk) file name
          l_time        LIKE type_file.chr8,    #NO FUN-690009   VARCHAR(8)    # Used time for running the job
          l_sql         LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(1000) # RDSQL STATEMENT
          l_sql1        LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(1000) # RDSQL STATEMENT
          l_chr         LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
          l_za05        LIKE type_file.chr50,   #NO FUN-690009   VARCHAR(40)
          p_aag02       LIKE type_file.chr1000,
          l_i           LIKE type_file.num5,
          l_i1          LIKE type_file.num10,   #No.FUN-710090
          l_bal         LIKE aah_file.aah04,
          l_aah04       LIKE aah_file.aah04,
          l_aah05       LIKE aah_file.aah05,
          sr1    RECORD
                    aag01 LIKE aag_file.aag01,   # course no
                    aag02 LIKE aag_file.aag02,   # course name
                    aag07 LIKE aag_file.aag07,   # course type
                    aag24 LIKE aag_file.aag24
                 END RECORD,
          sr     RECORD
                    aag01  LIKE aag_file.aag01,
                    aag02  LIKE aag_file.aag02,
                    mm     LIKE aah_file.aah03,
                    debit  LIKE aah_file.aah04,
                    credit LIKE aah_file.aah05,
                    qmye   LIKE aah_file.aah05,
                    stat   LIKE type_file.chr1
                 END RECORD  
#     DEFINE l_img_blob     LIKE type_file.blob    #TQC-C10039  #MOD-C20064 Mark TQC-C10039   
         
     #No.FUN-B80096--mark--Begin---        
     #CALL cl_used(g_prog,l_time,1) RETURNING l_time 
     #No.FUN-B80096--mark--End-----
     CALL cl_del_data(l_table) #No.FUN-710090
#     LOCATE l_img_blob IN MEMORY    #TQC-C10039  #MOD-C20064 Mark TQC-C10039
 
     LET l_i1 = 0               #No.FUN-710090
     
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='gglr402'  #No.FUN-710090
 
     SELECT aaf03 INTO g_company FROM aaf_file
      WHERE aaf01 = bookno
        AND aaf02 = g_rlang
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND aaguser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
#  IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
#     LET tm.wc = tm.wc clipped," AND aaggrup IN ",cl_chk_tgrup_list()
#  END IF
 
 
   LET l_sql1= "SELECT aag01,aag02,aag07,aag24 ",
               "  FROM aag_file ",
               " WHERE aag03 ='2' AND aag07 IN ('1','3') AND aagacti='Y' ",
               "   AND aag00 ='",bookno,"'",    #No.FUN-740055
               "   AND ",tm.wc CLIPPED
               
   IF tm.a = 'Y' THEN
      #No.FUN-A40020  --Begin                                                   
     #LET l_sql1 = l_sql1 CLIPPED," AND aag24= 99 "                             
      LET l_sql1 = l_sql1 CLIPPED," AND (aag24= 99 OR aag07 = '3')"             
      #No.FUN-A40020  --End
   ELSE
      IF NOT cl_null(tm.lvl1) AND NOT cl_null(tm.lvl2) THEN
      #  LET l_sql1 = l_sql1 CLIPPED, "  AND BETWEEN ",tm.lvl1 CLIPPED, " AND ",tm.lvl2 CLIPPED  #No.FUN-A40020
         LET l_sql1 = l_sql1 CLIPPED, "  AND aag24 BETWEEN ",tm.lvl1 CLIPPED, " AND ",tm.lvl2 CLIPPED  #No.FUN-A40020
      END IF
   END IF
 
   IF tm.c='N' THEN
      LET l_sql1 = l_sql1 CLIPPED," AND aag07 != '3' "
   END IF
   
   IF tm.d='N' THEN
      LET l_sql1 = l_sql1 CLIPPED, " AND aag19='1' "
   END IF
 
   #No.MOD-860252--begin--
   IF tm.h = 'Y' THEN 
      LET l_sql1 = l_sql1 CLIPPED, " AND aag09 = 'Y'   "
   END IF
   #No.MOD-860252---end---
 
   LET l_sql1= l_sql1 CLIPPED, " ORDER BY aag01 "
 
   PREPARE gglr402_prepare2 FROM l_sql1
   IF STATUS != 0 THEN
      CALL cl_err('prepare:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF
   DECLARE gglr402_curs2 CURSOR FOR gglr402_prepare2
 
   LET l_sql = " SELECT aah01,'',aah03,aah04,aah05,0,'' ",
               "   FROM aah_file ",
               "  WHERE aah01 = ? ",
               "    AND aah00 = '",bookno, "'",
               "    AND aah02 = ",yy,
               "    AND aah03 = ? ",
               "  ORDER BY aah01 ,aah03"
   
   PREPARE gglr402_prepare1 FROM l_sql
   IF STATUS != 0 THEN
      CALL cl_err('prepare:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF
   DECLARE gglr402_curs1 CURSOR FOR gglr402_prepare1
 
  #No.FUN-710090--begin-- mark
  #CALL cl_outnam('gglr402') RETURNING l_name
  #START REPORT gglr402_rep TO l_name
 
  #LET g_pageno = 0
  #CALL cl_prt_pos_len() 
  #No.FUN-710090--end-- mark
 
   FOREACH gglr402_curs2 INTO sr1.*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
 
      IF sr1.aag24 IS NULL THEN
         LET sr1.aag24 = 99
      END IF
 
      LET g_cnt = 0
      LET l_flag='N'
     
      IF tm.b = 'N' THEN
         #期初余額
         CALL gglr402_qcye(sr1.aag01,mm1-1)
           RETURNING l_bal
         #計算期間異動
         CALL gglr402_qjyd(sr1.aag01,mm1,mm2)
           RETURNING l_aah04,l_aah05,l_flag   
         #FUN-6C0012.....begin
#        CALL gglr402_sjkm(sr1.aag01)
#             RETURNING p_aag02
         IF tm.f = 'Y' THEN                                                     
            SELECT aag13 INTO p_aag02 FROM aag_file                             
             WHERE aag01 = sr1.aag01
#               AND aag00 = sr1.bookno    #No.FUN-740055     #091021 
               AND aag00 = bookno         #091021
         ELSE                                                                   
            SELECT aag02 INTO p_aag02 FROM aag_file                             
             WHERE aag01 = sr1.aag01          
        #       AND aag00 = sr1.bookno    #No.FUN-740055     #091021 
               AND aag00 =  bookno                           #091021
         END IF
         #FUN-6C0012....end
         #期初為0且無期間異動
         IF l_bal = 0 AND l_flag = 0 THEN CONTINUE FOREACH END IF
         LET sr.aag01 = sr1.aag01
         LET sr.aag02 = p_aag02
         LET sr.mm    = NULL
         LET sr.debit = NULL
         LET sr.credit= NULL
         LET sr.qmye  = l_bal
         LET sr.stat  = NULL
        #No.FUN-710090-begin--
        #OUTPUT TO REPORT gglr402_rep(sr.*)     #No.FUN-710090 mark
         LET l_i1 = l_i1+1
         EXECUTE insert_prep USING sr.aag01,sr.aag02,sr.mm,sr.debit,
                                   sr.credit,sr.qmye,sr.stat,yy,g_azi04,l_i1
#                                  , "",l_img_blob,"N",""    #TQC-C10039  #MOD-C20064 Mark TQC-C10039
        #No.FUN-710090--end--
      END IF  
      FOR l_i = mm1 TO mm2
        LET g_cnt = 0
        LET l_flag = 'N'
        FOREACH gglr402_curs1 USING sr1.aag01,l_i INTO sr.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
 
           LET l_flag='Y'
          #LET sr.aag02=sr1.aag02
           LET sr.aag02 = p_aag02
 
           CALL gglr402_qjyd(sr1.aag01,l_i,l_i)
                RETURNING sr.debit,sr.credit,l_flag
 
           CALL gglr402_qcye(sr1.aag01,l_i)
                RETURNING sr.qmye
            
           LET sr.stat = '0'  #本月
           LET sr.mm    = l_i
 
          #No.FUN-710090--begin--
          #OUTPUT TO REPORT gglr402_rep(sr.*)
           LET l_i1 = l_i1+1
           EXECUTE insert_prep USING sr.aag01,sr.aag02,sr.mm,sr.debit,
                                     sr.credit,sr.qmye,sr.stat,yy,g_azi04,l_i1
#                                     ,"",l_img_blob,"N",""    #TQC-C10039  #MOD-C20064 Mark TQC-C10039
          #No.FUN-710090--end--
           CALL gglr402_qjyd(sr1.aag01,1,l_i)
                RETURNING sr.debit,sr.credit,l_flag
           LET sr.stat = '1'   #本年           
           LET sr.mm    = NULL
           
          #No.FUN-710090--begin--
          #OUTPUT TO REPORT gglr402_rep(sr.*)
           LET l_i1 = l_i1+ 1
           EXECUTE insert_prep USING sr.aag01,sr.aag02,sr.mm,sr.debit,
                                     sr.credit,sr.qmye,sr.stat,yy,g_azi04,l_i1
#                                     ,"",l_img_blob,"N",""    #TQC-C10039  #MOD-C20064 Mark TQC-C10039
          #No.FUN-710090--end--
 
        END FOREACH
        
        ##沒有期間異動,下面自動生成一行資料
        IF l_flag='N' THEN
           #本月
           LET sr.aag01=sr1.aag01
           LET sr.mm = l_i
           LET sr.debit = 0
           LET sr.credit = 0
           CALL gglr402_qcye(sr1.aag01,l_i)
                RETURNING sr.qmye         #期末余額
           LET sr.stat = '0'              #本月
          #No.FUN-710090--begin--
          #OUTPUT TO REPORT gglr402_rep(sr.*)
           LET l_i1 = l_i1 + 1
           EXECUTE insert_prep USING sr.aag01,sr.aag02,sr.mm,sr.debit,
                                     sr.credit,sr.qmye,sr.stat,yy,g_azi04,l_i1
#                                     ,"",l_img_blob,"N",""    #TQC-C10039  #MOD-C20064 Mark TQC-C10039
          #No.FUN-710090--end--
           CALL gglr402_qjyd(sr1.aag01,1,l_i)     #1到當前月
                RETURNING sr.debit,sr.credit,l_flag
           LET sr.mm = NULL 
           LET sr.stat = '1'              #本年
          #No.FUN-710090--begin--
          #OUTPUT TO REPORT gglr402_rep(sr.*)
           LET l_i1 = l_i1+1
           EXECUTE insert_prep USING sr.aag01,sr.aag02,sr.mm,sr.debit,
                                     sr.credit,sr.qmye,sr.stat,yy,g_azi04,l_i1
#                                    , "",l_img_blob,"N",""    #TQC-C10039 #MOD-C20064 Mark TQC-C10039
          #No.FUN-710090--end--
        END IF
 
     END FOR
   END FOREACH
 
  #No.FUN-710090--begin--
  #FINISH REPORT gglr402_rep
 # LET g_sql = "SELECT * FROM ",l_table CLIPPED," ORDER BY i "  #TQC-730113
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," ORDER BY i "
   IF g_zz05='Y' THEN
      CALL cl_wcchp(tm.wc,'aag01')
       RETURNING tm.wc
   END IF            
   LET g_str=tm.wc
#   LET g_cr_table = l_table                 #主報表的temp table名稱   #TQC-C100399 #MOD-C20064 Mark TQC-C10039
#   LET g_cr_apr_key_f = "aag01"             #報表主鍵欄位名稱  #TQC-C10039  #MOD-C20064 Mark TQC-C10039
 # CALL cl_prt_cs3('gglr402',g_sql,g_str)  #TQC-730113
   CALL cl_prt_cs3('gglr402','gglr402',g_sql,g_str)
  #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
  #  CALL cl_used(g_prog,l_time,2) RETURNING l_time 
  #No.FUN-710090--end--
 
END FUNCTION
 
#No.FUN-710090--begin-- mark
#REPORT gglr402_rep(sr)
#DEFINE sr       RECORD
#                    aag01  LIKE aag_file.aag01,
#                    aag02  LIKE aag_file.aag02,
#                    mm     LIKE aah_file.aah03,
#                    debit  LIKE aah_file.aah04,
#                    credit LIKE aah_file.aah05,
#                    qmye   LIKE aah_file.aah05,
#                    stat   LIKE type_file.chr1
#                END RECORD,
#       l_bal             LIKE aah_file.aah04,
#       l_cc1             LIKE aah_file.aah04,
#       g_nonu            LIKE type_file.num5,    #NO FUN-690009   SMALLINT
#       l_dash1           LIKE type_file.num5,    #NO FUN-690009   SMALLINT
#       l_old_aah03       LIKE aah_file.aah03,
#       l_last_sw         LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
#       l_aah04,l_aah05   LIKE aah_file.aah04,
#       s_aah04,s_aah05   LIKE aah_file.aah04,
#       l_aah041,l_aah051 LIKE aah_file.aah04,
#       l_pfull           LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
#       l_i               LIKE type_file.num5,    #NO FUN-690009   SMALLINT
#       yyy               LIKE type_file.num5,     #NO FUN-690009   DECIMAL(4,0)
#       l_j               LIKE type_file.num5     #NO FUN-690009   SMALLINT   #TQC-5B0044
#DEFINE g_head1           STRING
#
#   OUTPUT
#      TOP MARGIN 0
#      LEFT MARGIN 0
#      BOTTOM MARGIN 0
#      PAGE LENGTH g_page_line
#
#   ORDER BY sr.aag01
#
#   FORMAT
#      PAGE HEADER
#         LET g_head1 = g_x[1],'  ',sr.aag02 
#         LET g_head1 = g_head1 CLIPPED
#         PRINT  '~MTC2T28X0L18.7;',COLUMN 78,g_head1
#         LET yyy = yy
#         PRINT COLUMN 66,yyy
#         LET g_pageno = g_pageno + 1 USING '<<<'
#         PRINT COLUMN 122, g_pageno
#         PRINT
#         PRINT
#         LET l_last_sw = 'n'
#         LET l_j = 1    #TQC-5B0044
# 
#      BEFORE GROUP OF sr.aag01    #科目
#         IF tm.e = 'Y' THEN
#            SKIP TO TOP OF PAGE
#         END IF
#         
#      ON EVERY ROW 
#         PRINT COLUMN  15, sr.mm;
#         IF cl_null(sr.stat) THEN
#            PRINT COLUMN  34 ,g_x[12];
#         END IF
#         IF sr.stat=0 THEN
#            PRINT COLUMN  34,g_x[13];
#         END IF
#         IF sr.stat=1 THEN
#            PRINT COLUMN  34,g_x[14];
#         END IF
#         PRINT COLUMN 69,cl_numfor(sr.debit,18,g_azi04),
#               COLUMN 93,cl_numfor(sr.credit,18,g_azi04);
#         IF sr.qmye=0 THEN
#            PRINT COLUMN 114,g_x[9] CLIPPED, 
#                  COLUMN 116,cl_numfor(sr.qmye,18,g_azi04)
#         END IF
#         IF sr.qmye>0 THEN
#            PRINT COLUMN 114,g_x[10] CLIPPED, 
#                  COLUMN 116,cl_numfor(sr.qmye,18,g_azi04)
#         END IF
#         IF sr.qmye<0 THEN
#            PRINT COLUMN 114,g_x[11] CLIPPED, 
#                  COLUMN 116,cl_numfor(sr.qmye*(-1),18,g_azi04)
#         END IF
#     
#END REPORT
#No.FUN-710090--end-- mark
 
FUNCTION gglr402_qcye(p_aag01,p_mm)
DEFINE   p_aag01     LIKE aag_file.aag01
DEFINE   p_mm        LIKE type_file.num5
DEFINE   l_bal       LIKE aah_file.aah04
 
    LET l_bal = 0
 
    SELECT SUM(aah04-aah05) INTO l_bal FROM aah_file
     WHERE aah01 = p_aag01  AND aah02=yy AND aah03<=p_mm
       AND aah00 = bookno
    IF cl_null(l_bal) THEN LET l_bal = 0 END IF
    RETURN l_bal
END FUNCTION
 
FUNCTION gglr402_qjyd(p_aag01,b_mm,e_mm)    #計算科目借方/貸方發生額
DEFINE   p_aag01     LIKE aag_file.aag01
DEFINE   b_mm        LIKE type_file.num5,
         e_mm        LIKE type_file.num5
DEFINE   l_flag      LIKE type_file.num5 
DEFINE   l_aah04     LIKE aah_file.aah04,
         l_aah05     LIKE aah_file.aah05
 
    LET l_flag = 0
    SELECT SUM(aah04),SUM(aah05) INTO l_aah04,l_aah05 FROM aah_file
     WHERE aah01=p_aag01 AND aah02=yy AND aah03 BETWEEN b_mm AND e_mm
       AND aah00=bookno
    IF cl_null(l_aah04) THEN LET l_aah04=0 END IF
    IF cl_null(l_aah05) THEN LET l_aah05=0 END IF
    IF l_aah04 != 0 OR l_aah05 != 0 THEN
       LET l_flag = 1
    END IF
    RETURN l_aah04,l_aah05,l_flag
END FUNCTION
#FUN-6C0012.....begin mark
#FUNCTION gglr402_sjkm(p_aag01)
#DEFINE p_aag01        LIKE aag_file.aag01
#DEFINE l_aag02        LIKE aag_file.aag02,
#       l_aag08        LIKE aag_file.aag08,
#       l_aag24        LIKE aag_file.aag24,
#       p_aag02        LIKE aag_file.aag02,
#       p_aag021       LIKE aag_file.aag02
#DEFINE l_success      LIKE type_file.num5
#DEFINE l_i            LIKE type_file.num5
 
#    LET l_aag02 = NULL
#    LET l_success = 1
#    LET l_i = 1
#    WHILE l_success
#        SELECT DISTINCT(aag02),aag08,aag24 INTO l_aag02,l_aag08,l_aag24
#          FROM aag_file
#         WHERE aag01=p_aag01 
#        IF SQLCA.sqlcode THEN
#           LET l_success = 0
#           EXIT WHILE
#        END IF
#        IF l_i = 1 THEN
#           LET p_aag02 = l_aag02
#        ELSE
#           LET p_aag021= p_aag02
#           LET p_aag02 = l_aag02 CLIPPED,'-',p_aag021 CLIPPED
#        END IF
#        LET l_i=l_i+1
        #當前科目為最上層時退出
#        IF l_aag24=1 OR l_aag08 = p_aag01 THEN LET l_success =1 EXIT WHILE END IF
#        LET p_aag01= l_aag08
#    END WHILE 
#    RETURN p_aag02
#END FUNCTION
#FUN-6C0012.....end
FUNCTION gglr402_set_entry()
 
    IF tm.a='N' THEN
       CALL cl_set_comp_entry("lvl1,lvl2",TRUE)
    END IF 
    
END FUNCTION
 
FUNCTION gglr402_set_no_entry()
    IF tm.a='Y' THEN
       CALL cl_set_comp_entry("lvl1,lvl2",FALSE)
    END IF 
END FUNCTION
