# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: p_keyrelat
# Descriptions...: Key值關聯維護作業 Maintain gau_file
# Date & Author..: 03/12/12 saki  
# Modify.........: 並沒有檢查field有沒有存在所填的table裡面,
#                  因為目前沒有檢查辦法,若zt_file or zq_file or zs_file有改變
#                  做法,必須回來補上檢查
#                  04/11/19 FUN-4B0049 Yuna 加轉excel檔功能
#                  05/04/20 MOD-540140 alex 修正 controlf 語法
# Modify.........: NO.MOD-580056 05/08/05 BY yiting key可更改
# Modify.........: NO.MOD-590329 05/10/04 BY yiting 針對zz13設定，假雙檔程式單身不做控管
# Modify.........: No.FUN-660096 06/06/15 By ice cl_err3訊息修改
# Modify.........: No.FUN-680064 06/10/18 By dxfwo 在新增函數_a()中的單身函數_b()前添加g_rec_b初始化命令 "LET g_rec_b =0" 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A10118 10/01/26 By Kevin 改成雙檔架構
# Modify.........: No.FUN-AC0033 10/12/13 By Kevin 提供多語言的說明欄位
# Modify.........: No.FUN-B20034 11/02/17 By jrg542 p_keyrelat整批副鍵取代功能要加上記錄 gae10
# Modify.........: No.FUN-B50065 11/05/13 BY huangrh BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C30027 12/08/15 By bart 複製後停在新資料畫面
# Modify.........: No:FUN-D30034 13/04/18 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"   
 
DEFINE   g_gbu              RECORD LIKE gbu_file.*        # 單頭
DEFINE   g_gbu_t            RECORD LIKE gbu_file.*        # 單頭舊值
DEFINE   g_gbu01_t          LIKE gbu_file.gbu01           # 單頭舊值
DEFINE   g_gau01            LIKE gau_file.gau01           # 欄位名稱
DEFINE   g_gau01_t          LIKE gau_file.gau01           # 欄位名稱
DEFINE   g_gau02            LIKE gau_file.gau02           # table名稱
DEFINE   g_gau              DYNAMIC ARRAY of RECORD        
            gau03              LIKE gau_file.gau03,
            gaq03              LIKE gaq_file.gaq03,
            gau04              LIKE gau_file.gau04,
            gat03              LIKE gat_file.gat03
                            END RECORD
DEFINE   g_gau_t            RECORD                 # 變數舊值
            gau03              LIKE gau_file.gau03,
            gaq03              LIKE gaq_file.gaq03,
            gau04              LIKE gau_file.gau04,
            gat03              LIKE gat_file.gat03
                            END RECORD 
DEFINE   g_cnt                 LIKE type_file.num10
DEFINE   g_wc                  STRING
DEFINE   g_wc2                 STRING
DEFINE   g_sql                 STRING
DEFINE   g_rec_b               LIKE type_file.num5              # 單身筆數
DEFINE   l_ac                  LIKE type_file.num5               # 目前處理的ARRAY CNT
DEFINE   g_msg                 STRING
DEFINE   g_forupd_sql          STRING
DEFINE   g_before_input_done   LIKE type_file.num5
# gae_file 畫面元件多語言記錄檔
DEFINE   gae_qry            DYNAMIC ARRAY OF RECORD
            check                 LIKE type_file.chr1,
            gae01                 LIKE gae_file.gae01,
            gae02                 LIKE gae_file.gae02,
            gae03                 LIKE gae_file.gae03,
            gae04                 LIKE gae_file.gae04
                            END RECORD
DEFINE  g_row_count         LIKE type_file.num10
DEFINE  g_curs_index        LIKE type_file.num10
DEFINE  g_jump              LIKE type_file.num10
DEFINE  g_no_ask            LIKE type_file.num5
DEFINE  g_gaq               DYNAMIC ARRAY OF RECORD
         gaq01                 LIKE gaq_file.gaq01,
         gaq02                 LIKE gaq_file.gaq02,
         gaq03                 LIKE gaq_file.gaq03
                            END RECORD
MAIN
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                             # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_gau01_t = NULL
 
   OPEN WINDOW p_keyrelat_w WITH FORM "azz/42f/p_keyrelat"
   ATTRIBUTE(STYLE = g_win_style CLIPPED)
   
   CALL cl_ui_init()
 
   LET g_forupd_sql = "SELECT * from gbu_file WHERE gbu01 = ? FOR UPDATE"             #FUN-A10118
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_keyrelat_cl CURSOR FROM g_forupd_sql
   
   CALL p_keyrelat_menu() 
 
   CLOSE WINDOW p_keyrelat_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN


 
