# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Library name...: cl_query_dbqry
# Descriptions...: 資料庫查詢
# Input parameter: p_prog   查詢單ID
#                  p_cust   客製碼
#                  p_str    SQL 指令
# Return code....: none
# Usage..........: call cl_query_dbqry(p_prog,p_cust,p_str)
# Date & Author..: 2006/09/15 No.FUN-690069 By Echo 
# Modify.........: 2006/01/29 No.FUN-730005 By Echo
# Modify.........: No.FUN-750084 07/05/23 By Echo 新增客製碼欄位
# Modify.........: No.FUN-770079 07/07/24 By Echo 第二階段功能調整:欄位值轉換功能、查詢畫面 Input 功能...等
# Modify.........: No.TQC-790154 07/09/28 By Echo SQL指令包含中文字時會抓取不到資料...
# Modify.........: No.FUN-7C0020 07/12/06 By Echo 功能調整<part2>
# Modify.........: No.FUN-7C0067 07/12/20 By Echo 調整 LIB function 說明
# Modify.........: No.FUN-810021 08/01/09 By Echo 調整權限部份應與 p_zy 勾稽
# Modify.........: No.FUN-810062 08/01/23 By Echo 調整 p_query 作業可以在 Windows 版執行
# Modify.........: No.FUN-820043 08/02/13 By Echo p_query 功能調整
# Modify.........: No.TQC-860016 08/06/06 By saki 修改ON IDLE段
# Modify.........: No.FUN-8B0089 08/11/20 By Vicky 調整匯出Excel功能指向正確window
# Modify.........: No.FUN-860089 08/12/12 By Echo 新增 CR Viewer 預覽查詢功能
# Modify.........: No.TQC-950089 09/06/01 By Echo select 欄位為大寫時無法正確顯示
# Modify.........: No.FUN-A60085 10/06/25 By Jay 呼叫cl_query_prt_getlength()只做一次CREATE TEMP TABLE
# Modify.........: No.FUN-AC0010 11/02/10 By Jay 修改匯出excel筆數限制問題
# Modify.........: No.MOD-B20057 11/02/15 By Jay 修改變數名稱為欄位名稱
# Modify.........: No.FUN-AC0011 11/03/08 By Jay 調整截取sql語法中table name、別名、欄位名稱方式
 
DATABASE ds
 
#FUN-690069,FUN-730005,FUN-7C0067
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_str            STRING,
     l_ac            LIKE type_file.num10,   #No.FUN-680135 SMALLINT #目前處理的ARRAY CNT 
     g_db_type       LIKE type_file.chr3,    #No.FUN-680135 VARCHAR(3)
     g_i             LIKE type_file.num10,   #count/index for any purpose #No.FUN-680135 SMALLINT
     g_curs_index    LIKE type_file.num10,   #No.FUN-680135 INTEGER
     g_row_count     LIKE type_file.num10,   #No.FUN-680135 INTEGER
     g_dba_priv      LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1)
     g_zz011         LIKE zz_file.zz011,     #No.FUN-810021
     g_zai07         LIKE zai_file.zai07,    #No.FUN-810021
     g_auth_wc       STRING                  #權限條件      #FUN-810021
 
CONSTANT GI_MAX_COLUMN_COUNT INTEGER = 100,  #FUN-770079
         GI_COLUMN_WIDTH     INTEGER = 10
 
#No.FUN-860089 -- start -- 
GLOBALS                                       
DEFINE   g_query_prog    LIKE gcy_file.gcy01    #查詢單ID  
DEFINE   g_query_cust    LIKE gcy_file.gcy05    #客製否    
DEFINE   g_dbqry_rec_b   LIKE type_file.num10 #dbqry單身筆數 #No.FUN-680135 SMALLINT
DEFINE   ga_table_data DYNAMIC ARRAY OF RECORD
     field001, field002, field003, field004, field005, field006, field007,
     field008, field009, field010, field011, field012, field013, field014,
     field015, field016, field017, field018, field019, field020, field021,
     field022, field023, field024, field025, field026, field027, field028,
     field029, field030, field031, field032, field033, field034, field035,
     field036, field037, field038, field039, field040, field041, field042,
     field043, field044, field045, field046, field047, field048, field049,
     field050, field051, field052, field053, field054, field055, field056,
     field057, field058, field059, field060, field061, field062, field063,
     field064, field065, field066, field067, field068, field069, field070,
     field071, field072, field073, field074, field075, field076, field077,
     field078, field079, field080, field081, field082, field083, field084,
     field085, field086, field087, field088, field089, field090, field091,
     field092, field093, field094, field095, field096, field097, field098,
     field099, field100 STRING
    ##FUN-770079
    #field101, field102, field103, field104, field105, field106, field107,
    #field108, field109, field110, field111, field112, field113, field114,
    #field115, field116, field117, field118, field119, field120, field121,
    #field122, field123, field124, field125, field126, field127, field128,
    #field129, field130, field131, field132, field133, field134, field135,
    #field136, field137, field138, field139, field140, field141, field142,
    #field143, field144, field145, field146, field147, field148, field149,
    #field150, field151, field152, field153, field154, field155, field156,
    #field157, field158, field159, field160, field161, field162, field163,
    #field164, field165, field166, field167, field168, field169, field170,
    #field171, field172, field173, field174, field175, field176, field177,
    #field178, field179, field180, field181, field182, field183, field184,
    #field185, field186, field187, field188, field189, field190, field191,
    #field192, field193, field194, field195, field196, field197, field198,
    #field199, field200  STRING
    ##END FUN-770079
                  END RECORD
    DEFINE g_qry_feld_type DYNAMIC ARRAY OF LIKE type_file.chr30 #欄位型態
    DEFINE g_feld_id       DYNAMIC ARRAY OF LIKE type_file.chr1000           
 
END GLOBALS                                               
#No.FUN-860089 -- start -- 
 
FUNCTION cl_query_dbqry(p_prog,p_cust,p_str)                #FUN-750084
DEFINE p_prog      LIKE zai_file.zai01
DEFINE p_cust      LIKE zai_file.zai05                      #FUN-750084
DEFINE p_str       STRING
DEFINE l_status    LIKE type_file.num5                      #FUN-810021
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF cl_null(p_str) THEN
         RETURN
    END IF
    
    LET g_query_prog = p_prog
    LET g_query_cust = p_cust
 
    LET g_str = p_str
    LET g_db_type=cl_db_get_database_type()             # No.TQC-810073
 
    #  將ora和ifx的判斷分開,因ifx是一個db判斷一次dba
    IF g_db_type="ORA" THEN
       RUN "groups|grep dba" RETURNING g_dba_priv
       IF g_dba_priv = '0' THEN
          LET g_dba_priv='1'
       END IF
    END IF
 
    IF g_db_type="IFX" THEN
       SELECT COUNT(*) INTO g_dba_priv FROM sysusers
        WHERE usertype='D' and (username=g_user or username='public')
       IF g_dba_priv != '0' THEN
          LET g_dba_priv='1'
       END IF
    END IF
 
    #FUN-810021
    SELECT zai07 INTO g_zai07 FROM zai_file 
     WHERE zai01=g_query_prog  AND zai05=g_query_cust      
    IF cl_null(g_zai07) THEN
       LET g_zai07 = g_query_prog CLIPPED
    END IF 
 
    SELECT zz011 INTO g_zz011 FROM zz_file WHERE zz01=g_zai07                            
    IF SQLCA.SQLCODE THEN
       LET g_zz011 = ""
    END IF   
    #END No.FUN-810021
 
    #資料權限設定
    CALL cl_query_auth(g_query_prog,g_query_cust,g_zz011,g_zai07)
        RETURNING l_status, g_auth_wc
    IF NOT l_status THEN
       RETURN
    END IF
    #END FUN-810021
 
    CALL cl_query_dbqry_menu()
 
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 顯示資料庫查詢資料
# Date & Author..:
# Input Parameter: p_ud
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_dbqry_bp(p_ud)
DEFINE   p_ud       LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "field_body" OR g_action_choice = "index_body" THEN
      IF g_dba_priv != '1' THEN
         LET g_action_choice=''
      END IF
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY ga_table_data TO s_table_data.* ATTRIBUTE (COUNT = g_dbqry_rec_b,UNBUFFERED)
 
