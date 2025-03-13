# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: gglr905.4gl
# Descriptions...: 總分類帳
# Input parameter:
# Return code....:
# Date & Author..: 92/03/10 By DAVID
# Modify.........: No.FUN-510007 05/01/18 By Nicola 報表架構修改
# Modify.........: No.MOD-580211 05/09/08 By ice  修改報表列印格式
# Modify.........: No.TQC-5B0102 05/11/15 By yoyo報表修改
# Modify.........: No.FUN-5C0015 06/01/03 By miki
#                  列印l_buf異動碼值內容，加上abb11~36，放寬欄寬至60
# Modify.........: No.TQC-630166 06/03/16 By 整批修改，將g_wc[1,70]改為g_wc.subString(1,......)寫法
# Modify.........: No.FUN-660124 06/06/21 By Cheunl cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-690009 06/09/06 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.CHI-6A0004 06/10/23 By atsea g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.TQC-6A0094 06/11/10 By johnray 報表修改
# Modify.........: No.CHI-710005 07/01/18 By Elva 去掉aza26的判斷
# Modify.........: No.FUN-740055 07/04/13 By johnray   會計科目加帳套
# Modify.........: No.TQC-740305 07/04/30 By Lynn 制表日期位置在報表名之上
# Modify.........: No.FUN-780031 07/08/28 By Carrier 報表轉Crystal Report格式
# Modify.........: No.FUN-870151 08/08/13 By xiaofeizhu 報表中匯率欄位小數位數沒有依 aooi050 做取位
# Modify.........: No.MOD-860252 08/07/02 By chenl   增加打印時是否打印貨幣性科目或全部科目的選擇。
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A70007 10/07/13 By Summer 多帳期改用s_azmm,並依據畫面上的帳別傳遞使用
# Modify.........: No.FUN-B20054 10/02/23 By yangtingting 先錄入帳套,科目根據帳套過濾;結構改為DIALOG
# Modify.........: No.TQC-B30147 11/03/18 By yinhy 查詢條件為空，跳到科目編號欄位
# Modify.........: No:FUN-B80096 11/08/10 By Lujh 模組程序撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
             #wc        VARCHAR(1000),
	      wc	STRING,			#TQC-630166
              t         LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
              u         LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
              s         LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
              v         LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
              x         LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
              h         LIKE type_file.chr1,    #MOD-860252
              #y        LIKE type_file.num5,    #NO FUN-690009   SMALLINT   #TQC-610056
              more      LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
              bookno    LIKE aaa_file.aaa01     #No.FUN-740055
           END RECORD,
     yy,mm           LIKE type_file.num10,   #NO FUN-690009   INTEGER
     l_begin,l_end   LIKE type_file.dat,     #NO FUN-690009   DATE
     bdate,edate     LIKE type_file.dat,     #NO FUN-690009   DATE
#     g_bookno        LIKE aaa_file.aaa01,    #帳別   #No.FUN-740055
     l_flag          LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)
DEFINE   g_aaa03     LIKE aaa_file.aaa03
DEFINE   g_cnt       LIKE type_file.num10    #NO FUN-690009   INTEGER
DEFINE   g_i         LIKE type_file.num5     #NO FUN-690009   SMALLINT   #count/index for any purpose
DEFINE   l_table     STRING                  #No.FUN-780031
DEFINE   g_str       STRING                  #No.FUN-780031
DEFINE   g_sql       STRING                  #No.FUN-780031
 
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
 
   #No.FUN-780031  --Begin
   LET g_sql = " aea01.aea_file.aea01,",
               " aag02.aag_file.aag02,",
               " aea02.aea_file.aea02,",
               " aea03.aea_file.aea03,",
               " abb04.abb_file.abb04,",
               " abb06.abb_file.abb06,",
               " abb07.abb_file.abb07,",
               " abb07f.abb_file.abb07f,",
               " abb24.abb_file.abb24,",
               " abb25.abb_file.abb25,",
               " buf.type_file.chr1000,",
               " abc04.type_file.chr1000,",
               " bal.aah_file.aah04,",
               " azi04.azi_file.azi04,",
               " azi05.azi_file.azi05,",
               " azi07.azi_file.azi07"                       #FUN-870151
 
   LET l_table = cl_prt_temptable('gglr905',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?               ) "  #FUN-870151
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-780031  --End
 
#   LET g_bookno= ARG_VAL(1)   #No.FUN-740055
   LET tm.bookno= ARG_VAL(1)   #No.FUN-740055
   LET g_pdate = ARG_VAL(2)            # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   LET tm.s  = ARG_VAL(11)
   LET tm.v  = ARG_VAL(12)
   LET tm.x  = ARG_VAL(13)
   #LET tm.y  = ARG_VAL(14)   #TQC-610056
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
#   IF g_bookno IS  NULL OR g_bookno = ' ' THEN   #No.FUN-740055
   IF tm.bookno IS  NULL OR tm.bookno = ' ' THEN   #No.FUN-740055
#      LET g_bookno = g_aaz.aaz64   #No.FUN-740055
      LET tm.bookno = g_aza.aza81   #No.FUN-740055
   END IF
 
   #-->使用預設帳別之幣別
#   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno   #No.FUN-740055
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.bookno   #No.FUN-740055
   IF SQLCA.sqlcode THEN
      LET g_aaa03 = g_aza.aza17
   END IF
 
