# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: atmi213.4gl
# Descriptions...: atmi213  廣告素材明細作業
# Date & Author..: 06/02/11 By day 
# Modify.........: No:TQC-630107 06/03/10 By Alexstar 單身筆數限制
# Modify.........: No:FUN-660104 06/06/15 By cl Error Message 調整
# Modify.........: No:FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No:FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: Mo:FUN-6A0072 06/10/24 By xumin g_no_ask改mi_no_ask    
# Modify.........: No:FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No:FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能 
# Modify.........: No:FUN-6B0043 06/11/24 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No:TQC-720019 07/03/01 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No:TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No:FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No:TQC-790082 07/09/13 By lumxa 打印時程序名稱不應在“制表日期”下面
# Modify.........: No:FUN-7C0043 07/12/18 By Sunyanchun   橾老報表改成p_query
# Modify.........: No:FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No:TQC-940083 09/05/08 By mike 查詢時ton01,ton02的開窗應該開的是ton_file,                                        
#                                                 而p_qry里維護的確是tom_file.                                                      
#                                                 另外ton04,ton05情況類似，都是錯的。
# Modify.........: No:FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9B0098 10/02/24 By tommas delete cl_doc
# Modify.........: No:MOD-AC0178 10/12/18 By shiwuying 更改TQC-940083的bug
# Modify.........: No.CHI-B40058 11/05/16 By JoHung 修改有使用到apy/gpy模組p_ze資料的程式
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-D30033 13/04/10 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_ton_hd        RECORD                       #單頭變數                      
        ton01       LIKE ton_file.ton01,
        ton02       LIKE ton_file.ton02
        END RECORD,
    g_ton_hd_t      RECORD                       #單頭變數                      
        ton01       LIKE ton_file.ton01,
        ton02       LIKE ton_file.ton02
        END RECORD,
    g_ton_hd_o      RECORD                       #單頭變數                      
        ton01       LIKE ton_file.ton01,
        ton02       LIKE ton_file.ton02
        END RECORD,
    g_ton           DYNAMIC ARRAY OF RECORD  
        ton03       LIKE ton_file.ton03,
        ton04       LIKE ton_file.ton04,
        toc02       LIKE toc_file.toc02,
        toa02       LIKE toa_file.toa02,
        ton05       LIKE ton_file.ton05,
        tor02       LIKE tor_file.tor02,
        ton06       LIKE ton_file.ton06,
        ton07       LIKE ton_file.ton07,
        ton08       LIKE ton_file.ton08,
        ton09       LIKE ton_file.ton09,
        ton10       LIKE ton_file.ton10
                    END RECORD,
    g_ton_t         RECORD                
        ton03       LIKE ton_file.ton03,
        ton04       LIKE ton_file.ton04,
        toc02       LIKE toc_file.toc02,
        toa02       LIKE toa_file.toa02,
        ton05       LIKE ton_file.ton05,
        tor02       LIKE tor_file.tor02,
        ton06       LIKE ton_file.ton06,
        ton07       LIKE ton_file.ton07,
        ton08       LIKE ton_file.ton08,
        ton09       LIKE ton_file.ton09,
        ton10       LIKE ton_file.ton10
                    END RECORD,
    g_argv1         LIKE ton_file.ton01, 
    g_argv2         LIKE ton_file.ton02, 
    g_wc            string,       
    g_sql           string, 
    g_rec_b         LIKE type_file.num5,                 #單身筆數                 #No.FUN-680120 SMALLINT
    l_ac            LIKE type_file.num5                  #目前處理的ARRAY CNT      #No.FUN-680120 SMALLINT
DEFINE   g_before_input_done LIKE type_file.num5         #No.FUN-680120 SMALLINT
DEFINE   g_forupd_sql   STRING     #SELECT ... FOR UPDATE  SQL
DEFINE   g_sql_tmp      STRING     #No.TQC-720019
DEFINE   g_cnt          LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   g_chr          LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
DEFINE   g_i            LIKE type_file.num5          #count/index for any purpose  #No.FUN-680120 SMALLINT
DEFINE   g_msg          LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680120 SMALLINT   #No.FUN-6A0072
 
#主程式開始
MAIN
DEFINE
#       l_time    LIKE type_file.chr8     #No.FUN-6B0014
    p_row,p_col LIKE type_file.num5      #No.FUN-680120 SMALLINT
 
    OPTIONS                                      #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                              #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ATM")) THEN
       EXIT PROGRAM
    END IF
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
    LET g_argv1      = ARG_VAL(1)     
    LET g_argv2      = ARG_VAL(2)      
    INITIALIZE g_ton_hd.* to NULL
    INITIALIZE g_ton_hd_t.* to NULL
    INITIALIZE g_ton_hd_o.* to NULL
 
    LET p_row = 3 LET p_col = 20
    OPEN WINDOW i213_w AT p_row,p_col
        WITH FORM "atm/42f/atmi213" ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_init()
    IF NOT cl_null(g_argv1) OR NOT cl_null(g_argv2) THEN CALL i213_q() END IF 
    CALL i213_menu()
    CLOSE WINDOW i213_w                          #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
