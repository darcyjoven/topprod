# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: gglr906.4gl
# Descriptions...: 分類帳
# Input parameter:
# Return code....:
# Date & Author..: 92/03/10 By DAVID
# modify by nick 96/05/17
# Modify.........: 97/08/06 By Melody  l_sql 加入 aba00=abb00 段
# Modify.........: No.FUN-510007 05/02/16 By Nicola 報表架構修改
# Modify.........: No.TQC-5B0044 05/11/07 By Smapmin 多出空白行
# Modify.........: No.FUN-5C0015 06/01/03 By miki
#                  列印l_buf異動碼值內容，加上abb11~36，放寬欄寬至60
# Modify.........: No.FUN-660124 06/06/21 By Cheunl cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-690009 06/09/06 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.CHI-6A0004 06/10/23 By atsea g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.TQC-6A0094 06/11/10 By johnray 報表修改
# Modify.........: No.CHI-720009 07/03/06 By rainy "無異動科目列印"未作用
# Modify.........: No.FUN-740055 07/04/13 By johnray   會計科目加帳套
# Modify.........: No.FUN-810019 08/01/31 By baofei 報表改為CR輸出 
# Modify.........: No.MOD-820011 08/02/01 By Smapmin 修改SQL語法
# Modify.........: No.MOD-850094 08/05/19 By Sarah 寫入Temptable時會多寫入一筆傳票日期是空的資料,3X時此筆資料根本不會印出,故5.1此筆資料不需寫入Temptable
# Modify.........: No.FUN-870151 08/08/13 By xiaofeizhu 報表中匯率欄位小數位數沒有依 aooi050 做取位
# Modify.........: No.MOD-860252 08/07/02 By chenl 增加打印時是否打印貨幣性科目或全部科目的選擇。
# Modify.........: No.MOD-920275 09/02/20 By liuxqa 外幣金額顯示錯誤.
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A70007 10/07/13 By Summer 多帳期改用s_azmm,並依據畫面上的帳別傳遞使用
# Modify.........: No.FUN-B20054 10/02/23 By yangtingting 先錄入帳套,科目根據帳套過濾;結構改為DIALOG
# Modify.........: No.TQC-B30147 11/03/18 By yinhy 查詢條件為空，跳到科目編號欄位
# Modify.........: No:FUN-B80096 11/08/10 By Lujh 模組程序撰寫規範修正
# Modify.........: No.CHI-C80041 12/12/25 By bart 排除作廢
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
                # wc1       VARCHAR(1000),
                # wc2       VARCHAR(1000),
		 wc1	    STRING,
		 wc2 	    STRING,
                 t          LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
                 u          LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
                 s          LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
                 v          LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
                 x          LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
                 y          LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
                 z          LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
                 h          LIKE type_file.chr1,    #MOD-860252
                 more       LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
                 bookno     LIKE aaa_file.aaa01     #No.FUN-740055
              END RECORD,
          yy,mm           LIKE type_file.num10,   #NO FUN-690009   INTEGER
          l_begin,l_end   LIKE type_file.dat,     #NO FUN-690009   DATE
          bdate,edate     LIKE type_file.dat,     #NO FUN-690009   DATE
          l_flag          LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)
