# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aski009.4gl
# Descriptions...: 混包裝方式維護作業
# Date & Author..: 2008/01/21 By  ve007
# Modify.........: No.FUN-820046 08/02/27 by chenyu
# Modify.........: No.FUN-830089 FUN-840137 08/03/31 by chenyu
# Modify.........: No.FUN-840036 FUN-830116 08/04/09 by chenyu
# Modify.........: No.FUN-870117 08/08/14 by chenyu 過單
# Modify.........: No.FUN-8A0145 08/10/31 by hongmei 欄位類型修改
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.TQC-940106 09/05/08 By mike 資料無效不可刪除
# Modify.........: No.TQC-940168 09/08/25 By alex 調整cl_used位置
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0072 10/01/12 By vealxu 精簡程式碼
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A70130 10/08/11 By huangtao 修改q_oay*()的參數
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管 
# Modify.........: No.FUN-AB0025 10/11/11 By huangtao 添加料號控管
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80030 11/08/03 By minpp 模组程序撰写规范修改
# Modify.........: No.TQC-BA0127 11/10/24 By destiny oriu,orig不能查询
# Modify.........: No:FUN-910088 11/11/15 By xujing 增加數量欄位小數取位
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D40030 13/04/08 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題


DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_obi              RECORD LIKE obi_file.*,       #簽核等級 (單頭)
       g_obi_t            RECORD LIKE obi_file.*,       #簽核等級 (舊值)
       g_obi_o            RECORD LIKE obi_file.*,       #簽核等級 (舊值)
       g_obi01_t          LIKE obi_file.obi01,          #簽核等級 (舊值)
       g_t1               LIKE oay_file.oayslip,       
       g_sheet            LIKE oay_file.oayslip,        #單別 (沿用)
       g_ydate            LIKE type_file.dat,           #單據日期(沿用)
       g_obj              DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
           att00          LIKE obj_file.obj02,          #款式編號
           att01          LIKE obj_file.obj03,          #款式品名
           att02          LIKE agd_file.agd02,          #
           att02_c        LIKE agd_file.agd02,          #
           att03          LIKE agd_file.agd02,          #
           att03_c        LIKE agd_file.agd02,          #
           att04          LIKE obj_file.obj06,          #
           att05          LIKE obj_file.obj06,          #
           att06          LIKE obj_file.obj06,          #
           att07          LIKE obj_file.obj06,          #
           att08          LIKE obj_file.obj06,          #
           att09          LIKE obj_file.obj06,          #
           att10          LIKE obj_file.obj06,          #
           att11          LIKE obj_file.obj06,          #
           att12          LIKE obj_file.obj06,          #
           att13          LIKE obj_file.obj06,          #
           obj02          LIKE obj_file.obj02,          #產品編號
           obj03          LIKE obj_file.obj03,          #品名
           obj04          LIKE obj_file.obj04,          #內包裝數 
           obj05          LIKE obj_file.obj05,          #內包裝含產品數量
           obj06          LIKE obj_file.obj06,          #總數量
           obj07          LIKE obj_file.obj07,          #單位
           obj08          LIKE obj_file.obj08,          #內包裝長
           obj09          LIKE obj_file.obj09,          #內包裝寬
           obj10          LIKE obj_file.obj10,          #內包裝高
           obj11          LIKE obj_file.obj11,          #內包裝體積
           obj12          LIKE obj_file.obj12,          #內包裝重
           obj13          LIKE obj_file.obj13,          #單個產品凈重 
           obj14          LIKE obj_file.obj14           #備注
                          END RECORD,
       g_obj_t           RECORD                        #程式變數 (舊值)
           att00          LIKE obj_file.obj02,          #款式編號
           att01          LIKE obj_file.obj03,          #款式品名
           att02          LIKE agd_file.agd02,          #
           att02_c        LIKE agd_file.agd02,          #
           att03          LIKE agd_file.agd02,          #
           att03_c        LIKE agd_file.agd02,          #
           att04          LIKE obj_file.obj06,          #
           att05          LIKE obj_file.obj06,          #
           att06          LIKE obj_file.obj06,          #
           att07          LIKE obj_file.obj06,          #
           att08          LIKE obj_file.obj06,          #
           att09          LIKE obj_file.obj06,          #
           att10          LIKE obj_file.obj06,          #
           att11          LIKE obj_file.obj06,          #
           att12          LIKE obj_file.obj06,          #
           att13          LIKE obj_file.obj06,          #
           obj02          LIKE obj_file.obj02,          #產品編號
           obj03          LIKE obj_file.obj03,          #品名
           obj04          LIKE obj_file.obj04,          #內包裝數 
           obj05          LIKE obj_file.obj05,          #內包裝含產品數量
           obj06          LIKE obj_file.obj06,          #總數量
           obj07          LIKE obj_file.obj07,          #單位
           obj08          LIKE obj_file.obj08,          #內包裝長
           obj09          LIKE obj_file.obj09,          #內包裝寬
           obj10          LIKE obj_file.obj10,          #內包裝高
           obj11          LIKE obj_file.obj11,          #內包裝體積
           obj12          LIKE obj_file.obj12,          #內包裝重
           obj13          LIKE obj_file.obj13,          #單個產品凈重 
           obj14          LIKE obj_file.obj14           #備注
                          END RECORD,
       g_obj_o           RECORD                        #程式變數 (舊值)
           att00          LIKE obj_file.obj02,          #款式編號
           att01          LIKE obj_file.obj03,          #款式品名
           att02          LIKE agd_file.agd02,          #
           att02_c        LIKE agd_file.agd02,          #
           att03          LIKE agd_file.agd02,          #
           att03_c        LIKE agd_file.agd02,          #
           att04          LIKE obj_file.obj06,          #
           att05          LIKE obj_file.obj06,          #
           att06          LIKE obj_file.obj06,          #
           att07          LIKE obj_file.obj06,          #
           att08          LIKE obj_file.obj06,          #
           att09          LIKE obj_file.obj06,          #
           att10          LIKE obj_file.obj06,          #
           att11          LIKE obj_file.obj06,          #
           att12          LIKE obj_file.obj06,          #
           att13          LIKE obj_file.obj06,          #
           obj02          LIKE obj_file.obj02,          #產品編號
           obj03          LIKE obj_file.obj03,          #品名
           obj04          LIKE obj_file.obj04,          #內包裝數 
           obj05          LIKE obj_file.obj05,          #內包裝含產品數量
           obj06          LIKE obj_file.obj06,          #總數量
           obj07          LIKE obj_file.obj07,          #單位
           obj08          LIKE obj_file.obj08,          #內包裝長
           obj09          LIKE obj_file.obj09,          #內包裝寬
           obj10          LIKE obj_file.obj10,          #內包裝高
           obj11          LIKE obj_file.obj11,          #內包裝體積
           obj12          LIKE obj_file.obj12,          #內包裝重
           obj13          LIKE obj_file.obj13,          #單個產品凈重 
           obj14          LIKE obj_file.obj14           #備注
                          END RECORD,
      #g_sql              LIKE type_file.chr1000,       #CURSOR暫存 #TQC-BA0127
       g_sql              STRING,                       #TQC-BA0127
      #g_wc               LIKE type_file.chr1000,       #單頭CONSTRUCT結果 #TQC-BA0127
       g_wc               STRING,                       #TQC-BA0127
      #g_wc2              LIKE type_file.chr1000,       #單身CONSTRUCT結果 #TQC-BA0127
       g_wc2              STRING,                       #TQC-BA0127
      #g_wc3              LIKE type_file.chr1000,       #單身CONSTRUCT結果 #TQC-BA0127
       g_wc3              STRING,                       #TQC-BA0127
       g_rec_b            LIKE type_file.num5,          #單身筆數  
       l_ac               LIKE type_file.num5           #目前處理的ARRAY CNT  
DEFINE g_forupd_sql        LIKE type_file.chr1000                       #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done LIKE type_file.num5    
DEFINE g_chr               LIKE type_file.chr1    
DEFINE g_cnt               LIKE type_file.num10   
DEFINE g_i                 LIKE type_file.num5          #count/index for any purpose  
DEFINE g_msg               LIKE ze_file.ze03      
DEFINE g_curs_index        LIKE type_file.num10   
DEFINE g_row_count         LIKE type_file.num10         #總筆數  
DEFINE g_jump              LIKE type_file.num10         #查詢指定的筆數  
DEFINE g_no_ask           LIKE type_file.num5          #是否開啟指定筆視窗  
DEFINE g_argv2             LIKE type_file.chr1000                       #指定執行的功能 
DEFINE g_argv3             LIKE obj_file.obj11
DEFINE lr_agc              DYNAMIC ARRAY OF RECORD LIKE agc_file.*
DEFINE g_ocq               DYNAMIC ARRAY OF RECORD LIKE ocq_file.*
DEFINE arr_detail          DYNAMIC ARRAY OF RECORD
       imx00             LIKE imx_file.imx00,
       imx               ARRAY[13] OF LIKE imx_file.imx01 
       END RECORD
DEFINE arr_show            DYNAMIC ARRAY OF RECORD
       att00             LIKE ima_file.ima01,
       att               ARRAY[13] OF LIKE obj_file.obj06 
       END RECORD,
       lg_obj              DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
           att00          LIKE obj_file.obj02,          #款式編號
           att01          LIKE obj_file.obj03,          #款式品名
           att02          LIKE agd_file.agd02,          #
           att02_c        LIKE agd_file.agd02,          #
           att03          LIKE agd_file.agd02,          #
           att03_c        LIKE agd_file.agd02,          #
           att04          LIKE obj_file.obj06,          #
           att05          LIKE obj_file.obj06,          #
           att06          LIKE obj_file.obj06,          #
           att07          LIKE obj_file.obj06,          #
           att08          LIKE obj_file.obj06,          #
           att09          LIKE obj_file.obj06,          #
           att10          LIKE obj_file.obj06,          #
           att11          LIKE obj_file.obj06,          #
           att12          LIKE obj_file.obj06,          #
           att13          LIKE obj_file.obj06,          #
           obj02          LIKE obj_file.obj02,          #產品編號
           obj03          LIKE obj_file.obj03,          #品名
           obj04          LIKE obj_file.obj04,          #內包裝數 
           obj05          LIKE obj_file.obj05,          #內包裝含產品數量
           obj06          LIKE obj_file.obj06,          #總數量
           obj07          LIKE obj_file.obj07,          #單位
           obj08          LIKE obj_file.obj08,          #內包裝長
           obj09          LIKE obj_file.obj09,          #內包裝寬
           obj10          LIKE obj_file.obj10,          #內包裝高
           obj11          LIKE obj_file.obj11,          #內包裝體積
           obj12          LIKE obj_file.obj12,          #內包裝重
           obj13          LIKE obj_file.obj13,          #單個產品凈重 
           obj14          LIKE obj_file.obj14           #備注
                          END RECORD
DEFINE     g_obj07_t      LIKE obj_file.obj07           #備份單位舊值
 
#主程式開始
MAIN
   DEFINE l_sma124   LIKE sma_file.sma124
   DEFINE l_hide     LIKE type_file.chr1000
   DEFINE l_show     LIKE type_file.chr1000
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASK")) THEN
      EXIT PROGRAM
   END IF          
 
   IF NOT s_industry('slk') THEN                                                
      CALL cl_err("","-1000",1)                                                 
      EXIT PROGRAM                                                              
   END IF
 
   LET g_forupd_sql = "SELECT * FROM obi_file WHERE obi01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i009_cl CURSOR FROM g_forupd_sql
 
   IF g_sma.sma128 != 'Y' THEN  #不使用混合包裝
      CALL cl_err("","-1001",1)
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #TQC-940168
 
   OPEN WINDOW i009_w WITH FORM "ask/42f/aski009"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   IF g_sma.sma120 != 'Y' THEN  #不使用多屬性
      CALL cl_set_comp_visible("obi12,obi12_ocq02,obi14,obi14_aga02",FALSE)
   ELSE
      CALL cl_set_comp_visible("obi12,obi12_ocq02,obi14,obi14_aga02",TRUE)
   END IF
 
   LET l_hide = "att00,att01,att02,att02_c,att03,att03_c,att04,att05,att06,att07,att08,att09,att10,att11,att12,att13"
   LET l_show = "obj02,obj03,obj04,obj06"
 
   CALL cl_set_comp_visible(l_hide,FALSE)
   CALL cl_set_comp_visible(l_show,TRUE)
 
   LET g_ydate = NULL
 
   CALL i009_menu()
   CLOSE WINDOW i009_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION i009_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01    
 
   CLEAR FORM 
   CALL g_obj.clear()
             
      INITIALIZE g_obi.* TO NULL      
      CONSTRUCT BY NAME g_wc ON obi01,obi02,obi03,obi04,obi05,obi06,obi07,
                                obi08,obi09,obi10,obi11,obi12,obi13,obi14,
                                obiuser,obigrup,obimodu,obidate,obiacti
                                ,obioriu,obiorig  #TQC-BA0127 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(obi01) #包裝編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_obi01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO obi01
                  NEXT FIELD obi01
 
               WHEN INFIELD(obi12) #未維屬性組
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_obi12"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO obi12
                  NEXT FIELD obi12
 
               WHEN INFIELD(obi14) #屬性群組
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_obi14"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO obi14
                  NEXT FIELD obi14
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
      
      END CONSTRUCT
      
      IF INT_FLAG THEN
         RETURN
      END IF
 
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('obiuser', 'obigrup')
 
   CALL cl_set_comp_visible("att00,att01,att02,att02_c,att03,att03_c,att04,att05,att06,att07,att08,att09,att10,att11,att12,att13",FALSE)
   CALL cl_set_comp_visible("obj02,obj03,obj04,obj05,obj06,obj07,obj08,obj09,obj10,obj11,obj12,obj13,obj14",TRUE)
 
      CONSTRUCT g_wc2 ON obj02,obj03,obj04,obj05,obj06,obj07,   #螢幕上取單身條件 
                         obj08,obj09,obi10,obj11,obj12,obj13,obj14
              FROM s_obj[1].obj02,s_obj[1].obj03,s_obj[1].obj04,
                   s_obj[1].obj05,s_obj[1].obj06,s_obj[1].obj07,
                   s_obj[1].obj08,s_obj[1].obj09,s_obj[1].obj10,
                   s_obj[1].obj11,s_obj[1].obj12,s_obj[1].obj13,s_obj[1].obj14
 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
   
         ON ACTION CONTROLP
            CASE
             WHEN INFIELD(obj02) #產品編號
#FUN-AA0059---------mod------------str-----------------
#             CALL cl_init_qry_var()
#             LET g_qryparam.state = 'c'
#             LET g_qryparam.form ="q_obj02"
#             CALL cl_create_qry() RETURNING g_qryparam.multiret
              CALL q_sel_ima(TRUE, "q_obj02","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
              DISPLAY g_qryparam.multiret TO obj02
              NEXT FIELD obj02
 
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
    
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END CONSTRUCT
   
      IF INT_FLAG THEN
         RETURN
      END IF
 
   IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
      LET g_sql = "SELECT  obi01 FROM obi_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY obi01"
   ELSE                              # 若單身有輸入條件
      LET g_sql = "SELECT  obi01 ",
                  "  FROM obi_file, obj_file ",
                  " WHERE obi01 = obj01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY obi01"
   END IF
 
   PREPARE i009_prepare FROM g_sql
   DECLARE i009_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i009_prepare
 
   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM obi_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT obi01) FROM obi_file,obj_file WHERE ",
                "obj01=obi01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
 
   PREPARE i009_precount FROM g_sql
   DECLARE i009_count CURSOR FOR i009_precount
 
