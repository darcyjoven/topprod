# Prog. Version..: '5.30.06-13.04.22(00010)'     #
 
# Pattern name...: aglt600.4gl
# Descriptions...: 預算維護作業
# Date & Author..: No.FUN-810069 08/02/27 By Zhangyajun
# Modify.........: No.FUN-810069 08/03/04 By lynn s_getbug()新增參數 部門編號afb041,專案代碼afb042
# Modify.........: No.TQC-830032 08/03/24 By Zhangyajun 調整年預算和季預算邏輯
# Modify.........: No.FUN-840002 08/04/01 By Zhangyajun 修改BUG:更改取消后復制出錯
# Modify.........: No.TQC-840018 08/04/08 By Zhangyajun 1:BUG修改：增加預設值
#                                                       2:規格變動：根據aza08動態隱藏afb04,afb042
# Modify.........: No.MOD-840181 08/04/21 By Zhangyajun BUG修改：1:處理單身尾數 2:欄位控管
# Modify.........: No.MOD-840676 08/04/29 By Zhangyajun BUG修改：單身帶出問題
# Modify.........: No.FUN-850027 08/05/23 By douzh 部門匯總到科目預算,并新增一筆科目預算進正式預算資料檔
# Modify.........: No.FUN-850027 08/05/29 By douzh WBS編碼錄入時要求時尾階并且為成本對象的WBS編碼
#                                            依利潤中心參數來決定部門開窗取舍
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-8C0092 08/12/17 By alex 調整SELECT語法
# Modify.........: No.MOD-8C0168 08/12/18 By Sarah 已有"已消耗預算"之預算資料應不可刪除
# Modify.........: No.FUN-930106 09/03/17 By destiny 對預算項目afb01字段增加管控
# Modify.........: No.CHI-950007 09/05/15 By Carrier EXECUTE后接prepare_id,非cursor_id
# Modify.........: No.FUN-950077 09/05/22 By dongbg 預算項目統一為費用原因/預算項目 
# Modify.........: No.MOD-950286 09/06/02 By Sarah 檢核輸入的成本中心值合理性時,出現回傳值多筆的錯誤訊息
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 增加"專案未結案"的判斷
# Modify.........: No.FUN-9A0024 09/10/10 By destiny display xxx.*改為display對應欄位
# Modify.........: No:FUN-9B0073 09/11/10 By wujie  5.2SQL转标准语法
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No:MOD-9C0034 09/12/04 By Smapmin 單身刪除時沒有重新計算單頭預算
# Modify.........: No:MOD-9C0038 09/12/04 By Smapmin 修改複製功能的處理
# Modify.........: No:MOD-9C0057 09/12/18 By wujie   afb04和afb042插入數據庫前檢查不能為null
# Modify.........: No.FUN-9C0072 10/01/18 By vealxu 精簡程式碼
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.MOD-A40172 10/04/29 By sabrina 輸入的科目要有做預算管理 (aag21='Y')
# Modify.........: No.TQC-A60061 10/06/13 By xiaofeizhu agli104中設為拒絕的部門不可錄入 
# Modify.........: No.TQC-A60059 10/06/17 By Carrier 科目开查过滤aag21<>'Y' & 复制字段检查重写
# Modify.........: No.MOD-AA0135 10/10/22 By Dido 新增單身時 afc08/afc09 應為 0  
# Modify.........: No:TQC-960206 10/11/08 By Sabrina _a()段少了BEGIN WORK 和 ROLLBACK WORK
# Modify.........: No:CHI-9C0004 10/11/25 By Summer 點選"生成科目預算"ACTION,應將舊資料刪除後再重新產生
# Modify.........: No.MOD-AC0009 10/12/01 By wujie
#                                                   aglt600科目编号afb02开窗挑选只作预算的科目aag21='Y'， aag07<>'1'    
#                                                   aglt600复制功能不可能，录入科目时就程序就死掉了                     
#                                                   aglt600中单身依月录入至13笔无法确定，无法删除，无法上移至上一笔作更改
# Modify.........: No.MOD-AC0400 10/12/29 By Dido 新增時,單身異動應無須計算 afc07  
# Modify.........: No.FUN-B10048 11/01/20 By zhangll AFTER FIELD 科目时开窗自动过滤
# Modify.........: No.MOD-B30193 11/03/16 By lixia 允許輸入預算為0的資料,單身輸入增加控管
# Modify.........: No.MOD-B30385 11/03/17 By lixia afbgrup赋值
# Modify.........: No.MOD-B30681 11/03/28 By Dido cs 段筆數計數調整
# Modify.........: No.TQC-B50068 11/05/16 By yinhy 若科目在agli102有勾選要做預算管理沒有勾選做部門管理,應該不允許輸入部門欄資料
# Modify.........: No.TQC-B50094 11/05/18 By wujie azf07 -->azf14 
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80057 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: No.MOD-B90153 11/09/20 By Polly 修正afbrup是null，查詢不到資料

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.MOD-C30249 12/03/10 by lujh afb01 開窗使用 q_azf01a 改用 q_azf4   取消 LET g_qryparam.arg1 = '7' 傳遞
# Modify.........: No.MOD-C30254 12/03/12 By wangrr 在START REPORT之前設置g_page_line=66
# Modify.........: No.MOD-C30638 12/03/13 By wangrr 單身操作完成后，點擊確定操作無法離開
# Modify.........: No.CHI-C30002 12/05/18 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/03 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

IMPORT os   #No.FUN-9C0009 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  g_afb    RECORD LIKE afb_file.*,
        g_afb_t  RECORD LIKE afb_file.*,
        g_afb_o  RECORD LIKE afb_file.*,
        g_afc   DYNAMIC ARRAY OF RECORD 
                afc05   LIKE afc_file.afc05,
                afc06   LIKE afc_file.afc06,
                afc08   LIKE afc_file.afc08,
                afc09   LIKE afc_file.afc09,
                afc07   LIKE afc_file.afc07
                        END RECORD,
        g_afc_t RECORD
                afc05   LIKE afc_file.afc05,
                afc06   LIKE afc_file.afc06,
                afc08   LIKE afc_file.afc08,
                afc09   LIKE afc_file.afc09,
                afc07   LIKE afc_file.afc07
                        END RECORD,
        g_afc_o RECORD
                afc05   LIKE afc_file.afc05,
                afc06   LIKE afc_file.afc06,
                afc08   LIKE afc_file.afc08,
                afc09   LIKE afc_file.afc09,
                afc07   LIKE afc_file.afc07
                        END RECORD
DEFINE  g_sql           STRING
DEFINE  g_wc            STRING
DEFINE  g_wc2           STRING
DEFINE  g_rec_b         LIKE type_file.num5
DEFINE  l_ac            LIKE type_file.num5
DEFINE  g_forupd_sql    STRING
DEFINE  g_before_input_done     LIKE type_file.num5
DEFINE  g_chr           LIKE type_file.chr1
DEFINE  g_cnt           LIKE type_file.num10
DEFINE  g_i             LIKE type_file.num5
DEFINE  g_msg           LIKE ze_file.ze03
DEFINE  g_row_count     LIKE type_file.num10
DEFINE  g_curs_index    LIKE type_file.num10
DEFINE  g_jump          LIKE type_file.num10
DEFINE  g_no_ask       LIKE type_file.num5
DEFINE  g_str           STRING
DEFINE  g_aaa03         LIKE aaa_file.aaa03
DEFINE  bookno          LIKE aaa_file.aaa01        #No.FUN-850027 
DEFINE  yyy             LIKE type_file.num10       #No.FUN-850027 
 
MAIN
    OPTIONS                            
       INPUT NO WRAP
    DEFER INTERRUPT                      
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AGL")) THEN
       EXIT PROGRAM
    END IF
  
    CALL cl_used(g_prog,g_time,1) RETURNING g_time   
 
    LET g_forupd_sql="SELECT * FROM afb_file WHERE afb00 = ? AND afb01 = ? AND afb02 = ? AND afb03 = ? ",
 " AND afb04 = ? AND afb041 =? AND afb042 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t600_cl CURSOR FROM g_forupd_sql
    
    OPEN WINDOW t600_w WITH FORM "agl/42f/aglt600"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
   
    IF g_aza.aza08='N' THEN
       CALL cl_set_comp_visible("afb04,afb042",FALSE)
       CALL cl_set_comp_visible("pja02",FALSE)
    END IF
    CALL t600_menu()
    CLOSE WINDOW t600_w                   
    CALL cl_used(g_prog,g_time,2) RETURNING g_time   
             
END MAIN
 
