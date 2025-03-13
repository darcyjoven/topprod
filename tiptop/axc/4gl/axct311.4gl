# Prog. Version..: '5.30.07-13.05.16(00000)'     #
#
# Pattern name...: axct311.4gl
# Descriptions...: No.FUN-7C0101 每月人工製費維護作業
# Date & Author..: No.FUN-7C0101 08/01/14 By douzh
# Modify.........: No.FUN-830135 08/03/27 By douzh 修整成本改善bug
# Modify.........: No.FUN-830140 08/04/01 By douzh 成本改善增加成本中心開窗條件
# Modify.........: No.FUN-8B0047 08/10/21 By sherry 十號公報修改
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-970237 09/07/29 By dxfwo  單身成本中心可任意輸入，沒有after field 卡關
# Modify.........: No.FUN-980009 09/08/18 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.CHI-970021 09/08/20 By jan 拿掉t311_gen()FUNCTION
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-990020 09/09/07 By xiaofeizhu 單身“金額”“分攤基礎指標總數”、“單位成本”對負數沒有控管
# Modify.........: No.TQC-990037 09/09/09 By xiaofeizhu 成本中心字段規格化
# Modify.........: No.FUN-980031 09/11/11 By jan cdb08 可以QBE
# Modify.........: No.FUN-9B0118 09/11/27 By Carrier add cdb11/cdb00
# Modify.........: No.MOD-A10012 10/01/05 By wujie   新增时为cdb03预设值
# Modify.........: No.FUN-9C0073 10/01/13 By chenls 程序精簡
# Modify.........: No.TQC-A30142 10/03/26 By wujie  TQC-970237报错后没有控管住
# Modify.........: No.FUN-A50075 10/05/24 By lutingting GP5.2 AXC模組TABLE重新分類,相關INSERT語法修改
# Modify.........: No:TQC-A70085 10/07/20 By xiaofeizhu 隱藏狀態頁
# Modify.........: No:MOD-B30642 11/03/22 By sabrina 單身新增完第一筆後無法新增第二筆
# Modify.........: No:MOD-BB0170 12/02/17 By bart 在檢核分攤設置檔時，也因考慮axci003設定
# Modify.........: No:MOD-C90072 12/10/12 By yinhy 給cdb12默認值
# Modify.........: No:MOD-CA0171 12/10/26 By Elise 擴大num5->num10
# Modify.........: No.FUN-C80092 12/12/05 By fengrui 增加寫入日誌功能
# Modify.........: No:FUN-D40030 13/04/09 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題	
# Modify.........: No:FUN-D40086 13/04/22 by lujh 	單身在最後加上cdb12，noentry，根據cdb04取ccz15,ccz33,ccz34,ccz35,ccz36		
# Modify.........: No:MOD-D50116 13/05/14 By wujie 删除时检查对应的分录底稿是否已经抛转凭证
# Modify.........: No:FUN-D40121 13/06/24 By zhangweib 增加傳參
# Modify.........: No:MOD-DB0034 13/11/06 By bart 接收傳入參數的變數不可與qbe的變數同
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_cdb01         LIKE cdb_file.cdb01,
    g_cdb01_t       LIKE cdb_file.cdb01,
    g_cdb02         LIKE cdb_file.cdb02,
    g_cdb02_t       LIKE cdb_file.cdb02,
    g_cdb00         LIKE cdb_file.cdb00,
    g_cdb00_t       LIKE cdb_file.cdb00,
    g_cdb11         LIKE cdb_file.cdb11,
    g_cdb11_t       LIKE cdb_file.cdb11,
    g_cdb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
               cdb03 LIKE cdb_file.cdb03,      #成本中心
               cdb04 LIKE cdb_file.cdb04,      #成本項目
               cdb08 LIKE cdb_file.cdb08,
               cdb05 LIKE cdb_file.cdb05,
               cdb06 LIKE cdb_file.cdb06,
               cdb07 LIKE cdb_file.cdb07,
               cdb09 LIKE cdb_file.cdb09,  #FUN-8B0047
               cdb10 LIKE cdb_file.cdb10,  #FUN-8B0047
               cdb12 LIKE cdb_file.cdb12   #FUN-D40086  add
                    END RECORD,
     g_cdb_t        RECORD                 #程式變數 (舊值)
               cdb03 LIKE cdb_file.cdb03,  #成本中心
               cdb04 LIKE cdb_file.cdb04,  #成本項目
               cdb08 LIKE cdb_file.cdb08,
               cdb05 LIKE cdb_file.cdb05,
               cdb06 LIKE cdb_file.cdb06,
               cdb07 LIKE cdb_file.cdb07,
               cdb09 LIKE cdb_file.cdb09,  #FUN-8B0047
               cdb10 LIKE cdb_file.cdb10,  #FUN-8B0047
               cdb12 LIKE cdb_file.cdb12   #FUN-D40086  add
                    END RECORD,
     g_wc2,g_wc,g_sql    string,  #No.FUN-580092 HCN
     g_cmd           LIKE type_file.chr1000, 
     g_rec_b         LIKE type_file.num10,          #單身筆數      #MOD-CA0171 mod 
     l_ac            LIKE type_file.num5           #目前處理的ARRAY CNT    
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_chr           LIKE type_file.chr1      
DEFINE   g_cnt           LIKE type_file.num10     
DEFINE   g_msg           LIKE ze_file.ze03        
DEFINE   g_before_input_done LIKE type_file.num5  
 
DEFINE   g_row_count    LIKE type_file.num10     
DEFINE   g_curs_index   LIKE type_file.num10    
DEFINE   g_jump         LIKE type_file.num10   
DEFINE   mi_no_ask      LIKE type_file.num5   
DEFINE   g_cka00        LIKE cka_file.cka00          #No.FUN-C80092
DEFINE  g_wc1           STRING     #No.FUN-D40121   Add
 
