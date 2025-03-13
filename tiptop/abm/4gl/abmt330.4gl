# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abmt330.4gl
# Descriptions...: 
# Date & Author..: NO.FUN-930109 09/03/30 By xiaofeizhu
# Modify.........: No.FUN-940083 09/05/05 By douzh 新增pmh24(VIM管理否)
# Modify.........: No.FUN-980001 09/08/11 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.           09/10/20 By lilingyu r.c2錯誤
# Modify.........: No.TQC-A10053 10/01/07 By sherry 審核時增加控管
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0015 10/10/07 By Nicola 預設pmh25 
# Modify.........: NO.FUN-AA0059 10/10/25 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/26 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No.MOD-AC0341 10/12/27 By suncx  EasyFlow送簽確認前檢查bug調整
# Modify.........: No.FUN-B50062 11/05/16 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80100 11/08/10 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-BC0018 12/01/04 By Abby 1.增加簽核功能
#                                                 2.拿掉GPM整合相關按鈕(此作業無跟GPM整合)
# Modify.........: No.TQC-BC0176 12/01/10 By destiny 1.复制时如果不输入日期，单号不能产生2.多次复制会进入无穷循环 
# Modify.........: No.CHI-C30002 12/05/15 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C30027 12/08/20 By bart 複製後停在新料號畫面
# Modify.........: No:CHI-C80041 12/12/18 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:MOD-D10213 13/01/24 By bart 複製時，簽核欄位應重抓單別設定資料
# Modify.........: No:CHI-D20010 13/02/19 By yangtt 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_bnm         RECORD LIKE bnm_file.*,      
       g_bnm_t       RECORD LIKE bnm_file.*,       
       g_bnm_o       RECORD LIKE bnm_file.*,       
       g_bnm01_t     LIKE bnm_file.bnm01,          
       g_t1          LIKE oay_file.oayslip,              
       g_ydate       LIKE type_file.dat,          
       g_bnn         DYNAMIC ARRAY OF RECORD       
           bnn02     LIKE bnn_file.bnn02,          
           bnn03     LIKE bnn_file.bnn03,
           ima02     LIKE ima_file.ima02,
           ima021    LIKE ima_file.ima021,         
           bnn04     LIKE bnn_file.bnn04,          
           bnn05     LIKE bnn_file.bnn05,                                                                        
           bnn08     LIKE bnn_file.bnn08,                               
           bnn09     LIKE bnn_file.bnn09,
           bnn06     LIKE bnn_file.bnn06,             
           bnn10     LIKE bnn_file.bnn10,
           bnn07     LIKE bnn_file.bnn07                      
                     END RECORD,
       g_bnn_t       RECORD                    
           bnn02     LIKE bnn_file.bnn02,          
           bnn03     LIKE bnn_file.bnn03,
           ima02     LIKE ima_file.ima02,
           ima021    LIKE ima_file.ima021,                    
           bnn04     LIKE bnn_file.bnn04,          
           bnn05     LIKE bnn_file.bnn05,                                                                        
           bnn08     LIKE bnn_file.bnn08,                               
           bnn09     LIKE bnn_file.bnn09,
           bnn06     LIKE bnn_file.bnn06,             
           bnn10     LIKE bnn_file.bnn10,
           bnn07     LIKE bnn_file.bnn07           
                     END RECORD,
       g_bnn_o       RECORD                      
           bnn02     LIKE bnn_file.bnn02,          
           bnn03     LIKE bnn_file.bnn03,
           ima02     LIKE ima_file.ima02,
           ima021    LIKE ima_file.ima021,                    
           bnn04     LIKE bnn_file.bnn04,          
           bnn05     LIKE bnn_file.bnn05,                                                                        
           bnn08     LIKE bnn_file.bnn08,                               
           bnn09     LIKE bnn_file.bnn09,
           bnn06     LIKE bnn_file.bnn06,             
           bnn10     LIKE bnn_file.bnn10,
           bnn07     LIKE bnn_file.bnn07           
                     END RECORD,
       g_sql         STRING,                       
       g_wc          STRING,                       
       g_wc2         STRING,                       
       g_rec_b       LIKE type_file.num5,          
       l_ac          LIKE type_file.num5           
DEFINE g_forupd_sql        STRING                
DEFINE g_before_input_done LIKE type_file.num5    
DEFINE g_chr               LIKE type_file.chr1   
DEFINE g_cnt               LIKE type_file.num10  
DEFINE g_i                 LIKE type_file.num5   
DEFINE g_msg               LIKE ze_file.ze03      
DEFINE g_curs_index        LIKE type_file.num10  
DEFINE g_row_count         LIKE type_file.num10  
DEFINE g_jump              LIKE type_file.num10  
DEFINE g_no_ask           LIKE type_file.num5    
DEFINE g_gen02             LIKE gen_file.gen02  
DEFINE g_gem02             LIKE gem_file.gem02
DEFINE g_pmc03             LIKE pmc_file.pmc03 
DEFINE g_flag              LIKE type_file.chr1
DEFINE g_argv1             LIKE bnm_file.bnm01  #單號                    #FUN-BC0018
DEFINE g_laststage         LIKE type_file.chr1  #是否為簽核最後一站flag  #FUN-BC0018
DEFINE g_chr1,g_chr2       LIKE type_file.chr1  #VARCHAR(1)              #FUN-BC0018

MAIN
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
    
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("abm")) THEN
      EXIT PROGRAM
   END IF
 
   IF cl_null(g_aza.aza92) OR g_aza.aza92 = 'N' THEN                         
      CALL cl_err('','abm-883',1)                       
      EXIT PROGRAM                                           
    END IF   
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
  #FUN-BC0018 add str---
   LET g_argv1 = ARG_VAL(1)              #單號
   IF fgl_getenv('EASYFLOW') = "1" THEN  #判斷是否為簽核模式
      LET g_argv1 = aws_efapp_wsk(1)     #取得單號,參數:key-1
   END IF
  #FUN-BC0018 add end---
 
   LET g_forupd_sql = "SELECT * FROM bnm_file WHERE bnm01 = ? FOR UPDATE"   #091020
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t330_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW t330_w WITH FORM "abm/42f/abmt330"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_set_locale_frm_name("abmt330")    
   CALL cl_ui_init()
   
  #FUN-BC0018 add str---
   CALL aws_efapp_toolbar()    #建立簽核模式時的toolbar icon
   CALL aws_efapp_flowaction("insert, modify, delete, reproduce, invalid, detail, query, locale, void, undo_void,confirm, undo_confirm, easyflow_approval")  #CHI-D20010 add undo_void
        RETURNING g_laststage  #傳入簽核模式時不應執行的action清單

   IF NOT cl_null(g_argv1) THEN
      CALL t330_q()
   END IF
  #FUN-BC0018 add end---
   
   CALL t330_menu()
   CLOSE WINDOW t330_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t330_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
   CLEAR FORM 
   CALL g_bnn.clear()
    
  #FUN-BC0018 add str---
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = " bnm01 = '",g_argv1,"'"
      LET g_wc2 = " 1=1"
   ELSE
  #FUN-BC0018 add end---
     #CONSTRUCT BY NAME g_wc ON bnm01,bnm02,bnm03,bnm04,bnm05,bnm06,bnm07,          #FUN-BC0018 mark
      CONSTRUCT BY NAME g_wc ON bnm01,bnm02,bnm03,bnm04,bnm05,bnm06,bnm08,bnmmksg,  #FUN-BC0018 add  
                             bnmuser,bnmgrup,bnmmodu,bnmdate,bnmacti
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(bnm01) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_bnm01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO bnm01                
                  NEXT FIELD bnm01
                  
               WHEN INFIELD(bnm03) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_gen"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO bnm03
                  NEXT FIELD bnm03                  
      
               WHEN INFIELD(bnm04) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_gem"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO bnm04
                  NEXT FIELD bnm04
      
               WHEN INFIELD(bnm05)   
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_pmc2"                  
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO bnm05
                  NEXT FIELD bnm05
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
      
         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
      END CONSTRUCT
      
      IF INT_FLAG THEN
         RETURN
      END IF
   
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND bnmuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND bnmgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    
   #      LET g_wc = g_wc clipped," AND bnmgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bnmuser', 'bnmgrup')
   #End:FUN-980030
 
   CONSTRUCT g_wc2 ON bnn02,bnn03,bnn04,   
                      bnn05,bnn06,bnn07,
                      bnn08,bnn09,bnn10  
             FROM s_bnn[1].bnn02,s_bnn[1].bnn03,s_bnn[1].bnn04,
                  s_bnn[1].bnn05,s_bnn[1].bnn06,s_bnn[1].bnn07,
                  s_bnn[1].bnn08,s_bnn[1].bnn09,s_bnn[1].bnn10
 
      BEFORE CONSTRUCT
        CALL cl_qbe_display_condition(lc_qbe_sn)
   
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(bnn03) 
#FUN-AA0059 --Begin--
            #  CALL cl_init_qry_var()
            #  LET g_qryparam.state = 'c'
            #  LET g_qryparam.form ="q_ima08"   
            #  CALL cl_create_qry() RETURNING g_qryparam.multiret
              CALL q_sel_ima( TRUE, "q_ima08","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End-- 
              DISPLAY g_qryparam.multiret TO bnn03
              NEXT FIELD bnn03
            WHEN INFIELD(bnn04)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_mse"
              LET g_qryparam.state = 'c'
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO bnn04
              NEXT FIELD bnn04             
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
   END IF  #FUN-BC0018   
 
   IF g_wc2 = " 1=1" THEN                  
      LET g_sql = "SELECT bnm01 FROM bnm_file ",        #091020
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY bnm01"
   ELSE                             
      LET g_sql = "SELECT bnm01 ",                        #091020
                  "  FROM bnm_file, bnn_file ",
                  " WHERE bnm01 = bnn01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY bnm01"
   END IF
 
   PREPARE t330_prepare FROM g_sql
   DECLARE t330_cs                         
       SCROLL CURSOR WITH HOLD FOR t330_prepare
 
   IF g_wc2 = " 1=1" THEN                  
      LET g_sql="SELECT COUNT(*) FROM bnm_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT bnm01) FROM bnm_file,bnn_file WHERE ",
                "bnn01=bnm01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
 
   PREPARE t330_precount FROM g_sql
   DECLARE t330_count CURSOR FOR t330_precount
 
END FUNCTION
 
FUNCTION t330_menu() 
DEFINE l_creator  LIKE type_file.chr1  #是否退回填表人      #FUN-BC0018
DEFINE l_flowuser LIKE type_file.chr1  #是否有指定加簽人員  #FUN-BC0018

   LET l_flowuser = "N"  #FUN-BC0018
 
   WHILE TRUE
      CALL t330_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t330_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t330_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t330_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t330_u()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t330_x()
            END IF
 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t330_copy()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t330_b()
            ELSE
               LET g_action_choice = NULL
            END IF
            
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
            
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
              #FUN-BC0018 mod str---
              #CALL t330_confirm()
               CALL t330_y_chk()          #CALL 原確認的 check 段
               IF g_success = "Y" THEN
                  CALL t330_y_upd()       #CALL 原確認的 update 段
               END IF
              #FUN-BC0018 mod end---
              #CALL cl_set_field_pic(g_bnm.bnm07,"","","","",g_bnm.bnmacti)  #FUN-BC0018 mark
               CALL t330_show_pic() #圖示  #FUN-BC0018 add
            END IF
 
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t330_unconfirm()
              #CALL cl_set_field_pic(g_bnm.bnm07,"","","","",g_bnm.bnmacti)  #FUN-BC0018 mark
               CALL t330_show_pic() #圖示  #FUN-BC0018 add
            END IF
            
       #FUN-BC0018 add str---
        WHEN "agree"                                       #執行EF簽核,"准"功能
           IF g_laststage = "Y" AND l_flowuser = "N" THEN  #最後一關並且沒有加簽人員
              CALL t330_y_upd()                            #CALL 原確認的 update 段
           ELSE
              LET g_success = "Y"
              IF NOT aws_efapp_formapproval() THEN       #執行EF簽核       
                 LET g_success = "N"
              END IF
           END IF
           IF g_success = 'Y' THEN
              IF cl_confirm('aws-081') THEN              #詢問是否繼續下一筆資料的簽核
                 IF aws_efapp_getnextforminfo() THEN     #取得下一筆簽核單號
                    LET l_flowuser = 'N'
                    LET g_argv1 = aws_efapp_wsk(1)       #取得單號
                    IF NOT cl_null(g_argv1) THEN         #自動query帶出資料
                       CALL t330_q()
                       #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                       CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void, confirm, undo_confirm, easyflow_approval")  #CHI-D20010 add undo_void
                            RETURNING g_laststage
                    ELSE
                       EXIT WHILE
                    END IF
                 ELSE
                    EXIT WHILE
                 END IF
              ELSE
                 EXIT WHILE
              END IF
           END IF

        WHEN "deny"                                                 #執行EF簽核,"不准"功能
           IF (l_creator := aws_efapp_backflow()) IS NOT NULL THEN  #退回關卡
              IF aws_efapp_formapproval() THEN                      #執行EF簽核
                 IF l_creator = "Y" THEN                            #當退回填表人時
                    LET g_bnm.bnm08 = 'R'                           #顯示狀態碼為'R' 送簽退回
                    DISPLAY BY NAME g_bnm.bnm08
                 END IF
                 IF cl_confirm('aws-081') THEN                      #詢問是否繼續下一筆資料的簽核
                    IF aws_efapp_getnextforminfo() THEN             #取得下一筆簽核單號
                       LET l_flowuser = 'N'
                       LET g_argv1 = aws_efapp_wsk(1)               #取得單號
                       IF NOT cl_null(g_argv1) THEN                 #自動query帶出資料
                          CALL t330_q()
                          #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                          CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void, confirm, undo_confirm, easyflow_approval")  #CHI-D20010 add undo_void
                               RETURNING g_laststage
                       ELSE
                          EXIT WHILE
                       END IF
                    ELSE
                       EXIT WHILE
                    END IF
                 ELSE
                    EXIT WHILE
                 END IF
              END IF
            END IF

        WHEN "modify_flow"                #執行EF簽核,"加簽"功能
           IF aws_efapp_flowuser() THEN   #選擇欲加簽人員
              LET l_flowuser = 'Y'
           ELSE
              LET l_flowuser = 'N'
           END IF

        WHEN "withdraw"                   #執行EF簽核,"撤簽"功能
           IF cl_confirm("aws-080") THEN
              IF aws_efapp_formapproval() THEN
                 EXIT WHILE
              END IF
           END IF

        WHEN "org_withdraw"               #執行EF簽核,"抽單"功能
           IF cl_confirm("aws-079") THEN
              IF aws_efapp_formapproval() THEN
                 EXIT WHILE
              END IF
           END IF

        WHEN "phrase"                     #執行EF簽核,"簽核意見"功能
           CALL aws_efapp_phrase()

        WHEN "approval_status"            #執行EF簽核,"簽核狀況"功能
           IF cl_chk_act_auth() THEN     
              IF aws_condition2() THEN
                 CALL aws_efstat2()             
              END IF
           END IF
       #FUN-BC0018 add end---

        WHEN "easyflow_approval"          #執行EF簽核,"EasyFlow送簽"功能
           IF cl_chk_act_auth() THEN
                CALL t330_ef()
           END IF                        
 
         WHEN "exporttoexcel"     
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bnn),'','')
            END IF
 
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_bnm.bnm01 IS NOT NULL THEN
                 LET g_doc.column1 = "bnm01"
                 LET g_doc.value1 = g_bnm.bnm01
                 CALL cl_doc()
               END IF
         END IF
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t330_v()    #CHI-D20010
               CALL t330_v(1)   #CHI-D20010
               CALL t330_show_pic() 
            END IF
         #CHI-C80041---end
         #CHI-D20010---begin
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
             # CALL t330_v()    #CHI-D20010
               CALL t330_v(2)   #CHI-D20010
               CALL t330_show_pic()
            END IF
         #CHI-D20010---end
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t330_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bnn TO s_bnn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
 
      ON ACTION first
         CALL t330_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION previous
         CALL t330_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
      ON ACTION jump
         CALL t330_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION next
         CALL t330_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION last
         CALL t330_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
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
         
      ON ACTION easyflow_approval           
        LET g_action_choice = "easyflow_approval"
        EXIT DISPLAY
 
      ON ACTION confirm     
         LET g_action_choice="confirm"
         EXIT DISPLAY
 
      ON ACTION undo_confirm     
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY         
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end 
      #CHI-D20010---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #CHI-D20010---end
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
 
      ON ACTION controls                                       
         CALL cl_set_head_visible("","AUTO")       
 
      ON ACTION related_document                #相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
     #FUN-BC0018 add str---
      ON ACTION agree
         LET g_action_choice = 'agree'
         EXIT DISPLAY
         
      ON ACTION deny
         LET g_action_choice = 'deny'
         EXIT DISPLAY

      ON ACTION modify_flow
         LET g_action_choice = 'modify_flow'
         EXIT DISPLAY

      ON ACTION withdraw
         LET g_action_choice = 'withdraw'
         EXIT DISPLAY

      ON ACTION org_withdraw
         LET g_action_choice = 'org_withdraw'
         EXIT DISPLAY

      ON ACTION phrase
         LET g_action_choice = 'phrase'
         EXIT DISPLAY

      ON ACTION approval_status           
        LET g_action_choice = "approval_status"
        EXIT DISPLAY
     #FUN-BC0018 add end---

     #FUN-BC0018 mark str--- 
     #ON ACTION gpm_show
     #   LET g_action_choice="gpm_show"
     #   EXIT DISPLAY
     #   
     #ON ACTION gpm_query
     #   LET g_action_choice="gpm_query"
     #   EXIT DISPLAY
     #FUN-BC0018 mark end--- 
 
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t330_bp_refresh()
  DISPLAY ARRAY g_bnn TO s_bnn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
 
