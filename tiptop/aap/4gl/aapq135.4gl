# Prog. Version..: '5.25.04-11.09.15(00007)'     #
#
# Pattern name...: aapq135.4gl
# Descriptions...: 暫估明細查詢作業
# Date & Author..: 12/11/29 By wangrr   #FUN-CB0124
# ...............: No.FUN-D60022 13/06/05 by yuhuabao 由aglq135.4gl->aapq135.4gl
# Modify.........: No.FUN-D10110 13/07/01 By wangrr 9主機追單,在個本幣金額旁邊增加原幣金額欄位,增加顯示立帳匯率、重評估匯率、結餘原幣金額

DATABASE ds
GLOBALS "../../config/top.global"

DEFINE tm         RECORD 
       bm         LIKE apa_file.apa02,
       em         LIKE apa_file.apa02
       END RECORD,
       g_apa05    LIKE apa_file.apa05,
       g_apb12    LIKE apb_file.apb12
DEFINE g_apa      DYNAMIC ARRAY OF RECORD
       apa02      LIKE apa_file.apa02,
       apa00      LIKE apa_file.apa00,
       apa01      LIKE apa_file.apa01,
       apb02      LIKE apb_file.apb02,
       apb21      LIKE apb_file.apb21,
       apb22      LIKE apb_file.apb22,
       rvv87      LIKE rvv_file.rvv87,
       rvv39      LIKE rvv_file.rvv39,
       apa13      LIKE apa_file.apa13,  #FUN-D10110 
       apa14      LIKE apa_file.apa14,  #FUN-D10110
       apa14_c    LIKE apa_file.apa14,  #FUN-D10110
       apb09      LIKE apb_file.apb09,
       apb24      LIKE apb_file.apb24,  #FUN-D10110
       apb10      LIKE apb_file.apb10,
       apa01_c    LIKE apa_file.apa01,
       apb02_c    LIKE apb_file.apb02,
       apb09_c    LIKE apb_file.apb09,
       apb24_c    LIKE apb_file.apb24,  #FUN-D10110
       apb10_c    LIKE apb_file.apb10,
       num1       LIKE apb_file.apb09,
       amt1       LIKE apb_file.apb10,
       num2       LIKE apb_file.apb09,
       amt3       LIKE apb_file.apb24,  #FUN-D10110
       amt2       LIKE apb_file.apb10
      ,diff       LIKE apb_file.apb24  #FUN-D10110
       END RECORD
DEFINE g_wc,g_sql       STRING,
       l_ac             LIKE type_file.num5,    
       g_rec_b          LIKE type_file.num5   
DEFINE g_cnt            LIKE type_file.num10  
DEFINE g_msg            LIKE type_file.chr1000
DEFINE g_row_count      LIKE type_file.num10   
DEFINE g_curs_index     LIKE type_file.num10   
DEFINE g_jump           LIKE type_file.num10   
DEFINE mi_no_ask        LIKE type_file.num5   

MAIN
   DEFINE p_row,p_col   LIKE type_file.num5
 
   OPTIONS                                 
        INPUT NO WRAP
    DEFER INTERRUPT                        
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time       #計算使用時間 (進入時間) 
   LET g_wc=ARG_VAL(1)
   LET tm.bm=ARG_VAL(2)
   LET tm.em=ARG_VAL(3)
   LET g_bgjob=ARG_VAL(4)
   CALL q135_table()        #臨時表   
   LET p_row = 2 LET p_col = 10
   OPEN WINDOW q135_w AT p_row,p_col WITH FORM "aap/42f/aapq135" #FUN-D60022
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()
   CALL cl_set_comp_visible('apa01_c,apb02_c,num1,amt1',FALSE)
   
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL q135_tm()
   ELSE
      CALL q135()
   END IF
   CALL q135_menu()
   DROP TABLE q135_tmp;
   DROP TABLE q135_tmp;
   CLOSE WINDOW q135_w             #結束畫面
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time       #計算使用時間 (退出使間)
END MAIN

#中文的MENU
FUNCTION q135_menu()
   
   WHILE TRUE
      CALL q135_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q135_tm()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_apa),'','')
             END IF
      END CASE
   END WHILE