FUNCTION p_keyrelat_curs()                       # QBE 查詢資料

   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01        #No.FUN-580031  HCN

   CLEAR FORM                                    # 清除畫面
   CALL g_gau.clear()
   CALL cl_set_head_visible("","YES")
   INITIALIZE g_gbu.* TO NULL 
   
   CONSTRUCT BY NAME g_wc ON gbu01,gbu02,gbu03,gbu04,gbu05   #FUN-A10118 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
                        
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
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
   END CONSTRUCT                
 
   IF INT_FLAG THEN RETURN END IF
 	
   CONSTRUCT g_wc2 ON gau03,gau04 FROM s_gau[1].gau03, s_gau[1].gau04                
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
                        
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
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
   END CONSTRUCT
 
   IF g_wc2 = " 1=1" THEN 
      LET g_sql= "SELECT gbu01 FROM gbu_file ",
              " WHERE ", g_wc CLIPPED,
              " ORDER BY gbu01"
   ELSE                              # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE gbu_file.gbu01 ",
                  "  FROM gbu_file, gau_file ",
                  " WHERE gbu01 = gau01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY gbu01"
   END IF
 
   PREPARE p_keyrelat_prepare FROM g_sql          # 預備一下
   DECLARE p_keyrelat_b_curs                      # 宣告成可捲動的
      SCROLL CURSOR WITH HOLD FOR p_keyrelat_prepare
 
   LET g_sql = "SELECT COUNT(*) FROM gbu_file ",
               " WHERE ",g_wc CLIPPED
 
   PREPARE p_keyrelat_precount FROM g_sql
   DECLARE p_keyrelat_count CURSOR FOR p_keyrelat_precount
END FUNCTION
 
