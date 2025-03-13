# Prog. Version..: '5.30.06-13.04.22(00002)'     #
#
# Pattern name...: apcq002.4gl
# Descriptions...: POS資料未上傳查詢作業
# Date & Author..: NO.FUN-CA0103 12/10/18 By xumeimei  
# Modify.........: No:FUN-D40055 13/04/16 By dongsz 增加日期區間，單身顯示資料調整
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  tm      RECORD
                Plant         STRING,
                Date          STRING,            
                bdate         LIKE type_file.dat,   #FUN-D40055 add
                edate         LIKE type_file.dat,   #FUN-D40055 add
                Source        LIKE type_file.chr1
                END RECORD   
DEFINE  g_shop  DYNAMIC ARRAY OF RECORD
                SHOP          LIKE azw_file.azw01,
                NAME          LIKE rtz_file.rtz13,
                DATE          LIKE type_file.dat,
                TYPE          LIKE type_file.chr1,
                SALENO        LIKE oga_file.oga01,
                TOT_AMT       LIKE ogb_file.ogb14t
                END RECORD
DEFINE g_cnt                  LIKE type_file.num10
DEFINE g_curs_index           LIKE type_file.num10
DEFINE g_row_count            LIKE type_file.num10
DEFINE g_argv1                LIKE type_file.chr1 
DEFINE g_argv2                STRING
DEFINE g_argv3                STRING
DEFINE g_argv4                STRING
DEFINE g_argv5                STRING
DEFINE g_argv6                STRING                #FUN-D40055 add
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT          

   LET g_argv2 = ARG_VAL(1)
   LET g_argv3 = ARG_VAL(2)
   LET tm.Plant = "azw01 in( '",cl_replace_str(g_argv2,",","','"),"')"
   LET tm.Date = "bdate in ( '",cl_replace_str(g_argv3,",","','"),"')" 
   LET tm.Source = ARG_VAL(3)
   LET g_argv1 = ARG_VAL(4)
   LET g_argv4 = ARG_VAL(5)
   LET g_argv5 = ARG_VAL(6)
   LET g_argv6 = ARG_VAL(7)                         #FUN-D40055 add
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   
   OPEN WINDOW q002_w WITH FORM "apc/42f/apcq002"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()   
 
   LET g_action_choice = ""
   IF cl_null(g_argv1) THEN
      LET g_argv1 = 'N'
   END IF
   IF g_argv1 = 'N' THEN
      CALL q002_q()
      CALL q002_menu()
   ELSE
      DISPLAY g_argv4 TO azw01
      DISPLAY g_argv5 TO bdate
      DISPLAY g_argv6 TO edate             #FUN-D40055 add
      DISPLAY tm.Source TO Source
      LET tm.bdate = ''                    #FUN-D40055 add
      LET tm.edate = ''                    #FUN-D40055 add 
      CALL q002_b_fill()
      CALL q002_menu()
   END IF
   CLOSE WINDOW q002_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION q002_curs()
  #CLEAR FORM                              #FUN-D40055 mark
   CALL g_shop.clear()

   DIALOG ATTRIBUTES(UNBUFFERED) 
   CONSTRUCT BY NAME tm.Plant ON azw01
                         
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
                    LET tm.Plant = g_qryparam.multiret
                    DISPLAY tm.Plant TO azw01
                    NEXT FIELD azw01 
              END CASE
   END CONSTRUCT
  #FUN-D40055--mark--str---
  #CONSTRUCT BY NAME tm.Date ON bdate
  #   BEFORE CONSTRUCT
  #        CALL cl_qbe_init()

  #END CONSTRUCT
  #FUN-D40055--mark--str---
   INPUT BY NAME tm.Source,tm.bdate,tm.edate ATTRIBUTE(WITHOUT DEFAULTS=TRUE)   #FUN-D40055 add tm.bdate,tm.edate
     
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
     #IF tm.Plant = " 1=1" THEN
     #   CALL cl_err('','apc-198',0)
     #   NEXT FIELD azw01
     #END IF
     #FUN-D40055--mark--end---
      IF cl_null(tm.Source) THEN
         CALL cl_err('','apc-202',0)
         NEXT FIELD Source
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