END FUNCTION
 
#QBE 查詢資料
FUNCTION q135_tm()
DEFINE lc_qbe_sn       LIKE gbm_file.gbm01 
   CLEAR FORM #清除畫面
   CALL g_apa.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL
   CALL cl_set_head_visible("","YES")
   #CALL q135_getday()   #FUN-D10110 mark
   CALL q135_getday(YEAR(g_today),MONTH(g_today)) RETURNING tm.bm,tm.em  #FUN-D10110 add
   DISPLAY tm.bm,tm.em TO bm,em
   WHILE TRUE
      DIALOG ATTRIBUTE(unbuffered)
          INPUT BY NAME tm.bm,tm.em ATTRIBUTE(WITHOUT DEFAULTS)   
            BEFORE INPUT
               CALL cl_qbe_display_condition(lc_qbe_sn)
           
            AFTER FIELD bm
               IF NOT cl_null(tm.bm) THEN
                  IF NOT cl_null(tm.bm) AND tm.bm>tm.em THEN
                     CALL cl_err('','mfg9234',0)
                     NEXT FIELD bm
                  END IF
               END IF
    
            AFTER FIELD em
               IF cl_null(tm.em) THEN
                  LET tm.em =g_lastdat
               ELSE
                  IF YEAR(tm.em) <> YEAR(tm.em) THEN NEXT FIELD em END IF
                  IF NOT cl_null(tm.bm) AND tm.em < tm.bm THEN
                     CALL cl_err(' ','agl-031',0)
                     NEXT FIELD em
                  END IF
               END IF
   
            ON ACTION locale
               CALL cl_show_fld_cont() 
               LET g_action_choice = "locale"
               EXIT DIALOG    
    
            ON ACTION CONTROLZ
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
               
         END INPUT
        
         CONSTRUCT g_wc ON apa05,apb12,apa13,apa14 #FUN-D10110 add apa13,apa14
                      FROM apa05,apb12,apa13,apa14 #FUN-D10110 add apa13,apa14
            BEFORE CONSTRUCT
               CALL cl_qbe_init()

            ON ACTION CONTROLP
               CASE
                  WHEN INFIELD(apa05) #供應商
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_apa05"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO apa05
                     NEXT FIELD apa05
                  WHEN INFIELD(apb12) #料號
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_ima"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO apb12
                     NEXT FIELD apb12
                  #FUN-D10110--add--str--
                  WHEN INFIELD(apa13) #幣別
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_azi"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO apa13
                     NEXT FIELD apa13
                  #FUN-D10110--add--end
               END CASE

            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE DIALOG

            ON ACTION about      
               CALL cl_about()   

            ON ACTION help
               CALL cl_show_help()

            ON ACTION controlg   
               CALL cl_cmdask()  

            ON ACTION qbe_select
               CALL cl_qbe_select()

            ON ACTION qbe_save
               CALL cl_qbe_save()
         END CONSTRUCT 
         ON ACTION ACCEPT
            EXIT DIALOG        
          
         ON ACTION CANCEL
            LET INT_FLAG=1
            EXIT DIALOG       
      END DIALOG 
      
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont() 
      END IF
   
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         RETURN
      END IF 
      IF cl_null(g_wc) THEN LET g_wc=" 1=1 " END IF
      EXIT WHILE
   END WHILE
   CALL q135()

END FUNCTION
 