FUNCTION p_keyrelat_menu()
 
   WHILE TRUE
      CALL p_keyrelat_bp("G")
      CASE g_action_choice
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL p_keyrelat_a()
            END IF
         WHEN "reproduce"                       # C.複製
            IF cl_chk_act_auth() THEN
               CALL p_keyrelat_copy()
            END IF
         WHEN "delete"                          # R.取消
            IF cl_chk_act_auth() THEN
               CALL p_keyrelat_r()
            END IF
            
         WHEN "modify"                          # U.修改
            IF cl_chk_act_auth() THEN
               CALL p_keyrelat_u()
            END IF
            
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL p_keyrelat_q()
            ELSE
               LET g_curs_index = 0
            END IF

         WHEN "detail"                          # B.單身 
            IF cl_chk_act_auth() THEN
               CALL p_keyrelat_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"                            # H.求助
            CALL cl_show_help()
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
         WHEN "batch"                           # 整批副鍵敘述替代
            CALL p_keyrelat_batch()
         WHEN "exporttoexcel"     #FUN-4B0049   # 匯出Excel # [e]單身匯出Excel
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gau),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_keyrelat_a()                            # Add  輸入
   MESSAGE ""
   CLEAR FORM
   CALL g_gau.clear()
            
   INITIALIZE g_gbu.* LIKE gbu_file.*              # 預設值及將數值類變數清成零
   
   LET g_gau01_t = NULL
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL p_keyrelat_i("a")                       # 輸入單頭
 
      IF INT_FLAG THEN                            # 使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      
      INSERT INTO gbu_file VALUES (g_gbu.*)       
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
         ROLLBACK WORK      #No:7857
         CALL cl_err3("ins","gbu_file",g_gbu.gbu01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         CONTINUE WHILE
      ELSE
         COMMIT WORK
      END IF
      CALL g_gau.clear()
      LET g_rec_b = 0
      
      CALL p_keyrelat_b()                          # 輸入單身
      LET g_gau01_t=g_gau01
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION p_keyrelat_i(p_cmd)                       # 處理INPUT
   DEFINE   p_cmd        VARCHAR(1)                  # a:輸入 u:更改   
   DEFINE   l_cnt        LIKE type_file.num5
   DEFINE   l_gaq03      LIKE gaq_file.gaq03
   DEFINE   l_gat03      LIKE gat_file.gat03
   DEFINE   l_gaz03      LIKE gaz_file.gaz03
   DEFINE   l_gae04      LIKE gae_file.gae04
    
    INPUT BY NAME g_gbu.gbu01 ,g_gbu.gbu02,g_gbu.gbu03,g_gbu.gbu04,g_gbu.gbu05
    	 WITHOUT DEFAULTS
 
       BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL p_keyrelat_set_entry(p_cmd)
          CALL p_keyrelat_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
      AFTER FIELD gbu01
      	 SELECT COUNT(*) INTO l_cnt FROM gbu_file
      	  WHERE gbu01 = g_gbu.gbu01
      	 
      	 IF p_cmd = 'a'  AND l_cnt > 0 THEN
      	    CALL cl_err(g_gbu.gbu01,-239,0)
      	    NEXT FIELD gbu01
      	 END IF      	 	  
     	
         LET l_gaq03 = p_keyrelat_gaq03(g_gbu.gbu01)
         DISPLAY l_gaq03 TO gaq03
      
      AFTER FIELD gbu02
         LET l_gat03 = p_keyrelat_gat03(g_gbu.gbu02)
         DISPLAY l_gat03 TO gat03

      AFTER FIELD gbu03
         LET l_gaz03 = p_keyrelat_gaz03()
         DISPLAY l_gaz03 TO gaz03

      AFTER FIELD gbu04
         LET l_gae04 = p_keyrelat_gae04()
         DISPLAY l_gae04 TO gae04

      AFTER FIELD gbu05
         LET l_gaq03 = p_keyrelat_gaq03(g_gbu.gbu05)
         DISPLAY l_gaq03 TO gaq03_1
            
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                  #欄位說明
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
 
END FUNCTION
 
FUNCTION p_keyrelat_set_entry(p_cmd)
   DEFINE   p_cmd   VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("gbu01",TRUE)
   END IF
END FUNCTION
 
FUNCTION p_keyrelat_set_no_entry(p_cmd)
   DEFINE   p_cmd   VARCHAR(1)
 
   IF p_cmd = 'u' AND (NOT g_before_input_done) 
     AND g_chkey = 'N' THEN #NO.MOD-580056 
      CALL cl_set_comp_entry("gbu01",FALSE)
   END IF
END FUNCTION

FUNCTION p_keyrelat_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
      
   IF cl_null(g_gbu.gbu01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')   
   LET g_gbu01_t = g_gbu.gbu01
 
   BEGIN WORK
   
   OPEN p_keyrelat_cl USING g_gbu.gbu01
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE p_keyrelat_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH p_keyrelat_cl INTO g_gbu.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("gbu01 LOCK:",SQLCA.sqlcode,1)
      CLOSE p_keyrelat_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   WHILE TRUE
      LET g_gbu_t.* = g_gbu.*
   	  
      CALL p_keyrelat_i("u")
      IF INT_FLAG THEN
         LET g_gbu.* = g_gbu_t.*
         CALL p_keyrelat_show()
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      
      UPDATE gbu_file SET gbu02 = g_gbu.gbu02,
                          gbu03 = g_gbu.gbu03,
                          gbu04 = g_gbu.gbu04,
                          gbu05 = g_gbu.gbu05
       WHERE gbu01 = g_gbu.gbu01
        
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","gbu_file",g_gbu.gbu01,"",SQLCA.sqlcode,"","",0)  
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE p_keyrelat_cl
   COMMIT WORK
END FUNCTION

FUNCTION p_keyrelat_q()                            #Query 查詢
   MESSAGE ""
   CLEAR FROM
   CALL g_gau.clear()
 
   # 2004/01/17 by Hiko : 在沒有權限查詢或是查詢不到資料時,都要將紀錄目前
   #                      cursor變數初始化.
   LET g_curs_index = 0
   LET g_row_count = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   DISPLAY '    ' TO FORMONLY.cnt
   CALL p_keyrelat_curs()                         #取得查詢條件
   IF INT_FLAG THEN                              #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_gbu.* TO NULL
      RETURN
   END IF
   OPEN p_keyrelat_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                         #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_gbu.* TO NULL
   ELSE
      OPEN p_keyrelat_count
      FETCH p_keyrelat_count INTO g_row_count #No.FUN-580092 HCN
      DISPLAY g_row_count TO FORMONLY.cnt #No.FUN-580092 HCN
      
      CALL p_keyrelat_fetch('F')                 #讀出TEMP第一筆並顯示
      
    END IF
END FUNCTION
 
FUNCTION p_keyrelat_fetch(p_flag)                  #處理資料的讀取
   DEFINE   p_flag   VARCHAR(1)                       #處理方式
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     p_keyrelat_b_curs INTO g_gbu.gbu01
      WHEN 'P' FETCH PREVIOUS p_keyrelat_b_curs INTO g_gbu.gbu01
      WHEN 'F' FETCH FIRST    p_keyrelat_b_curs INTO g_gbu.gbu01
      WHEN 'L' FETCH LAST     p_keyrelat_b_curs INTO g_gbu.gbu01
      WHEN '/' 
         IF (NOT g_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump
            IF INT_FLAG THEN
               LET INT_FLAG = FALSE
               RETURN
            END IF
         END IF
         LET g_no_ask = FALSE
         FETCH ABSOLUTE g_jump p_keyrelat_b_curs INTO g_gbu.gbu01
   END CASE 
     
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gbu.gbu01,SQLCA.sqlcode,0)
      INITIALIZE g_gbu.* TO NULL 
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count #No.FUN-580092 HCN
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count) 
      DISPLAY g_curs_index TO FORMONLY.idx
   END IF
   
   SELECT * INTO g_gbu.* FROM gbu_file WHERE gbu01 = g_gbu.gbu01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","gbu_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      INITIALIZE g_gbu.* TO NULL
      RETURN
   END IF
   
   CALL p_keyrelat_show() 
   
END FUNCTION
 
FUNCTION p_keyrelat_show()                         # 將資料顯示在畫面上
   DISPLAY BY NAME g_gbu.gbu01,g_gbu.gbu02,g_gbu.gbu03,g_gbu.gbu04,g_gbu.gbu05   
   CALL p_keyrelat_b_fill(g_wc2)                    # 單身
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
   CALL p_keyrelat_show_more()
END FUNCTION
 
#FUN-AC0033 start
FUNCTION p_keyrelat_show_more()                     
   DEFINE   l_name            RECORD     
            gat03              LIKE gat_file.gat03,
            gaq03              LIKE gaq_file.gaq03,
            gaz03              LIKE gaz_file.gaz03,
            gae04              LIKE gae_file.gae04,
            gaq03_1            LIKE gaq_file.gaq03
                            END RECORD 

   LET l_name.gat03 = p_keyrelat_gat03(g_gbu.gbu02)
   LET l_name.gaz03 = p_keyrelat_gaz03()
   LET l_name.gae04 = p_keyrelat_gae04()

   LET l_name.gaq03 = p_keyrelat_gaq03(g_gbu.gbu01) 
   LET l_name.gaq03_1 = p_keyrelat_gaq03(g_gbu.gbu05) 

   DISPLAY BY NAME l_name.gat03,l_name.gaq03,l_name.gaz03,
                   l_name.gae04,l_name.gaq03_1

END FUNCTION

FUNCTION p_keyrelat_gaq03(p_gbu01)                      
   DEFINE  p_gbu01  LIKE gbu_file.gbu01,
           l_gaq03  LIKE gaq_file.gaq03

     SELECT gaq03 INTO l_gaq03 
       FROM gaq_file
      WHERE gaq01 = p_gbu01 
        AND gaq02 = g_lang

    RETURN l_gaq03
END FUNCTION

FUNCTION p_keyrelat_gat03(p_gbu02)                      
   DEFINE  p_gbu02  LIKE gbu_file.gbu02,
           l_gat03  LIKE gat_file.gat03

   SELECT gat03 INTO l_gat03 
     FROM gat_file 
    WHERE gat01 = p_gbu02 
      AND gat02 = g_lang

    RETURN l_gat03

END FUNCTION

FUNCTION p_keyrelat_gaz03()                      
   DEFINE  l_gaz03  LIKE gaz_file.gaz03

   SELECT gaz03 INTO l_gaz03 
     FROM gaz_file
    WHERE gaz01= g_gbu.gbu03 AND gaz02=g_lang

   RETURN l_gaz03
END FUNCTION

 
FUNCTION p_keyrelat_gae04()                      
   DEFINE  l_gae04  LIKE gae_file.gae04

   SELECT gae04 INTO l_gae04 
     FROM gae_file
    WHERE gae01= g_gbu.gbu04 AND gae02="wintitle" AND gae03=g_lang

   IF cl_null(l_gae04) THEN
      SELECT gat03 INTO l_gae04
        FROM gat_file,gac_file
       WHERE gac01= g_gbu.gbu04 AND gac10="Y"
         AND gat01=gac05 AND gat02=g_lang
       
   END IF
   RETURN l_gae04
END FUNCTION
#FUN-AC0033 END

FUNCTION p_keyrelat_r()        # 取消整筆 (所有合乎單頭的資料)

   DEFINE   l_cnt   LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
   
   IF cl_null(g_gbu.gbu01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   BEGIN WORK
   
   OPEN p_keyrelat_cl USING g_gbu.gbu01
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE p_keyrelat_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH p_keyrelat_cl INTO g_gbu.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("gau01 LOCK:",SQLCA.sqlcode,1)
      CLOSE p_keyrelat_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   IF cl_delh(0,0) THEN                   #確認一下
   	  DELETE FROM gbu_file WHERE gbu01 = g_gbu.gbu01 	  
      DELETE FROM gau_file WHERE gau01 = g_gbu.gbu01
      
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","gau_file",g_gau01,"",SQLCA.sqlcode,"","BODY DELETE:",0)  
         ROLLBACK WORK
         RETURN
      ELSE
      	 CLEAR FORM
      	 CALL g_gau.clear()
         OPEN p_keyrelat_count        
#FUN-B50065------begin---
         IF STATUS THEN
            CLOSE p_keyrelat_cl
            CLOSE p_keyrelat_count
            COMMIT WORK
            RETURN
         END IF
#FUN-B50065------end------
         FETCH p_keyrelat_count INTO g_row_count #No.FUN-580092 HCN
#FUN-B50065------begin---
         IF STATUS OR g_row_count=0 OR cl_null(g_row_count) THEN
            CLOSE p_keyrelat_cl
            CLOSE p_keyrelat_count
            COMMIT WORK
            RETURN
         END IF
#FUN-B50065------end------

         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN p_keyrelat_b_curs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count 
            CALL p_keyrelat_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL p_keyrelat_fetch('/')
         END IF 
      END IF
   END IF
   COMMIT WORK
END FUNCTION
 
FUNCTION p_keyrelat_b()                            # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,             # 未取消的ARRAY CNT
            l_n             LIKE type_file.num5,             # 檢查重複用
            l_lock_sw       LIKE type_file.chr1,             # 單身鎖住否
            p_cmd           LIKE type_file.chr1,             # 處理狀態
            l_allow_insert  LIKE type_file.num5,
            l_allow_delete  LIKE type_file.num5
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   	
   LET g_gau01 = g_gbu.gbu01
   LET g_gau02 = g_gbu.gbu02
   
   IF cl_null(g_gau01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= "SELECT gau03,gau04",
                     "  FROM gau_file",
                     " WHERE gau01 = ? AND gau03 = ? ",
                     "   FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_keyrelat_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_gau WITHOUT DEFAULTS FROM s_gau.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_gau_t.* = g_gau[l_ac].*    #BACKUP
#-------NO.MOD-590329 MARK---------------
 #No.MOD-580056 --start
#           LET g_before_input_done = FALSE
#           CALL p_keyrelat_set_entry_b(p_cmd)
#           CALL p_keyrelat_set_no_entry_b(p_cmd)
#           LET g_before_input_done = TRUE
 #No.MOD-580056 --end
#-------NO.MOD-590329 MARK--------------
            OPEN p_keyrelat_bcl USING g_gau01,g_gau_t.gau03
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN p_keyrelat_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               #FETCH p_keyrelat_bcl INTO g_gau[l_ac].*
               FETCH p_keyrelat_bcl INTO g_gau[l_ac].gau03 , g_gau[l_ac].gau04
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_gau_t.gau03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_gau[l_ac].* TO NULL       #900423
         LET g_gau_t.* = g_gau[l_ac].*          #新輸入資料
#------NO.MOD-590329 MARK------------------
 #No.MOD-580056 --start
#           LET g_before_input_done = FALSE
#           CALL p_keyrelat_set_entry_b(p_cmd)
#           CALL p_keyrelat_set_no_entry_b(p_cmd)
#           LET g_before_input_done = TRUE
 #No.MOD-580056 --end
#------NO.MOD-590329 MARK-----------------
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD gau03
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         INSERT INTO gau_file(gau01,gau02,gau03,gau04)
              VALUES (g_gau01,g_gau02,g_gau[l_ac].gau03,g_gau[l_ac].gau04)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","gau_file",g_gau01,"",SQLCA.sqlcode,"","",0)  
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      AFTER FIELD gau03
         IF NOT cl_null(g_gau[l_ac].gau03) THEN
            IF g_gau[l_ac].gau03 != g_gau_t.gau03 OR g_gau_t.gau03 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM gau_file
                WHERE gau03 = g_gau[l_ac].gau03
               IF l_n > 0 THEN
                  CALL cl_err(g_gau[l_ac].gau03,-239,0)
                  LET g_gau[l_ac].gau03 = g_gau_t.gau03
                  NEXT FIELD gau03
               END IF
               SELECT COUNT(*) INTO l_n FROM gau_file
                WHERE gau01 = g_gau[l_ac].gau03
               IF l_n > 0 THEN
                  CALL cl_err(g_gau[l_ac].gau03,-239,0)
                  LET g_gau[l_ac].gau03 = g_gau_t.gau03
                  NEXT FIELD gau03
               END IF
               
               LET g_gau[l_ac].gaq03 = p_keyrelat_gaq03(g_gau[l_ac].gau03)
               
             END IF
         END IF
 
      AFTER FIELD gau04
         IF NOT cl_null(g_gau[l_ac].gau04) THEN
            LET g_gau[l_ac].gat03 = p_keyrelat_gat03(g_gau[l_ac].gau04)
         END IF

      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_gau_t.gau03) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM gau_file WHERE gau01 = g_gau01
                                   AND gau03 = g_gau[l_ac].gau03
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_gau_t.gau03,SQLCA.sqlcode,0)   #No.FUN-660096
               CALL cl_err3("del","gau_file",g_gau01,g_gau[l_ac].gau03,SQLCA.sqlcode,"","",0)  
               ROLLBACK WORK
               CANCEL DELETE
            END IF 
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_gau[l_ac].* = g_gau_t.*
            CLOSE p_keyrelat_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_gau[l_ac].gau03,-263,1)
            LET g_gau[l_ac].* = g_gau_t.*
         ELSE
            UPDATE gau_file
               SET gau03 = g_gau[l_ac].gau03,
                   gau04 = g_gau[l_ac].gau04
             WHERE gau01 = g_gau01
               AND gau03 = g_gau_t.gau03
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_gau[l_ac].gau03,SQLCA.sqlcode,0)   #No.FUN-660096
               CALL cl_err3("upd","gau_file",g_gau01,g_gau_t.gau03,SQLCA.sqlcode,"","",0)  
               LET g_gau[l_ac].* = g_gau_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
