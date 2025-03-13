# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: atmi219.4gl
# Descriptions...: 債權產品系列維護作業
# Date & Author..: 05/12/05 By Tracy 
# Modify.........: NO.TQC-640174 06/04/21 By Tracy 刪除狀態頁及有效無效功能
# Modify........ : No.FUN-660104 06/06/15 By cl Error Message 調整
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: Mo.FUN-6A0072 06/10/24 By xumin g_no_ask改mi_no_ask    
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能 
# Modify.........: No.FUN-6B0043 06/11/24 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-7B0031 07/11/06 By Carrier bp中去掉invalid事件
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.MOD-B30199 11/03/12 by Summer 查詢上下一筆時會出現 英文action (dsplt200,dsvstore1) 
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-D30033 13/04/10 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"   
 
#模組變數(Module Variables)
DEFINE 
    g_tqh01          LIKE tqh_file.tqh01,        #債權
    g_tqh01_t        LIKE tqh_file.tqh01,
    g_tqh_h          RECORD
                     tqhuser LIKE tqh_file.tqhuser,
                     tqhgrup LIKE tqh_file.tqhgrup,
                     tqhmodu LIKE tqh_file.tqhmodu,
                     tqhdate LIKE tqh_file.tqhdate, 
                     tqhacti LIKE tqh_file.tqhacti
                     END RECORD,
    g_tqh_h_t        RECORD 
                     tqhuser LIKE tqh_file.tqhuser,
                     tqhgrup LIKE tqh_file.tqhgrup,
                     tqhmodu LIKE tqh_file.tqhmodu,
                     tqhdate LIKE tqh_file.tqhdate, 
                     tqhacti LIKE tqh_file.tqhacti
                     END RECORD,
    g_tqh            DYNAMIC ARRAY OF RECORD     #程式變數(Program Variables)  
                     tqh02  LIKE tqh_file.tqh02, #系列
                     tqa021 LIKE tqa_file.tqa02  #系列名稱
                     END RECORD, 
    g_tqh_t          RECORD                      #程式變數(Program Variables)  
                     tqh02  LIKE tqh_file.tqh02, #系列
                     tqa021 LIKE tqa_file.tqa02  #系列名稱
                     END RECORD, 
    g_wc,g_wc2,g_sql STRING,
    g_rec_b          LIKE type_file.num5,           #No.FUN-680120 SMALLINT
    l_ac             LIKE type_file.num5            #No.FUN-680120 SMALLINT
                      
DEFINE g_forupd_sql  STRING                         #SELECT..FOR UPDATE  SQL
DEFINE g_cnt         LIKE type_file.num10           #No.FUN-680120 INTEGER
DEFINE g_chr         LIKE type_file.chr1            #No.FUN-680120 VARCHAR(1)
DEFINE g_i           LIKE type_file.num5            #No.FUN-680120 SMALLINT
DEFINE g_msg         LIKE type_file.chr1000         #No.FUN-680120 VARCHAR(72) 
DEFINE g_row_count   LIKE type_file.num10           #No.FUN-680120 INTEGER
DEFINE g_curs_index  LIKE type_file.num10           #No.FUN-680120 INTEGER
DEFINE g_jump        LIKE type_file.num10           #No.FUN-680120 INTEGER
DEFINE mi_no_ask     LIKE type_file.num5            #No.FUN-680120 SMALLINT   #No.FUN-6A0072
DEFINE g_argv1       LIKE tqh_file.tqh01      
DEFINE g_before_input_done LIKE type_file.num5      #No.FUN-680120 SMALLINT
 
#主程式開始
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6B0014
DEFINE p_row,p_col   LIKE type_file.num5            #No.FUN-680120 SMALLINT
DEFINE p_argv1       LIKE tqh_file.tqh01          
 
    OPTIONS
       INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN                                                     
       EXIT PROGRAM                                                             
    END IF                                                                      
                                                                                
    WHENEVER ERROR CALL cl_err_msg_log        
 
    IF (NOT cl_setup("ATM")) THEN                                               
       EXIT PROGRAM                                                             
    END IF                                                                      
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
    
    LET g_argv1=ARG_VAL(1)     
 
    LET g_forupd_sql = "SELECT UNIQUE tqh01",    #No.TQC-640174
                       "  FROM tqh_file WHERE tqh01 = ? AND tqh02 = ? FOR UPDATE"  #No.TQC-640174
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i219_cl CURSOR FROM g_forupd_sql        
 
    LET p_row = 4 LET p_col = 12
 
    OPEN WINDOW i219_w AT p_row,p_col WITH FORM "atm/42f/atmi219"
         ATTRIBUTE (STYLE = g_win_style)
 
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN CALL i219_q() END IF 
 
    CALL i219_menu()      
 
    CLOSE WINDOW i219_w                          #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN     
 