FUNCTION q002_menu()
 
   WHILE TRUE
      CALL q002_bp("G")

   CASE g_action_choice

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q002_q()
            END IF
        
         WHEN "help"
            CALL cl_show_help()
  
         WHEN "exit"
            EXIT WHILE 

         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q002_out()
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

FUNCTION q002_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1
   IF p_ud <> "G"  THEN
      RETURN
   END IF

   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)

   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_shop TO s_shop.* ATTRIBUTE(COUNT = g_cnt)
        BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )

      END DISPLAY  

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG 
         
      ON ACTION HELP
         LET g_action_choice="help"
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

FUNCTION q002_q()
DEFINE l_rcj10       LIKE rcj_file.rcj10    #FUN-D40055 add
    LET  g_row_count = 0
    LET  g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)

    INITIALIZE tm.* TO NULL
    LET tm.Plant = NULL 
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_shop.clear()
   #FUN-D40055--add--str---
    LET tm.Source = '0'
    LET tm.edate = g_today
    SELECT rcj10 INTO l_rcj10 FROM rcj_file
    LET tm.bdate = g_today - l_rcj10
    DISPLAY tm.Source TO Source
    DISPLAY tm.bdate TO bdate
    DISPLAY tm.edate TO edate
   #FUN-D40055--add--end---
    DISPLAY ' ' TO FORMONLY.cnt

    CALL q002_curs()  

    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       INITIALIZE tm.* TO NULL
       RETURN
    END IF
    CALL q002_show()
END FUNCTION
 
FUNCTION q002_show()
   #DISPLAY BY NAME tm.Plant,tm.Date,tm.Source              #FUN-D40055 mark
    DISPLAY BY NAME tm.Plant,tm.Source,tm.bdate,tm.edate    #FUN-D40055 add
    CALL cl_show_fld_cont()      
   #FUN-D40055--add--str---
    IF NOT cl_null(tm.bdate) THEN
       IF cl_null(tm.edate) THEN
          LET tm.edate = g_today
       END IF 
    END IF
   #FUN-D40055--add--end---
    CALL q002_b_fill()   
END FUNCTION