#   SELECT azi04,azi05 INTO g_azi04,g_azi05 FROM azi_file WHERE azi01 = g_aaa03  #No.CHI-6A0004
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_aaa03,SQLCA.sqlcode,0)   #No.FUN-660124
      CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","",0)   #No.FUN-660124
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80096   ADD 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL gglr905_tm()
   ELSE
      CALL gglr905()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
END MAIN
 
FUNCTION gglr905_tm()
DEFINE lc_qbe_sn           LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col      LIKE type_file.num5,    #NO FUN-690009   SMALLINT
       l_cmd            LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(400)
DEFINE li_chk_bookno LIKE type_file.num5   #FUN-B20054
 
#   CALL s_dsmark(g_bookno)   #No.FUN-740055
   CALL s_dsmark(tm.bookno)   #No.FUN-740055
   LET p_row = 2 LET p_col = 20
   OPEN WINDOW gglr905_w AT p_row,p_col
     WITH FORM "ggl/42f/gglr905"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
# Prog. Version..: '5.30.06-13.03.12(0,0,g_bookno)   #No.FUN-740055
   CALL s_shwact(0,0,tm.bookno)   #No.FUN-740055
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  # Default condition
   LET bdate   = NULL
   LET edate   = NULL
   LET tm.t    = 'Y'
   LET tm.u    = 'N'
   LET tm.s    = 'Y'
   LET tm.v    = 'N'
   LET tm.x    = 'N'
   LET tm.h    = 'Y'    #NO.MOD-860252
   LET tm.more = 'N'
   LET tm.bookno = g_aza.aza81          #FUN-B20054
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   DISPLAY BY NAME tm.t,tm.u,tm.s,tm.v,tm.x,tm.h,tm.more #No.MOD-860252 add tm.h  #FUN-B20054
   WHILE TRUE
   #FUN-B20054--add--str--
    DIALOG ATTRIBUTE(unbuffered)
       INPUT BY NAME tm.bookno ATTRIBUTE(WITHOUT DEFAULTS)
          AFTER FIELD bookno 
            IF NOT cl_null(tm.bookno) THEN
                   CALL s_check_bookno(tm.bookno,g_user,g_plant)
                    RETURNING li_chk_bookno
                IF (NOT li_chk_bookno) THEN
                    NEXT FIELD bookno
                END IF
                SELECT aaa02 FROM aaa_file WHERE aaa01 = tm.bookno
                IF STATUS THEN
                   CALL cl_err3("sel","aaa_file",tm.bookno,"","agl-043","","",0)
                   NEXT FIELD bookno
                END IF
            END IF
       END INPUT
     #FUN-B20054--add--end
      CONSTRUCT BY NAME tm.wc ON aag01
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
        
         #FUN-B20054--mark--str--
         #ON ACTION locale
         #   LET g_action_choice = "locale"
         # CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #   EXIT CONSTRUCT
         #
         #ON IDLE g_idle_seconds
         #   CALL cl_on_idle()
         #   CONTINUE CONSTRUCT
         #
         # ON ACTION about         #MOD-4C0121
         #    CALL cl_about()      #MOD-4C0121
         #
         # ON ACTION help          #MOD-4C0121
         #    CALL cl_show_help()  #MOD-4C0121
         #
         # ON ACTION controlg      #MOD-4C0121
         #    CALL cl_cmdask()     #MOD-4C0121
         #
         #ON ACTION exit
         #   LET INT_FLAG = 1
         #   EXIT CONSTRUCT  
         #FUN-B20054--mark--end--
 
         #No.FUN-580031 --start--
         #FUN-B20054--mark--str--
         #ON ACTION qbe_select
         #   CALL cl_qbe_select()
         #   #FUN-B20054--mark--end--
         #No.FUN-580031 ---end---
 
      END CONSTRUCT
      #FUN-B20054--mark--str--
      #IF g_action_choice = "locale" THEN
      #   LET g_action_choice = ""
      #   CALL cl_dynamic_locale()
      #   CONTINUE WHILE
      #END IF
      #
      #IF INT_FLAG THEN
      #   LET INT_FLAG = 0
      #   CLOSE WINDOW gglr905_w
      #   EXIT PROGRAM
      #END IF
      #FUN-B20054--mark--end--
      #FUN-B20054--TO AFTER END DIALOG--str--
      #IF tm.wc = ' 1=1' THEN
      #   CALL cl_err('','9046',0)
      #   CONTINUE WHILE
      #END IF   
      #FUN-B20054--TO AFTER END DIALOG--end-- 
      
 
      #DISPLAY BY NAME tm.t,tm.u,tm.s,tm.v,tm.x,tm.h,tm.more #No.MOD-860252 add tm.h  #FUN-B20054	
 
      INPUT BY NAME bdate,edate,tm.t,tm.u,tm.s,tm.v,tm.x,tm.h,tm.more  #No.FUN-740055 #No.MOD-860252 add tm.h   #FUN-B20054 del bookno 
            #WITHOUT DEFAULTS  #FUN-B20054
            ATTRIBUTE(WITHOUT DEFAULTS)  #FUN-B20054
            
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD bdate
            IF bdate IS NULL THEN
               NEXT FIELD bdate
            END IF
 
         AFTER FIELD edate
            IF edate IS NULL THEN
               LET edate = g_lastdat
            END IF
            IF edate < bdate THEN
               CALL cl_err(' ','agl-031',0)
               NEXT FIELD edate
            END IF
 
         AFTER FIELD t
            IF tm.t NOT MATCHES "[YN]" THEN
               NEXT FIELD t
            END IF
 
         AFTER FIELD u
            IF tm.u NOT MATCHES "[YN]" THEN
               NEXT FIELD u
            END IF
 
         AFTER FIELD s
            IF tm.s NOT MATCHES "[YN]" THEN
               NEXT FIELD s
            END IF
 
         AFTER FIELD v
            IF tm.v NOT MATCHES "[YN]" THEN
               NEXT FIELD v
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
 
