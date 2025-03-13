# Prog. Version..: '5.30.06-13.04.19(00006)'     #
#
# Pattern name...: aicq023.4gl
# Descriptions...: 料件批號異動明細查詢作業
# Date & Author..: 08/01/21 By lilingyu
# Modify.........: 08/03/20 No.FUN-830083 by hellen 過單
# Modify.........: No.MOD-8B0043 By chenyu 1.sql錯誤
#                                          2.deleteElement()的位置要移到上面
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-950107 09/10/12 By jan a1/a2 欄位開窗.form 修改
# Modify.........: No:MOD-AC0028 10/12/06 By sabrina 數量總和有誤
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-B30195 11/09/22 By jason add tree view
# Modify.........: No.FUN-C40014 12/04/06 By bart 修改單別取法
# Modify.........: No.MOD-CA0140 12/11/07 By Elise 加上一個空白,MOD-CB0027連同追單
# Modify.........: No.FUN-CC0079 13/04/02 By Alberti 單身增加顯示Datecode(idd17)

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
   tm       RECORD
           # wc            LIKE type_file.chr1000,
            wc            STRING,            #NO.FUN-910082
            estyle        LIKE type_file.chr1,
            detail        LIKE type_file.chr1
            END RECORD,
  g_lot                   LIKE idd_file.idd04,
  g_idd         DYNAMIC ARRAY OF RECORD
       smydesc            LIKE smy_file.smydesc,
       idd10              LIKE idd_file.idd10,
       idd11              LIKE idd_file.idd11,
       tlf19              LIKE tlf_file.tlf19,
       desc               LIKE type_file.chr50,
       raw_no             LIKE idd_file.idd30,
       raw_item           LIKE idd_file.idd31,
       idd01              LIKE idd_file.idd01,
       ima02              LIKE ima_file.ima02,
       ima021             LIKE ima_file.ima021,
       idd15              LIKE idd_file.idd15,
       ima06              LIKE ima_file.ima06,
       ima08              LIKE ima_file.ima08,
       idc19              LIKE idc_file.idc19,
       ima02_2            LIKE ima_file.ima02,
       idd07              LIKE idd_file.idd07,
       idd02              LIKE idd_file.idd02,
       idd03              LIKE idd_file.idd03,
       idd04              LIKE idd_file.idd04,
       idd16              LIKE idd_file.idd16,
       idd12              LIKE idd_file.idd12,
       idd13              LIKE idd_file.idd13,
       idd18              LIKE idd_file.idd18,
       idd05              LIKE idd_file.idd05,
       idd06              LIKE idd_file.idd06,        #FUN-CC0079   ,
       idd17              LIKE idd_file.idd06,        #FUN-CC0079
       idd08              LIKE idd_file.idd08
                 END RECORD,    
         g_sql           STRING,
         g_cmd           LIKE type_file.chr1000,
         i,m_cnt,g_t     LIKE type_file.num10,
         g_rec_b         LIKE type_file.num5 		  
DEFINE   g_cnt           LIKE type_file.num10   
DEFINE   g_msg           LIKE type_file.chr1000
DEFINE   g_row_count     LIKE type_file.num10
DEFINE   g_curs_index    LIKE type_file.num10
DEFINE   g_jump          LIKE type_file.num10
DEFINE   g_no_ask       LIKE type_file.num5
DEFINE   g_ima01         LIKE ima_file.ima01
DEFINE  lc_qbe_sn        LIKE gbm_file.gbm01
#FUN-B30195 --START--
DEFINE g_wc_o            STRING                #g_wc舊值備份   
DEFINE g_idx             LIKE type_file.num5   #g_tree的index，用於tree_fill()的recursive
DEFINE g_tree DYNAMIC ARRAY OF RECORD
          name           STRING,                 #節點名稱
          pid            STRING,                 #父節點id
          id             STRING,                 #節點id
          has_children   BOOLEAN,                #TRUE:有子節點, FALSE:無子節點
          expanded       BOOLEAN,                #TRUE:展開, FALSE:不展開
          level          LIKE type_file.num5,    #階層
          path           STRING,                 #節點路徑，以"."隔開
          #各程式key的數量會不同，單身和單頭的key都要記錄
          #若key是數值，要先轉字串，避免數值型態放到Tree有多餘空白
          treekey1       STRING
          END RECORD
DEFINE g_tree_focus_idx  STRING                  #focus節點idx
DEFINE g_tree_focus_path STRING                  #focus節點path
DEFINE g_tree_reload     LIKE type_file.chr1     #tree是否要重新整理 Y/N
DEFINE g_tree_b          LIKE type_file.chr1     #tree是否進入單身 Y/N
DEFINE g_path_self       DYNAMIC ARRAY OF STRING #tree加節點者至root的路徑(check loop)
DEFINE g_path_add        DYNAMIC ARRAY OF STRING #tree要增加的節點底層路徑(check loop)
DEFINE g_abd_del    DYNAMIC ARRAY OF RECORD      #刪除前的暫存檔，將於save之後，統一刪除
             idd01       LIKE idd_file.idd01
                      END RECORD   
#FUN-B30195 --END--
 