FUNCTION t600_bp(p_ud)
 
   DEFINE  p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = ''
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_afc TO s_afc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
        CALL cl_navigator_setting(g_curs_index,g_row_count)
        
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   
      
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL t600_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION previous
         CALL t600_fetch('P')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION jump
         CALL t600_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION next
         CALL t600_fetch('N')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION last
         CALL t600_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY   
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION acct_budget
         LET g_action_choice="acct_budget"
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
      # Standard 4ad ACTION
      ##########################################################################
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
 
      ON ACTION about         
         CALL cl_about()      
            
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      AFTER DISPLAY
         CONTINUE DISPLAY
      ON ACTION related_document
         LET g_action_choice = 'related_document'
         EXIT DISPLAY
 
      ON ACTION controls                                                        
         CALL cl_set_head_visible("","AUTO")
  END DISPLAY
  CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t600_menu()
 
   WHILE TRUE
      CALL t600_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t600_q()
            END IF
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t600_a()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t600_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t600_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t600_x()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t600_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t600_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "acct_budget"
            IF cl_chk_act_auth() THEN
               CALL t600_g()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t600_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()       
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_afc),'','')
             END IF
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF NOT cl_null(g_afb.afb00) THEN
                    LET g_doc.column1 = "afb00"
                    LET g_doc.value1 = g_afb.afb00
                    CALL cl_doc()
                 END IF
              END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t600_cs()
    CLEAR FORM
    CALL g_afc.clear()
    CALL cl_set_head_visible("","YES")
    INITIALIZE g_afb.* TO NULL
    
    CONSTRUCT BY NAME g_wc ON                               
        afb00,afb03,afb01,afb02,afb041,afb042,afb04,afb09,afb18,afb19,   #MOD-840181
        afb05,afb06,afb07,afb10,afb11,afb12,afb13,afb14,
        afbuser,afbgrup,afbmodu,afbdate,afbacti
             
        BEFORE CONSTRUCT
                CALL cl_qbe_init()
             
        ON ACTION controlp
           CASE
              WHEN INFIELD(afb041)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_afb.afb041
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO afb041
                 NEXT FIELD afb041
               WHEN INFIELD(afb01)
                 CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_azf01a"                   #No.FUN-930106   #MOD-C30249  mark
                 LET g_qryparam.form = "q_azf4"                      #MOD-C30249  add 
                 LET g_qryparam.state = "c"
                 #LET g_qryparam.arg1 = '7'                          #No.FUN-950077   #MOD-C30249  mark
                 LET g_qryparam.default1 = g_afb.afb01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO afb01
                 NEXT FIELD afb01
               WHEN INFIELD(afb02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.where = " aag03='2' AND aag07 IN ('2','3') AND aag21='Y'"  #No.TQC-A60059
                 LET g_qryparam.default1 = g_afb.afb02
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO afb02
                 NEXT FIELD afb02
               WHEN INFIELD(afb042)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pja"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_afb.afb042
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO afb042
                 NEXT FIELD afb042
               WHEN INFIELD(afb04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pjb"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_afb.afb04
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO afb04
                 NEXT FIELD afb04
              OTHERWISE
                 EXIT CASE
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
 
        ON ACTION qbe_select                      
     	  CALL cl_qbe_select()
          
        ON ACTION qbe_save                        
          CALL cl_qbe_save()
		
    END CONSTRUCT
 
    #LET g_wc = g_wc CLIPPED," AND afbgrup LIKE '",        #MOD-B90153 mark
    #           g_grup CLIPPED,"%'"                        #MOD-B90153 mark
 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('afbuser', 'afbgrup')
   
    CONSTRUCT g_wc2 ON afc05,afc06,afc08,afc09,afc07 
                    FROM s_afc[1].afc05,s_afc[1].afc06,s_afc[1].afc08,s_afc[1].afc09,s_afc[1].afc07
                                                
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
        RETURN
        END IF
    LET g_wc2=g_wc2 CLIPPED
    IF  g_wc2=" 1=1" THEN       
         LET g_sql="SELECT afb00,afb01,afb02,afb03,afb04,afb041,afb042 FROM afb_file ", 
        " WHERE ",g_wc CLIPPED, " ORDER BY afb00,afb01,afb02,afb03,afb04,afb041,afb042"
    ELSE                                 
    LET g_sql=
        "SELECT UNIQUE afb_file.afb00,afb01,afb02,afb03,afb04,afb041,afb042",
        " FROM afb_file,afc_file",
        " WHERE afb00 = afc00 AND afb01 = afc01",
        "   AND afb02 = afc02 AND afb03 = afc03",
        "   AND afb04 = afc04 AND afb041 = afc041",
        "   AND afb042 = afc042",
        " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
        " ORDER BY afb00,afb01,afb02,afb03,afb04,afb041,afb042"
    END IF
    PREPARE t600_prepare FROM g_sql
    DECLARE t600_cs SCROLL CURSOR WITH HOLD FOR t600_prepare
    IF g_wc2=" 1=1" THEN
        LET g_sql="SELECT COUNT(*) FROM afb_file WHERE ",g_wc CLIPPED
    ELSE
       #LET g_sql="SELECT COUNT(DISTINCT afb01) FROM afb_file,afc_file WHERE", #MOD-B30681 mark
        LET g_sql="SELECT afb00,afb01,afb02,afb03,afb04,afb041,afb042 ",       #MOD-B30681 
                  "  FROM afb_file,afc_file WHERE ",                           #MOD-B30681 
                " afb00 = afc00 AND afb01 = afc01",
                "   AND afb02 = afc02 AND afb03 = afc03",
                "   AND afb04 = afc04 AND afb041 = afc041",
                "   AND afb042 = afc042 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED, #MOD-B30681
                "  GROUP BY afb00,afb01,afb02,afb03,afb04,afb041,afb042 ",        #MOD-B30681
                "   INTO TEMP x"                                                  #MOD-B30681
       #-MOD-B30681-add-
        DROP TABLE x
        PREPARE t600_precount_x FROM g_sql
        EXECUTE t600_precount_x
        LET g_sql="SELECT COUNT(*) FROM x"
       #-MOD-B30681-end-
    END IF 
    PREPARE t600_precount FROM g_sql
    DECLARE t600_count CURSOR FOR t600_precount
END FUNCTION
 
FUNCTION t600_q()
    
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    CALL cl_opmsg('q')   
    CLEAR FORM 
    CALL g_afc.clear()      
    MESSAGE ""
    
    DISPLAY '' TO FORMONLY.cnt
    CALL t600_cs()                      
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_afb.* TO NULL
        CALL g_afc.clear()
        RETURN
    END IF
    OPEN t600_cs                
    
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_afb.* TO NULL
        CALL g_afc.clear()
    ELSE
        OPEN t600_count
        FETCH t600_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
                                  
        CALL t600_fetch('F')              
    END IF
END FUNCTION
 
FUNCTION t600_fetch(p_flafb)
    DEFINE
        p_flafb         LIKE type_file.chr1           
    CASE p_flafb
        WHEN 'N' FETCH NEXT     t600_cs INTO g_afb.afb00,g_afb.afb01,g_afb.afb02,g_afb.afb03,g_afb.afb04,g_afb.afb041,g_afb.afb042
        WHEN 'P' FETCH PREVIOUS t600_cs INTO g_afb.afb00,g_afb.afb01,g_afb.afb02,g_afb.afb03,g_afb.afb04,g_afb.afb041,g_afb.afb042
        WHEN 'F' FETCH FIRST    t600_cs INTO g_afb.afb00,g_afb.afb01,g_afb.afb02,g_afb.afb03,g_afb.afb04,g_afb.afb041,g_afb.afb042
        WHEN 'L' FETCH LAST     t600_cs INTO g_afb.afb00,g_afb.afb01,g_afb.afb02,g_afb.afb03,g_afb.afb04,g_afb.afb041,g_afb.afb042
        WHEN '/'
            IF (NOT g_no_ask) THEN                   
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
            FETCH ABSOLUTE g_jump t600_cs INTO g_afb.afb00,g_afb.afb01,g_afb.afb02,g_afb.afb03,g_afb.afb04,g_afb.afb041,g_afb.afb042
            LET g_no_ask = FALSE        
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_afb.afb01,SQLCA.sqlcode,0)
        INITIALIZE g_afb.* TO NULL  
        RETURN
    ELSE
      CASE p_flafb
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx                 
    END IF
 
    SELECT * INTO g_afb.* FROM afb_file    
       WHERE afb00 = g_afb.afb00 AND afb01 = g_afb.afb01 AND afb02 = g_afb.afb02 AND afb03 = g_afb.afb03
        AND afb04 = g_afb.afb04 AND afb041 = g_afb.afb041 AND afb042 = g_afb.afb042
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","afb_file","","",SQLCA.sqlcode,"","",0)  
    ELSE
        LET g_data_owner=g_afb.afbuser           
        LET g_data_group=g_afb.afbgrup
        CALL t600_show()                   
    END IF
END FUNCTION
 
FUNCTION t600_afb041(p_cmd)         
DEFINE    l_gemacti  LIKE gem_file.gemacti, 
          l_gem01    LIKE gem_file.gem01,         #No.FUN-850027
          l_gem02    LIKE gem_file.gem02,    
          p_cmd      LIKE type_file.chr1,
          l_cnt      LIKE type_file.num5          #MOD-950286 add
          
  LET g_errno = ' '
  IF g_aaz.aaz90 = 'Y' THEN
     #此成本中心是否存在
     LET l_cnt=0
     SELECT COUNT(*) INTO l_cnt FROM gem_file WHERE gem10=g_afb.afb041
     SELECT gem02,gemacti INTO l_gem02,l_gemacti  FROM gem_file     
      WHERE gem01 = g_afb.afb041
     CASE                          
        WHEN l_cnt=0             LET g_errno='mfg1318' 
                                 LET l_gem02=NULL 
        WHEN l_gemacti='N'       LET g_errno='9028'     
        OTHERWISE                LET g_errno=SQLCA.sqlcode USING '------'
     END CASE   
  ELSE
     SELECT gem02,gemacti INTO l_gem02,l_gemacti  FROM gem_file     
           WHERE gem01 = g_afb.afb041
     CASE                          
           WHEN SQLCA.sqlcode=100   LET g_errno='agl-003' 
                                    LET l_gem02=NULL 
           WHEN l_gemacti='N'       LET g_errno='9028'     
           OTHERWISE   
              LET g_errno=SQLCA.sqlcode USING '------' 
     END CASE   
  END IF                                              #No.FUN-850027
  
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_gem02 TO FORMONLY.gem02
  END IF
END FUNCTION
 
FUNCTION t600_afb01(p_cmd)         
DEFINE    l_azfacti  LIKE azf_file.azfacti
DEFINE    l_azf03    LIKE azf_file.azf03  
DEFINE    l_azf07    LIKE azf_file.azf07
DEFINE    p_cmd      LIKE type_file.chr1           
DEFINE    l_azf09    LIKE azf_file.azf09         #No.FUN-930106          
DEFINE    l_azf14    LIKE azf_file.azf14         #No.TQC-B50094

   LET g_errno = ' '
#  SELECT azf03,azf07,azfacti,azf09 INTO l_azf03,l_azf07,l_azfacti,l_azf09  FROM azf_file     #No.FUN-930106
   SELECT azf03,azf14,azfacti,azf09 INTO l_azf03,l_azf14,l_azfacti,l_azf09  FROM azf_file     #No.FUN-930106  #No.TQC-B50094 azf07 -->azf14
         WHERE azf01 = g_afb.afb01 AND azf02 = '2'
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='agl-005' 
                                 LET l_azf03=NULL 
                                 LET l_azf07=NULL   #MOD-840181
        WHEN l_azfacti='N'       LET g_errno='9028'     
        WHEN l_azf09 !='7'       LET g_errno='aoo-406' #No.FUN-950077
        OTHERWISE   
           LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_azf03 TO FORMONLY.azf03
      IF p_cmd='a' THEN                         #MOD-840676
#      LET g_afb.afb02 = l_azf07                #MOD-840181 
       LET g_afb.afb02 = l_azf14                #MOD-840181  #No.TQC-B50094 azf07 -->azf14
       DISPLAY BY NAME g_afb.afb02              #MOD-840181 
      END IF                                    #MOD-840676
  END IF
 
END FUNCTION
 
#No.FUN-A60059  --Begin
FUNCTION t600_afb02(p_cmd,p_bookno,p_aag01)         
   DEFINE p_cmd      LIKE type_file.chr1            
   DEFINE p_bookno   LIKE aag_file.aag00
   DEFINE p_aag01    LIKE aag_file.aag02
   DEFINE l_aagacti  LIKE aag_file.aagacti
   DEFINE l_aag02    LIKE aag_file.aag02    
   DEFINE l_aag21    LIKE aag_file.aag21
   DEFINE l_aag03    LIKE aag_file.aag03
   DEFINE l_aag07    LIKE aag_file.aag07
          
   LET g_errno = ' '
   SELECT aag02,aagacti,aag21,aag03,aag07 
     INTO l_aag02,l_aagacti,l_aag21,l_aag03,l_aag07
     FROM aag_file     
    WHERE aag00 = p_bookno AND aag01 = p_aag01
   CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='agl-001' 
                                 LET l_aag02=NULL 
        WHEN l_aagacti='N'       LET g_errno='9028'     
        WHEN l_aag03 <> '2'      LET g_errno='agl-201'  
        WHEN l_aag07 = '1'       LET g_errno='agl-238'  
        WHEN l_aag21 <> 'Y'      LET g_errno='agl-924'  
        OTHERWISE                LET g_errno=SQLCA.sqlcode USING '------' 
   END CASE   
   
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_aag02 TO FORMONLY.aag02
   END IF
 
END FUNCTION
#No.FUN-A60059  --End  
 
FUNCTION t600_afb042(p_cmd)         
DEFINE    l_pjaacti  LIKE pja_file.pjaacti
DEFINE    l_pja02    LIKE pja_file.pja02   
DEFINE    p_cmd      LIKE type_file.chr1           
DEFINE    l_pjaclose LIKE pja_file.pjaclose     #No.FUN-960038
          
   LET g_errno = ' '
   SELECT pja02,pjaacti,pjaclose INTO l_pja02,l_pjaacti,l_pjaclose  FROM pja_file #No.FUN-960038 add pjaclose    
         WHERE pja01 = g_afb.afb042
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='agl-007' 
                                 LET l_pja02=NULL 
        WHEN l_pjaacti='N'       LET g_errno='9028'     
        WHEN l_pjaclose='Y'      LET g_errno='abg-503'            #No.FUN-960038
        OTHERWISE   
           LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_pja02 TO FORMONLY.pja02
  END IF
 
END FUNCTION
 
FUNCTION t600_period(p_cmd1,p_cmd2)
   DEFINE l_flag   LIKE type_file.chr1
   DEFINE l_afb07  LIKE afb_file.afb07
   DEFINE l_amt    LIKE afc_file.afc08
   DEFINE l_tmp LIKE afb_file.afb10
   DEFINE l_n,l_i,i   LIKE type_file.num5
   DEFINE p_cmd1,p_cmd2 LIKE type_file.chr1
   DEFINE l_fac1,l_fac2,l_fac3,l_tot LIKE type_file.num5
   DEFINE l_arr ARRAY[13] OF DECIMAL(20,6) 
   DEFINE l_remaind  LIKE afb_file.afb10  #MOD-840181
   DEFINE l_sum      LIKE afb_file.afb10  #MOD-840181   
 
   SELECT azm02 INTO g_azm.azm02 FROM azm_file WHERE azm01=g_afb.afb03 
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_afb.afb00
   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_aaa03 
 
   LET l_sum = 0 #MOD-840181
   IF g_afb.afb06 = '1' THEN
       LET l_tot  = g_aaz.aaz61+g_aaz.aaz62+g_aaz.aaz63
       LET l_fac1 = g_aaz.aaz61
       LET l_fac2 = g_aaz.aaz62
       LET l_fac3 = g_aaz.aaz63
    ELSE
       IF g_azm.azm02 = '1' THEN
          LET l_tot = 3
          LET l_fac1 = 1  LET l_fac2 = 1  LET l_fac3 = 1
       ELSE
          LET l_tot = 4
          LET l_fac1 = 1  LET l_fac2 = 1  LET l_fac3 = 1
       END IF
    END IF
   CASE p_cmd2 
     WHEN '0' 
        LET l_i = 1
        LET g_afb.afb11 = g_afb.afb10/4
        LET g_afb.afb12 = g_afb.afb10/4
        LET g_afb.afb13 = g_afb.afb10/4
        LET g_afb.afb14 = g_afb.afb10/4
        LET l_arr[1] = g_afb.afb11*l_fac1/l_tot                                                                                     
        LET l_arr[2] = g_afb.afb11*l_fac2/l_tot                                                                                     
        LET l_arr[3] = g_afb.afb11*l_fac3/l_tot
        LET l_arr[4] = g_afb.afb12*l_fac1/l_tot                                                                                     
        LET l_arr[5] = g_afb.afb12*l_fac2/l_tot                                                                                     
        LET l_arr[6] = g_afb.afb12*l_fac3/l_tot
        LET l_arr[7] = g_afb.afb13*l_fac1/l_tot                                                                                     
        LET l_arr[8] = g_afb.afb13*l_fac2/l_tot                                                                                     
        LET l_arr[9] = g_afb.afb13*l_fac3/l_tot
        IF g_azm.azm02='1' THEN                                                                                                     
           LET l_n=12                                                                                                               
           LET l_arr[10] = g_afb.afb14*l_fac1/l_tot                                                                                 
           LET l_arr[11] = g_afb.afb14*l_fac2/l_tot       
           LET l_arr[12] = g_afb.afb14*l_fac3/l_tot                                                                                 
        ELSE                                                                                                                        
           LET l_n=13                                                                                                               
           LET l_arr[10] = g_afb.afb14*l_fac1/l_tot                                                                                 
           LET l_arr[11] = g_afb.afb14*l_fac2/l_tot                                                                                 
           LET l_arr[12] = g_afb.afb14*l_fac3/l_tot     
           LET l_arr[13] = g_afb.afb14-(l_arr[10]+l_arr[11]+l_arr[12])                                                              
        END IF
     WHEN '1'
        LET l_i=1
        LET l_n=3
        LET l_arr[1] = g_afb.afb11*l_fac1/l_tot 
        LET l_arr[2] = g_afb.afb11*l_fac2/l_tot
        LET l_arr[3] = g_afb.afb11*l_fac3/l_tot 
     WHEN '2'
        LET l_i=4
        LET l_n=6
        LET l_arr[4] = g_afb.afb12*l_fac1/l_tot                                                                                     
        LET l_arr[5] = g_afb.afb12*l_fac2/l_tot           
        LET l_arr[6] = g_afb.afb12*l_fac3/l_tot
     WHEN '3'
        LET l_i=7
        LET l_n=9
        LET l_arr[7] = g_afb.afb13*l_fac1/l_tot                                                                                     
        LET l_arr[8] = g_afb.afb13*l_fac2/l_tot          
        LET l_arr[9] = g_afb.afb13*l_fac3/l_tot
     WHEN '4'
        LET l_i=10
        IF g_azm.azm02='1' THEN
           LET l_n=12
           LET l_arr[10] = g_afb.afb14*l_fac1/l_tot                                                                                     
           LET l_arr[11] = g_afb.afb14*l_fac2/l_tot                 
           LET l_arr[12] = g_afb.afb14*l_fac3/l_tot
        ELSE 
           LET l_n=13
           LET l_arr[10] = g_afb.afb14*l_fac1/l_tot                                                                                 
           LET l_arr[11] = g_afb.afb14*l_fac2/l_tot                                                                                 
           LET l_arr[12] = g_afb.afb14*l_fac3/l_tot
           LET l_arr[13] = g_afb.afb14-(l_arr[10]+l_arr[11]+l_arr[12])
        END IF
     END CASE
   IF p_cmd2 NOT MATCHES '0' THEN
      LET g_afb.afb10=g_afb.afb11 + g_afb.afb12 + g_afb.afb13 + g_afb.afb14
   END IF
   LET g_afb.afb10 = cl_numfor(g_afb.afb10,20,t_azi04)
   LET g_afb.afb11 = cl_numfor(g_afb.afb11,20,t_azi04)
   LET g_afb.afb12 = cl_numfor(g_afb.afb12,20,t_azi04)
   LET g_afb.afb13 = cl_numfor(g_afb.afb13,20,t_azi04)
   LET g_afb.afb14 = cl_numfor(g_afb.afb14,20,t_azi04)
   LET l_remaind = g_afb.afb10 - (g_afb.afb11 + g_afb.afb12 + g_afb.afb13 + g_afb.afb14)  #MOD-840181
   LET g_afb.afb14 = g_afb.afb14 + l_remaind
    FOR i=l_i TO l_n
       LET l_arr[i] = cl_numfor(l_arr[i],20,t_azi04)
       LET l_sum = l_sum + l_arr[i]
       CASE l_n 
         WHEN '3'
           LET l_arr[3] = l_arr[3] + g_afb.afb11 - l_sum
         WHEN '6'
           LET l_arr[6] = l_arr[6] + g_afb.afb12 - l_sum
         WHEN '9'
           LET l_arr[9] = l_arr[9] + g_afb.afb13 - l_sum
         WHEN '12' 
           IF p_cmd2 NOT MATCHES '0' THEN
              LET l_arr[12] = l_arr[12] + g_afb.afb14 - l_sum
           ELSE
              LET l_arr[12] = l_arr[12] + g_afb.afb10 - l_sum
           END IF   
         WHEN '13'
           IF p_cmd2 NOT MATCHES '0' THEN                                                                                           
              LET l_arr[13] = l_arr[13] + g_afb.afb14 - l_sum                                                                       
           ELSE                                                                                                                     
              LET l_arr[13] = l_arr[13] + g_afb.afb10 - l_sum                                                                       
           END IF
       END CASE
    END FOR
   DISPLAY BY NAME g_afb.afb10,g_afb.afb11,g_afb.afb12,g_afb.afb13,g_afb.afb14   
   BEGIN WORK   
 IF p_cmd1 = 'a' THEN
   IF g_aza.aza08='N' THEN
      IF g_afb.afb04 IS NULL THEN
         LET g_afb.afb04 =' '
      END IF
      IF g_afb.afb042 IS NULL THEN
         LET g_afb.afb042 =' '
      END IF
   END IF

   DECLARE ic CURSOR FOR 
      INSERT INTO afc_file (afc00,afc01,afc02,afc03,afc04,afc041,afc042,afc05,afc06,afc07,afc08,afc09)                   #MOD-AA0135 add afc08,afc09
        values(g_afb.afb00,g_afb.afb01,g_afb.afb02,g_afb.afb03,g_afb.afb04,g_afb.afb041,g_afb.afb042,i,l_tmp,l_amt,0,0)  #MOD-AA0135 add 0
     OPEN ic
       FOR i=l_i TO l_n
         LET l_tmp = l_arr[i] 
         CALL s_getbug(g_afb.afb00,g_afb.afb01,g_afb.afb02,g_afb.afb03,i,g_afb.afb04,g_afb.afb15,g_afb.afb041,g_afb.afb042)     #FUN-810069
                     RETURNING l_flag,l_afb07,l_amt
         PUT ic
       END FOR
    FLUSH ic
    COMMIT WORK
    CLOSE ic
    FREE ic
  ELSE
      PREPARE iu FROM "UPDATE afc_file SET afc06 = ? WHERE afc00 = ? AND afc01 = ? AND afc02 = ?
                       AND afc03 = ? AND afc04 = ? AND afc041 = ? AND afc042 = ? AND afc05 = ?"
      FOR i=l_i TO l_n
        LET l_tmp = l_arr[i]
        EXECUTE iu USING l_tmp,g_afb.afb00,g_afb.afb01,g_afb.afb02,g_afb.afb03,g_afb.afb04,g_afb.afb041,g_afb.afb042,i  
        IF SQLCA.sqlcode THEN                                                                                                         
         CALL cl_err3("upd","afc_file",i,l_tmp,SQLCA.sqlcode,'','',1)
         ROLLBACK WORK
        END IF 
      END FOR
      COMMIT WORK
      FREE iu
   END IF
END FUNCTION
 
FUNCTION t600_show()
    LET g_afb_t.* = g_afb.*
    LET g_afb_o.*=g_afb.*
    DISPLAY BY NAME g_afb.afb00,g_afb.afb01,g_afb.afb02,g_afb.afb03, g_afb.afboriu,g_afb.afborig,
                    g_afb.afb04,g_afb.afb041,g_afb.afb042,g_afb.afb05,
                    g_afb.afb06,g_afb.afb07,g_afb.afb09,
                    g_afb.afb10,g_afb.afb11,g_afb.afb12,g_afb.afb13,g_afb.afb14,
                    g_afb.afb18,g_afb.afb19,g_afb.afbuser,g_afb.afbgrup,
                    g_afb.afbmodu,g_afb.afbdate,g_afb.afbacti
    CALL t600_afb041('d')
    CALL t600_afb01('d')
    CALL t600_afb02('d',g_afb.afb00,g_afb.afb02)  #No.TQC-A60059
    CALL t600_afb042('d')
    CALL t600_b_fill(g_wc2) 
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION t600_b_fill(p_wc2)              
DEFINE  p_wc2   STRING 
 
    LET g_sql =
        "SELECT afc05,afc06,afc08,afc09,afc07 FROM afc_file ",
        " WHERE afc00 = '",g_afb.afb00,"'"," AND afc01 = '",g_afb.afb01,"'",
        "   AND afc02 = '",g_afb.afb02,"'"," AND afc03 = ",g_afb.afb03,
        "   AND afc04 = '",g_afb.afb04,"'"," AND afc041 = '",g_afb.afb041,"'",
        "   AND afc042 = '",g_afb.afb042,"'" 
    IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED,"ORDER BY afc05"
    END IF
    PREPARE t600_pb FROM g_sql
    DECLARE afc_cs CURSOR FOR t600_pb
 
    CALL g_afc.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH afc_cs INTO g_afc[g_cnt].*  
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) 
        EXIT FOREACH
        END IF        
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_afc.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
        DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t600_a()
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10              
   DEFINE l_n         LIKE type_file.num5   
 
   MESSAGE ""
   CLEAR FORM
   CALL g_afc.clear()
   LET g_wc = '' 
   LET g_wc2= ''
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_afb.* TO NULL                  
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_afb.afbuser = g_user
      LET g_afb.afboriu = g_user #FUN-980030
      LET g_afb.afborig = g_grup #FUN-980030
      LET g_afb.afbgrup = g_grup
      LET g_afb.afbdate = g_today
      LET g_afb.afbacti = 'Y'               
      LET g_afb.afb00 = g_aza.aza81     
      LET g_afb.afb03 = YEAR(g_today)
      LET g_afb.afb09 = 'N'
      LET g_afb.afb18 = 'N'
      LET g_afb.afb05 = '3'   #TQC-840018
      LET g_afb.afb06 = '2'   #TQC-840018
      LET g_afb.afb07 = '1'   #TQC-840018
      LET g_afb.afb04 = ' '   #MOD-9C0038                                                                                                       
      LET g_afb.afb041 = ' '  #MOD-9C0038
      LET g_afb.afb042 = ' '  #MOD-9C0038
      LET g_afb.afb15 = '1'  #MOD-9C0057

 
      CALL t600_i("a")                          
 
      IF INT_FLAG THEN                          
         INITIALIZE g_afb.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_afb.afb00) OR  
         cl_null(g_afb.afb02) OR cl_null(g_afb.afb03) OR
         cl_null(g_afb.afb01) THEN       
         CONTINUE WHILE
      END IF

      BEGIN WORK             #TQC-960206 add

      IF g_aza.aza08='N' THEN
         LET g_afb.afb04 = ' '                                                                                                        
         LET g_afb.afb042 = ' '
      END IF
      INSERT INTO afb_file VALUES(g_afb.*)
      IF SQLCA.sqlcode THEN                     
         CALL cl_err3("ins","afb_file",g_afb.afb01,"",SQLCA.sqlcode,"","",1)  
         ROLLBACK WORK       #TQC-960206 add
         CONTINUE WHILE
      ELSE
         COMMIT WORK                                                   
         CALL cl_flow_notify(g_afb.afb01,'I')
      END IF
      
      SELECT sfb00,sfb01,sfb02,sfb03,sfb04,sfb041,sfb042
      INTO g_afb.afb00,g_afb.afb01,g_afb.afb02,g_afb.afb03,g_afb.afb04,g_afb.afb041,g_afb.afb042
      FROM afb_file
           WHERE afb00 = g_afb.afb00 AND afb01 = g_afb.afb01
             AND afb02 = g_afb.afb02 AND afb03 = g_afb.afb03
             AND afb04 = g_afb.afb04 AND afb041 = g_afb.afb041
             AND afb042 = g_afb.afb042 
      LET g_afb_t.* = g_afb.*
      LET g_afb_o.* = g_afb.*
      CALL g_afc.clear()
      
      CALL t600_b_fill("1=1")  
      CALL t600_b()                   
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t600_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          
   DEFINE   l_n       LIKE type_file.num10
   DEFINE   l_afb03   STRING
   DEFINE   l_pjb01   LIKE pjb_file.pjb01
   DEFINE   l_pjb09   LIKE pjb_file.pjb09   #No.FUN-850027 
   DEFINE   l_pjb11   LIKE pjb_file.pjb11   #No.FUN-850027
   DEFINE   l_aag05   LIKE aag_file.aag05   #No.TQC-B50068
 
   DISPLAY BY NAME
      g_afb.afb00,g_afb.afb03,g_afb.afb09,g_afb.afb18,g_afb.afb05,g_afb.afb06,g_afb.afb07,   #TQC-840018
      g_afb.afbuser,g_afb.afbgrup,g_afb.afbmodu,
      g_afb.afbdate,g_afb.afbacti
 
   LET g_afb_t.* = g_afb.* 
   CALL cl_set_head_visible("","YES")
   
   INPUT BY NAME g_afb.afboriu,g_afb.afborig,
      g_afb.afb00,g_afb.afb03,g_afb.afb01,g_afb.afb02,g_afb.afb041,g_afb.afb042,            #MOD-840181
      g_afb.afb04,g_afb.afb09,g_afb.afb18,g_afb.afb05,g_afb.afb06,g_afb.afb07,              #TQC-840018  
      g_afb.afb10,g_afb.afb11,g_afb.afb12,g_afb.afb13,g_afb.afb14
      WITHOUT DEFAULTS
 
      BEFORE INPUT     
          LET g_before_input_done = FALSE
          CALL t600_set_entry(p_cmd)
          CALL t600_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
      
      AFTER FIELD afb00
         IF NOT cl_null(g_afb.afb00) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_afb.afb00 != g_afb_t.afb00) THEN              
               SELECT COUNT(*) INTO l_n FROM aaa_file WHERE aaa01 = g_afb.afb00 AND aaaacti = 'Y'
               IF l_n<1 THEN
                  CALL cl_err('afb00:','agl-095',0)
                  LET g_afb.afb00 = g_afb_t.afb00
                  DISPLAY BY NAME g_afb.afb00
                  NEXT FIELD afb00
               END IF
               #No.TQC-A60059  --Begin
               IF NOT cl_null(g_afb.afb02) THEN
                  CALL t600_afb02(p_cmd,g_afb.afb00,g_afb.afb02)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('afb00:',g_errno,0)
                     LET g_afb.afb00 = g_afb_t.afb00
                     DISPLAY BY NAME g_afb.afb00
                     NEXT FIELD afb00
                  END IF
               END IF
               #No.TQC-A60059  --End  
               IF g_afb.afb00 != g_aza.aza81  THEN
                  CALL cl_set_comp_entry("afb07",FALSE) 
               ELSE
                  CALL cl_set_comp_entry("afb07",TRUE) 
               END IF
            END IF
         END IF
        
      AFTER FIELD afb04
         IF NOT cl_null(g_afb.afb04) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_afb.afb04 != g_afb_t.afb04) THEN      
               IF cl_null(g_afb.afb042) THEN
                  SELECT pjb01 INTO l_pjb01 FROM pjb_file WHERE pjb02 = g_afb.afb04 AND pjbacti = 'Y'
                  IF SQLCA.sqlcode THEN
                   CALL cl_err('afb04:','apj-051',0)
                   LET g_afb.afb04 = g_afb_t.afb04
                   NEXT FIELD afb04
                  ELSE
                    LET g_afb.afb042 = l_pjb01
                    CALL t600_afb042(p_cmd)
                  END IF  
                  DISPLAY BY NAME g_afb.afb042
               ELSE        
                  SELECT COUNT(*) INTO l_n FROM pjb_file WHERE pjb01 = g_afb.afb042 AND pjb02 = g_afb.afb04 AND pjbacti = 'Y'
                  IF l_n<1 THEN
                     CALL cl_err('afb04:','apj-051',0)
                     LET g_afb.afb04 = g_afb_t.afb04
                     DISPLAY BY NAME g_afb.afb04
                     NEXT FIELD afb04
                  ELSE
                     SELECT pjb09,pjb11 INTO l_pjb09,l_pjb11 
                      FROM pjb_file WHERE pjb01 = g_afb.afb042
                       AND pjb02 = g_afb.afb04
                       AND pjbacti = 'Y'            
                     IF l_pjb09 != 'Y' OR l_pjb11 != 'Y' THEN
                        CALL cl_err(g_afb.afb04,'apj-090',0)
                        LET g_afb.afb04 = g_afb_t.afb04
                        NEXT FIELD afb04
                     END IF
                  END IF
               END IF
            END IF
         ELSE
            LET g_afb.afb04 = ' '
         END IF
         
      AFTER FIELD afb041
         IF NOT cl_null(g_afb.afb041) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_afb.afb041 != g_afb_t.afb041) THEN              
               CALL t600_afb041('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('afb041:',g_errno,0)
                  LET g_afb.afb041 = g_afb_t.afb041
                  DISPLAY BY NAME g_afb.afb041
                  NEXT FIELD afb041
               END IF
               #TQC-A60061--Add--Begin 
               CALL t600_afb041_2()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('afb041:',g_errno,0)
                  LET g_afb.afb041 = g_afb_t.afb041
                  DISPLAY BY NAME g_afb.afb041
                  NEXT FIELD afb041
               END IF
               #TQC-A60061--Add--End               
            END IF
         ELSE
            LET g_afb.afb041 = ' '
            #No.TQC-B50068  --Begin
            IF NOT cl_null(g_afb.afb00) AND NOT cl_null(g_afb.afb02) THEN
               LET l_aag05 = ''
               SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag00=g_afb.afb00
                                                         AND aag01=g_afb.afb02
               IF l_aag05 = 'Y' THEN
                  CALL cl_err('afb041:','aws-604',0)
                  DISPLAY BY NAME g_afb.afb041
                  NEXT FIELD afb041
               END IF
            ELSE
               LET g_afb.afb041 = ' '
            END IF
            #No.TQC-B50068  --End
         END IF
              
      AFTER FIELD afb01
         IF NOT cl_null(g_afb.afb01) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_afb.afb01 != g_afb_t.afb01) THEN              
               CALL t600_afb01('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('afb01:',g_errno,0)
                  LET g_afb.afb01 = g_afb_t.afb01
                  DISPLAY BY NAME g_afb.afb01
                  NEXT FIELD afb01
               ELSE
                  CALL t600_afb02(p_cmd,g_afb.afb00,g_afb.afb02)  #No.TQC-A60059
               END IF
            END IF
         END IF
      AFTER FIELD afb02
         IF NOT cl_null(g_afb.afb02) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_afb.afb02 != g_afb_t.afb02) THEN              
               CALL t600_afb02(p_cmd,g_afb.afb00,g_afb.afb02)  #No.TQC-A60059
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('afb02:',g_errno,0)
                 #Mod No.FUN-B10048
                 #LET g_afb.afb02 = g_afb_t.afb02
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.construct = 'N'
                  LET g_qryparam.where = " aag03='2' AND aag07 IN ('2','3') AND aag21='Y' AND aag01 LIKE '",g_afb.afb02 CLIPPED,"%'"
                  LET g_qryparam.arg1 = g_afb.afb00
                  LET g_qryparam.default1 = g_afb.afb02
                  CALL cl_create_qry() RETURNING g_afb.afb02
                 #End Mod No.FUN-B10048
                  DISPLAY BY NAME g_afb.afb02
                  NEXT FIELD afb02
               END IF
               #No.TQC-B50068  --Begin
               IF NOT cl_null(g_afb.afb00) THEN
                  LET l_aag05 = ''
                  SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag00=g_afb.afb00
                                                            AND aag01=g_afb.afb02
                  IF l_aag05 <> 'Y' THEN
                     LET g_afb.afb041 = ' '
                     DISPLAY BY NAME g_afb.afb041
                     DISPLAY ' ' TO FORMONLY.gem02
                     CALL cl_set_comp_entry("afb041",FALSE)
                  ELSE 
                     CALL cl_set_comp_entry("afb041",TRUE)
                  END IF
               END IF
               #No.TQC-B50068  --End              #No.FUN-B10053
            END IF
         END IF
         
      AFTER FIELD afb042
         IF NOT cl_null(g_afb.afb042) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_afb.afb042 != g_afb_t.afb042) THEN              
               CALL t600_afb042('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('afb042:',g_errno,0)
                  LET g_afb.afb042 = g_afb_t.afb042
                  DISPLAY BY NAME g_afb.afb042
                  NEXT FIELD afb042
               END IF
            END IF
         ELSE 
          LET g_afb.afb042=' ' 
         END IF
         
      AFTER FIELD afb03
         IF NOT cl_null(g_afb.afb03) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_afb.afb03 != g_afb_t.afb03) THEN              
               LET l_afb03 = g_afb.afb03
               IF LENGTH(l_afb03)<>4 THEN
                  NEXT FIELD afb03
               END IF
            END IF
         END IF   
      ON CHANGE afb05
         CALL t600_set_entry(p_cmd)
 
      AFTER FIELD afb10,afb11,afb12,afb13,afb14                                       
          IF p_cmd='a' OR (p_cmd='u' AND (g_afb.afb10<>g_afb_t.afb10 OR 
             g_afb.afb11<>g_afb_t.afb11 OR g_afb.afb12<>g_afb_t.afb12 OR
             g_afb.afb13<>g_afb_t.afb13 OR g_afb.afb14<>g_afb_t.afb14)) THEN
             CASE
               WHEN INFIELD(afb10)
                 IF g_afb.afb10 <=0 THEN
                    CALL cl_err('','axr-029',0)
                    NEXT FIELD afb10
                 ELSE
                    CALL t600_period(p_cmd,'0')
                 END IF
               WHEN INFIELD(afb11)         
                 IF g_afb.afb11 <=0 THEN                                        
                    CALL cl_err('','axr-029',0)     
                    NEXT FIELD afb11                            
                 ELSE                                                                                          
                    CALL t600_period(p_cmd,'1')
                 END IF
               WHEN INFIELD(afb12)      
                 IF g_afb.afb12 <=0 THEN                                        
                    CALL cl_err('','axr-029',0)     
                    NEXT FIELD afb12                            
                 ELSE                                                                                              
                    CALL t600_period(p_cmd,'2')
                 END IF
               WHEN INFIELD(afb13)     
                 IF g_afb.afb13 <=0 THEN                                        
                    CALL cl_err('','axr-029',0)     
                    NEXT FIELD afb13                             
                 ELSE                                                                                              
                    CALL t600_period(p_cmd,'3')
                 END IF
               WHEN INFIELD(afb14)      
                 IF g_afb.afb14 <=0 THEN                                        
                    CALL cl_err('','axr-029',0)     
                    NEXT FIELD afb14                            
                 ELSE                                                                                             
                    CALL t600_period(p_cmd,'4')
                 END IF
               OTHERWISE EXIT CASE
             END CASE
         END IF   
      AFTER FIELD afb05,afb06,afb07,afb09,afb18 
         IF NOT cl_null(g_afb.afb09) OR NOT cl_null(g_afb.afb18) OR 
            NOT cl_null(g_afb.afb05) OR
            NOT cl_null(g_afb.afb06) OR NOT cl_null(g_afb.afb07) THEN
            CASE 
               WHEN INFIELD(afb09)
                    IF g_afb.afb09 NOT MATCHES '[YN]' THEN
                     NEXT FIELD afb09
                    END IF
               WHEN INFIELD(afb18)
                    IF g_afb.afb18 NOT MATCHES '[YN]' THEN
                     NEXT FIELD afb18
                    END IF
              WHEN INFIELD(afb05)
                    IF g_afb.afb05 NOT MATCHES '[123]' THEN
                     NEXT FIELD afb05
                    END IF
              WHEN INFIELD(afb07)
                    IF g_afb.afb07 NOT MATCHES '[123]' THEN
                     NEXT FIELD afb07
                    END IF
               OTHERWISE EXIT CASE
             END CASE
         END IF
     AFTER INPUT
        LET g_afb.afbuser = s_get_data_owner("afb_file") #FUN-C10039
        LET g_afb.afbgrup = s_get_data_group("afb_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            CASE 
                WHEN cl_null(g_afb.afb00) 
                     NEXT FIELD afb00
                     EXIT CASE
                WHEN cl_null(g_afb.afb02)                 
                     NEXT FIELD afb02
                     EXIT CASE
                WHEN cl_null(g_afb.afb03) 
                     NEXT FIELD afb03
                     EXIT CASE
                WHEN cl_null(g_afb.afb01) 
                     NEXT FIELD afb01
                     EXIT CASE
                OTHERWISE EXIT CASE
            END CASE
            IF p_cmd='a' THEN
            SELECT COUNT(*) INTO l_n FROM afb_file WHERE afb00 = g_afb.afb00 AND afb01 = g_afb.afb01
                                                    AND  afb02 = g_afb.afb02 AND afb03 = g_afb.afb03
                                                    AND  afb04 = g_afb.afb04 AND afb041 = g_afb.afb041
                                                    AND  afb042 = g_afb.afb042
              IF l_n > 0 THEN                  
                  CALL cl_err('',-239,1)
                  LET g_afb.* = g_afb_t.*
                  DISPLAY BY NAME g_afb.*
                  DISPLAY BY NAME g_afb.afb00,g_afb.afb01,g_afb.afb02,
                                  g_afb.afb03, g_afb.afboriu,g_afb.afborig,
                                  g_afb.afb04,g_afb.afb041,g_afb.afb042,g_afb.afb05,
                                  g_afb.afb06,g_afb.afb07,g_afb.afb09,
                                  g_afb.afb10,g_afb.afb11,g_afb.afb12,g_afb.afb13,g_afb.afb14,
                                  g_afb.afb18,g_afb.afb19,g_afb.afbuser,g_afb.afbgrup,
                                  g_afb.afbmodu,g_afb.afbdate,g_afb.afbacti    
                  NEXT FIELD afb00
               END IF   
            END IF        
            IF g_afb.afb05 <> g_afb_t.afb05 OR 
               (p_cmd = 'u' AND g_afb.afb06<> g_afb_t.afb06) THEN
              IF g_afb.afb05 = '2' THEN
                         CALL t600_period(p_cmd,'1')
                         CALL t600_period(p_cmd,'2')
                         CALL t600_period(p_cmd,'3')
                         CALL t600_period(p_cmd,'4')
              END IF
              IF g_afb.afb05 = '3' THEN
               CALL t600_period(p_cmd,'0')
              END IF
            END IF
            
      ON ACTION CONTROLO                        
         IF INFIELD(afb01) THEN
            LET g_afb.* = g_afb_t.*
            CALL t600_show()
            NEXT FIELD afb01
         END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(afb041)
                 CALL cl_init_qry_var()
                 IF g_aaz.aaz90 = 'Y' THEN
                    LET g_qryparam.form = "q_gem10"
                 ELSE
                    LET g_qryparam.form = "q_gem"
                 END IF
                 LET g_qryparam.default1 = g_afb.afb041
                 CALL cl_create_qry() RETURNING g_afb.afb041
                 DISPLAY g_afb.afb041 TO afb041
                 NEXT FIELD afb041
               WHEN INFIELD(afb01)
                 CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_azf01a"                #No.FUN-930106  #MOD-C30249  mark
                 LET g_qryparam.form = "q_azf4"                   #MOD-C30249 add
                 #LET g_qryparam.arg1 = '7'                       #No.FUN-950077  #MOD-C30249  mark
                 LET g_qryparam.default1 = g_afb.afb01
                 CALL cl_create_qry() RETURNING g_afb.afb01
                 DISPLAY g_afb.afb01 TO afb01
                 NEXT FIELD afb01
               WHEN INFIELD(afb02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = " aag03='2' AND aag07 IN ('2','3') AND aag21='Y'"  #No.TQC-A60059
                 LET g_qryparam.arg1 = g_afb.afb00
                 LET g_qryparam.default1 = g_afb.afb02
                 CALL cl_create_qry() RETURNING g_afb.afb02
                 DISPLAY g_afb.afb02 TO afb02
                 NEXT FIELD afb02
               WHEN INFIELD(afb042)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pja"
                 LET g_qryparam.default1 = g_afb.afb042
                 CALL cl_create_qry() RETURNING g_afb.afb042
                 DISPLAY g_afb.afb042 TO afb042
                 NEXT FIELD afb042
               WHEN INFIELD(afb04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pjb"
                 IF NOT cl_null(g_afb.afb042) THEN
                  LET g_qryparam.where = " pjb01 = '",g_afb.afb042,"'"
                 END IF
                 LET g_qryparam.default1 = g_afb.afb04
                 CALL cl_create_qry() RETURNING g_afb.afb04
                 DISPLAY g_afb.afb04 TO afb04
                 NEXT FIELD afb04
 
           OTHERWISE
              EXIT CASE
        END CASE
 
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
 
END FUNCTION
 
FUNCTION t600_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("afb00,afb01,afb02,afb03,afb04,afb041,afb042",TRUE)
     END IF
     IF p_cmd MATCHES '[au]' THEN
       CASE g_afb.afb05                                                                                                           
           WHEN '1'                                                                                                                 
               CALL cl_set_comp_entry("afb11,afb12,afb13,afb14",FALSE)                                                              
               CALL cl_set_comp_entry("afb10",FALSE)                                                                                
           WHEN '2'                                                                                                                 
               CALL cl_set_comp_entry("afb10",FALSE)                                                                                
               CALL cl_set_comp_entry("afb11,afb12,afb13,afb14",TRUE)
               IF p_cmd = 'a' THEN
                LET g_afb.afb11 = 0
                LET g_afb.afb12 = 0
                LET g_afb.afb13 = 0
                LET g_afb.afb14 = 0
               ELSE
                LET g_afb.afb11 = g_afb_t.afb11
                LET g_afb.afb12 = g_afb_t.afb12
                LET g_afb.afb13 = g_afb_t.afb13
                LET g_afb.afb14 = g_afb_t.afb14
               END IF                          
               DISPLAY BY NAME g_afb.afb11,g_afb.afb12,g_afb.afb13,g_afb.afb14
           WHEN '3'                                                                                                                 
               CALL cl_set_comp_entry("afb11,afb12,afb13,afb14",FALSE)                                                              
               CALL cl_set_comp_entry("afb10",TRUE)                           
               IF p_cmd = 'a' THEN
                LET g_afb.afb10 = 0
               ELSE
                LET g_afb.afb10 = g_afb_t.afb10
               END IF              
               DISPLAY BY NAME g_afb.afb10
           OTHERWISE EXIT CASE                                                                                                      
       END CASE
    END IF
    IF p_cmd = 'c' THEN
       CALL cl_set_comp_entry("afb00,afb01,afb02,afb03,afb04,afb041,afb042",TRUE)   #FUN-840002
    END IF
END FUNCTION
 
FUNCTION t600_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1         
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("afb00,afb01,afb02,afb03,afb04,afb041,afb042",FALSE)
       
    END IF
 
END FUNCTION
 
FUNCTION t600_b()
        DEFINE l_ac_t          LIKE type_file.num5,
               l_n             LIKE type_file.num5,               
               l_lock_sw       LIKE type_file.chr1,
               p_cmd           LIKE type_file.chr1,
               l_allow_insert  LIKE type_file.num5,
               l_allow_delete  LIKE type_file.num5
        DEFINE l_flag   LIKE type_file.chr1
        DEFINE l_afb07  LIKE afb_file.afb07
        DEFINE l_amt    LIKE afc_file.afc08
        DEFINE l_max_rec LIKE type_file.num5    #No.MOD-AC0009 
                
        LET g_action_choice=''
        IF s_shut(0) THEN 
                RETURN
        END IF
        
        IF cl_null(g_afb.afb00) OR 
           cl_null(g_afb.afb02) OR cl_null(g_afb.afb03) OR
           cl_null(g_afb.afb01) THEN
                RETURN 
        END IF
        
        SELECT * INTO g_afb.* FROM afb_file
                WHERE afb00 = g_afb.afb00 AND afb01 = g_afb.afb01 AND afb02 = g_afb.afb02 AND afb03 = g_afb.afb03
      AND afb04 = g_afb.afb04 AND afb041 = g_afb.afb041 AND afb042 = g_afb.afb042
        
        IF g_afb.afbacti='N' THEN 
                CALL cl_err(g_afb.afb00,'mfg1000',0)
                RETURN 
        END IF
        
        IF g_afb.afb05 MATCHES '[23]' THEN 
           RETURN
        END IF        
        CALL cl_opmsg('b')
        SELECT azm02 INTO g_azm.azm02 FROM azm_file WHERE azm01=g_afb.afb03 
        LET g_forupd_sql="SELECT  afc05,afc06,afc08,afc09,afc07",
                        " FROM afc_file",
                        "  WHERE afc00 = ? AND afc01 = ? AND afc02 = ?",
                        " AND afc03 = ? AND afc04 = ? AND afc041 = ? ",
                        " AND afc042 = ? AND afc05 = ?",
                        " FOR UPDATE "
        LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
        DECLARE t600_bcl CURSOR FROM g_forupd_sql
        LET l_allow_insert=cl_detail_input_auth("insert")
        LET l_allow_delete=cl_detail_input_auth("delete")
#No.MOD-AC0009 --begin                                                          
        IF g_azm.azm02 = '1' THEN                                               
           LET l_max_rec =12                                                    
        END IF                                                                  
        IF g_azm.azm02 = '2' THEN                                               
           LET l_max_rec =13                                                    
        END IF                                                                  
#No.MOD-AC0009 --end 
        INPUT ARRAY g_afc WITHOUT DEFAULTS FROM s_afc.*
                ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=l_max_rec,UNBUFFERED,    #No.MOD-AC0009
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW= l_allow_insert)
        BEFORE INPUT
                IF g_rec_b !=0 THEN 
                        CALL fgl_set_arr_curr(l_ac)
                END IF
        BEFORE ROW
                LET p_cmd =''
                LET l_ac =ARR_CURR()
                LET l_lock_sw ='N'
                LET l_n =ARR_COUNT()
                
                BEGIN WORK 
                OPEN t600_cl USING g_afb.afb00,g_afb.afb01,g_afb.afb02,g_afb.afb03,
g_afb.afb04,g_afb.afb041,g_afb.afb042
                IF STATUS THEN
                        CALL cl_err("OPEN t600_cl:",STATUS,1)
                        CLOSE t600_cl
                        ROLLBACK WORK
                END IF
                
                FETCH t600_cl INTO g_afb.*
                IF SQLCA.sqlcode THEN
                        CALL cl_err(g_afb.afb00,SQLCA.sqlcode,0)
                        CLOSE t600_cl
                        ROLLBACK WORK 
                        RETURN
                END IF
                IF g_rec_b>=l_ac THEN 
                        LET p_cmd ='u'
                        LET g_afc_t.*=g_afc[l_ac].*
                        LET g_afc_o.*=g_afc[l_ac].*
                        OPEN t600_bcl USING g_afb.afb00,g_afb.afb01,g_afb.afb02,
                                            g_afb.afb03,g_afb.afb04,g_afb.afb041,
                                            g_afb.afb042,g_afc_t.afc05
                        IF STATUS THEN
                                CALL cl_err("OPEN t600_bcl:",STATUS,1)
                                LET l_lock_sw='Y'
                        ELSE
                                FETCH t600_bcl INTO g_afc[l_ac].*
                                IF SQLCA.sqlcode THEN
                                        CALL cl_err(g_afc_t.afc05,SQLCA.sqlcode,1)
                                        LET l_lock_sw="Y"
                                END IF                               
                       END IF
                       IF g_afb.afb19 = 'Y' THEN                                                                                                   
                          RETURN                                                                                                                   
                       END IF
                END IF
       BEFORE INSERT
                LET l_n=ARR_COUNT()
                LET p_cmd='a'
                INITIALIZE g_afc[l_ac].* TO NULL
                LET g_afc[l_ac].afc06=0                
                LET g_afc[l_ac].afc07=0           #MOD-AC0400             
                LET g_afc_t.*=g_afc[l_ac].*
                LET g_afc_o.*=g_afc[l_ac].*
                CALL cl_show_fld_cont()
                NEXT FIELD afc05
       AFTER INSERT
                IF INT_FLAG THEN
                        CALL cl_err('',9001,0)
                        LET INT_FLAG=0
                        CANCEL INSERT
                END IF
               #-MOD-AC0400-mark-
               #CALL s_getbug(g_afb.afb00,g_afb.afb01,g_afb.afb02,g_afb.afb03,g_afc[l_ac].afc05,g_afb.afb04,g_afb.afb15,g_afb.afb041,g_afb.afb042)     #FUN-810069
               #     RETURNING l_flag,l_afb07,l_amt
               #LET g_afc[l_ac].afc07 = l_amt
               #-MOD-AC0400-end-
                INSERT INTO afc_file(afc00,afc01,afc02,afc03,afc04,afc041,afc042,afc05,afc06,afc07,afc08,afc09)   #MOD-AA0135 add afc08,afc09
                VALUES(g_afb.afb00,g_afb.afb01,g_afb.afb02,g_afb.afb03,g_afb.afb04,
                       g_afb.afb041,g_afb.afb042,g_afc[l_ac].afc05,g_afc[l_ac].afc06,
                       g_afc[l_ac].afc07,0,0)        #MOD-AA0135 add 0
                IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","afc_file",g_afb.afb01,g_afc[l_ac].afc05,SQLCA.sqlcode,"","",1)
                        CANCEL INSERT
                ELSE
                        MESSAGE 'INSERT Ok'
                        COMMIT WORK
                        LET g_rec_b=g_rec_b+1
                        DISPLAY g_rec_b To FORMONLY.cn2
                        CALL t600_sum()
                END IF
                
      BEFORE FIELD afc05
        IF cl_null(g_afc[l_ac].afc05) OR g_afc[l_ac].afc05=0 THEN 
            SELECT MAX(afc05)+1 INTO g_afc[l_ac].afc05 FROM afc_file
                WHERE afc00 = g_afb.afb00 AND afc01 = g_afb.afb01
                 AND  afc02 = g_afb.afb02 AND afc03 = g_afb.afb03
                 AND  afc04 = g_afb.afb04 AND afc041 = g_afb.afb041
                 AND  afc042 = g_afb.afb042
                IF cl_null(g_afc[l_ac].afc05) THEN
                        LET g_afc[l_ac].afc05 = 1 
                END IF
         END IF
      AFTER FIELD afc05
        IF NOT cl_null(g_afc[l_ac].afc05) THEN 
                IF g_afc[l_ac].afc05!=g_afc_t.afc05
                        OR cl_null(g_afc_t.afc05) THEN
                        SELECT COUNT(*) INTO l_n FROM afc_file
                        WHERE afc00 = g_afb.afb00 AND afc01 = g_afb.afb01
                         AND  afc02 = g_afb.afb02 AND afc03 = g_afb.afb03
                         AND  afc04 = g_afb.afb04 AND afc041 = g_afb.afb041
                         AND  afc042 = g_afb.afb042 AND afc05 = g_afc[l_ac].afc05
                       IF l_n>0 THEN
                           CALL cl_err('',-239,0)
                           LET g_afc[l_ac].afc05=g_afc_t.afc05
                           NEXT FIELD afc05
                       ELSE
                           IF g_afc[l_ac].afc05>=1 THEN
                              IF g_azm.azm02 = '1' THEN
                                 IF g_afc[l_ac].afc05>12 THEN
                                    CALL cl_err('','mfg9287',0)
                                    NEXT FIELD afc05
                                 END IF
                              END IF
                              IF g_azm.azm02 = '2' THEN                         
                                 IF g_afc[l_ac].afc05>13 THEN       
                                    CALL cl_err('','mfg9288',0)            
                                    NEXT FIELD afc05                            
                                 END IF                                         
                              END IF    
                           ELSE 
                              NEXT FIELD afc05
                           END IF
                       END IF
                 END IF
         END IF
         
      AFTER FIELD afc06
        #IF g_afc[l_ac].afc06 <= 0 THEN    #MOD-B30193 mark
        IF g_afc[l_ac].afc06 < 0 THEN      #MOD-B30193 add
                CALL cl_err('','axr-029',0)
		NEXT FIELD afc06
        END IF
       BEFORE DELETE                      
           DISPLAY "BEFORE DELETE"
           IF g_afc_t.afc05 > 0 AND g_afc_t.afc05 <=13 AND g_afc_t.afc05 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM afc_file
               WHERE afc00 = g_afb.afb00 AND afc01 = g_afb.afb01
                AND  afc02 = g_afb.afb02 AND afc03 = g_afb.afb03
                AND  afc04 = g_afb.afb04 AND afc041 = g_afb.afb041
                AND  afc042 = g_afb.afb042 AND afc05 = g_afc_t.afc05
                 
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","afc_file",g_afb.afb00,g_afc_t.afc05,SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK
           CALL t600_sum()   #MOD-9C0034
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_afc[l_ac].* = g_afc_t.*
              CLOSE t600_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_afc[l_ac].afc05,-263,1)
              LET g_afc[l_ac].* = g_afc_t.*
           ELSE
             #-MOD-AC0400-mark-
             #CALL s_getbug(g_afb.afb00,g_afb.afb01,g_afb.afb02,g_afb.afb03,g_afc[l_ac].afc05,g_afb.afb04,g_afb.afb15,g_afb.afb041,g_afb.afb042)     #FUN-810069
             #       RETURNING l_flag,l_afb07,l_amt
             #LET g_afc[l_ac].afc07 = l_amt
             #-MOD-AC0400-end-
              UPDATE afc_file SET afc05 = g_afc[l_ac].afc05,
                                  afc06 = g_afc[l_ac].afc06, 
                                  afc07 = g_afc[l_ac].afc07                                
                 WHERE afc00 = g_afb.afb00 AND afc01 = g_afb.afb01
                  AND  afc02 = g_afb.afb02 AND afc03 = g_afb.afb03
                  AND  afc04 = g_afb.afb04 AND afc041 = g_afb.afb041
                  AND  afc042 = g_afb.afb042 AND afc05 = g_afc_t.afc05
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","afc_file",g_afb.afb01,g_afc_t.afc05,SQLCA.sqlcode,"","",1) 
                 LET g_afc[l_ac].* = g_afc_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
                 CALL t600_sum()
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30032
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_afc[l_ac].* = g_afc_t.*
              #FUN-D30032--add--str--
              ELSE
                 CALL g_afc.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30032--add--end--
              END IF
              CLOSE t600_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac  #FUN-D30032
           CLOSE t600_bcl
           COMMIT WORK
          
      #MOD-B30193--add--str--
      ON ACTION accept 
          IF g_azm.azm02 = '1' AND g_rec_b < 12 THEN
             IF NOT cl_confirm('agl1003') THEN
                NEXT FIELD afc06
             ELSE
                EXIT INPUT
             END IF
          END IF
          IF g_azm.azm02 = '2' AND g_rec_b < 13 THEN
             IF NOT cl_confirm('agl1004') THEN
                NEXT FIELD afc06
             ELSE
                EXIT INPUT
             END IF
          END IF
       #MOD-B30193--add--end--
       #MOD-C30638--add--str
       IF INFIELD(afc05) THEN
          IF NOT cl_null(g_afc[l_ac].afc05) THEN
             IF g_afc[l_ac].afc05!=g_afc_t.afc05 OR cl_null(g_afc_t.afc05) THEN
                SELECT COUNT(*) INTO l_n FROM afc_file
                 WHERE afc00 = g_afb.afb00 AND afc01 = g_afb.afb01
                   AND afc02 = g_afb.afb02 AND afc03 = g_afb.afb03
                   AND afc04 = g_afb.afb04 AND afc041 = g_afb.afb041
                   AND afc042 = g_afb.afb042 AND afc05 = g_afc[l_ac].afc05
                IF l_n>0 THEN
                   CALL cl_err('',-239,0)
                   LET g_afc[l_ac].afc05=g_afc_t.afc05
                   NEXT FIELD afc05
                ELSE
                   IF g_afc[l_ac].afc05>=1 THEN
                      IF g_azm.azm02 = '1' THEN
                         IF g_afc[l_ac].afc05>12 THEN
                            CALL cl_err('','mfg9287',0)
                            NEXT FIELD afc05
                         END IF
                      END IF
                      IF g_azm.azm02 = '2' THEN
                         IF g_afc[l_ac].afc05>13 THEN
                            CALL cl_err('','mfg9288',0)
                            NEXT FIELD afc05
                         END IF
                      END IF
                   ELSE
                      NEXT FIELD afc05
                   END IF
                END IF
             END IF
          END IF
       END IF
       IF INFIELD(afc06) THEN
          IF g_afc[l_ac].afc06 < 0 THEN
             CALL cl_err('','axr-029',0)
             NEXT FIELD afc06
          END IF
       END IF
       IF l_lock_sw = 'Y' THEN
          CALL cl_err(g_afc[l_ac].afc05,-263,1)
          LET g_afc[l_ac].* = g_afc_t.*
       ELSE
          UPDATE afc_file SET afc05 = g_afc[l_ac].afc05,
                              afc06 = g_afc[l_ac].afc06,
                              afc07 = g_afc[l_ac].afc07
           WHERE afc00 = g_afb.afb00 AND afc01 = g_afb.afb01
             AND  afc02 = g_afb.afb02 AND afc03 = g_afb.afb03
             AND  afc04 = g_afb.afb04 AND afc041 = g_afb.afb041
             AND  afc042 = g_afb.afb042 AND afc05 = g_afc_t.afc05
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             CALL cl_err3("upd","afc_file",g_afb.afb01,g_afc_t.afc05,SQLCA.sqlcode,"","",1)
             LET g_afc[l_ac].* = g_afc_t.*
          ELSE
             MESSAGE 'UPDATE O.K'
             COMMIT WORK
             CALL t600_sum()
          END IF
       END IF
       EXIT INPUT
       #MOD-C30638--add--end           
              
      ON ACTION CONTROLO                        
           IF INFIELD(afc02) AND l_ac > 1 THEN
              LET g_afc[l_ac].* = g_afc[l_ac-1].*
              LET g_afc[l_ac].afc05 = g_rec_b + 1
              NEXT FIELD afc05
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
 
        ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
    END INPUT
 
    LET g_afb.afbmodu = g_user
    LET g_afb.afbdate = g_today
    UPDATE afb_file SET afbmodu = g_afb.afbmodu,afbdate = g_afb.afbdate
       WHERE afb01 = g_afb.afb01 AND afb02 = g_afb.afb02 AND afb03 = g_afb.afb03
         AND afb04 = g_afb.afb04 AND afb041 = g_afb.afb041 AND afb042 = g_afb.afb042
    DISPLAY BY NAME g_afb.afbmodu,g_afb.afbdate
  
    CLOSE t600_bcl
    COMMIT WORK
#   CALL t600_delall() #CHI-C30002 mark
    CALL t600_delHeader()     #CHI-C30002 add
    CALL t600_show()
END FUNCTION                 
 
#CHI-C30002 -------- add -------- begin
FUNCTION t600_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM afb_file WHERE afb00 = g_afb.afb00 AND afb01 = g_afb.afb01
                                AND  afb02 = g_afb.afb02 AND afb03 = g_afb.afb03
                                AND  afb04 = g_afb.afb04 AND afb041 = g_afb.afb041
                                AND  afb042 = g_afb.afb042
         INITIALIZE g_afb.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t600_delall()
#
#  SELECT COUNT(*) INTO g_cnt FROM afc_file
#   WHERE afc00 = g_afb.afb00 AND afc01 = g_afb.afb01
#    AND  afc02 = g_afb.afb02 AND afc03 = g_afb.afb03
#    AND  afc04 = g_afb.afb04 AND afc041 = g_afb.afb041
#    AND  afc042 = g_afb.afb042 
#
#  IF g_cnt = 0 THEN                  
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM afb_file WHERE afb00 = g_afb.afb00 AND afb01 = g_afb.afb01
#                           AND  afb02 = g_afb.afb02 AND afb03 = g_afb.afb03
#                           AND  afb04 = g_afb.afb04 AND afb041 = g_afb.afb041
#                           AND  afb042 = g_afb.afb042 
#  END IF
#
#END FUNCTION                  
#CHI-C30002 -------- mark -------- end
                                
FUNCTION t600_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
    IF cl_null(g_afb.afb00)OR 
      cl_null(g_afb.afb02) OR cl_null(g_afb.afb03) OR
      cl_null(g_afb.afb01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_afb.* FROM afb_file
    WHERE afb00 = g_afb.afb00 AND afb01 = g_afb.afb01
     AND  afb02 = g_afb.afb02 AND afb03 = g_afb.afb03
     AND  afb04 = g_afb.afb04 AND afb041 = g_afb.afb041
     AND  afb042 = g_afb.afb042
 
   IF g_afb.afbacti ='N' THEN    
      CALL cl_err(g_afb.afb00,'mfg1000',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   BEGIN WORK
 
   OPEN t600_cl USING g_afb.afb00,g_afb.afb01,g_afb.afb02,g_afb.afb03,
g_afb.afb04,g_afb.afb041,g_afb.afb042
   IF STATUS THEN
      CALL cl_err("OPEN t600_cl:", STATUS, 1)
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t600_cl INTO g_afb.*                      
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_afb.afb00,SQLCA.sqlcode,0)    
       CLOSE t600_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t600_show()
 
   WHILE TRUE
      LET g_afb_o.* = g_afb.*
      LET g_afb_t.* = g_afb.*
      LET g_afb.afbmodu=g_user
      LET g_afb.afbdate=g_today
 
      CALL t600_i("u")                            
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_afb.*=g_afb_t.*
         CALL t600_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_afb.afb00 != g_afb_t.afb00 OR g_afb.afb01 != g_afb_t.afb01 OR
         g_afb.afb02 != g_afb_t.afb02 OR g_afb.afb03 != g_afb_t.afb03 OR
         g_afb.afb04 != g_afb_t.afb04 OR g_afb.afb041 != g_afb_t.afb041 OR
         g_afb.afb042 != g_afb_t.afb042 THEN            
         UPDATE afc_file SET afc00 = g_afb.afb00,
                             afc01 = g_afb.afb01,
                             afc02 = g_afb.afb02,
                             afc03 = g_afb.afb03,
                             afc04 = g_afb.afb04,
                             afc041 = g_afb.afb041,
                             afc042 = g_afb.afb042
          WHERE afc00 = g_afb_t.afb00 AND afc01 = g_afb_t.afb01 AND afc02 = g_afb_t.afb02
           AND  afc03 = g_afb_t.afb03 AND afc04 = g_afb_t.afb04 AND afc041 = g_afb_t.afb041
           AND  afc042 = g_afb_t.afb042
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","afc_file",g_afb_t.afb00,"",SQLCA.sqlcode,"","",1)  
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE afb_file SET afb_file.* = g_afb.*
       WHERE afb00 = g_afb_t.afb00 AND afb01 = g_afb_t.afb01 AND afb02 = g_afb_t.afb02 AND afb03 = g_afb_t.afb03
       AND afb04 = g_afb_t.afb04 AND afb041 = g_afb_t.afb041 AND afb042 = g_afb_t.afb042
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","afb_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t600_cl
   COMMIT WORK
   CALL t600_show()
   CALL cl_flow_notify(g_afb.afb00,'U')
   
   CALL t600_b()
   CALL t600_b_fill("1=1")
   CALL t600_bp_refresh()
 
END FUNCTION          
                
FUNCTION t600_r()
   DEFINE l_cnt LIKE type_file.num5       #MOD-8C0168 add
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_afb.afb00) OR  
      cl_null(g_afb.afb02) OR cl_null(g_afb.afb03) OR
      cl_null(g_afb.afb01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_afb.* FROM afb_file
    WHERE afb00=g_afb.afb00 AND afb01=g_afb.afb01 AND afb02=g_afb.afb02
     AND  afb03=g_afb.afb03 AND afb04=g_afb.afb04 AND afb041=g_afb.afb041
     AND  afb042=g_afb.afb042
   IF g_afb.afbacti ='N' THEN    
      CALL cl_err(g_afb.afb01,'mfg1000',0)
      RETURN
   END IF
    SELECT COUNT(*) INTO l_cnt FROM afc_file
     WHERE afc00 = g_afb.afb00
       AND afc01 = g_afb.afb01
       AND afc02 = g_afb.afb02
       AND afc03 = g_afb.afb03
       AND afc04 = g_afb.afb04
       AND afc041= g_afb.afb041
       AND afc042= g_afb.afb042
       AND afc05 BETWEEN 1 AND 13
       AND afc07 != 0        #已消耗預算
    IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
    IF l_cnt > 0 THEN
       CALL cl_err('','agl024',0)   #已有已消耗預算資料,不可刪除!
       RETURN
    END IF
 
   BEGIN WORK
 
   OPEN t600_cl USING g_afb.afb00,g_afb.afb01,g_afb.afb02,g_afb.afb03,
g_afb.afb04,g_afb.afb041,g_afb.afb042
   IF STATUS THEN
      CALL cl_err("OPEN t600_cl:", STATUS, 1)
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t600_cl INTO g_afb.*               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_afb.afb00,SQLCA.sqlcode,0)         
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t600_show()
 
   IF cl_delh(0,0) THEN                   
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "afb00"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_afb.afb00      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                                            #No.FUN-9B0098 10/02/24
      DELETE FROM afb_file WHERE afb00=g_afb.afb00 AND afb01=g_afb.afb01 AND afb02=g_afb.afb02
                            AND  afb03=g_afb.afb03 AND afb04=g_afb.afb04 AND afb041=g_afb.afb041
                            AND  afb042=g_afb.afb042
      DELETE FROM afc_file WHERE afc00=g_afb.afb00 AND afc01=g_afb.afb01 AND afc02=g_afb.afb02
                            AND  afc03=g_afb.afb03 AND afc04=g_afb.afb04 AND afc041=g_afb.afb041
                            AND  afc042=g_afb.afb042
      CLEAR FORM
      CALL g_afc.clear()
      OPEN t600_count
      #FUN-B50062-add-start--
      IF STATUS THEN
         CLOSE t600_cs
         CLOSE t600_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      FETCH t600_count INTO g_row_count
      #FUN-B50062-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t600_cs
         CLOSE t600_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t600_cs
      IF g_row_count >0 THEN
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t600_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE      
            CALL t600_fetch('/')
         END IF
      END IF
   END IF
 
   CLOSE t600_cl
   COMMIT WORK
   CALL cl_flow_notify(g_afb.afb00,'D')
END FUNCTION
 
#No.TQC-A60059  --Begin
FUNCTION t600_copy()
   DEFINE l_new00     LIKE afb_file.afb00
   DEFINE l_new01     LIKE afb_file.afb01
   DEFINE l_new02     LIKE afb_file.afb02
   DEFINE l_new03     LIKE afb_file.afb03
   DEFINE l_new04     LIKE afb_file.afb04
   DEFINE l_new041    LIKE afb_file.afb041
   DEFINE l_new042    LIKE afb_file.afb042
   DEFINE l_old00     LIKE afb_file.afb00
   DEFINE l_old01     LIKE afb_file.afb01
   DEFINE l_old02     LIKE afb_file.afb02
   DEFINE l_old03     LIKE afb_file.afb03
   DEFINE l_old04     LIKE afb_file.afb04
   DEFINE l_old041    LIKE afb_file.afb041
   DEFINE l_old042    LIKE afb_file.afb042
   DEFINE l_n         LIKE type_file.num5
   DEFINE l_afb03     LIKE afb_file.afb03
   DEFINE l_pjb09     LIKE pjb_file.pjb09
   DEFINE l_pjb11     LIKE pjb_file.pjb11
   DEFINE l_cnt       LIKE type_file.num5
   DEFINE l_aag05     LIKE aag_file.aag05  #No.TQC-B50068

   IF s_shut(0) THEN RETURN END IF
 
   LET g_afb_t.* = g_afb.*
   IF cl_null(g_afb.afb00) OR 
      cl_null(g_afb.afb02) OR cl_null(g_afb.afb03) OR
      cl_null(g_afb.afb01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   CALL t600_show()
   LET g_before_input_done = FALSE
   CALL t600_set_entry('c') 
   
   CALL cl_set_head_visible("","YES")      
 
   LET l_new04 = ' '
   LET l_new041 = ' '
   LET l_new042 = ' '

   INPUT l_new00,l_new03,l_new01,l_new02,l_new041,l_new042,l_new04 
         WITHOUT DEFAULTS FROM 
         afb00,afb03,afb01,afb02,afb041,afb042,afb04
     BEFORE INPUT
         LET l_new00 = g_aza.aza81
         LET l_new03 = YEAR(g_today)
#No.MOD-AC0009 --begin                                                          
         IF g_aza.aza08='N' THEN                                                
            LET l_new042 = ' '                                                  
            LET l_new04 = ' '                                                  
         END IF                                                                 
#No.MOD-AC0009 --end 
         DISPLAY l_new00,l_new03 TO afb00,afb03

     AFTER FIELD afb00
         IF NOT cl_null(l_new00) THEN                 
            SELECT COUNT(*) INTO l_n FROM aaa_file WHERE aaa01 = l_new00 AND aaaacti = 'Y'
            IF l_n < 1 THEN
               CALL cl_err('afb00:','agl-095',0)
               LET l_new00 = g_afb_t.afb00
               DISPLAY l_new00 TO afb00
               NEXT FIELD afb00
            END IF
            IF NOT cl_null(l_new02) THEN
               CALL t600_afb02('a',l_new00,l_new02)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('afb00:',g_errno,0)
                  LET l_new00 = g_afb_t.afb00
                  DISPLAY l_new00 TO afb00
                  NEXT FIELD afb00
               END IF
            END IF
         END IF
        
      AFTER FIELD afb04
         IF NOT cl_null(l_new04) THEN             
            IF cl_null(l_new042) THEN
               CALL cl_err('afb042:','agl-956',0)
               NEXT FIELD afb042
            ELSE                         
               SELECT COUNT(*) INTO l_n FROM pjb_file WHERE pjb01 = l_new042 AND pjbacti = 'Y'
               IF l_n<1 THEN
                  CALL cl_err('afb042:','asf-984',0)
                  LET l_new042 = g_afb_t.afb042
                  DISPLAY l_new042 TO afb042
                  NEXT FIELD afb042
               END IF
            END IF
            SELECT COUNT(*) INTO l_n FROM pjb_file WHERE pjb01 = l_new042 AND pjb02 = l_new04 AND pjbacti = 'Y'
            IF l_n<1 THEN
               CALL cl_err('afb04:','apj-051',0)
               LET l_new04 = g_afb_t.afb04
               DISPLAY l_new04 TO afb04
               NEXT FIELD afb04
            ELSE
               SELECT pjb09,pjb11 INTO l_pjb09,l_pjb11 
                FROM pjb_file WHERE pjb01 = l_new042
                 AND pjb02 = l_new04
                 AND pjbacti = 'Y'            
               IF l_pjb09 != 'Y' OR l_pjb11 != 'Y' THEN
                  CALL cl_err(l_new04,'apj-090',0)
                  LET l_new04 = g_afb_t.afb04
                  NEXT FIELD afb04
               END IF
            END IF
         ELSE
           LET l_new04 = ' ' 
         END IF

      AFTER FIELD afb041
         IF NOT cl_null(l_new041) THEN
               LET g_afb.afb041 = l_new041
               CALL t600_afb041('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('afb041:',g_errno,0)
                  LET l_new041 = g_afb_t.afb041
                  DISPLAY l_new041 TO afb041
                  NEXT FIELD afb041
               END IF
               #TQC-A60061--Add--Begin 
               SELECT COUNT(*) INTO l_cnt FROM aab_file 
                WHERE aab00=l_new00
                  AND aab01=l_new02
                  AND aab02=l_new041
               IF l_cnt > 0 AND g_aaz.aaz72 = '1' THEN    
                  CALL cl_err('afb041:','agl-207',0)
                  LET l_new041 = g_afb_t.afb041
                  DISPLAY l_new041 TO afb041
                  NEXT FIELD afb041
               END IF
               #TQC-A60061--Add--End               
               LET g_afb.afb041 = g_afb_t.afb041
               #No.TQC-B50068  --Begin
               IF NOT cl_null(g_afb.afb00) AND NOT cl_null(g_afb.afb02) THEN
                  LET l_aag05 = ''
                  SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag00=g_afb.afb00
                                                            AND aag01=g_afb.afb02
                  IF l_aag05 <> 'Y' THEN
                     CALL cl_err('afb041:','aws-604',0)
                     NEXT FIELD afb041
                  END IF
               END IF
               #No.TQC-B50068  --End
         ELSE
          LET l_new041 = ' '    
         END IF  

      AFTER FIELD afb01
         IF NOT cl_null(l_new01) THEN
               LET g_afb.afb01 = l_new01
               CALL t600_afb01('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('afb01:',g_errno,0)
                  LET l_new01 = g_afb_t.afb01
                  DISPLAY l_new01 TO afb01
                  NEXT FIELD afb01
               END IF
               LET g_afb.afb01 = g_afb_t.afb01
         ELSE
           LET l_new01 = ' '
         END IF 
                  
      AFTER FIELD afb02
         IF NOT cl_null(l_new02) THEN
               CALL t600_afb02('a',l_new00,l_new02)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('afb02:',g_errno,0)
                 #Mod No.FUN-B10048
                 #LET l_new02 = g_afb_t.afb02
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.construct = 'N'
                  LET g_qryparam.arg1 = l_new00
                  LET g_qryparam.where = " aag03='2' AND aag07 IN ('2','3') AND aag21='Y' AND aag01 LIKE '",l_new02 CLIPPED,"%'"
                  CALL cl_create_qry() RETURNING l_new02
                 #End Mod No.FUN-B10048
                  DISPLAY l_new02 TO afb02
                  NEXT FIELD afb02
               END IF
         END IF
         
      AFTER FIELD afb042
         IF NOT cl_null(l_new042) THEN
               LET g_afb.afb042 = l_new042
               CALL t600_afb042('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('afb042:',g_errno,0)
                  LET l_new042 = g_afb_t.afb042
                  DISPLAY l_new042 TO afb042
                  NEXT FIELD afb042
               END IF
               LET g_afb.afb042 = g_afb_t.afb042
         ELSE   #MOD-9C0038
            LET l_new042 = ' '   #MOD-9C0038
         END IF
         
      AFTER FIELD afb03
         IF NOT cl_null(l_new03) THEN
               LET l_afb03 = l_new03 
               IF LENGTH(l_afb03)<>4 THEN
                  NEXT FIELD afb03
               END IF
         END IF              
       AFTER INPUT 
         IF INT_FLAG THEN
               LET g_afb.* = g_afb_t.*
               EXIT INPUT
         END IF
           CASE 
              WHEN cl_null(l_new00)
                   NEXT FIELD afb00
              WHEN cl_null(l_new02)
                   NEXT FIELD afb02
              WHEN cl_null(l_new03)
                   NEXT FIELD afb03
              WHEN cl_null(l_new01)
                   NEXT FIELD afb01
              OTHERWISE EXIT CASE
           END CASE
           
           SELECT COUNT(*) INTO l_n FROM afb_file WHERE afb00 = l_new00 AND afb01 = l_new01
                                                    AND afb02 = l_new02 AND afb03 = l_new03
                                                    AND afb04 = l_new04 AND afb041 = l_new041 AND afb042 = l_new042
           IF l_n > 0 THEN
              CALL cl_err('',-239,0)
              NEXT FIELD afb00
           END IF                                               
       ON ACTION controlp
          CASE
              WHEN INFIELD(afb041)
                 CALL cl_init_qry_var()
                 IF g_aaz.aaz90 = 'Y' THEN
                    LET g_qryparam.form = "q_gem10"
                 ELSE
                    LET g_qryparam.form = "q_gem"
                 END IF
                 CALL cl_create_qry() RETURNING l_new041
                 DISPLAY l_new041 TO afb041
                 NEXT FIELD afb041
               WHEN INFIELD(afb01)
                 CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_azf01a"                #No.FUN-930106   #MOD-C30249  mark
                 LET g_qryparam.form = "q_azf4"                   #MOD-C30249 add
                 #LET g_qryparam.arg1 = '7'                       #No.FUN-950077   #MOD-C30249  mark
                 CALL cl_create_qry() RETURNING l_new01
                 DISPLAY l_new01 TO afb01
                 NEXT FIELD afb01
               WHEN INFIELD(afb02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = l_new00
                 LET g_qryparam.where = " aag03='2' AND aag07 IN ('2','3') AND aag21='Y'"  #No.TQC-A60059
                 CALL cl_create_qry() RETURNING l_new02
                 DISPLAY l_new02 TO afb02
                 NEXT FIELD afb02
               WHEN INFIELD(afb042)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pja"
                 CALL cl_create_qry() RETURNING l_new042
                 DISPLAY l_new042 TO afb042
                 NEXT FIELD afb042
               WHEN INFIELD(afb04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pjb"
                 CALL cl_create_qry() RETURNING l_new04
                 DISPLAY l_new04 TO afb04
                 NEXT FIELD afb04
 
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
 
   BEGIN WORK
   
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_afb.afb00,g_afb.afb01,g_afb.afb02,g_afb.afb03,
                      g_afb.afb04,g_afb.afb041,g_afb.afb042  
      ROLLBACK WORK  
      RETURN
   END IF
 
   DROP TABLE y
 
   LET g_afb.* = g_afb_t.*
   SELECT * FROM afb_file         
       WHERE afb00=g_afb.afb00 AND afb01=g_afb.afb01 AND afb02=g_afb.afb02
        AND  afb03=g_afb.afb03 AND afb04=g_afb.afb04 AND afb041=g_afb.afb041
        AND  afb042=g_afb.afb042
       INTO TEMP y
 
   UPDATE y
       SET afb00=l_new00,
           afb01=l_new01,
           afb02=l_new02,
           afb03=l_new03,
           afb04=l_new04,
           afb041=l_new041,
           afb042=l_new042,
           afbuser=g_user,   
           afbgrup=g_grup,   
           afbmodu=NULL,     
           afbdate=g_today,  
           afbacti='Y'      
 
   INSERT INTO afb_file SELECT * FROM y
   
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","afb_file","","",SQLCA.sqlcode,"","",1) 
      ROLLBACK WORK
      RETURN
   ELSE 
      DROP TABLE x
 
      SELECT * FROM afc_file         
          WHERE afc00=g_afb.afb00 AND afc01=g_afb.afb01 AND afc02=g_afb.afb02
           AND  afc03=g_afb.afb03 AND afc04=g_afb.afb04 AND afc041=g_afb.afb041
           AND  afc042=g_afb.afb042
          INTO TEMP x
      IF SQLCA.sqlcode THEN
          CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1) 
          RETURN
      END IF
 
      UPDATE x SET afc00 = l_new00,
                   afc01 = l_new01,
                   afc02 = l_new02,
                   afc03 = l_new03,
                   afc04 = l_new04,
                   afc041 = l_new041,
                   afc042 = l_new042,
                   afc07 = 0,   #MOD-9C0038
                   afc08 = 0,   #MOD-9C0038
                   afc09 = 0    #MOD-9C0038
      INSERT INTO afc_file
        SELECT * FROM x
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","afc_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-B80057---調整至回滾事務前---
         ROLLBACK WORK 
         RETURN
      ELSE
        COMMIT WORK 
      END IF
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_new00,') O.K'
 
   LET l_old00 = g_afb.afb00
   LET l_old01 = g_afb.afb01
   LET l_old02 = g_afb.afb02
   LET l_old03 = g_afb.afb03
   LET l_old04 = g_afb.afb04
   LET l_old041 = g_afb.afb041
   LET l_old042 = g_afb.afb042
   SELECT * INTO g_afb.* FROM afb_file 
    WHERE afb00 = l_new00 AND afb01 = l_new01
      AND afb02 = l_new02 AND afb03 = l_new03
      AND afb04 = l_new04 AND afb041 = l_new041 AND afb042 = l_new042
   CALL t600_u()
   CALL t600_b()
   #FUN-C30027---begin
   #SELECT * INTO g_afb.* FROM afb_file 
   # WHERE afb00 = l_old00 AND afb01 = l_old01
   #   AND afb02 = l_old02 AND afb03 = l_old03
   #   AND afb04 = l_old04 AND afb041 = l_old041 AND afb042 = l_old042
   #CALL t600_show()
   #FUN-C30027---end
END FUNCTION
#No.TQC-A60059  --End  
 
FUNCTION t600_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_afb.afb01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t600_cl USING g_afb.afb00,g_afb.afb01,g_afb.afb02,g_afb.afb03,
g_afb.afb04,g_afb.afb041,g_afb.afb042
   IF STATUS THEN
      CALL cl_err("OPEN t600_cl:", STATUS, 1)
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t600_cl INTO g_afb.*               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_afb.afb01,SQLCA.sqlcode,0)          
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t600_show()
 
   IF cl_exp(0,0,g_afb.afbacti) THEN                   
      LET g_chr=g_afb.afbacti
      IF g_afb.afbacti='Y' THEN
         LET g_afb.afbacti='N'
      ELSE
         LET g_afb.afbacti='Y'
      END IF
 
      UPDATE afb_file SET afbacti=g_afb.afbacti,
                          afbmodu=g_user,
                          afbdate=g_today
       WHERE afb00=g_afb.afb00 AND afb01=g_afb.afb01 AND afb02=g_afb.afb02
        AND  afb03=g_afb.afb03 AND afb04=g_afb.afb04 AND afb041=g_afb.afb041
        AND  afb042=g_afb.afb042
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","afb_file",g_afb.afb00,"",SQLCA.sqlcode,"","",1)  
         LET g_afb.afbacti=g_chr
      END IF
   END IF
 
   CLOSE t600_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_afb.afb00,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT afbacti,afbmodu,afbdate
     INTO g_afb.afbacti,g_afb.afbmodu,g_afb.afbdate FROM afb_file
    WHERE afb00=g_afb.afb00 AND afb01=g_afb.afb01 AND afb02=g_afb.afb02
     AND  afb03=g_afb.afb03 AND afb04=g_afb.afb04 AND afb041=g_afb.afb041
     AND  afb042=g_afb.afb042
   DISPLAY BY NAME g_afb.afbacti,g_afb.afbmodu,g_afb.afbdate
 
END FUNCTION
 
FUNCTION t600_bp_refresh()
  DISPLAY ARRAY g_afc TO s_afc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
  CALL t600_show()
END FUNCTION
 
#str CHI-9C0004 mark
#FUNCTION t600_g()
#    DEFINE l_sql1  STRING,       
#           l_sql2  STRING,      
#           l_name,l_name2  LIKE type_file.chr20,    
#           l_cmd   LIKE type_file.chr1000  
#    DEFINE l_exist LIKE type_file.chr1    
#    DEFINE sr1     RECORD LIKE afb_file.* 
#    DEFINE tp      RECORD LIKE afb_file.*
#    DEFINE tp2     RECORD LIKE afc_file.*
#    DEFINE sr2     RECORD LIKE afc_file.*
#    DEFINE a       LIKE type_file.chr1    
#    DEFINE l_afc   RECORD LIKE afc_file.*
#    DEFINE l_afb   RECORD LIKE afb_file.*,
#           l_tmp   RECORD
#                    p001    LIKE type_file.chr1,  
#                    p002    LIKE afb_file.afb02    
#                   END RECORD,
#           l_cnt   LIKE type_file.num5  
# 
#    OPEN WINDOW t600_wg WITH FORM "agl/42f/aglt600_1"
#          ATTRIBUTE (STYLE = g_win_style CLIPPED)
# 
#    CALL cl_ui_init()
# 
#    INPUT bookno,yyy FROM bookno,yyy
# 
#         ON ACTION controlp
#            IF INFIELD(bookno) THEN
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_aaa"
#               LET g_qryparam.default1 = bookno
#               CALL cl_create_qry() RETURNING bookno
#               DISPLAY BY NAME bookno
#            END IF
#    END INPUT
# 
#    IF INT_FLAG THEN LET INT_FLAG = 0
#       CLOSE WINDOW t600_wg
#       CALL cl_err('','9001',1)
#       RETURN
#    END IF
#    CALL cl_wait()
#    CREATE TEMP TABLE tmp_file(
#           p01 LIKE type_file.chr1, 
#           p02 LIKE type_file.chr50);
#    CREATE UNIQUE INDEX tmp_01 ON tmp_file (p02)
# 
#    DECLARE judge_cur CURSOR FOR
#       SELECT * FROM afb_file
#        WHERE afb00=bookno  AND afb03 =yyy
#          AND afbacti = 'Y' 
# 
#    IF SQLCA.SQLCODE THEN 
#       CALL cl_err('judge',status,1)  
#    END IF
#    FOREACH judge_cur INTO tp.*,tp2.*
#      IF SQLCA.SQLCODE THEN 
#         CALL cl_err('temp_foreach',status,1)
#      END IF
#      SELECT count(*) INTO l_cnt FROM afb_file WHERE afb00 = bookno 
#         AND afb02 =tp.afb02 AND afb03 = yyy 
#         AND afb04 =' ' AND afb041=' ' AND afb042 =' '
#         AND afbacti = 'Y' 
#      IF l_cnt = 0 OR cl_null(l_cnt) THEN 
#         LET l_exist ='N' 
#      ELSE
#         LET l_exist ='Y'
#      END IF
#      INSERT INTO tmp_file VALUES(l_exist,tp.afb02)
#    END FOREACH
#    DECLARE tmp_cur CURSOR WITH HOLD FOR
#    SELECT * FROM tmp_file
# 
#    LET l_name = 'aglt6001.out'
#    LET l_name2 = 'aglt6002.out'
#    
#    IF os.Path.chrwx(l_name CLIPPED,511) THEN END IF    #No.FUN-9C0009
#    IF os.Path.chrwx(l_name2 CLIPPED,511) THEN END IF   #No.FUN-9C0009
#
#    IF STATUS THEN
#       CALL cl_err('chmod 777',STATUS,1)
#    END IF
#    
#    START REPORT t600_rep1 TO l_name
#    IF SQLCA.SQLCODE THEN CALL cl_err('tmp_cur',STATUS,1) END IF
#    START REPORT t600_rep2 TO l_name2
#    IF SQLCA.SQLCODE THEN CALL cl_err('tmp_cur',status,1) END IF
# 
#    LET g_success = 'Y'      
#    BEGIN WORK                
#    FOREACH tmp_cur INTO l_tmp.*
#       IF SQLCA.SQLCODE THEN
#           LET g_success = 'N'    
#          CALL cl_err('tmp_cur',status,1) EXIT FOREACH
#       END IF
# 
#       #----------afb_file部份----------
#        DECLARE t600_cur1 CURSOR FOR
#          SELECT *  FROM afb_file
#          WHERE afb00 = bookno   #帳別  
#            AND afb03 = yyy      #年度
#            AND afb02 = l_tmp.p002
#           ORDER BY afb00,afb03,afb01,afb02 
#        IF SQLCA.sqlcode THEN CALL cl_err('t600_cur1',STATUS,1) END IF
#        FOREACH t600_cur1 INTO l_afb.*
#          IF SQLCA.sqlcode THEN
#              LET g_success = 'N'            
#             CALL cl_err('t600_for1',STATUS,1)
#             EXIT FOREACH
#          END IF
#          OUTPUT TO REPORT t600_rep1(l_afb.*,l_tmp.p001)
#        END FOREACH
#       #----------afc_file部份----------#
#        DECLARE t600_cur2 CURSOR FOR
#         SELECT * FROM afc_file
#         WHERE afc00 = bookno AND afc02 =l_tmp.p002 
#           AND afc03 = yyy 
#          ORDER BY afc00,afc03,afc01,afc02,afc05  
#        IF SQLCA.sqlcode THEN
#          LET g_success = 'N'                   
#          CALL cl_err('t600_cur2',STATUS,1)   
#        END IF
#        FOREACH t600_cur2 INTO l_afc.*
#          IF SQLCA.sqlcode THEN
#             CALL cl_err('t600_for2',STATUS,1)
#              LET g_success = 'N'              
#             EXIT FOREACH
#          END IF
#          OUTPUT TO REPORT t600_rep2(l_afc.*,l_tmp.p001)
#        END FOREACH
#    END FOREACH
#    FINISH REPORT t600_rep1
#    FINISH REPORT t600_rep2
# 
#    IF g_success = 'Y' THEN
#       COMMIT WORK 
#    ELSE
#       ROLLBACK WORK
#    END IF
# 
#    IF os.Path.chrwx(l_name CLIPPED,511) THEN END IF    #No.FUN-9C0009
#    IF os.Path.chrwx(l_name2 CLIPPED,511) THEN END IF   #No.FUN-9C0009
# 
#    IF STATUS THEN
#       CALL cl_err('chmod 777',STATUS,1)
#    END IF
# 
#    IF INT_FLAG THEN LET INT_FLAG = 0
#       CLOSE WINDOW t600_wg
#       RETURN
#    END IF
#    CLOSE t600_cur1
#    CLOSE t600_cur2
#    CLOSE WINDOW t600_wg
#    CALL cl_end(0,0)
#    DROP TABLE tmp_file
# 
#END FUNCTION
#end CHI-9C0004 mark
 
#str CHI-9C0004 mod
FUNCTION t600_g()
   DEFINE l_sql1  STRING       
   DEFINE l_sql2  STRING      
   DEFINE l_name  LIKE type_file.chr20    
   DEFINE l_name2 LIKE type_file.chr20    
   DEFINE l_cmd   LIKE type_file.chr1000  
   DEFINE l_exist LIKE type_file.chr1    
   DEFINE sr1     RECORD LIKE afb_file.* 
   DEFINE tp      RECORD LIKE afb_file.*
   DEFINE tp2     RECORD LIKE afc_file.*
   DEFINE sr2     RECORD LIKE afc_file.*
   DEFINE a       LIKE type_file.chr1    
   DEFINE l_afc   RECORD LIKE afc_file.*
   DEFINE l_afb   RECORD LIKE afb_file.*
   DEFINE l_cnt   LIKE type_file.num5  
   DEFINE l_tmp   RECORD
                   p001    LIKE type_file.chr1,  
                   p002    LIKE afb_file.afb02    
                  END RECORD

   MESSAGE ""
   OPEN WINDOW t600_wg WITH FORM "agl/42f/aglt600_1"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   INPUT bookno,yyy FROM bookno,yyy
      ON ACTION controlp
         IF INFIELD(bookno) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_aaa"
            LET g_qryparam.default1 = bookno
            CALL cl_create_qry() RETURNING bookno
            DISPLAY BY NAME bookno
         END IF
   END INPUT

   IF INT_FLAG THEN LET INT_FLAG = 0
      CLOSE WINDOW t600_wg
      CALL cl_err('','9001',1)
      RETURN
   END IF

   CALL cl_wait()

   CREATE TEMP TABLE tmp_file(
      afb01  LIKE afb_file.afb01,  
      afb02  LIKE afb_file.afb02);

   LET g_success = 'Y'      
   BEGIN WORK                

   CALL s_showmsg_init()
   #檢核是否有已消耗預算資料,若沒有則刪除舊預算資料
   DECLARE judge_cur0 CURSOR FOR
      SELECT * FROM afb_file
       WHERE afb00=bookno  AND afb03 =yyy
         AND afb04=' ' AND afb041=' ' AND afb042=' '
         AND afbacti = 'Y' 
       ORDER BY afb01,afb02
   IF SQLCA.SQLCODE THEN 
      CALL cl_err('judge_cur0',status,1)  
   END IF
   FOREACH judge_cur0 INTO l_afb.*
      #先檢核要產生的科目預算是否已有消耗預算,若有則不允許重新產生
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM afc_file
       WHERE afc00 = l_afb.afb00
         AND afc01 = l_afb.afb01
         AND afc02 = l_afb.afb02
         AND afc03 = l_afb.afb03
         AND afc04 = l_afb.afb04
         AND afc041= l_afb.afb041
         AND afc042= l_afb.afb042
         AND afc05 BETWEEN 1 AND 13
         AND afc07 != 0        #已消耗預算
      IF cl_null(l_cnt) THEN LET l_cnt=0 END IF
      IF l_cnt > 0 THEN
         LET g_msg = l_afb.afb01,",",l_afb.afb02
         CALL s_errmsg('afb01,afb02',g_msg,'','agl024',1)  #已有已消耗預算資料,不可刪除!
         INSERT INTO tmp_file VALUES(l_afb.afb01,l_afb.afb02)
         CONTINUE FOREACH
      END IF

      #刪除舊預算資料
      DELETE FROM afb_file
       WHERE afb00=bookno  AND afb03 =yyy
         AND afb01 = l_afb.afb01
         AND afb02 = l_afb.afb02
         AND afb04=' ' AND afb041=' ' AND afb042=' '
      DELETE FROM afc_file
       WHERE afc00=bookno  AND afc03 =yyy
         AND afc01 = l_afb.afb01
         AND afc02 = l_afb.afb02
         AND afc04=' ' AND afc041=' ' AND afc042=' '
   END FOREACH

   LET l_name = 'aglt6001.out'
   LET l_name2= 'aglt6002.out'

   IF os.Path.chrwx(l_name CLIPPED,511) THEN END IF    #No.FUN-9C0009
   IF os.Path.chrwx(l_name2 CLIPPED,511) THEN END IF   #No.FUN-9C0009

   IF STATUS THEN
      CALL cl_err('chmod 777',STATUS,1)
   END IF

   LET g_page_line=66  #MOD-C30254
   START REPORT t600_rep1 TO l_name
   IF SQLCA.SQLCODE THEN CALL cl_err('tmp_cur',STATUS,1) END IF
   START REPORT t600_rep2 TO l_name2
   IF SQLCA.SQLCODE THEN CALL cl_err('tmp_cur',status,1) END IF

   DECLARE judge_cur CURSOR FOR
      SELECT * FROM afb_file
       WHERE afb00=bookno  AND afb03 =yyy
         AND afbacti = 'Y' 
       ORDER BY afb01,afb02
   IF SQLCA.SQLCODE THEN 
      CALL cl_err('judge',status,1)  
   END IF
   FOREACH judge_cur INTO l_afb.*
      IF SQLCA.SQLCODE THEN
         LET g_success = 'N'    
         CALL cl_err('judge_cur',status,1) EXIT FOREACH
      END IF
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM tmp_file
       WHERE afb01=afb01 AND afb02=l_afb.afb02
      IF cl_null(l_cnt) THEN LET l_cnt=0 END IF
      IF l_cnt > 0 THEN
         CONTINUE FOREACH
      END IF

      #寫入預算資料
      OUTPUT TO REPORT t600_rep1(l_afb.*)

      #----------afc_file部份----------#
      DECLARE t600_cur2 CURSOR FOR
         SELECT * FROM afc_file
         WHERE afc00 =l_afb.afb00 AND afc01 =l_afb.afb01
           AND afc02 =l_afb.afb02 AND afc03 =l_afb.afb03
           AND afc04 =l_afb.afb04 AND afc041=l_afb.afb041
           AND afc042=l_afb.afb042
         ORDER BY afc01,afc02,afc05  
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'                   
         CALL cl_err('t600_cur2',STATUS,1)   
      END IF
      FOREACH t600_cur2 INTO l_afc.*
         IF SQLCA.sqlcode THEN
            CALL cl_err('t600_for2',STATUS,1)
            LET g_success = 'N'              
            EXIT FOREACH
         END IF
         #寫入預算資料
         OUTPUT TO REPORT t600_rep2(l_afc.*)
      END FOREACH
   END FOREACH
   FINISH REPORT t600_rep1
   FINISH REPORT t600_rep2
   CALL s_showmsg()

   IF g_success = 'Y' THEN
      COMMIT WORK 
   ELSE
      ROLLBACK WORK
   END IF

   IF os.Path.chrwx(l_name CLIPPED,511) THEN END IF    #No.FUN-9C0009
   IF os.Path.chrwx(l_name2 CLIPPED,511) THEN END IF   #No.FUN-9C0009

   IF STATUS THEN
      CALL cl_err('chmod 777',STATUS,1)
   END IF

   IF INT_FLAG THEN LET INT_FLAG = 0
      CLOSE WINDOW t600_wg
      RETURN
   END IF
   CLOSE t600_cur2
   CLOSE WINDOW t600_wg
   CALL cl_end(0,0)
   DROP TABLE tmp_file
END FUNCTION
#end CHI-9C0004 mod

#REPORT t600_rep1(sr1,p_p001)  #CHI-9C0004 mark
REPORT t600_rep1(sr1)          #CHI-9C0004
  DEFINE sr1 RECORD LIKE afb_file.*
 #DEFINE p_flag,p_p001 LIKE type_file.chr1 #CHI-9C0004 mark    
  DEFINE p_flag     LIKE type_file.chr1    #CHI-9C0004 
  DEFINE m_afb10    LIKE  type_file.num20_6,  
         m_afb11    LIKE  type_file.num20_6, 
         m_afb12    LIKE  type_file.num20_6,
         m_afb13    LIKE  type_file.num20_6,
         m_afb14    LIKE  type_file.num20_6
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 
   ORDER EXTERNAL BY sr1.afb00,sr1.afb03,sr1.afb01,sr1.afb02,
                     sr1.afb04,sr1.afb041,sr1.afb042,sr1.afb05
 
  FORMAT
      AFTER GROUP OF sr1.afb02
         LET m_afb10=GROUP SUM(sr1.afb10)
         LET m_afb11=GROUP SUM(sr1.afb11)
         LET m_afb12=GROUP SUM(sr1.afb12)
         LET m_afb13=GROUP SUM(sr1.afb13)
         LET m_afb14=GROUP SUM(sr1.afb14)
      #str CHI-9C0004 mark
      #  IF p_p001 ='Y' THEN
      #    UPDATE afb_file SET  afb10 = m_afb10,
      #                         afb11 = m_afb11,
      #                         afb12 = m_afb12,
      #                         afb13 = m_afb13,
      #                         afb14 = m_afb14
      #            WHERE afb00 = sr1.afb00 AND afb01 = sr1.afb01
      #              AND afb03 = sr1.afb03 AND afb02 = sr1.afb02
      #              AND afb04 =' '  AND afb041 =' '
      #              AND afb042 =' '
      #    IF SQLCA.sqlcode THEN
      #       CALL cl_err3("upd","afb_file",sr1.afb01,sr1.afb02,SQLCA.sqlcode,"","upd afb :",1)
      #       LET g_success = 'N'
      #    END IF
      #  END IF
      # IF p_p001 ='N' THEN
      #end CHI-9C0004 mark
          INSERT INTO afb_file (afb00,afb01,afb02,afb03,afb04,afb041,afb042,afb05,afb06, 
                               afb07,afb08,afb09,afb10,afb11,afb12,afb13,
                                afb14,afb15,afbacti,afbuser,afbgrup,      
                               afbmodu,afbdate,afboriu,afborig)
              VALUES(sr1.afb00,sr1.afb01,sr1.afb02,sr1.afb03,' ',' ',' ',sr1.afb05,
                     sr1.afb06,sr1.afb07,sr1.afb08,sr1.afb09,m_afb10,m_afb11,
                     m_afb12,m_afb13,m_afb14,'1','Y',g_user,g_grup,g_user,g_today, g_user, g_grup)   #MOD-B30385 add
                     #m_afb12,m_afb13,m_afb14,'1','Y',g_user,' ',g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
         #str CHI-9C0004 add 
          IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
             UPDATE afb_file SET afb10 = m_afb10,
                                 afb11 = m_afb11,
                                 afb12 = m_afb12,
                                 afb13 = m_afb13,
                                 afb14 = m_afb14
              WHERE afb00=sr1.afb00 AND afb01=sr1.afb01
                AND afb03=sr1.afb03 AND afb02=sr1.afb02
                AND afb04=' '  AND afb041=' '  AND afb042=' '
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","afb_file",sr1.afb01,sr1.afb02,SQLCA.sqlcode,"","upd afb :",1)
                LET g_success = 'N'
             END IF
          ELSE
         #end CHI-9C0004 add 
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","afb_file",sr1.afb01,sr1.afb02,SQLCA.sqlcode,"","ins afb",1)  
               LET g_success = 'N'
            END IF
          END IF   #CHI-9C0004 add
      #END IF   #CHI-9C0004 mark
END REPORT
 
#REPORT t600_rep2(sr2,p_p001)  #CHI-9C0004 mark
REPORT t600_rep2(sr2)          #CHI-9C0004
  DEFINE sr2 RECORD LIKE afc_file.*
 #DEFINE p_p001     LIKE type_file.chr1   #CHI-9C0004 mark 
  DEFINE l_cnt     LIKE type_file.num5
  DEFINE m_afc06   LIKE afc_file.afc06,  
         m_afc07   LIKE afc_file.afc07, 
         m_afc08   LIKE afc_file.afc08, 
         m_afc09   LIKE afc_file.afc09  
  DEFINE l_afc00   LIKE afc_file.afc00
  DEFINE l_afc01   LIKE afc_file.afc01
  DEFINE l_afc02   LIKE afc_file.afc02
  DEFINE l_afc03   LIKE afc_file.afc03
  DEFINE l_afc05   LIKE afc_file.afc05
  DEFINE l_afc06   LIKE afc_file.afc06
  DEFINE l_afc07   LIKE afc_file.afc07
  DEFINE l_afc08   LIKE afc_file.afc08
  DEFINE l_afc09   LIKE afc_file.afc09
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 
   ORDER EXTERNAL BY sr2.afc00,sr2.afc03,sr2.afc01,
                     sr2.afc02,sr2.afc04,sr2.afc041,
                     sr2.afc042,sr2.afc05
 
  FORMAT
 
      AFTER GROUP OF sr2.afc05
         LET m_afc06 =0
         LET m_afc08 =0
         LET m_afc09 =0
         LET l_afc06 =0
         LET l_afc08 =0
         LET l_afc09 =0
        #str CHI-9C0004 mark
        #SELECT count(*) INTO l_cnt FROM afc_file
        # WHERE afc00 = sr2.afc00
        #   AND afc01 = sr2.afc01
        #   AND afc03 = sr2.afc03
        #   AND afc02 = sr2.afc02  
        #   AND afc04 = ' '  
        #   AND afc041= ' ' 
        #   AND afc042= ' '
        #   AND afc05 = sr2.afc05
        #IF l_cnt > 0  THEN 
        #   LET p_p001 ='Y' 
        #END IF
        #end CHI-9C0004 mark
         SELECT afc00,afc03,afc01,afc02,afc05,COALESCE(SUM(afc06),0),COALESCE(SUM(afc08),0),COALESCE(SUM(afc09),0)
           INTO l_afc00,l_afc03,l_afc01,l_afc02,l_afc05,l_afc06,l_afc08,l_afc09
           FROM afc_file
          WHERE afc00 = sr2.afc00
            AND afc01 = sr2.afc01
            AND afc03 = sr2.afc03
            AND afc02 = sr2.afc02
            AND afc04 = ' '
            AND afc041= ' '
            AND afc042= ' ' 
            AND afc05 = sr2.afc05
            GROUP BY afc00,afc03,afc01,afc02,afc05
         IF cl_null(l_afc06) THEN LET l_afc06 = 0 END IF  
         IF cl_null(l_afc08) THEN LET l_afc08 = 0 END IF  
         IF cl_null(l_afc09) THEN LET l_afc09 = 0 END IF  
         LET m_afc06 = GROUP SUM(sr2.afc06)
         LET m_afc08 = GROUP SUM(sr2.afc08)
         LET m_afc09 = GROUP SUM(sr2.afc09)
         IF cl_null(m_afc06) THEN LET m_afc06 = 0 END IF  
         IF cl_null(m_afc08) THEN LET m_afc08 = 0 END IF  
         IF cl_null(m_afc09) THEN LET m_afc09 = 0 END IF  
         LET m_afc06 = m_afc06+m_afc08+m_afc09+l_afc06+l_afc08+l_afc09
         LET l_afc07 = 0
         LET l_afc08 = 0
         LET l_afc09 = 0
      #str CHI-9C0004 mark
      #IF p_p001='Y'  THEN
      #   UPDATE afc_file SET afc06 = m_afc06,
      #                       afc07 = l_afc07,
      #                       afc08 = l_afc08,
      #                       afc09 = l_afc09 
      #                 WHERE afc00 = sr2.afc00 AND afc01 = sr2.afc01
      #                   AND afc02 = sr2.afc02 AND afc03 = sr2.afc03
      #                   AND afc04 = ' '     AND afc041 =' '
      #                   AND afc042 =' '
      #                   AND afc05 = sr2.afc05
      #  IF SQLCA.sqlcode THEN
      #     CALL cl_err3("upd","afc_file",sr2.afc02,sr2.afc03,SQLCA.sqlcode,"","upd afc:",1)
      #     LET g_success = 'N'  
      #  END IF
      #END IF
      #IF p_p001='N' THEN
      #   IF yyy != sr2.afc03 THEN #不同會計年度...已消耗預算不能代出
      #      LET m_afc07 = 0
      #   END IF
      #end CHI-9C0004 mark
          INSERT INTO afc_file (afc00,afc01,afc02,afc03,afc04,afc041,afc042,afc05, 
                               afc06,afc07,afc08,afc09)
              VALUES(sr2.afc00,sr2.afc01,sr2.afc02,sr2.afc03,' ',' ',' ',
                     sr2.afc05,m_afc06,l_afc07,l_afc08,l_afc09)
           #str CHI-9C0004 add 
            IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
               UPDATE afc_file SET afc06 = m_afc06,
                                   afc07 = l_afc07,
                                   afc08 = l_afc08,
                                   afc09 = l_afc09 
                             WHERE afc00 = sr2.afc00 AND afc01 = sr2.afc01
                               AND afc02 = sr2.afc02 AND afc03 = sr2.afc03
                               AND afc04 = ' '     AND afc041 =' '
                               AND afc042 =' '
                               AND afc05 = sr2.afc05
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","afc_file",sr2.afc02,sr2.afc03,SQLCA.sqlcode,"","upd afc:",1)
                  LET g_success = 'N'  
               END IF
            ELSE
           #end CHI-9C0004 add 
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","afc_file",sr2.afc02,sr2.afc03,SQLCA.sqlcode,"","ins afc:",1) 
             LET g_success = 'N' 
          END IF
            END IF   #CHI-9C0004 add
        #END IF   #CHI-9C0004 mark
END REPORT
 
FUNCTION t600_out()            
DEFINE l_wc    STRING                                                                             
    IF cl_null(g_afb.afb00) OR 
       cl_null(g_afb.afb02) OR cl_null(g_afb.afb03) OR
       cl_null(g_afb.afb01) THEN
       CALL cl_err('','9057',0) RETURN
    END IF
    IF cl_null(g_wc) THEN
       LET g_wc =" afb00 = '",g_afb.afb00,"'"," AND afb01 = '",g_afb.afb01,"'",  
                 " AND afb02 = '",g_afb.afb02,"'"," AND afb03 = ",g_afb.afb03,
                 " AND afb04 = '",g_afb.afb04,"'"," AND afb041 = '",g_afb.afb041,"'",
                 " AND afb042 = '",g_afb.afb042,"'"
   END IF
   IF cl_null(g_wc2) THEN
       LET g_wc2=" 1=1"    
   END IF
   CALL cl_wait()   
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                    
   LET g_sql=" SELECT DISTINCT afb00,afb01,afb02,afb03,afb04,afb041,afb042,afb05,afb06,afb07,afb09,",  
             " afb10,afb11,afb12,afb13,afb14,afb18,afb19,afc05,afc06,afc07,afc08,afc09,gem02,azf03,",
             " aag02,pja02",
             " FROM aag_file,pja_file,",
             " ((afb_file LEFT JOIN afc_file ON afb00 = afc00 AND afb01 = afc01 ",    
             " AND afb02 = afc02 AND afb03 = afc03 AND afb04 = afc04 AND afb041 = afc041 AND afb042 = afc042)",           
             " LEFT JOIN gem_file ON  gem01 = afb041) LEFT JOIN azf_file ON  azf01 = afb01 AND azf02 = '2'",     
             " WHERE aag00 = afb00 AND aag01 = afb02 AND aag03 = '2' AND aag07 IN ('2','3')",
             " AND pja01 = afb042",                   
             " AND aag21 = 'Y' ",    #MOD-A40172 add
             " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED                                              
   IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(g_wc,'afb00,afb01,afb02,afb03,afb04,afb041,afb042,afb05,afb06,afb07,afb09,  
                           afb10,afb11,afb12,afb13,afb14,afb18,afb19,afc05,afc06,afc07,afc08,afc09')                 
            RETURNING l_wc
    ELSE
       LET l_wc = ' '
    END IF
    LET g_str = l_wc
    CALL cl_prt_cs1('aglt600','aglt600',g_sql,g_str)                                    
                        
 END FUNCTION                                                            
 
 #計算年度和各季度預算
 FUNCTION t600_sum() 
 DEFINE l_afb10  LIKE afb_file.afb10
 DEFINE l_afb11  LIKE afb_file.afb11
 DEFINE l_afb12  LIKE afb_file.afb12
 DEFINE l_afb13  LIKE afb_file.afb13
 DEFINE l_afb14  LIKE afb_file.afb14
 DEFINE l_sql    STRING
    LET l_sql="SELECT COALESCE(SUM(afc06),0)+ COALESCE(SUM(afc08),0)+ COALESCE(SUM(afc09),0) FROM afc_file",
            " WHERE afc00 = '",g_afb.afb00,"'"," AND afc01 = '",g_afb.afb01,"'",
            "   AND afc02 = '",g_afb.afb02,"'"," AND afc03 = ",g_afb.afb03,
            "   AND afc04 = '",g_afb.afb04,"'"," AND afc041 = '",g_afb.afb041,"'",
            "   AND afc042 = '",g_afb.afb042,"'"," AND afc05 >= ? AND afc05 <= ?"
    PREPARE t600_sum_p FROM l_sql 
    EXECUTE t600_sum_p USING '1','3' INTO l_afb11
    EXECUTE t600_sum_p USING '4','6' INTO l_afb12
    EXECUTE t600_sum_p USING '7','9' INTO l_afb13
    IF g_azm.azm02 = '1' THEN
    EXECUTE t600_sum_p USING '10','12' INTO l_afb14
    END IF
    IF g_azm.azm02 = '2' THEN
    EXECUTE t600_sum_p USING '10','13' INTO l_afb14
    END IF
    FREE t600_sum_p
    LET l_afb10 = l_afb11 + l_afb12 + l_afb13 + l_afb14
    UPDATE afb_file SET afb10 = l_afb10,
                        afb11 = l_afb11,
                        afb12 = l_afb12,
                        afb13 = l_afb13,
                        afb14 = l_afb14
           WHERE afb00 = g_afb.afb00 AND afb01 = g_afb.afb01
             AND afb02 = g_afb.afb02 AND afb03 = g_afb.afb03
             AND afb04 = g_afb.afb04 AND afb041 = g_afb.afb041
             AND afb042 = g_afb.afb042    
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","afb_file",g_afb.afb00,"",SQLCA.sqlcode,"","",1)  
            ROLLBACK WORK
     END IF
     LET g_afb.afb10 = l_afb10
     LET g_afb.afb11 = l_afb11
     LET g_afb.afb12 = l_afb12
     LET g_afb.afb13 = l_afb13
     LET g_afb.afb14 = l_afb14
      DISPLAY l_afb10,l_afb11,l_afb12,l_afb13,l_afb14                            
         TO  afb10,afb11,afb12,afb13,afb14                                      
                                                                                
 END FUNCTION 
 #No.FUN-9C0072 精簡程式碼

#TQC-A60061--Add--Begin
FUNCTION t600_afb041_2()         
  DEFINE l_cnt  LIKE type_file.num5 
    
  IF NOT cl_null(g_afb.afb00) AND NOT cl_null(g_afb.afb02) THEN 
     LET l_cnt=0
     SELECT COUNT(*) INTO l_cnt FROM aab_file 
      WHERE aab00=g_afb.afb00
        AND aab01=g_afb.afb02
        AND aab02=g_afb.afb041
     IF l_cnt > 0 AND g_aaz.aaz72 = '1' THEN    
        LET g_errno='agl-207'
     END IF   
  END IF 
END FUNCTION
#TQC-A60061--Add--End

