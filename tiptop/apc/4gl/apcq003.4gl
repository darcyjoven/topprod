# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: apcq003.4gl
# Descriptions...: POS上傳資料檢查查詢作業
# Date & Author..: NO.FUN-CA0103 12/10/18 By xumeimei 
# Modify.........: No:MOD-D40081 13/04/12 By SunLM 按日期降序排列數據
# Modify.........: No:FUN-D40055 13/04/15 By dongsz 增加日期區間，單身顯示資料調整
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  tm      RECORD
                azw01         STRING,
                date          STRING,             
                bdate         LIKE type_file.dat,   #FUN-D40055 add
                edate         LIKE type_file.dat,   #FUN-D40055 add 
                source        LIKE type_file.chr1
                END RECORD   
DEFINE  g_shop  DYNAMIC ARRAY OF RECORD
                shop          LIKE azw_file.azw01,
                name          LIKE rtz_file.rtz13,
                date          LIKE type_file.dat,
                type          LIKE type_file.chr1,
                pos           LIKE type_file.chr2,
                uerp          LIKE type_file.num10,
                erp           LIKE type_file.num10,
                show          LIKE type_file.chr1000 
                END RECORD
DEFINE  g_shop_attr DYNAMIC ARRAY OF RECORD  #屬性，欄位必須與g_table1一樣
                shop          STRING,
                name          STRING,       
                date          STRING,
                type          STRING,
                pos           STRING,
                uerp          STRING,
                erp           STRING,
                show          STRING
                END RECORD
DEFINE g_cnt                  LIKE type_file.num10
DEFINE g_sql                  STRING 
DEFINE g_curs_index           LIKE type_file.num10
DEFINE g_row_count            LIKE type_file.num10
DEFINE g_wc                   STRING
DEFINE l_table                STRING
DEFINE g_azw01                STRING
DEFINE g_bdate                STRING
DEFINE g_edate                STRING               #FUN-D40055 add
DEFINE g_msg                  LIKE ze_file.ze03    #FUN-D40055 add
TYPE    sr1_t   RECORD
   shop         LIKE azw_file.azw01,
   edate        LIKE type_file.dat,
   type         LIKE type_file.chr1,
   pos          LIKE type_file.chr2,
   uerp         LIKE type_file.num10,
   erp          LIKE type_file.num10,
   name         LIKE rtz_file.rtz13,
   show         LIKE type_file.chr1000
END RECORD
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT          
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   LET g_pdate = g_today
   LET g_sql ="shop.azw_file.azw01,",
              "edate.type_file.dat,",
              "type.type_file.chr1,",
              "pos.type_file.chr2,",
              "uerp.type_file.num10,",
              "erp.type_file.num10,",
              "name.rtz_file.rtz13,",
              "show.type_file.chr1000"
   LET l_table = cl_prt_temptable('apcq003',g_sql) CLIPPED
   IF l_table = -1 THEN
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,? )"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   OPEN WINDOW q003_w WITH FORM "apc/42f/apcq003"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()   
 
   LET g_action_choice = ""
   CALL q003_q()
   CALL q003_menu()
 
   CLOSE WINDOW q003_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
   CALL cl_gre_drop_temptable(l_table)
END MAIN
 
FUNCTION q003_curs()
  #CLEAR FORM                    #FUN-D40055 mark
   CALL g_shop.clear()

   DIALOG ATTRIBUTES(UNBUFFERED) 
   CONSTRUCT BY NAME tm.azw01 ON azw01
                         
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
 
           ON ACTION controlp
              CASE
                 WHEN INFIELD(azw01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_ryg01"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.where = " ryg01 IN ",g_auth
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    LET tm.azw01 = g_qryparam.multiret
                    DISPLAY tm.azw01 TO azw01
                    NEXT FIELD azw01 
              END CASE
        AFTER CONSTRUCT
           LET g_azw01 = GET_FLDBUF(azw01)
   END CONSTRUCT
  #FUN-D40055--mark--str---
  #CONSTRUCT BY NAME tm.date ON bdate
  #    BEFORE CONSTRUCT
  #        CALL cl_qbe_init()

  #    AFTER CONSTRUCT
  #        LET g_bdate = GET_FLDBUF(bdate)
  #END CONSTRUCT
  #FUN-D40055--mark--str---

   INPUT BY NAME tm.source,tm.bdate,tm.edate ATTRIBUTE(WITHOUT DEFAULTS=TRUE)   #FUN-D40055 add tm.bdate,tm.edate

     #FUN-D40055--add--str---
      AFTER FIELD bdate
         IF NOT cl_null(tm.bdate) AND NOT cl_null(tm.edate) THEN
            IF tm.bdate > tm.edate THEN
               CALL cl_err('',"alm1038",0)
               NEXT FIELD bdate
            END IF
         END IF

      AFTER FIELD edate
         IF NOT cl_null(tm.bdate) AND NOT cl_null(tm.edate) THEN
            IF tm.bdate > tm.edate THEN
               CALL cl_err('',"alm1038",0)
               NEXT FIELD edate
            END IF
         END IF 
            
      AFTER INPUT
         LET g_bdate = GET_FLDBUF(bdate)
         LET g_edate = GET_FLDBUF(edate)
     #FUN-D40055--add--end---
   END INPUT
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

   ON ACTION close
      LET INT_FLAG=1
      EXIT DIALOG 

   ON ACTION ACCEPT
     #FUN-D40055--mark--str---
     #IF cl_null(tm.azw01) OR tm.azw01 = " 1=1" THEN
     #   CALL cl_err('','apc-198',0)    
     #   NEXT FIELD azw01              
     #END IF
     #FUN-D40055--mark--end---
      IF cl_null(tm.source) THEN
         NEXT FIELD source
      END IF
      ACCEPT DIALOG

   ON ACTION cancel
      LET INT_FLAG = 1
      EXIT DIALOG 
   END DIALOG       
   IF INT_FLAG THEN
      RETURN
   END IF
END FUNCTION

FUNCTION q003_menu()
 
   WHILE TRUE
      CALL q003_bp("G")

   CASE g_action_choice

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q003_q()
            END IF

         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q003_out()
            END IF

         WHEN "unupload"
            IF cl_chk_act_auth() THEN
               CALL q003_up()
            END IF

         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "locale"
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()

         WHEN "g_idle_seconds"
            CALL cl_on_idle()
            CONTINUE WHILE

         WHEN "about"
            CALL cl_about()

         WHEN "close"
            LET INT_FLAG = FALSE
            LET g_action_choice = "exit"
            EXIT WHILE
    
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_shop),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION q003_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1
DEFINE   l_ac   INTEGER
   IF p_ud <> "G"  THEN
      RETURN
   END IF

   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
 

   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_shop TO s_shop.* ATTRIBUTE(COUNT = g_cnt)
        BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )
          CALL DIALOG.setArrayAttributes("s_shop",g_shop_attr)    #参数：屏幕变量,属性数组

      END DISPLAY

      ON ACTION query
         LET g_action_choice="query"
         LET g_azw01 = GET_FLDBUF(azw01)
         LET g_bdate = GET_FLDBUF(bdate)
         LET g_edate = GET_FLDBUF(edate)          #FUN-D40055 add
         EXIT DIALOG

      ON ACTION HELP
         LET g_action_choice="help"
         EXIT DIALOG

      ON ACTION unupload
         LET g_action_choice="unupload"
         EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION EXIT
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION OUTPUT
         LET g_action_choice="output"
         EXIT DIALOG

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

      ON ACTION ACCEPT
         EXIT DIALOG

      ON ACTION CANCEL
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about
         CALL cl_about()

      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DIALOG
     
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q003_q()
DEFINE l_rcj10       LIKE rcj_file.rcj10    #FUN-D40055 add
    LET  g_row_count = 0
    LET  g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)

    INITIALIZE tm.* TO NULL
    LET tm.azw01 = NULL 
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_shop.clear()
   #FUN-D40055--add--str---
    LET tm.source = '0'
    LET tm.edate = g_today
    SELECT rcj10 INTO l_rcj10 FROM rcj_file
    LET tm.bdate = g_today - l_rcj10
    DISPLAY tm.source TO source
    DISPLAY tm.bdate TO bdate
    DISPLAY tm.edate TO edate
   #FUN-D40055--add--end--- 
    DISPLAY ' ' TO FORMONLY.cnt
   
    CALL q003_curs()  
         
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       INITIALIZE tm.* TO NULL
       RETURN
    END IF
    CALL q003_show()
