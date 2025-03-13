# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: p_genxml.4gl
# Descriptions...: 報表資料來源維護作業
# Date & Author..: 07/03/02 By Echo   #FUN-730005
# Modify.........: No.FUN-770106 07/09/10 By JackLai 提供產生子報表的DataSet的XML檔案功能
# Modify.........: No.FUN-810062 08/01/23 By Echo 調整 p_query 作業可以在 Windows 版執行
# Modify.........: No.FUN-8C0027 08/12/03 By tsai_yen 修正blob資料型態
# Modify.........: No.FUN-860089 08/12/12 By Echo CR viewer 功能- 新增接收參數 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60085 10/06/28 By Jay 呼叫cl_query_prt_getlength()只做一次CREATE TEMP TABLE
# Modify.........: No.FUN-AC0011 10/03/08 By Jay 調整取得sql語法中table name與別名方式
 
DATABASE ds     #FUN-730005
 
GLOBALS "../../config/top.global"
 
GLOBALS
   DEFINE ms_codeset    STRING
END GLOBALS
 
DEFINE g_xml_sql     STRING
DEFINE g_sql_type    LIKE type_file.chr1  #SQL型態(S:select,T:temptable)
DEFINE g_execmd_sql  STRING               
DEFINE g_xml_name    STRING               
DEFINE g_xml_out     STRING               
DEFINE g_xml         DYNAMIC ARRAY OF RECORD
                     xml01   STRING,
                     xml02   STRING,
                     xml03   STRING,
                     xml04   STRING
                     END RECORD
DEFINE g_rec_b       LIKE type_file.num10
DEFINE l_ac          LIKE type_file.num10
MAIN
    DEFINE
         p_row,p_col       LIKE type_file.num5  
 
    OPTIONS
       INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   #No.FUN-860089 -- start --
   LET g_xml_name = ARG_VAL(1)
   LET g_xml_sql = ARG_VAL(2)
   #No.FUN-860089 -- end --
 
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
 
   LET p_row = 4 LET p_col = 12
   OPEN WINDOW p_genxml_w AT 0,0 WITH FORM "azz/42f/p_genxml"
   ATTRIBUTE(STYLE=g_win_style)
 
   CALL cl_ui_init()
 
   CALL p_genxml_sql()                  
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
   ELSE
      LET l_ac = 1
      CALL p_genxml_b()
   END IF
 
   CALL p_genxml_menu()
 
   CLOSE WINDOW p_genxml_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
 
END MAIN
 
FUNCTION p_genxml_menu()
 
  WHILE TRUE
 
     CALL p_genxml_bp('G')
 
     CASE g_action_choice
 
       WHEN "exit"                               #"Esc.結束"
         EXIT WHILE 
 
       WHEN "genxml_sql"                         #輸入SQL指令  
         IF cl_chk_act_auth() THEN
            CALL p_genxml_sql()                  
            IF INT_FLAG THEN
               LET INT_FLAG = 0 
            ELSE
               LET l_ac = 1
               CALL p_genxml_b()
            END IF
         END IF
 
       WHEN "genxml_generate"                    #匯出 XML 檔
         IF cl_chk_act_auth() THEN
            CALL p_genxml_generate()
         END IF
 
       WHEN "detail"
         IF cl_chk_act_auth() THEN
            CALL p_genxml_b()
         ELSE
            LET g_action_choice = NULL
         END IF
 
       WHEN "controlg"                        # KEY(CONTROL-G)
          CALL cl_cmdask()
 
     END CASE
  END WHILE
 
END FUNCTION
 
FUNCTION p_genxml_bp(p_ud)
  DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
  IF p_ud <> "G" OR g_action_choice = "detail" THEN
     RETURN
  END IF
 
  LET g_action_choice = " "
 
  CALL cl_set_act_visible("accept,cancel", FALSE)
  DISPLAY ARRAY g_xml TO s_xml.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      ON ACTION help               #"H.說明" HELP 10102
         CALL cl_show_help()
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                  
 
      ON ACTION exit               #"Esc.結束"
         LET g_action_choice="exit"
         EXIT DISPLAY
 
     ON ACTION cancel
        LET INT_FLAG=FALSE                 #MOD-570244     mars
        LET g_action_choice="exit"
        EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION genxml_sql                         #輸入SQL指令  
         LET g_action_choice="genxml_sql"
         EXIT DISPLAY
 
      ON ACTION genxml_generate                    #匯出 XML 檔
         LET g_action_choice="genxml_generate"
         EXIT DISPLAY
 
      ON ACTION detail                             
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
   END DISPlAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION p_genxml_sql()