#QBE 查詢資料
FUNCTION i213_curs()
    CLEAR FORM #清除畫面
 
  IF NOT cl_null(g_argv1) OR NOT cl_null(g_argv2) THEN
     LET g_wc = "ton01 = '",g_argv1,"' AND ton02 = '",g_argv2,"' "    
  ELSE 
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_ton_hd.* TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON ton01,ton02,ton03,ton04,ton05, # 螢幕上取條件
                      ton06,ton07,ton08,ton09,ton10
         FROM ton01,ton02,
              s_ton[1].ton03, s_ton[1].ton04, s_ton[1].ton05,
              s_ton[1].ton06, s_ton[1].ton07, s_ton[1].ton08,
              s_ton[1].ton09, s_ton[1].ton10
 
        BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(ton01)                                             
                    CALL cl_init_qry_var()                                      
                   #LET g_qryparam.form ="q_tom"     #TQC-940083
                    LET g_qryparam.form ="q_ton01"   #TQC-940083                                  
                    LET g_qryparam.state = "c"                                  
                    CALL cl_create_qry() RETURNING g_qryparam.multiret          
                    DISPLAY g_qryparam.multiret TO ton01               
                    NEXT FIELD ton01                                            
                WHEN INFIELD(ton02)                                             
                    CALL cl_init_qry_var()                                      
                   #LET g_qryparam.form ="q_tom1"  #TQC-940083     
                    LET g_qryparam.form ="q_ton02" #TQC-940083                              
                    LET g_qryparam.state = "c"                                  
                    CALL cl_create_qry() RETURNING g_qryparam.multiret          
                    DISPLAY g_qryparam.multiret TO ton02               
                    NEXT FIELD ton02                                    
                WHEN INFIELD(ton04)                                             
                    CALL cl_init_qry_var()                                      
                   #LET g_qryparam.form ="q_toc"     #TQC-940083    
                    LET g_qryparam.form ="q_ton04"   #TQC-940083                                  
                    LET g_qryparam.state = "c"                                  
                    CALL cl_create_qry() RETURNING g_qryparam.multiret          
                    DISPLAY g_qryparam.multiret TO ton04                        
                    NEXT FIELD ton04                                            
                WHEN INFIELD(ton05)                                             
                    CALL cl_init_qry_var()                                      
                   #LET g_qryparam.form ="q_tor"     #TQC-940083  
                    LET g_qryparam.form ="q_ton05"   #TQC-940083                                   
                    LET g_qryparam.state = "c"                                  
                    CALL cl_create_qry() RETURNING g_qryparam.multiret          
                    DISPLAY g_qryparam.multiret TO ton05                        
                    NEXT FIELD ton05                         
                OTHERWISE                                                       
                    EXIT CASE  
            END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
  END IF
 
    IF INT_FLAG THEN
       LET g_ton_hd.ton01=''
       LET g_ton_hd.ton02=''
       CALL g_ton.clear()
       CALL i213_show()
       RETURN
    END IF
 
    LET g_sql = "SELECT UNIQUE ton01,ton02 ",
                "  FROM ton_file ",
                " WHERE ", g_wc CLIPPED,
                " ORDER BY ton01,ton02"
    PREPARE i213_prepare FROM g_sql
    DECLARE i213_cs                              #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i213_prepare
 
#   LET g_sql = "SELECT UNIQUE ton01,ton02 ",      #No.TQC-720019
    LET g_sql_tmp = "SELECT UNIQUE ton01,ton02 ",  #No.TQC-720019
                "  FROM ton_file ",
                " WHERE ", g_wc CLIPPED,
                " INTO TEMP x "
    DROP TABLE x
#   PREPARE i213_pre_x FROM g_sql      #No.TQC-720019
    PREPARE i213_pre_x FROM g_sql_tmp  #No.TQC-720019
    EXECUTE i213_pre_x
 
    LET g_sql = "SELECT COUNT(*) FROM x"
    PREPARE i213_precnt FROM g_sql
    DECLARE i213_cnt CURSOR FOR i213_precnt
END FUNCTION
 