END FUNCTION
 
FUNCTION t330_a()
   DEFINE li_result   LIKE type_file.num5   
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10  
 
   MESSAGE ""
   CLEAR FORM
   CALL g_bnn.clear()
   LET g_wc = NULL
   LET g_wc2= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_bnm.* LIKE bnm_file.*             #DEFAULT 設定
   LET g_bnm01_t = NULL
   LET g_bnm.bnm02 = g_today
   LET g_bnm.bnm03 = g_user
   LET g_bnm.bnm06 = '0'
   LET g_bnm.bnm07 = 'N'
   LET g_bnm.bnm08 = '0'    #FUN-BC0018 add
   LET g_bnm.bnmmksg = 'N'  #FUN-BC0018 add
   LET g_gen02 = NULL
   LET g_gem02 = NULL
   LET g_pmc03 = NULL
   SELECT gen02,gen03 INTO g_gen02,g_bnm.bnm04 FROM gen_file
    WHERE gen01 = g_user
   SELECT gem02 INTO g_gem02 FROM gem_file
    WHERE gem01 = g_bnm.bnm04   
 
   #預設值及將數值類變數清成零
   LET g_bnm_t.* = g_bnm.*
   LET g_bnm_o.* = g_bnm.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_bnm.bnmuser=g_user
      LET g_bnm.bnmoriu = g_user #FUN-980030
      LET g_bnm.bnmorig = g_grup #FUN-980030
      LET g_data_plant = g_plant #FUN-980030
      LET g_bnm.bnmgrup=g_grup
      LET g_bnm.bnmdate=g_today
      LET g_bnm.bnmacti='Y'              #資料有效
      #FUN-980001 add plant & legal 
      LET g_bnm.bnmplant = g_plant
      LET g_bnm.bnmlegal = g_legal 
      #FUN-980001 end plant & legal 
 
      CALL t330_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_bnm.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_bnm.bnm01) THEN       # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      #輸入後, 若該單據需自動編號, 並且其單號為空白, 則自動賦予單號
      BEGIN WORK
      CALL s_auto_assign_no("abm",g_bnm.bnm01,g_bnm.bnm02,"","bnm_file","bnm01","","","") RETURNING li_result,g_bnm.bnm01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_bnm.bnm01
 
      INSERT INTO bnm_file VALUES (g_bnm.*)
 
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
         CALL cl_err3("ins","bnm_file",g_bnm.bnm01,"",SQLCA.sqlcode,"","",1)  #No.FUN-B80100---上移一行調整至回滾事務前--- 
         ROLLBACK WORK     
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_bnm.bnm01,'I')
      END IF
 
      LET g_bnm01_t = g_bnm.bnm01 
      LET g_bnm_t.* = g_bnm.*
      LET g_bnm_o.* = g_bnm.*
      CALL g_bnn.clear()
 
      LET g_rec_b = 0
      CALL t330_b()                   #輸入單身
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t330_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_bnm.bnm01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
  #FUN-BC0018 mod str--- 
  #IF g_bnm.bnm07 = 'Y' THEN                                                                                                      
  #   CALL cl_err('','abm-880',0)                                                                                                        
  #   RETURN                                                                                                                        
  #END IF
   IF g_bnm.bnm08 = '9' THEN RETURN END IF  #CHI-C80041
   IF g_bnm.bnm08 matches '[Ss1]' THEN     
      CALL cl_err("","mfg3557",1)
      LET g_success='N'
      RETURN                                                                                                                        
   END IF
  #FUN-BC0018 mod end--- 

 
   SELECT * INTO g_bnm.* FROM bnm_file
    WHERE bnm01=g_bnm.bnm01
 
   IF g_bnm.bnmacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_bnm.bnm01,'mfg1000',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_bnm01_t = g_bnm.bnm01
   BEGIN WORK
 
#  OPEN t330_cl USING g_bnm_rowi    #091020
   OPEN t330_cl USING g_bnm.bnm01    #091020
   IF STATUS THEN
      CALL cl_err("OPEN t330_cl:", STATUS, 1)
      CLOSE t330_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t330_cl INTO g_bnm.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_bnm.bnm01,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE t330_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t330_show()
 
   WHILE TRUE
      LET g_bnm01_t = g_bnm.bnm01
      LET g_bnm_o.* = g_bnm.*
      LET g_bnm.bnmmodu=g_user
      LET g_bnm.bnmdate=g_today
 
      CALL t330_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_bnm.*=g_bnm_t.*
         CALL t330_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_bnm.bnm01 != g_bnm01_t THEN            # 更改單號
         UPDATE bnn_file SET bnn01 = g_bnm.bnm01
          WHERE bnn01 = g_bnm01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","bnn_file",g_bnm01_t,"",SQLCA.sqlcode,"","bnn",1)
            CONTINUE WHILE
         END IF
      END IF
 
      LET g_bnm.bnm08 = '0'  #FUN-BC0018   
      DISPLAY BY NAME g_bnm.bnm08  #FUN-BC0018

      UPDATE bnm_file SET bnm_file.* = g_bnm.*
       WHERE bnm01 = g_bnm01_t      #091020 
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","bnm_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t330_cl
   COMMIT WORK
   CALL cl_flow_notify(g_bnm.bnm01,'U')
 
   CALL t330_b_fill("1=1")
   CALL t330_bp_refresh()
 
END FUNCTION
 