FUNCTION i219_cs()
    CLEAR FORM   
    CALL g_tqh.clear()
    IF cl_null(g_argv1) OR g_argv1 = " " THEN      
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_tqh01 TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON tqh01,tqh02                #No.TQC-640174 
         FROM tqh01,                             #No.TQC-640174  
              s_tqh[1].tqh02                     #螢幕上取條件
 
        #No.FUN-580031 --start--     HCN
        BEFORE CONSTRUCT
          CALL cl_qbe_init()
        #No.FUN-580031 --end--       HCN
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(tqh01)                #債權
                   CALL cl_init_qry_var()     
                   LET g_qryparam.state = "c"    
                   LET g_qryparam.form ="q_tqa1" 
                   LET g_qryparam.arg1 ="20"     
                   CALL cl_create_qry() RETURNING g_qryparam.multiret 
                   DISPLAY g_qryparam.multiret TO tqh01   
                   NEXT FIELD tqh01
              WHEN INFIELD(tqh02)                #系列
                   CALL cl_init_qry_var()                                       
                   LET g_qryparam.form ="q_tqa1" 
                   LET g_qryparam.arg1 ="3"     
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO tqh02
           END CASE
        ON IDLE g_idle_seconds                                          
           CALL cl_on_idle()                                            
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
           CONTINUE CONSTRUCT                                           
 
        ON ACTION about         
           CALL cl_about()     
 
        ON ACTION help        
           CALL cl_show_help()  
 
        ON ACTION controlg      
           CALL cl_cmdask()    
 
    END CONSTRUCT          
    IF INT_FLAG THEN RETURN END IF 
  ELSE                                                                
    LET g_wc = "tqh01  = '",g_argv1,"'"                          
  END IF    
 
   #資料權限的檢查        
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料   
    #       LET g_wc = g_wc clipped," AND tqhuser = '",g_user,"'"           
    #    END IF                                                            
                                                                    
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料 
    #       LET g_wc = g_wc clipped," AND tqhgrup MATCHES '",g_grup CLIPPED,"*'"  
    #    END IF             
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND tghgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('tqhuser', 'tqhgrup')
    #End:FUN-980030
 
    LET g_sql = "SELECT UNIQUE tqh01 FROM tqh_file ",
                " WHERE ",g_wc CLIPPED, 
                " ORDER BY tqh01"
    PREPARE i219_prepare FROM g_sql              #預備一下
    DECLARE i219_curs                            #宣告成可卷動的
        SCROLL CURSOR WITH HOLD FOR i219_prepare
 
    LET g_sql = "SELECT COUNT(DISTINCT tqh01) FROM  tqh_file ",
                "  WHERE ", g_wc CLIPPED
    PREPARE i219_precount FROM g_sql                                            
    DECLARE i219_count CURSOR FOR  i219_precount          
 
END FUNCTION
 
FUNCTION i219_menu()
   WHILE TRUE                                                                   
      CALL i219_bp("G")                                                         
      CASE g_action_choice                                                      
         WHEN "insert"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i219_a()                                                    
            END IF   
         WHEN "query"
            IF cl_chk_act_auth() THEN                                           
               CALL i219_q()                                                    
            END IF                                                              
         WHEN "delete"        
            IF cl_chk_act_auth() THEN 
               CALL i219_r()    
            END IF   
         WHEN "detail"        
            IF cl_chk_act_auth() THEN    
               CALL i219_b()                                                    
            ELSE            
               LET g_action_choice = NULL        
            END IF                                                              
#No.TQC-640174 mark  
#        WHEN "invalid"                     
#           IF cl_chk_act_auth() THEN      
#              CALL i219_x()              
#           END IF                           
         WHEN "help"                                                            
            CALL cl_show_help()                                                 
         WHEN "exit"                                                            
            EXIT WHILE                                                          
         WHEN "controlg"                                                        
            CALL cl_cmdask()                                                    
         WHEN "exporttoexcel"                                                                                                       
            IF cl_chk_act_auth() THEN                                                                                               
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tqh),'','')                                                    
            END IF                    
         #No.FUN-6B0043-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_tqh01 IS NOT NULL THEN
                 LET g_doc.column1 = "tqh01"
                 LET g_doc.value1 = g_tqh01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6B0043-------add--------end----
      END CASE                                                                  
   END WHILE                                                                    
END FUNCTION                       
 