FUNCTION i213_menu()
   WHILE TRUE
      CALL i213_bp("G")
      CASE g_action_choice
        WHEN "insert"
           IF cl_chk_act_auth() THEN
              CALL i213_a()
           END IF
        WHEN "query"
           IF cl_chk_act_auth() THEN
              CALL i213_q()
           END IF
        WHEN "delete"
           IF cl_chk_act_auth() THEN
              CALL i213_r()
           END IF
        WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL i213_b()
           ELSE
              LET g_action_choice = NULL
           END IF
        WHEN "output"
           IF cl_chk_act_auth() THEN
              CALL i213_out()        
           END IF
        WHEN "help"
           CALL cl_show_help()
        WHEN "exit"
           EXIT WHILE
        WHEN "controlg"
           CALL cl_cmdask()
        WHEN "exporttoexcel"  
           IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ton),'','')
           END IF
        #No.FUN-6B0043-------add--------str----
        WHEN "related_document"           #相關文件
         IF cl_chk_act_auth() THEN
            IF g_ton_hd.ton01 IS NOT NULL THEN
               LET g_doc.column1 = "ton01"
               LET g_doc.column2 = "ton02"
               LET g_doc.value1 = g_ton_hd.ton01
               LET g_doc.value2 = g_ton_hd.ton02
               CALL cl_doc()
            END IF 
         END IF
        #No.FUN-6B0043-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i213_a()
    IF s_shut(0) THEN  RETURN END IF
 
    MESSAGE ""
    CLEAR FORM
    CALL g_ton.clear()  
    INITIALIZE g_ton_hd.* TO NULL                  #單頭初始清空
    INITIALIZE g_ton_hd_o.* TO NULL                #單頭舊值清空
    INITIALIZE g_ton_hd_t.* TO NULL                #單頭舊值清空
 
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i213_i("a")                         #輸入單頭
        IF INT_FLAG THEN                         #使用者不玩了
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           EXIT WHILE
        END IF
        IF cl_null(g_ton_hd.ton01)  OR
           cl_null(g_ton_hd.ton02)  THEN
           CONTINUE WHILE
        END IF
        CALL g_ton.clear()
        LET g_rec_b=0
        CALL i213_b()                            #輸入單身
        LET g_ton_hd_t.* = g_ton_hd.*            #保留舊值
        LET g_ton_hd_o.* = g_ton_hd.*            #保留舊值
        LET g_wc="     ton01='",g_ton_hd.ton01,"' ",
                 " AND ton02='",g_ton_hd.ton02,"' "
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i213_i(p_cmd)
DEFINE
    p_cmd   LIKE type_file.chr1,         #a:輸入 u:更改        #No.FUN-680120 VARCHAR(1)
    l_n     LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
    LET l_n = 0
 
    DISPLAY g_ton_hd.ton01, g_ton_hd.ton02
         TO ton01,ton02
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT g_ton_hd.ton01,g_ton_hd.ton02
     FROM ton01,ton02
 
       #MOD-AC0178 Begin---
       #AFTER FIELD ton01                                                       
       #    IF NOT cl_null(g_ton_hd.ton01) THEN                              
       #          SELECT * FROM tom_file,tol_file                               
       #           WHERE tom01 = g_ton_hd.ton01                              
       #             AND tom01 = tol01                                          
       #             AND tol13 = 'N'
       #             AND tolacti = 'Y'                                          
       #          IF SQLCA.sqlcode = 100 THEN                                   
       #          #  CALL cl_err(g_ton_hd.ton01,100,0)  #No.FUN-660104
       #             CALL cl_err3("sel","tom_file,tol_file",g_ton_hd.ton01,"",100,"","",1)  #No.FUN-660104 
       #             NEXT FIELD ton01                                           
       #          END IF                                                        
       #    END IF          
       #                                                                        
       #AFTER FIELD ton02                                                       
       #    IF NOT cl_null(g_ton_hd.ton02) THEN                              
       #       SELECT * FROM tom_file,tol_file                                  
       #        WHERE tom01 = g_ton_hd.ton01                                 
       #          AND tom02 = g_ton_hd.ton02                                 
       #          AND tom01 = tol01                                             
       #          AND tolacti = 'Y'                                             
       #       IF SQLCA.sqlcode = 100 THEN                                      
       #       #  CALL cl_err(g_ton_hd.ton02,100,0)                          
       #          CALL cl_err3("sel","tom_file,tol_file",g_ton_hd.ton01,g_ton_hd.ton02,100,"","",1)  #No.FUN-660104 
       #          NEXT FIELD ton02                                              
       #       END IF                                                           
       #    END IF                        
       #    SELECT COUNT(*) INTO l_n   #Key 值是否重覆
       #      FROM ton_file
       #     WHERE ton01 = g_ton_hd.ton01
       #       AND ton02 = g_ton_hd.ton02
       #    IF l_n > 0 THEN
       #        INITIALIZE g_ton_hd TO NULL
       #        DISPLAY g_ton_hd.ton01,g_ton_hd.ton02
       #             TO ton01,ton02
       #        CALL cl_err( g_ton_hd.ton01, -239, 0)
       #        NEXT FIELD ton01
       #    END IF
        AFTER FIELD ton01
           IF NOT cl_null(g_ton_hd.ton01) THEN
              CALL i213_ton01(p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_ton_hd.ton01,g_errno,0)
                 NEXT FIELD ton01
              END IF
           END IF

        AFTER FIELD ton02
           IF NOT cl_null(g_ton_hd.ton02) THEN
              CALL i213_ton01(p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_ton_hd.ton02,g_errno,0)
                 NEXT FIELD ton02
              END IF
           END IF
       #MOD-AC0178 End-----
 
        ON ACTION CONTROLF                       #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(ton01)                                             
                    CALL cl_init_qry_var()                                      
                   #LET g_qryparam.form ="q_tom"     #TQC-940083
                  # LET g_qryparam.form ="q_ton01"   #TQC-940083 #MOD-AC0178
                    LET g_qryparam.form ="q_tom"                 #MOD-AC0178
                    LET g_qryparam.default1 = g_ton_hd.ton01                 
                    LET g_qryparam.default2 = g_ton_hd.ton02                 
                    CALL cl_create_qry() RETURNING g_ton_hd.ton01,           
                                                   g_ton_hd.ton02            
                    DISPLAY g_ton_hd.ton01 TO ton01                          
                    DISPLAY g_ton_hd.ton02 TO ton02                          
                    NEXT FIELD ton01                                            
                WHEN INFIELD(ton02)                                             
                    CALL cl_init_qry_var()                                      
                   #LET g_qryparam.form ="q_tom1"      #TQC-940083   
                  # LET g_qryparam.form ="q_ton02"     #TQC-940083 #MOD-AC0178
                    LET g_qryparam.form ="q_tom1"                  #MOD-AC0178
                    LET g_qryparam.arg1=g_ton_hd.ton01                       
                    LET g_qryparam.default1 = g_ton_hd.ton02                 
                    CALL cl_create_qry() RETURNING g_ton_hd.ton02            
                    DISPLAY g_ton_hd.ton02 TO ton02                          
                    NEXT FIELD ton02                
                OTHERWISE                                                       
                    EXIT CASE     
            END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
    END INPUT
END FUNCTION

#MOD-AC0178 Begin---
FUNCTION i213_ton01(p_cmd)
 DEFINE p_cmd     LIKE type_file.chr1
 DEFINE l_n       LIKE type_file.num5
 DEFINE l_tol13   LIKE tol_file.tol13
 DEFINE l_tolacti LIKE tol_file.tolacti

   LET g_errno = ''
   SELECT tol13,tolacti INTO l_tol13,l_tolacti 
     FROM tol_file
    WHERE tol01 = g_ton_hd.ton01
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='100'
        WHEN l_tolacti='N'     LET g_errno='9028'
        WHEN l_tol13<>'Y'      LET g_errno='9029'
        OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
   END CASE
  
   IF NOT cl_null(g_errno) THEN RETURN END IF
 
   IF NOT cl_null(g_ton_hd.ton01) AND NOT cl_null(g_ton_hd.ton02) THEN
      SELECT * FROM tom_file,tol_file
       WHERE tom01 = g_ton_hd.ton01
         AND tom02 = g_ton_hd.ton02
         AND tom01 = tol01
      IF SQLCA.sqlcode=100 THEN LET g_errno='100' END IF
   END IF
   IF cl_null(g_errno) THEN
      SELECT COUNT(*) INTO l_n   #Key 值是否重覆
        FROM ton_file
       WHERE ton01 = g_ton_hd.ton01
         AND ton02 = g_ton_hd.ton02
      IF l_n > 0 THEN
         LET g_errno='-239'
      END IF
   END IF
