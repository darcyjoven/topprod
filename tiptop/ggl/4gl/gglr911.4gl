# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: gglr911.4gl
# Descriptions...: 傳票明細表
# Modify.........: No.7911 03/10/23 By Sophia依幣別取位及報表格式調整
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬aag02
# Modify.........: No.FUN-510007 05/02/16 By Nicola 報表架構修改
# Modify.........: No.TQC-630166 06/03/16 By 整批修改，將g_wc[1,70]改為g_wc.subString(1,......)寫法
# Modify.........: No.FUN-660124 06/06/21 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-690009 06/09/06 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.CHI-6A0004 06/10/23 By atsea g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.FUN-6C0012 06/12/30 By Judy 報表加入打印額外名稱
# Modify.........: No.FUN-740055 07/04/12 By johnray 會計科目加帳套
# Modify.........: No.TQC-740305 07/04/30 By Lynn 制表日期位置在報表名之上
# Modify.........: No.FUN-870151 08/08/13 By xiaofeizhu 報表中匯率欄位小數位數沒有依 aooi050 做取位
# Modify.........: No.FUN-850005 08/05/05 By Sunyanchun 老報表轉CR
#                                08/09/26 By Cockroach 21-->31 CR
# Modify.........: No.MOD-860252 08/07/02 By chenl  增加打印時是否打印貨幣性科目或全部科目的選擇。
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B80096 11/08/10 By Lujh 模組程序撰寫規範修正
# Modify.........: No.CHI-C80041 12/12/25 By bart 排除作廢
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
                #wc  VARCHAR(1000),             #Where Condiction
		 wc  STRING,
                 s   LIKE type_file.chr3,      #NO FUN-690009   VARCHAR(3)  #排列順序
                 t   LIKE type_file.chr3,      #NO FUN-690009   VARCHAR(3)  #排列順序
                 u   LIKE type_file.chr3,      #NO FUN-690009   VARCHAR(3)  #排列順序
                 d   LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)  #過帳別 (1)未過帳(2)已過帳(3)全部
                 e   LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)  #是否列印摘要
                 f   LIKE type_file.chr1,    #FUN-6C0012
                 h   LIKE type_file.chr1,    #MOD-860252
                 m   LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)  #是否輸入其它特殊列印條件
              END RECORD,
          g_bookno  LIKE aba_file.aba00,#帳別編號
          g_orderA  ARRAY[3] OF  LIKE zaa_file.zaa08    #NO FUN-690009   VARCHAR(10)  #排序名稱
   DEFINE g_aaa03   LIKE aaa_file.aaa03
   DEFINE g_msg     LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(72)
   DEFINE g_sql     STRING        #No.FUN-850005      
   DEFINE l_table   STRING        #No.FUN-850005
   DEFINE g_str     STRING        #NO.FUN-850005
 
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
 
   #NO,FUN-850005----BEGIN----
   LET g_sql = "order1.abb_file.abb11,",
               "order2.abb_file.abb11,",
               "order3.abb_file.abb11,",
               "aba01.aba_file.aba01,",
               "abb03.abb_file.abb03,",
               "abb05.abb_file.abb05,",
               "abb24.abb_file.abb24,",
               "amt_df.abb_file.abb07,",
               "amt_cf.abb_file.abb07,",
               "abb11.abb_file.abb11,",
               "abb04.abb_file.abb04,",
               "aba02.aba_file.aba02,",
               "aag02.aag_file.aag02,",
               "aag13.aag_file.aag13,",
               "gem02.gem_file.gem02,",
               "abb25.abb_file.abb25,",
               "amt_d.abb_file.abb07,",
               "amt_c.abb_file.abb07,",
               "abb12.abb_file.abb12,",
               "azi04.azi_file.azi04,",
               "azi07.azi_file.azi07"
   LET l_table = cl_prt_temptable('gglr911',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep3:',status,1)                                                                                        
      EXIT PROGRAM                                                                                                                 
   END IF
   #NO.FUN-850005----END------
 
   LET g_bookno = ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)            # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc  = ARG_VAL(8)
   LET tm.s  = ARG_VAL(9)
   LET tm.t  = ARG_VAL(10)
   LET tm.u  = ARG_VAL(11)
   LET tm.d  = ARG_VAL(12)
   LET tm.e  = ARG_VAL(13)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   #No.FUN-570264 ---end---
 
   IF g_bookno = ' ' OR g_bookno IS NULL THEN
      LET g_bookno = g_aaz.aaz64   #帳別若為空白則使用預設帳別
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80096   ADD 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL gglr911_tm()
   ELSE
      CALL gglr911()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