#          g_bookno        LIKE aaa_file.aaa01     #No.FUN-740055
   DEFINE g_aaa03         LIKE aaa_file.aaa03
   DEFINE g_cnt           LIKE type_file.num10    #NO FUN-690009   INTEGER
   DEFINE g_msg           LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(72)
   #No.FUN-810019---Begin                                                                                                           
   DEFINE g_sql     STRING                                                                                                          
   DEFINE g_str     STRING                                                                                                          
   DEFINE l_table  STRING                                                                                                           
   DEFINE l_table1  STRING                                                                                                          
   #No.FUN-810019---End  
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
   #No.FUN-810019---Begin                                                                                                           
   LET g_sql= "order1.aag_file.aag223,",                                                                                            
              " aag02.aag_file.aag02,",                                                                                             
              " aae02.aae_file.aae02,",                                                                                             
              " aea05.aea_file.aea05,",                                                                                             
              " aea02.aea_file.aea02,",                                                                                             
              " aea03.aea_file.aea03,",                                                                                             
              " aea04.aea_file.aea04,",                                                                                             
              " aba11.aba_file.aba11,",                                                                                             
              " abb04.abb_file.abb04,",                                                                                             
              " abb05.abb_file.abb05,",                                                                                             
              " abb06.abb_file.abb06,",                                                                                             
              " abb07_1.abb_file.abb07,",                                                                                           
              " abb07_2.abb_file.abb07,",                                                                                           
              " abb07f_1.abb_file.abb07f,",                                                                                         
              " abb07f_2.abb_file.abb07f,",                                                                                         
              " abb24.abb_file.abb24,",                                                                                             
              " abb25.abb_file.abb25,",                                                                                             
              " l_bal.aah_file.aah04,",                                                                                             
              " l_d.aah_file.aah04,",                                                                                               
              " l_c.aah_file.aah04,",                                                                                               
              " l_bal_sr.aah_file.aah04,",                                                                                          
              " azi04.azi_file.azi04,",  
              " l_chr.type_file.chr1,",                                                                                             
              " l_buf.type_file.chr1000,",                                                                                          
              " l_continue.type_file.chr1,",
              " azi07.azi_file.azi07 "                                                                                          
   LET l_table = cl_prt_temptable('gglr906',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
                                                                                                                                    
   LET g_sql = " abc01.abc_file.abc01,",                                                                                            
               " abc02.abc_file.abc02,",                                                                                            
               " abc04.abc_file.abc04 "                                                                                             
                                                                                                                                    
   LET l_table1 = cl_prt_temptable('gglr9061',g_sql) CLIPPED                                                                        
   IF l_table1 = -1 THEN EXIT PROGRAM END IF                                                                                        
   #No.FUN-810019---End  
 
#   LET g_bookno = ARG_VAL(1)   #No.FUN-740055
   LET tm.bookno = ARG_VAL(1)   #No.FUN-740055
   LET g_pdate = ARG_VAL(2)            # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc1 = ARG_VAL(8)
   LET tm.wc2 = ARG_VAL(9)
   LET tm.t  = ARG_VAL(10)
   LET tm.u  = ARG_VAL(11)
   LET tm.s  = ARG_VAL(12)   #TQC-610056
   LET tm.v  = ARG_VAL(13)
   LET tm.x  = ARG_VAL(14)
   LET tm.y  = ARG_VAL(15)
   LET tm.z  = ARG_VAL(16)
   LET bdate = ARG_VAL(17)   #TQC-610056
   LET edate = ARG_VAL(18)   #TQC-610056
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(19)
   LET g_rep_clas = ARG_VAL(20)
   LET g_template = ARG_VAL(21)
   LET g_rpt_name = ARG_VAL(22)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#   IF g_bookno IS NULL OR g_bookno = ' ' THEN   #No.FUN-740055
   IF tm.bookno IS NULL OR tm.bookno = ' ' THEN   #No.FUN-740055
#        LET g_bookno = g_aaz.aaz64   #No.FUN-740055
        LET tm.bookno = g_aza.aza81   #No.FUN-740055
   END IF
   #-->使用預設帳別之幣別
#   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno   #No.FUN-740055
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.bookno   #No.FUN-740055
   IF SQLCA.sqlcode THEN LET g_aaa03 = g_aza.aza17 END IF     #使用本國幣別
#   SELECT azi04,azi05 INTO g_azi04,g_azi05 FROM azi_file WHERE azi01 = g_aaa03   #No.CHI-6A0004
   IF SQLCA.sqlcode THEN 
#       CALL cl_err(g_aaa03,SQLCA.sqlcode,0)  # No.FUN-660124
        CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","",0)   #No.FUN-660124
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80096   ADD
   IF cl_null(g_bgjob) OR g_bgjob = 'N'            # If background job sw is off
      THEN CALL gglr906_tm()                    # Input print condition
      ELSE CALL gglr906()                  # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD

END MAIN
 
FUNCTION gglr906_tm()
   DEFINE p_row,p_col      LIKE type_file.num5,    #NO FUN-690009   SMALLINT
          l_cmd            LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(400)
   DEFINE li_chk_bookno LIKE type_file.num5   #FUN-B20054
   
#   CALL s_dsmark(g_bookno)   #No.FUN-740055
   CALL s_dsmark(tm.bookno)   #No.FUN-740055
 
   LET p_row = 2 LET p_col = 20
 
#   OPEN WINDOW gglr906_w AT p_row,p_col WITH FORM "agl/42f/aglr906"  #No.FUN-740055
   OPEN WINDOW gglr906_w AT p_row,p_col WITH FORM "ggl/42f/gglr906"  #No.FUN-740055
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
# Prog. Version..: '5.30.06-13.03.12(0,0,g_bookno)   #No.FUN-740055
   CALL s_shwact(0,0,tm.bookno)   #No.FUN-740055
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  # Default condition
   LET bdate   = NULL
   LET edate   = NULL
   LET tm.t    = 'N'
   LET tm.u    = 'N'
   LET tm.s    = 'Y'
   LET tm.v    = 'N'
   LET tm.x    = 'Y'
   LET tm.z    = 'N'
   LET tm.h    = 'Y'     #No.MOD-860252
   LET tm.more = 'N'
   LET tm.bookno = g_aza.aza81
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
    DISPLAY BY NAME tm.t,tm.u,tm.s,tm.v,tm.x,tm.y,tm.z,tm.h,tm.more   #FUN-B20054

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
    CONSTRUCT BY NAME tm.wc1 ON aag01
    
     #FUN-B20054--mark--str-- 
     #ON ACTION locale
     #   #CALL cl_dynamic_locale()
     #   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
     #   LET g_action_choice = "locale"
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
     #
     # ON ACTION exit
     #    LET INT_FLAG = 1
     #    EXIT CONSTRUCT    
     #FUN-B20054--mark--end--
  END CONSTRUCT
       #FUN-B20054--mark--str--
       #IF g_action_choice = "locale" THEN
       #   LET g_action_choice = ""
       #   CALL cl_dynamic_locale()
       #   CONTINUE WHILE
       #END IF  
       #FUN-B20054--mark--end--
 
    CONSTRUCT BY NAME tm.wc2 ON aba11  
       #FUN-B20054--mark--str--
       #ON IDLE g_idle_seconds
       #   CALL cl_on_idle()
       #   CONTINUE CONSTRUCT
       #
       #ON ACTION about         #MOD-4C0121
       #   CALL cl_about()      #MOD-4C0121
       #
       #ON ACTION help          #MOD-4C0121
       #  CALL cl_show_help()  #MOD-4C0121
       #
       #ON ACTION controlg      #MOD-4C0121
       #   CALL cl_cmdask()     #MOD-4C0121   
       #
       #ON ACTION exit
       #   LET INT_FLAG = 1
       #   EXIT CONSTRUCT 
       #FUN-B20054--mark--end-- 
    END CONSTRUCT  
#FUN-B20054--mark--str-- 
#       IF g_action_choice = "locale" THEN
#          LET g_action_choice = ""
#          CALL cl_dynamic_locale()
#          CONTINUE WHILE
#       END IF
# 
#    IF INT_FLAG THEN
#        LET INT_FLAG = 0 CLOSE WINDOW gglr906_w EXIT PROGRAM
#    END IF
#FUN-B20054--mark--str-- 
#FUN-B20054--TO AFTER END DIALOG--str-- 
#    IF tm.wc1 = ' 1=1' AND tm.wc2 = ' 1=1' THEN
#       CALL cl_err('','9046',0) CONTINUE WHILE
#    END IF
#FUN-B20054--TO AFTER END DIALOG--end-- 
#    DISPLAY BY NAME tm.t,tm.u,tm.s,tm.v,tm.x,tm.y,tm.z,tm.h,tm.more   #No.MOD-860252 add tm.h  #FUN-B20054       

    INPUT BY NAME bdate,edate,tm.t,tm.u,tm.s,tm.v,tm.x,tm.z,tm.h,tm.y,tm.more   #No.FUN-740055  #No.MOD-860252 add tm.h  #FUN-B20054 del bookno
         # WITHOUT DEFAULTS  #FUN-B20054
           ATTRIBUTE(WITHOUT DEFAULTS)  #FUN-B20054
           
          AFTER FIELD bdate
            IF bdate IS NULL THEN
               NEXT FIELD bdate
            END IF
          AFTER FIELD edate
            IF edate IS NULL THEN
               LET edate =g_lastdat
            END IF
            IF edate < bdate THEN
               CALL cl_err(' ','agl-031',0)
               NEXT FIELD edate
            END IF
          AFTER FIELD t
            IF tm.t NOT MATCHES "[YN]" THEN NEXT FIELD t END IF
          AFTER FIELD u
            IF tm.u NOT MATCHES "[YN]" THEN NEXT FIELD u END IF
          AFTER FIELD s
            IF tm.s NOT MATCHES "[YN]" THEN NEXT FIELD s END IF
          AFTER FIELD v
            IF tm.v NOT MATCHES "[YN]" THEN NEXT FIELD v END IF
          AFTER FIELD x
            IF tm.x NOT MATCHES "[YN]" THEN NEXT FIELD x END IF
          AFTER FIELD y
            IF tm.y NOT MATCHES "[12345]" THEN NEXT FIELD y END IF
          AFTER FIELD z
            IF tm.z NOT MATCHES "[YN]" THEN NEXT FIELD z END IF
          AFTER FIELD more
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                         g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,
                         g_bgjob,g_time,g_prtway,g_copies
            END IF
 
        #FUN-B20054--mark--str--
         #ON ACTION CONTROLP
         #   CASE
        #FUN-B20054--mark--end--
#No.FUN-740055 -- begin --
         #FUN-B20054--mark--str--
          # WHEN INFIELD(bookno)
          #    CALL cl_init_qry_var()
          #    LET g_qryparam.form ="q_aaa"
          #    LET g_qryparam.default1 = tm.bookno
          #    CALL cl_create_qry() RETURNING tm.bookno
          #    DISPLAY tm.bookno TO bookno
          #    NEXT FIELD bookno
          #   END CASE
         #FUN-B20054--mark--end--
#No.FUN-740055 -- end --
 
# START genero shell script ADD
#FUN-B20054--mark--str--
#          ON ACTION CONTROLR
#              CALL cl_show_req_fields()
#FUN-B20054--mark--end--
# END genero shell script ADD

#FUN-B20054--mark--str--
#       ON ACTION CONTROLG CALL cl_cmdask()      # Command execution
#       ON IDLE g_idle_seconds
#          CALL cl_on_idle()
#          CONTINUE INPUT
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
#FUN-B20054--mark--end--
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
         IF (cl_null(tm.wc1) AND cl_null(tm.wc2)) OR (tm.wc1 = ' 1=1' AND tm.wc2= ' 1=1') THEN
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
       CLOSE WINDOW gglr906_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
       EXIT PROGRAM
    END IF
    #FUN-B20054--add--end--
    
    IF tm.wc1 = ' 1=1' AND tm.wc2 = ' 1=1' THEN   #FUN-B20054
       CALL cl_err('','9046',0) CONTINUE WHILE    #FUN-B20054
    END IF                                        #FUN-B20054
   
    SELECT azn02,azn04 INTO yy,mm FROM azn_file WHERE azn01 = bdate
    #CALL s_azm(yy,mm) RETURNING l_flag,l_begin,l_end #CHI-A70007 mark
    #CHI-A70007 add --start--
    IF g_aza.aza63 = 'Y' THEN
       CALL s_azmm(yy,mm,g_plant,tm.bookno) RETURNING l_flag,l_begin,l_end
    ELSE
       CALL s_azm(yy,mm) RETURNING l_flag,l_begin,l_end
    END IF
    #CHI-A70007 add --end--
    IF l_begin=bdate THEN LET l_begin='9999/12/31' END IF
    IF g_bgjob = 'Y' THEN
       SELECT zz08 INTO l_cmd FROM zz_file      #get exec cmd (fglgo xxxx)
             WHERE zz01='gglr906'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('gglr906','9031',1)   
       ELSE
         LET tm.wc1=cl_wcsub(tm.wc1)
          LET l_cmd = l_cmd CLIPPED,            #(at time fglgo xxxx p1 p2 p3)
#                         " '",g_bookno CLIPPED,"'",   #No.FUN-7400a55
                         " '",tm.bookno CLIPPED,"'",   #No.FUN-740055
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc1 CLIPPED,"'",
                         " '",tm.wc2 CLIPPED,"'",   #TQC-610056
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.v CLIPPED,"'",
                         " '",tm.x CLIPPED,"'",
                         " '",tm.y CLIPPED,"'",
                         " '",tm.z CLIPPED,"'",
                         " '",bdate CLIPPED,"'",   #TQC-610056
                         " '",edate CLIPPED,"'",   #TQC-610056
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
          CALL cl_cmdat('gglr906',g_time,l_cmd)      # Execute cmd at later time
       END IF
       CLOSE WINDOW gglr906_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
       EXIT PROGRAM
    END IF
    CALL cl_wait()
    CALL gglr906()
    ERROR ""
  END WHILE
  CLOSE WINDOW gglr906_w
END FUNCTION
 
FUNCTION gglr906()
   DEFINE l_name      LIKE type_file.chr20,   #NO FUN-690009   VARCHAR(20)   # External(Disk) file name
          l_cnt       LIKE type_file.num5,    #CHI-720009
#       l_time          LIKE type_file.chr8          #No.FUN-6A0097
          l_sql       LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(1000) # RDSQL STATEMENT
          l_sql1      LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(1000) # RDSQL STATEMENT
          l_chr       LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
          sr1         RECORD
                         aag223 LIKE aag_file.aag223,  #NO FUN-690009   VARCHAR(5)
                         aag224 LIKE aag_file.aag224,  #NO FUN-690009   VARCHAR(5)
                         aag225 LIKE aag_file.aag225,  #NO FUN-690009   VARCHAR(5)
                         aag226 LIKE aag_file.aag226,  #NO FUN-690009   VARCHAR(5)
                         aag01  LIKE aag_file.aag01,   # course no
                         aag02  LIKE aag_file.aag02,   # course name
                         aag07  LIKE aag_file.aag07    # course type
                      END RECORD,
          sr          RECORD
                         order1 LIKE aag_file.aag223,   #NO FUN-690009   VARCHAR(5)
                         aea05  LIKE aea_file.aea05,   # acct. kinds
                         aea02  LIKE aea_file.aea02,   # trans date
                         aea03  LIKE aea_file.aea03,   # trans no
                         aea04  LIKE aea_file.aea04,   # trans seq
                         aba05  LIKE aba_file.aba05,   # input date
                         aba06  LIKE aba_file.aba06,   # Source code
                         aba11  LIKE aba_file.aba11,   # Source code
                         abb04  LIKE abb_file.abb04,   #
                         abb05  LIKE abb_file.abb05,   #
                         abb06  LIKE abb_file.abb06,   # D or  C
                         abb07_1  LIKE abb_file.abb07,   #No.FUN-810019
                         abb07_2  LIKE abb_file.abb07,   #No.FUN-810019
                         abb07  LIKE abb_file.abb07,                         
                         abb07f_1  LIKE abb_file.abb07f,   #No.FUN-810019
                         abb07f_2 LIKE abb_file.abb07f, #No.FUN-810019
                         abb07f LIKE abb_file.abb07f, # amount
                         abb11  LIKE abb_file.abb11,   #
                         abb12  LIKE abb_file.abb12,   #
                         abb13  LIKE abb_file.abb13,   #
                         abb14  LIKE abb_file.abb14,   #
                         abb31  LIKE abb_file.abb31,   #FUN-5C0015-----(S)
                         abb32  LIKE abb_file.abb32,
                         abb33  LIKE abb_file.abb33,
                         abb34  LIKE abb_file.abb34,
                         abb35  LIKE abb_file.abb35,
                         abb36  LIKE abb_file.abb36,   #FUN-5C0015-----(E)
                         abb24  LIKE abb_file.abb24,   #
                         abb25  LIKE abb_file.abb25,   #
                         aag02  LIKE aag_file.aag02,   # course name
                         azi04  LIKE azi_file.azi04,   # course name
                         amt    LIKE abb_file.abb07,
                         l_bal  LIKE aah_file.aah04,
                         l_d    LIKE aah_file.aah04,
                         l_c    LIKE aah_file.aah04
                      END RECORD,
#No.FUN-810019---Begin                                                                                                              
          abb07_1                   LIKE abb_file.abb07,                                                                            
          abb07_2                   LIKE abb_file.abb07,                                                                            
          abb07f_1                  LIKE abb_file.abb07f,                                                                           
          abb07f_2                  LIKE abb_file.abb07f,                                                                           
          l_amt,l_c,l_d,l_bal       LIKE aah_file.aah04,                                                                            
          l_t_d,l_t_c               LIKE aah_file.aah04,                                                                            
          g_sum                     LIKE aah_file.aah04,                                                                            
          l_last_sw                 LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)                                                
          l_abb07,l_aah04,l_aah05   LIKE aah_file.aah04,                                                                            
          l_abb06                   LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(01)                                               
          l_continue                LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(01)                                               
          l_sql2                    LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(100)                                              
          l_aae02                   LIKE aae_file.aae02,                                                                            
          l_buf                     LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(60)    #FUN-5C0015                                
          l_abc04                   LIKE abc_file.abc04,    #NO FUN-690009   VARCHAR(30)                                              
          abc01                     LIKE abc_file.abc01,                                                                            
          abc02                     LIKE abc_file.abc02 
  DEFINE  l_azi07                   LIKE azi_file.azi07     #No.FUN-870151
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",                                                                       
                 "        ?,?,?,?,?, ?,?,?,?,?,? )"                                      #FUN-870151 Add"?"                                                                          
     PREPARE insert_prep FROM g_sql                                                                                                 
     IF STATUS THEN                                                                                                                 
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
        EXIT PROGRAM                                                                           
     END IF                                                                                                                         
                                                                                                                                    
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                               
                 " VALUES(?,?,? )        "                                                                                          
     PREPARE insert_prep1 FROM g_sql                                                                                                
     IF STATUS THEN                                                                                                                 
        CALL cl_err('insert_prep1:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
        EXIT PROGRAM                                                                          
     END IF                                                                                                                         
     CALL cl_del_data(l_table)                                                                                                      
     CALL cl_del_data(l_table1)                                                                                                     
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                       
#No.FUN-810019---End     
   
   #No.FUN-B80096--mark--Begin---  
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
   #No.FUN-B80096--mark--End-----
   SELECT aaf03 INTO g_company FROM aaf_file
#    WHERE aaf01 = g_bookno   #No.FUN-740055
    WHERE aaf01 = tm.bookno   #No.FUN-740055
      AND aaf02 = g_lang
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc1 = tm.wc1 clipped," AND aaguser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc1 = tm.wc1 clipped," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc1 = tm.wc1 clipped," AND aaggrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc1 = tm.wc1 CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
   #End:FUN-980030
 
 
   LET l_sql1 = "SELECT aag223,aag224,aag225,aag226,aag01,aag02,aag07 ",
                "  FROM aag_file ",
                " WHERE aag03 ='2' AND aag07 IN ('2','3')",
                "   AND ",tm.wc1,
                #" AND aag00 = ",tm.bookno    #No.FUN-740055   #MOD-820011
                " AND aag00 = '",tm.bookno,"'"   #MOD-820011
 
   #No.MOD-860252--begin--
   IF tm.h = 'Y' THEN 
      LET l_sql1 = l_sql1, " AND aag09 = 'Y' " 
   END IF 
   #No.MOD-860252---end---
   PREPARE gglr906_prepare2 FROM l_sql1
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF
   DECLARE gglr906_curs2 CURSOR FOR gglr906_prepare2
 
   LET l_sql = "SELECT '',",
               "  aea05,aea02,aea03,aea04,aba05,aba06,aba11,abb04,abb05,abb06,",
              #->FUN-5C0015--------------------------------------------------(S)
              #"  abb07,abb07f,abb11,abb12,abb13,abb14,abb24,abb25,'',azi04,",
               "  abb07,abb07f,abb11,abb12,abb13,abb14,",
               "  abb31,abb32,abb33,abb34,abb35,abb36,",
               "  abb24,abb25,'',azi04,",
              #->FUN-5C0015--------------------------------------------------(E)
               "  0,0,0,0",
               "  FROM aea_file,aba_file,abb_file,azi_file ",
               " WHERE aea05 =  ? ",
#               "   AND aea00 = '",g_bookno,"' ",   #No.FUN-740055
               "   AND aea00 = '",tm.bookno,"' ",   #No.FUN-740055
               "   AND aea00 = aba00 ",
               "   AND aba00 = abb00 ",
               "   AND aba01 = abb01 ",
               "   AND aea02 BETWEEN '",bdate,"' AND '",edate,"' ",
               "   AND abb01 = aea03 AND abb02 = aea04 ",
               "   AND aba01 = aea03",
               "   AND azi01 = abb24 ",
               "   AND ",tm.wc2 CLIPPED,
               "   ORDER BY aea02,aea03 "   #NO:2760
 
   PREPARE gglr906_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF
   DECLARE gglr906_curs1 CURSOR FOR gglr906_prepare1
 
#   CALL cl_outnam('gglr906') RETURNING l_name          #No.FUN-810019    
#   START REPORT gglr906_rep TO l_name                  #No.FUN-810019 
 
#   LET g_pageno = 0                                    #No.FUN-810019 
 
   FOREACH gglr906_curs2 INTO sr1.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      IF tm.x = 'N' AND sr1.aag07 = '3' THEN
         CONTINUE FOREACH
      END IF
 
      #CHI-720009 begin
        IF tm.t = 'N' THEN  #無異動科目不列印
           LET l_cnt = 0 
           SELECT COUNT(*) INTO l_cnt FROM aba_file,abb_file
            WHERE aba00 = abb00
              AND aba01 = abb01
              AND abb03 = sr1.aag01
              AND aba02 >= bdate
              AND aba02 <= edate
              AND aba19 <> 'X'  #CHI-C80041
           IF l_cnt = 0 THEN
              CONTINUE FOREACH
           END IF
        END IF
      #CHI-720009 end
 
      LET g_cnt = 0
      LET l_flag = 'N'
 
      FOREACH gglr906_curs1 USING sr1.aag01 INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
        
 
         LET l_flag='Y'
         LET sr.aag02=sr1.aag02
         
         SELECT azi07 INTO l_azi07 FROM azi_file        #FUN-870151 
          WHERE azi01 = sr.abb24                        #FUN-870151         
 
         CASE WHEN tm.y = '1' LET sr.order1 = sr1.aag223
              WHEN tm.y = '2' LET sr.order1 = sr1.aag224
              WHEN tm.y = '3' LET sr.order1 = sr1.aag225
              WHEN tm.y = '4' LET sr.order1 = sr1.aag226
              OTHERWISE       LET sr.order1 = ' '
         END CASE
#No.FUN-810019---Begin
         LET g_sum = 0
         LET l_d = sr.l_d
         LET l_c = sr.l_c
         LET l_aae02 = NULL
         LET l_d = 0
         LET l_c = 0
 
         IF g_aaz.aaz51 = 'Y' THEN   
            SELECT sum(aah04-aah05) INTO l_bal FROM aah_file
             WHERE aah01 = sr.aea05
               AND aah02 = yy
               AND aah03 = 0
#               AND aah00 = g_bookno   #No.FUN-740055
               AND aah00 = tm.bookno   #No.FUN-740055
 
            SELECT SUM(aas04-aas05) INTO sr.l_bal FROM aas_file
#             WHERE aas00 = g_bookno   #No.FUN-740055
             WHERE aas00 = tm.bookno   #No.FUN-740055
               AND aas01 = sr.aea05
               AND YEAR(aas02) = yy
               AND aas02 < bdate
         ELSE
            SELECT sum(aah04-aah05) INTO l_bal FROM aah_file
             WHERE aah01 = sr.aea05
               AND aah02 = yy
               AND aah03 < mm
#               AND aah00 = g_bookno   #No.FUN-740055
               AND aah00 = tm.bookno   #No.FUN-740055
            LET l_d = 0
 
            SELECT sum(abb07) INTO l_d FROM abb_file,aba_file
             WHERE abb03 = sr.aea05
               AND aba01 = abb01
               AND abb06='1'
               AND aba02 >= l_begin
               AND aba02 < bdate
#               AND aba00 = g_bookno   #No.FUN-740055
               AND aba00 = tm.bookno   #No.FUN-740055
               AND abapost = 'Y'
               AND aba03 = yy
               AND aba04 <= mm
 
            IF l_d IS NULL THEN
               LET l_d = 0
            END IF
 
            SELECT sum(abb07) INTO l_c FROM aba_file,abb_file
             WHERE abb03 = sr.aea05
               AND aba01 = abb01
               AND abb06 = '2'
               AND aba02 >= l_begin
               AND aba02 < bdate
#               AND aba00 = g_bookno   #No.FUN-740055
               AND aba00 = tm.bookno   #No.FUN-740055
               AND abapost = 'Y'
               AND aba03 = yy
               AND aba04 <= mm
 
            IF l_c IS NULL THEN
               LET l_c = 0
            END IF
         END IF
 
         IF l_bal IS NULL THEN
            LET l_bal = 0
         END IF
 
         IF sr.l_bal IS NULL THEN
            LET sr.l_bal = 0
         END IF
 
      #   LET l_bal = l_bal + l_d - l_c + sr.l_bal 
 
         SELECT aae02 INTO l_aae02 FROM aae_file WHERE aae01 = sr.order1
         IF sr.abb07 != 0 THEN        
            LET l_continue = 'Y'
            LET l_buf = ' '
 
           #->FUN-5C0015-----------------------------------------------------(S)
            IF sr.abb11 IS NOT NULL THEN LET l_buf = sr.abb11 END IF                
            IF sr.abb12 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb12 END IF   
            IF sr.abb13 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb13 END IF    
            IF sr.abb14 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb14 END IF    
            IF sr.abb31 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb31 END IF 
            IF sr.abb32 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb32 END IF 
            IF sr.abb33 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb33 END IF 
            IF sr.abb34 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb34 END IF 
            IF sr.abb35 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb35 END IF 
            IF sr.abb36 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb36 END IF 
           #->FUN-5C0015-----------------------------------------------------(E)
            IF sr.abb06 = '1' THEN 
               LET abb07_1 = sr.abb07             
               LET abb07_2 = 0
               LET abb07f_1 = sr.abb07f
               LET abb07f_2 = 0     
            ELSE                   
               LET abb07_1 = 0
               LET abb07_2 = sr.abb07 
               LET abb07f_1 = 0                          
               LET abb07f_2 = sr.abb07f
          
            END IF
           IF tm.v = 'Y' THEN
               DECLARE abc_curs CURSOR FOR SELECT abc04 FROM abc_file
#                                            WHERE abc00 = g_bookno   #No.FUN-740055
                                            WHERE abc00 = tm.bookno   #No.FUN-740055
                                              AND abc01 = sr.aea03
                                              AND abc02 = sr.aea04
               FOREACH abc_curs INTO l_abc04
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('abc_curs',SQLCA.sqlcode,0)
                     EXIT FOREACH
                  END IF
                  IF NOT cl_null(l_abc04) THEN
                   EXECUTE insert_prep1 USING abc01,abc02,l_abc04
                  END IF
               END FOREACH
            END IF
            LET l_continue = 'N'
         END IF
         EXECUTE insert_prep USING sr.order1,sr.aag02,l_aae02,sr.aea05,sr.aea02,
                                   sr.aea03,sr.aea04,sr.aba11,sr.abb04,sr.abb05,
#                                   sr.abb06,abb07_1,abb07_2,abb07f_1,abb07_2,sr.abb24,sr.abb25,  #No.MOD-920275 mark by liuxqa 
                                   sr.abb06,abb07_1,abb07_2,abb07f_1,abb07f_2,sr.abb24,sr.abb25,  #No.MOD-920275 mod  by liuxqa 
                                   l_bal,l_d,l_c,sr.l_bal,sr.azi04,l_chr,
                                   l_buf,l_continue,l_azi07               
#         OUTPUT TO REPORT gglr906_rep(sr.*)
#No.FUN-810019---End
      END FOREACH
 
    #str MOD-850094 mark
    # LET sr.aea05 = sr1.aag01
    # LET sr.aea02 = NULL
    # LET sr.aag02 = sr1.aag02
    # LET sr.abb07 = 0
    # LET sr.abb07f = 0
    #
    # CASE WHEN tm.y = '1' LET sr.order1 = sr1.aag223
    #      WHEN tm.y = '2' LET sr.order1 = sr1.aag224
    #      WHEN tm.y = '3' LET sr.order1 = sr1.aag225
    #      WHEN tm.y = '4' LET sr.order1 = sr1.aag226
    #      OTHERWISE       LET sr.order1 = ' '
    # END CASE
#No.FUN-810019---Begin
    #    LET g_sum = 0
    #    LET l_d = sr.l_d
    #    LET l_c = sr.l_c
    #    LET l_aae02 = NULL
    #    LET l_d = 0
    #    LET l_c = 0
    #
    #    IF g_aaz.aaz51 = 'Y' THEN   
    #       SELECT sum(aah04-aah05) INTO l_bal FROM aah_file
    #        WHERE aah01 = sr.aea05
    #          AND aah02 = yy
    #          AND aah03 = 0
#   #           AND aah00 = g_bookno   #No.FUN-740055
    #          AND aah00 = tm.bookno   #No.FUN-740055
    #
    #       SELECT SUM(aas04-aas05) INTO sr.l_bal FROM aas_file
#   #         WHERE aas00 = g_bookno   #No.FUN-740055
    #        WHERE aas00 = tm.bookno   #No.FUN-740055
    #          AND aas01 = sr.aea05
    #          AND YEAR(aas02) = yy
    #          AND aas02 < bdate
    #    ELSE
    #       SELECT sum(aah04-aah05) INTO l_bal FROM aah_file
    #        WHERE aah01 = sr.aea05
    #          AND aah02 = yy
    #          AND aah03 < mm
#   #           AND aah00 = g_bookno   #No.FUN-740055
    #          AND aah00 = tm.bookno   #No.FUN-740055
    #       LET l_d = 0
    #
    #       SELECT sum(abb07) INTO l_d FROM abb_file,aba_file
    #        WHERE abb03 = sr.aea05
    #          AND aba01 = abb01
    #          AND abb06='1'
    #          AND aba02 >= l_begin
    #          AND aba02 < bdate
#   #           AND aba00 = g_bookno   #No.FUN-740055
    #          AND aba00 = tm.bookno   #No.FUN-740055
    #          AND abapost = 'Y'
    #          AND aba03 = yy
    #          AND aba04 <= mm
    #
    #       IF l_d IS NULL THEN
    #          LET l_d = 0
    #       END IF
    #
    #       SELECT sum(abb07) INTO l_c FROM aba_file,abb_file
    #        WHERE abb03 = sr.aea05
    #          AND aba01 = abb01
    #          AND abb06 = '2'
    #          AND aba02 >= l_begin
    #          AND aba02 < bdate
#   #           AND aba00 = g_bookno   #No.FUN-740055
    #          AND aba00 = tm.bookno   #No.FUN-740055
    #          AND abapost = 'Y'
    #          AND aba03 = yy
    #          AND aba04 <= mm
    #
    #       IF l_c IS NULL THEN
    #          LET l_c = 0
    #       END IF
    #    END IF
    #
    #    IF l_bal IS NULL THEN
    #       LET l_bal = 0
    #    END IF
    #
    #    IF sr.l_bal IS NULL THEN
    #       LET sr.l_bal = 0
    #    END IF
    #
    # #   LET l_bal = l_bal + l_d - l_c + sr.l_bal 
    #
    #    SELECT aae02 INTO l_aae02 FROM aae_file WHERE aae01 = sr.order1
    #    IF sr.abb07 != 0 THEN        
    #       LET l_continue = 'Y'
    #
    #       LET l_buf = ' '
    #      #->FUN-5C0015-----------------------------------------------------(S)
    #       IF sr.abb11 IS NOT NULL THEN LET l_buf = sr.abb11 END IF                
    #       IF sr.abb12 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb12 END IF   
    #       IF sr.abb13 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb13 END IF    
    #       IF sr.abb14 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb14 END IF    
    #       IF sr.abb31 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb31 END IF 
    #       IF sr.abb32 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb32 END IF 
    #       IF sr.abb33 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb33 END IF 
    #       IF sr.abb34 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb34 END IF 
    #       IF sr.abb35 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb35 END IF 
    #       IF sr.abb36 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb36 END IF 
    #      #->FUN-5C0015-----------------------------------------------------(E)
    #       IF sr.abb06 = '1' THEN                                                                                                  
    #          LET abb07_1 = sr.abb07                                                                                            
    #          LET abb07_2 = 0                                                                                                   
    #          LET abb07f_1 = sr.abb07f                                                                                          
    #          LET abb07f_2 = 0                                                                                                  
    #       ELSE                                                                                                                    
    #          LET abb07_1 = 0                                                                                                   
    #          LET abb07_2 = sr.abb07                                                                                            
    #          LET abb07f_1 = 0                                                                                                  
    #          LET abb07f_2 = sr.abb07f                                                                                          
    #                                                                                                                               
    #       END IF                  
    #      IF tm.v = 'Y' THEN
    #          DECLARE abc_curs1 CURSOR FOR SELECT abc04 FROM abc_file
#   #                                        WHERE abc00 = g_bookno   #No.FUN-740055
    #                                       WHERE abc00 = tm.bookno   #No.FUN-740055
    #                                         AND abc01 = sr.aea03
    #                                         AND abc02 = sr.aea04
    #          FOREACH abc_curs1 INTO l_abc04
    #             IF SQLCA.sqlcode THEN
    #                CALL cl_err('abc_curs',SQLCA.sqlcode,0)
    #                EXIT FOREACH
    #             END IF
    #             IF NOT cl_null(l_abc04) THEN
    #              EXECUTE insert_prep1 USING abc01,abc02,l_abc04
    #             END IF
    #          END FOREACH
    #       END IF
    #       LET l_continue = 'N'
    #    END IF 
    #   EXECUTE insert_prep USING sr.order1,sr.aag02,l_aae02,sr.aea05,sr.aea02,                                                    
    #                              sr.aea03,sr.aea04,sr.aba11,sr.abb04,sr.abb05,                                                    
    #                              sr.abb06,abb07_1,abb07_2,abb07f_1,abb07f_2,sr.abb24,sr.abb25,                                                   
    #                              l_bal,l_d,l_c,sr.l_bal,sr.azi04,l_chr,                                                  
    #                              l_buf,l_continue 
    #end MOD-850094 mark
#      OUTPUT TO REPORT gglr906_rep(sr.*)
#No.FUN-810019---End
   END FOREACH
#No.FUN-810019---Begin
#   FINISH REPORT gglr906_rep
      LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",                                                      
                  "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED                                                           
                                                                                                                                    
        LET g_str = ''                                                                                                              
        IF g_zz05 = 'Y' THEN                                                                                                        
           CALL cl_wcchp(tm.wc1,'aag01')                                                                                            
                RETURNING g_str                                                                                                     
        END IF                                                                                                                      
        LET g_str = g_str,";",bdate,";",edate,";",tm.bookno,";",tm.z,";",tm.u,";",                                                         
                    tm.s,";",tm.v,";",g_azi04                                                                  
        CALL cl_prt_cs3('gglr906','gglr906',g_sql,g_str) 
    # CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-810019---End
    #No.FUN-B80096--mark--Begin--- 
    #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
    #No.FUN-B80096--mark--End-----
END FUNCTION
#No.FUN-810019---Begin
#REPORT gglr906_rep(sr)
#  DEFINE sr     RECORD
#                   order1 LIKE aag_file.aag223,    #NO FUN-690009   VARCHAR(4)
#                   aea05  LIKE aea_file.aea05,
#                   aea02  LIKE aea_file.aea02,
#                   aea03  LIKE aea_file.aea03,
#                   aea04  LIKE aea_file.aea04,
#                   aba05  LIKE aba_file.aba05,
#                   aba06  LIKE aba_file.aba06,
#                   aba11  LIKE aba_file.aba11,
#                   abb04  LIKE abb_file.abb04,
#                   abb05  LIKE abb_file.abb05,
#                   abb06  LIKE abb_file.abb06,
#                   abb07  LIKE abb_file.abb07,
#                   abb07f LIKE abb_file.abb07f,
#                   abb11  LIKE abb_file.abb11,   #
#                   abb12  LIKE abb_file.abb12,   #
#                   abb13  LIKE abb_file.abb13,   #
#                   abb14  LIKE abb_file.abb14,   #
#                   abb31  LIKE abb_file.abb31,   #FUN-5C0015-----(S)
#                   abb32  LIKE abb_file.abb32,
#                   abb33  LIKE abb_file.abb33,
#                   abb34  LIKE abb_file.abb34,
#                   abb35  LIKE abb_file.abb35,
#                   abb36  LIKE abb_file.abb36,   #FUN-5C0015-----(E)
#                   abb24  LIKE abb_file.abb24,   #
#                   abb25  LIKE abb_file.abb25,   #
#                   aag02  LIKE aag_file.aag02,
#                   azi04  LIKE azi_file.azi04,
#                   amt    LIKE abb_file.abb07,
#                   l_bal  LIKE aah_file.aah04,
#                   l_d    LIKE aah_file.aah04,
#                   l_c    LIKE aah_file.aah04
#                END RECORD,
#         l_amt,l_c,l_d,l_bal       LIKE aah_file.aah04,
#         l_t_d,l_t_c               LIKE aah_file.aah04,
#         g_sum                     LIKE aah_file.aah04,
#         l_last_sw                 LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
#         l_abb07,l_aah04,l_aah05   LIKE aah_file.aah04,
#         l_chr,l_abb06             LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(01)
#         l_continue                LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(01)
#         l_sql2                    LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(100)
#         l_aae02                   LIKE aae_file.aae02,
#        #l_buf                     VARCHAR(15),  #FUN-5C0015
#         l_buf                     LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(60)    #FUN-5C0015
#         l_abc04                   LIKE abc_file.abc04     #NO FUN-690009   VARCHAR(30)
#  DEFINE g_head1                   STRING
 
#  OUTPUT
#     TOP MARGIN g_top_margin
#     LEFT MARGIN g_left_margin
#     BOTTOM MARGIN g_bottom_margin
#     PAGE LENGTH g_page_line
 
#  ORDER BY sr.order1,sr.aea05,sr.aea02
 
#  FORMAT
#     PAGE HEADER
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
##         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]    #No.TQC-6A0094
#         LET g_pageno = g_pageno + 1
#        LET pageno_total = PAGENO USING '<<<',"/pageno"
#        PRINT g_head CLIPPED,pageno_total
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]    #No.TQC-6A0094
#        LET g_head1 = g_x[9] CLIPPED,bdate,'-',edate
##         PRINT g_head1                                          #No.TQC-6A0094
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_head1))/2)-1,g_head1   #No.TQC-6A0094
#        PRINT g_dash[1,g_len]
#        PRINTX name = H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
#        PRINTX name = H2 g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43]
#        PRINT g_dash1
#        LET l_last_sw = 'n'
 