DEFINE l_gaz01       LIKE gaz_file.gaz01
DEFINE l_gaz03       LIKE gaz_file.gaz03
 
  
   CLEAR FORM
   CALL g_xml.clear()
   LET g_xml_out = ""
   LET g_rec_b = 0
 
   #No.FUN-860089 -- start --
   IF g_action_choice="genxml_sql" THEN
      LET g_xml_name = ""
      LET g_xml_sql = ""
   END IF
   DISPLAY g_xml_name,g_xml_sql TO xmlname,xmlsql
   #END No.FUN-860089 -- start --
 
   #INPUT g_xml_sql WITHOUT DEFAULTS FROM sql
   INPUT g_xml_name,g_xml_sql WITHOUT DEFAULTS FROM xmlname,xmlsql
 
       AFTER FIELD xmlname
          IF NOT cl_null(g_xml_name) THEN
             IF NOT p_genxml_chkname(g_xml_name) THEN
                CALL cl_err(g_xml_name,'azz-052',1)
                NEXT FIELD xmlname
             END IF
          END IF
 
          LET l_gaz01 = g_xml_name
 
          LET l_gaz01 = p_genxml_get_prog(l_gaz01) CLIPPED  #No.FUN-770106
          
          SELECT gaz03 INTO l_gaz03 FROM gaz_file 
               WHERE gaz01 = l_gaz01  AND gaz02 = g_lang
          DISPLAY l_gaz03 TO FORMONLY.gaz03
 
       AFTER INPUT
          IF INT_FLAG THEN                            # 使用者不玩了
              CLEAR FORM
              CALL g_xml.clear()
              LET g_rec_b = 0
              EXIT INPUT
          END IF
       
          #檢查 SQL 指令是否正確 
          IF NOT p_genxml_sql_check(g_xml_sql) THEN
             DISPLAY "" TO FORMONLY.out
             NEXT FIELD xmlsql
          END IF
 
          #產生 XML Array
          IF NOT p_genxml_array() THEN
             NEXT FIELD xmlsql
          END IF
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(xmlname)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_zz"
                LET g_qryparam.arg1 =  g_lang
                LET g_qryparam.default1= g_xml_name
                CALL cl_create_qry() RETURNING g_xml_name
 
                LET l_gaz01 = g_xml_name
                SELECT gaz03 INTO l_gaz03 FROM gaz_file 
                     WHERE gaz01 = l_gaz01  AND gaz02 = g_lang
                DISPLAY g_xml_name TO xmlname
                DISPLAY l_gaz03 TO FORMONLY.gaz03
                NEXT FIELD xmlname
             OTHERWISE
                EXIT CASE
          END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about
          CALL cl_about()
 
       ON ACTION help
          CALL cl_show_help()
 
       ON ACTION controlg
          CALL cl_cmdask()
 
       ON ACTION controlz
          CALL cl_show_req_fields()
 
       ON ACTION controlf                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
   END INPUT
 
END FUNCTION
 
FUNCTION p_genxml_generate()
DEFINE output_name     STRING
DEFINE unix_path       STRING,
       window_path     STRING 
DEFINE l_channel       base.Channel
DEFINE l_cmd           STRING
 
    LET output_name = g_xml_name,".xml"
 
    LET l_channel = base.Channel.create()
    CALL l_channel.openFile(output_name,"a" )
    CALL l_channel.setDelimiter("")
 
    CALL l_channel.write(g_xml_out)
    CALL l_channel.close()
     
    LET unix_path = "$TEMPDIR/",output_name 
    LET window_path = "c:\\tiptop\\",output_name          #FUN-660179
 
    LET status = cl_download_file(unix_path, window_path) #FUN-660179
    IF status then
       CALL cl_err(output_name,"amd-020",1)
       DISPLAY "Download OK!!"
    ELSE
       CALL cl_err(output_name,"amd-021",1)
       DISPLAY "Download fail!!"
    END IF
 
    LET l_cmd = "rm ",output_name CLIPPED," 2>/dev/null"
    RUN l_cmd
 
END FUNCTION
 
FUNCTION p_genxml_b()
DEFINE l_allow_insert  LIKE type_file.num5,
       l_allow_delete  LIKE type_file.num5