END FUNCTION
 
FUNCTION i009_menu()
 
   WHILE TRUE
      CALL i009_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i009_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i009_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i009_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i009_u()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i009_x()
            END IF
 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i009_copy()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i009_show_field()   #控制單身顯示
               CALL i009_b()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_obj),'','')
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_obi.obi01 IS NOT NULL THEN
                 LET g_doc.column1 = "obi01"
                 LET g_doc.value1 = g_obi.obi01
                 CALL cl_doc()
               END IF
         END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i009_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_obj TO s_obj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i009_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION previous
         CALL i009_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION jump
         CALL i009_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION next
         CALL i009_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION last
         CALL i009_fetch('L')
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
 
      ON ACTION controls                                      
         CALL cl_set_head_visible("","AUTO")       
 
      ON ACTION related_document                #相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i009_a()
   DEFINE li_result   LIKE type_file.num5    
   DEFINE ls_doc      LIKE type_file.chr1000
   DEFINE li_inx      LIKE type_file.num10   
 
   MESSAGE ""
   CLEAR FORM
   CALL g_obj.clear()
   LET g_wc  = NULL 
   LET g_wc2 = NULL 
   LET g_wc3 = NULL 
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_obi.* LIKE obi_file.*            #DEFAULT 設定
   LET g_obi01_t = NULL
 
   #預設值及將數值類變數清成零
   LET g_obi_t.* = g_obi.*
   LET g_obi_o.* = g_obi.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_obi.obiuser=g_user
      LET g_obi.obioriu = g_user #FUN-980030
      LET g_obi.obiorig = g_grup #FUN-980030
      LET g_obi.obigrup=g_grup
      LET g_obi.obidate=g_today
      LET g_obi.obiacti='Y'              #資料有效
 
      CALL i009_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_obi.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF NOT cl_null(g_obi.obi12) THEN
         IF cl_null(g_obi.obi14) THEN
            CALL cl_err('','ask-043',0)
            CONTINUE WHILE
         END IF
      END IF
 
      IF cl_null(g_obi.obi01) THEN       # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      #輸入後, 若該單據需自動編號, 並且其單號為空白, 則自動賦予單號
      BEGIN WORK
      CALL s_auto_assign_no("axm",g_obi.obi01,g_today,"61","obi_file","obi01","","","") RETURNING li_result,g_obi.obi01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_obi.obi01
 
      INSERT INTO obi_file VALUES (g_obi.*)
 
      CALL s_get_doc_no(g_obi.obi01) RETURNING g_sheet
 
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
         CALL cl_err3("ins","obi_file",g_obi.obi01,"",SQLCA.sqlcode,"","",1)  #FUN-B80030
         ROLLBACK WORK      
        # CALL cl_err3("ins","obi_file",g_obi.obi01,"",SQLCA.sqlcode,"","",1)  #FUN-B80030
         CONTINUE WHILE
      ELSE
         COMMIT WORK        
         CALL cl_flow_notify(g_obi.obi01,'I')
      END IF
 
      SELECT obi01 INTO g_obi.obi01 FROM obi_file
       WHERE obi01 = g_obi.obi01
      LET g_obi01_t = g_obi.obi01        #保留舊值
      LET g_obi_t.* = g_obi.*
      LET g_obi_o.* = g_obi.*
      CALL g_obj.clear()
 
      LET g_rec_b = 0 
      CALL i009_show_field()             #控制單身顯示 
      CALL i009_b()                      #輸入單身
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i009_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_obi.obi01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_obi.* FROM obi_file
    WHERE obi01=g_obi.obi01
 
   IF g_obi.obiacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_obi.obi01,'mfg1000',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_obi01_t = g_obi.obi01
   BEGIN WORK
 
   OPEN i009_cl USING g_obi.obi01
   IF STATUS THEN
      CALL cl_err("OPEN i009_cl:", STATUS, 1)
      CLOSE i009_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i009_cl INTO g_obi.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_obi.obi01,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE i009_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL i009_show()
 
   WHILE TRUE
      LET g_obi01_t = g_obi.obi01
      LET g_obi_o.* = g_obi.*
      LET g_obi.obimodu=g_user
      LET g_obi.obidate=g_today
 
      CALL i009_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_obi.*=g_obi_t.*
         CALL i009_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_obi.obi01 != g_obi01_t THEN            # 更改單號
         UPDATE obj_file SET obj01 = g_obi.obi01
          WHERE obj01 = g_obi01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","obj_file",g_obi01_t,"",SQLCA.sqlcode,"","obj",1)  
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE obi_file SET obi_file.* = g_obi.*
       WHERE obi01 = g_obi01_t
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","obi_file","","",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE i009_cl
   COMMIT WORK
   CALL cl_flow_notify(g_obi.obi01,'U')
   CALL i009_show_field()
   CALL i009_b_fill("1=1")
 
END FUNCTION
 
FUNCTION i009_i(p_cmd)
DEFINE
   l_n       LIKE type_file.num5,    
   p_cmd     LIKE type_file.chr1     #a:輸入 u:更改  
DEFINE    li_result   LIKE type_file.num5   
DEFINE    l_ocq03     LIKE ocq_file.ocq03
DEFINE    l_agb03     LIKE agb_file.agb03 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_obi.obiuser,g_obi.obimodu,
                   g_obi.obigrup,g_obi.obidate,g_obi.obiacti
 
   CALL cl_set_head_visible("","YES")           
   INPUT BY NAME g_obi.obi01,g_obi.obi02,g_obi.obi11,g_obi.obi03, g_obi.obioriu,g_obi.obiorig,
                 g_obi.obi04,g_obi.obi05,g_obi.obi09,g_obi.obi06,
                 g_obi.obi07,g_obi.obi08,g_obi.obi10,g_obi.obi12,
                 g_obi.obi14,g_obi.obi13
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i009_set_entry(p_cmd)
         CALL i009_set_no_entry(p_cmd)
         IF p_cmd = 'u' THEN
            CALL cl_set_comp_entry("obi12",FALSE)
         END IF
         IF p_cmd != 'u' THEN
            CALL cl_set_comp_entry("obi12",TRUE)
         END IF
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("obi01")
         IF NOT cl_null(g_obi.obi12) THEN
            CALL cl_set_comp_entry("obi14",TRUE)
         ELSE
            CALL cl_set_comp_entry("obi14",FALSE)
         END IF
 
      AFTER FIELD obi01
         #單號處理方式:
         #在輸入單別後, 至單據性質檔中讀取該單別資料;
         #若該單別不需自動編號, 則讓使用者自行輸入單號, 並檢查其是否重複
         #若要自動編號, 則單號不用輸入, 直到單頭輸入完成後, 再行自動指定單號
         IF NOT cl_null(g_obi.obi01) THEN
            CALL s_check_no("axm",g_obi.obi01,g_obi01_t,"61","obi_file","obi01","") RETURNING li_result,g_obi.obi01
            DISPLAY BY NAME g_obi.obi01
            IF (NOT li_result) THEN
               LET g_obi.obi01=g_obi_o.obi01
               RETURN
            END IF
            DISPLAY g_smy.smydesc TO smydesc
            IF g_obi.obi01 != g_obi01_t OR g_obi01_t IS NULL THEN
            END IF
         END IF
 
      AFTER FIELD obi03
         IF NOT cl_null(g_obi.obi03) THEN
            IF g_obi_t.obi03 IS NULL 
               OR g_obi.obi03 != g_obi_t.obi03 THEN
               IF g_obi.obi03 < 0 THEN
                  CALL cl_err('','aim-223',0)
                  NEXT FIELD obi03
               END IF
               LET g_obi.obi09 = g_obi.obi03*g_obi.obi04*g_obi.obi05
            END IF
         END IF
 
      AFTER FIELD obi04
         IF NOT cl_null(g_obi.obi04) THEN
            IF g_obi_t.obi04 IS NULL 
               OR g_obi.obi04 != g_obi_t.obi04 THEN
               IF g_obi.obi04 < 0 THEN
                  CALL cl_err('','aim-223',0)
                  NEXT FIELD obi04
               END IF
               LET g_obi.obi09 = g_obi.obi03*g_obi.obi04*g_obi.obi05
            END IF
         END IF
 
      AFTER FIELD obi05
         IF NOT cl_null(g_obi.obi05) THEN
            IF g_obi_t.obi05 IS NULL 
               OR g_obi.obi05 != g_obi_t.obi05 THEN
               IF g_obi.obi05 < 0 THEN
                  CALL cl_err('','aim-223',0)
                  NEXT FIELD obi05
               END IF
               LET g_obi.obi09 = g_obi.obi03*g_obi.obi04*g_obi.obi05
            END IF
         END IF
 
      AFTER FIELD obi06
         IF NOT cl_null(g_obi.obi06) THEN
            IF g_obi_t.obi06 IS NULL 
               OR g_obi.obi06 != g_obi_t.obi06 THEN
               IF g_obi.obi06 < 0 THEN
                  CALL cl_err('','aim-223',0)
                  NEXT FIELD obi06
               END IF
               LET g_obi.obi10 = g_obi.obi06*g_obi.obi07*g_obi.obi08
            END IF
         END IF
 
      AFTER FIELD obi07
         IF NOT cl_null(g_obi.obi07) THEN
            IF g_obi_t.obi07 IS NULL 
               OR g_obi.obi07 != g_obi_t.obi07 THEN
               IF g_obi.obi07 < 0 THEN
                  CALL cl_err('','aim-223',0)
                  NEXT FIELD obi07
               END IF
               LET g_obi.obi10 = g_obi.obi06*g_obi.obi07*g_obi.obi08
            END IF
         END IF
 
      AFTER FIELD obi08
         IF NOT cl_null(g_obi.obi08) THEN
            IF g_obi_t.obi08 IS NULL 
               OR g_obi.obi08 != g_obi_t.obi08 THEN
               IF g_obi.obi08 < 0 THEN
                  CALL cl_err('','aim-223',0)
                  NEXT FIELD obi08
               END IF
               LET g_obi.obi10 = g_obi.obi06*g_obi.obi07*g_obi.obi08
            END IF
         END IF
 
      AFTER FIELD obi11
         IF NOT cl_null(g_obi.obi11) THEN
            IF g_obi_t.obi11 IS NULL 
               OR g_obi.obi11 != g_obi_t.obi11 THEN
               IF g_obi.obi11 < 0 THEN
                  CALL cl_err('','aim-223',0)
                  NEXT FIELD obi11
               END IF
            END IF
         END IF
 
      AFTER FIELD obi12
         IF NOT cl_null(g_obi.obi12) THEN
            IF g_obi_t.obi12 IS NULL
               OR g_obi.obi12 != g_obi_t.obi12 THEN
               CALL i009_obi12()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_obi.obi12,g_errno,0)
                  LET g_obi.obi12 = g_obi_o.obi12
                  DISPLAY BY NAME g_obi.obi12
                  NEXT FIELD obi12
               END IF 
            END IF
            CALL cl_set_comp_entry("obi14",TRUE)
         ELSE
            CALL cl_set_comp_entry("obi14",FALSE)
         END IF
 
      AFTER FIELD obi14
         IF NOT cl_null(g_obi.obi14) THEN
            IF g_obi_t.obi14 IS NULL
               OR g_obi.obi14 != g_obi_t.obi14 THEN
               CALL i009_obi14()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_obi.obi14,g_errno,0)
                  LET g_obi.obi14 = g_obi_o.obi14
                  DISPLAY BY NAME g_obi.obi14
                  NEXT FIELD obi14
               END IF
             SELECT COUNT(*) INTO l_n FROM agb_file,ocq_file
              WHERE agb01 = g_obi.obi14
                AND ocq03 = agb03
                AND ocq01 = g_obi.obi12
             IF l_n = 0 THEN
                CALL cl_err('','axm-944',0)
                NEXT FIELD obi14
             END IF
            END IF
         END IF
         IF NOT cl_null(g_obi.obi12) THEN
            IF cl_null(g_obi.obi14) THEN
               CALL cl_err('','ask-043',0)
               NEXT FIELD obi14
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
            WHEN INFIELD(obi01) #包裝編號
                 LET g_t1=s_get_doc_no(g_obi.obi01)     
                 CALL q_oay(FALSE,FALSE,g_t1,'61','axm') RETURNING g_t1     #FUN-A70130
                 LET g_obi.obi01 = g_t1                 
                 DISPLAY BY NAME g_obi.obi01
                 CALL i009_obi01('d')
                 NEXT FIELD obi01
 
             WHEN INFIELD(obi12) #未維屬性組
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_ocq"
                 LET g_qryparam.default1 = g_obi.obi12
                 CALL cl_create_qry() RETURNING g_obi.obi12
                 DISPLAY BY NAME g_obi.obi12
                 NEXT FIELD obi12
 
             WHEN INFIELD(obi14) #屬性群組
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aga1"
                 LET g_qryparam.default1 = g_obi.obi14
                 LET g_qryparam.arg1= g_obi.obi12
                 CALL cl_create_qry() RETURNING g_obi.obi14
                 DISPLAY BY NAME g_obi.obi14
                 NEXT FIELD obi14
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
 
FUNCTION i009_obi01(p_cmd)  #單據編號
   DEFINE l_smydesc LIKE smy_file.smydesc,
          l_smyacti LIKE smy_file.smyacti,
          l_t1      LIKE oay_file.oayslip, 
          p_cmd     LIKE type_file.chr1    
 
   LET g_errno = ' '
   LET l_t1 = s_get_doc_no(g_obi.obi01)        
   IF g_obi.obi01 IS NULL THEN
      LET g_errno = 'E'
   ELSE
      SELECT smydesc,smyacti
        INTO l_smydesc,l_smyacti
        FROM smy_file WHERE smyslip = l_t1
      IF SQLCA.sqlcode THEN
         LET g_errno = 'E'
      ELSE
         IF l_smyacti matches'[nN]' THEN
            LET g_errno = 'E'
         END IF
      END IF
   END IF
END FUNCTION
 
FUNCTION i009_obi12()                                                      
  DEFINE l_ocq02   LIKE ocq_file.ocq02,
         l_ocqacti LIKE ocq_file.ocqacti
 
  LET g_errno=''
  
  SELECT DISTINCT ocq02,ocqacti INTO l_ocq02,l_ocqacti 
    FROM ocq_file
   WHERE ocq01=g_obi.obi12
 
  CASE WHEN SQLCA.sqlcode=100 LET g_errno='aim-910'
                              LET l_ocq02=NULL
       WHEN l_ocqacti='N'     LET g_errno='9028'
       OTHERWISE              LET g_errno=SQLCA.sqlcode USING '-------'
  END CASE 
 
  DISPLAY l_ocq02 TO FORMONLY.obi12_ocq02
 
END FUNCTION 
 