MAIN
   OPTIONS                                
        INPUT NO WRAP
    DEFER INTERRUPT                 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF
 
   IF NOT s_industry("icd") THEN
      CALL cl_err('','aic-999',1)
      EXIT PROGRAM
   END IF   

   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   
   OPEN WINDOW q023_w WITH FORM "aic/42f/aicq023" 
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   LET g_tree_reload = "N"      #tree是否要重新整理 Y/N   #FUN-B30195
   LET g_tree_b = "N"           #tree是否進入單身 Y/N     #FUN-B30195
   LET g_tree_focus_idx = 0     #focus節點index         #FUN-B30195
    
    CALL q023_tmp()
 
    CALL q023_menu()
    CLOSE WINDOW q023_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION q023_cs()
   DEFINE   l_cnt      LIKE type_file.num5
   DEFINE   l_i        LIKE type_file.num5
 
   CLEAR FORM 
   CALL g_idd.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL
   LET tm.estyle = '3'
   LET tm.detail = 'N'
 
   WHILE TRUE
      CONSTRUCT tm.wc ON idd01,idd15,idd04,idd17,idd08
                     FROM a1,a2,a3,a4,a5 
 
         BEFORE CONSTRUCT
                CALL cl_qbe_init()
 
         ON ACTION CONTROLP
            CASE
              WHEN INFIELD(a1)    #料號
                   CALL cl_init_qry_var()
                  #LET g_qryparam.form = "q_ima23"  #TQC-950107 
                   LET g_qryparam.form = "q_ima"    #TQC-950107
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO a1
                   NEXT FIELD a1
              WHEN INFIELD(a2)    #母編
                   CALL cl_init_qry_var()
                  #LET g_qryparam.form = "q_ima231"    #TQC-950107
                   LET g_qryparam.form = "q_imaicd1"   #TQC-950107
                   LET g_qryparam.arg1 = "0"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO a2
                   NEXT FIELD a2
              WHEN INFIELD(a3)    #批號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_idc01"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO a3
                   NEXT FIELD a3
              WHEN INFIELD(a4)    #date code
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_idc02"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO a4
                   NEXT FIELD a4
            END CASE
 
         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
   
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
 
         ON ACTION about 
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
 
         ON ACTION controlg
            CALL cl_cmdask()
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   
      IF INT_FLAG THEN RETURN END IF
      IF tm.wc = " 1=1" THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
  
   IF INT_FLAG THEN RETURN END IF
 
   INPUT tm.estyle,tm.detail WITHOUT DEFAULTS FROM estyle,detail
     AFTER FIELD estyle
       IF tm.estyle NOT MATCHES '[123]' THEN
	  NEXT FIELD estyle
       END IF    	      
  
     AFTER FIELD detail
       IF tm.detail NOT MATCHES '[YN]' THEN
	  NEXT FIELD estyle
       END IF    	      
  
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
     ON ACTION qbe_select
        CALL cl_qbe_list() RETURNING lc_qbe_sn
        CALL cl_qbe_display_condition(lc_qbe_sn)
 
     ON ACTION locale
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()
 
     ON ACTION help
        CALL cl_show_help()
 
     ON ACTION controlg
        CALL cl_cmdask()
   END INPUT
   IF INT_FLAG THEN RETURN END IF
   MESSAGE 'WAIT'
 
   #撈出符合條件的批號
   LET g_sql = "SELECT DISTINCT idd04 FROM idd_file ",
               " WHERE idd04 IS NOT NULL AND idd16 IS NOT NULL ",
               "   AND ",tm.wc,
               " ORDER BY idd04 "
   PREPARE q023_pre FROM g_sql
   DECLARE q023_cs SCROLL CURSOR WITH HOLD FOR q023_pre
 
   LET g_sql = "SELECT COUNT(DISTINCT idd04) FROM idd_file ",
               " WHERE idd04 IS NOT NULL AND idd16 IS NOT NULL ",
               "   AND ",tm.wc,
               " ORDER BY idd04 "
   PREPARE q023_count_pre FROM g_sql
   DECLARE q023_count_cs SCROLL CURSOR WITH HOLD FOR q023_count_pre
END FUNCTION
    
FUNCTION q023_menu()
   DEFINE l_tlf13       LIKE tlf_file.tlf13
 
   WHILE TRUE
      CALL q023_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q023_q()
            END IF
 
         WHEN "qry_back"
            IF cl_chk_act_auth() THEN
               LET g_t = ARR_CURR()
               SELECT tlf13 INTO l_tlf13
                 FROM tlf_file
                WHERE tlf01 = g_idd[g_t].idd01
                  AND tlf902= g_idd[g_t].idd02
                  AND tlf903= g_idd[g_t].idd03
                  AND tlf904= g_idd[g_t].idd04
                  AND tlf905= g_idd[g_t].idd10  
                  AND tlf906= g_idd[g_t].idd11
                  AND tlf06 = g_idd[g_t].idd08
            
               IF (l_tlf13 = 'apmt1501' OR l_tlf13 = 'asft6201' OR 
                   l_tlf13 = 'apmt1101' OR l_tlf13 = 'asft6001') AND
                  NOT cl_null(g_idd[g_t].idd10) AND
                  NOT cl_null(g_idd[g_t].idd11) THEN
                  LET g_cmd = "aicq021 '",g_idd[g_t].idd10,"' ",
                              "'",g_idd[g_t].idd11,"' "
                  CALL cl_cmdrun_wait(g_cmd)
               END IF
            END IF
            
         WHEN "help" 
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"    
            CALL cl_cmdask()
 
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),
                                      base.TypeInfo.create(g_idd),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q023_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    LET g_rec_b = 0
 
    DELETE FROM q023_tmp
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY ' ',' ' TO FORMONLY.cnt,FORMONLY.cn2
 
    CALL q023_cs()
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CALL g_tree.clear()   #FUN-B30195 
       RETURN 
    END IF
 
    OPEN q023_cs                          
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q023_count_cs
       FETCH q023_count_cs INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt  
       CALL q023_fetch('F')               
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q023_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,               #處理方式
    l_abso          LIKE type_file.num10               #絕對的筆數
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q023_cs INTO g_lot
        WHEN 'P' FETCH PREVIOUS q023_cs INTO g_lot
        WHEN 'F' FETCH FIRST    q023_cs INTO g_lot                                         
        WHEN 'L' FETCH LAST     q023_cs INTO g_lot
        WHEN '/'
            IF (NOT g_no_ask) THEN
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
            FETCH ABSOLUTE g_jump q023_cs INTO g_lot
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ima01,SQLCA.sqlcode,0)
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
       DISPLAY g_curs_index TO FORMONLY.idx    #No.MOD-8B0043 add
    END IF
    CALL q023_show()