END FUNCTION
#MOD-AC0178 End-----
 
FUNCTION i213_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_ton_hd TO NULL                   #No.FUN-6B0043 
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_ton.clear()
    DISPLAY '     ' TO FORMONLY.cnt
    CALL i213_curs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
    OPEN i213_cs                                 # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
      #INITIALIZE g_ton TO NULL                   #No.FUN-6B0043 mark
       INITIALIZE g_ton_hd TO NULL                #No.FUN-6B0043 
    ELSE
       OPEN i213_cnt
       FETCH i213_cnt INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL i213_fetch('F')                     # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i213_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                        #處理方式        #No.FUN-680120 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i213_cs INTO g_ton_hd.ton01,g_ton_hd.ton02
        WHEN 'P' FETCH PREVIOUS i213_cs INTO g_ton_hd.ton01,g_ton_hd.ton02
        WHEN 'F' FETCH FIRST    i213_cs INTO g_ton_hd.ton01,g_ton_hd.ton02
        WHEN 'L' FETCH LAST     i213_cs INTO g_ton_hd.ton01,g_ton_hd.ton02
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
            IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump i213_cs INTO g_ton_hd.ton01,g_ton_hd.ton02
         LET mi_no_ask = FALSE   #No.FUN-6A0072
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ton_hd.ton01, SQLCA.sqlcode, 0)
        INITIALIZE g_ton_hd.* TO NULL  #TQC-6B0105
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
    SELECT UNIQUE ton01,ton02
      FROM ton_file
     WHERE ton01 = g_ton_hd.ton01
       AND ton02 = g_ton_hd.ton02
    IF SQLCA.sqlcode THEN
 #     CALL cl_err(g_ton_hd.ton01, SQLCA.sqlcode, 0)  #No.FUN-660104
       CALL cl_err3("sel","ton_file",g_ton_hd.ton01,g_ton_hd.ton02,SQLCA.sqlcode,"","",1)  #No.FUN-660104 
       INITIALIZE g_ton TO NULL
       RETURN
   END IF
   CALL i213_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i213_show()
 
    LET g_ton_hd.* = g_ton_hd.*                   #保存單頭舊值
    DISPLAY BY NAME g_ton_hd.ton01,g_ton_hd.ton02 #顯示單頭值
 
    CALL i213_b_fill(g_wc) #單身
    CALL cl_show_fld_cont() 
END FUNCTION
 
FUNCTION i213_r()
DEFINE
    l_chr LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
 
    IF cl_null(g_ton_hd.ton01) OR cl_null(g_ton_hd.ton02) THEN
       CALL cl_err('', -400, 0)
       RETURN
    END IF
    CALL i213_show()
    IF cl_delh(0,0) THEN                         #詢問是否取消資料
        INITIALIZE g_doc.* TO NULL             #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ton01"            #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "ton02"            #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_ton_hd.ton01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_ton_hd.ton02      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                      #No.FUN-9B0098 10/02/24
        DELETE FROM ton_file
         WHERE ton01 = g_ton_hd.ton01
           AND ton02 = g_ton_hd.ton02
        IF STATUS THEN
        #  CALL cl_err(g_ton_hd.ton01,SQLCA.sqlcode,0)  #No.FUN-660104 
           CALL cl_err3("del","ton_file",g_ton_hd.ton01,g_ton_hd.ton02,SQLCA.sqlcode,"","",1)  #No.FUN-660104 
        ELSE
           CLEAR FORM
           DROP TABLE x
#          EXECUTE i213_pre_x                  #No.TQC-720019
           PREPARE i213_pre_x2 FROM g_sql_tmp  #No.TQC-720019
           EXECUTE i213_pre_x2                 #No.TQC-720019
           CALL g_ton.clear()
           LET g_sql = "SELECT UNIQUE ton01,ton02 ",
                       "  FROM ton_file ",
                       "  INTO TEMP y "
           DROP TABLE y
           PREPARE i213_pre_y FROM g_sql
           EXECUTE i213_pre_y
           LET g_sql = "SELECT COUNT(*) FROM y"
           PREPARE i213_precnt2 FROM g_sql
           DECLARE i213_cnt2 CURSOR FOR i213_precnt2
           OPEN i213_cnt2
           #FUN-B50064-add-start--
           IF STATUS THEN
              CLOSE i213_cs
              CLOSE i213_cnt2
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50064-add-end-- 
           FETCH i213_cnt2 INTO g_row_count
           #FUN-B50064-add-start--
           IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
              CLOSE i213_cs
              CLOSE i213_cnt2
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50064-add-end-- 
           DISPLAY g_row_count TO FORMONLY.cnt
           OPEN i213_cs
           IF g_curs_index = g_row_count + 1 THEN
              LET g_jump = g_row_count
              CALL i213_fetch('L')
           ELSE
              LET g_jump = g_curs_index
              LET mi_no_ask = TRUE   #No.FUN-6A0072
              CALL i213_fetch('/')
           END IF
        END IF
    END IF
    COMMIT WORK
END FUNCTION
 