END MAIN
 
FUNCTION gglr911_tm()
DEFINE lc_qbe_sn           LIKE gbm_file.gbm01     #No.FUN-580031
   DEFINE p_row,p_col      LIKE type_file.num5,    #NO FUN-690009   SMALLINT
          l_cmd            LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(400)
 
   CALL s_dsmark(g_bookno)
   LET p_row = 2 LET p_col = 20
   OPEN WINDOW gglr911_w AT p_row,p_col
     WITH FORM "ggl/42f/gglr911"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL s_shwact(3,2,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  # Default condition
   LET tm.s = '17'
   LET tm.u = 'Y'
   LET tm.d = '3'
   LET tm.e = 'N'
   LET tm.f = 'N'  #FUN-6C0012
   LET tm.h = 'Y'  #MOD-860252
   LET tm.m = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.u1   = tm.u[1,1]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
 
   WHILE TRUE
 
      CONSTRUCT BY NAME tm.wc ON aba01,aba02,abb03,abb05,abb11,aba00,abb02,abb06
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
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
 
 
      INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,
                      tm2.u1,tm2.u2,tm2.u3,tm.d,tm.e,tm.f,tm.h,tm.m WITHOUT DEFAULTS  #FUN-6C0012  #NO.MOD-860252 add tm.h
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD d
            IF tm.d NOT MATCHES "[123]" THEN
               NEXT FIELD d
            END IF
 
         AFTER FIELD m
            IF tm.m NOT MATCHES "[YN]" THEN
               NEXT FIELD m
            END IF
            IF tm.m = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         AFTER INPUT
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
            LET tm.t = tm2.t1,tm2.t2,tm2.t3
            LET tm.u = tm2.u1,tm2.u2,tm2.u3
 
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
         CLOSE WINDOW gglr911_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file      #get exec cmd (fglgo xxxx)
          WHERE zz01='gglr911'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
             CALL cl_err('gglr911','9031',1)   
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,            #(at time fglgo xxxx p1 p2 p3)
                        " '",g_bookno CLIPPED,"'",
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_lang CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.s CLIPPED,"'",
                        " '",tm.t CLIPPED,"'",
                        " '",tm.u CLIPPED,"'",
                        " '",tm.d CLIPPED,"'",
                        " '",tm.e CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('gglr911',g_time,l_cmd)      # Execute cmd at later time
         END IF
 
         CLOSE WINDOW gglr911_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL gglr911()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW gglr911_w
 
END FUNCTION
 
FUNCTION gglr911()
   DEFINE l_name      LIKE type_file.chr20,   #NO FUN-690009   VARCHAR(20)   # External(Disk) file name
#       l_time          LIKE type_file.chr8          #No.FUN-6A0097
          l_sql       LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(1000) # RDSQL STATEMENT
          l_chr       LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
          l_order     ARRAY[5] OF LIKE abb_file.abb11,  #NO FUN-690009   VARCHAR(20)   #排列順序
          l_i         LIKE type_file.num5,    #NO FUN-690009   SMALLINT
          sr          RECORD
                         order1    LIKE abb_file.abb11,  #NO FUN-690009   VARCHAR(20)  #排列順序-1
                         order2    LIKE abb_file.abb11,  #NO FUN-690009   VARCHAR(20)  #排列順序-2
                         order3    LIKE abb_file.abb11,  #NO FUN-690009   VARCHAR(20)  #排列順序-3
                         aba00     LIKE aba_file.aba00,#帳別
                         aba01     LIKE aba_file.aba01,#傳票編號
                         aba02     LIKE aba_file.aba02,#傳票日期
                         abb02     LIKE abb_file.abb02,#Seq
                         abb03     LIKE abb_file.abb03,#科目
                         aag02     LIKE aag_file.aag02,#科目名稱
                         aag13     LIKE aag_file.aag13,#FUN-6C0012
                         abb04     LIKE abb_file.abb04,#摘要
                         abb05     LIKE abb_file.abb05,#部門
                         abb06     LIKE abb_file.abb06,#借貸別
                         abb07     LIKE abb_file.abb07,#異動金額
                         abb11     LIKE abb_file.abb11,#異動碼-1
                         abb12     LIKE abb_file.abb12,#異動碼-2
                         abb07f    LIKE abb_file.abb07f,#原幣金額
                         abb24     LIKE abb_file.abb24,#幣種
                         abb25     LIKE abb_file.abb25,#匯率
                         azi04     LIKE azi_file.azi04,    #NO:7911
                         amt_d     LIKE abb_file.abb07,
                         amt_c     LIKE abb_file.abb07,
                         amt_df    LIKE abb_file.abb07,
                         amt_cf    LIKE abb_file.abb07
                      END RECORD
     DEFINE  l_gem02       LIKE gem_file.gem02   #NO.FUN-850005
     DEFINE  l_azi07       LIKE azi_file.azi07   #NO.FUN-870151
 
   #No.FUN-B80096--mark--Begin---
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
   #No.FUN-B80096--mark--End-----
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = g_bookno
      AND aaf02 = g_rlang
 
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno
   IF SQLCA.sqlcode THEN
#     CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660124
      CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","",0)   #No.FUN-660124
   END IF
 
   SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file WHERE azi01 = g_aaa03   #No.CHI-6A0004
   IF SQLCA.sqlcode THEN
#     CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660124
      CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","",0)   #No.FUN-660124
   END IF
 
   #====>資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND abauser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND abagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND abagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('abauser', 'abagrup')
   #End:FUN-980030
 
   CALL cl_del_data(l_table)     #NO.FUN-850005
   LET l_sql = "SELECT '','','', aba00,aba01,aba02,",
               "       abb02,abb03,aag02,aag13,abb04,abb05,abb06,abb07,abb11,", #FUN-6C0012
               "       abb12,abb07f,abb24,abb25,'',0,0,0,0 ",
               "  FROM aba_file, abb_file, OUTER aag_file",
               " WHERE aba00 = abb00",
               "   AND aba00 = aag00",    #No.FUN-740055
               "   AND aba01 = abb01",
               "   AND abb_file.abb03 = aag_file.aag01",
               "   AND abaacti='Y'",
               "   AND aba19 <> 'X' ",  #CHI-C80041
               "   AND ",tm.wc
   #No.MOD-860252--begin--
   IF tm.h = 'Y' THEN 
      LET l_sql = l_sql CLIPPED,"  AND aag09 = 'Y'  " 
   END IF
   #No.MOD-860252---end---
   CASE
      WHEN tm.d = '1'
         LET l_sql = l_sql CLIPPED," AND abapost = 'N' "
      WHEN tm.d = '2'
         LET l_sql = l_sql CLIPPED," AND abapost = 'Y' "
   END CASE
 
   PREPARE gglr911_prepare1 FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF
   DECLARE gglr911_curs1 CURSOR FOR gglr911_prepare1
 
#NO.FUN-850005----begin--------
#  CALL cl_outnam('gglr911') RETURNING l_name
#   
#  #FUN-6C0012.....begin
#  IF tm.e = 'Y' THEN
#      LET g_zaa[38].zaa06 = 'N'
#  ELSE
#      LET g_zaa[38].zaa06 = 'Y'
#  END IF
#  IF tm.f = 'Y' THEN
#      LET g_zaa[40].zaa06 = 'Y'                                                
#      LET g_zaa[46].zaa06 = 'N'                                                
#   ELSE                                                                        
#      LET g_zaa[40].zaa06 = 'N'                                                
#      LET g_zaa[46].zaa06 = 'Y'                                                
#   END IF                                                                      
#   CALL cl_prt_pos_len()
#   #FUN-6C0012.....end
#  START REPORT gglr911_rep TO l_name
#NO.FUN-850005----end-------
   FOREACH gglr911_curs1 INTO sr.*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
         EXIT PROGRAM
      END IF
 
      FOR l_i = 1 TO 3
         CASE WHEN tm.s[l_i,l_i]='1' LET l_order[l_i] =sr.aba01
                                     #LET g_orderA[l_i]=g_x[10]   #NO.FUN-850005
              WHEN tm.s[l_i,l_i]='2' LET l_order[l_i] =sr.aba02 USING 'yyyymmdd'
                                     #LET g_orderA[l_i]=g_x[11]   #NO.FUN-850005
              WHEN tm.s[l_i,l_i]='3' LET l_order[l_i] =sr.abb03
                                     #LET g_orderA[l_i]=g_x[12]   #NO.FUN-850005
              WHEN tm.s[l_i,l_i]='4' LET l_order[l_i] =sr.abb05
                                     #LET g_orderA[l_i]=g_x[13]   #NO.FUN-850005
              WHEN tm.s[l_i,l_i]='5' LET l_order[l_i] =sr.abb11
                                     #LET g_orderA[l_i]=g_x[14]   #NO.FUN-850005
              WHEN tm.s[l_i,l_i]='6' LET l_order[l_i] =sr.aba00
                                     #LET g_orderA[l_i]=g_x[15]   #NO.FUN-850005
              WHEN tm.s[l_i,l_i]='7' LET l_order[l_i] =sr.abb02 USING'&&&'
                                     #LET g_orderA[l_i]=g_x[16]   #NO.FUN-850005
              WHEN tm.s[l_i,l_i]='8' LET l_order[l_i] =sr.abb06
                                     #LET g_orderA[l_i]=g_x[17]   #NO.FUN-850005
              OTHERWISE LET l_order[l_i] = '-' #LET g_orderA[l_i]=' '   #NO.FUN-850005
         END CASE
      END FOR
 
      LET sr.order1 = l_order[1]
      LET sr.order2 = l_order[2]
      LET sr.order3 = l_order[3]
 
      SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = sr.abb24
      SELECT azi07 INTO l_azi07 FROM azi_file WHERE azi01 = sr.abb24       #FUN-870151
 
      IF sr.abb06 = '1' THEN
         LET sr.amt_d = sr.abb07
         LET sr.amt_df = sr.abb07f
         LET sr.amt_c = 0
         LET sr.amt_cf = 0
      ELSE
         LET sr.amt_d = 0
         LET sr.amt_df = 0
         LET sr.amt_c = sr.abb07
         LET sr.amt_cf = sr.abb07f
      END IF
 
      IF sr.abb05 IS NOT NULL THEN
         LET l_gem02 = NULL
         SELECT gem02 INTO l_gem02 FROM gem_file
             WHERE gem01=sr.abb05
      END IF      
      EXECUTE insert_prep USING sr.order1,sr.order2,sr.order3,sr.aba01,sr.abb03,
          sr.abb05,sr.abb24,sr.amt_df,sr.amt_cf,sr.abb11,sr.abb04,sr.aba02,
          sr.aag02,sr.aag13,l_gem02,sr.abb25,sr.amt_d,sr.amt_c,sr.abb12,sr.azi04,l_azi07
 
#      OUTPUT TO REPORT gglr911_rep(sr.*)         #NO.FUN-850005 
 
   END FOREACH
 
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog            
   IF g_zz05='Y' THEN
      CALL cl_wcchp(tm.wc,'aba02,aba01,abb03,abb05')
         RETURNING tm.wc
   ELSE
      LET tm.wc = ""
   END IF
   LET g_str = tm.wc,";",tm.e,";",tm.f,";",tm.s[1,1],";",tm.s[2,2],";",
               tm.s[3,3],";",tm.t[1,1],";",tm.t[2,2],";",
               tm.u[1,1],";",tm.u[2,2],";",tm.u[3,3],";",t_azi04,";",g_azi04
 
   IF tm.e = 'N' AND tm.f = 'N' THEN
      CALL cl_prt_cs3('gglr911','gglr911',g_sql,g_str)
   END IF
   
   IF tm.e = 'N' AND tm.f = 'Y' THEN                                    
      CALL cl_prt_cs3('gglr911','gglr911_1',g_sql,g_str)                  
   END IF
 
   IF tm.e = 'Y' AND tm.f = 'N' THEN                                    
      CALL cl_prt_cs3('gglr911','gglr911_2',g_sql,g_str)                  
   END IF
 
   IF tm.e = 'Y' AND tm.f = 'Y' THEN                                    
      CALL cl_prt_cs3('gglr911','gglr911_3',g_sql,g_str)                  
   END IF
#NO.FUN-850005 add end   
#NO.FUN-850005 mark begin
#   FINISH REPORT gglr911_rep
 
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
#NO.FUN-850005 mark end
END FUNCTION
 
#NO.FUN-850005---BEGIN----
#REPORT gglr911_rep(sr)
#  DEFINE l_last_sw     LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
#         sr            RECORD
#                          order1    LIKE abb_file.abb11,  #NO FUN-690009   VARCHAR(20)  #排列順序-1
#                          order2    LIKE abb_file.abb11,  #NO FUN-690009   VARCHAR(20)  #排列順序-2
#                          order3    LIKE abb_file.abb11,  #NO FUN-690009   VARCHAR(20)  #排列順序-3
#                          aba00     LIKE aba_file.aba00,#帳別
#                          aba01     LIKE aba_file.aba01,#傳票編號
#                          aba02     LIKE aba_file.aba02,#傳票日期
#                          abb02     LIKE abb_file.abb02,#Seq
#                          abb03     LIKE abb_file.abb03,#科目
#                          aag02     LIKE aag_file.aag02,#科目名稱
#                          aag13     LIKE aag_file.aag13,#FUN-6C0012
#                          abb04     LIKE abb_file.abb04,#摘要
#                          abb05     LIKE abb_file.abb05,#部門
#                          abb06     LIKE abb_file.abb06,#借貸別
#                          abb07     LIKE abb_file.abb07,#異動金額
#                          abb11     LIKE abb_file.abb11,#異動碼-1
#                          abb12     LIKE abb_file.abb12,#異動碼-2
#                          abb07f    LIKE abb_file.abb07f,#原幣金額
#                          abb24     LIKE abb_file.abb24,#幣種
#                          abb25     LIKE abb_file.abb25,#匯率
#                          azi04     LIKE azi_file.azi04,    #NO:7911
#                          amt_d     LIKE abb_file.abb07,
#                          amt_c     LIKE abb_file.abb07,
#                          amt_df    LIKE abb_file.abb07,
#                          amt_cf    LIKE abb_file.abb07
#                       END RECORD,
#         l_gem02       LIKE gem_file.gem02,
#         s_amt_d       LIKE abb_file.abb07,
#         s_amt_c       LIKE abb_file.abb07,
#         t_amt_d       LIKE abb_file.abb07,
#         t_amt_c       LIKE abb_file.abb07
#  DEFINE g_head1       STRING
#  DEFINE l_azi07       LIKE azi_file.azi07                #FUN-870151
 
#  OUTPUT
#     TOP MARGIN g_top_margin
#     LEFT MARGIN g_left_margin
#     BOTTOM MARGIN g_bottom_margin
#     PAGE LENGTH g_page_line
 
#  ORDER BY sr.order1,sr.order2,sr.order3,sr.aba01
 
#  FORMAT
#     PAGE HEADER
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
##         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]    #No.TQC-6A0094
#        LET g_pageno = g_pageno + 1
#        LET pageno_total = PAGENO USING '<<<',"/pageno"
##        PRINT g_head CLIPPED,pageno_total     # No.TQC-740305
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]    #No.TQC-6A0094
#        PRINT g_head CLIPPED,pageno_total     # No.TQC-740305
#        LET g_head1 = g_x[9] CLIPPED,g_orderA[1] CLIPPED,
#                      '-',g_orderA[2] CLIPPED,'-',g_orderA[3] CLIPPED
#        PRINT g_head1
#        PRINT g_dash[1,g_len]
#        PRINTX name = H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],
#                         g_x[37],g_x[38]
#        PRINTX name = H2 g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],   
#                         g_x[45],g_x[46]              #FUN-6C0012                                        
#        PRINT g_dash1
#        LET l_last_sw = 'n'
 
