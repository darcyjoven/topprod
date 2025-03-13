# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: atmi216.4gl
# Descriptions...: 組織架構維護作業 
# Date & Author..: 05/12/01 By yoyo 
# Modify.........: No.TQC-630069 06/03/07 By Smapmin 流程訊息通知功能
# Modify.........: No.TQC-640060 06/04/08 By yoyo 單身show資料沒有全部show出
# Modify.........: No.TQC-640469 06/04/13 By yoyo單身組織結構資料不存在可以過
# Modify.........: No.TQC-660071 06/06/14 By Smapmin 補充TQC-630069
# Modify.........: No.FUN-660104 06/06/19 By cl  Error Message 調整
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能 
# Modify.........: No.FUN-6B0043 06/11/24 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6C0217 06/12/29 By Rayven 連續點2次“核准生效”或“核准失效”并退出時，自動錄入了生效，失效日期
#                                                   下級渠道編號已被使用并失效日期為空時，在另一筆資料中再輸入該代碼時提示的錯誤信息不准確
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.MOD-860081 08/06/09 By jamie ON IDLE問題
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-B80061 11/08/05 By Lujh 模組程序撰寫規範修正
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30033 13/04/10 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_tqc          RECORD LIKE tqc_file.*,       
    g_tqc_t        RECORD LIKE tqc_file.*,      
    g_tqc_o        RECORD LIKE tqc_file.*,     
    g_tqc01_t      LIKE tqc_file.tqc01,         
    g_tqd          DYNAMIC ARRAY OF RECORD       
        tqd02       LIKE tqd_file.tqd02,          #項次
        tqd03       LIKE tqd_file.tqd03,          #下級組織機構代碼
        tqb021      LIKE tqb_file.tqb02,          #機構名稱
        tqd04       LIKE tqd_file.tqd04,          #所屬渠道
        tqa02       LIKE tqa_file.tqa02,          #渠道名稱
        tqd05       LIKE tqd_file.tqd05,          #生效日期 
        tqd06       LIKE tqd_file.tqd06           #失效日期  
                    END RECORD,                   
    g_tqd_t         RECORD                       
        tqd02       LIKE tqd_file.tqd02,          #項次               
        tqd03       LIKE tqd_file.tqd03,          #下級組織機構代碼  
        tqb021      LIKE tqb_file.tqb02,          #機構名稱
        tqd04       LIKE tqd_file.tqd04,          #所屬渠道         
        tqa02       LIKE tqa_file.tqa02,          #渠道名稱        
        tqd05       LIKE tqd_file.tqd05,          #生效日期        
        tqd06       LIKE tqd_file.tqd06           #失效日期       
                    END RECORD,                                        
    g_tqd_o         RECORD                      
        tqd02       LIKE tqd_file.tqd02,          #項次               
        tqd03       LIKE tqd_file.tqd03,          #下級組織機構代碼  
        tqb021      LIKE tqb_file.tqb02,          #機構名稱
        tqd04       LIKE tqd_file.tqd04,          #所屬渠道         
        tqa02       LIKE tqa_file.tqa02,          #渠道名稱        
        tqd05       LIKE tqd_file.tqd05,          #生效日期        
        tqd06       LIKE tqd_file.tqd06           #失效日期 
                    END RECORD,                                  
      
    g_wc,g_wc2,g_sql    LIKE type_file.chr1000,      #No.FUN-680120 VARCHAR(1000)
    g_rec_b         LIKE type_file.num5,             #單身筆數              #No.FUN-680120 SMALLINT
    g_n1            LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)     
    g_n2            LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)  
    l_ac            LIKE type_file.num5              #目前處理的ARRAY CNT   #No.FUN-680120 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5              #No.FUN-680120 SMALLINT
 
DEFINE   g_forupd_sql STRING                  #SELECT ... FOR UPDATE  SQL
DEFINE   g_before_input_done  LIKE type_file.num5     #No.FUN-680120 SMALLINT
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(72)
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   g_row_count     LIKE type_file.num10         #總筆數             #No.FUN-680120 INTEGER
DEFINE   g_jump          LIKE type_file.num10         #查詢指定的筆數     #No.FUN-680120 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #是否開啟指定筆視窗 #No.FUN-680120 SMALLINT
DEFINE   g_argv1         LIKE oea_file.oea01          #No.FUN-680120 VARCHAR(16)     #TQC-630069
DEFINE g_argv2         STRING     #TQC-630069
 
 
#主程式開始
MAIN
#     DEFINEl_time    LIKE type_file.chr8             #No.FUN-6B0014
 
    OPTIONS                                   #改變一些系統預設值       
        INPUT NO WRAP
    DEFER INTERRUPT                           #擷取中斷鍵, 由程式處理 
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 
    LET g_argv1 = ARG_VAL(1)   #TQC-630069
    LET g_argv2 = ARG_VAL(2)   #TQC-630069
 
 
    LET g_forupd_sql = "SELECT * FROM tqc_file WHERE tqc01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i216_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 2 LET p_col = 9
 
    OPEN WINDOW i216_w AT p_row,p_col         #顯示畫面
        WITH FORM "atm/42f/atmi216" ATTRIBUTE (STYLE = g_win_style)
    
    CALL cl_ui_init()
 
    #-----TQC-630069---------
    IF NOT cl_null(g_argv1) THEN
       CASE g_argv2
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL i216_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
             IF cl_chk_act_auth() THEN
                CALL i216_a()
             END IF
          OTHERWISE   #TQC-660071
             CALL i216_q()   #TQC-660071
       END CASE
    END IF
    #-----END TQC-630069-----
 
    LET g_n1 = 'N'              
    LET g_n2 = 'N'        
    CALL i216_menu()
    CLOSE WINDOW i216_w                        #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