END FUNCTION
 
FUNCTION q023_show()      
   DISPLAY ' '   TO FORMONLY.a1
   DISPLAY ' '   TO FORMONLY.a2
   DISPLAY g_lot TO FORMONLY.a3
   DISPLAY ' '   TO FORMONLY.a4
   DISPLAY ' '   TO FORMONLY.a5
 
   CALL q023_b_fill()
 
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION q023()              #BODY FILL UP
   DEFINE l_sql     STRING ,
          l_rec     LIKE type_file.num5,
          l_tlf13   LIKE tlf_file.tlf13
   DEFINE l_data    RECORD
            idd10   LIKE idd_file.idd10, #異動單據
            idd11   LIKE idd_file.idd11, #異動單據項次
            idd04   LIKE idd_file.idd04, #批
            lot     LIKE idd_file.idd16, #批號
            type    LIKE type_file.chr1, #逆(lot=批號)
                                         #順(lot=母批)
            seq     LIKE type_file.num5,
            idd12   LIKE idd_file.idd12     #MOD-AC0028 add
                    END RECORD
   
 DELETE FROM q023_tmp
   CASE
       WHEN tm.estyle = '1'  #1.逆展(撈批號找子階)
            LET l_sql = "INSERT INTO q023_tmp ",
                        "SELECT DISTINCT idd10 part,idd11, ",
                        "       idd04,idd04 lot,'1',0,idd12 ",          #MOD-AC0028 add idd12
                        "  FROM idd_file ",
                        " WHERE idd04 IS NOT NULL ",
                        "   AND idd16 IS NOT NULL ",
                        "   AND idd04 = '",g_lot,"' AND ",tm.wc
 
       WHEN tm.estyle = '2'  #2.順展(撈母批找父階)
            LET l_sql = "INSERT INTO q023_tmp ",
                        "SELECT DISTINCT idd10 part,idd11, ",
                        "       idd04,idd16 lot,'2',0,idd12 ",           #MOD-AC0028 add idd12
                        "  FROM idd_file ",
                        " WHERE idd04 IS NOT NULL ",
                        "   AND idd16 IS NOT NULL ",
                        "   AND idd04 = '",g_lot,"' AND ",tm.wc
 
       WHEN tm.estyle = '3'  #3.逆展+順展
            LET l_sql = "INSERT INTO q023_tmp ",
                        "SELECT DISTINCT idd10 part,idd11, ",
                        "       idd04,idd04 lot,'1' type,0,idd12 ",       #MOD-AC0028 add idd12
                        "  FROM idd_file ",
                        " WHERE idd04 IS NOT NULL ",
                        "   AND idd16 IS NOT NULL ",
                        "   AND idd04 = '",g_lot,"' AND ",tm.wc,
                        " UNION ",
                        "SELECT DISTINCT idd10 part,idd11, ",
                        "       idd04,idd16 lot,'2' type,0,idd12",         #MOD-AC0028 ad idd12
                        "  FROM idd_file ",
                        " WHERE idd04 IS NOT NULL ",
                        "   AND idd16 IS NOT NULL ",
                        "   AND idd04 = '",g_lot,"' AND ",tm.wc
   END CASE
   PREPARE q023_ins_pre FROM l_sql
   EXECUTE q023_ins_pre
 
   LET l_sql = "SELECT * ",
               "  FROM q023_tmp"
   PREPARE q023_pre1 FROM l_sql
   DECLARE q023_cs1 CURSOR FOR q023_pre1
 
   LET l_rec = 1
   FOREACH q023_cs1 INTO l_data.*
 
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH q023_cs1',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
 
      CALL q023_ex(l_data.*)
 
      LET l_rec = l_rec + 1
      IF l_rec > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
END FUNCTION
 
