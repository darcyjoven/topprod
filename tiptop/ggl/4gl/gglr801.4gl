# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: gglr801.4gl
# Descriptions...: 異動明細表
# Input parameter:
# Return code....:
# Date & Author..: 92/03/13 By DAVID WANG
# Modify.........: No.7911 03/10/23 By Sophia依幣別取位及報表格式調整
# Modify.........: No.FUN-510007 05/01/18 By Nicola 報表架構修改
# Modify.........: No.MOD-580211 05/09/08 By ice  修改報表列印格式
# Modify.........: No: FUN-5C0015 06/01/05 By kevin
#                  畫面QBE加aec052異動碼類型代號，^p q_ahe。
#                  (p_zaa)序號31放寬至30
# Modify.........: No.TQC-630166 06/03/16 By 整批修改，將g_wc[1,70]改為g_wc.subString(1,......)寫法
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-690009 06/09/06 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.CHI-6A0004 06/10/23 By atsea g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.TQC-6A0094 06/11/10 By johnray 報表修改
# Modify.........: No.FUN-740055 07/04/11 By atsea  會計科目加帳套
# Modify.........: No.FUN-850008 08/05/05 By lutingting報表轉為使用CR
# Modify.........: No.MOD-860252 08/07/02 By chenl  增加打印時是否打印貨幣性科目或全部科目的選擇。
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B20054 10/02/22 By yangtingting 先錄入帳套,科目根據帳套過濾;結構改為DIALOG
# Modify.........: No.TQC-B30147 11/03/18 By yinhy 查詢條件為空，跳到科目編號欄位
# Modify.........: No:FUN-B80096 11/08/10 By Lujh 模組程序撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
             #wc        VARCHAR(1000),
	      wc	STRING,			#TQC-630166
              aec00     LIKE aec_file.aec00,     #No.FUN-740055
              t         LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
              h         LIKE type_file.chr1,    #MOD-860252
              u         LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
              more      LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)
           END RECORD,
       l_sub_bal,l_tot_bal     LIKE abb_file.abb07,
       s_sub_bal               LIKE abb_file.abb07,
       l_s_d,l_s_c,l_t_d,l_t_c LIKE abb_file.abb07,
       g_bookno LIKE aaa_file.aaa01