#        LET l_ac_t = l_ac          #FUN-D30034 mark
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_gau[l_ac].* = g_gau_t.*
            #FUN-D30034---add---str---
            ELSE
               CALL g_gau.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034---add---end---
            END IF
            CLOSE p_keyrelat_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac          #FUN-D30034 add
         CLOSE p_keyrelat_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO                       #沿用所有欄位
         IF INFIELD(gau03) AND l_ac > 1 THEN
            LET g_gau[l_ac].* = g_gau[l_ac-1].*
            NEXT FIELD gau03
         END IF
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
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
   CLOSE p_keyrelat_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION p_keyrelat_b_fill(p_wc)              #BODY FILL UP
   DEFINE   p_wc   VARCHAR(300)
 
    LET g_sql = "SELECT gau03,gaq03,gau04,gat03 ",
                "  FROM gau_file ",
                "  LEFT OUTER JOIN gaq_file ON gau03=gaq01 AND gaq02='0'",
                "  LEFT OUTER JOIN gat_file ON gau04=gat01 AND gat02='0'",
                " WHERE gau01 = '", g_gbu.gbu01 CLIPPED,"' "
                
    IF NOT cl_null(p_wc) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc CLIPPED
    END IF
    
    LET g_sql=g_sql CLIPPED," ORDER BY gau03"
   
    PREPARE p_keyrelat_prepare2 FROM g_sql           #預備一下
    DECLARE gau_curs CURSOR FOR p_keyrelat_prepare2
 
    CALL g_gau.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH gau_curs INTO g_gau[g_cnt].*       #單身 ARRAY 填充
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_gau.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION p_keyrelat_bp(p_ud)
   DEFINE   p_ud   VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_gau TO s_gau.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      # 2004/01/17 by Hiko : 上下筆資料的ToolBar控制.
      BEFORE DISPLAY
          CALL cl_navigator_setting(g_curs_index, g_row_count) #No.FUN-580092 HCN
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION locale                          # 語言 #Ctrl+L]切換畫面顯示的語言別
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         INITIALIZE g_msg TO NULL
         CALL p_keyrelat_desc()
         EXIT DISPLAY
 
      ON ACTION insert                           # A.輸入
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"            # U.修改
         EXIT DISPLAY
      ON ACTION query                            # Q.查詢
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION reproduce                        # C.複製
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION delete                           # R.取消
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION detail                           # B.單身
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION batch 
         LET g_action_choice="batch"
         EXIT DISPLAY
      ON ACTION first                            # 第一筆
         CALL p_keyrelat_fetch('F')
          CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION previous                         # P.上筆
         CALL p_keyrelat_fetch('P')
          CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION jump                             # 指定筆
         CALL p_keyrelat_fetch('/')
          CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION next                             # N.下筆
         CALL p_keyrelat_fetch('N')
          CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION last                             # 最終筆
         CALL p_keyrelat_fetch('L')
          CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION help                             # H.說明
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION exit                             # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0049
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p_keyrelat_copy()
   DEFINE   l_n       LIKE type_file.num5,
            l_newfe   LIKE gbu_file.gbu01,
            l_newta   LIKE gbu_file.gbu02,
            l_oldno   LIKE gbu_file.gbu01
 
   IF s_shut(0) THEN                             # 檢查權限
      RETURN
   END IF
 
   IF g_gbu.gbu01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   
   LET g_before_input_done = FALSE
   CALL p_keyrelat_set_entry('a')
   CALL cl_set_head_visible("","YES")
   
   INPUT l_newfe FROM gbu01
      AFTER FIELD gbu01
         IF cl_null(l_newfe) THEN
            NEXT FIELD gbu01
         END IF
        
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
     ON ACTION about         #MOD-4C0121
        CALL cl_about()      #MOD-4C0121
 
     ON ACTION help          #MOD-4C0121
        CALL cl_show_help()  #MOD-4C0121
 
     ON ACTION controlg      #MOD-4C0121
        CALL cl_cmdask()     #MOD-4C0121  
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_gbu.gbu01
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM gbu_file         #單頭複製
       WHERE gbu01=g_gbu.gbu01
       INTO TEMP y
       
   UPDATE y
       SET gbu01=l_newfe    #新的鍵值
           
           
   INSERT INTO gbu_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","gbu_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
   END IF
               
   DROP TABLE x
   SELECT * FROM gau_file WHERE gau01 = g_gbu.gbu01
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x",g_gbu.gbu01,"",SQLCA.sqlcode,"","",0)  
      RETURN
   END IF
 
   UPDATE x
      SET gau01 = l_newfe              # 資料鍵值
 
   INSERT INTO gau_file SELECT * FROM x
 
   IF SQLCA.SQLCODE THEN
      CALL cl_err3("ins","gau_file",l_newfe,"",SQLCA.sqlcode,"","gau:",0)  
      RETURN
   END IF
   LET g_cnt = SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
   
   LET l_oldno = g_gbu.gbu01
   SELECT gbu_file.* INTO g_gbu.* FROM gbu_file WHERE gbu01 = l_newfe
   CALL p_keyrelat_u()
   CALL p_keyrelat_b()
   #SELECT gbu_file.* INTO g_gbu.* FROM gbu_file WHERE gbu01 = l_oldno  #FUN-C30027
   #CALL p_keyrelat_show()  #FUN-C30027
