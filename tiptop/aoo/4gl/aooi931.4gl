# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aooi931.4gl
# Descriptions...: 集團架構資料建立作業
# Date & Author..: No.FUN-980017 09/08/05 By destiny
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980020 09/09/20 By douzh ACTION調整
# Modify.........: No.FUN-9A0020 09/11/03 By douzh 集团架构后续调整
# Modify.........: No:FUN-9A0092 09/11/05 by douzh local table设定增加判断,拿掉TRANS DB的存在于azp03的检查
# Modify.........: No:TQC-9B0202 09/11/24 by jan 1.insert/update 時， azwuser / grup / date / modi 等欄位無資料
#                                                2.azw05(實體DB) 處判斷該 實體db 有無存在別的法人資料中，如果有，則不可設定
#                                                3.拿掉azw05的開窗功能
# Modify.........: No:FUN-9B0150 09/11/30 by jan 同一法人下，只能有Single DB或Multi DB的架構，不可混合設定
# Modify.........: No:FUN-9C0048 09/12/14 by jan 新增azw08/azw09兩個欄位/營運中心的設定以這支作業為主
# Modify.........: No:TQC-9C0157 09/12/18 by jan 修改Multi DB的判斷方法
# Modify.........: No:FUN-9C0154 09/12/25 by Hiko 調整p_create_schema的相關呼叫方式
# Modify.........: No.FUN-A10018 10/01/07 By Hiko 設定虛擬Schema時,要增加azp04的預設值
# Modify.........: No.FUN-A10121 10/01/22 By Hiko 離開前要詢問是否開啟建立Schema的工具
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A30103 10/04/01 by jay add action call p_ods_db
# Modify.........: No.FUN-A20056 10/04/08 by tommas add action call p_erp_sch
# Modity.........: No.FUN-A40090 10/05/03 by Alan  資料庫命名規則
# Modify.........: No.FUN-A50079 10/05/20 by tommas 1.資料庫設定第一碼不能為數字:azw05,azw06兩欄位要判斷
# Modify.........:                                  2.檢查登入DB，並建議可以設定成相同名稱。
# Modify.........: No.FUN-A60016 10/07/02 by johnson 開放登入DB建立後仍可異動.
# Modify.........: No.FUN-A70115 10/07/26 by Kevin 功能加強:可以獨立重跑虛擬DB的View重建
# Modify.........: No.FUN-A80148 10/08/31 by huangtao  原招商門店資料維護併入零售門店中
# Modify.........: NO:FUN-AA0054 10/10/21 By shiwuying 同步到32区
# Modify.........: NO:FUN-A80117 10/11/05 By huangtao 更新rtz_file
# Modify.........: No.MOD-AC0228 10/12/20 By baogc 修改插入rtz_file時rtz09的值
# Modify.........: No.FUN-B30165 11/03/22 By huangtao 將營運中心代碼azw01強制轉換成大寫
# Modify.........: No:FUN-B40071 11/04/29 by jason 已傳POS否狀態調整
# Modify.........: No:FUN-B50089 11/05/16 by jay 增加刪除schema相關資訊
# Modify.........: No.FUN-B50065 11/06/08 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B50039 11/07/04 By xianghui 增加自訂欄位
# Modify.........: No.TQC-B70199 11/07/26 By fengrui  修改自訂欄位
# Modify.........: No.FUN-B70115 11/08/01 BY laura    刪除營運中心增加zx_file檢核機制        11/08/10雄傑限制太嚴暫先取消
# Modify.........: No:FUN-B80035 11/08/03 By Lujh 模組程序撰寫規範修正
# Modify.........: No:TQC-C20124 12/02/14 By fanbj arti200測量面積默認值給0
# Modify.........: No:FUN-C50036 12/06/01 By yangxf 新增时给rtz31,rtz32,rtz33赋初值
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D40030 13/04/09 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-D50129 13/05/15 By suncx 刪除營運中心同時，刪除p_zxy中對應資料

IMPORT os      #FUN-B50089
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-980017---Begin
 
DEFINE
     g_azw02          LIKE azw_file.azw02,
     g_azw09          LIKE azw_file.azw09,  #FUN-9C0048  
     g_azw02_t        LIKE azw_file.azw02, 
     g_azw           DYNAMIC ARRAY OF RECORD 
        azw01       LIKE azw_file.azw01,  
       #azp02       LIKE azp_file.azp02,  #FUN-9C0048
        azw08       LIKE azw_file.azw08,  #FUN-9C0048
        azw03       LIKE azw_file.azw03,
        azw04       LIKE azw_file.azw04,
        azw05       LIKE azw_file.azw05,
        azw06       LIKE azw_file.azw06, 
        azwacti     LIKE azw_file.azwacti,    
        #FUN-B50039-add-str--
        azwud01     LIKE azw_file.azwud01,
        azwud02     LIKE azw_file.azwud02,
        azwud03     LIKE azw_file.azwud03,
        azwud04     LIKE azw_file.azwud04,
        azwud05     LIKE azw_file.azwud05,
        azwud06     LIKE azw_file.azwud06,
        azwud07     LIKE azw_file.azwud07,
        azwud08     LIKE azw_file.azwud08,
        azwud09     LIKE azw_file.azwud09,
        azwud10     LIKE azw_file.azwud10,
        azwud11     LIKE azw_file.azwud11,
        azwud12     LIKE azw_file.azwud12,
        azwud13     LIKE azw_file.azwud13,
        azwud14     LIKE azw_file.azwud14,
        azwud15     LIKE azw_file.azwud15
        #FUN-B50039-add-end--
                    END RECORD,
     g_azw_t         RECORD          
        azw01       LIKE azw_file.azw01,  
       #azp02       LIKE azp_file.azp02,  #FUN-9C0048
        azw08       LIKE azw_file.azw08,  #FUN-9C0048
        azw03       LIKE azw_file.azw03,
        azw04       LIKE azw_file.azw04,
        azw05       LIKE azw_file.azw05,
        azw06       LIKE azw_file.azw06, 
        azwacti     LIKE azw_file.azwacti,
        #FUN-B50039-add-str--
        azwud01     LIKE azw_file.azwud01,
        azwud02     LIKE azw_file.azwud02,
        azwud03     LIKE azw_file.azwud03,
        azwud04     LIKE azw_file.azwud04,
        azwud05     LIKE azw_file.azwud05,
        azwud06     LIKE azw_file.azwud06,
        azwud07     LIKE azw_file.azwud07,
        azwud08     LIKE azw_file.azwud08,
        azwud09     LIKE azw_file.azwud09,
        azwud10     LIKE azw_file.azwud10,
        azwud11     LIKE azw_file.azwud11,
        azwud12     LIKE azw_file.azwud12,
        azwud13     LIKE azw_file.azwud13,
        azwud14     LIKE azw_file.azwud14,
        azwud15     LIKE azw_file.azwud15
        #FUN-B50039-add-end--  
                    END RECORD,        
       
    g_wc,g_sql,g_wc2  STRING,                                                   
    g_show            LIKE type_file.chr1,         
    g_rec_b           LIKE type_file.num5,    #單身筆數 
    g_flag            LIKE type_file.chr1,                             
    l_ac              LIKE type_file.num5     #目前處理                               
 
#FUN-980020--begin
DEFINE g_gat      DYNAMIC ARRAY OF RECORD        
                  sel     LIKE type_file.chr1,     # 選擇
                  gat01   LIKE gat_file.gat01,     # 檔案代號
                  gat03   LIKE gat_file.gat03,     # 檔案名稱
                  gat07   LIKE gat_file.gat07      # 檔案類別
                  END RECORD 
DEFINE g_gat_t     RECORD        
                  sel     LIKE type_file.chr1,     # 選擇-舊值
                  gat01   LIKE gat_file.gat01,     # 檔案代號-舊值
                  gat03   LIKE gat_file.gat03,     # 檔案名稱-舊值
                  gat07   LIKE gat_file.gat07      # 檔案類別-舊值
                  END RECORD 
DEFINE   g_cnt1                LIKE type_file.num10      
DEFINE   g_azy                 RECORD LIKE azy_file.* 
#FUN-980020--end
 
DEFINE   p_row,p_col    LIKE type_file.num5                                                                       
DEFINE   g_forupd_sql STRING                  #SELECT ... FOR UPDATE SQL                       
DEFINE   g_sql_tmp    STRING                              
DEFINE   g_before_input_done   LIKE type_file.num5     
DEFINE   g_chr                 LIKE type_file.chr1
DEFINE   g_cnt                 LIKE type_file.num10      
DEFINE   g_msg         LIKE ze_file.ze03            
DEFINE   g_jump        LIKE type_file.num10   
DEFINE   g_abso        LIKE type_file.num10   
DEFINE   g_row_count   LIKE type_file.num10       
DEFINE   g_curs_index  LIKE type_file.num10          
DEFINE   mi_no_ask     LIKE type_file.num5
DEFINE   l_cmd         LIKE type_file.chr1000  
DEFINE   g_str         STRING
DEFINE   g_rec_b1      LIKE type_file.num5       #Local檔案設定單身筆數   #FUN-9A0092
DEFINE   l_ac1         LIKE type_file.num5       #Local檔案設定目前處理   #FUN-9A0092
DEFINE   l_ac1_t       LIKE type_file.num5       #Local檔案設定目前處理   #FUN-9A0092
DEFINE   g_rebuild_ods LIKE type_file.chr1       #FUN-B50089:是否需重新rebuild ods


MAIN                                                                            
                                                                                
   OPTIONS                               #改變一些系統預設值                   
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理               
                                                                                
   IF (NOT cl_user()) THEN                                                      
      EXIT PROGRAM                                                              
   END IF                                                                       
 
   WHENEVER ERROR CALL cl_err_msg_log                                           
                                                                                
   IF (NOT cl_setup("aoo")) THEN                                                
      EXIT PROGRAM                                                              
   END IF 
 
                                                                        
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   LET p_row = 3 LET p_col = 16
   OPEN WINDOW i931_w AT p_row,p_col
     WITH FORM "aoo/42f/aooi931"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   LET g_rebuild_ods = FALSE   #FUN-B50089
   CALL i931_menu()
   CALL cl_set_combo_industry("azw03")
   CLOSE WINDOW i931_w                 #結束畫面 
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
#QBE 查詢資料                                                                   
FUNCTION i931_cs()                                                              
DEFINE l_sql STRING  
                                                           
   CLEAR FORM 
   CALL g_azw.clear() 
   CALL cl_set_combo_industry("azw03")
                                                                                     
       INITIALIZE g_azw02 TO NULL                    
       INITIALIZE g_azw09 TO NULL         #FUN-9C0048           
       CONSTRUCT g_wc ON azw02,azw09,azw01,azw08,azw03,azw04,azw05,azw06,azwacti, #FUN-9C0048
            #FUN-B50039-add-str--
            azwud01,azwud02,azwud03,azwud04,azwud05,azwud06,azwud07,azwud08,
            azwud09,azwud10,azwud11,azwud12,azwud13,azwud14,azwud15
            #FUN-B50039-add-end--
            FROM azw02,azw09,s_azw[1].azw01,s_azw[1].azw08,s_azw[1].azw03,s_azw[1].azw04, #FUN-9C0048
            s_azw[1].azw05,s_azw[1].azw06,s_azw[1].azwacti,
            #FUN-B50039-add-str--
            s_azw[1].azwud01,s_azw[1].azwud02,s_azw[1].azwud03,s_azw[1].azwud04,s_azw[1].azwud05,
           # s_azw[1].azwud07,s_azw[1].azwud08,s_azw[1].azwud08,s_azw[1].azwud09,s_azw[1].azwud10,
            s_azw[1].azwud06,s_azw[1].azwud07,s_azw[1].azwud08,s_azw[1].azwud09,s_azw[1].azwud10, #TQC-B70199
            s_azw[1].azwud11,s_azw[1].azwud12,s_azw[1].azwud13,s_azw[1].azwud14,s_azw[1].azwud15
            #FUN-B50039-add-end--
                
       BEFORE CONSTRUCT                                                         
          CALL cl_qbe_init()                     
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(azw02)
                CALL cl_init_qry_var()
                LET g_qryparam.form  ="q_azw02"
                LET g_qryparam.state ="c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO azw02
                NEXT FIELD azw02