FUNCTION i009_obi14()                                                      
  DEFINE l_aga02   LIKE aga_file.aga02,
         l_agaacti LIKE aga_file.agaacti
 
  LET g_errno=''
  
  SELECT DISTINCT aga02,agaacti INTO l_aga02,l_agaacti 
    FROM aga_file
   WHERE aga01=g_obi.obi14
 
  CASE WHEN SQLCA.sqlcode=100 LET g_errno='aim-910'
                              LET l_aga02=NULL
       WHEN l_agaacti='N'     LET g_errno='9028'
       OTHERWISE              LET g_errno=SQLCA.sqlcode USING '-------'
  END CASE 
 
  DISPLAY l_aga02 TO FORMONLY.obi14_aga02
 
END FUNCTION 
 
FUNCTION i009_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_obj.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL i009_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_obi.* TO NULL
      RETURN
   END IF
 
   OPEN i009_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_obi.* TO NULL
   ELSE
      OPEN i009_count
      FETCH i009_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL i009_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION i009_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式 
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i009_cs INTO g_obi.obi01
      WHEN 'P' FETCH PREVIOUS i009_cs INTO g_obi.obi01
      WHEN 'F' FETCH FIRST    i009_cs INTO g_obi.obi01
      WHEN 'L' FETCH LAST     i009_cs INTO g_obi.obi01
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
            FETCH ABSOLUTE g_jump i009_cs INTO g_obi.obi01
            LET g_no_ask = FALSE     
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_obi.obi01,SQLCA.sqlcode,0)
      INITIALIZE g_obi.* TO NULL               
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
   END IF
 
   SELECT * INTO g_obi.* FROM obi_file WHERE obi01 = g_obi.obi01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","obi_file","","",SQLCA.sqlcode,"","",1)  
      INITIALIZE g_obi.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_obi.obiuser      
   LET g_data_group = g_obi.obigrup      
 
   CALL i009_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i009_show()
 
   LET g_obi_t.* = g_obi.*                #保存單頭舊值
   LET g_obi_o.* = g_obi.*                #保存單頭舊值
   DISPLAY BY NAME g_obi.obi01,g_obi.obi02,g_obi.obi03,g_obi.obi04, g_obi.obioriu,g_obi.obiorig,
                   g_obi.obi05,g_obi.obi06,g_obi.obi07,g_obi.obi08,
                   g_obi.obi09,g_obi.obi10,g_obi.obi11,g_obi.obi12,
                   g_obi.obi13,g_obi.obi14,
                   g_obi.obiuser,g_obi.obigrup,g_obi.obimodu,
                   g_obi.obidate,g_obi.obiacti
                   
 
   CALL i009_obi01('d')
   CALL i009_obi12()
   CALL i009_obi14()
   CALL i009_show_field()
   CALL i009_b_fill(g_wc2)                 #單身
   CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION i009_show_field()
  DEFINE l_hide       LIKE type_file.chr1000
  DEFINE l_show       LIKE type_file.chr1000
  DEFINE ls_show      LIKE type_file.chr1000
 
  IF cl_null(g_obi.obi12) THEN
     LET l_hide = "att00,att01,att02,att02_c,att03,att03_c,att04,att05,att06,att07,att08,att09,att10,att11,att12,att13"
     LET l_show = "obj02,obj03,obj04,obj06"
 
     CALL cl_set_comp_visible(l_hide,FALSE)
     CALL cl_set_comp_visible(l_show,TRUE)
  ELSE
     LET l_hide = "obj02,obj03,obj04,obj06"
     LET l_show = "att01"
     CALL cl_set_comp_visible(l_hide,FALSE)  #末維屬性組有值，需要隱藏這幾個欄位
     CALL cl_set_comp_visible(l_show,TRUE)
     CALL i009_refresh_detail() RETURNING ls_show   #attxx的隱藏和顯示由此函數控制
  END IF
 
END FUNCTION
 
FUNCTION i009_refresh_detail()
  DEFINE l_compare          LIKE oay_file.oay22    
  DEFINE li_col_count       LIKE type_file.num5
  DEFINE li_i, li_j         LIKE type_file.num5
  DEFINE lc_agb03           LIKE agb_file.agb03
  DEFINE lr_agd             RECORD LIKE agd_file.*
  DEFINE lc_index           LIKE type_file.chr1000
  DEFINE l_index            LIKE type_file.chr1000
  DEFINE ls_combo_vals      LIKE type_file.chr1000
  DEFINE ls_combo_txts      LIKE type_file.chr1000
  DEFINE #ls_sql             LIKE type_file.chr1000
         ls_sql        STRING       #NO.FUN-910082  
  DEFINE #l_sql              LIKE type_file.chr1000
         l_sql        STRING       #NO.FUN-910082  
  DEFINE ls_show,ls_hide    LIKE type_file.chr1000
  DEFINE l_gae04            LIKE gae_file.gae04
  DEFINE l_n                LIKE type_file.num5
  DEFINE l_i2               LIKE type_file.num5
  DEFINE l_j,l_i            LIKE type_file.num5
  DEFINE l_bz               LIKE type_file.chr1
 
  LET ls_hide = "obj02"
  LET ls_show = "att00"
 
  LET l_bz = '0'
 
  IF NOT cl_null(g_obi.obi14) THEN
     CALL cl_chg_comp_att("att00","NOT NULL|REQUIRED|SCROLL","1|1|1")
     #到這里時g_group中存放的已經是應該顯示的組別了，該變量是一個全局變量
     #在單身INPUT或開窗時都會用到，因為refresh函數被執行的時機較早，所以能保証在需要的時候有值
     SELECT COUNT(*) INTO li_col_count FROM agb_file WHERE agb01 = g_obi.obi14
     #顯現該有的欄位,置換欄位格式
     #因為這個過程可能會被執行多次，作為一個公共變量，每次執行之前必須要初始化
     CALL lr_agc.clear()
     FOR li_i = 1 TO li_col_count
         SELECT agb03 INTO lc_agb03 FROM agb_file
           WHERE agb01 = g_obi.obi14 AND agb02 = li_i
 
         LET lc_agb03 = lc_agb03 CLIPPED
         SELECT * INTO lr_agc[li_i].* FROM agc_file
           WHERE agc01 = lc_agb03
 
