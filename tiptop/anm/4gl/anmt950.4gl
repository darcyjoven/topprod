# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: anmt950.4gl
# Descriptions...: 內部銀行存款利息維護作業
# Date & Author..: baogui 06/10/24
# Modify.........: No.FUN-6B0030 06/11/14 By bnlent  單頭折疊功能修改
# Modify.........: No.TQC-6B0062 06/11/24 By baogui  將審核畫面的一欄位
#                                                    撥入銀行異動碼放 
#                                                    至anmt950的單身      
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740024 07/04/06 By Judy 審核時，對話框內"撥出內部銀行"開窗無資料
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760037 07/06/05 By Judy 應根據該銀行帳號所在營運中心抓取幣別
# Modify.........: No.TQC-760060 07/06/06 By chenl 確認時，撥出銀行應根據撥出營運中心來抓取和判斷。
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.TQC-860019 08/06/09 By cliare ON IDLE 控制調整
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980020 09/09/01 By douzh GP5.2架構重整，修改sub相關傳參
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980025 09/09/27 By dxfwo p_qry 跨資料庫查詢
# Modify.........: No.FUN-A50102 10/07/13 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-B40056 11/05/12 By lixia 刪除資料時一併刪除tic_file的資料
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_intob        LIKE type_file.num5          #判斷何種方式進入單身
#TQC-6B0062 ----add--begin
DEFINE   g_dbs_in       STRING     
DEFINE   g_azp03_in     LIKE azp_file.azp03       
DEFINE   g_plant_in     LIKE azp_file.azp01          #No.FUN-980025 add      
DEFINE   g_azp01_in     LIKE azp_file.azp01 
DEFINE   g_dbs_out1     STRING     
DEFINE   g_azp03_out    LIKE azp_file.azp03       
DEFINE   l_gem02        LIKE gem_file.gem02 
DEFINE   g_azp01_out    LIKE azp_file.azp01 
#TQC-6B0062 ----add--end
DEFINE   g_b            LIKE type_file.num5 
DEFINE   g_b2           LIKE type_file.num5 
DEFINE   g_dbs_out      LIKE type_file.chr2  
DEFINE   g_plant_out    LIKE type_file.chr10         #FUN-980020
DEFINE   g_nnw          RECORD LIKE nnw_file.* 
DEFINE   g_nae_hd       RECORD                       #單頭變數
            nae04            LIKE nae_file.nae04,
            nae05            LIKE nae_file.nae05,
            naeacti          LIKE nae_file.naeacti,
            naeuser          LIKE nae_file.naeuser,
            naegrup          LIKE nae_file.naegrup,
            naedate          LIKE nae_file.naedate
                        END RECORD
DEFINE    g_nae_hd_t    RECORD                       #單頭變數
               nae04         LIKE nae_file.nae04,
               nae05         LIKE nae_file.nae05,
             naeacti         LIKE nae_file.naeacti,
             naeuser         LIKE nae_file.naeuser,
             naegrup         LIKE nae_file.naegrup,
             naedate         LIKE nae_file.naedate
                        END RECORD 
DEFINE    g_nae_hd_o    RECORD                       #單頭變數
               nae04       LIKE nae_file.nae04,
               nae05       LIKE nae_file.nae05,
             naeacti       LIKE nae_file.naeacti,
             naeuser       LIKE nae_file.naeuser,
             naegrup       LIKE nae_file.naegrup,
             naedate       LIKE nae_file.naedate
                        END RECORD 
DEFINE    g_nae         DYNAMIC ARRAY OF RECORD      #程式變數(單身)
               nae01       LIKE nae_file.nae01,                                
               nac02       LIKE nac_file.nac02,                                
               nac04       LIKE nac_file.nac04,                                
               nae02       LIKE nae_file.nae02,                                
               nae03       LIKE nae_file.nae03,                                
               nae06       LIKE nae_file.nae06,                                
               nae09       LIKE nae_file.nae09,      #TQC-6B0062 add                       
               nae07       LIKE nae_file.nae07,                                
             naeconf       LIKE nae_file.naeconf,                              
              g_type       LIKE type_file.chr1,                             
               nae08       LIKE nae_file.nae08
                        END RECORD 
DEFINE   g_nae_t        RECORD                       #程式變數(舊值)
               nae01       LIKE nae_file.nae01,                                
               nac02       LIKE nac_file.nac02,                                
               nac04       LIKE nac_file.nac04,                                
               nae02       LIKE nae_file.nae02,                                
               nae03       LIKE nae_file.nae03,                                
               nae06       LIKE nae_file.nae06,                                
               nae09       LIKE nae_file.nae09,          #TQC-6B0062 add                      
               nae07       LIKE nae_file.nae07,                                
             naeconf       LIKE nae_file.naeconf,                              
              g_type       LIKE type_file.chr1,                             
               nae08       LIKE nae_file.nae08
                       END RECORD  
DEFINE   g_wc            string       
DEFINE   g_sql           string       
DEFINE   g_rec_b         LIKE type_file.num5         
DEFINE   l_ac            LIKE type_file.num5         
DEFINE   g_before_input_done LIKE type_file.num5 
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL
DEFINE   g_cnt          LIKE type_file.num10     
DEFINE   g_chr          LIKE type_file.chr1      
DEFINE   g_i            LIKE type_file.num5      
DEFINE   g_dbs_gl       LIKE type_file.chr21
DEFINE   g_dbs_nenew    LIKE type_file.chr21
DEFINE   g_i1           LIKE type_file.num5      #FOR COUNT
DEFINE   g_msg          LIKE ze_file.ze03        
DEFINE   g_row_count    LIKE type_file.num10     
DEFINE   g_curs_index   LIKE type_file.num10     
DEFINE   g_jump         LIKE type_file.num10     
DEFINE   mi_no_ask      LIKE type_file.num5      
 
#主程式開始
MAIN
  DEFINE
    p_row,p_col LIKE type_file.num5
 
    OPTIONS                                      #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                              #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ANM")) THEN
       EXIT PROGRAM
    END IF
    CALL  cl_used(g_prog,g_time,1)             #計算使用時間 (進入時間) 
          RETURNING g_time  
 
    INITIALIZE g_nae_hd.* to NULL
    INITIALIZE g_nae_hd_t.* to NULL
    INITIALIZE g_nae_hd_o.* to NULL
 
    LET p_row = 3 LET p_col = 20
 
    OPEN WINDOW t950_w AT p_row,p_col
         WITH FORM "anm/42f/anmt950" ATTRIBUTE(STYLE = g_win_style)
    CALL cl_set_comp_visible("g_type",FALSE)
    CALL cl_ui_init()
    CALL t950_menu()
    CLOSE WINDOW t950_w                          #結束畫面
    CALL  cl_used(g_prog,g_time,2)             #計算使用時間 (退出使間) 
          RETURNING g_time    
END MAIN
 
#QBE 查詢資料
FUNCTION t950_curs()
 
    CLEAR FORM #清除畫面
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INITIALIZE g_nae_hd.* TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON nae04, nae05, nae01, nae02,nae03, # 螢幕上取條件
                      nae06, nae09,nae07, nae08,naeconf      #TQC-6B0062 
         FROM nae04, nae05, 
              s_nae[1].nae01, s_nae[1].nae02, s_nae[1].nae03,
              s_nae[1].nae06, s_nae[1].nae09, s_nae[1].nae07, #TQC-6B0062 
              s_nae[1].nae08,s_nae[1].naeconf
    BEFORE CONSTRUCT
           CALL cl_qbe_init()
    ON ACTION controlp                                                        
      CASE                                                                      
         WHEN INFIELD(nae01)                                                    
              CALL cl_init_qry_var()                                              
              LET g_qryparam.state='c'                                            
              LET g_qryparam.form="q_nac"
              CALL cl_create_qry() RETURNING g_qryparam.multiret                     
              DISPLAY g_qryparam.multiret TO nae01                                
              NEXT FIELD nae01               
#TQC-6B0062--add--begin
         WHEN INFIELD(nae09)
              CALL cl_init_qry_var()
              LET g_qryparam.state='c'                                            
              LET g_qryparam.form = "q_nmc001"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO nae09
              NEXT FIELD nae09