END FUNCTION
 
FUNCTION p_keyrelat_batch()
   DEFINE   gau03_tmp   LIKE gau_file.gau03
   DEFINE   ls_sql      VARCHAR(700),
            ls_where    VARCHAR(500)
   DEFINE   ls_cnt      LIKE type_file.num5,
            l_rec_b     LIKE type_file.num5,
            l_ac        LIKE type_file.num5
   DEFINE   lr_qry      RECORD
            check       VARCHAR(1),
            gae01       LIKE gae_file.gae01,
            gae02       LIKE gae_file.gae02,
            gae03       LIKE gae_file.gae03,
            gae04       LIKE gae_file.gae04
                        END RECORD
 
   DISPLAY "g_gau01:",g_gau01
   IF cl_null(g_gau01) THEN
      RETURN
   END IF
 
   OPEN WINDOW p_keyrelat_batch WITH FORM "azz/42f/p_keyrelat_batch"
      ATTRIBUTE(STYLE=g_win_style)
 
   CALL cl_ui_locale("p_keyrelat_batch")
 
   SELECT COUNT(gau03) INTO ls_cnt FROM gau_file WHERE gau01 = g_gau01
   LET l_ac = 1
   LET g_sql = "SELECT gau03 FROM gau_file WHERE gau01 = '",g_gau01,"' ORDER BY gau03"
   PREPARE p_keyrelat_batch FROM g_sql
   DECLARE batch_cur CURSOR FOR p_keyrelat_batch
   FOREACH batch_cur INTO gau03_tmp
      IF SQLCA.sqlcode THEN
         CALL cl_err('batch_cur:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET ls_where = ls_where CLIPPED," gae02 = '", gau03_tmp CLIPPED,"'"
      IF l_ac < ls_cnt THEN
         LET ls_where = ls_where CLIPPED, " OR "
      END IF
      LET l_ac = l_ac + 1
   END FOREACH
 
   LET ls_sql = "SELECT 'N',gae01,gae02,gae03,gae04",
                "  FROM gae_file",
                " WHERE gae03 = '",g_lang,"'",
                "   AND (",ls_where CLIPPED,")",
                " ORDER BY gae02,gae01"
 
   DECLARE gae_qry_cs CURSOR FROM ls_sql
 
   CALL gae_qry.clear()
   LET l_rec_b = 0
   LET l_ac = 1
   FOREACH gae_qry_cs INTO lr_qry.*
      LET l_rec_b = l_rec_b + 1
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET gae_qry[l_ac].* = lr_qry.*
      LET l_ac = l_ac + 1
   END FOREACH
 
   INPUT ARRAY gae_qry WITHOUT DEFAULTS FROM s_gae.* 
      ATTRIBUTE(INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE,COUNT=l_rec_b,
                UNBUFFERED)
      ON ACTION accept
         IF cl_sure(1,1) THEN
            CALL gae_update()
         END IF
         EXIT INPUT
      ON ACTION cancel
         EXIT INPUT
      ON ACTION select_all
         FOR l_ac = 1 TO gae_qry.getLength()
            LET gae_qry[l_ac].check = "Y"
         END FOR
         DISPLAY ARRAY gae_qry TO s_gae.*
            BEFORE DISPLAY
               EXIT DISPLAY
         END DISPLAY
         MESSAGE "SELECT ALL"
      ON ACTION select_none
         FOR l_ac = 1 TO gae_qry.getLength()
            LET gae_qry[l_ac].check = "N"
         END FOR
         DISPLAY ARRAY gae_qry TO s_gae.*
            BEFORE DISPLAY
               EXIT DISPLAY
         END DISPLAY
         MESSAGE "SELECE NONE"
 
#     ON ACTION locale
#        CALL cl_dynamic_locale()
#        CALL cl_show_fld_cont()   #FUN-550037(smin)
 
      ON ACTION exit
         EXIT INPUT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   END INPUT
 
   CLOSE WINDOW p_keyrelat_batch
END FUNCTION
 
FUNCTION gae_update()
   DEFINE   li_i      LIKE type_file.num10,
            li_j      LIKE type_file.num10
   DEFINE   l_gau05   LIKE gau_file.gau05,     #繁體中文
            l_gau06   LIKE gau_file.gau06,     #英文
            l_gau07   LIKE gau_file.gau07      #簡詞中文
   DEFINE   l_errno   LIKE type_file.num5
   
   IF cl_null(g_gau01) THEN
      RETURN
   ELSE
      SELECT gau05,gau06,gau07 INTO l_gau05,l_gau06,l_gau07
        FROM gau_file
       WHERE gau01 = g_gau01
   END IF
 
   BEGIN WORK
   LET l_errno = FALSE
   DISPLAY "gae_gry:",gae_qry.getLength()  
   FOR li_i = 1 TO gae_qry.getLength()
       IF gae_qry[li_i].check = 'Y' THEN
          DISPLAY "g_gaq :",g_gaq.getLength() 
          FOR li_j = 1 TO g_gaq.getLength()
            
             #UPDATE gae_file SET gae04 = g_gaq[li_j].gaq03
             # WHERE gae01 = gae_qry[li_i].gae01 AND gae02 = gae_qry[li_i].gae02
             #   AND gae03 = g_gaq[li_j].gaq02
             DISPLAY "g_gaq[li_j].gaq03:",g_gaq[li_j].gaq03
             DISPLAY "gae10:",g_today
             DISPLAY "gae_qry[li_i].gae01:",gae_qry[li_i].gae01
             DISPLAY "gae_qry[li_i].gae02:",gae_qry[li_i].gae02
             DISPLAY "g_gaq[li_j].gaq02:",g_gaq[li_j].gaq02            
             UPDATE gae_file SET gae04 = g_gaq[li_j].gaq03,  #FUN-B20034 
                                 gae10 = g_today             #多加update gae10(異動日期)      
              WHERE gae01 = gae_qry[li_i].gae01 AND gae02 = gae_qry[li_i].gae02
                AND gae03 = g_gaq[li_j].gaq02
 
            IF STATUS THEN
                EXIT FOR
                LET l_errno = TRUE
             END IF
          END FOR
       END IF
   END FOR
   IF l_errno THEN
      CALL cl_err("UPDATE:",STATUS,0)
      ROLLBACK WORK
   ELSE
      COMMIT WORK
   END IF
END FUNCTION
 
FUNCTION p_keyrelat_desc()
   DEFINE   ls_sql     STRING
   DEFINE   ls_gay03   LIKE gay_file.gay03
 
   LET ls_sql = "SELECT gaq01,gaq02,gaq03 FROM gaq_file",
                " WHERE gaq01 = '",g_gau01,"'"
   PREPARE g_gaq_pre FROM ls_sql
   DECLARE g_gaq_cur CURSOR FOR g_gaq_pre
 
   LET g_cnt = 1
   INITIALIZE g_msg TO NULL
   FOREACH g_gaq_cur INTO g_gaq[g_cnt].*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      SELECT gay03 INTO ls_gay03 FROM gay_file
       WHERE gay01 = g_gaq[g_cnt].gaq02 AND gay02 = g_lang
      LET g_msg = g_msg CLIPPED,ls_gay03 CLIPPED," : ",g_gaq[g_cnt].gaq03 CLIPPED,"\n"
      LET g_cnt = g_cnt + 1
   END FOREACH
   DISPLAY g_msg TO FORMONLY.desc
END FUNCTION
 
