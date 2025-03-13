# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern Name...: p_charm_list.4gl
# DESCRIPTIONS...: 自訂圖表清單維護作業
# Date & Author..: 11/11/01 By tommas
# Modify.........: No.FUN-BA0079 by tommas 新建

IMPORT os
DATABASE ds

GLOBALS "../../config/top.global"
 
DEFINE 
     g_gdk           DYNAMIC ARRAY OF RECORD
        gdk01       LIKE gdk_file.gdk01,
        gfp04_name  LIKE gfp_file.gfp04,
        gfn02       LIKE gfn_file.gfn02,
        gfp04_desc  LIKE gfp_file.gfp04,
        gdk02       LIKE gdk_file.gdk02,
        gdk03       LIKE gdk_file.gdk03
                    END RECORD,
    g_gdk_t         RECORD
        gdk01       LIKE gdk_file.gdk01,
        gfp04_name  LIKE gfp_file.gfp04,
        gfn02       LIKE gfn_file.gfn02,
        gfp04_desc  LIKE gfp_file.gfp04,
        gdk02       LIKE gdk_file.gdk02,
        gdk03       LIKE gdk_file.gdk03
                    END RECORD,
    g_wc2,g_sql     STRING,
    g_rec_b         LIKE type_file.num5,              #單身筆數 
    l_ac            LIKE type_file.num5,              #目前處理的ARRAY CNT 
    g_account       LIKE type_file.num5           
DEFINE g_forupd_sql         STRING                  #SELECT ... FOR UPDATE SQL

DEFINE g_cnt                LIKE type_file.num10  
DEFINE g_before_input_done  LIKE type_file.num5  
DEFINE l_table              STRING               
 
MAIN  #No.FUN-BA0079
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
  
    WHENEVER ERROR CALL cl_err_msg_log
  
    IF (NOT cl_setup("AZZ")) THEN
       EXIT PROGRAM
    END IF
 
    LET g_sql="gdk01.gdk_file.gdk01,",
              "gdk02.gdk_file.gdk02,",
              "gdk03.gdk_file.gdk03,",
              "gdkuser.gdk_file.gdkuser,",
              "gdkdate.gdk_file.gdkdate,",
              "gdkgrup.gdk_file.gdkgrup,",
              "gdkoriu.gdk_file.gdkoriu,",
              "gdkorig.gdk_file.gdkorig,",
              "gdkmodu.gdk_file.gdkmodu"
    LET l_table=cl_prt_temptable("p_chartm_list",g_sql) CLIPPED
    IF l_table=-1 THEN EXIT PROGRAM END IF
    LET l_table = "gdk_file"
    LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?,?,?,?,?,?,?,?,?,?,?)"
    PREPARE insert_prep FROM g_sql
    PREPARE chartm_list_gfp FROM "SELECT a.gfp04, b.gfp04 FROM gfp_file a JOIN gfp_file b ON a.gfp01 = b.gfp01 AND b.gfp02 = 'desc' WHERE a.gfp01 = ? AND a.gfp02 = 'name' AND a.gfp03 = ? "
   
    IF STATUS THEN
        CALL cl_err("insert_prep:",STATUS,1)  
    END IF
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time   
 
    OPEN WINDOW chartm_list_w WITH FORM "azz/42f/p_chartm_list"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
 
  LET g_wc2 = '1=1' CALL chartm_list_b_fill(g_wc2)
 
  CALL chartm_list_menu()
  CLOSE WINDOW chartm_list_w                 #結束畫面

  CALL  cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
FUNCTION chartm_list_menu()
 
   WHILE TRUE
      CALL chartm_list_bp("G")
      CASE g_action_choice
         WHEN "query" 
             IF cl_chk_act_auth() THEN
                CALL chartm_list_q()
             END IF
         WHEN "detail"
             IF cl_chk_act_auth() THEN
               LET g_account=FALSE 
               CALL chartm_list_b()
             ELSE
                LET g_action_choice = NULL
             END IF

          WHEN "help"
             CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
          WHEN "controlg"
             CALL cl_cmdask()
           WHEN "related_document"  
             IF cl_chk_act_auth() AND l_ac != 0 THEN 
                IF g_gdk[l_ac].gdk01 IS NOT NULL THEN
                   LET g_doc.column1 = "gdk01"
                   LET g_doc.value1 = g_gdk[l_ac].gdk01
                   CALL cl_doc()
                END IF
             END IF
          WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gdk),'','')
             END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION chartm_list_q()
   CALL chartm_list_b_askkey()