#FUN-9C0048--begin--mark---
#            WHEN INFIELD(azw01)                                                
#               CALL cl_init_qry_var()                                          
#               LET g_qryparam.form  ="q_azw01"                                   
#               LET g_qryparam.state ="c"                                  
#               CALL cl_create_qry() RETURNING g_qryparam.multiret              
#               DISPLAY g_qryparam.multiret TO azw01                           
#               NEXT FIELD azw01
#FUN-9C0048--end--mark---
#TQC-9B0202--begin--mark-------
#            WHEN INFIELD(azw05)                                                
#               CALL cl_init_qry_var()                                          
#               LET g_qryparam.form  ="q_azw05"                                   
#               LET g_qryparam.state ="c"                                  
#               CALL cl_create_qry() RETURNING g_qryparam.multiret              
#               DISPLAY g_qryparam.multiret TO azw05                           
#               NEXT FIELD azw05
#TQC-9B0202--end--mark-----------
             WHEN INFIELD(azw06)                                                
                CALL cl_init_qry_var()                                          
                LET g_qryparam.form  ="q_azw06"                                   
                LET g_qryparam.state ="c"                                  
                CALL cl_create_qry() RETURNING g_qryparam.multiret              
                DISPLAY g_qryparam.multiret TO azw06                           
                NEXT FIELD azw06                
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
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('azwuser', 'azwgrup') #FUN-980030
 
       IF INT_FLAG THEN
          RETURN
       END IF
 
    IF cl_null(g_wc) THEN
       LET g_wc="1=1"
    END IF
    
    LET l_sql="SELECT UNIQUE azw02 FROM azw_file ",
              " WHERE ", g_wc CLIPPED
    LET g_sql= l_sql," ORDER BY azw02"       
    PREPARE i931_prepare FROM g_sql      #預備一下                              
    DECLARE i931_bcs                     #宣告成動的                        
      SCROLL CURSOR WITH HOLD FOR i931_prepare                                
 
    LET g_sql = "SELECT COUNT(UNIQUE azw02) FROM azw_file WHERE ",g_wc CLIPPED  
    PREPARE i931_precount FROM g_sql    
    DECLARE i931_count CURSOR FOR i931_precount
 
    CALL i931_show()
END FUNCTION     
 
FUNCTION i931_menu()
   DEFINE l_log_file STRING, #FUN-9C0154:rebuild_ods_view結束後,彈出訊息使用的變數.
          l_flag BOOLEAN #這只是為了離開前接收p_create_schema的回傳值
   DEFINE l_view_db  STRING  #FUN-A70115
 
   WHILE TRUE
      CALL i931_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i931_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i931_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i931_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i931_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i931_b()
               IF g_flag = 'Y' THEN  #FUN-9C0048
                  CALL i931_b2()   #FUN-9C0048
                  CALL i931_b3()   #FUN-9C0048
               END IF              #FUN-9C0048
            ELSE
               LET g_action_choice = NULL
            END IF
#FUN-980020--begin
#FUN-9C0048--mark----begin----
#       WHEN "set_loctab"
#          IF cl_chk_act_auth() THEN
#             CALL i931_settb(g_azw[l_ac].azw06) 
#          ELSE
#             LET g_action_choice = NULL
#          END IF
#FUN-9C0048--end--mark--
#FUN-980020--end

#FUN-9C0048--bengin--add---
        WHEN "create_db1"
          IF NOT cl_null(g_azw02) THEN
             IF cl_chk_act_auth() THEN
                #FUN-9C0154:Begin
                #CALL cl_cmdrun("p_create_schema")
                #Begin:FUN-A10121
                #IF NOT p_create_schema() THEN
                #   #成功的訊息會在p_create_schema裡面呈現,但是一開始若是判斷沒有新的Schema需要建立的話,則此訊息要在這裡設定,
                #   #因為此段程式會和離開aooi931時的判斷共用,而離開時是不需要顯現訊息的,這樣會比較妥當.
                #   CALL p_create_schema_info("azz1010", NULL)
                #END IF
                CALL p_create_schema()
                #End:FUN-A10121
                #FUN-9C0154:End
             ELSE
                LET g_action_choice = NULL
             END IF
          END IF   
#FUN-9C0048--end--add----

         #FUN-9C0154:Begin
         WHEN "rebuild_ods_view"
            IF cl_chk_act_auth() THEN
               IF p_create_schema_conf("azz1012") THEN
                  CALL p_create_schema_rebuild_ods_view() RETURNING l_log_file
                  CALL p_create_schema_info("azz1011", l_log_file)
               END IF
            END IF
         #FUN-9C0154:End

         WHEN "rebuild_view"  #FUN-A70115
            IF cl_chk_act_auth() THEN         	
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azw03"               
               CALL cl_create_qry() RETURNING l_view_db
               IF NOT cl_null(l_view_db) THEN
                  IF p_create_schema_conf("azz1019") THEN
                     CALL p_create_schema_rebuild_syn_view(l_view_db)
                     CALL p_create_schema_info("azz1014", "")
                  END IF
               END IF
            END IF               
               
         #FUN-A30103:Begin
         WHEN "ods_db"
            CALL cl_cmdrun("p_ods_db")
         #FUN-A30103:End

#No.FUN-A20056 add start -------------
         WHEN "erp_sch"
            CALL cl_cmdrun("p_erp_sch")
#No.FUN-A20056 add end   -------------

         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            #Begin:FUN-A10121
            IF NOT cl_null(g_azw02) THEN #用法人欄位來判斷畫面上是否有資料
               IF p_create_schema_prep() THEN #還有Schema未建立
                  IF p_create_schema_conf("azz1022") THEN
                     #CALL p_create_schema() RETURNING l_flag
                     CALL p_create_schema() #FUN-A10121:不需要再回傳了,因為這裡已經改用p_create_schema_prep()來判斷是否要開啟.
                  END IF
               END IF
            END IF
            #End:FUN-A10121

            #---FUN-B50089---start-----   
            #詢問使用者是否需重建ods view
            IF g_rebuild_ods THEN
               IF p_create_schema_conf("azz1048") THEN
                  CALL p_create_schema_rebuild_ods_view() RETURNING l_log_file
                  CALL p_create_schema_info("azz1011", l_log_file)
               END IF
            END IF
            #---FUN-B50089---end-------
            
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_azw),'','')
            END IF
         WHEN "related_document"           
            IF cl_chk_act_auth() THEN
               IF g_azw02 IS NOT NULL THEN
                  LET g_doc.column1 = "azw02"
                  LET g_doc.value1 = g_azw02
                  CALL cl_doc()
               END IF 
            END IF
      END CASE
   END WHILE
END FUNCTION     
 
FUNCTION i931_a()                                                               
   MESSAGE ""                                                                   
   CLEAR FORM                                                                   
   CALL g_azw.clear()
 
   IF s_shut(0) THEN RETURN END IF                #浪 d v  
 
   LET g_azw02 = NULL                                                           
   LET g_azw02_t = NULL
   LET g_azw09 = NULL    #FUN-9C0048                                                       
   
   CALL cl_opmsg('a')                                                           
                                                                                
    WHILE TRUE                                                            
       CALL i931_i("a")                   #塊 J蟲 Y                             
       IF INT_FLAG THEN                   #ㄏ     F                         
          LET INT_FLAG = 0                                                      
          CALL cl_err('',9001,0)   
          CLEAR FORM                                              
          EXIT WHILE                                                            
       END IF                                                                   
       IF cl_null(g_azw02) THEN                                                 
          CONTINUE WHILE                                                        
       END IF                
       IF SQLCA.sqlcode THEN                                                    
          CALL cl_err(g_azw02,SQLCA.sqlcode,1)
          ROLLBACK WORK                       	                                  
#         CALL cl_err(g_azw02,SQLCA.sqlcode,1)   # 檢測ROLLBACK WORK接下來卻又出現SQLCA.sqlcode,發現錯誤
       ELSE                                                                     
          COMMIT WORK                                                           
       END IF
 
       CALL g_azw.clear()                                                       
       LET g_rec_b = 0                                                          
       DISPLAY g_rec_b TO FORMONLY.cn2                                          
                                                                                
       CALL i931_b()                      #塊 J蟲                               
       IF g_flag = 'Y' THEN   #FUN-9C0048
          CALL i931_b2()   #FUN-9C0048
          CALL i931_b3()   #FUN-9C0048
       END IF              #FUN-9C0048
                                                                                
       LET g_azw02_t = g_azw02            # O d侶                               
       EXIT WHILE                                                               
    END WHILE                                                                   
    LET g_wc=' ' 
                                                    
END FUNCTION                 
 
FUNCTION i931_i(p_cmd)                                                          
DEFINE                                                                          
    p_cmd           LIKE type_file.chr1,       #a:輸入 u:更改   
    l_cnt           LIKE type_file.num10,      
    l_n             LIKE type_file.num5
                                                                                
                                                             
                         
    INPUT g_azw02 WITHOUT DEFAULTS FROM azw02                                     
 
       AFTER FIELD azw02 
          IF NOT cl_null(g_azw02) THEN 
             IF g_azw02 != g_azw02_t OR
                g_azw02_t IS NULL THEN
                CALL i931_azw02(g_azw02,'a')
                SELECT count(*) INTO l_n FROM azw_file
                 WHERE azw02 = g_azw02
                IF cl_null(g_errno) AND l_n> 0 THEN
                   LET g_errno ='-239'
                END IF 
                IF NOT cl_null(g_errno) THEN                 
                   CALL cl_err(g_azw02,g_errno,1)  
                   LET g_azw02=g_azw02_t
                   NEXT FIELD azw02
                END IF
             END IF
          END IF   
                                                                
       AFTER INPUT          
          IF INT_FLAG THEN
             EXIT INPUT
          END IF                                                    
          IF g_azw02 IS NULL THEN               
             NEXT FIELD azw02                  
          END IF 
 
         ON ACTION CONTROLP                                                       
            CASE                                                                  
              WHEN INFIELD(azw02)                                                
                CALL cl_init_qry_var()                                          
                LET g_qryparam.form  ="q_azt"                                   
                LET g_qryparam.default1 = g_azw02              
                CALL cl_create_qry() RETURNING g_azw02               
                DISPLAY g_azw02 TO azw02                               
                NEXT FIELD azw02
              OTHERWISE EXIT CASE
            END CASE        
 
         ON ACTION CONTROLG                                                     
           CALL cl_cmdask()                                                     
                                                                                
         ON IDLE g_idle_seconds                                                 
           CALL cl_on_idle()                                                    
           CONTINUE INPUT                                                       
                                                                                
         ON ACTION about                                       
            CALL cl_about()                                     
                                                                                
         ON ACTION help                                        
            CALL cl_show_help()                                
                                                                                
         ON ACTION CONTROLF                  #欄位說明                            
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)                          
    END INPUT          
END FUNCTION
 
FUNCTION i931_q()                                                               
   LET g_azw02 = ''                                                                                                                                                                                   
   LET g_row_count = 0                                                          
   LET g_curs_index = 0                                                         
   CALL cl_navigator_setting( g_curs_index, g_row_count )                       
   INITIALIZE g_azw02 TO NULL                            
   INITIALIZE g_azw09 TO NULL       #FUN-9C0048                     
   MESSAGE ""                                                                   
   CALL cl_opmsg('q')                                                           
   CLEAR FORM                                                                   
   CALL g_azw.clear()                                                           
   DISPLAY '' TO FORMONLY.cnt                                                   
                                                                                
   CALL i931_cs()                      #取得查詢條件                            
                                                                                
   IF INT_FLAG THEN                    #使用者不玩了                            
      LET INT_FLAG = 0         
      INITIALIZE g_azw02 TO NULL                                        
      INITIALIZE g_azw09 TO NULL       #FUN-9C0048                                 
      RETURN                                                                    
   END IF                                                                       
                                                                                
   OPEN i931_bcs                       #從DB產生合乎條件TEMP(0-30秒)            
   IF SQLCA.sqlcode THEN               #有問題                                  
      CALL cl_err('',SQLCA.sqlcode,0)                                           
      INITIALIZE g_azw02 TO NULL 
      INITIALIZE g_azw09 TO NULL       #FUN-9C0048                                 
   ELSE                                                                         
      OPEN i931_count                                                           
      FETCH i931_count INTO g_row_count   
      DISPLAY g_row_count TO FORMONLY.cnt                                       
      CALL i931_fetch('F')            #讀出TEMP第一筆并顯示                     
   END IF                                                                       
                                                                                
END FUNCTION     
 