DEFINE l_i             LIKE type_file.num10
DEFINE l_value         STRING
DEFINE l_date          LIKE type_file.dat
DEFINE buf             base.StringBuffer
 
      LET g_action_choice = ""
 
     #LET l_allow_insert = cl_detail_input_auth("insert")
     #LET l_allow_delete = cl_detail_input_auth("delete")
      LET l_allow_insert = FALSE
      LET l_allow_delete = FALSE
 
      INPUT ARRAY g_xml WITHOUT DEFAULTS FROM s_xml.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
            INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
         BEFORE INPUT
             IF g_rec_b != 0 THEN
                CALL fgl_set_arr_curr(l_ac)
             END IF
 
         BEFORE ROW
            LET l_ac = ARR_CURR()
 
         AFTER FIELD xml04
            IF NOT cl_null(g_xml[l_ac].xml04) THEN
               IF FGL_WIDTH(g_xml[l_ac].xml04) > g_xml[l_ac].xml03 THEN
                  CALL cl_err('','-460',0)
                  NEXT FIELD xml04 
               END IF
               CASE 
                WHEN g_xml[l_ac].xml02="smallint" OR g_xml[l_ac].xml02="integer" 
                  OR g_xml[l_ac].xml02="number"   OR g_xml[l_ac].xml02="decimal" 
                   LET l_i = g_xml[l_ac].xml04
                   IF l_i IS NULL OR (l_i = 0 AND g_xml[l_ac].xml04 != '0' )
                   THEN
                      CALL cl_err('','-1213',0)
                      NEXT FIELD xml04
                   END IF     
              
                WHEN g_xml[l_ac].xml02="date"  OR g_xml[l_ac].xml02="datetime" 
                   #LET l_value = cl_query_cut_spaces(g_xml[l_ac].xml04)
                   LET l_value = g_xml[l_ac].xml04 CLIPPED   #No.FUN-810062
                   LET l_date = l_value.trim()               #No.FUN-810062
                   IF cl_null(l_date) THEN
                      CALL cl_err('','-1106',0)
                      NEXT FIELD xml04
                   END IF
              
                   LET g_xml[l_ac].xml04 = l_date USING 'YYYY-MM-DD'
                   DISPLAY g_xml[l_ac].xml04 TO xml04
 
 
                END CASE
            END IF
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
       
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
       
         ON ACTION controls                           #No.FUN-6B0032
            CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         RETURN
      END IF
      CALL p_genxml_out()
 
END FUNCTION
 
FUNCTION p_genxml_sql_check(p_sql)
DEFINE p_sql         STRING
DEFINE buf           base.StringBuffer
DEFINE l_str         STRING
DEFINE l_tmp         STRING
DEFINE l_execmd      STRING
DEFINE l_tok         base.StringTokenizer
DEFINE l_start	     LIKE type_file.num5       
DEFINE l_end  	     LIKE type_file.num5       
DEFINE l_tok_table   base.StringTokenizer
DEFINE l_cnt_dot     LIKE type_file.num5
DEFINE l_cnt_comma   LIKE type_file.num5
DEFINE l_text        STRING
DEFINE l_field       RECORD
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
        field099, field100  LIKE gaq_file.gaq03     #No.FUN-680135 VARCHAR(255)
                    END RECORD
 
        
        LET buf = base.StringBuffer.create()
        CALL buf.append(p_sql CLIPPED)
        CALL buf.replace( "\"","'", 0)
        LET p_sql = buf.toString()
 
       #LET l_str= cl_query_cut_spaces(p_sql)
        LET l_str= p_sql.trim()                              #No.FUN-810062
        LET l_end = l_str.getIndexOf(';',1)
        IF l_end != 0 THEN
           LET l_str=l_str.subString(1,l_end-1)
        END IF
        LET l_tok = base.StringTokenizer.createExt(l_str CLIPPED,"\n","",TRUE)
        LET l_text = NULL
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
 
        LET l_execmd = l_execmd.toLowerCase()
        LET l_start = l_execmd.getIndexOf('select',1)
        IF l_start > 0 THEN
 
           PREPARE sql_pre1 FROM l_execmd
           IF SQLCA.SQLCODE THEN
              CALL cl_err("prepare:",sqlca.sqlcode,1) 
              RETURN 0
           END IF
           
           DECLARE sql_cur1 CURSOR FOR sql_pre1
           IF SQLCA.SQLCODE THEN
              CALL cl_err("prepare:",sqlca.sqlcode,1) 
              RETURN 0
           END IF
           
           FOREACH sql_cur1 INTO l_field.*
              EXIT FOREACH
           END FOREACH
           IF SQLCA.SQLCODE THEN
              CALL cl_err("prepare:",sqlca.sqlcode,1) 
              RETURN 0
           END IF
           LET g_sql_type = "S"
        ELSE
           LET l_tok_table = base.StringTokenizer.create(p_sql,".")
           LET l_cnt_dot = l_tok_table.countTokens()
           LET l_tok_table = base.StringTokenizer.create(p_sql,",")
           LET l_cnt_comma = l_tok_table.countTokens()
           IF ((l_cnt_dot-1)/2)  <> l_cnt_comma THEN
             IF g_bgerr THEN                                                                                                               
                CALL s_errmsg('','','','lib-359',1)                                                                     
             ELSE                                                                                                                          
                CALL cl_err('','lib-359',1)                                                                             
             END IF                                                                                                                        
             RETURN 0
           END IF
           LET g_sql_type = "T"
        END IF
        LET g_execmd_sql = l_execmd
        RETURN 1
        
