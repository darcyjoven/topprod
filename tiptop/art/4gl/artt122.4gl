# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
#Pattern name..:"artt122.4gl"
#Descriptions..:自定價調整單
#Date & Author..:FUN-870007 08/07/15 By Zhangyajun
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A10128 10/01/18 By Cockroach 添加g_data_plant管控
# Modify.........: No.TQC-A30041 10/03/15 By Cockroach  add oriu/orig  
# Modify.........: No.FUN-A30091 10/03/30 By Cockroach  g_date-->g_today
# Modify.........: No.TQC-A70080 10/07/19 By Carrier insert时加入legal字段
# Modify.........: No.FUN-A70130 10/08/06 By shaoyong AXM/ATM/ARM/ART/ALM單別調整,統一整合到oay_file,ART單據調整回歸 ART模組
# Modify.........: No.FUN-A70130 10/08/11 By huangtao 修改q_oay*()的參數
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管 
# Modify.........: No.FUN-AA0059 10/10/28 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No.TQC-AB0151 10/11/28 By shenyang GP5.2 SOP流程修改 
# Modify.........: No:TQC-AC0322 10/12/22 By wangxin 審核時當單頭生效方式為1立即變更時，請將審核日期同時賦值給單頭生效日期
# Modify.........: No:MOD-B20065 11/02/16 By baogc 增加狀況碼欄位(rtm900)來標識是否為發出的資料，確認時更新狀況碼為已核准(1)，發出后更新狀況碼為已發出(2)
#                                                  增加發出按鈕用來更新變更的數據(當且僅當生效日期等於當前日期的時候才允許發出)
# Modify.........: No:MOD-B30401 11/03/14 By suncx 變更自定價時，同時更新已傳POS否欄位為N
# Modify.........: No:FUN-B40103 11/05/06 By shiwuying 增加开价否栏位rtn16,rtn17
# Modify.........: No:FUN-B40071 11/05/09 by jason 已傳POS否狀態調整
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B50026 11/07/05 By zhangll 單號控管改善
# Modify.........: No.FUN-B80085 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外 

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C50036 12/05/21 by fanbj 增加最高退價欄位
# Modify.........: No.CHI-C30002 12/05/28 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/15 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C80046 12/08/17 By bart 複製後停在新資料畫面
# Modify.........: No:CHI-C80041 12/12/27 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No.CHI-D20015 13/03/26 By xumm 取消確認賦值確認異動時間和人員
# Modify.........: No:FUN-D30033 13/04/12 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:TQC-D40044 13/04/19 By dongsz 維護單位時，檢查是否存在庫存單位轉化率，存在時才能維護

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  g_rtm   RECORD LIKE rtm_file.*,
        g_rtm_t RECORD LIKE rtm_file.*,
        g_rtn   DYNAMIC ARRAY OF RECORD 
                rtn02   LIKE rtn_file.rtn02,
                rtn03   LIKE rtn_file.rtn03,
                rtn03_desc LIKE ima_file.ima02,
                rtn04   LIKE rtn_file.rtn04,
                rtn04_desc LIKE gfe_file.gfe02,
                rtn05   LIKE rtn_file.rtn05,
                rtn06   LIKE rtn_file.rtn06,
                rtn07   LIKE rtn_file.rtn07,
                rtn08   LIKE rtn_file.rtn08,
                rtn09   LIKE rtn_file.rtn09,
                rtn10   LIKE rtn_file.rtn10,
                rtn11   LIKE rtn_file.rtn11,
                rtn12   LIKE rtn_file.rtn12,
                rtn13   LIKE rtn_file.rtn13,
                rtn18   LIKE rtn_file.rtn18,      #FUN-C50036 add
               #FUN-B40103 Begin---
                rtn16   LIKE rtn_file.rtn16,
                rtn17   LIKE rtn_file.rtn17,
               #FUN-B40103 End-----
                rtn14   LIKE rtn_file.rtn14,
                rtn15   LIKE rtn_file.rtn15
                        END RECORD,
        g_rtn_t RECORD
                rtn02   LIKE rtn_file.rtn02,
                rtn03   LIKE rtn_file.rtn03,
                rtn03_desc LIKE ima_file.ima02,
                rtn04   LIKE rtn_file.rtn04,
                rtn04_desc LIKE gfe_file.gfe02,
                rtn05   LIKE rtn_file.rtn05,
                rtn06   LIKE rtn_file.rtn06,
                rtn07   LIKE rtn_file.rtn07,
                rtn08   LIKE rtn_file.rtn08,
                rtn09   LIKE rtn_file.rtn09,
                rtn10   LIKE rtn_file.rtn10,
                rtn11   LIKE rtn_file.rtn11,
                rtn12   LIKE rtn_file.rtn12,
                rtn13   LIKE rtn_file.rtn13,
                rtn18   LIKE rtn_file.rtn18,      #FUN-C50036 add
               #FUN-B40103 Begin---
                rtn16   LIKE rtn_file.rtn16,
                rtn17   LIKE rtn_file.rtn17,
               #FUN-B40103 End-----
                rtn14   LIKE rtn_file.rtn14,
                rtn15   LIKE rtn_file.rtn15
                        END RECORD
 
DEFINE  g_sql   STRING,
        g_wc    STRING,
        g_wc2   STRING,
        g_rec_b LIKE type_file.num5,
        l_ac    LIKE type_file.num5
DEFINE  p_row,p_col          LIKE type_file.num5
DEFINE  g_forupd_sql         STRING
DEFINE  g_before_input_done  LIKE type_file.num5
DEFINE  g_chr                LIKE type_file.chr1
DEFINE  g_cnt                LIKE type_file.num10
DEFINE  g_msg                LIKE ze_file.ze03
DEFINE  g_row_count          LIKE type_file.num10
DEFINE  g_curs_index         LIKE type_file.num10
DEFINE  g_jump               LIKE type_file.num10
DEFINE  mi_no_ask            LIKE type_file.num5
DEFINE  l_table  STRING
DEFINE  g_success  LIKE type_file.chr1
DEFINE  g_t1       LIKE oay_file.oayslip  #自動編號
DEFINE  g_rtz05    LIKE rtz_file.rtz05
DEFINE g_void              LIKE type_file.chr1      #CHI-C80041

MAIN
        OPTIONS                            
        INPUT NO WRAP
    DEFER INTERRUPT                      
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time   
         
    LET g_forupd_sql="SELECT * FROM rtm_file WHERE rtm01=? AND rtmplant=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t122_cl    CURSOR FROM g_forupd_sql
    
    LET p_row = 4 LET p_col = 10
    OPEN WINDOW t122_w AT p_row,p_col WITH FORM "art/42f/artt122"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
    
    SELECT rtz05 INTO g_rtz05 FROM rtz_file WHERE rtz01=g_plant
    CALL t122_menu()
    
    CLOSE WINDOW t122_w                   
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
FUNCTION t122_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = ''
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_rtn TO s_rtn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
        CALL cl_navigator_setting(g_curs_index,g_row_count)
        
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
      
      ON ACTION confirm  #審核
         LET g_action_choice="confirm"
         EXIT DISPLAY 
#MOD-B20065 ADD-BEGIN---
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end 
      ON ACTION ch_issued
         LET g_action_choice="ch_issued"
         EXIT DISPLAY
#MOD-B20065 ADD-END-----
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
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION first
         CALL t122_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION previous
         IF g_curs_index>1 THEN
          CALL t122_fetch('P')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY 
      ON ACTION jump
         CALL t122_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION next
         IF g_curs_index<g_row_count THEN
          CALL t122_fetch('N')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
          ACCEPT DISPLAY 
         END IF
      ON ACTION last
         CALL t122_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY   
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
#      ON ACTION output
#        LET g_action_choice="output"
#         EXIT DISPLAY
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
      ON ACTION related_document    
         LET g_action_choice="related_document"
         EXIT DISPLAY 
      ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
      AFTER DISPLAY
         CONTINUE DISPLAY
 
  END DISPLAY
  CALL cl_set_act_visible("accept,cancel", TRUE)
  
END FUNCTION
 
FUNCTION t122_menu()
 
   WHILE TRUE
      CALL t122_bp("G")
      CASE g_action_choice
         WHEN "confirm"   #審核
            IF cl_chk_act_auth() THEN
                  CALL t122_confirm()
            END IF
#MOD-B20065 ADD-BEGIN---
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t122_z()
            END IF
                  
         WHEN "ch_issued" 
            IF cl_chk_act_auth() THEN
               CALL t122_ch() 
            END IF   
#MOD-B20065 ADD-END-----
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t122_q()
            END IF
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t122_a()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
                  CALL t122_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
                  CALL t122_u()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
                  CALL t122_copy()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
                  CALL t122_x()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
                  CALL t122_b()
            ELSE
               LET g_action_choice = NULL
            END IF
#         WHEN "output"
#            IF cl_chk_act_auth() THEN
#               CALL t122_out()
#            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()       
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_rtn),'','')
             END IF 
         WHEN "related_document"
             IF cl_chk_act_auth() THEN
                IF NOT cl_null(g_rtm.rtm01)  THEN
                   LET g_doc.column1 = "rtm01"
                   LET g_doc.column1 = "rtmplant"
                   LET g_doc.value1 = g_rtm.rtm01
                   LET g_doc.value1 = g_rtm.rtmplant
                   CALL cl_doc()
                END IF
             END IF       
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t122_v()
               IF g_rtm.rtmconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_rtm.rtmconf,"","","",g_void,"")
            END IF
         #CHI-C80041---end 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t122_cs()
