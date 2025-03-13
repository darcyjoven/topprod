# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: gglr306.4gl
# Descriptions...: 序時帳
# Input parameter:
# Return code....:
# Date & Author..: 02/09/09 By Carrier
# Modify.........: No.7911 03/10/23 By Sophia依幣別取位及報表格式調整
# Modify.........: No.FUN-510007 05/02/21 By Smapmin 報表轉XML格式
# Modify.........: No.MOD-580293 05/08/29 By Smapmin 修改報表列印方式
# Modify.........: No.FUN-5C0015 06/01/03 增加列印異動碼
#                  依參數aaz88印出,成對加在後面
#                  異動碼1  異動碼3   異動碼5  異動碼7  異動碼9  關係人異動碼
#                  異動碼2  異動碼4   異動碼6  異動碼8  異動碼10
# Modify.........: No.TQC-630166 06/03/16 By 整批修改，將g_wc[1,70]改為g_wc.subString(1,......)寫法
# Modify.........: No.FUN-660124 06/06/21 By Cheunl cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-690009 06/09/05 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.CHI-6A0004 06/10/23 By atsea g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.FUN-6C0012 06/12/29 By Judy 增加打印額外名稱
# Modify.........: No.FUN-740055 07/04/13 By dxfwo    會計科目加帳套
# Modify.........: No.FUN-780031 07/08/22 By Carrier 報表轉Crystal Report格式
# Modify.........: No.MOD-860252 09/02/09 By chenl   增加打印時可選擇貨幣性質或非貨幣性質科目的選擇功能。 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B20010 11/02/15 By yinhy 先選擇帳套，根據帳套判斷科目開窗開哪個帳套的科目資料
# Modify.........: No.TQC-B30147 11/03/17 By yinhy 查詢條件為空，跳到科目編號欄位
# Modify.........: No:FUN-B50105 11/05/23 By zhangweib aaz88範圍修改為0~4 添加azz125 營運部門資訊揭露使用異動碼數(5-8)
# Modify.........: No:FUN-B80096 11/08/10 By Lujh 模組程序撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                            # Print condition RECORD
               #wc      VARCHAR(300),              # Where condition
		wc	STRING,			# TQC-630166
                t       LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)     # Post
                h       LIKE type_file.chr1,    #MOD-860252
                e       LIKE type_file.chr1,    #FUN-6C0012
                more    LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)     # Input more condition(Y/N)
               bookno   LIKE aba_file.aba00     #帳別            #No.FUN-740055
          END RECORD,
          bdate,edate   LIKE type_file.dat,     #NO FUN-690009   DATE
          g_totc     LIKE type_file.num20_6, #NO FUN-690009   DECIMAL(20,6)
          g_totd     LIKE type_file.num20_6, #NO FUN-690009   DECIMAL(20,6)
#         g_bookno   LIKE aba_file.aba00,    #帳別
          g_type     LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(40)
          p_dbs      LIKE type_file.chr20,   #NO FUN-690009   VARCHAR(20)
          g_part     LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(40)
          g_spac     LIKE aab_file.aab02     #NO FUN-690009   VARCHAR(6)
   DEFINE g_rpt_name LIKE type_file.chr20    #NO FUN-690009   VARCHAR(20) # For TIPTOP 串 EasyFlow
 
DEFINE   g_aaa03         LIKE aaa_file.aaa03
DEFINE   g_i             LIKE type_file.num5     #NO FUN-690009   SMALLINT   #count/index for any purpose
DEFINE   g_str           STRING                  #No.FUN-780031
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                      # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
 
 
   LET g_rpt_name = ''
#  LET g_bookno =ARG_VAL(1)             #modi by nick 960321    #No.FUN-740055
   LET tm.bookno =ARG_VAL(1)            #modi by nick 960321    #No.FUN-740055
   LET p_dbs    =ARG_VAL(2)
   LET g_pdate = ARG_VAL(3)             # Get arguments from command line
   LET g_towhom =ARG_VAL(4)
   LET g_rlang = ARG_VAL(5)
   LET g_bgjob = ARG_VAL(6)
   LET g_prtway =ARG_VAL(7)
   LET g_copies =ARG_VAL(8)
   LET tm.wc =ARG_VAL(9)
   LET tm.t  =ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)   # 外部指定報表名稱
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   #-->帳別若為空白則使用預設帳別
#  IF g_bookno = ' ' OR g_bookno IS NULL THEN                             #NO.FUN-740055   
#     LET g_bookno = g_aaz.aaz64                                          #NO.FUN-740055 
#  END IF                                                                 #NO.FUN-740055  
   IF tm.bookno = ' ' OR tm.bookno IS NULL THEN                           #NO.FUN-740055                                            
      LET tm.bookno = g_aza.aza81  #帳別若為空白則使用預設帳別            #NO.FUN-740055                                            
   END IF                                                                 #NO.FUN-740055
   #-->使用預設帳別之幣別
