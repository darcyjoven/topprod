# Prog. Version..: '5.30.07-13.05.30(00002)'     #
# Pattern name...: axcx006.4gl
# Descriptions...: 營業成本表
# Input parameter: 
# Return code....: 
# Date & Author..: 09/07/29 By jan
# Modify.........: No:FUN-970023 09/08/05 By jan
# Modify.........: No:FUN-9A0067 09/10/26 By mike 對年度期別default ccz01與ccz02
# Modify.........: No:MOD-A50164 10/05/25 By Sarah 1.SQL裡判斷單別(smyslip)的語法有誤
#                                                  2.SQL裡抓取tlf221+tlf222+tlf2231+tlf2232請改成抓tlf21
# Modify.........: No:MOD-A50196 10/05/31 By Sarah 1.cxi_file應該要用outer join的方式
#                                                  2.製費目前只抓cch22c(製費一),漏掉製費二、製費三、製費四、製費五
#                                                  3.報表中的金額取位應該與axcr430的取位相同,要抓azi03來做取位
#                                                  4.建議檢查碼為24(雜收發)的title應該加上雜收發3個字,較好辨認
# Modify.........: No:CHI-A70057 10/08/11 By Summer 增加抓取拆解組合單(tlf13=atmt260/atmt261)的部分
# Modify.........: No:MOD-AA0070 10/10/13 By sabrina sr.order1='60'段不需再另抓ccu_file來計算(l_ccuwip)，
#                                                    因為ccg_file已包含拆件式工單的在製金額
# Modify.........: No:MOD-AB0084 10/11/10 By sabrina 在call axcx006()時應將sr1/sr2 array歸0 
# Modify.........: No:MOD-AB0223 10/11/24 By sabrina 撈資料時有些條件不應有固定值 
# Modify.........: No:TQC-AB0089 10/11/26 By sabrina 修改MOD-AB0223誤mark的資料 
# Modify.........: No:MOD-AC0283 10/12/24 By sabrina 修正MOD-AB0223 
# Modify.........: No:MOD-B10212 11/01/26 By sabrina (1)本期耗用應該在期末前面
#                                                    (2)在製品沒有加、減的細項
# Modify.........: No:MOD-B70063 11/07/17 By Vampire (1)不應將1給sr.azf01
#                                                    (2)多一個判斷：azf02='1'
# Modify.........: No:MOD-B60051 11/07/17 By Pengu 當axci101同部門與理由碼同時有設雜收與雜發，則費用金額會重複
# Modify.........: No:MOD-B70092 11/07/17 By Summer 將sr1[36]、sr1[39]、sr2[36]、sr2[39]值拿掉
# Modify.........: No:FUN-B20053 11/08/01 By xianghui 增加報表列印順序的選項，預設值為1.原料/半成品/製成品/商品
#                                                                                     2.商品/製成品/半成品/原料
# Modify.........: No:FUN-B80056 11/08/04 By Lujh 模組程序撰寫規範修正
# Modify.........: No:FUN-B90023 11/10/18 By xujing    tit    LIKE type_file.chr100 改為tit    LIKE aag_file.aag02
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
# Modify.........: No:MOD-C10094 12/01/10 By ck2yuan 定義l_azf01 LIKE azf_file.azf01
# Modify.........: No:MOD-C40071 12/04/24 By ck2yuan 差異轉出應加總ccg42
# Modify.........: No.FUN-C10024 12/05/21 By minpp 帳套取歷年主會計帳別檔tna_file						
# Modify.........: No:MOD-B80323 12/06/15 By Elise 修改sr1、sr2 array長度
# Modify.........: No:CHI-B80040 12/07/16 By ck2yuan 增加在製調整金額
# Modify.........: No:CHI-C30012 12/07/19 By bart 金額取位改抓ccz26
# Modify.........: No:CHI-B80021 13/01/22 By Alberti tlf_file 需要考慮到不計成本倉的條件 
# Modify.........: No:CHI-B90043 13/01/22 By Alberti 報表列印順序不論選1或2，期初在製品、本期銷貨成本、營業成本皆要放在後面
# Modify.........: No:CHI-B80085 13/01/25 By Alberti 樣品出貨應與銷售出貨區隔
# Modify.........: No:FUN-D30060 13/03/20 By wangrr CR转为XtraGrid報表
# Modify.........: No:FUN-D40129 13/05/20 By yangtt 去除【列印條件】

DATABASE ds

 GLOBALS "../../config/top.global"

   DEFINE tm  RECORD                  
              wc          STRING,       
              yy,m1,m2    LIKE type_file.num5,
              azh01       LIKE azh_file.azh01,
              azh02       LIKE azh_file.azh02,
              b           LIKE type_file.chr1,
	      c		  LIKE type_file.chr1,
              d           LIKE type_file.chr1,  #FUN-B20053
              more        LIKE type_file.chr1          
              END RECORD,
          g_ccc62         LIKE ccc_file.ccc62,
          g_ccc82         LIKE ccc_file.ccc82,       #CHI-B80085 add
          l_tota,l_totd   LIKE ccc_file.ccc62,    
          g_tot_bal       LIKE type_file.num20_6     
   DEFINE last_yy,last_m1 LIKE type_file.num5
   DEFINE bdate           LIKE type_file.dat
   DEFINE tdate           LIKE type_file.dat
   DEFINE edate           LIKE type_file.dat
   DEFINE g_argv1         LIKE type_file.chr20
   DEFINE g_argv2         LIKE type_file.num5
   DEFINE g_argv3         LIKE type_file.num5
   DEFINE g_chr           LIKE type_file.chr1
   DEFINE g_i             LIKE type_file.num5
  #DEFINE sr1 ARRAY[80] OF LIKE type_file.num20   #暫存計算結果    #MOD-B80323 mark
  #DEFINE sr2 ARRAY[80] OF LIKE type_file.num20   #暫存計算結果    #MOD-B80323 mark
   DEFINE sr1 ARRAY[80] OF LIKE type_file.num20_6   #暫存計算結果  #MOD-B80323 add
   DEFINE sr2 ARRAY[80] OF LIKE type_file.num20_6   #暫存計算結果  #MOD-B80323 add
   DEFINE l_n             LIKE type_file.num5
   DEFINE g_msg           LIKE ze_file.ze03
   DEFINE  g_sql          STRING 
   DEFINE  g_str          STRING
   DEFINE  l_table        STRING
   DEFINE g_bookno1     LIKE aza_file.aza81      #FUN-C10024
   DEFINE g_bookno2     LIKE aza_file.aza82      #FUN-C10024
   DEFINE g_flag        LIKE type_file.chr1      #FUN-C10024	 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN	
       EXIT PROGRAM
   END IF
  
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time    #FUN-B80056  ADD #No.FUN-BB0047  mark 
 
  # LET g_sql = "azf06.type_file.chr1,",     #CHI-B90043 mark  
  #LET g_sql = "azf06.type_file.chr2,",      #CHI-B90043 add  #FUN-D30060
   LET g_sql = "azf06.azf_file.azf06,",      #CHI-B90043 add  #FUN-D30060
               "azf01.azf_file.azf01,", 
               "order2.type_file.chr3,", 
               "other1.type_file.chr100,", 
               "titlea.type_file.chr100,", 
               "amoutn.ccc_file.ccc12,",
               "order1.type_file.chr3,",
               "tit.aag_file.aag02,",      #FUN-B90023 MOD 
               "title4.type_file.chr1000,",#FUN-D30060
               "ccz26.ccz_file.ccz26"      #FUN-D30060

   LET l_table = cl_prt_temptable('axcx006',g_sql)
   IF l_table=-1 THEN EXIT PROGRAM END IF
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?)"  #FUN-D30060 add 2?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
   EXIT PROGRAM 
   END IF 

   FOR l_n = 1 TO 80          
       LET sr1[l_n] = 0
       LET sr2[l_n] = 0
   END FOR	
	
   INITIALIZE tm.* TO NULL    
   LET tm.yy      = g_ccz.ccz01 #FUN-9A0067 year( today)-->g_ccz.ccz01
   LET tm.m1      = g_ccz.ccz02 #FUN-9A0067 month( today)-->g_ccz.ccz02
   LET tm.m2      = g_ccz.ccz02 #FUN-9A0067 month( today)-->g_ccz.ccz02
   LET tm.b       = 'Y'
   LET tm.c       = 'Y'	
   LET tm.d       = '1'      #FUN-B20053
   LET tm.more    = 'N'
   LET g_pdate    = g_today
   LET g_rlang    = g_lang
   LET g_bgjob    = 'N'
   LET g_copies   = '1'
   LET g_argv1    = ARG_VAL(1)         
   LET g_argv2    = ARG_VAL(2)         
   LET g_argv3    = ARG_VAL(3)         
   LET g_rep_user = ARG_VAL(4)
   LET g_rep_clas = ARG_VAL(5)
   LET g_template = ARG_VAL(6)  
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-BB0047  add 
   IF cl_null(g_argv1) THEN 
      CALL axcx006_tm(0,3)         
   ELSE 
      LET tm.wc=" ima01='",g_argv1,"'"
      LET tm.yy=g_argv2
      LET tm.m1=g_argv3
      CALL s_azm(tm.yy,tm.m1) RETURNING g_chr,bdate,tdate
      CALL s_azm(tm.yy,tm.m2) RETURNING g_chr,tdate,edate
      INITIALIZE sr1 TO NULL   #MOD-AB0084 add 
      INITIALIZE sr2 TO NULL   #MOD-AB0084 add 
      CALL axcx006( )            
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80056   ADD
END MAIN

FUNCTION axcx006_tm(p_row,p_col)
   DEFINE p_row,p_col LIKE type_file.num5,
          l_cmd       LIKE type_file.chr1000,
          g_za05      LIKE type_file.chr50
          
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   OPEN WINDOW axcx006_w AT p_row,p_col
        WITH FORM "axc/42f/axcx006" 
        ATTRIBUTE (STYLE = g_win_style)
   CALL cl_ui_init()
   CALL cl_opmsg('p')