DEFINE  lc_qbe_sn   LIKE    gbm_file.gbm01
 
    CLEAR FORM
    CALL g_rtn.clear()
    
    CONSTRUCT BY NAME g_wc ON                               
      # rtm01,rtm02,rtm03,rtm04,rtm05,rtm06,rtmconf,rtmcond,  #MOD-B20065 MARK
        rtm01,rtm02,rtm03,rtm04,rtm05,rtm06,                  #MOD-B20065 ADD
        rtm900,rtmconf,rtmcond,                               #MOD-B20065 ADD
      # rtmconu,rtmmksg,rtm900,rtmplant,rtm07,#TQC-AB0151 
        rtmconu,rtmplant,rtm07,#TQC-AB0151
        rtmuser,rtmgrup,rtmmodu,rtmcrat,rtmacti,rtmdate
       ,rtmoriu,rtmorig                            #TQC-A30041 ADD
             
        BEFORE CONSTRUCT
              CALL cl_qbe_init()
              
        ON ACTION controlp
           CASE
              WHEN INFIELD(rtm01)  #調整單號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rtm01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rtm01
                 NEXT FIELD rtm01
              WHEN INFIELD(rtmconu) #審核人員
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rtmconu"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rtmconu
                 NEXT FIELD rtmconu
              WHEN INFIELD(rtmplant)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azp"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rtmplant
                 NEXT FIELD rtmplant
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
           CALL cl_qbe_list() RETURNING lc_qbe_sn
           CALL cl_qbe_display_condition(lc_qbe_sn)          
		
    END CONSTRUCT
    IF INT_FLAG THEN 
        RETURN
    END IF
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           
    #        LET g_wc = g_wc CLIPPED," AND rtmuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           
    #        LET g_wc = g_wc CLIPPED," AND rtmgrup MATCHES '",
    #                   g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN              
    #        LET g_wc = g_wc clipped," AND rtmgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rtmuser', 'rtmgrup')
    #End:FUN-980030
   
    CONSTRUCT g_wc2 ON rtn02,rtn03,rtn04,rtn05,rtn06,rtn07,rtn08,rtn09,
                       #rtn10,rtn11,rtn12,rtn13,rtn16,rtn17,rtn14,rtn15 #FUN-B40103     #FUN-C50036 mark
                       rtn10,rtn11,rtn12,rtn13,rtn18,rtn16,rtn17,rtn14,rtn15            #FUN-C50036 add  
                   FROM s_rtn[1].rtn02,s_rtn[1].rtn03,s_rtn[1].rtn04,s_rtn[1].rtn05,
                        s_rtn[1].rtn06,s_rtn[1].rtn07,s_rtn[1].rtn08,s_rtn[1].rtn09,
                        s_rtn[1].rtn10,s_rtn[1].rtn11,s_rtn[1].rtn12,s_rtn[1].rtn13,
                        s_rtn[1].rtn18,                                                 #FUN-C50036 add   
                        s_rtn[1].rtn16,s_rtn[1].rtn17,                 #FUN-B40103
                        s_rtn[1].rtn14,s_rtn[1].rtn15
        BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            
        ON ACTION controlp
           CASE
              WHEN INFIELD(rtn03)  #商品代碼
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rtn03"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rtn03
                 NEXT FIELD rtn03
              WHEN INFIELD(rtn04)  #單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rtn04"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rtn04
                 NEXT FIELD rtn04
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
 
        ON ACTION qbe_save                        
          CALL cl_qbe_save()
		
    END CONSTRUCT
    
    IF INT_FLAG THEN 
        RETURN
    END IF
    
    LET g_wc2 = g_wc2 CLIPPED
    IF  g_wc2 = " 1=1" THEN       
         LET g_sql = "SELECT rtm01 FROM rtm_file ", 
                     " WHERE rtmplant IN ",g_auth," AND ",g_wc CLIPPED,
                     " ORDER BY rtm01"
    ELSE                                 
        LET g_sql = "SELECT UNIQUE rtm01",
                    " FROM rtm_file,rtn_file",
                    " WHERE rtm01=rtn01 AND rtmplant=rtnplant",
                    " AND rtmplant IN ",g_auth,
                    " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                    " ORDER BY rtm01"
    END IF
    
    PREPARE t122_prepare FROM g_sql
    DECLARE t122_cs SCROLL CURSOR WITH HOLD FOR t122_prepare
    IF g_wc2=" 1=1" THEN
        LET g_sql="SELECT COUNT(*) FROM rtm_file WHERE rtmplant IN ",g_auth," AND ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(*) FROM rtm_file,rtn_file WHERE",
                " rtm01=rtn01 AND rtmplant=rtnplant AND rtmplant IN ",g_auth," AND ",
                g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF 
    PREPARE t122_precount FROM g_sql
    DECLARE t122_count CURSOR FOR t122_precount
END FUNCTION
 
FUNCTION t122_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    CALL cl_opmsg('q')   
    CLEAR FORM 
    CALL g_rtn.clear()      
    MESSAGE ""   
    DISPLAY ' ' TO FORMONLY.cnt
    
    CALL t122_cs()              
            
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_rtm.* TO NULL
        CALL g_rtn.clear()
        RETURN
    END IF
    
    OPEN t122_cs                
    
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        CALL g_rtn.clear()
    ELSE
        OPEN t122_count
        FETCH t122_count INTO g_row_count
        IF g_row_count>0 THEN
           DISPLAY g_row_count TO FORMONLY.cnt                                 
           CALL t122_fetch('F') 
        ELSE 
           CALL cl_err('',100,0)
        END IF             
    END IF
END FUNCTION
 
FUNCTION t122_fetch(p_flrtm)
DEFINE p_flrtm         LIKE type_file.chr1           
    CASE p_flrtm
        WHEN 'N' FETCH NEXT     t122_cs INTO g_rtm.rtm01
        WHEN 'P' FETCH PREVIOUS t122_cs INTO g_rtm.rtm01
        WHEN 'F' FETCH FIRST    t122_cs INTO g_rtm.rtm01
        WHEN 'L' FETCH LAST     t122_cs INTO g_rtm.rtm01
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
            FETCH ABSOLUTE g_jump t122_cs INTO g_rtm.rtm01
            LET mi_no_ask = FALSE        
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rtm.rtm01,SQLCA.sqlcode,0)
        INITIALIZE g_rtm.* TO NULL  
        RETURN
    ELSE
      CASE p_flrtm
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx                 
    END IF
 
    SELECT * INTO g_rtm.* FROM rtm_file    
     WHERE rtm01 = g_rtm.rtm01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","rtm_file","","",SQLCA.sqlcode,"","",0)  
    ELSE
        LET g_data_owner=g_rtm.rtmuser           
        LET g_data_group=g_rtm.rtmgrup
        LET g_data_plant=g_rtm.rtmplant  #TQC-A10128 ADD
        CALL t122_show()                   
    END IF
END FUNCTION
 
FUNCTION t122_rtmplant(p_cmd)         
DEFINE    l_azp02    LIKE azp_file.azp02,    
          p_cmd      LIKE type_file.chr1   
          
   LET g_errno = ' '
   SELECT azp02 INTO l_azp02 FROM azp_file
     WHERE azp01 = g_rtm.rtmplant
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='art-070' 
                                 LET l_azp02=NULL 
       OTHERWISE   
       LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_azp02 TO FORMONLY.rtmplant_desc
  END IF
 
END FUNCTION
 
FUNCTION t122_rtmconu(p_cmd)         
DEFINE    l_genacti  LIKE gen_file.genacti, 
          l_gen02    LIKE gen_file.gen02,    
          p_cmd      LIKE type_file.chr1   
          
   LET g_errno = ' '
   SELECT gen02,genacti INTO l_gen02,l_genacti FROM gen_file
     WHERE gen01 = g_rtm.rtmconu
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='art-070' 
                                 LET l_gen02=NULL 
        WHEN l_genacti='N'       LET g_errno='9028'     
       OTHERWISE   
       LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gen02 TO FORMONLY.rtmconu_desc
  END IF
 
END FUNCTION
 
FUNCTION t122_rtn03(p_cmd)         
DEFINE    l_imaacti  LIKE ima_file.imaacti 
DEFINE    l_ima02    LIKE ima_file.ima02   
DEFINE    p_cmd      LIKE type_file.chr1
DEFINE    l_rtg08    LIKE rtg_file.rtg08
DEFINE    l_rtg09    LIKE rtg_file.rtg09   
          
   LET g_errno = ' '
   SELECT DISTINCT ima02,imaacti INTO l_ima02,l_imaacti FROM ima_file
    WHERE ima01 = g_rtn[l_ac].rtn03
      CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='art-158' 
                                 LET l_ima02=NULL 
        WHEN l_imaacti='N'       LET g_errno='9028'     
       OTHERWISE   
       LET g_errno=SQLCA.sqlcode USING '------' 
     END CASE
   IF cl_null(g_errno) AND NOT cl_null(g_rtz05) THEN
      IF NOT cl_null(g_rtn[l_ac].rtn04) THEN
         SELECT rtg08,rtg09 INTO l_rtg08,l_rtg09 FROM rtg_file
          WHERE rtg01 = g_rtz05
            AND rtg03 = g_rtn[l_ac].rtn03
            AND rtg04 = g_rtn[l_ac].rtn04
         CASE
           WHEN SQLCA.sqlcode=100 LET g_errno='art-901'
           WHEN l_rtg08='N'       LET g_errno='art-065'
           WHEN l_rtg09='N'       LET g_errno='9028'
           OTHERWISE              LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      ELSE
         SELECT rtg08,rtg09 INTO l_rtg08,l_rtg09 FROM rtg_file
          WHERE rtg01 = g_rtz05
            AND rtg03 = g_rtn[l_ac].rtn03
         IF SQLCA.sqlcode=100 THEN LET g_errno='art-902' END IF
      END IF
   END IF
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_rtn[l_ac].rtn03_desc = l_ima02
      DISPLAY BY NAME g_rtn[l_ac].rtn03_desc
  END IF
 
END FUNCTION
 
FUNCTION t122_rtn04(p_cmd)         
DEFINE    l_gfeacti  LIKE gfe_file.gfeacti, 
          l_gfe02    LIKE gfe_file.gfe02, 
          l_rthacti  LIKE rth_file.rthacti,   
          p_cmd      LIKE type_file.chr1   
DEFINE    l_rtg08    LIKE rtg_file.rtg08
DEFINE    l_rtg09    LIKE rtg_file.rtg09
          
   LET g_errno = ' '
   SELECT DISTINCT gfe02,gfeacti INTO l_gfe02,l_gfeacti FROM gfe_file
    WHERE gfe01 = g_rtn[l_ac].rtn04
      CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='art-159' 
                                 LET l_gfe02=NULL 
        WHEN l_gfeacti='N'       LET g_errno='9028'     
       OTHERWISE   
       LET g_errno=SQLCA.sqlcode USING '------' 
      END CASE
   IF NOT cl_null(g_rtz05) AND cl_null(g_errno) THEN
      IF NOT cl_null(g_rtn[l_ac].rtn03) THEN
         SELECT rtg08,rtg09 INTO l_rtg08,l_rtg09 FROM rtg_file
          WHERE rtg01 = g_rtz05
            AND rtg03 = g_rtn[l_ac].rtn03
            AND rtg04 = g_rtn[l_ac].rtn04
         CASE
           WHEN SQLCA.sqlcode=100 LET g_errno='art-901'
           WHEN l_rtg08='N'       LET g_errno='art-065'
           WHEN l_rtg09='N'       LET g_errno='9028'
           OTHERWISE              LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      END IF
   END IF
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_rtn[l_ac].rtn04_desc = l_gfe02
      DISPLAY BY NAME g_rtn[l_ac].rtn04_desc
  END IF
 
