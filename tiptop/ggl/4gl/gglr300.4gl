# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: gglr300.4gl
# Descriptions...: 總分類帳
# Input parameter:
# Return code....:
# Date & Author..: 02/08/22 By Carrier
# Modify.........: No.FUN-510007 05/01/17 By Nicola 報表架構修改
# Modify.........: No.MOD-580211 05/09/08 By ice  修改報表列印格式
# Modify.........: No.TQC-5B0044 05/11/07 By Smapmin 報表最後多出一行g_dash2
# Modify.........: No.TQC-630166 06/03/16 By 整批修改，將g_wc[1,70]改為g_wc.subString(1,......)寫法
# Modify.........: No.FUN-660124 06/06/21 By Cheunl cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-690009 06/09/05 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.CHI-6A0004 06/10/23 By atsea g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.FUN-6C0012 06/12/28 By Judy 增加打印“額外名稱”
# Modify.........: No.CHI-710005 07/01/18 By Elva 去掉aza26的判斷
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740055 07/04/13 By arman   會計科目加帳套
# Modify.........: No.MOD-740497 07/04/30 By Smapmin 修改跳頁問題
# Modify.........: No.TQC-750022 07/05/09 By Lynn 制表日期位置在報表名之上
# Modify.........: No.FUN-7C0064 07/12/27 By Carrier 報表格式轉CR
# Modify.........: No.MOD-860252 09/02/03 By chenl 增加打印時可選擇貨幣性質或非貨幣性質科目的選擇功能。
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B20010 11/02/10 By yinhy 先選擇帳套，根據帳套判斷科目開窗開哪個帳套的科目資料
# Modify.........: No.TQC-B30147 11/03/17 By yinhy 查詢條件為空，跳到科目編號欄位  
# Modify.........: No:FUN-B80096 11/08/10 By Lujh 模組程序撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD
            #wc        VARCHAR(300),
	     wc        STRING,		#TQC-630166
             t         LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
             u         LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
             s         LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)   #TQC-610056
             x         LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
             e         LIKE type_file.chr1,    #FUN-6C0012
             h         LIKE type_file.chr1,    #MOD-860252
             y         LIKE type_file.num5,    #NO FUN-690009   SMALLINT
             more      LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)
          END RECORD,
     yy,m1,m2          LIKE type_file.num10,   #NO FUN-690009   INTEGER
     y1,mm             LIKE type_file.num10,   #NO FUN-690009   INTEGER
#     g_bookno LIKE aaa_file.aaa01,     #帳別    #NO.FUN-740055
       bookno         LIKE aaa_file.aaa01,    #NO.FUN-740055
     l_flag        LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)
DEFINE   g_aaa03         LIKE aaa_file.aaa03
DEFINE   g_cnt           LIKE type_file.num10    #NO FUN-690009   INTEGER
DEFINE   g_i             LIKE type_file.num5     #NO FUN-690009   SMALLINT   #count/index for any purpose
DEFINE   l_table         STRING                  #No.FUN-7C0064
DEFINE   g_str           STRING                  #No.FUN-7C0064
DEFINE   g_sql           STRING                  #No.FUN-7C0064
 
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
 
#   LET g_bookno= ARG_VAL(1)   #NO.FUN-740055
    LET bookno= ARG_VAL(1)   #NO.FUN-740055
   LET g_pdate = ARG_VAL(2)            # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   LET tm.s  = ARG_VAL(11)   #TQC-610056
   LET tm.x  = ARG_VAL(12)
   LET tm.y  = ARG_VAL(13)
   LET yy = ARG_VAL(14)   #TQC-610056
   LET m1 = ARG_VAL(15)   #TQC-610056
   LET m2 = ARG_VAL(16)   #TQC-610056
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(17)
   LET g_rep_clas = ARG_VAL(18)
   LET g_template = ARG_VAL(19)
   LET g_rpt_name = ARG_VAL(20)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#NO.FUN-740055  --Begin
    IF bookno IS  NULL OR bookno = ' ' THEN
       LET bookno = g_aza.aza81 
    END IF
#NO.FUN-740055  --End
   #-->使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = bookno   #NO.FUN-740055
   IF SQLCA.sqlcode THEN
      LET g_aaa03 = g_aza.aza17
   END IF
 
#  SELECT azi04,azi05 INTO g_azi04,g_azi05 FROM azi_file WHERE azi01 = g_aaa03   #No.CHI-6A0004
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_aaa03,SQLCA.sqlcode,0)   #No.FUN-660124
      CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","",0)   #No.FUN-660124
   END IF
 
   #No.FUN-7C0064  --Begin
   LET g_sql = " aah01.aah_file.aah01,",
               " aah03.aah_file.aah03,",
               " aah04.aah_file.aah04,",
               " aah05.aah_file.aah05,",
               " aag02.aag_file.aag02,",
               " l_bal.aah_file.aah04,",
               " s_aah04.aah_file.aah04,",
               " s_aah05.aah_file.aah05,",
               " type.type_file.chr1 "
 
   LET l_table = cl_prt_temptable('gglr300',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)    "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-7C0064  --End
   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80096   ADD 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL gglr300_tm()
   ELSE
      CALL gglr300()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
END MAIN
 
FUNCTION gglr300_tm()
DEFINE lc_qbe_sn           LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col      LIKE type_file.num5,    #NO FUN-690009   SMALLINT
          l_cmd            LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(400)
   DEFINE li_chk_bookno    LIKE type_file.num5     #FUN-B20010
   
   CALL s_dsmark(bookno)                #NO.FUN-740055
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW gglr300_w AT p_row,p_col
     WITH FORM "ggl/42f/gglr300"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL s_shwact(0,0,bookno)               #NO.FUN-740055
   CALL cl_opmsg('p')
   SELECT azn02,azn04 INTO y1,mm FROM azn_file WHERE azn01 = g_today
   INITIALIZE tm.* TO NULL                  # Default condition
   LET yy      = y1
   LET m1      = mm
   LET m2      = mm
   LET tm.t    = 'N'
   LET tm.u    = 'N'
   LET tm.x    = 'N'
   LET tm.e    = 'N'  #FUN-6C0012
   LET tm.h    = 'Y'  #No.MOD-860252
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      #No.FUN-B20010  --Begin
      DIALOG ATTRIBUTE(unbuffered)
      INPUT BY NAME bookno ATTRIBUTE(WITHOUT DEFAULTS) 
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
        
         AFTER FIELD bookno
            IF cl_null(bookno) THEN NEXT FIELD bookno END IF
            CALL s_check_bookno(bookno,g_user,g_plant)
                 RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
               NEXT FIELD bookno
            END IF
            SELECT * FROM aaa_file WHERE aaa01 = bookno
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","aaa_file",bookno,"","aap-229","","",0)
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
#         ON ACTION locale
#            LET g_action_choice = "locale"
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#            EXIT CONSTRUCT
# 
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE CONSTRUCT
# 
#          ON ACTION about         #MOD-4C0121
#             CALL cl_about()      #MOD-4C0121
# 
#          ON ACTION help          #MOD-4C0121
#             CALL cl_show_help()  #MOD-4C0121
# 
#          ON ACTION controlg      #MOD-4C0121
#             CALL cl_cmdask()     #MOD-4C0121
# 
#         ON ACTION exit
#            LET INT_FLAG = 1
#            EXIT CONSTRUCT
# 
#         #No.FUN-580031 --start--
#         ON ACTION qbe_select
#            CALL cl_qbe_select()
#         #No.FUN-580031 ---end---
#No.FUN-B20010  --Mark End
      END CONSTRUCT