#        IF l_continue = 'Y' THEN
#           PRINT COLUMN g_c[31],g_x[10] CLIPPED,
#                 COLUMN g_c[32],sr.aea05 CLIPPED,
#                 COLUMN g_c[33],sr.aag02 CLIPPED;
#           IF l_bal >= 0 THEN
#              PRINT COLUMN g_c[36],cl_numfor(l_bal,36,g_azi04),
#                    COLUMN g_c[37],'D'
#           ELSE
#              LET l_amt = l_bal * (-1)
#              PRINT COLUMN g_c[36],cl_numfor(l_amt,36,g_azi04),
#                    COLUMN g_c[37],'C'
#           END IF
#        ELSE
#           PRINT ''
#        END IF
#        LET l_continue = 'N'
#
#     BEFORE GROUP OF sr.order1
#        IF tm.z = 'Y' THEN
#           SKIP TO TOP OF PAGE
#        END IF
#        LET g_sum = 0
 
#     BEFORE GROUP OF sr.aea05     #明細科目
#        IF tm.u = 'Y' THEN
#           SKIP TO TOP OF PAGE
#        END IF
 
#        LET l_d = sr.l_d
#        LET l_c = sr.l_c
#        LET l_t_d = 0
#        LET l_t_c = 0
#        LET l_aae02 = NULL
#        LET l_d = 0
#        LET l_c = 0
 