END FUNCTION
 
FUNCTION t122_show()
    LET g_rtm_t.* = g_rtm.*
    DISPLAY BY NAME g_rtm.rtm01,g_rtm.rtm02,g_rtm.rtm03,g_rtm.rtm04,g_rtm.rtm05, g_rtm.rtmoriu,g_rtm.rtmorig,
                 #  g_rtm.rtm06,g_rtm.rtm07,g_rtm.rtm900,g_rtm.rtmplant,g_rtm.rtmmksg,#TQC-AB0151
                    g_rtm.rtm06,g_rtm.rtm07,g_rtm.rtmplant,#TQC-AB0151
                    g_rtm.rtmconf,g_rtm.rtmcond,g_rtm.rtmconu,g_rtm.rtmacti,
                    g_rtm.rtmuser,g_rtm.rtmgrup,g_rtm.rtmmodu,g_rtm.rtmcrat,g_rtm.rtmdate
    DISPLAY BY NAME g_rtm.rtm900         #MOD-B20065 ADD
    
    CALL t122_rtmplant('d')
    CALL t122_rtmconu('d')
    CASE g_rtm.rtmconf
        WHEN "Y"
          CALL cl_set_field_pic('Y',"","","","","")
        WHEN "N"
          CALL cl_set_field_pic("","","","","",g_rtm.rtmacti)
        WHEN "X"
          CALL cl_set_field_pic("","","","",'Y',"")
    END CASE
    CALL t122_b_fill(g_wc2) 
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION t122_b_fill(p_wc2)              
DEFINE   p_wc2       STRING        
 
    LET g_sql =
        "SELECT rtn02,rtn03,'',rtn04,'',rtn05,rtn06,rtn07,rtn08,",
        #" rtn09,rtn10,rtn11,rtn12,rtn13,rtn16,rtn17,rtn14,rtn15 FROM rtn_file ", #FUN-B40103  #FUN-C50036 mark
        " rtn09,rtn10,rtn11,rtn12,rtn13,rtn18,rtn16,rtn17,rtn14,rtn15 FROM rtn_file ",         #FUN-C50036 add
        " WHERE rtn01='",g_rtm.rtm01,"' AND rtnplant='",g_rtm.rtmplant,"'"
    IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    PREPARE t122_pb FROM g_sql
    DECLARE rtn_cs CURSOR FOR t122_pb
 
    CALL g_rtn.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH rtn_cs INTO g_rtn[g_cnt].*  
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) 
        EXIT FOREACH
        END IF
        SELECT ima02 INTO g_rtn[g_cnt].rtn03_desc FROM ima_file
         WHERE ima01 = g_rtn[g_cnt].rtn03
        SELECT gfe02 INTO g_rtn[g_cnt].rtn04_desc FROM gfe_file
         WHERE gfe01 = g_rtn[g_cnt].rtn04
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_rtn.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t122_a()
DEFINE li_result   LIKE type_file.num5
 
   MESSAGE ""
   CLEAR FORM
   CALL g_rtn.clear()
   LET g_wc = NULL 
   LET g_wc2= NULL 
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_rtm.* LIKE rtm_file.*                  
 
   LET g_rtm_t.* = g_rtm.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_rtm.rtm02 = '1'
      LET g_rtm.rtmconf = 'N'
      LET g_rtm.rtmmksg = 'N'   #TQC-AB0151
      LET g_rtm.rtm900 = '0'
      LET g_rtm.rtmplant = g_plant
      LET g_rtm.rtmuser = g_user
      LET g_rtm.rtmoriu = g_user #FUN-980030
      LET g_rtm.rtmorig = g_grup #FUN-980030
      LET g_rtm.rtmgrup = g_grup
      LET g_rtm.rtmcrat = g_today
      LET g_rtm.rtmacti = 'Y'                    
      LET g_data_plant = g_plant #TQC-A10128 ADD
      SELECT azw02 INTO g_rtm.rtmlegal FROM azw_file WHERE azw01=g_plant
      CALL t122_i("a")                          
 
      IF INT_FLAG THEN                          
         INITIALIZE g_rtm.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_rtm.rtm01) THEN       
         CONTINUE WHILE
      END IF
      
       BEGIN WORK
#      CALL s_auto_assign_no("axm",g_rtm.rtm01,g_today,"","rtm_file","rtm01,rtmplant","","","") #FUN-A70130 mark
       CALL s_auto_assign_no("art",g_rtm.rtm01,g_today,"A2","rtm_file","rtm01,rtmplant","","","") #FUN-A70130 mod
          RETURNING li_result,g_rtm.rtm01
       IF (NOT li_result) THEN                                                                           
           CONTINUE WHILE                                                                     
       END IF
       
       DISPLAY BY NAME g_rtm.rtm01
       
      INSERT INTO rtm_file VALUES(g_rtm.*)
      IF SQLCA.sqlcode THEN                     
         CALL cl_err3("ins","rtm_file",g_rtm.rtm01,"",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      ELSE
         COMMIT WORK                                                   
      END IF
      
      SELECT * INTO g_rtm.* FROM rtm_file
       WHERE rtm01 = g_rtm.rtm01 
      LET g_rtm_t.* = g_rtm.*
      CALL g_rtn.clear()
 
      LET g_rec_b = 0  
      CALL t122_b()                   
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t122_i(p_cmd)
DEFINE     p_cmd     LIKE type_file.chr1,                
           l_n       LIKE type_file.num5,           
           li_result    LIKE type_file.num5
   CALL cl_set_head_visible("","YES")
#  DISPLAY BY NAME g_rtm.rtmconf,g_rtm.rtm900,g_rtm.rtmplant,g_rtm.rtmuser,g_rtm.rtmgrup,#TQC-AB0151
   DISPLAY BY NAME g_rtm.rtmconf,g_rtm.rtmplant,g_rtm.rtmuser,g_rtm.rtmgrup,    #TQC-AB0151 
                   g_rtm.rtmcrat,g_rtm.rtmacti,g_rtm.rtmmodu,g_rtm.rtmdate
                  ,g_rtm.rtmoriu,g_rtm.rtmorig           #TQC-A30041 ADD
                  ,g_rtm.rtm900                          #MOD-B20065 ADD
   CALL t122_rtmplant('d')
   
   INPUT BY NAME g_rtm.rtm01,g_rtm.rtm02,g_rtm.rtm03,g_rtm.rtm04,g_rtm.rtm05, g_rtm.rtmoriu,g_rtm.rtmorig,
               # g_rtm.rtm06,g_rtm.rtmmksg,g_rtm.rtm07     #TQC-AB0151
                 g_rtm.rtm06,g_rtm.rtm07                   #TQC-AB0151 
      WITHOUT DEFAULTS
 
      BEFORE INPUT
         
          LET g_before_input_done = FALSE
          CALL t122_set_entry(p_cmd)
          CALL t122_set_no_entry(p_cmd)
          CALL cl_set_docno_format("rtm01")
          LET g_before_input_done = TRUE
	
      AFTER FIELD rtm01
         IF NOT cl_null(g_rtm.rtm01) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_rtm.rtm01 != g_rtm_t.rtm01) THEN
