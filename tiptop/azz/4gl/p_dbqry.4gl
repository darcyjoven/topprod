# Prog. Version..: '5.30.06-13.03.22(00008)'     #
#
# Pattern name...: p_dbqry.4gl
# Descriptions...: 簡易資料查詢工具(For GP5.2 Only)
# Date & Author..: 09/09/25 by Hiko  FUN-9A0039
# Memo...........: 此程式的來源為p_zta的FUNCTION
#                : p_dbqry_menu
#                : p_dbqry_buildForm
#                : p_dbqry_buildTable
#                : p_dbqry_buildRecordView
#                : p_dbqry_bp
#                : p_dbqry
# Modify.........: No.FUN-9C0036 09/12/24 by Echo  調整 SQL 發生錯誤時無詳細的說明
# Modify.........: No.FUN-A60085 10/06/25 By Jay 呼叫cl_query_prt_getlength()只做一次CREATE TEMP TABLE
# Modify.........: No.FUN-AC0011 11/03/09 By Jay 調整截取sql語法中table name、別名、欄位名稱方式
# Modify.........: No.FUN-A80094 11/04/20 By jenjwu 將result段增加按鈕以顯示parse後的SQL程式，及重新顯示結果之按鈕，修正按ctrl+enter後，顯示的錯誤
# Modify.........: No.FUN-A80094 11/05/25 By jenjwu 調整按取銷按鈕後無法正常查詢的錯誤。
# Modify.........: No.FUN-C10031 12/05/16 By andyhuang p_zta要還原[資料庫查詢]的串查功能
# Modify.........: No.CHI-D30034 13/03/22 By zack 修正輸入大寫字會無法執行,出現"can not execute this command"

DATABASE ds
 
#FUN-9A0039
GLOBALS "../../config/top.global"
 
CONSTANT GI_MAX_COLUMN_COUNT INTEGER = 400,                #TQC-710089
         GI_COLUMN_WIDTH     INTEGER = 10
#TQC-710089
DEFINE   ga_table_data DYNAMIC ARRAY OF RECORD
            field001, field002, field003, field004, field005,
            field006, field007, field008, field009, field010,
            field011, field012, field013, field014, field015,
            field016, field017, field018, field019, field020,
            field021, field022, field023, field024, field025,
            field026, field027, field028, field029, field030,
            field031, field032, field033, field034, field035,
            field036, field037, field038, field039, field040,
            field041, field042, field043, field044, field045,
            field046, field047, field048, field049, field050,
            field051, field052, field053, field054, field055,
            field056, field057, field058, field059, field060,
            field061, field062, field063, field064, field065,
            field066, field067, field068, field069, field070,
            field071, field072, field073, field074, field075,
            field076, field077, field078, field079, field080,
            field081, field082, field083, field084, field085,
            field086, field087, field088, field089, field090,
            field091, field092, field093, field094, field095,
            field096, field097, field098, field099, field100,
            field101, field102, field103, field104, field105,
            field106, field107, field108, field109, field110,
            field111, field112, field113, field114, field115,
            field116, field117, field118, field119, field120,
            field121, field122, field123, field124, field125,
            field126, field127, field128, field129, field130,
            field131, field132, field133, field134, field135,
            field136, field137, field138, field139, field140,
            field141, field142, field143, field144, field145,
            field146, field147, field148, field149, field150,
            field151, field152, field153, field154, field155,
            field156, field157, field158, field159, field160,
            field161, field162, field163, field164, field165,
            field166, field167, field168, field169, field170,
            field171, field172, field173, field174, field175,
            field176, field177, field178, field179, field180,
            field181, field182, field183, field184, field185,
            field186, field187, field188, field189, field190,
            field191, field192, field193, field194, field195,
            field196, field197, field198, field199, field200,
            field201, field202, field203, field204, field205,
            field206, field207, field208, field209, field210,
            field211, field212, field213, field214, field215,
            field216, field217, field218, field219, field220,
            field221, field222, field223, field224, field225,
            field226, field227, field228, field229, field230,
            field231, field232, field233, field234, field235,
            field236, field237, field238, field239, field240,
            field241, field242, field243, field244, field245,
            field246, field247, field248, field249, field250,
            field251, field252, field253, field254, field255,
            field256, field257, field258, field259, field260,
            field261, field262, field263, field264, field265,
            field266, field267, field268, field269, field270,
            field271, field272, field273, field274, field275,
            field276, field277, field278, field279, field280,
            field281, field282, field283, field284, field285,
            field286, field287, field288, field289, field290,
            field291, field292, field293, field294, field295,
            field296, field297, field298, field299, field300,
            field301, field302, field303, field304, field305,
            field306, field307, field308, field309, field310,
            field311, field312, field313, field314, field315,
            field316, field317, field318, field319, field320,
            field321, field322, field323, field324, field325,
            field326, field327, field328, field329, field330,
            field331, field332, field333, field334, field335,
            field336, field337, field338, field339, field340,
            field341, field342, field343, field344, field345,
            field346, field347, field348, field349, field350,
            field351, field352, field353, field354, field355,
            field356, field357, field358, field359, field360,
            field361, field362, field363, field364, field365,
            field366, field367, field368, field369, field370,
            field371, field372, field373, field374, field375,
            field376, field377, field378, field379, field380,
            field381, field382, field383, field384, field385,
            field386, field387, field388, field389, field390,
            field391, field392, field393, field394, field395,
            field396, field397, field398, field399, field400 LIKE gaq_file.gaq03