#       BEFORE DISPLAY
#         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
       BEFORE ROW
          LET l_ac = ARR_CURR()
 
       ON ACTION input_style
          LET g_action_choice="input_style"
          EXIT DISPLAY
      #ON ACTION locale
      #   CALL cl_dynamic_locale()
      #   EXIT DISPLAY
       ON ACTION exit                             # Esc.結束
          LET g_action_choice="exit"
          EXIT DISPLAY
       ON ACTION exporttoexcel
          LET g_action_choice = 'exporttoexcel'
          EXIT DISPLAY
       ON ACTION controlg
          LET g_action_choice="controlg"
          EXIT DISPLAY
       ON ACTION cancel
           LET INT_FLAG=FALSE 		#MOD-570244	mars
          LET g_action_choice="exit"
          EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      #No.TQC-860016 --start--
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
      #No.TQC-860016 ---end---
    END DISPLAY
    #CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 資料庫查詢 MENU
# Date & Author..:
# Input Parameter: 
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_dbqry_menu()
DEFINE l_sel LIKE type_file.chr1        #No.FUN-680135 VARCHAR(1)
DEFINE w ui.Window              #FUN-8B0089
DEFINE n om.DomNode             #FUN-8B0089
 
    LET l_sel='A'
    CALL cl_query_dbqry_buildForm()
 
    CALL cl_query_dbqry_sel(g_str,l_sel,'0')
    IF g_dbqry_rec_b < 1 THEN
       CLOSE WINDOW query_w
       CALL cl_err('!','lib-216',1)
       RETURN
    END IF
 
    WHILE TRUE
      CALL cl_query_dbqry_bp("G")
 
      CASE g_action_choice
        WHEN "input_style"
             CALL cl_query_dbqry_i(l_sel) RETURNING l_sel
        WHEN "exporttoexcel"
             #FUN-8B0089--start--
             LET w = ui.Window.getCurrent()
             LET n = w.getNode()
             CALL cl_export_to_excel(n,base.TypeInfo.create(ga_table_data),'','')
             #FUN-8B0089--end--
        WHEN "exit"
             EXIT WHILE
        WHEN "controlg"
             CALL cl_cmdask()
      END CASE
    END WHILE
    CLOSE WINDOW query_w
 
END FUNCTION
 
 
##################################################
# Private Func...: TRUE
# Descriptions...: 選擇欄位名稱顯示格式
# Date & Author..:
# Input Parameter: l_sel
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_dbqry_i(l_sel)
    DEFINE l_text      STRING
    DEFINE l_str       STRING
    DEFINE l_sql       STRING
    DEFINE l_tmp       STRING
    DEFINE l_execmd    STRING
    DEFINE l_tok       base.StringTokenizer
    DEFINE l_start     LIKE type_file.num10          #No.FUN-680135 SMALLINT
    DEFINE l_end       LIKE type_file.num10          #No.FUN-680135 SMALLINT
    DEFINE l_feld_tmp  LIKE type_file.chr1000       #No.FUN-680135 VARCHAR(55)
    DEFINE l_feld      DYNAMIC ARRAY OF STRING
    DEFINE l_length    DYNAMIC ARRAY OF LIKE type_file.num5        #No.FUN-680135 SMALLINT
    DEFINE l_feld_t    DYNAMIC ARRAY OF STRING
    DEFINE l_tab       DYNAMIC ARRAY OF STRING
    DEFINE l_tab_alias DYNAMIC ARRAY OF STRING
    DEFINE l_i         LIKE type_file.num10          #No.FUN-680135 SMALLINT
    DEFINE l_j         LIKE type_file.num10          #No.FUN-680135 SMALLINT
    DEFINE l_k         LIKE type_file.num10          #No.FUN-680135 SMALLINT
    DEFINE ln_table_column, ln_edit,ln_w om.DomNode
    DEFINE ls_items    om.NodeList
    DEFINE ls_colname  STRING
    DEFINE lw_w        ui.window
    DEFINE l_feld_cnt  LIKE type_file.num5          #No.FUN-680135 SMALLINT
    DEFINE l_tab_cnt   LIKE type_file.num5          #No.FUN-680135 SMALLINT
    DEFINE l_colname   LIKE zal_file.zal04,         #No.FUN-680135 VARCHAR(20)
           l_colnamec  LIKE gaq_file.gaq03,         #No.FUN-680135 VARCHAR(50)
           l_collen    LIKE type_file.num5,         #No.FUN-680135 SMALLINT
           l_coltype   LIKE type_file.chr3,         #No.FUN-680135 VARCHAR(3)
           l_sel       LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
 
    CALL cl_set_act_visible("accept,cancel", TRUE)
    INPUT l_sel WITHOUT DEFAULTS FROM selmethod HELP 1
        BEFORE INPUT
            LET l_text = null
        #No.TQC-860016 --start--
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION controlg
           CALL cl_cmdask()
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION help
           CALL cl_show_help()
        #No.TQC-860016 ---end---
    END INPUT
    CALL cl_query_dbqry_sel(g_str,l_sel,'0')
 
    RETURN l_sel
 
END FUNCTION 
 