#     BEFORE GROUP OF sr.order1
#        IF tm.t[1,1] = 'Y' THEN
#           SKIP TO TOP OF PAGE
#        END IF
 
#     BEFORE GROUP OF sr.order2
#        IF tm.t[2,2] = 'Y' THEN
#           SKIP TO TOP OF PAGE
#        END IF
 
#     ON EVERY ROW
#        IF sr.abb05 IS NOT NULL THEN
#           LET l_gem02 = NULL
#           SELECT gem02 INTO l_gem02 FROM gem_file
#            WHERE gem01=sr.abb05
#        END IF
#
#        PRINTX name = D1 COLUMN g_c[31],sr.aba01,
#                         COLUMN g_c[32],sr.abb03,
#                         COLUMN g_c[33],sr.abb05,
#                         COLUMN g_c[34],sr.abb24,
#                         COLUMN g_c[35],cl_numfor(sr.amt_df,35,t_azi04),  #No.CHI-6A0004
#                         COLUMN g_c[36],cl_numfor(sr.amt_cf,36,t_azi04),  #No.CHI-6A0004
#                         COLUMN g_c[37],sr.abb11;
#        IF tm.e='Y' THEN
#           PRINTX name = D1 COLUMN g_c[38],sr.abb04 CLIPPED
#        ELSE
#           PRINT
#        END IF
#        
#        SELECT azi07 INTO l_azi07 FROM azi_file WHERE azi01 = sr.abb24          #FUN-870151 
#        
#        PRINTX name = D2 COLUMN g_c[39],sr.aba02 USING "YY-MM-DD",
#                         COLUMN g_c[40],sr.aag02 CLIPPED,  #MOD-4A0238
#                         COLUMN g_c[46],sr.aag13 CLIPPED;  #FUN-6C0012                   
#        PRINTX name = D2 COLUMN g_c[41],l_gem02,
##                         COLUMN g_c[42],sr.abb25 USING "##.&&",          #No.FUN-870151 Mark
#                         COLUMN g_c[42],cl_numfor(sr.abb25,42,l_azi07),  #No.FUN-870151
#                         COLUMN g_c[43],cl_numfor(sr.amt_d,43,t_azi04),  #No.CHI-6A0004
#                         COLUMN g_c[44],cl_numfor(sr.amt_c,44,t_azi04),  #No.CHI-6A0004
#                         COLUMN g_c[45],sr.abb12 CLIPPED
 