END FUNCTION
 
FUNCTION p_genxml_out()
DEFINE l_str              STRING
DEFINE l_str2             STRING
DEFINE l_tok_table        base.StringTokenizer,
       l_table_name       LIKE gac_file.gac05,
       l_field_name       LIKE gac_file.gac06,
       l_alias_name       LIKE gac_file.gac06,
       l_datatype         LIKE ztb_file.ztb04
DEFINE l_p                LIKE type_file.num5,
       l_p2               LIKE type_file.num5,
       l_sql              STRING,
       l_name             STRING,
       l_length           STRING
DEFINE l_i,l_k,l_j        LIKE type_file.num10                  
DEFINE l_feld             DYNAMIC ARRAY OF STRING               #欄位ID
DEFINE l_feld_cnt         LIKE type_file.num5                   #欄位數
DEFINE l_feld_tmp         LIKE type_file.chr1000
DEFINE l_str_bak          STRING
DEFINE l_tmp              STRING
DEFINE l_tok              base.StringTokenizer
DEFINE l_start            LIKE type_file.num10          #No.FUN-680135 SMALLINT
DEFINE l_end              LIKE type_file.num10          #No.FUN-680135 SMALLINT
DEFINE l_sel              LIKE type_file.chr1
DEFINE l_tab_cnt          LIKE type_file.num5  
DEFINE l_tab              DYNAMIC ARRAY OF STRING
DEFINE l_tab_alias        DYNAMIC ARRAY OF STRING
DEFINE l_feld_length      LIKE type_file.num5  #欄位長度
DEFINE l_scale            LIKE type_file.num10 #欄位小數點
 
   IF g_xml.getLength() = 0 THEN
         RETURN
   END IF
 
   LET l_str = "<?xml version=\"1.0\" encoding=\"",ms_codeset,"\" standalone=\"yes\"?>", ASCII 10,
               "<NewDataSet>", ASCII 10,
               "  <xs:schema id=\"NewDataSet\" xmlns=\"\" xmlns:xs=\"http://www.w3.org/2001/XMLSchema\" xmlns:msdata=\"urn:schemas-microsoft-com:xml-msdata\"> ", ASCII 10,
               "    <xs:element name=\"NewDataSet\" msdata:IsDataSet=\"true\">", ASCII 10,
               "      <xs:complexType>", ASCII 10,
               "        <xs:choice maxOccurs=\"unbounded\">", ASCII 10,
               "          <xs:element name=\"",g_xml_name,"\">", ASCII 10,
               "            <xs:complexType>", ASCII 10,
               "              <xs:sequence>", ASCII 10
   FOR l_i = 1 TO g_xml.getLength()
              LET l_str2 = p_zxd_feld_type(g_xml[l_i].xml01,g_xml[l_i].xml02)
              LET l_str = l_str, l_str2
   END FOR
   LET l_str = l_str,
	       "              </xs:sequence>", ASCII 10,
               "           </xs:complexType>", ASCII 10,
               "         </xs:element>", ASCII 10,
               "       </xs:choice>", ASCII 10,
               "     </xs:complexType>", ASCII 10,
               "   </xs:element>", ASCII 10,
               " </xs:schema>", ASCII 10
   LET l_str2 = ""
   FOR l_i = 1 TO g_xml.getLength()
       IF NOT cl_null(g_xml[l_i].xml04) THEN
           LET l_str2 = l_str2,"   <",g_xml[l_i].xml01,">",g_xml[l_i].xml04,
                       "</",g_xml[l_i].xml01,">", ASCII 10
                       
       END IF
   END FOR
 
   IF NOT cl_null(l_str2) THEN
       LET l_str = l_str," <",g_xml_name,">", ASCII 10,
                   l_str2, 
                   "  </",g_xml_name,">", ASCII 10  
   END IF
 
   LET l_str = l_str, "</NewDataSet>"
 
   LET g_xml_out = l_str
   DISPLAY g_xml_out TO FORMONLY.out