#TQC-6B0062--add--end
                                               
         OTHERWISE EXIT CASE                                                    
     END CASE
 
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
 
    ON ACTION qbe_select
       CALL cl_qbe_select()
 
    ON ACTION qbe_save
       CALL cl_qbe_save()
       CONTINUE CONSTRUCT
 
    ON ACTION about
       CALL cl_about() 
 
    ON ACTION help          
       CALL cl_show_help()  
 
    ON ACTION controlg      
       CALL cl_cmdask()     
 
    END CONSTRUCT
 
    IF INT_FLAG THEN
        CALL t950_show()
        RETURN
    END IF
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN #只能使用自己的資料
    #       LET g_wc = g_wc clipped," AND naeuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN #只能使用相同群的資料
    #       LET g_wc = g_wc clipped," AND naegrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
    #    IF g_priv3 MATCHES "[5678]" THEN   
    #       LET g_wc = g_wc clipped," AND naegrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('naeuser', 'naegrup')
    #End:FUN-980030
 
    LET g_sql = "SELECT UNIQUE nae04, nae05 ",
                "  FROM nae_file ",
                " WHERE ", g_wc CLIPPED,
                " ORDER BY nae04"
    PREPARE t950_prepare FROM g_sql
    DECLARE t950_cs                              #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t950_prepare
 
    LET g_sql = "SELECT UNIQUE nae04, nae05",
                "  FROM nae_file ",
                " WHERE ", g_wc CLIPPED,
                " INTO TEMP x "
    DROP TABLE x
    PREPARE t950_pre_x FROM g_sql
    EXECUTE t950_pre_x
 
    LET g_sql = "SELECT COUNT(*) FROM x"
    PREPARE t950_precnt FROM g_sql
    DECLARE t950_cnt CURSOR FOR t950_precnt
END FUNCTION
 
FUNCTION t950_menu()
 
   WHILE TRUE
      CALL t950_bp("G")
      CASE g_action_choice
      WHEN "output"
           IF cl_chk_act_auth() THEN
              CALL t950_out()
           END IF
      WHEN "confirm"                 #審核時
          LET g_intob = 1
          LET g_b = 0
          IF cl_chk_act_auth() THEN
             CALL t950_b_fill(g_wc,'1')
             IF g_nae_hd.nae04 IS NOT NULL THEN   
                SELECT COUNT(*) INTO g_i1 from nae_file 
                       WHERE naeconf = 'Y' 
                         AND nae04 =  g_nae_hd.nae04
                         AND nae05 =  g_nae_hd.nae05
                IF g_i1 = g_rec_b THEN
                   CALL cl_err(g_nae_hd.nae04,'anm-057',1)
                ELSE   
                   CALL cl_set_comp_visible("g_type",TRUE)
                   CALL t950_b() 
                   IF g_b = 1 THEN 
                      LET g_b = 0 
                   ELSE                                          
                     CALL t950_y()
                   END IF                                                       
                   CALL t950_b_fill(g_wc,'1')
                   CALL cl_set_comp_visible("g_type",FALSE)       
                END IF  
              ELSE
                CALL t950_y()                                     
             END IF          
         END IF                                                       
                                                                                
      WHEN "undo_confirm"              # 取消審核時                                         
            LET g_intob = 2
            LET g_b = 0
           IF cl_chk_act_auth() THEN            
              CALL t950_b_fill(g_wc,'2')
              CALL cl_set_comp_visible("g_type",TRUE)
              IF g_nae_hd.nae04 IS NOT NULL THEN                                                                                                      
                 SELECT COUNT(*) INTO g_i1 from nae_file 
                  WHERE naeconf = 'N' 
                    AND nae04 =  g_nae_hd.nae04
                    AND nae05 =  g_nae_hd.nae05
                  IF g_i1 = g_rec_b THEN
                     CALL cl_err(g_nae_hd.nae04,'anm-056',1)
                     CALL cl_set_comp_visible("g_type",FALSE)
                  ELSE   
                     CALL t950_b()
                     IF g_b = 1  THEN
                        LET g_b = 2
                     ELSE                                  
                        CALL t950_z() 
                     END IF                                                      
                     CALL t950_b_fill(g_wc,'2')
                     CALL cl_set_comp_visible("g_type",FALSE)                                              
                  END IF
              ELSE
                 CALL t950_z()
              END IF
           END IF
 
      WHEN "query"
           IF cl_chk_act_auth() THEN
              CALL t950_q()
           END IF
      WHEN "delete"
           IF cl_chk_act_auth() THEN
              CALL t950_b_fill(g_wc,'1')
              CALL t950_r()
           END IF
      WHEN "detail"
           IF cl_chk_act_auth() THEN
              LET g_intob = 0
              CALL t950_b_fill(g_wc,'1')
              CALL t950_b()
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
                                      base.TypeInfo.create(g_nae),'','')
           END IF
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION t950_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
 
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_nae_hd.* TO NULL             
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_nae.clear()
    DISPLAY '     ' TO FORMONLY.cnt
 
    CALL t950_curs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
 
    OPEN t950_cs                                 # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_nae TO NULL
    ELSE
        OPEN t950_cnt
        FETCH t950_cnt INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t950_fetch('F')                     # 讀出TEMP第一筆並顯示
    END IF
 
END FUNCTION
 
#處理資料的讀取
FUNCTION t950_fetch(p_flag)
DEFINE    p_flag          LIKE type_file.chr1      
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t950_cs INTO g_nae_hd.nae04, g_nae_hd.nae05
        WHEN 'P' FETCH PREVIOUS t950_cs INTO g_nae_hd.nae04, g_nae_hd.nae05
        WHEN 'F' FETCH FIRST    t950_cs INTO g_nae_hd.nae04, g_nae_hd.nae05
        WHEN 'L' FETCH LAST     t950_cs INTO g_nae_hd.nae04, g_nae_hd.nae05
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
              FETCH ABSOLUTE g_jump t950_cs INTO
                    g_nae_hd.nae04, g_nae_hd.nae05
              LET mi_no_ask = FALSE            
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nae_hd.nae04, SQLCA.sqlcode, 0)
        INITIALIZE g_nae_hd.* TO NULL  #TQC-6B0105
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
 
 
    SELECT UNIQUE nae04, nae05
      FROM nae_file
     WHERE nae04 = g_nae_hd.nae04
       AND nae05 = g_nae_hd.nae05
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","nae_file",g_nae_hd.nae04,g_nae_hd.nae05,
                    SQLCA.sqlcode,"","",1)  
       INITIALIZE g_nae TO NULL
       RETURN
    END IF
    LET g_data_owner = g_nae_hd.naeuser
    LET g_data_group = g_nae_hd.naegrup   
    CALL t950_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t950_show()
 
    LET g_nae_hd.* = g_nae_hd.*                  #保存單頭舊值
    DISPLAY BY NAME g_nae_hd.nae04,              #顯示單頭值
                    g_nae_hd.nae05
    CALL t950_b_fill(g_wc,'1') #單身
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION t950_r()
DEFINE l_chr   LIKE type_file.chr1    
DEFINE l_i     LIKE type_file.num5
 
    IF s_shut(0) THEN RETURN END IF
 
    IF g_nae_hd.nae04 IS NULL THEN
        CALL cl_err('', -400, 0)
        RETURN
    END IF
 
    IF g_nae_hd.nae04 IS NOT NULL THEN                                                                                                      
       SELECT count(*) INTO g_i1 from nae_file 
        WHERE naeconf = 'Y' 
          AND nae04 =  g_nae_hd.nae04
          AND nae05 =  g_nae_hd.nae05
          IF g_i1 = g_rec_b THEN
             CALL cl_err(g_nae_hd.nae04,'anm-057',1)
             RETURN
          END IF
    END IF
    CALL t950_show()
    IF cl_delh(0,0) THEN                    
       LET l_i = 1
           WHILE l_i <= g_rec_b
                IF g_nae[l_i].naeconf = "Y"  THEN
                   LET l_i = l_i + 1  CONTINUE WHILE 
                ELSE
                   DELETE FROM nae_file
                    WHERE nae04 = g_nae_hd.nae04
                      AND nae05 = g_nae_hd.nae05
                      AND nae01 = g_nae[l_i].nae01
                      LET l_i = l_i +1 CONTINUE WHILE
                END IF 
           END WHILE
         IF STATUS THEN
            CALL cl_err3("del","nae_file",g_nae_hd.nae04,g_nae_hd.nae05,
                         SQLCA.sqlcode,"","",1)
         ELSE
            CLEAR FORM
            DROP TABLE x
            EXECUTE t950_pre_x
            CALL g_nae.clear()
            LET g_sql = "SELECT UNIQUE nae04, nae05",
                        "  FROM nae_file ",
                        " INTO TEMP y "
            DROP TABLE y
            PREPARE t950_pre_y FROM g_sql
            EXECUTE t950_pre_y
            LET g_sql = "SELECT COUNT(*) FROM y"
            PREPARE t950_precnt2 FROM g_sql
            DECLARE t950_cnt2 CURSOR FOR t950_precnt2
            OPEN t950_cnt2
            FETCH t950_cnt2 INTO g_row_count
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN t950_cs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL t950_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE                  
               CALL t950_fetch('/')
            END IF
        END IF
    END IF
    COMMIT WORK