#往上找父/往下找子
FUNCTION q023_ex(p_data)
   DEFINE #l_sql     LIKE type_file.chr1000
          l_sql      STRING     #NO.FUN-910082
   DEFINE p_data    RECORD
           idd10    LIKE idd_file.idd10, #異動單號
           idd11    LIKE idd_file.idd11, #異動單號項次
           idd04    LIKE idd_file.idd04, #批
           lot      LIKE idd_file.idd16, #批號
           type     LIKE type_file.chr1, #逆(lot=批號)
                                         #順(lot=母批)
           seq      LIKE type_file.num5,
           idd12    LIKE idd_file.idd12    ##MOD-AC0028 add
                    END RECORD
   DEFINE l_data    DYNAMIC ARRAY OF RECORD
           idd10    LIKE idd_file.idd10, #異動單號
           idd11    LIKE idd_file.idd11, #異動單號項次
           idd04    LIKE idd_file.idd04,
           lot      LIKE idd_file.idd16,
           type     LIKE type_file.chr1,
           seq      LIKE type_file.num5,
           idd12    LIKE idd_file.idd12    ##MOD-AC0028 add
                    END RECORD
   DEFINE l_rec     LIKE type_file.num5
   DEFINE   l_i     LIKE type_file.num5
   DEFINE l_cnt     LIKE type_file.num5   #MOD-CA0140 add
   DEFINE l_str     STRING                #MOD-CA0140 add 
   #FUN-B30195 --START--
   IF s_abs(p_data.seq) > 20 THEN
      RETURN 
   END IF  
   #FUN-B30195 --END-- 
   CASE p_data.type
        WHEN '1'
             LET l_sql = "SELECT DISTINCT idd10,idd11, ",
                         "       idd04,idd04,'1','',idd12 ",    #MOD-AC0028 add idd12  #MOD-CA0140 add ''
                         " FROM  idd_file",
                         " WHERE idd16='",p_data.lot,"'",       #串子階母批
                        #"   AND ",tm.wc,                       #MOD-CA0140 mark
                         "   AND idd04 IS NOT NULL ",
                         "   AND idd16 IS NOT NULL ",
                         "   AND(idd10||idd11||idd12) ",        #MOD-AC0028 add ||idd12 
                         "   NOT IN(SELECT idd10||idd11||idd12 ",  #扣除已撈    #MOD-AC0028 add ||idd12
                         "            FROM q023_tmp)"
        WHEN '2'
             LET l_sql = "SELECT DISTINCT idd10,idd11, ",
                         "       idd04,idd16,'2','',idd12 ",    #MOD-AC0028 add idd12  #MOD-CA0140 add ''
                         " FROM  idd_file",
                         " WHERE idd04='",p_data.lot,"'",       #串父階批號
                        #"   AND ",tm.wc,                       #MOD-CA0140 mark
                         "   AND idd04 IS NOT NULL ",
                         "   AND idd10 IS NOT NULL ",
                         "   AND(idd10||idd11||idd12) ",           #MOD-AC0028 add ||idd12
                         "   NOT IN(SELECT idd10||idd11||idd12 ",  #扣除已撈    #MOD-AC0028 add ||idd12
                         "            FROM q023_tmp)"
   END CASE
 
  #MOD-CA0140---add---S
   LET l_str = tm.wc
   LET l_cnt = l_str.getIndexOf('idd04',1)
   IF l_cnt > 0 THEN
      LET l_sql = l_sql," AND idd04 !=' '"
   END IF
  #MOD-CA0140---add---E  
   PREPARE q023_pre2 FROM l_sql
   DECLARE q023_cs2 CURSOR FOR q023_pre2
   LET l_rec = 1
   FOREACH q023_cs2 INTO l_data[l_rec].*
 
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH q023_cs2',SQLCA.sqlcode,0)
          EXIT FOREACH
       END IF
 
       CASE p_data.type
            WHEN '1'  LET l_data[l_rec].seq = p_data.seq + 1  #逆:找子
            WHEN '2'  LET l_data[l_rec].seq = p_data.seq - 1  #順:找父
       END CASE
 
       INSERT INTO q023_tmp VALUES(l_data[l_rec].idd10,
                                   l_data[l_rec].idd11,
                                   l_data[l_rec].idd04,
                                   l_data[l_rec].lot,
                                   l_data[l_rec].type,
                                   l_data[l_rec].seq,
                                   l_data[l_rec].idd12)          #MOD-AC0028 add
       LET l_rec = l_rec + 1
       IF l_rec > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL l_data.deleteElement(l_rec)
   LET l_rec = l_rec - 1
 
   FOR l_i = 1 TO l_rec
       #FUN-B30195 --START--
       IF l_data[l_i].idd04 = l_data[l_i].lot THEN
          CONTINUE FOR
       END IF
       #FUN-B30195 --END--    
       CALL q023_ex(l_data[l_i].*)
   END FOR
END FUNCTION
 