#     AFTER GROUP OF sr.order1
#        IF tm.u[1,1] = 'Y' THEN
#           LET s_amt_d = 0
#           LET s_amt_c = 0
#           LET s_amt_d = GROUP SUM(sr.amt_d)
#           LET s_amt_c = GROUP SUM(sr.amt_c)
#           #FUN-6C0012.....begin
#           #PRINT COLUMN g_c[35],g_dash2[1,g_w[35]],
#           #      COLUMN g_c[36],g_dash2[1,g_w[36]]
#           PRINTX name = S2 COLUMN g_c[43],g_dash2[1,g_w[43]],                 
#                            COLUMN g_c[44],g_dash2[1,g_w[44]]
#           #PRINT COLUMN g_c[33],g_orderA[1] CLIPPED,
#           #      COLUMN g_c[34],g_x[18] CLIPPED,
#           #      COLUMN g_c[35],cl_numfor(s_amt_d,35,t_azi04),   #No.CHI-6A0004
#           #      COLUMN g_c[36],cl_numfor(s_amt_c,36,t_azi04)    #No.CHI-6A0004
#           PRINTX name = S2 COLUMN g_c[41],g_orderA[1] CLIPPED,                
#                            COLUMN g_c[42],g_x[18] CLIPPED,                    
#                            COLUMN g_c[43],cl_numfor(s_amt_d,43,sr.azi04),     
#                            COLUMN g_c[44],cl_numfor(s_amt_c,44,sr.azi04)
#           #FUN-6C0012.....end
#           PRINT
#        END IF
 
