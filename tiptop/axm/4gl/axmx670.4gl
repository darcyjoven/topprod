# Prog. Version..: '5.30.07-13.05.30(00003)'     #
# Pattern name...: axmx670.4gl
# Descriptions...: 出貨未簽收及出至境外倉尚未出貨明細表
# Date & Author..: 12/01/16 FUN-BC0022 By Sakura
# Modify.........: No:MOD-C20023 12/02/02 By Sakura 修改l_sql where條件
# Modify.........: NO:FUN-C30228 12/03/19 By Sakura 於條件選項-排序下方，增加"簽收截止日"欄位，當條件為1時
#                                                   所有簽收日期(oga02)大於截止日的資料也都要顯示
# Modify.........: No:FUN-CB0003 12/11/05 By chenjing CR轉XtraGrid
# Modify.........: No.FUN-D30070 13/03/21 By chenying 去除小計
# Modify.........: No.FUN-D40128 13/05/16 By wangrr 報表中增加"客戶名稱,部門名稱,員工姓名"欄位
# Modify.........: No.FUN-D40128 13/05/22 By chenying 打印出至境外倉未出貨明細時，完全出貨的資料也被列印出來了 

DATABASE ds

GLOBALS "../../config/top.global"
   DEFINE tm  RECORD
              rtype  LIKE type_file.chr1, #報表類別
              wc     STRING,              #QBE
              s      LIKE type_file.chr3, #排序
              t      LIKE type_file.chr3, #跳頁
             #u      LIKE type_file.chr3, #小計  #FUN-D30070
              edate  LIKE type_file.dat,  #截止日 #FUN-C30228
              more   LIKE type_file.chr1  #其他特殊列印條件
              END RECORD
DEFINE   l_table       STRING
DEFINE   l_str         STRING
DEFINE   g_sql         STRING

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

     LET g_sql =" oga02.oga_file.oga02,",
                " oga01.oga_file.oga01,",
                " oga03.oga_file.oga03,",
                " oga14.oga_file.oga14,",
                " oga15.oga_file.oga15,",
                " ogb04.ogb_file.ogb04,",
                " ogb06.ogb_file.ogb06,",
                " ima021.ima_file.ima021,",
                " ogb12.ogb_file.ogb12,",
                " ogb13.ogb_file.ogb13,",
                " ogb14t.ogb_file.ogb14t,",
                " oga24.oga_file.oga24,",
                " ogb13_1.ogb_file.ogb13,",
                " ogb14t_1.ogb_file.ogb14t,",
                " azi03.azi_file.azi03,",
                " azi04.azi_file.azi04,",
                " azi05.azi_file.azi05,",
            #FUN-CB0003--add--str--
                "l_azi03.azi_file.azi03,",
                "l_azi04.azi_file.azi04,",
                "l_azi05.azi_file.azi05"
            #FUN-CB0003--add--end--
               ,",oga032.oga_file.oga032,",  #FUN-D40128
                " gen02.gen_file.gen02,",    #FUN-D40128
                " gem02.gem_file.gem02"      #FUN-D40128
   LET l_table = cl_prt_temptable('axmx670',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?)" #FUN-CB0003 add 3? #FUN-D40128 add 3?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF

   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway =ARG_VAL(5)
   LET g_copies =ARG_VAL(6)
   LET tm.rtype =ARG_VAL(7)
   LET tm.wc = ARG_VAL(8)
   LET tm.s  = ARG_VAL(9)
   LET tm.t  = ARG_VAL(10)
  #LET tm.u  = ARG_VAL(11)  #FUN-D30070
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)   
   LET tm.edate = ARG_VAL(16) #FUN-C30228

   IF cl_null(g_bgjob) OR g_bgjob = 'N'# If background job sw is off
      THEN CALL axmx670_tm(0,0)        # Input print condition
      ELSE CALL axmx670()              # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION axmx670_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
DEFINE p_row,p_col    LIKE type_file.num5,
       l_cmd          LIKE type_file.chr1000

   LET p_row = 5 LET p_col = 17

   OPEN WINDOW axmx670_w AT p_row,p_col WITH FORM "axm/42f/axmx670"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL # Default condition
   LET tm.rtype = '1'
   LET tm2.s1   = '1'
   LET tm2.s2   = '2'
   LET tm2.s3   = '3'
  #LET tm2.u1   = 'N'  #FUN-D30070
  #LET tm2.u2   = 'N'  #FUN-D30070
  #LET tm2.u3   = 'N'  #FUN-D30070
   LET tm2.t1   = 'N'
   LET tm2.t2   = 'N'
   LET tm2.t3   = 'N'
   LET tm.more  = 'N'
#FUN-C30228---add---START
   IF tm.rtype = '1' THEN
      LET g_pdate  = g_today
   ELSE
      CALL x670_set_no_entry()
   END IF