#QBE 查詢資料 
FUNCTION i216_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   CLEAR FORM                                  #清除畫面
   CALL g_tqd.clear()
 
   IF cl_null(g_argv1) THEN   #TQC-630069 
   CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_tqc.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME g_wc ON tqc01,tqc02,tqc03,
                   tqcuser,tqcgrup,tqcmodu,tqcdate,tqcacti
 
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
      ON ACTION controlp                  
           CASE                            
             WHEN INFIELD(tqc01)           #上級機構代碼 
               CALL cl_init_qry_var()             
               LET g_qryparam.state = 'c'     
               LET g_qryparam.form ="q_tqb"     
               CALL cl_create_qry() RETURNING g_qryparam.multiret  
               DISPLAY g_qryparam.multiret TO tqc01              
               NEXT FIELD tqc01                       
               OTHERWISE EXIT CASE                       
            END CASE                         
   
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
     ON ACTION about         
        CALL cl_about()     
 
     ON ACTION help        
        CALL cl_show_help()
 
     ON ACTION controlg  
        CALL cl_cmdask()
 
   
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
   
   IF INT_FLAG THEN
      RETURN
   END IF
   #資料權限的檢查   
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料 
   #      LET g_wc = g_wc clipped," AND tqcuser = '",g_user,"'"
   #   END IF
   
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料 
   #      LET g_wc = g_wc clipped," AND tqcgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET g_wc = g_wc clipped," AND tqcgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('tqcuser', 'tqcgrup')
   #End:FUN-980030
 
   CONSTRUCT g_wc2 ON tqd02,tqd03,tqd04,tqd05,tqd06  #螢幕上取單身條件
           FROM s_tqd[1].tqd02,s_tqd[1].tqd03,
                s_tqd[1].tqd04,s_tqd[1].tqd05,
                s_tqd[1].tqd06
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        ON ACTION controlp 
           CASE           
              WHEN INFIELD(tqd03)    
                 CALL cl_init_qry_var() 
                 LET g_qryparam.state = 'c'     
                 LET g_qryparam.form ="q_tqb"     
                 CALL cl_create_qry() RETURNING g_qryparam.multiret     
                 DISPLAY g_qryparam.multiret TO tqd03
                 NEXT FIELD tqd03                            
              WHEN INFIELD(tqd04)                           
                 CALL cl_init_qry_var()                        
                 LET g_qryparam.state = 'c'  
                 LET g_qryparam.form ="q_tqa"                
                 LET g_qryparam.arg1 ="19"                
                 CALL cl_create_qry() RETURNING g_qryparam.multiret    
                 DISPLAY g_qryparam.multiret TO tqd04
                 NEXT FIELD tqd04                            
               OTHERWISE EXIT CASE                              
            END CASE                            
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
     ON ACTION about         
        CALL cl_about()     
 
     ON ACTION help        
        CALL cl_show_help()
 
     ON ACTION controlg     
        CALL cl_cmdask()   
 
		#No.FUN-580031 --start--     HCN
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
 
   IF INT_FLAG THEN
      RETURN
   END IF
   #-----TQC-630069---------
   ELSE
   LET g_wc = "tqc01 = '",g_argv1,"'"
   LET g_wc2 = " 1=1"
   END IF
   #-----END TQC-630069-----
 
 
   IF g_wc2 = " 1=1" THEN                  #若單身未輸入條件 
      LET g_sql = "SELECT  tqc01 FROM tqc_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY tqc01"
   ELSE                                    #若單身有輸入條件  
      LET g_sql = "SELECT  tqc01 ",
                  "  FROM tqc_file, tqd_file ",
                  " WHERE tqc01 = tqd01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY tqc01"
   END IF
 
   PREPARE i216_prepare FROM g_sql
   DECLARE i216_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i216_prepare
 
   IF g_wc2 = " 1=1" THEN                  #取合乎條件筆數 
      LET g_sql="SELECT COUNT(*) FROM tqc_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT tqc01) FROM tqc_file,tqd_file WHERE ",
                "tqd01=tqc01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE i216_precount FROM g_sql
   DECLARE i216_count CURSOR FOR i216_precount
 
END FUNCTION
 
FUNCTION i216_menu()
 
   WHILE TRUE
      CALL i216_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL i216_a()
            END IF
         WHEN "reproduce"                                                       
            IF cl_chk_act_auth() THEN                                           
               CALL i216_copy()                                                 
            END IF          
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i216_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i216_r()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i216_b()
            ELSE
               LET g_action_choice = NULL
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
                                      base.TypeInfo.create(g_tqd),'','')        
            END IF                   
         WHEN "confirm1"       
            IF cl_null(g_tqc.tqc02) AND cl_chk_act_auth() THEN 
               CALL i216_y1()    
            END IF 
         WHEN "confirm2"     
            IF cl_chk_act_auth() THEN
               CALL i216_y11() 
            END IF
         WHEN "invalidate1"  
            IF cl_null(g_tqc.tqc03) AND cl_chk_act_auth() THEN    
               CALL i216_y2() 
            END IF 
         WHEN "invalidate2"  
            IF cl_chk_act_auth() THEN
               CALL i216_y21()     
            END IF
         #No.FUN-6B0043-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_tqc.tqc01 IS NOT NULL THEN
                 LET g_doc.column1 = "tqc01"
                 LET g_doc.value1 = g_tqc.tqc01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6B0043-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i216_a()
 
   MESSAGE ""
   CLEAR FORM
   CALL g_tqd.clear()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_tqc.* LIKE tqc_file.*             #DEFAULT 設定
   LET g_tqc01_t = NULL
 
 
   #預設值及將數值類變數清成零   
   LET g_tqc_t.* = g_tqc.*
   LET g_tqc_o.* = g_tqc.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_tqc.tqcuser=g_user
      LET g_tqc.tqcoriu = g_user #FUN-980030
      LET g_tqc.tqcorig = g_grup #FUN-980030
      LET g_tqc.tqcgrup=g_grup
      LET g_tqc.tqcdate=g_today
      LET g_tqc.tqcacti='Y'                      #資料有效
 
      #-----TQC-630069---------
      IF NOT cl_null(g_argv1) AND (g_argv2 = "insert") THEN
         LET g_tqc.tqc01 = g_argv1
      END IF
      #-----END TQC-630069-----
 
      CALL i216_i("a")                              #輸入單頭
 
      IF INT_FLAG THEN                              #使用者不玩了
         INITIALIZE g_tqc.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_tqc.tqc01) THEN              #KEY 不可空白 
         CONTINUE WHILE
      END IF   
     
      INSERT INTO tqc_file VALUES (g_tqc.*)    
      IF SQLCA.sqlcode THEN     
         CALL cl_err3("ins","tqc_file",g_tqc.tqc01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104       #FUN-B80061   ADD
         ROLLBACK WORK    
      #  CALL cl_err(g_tqc.tqc01,SQLCA.sqlcode,1)       #No.FUN-660104
      #   CALL cl_err3("ins","tqc_file",g_tqc.tqc01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104      #FUN-B80061   MARK
         CONTINUE WHILE       
      ELSE          
         COMMIT WORK      
      END IF
 
      SELECT tqc01 INTO g_tqc.tqc01 FROM tqc_file 
       WHERE tqc01 = g_tqc.tqc01
      LET g_tqc01_t = g_tqc.tqc01        #保留舊值
      LET g_tqc_t.* = g_tqc.*
      LET g_tqc_o.* = g_tqc.*
      CALL g_tqd.clear()
 
      LET g_rec_b = 0  
      CALL i216_b()                           #輸入單身
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
 
FUNCTION i216_i(p_cmd)
DEFINE
   l_tqb02   LIKE tqb_file.tqb02,
   l_tqa02   LIKE tqa_file.tqa02,
   l_n            LIKE type_file.num5,          #No.FUN-680120 SMALLINT
   p_cmd          LIKE type_file.chr1           #No.FUN-680120 VARCHAR(1)
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_tqc.tqcuser,g_tqc.tqcmodu,g_tqc.tqcgrup,g_tqc.tqcoriu,g_tqc.tqcorig,
                   g_tqc.tqcdate,g_tqc.tqcacti 
   CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INPUT BY NAME g_tqc.tqc01
      WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i216_set_entry(p_cmd)
         CALL i216_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD tqc01                      
         IF NOT cl_null(g_tqc.tqc01) THEN 
            IF cl_null(g_tqc_o.tqc01) OR 
               (g_tqc.tqc01 != g_tqc_o.tqc01 ) THEN 
               CALL i216_tqc01('d')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_tqc.tqc01,g_errno,0)
                  LET g_tqc.tqc01 = g_tqc_o.tqc01
                  DISPLAY BY NAME g_tqc.tqc01
                  NEXT FIELD tqc01
               END IF
            END IF
            SELECT count(*) INTO l_n FROM tqc_file 
                WHERE tqc01 = g_tqc.tqc01 
                IF l_n > 0 THEN        
                  CALL cl_err(g_tqc.tqc01,-239,0) 
                  LET g_tqc.tqc01 = g_tqc01_t 
                  DISPLAY BY NAME g_tqc.tqc01    
                  NEXT FIELD tqc01                 
                END IF                                 
            SELECT count(*) INTO l_n FROM tqb_file    
                WHERE tqb01 = g_tqc.tqc01    
                  AND tqbacti = 'Y'     
                IF l_n = 0 THEN 
                  CALL cl_err('','atm-320',0)
                  LET g_tqc.tqc01 = g_tqc01_t  
                  DISPLAY BY NAME g_tqc.tqc01  
                  NEXT FIELD tqc01               
                END IF   
         END IF
 
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
 
      ON ACTION controlp
           CASE  
             WHEN INFIELD(tqc01) #上級機構代碼 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_tqb"
               LET g_qryparam.default1 = g_tqc.tqc01
               CALL cl_create_qry() RETURNING g_tqc.tqc01 
               DISPLAY  g_tqc.tqc01 TO  tqc01 
               CALL i216_tqc01('d')
               NEXT FIELD tqc01
               OTHERWISE EXIT CASE
            END CASE        
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
     ON ACTION about         
        CALL cl_about()     
 
     ON ACTION help        
        CALL cl_show_help()
 
   
   END INPUT
 