END FUNCTION
 
#處理單身欄位(nae06,nae09)輸入
FUNCTION t950_b()
 
  DEFINE   l_ac_t          LIKE type_file.num5     #未取消的ARRAY CNT
  DEFINE   l_n             LIKE type_file.num5     #檢查重複
  DEFINE   l_lock_sw       LIKE type_file.chr1     #單身鎖住否 
  DEFINE   p_cmd           LIKE type_file.chr1     #處理狀態  
  DEFINE   l_allow_insert  LIKE type_file.num5     #可新增否  LINT
  DEFINE   l_allow_delete  LIKE type_file.num5     #可刪除否 
 
    LET g_action_choice = ""
    IF g_nae_hd.nae04 IS NULL THEN RETURN END IF
    IF s_shut(0) THEN RETURN END IF
    IF g_intob =0 THEN CALL cl_set_comp_entry("nae06,nae09",TRUE) END IF    #TQC-6B0062
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
        "SELECT nae01, '', '',nae02, nae03, nae06,nae09,nae07, ",
        "       naeconf, '',nae08 ", 
        "  FROM nae_file ",      #TQC-6B0062
        " WHERE nae04 = ? AND nae05 = ? AND nae01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t950_bcl CURSOR FROM g_forupd_sql                  # LOCK CURSOR
       IF g_nae_hd.nae04 IS NULL THEN RETURN END IF
    IF g_intob = 0 THEN
       LET l_allow_delete = cl_detail_input_auth("delete")
    ELSE
       LET l_allow_delete = "FALSE"
    END IF
       LET l_allow_insert = "FALSE"
    INPUT ARRAY g_nae WITHOUT DEFAULTS FROM s_nae.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
    BEFORE INPUT
        IF g_intob = 0 THEN
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
        END IF
        IF (g_intob = 1 OR g_intob = 2) THEN
           LET l_ac = 1
        END IF
 
    BEFORE ROW
       LET p_cmd=''
       LET l_ac = ARR_CURR()
       LET l_lock_sw = 'N'                  #DEFAULT
       LET l_n  = ARR_COUNT()
       LET g_nae[l_ac].g_type = 'Y' 
       BEGIN WORK
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'                                                       
            CALL cl_set_comp_entry("nae01,nae02,nae03,nae06,
                                    nae07,nae08,g_type",FALSE) 
            CALL cl_set_comp_entry("nae06,nae09,g_type",TRUE)   #TQC-6B0062
 
             IF g_intob = 1  THEN                    #審核時
                CALL cl_set_comp_entry("nae06,nae09",FALSE)    #TQC-6B0062
                IF g_nae[l_ac].naeconf = "Y"  THEN
                   RETURN
                END IF
             END IF
 
            IF g_intob = 2   THEN                   #取消審核時
               CALL cl_set_comp_entry("nae06,nae09",FALSE)    #TQC-6B0062
               IF g_nae[l_ac].naeconf = "N" THEN
                  RETURN
               END IF
            END IF
 
           IF g_intob = 0 THEN                     #正常進單身
              CALL cl_set_comp_entry("g_type",FALSE) 
              IF g_nae[l_ac].naeconf = "Y"  THEN  
                 RETURN
              END IF
           END IF  
 
           IF g_intob = 0 THEN
              LET g_nae_t.* = g_nae[l_ac].*    #BACKUP
              OPEN t950_bcl USING 
                   g_nae_hd.nae04,g_nae_hd.nae05,g_nae_t.nae01
                   IF STATUS THEN
                      CALL cl_err("OPEN t950_bcl:", STATUS, 1)
                      LET l_lock_sw = "Y"
                   ELSE
                      FETCH t950_bcl INTO g_nae[l_ac].*
                      SELECT nac02,nac04 INTO g_nae[l_ac].nac02,g_nae[l_ac].nac04 
                        FROM nac_file 
                        WHERE nac01 = g_nae[l_ac].nae01
                      IF SQLCA.sqlcode THEN
                         CALL cl_err(g_nae_t.nae01,SQLCA.sqlcode,1)
                         LET l_lock_sw = "Y"
                      END IF
                   END IF
                   CALL cl_show_fld_cont()
           END IF
        END IF
 
         AFTER FIELD nae06
           IF NOT cl_null(g_nae[l_ac].nae06) THEN
              IF g_nae[l_ac].nae06 < 0  THEN
                 CALL cl_err(g_nae[l_ac].nae06,'anm-068',1)
                 LET g_nae[l_ac].nae06 = g_nae_t.nae06
                 NEXT FIELD nae06
              END IF
           END IF
 
#TQC-6B0062--add--begin
       BEFORE FIELD nae09
            IF NOT cl_null(g_nae[l_ac].nae08) THEN
                CALL t950_plantnam('1',g_nae[l_ac].nae08)
            END IF
 
       AFTER FIELD nae09          
          IF g_nae[l_ac].nae09 IS NOT NULL THEN               
             #CALL t950_nnw07(g_dbs_in,g_nae[l_ac].nae09,'1')
             CALL t950_nnw07(g_plant_in,g_nae[l_ac].nae09,'1')    #FUN-A50102           
             IF NOT cl_null(g_errno) THEN 
                CALL cl_err(g_nae[l_ac].nae09,g_errno,1)            
                LET g_nae[l_ac].nae09 = g_nae_t.nae09              
                DISPLAY BY NAME g_nae[l_ac].nae09
                NEXT FIELD nae09 
             END IF         
          END IF   
 
      AFTER FIELD g_type
         IF g_nae[l_ac].nae09 IS NULL THEN
            IF g_nae[l_ac].g_type = 'Y' THEN
               IF g_intob = 1 THEN
                  CALL cl_err(g_nae[l_ac].nae01,'anm-072',1)
                  NEXT FIELD g_type
               END IF
            END IF
         END IF 
#TQC-6B0062--add--end
 
 
       BEFORE DELETE
              IF NOT cl_null(g_nae_t.nae01) THEN          
                  IF g_nae[l_ac].naeconf = "Y" THEN 
                     CALL cl_err("",'anm-105',1)
                     CANCEL DELETE
                  END IF                        
                  IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                  END IF
                  IF l_lock_sw = "Y" THEN
                      CALL cl_err("", -263, 1)
                      CANCEL DELETE
                   END IF
                   DELETE FROM nae_file             #刪除該筆單身資料
                   WHERE nae04 = g_nae_hd.nae04
                     AND nae05 = g_nae_hd.nae05
                     AND nae01 = g_nae_t.nae01
                      IF SQLCA.sqlcode THEN
                         CALL cl_err3("del","nae_file",g_nae_hd.nae04,
                                       g_nae_t.nae01,SQLCA.sqlcode,"","",1) 
                         ROLLBACK WORK
                         CANCEL DELETE
                      END IF
                      LET g_rec_b=g_rec_b-1
                      DISPLAY g_rec_b TO FORMONLY.cn2
               END IF
               COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               LET g_b = 1
               LET INT_FLAG = 0
           IF g_intob = 0 THEN
               CALL cl_err('',9001,0)
               LET g_b = 1
               LET g_nae[l_ac].* = g_nae_t.*
               CLOSE t950_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
           END IF
            IF g_intob = 0  THEN
               IF l_lock_sw = 'Y' THEN
                  CALL cl_err(g_nae[l_ac].nae01,-263,1)
                  LET g_nae[l_ac].* = g_nae_t.*
               ELSE
                  UPDATE nae_file
                     SET nae01 = g_nae[l_ac].nae01,
                         nae02 = g_nae[l_ac].nae02,
                         nae03 = g_nae[l_ac].nae03,
                         nae06 = g_nae[l_ac].nae06,
                         nae09 = g_nae[l_ac].nae09,    #TQC-6B0062  add
                         nae07 = g_nae[l_ac].nae07,
                         nae08 = g_nae[l_ac].nae08,
                         naeconf = g_nae[l_ac].naeconf
                     WHERE CURRENT OF t950_bcl
               END IF
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","nae_file",g_nae[l_ac].nae01,
                                g_nae[l_ac].nae02,SQLCA.sqlcode,"","",1) 
                  LET g_nae[l_ac].* = g_nae_t.*
                  ROLLBACK WORK
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               LET g_b = 1
               LET INT_FLAG = 0
         IF g_intob = 0 THEN
               CALL cl_err('',9001,0)
               IF p_cmd = 'u' THEN
                  LET g_nae[l_ac].* = g_nae_t.*
               END IF
               CLOSE t950_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE t950_bcl
            COMMIT WORK
        END IF