WHILE TRUE
	INPUT BY NAME tm.yy,tm.m1,tm.m2,tm.azh01,tm.azh02,tm.b,tm.c,tm.d,tm.more WITHOUT DEFAULTS #FUN-B20053增加tm.d		
 
        AFTER FIELD yy
           IF tm.yy IS NULL THEN NEXT FIELD yy END IF
      
        AFTER FIELD m1
           IF tm.m1 IS NULL THEN NEXT FIELD m1 END IF
           CALL s_azm(tm.yy,tm.m1) RETURNING g_chr,bdate,edate
      
        AFTER FIELD m2
           IF tm.m2 IS NULL THEN NEXT FIELD m2 END IF
           IF tm.m2 < 1 OR tm.m2 > 12 OR tm.m2 < tm.m1 THEN 
               NEXT FIELD m1         
           END IF
           CALL s_azm(tm.yy,tm.m2) RETURNING g_chr,tdate,edate         
           LET bdate = tdate 

        AFTER FIELD azh01
           SELECT azh02 INTO tm.azh02 
             FROM azh_file 
            WHERE azh01 = tm.azh01
           DISPLAY BY NAME tm.azh02     

        AFTER FIELD more
           IF tm.more = 'Y' THEN 
              CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                             g_bgjob,g_time,g_prtway,g_copies)
                   RETURNING g_pdate,g_towhom,g_rlang,
                             g_bgjob,g_time,g_prtway,g_copies
           END IF
   
     ON ACTION CONTROLP 
        CASE WHEN INFIELD(azh01)
             CALL cl_init_qry_var()
             LET g_qryparam.form = 'q_azh'
             LET g_qryparam.default1 = tm.azh01
             LET g_qryparam.default2 = tm.azh02
             CALL cl_create_qry() RETURNING tm.azh01,tm.azh02
             DISPLAY BY NAME tm.azh01,tm.azh02
         END CASE

     ON ACTION CONTROLR
        CALL cl_show_req_fields()

     ON ACTION CONTROLG 
        CALL cl_cmdask()    
    
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
     ON ACTION about         
        CALL cl_about()      
 
     ON ACTION help          
        CALL cl_show_help()  
  
     ON ACTION locale
        CALL cl_show_fld_cont()
        LET g_action_choice = "locale"
        EXIT INPUT

     ON ACTION exit
        LET INT_FLAG = 1
        EXIT INPUT
   END INPUT
   IF g_action_choice = "locale" THEN 
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW axcx006_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80056   ADD
      EXIT PROGRAM
   END IF
   CALL s_azm(tm.yy,tm.m2) RETURNING g_chr,tdate,edate   
   LET bdate = tdate 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file     
             WHERE zz01='axcx006'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcx006','9031',1)   
      ELSE
         LET l_cmd = l_cmd CLIPPED,         
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",            
                         " '",g_rep_clas CLIPPED,"'",            
                         " '",g_template CLIPPED,"'"             
         CALL cl_cmdat('axcx006',g_time,l_cmd)     
      END IF
      CLOSE WINDOW axcx006_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80056   ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   INITIALIZE sr1 TO NULL   #MOD-AB0084 add 
   INITIALIZE sr2 TO NULL   #MOD-AB0084 add 
   CALL axcx006()
   ERROR ""
END WHILE
CLOSE WINDOW axcx006_w
END FUNCTION

FUNCTION axcx006()
   DEFINE l_name   LIKE type_file.chr20,                 
          g_za05   LIKE za_file.za05
   DEFINE l_azf06  LIKE azf_file.azf06
   DEFINE l_azf01  LIKE azf_file.azf01
   DEFINE l_azf03  LIKE azf_file.azf03
   DEFINE l_sql1   STRING                #CHI-B90043 add
   DEFINE l_sql2   STRING                #CHI-B90043 add
   DEFINE l_sql3   STRING                #CHI-B90043 add
	   
     CALL cl_del_data(l_table)
     CALL s_azm(tm.yy,tm.m1) RETURNING g_chr,bdate,tdate
     CALL s_azm(tm.yy,tm.m2) RETURNING g_chr,tdate,edate

     #No.FUN-BB0047--mark--Begin---
     #CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
     #No.FUN-BB0047--mark--End-----
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axcx006'
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     IF g_priv2='4' THEN      #只能使用自己的資料
         LET tm.wc = tm.wc clipped," AND pmmuser = '",g_user,"'"
     END IF
     IF g_priv3='4' THEN      #只能使用相同群的資料
        LET tm.wc = tm.wc clipped," AND pmmgrup MATCHES '",g_grup CLIPPED,"*'"
     END IF
     LET last_yy=tm.yy
     LET last_m1=tm.m1-1
     IF last_m1=0 THEN LET last_yy=tm.yy-1 LET last_m1=12 END IF
     LET g_ccc62 = 0
     LET g_ccc82 = 0       #CHI-B80085 add
     LET l_tota = 0 
     LET l_totd = 0 
	  
     DECLARE axcx006_curs1 CURSOR FOR 
      SELECT azf06,azf01,azf03 FROM azf_file 
       WHERE azf02 = 'G'     #成本分群碼
         AND azfacti = 'Y'
       ORDER BY azf06 DESC, azf01 
     FOREACH axcx006_curs1 INTO l_azf06,l_azf01,l_azf03
       IF l_azf06 IS NULL THEN CONTINUE FOREACH END IF
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       CALL r002_stand(l_azf06,l_azf01,l_azf03)
     END FOREACH
     
     CALL cl_getmsg('axc-300',g_lang) RETURNING g_msg
    #CALL r002_wip('9','ZZZZZ',g_msg) #FUN-D30060
     CALL r002_wip(9,'ZZZZZ',g_msg)   #FUN-D30060

     CALL cl_getmsg('axc-301',g_lang) RETURNING g_msg 
    #EXECUTE insert_prep USING 'y','ZZZZZ','90','',g_msg,'','71',''  #FUN-D30060
     EXECUTE insert_prep USING '100','ZZZZZ','90','',g_msg,'','71',''  #FUN-D30060
                              ,g_msg,g_ccz.ccz26   #FUN-D30060
     CALL cl_getmsg('axc-302',g_lang) RETURNING g_msg
     #-----------CHI-B80085 modify 
     IF tm.c='N' OR g_msg[1,8]<>'        ' OR (tm.c='Y' AND g_ccc62<> 0) THEN #FUN-D30060
    #EXECUTE insert_prep USING 'z','ZZZZZ','99','',g_msg,g_ccc62,'72',''  #FUN-D30060
     EXECUTE insert_prep USING '99','ZZZZZ','99','',g_msg,g_ccc62,'72',''  #FUN-D30060
                              ,g_msg,g_ccz.ccz26   #FUN-D30060
 
    #EXECUTE insert_prep USING 'z','ZZZZZ','98','',g_msg,g_ccc62,'72',''  #FUN-D30060
     EXECUTE insert_prep USING '99','ZZZZZ','98','',g_msg,g_ccc62,'72',''  #FUN-D30060
                               ,g_msg,g_ccz.ccz26   #FUN-D30060  
     END IF  #FUN-D30060
     #-----------CHI-B80085 end
     #------------------CHI-B80085 add
     CALL cl_getmsg('axc-304',g_lang) RETURNING g_msg
     IF tm.c='N' OR g_msg[1,8]<>'        ' OR (tm.c='Y' AND g_ccc82<> 0) THEN #FUN-D30060
    #EXECUTE insert_prep USING 'z','ZZZZZ','99','',g_msg,g_ccc82,'73',''  #FUN-D30060
     EXECUTE insert_prep USING '99','ZZZZZ','99','',g_msg,g_ccc82,'73',''  #FUN-D30060
                              ,g_msg,g_ccz.ccz26   #FUN-D30060
     END IF  #FUN-D30060
     #------------------CHI-B80085 end
     #LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED      #FUN-B20053 mark
     #CHI-B90043---add---start---
     #FUN-D30060 mod  XtraGrid azf06為chr2型時無法進行降序排序,故z y值用99 100來替換
    #IF tm.d='1' THEN
    #   LET l_sql1="UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED ," SET azf06='-3' WHERE azf06='9'"
    #   LET l_sql2="UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED ," SET azf06='-2' WHERE azf06='z'"
    #   LET l_sql3="UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED ," SET azf06='-1' WHERE azf06='y'" 
    #ELSE
    #   LET l_sql1="UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED ," SET azf06='4' WHERE azf06='9'"
    #   LET l_sql2="UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED ," SET azf06='5' WHERE azf06='z'"
    #   LET l_sql3="UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED ," SET azf06='6' WHERE azf06='y'"
    #END IF
     IF tm.d='1' THEN
        LET l_sql1="UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED ," SET azf06=-3 WHERE azf06=9"
        LET l_sql2="UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED ," SET azf06=-2 WHERE azf06=99"
        LET l_sql3="UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED ," SET azf06=-1 WHERE azf06=100" 
     ELSE
        LET l_sql1="UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED ," SET azf06=4 WHERE azf06=9"
        LET l_sql2="UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED ," SET azf06=5 WHERE azf06=99"
        LET l_sql3="UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED ," SET azf06=6 WHERE azf06=100"
     END IF
     #FUN-D30060 mod  
     PREPARE azf06_p1 FROM l_sql1
     EXECUTE azf06_p1
     PREPARE azf06_p2 FROM l_sql2
     EXECUTE azf06_p2
     PREPARE azf06_p3 FROM l_sql3
     EXECUTE azf06_p3
    #CHI-B90043---add---end---
     #FUN-B20053-add-str--
     IF tm.d = '1' THEN 
        LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," ORDER BY azf06 DESC"
     ELSE
###XtraGrid###        LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," ORDER BY azf06"
     END IF
     #FUN-B20053-add-end--

     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'azf01,azf02')
        RETURNING tm.wc
     END IF