FUNCTION q023_b_fill()
   DEFINE l_sql     STRING
   DEFINE l_i       LIKE type_file.num5
   DEFINE l_idd10   LIKE idd_file.idd10,
          l_idd11   LIKE idd_file.idd11,
          l_slip    LIKE smy_file.smyslip,
          l_tlf13   LIKE tlf_file.tlf13
   DEFINE l_idd12   LIKE idd_file.idd12         #MOD-AC0028 add 

   CALL q023()
   CALL q023_tree_fill(NULL,0,NULL,NULL)   #FUN-B30196 Tree填充
   
  IF tm.estyle = '2' THEN
     LET l_sql= "SELECT DISTINCT idd10,idd11,idd12,seq ",     #MOD-AC0028 add idd12
          "  FROM q023_tmp ",
          "  ORDER BY idd10,idd11,seq DESC"
   ELSE
      LET l_sql="SELECT DISTINCT idd10,idd11,idd12,seq ",     #MOD-AC0028 add idd12 
          "  FROM q023_tmp ",
          "  ORDER BY idd10,idd11,seq "
   END IF
   PREPARE q023_bp1_pre FROM l_sql
   DECLARE q023_bp1 CURSOR FOR q023_bp1_pre
 
   #撈合計的cursor宣告
   CASE
       WHEN tm.detail = 'N'   #不展開(異動單號/項次)sum
            LET l_sql = " SELECT '','',SUM(idd13),SUM(idd18) ",
                        "   FROM idd_file ",
                        "  WHERE idd10 = ? ",
                        "    AND idd11 = ? ",
                        "    AND idd12 = ? ",       #MOD-AC0028 add
                        "    AND ",tm.wc
       WHEN tm.detail = 'Y'   #展開(異動單號/項次/刻號/bin)sum
            LET l_sql = " SELECT idd05,idd06, ",
                        "        SUM(idd13),SUM(idd18) ",
                        "   FROM idd_file ",
                        "  WHERE idd10 = ? ",
                        "    AND idd11 = ? ",
                        "    AND idd12 = ? ",       #MOD-AC0028 add
                        "    AND ",tm.wc,
                        "  GROUP BY idd05,idd06 "
   END CASE
   PREPARE q023_bp2_pre FROM l_sql
   DECLARE q023_bp2 CURSOR FOR q023_bp2_pre
 
   #撈細項資料的cursor宣告
   CASE
       WHEN tm.detail = 'N'   #不展開(異動單號/項次)
            LET l_sql = " SELECT idd01,ima02,ima021,idd15, ",
                        "        ima06,ima08,idc19,idd07,idd02, ",
                        "        idd03,idd04,idd16,idd12, ",
                        "        idd08,idd17 ",         #FUN-CC0079 add idd17
                        "   FROM idd_file, ",
                        "        idc_file,ima_file ",
                        "  WHERE ima_file.ima01 = idd01 ",
                        "    AND idd01 = idc_file.idc01 ",
                        "    AND idd02 = idc_file.idc02 ",
                        "    AND idd03 = idc_file.idc03 ",
                        "    AND idd04 = idc_file.idc04 ",
                        "    AND idd10 = ? ",
                        "    AND idd11 = ? ",
                        "    AND idd12 = ? "         #MOD-AC0028 add
                       #"    AND ",tm.wc             #MOD-CA0140 mark
       WHEN tm.detail = 'Y'   #展開(異動單號/項次/刻號/bin)
            LET l_sql = " SELECT idd01,ima02,ima021,idd15, ",
                        "        ima06,ima08,idc19,idd07,idd02, ",
                        "        idd03,idd04,idd16,idd12, ",
                        "        idd08,idd17 ",                   #FUN-CC0079 add idd17
                        "   FROM idd_file, ",
                        "        idc_file,ima_file ",
                        "  WHERE ima_file.ima01 = idd01 ",
                        "    AND idd01 = idc_file.idc01 ",
                        "    AND idd02 = idc_file.idc02 ",
                        "    AND idd03 = idc_file.idc03 ",
                        "    AND idd04 = idc_file.idc04 ",
                        "    AND idd10 = ? ",
                        "    AND idd11 = ? ",
                        "    AND idd05 = ? ",
                        "    AND idd06 = ? ",
                        "    AND idd12 = ? "         #MOD-AC0028 add
                       #"    AND ",tm.wc             #MOD-CA0140 mark
   END CASE
   PREPARE idd_pre FROM l_sql
   DECLARE idd_cs CURSOR FOR idd_pre
 
   #撈tlf的廠商/客戶及異動命令cursor
  #No.MOD-8B0043 modify --begin
  #LET l_sql = "SELECT tlf19,tlf13 FROM tlf_file ",
  #            " WHERE tlf01 = ? ",  #料
  #            "   AND tlf02 = ? ",  #倉
  #            "   AND tlf03 = ? ",  #儲
  #            "   AND tlf04 = ? ",  #批
  #            "   AND tlf26 = ? ",  #異動單號
  #            "   AND tlf27 = ? "   #異動項次
   LET l_sql = "SELECT tlf19,tlf13 FROM tlf_file ",
               " WHERE tlf01 = ? ",   #料
               "   AND (tlf021 = ? OR tlf031 = ?) ",  #倉
               "   AND (tlf022 = ? OR tlf032 = ?) ",  #儲
               "   AND (tlf023 = ? OR tlf033 = ?) ",  #批
               "   AND (tlf026 = ? OR tlf036 = ?) ",  #異動單號
               "   AND (tlf027 = ? OR tlf037 = ?) "   #異動項次
  #No.MOD-8B0043 modify --end
   PREPARE tlf_pre FROM l_sql
   DECLARE tlf_cs CURSOR FOR tlf_pre
 
   CALL g_idd.clear()
   LET l_i = 1
   FOREACH q023_bp1 INTO l_idd10,l_idd11,l_idd12     #MOD-AC0028 add idd12
 
      INITIALIZE g_idd[l_i].* TO NULL   
 
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
 #     OPEN q023_bp2 USING l_idd10,l_idd11
 
 #     FOREACH q023_bp2 INTO g_idd[l_i].idd05,g_idd[l_i].idd06,
 #                           g_idd[l_i].idd13,g_idd[l_i].idd18
       FOREACH q023_bp2 USING l_idd10,l_idd11,l_idd12       #MOD-AC0028 add idd12
          INTO g_idd[l_i].idd05,g_idd[l_i].idd06,
               g_idd[l_i].idd13,g_idd[l_i].idd18 
 
         IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         #---------------------------------------------------------------#
         #LET l_slip = l_idd10[1,3]  #FUN-C40014
         CALL s_get_doc_no(l_idd10) RETURNING l_slip  #FUN-C40014 
         SELECT smydesc INTO g_idd[l_i].smydesc       #單據性質
           FROM smy_file
          WHERE smyslip = l_slip
         LET g_idd[l_i].idd10 = l_idd10               #異動單號
         LET g_idd[l_i].idd11 = l_idd11               #異動單號項次
         LET g_idd[l_i].idd12 = l_idd12               #出入庫類別     #MOD-AC0028 add 
   
         CASE
             WHEN tm.detail = 'N'