##################################################
# Private Func...: TRUE
# Descriptions...: 產生資料庫查詢資料
# Date & Author..:
# Input Parameter: p_str    - SQL 語法
#                  p_sel    -   I : show field ID, N:show Field Name,
#                             其他:show Field ID+Name
#                  p_type   - 0: 以 p_tabname 設定的欄位名稱
#                             1: 以 p_query 設定的欄位名稱
#                             2: 以 p_crview_set 設定的欄位名稱
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_dbqry_sel(p_str,p_sel,p_type)
    DEFINE p_str       STRING                       #No.FUN-860089
    DEFINE p_sel       LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
    DEFINE p_type      LIKE type_file.chr1          #No.FUN-860089
    DEFINE l_text      STRING
    DEFINE l_str       STRING
    DEFINE l_sql       STRING
    DEFINE l_tmp       STRING
    DEFINE l_execmd    STRING
    DEFINE l_tok       base.StringTokenizer
    DEFINE l_start     LIKE type_file.num10          #No.FUN-680135 SMALLINT
    DEFINE l_end       LIKE type_file.num10          #No.FUN-680135 SMALLINT
    DEFINE l_feld_tmp  LIKE type_file.chr1000        #No.FUN-680135 VARCHAR(55)
    DEFINE l_feld      DYNAMIC ARRAY OF STRING
    DEFINE l_length    DYNAMIC ARRAY OF LIKE type_file.num5        #No.FUN-680135 SMALLINT
    DEFINE l_feld_t    DYNAMIC ARRAY OF STRING
    DEFINE l_tab       DYNAMIC ARRAY OF STRING
    DEFINE l_tab_alias DYNAMIC ARRAY OF STRING
    DEFINE l_i         LIKE type_file.num10          #No.FUN-680135 SMALLINT
    DEFINE l_j         LIKE type_file.num10          #No.FUN-680135 SMALLINT
    DEFINE l_k         LIKE type_file.num10          #No.FUN-680135 SMALLINT
    DEFINE ln_table_column, ln_edit,ln_w om.DomNode
    DEFINE ls_items    om.NodeList
    DEFINE ls_colname  STRING
    DEFINE lw_w        ui.window
    DEFINE l_feld_cnt  LIKE type_file.num5          #No.FUN-680135 SMALLINT
    DEFINE l_tab_cnt   LIKE type_file.num5          #No.FUN-680135 SMALLINT
    DEFINE l_colname   LIKE zal_file.zal04,         #No.FUN-680135 VARCHAR(20)
           l_colnamec  LIKE gaq_file.gaq03,         #No.FUN-680135 VARCHAR(50)
           l_collen    LIKE type_file.num5,         #No.FUN-680135 SMALLINT
           l_coltype   LIKE type_file.chr3          #No.FUN-680135 VARCHAR(3)
    DEFINE l_zap06     LIKE zap_file.zap06
    DEFINE l_str_bak   STRING
    DEFINE l_tab_name  STRING                       #No.FUN-820043
    DEFINE l_table_tok base.StringTokenizer         #FUN-AC0011
    DEFINE l_table_data RECORD
          field001, field002, field003, field004, field005, field006, field007,
          field008, field009, field010, field011, field012, field013, field014,
          field015, field016, field017, field018, field019, field020, field021,
          field022, field023, field024, field025, field026, field027, field028,
          field029, field030, field031, field032, field033, field034, field035,
          field036, field037, field038, field039, field040, field041, field042,
          field043, field044, field045, field046, field047, field048, field049,
          field050, field051, field052, field053, field054, field055, field056,
          field057, field058, field059, field060, field061, field062, field063,
          field064, field065, field066, field067, field068, field069, field070,
          field071, field072, field073, field074, field075, field076, field077,
          field078, field079, field080, field081, field082, field083, field084,
          field085, field086, field087, field088, field089, field090, field091,
          field092, field093, field094, field095, field096, field097, field098,
          field099, field100  LIKE gaq_file.gaq03
         ##FUN-770079
         #field101, field102, field103, field104, field105, field106, field107,
         #field108, field109, field110, field111, field112, field113, field114,
         #field115, field116, field117, field118, field119, field120, field121,
         #field122, field123, field124, field125, field126, field127, field128,
         #field129, field130, field131, field132, field133, field134, field135,
         #field136, field137, field138, field139, field140, field141, field142,
         #field143, field144, field145, field146, field147, field148, field149,
         #field150, field151, field152, field153, field154, field155, field156,
         #field157, field158, field159, field160, field161, field162, field163,
         #field164, field165, field166, field167, field168, field169, field170,
         #field171, field172, field173, field174, field175, field176, field177,
         #field178, field179, field180, field181, field182, field183, field184,
         #field185, field186, field187, field188, field189, field190, field191,
         #field192, field193, field194, field195, field196, field197, field198,
         #field199, field200  LIKE gaq_file.gaq03
         ##END FUN-770079
           END RECORD
 
       #No.FUN-860089 -- start --
       IF g_prog = 'p_query' THEN
          SELECT zap06 INTO l_zap06 FROM zap_file             #MOD-B20057
           where zap01=g_query_prog AND zap07=g_query_cust    #FUN-750084
          IF l_zap06 IS NULL OR l_zap06 = 0 THEN
             LET l_zap06 = 6600
          END IF
       ELSE
          LET l_zap06 = g_max_rec
          LET g_auth_wc = " 1=1"
       END IF
 
       #LET l_str=cl_query_cut_spaces(g_str)
       LET l_str= p_str.trim()                     #TQC-790154 # FUN-810062
       #No.FUN-860089 -- end --
 
       LET l_end = l_str.getIndexOf(';',1)
       IF l_end != 0 THEN
          LET l_str=l_str.subString(1,l_end-1)
       END IF
       LET l_tok = base.StringTokenizer.createExt(l_str CLIPPED,"\n","",TRUE)
       WHILE l_tok.hasMoreTokens()
             LET l_tmp=l_tok.nextToken()
             IF l_text is null THEN
                LET l_text = l_tmp.trim()
             ELSE
                LET l_text = l_text CLIPPED,' ',l_tmp.trim()
             END IF
       END WHILE
       LET l_tmp=l_text
       LET l_execmd=l_tmp
       LET l_str=l_tmp
       LET l_str_bak = l_str.toLowerCase()
       LET l_start = l_str_bak.getIndexOf('select',1)
       IF l_start=0 THEN
          CALL cl_err('can not execute this command!','!',0)
          RETURN
       END IF
       LET l_end   = l_str_bak.getIndexOf('from',1)
       LET l_str=l_str.subString(l_start+7,l_end-2)
       LET l_str=l_str.trim()
       LET l_tok = base.StringTokenizer.createExt(l_str CLIPPED,",","",TRUE)
       LET l_i=1
       WHILE l_tok.hasMoreTokens()
             LET l_feld[l_i]=l_tok.nextToken()
             LET l_feld[l_i]=l_feld[l_i].trim()
             LET l_feld[l_i]=l_feld[l_i].toLowerCase()  #No.TQC-950089
             LET l_i=l_i+1
       END WHILE
       LET l_feld_cnt=l_i-1
 
 
       LET l_str=l_tmp
       LET l_str_bak = l_str.toLowerCase()
       LET l_start = l_str_bak.getIndexOf('from',1)
       LET l_end   = l_str_bak.getIndexOf('where',1)
       IF l_end=0 THEN
          LET l_end   = l_str_bak.getIndexOf('group',1)
          IF l_end=0 THEN
             LET l_end   = l_str_bak.getIndexOf('order',1)
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
       LET l_str_bak = l_str.toLowerCase()                                          #FUN-AC0011
       #LET l_tok = base.StringTokenizer.createExt(l_str CLIPPED,",","",TRUE)       #FUN-AC0011 mark
       LET l_tok = base.StringTokenizer.createExt(l_str_bak CLIPPED,",","",TRUE)    #FUN-AC0011
       LET l_j=1
       WHILE l_tok.hasMoreTokens()
             #---FUN-AC0011---start-----
             #因為sql語法中FROM後面的table有可能會以 JOIN 的形式出現
             #例1:SELECT XXX FROM nni_file nni LEFT OUTER JOIN nma_file ON nma01 = nni06, nnj_file LEFT OUTER JOIN nne_file ON nnj03 = nne01
             #例2:SELECT XXX FROM nni_file nni RIGHT OUTER JOIN nma_file ON nma01 = nni06, nnj_file LEFT OUTER JOIN nne_file ON nnj03 = nne01
             #例3:SELECT XXX FROM nni_file nni OUTER JOIN nma_file ON nma01 = nni06, nnj_file LEFT OUTER JOIN nne_file ON nnj03 = nne01
             LET l_str_bak = l_tok.nextToken()

             #依照關鍵字去除,取代成逗號,以利分割table
             LET l_text = "left outer join"
             CALL cl_replace_str(l_str_bak, l_text.toLowerCase(), ",") RETURNING l_str_bak
             LET l_text = "right outer join"
             CALL cl_replace_str(l_str_bak, l_text.toLowerCase(), ",") RETURNING l_str_bak
             LET l_text = "outer join"
             CALL cl_replace_str(l_str_bak, l_text.toLowerCase(), ",") RETURNING l_str_bak
             WHILE l_str_bak.getIndexOf("on", 1) > 0
                   #準備將on後面的條件式去除,如:XXXXXX JOIN nma_file nma [ON nma01 = nni06], 
                   LET l_start = l_str_bak.getIndexOf("on", 1) 

                   #從剛才找出on關鍵字地方關始找下一個逗號,應該就是此次所要截取的table名稱和別名
                   #如果後面已找不到逗號位置,代表應該已到字串的最尾端
                   LET l_end = l_str_bak.getIndexOf(",", l_start)  
                   IF l_end = 0 THEN
                      LET l_end = l_str_bak.getLength() + 1   #因為下面會減1,所以這裡先加1
                   END IF
                   LET l_text = l_str_bak.subString(l_start, l_end - 1)
                   CALL cl_replace_str(l_str_bak, l_text, " ") RETURNING l_str_bak
             END WHILE

             #依逗號區隔出各table名稱和別名
             LET l_table_tok = base.StringTokenizer.createExt(l_str_bak CLIPPED,",","",TRUE)
             
             #回復原本sql字串,並轉成小寫,以利找table名稱位置,再抓取真正sql字串
             LET l_str_bak = l_str.toLowerCase()             
             WHILE l_table_tok.hasMoreTokens()
                   LET l_text = l_table_tok.nextToken()
                   LET l_text = l_text.trim()
                   LET l_start = l_str_bak.getIndexOf(l_text, 1) 
                   LET l_text = l_str.substring(l_start, l_start + l_text.getLength() - 1)
                   #LET l_tab[l_j]=l_tok.nextToken()          #mark 改成下面取l_text方式
                   LET l_tab[l_j] = l_text
             #---FUN-AC0011---end-------
                   LET l_tab[l_j]=l_tab[l_j].trim()
                   IF l_tab[l_j].getIndexOf(' ',1) THEN
                      DISPLAY 'qazzaq:',l_tab[l_j].getIndexOf(' ',1)
                      LET l_tab_alias[l_j]=l_tab[l_j].subString(l_tab[l_j].getIndexOf(' ',1)+1,l_tab[l_j].getLength())
                      LET l_tab[l_j]=l_tab[l_j].subString(1,l_tab[l_j].getIndexOf(' ',1)-1)
                   END IF
                   LET l_j=l_j+1
             END WHILE   #FUN-AC0011
       END WHILE
       LET l_tab_cnt=l_j-1
 
       CALL g_qry_feld_type.clear()               #No.FUN-860089

       CALL cl_query_prt_temptable()     #No.FUN-A60085
         
       FOR l_i=1 TO l_feld_cnt
           IF l_feld[l_i]='*' THEN
              LET l_str=l_tmp
              LET l_str_bak = l_str.toLowerCase()
              LET l_start = l_str_bak.getIndexOf('from',1)
              LET l_end   = l_str_bak.getIndexOf('where',1)
              IF l_end=0 THEN
                 LET l_end   = l_str_bak.getIndexOf('group',1)
                 IF l_end=0 THEN
                    LET l_end   = l_str_bak.getIndexOf('order',1)
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
                 #CALL cl_query_dbqry_getlength(l_tab[l_j],l_sel,'m')
                  CALL cl_query_prt_getlength(l_tab[l_j],p_sel,'m',p_type)   #No.FUN-810062 #No.FUN-860089
                  DECLARE cl_query_dbqry_insert_d_ifx CURSOR FOR
                          SELECT xabc02,xabc03,xabc04,xabc06 FROM xabc ORDER BY xabc01  #No.FUN-810062
                  FOREACH cl_query_dbqry_insert_d_ifx INTO g_feld_id[l_i],l_feld_tmp,l_length[l_i],g_qry_feld_type[l_i] #No.FUN-860089
                     LET l_feld[l_i]=l_feld_tmp CLIPPED
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
                              LET l_k=l_i   #備份l_i的值
                              CALL l_feld.deleteElement(l_i) #刪除xxx.*那筆資料
                              CALL l_length.deleteElement(l_i) #刪除xxx.*那筆資料
                              CALL l_feld.insertElement(l_i)
                              CALL l_length.insertElement(l_i)
                             #CALL cl_query_dbqry_getlength(l_tab[l_j],l_sel,'m')
                              CALL cl_query_prt_getlength(l_tab[l_j],p_sel,'m',p_type) #No.FUN-810062 #No.FUN-860089
                              DECLARE cl_query_dbqry_insert_d1_ifx CURSOR FOR 
                                      SELECT xabc02,xabc03,xabc04,xabc06 FROM xabc ORDER BY xabc01 DESC   #No.FUN-810062
                              FOREACH cl_query_dbqry_insert_d1_ifx INTO g_feld_id[l_i],l_feld_tmp,l_length[l_i],g_qry_feld_type[l_i]   #No.FUN-860089
                                 LET l_feld[l_i]=l_tab[l_j] CLIPPED,".",l_feld_tmp CLIPPED   #No.FUN-820043
                                 CALL l_feld.insertElement(l_i)
                                 CALL l_length.insertElement(l_i)
                                 CALL g_feld_id.insertelement(l_i)   #FUN-AC0011
                                 LET l_k=l_k+1
                                 LET l_feld_cnt=l_feld_cnt+1
                              END FOREACH
                              CALL l_feld.deleteElement(l_i) #刪除xxx.*那筆資料
                              CALL l_length.deleteElement(l_i) #刪除xxx.*那筆資料
                              CALL g_feld_id.deleteElement(l_i)   #FUN-AC0011
                              LET l_feld_cnt=l_feld_cnt-1
                              LET l_i=l_k-1
                           END IF
                        ELSE
                           IF l_tab_alias[l_j]=l_feld[l_i].subString(1,l_feld[l_i].getIndexOf('.',1)-1) THEN
                              LET l_k=l_i   #備份l_i的值
                              CALL l_feld.deleteElement(l_i) #刪除xxx.*那筆資料
                              CALL l_length.deleteElement(l_i) #刪除xxx.*那筆資料
                              CALL l_feld.insertElement(l_i)
                              CALL l_length.insertElement(l_i)
                             #CALL cl_query_dbqry_getlength(l_tab[l_j],l_sel,'m')
                              CALL cl_query_prt_getlength(l_tab[l_j],p_sel,'m',p_type) #No.FUN-810062  #No.FUN-860089
                              DECLARE cl_query_dbqry_insert_d2_ifx CURSOR FOR 
                                      SELECT xabc02,xabc03,xabc04,xabc06 FROM xabc ORDER BY xabc01 DESC  #No.FUN-810062
                              FOREACH cl_query_dbqry_insert_d2_ifx INTO g_feld_id[l_i],l_feld_tmp,l_length[l_i],g_qry_feld_type[l_i]  #No.FUN-860089
                                 LET l_feld[l_i]=l_tab_alias[l_j] CLIPPED,".",l_feld_tmp CLIPPED   #No.FUN-820043
                                 CALL l_feld.insertElement(l_i)
                                 CALL l_length.insertElement(l_i)
                                 CALL g_feld_id.insertelement(l_i)   #FUN-AC0011
                                 LET l_k=l_k+1
                                 LET l_feld_cnt=l_feld_cnt+1
                              END FOREACH
                              CALL l_feld.deleteElement(l_i) #刪除xxx.*那筆資料
                              CALL l_length.deleteElement(l_i) #刪除xxx.*那筆資料
                              CALL g_feld_id.deleteElement(l_i)   #FUN-AC0011
                              LET l_feld_cnt=l_feld_cnt-1
                              LET l_i=l_k-1
                           END IF
                        END IF 
                    END FOR
                 ELSE
                    LET l_tab_name=l_feld[l_i].subString(1,l_feld[l_i].getIndexOf('.',1)-1)
                    LET l_feld[l_i]=l_feld[l_i].subString(l_feld[l_i].getIndexOf('.',1)+1,l_feld[l_i].getLength())
                    LET l_length[l_i]=''
                   #CALL cl_query_dbqry_getlength(l_feld[l_i],l_sel,'s')
                    CALL cl_query_prt_getlength(l_feld[l_i],p_sel,'s',p_type) #No.FUN-810062 #No.FUN-860089
                    DECLARE cl_query_dbqry_d_ifx CURSOR FOR 
                            SELECT xabc02,xabc03,xabc04,xabc06 FROM xabc ORDER BY xabc01 DESC   #No.FUN-810062
                    FOREACH cl_query_dbqry_d_ifx INTO g_feld_id[l_i],l_feld_tmp,l_length[l_i],g_qry_feld_type[l_i]   #No.FUN-860089
                       LET l_feld[l_i]=l_tab_name CLIPPED,".",l_feld_tmp CLIPPED
                    END FOREACH
                 END IF
              ELSE
                 LET l_length[l_i]=''
                   #CALL cl_query_dbqry_getlength(l_feld[l_i],l_sel,'s')
                    CALL cl_query_prt_getlength(l_feld[l_i],p_sel,'s',p_type) #No.FUN-810062  #No.FUN-860089  
                    DECLARE cl_query_dbqry_d1_ifx CURSOR FOR 
                            SELECT xabc02,xabc03,xabc04,xabc06 FROM xabc ORDER BY xabc01 DESC   #No.FUN-810062
                    FOREACH cl_query_dbqry_d1_ifx INTO g_feld_id[l_i],l_feld_tmp,l_length[l_i],g_qry_feld_type[l_i]   #No.FUN-860089
                       LET l_feld[l_i]=l_feld_tmp CLIPPED
                    END FOREACH
              END IF
           END IF
       END FOR
 
       #FUN-770079
       IF l_feld_cnt > 100 THEN
          CALL cl_err( l_feld_cnt, 'azz-271', 1 )
          RETURN
       END IF
       #END FUN-770079
 
       #No.FUN-860089 -- start --
       IF g_prog = "p_query" THEN
          LET lw_w=ui.window.getcurrent()
          LET ln_w = lw_w.getNode()
          LET ls_items=ln_w.selectByTagName("TableColumn")
          FOR l_i = 1 TO l_feld_cnt
              LET ln_table_column = ls_items.item(l_i)
              LET ls_colname = "field", l_i USING "&&&"
              CALL ln_table_column.setAttribute("colName", ls_colname)
             #CALL ln_table_column.setAttribute("name", "formonly." || ls_colname)
              CALL ln_table_column.setAttribute("name", "formonly." || g_feld_id[l_i] CLIPPED)
              CALL ln_table_column.setAttribute("text", l_feld[l_i])
              CALL ln_table_column.setAttribute("hidden", 0)
              LET ln_edit = ln_table_column.getChildByIndex(1)
              IF FGL_WIDTH(l_feld[l_i]) > l_length[l_i] THEN
                  CALL ln_edit.setAttribute("width", FGL_WIDTH(l_feld[l_i]))
              ELSE
                  CALL ln_edit.setAttribute("width", l_length[l_i])
              END IF