FUNCTION q002_b_fill()
    DEFINE l_posdb       LIKE ryg_file.ryg00  
    DEFINE l_posdb_link  LIKE ryg_file.ryg02
    DEFINE l_azw01       LIKE azw_file.azw01
    DEFINE l_type        LIKE type_file.chr1
    DEFINE l_sql         STRING
    DEFINE l_sql1        STRING
    DEFINE l_bdate       STRING                 #FUN-D40055 add
    DEFINE l_edate       STRING                 #FUN-D40055 add
 
    CALL g_shop.clear()  
    LET g_cnt = 1
 
    SELECT DISTINCT ryg00,ryg02 INTO l_posdb,l_posdb_link FROM ryg_file WHERE ryg00='ds_pos1'
    LET l_posdb=s_dbstring(l_posdb)
    LET l_posdb_link=q002_dblinks(l_posdb_link)
   #FUN-D40055--add--str---
    IF cl_null(tm.Plant) THEN 
       LET tm.Plant = " 1=1" 
    END IF
    LET tm.Plant = tm.Plant," AND azw01 IN (SELECT ryg01 FROM ryg_file WHERE rygacti = 'Y') "
    LET l_edate = DATE(tm.edate) USING "yyyymmdd"
    IF cl_null(tm.bdate) AND NOT cl_null(tm.edate) THEN
       LET tm.date = " BDATE <= '",l_edate,"' "
    END IF
    IF NOT cl_null(tm.bdate) THEN
       LET l_bdate = DATE(tm.bdate) USING "yyyymmdd"
       LET l_edate = DATE(tm.edate) USING "yyyymmdd"
       LET tm.date = " BDATE BETWEEN '",l_bdate,"' AND '",l_edate,"' "
    END IF
   #FUN-D40055--add--end---
    IF cl_null(tm.Date) THEN
       LET tm.Date = " 1=1"                 
    ELSE
       LET tm.Date = cl_replace_str(tm.Date,"bdate","CAST( bdate AS date )")
    END IF
    CASE 
        #全部       
        WHEN tm.Source = '0'
           LET l_sql = " SELECT SHOP,' ',BDATE,TYPE,SALENO,TOT_AMT", 
                       "   FROM ",l_posdb,"td_Sale",l_posdb_link,",",
                       "         azw_file",
                       "  WHERE SHOP = azw01",
                       "    AND azw01 IN ",g_auth,
                       "    AND CONDITION2 <> 'Y'",
                       "    AND TYPE IN ('0','1','2','3','4') ",
                       "    AND ",tm.Plant CLIPPED,
                       "    AND ",tm.Date CLIPPED,                                      
                       " UNION ALL SELECT SHOP,' ',BDATE,5,SALENO,INVAMT",
                       "             FROM ",l_posdb,"td_InvoiceDetail",l_posdb_link,",",
                       "                   azw_file",
                       "            WHERE SHOP = azw01",
                       "              AND azw01 IN ",g_auth,
                       "              AND CONDITION2 <> 'Y'",
                       "    AND ",tm.Plant CLIPPED,
                       "    AND ",tm.Date CLIPPED                                      
        #資料來源為客戶訂單
        WHEN tm.Source = '1'
           LET l_sql = " SELECT SHOP,' ',BDATE,TYPE,SALENO,TOT_AMT",
                       "   FROM ",l_posdb,"td_Sale",l_posdb_link,",",
                       "         azw_file",
                       "  WHERE SHOP = azw01",
                       "    AND azw01 IN ",g_auth,
                       "    AND ",tm.Plant CLIPPED,
                       "    AND ",tm.Date CLIPPED,                                    
                       "    AND CONDITION2 <> 'Y'",
                       "    AND TYPE = '3' "
        #資料來源為訂金退回單
        WHEN tm.Source = '2' 
           LET l_sql = " SELECT SHOP,' ',BDATE,TYPE,SALENO,TOT_AMT",
                       "   FROM ",l_posdb,"td_Sale",l_posdb_link,",",
                       "         azw_file",
                       "  WHERE SHOP = azw01",
                       "    AND azw01 IN ",g_auth,
                       "    AND ",tm.Plant CLIPPED,
                       "    AND ",tm.Date CLIPPED,                                        
                       "    AND CONDITION2 <> 'Y'",
                       "    AND TYPE = '4'"
        #資料來源為銷售銷退單
        WHEN tm.Source = '3'
           LET l_sql = " SELECT SHOP,' ',BDATE,TYPE,SALENO,TOT_AMT",
                       "   FROM ",l_posdb,"td_Sale",l_posdb_link,",",
                       "         azw_file",
                       "  WHERE SHOP = azw01",
                       "    AND azw01 IN ",g_auth,
                       "    AND ",tm.Plant CLIPPED,
                       "    AND ",tm.Date CLIPPED,                                       
                       "    AND CONDITION2 <> 'Y'",
                       "    AND TYPE IN('0','1','2')"
        #資料來源為發票
        WHEN tm.Source = '4' 
           LET l_sql = " SELECT SHOP,' ',BDATE,4,SALENO,TOT_AMT",
                       "   FROM ",l_posdb,"td_InvoiceDetail",l_posdb_link,",",
                       "         azw_file",
                       "  WHERE SHOP = azw01",
                       "    AND azw01 IN ",g_auth,
                       "    AND ",tm.Plant CLIPPED,
                       "    AND ",tm.Date CLIPPED,                                       
                       "    AND CONDITION2 <> 'Y'"
    END CASE    
   #LET l_sql = l_sql ," ORDER BY SHOP,BDATE,TYPE,SALENO"           #FUN-D40055 mark
    LET l_sql = l_sql ," ORDER BY SHOP,BDATE DESC "                      #FUN-D40055 add 
    PREPARE q002_pre FROM l_sql
    DECLARE q002_cl CURSOR FOR q002_pre
    FOREACH q002_cl INTO g_shop[g_cnt].*
       IF STATUS THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT rtz13 INTO g_shop[g_cnt].NAME FROM rtz_file WHERE rtz01 = g_shop[g_cnt].SHOP
       IF tm.Source = '4' THEN LET l_type = '4' END IF
       IF g_shop[g_cnt].TYPE = '3' THEN LET l_type = '1' END IF
       IF g_shop[g_cnt].TYPE = '4' THEN LET l_type = '2' END IF
       IF g_shop[g_cnt].TYPE = '0' OR g_shop[g_cnt].TYPE = '1' OR g_shop[g_cnt].TYPE = '2' THEN LET l_type = '3' END IF
       LET g_shop[g_cnt].TYPE = l_type
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_shop.deleteElement(g_cnt)
  
    LET g_cnt=g_cnt-1
    DISPLAY g_cnt TO FORMONLY.cnt