MAIN
DEFINE p_row,p_col   LIKE type_file.num5     
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

  #No.FUN-D40121 ---Add--- Start
   LET g_wc1 = ARG_VAL(1)
   LET g_wc1 = cl_replace_str(g_wc1, "\\\"", "'")
  #No.FUN-D40121 ---Add--- End
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
         RETURNING g_time    #No.FUN-6A0146
    LET p_row = 4 LET p_col = 3
 
    OPEN WINDOW t311_w AT p_row,p_col WITH FORM "axc/42f/axct311"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
    CALL cl_set_comp_visible("page4",FALSE)        #TQC-A70085 Add

  #No.FUN-D40121 ---Add--- Start
   IF NOT cl_null(g_wc1) THEN
      CALL t311_q()
   END IF
  #No.FUN-D40121 ---Add--- End
 
    CALL t311_menu()
 
    CLOSE WINDOW t311_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) 
         RETURNING g_time    #No.FUN-6A0146
END MAIN
 
FUNCTION t311_menu()
DEFINE   l_cmd  STRING 
   WHILE TRUE
      CALL t311_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t311_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t311_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t311_b()
            END IF
         WHEN "previous"
            CALL t311_fetch('P')
         WHEN "next"
            CALL t311_fetch('N')
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "detailquery"
            IF cl_chk_act_auth() THEN
               LET l_cmd ="axcq311 '",g_cdb01,"' '",g_cdb02,"' '",g_cdb11,"' '",g_cdb00,"'"
               CALL cl_cmdrun_wait(l_cmd)
            END IF
         WHEN "exporttoexcel" #FUN-4B0015
	    CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_cdb),'','')
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_cdb01 IS NOT NULL THEN
                LET g_doc.column1 = "cdb01"
                LET g_doc.column2 = "cdb02"
                LET g_doc.value1 = g_cdb01
                LET g_doc.value2 = g_cdb02
                LET g_doc.column3 = "cdb11"
                LET g_doc.value3 = g_cdb11
                CALL cl_doc()
             END IF 
          END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t311_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_cdb.clear()
    LET g_cdb01_t = NULL
    LET g_cdb02_t = NULL
    LET g_cdb11_t = NULL
    LET g_cdb00_t = NULL
    CALL cl_opmsg('a')
    CALL s_log_ins(g_prog,'','','','') RETURNING g_cka00  #FUN-C80092 add
    WHILE TRUE
        LET g_cdb01 = NULL
        LET g_cdb02 = NULL
        LET g_cdb11 = NULL
        LET g_cdb00 = NULL
        CALL t311_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CALL s_log_upd(g_cka00,'N')          #更新日誌  #FUN-C80092
            RETURN
        END IF
        IF g_cdb01 IS NULL OR g_cdb02 IS NULL OR g_cdb11 IS NULL OR g_cdb00 IS NULL THEN   #KEY 不可空白  #No.TQC-9B0118
            CONTINUE WHILE
        END IF
        CALL g_cdb.clear()
        LET g_rec_b = 0
        CALL b_fill(g_cdb01,g_cdb02,g_cdb11)    #單身  #No.FUN-9B0118
        CALL t311_b()                           #輸入單身
        IF INT_FLAG THEN                        #使用者不玩了
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           CALL s_log_upd(g_cka00,'N')          #更新日誌  #FUN-C80092
           RETURN
        END IF
        CALL s_log_upd(g_cka00,'Y')          #更新日誌  #FUN-C80092
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t311_i(p_cmd)
   DEFINE
        p_cmd               LIKE type_file.chr1,         
        l_flag              LIKE type_file.chr1,          #判斷必要欄位是否輸入       
        l_msg1,l_msg2       LIKE type_file.chr1000,      
        l_oba02    LIKE oba_file.oba02,
        l_n                 LIKE type_file.num10          #MOD-CA0171 mod 
    CALL cl_set_head_visible("","YES")            
    INPUT g_cdb11,g_cdb01,g_cdb02,g_cdb00 WITHOUT DEFAULTS  #No.TQC-9B0118
        FROM cdb11,cdb01,cdb02,cdb00                        #No.TQC-9B0118

        BEFORE INPUT
           CALL cl_set_comp_entry('cdb00',TRUE)
 
        AFTER FIELD cdb00
           IF NOT cl_null(g_cdb00) THEN
               CALL t311_cdb00(p_cmd,g_cdb00)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_cdb00,g_errno,0)
                  LET g_cdb00 = ''
                  DISPLAY g_cdb00 TO cdb00
                  NEXT FIELD cdb00
               END IF
           END IF

        AFTER FIELD cdb02
          IF NOT cl_null(g_cdb02) THEN
              IF g_cdb02  <1 OR g_cdb02 > 12 THEN NEXT FIELD cdb02 END IF
          END IF
          CALL t311_get_cdb00(p_cmd)  #No.FUN-9B0118

        AFTER FIELD cdb01
          CALL t311_get_cdb00(p_cmd)  #No.FUN-9B0118

        AFTER FIELD cdb11
          CALL t311_get_cdb00(p_cmd)  #No.FUN-9B0118
 
        AFTER INPUT
            LET l_flag='N'
            IF INT_FLAG THEN
               CLEAR FORM
               CALL g_cdb.clear()
               EXIT INPUT
            END IF
            IF g_cdb01 IS NULL THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_cdb01
            END IF
            IF g_cdb02 IS NULL THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_cdb02
            END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(cdb00)   #帐套
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_aaa"
                 CALL cl_create_qry() RETURNING g_cdb00
                 DISPLAY g_cdb00 TO cdb00
                 NEXT FIELD cdb00
            OTHERWISE EXIT CASE
         END CASE

         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
    END INPUT