#        IF g_aaz.aaz51 = 'Y' THEN   #每日餘額檔
#           SELECT sum(aah04-aah05) INTO l_bal FROM aah_file
#            WHERE aah01 = sr.aea05
#              AND aah02 = yy
#              AND aah03 = 0
##               AND aah00 = g_bookno   #No.FUN-740055
#               AND aah00 = tm.bookno   #No.FUN-740055
 
#           SELECT SUM(aas04-aas05) INTO sr.l_bal FROM aas_file
##             WHERE aas00 = g_bookno   #No.FUN-740055
#            WHERE aas00 = tm.bookno   #No.FUN-740055
#              AND aas01 = sr.aea05
#              AND YEAR(aas02) = yy
#              AND aas02 < bdate
#        ELSE
#           SELECT sum(aah04-aah05) INTO l_bal FROM aah_file
#            WHERE aah01 = sr.aea05
#              AND aah02 = yy
#              AND aah03 < mm
##               AND aah00 = g_bookno   #No.FUN-740055
#              AND aah00 = tm.bookno   #No.FUN-740055
#           LET l_d = 0
 
#           SELECT sum(abb07) INTO l_d FROM abb_file,aba_file
#            WHERE abb03 = sr.aea05
#              AND aba01 = abb01
#              AND abb06='1'
#              AND aba02 >= l_begin
#              AND aba02 < bdate
##               AND aba00 = g_bookno   #No.FUN-740055
#              AND aba00 = tm.bookno   #No.FUN-740055
#              AND abapost = 'Y'
#              AND aba03 = yy
#              AND aba04 <= mm
 