#  SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno         #NO.FUN-740055
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.bookno        #NO.FUN-740055  
   IF SQLCA.sqlcode THEN LET g_aaa03 = g_aza.aza17 END IF     #使用本國幣別
#  SELECT azi04,azi05 INTO g_azi04,g_azi05 FROM azi_file WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN 
#       CALL cl_err(g_aaa03,SQLCA.sqlcode,0)   #No.FUN-660124
        CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","",0)   #No.FUN-660124
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80096   ADD
   IF cl_null(g_bgjob) OR g_bgjob = 'N' # If background job sw is off
      THEN CALL gglr306_tm(0,0)         # Input print condition
      ELSE CALL gglr306()               # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
END MAIN
 
FUNCTION gglr306_tm(p_row,p_col)
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col   LIKE type_file.num5,    #NO FUN-690009   SMALLINT
          l_cmd         LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(400)
   DEFINE li_chk_bookno LIKE type_file.num5     #FUN-B20010
 
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 12 END IF
#  CALL s_dsmark(g_bookno)     #NO.FUN-740055
   CALL s_dsmark(tm.bookno)    #NO.FUN-740055
   IF g_gui_type = '1' AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 18
   ELSE LET p_row = 5 LET p_col = 12
   END IF
   OPEN WINDOW gglr306_w AT p_row,p_col
        WITH FORM "ggl/42f/gglr306"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
#  CALL s_shwact(3,2,g_bookno)     #NO.FUN-740055
   CALL s_shwact(3,2,tm.bookno)    #NO.FUN-740055
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.bookno = g_aza.aza81     #FUN-B20010
   LET tm.e    = 'N'  #FUN-6C0012
   LET tm.more = 'N'
   LET tm.t    = '3'
   LET tm.h    = 'Y'  #MOD-860252
   LET bdate = g_today
   LET edate = g_today
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   WHILE TRUE
       #No.FUN-B20010  --Begin
       DIALOG ATTRIBUTE(unbuffered)
       INPUT BY NAME tm.bookno ATTRIBUTE(WITHOUT DEFAULTS) 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
        
         AFTER FIELD bookno
            IF cl_null(tm.bookno) THEN NEXT FIELD bookno END IF
            CALL s_check_bookno(tm.bookno,g_user,g_plant)
                 RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
               NEXT FIELD bookno
            END IF
            SELECT * FROM aaa_file WHERE aaa01 = tm.bookno
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","aaa_file",tm.bookno,"","aap-229","","",0)
               NEXT FIELD bookno
            END IF          
        
       END INPUT       
       #No.FUN-B20010  --End
       
       CONSTRUCT BY NAME tm.wc ON aag01
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
#No.FUN-B20010  --Mark Begin         
#       ON ACTION locale
#           #CALL cl_dynamic_locale()
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#         LET g_action_choice = "locale"
#         EXIT CONSTRUCT
# 
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE CONSTRUCT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
# 
# 
#           ON ACTION exit
#           LET INT_FLAG = 1
#           EXIT CONSTRUCT
#         #No.FUN-580031 --start--
#         ON ACTION qbe_select
#            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
#No.FUN-B20010  --Mark End
  END CONSTRUCT
#No.FUN-B20010  --Mark Begin
#       IF g_action_choice = "locale" THEN
#          LET g_action_choice = ""
#          CALL cl_dynamic_locale()
#          CONTINUE WHILE
#       END IF
# 
#       IF INT_FLAG THEN
#          LET INT_FLAG = 0 CLOSE WINDOW gglr306_w EXIT PROGRAM
#       END IF
#       DISPLAY BY NAME tm.more             # Condition
       #INPUT BY NAME tm.bookno,bdate,edate,tm.t,tm.h,tm.e,tm.more WITHOUT DEFAULTS #FUN-6C0012   #No.FUN-740055  #No.MOD-860252 add tm.h #FUN-B20010 mark