END FUNCTION
 
 
FUNCTION p_genxml_array()
DEFINE l_str              STRING
DEFINE l_str2             STRING
DEFINE l_tok_table        base.StringTokenizer,
       l_table_name       LIKE gac_file.gac05,
       l_field_name       LIKE gac_file.gac06,
       l_alias_name       LIKE gac_file.gac06,
       l_datatype         LIKE ztb_file.ztb04
DEFINE l_p                LIKE type_file.num5,
       l_p2               LIKE type_file.num5,
       l_sql              STRING,
       l_name             STRING,
       l_length           STRING
DEFINE l_i,l_k,l_j        LIKE type_file.num10                  
DEFINE l_feld             DYNAMIC ARRAY OF STRING               #欄位ID
DEFINE l_feld_cnt         LIKE type_file.num5                   #欄位數
DEFINE l_feld_tmp         LIKE type_file.chr1000
DEFINE l_str_bak          STRING
DEFINE l_tmp              STRING
DEFINE l_tok              base.StringTokenizer
DEFINE l_start            LIKE type_file.num10          #No.FUN-680135 SMALLINT
DEFINE l_end              LIKE type_file.num10          #No.FUN-680135 SMALLINT
DEFINE l_sel              LIKE type_file.chr1
DEFINE l_tab_cnt          LIKE type_file.num5  
DEFINE l_tab              DYNAMIC ARRAY OF STRING
DEFINE l_tab_alias        DYNAMIC ARRAY OF STRING
DEFINE l_feld_length      LIKE type_file.num5     #欄位長度
DEFINE l_scale            LIKE type_file.num10    #欄位小數點
DEFINE l_dbname           STRING                        #No.FUN-810062
DEFINE l_table_tok        base.StringTokenizer          #FUN-AC0011
DEFINE l_text             STRING                        #FUN-AC0011
 
   LET g_rec_b = 0
 
   CASE g_sql_type 
      WHEN "S" 
           LET l_str_bak = g_execmd_sql.toLowerCase()
           LET l_start = l_str_bak.getIndexOf('select',1)
           IF l_start=0 THEN
              CALL cl_err('can not execute this command!','!',0)
              RETURN 0
           END IF
           LET l_end   = l_str_bak.getIndexOf('from',1)
           LET l_str2=l_str_bak.subString(l_start+7,l_end-2)
           LET l_str2=l_str2.trim()
           LET l_tok = base.StringTokenizer.createExt(l_str2 CLIPPED,",","",TRUE)
           LET l_i=1
           WHILE l_tok.hasMoreTokens()
                 LET l_feld[l_i]=l_tok.nextToken()
                 LET l_feld[l_i]=l_feld[l_i].trim()
                 LET l_i=l_i+1
           END WHILE
           LET l_feld_cnt=l_i-1
           
           LET l_start = l_str_bak.getIndexOf('from',1)
           LET l_end   = l_str_bak.getIndexOf('where',1)
           IF l_end=0 THEN
              LET l_end   = l_str_bak.getIndexOf('group',1)
              IF l_end=0 THEN
                 LET l_end   = l_str_bak.getIndexOf('order',1)
                 IF l_end=0 THEN
                    LET l_end=l_str_bak.getLength()
                    LET l_str2=l_str_bak.subString(l_start+5,l_end)
                 ELSE
                    LET l_str2=l_str_bak.subString(l_start+5,l_end-2)
                 END IF
              ELSE
                 LET l_str2=l_str_bak.subString(l_start+5,l_end-2)
              END IF
           ELSE
              LET l_str2=l_str_bak.subString(l_start+5,l_end-2)
           END IF
           LET l_str2=l_str2.trim()
           LET l_tok = base.StringTokenizer.createExt(l_str2 CLIPPED,",","",TRUE)
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
                       #LET l_tab[l_j]=l_tok.nextToken()          #FUN-AC0011 mark 改成下面取tok方式
                       LET l_tab[l_j] = l_table_tok.nextToken()   #FUN-AC0011
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
          
           CALL cl_query_prt_temptable()     #No.FUN-A60085
         
           FOR l_i=1 TO l_feld_cnt
               IF l_feld[l_i]='*' THEN
                  LET l_start = l_str_bak.getIndexOf('from',1)
                  LET l_end   = l_str_bak.getIndexOf('where',1)
                  IF l_end=0 THEN
                     LET l_end   = l_str_bak.getIndexOf('group',1)
                     IF l_end=0 THEN
                        LET l_end   = l_str_bak.getIndexOf('order',1)
                        IF l_end=0 THEN
                           LET l_end=l_str_bak.getLength()
                           LET l_str2=l_str_bak.subString(l_start+5,l_end)
                        ELSE
                           LET l_str2=l_str_bak.subString(l_start+5,l_end-2)
                        END IF
                     ELSE
                        LET l_str2=l_str_bak.subString(l_start+5,l_end-2)
                     END IF
                  ELSE
                     LET l_str2=l_str_bak.subString(l_start+5,l_end-2)
                  END IF
                  LET l_str2=l_str2.trim()
                  LET l_tok = base.StringTokenizer.createExt(l_str2 CLIPPED,",","",TRUE)
                  FOR l_j=1 TO l_tab_cnt 
                      CALL cl_query_prt_getlength(l_tab[l_j],l_sel,'m','0')   #No.FUN-810062
                      DECLARE cl_query_insert_d_ifx CURSOR FOR
                              SELECT xabc02,xabc03,xabc04,xabc05,xabc06 FROM xabc ORDER BY xabc01
                      FOREACH cl_query_insert_d_ifx INTO l_alias_name,l_feld_tmp,l_feld_length,l_scale,l_datatype
                         IF NOT p_zxd_feld(l_alias_name,l_datatype,l_feld_length,l_scale) THEN   #No.FUN-860089
                            RETURN 0 
                         END IF
                      END FOREACH
                  END FOR
                  EXIT FOR   #確保避免因人為的sql錯誤產生多除的顯示欄位
               ELSE
                  IF l_feld[l_i].getIndexOf('.',1) THEN
                     IF l_feld[l_i].subString(l_feld[l_i].getIndexOf('.',1)+1,l_feld[l_i].getLength())='*' THEN
                        FOR l_j=1 TO l_tab_cnt
                            IF l_tab_alias[l_j] is null THEN
                               IF l_tab[l_j]=l_feld[l_i].subString(1,l_feld[l_i].getIndexOf('.',1)-1) THEN
                                  CALL cl_query_prt_getlength(l_tab[l_j],l_sel,'m','0')  #No.FUN-810062
                                  DECLARE cl_query_insert_d1_ifx CURSOR FOR 
                                          SELECT xabc02,xabc03,xabc04,xabc05,xabc06 FROM xabc ORDER BY xabc01 DESC
                                  FOREACH cl_query_insert_d1_ifx INTO l_alias_name,l_feld_tmp,l_feld_length,l_scale,l_datatype
                                     IF NOT p_zxd_feld(l_alias_name,l_datatype,l_feld_length,l_scale) THEN  #No.FUN-860089
                                        RETURN 0 
                                     END IF
                                  END FOREACH
                               END IF
                            ELSE
                               IF l_tab_alias[l_j]=l_feld[l_i].subString(1,l_feld[l_i].getIndexOf('.',1)-1) THEN
                                  CALL cl_query_prt_getlength(l_tab[l_j],l_sel,'m','0')   #No.FUN-810062
                                  DECLARE cl_query_insert_d2_ifx CURSOR FOR 
                                          SELECT xabc02,xabc03,xabc04,xabc05,xabc06 FROM xabc ORDER BY xabc01 DESC
                                  FOREACH cl_query_insert_d2_ifx INTO l_alias_name,l_feld_tmp,l_feld_length,l_scale,l_datatype
                                     IF NOT p_zxd_feld(l_alias_name,l_datatype,l_feld_length,l_scale) THEN  #No.FUN-860089
                                        RETURN 0 
                                     END IF
                                  END FOREACH
                               END IF
                            END IF 
                        END FOR
                     ELSE
                        LET l_feld[l_i]=l_feld[l_i].subString(l_feld[l_i].getIndexOf('.',1)+1,l_feld[l_i].getLength())
                        CALL cl_query_prt_getlength(l_feld[l_i],l_sel,'s','0')    #No.FUN-810062
                        DECLARE cl_query_ifx CURSOR FOR 
                                SELECT xabc02,xabc03,xabc04,xabc05,xabc06 FROM xabc ORDER BY xabc01 DESC
                        FOREACH cl_query_ifx INTO l_alias_name,l_feld_tmp,l_feld_length,l_scale,l_datatype
                            IF NOT p_zxd_feld(l_alias_name,l_datatype,l_feld_length,l_scale) THEN   #No.FUN-860089
                               RETURN 0 
                            END IF
                        END FOREACH
                     END IF
                  ELSE
                        CALL cl_query_prt_getlength(l_feld[l_i],l_sel,'s','0')    #No.FUN-810062
                        DECLARE cl_query_d1_ifx CURSOR FOR 
                                SELECT xabc02,xabc03,xabc04,xabc05,xabc06 FROM xabc ORDER BY xabc01 DESC
                        FOREACH cl_query_d1_ifx INTO l_alias_name,l_feld_tmp,l_feld_length,l_scale,l_datatype
                            IF NOT p_zxd_feld(l_alias_name,l_datatype,l_feld_length,l_scale) THEN  #No.FUN-860089
                               RETURN 0 
                            END IF
                        END FOREACH
                  END IF
               END IF
           END FOR
      WHEN "T"
           ### Using Function to get data type and length ###
           LET l_tok_table = base.StringTokenizer.create(g_execmd_sql,",")
           WHILE l_tok_table.hasMoreTokens()
              #DISPLAY l_tok_table.nextToken()
              LET l_name = l_tok_table.nextToken()
              LET l_p = l_name.getIndexOf(".",1)
              LET l_p2 = l_name.getIndexOf(".",l_p+1)
              LET l_alias_name = l_name.subString(1,l_p-1)
              LET l_table_name = l_name.subString(l_p+1,l_p2-1)
              LET l_field_name = l_name.subString(l_p2+1,l_name.getLength())
              #No.FUN-810062 
              CASE cl_db_get_database_type()
                WHEN "MSV" 
                   LET l_dbname =  FGL_GETENV('MSSQLAREA'),'_ds'                
                OTHERWISE
                   LET l_dbname = 'ds'
              END CASE
              CALL cl_get_column_info(l_dbname,l_table_name,l_field_name)  
                  RETURNING l_datatype,l_length
              #END No.FUN-810062
              IF cl_null(l_datatype) THEN
                 CALL cl_err(l_field_name,'-2863',1)
                 RETURN 0
              END IF
              IF l_datatype  = 'date' THEN
                 LET l_length = 10
              END IF
 
              IF NOT p_zxd_feld(l_alias_name,l_datatype,l_length,'') THEN  #FUN-860089
                 RETURN 0
              END IF
           END WHILE
   END CASE  
   RETURN 1