FUNCTION i219_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_tqh.clear()
 
    INITIALIZE g_tqh01 LIKE tqh_file.tqh01
    INITIALIZE g_tqh_h.tqhuser LIKE tqh_file.tqhuser
    INITIALIZE g_tqh_h.tqhgrup LIKE tqh_file.tqhgrup
    INITIALIZE g_tqh_h.tqhmodu LIKE tqh_file.tqhmodu
    INITIALIZE g_tqh_h.tqhacti LIKE tqh_file.tqhacti
 
    
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_tqh_h.tqhuser=g_user                         
        LET g_tqh_h.tqhgrup=g_grup                        
        LET g_tqh_h.tqhdate=g_today                      
        LET g_tqh_h.tqhacti='Y'                  #資料有效      
 
        CALL i219_i("a")                         #輸入單頭
        IF INT_FLAG THEN                         #用戶不玩了
           LET g_tqh01=NULL
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           EXIT WHILE
        END IF
        SELECT tqh01,tqh02 INTO g_tqh01,g_tqh_t.tqh02 FROM tqh_file   
         WHERE tqh01 = g_tqh01 
	CALL g_tqh.clear()
        LET g_rec_b = 0
        CALL i219_b()           
        LET g_tqh01_t  =g_tqh01
        LET g_tqh_h_t.*=g_tqh_h.*
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i219_i(p_cmd)
   DEFINE p_cmd           LIKE type_file.chr1,         #a:輸入 u:更改        #No.FUN-680120 VARCHAR(1)
          l_n             LIKE type_file.num5,         #No.FUN-680120 SMALLINT
          l_cnt           LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
#No.TQC-640174 mark  
#  DISPLAY BY NAME g_tqh_h.tqhuser,g_tqh_h.tqhmodu, 
#                  g_tqh_h.tqhgrup,g_tqh_h.tqhdate,g_tqh_h.tqhacti            
   CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031 
   INPUT g_tqh01 WITHOUT DEFAULTS FROM tqh01
 
      BEFORE INPUT                                                              
         LET g_before_input_done = FALSE                                        
         LET g_before_input_done = TRUE                
 
       AFTER FIELD tqh01                         #債權
          IF NOT cl_null(g_tqh01) THEN
	     #資料是否存在
             SELECT COUNT(*) INTO l_cnt FROM tqa_file   
              WHERE tqa01=g_tqh01 AND tqa03='20' AND tqaacti='Y'
             IF l_cnt = 0 THEN
                CALL cl_err(g_tqh01,100,0)     
                LET g_tqh01=g_tqh01_t
                NEXT FIELD tqh01
             END IF
             #重復
             SELECT COUNT(*) INTO l_cnt FROM tqh_file
              WHERE tqh01 = g_tqh01
             IF l_cnt > 0 THEN
                CALL cl_err(g_tqh01,-239,0)         
                LET g_tqh01= g_tqh01_t
                NEXT FIELD tqh01
             END IF
             CALL i219_tqh01('a',g_tqh01)
          END IF
        
       ON ACTION CONTROLF                        #欄位說明
          CALL cl_set_focus_form(ui.Interface.getRootNode()) 
               RETURNING g_fld_name,g_frm_name
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)          
 
       ON ACTION CONTROLR          
          CALL cl_show_req_fields()  
 
       ON ACTION CONTROLP   
          CASE     
             WHEN INFIELD(tqh01)                 #債權
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_tqa1"
                  LET g_qryparam.arg1 ="20"     
                  LET g_qryparam.default1 = g_tqh01
                  CALL cl_create_qry() RETURNING g_tqh01
                  NEXT FIELD tqh01
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
 
    END INPUT
 
END FUNCTION
 