FUNCTION i213_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                     #未取消的ARRAY CNT #No.FUN-680120 SMALLINT
    l_n             LIKE type_file.num5,                     #檢查重複用        #No.FUN-680120 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                      #單身鎖住否       #No.FUN-680120 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                      #處理狀態         #No.FUN-680120 VARCHAR(1)
    l_cnt1          LIKE type_file.num5,                     #sum(ton07)        #No.FUN-680120 SMALLINT
    l_cnt2          LIKE type_file.num5,                     #sum(tom08)        #No.FUN-680120 SMALLINT
    l_toc02         LIKE toc_file.toc02,
    l_toa02         LIKE toa_file.toa02,
    l_tor02         LIKE tor_file.tor02,
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680120 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680120 SMALLINT
 
    LET g_action_choice = ""
    IF cl_null(g_ton_hd.ton01) OR cl_null(g_ton_hd.ton02) THEN RETURN END IF
 
    IF s_shut(0) THEN RETURN END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
        "SELECT ton03,ton04,'','',ton05,'',ton06,ton07,ton08,ton09,ton10 FROM ton_file ",
        " WHERE ton01 = ? AND ton02 = ? AND ton03 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i213_bcl CURSOR FROM g_forupd_sql                  # LOCK CURSOR
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_ton WITHOUT DEFAULTS FROM s_ton.*
        ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                  APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                  #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_ton_t.* = g_ton[l_ac].*    #BACKUP
               OPEN i213_bcl USING g_ton_hd.ton01,g_ton_hd.ton02,g_ton[l_ac].ton03
               IF STATUS THEN
                  CALL cl_err("OPEN i213_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i213_bcl INTO g_ton[l_ac].*
                  IF SQLCA.sqlcode THEN
                      CALL cl_err(g_ton_t.ton03,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                  END IF
                  SELECT toc02,toa02                                          
                    INTO g_ton[l_ac].toc02,g_ton[l_ac].toa02                  
                    FROM toc_file,toa_file                                    
                   WHERE toc01 = g_ton[l_ac].ton04                            
                     AND toa01 = toc05                                        
                     AND toa03 = '6'                                          
                  SELECT tor02 INTO g_ton[l_ac].tor02 FROM tor_file           
                   WHERE tor01 = g_ton[l_ac].ton05            
               END IF
               CALL cl_show_fld_cont()  
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_ton[l_ac].* TO NULL
            LET g_ton_t.* = g_ton[l_ac].*        #新輸入資料
            CALL cl_show_fld_cont()
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            LET l_cnt1=0
            LET l_cnt2=0
            SELECT SUM(ton07) INTO l_cnt1
              FROM ton_file
             WHERE ton01=g_ton_hd.ton01
               AND ton02=g_ton_hd.ton02
            IF cl_null(l_cnt1) THEN
               LET l_cnt1 = g_ton[l_ac].ton07
            ELSE
               LET l_cnt1 = l_cnt1+g_ton[l_ac].ton07
            END IF
            SELECT SUM(tom08) INTO l_cnt2
              FROM tom_file
             WHERE tom01=g_ton_hd.ton01
               AND tom02=g_ton_hd.ton02
            IF l_cnt1>l_cnt2 THEN 
               CALL cl_err('','atm-122',1)
               CANCEL INSERT
            END IF
            INSERT INTO ton_file(ton01,ton02,ton03,ton04,ton05, 
                                 ton06,ton07,ton08,ton09,ton10)
              VALUES(g_ton_hd.ton01,g_ton_hd.ton02,
                     g_ton[l_ac].ton03,g_ton[l_ac].ton04,g_ton[l_ac].ton05,
                     g_ton[l_ac].ton06,g_ton[l_ac].ton07,g_ton[l_ac].ton08,
                     g_ton[l_ac].ton09,g_ton[l_ac].ton10)
            IF SQLCA.sqlcode THEN
            #  CALL cl_err(g_ton[l_ac].ton03,SQLCA.sqlcode,0)  #No.FUN-660104 
               CALL cl_err3("ins","ton_file",g_ton[l_ac].ton03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104 
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               COMMIT WORK
               SELECT COUNT(*) INTO g_rec_b FROM ton_file
                WHERE ton01 = g_ton_hd.ton01
                  AND ton02 = g_ton_hd.ton02
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE FIELD ton03                        #default 序號                 
           IF g_ton[l_ac].ton03 IS NULL OR g_ton[l_ac].ton03 = 0 THEN           
              SELECT MAX(ton03)+1                                               
                INTO g_ton[l_ac].ton03                                          
                FROM ton_file                                                   
               WHERE ton01 = g_ton_hd.ton01                                  
                 AND ton02 = g_ton_hd.ton02                                  
              IF g_ton[l_ac].ton03 IS NULL THEN                                 
                 LET g_ton[l_ac].ton03 = 1                                      
              END IF                                                            
           END IF               
 
        AFTER FIELD ton03                        #check 序號是否重復            
            IF NOT cl_null(g_ton[l_ac].ton03) THEN                              
               IF g_ton[l_ac].ton03!=g_ton_t.ton03 OR cl_null(g_ton_t.ton03) THEN
                  SELECT count(*)                                                  
                    INTO l_n                                                       
                    FROM ton_file                                                  
                   WHERE ton01 = g_ton_hd.ton01                                 
                     AND ton02 = g_ton_hd.ton02                                 
                     AND ton03 = g_ton[l_ac].ton03                                 
                  IF l_n > 0 THEN                                              
                     CALL cl_err(g_ton[l_ac].ton03,-239,0)                                   
                     NEXT FIELD ton03                                         
                  END IF                                                       
                END IF                                                          
             END IF                 
 
        AFTER FIELD ton04 
	    IF NOT cl_null(g_ton[l_ac].ton04) THEN
               SELECT * FROM toc_file 
                WHERE toc01 = g_ton[l_ac].ton04
               IF SQLCA.sqlcode = 100 THEN
               #  CALL cl_err(g_ton[l_ac].ton04,100,0)  #No.FUN-660104 
                  CALL cl_err3("sel","toc_file",g_ton[l_ac].ton04,"",100,"","",1)  #No.FUN-660104 
                  NEXT FIELD ton04
   	       ELSE
                  CALL i213_ton04('a')
    	          IF NOT cl_null(g_errno)  THEN
	             CALL cl_err('',g_errno,0)
 	             LET g_ton[l_ac].ton04 = g_ton_t.ton04
                     NEXT FIELD ton04
                  END IF
    	       END IF
            END IF
 
        AFTER FIELD ton05 
	    IF NOT cl_null(g_ton[l_ac].ton05) THEN
               SELECT * FROM tor_file 
                WHERE tor01 = g_ton[l_ac].ton05
               IF SQLCA.sqlcode = 100 THEN
               #  CALL cl_err(g_ton[l_ac].ton05,100,0)  #No.FUN-660104 
                  CALL cl_err3("sel","tor_file",g_ton[l_ac].ton05,"",100,"","",1)  #No.FUN-660104 
                  NEXT FIELD ton05
   	       ELSE
                  CALL i213_ton05('a')
    	          IF NOT cl_null(g_errno)  THEN
	             CALL cl_err('',g_errno,0)
 	             LET g_ton[l_ac].ton05 = g_ton_t.ton05
                     NEXT FIELD ton05
                  END IF
    	       END IF
            END IF
 
        AFTER FIELD ton07 
	    IF NOT cl_null(g_ton[l_ac].ton07) THEN
               IF g_ton[l_ac].ton07 <= 0 THEN 
                  NEXT FIELD ton07
               END IF
               LET l_cnt1=0
               LET l_cnt2=0
               SELECT SUM(ton07) INTO l_cnt1
                 FROM ton_file
                WHERE ton01=g_ton_hd.ton01
                  AND ton02=g_ton_hd.ton02
               IF (g_ton_t.ton07 IS NULL) THEN
                  IF cl_null(l_cnt1) THEN
                     LET l_cnt1 = g_ton[l_ac].ton07
                  ELSE
                     LET l_cnt1 = l_cnt1+g_ton[l_ac].ton07
                  END IF
               END IF
               IF (g_ton[l_ac].ton07 > g_ton_t.ton07 
                   AND g_ton_t.ton07 IS NOT NULL) THEN
                   LET l_cnt1 = l_cnt1 + g_ton[l_ac].ton07 - g_ton_t.ton07
               END IF
               SELECT SUM(tom08) INTO l_cnt2
                 FROM tom_file
                WHERE tom01=g_ton_hd.ton01
                  AND tom02=g_ton_hd.ton02
               IF l_cnt1>l_cnt2 THEN 
                  CALL cl_err('','atm-122',1)
                  LET g_ton[l_ac].ton07=g_ton_t.ton07
                  NEXT FIELD ton07
               END IF
            END IF
 
        AFTER FIELD ton09 
	    IF NOT cl_null(g_ton[l_ac].ton09) THEN
               CALL i213_chk_time(g_ton[l_ac].ton09,'1')
               IF NOT cl_null(g_errno) THEN 
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD ton09
               END IF 
            END IF
 
 
        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_ton_t.ton03) THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM ton_file             #刪除該筆單身資料
                 WHERE ton01 = g_ton_hd.ton01
                   AND ton02 = g_ton_hd.ton02
                   AND ton03 = g_ton_t.ton03
                IF SQLCA.sqlcode THEN
                #   CALL cl_err(g_ton_t.ton03,SQLCA.sqlcode,0)  #No.FUN-660104
                    CALL cl_err3("del","ton_file",g_ton_t.ton03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
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
               LET g_ton[l_ac].* = g_ton_t.*
               CLOSE i213_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_ton[l_ac].ton03,-263,1)
               LET g_ton[l_ac].* = g_ton_t.*
            ELSE
               UPDATE ton_file
                  SET ton03 = g_ton[l_ac].ton03,
                      ton04 = g_ton[l_ac].ton04,
                      ton05 = g_ton[l_ac].ton05,
                      ton06 = g_ton[l_ac].ton06,
                      ton07 = g_ton[l_ac].ton07,
                      ton08 = g_ton[l_ac].ton08,
                      ton09 = g_ton[l_ac].ton09,
                      ton10 = g_ton[l_ac].ton10
                WHERE CURRENT OF i213_bcl
               IF SQLCA.sqlcode THEN
               #   CALL cl_err(g_ton[l_ac].ton03, SQLCA.sqlcode, 0)  #No.FUN-660104
                   CALL cl_err3("upd","ton_file",g_ton[l_ac].ton03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
                   LET g_ton[l_ac].* = g_ton_t.*
                   ROLLBACK WORK
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30033 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_ton[l_ac].* = g_ton_t.*
               #FUN-D30033--add--begin--
               ELSE
                  CALL g_ton.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30033--add--end----
               END IF
               CLOSE i213_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30033 add
            CLOSE i213_bcl
            COMMIT WORK
 
        ON ACTION CONTROLP
           CASE
                WHEN INFIELD(ton04) 
                    CALL cl_init_qry_var()                                     
                   #LET g_qryparam.form ="q_toc"     #TQC-940083    
                  # LET g_qryparam.form ="q_ton04"   #TQC-940083    
                    LET g_qryparam.form ="q_toc"     #MOD-AC0178 TQC-940083修改错误，还原
                    LET g_qryparam.default1 = g_ton[l_ac].ton04
                    CALL cl_create_qry() RETURNING g_ton[l_ac].ton04
                    DISPLAY g_ton[l_ac].ton04 TO ton04
                    NEXT FIELD ton04
                WHEN INFIELD(ton05) 
                    CALL cl_init_qry_var()                                     
                   #LET g_qryparam.form ="q_tor"     #TQC-940083    
                  # LET g_qryparam.form ="q_ton05"   #TQC-940083   
                    LET g_qryparam.form ="q_tor"     #MOD-AC0178 TQC-940083修改错误，还原
                    LET g_qryparam.default1 = g_ton[l_ac].ton05
                    CALL cl_create_qry() RETURNING g_ton[l_ac].ton05
                    DISPLAY g_ton[l_ac].ton05 TO ton05
                    NEXT FIELD ton05
                OTHERWISE
                    EXIT CASE
            END CASE
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END  
        ON ACTION CONTROLN
           CALL i213_b_askkey()
           EXIT INPUT
 
        ON ACTION CONTROLO                       #沿用所有欄位
           IF INFIELD(ton03) AND l_ac > 1 THEN
              LET g_ton[l_ac].* = g_ton[l_ac-1].*
              NEXT FIELD ton03
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
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
  
        END INPUT
 
    CLOSE i213_bcl
    COMMIT WORK
    CALL i213_delall()
END FUNCTION
 
FUNCTION i213_ton04(p_cmd) 
 DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
        l_toc02     LIKE toc_file.toc02,
        l_tocacti   LIKE toc_file.tocacti,
        l_toa02     LIKE toa_file.toa02,
        l_toaacti   LIKE toa_file.toaacti
 
    LET g_errno = ' '
 
    SELECT toc02,tocacti,toa02,toaacti 
      INTO l_toc02,l_tocacti,l_toa02,l_toaacti 
      FROM toc_file,toa_file
     WHERE toc01 = g_ton[l_ac].ton04
       AND toa01 = toc05
       AND toa03 = '6'
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
                                   LET g_ton[l_ac].ton04 = NULL
         WHEN l_tocacti='N' LET g_errno = 'anm-027'
         WHEN l_toaacti='N' LET g_errno = 'anm-027'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd='a' THEN
       LET g_ton[l_ac].toc02 = l_toc02
       LET g_ton[l_ac].toa02 = l_toa02
    END IF
END FUNCTION
 
FUNCTION i213_ton05(p_cmd) 
 DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
        l_tor02     LIKE tor_file.tor02,
        l_toracti   LIKE tor_file.toracti
 
    LET g_errno = ' '
    SELECT tor02,toracti INTO l_tor02,l_toracti FROM tor_file
     WHERE tor01 = g_ton[l_ac].ton05
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
                                   LET g_ton[l_ac].ton05 = NULL
         WHEN l_toracti='N' LET g_errno = 'anm-027'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd='a' THEN
       LET g_ton[l_ac].tor02 = l_tor02
    END IF
END FUNCTION
 
FUNCTION i213_delall()
    SELECT COUNT(*)
      INTO g_cnt
      FROM ton_file
     WHERE ton01 = g_ton_hd.ton01
       AND ton02 = g_ton_hd.ton02
    IF g_cnt = 0 THEN                      # 未輸入單身資料, 是否取消單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM ton_file
        WHERE ton01 = g_ton_hd.ton01
          AND ton02 = g_ton_hd.ton02
    END IF
END FUNCTION
 
#單身重查
FUNCTION i213_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON ton03,ton04,ton05,ton06,ton07,ton08,ton09,ton10
         FROM s_ton[1].ton03,s_ton[1].ton04,s_ton[1].ton04,s_ton[1].ton05,
              s_ton[1].ton06,s_ton[1].ton07,s_ton[1].ton08,s_ton[1].ton09,
              s_ton[1].ton10
 
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
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL i213_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i213_b_fill(p_wc2)                      #BODY FILL UP
DEFINE
    p_wc2    LIKE type_file.chr1000,      #No.FUN-680120 VARCHAR(200)
    l_cnt    LIKE type_file.num5          #No.FUN-680120 SMALLINT
        
    LET g_sql =
        "SELECT ton03,ton04,toc02,'',ton05,tor02,ton06,ton07,ton08,ton09,ton10",
        "  FROM ton_file,OUTER toc_file, ",
        "                OUTER tor_file  ",
        " WHERE ton01 ='", g_ton_hd.ton01, "' ",
        "   AND ton02 ='", g_ton_hd.ton02, "' ",
        "   AND ton_file.ton04 = toc_file.toc01 ",
        "   AND ton_file.ton05 = tor_file.tor01 ",
	"   AND ", p_wc2 CLIPPED,
        " ORDER BY ton03"
    PREPARE i213_pb
       FROM g_sql
    DECLARE i213_bcs                             #SCROLL CURSOR
     CURSOR FOR i213_pb
 
    CALL g_ton.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH i213_bcs INTO g_ton[g_cnt].*         #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT UNIQUE toa02 INTO g_ton[g_cnt].toa02 FROM toc_file,toa_file
       WHERE toc01=g_ton[g_cnt].ton04                                         
         AND toa03='6' AND toc05=toa01                                            
      LET g_cnt = g_cnt + 1
      #TQC-630107---add---
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      #TQC-630107---end---
    END FOREACH
    CALL g_ton.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
#單身顯示
FUNCTION i213_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ton TO s_ton.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()        
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
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
         CALL i213_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         EXIT DISPLAY       
 
      ON ACTION previous
         CALL i213_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         EXIT DISPLAY            
 
      ON ACTION jump
         CALL i213_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         EXIT DISPLAY             
 
      ON ACTION next
         CALL i213_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         EXIT DISPLAY          
 
      ON ACTION last
         CALL i213_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         EXIT DISPLAY              
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont() 
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION exporttoexcel  
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about        
         CALL cl_about()    
 
      ON ACTION related_document                #No.FUN-6B0043  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION  i213_chk_time(p_time,p_code)
   DEFINE p_time     LIKE ton_file.ton09,             #No.FUN-680120 VARCHAR(05)
          p_code     LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(01)
          l_time     LIKE pob_file.pob32,             #No.FUN-680120 DEC(8,4)
          l_time1    LIKE pob_file.pob32,             #No.FUN-680120 DEC(8,4)
          l_time2    LIKE pob_file.pob32              #No.FUN-680120 DEC(8,4)
         
   LET g_errno=''
#   IF length(p_time)!=5 THEN LET g_errno='apy-080' END IF                          #CHI-B40058
#   IF p_time[1,1] < '0' OR p_time[1,1] >  '2' THEN LET g_errno='apy-080' END IF    #CHI-B40058
#   IF p_time[2,2] < '0' OR p_time[2,2] >  '9' THEN LET g_errno='apy-080' END IF    #CHI-B40058
#   IF p_time[1,2] < '0' OR p_time[1,2] > '23' THEN LET g_errno='apy-080' END IF    #CHI-B40058
#   IF p_time[4,5] < '0' OR p_time[4,5] > '59' THEN LET g_errno='apy-080' END IF    #CHI-B40058
#   IF p_time[3,3]!=':'  THEN LET g_errno='apy-080' END IF                          #CHI-B40058

   IF length(p_time)!=5 THEN LET g_errno='asr-057' END IF                          #CHI-B40058
   IF p_time[1,1] < '0' OR p_time[1,1] >  '2' THEN LET g_errno='asr-057' END IF    #CHI-B40058
   IF p_time[2,2] < '0' OR p_time[2,2] >  '9' THEN LET g_errno='asr-057' END IF    #CHI-B40058
   IF p_time[1,2] < '0' OR p_time[1,2] > '23' THEN LET g_errno='asr-057' END IF    #CHI-B40058
   IF p_time[4,5] < '0' OR p_time[4,5] > '59' THEN LET g_errno='asr-057' END IF    #CHI-B40058
   IF p_time[3,3]!=':'  THEN LET g_errno='asr-057' END IF                          #CHI-B40058
 
END FUNCTION  
#NO.FUN-7C0043----Begin
FUNCTION i213_out()
    DEFINE l_cmd  LIKE type_file.chr1000
#   DEFINE
#       l_ton           RECORD LIKE ton_file.*,
#       l_i             LIKE type_file.num5,          #No.FUN-680120 SMALLINT
#       l_name          LIKE type_file.chr20,         #No.FUN-680120 VARCHAR(20)   
#       l_za05          LIKE za_file.za05 
    IF cl_null(g_wc) AND NOT cl_null(g_ton_hd.ton01)                            
       AND NOT cl_null(g_ton_hd.ton02) THEN                                     
       LET g_wc = " ton01 = '",g_ton_hd.ton01,"' AND ton02 = '",g_ton_hd.ton02,"'"
    END IF                                                                      
    IF g_wc IS NULL THEN                                                        
       CALL cl_err('','9057',0)                                                 
       RETURN                                                                   
    END IF                                                                      
    LET l_cmd = 'p_query "atmi213" "',g_wc CLIPPED,'"'   
    CALL cl_cmdrun(l_cmd)
#   IF g_wc IS NULL THEN
#      CALL cl_err('','9057',0)
#      RETURN 
#   END IF
#   CALL cl_wait()
#   CALL cl_outnam('atmi213') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT * FROM ton_file ",      # 組合出 SQL 指令
#             " WHERE ",g_wc CLIPPED
#   PREPARE i213_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i213_co                           # SCROLL CURSOR
#        CURSOR FOR i213_p1
 
#   START REPORT i213_rep TO l_name
 
#   FOREACH i213_co INTO l_ton.*
#       IF SQLCA.sqlcode THEN
#          CALL cl_err('foreach:',SQLCA.sqlcode,1)
#          EXIT FOREACH
#       END IF
#       OUTPUT TO REPORT i213_rep(l_ton.*)
#   END FOREACH
 
#   FINISH REPORT i213_rep
 
#   CLOSE i213_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i213_rep(sr)
#   DEFINE
#       l_trailer_sw    LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
#       sr RECORD LIKE ton_file.*,
#       l_toc02   LIKE toc_file.toc02,
#       l_toa02   LIKE toa_file.toa02,
#       l_tor02   LIKE tor_file.tor02,
#       l_chr     LIKE type_file.chr1                    #No.FUN-680120 VARCHAR(1)
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.ton01,sr.ton02,sr.ton03
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]   #TQC-790082
 
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<',"/pageno" 
#           PRINT g_head CLIPPED,pageno_total     
 
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]   #TQC-790082
#           PRINT
#           PRINT g_dash[1,g_len]
 
#           PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#                 g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
#                 g_x[41],g_x[42],g_x[43]
#           PRINT g_dash1 
#           LET l_trailer_sw = 'y'
 
#       BEFORE GROUP OF sr.ton01
#           PRINT COLUMN g_c[31],sr.ton01 CLIPPED;
 
#       BEFORE GROUP OF sr.ton02
#           PRINT COLUMN g_c[32],sr.ton02 USING '--------';
 
#       ON EVERY ROW
#           SELECT tor02 INTO l_tor02 FROM tor_file WHERE tor01 = sr.ton05
#           SELECT toc02,toa02 INTO l_toc02,l_toa02 FROM toa_file,toc_file
#            WHERE toc01 = sr.ton04
#              AND toa01 = toc05
#              AND toa03 = '6'
#           PRINT COLUMN g_c[33],sr.ton03 USING '--------',
#                 COLUMN g_c[34],sr.ton04 CLIPPED,
#                 COLUMN g_c[35],l_toc02 CLIPPED,
#                 COLUMN g_c[36],l_toa02 CLIPPED,
#                 COLUMN g_c[37],sr.ton05 CLIPPED,
#                 COLUMN g_c[38],l_tor02 CLIPPED,
#                 COLUMN g_c[39],sr.ton06 CLIPPED,
#                 COLUMN g_c[40],cl_numfor(sr.ton07,40,0),
#                 COLUMN g_c[41],sr.ton08 CLIPPED,
#                 COLUMN g_c[42],sr.ton09 CLIPPED,
#                 COLUMN g_c[43],sr.ton10 CLIPPED
 
#       AFTER GROUP OF sr.ton01
#           PRINT
 
#       ON LAST ROW
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#           LET l_trailer_sw = 'n'
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#NO.FUN-7C0043---End