#TQC-6B0062--add--begin
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(nae09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_m_nmc01"
                 LET g_qryparam.arg1 = '1'
                 LET g_qryparam.default1 = g_nae[l_ac].nae09
#                LET g_qryparam.arg2 = g_azp03_in   #No.FUN-980025 mark
                 LET g_qryparam.plant = g_plant_in  #No.FUN-980025 add
                 CALL cl_create_qry() RETURNING g_nae[l_ac].nae09
                 DISPLAY BY NAME g_nae[l_ac].nae09
                 NEXT FIELD nae09
          END CASE
#TQC-6B0062--add--end
 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
 
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
#No.FUN-6B0030------Begin--------------                                                                                             
        ON ACTION controls                                                                                                             
           CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------  
 
        END INPUT
 
    CLOSE t950_bcl
     
    COMMIT WORK
    CALL t950_delall()
END FUNCTION
 
FUNCTION t950_delall()
 
    SELECT COUNT(*)
      INTO g_cnt
      FROM nae_file
     WHERE nae04 = g_nae_hd.nae04
       AND nae05 = g_nae_hd.nae05
 
    IF g_cnt = 0 THEN                      # 未輸入單身資料, 是否取消單頭資料
        CALL cl_getmsg('9044',g_lang) RETURNING g_msg
        ERROR g_msg CLIPPED
        DELETE FROM nae_file
     WHERE nae04 = g_nae_hd.nae04
       AND nae05 = g_nae_hd.nae05
    END IF
 
END FUNCTION
 
FUNCTION t950_b_fill(p_wc2,p_ss)          
 
#  DEFINE    p_wc2    LIKE type_file.chr1000    
  DEFINE p_wc2  STRING     #NO.FUN-910082
  DEFINE    p_ss     LIKE type_file.chr1      # 以何種方式排序
  DEFINE    l_cnt    LIKE type_file.num5       
 
    LET g_sql =
        "SELECT nae01,'','',nae02,nae03,nae06, nae09, nae07, naeconf,'',nae08",
        "  FROM nae_file",
        " WHERE nae04 ='", g_nae_hd.nae04, "' ",
        "   AND nae05 ='", g_nae_hd.nae05, "' ",
	"   AND ", p_wc2 CLIPPED
    IF p_ss='1' THEN 
       LET g_sql=g_sql CLIPPED," ORDER BY naeconf"
    ELSE
       LET g_sql=g_sql CLIPPED," ORDER BY naeconf DESC"
    END IF
    PREPARE t950_pb
       FROM g_sql
    DECLARE t950_bcs                          
     CURSOR FOR t950_pb
 
    CALL g_nae.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH t950_bcs INTO g_nae[g_cnt].*         
    SELECT nac02,nac04 INTO g_nae[g_cnt].nac02,g_nae[g_cnt].nac04 
      FROM nac_file WHERE nac01 = g_nae[g_cnt].nae01
        IF SQLCA.sqlcode THEN
           CALL cl_err('Foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF g_nae[g_cnt].nae06 < 0 THEN 
           LET g_nae[g_cnt].nae06 = 0
                  UPDATE nae_file
                     SET nae06 = 0 
                   WHERE nae04 = g_nae_hd.nae04
                     AND nae05 = g_nae_hd.nae05
                     AND nae01 = g_nae[g_cnt].nae01
        END IF
        LET g_cnt = g_cnt + 1
    END FOREACH
    CALL g_nae.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
 
FUNCTION t950_bp(p_ud)
  DEFINE p_ud   LIKE type_file.chr1    
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE) 
 
   DISPLAY ARRAY g_nae TO s_nae.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED) 
      BEFORE DISPLAY
      CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()          
     
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
 
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
 
      ON ACTION first
         CALL t950_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY              
           EXIT DISPLAY             
 
      ON ACTION previous
         CALL t950_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY                
           EXIT DISPLAY            
 
      ON ACTION jump
         CALL t950_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY                 
           EXIT DISPLAY            
 
      ON ACTION next
         CALL t950_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY                   
           EXIT DISPLAY             
 
      ON ACTION last
         CALL t950_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY                   
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
          EXIT DISPLAY
 
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
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------  
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#### ----審核時處理過程------
FUNCTION t950_y()   
                                                            
  DEFINE l_i          LIKE  type_file.chr1000                                          
  DEFINE l_m          LIKE  type_file.chr1000                                          
  DEFINE l_n          LIKE  type_file.chr1000                                          
  DEFINE l_sql        STRING
  DEFINE p_row,p_col  LIKE type_file.num5                                
  DEFINE l_nnw01      LIKE nnw_file.nnw01                                            
  DEFINE l_nnw02      LIKE nnw_file.nnw02                                            
  DEFINE li_result    LIKE type_file.num5                                            
  DEFINE l_nnw03      LIKE nnw_file.nnw03                                            
  DEFINE l_nnw07      LIKE nnw_file.nnw07                                            
  DEFINE l_nnw05      LIKE nnw_file.nnw05                                            
  DEFINE l_nmc05      LIKE nmc_file.nmc05                                            
  DEFINE l_nnw06      LIKE nnw_file.nnw06                                            
 
    IF g_nae_hd.nae04 IS NULL THEN                                                  
       CALL cl_err('',-400,0)                                                   
       RETURN                                                                   
    END IF
 #TQC-6A0062--add--begin
    LET g_b2 = 1
    WHILE g_b2 <= g_rec_b
       IF g_nae[g_b2].g_type = 'Y'  THEN
          IF g_nae[g_b2].nae09 IS NULL THEN
             CALL cl_err(g_nae[g_b2].nae01,'anm-072',1)
             LET g_nae[g_b2].g_type = 'N'
          END IF
       END IF
       LET g_b2 = g_b2 +1
    END WHILE   
       LET g_b = 0                                                                                                        
       LET g_b2 = 1                                                                                                       
       WHILE g_b2 <= g_rec_b                                                                                              
          IF g_nae[g_b2].g_type = 'Y' THEN                                                                                
             LET g_b = g_b +1 
          END IF                                                                                                          
          LET g_b2 = g_b2 +1                                                                                              
       END WHILE                                                                                                          
       IF g_b = 0 THEN CALL cl_err('','-400',1)                                                                        
          RETURN                                                                                                                         
       END IF