#           IF l_d IS NULL THEN
#              LET l_d = 0
#           END IF
 
#           SELECT sum(abb07) INTO l_c FROM aba_file,abb_file
#            WHERE abb03 = sr.aea05
#              AND aba01 = abb01
#              AND abb06 = '2'
#              AND aba02 >= l_begin
#              AND aba02 < bdate
##               AND aba00 = g_bookno   #No.FUN-740055
#              AND aba00 = tm.bookno   #No.FUN-740055
#              AND abapost = 'Y'
#              AND aba03 = yy
#              AND aba04 <= mm
 
#           IF l_c IS NULL THEN
#              LET l_c = 0
#           END IF
#        END IF
 
#        IF l_bal IS NULL THEN
#           LET l_bal = 0
#        END IF
 
#        IF sr.l_bal IS NULL THEN
#           LET sr.l_bal = 0
#        END IF
 
#        LET l_bal = l_bal + l_d - l_c + sr.l_bal  # 期初餘額
 
#        SELECT aae02 INTO l_aae02 FROM aae_file WHERE aae01 = sr.order1
 
#       #PRINT sr.order1 CLIPPED,' ',l_aae02 CLIPPED;
#
#        IF l_bal >= 0 THEN
#           PRINT COLUMN g_c[31],g_x[10] CLIPPED,
#                 COLUMN g_c[32],sr.aea05 CLIPPED,
#                 COLUMN g_c[33],sr.aag02 CLIPPED,
#                 COLUMN g_c[34],l_chr CLIPPED,
#                 COLUMN g_c[36],cl_numfor(l_bal,36,g_azi04),
#                 COLUMN g_c[37],'D'
#        ELSE
#           LET l_amt = l_bal * (-1)
#           PRINT COLUMN g_c[31],g_x[10] CLIPPED,
#                 COLUMN g_c[32],sr.aea05 CLIPPED,
#                 COLUMN g_c[33],sr.aag02 CLIPPED,
#                 COLUMN g_c[36],cl_numfor(l_amt,36,g_azi04),
#                 COLUMN g_c[37],'C'
#        END IF
#        PRINT
#
#     ON EVERY ROW
#        IF sr.abb07 != 0 THEN        #異動金額
#           LET l_continue = 'Y'
 