#FUN-C30228---add---END
   #LET g_pdate  = g_today #FUN-C30228 mark 
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
   LET tm.edate = g_today #FUN-C30228
WHILE TRUE
   INPUT BY NAME tm.rtype WITHOUT DEFAULTS

      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
         CALL x670_set_entry() #FUN-C30228
         CALL x670_set_no_entry() #FUN-C30228
      BEFORE FIELD rtype #FUN-C30228
         CALL x670_set_entry() #FUN-C30228
      AFTER FIELD rtype
         IF cl_null(tm.rtype) THEN
            NEXT FIELD rtype
         END IF
         CALL x670_set_no_entry() #FUN-C30228

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
         
      ON ACTION qbe_save
         CALL cl_qbe_save()

   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axmx670_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

   CONSTRUCT BY NAME tm.wc ON oga01,oga02,oga03,oga14,oga15

         BEFORE CONSTRUCT
             CALL cl_qbe_init()

       ON ACTION CONTROLP
           CASE
              WHEN INFIELD(oga01)  #出貨單號
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_oga8"
                LET g_qryparam.state = 'c'
                IF tm.rtype = '1' THEN
                  LET g_qryparam.where = " oga65='Y' and oga09='2' "
                ELSE
                  LET g_qryparam.where = " oga00='3' and oga09='2' "
                END IF
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oga01
                NEXT FIELD oga01

              WHEN INFIELD(oga03)  #客戶編號  
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_occ"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oga03
                NEXT FIELD oga03

              WHEN INFIELD(oga14)   #業務員編號
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gen"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oga14
                NEXT FIELD oga14

              WHEN INFIELD(oga15)   #部門編號
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gem"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oga15
                NEXT FIELD oga15
           END CASE
 
       ON ACTION locale
         LET g_action_choice = "locale"
          CALL cl_show_fld_cont()
         EXIT CONSTRUCT

     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT CONSTRUCT
         
      ON ACTION qbe_select
         CALL cl_qbe_select()

  END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF

 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axmx670_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE #本作業查詢條件不可空白!
   END IF
   DISPLAY BY NAME tm.more             # Condition
   INPUT BY NAME tm.edate, #FUN-C30228
                 tm2.s1,tm2.s2,tm2.s3,
                 tm2.t1,tm2.t2,tm2.t3,
                #tm2.u1,tm2.u2,tm2.u3,  #FUN-D30070
                 tm.more WITHOUT DEFAULTS

         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)

      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()

      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
        #LET tm.u = tm2.u1,tm2.u2,tm2.u3  #FUN-D30070
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
         
      ON ACTION qbe_save
         CALL cl_qbe_save()


   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axmx670_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='axmx670'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmx670','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.rtype CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'", #FUN-C30228
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                        #" '",tm.u CLIPPED,"'",  #FUN-D30070
                         " '",g_rep_user CLIPPED,"'",
                         " '",g_rep_clas CLIPPED,"'",
                         " '",g_template CLIPPED,"'",
                         " '",g_rpt_name CLIPPED,"'"
         CALL cl_cmdat('axmx670',g_time,l_cmd)
      END IF
      CLOSE WINDOW axmx670_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axmx670()
   ERROR ""
END WHILE
   CLOSE WINDOW axmx670_w
END FUNCTION

#FUN-C30228---add---START
FUNCTION x670_set_entry()
    CALL cl_set_comp_entry("edate",TRUE)
END FUNCTION

FUNCTION x670_set_no_entry()
   IF tm.rtype = '2' THEN
      CALL cl_set_comp_entry("edate",FALSE)
      LET tm.edate = ''
   ELSE
      LET tm.edate = g_today
   END IF
END FUNCTION
#FUN-C30228---add---END