#No.FUN-B20010  --Mark Begin 
#      IF g_action_choice = "locale" THEN
#         LET g_action_choice = ""
#         CALL cl_dynamic_locale()
#         CONTINUE WHILE
#      END IF
# 
#      IF INT_FLAG THEN
#         LET INT_FLAG = 0
#         CLOSE WINDOW gglr300_w
#         EXIT PROGRAM
#      END IF
# 
#      IF tm.wc = ' 1=1' THEN
#         CALL cl_err('','9046',0)
#         CONTINUE WHILE
#      END IF
# 
#      DISPLAY BY NAME tm.t,tm.u,tm.x,tm.e,tm.h,tm.more  #FUN-6C0012 #No.MOD-860252 add tm.h
# 
#      INPUT BY NAME bookno,yy,m1,m2,tm.t,tm.u,tm.x,tm.e,tm.h,tm.y,tm.more WITHOUT DEFAULTS #FUN-6C0012        #No.FUN-740049 #No.MOD-860252 add tm.h #FUN-B20010
#No.FUN-B20010  --Mark End
      INPUT BY NAME yy,m1,m2,tm.t,tm.u,tm.x,tm.e,tm.h,tm.y,tm.more ATTRIBUTE(WITHOUT DEFAULTS) #FUN-B20010 去掉bookno
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD yy
            IF yy IS NULL THEN
               NEXT FIELD yy
            END IF
 
         AFTER FIELD m1