END FUNCTION
 
FUNCTION i216_y1()              
  DEFINE p_cmd   LIKE type_file.chr1              #No.FUN-680120 VARCHAR(1)
  DEFINE l_date1 LIKE type_file.dat,              #No.FUN-680120 DATE
         l_date2 LIKE type_file.dat               #No.FUN-680120 DATE                           
   IF s_shut(0) THEN            
      RETURN                    
   END IF                       
                                
   IF cl_null(g_tqc.tqc01) THEN 
      CALL cl_err('',-400,0)         
      RETURN                        
   END IF                          
 
   IF NOT cl_null(g_tqc.tqc02) THEN
      CALL cl_err('','atm-323',0)
      RETURN
   END IF
 
   IF NOT cl_null(g_tqc.tqc03) THEN  
      CALL cl_err('','atm-321',0)         
      RETURN                                                             
   END IF                                       
 
   BEGIN WORK                                             
                                                         
   OPEN i216_cl USING g_tqc.tqc01                    
   IF STATUS THEN                                      
      CALL cl_err("OPEN i216_cl:", STATUS, 1) 
      CLOSE i216_cl                          
      ROLLBACK WORK                         
      RETURN                               
   END IF                                 
                                         
   FETCH i216_cl INTO g_tqc.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN                                                      
       CALL cl_err(g_tqc.tqc01,SQLCA.sqlcode,0)    # 資料被他人LOCK   
       CLOSE i216_cl                                                        
       ROLLBACK WORK
       RETURN                   
   END IF                       
                                
   CALL i216_show()             
                                
   WHILE TRUE                   
      LET g_tqc01_t = g_tqc.tqc01 
      LET g_tqc_o.* = g_tqc.*            
      LET g_tqc.tqcmodu=g_user          
      LET g_tqc.tqcdate=g_today     
      LET g_tqc.tqc02=s_first(g_today)
 
   INPUT BY NAME g_tqc.tqc02  
      WITHOUT DEFAULTS             
 
      AFTER FIELD tqc02       
       IF NOT cl_null(g_tqc.tqc02) THEN  
         LET l_date1 = DAY(g_tqc.tqc02) 
         IF l_date1 <> 1 THEN                 
            CALL cl_err('','atm-322',0)   
            DISPLAY BY NAME g_tqc.tqc02
            NEXT FIELD tqc02             
         END IF                             
       END IF                              
 
     #MOD-860081------add-----str---
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
      
      ON ACTION about         
         CALL cl_about()      
      
      ON ACTION controlg      
         CALL cl_cmdask()     
      
      ON ACTION help          
         CALL cl_show_help()  
     #MOD-860081------add-----end---
 
   END INPUT               
 