#           IF sr.abb06 = '1' THEN     #借方
#              LET l_bal = l_bal + sr.abb07
#              LET l_t_d = l_t_d + sr.abb07
#           ELSE                       #貸方
#              LET l_bal = l_bal - sr.abb07
#              LET l_t_c = l_t_c + sr.abb07
#           END IF
 
#           LET l_buf = ' '
 
#          #->FUN-5C0015-----------------------------------------------------(S)
#           IF sr.abb11 IS NOT NULL THEN LET l_buf = sr.abb11 END IF    #異動碼-1
#          #IF sr.abb12 IS NOT NULL THEN LET l_buf = sr.abb12 END IF    #異動碼-2
#          #IF sr.abb13 IS NOT NULL THEN LET l_buf = sr.abb13 END IF    #異動碼-3
#          #IF sr.abb14 IS NOT NULL THEN LET l_buf = sr.abb14 END IF    #異動碼-4
#           IF sr.abb12 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb12 END IF    #異動碼-2
#           IF sr.abb13 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb13 END IF    #異動碼-3
#           IF sr.abb14 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb14 END IF    #異動碼-4
#           IF sr.abb31 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb31 END IF #異動碼-5
#           IF sr.abb32 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb32 END IF #異動碼-6
#           IF sr.abb33 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb33 END IF #異動碼-7
#           IF sr.abb34 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb34 END IF #異動碼-8
#           IF sr.abb35 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb35 END IF #異動碼-9
#           IF sr.abb36 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb36 END IF #異動碼-10
#          #->FUN-5C0015-----------------------------------------------------(E)
 