END FUNCTION
 
FUNCTION chartm_list_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  
    l_n             LIKE type_file.num5,                #檢查重複用  
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否  
    p_cmd           LIKE type_file.chr1,                #處理狀態  
    l_allow_insert  LIKE type_file.chr1,                #可新增否
    l_allow_delete  LIKE type_file.chr1,                #可刪除否
    l_gdk01         LIKE gdk_file.gdk01
    LET g_rec_b = 20
    LET g_action_choice = ""    
     IF s_shut(0) THEN RETURN END IF
     CALL cl_opmsg('b')

 
     LET l_allow_insert = cl_detail_input_auth('insert')
     LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT gdk01,'','','',gdk02,gdk03",
                       "  FROM gdk_file WHERE gdk01 = ? FOR UPDATE"
     LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

    DECLARE chartm_list_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

     LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    LET g_rec_b = g_gdk.getLength()
    INPUT ARRAY g_gdk WITHOUT DEFAULTS FROM s_gdk.*
           ATTRIBUTE (UNBUFFERED)
    #      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
    #                 INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
    BEFORE INPUT
       IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(l_ac)
       END IF

    BEFORE ROW
        LET p_cmd=''
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT
        LET l_n  = ARR_COUNT()
        LET g_success = 'Y'          
        
        IF g_rec_b>=l_ac THEN
        #IF g_gdk_t.gdk01 IS NOT NULL THEN
           BEGIN WORK
           LET p_cmd='u'
           LET g_gdk_t.* = g_gdk[l_ac].*  #BACKUP
 
           #CALL chartm_list_set_entry_b()
                                            
           LET g_before_input_done = FALSE                                      
                                      
           LET g_before_input_done = TRUE                                       

           OPEN chartm_list_bcl USING g_gdk_t.gdk01
           IF STATUS THEN
              CALL cl_err("OPEN chartm_list_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH chartm_list_bcl INTO g_gdk[l_ac].*
              IF SQLCA.sqlcode AND SQLCA.sqlcode != 100 THEN
                  CALL cl_err(g_gdk_t.gdk01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
              END IF

           END IF
            CALL cl_show_fld_cont()   
        END IF
 
     BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
                                                         
         LET g_before_input_done = FALSE                                        
                                        
         LET g_before_input_done = TRUE                                         
  
         INITIALIZE g_gdk[l_ac].* TO NULL
         LET g_gdk_t.* = g_gdk[l_ac].*         #新輸入資料
          CALL cl_show_fld_cont()    
         NEXT FIELD gdk01
 
     AFTER INSERT
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE chartm_list_bcl
           CANCEL INSERT
        END IF
        
        BEGIN WORK                 
 
        INSERT INTO gdk_file(gdk01,gdk02,gdk03,gdkdate,gdkgrup,gdkmodu,gdkoriu,gdkorig,gdkuser)
        VALUES(g_gdk[l_ac].gdk01,g_gdk[l_ac].gdk02,g_gdk[l_ac].gdk03, today,'',g_user,g_user,g_grup,'')
        INSERT INTO gdj_file(gdj01,gdj02,gdj03,gdjdate,gdjgrup,gdjmodu,gdjoriu,gdjorig,gdjuser)
        VALUES(g_gdk[l_ac].gdk01,'2','default', today,'',g_user,g_user,g_grup,'')
        IF SQLCA.sqlcode THEN 
           CALL cl_err3("ins","gdk_file or gdj_file",g_gdk[l_ac].gdk01,"",SQLCA.sqlcode,"","",1) 
           CANCEL INSERT
        ELSE

              IF g_success = 'N' THEN 
                 ROLLBACK WORK                                     
                 CANCEL INSERT                                     
              ELSE 
                 LET g_rec_b=g_rec_b+1                             
                 DISPLAY g_rec_b TO FORMONLY.cn2                   
                 COMMIT WORK 
              END IF

        END IF
    ON ACTION controlp
       CASE 
          WHEN INFIELD(gdk01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gfn"
               LET g_qryparam.state ="i"
               CALL cl_create_qry() RETURNING l_gdk01 
               LET g_gdk[l_ac].gdk01 = l_gdk01
               DISPLAY l_gdk01 TO s_gdk.gdk01
               NEXT FIELD gdk01
       END CASE
       
    AFTER FIELD gdk01
        IF NOT cl_null(g_gdk[l_ac].gdk01) THEN  
           SELECT COUNT(*) INTO g_cnt FROM gdk_file  #check 圖表代碼是否重複
            WHERE gdk01 = g_gdk[l_ac].gdk01
           IF g_cnt > 1 THEN
              CALL cl_err('',-239,0)
              LET g_gdk[l_ac].gdk01 = g_gdk_t.gdk01
              NEXT FIELD gdk01
           END IF
           SELECT COUNT(*) INTO g_cnt FROM gfn_file  #check 圖表代碼是否存在於p_chart(gfn_file)
               WHERE gfn01 = g_gdk[l_ac].gdk01
           IF g_cnt == 0 THEN
              CALL cl_err('不存在於p_chart',-239,0)
              LET g_gdk[l_ac].gdk01 = g_gdk_t.gdk01
              NEXT FIELD gdk01
           END IF
           SELECT gfp04 INTO g_gdk[l_ac].gfp04_name FROM gfp_file 
                        WHERE gfp01 = g_gdk[l_ac].gdk01 
                          AND gfp02 = 'name' 
                          AND gfp03 = g_lang
           
        END IF
        LET l_gdk01 = g_gdk[l_ac].gdk01
        
    BEFORE DELETE                            #是否取消單身
        LET g_success = 'Y'                
        SELECT COUNT(*) INTO g_cnt FROM gdj_file 
         WHERE gdj01 = g_gdk_t.gdk01  AND gdj03 <> 'default'
        IF g_cnt > 0 THEN 
           CALL cl_err('','azz1104',1) 
        END IF 
        IF g_rec_b>=l_ac THEN
        #IF g_gdk_t.gdk01 IS NOT NULL THEN
           IF g_cnt = 0 THEN 
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
              INITIALIZE g_doc.* TO NULL              
              LET g_doc.column1 = "gdk01"            
              LET g_doc.value1 = g_gdk[l_ac].gdk01  
               CALL cl_del_doc()                   
              IF l_lock_sw = "Y" THEN 
                 CALL cl_err("", -263, 1) 
                 CANCEL DELETE 
              END IF 
              DELETE FROM gdk_file WHERE gdk01 = g_gdk_t.gdk01
              DELETE FROM gdj_file WHERE gdj01 = g_gdk_t.gdk01 AND gdj02 = '2' AND gdj03 = 'default'
              IF SQLCA.sqlcode THEN
                #CALL cl_err(g_gdk_t.gdk01,SQLCA.sqlcode,0)  
                 CALL cl_err3("del","gdk_file or gdj_file",g_gdk_t.gdk01,"",SQLCA.sqlcode,"","",1) 
                 EXIT INPUT
              END IF

              LET g_rec_b=g_rec_b-1                      
              DISPLAY g_rec_b TO FORMONLY.cn2    
            ELSE
              ROLLBACK WORK
              EXIT INPUT 
            END IF 
 
         END IF
 
     ON ROW CHANGE
        IF INT_FLAG THEN                 #新增程式段
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           LET g_gdk[l_ac].* = g_gdk_t.*
           CLOSE chartm_list_bcl
           ROLLBACK WORK
           EXIT INPUT
        END IF
        IF l_lock_sw="Y" THEN
           CALL cl_err(g_gdk[l_ac].gdk01,-263,0)
           LET g_gdk[l_ac].* = g_gdk_t.*
        ELSE
           LET g_success = 'Y' 
           UPDATE gdk_file 
               SET gdk01=g_gdk[l_ac].gdk01,gdk02=g_gdk[l_ac].gdk02,
                   gdk03=g_gdk[l_ac].gdk03,
                   gdkmodu=g_user,gdkdate=g_today
            WHERE gdk01 = g_gdk_t.gdk01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","gdk_file",g_gdk[l_ac].gdk01,"",SQLCA.sqlcode,"","",1)
              LET g_gdk[l_ac].* = g_gdk_t.*
           END IF
        END IF
 
     AFTER ROW
        LET l_ac = ARR_CURR()         # 新增
        LET l_ac_t = l_ac             # 新增
 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           IF p_cmd='u' THEN
              LET g_gdk[l_ac].* = g_gdk_t.*
           END IF
           CLOSE chartm_list_bcl         # 新增

           ROLLBACK WORK          # 新增
           EXIT INPUT
        END IF
        CLOSE chartm_list_bcl            # 新增

        COMMIT WORK
         
     ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(gdk01) AND l_ac > 1 THEN
             LET g_gdk[l_ac].* = g_gdk[l_ac-1].*
             NEXT FIELD gdk01
         END IF
 
     ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
     ON ACTION CONTROLG
          CALL cl_cmdask()
 
     ON ACTION CONTROLF
          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
           CONTINUE INPUT
 
      ON ACTION about       
          CALL cl_about()  
 
      ON ACTION HELP      
          CALL cl_show_help()

     
     END INPUT
 
 
     CLOSE chartm_list_bcl
END FUNCTION
 
FUNCTION chartm_list_b_askkey()
 
    CLEAR FORM
   CALL g_gdk.clear()
 
    CONSTRUCT g_wc2 ON gdk01,gdk02,gdk03
         FROM s_gdk[1].gdk01,s_gdk[1].gdk02,s_gdk[1].gdk03
 
              BEFORE CONSTRUCT
                  CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(gdk10)
                CALL cl_init_qry_var()
                LET g_qryparam.form  = "q_gdk"
                LET g_qryparam.state = "c"   #多選
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO gdk10
               NEXT FIELD gdk10
         END CASE 
 
       ON IDLE g_idle_seconds
           CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about      
          CALL cl_about() 
 
      ON ACTION HELP     
          CALL cl_show_help()
 
      ON ACTION controlg  
          CALL cl_cmdask()
 
    
                  ON ACTION qbe_select
         	    CALL cl_qbe_select() 
                  ON ACTION qbe_save
		    CALL cl_qbe_save()
    END CONSTRUCT
     LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('gdkuser', 'gdkgrup')
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF

 
    CALL chartm_list_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION chartm_list_b_fill(p_wc2)   
DEFINE
    p_wc2           LIKE type_file.chr1000
 
    LET g_sql =
        "SELECT gdk01,gdk02,gdk03",
        " FROM gdk_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE chartm_list_pb FROM g_sql
    DECLARE gdk_curs CURSOR FOR chartm_list_pb
 
    CALL g_gdk.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH gdk_curs INTO g_gdk[g_cnt].gdk01, g_gdk[g_cnt].gdk02, g_gdk[g_cnt].gdk03   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        SELECT DISTINCT gfn02 INTO g_gdk[g_cnt].gfn02 FROM gfn_file WHERE gfn01 = g_gdk[g_cnt].gdk01
        CALL p_chartm_list_info(g_gdk[g_cnt].gdk01) RETURNING g_gdk[g_cnt].gfp04_name, g_gdk[g_cnt].gfp04_desc
        LET g_cnt = g_cnt + 1
         IF g_cnt > g_max_rec THEN
            CALL cl_err( '', 9035, 0 )
            EXIT FOREACH
         END IF
    END FOREACH
    CALL g_gdk.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION chartm_list_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gdk TO s_gdk.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
       CALL cl_show_fld_cont()
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION OUTPUT
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION HELP
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()
 
      ON ACTION EXIT
         LET g_action_choice="exit"
         EXIT DISPLAY
       ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION ACCEPT
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION CANCEL
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DISPLAY
 
      ON ACTION about         
          CALL cl_about()    
 
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION gen_include
         CALL chartm_list_generation()
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION p_chartm_list_info(p_gdk01)
   DEFINE p_gdk01    LIKE gdk_file.gdk01
   DEFINE l_gfp02    LIKE gfp_file.gfp02
   DEFINE l_gfp03    LIKE gfp_file.gfp03
   DEFINE l_name     LIKE gfp_file.gfp04,  #圖表名稱
          l_desc     LIKE gfp_file.gfp04   #圖表說明
          
   EXECUTE chartm_list_gfp USING p_gdk01, g_lang INTO l_name, l_desc
   RETURN l_name, l_desc
END FUNCTION

FUNCTION chartm_list_generation()
   DEFINE l_sb         base.StringBuffer
   DEFINE l_idx        INTEGER
   DEFINE l_path       STRING
   DEFINE l_channel    base.Channel
   DEFINE l_comb_func  STRING
   DEFINE l_tmp        STRING
   DEFINE l_cmd        STRING
   run "id"
   LET l_sb = base.StringBuffer.create()
   CALL l_sb.append("FUNCTION cl_udm_chart(p_chart_id, p_argv1, p_argv2, p_wc) \n")
   CALL l_sb.append("   DEFINE p_chart_id   STRING #圖表代號 \n")
   CALL l_sb.append("   DEFINE p_argv1      STRING #條件1 \n")
   CALL l_sb.append("   DEFINE p_argv2      STRING #條件2 \n")
   CALL l_sb.append("   DEFINE p_wc         STRING #Web Component \n")
#   CALL l_sb.append("   DEFINE l_gdk02      STRING #篩選條件的ComboBox名稱 \n")
#   CALL l_sb.append("   DEFINE l_gdk03      STRING #篩選條件的ComboBox名稱 \n")
#   CALL l_sb.append("   LET l_gdk02 = \"formonly.\", p_wc, \"_combo\" \n")
#   CALL l_sb.append("   LET l_gdk03 = \"formonly.\", p_wc, \"_combo\" \n")
   CALL l_sb.append("   IF cl_null(p_chart_id) THEN LET p_chart_id = \"\" END IF \n")
   CALL l_sb.append("   CASE p_chart_id \n")
   CALL l_sb.append("      WHEN \"\" \n")
   
   FOR l_idx = 1 TO g_gdk.getLength()
      CALL l_sb.append("      WHEN \"" || g_gdk[l_idx].gdk01 || "\"   \n")
      CALL l_sb.append("         CALL " || g_gdk[l_idx].gdk01 || "(p_argv1, p_argv2, p_wc) \n")
   END FOR

#   CALL l_sb.append("      OTHERWISE \n")
#   CALL l_sb.append("         DISPLAY \"找不到圖表代碼:\", p_chart_id \n")
   CALL l_sb.append("   END CASE  \n")
   CALL l_sb.append("END FUNCTION \n")

   #產生下拉選單的function
   CALL l_sb.append("FUNCTION cl_chart_set_combo_items(p_wc, p_chart_id, p_v1, p_v2) \n")
   CALL l_sb.append("   DEFINE p_chart_id   STRING #圖表代號 \n")
   CALL l_sb.append("   DEFINE p_v1         STRING \n")
   CALL l_sb.append("   DEFINE p_v2         STRING \n")
   CALL l_sb.append("   DEFINE p_wc         STRING #Web Component \n")
   CALL l_sb.append("   DEFINE l_comb       STRING #篩選條件的ComboBox名稱 \n")
#   CALL l_sb.append("   DEFINE l_gdk03      STRING #篩選條件的ComboBox名稱 \n")
   CALL l_sb.append("   DEFINE l_r1, l_r2   STRING #設定ComboBox後的預設值 \n")
   CALL l_sb.append("   LET l_comb = p_wc, \"_combo\" \n")
   CALL l_sb.append("   IF cl_null(p_chart_id) THEN LET p_chart_id = \"\" END IF \n")
   CALL l_sb.append("   CASE p_chart_id \n")
   CALL l_sb.append("      WHEN \"\" \n")
   
   FOR l_idx = 1 TO g_gdk.getLength()
   LET l_tmp = g_gdk[l_idx].gdk01
   LET l_tmp = l_tmp.subString(l_tmp.getLength()-1, l_tmp.getLength())
   IF l_tmp == "_d" THEN
      LET l_tmp = g_gdk[l_idx].gdk01
      LET l_comb_func = l_tmp.subString(1, l_tmp.getLength()-2)
   ELSE
      LET l_comb_func = g_gdk[l_idx].gdk01
   END IF
   CALL l_sb.append("      WHEN \"" || g_gdk[l_idx].gdk01 || "\"   \n")
   CALL l_sb.append("         CALL " || l_comb_func || "_set_combo(l_comb, p_v1, p_v2) RETURNING l_r1, l_r2\n")
   END FOR

#   CALL l_sb.append("      OTHERWISE \n")
#   CALL l_sb.append("         DISPLAY \"找不到圖表代碼:\", p_chart_id \n")
   CALL l_sb.append("   END CASE  \n")
   CALL l_sb.append("   RETURN l_r1, l_r2 \n")
   CALL l_sb.append("END FUNCTION")

   LET l_path = os.Path.join(FGL_GETENV("TOP"), "config")
   LET l_path = os.path.join(l_path, "include")
   LET l_path = os.path.join(l_path, "cl_chart_marco_when.4gl")
   CALL cl_null_cat_to_file(l_path)
   LET l_channel = base.Channel.create()
   CALL l_channel.setDelimiter(NULL)
   CALL l_channel.openFile(l_path, "a")
   CALL l_channel.write(l_sb.toString())
   CALL l_channel.close();
   #IF os.Path.chrwx(l_path, ((6*64)+(6*8)+6) ) THEN
      LET l_cmd = "cd $TOP/lib/4gl; r.c2 cl_chart; r.l2 lib; cd $TOP/azz/4gl; r.l2 udm_tree;"
      RUN l_cmd
   #END IF
END FUNCTION