END FUNCTION
 
 
FUNCTION p_zxd_feld(p_name,p_type,p_len,p_scale)        #No.FUN-860089
DEFINE p_name     STRING
DEFINE p_type     STRING   
DEFINE p_len      STRING
DEFINE l_i        LIKE type_file.num5
DEFINE p_scale    LIKE type_file.num10 #欄位小數點      #No.FUN-860089
 
    FOR l_i = 1 TO g_rec_b 
        IF g_xml[l_i].xml01 = p_name THEN
           CALl cl_err(p_name,'azz-300',0)
           LET g_rec_b = 0
           CALL g_xml.clear()
           RETURN 0
        END IF
    END FOR
    
    #No.FUN-860089 -- start --
    IF p_scale >= 0 THEN
       IF p_scale=0 THEN
          LET p_len = p_len.trim(),",0"
       ELSE
          LET p_len = p_len.trim(),",",p_scale USING '<<<<<<<<<<<'
       END IF
    END IF
    #No.FUN-860089 -- end --
 
    LET g_rec_b = g_rec_b + 1
    LET g_xml[g_rec_b].xml01 = p_name.trim()
    LET g_xml[g_rec_b].xml02 = p_type
    LET g_xml[g_rec_b].xml03 = p_len
    RETURN 1
END FUNCTION
 
 
FUNCTION p_zxd_feld_type(p_name,p_type)
DEFINE p_name     STRING
DEFINE p_type     STRING   
DEFINE l_str      STRING
 
   LET p_name = p_name.trim()
   CASE
       WHEN p_type = "smallint" OR p_type = "integer" OR
            p_type = "number"   OR  p_type = "decimal" 
            LET l_str = 18 SPACES,
                        "<xs:element name=\"",p_name,
                        "\" type=\"xs:decimal\" minOccurs=\"0\" />",ASCII 10    
       WHEN p_type = "date"  OR p_type = "datetime" 
            LET l_str = 18 SPACES,
                        "<xs:element name=\"",p_name,
                        "\" type=\"xs:dateTime\" minOccurs=\"0\" />",ASCII 10  
       ###FUN-8C0027 START ###
       WHEN p_type = "blob"   OR p_type = "byte"  #Informix 為 byte  #FUN-860089 
            LET l_str = 18 SPACES,
                        "<xs:element name=\"",p_name,
                        "\" type=\"xs:base64Binary\" minOccurs=\"0\" />",ASCII 10
       ###FUN-8C0027 END ###
       OTHERWISE
            LET l_str = 18 SPACES,
                        "<xs:element name=\"",p_name,
                        "\" type=\"xs:string\" minOccurs=\"0\" />",ASCII 10    
   END CASE
 
   RETURN l_str