FUNCTION t330_i(p_cmd)
DEFINE
   l_n       LIKE type_file.num5,    
   p_cmd     LIKE type_file.chr1    
   DEFINE    li_result   LIKE type_file.num5
   DEFINE    l_sql       STRING
   DEFINE    l_bnm06     LIKE bnm_file.bnm06
   DEFINE    l_cnt       LIKE type_file.num5      
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_bnm.bnmuser,g_bnm.bnmmodu,
       g_bnm.bnmgrup,g_bnm.bnmdate,g_bnm.bnmacti
   IF p_cmd = 'a' THEN    
      DISPLAY g_gen02 TO gen02
      DISPLAY g_gem02 TO gem02       
   END IF
   CALL cl_set_head_visible("","YES")         
   INPUT BY NAME g_bnm.bnm01,g_bnm.bnm02,g_bnm.bnm03,g_bnm.bnm04,              g_bnm.bnmoriu,g_bnm.bnmorig,
                #g_bnm.bnm05,g_bnm.bnm06,g_bnm.bnm07                #FUN-BC0018 mark     
                 g_bnm.bnm05,g_bnm.bnm06,g_bnm.bnm08,g_bnm.bnmmksg  #FUN-BC0018 add       
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t330_set_entry(p_cmd)
         CALL t330_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("bnm01")
 
      AFTER FIELD bnm01
         IF NOT cl_null(g_bnm.bnm01) THEN
            CALL s_check_no("abm",g_bnm.bnm01,g_bnm01_t,"5","bnm_file","bnm01","") RETURNING li_result,g_bnm.bnm01
            DISPLAY BY NAME g_bnm.bnm01
            IF (NOT li_result) THEN
               LET g_bnm.bnm01=g_bnm_o.bnm01
               NEXT FIELD bnm01
            END IF
           #FUN-BC0018 add str---
            LET g_bnm.bnmmksg = g_smy.smyapr
            DISPLAY BY NAME g_bnm.bnmmksg
           #FUN-BC0018 add end---
            DISPLAY g_smy.smydesc TO smydesc
         END IF
 
      AFTER FIELD bnm03                
         IF NOT cl_null(g_bnm.bnm03) THEN
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt 
              FROM gen_file
             WHERE gen01 = g_bnm.bnm03
               AND genacti ='Y'
            IF l_cnt <= 0 THEN
               CALL cl_err('','aap-038',0)
               NEXT FIELD bnm03
            END IF     
            LET g_gen02 = NULL
            SELECT gen02,gen03 INTO g_gen02,g_bnm.bnm04 FROM gen_file
             WHERE gen01 = g_bnm.bnm03
            DISPLAY g_gen02 TO gen02
            DISPLAY g_bnm.bnm04 TO bnm04
         END IF
 
      AFTER FIELD bnm04                
         IF NOT cl_null(g_bnm.bnm04) THEN
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt 
              FROM gem_file
             WHERE gem01 = g_bnm.bnm04
               AND gemacti ='Y'
            IF l_cnt <= 0 THEN
               CALL cl_err('','aap-039',0)
               NEXT FIELD bnm04
            END IF         
            LET g_gem02 = NULL
            SELECT gem02 INTO g_gem02 FROM gem_file
             WHERE gem01 = g_bnm.bnm04
            DISPLAY g_gem02 TO gem02  
         END IF
 
      AFTER FIELD bnm05               
         IF NOT cl_null(g_bnm.bnm05) THEN
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt 
              FROM pmc_file
             WHERE pmc01 = g_bnm.bnm05
               AND pmcacti ='Y'
            IF l_cnt <= 0 THEN
               CALL cl_err('','aap-000',0)
               NEXT FIELD bnm05
            END IF         
            LET g_pmc03 = NULL
            SELECT pmc03 INTO g_pmc03 FROM pmc_file
             WHERE pmc01 = g_bnm.bnm05
            DISPLAY g_pmc03 TO pmc03
         END IF                       
         
      AFTER FIELD bnm06
         IF cl_null(g_bnm.bnm06) THEN
            CALL cl_err('','aim-927',0)
            NEXT FIELD bnm06
         END IF                                                                                                                  
         IF NOT cl_null(g_bnm.bnm06) THEN                                                                                  
            IF g_bnm.bnm06 NOT MATCHES'[01234]' THEN                                                                         
               NEXT FIELD bnm06                                                                                                 
            END IF                                                                                                              
         END IF
         
     #FUN-BC0018 mark str---    
     #AFTER FIELD bnm07                                                                                                             
     #   IF NOT cl_null(g_bnm.bnm07) THEN                                                                                  
     #      IF g_bnm.bnm07 NOT MATCHES'[YN]' THEN                                                                         
     #         NEXT FIELD bnm07                                                                                                 
     #      END IF                                                                                                              
     #   END IF                  
     #FUN-BC0018 mark end---    
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(bnm01) 
                 LET g_t1=s_get_doc_no(g_bnm.bnm01)     
                 CALL q_smy(FALSE,FALSE,g_t1,'abm','5') RETURNING g_t1 
                 LET g_bnm.bnm01 = g_t1                 
                 DISPLAY BY NAME g_bnm.bnm01
                 CALL t330_bnm01('d')
                 NEXT FIELD bnm01
                 
            WHEN INFIELD(bnm03) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gen"
               LET g_qryparam.default1 = g_bnm.bnm03
               CALL cl_create_qry() RETURNING g_bnm.bnm03
               DISPLAY BY NAME g_bnm.bnm03
               CALL t330_bnm03('d')
               NEXT FIELD bnm03                 
 
            WHEN INFIELD(bnm04) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gem"
               LET g_qryparam.default1 = g_bnm.bnm04
               CALL cl_create_qry() RETURNING g_bnm.bnm04
               DISPLAY BY NAME g_bnm.bnm04
               CALL t330_bnm04('d')
               NEXT FIELD bnm04
 
            WHEN INFIELD(bnm05) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_pmc2"
               LET g_qryparam.default1 = g_bnm.bnm05
               CALL cl_create_qry() RETURNING g_bnm.bnm05
               DISPLAY BY NAME g_bnm.bnm05
               CALL t330_bnm05('d')
               NEXT FIELD bnm05
 
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
 
FUNCTION t330_bnm01(p_cmd)
   DEFINE l_smydesc LIKE smy_file.smydesc,
          l_smyacti LIKE smy_file.smyacti,
          l_t1      LIKE oay_file.oayslip, 
          p_cmd     LIKE type_file.chr1   
 
   LET g_errno = ' '
   LET l_t1 = s_get_doc_no(g_bnm.bnm01)
   IF g_bnm.bnm01 IS NULL THEN
      LET g_errno = 'E'
      LET l_smydesc=NULL
   ELSE
      SELECT smydesc,smyacti
        INTO l_smydesc,l_smyacti
        FROM smy_file WHERE smyslip = l_t1
      IF SQLCA.sqlcode THEN
         LET g_errno = 'E'
         LET l_smydesc = NULL
      ELSE
         IF l_smyacti matches'[nN]' THEN
            LET g_errno = 'E'
         END IF
      END IF
   END IF
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_smydesc TO FORMONLY.smydesc
   END IF
 
END FUNCTION
 
FUNCTION t330_bnm03(p_cmd)
   DEFINE l_gen02   LIKE gen_file.gen02,
          p_cmd     LIKE type_file.chr1
 
   LET g_errno = ' '
   SELECT gen02 INTO l_gen02 FROM gen_file
    WHERE gen01 = g_bnm.bnm03
 
   IF SQLCA.SQLCODE = 100  THEN
      LET g_errno = 'mfg3008'
      LET l_gen02 = NULL
   END IF   
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gen02 TO gen02
   END IF
 
END FUNCTION
 
FUNCTION t330_bnm04(p_cmd)  
   DEFINE l_gem02   LIKE gem_file.gem02,
          p_cmd     LIKE type_file.chr1
 
   LET g_errno = ' '
   SELECT gem02 INTO l_gem02 FROM gem_file
    WHERE gem01 = g_bnm.bnm04
 
   IF SQLCA.SQLCODE = 100  THEN
      LET g_errno = 'mfg3008'
      LET l_gem02 = NULL
   END IF
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gem02 TO gem02
   END IF
 
END FUNCTION
 
FUNCTION t330_bnm05(p_cmd)
   DEFINE l_pmc03   LIKE pmc_file.pmc03,
          p_cmd     LIKE type_file.chr1
 
   LET g_errno = ' '
   SELECT pmc03 INTO l_pmc03 FROM pmc_file
    WHERE pmc01 = g_bnm.bnm05
 
   IF SQLCA.SQLCODE = 100  THEN
      LET g_errno = 'mfg3008'
      LET l_pmc03 = NULL
   END IF
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_pmc03 TO pmc03
   END IF
 
END FUNCTION
 
FUNCTION t330_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_bnn.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t330_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_bnm.* TO NULL
      RETURN
   END IF
 
   OPEN t330_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_bnm.* TO NULL
   ELSE
      OPEN t330_count
      FETCH t330_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL t330_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION t330_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1            
 
   CASE p_flag
#     WHEN 'N' FETCH NEXT     t330_cs INTO g_bnm_rowi,g_bnm.bnm01   #091020
#     WHEN 'P' FETCH PREVIOUS t330_cs INTO g_bnm_rowi,g_bnm.bnm01   #091020
#     WHEN 'F' FETCH FIRST    t330_cs INTO g_bnm_rowi,g_bnm.bnm01   #091020
#     WHEN 'L' FETCH LAST     t330_cs INTO g_bnm_rowi,g_bnm.bnm01   #091020
      WHEN 'N' FETCH NEXT     t330_cs INTO g_bnm.bnm01               #091020
      WHEN 'P' FETCH PREVIOUS t330_cs INTO g_bnm.bnm01               #091020
      WHEN 'F' FETCH FIRST    t330_cs INTO g_bnm.bnm01               #091020
      WHEN 'L' FETCH LAST     t330_cs INTO g_bnm.bnm01               #091020
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
#           FETCH ABSOLUTE g_jump t330_cs INTO g_bnm_rowi,g_bnm.bnm01        #091020
            FETCH ABSOLUTE g_jump t330_cs INTO g_bnm.bnm01                    #091020
            LET g_no_ask = FALSE   
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bnm.bnm01,SQLCA.sqlcode,0)
      INITIALIZE g_bnm.* TO NULL             
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
      DISPLAY g_curs_index TO FORMONLY.idx                    
   END IF
 
   SELECT * INTO g_bnm.* FROM bnm_file WHERE bnm01 = g_bnm.bnm01  #091020
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","bnm_file","","",SQLCA.sqlcode,"","",1) 
      INITIALIZE g_bnm.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_bnm.bnmuser      
   LET g_data_group = g_bnm.bnmgrup    
   LET g_data_plant = g_bnm.bnmplant #FUN-980030
 
   CALL t330_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t330_show()
 
   LET g_bnm_t.* = g_bnm.*                #保存單頭舊值
   LET g_bnm_o.* = g_bnm.*                #保存單頭舊值
   DISPLAY BY NAME g_bnm.bnm01,g_bnm.bnm02,g_bnm.bnm03, g_bnm.bnmoriu,g_bnm.bnmorig,
                  #g_bnm.bnm04,g_bnm.bnm05,g_bnm.bnm06,g_bnm.bnm07,                #FUN-BC0018 mark
                   g_bnm.bnm04,g_bnm.bnm05,g_bnm.bnm06,g_bnm.bnm08,g_bnm.bnmmksg,  #FUN-BC0018 add           
                   g_bnm.bnmuser,g_bnm.bnmgrup,g_bnm.bnmmodu,
                   g_bnm.bnmdate,g_bnm.bnmacti
                   
   CALL t330_bnm01('d')
   CALL t330_bnm03('d')
   CALL t330_bnm04('d')
   CALL t330_bnm05('d')                    
 
   CALL t330_b_fill(g_wc2)                 #單身
  #CALL cl_set_field_pic(g_bnm.bnm07,"","","","",g_bnm.bnmacti)  #FUN-BC0018 mark
   CALL t330_show_pic() #圖示  #FUN-BC0018 add
   CALL cl_show_fld_cont()              
END FUNCTION
 
FUNCTION t330_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_bnm.bnm01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
  #FUN-BC0018 mod str---
  #IF g_bnm.bnm07 = 'Y' THEN
  #   CALL cl_err('','abm-887',0)
  #   RETURN
  #END IF   
   IF g_bnm.bnm08 matches '[Ss1]' THEN 
      CALL cl_err("","mfg3557",1)  
      LET g_success='N' RETURN
   END IF   
  #FUN-BC0018 mod end---
   BEGIN WORK
 
#  OPEN t330_cl USING g_bnm_rowi   #091020
   OPEN t330_cl USING g_bnm.bnm01   #091020
   IF STATUS THEN
      CALL cl_err("OPEN t330_cl:", STATUS, 1)
      CLOSE t330_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t330_cl INTO g_bnm.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bnm.bnm01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t330_show()
 
   IF cl_exp(0,0,g_bnm.bnmacti) THEN                   #確認一下
      LET g_chr=g_bnm.bnmacti
      IF g_bnm.bnmacti='Y' THEN
         LET g_bnm.bnmacti='N'
      ELSE
         LET g_bnm.bnmacti='Y'
      END IF
 
      UPDATE bnm_file SET bnmacti=g_bnm.bnmacti,
                          bnmmodu=g_user,
                          bnmdate=g_today
       WHERE bnm01=g_bnm.bnm01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","bnm_file",g_bnm.bnm01,"",SQLCA.sqlcode,"","",1)  
         LET g_bnm.bnmacti=g_chr
      END IF
   END IF
 
   CLOSE t330_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_bnm.bnm01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT bnmacti,bnmmodu,bnmdate
     INTO g_bnm.bnmacti,g_bnm.bnmmodu,g_bnm.bnmdate FROM bnm_file
    WHERE bnm01=g_bnm.bnm01
   DISPLAY BY NAME g_bnm.bnmacti,g_bnm.bnmmodu,g_bnm.bnmdate
 
