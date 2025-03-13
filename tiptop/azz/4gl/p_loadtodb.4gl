# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: p_loadtodb.4gl
# Descriptions...: Client端檔案回寫資料庫工具
# Date & Author..: 05/02/25 by saki
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-860017 08/06/09 By Jerry 修改程式控制區間內,缺乏ON IDLE的部份
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A50035 10/05/07 By Jay ls_cell組字串時去空白
# Modify.........: No.FUN-A70082 10/07/15 by jay 調整使用gat_file來判斷table是否存在，需要改成用zta_file來判斷
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_temp_path   STRING
 
MAIN
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time    #No.TQC-860017 by saki
 
   OPEN WINDOW unload_w AT 1,1 WITH FORM "azz/42f/p_loadtodb"
 
   CALL cl_ui_init()
 
   LET g_temp_path = FGL_GETENV("TEMPDIR")
 
   CALL unload_i()
        
   CLOSE WINDOW unload_w                 #結束畫面
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #No.TQC-860017 by saki
END MAIN
 
FUNCTION unload_i()
   DEFINE   ls_doc_path   STRING
   DEFINE   lc_azp03      LIKE azp_file.azp03
   DEFINE   lc_gat01      LIKE gat_file.gat01
   DEFINE   li_cnt        LIKE type_file.num10   #FUN-680135 INTEGER
   DEFINE   li_result     LIKE type_file.num5    #No.FUN-680135 SMALLINT
 
 
   CALL cl_set_act_visible("accept",FALSE)
   INPUT ls_doc_path,lc_azp03,lc_gat01
    FROM FORMONLY.doc_path,FORMONLY.db_name,FORMONLY.tab_name
 
      AFTER FIELD db_name
         IF NOT cl_null(lc_azp03) THEN
            SELECT COUNT(*) INTO li_cnt FROM azp_file WHERE azp03 = lc_azp03
            IF li_cnt <= 0 THEN
               CALL cl_err(lc_azp03,"-827",0)
               NEXT FIELD db_name
            END IF
         END IF
 
      AFTER FIELD tab_name
         IF NOT cl_null(lc_gat01) THEN
            #FUN-A70082-----start----
            #SELECT COUNT(*) INTO li_cnt FROM gat_file WHERE gat01 = lc_gat01
            SELECT COUNT(*) INTO li_cnt FROM zta_file WHERE zta01 = lc_gat01 AND zta02 = 'ds'
            #FUN-A70082-----end----- 
            IF li_cnt <= 0 THEN
               CALL cl_err(lc_gat01,"azz-710",0)
               NEXT FIELD tab_name
            END IF
         END IF
     
      ON ACTION open_file
         CALL cl_browse_file() RETURNING ls_doc_path
         DISPLAY ls_doc_path TO FORMONLY.doc_path
 
      ON ACTION file_analyze
         CALL cl_loadtodb_file_analyze(ls_doc_path)
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(db_name)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp4zta"
               LET g_qryparam.default1 = lc_azp03
               CALL cl_create_qry() RETURNING lc_azp03
               DISPLAY lc_azp03 TO FORMONLY.db_name
            WHEN INFIELD(tab_name)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gat"
               LET g_qryparam.arg1 = g_lang CLIPPED
               LET g_qryparam.default1 = lc_gat01
               CALL cl_create_qry() RETURNING lc_gat01
               DISPLAY lc_gat01 TO FORMONLY.tab_name
         END CASE
 
      ON ACTION exit
         EXIT INPUT
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
   CALL cl_set_act_visible("accept",TRUE)
END FUNCTION
 