#No.FUN-B20010  --Mark End 
      INPUT BY NAME bdate,edate,tm.t,tm.h,tm.e,tm.more ATTRIBUTE(WITHOUT DEFAULTS)  #FUN-B20010
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
          AFTER FIELD bdate
             IF cl_null(bdate) THEN NEXT FIELD bdate END IF
          AFTER FIELD edate
             IF cl_null(edate) OR edate < bdate THEN NEXT FIELD edate END IF
          AFTER FIELD t
             IF tm.t NOT MATCHES "[123]" OR cl_null(tm.t)
                THEN NEXT FIELD t
             END IF
          AFTER FIELD more
             IF tm.more = 'Y'
                THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                    g_bgjob,g_time,g_prtway,g_copies)
                          RETURNING g_pdate,g_towhom,g_rlang,
                                    g_bgjob,g_time,g_prtway,g_copies
             END IF
################################################################################
# START genero shell script ADD
#   ON ACTION CONTROLR
#      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################

#No.FUN-B20010  --Mark Begin
        #No.FUN-740055  --Begin                                                                                                    
#        ON ACTION CONTROLP                                                                                                         
#         CASE                                                                                                                      
#           WHEN INFIELD(bookno)                                                                                                    
#             CALL cl_init_qry_var()                                                                                                
#             LET g_qryparam.form = 'q_aaa'                                                                                         
#             LET g_qryparam.default1 =tm.bookno                                                                                    
#             CALL cl_create_qry() RETURNING tm.bookno                                                                              
#             DISPLAY BY NAME tm.bookno                                                                                             
#             NEXT FIELD bookno                                                                                                     
#         END CASE                                                                                                                  
#         #No.FUN-740055  --End 
#
#          ON ACTION CONTROLG CALL cl_cmdask()        # Command execution
#          ON IDLE g_idle_seconds
#             CALL cl_on_idle()
#             CONTINUE INPUT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
# 
#          ON ACTION exit
#          LET INT_FLAG = 1
#          EXIT INPUT
#         #No.FUN-580031 --start--
#         ON ACTION qbe_save
#            CALL cl_qbe_save()
#         #No.FUN-580031 ---end---
#No.FUN-B20010  --Mark End
       END INPUT
       ON ACTION CONTROLP                                                                                                         
          CASE                                                                                                                      
            WHEN INFIELD(bookno)                                                                                                    
              CALL cl_init_qry_var()                                                                                                
              LET g_qryparam.form = 'q_aaa'                                                                                         
              LET g_qryparam.default1 =tm.bookno                                                                                    
              CALL cl_create_qry() RETURNING tm.bookno                                                                              
              DISPLAY BY NAME tm.bookno                                                                                             
              NEXT FIELD bookno  
            WHEN INFIELD(aag01)                                             
              CALL cl_init_qry_var()                                        
              LET g_qryparam.state= "c"                                     
              LET g_qryparam.form = "q_aag"   
              LET g_qryparam.where = " aag00 = '",tm.bookno CLIPPED,"'"
              CALL cl_create_qry() RETURNING g_qryparam.multiret            
              DISPLAY g_qryparam.multiret TO aag01                          
              NEXT FIELD aag01                                                                                                    
          END CASE
       ON ACTION locale
          CALL cl_show_fld_cont() 
          LET g_action_choice = "locale"
          EXIT DIALOG
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
     END DIALOG
     IF g_action_choice = "locale" THEN
       LET g_action_choice = ""
       CALL cl_dynamic_locale()
       CONTINUE WHILE
     END IF
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          CLOSE WINDOW gglr306_w 
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
          SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
           WHERE zz01='gglr306'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('gglr306','9031',1)   
       ELSE
          LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
          LET l_cmd = l_cmd CLIPPED,             #(at time fglgo xxxx p1 p2 p3)
             #        " '",g_bookno CLIPPED,"'",     #NO.FUN-740055
                      " '",tm.bookno CLIPPED,"'",    #NO.FUN-740055 
                      " '",g_dbs CLIPPED,"'",
                      " '",g_pdate CLIPPED,"'",
                      " '",g_towhom CLIPPED,"'",
                      #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                      " '",g_bgjob CLIPPED,"'",
                      " '",g_prtway CLIPPED,"'",
                      " '",g_copies CLIPPED,"'",
                      " '",tm.wc CLIPPED,"'",
                      " '",tm.t CLIPPED,"'",
                      " '",g_rpt_name CLIPPED,"'",   #TQC-610056
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
          CALL cl_cmdat('gglr306',g_time,l_cmd)  # Execute cmd at later time
       END IF
       CLOSE WINDOW gglr306_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
       EXIT PROGRAM
    END IF
    CALL cl_wait()
    CALL gglr306()
    ERROR ""
   END WHILE
   CLOSE WINDOW gglr306_w