END FUNCTION
 
FUNCTION t330_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_bnm.bnm01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   
  #FUN-BC0018 mod str--- 
  #IF g_bnm.bnm07 = 'Y'  THEN
  #   CALL cl_err("",'abm-881',0)
  #   RETURN
  #END IF   
   IF g_bnm.bnm08 matches '[Ss1]' THEN 
      CALL cl_err("","mfg3557",1)  
      LET g_success='N' 
      RETURN
   END IF   
  #FUN-BC0018 mod end--- 
 
   SELECT * INTO g_bnm.* FROM bnm_file
    WHERE bnm01=g_bnm.bnm01
 
   BEGIN WORK
 
 # OPEN t330_cl USING g_bnm_rowi  #091020
   OPEN t330_cl USING g_bnm.bnm01  #091020
   IF STATUS THEN
      CALL cl_err("OPEN t330_cl:", STATUS, 1)
      CLOSE t330_cl
      ROLLBACK WORK
  
      RETURN
   END IF
 
   FETCH t330_cl INTO g_bnm.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bnm.bnm01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t330_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "bnm01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_bnm.bnm01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM bnm_file WHERE bnm01 = g_bnm.bnm01
      DELETE FROM bnn_file WHERE bnn01 = g_bnm.bnm01
      CLEAR FORM
      CALL g_bnn.clear()
      OPEN t330_count
      #FUN-B50062-add-start--
      IF STATUS THEN
         CLOSE t330_cs  
         CLOSE t330_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      FETCH t330_count INTO g_row_count
      #FUN-B50062-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t330_cs  
         CLOSE t330_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t330_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t330_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE   
         CALL t330_fetch('/')
      END IF
   END IF
 
   CLOSE t330_cl
   COMMIT WORK
   CALL cl_flow_notify(g_bnm.bnm01,'D')
END FUNCTION
 
#單身
FUNCTION t330_b()
DEFINE
    l_ac_t          LIKE type_file.num5,              
    l_n             LIKE type_file.num5,            
    l_n1            LIKE type_file.num5,               
    l_n2            LIKE type_file.num5,               
    l_n3            LIKE type_file.num5,               
    l_cnt           LIKE type_file.num5,               
    l_lock_sw       LIKE type_file.chr1,             
    p_cmd           LIKE type_file.chr1,                            
    l_allow_insert  LIKE type_file.num5,               
    l_allow_delete  LIKE type_file.num5   
 
DEFINE  l_s      LIKE type_file.chr1000 
DEFINE  l_m      LIKE type_file.chr1000 
DEFINE  i        LIKE type_file.num5
DEFINE  l_s1     LIKE type_file.chr1000 
DEFINE  l_m1     LIKE type_file.chr1000
DEFINE l_ima926  LIKE ima_file.ima926  
DEFINE l_count   LIKE type_file.num5
DEFINE l_sql     STRING
DEFINE l_bnm06   LIKE bnm_file.bnm06
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_bnm.bnm01 IS NULL THEN
       RETURN
    END IF
 
   #FUN-BC0018 mod str---
   #IF g_bnm.bnm07 = 'Y' THEN
   #   CALL cl_err('','abm-879',0)
   #   RETURN
   #END IF    
    IF g_bnm.bnm08 ='9' THEN RETURN END IF  #CHI-C80041
    IF g_bnm.bnm08 matches '[Ss1]' THEN     
       CALL cl_err("","mfg3557",1) 
       LET g_success='N' 
       RETURN
    END IF    
   #FUN-BC0018 mod end---

 
    SELECT * INTO g_bnm.* FROM bnm_file
     WHERE bnm01=g_bnm.bnm01
 
    IF g_bnm.bnmacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_bnm.bnm01,'mfg1000',0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT bnn02,bnn03,'','',bnn04,'',bnn08,bnn09,bnn06,bnn10,bnn07",
                       "  FROM bnn_file",
                       " WHERE bnn01=? AND bnn02=? FOR UPDATE" 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t330_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_bnn WITHOUT DEFAULTS FROM s_bnn.*
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
           CALL t330_set_entry_b()
           CALL t330_set_no_entry_b()
 
           BEGIN WORK
 
#          OPEN t330_cl USING g_bnm_rowi   #091020
           OPEN t330_cl USING g_bnm.bnm01   #091020
           IF STATUS THEN
              CALL cl_err("OPEN t330_cl:", STATUS, 1)
              CLOSE t330_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t330_cl INTO g_bnm.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_bnm.bnm01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE t330_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_bnn_t.* = g_bnn[l_ac].*  #BACKUP
              LET g_bnn_o.* = g_bnn[l_ac].*  #BACKUP
              OPEN t330_bcl USING g_bnm.bnm01,g_bnn_t.bnn02
              IF STATUS THEN
                 CALL cl_err("OPEN t330_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t330_bcl INTO g_bnn[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_bnn_t.bnn02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL t330_bnn03('d')                 
              CALL cl_show_fld_cont()     
              END IF
           END IF 
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_bnn[l_ac].* TO NULL        
           LET g_bnn_t.* = g_bnn[l_ac].*        
           LET g_bnn_o.* = g_bnn[l_ac].*        
           CALL cl_show_fld_cont()         
           NEXT FIELD bnn02
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO bnn_file(bnn01,bnn02,bnn03,bnn04,bnn05,bnn06,bnn07,bnn08,bnn09,bnn10,
                                bnnplant,bnnlegal)  #FUN-980001 add plant & legal 
           VALUES(g_bnm.bnm01,g_bnn[l_ac].bnn02,
                  g_bnn[l_ac].bnn03,g_bnn[l_ac].bnn04,
                  g_bnn[l_ac].bnn05,g_bnn[l_ac].bnn06,
                  g_bnn[l_ac].bnn07,g_bnn[l_ac].bnn08,
                  g_bnn[l_ac].bnn09,g_bnn[l_ac].bnn10,
                  g_plant,g_legal) #FUN-980001 add plant & legal 
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","bnn_file",g_bnm.bnm01,g_bnn[l_ac].bnn02,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        BEFORE FIELD bnn02                       
           IF g_bnn[l_ac].bnn02 IS NULL OR g_bnn[l_ac].bnn02 = 0 THEN
              SELECT max(bnn02)+1
                INTO g_bnn[l_ac].bnn02
                FROM bnn_file
               WHERE bnn01 = g_bnm.bnm01
              IF g_bnn[l_ac].bnn02 IS NULL THEN
                 LET g_bnn[l_ac].bnn02 = 1
              END IF
           END IF
 
        AFTER FIELD bnn02                        #check 序號是否重複
           IF NOT cl_null(g_bnn[l_ac].bnn02) THEN
              IF g_bnn[l_ac].bnn02 != g_bnn_t.bnn02
                 OR g_bnn_t.bnn02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM bnn_file
                  WHERE bnn01 = g_bnm.bnm01
                    AND bnn02 = g_bnn[l_ac].bnn02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_bnn[l_ac].bnn02 = g_bnn_t.bnn02
                    NEXT FIELD bnn02
                 END IF
              END IF
           END IF
           
        AFTER FIELD bnn03
           IF cl_null(g_bnn[l_ac].bnn03) THEN
              NEXT FIELD bnn03
           END IF                                  
           IF NOT cl_null(g_bnn[l_ac].bnn03) THEN
              #FUN-AA0059 ------------------------add start---------------------
              IF NOT s_chk_item_no(g_bnn[l_ac].bnn03,'') THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD bnn03
              END IF 
              #FUN-AA0059 ------------------------add end----------------------
              LET l_n1 = 0
              SELECT COUNT(*) INTO l_n1 FROM ima_file
               WHERE ima01 = g_bnn[l_ac].bnn03
              IF l_n1 = 0 THEN
                 CALL cl_err('','mfg0002',0)
                 NEXT FIELD bnn03
              END IF
              CALL t330_bnn03('d') 
              SELECT ima926 INTO l_ima926 
                FROM ima_file
               WHERE ima01 = g_bnn[l_ac].bnn03
              IF l_ima926 != 'Y' THEN
                 CALL cl_err('',9088,1)
                 NEXT FIELD bnn03
              END IF                 
           END IF
          IF p_cmd = 'a' OR (p_cmd = 'u' AND g_bnn[l_ac].bnn03 != g_bnn_t.bnn03) THEN  
             SELECT COUNT(*) INTO l_count FROM bnn_file
              WHERE bnn03 = g_bnn[l_ac].bnn03
                AND bnn04 = g_bnn[l_ac].bnn04
                AND bnn01 = g_bnm.bnm01
             IF l_count > 0  THEN 
                CALL cl_err('','abm-882',1)
                NEXT FIELD bnn03
             END IF
             LET l_sql = "SELECT MAX(bnm06)",
                         "  FROM bnm_file,bnn_file",
                         " WHERE bnn01=bnm01",
                         "   AND bnm05='",g_bnm.bnm05,"'",
                         "   AND bnn03='",g_bnn[l_ac].bnn03,"'",
                         "   AND bnn04='",g_bnn[l_ac].bnn04,"'",
                         "   AND bnm08 <> '9' "  #CHI-C80041
             PREPARE t330_pb1 FROM l_sql
             DECLARE t330_cs1 CURSOR FOR t330_pb1
             OPEN t330_cs1
             FETCH t330_cs1 INTO l_bnm06
             IF l_bnm06 = '3' OR l_bnm06 = '4' THEN
                CALL cl_err_msg('','abm-878',l_bnm06,0)
                NEXT FIELD bnn03
             ELSE
             	  IF g_bnm.bnm06 <= l_bnm06 THEN
                   CALL cl_err_msg('','abm-877',l_bnm06,0)
                   NEXT FIELD bnn03
                END IF               	      
             END IF                          
          END IF           
           
        AFTER FIELD bnn04
           IF cl_null(g_bnn[l_ac].bnn04) THEN
              NEXT FIELD bnn04
           ELSE
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt 
                FROM mse_file
               WHERE mse01 = g_bnn[l_ac].bnn04
              IF l_cnt <= 0 THEN
                 CALL cl_err('','aem-048',0)
                 NEXT FIELD bnn04
              END IF           	   
           END IF        
           IF p_cmd = 'a' OR 
              (p_cmd = 'u' AND (g_bnn[l_ac].bnn03 != g_bnn_t.bnn03 OR g_bnn[l_ac].bnn04 != g_bnn_t.bnn04)) THEN
              LET l_sql = "SELECT bmj10,bmj05,bmj06,bmj11",                                                                            
                          "  FROM bmj_file",                                                                                           
                          " WHERE bmj01 = '",g_bnn[l_ac].bnn03,"'",                                                                    
                          "   AND bmj02 = '",g_bnn[l_ac].bnn04,"'",                                                                  
                          "   AND bmj03 = '",g_bnm.bnm05,"'"                                                                         
              PREPARE t330_pb5 FROM l_sql                                                                                              
              DECLARE t330_cs5 CURSOR FOR t330_pb5
              LET g_bnn[l_ac].bnn06 =NULL
              LET g_bnn[l_ac].bnn08 =NULL
              LET g_bnn[l_ac].bnn09 =NULL
              LET g_bnn[l_ac].bnn10 =NULL                                                                                       
              OPEN t330_cs5
              FETCH t330_cs5 INTO g_bnn[l_ac].bnn06,g_bnn[l_ac].bnn08,g_bnn[l_ac].bnn09,g_bnn[l_ac].bnn10
              DISPLAY BY NAME g_bnn[l_ac].bnn06
              DISPLAY BY NAME g_bnn[l_ac].bnn08
              DISPLAY BY NAME g_bnn[l_ac].bnn09
              DISPLAY BY NAME g_bnn[l_ac].bnn10  
              SELECT COUNT(*) INTO l_count FROM bnn_file
               WHERE bnn03 = g_bnn[l_ac].bnn03
                 AND bnn04 = g_bnn[l_ac].bnn04
                 AND bnn01 = g_bnm.bnm01
              IF l_count > 0  THEN 
                 CALL cl_err('','abm-882',1)
                 NEXT FIELD bnn04
              END IF
              LET l_sql = "SELECT MAX(bnm06)",
                          "  FROM bnm_file,bnn_file",
                          " WHERE bnn01=bnm01",
                          "   AND bnm05='",g_bnm.bnm05,"'",
                          "   AND bnn03='",g_bnn[l_ac].bnn03,"'",
                          "   AND bnn04='",g_bnn[l_ac].bnn04,"'",
                          "   AND bnm08 <> '9' "  #CHI-C80041 
              PREPARE t330_pb2 FROM l_sql
              DECLARE t330_cs2 CURSOR FOR t330_pb2
              OPEN t330_cs2
              FETCH t330_cs2 INTO l_bnm06
              IF l_bnm06 = '3' OR l_bnm06 = '4' THEN
                 CALL cl_err_msg('','abm-878',l_bnm06,0)
                 NEXT FIELD bnn04
              ELSE
             	   IF g_bnm.bnm06 <= l_bnm06 THEN
                    CALL cl_err_msg('','abm-877',l_bnm06,0)
                    NEXT FIELD bnn04
                 END IF               	      
              END IF               
           END IF                   
           
        BEFORE FIELD bnn06,bnn10
              CALL t330_set_entry_b()
              CALL t330_set_no_entry_b()
              CALL t330_bnm06()        
              IF g_bnm.bnm06 = '3' THEN
                 CALL cl_err('','abm-013',0)
              END IF
 
        AFTER FIELD bnn06
              IF g_bnm.bnm06 = '3' AND cl_null(g_bnn[l_ac].bnn06) THEN
                 NEXT FIELD bnn06
              END IF
 
        AFTER FIELD bnn10
              IF g_bnm.bnm06 = '3' AND cl_null(g_bnn[l_ac].bnn10) THEN
                  NEXT FIELD bnn10
              END IF                        
                      
        BEFORE DELETE                     
           DISPLAY "BEFORE DELETE"
           IF g_bnn_t.bnn02 > 0 AND g_bnn_t.bnn02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM bnn_file
               WHERE bnn01 = g_bnm.bnm01
                 AND bnn02 = g_bnn_t.bnn02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","bnn_file",g_bnm.bnm01,g_bnn_t.bnn02,SQLCA.sqlcode,"","",1)
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
              LET g_bnn[l_ac].* = g_bnn_t.*
              CLOSE t330_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_bnn[l_ac].bnn02,-263,1)
              LET g_bnn[l_ac].* = g_bnn_t.*
           ELSE
              UPDATE bnn_file SET bnn02=g_bnn[l_ac].bnn02,
                                  bnn03=g_bnn[l_ac].bnn03,
                                  bnn04=g_bnn[l_ac].bnn04,
                                  bnn05=g_bnn[l_ac].bnn05,
                                  bnn06=g_bnn[l_ac].bnn06,
                                  bnn07=g_bnn[l_ac].bnn07,
                                  bnn08=g_bnn[l_ac].bnn08,
                                  bnn09=g_bnn[l_ac].bnn09,
                                  bnn10=g_bnn[l_ac].bnn10                                  
               WHERE bnn01=g_bnm.bnm01
                 AND bnn02=g_bnn_t.bnn02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","bnn_file",g_bnm.bnm01,g_bnn_t.bnn02,SQLCA.sqlcode,"","",1)
                 LET g_bnn[l_ac].* = g_bnn_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D40030
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_bnn[l_ac].* = g_bnn_t.*
              #FUN-D40030--add--str--
              ELSE
                 CALL g_bnn.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D40030--add--end--
              END IF
              CLOSE t330_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac  #FUN-D40030
           CLOSE t330_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(bnn02) AND l_ac > 1 THEN
              LET g_bnn[l_ac].* = g_bnn[l_ac-1].*
              LET g_bnn[l_ac].bnn02 = g_rec_b + 1
              NEXT FIELD bnn02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION itemno
           IF g_sma.sma38 matches'[Yy]' THEN
              CALL cl_cmdrun("aimi109 ")
           ELSE
              CALL cl_err(g_sma.sma38,'mfg0035',1)
           END IF
           
        ON ACTION CONTROLP
           CASE           
            WHEN INFIELD(bnn03) 