#TQC-6A0062--add--begin   
 
               
  IF cl_confirm('aap-222') THEN                                                 
     BEGIN WORK                                                                 
   LET p_row = 3                                                                
   LET p_col = 2                                                                
   OPEN WINDOW t9501_w AT p_row,p_col                                           
        WITH FORM "anm/42f/anmt9501"                                            
        ATTRIBUTE (STYLE = g_win_style CLIPPED)                                 
   CALL cl_ui_init()                                                
   INPUT l_nnw01,l_nnw02,l_nnw03,l_nnw05,l_nnw06,l_nnw07                
                 FROM nnw01,nnw02,nnw03,nnw05,nnw06,nnw07                 
      BEFORE INPUT
 
      AFTER FIELD nnw01
         IF l_nnw01 IS NOT NULL THEN               
            CALL t950_nnw01(l_nnw01)                                          
            IF NOT cl_null(g_errno) THEN 
              CALL cl_err(l_nnw01,g_errno,1)
              NEXT FIELD nnw01
            END IF
          END IF
 
      AFTER FIELD nnw03                                                         
         IF l_nnw03 IS NOT NULL THEN           
            CALL t950_nnw03(l_nnw03)                                          
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err(l_nnw03,g_errno,1)
               NEXT FIELD nnw03
            ELSE
               DISPLAY l_gem02 TO gem02
            END IF
         END IF
      IF cl_null(l_nnw03) THEN
         LET l_gem02 =  NULL 
         DISPLAY l_gem02 TO gem02
      END IF 
 
       AFTER FIELD nnw07                                                        
          IF l_nnw07 IS NOT NULL THEN           
             #CALL t950_nnw07(g_dbs_out1,l_nnw07,'2')
             CALL t950_nnw07(g_plant_out,l_nnw07,'2') #FUN-A50102
             IF NOT cl_null(g_errno) THEN                                                                                        
                    CALL cl_err(l_nnw07,g_errno,1)                                                                              
                    DISPLAY BY NAME l_nnw07                                                                                     
                    NEXT FIELD nnw07                                                                                                
                END IF                                       
          END IF           
          IF l_nnw06 IS NOT NULL THEN 
             CALL t950_nnw06(l_nnw05,l_nnw06)       
             IF NOT cl_NULL(g_errno) THEN
                CALL cl_err(l_nnw06,g_errno,1)
                DISPLAY BY NAME l_nnw06     
                NEXT FIELD nnw06
             END IF                   
          END IF                                    
#TQC-6B0062-----mark--begin                                                                                
#         IF l_nnw22 IS NOT NULL THEN                                                         
#            SELECT nmc05 INTO l_nmc05 FROM nmc_file WHERE nmc01 = l_nnw22 
#                                      AND nmc03 = '1'          
#                IF SQLCA.SQLCODE=100 THEN
#                CALL cl_err(l_nnw22,'anm-541',0) 
#                NEXT FIELD nnw22 
#                END IF         
#         END IF               
#TQC-6B0062-----mark--end                                                                               
                                                                                
       AFTER FIELD nnw05 
          IF l_nnw05 IS NOT NULL THEN   
             CALL t950_plantnam('2',l_nnw05)          
             IF NOT cl_null(g_errno) THEN                                                                                        
                    CALL cl_err(l_nnw05,g_errno,1)                                                                              
                    DISPLAY BY NAME l_nnw05                                                                                     
                    NEXT FIELD nnw05                                                                                                
             END IF                                            
          END IF
          IF l_nnw07 IS NOT NULL THEN           
             #CALL t950_nnw07(g_dbs_out1,l_nnw07,'2') 
             CALL t950_nnw07(g_plant_out,l_nnw07,'2')   #FUN-A50102
             IF NOT cl_null(g_errno) THEN                                                                                        
                    CALL cl_err(l_nnw07,g_errno,1)                                                                              
                    DISPLAY BY NAME l_nnw07                                                                                     
                    NEXT FIELD nnw07                                                                                                
                END IF                                       
          END IF  
          IF l_nnw06 IS NOT NULL THEN         
             CALL t950_nnw06(l_nnw05,l_nnw06)                                                                   
             IF NOT cl_NULL(g_errno) THEN
                CALL cl_err(l_nnw06,g_errno,1)
                DISPLAY BY NAME l_nnw06     
                NEXT FIELD nnw06
             END IF                  
          END IF                                     
 
       BEFORE FIELD nnw06
          IF cl_null(l_nnw05)   THEN
             CALL cl_err('','aom-423',1)    
             NEXT FIELD nnw05
          END IF                                                   
       BEFORE FIELD nnw07
          IF cl_null(l_nnw05)   THEN
             CALL cl_err('','aom-423',1)    
             NEXT FIELD nnw05
          END IF                                                   
    
       AFTER FIELD nnw06        
           IF l_nnw06 IS NOT NULL THEN 
              CALL t950_nnw06(l_nnw05,l_nnw06)       
              IF NOT cl_NULL(g_errno) THEN
                 CALL cl_err(l_nnw06,g_errno,1)
                 DISPLAY BY NAME l_nnw06     
                 NEXT FIELD nnw06
              END IF                   
           END IF                                    
           IF l_nnw07 IS NOT NULL THEN           
              #CALL t950_nnw07(g_dbs_out1,l_nnw07,'2') 
              CALL t950_nnw07(g_plant_out,l_nnw07,'2')  #FUN-A50102
              IF NOT cl_null(g_errno) THEN                                                                                        
                     CALL cl_err(l_nnw07,g_errno,1)                                                                              
                     DISPLAY BY NAME l_nnw07                                                                                     
                     NEXT FIELD nnw07                                                                                                
              END IF                                       
           END IF           
      AFTER INPUT                                                               
      IF INT_FLAG THEN CLOSE WINDOW t9501_w
#        LET INT_FLAG = 0
      END IF                                                  
 
        ON ACTION controlp                                                         
           CASE                                                                  
             WHEN INFIELD(nnw01)                                                 
                  CALL cl_init_qry_var()                                              
                  LET g_qryparam.form = "q_nmy1"                                      
                  LET g_qryparam.default1 = l_nnw01                                   
                  CALL cl_create_qry() RETURNING l_nnw01                              
                  DISPLAY BY NAME l_nnw01                                             
                  NEXT FIELD nnw01          
                                           
             WHEN INFIELD(nnw03)                                                 
                  CALL cl_init_qry_var()                                              
                  LET g_qryparam.form = "q_gem"                                       
                  LET g_qryparam.default1 = l_nnw03                                   
                  CALL cl_create_qry() RETURNING l_nnw03                              
                  DISPLAY BY NAME l_nnw03                                             
                  NEXT FIELD nnw03        
                                            
             WHEN INFIELD(nnw07)                                                 
                  CALL cl_init_qry_var()                                              
                  LET g_qryparam.form = "q_m_nmc01"        
#                 LET g_qryparam.arg2 = g_azp03_out   #No.FUN-980025 mark
                  LET g_qryparam.plant = g_plant_out  #No.FUN-980025 add  
                  LET g_qryparam.arg1 = '2'                               
                  LET g_qryparam.default1 = l_nnw07                                   
                  CALL cl_create_qry() RETURNING l_nnw07                              
                  DISPLAY BY NAME l_nnw07                                             
                  NEXT FIELD nnw07
 
             WHEN INFIELD(nnw06)                                                 
                  CALL cl_init_qry_var()                                              
#                 LET g_qryparam.form = "q_nma01"  #TQC-740024 mark
                  LET g_qryparam.form = "q_nma011" #TQC-740024
                 #LET g_qryparam.arg1 = l_nnw05      #No.TQC-760060 mark                                   
#                 LET g_qryparam.arg1 = g_azp03_out   #No.TQC-760060   #No.FUN-980025 mark                                    
                  LET g_qryparam.plant = g_plant_out  #No.FUN-980025 add  
                  LET g_qryparam.default1 = l_nnw06                                   
                  CALL cl_create_qry() RETURNING l_nnw06 
                  CALL FGL_DIALOG_SETBUFFER(l_nnw06)                             
                  DISPLAY BY NAME l_nnw06                                             
                  NEXT FIELD nnw06             
                                       
             WHEN INFIELD(nnw05)                                                 
                  CALL cl_init_qry_var()                                              
                  LET g_qryparam.form = "q_azp"                                       
                  LET g_qryparam.default1 = l_nnw05                                   
                  CALL cl_create_qry() RETURNING l_nnw05                              
                  DISPLAY BY NAME l_nnw05                                             
                  NEXT FIELD nnw05           
                   
