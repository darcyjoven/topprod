# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimt837.4gl
# Descriptions...: 複盤adjust作業－在製工單
# Date & Author..: 93/06/14 By Apple
# Modify.........: No.FUN-550029 05/05/30 By vivien 單據編號格式放大
# Modify.........: No.FUN-570035 05/07/05 By kim 修改快速輸入的方式
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-640213 06/07/14 By rainy 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-670093 06/07/27 By kim GP3.5 利潤中心
# Modify.........: No.FUN-690026 06/09/12 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690022 06/09/15 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.TQC-860018 08/06/09 By Smapmin 增加on idle控管
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60092 10/07/23 By lilingyu 平行工藝
# Modify.........: No.FUN-AA0059 10/10/28 By huangtao 修改料號的管控
# Modify.........: No.FUN-AA0059 10/10/29 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No.FUN-910088 11/12/13 By chenjing 增加數量欄位小數取位
# Modify.........: No.FUN-C20068 12/02/13 By fengrui 數量欄位小數取位處理
# Modify.........: No.FUN-CB0087 12/12/17 By xianghui 庫存單據理由碼改善
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_pid           RECORD LIKE pid_file.*,
    g_pie           RECORD LIKE pie_file.*,
    g_pid_t         RECORD LIKE pid_file.*,
    g_pie_t         RECORD LIKE pie_file.*,
    g_pid_o         RECORD LIKE pid_file.*,
    g_pie_o         RECORD LIKE pie_file.*,
    g_pid01_t       LIKE pid_file.pid01,
    g_ima25         LIKE ima_file.ima25,
    g_wc,g_sql      string,                 #No.FUN-580092 HCN
    g_qty           LIKE pie_file.pie50
DEFINE p_row,p_col         LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_forupd_sql        STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_cnt               LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_msg               LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count         LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index        LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump              LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask           LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_sfb98             LIKE sfb_file.sfb98    #FUN-670093
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0074
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
    INITIALIZE g_pid.* TO NULL
    INITIALIZE g_pid_t.* TO NULL
    INITIALIZE g_pid_o.* TO NULL
    LET g_qty = NULL
 
    LET g_forupd_sql = "SELECT * FROM pie_file WHERE pie01 = ? AND pie07 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t837_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
       LET p_row = 3 LET p_col = 27
 
    OPEN WINDOW t837_w AT p_row,p_col
             WITH FORM "aim/42f/aimt837" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()

#FUN-A60092 --begin--
   IF g_sma.sma541 = 'Y' THEN 
      CALL cl_set_comp_visible("pie012,pie013",TRUE)
   ELSE
      CALL cl_set_comp_visible("pie012,pie013",FALSE)
   END IF 	
#FUN-A60092 --end--
    IF g_aza.aza115 ='Y' THEN                    #FUN-CB0087
       CALL cl_set_comp_required('pie70',TRUE)   #FUN-CB0087
    END IF                                       #FUN-CB0087

    CALL cl_set_comp_visible("sfb98,gem02",g_aaz.aaz90='Y')  #FUN-670093
 
    WHILE TRUE
      LET g_action_choice=""
      CALL t837_menu()
      IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE
 
    CLOSE WINDOW t837_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
END MAIN
 
FUNCTION t837_cs()
 DEFINE  l_str   LIKE ze_file.ze03,     #No.FUN-690026 VARCHAR(70)
         l_code  LIKE type_file.num5    #No.FUN-690026 SMALLINT
 DEFINE  l_flag  LIKE type_file.chr1,   #FUN-CB0087
         l_where STRING                 #FUN-CB0087
 
    CLEAR FORM
    CALL cl_getmsg('mfg0126',g_lang) RETURNING l_str
    CALL cl_prompt(0,0,l_str) RETURNING l_code 
    INITIALIZE g_pid.* TO NULL    #FUN-640213 add
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        pid01, pie07, pid02, pid03, pie05, 
        pie012,pie013,      #FUN-A60092 
        pie03, pie02,pie70      #FUN-CB0087 add pie70
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp                                                      
           CASE                                                                 
               WHEN INFIELD(pid03) #生產料件                                    
#FUN-AA0059 --Begin--
                #  CALL cl_init_qry_var()                                        
                #  LET g_qryparam.state    = "c"                                 
                #  LET g_qryparam.form     ="q_ima"                              
                #  LET g_qryparam.default1 = g_pid.pid03                         
