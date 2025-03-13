# Prog. Version..: '5.30.06-13.04.22(00002)'     #
#
# Pattern name...: aooi104.4gl
# Descriptions...: 量化規格 
# Date & Author..: NO.FUN-B30092 11/06/13 By Polly
# Modify.........: No.CHI-BB0048 12/02/07 By jt_chen 刪除時增加寫入azo_file紀錄異動
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"

# NO.FUN-B30092 
DEFINE 
    g_gfo           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        gfo01       LIKE gfo_file.gfo01,   #量化單位
        gfo02       LIKE gfo_file.gfo02,   #說明
        gfoacti     LIKE gfo_file.gfoacti  #資料有效碼 
                    END RECORD,
    g_gfo_t         RECORD                 #程式變數 (舊值)
        gfo01       LIKE gfo_file.gfo01,   #量化單位
        gfo02       LIKE gfo_file.gfo02,   #說明
        gfoacti     LIKE gfo_file.gfoacti  #資料有效碼 
                    END RECORD,
    g_wc,g_sql     STRING,
    g_rec_b         LIKE type_file.num5,                #單身的總筆數；單身筆數  #No.FUN-680102 SMALLINT
    l_ac            LIKE type_file.num5                 #單身目前的指標；目前處理的ARRAY CNT  #No.FUN-680102 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   LIKE type_file.num5 
DEFINE g_cnt           LIKE type_file.num10 
DEFINE g_i             LIKE type_file.num5  
DEFINE g_str        STRING                
DEFINE g_msg           LIKE type_file.chr1000          #CHI-BB0048

MAIN

DEFINE p_row,p_col   LIKE type_file.num5    
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN                 #抓取部份參數
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log      #記錄log檔
  
   IF (NOT cl_setup("AOO")) THEN           #抓取權限共用變數及模組變數 
      EXIT PROGRAM
   END IF
 
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time   #計算使用時間(進入時間)
             
   LET p_row = 5 LET p_col = 29
   OPEN WINDOW i104_w AT p_row,p_col WITH FORM "aoo/42f/aooi104"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
   CALL cl_ui_init()  #轉換介面語言別、匯入ToolBar、Action …等資訊
 
   LET g_wc = '1=1'
   CALL i104_b_fill(g_wc)  #抓取單身資料

   CALL i104_menu()        #進入主視窗畫面
   CLOSE WINDOW i104_w                 #結束畫面
   CALL  cl_used(g_prog,g_time,2)  RETURNING g_time      #計算使用時間(退出使間) 
         
END MAIN

FUNCTION i104_menu()
 
   WHILE TRUE
      CALL i104_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i104_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i104_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i104_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() AND l_ac != 0 THEN 
               IF g_gfo[l_ac].gfo01 IS NOT NULL THEN
                  LET g_doc.column1 = "gfo01"
                  LET g_doc.value1 = g_gfo[l_ac].gfo01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"    #轉出excel
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gfo),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION

FUNCTION i104_b_fill(p_wc2)              #抓取單身資料
DEFINE
    p_wc2           LIKE type_file.chr1000 
 
    LET g_sql =
        "SELECT gfo01,gfo02,gfoacti",
        " FROM gfo_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i104_pb FROM g_sql
    DECLARE gfo_curs CURSOR FOR i104_pb
 
    CALL g_gfo.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH gfo_curs INTO g_gfo[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN      #最大單身筆數限制
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_gfo.deleteElement(g_cnt)    #刪除最後新增的空白而
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION

FUNCTION i104_q()
   CALL i104_b_askkey()
END FUNCTION

FUNCTION i104_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                 #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,                 #檢查重複用
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否
    p_cmd           LIKE type_file.chr1,                 #處理狀態  
    l_allow_insert  LIKE type_file.chr1,                 #可新增否
    l_allow_delete  LIKE type_file.chr1,                 #可刪除否
    l_azo06         LIKE azo_file.azo06                  #CHI-BB0048
 
    IF s_shut(0) THEN RETURN END IF  #是否可進入單身
    CALL cl_opmsg('b')               #顯示單身功能的操作說明
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')  #單身insert權限
    LET l_allow_delete = cl_detail_input_auth('delete')  #單身delete權限
 
    LET g_forupd_sql = "SELECT gfo01,gfo02,gfoacti FROM gfo_file", 
                       " WHERE gfo01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i104_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_gfo WITHOUT DEFAULTS FROM s_gfo.*       #設定使用者輸入資料
      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED, # 設定新增、刪除的權限
                 INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
        BEFORE INPUT                        # 指定進入單身後跳至第幾筆
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            IF g_rec_b>=l_ac THEN          #當總筆數大於目前指標時，代表對已有資料做更改
               BEGIN WORK
               LET p_cmd='u'
                                                         
               LET g_before_input_done = FALSE                                  
               CALL i104_set_entry(p_cmd)                                       
               CALL i104_set_no_entry(p_cmd)                                    
               LET g_before_input_done = TRUE                                   
  
               LET g_gfo_t.* = g_gfo[l_ac].*  #BACKUP
               OPEN i104_bcl USING g_gfo_t.gfo01    #鎖住單身
               IF STATUS THEN
                  CALL cl_err("OPEN i104_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE 
                  FETCH i104_bcl INTO g_gfo[l_ac].*  #鎖住單筆單身資料 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_gfo_t.gfo01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont() 
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
                                                         
            LET g_before_input_done = FALSE                                     
            CALL i104_set_entry(p_cmd)                                          
            CALL i104_set_no_entry(p_cmd)                                       
            LET g_before_input_done = TRUE                                      
     
            INITIALIZE g_gfo[l_ac].* TO NULL              
                       
            LET g_gfo[l_ac].gfoacti = 'Y'       #Body default
            LET g_gfo_t.* = g_gfo[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()    
            NEXT FIELD gfo01
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i104_bcl
              CANCEL INSERT                  #按下中斷鍵時，離開新增階段
           END IF
 
           BEGIN WORK                    
 
           INSERT INTO gfo_file(gfo01,gfo02,gfoacti,gfouser,gfodate,gfooriu,gfoorig)  
                         VALUES(g_gfo[l_ac].gfo01,g_gfo[l_ac].gfo02,
                                g_gfo[l_ac].gfoacti,g_user,g_today, g_user, g_grup)  
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","gfo_file",g_gfo[l_ac].gfo01,"",SQLCA.sqlcode,"","",1)  
              ROLLBACK WORK             
              CANCEL INSERT
           ELSE
              ##FUN-680010
              #MESSAGE 'INSERT O.K'
              #LET g_rec_b=g_rec_b+1
              #DISPLAY g_rec_b TO FORMONLY.cn2  
           
              # CALL aws_spccli_base()
              # 傳入參數: (1)TABLE名稱, (2)新增資料,
              #           (3)功能選項：insert(新增),update(修改),delete(刪除)
              CASE aws_spccli_base('gfo_file',base.TypeInfo.create(g_gfo[l_ac]),'insert')    
                 WHEN 0  #無與 SPC 整合
                      MESSAGE 'INSERT O.K'
                      LET g_rec_b=g_rec_b+1
                      DISPLAY g_rec_b TO FORMONLY.cn2  
                 WHEN 1  #呼叫 SPC 成功
                      MESSAGE 'INSERT O.K, INSERT SPC O.K'
                      LET g_rec_b=g_rec_b+1
                      DISPLAY g_rec_b TO FORMONLY.cn2  
                 WHEN 2  #呼叫 SPC 失敗
                      ROLLBACK WORK
                      CANCEL INSERT
              END CASE
              COMMIT WORK
              ##FUN-680010 
           END IF
 
        AFTER FIELD gfo01                        #check 編號是否重複
            IF g_gfo[l_ac].gfo01 != g_gfo_t.gfo01 OR
               (g_gfo[l_ac].gfo01 IS NOT NULL AND g_gfo_t.gfo01 IS NULL) THEN
                SELECT count(*) INTO l_n FROM gfo_file
                    WHERE gfo01 = g_gfo[l_ac].gfo01
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_gfo[l_ac].gfo01 = g_gfo_t.gfo01
                  NEXT FIELD gfo01
               END IF
            END IF
 

        AFTER FIELD gfoacti
            IF NOT cl_null(g_gfo[l_ac].gfoacti) THEN
               IF g_gfo[l_ac].gfoacti NOT MATCHES '[YN]' THEN 
                  LET g_gfo[l_ac].gfoacti = g_gfo_t.gfoacti
                  NEXT FIELD gfoacti
               END IF 
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_gfo_t.gfo01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   ROLLBACK WORK 
                   CANCEL DELETE
                END IF

                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   ROLLBACK WORK    
                   CANCEL DELETE 
                END IF 
                DELETE FROM gfo_file WHERE gfo01 = g_gfo_t.gfo01
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","gfo_file",g_gfo_t.gfo01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                    ROLLBACK WORK      #FUN-680010
                    EXIT INPUT
                END IF
                #CHI-BB0048 -- add start --
                LET g_msg = TIME
                LET l_azo06 = 'delete'
                INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)
                  VALUES ('aooi104',g_user,g_today,g_msg,g_gfo_t.gfo01,l_azo06,g_plant,g_legal)
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("ins","azo_file","aooi104","",SQLCA.sqlcode,"","",1)
                   ROLLBACK WORK
                   EXIT INPUT
                END IF
                #CHI-BB0048 -- add end --
                #FUN-680010 
                #LET g_rec_b=g_rec_b-1
                #DISPLAY g_rec_b TO FORMONLY.cn2  
                #COMMIT WORK
                
                # CALL aws_spccli_base()
                # 傳入參數: (1)TABLE名稱, (2)刪除資料,
                #           (3)功能選項：insert(新增),update(修改),delete(刪除)
                CASE aws_spccli_base('gfo_file',base.TypeInfo.create(g_gfo[l_ac]),'delete')   
                   WHEN 0  #無與 SPC 整合
                        LET g_rec_b=g_rec_b-1
                        DISPLAY g_rec_b TO FORMONLY.cn2  
                        COMMIT WORK
                   WHEN 1  #呼叫 SPC 成功
                        LET g_rec_b=g_rec_b-1
                        DISPLAY g_rec_b TO FORMONLY.cn2  
                        COMMIT WORK
                   WHEN 2  #呼叫 SPC 失敗
                        ROLLBACK WORK  
                        CANCEL DELETE
                END CASE
                #END FUN-680010 
 
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_gfo[l_ac].* = g_gfo_t.*
              CLOSE i104_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err(g_gfo[l_ac].gfo01,-263,0)
               LET g_gfo[l_ac].* = g_gfo_t.*
           ELSE
               UPDATE gfo_file SET gfo01=g_gfo[l_ac].gfo01,
                                   gfo02=g_gfo[l_ac].gfo02,
                                   gfoacti=g_gfo[l_ac].gfoacti
                WHERE gfo01 = g_gfo_t.gfo01
               IF SQLCA.sqlcode THEN

                  CALL cl_err3("upd","gfo_file",g_gfo_t.gfo01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                  ROLLBACK WORK     
                  LET g_gfo[l_ac].* = g_gfo_t.*
               ELSE
                  #FUN-680010 
                  #MESSAGE 'UPDATE O.K'
                  #COMMIT WORK
                  
                  # CALL aws_spccli_base()
                  # 傳入參數: (1)TABLE名稱, (2)修改資料,
                  #           (3)功能選項：insert(新增),update(修改),delete(刪除)
                  CASE aws_spccli_base('gfo_file',base.TypeInfo.create(g_gfo[l_ac]),'update')    
                     WHEN 0  #無與 SPC 整合
                          MESSAGE 'UPDATE O.K'
                          COMMIT WORK
                     WHEN 1  #呼叫 SPC 成功
                          MESSAGE 'UPDATE O.K. UPDATE SPC O.K'
                          COMMIT WORK
                     WHEN 2  #呼叫 SPC 失敗
                          ROLLBACK WORK  
                          LET g_gfo[l_ac].* = g_gfo_t.*
                  END CASE
                  #END FUN-680010 
               END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()         
          #LET l_ac_t = l_ac        #FUN-D40030 Mark          
 
           IF INT_FLAG THEN                 
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_gfo[l_ac].* = g_gfo_t.*
              #FUN-D40030--add--str--
              ELSE
                 CALL g_gfo.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D40030--add--end--
              END IF
              CLOSE i104_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac        #FUN-D40030 Add
           CLOSE i104_bcl
           COMMIT WORK
 
       
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(gfo01) AND l_ac > 1 THEN
                LET g_gfo[l_ac].* = g_gfo[l_ac-1].*
                NEXT FIELD gfo01
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
              CONTINUE INPUT
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION help        
           CALL cl_show_help()
 
        
        END INPUT
 
    CLOSE i104_bcl
    COMMIT WORK
 
END FUNCTION

FUNCTION i104_out()
  DEFINE
        l_gfo           RECORD LIKE gfo_file.*,
        l_i             LIKE type_file.num5,    
        l_name          LIKE type_file.chr20,      
        l_za05          LIKE type_file.chr1000      
   
    IF g_wc IS NULL THEN 
       CALL cl_err('','9057',0)
    RETURN END IF
    LET g_str=''                                          
    SELECT  zz05 INTO g_zz05 FROM zz_file  WHERE zz01=g_prog  
    CALL cl_wait()

    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM gfo_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED
    PREPARE i104_p1 FROM g_sql                    # RUNTIME 編譯
    DECLARE i104_co                               # SCROLL CURSOR
         CURSOR FOR i104_p1
 
 
    FOREACH i104_co INTO l_gfo.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)    
            EXIT FOREACH
            END IF
       
    END FOREACH
 
    CLOSE i104_co
    ERROR ""
    
    IF g_zz05='Y' THEN                                     
       CALL cl_wcchp(g_wc,'gfo01,gfo02,gfoacti')
       RETURNING g_wc                                      
    END IF                                                
    LET g_str=g_wc                                          
    CALL cl_prt_cs1("aooi104","aooi104",g_sql,g_str)       
END FUNCTION

FUNCTION i104_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gfo TO s_gfo.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                  
 
      ON ACTION query                 #查詢
         LET g_action_choice="query"
         EXIT DISPLAY

     ON ACTION detail                 #單身
         LET g_action_choice="detail"
         LET l_ac = 1
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION output                 #列印
         LET g_action_choice="output"
         EXIT DISPLAY

      ON ACTION help                   #幫助
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale                 #語言
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()               
 
      ON ACTION exit                   #離開
         LET g_action_choice="exit"
         EXIT DISPLAY
      
      ON ACTION controlg               #開窗查詢
         LET g_action_choice="controlg"
         EXIT DISPLAY
  
      ON ACTION accept                 #確定更新
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel                 #取消
             LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION related_document       #相關文件
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel          #轉Excel檔
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
       ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about                   #程式資訊   
         CALL cl_about()      
 
      AFTER DISPLAY
         CONTINUE DISPLAY
     
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i104_b_askkey()
    CLEAR FORM
    CALL g_gfo.clear()
    CONSTRUCT g_wc ON gfo01,gfo02,gfoacti
            FROM s_gfo[1].gfo01,s_gfo[1].gfo02,s_gfo[1].gfoacti
            
    BEFORE CONSTRUCT
       CALL cl_qbe_init()
            
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
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

    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('gfouser', 'gfogrup') 

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      RETURN
   END IF

    CALL i104_b_fill(g_wc)
END FUNCTION
 

                                                          
FUNCTION i104_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1        
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("gfo01",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i104_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1        
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("gfo01",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