DEFINE   g_aaa03         LIKE aaa_file.aaa03
DEFINE   g_i             LIKE type_file.num5     #NO FUN-690009   SMALLINT   #count/index for any purpose
DEFINE   g_str           STRING                  #No.FUN-850008
DEFINE   g_sql           STRING                  #No.FUN-850008
DEFINE   l_table         STRING                  #No.FUN-850008
 
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
 
   #No.FUN-850008--------start--
   LET g_sql = "aec01.aec_file.aec01,", 
               "l_aag02.aag_file.aag02,",
               "aec05.aec_file.aec05,",
               "aec02.aec_file.aec02,",
               "aec03.aec_file.aec03,", 
               "abb07.abb_file.abb07,", 
               "abb24.abb_file.abb24,", 
               "abb25.abb_file.abb25,", 
               "abb07f.abb_file.abb07f,",
               "l_chr.type_file.chr1,", 
               "abb06.abb_file.abb06,", 
               "l_sub_bal.abb_file.abb07,",
               "l_s_d.abb_file.abb07,", 
               "l_s_c.abb_file.abb07,", 
               "l_t_d.abb_file.abb07,", 
               "l_t_c.abb_file.abb07,", 
               "s_sub_bal.abb_file.abb07,",
               "aec051.aec_file.aec051,", 
               "azi04.azi_file.azi04" 
   LET l_table = cl_prt_temptable('gglr801',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES (?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-850008---end
   
#   LET g_bookno=ARG_VAL(1)       #No.FUN-740055
   LET tm.aec00 =ARG_VAL(1)       #No.FUN-740055
   LET g_pdate = ARG_VAL(2)            # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   #No.FUN-570264 ---end---
#No.FUN-740055--begin--
   IF g_bookno IS NULL OR g_bookno = ' ' THEN
      LET g_bookno = g_aaz.aaz64
   END IF
   IF tm.aec00 IS NULL OR tm.aec00 = ' ' THEN
      LET tm.aec00 = g_aza.aza81
   END IF
#No.FUN-740055--end--

   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80096   ADD
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL gglr801_tm(0,0)
   ELSE
      CALL gglr801()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
END MAIN
 
FUNCTION gglr801_tm(p_row,p_col)
DEFINE lc_qbe_sn           LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col      LIKE type_file.num5,    #NO FUN-690009   SMALLINT
       l_cmd            LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(400)
DEFINE li_chk_bookno LIKE type_file.num5   #FUN-B20054   
 
   CALL s_dsmark(tm.aec00)
   LET p_row = 3 LET p_col = 20
   OPEN WINDOW gglr801_w AT p_row,p_col
     WITH FORM "ggl/42f/gglr801"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
# Prog. Version..: '5.30.06-13.03.12(0,0,g_bookno)          #No.FUN-740055   
   CALL s_shwact(0,0,tm.aec00)          #No.FUN-740055   
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  # Default condition
   LET tm.t    = 'Y'
   LET tm.u    = '1'
   LET tm.more = 'N'
   LET tm.h    = 'Y'        #MOD-860252
   LET tm.aec00= g_aza.aza81           #FUN-B20054
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
#No.FUN-740055--begin--
   IF tm.aec00 IS NULL OR tm.aec00 = ' ' THEN
      LET tm.aec00 = g_aza.aza81
   END IF
#No.FUN-740055--end--
   WHILE TRUE
   #FUN-B20054--add--str--
    DIALOG ATTRIBUTE(unbuffered)
       INPUT BY NAME tm.aec00 ATTRIBUTE(WITHOUT DEFAULTS)
          AFTER FIELD aec00
            IF NOT cl_null(tm.aec00) THEN
                   CALL s_check_bookno(tm.aec00,g_user,g_plant)
                    RETURNING li_chk_bookno
                IF (NOT li_chk_bookno) THEN
                    NEXT FIELD aec00
                END IF
                SELECT aaa02 FROM aaa_file WHERE aaa01 = tm.aec00
                IF STATUS THEN
                   CALL cl_err3("sel","aaa_file",tm.aec00,"","agl-043","","",0)
                   NEXT FIELD aec00
                END IF
            END IF
       END INPUT
     #FUN-B20054--add--end
     #FUN-B20054--mark--str--
      #LET l_sub_bal = 0
      #LET l_s_d     = 0
      #LET l_s_c     = 0
      #LET l_t_d     = 0
      #LET l_t_c     = 0
      #FUN-B20054--mark--end--
      #FUN-5C0015 mod (s)
      #CONSTRUCT BY NAME tm.wc ON aec01,aec051,aec05,aec02
       CONSTRUCT BY NAME tm.wc ON aec01,aec051,aec052,aec05,aec02
      #FUN-5C0015 mod (e)
 
         # FUN-5C0015 (s)
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
         #FUN-B20054--mark--str--
         #ON ACTION controlp
         #   CASE
         #     WHEN INFIELD(aec052) #異動碼類型代號
         #       CALL cl_init_qry_var()
         #       LET g_qryparam.form     = "q_ahe"
         #       LET g_qryparam.state    = "c"
         #       CALL cl_create_qry() RETURNING g_qryparam.multiret
         #       DISPLAY g_qryparam.multiret TO aec052
         #       NEXT FIELD aec052
         #     OTHERWISE EXIT CASE
         #   END CASE
         #FUN-B20054--mark--end--
         # FUN-5C0015 (e)
      
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
         #FUN-B20054--mark--end--
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
      #   CLOSE WINDOW gglr801_w
      #   EXIT PROGRAM
      #END IF 
      # 
      #IF tm.wc = ' 1=1' THEN
      #   CALL cl_err('','9046',0)
      #   CONTINUE WHILE
      #END IF
      #FUN-B20054--mark--end--
 
      #DISPLAY BY NAME tm.aec00,tm.t,tm.h,tm.u,tm.more  #No.MOD-860252 add tm.h  #FUN-B20054
 
      INPUT BY NAME tm.t,tm.h,tm.u,tm.more #WITHOUT DEFAULTS  #No.MOD-860252 add tm.h  #FUN-B20054 del aec00
                ATTRIBUTE(WITHOUT DEFAULTS)  #FUN-B20054
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---   
      #FUN-B20054--mark--str--
      #AFTER FIELD aec00      
      #    IF cl_null(tm.aec00) THEN NEXT FIELD aec00 END IF
      #   AFTER FIELD t
      #      IF tm.t NOT MATCHES "[YN]" THEN
      #         NEXT FIELD t
      #      END IF
      #FUN-B20054--mark--str--
 
         AFTER FIELD u
            IF tm.u NOT MATCHES "[12]" THEN
               NEXT FIELD u
            END IF
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
#NO.FUN-740055   --Begin
         #FUN-B20054--mark--str--
         #ON ACTION CONTROLP
         #   CASE
         #    WHEN INFIELD(aec00) 
         #      CALL cl_init_qry_var()
         #      LET g_qryparam.form = 'q_aaa'
         #      LET g_qryparam.default1 = tm.aec00
         #      CALL cl_create_qry() RETURNING tm.aec00
	       #DISPLAY BY NAME tm.aec00
	       #NEXT FIELD aec00
         #END CASE
         #FUN-B20054--mark--end--
#NO.FUN-740055   ---End
         #FUN-B20054--mark--str--
         #ON ACTION CONTROLR
         #   CALL cl_show_req_fields()
         #
         #ON ACTION CONTROLG
         #   CALL cl_cmdask()
         #
         #ON IDLE g_idle_seconds
         #   CALL cl_on_idle()
         #   CONTINUE INPUT
         #
         # ON ACTION about         #MOD-4C0121
         #    CALL cl_about()      #MOD-4C0121
         #
         # ON ACTION help          #MOD-4C0121
         #    CALL cl_show_help()  #MOD-4C0121
         #
         #ON ACTION exit
         #   LET INT_FLAG = 1
         #   EXIT INPUT  
         #FUN-B20054--mark--end--
 
         #No.FUN-580031 --start--
         #FUN-B20054--mark--str--
         #ON ACTION qbe_save
         #   CALL cl_qbe_save()
         #FUN-B20054--mark--end--
         #No.FUN-580031 ---end---
 
      END INPUT
      #FUN-B20054--add--str--
      ON ACTION CONTROLP
          CASE
             WHEN INFIELD(aec00)
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_aaa'
                LET g_qryparam.default1 = tm.aec00
                CALL cl_create_qry() RETURNING tm.aec00
                DISPLAY tm.aec00 TO FORMONLY.aec00
                NEXT FIELD aec00
             WHEN INFIELD(aec01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag"
                LET g_qryparam.state = "c"
                LET g_qryparam.where = " aag00 = '",tm.aec00 CLIPPED,"'"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO aec01
                NEXT FIELD aec01
             WHEN INFIELD(aec052)
                CALL cl_init_qry_var()                            
                LET g_qryparam.form     = "q_ahe"                 
                LET g_qryparam.state    = "c"                     
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO aec052             
                NEXT FIELD aec052                                 
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
           NEXT FIELD aec01
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
    #FUN-B20054--add--end--
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW gglr801_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file      #get exec cmd (fglgo xxxx)
          WHERE zz01='gglr801'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('gglr801','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,            #(at time fglgo xxxx p1 p2 p3)
#                        " '",g_bookno CLIPPED,"'",    #No.FUN-740055
                        " '",tm.aec00 CLIPPED,"'",    #No.FUN-740055
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_lang CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.t CLIPPED,"'",   #TQC-610056
                        " '",tm.u CLIPPED,"'",   #TQC-610056
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('gglr801',g_time,l_cmd)      # Execute cmd at later time
         END IF
 
         CLOSE WINDOW gglr801_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL gglr801()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW gglr801_w
 
END FUNCTION
 
FUNCTION gglr801()
   DEFINE l_name      LIKE type_file.chr20,   #NO FUN-690009   VARCHAR(20)    # External(Disk) file name
#       l_time          LIKE type_file.chr8          #No.FUN-6A0097
          l_sql       LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(1000)  # RDSQL STATEMENT
          l_chr       LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
          l_order     ARRAY[5] OF LIKE cre_file.cre08,   #NO FUN-690009   VARCHAR(10)
          sr          RECORD
                         aec01   LIKE aec_file.aec01,
                         aec02   LIKE aec_file.aec02,
                         aec03   LIKE aec_file.aec03,
                         aec051  LIKE aec_file.aec051,
                         aec05   LIKE aec_file.aec05,
                         abb06   LIKE abb_file.abb06,
                         abb07   LIKE abb_file.abb07,
                         abb07f  LIKE abb_file.abb07f,
                         abb24   LIKE abb_file.abb24,
                         abb25   LIKE abb_file.abb25,
                         azi04   LIKE azi_file.azi04
                      END RECORD
 
   DEFINE     l_aag02       LIKE aag_file.aag02    #No.FUN-850008
 
   #No.FUN-B80096--mark--Begin---  
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
   #No.FUN-B80096--mark--End-----
   CALL cl_del_data(l_table)     #No.FUN-850008
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'gglr801'  #No.FUN-850008     
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 =tm.aec00   #No.FUN-740055 
      AND aaf02 = g_rlang
 
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.aec00       #No.FUN-740055
 
   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_aaa03        #No.CHI-6A0004
 
   #====>資料權限的檢查
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
 
 
   LET l_sql = "SELECT aec01,aec02,aec03,aec051,aec05,abb06,abb07,abb07f,",
               "       abb24,abb25,azi04 ",
               "  FROM aec_file,abb_file,azi_file,aag_file " ,
               " WHERE aec00 = '",tm.aec00,"'",    #No.FUN-740055
               "   AND aec00 = abb00 AND aec01 = abb03 ",
               "   AND abb01 = aec03 AND abb02 = aec04 ",
               "   AND azi01 = abb24  "
 
   IF tm.u ='1' THEN
      LET l_sql =l_sql CLIPPED," AND aag01 =aec01 AND aag07 IN ('1','3') "
   ELSE
      LET l_sql =l_sql CLIPPED," AND aag01 =aec01 AND aag07 ='2' "
   END IF
 
   #No.MOD-860252--begin--
   IF tm.h = 'Y' THEN 
      LET l_sql = l_sql CLIPPED," AND aag09 = 'Y' " 
   END IF
   #No.MOD-860252---end---
   LET l_sql =l_sql CLIPPED, " AND ",tm.wc
 
   LET l_sql = l_sql CLIPPED," ORDER BY aec01,aec05,aec02,aec03 "   #NO:2761
 
   PREPARE gglr801_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF
   DECLARE gglr801_curs1 CURSOR FOR gglr801_prepare1
 
   #CALL cl_outnam('gglr801') RETURNING l_name   #No.FUN-850008
   #START REPORT gglr801_rep TO l_name             #No.FUN-850008
 
   LET g_pageno = 0
   #No.FUN-850008---start--
   LET s_sub_bal = 0    
   LET l_sub_bal=0
   LET l_s_d=0    
   LET l_s_c=0    
   LET l_t_d=0 
   LET l_t_c=0 
   #No.FUN-850008--end
   FOREACH gglr801_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #No.FUN-850008------start--
      SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01 = sr.aec01
      LET l_chr ='0'
      IF l_chr = '0' THEN
         LET l_chr ='1' 
      END IF
      IF sr.abb06 = '1' THEN
         LET l_sub_bal = l_sub_bal + sr.abb07 
         LET l_s_d = l_s_d + sr.abb07
         LET l_t_d = l_t_d + sr.abb07
      ELSE
         LET l_sub_bal = l_sub_bal - sr.abb07 
         LET l_s_c = l_s_c + sr.abb07
         LET l_t_c = l_t_c + sr.abb07
      END IF
      LET s_sub_bal = s_sub_bal + l_sub_bal
      EXECUTE insert_prep USING
         sr.aec01,l_aag02,sr.aec05,sr.aec02,sr.aec03,sr.abb07,sr.abb24,sr.abb25,
         sr.abb07f,l_chr,sr.abb06,l_sub_bal,l_s_d,l_s_c,l_t_d,l_t_c,s_sub_bal,
         sr.aec051,sr.azi04                              
      LET s_sub_bal = 0
      #OUTPUT TO REPORT gglr801_rep(sr.*)
      #No.FUN-850008---end
   END FOREACH
   
   #No.FUN-850008-----start--
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'aec01,aec051,aec052,aec05,aec02')
      RETURNING tm.wc
   END IF
   
   LET g_str = tm.wc,";",tm.t
   
   CALL cl_prt_cs3('gglr801','gglr801',g_sql,g_str)
   #FINISH REPORT gglr801_rep
 
   #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   #NO.FUN-850008---end
    #No.FUN-B80096--mark--Begin--- 
    #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
    #No.FUN-B80096--mark--End-----
END FUNCTION
 
#No.FUN-850008-----start--
#REPORT gglr801_rep(sr)
#DEFINE l_last_sw     LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
#       sr            RECORD
#                        aec01   LIKE aec_file.aec01,
#                        aec02   LIKE aec_file.aec02,
#                        aec03   LIKE aec_file.aec03,
#                        aec051  LIKE aec_file.aec051,
#                        aec05   LIKE aec_file.aec05,
#                        abb06   LIKE abb_file.abb06,
#                        abb07   LIKE abb_file.abb07,
#                        abb07f  LIKE abb_file.abb07f,
#                        abb24   LIKE abb_file.abb24,
#                        abb25   LIKE abb_file.abb25,
#                        azi04   LIKE azi_file.azi04
#                     END RECORD,
#       l_aag02       LIKE aag_file.aag02,
#       l_chr         LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)
#
#   OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
#
#   ORDER BY sr.aec01,sr.aec051,sr.aec05,sr.aec02
#
#   FORMAT
#      PAGE HEADER
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
##         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]   #No.TQC-6A0094
#         LET g_pageno = g_pageno + 1
#         LET pageno_total = PAGENO USING '<<<',"/pageno"
#         PRINT g_head CLIPPED,pageno_total
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]   #No.TQC-6A0094
#         PRINT
#         PRINT g_dash[1,g_len]
#         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
#         PRINT g_dash1
#         LET l_last_sw = 'n'
# 
#      BEFORE GROUP OF sr.aec01
#         IF tm.t='Y' THEN
#            SKIP TO TOP OF PAGE
#         END IF
#
#         SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01 = sr.aec01
#
#         PRINT COLUMN g_c[31],g_x[9] CLIPPED,
#               COLUMN g_c[32],sr.aec01,
#               COLUMN g_c[33],l_aag02
#
#         PRINT ' '
#         LET s_sub_bal = 0
# 
#      BEFORE GROUP OF sr.aec05
#         LET l_chr ='0'
# 
#      ON EVERY ROW
#         IF l_chr = '0' THEN
#            LET l_chr ='1'
#            PRINT COLUMN g_c[31],sr.aec05 CLIPPED,
#                  COLUMN g_c[32],sr.aec02,
#                  COLUMN g_c[33],sr.aec03;
#         ELSE
#            PRINT COLUMN g_c[32],sr.aec02,
#                  COLUMN g_c[33],sr.aec03;
#         END IF
#
#         IF sr.abb06 = '1' THEN
#            LET l_sub_bal = l_sub_bal + sr.abb07
#            PRINT COLUMN g_c[34],cl_numfor(sr.abb07,34,sr.azi04);
#            LET l_s_d = l_s_d + sr.abb07
#            LET l_t_d = l_t_d + sr.abb07
#         ELSE
#            LET l_sub_bal = l_sub_bal - sr.abb07
#            PRINT COLUMN g_c[35],cl_numfor(sr.abb07,35,sr.azi04);
#            LET l_s_c = l_s_c + sr.abb07
#            LET l_t_c = l_t_c + sr.abb07
#         END IF
#
#         IF l_sub_bal >= 0 THEN
#            PRINT COLUMN g_c[36],cl_numfor(l_sub_bal,36,sr.azi04),
#                  COLUMN g_c[37],'D'
#         ELSE
#            LET l_sub_bal = l_sub_bal *(-1)
#            PRINT COLUMN g_c[36],cl_numfor(l_sub_bal,36,sr.azi04),
#                  COLUMN g_c[37],'C'
#            LET l_sub_bal = l_sub_bal *(-1)
#         END IF
#
#         PRINT COLUMN g_c[32],sr.abb24,
#               COLUMN g_c[33],sr.abb25 USING '##&.&&';
#         IF sr.abb06 = '1' THEN
#            PRINT COLUMN g_c[34],cl_numfor(sr.abb07f,34,sr.azi04)
#         ELSE
#            PRINT COLUMN g_c[35],cl_numfor(sr.abb07f,35,sr.azi04)
#         END IF
# 
#      AFTER GROUP OF sr.aec05
#         PRINT '  '
#         PRINT COLUMN g_c[33],g_x[10] CLIPPED,
#               COLUMN g_c[34],cl_numfor(l_s_d,34,sr.azi04),
#               COLUMN g_c[35],cl_numfor(l_s_c,35,sr.azi04)
#         PRINT '  '
#         LET s_sub_bal = s_sub_bal + l_sub_bal
#         LET l_sub_bal=0
#         LET l_s_d=0
#         LET l_s_c=0
# 
#      AFTER GROUP OF sr.aec01
#         PRINT '  '
#         PRINT COLUMN g_c[33],g_x[11] CLIPPED,
#               COLUMN g_c[34],cl_numfor(l_t_d,34,sr.azi04),
#               COLUMN g_c[35],cl_numfor(l_t_c,35,sr.azi04);
#
#         IF s_sub_bal >=0 THEN
#            PRINT COLUMN g_c[36],cl_numfor(s_sub_bal,36,sr.azi04),
#                  COLUMN g_c[37],'D'
#         ELSE
#            LET s_sub_bal=s_sub_bal*(-1)
#            PRINT COLUMN g_c[36],cl_numfor(s_sub_bal,36,sr.azi04),
#                  COLUMN g_c[37],'C'
#            LET s_sub_bal=s_sub_bal*(-1)
#         END IF
#
#         PRINT '  '
#         LET l_t_d=0
#         LET l_t_c=0
#         LET s_sub_bal=0
# 
#      ON LAST ROW
#         IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#            CALL cl_wcchp(tm.wc,'aec01,aec02,aec03,aec051,aec05') RETURNING tm.wc
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
#No.FUN-850008-----end