FUNCTION q135()  
   DEFINE l_apa05     LIKE apa_file.apa05,
          l_apb12     LIKE apb_file.apb12,
          l_num1      LIKE apb_file.apb09,
          l_amt1      LIKE apb_file.apb10,
          l_num2      LIKE apb_file.apb09,
          l_amt2      LIKE apb_file.apb10,
          l_num3      LIKE apb_file.apb09,
          l_amt3      LIKE apb_file.apb10,
          l_date      LIKE apa_file.apa02,
          l_apb09     LIKE apb_file.apb09,
          l_apb10     LIKE apb_file.apb10
   DEFINE l_sql       STRING
   #FUN-D10110--add--str--
   DEFINE l_apa13     LIKE apa_file.apa13 
   DEFINE l_azj02     LIKE azj_file.azj02
   DEFINE l_azj07     LIKE azj_file.azj07
   DEFINE l_year      LIKE type_file.num10
   DEFINE l_month     LIKE type_file.num10
   DEFINE l_flag      LIKE type_file.num5
   DEFINE l_azk02     LIKE azk_file.azk02
   DEFINE l_apz33     LIKE apz_file.apz33
   #FUN-D10110--add--end
   
   DELETE FROM q135_tmp;
   
   LET g_sql="SELECT apa05,apb12,apa02,apa00,",  
             "       apa01,apb02,apb21,apb22,",
             "       rvv87,rvv39,apa13,apa14,0 apa14_c,apb09,apb24,apb10,", #FUN-D10110 add apa13,apa14,apb24,apa14_c
             "       '' apa01_c,'' apb02_c,0 apb09_c,0 apb24_c,0 apb10_c,", #FUN-D10110 add apb24_c
             "       0 num1,0 amt1,0 num2,0 amt3,0 amt2,0 diff ",           #FUN-D10110 add amt3,diff   
             "  FROM apa_file LEFT OUTER JOIN apb_file ON (apa01=apb01)",
             "                LEFT OUTER JOIN rvv_file ON (apb21=rvv01 AND apb22=rvv02)",
             " WHERE apa00 IN ('16','26') AND apa41 = 'Y' AND apa42='N' ",
             "   AND apa02 BETWEEN '",tm.bm,"' AND '",tm.em,"'", 
             "   AND ",g_wc CLIPPED,
             " ORDER BY apa05,apb12,apa02,apa00,apa01,apb02,apa13 ASC " #FUN-D10110 add apa13
             
   #插入臨時表
   LET g_sql = " INSERT INTO q135_tmp ",
               " SELECT z.*,ROWNUM ",
               " FROM (",g_sql CLIPPED," ) z" 
   PREPARE q135_ins FROM g_sql
   EXECUTE q135_ins

   #FUN-D10110--add--str--
   #重評估匯率
   LET g_sql="SELECT DISTINCT apa13 FROM q135_tmp "
   PREPARE q135_sel_pr FROM g_sql
   DECLARE q135_sel_cr CURSOR FOR q135_sel_pr 
   LET g_success='Y'
   CALL s_showmsg_init()
   
   FOREACH q135_sel_cr INTO l_apa13
      IF l_apa13=g_aza.aza17 THEN
         LET l_azj07=1
      ELSE
         LET l_azj07=NULL
         IF tm.em<g_today THEN
            IF g_aza.aza19='1' THEN  #取每月匯率
               IF MONTH(tm.em)=1 THEN
                  LET l_year=YEAR(tm.em)-1
                  LET l_azj02=l_year USING '<<<<',"12"
               ELSE
                  LET l_month=MONTH(tm.em)-1
                  LET l_year=YEAR(tm.em)
                  IF l_month<10 THEN
                  LET l_azj02=l_year USING '<<<<','0',l_month USING '<<'
                  ELSE
                     LET l_azj02=l_year USING '<<<<',l_month USING '<<'
                  END IF
               END IF
               
               SELECT azj07 INTO l_azj07 FROM azj_file 
                WHERE azj01=l_apa13 AND azj02=l_azj02
               IF cl_null(l_azj07) THEN
                  LET g_showmsg=l_apa13,'/',l_azj02
                  CALL s_errmsg('azj01,azj02',g_showmsg,'sel azj_file:','aoo-108',1)
                  LET g_success='N'
               END IF
            ELSE #取每日匯率
               IF MONTH(tm.em)=1 THEN
                  LET l_year=YEAR(tm.em)-1
                  LET l_azj02=l_year USING '<<<<',"/12/31"
               ELSE
                  LET l_month=MONTH(tm.em)-1
                  LET l_year=YEAR(tm.em)
                  CALL q135_getday(l_year,l_month) RETURNING l_date,l_azk02
               END IF
               SELECT apz33 INTO l_apz33 FROM apz_file
               CASE
                  WHEN l_apz33='B' LET g_sql="SELECT azk03 "
                  WHEN l_apz33='S' LET g_sql="SELECT azk04 "
                  WHEN l_apz33='M' LET g_sql="SELECT azk041 "
                  WHEN l_apz33='C' LET g_sql="SELECT azk051 "
                  WHEN l_apz33='D' LET g_sql="SELECT azk052 "
               END CASE
               LET g_sql=g_sql,"  FROM azk_file ",
                               " WHERE azk01='",l_apa13,"' AND azk02='",l_azk02,"'"
               PREPARE sel_azk_pr FROM g_sql
               EXECUTE sel_azk_pr INTO l_azj07
               IF cl_null(l_azj07) THEN
                  LET g_showmsg=l_apa13,'/',l_azk02
                  CALL s_errmsg('azk01,azk02',g_showmsg,'sel azk_file:','aoo-261',1)
                  LET g_success='N'
               END IF
            END IF
         ELSE
            IF g_aza.aza19='1' THEN  #取每月匯率
                LET l_month=MONTH(tm.em)
                LET l_year=YEAR(tm.em)
                IF l_month<10 THEN
                LET l_azj02=l_year USING '<<<<','0',l_month USING '<<'
                ELSE
                   LET l_azj02=l_year USING '<<<<',l_month USING '<<'
                END IF
                SELECT azj07 INTO l_azj07 FROM azj_file 
                WHERE azj01=l_apa13 AND azj02=l_azj02
               IF cl_null(l_azj07) THEN
                  LET g_showmsg=l_apa13,'/',l_azj02
                  CALL s_errmsg('azj01,azj02',g_showmsg,'sel azj_file:','aoo-108',1)
                  LET g_success='N'
               END IF
            ELSE #取每日匯率
               SELECT apz33 INTO l_apz33 FROM apz_file
               CASE
                  WHEN l_apz33='B' LET g_sql="SELECT azk03 "
                  WHEN l_apz33='S' LET g_sql="SELECT azk04 "
                  WHEN l_apz33='M' LET g_sql="SELECT azk041 "
                  WHEN l_apz33='C' LET g_sql="SELECT azk051 "
                  WHEN l_apz33='D' LET g_sql="SELECT azk052 "
               END CASE
               LET g_sql=g_sql,"  FROM azk_file ",
                               " WHERE azk01='",l_apa13,"' AND azk02='",tm.em,"'"
               PREPARE sel_azk_pr1 FROM g_sql
               EXECUTE sel_azk_pr1 INTO l_azj07
               IF cl_null(l_azj07) THEN
                  LET g_showmsg=l_apa13,'/',tm.em
                  CALL s_errmsg('azk01,azk02',g_showmsg,'sel azk_file:','aoo-261',1)
                  LET g_success='N'
               END IF
            END IF
         END IF
      END IF
      LET g_sql="UPDATE q135_tmp",
                "   SET apa14_c=",l_azj07,
                " WHERE apa13='",l_apa13,"'"
      PREPARE q135_upd_pr5 FROM g_sql
      EXECUTE q135_upd_pr5
   END FOREACH
   CALL s_showmsg()
   #FUN-D10110--add--
   
   #入庫/倉退數量和金額
   UPDATE q135_tmp SET rvv87=0 WHERE (rvv87 IS NULL OR rvv87='')
   UPDATE q135_tmp SET rvv39=0 WHERE (rvv39 IS NULL OR rvv39='')
   
   #當暫估有單身時抓沖暫估數量
   LET g_sql = " UPDATE q135_tmp o ",
               "    SET o.apb09_c= ",
               "       (",
               "        SELECT SUM((case when apb09<0 then -1*apb09  else apb09 end)) ",
               "          FROM apa_file a,apb_file b ",
               "         WHERE a.apa41 = 'Y' AND a.apa42='N' AND b.apb34='Y' ",
               "           AND a.apa00 IN ('11','21') AND a.apa01=b.apb01 ",
               "           AND a.apa02 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
               "           AND o.apa05 = a.apa05 AND o.apb12= b.apb12 ",
               "           AND o.apb21=b.apb21 AND o.apb22=b.apb22 ",
               "       )",
               " WHERE o.apb02 IS NOT NULL "
   PREPARE q135_pr2 FROM g_sql
   EXECUTE q135_pr2
  
   #當暫估有單身時抓沖暫估金額
   LET g_sql = " UPDATE q135_tmp o ",
               "    SET o.apb10_c= ",
               "       (",
               "        SELECT SUM((case when api05<0 then -1*api05  else api05 end)) ",
               "          FROM api_file ",
               "         WHERE api01||api03 IN ",
               "              ( ",
               "               SELECT DISTINCT apa01||apb02 ",
               "                 FROM apa_file a,apb_file b ",
               "                WHERE a.apa41 = 'Y' AND a.apa42='N' AND b.apb34='Y' ",
               "                  AND a.apa00 IN ('11','21') AND a.apa01=b.apb01 ",
               "                  AND a.apa02 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
               "                  AND o.apa05 = a.apa05 AND o.apb12= b.apb12 ",
               "                  AND o.apb21=b.apb21 AND o.apb22=b.apb22 ",
               "                  AND o.apa13=a.apa13 ",
               "              )",
               "          AND api02 = '2' AND api26 <> 'DIFF' AND o.apa01=api26",
               "       )",
               " WHERE o.apb02 IS NOT NULL "
   PREPARE q135_pr3 FROM g_sql
   EXECUTE q135_pr3

   #FUN-D10110--add--str--
   #當暫估有單身時抓沖暫原幣估金額
   LET g_sql = " UPDATE q135_tmp o ",
               "    SET o.apb24_c= ",
               "       (",
               "        SELECT SUM((case when api05f<0 then -1*api05f  else api05f end)) ",
               "          FROM api_file ",
               "         WHERE api01||api03 IN ",
               "              ( ",
               "               SELECT DISTINCT apa01||apb02 ",
               "                 FROM apa_file a,apb_file b ",
               "                WHERE a.apa41 = 'Y' AND a.apa42='N' AND b.apb34='Y' ",
               "                  AND a.apa00 IN ('11','21') AND a.apa01=b.apb01 ",
               "                  AND a.apa02 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
               "                  AND o.apa05 = a.apa05 AND o.apb12= b.apb12 ",
               "                  AND o.apb21=b.apb21 AND o.apb22=b.apb22 ",
               "                  AND o.apa13=a.apa13 ",
               "              )",
               "          AND api02 = '2' AND api26 <> 'DIFF' AND o.apa01=api26",
               "       )",
               " WHERE o.apb02 IS NOT NULL "
   PREPARE q135_upq_pr1 FROM g_sql
   EXECUTE q135_upq_pr1
   #FUN-D10110--add--end

   #當暫估无单身時金額等於單頭本幣金額
   LET g_sql="UPDATE q135_tmp o",
             "   SET o.apb09=0,",
             "       o.apb10=(SELECT apa31 FROM apa_file",
             "                 WHERE apa01=o.apa01 )",
             "      ,o.apb24=(SELECT apa31f FROM apa_file", #FUN-D10110
             "                 WHERE apa01=o.apa01 )",      #FUN-D10110
             " WHERE o.apb02 IS NULL "
   PREPARE q135_pr4 FROM g_sql
   EXECUTE q135_pr4
   IF STATUS THEN
      CALL cl_err('',STATUS,0)
   END IF

   #暫估無單身抓取沖暫估資料,沖暫估无单身金額等於單頭本幣金額
   LET g_sql = " UPDATE q135_tmp o ",
               "    SET o.apb10_c= ",
               "       (",
               "        SELECT SUM((case when api05<0 then -1*api05  else api05 end)) ",
               "          FROM api_file ",
               "         WHERE api01 IN ",
               "              ( ",
               "               SELECT DISTINCT apa01 ",
               "                 FROM apa_file a LEFT OUTER JOIN apb_file b ON (a.apa01=b.apb01)",
               "                WHERE a.apa41 = 'Y' AND a.apa42='N'  ",
               "                  AND a.apa00 IN ('11','21') AND b.apb02 IS NULL ",
               "                  AND a.apa02 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
               "                  AND o.apa05 = a.apa05 AND  b.apb12 IS NULL",
               "                  AND o.apa13 = a.apa13 ",  #FUN-D10110   
               "              )",
               "          AND api02 = '2'  AND o.apa01=api26",
               "       )",
               " WHERE  o.apb02 IS NULL "
   PREPARE q135_pr5 FROM g_sql
   EXECUTE q135_pr5
   IF STATUS THEN
      CALL cl_err('',STATUS,0)
   END IF
   
   #FUN-D10110--add--str--
   #暫估無單身抓取沖暫估資料,沖暫估无单身原幣金額等於單頭原幣金額
   LET g_sql = " UPDATE q135_tmp o ",
               "    SET o.apb24_c= ",
               "       (",
               "        SELECT SUM((case when api05f<0 then -1*api05f  else api05f end)) ",
               "          FROM api_file ",
               "         WHERE api01 IN ",
               "              ( ",
               "               SELECT DISTINCT apa01 ",
               "                 FROM apa_file a LEFT OUTER JOIN apb_file b ON (a.apa01=b.apb01)",
               "                WHERE a.apa41 = 'Y' AND a.apa42='N'  ",
               "                  AND a.apa00 IN ('11','21') AND b.apb02 IS NULL ",
               "                  AND a.apa02 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
               "                  AND o.apa05 = a.apa05 AND  b.apb12 IS NULL",
               "                  AND o.apa13 = a.apa13 ", 
               "              )",
               "          AND api02 = '2'  AND o.apa01=api26",
               "       )",
               " WHERE  o.apb02 IS NULL "
   PREPARE q135_upq_pr2 FROM g_sql
   EXECUTE q135_upq_pr2
   IF STATUS THEN
      CALL cl_err('',STATUS,0)
   END IF
   UPDATE q135_tmp SET apb24_c=0 WHERE apb24_c IS NULL OR apb24_c=''
   #FUN-D10110--add--end
   
   UPDATE q135_tmp SET apb09_c=0 WHERE apb09_c IS NULL OR apb09_c=''
   UPDATE q135_tmp SET apb10_c=0 WHERE apb10_c IS NULL OR apb10_c=''
    
   #'11'入庫沖暫估(-)
   UPDATE q135_tmp SET apb09_c=-1*apb09_c,
                       apb10_c=-1*apb10_c,
                       apb24_c=-1*apb24_c,  #FUN-D10110
                       num1=-1*num1,
                       amt1=-1*amt1
   WHERE apa00='16' AND (apb09_c>0 OR apb10_c>0)

   #'26'倉退暫估立賬(-)
   UPDATE q135_tmp SET apb09=-1*apb09,
                       apb10=-1*apb10 
                      ,apb24=-1*apb24  #FUN-D10110 
    WHERE apa00='26'

   #結餘數量金額
   LET g_sql="UPDATE q135_tmp",
             "   SET num2=apb09+apb09_c,",
             "       amt2=apb10+apb10_c "
            ,"      ,amt3=apb24+apb24_c "  #FUN-D10110
   PREPARE q135_pr6 FROM g_sql
   EXECUTE q135_pr6 
   IF STATUS THEN
      CALL cl_err('',STATUS,0)
   END IF
   #FUN-D10110-add--str--
   #匯差
   LET g_sql="UPDATE q135_tmp",
             "   SET diff=amt3*apa14_c-amt2"
   PREPARE q135_upd_pr3 FROM g_sql
   EXECUTE q135_upd_pr3
   #本幣結餘
   LET g_sql="UPDATE q135_tmp",
             "   SET amt2=amt3*apa14_c"
   PREPARE q135_upd_pr4 FROM g_sql
   EXECUTE q135_upd_pr4 
   #FUN-D10110-add--end
   CALL q135_cs()