#                  OPEN idd_cs USING g_idd[l_i].idd10,
#                                       g_idd[l_i].idd11
                   FOREACH idd_cs USING g_idd[l_i].idd10,g_idd[l_i].idd11,
                                        g_idd[l_i].idd12              #MOD-AC0028 add
                      INTO g_idd[l_i].idd01, #料號
                           g_idd[l_i].ima02,     #品名                                                                
                           g_idd[l_i].ima021,    #規格                                                                
                           g_idd[l_i].idd15,     #母體料號                                                            
                           g_idd[l_i].ima06,     #分群碼                                                              
                           g_idd[l_i].ima08,     #來源碼                                                              
                           g_idd[l_i].idc19,     #最終料號                                                            
                           g_idd[l_i].idd07,     #庫存單位                                                            
                           g_idd[l_i].idd02,     #倉                                                                  
                           g_idd[l_i].idd03,     #儲                                                                  
                           g_idd[l_i].idd04,     #批號 
                           g_idd[l_i].idd16,     #母批                                                                
                           g_idd[l_i].idd12,     #出入庫                                                              
                           g_idd[l_i].idd08,      #異動日期   #FUN-CC0079    ,
                           g_idd[l_i].idd17       #DateCode  #FUN-CC0079                    
                      EXIT FOREACH                                                                                                   
                    END FOREACH                                    
 
             WHEN tm.detail = 'Y'
#                  OPEN idd_cs USING g_idd[l_i].idd10,
                FOREACH idd_cs USING g_idd[l_i].idd10,
                                     g_idd[l_i].idd11,
                                     g_idd[l_i].idd05,
                                     g_idd[l_i].idd06,
                                     g_idd[l_i].idd12              #MOD-AC0028 add
                                INTO g_idd[l_i].idd01, #料號
                                     g_idd[l_i].ima02,     #品名                                                                
                                     g_idd[l_i].ima021,    #規格                                                                
                                     g_idd[l_i].idd15,     #母體料號                                                            
                                     g_idd[l_i].ima06,     #分群碼                                                              
                                     g_idd[l_i].ima08,     #來源碼                                                              
                                     g_idd[l_i].idc19,     #最終料號                                                            
                                     g_idd[l_i].idd07,     #庫存單位                                                            
                                     g_idd[l_i].idd02,     #倉                                                                  
                                     g_idd[l_i].idd03,     #儲                                                                  
                                     g_idd[l_i].idd04,     #批號
                                     g_idd[l_i].idd16,     #母批                                                                
                                     g_idd[l_i].idd12,     #出入庫                                                              
                                     g_idd[l_i].idd08,      #異動日期    #FUN-CC0079 ,
                                     g_idd[l_i].idd17       #DateCode  #FUN-CC0079                              
                                EXIT FOREACH                                                                                                   
                            END FOREACH                                               
            END CASE
#         FOREACH idd_cs INTO g_idd[l_i].idd01, #料號
#                                g_idd[l_i].ima02,     #品名
#                                g_idd[l_i].ima021,    #規格
#                                g_idd[l_i].idd15,     #母體料號
#                                g_idd[l_i].ima06,     #分群碼
#                                g_idd[l_i].ima08,     #來源碼
#                                g_idd[l_i].idc19,     #最終料號
#                                g_idd[l_i].idd07,     #庫存單位
#                                g_idd[l_i].idd02,     #倉
#                                g_idd[l_i].idd03,     #儲
#                               g_idd[l_i].idd04,     #批號
#                               g_idd[l_i].idd16,     #母批
#                               g_idd[l_i].idd12,     #出入庫
#                               g_idd[l_i].idd08      #異動日期
#           EXIT FOREACH
#        END FOREACH
         SELECT ima02 INTO g_idd[l_i].ima02_2         #品名
           FROM ima_file 
          WHERE ima01 = g_idd[l_i].idc19
 
         LET l_tlf13 = NULL
#         OPEN tlf_cs USING g_idd[l_i].idd01, g_idd[l_i].idd02,
#                           g_idd[l_i].idd03, g_idd[l_i].idd04,
#                           g_idd[l_i].idd10, g_idd[l_i].idd11
#         FOREACH tlf_cs INTO g_idd[l_i].tlf19,        #廠商/客戶
#                             l_tlf13                  #異動命令
         #No.MOD-8B0043 modify --begin
         #FOREACH tlf_cs USING g_idd[l_i].idd01, g_idd[l_i].idd02,
         #                     g_idd[l_i].idd03, g_idd[l_i].idd04,
         #                     g_idd[l_i].idd10, g_idd[l_i].idd11
         #                INTO g_idd[l_i].tlf19,l_tlf13
          FOREACH tlf_cs USING g_idd[l_i].idd01, g_idd[l_i].idd02,g_idd[l_i].idd02,
                               g_idd[l_i].idd03,g_idd[l_i].idd03, g_idd[l_i].idd04,g_idd[l_i].idd04,
                               g_idd[l_i].idd10,g_idd[l_i].idd10, g_idd[l_i].idd11,g_idd[l_i].idd11
                          INTO g_idd[l_i].tlf19,l_tlf13
         #No.MOD-8B0043 modify --begin
            EXIT FOREACH
         END FOREACH 
         CASE
             WHEN l_tlf13 = 'apmt1101' OR             #收貨
                  l_tlf13 = 'apmt150'  OR             #入庫
                  l_tlf13 = 'apmt1072'                #倉退
                  SELECT pmc02 INTO g_idd[l_i].desc
                    FROM pmc_file
                   WHERE pmc01 = g_idd[l_i].tlf19
                  CASE
                      WHEN l_tlf13 = 'apmt1101'       #收貨
                           SELECT rvb04,rvb03 
                             INTO g_idd[l_i].raw_no,g_idd[l_i].raw_item
                             FROM rvb_file
                            WHERE rvb01 = g_idd[l_i].idd10
                              AND rvb02 = g_idd[l_i].idd11
                      WHEN l_tlf13 = 'apmt150'        #入庫
                           SELECT rvv36,rvv37 
                             INTO g_idd[l_i].raw_no,g_idd[l_i].raw_item
                             FROM rvv_file
                            WHERE rvv01 = g_idd[l_i].idd10
                              AND rvv02 = g_idd[l_i].idd11
                              AND rvv03 = '1'
                      WHEN l_tlf13 = 'apmt1072'       #倉退
                           SELECT rvv36,rvv37 
                             INTO g_idd[l_i].raw_no,g_idd[l_i].raw_item
                             FROM rvv_file
                            WHERE rvv01 = g_idd[l_i].idd10
                              AND rvv02 = g_idd[l_i].idd11
                              AND rvv03 = '3'
                  END CASE
             WHEN l_tlf13 = 'axmt620' OR               #出貨
                  l_tlf13 = 'aomt800'                  #銷退
                  SELECT occ02 INTO g_idd[l_i].desc
                    FROM occ_file
                   WHERE occ01 = g_idd[l_i].tlf19
                  CASE
                      WHEN l_tlf13 = 'axmt620'         #出貨
                           SELECT ogb31,ogb32 
                             INTO g_idd[l_i].raw_no,g_idd[l_i].raw_item
                             FROM ogb_file
                            WHERE ogb01 = g_idd[l_i].idd10
                              AND ogb03 = g_idd[l_i].idd11
                      WHEN l_tlf13 = 'aomt800'         #銷退
                           SELECT ohb33,ohb34 
                             INTO g_idd[l_i].raw_no,g_idd[l_i].raw_item
                             FROM ohb_file
                            WHERE ohb01 = g_idd[l_i].idd10
                              AND ohb03 = g_idd[l_i].idd11
                  END CASE
             OTHERWISE
                   LET g_idd[l_i].desc = NULL
                   LET g_idd[l_i].raw_no = NULL
                   LET g_idd[l_i].raw_item = NULL
         END CASE
         #---------------------------------------------------------------#
         LET l_i = l_i + 1 
         IF l_i > g_max_rec THEN
            CALL cl_err( '', 9035, 0 )
            EXIT FOREACH
         END IF
      END FOREACH
      IF l_i > g_max_rec THEN
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_idd.deleteElement(l_i)  #No.MOD-8B0043 add
   LET l_i = l_i - 1
   LET g_rec_b = l_i
 # CALL g_idd.deleteElement(l_i)  #No.MOD-8B0043 mark
   DISPLAY g_rec_b TO FORMONLY.cn2
   IF g_rec_b != 0 THEN
      CALL fgl_set_arr_curr(1)
   END IF