###XtraGrid###     LET g_str = tm.wc,";",tm.azh01,";",tm.azh02,";",tm.yy,";",tm.m1,";",
###XtraGrid###                #tm.m2,";",tm.c,";",tm.b,";",g_azi04  #MOD-A50196 mark
###XtraGrid###                 #tm.m2,";",tm.c,";",tm.b,";",g_azi03  #MOD-A50196 #CHI-C30012 mark
###XtraGrid###                 tm.m2,";",tm.c,";",tm.b,";",g_ccz.ccz26  #CHI-C30012
###XtraGrid###     CALL cl_prt_cs3('axcx006','axcx006',g_sql,g_str)
    LET g_xgrid.table = l_table    ###XtraGrid###
    #FUN-D30060--add--str--
    IF tm.d = '1' THEN 
       LET g_xgrid.order_field = 'azf06 DESC,azf01,order2'
    ELSE
       LET g_xgrid.order_field = 'azf06,azf01,order2'
    END IF 
    IF cl_null(tm.azh01) THEN
       LET g_xgrid.title2=cl_getmsg('axc-133',g_lang)
    ELSE
      LET g_xgrid.title2=tm.azh02
    END IF
    LET g_xgrid.headerinfo1=cl_getmsg('agl-172',g_lang),':',tm.yy,
                            cl_getmsg('azz-159',g_lang),':',tm.m1,'--',tm.m2
   #LET g_xgrid.condition=cl_getmsg('lib-160',g_lang),tm.wc  #FUN-D40129 mark
    IF tm.b='Y' THEN
       LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"order2","Y")
    ELSE
       LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"order2","N")
    END IF
    #FUN-D30060--add--end
    CALL cl_xg_view()    ###XtraGrid###
     #No.FUN-BB0047--mark--Begin---
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
     #No.FUN-BB0047--mark--End-----
END FUNCTION

FUNCTION r002_stand(l_azf06,l_azf01,l_title)   #庫存成本計算模組
  DEFINE l_n,l_a,l_b   LIKE type_file.num5
 #DEFINE l_azf06       LIKE type_file.chr1     #FUN-D30060
  DEFINE l_azf06       LIKE azf_file.azf06     #FUN-D30060
 #DEFINE l_azf01       LIKE type_file.chr4     #MOD-C10094 mark
  DEFINE l_azf01       LIKE azf_file.azf01     #MOD-C10094 add
  DEFINE max_azf01     LIKE type_file.chr4
  DEFINE l_title       LIKE type_file.chr100
  DEFINE l_sql         STRING
  DEFINE l_amount      LIKE tlf_file.tlf21
  DEFINE l_ccuwip      LIKE tlf_file.tlf21
  DEFINE l_amt1,l_amt2 LIKE tlf_file.tlf21
  DEFINE l_amt ,l_amt3 LIKE tlf_file.tlf21
  DEFINE l_ccl22       LIKE ccl_file.ccl22   
 #DEFINE sr            RECORD azf06  LIKE type_file.chr1,   #FUN-D30060
  DEFINE sr            RECORD azf06  LIKE azf_file.azf06,   #FUN-D30060
                              azf01  LIKE azf_file.azf01,
                              order  LIKE type_file.chr3,
                              other  LIKE type_file.chr100,
                              title  LIKE type_file.chr100,
                              amount LIKE tlf_file.tlf21,
                              order1 LIKE type_file.chr3,
                              tit    LIKE aag_file.aag02           #FUN-B90023 MOD
                       END RECORD
  DEFINE sc            RECORD azf01  LIKE azf_file.azf01,
                              ccc02  LIKE type_file.chr4,
                              ccc03  LIKE type_file.num5
                       END RECORD
  DEFINE l_title4      LIKE type_file.chr1000  #FUN-D30060