END FUNCTION
 
 
FUNCTION t311_q()
  DEFINE lc_qbe_sn    LIKE gbm_file.gbm01  
  DEFINE l_cdb01      LIKE cdb_file.cdb01
  DEFINE l_cdb02      LIKE cdb_file.cdb02
  DEFINE l_wc1        STRING  #MOD-DB0034
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE  ""
    CLEAR FORM
    CALL g_cdb.clear()
    CALL cl_set_head_visible("","YES")     
    IF cl_null(g_wc1) THEN   #No.FUN-D40121   Add
    CONSTRUCT BY NAME g_wc ON cdb11,cdb01,cdb02,cdb00  #No.FUN-9B0118
 
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
          CALL cl_qbe_list() RETURNING lc_qbe_sn
          CALL cl_qbe_display_condition(lc_qbe_sn)

       ON ACTION controlp
          CASE
             WHEN INFIELD(cdb00)       #帐套
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_aaa"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO cdb00
             OTHERWISE EXIT CASE
          END CASE
      
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cdbuser', 'cdbgrup') #FUN-980030
    IF cl_null(g_wc) THEN LET g_wc=" 1=1" END IF
 
    CONSTRUCT g_wc2 ON cdb03,cdb04,cdb08,cdb05,cdb06,cdb07,cdb09,cdb10,cdb12 #FUN-8B0047#FUN-980031 add cdb08   #FUN-D40086 add  cdb12
            FROM s_cdb[1].cdb03,s_cdb[1].cdb04,s_cdb[1].cdb08, #FUN-980031 
                 s_cdb[1].cdb05,s_cdb[1].cdb06,s_cdb[1].cdb07,
                 s_cdb[1].cdb09,s_cdb[1].cdb10,s_cdb[1].cdb12  #FUN-8B0047   #FUN-D40086 add s_cdb[1].cdb12
     
       BEFORE CONSTRUCT
          CALL cl_qbe_display_condition(lc_qbe_sn)
 
       ON ACTION CONTROLP
           CASE
             WHEN INFIELD(cdb03)
                CASE g_ccz.ccz06
                   WHEN '3'
                      CALL q_ecd(TRUE,TRUE,"")
                           RETURNING g_qryparam.multiret
                   WHEN '4'
                      CALL q_eca(TRUE,TRUE,"")
                           RETURNING g_qryparam.multiret
                   OTHERWISE
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_gem"
                      LET g_qryparam.state = 'c'
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                END CASE
                DISPLAY g_qryparam.multiret TO cdb03
                NEXT FIELD cdb03
                EXIT CASE
             #FUN-D40086--add--str--
             WHEN INFIELD(cdb12)   #科目編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag07"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cdb12
                 NEXT FIELD cdb12
             #FUN-D40086--add--end--
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
 
       ON ACTION qbe_save
          CALL cl_qbe_save()
 
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    END IF   #No.FUN-D40121   Add

    IF cl_null(g_wc)  THEN LET g_wc  = " 1=1" END IF   #No.FUN-D40121   Add
   #IF cl_null(g_wc1) THEN LET g_wc1 = " 1=1" END IF   #No.FUN-D40121   Add #MOD-DB0034
    IF cl_null(g_wc1) THEN LET l_wc1 = " 1=1" END IF   #MOD-DB0034
    IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF   #No.FUN-D40121   Add

    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT UNIQUE cdb11,cdb00,cdb01,cdb02 FROM cdb_file",  #No.TQC-9B0118
                   " WHERE ", g_wc CLIPPED,
                  #"   AND ", g_wc1 CLIPPED,    #No.FUN-D40121   Add  #MOD-DB0034
                   "   AND ", l_wc1 CLIPPED,  #MOD-DB0034
                   " ORDER BY cdb11,cdb00,cdb01,cdb02"                     #No.TQC-9B0118
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE cdb11,cdb00,cdb01,cdb02 FROM cdb_file",  #No.TQC-9B0118
                   "   WHERE ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  #"   AND ", g_wc1 CLIPPED,    #No.FUN-D40121   Add #MOD-DB0034
                   "   AND ", l_wc1 CLIPPED,  #MOD-DB0034
                   " ORDER BY cdb11,cdb00,cdb01,cdb02"                     #No.TQC-9B0118
    END IF
 
    PREPARE t311_prepare FROM g_sql
    DECLARE t311_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t311_prepare
 
    DROP TABLE x  
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT UNIQUE cdb11,cdb00,cdb01,cdb02 FROM cdb_file WHERE ",g_wc CLIPPED,  #No.TQC-9B0118
                  " INTO TEMP x"
    ELSE
        LET g_sql="SELECT UNIQUE cdb11,cdb00,cdb01,cdb02 FROM cdb_file WHERE ",  #No.TQC-9B0118
                  g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                  " INTO TEMP x"
    END IF
    PREPARE t311_precount_x FROM g_sql
    EXECUTE t311_precount_x
 
    LET g_sql="SELECT COUNT(*) FROM x "
 
    PREPARE t311_precount FROM g_sql
    DECLARE t311_count CURSOR FOR t311_precount
 
 
    MESSAGE "Searching !"
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN t311_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        LET g_cdb01 = NULL
        LET g_cdb02 = NULL
    ELSE
        OPEN t311_count
        FETCH t311_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t311_fetch('F')                  # 讀出TEMP第一筆並顯示
        MESSAGE " "
    END IF
END FUNCTION
 
FUNCTION t311_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式       
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t311_cs INTO g_cdb11,g_cdb00,g_cdb01,g_cdb02   #No.FUN-9B0118
        WHEN 'P' FETCH PREVIOUS t311_cs INTO g_cdb11,g_cdb00,g_cdb01,g_cdb02   #No.FUN-9B0118
        WHEN 'F' FETCH FIRST    t311_cs INTO g_cdb11,g_cdb00,g_cdb01,g_cdb02   #No.FUN-9B0118
        WHEN 'L' FETCH LAST     t311_cs INTO g_cdb11,g_cdb00,g_cdb01,g_cdb02   #No.FUN-9B0118
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
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
            FETCH ABSOLUTE g_jump t311_cs INTO g_cdb11,g_cdb00,g_cdb01,g_cdb02   #No.FUN-9B0118
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_cdb01 TO NULL 
        INITIALIZE g_cdb02 TO NULL
        INITIALIZE g_cdb11 TO NULL 
        INITIALIZE g_cdb00 TO NULL
    ELSE
        SELECT UNIQUE cdb00 INTO g_cdb00 FROM cdb_file 
         WHERE cdb01 = g_cdb01
           AND cdb02 = g_cdb02
           AND cdb11 = g_cdb11
        CALL t311_show()
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t311_show()
    DISPLAY g_cdb01 TO cdb01
    DISPLAY g_cdb02 TO cdb02
    DISPLAY g_cdb11 TO cdb11
    DISPLAY g_cdb00 TO cdb00
    CALL b_fill(g_cdb01,g_cdb02,g_cdb11)                         #單身  #No.FUN-9B0118
    CALL t311_tot()
    CALL cl_show_fld_cont()     