END FUNCTION
      
FUNCTION q023_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
   DEFINE   l_tree_arr_curr    LIKE type_file.num5  #FUN-B30195
   DEFINE   l_curs_index       STRING               #FUN-B30195 focus的資料是在第幾筆
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   #FUN-B30195 --START--
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_tree TO tree.*
         BEFORE DISPLAY
            #重算g_curs_index，按上下筆按鈕才會正確
            #因為double click tree node後,focus tree的節點會改變
            IF g_tree_focus_idx <= 0 THEN
               LET g_tree_focus_idx = ARR_CURR()
            END IF

            #以最上層的id當作單頭的g_curs_index
            #CALL cl_str_sepsub(g_tree[g_tree_focus_idx].id CLIPPED,".",1,1) RETURNING l_curs_index #依分隔符號分隔字串後，截取指定起點至終點的item
            #CALL q023_jump() RETURNING g_curs_index
            LET g_curs_index = 1
            CALL cl_navigator_setting(g_curs_index, g_row_count)

         BEFORE ROW
            LET l_tree_arr_curr = ARR_CURR() #目前在tree的row 
            CALL DIALOG.setSelectionMode( "tree", 1 )  
            CALL cl_set_act_visible("addchild",TRUE)   
         
      END DISPLAY   

   #FUN-B30195 --END--
   
      #DISPLAY ARRAY g_idd TO s_idd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)   #FUN-B30195 mark
      DISPLAY ARRAY g_idd TO s_idd.* ATTRIBUTE(COUNT=g_rec_b)               #FUN-B30195
       
      BEFORE DISPLAY
        CALL cl_navigator_setting(g_curs_index,g_row_count)
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      END DISPLAY   #FUN-B30195
      
      ON ACTION query
         LET g_action_choice="query"
         #EXIT DISPLAY   #FUN-B30195 mark
         EXIT DIALOG     #FUN-B30195
         
      ON ACTION first
         CALL q023_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
                              
      ON ACTION previous
         CALL q023_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
                              
      ON ACTION jump
         CALL q023_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF                            
 
      ON ACTION next
         CALL q023_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF                              
 
      ON ACTION last
         CALL q023_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
           
      ON ACTION qry_back                        
         LET g_t = ARR_CURR()
         LET g_action_choice = 'qry_back'
         #EXIT DISPLAY   #FUN-B30195 mark
         EXIT DIALOG     #FUN-B30195
 
      ON ACTION help
         LET g_action_choice="help"
         #EXIT DISPLAY   #FUN-B30195 mark
         EXIT DIALOG     #FUN-B30195
 
      ON ACTION locale
         CALL cl_dynamic_locale()
 
      ON ACTION exit
         LET g_action_choice="exit"
         #EXIT DISPLAY   #FUN-B30195 mark
         EXIT DIALOG     #FUN-B30195
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         #EXIT DISPLAY   #FUN-B30195 mark
         EXIT DIALOG     #FUN-B30195
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         #EXIT DISPLAY   #FUN-B30195 mark
         EXIT DIALOG     #FUN-B30195
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         #CONTINUE DISPLAY   #FUN-B30195 mark
         CONTINUE DIALOG     #FUN-B30195
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION cancel                                                          
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"                                             
         #EXIT DISPLAY   #FUN-B30195 mark
         EXIT DIALOG     #FUN-B30195
   #END DISPLAY   #FUN-B30195 mark
   END DIALOG   #FUN-B30195
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q023_tmp()
  DROP TABLE q023_temp                                                                                                             
                                                                                                                                    
   CREATE TEMP TABLE q023_tmp(                                                                                                      
          idd10    LIKE idd_file.idd10,                                                                                             
          idd11    LIKE idd_file.idd11,                                                                                       
          idd04    LIKE idd_file.idd04, 
          lot      LIKE idd_file.idd16,
          type     LIKE type_file.chr1,
          seq      LIKE type_file.num5,
          idd12    LIKE idd_file.idd12)      #MOD-AC0028 add
                                                                                                                    
   IF SQLCA.SQLCODE THEN                                                                                                            
     CALL cl_err('cretmp',SQLCA.SQLCODE,1)                                                                                          
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM                                                                                                                   
   END IF