#TQC-6B0062---mark--begin                      
#            WHEN INFIELD(nnw22)                                                 
#                 CALL cl_init_qry_var()                                              
#                 LET g_qryparam.form = "q_nmc001"                                       
#                 LET g_qryparam.default1 = l_nnw22                                   
#                 CALL cl_create_qry() RETURNING l_nnw22                              
#                 DISPLAY BY NAME l_nnw22                                             
#                 NEXT FIELD nnw22
          END CASE                                                                
#TQC-6B0062---mark--end                     
 
      #TQC-860019-add
      ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE INPUT
      #TQC-860019-add
    END INPUT
 
     LET l_m = 0         
                                                            
     IF INT_FLAG THEN 
        CLOSE WINDOW t9501_w 
        LET INT_FLAG = 0 
        LET l_m = 1
     END IF   
#生成nnw_file里面的數據                
    IF l_m = 0 THEN
       LET l_n = 1                                                                 
           WHILE l_n <= g_rec_b                                                             
              IF g_nae[l_n].g_type ="N" THEN                                          
                 LET l_n = l_n +1 
                 CONTINUE WHILE                                    
               END IF          
                IF g_nae[l_n].g_type ="Y" THEN
                   IF l_nnw05 != g_nae[l_n].nae08   THEN    
                      LET g_nnw.nnw01 = l_nnw01                                               
                      LET g_nnw.nnw02 = l_nnw02                                               
                      LET g_nnw.nnw03 = l_nnw03                                               
                      LET g_nnw.nnw05 = l_nnw05                                               
                      LET g_nnw.nnw06 = l_nnw06                                               
                      LET g_nnw.nnw07 = l_nnw07                                               
                      LET g_nnw.nnw22 = g_nae[l_n].nae09         #TQC-6B0062  modify           
                      SELECT nmc05 INTO l_nmc05 FROM nmc_file
                             WHERE nmc01 = l_nnw07                           
                      LET g_nnw.nnw04 = l_nmc05                                               
                      LET g_nnw.nnw20 = g_nae[l_n].nae08                                      
                      LET g_nnw.nnw21 = g_nae[l_n].nae01
                 #TQC-760037.....begin
                      LET g_nnw.nnwacti = 'Y'
                      LET g_nnw.nnwuser = g_user
                      LET g_nnw.nnworiu = g_user #FUN-980030
                      LET g_nnw.nnworig = g_grup #FUN-980030
                      LET g_nnw.nnwgrup = g_grup
                      LET g_nnw.nnwdate = g_today
                      #LET g_plant_new = g_nae[l_n].nae08 #FUN-A50102
                      #CALL s_getdbs()                    #FUN-A50102
                      LET l_sql = "SELECT nma10",
                                  #" FROM ",g_dbs_new CLIPPED,"nma_file",
                                  " FROM ",cl_get_target_table(g_nae[l_n].nae08,'nma_file'), #FUN-A50102
                                  " WHERE nma01 = '",g_nnw.nnw21,"'"
 	                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                      CALL cl_parse_qry_sql(l_sql,g_nae[l_n].nae08) RETURNING l_sql #FUN-A50102
                      PREPARE t950_pre FROM l_sql
                      DECLARE t950_curs CURSOR FOR t950_pre
                      FOREACH t950_curs INTO g_nnw.nnw23 END FOREACH
                 #    SELECT nma10 INTO g_nnw.nnw23 FROM nma_file
                 #           WHERE nma01 = g_nnw.nnw21   
                 #TQC-760037.....end