END FUNCTION
 
FUNCTION q003_show()
    CALL cl_show_fld_cont()      
   #FUN-D40055--add--str---
    CALL q003_ins_table()
    IF NOT cl_null(tm.bdate) AND NOT cl_null(tm.edate) THEN
       IF tm.source <> '1' THEN
          CALL q003_ins_table_1()
       END IF
    END IF
   #FUN-D40055--add--end---
    CALL q003_b_fill()   
END FUNCTION

#FUN-D40055--add--str---
FUNCTION q003_ins_table()
DEFINE sr   RECORD
            shop         LIKE azw_file.azw01,
            edate        LIKE type_file.dat,
            type         LIKE type_file.chr1,
            pos          LIKE type_file.chr2,
            uerp         LIKE type_file.num10,
            erp          LIKE type_file.num10,
            name         LIKE rtz_file.rtz13,
            SHOW         LIKE type_file.chr1000
            END RECORD
DEFINE l_posdb       LIKE ryg_file.ryg00
DEFINE l_posdb_link  LIKE ryg_file.ryg02
DEFINE l_azw01       LIKE azw_file.azw01
DEFINE l_date        STRING
DEFINE l_fdate       LIKE type_file.dat
DEFINE l_erp         LIKE type_file.num10
DEFINE l_uerp        LIKE type_file.num10
DEFINE l_pos         LIKE type_file.num10
DEFINE l_sql2        STRING
DEFINE l_sql3        STRING
DEFINE l_sql4        STRING
DEFINE l_sql         STRING
DEFINE l_sql1        STRING
DEFINE l_bdate       STRING     
DEFINE l_edate       STRING    

   CALL cl_del_data(l_table)
   IF cl_null(tm.azw01) THEN
      LET tm.azw01 = " 1=1"
   END IF
   LET tm.azw01 = tm.azw01," AND azw01 IN (SELECT ryg01 FROM ryg_file WHERE rygacti = 'Y') "
   IF cl_null(tm.bdate) AND NOT cl_null(tm.edate) THEN
      LET l_edate = DATE(tm.edate) USING "yyyymmdd"    
      LET tm.date = " BDATE <= '",l_edate,"' "
   END IF
   IF NOT cl_null(tm.bdate) THEN
      IF cl_null(tm.edate) THEN
         LET tm.edate = g_today
         LET l_edate = DATE(tm.edate) USING "yyyymmdd"    
      END IF
      LET l_bdate = DATE(tm.bdate) USING "yyyymmdd"     
      LET l_edate = DATE(tm.edate) USING "yyyymmdd"    
      LET tm.date = " BDATE BETWEEN '",l_bdate,"' AND '",l_edate,"' " 
   END IF
   IF cl_null(tm.date) THEN
      LET tm.date = " 1=1"
   ELSE
      LET tm.date = cl_replace_str(tm.date,"bdate","CAST( bdate AS date )")
   END IF   
   SELECT DISTINCT ryg00,ryg02 INTO l_posdb,l_posdb_link FROM ryg_file WHERE ryg00='ds_pos1'
   LET l_posdb=s_dbstring(l_posdb)
   LET l_posdb_link=q003_dblinks(l_posdb_link)
   LET l_sql = "SELECT DISTINCT azw01 FROM azw_file ",
               "  WHERE ",tm.azw01 CLIPPED,
               "    AND azw01 IN ",g_auth
   PREPARE q003_azw01_pre2 FROM l_sql
   DECLARE q003_azw01_cs2 CURSOR FOR q003_azw01_pre2
   FOREACH q003_azw01_cs2 INTO l_azw01
      LET l_sql4 = " SELECT DISTINCT BDATE ",
                   "   FROM ",l_posdb,"td_Sale",l_posdb_link,
                   "  WHERE SHOP = '",l_azw01,"'",
                   "    AND ",tm.date CLIPPED,
                   "  UNION SELECT DISTINCT BDATE",
                   "   FROM ",l_posdb,"td_InvoiceDetail",l_posdb_link,
                   "  WHERE SHOP = '",l_azw01,"'",
                   "    AND ",tm.date CLIPPED ," ORDER BY 1 DESC " #MOD-D40081 add desc
      PREPARE q003_edate_pre1 FROM l_sql4
      DECLARE q003_edate_cs1 CURSOR FOR q003_edate_pre1
      FOREACH q003_edate_cs1 INTO l_fdate
      IF NOT cl_null(l_fdate) THEN
         LET l_date = DATE(l_fdate) USING "yyyymmdd"
      END IF
      CASE
         #全部
         WHEN tm.Source = '0'

            LET l_sql1 = " SELECT COUNT(*)",
                         "   FROM ",l_posdb,"ta_DateEnd",l_posdb_link,
                         "  WHERE SHOP = '",l_azw01,"'",
                         "    AND EDATE = '",l_date,"'"
            PREPARE q003_pos_pre1 FROM l_sql1
            EXECUTE q003_pos_pre1 INTO l_pos
            LET l_sql2 = " SELECT COUNT(*)",
                         "   FROM ",l_posdb,"td_Sale",l_posdb_link,
                         "  WHERE SHOP = '",l_azw01,"'",
                         "    AND CONDITION2 <> 'Y'",
                         "    AND BDATE = '",l_date,"'",
                         "  UNION ALL SELECT COUNT(*)",
                         "   FROM ",l_posdb,"td_InvoiceDetail",l_posdb_link,
                         "  WHERE SHOP = '",l_azw01,"'",
                         "    AND CONDITION2 <> 'Y'",
                         "    AND BDATE = '",l_date,"'"
            PREPARE q003_uerp_pre1 FROM l_sql2
            EXECUTE q003_uerp_pre1 INTO l_uerp
            LET l_sql3 = " SELECT COUNT(*)",
                         "   FROM ",l_posdb,"td_Sale",l_posdb_link,
                         "  WHERE SHOP = '",l_azw01,"'",
                         "    AND BDATE = '",l_date,"'",
                         "    AND CONDITION2 = 'Y'",
                         "  UNION ALL SELECT COUNT(*)",
                         "   FROM ",l_posdb,"td_InvoiceDetail",l_posdb_link,
                         "  WHERE SHOP = '",l_azw01,"'",
                         "    AND CONDITION2 = 'Y'",
                         "    AND BDATE = '",l_date,"'"
            PREPARE q003_erp_pre1 FROM l_sql3
            EXECUTE q003_erp_pre1 INTO l_erp
            IF l_pos > 0  AND l_uerp = 0 THEN
               LET sr.pos = 'Y'
               LET sr.uerp = l_uerp
               LET sr.erp = l_erp
               LET sr.TYPE = '1'
               LET sr.show = cl_gr_getmsg("gre-311",g_lang,0)
            END IF
            IF l_pos = 0  OR l_uerp > 0 THEN
               IF l_pos = 0 THEN
                  LET sr.pos = 'N'
               ELSE
                  LET sr.pos = 'Y'
               END IF
               LET sr.uerp = l_uerp
               LET sr.erp = l_erp
               LET sr.TYPE = '2'
               IF sr.pos = 'N' AND sr.uerp > 0 THEN
                  LET sr.show = cl_gr_getmsg("gre-311",g_lang,1)
               END IF
               IF sr.pos = 'N' AND sr.uerp = 0 THEN
                  LET sr.show = cl_gr_getmsg("gre-311",g_lang,2)
               END IF
               IF sr.pos = 'Y' AND sr.uerp > 0 THEN
                  LET sr.show = cl_gr_getmsg("gre-311",g_lang,3)
               END IF
            END IF
         #已完成
         WHEN tm.Source = '1'
            LET l_sql1 = " SELECT COUNT(*)",
                         "   FROM ",l_posdb,"ta_DateEnd",l_posdb_link,
                         "  WHERE SHOP = '",l_azw01,"'",
                         "    AND EDATE = '",l_date,"'"
            PREPARE q003_pos1_pre1 FROM l_sql1
            EXECUTE q003_pos1_pre1 INTO l_pos
            LET l_sql2 = " SELECT COUNT(*)",
                         "   FROM ",l_posdb,"td_Sale",l_posdb_link,
                         "  WHERE SHOP = '",l_azw01,"'",
                         "    AND BDATE = '",l_date,"'",
                         "    AND CONDITION2 <> 'Y'",
                         "  UNION ALL SELECT COUNT(*)",
                         "   FROM ",l_posdb,"td_InvoiceDetail",l_posdb_link,
                         "  WHERE SHOP = '",l_azw01,"'",
                         "    AND CONDITION2 <> 'Y'",
                         "    AND BDATE = '",l_date,"'"
            PREPARE q003_uerp1_pre1 FROM l_sql2
            EXECUTE q003_uerp1_pre1 INTO l_uerp
            LET l_sql3 = " SELECT COUNT(*)",
                         "   FROM ",l_posdb,"td_Sale",l_posdb_link,
                         "  WHERE SHOP = '",l_azw01,"'",
                         "    AND BDATE = '",l_date,"'",
                         "    AND CONDITION2 = 'Y'",
                         "  UNION ALL SELECT COUNT(*)",
                         "   FROM ",l_posdb,"td_InvoiceDetail",l_posdb_link,
                         "  WHERE SHOP = '",l_azw01,"'",
                         "    AND CONDITION2 = 'Y'",
                         "    AND BDATE = '",l_date,"'"
            PREPARE q003_erp1_pre1 FROM l_sql3
            EXECUTE q003_erp1_pre1 INTO l_erp
            IF l_pos > 0  AND l_uerp = 0 THEN
               LET sr.pos = 'Y'
               LET sr.uerp = l_uerp
               LET sr.erp = l_erp
               LET sr.TYPE = '1'
               LET sr.show = cl_gr_getmsg("gre-311",g_lang,0)
            END IF
         #未完成
         WHEN tm.Source = '2'
            LET l_sql1 = " SELECT COUNT(*)",
                         "   FROM ",l_posdb,"ta_DateEnd",l_posdb_link,
                         "  WHERE SHOP = '",l_azw01,"'",
                         "    AND EDATE = '",l_date,"'"
            PREPARE q003_pos2_pre1 FROM l_sql1
            EXECUTE q003_pos2_pre1 INTO l_pos
            LET l_sql2 = " SELECT COUNT(*)",
                         "   FROM ",l_posdb,"td_Sale",l_posdb_link,
                         "  WHERE SHOP = '",l_azw01,"'",
                         "    AND BDATE = '",l_date,"'",
                         "    AND CONDITION2 <> 'Y'",
                         "  UNION ALL SELECT COUNT(*)",
                         "   FROM ",l_posdb,"td_InvoiceDetail",l_posdb_link,
                         "  WHERE SHOP = '",l_azw01,"'",
                         "    AND CONDITION2 <> 'Y'",
                         "    AND BDATE = '",l_date,"'"
            PREPARE q003_uerp2_pre1 FROM l_sql2
            EXECUTE q003_uerp2_pre1 INTO l_uerp
            LET l_sql3 = " SELECT COUNT(*)",
                         "   FROM ",l_posdb,"td_Sale",l_posdb_link,
                         "  WHERE SHOP = '",l_azw01,"'",
                         "    AND BDATE = '",l_date,"'",
                         "    AND CONDITION2 = 'Y'",
                         "  UNION ALL SELECT COUNT(*)",
                         "   FROM ",l_posdb,"td_InvoiceDetail",l_posdb_link,
                         "  WHERE SHOP = '",l_azw01,"'",
                         "    AND CONDITION2 = 'Y'",
                         "    AND BDATE = '",l_date,"'"
            PREPARE q003_erp2_pre1 FROM l_sql3
            EXECUTE q003_erp2_pre1 INTO l_erp
            IF l_pos = 0  OR l_uerp > 0 THEN
               IF l_pos = 0 THEN
                  LET sr.pos = 'N'
               ELSE
                  LET sr.pos = 'Y'
               END IF
               LET sr.uerp = l_uerp
               LET sr.erp = l_erp
               LET sr.TYPE = '2'
               IF sr.pos = 'N' AND sr.uerp > 0 THEN
                  LET sr.show = cl_gr_getmsg("gre-311",g_lang,1)
               END IF
               IF sr.pos = 'N' AND sr.uerp = 0 THEN
                  LET sr.show = cl_gr_getmsg("gre-311",g_lang,2)
               END IF
               IF sr.pos = 'Y' AND sr.uerp > 0 THEN
                  LET sr.show = cl_gr_getmsg("gre-311",g_lang,3)
               END IF
            END IF
      END CASE
      LET sr.shop = l_azw01
      SELECT rtz13 INTO sr.NAME
        FROM rtz_file
       WHERE rtz01 = sr.shop
      LET sr.edate = l_date
      EXECUTE insert_prep USING sr.*
      END FOREACH
   END FOREACH
 