END FUNCTION
 
FUNCTION p_genxml_chkname(p_xmlname)
 DEFINE p_xmlname   LIKE zz_file.zz01
 DEFINE li_i1       LIKE type_file.num5    #No.FUN-680135 SMALLINT
 DEFINE li_i2       LIKE type_file.num5    #No.FUN-680135 SMALLINT
 DEFINE lc_zz08     LIKE zz_file.zz08
 DEFINE lc_db       LIKE type_file.chr3    #No.FUN-680135 VARCHAR(3)
 DEFINE ls_str      STRING
 DEFINE lc_xmlname  STRING
 DEFINE l_cnt       LIKE type_file.num10
 DEFINE l_cnt2      LIKE type_file.num10
 
 LET p_xmlname = p_genxml_get_prog(p_xmlname) CLIPPED  #No.FUN-770106
 
 LET lc_db=cl_db_get_database_type()
  CASE lc_db
     WHEN "ORA"
         LET lc_zz08="%",p_xmlname CLIPPED,"%"
         SELECT COUNT(*) INTO li_i1 FROM zz_file
          WHERE zz08 LIKE lc_zz08
     WHEN "IFX"
         LET lc_zz08="*",p_xmlname CLIPPED,"*"
         SELECT COUNT(*) INTO li_i1 FROM zz_file
          WHERE zz08 MATCHES lc_zz08
   END CASE
   SELECT COUNT(*) INTO l_cnt from zz_file where zz01= p_xmlname
   IF li_i1 > 0 THEN
      select COUNT(*) INTO l_cnt2 from gak_file where gak01 = p_xmlname
      IF l_cnt2 = 0 THEN
         RETURN 0 
      END IF
   ELSE
      IF (li_i1 = 0 AND l_cnt = 0 )THEN
         RETURN 0
      ELSE
         SELECT zz08 INTO lc_zz08 FROM zz_file WHERE zz01=p_xmlname
         LET ls_str = DOWNSHIFT(lc_zz08) CLIPPED
         LET li_i1 = ls_str.getIndexOf("i/",1)
         LET li_i2 = ls_str.getIndexOf(" ",li_i1)
         IF li_i2 <= li_i1 THEN LET li_i2=ls_str.getLength() END IF
         LET lc_xmlname = ls_str.subString(li_i1+2,li_i2)
         CALL cl_err_msg(NULL,"azz-060",p_xmlname CLIPPED|| "|" || lc_xmlname,10)
         LET g_xml_name = lc_xmlname CLIPPED
         DISPLAY g_xml_name TO xmlname
      END IF
  END IF
  RETURN 1