#FUN-AA0059 --Begin--
          #    CALL cl_init_qry_var()
          #    LET g_qryparam.form ="q_ima08"   
          #    CALL cl_create_qry() RETURNING g_bnn[l_ac].bnn03
          #    DISPLAY BY NAME g_bnn[l_ac].bnn03
              CALL q_sel_ima(FALSE, "q_ima08", "", "" , "", "", "", "" ,"",'' )  RETURNING g_bnn[l_ac].bnn03 
#FUN-AA0059 --End--
              CALL t330_bnn03('d')
              NEXT FIELD bnn03
            WHEN INFIELD(bnn04)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_mse"
              LET g_qryparam.default1 = g_bnn[l_ac].bnn04
              CALL cl_create_qry() RETURNING g_bnn[l_ac].bnn04
              DISPLAY g_bnn[l_ac].bnn04 TO bnn04
              NEXT FIELD bnn04              
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
 
    LET g_bnm.bnmmodu = g_user
    LET g_bnm.bnmdate = g_today
    LET g_bnm.bnm08 = '0'  #FUN-BC0018
    UPDATE bnm_file SET bnmmodu = g_bnm.bnmmodu,bnmdate = g_bnm.bnmdate,bnm08 = g_bnm.bnm08 #FUN-BC0018 add bnm08
     WHERE bnm01 = g_bnm.bnm01
    DISPLAY BY NAME g_bnm.bnmmodu,g_bnm.bnmdate,g_bnm.bnm08  #FUN-BC0018 add bnm08
 
    CLOSE t330_bcl
    COMMIT WORK
#   CALL t330_delall()
    CALL t330_delHeader()
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t330_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_bnm.bnm01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM bnm_file ",
                  "  WHERE bnm01 LIKE '",l_slip,"%' ",
                  "    AND bnm01 > '",g_bnm.bnm01,"'"
      PREPARE t330_pb6 FROM l_sql 
      EXECUTE t330_pb6 INTO l_cnt       
      
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
        #CALL t330_v()
         CALL t330_v(1)   #CHI-D20010
         CALL t330_show_pic()
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM bnm_file WHERE bnm01 = g_bnm.bnm01
         INITIALIZE g_bnm.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
 