END FUNCTION

FUNCTION q135_cs()
     LET g_sql = "SELECT DISTINCT apa05,apb12 FROM q135_tmp ",
                 " ORDER BY apa05,apb12 "
     PREPARE q135_ps FROM g_sql
     DECLARE q135_curs SCROLL CURSOR WITH HOLD FOR q135_ps

     LET g_sql = "SELECT COUNT(DISTINCT (apa05||apb12)) FROM q135_tmp"
     PREPARE q135_ps2 FROM g_sql
     DECLARE q135_cnt CURSOR FOR q135_ps2

     OPEN q135_curs
     IF SQLCA.sqlcode THEN
        CALL cl_err('OPEN q135_curs',SQLCA.sqlcode,0)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     ELSE
        OPEN q135_cnt
        FETCH q135_cnt INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL q135_fetch('F')
     END IF
END FUNCTION

FUNCTION q135_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,
   l_abso          LIKE type_file.num10

   CASE p_flag
      WHEN 'N' FETCH NEXT     q135_curs INTO g_apa05,g_apb12
      WHEN 'P' FETCH PREVIOUS q135_curs INTO g_apa05,g_apb12
      WHEN 'F' FETCH FIRST    q135_curs INTO g_apa05,g_apb12
      WHEN 'L' FETCH LAST     q135_curs INTO g_apa05,g_apb12
      WHEN '/'
         IF (NOT mi_no_ask) THEN
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0
             PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()

                ON ACTION about
                   CALL cl_about()

                ON ACTION help
                   CALL cl_show_help()

                ON ACTION controlg
                   CALL cl_cmdask()

             END PROMPT
             IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
             END IF

         END IF
         FETCH ABSOLUTE g_jump q135_curs INTO g_apa05,g_apb12
         LET mi_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_apa05 TO NULL
      INITIALIZE g_apb12 TO NULL
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      DISPLAY g_curs_index TO FORMONLY.idx
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
   CALL q135_show()
   