END FUNCTION       

FUNCTION q003_ins_table_1()
DEFINE l_azw01       LIKE azw_file.azw01
DEFINE l_rtz13       LIKE rtz_file.rtz13
DEFINE l_sql         STRING
DEFINE l_sql1        STRING

   LET g_msg = cl_getmsg("apc-224",g_lang)

   LET l_sql = " INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " SELECT DISTINCT azw01,azn01,'2','N',0,0,rtz13,'",g_msg,"' ",
               "   FROM azn_file,azw_file,rtz_file ",
               "  WHERE azn01 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
               "    AND azw01 = rtz01 ",
               "    AND NOT EXISTS ( SELECT 1 FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," WHERE shop = azw01 AND edate = azn01)",
               "    AND ",tm.azw01 CLIPPED,
               "    AND azw01 IN ",g_auth
   PREPARE ins_table_pre FROM l_sql
   EXECUTE ins_table_pre
   IF STATUS OR SQLCA.sqlcode THEN
      CALL cl_err('INSERT',SQLCA.sqlcode,1)
      RETURN
   END IF 

END FUNCTION
#FUN-D40055--add--end---

FUNCTION q003_b_fill()
   #FUN-D40055--mark--str---
   #DEFINE l_posdb       LIKE ryg_file.ryg00  
   #DEFINE l_posdb_link  LIKE ryg_file.ryg02
   #DEFINE l_azw01       LIKE azw_file.azw01
   #DEFINE l_date        STRING
   #DEFINE l_fdate       LIKE type_file.dat
   #DEFINE l_erp         LIKE type_file.num10
   #DEFINE l_uerp        LIKE type_file.num10
   #DEFINE l_pos         LIKE type_file.num10
   #DEFINE l_sql2        STRING
   #DEFINE l_sql3        STRING
   #DEFINE l_sql4        STRING
   #DEFINE l_sql         STRING
   #DEFINE l_sql1        STRING
   #FUN-D40055--mark--end---
    DEFINE l_sql         STRING                 #FUN-D40055 add    
 
    CALL g_shop.clear()  
    LET g_cnt = 1

   #FUN-D40055--add--str---
    LET l_sql = " SELECT shop,name,edate,type,pos,uerp,erp,show FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                "  ORDER BY shop,edate DESC"
    PREPARE q003_sel_pre FROM l_sql
    DECLARE q003_sql_cs  CURSOR FOR q003_sel_pre
    FOREACH q003_sql_cs  INTO g_shop[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF g_shop[g_cnt].pos = 'N' OR g_shop[g_cnt].uerp > 0 THEN
          LET g_shop_attr[g_cnt].shop = "red reverse"
          LET g_shop_attr[g_cnt].name = "red reverse"
          LET g_shop_attr[g_cnt].date = "red reverse"
          LET g_shop_attr[g_cnt].type = "red reverse"
          LET g_shop_attr[g_cnt].pos  = "red reverse"
          LET g_shop_attr[g_cnt].uerp = "red reverse"
          LET g_shop_attr[g_cnt].erp  = "red reverse"
          LET g_shop_attr[g_cnt].show = "red reverse"
       END IF 
       LET g_cnt = g_cnt + 1 
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
   #FUN-D40055--add--end---

  #FUN-D40055--mark--str---
  # IF cl_null(tm.date) THEN
  #    LET tm.date = " 1=1"
  # ELSE
  #    LET tm.date = cl_replace_str(tm.date,"bdate","CAST( bdate AS date )")
  # END IF
  # SELECT DISTINCT ryg00,ryg02 INTO l_posdb,l_posdb_link FROM ryg_file WHERE ryg00='ds_pos1'
  # LET l_posdb=s_dbstring(l_posdb)
  # LET l_posdb_link=q003_dblinks(l_posdb_link)
  # LET l_sql = "SELECT DISTINCT azw01 FROM azw_file ",
  #             "  WHERE ",tm.azw01 CLIPPED,
  #             "    AND azw01 IN ",g_auth
  # PREPARE q003_azw01_pre FROM l_sql
  # DECLARE q003_azw01_cs CURSOR FOR q003_azw01_pre
  # FOREACH q003_azw01_cs INTO l_azw01
  #    LET l_sql4 = " SELECT DISTINCT BDATE ",
  #                 "   FROM ",l_posdb,"td_Sale",l_posdb_link,
  #                 "  WHERE SHOP = '",l_azw01,"'",
  #                 "    AND ",tm.date CLIPPED,                         
  #                 "  UNION SELECT DISTINCT BDATE",
  #                 "   FROM ",l_posdb,"td_InvoiceDetail",l_posdb_link,
  #                 "  WHERE SHOP = '",l_azw01,"'",
  #                 "    AND ",tm.date CLIPPED," ORDER BY 1 DESC " #MOD-D40081 add desc 
  #    PREPARE q003_edate_pre FROM l_sql4
  #    DECLARE q003_edate_cs CURSOR FOR q003_edate_pre 
  #    FOREACH q003_edate_cs INTO l_fdate
  #    IF NOT cl_null(l_fdate) THEN
  #      LET l_date = DATE(l_fdate) USING "yyyymmdd" 
  #    END IF
  #       CASE 
  #           #全部       
  #           WHEN tm.Source = '0'
  #              LET l_sql1 = " SELECT COUNT(*)",
  #                           "   FROM ",l_posdb,"ta_DateEnd",l_posdb_link,
  #                           "  WHERE SHOP = '",l_azw01,"'",
  #                           "    AND EDATE = '",l_date,"'"
  #              PREPARE q003_pos_pre FROM l_sql1
  #              EXECUTE q003_pos_pre INTO l_pos
  #              LET l_sql2 = " SELECT COUNT(*)",
  #                           "   FROM ",l_posdb,"td_Sale",l_posdb_link,
  #                           "  WHERE SHOP = '",l_azw01,"'",
  #                           "    AND BDATE = '",l_date,"'",
  #                           "    AND CONDITION2 <> 'Y'",
  #                           "  UNION ALL SELECT COUNT(*)",
  #                           "   FROM ",l_posdb,"td_InvoiceDetail",l_posdb_link,
  #                           "  WHERE SHOP = '",l_azw01,"'",
  #                           "    AND CONDITION2 <> 'Y'",
  #                           "    AND BDATE = '",l_date,"'"
  #              PREPARE q003_uerp_pre FROM l_sql2
  #              EXECUTE q003_uerp_pre INTO l_uerp
  #              LET l_sql3 = " SELECT COUNT(*)",
  #                           "   FROM ",l_posdb,"td_Sale",l_posdb_link,
  #                           "  WHERE SHOP = '",l_azw01,"'",
  #                           "    AND BDATE = '",l_date,"'",
  #                           "    AND CONDITION2 = 'Y'",
  #                           "  UNION ALL SELECT COUNT(*)",
  #                           "   FROM ",l_posdb,"td_InvoiceDetail",l_posdb_link,
  #                           "  WHERE SHOP = '",l_azw01,"'",
  #                           "    AND CONDITION2 = 'Y'",
  #                           "    AND BDATE = '",l_date,"'"
  #              PREPARE q003_erp_pre FROM l_sql3
  #              EXECUTE q003_erp_pre INTO l_erp
  #              IF l_pos > 0  AND l_uerp = 0 THEN
  #                 LET g_shop[g_cnt].pos = 'Y'
  #                 LET g_shop[g_cnt].uerp = l_uerp
  #                 LET g_shop[g_cnt].erp = l_erp
  #                 LET g_shop[g_cnt].TYPE = '1'
  #                 LET g_shop[g_cnt].show = cl_gr_getmsg("gre-311",g_lang,0)
  #              END IF
  #              IF l_pos = 0  OR l_uerp > 0 THEN
  #                 IF l_pos = 0 THEN
  #                    LET g_shop[g_cnt].pos = 'N'
  #                 ELSE
  #                    LET g_shop[g_cnt].pos = 'Y'
  #                 END IF
  #                 LET g_shop[g_cnt].uerp = l_uerp
  #                 LET g_shop[g_cnt].erp = l_erp
  #                 LET g_shop[g_cnt].TYPE = '2'
  #                 LET g_shop_attr[g_cnt].shop = "red reverse"
  #                 LET g_shop_attr[g_cnt].name = "red reverse"
  #                 LET g_shop_attr[g_cnt].date = "red reverse"
  #                 LET g_shop_attr[g_cnt].type = "red reverse"
  #                 LET g_shop_attr[g_cnt].pos = "red reverse"
  #                 LET g_shop_attr[g_cnt].uerp = "red reverse"
  #                 LET g_shop_attr[g_cnt].erp = "red reverse"
  #                 LET g_shop_attr[g_cnt].show = "red reverse"
  #                 IF g_shop[g_cnt].pos = 'N' AND g_shop[g_cnt].uerp > 0 THEN
  #                    LET g_shop[g_cnt].show = cl_gr_getmsg("gre-311",g_lang,1)
  #                 END IF
  #                 IF g_shop[g_cnt].pos = 'N' AND g_shop[g_cnt].uerp = 0 THEN
  #                    LET g_shop[g_cnt].show = cl_gr_getmsg("gre-311",g_lang,2)
  #                 END IF
  #                 IF g_shop[g_cnt].pos = 'Y' AND g_shop[g_cnt].uerp > 0 THEN
  #                    LET g_shop[g_cnt].show = cl_gr_getmsg("gre-311",g_lang,3)
  #                 END IF
  #              END IF
  #           #已完成
  #           WHEN tm.Source = '1'
  #              LET l_sql1 = " SELECT COUNT(*)",
  #                           "   FROM ",l_posdb,"ta_DateEnd",l_posdb_link,
  #                           "  WHERE SHOP = '",l_azw01,"'",
  #                           "    AND EDATE = '",l_date,"'"
  #              PREPARE q003_pos1_pre FROM l_sql1
  #              EXECUTE q003_pos1_pre INTO l_pos
  #              LET l_sql2 = " SELECT COUNT(*)",
  #                           "   FROM ",l_posdb,"td_Sale",l_posdb_link,
  #                           "  WHERE SHOP = '",l_azw01,"'",
  #                           "    AND BDATE = '",l_date,"'",
  #                           "    AND CONDITION2 <> 'Y'",
  #                           "  UNION ALL SELECT COUNT(*)",
  #                           "   FROM ",l_posdb,"td_InvoiceDetail",l_posdb_link,
  #                           "  WHERE SHOP = '",l_azw01,"'",
  #                           "    AND CONDITION2 <> 'Y'",
  #                           "    AND BDATE = '",l_date,"'"
  #              PREPARE q003_uerp1_pre FROM l_sql2
  #              EXECUTE q003_uerp1_pre INTO l_uerp
  #              LET l_sql3 = " SELECT COUNT(*)",
  #                           "   FROM ",l_posdb,"td_Sale",l_posdb_link,
  #                           "  WHERE SHOP = '",l_azw01,"'",
  #                           "    AND BDATE = '",l_date,"'",
  #                           "    AND CONDITION2 = 'Y'",
  #                           "  UNION ALL SELECT COUNT(*)",
  #                           "   FROM ",l_posdb,"td_InvoiceDetail",l_posdb_link,
  #                           "  WHERE SHOP = '",l_azw01,"'",
  #                           "    AND CONDITION2 = 'Y'",
  #                           "    AND BDATE = '",l_date,"'"
  #              PREPARE q003_erp1_pre FROM l_sql3
  #              EXECUTE q003_erp1_pre INTO l_erp
  #              IF l_pos > 0  AND l_uerp = 0 THEN
  #                 LET g_shop[g_cnt].pos = 'Y'
  #                 LET g_shop[g_cnt].uerp = l_uerp
  #                 LET g_shop[g_cnt].erp = l_erp
  #                 LET g_shop[g_cnt].TYPE = '1'
  #                 LET g_shop[g_cnt].show = cl_gr_getmsg("gre-311",g_lang,0)
  #              END IF
  #           #未完成
  #           WHEN tm.Source = '2' 
  #              LET l_sql1 = " SELECT COUNT(*)",
  #                           "   FROM ",l_posdb,"ta_DateEnd",l_posdb_link,
  #                           "  WHERE SHOP = '",l_azw01,"'",
  #                           "    AND EDATE = '",l_date,"'"
  #              PREPARE q003_pos2_pre FROM l_sql1
  #              EXECUTE q003_pos2_pre INTO l_pos
  #              LET l_sql2 = " SELECT COUNT(*)",
  #                           "   FROM ",l_posdb,"td_Sale",l_posdb_link,
  #                           "  WHERE SHOP = '",l_azw01,"'",
  #                           "    AND BDATE = '",l_date,"'",
  #                           "    AND CONDITION2 <> 'Y'",
  #                           "  UNION ALL SELECT COUNT(*)",
  #                           "   FROM ",l_posdb,"td_InvoiceDetail",l_posdb_link,
  #                           "  WHERE SHOP = '",l_azw01,"'",
  #                           "    AND CONDITION2 <> 'Y'",
  #                           "    AND BDATE = '",l_date,"'"
  #              PREPARE q003_uerp2_pre FROM l_sql2
  #              EXECUTE q003_uerp2_pre INTO l_uerp
  #              LET l_sql3 = " SELECT COUNT(*)",
  #                           "   FROM ",l_posdb,"td_Sale",l_posdb_link,
  #                           "  WHERE SHOP = '",l_azw01,"'",
  #                           "    AND CONDITION2 = 'Y'",
  #                           "    AND BDATE = '",l_date,"'",
  #                           "  UNION ALL SELECT COUNT(*)",
  #                           "   FROM ",l_posdb,"td_InvoiceDetail",l_posdb_link,
  #                           "  WHERE SHOP = '",l_azw01,"'",
  #                           "    AND CONDITION2 = 'Y'",
  #                           "    AND BDATE = '",l_date,"'"
  #              PREPARE q003_erp2_pre FROM l_sql3
  #              EXECUTE q003_erp2_pre INTO l_erp
  #              IF l_pos = 0  OR l_uerp > 0 THEN
  #                 IF l_pos = 0 THEN
  #                    LET g_shop[g_cnt].pos = 'N'
  #                 ELSE
  #                    LET g_shop[g_cnt].pos = 'Y'
  #                 END IF
  #                 LET g_shop[g_cnt].uerp = l_uerp
  #                 LET g_shop[g_cnt].erp = l_erp
  #                 LET g_shop[g_cnt].TYPE = '2'
  #                 LET g_shop_attr[g_cnt].shop = "red reverse"
  #                 LET g_shop_attr[g_cnt].name = "red reverse"
  #                 LET g_shop_attr[g_cnt].date = "red reverse"
  #                 LET g_shop_attr[g_cnt].type = "red reverse"
  #                 LET g_shop_attr[g_cnt].pos = "red reverse"
  #                 LET g_shop_attr[g_cnt].uerp = "red reverse"
  #                 LET g_shop_attr[g_cnt].erp = "red reverse"
  #                 LET g_shop_attr[g_cnt].show = "red reverse"
  #                 IF g_shop[g_cnt].pos = 'N' AND g_shop[g_cnt].uerp > 0 THEN
  #                    LET g_shop[g_cnt].show = cl_gr_getmsg("gre-311",g_lang,1)
  #                 END IF
  #                 IF g_shop[g_cnt].pos = 'N' AND g_shop[g_cnt].uerp = 0 THEN
  #                    LET g_shop[g_cnt].show = cl_gr_getmsg("gre-311",g_lang,2)
  #                 END IF
  #                 IF g_shop[g_cnt].pos = 'Y' AND g_shop[g_cnt].uerp > 0 THEN
  #                    LET g_shop[g_cnt].show = cl_gr_getmsg("gre-311",g_lang,3)
  #                 END IF
  #              END IF
  #       END CASE 
  #    LET g_shop[g_cnt].shop = l_azw01
  #    SELECT rtz13 INTO g_shop[g_cnt].NAME 
  #      FROM rtz_file
  #     WHERE rtz01 = g_shop[g_cnt].shop
  #    LET g_shop[g_cnt].date = l_date
  #    LET g_cnt = g_cnt + 1
  #    IF g_cnt > g_max_rec THEN
  #       CALL cl_err( '', 9035, 0 )
  #       EXIT FOREACH
  #    END IF 
  #    END FOREACH
  #    IF g_cnt > g_max_rec THEN
  #       EXIT FOREACH
  #    END IF
  # END FOREACH
  #FUN-D40055--mark--end---
    CALL g_shop.deleteElement(g_cnt)
    
    LET g_cnt=g_cnt-1
    DISPLAY g_cnt TO FORMONLY.cnt
END FUNCTION

FUNCTION q003_up()
  DEFINE l_cmd          STRING
  DEFINE l_str          LIKE azw_file.azw01
  DEFINE l_str1         STRING
  DEFINE l_sql          STRING
  DEFINE l_str2         LIKE type_file.dat
  DEFINE l_str3         STRING
  DEFINE l_str4         STRING
  DEFINE l_posdb        LIKE ryg_file.ryg00
  DEFINE l_posdb_link   LIKE ryg_file.ryg02

  IF g_cnt = 0 THEN
     CALL cl_err('',-400,0)
     RETURN
  END IF
  LET l_sql = " SELECT DISTINCT azw01 FROM azw_file",
              "  WHERE ",tm.azw01 CLIPPED
  PREPARE q003_str_pre FROM l_sql
  DECLARE q003_str_cs CURSOR FOR q003_str_pre
  FOREACH q003_str_cs INTO l_str
     IF cl_null(l_str1) THEN
        LET l_str1 = l_str
     ELSE
        LET l_str1 = l_str1,',',l_str
     END IF
  END FOREACH
  SELECT DISTINCT ryg00,ryg02 INTO l_posdb,l_posdb_link FROM ryg_file WHERE ryg00='ds_pos1'
  LET l_posdb=s_dbstring(l_posdb)
  LET l_posdb_link=q003_dblinks(l_posdb_link)
  LET l_sql = " SELECT DISTINCT BDATE",
              "   FROM ",l_posdb,"td_Sale",l_posdb_link,
              "  WHERE CONDITION2 <> 'Y'",
              "    AND ",tm.date CLIPPED,           
              "  UNION ALL SELECT DISTINCT BDATE",
              "  FROM ",l_posdb,"td_InvoiceDetail",l_posdb_link,
              "  WHERE CONDITION2 <> 'Y'",
              "    AND ",tm.date CLIPPED           
  PREPARE q003_str1_pre FROM l_sql
  DECLARE q003_str1_cs CURSOR FOR q003_str1_pre
  FOREACH q003_str1_cs INTO l_str2
     IF NOT cl_null(l_str2) THEN
        LET l_str4 = l_str2 USING "yyyymmdd"
     END IF
     IF cl_null(l_str3) THEN
        LET l_str3 = l_str4
     ELSE
        LET l_str3 = l_str3,',',l_str4
     END IF
  END FOREACH
  IF g_cnt > 0 THEN
     LET l_cmd ="apcq002  '",l_str1 CLIPPED,"' '",l_str3 CLIPPED,"' '0' 'Y' '",g_azw01,"' '",g_bdate,"' '",g_edate,"'"   #FUN-D40055 add g_edate
     CALL cl_cmdrun(l_cmd)
     ERROR ''
  END IF
END FUNCTION

FUNCTION q003_dblinks(l_db_links)
DEFINE l_db_links LIKE ryg_file.ryg02

  IF l_db_links IS NULL OR l_db_links = ' ' THEN
     RETURN ' '
  ELSE
     LET l_db_links = '@',l_db_links CLIPPED
     RETURN l_db_links
  END IF

END FUNCTION

FUNCTION q003_out()
  #FUN-D40055--mark--str---
  #DEFINE sr    RECORD
  #             shop         LIKE azw_file.azw01,
  #             edate        LIKE type_file.dat,
  #             type         LIKE type_file.chr1,
  #             pos          LIKE type_file.chr2,
  #             uerp         LIKE type_file.num10,
  #             erp          LIKE type_file.num10,
  #             name         LIKE rtz_file.rtz13,
  #             SHOW         LIKE type_file.chr1000 
  #             END RECORD
  # DEFINE l_posdb       LIKE ryg_file.ryg00  
  # DEFINE l_posdb_link  LIKE ryg_file.ryg02
  # DEFINE l_azw01       LIKE azw_file.azw01 
  # DEFINE l_date        STRING
  # DEFINE l_fdate       LIKE type_file.dat
  # DEFINE l_erp         LIKE type_file.num10
  # DEFINE l_uerp        LIKE type_file.num10
  # DEFINE l_pos         LIKE type_file.num10
  # DEFINE l_sql2        STRING
  # DEFINE l_sql3        STRING
  # DEFINE l_sql4        STRING
  # DEFINE l_sql         STRING
  # DEFINE l_sql1        STRING

  # CALL cl_del_data(l_table)
  # SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
  # IF tm.date = " 1=1" THEN                                    
  #    LET g_wc = tm.azw01,"AND TYPE = ",tm.source
  # ELSE
  #    LET g_wc = tm.azw01,"AND",tm.date,"AND TYPE = ",tm.source 
  # END IF
  # SELECT DISTINCT ryg00,ryg02 INTO l_posdb,l_posdb_link FROM ryg_file WHERE ryg00='ds_pos1'
  # LET l_posdb=s_dbstring(l_posdb)
  # LET l_posdb_link=q003_dblinks(l_posdb_link)
  # LET l_sql = "SELECT DISTINCT azw01 FROM azw_file ",
  #             "  WHERE ",tm.azw01 CLIPPED,
  #             "    AND azw01 IN ",g_auth
  # PREPARE q003_azw01_pre1 FROM l_sql
  # DECLARE q003_azw01_cs1 CURSOR FOR q003_azw01_pre1
  # FOREACH q003_azw01_cs1 INTO l_azw01
  #    LET l_sql4 = " SELECT DISTINCT BDATE ",
  #                 "   FROM ",l_posdb,"td_Sale",l_posdb_link,
  #                 "  WHERE SHOP = '",l_azw01,"'",
  #                 "    AND ",tm.date CLIPPED,                   
  #                 "  UNION SELECT DISTINCT BDATE",
  #                 "   FROM ",l_posdb,"td_InvoiceDetail",l_posdb_link,
  #                 "  WHERE SHOP = '",l_azw01,"'",
  #                 "    AND ",tm.date CLIPPED ," ORDER BY 1 DESC " #MOD-D40081 add desc 
  #    PREPARE q003_edate_pre1 FROM l_sql4
  #    DECLARE q003_edate_cs1 CURSOR FOR q003_edate_pre1
  #    FOREACH q003_edate_cs1 INTO l_fdate
  #    IF NOT cl_null(l_fdate) THEN
  #      LET l_date = DATE(l_fdate) USING "yyyymmdd"
  #    END IF
  #       CASE 
  #           #全部       
  #           WHEN tm.Source = '0'
  #             
  #              LET l_sql1 = " SELECT COUNT(*)",
  #                           "   FROM ",l_posdb,"ta_DateEnd",l_posdb_link,
  #                           "  WHERE SHOP = '",l_azw01,"'",
  #                           "    AND EDATE = '",l_date,"'"
  #              PREPARE q003_pos_pre1 FROM l_sql1
  #              EXECUTE q003_pos_pre1 INTO l_pos
  #              LET l_sql2 = " SELECT COUNT(*)",
  #                           "   FROM ",l_posdb,"td_Sale",l_posdb_link,
  #                           "  WHERE SHOP = '",l_azw01,"'",
  #                           "    AND CONDITION2 <> 'Y'",
  #                           "    AND BDATE = '",l_date,"'",
  #                           "  UNION ALL SELECT COUNT(*)",
  #                           "   FROM ",l_posdb,"td_InvoiceDetail",l_posdb_link,
  #                           "  WHERE SHOP = '",l_azw01,"'",
  #                           "    AND CONDITION2 <> 'Y'",
  #                           "    AND BDATE = '",l_date,"'"
  #              PREPARE q003_uerp_pre1 FROM l_sql2
  #              EXECUTE q003_uerp_pre1 INTO l_uerp
  #              LET l_sql3 = " SELECT COUNT(*)",
  #                           "   FROM ",l_posdb,"td_Sale",l_posdb_link,
  #                           "  WHERE SHOP = '",l_azw01,"'",
  #                           "    AND BDATE = '",l_date,"'",
  #                           "    AND CONDITION2 = 'Y'",
  #                           "  UNION ALL SELECT COUNT(*)",
  #                           "   FROM ",l_posdb,"td_InvoiceDetail",l_posdb_link,
  #                           "  WHERE SHOP = '",l_azw01,"'",
  #                           "    AND CONDITION2 = 'Y'",
  #                           "    AND BDATE = '",l_date,"'"
  #              PREPARE q003_erp_pre1 FROM l_sql3
  #              EXECUTE q003_erp_pre1 INTO l_erp
  #              IF l_pos > 0  AND l_uerp = 0 THEN
  #                 LET sr.pos = 'Y'
  #                 LET sr.uerp = l_uerp
  #                 LET sr.erp = l_erp
  #                 LET sr.TYPE = '1'
  #                 LET sr.show = cl_gr_getmsg("gre-311",g_lang,0)
  #              END IF
  #              IF l_pos = 0  OR l_uerp > 0 THEN
  #                 IF l_pos = 0 THEN
  #                    LET sr.pos = 'N'
  #                 ELSE
  #                    LET sr.pos = 'Y'
  #                 END IF
  #                 LET sr.uerp = l_uerp
  #                 LET sr.erp = l_erp
  #                 LET sr.TYPE = '2'
  #                 IF sr.pos = 'N' AND sr.uerp > 0 THEN
  #                    LET sr.show = cl_gr_getmsg("gre-311",g_lang,1)
  #                 END IF
  #                 IF sr.pos = 'N' AND sr.uerp = 0 THEN
  #                    LET sr.show = cl_gr_getmsg("gre-311",g_lang,2)
  #                 END IF
  #                 IF sr.pos = 'Y' AND sr.uerp > 0 THEN
  #                    LET sr.show = cl_gr_getmsg("gre-311",g_lang,3)
  #                 END IF
  #              END IF
  #           #已完成
  #           WHEN tm.Source = '1'
  #              LET l_sql1 = " SELECT COUNT(*)",
  #                           "   FROM ",l_posdb,"ta_DateEnd",l_posdb_link,
  #                           "  WHERE SHOP = '",l_azw01,"'",
  #                           "    AND EDATE = '",l_date,"'"
  #              PREPARE q003_pos1_pre1 FROM l_sql1
  #              EXECUTE q003_pos1_pre1 INTO l_pos
  #              LET l_sql2 = " SELECT COUNT(*)",
  #                           "   FROM ",l_posdb,"td_Sale",l_posdb_link,
  #                           "  WHERE SHOP = '",l_azw01,"'",
  #                           "    AND BDATE = '",l_date,"'",
  #                           "    AND CONDITION2 <> 'Y'",
  #                           "  UNION ALL SELECT COUNT(*)",
  #                           "   FROM ",l_posdb,"td_InvoiceDetail",l_posdb_link,
  #                           "  WHERE SHOP = '",l_azw01,"'",
  #                           "    AND CONDITION2 <> 'Y'",
  #                           "    AND BDATE = '",l_date,"'"
  #              PREPARE q003_uerp1_pre1 FROM l_sql2
  #              EXECUTE q003_uerp1_pre1 INTO l_uerp
  #              LET l_sql3 = " SELECT COUNT(*)",
  #                           "   FROM ",l_posdb,"td_Sale",l_posdb_link,
  #                           "  WHERE SHOP = '",l_azw01,"'",
  #                           "    AND BDATE = '",l_date,"'",
  #                           "    AND CONDITION2 = 'Y'",
  #                           "  UNION ALL SELECT COUNT(*)",
  #                           "   FROM ",l_posdb,"td_InvoiceDetail",l_posdb_link,
  #                           "  WHERE SHOP = '",l_azw01,"'",
  #                           "    AND CONDITION2 = 'Y'",
  #                           "    AND BDATE = '",l_date,"'"
  #              PREPARE q003_erp1_pre1 FROM l_sql3
  #              EXECUTE q003_erp1_pre1 INTO l_erp
  #              IF l_pos > 0  AND l_uerp = 0 THEN
  #                 LET sr.pos = 'Y'
  #                 LET sr.uerp = l_uerp
  #                 LET sr.erp = l_erp
  #                 LET sr.TYPE = '1'
  #                 LET sr.show = cl_gr_getmsg("gre-311",g_lang,0)
  #              END IF
  #           #未完成
  #           WHEN tm.Source = '2' 
  #              LET l_sql1 = " SELECT COUNT(*)",
  #                           "   FROM ",l_posdb,"ta_DateEnd",l_posdb_link,
  #                           "  WHERE SHOP = '",l_azw01,"'",
  #                           "    AND EDATE = '",l_date,"'"
  #              PREPARE q003_pos2_pre1 FROM l_sql1
  #              EXECUTE q003_pos2_pre1 INTO l_pos
  #              LET l_sql2 = " SELECT COUNT(*)",
  #                           "   FROM ",l_posdb,"td_Sale",l_posdb_link,
  #                           "  WHERE SHOP = '",l_azw01,"'",
  #                           "    AND BDATE = '",l_date,"'",
  #                           "    AND CONDITION2 <> 'Y'",
  #                           "  UNION ALL SELECT COUNT(*)",
  #                           "   FROM ",l_posdb,"td_InvoiceDetail",l_posdb_link,
  #                           "  WHERE SHOP = '",l_azw01,"'",
  #                           "    AND CONDITION2 <> 'Y'",
  #                           "    AND BDATE = '",l_date,"'"
  #              PREPARE q003_uerp2_pre1 FROM l_sql2
  #              EXECUTE q003_uerp2_pre1 INTO l_uerp
  #              LET l_sql3 = " SELECT COUNT(*)",
  #                           "   FROM ",l_posdb,"td_Sale",l_posdb_link,
  #                           "  WHERE SHOP = '",l_azw01,"'",
  #                           "    AND BDATE = '",l_date,"'",
  #                           "    AND CONDITION2 = 'Y'",
  #                           "  UNION ALL SELECT COUNT(*)",
  #                           "   FROM ",l_posdb,"td_InvoiceDetail",l_posdb_link,
  #                           "  WHERE SHOP = '",l_azw01,"'",
  #                           "    AND CONDITION2 = 'Y'",
  #                           "    AND BDATE = '",l_date,"'"
  #              PREPARE q003_erp2_pre1 FROM l_sql3
  #              EXECUTE q003_erp2_pre1 INTO l_erp
  #              IF l_pos = 0  OR l_uerp > 0 THEN
  #                 IF l_pos = 0 THEN
  #                    LET sr.pos = 'N'
  #                 ELSE
  #                    LET sr.pos = 'Y'
  #                 END IF
  #                 LET sr.uerp = l_uerp
  #                 LET sr.erp = l_erp
  #                 LET sr.TYPE = '2'
  #                 IF sr.pos = 'N' AND sr.uerp > 0 THEN
  #                    LET sr.show = cl_gr_getmsg("gre-311",g_lang,1)
  #                 END IF
  #                 IF sr.pos = 'N' AND sr.uerp = 0 THEN
  #                    LET sr.show = cl_gr_getmsg("gre-311",g_lang,2)
  #                 END IF
  #                 IF sr.pos = 'Y' AND sr.uerp > 0 THEN
  #                    LET sr.show = cl_gr_getmsg("gre-311",g_lang,3)
  #                 END IF
  #              END IF
  #       END CASE 
  #    LET sr.shop = l_azw01
  #    SELECT rtz13 INTO sr.NAME 
  #      FROM rtz_file
  #     WHERE rtz01 = g_shop[g_cnt].shop
  #    LET sr.edate = l_date
  #    EXECUTE insert_prep USING sr.* 
  #    END FOREACH
  # END FOREACH
  #FUN-D40055--mark--end---
  #FUN-D40055--add--str---
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF tm.date = " 1=1" THEN
      LET g_wc = tm.azw01,"AND TYPE = ",tm.source
   ELSE
      LET g_wc = tm.azw01,"AND",tm.date,"AND TYPE = ",tm.source
   END IF
  #FUN-D40055--add--end---
   CALL q003_grdata()
END FUNCTION

FUNCTION q003_grdata()
   DEFINE l_sql    STRING
   DEFINE handler  om.SaxDocumentHandler
   DEFINE sr1      sr1_t
   DEFINE l_cnt    LIKE type_file.num10

   LET l_cnt = cl_gre_rowcnt(l_table)
   IF l_cnt <= 0 THEN
      CALL cl_msgany(0, 0, "No Data!!")
      RETURN
   END IF

   WHILE TRUE
       CALL cl_gre_init_pageheader()
       LET handler = cl_gre_outnam("apcq003")
       IF handler IS NOT NULL THEN
           START REPORT q003_rep TO XML HANDLER handler
           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                      #" ORDER BY shop,edate,type"      #FUN-D40055 mark
                       " ORDER BY shop,edate DESC"           #FUN-D40055 add
           DECLARE q003_datacur1 CURSOR FROM l_sql
           FOREACH q003_datacur1 INTO sr1.*
               OUTPUT TO REPORT q003_rep(sr1.*)
           END FOREACH
           FINISH REPORT q003_rep
       END IF
       IF INT_FLAG = TRUE THEN
           LET INT_FLAG = FALSE
           EXIT WHILE
       END IF
   END WHILE
   CALL cl_gre_close_report()
END FUNCTION

REPORT q003_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_pos    STRING
    DEFINE l_type   STRING


    ORDER EXTERNAL BY sr1.shop


    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            PRINTX g_wc

        BEFORE GROUP OF sr1.shop
            LET l_lineno = 0

        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            PRINTX sr1.*
            LET l_pos = cl_gr_getmsg("gre-313",g_lang,sr1.pos) 
            LET l_type = cl_gr_getmsg("gre-312",g_lang,sr1.type)
            PRINTX l_pos
            PRINTX l_type

        AFTER GROUP OF sr1.shop

        ON LAST ROW

END REPORT
#FUN-CA0103