END FUNCTION
 
FUNCTION t311_tot()
  DEFINE l_cdb    RECORD LIKE cdb_file.*,
         p_ltot   LIKE cdb_file.cdb05,
         p_otot1  LIKE cdb_file.cdb05,
         p_otot2  LIKE cdb_file.cdb05,
         p_otot3  LIKE cdb_file.cdb05,
         p_otot4  LIKE cdb_file.cdb05,
         p_otot5  LIKE cdb_file.cdb05,
         l_cdb04  LIKE cdb_file.cdb04,
         l_sql    STRING     #NO.FUN-910082      
 
  LET l_sql=" SELECT cdb04 FROM cdb_file WHERE cdb01= ? ",
            "    AND cdb02=? AND cdb11 = ? " CLIPPED                #No.FUN-9B0118
  PREPARE cdb_pre2 FROM l_sql
  DECLARE cdb_cur2 CURSOR FOR cdb_pre2
 
  DECLARE cdb_cur CURSOR FOR
   SELECT * FROM cdb_file
    WHERE cdb01=g_cdb01 AND cdb02=g_cdb02
      AND cdb11=g_cdb11                       #No.FUN-9B0118
  IF STATUS THEN 
   CALL cl_err('cdb_cur',STATUS,1)       
  END IF
  LET p_ltot=0   LET p_otot1=0
  LET p_otot2=0  LET p_otot3=0
  LET p_otot4=0  LET p_otot5=0
  FOREACH cdb_cur INTO l_cdb.*
   IF STATUS THEN CALL cl_err('cdb_for',STATUS,1) EXIT FOREACH END IF
   OPEN cdb_cur2 USING l_cdb.cdb01,l_cdb.cdb02,l_cdb.cdb11                #No.FUN-9B0118
   FETCH cdb_cur2 INTO l_cdb04
   CLOSE cdb_cur2 	
   CASE l_cdb.cdb04
     WHEN '1' LET p_ltot=p_ltot+l_cdb.cdb05   #人工
     WHEN '2' LET p_otot1=p_otot1+l_cdb.cdb05 #製費一
     WHEN '3' LET p_otot2=p_otot2+l_cdb.cdb05 #製費二
     WHEN '4' LET p_otot3=p_otot3+l_cdb.cdb05 #製費三
     WHEN '5' LET p_otot4=p_otot4+l_cdb.cdb05 #製費四
     WHEN '6' LET p_otot5=p_otot5+l_cdb.cdb05 #製費五
    EXIT CASE
   END CASE
  END FOREACH
  IF p_ltot  IS NULL THEN LET p_ltot=0 END IF
  IF p_otot1 IS NULL THEN LET p_otot1=0 END IF
  IF p_otot2 IS NULL THEN LET p_otot2=0 END IF
  IF p_otot3 IS NULL THEN LET p_otot3=0 END IF
  IF p_otot4 IS NULL THEN LET p_otot4=0 END IF
  IF p_otot5 IS NULL THEN LET p_otot5=0 END IF
  DISPLAY p_ltot  TO FORMONLY.ltot
  DISPLAY p_otot1 TO FORMONLY.otot1
  DISPLAY p_otot2 TO FORMONLY.otot2
  DISPLAY p_otot3 TO FORMONLY.otot3
  DISPLAY p_otot4 TO FORMONLY.otot4
  DISPLAY p_otot5 TO FORMONLY.otot5
END FUNCTION
 
FUNCTION t311_b()
DEFINE
    l_ac_t          LIKE type_file.num5,          #未取消的ARRAY CNT  
    l_n             LIKE type_file.num10,         #檢查重複用    #MOD-CA0171 mod 
    l_lock_sw       LIKE type_file.chr1,          #單身鎖住否    
    p_cmd           LIKE type_file.chr1,          #處理狀態       
    l_possible      LIKE type_file.num5,          #用來設定判斷重複的可能性
    l_ltot          LIKE cdb_file.cdb05,
    l_otot          LIKE cdb_file.cdb05,
    l_allow_insert  LIKE type_file.num5,          #可新增否     
    l_allow_delete  LIKE type_file.num5,          #可刪除否    
    l_cmd           LIKE type_file.chr1000,  
    l_cdb12         LIKE cdb_file.cdb12           #MOD-C90072