END FUNCTION

#FUN-B30195 --START-- Tree填充
FUNCTION q023_tree_fill(p_pid,p_level,p_path,p_key1)   
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路徑
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING
   DEFINE l_idd              DYNAMIC ARRAY OF RECORD
             idd16           LIKE idd_file.idd16,
             idd04           LIKE idd_file.idd04,             
             child_cnt       LIKE type_file.num5  #子節點數
             END RECORD   
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴圈.
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5

   LET max_level = 20 #設定最大階層數為20

   IF p_level = 0 THEN
      LET g_idx = 0
      LET p_level = 1
      CALL g_tree.clear()
      CALL l_idd.clear()

      #Tree的最上層
      LET g_sql = "SELECT DISTINCT lot as idd16,lot as idd04,COUNT(idd04) as child_cnt",
                  " FROM q023_tmp",
                  "  WHERE NOT lot IN (select DISTINCT idd04 from q023_tmp WHERE  idd04 <> lot)",
                  "   AND NOT lot = ' ' AND NOT idd04 = ' '",
                  "  GROUP BY lot "
                     	            
      PREPARE q023_tree_pre1 FROM g_sql
      DECLARE q023_tree_cs1 CURSOR FOR q023_tree_pre1      

      LET l_i = 1      
      FOREACH q023_tree_cs1 INTO l_idd[l_i].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF         
         
         LET g_idx = g_idx + 1
         LET g_tree[g_idx].pid = NULL
         LET l_str = l_i  #數值轉字串
         LET g_tree[g_idx].id = l_str
         LET g_tree[g_idx].expanded = TRUE    #TRUE:展開, FALSE:不展開         
         LET g_tree[g_idx].name = l_idd[l_i].idd16
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].path = l_idd[l_i].idd16 
         LET g_tree[g_idx].treekey1 = l_idd[l_i].idd16         
         #有子節點
         IF l_idd[l_i].child_cnt > 0 THEN
            LET g_tree[g_idx].has_children = TRUE
            CALL q023_tree_fill(g_tree[g_idx].id,p_level,g_tree[g_idx].path,g_tree[g_idx].treekey1)
         ELSE
            LET g_tree[g_idx].has_children = FALSE
         END IF
         LET l_i = l_i + 1
      END FOREACH
   ELSE
      LET p_level = p_level + 1   #下一階層
      IF p_level > max_level THEN
         CALL cl_err_msg("","agl1001",max_level,0)
         RETURN
      END IF
  
      LET g_sql = "SELECT DISTINCT lot as idd16,idd04,0 as child_cnt",
                  " FROM q023_tmp WHERE lot = '",p_key1 CLIPPED,"'",
                  "  AND NOT lot = ' ' AND NOT idd04 = ' '",                   
                  "  AND idd04 <> lot"
                  
      PREPARE q023_tree_pre2 FROM g_sql
      DECLARE q023_tree_cs2 CURSOR FOR q023_tree_pre2

      #在FOREACH中直接使用遞迴,資料會錯亂,所以先將資料放到陣列後,在FOR迴圈處理
      LET l_cnt = 1
      CALL l_idd.clear()
      FOREACH q023_tree_cs2 INTO l_idd[l_cnt].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF
         LET l_cnt = l_cnt + 1
      END FOREACH
      CALL l_idd.deleteelement(l_cnt)  #刪除FOREACH最後新增的空白列
      LET l_cnt = l_cnt - 1

      IF l_cnt >0 THEN
         FOR l_i=1 TO l_cnt
            LET g_idx = g_idx + 1
            LET g_tree[g_idx].pid = p_pid CLIPPED
            LET l_str = l_i  #數值轉字串
            LET g_tree[g_idx].id = g_tree[g_idx].pid,".",l_str
            LET g_tree[g_idx].expanded = TRUE    #TRUE:展開, FALSE:不展開            
            LET g_tree[g_idx].name = l_idd[l_i].idd04
            LET g_tree[g_idx].level = p_level
            LET g_tree[g_idx].path = p_path CLIPPED,".",l_idd[l_i].idd04
            LET g_tree[g_idx].treekey1 = l_idd[l_i].idd04
            SELECT COUNT(idd04) INTO l_idd[l_i].child_cnt FROM q023_tmp 
             WHERE lot = l_idd[l_i].idd04 AND NOT idd04 = l_idd[l_i].idd04 
              AND NOT lot = ' ' AND NOT idd04 = ' '              
            #有子節點
            IF l_idd[l_i].child_cnt > 0 THEN
               LET g_tree[g_idx].has_children = TRUE
               CALL q023_tree_fill(g_tree[g_idx].id,p_level,g_tree[g_idx].path,g_tree[g_idx].treekey1)
            ELSE
               LET g_tree[g_idx].has_children = FALSE
            END IF
         END FOR
      END IF
   END IF
END FUNCTION
#FUN-B30195 --END--

#No.FUN-830083 by hellen 過單