FUNCTION i219_tqh01(p_cmd,p_key)
    DEFINE p_cmd     LIKE type_file.num5             #No.FUN-680120 SMALLINT
    DEFINE p_key     LIKE tqh_file.tqh01
    DEFINE l_tqa02   LIKE tqa_file.tqa02 
    
    SELECT tqa02
      INTO l_tqa02
      FROM tqa_file
     WHERE tqa01 = p_key
       AND tqa03='20'
       AND tqaacti='Y'
    IF SQLCA.sqlcode THEN
    #   CALL cl_err(p_key,SQLCA.sqlcode,0)  #No.FUN-660104
        CALL cl_err3("sel","tqa_file",p_key,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
    ELSE
        DISPLAY  l_tqa02 TO tqa02
    END IF
 
END FUNCTION
 
#Query 查詢
FUNCTION i219_q()
    LET g_row_count = 0                                                         
    LET g_curs_index = 0                                                        
    CALL cl_navigator_setting( g_curs_index, g_row_count )                      
    INITIALIZE g_tqh01 TO NULL                   #No.FUN-6B0043
    INITIALIZE g_tqh_h.* TO NULL                 #No.FUN-6B0043
    MESSAGE ""
    CALL cl_opmsg('q')  
    CLEAR FORM
    CALL g_tqh.clear()
    INITIALIZE  g_tqh01 TO NULL 
    DISPLAY ' ' TO FORMONLY.cnt 
    CALL i219_cs()                               #取得查詢條件
    IF INT_FLAG THEN                             #用戶不玩了
       LET INT_FLAG = 0 
       INITIALIZE g_tqh01 TO NULL
       INITIALIZE g_tqh_h.* TO NULL
       RETURN
    END IF
    OPEN i219_curs                               #從DB生成合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                        #有問題
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_tqh01 TO NULL
       INITIALIZE g_tqh_h.* TO NULL
    ELSE
       OPEN i219_count                                                     
       FETCH i219_count INTO g_row_count   
       DISPLAY g_row_count TO FORMONLY.cnt  
       CALL i219_fetch('F')                      #讀出TEMP第一筆并顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i219_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1           #處理方式        #No.FUN-680120 VARCHAR(1)
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i219_curs INTO g_tqh01
        WHEN 'P' FETCH PREVIOUS i219_curs INTO g_tqh01
        WHEN 'F' FETCH FIRST    i219_curs INTO g_tqh01
        WHEN 'L' FETCH LAST     i219_curs INTO g_tqh01
        WHEN '/' 
          IF (NOT mi_no_ask) THEN   #No.FUN-6A0072
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
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
          END IF
          FETCH ABSOLUTE g_jump i219_curs INTO g_tqh01
          LET mi_no_ask = FALSE   #No.FUN-6A0072
    END CASE
    IF SQLCA.sqlcode THEN                        #有麻煩
       CALL cl_err(g_tqh01,SQLCA.sqlcode,0)
       INITIALIZE g_tqh01 TO NULL  #TQC-6B0105
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
    END IF
#No.TQC-640174 mark  
#   SELECT UNIQUE tqhuser,tqhgrup,tqhmodu,tqhdate,tqhacti 
#     INTO g_tqh_h.*
#     FROM tqh_file
#    WHERE tqh01=g_tqh01  
#   IF SQLCA.sqlcode THEN                
#      CALL cl_err(g_tqh01,SQLCA.sqlcode,0)      
#      INITIALIZE g_tqh01 TO NULL                   
#      INITIALIZE g_tqh_h.* TO NULL                   
#      RETURN                                                                                                                        
#  END IF                                
#   LET g_data_owner = g_tqh_h.tqhuser       
#   LET g_data_group = g_tqh_h.tqhgrup   
 
    CALL i219_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i219_show()
    LET g_tqh01_t   = g_tqh01
    LET g_tqh_h_t.* = g_tqh_h.*
    DISPLAY g_tqh01                              #No.TQC-640174
    TO tqh01
    CALL i219_tqh01('d',g_tqh01)
    CALL i219_b_fill(g_wc)                       #單身
    CALL cl_show_fld_cont()           #MOD-B30199 add
END FUNCTION
 
#No.TQC-640174 mark  
{
FUNCTION i219_x()
 
   IF s_shut(0) THEN 
      RETURN
   END IF
 
   IF cl_null(g_tqh01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   LET g_success = 'Y'
 
   CALL i219_show()
 
   IF cl_exp(0,0,g_tqh_h.tqhacti) THEN            #確認一下
      LET g_chr=g_tqh_h.tqhacti
      IF g_tqh_h.tqhacti='Y' THEN
         LET g_tqh_h.tqhacti='N'
      ELSE
         LET g_tqh_h.tqhacti='Y'
      END IF
 
      UPDATE tqh_file SET tqhacti=g_tqh_h.tqhacti,
                          tqhmodu=g_user,
                          tqhdate=g_today
      WHERE tqh01=g_tqh01
 
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
      #  CALL cl_err(g_tqh01,SQLCA.sqlcode,0)  #No.FUN-660104
         CALL cl_err3("upd","tqh_file",g_tqh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
         LET g_tqh_h.tqhacti=g_chr
      END IF
   END IF
 
   CLOSE i219_cl
 
   IF g_success = 'Y' THEN 
      COMMIT WORK
   ELSE 
      ROLLBACK WORK
   END IF  
   SELECT tqhacti,tqhmodu,tqhdate
     INTO g_tqh_h.tqhacti,g_tqh_h.tqhmodu,g_tqh_h.tqhdate FROM tqh_file
    WHERE tqh01=g_tqh01 
   DISPLAY BY NAME g_tqh_h.tqhacti,g_tqh_h.tqhmodu,g_tqh_h.tqhdate
END FUNCTION
}
FUNCTION i219_r()
 
    IF s_shut(0) THEN RETURN END IF
    IF g_tqh01 IS NULL THEN 
       CALL cl_err('',-400,0)
       RETURN 
    END IF
 
    BEGIN WORK
    CALL i219_show()                 
    IF cl_delh(0,0) THEN                   #審核一下
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "tqh01"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_tqh01       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
       DELETE FROM tqh_file WHERE tqh01 = g_tqh01
       IF SQLCA.sqlcode THEN
       #  CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)  #No.FUN-660104
          CALL cl_err3("del","tqh_file",g_tqh01,"",SQLCA.sqlcode,"","BODY DELETE:",1)  #No.FUN-660104
          ROLLBACK WORK
       ELSE
          CLEAR FORM
          CALL g_tqh.clear()  
          OPEN i219_count      
          #FUN-B50064-add-start--
          IF STATUS THEN
             CLOSE i219_curs
             CLOSE i219_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50064-add-end-- 
          FETCH i219_count INTO g_row_count      
          #FUN-B50064-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i219_curs
             CLOSE i219_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50064-add-end-- 
          DISPLAY g_row_count TO FORMONLY.cnt  
          OPEN i219_curs      
          IF g_curs_index = g_row_count + 1 THEN  
             LET g_jump = g_row_count        
             CALL i219_fetch('L')     
          ELSE       
             LET g_jump = g_curs_index    
             LET mi_no_ask = TRUE    #No.FUN-6A0072  
             CALL i219_fetch('/')     
          END IF
       END IF
    END IF
    COMMIT WORK
END FUNCTION
#單身
FUNCTION i219_b()
   DEFINE l_ac_t          LIKE type_file.num5,              #未撤銷的ARRAY CNT #No.FUN-680120 SMALLINT
          l_n             LIKE type_file.num5,              #檢查重復用        #No.FUN-680120 SMALLINT
          l_cnt           LIKE type_file.num5,              #No.FUN-680120 SMALLINT
          l_modify_flag   LIKE type_file.chr1,              #單身更改否        #No.FUN-680120 VARCHAR(1)
          l_lock_sw       LIKE type_file.chr1,              #單身鎖住否        #No.FUN-680120 VARCHAR(1)
          l_exit_sw       LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)           #Esc結案INPUT ARRAY 否
          p_cmd           LIKE type_file.chr1,              #處理狀態          #No.FUN-680120 VARCHAR(1)
          l_allow_insert  LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(01)          #可新增否
          l_allow_delete  LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(01)          #可更改否 (含撤銷)
          l_tqa02         LIKE tqa_file.tqa02,
          l_jump          LIKE type_file.num5              #No.FUN-680120 SMALLINT          #判斷是否跳過AFTER ROW的處理
 
   LET g_action_choice = ""    
 
   IF g_tqh01 IS NULL THEN RETURN END IF
    
   CALL cl_opmsg('b')
   LET g_forupd_sql = "SELECT tqh02,''",
                      "  FROM tqh_file ",  
                      "  WHERE tqh01 = ? ",
                      "   AND tqh02 = ? ",
                      "  FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i219_bcl CURSOR FROM g_forupd_sql
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")                         
   LET l_allow_delete = cl_detail_input_auth("delete")    
 
   INPUT ARRAY g_tqh WITHOUT DEFAULTS FROM s_tqh.*                             
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,                
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,        
                   APPEND ROW=l_allow_insert)                                  
 
       BEFORE INPUT
          IF g_rec_b != 0 THEN                                                
             CALL fgl_set_arr_curr(l_ac)                                      
          END IF           
 
       BEFORE ROW
          LET p_cmd = ''                                                      
          LET l_ac = ARR_CURR()                                               
          LET l_lock_sw = 'N'                    #DEFAULT    
          LET l_n  = ARR_COUNT()                                              
 
          BEGIN WORK
            
          IF g_rec_b >= l_ac THEN                                             
             LET p_cmd = 'u'    
             LET g_tqh_t.* = g_tqh[l_ac].*       #BACKUP
             OPEN i219_bcl USING g_tqh01,g_tqh_t.tqh02
             IF STATUS THEN
                CALL cl_err("OPEN i219_bcl:", STATUS, 1)                     
                LET l_lock_sw = "Y"                                           
             ELSE                                         
                FETCH i219_bcl INTO g_tqh[l_ac].* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_tqh[l_ac].tqh02,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y" 
                ELSE 
                   SELECT tqa02 INTO l_tqa02 FROM tqa_file 
                    WHERE tqa01=g_tqh[l_ac].tqh02 
                      AND tqa03='3' AND tqaacti='Y'
                   LET g_tqh[l_ac].tqa021=l_tqa02      
                END IF
             END IF
             CALL cl_show_fld_cont()           #MOD-B30199 add
          END IF
          NEXT FIELD tqh02
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE g_tqh[l_ac].* TO NULL     
          INITIALIZE g_tqh_t.* TO NULL    
          CALL cl_show_fld_cont()           #MOD-B30199 add
          NEXT FIELD tqh02
 
       AFTER INSERT
          IF INT_FLAG THEN                                                    
             CALL cl_err('',9001,0)                                           
             LET INT_FLAG = 0                                                 
             CANCEL INSERT                                                    
          END IF     
          INSERT INTO tqh_file(tqh01,tqh02,tqhacti,tqhuser,
                                  tqhgrup,tqhdate,tqhoriu,tqhorig)      
          VALUES(g_tqh01,g_tqh[l_ac].tqh02,'Y',g_user,g_grup,g_today, g_user, g_grup)       #No.FUN-980030 10/01/04  insert columns oriu, orig
 
          IF SQLCA.sqlcode THEN
          #  CALL cl_err(g_tqh[l_ac].tqh02,SQLCA.sqlcode,0)        #No.FUN-660104
             CALL cl_err3("ins","tqh_file",g_tqh01,g_tqh[l_ac].tqh02,SQLCA.sqlcode,"","",1)  #No.FUN-660104
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'    
 
#No.TQC-640174 mark
#            UPDATE tqh_file SET tqhuser=g_user,
#                                tqhacti='Y',
#                                tqhgrup=g_grup,
#                                tqhdate=g_today
#                          WHERE tqh01  =g_tqh01
 
             COMMIT WORK
             LET g_rec_b=g_rec_b+1   
             DISPLAY g_rec_b TO FORMONLY.cn2
          END IF   
 
       AFTER FIELD tqh02               #系列
          IF g_tqh[l_ac].tqh02 IS NOT NULL THEN 
             #資料是否存在
             SELECT COUNT(*) INTO l_cnt FROM tqa_file   
              WHERE tqa01=g_tqh[l_ac].tqh02 AND tqa03='3'
                    AND tqaacti='Y'
             IF l_cnt = 0 THEN
                CALL cl_err(g_tqh[l_ac].tqh02,100,0)
                LET g_tqh[l_ac].tqh02 = g_tqh_t.tqh02
                NEXT FIELD tqh02
             END IF
             IF g_tqh[l_ac].tqh02 != g_tqh_t.tqh02 OR
                g_tqh_t.tqh02 IS NULL  THEN
                SELECT COUNT(*) INTO l_cnt FROM tqh_file
                 WHERE tqh02 = g_tqh[l_ac].tqh02
                       AND tqh01 = g_tqh01
                IF l_cnt > 0 THEN
                   CALL cl_err(g_tqh[l_ac].tqh02,-239,0)         
                   LET g_tqh[l_ac].tqh02 = g_tqh_t.tqh02
                   NEXT FIELD tqh02
                END IF
             END IF
 
	     CALL i219_tqh02(l_ac,g_tqh[l_ac].tqh02)
           END IF
 
        BEFORE DELETE
           IF NOT cl_null(g_tqh_t.tqh02) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN                                         
                 CALL cl_err("", -263, 1)                                     
                 CANCEL DELETE                                                
              END IF        
              DELETE FROM tqh_file
               WHERE tqh01 = g_tqh01
                     AND tqh02 = g_tqh[l_ac].tqh02
              IF SQLCA.sqlcode THEN
              #  CALL cl_err(g_tqh_t.tqh02,SQLCA.sqlcode,0)  #No.FUN-660104
                 CALL cl_err3("del","tqh_file",g_tqh01,g_tqh[l_ac].tqh02,SQLCA.sqlcode,"","",1)  #No.FUN-660104
                 ROLLBACK WORK 
                 CANCEL DELETE
              END IF
              LET g_rec_b = g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK 
 
        ON ROW CHANGE                                                           
           IF INT_FLAG THEN                                                    
              CALL cl_err('',9001,0)                                           
              LET INT_FLAG = 0                                                 
              LET g_tqh[l_ac].* = g_tqh_t.*                                    
              CLOSE i219_bcl
              ROLLBACK WORK                                                    
              EXIT INPUT                                                       
           END IF                                                              
           IF l_lock_sw = 'Y' THEN                                             
              CALL cl_err(g_tqh[l_ac].tqh02,-263,1)
              LET g_tqh[l_ac].* = g_tqh_t.*                                    
           ELSE                    
              UPDATE tqh_file 
                 SET tqh02   = g_tqh[l_ac].tqh02
               WHERE CURRENT OF i219_bcl            ##new               
              UPDATE tqh_file 
                 SET tqhmodu = g_user,
                     tqhdate = g_today
               WHERE tqh01   = g_tqh01
                 AND tqh02   = g_tqh[l_ac].tqh02    
              IF SQLCA.sqlcode THEN                                   
              #  CALL cl_err('',SQLCA.sqlcode,0)        #No.FUN-660104
                 CALL cl_err3("upd","tqh_file",g_tqh[l_ac].tqh02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
                 LET g_tqh[l_ac].* = g_tqh_t.* 
                 ROLLBACK WORK                                       
              ELSE                                                    
                 MESSAGE 'UPDATE O.K'                                
                 COMMIT WORK 
              END IF                                                  
           END IF                
 
        AFTER ROW
           LET l_ac = ARR_CURR()                                               
          #LET l_ac_t = l_ac   #FUN-D30033 mark                                                
           IF INT_FLAG THEN                                                    
              CALL cl_err('',9001,0)                                           
              LET INT_FLAG = 0                                                 
              IF p_cmd = 'u' THEN                                              
                 LET g_tqh[l_ac].* = g_tqh_t.*                                 
              #FUN-D30033--add--begin--
              ELSE
                 CALL g_tqh.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end----
              END IF
              CLOSE i219_bcl    
              ROLLBACK WORK                                                    
              EXIT INPUT                                                       
           END IF         
           LET l_ac_t = l_ac #FUN-D30033 add                                                     
           CLOSE i219_bcl
           COMMIT WORK                                                         
 
        ON ACTION CONTROLN
           CALL i219_b_askkey()
           EXIT INPUT
 
        ON ACTION CONTROLP                                                      
           CASE                                                                 
              WHEN INFIELD(tqh02)                #系列
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_tqa1"
                   LET g_qryparam.arg1 ="3"     
                   LET g_qryparam.default1 = g_tqh[l_ac].tqh02
                   CALL cl_create_qry() RETURNING g_tqh[l_ac].tqh02
                   DISPLAY BY NAME g_tqh[l_ac].tqh02
           END CASE
 
        ON ACTION CONTROLO                       #沿用所有欄位
            IF INFIELD(tqh02) AND l_ac > 1 THEN
                LET l_n = l_ac - 1
                LET g_tqh[l_ac].* = g_tqh[l_n].*
                NEXT FIELD tqh02
            END IF
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) 
                RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
        ON IDLE g_idle_seconds       
           CALL cl_on_idle()    
           CONTINUE INPUT      
 
        ON ACTION about         
           CALL cl_about()     
 
        ON ACTION help          
           CALL cl_show_help() 
 #NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END
     END INPUT
     CLOSE i219_bcl    
     COMMIT WORK
END FUNCTION
   
FUNCTION i219_b_askkey()
DEFINE
    l_wc            LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
    CONSTRUCT l_wc ON tqh02 FROM s_tqh[1].tqh02  #螢幕上取條件
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
     ON IDLE g_idle_seconds          
        CALL cl_on_idle()     
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
        CONTINUE CONSTRUCT    
 
     ON ACTION about     
        CALL cl_about()   
 
     ON ACTION help         
        CALL cl_show_help()  
 
     ON ACTION controlg    
        CALL cl_cmdask()   
 
    END CONSTRUCT       
    IF INT_FLAG THEN 
       LET INT_FLAG = 0
       RETURN 
    END IF
    CALL i219_b_fill(l_wc)
END FUNCTION
 
FUNCTION i219_b_fill(p_wc)   
DEFINE
    p_wc            LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
                                                                                
    LET g_sql ="SELECT tqh02,tqa02 FROM tqh_file,OUTER tqa_file ",
               " WHERE tqh_file.tqh02=tqa_file.tqa01",
               "   AND tqa03='3' AND tqaacti='Y'",
               "   AND tqh01='",g_tqh01,"'",
               "   AND ", p_wc CLIPPED ,
               " ORDER BY tqh02"
    PREPARE i219_p2 FROM g_sql                   #預備一下                                   
    DECLARE tqh_curs CURSOR FOR i219_p2       
    CALL g_tqh.clear()
    LET g_cnt = 1                                                               
    FOREACH tqh_curs INTO g_tqh[g_cnt].*         #單身 ARRAY 填充      
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
    CALL g_tqh.deleteElement(g_cnt)               
 
    LET g_rec_b = g_cnt - 1
    
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i219_bp(p_ud)
DEFINE
   p_ud            LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
                                                                                
   LET g_action_choice = " "                                                    
                                                                                
   CALL cl_set_act_visible("accept,cancel", FALSE)                              
   DISPLAY ARRAY g_tqh TO s_tqh.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)   
                                                                                
      BEFORE DISPLAY                                                            
         CALL cl_navigator_setting( g_curs_index, g_row_count )                 
                                                                                
      BEFORE ROW   
         LET l_ac = ARR_CURR()     
         CALL cl_show_fld_cont()           #MOD-B30199 add
      ON ACTION insert       
         LET g_action_choice="insert"    
         EXIT DISPLAY    
      ON ACTION query       
         LET g_action_choice="query"        
         EXIT DISPLAY          
      ON ACTION delete      
         LET g_action_choice="delete"      
         EXIT DISPLAY       
      ON ACTION first                                                           
         CALL i219_fetch('F')                                                   
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  
           END IF         
         EXIT DISPLAY       
                                                                                
      ON ACTION previous        
         CALL i219_fetch('P')          
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN               
            CALL fgl_set_arr_curr(1)                
           END IF           
         EXIT DISPLAY
                                                                                
      ON ACTION jump       
         CALL i219_fetch('/')         
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN      
            CALL fgl_set_arr_curr(1)                        
           END IF             
         EXIT DISPLAY 
      ON ACTION next       
         CALL i219_fetch('N')     
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN       
            CALL fgl_set_arr_curr(1) 
           END IF          
         EXIT DISPLAY   
                                                                                
      ON ACTION last        
         CALL i219_fetch('L')    
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN            
            CALL fgl_set_arr_curr(1)         
           END IF
         EXIT DISPLAY
 
      #No.TQC-7B0031  --Begin
      #ON ACTION invalid       
      #   LET g_action_choice="invalid"    
      #   EXIT DISPLAY             
      #No.TQC-7B0031  --End  
 
      ON ACTION detail    
         LET g_action_choice="detail"    
         LET l_ac = ARR_CURR()        
         EXIT DISPLAY      
    
      ON ACTION help       
         LET g_action_choice="help"     
         EXIT DISPLAY   
                                                                                
      ON ACTION locale     
         CALL cl_dynamic_locale()     
         CALL cl_show_fld_cont()           #MOD-B30199 add
         EXIT DISPLAY        
             
      ON ACTION exit      
         LET g_action_choice="exit"   
         EXIT DISPLAY      
      ON ACTION accept      
         LET g_action_choice="detail"        
         LET l_ac = ARR_CURR()    
         EXIT DISPLAY      
              
      ON ACTION cancel    
         LET g_action_choice="exit"    
         EXIT DISPLAY       
               
      ON ACTION close       
         LET g_action_choice="exit"    
         EXIT DISPLAY       
            
      ON ACTION controlg     
         LET g_action_choice="controlg"   
         EXIT DISPLAY        
            
      ON IDLE g_idle_seconds      
         CALL cl_on_idle()  
         CONTINUE DISPLAY                                                      
 
      ON ACTION about     
         CALL cl_about()  
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END      
      ON ACTION related_document                #No.FUN-6B0043  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY

      #MOD-B30199 add --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      #MOD-B30199 add --end--
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY   
   CALL cl_set_act_visible("accept,cancel", TRUE)   
      