#add by chenyu  --08/05/22  #增加一個判斷，看該屬性是否分拆成末維屬性
         SELECT COUNT(*) INTO l_n FROM ocq_file 
          WHERE ocq01 = g_obi.obi12
            AND ocq03 = lr_agc[li_i].agc01 
         IF l_n > 0 THEN
            LET l_bz = '1'
            CONTINUE FOR
         END IF
         IF l_bz = '1' THEN 
            LET lc_index = li_i USING '&&'
         ELSE
            LET lc_index = li_i+1 USING '&&'
         END IF
 
         CASE lr_agc[li_i].agc04
           WHEN '1'
             LET ls_show = ls_show || ",att" || lc_index
             LET ls_hide = ls_hide || ",att" || lc_index || "_c"
             CALL cl_set_comp_att_text("att" || lc_index,lr_agc[li_i].agc02)
             CALL cl_chg_comp_att("att" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")
 
           WHEN '2'
             LET ls_show = ls_show || ",att" || lc_index || "_c"
             LET ls_hide = ls_hide || ",att" || lc_index 
             CALL cl_set_comp_att_text("att" || lc_index || "_c",lr_agc[li_i].agc02)
             LET ls_sql = "SELECT * FROM agd_file WHERE agd01 = '",lr_agc[li_i].agc01,"'"
             DECLARE agd_curs CURSOR FROM ls_sql
             LET ls_combo_vals = ""
             LET ls_combo_txts = ""
             FOREACH agd_curs INTO lr_agd.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF ls_combo_vals IS NULL THEN
                   LET ls_combo_vals = lr_agd.agd02 CLIPPED
                ELSE
                   LET ls_combo_vals = ls_combo_vals,",",lr_agd.agd02 CLIPPED
                END IF
                IF ls_combo_txts IS NULL THEN
                   LET ls_combo_txts = lr_agd.agd02 CLIPPED,":",lr_agd.agd03 CLIPPED
                ELSE
                   LET ls_combo_txts = ls_combo_txts,",",lr_agd.agd02 CLIPPED,":",lr_agd.agd03 CLIPPED
                END IF
             END FOREACH
             CALL cl_set_combo_items("formonly.att" || lc_index || "_c",ls_combo_vals,ls_combo_txts)
             CALL cl_chg_comp_att("att" || lc_index || "_c","NOT NULL|REQUIRED|SCROLL","1|1|1")
 
          WHEN '3'
             LET ls_show = ls_show || ",att" || lc_index
             LET ls_hide = ls_hide || ",att" || lc_index || "_c"
             CALL cl_set_comp_att_text("att" || lc_index,lr_agc[li_i].agc02)
             CALL cl_chg_comp_att("att" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")
       END CASE
     END FOR       
  ELSE
    #否則什么也不做(不顯示任何屬性列)
    #為了提高效率，把需要顯示和隱藏的欄位都放到各自的變量里，然后在結尾的地方一次性顯示或隱藏
    LET li_i = 1
  END IF
  
  #下面開始隱藏其他明細屬性欄位(從li_i開始)
  FOR li_j = li_i TO 2
      LET lc_index = li_j+1 USING '&&'
      #注意att0x和att0x_c都要隱藏，別忘了_c的
      LET ls_hide = ls_hide || ",att" || lc_index || ",att" || lc_index || "_c"
  END FOR
 
  SELECT COUNT(*) INTO l_n FROM ocq_file
   WHERE ocq01 = g_obi.obi12
  IF l_n > 0 THEN
     CALL g_ocq.clear()
 
     LET l_sql = "SELECT * FROM ocq_file WHERE ocq01 = '",g_obi.obi12,"'"
     DECLARE ocq_curs CURSOR FROM l_sql
     LET l_i2 = 1
     FOREACH ocq_curs INTO g_ocq[l_i2].*
      
         LET l_index = l_i2 + 3 USING '&&'
 
         LET ls_show = ls_show || ",att" || l_index
         CALL cl_set_comp_att_text("att" || l_index,g_ocq[l_i2].ocq05)
         CALL cl_chg_comp_att("att" || l_index,"NOENTRY|NOT NULL","0|0")
         LET l_i2 = l_i2 + 1
     END FOREACH
  ELSE
     LET l_i2 = 1
  END IF
 
  #隱藏其它末維屬性，從l_n+3開始 
  FOR l_j = l_i2 TO 10
      LET l_index = l_j+3 USING '&&'
      LET ls_hide = ls_hide || ",att" || l_index 
  END FOR
 
  #這樣只用調兩次公共函數就可以解決問題了，效率應該會高一些
  CALL cl_set_comp_visible(ls_show, TRUE)
  CALL cl_set_comp_visible(ls_hide, FALSE)
  RETURN ls_show
END FUNCTION
 
         
#用于att02~att03這兩個輸入型屬性欄位的AFTER FIELD事件的判斷函數
#傳入參數:p_value 要比較的欄位內容,p_index當前欄位的索引號(從2~3表示att02~att03)
#         p_row是當前行索引,傳入INPUT ARRAY中使用的l_ac即可
#而AFTER FIELD的時候檢測到這個返回值則會做NEXT FIELD
FUNCTION i009_check_att0x(p_value,p_index,p_row,p_cmd)
DEFINE
  p_value      LIKE imx_file.imx01,
  p_index      LIKE type_file.num5,
  p_row        LIKE type_file.num5,
  p_cmd        LIKE type_file.chr1,
  li_min_num   LIKE agc_file.agc05,
  li_max_num   LIKE agc_file.agc06,
  l_index      LIKE type_file.chr1000,
  l_check_res  LIKE type_file.num5
 
  #這個欄位一旦進入了就不能忽略，因為要保証在輸入其他欄位之前必須要生成obj02料件編號
  IF cl_null(p_value) THEN 
     RETURN FALSE
  END IF
 
  #這里使用到了一個用于存放當前屬性組包含的所有屬性信息的全局數組lr_agc
  #該數組會由i009_refresh_detail()函數在較早的時候填充
  
  #判斷長度與定義的使用位數是否相等
  IF LENGTH(p_value CLIPPED) <> lr_agc[p_index].agc03 THEN
     CALL cl_err_msg("","aim-911",lr_agc[p_index].agc03,1)
     RETURN FALSE
  END IF
  #比較大小是否在合理范圍之內
  LET li_min_num = lr_agc[p_index].agc05
  LET li_max_num = lr_agc[p_index].agc06
  IF (lr_agc[p_index].agc05 IS NOT NULL) AND
     (p_value < li_min_num) THEN
     CALL cl_err_msg("","lib-232",lr_agc[p_index].agc05 || "|" || lr_agc[p_index].agc06,1)
     RETURN FALSE
  END IF
  IF (lr_agc[p_index].agc06 IS NOT NULL) AND
     (p_value > li_max_num) THEN
     CALL cl_err_msg("","lib-232",lr_agc[p_index].agc05 || "|" || lr_agc[p_index].agc06,1)
     RETURN FALSE
  END IF
 
  RETURN TRUE
END FUNCTION
 
FUNCTION i009_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_obi.obi01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN i009_cl USING g_obi.obi01
   IF STATUS THEN
      CALL cl_err("OPEN i009_cl:", STATUS, 1)
      CLOSE i009_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i009_cl INTO g_obi.*                         # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_obi.obi01,SQLCA.sqlcode,0)        #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL i009_show()
 
   IF cl_exp(0,0,g_obi.obiacti) THEN                  #確認一下
      LET g_chr=g_obi.obiacti
      IF g_obi.obiacti='Y' THEN
         LET g_obi.obiacti='N'
      ELSE
         LET g_obi.obiacti='Y'
      END IF
 
      UPDATE obi_file SET obiacti=g_obi.obiacti,
                          obimodu=g_user,
                          obidate=g_today
       WHERE obi01=g_obi.obi01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","obi_file",g_obi.obi01,"",SQLCA.sqlcode,"","",1)  
         LET g_obi.obiacti=g_chr
      END IF
   END IF
 
   CLOSE i009_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_obi.obi01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT obiacti,obimodu,obidate
     INTO g_obi.obiacti,g_obi.obimodu,g_obi.obidate FROM obi_file
    WHERE obi01=g_obi.obi01
   DISPLAY BY NAME g_obi.obiacti,g_obi.obimodu,g_obi.obidate
 
END FUNCTION
 
FUNCTION i009_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_obi.obi01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_obi.* FROM obi_file
    WHERE obi01=g_obi.obi01
   IF g_obi.obiacti='N' THEN                                                                                                        
      CALL cl_err('','abm-950',0)                                                                                                   
      RETURN                                                                                                                        
   END IF                                                                                                                           
 
   BEGIN WORK
 
   OPEN i009_cl USING g_obi.obi01
   IF STATUS THEN
      CALL cl_err("OPEN i009_cl:", STATUS, 1)
      CLOSE i009_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i009_cl INTO g_obi.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_obi.obi01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i009_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "obi01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_obi.obi01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM obi_file WHERE obi01 = g_obi.obi01
      DELETE FROM obj_file WHERE obj01 = g_obi.obi01
      CLEAR FORM
      CALL g_obj.clear()
      OPEN i009_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE i009_cs
         CLOSE i009_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH i009_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i009_cs
         CLOSE i009_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i009_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i009_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE      
         CALL i009_fetch('/')
      END IF
   END IF
 
   CLOSE i009_cl
   COMMIT WORK
   CALL cl_flow_notify(g_obi.obi01,'D')
END FUNCTION
 
#單身
FUNCTION i009_b()
DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  
       l_n             LIKE type_file.num5,                #檢查重複用  
       l_cnt           LIKE type_file.num5,                #檢查重複用  
       l_lock_sw       LIKE type_file.chr1,                #單身鎖住否  
       p_cmd           LIKE type_file.chr1,                #處理狀態  
       l_allow_insert  LIKE type_file.num5,                #可新增否  
       l_allow_delete  LIKE type_file.num5,                #可刪除否
       l_obj01         LIKE obj_file.obj01,
       l_obj05         LIKE obj_file.obj05,
       l_ima31         LIKE ima_file.ima31
DEFINE l_check_res     LIKE type_file.num5
DEFINE #l_sql           LIKE type_file.chr1000,
       l_sql           STRING,       #NO.FUN-910082  
       l_i2,l_j2       LIKE type_file.num5,
       l_ps            LIKE sma_file.sma46,
       l_obj02         LIKE obj_file.obj02,
       l_obj03         LIKE obj_file.obj03
DEFINE l_str_tok       base.stringTokenizer,
       l_tmp           LIKE type_file.chr1000,
       ls_sql          STRING ,      #NO.FUN-910082  
       lc_agb03        LIKE agb_file.agb03,
       l_param_list    LIKE type_file.chr1000
DEFINE #l_sqlb          LIKE type_file.chr1000
       l_sqlb        STRING       #NO.FUN-910082  
DEFINE 
       l_wc           STRING       #NO.FUN-910082 
DEFINE l_case         STRING    #FUN-910088 add
 
 
    LET g_action_choice = ""
    LET g_success = 'Y'
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_obi.obi01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_obi.* FROM obi_file
     WHERE obi01=g_obi.obi01
 
    IF g_obi.obiacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_obi.obi01,'mfg1000',0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT '','','','','','','','','','','','','','','','',", 
                       "       obj02,obj03,obj04,obj05,obj06,obj07,obj08,",
                       "       obj09,obj10,obj11,obj12,obj13,obj14", 
                       "  FROM obj_file",
                       "  WHERE obj01=? AND obj02=? ",
                       " FOR UPDATE"  
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i009_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_obj WITHOUT DEFAULTS FROM s_obj.*
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
 
           OPEN i009_cl USING g_obi.obi01
           IF STATUS THEN
              CALL cl_err("OPEN i009_cl:", STATUS, 1)
              CLOSE i009_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i009_cl INTO g_obi.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_obi.obi01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE i009_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_obj_t.* = g_obj[l_ac].*  #BACKUP
              LET g_obj_o.* = g_obj[l_ac].*  #BACKUP
              LET g_obj07_t = g_obj[l_ac].obj07      #FUN-910088 add
              IF cl_null(g_obi.obi12) THEN
                 OPEN i009_bcl USING g_obi.obi01,g_obj_t.obj02
                 IF STATUS THEN
                    CALL cl_err("OPEN i009_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                 ELSE
                    FETCH i009_bcl INTO g_obj[l_ac].*
                    IF SQLCA.sqlcode THEN
                       CALL cl_err(g_obj_t.obj02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                    END IF
                 END IF
                 CALL cl_show_fld_cont()
              ELSE
                 CALL i009_wc() RETURNING l_wc 
                 LET l_sqlb = "SELECT DISTINCT att00,att01,att02,att02_c,att03,",
                              "                att03_c,att04,att05,att06,att07,",
                              "                att08,att09,att10,att11,att12,att13,",
                              "                '','','',obj05,'',obj07,",
                              "                obj08,obj09,obj10,obj11,obj12,obj13,obj14",
                              "  FROM i009_temp",
                              " WHERE ",l_wc CLIPPED
                 DECLARE temp_bcl CURSOR FROM l_sqlb
                 OPEN temp_bcl 
                 IF STATUS THEN
                    CALL cl_err("OPEN temp_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                 ELSE
                    FETCH temp_bcl INTO g_obj[l_ac].*
                    IF SQLCA.sqlcode THEN
                       CALL cl_err(g_obj_t.obj02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                    END IF
                 END IF
                 CALL cl_show_fld_cont()
                 CALL i009_set_no_entry_b(p_cmd)
              END IF
           END IF
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_obj[l_ac].* TO NULL
           LET g_obj[l_ac].obj08 =  0            #Body default
           LET g_obj[l_ac].obj09 =  0            #Body default
           LET g_obj[l_ac].obj10 =  0            #Body default
           LET g_obj[l_ac].obj12 =  0            #Body default
           LET g_obj_t.* = g_obj[l_ac].*         #新輸入資料
           LET g_obj_o.* = g_obj[l_ac].*         #新輸入資料
           LET g_obj07_t = NULL                  #FUN-910088 add
           CALL cl_show_fld_cont()
           CALL i009_set_entry_b(p_cmd)
           IF NOT cl_null(g_obi.obi12) THEN
              NEXT FIELD att00
           ELSE
              NEXT FIELD obj02
           END IF
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF NOT cl_null(g_obi.obi12) THEN
              CALL i009_b_ins() RETURNING g_success
           ELSE
              INSERT INTO obj_file(obj01,obj02,obj03,obj04,obj05,obj06,obj07,
                                   obj08,obj09,obj10,obj11,obj12,obj13,obj14)  
              VALUES(g_obi.obi01,g_obj[l_ac].obj02,g_obj[l_ac].obj03,
                     g_obj[l_ac].obj04,g_obj[l_ac].obj05,g_obj[l_ac].obj06,
                     g_obj[l_ac].obj07,g_obj[l_ac].obj08,g_obj[l_ac].obj09,
                     g_obj[l_ac].obj10,g_obj[l_ac].obj11,g_obj[l_ac].obj12,
                     g_obj[l_ac].obj13,g_obj[l_ac].obj14)  
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("ins","obj_file",g_obi.obi01,g_obj[l_ac].obj02,SQLCA.sqlcode,"","",1)  
                 CANCEL INSERT
                 LET g_success = 'N'
              END IF
           END IF
           IF g_success = 'Y' THEN
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
              CALL i009_b_fill(" 1=1")
           END IF
 
        AFTER FIELD obj02
          IF NOT cl_null(g_obj[l_ac].obj02) THEN
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_obj[l_ac].obj02,"") THEN
               CALL cl_err('',g_errno,1)
               LET g_obj[l_ac].obj02= g_obj_t.obj02
               NEXT FIELD obj02
            END IF
#FUN-AA0059 ---------------------end-------------------------------
            IF g_obj_t.obj02 IS NULL OR g_obj_t.obj02 <> g_obj[l_ac].obj02 THEN
               SELECT COUNT(*) INTO l_n FROM obj_file
                WHERE obj01 = g_obi.obi01
                  AND obj02 = g_obj[l_ac].obj02
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_obj[l_ac].obj02 = g_obj_t.obj02
                  NEXT FIELD obj02
               END IF
               SELECT COUNT(*) INTO l_n FROM ima_file
                WHERE ima01 = g_obj[l_ac].obj02
                  AND ima151 != 'Y'
                  AND imaacti = 'Y'
               IF l_n = 0 THEN
                  CALL cl_err('','ask-039',0)
                  LET g_obj[l_ac].obj02 = g_obj_t.obj02
                  NEXT FIELD obj02
                END IF
                SELECT ima02,ima31,ima18 INTO g_obj[l_ac].obj03,g_obj[l_ac].obj07,g_obj[l_ac].obj13
                  FROM ima_file
                 WHERE ima01 = g_obj[l_ac].obj02
                 #FUN-910088---add---start
                 LET l_case = ''
                 IF NOT i009_obj05_check() THEN
                    LET l_case = "obj05"
                 END IF
                 
                 IF NOT i009_obj06_check() THEN
                    LET l_case = "obj06"
                 END IF
                 LET g_obj07_t = g_obj[l_ac].obj07
                 CASE l_case
                    WHEN "obj05" 
                       NEXT FIELD obj05
                    WHEN "obj06"
                       NEXT FIELD obj06
                    OTHERWISE EXIT CASE
                 END CASE                 
                 #FUN-910088---add---end 
             END IF
          END IF
 
        AFTER FIELD att00
           IF NOT cl_null(g_obj[l_ac].att00) THEN
#FUN-AB0025 ---------------------start----------------------------
              IF NOT s_chk_item_no(g_obj[l_ac].att00,"") THEN
                 CALL cl_err('',g_errno,1)
                 LET g_obj[l_ac].att00= g_obj_t.att00
                 NEXT FIELD att00
              END IF
#FUN-AB0025 ---------------------end-------------------------------
              IF g_obj_t.att00 IS NULL OR g_obj_t.att00 <> g_obj[l_ac].att00 THEN
                 SELECT COUNT(*) INTO l_n FROM ima_file
                  WHERE ima151 = 'Y'
                    AND ima01 = g_obj[l_ac].att00
                    AND imaacti = 'Y'
                    AND imaag = g_obi.obi14
                 IF l_n = 0 THEN
                    CALL cl_err('','ask-044',0)
                    LET g_obj[l_ac].att00 = g_obj_t.att00
                    NEXT FIELD att00
                 END IF
                 CALL i009_check() RETURNING g_success
                 IF g_success = 'N' THEN
                    CALL cl_err('','atm-310',0)
                    NEXT FIELD att00
                 END IF
                 SELECT ima02,ima18,ima31 INTO g_obj[l_ac].att01,g_obj[l_ac].obj13,g_obj[l_ac].obj07
                   FROM ima_file
                  WHERE ima01 = g_obj[l_ac].att00
                  #FUN-910088---add---start
                 IF NOT i009_obj05_check() THEN
                    LET l_case = "obj05"
                 END IF
                 
                 IF NOT i009_obj06_check() THEN
                    LET l_case = "obj06"
                 END IF
                 LET g_obj07_t = g_obj[l_ac].obj07
                 CASE l_case
                    WHEN "obj05" 
                       NEXT FIELD obj05
                    WHEN "obj06"
                       NEXT FIELD obj06
                    OTHERWISE EXIT CASE
                 END CASE                 
                 #FUN-910088---add---end
              END IF
           END IF
              
 
        #下面是兩個輸入型下拉框屬性欄位的判斷語句
        AFTER FIELD att02_c
            IF NOT cl_null(g_obj[l_ac].att02_c) THEN
               IF g_obj_t.att02_c IS NULL OR g_obj_t.att02_c <> g_obj[l_ac].att02_c THEN
                  LET arr_detail[l_ac].imx[2] = g_obj[l_ac].att02_c
                  CALL i009_check() RETURNING g_success
                  IF g_success = 'N' THEN
                     CALL cl_err('','atm-310',0)
                     NEXT FIELD att02_c
                  END IF
               END IF
            END IF
        AFTER FIELD att03_c
            IF NOT cl_null(g_obj[l_ac].att03_c) THEN
               IF g_obj_t.att03_c IS NULL OR g_obj_t.att03_c <> g_obj[l_ac].att03_c THEN
                  LET arr_detail[l_ac].imx[3] = g_obj[l_ac].att03_c
                  CALL i009_check() RETURNING g_success
                  IF g_success = 'N' THEN
                     CALL cl_err('','atm-310',0)
                     NEXT FIELD att03_c
                  END IF
               END IF
            END IF
 
        AFTER FIELD att02
            CALL i009_check_att0x(g_obj[l_ac].att02,2,l_ac,p_cmd) RETURNING l_check_res
            IF NOT l_check_res THEN 
               NEXT FIELD att02 
            ELSE
               LET arr_detail[l_ac].imx[2] = g_obj[l_ac].att02
            END IF              
            IF NOT cl_null(g_obj[l_ac].att02) THEN
               IF g_obj_t.att02 IS NULL OR g_obj_t.att02 <> g_obj[l_ac].att02 THEN
                  CALL i009_check() RETURNING g_success
                  IF g_success = 'N' THEN
                     CALL cl_err('','atm-310',0)
                     NEXT FIELD att02
                  END IF
               END IF
            END IF
 
        AFTER FIELD att03
            CALL i009_check_att0x(g_obj[l_ac].att03,3,l_ac,p_cmd) RETURNING l_check_res
            IF NOT l_check_res THEN 
               NEXT FIELD att03 
            ELSE
               LET arr_detail[l_ac].imx[3] = g_obj[l_ac].att03
            END IF
            IF NOT cl_null(g_obj[l_ac].att03) THEN
               IF g_obj_t.att03 IS NULL OR g_obj_t.att03 <> g_obj[l_ac].att03 THEN
                  CALL i009_check() RETURNING g_success
                  IF g_success = 'N' THEN
                     CALL cl_err('','atm-310',0)
                     NEXT FIELD att03
                  END IF
               END IF
            END IF
 
        AFTER FIELD att04
            IF NOT cl_null(g_obj[l_ac].att04) THEN
              IF g_obj[l_ac].att04 <0 THEN
                 CALL cl_err(g_obj[l_ac].att04,'axm-948',0)
                 NEXT FIELD att04
              END IF
              LET arr_detail[l_ac].imx[4] = g_obj[l_ac].att04
            END IF
        AFTER FIELD att05
            IF NOT cl_null(g_obj[l_ac].att05) THEN
              IF g_obj[l_ac].att05 <0 THEN
                CALL cl_err(g_obj[l_ac].att05,'axm-948',0)
                NEXT FIELD att05
              END IF
              LET arr_detail[l_ac].imx[5] = g_obj[l_ac].att05
            END IF
        AFTER FIELD att06
            IF NOT cl_null(g_obj[l_ac].att06) THEN
              IF g_obj[l_ac].att06 <0 THEN
                CALL cl_err(g_obj[l_ac].att06,'axm-948',0)
                NEXT FIELD att06
              END IF
              LET arr_detail[l_ac].imx[6] = g_obj[l_ac].att06
            END IF
        AFTER FIELD att07
            IF NOT cl_null(g_obj[l_ac].att07) THEN
              IF g_obj[l_ac].att07 <0 THEN
                CALL cl_err(g_obj[l_ac].att07,'axm-948',0)
                NEXT FIELD att07
              END IF
              LET arr_detail[l_ac].imx[7] = g_obj[l_ac].att07
            END IF
        AFTER FIELD att08
            IF NOT cl_null(g_obj[l_ac].att08) THEN
              IF g_obj[l_ac].att08 <0 THEN
                CALL cl_err(g_obj[l_ac].att08,'axm-948',0)
                NEXT FIELD att08
              END IF
              LET arr_detail[l_ac].imx[8] = g_obj[l_ac].att08
            END IF
        AFTER FIELD att09
            IF NOT cl_null(g_obj[l_ac].att09) THEN
              IF g_obj[l_ac].att09 <0 THEN
                CALL cl_err(g_obj[l_ac].att09,'axm-948',0)
                NEXT FIELD att09
              END IF
              LET arr_detail[l_ac].imx[9] = g_obj[l_ac].att09
            END IF
        AFTER FIELD att10
            IF NOT cl_null(g_obj[l_ac].att10) THEN
              IF g_obj[l_ac].att10 <0 THEN
                CALL cl_err(g_obj[l_ac].att10,'axm-948',0)
                NEXT FIELD att10
              END IF
              LET arr_detail[l_ac].imx[10] = g_obj[l_ac].att10
            END IF
        AFTER FIELD att11
            IF NOT cl_null(g_obj[l_ac].att11) THEN
              IF g_obj[l_ac].att11 <0 THEN
                CALL cl_err(g_obj[l_ac].att11,'axm-948',0)
                NEXT FIELD att11
              END IF
              LET arr_detail[l_ac].imx[11] = g_obj[l_ac].att11
            END IF
        AFTER FIELD att12
            IF NOT cl_null(g_obj[l_ac].att12) THEN
              IF g_obj[l_ac].att12 <0 THEN
                CALL cl_err(g_obj[l_ac].att12,'axm-948',0)
                NEXT FIELD att12
              END IF
              LET arr_detail[l_ac].imx[12] = g_obj[l_ac].att12
            END IF
        AFTER FIELD att13
            IF NOT cl_null(g_obj[l_ac].att13) THEN
              IF g_obj[l_ac].att13 <0 THEN
                CALL cl_err(g_obj[l_ac].att13,'axm-948',0)
                NEXT FIELD att13
              END IF
              LET arr_detail[l_ac].imx[13] = g_obj[l_ac].att13
            END IF
           
        AFTER FIELD obj04 
           IF NOT cl_null(g_obj[l_ac].obj04) THEN
              IF g_obj[l_ac].obj04 != g_obj_t.obj04
                 OR g_obj_t.obj04 IS NULL THEN
                 IF g_obj[l_ac].obj04<0 THEN
                    CALL cl_err('','aim-223',0)
                    NEXT FIELD obj04
                 END IF     
                 LET g_obj[l_ac].obj06=g_obj[l_ac].obj04*g_obj[l_ac].obj05
                 LET g_obj[l_ac].obj06 = s_digqty(g_obj[l_ac].obj06,g_obj[l_ac].obj07)     #FUN-910088 add
              END IF
           END IF
        
        AFTER FIELD obj05 
           IF NOT i009_obj05_check() THEN NEXT FIELD obj05 END IF        #FUN-910088 add
           #FUN-910088---mark---start
           #IF NOT cl_null(g_obj[l_ac].obj05) THEN
           #  IF g_obj[l_ac].obj05 != g_obj_t.obj05
           #     OR g_obj_t.obj05 IS NULL THEN
           #     IF g_obj[l_ac].obj05<=0 THEN
           #        CALL cl_err('','aim-223',0)
           #        NEXT FIELD obj05
           #     END IF 
           #     LET g_obj[l_ac].obj06=g_obj[l_ac].obj04*g_obj[l_ac].obj05
           #  END IF
           #END IF
           #FUN-910088---mark---end
        AFTER FIELD obj06 
           IF NOT i009_obj06_check() THEN NEXT FIELD obj06 END IF  #FUN-910088 add
           #FUN-910088---mark---start
           #IF NOT cl_null(g_obj[l_ac].obj06) THEN
           #  IF g_obj[l_ac].obj06 != g_obj_t.obj06
           #     OR g_obj_t.obj06 IS NULL THEN
           #     IF g_obj[l_ac].obj06<0 THEN
           #        CALL cl_err('','aim-223',0)
           #        NEXT FIELD obj06
           #     END IF 
           #  END IF
           #END IF
           #FUN-910088---mark---end
 
        AFTER FIELD obj08 
           IF NOT cl_null(g_obj[l_ac].obj08) THEN
              IF g_obj[l_ac].obj08 != g_obj_t.obj08
                 OR g_obj_t.obj08 IS NULL THEN
                 IF g_obj[l_ac].obj08<0 THEN
                    CALL cl_err('','aim-223',0)
                    NEXT FIELD obj08
                 ELSE
                    LET g_obj[l_ac].obj11=g_obj[l_ac].obj08*g_obj[l_ac].obj09*g_obj[l_ac].obj10      
                 END IF
              END IF
           END IF
       
        AFTER FIELD obj09
           IF NOT cl_null(g_obj[l_ac].obj09) THEN
              IF g_obj[l_ac].obj09 != g_obj_t.obj09
                 OR g_obj_t.obj09 IS NULL THEN
                 IF g_obj[l_ac].obj09<0 THEN
                    CALL cl_err('','aim-223',0)
                    NEXT FIELD obj09
                 ELSE
                    LET g_obj[l_ac].obj11=g_obj[l_ac].obj08*g_obj[l_ac].obj09*g_obj[l_ac].obj10      
                 END IF
              END IF
           END IF
 
        AFTER FIELD obj10 
           IF NOT cl_null(g_obj[l_ac].obj10) THEN
              IF g_obj[l_ac].obj10 != g_obj_t.obj10
                 OR g_obj_t.obj10 IS NULL THEN
                 IF g_obj[l_ac].obj10<0 THEN
                    CALL cl_err('','aim-223',0)
                    NEXT FIELD obj10
                 ELSE
                    LET g_obj[l_ac].obj11=g_obj[l_ac].obj08*g_obj[l_ac].obj09*g_obj[l_ac].obj10      
                 END IF
              END IF
           END IF
          
        AFTER FIELD obj11 
           IF NOT cl_null(g_obj[l_ac].obj11) THEN
              IF g_obj[l_ac].obj11 != g_obj_t.obj11
                 OR g_obj_t.obj11 IS NULL THEN
                 IF g_obj[l_ac].obj11<0 THEN
                    CALL cl_err('','aim-223',0)
                    NEXT FIELD obj11
                 END IF 
              END IF
           END IF
        
        BEFORE DELETE                      #是否取消單身
           DISPLAY "BEFORE DELETE"
           IF cl_null(g_obi.obi12) THEN
              IF g_obj_t.obj02 IS NOT NULL THEN
                 IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
                 END IF
                 IF l_lock_sw = "Y" THEN
                    CALL cl_err("", -263, 1)
                    CANCEL DELETE
                 END IF
                 DELETE FROM obj_file
                  WHERE obj01 = g_obi.obi01
                    AND obj02 = g_obj_t.obj02
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","obj_file",g_obi.obi01,g_obj_t.obj02,SQLCA.sqlcode,"","",1)  
                    ROLLBACK WORK
                    CANCEL DELETE
                 END IF
                 LET g_rec_b=g_rec_b-1
                 DISPLAY g_rec_b TO FORMONLY.cn2
              END IF
           ELSE
              IF g_obj_t.att00 IS NOT NULL THEN
                 IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
                 END IF
                 IF l_lock_sw = "Y" THEN
                    CALL cl_err("", -263, 1)
                    CANCEL DELETE
                 END IF
                 CALL i009_b_del() RETURNING g_success
                 IF g_success != 'Y' THEN
                    ROLLBACK WORK
                    CANCEL DELETE
                 END IF
                 LET g_rec_b=g_rec_b-1
                 DISPLAY g_rec_b TO FORMONLY.cn2
              END IF
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_obj[l_ac].* = g_obj_t.*
              CLOSE i009_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_obj[l_ac].obj02,-263,1)
              LET g_obj[l_ac].* = g_obj_t.*
           ELSE
              IF cl_null(g_obi.obi12) THEN
                 UPDATE obj_file SET obj02=g_obj[l_ac].obj02,
                                     obj03=g_obj[l_ac].obj03,
                                     obj04=g_obj[l_ac].obj04,
                                     obj05=g_obj[l_ac].obj05,
                                     obj06=g_obj[l_ac].obj06,
                                     obj07=g_obj[l_ac].obj07,
                                     obj08=g_obj[l_ac].obj08,
                                     obj09=g_obj[l_ac].obj09,
                                     obj10=g_obj[l_ac].obj10,
                                     obj11=g_obj[l_ac].obj11,
                                     obj12=g_obj[l_ac].obj12,
                                     obj13=g_obj[l_ac].obj13,
                                     obj14=g_obj[l_ac].obj14
                  WHERE obj01=g_obi.obi01
                    AND obj02=g_obj_t.obj02
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                    CALL cl_err3("upd","obj_file",g_obi.obi01,g_obj_t.obj02,SQLCA.sqlcode,"","",1)  
                    LET g_obj[l_ac].* = g_obj_t.*
                 ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                 END IF
              ELSE
                 CALL i009_b_del() RETURNING g_success
                 IF g_success != 'Y' THEN
                    ROLLBACK WORK
                    LET g_obj[l_ac].* = g_obj_t.*
                 END IF
 
                 LET arr_detail[l_ac].imx[4] = g_obj[l_ac].att04
                 LET arr_detail[l_ac].imx[5] = g_obj[l_ac].att05
                 LET arr_detail[l_ac].imx[6] = g_obj[l_ac].att06
                 LET arr_detail[l_ac].imx[7] = g_obj[l_ac].att07
                 LET arr_detail[l_ac].imx[8] = g_obj[l_ac].att08
                 LET arr_detail[l_ac].imx[9] = g_obj[l_ac].att09
                 LET arr_detail[l_ac].imx[10] = g_obj[l_ac].att10
                 LET arr_detail[l_ac].imx[11] = g_obj[l_ac].att11
                 LET arr_detail[l_ac].imx[12] = g_obj[l_ac].att12
                 LET arr_detail[l_ac].imx[13] = g_obj[l_ac].att13
 
                 CALL i009_b_ins() RETURNING g_success
                 IF g_success != 'Y' THEN
                    ROLLBACK WORK
                    LET g_obj[l_ac].* = g_obj_t.*
                 ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                    CALL i009_b_fill("1=1")
                 END IF
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
#          LET l_ac_t = l_ac         #FUN-D40030 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_obj[l_ac].* = g_obj_t.*
              #FUN-D40030---add---str---
              ELSE
                 CALL g_obj.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D40030---add---end---
              END IF
              CLOSE i009_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac        #FUN-D40030 add
           CLOSE i009_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(obj02) AND l_ac > 1 THEN
              LET g_obj[l_ac].* = g_obj[l_ac-1].*
              NEXT FIELD obj02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
             WHEN INFIELD(obj02) #廠品編號
#FUN-AA0059---------mod------------str-----------------
#              CALL cl_init_qry_var()
#              LET g_qryparam.form ="q_obj02"
#              LET g_qryparam.default1 = g_obj[l_ac].obj02
#              CALL cl_create_qry() RETURNING g_obj[l_ac].obj02
               CALL q_sel_ima(FALSE, "q_obj02","",g_obj[l_ac].obj02,"","","","","",'' ) 
                   RETURNING  g_obj[l_ac].obj02 
#FUN-AA0059---------mod------------end-----------------
               DISPLAY BY NAME g_obj[l_ac].obj02
               NEXT FIELD obj02
 
             WHEN INFIELD(att00) #款式編號
#FUN-AA0059---------mod------------str-----------------
#              CALL cl_init_qry_var()
#              LET g_qryparam.form ="q_att00"
#              LET g_qryparam.default1 = g_obj[l_ac].att00 
#              LET g_qryparam.arg1 =  g_obi.obi14     #by ve007
#              CALL cl_create_qry() RETURNING g_obj[l_ac].att00
              CALL q_sel_ima(FALSE, "q_att00","", g_obj[l_ac].att00,g_obi.obi14,"","","","",'' ) 
                   RETURNING    g_obj[l_ac].att00
#FUN-AA0059---------mod------------end-----------------
               DISPLAY BY NAME g_obj[l_ac].att00
               NEXT FIELD att00
           
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
 
    LET g_obi.obimodu = g_user
    LET g_obi.obidate = g_today
    UPDATE obi_file SET obimodu = g_obi.obimodu,obidate = g_obi.obidate
     WHERE obi01 = g_obi.obi01
    DISPLAY BY NAME g_obi.obimodu,g_obi.obidate
 
    CLOSE i009_bcl
    COMMIT WORK
#   CALL i009_delall()  #CHI-C30002 mark
    CALL i009_delHeader()     #CHI-C30002 add
    
    CALL i009_b_fill("1=1")  #離開單身時更新一下臨時表，
                             #保証臨時表里的數據和單身是完全一樣的
END FUNCTION
 
FUNCTION i009_b_ins()
DEFINE #l_sql           LIKE type_file.chr1000,
       l_sql           STRING,       #NO.FUN-910082  
       l_i2,l_j2       LIKE type_file.num5,
       l_ps            LIKE sma_file.sma46,
       l_obj02         LIKE obj_file.obj02,
       l_obj03         LIKE obj_file.obj03
DEFINE l_ocq           DYNAMIC ARRAY OF RECORD LIKE ocq_file.*
DEFINE l_str_tok       base.stringTokenizer,
       l_tmp           LIKE type_file.chr1000,
       ls_sql          STRING,       #NO.FUN-910082  
       lc_agb03        LIKE agb_file.agb03,
       l_param_list    LIKE type_file.chr1000
  DEFINE l_n          LIKE type_file.num5     #屬性的個數
  DEFINE l_i          LIKE type_file.num5     #末維屬性在第幾個
  DEFINE l_max        LIKE type_file.num5     #最后一個屬性項次
  DEFINE l_min        LIKE type_file.num5     #第一個屬性項次
 
    LET g_success = 'Y'
 
    SELECT sma46 INTO l_ps FROM sma_file
    IF cl_null(l_ps) THEN
       LET l_ps = ' '
    END IF
 
    SELECT COUNT(*) INTO l_n FROM agb_file WHERE agb01 = g_obi.obi14
    SELECT MAX(agb02) INTO l_max FROM agb_file WHERE agb01 = g_obi.obi14
    SELECT MIN(agb02) INTO l_min FROM agb_file WHERE agb01 = g_obi.obi14
    SELECT DISTINCT agb02 INTO l_i FROM ocq_file,agb_file
     WHERE ocq01 = g_obi.obi12
       AND ocq03 = agb03
    IF l_max = l_min THEN
       LET l_max = 4000
    END IF
    
    LET l_sql = "SELECT * FROM ocq_file WHERE ocq01 = '",g_obi.obi12,"'"
    PREPARE i009_ocq FROM l_sql
    DECLARE ocq_curs1 CURSOR FOR i009_ocq
       LET l_i2 = 1
    FOREACH ocq_curs1 INTO l_ocq[l_i2].*
       LET l_j2 = l_i2 + 3
       IF NOT cl_null(arr_detail[l_ac].imx[l_j2]) AND arr_detail[l_ac].imx[l_j2] != 0 THEN
          CALL i009_obj02(l_ocq[l_i2].ocq04,l_ocq[l_i2].ocq05) RETURNING g_obj[l_ac].obj02,g_obj[l_ac].obj03
          LET g_obj[l_ac].obj06 = arr_detail[l_ac].imx[l_j2]
          LET g_obj[l_ac].obj06 = s_digqty(g_obj[l_ac].obj06,g_obj[l_ac].obj07)     #FUN-910088 add
          LET g_obj[l_ac].obj04 = g_obj[l_ac].obj06/g_obj[l_ac].obj05
          
 
          #解析ls_value生成要傳給cl_copy_bom的那個l_param_list
          LET l_param_list = NULL  #每次傳之前要先清空 
          LET l_str_tok = base.StringTokenizer.create(g_obj[l_ac].obj02,l_ps)
          LET l_tmp = l_str_tok.nextToken()   #先把第一個部分--名稱去掉
 
          LET ls_sql = "SELECT agb03 FROM agb_file,ima_file WHERE ",
                       "ima01 = '",g_obj[l_ac].att00 CLIPPED,"' AND agb01 = imaag ",
                       "ORDER BY agb02"  
          DECLARE param_curs CURSOR FROM ls_sql
          FOREACH param_curs INTO lc_agb03
             #l_str_tok中的Tokens數量應該和param_curs中的記錄數量完全一致
             IF cl_null(l_param_list) THEN
                LET l_param_list = '#',lc_agb03,'#|',l_str_tok.nextToken()
             ELSE
                LET l_param_list = l_param_list,'|#',lc_agb03,'#|',l_str_tok.nextToken()
             END IF
          END FOREACH
               
          LET l_param_list = l_param_list,'|#',l_ocq[l_i2].ocq05,'|#',l_ocq[l_i2].ocq05
 
          INSERT INTO obj_file(obj01,obj02,obj03,obj04,obj05,obj06,obj07,
                               obj08,obj09,obj10,obj11,obj12,obj13,obj14)  
          VALUES(g_obi.obi01,g_obj[l_ac].obj02,g_obj[l_ac].obj03,
                 g_obj[l_ac].obj04,g_obj[l_ac].obj05,g_obj[l_ac].obj06,
                 g_obj[l_ac].obj07,g_obj[l_ac].obj08,g_obj[l_ac].obj09,
                 g_obj[l_ac].obj10,g_obj[l_ac].obj11,g_obj[l_ac].obj12,
                 g_obj[l_ac].obj13,g_obj[l_ac].obj14)  
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","obj_file",g_obi.obi01,g_obj[l_ac].obj02,SQLCA.sqlcode,"","",1)  
             LET g_success = 'N'
             RETURN g_success
          ELSE
             #調用cl_copy_ima將新生成的子料件插入到數據庫中
             IF cl_copy_ima(g_obj[l_ac].att00,g_obj[l_ac].obj02,g_obj[l_ac].obj03,l_param_list) = TRUE THEN
                IF l_i = l_max AND l_n = 3 THEN
                   INSERT INTO imx_file(imx000,imx00,imx01,imx02,imx03) 
                     VALUES(g_obj[l_ac].obj02,g_obj[l_ac].att00,arr_detail[l_ac].imx[2],
                            arr_detail[l_ac].imx[3],l_ocq[l_i2].ocq04)
                   #如果向imx_file中插入記錄失敗則也應將ima_file中已經建立的紀錄刪除以保証兩邊
                   #記錄的完全同步
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("ins","imx_file",g_obj[l_ac].obj02,"",SQLCA.sqlcode,"","Failure to insert imx_file , rollback insert to ima_file !",1)
                      DELETE FROM ima_file WHERE ima01 = g_obj[l_ac].obj02
                      LET g_success = 'N'
                      RETURN g_success
                   END IF
                END IF
                IF l_i = l_max AND l_n = 2 THEN
                   INSERT INTO imx_file(imx000,imx00,imx01,imx02) 
                     VALUES(g_obj[l_ac].obj02,g_obj[l_ac].att00,arr_detail[l_ac].imx[2],
                            l_ocq[l_i2].ocq04)
                   #如果向imx_file中插入記錄失敗則也應將ima_file中已經建立的紀錄刪除以保証兩邊
                   #記錄的完全同步
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("ins","imx_file",g_obj[l_ac].obj02,"",SQLCA.sqlcode,"","Failure to insert imx_file , rollback insert to ima_file !",1)
                      DELETE FROM ima_file WHERE ima01 = g_obj[l_ac].obj02
                      LET g_success = 'N'
                      RETURN g_success
                   END IF
                END IF
                IF l_i = l_min THEN
                   INSERT INTO imx_file(imx000,imx00,imx01,imx02,imx03) 
                     VALUES(g_obj[l_ac].obj02,g_obj[l_ac].att00,l_ocq[l_i2].ocq04,arr_detail[l_ac].imx[2],
                            arr_detail[l_ac].imx[3])
                   #如果向imx_file中插入記錄失敗則也應將ima_file中已經建立的紀錄刪除以保証兩邊
                   #記錄的完全同步
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("ins","imx_file",g_obj[l_ac].obj02,"",SQLCA.sqlcode,"","Failure to insert imx_file , rollback insert to ima_file !",1)
                      DELETE FROM ima_file WHERE ima01 = g_obj[l_ac].obj02
                      LET g_success = 'N'
                      RETURN g_success
                   END IF
                END IF
                IF l_i > l_min AND l_i <l_max THEN
                   INSERT INTO imx_file(imx000,imx00,imx01,imx02,imx03) 
                     VALUES(g_obj[l_ac].obj02,g_obj[l_ac].att00,arr_detail[l_ac].imx[2],l_ocq[l_i2].ocq04,
                            arr_detail[l_ac].imx[3])
                   #如果向imx_file中插入記錄失敗則也應將ima_file中已經建立的紀錄刪除以保証兩邊
                   #記錄的完全同步
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("ins","imx_file",g_obj[l_ac].obj02,"",SQLCA.sqlcode,"","Failure to insert imx_file , rollback insert to ima_file !",1)
                      DELETE FROM ima_file WHERE ima01 = g_obj[l_ac].obj02
                      LET g_success = 'N'
                      RETURN g_success
                   END IF
                END IF
             END IF
          END IF
       END IF
          LET l_i2 = l_i2 + 1
    END FOREACH 
    CALL arr_detail.clear()
    RETURN g_success
END FUNCTION
 
#組成子料件及品名的過程放在這個函數里面，在_b_ins()里面調用
FUNCTION i009_obj02(p_ocq04,p_ocq05)
DEFINE  p_ocq04       LIKE ocq_file.ocq04
DEFINE  p_ocq05       LIKE ocq_file.ocq05
DEFINE  l_n           LIKE type_file.num5     #屬性的個數
DEFINE  l_i           LIKE type_file.num5     #末維屬性在第幾個
DEFINE  l_max         LIKE type_file.num5     #最后一個屬性項次
DEFINE  l_min         LIKE type_file.num5     #第一個屬性項次
DEFINE  l_ps          LIKE sma_file.sma46     #系統標準的分割符
DEFINE  l_agd03       LIKE agd_file.agd03
DEFINE  l_att00       LIKE ima_file.ima01
DEFINE  l_att01       LIKE ima_file.ima02
 
    LET g_success = 'Y'
 
    SELECT sma46 INTO l_ps FROM sma_file
    IF cl_null(l_ps) THEN
       LET l_ps = ' '
    END IF
 
    LET g_obj[l_ac].obj02 = g_obj[l_ac].att00
    LET g_obj[l_ac].obj03 = g_obj[l_ac].att01
 
    SELECT COUNT(*) INTO l_n FROM agb_file WHERE agb01 = g_obi.obi14
    SELECT MAX(agb02) INTO l_max FROM agb_file WHERE agb01 = g_obi.obi14
    SELECT MIN(agb02) INTO l_min FROM agb_file WHERE agb01 = g_obi.obi14
    SELECT DISTINCT agb02 INTO l_i FROM ocq_file,agb_file
     WHERE ocq01 = g_obi.obi12
       AND ocq03 = agb03
    IF l_max = l_min THEN
       LET l_max = 4000
    END IF
 
    IF l_i = l_max THEN                     #最后一個屬性是末維屬性
       IF NOT cl_null(g_obj[l_ac].att02) THEN
          LET g_obj[l_ac].obj02 = g_obj[l_ac].obj02 CLIPPED,l_ps,g_obj[l_ac].att02
          LET l_agd03 = ''
          SELECT agd03 INTO l_agd03 FROM agd_file
           WHERE agd01 = lr_agc[1].agc01 AND agd02 = g_obj[l_ac].att02
          IF cl_null(l_agd03) THEN
             LET g_obj[l_ac].obj03 = g_obj[l_ac].obj03 CLIPPED,l_ps,g_obj[l_ac].att02
          ELSE
             LET g_obj[l_ac].obj03 = g_obj[l_ac].obj03 CLIPPED,l_ps,l_agd03
          END IF
       END IF
       IF NOT cl_null(g_obj[l_ac].att02_c) THEN
          LET g_obj[l_ac].obj02 = g_obj[l_ac].obj02 CLIPPED,l_ps,g_obj[l_ac].att02_c
          LET l_agd03 = ''
          SELECT agd03 INTO l_agd03 FROM agd_file
           WHERE agd01 = lr_agc[1].agc01 AND agd02 = g_obj[l_ac].att02_c
          IF cl_null(l_agd03) THEN
             LET g_obj[l_ac].obj03 = g_obj[l_ac].obj03 CLIPPED,l_ps,g_obj[l_ac].att02_c
          ELSE
             LET g_obj[l_ac].obj03 = g_obj[l_ac].obj03 CLIPPED,l_ps,l_agd03
          END IF
       END IF
       IF NOT cl_null(g_obj[l_ac].att03) THEN
          LET g_obj[l_ac].obj02 = g_obj[l_ac].obj02 CLIPPED,l_ps,g_obj[l_ac].att03
          LET l_agd03 = ''
          SELECT agd03 INTO l_agd03 FROM agd_file
           WHERE agd01 = lr_agc[2].agc01 AND agd02 = g_obj[l_ac].att03
          IF cl_null(l_agd03) THEN
             LET g_obj[l_ac].obj03 = g_obj[l_ac].obj03 CLIPPED,l_ps,g_obj[l_ac].att03
          ELSE
             LET g_obj[l_ac].obj03 = g_obj[l_ac].obj03 CLIPPED,l_ps,l_agd03
          END IF
       END IF
       IF NOT cl_null(g_obj[l_ac].att03_c) THEN
          LET g_obj[l_ac].obj02 = g_obj[l_ac].obj02 CLIPPED,l_ps,g_obj[l_ac].att03_c
          LET l_agd03 = ''
          SELECT agd03 INTO l_agd03 FROM agd_file
           WHERE agd01 = lr_agc[2].agc01 AND agd02 = g_obj[l_ac].att03_c
          IF cl_null(l_agd03) THEN
             LET g_obj[l_ac].obj03 = g_obj[l_ac].obj03 CLIPPED,l_ps,g_obj[l_ac].att03_c
          ELSE
             LET g_obj[l_ac].obj03 = g_obj[l_ac].obj03 CLIPPED,l_ps,l_agd03
          END IF
       END IF
       LET g_obj[l_ac].obj02 = g_obj[l_ac].obj02 CLIPPED,l_ps,p_ocq04
       LET g_obj[l_ac].obj03 = g_obj[l_ac].obj03 CLIPPED,l_ps,p_ocq05
    END IF
 
    IF l_i = l_min THEN                     #第一個屬性是末維屬性
       LET g_obj[l_ac].obj02 = g_obj[l_ac].obj02 CLIPPED,l_ps,p_ocq04
       LET g_obj[l_ac].obj03 = g_obj[l_ac].obj03 CLIPPED,l_ps,p_ocq05
       IF NOT cl_null(g_obj[l_ac].att02) THEN
          LET g_obj[l_ac].obj02 = g_obj[l_ac].obj02 CLIPPED,l_ps,g_obj[l_ac].att02
          LET l_agd03 = ''
          SELECT agd03 INTO l_agd03 FROM agd_file
           WHERE agd01 = lr_agc[2].agc01 AND agd02 = g_obj[l_ac].att02
          IF cl_null(l_agd03) THEN
             LET g_obj[l_ac].obj03 = g_obj[l_ac].obj03 CLIPPED,l_ps,g_obj[l_ac].att02
          ELSE
             LET g_obj[l_ac].obj03 = g_obj[l_ac].obj03 CLIPPED,l_ps,l_agd03
          END IF
       END IF
       IF NOT cl_null(g_obj[l_ac].att02_c) THEN
          LET g_obj[l_ac].obj02 = g_obj[l_ac].obj02 CLIPPED,l_ps,g_obj[l_ac].att02_c
          LET l_agd03 = ''
          SELECT agd03 INTO l_agd03 FROM agd_file
           WHERE agd01 = lr_agc[2].agc01 AND agd02 = g_obj[l_ac].att02_c
          IF cl_null(l_agd03) THEN
             LET g_obj[l_ac].obj03 = g_obj[l_ac].obj03 CLIPPED,l_ps,g_obj[l_ac].att02_c
          ELSE
             LET g_obj[l_ac].obj03 = g_obj[l_ac].obj03 CLIPPED,l_ps,l_agd03
          END IF
       END IF
       IF NOT cl_null(g_obj[l_ac].att03) THEN
          LET g_obj[l_ac].obj02 = g_obj[l_ac].obj02 CLIPPED,l_ps,g_obj[l_ac].att03
          LET l_agd03 = ''
          SELECT agd03 INTO l_agd03 FROM agd_file
           WHERE agd01 = lr_agc[3].agc01 AND agd02 = g_obj[l_ac].att03
          IF cl_null(l_agd03) THEN
             LET g_obj[l_ac].obj03 = g_obj[l_ac].obj03 CLIPPED,l_ps,g_obj[l_ac].att03
          ELSE
             LET g_obj[l_ac].obj03 = g_obj[l_ac].obj03 CLIPPED,l_ps,l_agd03
          END IF
       END IF
       IF NOT cl_null(g_obj[l_ac].att03_c) THEN
          LET g_obj[l_ac].obj02 = g_obj[l_ac].obj02 CLIPPED,l_ps,g_obj[l_ac].att03_c
          LET l_agd03 = ''
          SELECT agd03 INTO l_agd03 FROM agd_file
           WHERE agd01 = lr_agc[3].agc01 AND agd02 = g_obj[l_ac].att03_c
          IF cl_null(l_agd03) THEN
             LET g_obj[l_ac].obj03 = g_obj[l_ac].obj03 CLIPPED,l_ps,g_obj[l_ac].att03_c
          ELSE
             LET g_obj[l_ac].obj03 = g_obj[l_ac].obj03 CLIPPED,l_ps,l_agd03
          END IF
       END IF
    END IF
 
    IF l_i > l_min AND l_i < l_max THEN     #中間的屬性是末維屬性 
       IF NOT cl_null(g_obj[l_ac].att02) THEN
          LET g_obj[l_ac].obj02 = g_obj[l_ac].obj02 CLIPPED,l_ps,g_obj[l_ac].att02
          LET l_agd03 = ''
          SELECT agd03 INTO l_agd03 FROM agd_file
           WHERE agd01 = lr_agc[1].agc01 AND agd02 = g_obj[l_ac].att02
          IF cl_null(l_agd03) THEN
             LET g_obj[l_ac].obj03 = g_obj[l_ac].obj03 CLIPPED,l_ps,g_obj[l_ac].att02
          ELSE
             LET g_obj[l_ac].obj03 = g_obj[l_ac].obj03 CLIPPED,l_ps,l_agd03
          END IF
       END IF
       IF NOT cl_null(g_obj[l_ac].att02_c) THEN
          LET g_obj[l_ac].obj02 = g_obj[l_ac].obj02 CLIPPED,l_ps,g_obj[l_ac].att02_c
          LET l_agd03 = ''
          SELECT agd03 INTO l_agd03 FROM agd_file
           WHERE agd01 = lr_agc[1].agc01 AND agd02 = g_obj[l_ac].att02_c
          IF cl_null(l_agd03) THEN
             LET g_obj[l_ac].obj03 = g_obj[l_ac].obj03 CLIPPED,l_ps,g_obj[l_ac].att02_c
          ELSE
             LET g_obj[l_ac].obj03 = g_obj[l_ac].obj03 CLIPPED,l_ps,l_agd03
          END IF
       END IF
       LET g_obj[l_ac].obj02 = g_obj[l_ac].obj02 CLIPPED,l_ps,p_ocq04
       LET g_obj[l_ac].obj03 = g_obj[l_ac].obj03 CLIPPED,l_ps,p_ocq05
       IF NOT cl_null(g_obj[l_ac].att03) THEN
          LET g_obj[l_ac].obj02 = g_obj[l_ac].obj02 CLIPPED,l_ps,g_obj[l_ac].att03
          LET l_agd03 = ''
          SELECT agd03 INTO l_agd03 FROM agd_file
           WHERE agd01 = lr_agc[3].agc01 AND agd02 = g_obj[l_ac].att03
          IF cl_null(l_agd03) THEN
             LET g_obj[l_ac].obj03 = g_obj[l_ac].obj03 CLIPPED,l_ps,g_obj[l_ac].att03
          ELSE
             LET g_obj[l_ac].obj03 = g_obj[l_ac].obj03 CLIPPED,l_ps,l_agd03
          END IF
       END IF
       IF NOT cl_null(g_obj[l_ac].att03_c) THEN
          LET g_obj[l_ac].obj02 = g_obj[l_ac].obj02 CLIPPED,l_ps,g_obj[l_ac].att03_c
          LET l_agd03 = ''
          SELECT agd03 INTO l_agd03 FROM agd_file
           WHERE agd01 = lr_agc[3].agc01 AND agd02 = g_obj[l_ac].att03_c
          IF cl_null(l_agd03) THEN
             LET g_obj[l_ac].obj03 = g_obj[l_ac].obj03 CLIPPED,l_ps,g_obj[l_ac].att03_c
          ELSE
             LET g_obj[l_ac].obj03 = g_obj[l_ac].obj03 CLIPPED,l_ps,l_agd03
          END IF
       END IF
    END IF
 
    RETURN g_obj[l_ac].obj02,g_obj[l_ac].obj03
 
END FUNCTION
 
FUNCTION i009_wc()
DEFINE 
    l_wc           STRING       #NO.FUN-910082 
 
    LET l_wc = "att00 = '",g_obj[l_ac].att00,"'"
 
    IF NOT cl_null(g_obj[l_ac].att02) THEN
       LET l_wc = l_wc CLIPPED," AND att02 = '",g_obj[l_ac].att02,"'"
    END IF
    IF NOT cl_null(g_obj[l_ac].att03) THEN
       LET l_wc = l_wc CLIPPED," AND att02 = '",g_obj[l_ac].att02,"'"
    END IF
    IF NOT cl_null(g_obj[l_ac].att02_c) THEN
       LET l_wc = l_wc CLIPPED," AND att02_c = '",g_obj[l_ac].att02_c,"'"
    END IF
    IF NOT cl_null(g_obj[l_ac].att03_c) THEN
       LET l_wc = l_wc CLIPPED," AND att03_c = '",g_obj[l_ac].att03_c,"'"
    END IF
 
    RETURN l_wc
END FUNCTION
 
FUNCTION i009_b_del()
DEFINE #l_sqldel      LIKE type_file.chr1000
       l_sqldel        STRING       #NO.FUN-910082  
DEFINE 
       #l_wc          LIKE type_file.chr1000
       l_wc           STRING       #NO.FUN-910082 
DEFINE l_obj02       LIKE obj_file.obj02
 
    LET g_success = 'Y'
 
    CALL i009_wc() RETURNING l_wc 
    LET l_sqldel = "SELECT obj02 FROM i009_temp",
                   " WHERE ",l_wc CLIPPED
    PREPARE i009_del FROM l_sqldel
    DECLARE del_cs CURSOR FOR i009_del
 
    FOREACH del_cs INTO l_obj02
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
       DELETE FROM obj_file WHERE obj01 = g_obi.obi01
                              AND obj02 = l_obj02
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","obj_file",g_obi.obi01,l_obj02,SQLCA.sqlcode,"","",1) 
          LET g_success = 'N'
          EXIT FOREACH
       END IF 
          
    END FOREACH
    RETURN g_success 
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i009_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM obi_file WHERE obi01 = g_obi.obi01
         INITIALIZE g_obi.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION i009_delall()
#
#  SELECT COUNT(*) INTO g_cnt FROM obj_file
#   WHERE obj01 = g_obi.obi01
#
#  IF g_cnt = 0 THEN                   # 未輸入單身資料, 是否取消單頭資料
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM obi_file WHERE obi01 = g_obi.obi01
#  END IF
#
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION i009_b_askkey()
 
    DEFINE 
          l_wc2           STRING       #NO.FUN-910082 
 
    CONSTRUCT l_wc2 ON obj02,obj03,obj05   
            FROM s_obj[1].obj02,s_obj[1].obj05,
                 s_obj[1].obj05_ima02                
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
       ON ACTION controlp
          CASE
            WHEN INFIELD(obj03) #廠商編號
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form ="q_obj03"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO obj03
              NEXT FIELD obj03
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
 
    END CONSTRUCT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
 
    LET l_wc2 = l_wc2 CLIPPED," AND obj11 ='",g_obj[l_ac].obj11,"'"  
    CALL i009_show_field() 
    CALL i009_b_fill(l_wc2)
 
END FUNCTION
 
#此函數用來解析obj02，將obj02還原到各屬性中去
FUNCTION i009_b_row(p_n)
  DEFINE p_n          LIKE type_file.num5
  DEFINE l_ps         LIKE sma_file.sma46
  DEFINE l_tok        base.stringTokenizer
  DEFINE field_array  DYNAMIC ARRAY OF LIKE type_file.chr1000
  DEFINE i,k          LIKE type_file.num5
  DEFINE ls_show      STRING
  DEFINE #l_sql        LIKE type_file.chr1000
         l_sql        STRING       #NO.FUN-910082  
  DEFINE l_ocq        DYNAMIC ARRAY OF RECORD LIKE ocq_file.*
  DEFINE l_m          LIKE type_file.num5
  DEFINE l_index      LIKE type_file.num5
  DEFINE l_string     STRING
  DEFINE l_n          LIKE type_file.num5     #屬性的個數
  DEFINE l_i          LIKE type_file.num5     #末維屬性在第幾個
  DEFINE l_max        LIKE type_file.num5     #最后一個屬性項次
  DEFINE l_min        LIKE type_file.num5     #第一個屬性項次
 
    SELECT sma46 INTO l_ps FROM sma_file
    IF cl_null(l_ps) THEN
       LET l_ps = ' '
    END IF
 
    SELECT COUNT(*) INTO l_n FROM agb_file WHERE agb01 = g_obi.obi14
    SELECT MAX(agb02) INTO l_max FROM agb_file WHERE agb01 = g_obi.obi14
    SELECT MIN(agb02) INTO l_min FROM agb_file WHERE agb01 = g_obi.obi14
    SELECT DISTINCT agb02 INTO l_i FROM ocq_file,agb_file
     WHERE ocq01 = g_obi.obi12
       AND ocq03 = agb03
    IF l_max = l_min THEN
       LET l_max = 4000
    END IF
 
    IF NOT cl_null(g_obi.obi12) THEN
       LET l_tok = base.StringTokenizer.createExt(lg_obj[p_n].obj02,l_ps,'',TRUE)
           IF l_tok.countTokens() > 0 THEN
              LET k=0
              WHILE l_tok.hasMoreTokens()
                    LET k=k+1
                    LET field_array[k] = l_tok.nextToken()
              END WHILE
           END IF
 
       CALL i009_refresh_detail() RETURNING ls_show
       LET ls_show = ls_show||','
 
       LET lg_obj[p_n].att00 = field_array[1]
       SELECT ima02,ima18,ima31 INTO lg_obj[p_n].att01,lg_obj[p_n].obj13,lg_obj[p_n].obj07
         FROM ima_file
        WHERE ima01 = lg_obj[p_n].att00
 
       IF l_i = l_max THEN        #最后一個屬性為末維屬性
          LET i = 2
   
          IF ls_show.getIndexOf("att02,",1) THEN
             LET lg_obj[p_n].att02 = field_array[i]
             LET i = i + 1
          END IF
          IF ls_show.getIndexOf("att02_c,",1) THEN
             LET lg_obj[p_n].att02_c = field_array[i]
             LET i = i + 1
          END IF
          IF ls_show.getIndexOf("att03,",1) THEN
             LET lg_obj[p_n].att03 = field_array[i]
             LET i = i + 1
          END IF
          IF ls_show.getIndexOf("att03_c,",1) THEN
             LET lg_obj[p_n].att03_c = field_array[i]
             LET i = i + 1
          END IF
      
          CALL arr_show.clear() 
          LET l_sql = "SELECT * FROM ocq_file WHERE ocq01 = '",g_obi.obi12,"'"
          PREPARE i009_ocq1 FROM l_sql
          DECLARE ocq_curs2 CURSOR FOR i009_ocq1
             LET l_m = 1
          FOREACH ocq_curs2 INTO l_ocq[l_m].*
             LET l_string = lg_obj[p_n].obj02
             LET l_ocq[l_m].ocq04 = l_ps CLIPPED,l_ocq[l_m].ocq04
             IF l_string.getIndexOf(l_ocq[l_m].ocq04,1) THEN
                LET l_index = l_m + 3
                LET arr_show[p_n].att[l_index] = lg_obj[p_n].obj06
             END IF 
             LET l_m = l_m + 1
       
          END FOREACH 
          LET lg_obj[p_n].att04 = arr_show[p_n].att[4] 
          LET lg_obj[p_n].att05 = arr_show[p_n].att[5] 
          LET lg_obj[p_n].att06 = arr_show[p_n].att[6]
          LET lg_obj[p_n].att07 = arr_show[p_n].att[7]
          LET lg_obj[p_n].att08 = arr_show[p_n].att[8]
          LET lg_obj[p_n].att09 = arr_show[p_n].att[9]
          LET lg_obj[p_n].att10 = arr_show[p_n].att[10]
          LET lg_obj[p_n].att11 = arr_show[p_n].att[11]
          LET lg_obj[p_n].att12 = arr_show[p_n].att[12]
          LET lg_obj[p_n].att13 = arr_show[p_n].att[13]
       END IF
 
       IF l_i = l_min THEN            #第一個屬性為末維屬性
          LET i = 3
   
          IF ls_show.getIndexOf("att02,",1) THEN
             LET lg_obj[p_n].att02 = field_array[i]
             LET i = i + 1
          END IF
          IF ls_show.getIndexOf("att02_c,",1) THEN
             LET lg_obj[p_n].att02_c = field_array[i]
             LET i = i + 1
          END IF
          IF ls_show.getIndexOf("att03,",1) THEN
             LET lg_obj[p_n].att03 = field_array[i]
             LET i = i + 1
          END IF
          IF ls_show.getIndexOf("att03_c,",1) THEN
             LET lg_obj[p_n].att03_c = field_array[i]
             LET i = i + 1
          END IF
      
          CALL arr_show.clear() 
          LET l_sql = "SELECT * FROM ocq_file WHERE ocq01 = '",g_obi.obi12,"'"
          PREPARE i009_ocq2 FROM l_sql
          DECLARE ocq_curs3 CURSOR FOR i009_ocq2
             LET l_m = 1
          FOREACH ocq_curs3 INTO l_ocq[l_m].*
             LET l_string = lg_obj[p_n].obj02
             IF l_string.getIndexOf(l_ocq[l_m].ocq04,1) THEN
                LET l_index = l_m + 3
                LET arr_show[p_n].att[l_index] = lg_obj[p_n].obj06
             END IF 
             LET l_m = l_m + 1
       
          END FOREACH 
          LET lg_obj[p_n].att04 = arr_show[p_n].att[4] 
          LET lg_obj[p_n].att05 = arr_show[p_n].att[5] 
          LET lg_obj[p_n].att06 = arr_show[p_n].att[6]
          LET lg_obj[p_n].att07 = arr_show[p_n].att[7]
          LET lg_obj[p_n].att08 = arr_show[p_n].att[8]
          LET lg_obj[p_n].att09 = arr_show[p_n].att[9]
          LET lg_obj[p_n].att10 = arr_show[p_n].att[10]
          LET lg_obj[p_n].att11 = arr_show[p_n].att[11]
          LET lg_obj[p_n].att12 = arr_show[p_n].att[12]
          LET lg_obj[p_n].att13 = arr_show[p_n].att[13]
       END IF
 
       IF l_i < l_max AND l_i > l_min THEN   #第二個屬性是末維屬性
 
          LET i = 2
          IF ls_show.getIndexOf("att02,",1) THEN
             LET lg_obj[p_n].att02 = field_array[i]
          END IF
          IF ls_show.getIndexOf("att02_c,",1) THEN
             LET lg_obj[p_n].att02_c = field_array[i]
          END IF
          LET i = 4
          IF ls_show.getIndexOf("att03,",1) THEN
             LET lg_obj[p_n].att03 = field_array[i]
          END IF
          IF ls_show.getIndexOf("att03_c,",1) THEN
             LET lg_obj[p_n].att03_c = field_array[i]
          END IF
      
          CALL arr_show.clear() 
          LET l_sql = "SELECT * FROM ocq_file WHERE ocq01 = '",g_obi.obi12,"'"
          PREPARE i009_ocq3 FROM l_sql
          DECLARE ocq_curs4 CURSOR FOR i009_ocq3
             LET l_m = 1
          FOREACH ocq_curs4 INTO l_ocq[l_m].*
             LET l_string = lg_obj[p_n].obj02
             LET l_ocq[l_m].ocq04 = l_ps CLIPPED,l_ocq[l_m].ocq04 CLIPPED,l_ps CLIPPED
             IF l_string.getIndexOf(l_ocq[l_m].ocq04,1) THEN
                LET l_index = l_m + 3
                LET arr_show[p_n].att[l_index] = lg_obj[p_n].obj06
             END IF 
             LET l_m = l_m + 1
       
          END FOREACH 
          LET lg_obj[p_n].att04 = arr_show[p_n].att[4] 
          LET lg_obj[p_n].att05 = arr_show[p_n].att[5] 
          LET lg_obj[p_n].att06 = arr_show[p_n].att[6]
          LET lg_obj[p_n].att07 = arr_show[p_n].att[7]
          LET lg_obj[p_n].att08 = arr_show[p_n].att[8]
          LET lg_obj[p_n].att09 = arr_show[p_n].att[9]
          LET lg_obj[p_n].att10 = arr_show[p_n].att[10]
          LET lg_obj[p_n].att11 = arr_show[p_n].att[11]
          LET lg_obj[p_n].att12 = arr_show[p_n].att[12]
          LET lg_obj[p_n].att13 = arr_show[p_n].att[13]
       END IF
 
    END IF
 
END FUNCTION
 
#先把單身的數據放到一個臨時的數組lg_obj里面，然后把這個數組按照相同
#的屬性填充完整，這樣數組里面就有一樣的數據，然后把這些數據放到臨時
#表里面，DISTINCT數據，得到最后顯示在單身的數據
FUNCTION i009_b_row2()
  DEFINE l_n          LIKE type_file.num5
  DEFINE m,n          LIKE type_file.num5
  DEFINE i            LIKE type_file.num5
  DEFINE k            LIKE type_file.num5
  DEFINE #l_sql        LIKE type_file.chr1000
         l_sql        STRING       #NO.FUN-910082  
 
       SELECT COUNT(*) INTO l_n FROM obj_file
        WHERE obj01 = g_obi.obi01
 
       FOR k = 1 TO l_n                        #空值不能比較，所以先賦值
           IF cl_null(lg_obj[k].att02) THEN
              LET lg_obj[k].att02 = ' '
           END IF
           IF cl_null(lg_obj[k].att03) THEN
              LET lg_obj[k].att03 = ' '
           END IF
           IF cl_null(lg_obj[k].att02_c) THEN
              LET lg_obj[k].att02_c = ' '
           END IF
           IF cl_null(lg_obj[k].att03_c) THEN
              LET lg_obj[k].att03_c = ' '
           END IF
       END FOR
 
       FOR m = 1 TO l_n
          FOR n = 1 TO l_n
             IF lg_obj[m].att00 = lg_obj[n].att00 
                AND lg_obj[m].att02 = lg_obj[n].att02
                AND lg_obj[m].att03 = lg_obj[n].att03
                AND lg_obj[m].att02_c = lg_obj[n].att02_c
                AND lg_obj[m].att03_c = lg_obj[n].att03_c THEN
                
                IF NOT cl_null(lg_obj[n].att04) THEN
                   LET lg_obj[m].att04 = lg_obj[n].att04
                END IF
                IF NOT cl_null(lg_obj[n].att05) THEN
                   LET lg_obj[m].att05 = lg_obj[n].att05
                END IF
                IF NOT cl_null(lg_obj[n].att06) THEN
                   LET lg_obj[m].att06 = lg_obj[n].att06
                END IF
                IF NOT cl_null(lg_obj[n].att07) THEN
                   LET lg_obj[m].att07 = lg_obj[n].att07
                END IF
                IF NOT cl_null(lg_obj[n].att08) THEN
                   LET lg_obj[m].att08 = lg_obj[n].att08
                END IF
                IF NOT cl_null(lg_obj[n].att09) THEN
                   LET lg_obj[m].att09 = lg_obj[n].att09
                END IF
                IF NOT cl_null(lg_obj[n].att10) THEN
                   LET lg_obj[m].att10 = lg_obj[n].att10
                END IF
                IF NOT cl_null(lg_obj[n].att11) THEN
                   LET lg_obj[m].att11 = lg_obj[n].att11
                END IF
                IF NOT cl_null(lg_obj[n].att12) THEN
                   LET lg_obj[m].att12 = lg_obj[n].att12
                END IF
                IF NOT cl_null(lg_obj[n].att13) THEN
                   LET lg_obj[m].att13 = lg_obj[n].att13
                END IF
 
             END IF
          END FOR
       END FOR
 
       FOR k = 1 TO l_n
           IF lg_obj[k].att02=' ' THEN
              LET lg_obj[k].att02 = ''
           END IF
           IF lg_obj[k].att03=' ' THEN
              LET lg_obj[k].att03 = ''
           END IF
           IF lg_obj[k].att02_c=' ' THEN
              LET lg_obj[k].att02_c = ''
           END IF
           IF lg_obj[k].att03_c=' ' THEN
              LET lg_obj[k].att03_c = ''
           END IF
       END FOR
       DROP TABLE i009_temp
       CREATE TEMP TABLE i009_temp(
                                   att00   LIKE obj_file.obj02,
                                   att01   LIKE obj_file.obj03,
                                   att02   LIKE agd_file.agd02,
                                   att02_c LIKE agd_file.agd02,
                                   att03   LIKE agd_file.agd02,
                                   att03_c LIKE agd_file.agd02,
                                   att04   LIKE obj_file.obj06,
                                   att05   LIKE obj_file.obj06,
                                   att06   LIKE obj_file.obj06,
                                   att07   LIKE obj_file.obj06,
                                   att08   LIKE obj_file.obj06,
                                   att09   LIKE obj_file.obj06,
                                   att10   LIKE obj_file.obj06,
                                   att11   LIKE obj_file.obj06,
                                   att12   LIKE obj_file.obj06,
                                   att13   LIKE obj_file.obj06,
                                   obj02   LIKE obj_file.obj02,
                                   obj03   LIKE obj_file.obj03,
                                   obj04   LIKE obj_file.obj04,
                                   obj05   LIKE obj_file.obj05,
                                   obj06   LIKE obj_file.obj06,
                                   obj07   LIKE obj_file.obj07,
                                   obj08   LIKE obj_file.obj08,
                                   obj09   LIKE obj_file.obj09,
                                   obj10   LIKE obj_file.obj10,
                                   obj11   LIKE obj_file.obj11,
                                   obj12   LIKE obj_file.obj12,
                                   obj13   LIKE obj_file.obj13,
                                   obj14   LIKE obj_file.obj14);
       DELETE FROM i009_temp 
       FOR i = 1 TO l_n
           INSERT INTO i009_temp VALUES(lg_obj[i].*)
       END FOR
 
       LET l_sql = "SELECT DISTINCT att00,att01,att02,att02_c,att03,",
                   "                att03_c,att04,att05,att06,att07,",
                   "                att08,att09,att10,att11,att12,att13,",
                   "                '','','',obj05,'',obj07,",
                   "                obj08,obj09,obj10,obj11,obj12,obj13,obj14",
                   "  FROM i009_temp",
                   " ORDER BY att00,att02,att02_c,att03,att03_c" 
       PREPARE i009_temp FROM l_sql
       DECLARE temp_cs CURSOR FOR i009_temp
 
       LET g_cnt = 1
       FOREACH temp_cs INTO g_obj[g_cnt].*    #二維單身填充
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
    
          LET g_cnt = g_cnt + 1
          IF g_cnt > g_max_rec THEN
             CALL cl_err('',9035,0)
             EXIT FOREACH
          END IF
       END FOREACH
 
END FUNCTION
 
#此函數用來檢查款式編號和屬性是否重復
FUNCTION i009_check()
  DEFINE i            LIKE type_file.num5
  DEFINE k            LIKE type_file.num5
 
  LET g_success = 'Y'
  LET g_rec_b = g_rec_b + 1
 
       FOR k = 1 TO g_rec_b                    #空值不能比較，所以先賦值
           IF cl_null(g_obj[k].att02) THEN
              LET g_obj[k].att02 = ' '
           END IF
           IF cl_null(g_obj[k].att03) THEN
              LET g_obj[k].att03 = ' '
           END IF
           IF cl_null(g_obj[k].att02_c) THEN
              LET g_obj[k].att02_c = ' '
           END IF
           IF cl_null(g_obj[k].att03_c) THEN
              LET g_obj[k].att03_c = ' '
           END IF
       END FOR
 
       LET g_rec_b = g_rec_b - 1
       FOR i = 1 TO g_rec_b
          IF NOT cl_null(g_obj[i].obj05) THEN 
             IF g_obj[l_ac].att00 = g_obj[i].att00 
                AND g_obj[l_ac].att02 = g_obj[i].att02
                AND g_obj[l_ac].att03 = g_obj[i].att03
                AND g_obj[l_ac].att02_c = g_obj[i].att02_c
                AND g_obj[l_ac].att03_c = g_obj[i].att03_c THEN
 
                LET g_success = 'N'
             END IF
          END IF
       END FOR
 
       LET g_rec_b = g_rec_b + 1
       FOR k = 1 TO g_rec_b
           IF g_obj[k].att02=' ' THEN
              LET g_obj[k].att02 = ''
           END IF
           IF g_obj[k].att03=' ' THEN
              LET g_obj[k].att03 = ''
           END IF
           IF g_obj[k].att02_c=' ' THEN
              LET g_obj[k].att02_c = ''
           END IF
           IF g_obj[k].att03_c=' ' THEN
              LET g_obj[k].att03_c = ''
           END IF
       END FOR
 
  LET g_rec_b = g_rec_b - 1
  RETURN g_success
 
END FUNCTION
 
FUNCTION i009_b_fill(p_wc2)
   DEFINE 
      p_wc2           STRING       #NO.FUN-910082 
 
   LET g_sql = "SELECT '','','','','','','','','','','','','','','','',",
               "      obj02,obj03,obj04,obj05,obj06,obj07,",
               "      obj08,obj09,obj10,obj11,obj12,obj13,obj14 ",
               " FROM obj_file",   
               " WHERE obj01 ='",g_obi.obi01,"' "   #單頭
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY obj02 "
   DISPLAY g_sql
 
   PREPARE i009_pb FROM g_sql
   DECLARE obj_cs CURSOR FOR i009_pb
 
   CALL g_obj.clear()
   LET g_cnt = 1
   
   IF cl_null(g_obi.obi12) THEN   #正常的單身
      FOREACH obj_cs INTO g_obj[g_cnt].*   #單身 ARRAY 填充
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
    
          LET g_cnt = g_cnt + 1
          IF g_cnt > g_max_rec THEN
             CALL cl_err( '', 9035, 0 )
             EXIT FOREACH
          END IF
      END FOREACH
   ELSE                           #二維單身
      CALL lg_obj.clear()
      FOREACH obj_cs INTO lg_obj[g_cnt].*   #單身 ARRAY 填充
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
    
          CALL i009_b_row(g_cnt)
    
          LET g_cnt = g_cnt + 1
          IF g_cnt > g_max_rec THEN
             CALL cl_err( '', 9035, 0 )
             EXIT FOREACH
          END IF
      END FOREACH
      CALL lg_obj.deleteElement(g_cnt)
      CALL i009_b_row2()
   END IF
 
   CALL g_obj.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i009_copy()
   DEFINE l_newno     LIKE obi_file.obi01,
          l_newdate   LIKE obi_file.obi02,
          l_oldno     LIKE obi_file.obi01
   DEFINE li_result   LIKE type_file.num5    
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_obi.obi01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL i009_set_entry('a')
 
   CALL cl_set_head_visible("","YES")           
   INPUT l_newno FROM obi01
       BEFORE INPUT
          CALL cl_set_docno_format("obi01")
 
       AFTER FIELD obi01
           CALL s_check_no("axm",l_newno,"","61","obi_file","obi01","") RETURNING li_result,l_newno
           DISPLAY l_newno TO obi01
           IF (NOT li_result) THEN
              LET g_obi.obi01 = g_obi_o.obi01
              NEXT FIELD obi01
           END IF
           BEGIN WORK 
           CALL s_auto_assign_no("axm",l_newno,g_today,"61","obi_file","obi01","","","") RETURNING li_result,l_newno
           IF (NOT li_result) THEN
              NEXT FIELD obi01
           END IF
           DISPLAY l_newno TO obi01
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(obi01) #包裝編號
                 LET g_t1=s_get_doc_no(l_newno)         
                CALL q_oay(FALSE,FALSE,g_t1,'61','axm') RETURNING g_t1     #FUN-A70130
                 LET l_newno=g_t1                     
                NEXT FIELD obi01
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
      DISPLAY BY NAME g_obi.obi01
      ROLLBACK WORK
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM obi_file         #單頭複製
       WHERE obi01=g_obi.obi01
       INTO TEMP y
 
   UPDATE y
       SET obi01=l_newno,    #新的鍵值
           obiuser=g_user,   #資料所有者
           obigrup=g_grup,   #資料所有者所屬群
           obimodu=NULL,     #資料修改日期
           obidate=g_today,  #資料建立日期
           obiacti='Y'       #有效資料
 
   INSERT INTO obi_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","obi_file","","",SQLCA.sqlcode,"","",1) 
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
   END IF
 
   DROP TABLE x
 
   SELECT * FROM obj_file         #單身複製
       WHERE obj01=g_obi.obi01
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)  
      RETURN
   END IF
 
   UPDATE x SET obj01=l_newno
 
   INSERT INTO obj_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","obj_file","","",SQLCA.sqlcode,"","",1)  #FUN-B80030  ADD
      ROLLBACK WORK 
      #CALL cl_err3("ins","obj_file","","",SQLCA.sqlcode,"","",1)  #FUN-B80030 MARK
      RETURN
   ELSE
       COMMIT WORK 
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_obi.obi01
   SELECT obi_file.* INTO g_obi.* FROM obi_file WHERE obi01 = l_newno
   CALL i009_u()
   CALL i009_show_field()   #控制單身顯示
   CALL i009_b()
   #SELECT obi_file.* INTO g_obi.* FROM obi_file WHERE obi01 = l_oldno #FUN-C80046
   #CALL i009_show()                                                   #FUN-C80046
 
END FUNCTION
 
FUNCTION i009_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("obi01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i009_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("obi01",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION i009_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    
 
    IF p_cmd = 'a' THEN
      CALL cl_set_comp_entry("att00,att02,att02_c,att03,att03_c",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i009_set_no_entry_b(p_cmd)
  DEFINE p_cmd     LIKE type_file.chr1
  DEFINE l_field   LIKE type_file.chr1000
 
   LET l_field = 'att00,att02,att02_c,att03,att03_c'
   
    IF p_cmd = 'u' THEN 
       CALL cl_set_comp_entry(l_field,FALSE)
    END IF
 
END FUNCTION

#FUN-910088---add---start
FUNCTION i009_obj05_check()  
#obj05的单位obj07

   IF NOT cl_null(g_obj[l_ac].obj07) AND NOT cl_null(g_obj[l_ac].obj05) THEN
      IF cl_null(g_obj_t.obj05) OR cl_null(g_obj07_t) OR g_obj_t.obj05 != g_obj[l_ac].obj05 OR g_obj07_t != g_obj[l_ac].obj07 THEN 
         LET g_obj[l_ac].obj05=s_digqty(g_obj[l_ac].obj05, g_obj[l_ac].obj07)
         DISPLAY BY NAME g_obj[l_ac].obj05  
      END IF  
   END IF

   IF NOT cl_null(g_obj[l_ac].obj05) THEN
      IF g_obj[l_ac].obj05 != g_obj_t.obj05
         OR g_obj_t.obj05 IS NULL THEN
         IF g_obj[l_ac].obj05<=0 THEN
            CALL cl_err('','aim-223',0)
            RETURN FALSE
         END IF 
         LET g_obj[l_ac].obj06=g_obj[l_ac].obj04*g_obj[l_ac].obj05
         LET g_obj[l_ac].obj06 = s_digqty(g_obj[l_ac].obj06,g_obj[l_ac].obj07)     
      END IF
    END IF
    RETURN TRUE
END FUNCTION

FUNCTION i009_obj06_check()  
#obj06的单位obj07

   IF NOT cl_null(g_obj[l_ac].obj07) AND NOT cl_null(g_obj[l_ac].obj06) THEN
      IF cl_null(g_obj_t.obj06) OR cl_null(g_obj07_t) OR g_obj_t.obj06 != g_obj[l_ac].obj06 OR g_obj07_t != g_obj[l_ac].obj07 THEN 
         LET g_obj[l_ac].obj06=s_digqty(g_obj[l_ac].obj06, g_obj[l_ac].obj07)
         DISPLAY BY NAME g_obj[l_ac].obj06  
      END IF  
   END IF

   IF NOT cl_null(g_obj[l_ac].obj06) THEN
              IF g_obj[l_ac].obj06 != g_obj_t.obj06
                 OR g_obj_t.obj06 IS NULL THEN
                 IF g_obj[l_ac].obj06<0 THEN
                    CALL cl_err('','aim-223',0)
                    RETURN FALSE
                 END IF 
              END IF
   END IF
   RETURN TRUE
END FUNCTION
#FUN-910088---add---end
#No.FUN-9C0072 精簡程式碼 