END FUNCTION

FUNCTION q002_dblinks(l_db_links)
DEFINE l_db_links LIKE ryg_file.ryg02

  IF l_db_links IS NULL OR l_db_links = ' ' THEN
     RETURN ' '
  ELSE
     LET l_db_links = '@',l_db_links CLIPPED
     RETURN l_db_links
  END IF

END FUNCTION

FUNCTION q002_out()
   DEFINE l_cmd   STRING
   DEFINE l_str          LIKE azw_file.azw01
   DEFINE l_str1         STRING
   DEFINE l_sql          STRING
   DEFINE l_str2         LIKE type_file.dat
   DEFINE l_str3         STRING
   DEFINE l_str4         STRING
   DEFINE l_posdb        LIKE ryg_file.ryg00
   DEFINE l_posdb_link   LIKE ryg_file.ryg02

   IF g_cnt > 0  THEN
      CALL cl_wait()
      LET l_sql = " SELECT DISTINCT azw01 FROM azw_file",
                  "  WHERE ",tm.Plant CLIPPED
      PREPARE q002_str_pre FROM l_sql
      DECLARE q002_str_cs CURSOR FOR q002_str_pre
      FOREACH q002_str_cs INTO l_str
         IF cl_null(l_str1) THEN
            LET l_str1 = l_str
         ELSE
            LET l_str1 = l_str1,',',l_str
         END IF
      END FOREACH
      SELECT DISTINCT ryg00,ryg02 INTO l_posdb,l_posdb_link FROM ryg_file WHERE ryg00='ds_pos1'
      LET l_posdb=s_dbstring(l_posdb)
      LET l_posdb_link=q002_dblinks(l_posdb_link)
      LET l_sql = " SELECT DISTINCT BDATE",
                  "   FROM ",l_posdb,"td_Sale",l_posdb_link,
                  "  WHERE CONDITION2 <> 'Y'",
                  "    AND ",tm.Date CLIPPED,
                  "  UNION ALL SELECT DISTINCT BDATE",
                  "  FROM ",l_posdb,"td_InvoiceDetail",l_posdb_link,
                  "  WHERE CONDITION2 <> 'Y'",
                  "    AND ",tm.Date CLIPPED," ORDER BY 1 DESC "     #FUN-D40055 add " ORDER BY 1 DESC "
      PREPARE q002_str1_pre FROM l_sql
      DECLARE q002_str1_cs CURSOR FOR q002_str1_pre
      FOREACH q002_str1_cs INTO l_str2
         IF NOT cl_null(l_str2) THEN
            LET l_str4 = l_str2 USING "yyyymmdd" 
         END IF
         IF cl_null(l_str3) THEN
            LET l_str3 = l_str4
         ELSE
            LET l_str3 = l_str3,',',l_str4
         END IF
      END FOREACH
      LET l_cmd="apcg010 '",g_today CLIPPED,"' '",g_user CLIPPED,"' '",g_lang CLIPPED,"' 'Y' '' '' '",l_str1 CLIPPED,"' '",l_str3 CLIPPED,"' '",tm.Source CLIPPED,"'"
      CALL cl_cmdrun(l_cmd)
      ERROR ''
   END IF
END FUNCTION
#FUN-CA0103