#               #  CALL cl_create_qry() RETURNING g_pid.pid03                    
#               #  DISPLAY BY NAME g_pid.pid03                                   
                #  CALL cl_create_qry() RETURNING g_qryparam.multiret            
                  CALL q_sel_ima( TRUE, "q_ima","",g_pid.pid03,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                  DISPLAY g_qryparam.multiret TO pid03 
                  CALL t837_part('d',g_pid.pid03,'1')                           
                  NEXT FIELD pid03                                              
               WHEN INFIELD(pie02) #盤點料件                                    
#FUN-AA0059 --Begin--
                #  CALL cl_init_qry_var()                                        
                #  LET g_qryparam.state    = "c"                                 
                #  LET g_qryparam.form     ="q_ima"                              
                #  LET g_qryparam.default1 = g_pie.pie02                         
#               #  CALL cl_create_qry() RETURNING g_pie.pie02                    
#               #  DISPLAY BY NAME g_pie.pie02                                   
                #  CALL cl_create_qry() RETURNING g_qryparam.multiret            
                  CALL q_sel_ima( TRUE, "q_ima","",g_pie.pie02,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                  DISPLAY g_qryparam.multiret TO pie02  
                  CALL t837_part('d',g_pie.pie02,'2')    
                  NEXT FIELD pie02      

#FUN-A60092 --begin--
               WHEN INFIELD(pie012)                             
                  CALL cl_init_qry_var()                                        
                  LET g_qryparam.state    = "c"                                 
                  LET g_qryparam.form     ="q_pie012"                              
                  LET g_qryparam.default1 = g_pie.pie012                               
                  CALL cl_create_qry() RETURNING g_qryparam.multiret            
                  DISPLAY g_qryparam.multiret TO pie012
                  NEXT FIELD pie012
#FUN-A60092 --end--
               #FUN-CB0087---add---str---
               WHEN INFIELD(pie70) #理由
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     ="q_azf41"
                  LET g_qryparam.default1 = g_pie.pie70
                  CALL cl_create_qry() RETURNING g_pie.pie70
                  DISPLAY BY NAME g_pie.pie70
                  CALL t837_azf03()
                  NEXT FIELD pie70
               #FUN-CB0087---add---end---
                                                          
               OTHERWISE EXIT CASE                                              
            END CASE       
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
       
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
       END CONSTRUCT
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
    IF INT_FLAG THEN RETURN END IF
 
    LET g_sql="SELECT pie_file.pie01,pie07 ",
              " FROM pid_file,pie_file ",
              " WHERE pid01=pie01 ",
              "   AND (pie02 IS NOT NULL AND pie02 != ' ' ) ",
              "   AND (pie50 IS NOT NULL OR pie60 IS NOT NULL) ",
              " AND  ",g_wc CLIPPED
 
    IF l_code THEN 
       LET g_sql = g_sql clipped,
                  " AND (pie50 != pie60 OR pie50 IS NULL OR pie60 IS NULL)",
                   " ORDER BY pie01,pie07 "
    ELSE  LET g_sql = g_sql clipped, " ORDER BY pie01,pie07"
    END IF
 
    PREPARE t837_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t837_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t837_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM pie_file WHERE ",g_wc CLIPPED,
              "   AND (pie02 IS NOT NULL AND pie02 != ' ' ) ",
              "   AND (pie50 IS NOT NULL OR pie60 IS NOT NULL) "
    PREPARE t837_precount FROM g_sql
    DECLARE t837_count CURSOR FOR t837_precount
END FUNCTION
 
FUNCTION t837_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION quick_input 
            LET g_action_choice="quick_input"
            IF cl_chk_act_auth() THEN
                 CALL t837_a()
            END IF
        ON ACTION query 
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL t837_q()
            END IF
        ON ACTION next 
            CALL t837_fetch('N') 
        ON ACTION previous 
            CALL t837_fetch('P')
        ON ACTION adjust 
            CALL t837_u()
        ON ACTION help 
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#           EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL t837_fetch('/')
        ON ACTION first
            CALL t837_fetch('F')
        ON ACTION last
            CALL t837_fetch('L')

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
    END MENU
    CLOSE t837_cs
END FUNCTION
 
   
#quick_input     
FUNCTION t837_a()
  DEFINE l_msg1,l_msg2  LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(70)
  DEFINE l_flag         LIKE type_file.num5    #FUN-570035  #No.FUN-690026 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                      # 清螢墓欄位內容
    INITIALIZE g_pid.* LIKE pid_file.*
    LET g_pid01_t = NULL
    LET g_qty = NULL
    LET l_msg1 = 'Del:登錄結束,<^F>:欄位說明'
    LET l_msg2=  '↑↓←→:移動游標, <^A>:插字,<^X>:消字'
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       MESSAGE l_msg1,l_msg2
   ELSE
       DISPLAY l_msg1 AT 1,1 
       DISPLAY l_msg2 AT 2,1 
   END IF
    WHILE TRUE
        CLEAR FORM 
        INITIALIZE g_pid.* LIKE pid_file.*
        INITIALIZE g_pie.* LIKE pie_file.*
        LET g_qty  = NULL
        #FUN-570035................begin
        IF (NOT l_flag) AND (g_curs_index<g_row_count) THEN
           CALL t837_fetch('N')
        END IF
        LET l_flag=FALSE
        LET g_pid.pid01 = g_pie_t.pie01
        LET g_pie.pie07 = g_pie_t.pie07
       #LET g_pid.pid01 = g_pie_t.pie01
        #FUN-570035................end
        CALL t837_i("a")                            # 各欄位輸入
        IF INT_FLAG THEN                            # 若按了DEL鍵
            LET INT_FLAG = 0
            CLEAR FORM 
            INITIALIZE g_pid.* LIKE pid_file.*
            INITIALIZE g_pie.* LIKE pie_file.*
            EXIT WHILE
        END IF
        IF g_pid.pid01 IS NULL OR g_qty IS NULL 
        THEN CONTINUE WHILE
        END IF
        IF g_pid.pid03 IS NULL THEN LET g_pid.pid03 = ' ' END IF
        IF g_pid.pid04 IS NULL THEN LET g_pid.pid04 = ' ' END IF
        IF g_pid.pid05 IS NULL THEN LET g_pid.pid05 = ' ' END IF
        LET g_pie.pie50 = g_qty
        LET g_pie.pie60 = g_qty
        UPDATE pie_file SET pie_file.* = g_pie.*    # 更新DB
            WHERE pie01=g_pie_t.pie01 AND pie07=g_pie_t.pie07              # COLAUTH?
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_pie.pie01,SQLCA.sqlcode,0) #No.FUN-660156
           CALL cl_err3("upd","pie_file",g_pie_t.pie01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
           CONTINUE WHILE
        END IF
        LET g_pie_t.* = g_pie.*                # 保存上筆資料
        #FUN-570035................begin
        #已經編輯完最後一筆
        IF (g_curs_index>=g_row_count) THEN
           EXIT WHILE
        END IF
        #FUN-570035................end
    END WHILE
END FUNCTION
 
FUNCTION t837_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_flag          LIKE type_file.chr1,    #判斷必要欄位是否有輸入  #No.FUN-690026 VARCHAR(1)
	l_direct        LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
	l_sw            LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_n             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_where         STRING,                 #FUN-CB0087
        l_sql           STRING                  #FUN-CB0087
 
    
    INPUT g_pid.pid01,g_pie.pie07,g_pid.pid03,
          g_pid.pid02,g_pie.pie05,g_pie.pie02,
          g_pie.pie03,g_pie.pie60,g_qty,g_pie.pie70   #FUN-CB0087  g_pie.pie70
          WITHOUT DEFAULTS 
      FROM pid01,pie07,pid03,
           pid02,pie05,pie02,pie03,pie60,
           qty,pie70                                  #FUN-CB0087 pie70
 
      BEFORE INPUT                                                              
         LET g_before_input_done = FALSE                                        
         CALL i110_set_entry(p_cmd)                                             
         CALL i110_set_no_entry(p_cmd)                                          
         LET g_before_input_done = TRUE   
        #No.FUN-550029 --start--
         CALL cl_set_docno_format("pid02")
        #No.FUN-550029 --end--  
 
#        BEFORE FIELD pid01
#           IF p_cmd = 'u' THEN NEXT FIELD qty  END IF
 
        AFTER FIELD pid01 
           IF g_pid.pid01 IS NOT NULL OR g_pid.pid01 != ' ' THEN
                CALL t837_pid01('d')
                IF NOT cl_null(g_errno)  THEN 
                   CALL cl_err(g_pid.pid01,'mfg0114',0)
                   NEXT FIELD pid01
                END IF
                LET g_pid_o.pid02 = g_pid.pid02
           END IF
           LET l_direct = 'D'
{
        BEFORE FIELD pie07
	   	   IF g_pid_o.pid02 IS NOT NULL AND g_pid_o.pid02 !=' ' THEN 
			  LET l_sw='N'
			  NEXT FIELD qty  
		   END IF
		   LET l_sw='Y'
}
        AFTER FIELD pie07    #項次
           IF g_pie.pie07 <=0
           THEN NEXT FIELD pie07
           END IF
           IF g_pie_o.pie07 IS NULL OR 
               (g_pie_o.pie07 != g_pie.pie07) 
           THEN CALL t837_pie07('a')
                IF NOT cl_null(g_errno)  THEN 
                   CALL cl_err(g_pie.pie07,g_errno,0)
                   LET g_pie.pie07 = g_pie_o.pie07
                   DISPLAY BY NAME g_pie.pie07 
                   NEXT FIELD pie07
                END IF
           END IF
           NEXT FIELD qty
 
        BEFORE FIELD pid03
	       IF g_sma.sma60 = 'Y'		# 若須分段輸入
	          THEN CALL s_inp5(7,33,g_pid.pid03) RETURNING g_pid.pid03
	               DISPLAY BY NAME g_pid.pid03 
                   IF INT_FLAG THEN LET INT_FLAG = 0 END IF
      	   END IF
 
        AFTER FIELD pid03      #生產料件編號
#FUN-AA0059 ---------------------start----------------------------
            IF NOT cl_null(g_pid.pid03) THEN
               IF NOT s_chk_item_no(g_pid.pid03,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_pid.pid03= g_pid_t.pid03
                  NEXT FIELD pid03
               END IF
            END IF
#FUN-AA0059 ---------------------end-------------------------------
            IF g_pid.pid03 <= 0 THEN
                NEXT FIELD pid03
            END IF
            IF g_pid_o.pid03 IS NULL OR 
                (g_pid_o.pid03 != g_pid.pid03) 
            THEN CALL t837_part('a',g_pid.pid03,'1')
                 IF NOT cl_null(g_errno)  THEN 
                    CALL cl_err(g_pid.pid03,g_errno,0)
                    LET g_pid.pid03 = g_pid_o.pid03
                    DISPLAY BY NAME g_pid.pid03 
                    NEXT FIELD pid03
                 END IF
            END IF
 
        AFTER FIELD pie02      #盤點料件
#FUN-AA0059 ---------------------start----------------------------
            IF NOT cl_null(g_pie.pie02) THEN
               IF NOT s_chk_item_no(g_pie.pie02,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_pie.pie02= g_pie_t.pie02
                  NEXT FIELD pie02
               END IF
            END IF
#FUN-AA0059 ---------------------end-------------------------------
            IF g_pie.pie02 <= 0 THEN
                NEXT FIELD pie02
            END IF
            IF g_pie_o.pie02 IS NULL OR (g_pie_o.pie02 != g_pie.pie02) 
            THEN CALL t837_part('a',g_pie.pie02,'2')
                 IF NOT cl_null(g_errno)  THEN 
                    CALL cl_err(g_pie.pie02,g_errno,0)
                    LET g_pie.pie02 = g_pie_o.pie02
                    DISPLAY BY NAME g_pie.pie02 
                    NEXT FIELD pie02
                 END IF
            END IF
 
        AFTER FIELD qty
            LET g_qty = s_digqty(g_qty,g_pid.pid04)   #FUN-910088--add--
            #DISPLAY BY NAME g_qty                    #FUN-910088--add--  #FUN-C20068 mark
            DISPLAY g_qty TO FORMONLY.qty             #FUN-C20068 add 
            IF g_qty < 0 THEN 
               NEXT FIELD qty
            END IF 
            LET l_direct = 'U'

        #FUN-CB0087--add---str----
        BEFORE FIELD pie70
           IF g_aza.aza115 = 'Y' AND cl_null(g_pie.pie70) THEN
              CALL s_reason_code(g_pie.pie01,g_pid.pid02,'',g_pid.pid03,'','','') RETURNING g_pie.pie70
              DISPLAY BY NAME g_pie.pie70
              CALL t837_azf03()
           END IF
        AFTER FIELD pie70
           IF NOT t837_pie70_chk() THEN
              NEXT FIELD pie70
           ELSE
              CALL t837_azf03()
           END IF
        #FUN-CB0087--add---end----
 
        AFTER INPUT
          IF g_pid.pid02 IS NULL THEN LET g_pid.pid02 = ' ' END IF
          IF g_pid.pid03 IS NULL THEN LET g_pid.pid03 = ' ' END IF
          LET l_flag='N'
          IF INT_FLAG THEN EXIT INPUT  END IF
          IF g_pid.pid02 IS NULL THEN
             LET l_flag='Y'
             DISPLAY BY NAME g_pid.pid02 
          END IF    
          IF l_flag='Y' THEN
             CALL cl_err('','9033',0)
             NEXT FIELD pid01
          END IF
          #FUN-CB0087--add---str----
          IF NOT t837_pie70_chk() THEN
             NEXT FIELD pie70
          END IF
          #FUN-CB0087--add---end----
 
        ON ACTION controlp                                                      
           CASE                                                                 
               WHEN INFIELD(pid03) #生產料件                                    
#FUN-AA0059 --Begin--
               #   CALL cl_init_qry_var()                                        
               #   LET g_qryparam.form     ="q_ima"                              
               #   LET g_qryparam.default1 = g_pid.pid03                         
               #   CALL cl_create_qry() RETURNING g_pid.pid03                    
                  CALL q_sel_ima(FALSE, "q_ima", "", g_pid.pid03, "", "", "", "" ,"",'' )  RETURNING g_pid.pid03
#FUN-AA0059 --End--
                  DISPLAY BY NAME g_pid.pid03                                   
                                  CALL t837_part('d',g_pid.pid03,'1')           
                  NEXT FIELD pid03                                              
               WHEN INFIELD(pie02) #盤點料件                                    
#FUN-AA0059 --Begin--
               #   CALL cl_init_qry_var()                                        
               #   LET g_qryparam.form     ="q_ima"                              
               #   LET g_qryparam.default1 = g_pie.pie02                         
               #   CALL cl_create_qry() RETURNING g_pie.pie02                    
                  CALL q_sel_ima(FALSE, "q_ima", "", g_pie.pie02, "", "", "", "" ,"",'' )  RETURNING g_pie.pie02
#FUN-AA0059 --End--
                  DISPLAY BY NAME g_pie.pie02                                   
                  CALL t837_part('d',g_pie.pie02,'2')                           
                  NEXT FIELD pie02                                              
               #FUN-CB0087---add---str---
               WHEN INFIELD(pie70) #理由
                  CALL s_get_where(g_pie.pie01,g_pid.pid02,'',g_pid.pid03,'','','') RETURNING l_flag,l_where
                  IF l_flag AND g_aza.aza115 = 'Y' THEN
                     CALL cl_init_qry_var()
                     LET g_qryparam.form  ="q_ggc08"
                     LET g_qryparam.where = l_where
                     LET g_qryparam.default1 = g_pie.pie70
                  ELSE
                      CALL cl_init_qry_var()
                      LET g_qryparam.form     ="q_azf41"
                      LET g_qryparam.default1 = g_pie.pie70
                  END IF
                  CALL cl_create_qry() RETURNING g_pie.pie70
                  DISPLAY BY NAME g_pie.pie70
                  CALL t837_azf03()
                  NEXT FIELD pie70
               #FUN-CB0087---add---end---
               OTHERWISE EXIT CASE                                              
            END CASE     
   
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        #-----TQC-860018---------
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
        
        ON ACTION about         
           CALL cl_about()      
        
        ON ACTION help          
           CALL cl_show_help()  
        #-----END TQC-860018-----
          
    END INPUT
END FUNCTION
   
FUNCTION i110_set_entry(p_cmd)                                                  
DEFINE   p_cmd   LIKE type_file.chr1                                                            #No.FUN-690026 VARCHAR(1)
                                                                                
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN                            
      CALL cl_set_comp_entry("pid01",TRUE)                                      
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i110_set_no_entry(p_cmd)                                               
DEFINE   p_cmd   LIKE type_file.chr1                                                            #No.FUN-690026 VARCHAR(1)
                                                                                
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN  
      CALL cl_set_comp_entry("pid01",FALSE)                                     
   END IF                                                                       
                                                                                
END FUNCTION     
 
FUNCTION t837_pid01(p_cmd)  
    DEFINE p_cmd	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_desc       LIKE ze_file.ze03,      #No.FUN-690026 VARCHAR(30)
           l_ima02      LIKE ima_file.ima02,
           l_sfb02      LIKE sfb_file.sfb02,
           l_imaacti    LIKE ima_file.imaacti
 
    LET g_errno = ' '
    SELECT pid_file.*, sfb02, ima02,imaacti,sfb98 ##FUN-670093 
      INTO g_pid.*,  l_sfb02, l_ima02,l_imaacti,g_sfb98 #FUN-670093
      FROM pid_file,sfb_file, OUTER ima_file
      WHERE pid01 = g_pid.pid01 AND pid_file.pid03=ima_file.ima01
         AND pid02= sfb01
 
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg0002' 
              LET g_pid.pid02  = NULL LET g_pid.pid03 = NULL
              LET l_ima02     = NULL LET l_imaacti   = NULL
    	WHEN l_imaacti='N' LET g_errno = '9028' 
      #FUN-690022------mod-------
        WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
      #FUN-690022------mod-------
	OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------' 
	END CASE
 
	IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY BY NAME g_pid.pid02,g_pid.pid03
       DISPLAY l_ima02 TO FORMONLY.ima02_1 
       CALL s_wotype(l_sfb02) RETURNING l_desc
       DISPLAY l_desc TO FORMONLY.desc 
       DISPLAY g_sfb98 TO sfb98 #FUN-670093
       DISPLAY s_costcenter_desc(g_sfb98) TO FORMONLY.gem02 #FUN-670093
    END IF
END FUNCTION
   
FUNCTION t837_pie07(p_cmd)  
    DEFINE p_cmd	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_ima02      LIKE ima_file.ima02
 
    LET g_errno = ' '
    SELECT pie_file.*,ima02
      INTO g_pie.*,l_ima02
      FROM pie_file ,OUTER ima_file
      WHERE pie01 = g_pid.pid01 AND pie07 = g_pie.pie07
        AND pie_file.pie02 = ima_file.ima01
 
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg0115' 
                                  LET l_ima02 = NULL
		OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------' 
	END CASE
	IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY BY NAME g_pie.pie02,g_pie.pie03,g_pie.pie05,
                       g_pie.pie50,g_pie.pie60
       DISPLAY g_pie.pie04 TO FORMONLY.pie04_1 
       DISPLAY g_pie.pie04 TO FORMONLY.pie04_2 
       DISPLAY g_pie.pie04 TO FORMONLY.unit 
       DISPLAY l_ima02 TO FORMONLY.ima02_2 
    END IF
END FUNCTION
   
FUNCTION t837_part(p_cmd,p_part,p_dis)  #料件編號
    DEFINE p_cmd	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           p_part       LIKE ima_file.ima01,
           p_dis        LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_ima02      LIKE ima_file.ima02,
           l_imaacti    LIKE ima_file.imaacti
 
    LET g_errno = ' '
	LET l_ima02=' '
    SELECT ima02,imaacti INTO l_ima02,l_imaacti
           FROM ima_file WHERE ima01 = p_part
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg0002' 
		        					LET l_ima02 = NULL 
    	WHEN l_imaacti='N' LET g_errno = '9028' 
      #FUN-690022------mod-------
        WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
      #FUN-690022------mod-------	
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------' 
	END CASE
	IF cl_null(g_errno) OR p_cmd = 'd' THEN
       IF p_dis = '1' THEN 
            DISPLAY l_ima02 TO FORMONLY.ima02_1 
       ELSE DISPLAY l_ima02 TO FORMONLY.ima02_2 
       END IF
    END IF
END FUNCTION
 
FUNCTION t837_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL t837_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t837_count
    FETCH t837_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    OPEN t837_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pid.pid01,SQLCA.sqlcode,0)
        INITIALIZE g_pid.* TO NULL
        LET g_qty = NULL
    ELSE
        CALL t837_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t837_fetch(p_flpid)
    DEFINE
        p_flpid          LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    CASE p_flpid
        WHEN 'N' FETCH NEXT     t837_cs INTO g_pid.pid01,
                                                         g_pie.pie07
        WHEN 'P' FETCH PREVIOUS t837_cs INTO g_pid.pid01,
                                                         g_pie.pie07
        WHEN 'F' FETCH FIRST    t837_cs INTO g_pid.pid01,
                                                         g_pie.pie07
        WHEN 'L' FETCH LAST     t837_cs INTO g_pid.pid01,
                                                         g_pie.pie07
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
                
                END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump t837_cs INTO g_pid.pid01,
                                                           g_pie.pie07
            LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pid.pid01,SQLCA.sqlcode,0)
        INITIALIZE g_pid.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flpid
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_pie.* FROM pie_file   # 重讀DB,因TEMP有不被更新特性
       WHERE pie01 = g_pid.pid01 AND pie07 = g_pie.pie07
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_pie.pie01,SQLCA.sqlcode,0) #No.FUN-660156
       CALL cl_err3("sel","pie_file",g_pie.pie01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
    ELSE
 
        CALL t837_show()                      # 重新顯示
    END IF
    SELECT * INTO g_pid.* FROM pid_file  
       WHERE pid01 = g_pie.pie01
END FUNCTION
 
FUNCTION t837_show()

    LET g_pid_t.* = g_pid.*
    LET g_pie_t.* = g_pie.*
    LET g_qty = NULL

    DISPLAY g_qty TO FORMONLY.qty 
    DISPLAY BY NAME 
        g_pid.pid01,g_pid.pid02,g_pid.pid03,
        g_pie.pie50,g_pie.pie60,g_pie.pie07,
        g_pie.pie05,g_pie.pie03,g_pie.pie02
       ,g_pie.pie012,g_pie.pie013,   #FUN-A60092 add
        g_pie.pie70            #FUN-CB0087
       
    DISPLAY g_pie.pie04 TO FORMONLY.pie04_1 
    DISPLAY g_pie.pie04 TO FORMONLY.pie04_2 
    DISPLAY g_pie.pie04 TO FORMONLY.unit 
 
    CALL t837_pid01('d')  
    CALL t837_azf03()         #FUN-CB0087
    CALL t837_part('d',g_pid.pid03,'1')
    CALL t837_part('d',g_pie.pie02,'2')
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t837_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_pid.pid01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_pid01_t = g_pid.pid01
    LET g_pid_o.*=g_pid.*   
    LET g_pie_o.*=g_pie.*   
    BEGIN WORK
 
    OPEN t837_cl USING g_pid.pid01,g_pie.pie07
    IF STATUS THEN
       CALL cl_err("OPEN t837_cl:", STATUS, 1)
       CLOSE t837_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t837_cl INTO g_pie.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pid.pid01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t837_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t837_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_pid.*=g_pid_t.*
            CALL t837_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_pie.pie50 = g_qty
        LET g_pie.pie60 = g_qty
        UPDATE pie_file SET pie_file.* = g_pie.*    # 更新DB
            WHERE pie01=g_pie_t.pie01 AND pie07=g_pie_t.pie07             # COLAUTH?
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_pie.pie01,SQLCA.sqlcode,0) #No.FUN-660156
           CALL cl_err3("upd","pie_file",g_pie_t.pie01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t837_cl
    COMMIT WORK
END FUNCTION
 
#FUN-CB0087-add-str--
FUNCTION t837_pie70_chk()
DEFINE  l_flag          LIKE type_file.chr1,
        l_n             LIKE type_file.num5,
        l_where         STRING,
        l_sql           STRING

   IF NOT cl_null(g_pie.pie70) THEN
      LET l_n = 0
      LET l_n = 0
      LET l_flag= FALSE
      IF g_aza.aza115 ='Y' THEN 
         CALL s_get_where(g_pie.pie01,g_pid.pid02,'',g_pid.pid03,'','','') RETURNING l_flag,l_where
      END IF
      IF g_aza.aza115='Y' AND l_flag THEN
         LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_pie.pie70,"' AND ",l_where
         PREPARE ggc08_pre FROM l_sql
         EXECUTE ggc08_pre INTO l_n
         IF l_n < 1 THEN
            CALL cl_err(g_pie.pie70,'aim-425',0)
            RETURN FALSE 
         END IF
      ELSE
         SELECT COUNT(*) INTO l_n FROM azf_file WHERE azf01=g_pie.pie70 AND azf02='2'
         IF l_n < 1 THEN
            CALL cl_err(g_pie.pie70,'aim-425',0)
            RETURN FALSE 
         END IF
      END IF
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t837_azf03()
DEFINE l_azf03  LIKE azf_file.azf03
   SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01=g_pie.pie70 AND azf02='2'
   DISPLAY l_azf03 TO azf03
END FUNCTION
#FUN-CB0087-add-end--