#              CALL s_check_no("axm",g_rtm.rtm01,g_rtm_t.rtm01,"A2","rtm_file","rtm01,rtmplant","") #FUN-A70130 mark
               CALL s_check_no("art",g_rtm.rtm01,g_rtm_t.rtm01,"A2","rtm_file","rtm01,rtmplant","") #FUN-A70130 mod
                    RETURNING li_result,g_rtm.rtm01
                 IF (NOT li_result) THEN                                                            
                    LET g_rtm.rtm01=g_rtm_t.rtm01                                                                 
                    NEXT FIELD rtm01                                                                                      
                 END IF        
            END IF
         END IF
      ON CHANGE rtm02
         IF NOT cl_null(g_rtm.rtm02) THEN
            IF g_rtm.rtm02 = '1' THEN
               CALL cl_set_comp_entry("rtm03",FALSE)
               LET g_rtm.rtm03 = NULL
               CLEAR rtm03
            END IF
            IF g_rtm.rtm02 = '2' THEN
               CALL cl_set_comp_entry("rtm03",TRUE)
               LET g_rtm.rtm03 = NULL
               CLEAR rtm03
            END IF
         END IF    
      
      AFTER FIELD rtm04,rtm05,rtm06
          IF (NOT cl_null(g_rtm.rtm04)) OR (NOT cl_null(g_rtm.rtm05))
             OR (NOT cl_null(g_rtm.rtm06))  THEN  
             IF FGL_DIALOG_GETBUFFER()<=0 THEN
                CALL cl_err('','art-067',0)
                NEXT FIELD CURRENT
             END IF
           END IF
      AFTER INPUT
         LET g_rtm.rtmuser = s_get_data_owner("rtm_file") #FUN-C10039
         LET g_rtm.rtmgrup = s_get_data_group("rtm_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF cl_null(g_rtm.rtm01) THEN
               NEXT FIELD rtm01
            END IF
 
      ON ACTION CONTROLO                        
         IF INFIELD(rtm01) THEN
            LET g_rtm.* = g_rtm_t.*
            CALL t122_show()
            NEXT FIELD rtm01
         END IF   
         
     ON ACTION controlp
          CASE 
             WHEN INFIELD(rtm01)
                LET g_t1=s_get_doc_no(g_rtm.rtm01)
                CALL q_oay(FALSE,FALSE,g_t1,'A2','art') RETURNING g_t1    #FUN-A70130
                LET g_rtm.rtm01=g_t1                                                                                             
                DISPLAY BY NAME g_rtm.rtm01                                                                                      
                NEXT FIELD rtm01
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
 
FUNCTION t122_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("rtm01",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION t122_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1         
    IF p_cmd = 'u' AND g_chkey = 'N'AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("rtm01",FALSE)      
    END IF
 
END FUNCTION
 
FUNCTION t122_b()
DEFINE          l_ac_t  LIKE type_file.num5,
                l_n     LIKE type_file.num5,
                l_lock_sw       LIKE type_file.chr1,
                p_cmd   LIKE type_file.chr1,
                l_allow_insert  LIKE type_file.num5,
                l_allow_delete  LIKE type_file.num5
DEFINE l_ima25 LIKE ima_file.ima25
#TQC-AB0151 ----ADD--BEGIN--
DEFINE l_rtg05  LIKE rtg_file.rtg05
DEFINE l_rtg06  LIKE rtg_file.rtg06 
DEFINE l_rtg07  LIKE rtg_file.rtg07
#TQC-AB0151 ----ADD--end--             
DEFINE l_flag   LIKE type_file.chr1            #TQC-D40044 add
DEFINE l_fac    LIKE type_file.num20_6         #TQC-D40044 add 
        LET g_action_choice=""
        IF s_shut(0) THEN 
                RETURN
        END IF
        
        IF cl_null(g_rtm.rtm01) THEN
           CALL cl_err('',-400,0)
           RETURN 
        END IF
        
        SELECT * INTO g_rtm.* FROM rtm_file
         WHERE rtm01=g_rtm.rtm01 AND rtmplant=g_rtm.rtmplant
 
        IF g_rtm.rtmacti='N' THEN 
              CALL cl_err(g_rtm.rtm01,'mfg1000',0)
              RETURN 
        END IF
        IF g_rtm.rtmconf = 'X' THEN RETURN END IF  #CHI-C80041
        IF g_rtm.rtmconf = 'Y' THEN
           CALL cl_err('',9022,0)
           RETURN
        END IF
   
        CALL cl_opmsg('b')
        
        LET g_forupd_sql="SELECT  rtn02,rtn03,'',rtn04,'',rtn05,rtn06,rtn07,",
                         #"rtn08,rtn09,rtn10,rtn11,rtn12,rtn13,rtn16,rtn17,rtn14,rtn15", #FUN-B40103  #FUN-C50036 mark
                         "rtn08,rtn09,rtn10,rtn11,rtn12,rtn13,rtn18,rtn16,rtn17,rtn14,rtn15",         #FUN-C50036 add 
                         " FROM rtn_file",
                         " WHERE rtn01 = ? AND rtn02 = ? AND rtnplant = ?",
                         " FOR UPDATE "
        LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
        DECLARE t122_bcl CURSOR FROM g_forupd_sql
        
        LET l_allow_insert=cl_detail_input_auth("insert")
        LET l_allow_delete=cl_detail_input_auth("delete")
        
        INPUT ARRAY g_rtn WITHOUT DEFAULTS FROM s_rtn.*
                ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
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
                OPEN t122_cl USING g_rtm.rtm01,g_rtm.rtmplant
                IF STATUS THEN
                        CALL cl_err("OPEN t122_cl:",STATUS,1)
                        CLOSE t122_cl
                        ROLLBACK WORK
                END IF
                
                FETCH t122_cl INTO g_rtm.*
                IF SQLCA.sqlcode THEN
                        CALL cl_err(g_rtm.rtm01,SQLCA.sqlcode,0)
                        CLOSE t122_cl
                        ROLLBACK WORK 
                        RETURN
                END IF
                IF g_rec_b>=l_ac THEN 
                        LET p_cmd ='u'
                        LET g_rtn_t.*=g_rtn[l_ac].*
                        OPEN t122_bcl USING g_rtm.rtm01,g_rtn_t.rtn02,g_rtm.rtmplant
                        IF STATUS THEN
                                CALL cl_err("OPEN t122_bcl:",STATUS,1)
                                LET l_lock_sw='Y'
                        ELSE
                                FETCH t122_bcl INTO g_rtn[l_ac].*
                                IF SQLCA.sqlcode THEN
                                    CALL cl_err('',SQLCA.sqlcode,1)
                                    LET l_lock_sw="Y"
                                END IF
                                CALL t122_rtn03('d')
                                CALL t122_rtn04('d')
                                CALL cl_set_comp_entry("rtn11,rtn12,rtn13",TRUE)
                        END IF
                END IF
       BEFORE INSERT
                LET l_n=ARR_COUNT()
                LET p_cmd='a'
                INITIALIZE g_rtn[l_ac].* TO NULL
                LET g_rtn[l_ac].rtn15 = 'Y'
                LET g_rtn[l_ac].rtn17 = 'N'   #FUN-B40103
                LET g_rtn[l_ac].rtn08 = g_rtm.rtm04
                LET g_rtn[l_ac].rtn09 = g_rtm.rtm05
                LET g_rtn[l_ac].rtn10 = g_rtm.rtm06
                LET g_rtn_t.*=g_rtn[l_ac].*
                CALL cl_show_fld_cont()
           #    CALL cl_set_comp_entry("rtn11,rtn12,rtn13",FALSE)  #TQC-AB0151
                CALL cl_set_comp_entry("rtn11,rtn12,rtn13",TRUE)  #TQC-AB0151 
                NEXT FIELD rtn02
                
       AFTER INSERT
                IF INT_FLAG THEN
                        CALL cl_err('',9001,0)
                        LET INT_FLAG=0
                        CANCEL INSERT
                END IF
                INSERT INTO rtn_file(rtn01,rtn02,rtn03,rtn04,rtn05,rtn06,rtn07,rtn08,
                                     #rtn09,rtn10,rtn11,rtn12,rtn13,rtn16,rtn17,rtn14,rtn15,rtnplant,rtnlegal)  #No.TQC-A70080 #FUN-B40103 #FUN-C50036 mark
                                     rtn09,rtn10,rtn11,rtn12,rtn13,rtn18,rtn16,rtn17,rtn14,rtn15,rtnplant,rtnlegal)   #FUN-C50036 add
                              VALUES(g_rtm.rtm01,g_rtn[l_ac].rtn02,g_rtn[l_ac].rtn03,
                                     g_rtn[l_ac].rtn04,g_rtn[l_ac].rtn05,g_rtn[l_ac].rtn06,
                                     g_rtn[l_ac].rtn07,g_rtn[l_ac].rtn08,g_rtn[l_ac].rtn09,
                                     g_rtn[l_ac].rtn10,g_rtn[l_ac].rtn11,g_rtn[l_ac].rtn12,
                                     #g_rtn[l_ac].rtn13,g_rtn[l_ac].rtn16,g_rtn[l_ac].rtn17, #FUN-B40103       #FUN-C50036 mark
                                     g_rtn[l_ac].rtn13,g_rtn[l_ac].rtn18,g_rtn[l_ac].rtn16,g_rtn[l_ac].rtn17, #FUN-C50036 add
                                     g_rtn[l_ac].rtn14,g_rtn[l_ac].rtn15,g_rtm.rtmplant,
                                     g_rtm.rtmlegal)  #No.TQC-A70080
                IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","rtn_file",g_rtm.rtm01,g_rtn[l_ac].rtn02,SQLCA.sqlcode,"","",1)
                        CANCEL INSERT
                ELSE
                        MESSAGE 'INSERT O.K.'
                        COMMIT WORK
                        LET g_rec_b=g_rec_b+1
                        DISPLAY g_rec_b TO FORMONLY.cn2
                END IF
                
      BEFORE FIELD rtn02
        IF cl_null(g_rtn[l_ac].rtn02) OR g_rtn[l_ac].rtn02 = 0 THEN 
            SELECT MAX(rtn02)+1 INTO g_rtn[l_ac].rtn02 FROM rtn_file
                WHERE rtn01=g_rtm.rtm01 AND rtnplant=g_rtm.rtmplant
                IF g_rtn[l_ac].rtn02 IS NULL THEN
                        LET g_rtn[l_ac].rtn02=1
                END IF
         END IF
         
      AFTER FIELD rtn02
        IF NOT cl_null(g_rtn[l_ac].rtn02) THEN 
           IF g_rtn[l_ac].rtn02<= 0 THEN
              CALL cl_err('','aec-994',0)
              LET g_rtn[l_ac].rtn02=g_rtn_t.rtn02
              NEXT FIELD rtn02
           END IF
                IF p_cmd = 'a' OR (p_cmd = 'u' AND 
                                    g_rtn[l_ac].rtn02 <> g_rtn_t.rtn02) THEN
                       SELECT COUNT(*) INTO l_n FROM rtn_file
                            WHERE rtn01= g_rtm.rtm01 AND rtn02=g_rtn[l_ac].rtn02
                              AND rtnplant = g_rtm.rtmplant
                       IF l_n>0 THEN
                           CALL cl_err('',-239,0)
                           LET g_rtn[l_ac].rtn02=g_rtn_t.rtn02
                           NEXT FIELD rtn02
                       END IF
                 END IF
         END IF
       
      AFTER FIELD rtn03,rtn04
          IF INFIELD(rtn03) THEN
            IF NOT cl_null(g_rtn[l_ac].rtn03) THEN 
#FUN-AA0059 ---------------------start----------------------------
               IF NOT s_chk_item_no(g_rtn[l_ac].rtn03,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_rtn[l_ac].rtn03= g_rtn_t.rtn03
                  NEXT FIELD rtn03
               END IF
#FUN-AA0059 ---------------------end-------------------------------
                IF p_cmd = 'a' OR (p_cmd = 'u' AND 
                                    g_rtn[l_ac].rtn03 <> g_rtn_t.rtn03) THEN
                   CALL t122_rtn03('a')
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_rtn[l_ac].rtn03,g_errno,0)
                      LET g_rtn[l_ac].rtn03=g_rtn_t.rtn03
                      NEXT FIELD rtn03
                   END IF
                 END IF
            END IF
          END IF
          IF INFIELD(rtn04) THEN
            IF NOT cl_null(g_rtn[l_ac].rtn04) THEN 
                IF p_cmd = 'a' OR (p_cmd = 'u' AND 
                                    g_rtn[l_ac].rtn04 <> g_rtn_t.rtn04) THEN
                   CALL t122_rtn04('a')
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_rtn[l_ac].rtn04,g_errno,0)
                      LET g_rtn[l_ac].rtn04=g_rtn_t.rtn04
                      NEXT FIELD rtn04
                   END IF
                 END IF
             END IF
          END IF
          IF NOT cl_null(g_rtn[l_ac].rtn03) AND NOT cl_null(g_rtn[l_ac].rtn04) THEN
            #TQC-D40044--add--str---
             SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = g_rtn[l_ac].rtn03
             IF l_ima25 != g_rtn[l_ac].rtn04 THEN
                CALL s_umfchk(g_rtn[l_ac].rtn03,l_ima25,g_rtn[l_ac].rtn04)
                   RETURNING l_flag,l_fac
                IF l_flag = 1 THEN
                   CALL cl_err('','art-214',0)
                   NEXT FIELD CURRENT
                END IF
             END IF  
            #TQC-D40044--add--end--- 
              #SELECT rth04,rth05,rth06,rthacti,rth07     #FUN-B40103      #FUN-C50036 mark
             SELECT rth04,rth05,rth06,rthacti,rth07,rth08                  #FUN-C50036 add
                INTO g_rtn[l_ac].rtn05,g_rtn[l_ac].rtn06,
                     g_rtn[l_ac].rtn07,g_rtn[l_ac].rtn14,g_rtn[l_ac].rtn16, #FUN-B40103
                     g_rtn[l_ac].rtn18                                     #FUN-C50036 add
                FROM rth_file 
               WHERE rth01 = g_rtn[l_ac].rtn03 
                 AND rth02 = g_rtn[l_ac].rtn04 
                 AND rthplant = g_rtm.rtmplant
              IF SQLCA.sqlcode THEN       
                 SELECT rtg05,rtg06,rtg07,rtg09,rtg10       #FUN-B40103
                   INTO g_rtn[l_ac].rtn05,g_rtn[l_ac].rtn06,
                        g_rtn[l_ac].rtn07,g_rtn[l_ac].rtn14,g_rtn[l_ac].rtn16 #FUN-B40103
                   FROM rtg_file
                  WHERE rtg01 = g_rtz05
                    AND rtg03 = g_rtn[l_ac].rtn03
                    AND rtg04 = g_rtn[l_ac].rtn04
              END IF
              LET g_rtn[l_ac].rtn17 = g_rtn[l_ac].rtn16 #FUN-B40103
           END IF
           
       AFTER FIELD rtn08,rtn09,rtn10
          IF (NOT cl_null(g_rtn[l_ac].rtn08)) OR (NOT cl_null(g_rtn[l_ac].rtn09))
             OR (NOT cl_null(g_rtn[l_ac].rtn10))  THEN  
             IF FGL_DIALOG_GETBUFFER()<=0 THEN
                CALL cl_err('','art-067',0)
                NEXT FIELD CURRENT
             END IF
          END IF
           IF NOT cl_null(g_rtn[l_ac].rtn08) THEN
              LET g_rtn[l_ac].rtn11 = g_rtn[l_ac].rtn05*(g_rtn[l_ac].rtn08/100)
           END IF
           IF NOT cl_null(g_rtn[l_ac].rtn09) THEN
              LET g_rtn[l_ac].rtn12 = g_rtn[l_ac].rtn06*(g_rtn[l_ac].rtn09/100)
           END IF
           IF NOT cl_null(g_rtn[l_ac].rtn10) THEN
              LET g_rtn[l_ac].rtn13 = g_rtn[l_ac].rtn07*(g_rtn[l_ac].rtn10/100)
           END IF
#TQC-AB0151 ----ADD--BEGIN-- 
       IF (NOT cl_null(g_rtn[l_ac].rtn08)) OR (NOT cl_null(g_rtn[l_ac].rtn09))                                  
             OR (NOT cl_null(g_rtn[l_ac].rtn10))  THEN     
                   SELECT rtg05,rtg06,rtg07 
                   INTO l_rtg05,l_rtg06,l_rtg07
                   FROM rtg_file 
                  WHERE rtg01 = g_rtz05 
                    AND rtg03 = g_rtn[l_ac].rtn03 
                    AND rtg04 = g_rtn[l_ac].rtn04 
               IF g_rtn[l_ac].rtn11 < l_rtg07  OR g_rtn[l_ac].rtn12 < l_rtg07
                  OR g_rtn[l_ac].rtn13 < l_rtg07 THEN  
                  CALL cl_err(l_rtg07,'art-900',0)
                  NEXT FIELD CURRENT
               END IF     
           END IF 
#TQC-AB0151 ----ADD--end--      
       AFTER FIELD rtn11,rtn12,rtn13
           IF (NOT cl_null(g_rtn[l_ac].rtn11)) OR (NOT cl_null(g_rtn[l_ac].rtn12))
             OR (NOT cl_null(g_rtn[l_ac].rtn13))  THEN  
             IF FGL_DIALOG_GETBUFFER()<0 THEN
                CALL cl_err('','art-103',0)
                NEXT FIELD CURRENT
             END IF
           END IF
#TQC-AB0151 ---------------STA                                                  
           IF (NOT cl_null(g_rtn[l_ac].rtn11)) OR (NOT cl_null(g_rtn[l_ac].rtn12))
             OR (NOT cl_null(g_rtn[l_ac].rtn13))  THEN 
              SELECT rtg05,rtg06,rtg07                                
                   INTO l_rtg05,l_rtg06,l_rtg07                    
                   FROM rtg_file                                                
                  WHERE rtg01 = g_rtz05                                         
                    AND rtg03 = g_rtn[l_ac].rtn03                               
                    AND rtg04 = g_rtn[l_ac].rtn04 
               IF g_rtn[l_ac].rtn11 < l_rtg07  OR g_rtn[l_ac].rtn12 < l_rtg07
                  OR g_rtn[l_ac].rtn13 < l_rtg07 THEN  
                  CALL cl_err(l_rtg07,'art-900',0)                               
                  NEXT FIELD CURRENT                                             
               END IF                         
           END IF                                                    
           IF NOT cl_null(g_rtn[l_ac].rtn12) THEN                               
              IF g_rtn[l_ac].rtn12>g_rtn[l_ac].rtn11 THEN                       
                 CALL cl_err('','art-983',0)                                    
              END IF                                                            
           END IF                                                                                             
           IF NOT cl_null(g_rtn[l_ac].rtn13) THEN                               
              IF g_rtn[l_ac].rtn13>g_rtn[l_ac].rtn11 OR g_rtn[l_ac].rtn13>g_rtn[
l_ac].rtn12 THEN                                                                
                 CALL cl_err('','art-982',0)                                    
              END IF                                                            
           END IF                                                               
                                                                                
#TQC-AB0151 ---------------END 
           IF NOT cl_null(g_rtn[l_ac].rtn11) THEN
                   LET g_rtn[l_ac].rtn08 = (g_rtn[l_ac].rtn11/g_rtn[l_ac].rtn05)*100
                   IF g_rtn[l_ac].rtn08<0 THEN
                      LET g_rtn[l_ac].rtn08=g_rtn[l_ac].rtn08*(-1)
                   END IF
           END IF
           IF NOT cl_null(g_rtn[l_ac].rtn12) THEN
                   LET g_rtn[l_ac].rtn09 = (g_rtn[l_ac].rtn12/g_rtn[l_ac].rtn06)*100
                   IF g_rtn[l_ac].rtn09<0 THEN
                      LET g_rtn[l_ac].rtn09=g_rtn[l_ac].rtn09*(-1)
                   END IF
           END IF
           IF NOT cl_null(g_rtn[l_ac].rtn13) THEN
                   LET g_rtn[l_ac].rtn10 = (g_rtn[l_ac].rtn13/g_rtn[l_ac].rtn07)*100
                   IF g_rtn[l_ac].rtn10<0 THEN
                      LET g_rtn[l_ac].rtn10=g_rtn[l_ac].rtn10*(-1)
                   END IF
           END IF
           
       BEFORE DELETE                      
           IF g_rtn_t.rtn02 > 0 AND NOT cl_null(g_rtn_t.rtn02) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rtn_file
                    WHERE rtn01 = g_rtm.rtm01 AND rtnplant = g_rtm.rtmplant
                      AND rtn02 = g_rtn_t.rtn02
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","rtn_file",g_rtm.rtm01,g_rtn_t.rtn02,SQLCA.sqlcode,"","",1)  
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
              LET g_rtn[l_ac].* = g_rtn_t.*
              CLOSE t122_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rtn[l_ac].rtn02,-263,1)
              LET g_rtn[l_ac].* = g_rtn_t.*
           ELSE
             
              UPDATE rtn_file SET  rtn02 = g_rtn[l_ac].rtn02,
                                   rtn03 = g_rtn[l_ac].rtn03,
                                   rtn04 = g_rtn[l_ac].rtn04,
                                   rtn05 = g_rtn[l_ac].rtn05,
                                   rtn06 = g_rtn[l_ac].rtn06,
                                   rtn07 = g_rtn[l_ac].rtn07,
                                   rtn08 = g_rtn[l_ac].rtn08,
                                   rtn09 = g_rtn[l_ac].rtn09,
                                   rtn10 = g_rtn[l_ac].rtn10,
                                   rtn11 = g_rtn[l_ac].rtn11,
                                   rtn12 = g_rtn[l_ac].rtn12,
                                   rtn13 = g_rtn[l_ac].rtn13,
                                   rtn18 = g_rtn[l_ac].rtn18, #FUN-C50036 add
                                   rtn16 = g_rtn[l_ac].rtn16, #FUN-B40103
                                   rtn17 = g_rtn[l_ac].rtn17, #FUN-B40103
                                   rtn14 = g_rtn[l_ac].rtn14,
                                   rtn15 = g_rtn[l_ac].rtn15
                 WHERE rtn01 = g_rtm.rtm01 AND rtnplant = g_rtm.rtmplant
                   AND rtn02 = g_rtn_t.rtn02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rtn_file",g_rtm.rtm01,g_rtn_t.rtn02,SQLCA.sqlcode,"","",1) 
                 LET g_rtn[l_ac].* = g_rtn_t.*
              ELSE
                 LET g_rtm.rtmmodu = g_user
                 LET g_rtm.rtmdate = g_today
                 UPDATE rtm_file SET rtmmodu = g_rtm.rtmmodu,rtmdate = g_rtm.rtmdate
                  WHERE rtm01 = g_rtm.rtm01 AND rtmplant=g_rtm.rtmplant
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("upd","rtm_file",g_rtm.rtmmodu,g_rtm.rtmdate,SQLCA.sqlcode,"","",1)
                 END IF
                 DISPLAY BY NAME g_rtm.rtmmodu,g_rtm.rtmdate
                 MESSAGE 'UPDATE O.K.'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
        #  LET l_ac_t = l_ac    #FUN-D30033 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rtn[l_ac].* = g_rtn_t.*
            #FUN-D30033--add--str--
              ELSE
                 CALL g_rtn.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
            #FUN-D30033--add--end--
              END IF
              CLOSE t122_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac    #FUN-D30033 add
           CLOSE t122_bcl
           COMMIT WORK
           
      ON ACTION CONTROLO                        
           IF INFIELD(rtn02) AND l_ac > 1 THEN
              LET g_rtn[l_ac].* = g_rtn[l_ac-1].*
              LET g_rtn[l_ac].rtn02 = g_rec_b + 1
              NEXT FIELD rtn02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp                         
          CASE
            WHEN INFIELD(rtn03)