#No.MOD-D50116 --begin 
DEFINE l_cdb13      LIKE cdb_file.cdb13
DEFINE l_nppglno    LIKE npp_file.nppglno
#No.MOD-D50116 --end
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
        "SELECT cdb03,cdb04,cdb08,cdb05,cdb06,cdb07,cdb09,cdb10,cdb12 ",  #FUN-8B0047    #FUN-D40086 add cdb12
        "  FROM cdb_file ",
        "  WHERE cdb01= ? ",
        "   AND cdb02= ? ",
        "   AND cdb11 = ? ",            #No.FUN-9B0118
        "   AND cdb03= ? ",
        "   AND cdb04= ? ",
        "   AND cdb08= ? ",
        " FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t311_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_cdb WITHOUT DEFAULTS FROM s_cdb.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK 
          
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_cdb_t.* = g_cdb[l_ac].*  #BACKUP
 
               OPEN t311_bcl USING g_cdb01,g_cdb02,g_cdb11,g_cdb_t.cdb03,g_cdb_t.cdb04,g_cdb_t.cdb08          #No.FUN-9B0118
               IF STATUS THEN
                   CALL cl_err("OPEN t311_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
               ELSE
                   FETCH t311_bcl INTO g_cdb[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_cdb_t.cdb03,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                   LET g_before_input_done = FALSE
                   LET g_before_input_done = TRUE
               END IF
               CALL cl_show_fld_cont()     
            END IF
            IF g_ccz.ccz06 ='1' THEN
               CALL cl_set_comp_entry("cdb03",FALSE)
            ELSE
               CALL cl_set_comp_entry("cdb03",TRUE)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_cdb[l_ac].* TO NULL
            LET g_cdb_t.* = g_cdb[l_ac].*         #新輸入資料
            LET g_cdb[l_ac].cdb09='2'
            CALL cl_show_fld_cont()   
            IF g_ccz.ccz06 ='1' THEN
               LET g_cdb[l_ac].cdb03 =' '    #MOD-B30642 add
               NEXT FIELD cdb04
              # LET g_cdb[l_ac].cdb03 = ' '  #No.MOD-A10012  #MOD-B30642 mark 要往前放
            ELSE
               NEXT FIELD cdb03
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            IF cl_null(g_cdb[l_ac].cdb05) THEN
               LET g_cdb[l_ac].cdb05=0
            END IF
            IF cl_null(g_cdb[l_ac].cdb06) THEN
               LET g_cdb[l_ac].cdb06=0
            END IF
            IF cl_null(g_cdb[l_ac].cdb07) THEN
               LET g_cdb[l_ac].cdb07=0
            END IF
            IF g_cdb[l_ac].cdb03 IS NULL THEN
               LET g_cdb[l_ac].cdb03= ' '
            END IF
            #No.MOD-C90072  --Begin
            CASE g_cdb[l_ac].cdb04
                WHEN '1'  LET l_cdb12 = g_ccz.ccz14
                WHEN '2'  LET l_cdb12 = g_ccz.ccz15
                WHEN '3'  LET l_cdb12 = g_ccz.ccz33
                WHEN '4'  LET l_cdb12 = g_ccz.ccz34
                WHEN '5'  LET l_cdb12 = g_ccz.ccz35
                WHEN '6'  LET l_cdb12 = g_ccz.ccz36
            END CASE 
            #No.MOD-C90072  --End
            INSERT INTO cdb_file(cdb01,cdb02,cdb03,cdb04,cdb05,
                                 cdb06,cdb07,cdb08,cdb09,cdb10,cdb12,cdblegal, #FUN-8B0047 #FUN-980009 add cdbplant,cdblegal   #FUN-A50075 del plant #MOD-C90072 add cdb12
                                 cdb11,cdb00,cdboriu,cdborig)                  #No.FUN-9B0118
                   VALUES(g_cdb01,g_cdb02,g_cdb[l_ac].cdb03,
                   g_cdb[l_ac].cdb04,g_cdb[l_ac].cdb05,
                   g_cdb[l_ac].cdb06,g_cdb[l_ac].cdb07,g_cdb[l_ac].cdb08,
                   g_cdb[l_ac].cdb09,g_cdb[l_ac].cdb10,l_cdb12,g_legal, #FUN-8B0047 #FUN-980009 add g_plant,g_legal     #FUN-A50075 del plant  #MOD-C90072 add cdb12
                   g_cdb11,g_cdb00, g_user, g_grup)                    #No.FUN-9B0118      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","cdb_file",g_cdb01,g_cdb02,SQLCA.sqlcode,"","",1) 
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
            END IF
 
        AFTER FIELD cdb03
           IF NOT cl_null(g_cdb[l_ac].cdb03) THEN                                                                                   
               CALL t311_check()        
#No.TQC-A30142 --begin                                                          
               IF NOT cl_null(g_errno) THEN                                     
                  LET g_cdb[l_ac].cdb03 = g_cdb_t.cdb03                         
                  NEXT FIELD cdb03                                              
               END IF                                                           
#No.TQC-A30142 --end  
              IF g_aaz.aaz90='Y' THEN                                                                                               
                 IF NOT s_costcenter_chk(g_cdb[l_ac].cdb03) THEN                                                                    
                    NEXT FIELD cdb03                                                                                                
                 END IF                                                                                                             
              ELSE                                                                                                                  
                 CALL t311_cdb03(g_cdb[l_ac].cdb03)                                                                                 
                 IF NOT cl_null(g_errno) THEN                                                                                       
                    CALL cl_err(g_cdb[l_ac].cdb03,g_errno,0)                                                                        
                    NEXT FIELD cdb03                                                                                                
                 END IF                                                                                                             
              END IF                                                                                                                
           END IF                                                                                                                   
 
        #check 須存在成本項目分攤設定檔(caa_file)
        AFTER FIELD cdb04
            IF NOT cl_null(g_cdb[l_ac].cdb04) THEN
               CALL t311_check()     
#No.TQC-A30142 --begin                                                          
               IF NOT cl_null(g_errno) THEN                                     
                  LET g_cdb[l_ac].cdb04 = g_cdb_t.cdb04                         
                  NEXT FIELD cdb04                                              
               END IF                                                           
#No.TQC-A30142 --end                                                                                                
               IF (g_cdb[l_ac].cdb04 !=g_cdb_t.cdb04 OR
                   g_cdb[l_ac].cdb03 !=g_cdb_t.cdb03) OR
                 (g_cdb[l_ac].cdb03 IS NOT NULL AND g_cdb_t.cdb03 IS NULL)
                  OR (g_cdb[l_ac].cdb04 IS NOT NULL AND g_cdb_t.cdb04 IS NULL) THEN
                   SELECT count(*) INTO l_n FROM cdb_file
                    WHERE cdb01 = g_cdb01
                      AND cdb02 = g_cdb02
                      AND cdb11 = g_cdb11    #No.FUN-9B0118
                      AND cdb03 = g_cdb[l_ac].cdb03
                      AND cdb04 = g_cdb[l_ac].cdb04
                   IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     IF g_ccz.ccz06 ='1' THEN
                        LET g_cdb[l_ac].cdb04 = g_cdb_t.cdb04
                        NEXT FIELD cdb04
                     ELSE
                        LET g_cdb[l_ac].cdb03 = g_cdb_t.cdb03
                        NEXT FIELD cdb03
                     END IF
                   END IF
               END IF
               CALL t311_cdb12()   #FUN-D40086 add
           END IF
 
        AFTER FIELD cdb05
           IF NOT cl_null(g_cdb[l_ac].cdb05) OR g_cdb[l_ac].cdb05 != g_cdb_t.cdb05 THEN
              IF g_cdb[l_ac].cdb05 < 0 THEN
                 CALL cl_err('','aec-020',0)
                 NEXT FIELD cdb05
              END IF   
              LET g_cdb[l_ac].cdb07 = g_cdb[l_ac].cdb05 / g_cdb[l_ac].cdb06
              DISPLAY BY NAME g_cdb[l_ac].cdb05
              DISPLAY BY NAME g_cdb[l_ac].cdb07
           END IF
 
        AFTER FIELD cdb06
           IF NOT cl_null(g_cdb[l_ac].cdb05) OR g_cdb[l_ac].cdb06 != g_cdb_t.cdb06 THEN
              IF g_cdb[l_ac].cdb06 < 0 THEN
                 CALL cl_err('','aec-020',0)
                 NEXT FIELD cdb06
              END IF   
              LET g_cdb[l_ac].cdb07 = g_cdb[l_ac].cdb05 / g_cdb[l_ac].cdb06
              DISPLAY BY NAME g_cdb[l_ac].cdb06
              DISPLAY BY NAME g_cdb[l_ac].cdb07
           END IF
 
        AFTER FIELD cdb07
           IF NOT cl_null(g_cdb[l_ac].cdb07) OR g_cdb[l_ac].cdb07 != g_cdb_t.cdb07 THEN              
              IF g_cdb[l_ac].cdb07 < 0 THEN
                 CALL cl_err('','aec-020',0)
                 NEXT FIELD cdb07
              END IF                            
           END IF
 
        AFTER FIELD cdb08
           IF NOT cl_null(g_cdb[l_ac].cdb08) THEN                                                                                   
               CALL t311_check()      
#No.TQC-A30142 --begin                                                          
               IF NOT cl_null(g_errno) THEN                                     
                  LET g_cdb[l_ac].cdb08 = g_cdb_t.cdb08                         
                  NEXT FIELD cdb08                                              
               END IF                                                           
#No.TQC-A30142 --end                                                                                               
           END IF                                                                                                                   
 
      BEFORE FIELD cdb09
         CALL t311_set_entry_b(p_cmd)
 
      AFTER FIELD cdb09
         IF cl_null(g_cdb[l_ac].cdb09) THEN
            NEXT FIELD cdb09
         END IF
           IF NOT cl_null(g_cdb[l_ac].cdb09) THEN                                                                                   
               CALL t311_check()                        
#No.TQC-A30142 --begin                                                          
               IF NOT cl_null(g_errno) THEN                                     
                  LET g_cdb[l_ac].cdb09 = g_cdb_t.cdb09                         
                  NEXT FIELD cdb09                                              
               END IF                                                           
#No.TQC-A30142 --end                                                                             
           END IF                                                                                                                   
         CALL t311_set_no_entry_b(p_cmd)
 
      AFTER FIELD cdb10
         IF cl_null(g_cdb[l_ac].cdb10) THEN
            NEXT FIELD cdb10
         END IF
 
 
        BEFORE DELETE                            #是否取消單身
            IF g_cdb_t.cdb03 IS NOT NULL AND g_cdb_t.cdb04 IS NOT NULL THEN
#No.MOD-D50116 --begin
                SELECT cdb13 INTO l_cdb13 FROM cdb_file 
                 WHERE cdb01=g_cdb01
                   AND cdb02 = g_cdb02
                   AND cdb11 = g_cdb11      
                   AND cdb03 = g_cdb_t.cdb03
                   AND cdb04 = g_cdb_t.cdb04
                   AND cdb08 = g_cdb_t.cdb08
                IF NOT cl_null(l_cdb13) THEN 
                	 SELECT nppglno INTO l_nppglno FROM npp_file 
                	  WHERE npp01  = l_cdb13 
                	    AND nppsys ='CA' 
                	    AND npp00  =8 
                	    AND npp011 =1
                	 IF NOT cl_null(l_cdb13) THEN CALL cl_err('','afa-973',1) CANCEL DELETE END IF 
                END IF 
#No.MOD-D50116 --end
                IF NOT cl_delete() THEN
                    CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM cdb_file WHERE cdb01=g_cdb01
                  AND cdb02 = g_cdb02
                  AND cdb11 = g_cdb11       #No.FUN-9B0118
                  AND cdb03 = g_cdb_t.cdb03
                  AND cdb04 = g_cdb_t.cdb04
                IF SQLCA.sqlcode THEN
                      CALL cl_err3("del","cdb_file",g_cdb01,g_cdb02,SQLCA.SQLCODE,"","",1) 
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
               LET g_cdb[l_ac].* = g_cdb_t.*
               CLOSE t311_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_cdb[l_ac].cdb03,-263,1)
                LET g_cdb[l_ac].* = g_cdb_t.*
            ELSE
                UPDATE cdb_file SET cdb03 = g_cdb[l_ac].cdb03,
                                    cdb04 = g_cdb[l_ac].cdb04,
                                    cdb05 = g_cdb[l_ac].cdb05,
                                    cdb06 = g_cdb[l_ac].cdb06,
                                    cdb07 = g_cdb[l_ac].cdb07,
                                    cdb08 = g_cdb[l_ac].cdb08,
                                    cdb09 = g_cdb[l_ac].cdb09, #FUN-8B0047
                                    cdb10 = g_cdb[l_ac].cdb10, #FUN-8B0047
                                    cdb12 = g_cdb[l_ac].cdb12  #FUN-D40086 add
                 WHERE cdb01=g_cdb01
                   AND cdb02=g_cdb02
                   AND cdb11=g_cdb11       #No.FUN-9B0118
                   AND cdb03=g_cdb_t.cdb03
                   AND cdb04=g_cdb_t.cdb04
                   AND cdb08=g_cdb_t.cdb08
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","cdb_file",g_cdb01,g_cdb02,SQLCA.SQLCODE,"","",1) 
                    LET g_cdb[l_ac].* = g_cdb_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D40030 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_cdb[l_ac].* = g_cdb_t.*
               #FUN-D40030--add--begin--							
               ELSE							
                  CALL g_cdb.deleteElement(l_ac)							
                  IF g_rec_b != 0 THEN							
                     LET g_action_choice = "detail"							
                     LET l_ac = l_ac_t							
                  END IF							
               #FUN-D40030--add--end----							
               END IF
               CLOSE t311_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030 add
            CLOSE t311_bcl
            COMMIT WORK
 
        ON ACTION CONTROLP
            CASE
              WHEN INFIELD(cdb03)
                CASE g_ccz.ccz06
                   WHEN '3'
                      CALL q_ecd(FALSE,TRUE,g_cdb[l_ac].cdb03)
                           RETURNING g_cdb[l_ac].cdb03
                   WHEN '4'
                      CALL q_eca(FALSE,TRUE,g_cdb[l_ac].cdb03)
                           RETURNING g_cdb[l_ac].cdb03
                   OTHERWISE
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_gem"
                      LET g_qryparam.default1 = g_cdb[l_ac].cdb03
                      CALL cl_create_qry() RETURNING g_cdb[l_ac].cdb03
                END CASE
                DISPLAY BY NAME g_cdb[l_ac].cdb03
                NEXT FIELD cdb03
              OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF g_ccz.ccz06 ='1' THEN
              IF INFIELD(cdb04) AND l_ac > 1 THEN
                 LET g_cdb[l_ac].* = g_cdb[l_ac-1].*
              END IF
              NEXT FIELD cdb04
           ELSE
              IF INFIELD(cdb03) AND l_ac > 1 THEN
                 LET g_cdb[l_ac].* = g_cdb[l_ac-1].*
              END IF
              NEXT FIELD cdb03
           END IF
 
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
           
        ON ACTION about        
           CALL cl_about()    
 
        ON ACTION help       
           CALL cl_show_help()
 
        ON ACTION controls    
           CALL cl_set_head_visible("","AUTO")       
 
    END INPUT
 
    #統計總人工成本/製造費用到ltot,otot
    CALL t311_tot()
    CLOSE t311_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION t311_b_askkey()
    CLEAR FORM
    CALL g_cdb.clear()
    CONSTRUCT g_wc2 ON cdb01,cdb02,cdb04,cdb05,cdb06
            FROM s_cdb[1].cdb01,s_cdb[1].cdb02,s_cdb[1].cdb04,
                 s_cdb[1].cdb05,s_cdb[1].cdb06
 
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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL t311_b_fill(g_wc2)
END FUNCTION
 
 
FUNCTION b_fill(p_cdb01,p_cdb02,p_cdb11)                      #BODY FILL UP  #No.FUN-9B0118
DEFINE p_cdb01  LIKE cdb_file.cdb01
DEFINE p_cdb02  LIKE cdb_file.cdb02
DEFINE p_cdb11  LIKE cdb_file.cdb11   #No.FUN-9B0118
DEFINE p_cdb00  LIKE cdb_file.cdb00   #No.FUN-9B0118
 
    LET g_sql =
        "SELECT cdb03,cdb04,cdb08,cdb05,cdb06,cdb07,cdb09,cdb10,cdb12 ",     #FUN-D40086 add cdb12
        "  FROM cdb_file ",
        " WHERE cdb01='",p_cdb01,"' ",
        "   AND cdb02='",p_cdb02,"' ",
        "   AND cdb11='",p_cdb11,"' ",   #No.FUN-9B0118
        "   AND ",g_wc2 CLIPPED,
        "   AND ",g_wc2 CLIPPED,
        " ORDER BY 1"
    PREPARE t311_pb FROM g_sql
    DECLARE cdb_curs CURSOR FOR t311_pb
 
    CALL g_cdb.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH cdb_curs INTO g_cdb[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_cdb.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
 
FUNCTION t311_b_fill(p_wc2)              #BODY FILL UP
DEFINE  
     p_wc2         STRING       #NO.FUN-910082  
 
    LET g_sql =
        "SELECT cdb03,cdb04,cdb08,cdb05,cdb06,cdb07,cdb09,cdb10,cdb12 ",  #FUN-8B0047  #FUN-D40086  add cdb12
        "  FROM cdb_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
 
    PREPARE t311_bp FROM g_sql
 
    CALL g_cdb.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH cdb_curs INTO g_cdb[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t311_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cdb TO s_cdb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()          
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
      ON ACTION first
         CALL t311_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY            
      ON ACTION previous
         CALL t311_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
  	 ACCEPT DISPLAY             
      ON ACTION jump
         CALL t311_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
	 ACCEPT DISPLAY             
      ON ACTION next
         CALL t311_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
	 ACCEPT DISPLAY             
      ON ACTION last
         CALL t311_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY            
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()  
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION detailquery
         LET g_action_choice="detailquery"
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
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION controls    
         CALL cl_set_head_visible("","AUTO")      
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY  
 
      ON ACTION related_document              
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
#單身
FUNCTION t311_set_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1       
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("cdb04,cdb09,cdb10",TRUE) #FUN-8B0047
   END IF
   CALL cl_set_comp_entry("cdb09,cdb10",TRUE)   #FUN-8B0047
 
END FUNCTION
 
FUNCTION t311_set_no_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1         
 
   IF INFIELD(cdb03) OR (NOT g_before_input_done) THEN
       #IF cl_null(g_cdb[l_ac].cdb03) THEN     #MOD-B30642 mark
       IF g_cdb[l_ac].cdb03 IS NULL THEN       #MOD-B30642 add
           CALL cl_set_comp_entry("cdb04",FALSE)
       END IF
   END IF
   CALL cl_set_comp_entry("cdb09",FALSE) #FUN-8B0047
   IF (g_cdb[l_ac].cdb09='2') THEN #FUN-8B0047
      CALL cl_set_comp_entry("cdb10",FALSE) #FUN-8B0047
   END IF #FUN-8B0047
 
END FUNCTION
FUNCTION  t311_check()                                                                                                              
DEFINE    l_n1            LIKE type_file.num10        #檢查      #No.TQC-970237   #MOD-CA0171 mod
DEFINE    l_n2            LIKE type_file.num10        #檢查      #MOD-BB0170 add  #MOD-CA0171 mod                                                     
                                                                                                                                    
    IF  g_cdb[l_ac].cdb03 is null OR g_cdb[l_ac].cdb04 is null OR                                                                   
        g_cdb[l_ac].cdb08 is null OR g_cdb[l_ac].cdb09 is null THEN                                                                 
                                                                                                                                    
          RETURN                                                                                                                    
    END IF                                                                                                                          
            SELECT  count(cda01||'+'||cda02||'+'||cda06||'+'||cda08)                                                                
               INTO  l_n1                                                                                                           
               FROM  cda_file                                                                                                       
              WHERE  cda01 = g_cdb[l_ac].cdb03                                                                                      
                AND  cda02 = g_cdb[l_ac].cdb04                                                                                      
                AND  cda06 = g_cdb[l_ac].cdb08                                                                                      
                AND  cda08 = g_cdb[l_ac].cdb09    
            #--------MOD-BB0170 add
             SELECT  count(cay04||'+'||cay00||'+'||cay12||'+'||cay11)                                                                
                INTO  l_n2                                                                                                           
                FROM  cay_file                                                                                                       
               WHERE  cay04 = g_cdb[l_ac].cdb03                                                                                      
                 AND  cay00 = g_cdb[l_ac].cdb04                                                                                      
                 AND  cay12 = g_cdb[l_ac].cdb08                
                 AND  cay11 = g_cdb00
                 AND  cay01 = g_cdb01
                 AND  cay02 = g_cdb02                 

             IF cl_null(l_n1) THEN LET l_n1=0 END IF
             IF cl_null(l_n2) THEN LET l_n2=0 END IF
            #--------MOD-BB0170 end
              IF (l_n1 + l_n2)< 1 THEN         #MOD-BB0170 modify                                                                                                       
                CALL cl_err('','axc-111' ,1 )                                                                                       
                RETURN                                                                                                              
              END IF                                                                                                                
                                                                                                                                    
END FUNCTION                                                                                                                        
 
FUNCTION t311_cdb03(p_cdb03)                                                                                                        
DEFINE p_cdb03         LIKE gem_file.gem01                                                                                          
DEFINE l_gemacti       LIKE gem_file.gemacti                                                                                        
                                                                                                                                    
    LET g_errno = ''                                                                                                                
    SELECT gemacti  INTO l_gemacti FROM gem_file                                                                                    
     WHERE gem01 = p_cdb03                                                                                                          
                                                                                                                                    
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1318'                                                                          
                                   LET l_gemacti = NULL                                                                             
         WHEN l_gemacti='N'        LET g_errno = '9028'                                                                             
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'                                                      
    END CASE                                                                                                                        
                                                                                                                                    
END FUNCTION                                                                                                                        

FUNCTION t311_cdb00(p_cmd,p_cdb00)
   DEFINE p_cmd           LIKE type_file.chr1
   DEFINE p_cdb00         LIKE cdb_file.cdb00
   DEFINE l_aaaacti       LIKE aaa_file.aaaacti

   LET g_errno = ' '

   SELECT aaaacti INTO l_aaaacti
     FROM aaa_file
    WHERE aaa01 = p_cdb00

   CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-095'
        WHEN l_aaaacti = 'N'     LET g_errno = '9028'
        OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------'
   END CASE

END FUNCTION

#FUN-D40086--add--str--
FUNCTION t311_cdb12()
   CASE g_cdb[l_ac].cdb04
     WHEN '1'  SELECT ccz14 INTO g_cdb[l_ac].cdb12 FROM ccz_file  
     WHEN '2'  SELECT ccz15 INTO g_cdb[l_ac].cdb12 FROM ccz_file  
     WHEN '3'  SELECT ccz33 INTO g_cdb[l_ac].cdb12 FROM ccz_file
     WHEN '4'  SELECT ccz34 INTO g_cdb[l_ac].cdb12 FROM ccz_file
     WHEN '5'  SELECT ccz35 INTO g_cdb[l_ac].cdb12 FROM ccz_file  
     WHEN '6'  SELECT ccz36 INTO g_cdb[l_ac].cdb12 FROM ccz_file
     OTHERWISE LET g_cdb[l_ac].cdb12 = NULL 
   END CASE 
END FUNCTION 
#FUN-D40086--add--end--

FUNCTION t311_get_cdb00(p_cmd)
   DEFINE p_cmd        LIKE type_file.chr1

   IF cl_null(g_cdb11) OR cl_null(g_cdb01) OR cl_null(g_cdb02) THEN
      RETURN
   END IF

   SELECT UNIQUE cdb00 INTO g_cdb00 FROM cdb_file
    WHERE cdb01 = g_cdb01 AND cdb02 = g_cdb02 AND cdb11 = g_cdb11
   IF NOT cl_null(g_cdb00) AND p_cmd = 'a' THEN
      CALL cl_set_comp_entry('cdb00',FALSE)
   END IF

END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/13