END FUNCTION
 
FUNCTION gglr306()
   DEFINE l_name        LIKE type_file.chr20,   #NO FUN-690009   VARCHAR(20)     # External(Disk) file name
#       l_time          LIKE type_file.chr8            #No.FUN-6A0097
          l_sql         LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(1000)   # RDSQL STATEMENT
          l_za05        LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(40)
          l_order       ARRAY[5] OF LIKE cre_file.cre08,   #NO FUN-690009   VARCHAR(10)
          sr               RECORD
                                  aba  RECORD LIKE aba_file.*,
                                  abb  RECORD LIKE abb_file.*,
                                  aag02 LIKE aag_file.aag02,
                                  aag13 LIKE aag_file.aag13, #FUN-6C0012
                                  gem02 LIKE gem_file.gem02
                        END RECORD

     #No.FUN-B80096--mark--Begin---
     #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
     #No.FUN-B80096--mark--End-----
#    SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = g_bookno      #NO.FUN-740055
     SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = tm.bookno     #NO.FUN-740055
                        AND aaf02 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND abauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped,
     #                     " AND abagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped,
     #                     " AND abagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('abauser', 'abagrup')
     #End:FUN-980030
 
     #No.FUN-780031  --Begin
     #LET l_sql = "SELECT aba_file.*,abb_file.*,aag02,aag13,gem02 ", #FUN-6C0012
     #            "  FROM aba_file,abb_file,aag_file,OUTER gem_file ",
     #          # " WHERE aba00 = '",g_bookno,"' AND abb00 ='",g_bookno,"'",      #NO.FUN-740055
     LET l_sql = "SELECT aba01,aba02,abb03,abb04,abb05,abb06,abb07,",
                 "       abb11,abb12,abb13,abb14,abb31,abb32,abb33,",
                 "       abb34,abb35,abb36,abb37,aag02,aag13,gem02,",
                 "       azi04,azi05                               ",
                #No.FUN-B20010  --Begin
                # "  FROM aba_file,abb_file,aag_file,",
                # "       gem_file,azi_file",
                # " WHERE aba00 = '",tm.bookno,"' AND abb00 ='",tm.bookno,"'",    #NO.FUN-740055
                # " AND aag00 = aba00 ",  #NO.FUN-740055 
                # " AND aba01 = abb01 ",
                # " AND abb03 = aag01 ",
                # " AND abb05 = gem_file.gem01(+) ",
                # " AND abb24 = azi_file.azi01(+) ",
                # " AND aag03 = '2'",
                # " AND aba02 >= to_date('",bdate,"','yy/mm/dd')",
                # " AND aba02 <= to_date('",edate,"','yy/mm/dd')",
                # " AND ",tm.wc CLIPPED
                 "  FROM aba_file,aag_file,abb_file LEFT OUTER JOIN gem_file ON abb05 = gem01 LEFT OUTER JOIN azi_file ON abb24 = azi_file.azi01",
                 " WHERE aba00 = '",tm.bookno,"' AND abb00 ='",tm.bookno,"'",    #NO.FUN-740055
                 " AND aag00 = aba00 ",  #NO.FUN-740055 
                 " AND aba01 = abb01 ",
                 " AND abb03 = aag01 ",
                 " AND aag03 = '2'",
                 " AND aba02 BETWEEN '",bdate,"' AND '",edate,"' ",
                 " AND ",tm.wc CLIPPED
                #No.FUN-B20010  --Begin
     #No.FUN-780031  --End  
     CASE tm.t
          WHEN '1' LET l_sql = l_sql CLIPPED," AND abapost = 'N'"
          WHEN '2' LET l_sql = l_sql CLIPPED," AND abapost = 'Y'"
          OTHERWISE EXIT CASE
     END CASE
     #No.MOD-860252--begin--
     IF tm.h = 'Y' THEN 
        LET l_sql = l_sql ," AND aag09 ='Y' " 
     END IF 
     #No.MOD-860252---end---
     LET l_sql = l_sql CLIPPED ," ORDER BY aba02,aba01,abb03 "
 
     #No.FUN-780031  --Begin
     #PREPARE gglr306_prepare1 FROM l_sql
     #IF SQLCA.sqlcode != 0 THEN
     #   CALL cl_err('prepare1:',SQLCA.sqlcode,1)
     #   EXIT PROGRAM
     #END IF
     #DECLARE gglr306_curs1 CURSOR FOR gglr306_prepare1
 
     ##-->額外摘要
 
     #IF NOT cl_null(g_rpt_name) THEN  #已有外部指定報表名稱
     #   LET l_name = g_rpt_name
     #ELSE
     #   CALL cl_outnam('gglr306') RETURNING l_name
     #END IF
 
    ##FUN-5C0015-------------------------------------------------------(S)
     #IF NOT(g_aaz.aaz88 >= 1) THEN LET g_zaa[36].zaa06='Y' END IF #異1
     #IF NOT(g_aaz.aaz88 >= 2) THEN LET g_zaa[44].zaa06='Y' END IF #異2
     #IF NOT(g_aaz.aaz88 >= 3) THEN LET g_zaa[37].zaa06='Y' END IF #異3
     #IF NOT(g_aaz.aaz88 >= 4) THEN LET g_zaa[45].zaa06='Y' END IF #異4
     #IF NOT(g_aaz.aaz88 >= 5) THEN LET g_zaa[47].zaa06='Y' END IF #異5
     #IF NOT(g_aaz.aaz88 >= 6) THEN LET g_zaa[48].zaa06='Y' END IF #異6
     #IF NOT(g_aaz.aaz88 >= 7) THEN LET g_zaa[49].zaa06='Y' END IF #異7
     #IF NOT(g_aaz.aaz88 >= 8) THEN LET g_zaa[50].zaa06='Y' END IF #異8
     #IF NOT(g_aaz.aaz88 >= 9) THEN LET g_zaa[51].zaa06='Y' END IF #異9
     #IF NOT(g_aaz.aaz88 >=10) THEN LET g_zaa[52].zaa06='Y' END IF #異10
    ##FUN-5C0015-------------------------------------------------------(E)
 
     #START REPORT gglr306_rep TO l_name
 
     #LET g_pageno = 0
     #LET g_totc = 0
     #LET g_totd = 0
     #FOREACH gglr306_curs1 INTO sr.*
     #   IF SQLCA.sqlcode != 0 THEN
     #      CALL cl_err('foreach:',SQLCA.sqlcode,1)
     #      EXIT FOREACH
     #   END IF
     #   OUTPUT TO REPORT gglr306_rep(sr.*)
     #END FOREACH
 
     #FINISH REPORT gglr306_rep
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'aag01')
             RETURNING g_str
     END IF
     LET g_str = g_str,";",tm.e,";",g_azi04,";",g_azi05,";",g_aaz.aaz88,";",
                 bdate,";",edate,";",g_aaz.aaz125     #FUN-B50105   Add ,";",g_aaz.aaz125
     CALL cl_prt_cs1('gglr306','gglr306',l_sql,g_str)
     #No.FUN-780031  --End  
     #No.FUN-B80096--mark--Begin---
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
     #No.FUN-B80096--mark--End-----