--              CALL ln_edit.setAttribute("width", l_length[l_i])
-- #              LET ln_edit = ln_table_column.createChild("Edit")
-- #             CALL ln_edit.setAttribute("tag", l_feld[l_i])
          END FOR
          FOR l_i = l_feld_cnt+1 TO GI_MAX_COLUMN_COUNT
              LET ln_table_column = ls_items.item(l_i)
              LET ls_colname = "field", l_i USING "&&&"
              CALL ln_table_column.setAttribute("colName", ls_colname)
              CALL ln_table_column.setAttribute("name", "formonly." || ls_colname)
              CALL ln_table_column.setAttribute("text", ls_colname)
              CALL ln_table_column.setAttribute("noEntry", 1)
              CALL ln_table_column.setAttribute("hidden", 1)
-- #              LET ln_edit = ln_table_column.createChild("Edit")
--              LET ln_edit = ln_table_column.getChildByIndex(1)
--              CALL ln_edit.setAttribute("width", GI_COLUMN_WIDTH)
-- #             CALL ln_edit.setAttribute("tag", "unused")
          END FOR
       ELSE
          
       END IF
       #No.FUN-860089 -- END  --
 
       IF g_action_choice = "input_style" THEN
          RETURN
       END IF 
       
       #FUN-810021
       IF g_auth_wc CLIPPED <> ' 1=1' THEN
          LET l_str_bak = l_execmd.toLowerCase()
          LET l_end   = l_str_bak.getIndexOf('where',1)
          IF l_end=0 THEN
             LET l_end   = l_str_bak.getIndexOf('group',1)
             IF l_end=0 THEN
                LET l_end   = l_str_bak.getIndexOf('order',1)
                IF l_end=0 THEN
                   LET l_execmd = l_execmd," WHERE ",g_auth_wc
                ELSE
                   LET l_execmd = l_execmd.subString(1,l_end-1),
                               " WHERE ",g_auth_wc," ",
                               l_execmd.subString(l_end,l_execmd.getLength())
                END IF
             ELSE
                LET l_execmd = l_execmd.subString(1,l_end-1),
                               " WHERE ",g_auth_wc," ",
                               l_execmd.subString(l_end,l_execmd.getLength())
             END IF
          ELSE
             LET l_execmd = l_execmd.subString(1,l_end+5),
                            g_auth_wc," AND ",
                            l_execmd.subString(l_end+6,l_execmd.getLength())
          END IF
       END IF 
       #END FUN-810021
 
       PREPARE table_pre FROM l_execmd
       IF SQLCA.SQLCODE THEN
          CALL cl_err('',sqlca.sqlcode,1)
          RETURN               
       END IF
       DECLARE table_cur CURSOR FOR table_pre
       IF SQLCA.SQLCODE THEN
          CALL cl_err('',sqlca.sqlcode,1)
          RETURN               
       END IF
 
       LET l_i = 1
       CALL ga_table_data.clear()
       INITIALIZE l_table_data.*   TO NULL
 
       FOREACH table_cur INTO l_table_data.*
           IF SQLCA.SQLCODE THEN
              CALL cl_err('',sqlca.sqlcode,1)
              RETURN               
           END IF
           LET ga_table_data[l_i].field001 = l_table_data.field001
           LET ga_table_data[l_i].field002 = l_table_data.field002
           LET ga_table_data[l_i].field003 = l_table_data.field003
           LET ga_table_data[l_i].field004 = l_table_data.field004
           LET ga_table_data[l_i].field005 = l_table_data.field005
           LET ga_table_data[l_i].field006 = l_table_data.field006
           LET ga_table_data[l_i].field007 = l_table_data.field007
           LET ga_table_data[l_i].field008 = l_table_data.field008
           LET ga_table_data[l_i].field009 = l_table_data.field009
           LET ga_table_data[l_i].field010 = l_table_data.field010
           LET ga_table_data[l_i].field011 = l_table_data.field011
           LET ga_table_data[l_i].field012 = l_table_data.field012
           LET ga_table_data[l_i].field013 = l_table_data.field013
           LET ga_table_data[l_i].field014 = l_table_data.field014
           LET ga_table_data[l_i].field015 = l_table_data.field015
           LET ga_table_data[l_i].field016 = l_table_data.field016
           LET ga_table_data[l_i].field017 = l_table_data.field017
           LET ga_table_data[l_i].field018 = l_table_data.field018
           LET ga_table_data[l_i].field019 = l_table_data.field019
           LET ga_table_data[l_i].field020 = l_table_data.field020
           LET ga_table_data[l_i].field021 = l_table_data.field021
           LET ga_table_data[l_i].field022 = l_table_data.field022
           LET ga_table_data[l_i].field023 = l_table_data.field023
           LET ga_table_data[l_i].field024 = l_table_data.field024
           LET ga_table_data[l_i].field025 = l_table_data.field025
           LET ga_table_data[l_i].field026 = l_table_data.field026
           LET ga_table_data[l_i].field027 = l_table_data.field027
           LET ga_table_data[l_i].field028 = l_table_data.field028
           LET ga_table_data[l_i].field029 = l_table_data.field029
           LET ga_table_data[l_i].field030 = l_table_data.field030
           LET ga_table_data[l_i].field031 = l_table_data.field031
           LET ga_table_data[l_i].field032 = l_table_data.field032
           LET ga_table_data[l_i].field033 = l_table_data.field033
           LET ga_table_data[l_i].field034 = l_table_data.field034
           LET ga_table_data[l_i].field035 = l_table_data.field035
           LET ga_table_data[l_i].field036 = l_table_data.field036
           LET ga_table_data[l_i].field037 = l_table_data.field037
           LET ga_table_data[l_i].field038 = l_table_data.field038
           LET ga_table_data[l_i].field039 = l_table_data.field039
           LET ga_table_data[l_i].field040 = l_table_data.field040
           LET ga_table_data[l_i].field041 = l_table_data.field041
           LET ga_table_data[l_i].field042 = l_table_data.field042
           LET ga_table_data[l_i].field043 = l_table_data.field043
           LET ga_table_data[l_i].field044 = l_table_data.field044
           LET ga_table_data[l_i].field045 = l_table_data.field045
           LET ga_table_data[l_i].field046 = l_table_data.field046
           LET ga_table_data[l_i].field047 = l_table_data.field047
           LET ga_table_data[l_i].field048 = l_table_data.field048
           LET ga_table_data[l_i].field049 = l_table_data.field049
           LET ga_table_data[l_i].field050 = l_table_data.field050
           LET ga_table_data[l_i].field051 = l_table_data.field051
           LET ga_table_data[l_i].field052 = l_table_data.field052
           LET ga_table_data[l_i].field053 = l_table_data.field053
           LET ga_table_data[l_i].field054 = l_table_data.field054
           LET ga_table_data[l_i].field055 = l_table_data.field055
           LET ga_table_data[l_i].field056 = l_table_data.field056
           LET ga_table_data[l_i].field057 = l_table_data.field057
           LET ga_table_data[l_i].field058 = l_table_data.field058
           LET ga_table_data[l_i].field059 = l_table_data.field059
           LET ga_table_data[l_i].field060 = l_table_data.field060
           LET ga_table_data[l_i].field061 = l_table_data.field061
           LET ga_table_data[l_i].field062 = l_table_data.field062
           LET ga_table_data[l_i].field063 = l_table_data.field063
           LET ga_table_data[l_i].field064 = l_table_data.field064
           LET ga_table_data[l_i].field065 = l_table_data.field065
           LET ga_table_data[l_i].field066 = l_table_data.field066
           LET ga_table_data[l_i].field067 = l_table_data.field067
           LET ga_table_data[l_i].field068 = l_table_data.field068
           LET ga_table_data[l_i].field069 = l_table_data.field069
           LET ga_table_data[l_i].field070 = l_table_data.field070
           LET ga_table_data[l_i].field071 = l_table_data.field071
           LET ga_table_data[l_i].field072 = l_table_data.field072
           LET ga_table_data[l_i].field073 = l_table_data.field073
           LET ga_table_data[l_i].field074 = l_table_data.field074
           LET ga_table_data[l_i].field075 = l_table_data.field075
           LET ga_table_data[l_i].field076 = l_table_data.field076
           LET ga_table_data[l_i].field077 = l_table_data.field077
           LET ga_table_data[l_i].field078 = l_table_data.field078
           LET ga_table_data[l_i].field079 = l_table_data.field079
           LET ga_table_data[l_i].field080 = l_table_data.field080
           LET ga_table_data[l_i].field081 = l_table_data.field081
           LET ga_table_data[l_i].field082 = l_table_data.field082
           LET ga_table_data[l_i].field083 = l_table_data.field083
           LET ga_table_data[l_i].field084 = l_table_data.field084
           LET ga_table_data[l_i].field085 = l_table_data.field085
           LET ga_table_data[l_i].field086 = l_table_data.field086
           LET ga_table_data[l_i].field087 = l_table_data.field087
           LET ga_table_data[l_i].field088 = l_table_data.field088
           LET ga_table_data[l_i].field089 = l_table_data.field089
           LET ga_table_data[l_i].field090 = l_table_data.field090
           LET ga_table_data[l_i].field091 = l_table_data.field091
           LET ga_table_data[l_i].field092 = l_table_data.field092
           LET ga_table_data[l_i].field093 = l_table_data.field093
           LET ga_table_data[l_i].field094 = l_table_data.field094
           LET ga_table_data[l_i].field095 = l_table_data.field095
           LET ga_table_data[l_i].field096 = l_table_data.field096
           LET ga_table_data[l_i].field097 = l_table_data.field097
           LET ga_table_data[l_i].field098 = l_table_data.field098
           LET ga_table_data[l_i].field099 = l_table_data.field099
           LET ga_table_data[l_i].field100 = l_table_data.field100
          #FUN-770079
          #LET ga_table_data[l_i].field101 = l_table_data.field101
          #LET ga_table_data[l_i].field102 = l_table_data.field102
          #LET ga_table_data[l_i].field103 = l_table_data.field103
          #LET ga_table_data[l_i].field104 = l_table_data.field104
          #LET ga_table_data[l_i].field105 = l_table_data.field105
          #LET ga_table_data[l_i].field106 = l_table_data.field106
          #LET ga_table_data[l_i].field107 = l_table_data.field107
          #LET ga_table_data[l_i].field108 = l_table_data.field108
          #LET ga_table_data[l_i].field109 = l_table_data.field109
          #LET ga_table_data[l_i].field110 = l_table_data.field110
          #LET ga_table_data[l_i].field111 = l_table_data.field111
          #LET ga_table_data[l_i].field112 = l_table_data.field112
          #LET ga_table_data[l_i].field113 = l_table_data.field113
          #LET ga_table_data[l_i].field114 = l_table_data.field114
          #LET ga_table_data[l_i].field115 = l_table_data.field115
          #LET ga_table_data[l_i].field116 = l_table_data.field116
          #LET ga_table_data[l_i].field117 = l_table_data.field117
          #LET ga_table_data[l_i].field118 = l_table_data.field118
          #LET ga_table_data[l_i].field119 = l_table_data.field119
          #LET ga_table_data[l_i].field120 = l_table_data.field120
          #LET ga_table_data[l_i].field121 = l_table_data.field121
          #LET ga_table_data[l_i].field122 = l_table_data.field122
          #LET ga_table_data[l_i].field123 = l_table_data.field123
          #LET ga_table_data[l_i].field124 = l_table_data.field124
          #LET ga_table_data[l_i].field125 = l_table_data.field125
          #LET ga_table_data[l_i].field126 = l_table_data.field126
          #LET ga_table_data[l_i].field127 = l_table_data.field127
          #LET ga_table_data[l_i].field128 = l_table_data.field128
          #LET ga_table_data[l_i].field129 = l_table_data.field129
          #LET ga_table_data[l_i].field130 = l_table_data.field130
          #LET ga_table_data[l_i].field131 = l_table_data.field131
          #LET ga_table_data[l_i].field132 = l_table_data.field132
          #LET ga_table_data[l_i].field133 = l_table_data.field133
          #LET ga_table_data[l_i].field134 = l_table_data.field134
          #LET ga_table_data[l_i].field135 = l_table_data.field135
          #LET ga_table_data[l_i].field136 = l_table_data.field136
          #LET ga_table_data[l_i].field137 = l_table_data.field137
          #LET ga_table_data[l_i].field138 = l_table_data.field138
          #LET ga_table_data[l_i].field139 = l_table_data.field139
          #LET ga_table_data[l_i].field140 = l_table_data.field140
          #LET ga_table_data[l_i].field141 = l_table_data.field141
          #LET ga_table_data[l_i].field142 = l_table_data.field142
          #LET ga_table_data[l_i].field143 = l_table_data.field143
          #LET ga_table_data[l_i].field144 = l_table_data.field144
          #LET ga_table_data[l_i].field145 = l_table_data.field145
          #LET ga_table_data[l_i].field146 = l_table_data.field146
          #LET ga_table_data[l_i].field147 = l_table_data.field147
          #LET ga_table_data[l_i].field148 = l_table_data.field148
          #LET ga_table_data[l_i].field149 = l_table_data.field149
          #LET ga_table_data[l_i].field150 = l_table_data.field150
          #LET ga_table_data[l_i].field151 = l_table_data.field151
          #LET ga_table_data[l_i].field152 = l_table_data.field152
          #LET ga_table_data[l_i].field153 = l_table_data.field153
          #LET ga_table_data[l_i].field154 = l_table_data.field154
          #LET ga_table_data[l_i].field155 = l_table_data.field155
          #LET ga_table_data[l_i].field156 = l_table_data.field156
          #LET ga_table_data[l_i].field157 = l_table_data.field157
          #LET ga_table_data[l_i].field158 = l_table_data.field158
          #LET ga_table_data[l_i].field159 = l_table_data.field159
          #LET ga_table_data[l_i].field160 = l_table_data.field160
          #LET ga_table_data[l_i].field161 = l_table_data.field161
          #LET ga_table_data[l_i].field162 = l_table_data.field162
          #LET ga_table_data[l_i].field163 = l_table_data.field163
          #LET ga_table_data[l_i].field164 = l_table_data.field164
          #LET ga_table_data[l_i].field165 = l_table_data.field165
          #LET ga_table_data[l_i].field166 = l_table_data.field166
          #LET ga_table_data[l_i].field167 = l_table_data.field167
          #LET ga_table_data[l_i].field168 = l_table_data.field168
          #LET ga_table_data[l_i].field169 = l_table_data.field169
          #LET ga_table_data[l_i].field170 = l_table_data.field170
          #LET ga_table_data[l_i].field171 = l_table_data.field171
          #LET ga_table_data[l_i].field172 = l_table_data.field172
          #LET ga_table_data[l_i].field173 = l_table_data.field173
          #LET ga_table_data[l_i].field174 = l_table_data.field174
          #LET ga_table_data[l_i].field175 = l_table_data.field175
          #LET ga_table_data[l_i].field176 = l_table_data.field176
          #LET ga_table_data[l_i].field177 = l_table_data.field177
          #LET ga_table_data[l_i].field178 = l_table_data.field178
          #LET ga_table_data[l_i].field179 = l_table_data.field179
          #LET ga_table_data[l_i].field180 = l_table_data.field180
          #LET ga_table_data[l_i].field181 = l_table_data.field181
          #LET ga_table_data[l_i].field182 = l_table_data.field182
          #LET ga_table_data[l_i].field183 = l_table_data.field183
          #LET ga_table_data[l_i].field184 = l_table_data.field184
          #LET ga_table_data[l_i].field185 = l_table_data.field185
          #LET ga_table_data[l_i].field186 = l_table_data.field186
          #LET ga_table_data[l_i].field187 = l_table_data.field187
          #LET ga_table_data[l_i].field188 = l_table_data.field188
          #LET ga_table_data[l_i].field189 = l_table_data.field189
          #LET ga_table_data[l_i].field190 = l_table_data.field190
          #LET ga_table_data[l_i].field191 = l_table_data.field191
          #LET ga_table_data[l_i].field192 = l_table_data.field192
          #LET ga_table_data[l_i].field193 = l_table_data.field193
          #LET ga_table_data[l_i].field194 = l_table_data.field194
          #LET ga_table_data[l_i].field195 = l_table_data.field195
          #LET ga_table_data[l_i].field196 = l_table_data.field196
          #LET ga_table_data[l_i].field197 = l_table_data.field197
          #LET ga_table_data[l_i].field198 = l_table_data.field198
          #LET ga_table_data[l_i].field199 = l_table_data.field199
          #LET ga_table_data[l_i].field200 = l_table_data.field200
          #END FUN-770079
          
           #No.FUN-860089 -- start --
           FOR l_k = 1 TO l_feld.getLength()
               IF g_qry_feld_type[l_k] = 'date' THEN
                  CALL cl_query_value(l_k,l_i)
               END IF
           END FOR
           #No.FUN-860089 -- end --
     
           LET l_i=l_i+1
           IF l_i > l_zap06 AND p_type != '2' THEN    #FUN-AC0010  增加選匯出成excel條件就不須筆數判斷
              CALL cl_err( '', 'azz-246', 1 )
              EXIT FOREACH
           END IF
       END FOREACH
       IF SQLCA.SQLCODE THEN
          CALL cl_err('',sqlca.sqlcode,1)
       END IF
       CALL ga_table_data.deleteElement(l_i)
       LET g_dbqry_rec_b = l_i - 1
 
       #No.FUN-860089 -- start --
       IF g_prog = 'p_query' THEN
          DISPLAY ARRAY ga_table_data TO s_table_data.* ATTRIBUTE ( COUNT = g_dbqry_rec_b)
             BEFORE DISPLAY
                    EXIT DISPLAY
          END DISPLAY
       END IF
       #No.FUN-860089 -- END  --