FUNCTION cl_loadtodb_file_analyze(p_doc_path)
   DEFINE   p_doc_path    STRING
   DEFINE   llst_path     base.StringTokenizer
   DEFINE   ls_file_name  STRING
   DEFINE   ls_file_path  STRING
   DEFINE   ls_cmd        STRING
   DEFINE   li_i,li_j     LIKE type_file.num10   #FUN-680135 INTEGER
   DEFINE   ls_i,ls_j     STRING
   DEFINE   ls_cell       STRING
   DEFINE   li_result     LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   ls_value      STRING
   DEFINE   lr_field      DYNAMIC ARRAY OF RECORD
               field_no   STRING,
               type       STRING,
               desc       STRING
                          END RECORD
 
 
   IF p_doc_path IS NULL THEN
      RETURN
   ELSE
      LET ls_file_path = "\"",p_doc_path,"\""
      LET ls_file_name = p_doc_path
      WHILE TRUE
         IF ls_file_name.getIndexOf("/",1) THEN
            LET ls_file_name = ls_file_name.subString(ls_file_name.getIndexOf("/",1) + 1,ls_file_name.getLength())
         ELSE
            EXIT WHILE
         END IF
      END WHILE
      DISPLAY 'ls_file_path = ',ls_file_path
   END IF
 
   CALL ui.Interface.frontCall("standard","shellexec",[ls_file_path] ,li_result)
   CALL checkError2(li_result,"Open File")
 
   CALL ui.Interface.frontCall("WINDDE","DDEConnect",["EXCEL",ls_file_name],[li_result])
   CALL checkError2(li_result,"Connect File")
 
   CALL ui.Interface.frontCall("WINDDE","DDEConnect",["EXCEL","Sheet1"],[li_result])
   CALL checkError2(li_result,"Connect Sheet1")
 
   DISPLAY ls_file_name," File Analyze..."
 
   CALL lr_field.clear()
   LET li_i = 2
   WHILE TRUE
      LET ls_i = li_i
      FOR li_j = 1 TO 3
         LET ls_j = li_j
         LET ls_cell = "R",ls_i.trim(),"C",ls_j.trim()     #MOD-A50035
         CALL ui.Interface.frontCall("WINDDE","DDEPeek",["EXCEL",ls_file_name,ls_cell],[li_result,ls_value])
         CALL checkError2(li_result,"Peek Cells")
         IF (li_j = 1) AND (ls_value IS NULL) THEN
            EXIT WHILE
         ELSE
            CASE li_j
               WHEN 1
                  LET lr_field[li_i-1].field_no = ls_value
               WHEN 2
                  LET lr_field[li_i-1].type = ls_value
               WHEN 3
                  LET lr_field[li_i-1].desc = ls_value
            END CASE
         END IF
      END FOR
      LET li_i = li_i + 1
   END WHILE
 
   CALL ui.Interface.frontCall("WINDDE","DDEFinish",["EXCEL",ls_file_name],[li_result])
   CALL checkError2(li_result,"Finish")
 
   DISPLAY ARRAY lr_field TO s_field.* ATTRIBUTE(COUNT=lr_field.getLength(),UNBUFFERED)
      ON ACTION import
         DISPLAY 'import'
      ON ACTION cancel
         EXIT DISPLAY
      ON ACTION exit
         EXIT DISPLAY
#TQC-860017 start
      ON ACTION about
         CALL cl_about()
      ON ACTION controlg
         CALL cl_cmdask()
      ON ACTION help
         CALL cl_show_help()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
#TQC-860017 end  
    END DISPLAY
 
END FUNCTION
 
FUNCTION checkError2(p_result,p_msg)
   DEFINE   p_result   LIKE type_file.num5    #FUN-680135 SMALLINT
   DEFINE   p_msg      STRING
   DEFINE   ls_msg     STRING
   DEFINE   li_result  LIKE type_file.num5    #No.FUN-680135 SMALLINT
 
 
   IF p_result THEN
      RETURN
   END IF
   DISPLAY p_msg," DDE ERROR:"
   CALL ui.Interface.frontCall("WINDDE","DDEError",[],[ls_msg])
   DISPLAY ls_msg
   CALL ui.Interface.frontCall("WINDDE","DDEFinishAll",[],[li_result])
   IF NOT li_result THEN
      DISPLAY "Exit with DDE Error."
   END IF
   EXIT PROGRAM
END FUNCTION