FUNCTION axmx670()
   DEFINE l_sql     STRING,
          sr              RECORD  oga02    LIKE oga_file.oga02,
                                  oga01    LIKE oga_file.oga01,
                                  oga03    LIKE oga_file.oga03,
                                  oga032   LIKE oga_file.oga032, #FUN-D40128
                                  oga14    LIKE oga_file.oga14,
                                  oga15    LIKE oga_file.oga15,
                                  ogb04    LIKE ogb_file.ogb04,
                                  ogb06    LIKE ogb_file.ogb06,
                                  ima021   LIKE ima_file.ima021,
                                  ogb12    LIKE ogb_file.ogb12,
                                  ogb13    LIKE ogb_file.ogb13,
                                  ogb14t   LIKE ogb_file.ogb14t,
                                  oga24    LIKE oga_file.oga24,
                                  ogb13_1  LIKE ogb_file.ogb13,
                                  ogb14t_1 LIKE ogb_file.ogb14t,
                                  azi03    LIKE azi_file.azi03,
                                  azi04    LIKE azi_file.azi04,
                                  azi05    LIKE azi_file.azi05                                  
                        END RECORD                      
   DEFINE l_ima021   LIKE ima_file.ima021,
          l_ogb13    LIKE ogb_file.ogb13,
          l_ogb14t   LIKE ogb_file.ogb14t,
          l_azi03    LIKE azi_file.azi03,
          l_azi04    LIKE azi_file.azi04,
          l_azi05    LIKE azi_file.azi05
   DEFINE l_gen02    LIKE gen_file.gen02  #FUN-D40128
   DEFINE l_gem02    LIKE gem_file.gem02  #FUN-D40128

     CALL cl_del_data(l_table)
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang

     IF g_priv2='4' THEN                           #只能使用自己的資料
         LET tm.wc = tm.wc clipped," AND ogauser = '",g_user,"'"
     END IF
     IF g_priv3='4' THEN                           #只能使用相同群的資料
         LET tm.wc = tm.wc clipped," AND ogagrup MATCHES '",g_grup CLIPPED,"*'"
     END IF

     IF g_priv3 MATCHES "[5678]" THEN    #群組權限
         LET tm.wc = tm.wc clipped," AND ogagrup IN ",cl_chk_tgrup_list()
     END IF
     IF tm.rtype = '1' THEN 
        LET l_sql = "SELECT oga02,oga01,oga03,oga032,oga14,oga15,ogb04,ogb06,'',ogb12, ", #FUN-D40128 add oga032
                    "       ogb13,ogb14t,oga24,'','' ",
                    "       azi03,azi04,azi05  ",
                    "  FROM oga_file,ogb_file,azi_file ",
                    " WHERE oga01 = ogb01 AND oga23 = azi01 AND oga65 ='Y' AND oga09 ='2' ",
                    "   AND ogaconf ='Y' AND ogapost ='Y' ",
                    "   AND oga01 NOT IN (SELECT oga011 FROM oga_file WHERE oga09 = '8' AND ogapost ='Y') ", #MOD-C20023 add
                    #"   AND (oga01 NOT IN (SELECT oga01 FROM oga_file WHERE oga011 = oga01 AND oga09 = '8') ", #MOD-C20023 mark
                    #"     OR oga01 NOT IN (SELECT oga01 FROM oga_file WHERE oga011 = oga01 AND oga09 = '8' AND ogapost ='N' ))", #MOD-C20023 mark
                    "   AND ",tm.wc
                  #FUN-C30228---Start--add
                    IF NOT cl_null(tm.edate) THEN
                       LET l_sql = l_sql,
                           " UNION ",
                           "SELECT oga02,oga01,oga03,oga032,oga14,oga15,ogb04,ogb06,'',ogb12, ", #FUN-D40128 add oga032
                           "       ogb13,ogb14t,oga24,'','' ",
                           "       azi03,azi04,azi05  ",
                           "  FROM oga_file,ogb_file,azi_file ",
                           " WHERE oga01 = ogb01 AND oga23 = azi01 AND oga65 ='Y' AND oga09 ='2' ",
                           "   AND ogaconf ='Y' AND ogapost ='Y' ",
                           "   AND oga01 IN (SELECT oga011 FROM oga_file WHERE oga09 = '8' AND oga02 > '",tm.edate,"')",
                           "   AND ",tm.wc 
                    END IF
                  #FUN-C30228---End---add  
     ELSE
        LET l_sql = "SELECT oga02,oga01,oga03,oga032,oga14,oga15,ogb04,ogb06,'',ogb12, ", #FUN-D40128 add oga032
                    "       ogb13,ogb14t,oga24,'','' ",
                    "       azi03,azi04,azi05  ",
                    "  FROM oga_file,ogb_file,azi_file ",
                    " WHERE oga01 = ogb01 AND oga23 = azi01 AND oga00 ='3' AND oga09 ='2' ",
                    "   AND ogaconf ='Y' AND ogapost ='Y' ",
                   #FUN-D40128--add--str--0522
                   #"   AND (oga01 NOT IN (SELECT oea01 FROM oea_file,oga_file WHERE oea00 = '4' AND oea11 = '7' AND oea12 = oga01) ",
                   #"     OR oga01 NOT IN (SELECT oea01 FROM oea_file,oeb_file,oga_file WHERE oea01= oeb01 ",
                   #"                      AND oea12=oga01 AND (oeb12-oeb24+oeb25-oeb26)>0 AND oeb70 <> 'Y') ",
                   #"     OR ogb12<>(SELECT SUM(oeb12) FROM oea_file,oeb_file,oga_file WHERE oea00='4' AND oea11='7' AND oea12=oga01 AND oea01= oeb01))",
                    "   AND (oga01 NOT IN (SELECT oea12 FROM oea_file WHERE oea00 = '4' AND oea11 = '7' ) ",
                    "     OR oga01  IN (SELECT oea12 FROM oea_file,oeb_file,oga_file WHERE oea01= oeb01 ",
                    "                      AND oea12=oga01 AND (oeb12-oeb24+oeb25-oeb26)>0 AND oeb70 <> 'Y' AND oea00 = '4' AND oea11 = '7' ) ",
                    "     OR ogb12<>(SELECT SUM(oeb12) FROM oea_file,oeb_file,oga_file WHERE oea00='4' AND oea11='7' AND oea12=oga01 AND oea01= oeb01))",
                   #FUN-D40128--add--end--0522
                    "   AND ",tm.wc
     END IF      

     PREPARE axmx670_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE axmx670_curs1 CURSOR FOR axmx670_prepare1
     FOREACH axmx670_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF

      SELECT ima021 INTO l_ima021 FROM ima_file
       WHERE ima01=sr.ogb04
      IF cl_null(sr.ogb13)  THEN LET sr.ogb13  = 0 END IF
      IF cl_null(sr.oga24)  THEN LET sr.oga24  = 0 END IF
      IF cl_null(sr.ogb14t) THEN LET sr.ogb14t = 0 END IF
      IF cl_null(sr.oga24)  THEN LET sr.oga24  = 0 END IF
      LET l_ogb13 = sr.ogb13 * sr.oga24
      LET l_ogb14t = sr.ogb14t * sr.oga24
      SELECT azi04,azi05,azi03 INTO l_azi04,l_azi05,l_azi03 FROM azi_file WHERE azi01 = g_aza.aza17     #FUN-CB0003
      #FUN-D40128--add--str--
      LET l_gen02=''
      LET l_gem02=''
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.oga14
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.oga15
      LET sr.ogb12=cl_digcut(sr.ogb12,2)
      LET sr.oga24=cl_digcut(sr.oga24,2)
      #FUN-D40128--add--end

      EXECUTE insert_prep USING sr.oga02 ,sr.oga01 ,sr.oga03,sr.oga14,sr.oga15,
                                sr.ogb04 ,sr.ogb06 ,l_ima021,sr.ogb12,
                                sr.ogb13 ,sr.ogb14t,sr.oga24,
                                l_ogb13  ,l_ogb14t ,
                                sr.azi03 ,sr.azi04 ,sr.azi05
                              #,l_azi04,l_azi05,l_azi03             #FUN-CB0003 add  
                               ,l_azi03,l_azi04,l_azi05    #FUN-D40128
                               ,sr.oga032,l_gen02,l_gem02  #FUN-D40128
     END FOREACH
     
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'axmx670'
     IF g_zz05 = 'Y' THEN
         CALL cl_wcchp(tm.wc,'oga01,oga02,oga03,oga14,oga15')
              RETURNING tm.wc
     END IF     