# LET sr.azf01 = l_azf01,'1'      #MOD-B70063 mark
  LET sr.azf01 = l_azf01          #MOD-B70063 add
  LET sr.azf06 = l_azf06
  LET sr.order = '00' #列類品標題
  LET sr.order1 = '00'
  LET sr.title = l_title 
  INITIALIZE sr.amount TO NULL
  INITIALIZE sr.tit TO NULL
  LET l_title4=sr.title,':'    #FUN-D30060
  IF tm.c='N' OR l_title4[1,8]<>'        ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
  EXECUTE insert_prep USING sr.*,l_title4,g_ccz.ccz26 #FUN-D30060 add l_title4,g_ccz.ccz26
  END IF  #FUN-D30060
  
  LET sr.order = '10'  #期初存貨
  LET sr.order1 = '10'
  SELECT SUM(ccc12) INTO sr.amount FROM ccc_file, ima_file
   WHERE ima01 = ccc01 
     AND ima12 = l_azf01
     AND ccc02 = tm.yy
     AND ccc03 = tm.m1
  IF cl_null(sr.amount) THEN LET sr.amount = 0 END IF
  LET sr1[10] = sr.amount
  INITIALIZE sr.tit TO NULL
  LET l_title4=sr.title,cl_gr_getmsg('axc-134',g_lang,sr.order1)   #FUN-D30060
  IF tm.c='N' OR l_title4[1,8]<>'        ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
  EXECUTE insert_prep USING sr.*,l_title4,g_ccz.ccz26 #FUN-D30060 add l_title4,g_ccz.ccz26
  END IF  #FUN-D30060

  LET sr.order = '12'   #本期進貨
  LET sr.order1 = '12'
  SELECT SUM(tlf21) INTO l_amt1 FROM tlf_file, ima_file
   WHERE ima01 = tlf01
     AND ima12 = l_azf01
     AND tlf06 BETWEEN bdate AND edate
     AND (tlf13 = 'apmt150') 
     AND tlf902 NOT IN (SELECT jce02 FROM jce_file)
  IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
  SELECT SUM(ccb22) INTO l_amt2 FROM ccb_file, ima_file
   WHERE ima01 = ccb01
     AND ima12 = l_azf01
     AND ccb02 = tm.yy
     AND ccb03 BETWEEN tm.m1 AND tm.m2
  IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF    
  LET sr.amount = l_amt1 + l_amt2
  LET sr1[12] = sr.amount
  INITIALIZE sr.tit TO NULL
  LET l_title4='   ',cl_gr_getmsg('axc-135',g_lang,'1'),': ',sr.title,cl_gr_getmsg('axc-134',g_lang,sr.order1) #FUN-D30060
  IF tm.c='N' OR l_title4[1,8]<>'        ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
  EXECUTE insert_prep USING sr.*,l_title4,g_ccz.ccz26 #FUN-D30060 add l_title4,g_ccz.ccz26
  END IF  #FUN-D30060

  LET sr.order = '13'   #進貨退回(倉退)
  LET sr.order1 = '13'
  SELECT SUM(tlf21) INTO sr.amount FROM tlf_file, ima_file
   WHERE ima01 = tlf01
     AND ima12 = l_azf01
     AND tlf06 BETWEEN bdate AND edate
     AND tlf13 = 'apmt1072' 
     AND tlf902 NOT IN (SELECT jce02 FROM jce_file)
     AND tlf10 <> 0 
  IF cl_null(sr.amount) THEN LET sr.amount = 0 END IF
  LET sr1[13] = sr.amount
  INITIALIZE sr.tit TO NULL
  LET l_title4='   ',cl_gr_getmsg('axc-135',g_lang,'2'),': ',sr.title,cl_gr_getmsg('axc-134',g_lang,sr.order1) #FUN-D30060
  IF tm.c='N' OR l_title4[1,8]<>'        ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
  EXECUTE insert_prep USING sr.*,l_title4,g_ccz.ccz26 #FUN-D30060 add l_title4,g_ccz.ccz26
  END IF  #FUN-D30060
  
  LET sr.order = '14'  #進貨折讓
  LET sr.order1 = '14'
  SELECT SUM(tlf21) INTO sr.amount FROM tlf_file, ima_file 
   WHERE ima01 = tlf01
     AND ima12 = l_azf01
     AND tlf06 BETWEEN bdate AND edate
     AND tlf13 = 'apmt1072' 
     AND tlf902 NOT IN (SELECT jce02 FROM jce_file)
     AND tlf10 = 0 #倉退數量為0
  IF cl_null(sr.amount) THEN LET sr.amount = 0 END IF
  LET sr1[14] = sr.amount
  INITIALIZE sr.tit TO NULL
  LET l_title4='            ',sr.title,cl_gr_getmsg('axc-134',g_lang,sr.order1) #FUN-D30060
  IF tm.c='N' OR l_title4[1,8]<>'        ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
  EXECUTE insert_prep USING sr.*,l_title4,g_ccz.ccz26 #FUN-D30060 add l_title4,g_ccz.ccz26
  END IF  #FUN-D30060

  LET sr.order = '15'  #進貨余額
  LET sr.order1 = '15'
  LET sr.amount = sr1[12] - sr1[13] - sr1[14]
  IF cl_null(sr.amount) THEN LET sr.amount = 0 END IF
  LET sr1[15]= sr.amount
  INITIALIZE sr.tit TO NULL
  LET l_title4='        ',sr.title,cl_gr_getmsg('axc-134',g_lang,sr.order1) #FUN-D30060
  IF tm.c='N' OR l_title4[1,8]<>'        ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
  EXECUTE insert_prep USING sr.*,l_title4,g_ccz.ccz26 #FUN-D30060 add l_title4,g_ccz.ccz26
  END IF  #FUN-D30060

  LET sr.order = '16'  #在制品轉入(+)
  LET sr.order1 = '16'
  SELECT SUM(-ccg32) INTO sr.amount FROM ccg_file,ima_file
   WHERE ima01 = ccg04 
     AND ima12 = l_azf01
     AND ccg02 = tm.yy
     AND ccg03 BETWEEN tm.m1 AND tm.m2
  IF cl_null(sr.amount) THEN LET sr.amount = 0 END IF
  LET sr1[16] = sr.amount
  INITIALIZE sr.tit TO NULL
  LET l_title4='        ',cl_gr_getmsg('axc-134',g_lang,sr.order1),sr.title #FUN-D30060
  IF tm.c='N' OR l_title4[1,8]<>'       ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
  EXECUTE insert_prep USING sr.*,l_title4,g_ccz.ccz26 #FUN-D30060 add l_title4,g_ccz.ccz26
  END IF  #FUN-D30060
   
  LET sr.order = '39'  #在制品轉出(-)
  LET sr.order1 = '39'
 #MOD-AB0223---mark---start---
 #IF l_azf01 != 'A101' AND l_azf01[1,2] != 'A7' THEN
 #   LET sr1[39] = sr1[39] + sr.amount 
 #   EXECUTE insert_prep USING '9','ZZZZZ',sr.order,sr.other,sr.title,sr.amount,sr.order1,''
 #END IF
 #IF l_azf01 = 'A701' OR l_azf01 = 'A702' THEN 
 #   LET sr2[39] = sr2[39] + sr.amount
 #   EXECUTE insert_prep USING 'd','ZZZZZ',sr.order,sr.other,sr.title,sr.amount,sr.order1,''
 #END IF
 #MOD-AB0223---mark---end---
  #處理借入
  LET sr.order = '16' #在制品轉入(+)
  LET sr.order1 = '22'
  LET sr.amount = 0 
 #SELECT  SUM((NVL(tlf221,0)+NVL(tlf222,0)+NVL(tlf2231,0)+  #MOD-A50164 mark
 #             NVL(tlf2232,0))*NVL(tlf907,0))               #MOD-A50164 mark
  SELECT  SUM(NVL(tlf21,0)*NVL(tlf907,0))                   #MOD-A50164
    INTO  sr.amount
    FROM tlf_file,ima_file 
   WHERE tlf01 = ima01
     AND ima12 = l_azf01
     AND YEAR(tlf06) = tm.yy
     AND tlf06 BETWEEN bdate AND edate 
     AND tlf13 = 'aimt306'
     AND tlf902 NOT IN (SELECT jce02 FROM jce_file)         #CHI-B80021 add
  IF cl_null(sr.amount) THEN LET sr.amount = 0 END IF
  INITIALIZE sr.tit TO NULL
  LET l_title4='        ',sr.title,cl_gr_getmsg('axc-134',g_lang,sr.order1)  #FUN-D30060
  IF tm.c='N' OR l_title4[1,8]<>'        ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
  EXECUTE insert_prep USING sr.*,l_title4,g_ccz.ccz26 #FUN-D30060 add l_title4,g_ccz.ccz26
  END IF  #FUN-D30060

  LET sr1[16] = sr1[16] + sr.amount
 #MOD-AB0223---mark---start---
 #IF l_azf01 = 'TP' THEN 
 #   DISPLAY l_azf01  
 #END IF
 #MOD-AB0223---mark---end---
  LET sr.order = '161'  #在制品轉入(+)
  LET sr.order1 = '161'
  LET sr.amount = 0 
  SELECT SUM(tlf21) INTO sr.amount FROM tlf_file, ima_file 
   WHERE tlf01 = ima01
     AND ima12 = l_azf01
     AND YEAR(tlf06) = tm.yy
     AND tlf06 BETWEEN bdate AND edate #mod Derrick 07041
     AND tlf13 = 'aimp701'
     AND tlf902 NOT IN (SELECT jce02 FROM jce_file)         #CHI-B80021 add
  IF cl_null(sr.amount) THEN LET sr.amount = 0 END IF
  INITIALIZE sr.tit TO NULL
  LET l_title4='        ',sr.title,cl_gr_getmsg('axc-134',g_lang,sr.order1)  #FUN-D30060
  IF tm.c='N' OR l_title4[1,8]<>'        ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
  EXECUTE insert_prep USING sr.*,l_title4,g_ccz.ccz26 #FUN-D30060 add l_title4,g_ccz.ccz26
  END IF  #FUN-D30060

  LET sr1[16] = sr1[16] + sr.amount

  LET sr.order = '17' #成本調整(+)
  LET sr.order1 = '17'
  SELECT SUM(ccc93) INTO sr.amount FROM ccc_file, ima_file
   WHERE ima01 = ccc01 
     AND ima12 = l_azf01
     AND ccc02 = tm.yy
     AND ccc03 BETWEEN tm.m1 AND tm.m2
     AND ccc93 > 0
  IF cl_null(sr.amount) THEN LET sr.amount = 0 END IF
  LET sr1[17] = sr.amount
  INITIALIZE sr.tit TO NULL
  LET l_title4='        ',sr.title,cl_gr_getmsg('axc-134',g_lang,sr.order1)  #FUN-D30060
  IF tm.c='N' OR l_title4[1,8]<>'        ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
  EXECUTE insert_prep USING sr.*,l_title4,g_ccz.ccz26 #FUN-D30060 add l_title4,g_ccz.ccz26
  END IF  #FUN-D30060

  LET sr.order = '18'  #盤盈
  LET sr.order1 = '18'
  SELECT SUM(ccc72) INTO sr.amount FROM ccc_file, ima_file
   WHERE ima01 = ccc01 
     AND ima12 = l_azf01
     AND ccc02 = tm.yy
     AND ccc03 BETWEEN tm.m1 AND tm.m2
     AND ccc72 > 0
  IF cl_null(sr.amount) THEN LET sr.amount = 0 END IF
  LET sr1[18] = sr.amount
  INITIALIZE sr.tit TO NULL
  LET l_title4='        ',sr.title,cl_gr_getmsg('axc-134',g_lang,sr.order1)  #FUN-D30060
  IF tm.c='N' OR l_title4[1,8]<>'        ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
  EXECUTE insert_prep USING sr.*,l_title4,g_ccz.ccz26 #FUN-D30060 add l_title4,g_ccz.ccz26
  END IF  #FUN-D30060

  LET sr.order = '19'  #空白列
  LET sr.order1 = '19'
  INITIALIZE sr.amount TO NULL
  INITIALIZE sr.tit TO NULL
  LET l_title4='  '  #FUN-D30060
 #IF tm.c='N' OR l_title4[1,8]<>'        ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
  EXECUTE insert_prep USING sr.*,l_title4,g_ccz.ccz26 #FUN-D30060 add l_title4,g_ccz.ccz26
 #END IF  #FUN-D30060 
 #str MOD-A50164 mod
 #SELECT SUM((tlf221+tlf222+tlf2231+tlf2232)*tlf907)
 #  INTO l_amt3  FROM tlf_file,smy_file,ima_file
 # WHERE (tlf13 = 'axmt620' OR tlf13 = 'aomt800' OR tlf13 = 'axmt650')
 #   AND tlf905[1,5] = smyslip
 #   AND tlf01 = ima01
 #   AND smy53 = 'Y'
 #   AND (YEAR(tlf06) = tm.yy
 #   AND Month(tlf06) BETWEEN tm.m1 AND tm.m2)
 #   AND ima12=l_azf01
 #---------------CHI-B80085 modify
 # LET l_sql = "SELECT SUM(tlf21*tlf907)",
 #             "  FROM tlf_file,smy_file,ima_file",
 #             " WHERE (tlf13 = 'axmt620' OR tlf13 = 'aomt800' OR tlf13 = 'axmt650')",
 #             "   AND tlf905 LIKE trim(smyslip)||'-%' ",
 #             "   AND tlf01 = ima01",
 #             "   AND smy53 = 'Y'",
 #             "   AND (YEAR(tlf06) = ",tm.yy,
 #             "   AND  Month(tlf06) BETWEEN ",tm.m1," AND ",tm.m2,")",
 #             "   AND ima12='",l_azf01,"'",
 #             "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)"         #CHI-B80021 add
 LET l_sql = "SELECT SUM(tlf21*tlf907)",
              "  FROM tlf_file,azf_file,ima_file",
              " WHERE (tlf13 = 'axmt620' OR tlf13 = 'aomt800' OR tlf13 = 'axmt650')",
              "   AND tlf01 = ima01",
              "  AND tlf14 = azf01 AND azf08 = 'Y' ",
              "   AND (YEAR(tlf06) = ",tm.yy,
              "   AND  Month(tlf06) BETWEEN ",tm.m1," AND ",tm.m2,")",
              "   AND ima12='",l_azf01,"'",
              "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)"         #CHI-B80021 add
 #---------------CHI-B80085 end
  PREPARE x006_p1 FROM l_sql
  EXECUTE x006_p1 INTO l_amt3
 #end MOD-A50164 mod
  IF cl_null(l_amt3) THEN LET l_amt3 = 0 END IF
  LET l_amt3 = l_amt3 * -1

  LET sr.order = '20'
  LET sr.order1 = '20'
 #str MOD-A50164 mod
 #SELECT SUM((tlf221+tlf222+tlf2231+tlf2232)*tlf907)
 #  INTO sr.amount  FROM tlf_file,smy_file,ima_file
 # WHERE (tlf13 = 'axmt620' OR tlf13 = 'aomt800' OR tlf13 = 'axmt650' ) 
 #   AND tlf905[1,5] = smyslip 
 #   AND tlf01 = ima01
 #   AND (smy53 != 'Y' OR smy53 IS NULL)
 #   AND (YEAR(tlf06) = tm.yy
 #   AND Month(tlf06) BETWEEN tm.m1 AND tm.m2)
 #   AND ima12=l_azf01
  LET l_sql = "SELECT SUM(tlf21*tlf907)",
              "  FROM tlf_file,smy_file,ima_file",
              " WHERE (tlf13 = 'axmt620' OR tlf13 = 'aomt800' OR tlf13 = 'axmt650')",
              "   AND tlf905 LIKE trim(smyslip)||'-%' ",
              "   AND tlf01 = ima01",
              "   AND (smy53 != 'Y' OR smy53 IS NULL)",
              "   AND (YEAR(tlf06) = ",tm.yy,
              "   AND  Month(tlf06) BETWEEN ",tm.m1," AND ",tm.m2,")",
              "   AND ima12='",l_azf01,"'",
              "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)"         #CHI-B80021 add
  PREPARE x006_p2 FROM l_sql
  EXECUTE x006_p2 INTO sr.amount
 #end MOD-A50164 mod
  IF cl_null(sr.amount) THEN LET sr.amount = 0 END IF
  LET sr.amount = sr.amount * -1
  LET sr.amount = sr.amount - l_amt3    #CHI-B80085 add
  LET sr1[20] = sr.amount
 #MOD-AB0223---mark---start---
 #IF l_azf01 != 'A101' AND l_azf01 != 'A701' THEN
  INITIALIZE sr.tit TO NULL                #MOD-AC0283 取消mark   
  LET l_title4='   ',cl_gr_getmsg('axc-135',g_lang,'2'),': ',sr.title,cl_gr_getmsg('axc-134',g_lang,sr.order1)  #FUN-D30060
  IF tm.c='N' OR l_title4[1,8]<>'        ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
  EXECUTE insert_prep USING sr.*           #MOD-AC0283 取消mark
                            ,l_title4,g_ccz.ccz26 #FUN-D30060   
  END IF  #FUN-D30060
 #END IF
 #MOD-AB0223---mark---end---
  LET g_ccc62 = g_ccc62 + sr1[20]
  LET g_ccc82 = g_ccc82 + l_amt3     #CHI-B80085 add
	
  LET sr.order1 = '91'
  LET l_title4='  ',sr.title,cl_gr_getmsg('axc-134',g_lang,sr.order1)  #FUN-D30060
  IF tm.c='N' OR l_title4[1,8]<>'       ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
 #EXECUTE insert_prep USING 'y','ZZZZZ','91','',sr.title,sr.amount,sr.order1,''   #FUN-D30060
  EXECUTE insert_prep USING '100','ZZZZZ','91','',sr.title,sr.amount,sr.order1,''   #FUN-D30060
                            ,l_title4,g_ccz.ccz26 #FUN-D30060
  END IF  #FUN-D30060
  #---------------CHI-B80085 modify
  LET sr.order1 = '92'
  LET l_title4='  ',sr.title,cl_gr_getmsg('axc-134',g_lang,sr.order1)  #FUN-D30060
  IF tm.c='N' OR l_title4[1,8]<>'        ' OR (tm.c='Y' AND l_amt3<> 0) THEN #FUN-D30060
 #EXECUTE insert_prep USING 'y','ZZZZZ','92','',sr.title,l_amt3,sr.order1,''   #FUN-D30060
  EXECUTE insert_prep USING '100','ZZZZZ','92','',sr.title,l_amt3,sr.order1,''   #FUN-D30060 
                            ,l_title4,g_ccz.ccz26 #FUN-D30060
  END IF  #FUN-D30060
 #---------------CHI-B80085 end
  LET sr.order = '21'
  LET sr.order1 = '21'
  LET sr.amount = l_amt3
  LET sr1[21] = sr.amount
  INITIALIZE sr.tit TO NULL
  LET l_title4='        ',sr.title,cl_gr_getmsg('axc-134',g_lang,sr.order1)  #FUN-D30060
  IF tm.c='N' OR l_title4[1,8]<>'        ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
  EXECUTE insert_prep USING sr.*,l_title4,g_ccz.ccz26 #FUN-D30060 add l_title4,g_ccz.ccz26
  END IF  #FUN-D30060

 #LET sr.order = '36'         #MOD-B10212 mark 
  LET sr.order = '29'         #MOD-B10212 add   #'xx-本期耗用'應該於期末存貨前顯示 
  LET sr.order1 = '36'  		
  SELECT SUM(cch22) INTO sr.amount FROM cch_file, ima_file
   WHERE cch04 = ima01
     AND cch04 != ' DL+OH+SUB' AND cch04 != ' ADJUST'    #MOD-AB0223 mark  #TQC-AB0089 取消mark
     AND ima12 = l_azf01
     AND cch02 = tm.yy
     AND cch03 BETWEEN tm.m1 AND tm.m2
  IF cl_null(sr.amount) THEN LET sr.amount = 0 END IF

  LET l_ccuwip = 0
  IF cl_null(l_ccuwip) THEN LET l_ccuwip = 0 END IF
  LET sr.amount = sr.amount + l_ccuwip

  LET sr1[22] = sr.amount
 #MOD-AB0223---mark---start---
 #IF l_azf01[1,2] != 'A1' AND l_azf01 != 'A701' THEN
  INITIALIZE sr.tit TO NULL             #MOD-AC0283 取消mark   
  LET l_title4=sr.title,cl_gr_getmsg('axc-134',g_lang,sr.order1)  #FUN-D30060
  IF tm.c='N' OR l_title4[1,8]<>'       ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
  EXECUTE insert_prep USING sr.*        #MOD-AC0283 取消mark   
                           ,l_title4,g_ccz.ccz26 #FUN-D30060 
  END IF  #FUN-D30060
 #END IF
 #MOD-AB0223---mark---end---
  LET l_ccl22 = 0
  SELECT SUM(ccl22) INTO l_ccl22 FROM ccl_file,sfb_file,ima_file
   WHERE ccl01 = sfb01 AND sfb05 = ima01
     AND ima12 = l_azf01
     AND ccl02 = tm.yy
     AND ccl03 BETWEEN tm.m1 AND tm.m2     
  IF cl_null(l_ccl22) THEN LET l_ccl22 = 0 END IF
  LET sr.amount = sr.amount + l_ccl22
  #--

  LET sr.order = '36'   #轉入在制品(+)
  LET sr.order1 = '01'
 #MOD-AB0223---mark---start---
 #IF sr.azf01[1,2] ='A1' THEN
 #   LET sr1[36] = sr1[36] + sr.amount  #成品轉入在制
 #   EXECUTE insert_prep USING '9','ZZZZZ',sr.order,sr.other,sr.title,sr.amount,sr.order1,''
 #END IF
 #IF sr.azf01 = 'A701' THEN   #模具成品轉入在制
 #   LET sr2[36] = sr2[36] + sr.amount
 #   EXECUTE insert_prep USING 'd','ZZZZZ',sr.order,sr.other,sr.title,sr.amount,sr.order1,''
 #END IF
 #MOD-AB0223---mark---end---
  LET sr.order = '24'  #轉列費用(雜發+雜收)
  LET l_amt    = 0
  LET sc.azf01 = l_azf01
  LET sc.ccc02 = tm.yy
  LET sc.ccc03 = tm.m1