#     AFTER GROUP OF sr.order2
#        IF tm.u[2,2] = 'Y' THEN
#           LET s_amt_d = 0
#           LET s_amt_c = 0
#           LET s_amt_d = GROUP SUM(sr.amt_d)
#           LET s_amt_c = GROUP SUM(sr.amt_c)
#           #FUN-6C0012.....begin
#           #PRINT COLUMN g_c[35],g_dash2[1,g_w[35]],
#           #      COLUMN g_c[36],g_dash2[1,g_w[36]]
#           #PRINT COLUMN g_c[33],g_orderA[2] CLIPPED,
#           #      COLUMN g_c[34],g_x[18] CLIPPED,
#           #      COLUMN g_c[35],cl_numfor(s_amt_d,35,t_azi04),   #No.CHI-6A0004
#           #      COLUMN g_c[36],cl_numfor(s_amt_c,36,t_azi04)    #No.CHI-6A0004
#           PRINTX name = S2 COLUMN g_c[43],g_dash2[1,g_w[43]],                 
#                            COLUMN g_c[44],g_dash2[1,g_w[44]]
#           PRINTX name = S2 COLUMN g_c[41],g_orderA[2] CLIPPED,                
#                            COLUMN g_c[42],g_x[18] CLIPPED,                    
#                            COLUMN g_c[43],cl_numfor(s_amt_d,43,sr.azi04),     
#                            COLUMN g_c[44],cl_numfor(s_amt_c,44,sr.azi04)
#           #FUN-6C0012.....end
#           PRINT
#        END IF
 