#No.FUN-740055 -- begin --
#FUN-B20054--mark--str--
         #ON ACTION CONTROLP
         #   CASE
         #   WHEN INFIELD(bookno)
         #     CALL cl_init_qry_var()
         #     LET g_qryparam.form ="q_aaa"
         #     LET g_qryparam.default1 = tm.bookno
         #     CALL cl_create_qry() RETURNING tm.bookno
         #     DISPLAY tm.bookno TO bookno
         #     NEXT FIELD bookno
         #   END CASE   
#FUN-B20054--mark--end--
#No.FUN-740055 -- end --
 
#FUN-B20054--mark--str--
#         ON ACTION CONTROLR
#            CALL cl_show_req_fields()
# 
#         ON ACTION CONTROLG
#            CALL cl_cmdask()
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
#            ON ACTION exit
#            LET INT_FLAG = 1
#            EXIT INPUT  
#FUN-B20054--mark--end--
 
         #No.FUN-580031 --start--
#FUN-B20054--mark--str--
#         ON ACTION qbe_save
#            CALL cl_qbe_save()
#FUN-B20054--mark--end--
         #No.FUN-580031 ---end---
 
      END INPUT
      
      #FUN-B20054--add--str--
      ON ACTION CONTROLP
          CASE
             WHEN INFIELD(bookno)
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_aaa'
                LET g_qryparam.default1 = tm.bookno
                CALL cl_create_qry() RETURNING tm.bookno
                DISPLAY tm.bookno TO FORMONLY.bookno
                NEXT FIELD bookno
             WHEN INFIELD(aag01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag02"
                LET g_qryparam.state = "c"
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
       CLOSE WINDOW gglr905_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
       EXIT PROGRAM
    END IF
    #FUN-B20054--add--end--
  
     IF tm.wc = ' 1=1' THEN              #FUN-B20054
        CALL cl_err('','9046',0)         #FUN-B20054
        CONTINUE WHILE                   #FUN-B20054
     END IF                              #FUN-B20054
      SELECT azn02,azn04 INTO yy,mm FROM azn_file WHERE azn01 = bdate
 
      #CALL s_azm(yy,mm) RETURNING l_flag,l_begin,l_end #CHI-A70007 mark
      #CHI-A70007 add --start--
      IF g_aza.aza63 = 'Y' THEN
         CALL s_azmm(yy,mm,g_plant,tm.bookno) RETURNING l_flag,l_begin,l_end
      ELSE
         CALL s_azm(yy,mm) RETURNING l_flag,l_begin,l_end
      END IF
      #CHI-A70007 add --end--
 
      IF l_begin = bdate THEN
         LET l_begin = DATE(2958464)
      END IF
 
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file      #get exec cmd (fglgo xxxx)
          WHERE zz01='gglr905'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
             CALL cl_err('gglr905','9031',1)   
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,            #(at time fglgo xxxx p1 p2 p3)
#                        " '",g_bookno CLIPPED,"' ",   #No.FUN-740055
                        " '",tm.bookno CLIPPED,"' ",   #No.FUN-740055
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
                        " '",tm.s CLIPPED,"'",
                        " '",tm.v CLIPPED,"'",
                        " '",tm.x CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('gglr905',g_time,l_cmd)      # Execute cmd at later time
         END IF
 
         CLOSE WINDOW gglr905_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL gglr905()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW gglr905_w
 
END FUNCTION
 
FUNCTION gglr905()
   DEFINE l_name      LIKE type_file.chr20,   #NO FUN-690009   VARCHAR(20)   # External(Disk) file name
#       l_time          LIKE type_file.chr8          #No.FUN-6A0097
          l_sql       LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(1000) # RDSQL STATEMENT
          l_sql1      LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(1000) # RDSQL STATEMENT
          l_chr       LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
          sr1    RECORD
                    aag00 LIKE aag_file.aag00,     #No.FUN-740055
                    aag01 LIKE aag_file.aag01,
                    aag02 LIKE aag_file.aag02,
                    aag07 LIKE aag_file.aag07,
                    aag24 LIKE aag_file.aag24
                 END RECORD,
          sr     RECORD
                    aea01   LIKE aea_file.aea01,
                    aea02   LIKE aea_file.aea02,
                    aea03   LIKE aea_file.aea03,
                    aea04   LIKE aea_file.aea04,
                    aba05   LIKE aba_file.aba05,
                    aba06   LIKE aba_file.aba06,
                    abb04   LIKE abb_file.abb04,
                    abb05   LIKE abb_file.abb05,
                    abb06   LIKE abb_file.abb06,
                    abb07   LIKE abb_file.abb07,
                    abb07f  LIKE abb_file.abb07f,
                    abb11   LIKE abb_file.abb11,
                    abb12   LIKE abb_file.abb12,
                    abb13   LIKE abb_file.abb13,
                    abb14   LIKE abb_file.abb14,
                    abb31   LIKE abb_file.abb31,   #FUN-5C0015-----(S)
                    abb32   LIKE abb_file.abb32,
                    abb33   LIKE abb_file.abb33,
                    abb34   LIKE abb_file.abb34,
                    abb35   LIKE abb_file.abb35,
                    abb36   LIKE abb_file.abb36,   #FUN-5C0015-----(E)
                    abb24   LIKE abb_file.abb24,
                    abb25   LIKE abb_file.abb25,
                    aag02   LIKE aag_file.aag02,
                    azi04   LIKE azi_file.azi04,
                    amt     LIKE abb_file.abb07
                 END RECORD
   #No.FUN-780031  --Begin
   DEFINE l_buf     LIKE type_file.chr1000
   DEFINE t_abc04   LIKE type_file.chr1000
   DEFINE l_abc04   LIKE abc_file.abc04
   DEFINE l_bal     LIKE aah_file.aah04
   DEFINE l_space   LIKE type_file.num5
   #No.FUN-780031  --End
   DEFINE l_azi07   LIKE azi_file.azi07            #FUN-870151     
 
   #No.FUN-780031  --Begin
   CALL cl_del_data(l_table)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   #No.FUN-780031  --End  
   #No.FUN-B80096--mark--Begin---
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
   #No.FUN-B80096--mark--End-----
   SELECT aaf03 INTO g_company FROM aaf_file
#    WHERE aaf01 = g_bookno   #No.FUN-740055
    WHERE aaf01 = tm.bookno   #No.FUN-740055
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
 
 
   LET l_sql1= "SELECT aag00,aag01,aag02,aag07,aag24 ",  #No.FUN-780031
               "  FROM aag_file ",
               " WHERE aag03 ='2' AND aag07 IN ('1','3') ",
               "   AND aag00 = '",tm.bookno,"'",         #No.FUN-780031
               "   AND ",tm.wc CLIPPED
 
   #No.MOD-860252--begin--
   IF tm.h = 'Y' THEN 
      LET l_sql1 = l_sql1 CLIPPED ," AND aag09='Y' " 
   END IF
   #No.MOD-860252---end---
   PREPARE gglr905_prepare2 FROM l_sql1
   IF STATUS != 0 THEN
      CALL cl_err('prepare:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF
   DECLARE gglr905_curs2 CURSOR FOR gglr905_prepare2
 
   LET l_sql = "SELECT ",
            " aea01,aea02,aea03,aea04,aba05,aba06,abb04,abb05,abb06,abb07,",
           #->FUN-5C0015-------------------------------------------------(S)
           #" abb07f,abb11,abb12,abb13,abb14,abb24,abb25,'',azi04,0",
            " abb07f,abb11,abb12,abb13,abb14,",
            " abb31,abb32,abb33,abb34,abb35,abb36,",
            " abb24,abb25,'',azi04,0",
           #->FUN-5C0015-------------------------------------------------(E)
            " FROM aea_file,aba_file,abb_file,OUTER azi_file",
            " WHERE aea01 = ?  ",
#            "   AND aea00 = '",g_bookno,"' ",   #No.FUN-740055
            "   AND aea00 = '",tm.bookno,"' ",   #No.FUN-740055
            "   AND aba00 = aea00 ",
            "   AND aba00 = abb00 ",
            "   AND aea02 BETWEEN '",bdate,"' AND '",edate,"' ",
            "   AND aba01 = aea03 AND abb01 = aea03 AND abb02 = aea04 ",
            "   AND azi_file.azi01 = abb_file.abb24 ",
            "   ORDER BY 1,2,3"
 
   PREPARE gglr905_prepare1 FROM l_sql
   IF STATUS != 0 THEN
      CALL cl_err('prepare:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF
   DECLARE gglr905_curs1 CURSOR FOR gglr905_prepare1
 
   #No.FUN-780031  --Begin
   #CALL cl_outnam('gglr905') RETURNING l_name
   ##NoTQC-5B0102--begin
   #      IF tm.s = 'Y' THEN
   #      LET g_zaa[42].zaa06 = 'N'
   #      ELSE
   #      LET g_zaa[42].zaa06 = 'Y'
   #      END IF
   #   CALL cl_prt_pos_len()
   ##NoTQC-5B0102--end
   IF tm.s = 'N' THEN 
       LET l_name = 'gglr905'
   ELSE
       LET l_name = 'gglr905_1'
   END IF
   #START REPORT gglr905_rep TO l_name
   #LET g_pageno = 0
   ##No.FUN-780031  --End  
 
   FOREACH gglr905_curs2 INTO sr1.*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
 
      IF tm.x = 'N' AND sr1.aag07 = '3' THEN
         CONTINUE FOREACH
      END IF
 
      #IF g_aza.aza26 = '2' AND NOT cl_null(tm.y) THEN  #TQC-610056
      #   IF sr1.aag07 = '1' AND sr1.aag24 != tm.y THEN   #TQC-610056
   #  IF g_aza.aza26 = '2' THEN  #TQC-610056  #CHI-710005
         #No.FUN-780031  --Begin    先暫時mark,具體處理TQC-780088會加入
         #IF sr1.aag07 = '1' THEN   #TQC-610056
         #   CONTINUE FOREACH
         #END IF
         #No.FUN-780031  --End  
   #  END IF
 
      LET g_cnt = 0
      LET l_flag='N'
 
      FOREACH gglr905_curs1 USING sr1.aag01 INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
 
         LET l_flag='Y'
         LET sr.aag02=sr1.aag02
         #No.FUN-780031  --Begin
         CALL r905_bal(sr.aea01) RETURNING l_bal
         LET l_buf = ''
         IF sr.abb11 IS NOT NULL THEN
            LET l_buf = sr.abb11
         END IF
         IF sr.abb12 IS NOT NULL THEN
            LET l_buf = l_buf CLIPPED," ",sr.abb12
         END IF
         IF sr.abb13 IS NOT NULL THEN
            LET l_buf = l_buf CLIPPED," ",sr.abb13
         END IF
         IF sr.abb14 IS NOT NULL THEN
            LET l_buf = l_buf CLIPPED," ",sr.abb14
         END IF
         IF sr.abb31 IS NOT NULL THEN LET l_buf=l_buf CLIPPED," ",sr.abb31 END IF
         IF sr.abb32 IS NOT NULL THEN LET l_buf=l_buf CLIPPED," ",sr.abb32 END IF
         IF sr.abb33 IS NOT NULL THEN LET l_buf=l_buf CLIPPED," ",sr.abb33 END IF
         IF sr.abb34 IS NOT NULL THEN LET l_buf=l_buf CLIPPED," ",sr.abb34 END IF
         IF sr.abb35 IS NOT NULL THEN LET l_buf=l_buf CLIPPED," ",sr.abb35 END IF
         IF sr.abb36 IS NOT NULL THEN LET l_buf=l_buf CLIPPED," ",sr.abb36 END IF
         LET t_abc04 = ''
         LET l_space = 0
         IF tm.v = 'Y' THEN
            DECLARE abc_curs CURSOR FOR SELECT abc04 FROM abc_file
                                         WHERE abc00 = tm.bookno   #No.FUN-740055
                                           AND abc01 = sr.aea03
                                           AND abc02 = sr.aea04
                                           AND abc04 IS NOT NULL
            FOREACH abc_curs INTO l_abc04
               #LET t_abc04 = t_abc04 CLIPPED,l_space SPACES,l_abc04 CLIPPED
               #LET l_space = 40 - LENGTH(l_abc04)
               IF cl_null(t_abc04) THEN
                  LET t_abc04 = l_abc04 CLIPPED
               ELSE
                  LET t_abc04 = t_abc04 CLIPPED,'',l_abc04 CLIPPED
               END IF
            END FOREACH
         END IF
         SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,l_azi07 FROM azi_file     #FUN-870151 Add azi07
          WHERE azi01 = sr.abb24
         #OUTPUT TO REPORT gglr905_rep(sr.*)
         EXECUTE insert_prep USING sr.aea01,sr.aag02,sr.aea02,sr.aea03,
                                   sr.abb04,sr.abb06,sr.abb07,sr.abb07f,
                                   sr.abb24,sr.abb25,l_buf,t_abc04,l_bal,
                                   t_azi04,t_azi05,l_azi07                       #FUN-870151 Add azi07         
         #No.FUN-780031  --End  
 
      END FOREACH
 
      IF tm.t='Y' AND l_flag='N' THEN
         INITIALIZE sr.* TO NULL
         LET sr.aea01=sr1.aag01
         LET sr.aag02=sr1.aag02
         LET sr.abb07=0
         LET sr.abb07f=0
 
         #No.FUN-780031  --Begin
         CALL r905_bal(sr.aea01) RETURNING l_bal
         #OUTPUT TO REPORT gglr905_rep(sr.*)
         EXECUTE insert_prep USING sr.aea01,sr.aag02,sr.aea02,sr.aea03,
                                   sr.abb04,sr.abb06,sr.abb07,sr.abb07f,
                                   sr.abb24,sr.abb25,'','',l_bal,'0','0','0'     #FUN-870151 Add '0' 
         #No.FUN-780031  --End  
      END IF
 
   END FOREACH
 
   #No.FUN-780031  --Begin
   #FINISH REPORT gglr905_rep
   #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = ''
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'aag01')
           RETURNING g_str
   END IF
   LET g_str = g_str,";",bdate,";",edate,";",tm.u,";",
               g_azi04,";",g_azi05
   CALL cl_prt_cs3('gglr905',l_name,g_sql,g_str)
   #No.FUN-780031  --End  
   #No.FUN-B80096--mark--Begin--- 
   #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
   #No.FUN-B80096--mark--End-----
END FUNCTION
 
#No.FUN-780031  --Begin
#REPORT gglr905_rep(sr)
#DEFINE sr RECORD
#             aea01  LIKE aea_file.aea01,
#             aea02  LIKE aea_file.aea02,
#             aea03  LIKE aea_file.aea03,
#             aea04  LIKE aea_file.aea04,
#             aba05  LIKE aba_file.aba05,
#             aba06  LIKE aba_file.aba06,
#             abb04  LIKE abb_file.abb04,
#             abb05  LIKE abb_file.abb05,
#             abb06  LIKE abb_file.abb06,
#             abb07  LIKE abb_file.abb07,
#             abb07f LIKE abb_file.abb07f,
#             abb11  LIKE abb_file.abb11,
#             abb12  LIKE abb_file.abb12,
#             abb13  LIKE abb_file.abb13,
#             abb14  LIKE abb_file.abb14,
#             abb31  LIKE abb_file.abb31,   #FUN-5C0015-----(S)
#             abb32  LIKE abb_file.abb32,
#             abb33  LIKE abb_file.abb33,
#             abb34  LIKE abb_file.abb34,
#             abb35  LIKE abb_file.abb35,
#             abb36  LIKE abb_file.abb36,   #FUN-5C0015-----(E)
#             abb24  LIKE abb_file.abb24,
#             abb25  LIKE abb_file.abb25,
#             aag02  LIKE aag_file.aag02,
#             azi04  LIKE azi_file.azi04,
#             amt    LIKE abb_file.abb07
#          END RECORD,
#     l_amt,l_c,l_d,l_bal,l_bal0 LIKE aah_file.aah04,
#     l_t_d,l_t_c                LIKE abb_file.abb07,
#     l_last_sw                  LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
#     l_abb07,l_aah04,l_aah05    LIKE abb_file.abb07,
#     l_chr,l_abb06,l_continue   LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
#     l_sql2                     LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(100)
#    #l_buf                      VARCHAR(15),   #FUN-5C0015
#     l_buf                      LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(60)   #FUN-5C0015
#     m                          LIKE type_file.num5,    #NO FUN-690009   SMALLINT
#     l_abc04                    LIKE abc_file.abc04
#DEFINE g_head1                  STRING
#
#   OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
# 
#   FORMAT
#      PAGE HEADER
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
##         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]    #No.TQC-6A0094
#         LET g_pageno = g_pageno + 1
#         LET pageno_total = PAGENO USING '<<<',"/pageno"
##        PRINT g_head CLIPPED,pageno_total      # No.TQC-740305 
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]     #No.TQC-6A0094
#         PRINT g_head CLIPPED,pageno_total      # No.TQC-740305
#         LET g_head1 = g_x[9] CLIPPED,bdate,'-',edate
##         PRINT g_head1                                          #No.TQC-6A0094
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_head1))/2)-1,g_head1   #No.TQC-6A0094
#         PRINT g_dash[1,g_len]
#         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#               g_x[39],g_x[40],g_x[41],g_x[42]          #No.TQC-5B0102
#         PRINT g_dash1
#         LET l_last_sw = 'n'
#
#         IF l_continue = 'Y' THEN
#            PRINT COLUMN g_c[31],g_x[10] CLIPPED,
#                  COLUMN g_c[32],sr.aea01 CLIPPED,
#                  COLUMN g_c[33],sr.aag02[1,15] CLIPPED;      #TQC-5B0102
#            IF l_bal >=0 THEN
#               PRINT COLUMN g_c[38],cl_numfor(l_bal,38,g_azi04),
#                     COLUMN g_c[39],'D'
#            ELSE
#               LET l_amt = l_bal * (-1)
#               PRINT COLUMN g_c[38],cl_numfor(l_amt,38,g_azi04),
#                     COLUMN g_c[39],'C'
#            END IF
#         ELSE
#            PRINT ''
#         END IF
#         LET l_continue = 'N'
# 
#      BEFORE GROUP OF sr.aea01    #科目
#         IF tm.u = 'Y' THEN
#            SKIP TO TOP OF PAGE
#         END IF
#
#         LET l_bal = 0
#         LET l_bal0=0
#         LET l_d=0
#         LET l_c=0
#
#         IF g_aaz.aaz51 = 'Y' THEN  #產生每日餘額檔
#            SELECT sum(aah04-aah05) INTO l_bal0
#              FROM aah_file
#             WHERE aah01 = sr.aea01
#               AND aah02 = yy
#               AND aah03 = 0
##               AND aah00 = g_bookno   #No.FUN-740055
#               AND aah00 = tm.bookno   #No.FUN-740055
#
#            SELECT SUM(aas04-aas05) INTO l_bal
#              FROM aas_file
##             WHERE aas00 = g_bookno   #No.FUN-740055
#             WHERE aas00 = tm.bookno   #No.FUN-740055
#               AND aas01 = sr.aea01
#               AND YEAR(aas02) = yy
#               AND aas02 < bdate
#         ELSE
#            SELECT sum(aah04-aah05) INTO l_bal
#              FROM aah_file
#             WHERE aah01 = sr.aea01
#               AND aah02 = yy
#               AND aah03 < mm
##               AND aah00 = g_bookno   #No.FUN-740055
#               AND aah00 = tm.bookno   #No.FUN-740055
#
#            SELECT sum(abb07) INTO l_d
#              FROM aag_file,abb_file,aba_file
#              WHERE aag08 = sr.aea01
#                AND aag01 = abb03
#                AND aba01 = abb01
#                AND aba02 >= l_begin
#                AND aba02 < bdate
#                AND abb06 = '1'
#                AND abapost = 'Y'
##                AND aba00 = g_bookno   #No.FUN-740055
#                AND aba00 = tm.bookno   #No.FUN-740055
#
#            IF l_d IS NULL THEN
#               LET l_d = 0
#            END IF
#
#            SELECT sum(abb07) INTO l_c
#              FROM aag_file,aba_file,abb_file
#             WHERE aag08 = sr.aea01
#               AND aag01 = abb03
#               AND aba01 = abb01
#               AND aba02 >= l_begin
#               AND aba02 <  bdate
#               AND abb06 = '2'
#               AND abapost='Y'
##               AND aba00=g_bookno   #No.FUN-740055
#               AND aba00=tm.bookno   #No.FUN-740055
#
#            IF l_c IS NULL THEN
#               LET l_c = 0
#            END IF
#         END IF
#
#         IF l_bal IS NULL THEN
#            LET l_bal = 0
#         END IF
#
#         IF l_bal0 IS NULL THEN
#            LET l_bal0 = 0
#         END IF
#
#         LET l_t_d =0
#         LET l_t_c =0
#         LET l_bal = l_bal + l_d - l_c +l_bal0  # 期初餘額
#         IF l_bal >= 0 THEN
#            PRINT COLUMN g_c[31],g_x[10] CLIPPED,
#                  COLUMN g_c[32],sr.aea01 CLIPPED,
#                  COLUMN g_c[33],sr.aag02[1,15] CLIPPED,      #TQC-5B0102
#                  COLUMN g_c[34],l_chr CLIPPED,
#                  COLUMN g_c[38],cl_numfor(l_bal,38,g_azi04),
#                  COLUMN g_c[39],'D'
#         ELSE
#            LET l_bal =l_bal * (-1)
#            PRINT COLUMN g_c[31],g_x[10] CLIPPED,
#                  COLUMN g_c[32],sr.aea01 CLIPPED,
#                  COLUMN g_c[33],sr.aag02[1,15] CLIPPED,      #TQC-5B0102
#                  COLUMN g_c[38],cl_numfor(l_bal,38,g_azi04),
#                  COLUMN g_c[39],'C'
#            LET l_bal =l_bal * (-1)
#         END IF
#         PRINT ' '
# 
#      ON EVERY ROW
#
#         LET l_buf = ''
#
#         IF sr.abb11 IS NOT NULL THEN
#            LET l_buf = sr.abb11
#         END IF
# 
#         IF sr.abb12 IS NOT NULL THEN
#            LET l_buf = l_buf CLIPPED," ",sr.abb12
#         END IF
#
#         IF sr.abb13 IS NOT NULL THEN
#            LET l_buf = l_buf CLIPPED," ",sr.abb13
#         END IF
#
#         IF sr.abb14 IS NOT NULL THEN
#            LET l_buf = l_buf CLIPPED," ",sr.abb14
#         END IF
#
#        #FUN-5C0015----------------------------------------------------------(S)
#         IF sr.abb31 IS NOT NULL THEN LET l_buf=l_buf CLIPPED," ",sr.abb31 END IF
#         IF sr.abb32 IS NOT NULL THEN LET l_buf=l_buf CLIPPED," ",sr.abb32 END IF
#         IF sr.abb33 IS NOT NULL THEN LET l_buf=l_buf CLIPPED," ",sr.abb33 END IF
#         IF sr.abb34 IS NOT NULL THEN LET l_buf=l_buf CLIPPED," ",sr.abb34 END IF
#         IF sr.abb35 IS NOT NULL THEN LET l_buf=l_buf CLIPPED," ",sr.abb35 END IF
#         IF sr.abb36 IS NOT NULL THEN LET l_buf=l_buf CLIPPED," ",sr.abb36 END IF
#        #FUN-5C0015----------------------------------------------------------(E)
#
#         IF sr.abb07 != 0 THEN
#            LET l_continue = 'Y'
##TQC-5B0102--start
#            PRINT COLUMN g_c[31],sr.aea02,
#                  COLUMN g_c[32],sr.aea03,
#                  COLUMN g_c[33],l_buf;
#            PRINT COLUMN g_c[34],sr.abb24,
#                  COLUMN g_c[35],sr.abb25 USING '##&.&&&&';
#            IF sr.abb06 = '1' THEN
#               PRINT COLUMN g_c[40],cl_numfor(sr.abb07f,36,sr.azi04);
#            ELSE
#               PRINT COLUMN g_c[41],cl_numfor(sr.abb07f,37,sr.azi04);
#            END IF
##TQC-5B0102--end
#
#            IF sr.abb06 = '1' THEN
#               PRINT COLUMN g_c[36],cl_numfor(sr.abb07,36,g_azi04);
#               LET l_bal = l_bal + sr.abb07
#               LET l_t_d = l_t_d + sr.abb07
#               LET l_bal = l_bal - sr.abb07
#               LET l_t_c = l_t_c + sr.abb07
#            END IF
#
#            IF l_bal >=0 THEN
#               PRINT COLUMN g_c[38],cl_numfor(l_bal,38,g_azi04),
#                     COLUMN g_c[39],'D'
#            ELSE
#               LET l_bal = l_bal * (-1)
#               PRINT COLUMN g_c[38],cl_numfor(l_bal,38,g_azi04),
#                     COLUMN g_c[39],'C'
#               LET l_bal = l_bal * (-1)
#            END IF
##TQC-5B0102--start
##           IF tm.s ='Y' THEN
#               PRINT COLUMN g_c[42],sr.abb04;
##           END IF
# 
##           PRINT COLUMN g_c[32],sr.abb24,
##                 COLUMN g_c[33],sr.abb25 USING '##&.&&&&';
# 
##           IF sr.abb06 = '1' THEN
##              PRINT COLUMN g_c[36],cl_numfor(sr.abb07f,36,sr.azi04)
##           ELSE
##              PRINT COLUMN g_c[37],cl_numfor(sr.abb07f,37,sr.azi04)
##           END IF
##TQC-5B0102--end
#
#            IF tm.v = 'Y' THEN
#               DECLARE abc_curs CURSOR FOR SELECT abc04 FROM abc_file
##                                            WHERE abc00 = g_bookno   #No.FUN-740055
#                                            WHERE abc00 = tm.bookno   #No.FUN-740055
#                                              AND abc01 = sr.aea03
#                                              AND abc02 = sr.aea04
#               FOREACH abc_curs INTO l_abc04
#                  IF l_abc04 IS NOT NULL THEN
#                     PRINT COLUMN g_c[32],l_abc04
#                  END IF
#               END FOREACH
#            END IF
#            LET l_continue = 'N'
#         END IF
# 
#      AFTER GROUP OF sr.aea01
#    #    LET g_pageno = 0
#         PRINT '  '
#         PRINT COLUMN g_c[33],g_x[11] CLIPPED,
#               COLUMN g_c[36],cl_numfor(l_t_d,36,g_azi04),
#               COLUMN g_c[37],cl_numfor(l_t_c,37,g_azi04)
#
#         IF tm.u ='N' THEN
#            PRINT g_dash2
#         END IF
# 
#      ON LAST ROW
#         IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#            CALL cl_wcchp(tm.wc,'aag01') RETURNING tm.wc
#            PRINT g_dash[1,g_len]
#	#TQC-630166
#        #    IF tm.wc[001,070] > ' ' THEN                  # for 80
#        #       PRINT COLUMN g_c[31],g_x[8] CLIPPED,
#        #             COLUMN g_c[32],tm.wc[001,070] CLIPPED
#        #    END IF
#        #    IF tm.wc[071,140] > ' ' THEN
#        #       PRINT COLUMN g_c[32],tm.wc[071,140] CLIPPED
#        #    END IF
#        #    IF tm.wc[141,210] > ' ' THEN
#        #       PRINT COLUMN g_c[32],tm.wc[141,210] CLIPPED
#        #    END IF
#        #    IF tm.wc[211,280] > ' ' THEN
#        #       PRINT COLUMN g_c[32],tm.wc[211,280] CLIPPED
#        #    END IF
#	CALL cl_prt_pos_wc(tm.wc)
#        #END TQC-630166
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
#No.FUN-780031  --End  
#Patch....NO.TQC-610037 <001> #
 