#                     CALL s_currm(g_nnw.nnw23,g_nnw.nnw02,'S',g_dbs_out)             #FUN-980020 mark
                      CALL s_currm(g_nnw.nnw23,g_nnw.nnw02,'S',g_plant_out)           #FUN-980020         
                             RETURNING g_nnw.nnw24                              
                      LET g_nnw.nnw25 = g_nae[l_n].nae06                                      
                      LET g_nnw.nnw26 = g_nae[l_n].nae06 * g_nnw.nnw24                        
                      LET g_nnw.nnwconf = 'N'                                                 
                      LET g_nnw.nnw08 = g_nnw.nnw23                                           
                      LET g_nnw.nnw10 = g_nnw.nnw25                                           
                      LET g_nnw.nnw11 = g_nnw.nnw26         
                      LET g_nnw.nnw09 = g_nnw.nnw24                                  
                      CALL s_auto_assign_no("anm",g_nnw.nnw01,g_nnw.nnw02,"I",
                                            "nnw_file","nnw01","","","")
                           RETURNING li_result,g_nnw.nnw01                                         
                                                                                
                  #  INSERT INTO nnx_file(nnx01)  VALUES(g_nnw.nnw01)
                     INSERT INTO nnw_file(nnw00,nnw01,nnw02,nnw03,nnw04,nnw05,                     
                                          nnw06,nnw07,nnw08,nnw09,nnw10,                    
                                          nnw11,nnw20,nnw21,nnw22,nnw23,                    
                                          nnw24,nnw25,nnw26,nnwconf,
                                          nnwacti,nnwuser,nnwgrup,nnwdate,  #TQC-760037                        
                                          nnwlegal,nnworiu,nnworig)  #FUN-980005 add legal
                                   VALUES('2',g_nnw.nnw01,g_nnw.nnw02,g_nnw.nnw03,
                                          g_nnw.nnw04,g_nnw.nnw05,g_nnw.nnw06,
                                          g_nnw.nnw07,g_nnw.nnw08,g_nnw.nnw09,
                                          g_nnw.nnw10,g_nnw.nnw11,g_nnw.nnw20,
                                          g_nnw.nnw21,g_nnw.nnw22,g_nnw.nnw23,
                                          g_nnw.nnw24,g_nnw.nnw25,g_nnw.nnw26,
                                          g_nnw.nnwconf,
                                          g_nnw.nnwacti,g_nnw.nnwuser,g_nnw.nnwgrup,g_nnw.nnwdate, #TQC-760037
                                          g_legal, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
                     LET g_nae[l_n].nae07 = g_nnw.nnw01                                     
                     UPDATE nae_file SET nae07 = g_nnw.nnw01                                
                                   WHERE nae01 = g_nae[l_n].nae01                         
                                     AND nae04 = g_nae_hd.nae04                             
                                     AND nae05 = g_nae_hd.nae05                            
                 END IF 
                 LET g_nae[l_n].naeconf = "Y"                                           
                     UPDATE nae_file SET naeconf = g_nae[l_n].naeconf                     
                      WHERE nae01 = g_nae[l_n].nae01                                
                        AND nae04 = g_nae_hd.nae04                                  
                        AND nae05 = g_nae_hd.nae05                                  
                 LET l_n = l_n+1  CONTINUE WHILE     
            ELSE LET l_n = l_n+1  CONTINUE WHILE                                    
          END IF                                                          
       END WHILE                                                                       
    END IF                                                                          
           COMMIT WORK                                                                     
           CLOSE WINDOW t9501_w                                                         
  END IF                                                                          
END FUNCTION                                                                    
######### 取消審核時處理過程------                                                                                
FUNCTION t950_z()
  DEFINE l_i     LIKE  type_file.chr1000                                          
                                                                                 
    IF g_nae_hd.nae04 IS NULL THEN                                               
       CALL cl_err('',-400,0)                                                   
       RETURN                                                                   
    END IF
 
#TQC-6A0062--add--begin
    LET g_b = 0                                                                                                                  
        LET g_b2 = 1                                                                                                                 
        WHILE g_b2 <= g_rec_b                                                                                                        
           IF g_nae[g_b2].g_type = 'Y' THEN                                                                                          
              LET g_b = g_b +1                                                                                                       
           END IF                                                                                                                    
           LET g_b2 = g_b2 +1                                                                                                        
        END WHILE                                                                                                                    
        IF g_b = 0 THEN CALL cl_err('','-400',1)                                                                                     
           RETURN                                                                                                                    
        END IF        
#TQC-6A0062--add--end
                                                              
   IF cl_confirm('aap-224') THEN                                                   
      BEGIN WORK     
#取消審核時刪除nnw_file, nnx_file ,npq_file, npp_file相關數據                                                              
      LET l_i = 1                                                                 
         WHILE  l_i<=g_rec_b                                                             
            IF g_nae[l_i].g_type ="Y"  THEN                                         
               LET g_nae[l_i].naeconf = "N"                                         
               UPDATE nae_file SET naeconf = g_nae[l_i].naeconf,                    
                                   nae07 = NULL                                     
                             WHERE nae01 = g_nae[l_i].nae01                                
                               AND nae04 = g_nae_hd.nae04                                  
                               AND nae05 = g_nae_hd.nae05                                  
               DELETE FROM nnw_file WHERE nnw01 = g_nae[l_i].nae07 
                                      AND nnwconf = 'N'   
               DELETE FROM nnx_file WHERE nnx01 = g_nae[l_i].nae07             
               DELETE FROM npq_file 
                     WHERE npqsys='NM' 
                       AND npq00 ='23' 
                       AND npq01 =g_nae[l_i].nae07 
                       AND npq011='9'
               DELETE FROM npp_file 
                     WHERE nppsys='NM' AND npp00 ='23' 
                       AND npp01 =g_nae[l_i].nae07 AND npp011='9'

               #FUN-B40056--add--str--
               DELETE FROM tic_file WHERE tic04 = g_nae[l_i].nae07
               #FUN-B40056--add--end--

               lET g_nae[l_i].nae07 = NULL       
               DISPLAY BY name g_nae[l_i].nae07
               LET l_i = l_i+1 
               CONTINUE WHILE                                         
          ELSE                                                                    
               LET l_i = l_i +1
               CONTINUE WHILE                                         
          END IF                                                                   
     END WHILE                                                                       
   END IF
   COMMIT WORK                                                              
END FUNCTION
 
FUNCTION t950_out()            
DEFINE   sr            RECORD                                                     
        nae04            LIKE nae_file.nae04,                                       
        nae05            LIKE nae_file.nae05,                                       
        nae01            LIKE nae_file.nae01,                                       
        nac02            LIKE nac_file.nac02,                                       
        nac04            LIKE nac_file.nac04,                                       
        nae02            LIKE nae_file.nae02,                                       
        nae03            LIKE nae_file.nae03,                                       
        nae06            LIKE nae_file.nae06,                                       
        nae09            LIKE nae_file.nae09,    #TQC-6B0062  add                                      
        nae07            LIKE nae_file.nae07,                                       
        naeconf          LIKE nae_file.naeconf,                                     
        nae08            LIKE nae_file.nae08                                        
                      END RECORD                                                 
DEFINE   l_name          LIKE type_file.chr20                                       
DEFINE   l_za05          LIKE za_file.za05  
 
                                         
   IF cl_null(g_nae_hd.nae04) THEN
      CALL cl_err('','9057',0)                                                
      RETURN                                                                  
   END IF                                                                      
   IF cl_null(g_nae_hd.nae05) THEN                                             
      CALL cl_err('','9057',0)                                                
      RETURN                                                                  
   END IF                                                                      
   IF cl_null(g_wc) THEN                                                       
      LET g_wc = " nae04='",g_nae_hd.nae04,"'" 
   END IF                                                                      
   CALL cl_wait()                                                              
   CALL cl_outnam('anmt950') RETURNING l_name                                  
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang                 
   LET g_sql="SELECT nae04,nae05,nae01,nac02,nac04,nae02,",
             " nae03,nae06,nae09,nae07,",   #TQC-6B0062 
             " naeconf,nae08 ",                                                
             " FROM nae_file,nac_file ",                                       
             " WHERE nac01 = nae01 AND ",g_wc CLIPPED                         
   PREPARE t950_p1 FROM g_sql                                                  
   DECLARE t950_co CURSOR FOR t950_p1
   START REPORT t950_rep TO l_name                                             
                                                                               
   FOREACH t950_co INTO sr.*                                                   
      IF SQLCA.sqlcode THEN                                                    
         CALL cl_err('foreach:',SQLCA.sqlcode,1)                               
         EXIT FOREACH                                                          
      END IF                                                                   
      OUTPUT TO REPORT t950_rep(sr.*)                                          
   END FOREACH                                                                 
                                                                               
   FINISH REPORT t950_rep                                                      
                                                                               
   CLOSE t950_co                                                               
   ERROR ""                                                                    
   CALL cl_prt(l_name,' ','1',g_len)                                           
END FUNCTION
 
REPORT t950_rep(sr)                                                             
DEFINE    l_trailer_sw    LIKE type_file.chr1                                         
DEFINE    l_str1          LIKE type_file.chr1000 
DEFINE    l_desc          LIKE ze_file.ze03 
DEFINE     sr           RECORD                                                     
        nae04            LIKE nae_file.nae04,                                       
        nae05            LIKE nae_file.nae05,                                       
        nae01            LIKE nae_file.nae01,                                       
        nac02            LIKE nac_file.nac02,                                       
        nac04            LIKE nac_file.nac04,                                       
        nae02            LIKE nae_file.nae02,                                       
        nae03            LIKE nae_file.nae03,                                       
        nae06            LIKE nae_file.nae06,                                       
        nae09            LIKE nae_file.nae09,    #TQC-6B0062  add                                      
        nae07            LIKE nae_file.nae07,                                       
        naeconf          LIKE nae_file.naeconf,                                     
        nae08            LIKE nae_file.nae08          
                       END RECORD                              
  OUTPUT                                                                       
     TOP MARGIN g_top_margin                                                              
      LEFT MARGIN g_left_margin                                                
      BOTTOM MARGIN g_bottom_margin                                                          
      PAGE LENGTH g_page_line
 
 ORDER BY sr.nae04,sr.nae05                                                   
  FORMAT                                                                       
    PAGE HEADER                                                              
     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]                      
     LET g_pageno = g_pageno + 1                                               
     LET pageno_total = PAGENO USING '<<<',"/pageno"                           
     PRINT g_head CLIPPED,pageno_total                                         
     PRINT g_dash[1,g_len]                                                     
     LET l_trailer_sw = 'y'
 
 BEFORE GROUP OF sr.nae05
     SKIP TO TOP OF PAGE
     PRINT COLUMN 01,g_x[31] CLIPPED,sr.nae04
     PRINT COLUMN 01,g_x[32] CLIPPED,sr.nae05
     PRINT g_dash2[1, g_len]                                                    
     PRINT g_x[33],g_x[34],g_x[35],                            
           g_x[36],g_x[37],g_x[38],g_x[43],g_x[39],g_x[40],g_x[41]                    #TQC-6B0062 
     PRINT g_dash1                                                             
                                                                               
 ON EVERY ROW               
        CASE sr.nae02                                                                                                             
            WHEN "0"  CALL cl_getmsg('anm-199',g_lang) RETURNING l_desc                                                            
            WHEN "1"  CALL cl_getmsg('anm-198',g_lang) RETURNING l_desc                                                            
            WHEN "2"  CALL cl_getmsg('anm-197',g_lang) RETURNING l_desc                                                            
            WHEN "3"  CALL cl_getmsg('anm-196',g_lang) RETURNING l_desc                                                            
            WHEN "4"  CALL cl_getmsg('anm-195',g_lang) RETURNING l_desc                                                            
            WHEN "5"  CALL cl_getmsg('anm-194',g_lang) RETURNING l_desc   
            OTHERWISE LET l_desc = NULL                                                         
         END CASE                                                   
     PRINT                                                                     
           COLUMN g_c[33],sr.nae01,                                            
           COLUMN g_c[34],sr.nac02,
           COLUMN g_c[35],sr.nac04,
           COLUMN g_c[36],l_desc,
           COLUMN g_c[37],cl_numfor(sr.nae03,37,6),     
           COLUMN g_c[38],cl_numfor(sr.nae06,38,6),
           COLUMN g_c[43],sr.nae09,          #TQC-6B0062                                  
           COLUMN g_c[39],sr.nae07,                                            
           COLUMN g_c[40],sr.naeconf,                                          
           COLUMN g_c[41],sr.nae08                                             
                                                                               
    ON LAST ROW                                                                   
            PRINT g_dash[1,g_len]                                                     
            LET l_trailer_sw = 'n'                                             
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED      
                                                                               
    AFTER  GROUP OF sr.nae04                                                      
 
   PAGE TRAILER                                                                  
        IF l_trailer_sw = 'y' THEN                                          
           PRINT g_dash[1,g_len]                                           
           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED   
        ELSE                                                              
           SKIP 2 LINE                                                     
        END IF                                                              