#No.TQC-6C0217 --start-- mark
#     UPDATE tqc_file SET tqc_file.tqc02 = g_tqc.tqc02    
#      WHERE tqc01 = g_tqc.tqc01                                       
#No.TQC-6C0217 --end--
                                                                         
      IF INT_FLAG THEN                                                  
         LET INT_FLAG = 0                                              
         LET g_tqc.*=g_tqc_t.*                                  
         CALL i216_show()                                            
         CALL cl_err('','9001',0)                                   
         EXIT WHILE                                                
      END IF                                                      
 
      #No.TQC-6C0217 --start--                                                                                                      
      UPDATE tqc_file SET tqc_file.tqc02 = g_tqc.tqc02                                                                              
       WHERE tqc01 = g_tqc.tqc01                                                                                                    
      #No.TQC-6C0217 --end--                      
                                           
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN            
      #  CALL cl_err("",SQLCA.sqlcode,0)                         #No.FUN-660104
         CALL cl_err3("upd","tqc_file",g_tqc.tqc01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
         CONTINUE WHILE                                      
      END IF                                                
                                                           
    CLOSE i216_cl                                         
                                                         
    COMMIT WORK                                         
    EXIT WHILE                                         
  END WHILE                                           
END FUNCTION                                        
 
FUNCTION i216_y11()                          
  DEFINE p_cmd   LIKE type_file.chr1                        #No.FUN-680120 VARCHAR(1)
                                         
   IF s_shut(0) THEN                    
      RETURN                           
   END IF                             
                                     
   IF cl_null(g_tqc.tqc01) THEN        
      CALL cl_err('',-400,0)                
      RETURN                               
   END IF                                 
   
   IF cl_null(g_tqc.tqc02) THEN
      CALL cl_err('','atm-324',0)
      RETURN
   END IF
                                         
   IF NOT cl_null(g_tqc.tqc03) THEN                         
      CALL cl_err('','atm-321',0)                                
      RETURN                                  
   END IF                                    
 
   BEGIN WORK                                                 
                                                             
   OPEN i216_cl USING g_tqc.tqc01                        
   IF STATUS THEN                                          
      CALL cl_err("OPEN i216_cl:", STATUS, 1)             
      CLOSE i216_cl                                      
      ROLLBACK WORK    
      RETURN          
   END IF            
                    
   FETCH i216_cl INTO g_tqc.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN                                                      
       CALL cl_err(g_tqc.tqc01,SQLCA.sqlcode,0)    # 資料被他人LOCK   
       CLOSE i216_cl                                                        
       ROLLBACK WORK                                               
       RETURN                                                     
   END IF                                                        
                                                                
   CALL i216_show()                                            
                                                              
   WHILE TRUE                                                
      LET g_tqc01_t = g_tqc.tqc01                
      LET g_tqc_o.* = g_tqc.*                        
      LET g_tqc.tqcmodu=g_user                      
      LET g_tqc.tqcdate=g_today                   
                                                       
      LET g_tqc.tqc02= NULL                 
      DISPLAY BY NAME g_tqc.tqc02         
                                                   
      UPDATE tqc_file SET tqc02 = g_tqc.tqc02           
       WHERE tqc01 = g_tqc.tqc01                                  
                                                                    
      IF INT_FLAG THEN                                             
         LET INT_FLAG = 0                                         
         LET g_tqc.*=g_tqc_t.*                             
         CALL i216_show()                                       
         CALL cl_err('','9001',0)                              
         EXIT WHILE                                           
      END IF                                                 
                                                            
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN        
      #  CALL cl_err("",SQLCA.sqlcode,0)                     #No.FUN-660104
         CALL cl_err3("upd","tqc_file",g_tqc.tqc01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
         CONTINUE WHILE                                  
      END IF                    
                               
    CLOSE i216_cl             
                             
    COMMIT WORK  #No.TQC-6C0217
    EXIT WHILE              
  END WHILE                
END FUNCTION             
 
FUNCTION i216_y2()                                
  DEFINE p_cmd   LIKE type_file.chr1,                   #No.FUN-680120 VARCHAR(1)
         l_date        LIKE type_file.dat,              #No.FUN-680120 DATE
         l_date2       LIKE type_file.dat,              #No.FUN-680120 DATE
         l_day         LIKE type_file.dat               #No.FUN-680120 DATE                            
   IF s_shut(0) THEN            
      RETURN                    
   END IF                       
                             
   IF cl_null(g_tqc.tqc01) THEN    
      CALL cl_err('',-400,0)            
      RETURN                           
   END IF                             
                                    
   IF cl_null(g_tqc.tqc02) THEN     
      CALL cl_err('','atm-325',0)            
      RETURN                                
   END IF     
 
   IF NOT cl_null(g_tqc.tqc03) THEN
      CALL cl_err('','atm-321',0)
      RETURN
   END IF
 
   BEGIN WORK                                                 
                                                             
   OPEN i216_cl USING g_tqc.tqc01                        
   IF STATUS THEN                                          
      CALL cl_err("OPEN i216_cl:", STATUS, 1)             
      CLOSE i216_cl                                      
      ROLLBACK WORK                                     
      RETURN                    
   END IF                       
                                
   FETCH i216_cl INTO g_tqc.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN                                                      
       CALL cl_err(g_tqc.tqc01,SQLCA.sqlcode,0)    # 資料被他人LOCK   
       CLOSE i216_cl                                     
       ROLLBACK WORK                                    
       RETURN                                          
   END IF                                             
                                                     
   CALL i216_show()                                 
                                                   
   WHILE TRUE                                     
      LET g_tqc01_t = g_tqc.tqc01     
      LET g_tqc_o.* = g_tqc.*             
      LET g_tqc.tqcmodu=g_user           
      LET g_tqc.tqcdate=g_today 
      LET g_tqc.tqc03=s_last(g_today)      
                                     
   INPUT BY NAME g_tqc.tqc03             
       WITHOUT DEFAULTS                        
                                              
      AFTER FIELD tqc03            
       IF NOT cl_null(g_tqc.tqc03) THEN 
          LET l_date2 = DAY(g_tqc.tqc03)
          LET l_date  = s_last(g_tqc.tqc03)  
          LET l_day   = DAY(l_date)                
          IF l_date2 <> l_day  THEN               
             CALL cl_err('','atm-326',0)   
             DISPLAY BY NAME g_tqc.tqc03  
             NEXT FIELD tqc03               
          END IF                               
       END IF                                                                                                                       
       IF NOT cl_null(g_tqc.tqc03) THEN   
          IF (g_tqc.tqc03 < g_tqc.tqc02) THEN  
                 CALL cl_err(g_tqc.tqc03,'mfg3009',0)  
                 NEXT FIELD tqc03                     
              END IF                                     
          END IF                                       
 
      #MOD-860081------add-----str---
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
       
       ON ACTION about         
          CALL cl_about()      
       
       ON ACTION controlg      
          CALL cl_cmdask()     
       
       ON ACTION help          
          CALL cl_show_help()  
      #MOD-860081------add-----end---
 
   END INPUT                       
 
  #No.TQC-6C0217 --start--  mark
  #   UPDATE tqc_file SET tqc_file.* = g_tqc.*
  #    WHERE tqc01 = g_tqc.tqc01                   
  #No.TQC-6C0217 --end-- 
                                                     
      IF INT_FLAG THEN                              
         LET INT_FLAG = 0                          
         LET g_tqc.*=g_tqc_t.*              
         CALL i216_show()                        
         CALL cl_err('','9001',0)               
         EXIT WHILE                            
      END IF   
                                
      #No.TQC-6C0217 --start--                                                                                                      
      UPDATE tqc_file SET tqc_file.* = g_tqc.*                                                                                      
       WHERE tqc01 = g_tqc.tqc01                                                                                                    
      #No.TQC-6C0217 --end--
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN    
      #  CALL cl_err("",SQLCA.sqlcode,0)              
         CALL cl_err3("upd","tqc_file",g_tqc.tqc01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
         CONTINUE WHILE                              
      END IF                                        
     CLOSE i216_cl                                 
    COMMIT WORK                                   
    EXIT WHILE                                   
  END WHILE                                     
END FUNCTION                           
 
FUNCTION i216_y21()      
  DEFINE p_cmd   LIKE type_file.chr1              #No.FUN-680120 VARCHAR(1)
                               
   IF s_shut(0) THEN          
      RETURN                 
   END IF                   
                           
   IF cl_null(g_tqc.tqc01) THEN             
      CALL cl_err('',-400,0)                     
      RETURN                                    
   END IF                                      
   
   IF cl_null(g_tqc.tqc03) THEN
      CALL cl_err('','atm-327',0)
      RETURN
   END IF
 
                                
   BEGIN WORK                   
                               
   OPEN i216_cl USING g_tqc.tqc01                    
   IF STATUS THEN                                      
      CALL cl_err("OPEN i216_cl:", STATUS, 1)         
      CLOSE i216_cl                                  
      ROLLBACK WORK                                 
      RETURN                                       
   END IF                                         
                                                 
   FETCH i216_cl INTO g_tqc.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN                                                      
       CALL cl_err(g_tqc.tqc01,SQLCA.sqlcode,0)    # 資料被他人LOCK   
       CLOSE i216_cl                                                        
       ROLLBACK WORK                                                       
       RETURN                                                             
   END IF                                                     
   CALL i216_show()    
                      
   WHILE TRUE        
      LET g_tqc01_t = g_tqc.tqc01       
      LET g_tqc_o.* = g_tqc.*               
      LET g_tqc.tqcmodu=g_user             
      LET g_tqc.tqcdate=g_today           
                                               
      LET g_tqc.tqc03=''            
      DISPLAY BY NAME g_tqc.tqc03  
                                            
      UPDATE tqc_file SET tqc_file.* = g_tqc.*        
       WHERE tqc01 = g_tqc.tqc01                           
                                                             
      IF INT_FLAG THEN                                      
         LET INT_FLAG = 0                                  
         LET g_tqc.*=g_tqc_t.*                      
         CALL i216_show()                                
         CALL cl_err('','9001',0)                       
         EXIT WHILE                     
      END IF               
                          
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN       
      #  CALL cl_err("",SQLCA.sqlcode,0)                    #No.FUN-660104
         CALL cl_err3("upd","tqc_file",g_tqc.tqc01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
         CONTINUE WHILE                                 
      END IF                                           
     CLOSE i216_cl                                    
    COMMIT WORK                                      
    EXIT WHILE                                      
  END WHILE                                       
END FUNCTION          
                                 
FUNCTION i216_tqc01(p_cmd)  
   DEFINE l_tqb02   LIKE tqb_file.tqb02, 
          l_tqbacti LIKE tqb_file.tqbacti,  
          p_cmd   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   LET g_errno = " "
   SELECT tqb02,tqbacti
     INTO l_tqb02,l_tqbacti
     FROM tqb_file WHERE tqb01 = g_tqc.tqc01 
 
   CASE WHEN SQLCA.SQLCODE = 100  
                           LET l_tqb02 = NULL
        WHEN l_tqbacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_tqb02 TO FORMONLY.tqb02 
   END IF
 
END FUNCTION
   
 
FUNCTION i216_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_tqc.* TO NULL              #No.FUN-6B0043
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_tqd.clear()
   DISPLAY ' ' TO FORMONLY.cnt  
 
   CALL i216_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_tqc.* TO NULL
      RETURN
   END IF
 
   OPEN i216_cs                            #從DB產生合乎條件TEMP(0-30秒) 
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_tqc.* TO NULL
   ELSE
      OPEN i216_count
      FETCH i216_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
 
      CALL i216_fetch('F')                  #讀出TEMP第一筆并顯示 
   END IF
 
END FUNCTION
 
FUNCTION i216_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680120 VARCHAR(1)
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i216_cs INTO g_tqc.tqc01
      WHEN 'P' FETCH PREVIOUS i216_cs INTO g_tqc.tqc01
      WHEN 'F' FETCH FIRST    i216_cs INTO g_tqc.tqc01
      WHEN 'L' FETCH LAST     i216_cs INTO g_tqc.tqc01
      WHEN '/'
            IF (NOT mi_no_ask) THEN
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
            FETCH ABSOLUTE g_jump i216_cs INTO g_tqc.tqc01
            LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tqc.tqc01,SQLCA.sqlcode,0)
      INITIALIZE g_tqc.* TO NULL  #TQC-6B0105
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
 
   SELECT * INTO g_tqc.* FROM tqc_file WHERE tqc01 = g_tqc.tqc01
   IF SQLCA.sqlcode THEN
   #  CALL cl_err(g_tqc.tqc01,SQLCA.sqlcode,0)   #No.FUN-660104
      CALL cl_err3("sel","tqc_file",g_tqc.tqc01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
      INITIALIZE g_tqc.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_tqc.tqcuser      
   LET g_data_group = g_tqc.tqcgrup     
 
   CALL i216_show()
 
END FUNCTION
 
#將資料顯示在畫面上 
FUNCTION i216_show()
   LET g_tqc_t.* = g_tqc.*                #保存單頭舊值 
   LET g_tqc_o.* = g_tqc.*                #保存單頭舊值 
   DISPLAY BY NAME g_tqc.tqc01,g_tqc.tqc02,g_tqc.tqc03, 
                   g_tqc.tqcuser,g_tqc.tqcgrup,g_tqc.tqcmodu,
                   g_tqc.tqcdate,g_tqc.tqcacti
       
   CALL i216_tqc01('d')
 
   CALL i216_b_fill(g_wc2)                 #單身
 
END FUNCTION
 
FUNCTION i216_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_tqc.tqc01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   
   SELECT * INTO g_tqc.* FROM tqc_file
    WHERE tqc01=g_tqc.tqc01
 
   IF g_tqc.tqc02 < g_today AND g_tqc.tqc03 > g_today THEN
      IF NOT cl_confirm("atm-216") THEN 
         RETURN
      END IF
   END IF
      
   BEGIN WORK
 
   OPEN i216_cl USING g_tqc.tqc01
   IF STATUS THEN
      CALL cl_err("OPEN i216_cl:", STATUS, 1)
      CLOSE i216_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i216_cl INTO g_tqc.*               #鎖住將被更改或取消的資料  
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tqc.tqc01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i216_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "tqc01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_tqc.tqc01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM tqc_file WHERE tqc01 = g_tqc.tqc01
      DELETE FROM tqd_file WHERE tqd01 = g_tqc.tqc01
      CLEAR FORM
      CALL g_tqd.clear()
      OPEN i216_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE i216_cs
         CLOSE i216_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH i216_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i216_cs
         CLOSE i216_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i216_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i216_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL i216_fetch('/')
      END IF
   END IF
 
   CLOSE i216_cl
   COMMIT WORK
   CALL cl_flow_notify(g_tqc.tqc01,'D') 
END FUNCTION
 
FUNCTION i216_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT    #No.FUN-680120 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重復用           #No.FUN-680120 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重復用           #No.FUN-680120 SMALLINT
    l_lock_sw       LIKE type_file.chr1,              #單身鎖住否             #No.FUN-680120 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,              #處理狀態               #No.FUN-680120 VARCHAR(1) #TQC-840066
    l_allow_insert  LIKE type_file.num5,                #可新增否             #No.FUN-680120 SMALLINT
    l_allow_delete  LIKE type_file.num5,                #可刪除否             #No.FUN-680120 SMALLINT
    l_date1         LIKE type_file.dat,              #No.FUN-680120 DATE
    l_date2         LIKE type_file.dat,              #No.FUN-680120 DATE
    l_date          LIKE type_file.dat,              #No.FUN-680120 DATE
    l_day           LIKE type_file.dat,              #No.FUN-680120 DATE  
    l_tqd06         LIKE tqd_file.tqd06,  
    l_tqd05         LIKE tqd_file.tqd05
    LET g_action_choice = ""
 
    IF s_shut(0) THEN 
       RETURN
    END IF
 
    IF cl_null(g_tqc.tqc01) THEN
       RETURN
    END IF
 
    IF NOT cl_null(g_tqc.tqc03) THEN      
       CALL cl_err('','atm-328',0)             
       RETURN                                                                  
    END IF             
 
    SELECT * INTO g_tqc.* FROM tqc_file
     WHERE tqc01 = g_tqc.tqc01
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT tqd02,tqd03,'',tqd04,'',",
                       "       tqd05,tqd06 FROM tqd_file",
                       " WHERE tqd01=? AND tqd02=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i216_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_tqd WITHOUT DEFAULTS FROM s_tqd.*
           ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                     APPEND ROW=l_allow_insert)   
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN i216_cl USING g_tqc.tqc01
           IF STATUS THEN
              CALL cl_err("OPEN i216_cl:", STATUS, 1)
              CLOSE i216_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i216_cl INTO g_tqc.*          
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_tqc.tqc01,SQLCA.sqlcode,0)   
              CLOSE i216_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_tqd_t.* = g_tqd[l_ac].*  
              LET g_tqd_o.* = g_tqd[l_ac].* 
              OPEN i216_bcl USING g_tqc.tqc01,g_tqd_t.tqd02
              IF STATUS THEN
                 CALL cl_err("OPEN i216_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i216_bcl INTO g_tqd[l_ac].* 
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_tqd_t.tqd02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 ELSE
                    CALL i216_tqd03('d')
                    CALL i216_tqd04('d')
                 END IF
              END IF
           END IF
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_tqd[l_ac].* TO NULL   
           LET g_tqd_t.* = g_tqd[l_ac].*      
           LET g_tqd_o.* = g_tqd[l_ac].*     
           NEXT FIELD tqd02 
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF g_tqd[l_ac].tqd03 IS NOT NULL THEN    
              CALL i216_tqd03('d') 
              IF NOT cl_null(g_errno) THEN           
                   CALL cl_err('tqd03:',g_errno,0)  
                   LET g_tqd[l_ac].tqd03 = g_tqd_t.tqd03 
                   NEXT FIELD tqd03               
              END IF                               
              CALL i216_check()                   
              IF NOT cl_null(g_errno) THEN       
                  CALL cl_err('',g_errno,0)      
                  LET g_tqd[l_ac].* = g_tqd_t.* 
                  NEXT FIELD tqd05         
              END IF                         
           END IF                                   
           INSERT INTO tqd_file(tqd01,tqd02,tqd03,tqd04,tqd05,tqd06)
           VALUES(g_tqc.tqc01,g_tqd[l_ac].tqd02,
                  g_tqd[l_ac].tqd03,g_tqd[l_ac].tqd04,
                  g_tqd[l_ac].tqd05,g_tqd[l_ac].tqd06)
           IF SQLCA.sqlcode THEN
           #  CALL cl_err(g_tqd[l_ac].tqd02,SQLCA.sqlcode,0)   #No.FUN-660104
              CALL cl_err3("ins","tqd_file",g_tqd[l_ac].tqd02,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK 
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  
           END IF
 
        BEFORE FIELD tqd02                        #default 序號
           IF cl_null(g_tqd[l_ac].tqd02) OR g_tqd[l_ac].tqd02 = 0 THEN
              SELECT max(tqd02)+1
                INTO g_tqd[l_ac].tqd02
                FROM tqd_file
               WHERE tqd01 = g_tqc.tqc01
              IF cl_null(g_tqd[l_ac].tqd02) THEN
                 LET g_tqd[l_ac].tqd02 = 1
              END IF
           END IF
 
        AFTER FIELD tqd02                        #check 序號是否重復
           IF NOT cl_null(g_tqd[l_ac].tqd02) THEN
              IF g_tqd[l_ac].tqd02 != g_tqd_t.tqd02 
                 OR cl_null(g_tqd_t.tqd02) THEN
                 SELECT count(*)
                   INTO l_n
                   FROM tqd_file
                  WHERE tqd01 = g_tqc.tqc01 
                    AND tqd02 = g_tqd[l_ac].tqd02
                 IF l_n > 0 THEN
                    CALL cl_err('','atm-310',0)
                    LET g_tqd[l_ac].tqd02 = g_tqd_t.tqd02
                    NEXT FIELD tqd02
                 END IF
              END IF
           END IF
 
         AFTER FIELD tqd03 
            IF NOT cl_null(g_tqd[l_ac].tqd03) THEN   
               CALL i216_tqd03('d')       
               IF NOT cl_null(g_errno) THEN         
                  CALL cl_err(g_tqd[l_ac].tqd03,g_errno,0) 
                  LET g_tqd[l_ac].tqd03 = g_tqd_o.tqd03 
                  DISPLAY BY NAME g_tqd[l_ac].tqd03        
                  NEXT FIELD tqd03                  
               END IF                                
               IF g_tqd[l_ac].tqd03 = g_tqc.tqc01 THEN
                  CALL cl_err('','axm-298',0)           
                  LET g_tqd[l_ac].tqd03= g_tqd_t.tqd03  
                  NEXT FIELD tqd03                               
               END IF                                                
               IF g_tqd[l_ac].tqd03 != g_tqd_t.tqd03 OR   
                 cl_null(g_tqd_t.tqd03) THEN  
                 SELECT COUNT(*) INTO l_cnt FROM tqd_file         
                  WHERE tqd03 = g_tqd[l_ac].tqd03        
                    AND tqd05 LIKE "%"              
                    AND tqd06 IS NULL              
                    IF l_cnt>0 THEN                  
#                      CALL cl_err('','atm-330',0)  #No.TQC-6C0217 mark
                       CALL cl_err('','atm-559',0)  #No.TQC-6C0217
                       LET g_tqd[l_ac].tqd03 = g_tqd_t.tqd03    
                       NEXT FIELD tqd03                                  
                    END IF                                                  
               END IF                                                    
            END IF 
 
         AFTER FIELD tqd04    
            IF NOT cl_null(g_tqd[l_ac].tqd04) THEN  
               CALL i216_tqd04('d') 
               IF NOT cl_null(g_errno) THEN     
                  CALL cl_err(g_tqd[l_ac].tqd04,g_errno,0)     
                  LET g_tqd[l_ac].tqd04 = g_tqd_o.tqd04        
                  DISPLAY BY NAME g_tqd[l_ac].tqd04          
                  NEXT FIELD tqd04                     
               END IF                                
            END IF           
 
        BEFORE FIELD tqd05 
           IF cl_null(g_tqd[l_ac].tqd05) THEN 
              LET g_tqd[l_ac].tqd05=s_first(g_today)
           END IF 
 
        AFTER FIELD tqd05             
            IF NOT cl_null(g_tqd[l_ac].tqd06) THEN       
              IF (g_tqd[l_ac].tqd06 < g_tqd[l_ac].tqd05) THEN   
                 CALL cl_err(g_tqd[l_ac].tqd06,'mfg3009',0)           
                 NEXT FIELD tqd05                                       
              END IF                                                       
            END IF
 
           IF NOT cl_null(g_tqd[l_ac].tqd05) THEN      
            LET l_date1 = DAY(g_tqd[l_ac].tqd05)   
            IF l_date1 <> 1 THEN        
               CALL cl_err('','atm-322',0)           
               DISPLAY BY NAME g_tqd[l_ac].tqd05    
               NEXT FIELD tqd05                   
            END IF           
            #No.TQC-6C0217 --start--
            LET l_tqd05 = g_tqd[l_ac].tqd05
#           SELECT tqd06 INTO l_tqd06
#             FROM tqd_file
#            WHERE tqd03 = g_tqd[l_ac].tqd03
#              AND tqd06 IS NOT NULL
            IF p_cmd = 'u' THEN
               SELECT max(tqd06) INTO l_tqd06
                 FROM tqd_file
                WHERE tqd03 = g_tqd[l_ac].tqd03
                  AND tqd06 < l_tqd05
            END IF
            IF p_cmd = 'a' THEN
               SELECT max(tqd06) INTO l_tqd06
                 FROM tqd_file
                WHERE tqd03 = g_tqd[l_ac].tqd03
                  AND tqd06 IS NOT NULL
            END IF
            #No.TQC-6C0217 --end--
            IF g_tqd[l_ac].tqd05 < l_tqd06 THEN
#              CALL cl_err('','atm-330',0) #No.TQC-6C0217 mark
               CALL cl_err('','atm-560',0) #No.TQC-6C0217
               DISPLAY BY NAME g_tqd[l_ac].tqd05
               NEXT FIELD tqd05
            END IF
           END IF                                                         
           
 
        AFTER FIELD tqd06                                            
           IF NOT cl_null(g_tqd[l_ac].tqd06) THEN                
             IF NOT cl_null(g_tqd[l_ac].tqd05) THEN   
              IF (g_tqd[l_ac].tqd06 < g_tqd[l_ac].tqd05) THEN 
                 CALL cl_err(g_tqd[l_ac].tqd06,'mfg3009',0)         
                 NEXT FIELD tqd06                                     
              END IF                                
             END IF   
             LET l_date2 = DAY(g_tqd[l_ac].tqd06)    
             LET l_date  = s_last(g_tqd[l_ac].tqd06)             
             LET l_day   = DAY(l_date)                        
             IF l_date2 <> l_day  THEN 
                CALL cl_err('','atm-326',0)                      
                DISPLAY BY NAME g_tqd[l_ac].tqd06             
                NEXT FIELD tqd06  
             END IF                       
           END IF        
 
            CALL i216_check()                #判斷時間是否有誤或重復
            IF NOT cl_null(g_errno) THEN                          
               CALL cl_err('',g_errno,0)                         
               NEXT FIELD tqd05                             
            END IF                                         
 
        BEFORE DELETE                      #是否取消單身
           DISPLAY "BEFORE DELETE" 
           IF g_tqd_t.tqd02 > 0 AND NOT cl_null(g_tqd_t.tqd02) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN 
                 CALL cl_err("", -263, 1) 
                 CANCEL DELETE 
              END IF 
              DELETE FROM tqd_file
               WHERE tqd01 = g_tqc.tqc01
                 AND tqd02 = g_tqd_t.tqd02
              IF SQLCA.sqlcode THEN
              #  CALL cl_err(g_tqd_t.tqd02,SQLCA.sqlcode,0)   #No.FUN-660104
                 CALL cl_err3("del","tqd_file",g_tqd_t.tqd02,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
                 ROLLBACK WORK
                 CANCEL DELETE 
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2  
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_tqd[l_ac].* = g_tqd_t.*
              CLOSE i216_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF g_tqd[l_ac].tqd03 IS NOT NULL THEN 
              CALL i216_tqd03('d')  
              IF NOT cl_null(g_errno) THEN                    
                   CALL cl_err('tqd03:',g_errno,0)       
                   LET g_tqd[l_ac].tqd03 = g_tqd_t.tqd03 
                   NEXT FIELD tqd03                                                                                             
               END IF                                           
               CALL i216_check()                               
               IF NOT cl_null(g_errno) THEN                   
                  CALL cl_err('',g_errno,0)                  
                  LET g_tqd[l_ac].* = g_tqd_t.*             
                  NEXT FIELD tqd05                     
               END IF                                     
           END IF                                    
 
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_tqd[l_ac].tqd02,-263,1)
              LET g_tqd[l_ac].* = g_tqd_t.*
           ELSE
              UPDATE tqd_file SET tqd02=g_tqd[l_ac].tqd02,
                                     tqd03=g_tqd[l_ac].tqd03,
                                     tqd04=g_tqd[l_ac].tqd04,
                                     tqd05=g_tqd[l_ac].tqd05,
                                     tqd06=g_tqd[l_ac].tqd06
               WHERE tqd01=g_tqc.tqc01
                 AND tqd02=g_tqd_t.tqd02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              #  CALL cl_err(g_tqd[l_ac].tqd02,SQLCA.sqlcode,0)   #No.FUN-660104
                 CALL cl_err3("upd","tqd_file",g_tqd_t.tqd02,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
                 LET g_tqd[l_ac].* = g_tqd_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK 
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac  #FUN-D30033 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN 
                 LET g_tqd[l_ac].* = g_tqd_t.*
              #FUN-D30033--add--begin--
              ELSE
                 CALL g_tqd.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end----
              END IF 
              CLOSE i216_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac  #FUN-D30033 add
           CLOSE i216_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO                     
           IF INFIELD(tqd02) AND l_ac > 1 THEN
              LET g_tqd[l_ac].* = g_tqd[l_ac-1].*
              LET g_tqd[l_ac].tqd02 = g_rec_b + 1 
              NEXT FIELD tqd02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(tqd03) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_tqb"
                 LET g_qryparam.default1 = g_tqd[l_ac].tqd03        
                 CALL cl_create_qry() RETURNING g_tqd[l_ac].tqd03
                 CALL i216_tqd03('d')
                 DISPLAY g_tqd[l_ac].tqd03 TO s_tqd[l_ac].tqd03 
                 NEXT FIELD tqd03
              WHEN INFIELD(tqd04)                 
                 CALL cl_init_qry_var()           
                 LET g_qryparam.form ="q_tqa"    
                 LET g_qryparam.arg1 ="19"    
                 CALL cl_create_qry() RETURNING g_tqd[l_ac].tqd04
                 CALL i216_tqd04('d')  
                 DISPLAY g_tqd[l_ac].tqd04 TO s_tqd[l_ac].tqd04 
                 NEXT FIELD tqd04                  
               OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
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
 
    CLOSE i216_bcl
    COMMIT WORK
#   CALL i216_delall() #CHI-C30002 mark
    CALL i216_delHeader()     #CHI-C30002 add
 
END FUNCTION
   
#CHI-C30002 -------- add -------- begin
FUNCTION i216_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM  tqc_file WHERE tqc01 = g_tqc.tqc01
         INITIALIZE g_tqc.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION i216_delall()
#
#   SELECT COUNT(*) INTO g_cnt FROM tqd_file
#    WHERE tqd01 = g_tqc.tqc01
#
#   IF g_cnt = 0 THEN                   # 未輸入單身資料, 是否取消單頭資料 
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM tqc_file WHERE tqc01 = g_tqc.tqc01
#   END IF
#
#END FUNCTION
#CHI-C30002 -------- mark -------- end
   
FUNCTION i216_tqd03(p_cmd)  #機構代碼
    DEFINE l_tqb02    LIKE tqb_file.tqb02,
           l_tqbacti   LIKE tqb_file.tqbacti, 
           p_cmd       LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT tqb02,tqbacti 
      INTO l_tqb02,l_tqbacti  
      FROM tqb_file 
      WHERE tqb01 = g_tqd[l_ac].tqd03 
 
    CASE WHEN SQLCA.SQLCODE = 100   
                            LET l_tqb02 = NULL     
                            LET g_errno='mfg9329'    #NO.MOD-640469
         WHEN l_tqbacti='N' LET g_errno = '9028'   
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'      
    END CASE                          
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN      
    LET g_tqd[l_ac].tqb021 = l_tqb02
   END IF
END FUNCTION
 
FUNCTION i216_tqd04(p_cmd)  #對應渠道
   DEFINE l_tqa02   LIKE tqa_file.tqa02 
   DEFINE p_cmd     LIKE type_file.chr1            #No.FUN-680120 VARCHAR(1)
   DEFINE l_tqaacti  LIKE tqa_file.tqaacti
  LET g_errno = " "
  SELECT tqa02,tqaacti INTO l_tqa02,l_tqaacti FROM tqa_file    
                WHERE tqa01 = g_tqd[l_ac].tqd04
                  AND tqa03 = '19'
 
    CASE WHEN SQLCA.SQLCODE = 100 
                            LET l_tqa02 = NULL    
                            LET g_errno='mfg9329'    #NO.MOD-640469
         WHEN l_tqaacti='N' LET g_errno = '9028' 
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'    
    END CASE                 
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN      
      LET g_tqd[l_ac].tqa02 = l_tqa02
   END IF
 
END FUNCTION 
   
FUNCTION i216_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON tqd02,tqd03,tqd04,
                       tqd05,tqd06
            FROM s_tqd[1].tqd02,s_tqd[1].tqd03,
                 s_tqd[1].tqd04,s_tqd[1].tqd05,
                 s_tqd[1].tqd06
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
     ON ACTION about         
        CALL cl_about()   
 
     ON ACTION help      
        CALL cl_show_help()  
 
     ON ACTION controlg     
        CALL cl_cmdask()   
 
    
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
 
    CALL i216_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION i216_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
#No.TQC-640060--start    
    LET g_sql = "SELECT tqd02,tqd03,' ',tqd04,' ',tqd05,tqd06",
                " FROM tqd_file",
                " WHERE tqd01 ='",g_tqc.tqc01,"' "   
#No.TQC-640060--end
 
    
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    LET g_sql=g_sql CLIPPED," ORDER BY tqd02 "
    DISPLAY g_sql
 
    PREPARE i216_pb FROM g_sql
    DECLARE tqd_cs                       #CURSOR
        CURSOR FOR i216_pb
 
    CALL g_tqd.clear()
    LET g_cnt = 1
 
    FOREACH tqd_cs INTO g_tqd[g_cnt].*   
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
#No.TQC-640060--start
      SELECT tqb02 INTO g_tqd[g_cnt].tqb021
        FROM tqb_file
       WHERE tqb01=g_tqd[g_cnt].tqd03      
      SELECT tqa02 INTO g_tqd[g_cnt].tqa02
        FROM tqa_file
       WHERE tqa03='19'
         AND tqa01=g_tqd[g_cnt].tqd04
#No.TQC-640060--end
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF 
    END FOREACH
    CALL g_tqd.deleteElement(g_cnt)
  
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i216_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tqd TO s_tqd.*     ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ##################################################################
      # Standard 4ad ACTION
      ##################################################################
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END
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
         CALL i216_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         CALL fgl_set_arr_curr(1) 
      ON ACTION previous
         CALL i216_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1) 
      ON ACTION jump
         CALL i216_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         CALL fgl_set_arr_curr(1)  
      ON ACTION next
         CALL i216_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         CALL fgl_set_arr_curr(1) 
      ON ACTION last
         CALL i216_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         CALL fgl_set_arr_curr(1) 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION locale
         CALL cl_dynamic_locale()
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
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      ON ACTION reproduce                                                       
         LET g_action_choice="reproduce"                                        
         EXIT DISPLAY       
      ON ACTION about         
        CALL cl_about()     
      ON ACTION exporttoexcel                                                   
         LET g_action_choice = 'exporttoexcel'                                  
         EXIT DISPLAY          
      ON ACTION confirm1                             
         LET g_action_choice="confirm1"             
         EXIT DISPLAY          
      ON ACTION confirm2                        
         LET g_action_choice="confirm2"        
         EXIT DISPLAY          
      ON ACTION invalidate1                
         LET g_action_choice="invalidate1"
         EXIT DISPLAY          
      ON ACTION invalidate2           
         LET g_action_choice="invalidate2"  
         EXIT DISPLAY          
      ON ACTION related_document                #No.FUN-6B0043  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
   END DISPLAY  
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i216_set_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN 
      CALL cl_set_comp_entry("tqc01",TRUE)
    END IF                                                
 
END FUNCTION
 
FUNCTION i216_set_no_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680120 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN 
       CALL cl_set_comp_entry("tqc01",FALSE) 
    END IF
 
END FUNCTION
 
FUNCTION i216_check()  
 DEFINE  l_old         RECORD      
         tqd05         LIKE tqd_file.tqd05,   
         tqd06         LIKE tqd_file.tqd06   
                       END RECORD,                             
         l_sql         LIKE type_file.chr1000,  #No.FUN-680120 VARCHAR(200)
         l_tqd01       LIKE tqd_file.tqd01,         l_tqd02       LIKE tqd_file.tqd02
                                                            
    LET g_errno = ''                                       
    SELECT tqd01,tqd02 INTO l_tqd01,l_tqd02 FROM tqd_file            
     WHERE tqd03 = g_tqd_t.tqd03                 
       AND tqd05 = g_tqd_t.tqd05                
    IF cl_null(l_tqd01) and cl_null(l_tqd02) THEN                           
       SELECT tqd01,tqd02 INTO l_tqd01,l_tqd02 FROM sma_file WHERE sma00='0'   
    END IF                                                      
    LET l_sql = "SELECT tqd05,tqd06 FROM tqd_file", 
                " WHERE tqd03  = '",g_tqd[l_ac].tqd03,"'",    
                "   AND tqd01!='",l_tqd01,"' AND tqd02 !='",l_tqd02,"'"                       
    PREPARE check_prepare FROM l_sql                                
    IF SQLCA.sqlcode THEN                                          
       LET g_errno = SQLCA.sqlcode USING '-------' RETURN  
    END IF                                                
    DECLARE check_cs SCROLL CURSOR FOR check_prepare     
    OPEN check_cs                                       
    FOREACH check_cs INTO l_old.*                      
      IF SQLCA.sqlcode = 0 THEN                       
         IF (g_tqd[l_ac].tqd05>=l_old.tqd05 AND g_tqd[l_ac].tqd05 <=
 l_old.tqd06) OR                                 
            (g_tqd[l_ac].tqd06>=l_old.tqd05 AND g_tqd[l_ac].tqd06 <=
 l_old.tqd06) OR                                                           
            (l_old.tqd05>=g_tqd[l_ac].tqd05 AND l_old.tqd05 <= g_tqd
[l_ac].tqd06) OR                                                           
            (l_old.tqd06>=g_tqd[l_ac].tqd05 AND l_old.tqd06 <= g_tqd
[l_ac].tqd06) THEN  
            LET g_errno = 'atm-332'
            RETURN                                                            
         END IF                                                              
      END IF                                                                
    END FOREACH                                                            
END FUNCTION                               
 
FUNCTION i216_copy()
DEFINE                                                                          
    l_newno         LIKE tqc_file.tqc01,                                        
    l_tqb02         LIKE tqb_file.tqb02,                                        
    l_oldno         LIKE tqc_file.tqc01                                         
 
   DEFINE   li_result   LIKE type_file.num5     #No.FUN-680120 SMALLINT
                                                                                
    IF s_shut(0) THEN RETURN END IF                                             
    IF g_tqc.tqc01 IS NULL THEN                                                 
       CALL cl_err('',-400,0)                                                   
       RETURN                                                                   
    END IF                                                                      
                                                                                
    LET g_before_input_done = FALSE   
    CALL i216_set_entry('a')                                                    
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031                                                                            
    INPUT l_newno FROM tqc01                                     
                                                                                
        AFTER FIELD tqc01                                                       
            IF cl_null(l_newno) THEN NEXT FIELD tqc01 END IF                    
            SELECT  count(*) INTO g_cnt FROM tqc_file                           
             WHERE  tqc01=l_newno                                               
               AND  tqcacti='Y'                                                 
            IF g_cnt > 0 THEN                                                  
               CALL cl_err(l_newno,-239,0)                                 
               NEXT FIELD tqc01                                                 
            END IF                                                              
            SELECT  tqb02 INTO l_tqb02 FROM tqb_file                            
             WHERE  tqb01=l_newno                                               
               AND  tqbacti='Y'                                                 
            IF l_tqb02 IS NULL THEN
               CALL cl_err(l_newno,-239,0)
               NEXT FIELD tqc01
            END IF
            DISPLAY l_tqb02 TO FORMONLY.tqb02  
 
        ON ACTION controlp                  
           CASE                            
             WHEN INFIELD(tqc01)           #上級機構代碼 
               CALL cl_init_qry_var()             
               LET g_qryparam.form ="q_tqb"     
               CALL cl_create_qry() RETURNING l_newno 
               DISPLAY l_newno TO tqc01              
               IF SQLCA.sqlcode THEN                                          
                  DISPLAY BY NAME g_tqc.tqc01                                  
                  LET l_newno = NULL                                           
                  NEXT FIELD tqc01                                             
               END IF         
               OTHERWISE EXIT CASE                       
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
    IF INT_FLAG THEN                                                            
       LET INT_FLAG = 0                                                         
       DISPLAY BY NAME g_tqc.tqc01                                  
       ROLLBACK WORK                                                            
       RETURN                                                                   
    END IF                                                                      
                                                                                
    DROP TABLE y            
    SELECT * FROM tqc_file                                            
        WHERE tqc01=g_tqc.tqc01                                                 
        INTO TEMP y                                                             
                                                                                
    UPDATE y                                                                    
        SET tqc01=l_newno,                                          
            tqcuser=g_user,                                         
            tqcgrup=g_grup,
            tqcdate=g_today,
            tqcacti='Y'                                              
                                                                                
    INSERT INTO tqc_file                                                        
        SELECT * FROM y                                                         
    IF SQLCA.sqlcode THEN                                                       
    #   CALL cl_err(g_tqc.tqc01,SQLCA.sqlcode,0)                                   #No.FUN-660104
        CALL cl_err3("ins","tqc_file",g_tqc.tqc01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
        ROLLBACK WORK                                                           
        RETURN                                                                  
    ELSE                                                                        
        COMMIT WORK                                                             
    END IF                                                                      
                                                                                
    DROP TABLE x                                                                
                                                                                
    SELECT * FROM tqd_file                                           
        WHERE tqd01=g_tqc.tqc01                                                 
        INTO TEMP x                                                             
    IF SQLCA.sqlcode THEN                                                       
    #   CALL cl_err(g_tqc.tqc01,SQLCA.sqlcode,0)           #No.FUN-660104                        
        CALL cl_err3("ins","x",g_tqc.tqc01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
 
        RETURN                                                                  
    END IF                                                                      
                                                                                
    UPDATE x                                                                    
        SET tqd01=l_newno                                                      
                                                                                
    INSERT INTO tqd_file                                                        
        SELECT * FROM x                                                         
    IF SQLCA.sqlcode THEN    
        CALL cl_err3("ins","tqd_file",g_tqc.tqc01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104            #FUN-B80061      ADD
        ROLLBACK WORK                                                   
    #   CALL cl_err(g_tqc.tqc01,SQLCA.sqlcode,0)                                   #No.FUN-660104
    #    CALL cl_err3("ins","tqd_file",g_tqc.tqc01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104           #FUN-B80061      MARK
        RETURN    
    ELSE                                                                        
        COMMIT WORK                                                             
    END IF    
    LET g_cnt=SQLCA.SQLERRD[3]                                                  
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'                  
                                                                                
     LET l_oldno = g_tqc.tqc01                                                  
     SELECT tqc_file.* INTO g_tqc.* FROM tqc_file             
      WHERE tqc01 = l_newno                                                     
     CALL i216_b()                                                              
     #SELECT * INTO g_tqc.* FROM tqc_file  #FUN-C80046                
     # WHERE tqc01 = l_oldno               #FUN-C80046                                    
     #CALL i216_show()                     #FUN-C80046                                      
                                                                                
END FUNCTION              
 
 