#    SELECT azi04,azi05,azi03 INTO l_azi04,l_azi05,l_azi03 FROM azi_file WHERE azi01 = g_aza.aza17    #FUN-CB0003

###XtraGrid###     LET l_sql=" SELECT * FROM ",g_cr_db_str CLIPPED,l_table clipped
     PREPARE axmx670_preparet FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    
        EXIT PROGRAM
     END IF
###XtraGrid###     LET l_str = tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",
###XtraGrid###                 tm.u[1,1],";",tm.u[2,2],";",tm.u[3,3],";",
###XtraGrid###                 tm.wc CLIPPED,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
###XtraGrid###                 l_azi04,";",l_azi05,";",l_azi03
###XtraGrid###     CALL cl_prt_cs3('axmx670','axmx670',l_sql,l_str)
    LET g_xgrid.table = l_table    ###XtraGrid###
#FUN-CB0003--add--start--
    LET g_xgrid.order_field = cl_get_order_field(tm.s,"oga01,oga02,oga03,oga14,oga15")
   #LET g_xgrid.grup_field = "oga01,"   #FUN-D30070
   #LET g_xgrid.grup_field = g_xgrid.grup_field,cl_get_order_field(tm.s,"oga01,oga02,oga03,oga14,oga15")  #FUN-D30070
    LET g_xgrid.grup_field = cl_get_order_field(tm.s,"oga01,oga02,oga03,oga14,oga15")  #FUN-D30070
   #LET g_xgrid.grup_sum_field = cl_get_sum_field(tm.s,tm.u,"oga01,oga02,oga03,oga14,oga15")  #FUN-D30070
    LET g_xgrid.skippage_field = cl_get_skip_field(tm.s,tm.t,"oga01,oga02,oga03,oga14,oga15")
    LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc    
#FUN-Cb0003--add--end---
    CALL cl_xg_view()    ###XtraGrid###

END FUNCTION
#FUN-BC0022


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