#CHI-C30002 -------- mark -------- begin
#FUNCTION t330_delall()
#
#  SELECT COUNT(*) INTO g_cnt FROM bnn_file
#   WHERE bnn01 = g_bnm.bnm01
#
#  IF g_cnt = 0 THEN                   # 未輸入單身資料, 是否取消單頭資料
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM bnm_file WHERE bnm01 = g_bnm.bnm01
#  END IF
#
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION t330_b_fill(p_wc2)
DEFINE p_wc2   STRING
DEFINE  l_s      LIKE type_file.chr1000 
DEFINE  l_m      LIKE type_file.chr1000 
DEFINE  i        LIKE type_file.num5
 
   LET g_sql = "SELECT bnn02,bnn03,'','',bnn04,bnn05,",
               " bnn08,bnn09,bnn06,bnn10,bnn07 FROM bnn_file",
               " WHERE bnn01 ='",g_bnm.bnm01,"' "   #單頭
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY bnn02"
   DISPLAY g_sql
 
   PREPARE t330_pb FROM g_sql
   DECLARE bnn_cs CURSOR FOR t330_pb
 
   CALL g_bnn.clear()
   LET g_cnt = 1
 
   FOREACH bnn_cs INTO g_bnn[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT ima02,ima021 INTO g_bnn[g_cnt].ima02,g_bnn[g_cnt].ima021
         FROM ima_file
        WHERE ima01 = g_bnn[g_cnt].bnn03 
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_bnn.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t330_copy()
   DEFINE l_newno     LIKE bnm_file.bnm01,
          l_newdate   LIKE bnm_file.bnm02,
          l_oldno     LIKE bnm_file.bnm01
   DEFINE li_result   LIKE type_file.num5 
   DEFINE l_slip      LIKE smy_file.smyslip  #MOD-D10213
   DEFINE l_bnmmksg   LIKE bnm_file.bnmmksg  #MOD-D10213
   
   IF s_shut(0) THEN RETURN END IF
 
   IF g_bnm.bnm01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   
   CALL cl_set_head_visible("","YES")           
   INPUT l_newno,l_newdate FROM bnm01,bnm02
       BEFORE INPUT
          CALL cl_set_docno_format("bnm01")
          CALL cl_set_comp_required("bnm02",TRUE)    #TQC-BC0176
          CALL cl_set_comp_entry("bnm01,bnm02",TRUE) #TQC-BC0176
          LET l_newdate=g_today                      #TQC-BC0176
          DISPLAY l_newdate TO bnm02                 #TQC-BC0176
 
       AFTER FIELD bnm01
           CALL s_check_no("abm",l_newno,"","5","bnm_file","bnm01","") RETURNING li_result,l_newno
           DISPLAY l_newno TO bnm01
           IF (NOT li_result) THEN
              LET g_bnm.bnm01 = g_bnm_o.bnm01
              NEXT FIELD bnm01
           END IF
 
           DISPLAY g_smy.smydesc TO smydesc           #單據名稱
 
       AFTER FIELD bnm02
           IF cl_null(l_newdate) THEN NEXT FIELD bnm02 END IF
 
           BEGIN WORK 
           CALL s_auto_assign_no("abm",l_newno,l_newdate,"","bnm_file","bnm01","","","") RETURNING li_result,l_newno
           IF (NOT li_result) THEN
              NEXT FIELD bnm01
           END IF
           DISPLAY l_newno TO bnm01
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(bnm01) #單據編號
                LET g_t1=s_get_doc_no(l_newno)       
                CALL q_smy(FALSE,FALSE,g_t1,'abm','5') RETURNING g_t1 
                LET l_newno=g_t1                     
                DISPLAY BY NAME l_newno
                NEXT FIELD bnm01
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
 

     AFTER INPUT                                 #TQC-BC0176
        CALL cl_set_comp_required("bnm02",FALSE) #TQC-BC0176 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_bnm.bnm01
      ROLLBACK WORK
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM bnm_file         #單頭複製
       WHERE bnm01=g_bnm.bnm01
       INTO TEMP y
   #MOD-D10213---begin
   CALL s_get_doc_no(l_newno) RETURNING l_slip
   SELECT smyapr INTO l_bnmmksg
     FROM smy_file 
    WHERE smyslip = l_slip
   IF cl_null(l_bnmmksg) THEN LET l_bnmmksg = 'N' END IF 
   #MOD-D10213---end
   UPDATE y
       SET bnm01=l_newno,    #新的鍵值
           bnm02=l_newdate,  
           bnmuser=g_user,   #資料所有者
           bnmgrup=g_grup,   #資料所有者所屬群
           bnmmodu=NULL,     #資料修改日期
           bnmdate=g_today,  #資料建立日期
           bnmacti='Y',      #有效資料
           bnm08='0',        #狀況碼  #FUN-BC0018
           bnmmksg = l_bnmmksg  #MOD-D10213
 
   INSERT INTO bnm_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","bnm_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
   END IF
 
   DROP TABLE x
 
   SELECT * FROM bnn_file         #單身複製
       WHERE bnn01=g_bnm.bnm01
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF
 
   UPDATE x SET bnn01=l_newno
 
   INSERT INTO bnn_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","bnn_file","","",SQLCA.sqlcode,"","",1)    #No.FUN-B80100---上移一行調整至回滾事務前---
      ROLLBACK WORK 
      RETURN
   ELSE
       COMMIT WORK
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_bnm.bnm01
   SELECT bnm_file.* INTO g_bnm.* FROM bnm_file WHERE bnm01 = l_newno                      #091020
   CALL t330_u()
   CALL t330_b()
   #SELECT bnm_file.* INTO g_bnm.* FROM bnm_file WHERE bnm01 = l_oldno  #FUN-C30027                  #091020
   #CALL t330_show()  #FUN-C30027
 
END FUNCTION

#FUN-BC0018 mark str--- 
#FUNCTION t330_confirm()
#  DEFINE l_cnt    LIKE type_file.num5
#  DEFINE i        LIKE type_file.num5
#  DEFINE l_n       LIKE type_file.num5  #TQC-A10053
#  DEFINE l_bmj08  LIKE bmj_file.bmj08
#  DEFINE c_bnm05   LIKE bnm_file.bnm05  #No.FUN-930109
#  DEFINE c_bnm06   LIKE bnm_file.bnm06  #No.FUN-930109
#  DEFINE c_bnn02   LIKE bnn_file.bnn02  #No.FUN-930109
#  DEFINE c_bnn03   LIKE bnn_file.bnn03  #No.FUN-930109
#  DEFINE c_bnn04   LIKE bnn_file.bnn04  #No.FUN-930109
#  DEFINE c_bmj08   LIKE bmj_file.bmj08  #No.FUN-930109
#  
#  
#    LET g_success = 'Y'
#    
#    LET g_flag ='Y'                 #No.FUN-930109
# 
#    IF g_bnm.bnm07 = 'Y' THEN
#       RETURN
#    END IF   
#  
#    #TQC-A10053---Begin
#    IF g_bnm.bnm06 = '3' THEN
#       SELECT COUNT(*) INTO l_n FROM bnn_file
#        WHERE bnn01 = g_bnm.bnm01
#          AND (bnn06 IS NULL OR bnn10 IS NULL)
#       IF l_n > 0 THEN
#          CALL cl_err('','abm-013',0)
#          RETURN
#       END IF
#    END IF   
#    #TQC-A10053---End 
#   
#    IF NOT cl_confirm('axm-108') THEN RETURN END IF
#  
#    IF g_bnm.bnmacti = 'N' THEN
#       CALL cl_err('','abm-889',1)
#       RETURN
#    ELSE
#    	 BEGIN WORK
#       FOR i = 1 TO g_rec_b
#           LET l_cnt = 0
##FUN-930109-add--by douzh-begin
#       DECLARE t330_bnn_cs CURSOR FOR
#         SELECT bnm05,bnm06,bnn02,bnn03,bnn04 FROM bnm_file,bnn_file
#          WHERE bnn01=bnm01
#            AND bnm01=g_bnm.bnm01
#            AND bnm05=g_bnm.bnm05
#            AND bnn03=g_bnn[i].bnn03
#            AND bnn04=g_bnn[i].bnn04
#       CALL s_showmsg_init()
#       FOREACH t330_bnn_cs INTO c_bnm05,c_bnm06,c_bnn02,c_bnn03,c_bnn04
#          DECLARE t330_bmj2_cs CURSOR FOR 
#            SELECT bmj08 FROM bmj_file
#                   WHERE bmj01=c_bnn03
#                     AND bmj02 = c_bnn04
#                     AND bmj03 = c_bnm05
#          FOREACH t330_bmj2_cs INTO c_bmj08
#              IF c_bnm06<c_bmj08 THEN
#                 LET g_flag='N'
#                 LET g_showmsg=c_bnn02,"/",c_bnn03,"/",c_bnm05,"/",c_bnn04
#                 CALL s_errmsg('bnn02,bnn03,bnm05,bnn04',g_showmsg,'','abm-875',1)
#              END IF
#          END FOREACH
#       END FOREACH
#       CALL s_showmsg()
#       IF g_flag='N' THEN
#          RETURN
#       END IF
##FUN-930109-add--by douzh--end
# 
#    	     SELECT COUNT(*) INTO l_cnt FROM bmj_file
#    	      WHERE bmj01 = g_bnn[i].bnn03
#    	        AND bmj02 = g_bnn[i].bnn04
#    	        AND bmj03 = g_bnm.bnm05
#    	     IF l_cnt = 0 THEN
#                IF cl_null(g_bnn[i].bnn03) THEN
#                   LET g_bnn[i].bnn03 = ' '
#                END IF
#                IF cl_null(g_bnn[i].bnn04) THEN
#                   LET g_bnn[i].bnn04 = ' '
#                END IF
#                IF cl_null(g_bnm.bnm05) THEN
#                   LET g_bnm.bnm05 = ' '
#                END IF                                	     
#    	        INSERT INTO bmj_file(bmj01,bmj02,bmj03,bmj04,bmj05,
#    	                             bmj06,bmj07,bmj08,bmj10,bmj11,bmj12,
#    	                             bmjacti,bmjuser,bmjgrup,bmjoriu,bmjorig)
#    	        VALUES(g_bnn[i].bnn03,g_bnn[i].bnn04,g_bnm.bnm05,g_bnn[i].bnn05,g_bnn[i].bnn08,
#    	               g_bnn[i].bnn09,g_bnm.bnm03,g_bnm.bnm06,g_bnn[i].bnn06,g_bnn[i].bnn10,g_bnn[i].bnn07,
#    	               g_bnm.bnmacti,g_bnm.bnmuser,g_bnm.bnmgrup, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
#                IF SQLCA.sqlcode THEN
#                   CALL cl_err3("ins","bmj_file","","",SQLCA.sqlcode,"","",1)   #No.FUN-B80100---上移一行調整至回滾事務前---
#                   ROLLBACK WORK
#                   LET g_success = 'N' 
#                   RETURN
#                ELSE
#               	   CALL t330_ins_pmh(i)     	               
#                END IF    	               
#    	     ELSE
#    	     	UPDATE bmj_file SET bmj04=g_bnn[i].bnn05,
#                                bmj05=g_bnn[i].bnn08,
#                                bmj06=g_bnn[i].bnn09,
#                                bmj07=g_bnm.bnm03,
#                                bmj08=g_bnm.bnm06,
#                                bmj10=g_bnn[i].bnn06,
#                                bmj11=g_bnn[i].bnn10,
#                                bmj12=g_bnn[i].bnn07,
#                                bmjacti=g_bnm.bnmacti,
#                                bmjuser=g_bnm.bnmuser,
#                                bmjgrup=g_bnm.bnmgrup
#               WHERE bmj01=g_bnn[i].bnn03
#                 AND bmj02=g_bnn[i].bnn04
#                 AND bmj03=g_bnm.bnm05
#              IF SQLCA.sqlcode THEN
#                 CALL cl_err3("upd","bmj_file","","",SQLCA.sqlcode,"","",1)   #No.FUN-B80100---上移兩行調整至回滾事務前---
#                 ROLLBACK WORK
#                 LET g_success = 'N' 
#                 RETURN
#              ELSE
#              	 CALL t330_ins_pmh(i)     	               
#              END IF                 
#           END IF      
#    	 END FOR
#    	 IF g_success = 'Y' THEN
#    	    LET g_bnm.bnm07 = 'Y'
#    	    UPDATE bnm_file SET bnm07 = 'Y'
#    	     WHERE bnm01 = g_bnm.bnm01
#    	    DISPLAY BY NAME g_bnm.bnm07   
#    	    COMMIT WORK 
#    	 END IF   	                                         	    
#    END IF     
#END FUNCTION
#FUN-BC0018 mark end--- 

#FUN-BC0018 add str---
FUNCTION t330_y_chk()
  DEFINE l_n      LIKE type_file.num5  
  
    LET g_success = 'Y'
 
#CHI-C30107 -------------- add ------------- begin
    IF g_bnm.bnm01 IS NULL THEN
       CALL cl_err('',-400,0)
       LET g_success = 'N'
       RETURN
    END IF
    #CHI-C80041---begin
    IF g_bnm.bnm08 = '9' THEN 
       LET g_success = 'N'
       RETURN 
    END IF  
    #CHI-C80041---end
    IF g_bnm.bnm08 = '1' THEN  #已核准
       CALL cl_err('','mfg3212',1)
       LET g_success = 'N'
       RETURN
    END IF

    IF g_bnm.bnm06 = '3' THEN  #已承認
       SELECT COUNT(*) INTO l_n FROM bnn_file
        WHERE bnn01 = g_bnm.bnm01
          AND (bnn06 IS NULL OR bnn10 IS NULL)
       IF l_n > 0 THEN
          CALL cl_err('','abm-013',0)
          LET g_success = 'N'
          RETURN
       END IF
    END IF

    IF g_bnm.bnmacti = 'N' THEN  #本筆資料無效
       CALL cl_err('','abm-889',1)
       LET g_success = 'N'
       RETURN
    END IF
    IF g_action_choice CLIPPED = "confirm" OR  #執行 "確認" 功能(非簽核模式呼叫)
       g_action_choice CLIPPED = "insert"
    THEN
       IF NOT cl_confirm('axm-108') THEN LET g_success = 'N' RETURN END IF  #詢問是否執行確認功能 #CHI-C30107
    END IF
#CHI-C30107 -------------- add ----------------- end
    IF g_bnm.bnm01 IS NULL THEN
       CALL cl_err('',-400,0)
       LET g_success = 'N'
       RETURN
    END IF

    IF g_bnm.bnm08 = '1' THEN  #已核准
       CALL cl_err('','mfg3212',1)
       LET g_success = 'N'
       RETURN
    END IF   
  
    IF g_bnm.bnm06 = '3' THEN  #已承認
       SELECT COUNT(*) INTO l_n FROM bnn_file
        WHERE bnn01 = g_bnm.bnm01
          AND (bnn06 IS NULL OR bnn10 IS NULL)
       IF l_n > 0 THEN
          CALL cl_err('','abm-013',0)
          LET g_success = 'N'
          RETURN
       END IF
    END IF   
    
    IF g_bnm.bnmacti = 'N' THEN  #本筆資料無效
       CALL cl_err('','abm-889',1)
       LET g_success = 'N'
       RETURN
    END IF
END FUNCTION

FUNCTION t330_y_upd()
  DEFINE i         LIKE type_file.num5
  DEFINE l_cnt     LIKE type_file.num5
  DEFINE c_bnm05   LIKE bnm_file.bnm05  
  DEFINE c_bnm06   LIKE bnm_file.bnm06  
  DEFINE c_bnn02   LIKE bnn_file.bnn02
  DEFINE c_bnn03   LIKE bnn_file.bnn03  
  DEFINE c_bnn04   LIKE bnn_file.bnn04  
  DEFINE c_bmj08   LIKE bmj_file.bmj08  

    LET g_success = 'Y'
    LET g_flag = 'Y' 

    IF g_action_choice CLIPPED = "confirm" OR  #執行 "確認" 功能(非簽核模式呼叫)
       g_action_choice CLIPPED = "insert"    
    THEN
       IF g_bnm.bnmmksg = 'Y' THEN        #若簽核碼為 'Y' 且狀態碼不為 '1' 已同意
          IF g_bnm.bnm08 != '1' THEN
             CALL cl_err('','aws-078',1)  #此狀況碼不為「1.已核准」，不可確認!!
             LET g_success = 'N'
             RETURN
          END IF
       END IF
#      IF NOT cl_confirm('axm-108') THEN RETURN END IF  #詢問是否執行確認功能 #CHI-C30107 mark
    END IF

    BEGIN WORK

    FOR i = 1 TO g_rec_b
       LET l_cnt = 0
       DECLARE t330_bnn_cs CURSOR FOR
          SELECT bnm05,bnm06,bnn02,bnn03,bnn04 FROM bnm_file,bnn_file
           WHERE bnn01 = bnm01
             AND bnm01 = g_bnm.bnm01
             AND bnm05 = g_bnm.bnm05
             AND bnn03 = g_bnn[i].bnn03
             AND bnn04 = g_bnn[i].bnn04
             AND bnm08 <> '9'   #CHI-C80041

       CALL s_showmsg_init()
       FOREACH t330_bnn_cs INTO c_bnm05,c_bnm06,c_bnn02,c_bnn03,c_bnn04
          DECLARE t330_bmj2_cs CURSOR FOR 
             SELECT bmj08 FROM bmj_file
              WHERE bmj01 = c_bnn03
                AND bmj02 = c_bnn04
                AND bmj03 = c_bnm05
          FOREACH t330_bmj2_cs INTO c_bmj08
             IF c_bnm06 < c_bmj08 THEN
                LET g_flag = 'N'
                LET g_showmsg = c_bnn02,"/",c_bnn03,"/",c_bnm05,"/",c_bnn04
                CALL s_errmsg('bnn02,bnn03,bnm05,bnn04',g_showmsg,'','abm-875',1)
             END IF
          END FOREACH
       END FOREACH
       CALL s_showmsg()
       IF g_flag='N' THEN
          LET g_success = 'N'
          RETURN
       END IF
  
       SELECT COUNT(*) INTO l_cnt FROM bmj_file
        WHERE bmj01 = g_bnn[i].bnn03
          AND bmj02 = g_bnn[i].bnn04
          AND bmj03 = g_bnm.bnm05
       IF l_cnt = 0 THEN
          IF cl_null(g_bnn[i].bnn03) THEN
             LET g_bnn[i].bnn03 = ' '
          END IF
          IF cl_null(g_bnn[i].bnn04) THEN
             LET g_bnn[i].bnn04 = ' '
          END IF
          IF cl_null(g_bnm.bnm05) THEN
             LET g_bnm.bnm05 = ' '
          END IF        
                        	     
          INSERT INTO bmj_file(bmj01,bmj02,bmj03,bmj04,bmj05,
                               bmj06,bmj07,bmj08,bmj10,bmj11,bmj12,
                               bmjacti,bmjuser,bmjgrup,bmjoriu,bmjorig)
          VALUES(g_bnn[i].bnn03,g_bnn[i].bnn04,g_bnm.bnm05,g_bnn[i].bnn05,g_bnn[i].bnn08,
                 g_bnn[i].bnn09,g_bnm.bnm03,g_bnm.bnm06,g_bnn[i].bnn06,g_bnn[i].bnn10,g_bnn[i].bnn07,
                 g_bnm.bnmacti,g_bnm.bnmuser,g_bnm.bnmgrup, g_user, g_grup) 
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","bmj_file","","",SQLCA.sqlcode,"","",1)   #No.FUN-B80100---上移一行調整至回滾事務前---
             ROLLBACK WORK
             LET g_success = 'N'
             RETURN
          ELSE
             CALL t330_ins_pmh(i)     	               
          END IF    	               
       ELSE
       	  UPDATE bmj_file SET bmj04 = g_bnn[i].bnn05,
                              bmj05 = g_bnn[i].bnn08,
                              bmj06 = g_bnn[i].bnn09,
                              bmj07 = g_bnm.bnm03,
                              bmj08 = g_bnm.bnm06,
                              bmj10 = g_bnn[i].bnn06,
                              bmj11 = g_bnn[i].bnn10,
                              bmj12 = g_bnn[i].bnn07,
                              bmjacti = g_bnm.bnmacti,
                              bmjuser = g_bnm.bnmuser,
                              bmjgrup = g_bnm.bnmgrup
           WHERE bmj01 = g_bnn[i].bnn03
             AND bmj02 = g_bnn[i].bnn04
             AND bmj03 = g_bnm.bnm05
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","bmj_file","","",SQLCA.sqlcode,"","",1)   #No.FUN-B80100---上移一行調整至回滾事務前---
             ROLLBACK WORK
             LET g_success = 'N'
             RETURN
          ELSE
             CALL t330_ins_pmh(i)     	               
          END IF                 
       END IF      
    END FOR
    IF g_success = 'Y' THEN
       IF g_bnm.bnmmksg = 'Y' THEN       #簽核模式
          CASE aws_efapp_formapproval()  #呼叫EF簽核功能
             WHEN 0  #呼叫EasyFlow簽核失敗
                LET g_success = "N"
                ROLLBACK WORK
                RETURN
             WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                ROLLBACK WORK
                RETURN
          END CASE
       END IF
   
       IF g_success = 'Y' THEN
          LET g_bnm.bnm08 = '1'  #執行成功，狀態值顯示為'1'已核准
          UPDATE bnm_file SET bnm08 = '1'
           WHERE bnm01 = g_bnm.bnm01
          DISPLAY BY NAME g_bnm.bnm08   
          COMMIT WORK 
       ELSE
          LET g_success = "N"
          ROLLBACK WORK
       END IF
    ELSE
       LET g_success = "N"
       ROLLBACK WORK
    END IF   	                                         	    
END FUNCTION
#FUN-BC0018 add end---
 
FUNCTION t330_unconfirm()
  DEFINE l_cnt     LIKE type_file.num5
  DEFINE i         LIKE type_file.num5
  DEFINE l_bnm06   LIKE bnm_file.bnm06
  DEFINE l_bnm06_1 LIKE bnm_file.bnm06
  DEFINE l_sql     STRING
  DEFINE l_pmc22   LIKE pmc_file.pmc22 
  DEFINE c_bnm05   LIKE bnm_file.bnm05
  DEFINE c_bnm06   LIKE bnm_file.bnm06
  DEFINE c_bnn02   LIKE bnn_file.bnn02
  DEFINE c_bnn03   LIKE bnn_file.bnn03
  DEFINE c_bnn04   LIKE bnn_file.bnn04
  DEFINE c_bmj08   LIKE bmj_file.bmj08 
  
    LET g_success = 'Y'
 
    LET g_flag ='Y'                 #No.FUN-930109
  
   #FUN-BC0018 mark str---  
   #IF g_bnm.bnm07 = 'N' THEN
   #   RETURN
   #END IF
   #FUN-BC0018 mark end---  
   
   #FUN-BC0018 add str---
    IF g_bnm.bnm08 = '9' THEN RETURN END IF  #CHI-C80041
    IF g_bnm.bnm08 = 'S' THEN
       #送簽中, 不可修改資料!
       CALL cl_err(g_bnm.bnm08,'apm-030',1)
       RETURN
    END IF
    #非審核狀態 不能取消審核
    IF g_bnm.bnm08 !='1' THEN
       CALL  cl_err('','atm-053',1)
       RETURN
    END IF
   #FUN-BC0018 add end---
    
    IF NOT cl_confirm('axm-109') THEN RETURN END IF
    
    FOR i = 1 TO g_rec_b
#FUN-930109--begin-by douzh
    DECLARE t330_bnn_cs2 CURSOR FOR
      SELECT bnm05,bnm06,bnn02,bnn03,bnn04 FROM bnm_file,bnn_file
       WHERE bnn01=bnm01
         AND bnm01=g_bnm.bnm01
         AND bnm05=g_bnm.bnm05
         AND bnn03=g_bnn[i].bnn03
         AND bnn04=g_bnn[i].bnn04
        #AND bnm07='Y'  #FUN-BC0018 mark
         AND bnm08='1'  #FUN-BC0018 add
    CALL s_showmsg_init()
    FOREACH t330_bnn_cs2 INTO c_bnm05,c_bnm06,c_bnn02,c_bnn03,c_bnn04
       DECLARE t330_bmj2_cs2 CURSOR FOR 
         SELECT bmj08 FROM bmj_file
                WHERE bmj01=c_bnn03
                  AND bmj02 = c_bnn04
                  AND bmj03 = c_bnm05
       FOREACH t330_bmj2_cs2 INTO c_bmj08
           IF c_bnm06<c_bmj08 THEN
              LET g_flag='N'
              LET g_showmsg=c_bnn02,"/",c_bnn03,"/",c_bnm05,"/",c_bnn04
              CALL s_errmsg('bnn02,bnn03,bnm05,bnn04',g_showmsg,'','abm-876',1)
           END IF
       END FOREACH
    END FOREACH
    CALL s_showmsg()
    IF g_flag='N' THEN
       RETURN
    END IF
 
    LET l_sql = "SELECT MAX(bnm06)",
                "  FROM bnm_file,bnn_file",
                " WHERE bnn01 = bnm01",
                "   AND bnm05 = '",g_bnm.bnm05,"'",
                "   AND bnn03 = '",g_bnn[i].bnn03,"'",
                "   AND bnn04 = '",g_bnn[i].bnn04,"'",
               #"   AND bnm07 = 'Y'"  #FUN-BC0018 mark
                "   AND bnm08 = '1'"  #FUN-BC0018 add
    PREPARE t330_pb3 FROM l_sql
    DECLARE t330_cs3 CURSOR FOR t330_pb3
    OPEN t330_cs3
    FETCH t330_cs3 INTO l_bnm06_1
    
    LET l_sql = "SELECT MAX(bnm06)",
                "  FROM bnm_file,bnn_file",
                " WHERE bnn01 = bnm01",
                "   AND bnm05 = '",g_bnm.bnm05,"'",
                "   AND bnn03 = '",g_bnn[i].bnn03,"'",
                "   AND bnn04 = '",g_bnn[i].bnn04,"'",
               #"   AND bnm07 = 'Y'",  #FUN-BC0018 mark
                "   AND bnm08 = '1'",  #FUN-BC0018 add
                "   AND bnm06 != '",g_bnm.bnm06,"'"
    PREPARE t330_pb4 FROM l_sql
    DECLARE t330_cs4 CURSOR FOR t330_pb4
    OPEN t330_cs4
    FETCH t330_cs4 INTO l_bnm06     
    
#FUN-930109--end-by douzh
    
    
 
 
    IF g_sma.sma102 = 'Y' THEN
       LET l_cnt = 0
       SELECT pmc22 INTO l_pmc22 FROM pmc_file
        WHERE pmc01 = g_bnm.bnm05
       IF NOT cl_null(l_pmc22) THEN
          SELECT COUNT(*) INTO l_cnt FROM pmh_file
           WHERE pmh01 = g_bnn[i].bnn03
             AND pmh02 = g_bnm.bnm05
             AND pmh13 = l_pmc22
             AND pmh21 = " "                                                                            
             AND pmh22 = '1'                                            
             AND pmhacti = 'Y'                                     
        END IF
    ELSE
        LET l_cnt = 0
    END IF            
       	 
    BEGIN WORK
    IF g_bnm.bnm06 = '0' OR cl_null(l_bnm06) THEN       
    	     DELETE FROM bmj_file
    	      WHERE bmj01 = g_bnn[i].bnn03
    	        AND bmj02 = g_bnn[i].bnn04
    	        AND bmj03 = g_bnm.bnm05
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","bmj_file","","",SQLCA.sqlcode,"","",1)   #No.FUN-B80100---上移兩行調整至回滾事務前---
              ROLLBACK WORK
              LET g_success = 'N' 
              RETURN  	               
           END IF
           IF g_sma.sma102='Y' AND l_cnt > 0 THEN
              SELECT pmc22 INTO l_pmc22 FROM pmc_file
               WHERE pmc01 = g_bnm.bnm05
              UPDATE pmh_file SET
                     pmh05 = '1',
                     pmh06 = ''
               WHERE pmh01 = g_bnn[i].bnn03
                 AND pmh02 = g_bnm.bnm05
                 AND pmh13 = l_pmc22
                 AND pmh21 = " "                                                                                 
                 AND pmh22 = '1'                                           
              IF SQLCA.sqlcode THEN
                 LET g_success = 'N'
                 CALL cl_err3("upd","pmh_file","","",SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
                 RETURN
              END IF
           END IF                	             
    	 IF g_success = 'Y' THEN
           #FUN-BC0018 mod str---
    	   #LET g_bnm.bnm07 = 'N'
    	   #UPDATE bnm_file SET bnm07 = 'N'
    	   # WHERE bnm01 = g_bnm.bnm01
    	   #DISPLAY BY NAME g_bnm.bnm07  
    	    LET g_bnm.bnm08 = '0'
    	    UPDATE bnm_file SET bnm08 = '0'
    	     WHERE bnm01 = g_bnm.bnm01
    	    DISPLAY BY NAME g_bnm.bnm08  
           #FUN-BC0018 mod end---
    	    COMMIT WORK
    	 END IF
    ELSE  
       IF g_bnm.bnm06 = '3' THEN       
          UPDATE bmj_file SET bmj08 = l_bnm06,
                              bmj10 = '',
                              bmj11 = '' 
           WHERE bmj01 = g_bnn[i].bnn03
             AND bmj02 = g_bnn[i].bnn04
             AND bmj03 = g_bnm.bnm05
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","bmj_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-B80100---上移兩行調整至回滾事務前---
             ROLLBACK WORK
             LET g_success = 'N' 
             RETURN  	               
          END IF
       ELSE
          UPDATE bmj_file SET bmj08 = l_bnm06
           WHERE bmj01 = g_bnn[i].bnn03
             AND bmj02 = g_bnn[i].bnn04
             AND bmj03 = g_bnm.bnm05
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","bmj_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-B80100---上移兩行調整至回滾事務前---
             ROLLBACK WORK
             LET g_success = 'N' 
             RETURN  	               
          END IF
       END IF
       IF g_sma.sma102='Y' AND l_cnt > 0 THEN
          SELECT pmc22 INTO l_pmc22 FROM pmc_file
           WHERE pmc01 = g_bnm.bnm05
          UPDATE pmh_file SET
                 pmh05 = '1',
                 pmh06 = ''
           WHERE pmh01 = g_bnn[i].bnn03
             AND pmh02 = g_bnm.bnm05
             AND pmh13 = l_pmc22
             AND pmh21 = " "                                                                                 
             AND pmh22 = '1'
          IF SQLCA.sqlcode THEN
             LET g_success = 'N'
             CALL cl_err3("upd","pmh_file","","",SQLCA.sqlcode,"","",1)  
             ROLLBACK WORK
             RETURN
          END IF
       END IF                         	             
       IF g_success = 'Y' THEN
         #FUN-BC0018 mod str---
         #LET g_bnm.bnm07 = 'N'
         #UPDATE bnm_file SET bnm07 = 'N'
         # WHERE bnm01 = g_bnm.bnm01
         #DISPLAY BY NAME g_bnm.bnm07  
          LET g_bnm.bnm08 = '0'
          UPDATE bnm_file SET bnm08 = '0'
           WHERE bnm01 = g_bnm.bnm01
          DISPLAY BY NAME g_bnm.bnm08  
         #FUN-BC0018 mod end---
           COMMIT WORK
       END IF
    END IF
    END FOR    	     	 	    
    
END FUNCTION
 
FUNCTION t330_ef()                                                                                                                  
                                                                                                                                    
    #FUN-BC0018 add str---                    
     CALL t330_y_chk()  #CALL 原確認段的check段後在執行送簽
     IF g_success = 'N' THEN                                                                                                        
        RETURN                                                                                                                     
     END IF                                                                                                                         
    #FUN-BC0018 add end--- 
                                                                                                            
     IF g_bnm.bnmacti = 'N' THEN
        CALL cl_err('','abm-885',1)
        LET g_success = 'N'
        RETURN
     END IF
     #IF g_bnm.bnm07 = 'N' THEN    #MOD-AC0341 mark
    #IF g_bnm.bnm07 = 'Y' THEN     #MOD-AC0341 add  #FUN-BC0018 mark
     IF g_bnm.bnm08 = '1' THEN     #MOD-AC0341 add  #FUN-BC0018 add
        CALL cl_err('','abm-884',1)
        LET g_success = 'N'
        RETURN
     END IF                                                                                                                       
                                                                                                                                    
     CALL aws_condition()  #判斷送簽資料                                                                                         
     IF g_success = 'N' THEN                                                                                                        
         RETURN                                                                                                                     
     END IF                                                                                                                         

 ##########
 # CALL aws_efcli2()
 # 傳入參數：(1)單頭資料,(2-6)單身資料
 # 回傳值：0 開單失敗; 1 開單成功
 ##########
                                                                                                                
 IF aws_efcli2(base.TypeInfo.create(g_bnm),base.TypeInfo.create(g_bnn),'','','','')                        
 THEN
   LET g_success='Y'                                                                                                   
  #FUN-BC0018 add str---
   LET g_bnm.bnm08 = 'S'
   DISPLAY BY NAME g_bnm.bnm08      
  #FUN-BC0018 add end---                                                                                            
 ELSE                                                                                                                               
   LET g_success='N'                                                                                                                
 END IF                                                                                                                             
                                                                                                                                    
END FUNCTION 
 
FUNCTION t330_set_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("bnm01",TRUE)
   END IF   
END FUNCTION
 
FUNCTION t330_set_no_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("bnm01",FALSE)
   END IF
END FUNCTION
 
FUNCTION t330_set_entry_b() 
   IF g_bnm.bnm06='3' THEN
     CALL cl_set_comp_entry("bnn06,bnn10",TRUE)
   END IF
END FUNCTION
 
FUNCTION t330_set_no_entry_b()
   IF g_bnm.bnm06<>'3' THEN
     CALL cl_set_comp_entry("bnn06,bnn10",FALSE)
   END IF
END FUNCTION
 
FUNCTION t330_bnm06()
   IF g_bnm.bnm06<>'3' THEN
      LET g_bnn[l_ac].bnn10=NULL
      LET g_bnn[l_ac].bnn06=NULL
   END IF
END FUNCTION
 
FUNCTION t330_bnn03(p_cmd)        
DEFINE  p_cmd   LIKE type_file.chr1   
 
   LET g_errno = " "
  SELECT ima02,ima021 INTO g_bnn[l_ac].ima02,g_bnn[l_ac].ima021
    FROM ima_file
   WHERE ima01 = g_bnn[l_ac].bnn03
   
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
                           LET g_bnn[l_ac].ima02 = NULL
                           LET g_bnn[l_ac].ima021 = NULL
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE   
   
  SELECT pmh04 INTO g_bnn[l_ac].bnn05
    FROM pmh_file
   WHERE pmh01 = g_bnn[l_ac].bnn03
     AND pmh02 = g_bnm.bnm05    
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
                           LET g_bnn[l_ac].bnn05 = NULL
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY BY NAME g_bnn[l_ac].ima02
      DISPLAY BY NAME g_bnn[l_ac].ima021
      DISPLAY BY NAME g_bnn[l_ac].bnn05 
   END IF   
   
END FUNCTION
 
FUNCTION t330_ins_pmh(i)                
  DEFINE  l_cnt      LIKE type_file.num5,          
          l_pmh      RECORD LIKE pmh_file.*,
          l_pmh05    LIKE pmh_file.pmh05,
          l_pmh06    LIKE pmh_file.pmh06,
          l_pmc22    LIKE pmc_file.pmc22,
          i          LIKE type_file.num5
 
     IF g_sma.sma102='N' THEN RETURN END IF
 
     SELECT pmc22 INTO l_pmc22 FROM pmc_file
      WHERE pmc01 = g_bnm.bnm05
 
     SELECT COUNT(*) INTO l_cnt FROM pmh_file
      WHERE pmh01 = g_bnn[i].bnn03
        AND pmh02 = g_bnm.bnm05
        AND pmh13 = l_pmc22
        AND pmh21 = " "                                                                                           
        AND pmh22 = '1'                                             
        AND pmhacti = 'Y'                                        
     IF l_cnt > 0 THEN
        CASE WHEN g_bnm.bnm06='3'
                  LET l_pmh05 = '0'
                  LET l_pmh06 = g_bnn[i].bnn10
             WHEN g_bnm.bnm06='4'
                  LET l_pmh05 = '2'
                  LET l_pmh06 = ''
             OTHERWISE
                  LET l_pmh05 = '1'
                  LET l_pmh06 = ''
             EXIT CASE
        END CASE
        UPDATE pmh_file SET
               pmh04 = g_bnn[i].bnn05,
               pmh05 = l_pmh05,
               pmh06 = l_pmh06
         WHERE pmh01 = g_bnn[i].bnn03
           AND pmh02 = g_bnm.bnm05
           AND pmh13 = l_pmc22
           AND pmh21 = " "                                                                                    
           AND pmh22 = '1'                                            
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           CALL cl_err3("upd","pmh_file","","",SQLCA.sqlcode,"","",1)  
           LET g_success = 'N'
        END IF
     ELSE
       LET l_pmh.pmh01 = g_bnn[i].bnn03
       LET l_pmh.pmh02 = g_bnm.bnm05
       LET l_pmh.pmh04 = g_bnn[i].bnn05
       LET l_pmh.pmh07 = g_bnn[i].bnn04
       SELECT ima24 INTO l_pmh.pmh08 FROM ima_file
        WHERE ima01 = g_bnn[i].bnn03
       IF cl_null(l_pmh.pmh08) THEN LET l_pmh.pmh08 = 'Y' END IF
       LET l_pmh.pmh13 = l_pmc22
       IF g_aza.aza17 = l_pmh.pmh13 THEN
          LET l_pmh.pmh14 = 1
       ELSE
          CALL s_curr3(l_pmh.pmh13,g_today,'S') RETURNING l_pmh.pmh14
       END IF
       CASE WHEN g_bnm.bnm06='3'
                 LET l_pmh.pmh05 = '0'
                 LET l_pmh.pmh06 = g_bnn[i].bnn10
            WHEN g_bnm.bnm06='4'
                 LET l_pmh.pmh05 = '2'
                 LET l_pmh.pmh06 = ''
            OTHERWISE
                 LET l_pmh.pmh05 = '1'
                 LET l_pmh.pmh06 = ''
            EXIT CASE
       END CASE
       IF cl_null(l_pmh.pmh13) THEN LET l_pmh.pmh13=' ' END IF
       IF cl_null(l_pmh.pmh21) THEN LET l_pmh.pmh21=' ' END IF
       IF cl_null(l_pmh.pmh22) THEN LET l_pmh.pmh22='1' END IF
       SELECT ima100,ima101,ima102
          INTO l_pmh.pmh09,l_pmh.pmh15,l_pmh.pmh16
          FROM ima_file
         WHERE ima01=l_pmh.pmh01
 
       IF cl_null(l_pmh.pmh23) THEN LET l_pmh.pmh23=' ' END IF
       IF cl_null(l_pmh.pmh24) THEN LET l_pmh.pmh24='N' END IF   #FUN-940083
       LET l_pmh.pmhacti=g_bnm.bnmacti
       LET l_pmh.pmhuser=g_bnm.bnmuser
       LET l_pmh.pmhgrup=g_bnm.bnmgrup
       LET l_pmh.pmhoriu = g_user      #No.FUN-980030 10/01/04
       LET l_pmh.pmhorig = g_grup      #No.FUN-980030 10/01/04
       LET l_pmh.pmh25='N'   #No:FUN-AA0015
       INSERT INTO pmh_file VALUES(l_pmh.*)
       IF SQLCA.sqlcode  THEN
          CALL cl_err3("ins","pmh_file","","",SQLCA.sqlcode,"","",1)
          LET g_success = 'N'
       END IF
     END IF
END FUNCTION

#FUN-BC0018 add str---
FUNCTION t330_show_pic()
DEFINE l_chr3  LIKE type_file.chr1  #CHI-C80041
     IF g_bnm.bnm08 MATCHES '[1]' THEN
         LET g_chr1='Y'
         LET g_chr2='Y'
     ELSE
         LET g_chr1='N'
         LET g_chr2='N'
     END IF
     #CHI-C80041---begin
     IF g_bnm.bnm08 MATCHES '[9]' THEN
         LET l_chr3 = 'Y'
     ELSE
         LET l_chr3 = 'N'
     END IF 
     #CHI-C80041---end
     #CALL cl_set_field_pic(g_chr1,g_chr2,"","","",g_bnm.bnmacti) #CHI-C80041
     CALL cl_set_field_pic(g_chr1,g_chr2,"","",l_chr3,g_bnm.bnmacti)
# Memo          : ps_confirm 確認碼, ps_approve 核准碼, ps_post 過帳碼
#               : ps_close 結案碼, ps_void 作廢碼, ps_valid 有效碼
END FUNCTION
#FUN-BC0018 add end---
#FUN-930109        
#CHI-C80041---begin
#FUNCTION t330_v()   #CHI-D20010
FUNCTION t330_v(p_type)    #CHI-D20010
DEFINE   l_chr              LIKE type_file.chr1
DEFINE   l_chr1             LIKE type_file.chr1
DEFINE   l_flag             LIKE type_file.chr1  #CHI-D20010
DEFINE   p_type             LIKE type_file.chr1  #CHI-D20010

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_bnm.bnm01) THEN CALL cl_err('',-400,0) RETURN END IF  
   
   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_bnm.bnm08 ='9' THEN RETURN END IF
   ELSE
      IF g_bnm.bnm08 <>'9' THEN RETURN END IF
   END IF
   #CHI-D20010---end
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t330_cl USING g_bnm.bnm01
   IF STATUS THEN
      CALL cl_err("OPEN t330_cl:", STATUS, 1)
      CLOSE t330_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t330_cl INTO g_bnm.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bnm.bnm01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t330_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_bnm.bnm08 matches '[Ss1]' THEN 
      CALL cl_err("","mfg3557",1)  
      RETURN
   END IF  
   IF g_bnm.bnm08 = '0' THEN
      LET l_chr1 = 'N'
   ELSE
      LET l_chr1 = 'X'
   END IF 
   IF cl_void(0,0,l_chr1)   THEN 
        LET l_chr=g_bnm.bnm08
       #IF g_bnm.bnm08='0' THEN    #CHI-D20010
        IF p_type = 1 THEN         #CHI-D20010 
            LET g_bnm.bnm08='9' 
        ELSE 
           IF g_bnm.bnm08='9' THEN
              LET g_bnm.bnm08='0'
           END IF 
        END IF
        UPDATE bnm_file
            SET bnm08=g_bnm.bnm08,  
                bnmmodu=g_user,
                bnmdate=g_today
            WHERE bnm01=g_bnm.bnm01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","bnm_file",g_bnm.bnm01,"",SQLCA.sqlcode,"","",1)  
            LET g_bnm.bnm08=l_chr 
        END IF
        DISPLAY BY NAME g_bnm.bnm08 
   END IF
 
   CLOSE t330_cl
   COMMIT WORK
   CALL cl_flow_notify(g_bnm.bnm01,'V')
 
END FUNCTION
#CHI-C80041---end