END FUNCTION
 
#No.FUN-810062
##################################################
# Private Func...: TRUE
# Descriptions...: 取得欄位顯示名稱及欄位長度
#                  p_flag = s 表 single 只查 field
#                  p_flag = m 表 multi 查 table 所有的 field
# Date & Author..:
# Input Parameter: p_tab,p_sel,p_flag
# Return code....:
# Modify.........: 
##################################################
#FUNCTION cl_query_dbqry_getlength(p_tab,p_sel,p_flag)
#DEFINE p_tab        STRING
#DEFINE l_sql        STRING
#DEFINE l_sn         LIKE type_file.num5     #No.FUN-680135 SMALLINT
#DEFINE p_flag       LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1) 
#DEFINE l_feldname   LIKE type_file.chr1000  #No.FUN-680135 VARCHAR(55)
#DEFINE l_colname    LIKE zal_file.zal04,    #No.FUN-680135 VARCHAR(20)
#       l_colnamec   LIKE gaq_file.gaq03,    #No.FUN-680135 VARCHAR(50)
#       l_collen     LIKE type_file.num5,    #No.FUN-680135 SMALLINT
#       l_coltype    LIKE type_file.chr3,    #No.FUN-680135 VARCHAR(3)
#       p_sel        LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
#
#    DROP TABLE xabc
#
#    CREATE TEMP TABLE xabc(
#      xabc01  SMALLINT,  
#      xabc02  VARCHAR(1000),
#      xabc03  SMALLINT)
#
##No.FUN-680135 --end
#    LET l_sn=1
#    IF p_flag='m' THEN
#       #IF g_db_type="IFX" THEN
#       CASE g_db_type                                             #FUN-750084
#        WHEN "IFX"                                                #FUN-750084
#          LET l_sql="SELECT c.colname,c.coltype,c.collength FROM syscolumns c,systables t",
#                    " WHERE c.tabid=t.tabid AND t.tabname='",p_tab CLIPPED,"'",
#                    " ORDER BY c.colno "
#          DECLARE cl_query_dbqry_getlength_d_ifx CURSOR FROM l_sql
#          FOREACH cl_query_dbqry_getlength_d_ifx INTO l_colname,l_coltype,l_collen
#             CASE WHEN l_coltype='1' or l_coltype='257'
#                       LET l_collen=5
#                  WHEN l_coltype='2' or l_coltype='258'
#                       LET l_collen=10
#                  WHEN l_coltype='5' or l_coltype='261'
#                       LET l_collen=20
#                  WHEN l_coltype='7' or l_coltype='263'
#                       LET l_collen=10
#             END CASE
#             CASE
#               WHEN p_sel='N'
#                  SELECT gaq03 INTO l_colnamec FROM gaq_file
#                  WHERE gaq01=l_colname AND gaq02=g_i
#                  IF cl_null(l_colnamec) THEN
#                     INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colname,l_collen)
#                     LET l_sn=l_sn+1
#                  ELSE
#                     INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colnamec,l_collen)
#                     LET l_sn=l_sn+1
#                  END IF
#               WHEN p_sel='I'
#                  INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colname,l_collen)
#                  LET l_sn=l_sn+1
#               OTHERWISE
#                  SELECT gaq03 INTO l_colnamec FROM gaq_file
#                  WHERE gaq01=l_colname AND gaq02=g_i
#                  LET l_feldname=l_colname CLIPPED,'(',l_colnamec CLIPPED,')'
#                  INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_feldname,l_collen)
#                  LET l_sn=l_sn+1
#             END CASE
#          END FOREACH
#       #ELSE
#       WHEN "ORA"                                                #FUN-750084
#          LET l_sql="SELECT lower(column_name),decode(data_type,'VARCHAR2',data_length,'DATE',10,'NUMBER',data_PRECISION) FROM user_tab_columns",
#                    " WHERE lower(table_name)='",p_tab CLIPPED,"'",
#                    " ORDER BY column_id "
#          DECLARE cl_query_dbqry_getlength_d CURSOR FROM l_sql
#          FOREACH cl_query_dbqry_getlength_d INTO l_colname,l_collen
#             CASE
#               WHEN p_sel='N'
#                  SELECT gaq03 INTO l_colnamec FROM gaq_file
#                  WHERE gaq01=l_colname AND gaq02=g_i
#                  IF cl_null(l_colnamec) THEN
#                     INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colname,l_collen)
#                     LET l_sn=l_sn+1
#                  ELSE
#                     INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colnamec,l_collen)
#                     LET l_sn=l_sn+1
#                  END IF
#               WHEN p_sel='I'
#                  INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colname,l_collen)
#                  LET l_sn=l_sn+1
#               OTHERWISE
#                  SELECT gaq03 INTO l_colnamec FROM gaq_file
#                  WHERE gaq01=l_colname AND gaq02=g_i
#                  INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colname||'('||l_colnamec||')',l_collen)
#                  LET l_sn=l_sn+1
#             END CASE
#          END FOREACH
#
#         WHEN "MSV"                                               #FUN-750084
#       END CASE                                                   #FUN-750084
#    ELSE
#       #IF g_db_type="IFX" THEN
#       CASE g_db_type                                             #FUN-750084
#        WHEN "IFX"                                                #FUN-750084
#          LET l_sql="SELECT c.colname,c.coltype,c.collength FROM syscolumns c",
#                    " WHERE c.colname='",p_tab CLIPPED,"'",
#                    " ORDER BY c.colno desc"
#          DECLARE cl_query_dbqry_getlength_d1_ifx CURSOR FROM l_sql
#          FOREACH cl_query_dbqry_getlength_d1_ifx INTO l_colname,l_coltype,l_collen
#             CASE WHEN l_coltype='1' or l_coltype='257'
#                       LET l_collen=5
#                  WHEN l_coltype='2' or l_coltype='258'
#                       LET l_collen=10
#                  WHEN l_coltype='5' or l_coltype='261'
#                       LET l_collen=20
#                  WHEN l_coltype='7' or l_coltype='263'
#                       LET l_collen=10
#             END CASE
#             CASE
#               WHEN p_sel='N'
#                  SELECT gaq03 INTO l_colnamec FROM gaq_file
#                  WHERE gaq01=l_colname AND gaq02=g_i
#                  IF cl_null(l_colnamec) THEN
#                     INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colname,l_collen)
#                  ELSE
#                     INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colnamec,l_collen)
#                  END IF
#               WHEN p_sel='I'
#                  INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colname,l_collen)
#               OTHERWISE
#                  SELECT gaq03 INTO l_colnamec FROM gaq_file
#                  WHERE gaq01=l_colname AND gaq02=g_i
#                  LET l_feldname=l_colname CLIPPED,'(',l_colnamec CLIPPED,')'
#                  INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_feldname,l_collen)
#             END CASE
#          END FOREACH
#          IF cl_null(l_colname) AND (l_collen=0) THEN
#             LET l_feldname=p_tab
#             INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_feldname,10)
#          END IF
#       #ELSE
#       WHEN "ORA"                                                   #FUN-750084
#          LET l_sql="SELECT lower(column_name),decode(data_type,'VARCHAR2',data_length,'DATE',10,'NUMBER',data_PRECISION) FROM user_tab_columns",
#                    " WHERE lower(column_name)='",p_tab CLIPPED,"'",
#                    " ORDER BY column_id desc"
#          DECLARE cl_query_dbqry_getlength_d1 CURSOR FROM l_sql
#          FOREACH cl_query_dbqry_getlength_d1 INTO l_colname,l_collen
#             CASE
#               WHEN p_sel='N'
#                  SELECT gaq03 INTO l_colnamec FROM gaq_file
#                  WHERE gaq01=l_colname AND gaq02=g_i
#                  IF cl_null(l_colnamec) THEN
#                     INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colname,l_collen)
#                  ELSE
#                     INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colnamec,l_collen)
#                  END IF
#               WHEN p_sel='I'
#                  INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colname,l_collen)
#               OTHERWISE
#                  SELECT gaq03 INTO l_colnamec FROM gaq_file
#                  WHERE gaq01=l_colname AND gaq02=g_i
#                  INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colname||'('||l_colnamec||')',l_collen)
#             END CASE
#          END FOREACH
#          IF cl_null(l_colname) AND (l_collen=0) THEN  #for count(*)之類的用途
#             LET l_feldname=p_tab
#             INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_feldname,10)
#          END IF
# 
#        WHEN "MSV"                                                #FUN-750084
#       END CASE                                                   #FUN-750084
#        
#    END IF
#END FUNCTION
#END No.FUN-810062
 
