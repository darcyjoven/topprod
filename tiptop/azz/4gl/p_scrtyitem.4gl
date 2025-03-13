# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: p_scrtyitem.4gl
# Descriptions...: 員工資料
# Date & Author..: 11/12/20 By jrg542
# Modify.........: No.FUN-BC0056 11/12/20 By jrg542 部分隱藏樣式設定作業
# Modify.........: No.FUN-C20060 11/12/20 By jrg542 調整 p_scrtyitem 新增 gdu07 關聯 gdz01 遮罩類型
# Modify.........: No:FUN-D30034 13/04/18 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_gdu           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        gdu01       LIKE gdu_file.gdu01,   #個資顯示PatternID
        gdu02       LIKE gdu_file.gdu02,   #個資Pattern說明
        gdu03       LIKE gdu_file.gdu03,   #遮罩中間字串, 顯示頭尾各 N字
        gdu04       LIKE gdu_file.gdu04,   #從前方起算第N字 (非字元) 起遮罩
        gdu05       LIKE gdu_file.gdu05,   #從後方起算第N字 (非字元) 起遮罩
        gdu06       LIKE gdu_file.gdu06,   #從指定的英數字 (非字元) 遮罩
        gdu07       LIKE gdu_file.gdu07    #個資欄位種類ID # FUN-C20060
                    END RECORD,
    g_gdu_t         RECORD  
        gdu01       LIKE gdu_file.gdu01,   #個資顯示PatternID
        gdu02       LIKE gdu_file.gdu02,   #個資Pattern說明
        gdu03       LIKE gdu_file.gdu03,   #遮罩中間字串, 顯示頭尾各 N字
        gdu04       LIKE gdu_file.gdu04,   #從前方起算第N字 (非字元) 起遮罩
        gdu05       LIKE gdu_file.gdu05,   #從後方起算第N字 (非字元) 起遮罩
        gdu06       LIKE gdu_file.gdu06,   #從指定的英數字 (非字元) 遮罩
        gdu07       LIKE gdu_file.gdu07    #個資欄位種類ID # FUN-C20060
                    END RECORD,
    g_wc2           STRING,
    g_sql           STRING,
    g_cmd           LIKE type_file.chr1000, 
    g_rec_b         LIKE type_file.num5,                #單身筆數 
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT 


  
DEFINE g_forupd_sql STRING     #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10     
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_i          LIKE type_file.num5       #count/index for any purpose  
DEFINE g_on_change  LIKE type_file.num5       #No.FUN-680102 SMALLINT  
DEFINE g_row_count  LIKE type_file.num5       #No.TQC-680158 add
DEFINE g_curs_index LIKE type_file.num5       #No.TQC-680158 add
DEFINE g_str        STRING                    #No.FUN-760083     

#12/02/09
DEFINE g_gdz01           STRING # FUN-C20060
DEFINE g_gdz02           STRING # FUN-C20060

MAIN

   DEFINE l_gdz01       LIKE gdz_file.gdz01  # FUN-C20060
   DEFINE l_gdz02       LIKE gdz_file.gdz02  # FUN-C20060

   OPTIONS                                    #改變一些系統預設值
       INPUT NO WRAP
   DEFER INTERRUPT                            #擷取中斷鍵, 由程式處理
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   OPEN WINDOW p_scrtyitem_w WITH FORM "azz/42f/p_scrtyitem"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()

    # FUN-C20060 --start--
    DECLARE p_perscrty_gdz01_cur CURSOR FOR 
     SELECT gdz01,gdz02 FROM gdz_file 
             ORDER BY gdz01
    FOREACH p_perscrty_gdz01_cur INTO l_gdz01,l_gdz02
      IF cl_null(g_gdz01) AND  cl_null(g_gdz02) THEN
         LET g_gdz01 = l_gdz01
         LET g_gdz02 = l_gdz02
         
      ELSE
         LET g_gdz01 = g_gdz01 CLIPPED,",",l_gdz01 CLIPPED
         LET g_gdz02 = g_gdz02 CLIPPED,",",l_gdz02 CLIPPED
      END IF
    END FOREACH
                            #ps_field_name, ps_values, ps_items 
    CALL cl_set_combo_items("gdu07",g_gdz01,g_gdz02) #combobox

   # FUN-C20060 --end--  

   LET g_wc2 = '1=1'
   CALL p_scrtyitem_b_fill(g_wc2)
 
   CALL p_scrtyitem_menu()
   CLOSE WINDOW p_scrtyitem_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p_scrtyitem_menu()
 
   WHILE TRUE
      CALL p_scrtyitem_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL p_scrtyitem_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL p_scrtyitem_b()
            ELSE
               LET g_action_choice = NULL
            END IF

         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gdu),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_scrtyitem_q()
   CALL p_scrtyitem_b_askkey()