#FUN-AA0059---------mod------------str-----------------                                 
#               CALL cl_init_qry_var()                             #FUN-AA0059 mark
               IF cl_null(g_rtz05) THEN
#                 LET g_qryparam.form = "q_ima01"                  #FUN-AA0059 mark
                  CALL q_sel_ima(FALSE, "q_ima01","",g_rtn[l_ac].rtn03,"","","","","",'' ) #FUN-AA0059 add
                     RETURNING  g_rtn[l_ac].rtn03                                          #FUN-AA0059 add
               ELSE
               	  CALL cl_init_qry_var()                                                     #FUN-AA0059 add
                  LET g_qryparam.form = "q_rtg03_1"
                  LET g_qryparam.arg1 = g_rtz05
                  LET g_qryparam.default1 = g_rtn[l_ac].rtn03                                #FUN-AA0059 add
                  CALL cl_create_qry() RETURNING g_rtn[l_ac].rtn03                           #FUN-AA0059 add
               END IF
#               LET g_qryparam.default1 = g_rtn[l_ac].rtn03                                   #FUN-AA0059 mark
#               CALL cl_create_qry() RETURNING g_rtn[l_ac].rtn03                              #FUN-AA0059 mark 
#FUN-AA0059---------mod------------end-----------------
               DISPLAY BY NAME g_rtn[l_ac].rtn03
               CALL t122_rtn03('d')
               NEXT FIELD rtn03
            WHEN INFIELD(rtn04)                     
               CALL cl_init_qry_var()
               LET g_qryparam.default1 = g_rtn[l_ac].rtn04
               IF NOT cl_null(g_rtn[l_ac].rtn03) THEN
                  LET g_qryparam.form ="q_gfe02" 
                  SELECT ima25 INTO l_ima25 FROM ima_file 
                   WHERE ima01 = g_rtn[l_ac].rtn03
                  LET g_qryparam.arg1=l_ima25
               ELSE
                  LET g_qryparam.form ="q_gfe"
               END IF
               CALL cl_create_qry() RETURNING g_rtn[l_ac].rtn04
               DISPLAY BY NAME g_rtn[l_ac].rtn04
               CALL t122_rtn04('d')
               NEXT FIELD rtn04
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
 
        ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
    END INPUT
  
    CLOSE t122_bcl
    COMMIT WORK