#處理資料的讀取                                                                 
FUNCTION i931_fetch(p_flag)                                                     
DEFINE                                                                          
   p_flag          LIKE type_file.chr1    #處理方式       
                                                                                
   MESSAGE ""                                                                   
   CASE p_flag                                                                  
       WHEN 'N' FETCH NEXT     i931_bcs INTO g_azw02                   
       WHEN 'P' FETCH PREVIOUS i931_bcs INTO g_azw02             
       WHEN 'F' FETCH FIRST    i931_bcs INTO g_azw02       
       WHEN 'L' FETCH LAST     i931_bcs INTO g_azw02
       WHEN '/'  
         IF (NOT mi_no_ask) THEN                                                              
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg                      
            LET INT_FLAG = 0                            
            PROMPT g_msg CLIPPED,': ' FOR g_abso  
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
            FETCH ABSOLUTE g_abso i931_bcs 
                  INTO g_azw02
            LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN                     #有麻煩
      CALL cl_err(g_azw02,SQLCA.sqlcode,0)
      INITIALIZE g_azw02 TO NULL  
      INITIALIZE g_azw09 TO NULL  #FUN-9C0048
   ELSE
     #CALL i931_show()   #FUN-9C0048
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_abso
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
   #FUN-9C0048--begin--add--
   SELECT UNIQUE azw09 INTO g_azw09 FROM azw_file
    WHERE azw02 = g_azw02
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","azw_file",g_azw02,"",SQLCA.sqlcode,"","",0)
   ELSE
     CALL i931_show()
   END IF
   #FUN-9C0048--end--add----
 
END FUNCTION
 
                                                             
FUNCTION i931_show()                                                            
  
   DISPLAY g_azw02 TO azw02
   DISPLAY g_azw09 TO azw09   #FUN-9C0048
 
   CALL i931_azw02(g_azw02,'d')                                                                             
   CALL i931_b_fill(g_wc)                      #單身                            
   CALL cl_show_fld_cont()                             
END FUNCTION
 
                                                                     
FUNCTION i931_b()                                                               
DEFINE                                                                          
   l_ac_t          LIKE type_file.num5,          #未取消的ARRAY CNT 
   l_n             LIKE type_file.num5,          #檢查重復用        
   l_n1            LIKE type_file.num5,          #檢查重復用        
   l_lock_sw       LIKE type_file.chr1,          #單身鎖住否        
   p_cmd           LIKE type_file.chr1,          #處理狀態         
   l_allow_insert  LIKE type_file.num5,          #可新增否         
   l_allow_delete  LIKE type_file.num5,          #可刪除否         
   l_cnt           LIKE type_file.num10,     
   l_azp053        LIKE azp_file.azp053,
   l_rtz28         LIKE rtz_file.rtz28,           #FUN-A80148
   l_rtzpos        LIKE rtz_file.rtzpos,          #FUN-A80148
   l_azwacti       LIKE azw_file.azwacti,         #FUN-A80148
   l_azp03         LIKE azp_file.azp03,           #FUN-B50089
   l_zxcnt         LIKE type_file.num10           #FUN-B70115
   
DEFINE l_rtzpos2      LIKE rtz_file.rtzpos        #FUN-B40071
                                                                               
   LET g_action_choice = ""
   LET g_flag = 'N'   #FUN-9C0048
                                                                               
   IF cl_null(g_azw02) THEN   
      CALL cl_err('',-400,1)                                                    
      RETURN                                        
   END IF                                                                       
                                                                                
   IF s_shut(0) THEN                                                            
      RETURN                                                                    
   END IF           
  
           
   CALL cl_opmsg('b')
   CALL cl_set_combo_industry("azw03")
   LET g_forupd_sql = "SELECT azw01,azw08,azw03,azw04,azw05,azw06,azwacti,",  #FUN-9C0048
                      "       azwud01,azwud02,azwud03,azwud04,azwud05,    ",  #FUN-B50039
                      "       azwud06,azwud07,azwud08,azwud09,azwud10,    ",  #FUN-B50039
                      "       azwud11,azwud12,azwud13,azwud14,azwud15     ",  #FUN-B50039
                      " FROM azw_file",
                      " WHERE azw02 = ? AND azw01 = ?  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i931_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_azw WITHOUT DEFAULTS FROM s_azw.*
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
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_azw02_t = g_azw02
            LET g_azw_t.* = g_azw[l_ac].*  #BACKUP