END FUNCTION         
 
FUNCTION i219_set_entry(p_cmd)                                                  
DEFINE   p_cmd   LIKE type_file.chr1            #No.FUN-680120 VARCHAR(1)
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN                            
   END IF                
END FUNCTION    
 
FUNCTION i219_set_no_entry(p_cmd)                                               
DEFINE   p_cmd   LIKE type_file.chr1             #No.FUN-680120 VARCHAR(1)
   IF p_cmd = 'u' AND (NOT g_before_input_done) THEN  
   END IF
END FUNCTION
 
FUNCTION i219_tqh02(p_ac,p_key)
    DEFINE p_key    LIKE tqh_file.tqh02
    DEFINE p_ac     LIKE type_file.num5           #No.FUN-680120 SMALLINT
    DEFINE l_tqa02 LIKE tqa_file.tqa02
    
    SELECT tqa02 INTO l_tqa02 FROM tqa_file 
     WHERE tqa01 = p_key AND tqa03 = '3' AND tqaacti = 'Y' 
    IF SQLCA.sqlcode THEN
    #  CALL cl_err(p_key,SQLCA.sqlcode,0)  #No.FUN-660104
       CALL cl_err3("sel","tqa_file",p_key,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
    ELSE
       LET g_tqh[l_ac].tqa021 = l_tqa02
    END IF
 
    DISPLAY BY NAME g_tqh[l_ac].tqa021
 
END FUNCTION 
 