#No.FUN-780031  --Begin
FUNCTION r905_bal(p_aea01)
  DEFINE p_aea01  LIKE aea_file.aea01
  DEFINE l_amt,l_c,l_d,l_bal,l_bal0 LIKE aah_file.aah04
  DEFINE l_t_d,l_t_c                LIKE abb_file.abb07
 
    LET l_bal = 0
    LET l_bal0=0
    LET l_d=0
    LET l_c=0
    IF g_aaz.aaz51 = 'Y' THEN  #產生每日餘額檔
       SELECT sum(aah04-aah05) INTO l_bal0
         FROM aah_file
        WHERE aah01 = p_aea01
          AND aah02 = yy
          AND aah03 = 0
          AND aah00 = tm.bookno
 
       SELECT SUM(aas04-aas05) INTO l_bal
         FROM aas_file
        WHERE aas00 = tm.bookno
          AND aas01 = p_aea01
          AND YEAR(aas02) = yy
          AND aas02 < bdate
    ELSE
       SELECT sum(aah04-aah05) INTO l_bal
         FROM aah_file
        WHERE aah01 = p_aea01
          AND aah02 = yy
          AND aah03 < mm
          AND aah00 = tm.bookno   #No.FUN-740055
 
       SELECT sum(abb07) INTO l_d
         FROM aag_file,abb_file,aba_file
         WHERE aag08 = p_aea01
           AND aag01 = abb03
           AND aba01 = abb01
           AND aba02 >= l_begin
           AND aba02 < bdate
           AND abb06 = '1'
           AND abapost = 'Y'
           AND aba00 = tm.bookno   #No.FUN-740055
 
       IF l_d IS NULL THEN
          LET l_d = 0
       END IF
 
       SELECT sum(abb07) INTO l_c
         FROM aag_file,aba_file,abb_file
        WHERE aag08 = p_aea01
          AND aag01 = abb03
          AND aba01 = abb01
          AND aba02 >= l_begin
          AND aba02 <  bdate
          AND abb06 = '2'
          AND abapost='Y'
          AND aba00=tm.bookno   #No.FUN-740055
 
       IF l_c IS NULL THEN
          LET l_c = 0
       END IF
    END IF
 
    IF l_bal IS NULL THEN
       LET l_bal = 0
    END IF
 
    IF l_bal0 IS NULL THEN
       LET l_bal0 = 0
    END IF
 
    LET l_bal = l_bal + l_d - l_c +l_bal0  # 期初餘額
    RETURN l_bal
END FUNCTION
#No.FUN-780031  --End  