#           CALL cl_set_combo_industry("azw03")
            OPEN i931_bcl USING g_azw02,g_azw[l_ac].azw01
            IF STATUS THEN
               CALL cl_err("OPEN i931_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i931_bcl INTO g_azw[l_ac].*
               IF STATUS THEN
                  CALL cl_err("OPEN i931_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            
            #No.FUN-A60016--Begin

            ##FUN-9C0048--begin--add------
            #CALL cl_set_comp_entry("azw05,azw06",TRUE)
            #IF cl_chk_schema_has_built(g_azw[l_ac].azw06) THEN
            #   CALL cl_set_comp_entry("azw05,azw06",FALSE)
            #END IF
            ##FUN-9C0048--end--add------

            CALL i931_set_entry_b(p_cmd)
            IF cl_chk_schema_has_built(g_azw[l_ac].azw05) THEN
               CALL i931_set_no_entry_b(p_cmd)
            END IF 

            #No.FUN-A60016--End

           #CALL i931_azw01()   #FUN-9C0048
            CALL cl_show_fld_cont()     
         END IF
  
      BEFORE INSERT                                                             
         LET l_n = ARR_COUNT()                                                  
         LET p_cmd='a'                                                          
         LET g_before_input_done = FALSE
         INITIALIZE g_azw[l_ac].* TO NULL                   
         LET g_before_input_done = TRUE
         LET g_azw[l_ac].azw03='std'
         LET g_azw[l_ac].azw04='1'
         LET g_azw[l_ac].azwacti='Y'
         LET g_azw_t.* = g_azw[l_ac].*               #新輸入資料                
         CALL cl_show_fld_cont()

         #No.FUN-A60016--Begin
                                                
         #CALL cl_set_comp_entry("azw05,azw06",TRUE)  #FUN-9C0048
         CALL i931_set_entry_b(p_cmd)

         #No.FUN-A60016--end

         NEXT FIELD azw01 
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         LET g_azw[l_ac].azw01 = UPSHIFT(g_azw[l_ac].azw01)        #FUN-B30165 add
         INSERT INTO azw_file(azw01,azw02,azw03,azw04,azw05,azw06,azwacti,
                              azwuser,azwgrup,azwdate,azw08,azw09,azworiu,azworig,  #TQC-9B0202 #FUN-9C0048
                              azwud01,azwud02,azwud03,azwud04,azwud05,        #FUN-B50039
                              azwud06,azwud07,azwud08,azwud09,azwud10,        #FUN-B50039
                              azwud11,azwud12,azwud13,azwud14,azwud15)        #FUN-B50039
               VALUES(g_azw[l_ac].azw01,g_azw02,g_azw[l_ac].azw03,g_azw[l_ac].azw04,
                      g_azw[l_ac].azw05,g_azw[l_ac].azw06,g_azw[l_ac].azwacti,
                      g_user,g_grup,g_today,g_azw[l_ac].azw08,g_azw09, g_user, g_grup,  #TQC-9B0202 #FUN-9C0048      #No.FUN-980030 10/01/04  insert columns oriu, orig
                      g_azw[l_ac].azwud01,g_azw[l_ac].azwud02,g_azw[l_ac].azwud03,      #FUN-B50039
                      g_azw[l_ac].azwud04,g_azw[l_ac].azwud05,g_azw[l_ac].azwud06,      #FUN-B50039
                      g_azw[l_ac].azwud07,g_azw[l_ac].azwud08,g_azw[l_ac].azwud09,      #FUN-B50039
                      g_azw[l_ac].azwud10,g_azw[l_ac].azwud11,g_azw[l_ac].azwud12,      #FUN-B50039
                      g_azw[l_ac].azwud13,g_azw[l_ac].azwud14,g_azw[l_ac].azwud15)      #FUN-B50039
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","azw_file",g_azw02,SQLCA.sqlcode,"","","",1)  
            CANCEL INSERT
         ELSE
#FUN-A80148 ----start
         #  INSERT INTO rtz_file(rtz01,rtz03,rtz11,rtzpos,rtz12,rtz13,rtz14,rtz15,rtz22,rtz23,rtz28,rtzcrat,rtzgrup,rtzorig,rtzoriu,rtzuser )   #FUN-A80117 mod  #MOD-AC0228 MARK
         #  INSERT INTO rtz_file(rtz01,rtz03,rtz09,rtz11,rtzpos,rtz12,rtz13,rtz14,rtz15,rtz22,rtz23,rtz28,rtzcrat,rtzgrup,rtzorig,rtzoriu,rtzuser ) #MOD-AC0228 ADD #TQC-C20124 mark
         #  INSERT INTO rtz_file(rtz01,rtz03,rtz09,rtz11,rtzpos,rtz12,rtz13,rtz14,rtz15,rtz22,rtz30,rtz23,rtz28,rtzcrat,rtzgrup,rtzorig,rtzoriu,rtzuser )    #TQC-C20124 add    #FUN-C50036 MARK
         #  VALUES(g_azw[l_ac].azw01,' ','N','N',' ',g_azw[l_ac].azw08,0,0,0,0,'N',g_today,g_grup,g_grup,g_user,g_user)              #FUN-A80117 mod   #MOD-AC0228 MARK
         #   VALUES(g_azw[l_ac].azw01,' ',0,'N','1',' ',g_azw[l_ac].azw08,0,0,0,0,'N',g_today,g_grup,g_grup,g_user,g_user)            #MOD-AC0228 ADD #FUN-B40071    #TQC-C20124 mark
         #  VALUES(g_azw[l_ac].azw01,' ',0,'N','1',' ',g_azw[l_ac].azw08,0,0,0,0,0,'N',g_today,g_grup,g_grup,g_user,g_user)              #TQC-C20124  add            #FUN-C50036 MARK
            INSERT INTO rtz_file(rtz01,rtz03,rtz09,rtz11,rtzpos,rtz12,rtz13,rtz14,rtz15,rtz22,rtz30,rtz23,rtz28,rtzcrat,rtzgrup,rtzorig,rtzoriu,rtzuser,rtz31,rtz32,rtz33) #FUN-C50036 add 
            VALUES(g_azw[l_ac].azw01,' ',0,'N','1',' ',g_azw[l_ac].azw08,0,0,0,0,0,'N',g_today,g_grup,g_grup,g_user,g_user,100,100,100)       #FUN-C50036 add    
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","rtz_file",g_azw[l_ac].azw01,SQLCA.sqlcode,"","","",1)
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               COMMIT WORK
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
#FUN-A80148  ---end
        END IF
    
      AFTER FIELD azw01                         # check data  是否重復
          IF NOT cl_null(g_azw[l_ac].azw01) THEN 
             IF g_azw[l_ac].azw01 != g_azw_t.azw01 OR
                g_azw_t.azw01 IS NULL THEN
                LET g_azw[l_ac].azw01 = UPSHIFT(g_azw[l_ac].azw01)        #FUN-B30165 add
                CALL i931_azw01()
                SELECT COUNT(*) INTO l_n FROM azw_file 
                 WHERE azw01=g_azw[l_ac].azw01 
                IF cl_null(g_errno) AND l_n> 0 THEN
                   LET g_errno ='atm-310'
                END IF 
                IF NOT cl_null(g_errno) THEN                 
                   CALL cl_err(g_azw[l_ac].azw01,g_errno,1)  
                   LET g_azw[l_ac].azw01=g_azw_t.azw01
                   NEXT FIELD azw01
                END IF  
#FUN-A80148  ----start
                IF p_cmd = 'u' THEN
                   SELECT rtz28 INTO l_rtz28 FROM rtz_file
                  # WHERE rtz01 = g_azw[l_ac].azw01
                    WHERE rtz01 = g_azw_t.azw01 #20101012 By shi
                   IF l_rtz28 = 'Y' THEN
                      CALL cl_err('','aoo-421',0)
                      LET g_azw[l_ac].azw01 = g_azw_t.azw01
                      NEXT FIELD azw01
                   END IF
                END IF 
#FUN-A80148  ------end               
              END IF
           END IF   
      BEFORE FIELD azw03
           LET g_azw[l_ac].azw03=FGL_DIALOG_GETBUFFER()              
      AFTER FIELD azw03
           LET g_azw[l_ac].azw03=FGL_DIALOG_GETBUFFER()     
 
      #TQC-9B0202--begin--add------------
      AFTER FIELD azw05
          IF NOT cl_null(g_azw[l_ac].azw05) THEN

             IF NOT i931_chk_dbname(g_azw[l_ac].azw05) THEN  #FUN-A50079  
                NEXT FIELD azw05                             #FUN-A50079 
             END IF                                          #FUN-A50079

             IF g_azw[l_ac].azw05 != g_azw_t.azw05 OR
                g_azw_t.azw05 IS NULL THEN
                IF g_azw[l_ac].azw05='ods'OR g_azw[l_ac].azw05='wds' OR  #FUN-9C0048
                   g_azw[l_ac].azw05='boe' THEN  #FUN-9C0048
                   NEXT FIELD azw05  #FUN-9C0048
                END IF   #FUN-9C0048
                LET l_n1 = 0
                SELECT count(*) INTO l_n1 FROM azw_file
                 WHERE azw05 = g_azw[l_ac].azw05
                   AND azw02 <> g_azw02
                IF l_n1 > 0 THEN
                   CALL cl_err('','aoo-258',0)
                   NEXT FIELD azw05
                END IF
                IF NOT cl_null(g_azw[l_ac].azw06) THEN  #FUN-9C0048
                   IF i931_azw05_a() THEN NEXT FIELD azw05 END IF  #FUN-9B0150
                END IF   #FUN-9C0048
              END IF
              IF NOT cl_null(g_azw[l_ac].azw06) THEN  #FUN-9C0048
                 CALL i931_azw05(p_cmd)  #FUN-9B0150
              END IF  #FUN-9C0048
            
          END IF
      #TQC-9B0202--end--add-----------------

      #FUN-9C0048--begin--add------
      AFTER FIELD azw06
          IF NOT cl_null(g_azw[l_ac].azw06) THEN

             IF NOT i931_chk_dbname(g_azw[l_ac].azw06) THEN  #FUN-A50079
                NEXT FIELD azw06                             #FUN-A50079
             END IF                                          #FUN-A50079

             IF g_azw[l_ac].azw06 != g_azw_t.azw06 OR
                g_azw_t.azw06 IS NULL THEN
                IF g_azw[l_ac].azw06='ods'OR g_azw[l_ac].azw06='wds' OR
                   g_azw[l_ac].azw06='boe' THEN
                   NEXT FIELD azw06
                END IF
                LET l_n1 = 0
                SELECT count(*) INTO l_n1 FROM azw_file
                 WHERE azw06 = g_azw[l_ac].azw06
                   AND azw02 <> g_azw02
                IF l_n1 > 0 THEN
                   CALL cl_err('','aoo-259',0)
                   NEXT FIELD azw06
                END IF
                IF NOT cl_null(g_azw[l_ac].azw05) THEN
                   IF i931_azw05_a() THEN NEXT FIELD azw06 END IF
                END IF 
              END IF
              IF NOT cl_null(g_azw[l_ac].azw05) THEN
                 CALL i931_azw05(p_cmd)
              END IF
          END IF
     #FUN-9C0048--end--add----------

      #FUN-B50039-add-str--
      AFTER FIELD azwud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azwud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azwud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azwud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azwud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azwud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azwud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azwud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azwud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azwud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azwud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azwud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azwud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azwud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azwud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #FUN-B50039-add-end--


#FUN-9A0092--begin
#     AFTER FIELD azw05                         
#         IF NOT cl_null(g_azw[l_ac].azw05) THEN 
#            IF g_azw[l_ac].azw05 != g_azw_t.azw05 OR
#               g_azw_t.azw05 IS NULL THEN
#               SELECT COUNT(*) INTO l_n1 FROM azp_file 
#                WHERE azp03=g_azw[l_ac].azw05 
#               IF l_n1=0 THEN
#                  CALL cl_err('','aoo-311',1)
#                  NEXT FIELD azw05
#               ELSE 
#                  SELECT azp053 INTO l_azp053 FROM azp_file 
#                   WHERE azp03=g_azw[l_ac].azw05 
#                  IF l_azp053='N' THEN 
#                     CALL cl_err('','9028',1)
#                     NEXT FIELD azw05
#                  END IF 
#               END IF                         #FUN-9A0092  mark
#             END IF
#          END IF   
#FUN-9A0092--end
           
      BEFORE DELETE                            # 是否取消單身 

#FUN-B70115-------start-
#         LET l_zxcnt = 0
#         SELECT count(*) INTO l_zxcnt FROM zx_file         #FUN-B70115
#         WHERE zx08=g_azw[l_ac].azw01
#         AND zxacti='Y'
#
#
#         IF l_zxcnt >=1 THEN                               #FUN-B70115
#            CALL cl_err("",-240,1)
#            CANCEL DELETE
#
#         END IF
#FUN-B70115--End

         SELECT rtz28,rtzpos INTO l_rtz28,l_rtzpos FROM rtz_file
          WHERE rtz01 = g_azw[l_ac].azw01
         SELECT azwacti INTO l_azwacti FROM azw_file
          WHERE azw01 = g_azw[l_ac].azw01
         IF NOT cl_null(g_azw_t.azw01)  THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF      
#FUN-A80148 ----------start-------------------------
            IF g_azw[l_ac].azw04 <> '2' THEN
           #-----------
            ELSE 
               IF g_aza.aza88 = 'Y' THEN
                  IF l_rtz28 = 'N' THEN
                    #FUN-B40071 --START--
                     #IF l_azwacti = 'Y' THEN
                     #   #CALL cl_err("",'art-648',0) #NO.FUN-B40071
                     #   CALL cl_err("",'apc-139',0)  #NO.FUN-B40071
                     #   CANCEL DELETE
                     #END IF
                     #IF l_azwacti = 'N' THEN
                     #   IF l_rtzpos = 'Y' THEN
                     #  #----------
                     #   ELSE
                     #      #CALL cl_err("",'art-648',0) #NO.FUN-B40071
                     #      CALL cl_err("",'apc-139',0)  #NO.FUN-B40071
                     #      CANCEL DELETE
                     #   END IF
                     #END IF
                     IF NOT ((l_rtzpos='3' AND l_azwacti='N') 
                                OR (l_rtzpos='1'))  THEN                  
                        CALL cl_err('','apc-139',0)            
                        CANCEL DELETE
                     END IF  
                    #FUN-B40071 --END--
                   ELSE
                      CALL cl_err("",'aoo-422',0)
                      CANCEL DELETE 
                   END IF
                ELSE
                   IF l_rtz28 = 'N' THEN
                   ELSE
                      CALL cl_err("",'aoo-422',0)
                      CANCEL DELETE
                   END IF
                END IF
             END IF           

            #---FUN-B50089---start-----
            #找出是否還有其它營運中心使用此實體DB或登入DB
            IF g_azw_t.azw05 = g_azw_t.azw06 THEN
               #屬於實體DB
               SELECT COUNT(*) INTO l_cnt FROM azw_file 
                 WHERE azw01 <> g_azw_t.azw01 AND 
                       azw05 = g_azw_t.azw05
            ELSE
               #屬於虛擬DB
               SELECT COUNT(*) INTO l_cnt FROM azw_file 
                 WHERE azw01 <> g_azw_t.azw01 AND 
                       azw06 = g_azw_t.azw06
            END IF

            #找出此營運中心實際DB是那一個
            LET l_azp03 = g_azw_t.azw06
            IF g_azw_t.azw05 = g_azw_t.azw06 THEN
               LET l_azp03 = g_azw_t.azw05
            END IF
            
            #如果沒有任何登入DB在設定中,才可刪除系統上關於此DB的所有設定
            #詢問是否刪除此DB在系統中之相關設定?
            IF l_cnt = 0 AND cl_chk_schema_has_built(l_azp03) THEN
               IF cl_confirm("aoo-425") THEN
                  #刪除zta_file, azwd_file相關資料
                  #刪除FGLPROFILE檔案此登入DB設定,採註解方式,
                  #並將原先FGLPROFILE檔案在同路徑下備份一份為.bak檔案
                  IF NOT i931_data_r(l_azp03) THEN
                     ROLLBACK WORK
                     CANCEL DELETE
                  END IF

                  #判斷是否為實體DB,如果是需重建ods view
                  IF (NOT g_rebuild_ods) AND g_azw_t.azw05 = g_azw_t.azw06 THEN
                     #判斷該DB Schema是否已經在資料庫中建立,有建立才需要重建ods view
                     IF cl_chk_schema_has_built(g_azw_t.azw06) THEN
                        LET g_rebuild_ods = TRUE
                     END IF
                  END IF
               END IF
            ELSE
               LET l_azp03 = ""
            END IF
            #---FUN-B50089---end-------
            
            DELETE FROM azw_file WHERE azw02 = g_azw02
                                   AND azw01 = g_azw_t.azw01
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","azw_file",g_azw02,SQLCA.sqlcode,"","","",1)  
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            DELETE FROM rtz_file WHERE rtz01 = g_azw_t.azw01
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","rtz_file",g_azw_t.azw01,SQLCA.sqlcode,"","","",1)  
               ROLLBACK WORK
               CANCEL DELETE
            END IF
#FUN-A80148 --------------end -------------------------            
           #FUN-9C0048--begin--add---
            DELETE FROM azp_file WHERE azp01 = g_azw_t.azw01
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","azp_file",g_azw_t.azw01,SQLCA.sqlcode,"","","",1)  
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            #FUN-9C0048--end--add---
           #MOD-D50129 add begin--------------------------
            DELETE FROM zxy_file WHERE zxy03 = g_azw_t.azw01
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","zxy_file",g_azw_t.azw01,"",SQLCA.sqlcode,"","",0)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
           #MOD-D50129 add edn----------------------------
            LET g_rec_b = g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK   

         #---FUN-B50089---start-----
         #提醒使用者仍需手動從DB中drop schema
         IF NOT cl_null(l_azp03) THEN
            CALL cl_err_msg('', 'aoo-428', l_azp03, 10)
         END IF
         #---FUN-B50089---end-------
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_azw[l_ac].* = g_azw_t.*
            CLOSE i931_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_azw[l_ac].azw01,-263,1)
            LET g_azw[l_ac].* = g_azw_t.*
         ELSE

            UPDATE azw_file SET azw01 = g_azw[l_ac].azw01,
                                azw03 = g_azw[l_ac].azw03,
                                azw04 = g_azw[l_ac].azw04,
                                azw05 = g_azw[l_ac].azw05, 
                                azw06 = g_azw[l_ac].azw06,
                                azw08 = g_azw[l_ac].azw08,   #FUN-9C0048
                                azw09 = g_azw09,  #FUN-9C0048
                                azwacti = g_azw[l_ac].azwacti,
                                azwmodu = g_user,   #TQC-9B0202  
                                azwdate = g_today,   #TQC-9B0202
                                #FUN-B50039-add-str--
                                azwud01 = g_azw[l_ac].azwud01,
                                azwud02 = g_azw[l_ac].azwud02,
                                azwud03 = g_azw[l_ac].azwud03,
                                azwud04 = g_azw[l_ac].azwud04,
                                azwud05 = g_azw[l_ac].azwud05,
                                azwud06 = g_azw[l_ac].azwud06,
                                azwud07 = g_azw[l_ac].azwud07,
                                azwud08 = g_azw[l_ac].azwud08,
                                azwud09 = g_azw[l_ac].azwud09,
                                azwud10 = g_azw[l_ac].azwud10,
                                azwud11 = g_azw[l_ac].azwud11,
                                azwud12 = g_azw[l_ac].azwud12,
                                azwud13 = g_azw[l_ac].azwud13,
                                azwud14 = g_azw[l_ac].azwud14,
                                azwud15 = g_azw[l_ac].azwud15
                                #FUN-B50039-add-end--
                                 WHERE azw02 = g_azw02
                                   AND azw01 = g_azw_t.azw01
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","azw_file",g_azw02,SQLCA.sqlcode,"","","",1)  #No.FUN-660138
               ROLLBACK WORK                                #FUN-A80148  add
               LET g_azw[l_ac].* = g_azw_t.*
            ELSE  
#FUN-A80148  ----start
            IF g_azw[l_ac].azw01<>g_azw_t.azw01 THEN
               #SELECT rtz28 INTO l_rtz28 FROM rtz_file #FUN-B40071 MARK
               SELECT rtz28,rtzpos INTO l_rtz28,l_rtzpos2 FROM rtz_file #FUN-B40071
              # WHERE rtz01 = g_azw[l_ac].azw01
                WHERE rtz01 = g_azw_t.azw01  #20101012 By shi
               #FUN-B40071 --START--
               IF l_rtzpos2 <> '1' THEN
                  LET l_rtzpos2 = '2'
               ELSE
                  LET l_rtzpos2 = '1'
               END IF               
               #FUN-B40071 --END--
                
               IF l_rtz28 = 'N' THEN 
                  UPDATE rtz_file SET rtz01 = g_azw[l_ac].azw01,
                                    rtzpos = l_rtzpos2,                                  #No:FUN-B40071
                                    rtzmodu = g_user,                                   #FUN-A80117  add
                                   rtzdate = g_today                                    #FUN-A80117  add
                 # WHERE rtz01 =  g_azw[l_ac].azw01
                   WHERE rtz01 = g_azw_t.azw01  #20101012 By shi
                  IF SQLCA.sqlcode THEN 
                     CALL cl_err3("upd","rtz_file",g_azw_t.azw01,SQLCA.sqlcode,"","","",1)
                     ROLLBACK WORK
                  ELSE
                     MESSAGE 'UPDATE O.K'
                     COMMIT WORK
                  END IF
               ELSE
                  CALL cl_err('','aoo-421',0)
                  ROLLBACK WORK
                  LET g_azw[l_ac].azw01 = g_azw_t.azw01
               END IF
             END IF   
#               MESSAGE 'UPDATE O.K'
#               COMMIT WORK
#FUN-A80148  ------end   
            END IF
         END IF          
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac  #FUN-D40030
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_azw[l_ac].* = g_azw_t.*
            #FUN-D40030--add--str--
            ELSE
               CALL g_azw.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D40030--add--end--
            END IF
            CLOSE i931_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D40030
         CLOSE i931_bcl
         COMMIT WORK
 
#FUN-9C0048--begin--mark---
#      ON ACTION CONTROLP                                                       
#         CASE                                                                  
#            WHEN INFIELD(azw01)                                                
#               CALL cl_init_qry_var()                                          
#               LET g_qryparam.form  ="q_azp"     
#               LET g_qryparam.default1 = g_azw[l_ac].azw01                          
#               CALL cl_create_qry() RETURNING g_azw[l_ac].azw01               
#               DISPLAY BY NAME g_azw[l_ac].azw01                         
#               NEXT FIELD azw01
#FUN-9C0048--end--mark----
                
#TQC-9B0202--begin--mark---------
#            WHEN INFIELD(azw05)                                                
#               CALL cl_init_qry_var()                                          
#               LET g_qryparam.form  ="q_azp3"     
#               LET g_qryparam.default1 = g_azw[l_ac].azw05                          
#               CALL cl_create_qry() RETURNING g_azw[l_ac].azw05               
#               DISPLAY BY NAME g_azw[l_ac].azw05                         
#               NEXT FIELD azw05                                                                
#TQC-9B0202--end--mark---------
#           OTHERWISE EXIT CASE          #FUN-9C0048                                   
#         END CASE                       #FUN-9C0048
 
      ON ACTION CONTROLO                      
         IF INFIELD(azw01) AND l_ac > 1 THEN
            LET g_azw[l_ac].* = g_azw[l_ac-1].*
            LET g_azw[l_ac].azw01=null
            NEXT FIELD azw01
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
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
 
      AFTER INPUT  
         CALL i931_chk_login_db()#No.FUN-A50079 add by tommas
 
   END INPUT
 
   CALL i931_b1()   #FUN-9B0150
   LET g_flag = 'Y' #FUN-9C0048
   CLOSE i931_bcl
   COMMIT WORK
 
END FUNCTION            

FUNCTION i931_b_fill(p_wc)                     #BODY FILL UP
DEFINE p_wc STRING
 
  #LET g_sql = "SELECT azw01,'',azw03,azw04,azw05,azw06,azwacti ",   #FUN-9C0048
   LET g_sql = "SELECT azw01,azw08,azw03,azw04,azw05,azw06,azwacti, ",#FUN-9C0048
               " azwud01,azwud02,azwud03,azwud04,azwud05,",     #FUN-B50039
               " azwud06,azwud07,azwud08,azwud09,azwud10,",     #FUN-B50039
               " azwud11,azwud12,azwud13,azwud14,azwud15 ",     #FUN-B50039
               " FROM azw_file ",
               " WHERE azw02 = '",g_azw02,"'",
               "  AND ",p_wc CLIPPED ,
               " ORDER BY azw02"
   PREPARE i931_prepare2 FROM g_sql       #預備一下 
   DECLARE azw_cs CURSOR FOR i931_prepare2
 
   CALL g_azw.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH azw_cs INTO g_azw[g_cnt].*     #單身ARRAY填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
#     SELECT azp02 INTO g_azw[g_cnt].azp02              #FUN-9C0048
#       FROM azp_file WHERE azp01 = g_azw[g_cnt].azw01  #FUN-9C0048
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   
   CALL cl_set_combo_industry("azw03")
   CALL g_azw.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
 
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i931_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL cl_set_combo_industry("azw03")
   DISPLAY ARRAY g_azw TO s_azw.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
 
      ON ACTION first
         CALL i931_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
            CALL fgl_set_arr_curr(1)  
         ACCEPT DISPLAY                   
 
      ON ACTION previous
         CALL i931_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
            CALL fgl_set_arr_curr(1) 
	 ACCEPT DISPLAY              
 
      ON ACTION jump
         CALL i931_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
            CALL fgl_set_arr_curr(1)
	 ACCEPT DISPLAY                   
 
      ON ACTION next
         CALL i931_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         CALL fgl_set_arr_curr(1)  
 
	 ACCEPT DISPLAY               
 
      ON ACTION last
         CALL i931_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         CALL fgl_set_arr_curr(1)  
	 ACCEPT DISPLAY                   
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
#FUN-980020--begin
#FUN-9C0048--begin--mark--
#     ON ACTION set_loctab
#        LET g_action_choice="set_loctab"
#        EXIT DISPLAY
#FUN-9C0048--end--mark--
#FUN-980020--end
 
#FUN-9C0048--begin--add---
      ON ACTION create_db1
         LET g_action_choice="create_db1"
         EXIT DISPLAY
#FUN-9C0048--end--add----

      #FUN-9C0154:Begin
      ON ACTION rebuild_ods_view
         LET g_action_choice = "rebuild_ods_view"
         EXIT DISPLAY
      #FUN-9C0154:End
      
      ON ACTION rebuild_view   #FUN-A70115
         LET g_action_choice = "rebuild_view"
         EXIT DISPLAY      

      #FUN-A30103:Begin
      ON ACTION ods_db
         LET g_action_choice = "ods_db"
         EXIT DISPLAY
      #FUN-A30103:End

#No.FUN-A20056 add --------------
      ON ACTION erp_sch
         LET g_action_choice = "erp_sch"
         EXIT DISPLAY
#No.FUN-A20056 add --------------

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
 
      AFTER DISPLAY
         CONTINUE DISPLAY
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION   
 
FUNCTION i931_r()
DEFINE   l_azw01   LIKE azw_file.azw01   #FUN-9C0048
DEFINE   l_azw04   LIKE azw_file.azw04   #FUN-A80117
DEFINE   l_azwacti LIKE azw_file.azwacti #FUN-A80117
DEFINE   l_rtzpos  LIKE rtz_file.rtzpos  #FUN-A80117
DEFINE   l_rtz28   LIKE rtz_file.rtz28   #FUN-A80117
DEFINE   l_cnt     LIKE type_file.num5   #FUN-A80117
#---FUN-B50089---start-----
DEFINE   l_azw06         STRING
DEFINE   l_azw06_t       LIKE azw_file.azw06
DEFINE   l_is_virtual    LIKE type_file.chr1   #是否為虛擬DB schema
DEFINE   l_del           LIKE type_file.chr1   #是否要刪除相關資訊
DEFINE   l_has_built     LIKE type_file.chr1   #是否已建立
DEFINE   l_azp03         STRING                #已被建立之schema
#---FUN-B50089---end-------
DEFINE   l_zxcntx        LIKE type_file.num10  #FUN-B70115
DEFINE   l_azw01x        LIKE azw_file.azw01   #FUN-B70115

 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_azw02) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   LET l_cnt = 0                          #FUN-A80117
   LET g_success = 'Y'                    #FUN-A80117