#           PRINTX name = D1 COLUMN g_c[31],sr.aea02,
#                            COLUMN g_c[32],sr.aea03,
#                            COLUMN g_c[33],l_buf;
 
#           IF sr.abb06 = '1' THEN     #借方
#              PRINTX name = D1 COLUMN g_c[34],cl_numfor(sr.abb07,34,g_azi04);
#           ELSE                       #貸方
#              PRINTX name = D1 COLUMN g_c[35],cl_numfor(sr.abb07,35,g_azi04);
#           END IF
 
#           IF l_bal >= 0 THEN
#              PRINTX name = D1 COLUMN g_c[36],cl_numfor(l_bal,36,g_azi04),
#                               COLUMN g_c[37],'D'
#           ELSE
#              LET l_amt = l_bal * (-1)
#              PRINTX name = D1 COLUMN g_c[36],cl_numfor(l_amt,36,g_azi04),
#                               COLUMN g_c[37],'C'
#           END IF
 
#           PRINTX name = D2 COLUMN g_c[39],sr.aba11,
#                            COLUMN g_c[40],sr.abb24,
#                            COLUMN g_c[41],sr.abb25 USING '##&.&&&&';
 
#           IF sr.abb06 = '1' THEN     #借方
#              PRINTX name = D2 COLUMN g_c[42],cl_numfor(sr.abb07f,42,sr.azi04)
#           ELSE                       #貸方
#              PRINTX name = D2 COLUMN g_c[43],cl_numfor(sr.abb07f,43,sr.azi04)
#           END IF
 