END RECORD
#END TQC-710089
DEFINE g_str STRING,
       g_dba_priv           LIKE type_file.chr1, #No.FUN-680135 VARCHAR(1)
       g_dbqry_rec_b        LIKE type_file.num5, #No.FUN-680135 SMALLINT:dbqry單身筆數
       l_ac                 LIKE type_file.num5, #No.FUN-680135 SMALLINT:目前處理的ARRAY CNT
       g_db_type            LIKE type_file.chr3  #No.FUN-680135 VARCHAR(3)
DEFINE g_nohidden_cnt       LIKE type_file.num5  #No.FUN-9C0036 顯示欄位數
DEFINE g_sql2               STRING               #No.FUN-A80094 
DEFINE g_value              SMALLINT		 #FUN-C10031 SMALLINT


MAIN
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_nohidden_cnt = 1               #FUN-9C0036

   #FUN-C10031 -- start --
   IF ARG_VAL(1) is not null THEN
      LET g_dbs = ARG_VAL(1)
      PREPARE sql01 FROM "SELECT * FROM (SELECT count(*) AS count FROM azw_file WHERE lower(azw06) = ?) tb1 ,
         (SELECT azw01 FROM azw_file WHERE lower(azw06) = ?) tb2"
      EXECUTE sql01 USING g_dbs,g_dbs INTO g_value,g_plant
      IF g_value >= 1 THEN
         CALL cl_ins_del_sid(2,'')
         DATABASE g_dbs
         CALL cl_ins_del_sid(1,g_plant)
         IF g_value > 1 THEN
            CALL p_dbqry_plant()
         END IF
      END IF
      IF g_value = 0 THEN
         CALL cl_err('DATABASE',SQLCA.SQLCODE,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      FREE sql01
   END IF
   #FUN-C10031 -- end --

   CALL p_dbqry_buildForm()
   CALL ga_table_data.clear()           #FUN-830143
   LET g_str = null                     #FUN-830143
   LET g_sql2 = null                    #FUN-A80094
   DISPLAY " " TO formonly.text1
   DISPLAY " " TO formonly.text2
 
   CALL p_dbqry_menu()
 
   CLOSE WINDOW p_dbqry_table
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
FUNCTION p_dbqry_menu()
DEFINE l_sel LIKE type_file.chr1        #No.FUN-680135 VARCHAR(1)
DEFINE w ui.Window                      #MOD-890209
DEFINE n om.DomNode                     #MOD-890209
 
   LET l_sel='I'

   #FUN-9C0036 -- start --
   #CALL p_dbqry(l_sel) RETURNING l_sel  
   #IF INT_FLAG=1 THEN
   #   RETURN
   #END IF
   #FUN-9C0036 -- end --

   WHILE TRUE
      CALL p_dbqry_bp("G")
      CASE g_action_choice
        WHEN "inputsql"
             CALL p_dbqry(l_sel) RETURNING l_sel 
       #FUN-A80094 start
        WHEN "show_result"
             CALL p_dbqry_result(l_sel)
       #FUN-A80094 end
        WHEN "exporttoexcel"
           LET w = ui.Window.getCurrent()
           LET n = w.getNode()
           CALL cl_export_to_excel(n,base.TypeInfo.create(ga_table_data),'','')
        WHEN "exit"
           EXIT WHILE
        WHEN "controlg"
             CALL cl_cmdask()
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION p_dbqry_buildForm()
    DEFINE lw_win   ui.Window
    DEFINE lf_form  ui.Form
    DEFINE ln_win,  ln_form, ln_vbox om.DomNode
    DEFINE ls_vbox  om.NodeList
 
    OPEN WINDOW p_dbqry_table WITH FORM "azz/42f/p_dbqry" ATTRIBUTE(STYLE = g_win_style)
 
    CALL cl_ui_init()
 
    LET lw_win = ui.Window.getCurrent()
    LET ln_win = lw_win.getNode()
    LET lf_form = lw_win.getForm()
    LET ln_form = lf_form.getNode()
    LET ls_vbox = ln_form.selectByPath("//Form//VBox")
    LET ln_vbox = ls_vbox.item(1)
    CALL p_dbqry_buildTable(ln_vbox)
 
END FUNCTION
 
FUNCTION p_dbqry_buildTable(pn_vbox)
    DEFINE pn_vbox    om.DomNode
    DEFINE ln_table,ln_table_column, ln_edit om.DomNode
    DEFINE ln_grid,ln_FormField, ln_TextEdit,ln_RadioGroup,ln_Item om.DomNode
    DEFINE li_i       LIKE type_file.num10   #No.FUN-680135 INTEGER
    DEFINE ls_colname STRING
 
 
    LET ln_table = pn_vbox.createChild("Table")
    CALL ln_table.setAttribute("tabName", "s_table_data")
    CALL ln_table.setAttribute("pageSize", 10)
    CALL ln_table.setAttribute("size", 10)
    CALL ln_table.setAttribute("unhidableColumns", 1)
    FOR li_i = 1 TO GI_MAX_COLUMN_COUNT
        LET ln_table_column = ln_table.createChild("TableColumn")
        LET ls_colname = "field", li_i USING "&&&"
        CALL ln_table_column.setAttribute("colName", ls_colname)
        CALL ln_table_column.setAttribute("name", "formonly." || ls_colname)
        CALL ln_table_column.setAttribute("text", ls_colname)
        CALL ln_table_column.setAttribute("noEntry", 1)
        #FUN-9C0036 -- start -- 
        IF li_i <= g_nohidden_cnt THEN
            CALL ln_table_column.setAttribute("hidden", 0)
        ELSE
            CALL ln_table_column.setAttribute("hidden", 1)
        END IF
        #FUN-9C0036 -- end -- 
        CALL ln_table_column.setAttribute("tabIndex", li_i)  #TQC-710089
        LET ln_edit = ln_table_column.createChild("Edit")
        CALL ln_edit.setAttribute("width", GI_COLUMN_WIDTH)
    END FOR
    LET ln_grid = pn_vbox.createChild("Grid")
    LET ln_formfield = ln_grid.createChild("FormField")
    CALL ln_formfield.setAttribute("colName","selmethod")
    CALL ln_formfield.setAttribute("name","formonly.selmethod")
    LET ln_radiogroup = ln_formfield.createChild("RadioGroup")
    CALL ln_radiogroup.setAttribute("orientation","horizontal")
    LET ln_item = ln_radiogroup.createChild("Item")
    CALL ln_item.setAttribute("name","I")
    CALL ln_item.setAttribute("text","show Field ID")
    LET ln_item = ln_radiogroup.createChild("Item")
    CALL ln_item.setAttribute("name","N")
    CALL ln_item.setAttribute("text","show Field Name")
    LET ln_item = ln_radiogroup.createChild("Item")
    CALL ln_item.setAttribute("name","A")
    CALL ln_item.setAttribute("text","show Field ID+Name")
END FUNCTION
 
FUNCTION p_dbqry_buildRecordView(pn_form)
    DEFINE pn_form om.DomNode
    DEFINE ln_recview, ln_link om.DomNode
    DEFINE ls_colname STRING
    DEFINE li_i LIKE type_file.num10   #No.FUN-680135 INTEGER
 
 
    LET ln_recview = pn_form.createChild("RecordView")
    CALL ln_recview.setAttribute("tabName", "formonly")
    FOR li_i = 1 TO GI_MAX_COLUMN_COUNT
        LET ls_colname = "field", li_i USING "&&&"
        LET ln_link = ln_recview.createChild("Link")
        CALL ln_link.setAttribute("colName", ls_colname)
    END FOR
END FUNCTION
 
FUNCTION p_dbqry_bp(p_ud)
DEFINE   p_ud       LIKE type_file.chr1                #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "field_body" 
      OR g_action_choice = "index_body" 
      OR g_action_choice = "constraint_body"           #FUN-730016
   THEN
      IF g_dba_priv != '1' THEN
         LET g_action_choice=''
      END IF
      RETURN
   END IF
 
   LET g_action_choice = " "
      CALL cl_set_act_visible("accept,cancel", FALSE)  #FUN-A80094 
      IF  g_sql2 IS NOT null THEN
          CALL cl_set_act_visible("show_result", TRUE) 
      ELSE
          CALL cl_set_act_visible("show_result", FALSE) 
      END IF
   DISPLAY ARRAY ga_table_data TO s_table_data.* ATTRIBUTE (COUNT = g_dbqry_rec_b,UNBUFFERED)

       BEFORE ROW
          LET l_ac = ARR_CURR()
          LET g_action_choice="inputsql"
 
       ON ACTION inputsql
          LET g_action_choice="inputsql"
          EXIT DISPLAY
          #FUN-A80094 start                       #增加重新產生結果之按鈕
       ON ACTION show_result
          LET g_action_choice = "show_result"
          EXIT DISPLAY
          #FUN-A80094 end
       ON ACTION locale
          CALL cl_dynamic_locale()
          EXIT DISPLAY
       ON ACTION exit                             #Esc.結束
          LET g_action_choice="exit"
          EXIT DISPLAY
       ON ACTION exporttoexcel
          LET g_action_choice = "exporttoexcel"
          EXIT DISPLAY
       ON ACTION controlg
          LET g_action_choice="controlg"
          EXIT DISPLAY
       ON ACTION cancel
           LET INT_FLAG=FALSE 		          #MOD-570244	mars         
           LET g_action_choice="exit"
           EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
    END DISPLAY
    
#    CALL cl_set_act_visible("sql_parse,qry_result,cancel", TRUE)  #FUN-A800094
END FUNCTION
 
FUNCTION p_dbqry(l_sel)
    DEFINE l_text      STRING
    DEFINE l_str       STRING
    DEFINE l_sql       STRING
    DEFINE l_tmp       STRING
    DEFINE l_tmp_chk   STRING                       #CHI-D30034
    DEFINE l_execmd    STRING
    DEFINE l_tok       base.StringTokenizer
    DEFINE l_start     LIKE type_file.num5          #No.FUN-680135 SMALLINT
    DEFINE l_end       LIKE type_file.num5          #No.FUN-680135 SMALLINT
    DEFINE l_feld_tmp  LIKE type_file.chr1000       #No.FUN-680135 VARCHAR(55)
    DEFINE l_feld      DYNAMIC ARRAY OF STRING
    DEFINE l_length    DYNAMIC ARRAY OF LIKE type_file.num5  #No.FUN-680135 SMALLINT
    DEFINE l_feld_t    DYNAMIC ARRAY OF STRING
    DEFINE l_tab       DYNAMIC ARRAY OF STRING
    DEFINE l_tab_alias DYNAMIC ARRAY OF STRING
    DEFINE l_i         LIKE type_file.num5          #No.FUN-680135 SMALLINT
    DEFINE l_j         LIKE type_file.num5          #No.FUN-680135 SMALLINT
    DEFINE l_k         LIKE type_file.num5          #No.FUN-680135 SMALLINT
    DEFINE ln_table_column, ln_edit,ln_w om.DomNode
    DEFINE ls_items    om.NodeList
    DEFINE ls_colname  STRING
    DEFINE lw_w        ui.window
    DEFINE l_feld_cnt  LIKE type_file.num5          #No.FUN-680135 SMALLINT
    DEFINE l_tab_cnt   LIKE type_file.num5          #No.FUN-680135 SMALLINT
    DEFINE l_colname   LIKE gaq_file.gaq01,         #No.FUN-680135 VARCHAR(20)
           l_colnamec  LIKE gaq_file.gaq03,         #No.FUN-680135 VARCHAR(50)
           l_collen    LIKE type_file.num5,         #No.FUN-680135 SMALLINT
           l_coltype   LIKE type_file.chr3,         #No.FUN-680135 VARCHAR(3)
           l_sel       LIKE type_file.chr1,         #No.FUN-680135 VARCHAR(1)
           l_str_len   LIKE type_file.num10,        #CHI-910011 add
           l_index     LIKE type_file.num10,        #CHI-910011 add
           l_where     STRING                       #CHI-910011 add
    DEFINE l_feld_id   DYNAMIC ARRAY OF LIKE type_file.chr30      #No.FUN-720026
    DEFINE l_table_tok base.StringTokenizer         #FUN-AC0011
    DEFINE l_action    STRING                       #FUN-A80094
    DEFINE l_err       STRING                       #FUN-A80094  
    
    CALL cl_set_act_visible("sql_parse,qry_result,cancel", TRUE)  #FUN-A80094        
    LET g_nohidden_cnt = 1         #FUN-9C0036
    #LET l_sel='I'

   INPUT g_str,l_sel WITHOUT DEFAULTS FROM text1,selmethod HELP 1
   
      BEFORE INPUT
         LET l_text = null
         LET l_action = 1
         LET l_err = null
        #LET g_action_choice = "gry_result" #FUN-A80094

    #FUN-A80094 原AFTER INPUT段之程式移至INPUT後面 
       
    #FUN-A80094 start
    ON ACTION sql_parse
       LET g_action_choice = "sql_parse"
       ACCEPT INPUT
       
    ON ACTION qry_result
       LET l_action = 1
       LET g_action_choice = "qry_result"         
       ACCEPT INPUT         
    
    ON ACTION cancel      
       LET g_action_choice = "cancel"
       DISPLAY g_str TO formonly.text1  #輸入SQL後按取銷則顯示原本輸入資料
       EXIT INPUT
    #FUN-A80094 end
    
    #TQC-860017 start
    ON ACTION about
       CALL cl_about()
 
    ON ACTION controlg
       CALL cl_cmdask()
 
    ON ACTION help
       CALL cl_show_help()
 
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE INPUT
    #TQC-860017 end       
    END INPUT
    
    #使用者是否按下中斷鍵的判斷
    IF INT_FLAG=1 THEN
       LET INT_FLAG = FALSE
       RETURN l_sel
    END IF
    
    #FUN-A80094 #原AFTER INPUT之parse SQL程式段移至此
    #SQL檢驗之程式段 
    LET l_str=g_str.toLowerCase()             #FUN-830143 去掉mark
    LET g_sql2=l_str.toLowercase()
    #--CHI-910011--start--
    LET l_str_len = g_str.getLength()
    LET l_index = l_str.getIndexOf('where',1)

    IF l_index <> 0 THEN
       LET l_where = g_str.subString(l_index+5 , l_str_len)
       LET l_str = l_str.subString(1,l_index+4),l_where
    END IF
    #--CHI-910011--end--
    
    #LET l_str=p_zta_cut_spaces(l_str)        #FUN-830143 #CHI-960098
    LET l_str = l_str.trim()                  #CHI-960098
    LET l_end = l_str.getIndexOf(';',1)

    IF l_end != 0 THEN
       LET l_str=l_str.subString(1,l_end-1)
    END IF

    LET l_tok = base.StringTokenizer.createExt(l_str CLIPPED,"\n","",TRUE)
    LET l_text = NULL                         #FUN-9C0036
    
    WHILE l_tok.hasMoreTokens()
          LET l_tmp=l_tok.nextToken()
          IF cl_null(l_text) THEN             #FUN-9C0036
             LET l_text = l_tmp.trim()
          ELSE
             LET l_text = l_text CLIPPED,' ',l_tmp.trim()
          END IF          
          #display "dbquery_sql:",l_text
    END WHILE
    
    LET l_tmp=l_text
    LET l_execmd=l_tmp
   {LET l_tmp=p_zta_cut_spaces(l_tmp)
    LET l_end = l_tmp.getIndexOf(';',1)
    IF l_end != 0 THEN
       LET l_tmp=l_tmp.subString(1,l_end-1)
    END IF}
    
    LET l_str=l_tmp
    #LET l_tmp=l_text
     LET l_tmp_chk=l_tmp.subString(1,6)                #CHI-D30034    
     #IF l_tmp.subString(1,6) != 'select' THEN         #mark CHI-D30034                          
     IF l_tmp_chk.toLowercase() != 'select' THEN       #CHI-D30034 
         CALL cl_err('can not execute this command!','!',0)  
         RETURN l_sel                                                                        
     END IF
         #FUN-A80094--add--  
     PREPARE table_pre1 FROM l_tmp     
     IF SQLCA.SQLCODE THEN
         LET l_err = 1   
     END IF

     DECLARE table_cur1 CURSOR FOR table_pre1

     IF SQLCA.SQLCODE THEN
         LET l_err = 1  
     END IF
 
     LET l_i = 1
     CALL ga_table_data.clear()
     #OPEN table_cur1
     #FETCH table_cur1 INTO ga_table_data[l_i].*
     #   IF SQLCA.SQLCODE THEN            
     #       LET l_err = 1  
     #   END IF
     #CLOSE table_cur1
     FOREACH  table_cur1 INTO ga_table_data[l_i].*
       IF SQLCA.sqlcode THEN
          LET l_err = 1
       ELSE
           LET l_i = l_i + 1
       END IF
     END FOREACH
     CALL ga_table_data.deleteElement(l_i)

     #FUN-A80094--add end--  

    #FUN-A80094 start                  
    IF g_action_choice = "sql_parse" THEN
        LET l_action = null
        CALL ga_table_data.clear()       #parse功能時不顯示欄位資料          
    END IF                                   
    
    IF l_err = 1 THEN                    #判斷是否顯示parse後的sql碼 
        LET ga_table_data = null         #當pares錯誤時清空結果欄位
        DISPLAY " " TO formonly.text2    #當pares錯誤時清空parse後的sql欄位 
        CALL cl_err('can not execute this command!','!',0) 
    ELSE 
        LET l_sql = cl_parse_qry_sql(g_str,g_plant)              #FUN-9C0036
        DISPLAY l_sql TO formonly.text2
        
    END IF                
        
    IF l_action = 1 THEN         #增加是否需顯示欄位結果的判斷
       CALL p_dbqry_result(l_sel) 
    END IF
    #FUN-A80094 end
    CALL cl_set_act_visible("show_result", TRUE)
    RETURN l_sel
END FUNCTION


#FUN-A80094 start 
FUNCTION p_dbqry_result(l_sel)
    DEFINE l_text      STRING
    DEFINE l_str       STRING
    DEFINE l_sql       STRING
    DEFINE l_tmp       STRING
    DEFINE l_tmp_chk   STRING                       #No.CHI-D30034
    DEFINE l_execmd    STRING
    DEFINE l_tok       base.StringTokenizer
    DEFINE l_start     LIKE type_file.num5          #No.FUN-680135 SMALLINT
    DEFINE l_end       LIKE type_file.num5          #No.FUN-680135 SMALLINT
    DEFINE l_feld_tmp  LIKE type_file.chr1000       #No.FUN-680135 VARCHAR(55)
    DEFINE l_feld      DYNAMIC ARRAY OF STRING
    DEFINE l_length    DYNAMIC ARRAY OF LIKE type_file.num5        #No.FUN-680135 SMALLINT
    DEFINE l_feld_t    DYNAMIC ARRAY OF STRING
    DEFINE l_tab       DYNAMIC ARRAY OF STRING
    DEFINE l_tab_alias DYNAMIC ARRAY OF STRING
    DEFINE l_i         LIKE type_file.num5          #No.FUN-680135 SMALLINT
    DEFINE l_j         LIKE type_file.num5          #No.FUN-680135 SMALLINT
    DEFINE l_k         LIKE type_file.num5          #No.FUN-680135 SMALLINT
    DEFINE ln_table_column, ln_edit,ln_w om.DomNode
    DEFINE ls_items    om.NodeList
    DEFINE ls_colname  STRING
    DEFINE lw_w        ui.window
    DEFINE l_feld_cnt  LIKE type_file.num5          #No.FUN-680135 SMALLINT
    DEFINE l_tab_cnt   LIKE type_file.num5          #No.FUN-680135 SMALLINT
    DEFINE l_colname   LIKE gaq_file.gaq01,         #No.FUN-680135 VARCHAR(20)
           l_colnamec  LIKE gaq_file.gaq03,         #No.FUN-680135 VARCHAR(50)
           l_collen    LIKE type_file.num5,         #No.FUN-680135 SMALLINT
           l_coltype   LIKE type_file.chr3,         #No.FUN-680135 VARCHAR(3)
           l_sel       LIKE type_file.chr1,         #No.FUN-680135 VARCHAR(1)
           l_str_len   LIKE type_file.num10,        #CHI-910011 add
           l_index     LIKE type_file.num10,        #CHI-910011 add
           l_where     STRING                       #CHI-910011 add
    DEFINE l_feld_id   DYNAMIC ARRAY OF LIKE type_file.chr30      #No.FUN-720026
    DEFINE l_table_tok base.StringTokenizer         #FUN-AC0011
         
    #原AFTER INPUT抓取欄位結果之程式段移至於此
    LET l_tmp = g_sql2.tolowercase()    #FUN-A80094 
    LET l_str = l_tmp                   #FUN-A80094 
    LET l_tmp=g_str                     #FUN-A80094
    LET l_start = l_tmp.getIndexOf('select',1)
    LET l_end   = l_tmp.getIndexOf('from',1)
    #display "l_start:",l_start
    #display "l_end:",l_end
    LET l_str=l_str.subString(l_start+7,l_end-2)
    LET l_str=l_str.trim()
    LET l_tok = base.StringTokenizer.createExt(l_str CLIPPED,",","",TRUE)
    LET l_i=1

    WHILE l_tok.hasMoreTokens()
      LET l_feld[l_i]=l_tok.nextToken()
      LET l_feld[l_i]=l_feld[l_i].trim()
      LET l_i=l_i+1
      #display "feld",l_i-1,":",l_feld[l_i-1]
    END WHILE
               
    LET l_feld_cnt=l_i-1
    LET l_str = l_tmp          
    LET l_start = l_str.getIndexOf('from',1)
    LET l_end   = l_str.getIndexOf('where',1)
    IF l_end=0 THEN
       LET l_end   = l_str.getIndexOf('group',1)
       IF l_end=0 THEN
          LET l_end   = l_str.getIndexOf('order',1)
          IF l_end=0 THEN
             LET l_end=l_str.getLength()
             LET l_str=l_str.subString(l_start+5,l_end)
          ELSE
             LET l_str=l_str.subString(l_start+5,l_end-2)
          END IF
       ELSE
           LET l_str=l_str.subString(l_start+5,l_end-2)
       END IF
    ELSE
        LET l_str=l_str.subString(l_start+5,l_end-2)
    END IF
    
    LET l_str=l_str.trim()
    LET l_tok = base.StringTokenizer.createExt(l_str CLIPPED,",","",TRUE)
    LET l_j=1
    
    WHILE l_tok.hasMoreTokens()
    #---FUN-AC0011---start-----
    #因為sql語法中FROM後面的table有可能會以 JOIN 的形式出現
    #例1:SELECT XXX FROM nni_file nni LEFT OUTER JOIN nma_file ON nma01 = nni06, nnj_file LEFT OUTER JOIN nne_file ON nnj03 = nne01
    #例2:SELECT XXX FROM nni_file nni RIGHT OUTER JOIN nma_file ON nma01 = nni06, nnj_file LEFT OUTER JOIN nne_file ON nnj03 = nne01
    #例3:SELECT XXX FROM nni_file nni OUTER JOIN nma_file ON nma01 = nni06, nnj_file LEFT OUTER JOIN nne_file ON nnj03 = nne01
         LET l_str = l_tok.nextToken()

         #依照關鍵字去除,取代成逗號,以利分割table
         LET l_text = "left outer join"
         CALL cl_replace_str(l_str, l_text.toLowerCase(), ",") RETURNING l_str
         LET l_text = "right outer join"
         CALL cl_replace_str(l_str, l_text.toLowerCase(), ",") RETURNING l_str
         LET l_text = "outer join"
         CALL cl_replace_str(l_str, l_text.toLowerCase(), ",") RETURNING l_str
                     
         WHILE l_str.getIndexOf("on", 1) > 0
               #準備將on後面的條件式去除,如:XXXXXX JOIN nma_file nma [ON nma01 = nni06], 
               LET l_start = l_str.getIndexOf("on", 1) 

               #從剛才找出on關鍵字地方關始找下一個逗號,應該就是此次所要截取的table名稱和別名
               #如果後面已找不到逗號位置,代表應該已到字串的最尾端
               LET l_end = l_str.getIndexOf(",", l_start)  
               IF l_end = 0 THEN
                  LET l_end = l_str.getLength() + 1   #因為下面會減1,所以這裡先加1
               END IF
               
               LET l_text = l_str.subString(l_start, l_end - 1)
               CALL cl_replace_str(l_str, l_text, " ") RETURNING l_str
         END WHILE

         #依逗號區隔出各table名稱和別名
         LET l_table_tok = base.StringTokenizer.createExt(l_str CLIPPED,",","",TRUE)
         
         WHILE l_table_tok.hasMoreTokens()
          #---FUN-AC0011---end-------
          #LET l_tab[l_j]=l_tok.nextToken()               #FUN-AC0011 mark 改成下面取tok方式
               LET l_tab[l_j] = l_table_tok.nextToken()   #FUN-AC0011
               LET l_tab[l_j]=l_tab[l_j].trim()
               IF l_tab[l_j].getIndexOf(' ',1) THEN
                  DISPLAY 'qazzaq:',l_tab[l_j].getIndexOf(' ',1)
                  LET l_tab_alias[l_j]=l_tab[l_j].subString(l_tab[l_j].getIndexOf(' ',1)+1,l_tab[l_j].getLength())
                  LET l_tab[l_j]=l_tab[l_j].subString(1,l_tab[l_j].getIndexOf(' ',1)-1)
               END IF
               LET l_j=l_j+1
          #display "tab",l_j-1,":",l_tab[l_j-1],":",l_tab_alias[l_j-1]
         END WHILE                    #FUN-AC0011      
    END WHILE
    
    LET l_tab_cnt=l_j-1
    CALL cl_query_prt_temptable()     #No.FUN-A60085
         
    FOR l_i=1 TO l_feld_cnt
        IF l_feld[l_i]='*' THEN
           LET l_str=l_tmp         
           LET l_start = l_str.getIndexOf('from',1)
           LET l_end   = l_str.getIndexOf('where',1)
           IF l_end=0 THEN
              LET l_end   = l_str.getIndexOf('group',1)
              IF l_end=0 THEN
                 LET l_end   = l_str.getIndexOf('order',1)
                 IF l_end=0 THEN
                    LET l_end=l_str.getLength()
                    LET l_str=l_str.subString(l_start+5,l_end)
                 ELSE
                    LET l_str=l_str.subString(l_start+5,l_end-2)
                 END IF
              ELSE
                 LET l_str=l_str.subString(l_start+5,l_end-2)
              END IF
           ELSE
              LET l_str=l_str.subString(l_start+5,l_end-2)
           END IF
           LET l_str=l_str.trim()
           LET l_tok = base.StringTokenizer.createExt(l_str CLIPPED,",","",TRUE)
           FOR l_j=1 TO l_tab_cnt 
               CALL cl_query_prt_getlength(l_tab[l_j],l_sel,'m','0')   #No.FUN-990043
               DECLARE p_zta_dbqry_insert_d_ifx CURSOR FOR
               SELECT xabc02,xabc03,xabc04 FROM xabc ORDER BY xabc01
               FOREACH p_zta_dbqry_insert_d_ifx INTO l_feld_id[l_i],l_feld_tmp,l_length[l_i]  #No.FUN-720026 #No.FUN-990043
                   LET l_feld[l_i]=l_feld_tmp
                   LET l_i=l_i+1
               END FOREACH
                          LET l_feld_cnt=l_i-1
           END FOR
           EXIT FOR   #確保避免因人為的sql錯誤產生多除的顯示欄位
       ELSE
           IF l_feld[l_i].getIndexOf('.',1) THEN
              IF l_feld[l_i].subString(l_feld[l_i].getIndexOf('.',1)+1,l_feld[l_i].getLength())='*' THEN
                 FOR l_j=1 TO l_tab_cnt
                     IF l_tab_alias[l_j] is null THEN
                        IF l_tab[l_j]=l_feld[l_i].subString(1,l_feld[l_i].getIndexOf('.',1)-1) THEN
                           LET l_k=l_i                        #備份l_i的值
                           CALL l_feld.deleteElement(l_i)     #刪除xxx.*那筆資料
                           CALL l_length.deleteElement(l_i)   #刪除xxx.*那筆資料
                           CALL l_feld.insertElement(l_i)
                           CALL l_length.insertElement(l_i)
                           CALL cl_query_prt_getlength(l_tab[l_j],l_sel,'m','0')   #No.FUN-990043
                           DECLARE p_zta_dbqry_insert_d1_ifx CURSOR FOR 
                           SELECT xabc02,xabc03,xabc04 FROM xabc ORDER BY xabc01 DESC
                           FOREACH p_zta_dbqry_insert_d1_ifx INTO l_feld_id[l_i],l_feld_tmp,l_length[l_i] #No.FUN-720026 #No.FUN-990043
                               LET l_feld[l_i]=l_feld_tmp
                               CALL l_feld.insertElement(l_i)
                               CALL l_length.insertElement(l_i)
                               CALL l_feld_id.insertelement(l_i)    #FUN-AC0011
                               LET l_k=l_k+1
                               LET l_feld_cnt=l_feld_cnt+1
                           END FOREACH
                               CALL l_feld.deleteElement(l_i)   #刪除xxx.*那筆資料
                               CALL l_length.deleteElement(l_i) #刪除xxx.*那筆資料
                               CALL l_feld_id.deleteElement(l_i)    #FUN-AC0011
                               LET l_feld_cnt=l_feld_cnt-1
                               LET l_i=l_k-1
                        END IF
                    ELSE
                        IF l_tab_alias[l_j]=l_feld[l_i].subString(1,l_feld[l_i].getIndexOf('.',1)-1) THEN
                           LET l_k=l_i                          #備份l_i的值
                           CALL l_feld.deleteElement(l_i)       #刪除xxx.*那筆資料
                           CALL l_length.deleteElement(l_i)     #刪除xxx.*那筆資料
                           CALL l_feld.insertElement(l_i)
                           CALL l_length.insertElement(l_i)
                           CALL cl_query_prt_getlength(l_tab[l_j],l_sel,'m','0')   #No.FUN-990043
                           DECLARE p_zta_dbqry_insert_d2_ifx CURSOR FOR 
                           SELECT xabc02,xabc03,xabc04 FROM xabc ORDER BY xabc01 DESC
                           FOREACH p_zta_dbqry_insert_d2_ifx INTO l_feld_id[l_i],l_feld_tmp,l_length[l_i]  #No.FUN-720026 #No.FUN-990043
                                   LET l_feld[l_i]=l_feld_tmp
                                   CALL l_feld.insertElement(l_i)
                                   CALL l_length.insertElement(l_i)
                                   CALL l_feld_id.insertelement(l_i) #FUN-AC0011
                                   LET l_k=l_k+1
                                   LET l_feld_cnt=l_feld_cnt+1
                           END FOREACH
                           CALL l_feld.deleteElement(l_i)       #刪除xxx.*那筆資料
                           CALL l_length.deleteElement(l_i)     #刪除xxx.*那筆資料
                           CALL l_feld_id.deleteElement(l_i)    #FUN-AC0011
                           LET l_feld_cnt=l_feld_cnt-1
                           LET l_i=l_k-1
                         END IF
                    END IF 
                END FOR
            ELSE
                LET l_feld[l_i]=l_feld[l_i].subString(l_feld[l_i].getIndexOf('.',1)+1,l_feld[l_i].getLength())
                LET l_length[l_i]=''
                CALL cl_query_prt_getlength(l_feld[l_i],l_sel,'s','0') #No.FUN-990043
                DECLARE p_zta_dbqry_d_ifx CURSOR FOR 
                SELECT xabc02,xabc03,xabc04 FROM xabc ORDER BY xabc01 DESC
                 FOREACH p_zta_dbqry_d_ifx INTO l_feld_id[l_i],l_feld_tmp,l_length[l_i] #No.FUN-720026 #No.FUN-990043
                         LET l_feld[l_i]=l_feld_tmp
                 END FOREACH
            END IF
         ELSE
            LET l_length[l_i]=''
            CALL cl_query_prt_getlength(l_feld[l_i],l_sel,'s','0')  #No.FUN-990043
            DECLARE p_zta_dbqry_d1_ifx CURSOR FOR 
            SELECT xabc02,xabc03,xabc04 FROM xabc ORDER BY xabc01 DESC
            FOREACH p_zta_dbqry_d1_ifx INTO l_feld_id[l_i],l_feld_tmp,l_length[l_i] #No.FUN-720026 #No.FUN-990043
                LET l_feld[l_i]=l_feld_tmp
            END FOREACH
         END IF
      END IF
    END FOR
 
    LET lw_w=ui.window.getcurrent()
    LET ln_w = lw_w.getNode()
    LET ls_items=ln_w.selectByTagName("TableColumn")
    FOR l_i = 1 TO l_feld_cnt
        LET ln_table_column = ls_items.item(l_i)
        LET ls_colname = "field", l_i USING "&&&"
        #IF l_i=1 THEN
        #CALL ln_table_column.setAttribute("width",1 )
        #END IF
        CALL ln_table_column.setAttribute("colName", ls_colname)
        CALL ln_table_column.setAttribute("name", "formonly." || l_feld_id[l_i])  #No.FUN-720026
        CALL ln_table_column.setAttribute("text", l_feld[l_i])
        CALL ln_table_column.setAttribute("hidden", 0)
        LET ln_edit = ln_table_column.getChildByIndex(1)
        CALL ln_edit.setAttribute("width", l_length[l_i])
        #CALL ln_edit.setAttribute("width", l_length[l_i])
        #LET ln_edit = ln_table_column.createChild("Edit")
        #CALL ln_edit.setAttribute("tag", l_feld[l_i])
    END FOR
    FOR l_i = l_feld_cnt+1 TO GI_MAX_COLUMN_COUNT
        LET ln_table_column = ls_items.item(l_i)
        #LET ln_table_column = ln_table.createChild("TableColumn")
        LET ls_colname = "field", l_i USING "&&&"
        CALL ln_table_column.setAttribute("colName", ls_colname)
        CALL ln_table_column.setAttribute("name", "formonly." || ls_colname)
        CALL ln_table_column.setAttribute("text", ls_colname)
        CALL ln_table_column.setAttribute("noEntry", 1)
        #FUN-9C0036 -- start -- 
        IF l_feld_cnt=0 AND l_i <= g_nohidden_cnt THEN
           CALL ln_table_column.setAttribute("hidden", 0)
        ELSE
           CALL ln_table_column.setAttribute("hidden", 1)
        END IF
        #FUN-9C0036 -- end -- 
        #LET ln_edit = ln_table_column.createChild("Edit")
        #LET ln_edit = ln_table_column.getChildByIndex(1)
        #CALL ln_edit.setAttribute("width", GI_COLUMN_WIDTH)
        #CALL ln_edit.setAttribute("tag", "unused")
    END FOR
    
      #PREPARE table_pre FROM l_execmd
      #FUN-A80094-add
     
      LET l_tmp_chk=l_tmp.subString(1,6)                #CHI-D30034
      #IF l_tmp.subString(1,6) != 'select' THEN         #mark CHI-D30034
      IF l_tmp_chk.toLowercase() != 'select' THEN       #CHI-D30034
         CALL cl_err('can not execute this command!','!',0)  
      ELSE                                                                        
      #FUN-A80094-end
        PREPARE table_pre FROM l_tmp                                   #FUN-A80094
     
        IF SQLCA.SQLCODE THEN
            CALL cl_err('can not execute this command!','!',0)         #FUN-9C0036 
        END IF
        DECLARE table_cur CURSOR FOR table_pre
        IF SQLCA.SQLCODE THEN
            CALL cl_err('can not execute this command!','!',0)         #FUN-9C0036 
        END IF
 
        LET l_i = 1
        CALL ga_table_data.clear()
        FOREACH table_cur INTO ga_table_data[l_i].*
            IF SQLCA.SQLCODE THEN
                CALL cl_msg_error("",SQLCA.SQLCODE, SQLCA.SQLERRD[2])  #FUN-9C0036 
            END IF
            LET l_i=l_i+1
        #FUN-990043 -- start --
            IF l_i > g_max_rec THEN
               CALL cl_err("",9035,0)
               EXIT FOREACH
            END IF
        #FUN-990043 -- end --
        END FOREACH
     
        IF SQLCA.SQLCODE THEN
            CALL cl_msg_error("",SQLCA.SQLCODE, SQLCA.SQLERRD[2])     #FUN-9C0036 
        END IF
        CALL ga_table_data.deleteElement(l_i)                         #CHI-910066 add
        LET g_dbqry_rec_b = l_i - 1
 
        DISPLAY ARRAY ga_table_data TO s_table_data.* ATTRIBUTE ( COUNT = g_dbqry_rec_b)
            BEFORE DISPLAY
            CALL cl_set_act_visible("show_result", FALSE)
            EXIT DISPLAY
        END DISPLAY
    END IF  #FUN-A80094                         
END FUNCTION
#FUN-A80094 end

#FUN-C10031 -- start --
#選擇登入營運中心
FUNCTION p_dbqry_plant()
DEFINE l_welcome  LIKE type_file.chr1000
DEFINE l_n        LIKE type_file.num10
 
    OPEN WINDOW p_dbqry_plant AT 5,20
      WITH FORM "azz/42f/p_dbqry_plant" ATTRIBUTE(STYLE=g_win_style)
 
    CALL cl_ui_init()
 
    LET l_welcome = cl_getmsg("azz1233",g_lang)

    MESSAGE " "
    CLEAR FORM                                   # 清螢幕欄位內容
    CALL cl_opmsg('a')

    INPUT g_plant,l_welcome WITHOUT DEFAULTS FROM azw01,formonly.welcome HELP 1
    
    	  AFTER FIELD azw01
            #判斷登入資料庫是否由 azw_file 的設定
            SELECT count(*) INTO l_n from azw_file
             WHERE azwacti = 'Y' AND azw01 = g_plant AND azw06 = g_dbs
            IF l_n = 0 THEN
               CALL cl_err3("sel","azw_file",g_plant CLIPPED,"",100,"","sel azw",0)
               NEXT FIELD azw01
            END IF
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM zxy_file,azw_file
             WHERE zxy01 = g_user AND zxy03 = azw01 AND azw01 = g_plant
            IF l_n = 0 OR cl_null(l_n) THEN
               CALL cl_err(g_user,'sub-118',1)
               NEXT FIELD azw01
            END IF
 
        ON ACTION controlp
           CASE
             WHEN INFIELD(azw01)
                # 產生查詢畫面的參數初始化.
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_zxy02"
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_plant
                LET g_qryparam.arg1 = g_dbs CLIPPED
                CALL cl_create_qry() RETURNING g_plant
                DISPLAY g_plant TO azw01
                NEXT FIELD azw01
           END CASE
 
        ON ACTION locale
           CALL cl_dynamic_locale()
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION controlg
           CALL cl_cmdask()
 
        ON ACTION help
           CALL cl_show_help()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT

    END INPUT
    CLOSE WINDOW p_dbqry_plant
    IF INT_FLAG THEN
       LET INT_FLAG=0
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
       EXIT PROGRAM
    END IF
    CALL cl_ins_del_sid(1,g_plant)
END FUNCTION
#FUN-C10031 -- end --