END FUNCTION
 
FUNCTION p_scrtyitem_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                 #未取消的ARRAY CNT     
    l_n             LIKE type_file.num5,                 #檢查重複用          
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       
    p_cmd           LIKE type_file.chr1,                 #處理狀態       
    l_allow_insert  LIKE type_file.chr1,                 #增否
    l_allow_delete  LIKE type_file.chr1,                 #可刪除否
    v               STRING

    DEFINE l_msg STRING 
 
    IF s_shut(0) THEN RETURN END IF
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT gdu01,gdu02,gdu03,gdu04,gdu05,gdu06,gdu07 ",  # FUN-C20060
                       "  FROM gdu_file WHERE gdu01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p_scrtyitem_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_gdu WITHOUT DEFAULTS FROM s_gdu.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF
 
    BEFORE ROW
        LET p_cmd='' 
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT
        LET l_n  = ARR_COUNT()
        LET g_on_change = TRUE         #FUN-550077
 
        IF g_rec_b>=l_ac THEN
           BEGIN WORK
           LET p_cmd='u'
           LET g_before_input_done = FALSE                                      
           CALL p_scrtyitem_set_entry(p_cmd)                                           
           CALL p_scrtyitem_set_no_entry(p_cmd)                                        
           LET g_before_input_done = TRUE                                       
           LET g_gdu_t.* = g_gdu[l_ac].*  #BACKUP
           OPEN p_scrtyitem_bcl USING g_gdu_t.gdu01
           IF STATUS THEN
              CALL cl_err("OPEN p_scrtyitem_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH p_scrtyitem_bcl INTO g_gdu[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_gdu_t.gdu01,SQLCA.sqlcode,1)   #100:找不到
                 LET l_lock_sw = "Y"
              END IF
           END IF
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           CALL p_scrtyitem_example(g_lang) RETURNING l_msg
           DISPLAY l_msg TO ex
        END IF
 
     BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         LET g_before_input_done = FALSE                                        
         CALL p_scrtyitem_set_entry(p_cmd)                                             
         CALL p_scrtyitem_set_no_entry(p_cmd)                                          
         LET g_before_input_done = TRUE                                         
         INITIALIZE g_gdu[l_ac].* TO NULL      #900423
         LET g_gdu_t.* = g_gdu[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD gdu01
 
     AFTER INSERT
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE p_scrtyitem_bcl
           CANCEL INSERT
        END IF
 
        BEGIN WORK                    #FUN-680010
 
        INSERT INTO gdu_file(gdu01,gdu02,gdu03,gdu04,gdu05,gdu06,gdu07 )   # FUN-C20060  
               VALUES(g_gdu[l_ac].gdu01,g_gdu[l_ac].gdu02,
               g_gdu[l_ac].gdu03,g_gdu[l_ac].gdu04,        
               g_gdu[l_ac].gdu05,g_gdu[l_ac].gdu06,g_gdu[l_ac].gdu07)      # FUN-C20060
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","gdu_file",g_gdu[l_ac].gdu01,"",SQLCA.sqlcode,"","",1)
           ROLLBACK WORK        
           CANCEL INSERT
        ELSE
        LET g_rec_b=g_rec_b+1
        END IF
 
     AFTER FIELD gdu01                        #check 編號是否重複
        IF NOT cl_null(g_gdu[l_ac].gdu01) THEN
           IF g_gdu[l_ac].gdu01 != g_gdu_t.gdu01 OR
              g_gdu_t.gdu01 IS NULL THEN
              SELECT count(*) INTO l_n FROM gdu_file
               WHERE gdu01 = g_gdu[l_ac].gdu01
              IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_gdu[l_ac].gdu01 = g_gdu_t.gdu01
                  NEXT FIELD gdu01
              END IF
           END IF
        END IF

     AFTER FIELD gdu03                     
        IF NOT cl_null(g_gdu[l_ac].gdu03) THEN
           #IF g_gdu[l_ac].gdu03 != g_gdu_t.gdu03 OR
           #   g_gdu_t.gdu03 IS NULL THEN
              IF NOT cl_null(g_gdu[l_ac].gdu04) OR NOT cl_null(g_gdu[l_ac].gdu05) OR 
                 NOT cl_null(g_gdu[l_ac].gdu06) THEN 

                 CALL cl_err(g_gdu[l_ac].gdu03,'azz1181',1)  #同一項目只能設定一項
                 NEXT FIELD gdu03
              END IF    
           #END IF
        END IF

     AFTER FIELD gdu04                        
        IF NOT cl_null(g_gdu[l_ac].gdu04) THEN
              IF NOT cl_null(g_gdu[l_ac].gdu03) OR NOT cl_null(g_gdu[l_ac].gdu05) OR 
                 NOT cl_null(g_gdu[l_ac].gdu06) THEN 

                 CALL cl_err(g_gdu[l_ac].gdu04,'azz1181',1)  #同一項目只能設定一項
                 NEXT FIELD gdu04
              END IF              
        END IF    

     AFTER FIELD gdu05                     
        IF NOT cl_null(g_gdu[l_ac].gdu05) THEN
              IF NOT cl_null(g_gdu[l_ac].gdu03) OR NOT cl_null(g_gdu[l_ac].gdu04) OR 
                 NOT cl_null(g_gdu[l_ac].gdu06) THEN 

                 CALL cl_err(g_gdu[l_ac].gdu05,'azz1181',1)  #同一項目只能設定一項
                 NEXT FIELD gdu05 
              END IF
        END IF  

     AFTER FIELD gdu06                        
        IF NOT cl_null(g_gdu[l_ac].gdu06) THEN

              IF NOT cl_null(g_gdu[l_ac].gdu03) OR NOT cl_null(g_gdu[l_ac].gdu04) OR 
                 NOT cl_null(g_gdu[l_ac].gdu05) THEN 

                 CALL cl_err(g_gdu[l_ac].gdu06,'azz1181',1)  #同一項目只能設定一項
                 NEXT FIELD gdu06
              END IF
        END IF   
        
     BEFORE DELETE                            #是否取消單身
         IF g_gdu_t.gdu01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               ROLLBACK WORK      #FUN-680010
               CANCEL DELETE
            END IF
            #檢查gdv_file 是否有資料
            IF p_scrtyitem_chk_before_delete(g_gdu_t.gdu01) THEN
               CALL cl_err(g_gdu_t.gdu01,'azz1182',1)     
               ROLLBACK WORK
               CANCEL DELETE               
            ELSE 
               DELETE FROM gdu_file WHERE gdu01 = g_gdu_t.gdu01
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","gdu_file",g_gdu_t.gdu01,"",SQLCA.sqlcode,"","",1)
                  ROLLBACK WORK     
                  CANCEL DELETE
                  EXIT INPUT
               END IF
               LET g_rec_b = g_rec_b - 1
            END IF 
         END IF
 
     ON ROW CHANGE
        IF INT_FLAG THEN                 #新增程式段
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          LET g_gdu[l_ac].* = g_gdu_t.*
          CLOSE p_scrtyitem_bcl
          ROLLBACK WORK
          EXIT INPUT
        END IF
        IF l_lock_sw="Y" THEN
           CALL cl_err(g_gdu[l_ac].gdu01,-263,0)
           LET g_gdu[l_ac].* = g_gdu_t.*
        ELSE
           UPDATE gdu_file SET gdu01=g_gdu[l_ac].gdu01,
                               gdu02=g_gdu[l_ac].gdu02,
                               gdu03=g_gdu[l_ac].gdu03,
                               gdu04=g_gdu[l_ac].gdu04,
                               gdu05=g_gdu[l_ac].gdu05,
                               gdu06=g_gdu[l_ac].gdu06,
                               gdu07=g_gdu[l_ac].gdu07    # FUN-C20060
           WHERE gdu01 = g_gdu_t.gdu01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","gdu_file",g_gdu_t.gdu01,"",SQLCA.sqlcode,"","",1) 
              ROLLBACK WORK   
              LET g_gdu[l_ac].* = g_gdu_t.*
            ELSE 
              MESSAGE 'UPDATE O.K'
              COMMIT WORK
           END IF
        END IF
 
     AFTER ROW
        LET l_ac = ARR_CURR()            # 新增
        #LET l_ac_t = l_ac               # 新增  #FUN-D30034
 
        IF INT_FLAG THEN                 #900423
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           IF p_cmd='u' THEN
              LET g_gdu[l_ac].* = g_gdu_t.*
           #FUN-D30034--add--str--
           ELSE
              CALL g_gdu.deleteElement(l_ac)
              IF g_rec_b != 0 THEN
                 LET g_action_choice = "detail"
                 LET l_ac = l_ac_t
              END IF
           #FUN-D30034--add--end--
           END IF
           CLOSE p_scrtyitem_bcl                # 新增
           ROLLBACK WORK                 # 新增
           EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30034
         CLOSE p_scrtyitem_bcl                # 新增
         COMMIT WORK
 
     ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(gdu01) AND l_ac > 1 THEN
             LET g_gdu[l_ac].* = g_gdu[l_ac-1].*
             NEXT FIELD gdu01
         END IF
 
       ON ACTION controlp
           CASE 
             WHEN INFIELD(gdu03)
                OTHERWISE
                     EXIT CASE
            END CASE
 
     ON ACTION CONTROLR
        CALL cl_show_req_fields()
 
     ON ACTION CONTROLG
        CALL cl_cmdask()
 
     ON ACTION CONTROLF
        CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
        CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
    END INPUT
 
    CLOSE p_scrtyitem_bcl
    COMMIT WORK
END FUNCTION

 
FUNCTION p_scrtyitem_b_askkey()
    CLEAR FORM
    CALL g_gdu.clear()
 
    CONSTRUCT g_wc2 ON gdu01,gdu02,gdu03,gdu04,gdu05,gdu06,gdu07           # FUN-C20060
         FROM s_gdu[1].gdu01,s_gdu[1].gdu02,s_gdu[1].gdu03,
              s_gdu[1].gdu04,s_gdu[1].gdu05,s_gdu[1].gdu06,s_gdu[1].gdu07  # FUN-C20060
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE WHEN INFIELD(gdu03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  = "q_gem"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO s_gdu[1].gdu03

              OTHERWISE
                   EXIT CASE
         END CASE
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()

    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('genuser', 'gengrup') #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
 
   CALL p_scrtyitem_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION p_scrtyitem_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2           STRING
 
    LET g_sql = "SELECT gdu01,gdu02,gdu03,gdu04,gdu05,gdu06,gdu07 ",    # FUN-C20060
                 " FROM gdu_file ",
                " WHERE ", p_wc2 CLIPPED,           #單身
                " ORDER BY 1" 
 
    PREPARE p_scrtyitem_pb FROM g_sql
    DECLARE p_scrtyitem_gdu_curs CURSOR FOR p_scrtyitem_pb
 
    CALL g_gdu.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH p_scrtyitem_gdu_curs INTO g_gdu[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH

    CALL g_gdu.deleteElement(g_cnt)

    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION p_scrtyitem_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
   DEFINE l_msg STRING  
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gdu TO s_gdu.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_gdu_t.* = g_gdu[l_ac].*  #BACKUP
         CALL p_scrtyitem_example(g_lang) RETURNING l_msg
         DISPLAY l_msg TO ex
         
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p_scrtyitem_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("gdu01",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION p_scrtyitem_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680102 VARCHAR(1)
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("gdu01",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION                                                                    

#刪除前檢查 No.FUN-BC0056
FUNCTION p_scrtyitem_chk_before_delete(p_gdv)

    DEFINE p_gdv  LIKE    gdv_file.gdv01
    DEFINE l_cnt  LIKE    type_file.num5           
      
    SELECT count(*) INTO l_cnt FROM gdv_file
       WHERE gdv05 = p_gdv 

    IF l_cnt > 0 THEN
       RETURN TRUE    
    END IF
      
   RETURN FALSE
END FUNCTION

#範例字串 No.FUN-BC0056
FUNCTION p_scrtyitem_example(p_lang)
   DEFINE p_lang        LIKE type_file.chr1        #CHAR(1)
   DEFINE l_ze031       LIKE ze_file.ze03
   DEFINE l_ze032       LIKE ze_file.ze03
   DEFINE l_ze033       LIKE ze_file.ze03
   
   DEFINE l_example     STRING 
   DEFINE ls_nodenew    STRING
 
   SELECT ze03 INTO l_ze031 FROM ze_file
    WHERE ze01 = "azz1183"   #範例字串:
      AND ze02 = p_lang

   SELECT ze03 INTO l_ze032 FROM ze_file
    WHERE ze01 = "azz1184"   #abcde@fghijklm.nop.qrs.tu
      AND ze02 = p_lang

   SELECT ze03 INTO l_ze033 FROM ze_file
    WHERE ze01 = "azz1185"  #字串為:  
      AND ze02 = p_lang    

   CALL cl_set_data_mask_calc(g_gdu_t.*,l_ze032) RETURNING  ls_nodenew
   LET l_example = l_ze031 CLIPPED, l_ze032 ,"\n",l_ze033 CLIPPED,ls_nodenew CLIPPED
   RETURN l_example
END FUNCTION