END FUNCTION
 
#No.FUN-780031  --Begin
#REPORT gglr306_rep(sr)
#   DEFINE l_depname   LIKE cre_file.cre08    #NO FUN-690009   VARCHAR(10)     # 部門名稱
#   DEFINE l_buf       ARRAY[10] OF LIKE azo_file.azo05     #NO FUN-690009   VARCHAR(18)
#   DEFINE i,l_flag    LIKE type_file.num5          #NO FUN-690009   SMALLINT
#   DEFINE l_d,l_c     LIKE type_file.num20_6,      #NO FUN-690009   DECIMAL(20,6)
#          l_last_sw   LIKE type_file.chr1,         #NO FUN-690009   VARCHAR(1)
#          g_head1     STRING
#   DEFINE sr          RECORD
#                      aba    RECORD LIKE aba_file.*,
#                      abb    RECORD LIKE abb_file.*,
#                      aag02  LIKE aag_file.aag02,
#                      aag13  LIKE aag_file.aag13,  #FUN-6C0012
#                      gem02  LIKE gem_file.gem02
#                      END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#  ORDER BY sr.aba.aba02,sr.aba.aba01,sr.abb.abb03
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1] CLIPPED
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED, pageno_total
#      LET g_head1 = g_x[9] CLIPPED,YEAR(bdate),g_x[10],
#                    MONTH(bdate) USING "##",g_x[11],
#                    DAY(bdate) USING "##",g_x[12],
#                    g_x[13] CLIPPED,YEAR(edate),g_x[10],
#                    MONTH(edate) USING "##" ,g_x[11],
#                    DAY(edate) USING "##",g_x[12]
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_head1))/2)+1,g_head1
#      #FUN-6C0012.....begin
#      IF tm.e = 'Y' THEN
#         LET g_zaa[41].zaa08 =g_x[16]
#      END IF
#      #FUN-6C0012.....end
#      PRINT g_dash[1,g_len]
#     #->FUN-5C0015-----------------------------------------------------------------------(S)
#     #PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
#     #PRINTX name=H2 g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46]
#      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#                     g_x[47],g_x[49],g_x[51],g_x[53]
#      PRINTX name=H2 g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],
#                     g_x[48],g_x[50],g_x[52]
#     #->FUN-5C0015-----------------------------------------------------------------------(S)
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.aba.aba02
#     LET l_c = 0
#     LET l_d = 0
# #     PRINT COLUMN g_c[31],sr.aba.aba02;   #MOD-580293
#      PRINTX name=D1 COLUMN g_c[31],sr.aba.aba02 CLIPPED;   #MOD-580293
#
#   BEFORE GROUP OF sr.aba.aba01
# #     PRINT COLUMN g_c[32],sr.aba.aba01 CLIPPED;   #MOD-580293
#      PRINTX name=D1 COLUMN g_c[32],sr.aba.aba01 CLIPPED;   #MOD-580293
#
#   ON EVERY ROW
#      #NO:7911
#      SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file   #No.CHI-6A0004
#       WHERE azi01 = sr.abb24
#      #NO:7911 end
#
#      PRINTX name=D1 COLUMN g_c[33],sr.abb.abb03 CLIPPED,
#                     COLUMN g_c[34],sr.abb.abb04 CLIPPED,
#                     COLUMN g_c[35],sr.abb.abb05 CLIPPED,
#                     COLUMN g_c[36],sr.abb.abb11 CLIPPED,
#                     COLUMN g_c[37],sr.abb.abb13 CLIPPED;
#            IF sr.abb.abb06 = '1' THEN
#              #PRINTX name=D1 COLUMN g_c[38],cl_numfor(sr.abb.abb07,38,t_azi04) CLIPPED   #FUN-5C0015   #No.CHI-6A0004
#               PRINTX name=D1 COLUMN g_c[38],cl_numfor(sr.abb.abb07,38,t_azi04) CLIPPED;  #FUN-5C0015   #No.CHI-6A0004
#               LET l_d = l_d + sr.abb.abb07
#               LET g_totd = g_totd + sr.abb.abb07
#            ELSE
# Prog. Version..: '5.30.06-13.03.12(0,38,t_azi04) CLIPPED  #FUN-5C0015   #No.CHI-6A0004
# Prog. Version..: '5.30.06-13.03.12(0,38,t_azi04) CLIPPED; #FUN-5C0015   #No.CHI-6A0004
#            END IF
#           #->FUN-5C0015---------------------------------------------(S)
#            PRINTX name=D1 COLUMN g_c[47],sr.abb.abb31 CLIPPED,
#                           COLUMN g_c[49],sr.abb.abb33 CLIPPED,
#                           COLUMN g_c[51],sr.abb.abb35 CLIPPED,
#                           COLUMN g_c[53],sr.abb.abb37 CLIPPED
#           #->FUN-5C0015---------------------------------------------(E)
#      #FUN-6C0012.....begin
#      IF tm.e = 'Y' THEN
#         PRINTX name=D2 COLUMN g_c[41],sr.aag13 CLIPPED,                   
#                        COLUMN g_c[43],sr.gem02 CLIPPED,                   
#                        COLUMN g_c[44],sr.abb.abb12 CLIPPED,               
#                        COLUMN g_c[45],sr.abb.abb14 CLIPPED;
#      ELSE
#      #FUN-6C0012.....end
#         PRINTX name=D2 COLUMN g_c[41],sr.aag02 CLIPPED,
#                        COLUMN g_c[43],sr.gem02 CLIPPED,
#                        COLUMN g_c[44],sr.abb.abb12 CLIPPED,
#                        COLUMN g_c[45],sr.abb.abb14 CLIPPED;
#      END IF  #FUN-6C0012
#            IF sr.abb.abb06 = '2' THEN
#              #PRINTX name=D2 COLUMN g_c[46],cl_numfor(sr.abb.abb07,46,t_azi04) CLIPPED   #FUN-5C0015  #No.CHI-6A0004
#               PRINTX name=D2 COLUMN g_c[46],cl_numfor(sr.abb.abb07,46,t_azi04) CLIPPED;  #FUN-5C0015  #No.CHI-6A0004
#               LET l_c = l_c + sr.abb.abb07
#               LET g_totc = g_totc + sr.abb.abb07
#            ELSE
# Prog. Version..: '5.30.06-13.03.12(0,46,t_azi04) CLIPPED   #FUN-5C0015   #No.CHI-6A0004
# Prog. Version..: '5.30.06-13.03.12(0,46,t_azi04) CLIPPED;  #FUN-5C0015   #No.CHI-6A0004
#            END IF
#           #->FUN-5C0015---------------------------------------------(S)
#            PRINTX name=D2 COLUMN g_c[48],sr.abb.abb32 CLIPPED,
#                           COLUMN g_c[50],sr.abb.abb34 CLIPPED,
#                           COLUMN g_c[52],sr.abb.abb36 CLIPPED
#           #->FUN-5C0015---------------------------------------------(E)
#
#   AFTER GROUP OF sr.aba.aba01
#      SKIP 1 LINE
#
#   AFTER GROUP OF sr.aba.aba02
# #      PRINT COLUMN g_c[31],g_x[14] CLIPPED,   #MOD-580293
#       PRINTX name=D1 COLUMN g_c[31],g_x[14] CLIPPED,   #MOD-580293
#                     COLUMN g_c[38],cl_numfor(l_d,38,t_azi04)   #No.CHI-6A0004
# #      PRINT COLUMN g_c[46],cl_numfor(l_c,46,g_azi04)   #MOD-580293
#       PRINTX name=D2 COLUMN g_c[46],cl_numfor(l_c,46,t_azi04) CLIPPED  #MOD-580293   #No.CHI-6A0004
#      PRINT g_dash2[1,g_len]
#
#   ON LAST ROW
# #      PRINT COLUMN g_c[31],g_x[15] CLIPPED,   #MOD-580293
#       PRINTX name=D1 COLUMN g_c[31],g_x[15] CLIPPED,   #MOD-580293
#                     COLUMN g_c[38],cl_numfor(g_totd,38,t_azi04)           #No.CHI-6A0004
# #      PRINT COLUMN g_c[46],cl_numfor(g_totc,46,g_azi04)   #MOD-580293
#       PRINTX name=D2 COLUMN g_c[46],cl_numfor(g_totc,46,t_azi04) CLIPPED  #MOD-580293   #No.CHI-6A0004
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#         CALL cl_wcchp(tm.wc,'aag01')
#                    RETURNING tm.wc
#         PRINT g_dash[1,g_len]
#	#TQC-630166
#        #      IF tm.wc[001,070] > ' ' THEN			# for 80
#	#	 PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#        #      IF tm.wc[071,140] > ' ' THEN
#	# 	 PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#        #      IF tm.wc[141,210] > ' ' THEN
#	# 	 PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#        #      IF tm.wc[211,280] > ' ' THEN
#	# 	 PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#	CALL cl_prt_pos_wc(tm.wc)
#        #END TQC-630166
#      END IF
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#              PRINT g_dash[1,g_len]
#              PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
##Patch....NO.TQC-610037 <001> #
#No.FUN-780031  --End  