#FUN-B70115-------start-
#   DECLARE i931_cs99 CURSOR FOR
#        SELECT azw01 FROM azw_file
#         WHERE azw02 = g_azw02
#   LET l_zxcntx = 0
#
#   FOREACH i931_cs99 INTO l_azw01x
#
#      SELECT count(*) INTO l_zxcntx FROM zx_file         #FUN-B70115
#       WHERE zx08 = l_azw01x
#       AND   zxacti='Y'
#      IF l_zxcntx >=1 THEN
#         CALL cl_err("","azz-033",1)
#         RETURN
#      END IF
#   END FOREACH
#
#FUN-B70115--end--


   BEGIN WORK
 
   IF cl_delh(0,0) THEN             #確認一下      
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "azw02"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_azw02       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()          #No.FUN-9B0098 10/02/24
 #FUN-A80117 ------------------STR
      #FUN-9C0048--begin--add-----
 #     DECLARE i931_cs1 CURSOR FOR
 #      SELECT azw01 FROM azw_file
 #       WHERE azw02 = g_azw02
 #     FOREACH i931_cs1 INTO l_azw01
 #       DELETE FROM azp_file WHERE azp01 = l_azw01
 #     END FOREACH
 #     #FUN-9C0048--end--add-----
 #      DELETE FROM azw_file WHERE azw02 = g_azw02    #FUN-A80117
 #      IF SQLCA.sqlcode THEN
 #        CALL cl_err3("del","azw_file",g_azw02,"",SQLCA.sqlcode,"","BODY DELETE",0) 
 #      ELSE
 #        COMMIT WORK
 #        CLEAR FORM
 #        CALL g_azw.clear()
 #         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'      
 #        OPEN i931_count
 #        FETCH i931_count INTO g_row_count
 #        DISPLAY g_row_count TO FORMONLY.cnt
 #        OPEN i931_bcs
 #        IF g_curs_index = g_row_count + 1 THEN
 #           LET  g_abso= g_row_count
 #           CALL i931_fetch('L')
 #        ELSE
 #           LET g_abso = g_curs_index
 #           LET mi_no_ask = TRUE
 #           CALL i931_fetch('/')
 #        END IF
 #      END IF

       DECLARE i931_cs1 CURSOR FOR
        SELECT azw01,azw04,azwacti FROM azw_file
         WHERE azw02 = g_azw02
       CALL s_showmsg_init()

       #---FUN-B50089---start-----
       LET l_del = FALSE
       LET l_azw06 = ""
       LET l_azp03 = ""
       #找出此法人下所有實體DB、登入DB,在其他法人的實體DB或登入DB中也沒有在使用的才可以刪除
       #N:不是虛擬DB, Y:是虛擬DB
       DECLARE i931_azw_cs1 CURSOR FOR                      
          SELECT DISTINCT azw05, 'N' FROM azw_file 
            WHERE azw02 = g_azw02 AND 
                  azw05 NOT IN (SELECT DISTINCT azw05 FROM azw_file
                                  WHERE azw02 <> g_azw02)
          UNION 
          SELECT DISTINCT azw06, 'Y' FROM azw_file 
            WHERE azw05 <> azw06 AND azw02 = g_azw02 AND 
                  azw06 NOT IN (SELECT DISTINCT azw06 FROM azw_file
                                  WHERE azw02 <> g_azw02)
                                        
       FOREACH i931_azw_cs1 INTO l_azw06_t, l_is_virtual
          IF SQLCA.sqlcode THEN
             CALL cl_err("i931_azw_cs1", SQLCA.sqlcode, 1)
             ROLLBACK WORK
             RETURN
          END IF

          LET l_has_built = FALSE
          LET l_azw06 = l_azw06, l_azw06_t CLIPPED, "|"

          #判斷是否已建立此DB
          IF cl_chk_schema_has_built(l_azw06_t) THEN
             LET l_azp03 = l_azp03, l_azw06_t CLIPPED, ","
             LET l_has_built = TRUE
             LET l_del = TRUE
          END IF
          
          #判斷該DB Schema是否已經在資料庫中建立,有建立才需要重建ods view
          #只有是實體DB才需要重建ODS View
          IF (NOT g_rebuild_ods) AND (l_is_virtual = "N") AND l_has_built THEN
             LET g_rebuild_ods = TRUE
          END IF
       END FOREACH

       #詢問是否刪除此DB在系統中之相關設定?
       IF l_del THEN
          IF cl_confirm("aoo-425") THEN
             IF l_azw06.getCharAt(l_azw06.getLength()) = "|" THEN
                LET l_azw06 = l_azw06.subString(1, l_azw06.getLength() - 1)
             END IF
             #刪除zta_file, azwd_file相關資料
             #刪除FGLPROFILE檔案此登入DB設定,採註解方式,
             #並將原先FGLPROFILE檔案在同路徑下備份一份為.bak檔案
             IF NOT i931_data_r(l_azw06) THEN
                ROLLBACK WORK
                RETURN
             END IF
          END IF
       END IF
       #---FUN-B50089---end-------
            
       FOREACH i931_cs1 INTO l_azw01,l_azw04,l_azwacti
          SELECT rtz28,rtzpos INTO l_rtz28,l_rtzpos FROM rtz_file
           WHERE rtz01 = l_azw01
          IF l_azw04 = '2' THEN
             IF g_aza.aza88 = 'Y' THEN
               IF l_rtz28 = 'N' THEN
                #FUN-B40071 --START--
                 #IF l_azwacti = 'N' AND l_rtzpos = 'Y' THEN
                 #ELSE
                 #  #CALL s_errmsg('',g_showmsg,'','art-648',1) #NO.FUN-B40071
                 #  CALL s_errmsg('',g_showmsg,'','apc-139',1)  #NO.FUN-B40071                   
                 #  CONTINUE FOREACH
                 #END IF
                 IF NOT ((l_rtzpos='3' AND l_azwacti='N') 
                            OR (l_rtzpos='1'))  THEN                  
                    CALL s_errmsg('',g_showmsg,'','apc-139',1)
                    CONTINUE FOREACH
                 END IF   
                #FUN-B40071 --END--
               ELSE
                 CALL s_errmsg('',g_showmsg,'','aoo-422',1)
                 CONTINUE FOREACH
               END IF
             ELSE
               IF l_rtz28 = 'N' THEN
               ELSE
                 CALL s_errmsg('',g_showmsg,'','aoo-422',1)
                 CONTINUE FOREACH
               END IF
             END IF
          END IF
          DELETE FROM azp_file WHERE azp01 = l_azw01
          IF SQLCA.sqlcode THEN
             CALL cl_err3("del","azp_file",l_azw01,"",SQLCA.sqlcode,"","",0)
             LET g_success = 'N'
             EXIT FOREACH
          END IF
          DELETE FROM azw_file WHERE azw01 = l_azw01
          IF SQLCA.sqlcode THEN
             CALL cl_err3("del","azw_file",l_azw01,"",SQLCA.sqlcode,"","",0)
             LET g_success = 'N'
             EXIT FOREACH
          END IF
          DELETE FROM rtz_file WHERE rtz01 = l_azw01
          IF SQLCA.sqlcode THEN
             CALL cl_err3("del","rtz_file",l_azw01,"",SQLCA.sqlcode,"","",0)
             LET g_success = 'N'
             EXIT FOREACH
          END IF
         #MOD-D50129 add begin--------------------------
          DELETE FROM zxy_file WHERE zxy03 = l_azw01
          IF SQLCA.sqlcode THEN
             CALL cl_err3("del","zxy_file",l_azw01,"",SQLCA.sqlcode,"","",0)
             LET g_success = 'N'
             EXIT FOREACH
          END IF
         #MOD-D50129 add edn----------------------------
          LET l_cnt = l_cnt+1
       END FOREACH
       LET l_cnt = l_cnt-1
       CALL s_showmsg()
       IF g_success = 'N' THEN
          ROLLBACK WORK
       ELSE
          COMMIT WORK
          IF l_cnt = g_rec_b THEN
             CLEAR FORM
             CALL g_azw.clear()
             MESSAGE 'Remove (',g_rec_b USING '####&',') Row(s)'
             OPEN i931_count
             #FUN-B50065-add-start--
             IF STATUS THEN
                CLOSE i931_count
                COMMIT WORK
                RETURN
             END IF
             #FUN-B50065-add-end-- 
             FETCH i931_count INTO g_row_count
             #FUN-B50065-add-start--
             IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
                CLOSE i931_count
                COMMIT WORK
                RETURN
             END IF
             #FUN-B50065-add-end-- 
             DISPLAY g_row_count TO FORMONLY.cnt
             OPEN i931_bcs
             IF g_curs_index = g_row_count + 1 THEN
                LET  g_abso= g_row_count
                CALL i931_fetch('L')
             ELSE
                LET g_abso = g_curs_index
                LET mi_no_ask = TRUE
                CALL i931_fetch('/')
             END IF
          ELSE
             CALL i931_b_fill(g_wc)
          END IF
       END IF
             
 #FUN-A80117 -------------------END
   END IF
   COMMIT WORK

   #---FUN-B50089---start-----
   #提醒使用者仍需手動從DB中drop schema
   IF l_del THEN
      IF l_azp03.getCharAt(l_azp03.getLength()) = "," THEN
         LET l_azp03 = l_azp03.subString(1, l_azp03.getLength() - 1)
      END IF
      CALL cl_err_msg('', 'aoo-428', l_azp03, 10)
   END IF
   #---FUN-B50089---end-------