##################################################
# Private Func...: TRUE
# Descriptions...: 動態建立資料庫查詢畫面
# Date & Author..:
# Input Parameter: none
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_dbqry_buildForm()
    DEFINE lw_win   ui.Window
    DEFINE lf_form  ui.Form
    DEFINE ln_win,  ln_form, ln_vbox om.DomNode
 
 
    OPEN WINDOW query_w WITH FORM "lib/42f/cl_dummy" ATTRIBUTE(STYLE="create_qry")  #No.FUN-860089
 
    CALL cl_load_style_list(NULL)
    CALL cl_ui_locale("cl_dummy")
 
    LET lw_win = ui.Window.getCurrent()
    LET ln_win = lw_win.getNode()
    CALL ln_win.setAttribute("text", "DataBase Query: " || g_dbs)
#   LET ln_form = ln_win.createChild("Form")
    LET lf_form = lw_win.getForm()
    LET ln_form = lf_form.getNode()
    CALL ln_form.setAttribute("name", "cl_query_dbqry")
    LET ln_vbox = ln_form.createChild("VBox")
    CALL cl_query_dbqry_buildTable(ln_vbox)
#   CALL cl_query_dbqry_buildRecordView(ln_form)
 
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 動態建立資料庫畫面欄位
# Date & Author..:
# Input Parameter: pn_vbox
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_dbqry_buildTable(pn_vbox)
    DEFINE pn_vbox    om.DomNode
    DEFINE ln_table,ln_table_column, ln_edit om.DomNode
    DEFINE ln_grid,ln_FormField, ln_TextEdit,ln_RadioGroup,ln_Item om.DomNode
    DEFINE li_i       LIKE type_file.num10   #No.FUN-680135 INTEGER
    DEFINE ls_colname STRING
 
 
    LET ln_table = pn_vbox.createChild("Table")
    CALL ln_table.setAttribute("tabName", "s_table_data")
    CALL ln_table.setAttribute("pageSize", 10)
    CALL ln_table.setAttribute("size", 10)
   #CALL ln_table.setAttribute("unhidableColumns", 1)        #No.FUN-860089
    FOR li_i = 1 TO GI_MAX_COLUMN_COUNT
        LET ln_table_column = ln_table.createChild("TableColumn")
        LET ls_colname = "field", li_i USING "&&&"
        CALL ln_table_column.setAttribute("colName", ls_colname)
        CALL ln_table_column.setAttribute("name", "formonly." || ls_colname)
        CALL ln_table_column.setAttribute("text", ls_colname)
        CALL ln_table_column.setAttribute("noEntry", 1)
        CALL ln_table_column.setAttribute("hidden", 1)
        CALL ln_table_column.setAttribute("tabIndex", li_i)
        LET ln_edit = ln_table_column.createChild("Edit")
        CALL ln_edit.setAttribute("width", GI_COLUMN_WIDTH)
    END FOR
 
    #No.FUN-860089 -- start --
    IF g_prog = "p_query" THEN
       LET ln_grid = pn_vbox.createChild("Grid")
       LET ln_formfield = ln_grid.createChild("FormField")
       CALL ln_formfield.setAttribute("colName","selmethod")
       CALL ln_formfield.setAttribute("name","formonly.selmethod")
       CALL ln_formfield.setAttribute("tabIndex", GI_MAX_COLUMN_COUNT+1)
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
    END IF
    #No.FUN-860089 -- end --
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 
# Date & Author..:
# Input Parameter: pn_vbox
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_dbqry_buildRecordView(pn_form)
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
 
 
##################################################
# Private Func...: TRUE
# Descriptions...: 
# Date & Author..:
# Input Parameter: none
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_dbqry_showAbout()
    DEFINE ls_str STRING
 
 
    LET ls_str = "A simple database query for TIPTOP\n",
                 "\n",
                 "\n",
                 "Version: 0.1"
    MENU "About" ATTRIBUTE ( STYLE = "dialog", COMMENT = ls_str )
         COMMAND "Close"
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
            LET g_action_choice = "exit"
            EXIT MENU
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE MENU
 
       #No.TQC-860016 --start--
       ON ACTION controlg
          CALL cl_cmdask()
 
       ON ACTION about
          CALL cl_about()
 
       ON ACTION help
          CALL cl_show_help()
       #No.TQC-860016 ---end---
    END MENU