#     AFTER GROUP OF sr.order3
#        IF tm.u[3,3] = 'Y' THEN
#           LET s_amt_d = 0
#           LET s_amt_c = 0
#           LET s_amt_d = GROUP SUM(sr.amt_d)
#           LET s_amt_c = GROUP SUM(sr.amt_c)
#           #FUN-6C0012.....begin
#           #PRINT COLUMN g_c[35],g_dash2[1,g_w[35]],
#           #      COLUMN g_c[36],g_dash2[1,g_w[36]]
#           #PRINT COLUMN g_c[33],g_orderA[3] CLIPPED,
#           #      COLUMN g_c[34],g_x[18] CLIPPED,
#           #      COLUMN g_c[35],cl_numfor(s_amt_d,35,t_azi04),   #No.CHI-6A0004
#           #      COLUMN g_c[36],cl_numfor(s_amt_c,36,t_azi04)    #No.CHI-6A0004
#           PRINTX name = S2 COLUMN g_c[43],g_dash2[1,g_w[43]],                 
#                            COLUMN g_c[44],g_dash2[1,g_w[44]]
#           PRINTX name = S2 COLUMN g_c[41],g_orderA[3] CLIPPED,                
#                            COLUMN g_c[42],g_x[18] CLIPPED,                    
#                            COLUMN g_c[43],cl_numfor(s_amt_d,43,sr.azi04),     
#                            COLUMN g_c[44],cl_numfor(s_amt_c,44,sr.azi04)
#           #FUN-6C0012.....end
#           PRINT
#        END IF
 