END FUNCTION
 
FUNCTION i931_copy()
DEFINE
   l_n             LIKE type_file.num5,   
   l_cnt           LIKE type_file.num10,  
   l_oldno1        LIKE azw_file.azw01,
   l_newno         LIKE azw_file.azw01,
   l_lne36         LIKE lne_file.lne36
   
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_azw02) THEN
      CALL cl_err('',-400,1)
      RETURN  
   END IF
   
   CALL i931_set_entry('a')
   CALL cl_set_head_visible("","YES")     
 
   INPUT l_newno FROM azw02
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         
      AFTER FIELD azw02 
         IF NOT cl_null(l_newno) THEN
            SELECT COUNT(*) INTO l_n FROM azw_file
             WHERE azw02 = l_newno
            IF l_n > 0 THEN
               CALL cl_err('',-239,0)
               NEXT FIELD azw02
            END IF
            CALL i931_azw02(l_newno,'a')
            IF cl_null(g_errno) THEN 
               CALL cl_err('',g_errno,1)
               NEXT FIELD azw02
            END IF 
         END IF
 
     ON ACTION CONTROLP                                                     
        CASE                                                                
           WHEN INFIELD(azw02)                                                
                CALL cl_init_qry_var()                                          
                LET g_qryparam.form  ="q_azt"                                   
                LET g_qryparam.default1 = g_azw02              
                CALL cl_create_qry() RETURNING g_azw02               
                DISPLAY g_azw02 TO azw02                               
                NEXT FIELD azw02                                           
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
      DISPLAY g_azw02 TO azw02
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM azw_file             
    WHERE azw02 = g_azw02
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x",g_azw02,'',SQLCA.sqlcode,"","",1)  
      RETURN
   END IF
 
   UPDATE x SET azw02  = l_newno,
                azwuser = g_user,  #TQC-9B0202
                azwgrup = g_grup,  #TQC-9B0202
                azwmodu = NULL,    #TQC-9B0202
                azwdate = g_today  #TQC-9B0202  
   
   INSERT INTO azw_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","azw_file",l_newno,'',SQLCA.sqlcode,"",g_msg,1)  
      RETURN
   ELSE 
      MESSAGE 'COPY O.K'
      LET l_oldno1 = g_azw02
      LET g_azw02=l_newno
      CALL i931_b()
      IF g_flag = 'Y' THEN   #FUN-9C0048
         CALL i931_b2()   #FUN-9C0048
         CALL i931_b3()   #FUN-9C0048
      END IF              #FUN-9C0048
      #LET g_azw02 = l_oldno1  #FUN-C80046
      #CALL i931_show()        #FUN-C80046
      CALL i931_azw02(l_newno,'d')
   END IF
END FUNCTION
 
 
FUNCTION i931_azw02(l_azt01,p_cmd)   
DEFINE
   p_cmd           LIKE type_file.chr1,
   l_azt01         LIKE azt_file.azt01,
   l_azt02         LIKE azt_file.azt02,
   l_aztacti       LIKE azt_file.aztacti       
 
   LET g_errno = ' '
   SELECT azt02,aztacti 
     INTO l_azt02,l_aztacti
     FROM azt_file WHERE azt01 = l_azt01
 
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aoo-416'
                                 LET l_azt02 = NULL
        WHEN l_aztacti = 'N'     LET g_errno = '9028'
        OTHERWISE                LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_azt02  TO FORMONLY.azt02
   END IF
 
END FUNCTION
 
FUNCTION i931_azw01()                                          
DEFINE   l_azp02         LIKE azp_file.azp02
DEFINE   l_azp03         LIKE azp_file.azp03
DEFINE   l_azp053        LIKE azp_file.azp053
DEFINE   p_cmd           LIKE type_file.chr1
 
   LET g_errno =''                                                      
   SELECT azp02,azp03,azp053 INTO l_azp02,l_azp03,l_azp053 FROM azp_file                    
    WHERE azp01 = g_azw[l_ac].azw01    
                                                         
#FUN-9C0048--begin--mark---
#  CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-025'
#                                LET l_azp02 = NULL
#                                LET l_azp03 = NULL
#FUN-9C0048--end--mark----
   CASE WHEN SQLCA.SQLCODE = 100 EXIT CASE   #FUN-9C0048
        WHEN l_azp053 = 'N'      LET g_errno = '9028'
        OTHERWISE                LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE              
   
#  IF cl_null(g_errno) THEN 
#FUN-9C0048--begin--mod----
   IF NOT cl_null(l_azp02) THEN
      LET l_azp02=DOWNSHIFT(l_azp02)
      LET g_azw[l_ac].azw08=l_azp02                           
      DISPLAY BY NAME g_azw[l_ac].azw08 
#     LET g_azw[l_ac].azp02=l_azp02                           
#     DISPLAY BY NAME g_azw[l_ac].azp02 
   END IF
#FUN-9C0048--end--mod-----
   IF NOT cl_null(l_azp03) THEN      #FUN-9C0048
      LET l_azp03=DOWNSHIFT(l_azp03) #FUN-9C0048
      LET g_azw[l_ac].azw06=l_azp03                           
      DISPLAY BY NAME g_azw[l_ac].azw06
   END IF                            #FUN-9C0048
#   END IF                           
                                           
END FUNCTION 
      
 
FUNCTION i931_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1         
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("azw02",TRUE)
     END IF
END FUNCTION
 
FUNCTION i931_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1         
 
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       call cl_set_comp_entry("azw02",FALSE)
    END IF
END FUNCTION 
#No.FUN-980017---End              