END FUNCTION
 
 
##################################################
# Private Func...: TRUE
# Descriptions...: 隱藏 unused 欄位
# Date & Author..:
# Input Parameter: none
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_dbqry_hideColumn()
    DEFINE lw_win  ui.Window
    DEFINE ln_win  om.DomNode
    DEFINE ln_edit om.DomNode
    DEFINE ll_edit om.NodeList
    DEFINE li_i    LIKE type_file.num10   #No.FUN-680135 INTEGER
 
 
    LET lw_win = ui.Window.getCurrent()
    LET ln_win = lw_win.getNode()
    LET ll_edit = ln_win.selectByPath("//Edit[@tag=\"unused\"]")
    FOR li_i = 1 TO ll_edit.getLength()
        LET ln_edit = ll_edit.item(li_i)
        CALL ln_edit.setAttribute("hidden", 1)
    END FOR
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 顯示 unused 欄位
# Date & Author..:
# Input Parameter: none
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_dbqry_unhideColumn()
    DEFINE lw_win  ui.Window
    DEFINE ln_win  om.DomNode
    DEFINE ln_edit om.DomNode
    DEFINE ll_edit om.NodeList
    DEFINE li_i    LIKE type_file.num10   #No.FUN-680135 INTEGER
 
 
    LET lw_win = ui.Window.getCurrent()
    LET ln_win = lw_win.getNode()
    LET ll_edit = ln_win.selectByPath("//Edit[@tag=\"unused\"]")
    FOR li_i = 1 TO ll_edit.getLength()
        LET ln_edit = ll_edit.item(li_i)
        CALL ln_edit.setAttribute("hidden", 0)
    END FOR