#No.TQC-720032 -- begin --
         IF NOT cl_null(m1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = yy
            IF g_azm.azm02 = 1 THEN
               IF m1 > 12 OR m1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1
               END IF
            ELSE
               IF m1 > 13 OR m1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1
               END IF
            END IF
         END IF
#            IF m1 IS NULL OR m1 <= 0 OR m1 > 13 THEN
#               NEXT FIELD m1
#            END IF
#No.TQC-720032 -- end --
 
         AFTER FIELD m2
#No.TQC-720032 -- begin --
         IF NOT cl_null(m2) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = yy
            IF g_azm.azm02 = 1 THEN
               IF m2 > 12 OR m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            ELSE
               IF m2 > 13 OR m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
            IF m2 IS NULL OR m2 < m1 THEN
               NEXT FIELD m2
            END IF
 
         AFTER FIELD t
            IF tm.t NOT MATCHES "[YN]" THEN
               NEXT FIELD t
            END IF
 
         AFTER FIELD u
            IF tm.u NOT MATCHES "[YN]" THEN
               NEXT FIELD u
            END IF
 
         AFTER FIELD x
            IF tm.x NOT MATCHES "[YN]" THEN
               NEXT FIELD x
            END IF
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
#No.FUN-B20010  --Mark Begin 
#         ON ACTION CONTROLR
#            CALL cl_show_req_fields()
# 
#         ON ACTION CONTROLG
#            CALL cl_cmdask()

#NO.FUN-740055    ---Begin
#     ON ACTION CONTROLP
#	      CASE
#           WHEN INFIELD(bookno) 
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = 'q_aaa'
#              LET g_qryparam.default1 =bookno
#              CALL cl_create_qry() RETURNING bookno
#	      DISPLAY BY NAME bookno
#	      NEXT FIELD bookno
#        END CASE
##NO.FUN-740055   ---End
#
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE INPUT
# 
#          ON ACTION about         #MOD-4C0121
#             CALL cl_about()      #MOD-4C0121
# 
#          ON ACTION help          #MOD-4C0121
#             CALL cl_show_help()  #MOD-4C0121
# 
#         ON ACTION exit
#            LET INT_FLAG = 1
#            EXIT INPUT
# 
#         #No.FUN-580031 --start--
#         ON ACTION qbe_save
#            CALL cl_qbe_save()
#         #No.FUN-580031 ---end-
#No.FUN-B20010  --Mark End
 
      END INPUT
      #No.FUN-B20010  --Begin
      ON ACTION CONTROLP
	       CASE
           WHEN INFIELD(bookno) 
              CALL cl_init_qry_var()
              LET g_qryparam.form = 'q_aaa'
              LET g_qryparam.default1 =bookno
              CALL cl_create_qry() RETURNING bookno
	            DISPLAY BY NAME bookno
	            NEXT FIELD bookno
	         WHEN INFIELD(aag01)                                             
              CALL cl_init_qry_var()                                        
              LET g_qryparam.state= "c"                                     
              LET g_qryparam.form = "q_aag"   
              LET g_qryparam.where = " aag00 = '",bookno CLIPPED,"'"                  
              CALL cl_create_qry() RETURNING g_qryparam.multiret            
              DISPLAY g_qryparam.multiret TO aag01                          
              NEXT FIELD aag01                                              
           OTHERWISE                                                        
               EXIT CASE      
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
      #No.MOD-860252--begin--
      IF INT_FLAG THEN 
         LET INT_FLAG = 0 
         CLOSE WINDOW gglr300_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
         EXIT PROGRAM
      END IF 
      #No.MOD-860252---end---
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 #No.FUN-B20010  --End     
      
      SELECT azn02,azn04 INTO y1,mm FROM azn_file WHERE azn01 = bdate
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file      #get exec cmd (fglgo xxxx)
          WHERE zz01='gglr300'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
             CALL cl_err('gglr300','9031',1)   
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,            #(at time fglgo xxxx p1 p2 p3)
                        " '",bookno CLIPPED,"' ",   #NO.FUN-740055
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.t CLIPPED,"'",
                        " '",tm.u CLIPPED,"'",
                        " '",tm.s CLIPPED,"'",   #TQC-610056
                        " '",tm.x CLIPPED,"'",
                        " '",tm.y CLIPPED,"'",
                       " '",yy CLIPPED,"'",   #TQC-610056
                       " '",m1 CLIPPED,"'",   #TQC-610056
                       " '",m2 CLIPPED,"'",   #TQC-610056
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('gglr300',g_time,l_cmd)      # Execute cmd at later time
         END IF
 
         CLOSE WINDOW gglr300_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL gglr300()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW gglr300_w
 
END FUNCTION
 
FUNCTION gglr300()
   DEFINE l_name        LIKE type_file.chr20,   #NO FUN-690009   VARCHAR(20)   # External(Disk) file name
#       l_time          LIKE type_file.chr8            #No.FUN-6A0097
          l_sql         LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(1000) # RDSQL STATEMENT
          l_sql1        LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(1000) # RDSQL STATEMENT
          l_chr         LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
          l_za05        LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(40)
          l_bal         LIKE aah_file.aah04,
          l_aah041      LIKE aah_file.aah04,
          l_aah051      LIKE aah_file.aah05,
          sr1    RECORD
                    aag01 LIKE aag_file.aag01,   # course no
                    aag02 LIKE aag_file.aag02,   # course name
                    aag13 LIKE aag_file.aag13,   #FUN-6C0012
                    aag07 LIKE aag_file.aag07,   # course type
                    aag24 LIKE aag_file.aag24
                 END RECORD,
          sr     RECORD
                    aah00 LIKE aah_file.aah00,
                    aah01 LIKE aah_file.aah01,
                    aah02 LIKE aah_file.aah02,
                    aah03 LIKE aah_file.aah03,
                    aah04 LIKE aah_file.aah04,
                    aah05 LIKE aah_file.aah05,
                    aag02 LIKE aag_file.aag02,
                    aag13 LIKE aag_file.aag13   #FUN-6C0012
                 END RECORD
   #No.FUN-7C0064  --Begin
   DEFINE s_aah04    LIKE aah_file.aah04
   DEFINE s_aah05    LIKE aah_file.aah05
   DEFINE l_i        LIKE type_file.num5
   #No.FUN-7C0064  --End   
   #No.FUN-B80096--mark--Begin--- 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
   #No.FUN-B80096--mark--End-----
   #No.FUN-7C0064  --Begin
   CALL cl_del_data(l_table)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   #No.FUN-7C0064  --End
 
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = bookno    #NO.FUN-740055
      AND aaf02 = g_rlang
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND aaguser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND aaggrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
   #End:FUN-980030
 
 
   LET l_sql1= "SELECT aag01,aag02,aag13,aag07,aag24 ",  #FUN-6C0012
               "  FROM aag_file ",
               " WHERE aag03 ='2' AND aag07 IN ('1','3') ",
               "   AND aag00 ='", bookno,"' ",               #NO.FUN-740055
               "   AND ",tm.wc CLIPPED
 
   #No.MOD-860252--begin-- 
   IF tm.h = 'Y' THEN 
      LET l_sql1 = l_sql1, " AND aag09 = 'Y'  "
   END IF 
   #No.MOD-860252---end---
   PREPARE gglr300_prepare2 FROM l_sql1
   IF STATUS != 0 THEN
      CALL cl_err('prepare:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF
   DECLARE gglr300_curs2 CURSOR FOR gglr300_prepare2
 
   LET l_sql = "SELECT aah00,aah01,aah02,aah03,aah04,aah05,'' ",
               "  FROM aah_file ",
               " WHERE aah01 = ? ",
               "   AND aah00 = '",bookno,"' ",   #NO.FUN-740055
               "   AND aah02 = ",yy,
   #           "   AND aah03 BETWEEN  ",m1," AND ",m2,   #No.FUN-7C0064
               "   AND aah03 = ? ",                      #No.FUN-7C0064
               "   ORDER BY aah01,aah02"
 
   PREPARE gglr300_prepare1 FROM l_sql
   IF STATUS != 0 THEN
      CALL cl_err('prepare:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF
   DECLARE gglr300_curs1 CURSOR FOR gglr300_prepare1
 
   #No.FUN-7C0064  --Begin
   #CALL cl_outnam('gglr300') RETURNING l_name
 
   ##FUN-6C0012.....begin
   #IF tm.e ='Y' THEN                                                            
   #   LET g_zaa[32].zaa06 ='Y'                                                  
   #   LET g_zaa[39].zaa06 ='N'                                                  
   #ELSE                                                                         
   #   LET g_zaa[32].zaa06 ='N'                                                  
   #   LET g_zaa[39].zaa06 ='Y'                                                  
   #END IF                                                                       
   #CALL  cl_prt_pos_len()
   ##FUN-6C0012.....end
   #START REPORT gglr300_rep TO l_name
 
   #LET g_pageno = 0
   #No.FUN-7C0064  --End  
 
   FOREACH gglr300_curs2 INTO sr1.*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
 
      IF tm.x = 'N' AND sr1.aag07 = '3' THEN
         CONTINUE FOREACH
      END IF
 
      IF sr1.aag24 IS NULL THEN
         LET sr1.aag24 = 99
      END IF
 
     #IF g_aza.aza26 = '2' AND NOT cl_null(tm.y) THEN  #CHI-710005
      IF NOT cl_null(tm.y) THEN #CHI-710005 
         IF sr1.aag07 = '1' AND sr1.aag24 != tm.y THEN
            CONTINUE FOREACH
         END IF
      END IF
 
      LET g_cnt = 0
      LET l_flag='N'
 
      #No.FUN-7C0064  --Begin
      LET sr.aah01=sr1.aag01
      LET sr.aag02=sr1.aag02
      IF tm.e ='Y' THEN                                                            
         LET sr.aag02=sr1.aag13
      END IF
 
      #compute 期初 & 期間異動
      CALL r300_f(sr1.aag01,m1,m2) RETURNING l_bal,l_aah041,l_aah051
      IF l_aah041 = 0 AND l_aah051 = 0 AND l_bal = 0 THEN  #無期初,無期間異動
         IF tm.t = 'Y' THEN
            LET sr.aah04 = 0
            LET sr.aah05 = 0
            CALL r300_y_aah(sr1.aag01,m1) RETURNING s_aah04,s_aah05
            EXECUTE insert_prep USING sr.aah01,'0','0','0',sr.aag02,
                    '0',s_aah04,s_aah05,'1'   #1-無期初,無異動
         END IF
      ELSE
         FOR l_i = m1 TO m2
             LET sr.aah04 = 0
             LET sr.aah05 = 0
             CALL r300_bal_aah(sr1.aag01,l_i) RETURNING l_bal,sr.aah04,sr.aah05
             CALL r300_y_aah(sr1.aag01,l_i) RETURNING s_aah04,s_aah05
             EXECUTE insert_prep USING sr.aah01,l_i,sr.aah04,sr.aah05,
                     sr.aag02,l_bal,s_aah04,s_aah05,'2'
         END FOR
      END IF
      #No.FUN-7C0064  --End  
   END FOREACH
 
   #No.FUN-7C0064  --Begin
   #FINISH REPORT gglr300_rep
   #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = ''
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'aag01')
           RETURNING g_str
   END IF
   LET g_str = g_str,";",yy,";",tm.u,";",tm.e,";",g_azi04
   CALL cl_prt_cs3('gglr300','gglr300',g_sql,g_str)
   #No.FUN-7C0064  --End  
   #No.FUN-B80096--mark--Begin---
   #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
   #No.FUN-B80096--mark--End-----
END FUNCTION
 
#No.FUN-7C0064  --Begin
#REPORT gglr300_rep(sr)
#DEFINE sr                RECORD
#                            aah00 LIKE aah_file.aah00,
#                            aah01 LIKE aah_file.aah01,
#                            aah02 LIKE aah_file.aah02,
#                            aah03 LIKE aah_file.aah03,
#                            aah04 LIKE aah_file.aah04,
#                            aah05 LIKE aah_file.aah05,
#                            aag02 LIKE aag_file.aag02,
#                            aag13 LIKE aag_file.aag13   #FUN-6C0012
#                         END RECORD,
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
#       yyy               LIKE type_file.num10,     #NO FUN-690009   DECIMAL(4,0)
#       l_j               LIKE type_file.num5     #NO FUN-690009   SMALLINT   #TQC-5B0044
#DEFINE g_head1           STRING
#
#   OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
#
#   ORDER BY sr.aah01,sr.aah03
#
#   FORMAT
#      PAGE HEADER
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
##No.TQC-6A0094 -- begin --
##         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
##         LET yyy = yy
##         LET g_head1 = '(',yyy ,'  )' CLIPPED,g_x[9] CLIPPED
##         PRINT COLUMN ((g_len-11)/2)-1,g_head1
##No.TQC-6A0094 -- end --
#         LET g_pageno = g_pageno + 1
#         LET pageno_total = PAGENO USING '<<<',"/pageno"
##        PRINT g_head CLIPPED,pageno_total      # No.TQC-750022
##No.TQC-6A0094 -- begin --
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
#         LET yyy = yy
#         LET g_head1 = '(',yyy ,'  )' CLIPPED,g_x[9] CLIPPED
##No.TQC-6A0094 -- end --
#         PRINT COLUMN ((g_len-11)/2)-1,g_head1
#         PRINT
#         PRINT g_head CLIPPED,pageno_total      # No.TQC-750022
#         PRINT g_dash[1,g_len]
##        PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]         #FUN-6C0012
#         PRINT g_x[31],g_x[32],g_x[39],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38] #FUN-6C0012
#         PRINT g_dash1
#         LET l_last_sw = 'n'
#         LET l_j = 1    #TQC-5B0044
# 
#      BEFORE GROUP OF sr.aah01    #科目
#         LET l_old_aah03 = sr.aah03
#
#         IF tm.u = 'Y' THEN
#            SKIP TO TOP OF PAGE
#         END IF
#
#         LET l_bal = 0
#
#         SELECT SUM(aah04-aah05) INTO l_bal FROM aah_file
#          WHERE aah01 = sr.aah01
#            AND aah02 = yy
#            AND aah03 < m1
#            AND aah00 = bookno   #NO.FUN-740055
#
#         IF l_bal IS NULL THEN
#            LET l_bal = 0
#         END IF
#
#         IF l_bal = 0 THEN
#            LET l_dash1 = 0
#         ELSE
#            LET l_dash1 = 1
#         END IF
#
#         SELECT SUM(aah04) INTO l_aah041 FROM aah_file
#          WHERE aah00 = bookno    #NO.FUN-740055
#            AND aah01 = sr.aah01
#            AND aah02 = yy
#            AND aah03 >= m1
#            AND aah03 <= m2
#
#         SELECT SUM(aah05) INTO l_aah051 FROM aah_file
#          WHERE aah00 = bookno    #NO.FUN-740055
#            AND aah01 = sr.aah01
#            AND aah02 = yy
#            AND aah03 >= m1
#            AND aah03 <= m2
#
#         IF l_aah041 IS NULL THEN
#            LET l_aah041 = 0
#         END IF
#
#         IF l_aah051 IS NULL THEN
#            LET l_aah051 = 0
#         END IF
#
#         IF l_aah041 = 0 AND l_aah051 = 0 THEN
#            LET g_nonu = 0
#         ELSE
#            LET g_nonu = 1
#         END IF
#
#         IF g_nonu = 0 THEN
#            SELECT SUM(aah04) INTO s_aah04 FROM aah_file
#             WHERE aah00 = bookno    #NO.FUN-740055
#               AND aah01 = sr.aah01
#               AND aah02 = yy
#               AND aah03 < m1
#
#            SELECT SUM(aah05) INTO s_aah05 FROM aah_file
#             WHERE aah00 = bookno    #NO.FUN-740055
#               AND aah01 = sr.aah01
#               AND aah02 = yy
#               AND aah03 < m1
#
#            IF s_aah04 IS NULL THEN
#               LET s_aah04 = 0
#            END IF
#
#            IF s_aah05 IS NULL THEN
#               LET s_aah05 = 0
#            END IF
#
#            IF l_bal <> 0 THEN
#               IF l_bal > 0 THEN
#                  IF l_j <> 1 THEN   #TQC-5B0044
#                     PRINT g_dash2   #TQC-5B0044
#                  END IF             #TQC-5B0044
#                  PRINT COLUMN g_c[31],sr.aah01 CLIPPED,
#                        COLUMN g_c[32],sr.aag02 CLIPPED,
#                        COLUMN g_c[39],sr.aag13 CLIPPED,  #FUN-6C0012
#                        COLUMN g_c[34],g_x[12] CLIPPED,
#                        COLUMN g_c[38],cl_numfor(l_bal,38,g_azi04)
#               ELSE
#                  LET l_bal =l_bal * (-1)
#                  IF l_j <> 1 THEN   #TQC-5B0044
#                     PRINT g_dash2   #TQC-5B0044
#                  END IF             #TQC-5B0044
#                  PRINT COLUMN g_c[31],sr.aah01 CLIPPED,
#                        COLUMN g_c[32],sr.aag02 CLIPPED,
#                        COLUMN g_c[39],sr.aag13 CLIPPED,  #FUN-6C0012
#                        COLUMN g_c[34],g_x[12] CLIPPED,
#                        COLUMN g_c[38],cl_numfor(l_bal,38,g_azi04)
#                  LET l_bal =l_bal * (-1)
#               END IF
# 
#               PRINT ' '
# 
#               FOR l_i = m1 TO m2
#                  IF l_bal > 0 THEN
#                     PRINT COLUMN g_c[33],l_i,
#                           COLUMN g_c[34],g_x[13] CLIPPED,
#                           COLUMN g_c[35],cl_numfor(0,35,g_azi04),
#                           COLUMN g_c[36],cl_numfor(0,36,g_azi04),
#                           COLUMN g_c[37],g_x[10] CLIPPED,
#                           COLUMN g_c[38],cl_numfor(l_bal,38,g_azi04)
#                     PRINT COLUMN g_c[34],g_x[14] CLIPPED,
#                           COLUMN g_c[35],cl_numfor(s_aah04,35,g_azi04),
#                           COLUMN g_c[36],cl_numfor(s_aah05,36,g_azi04),
#                           COLUMN g_c[37],g_x[10] CLIPPED,
#                           COLUMN g_c[38],cl_numfor(l_bal,38,g_azi04)
#                  ELSE
#                     PRINT COLUMN g_c[33],l_i,
#                           COLUMN g_c[34],g_x[14] CLIPPED,
#                           COLUMN g_c[35],cl_numfor(0,35,g_azi04),
#                           COLUMN g_c[36],cl_numfor(0,36,g_azi04),
#                           COLUMN g_c[37],g_x[11] CLIPPED;
#                     LET l_bal = l_bal * (-1)
#                     PRINT COLUMN g_c[38],cl_numfor(l_bal,38,g_azi04)
#                     LET l_bal = l_bal * (-1)
#                     PRINT COLUMN g_c[34],g_x[14] CLIPPED,
#                           COLUMN g_c[35],cl_numfor(s_aah04,35,g_azi04),
#                           COLUMN g_c[36],cl_numfor(s_aah05,36,g_azi04),
#                           COLUMN g_c[37],g_x[11] CLIPPED;
#                     LET l_bal = l_bal * (-1)
#                     PRINT COLUMN g_c[38],cl_numfor(l_bal,38,g_azi04)
#                     LET l_bal = l_bal * (-1)
#                  END IF
#               END FOR
#            ELSE
#               IF tm.t = "Y" THEN
#                  IF l_j <> 1 THEN   #TQC-5B0044
#                     PRINT g_dash2   #TQC-5B0044
#                  END IF             #TQC-5B0044
#                  PRINT COLUMN g_c[31],sr.aah01 CLIPPED,
#                        COLUMN g_c[32],sr.aag02 CLIPPED,
#                        COLUMN g_c[39],sr.aag13 CLIPPED,  #FUN-6C0012
#                        COLUMN g_c[34],g_x[12] CLIPPED,
#                        COLUMN g_c[38],cl_numfor(l_bal,38,g_azi04)
#                  PRINT ' '
#               END IF
#            END IF
#         ELSE
#            IF l_bal >= 0 THEN
#               IF l_j <> 1 THEN   #TQC-5B0044
#                  PRINT g_dash2   #TQC-5B0044
#               END IF             #TQC-5B0044
#               PRINT COLUMN g_c[31],sr.aah01 CLIPPED,
#                     COLUMN g_c[32],sr.aag02 CLIPPED,
#                     COLUMN g_c[39],sr.aag13 CLIPPED,  #FUN-6C0012
#                     COLUMN g_c[34],g_x[12] CLIPPED,
#                     COLUMN g_c[38],cl_numfor(l_bal,38,g_azi04)
#            ELSE
#               LET l_bal =l_bal * (-1)
#               IF l_j <> 1 THEN   #TQC-5B0044
#                  PRINT g_dash2   #TQC-5B0044
#               END IF             #TQC-5B0044
#               PRINT COLUMN g_c[31],sr.aah01 CLIPPED,
#                     COLUMN g_c[32],sr.aag02 CLIPPED,
#                     COLUMN g_c[39],sr.aag13 CLIPPED,  #FUN-6C0012
#                     COLUMN g_c[34],g_x[12] CLIPPED,
#                     COLUMN g_c[38],cl_numfor(l_bal,38,g_azi04)
#               LET l_bal =l_bal * (-1)
#            END IF
#            PRINT ' '
#            IF sr.aah03 > m1 THEN
#               FOR l_i = m1 TO sr.aah03 - 1
#                  IF l_bal > 0 THEN
#                     PRINT COLUMN g_c[33],l_i,
#                           COLUMN g_c[34],g_x[13] CLIPPED,
#                           COLUMN g_c[35],cl_numfor(0,35,g_azi04),
#                           COLUMN g_c[36],cl_numfor(0,36,g_azi04),
#                           COLUMN g_c[37],g_x[10] CLIPPED,
#                           COLUMN g_c[38],cl_numfor(l_bal,38,g_azi04)
#                     PRINT COLUMN g_c[34],g_x[14] CLIPPED,
#                           COLUMN g_c[35],cl_numfor(0,35,g_azi04),
#                           COLUMN g_c[36],cl_numfor(0,36,g_azi04),
#                           COLUMN g_c[37],g_x[10] CLIPPED,
#                           COLUMN g_c[38],cl_numfor(l_bal,38,g_azi04)
#                  ELSE
#                     IF l_bal < 0 THEN
#                        PRINT COLUMN g_c[33],l_i,
#                              COLUMN g_c[34],g_x[13] CLIPPED,
#                              COLUMN g_c[35],cl_numfor(0,35,g_azi04),
#                              COLUMN g_c[36],cl_numfor(0,36,g_azi04),
#                              COLUMN g_c[37],g_x[11] CLIPPED;
#                        LET l_bal = l_bal * (-1)
#                        PRINT COLUMN g_c[38],cl_numfor(l_bal,38,g_azi04)
#                        LET l_bal = l_bal * (-1)
#                        PRINT COLUMN g_c[34],g_x[14] CLIPPED,
#                              COLUMN g_c[35],cl_numfor(0,35,g_azi04),
#                              COLUMN g_c[36],cl_numfor(0,36,g_azi04),
#                              COLUMN g_c[37],g_x[11] CLIPPED;
#                        LET l_bal = l_bal * (-1)
#                        PRINT COLUMN g_c[38],cl_numfor(l_bal,38,g_azi04)
#                        LET l_bal = l_bal * (-1)
#                     ELSE
#                        PRINT COLUMN g_c[33],l_i,
#                              COLUMN g_c[34],g_x[13] CLIPPED,
#                              COLUMN g_c[35],cl_numfor(0,35,g_azi04),
#                              COLUMN g_c[36],cl_numfor(0,36,g_azi04),
#                              COLUMN g_c[37],' ' CLIPPED,
#                              COLUMN g_c[38],cl_numfor(l_bal,38,g_azi04)
#                        PRINT COLUMN g_c[34],g_x[14] CLIPPED,
#                              COLUMN g_c[35],cl_numfor(0,35,g_azi04),
#                              COLUMN g_c[36],cl_numfor(0,36,g_azi04),
#                              COLUMN g_c[37],' ' CLIPPED,
#                              COLUMN g_c[38],cl_numfor(l_bal,38,g_azi04)
#                     END IF
#                  END IF
#               END FOR
#            END IF
#         END IF
#      BEFORE GROUP OF sr.aah03
#         IF g_nonu = 1 AND sr.aah03 > l_old_aah03 + 1 THEN
#            SELECT SUM(aah04) INTO l_aah04 FROM aah_file
#             WHERE aah00 = bookno   #NO.FUN-740055
#               AND aah01 = sr.aah01
#               AND aah02 = yy
#               AND aah03 < sr.aah03
#               AND aah03 > 0
#
#            SELECT SUM(aah05) INTO l_aah05 FROM aah_file
#             WHERE aah00 = bookno   #NO.FUN-740055
#               AND aah01 = sr.aah01
#               AND aah02 = yy
#               AND aah03 < sr.aah03
#               AND aah03 > 0
#
#            IF l_aah04 IS NULL THEN
#               LET l_aah04 = 0
#            END IF
#
#            IF l_aah05 IS NULL THEN
#               LET l_aah05 = 0
#            END IF
#
#            IF l_bal > 0 THEN
#               FOR l_i = l_old_aah03 + 1 TO sr.aah03 - 1
#                  PRINT COLUMN g_c[33],l_i,
#                        COLUMN g_c[34],g_x[13] CLIPPED,
#                        COLUMN g_c[35],cl_numfor(0,35,g_azi04),
#                        COLUMN g_c[36],cl_numfor(0,36,g_azi04),
#                        COLUMN g_c[37],g_x[10] CLIPPED,
#                        COLUMN g_c[38],cl_numfor(l_bal,38,g_azi04)
#                  PRINT COLUMN g_c[34],g_x[14] CLIPPED,
#                        COLUMN g_c[35],cl_numfor(l_aah04,35,g_azi04),
#                        COLUMN g_c[36],cl_numfor(l_aah05,36,g_azi04),
#                        COLUMN g_c[37],g_x[10] CLIPPED,
#                        COLUMN g_c[38],cl_numfor(l_bal,38,g_azi04)
#               END FOR
#            ELSE
#               IF l_bal < 0 THEN
#                  FOR l_i = l_old_aah03 + 1 TO sr.aah03 - 1
#                     PRINT COLUMN g_c[33],l_i,
#                           COLUMN g_c[34],g_x[13] CLIPPED,
#                           COLUMN g_c[35],cl_numfor(0,35,g_azi04),
#                           COLUMN g_c[36],cl_numfor(0,36,g_azi04),
#                           COLUMN g_c[37],g_x[11] CLIPPED;
#                     LET l_bal = l_bal * (-1)
#                     PRINT COLUMN g_c[38],cl_numfor(l_bal,38,g_azi04)
#                     LET l_bal = l_bal * (-1)
#                     PRINT COLUMN g_c[34],g_x[14] CLIPPED,
#                           COLUMN g_c[35],cl_numfor(l_aah04,35,g_azi04),
#                           COLUMN g_c[36],cl_numfor(l_aah05,36,g_azi04),
#                           COLUMN g_c[37],g_x[11] CLIPPED;
#                     LET l_bal = l_bal * (-1)
#                     PRINT COLUMN g_c[38],cl_numfor(l_bal,38,g_azi04)
#                     LET l_bal = l_bal * (-1)
#                  END FOR
#               ELSE
#                  FOR l_i = l_old_aah03 + 1 TO sr.aah03 - 1
#                     PRINT COLUMN g_c[33],l_i,
#                           COLUMN g_c[34],g_x[13] CLIPPED,
#                           COLUMN g_c[35],cl_numfor(0,35,g_azi04),
#                           COLUMN g_c[36],cl_numfor(0,36,g_azi04),
#                           COLUMN g_c[37],' ' CLIPPED;
#                     PRINT COLUMN g_c[38],cl_numfor(l_bal,38,g_azi04)
#                     PRINT COLUMN g_c[34],g_x[14] CLIPPED,
#                           COLUMN g_c[35],cl_numfor(l_aah04,35,g_azi04),
#                           COLUMN g_c[36],cl_numfor(l_aah05,36,g_azi04),
#                           COLUMN g_c[37],' ' CLIPPED;
#                     PRINT COLUMN g_c[38],cl_numfor(l_bal,38,g_azi04)
#                  END FOR
#               END IF
#            END IF
#         END IF
# 
#      ON EVERY ROW
#         IF sr.aah04 IS NULL THEN
#            LET sr.aah04 = 0
#         END IF
#
#         IF sr.aah05 IS NULL THEN
#            LET sr.aah05 = 0
#         END IF
#
#         LET l_cc1 = l_bal + sr.aah04 - sr.aah05
#
#         IF l_cc1 IS NULL THEN
#            LET l_cc1 = 0
#         END IF
#
#         IF g_nonu = 1 THEN
#            LET l_old_aah03 = sr.aah03
#            PRINT COLUMN g_c[33],sr.aah03,
#                  COLUMN g_c[34],g_x[13] CLIPPED,
#                  COLUMN g_c[35],cl_numfor(sr.aah04,35,g_azi04),
#                  COLUMN g_c[36],cl_numfor(sr.aah05,36,g_azi04);
#            IF l_cc1 > 0 THEN
#               PRINT COLUMN g_c[37],g_x[10] CLIPPED,
#                     COLUMN g_c[38],cl_numfor(l_cc1,38,g_azi04)
#            ELSE
#               IF l_cc1 < 0 THEN
#                  LET l_cc1 = l_cc1 * (-1)
#                  PRINT COLUMN g_c[37],g_x[11] CLIPPED,
#                        COLUMN g_c[38],cl_numfor(l_cc1,38,g_azi04)
#                  LET l_cc1 = l_cc1 * (-1)
#               ELSE
#                  PRINT COLUMN g_c[37],'  ',
#                        COLUMN g_c[38],cl_numfor(l_cc1,38,g_azi04)
#               END IF
#            END IF
#
#            SELECT SUM(aah04) INTO l_aah04 FROM aah_file
#             WHERE aah00 = bookno   #NO.FUN-740055
#               AND aah01 = sr.aah01
#               AND aah02 = yy
#               AND aah03 <= sr.aah03
#               AND aah03 > 0
#
#            SELECT SUM(aah05) INTO l_aah05 FROM aah_file
#             WHERE aah00 = bookno  #NO.FUN-740055
#               AND aah01 = sr.aah01
#               AND aah02 = yy
#               AND aah03 <= sr.aah03
#               AND aah03 > 0
#
#            IF l_aah04 IS NULL THEN
#               LET l_aah04 = 0
#            END IF
#
#            IF l_aah05 IS NULL THEN
#               LET l_aah05 = 0
#            END IF
# 
#            PRINT COLUMN g_c[34],g_x[14] CLIPPED,
#                  COLUMN g_c[35],cl_numfor(l_aah04,35,g_azi04),
#                  COLUMN g_c[36],cl_numfor(l_aah05,18,g_azi04);
#
#            IF l_cc1 > 0 THEN
#               PRINT COLUMN g_c[37],g_x[10] CLIPPED,
#                     COLUMN g_c[38],cl_numfor(l_cc1,38,g_azi04)
#            ELSE
#               IF l_cc1 < 0 THEN
#                  LET l_cc1 = l_cc1 * (-1)
#                  PRINT COLUMN g_c[37],g_x[11] CLIPPED,
#                        COLUMN g_c[38],cl_numfor(l_cc1,38,g_azi04)
#                  LET l_cc1 = l_cc1 * (-1)
#               ELSE
#                  PRINT COLUMN g_c[37],'  ',
#                        COLUMN g_c[38],cl_numfor(l_cc1,38,g_azi04)
#               END IF
#            END IF
#            LET l_bal = l_cc1
#         END IF
# 
#      AFTER GROUP OF sr.aah01
#         IF g_nonu = 1 THEN
#            IF sr.aah03 < m2 THEN
#               FOR l_i = sr.aah03+1 TO m2
#                  SELECT SUM(aah04) INTO l_aah04 FROM aah_file
#                   WHERE aah00 = bookno     #NO.FUN-740055
#                     AND aah01 = sr.aah01
#                     AND aah02 = yy
#                     AND aah03 <= l_i
#                     AND aah03 > 0
#
#                  SELECT SUM(aah05) INTO l_aah05 FROM aah_file
#                   WHERE aah00 = bookno    #NO.FUN-740055
#                     AND aah01 = sr.aah01
#                     AND aah02 = yy
#                     AND aah03 <= l_i
#                     AND aah03 > 0
#
#                  IF l_aah04 IS NULL THEN
#                     LET l_aah04 = 0
#                  END IF
# 
#                  IF l_aah05 IS NULL THEN
#                     LET l_aah05 = 0
#                  END IF
# 
#                  IF l_bal > 0 THEN
#                     PRINT COLUMN g_c[33],l_i,
#                           COLUMN g_c[34],g_x[13] CLIPPED,
#                           COLUMN g_c[35],cl_numfor(0,35,g_azi04),
#                           COLUMN g_c[36],cl_numfor(0,36,g_azi04),
#                           COLUMN g_c[37],g_x[10] CLIPPED,
#                           COLUMN g_c[38],cl_numfor(l_bal,38,g_azi04)
#                     PRINT COLUMN g_c[34],g_x[14] CLIPPED,
#                           COLUMN g_c[35],cl_numfor(l_aah04,35,g_azi04),
#                           COLUMN g_c[36],cl_numfor(l_aah05,36,g_azi04),
#                           COLUMN g_c[37],g_x[10] CLIPPED,
#                           COLUMN g_c[38],cl_numfor(l_bal,38,g_azi04)
#                  ELSE
#                     IF l_bal < 0 THEN
#                        PRINT COLUMN g_c[33],l_i,
#                              COLUMN g_c[34],g_x[13] CLIPPED,
#                              COLUMN g_c[35],cl_numfor(0,35,g_azi04),
#                              COLUMN g_c[36],cl_numfor(0,36,g_azi04),
#                              COLUMN g_c[37],g_x[11] CLIPPED;
#                        LET l_bal = l_bal * (-1)
#                        PRINT COLUMN g_c[38],cl_numfor(l_bal,38,g_azi04)
#                        LET l_bal = l_bal * (-1)
#                        PRINT COLUMN g_c[34],g_x[14] CLIPPED,
#                              COLUMN g_c[35],cl_numfor(l_aah04,35,g_azi04),
#                              COLUMN g_c[36],cl_numfor(l_aah05,36,g_azi04),
#                              COLUMN g_c[37],g_x[11] CLIPPED;
#                        LET l_bal = l_bal * (-1)
#                        PRINT COLUMN g_c[38],cl_numfor(l_bal,38,g_azi04)
#                        LET l_bal = l_bal * (-1)
#                     ELSE
#                        PRINT COLUMN g_c[33],l_i,
#                              COLUMN g_c[34],g_x[13] CLIPPED,
#                              COLUMN g_c[35],cl_numfor(0,35,g_azi04),
#                              COLUMN g_c[36],cl_numfor(0,36,g_azi04),
#                              COLUMN g_c[37],' ' CLIPPED,
#                              COLUMN g_c[38],cl_numfor(l_bal,38,g_azi04)
#                        PRINT COLUMN g_c[34],g_x[14] CLIPPED,
#                              COLUMN g_c[35],cl_numfor(l_aah04,35,g_azi04),
#                              COLUMN g_c[36],cl_numfor(l_aah05,36,g_azi04),
#                              COLUMN g_c[37],' ' CLIPPED,
#                              COLUMN g_c[38],cl_numfor(l_bal,38,g_azi04)
#                     END IF
#                  END IF
#               END FOR
#            END IF
#         END IF
# 
#         PRINT '  '
#         IF tm.u ='N'  THEN
#            IF g_nonu = 1 OR l_dash1 = 1 OR tm.t = "Y" THEN
##               PRINT g_dash2   #TQC-5B0044
#               LET l_j = l_j + 1    #TQC-5B0044
#            END IF
#         END IF
# 
#      ON LAST ROW
#         IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#            CALL cl_wcchp(tm.wc,'aag01') RETURNING tm.wc
#            PRINT g_dash[1,g_len]
#	    #TQC-630166
#            #IF tm.wc[001,070] > ' ' THEN                  # for 80
#            #   PRINT COLUMN g_c[31],g_x[8] CLIPPED,
#            #         COLUMN g_c[32],tm.wc[001,070] CLIPPED
#            #END IF
#            #IF tm.wc[071,140] > ' ' THEN
#            #   PRINT COLUMN g_c[32],tm.wc[071,140] CLIPPED
#            #END IF
#            #IF tm.wc[141,210] > ' ' THEN
#            #   PRINT COLUMN g_c[32],tm.wc[141,210] CLIPPED
#            #END IF
#            #IF tm.wc[211,280] > ' ' THEN
#            #   PRINT COLUMN g_c[32],tm.wc[211,280] CLIPPED
#            #END IF
#	     CALL cl_prt_pos_wc(tm.wc)
#            #END TQC-630166
#         END IF
#         PRINT g_dash[1,g_len]
#         LET l_last_sw = 'y'
#         PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[7] CLIPPED  #No.MOD-580211
# 
#      PAGE TRAILER
#         IF l_last_sw = 'n' THEN
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[6] CLIPPED  #No.MOD-580211
#         ELSE
#            SKIP 2 LINE
#         END IF
#
#END REPORT
#No.FUN-7C0064  --End  
#Patch....NO.TQC-610037 <001> #
 
#No.FUN-7C0064  --Begin
FUNCTION r300_y_aah(p_aah01,p_aah03)
  DEFINE p_aah01    LIKE aah_file.aah01
  DEFINE p_aah03    LIKE aah_file.aah03
  DEFINE l_aah04    LIKE aah_file.aah04
  DEFINE l_aah05    LIKE aah_file.aah05
 
     LET l_aah04 = 0   LET l_aah05 = 0
     SELECT SUM(aah04) INTO l_aah04 FROM aah_file
      WHERE aah00 = bookno    #NO.FUN-740055
        AND aah01 = p_aah01
        AND aah02 = yy
        AND aah03 <= p_aah03
        AND aah03 > 0
 
     SELECT SUM(aah05) INTO l_aah05 FROM aah_file
      WHERE aah00 = bookno    #NO.FUN-740055
        AND aah01 = p_aah01
        AND aah02 = yy
        AND aah03 <= p_aah03
        AND aah03 > 0
 
     IF l_aah04 IS NULL THEN
        LET l_aah04 = 0
     END IF
 
     IF l_aah05 IS NULL THEN
        LET l_aah05 = 0
     END IF
 
     RETURN l_aah04,l_aah05
END FUNCTION
 
FUNCTION r300_bal_aah(p_aah01,p_aah03)
  DEFINE p_aah01      LIKE aah_file.aah01
  DEFINE p_aah03      LIKE aah_file.aah03
  DEFINE l_bal        LIKE aah_file.aah04
  DEFINE l_aah04      LIKE aah_file.aah04
  DEFINE l_aah05      LIKE aah_file.aah05
 
     LET l_bal = 0  LET l_aah04 = 0  LET l_aah05 = 0
     #期初
     SELECT SUM(aah04-aah05) INTO l_bal FROM aah_file
      WHERE aah01 = p_aah01
        AND aah02 = yy
        AND aah03 < p_aah03
        AND aah00 = bookno
 
     IF l_bal IS NULL THEN LET l_bal = 0 END IF
 
     #本期
     SELECT SUM(aah04) INTO l_aah04 FROM aah_file
      WHERE aah00 = bookno
        AND aah01 = p_aah01
        AND aah02 = yy
        AND aah03 = p_aah03
 
     SELECT SUM(aah05) INTO l_aah05 FROM aah_file
      WHERE aah00 = bookno
        AND aah01 = p_aah01
        AND aah02 = yy
        AND aah03 = p_aah03
 
     IF l_aah04 IS NULL THEN LET l_aah04 = 0 END IF
     IF l_aah05 IS NULL THEN LET l_aah05 = 0 END IF
     RETURN l_bal,l_aah04,l_aah05
END FUNCTION
 
FUNCTION r300_f(p_aah01,p_aah03_1,p_aah03_2)
   DEFINE p_aah01      LIKE aah_file.aah01
   DEFINE p_aah03_1    LIKE aah_file.aah03
   DEFINE p_aah03_2    LIKE aah_file.aah03
   DEFINE l_bal        LIKE aah_file.aah04
   DEFINE l_aah04      LIKE aah_file.aah04
   DEFINE l_aah05      LIKE aah_file.aah05
   
      LET l_bal = 0  LET l_aah04 = 0  LET l_aah05 = 0
 
      SELECT SUM(aah04-aah05) INTO l_bal FROM aah_file
       WHERE aah01 = p_aah01
         AND aah02 = yy
         AND aah03 < p_aah03_1
         AND aah00 = bookno
 
      IF l_bal IS NULL THEN LET l_bal = 0 END IF
 
      SELECT SUM(aah04) INTO l_aah04 FROM aah_file
       WHERE aah00 = bookno
         AND aah01 = p_aah01
         AND aah02 = yy
         AND aah03 >= p_aah03_1
         AND aah03 <= p_aah03_2
 
      SELECT SUM(aah05) INTO l_aah05 FROM aah_file
       WHERE aah00 = bookno
         AND aah01 = p_aah01
         AND aah02 = yy
         AND aah03 >= p_aah03_1
         AND aah03 <= p_aah03_2
 
      IF l_aah04 IS NULL THEN LET l_aah04 = 0 END IF
      IF l_aah05 IS NULL THEN LET l_aah05 = 0 END IF
      
      RETURN l_bal,l_aah04,l_aah05
END FUNCTION
#No.FUN-7C0064  --End  