# SELECT azf06 INTO sr.azf06 FROM azf_file WHERE azf01 = sr.azf01                         #MOD-B70063 mark
  SELECT azf06 INTO sr.azf06 FROM azf_file WHERE azf01 = sr.azf01 AND azf02 = '1'         #MOD-B70063 add
  LET l_sql = "SELECT distinct(cxi04), ",
             #"   SUM((NVL(tlf221,0)+NVL(tlf222,0)+NVL(tlf2231,0)+NVL(tlf2232,0))*NVL(tlf907,0)) * -1 ",  #MOD-A50164 mark
              "   SUM(NVL(tlf21,0)*NVL(tlf907,0)) * -1 ",                                                 #MOD-A50164
              "  FROM tlf_file,ima_file,OUTER cxi_file ",  #MOD-A50196 mod
              " WHERE tlf01 = ima01 AND ima12= '",sc.azf01 ,"'",
              "   AND (YEAR(tlf06) = '",tm.yy,"'" ,
              "   AND Month(tlf06)>=",tm.m1," AND Month(tlf06)<=",tm.m2," )", 
              "   AND tlf19 = cxi_file.cxi01 AND tlf14 = cxi_file.cxi02 ",  #MOD-A50196 mod
               "   AND cxi_file.cxi03 ='2' ",                                              #No:MOD-B60051 add
              "   AND tlf13 IN ('aimt301','aimt311','aimt303','aimt313')",       #No:MOD-B60051 modify
              "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file) ", 
              " GROUP BY cxi04"
  PREPARE t370_curs1 FROM l_sql
  DECLARE t370_pre1 CURSOR FOR t370_curs1
  FOREACH t370_pre1 INTO sr.other,sr.amount
     CALL s_get_bookno(tm.yy)  RETURNING g_flag,g_bookno1,g_bookno2  #FUN-C10024				
     LET sr.order1 = '02'
     SELECT aag02 INTO sr.tit FROM aag_file
      WHERE aag01 = sr.other
        AND aag00 = g_bookno1    #FUN-C10024
     LET l_title4='        ',sr.title,sr.tit,cl_gr_getmsg('axc-134',g_lang,sr.order1) #FUN-D30060
     IF tm.c='N' OR l_title4[1,8]<>'        ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
     EXECUTE insert_prep USING sr.*,l_title4,g_ccz.ccz26 #FUN-D30060 add l_title4,g_ccz.ccz26
     END IF  #FUN-D30060 
     LET l_amt = l_amt + sr.amount
  END FOREACH
  #------------------------------------No:MOD-B60051 add
  #雜收費用
   LET l_sql = "SELECT distinct(cxi04), ",
               "   SUM((NVL(tlf221,0)+NVL(tlf222,0)+NVL(tlf2231,0)+NVL(tlf2232,0))*NVL(tlf907,0)) * -1 ",  
               "  FROM tlf_file,OUTER cxi_file,ima_file ",  
               " WHERE tlf01 = ima01 AND ima12= '",sc.azf01 ,"'",
               "   AND (YEAR(tlf06) = '",tm.yy,"'" ,
               "   AND Month(tlf06)>=",tm.m1," AND Month(tlf06)<=",tm.m2," )", 
               "   AND cxi_file.cxi01 = tlf19 AND cxi_file.cxi02 = tlf14 ",
               "   AND cxi_file.cxi03 ='1' ",                        
               "   AND tlf13 IN ('aimt302','aimt312')",   
               "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file) ", 
               " GROUP BY cxi04"
   PREPARE t370_curs11 FROM l_sql
   DECLARE t370_pre11 CURSOR FOR t370_curs11
   FOREACH t370_pre11 INTO sr.other,sr.amount
      LET sr.order1 = '02'
      CALL s_get_bookno(tm.yy)  RETURNING g_flag,g_bookno1,g_bookno2  #FUN-C10024
      SELECT aag02 INTO sr.tit FROM aag_file
       WHERE aag01 = sr.other
         AND aag00 = g_bookno1    #FUN-C10024
      LET l_title4='        ',sr.title,sr.tit,cl_gr_getmsg('axc-134',g_lang,sr.order1) #FUN-D30060
      IF tm.c='N' OR l_title4[1,8]<>'        ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
      EXECUTE insert_prep USING sr.*,l_title4,g_ccz.ccz26 #FUN-D30060 add l_title4,g_ccz.ccz26
      END IF  #FUN-D30060
      LET l_amt = l_amt + sr.amount
   END FOREACH
  #------------------------------------No:MOD-B60051 end
  LET sr.order1 = '03'
  LET sr.amount = 0 
 #SELECT  SUM((NVL(tlf221,0)+NVL(tlf222,0)+NVL(tlf2231,0)+  #MOD-A50164 mark
 #             NVL(tlf2232,0)))                             #MOD-A50164 mark
  SELECT  SUM(NVL(tlf21,0))                                 #MOD-A50164
          INTO sr.amount
    FROM tlf_file,ima_file 
   WHERE tlf01 = ima01
     AND ima12 = sc.azf01
     AND YEAR(tlf06) = tm.yy
     AND tlf06 BETWEEN bdate AND edate  
     AND tlf13 = 'aimt309'
     AND tlf902 NOT IN (SELECT jce02 FROM jce_file)         #CHI-B80021 add
  IF cl_null(sr.amount) THEN LET sr.amount = 0 END IF
  INITIALIZE sr.tit TO NULL
  LET l_title4='        ',sr.title,cl_gr_getmsg('axc-134',g_lang,sr.order1) #FUN-D30060
  IF tm.c='N' OR l_title4[1,8]<>'        ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
  EXECUTE insert_prep USING sr.*,l_title4,g_ccz.ccz26 #FUN-D30060 add l_title4,g_ccz.ccz26
  END IF  #FUN-D30060
  LET l_amt = l_amt + sr.amount 
  #CHI-A70057 add --start--
  LET sr.order1 = '021'
  LET sr.amount = 0
  SELECT  SUM(NVL(tlf21,0))
          INTO sr.amount
    FROM tlf_file,ima_file 
   WHERE tlf01 = ima01
     AND ima12 = sc.azf01
     AND YEAR(tlf06) = tm.yy
     AND tlf06 BETWEEN bdate AND edate  
     AND tlf13 = 'atmt260'
     AND tlf902 NOT IN (SELECT jce02 FROM jce_file)         #CHI-B80021 add
  IF cl_null(sr.amount) THEN LET sr.amount = 0 END IF
  INITIALIZE sr.tit TO NULL
  LET l_title4='        ',sr.title,sr.tit,cl_gr_getmsg('axc-134',g_lang,sr.order1) #FUN-D30060
  IF tm.c='N' OR l_title4[1,8]<>'        ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
  EXECUTE insert_prep USING sr.*,l_title4,g_ccz.ccz26 #FUN-D30060 add l_title4,g_ccz.ccz26
  END IF  #FUN-D30060
  LET l_amt = l_amt + sr.amount 
  LET sr.order1 = '022'
  LET sr.amount = 0
  SELECT  SUM(NVL(tlf21,0))
          INTO sr.amount
    FROM tlf_file,ima_file 
   WHERE tlf01 = ima01
     AND ima12 = sc.azf01
     AND YEAR(tlf06) = tm.yy
     AND tlf06 BETWEEN bdate AND edate  
     AND tlf13 = 'atmt261'
     AND tlf902 NOT IN (SELECT jce02 FROM jce_file)         #CHI-B80021 add
  IF cl_null(sr.amount) THEN LET sr.amount = 0 END IF
  INITIALIZE sr.tit TO NULL
  LET l_title4='        ',sr.title,sr.tit,cl_gr_getmsg('axc-134',g_lang,sr.order1) #FUN-D30060
  IF tm.c='N' OR l_title4[1,8]<>'        ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
  EXECUTE insert_prep USING sr.*,l_title4,g_ccz.ccz26 #FUN-D30060 add l_title4,g_ccz.ccz26
  END IF  #FUN-D30060
  LET l_amt = l_amt + sr.amount 
  #CHI-A70057 add --end--
  LET sr1[24] = l_amt

  LET sr.amount = 0 
  LET sr.order = '241' 
  LET sr.order1 = '241'
  SELECT SUM(tlf21) INTO sr.amount FROM tlf_file, ima_file     
   WHERE tlf01 = ima01
     AND ima12 = sc.azf01
     AND YEAR(tlf06) = tm.yy
     AND tlf06 BETWEEN bdate AND edate 
     AND tlf13 = 'aimp700'
     AND tlf902 NOT IN (SELECT jce02 FROM jce_file)         #CHI-B80021 add
  IF cl_null(sr.amount) THEN LET sr.amount = 0 END IF
  INITIALIZE sr.tit TO NULL
  LET l_title4='        ',sr.title,cl_gr_getmsg('axc-134',g_lang,sr.order1) #FUN-D30060
  IF tm.c='N' OR l_title4[1,8]<>'        ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
  EXECUTE insert_prep USING sr.*,l_title4,g_ccz.ccz26 #FUN-D30060 add l_title4,g_ccz.ccz26
  END IF  #FUN-D30060
  LET l_amt = l_amt + sr.amount 
  LET sr1[24] = l_amt

  LET sr.order = '25'    #成本調整(-1)
  LET sr.order1 = '25'
  SELECT SUM(ccc93*-1) INTO sr.amount FROM ccc_file, ima_file
   WHERE ima01 = ccc01 
     AND ima12 = l_azf01
     AND ccc02 = tm.yy
     AND ccc03 BETWEEN tm.m1 AND tm.m2
     AND ccc93 < 0 
  IF cl_null(sr.amount) THEN LET sr.amount = 0 END IF
  LET sr1[25] = sr.amount
  INITIALIZE sr.tit TO NULL
  LET l_title4='        ',sr.title,cl_gr_getmsg('axc-134',g_lang,sr.order1) #FUN-D30060
  IF tm.c='N' OR l_title4[1,8]<>'        ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
  EXECUTE insert_prep USING sr.*,l_title4,g_ccz.ccz26 #FUN-D30060 add l_title4,g_ccz.ccz26
  END IF  #FUN-D30060

  LET sr.order = '26'   #盤虧
  LET sr.order1 = '26'
  SELECT SUM(ccc72*-1) INTO sr.amount FROM ccc_file, ima_file
   WHERE ima01 = ccc01 
     AND ima12 = l_azf01
     AND ccc02 = tm.yy
     AND ccc03 BETWEEN tm.m1 AND tm.m2
     AND ccc72 < 0
  IF cl_null(sr.amount) THEN LET sr.amount = 0 END IF
  LET sr1[26] = sr.amount
  INITIALIZE sr.tit TO NULL
  LET l_title4='        ',sr.title,cl_gr_getmsg('axc-134',g_lang,sr.order1) #FUN-D30060
  IF tm.c='N' OR l_title4[1,8]<>'        ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
  EXECUTE insert_prep USING sr.*,l_title4,g_ccz.ccz26 #FUN-D30060 add l_title4,g_ccz.ccz26
  END IF  #FUN-D30060

 #期末存貨(用計算的)30=10+15++16+17+18-20-21-22-24-25-26
  LET sr.order = '30'
  LET sr.order1 = '30'
  LET sr.amount = sr1[10] + sr1[15] + sr1[16] + sr1[17] + sr1[18]
                - sr1[20] - sr1[21] - sr1[22] - sr1[24] - sr1[25] - sr1[26]
  IF cl_null(sr.amount) THEN LET sr.amount = 0 END IF
  LET sr1[30] = sr.amount
  INITIALIZE sr.tit TO NULL
  LET l_title4=sr.title,':',cl_gr_getmsg('axc-134',g_lang,sr.order1) #FUN-D30060
  IF tm.c='N' OR l_title4[1,8]<>'        ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
  EXECUTE insert_prep USING sr.*,l_title4,g_ccz.ccz26 #FUN-D30060 add l_title4,g_ccz.ccz26
  END IF  #FUN-D30060