END FUNCTION
#FUN-810062
##################################################
# Descriptions...: 將字串裡的空白字元刪除 
# Date & Author..:
# Input Parameter: p_str   資料字串
# Return code....: l_cmd   處理後的字串
# Usage..........: LET l_str = cl_query_cut_spaces(p_str)
# Modify.........: 
##################################################
#FUNCTION cl_query_cut_spaces(p_str)     
#DEFINE p_str         STRING,
#       l_i           LIKE type_file.num10,         #No.FUN-680135 SMALLINT
#       l_flag        LIKE type_file.chr1,          #No.FUN-680135 VARCHAR(1) 
#       l_cmd         STRING,
#       l_desc_stop   LIKE type_file.num5           #No.FUN-680135 SMALLINT
#
#  IF cl_null(g_db_type) THEN                       #FUN-7C0020
#     LET g_db_type=cl_db_get_database_type()       # No.TQC-810073
#  END IF
#
#  LET l_flag='N'
#  LET l_desc_stop=-1
#  LET p_str=p_str.trim()
#  FOR l_i=1 TO p_str.getLength()
#    IF l_i<=l_desc_stop+1 THEN
#       CONTINUE FOR
#    ELSE
#       #IF g_db_type="IFX" THEN
#       CASE g_db_type                                        #FUN-750084
#        WHEN "IFX"                                           #FUN-750084
#          IF l_i=p_str.getIndexOf('{',l_i) THEN
#             LET l_desc_stop=p_str.getIndexOf('}',l_i)
#             LET l_cmd=l_cmd,p_str.subString(l_i,l_desc_stop+1)
#          ELSE
#             IF p_str.subString(l_i,l_i) != ' ' THEN
#                IF l_cmd.getLength()=0 THEN
#                   LET l_cmd=p_str.subString(l_i,l_i)
#                ELSE
#                   LET l_cmd=l_cmd,p_str.subString(l_i,l_i)
#                END IF
#                LET l_flag='N'
#             ELSE
#                IF l_flag='N' THEN
#                   LET l_flag='Y'
#                   LET l_cmd=l_cmd,p_str.subString(l_i,l_i)
#                END IF
#             END IF
#          END IF
#       #ELSE
#       WHEN "ORA"                                            #FUN-750084
#          IF l_i=p_str.getIndexOf('/*',l_i) THEN
#             LET l_desc_stop=p_str.getIndexOf('*/',l_i)
#             LET l_cmd=l_cmd,p_str.subString(l_i,l_desc_stop+1)
#          ELSE
#             IF p_str.subString(l_i,l_i) != ' ' THEN
#                IF l_cmd.getLength()=0 THEN
#                   LET l_cmd=p_str.subString(l_i,l_i)
#                ELSE
#                   LET l_cmd=l_cmd,p_str.subString(l_i,l_i)
#                END IF
#                LET l_flag='N'
#             ELSE
#                IF l_flag='N' THEN
#                   LET l_flag='Y'
#                   LET l_cmd=l_cmd,p_str.subString(l_i,l_i)
#                END IF
#             END IF
#          END IF
#        WHEN "MSV"                                               #FUN-750084
#       END CASE                                                  #FUN-750084 
#    END IF
#  END FOR
#  RETURN l_cmd
#END FUNCTION
#END  FUN-810062
#No.TQC-810080