END REPORT
 
##TQC-6B0062   add----begin
FUNCTION t950_plantnam(p_code,p_plant)                                                                                        
  DEFINE  p_plant   LIKE nnw_file.nnw05            
  DEFINE  p_code    LIKE type_file.chr1                                                                               
  DEFINE  l_azp01   LIKE azp_file.azp01                                                                                            
  DEFINE  l_azp02   LIKE azp_file.azp02                                                                                            
  DEFINE  l_azp03   LIKE azp_file.azp03                                                                                             
                                                                                                                                    
   LET g_errno = ' '                                                                                                                
                                                                                                                                    
   SELECT azp01,azp02,azp03 INTO l_azp01,l_azp02,l_azp03  FROM azp_file                                                             
    WHERE azp01 = p_plant                                                                                                           
                                                                                                                                    
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg9142'                                                                            
                           LET l_azp02 = NULL                                                                                       
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'                                                              
   END CASE
   IF cl_null(g_errno) THEN
      CASE p_code
           WHEN '1' 
              LET g_azp01_in = l_azp01                                                                                                
              LET g_azp03_in = l_azp03                                                                                                
              LET g_plant_in = l_azp01   #No.FUN-980025 add
              LET g_dbs_in = s_dbstring(l_azp03)               
           WHEN '2'
              LET g_azp01_out = l_azp01                                                                                               
              LET g_azp03_out = l_azp03                                                                                               
              LET g_plant_out = l_azp01      #FUN-980020
              LET g_dbs_out1  = s_dbstring(l_azp03)
      END CASE
   END IF                                                                               
END FUNCTION
 
#FUNCTION t950_nnw07(p_dbs,p_nmc01,p_nmc03)  #銀行存提異動碼    
FUNCTION t950_nnw07(l_plant,p_nmc01,p_nmc03)  #FUN-A50102                                                       
   DEFINE p_nmc01   LIKE nmc_file.nmc01                                                                                            
   DEFINE p_nmc03   LIKE nmc_file.nmc03    #存提別: 1:存(借)  2:提(貸)                                                             
   #DEFINE p_dbs     LIKE type_file.chr21 
   DEFINE l_plant   LIKE type_file.chr21      #FUN-A50102
   DEFINE 
          #l_sql     LIKE type_file.chr1000  
          l_sql        STRING       #NO.FUN-910082                                                               
   DEFINE l_nmc02   LIKE nmc_file.nmc02                                                                                            
   DEFINE l_nmc03   LIKE nmc_file.nmc03                                                                                            
   DEFINE l_nmcacti LIKE nmc_file.nmcacti                                                                                           
                                                                                                                                    
   LET g_errno = ' '                                                                                                                
                                                                                                                                    
   #LET l_sql= "SELECT nmc02,nmc03,nmcacti FROM ",p_dbs CLIPPED,"nmc_file",
   LET l_sql= "SELECT nmc02,nmc03,nmcacti FROM ",cl_get_target_table(l_plant,'nmc_file'), #FUN-A50102    
              " WHERE nmc01 = '",p_nmc01,"'"                                                                                        
                                                                                                                                    
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
   PREPARE nmc_pre FROM l_sql                                                                                                       
   DECLARE nmc_cur CURSOR FOR nmc_pre                                                                                               
                                                                                                                                    
   OPEN nmc_cur                                                                                                                     
   FETCH nmc_cur INTO l_nmc02,l_nmc03,l_nmcacti
 
   CASE                                                                                                                             
      WHEN SQLCA.SQLCODE = 100                                                                                                      
         LET g_errno = 'anm-024'                                                                      
         LET l_nmc03 = NULL                                                                                                         
         LET l_nmcacti = NULL       
      WHEN l_nmc03 <> p_nmc03                                                                                                       
         LET g_errno = "anm-019"                                                                                                
      WHEN l_nmcacti = 'N'                                                                                                          
         LET g_errno = '9028'                                                                                                       
      OTHERWISE                                                                                                                     
         LET g_errno = SQLCA.SQLCODE USING '-------'                                                                                
   END CASE
 
END FUNCTION
 
##TQC-6B0062   add----end
FUNCTION t950_nnw06(p_nnw05,p_nnw06)
 
  DEFINE l_nmaacti    LIKE  nma_file.nmaacti                                          
  DEFINE l_nma38      LIKE  nma_file.nma38                                          
  DEFINE l_nma37      LIKE  nma_file.nma37                                          
  DEFINE p_nnw05      LIKE  nnw_file.nnw05                                          
  DEFINE p_nnw06      LIKE  nnw_file.nnw06        
  DEFINE l_sql        STRING
                                  
   LET g_errno = ''               
                  
  #No.TQC-760060--begin--
  #SELECT nmaacti,nma37,nma38 INTO l_nmaacti,l_nma37,l_nma38 
  #  FROM nma_file WHERE nma01 = p_nnw06 
   #LET l_sql="SELECT nmaacti,nma37,nma38 FROM ",g_dbs_out1 CLIPPED,"nma_file ",
   LET l_sql="SELECT nmaacti,nma37,nma38 FROM ",cl_get_target_table(g_plant_out,'nma_file'), #FUN-A50102
             " WHERE nma01 = '",p_nnw06 CLIPPED,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_out) RETURNING l_sql #FUN-A50102
   PREPARE t950_nnw06_prepare FROM l_sql
   DECLARE t950_nnw06cs CURSOR FOR t950_nnw06_prepare
   OPEN t950_nnw06cs
   FETCH t950_nnw06cs INTO l_nmaacti,l_nma37,l_nma38
  #No.TQC-760060--end--
     CASE WHEN SQLCA.SQLCODE=100 
               LET g_errno = 'anm-029'
          WHEN l_nmaacti = 'N'         
               LET g_errno ='9028'    
          WHEN l_nma37 <> 0
               LET g_errno ='anm-076'
          WHEN l_nma38 <> p_nnw05
               LET g_errno ='anm-080'
          OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
    CLOSE t950_nnw06cs
END FUNCTION 
 
FUNCTION t950_nnw01(p_nnw01)
 
  DEFINE  l_nmydmy6    LIKE nmy_file.nmydmy6
  DEFINE  l_nmykind    LIKE nmy_file.nmykind
  DEFINE  l_nmyacti    LIKE nmy_file.nmyacti
  DEFINE  p_nnw01      LIKE nnw_file.nnw01
  DEFINE  l_nmydmy3    LIKE nmy_file.nmydmy3    #No.TQC-760060
 
   LET g_errno = ''
 
   SELECT nmydmy3,nmydmy6,nmykind,nmyacti            #No.TQC-760060 add nmydmy3
     INTO l_nmydmy3,l_nmydmy6,l_nmykind,l_nmyacti    #No.TQC-760060 add l_nmydmy3
     FROM nmy_file WHERE nmyslip = p_nnw01
        CASE WHEN SQLCA.SQLCODE=100
                  LET g_errno = 'anm-540'
             WHEN l_nmydmy6 <> 'N'
                  LET g_errno = 'anm-085'
             WHEN l_nmydmy3 = 'Y'
                  LET g_errno = 'anm-162'
             WHEN l_nmykind <> 'I'
                  LET g_errno = 'anm-083'
             WHEN l_nmyacti = 'N'
                  LET g_errno = '9028'
             OTHERWISE
                  LET g_errno = SQLCA.SQLCODE USING '-------'
        END CASE
END FUNCTION         
 
FUNCTION t950_nnw03(p_nnw03)
 
  DEFINE  p_nnw03     LIKE nnw_file.nnw03
  DEFINE  l_gemacti   LIKE gem_file.gemacti
 
     LET g_errno = ''
 
     SELECT gem02,gemacti INTO l_gem02,l_gemacti 
                          FROM gem_file WHERE gem01 = p_nnw03
         CASE WHEN SQLCA.SQLCODE=100 
                   LET g_errno = 'aap-039'
              WHEN l_gemacti = 'N'
                   LET g_errno = '9028'
              OTHERWISE
                   LET g_errno = SQLCA.SQLCODE USING '-------' 
         END CASE
END FUNCTION