#     ON LAST ROW
#        #FUN-6C0012.....begin
#        #PRINT COLUMN g_c[35],g_dash[1,g_w[35]],
#        #      COLUMN g_c[36],g_dash[1,g_w[36]]
#        PRINTX name = S2 COLUMN g_c[43],g_dash[1,g_w[43]],
#                         COLUMN g_c[43],g_dash[1,g_w[44]]
#        #FUN-6C0012.....end
#        LET t_amt_d = 0
#        LET t_amt_c = 0
#        LET t_amt_d = SUM(sr.amt_d)
#        LET t_amt_c = SUM(sr.amt_c)
#        #FUN-6C0012....begin
#        #PRINT COLUMN g_c[34],g_x[19] CLIPPED,
#        #      COLUMN g_c[35],cl_numfor(t_amt_d,35,t_azi04),  #No.CHI-6A0004
#        #      COLUMN g_c[36],cl_numfor(t_amt_c,36,t_azi04)   #No.CHI-6A0004
#        PRINTX name = S2 COLUMN g_c[42],g_x[19] CLIPPED,
#                         COLUMN g_c[43],cl_numfor(t_amt_d,43,g_azi04),
#                         COLUMN g_c[44],cl_numfor(t_amt_c,44,g_azi04)
#        #FUN-6C0012.....end
#
#        IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#           CALL cl_wcchp(tm.wc,'aba02,aba01,abb03,abb05') RETURNING tm.wc
#           PRINT g_dash[1,g_len]
#       #TQC-630166
#       #    IF tm.wc[001,070] > ' ' THEN                  # for 80
#       #       PRINT COLUMN g_c[31],g_x[8] CLIPPED,
#       #             COLUMN g_c[32],tm.wc[001,070] CLIPPED
#       #    END IF
#       #    IF tm.wc[071,140] > ' ' THEN
#       #       PRINT COLUMN g_c[32],tm.wc[071,140] CLIPPED
#       #    END IF
#       #    IF tm.wc[141,210] > ' ' THEN
#       #       PRINT COLUMN g_c[32],tm.wc[141,210] CLIPPED
#       #    END IF
#       #    IF tm.wc[211,280] > ' ' THEN
#       #       PRINT COLUMN g_c[32],tm.wc[211,280] CLIPPED
#       #    END IF
#       CALL cl_prt_pos_wc(tm.wc)
#       #END TQC-630166
#        END IF
#        PRINT g_dash[1,g_len]
#        LET l_last_sw = 'y'
#        PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
#
#     PAGE TRAILER
#        IF l_last_sw = 'n' THEN
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
#        ELSE
#           SKIP 2 LINE
#        END IF
 
#END REPORT
#Patch....NO.TQC-610037 <001> #
#NO.FUN-850005 ---mark end --