END FUNCTION

FUNCTION q135_show()
   DEFINE l_pmc03    LIKE pmc_file.pmc03,
          l_ima02    LIKE ima_file.ima02
          
   SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01=g_apa05
   SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01=g_apb12
   DISPLAY g_apa05,l_pmc03,g_apb12,l_ima02
        TO apa05,pmc03,apb12,ima02
CALL q135_b_fill()
END FUNCTION

FUNCTION q135_b_fill()
  DEFINE  l_npq06    LIKE npq_file.npq06
  DEFINE  l_type     LIKE type_file.chr1
  DEFINE  l_memo     LIKE abb_file.abb04

   LET g_sql="SELECT apa02,apa00,apa01,apb02,apb21,apb22,rvv87,rvv39,apa13,apa14,apa14_c,", #FUN-D10110 add apa13,apa14,apa14_c 
             "       apb09,apb24,apb10,apa01_c,apb02_c,apb09_c,apb24_c,apb10_c, ", #FUN-D10110 add apb24,apb24_c
             "       num1,amt1,num2,amt3,amt2,diff ",  #FUN-D10110 add num3,diff
             "  FROM q135_tmp ",
             " WHERE apa05='",g_apa05,"'"
   IF NOT cl_null(g_apb12) THEN
      LET g_sql=g_sql," AND apb12='",g_apb12,"'"
   ELSE
      LET g_sql=g_sql," AND apb12 IS NULL "
   END IF
   LET g_sql=g_sql," ORDER BY apa02,apa00,apa01,apb02,apa01_c,apb02_c"
   PREPARE q135_bpr FROM g_sql
   DECLARE q135_bcs CURSOR FOR q135_bpr
   CALL g_apa.clear()
   LET g_cnt = 1
   FOREACH q135_bcs INTO g_apa[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH q135_bcs:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN  
         CALL cl_err( '', 9035, 0 )
	      EXIT FOREACH
      END IF
   END FOREACH
   CALL g_apa.deleteElement(g_cnt) 
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION q135_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_apa TO s_apa.* ATTRIBUTE(UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index,g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()  
         
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

            ON ACTION first
         CALL q135_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY                   
 
      ON ACTION previous
         CALL q135_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	     ACCEPT DISPLAY               
 
      ON ACTION jump
         CALL cl_set_act_visible("accept,cancel", TRUE)     
         CALL q135_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	     ACCEPT DISPLAY                  
 
      ON ACTION next
         CALL q135_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	     ACCEPT DISPLAY                  
 
      ON ACTION last
         CALL q135_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	     ACCEPT DISPLAY              
         
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds 
         CALL cl_on_idle()   
         CONTINUE DISPLAY    
 
      ON ACTION about        
         CALL cl_about()     
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()      
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
         
      ON ACTION cancel
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                                                                                         	
         CALL cl_set_head_visible("","AUTO")   
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

#FUNCTION q135_getday()   #FUB-D10110 mark
FUNCTION q135_getday(p_year,p_month)  #FUB-D10110 add
   DEFINE p_year     LIKE  type_file.num5  #FUB-D10110 add
   DEFINE p_month    LIKE  type_file.num5  #FUB-D10110 add
   DEFINE l_year     LIKE  type_file.num5
   DEFINE l_month    LIKE  type_file.num5
   DEFINE l_bdate    LIKE type_file.chr20
   DEFINE l_edate    LIKE type_file.chr20
   DEFINE bm         LIKE apa_file.apa02  #FUB-D10110 add
   DEFINE em         LIKE apa_file.apa02  #FUB-D10110 add
   
   #LET l_year = YEAR(g_today)    #FUB-D10110 mark
   #LET l_month = MONTH(g_today)  #FUB-D10110 mark
   LET l_year = p_year            #FUB-D10110 add
   LET l_month = p_month          #FUB-D10110 add
   LET l_bdate = l_year USING '<<<<','/',l_month USING '<<','/01'
   CASE 
      WHEN (l_month = '1' OR l_month = '3' OR l_month = '5' OR l_month = '7' OR 
           l_month = '8' OR l_month = '10' OR l_month = '12' )
         LET l_edate  = l_year USING '<<<<','/',l_month USING '<<','/31'
      WHEN (l_month = '4' OR l_month = '6' OR l_month = '9' OR l_month = '11')
         LET l_edate  = l_year USING '<<<<','/',l_month USING '<<','/30'                 
      WHEN  (l_month = '2')  
         IF (l_year MOD 4 = 0 AND l_year MOD 100 !=0) OR (l_year MOD 400 = 0) THEN
            LET l_edate  = l_year USING '<<<<','/0',l_month USING '<<','/29'
         ELSE
            LET l_edate  = l_year USING '<<<<','/0',l_month USING '<<','/28'
         END IF
   END CASE   
   #LET tm.bm = l_bdate  #FUB-D10110 mark
   #LET tm.em = l_edate  #FUB-D10110 mark
   LET bm = l_bdate      #FUB-D10110 add
   LET em = l_edate      #FUB-D10110 add
   RETURN bm,em          #FUB-D10110 add
END FUNCTION 

FUNCTION q135_table()
   DROP TABLE q135_tmp;
   CREATE TEMP TABLE q135_tmp(
       apa05      LIKE apa_file.apa05,
       apb12      LIKE apb_file.apb12,
       apa02      LIKE apa_file.apa02,
       apa00      LIKE apa_file.apa00,
       apa01      LIKE apa_file.apa01,
       apb02      LIKE apb_file.apb02,
       apb21      LIKE apb_file.apb21,
       apb22      LIKE apb_file.apb22,
       rvv87      LIKE rvv_file.rvv87,
       rvv39      LIKE rvv_file.rvv39,
       apa13      LIKE apa_file.apa13, #FUN-D10110
       apa14      LIKE apa_file.apa14, #FUN-D10110
       apa14_c    LIKE apa_file.apa14, #FUN-D10110
       apb09      LIKE apb_file.apb09,
       apb24      LIKE apb_file.apb24, #FUN-D10110
       apb10      LIKE apb_file.apb10,
       apa01_c    LIKE apa_file.apa01,
       apb02_c    LIKE apb_file.apb02,
       apb09_c    LIKE apb_file.apb09,
       apb24_c    LIKE apb_file.apb24, #FUN-D10110
       apb10_c    LIKE apb_file.apb10,
       num1       LIKE apb_file.apb09,
       amt1       LIKE apb_file.apb10,
       num2       LIKE apb_file.apb09,
       amt3       LIKE apb_file.apb24, #FUN-D10110
       amt2       LIKE apb_file.apb10,
       diff       LIKE apb_file.apb24, #FUN-D10110
       rowno      LIKE type_file.num10);
END FUNCTION 


	
	