#No.FUN-A60016--Begin
FUNCTION i931_set_entry_b(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1

   IF p_cmd = 'a' THEN
      CALL cl_set_comp_entry("azw05", TRUE)
   END IF
END FUNCTION

FUNCTION i931_set_no_entry_b(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1

   IF p_cmd = 'a' OR p_cmd = 'u' THEN
      CALL cl_set_comp_entry("azw05", FALSE)
   END IF
END FUNCTION
#No.FUN-A60016--end

 
#FUN-980020--begin
#Local 檔案設定
FUNCTION i931_settb(p_azy01)
  DEFINE l_flag          LIKE type_file.chr1,   #A:Alter Table, D:Drop Table
         l_sql           STRING,
         g_i             LIKE type_file.num5,
         l_allow_insert  LIKE type_file.num5,
         l_allow_delete  LIKE type_file.num5 
  DEFINE l_n             LIKE type_file.num5
  DEFINE p_azy01         LIKE azy_file.azy01
  DEFINE l_n1            LIKE type_file.num5    #FUN-9A0092
  DEFINE l_n2            LIKE type_file.num5    #FUN-9A0092
  DEFINE l_n3            LIKE type_file.num5    #FUN-9A0092
  DEFINE p_cmd           LIKE type_file.chr1    #FUN-9A0092

    IF cl_null(g_azw02) THEN RETURN END IF   #FUN-9C0048
#FUN-9A0092--begin
    SELECT COUNT(*) INTO l_n2 FROM azw_file
     WHERE azw05 = azw06
       AND azw06 = p_azy01
    IF l_n2 >0 THEN
       CALL  cl_err(p_azy01,'aoo-100',1)
       RETURN
    END IF
#FUN-9A0092--end
 
    #開啟視窗找出gat_file里gat07為P,M,B的資料
    #讓登錄用戶選擇，然後對這些選擇的資料庫執行Alter Table
    OPEN WINDOW i931_1_w AT 12,40 WITH FORM "aoo/42f/aooi931_1"
    ATTRIBUTE(STYLE = g_win_style)
 
    CALL cl_ui_locale("aooi931_1")
 
    LET l_sql = "SELECT '',gat01,gat03,gat07 FROM gat_file",
                " WHERE gat02='",g_lang,"'",
                "   AND gat07 IN ('P','M','B')" 
 
    DECLARE i931_settb_cs CURSOR FROM l_sql
 
    CALL g_gat.clear()
    LET g_rec_b1 =0
    LET g_cnt1 = 1
    FOREACH i931_settb_cs INTO g_gat[g_cnt1].*   #單身 ARRAY 填充
       IF sqlca.sqlcode THEN
          CALL cl_err('foreach gat data error',sqlca.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT COUNT(*) INTO l_n1 FROM azy_file
        WHERE azy01 = p_azy01
          AND azy02 = g_gat[g_cnt1].gat01
          AND azyacti = 'Y'
       IF l_n1 > 0 THEN
          LET g_gat[g_cnt1].sel = 'Y'
       ELSE
          LET g_gat[g_cnt1].sel = 'N'
       END IF
       LET g_cnt1 = g_cnt1 + 1
       IF g_cnt1 > g_max_rec THEN
          CALL cl_err("",9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
 
    CALL g_gat.deleteElement(g_cnt1)
    LET g_cnt1 = g_cnt1 - 1
 
    #改成INPUT 
    LET g_rec_b1 = g_cnt1
    LET l_ac1 = 0
    LET g_i = 0
    LET l_allow_insert = FALSE
    LET l_allow_delete = FALSE
 
    INPUT ARRAY g_gat WITHOUT DEFAULTS FROM s_gat.*
      ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)

       BEFORE INPUT
          IF g_rec_b1 != 0 THEN
             CALL fgl_set_arr_curr(l_ac1)
          END IF
 
#FUN-9A0092--begin
       BEFORE ROW
          LET p_cmd = ''
          LET l_ac1= ARR_CURR()
          LET l_n  = ARR_COUNT()
          IF g_rec_b1 >= l_ac1 THEN
             BEGIN WORK
             LET p_cmd='u'
             LET g_gat_t.* = g_gat[l_ac1].*  #BACKUP
             CALL cl_show_fld_cont()     
          END IF
  
       BEFORE INSERT                                                             
          LET l_n = ARR_COUNT()                                                  
          LET p_cmd='a'                                                          
          LET g_before_input_done = FALSE
          IF cl_null(g_gat[l_ac1].sel) THEN
             LET g_gat[l_ac1].sel = 'N'
          END IF
          INITIALIZE g_gat[l_ac1].* TO NULL                   
          LET g_before_input_done = TRUE
          LET g_gat_t.* = g_gat[l_ac1].*               #新輸入資料                
          CALL cl_show_fld_cont()                                                
          NEXT FIELD sel
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
          END IF
#FUN-9A0092--end

       AFTER FIELD sel
          IF NOT cl_null(g_gat[l_ac1].sel) THEN
             IF g_gat[l_ac1].sel NOT MATCHES "[YN]" THEN
                NEXT FIELD sel
             END IF
          ELSE
             LET g_gat[l_ac1].sel ='N'
             NEXT FIELD sel
          END IF
 
#FUN-9A0092--begin
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_gat[l_ac1].* = g_gat_t.*
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
       AFTER ROW
         FOR g_i =1 TO g_rec_b1
            IF g_gat[g_i].sel = 'Y' AND
               NOT cl_null(g_gat[g_i].gat01)  THEN
               LET g_azy.azy01 = p_azy01
               LET g_azy.azy02 = g_gat[g_i].gat01
               LET g_azy.azyacti = 'Y'
               LET g_azy.azyuser = g_user
               LET g_azy.azydate = g_today
               LET g_azy.azygrup = g_grup
               SELECT COUNT(*) INTO l_n3 FROM azy_file WHERE azy01 = p_azy01 AND azy02 = g_gat[g_i].gat01
               IF l_n3 =0 THEN
                  LET g_azy.azyoriu = g_user      #No.FUN-980030 10/01/04
                  LET g_azy.azyorig = g_grup      #No.FUN-980030 10/01/04
                  INSERT INTO azy_file VALUES(g_azy.*)
                  IF SQLCA.sqlcode THEN                                                                                                       
                     CALL cl_err3("ins","azy_file",g_azy.azy01,g_gat[g_i].gat01,SQLCA.sqlcode,"","",1)  
                     RETURN
                  END IF
               END IF
            ELSE
               DELETE FROM azy_file WHERE azy01 = p_azy01 AND azy02 = g_gat[g_i].gat01
            END IF
            IF g_i = g_rec_b1 THEN
               EXIT FOR
            END IF
         END FOR

          LET l_ac1 = ARR_CURR()
          LET l_ac1_t = l_ac1
          IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_gat[l_ac1].* = g_gat_t.*
            END IF
            ROLLBACK WORK
            EXIT INPUT
         END IF
         COMMIT WORK
#FUN-9A0092--end

       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION cancel
          LET INT_FLAG=FALSE 		
          LET g_action_choice="exit"
          EXIT INPUT
 
       ON ACTION select_all
          FOR l_ac1 = 1 TO g_rec_b1
              LET g_gat[l_ac1].sel="Y"
              DISPLAY BY NAME g_gat[l_ac1].sel
              IF l_ac1 = g_rec_b1 THEN
                 EXIT FOR
              END IF
          END FOR
 
       ON ACTION cancel_all
          FOR l_ac1 = 1 TO g_rec_b1
              LET g_gat[l_ac1].sel="N"
              DISPLAY BY NAME g_gat[l_ac1].sel
              IF l_ac1 = g_rec_b1 THEN
                 EXIT FOR
              END IF
          END FOR
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about        
          CALL cl_about()    
 
       ON ACTION help        
          CALL cl_show_help() 
 
    END INPUT
    COMMIT WORK
 
    CLOSE WINDOW i931_1_w

END FUNCTION

#FUN-9B0150--begin--add------
FUNCTION i931_azw05(l_cmd)
DEFINE l_n1      LIKE type_file.num5
DEFINE l_azw05   LIKE azw_file.azw05
DEFINE l_cmd     LIKE type_file.chr1

    LET l_n1 = 0
    IF l_cmd = 'u' THEN
       SELECT count(*) INTO l_n1 FROM azw_file
        WHERE azw02 = g_azw02
          AND azw05 = azw06 
          AND azw01 <> g_azw_t.azw01
    ELSE
       SELECT count(*) INTO l_n1 FROM azw_file
        WHERE azw02 = g_azw02
          AND azw05 = azw06 
    END IF
#當有實體DB(azw05)=登入DB(azw06)時，且筆數 = 1 時，表示可能輸入了一筆 DS1 (ds1 / ds1) 
#或 DSALL (dsall / dsall) 資料，則只能再輸入 DS2 (ds2/ ds2) 或 DSV1-1 (dsall /dsv1) 的資料
    IF l_n1 = 1 THEN
       IF g_azw[l_ac].azw05 <> g_azw[l_ac].azw06 THEN
          IF l_cmd = 'u' THEN
             SELECT azw05 INTO l_azw05 FROM azw_file
              WHERE azw02 = g_azw02
                AND azw05 = azw06
                AND azw01 <> g_azw_t.azw01
          ELSE
             SELECT azw05 INTO l_azw05 FROM azw_file
              WHERE azw02 = g_azw02
                AND azw05 = azw06
          END IF
          IF l_azw05 <> g_azw[l_ac].azw05 THEN
             CALL cl_err('','aoo-417',0)
          END IF
       END IF
    END IF
#當有實體DB(azw05)=登入DB(azw06)時，且筆數 > 1 時，表示輸入了Multi DB的架構(如: DS1 (ds1/ds1) , 
#DS2 (ds2/ds2) ) 的資料，則不可再輸入 Single DB的架構(如 DSV1-1 (dsall/ dsv1) )
    IF l_n1 > 1 THEN
       IF g_azw[l_ac].azw05 <> g_azw[l_ac].azw06 THEN
          CALL cl_err('','aoo-418',0)
       END IF
    END IF
#當有實體DB(azw05)<>登入DB(azw06)的資料時，表示該法人為Single DB架構，
#不可再輸入實體DB(azw05)<>已存在的實體DB的資料
    LET l_n1 = 0
    IF l_cmd = 'u' THEN
       SELECT count(*) INTO l_n1 FROM azw_file
        WHERE azw02 = g_azw02
          AND azw05 <> azw06
          AND azw01 <> g_azw_t.azw01
    ELSE
       SELECT count(*) INTO l_n1 FROM azw_file
        WHERE azw02 = g_azw02
          AND azw05 <> azw06
    END IF
    IF l_n1 > 0 THEN
       IF l_cmd = 'u' THEN
          SELECT UNIQUE azw05 INTO l_azw05 FROM azw_file
           WHERE azw02 = g_azw02
             AND azw01 <> g_azw_t.azw01
       ELSE
          SELECT UNIQUE azw05 INTO l_azw05 FROM azw_file
           WHERE azw02 = g_azw02
       END IF
       IF l_azw05 <> g_azw[l_ac].azw05 THEN
          CALL cl_err('','aoo-417',0)
       END IF
    END IF
END FUNCTION

FUNCTION i931_azw05_a()
DEFINE l_n     LIKE type_file.num5
DEFINE l_n1    LIKE type_file.num5   #TQC-9C0157
DEFINE l_azw05 LIKE azw_file.azw05   #TQC-9C0157

      LET l_n = 0
      LET l_n1 = 0 #TQC-9C0157
      SELECT count(*) INTO l_n FROM azw_file
       WHERE azw02 = g_azw02
         AND azw05 = azw06
      #TQC-9C0157--begin--add--
      SELECT count(*) INTO l_n1 FROM azw_file
       WHERE azw02 = g_azw02
         AND azw05 <> azw06
      IF l_n = 1 AND l_n1 > 0 THEN
         SELECT DISTINCT azw05 INTO l_azw05 FROM azw_file
          WHERE azw02 = g_azw02
            AND azw05 = azw06
         IF g_azw[l_ac].azw05 = g_azw[l_ac].azw06 AND
            g_azw[l_ac].azw05 = l_azw05 THEN
            CALL cl_err('','aoo-420',0)
            RETURN TRUE
         END IF
      END IF
      IF l_n > 1 OR (l_n =1 AND l_n1 =0) THEN 
      #TQC-9C0157--end--add-----
         LET l_n = 0
         SELECT count(*) INTO l_n FROM azw_file
          WHERE azw02 = g_azw02
            AND azw05 = g_azw[l_ac].azw05
            AND azw06 = g_azw[l_ac].azw06
         IF l_n > 0 THEN
            CALL cl_err('','aoo-419',0)
            RETURN TRUE
         END IF
      END IF 
      RETURN FALSE
END FUNCTION

FUNCTION i931_b1()
DEFINE  l_n1   LIKE type_file.num5
DEFINE  l_n2   LIKE type_file.num5

         LET l_n1 = 0
         SELECT count(*) INTO l_n1 FROM azw_file
          WHERE azw02 = g_azw02
            AND azw05 <> azw06
         IF l_n1 > 0 THEN
            SELECT count(unique azw05) INTO l_n2 FROM azw_file
             WHERE azw02 = g_azw02
            IF l_n2 > 1 THEN
               CALL cl_err('','aoo-417',0)
               CALL i931_b()
            END IF
         END IF
END FUNCTION
#FUN-9B0150--end--add-----------

#FUN-9C0048--begin--add----
FUNCTION i931_b2()
DEFINE l_azw    RECORD LIKE azw_file.*
DEFINE l_n      LIKE type_file.num5
   DEFINE l_cnt SMALLINT, #FUN-A10018
          l_dbname LIKE azp_file.azp04 #FUN-A10018

   DECLARE i931_b2_cs CURSOR FOR
    SELECT * FROM azw_file
     WHERE azw02 = g_azw02
   FOREACH i931_b2_cs INTO l_azw.*
       #Begin:FUN-A10018
       LET l_dbname = NULL
       #判斷相同的azp03所對應的azp04是否已經存在.
       SELECT count(*) INTO l_cnt FROM azp_file WHERE azp03=l_azw.azw06 AND azp04 IS NOT NULL
       IF l_cnt>0 THEN
          #正常的資料來說,同一個azp03如果有azp04的話,一定都是相同的值.
          SELECT distinct azp04 INTO l_dbname FROM azp_file WHERE azp03=l_azw.azw06 AND azp04 IS NOT NULL
       END IF
       #End:FUN-A10018

       SELECT count(*) INTO l_n FROM azp_file
        WHERE azp01 = l_azw.azw01
       IF l_n > 0 THEN
          UPDATE azp_file SET azp01=l_azw.azw01,
                              azp02=l_azw.azw08,
                              azp03=l_azw.azw06,
                              azp04=l_dbname #FUN-A10018:增加azp04的設定
           WHERE azp01 = l_azw.azw01
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","zap_file",l_azw.azw01,"",SQLCA.sqlcode,"","",0)
             CONTINUE FOREACH
          END IF
       ELSE
          INSERT INTO azp_file(azp01,azp02,azp03,azp04,azp053,azp052,azp09) #FUN-A10018:增加azp04的設定
             VALUES(l_azw.azw01,l_azw.azw08,l_azw.azw06,l_dbname,'Y','GMT+8','N')
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","zap_file",l_azw.azw01,"",SQLCA.sqlcode,"","",0)
             CONTINUE FOREACH
          END IF
       END IF
   END FOREACH
END FUNCTION

FUNCTION i931_b3()
DEFINE l_cnt    LIKE type_file.num5 

   SELECT COUNT(DISTINCT azw05) INTO l_cnt FROM azw_file
    WHERE azw02 = g_azw02
   IF l_cnt = 1 THEN   #single DB
      LET g_azw09 = g_azw[1].azw05
      UPDATE azw_file SET azw09 = g_azw09
       WHERE azw02 = g_azw02
      DISPLAY g_azw09 TO azw09
   END IF
   IF l_cnt > 1 THEN  #Multi DB
      IF cl_null(g_azw09) THEN #單頭法人DB無資料
         CALL i931_azw09(g_azw09) RETURNING g_azw09
         DISPLAY g_azw09 TO azw09
      ELSE   #單頭法人DB有資料
         IF cl_chk_schema_has_built(g_azw09) THEN
            DISPLAY g_azw09 TO azw09
         ELSE
            CALL i931_azw09(g_azw09) RETURNING g_azw09
            DISPLAY g_azw09 TO azw09
         END IF
      END IF
      IF NOT cl_null(g_azw09) THEN
         UPDATE azw_file SET azw09 = g_azw09
          WHERE azw02 = g_azw02
          DISPLAY g_azw09 TO azw09
      END IF
   END IF
END FUNCTION

FUNCTION i931_azw09(p_azw09)
DEFINE l_azw09      LIKE azw_file.azw09
DEFINE l_n          LIKE type_file.num5
DEFINE p_azw09      LIKE azw_file.azw09

    OPEN WINDOW i931_2_w AT 12,40 WITH FORM "aoo/42f/aooi931_2"
    ATTRIBUTE(STYLE = g_win_style)
 
    CALL cl_ui_locale("aooi931_2")

    INPUT l_azw09 WITHOUT DEFAULTS FROM azw09p
      
       BEFORE INPUT
         LET l_azw09 = p_azw09
         DISPLAY l_azw09 TO azw09p

       AFTER FIELD azw09p
         SELECT count(*) INTO l_n FROM azw_file
          WHERE azw02 = g_azw02
            AND azw05 = l_azw09
       IF l_n = 0 THEN
          CALL cl_err('','aic-036',0)
          NEXT FIELD azw09p
       END IF

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(azw09p)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azw09"
                 LET g_qryparam.default1 = l_azw09
                 LET g_qryparam.arg1 = g_azw02
                 CALL cl_create_qry() RETURNING l_azw09
                 DISPLAY l_azw09 TO azw09p
                 NEXT FIELD azw09p
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()
      
      AFTER INPUT
        IF INT_FLAG THEN                         # 若按了DEL鍵
           LET INT_FLAG = 0
           EXIT INPUT
        END IF

       ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
       
       ON ACTION about
          CALL cl_about()
 
       ON ACTION help
          CALL cl_show_help()
    END INPUT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
    END IF
    CLOSE WINDOW i931_2_w
    RETURN l_azw09
END FUNCTION
#FUN-9C0048--end--add-----
#FUN-980020--end


#FUN-A40090  #FUN-A50079 
FUNCTION i931_chk_dbname(p_azw05)
   DEFINE p_azw05  LIKE azw_file.azw05
   DEFINE l_dbname STRING
   DEFINE l_len    INTEGER
   LET l_dbname = p_azw05
   LET l_dbname = l_dbname.trim()

   IF p_azw05[1] MATCHES "[0-9]" THEN   #資料庫名稱開頭不得為數字
      CALL cl_err("","aoo-931",1)
      RETURN FALSE
   END IF

   FOR l_len = 1 TO l_dbname.getLength() #資料庫名稱只可包含大小寫英文及_$#符號
      IF l_dbname.getCharAt(l_len) NOT MATCHES "[A-Za-z0-9_$#]" THEN
         CALL cl_err("","aoo-507",1)
         RETURN FALSE
      END IF
   END FOR
   RETURN TRUE
END FUNCTION
 
FUNCTION i931_chk_login_db()  #No.FUN-A50079 出現提示建議使用者登入DB能統一
   DEFINE l_cnt   LIKE type_file.num5
   DEFINE l_sql   STRING

   LET l_sql = "SELECT COUNT(DISTINCT AZW06) FROM AZW_FILE ",
                                           "WHERE AZW02=? ",
                                           "AND AZW05 <> AZW06 "
   PREPARE i931_logindb_p1 FROM l_sql
   EXECUTE i931_logindb_p1 USING g_azw02 INTO l_cnt  
   IF l_cnt > 1 THEN  #l_cnt > 1表示設定了超過2個以上的登入DB名稱
      CALL cl_err("","aoo-933",1)
   END IF
   FREE i931_logindb_p1  
END FUNCTION
#FUN-AA0054

#---FUN-B50089---start-----
#刪除zta_file, azwd_file相關資料
FUNCTION i931_data_r(p_azw06)
   DEFINE p_azw06            STRING       #DB user schema名稱,可用多個名稱組合,中間用"|"等號隔開,如:ds1|ds4|dsall
   DEFINE l_azp03            LIKE azp_file.azp03
   DEFINE l_tok              base.StringTokenizer
   
   #將schema名稱拆解,並刪除相關資料
   LET l_tok = base.StringTokenizer.create(p_azw06, "|")
   WHILE l_tok.hasMoreTokens()
      LET l_azp03 = l_tok.nextToken()

      #刪除zta_file zta02屬於該schema的資料
      DELETE FROM zta_file WHERE zta02 = l_azp03
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del", "zta_file", l_azp03, SQLCA.sqlcode, "", "", "", 1)  
         RETURN FALSE
      END IF

      #刪除azwd_file azwd01屬於該schema的資料
      DELETE FROM azwd_file WHERE azwd01 = l_azp03
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del", "azwd_file", l_azp03, SQLCA.sqlcode, "", "", "", 1)  
         RETURN FALSE
      END IF
   END WHILE

   CALL i931_fglprofile_r(p_azw06)
   RETURN TRUE
END FUNCTION

#刪除$FGLPROFILE該db設定
FUNCTION i931_fglprofile_r(p_azw06)
   DEFINE p_azw06            STRING       #DB user schema名稱,可用多個名稱組合,中間用"|"等號隔開,如:ds1|ds4|dsall
   DEFINE l_fglprofile       STRING       #FGLPROFILE檔案路徑
   DEFINE l_dirname          STRING       #FGLPROFILE檔案所在目錄路徑
   DEFINE l_basename         STRING       #FGLPROFILE檔名
   DEFINE l_fglprofile_bk    STRING       #FGLPROFILE檔備份檔案
   DEFINE l_file             STRING       #FGLPROFILE檔暫存檔名
   DEFINE l_path             STRING       #FGLPROFILE檔暫存檔路徑
   DEFINE l_line             STRING       #FGLPROFILE檔讀取行之內容
   DEFINE l_line_lowerCase   STRING       #轉成全小寫內容
   DEFINE l_user             STRING       #DB user
   DEFINE l_key              STRING       #尋找key值
   DEFINE l_err              STRING       #錯誤訊息
   DEFINE l_ch               base.Channel  
   DEFINE lc_channel         base.Channel
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_length           LIKE type_file.num5
   DEFINE l_tok              base.StringTokenizer
   DEFINE l_azw06            DYNAMIC ARRAY OF STRING

   IF cl_null(p_azw06) THEN
      DISPLAY "fglprofile isn't delete."
      RETURN
   END IF
   
   TRY
      LET l_fglprofile = FGL_GETENV("FGLPROFILE")
   
      #判斷是否有寫入FGLPROFILE的權限
      IF NOT i931_fglprofile(l_fglprofile) THEN
         LET p_azw06 = cl_replace_str(p_azw06, "|", ",")
         CALL cl_err_msg(null, "aoo-426", g_user || "|" || p_azw06, 10)
         RETURN
      END IF
   
      #抓取$FGLPROFILE檔案目錄所在位置
      LET l_dirname = os.Path.dirname(FGL_GETENV("FGLPROFILE"))

      #抓取$FGLPROFILE檔案檔名
      LET l_basename = os.Path.basename(FGL_GETENV("FGLPROFILE"))

      #將db名稱拆解,並尋找FGLPROFILE是否原本就存有此db設定
      LET l_tok = base.StringTokenizer.create(p_azw06, "|")
      LET l_i = 1
      WHILE l_tok.hasMoreTokens()
         LET l_key = l_tok.nextToken()
         LET l_user = fgl_getResource("dbi.database."|| l_key ||".username")
         #判斷要刪除之DB User設定是否已存在FGLPROFILE內
         IF l_user IS NOT NULL THEN
            LET l_azw06[l_i] = l_key.trim()
            LET l_i = l_i + 1
         END IF
      END WHILE
      CALL l_azw06.deleteElement(l_i)

      #進行註解FGLPROFILE該DB相關資訊
      LET l_length = l_azw06.getLength()
      IF l_length > 0 THEN
         #開啟FGLPROFILE檔案,預備做讀取內容動作
         LET lc_channel = base.Channel.create()
         CALL lc_channel.openFile(l_fglprofile CLIPPED, "r" )      
         CALL lc_channel.setDelimiter("")
      
         #開啟tmp檔,覆寫一份FGLPROFILE設定
         LET l_file = l_basename, ".tmp"
         LET l_path = os.Path.join(l_dirname, l_file)
         DISPLAY "path", l_path
         LET l_ch = base.Channel.create()
         CALL l_ch.openFile(l_path, "w")
         CALL l_ch.setDelimiter("")
   
         WHILE TRUE
            LET l_line = lc_channel.readLine()
         
            #檔案讀取完畢,關閉檔案,離開迴圈
            IF lc_channel.isEof() THEN               
               CALL lc_channel.close()
               EXIT WHILE
            END IF
         
            LET l_line = l_line.trim()
            LET l_line_lowerCase = l_line.toLowerCase()

            IF l_line.getCharAt(1) <> "#" THEN
               #判斷此行資料是否為該DB User設定內容,如果是就註解此行內容
               FOR l_i = 1 TO l_length
                   LET l_key = "dbi.database.", l_azw06[l_i].trim(), "."
                   IF l_line_lowerCase.getIndexOf(l_key, 1) > 0 THEN
                      LET l_line = "#", l_line
                      EXIT FOR
                   END iF
               END FOR
            END IF

            #回寫tmp檔
            CALL l_ch.write(l_line)
         END WHILE

         #判斷FGLPROFILE備份檔是否存在
         LET l_fglprofile_bk = l_fglprofile, ".bk"
         IF os.Path.exists(l_fglprofile_bk) THEN
            #刪除備份檔
            IF NOT os.Path.delete(l_fglprofile_bk) THEN
               DISPLAY l_fglprofile_bk, " delete failure!"
            END IF
         END IF
      
         #LET l_fglprofile_bk = os.Path.join(l_dirname, l_fglprofile_bk)
         #將原本FGLPROFILE檔名變更成.bk備份檔
         IF os.Path.exists(l_fglprofile) THEN
            IF NOT os.Path.rename(l_fglprofile, l_fglprofile_bk) THEN
               DISPLAY l_fglprofile, " rename failure!"
            END IF
         END IF

         #將現在新增之FGLPROFILE tmp檔名變更成FGLPROFILE檔
         DISPLAY "l_path:", l_path
         IF os.Path.exists(l_path) THEN
         	 IF NOT os.Path.rename(l_path, l_fglprofile) THEN
            	  DISPLAY l_path, " rename failure!"
            END IF
         END IF
      ELSE
     	  DISPLAY g_dbs, " isn't existed. Not delete."
      END IF
   CATCH
      #修改FGLPROFILE過程有問題
      LET l_err = ERR_GET(STATUS)
      DISPLAY "error msg: ", l_err
      CALL cl_err_msg(null, "aoo-427", l_azw06[l_i].trim(), 10)
   END TRY
END FUNCTION

#判斷登入使用者是否有寫入FGLPROFILE的權限.
FUNCTION i931_fglprofile(p_fileName)
   DEFINE p_fileName     STRING   #檔案名稱
   DEFINE l_flag         BOOLEAN  #是否有寫入權限
   
   LET l_flag = os.Path.writable(p_fileName)
   RETURN l_flag   
END FUNCTION
#---FUN-B50089---end-------

#FUN-B80035