END FUNCTION

FUNCTION r002_wip(l_azf06,l_azf01,l_title)  #在制成本
  DEFINE l_n,l_a,l_b   LIKE type_file.num5
 #DEFINE l_azf06       LIKE type_file.chr1  #FUN-D30060
  DEFINE l_azf06       LIKE azf_file.azf06  #FUN-D30060
  DEFINE l_azf01       LIKE azf_file.azf01
  DEFINE l_azf03       LIKE azf_file.azf03       #MOD-B10212 add
  DEFINE l_title       LIKE type_file.chr100
  DEFINE l_sql         STRING
  DEFINE l_amount      LIKE tlf_file.tlf21
  DEFINE l_adj_amt     LIKE tlf_file.tlf21   #No:CHI-B80040 add
  DEFINE l_ccuwip      LIKE tlf_file.tlf21
  DEFINE l_pcost       LIKE tlf_file.tlf21
  DEFINE l_bwip	       LIKE tlf_file.tlf21
  DEFINE l_amt1,l_amt2 LIKE tlf_file.tlf21
  DEFINE l_amt ,l_amt3 LIKE tlf_file.tlf21
 #DEFINE sr            RECORD azf06    LIKE type_file.chr1,  #FUN-D30060
  DEFINE sr            RECORD azf06    LIKE azf_file.azf06,  #FUN-D30060
                              azf01    LIKE azf_file.azf01, 
                              order    LIKE type_file.chr3,
                              other    LIKE type_file.chr100,   
                              title    LIKE type_file.chr100,
                              amount   LIKE tlf_file.tlf21, 
                              order1   LIKE type_file.chr3,
                              tit      LIKE aag_file.aag02           #FUN-B90023 MOD
                       END RECORD
  DEFINE cch	       RECORD cch22    LIKE cch_file.cch22,
		              cch22b   LIKE cch_file.cch22b,
		              cch22c   LIKE cch_file.cch22c,
		              cch22d   LIKE cch_file.cch22d
		       END RECORD  
   DEFINE l_title4  LIKE type_file.chr1000  #FUN-D30060

  LET sr.azf06 = l_azf06
  LET sr.azf01 = l_azf01
    
  INITIALIZE sr.amount TO NULL
  LET l_pcost  = 0
  LET l_bwip 	 = 0
  LET l_ccuwip = 0	
  LET sr.title = l_title		
	
 #IF sr.azf06 = '9' THEN  #制成品--制造成本 #FUN-D30060
  IF sr.azf06 = 9 THEN  #制成品--制造成本   #FUN-D30060
     SELECT SUM(cch22) INTO cch.cch22
      FROM cch_file, ima_file
     WHERE cch04 = ima01
       AND cch04 != ' DL+OH+SUB' AND cch04 != ' ADJUST'         #MOD-AB0223 mark     #TQC-AB0089 取消mark
       AND cch02 = tm.yy
       AND cch03 BETWEEN tm.m1 AND tm.m2
      #AND cch01[2,5] NOT BETWEEN '4019' AND '401F'             #MOD-AB0223 mark
      #AND ima12 NOT IN ('A101','A701')                         #MOD-AB0223 mark
  
    #SELECT SUM(cch22b),SUM(cch22c),SUM(cch22d)                                                  #MOD-A50196 mark
     SELECT SUM(cch22b),SUM(cch22c)+SUM(cch22e)+SUM(cch22f)+SUM(cch22g)+SUM(cch22h),SUM(cch22d)  #MOD-A50196
       INTO cch.cch22b,cch.cch22c,cch.cch22d
       FROM cch_file
      WHERE cch04 =' DL+OH+SUB'                          #MOD-AB0223 mark  #TQC-AB0089 取消mark 
        AND cch02 = tm.yy                                #MOD-AB0223 mark  #TQC-AB0089 取消mark  
     #WHERE cch02 = tm.yy                                #MOD-AB0223 add   #TQC-AB0089 mark 
	AND cch03 BETWEEN tm.m1 AND tm.m2
     #  AND cch01[2,5] NOT BETWEEN '4019' AND '401F'     #MOD-AB0223 mark
 
  ELSE   #模具--制造成本
     SELECT SUM(cch22) INTO cch.cch22
       FROM cch_file, ima_file
      WHERE cch04 = ima01
        AND cch04 != ' DL+OH+SUB' AND cch04 != ' ADJUST'  #MOD-AB0223 mark  #TQC-AB0089 取消mark
        AND cch02 = tm.yy
        AND cch03 BETWEEN tm.m1 AND tm.m2
       #AND cch01[2,5] BETWEEN '4019' AND '401F'          #MOD-AB0223 mark
       #AND ima12 NOT IN ('A101','A701')                  #MOD-AB0223 mark
	
    #SELECT SUM(cch22b),SUM(cch22c),SUM(cch22d)                                                  #MOD-A50196 mark
     SELECT SUM(cch22b),SUM(cch22c)+SUM(cch22e)+SUM(cch22f)+SUM(cch22g)+SUM(cch22h),SUM(cch22d)  #MOD-A50196
       INTO cch.cch22b,cch.cch22c,cch.cch22d
       FROM cch_file
      WHERE cch04 =' DL+OH+SUB'                          #MOD-AB0223 mark    #TQC-AB0089 取消mark  
        AND cch02 = tm.yy                                #MOD-AB0223 mark    #TQC-AB0089 取消mark   
     #WHERE cch02 = tm.yy                                #MOD-AB0223 add     #TQC-AB0089 mark  
	AND cch03 BETWEEN tm.m1 AND tm.m2
       #AND cch01[2,5] BETWEEN '4019' AND '401F'         #MOD-AB0223 mark
  END IF
	
  LET sr.order = '00'  #本期耗用原物料
  LET sr.order1 = '04'

  LET l_ccuwip = 0
  SELECT SUM(ccu22+ccu32) INTO l_ccuwip FROM ccu_file, ima_file
   WHERE ccu04 = ima01
     AND ccu04 != ' DL+OH+SUB' AND ccu04 != ' ADJUST'    #MOD-AB0223 mark   #TQC-AB0089 del mark 
     AND ima12 = l_azf01
     AND ccu02 = tm.yy
     AND ccu03 BETWEEN tm.m1 AND tm.m2
    #AND ima12 NOT IN ('A101','A701')                    #MOD-AB0223 mark
  IF cl_null(l_ccuwip) THEN LET l_ccuwip = 0 END IF
  LET sr.amount = sr.amount + l_ccuwip
	
  IF cl_null(cch.cch22 + l_ccuwip) THEN 
     LET sr.amount = 0 
  ELSE
     LET sr.amount = cch.cch22 + l_ccuwip
  END IF
		
  IF cl_null(l_ccuwip) THEN LET l_ccuwip = 0 END IF
  LET sr.amount = sr.amount + l_ccuwip
  LET l_pcost = sr.amount
  INITIALIZE sr.tit TO NULL
  LET l_title4='        ',cl_gr_getmsg('axc-134',g_lang,sr.order1) #FUN-D30060
  IF tm.c='N' OR l_title4[1,8]<>'        ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
  EXECUTE insert_prep USING sr.*,l_title4,g_ccz.ccz26 #FUN-D30060 add l_title4,g_ccz.ccz26
  END IF  #FUN-D30060

 #----------No:CHI-B80040 add
 #再製調整金額
  LET l_adj_amt = 0
  SELECT SUM(cch22a+cch22b+cch22c+cch22d+cch22e+cch22f+cch22g+cch22h)
    INTO l_adj_amt
    FROM cch_file
   WHERE cch04 = ' ADJUST'
     AND cch02 = tm.yy
     AND cch03 BETWEEN tm.m1 AND tm.m2

  IF cl_null(l_adj_amt) THEN LET l_adj_amt = 0 END IF

  LET sr.order = '34'
  LET sr.order1 = '11'
  LET sr.amount = l_adj_amt
  LET l_pcost = l_pcost + sr.amount
  IF sr.amount < 0 THEN
     LET sr.order = '42'
     LET sr.order1 = '11'
     LET sr.amount = sr.amount * -1
  END IF
  INITIALIZE sr.tit TO NULL
  LET l_title4='        ',cl_gr_getmsg('axc-134',g_lang,sr.order1) #FUN-D30060
  IF tm.c='N' OR l_title4[1,8]<>'        ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
  EXECUTE insert_prep USING sr.*,l_title4,g_ccz.ccz26  #FUN-D30060 add l_title4,g_ccz.ccz26
  END IF  #FUN-D30060
 #----------No:CHI-B80040 end

  		
 #LET sr.order = '01'  #直接人工      #MOD-B10212 mark
  LET sr.order = '31'                 #MOD-B10212 add     #直接人工應顯示於在製品加項的區段內
  LET sr.order1 = '05'
  IF cl_null(cch.cch22b) THEN 
     LET sr.amount = 0 
  ELSE
     LET sr.amount = cch.cch22b
  END IF
  LET l_pcost = l_pcost + sr.amount
  INITIALIZE sr.tit TO NULL
  LET l_title4='        ',cl_gr_getmsg('axc-134',g_lang,sr.order1) #FUN-D30060
  IF tm.c='N' OR l_title4[1,8]<>'        ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
  EXECUTE insert_prep USING sr.*,l_title4,g_ccz.ccz26  #FUN-D30060 add l_title4,g_ccz.ccz26
  END IF  #FUN-D30060

 #LET sr.order = '02'  #制造費用     #MOD-B10212 mark
  LET sr.order = '32'                #MOD-B10212 add    #製造費用應顯示於在製品加項的區段內
  LET sr.order1 = '06'
  IF cl_null(cch.cch22c) THEN 
     LET sr.amount = 0 
  ELSE
     LET sr.amount = cch.cch22c
  END IF
  LET l_pcost = l_pcost + sr.amount
  INITIALIZE sr.tit TO NULL
  LET l_title4='        ',cl_gr_getmsg('axc-134',g_lang,sr.order1) #FUN-D30060
  IF tm.c='N' OR l_title4[1,8]<>'        ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
  EXECUTE insert_prep USING sr.*,l_title4,g_ccz.ccz26  #FUN-D30060 add l_title4,g_ccz.ccz26
  END IF  #FUN-D30060
	  
 #LET sr.order = '03'  #委外加工費     #MOD-B10212 mark
  LET sr.order = '33'                  #MOD-B10212 add   #委外加工費應顯示於在製品加項的區段內 
  LET sr.order1 = '07'
  IF cl_null(cch.cch22d) THEN 
     LET sr.amount = 0 
  ELSE
     LET sr.amount = cch.cch22d
  END IF
  LET l_pcost = l_pcost + sr.amount
  INITIALIZE sr.tit TO NULL
  LET l_title4='        ',cl_gr_getmsg('axc-134',g_lang,sr.order1) #FUN-D30060
  IF tm.c='N' OR l_title4[1,8]<>'        ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
  EXECUTE insert_prep USING sr.*,l_title4,g_ccz.ccz26  #FUN-D30060 add l_title4,g_ccz.ccz26
  END IF  #FUN-D30060
	
  LET sr.order = '10'#列印標題
  LET sr.order1 = '08'
  LET sr.amount = l_pcost
  INITIALIZE sr.amount TO NULL     #MOD-B10212 add
  INITIALIZE sr.tit TO NULL
  LET l_title4=sr.title,':' #FUN-D30060
  IF tm.c='N' OR l_title4[1,8]<>'        ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
  EXECUTE insert_prep USING sr.*,l_title4,g_ccz.ccz26  #FUN-D30060 add l_title4,g_ccz.ccz26
  END IF  #FUN-D30060
			
  LET sr.order = '20' #期初在制品
  LET sr.order1 = '09'
 #IF sr.azf06 = '9' THEN  #制成品--制造成本  #FUN-D30060
  IF sr.azf06 = 9 THEN  #制成品--制造成本  #FUN-D30060
     SELECT SUM(ccg12) INTO sr.amount FROM ccg_file
      WHERE ccg02 = tm.yy
        AND ccg03 = tm.m1
       #AND ccg01[2,5] NOT BETWEEN '4019' AND '401F'     #MOD-AB0223 mark
  ELSE                    #制成品--模具
     SELECT SUM(ccg12) INTO sr.amount FROM ccg_file
      WHERE ccg02 = tm.yy
        AND ccg03 = tm.m1
       #AND ccg01[2,5] BETWEEN '4019' AND '401F'         #MOD-AB0223 mark
  END IF
  LET l_bwip = sr.amount
  IF cl_null(sr.amount) THEN LET sr.amount = 0 END IF
  INITIALIZE sr.tit TO NULL
  LET l_title4=cl_gr_getmsg('axc-134',g_lang,sr.order1) #FUN-D30060
  IF tm.c='N' OR l_title4[1,8]<>'        ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
  EXECUTE insert_prep USING sr.*,l_title4,g_ccz.ccz26  #FUN-D30060 add l_title4,g_ccz.ccz26
  END IF  #FUN-D30060
	
  LET sr.order = '30'  #加：空白列
  LET sr.order1 = '31'
  INITIALIZE sr.amount TO NULL
  INITIALIZE sr.tit TO NULL
  LET l_title4='   ',cl_gr_getmsg('axc-135',g_lang,'1'),':' #FUN-D30060
  IF tm.c='N' OR l_title4[1,8]<>'        ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
  EXECUTE insert_prep USING sr.*,l_title4,g_ccz.ccz26  #FUN-D30060 add l_title4,g_ccz.ccz26
  END IF  #FUN-D30060
 #MOD-B10212---add---start---
  FOREACH axcx006_curs1 INTO l_azf06,l_azf01,l_azf03
    IF l_azf06 IS NULL THEN CONTINUE FOREACH END IF
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
    LET sr.order = '36'       #在製品轉入 
    LET sr.order1 = '16'
    LET sr.title = l_azf03
    SELECT SUM(cch22) INTO sr.amount FROM cch_file, ima_file
     WHERE cch04 = ima01
       AND cch04 != ' DL+OH+SUB' AND cch04 != ' ADJUST'
       AND ima12 = l_azf01
       AND cch02 = tm.yy
       AND cch03 BETWEEN tm.m1 AND tm.m2
    IF cl_null(sr.amount) THEN LET sr.amount = 0 END IF
    INITIALIZE sr.tit TO NULL
    LET l_title4='        ',cl_gr_getmsg('axc-134',g_lang,sr.order1),sr.title #FUN-D30060
    IF tm.c='N' OR l_title4[1,8]<>'        ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
    EXECUTE insert_prep USING sr.*,l_title4,g_ccz.ccz26  #FUN-D30060 add l_title4,g_ccz.ccz26
    END IF  #FUN-D30060
  END FOREACH
 #MOD-B10212---add---end---
  LET sr.order = '37' #在制品--盤盈
  LET sr.order1 = '37'
  LET sr.amount = 0
  INITIALIZE sr.tit TO NULL
  LET l_title4='        ',cl_gr_getmsg('axc-134',g_lang,sr.order1) #FUN-D30060
  IF tm.c='N' OR l_title4[1,8]<>'        ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
  EXECUTE insert_prep USING sr.*,l_title4,g_ccz.ccz26  #FUN-D30060 add l_title4,g_ccz.ccz26
  END IF  #FUN-D30060
	
  LET sr.order = '38' #減：空白列
  LET sr.order1 = '38'
  INITIALIZE sr.amount TO NULL
  INITIALIZE sr.tit TO NULL
  LET l_title4='   ',cl_gr_getmsg('axc-135',g_lang,'2'),':' #FUN-D30060
  IF tm.c='N' OR l_title4[1,8]<>'        ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
  EXECUTE insert_prep USING sr.*,l_title4,g_ccz.ccz26  #FUN-D30060 add l_title4,g_ccz.ccz26
  END IF  #FUN-D30060
    
  LET sr.order = '40'  #在制品--盤虧
  LET sr.order1 = '40'
  LET sr.amount = 0
  INITIALIZE sr.tit TO NULL
  LET l_title4='        ',cl_gr_getmsg('axc-134',g_lang,sr.order1) #FUN-D30060
  IF tm.c='N' OR l_title4[1,8]<>'        ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
  EXECUTE insert_prep USING sr.*,l_title4,g_ccz.ccz26  #FUN-D30060 add l_title4,g_ccz.ccz26
  END IF  #FUN-D30060
 #MOD-B10212---add---start---
  FOREACH axcx006_curs1 INTO l_azf06,l_azf01,l_azf03
    IF l_azf06 IS NULL THEN CONTINUE FOREACH END IF
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
    LET sr.order = '41'   #在製品轉出 
    LET sr.order1 = '39'
    LET sr.title = l_azf03
    SELECT SUM(-ccg32) INTO sr.amount FROM ccg_file,ima_file
     WHERE ima01 = ccg04
       AND ima12 = l_azf01
       AND ccg02 = tm.yy
       AND ccg03 BETWEEN tm.m1 AND tm.m2
    IF cl_null(sr.amount) THEN LET sr.amount = 0 END IF
    INITIALIZE sr.tit TO NULL
    LET l_title4='        ',cl_gr_getmsg('axc-134',g_lang,sr.order1),sr.title #FUN-D30060
    IF tm.c='N' OR l_title4[1,8]<>'        ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
    EXECUTE insert_prep USING sr.*,l_title4,g_ccz.ccz26  #FUN-D30060 add l_title4,g_ccz.ccz26
    END IF  #FUN-D30060
  END FOREACH
 #MOD-B10212---add---end---	
  LET sr.order = '50' #在制品--差異轉出
  LET sr.order1 = '50'
  LET sr.amount = 0
 #MOD-C40071 str mark-----
 #整段mark的原因是pkg中沒有azf06=9
 #IF sr.azf06 = '9' THEN #制成品--制造成本
 #   SELECT SUM(ccu42*-1) INTO sr.amount FROM ccu_file
 #    WHERE ccu02 = tm.yy
 #      AND ccu03 BETWEEN tm.m1 AND tm.m2
 #     #AND ccu01[2,5] NOT BETWEEN '4019' AND '401F'        #MOD-AB0223 mark
 #ELSE     #制成品--模具
 #   SELECT SUM(ccu42*-1) INTO sr.amount FROM ccu_file
 #    WHERE ccu02 = tm.yy
 #      AND ccu03 BETWEEN tm.m1 AND tm.m2
 #     #AND ccu01[2,5] BETWEEN '4019' AND '401F'            #MOD-AB0223 mark
 #END IF
 #MOD-C40071 end mark-----
 #MOD-C40071 str add------
  SELECT SUM(ccg42*-1) INTO sr.amount FROM ccg_file
   WHERE ccg02 = tm.yy
     AND ccg03 BETWEEN tm.m1 AND tm.m2
 #MOD-C40071 end add------ 
  IF cl_null(sr.amount) THEN LET sr.amount = 0 END IF
  INITIALIZE sr.tit TO NULL
  LET l_title4='        ',cl_gr_getmsg('axc-134',g_lang,sr.order1) #FUN-D30060
  IF tm.c='N' OR l_title4[1,8]<>'        ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
  EXECUTE insert_prep USING sr.*,l_title4,g_ccz.ccz26  #FUN-D30060 add l_title4,g_ccz.ccz26
  END IF  #FUN-D30060

  LET sr.order = '60' #期末在制品
  LET sr.order1 = '60'
 #IF sr.azf06 = '9' THEN #制成品--制造成本  #FUN-D30060
  IF sr.azf06 = 9 THEN #制成品--制造成本  #FUN-D30060
     SELECT SUM(ccg92) INTO sr.amount FROM ccg_file
      WHERE ccg02 = tm.yy
        AND ccg03 = tm.m2
       #AND ccg01[2,5] NOT BETWEEN '4019' AND '401F'      #MOD-AB0223 mark
    #MOD-AA0070---mark---start---		
    #LET l_ccuwip = 0
    #SELECT SUM(ccu92) INTO l_ccuwip FROM ccu_file
    # WHERE ccu02 = tm.yy
    #   AND ccu03 = tm.m2
    #   AND ccu01[2,5] NOT BETWEEN '4019' AND '401F'
    #MOD-AA0070---mark---end---
  ELSE     #制成品--模具
     SELECT SUM(ccg92) INTO sr.amount FROM ccg_file
      WHERE ccg02 = tm.yy
        AND ccg03 = tm.m2
       #AND ccg01[2,5] BETWEEN '4019' AND '401F'          #MOD-AB0223 mark
    #MOD-AA0070---mark---start---		
    #LET l_ccuwip = 0
    #SELECT SUM(ccu92) INTO l_ccuwip FROM ccu_file
    # WHERE ccu02 = tm.yy
    #   AND ccu03 = tm.m2
    #   AND ccu01[2,5] BETWEEN '4019' AND '401F'
    #MOD-AA0070---mark---end---
  END IF
  IF cl_null(sr.amount) THEN LET sr.amount = 0 END IF
 #IF cl_null(l_ccuwip) THEN LET l_ccuwip = 0 END IF           #MOD-AA0070 mark    
 #LET sr.amount = sr.amount + l_ccuwip                        #MOD-AA0070 mark   
  INITIALIZE sr.tit TO NULL
  LET l_title4='    ',cl_gr_getmsg('axc-134',g_lang,sr.order1) #FUN-D30060
  IF tm.c='N' OR l_title4[1,8]<>'        ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
  EXECUTE insert_prep USING sr.*,l_title4,g_ccz.ccz26  #FUN-D30060 add l_title4,g_ccz.ccz26
  END IF  #FUN-D30060
	
  LET sr.order = '70'    #制成品成本
  LET sr.order1 = '70'
 #MOD-B70092---modify---start---
 #IF sr.azf06 = '9' THEN #成品--制成品成本
 #   LET sr.amount = l_pcost + l_bwip + sr1[36] - sr1[39] - sr.amount
 #ELSE                   #模具--制成品成本
 #   LET sr.amount = l_pcost + l_bwip + sr2[36] - sr2[39] - sr.amount
 #END IF
 #IF sr.azf06 = '9' THEN #成品--制成品成本  #FUN-D30060
  IF sr.azf06 = 9 THEN #成品--制成品成本  #FUN-D30060
     LET sr.amount = l_pcost + l_bwip - sr.amount
  ELSE                   #模具--制成品成本
     LET sr.amount = l_pcost + l_bwip - sr.amount
  END IF
 #MOD-B70092---modify---end---
  INITIALIZE sr.tit TO NULL
  LET l_title4=cl_gr_getmsg('axc-134',g_lang,sr.order1) #FUN-D30060
  IF tm.c='N' OR l_title4[1,8]<>'        ' OR (tm.c='Y' AND sr.amount<> 0) THEN #FUN-D30060
  EXECUTE insert_prep USING sr.*,l_title4,g_ccz.ccz26  #FUN-D30060 add l_title4,g_ccz.ccz26
  END IF  #FUN-D30060
END FUNCTION
#FUN-970023 


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