END FUNCTION
 
#No.FUN-770106 --start--
#檢查傳入的字串是否含有正確程式代號, 並傳回程式代號
FUNCTION p_genxml_get_prog(p_xmlname)
    DEFINE p_xmlname   LIKE zz_file.zz01
    DEFINE lr_xmlname  LIKE zz_file.zz01      #傳出去的程式代號
    DEFINE lc_xmlname  STRING
    DEFINE l_endpos    LIKE type_file.num10   #最後一個'_'字元的位置
    DEFINE l_xmllen    LIKE type_file.num10   #傳入參數p_xmlname的字串長度
    DEFINE l_i         LIKE type_file.num10   #No.FUN-770106
    DEFINE l_cnt       LIKE type_file.num10
 
    INITIALIZE lr_xmlname TO NULL
    
    SELECT COUNT(*) INTO l_cnt from zz_file where zz01= p_xmlname
    IF l_cnt > 0 THEN
        RETURN p_xmlname CLIPPED
    ELSE 
        LET lc_xmlname = p_xmlname CLIPPED
        LET l_xmllen = lc_xmlname.getLength()
        FOR l_i = l_xmllen TO 1 STEP -1
            IF lc_xmlname.getCharAt(l_i) = "_" THEN
                LET l_endpos = l_i
                EXIT FOR
            END IF
        END FOR
        
        IF l_endpos > 1 THEN
            LET lr_xmlname = lc_xmlname.subString(1,l_endpos - 1)
        END IF
        
        RETURN lr_xmlname CLIPPED
    END IF 
END FUNCTION
#No.FUN-770106 --end--