#   CALL t122_delall()  #CHI-C30002 mark
    CALL t122_delHeader()     #CHI-C30002 add
    CALL t122_show()
END FUNCTION                 
 
#CHI-C30002 -------- add -------- begin
FUNCTION t122_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_rtm.rtm01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM rtm_file ",
                  "  WHERE rtm01 LIKE '",l_slip,"%' ",
                  "    AND rtm01 > '",g_rtm.rtm01,"'"
      PREPARE t122_pb1 FROM l_sql 
      EXECUTE t122_pb1 INTO l_cnt       
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
         CALL t122_v()
         IF g_rtm.rtmconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
         CALL cl_set_field_pic(g_rtm.rtmconf,"","","",g_void,"")
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM rtm_file WHERE rtm01 = g_rtm.rtm01 AND rtmplant = g_rtm.rtmplant
         INITIALIZE g_rtm.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t122_delall()
#
#  SELECT COUNT(*) INTO g_cnt FROM rtn_file
#   WHERE rtn01 = g_rtm.rtm01 AND rtnplant=g_rtm.rtmplant
#
#  IF g_cnt = 0 THEN                  
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM rtm_file WHERE rtm01 = g_rtm.rtm01 AND rtmplant = g_rtm.rtmplant
#     CLEAR FORM
#  END IF
#
#END FUNCTION                 
#CHI-C30002 -------- mark -------- end
                                
FUNCTION t122_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_rtm.rtm01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   
   SELECT * INTO g_rtm.* FROM rtm_file
    WHERE rtm01 = g_rtm.rtm01 AND rtmplant = g_rtm.rtmplant
 
   IF g_rtm.rtmacti ='N' THEN    
      CALL cl_err(g_rtm.rtm01,'mfg1000',0)
      RETURN
   END IF
   IF g_rtm.rtmconf = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_rtm.rtmconf = 'Y' THEN
      CALL cl_err('',9022,0)
      RETURN
   END IF
   
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_rtm_t.* = g_rtm.*
   BEGIN WORK
 
   OPEN t122_cl USING g_rtm.rtm01,g_rtm.rtmplant
   IF STATUS THEN
      CALL cl_err("OPEN t122_cl:", STATUS, 1)
      CLOSE t122_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t122_cl INTO g_rtm.*                      
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_rtm.rtm01,SQLCA.sqlcode,0)    
       CLOSE t122_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t122_show()
 
   WHILE TRUE
      LET g_rtm.rtmmodu=g_user
      LET g_rtm.rtmdate=g_today
 
      CALL t122_i("u")                            
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_rtm.*=g_rtm_t.*
         CALL t122_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_rtm.rtm01 <> g_rtm_t.rtm01 THEN            
         UPDATE rtn_file SET rtn01 = g_rtm.rtm01
             WHERE rtn01 = g_rtm_t.rtm01 AND rtnplant = g_rtm.rtmplant
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","rtn_file",g_rtm_t.rtm01,"",SQLCA.sqlcode,"","rtn",1)  
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE rtm_file SET rtm02 = g_rtm.rtm02,
                          rtm03 = g_rtm.rtm03,
                          rtm04 = g_rtm.rtm04,
                          rtm05 = g_rtm.rtm05,
                          rtm06 = g_rtm.rtm06,
                          rtm07 = g_rtm.rtm07,
                          rtmmodu = g_rtm.rtmmodu,
                          rtmdate = g_rtm.rtmdate
       WHERE rtm01 = g_rtm.rtm01
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rtm_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t122_cl
   COMMIT WORK
   CALL t122_show()
   CALL t122_bp_refresh()
 
END FUNCTION          
                
FUNCTION t122_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_rtm.rtm01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   
   SELECT * INTO g_rtm.* FROM rtm_file
    WHERE rtm01=g_rtm.rtm01 AND rtmplant=g_rtm.rtmplant
   IF g_rtm.rtmacti ='N' THEN    
      CALL cl_err(g_rtm.rtm01,'mfg1000',0)
      RETURN
   END IF
 
   IF g_rtm.rtmconf = 'Y' THEN
      CALL cl_err('',9022,0)
      RETURN
   END IF
   
   BEGIN WORK
 
   OPEN t122_cl USING g_rtm.rtm01,g_rtm.rtmplant
   IF STATUS THEN
      CALL cl_err("OPEN t122_cl:", STATUS, 1)
      CLOSE t122_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t122_cl INTO g_rtm.*               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rtm.rtm01,SQLCA.sqlcode,0)         
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t122_show()
 
   IF cl_delh(0,0) THEN                   
      DELETE FROM rtm_file WHERE rtm01 = g_rtm.rtm01 AND rtmplant=g_rtm.rtmplant
      DELETE FROM rtn_file WHERE rtn01 = g_rtm.rtm01 AND rtnplant=g_rtm.rtmplant
      CLEAR FORM
      CALL g_rtn.clear()
      OPEN t122_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE t122_cs
         CLOSE t122_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end--
      FETCH t122_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t122_cs
         CLOSE t122_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t122_cs
      IF g_row_count >0 THEN
 
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t122_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE      
            CALL t122_fetch('/')
         END IF
      END IF
   END IF
 
   CLOSE t122_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION t122_copy()
DEFINE  l_newno     LIKE rtm_file.rtm01,
        l_oldno     LIKE rtm_file.rtm01,
        l_cnt       LIKE type_file.num5,
        li_result   LIKE type_file.num5 
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_rtm.rtm01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   
   LET g_before_input_done = FALSE
   CALL t122_set_entry('a')
 
   CALL cl_set_head_visible("","YES")       
   INPUT l_newno FROM rtm01
       BEFORE INPUT
          CALL cl_set_docno_format("rtm01")
       AFTER FIELD rtm01
          IF l_newno IS NOT NULL THEN                                          
             SELECT count(*) INTO l_cnt FROM rtm_file                          
                 WHERE rtm01 = l_newno AND rtmplant=g_plant                                     
             IF l_cnt > 0 THEN                                                 
                CALL cl_err(l_newno,-239,0)                                    
                 NEXT FIELD rtm01                                              
             END IF                                                                                                                        
             #FUN-B50026 add
             CALL s_check_no("art",l_newno,"","A2","rtm_file","rtm01,rtmplant","")
                  RETURNING li_result,l_newno
             IF (NOT li_result) THEN                                                            
                NEXT FIELD rtm01                                                                                      
             END IF        
             #FUN-B50026 add--end
           END IF                       
     ON ACTION controlp
          CASE 
             WHEN INFIELD(rtm01)
                LET g_t1=s_get_doc_no(l_newno)
                CALL q_oay(FALSE,FALSE,g_t1,'A2','art') RETURNING g_t1         #FUN-A70130     
                LET l_newno = g_t1                                                                                             
                DISPLAY l_newno TO rtm01                                                                                   
                NEXT FIELD rtm01
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
      DISPLAY BY NAME g_rtm.rtm01
   
      ROLLBACK WORK
  
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM rtm_file         
       WHERE rtm01=g_rtm.rtm01 AND rtmplant=g_rtm.rtmplant
       INTO TEMP y