#           #Print 摘要
#           IF tm.s = 'Y' THEN
#              PRINT COLUMN g_c[32],sr.abb04,
#                    COLUMN g_c[33],sr.abb05
#           END IF
#
#           IF tm.v = 'Y' THEN
#              DECLARE abc_curs CURSOR FOR SELECT abc04 FROM abc_file
##                                            WHERE abc00 = g_bookno   #No.FUN-740055
#                                           WHERE abc00 = tm.bookno   #No.FUN-740055
#                                             AND abc01 = sr.aea03
#                                             AND abc02 = sr.aea04
#              FOREACH abc_curs INTO l_abc04
#                 IF SQLCA.sqlcode THEN
#                    CALL cl_err('abc_curs',SQLCA.sqlcode,0)
#                    EXIT FOREACH
#                 END IF
#                 IF NOT cl_null(l_abc04) THEN
#                    PRINT COLUMN g_c[32],l_abc04
#                 END IF
#              END FOREACH
#           END IF
#           LET l_continue = 'N'
#        END IF
#        PRINT ' '
 
#     AFTER GROUP OF sr.aea05
#   #    LET g_pageno = 0
#        IF l_t_d != 0 OR l_t_c != 0 THEN
##            PRINT    #TQC-5B0044
#           PRINT COLUMN g_c[33],g_x[11] CLIPPED,
#                 COLUMN g_c[34],cl_numfor(l_t_d,34,g_azi04),
#                 COLUMN g_c[35],cl_numfor(l_t_c,35,g_azi04)
#        END IF
#        IF tm.u = 'N' THEN
#           PRINT g_dash2[1,g_len]
#        END IF
#        LET g_sum = g_sum + l_bal
#
#     AFTER GROUP OF sr.order1
#        PRINT COLUMN g_c[33],sr.order1 CLIPPED,
#              COLUMN g_c[34],l_aae02 CLIPPED,
#              COLUMN g_c[35],g_x[12] CLIPPED
#        IF g_sum >= 0 THEN
#           PRINT COLUMN g_c[36],cl_numfor(g_sum,36,g_azi04),
#                 COLUMN g_c[37],'D'
#        ELSE
#           LET l_amt = g_sum * (-1)
#           PRINT COLUMN g_c[36],cl_numfor(l_amt,36,g_azi04),
#                 COLUMN g_c[37],'C'
#        END IF
#        PRINT g_dash2[1,g_len]
#
#     ON LAST ROW
#        IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#           CALL cl_wcchp(tm.wc1,'aag01') RETURNING tm.wc1
#           PRINT g_dash[1,g_len]
#       #TQC-630166
#       #    IF tm.wc1[001,070] > ' ' THEN                  # for 80
#       #       PRINT COLUMN g_c[31],g_x[8] CLIPPED,
#       #             COLUMN g_c[32],tm.wc1[001,070] CLIPPED
#       #    END IF
#       #    IF tm.wc1[071,140] > ' ' THEN
#       #       PRINT COLUMN g_c[32],tm.wc1[071,140] CLIPPED
#       #    END IF
#       #    IF tm.wc1[141,210] > ' ' THEN
#       #       PRINT COLUMN g_c[32],tm.wc1[141,210] CLIPPED
#       #    END IF
#       #    IF tm.wc1[211,280] > ' ' THEN
#       #       PRINT COLUMN g_c[32],tm.wc1[211,280] CLIPPED
#       #    END IF
#       CALL cl_prt_pos_wc(tm.wc1)
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
#No.FUN-810019---End
#Patch....NO.TQC-610037 <001> #