#  CALL s_auto_assign_no("axm",l_newno,g_today,"","rtm_file","rtm01,rtmplant","","","") #FUN-A70130 mark
   CALL s_auto_assign_no("art",l_newno,g_today,"A2","rtm_file","rtm01,rtmplant","","","") #FUN-A70130 mod
          RETURNING li_result,l_newno
   IF (NOT li_result) THEN                                                                           
           ROLLBACK WORK
           RETURN                                                                   
   END IF
   UPDATE y
       SET rtm01 = l_newno,    
           rtm900 = '0',   #MOD-B20065
           rtmuser = g_user,   
           rtmgrup = g_grup,   
           rtmoriu = g_user,   #TQC-A30041 ADD
           rtmorig = g_grup,   #TQC-A30041 ADD
           rtmmodu = NULL,     
           rtmcrat = g_today,  
           rtmdate = NULL,
           rtmacti = 'Y',
           rtmconf = 'N',
           rtmconu = NULL,
           rtmcond = NULL      
 
   INSERT INTO rtm_file SELECT * FROM y
   
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","rtm_file","","",SQLCA.sqlcode,"","",1) 
      ROLLBACK WORK
      RETURN
   ELSE
  
   DROP TABLE x
 
   SELECT * FROM rtn_file         
       WHERE rtn01=g_rtm.rtm01 AND rtnplant=g_rtm.rtmplant
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1) 
      RETURN
   END IF
 
   UPDATE x SET rtn01=l_newno
 
   INSERT INTO rtn_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
   #   ROLLBACK WORK        #FUN-B80085---回滾放在報錯後---
      CALL cl_err3("ins","rtn_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK         #FUN-B80085--add--
      RETURN
   ELSE
       COMMIT WORK 
   END IF
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_rtm.rtm01
   SELECT rtm_file.* INTO g_rtm.* FROM rtm_file 
    WHERE rtm01 = l_newno AND rtmplant=g_plant
   CALL t122_u()
   CALL t122_b()
   #SELECT rtm_file.* INTO g_rtm.* FROM rtm_file  #FUN-C80046
   # WHERE rtm01 = l_oldno AND rtmplant=g_plant   #FUN-C80046
   #CALL t122_show()  #FUN-C80046
 
END FUNCTION
 
FUNCTION t122_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_rtm.rtm01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   
   BEGIN WORK
 
   OPEN t122_cl USING g_rtm.rtm01,g_rtm.rtmplant
   IF STATUS THEN
      CALL cl_err("OPEN t122_cl:", STATUS, 1)
      CLOSE t122_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t122_cl INTO g_rtm.*               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rtm.rtm01,SQLCA.sqlcode,0)          
      ROLLBACK WORK
      RETURN
   END IF
 
   IF g_rtm.rtmconf = 'Y' THEN
      CALL cl_err('',9022,0)
      RETURN
   END IF
   
   LET g_success = 'Y'
 
   CALL t122_show()
 
   IF cl_exp(0,0,g_rtm.rtmacti) THEN                   
      LET g_chr=g_rtm.rtmacti
      IF g_rtm.rtmacti='Y' THEN
         LET g_rtm.rtmacti='N'
      ELSE
         LET g_rtm.rtmacti='Y'
      END IF
 
      UPDATE rtm_file SET rtmacti = g_rtm.rtmacti,
                          rtmmodu = g_user,
                          rtmdate = g_today
       WHERE rtm01 = g_rtm.rtm01 AND rtmplant = g_rtm.rtmplant
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","rtm_file",g_rtm.rtm01,"",SQLCA.sqlcode,"","",1)  
         LET g_rtm.rtmacti=g_chr
      END IF
   END IF
 
   CLOSE t122_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT rtmacti,rtmmodu,rtmdate
     INTO g_rtm.rtmacti,g_rtm.rtmmodu,g_rtm.rtmdate FROM rtm_file
    WHERE rtm01=g_rtm.rtm01 AND rtmplant=g_rtm.rtmplant
   DISPLAY BY NAME g_rtm.rtmacti,g_rtm.rtmmodu,g_rtm.rtmdate
   CALL cl_set_field_pic('','','','','',g_rtm.rtmacti)
END FUNCTION
 
FUNCTION t122_bp_refresh()
 
  DISPLAY ARRAY g_rtn TO s_rtn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
  
END FUNCTION
 
#MOD-B20065 MARK-BEGIN--
#
#FUNCTION t122_confirm()
#DEFINE ln_i    LIKE type_file.num5
#DEFINE l_n     LIKE type_file.num5
#DEFINE l_flag  LIKE type_file.num5
#DEFINE l_fac   LIKE ima_file.ima31_fac
#DEFINE l_ima25 LIKE ima_file.ima25
#DEFINE l_sql   STRING
#
#  IF cl_null(g_rtm.rtm01) THEN 
#       CALL cl_err('',-400,0) 
#       RETURN 
#  END IF  
#  
#  BEGIN WORK
#  LET g_success = 'Y'
#
#  OPEN t122_cl USING g_rtm.rtm01,g_rtm.rtmplant
#  IF STATUS THEN
#     CALL cl_err("OPEN t122_cl:", STATUS, 1)
#     CLOSE t122_cl
#     ROLLBACK WORK
#     RETURN
#  END IF
#
#  FETCH t122_cl INTO g_rtm.*    
#    IF SQLCA.sqlcode THEN
#     CALL cl_err('',SQLCA.sqlcode,0)      
#     CLOSE t122_cl
#     ROLLBACK WORK
#     RETURN
#   END IF
#
#  IF g_rtm.rtmacti='N' THEN
#       CALL cl_err('','atm-364',0)
#       RETURN
#  END IF
#  
#  IF g_rtm.rtmconf='Y' THEN 
#       CALL cl_err('','9023',0)
#       RETURN
#  END IF
#  IF NOT cl_confirm('axm-108') THEN 
#       RETURN
#  END IF
#  IF g_rtm.rtm02='1' THEN
#     FOR ln_i = 1 TO g_rec_b
#     SELECT COUNT(*) INTO l_n FROM rth_file
#      WHERE rth01 = g_rtn[ln_i].rtn03 AND rth02=g_rtn[ln_i].rtn04
#        AND rthplant = g_rtm.rtmplant
#     IF l_n = 0 THEN
#        SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = g_rtn[ln_i].rtn03
#        CALL s_umfchk('',l_ima25,g_rtn[ln_i].rtn04) RETURNING l_flag,l_fac
#        INSERT INTO rth_file (rth01,rth02,rth03,rth04,rth05,rth06,rthplant, 
#                              rthlegal,rthacti,rthpos,rthuser,rthgrup,rthcrat,rthmodu,rthdate,rthoriu,rthorig) 
#                        VALUES(g_rtn[ln_i].rtn03,g_rtn[ln_i].rtn04,l_fac,'','','',g_rtm.rtmplant, 
#                               g_rtm.rtmlegal,g_rtn[ln_i].rtn15,'N',g_user,g_grup,g_today,'','', g_user, g_grup)  #FUN-A30091    #No.FUN-980030 10/01/04  insert columns oriu, orig
#        IF SQLCA.sqlcode THEN
#           CALL cl_err3("ins","rth_file",g_rtm.rtm01,"",STATUS,"","",1)
#           LET g_success = 'N'
#        END IF
#     ELSE
#         UPDATE rth_file SET rth04 = g_rtn[ln_i].rtn11,
#                             rth05 = g_rtn[ln_i].rtn12,
#                             rth06 = g_rtn[ln_i].rtn13,
#                             rthacti = g_rtn[ln_i].rtn15
#                WHERE rth01 = g_rtn[ln_i].rtn03 AND rth02 = g_rtn[ln_i].rtn04 
#        IF SQLCA.sqlcode THEN
#           CALL cl_err3("upd","rth_file",g_rtm.rtm01,"",STATUS,"","",1) 
#           LET g_success = 'N'
#        ELSE
#           IF SQLCA.sqlerrd[3]=0 THEN
#              CALL cl_err3("upd","rth_file",g_rtm.rtm01,"","9050","","",1) 
#              LET g_success = 'N'
#           END IF
#        END IF
#     END IF
#     END FOR
#   END IF
#     IF g_success = 'Y' THEN
#           UPDATE rtm_file SET rtmconf = 'Y',
#                               rtmconu = g_user,
#                               rtmcond = g_today,
#                               rtm03   = g_today   #TQC-AC0322 add
#              WHERE rtm01 = g_rtm.rtm01 AND rtmplant = g_rtm.rtmplant
#           IF SQLCA.sqlcode THEN
#             CALL cl_err3("upd","rtm_file",g_rtm.rtm01,"",STATUS,"","",1) 
#             LET g_success = 'N'
#           ELSE
#              IF SQLCA.sqlerrd[3]=0 THEN
#                CALL cl_err3("upd","rtm_file",g_rtm.rtm01,"","9050","","",1) 
#                LET g_success = 'N'
#              ELSE
#                LET g_rtm.rtmconf = 'Y'
#                LET g_rtm.rtmconu = g_user
#                LET g_rtm.rtmcond = g_today
#                LET g_rtm.rtm03   = g_today   #TQC-AC0322 add
#                DISPLAY BY NAME g_rtm.rtmconf,g_rtm.rtmconu,g_rtm.rtmcond,g_rtm.rtm03 #TQC-AC0322 add rtm03
#                CALL t122_rtmconu('d')
#                CALL cl_set_field_pic(g_rtm.rtmconf,"","","","","")
#              END IF
#           END IF
#     END IF
#  IF g_success = 'Y' THEN
#     COMMIT WORK
#  ELSE
#     ROLLBACK WORK
#  END IF
#  
#END FUNCTION
#
#MOD-B20065 MARK-END----

#MOD-B20065 ADD-BEGIN---
##-確認-##
FUNCTION t122_confirm()
DEFINE ln_i    LIKE type_file.num5
DEFINE l_n     LIKE type_file.num5
DEFINE l_flag  LIKE type_file.num5
DEFINE l_fac   LIKE ima_file.ima31_fac
DEFINE l_ima25 LIKE ima_file.ima25
DEFINE l_sql   STRING
DEFINE l_date  LIKE type_file.dat

   IF cl_null(g_rtm.rtm01) THEN
        CALL cl_err('',-400,0)
        RETURN
   END IF
#CHI-C30107 ------------ add ----------- begin
   IF g_rtm.rtmacti='N' THEN
        CALL cl_err('','atm-364',0)
        RETURN
   END IF
   IF g_rtm.rtmconf = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_rtm.rtmconf='Y' THEN
        CALL cl_err('','9023',0)
        RETURN
   END IF
   IF NOT cl_confirm('axm-108') THEN
        RETURN
   END IF
   SELECT * INTO g_rtm.* FROM rtm_file WHERE rtm01 = g_rtm.rtm01
#CHI-C30107 ------------ add ----------- end
   BEGIN WORK
   LET g_success = 'Y'

   OPEN t122_cl USING g_rtm.rtm01,g_rtm.rtmplant
   IF STATUS THEN
      CALL cl_err("OPEN t122_cl:", STATUS, 1)
      CLOSE t122_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t122_cl INTO g_rtm.*
     IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      CLOSE t122_cl
      ROLLBACK WORK
      RETURN
    END IF

   IF g_rtm.rtmacti='N' THEN
        CALL cl_err('','atm-364',0)
        RETURN
   END IF
   IF g_rtm.rtmconf = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_rtm.rtmconf='Y' THEN
        CALL cl_err('','9023',0)
        RETURN
   END IF
#CHI-C30107 ----------- mark ------------- begin
#  IF NOT cl_confirm('axm-108') THEN
#       RETURN
#  END IF
#CHI-C30107 ----------- mark ------------- end
   IF g_rtm.rtm02='1' THEN
      LET l_date = g_today
   ELSE
      LET l_date = g_rtm.rtm03
   END IF
   IF g_success = 'Y' THEN
      UPDATE rtm_file SET rtmconf = 'Y',
                          rtm900 = '1',
                          rtmconu = g_user,
                          rtmcond = g_today,
                          rtm03   = l_date
       WHERE rtm01 = g_rtm.rtm01 AND rtmplant = g_rtm.rtmplant
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","rtm_file",g_rtm.rtm01,"",STATUS,"","",1)
         LET g_success = 'N'
      ELSE
         IF SQLCA.sqlerrd[3]=0 THEN
            CALL cl_err3("upd","rtm_file",g_rtm.rtm01,"","9050","","",1)
            LET g_success = 'N'
         ELSE
            LET g_rtm.rtmconf = 'Y'
            LET g_rtm.rtm900 = '1'
            LET g_rtm.rtmconu = g_user
            LET g_rtm.rtmcond = g_today
            LET g_rtm.rtm03   = l_date 
            DISPLAY BY NAME g_rtm.rtmconf,g_rtm.rtmconu,g_rtm.rtmcond,g_rtm.rtm03 #TQC-AC0322 add rtm03
            DISPLAY BY NAME g_rtm.rtm900
            CALL t122_rtmconu('d')
            CALL cl_set_field_pic(g_rtm.rtmconf,"","","","","")
         END IF
      END IF
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF

END FUNCTION
#MOD-B20065 ADD-END----

#MOD-B20065 ADD-BEGIN--
##-取消確認-##
FUNCTION t122_z()
DEFINE l_flag  LIKE type_file.num5
DEFINE l_date  LIKE type_file.dat

   IF cl_null(g_rtm.rtm01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   BEGIN WORK
   LET g_success = 'Y'

   OPEN t122_cl USING g_rtm.rtm01,g_rtm.rtmplant
   IF STATUS THEN
      CALL cl_err("OPEN t122_cl:", STATUS, 1)
      CLOSE t122_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t122_cl INTO g_rtm.*
     IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      CLOSE t122_cl
      ROLLBACK WORK
      RETURN
    END IF

   IF g_rtm.rtm900 = '2' THEN CALL cl_err('','art-123',0) RETURN END IF
   IF g_rtm.rtmconf = 'N' THEN CALL cl_err('',9025,0) RETURN END IF
   IF g_rtm.rtmconf = 'X' THEN CALL cl_err(g_rtm.rtm01,'9024',0) RETURN END IF
   IF NOT cl_confirm('aco-729') THEN
      RETURN
   END IF
   IF g_rtm.rtm02 = '1' THEN
      INITIALIZE l_date TO NULL
   ELSE
      LET l_date = g_rtm.rtm03
   END IF
   UPDATE rtm_file SET rtmconf = 'N',
                       rtm900 = '0',
                      #CHI-D20015 Mark&Add Str
                      #rtmconu = '',
                      #rtmcond = '',
                       rtmconu = g_user,
                       rtmcond = g_today,
                      #CHI-D20015 Mark&Add End
                       rtm03   = l_date
    WHERE rtm01 = g_rtm.rtm01 AND rtmplant = g_rtm.rtmplant
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","rtm_file",g_rtm.rtm01,"",STATUS,"","",1)
      LET g_success = 'N'
   ELSE
      IF SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","rtm_file",g_rtm.rtm01,"","9050","","",1)
         LET g_success = 'N'
      ELSE
         LET g_rtm.rtmconf = 'N'
         LET g_rtm.rtm900 = '0'
        #CHI-D20015 Mark&Add Str
        #LET g_rtm.rtmconu = ''
        #LET g_rtm.rtmcond = ''
         LET g_rtm.rtmconu = g_user
         LET g_rtm.rtmcond = g_today
        #CHI-D20015 Mark&Add End
         LET g_rtm.rtm03   = l_date
         DISPLAY BY NAME g_rtm.rtmconf,g_rtm.rtmconu,g_rtm.rtmcond,g_rtm.rtm03 #TQC-AC0322 add rtm03
         DISPLAY BY NAME g_rtm.rtm900
         CALL t122_rtmconu('d')
         CALL cl_set_field_pic(g_rtm.rtmconf,"","","","","")
      END IF
   END IF
#CHI-C30107 -------- add -------- begin
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
#CHI-C30107 -------- add -------- end
END FUNCTION
#MOD-B20065 ADD-END----

#MOD-B20065 ADD-GEGIN--
##-變更發出-##
FUNCTION t122_ch()
DEFINE ln_i    LIKE type_file.num5
DEFINE l_n     LIKE type_file.num5
DEFINE l_flag  LIKE type_file.num5
DEFINE l_fac   LIKE ima_file.ima31_fac
DEFINE l_ima25 LIKE ima_file.ima25
DEFINE l_sql   STRING
DEFINE l_rthpos LIKE rth_file.rthpos #FUN-B40071

   IF cl_null(g_rtm.rtm01) THEN
        CALL cl_err('',-400,0)
        RETURN
   END IF

   BEGIN WORK
   LET g_success = 'Y'

   OPEN t122_cl USING g_rtm.rtm01,g_rtm.rtmplant
   IF STATUS THEN
      CALL cl_err("OPEN t122_cl:", STATUS, 1)
      CLOSE t122_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t122_cl INTO g_rtm.*
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      CLOSE t122_cl
      ROLLBACK WORK
      RETURN
   END IF
   IF g_rtm.rtm900 = '0' THEN CALL cl_err('','art-124',0) RETURN END IF
   IF g_rtm.rtm900 = '2' THEN CALL cl_err('','art-125',0) RETURN END IF
   IF g_rtm.rtm02 = '2' AND g_rtm.rtm03 <> g_today THEN CALL cl_err('','art-126',0) RETURN END IF

   IF NOT cl_confirm('alm-207') THEN RETURN END IF
   FOR ln_i = 1 TO g_rec_b
      SELECT COUNT(*) INTO l_n FROM rth_file
       WHERE rth01 = g_rtn[ln_i].rtn03 AND rth02=g_rtn[ln_i].rtn04
         AND rthplant = g_rtm.rtmplant
      IF l_n = 0 THEN
         SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = g_rtn[ln_i].rtn03
         CALL s_umfchk('',l_ima25,g_rtn[ln_i].rtn04) RETURNING l_flag,l_fac
         #INSERT INTO rth_file (rth01,rth02,rth03,rth04,rth05,rth06,rthplant,            #FUN-C50036 mark
         INSERT INTO rth_file (rth01,rth02,rth03,rth04,rth05,rth06,rthplant,rth08,rth09, #FUN-C50036 add  
                               rthlegal,rthacti,rthpos,rthuser,rthgrup,rthcrat,rthmodu,rthdate,rthoriu,rthorig,rth07) #FUN-B40103
                        VALUES(g_rtn[ln_i].rtn03,g_rtn[ln_i].rtn04,l_fac,'','','',g_rtm.rtmplant,
                               g_rtn[ln_i].rtn18,g_today,                                #FUN-C50036 add 
                               g_rtm.rtmlegal,g_rtn[ln_i].rtn15
                               ,'1',g_user,g_grup,g_today,'','', g_user, g_grup,g_rtn[ln_i].rtn17)  #FUN-A30091    #No.FUN-980030 10/01/04  in #FUN-B40103 #FUN-B40071
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","rth_file",g_rtm.rtm01,"",STATUS,"","",1)
            LET g_success = 'N'
         END IF
      ELSE
         #FUN-B40071 --START--
         #UPDATE rth_file SET rth04 = g_rtn[ln_i].rtn11,
         #                    rth05 = g_rtn[ln_i].rtn12,
         #                    rth06 = g_rtn[ln_i].rtn13,
         #                    rth07 = g_rtn[ln_i].rtn17,  #FUN-B40103
         #                    rthacti = g_rtn[ln_i].rtn15,
         #                    rthpos = 'N'    #MOD-B30401 add
         # WHERE rth01 = g_rtn[ln_i].rtn03 AND rth02 = g_rtn[ln_i].rtn04
         SELECT rthpos INTO l_rthpos FROM rth_file
          WHERE rth01 = g_rtn[ln_i].rtn03 AND rth02 = g_rtn[ln_i].rtn04
         IF l_rthpos <> '1' THEN
            LET l_rthpos = '2'
         ELSE
            LET l_rthpos = '1'
         END IF
         UPDATE rth_file SET rth04 = g_rtn[ln_i].rtn11,
                             rth05 = g_rtn[ln_i].rtn12,
                             rth06 = g_rtn[ln_i].rtn13,
                             rth07 = g_rtn[ln_i].rtn17,  
                             rth08 = g_rtn[ln_i].rtn18,        #FUN-C50036 add
                             rth09 = g_today,                  #FUN-C50036 add 
                             rthacti = g_rtn[ln_i].rtn15,
                             rthpos = l_rthpos    
           WHERE rth01 = g_rtn[ln_i].rtn03 AND rth02 = g_rtn[ln_i].rtn04
         #FUN-B40071 --END--
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","rth_file",g_rtm.rtm01,"",STATUS,"","",1)
            LET g_success = 'N'
         ELSE
            IF SQLCA.sqlerrd[3]=0 THEN
               CALL cl_err3("upd","rth_file",g_rtm.rtm01,"","9050","","",1)
               LET g_success = 'N'
            END IF
         END IF
      END IF
   END FOR
   UPDATE rtm_file 
      SET rtm900 = '2'
    WHERE rtm01=g_rtm.rtm01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("upd","rth_file",g_rtm.rtm01,"",SQLCA.sqlcode,"","",0)
      LET g_success='N'
   END IF

   IF g_success = 'Y' THEN
      CALL cl_err('','alm-940',0)
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   SELECT * INTO g_rtm.* FROM rtm_file WHERE rtm01=g_rtm.rtm01
   DISPLAY BY NAME g_rtm.rtm900
END FUNCTION
#MOD-B20065 ADD-END----

#FUN-870007
#CHI-C80041---begin
FUNCTION t122_v()
DEFINE l_chr LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_rtm.rtm01) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t122_cl USING g_rtm.rtm01,g_rtm.rtmplant
   IF STATUS THEN
      CALL cl_err("OPEN t122_cl:", STATUS, 1)
      CLOSE t122_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t122_cl INTO g_rtm.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rtm.rtm01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t122_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_rtm.rtmconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_rtm.rtmconf)   THEN 
        LET l_chr=g_rtm.rtmconf
        IF g_rtm.rtmconf='N' THEN 
            LET g_rtm.rtmconf='X' 
        ELSE
            LET g_rtm.rtmconf='N'
        END IF
        UPDATE rtm_file
            SET rtmconf=g_rtm.rtmconf,  
                rtmmodu=g_user,
                rtmdate=g_today
            WHERE rtm01=g_rtm.rtm01
              AND rtmplant=g_rtm.rtmplant
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","rtm_file",g_rtm.rtm01,"",SQLCA.sqlcode,"","",1)  
            LET g_rtm.rtmconf=l_chr 
        END IF
        DISPLAY BY NAME g_rtm.rtmconf
   END IF
 
   CLOSE t122_cl
   COMMIT WORK
   CALL cl_flow_notify(g_rtm.rtm01,'V')
 
END FUNCTION
#CHI-C80041---end

