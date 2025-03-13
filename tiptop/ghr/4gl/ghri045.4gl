# Prog. Version..: '5.30.05-13.01.08(00010)'     #
#
# Pattern name...: ghri045.4gl
# Descriptions...: 畫面元件顯示多語言設定作業
# Descriptions...: 员工出差信息维护作业
# Date & Author..: 13/06/06 By yeap1
# Date & Author..: 140815 By cqz 增加查询单身
# Date & Author..: 140820 By cqz 去掉 hrceconf = 'Y' 显示已撤销出差记录

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_hrce                 RECORD LIKE hrce_file.*,
       g_hrce_t               RECORD LIKE hrce_file.*,     #備份舊值
       g_hrce01_t             LIKE        hrce_file.hrce01,         #Key值備份
       g_hrce03_t             LIKE        hrce_file.hrce03,
       g_hrce08_t             LIKE        hrce_file.hrce08,
       g_hrce05_t             LIKE        hrce_file.hrce05,
       g_hrceb01              LIKE        hrceb_file.hrceb01,     #NO.130619
       g_hrcea01              LIKE        hrcea_file.hrcea01,
       g_hrcec01              LIKE        hrcec_file.hrcec01,
       g_hrce07_1             LIKE        hrce_file.hrce07,  #NO.130619
       g_hrce07_2             LIKE        hrce_file.hrce07,
       g_hrce07_3             LIKE        hrce_file.hrce07,
       g_hrce07_4             LIKE        hrce_file.hrce07,
       g_hrce_lock RECORD LIKE hrce_file.*,      # FOR LOCK CURSOR TOUCH
     g_hrcea   DYNAMIC ARRAY OF RECORD
        hrcea02      LIKE hrcea_file.hrcea02,
        hrcea13      LIKE hrcea_file.hrcea13,                     #NO.130619
        hrat02       LIKE hrat_file.hrat02,                       #NO.130619
        hrcea03      LIKE hrcea_file.hrcea03,
        hrcea04      LIKE hrcea_file.hrcea04,
        hrcea05      LIKE hrcea_file.hrcea05,
        hrcea06      LIKE hrcea_file.hrcea06,
        hrcea07      LIKE hrcea_file.hrcea07,
        hrcea08      LIKE hrcea_file.hrcea08,
        hrcea09      LIKE hrcea_file.hrcea09,
        hrcea10      LIKE hrcea_file.hrcea10,
        hrcea11      LIKE hrcea_file.hrcea11,
        hrcea12      LIKE hrcea_file.hrcea12
                    END RECORD,
     g_hrceb  DYNAMIC ARRAY OF RECORD
        hrceb02      LIKE hrceb_file.hrceb02,
        hrceb03      LIKE hrceb_file.hrceb03,
        hrat102      LIKE hrat_file.hrat02,
        hrao102      LIKE hrao_file.hrao02,
        hras104      LIKE hras_file.hras04,
        hrat125      LIKE hrat_file.hrat25,
        hrad03       LIKE hrad_file.hrad03,
        hrceb04      LIKE hrceb_file.hrceb04,
        hrat202      LIKE hrat_file.hrat02,
        hrao202      LIKE hrao_file.hrao02,
        hras204      LIKE hras_file.hras04,
        hrat225      LIKE hrat_file.hrat25,
        hrceb05      LIKE hrceb_file.hrceb05,
        hrao02       LIKE hrao_file.hrao02,
        hrceb06      LIKE hrceb_file.hrceb06
                    END RECORD,
     g_hrcec   DYNAMIC ARRAY OF RECORD
        hrcec02      LIKE type_file.num10,
        hrcec03      LIKE hrcec_file.hrcec03,
        hrcec04      LIKE hrcec_file.hrcec04,
        hrat02_1     LIKE hrat_file.hrat02,
        hrcec05      LIKE hrcec_file.hrcec05,
        hrcec06      LIKE hrcec_file.hrcec06,
        hrcec07      LIKE hrcec_file.hrcec07,
        hrcec08      LIKE hrcec_file.hrcec08,
        hrcec09      LIKE hrcec_file.hrcec09,
        hrcec10      LIKE hrcec_file.hrcec10,
        hrcec11      LIKE hrcec_file.hrcec11,
        hrcec12      LIKE hrcec_file.hrcec12,
        hrcec13      LIKE hrcec_file.hrcec13,
        hrcec14      LIKE hrcec_file.hrcec14,
        hrcec15      LIKE hrcec_file.hrcec15,
        hrcec16      LIKE hrcec_file.hrcec16
                    END RECORD, 
     g_hrce_1   DYNAMIC ARRAY OF RECORD
        sure         LIKE type_file.chr1,
        hrce01       LIKE hrce_file.hrce01,
        hrce02       LIKE hrce_file.hrce02,
        hrce03       LIKE hrce_file.hrce03,
        hrce04       LIKE hrce_file.hrce04,
        hrce05       LIKE hrce_file.hrce05,
        hrce06       LIKE hrce_file.hrce06,
        hrce07       LIKE hrce_file.hrce07,
        hrce08       LIKE hrce_file.hrce08,
        hrce09       LIKE hrce_file.hrce09,
        hrce10       LIKE hrce_file.hrce10,
        hrce12       LIKE hrce_file.hrce12,
        hrce11       LIKE hrce_file.hrce11,
        hrce13       LIKE hrce_file.hrce13,
        hrceacti     LIKE hrce_file.hrceacti
                    END RECORD, 
     g_hrcec_1  DYNAMIC ARRAY OF RECORD
        hrcec04       LIKE hrcec_file.hrcec04,
        hrcec16       LIKE hrcec_file.hrcec16
                    END RECORD,
     g_hrce_1_t       RECORD
        sure         LIKE type_file.chr1,
        hrce01       LIKE hrce_file.hrce01,
        hrce02       LIKE hrce_file.hrce02,
        hrce03       LIKE hrce_file.hrce03,
        hrce04       LIKE hrce_file.hrce04,
        hrce05       LIKE hrce_file.hrce05,
        hrce06       LIKE hrce_file.hrce06,
        hrce07       LIKE hrce_file.hrce07,
        hrce08       LIKE hrce_file.hrce08,
        hrce09       LIKE hrce_file.hrce09,
        hrce10       LIKE hrce_file.hrce10,
        hrce12       LIKE hrce_file.hrce12,
        hrce11       LIKE hrce_file.hrce11,
        hrce13       LIKE hrce_file.hrce13,
        hrceacti     LIKE hrce_file.hrceacti
                    END RECORD,
     g_hrcea_t          RECORD
        hrcea02      LIKE hrcea_file.hrcea02,
        hrcea13      LIKE hrcea_file.hrcea13,                     #NO.130619
        hrat02       LIKE hrat_file.hrat02,                       #NO.130619
        hrcea03      LIKE hrcea_file.hrcea03,
        hrcea04      LIKE hrcea_file.hrcea04,
        hrcea05      LIKE hrcea_file.hrcea05,
        hrcea06      LIKE hrcea_file.hrcea06,
        hrcea07      LIKE hrcea_file.hrcea07,
        hrcea08      LIKE hrcea_file.hrcea08,
        hrcea09      LIKE hrcea_file.hrcea09,
        hrcea10      LIKE hrcea_file.hrcea10,
        hrcea11      LIKE hrcea_file.hrcea11,
        hrcea12      LIKE hrcea_file.hrcea12
                    END RECORD,
     g_hrceb_t          RECORD
        hrceb02      LIKE hrceb_file.hrceb02,
        hrceb03      LIKE hrceb_file.hrceb03,
        hrat102      LIKE hrat_file.hrat02,
        hrao102      LIKE hrao_file.hrao02,
        hras104      LIKE hras_file.hras04,
        hrat125      LIKE hrat_file.hrat25,
        hrad03       LIKE hrad_file.hrad03,
        hrceb04      LIKE hrceb_file.hrceb04,
        hrat202      LIKE hrat_file.hrat02,
        hrao202      LIKE hrao_file.hrao02,
        hras204      LIKE hras_file.hras04,
        hrat225      LIKE hrat_file.hrat25,
        hrceb05      LIKE hrceb_file.hrceb05,
        hrao02       LIKE hrao_file.hrao02,
        hrceb06      LIKE hrceb_file.hrceb06
                    END RECORD,
     g_hrcec_t          RECORD
        hrcec02      LIKE type_file.num10,
        hrcec03      LIKE hrcec_file.hrcec03,
        hrcec04      LIKE hrcec_file.hrcec04,
        hrat02_1     LIKE hrat_file.hrat02,
        hrcec05      LIKE hrcec_file.hrcec05,
        hrcec06      LIKE hrcec_file.hrcec06,
        hrcec07      LIKE hrcec_file.hrcec07,
        hrcec08      LIKE hrcec_file.hrcec08,
        hrcec09      LIKE hrcec_file.hrcec09,
        hrcec10      LIKE hrcec_file.hrcec10,
        hrcec11      LIKE hrcec_file.hrcec11,
        hrcec12      LIKE hrcec_file.hrcec12,
        hrcec13      LIKE hrcec_file.hrcec13,
        hrcec14      LIKE hrcec_file.hrcec14,
        hrcec15      LIKE hrcec_file.hrcec15,
        hrcec16      LIKE hrcec_file.hrcec16
                    END RECORD, 
         g_cnt2                LIKE type_file.num5,    #FUN-680135 SMALLINT
         g_wc                  STRING,  #No.FUN-580092 HCN
         g_wc2                 STRING,
         g_wc3                 STRING,
         g_sql                STRING,  #No.FUN-580092 HCN
         g_sql1                STRING,  #No.FUN-580092 HCN
         g_sql2                STRING,  #No.FUN-580092 HCN
         g_sql3                STRING,  #No.FUN-580092 HCN
         g_ss                  LIKE type_file.chr1,    # 決定後續步驟 #No.FUN-680135 VARCHAR(1)
         g_rec_b1              LIKE type_file.num5,    # 單身筆數     #No.FUN-680135 SMALLINT
         g_rec_b2              LIKE type_file.num5,    # 單身筆數     #No.FUN-680135 SMALLINT
         g_rec_b3              LIKE type_file.num5,    # 單身筆數     #No.FUN-680135 SMALLINT
         l_ac                  LIKE type_file.num5,
         l_ac1                 LIKE type_file.num5,     # 目前處理的ARRAY CNT  #No.FUN-680135 SMALLINT
         l_ac2                 LIKE type_file.num5,
         l_chk_time1           LIKE type_file.num10,#NO.130619
         g_hrag          RECORD LIKE hrag_file.*,  #NO.130705
         g_number1             LIKE type_file.num5,
         g_number2             LIKE type_file.num5,
         g_number3             LIKE type_file.num5,
         g_number4             LIKE type_file.num5,
         g_i                   LIKE type_file.num5,
         g_i1                   LIKE type_file.num5,
         l_ac3                 LIKE type_file.num5,
         g_h1,g_m1,g_h2,g_m2,g_sum_m1,g_sum_m2    LIKE type_file.num5,#NO.130619
         g_h11,g_h12,g_m11,g_m12                  LIKE type_file.num5,#NO.130624
         g_h21,g_h22,g_m21,g_m22                  LIKE type_file.num5 #NO.130624
DEFINE   g_chr                  LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
DEFINE   g_cnt                  LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_cnt0                 LIKE type_file.num10 
DEFINE   g_cnt1                 LIKE type_file.num10 
DEFINE   g_msg                 LIKE type_file.chr1000  #No.FUN-680135 VARCHAR(72)
DEFINE   g_forupd_sql         STRING
DEFINE   g_before_input_done   LIKE type_file.num5     #No.FUN-680135 SMALLINT
DEFINE   g_argv1               LIKE hrce_file.hrce01
DEFINE   g_curs_index          LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_row_count           LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_jump                LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_no_ask              LIKE type_file.num5     #No.FUN-680135 SMALLINT #No.FUN-6A0080
DEFINE   g_db_type             LIKE type_file.chr3     #No.FUN-760049
DEFINE   g_hrbm                RECORD LIKE hrbm_file.*
DEFINE   g_chr2                LIKE type_file.chr1    #No.130618
DEFINE   g_sum                 LIKE type_file.num10    #No.130807 added by yeap 用来计算单头费用总计
DEFINE   g_flag                LIKE type_file.chr1 
DEFINE   g_bp_flag             LIKE type_file.chr10
DEFINE   g_action_flag         LIKE type_file.chr1

MAIN #gai
 
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                # 擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0096
   INITIALIZE g_hrce.* TO NULL
 
 
   OPEN WINDOW i045_w WITH FORM "ghr/42f/ghri045"
     ATTRIBUTE(STYLE=g_win_style CLIPPED)
   CALL cl_ui_init()
  
   LET g_forupd_sql =" SELECT * FROM hrce_file ",  
                      "  WHERE hrce01 = ? ",  #No.FUN-710055
                      " FOR UPDATE NOWAIT"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i045_lock_u CURSOR FROM g_forupd_sql
 
   IF NOT cl_null(g_argv1) THEN
      CALL i045_q()
      CALL i045_b_fill_1(g_wc)   #added by yeap NO.130828
     ELSE 
     LET g_flag = 'N'  # add by cqz 140815  
   END IF
   
   LET g_action_choice = "" 
  # LET g_wc = '1=1' CALL i045_b_fill_1(g_wc)
   CALL cl_set_comp_visible('sure,hrce01',FALSE)
   CALL i045_menu() 
 
   CLOSE WINDOW i045_w                       # 結束畫面
     CALL  cl_used(g_prog,g_time,2)             # 計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
END MAIN
 
FUNCTION i045_curs() #gai                        # QBE 查詢資料
   CLEAR FORM                                    # 清除畫面
   CALL g_hrceb.clear()
   CALL g_hrcea.clear()
   CALL g_hrcec.clear()
 
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = "hrce01 = '",g_argv1 CLIPPED,"' "
   ELSE  
      CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
      INITIALIZE g_hrce.* TO NULL
 
      CONSTRUCT g_wc ON hrce02,hrce03,hrce04,hrce05,hrce06, # hrce07,hrce08,    marked by yeap NO.130909
                        hrce09,hrce10,hrce11,hrce12,hrce13,hrceconf,hrceacti
                   FROM hrce02,hrce03,hrce04,hrce05,hrce06, # hrce07,hrce08,    marked by yeap NO.130909
                        hrce09,hrce10,hrce11,hrce12,hrce13,hrceconf,hrceacti


    BEFORE CONSTRUCT
        CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
            	WHEN INFIELD(hrce02)
            	 CALL cl_init_qry_var()
                LET g_qryparam.form = "q_hrbm03"
                LET g_qryparam.arg1 = '005'
                LET g_qryparam.default1= g_hrce.hrce02
               CALL cl_create_qry() RETURNING g_hrce.hrce02
               DISPLAY BY NAME g_hrce.hrce02
               NEXT FIELD hrce02
                  
           WHEN INFIELD(hrceb03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrat"
              LET g_qryparam.default1 = g_hrceb[1].hrceb03
              CALL cl_create_qry() RETURNING g_hrceb[1].hrceb03
              DISPLAY BY NAME g_hrceb[1].hrceb03
              NEXT FIELD hrceb03
              
           WHEN INFIELD(hrceb04)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrat"
              LET g_qryparam.default1 = g_hrceb[1].hrceb04
              CALL cl_create_qry() RETURNING g_hrceb[1].hrceb04
              DISPLAY BY NAME g_hrceb[1].hrceb04
              NEXT FIELD hrceb04

           WHEN INFIELD(hrceb05)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrao01"
              LET g_qryparam.default1 = g_hrceb[1].hrceb05
              CALL cl_create_qry() RETURNING g_hrceb[1].hrceb05
              DISPLAY BY NAME g_hrceb[1].hrceb05
              NEXT FIELD hrceb05
 
               OTHERWISE
                  EXIT CASE
            END CASE
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
          ON ACTION help
             CALL cl_show_help()
          ON ACTION controlg
             CALL cl_cmdask()
          ON ACTION about
             CALL cl_about()
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrceuser', 'hrcegrup')
 
      IF INT_FLAG THEN RETURN END IF
   END IF

 # add by cqz 140815 begin ---
   IF g_flag = 'N' THEN
      CONSTRUCT g_wc3 ON hrceb03 
                    FROM s_hrceb[1].hrceb03
                    
		BEFORE CONSTRUCT
		    CALL cl_qbe_init()
            
      ON ACTION controlp
         CASE 
            WHEN INFIELD(hrceb03) 
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_gen"
               LET g_qryparam.state    = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrceb03
               NEXT FIELD hrceb03
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
   ELSE
      LET g_wc3 = " 1=1"
   END IF
 
    IF g_wc3 = " 1=1" THEN                 
       LET g_sql = "SELECT UNIQUE hrce01,hrce02 FROM hrce_file",
               " WHERE ",g_wc CLIPPED," ORDER BY hrce01"
    ELSE                             
       LET g_wc3 = cl_replace_str(g_wc3,"hrceb03","hrat01")
       LET g_sql = "SELECT UNIQUE hrce01,hrce02 FROM hrce_file,hrceb_file ,hrat_file",
                   " WHERE  hrce01=hrceb01 AND hrceb03=hratid AND ",g_wc CLIPPED," AND ",g_wc3 CLIPPED," ORDER BY hrce01"
                  
    END IF

 
 # add by cqz 140815 end ---
##mark by cqz 140815   LET g_sql = "SELECT UNIQUE hrce01,hrce02 FROM hrce_file",
##mark by cqz 140815                " WHERE ",g_wc CLIPPED," ORDER BY hrce01"
   PREPARE i045_prepare FROM g_sql          # 預備一下
   DECLARE i045_b_curs                      # 宣告成可捲動的
      SCROLL CURSOR WITH HOLD FOR i045_prepare

##mark by cqz 140815   LET g_sql = "SELECT COUNT(*) FROM hrce_file WHERE ",g_wc CLIPPED
   LET g_sql = "SELECT COUNT(*) FROM hrce_file,hrceb_file,hrat_file ",
               " WHERE  hrce01=hrceb01 AND hrceb03=hratid AND ",g_wc CLIPPED," AND ",g_wc3 CLIPPED," ORDER BY hrce01"  
   PREPARE i045_precount FROM g_sql
   DECLARE i045_count CURSOR FOR i045_precount
 
END FUNCTION
 
FUNCTION i045_b_menu()#gai

   WHILE TRUE
   	 
      CALL i045_bp("G")
      
      IF NOT cl_null(g_action_choice) AND l_ac>0 THEN #將清單的資料回傳到主畫面
         SELECT hrce_file.*
           INTO g_hrce.*
           FROM hrce_file
          WHERE hrce01=g_hrce_1[l_ac].hrce01
      END IF

      IF g_action_choice!= "" THEN
         LET g_bp_flag = 'Page1'
         LET l_ac = ARR_CURR()
         LET g_jump = l_ac
         LET g_no_ask = TRUE
         IF g_row_count >0 THEN
             CALL i045_fetch('/')
         END IF
         CALL cl_set_comp_visible("Page2", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("Page2", TRUE)
       END IF
 
      CASE g_action_choice
      	
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL i045_a()
            END IF
            EXIT WHILE
         WHEN "modify"                          # U.修改
            IF cl_chk_act_auth() THEN
               CALL i045_u()
            END IF
            EXIT WHILE
#         WHEN "reproduce"                       # C.複製
#            IF cl_chk_act_auth() THEN
#               CALL i045_copy()
#            END IF
         WHEN "delete"                          # R.取消
            IF cl_chk_act_auth() THEN
            CALL i045_r()
            END IF
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL i045_q()
               CALL i045_b_fill_1(g_wc)   #added by yeap NO.130828
            END IF
            EXIT WHILE
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i045_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"                            # H.求助
            CALL cl_show_help()
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
         WHEN "ghr_confirm"
            LET g_wc2 = g_wc CLIPPED ,"  AND hrceconf = 'N' " 
            CALL i045_b_fill_1(g_wc2)                       
            CALL i045_confirm('Y')
         WHEN "ghr_undo_confirm" 
            LET g_wc2 = g_wc CLIPPED ,"  AND hrceconf = 'Y' " 
            CALL i045_b_fill_1(g_wc2)                        
            CALL i045_confirm('N')
         WHEN "ghri045_a"
          #  LET g_msg='ghri045a "$FGLRUN $GHRi/ghri045a" '
          #  CALL cl_cmdrun_wait(g_msg)
            RUN "$FGLRUN $GHRi/ghri045a"
            CALL i045_show()
            CALL i045_b_fill_1(g_wc)   #added by yeap NO.130828
         WHEN "related_document"
            IF cl_chk_act_auth() THEN
              IF g_hrce.hrce01 IS NOT NULL THEN
                 LET g_doc.column1 = "hrce01"
                 LET g_doc.value1 = g_hrce.hrce01
                 CALL cl_doc()
              END IF
           END IF
         WHEN "exporttoexcel"     #FUN-4B0049
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrce),'','')
            END IF
         WHEN "generate_link" 
            CALL cl_generate_shortcut()
            
         OTHERWISE
            EXIT WHILE
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i045_a()   #gai                         # Add  輸入
   MESSAGE ""
   CLEAR FORM
   INITIALIZE g_hrce.* TO NULL
   CALL g_hrcea.clear()
   CALL g_hrceb.clear()
   CALL g_hrcec.clear()
 
   INITIALIZE g_hrce.hrce01 LIKE hrce_file.hrce01         # 預設值及將數值類變數清成零
   
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_hrce.hrce03 = g_today
      LET g_hrce.hrce05 = g_today
      LET g_hrce.hrce04 = "00:00"   #NO.130624
      LET g_hrce.hrce06 = "00:00"
      LET g_hrce.hrce09 = NULL 
      LET g_hrce.hrceacti = "Y"
      LET g_hrce.hrceconf = "N"
      LET g_hrce.hrceuser = g_user
      LET g_hrce.hrcegrup = g_grup
      LET g_sum = 0      #added by yeap NO.130807
      CALL i045_i("a")                       # 輸入單頭
 
      IF INT_FLAG THEN  
         INITIALIZE g_hrce.* TO NULL      
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b1 = 0
      LET g_rec_b2 = 0
      LET g_rec_b3 = 0
 
 
      IF g_ss='N' THEN
         INITIALIZE g_hrce.* TO NULL
      ELSE
         INSERT INTO hrce_file VALUES(g_hrce.*)
         CALL i045_b_fill('1=1')             # 單身
      END IF

      CALL i045_b()                          # 輸入單身
      LET g_hrce01_t=g_hrce.hrce01
      LET g_hrce.hrce12 = g_sum              #added by yeap NO.130807
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION i045_i(p_cmd)#gai                       # 處理INPUT
 
   DEFINE   p_cmd        LIKE type_file.chr1    # a:輸入 u:更改  #No.FUN-680135 VARCHAR(1)
   DEFINE   l_count      LIKE type_file.num5    #FUN-680135 SMALLINT
   DEFINE   l_input      LIKE type_file.chr1
   DEFINE   l_s          VARCHAR(20)
   DEFINE   l_dd         VARCHAR(20)
   DEFINE   l_sql        STRING
   DEFINE   l_time       LIKE hrce_file.hrce07
   DEFINE   l_time1      LIKE type_file.num5
   DEFINE   l_cnt        LIKE type_file.num10
   DEFINE   l_hrce07     LIKE hrce_file.hrce07
   
 
   LET g_ss = 'Y'

  DISPLAY   g_hrce.hrce02,g_hrce.hrce03,g_hrce.hrce04,g_hrce.hrce05,
            g_hrce.hrce06,  # g_hrce.hrce07,g_hrce.hrce08,  marked by yeap NO.130909
            g_hrce.hrce09,
            g_hrce.hrce10,g_hrce.hrce11,g_hrce.hrce12,g_hrce.hrce13,
            g_hrce.hrceacti,g_hrce.hrceuser,g_hrce.hrcegrup,
            g_hrce.hrcemodu,g_hrce.hrcedate,g_hrce.hrceoriu,g_hrce.hrceorig
       TO   hrce02,hrce03,hrce04,hrce05,hrce06,# hrce07,hrce08,marked by yeap NO.130909
            hrce09,hrce10,hrce11,hrce12,hrce13,hrceacti,hrceuser,hrcegrup,
            hrcemodu,hrcedate,hrceoriu,hrceorig

      CALL cl_set_head_visible("","YES")
 
   INPUT  g_hrce.hrce02,g_hrce.hrce10,g_hrce.hrce03,g_hrce.hrce04,
          g_hrce.hrce05,g_hrce.hrce06,# g_hrce.hrce07,g_hrce.hrce08, marked by yeap NO.130909
          g_hrce.hrce09,g_hrce.hrce11,g_hrce.hrce12,g_hrce.hrce13
          WITHOUT DEFAULTS 
    FROM  hrce02,hrce10,hrce03,hrce04,hrce05,hrce06, # hrce07,hrce08, marked by yeap NO.130909
          hrce09,hrce11,hrce12,hrce13
          
      BEFORE INPUT
         LET l_input='N'
         LET g_before_input_done = FALSE
         CALL i045_set_entry(p_cmd)
         CALL i045_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         LET l_hrce07 = g_hrce.hrce07

      AFTER FIELD hrce02
         IF g_hrce.hrce02 IS  NULL THEN
            NEXT FIELD hrce02
       ELSE 
            CALL i045_hrce02('a')
        END IF

      AFTER FIELD hrce04                      #NO.130624
         IF NOT cl_null(g_hrce.hrce04) THEN
            LET  g_h1 = g_hrce.hrce04[1,2]
            LET  g_m1 = g_hrce.hrce04[4,5]
            LET  g_h2 = g_hrce.hrce06[1,2]
            LET  g_m2 = g_hrce.hrce06[4,5]
            LET  g_h11 = g_hrce.hrce04[1]
            LET  g_h12 = g_hrce.hrce04[2]
            LET  g_m11 = g_hrce.hrce04[4]
            LET  g_m12 = g_hrce.hrce04[5]
            LET  g_h21 = g_hrce.hrce06[1]
            LET  g_h22 = g_hrce.hrce06[2]
            LET  g_m21 = g_hrce.hrce06[4]
            LET  g_m22 = g_hrce.hrce06[5]
            
            IF cl_null(g_h1) OR cl_null(g_m1) OR g_h1>24 OR g_m1>=60 THEN
               CALL cl_err(g_hrce.hrce04,'asf-807',0)
               NEXT FIELD hrce04
            END IF
            IF cl_null(g_h11) OR cl_null(g_h12) OR cl_null(g_m11) OR cl_null(g_m12) THEN
               CALL cl_err(g_hrce.hrce04,'ghr-104',0)
               NEXT FIELD hrce04
            END IF 
            IF cl_null(g_h2) OR cl_null(g_m2) OR g_h2>24 OR g_m2>=60 THEN
               CALL cl_err(g_hrce.hrce06,'asf-807',0)
               NEXT FIELD hrce06
            END IF
            IF cl_null(g_h21) OR cl_null(g_h22) OR cl_null(g_m21) OR cl_null(g_m22) THEN
               CALL cl_err(g_hrce.hrce06,'ghr-104',0)
               NEXT FIELD hrce06
            END IF
           IF g_hrce.hrce08 = "001" THEN 
              LET g_sum_m1 = g_h1/24 +g_m1/24/60
              LET g_sum_m2 = g_h2/24 +g_m2/24/60
              LET l_chk_time1 = (g_hrce.hrce05-g_hrce.hrce03)+ (g_sum_m2-g_sum_m1)
               IF l_chk_time1<0 THEN
                  CALL cl_err('','ghr-102',1)
                  NEXT FIELD hrce04
              END IF
              IF cl_null(g_hrce.hrce07) OR g_hrce.hrce07 = "0.00" OR l_chk_time1 != l_hrce07  THEN
                 LET g_hrce.hrce07 = l_chk_time1 + 1
                 LET g_hrce07_1 = l_chk_time1
                # DISPLAY BY NAME  g_hrce.hrce07
              END IF 
           END IF
           IF g_hrce.hrce08 = "002" THEN 
              LET g_sum_m1 = g_h1/24 +g_m1/24/60
              LET g_sum_m2 = g_h2/24 +g_m2/24/60
              LET l_chk_time1 = (g_hrce.hrce05-g_hrce.hrce03)+ (g_sum_m2-g_sum_m1)
               IF l_chk_time1<0 THEN
                  CALL cl_err('','ghr-102',1)
                  NEXT FIELD hrce04
              END IF
              IF cl_null(g_hrce.hrce07) OR g_hrce.hrce07 = "0.00" OR l_chk_time1 != l_hrce07  THEN
                 LET g_hrce.hrce07 = (l_chk_time1 + 1)*2
                 LET g_hrce07_4 = l_chk_time1
               #  DISPLAY BY NAME  g_hrce.hrce07
              END IF 
           END IF 
           IF g_hrce.hrce08 = "003" THEN 
              LET g_sum_m1 = g_h1 +g_m1/24
              LET g_sum_m2 = g_h2 +g_m2/24
              LET l_chk_time1 = (g_hrce.hrce05-g_hrce.hrce03)*24+ (g_sum_m2-g_sum_m1)
               IF l_chk_time1<0 THEN
                  CALL cl_err('','ghr-102',1)
                  NEXT FIELD hrce04
              END IF
              IF cl_null(g_hrce.hrce07) OR g_hrce.hrce07 = "0.00" OR l_chk_time1 != l_hrce07   THEN
                 LET g_hrce.hrce07 = l_chk_time1  
                 LET g_hrce07_2 = l_chk_time1
               #  DISPLAY BY NAME  g_hrce.hrce07
              END IF 
            END IF
           IF g_hrce.hrce08 = "004" THEN 
              LET g_sum_m1 = g_h1*60 + g_m1
              LET g_sum_m2 = g_h2*60 + g_m2
              LET l_chk_time1 = (g_hrce.hrce05-g_hrce.hrce03)* 24 * 60 + (g_sum_m2-g_sum_m1)
               IF l_chk_time1<0 THEN
                  CALL cl_err('','ghr-102',1)
                  NEXT FIELD hrce04
              END IF
              IF cl_null(g_hrce.hrce07) OR g_hrce.hrce07 = "0.00" OR l_chk_time1 != l_hrce07 THEN 
                 LET g_hrce.hrce07 = l_chk_time1  
                 LET g_hrce07_3 = l_chk_time1 
                # DISPLAY BY NAME  g_hrce.hrce07
              END IF 
           END IF 
        END IF

        AFTER FIELD hrce05                      #NO.130624
         IF NOT cl_null(g_hrce.hrce05) THEN
            LET  g_h1 = g_hrce.hrce04[1,2]
            LET  g_m1 = g_hrce.hrce04[4,5]
            LET  g_h2 = g_hrce.hrce06[1,2]
            LET  g_m2 = g_hrce.hrce06[4,5]
            LET  g_h11 = g_hrce.hrce04[1]
            LET  g_h12 = g_hrce.hrce04[2]
            LET  g_m11 = g_hrce.hrce04[4]
            LET  g_m12 = g_hrce.hrce04[5]
            LET  g_h21 = g_hrce.hrce06[1]
            LET  g_h22 = g_hrce.hrce06[2]
            LET  g_m21 = g_hrce.hrce06[4]
            LET  g_m22 = g_hrce.hrce06[5]
            
            IF cl_null(g_h1) OR cl_null(g_m1) OR g_h1>24 OR g_m1>=60 THEN
               CALL cl_err(g_hrce.hrce04,'asf-807',0)
               NEXT FIELD hrce04
            END IF
            IF cl_null(g_h11) OR cl_null(g_h12) OR cl_null(g_m11) OR cl_null(g_m12) THEN
               CALL cl_err(g_hrce.hrce04,'ghr-104',0)
               NEXT FIELD hrce04
            END IF 
            IF cl_null(g_h2) OR cl_null(g_m2) OR g_h2>24 OR g_m2>=60 THEN
               CALL cl_err(g_hrce.hrce06,'asf-807',0)
               NEXT FIELD hrce06
            END IF
            IF cl_null(g_h21) OR cl_null(g_h22) OR cl_null(g_m21) OR cl_null(g_m22) THEN
               CALL cl_err(g_hrce.hrce06,'ghr-104',0)
               NEXT FIELD hrce06
            END IF
           IF g_hrce.hrce08 = "001" THEN 
              LET g_sum_m1 = g_h1/24 +g_m1/24/60
              LET g_sum_m2 = g_h2/24 +g_m2/24/60
              LET l_chk_time1 = (g_hrce.hrce05-g_hrce.hrce03)+ (g_sum_m2-g_sum_m1)
               IF l_chk_time1<0 THEN
                  CALL cl_err('','ghr-102',1)
                  NEXT FIELD hrce04
              END IF
              IF cl_null(g_hrce.hrce07) OR g_hrce.hrce07 = "0.00" OR l_chk_time1 != l_hrce07  THEN
                 LET g_hrce.hrce07 = l_chk_time1 + 1   
                 LET g_hrce07_1 = l_chk_time1
               #  DISPLAY BY NAME  g_hrce.hrce07
              END IF 
           END IF 
           IF g_hrce.hrce08 = "002" THEN 
              LET g_sum_m1 = g_h1/24 +g_m1/24/60
              LET g_sum_m2 = g_h2/24 +g_m2/24/60
              LET l_chk_time1 = (g_hrce.hrce05-g_hrce.hrce03)+ (g_sum_m2-g_sum_m1)
               IF l_chk_time1<0 THEN
                  CALL cl_err('','ghr-102',1)
                  NEXT FIELD hrce04
              END IF
              IF cl_null(g_hrce.hrce07) OR g_hrce.hrce07 = "0.00" OR l_chk_time1 != l_hrce07  THEN
                 LET g_hrce.hrce07 = (l_chk_time1 + 1)*2
                 LET g_hrce07_4 = l_chk_time1
                # DISPLAY BY NAME  g_hrce.hrce07
              END IF 
           END IF
           IF g_hrce.hrce08 = "003" THEN 
              LET g_sum_m1 = g_h1 +g_m1/24
              LET g_sum_m2 = g_h2 +g_m2/24
              LET l_chk_time1 = (g_hrce.hrce05-g_hrce.hrce03)*24+ (g_sum_m2-g_sum_m1)
               IF l_chk_time1<0 THEN
                  CALL cl_err('','ghr-102',1)
                  NEXT FIELD hrce04
              END IF
              IF cl_null(g_hrce.hrce07) OR g_hrce.hrce07 = "0.00" OR l_chk_time1 != l_hrce07 THEN
                 LET g_hrce.hrce07 = l_chk_time1  
                 LET g_hrce07_2 = l_chk_time1
              #   DISPLAY BY NAME  g_hrce.hrce07
              END IF 
            END IF
           IF g_hrce.hrce08 = "004" THEN 
              LET g_sum_m1 = g_h1*60 + g_m1
              LET g_sum_m2 = g_h2*60 + g_m2
              LET l_chk_time1 = (g_hrce.hrce05-g_hrce.hrce03)* 24 * 60 + (g_sum_m2-g_sum_m1)
               IF l_chk_time1<0 THEN
                  CALL cl_err('','ghr-102',1)
                  NEXT FIELD hrce04
              END IF
              IF cl_null(g_hrce.hrce07) OR g_hrce.hrce07 = "0.00" OR l_chk_time1 != l_hrce07 THEN 
                 LET g_hrce.hrce07 = l_chk_time1  
                 LET g_hrce07_3 = l_chk_time1 
               #  DISPLAY BY NAME  g_hrce.hrce07
              END IF 
           END IF
        END IF

      ON CHANGE  hrce03
         IF g_hrce.hrce03 IS NOT NULL THEN
            LET l_time = g_hrce.hrce03 - g_hrce.hrce05
             IF l_time > 0 THEN
               CALL cl_err('','ghr-102',1) 
               LET g_hrce.hrce05 = g_hrce.hrce03
               DISPLAY BY NAME g_hrce.hrce05
               NEXT FIELD hrce05 
         END IF 
         END IF 

           
      AFTER FIELD hrce03                    #NO.130624
         IF NOT cl_null(g_hrce.hrce03) THEN
            LET  g_h1 = g_hrce.hrce04[1,2]
            LET  g_m1 = g_hrce.hrce04[4,5]
            LET  g_h2 = g_hrce.hrce06[1,2]
            LET  g_m2 = g_hrce.hrce06[4,5]
            LET  g_h11 = g_hrce.hrce04[1]
            LET  g_h12 = g_hrce.hrce04[2]
            LET  g_m11 = g_hrce.hrce04[4]
            LET  g_m12 = g_hrce.hrce04[5]
            LET  g_h21 = g_hrce.hrce06[1]
            LET  g_h22 = g_hrce.hrce06[2]
            LET  g_m21 = g_hrce.hrce06[4]
            LET  g_m22 = g_hrce.hrce06[5]
            
            IF cl_null(g_h1) OR cl_null(g_m1) OR g_h1>24 OR g_m1>=60 THEN
               CALL cl_err(g_hrce.hrce04,'asf-807',0)
               NEXT FIELD hrce04
            END IF
            IF cl_null(g_h11) OR cl_null(g_h12) OR cl_null(g_m11) OR cl_null(g_m12) THEN
               CALL cl_err(g_hrce.hrce04,'ghr-104',0)
               NEXT FIELD hrce04
            END IF 
            IF cl_null(g_h2) OR cl_null(g_m2) OR g_h2>24 OR g_m2>=60 THEN
               CALL cl_err(g_hrce.hrce06,'asf-807',0)
               NEXT FIELD hrce06
            END IF
            IF cl_null(g_h21) OR cl_null(g_h22) OR cl_null(g_m21) OR cl_null(g_m22) THEN
               CALL cl_err(g_hrce.hrce06,'ghr-104',0)
               NEXT FIELD hrce06
            END IF
           IF g_hrce.hrce08 = "001" THEN 
              LET g_sum_m1 = g_h1/24 +g_m1/24/60
              LET g_sum_m2 = g_h2/24 +g_m2/24/60
              LET l_chk_time1 = (g_hrce.hrce05-g_hrce.hrce03)+ (g_sum_m2-g_sum_m1)
               IF l_chk_time1<0 THEN
                  CALL cl_err('','ghr-102',1)
                  NEXT FIELD hrce04
              END IF
              IF cl_null(g_hrce.hrce07) OR g_hrce.hrce07 = "0.00" OR l_chk_time1 != l_hrce07 THEN
                 LET g_hrce.hrce07 = l_chk_time1 + 1 
                 LET g_hrce07_1 = l_chk_time1
              #   DISPLAY BY NAME  g_hrce.hrce07
              END IF 
           END IF 
           IF g_hrce.hrce08 = "002" THEN 
              LET g_sum_m1 = g_h1/24 +g_m1/24/60
              LET g_sum_m2 = g_h2/24 +g_m2/24/60
              LET l_chk_time1 = (g_hrce.hrce05-g_hrce.hrce03)+ (g_sum_m2-g_sum_m1)
               IF l_chk_time1<0 THEN
                  CALL cl_err('','ghr-102',1)
                  NEXT FIELD hrce04
              END IF
              IF cl_null(g_hrce.hrce07) OR g_hrce.hrce07 = "0.00" OR l_chk_time1 != l_hrce07  THEN
                 LET g_hrce.hrce07 = (l_chk_time1 + 1)*2
                 LET g_hrce07_4 = l_chk_time1
                # DISPLAY BY NAME  g_hrce.hrce07
              END IF 
           END IF
           IF g_hrce.hrce08 = "003" THEN 
              LET g_sum_m1 = g_h1 +g_m1/24
              LET g_sum_m2 = g_h2 +g_m2/24
              LET l_chk_time1 = (g_hrce.hrce05-g_hrce.hrce03)*24+ (g_sum_m2-g_sum_m1)
               IF l_chk_time1<0 THEN
                  CALL cl_err('','ghr-102',1)
                  NEXT FIELD hrce04
              END IF
              IF cl_null(g_hrce.hrce07) OR g_hrce.hrce07 = "0.00" OR l_chk_time1 != l_hrce07 THEN
                 LET g_hrce.hrce07 = l_chk_time1  
                 LET g_hrce07_2 = l_chk_time1
              #   DISPLAY BY NAME  g_hrce.hrce07
              END IF 
            END IF
           IF g_hrce.hrce08 = "004" THEN 
              LET g_sum_m1 = g_h1*60 + g_m1
              LET g_sum_m2 = g_h2*60 + g_m2
              LET l_chk_time1 = (g_hrce.hrce05-g_hrce.hrce03)* 24 * 60 + (g_sum_m2-g_sum_m1)
               IF l_chk_time1<0 THEN
                  CALL cl_err('','ghr-102',1)
                  NEXT FIELD hrce04
              END IF
              IF cl_null(g_hrce.hrce07) OR g_hrce.hrce07 = "0.00" OR l_chk_time1 != l_hrce07 THEN 
                 LET g_hrce.hrce07 = l_chk_time1  
                 LET g_hrce07_3 = l_chk_time1 
               #  DISPLAY BY NAME  g_hrce.hrce07
              END IF 
           END IF  
         END IF
     
      AFTER FIELD hrce06                    #NO.130624
         IF NOT cl_null(g_hrce.hrce06) THEN
            LET  g_h1 = g_hrce.hrce04[1,2]
            LET  g_m1 = g_hrce.hrce04[4,5]
            LET  g_h2 = g_hrce.hrce06[1,2]
            LET  g_m2 = g_hrce.hrce06[4,5]
            LET  g_h11 = g_hrce.hrce04[1]
            LET  g_h12 = g_hrce.hrce04[2]
            LET  g_m11 = g_hrce.hrce04[4]
            LET  g_m12 = g_hrce.hrce04[5]
            LET  g_h21 = g_hrce.hrce06[1]
            LET  g_h22 = g_hrce.hrce06[2]
            LET  g_m21 = g_hrce.hrce06[4]
            lET  g_m22 = g_hrce.hrce06[5]
            
            IF cl_null(g_h1) OR cl_null(g_m1) OR g_h1>24 OR g_m1>=60 THEN
               CALL cl_err(g_hrce.hrce04,'asf-807',0)
               NEXT FIELD hrce04
            END IF
            IF cl_null(g_h11) OR cl_null(g_h12) OR cl_null(g_m11) OR cl_null(g_m12) THEN
               CALL cl_err(g_hrce.hrce04,'ghr-104',0)
               NEXT FIELD hrce04
            END IF 
            IF cl_null(g_h2) OR cl_null(g_m2) OR g_h2>24 OR g_m2>=60 THEN
               CALL cl_err(g_hrce.hrce06,'asf-807',0)
               NEXT FIELD hrce06
            END IF
            IF cl_null(g_h21) OR cl_null(g_h22) OR cl_null(g_m21) OR cl_null(g_m22) THEN
               CALL cl_err(g_hrce.hrce06,'ghr-104',0)
               NEXT FIELD hrce06
            END IF
           IF g_hrce.hrce08 = "001" THEN 
              LET g_sum_m1 = g_h1/24 +g_m1/24/60
              LET g_sum_m2 = g_h2/24 +g_m2/24/60
              LET l_chk_time1 = (g_hrce.hrce05-g_hrce.hrce03)+ (g_sum_m2-g_sum_m1)
               IF l_chk_time1<0 THEN
                  CALL cl_err('','ghr-102',1)
                  NEXT FIELD hrce04
              END IF
              IF cl_null(g_hrce.hrce07) OR g_hrce.hrce07 = "0.00" OR l_chk_time1 != l_hrce07 THEN
                 LET g_hrce.hrce07 = l_chk_time1 + 1
                 LET g_hrce07_1 = l_chk_time1
               #  DISPLAY BY NAME  g_hrce.hrce07
              END IF 
           END IF
           IF g_hrce.hrce08 = "002" THEN 
              LET g_sum_m1 = g_h1/24 +g_m1/24/60
              LET g_sum_m2 = g_h2/24 +g_m2/24/60
              LET l_chk_time1 = (g_hrce.hrce05-g_hrce.hrce03)+ (g_sum_m2-g_sum_m1)
               IF l_chk_time1<0 THEN
                  CALL cl_err('','ghr-102',1)
                  NEXT FIELD hrce04
              END IF
              IF cl_null(g_hrce.hrce07) OR g_hrce.hrce07 = "0.00" OR l_chk_time1 != l_hrce07  THEN
                 LET g_hrce.hrce07 = (l_chk_time1 + 1)*2
                 LET g_hrce07_4 = l_chk_time1
               #  DISPLAY BY NAME  g_hrce.hrce07
              END IF 
           END IF 
           IF g_hrce.hrce08 = "003" THEN 
              LET g_sum_m1 = g_h1 +g_m1/24
              LET g_sum_m2 = g_h2 +g_m2/24
              LET l_chk_time1 = (g_hrce.hrce05-g_hrce.hrce03)*24+ (g_sum_m2-g_sum_m1)
               IF l_chk_time1<0 THEN
                  CALL cl_err('','ghr-102',1)
                  NEXT FIELD hrce04
              END IF
              IF cl_null(g_hrce.hrce07) OR g_hrce.hrce07 = "0.00" OR l_chk_time1 != l_hrce07 THEN
                 LET g_hrce.hrce07 = l_chk_time1  
                 LET g_hrce07_2 = l_chk_time1
              #   DISPLAY BY NAME  g_hrce.hrce07
              END IF 
            END IF
           IF g_hrce.hrce08 = "004" THEN 
              LET g_sum_m1 = g_h1*60 + g_m1
              LET g_sum_m2 = g_h2*60 + g_m2
              LET l_chk_time1 = (g_hrce.hrce05-g_hrce.hrce03)* 24 * 60 + (g_sum_m2-g_sum_m1)
               IF l_chk_time1<0 THEN
                  CALL cl_err('','ghr-102',1)
                  NEXT FIELD hrce04
              END IF
              IF cl_null(g_hrce.hrce07) OR g_hrce.hrce07 = "0.00" OR l_chk_time1 != l_hrce07 THEN 
                 LET g_hrce.hrce07 = l_chk_time1  
                 LET g_hrce07_3 = l_chk_time1 
              #   DISPLAY BY NAME  g_hrce.hrce07
              END IF 
           END IF
        END IF

#      marked by yeap NO.130909------------str-----------
#      AFTER FIELD hrce08                    #NO.130624
#         IF NOT cl_null(g_hrce.hrce08) THEN
#            LET  g_h1 = g_hrce.hrce04[1,2]
#            LET  g_m1 = g_hrce.hrce04[4,5]
#            LET  g_h2 = g_hrce.hrce06[1,2]
#            LET  g_m2 = g_hrce.hrce06[4,5]
#            LET  g_h11 = g_hrce.hrce04[1]
#            LET  g_h12 = g_hrce.hrce04[2]
#            LET  g_m11 = g_hrce.hrce04[4]
#            LET  g_m12 = g_hrce.hrce04[5]
#            LET  g_h21 = g_hrce.hrce06[1]
#            LET  g_h22 = g_hrce.hrce06[2]
#            LET  g_m21 = g_hrce.hrce06[4]
#            LET  g_m22 = g_hrce.hrce06[5]
#            
#            IF cl_null(g_h1) OR cl_null(g_m1) OR g_h1>24 OR g_m1>=60 THEN
#               CALL cl_err(g_hrce.hrce04,'asf-807',0)
#               NEXT FIELD hrce04
#            END IF
#            IF cl_null(g_h11) OR cl_null(g_h12) OR cl_null(g_m11) OR cl_null(g_m12) THEN
#               CALL cl_err(g_hrce.hrce04,'ghr-104',0)
#               NEXT FIELD hrce04
#            END IF 
#            IF cl_null(g_h2) OR cl_null(g_m2) OR g_h2>24 OR g_m2>=60 THEN
#               CALL cl_err(g_hrce.hrce06,'asf-807',0)
#               NEXT FIELD hrce06
#            END IF
#            IF cl_null(g_h21) OR cl_null(g_h22) OR cl_null(g_m21) OR cl_null(g_m22) THEN
#               CALL cl_err(g_hrce.hrce06,'ghr-104',0)
#               NEXT FIELD hrce06
#            END IF
#           IF g_hrce.hrce08 = "001" THEN 
#              LET g_sum_m1 = g_h1/24 +g_m1/24/60
#              LET g_sum_m2 = g_h2/24 +g_m2/24/60
#              LET l_chk_time1 = (g_hrce.hrce05-g_hrce.hrce03)+ (g_sum_m2-g_sum_m1)
#               IF l_chk_time1<0 THEN
#                  CALL cl_err('','ghr-102',1)
#                  NEXT FIELD hrce04
#              END IF
#              IF cl_null(g_hrce.hrce07) OR g_hrce.hrce07 = "0.00" THEN
#                 LET g_hrce.hrce07 = l_chk_time1 + 1 
#                 LET g_hrce07_1 = l_chk_time1
#                 DISPLAY BY NAME  g_hrce.hrce07
#              END IF 
#           END IF 
#           IF g_hrce.hrce08 = "002" THEN 
#              LET g_sum_m1 = g_h1 +g_m1/24
#              LET g_sum_m2 = g_h2 +g_m2/24
#              LET l_chk_time1 = (g_hrce.hrce05-g_hrce.hrce03)*24+ (g_sum_m2-g_sum_m1)
#               IF l_chk_time1<0 THEN
#                  CALL cl_err('','ghr-102',1)
#                  NEXT FIELD hrce04
#              END IF
#              IF cl_null(g_hrce.hrce07) OR g_hrce.hrce07 = "0.00" THEN
#                 LET g_hrce.hrce07 = l_chk_time1  
#                 LET g_hrce07_2 = l_chk_time1
#                 DISPLAY BY NAME  g_hrce.hrce07
#              END IF 
#            END IF
#           IF g_hrce.hrce08 = "003" THEN 
#              LET g_sum_m1 = g_h1*60 + g_m1
#              LET g_sum_m2 = g_h2*60 + g_m2
#              LET l_chk_time1 = (g_hrce.hrce05-g_hrce.hrce03)* 24 * 60 + (g_sum_m2-g_sum_m1)
#               IF l_chk_time1<0 THEN
#                  CALL cl_err('','ghr-102',1)
#                  NEXT FIELD hrce04
#              END IF
#              IF cl_null(g_hrce.hrce07) OR g_hrce.hrce07 = "0.00" THEN 
#                 LET g_hrce.hrce07 = l_chk_time1  
#                 LET g_hrce07_3 = l_chk_time1 
#                 DISPLAY BY NAME  g_hrce.hrce07
#              END IF 
#           END IF 
#        END IF
#          marked by yeap NO.130909---------end--------------
     
      AFTER INPUT
            LET  g_h1 = g_hrce.hrce04[1,2]
            LET  g_m1 = g_hrce.hrce04[4,5]
            LET  g_h2 = g_hrce.hrce06[1,2]
            LET  g_m2 = g_hrce.hrce06[4,5]
            LET  g_h11 = g_hrce.hrce04[1]
            LET  g_h12 = g_hrce.hrce04[2]
            LET  g_m11 = g_hrce.hrce04[4]
            LET  g_m12 = g_hrce.hrce04[5]
            LET  g_h21 = g_hrce.hrce06[1]
            LET  g_h22 = g_hrce.hrce06[2]
            LET  g_m21 = g_hrce.hrce06[4]
            LET  g_m22 = g_hrce.hrce06[5]
            
            IF cl_null(g_h1) OR cl_null(g_m1) OR g_h1>24 OR g_m1>=60 THEN
               CALL cl_err(g_hrce.hrce04,'asf-807',0)
               NEXT FIELD hrce04
            END IF
            IF cl_null(g_h11) OR cl_null(g_h12) OR cl_null(g_m11) OR cl_null(g_m12) THEN
               CALL cl_err(g_hrce.hrce04,'ghr-104',0)
               NEXT FIELD hrce04
            END IF 
            IF cl_null(g_h2) OR cl_null(g_m2) OR g_h2>24 OR g_m2>=60 THEN
               CALL cl_err(g_hrce.hrce06,'asf-807',0)
               NEXT FIELD hrce06
            END IF
            IF cl_null(g_h21) OR cl_null(g_h22) OR cl_null(g_m21) OR cl_null(g_m22) THEN
               CALL cl_err(g_hrce.hrce06,'ghr-104',0)
               NEXT FIELD hrce06
            END IF
           IF g_hrce.hrce08 = "001" THEN 
              LET g_sum_m1 = g_h1/24 +g_m1/24/60
              LET g_sum_m2 = g_h2/24 +g_m2/24/60
              LET l_chk_time1 = (g_hrce.hrce05-g_hrce.hrce03)+ (g_sum_m2-g_sum_m1)
               IF l_chk_time1<0 THEN
                  CALL cl_err('','ghr-102',1)
                  NEXT FIELD hrce04
              END IF
              IF cl_null(g_hrce.hrce07) OR g_hrce.hrce07 = "0.00" OR l_chk_time1 != l_hrce07 THEN
                 LET g_hrce.hrce07 = l_chk_time1 + 1 
                 LET g_hrce07_1 = l_chk_time1
              #   DISPLAY BY NAME  g_hrce.hrce07
              END IF 
           END IF 
           IF g_hrce.hrce08 = "002" THEN 
              LET g_sum_m1 = g_h1/24 +g_m1/24/60
              LET g_sum_m2 = g_h2/24 +g_m2/24/60
              LET l_chk_time1 = (g_hrce.hrce05-g_hrce.hrce03)+ (g_sum_m2-g_sum_m1)
               IF l_chk_time1<0 THEN
                  CALL cl_err('','ghr-102',1)
                  NEXT FIELD hrce04
              END IF
              IF cl_null(g_hrce.hrce07) OR g_hrce.hrce07 = "0.00" OR l_chk_time1 != l_hrce07  THEN
                 LET g_hrce.hrce07 = (l_chk_time1 + 1)*2
                 LET g_hrce07_4 = l_chk_time1
                # DISPLAY BY NAME  g_hrce.hrce07
              END IF 
           END IF
           IF g_hrce.hrce08 = "003" THEN 
              LET g_sum_m1 = g_h1 +g_m1/24
              LET g_sum_m2 = g_h2 +g_m2/24
              LET l_chk_time1 = (g_hrce.hrce05-g_hrce.hrce03)*24+ (g_sum_m2-g_sum_m1)
               IF l_chk_time1<0 THEN
                  CALL cl_err('','ghr-102',1)
                  NEXT FIELD hrce04
              END IF
              IF cl_null(g_hrce.hrce07) OR g_hrce.hrce07 = "0.00" OR l_chk_time1 != l_hrce07 THEN
                 LET g_hrce.hrce07 = l_chk_time1  
                 LET g_hrce07_2 = l_chk_time1
              #   DISPLAY BY NAME  g_hrce.hrce07
              END IF 
            END IF
           IF g_hrce.hrce08 = "004" THEN 
              LET g_sum_m1 = g_h1*60 + g_m1
              LET g_sum_m2 = g_h2*60 + g_m2
              LET l_chk_time1 = (g_hrce.hrce05-g_hrce.hrce03)* 24 * 60 + (g_sum_m2-g_sum_m1)
               IF l_chk_time1<0 THEN
                  CALL cl_err('','ghr-102',1)
                  NEXT FIELD hrce04
              END IF
              IF cl_null(g_hrce.hrce07) OR g_hrce.hrce07 = "0.00" OR l_chk_time1 != l_hrce07 THEN 
                 LET g_hrce.hrce07 = l_chk_time1  
                 LET g_hrce07_3 = l_chk_time1 
               #  DISPLAY BY NAME  g_hrce.hrce07
              END IF 
           END IF
         IF NOT cl_null(g_hrce.hrce01) THEN
            IF g_hrce.hrce01 != g_hrce01_t OR cl_null(g_hrce01_t) THEN
               SELECT COUNT(UNIQUE hrce01) INTO g_cnt FROM hrce_file
                WHERE hrce01 = g_hrce.hrce01
               IF g_cnt > 0 THEN
                  IF p_cmd = 'a' THEN
                     LET g_ss = 'Y'
                  END IF
               ELSE
                  IF p_cmd = 'u' THEN
                     CALL cl_err(g_hrce.hrce01,-239,0)
                     LET g_hrce.hrce01 = g_hrce01_t
                     NEXT FIELD hrce01
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_hrce.hrce01,g_errno,0)
                  NEXT FIELD hrce02
               END IF
            END IF
         END IF  
         
    IF p_cmd ='a' THEN 
       BEGIN WORK
      # SELECT COUNT(*) INTO l_cnt FROM hrce_file
      #  WHERE hrce02 = g_hrce.hrce02
      #    AND hrce03 = g_hrce.hrce03
      #    AND hrce07 = g_hrce.hrce07
      #    AND hrce04 = g_hrce.hrce04
      #    AND hrce09 = g_hrce.hrce09
      #    AND hrce10 = g_hrce.hrce10
      # IF l_cnt > 0 THEN 
      #    SELECT hrce01 INTO g_hrce.hrce01 FROM hrce_file
      #     WHERE hrce02 = g_hrce.hrce02
      #       AND hrce03 = g_hrce.hrce03
      #       AND hrce07 = g_hrce.hrce07
      #       AND hrce04 = g_hrce.hrce04
      #       AND hrce09 = g_hrce.hrce09
      #       AND hrce10 = g_hrce.hrce10
      #       COMMIT WORK 
      # ELSE 
           SELECT max(hrce01)+1 INTO g_hrce.hrce01 FROM hrce_file 
               IF cl_null(g_hrce.hrce01) THEN
           	      LET g_hrce.hrce01 =  '1'
               END IF
      # END IF 

          
      IF SQLCA.sqlcode THEN                             #置入資料庫不成功
         CALL cl_err3("ins","hrce_file",g_hrce.hrce01,"",SQLCA.sqlcode,"","",1) #No.FUN-B80088---上移一行調整至回滾事務前---
         ROLLBACK WORK
      ELSE
         COMMIT WORK                                    #新增成功後，若有設定流程通知
         CALL cl_flow_notify(g_hrce.hrce01,'I')           #則增加訊息到udm7主畫面上或使用者信箱
      END IF 
    END IF 

            IF g_hrce.hrce01 IS NULL THEN
               DISPLAY BY NAME g_hrce.hrce02
            END IF
            IF l_input='Y' THEN
               NEXT FIELD hrce02
            END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(hrce02)
               CALL cl_init_qry_var()
                LET g_qryparam.form = "q_hrbm03"
                LET g_qryparam.arg1 = '005'
                LET g_qryparam.default1= g_hrce.hrce02
               CALL cl_create_qry() RETURNING g_hrce.hrce02
               NEXT FIELD hrce02
         OTHERWISE 
               EXIT CASE
         END CASE
 
      ON ACTION controlf                  #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

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
END FUNCTION
 
FUNCTION i045_hrce02(p_cmd) 

   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_hrbm04    LIKE hrbm_file.hrbm04
   DEFINE l_hrbm06    LIKE hrbm_file.hrbm06
 
   LET g_errno=''
   SELECT hrbm04,hrbm06 INTO l_hrbm04,l_hrbm06 FROM hrbm_file
    WHERE hrbm03=g_hrce.hrce02
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='ghr-072'
                                LET l_hrbm04=NULL
                                LET l_hrbm06=NULL 
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   
   IF p_cmd='a' OR cl_null(g_errno)THEN
      DISPLAY l_hrbm04 TO hrbm04
      DISPLAY l_hrbm06 TO hrce08
      LET g_hrce.hrce08 = l_hrbm06
   END IF
END FUNCTION

FUNCTION i045_u() #gai
 
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_hrce.hrce01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF


   SELECT * INTO g_hrce.* FROM hrce_file
    WHERE hrce01=g_hrce.hrce01        #刷新资料
 
   IF g_hrce.hrceacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_hrce.hrce01,'mfg1000',0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_hrce01_t = g_hrce.hrce01
 
   BEGIN WORK
   
   OPEN i045_lock_u USING g_hrce.hrce01
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE i045_lock_u
      ROLLBACK WORK
      RETURN
   END IF
   
   FETCH i045_lock_u INTO g_hrce_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("hrce01 LOCK:",SQLCA.sqlcode,1)
      CLOSE i045_lock_u
      ROLLBACK WORK
      RETURN
   END IF

   CALL i045_show()
   CALL i045_b_fill_1(g_wc)   #added by yeap NO.130828
 
   WHILE TRUE
   IF  g_hrce.hrceconf = 'N' OR cl_null(g_hrce.hrceconf) THEN                #NO.130619
       LET g_hrce01_t = g_hrce.hrce01
       LET g_hrce03_t = g_hrce.hrce03  #NO.130625
       LET g_hrce08_t = g_hrce.hrce08
       LET g_hrce.hrcemodu=g_user
       LET g_hrce.hrcedate=g_today
      CALL i045_i("u")

        IF INT_FLAG THEN
           LET g_hrce.hrce01 = g_hrce01_t
           DISPLAY g_hrce.hrce01 TO hrce01
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           EXIT WHILE
        END IF

      
        LET g_hrce.hrce08 = g_hrce08_t
         UPDATE hrce_file SET hrce_file.* = g_hrce.*
          WHERE hrce01 = g_hrce01_t
       
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","hrce_file",g_hrce01_t,"",SQLCA.sqlcode,"","",1) 
            CONTINUE WHILE
          ELSE
      	    DELETE FROM hrcec_file
      	     WHERE hrcec01 = g_hrce.hrce01
      	      CALL i045_hrcec_file()
         END IF
         EXIT WHILE
    END IF                #NO.130619
   END WHILE
   CLOSE i045_lock_u
   COMMIT WORK
   CALL cl_flow_notify(g_hrce.hrce01,'U')
   
   CALL i045_b_fill_1(g_wc)   #added by yeap NO.130828
   CALL i045_b_fill("1=1")
END FUNCTION

FUNCTION i045_hrcec_file()
	DEFINE   l_hrcec10       LIKE hrcec_file.hrcec10
  DEFINE   l_hratid1       LIKE hrat_file.hratid
	 
	 CALL g_hrcec.clear()  #NO.071305
	 
	SELECT MAX(hrceb02) INTO g_number2 FROM hrceb_file WHERE hrceb01 = g_hrce.hrce01 GROUP BY hrceb01
	   LET g_number1 = g_hrce.hrce05 - g_hrce.hrce03 + 1

	
	 FOR g_i1 = 1 TO g_number2
	     	   LET g_number3 = 1+(g_number1)*(g_i1-1)
	         LET g_number4 = (g_number1)+(g_number1)*(g_i1-1)
	         
	          SELECT hratid
              INTO l_hratid1  #抓取员工ID
              FROM hrat_file
             WHERE hrat01 = g_hrceb[g_i1].hrceb03
	         
	          FOR g_i = g_number3 TO g_number4
	          
               LET g_hrcec[g_i].hrcec04 = g_hrceb[g_i1].hrceb03
                
                IF g_i = g_number3 THEN 
                   SELECT hrce02,hrce03,hrce04,hrce08
                     INTO g_hrcec[g_i].hrcec03,g_hrcec[g_i].hrcec05,g_hrcec[g_i].hrcec06,l_hrcec10
                     FROM hrce_file
                    WHERE hrce01 = g_hrce.hrce01
                      LET g_hrcec[g_i].hrcec07 = ''
                      LET g_hrcec[g_i].hrcec08 = ''
                END IF 
                 
                IF g_i > g_number3 AND g_i < g_number4 THEN	 
                   SELECT hrce02,hrce08
                     INTO g_hrcec[g_i].hrcec03,l_hrcec10
                     FROM hrce_file
                    WHERE hrce01 = g_hrce.hrce01
                      LET g_hrcec[g_i].hrcec05 = g_hrcec[g_i-1].hrcec05 + 1
                      LET g_hrcec[g_i].hrcec07 = g_hrcec[g_i].hrcec05
                      LET g_hrcec[g_i].hrcec08 = ''
                END IF
                      
                IF g_i = g_number4 THEN	 
                   SELECT hrce02,hrce05,hrce06,hrce08
                     INTO g_hrcec[g_i].hrcec03,g_hrcec[g_i].hrcec07,g_hrcec[g_i].hrcec08,l_hrcec10
                     FROM hrce_file
                    WHERE hrce01 = g_hrce.hrce01
                      LET g_hrcec[g_i].hrcec05 = ''
                      LET g_hrcec[g_i].hrcec06 = ''
                END IF
                      
                   SELECT hrag07
        	           INTO g_hrcec[g_i].hrcec10
        	           FROM hrag_file
                    WHERE hrag06 = l_hrcec10 
        	            AND hrag01 = 504
        	            
               DISPLAY BY NAME g_hrcec[g_i].hrcec04,g_hrcec[g_i].hrcec10
               
                   SELECT to_char(max(hrcec02)+1,'fm000000') INTO g_hrcec[g_i].hrcec02 FROM hrcec_file 
                    WHERE hrcec01 = g_hrce.hrce01
                         IF cl_null(g_hrcec[g_i].hrcec02) THEN
                            LET g_hrcec[g_i].hrcec02 =  '000001'
                         END IF
                         	
                      LET g_hrcec[g_i].hrcec16 = "N"

                
            INSERT INTO hrcec_file(hrcec01,hrcec02,hrcec03,hrcec04,hrcec05,hrcec06,
                                 hrcec07,hrcec08,hrcec09,hrcec10,
                                 hrcec11,hrcec12,hrcec13,hrcec14,    #NO.130618
                                 hrcec15,hrcec16)
               VALUES (g_hrce.hrce01,g_hrcec[g_i].hrcec02,g_hrcec[g_i].hrcec03,l_hratid1,
                       g_hrcec[g_i].hrcec05,g_hrcec[g_i].hrcec06,g_hrcec[g_i].hrcec07,g_hrcec[g_i].hrcec08,
                       '0',l_hrcec10,g_hrcec[g_i].hrcec11,g_hrcec[g_i].hrcec12,#NO.130618   no.130909
                       g_hrcec[g_i].hrcec13,g_hrcec[g_i].hrcec14,g_hrcec[g_i].hrcec15,g_hrcec[g_i].hrcec16)          
        END FOR 
  END FOR     
END FUNCTION 
 
FUNCTION i045_q()   #gai                         #Query 查詢
   MESSAGE ""
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CLEAR FORM  #NO.TQC-740075
   INITIALIZE g_hrce.* TO NULL
   DISPLAY '' TO FORMONLY.cnt
   CALL i045_curs()                         #取得查詢條件
   IF INT_FLAG THEN                              #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN i045_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                         #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_hrce.hrce01 TO NULL
      CALL g_hrcea.clear()
      CALL g_hrceb.clear()
      CALL g_hrcec.clear()
   ELSE
      OPEN i045_count
      FETCH i045_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i045_fetch('F')                 #讀出TEMP第一筆並顯示
    END IF
END FUNCTION

 
FUNCTION i045_fetch(p_flag)#gai                  #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1,         #處理方式     #No.FUN-680135 VARCHAR(1) 
            l_abso   LIKE type_file.num10         #絕對的筆數   #No.FUN-680135 INTEGER
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i045_b_curs INTO g_hrce.hrce01,g_hrce.hrce02   #No.FUN-710055
      WHEN 'P' FETCH PREVIOUS i045_b_curs INTO g_hrce.hrce01,g_hrce.hrce02   #No.FUN-710055
      WHEN 'F' FETCH FIRST    i045_b_curs INTO g_hrce.hrce01,g_hrce.hrce02    #No.FUN-710055
      WHEN 'L' FETCH LAST     i045_b_curs INTO g_hrce.hrce01,g_hrce.hrce02    #No.FUN-710055
      WHEN '/' 
         IF (NOT g_no_ask) THEN          #No.FUN-6A0080
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
                ON ACTION controlp
                   CALL cl_cmdask()
 
                ON ACTION help
                   CALL cl_show_help()
 
                ON ACTION about
                   CALL cl_about()
 
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump i045_b_curs INTO g_hrce.hrce01,g_hrce.hrce02    #No.FUN-710055
         LET g_no_ask = FALSE    #No.FUN-6A0080
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hrce.hrce01,SQLCA.sqlcode,0)
      INITIALIZE g_hrce.hrce01 TO NULL  #TQC-6B0105
      RETURN 
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump          --改g_jump
      END CASE 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
   END IF
   
      SELECT * INTO g_hrce.* FROM hrce_file WHERE hrce01 = g_hrce.hrce01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","hrce_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      INITIALIZE g_hrce.* TO NULL
      RETURN
   END IF
      CALL i045_show()

END FUNCTION
 
FUNCTION i045_show()#gai                         # 將資料顯示在畫面上
   DISPLAY BY NAME
            g_hrce.hrce02,g_hrce.hrce03,g_hrce.hrce04,g_hrce.hrce05,g_hrce.hrce06,
            # g_hrce.hrce07,g_hrce.hrce08,    marked by yeap NO.130909
            g_hrce.hrce09,g_hrce.hrce10,g_hrce.hrce11,
            g_hrce.hrce12,g_hrce.hrce13,g_hrce.hrceconf,g_hrce.hrceacti 
      #  TO hrce02,hrce03,hrce04,hrce05,hrce06,hrce07,hrce08,
      #     hrce09,hrce10,hrce11,hrce12,hrce13,hrceconf,hrceacti

      IF g_hrce.hrceconf = 'Y' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF              #NO.130618
    CALL cl_set_field_pic(g_hrce.hrceconf,g_chr2,"","","","")#显示表示已审核的图片


   IF cl_null(g_wc) THEN
   	  LET g_wc = '1=1'
   END IF
   CALL i045_hrce02('a')   #NO.130625 	
   CALL i045_b_fill(g_wc)                    # 單身  
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i045_r()#gai        # 取消整筆 (所有合乎單頭的資料)
   DEFINE   l_cnt           LIKE type_file.num5,
            l_hrceconf      LIKE hrce_file.hrceconf
 #           l_hrce          RECORD LIKE hrce_file.*  #NO.130617
   DEFINE   l_hrce01        LIKE hrce_file.hrce01
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_hrce.hrce02) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   SELECT hrceconf,hrce01 INTO l_hrceconf,l_hrce01 FROM hrce_file 
    WHERE hrce02 = g_hrce.hrce02
      AND hrce03 = g_hrce.hrce03
      AND hrce04 = g_hrce.hrce04
      AND hrce07 = g_hrce.hrce07
#      AND hrce09 = g_hrce.hrce09
      AND hrce10 = g_hrce.hrce10
   BEGIN WORK
     OPEN i045_lock_u USING l_hrce01
          IF STATUS THEN
             CALL cl_err("OPEN i045_lock_u:", STATUS, 0)
             CLOSE i045_lock_u
             ROLLBACK WORK
             RETURN
          END IF
          FETCH i045_lock_u INTO g_hrce.*
             IF SQLCA.sqlcode THEN
                CALL cl_err(l_hrce01,SQLCA.sqlcode,0)
                RETURN
            END IF
           CALL i045_show()
           CALL i045_b_fill_1(g_wc)   #added by yeap NO.130828
       IF cl_delh(0,0)THEN                   #確認一下
          LET g_doc.column1 = "hrce01"
          LET g_doc.value1 = g_hrce.hrce01
         CALL cl_del_doc()
         
           IF l_hrceconf = 'N' OR cl_null(l_hrceconf)THEN 
              DELETE FROM hrce_file
              WHERE hrce01 = l_hrce01
      
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","hrce_file",l_hrce01,"",SQLCA.sqlcode,"","BODY DELETE",0)   #No.FUN-660081
              ELSE
                 DELETE FROM hrceb_file
                  WHERE hrceb01= l_hrce01
                 DELETE FROM hrcea_file
                  WHERE hrcea01= l_hrce01
                 DELETE FROM hrcec_file
                  WHERE hrcec01= l_hrce01
              
                  CLEAR FORM
                   CALL g_hrceb.clear()
                   CALL g_hrcea.clear()
                   CALL g_hrcec.clear()
               
             INITIALIZE g_hrce.* TO NULL
                   OPEN i045_count
                     IF STATUS THEN
                        CLOSE i045_lock_u
                        CLOSE i045_count
                        COMMIT WORK
                        RETURN
                     END IF
                  FETCH i045_count INTO g_row_count
                     IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
                        CLOSE i045_lock_u
                        CLOSE i045_count
                        COMMIT WORK
                        RETURN
                     END IF
                DISPLAY g_row_count TO FORMONLY.cnt
                   OPEN i045_b_curs
                     IF g_curs_index = g_row_count + 1 THEN
                        LET g_jump = g_row_count
                        CALL i045_fetch('L')
                     ELSE
                        LET g_jump = g_curs_index
                        LET g_no_ask = TRUE           #No.FUN-6A0080
                        CALL i045_fetch('/')
                     END IF
              END IF
           ELSE 
                CALL cl_err('','ghr-103',1)
                COMMIT WORK 
          END IF 
   END IF
   CLOSE i045_lock_u
   COMMIT WORK
END FUNCTION
 
FUNCTION i045_b()#gai                            # 單身
   DEFINE   l_hrce          RECORD LIKE hrce_file.*,           #NO.130617
            l_ac_t          LIKE type_file.num5,               # 未取消的ARRAY CNT #No.FUN-680135 SMALLINT 
            l_n             LIKE type_file.num5,               # 檢查重複用        #No.FUN-680135 SMALLINT
            l_cnt           LIKE type_file.num5,               # FUN-7B0081
            l_hrceconf      LIKE hrce_file.hrceconf,
            l_lock_sw       LIKE type_file.chr1,               # 單身鎖住否        #No.FUN-680135 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,               # 處理狀態          #No.FUN-680135 VARCHAR(1)
            l_allow_insert  LIKE type_file.num5,               #No.FUN-680135 SMALLINT
            l_allow_delete  LIKE type_file.num5                #No.FUN-680135 SMALLINT
   DEFINE   l_count         LIKE type_file.num5                #FUN-680135    SMALLINT
   DEFINE   ls_msg_o        STRING
   DEFINE   ls_msg_n        STRING
   DEFINE   li_i            LIKE type_file.num5                # 暫存用數值   # No:FUN-BA0116
   DEFINE   lc_target       LIKE gay_file.gay01                # No:FUN-BA0116
   DEFINE   l_aa            varchar(20)
   DEFINE   l_bb            varchar(20)
   DEFINE   l_cc            varchar(20)
   DEFINE   l_ss            varchar(20)
   DEFINE   l_sql           STRING
   DEFINE   l_hrat01        LIKE hrat_file.hrat01   #NO.130624
   DEFINE   l_hrat011       LIKE hrat_file.hrat01   #NO.130619
   DEFINE   l_hrat041       LIKE hrat_file.hrat04   #NO.130619
   DEFINE   l_hrat051       LIKE hrat_file.hrat05   #NO.130619
   DEFINE   l_hrat19       LIKE hrat_file.hrat19   #NO.130619
   DEFINE   l_hratid1       LIKE hrat_file.hratid   #NO.130619
   DEFINE   l_hratid        LIKE hrat_file.hratid   #NO.130619
   DEFINE   l_hrat012       LIKE hrat_file.hrat01   #NO.130619
   DEFINE   l_hrat042       LIKE hrat_file.hrat04   #NO.130619
   DEFINE   l_hrat052       LIKE hrat_file.hrat05   #NO.130619
   DEFINE   l_hrat192       LIKE hrat_file.hrat19   #NO.130619
   DEFINE   l_hratid2       LIKE hrat_file.hratid   #NO.130619
   DEFINE   l_hrcec07       LIKE hrcec_file.hrcec07
   DEFINE   l_hrcec08       LIKE hrcec_file.hrcec08
   DEFINE   l_hrcec10       LIKE hrcec_file.hrcec10
   DEFINE   l_hrcec03       LIKE hrcec_file.hrcec03 #NO.130705
   DEFINE   l_hrce05        LIKE hrce_file.hrce05
   DEFINE   l_hrce06        LIKE hrce_file.hrce06
   DEFINE   l_hrcea05       LIKE hrcea_file.hrcea05
   DEFINE   l_hrcea06       LIKE hrcea_file.hrcea06
   DEFINE   l_hrcd02        LIKE hrcd_file.hrcd02
   DEFINE   l_hrcd04        LIKE hrcd_file.hrcd04
   DEFINE   l_hrbm04        LIKE hrbm_file.hrbm04   #NO.130705
   DEFINE   l_hrceb03_t     LIKE hrceb_file.hrceb03
   DEFINE   l_hrat01_t      LIKE hrat_file.hrat01
   DEFINE   l_hrcec10_c     LIKE hrcec_file.hrcec10
   DEFINE   l_hrcec03_c     LIKE hrcec_file.hrcec03
   
   
 
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_hrce.hrce01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 #NO.130705  
 #  SELECT MAX(hrceb02) INTO g_number2 FROM hrceb_file WHERE hrceb01 = g_hrce.hrce01 GROUP BY hrceb01
 #  IF NOT g_number2 THEN 
 #  	  LET g_number2 = g_number2 + 1
 #  END IF 
 #  LET g_number1 = g_hrce.hrce05 -g_hrce.hrce03 + 1  
   
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
   
#NO.130619
   LET g_forupd_sql= "SELECT hrceb02,hrceb03,'','','','','',",
                     "hrceb04,'','','','',hrceb05,'',hrceb06 ",
                      " FROM hrceb_file ",
                      "  WHERE hrceb01 = ? AND hrceb02 = ?  ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i045_bcl1 CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET g_forupd_sql =  "SELECT hrcea02,hrcea13,'',hrcea03,hrcea04,hrcea05,hrcea06,",
                        "hrcea07,hrcea08,hrcea09,hrcea10,hrcea11,hrcea12",
                        " FROM hrcea_file ",
                        "  WHERE hrcea01 = ? AND hrcea02 = ?  ",
                        " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i045_bcl2 CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET g_forupd_sql = "SELECT hrcec02,hrcec03,hrcec04,'',hrcec05,hrcec06,",
                       "hrcec07,hrcec08,hrcec09,hrcec10,'','','','',hrcec15,hrcec16",
                       " FROM hrcec_file ",
                       "  WHERE hrcec01 = ? AND hrcec02 = ?  ",
                       " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i045_bcl3 CURSOR FROM g_forupd_sql      # LOCK CURSOR
   
   LET l_ac_t = 0

    DIALOG ATTRIBUTES(UNBUFFERED)

        INPUT ARRAY g_hrceb FROM s_hrceb.*
              ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS = TRUE,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
                IF g_rec_b1 != 0 THEN
                   CALL fgl_set_arr_curr(l_ac1)
               END IF 
         
        BEFORE ROW         #NO.130617
         DISPLAY "BEFORE ROW!"
         LET p_cmd=''
         LET l_ac1 = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()

         BEGIN WORK
         
           OPEN i045_lock_u USING g_hrce.hrce01
           IF STATUS THEN
              CALL cl_err("OPEN i045_lock_u:", STATUS, 1)
              CLOSE i045_lock_u
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i045_lock_u INTO g_hrce.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_hrce.hrce01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE i045_lock_u
              ROLLBACK WORK
              RETURN
           END IF
           
          IF g_rec_b1 >= l_ac1 THEN
               LET p_cmd='u'
               LET g_before_input_done = FALSE                                  
              CALL i045_set_entry(p_cmd)                                       
              CALL i045_set_no_entry(p_cmd)                                    
               LET g_before_input_done = TRUE  
               LET g_hrceb_t.* = g_hrceb[l_ac1].*    #BACKUP
            
          OPEN i045_bcl1 USING g_hrce.hrce01,g_hrceb_t.hrceb02     #NO.130619
            IF STATUS THEN
               CALL cl_err("OPEN i045_bcl1:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH i045_bcl1 INTO g_hrceb[l_ac1].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_hrceb_t.hrceb02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
     #NO.130619
            SELECT hratid
              INTO l_hratid1  #抓取员工ID
              FROM hrat_file
             WHERE hratid = g_hrceb[l_ac1].hrceb03
            SELECT hratid
              INTO l_hratid2  #抓取员工ID
              FROM hrat_file
             WHERE hratid = g_hrceb[l_ac1].hrceb04

#NO.130626
               SELECT hrat04,hrat05,hrat19
                 INTO l_hrat041,l_hrat051,l_hrat19  #抓取中间变量
                 FROM hrat_file
                WHERE hratid = g_hrceb[l_ac1].hrceb03
                
               SELECT hrat02 INTO g_hrceb[l_ac1].hrat102 #抓取姓名
                 FROM hrat_file
                WHERE hratid = g_hrceb[l_ac1].hrceb03

                SELECT hrao02 INTO g_hrceb[l_ac1].hrao102   #抓取部门名称
                  FROM hrao_file
                 WHERE hrao01 = l_hrat041

                SELECT hras04 INTO g_hrceb[l_ac1].hras104   #抓取职位名称
                  FROM hras_file
                 WHERE hras01 = l_hrat051

                SELECT hrat25 INTO g_hrceb[l_ac1].hrat125   #抓取入司日期
                  FROM hrat_file
                 WHERE hratid = g_hrceb[l_ac1].hrceb03
                 
                SELECT hrad03 INTO g_hrceb[l_ac1].hrad03   #抓取员工状态
                  FROM hrad_file
                 WHERE hrad02 = l_hrat19
#NO.130625
               SELECT hrat04,hrat05 INTO l_hrat042,l_hrat052 #抓取中间变量
                 FROM hrat_file
                WHERE hratid = g_hrceb[l_ac1].hrceb04
                
               LET g_errno = ''
               SELECT hrat02 INTO g_hrceb[l_ac1].hrat202 #抓取姓名
                 FROM hrat_file
                WHERE hratid = g_hrceb[l_ac1].hrceb04

                CASE WHEN SQLCA.SQLCODE = 100   LET  g_errno = 'mfg3006'
                                                LET  g_hrceb[l_ac1].hrat202 = NULL
                     OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                END CASE

                LET g_errno = ''
                SELECT hrao02 INTO g_hrceb[l_ac1].hrao202   #抓取部门名称
                  FROM hrao_file
                 WHERE hrao01 = l_hrat042

                 CASE WHEN SQLCA.SQLCODE = 100   LET  g_errno = 'mfg3006'
                                                 LET  g_hrceb[l_ac1].hrao202 = NULL
                      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                END CASE

                LET g_errno = ''
                SELECT hras04 INTO g_hrceb[l_ac1].hras204   #抓取职位名称
                  FROM hras_file
                 WHERE hras01 = l_hrat052

                 CASE WHEN SQLCA.SQLCODE = 100   LET  g_errno = 'mfg3006'
                                                 LET  g_hrceb[l_ac1].hras204 = NULL
                      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                END CASE

                LET g_errno = ''
                SELECT hrat25 INTO g_hrceb[l_ac1].hrat225   #抓取入司日期
                  FROM hrat_file
                 WHERE hrat01 = g_hrceb[l_ac1].hrceb04

                 CASE WHEN SQLCA.SQLCODE = 100   LET  g_errno = 'mfg3006'
                                                 LET  g_hrceb[l_ac1].hrat225 = NULL
                      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                END CASE

                  LET g_errno = ''
               SELECT hrao02 INTO g_hrceb[l_ac1].hrao02 #抓取姓名
                 FROM hrat_file
                WHERE hrat01 = g_hrceb[l_ac1].hrceb05

                CASE WHEN SQLCA.SQLCODE = 100   LET  g_errno = 'mfg3006'
                                                LET  g_hrceb[l_ac1].hrao02 = NULL
                     OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                END CASE
     #----------------------end---------------#
            END IF
            CALL cl_show_fld_cont()     #NO.130626


        END IF

        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
               
               LET l_n = ARR_COUNT()
               LET p_cmd='a'
               LET g_before_input_done = FALSE
              CALL i045_set_entry(p_cmd)
              CALL i045_set_no_entry(p_cmd)
               LET g_before_input_done = TRUE
        INITIALIZE g_hrceb[l_ac1].* TO NULL
               LET g_hrceb_t.* = g_hrceb[l_ac1].*
              CALL cl_show_fld_cont()     #FUN-550037(smin)
              
              SELECT count(*) INTO l_cnt FROM hrceb_file #NO.130625
               WHERE hrceb01 = g_hrce.hrce01
                 AND hrceb03= g_hrceb[l_ac1].hrceb03 
                  IF l_cnt > 0 THEN 
                     CALL cl_err3("ins","hrceb_file",g_hrce.hrce01,"",SQLCA.sqlcode,"","",0) 
                  ELSE 
                     SELECT to_char(max(hrceb02)+1,'fm000000') INTO g_hrceb[l_ac1].hrceb02 FROM hrceb_file WHERE hrceb01 = g_hrce.hrce01 
                         IF cl_null(g_hrceb[l_ac1].hrceb02) THEN
                            LET g_hrceb[l_ac1].hrceb02 =  '000001'
                          END IF
                  END IF 
            	
              NEXT FIELD hrceb03

        AFTER INSERT
         DISPLAY "AFTER INSERT!"
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF 
        #NO.130625
            
            SELECT hratid
              INTO l_hratid1  #抓取员工ID
              FROM hrat_file
             WHERE hrat01 = g_hrceb[l_ac1].hrceb03

            SELECT hratid
              INTO l_hratid2  #抓取员工ID
              FROM hrat_file
             WHERE hrat01 = g_hrceb[l_ac1].hrceb04
            
         INSERT INTO hrceb_file(hrceb01,hrceb02,hrceb03,hrceb04,hrceb05,hrceb06)
                      VALUES (g_hrce.hrce01,g_hrceb[l_ac1].hrceb02,l_hratid1,
                              l_hratid2,g_hrceb[l_ac1].hrceb05,g_hrceb[l_ac1].hrceb06)

         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrceb_file",g_hrce.hrce01,g_hrceb[l_ac1].hrceb02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
            CANCEL INSERT
         ELSE
            #-------------------NO.130624----------str------------#
   SELECT MAX(hrceb02) INTO g_number2 FROM hrceb_file WHERE hrceb01 = g_hrce.hrce01 GROUP BY hrceb01
   IF NOT g_number2 THEN 
   	  LET g_number2 = g_number2 + 1
   END IF 
   LET g_number1 = g_hrce.hrce05 -g_hrce.hrce03 + 1  


            LET g_number3 = 1+(g_number1)*(g_number2-1)
            LET g_number4 = (g_number1)+(g_number1)*(g_number2-1)
            FOR g_i = g_number3 TO g_number4
                LET g_hrcec[g_i].hrcec04 = g_hrceb[l_ac1].hrceb03
                
                IF g_i =  g_number3 THEN 
                   SELECT hrce02,hrce03,hrce04,hrce08
                     INTO g_hrcec[g_i].hrcec03,g_hrcec[g_i].hrcec05,g_hrcec[g_i].hrcec06,l_hrcec10
                     FROM hrce_file
                    WHERE hrce01 = g_hrce.hrce01
                      LET g_hrcec[g_i].hrcec07 = ''
                      LET g_hrcec[g_i].hrcec08 = ''
                END IF 
                 
                IF g_i >  g_number3 AND g_i < g_number4 THEN	 
                   SELECT hrce02,hrce08
                     INTO g_hrcec[g_i].hrcec03,l_hrcec10
                     FROM hrce_file
                    WHERE hrce01 = g_hrce.hrce01
                      LET g_hrcec[g_i].hrcec05 = g_hrcec[g_i-1].hrcec05 + 1
                    #  LET g_hrcec[g_i].hrcec07 = ''                               #marked by yeap NO.130806
                      LET g_hrcec[g_i].hrcec07 = g_hrcec[g_i].hrcec05              #marked by yeap NO.130806    
                      LET g_hrcec[g_i].hrcec08 = ''
                END IF
                      
                IF g_i =  g_number4 THEN	 
                   SELECT hrce02,hrce05,hrce06,hrce08
                     INTO g_hrcec[g_i].hrcec03,g_hrcec[g_i].hrcec07,g_hrcec[g_i].hrcec08,l_hrcec10
                     FROM hrce_file
                    WHERE hrce01 = g_hrce.hrce01
                      LET g_hrcec[g_i].hrcec05 = ''
                      LET g_hrcec[g_i].hrcec06 = ''
                END IF
                      
                          	#add-----NO.130705----begin----
        SELECT hrat01 INTO l_hrat01 FROM hrat_file WHERE hratid = g_hrcec[g_i].hrcec04
           LET g_hrcec[g_i].hrcec04 = l_hrat01
       DISPLAY BY NAME g_hrcec[g_i].hrcec04
     
        SELECT hrbm04 INTO l_hrbm04 FROM hrbm_file
         WHERE hrbm03 = g_hrcec[g_i].hrcec03
           LET l_hrcec03 = g_hrcec[g_i].hrcec03
           LET g_hrcec[g_i].hrcec03 = l_hrbm04

       
       CALL s_code('504',g_hrcec[g_i].hrcec10) RETURNING g_hrag.*
        LET g_hrcec[g_i].hrcec10 = g_hrag.hrag07
        
        SELECT hrat02 INTO g_hrcec[g_i].hrat02_1 #抓取姓名
          FROM hrat_file
         WHERE hrat01 = g_hrcec[g_i].hrcec04 
        
        DISPLAY BY NAME g_hrcec[g_i].hrcec04,g_hrcec[g_i].hrcec03,g_hrcec[g_i].hrcec10,g_hrcec[g_i].hrat02_1      
        
        #add-----NO.130705----end----
               
                   SELECT to_char(max(hrcec02)+1,'fm000000') INTO g_hrcec[g_i].hrcec02 FROM hrcec_file 
                    WHERE hrcec01 = g_hrce.hrce01
                         IF cl_null(g_hrcec[g_i].hrcec02) THEN
                            LET g_hrcec[g_i].hrcec02 =  '000001'
                         END IF
                         	
                      LET g_hrcec[g_i].hrcec16 = "N"

                
            INSERT INTO hrcec_file(hrcec01,hrcec02,hrcec03,hrcec04,hrcec05,hrcec06,
                                 hrcec07,hrcec08,hrcec09,hrcec10,
                                 hrcec11,hrcec12,hrcec13,hrcec14,    #NO.130618
                                 hrcec15,hrcec16)
               VALUES (g_hrce.hrce01,g_hrcec[g_i].hrcec02,l_hrcec03,l_hratid1,
                       g_hrcec[g_i].hrcec05,g_hrcec[g_i].hrcec06,g_hrcec[g_i].hrcec07,g_hrcec[g_i].hrcec08,
                       '0',l_hrcec10,g_hrcec[g_i].hrcec11,g_hrcec[g_i].hrcec12,#NO.130618 NO.130909
                       g_hrcec[g_i].hrcec13,g_hrcec[g_i].hrcec14,g_hrcec[g_i].hrcec15,"N")          
             END FOR 
            #-------------------end-------------------------------#
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b1 = g_rec_b1 + 1
            DISPLAY g_rec_b1 TO FORMONLY.cn2
         END IF

      ON CHANGE hrceb03  #NO.130625
         IF NOT cl_null(g_hrceb[l_ac1].hrceb03) THEN
         	  SELECT hratid
              INTO l_hratid1  #抓取员工ID
              FROM hrat_file
             WHERE hrat01 = g_hrceb[l_ac1].hrceb03
             
            SELECT COUNT(*) INTO l_n FROM hrceb_file
             WHERE hrceb03 = l_hratid1   #NO.130619
               AND hrceb01 = g_hrce.hrce01      #NO.130625
              # AND hrceb04 = l_hratid2   #NO.130619  #NO.130625
              # AND hrceb05 = g_hrceb[l_ac1].hrceb05
             IF l_n > 0 THEN
                  CALL cl_err(g_hrceb[l_ac1].hrceb03,-239,0)
                  LET g_hrceb[l_ac1].hrceb03 = g_hrceb_t.hrceb03
                  NEXT FIELD hrceb03
              END IF
              	#-----------NO.130619------sta-------#
               SELECT hrat04,hrat05,hrat19
                 INTO l_hrat041,l_hrat051,l_hrat19  #抓取中间变量
                 FROM hrat_file
                WHERE hrat01 = g_hrceb[l_ac1].hrceb03
                
               LET g_errno = ''
               SELECT hrat02 
                 INTO g_hrceb[l_ac1].hrat102 #抓取姓名
                 FROM hrat_file
                WHERE hrat01 = g_hrceb[l_ac1].hrceb03

                CASE WHEN SQLCA.SQLCODE = 100   LET  g_errno = 'mfg3006'
                                                LET  g_hrceb[l_ac1].hrat102 = NULL
                     OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                END CASE

                LET g_errno = ''
                SELECT hrao02 INTO g_hrceb[l_ac1].hrao102   #抓取部门名称
                  FROM hrao_file
                 WHERE hrao01 = l_hrat041

                 CASE WHEN SQLCA.SQLCODE = 100   LET  g_errno = 'mfg3006'
                                                 LET  g_hrceb[l_ac1].hrao102 = NULL
                      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                END CASE

                LET g_errno = ''
                SELECT hras04 INTO g_hrceb[l_ac1].hras104   #抓取职位名称
                  FROM hras_file
                 WHERE hras01 = l_hrat051

                 CASE WHEN SQLCA.SQLCODE = 100   LET  g_errno = 'mfg3006'
                                                 LET  g_hrceb[l_ac1].hras104 = NULL
                      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                END CASE

                LET g_errno = ''
                SELECT hrat25 INTO g_hrceb[l_ac1].hrat125   #抓取入司日期
                  FROM hrat_file
                 WHERE hrat01 = g_hrceb[l_ac1].hrceb03

                 CASE WHEN SQLCA.SQLCODE = 100   LET  g_errno = 'mfg3006'
                                                 LET  g_hrceb[l_ac1].hrat125 = NULL
                      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                END CASE

                LET g_errno = ''
                SELECT hrad03 INTO g_hrceb[l_ac1].hrad03   #抓取入司日期
                  FROM hrad_file
                 WHERE hrad02 = l_hrat19

                 CASE WHEN SQLCA.SQLCODE = 100   LET  g_errno = 'mfg3006'
                                                 LET  g_hrceb[l_ac1].hrad03 = NULL
                      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                END CASE

         END IF
 
      AFTER FIELD hrceb05
         IF NOT cl_null(g_hrceb[l_ac1].hrceb05) THEN
            SELECT COUNT(*) INTO l_n FROM hrceb_file
             WHERE hrceb03 = l_hratid1   #NO.130619
               AND hrceb04 = l_hratid2   #NO.130619
               AND hrceb05 = g_hrceb[l_ac1].hrceb05
             IF l_n > 0 THEN
                  CALL cl_err(g_hrceb[l_ac1].hrceb05,-239,0)
                  LET g_hrceb[l_ac1].hrceb05 = g_hrceb_t.hrceb05
                  NEXT FIELD hrceb05
              END IF
         END IF 

     AFTER FIELD hrceb03 
               SELECT hrat04,hrat05,hrat19
                 INTO l_hrat041,l_hrat051,l_hrat19  #抓取中间变量
                 FROM hrat_file
                WHERE hrat01 = g_hrceb[l_ac1].hrceb03
                
               SELECT hrat02 INTO g_hrceb[l_ac1].hrat102 #抓取姓名
                 FROM hrat_file
                WHERE hrat01 = g_hrceb[l_ac1].hrceb03

                SELECT hrao02 INTO g_hrceb[l_ac1].hrao102   #抓取部门名称
                  FROM hrao_file
                 WHERE hrao01 = l_hrat041

                SELECT hras04 INTO g_hrceb[l_ac1].hras104   #抓取职位名称
                  FROM hras_file
                 WHERE hras01 = l_hrat051

                SELECT hrat25 INTO g_hrceb[l_ac1].hrat125   #抓取入司日期
                  FROM hrat_file
                 WHERE hrat01 = g_hrceb[l_ac1].hrceb03
                 
                SELECT hrad03 INTO g_hrceb[l_ac1].hrad03   #抓取员工状态
                  FROM hrad_file
                 WHERE hrad02 = l_hrat19
              
      DISPLAY BY NAME g_hrceb[l_ac1].hrat102,g_hrceb[l_ac1].hrao102,g_hrceb[l_ac1].hras104,
                      g_hrceb[l_ac1].hrat125,g_hrceb[l_ac1].hrad03,g_hrceb[l_ac1].hrao02
               
       AFTER FIELD hrceb04
             SELECT hrat04,hrat05 INTO l_hrat042,l_hrat052 #抓取中间变量
                 FROM hrat_file
                WHERE hrat01 = g_hrceb[l_ac1].hrceb04
                
               SELECT hrat02 INTO g_hrceb[l_ac1].hrat202 #抓取姓名
                 FROM hrat_file
                WHERE hrat01 = g_hrceb[l_ac1].hrceb04

                SELECT hrao02 INTO g_hrceb[l_ac1].hrao202   #抓取部门名称
                  FROM hrao_file
                 WHERE hrao01 = l_hrat042

                SELECT hras04 INTO g_hrceb[l_ac1].hras204   #抓取职位名称
                  FROM hras_file
                 WHERE hras01 = l_hrat052

                SELECT hrat25 INTO g_hrceb[l_ac1].hrat225   #抓取入司日期
                  FROM hrat_file
                 WHERE hrat01 = g_hrceb[l_ac1].hrceb04

                  LET g_errno = ''
               SELECT hrao02 INTO g_hrceb[l_ac1].hrao02 #抓取姓名
                 FROM hrao_file
                WHERE hrat01 = g_hrceb[l_ac1].hrceb05
                
                DISPLAY BY NAME g_hrceb[l_ac1].hrat202,g_hrceb[l_ac1].hrao202,g_hrceb[l_ac1].hras204,g_hrceb[l_ac1].hrat225


    
     BEFORE DELETE 
         DISPLAY "BEFORE DELETE"
         IF NOT cl_null(g_hrceb_t.hrceb02) THEN
            SELECT hrceb01 INTO g_hrceb01 FROM hrceb_file
             WHERE hrceb02 = g_hrceb_t.hrceb02
            SELECT hrceconf INTO l_hrceconf FROM hrce_file
             WHERE hrce01 = g_hrceb01
             
            IF (NOT cl_delete()) OR (l_hrceconf = 'Y') THEN
            	  CALL cl_err('','ghr-106',0)
                CANCEL DELETE
            END IF
            INITIALIZE g_doc.* TO NULL                      #No.130614
            LET g_doc.column1 = "hrceb02"                   #No.130614
                LET g_doc.value1 = g_hrceb[l_ac1].hrceb02   #No.130614
                CALL cl_del_doc() 
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
            DELETE FROM hrceb_file WHERE hrceb01 = g_hrceb01
                                     AND hrceb02 = g_hrceb_t.hrceb02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","hrceb_file",g_hrceb01,g_hrceb_t.hrceb02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            ELSE
            SELECT hratid INTO l_hrceb03_t FROM hrat_file WHERE hrat01 = g_hrceb_t.hrceb03
            DELETE FROM hrcea_file WHERE hrcea01 = g_hrceb01   #NO.130625
                                     AND hrcea13 = l_hrceb03_t
            DELETE FROM hrcec_file WHERE hrcec01 = g_hrceb01
                                     AND hrcec04 = l_hrceb03_t
            END IF 
            	LET g_rec_b1 = g_rec_b1 - 1
           DISPLAY g_rec_b1 TO FORMONLY.cn2
            COMMIT WORK
           MESSAGE 'DELETE O.K'   #NO.130625
     END IF
     

     ON ROW CHANGE
        IF INT_FLAG THEN                 #新增程式段
           CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_hrceb[l_ac1].* = g_hrceb_t.*
          CLOSE i045_bcl1
                ROLLBACK WORK
                EXIT DIALOG
        END IF 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_hrceb[l_ac1].hrceb02,-263,1)
            LET g_hrceb[l_ac1].* = g_hrceb_t.*
         ELSE 
            SELECT hratid
              INTO l_hratid1  #抓取员工ID
              FROM hrat_file
             WHERE hrat01 = g_hrceb[l_ac1].hrceb03
            SELECT hratid
              INTO l_hratid2  #抓取员工ID
              FROM hrat_file
             WHERE hrat01 = g_hrceb[l_ac1].hrceb04
         
            UPDATE hrceb_file
               SET hrceb01 = g_hrce.hrce01,
                   hrceb02 = g_hrceb[l_ac1].hrceb02,
                   hrceb03 = l_hratid1,
                   hrceb04 = l_hratid2,
                   hrceb05 = g_hrceb[l_ac1].hrceb05,
                   hrceb06 = g_hrceb[l_ac1].hrceb06
             WHERE hrceb01 = g_hrce.hrce01
               AND hrceb02 = g_hrceb_t.hrceb02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","hrceb_file",g_hrce.hrce01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660081
               LET g_hrceb[l_ac1].* = g_hrceb_t.*
            ELSE 
            	SELECT hratid INTO g_hrceb_t.hrceb03 FROM hrat_file WHERE hrat01 = g_hrceb_t.hrceb03
            	UPDATE hrcea_file
            	   SET hrcea13 = l_hratid1
            	 WHERE hrcea01 = g_hrce.hrce01
            	   AND hrcea13 = g_hrceb_t.hrceb03
            	   
            	UPDATE hrcec_file
            	   SET hrcec04 = l_hratid1
            	 WHERE hrcec01 = g_hrce.hrce01
            	   AND hrcec04 = g_hrceb_t.hrceb03
               MESSAGE 'UPDATE O.K'
                COMMIT WORK
            END IF
         END IF

      AFTER ROW
         DISPLAY  "AFTER ROW!!"
         LET l_ac1 = ARR_CURR()

          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
              LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_hrceb[l_ac1].* = g_hrceb_t.*
               END IF 
             CLOSE i045_bcl1
             ROLLBACK WORK
             EXIT DIALOG
         END IF
         CLOSE i045_bcl1
         COMMIT WORK

      AFTER INPUT 
         IF cl_null(g_hrceb[l_ac1].hrceb02) THEN 
      # CALL cl_err('','cxm-013',1) #NO.130617
            CONTINUE DIALOG
        END IF  

      ON ACTION CONTROLO                       #沿用所有欄位
         IF l_ac1 > 1 THEN
            LET g_hrceb[l_ac1].* = g_hrceb[l_ac1-1].*
            NEXT FIELD hrceb02
         END IF

      ON ACTION controlp
         CASE
           WHEN INFIELD(hrceb03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrat"
              LET g_qryparam.default1 = g_hrceb[l_ac1].hrceb03
              CALL cl_create_qry() RETURNING g_hrceb[l_ac1].hrceb03 
              DISPLAY BY NAME g_hrceb[l_ac1].hrceb03
              NEXT FIELD hrceb03
              
           WHEN INFIELD(hrceb04)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrat"
              LET g_qryparam.default1 = g_hrceb[l_ac1].hrceb04
              CALL cl_create_qry() RETURNING g_hrceb[l_ac1].hrceb04
              DISPLAY BY NAME g_hrceb[l_ac1].hrceb04
              NEXT FIELD hrceb04

           WHEN INFIELD(hrceb05)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrao01"
              LET g_qryparam.state = "c" 
              LET g_qryparam.default1 = g_hrceb[l_ac1].hrceb05
              CALL cl_create_qry() RETURNING g_hrceb[l_ac1].hrceb05
              DISPLAY BY NAME g_hrceb[l_ac1].hrceb05
              NEXT FIELD hrceb05
            OTHERWISE
               EXIT CASE
         END CASE

      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
   
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
         
     ON ACTION controls                                                                   
         CALL cl_set_head_visible("","AUTO") 

    
     UPDATE hrce_file SET hrcemodu = g_hrce.hrcemodu,hrcedate = g_hrce.hrcedate
      WHERE hrce01 = g_hrce.hrce01
    DISPLAY BY NAME g_hrce.hrcemodu,g_hrce.hrcedate

    CLOSE i045_bcl1
    COMMIT WORK
         
   END INPUT

        INPUT ARRAY g_hrcea FROM s_hrcea.*
              ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS = TRUE,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

        BEFORE INPUT
            DISPLAY "BEFORE INPUT!"
            IF g_rec_b2 != 0 THEN
               CALL fgl_set_arr_curr(l_ac2)
           END IF

        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd=''
           LET l_ac2 = ARR_CURR()
           LET l_lock_sw = 'N'              #DEFAULT
           LET l_n  = ARR_COUNT()

        BEGIN WORK

         OPEN i045_lock_u USING g_hrce.hrce01
           IF STATUS THEN
              CALL cl_err("OPEN i045_lock_u:", STATUS, 1)
              CLOSE i045_lock_u
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i045_lock_u INTO g_hrce.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_hrce.hrce01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE i045_lock_u
              ROLLBACK WORK
              RETURN
           END IF

            IF g_rec_b2 >= l_ac2 THEN
            LET p_cmd='u'
            LET g_before_input_done = FALSE                                  
           CALL i045_set_entry(p_cmd)                                       
           CALL i045_set_no_entry(p_cmd)                                    
            LET g_before_input_done = TRUE 
            LET g_hrcea_t.* = g_hrcea[l_ac2].*    #BACKUP
            
            OPEN i045_bcl2 USING g_hrce.hrce01,g_hrcea_t.hrcea02     #NO.130619
            IF STATUS THEN
               CALL cl_err("OPEN i045_bcl2:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH i045_bcl2 INTO g_hrcea[l_ac2].*                 #NO.130619
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_hrcea01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
          #NO.130619
          SELECT hratid INTO l_hratid
            FROM hrat_file
           WHERE hratid = g_hrcea[l_ac2].hrcea13
           
         #NO.130619------sta------#
    SELECT hrat02 INTO g_hrcea[l_ac2].hrat02
      FROM hrat_file
     WHERE hratid = g_hrcea[l_ac2].hrcea13
     DISPLAY BY NAME g_hrcea[l_ac2].hrat02

      CASE WHEN SQLCA.SQLCODE = 100   LET  g_errno = 'mfg3006'
                                      LET  g_hrcea[l_ac2].hrat02 = NULL
                   OTHERWISE          LET  g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    #----------end-----------#
            END IF
            CALL cl_show_fld_cont()     #NO.130626
          END IF
          
      BEFORE INSERT
         DISPLAY "BEFORE INSERT!"
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         LET g_before_input_done = FALSE                                  
        CALL i045_set_entry(p_cmd)                                       
        CALL i045_set_no_entry(p_cmd)                                    
         LET g_before_input_done = TRUE 
         INITIALIZE g_hrcea[l_ac2].* TO NULL       #900423
         LET g_hrcea_t.* = g_hrcea[l_ac2].*          #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         
         SELECT count(*) INTO l_cnt FROM hrcea_file  #NO.130625
         WHERE hrcea01 = g_hrce.hrce01
           AND hrcea04 = g_hrcea[l_ac2].hrcea04 
           AND hrcea13 = l_hratid    #NO.130619
            IF l_cnt > 0 THEN 
               CALL cl_err3("ins","hrce_file",g_hrce.hrce01,g_hrcea[l_ac2].hrcea02,SQLCA.sqlcode,"","",0) 
            ELSE 
               SELECT to_char(max(hrcea02)+1,'fm000000') INTO g_hrcea[l_ac2].hrcea02 FROM hrcea_file WHERE hrcea01 = g_hrce.hrce01
                   IF cl_null(g_hrcea[l_ac2].hrcea02) THEN
                      LET g_hrcea[l_ac2].hrcea02 =  '000001'
                   END IF
            END IF 
         NEXT FIELD hrcea03
 
      AFTER INSERT
         DISPLAY "AFTER INSERT!"
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF

         
          INSERT INTO hrcea_file(hrcea01,hrcea02,hrcea03,hrcea04,hrcea05,hrcea06,hrcea07,
                                 hrcea08,hrcea09,hrcea10,hrcea11,hrcea12,hrcea13)
               VALUES (g_hrce.hrce01,g_hrcea[l_ac2].hrcea02,g_hrcea[l_ac2].hrcea03,
                       g_hrcea[l_ac2].hrcea04,g_hrcea[l_ac2].hrcea05,g_hrcea[l_ac2].hrcea06,
                       g_hrcea[l_ac2].hrcea07,g_hrcea[l_ac2].hrcea08,g_hrcea[l_ac2].hrcea09,
                       g_hrcea[l_ac2].hrcea10,g_hrcea[l_ac2].hrcea11,g_hrcea[l_ac2].hrcea12,
                       g_hrcea[l_ac2].hrcea13)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrcea_file",g_hrce.hrce01,g_hrcea[l_ac2].hrcea02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b2 = g_rec_b2 + 1
            LET g_sum = g_sum + g_hrcea[l_ac2].hrcea11
        DISPLAY g_rec_b2 TO FORMONLY.cn2
         END IF 

      AFTER FIELD hrcea05
         IF NOT cl_null(g_hrcea[l_ac2].hrcea05) THEN
         	  SELECT MAX(hrcea05),MAX(hrcea06) INTO l_hrcea05,l_hrcea06
         	    FROM hrcea_file
             WHERE hrcea01 = g_hrce.hrce01
               AND hrcea13 = g_hrcea[l_ac2].hrcea13
             GROUP BY hrcea01
            IF NOT cl_null(l_hrcea05) AND cl_null(l_hrcea06) THEN 
             IF g_hrcea[l_ac2].hrcea05 > l_hrcea05 AND g_hrcea[l_ac2].hrcea05 < l_hrcea06 THEN
             	   CALL cl_err('','ghr-117',0)
             	   NEXT FIELD hrcea05
             END IF
            END IF 
            	 
             IF g_hrcea[l_ac2].hrcea05 > g_hrcea[l_ac2].hrcea06 THEN 
             	  CALL cl_err('','ghr-118',0)
             	  NEXT FIELD hrcea05
             END IF 
             	
             SELECT hrcd02,hrcd04 INTO l_hrcd02,l_hrcd04
               FROM hrcd_file
              WHERE hrcd09 = g_hrcea[l_ac2].hrcea13
              IF NOT cl_null(l_hrcd02) AND cl_null(l_hrcd04) THEN 
                 IF g_hrcea[l_ac2].hrcea05 < g_hrce.hrce03 OR g_hrcea[l_ac2].hrcea05 >g_hrce.hrce05 OR g_hrcea[l_ac2].hrcea05 < l_hrcd02 OR g_hrcea[l_ac2].hrcea05 > l_hrcd04 THEN 
                  	LET g_sql = "请假开始时间：",l_hrcd02,"请假结束时间：",l_hrcd04
                  	CALL cl_err3("ins","hrcea_file",g_hrce.hrce01,g_sql,'ghr-112',"","",0)
                  	NEXT FIELD hrcea05
                 END IF 
              ELSE 
              	 IF g_hrcea[l_ac2].hrcea05 < g_hrce.hrce03 OR g_hrcea[l_ac2].hrcea05 >g_hrce.hrce05 THEN 
                  	CALL cl_err3("ins","hrcea_file","","",'ghr-112',"","",0)
               	    NEXT FIELD hrcea05
                 END IF 
              END IF          
         END IF
 
      AFTER FIELD hrcea06
         IF NOT cl_null(g_hrcea[l_ac2].hrcea06) THEN
         	  SELECT MAX(hrcea05),MAX(hrcea06) INTO l_hrcea05,l_hrcea06
         	    FROM hrcea_file
             WHERE hrcea01 = g_hrce.hrce01
               AND hrcea13 = g_hrcea[l_ac2].hrcea13
             GROUP BY hrcea01
            IF NOT cl_null(l_hrcea05) AND cl_null(l_hrcea06) THEN 
             IF g_hrcea[l_ac2].hrcea06 > l_hrcea05 AND g_hrcea[l_ac2].hrcea06 < l_hrcea06 THEN
             	   CALL cl_err('','ghr-117',0)
             	   NEXT FIELD hrcea05
             END IF
            END IF 
            	 
             IF g_hrcea[l_ac2].hrcea05 > g_hrcea[l_ac2].hrcea06 THEN 
             	  CALL cl_err('','ghr-118',0)
             	  NEXT FIELD hrcea05
             END IF 
             	
             SELECT hrcd02,hrcd04 INTO l_hrcd02,l_hrcd04
               FROM hrcd_file
              WHERE hrcd09 = g_hrcea[l_ac2].hrcea13
              IF NOT cl_null(l_hrcd02) AND cl_null(l_hrcd04) THEN 
                 IF g_hrcea[l_ac2].hrcea06 < g_hrce.hrce03 OR g_hrcea[l_ac2].hrcea06 >g_hrce.hrce05 OR g_hrcea[l_ac2].hrcea06 < l_hrcd02 OR g_hrcea[l_ac2].hrcea06 > l_hrcd04 THEN 
                  	LET g_sql = "请假开始时间：",l_hrcd02,"请假结束时间：",l_hrcd04
                  	CALL cl_err3("ins","hrcea_file",g_hrce.hrce01,g_sql,'ghr-112',"","",0)
                  	NEXT FIELD hrcea05
                 END IF 
              ELSE 
              	 IF g_hrcea[l_ac2].hrcea06 < g_hrce.hrce03 OR g_hrcea[l_ac2].hrcea06 >g_hrce.hrce05 THEN 
                  	CALL cl_err3("ins","hrcea_file","","",'ghr-112',"","",0)
               	    NEXT FIELD hrcea05
                 END IF 
              END IF          
         END IF
 
      BEFORE DELETE                            #是否取消單身
         DISPLAY "BEFORE DELETE"
         IF NOT cl_null(g_hrcea_t.hrcea02) THEN
            SELECT hrcea01 INTO g_hrcea01 FROM hrcea_file
             WHERE hrcea02 = g_hrcea_t.hrcea02
            SELECT hrceconf INTO l_hrceconf FROM hrce_file
             WHERE hrce01 = g_hrcea01
            IF (NOT cl_delete()) OR (l_hrceconf = 'Y') THEN
            	 CALL cl_err('','ghr-106',0)
               CANCEL DELETE
            END IF
            INITIALIZE g_doc.* TO NULL               #No.130614
            LET g_doc.column1 = "hrcea02"               
            LET g_doc.value1 = g_hrcea[l_ac2].hrcea02     
            CALL cl_del_doc()
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
            DELETE FROM hrcea_file WHERE hrcea01 = g_hrce.hrce01
                                     AND hrcea02 = g_hrcea[l_ac2].hrcea02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","hrcea_file",g_hrcea01,g_hrcea_t.hrcea02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               CANCEL DELETE
            END IF 
            LET g_rec_b2 = g_rec_b2 - 1
        DISPLAY g_rec_b2 TO FORMONLY.cn2
         END IF
         COMMIT WORK
         MESSAGE 'DELETE O.K'

      ON ROW CHANGE
         IF INT_FLAG THEN                 #新增程式段
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_hrcea[l_ac2].* = g_hrcea_t.*
            CLOSE i045_bcl2
            ROLLBACK WORK
            EXIT DIALOG
         END IF      
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_hrcea[l_ac2].hrcea02,-263,1)
            LET g_hrcea[l_ac2].* = g_hrcea_t.*
         ELSE 
            SELECT hratid INTO l_hratid
              FROM hrat_file
             WHERE hrat01 = g_hrcea[l_ac2].hrcea13
         
            UPDATE hrcea_file
               SET hrcea03 = g_hrcea[l_ac2].hrcea03,
                   hrcea04 = g_hrcea[l_ac2].hrcea04,
                   hrcea05 = g_hrcea[l_ac2].hrcea05,
                   hrcea06 = g_hrcea[l_ac2].hrcea06,
                   hrcea07 = g_hrcea[l_ac2].hrcea07,
                   hrcea08 = g_hrcea[l_ac2].hrcea08,
                   hrcea09 = g_hrcea[l_ac2].hrcea09,
                   hrcea10 = g_hrcea[l_ac2].hrcea10,
                   hrcea11 = g_hrcea[l_ac2].hrcea11,
                   hrcea12 = g_hrcea[l_ac2].hrcea12,
                   hrcea13 = g_hrcea[l_ac2].hrcea13
             WHERE hrcea01 = g_hrce.hrce01
               AND hrcea02 = g_hrcea_t.hrcea02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","hrcea_file",g_hrce.hrce01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660081
               LET g_hrcea[l_ac2].* = g_hrcea_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
         
      AFTER ROW
         DISPLAY  "AFTER ROW!!"
         LET l_ac2 = ARR_CURR()
  #       LET l_ac_t = l_ac2
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
              LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_hrcea[l_ac2].* = g_hrcea_t.*
               END IF 
               CLOSE i045_bcl2
               ROLLBACK WORK
               EXIT DIALOG
          END IF
          CLOSE i045_bcl2
          COMMIT WORK

      AFTER INPUT 
         IF cl_null(g_hrcea[l_ac2].hrcea02) THEN 
      # CALL cl_err('','cxm-013',1)  #NO.130617
            CONTINUE DIALOG
        END IF 

 
      ON ACTION CONTROLO                       #沿用所有欄位
         IF l_ac2 > 1 THEN
            LET g_hrcea[l_ac2].* = g_hrcea[l_ac2-1].*
            NEXT FIELD hrcea02
         END IF

      ON ACTION controlp
         CASE
           WHEN INFIELD(hrcea13)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrat"
              LET g_qryparam.default1 = g_hrcea[l_ac2].hrcea13
              CALL cl_create_qry() RETURNING g_hrcea[l_ac2].hrcea13 
              DISPLAY BY NAME g_hrcea[l_ac2].hrcea13
              NEXT FIELD hrcea13
            OTHERWISE
               EXIT CASE
         END CASE

 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
   
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
         
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO") 


     UPDATE hrce_file SET hrcemodu = g_hrce.hrcemodu,hrcedate = g_hrce.hrcedate
      WHERE hrce01 = g_hrce.hrce01
    DISPLAY BY NAME g_hrce.hrcemodu,g_hrce.hrcedate

    CLOSE i045_bcl2
    COMMIT WORK
    
END INPUT
    
        INPUT ARRAY g_hrcec FROM s_hrcec.*
              ATTRIBUTE(COUNT=g_rec_b3,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS = TRUE,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT                   
         DISPLAY "BEFORE INPUT!"
         IF g_rec_b3 != 0 THEN
            CALL fgl_set_arr_curr(l_ac3)
         END IF
      
      BEFORE ROW
         DISPLAY "BEFORE ROW!"
         LET p_cmd=''
         LET l_ac3 = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()

         BEGIN WORK

           OPEN i045_lock_u USING g_hrce.hrce01
           IF STATUS THEN
              CALL cl_err("OPEN i045_lock_u:", STATUS, 1)
              CLOSE i045_lock_u
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i045_lock_u INTO g_hrce.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_hrce.hrce01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE i045_lock_u
              ROLLBACK WORK
              RETURN
           END IF
           
         IF g_rec_b3 >= l_ac3 THEN
            LET p_cmd='u'
            LET g_before_input_done = FALSE                                  
            CALL i045_set_entry(p_cmd)                                       
            CALL i045_set_no_entry(p_cmd)                                    
            LET g_before_input_done = TRUE 
            LET g_hrcec_t.* = g_hrcec[l_ac3].*    #BACKUP
            
            OPEN i045_bcl3 USING g_hrce.hrce01,g_hrcec_t.hrcec02     #NO.130619
            IF STATUS THEN
               CALL cl_err("OPEN i045_bcl3:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH i045_bcl3 INTO g_hrcec[l_ac3].*   #NO.130624
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_hrcec01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               SELECT hrat02 INTO g_hrcec[l_ac3].hrat02_1 FROM hrat_file WHERE hratid = g_hrcec[l_ac3].hrcec04
               CALL s_code('504',g_hrcec[l_ac3].hrcec10) RETURNING g_hrag.*
               LET l_hrcec10_c = g_hrcec[l_ac3].hrcec10
               LET g_hrcec[l_ac3].hrcec10 = g_hrag.hrag07
               LET l_hrcec03_c = g_hrcec[l_ac3].hrcec03
               
               SELECT hrbm04 INTO g_hrcec[l_ac3].hrcec03 FROM hrbm_file
               WHERE hrbm03 = g_hrcec[l_ac3].hrcec03
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
          END IF
          
      BEFORE INSERT
         DISPLAY "BEFORE INSERT!"
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         LET g_before_input_done = FALSE
         CALL i045_set_entry(p_cmd)
         CALL i045_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         INITIALIZE g_hrcec[l_ac3].* TO NULL
         LET g_hrcec_t.* = g_hrcec[l_ac3].*
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD hrcec04
 
      AFTER INSERT
         DISPLAY "AFTER INSERT!"
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         	
         	FOR g_i = 1 TO (g_number1)+(g_number1)*(g_number2-1)
          INSERT INTO hrcec_file(hrcec01,hrcec02,hrcec03,hrcec04,hrcec05,hrcec06,
                                 hrcec07,hrcec08,hrcec09,hrcec10,
                                 hrcec11,hrcec12,hrcec13,hrcec14,    #NO.130618
                                 hrcec15,hrcec16)
               VALUES (g_hrce.hrce01,g_hrcec[l_ac3].hrcec02,g_hrcec[l_ac3].hrcec03,g_hrcec[l_ac3].hrcec04,
                       g_hrcec[l_ac3].hrcec05,g_hrcec[l_ac3].hrcec06,g_hrcec[l_ac3].hrcec07,g_hrcec[l_ac3].hrcec08,
                       '0',l_hrcec10,g_hrcec[l_ac3].hrcec11,g_hrcec[l_ac3].hrcec12,#NO.130618 No.130909
                       g_hrcec[l_ac3].hrcec13,g_hrcec[l_ac3].hrcec14,g_hrcec[l_ac3].hrcec15,"N")
           
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrce_file",g_hrce.hrce01,g_hrcec[l_ac3].hrcec02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b3 = g_rec_b3 + 1
            DISPLAY g_rec_b3 TO FORMONLY.cn2
         END IF
         END FOR
         
         ON CHANGE hrcec03   #NO.130625
         IF NOT cl_null(g_hrcec[l_ac3].hrcec03) THEN 
         	  SELECT COUNT (*) INTO l_n FROM hrcec_file
         	   WHERE hrcec04 = g_hrcec[l_ac3].hrcec04
         	     AND hrcec03 = g_hrcec[l_ac3].hrcec03 
         	     IF l_n > 0 THEN 
         	     SELECT COUNT (*) INTO l_n FROM hrcec_file
         	      WHERE hrcec03 = g_hrcec[l_ac3].hrcec03
         	        AND hrcec04 = g_hrcec[l_ac3].hrcec04
         	        AND hrcec05 = g_hrcec[l_ac3].hrcec05
         	        AND hrcec06 = g_hrcec[l_ac3].hrcec06
         	         IF l_n > 0 THEN 
         	            CALL cl_err('','ghr-080',0)
         	            NEXT FIELD hrcec04
         	         ELSE 
         	         SELECT to_char(max(hrcec02)+1,'fm000000') INTO g_hrcec[l_ac3].hrcec02 FROM hrcec_file 
                       IF cl_null(g_hrcec[l_ac3].hrcec02) THEN
                          LET g_hrcec[l_ac3].hrcec02 =  '000001'
                       END IF
         	         	   DISPLAY BY NAME g_hrcec[l_ac3].hrcec02
                   END IF
               END IF
         END IF 
          	
         ON CHANGE hrcec04   #NO.130625
         IF NOT cl_null(g_hrcec[l_ac3].hrcec04) THEN 
         	  SELECT COUNT (*) INTO l_n FROM hrcec_file
         	   WHERE hrcec04 = g_hrcec[l_ac3].hrcec04
         	     AND hrcec03 = g_hrcec[l_ac3].hrcec03 
         	     IF l_n > 0 THEN 
         	     SELECT COUNT (*) INTO l_n FROM hrcec_file
         	      WHERE hrcec03 = g_hrcec[l_ac3].hrcec03
         	        AND hrcec04 = g_hrcec[l_ac3].hrcec04
         	        AND hrcec05 = g_hrcec[l_ac3].hrcec05
         	        AND hrcec06 = g_hrcec[l_ac3].hrcec06
         	         IF l_n > 0 THEN 
         	            CALL cl_err('','ghr-080',0)
         	            NEXT FIELD hrcec04
         	         ELSE 
         	         SELECT to_char(max(hrcec02)+1,'fm000000') INTO g_hrcec[l_ac3].hrcec02 FROM hrcec_file 
                       IF cl_null(g_hrcec[l_ac3].hrcec02) THEN
                          LET g_hrcec[l_ac3].hrcec02 =  '000001'
                       END IF
         	         	   DISPLAY BY NAME g_hrcec[l_ac3].hrcec02
                   END IF
               END IF
         END IF 
          	
         ON CHANGE hrcec05   #NO.130625
         IF NOT cl_null(g_hrcec[l_ac3].hrcec05) THEN 
         	  SELECT COUNT (*) INTO l_n FROM hrcec_file
         	   WHERE hrcec04 = g_hrcec[l_ac3].hrcec04
         	     AND hrcec03 = g_hrcec[l_ac3].hrcec03 
         	     IF l_n > 0 THEN 
         	     SELECT COUNT (*) INTO l_n FROM hrcec_file
         	      WHERE hrcec03 = g_hrcec[l_ac3].hrcec03
         	        AND hrcec04 = g_hrcec[l_ac3].hrcec04
         	        AND hrcec05 = g_hrcec[l_ac3].hrcec05
         	        AND hrcec06 = g_hrcec[l_ac3].hrcec06
         	         IF l_n > 0 THEN 
         	            CALL cl_err('','ghr-080',0)
         	            NEXT FIELD hrcec04
         	         ELSE 
         	         SELECT to_char(max(hrcec02)+1,'fm000000') INTO g_hrcec[l_ac3].hrcec02 FROM hrcec_file 
                       IF cl_null(g_hrcec[l_ac3].hrcec02) THEN
                          LET g_hrcec[l_ac3].hrcec02 =  '000001'
                       END IF
         	         	   DISPLAY BY NAME g_hrcec[l_ac3].hrcec02
                   END IF
               END IF
         END IF
          	
         ON CHANGE hrcec06   #NO.130625
         IF NOT cl_null(g_hrcec[l_ac3].hrcec06) THEN 
         	  SELECT COUNT (*) INTO l_n FROM hrcec_file
         	   WHERE hrcec04 = g_hrcec[l_ac3].hrcec04
         	     AND hrcec03 = g_hrcec[l_ac3].hrcec03 
         	     IF l_n > 0 THEN 
         	     SELECT COUNT (*) INTO l_n FROM hrcec_file
         	      WHERE hrcec03 = g_hrcec[l_ac3].hrcec03
         	        AND hrcec04 = g_hrcec[l_ac3].hrcec04
         	        AND hrcec05 = g_hrcec[l_ac3].hrcec05
         	        AND hrcec06 = g_hrcec[l_ac3].hrcec06
         	         IF l_n > 0 THEN 
         	            CALL cl_err('','ghr-080',0)
         	            NEXT FIELD hrcec04
         	         ELSE 
         	         SELECT to_char(max(hrcec02)+1,'fm000000') INTO g_hrcec[l_ac3].hrcec02 FROM hrcec_file 
                       IF cl_null(g_hrcec[l_ac3].hrcec02) THEN
                          LET g_hrcec[l_ac3].hrcec02 =  '000001'
                       END IF
         	         	   DISPLAY BY NAME g_hrcec[l_ac3].hrcec02
                   END IF
               END IF
         END IF  	
                
         
      BEFORE DELETE                            #是否取消單身
         DISPLAY "BEFORE DELETE"
         IF NOT cl_null(g_hrcec_t.hrcec02) THEN
            SELECT hrcec01 INTO g_hrcec01 FROM hrcec_file
             WHERE hrcec02 = g_hrcec_t.hrcec02
            SELECT hrceconf INTO l_hrceconf FROM hrce_file
             WHERE hrce01 = g_hrcec01
            IF (NOT cl_delete()) OR (l_hrceconf = 'Y') THEN
            	 CALL cl_err('','ghr-106',0)
               CANCEL DELETE
            END IF
            INITIALIZE g_doc.* TO NULL               #  No.130614
            LET g_doc.column1 = "hrcec02"               
            LET g_doc.value1 = g_hrcec[l_ac3].hrcec02   
            CALL cl_del_doc()
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
            DELETE FROM hrcec_file WHERE hrcec01 = g_hrce.hrce01
                                     AND hrcec02 = g_hrcec[l_ac3].hrcec02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","hrcec_file",g_hrcec01,g_hrcec_t.hrcec02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF 
            LET g_rec_b3 = g_rec_b3 - 1
        DISPLAY g_rec_b3 TO FORMONLY.cn2
         END IF
         COMMIT WORK
         MESSAGE 'DELETE O.K'
         
      ON ROW CHANGE
         IF INT_FLAG THEN                 #新增程式段
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_hrcec[l_ac3].* = g_hrcec_t.*
            CLOSE i045_bcl3
            ROLLBACK WORK
            EXIT DIALOG
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_hrcec[l_ac3].hrcec02,-263,1)
            LET g_hrcec[l_ac3].* = g_hrcec_t.*
         ELSE 
            UPDATE hrcec_file
               SET hrcec03 = l_hrcec03_c,
                   hrcec04 = g_hrcec[l_ac3].hrcec04,
                   hrcec05 = g_hrcec[l_ac3].hrcec05,
                   hrcec06 = g_hrcec[l_ac3].hrcec06,
                   hrcec07 = g_hrcec[l_ac3].hrcec07,
                   hrcec08 = g_hrcec[l_ac3].hrcec08,
                   hrcec09 = g_hrcec[l_ac3].hrcec09,
                   hrcec10 = l_hrcec10_c,
                   hrcec11 = g_hrcec[l_ac3].hrcec11,
                   hrcec12 = g_hrcec[l_ac3].hrcec12,
                   hrcec13 = g_hrcec[l_ac3].hrcec13,
                   hrcec14 = g_hrcec[l_ac3].hrcec14,
                   hrcec15 = g_hrcec[l_ac3].hrcec15,
                   hrcec16 = g_hrcec[l_ac3].hrcec16
             WHERE hrcec01 = g_hrce.hrce01
               AND hrcec02 = g_hrcec_t.hrcec02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","hrcec_file",g_hrcec01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660081
               LET g_hrcec[l_ac3].* = g_hrcec_t.*
          ELSE 
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
         
      AFTER ROW
         LET l_ac3 = ARR_CURR()
      #   LET l_ac_t = l_ac3
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_hrcec[l_ac3].* = g_hrcec_t.*
              END IF 
            CLOSE i045_bcl3
            ROLLBACK WORK
            EXIT DIALOG
         END IF
         CLOSE i045_bcl3
         COMMIT WORK
 
      ON ACTION CONTROLO                       #沿用所有欄位
         IF l_ac3 > 1 THEN
            LET g_hrcec[l_ac3].* = g_hrcec[l_ac3-1].*
            NEXT FIELD hrcec02
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
   
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
         
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO") 

        

    UPDATE hrce_file SET hrcemodu = g_hrce.hrcemodu,hrcedate = g_hrce.hrcedate
      WHERE hrce01 = g_hrce.hrce01
    DISPLAY BY NAME g_hrce.hrcemodu,g_hrce.hrcedate

    CLOSE i045_bcl3
    COMMIT WORK
END INPUT 
    
       # BEFORE DIALOG
       # 
       #   OPEN i045_lock_u USING g_hrce.hrce01
       #     IF STATUS THEN 
       #        CALL cl_err("ONPEN i045_lock_u:",STATUS,0)
       #        LET INT_FLAG = 1
       #        EXIT DIALOG
       #    END IF   
       #  FETCH i045_lock_u INTO g_hrce.*
       #     IF SQLCA.sqlcode THEN 
       #        CALL cl_err("fetch i045_lock_u:",SQLCA.sqlcode,0)
       #        LET INT_FLAG = 1
       #        EXIT DIALOG
       #    END IF 
        
        
        ON ACTION accept    
             ACCEPT DIALOG
           
        ON ACTION cancel
           LET INT_FLAG = 1
           EXIT DIALOG 
           
        ON ACTION controlg
           CALL cl_cmdask()
        
        ON ACTION about         
         CALL cl_about()
         
        ON ACTION help         
         CALL cl_show_help()
         
END DIALOG
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLOSE i045_lock_u  
       RETURN 
    END IF
    
    CLOSE i045_lock_u 

END FUNCTION

FUNCTION i045_b_fill(p_wc)   #gai   youwenti         #BODY FILL UP
 
   DEFINE p_wc         STRING #No.FUN-680135 VARCHAR(300)

 
     CALL i045_hrceb(g_hrce.hrce01,p_wc)
     CALL i045_hrcea(g_hrce.hrce01,p_wc)
     CALL i045_hrcec(g_hrce.hrce01,p_wc)

END FUNCTION

FUNCTION i045_hrceb(l_hrceb01,p_wc)
    DEFINE   p_wc            STRING
    DEFINE   l_hrceb01       LIKE hrceb_file.hrceb01
    DEFINE   l_hrat041        LIKE hrat_file.hrat04   #NO.130619
    DEFINE   l_hrat051        LIKE hrat_file.hrat05   #NO.130619
    DEFINE   l_hrat19        LIKE hrat_file.hrat19   #NO.130619
    DEFINE   l_hrat042        LIKE hrat_file.hrat04   #NO.130619
    DEFINE   l_hrat052        LIKE hrat_file.hrat05   #NO.130619
    DEFINE   l_hrat01        LIKE hrat_file.hrat01   #NO.130705

    IF cl_null(l_hrceb01) THEN 
       RETURN 
    END IF

   LET g_sql1= "SELECT hrceb02,hrceb03,'','','','','',",
                "hrceb04,'','','','',hrceb05,'',hrceb06 ",
                " FROM hrceb_file ",
                " WHERE hrceb01 = '", l_hrceb01 CLIPPED,"' ",
         #       " AND ",p_wc CLIPPED,   #NO.130617
                " ORDER BY hrceb02"
    PREPARE i045_prepare2 FROM g_sql1           #預備一下
    DECLARE hrceb_curs CURSOR FOR i045_prepare2

    CALL g_hrceb.clear()

    LET g_cnt = 1
    LET g_rec_b1 = 0
    
    FOREACH hrceb_curs INTO g_hrceb[g_cnt].*
        LET g_rec_b1 = g_rec_b1 + 1
         IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        
        #-------NO.130619----sta------#
        
        #add-----NO.130705----begin----
        SELECT hrat01 INTO l_hrat01 FROM hrat_file WHERE hratid = g_hrceb[g_cnt].hrceb03
        LET g_hrceb[g_cnt].hrceb03 = l_hrat01
        DISPLAY BY NAME g_hrceb[g_cnt].hrceb03
        #add-----NO.130705----end----
        
        
               SELECT hrat04,hrat05,hrat19
                 INTO l_hrat041,l_hrat051,l_hrat19  #抓取中间变量
                 FROM hrat_file
                WHERE hrat01 = g_hrceb[g_cnt].hrceb03
                
               SELECT hrat02 INTO g_hrceb[g_cnt].hrat102 #抓取姓名
                 FROM hrat_file
                WHERE hrat01 = g_hrceb[g_cnt].hrceb03

                SELECT hrao02 INTO g_hrceb[g_cnt].hrao102   #抓取部门名称
                  FROM hrao_file
                 WHERE hrao01 = l_hrat041

                SELECT hras04 INTO g_hrceb[g_cnt].hras104   #抓取职位名称
                  FROM hras_file
                 WHERE hras01 = l_hrat051

                SELECT hrat25 INTO g_hrceb[g_cnt].hrat125   #抓取入司日期
                  FROM hrat_file
                 WHERE hrat01 = g_hrceb[g_cnt].hrceb03
                 
                SELECT hrad03 INTO g_hrceb[g_cnt].hrad03   #抓取员工状态
                  FROM hrad_file
                 WHERE hrad02 = l_hrat19

                 
               SELECT hrat04,hrat05 INTO l_hrat042,l_hrat052 #抓取中间变量
                 FROM hrat_file
                WHERE hrat01 = g_hrceb[g_cnt].hrceb04
                
               SELECT hrat02 INTO g_hrceb[g_cnt].hrat202 #抓取姓名
                 FROM hrat_file
                WHERE hrat01 = g_hrceb[g_cnt].hrceb04

                SELECT hrao02 INTO g_hrceb[g_cnt].hrao202   #抓取部门名称
                  FROM hrao_file
                 WHERE hrao01 = l_hrat042

                SELECT hras04 INTO g_hrceb[g_cnt].hras204   #抓取职位名称
                  FROM hras_file
                 WHERE hras01 = l_hrat052

                SELECT hrat25 INTO g_hrceb[g_cnt].hrat225   #抓取入司日期
                  FROM hrat_file
                 WHERE hrat01 = g_hrceb[g_cnt].hrceb04

                  LET g_errno = ''
               SELECT hrao02 INTO g_hrceb[g_cnt].hrao02 #抓取姓名
                 FROM hrat_file
                WHERE hrat01 = g_hrceb[g_cnt].hrceb05
                
      DISPLAY BY NAME g_hrceb[g_cnt].hrat102,g_hrceb[g_cnt].hrao102,g_hrceb[g_cnt].hras104,
                      g_hrceb[g_cnt].hrat125,g_hrceb[g_cnt].hrad03,g_hrceb[g_cnt].hrao02,
                      g_hrceb[g_cnt].hrat202,g_hrceb[g_cnt].hrao202,g_hrceb[g_cnt].hras204,g_hrceb[g_cnt].hrat225
               #--------end--------# 
        LET g_cnt = g_cnt + 1
         IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
         END IF
         
    END FOREACH 
    CALL g_hrceb.deleteElement(g_cnt)
    DISPLAY ARRAY g_hrceb TO s_hrceb.* ATTRIBUTE(COUNT=g_rec_b1)
        BEFORE DISPLAY
            EXIT DISPLAY 
        END DISPLAY 
    
   LET g_rec_b1 = g_cnt - 1
  # IF INFIELD(hrceb) THEN        #NO.130618
  #    DISPLAY NULL TO FORMONLY.cn2
      DISPLAY g_rec_b1 TO FORMONLY.cn2
  # END IF  
   LET g_cnt = 0
   
END FUNCTION 

FUNCTION i045_hrcea(l_hrcea01,p_wc)
    DEFINE  p_wc         STRING
    DEFINE  l_hrcea01    LIKE hrcea_file.hrcea01
    DEFINE   l_hrat01        LIKE hrat_file.hrat01   #NO.130705
    
      CALL g_hrcea.clear()
      
        IF cl_null(l_hrcea01) THEN 
           RETURN 
        END IF

   LET g_sql2 =  "SELECT hrcea02,hrcea13,'',hrcea03,hrcea04,hrcea05,hrcea06,",
                 "hrcea07,hrcea08,hrcea09,hrcea10,hrcea11,hrcea12",
                 " FROM hrcea_file ",
                 " WHERE hrcea01 = '",l_hrcea01 CLIPPED,"' ",
        #         " AND ",p_wc CLIPPED,     #NO.130617
                 " ORDER BY hrcea02"
 
    PREPARE i045_prepare3 FROM g_sql2           #預備一下
    DECLARE hrcea_curs CURSOR FOR i045_prepare3

        LET g_cnt0 = 1
        LET g_rec_b2 = 0

    FOREACH hrcea_curs INTO g_hrcea[g_cnt0].*       #單身 ARRAY 填充
        LET g_rec_b2 = g_rec_b2 + 1
         IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF


       #add-----NO.130705----begin----
        SELECT hrat01 INTO l_hrat01 FROM hrat_file WHERE hratid = g_hrcea[g_cnt0].hrcea13
        LET g_hrcea[g_cnt0].hrcea13 = l_hrat01
        DISPLAY BY NAME g_hrcea[g_cnt0].hrcea13
        #add-----NO.130705----end----

        #---------NO.130619-------sta-------#
    SELECT hrat02 INTO g_hrcea[g_cnt0].hrat02
      FROM hrat_file
     WHERE hrat01 = g_hrcea[g_cnt0].hrcea13

     DISPLAY BY NAME g_hrcea[g_cnt0].hrat02
     #-----------end------------------#
     
        LET g_cnt0 = g_cnt0 + 1
         IF g_cnt0 > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
         END IF
    END FOREACH
    CALL g_hrcea.deleteElement(g_cnt0) 
                  
   DISPLAY ARRAY g_hrcea TO s_hrcea.* ATTRIBUTE(COUNT=g_rec_b2)
        BEFORE DISPLAY
            EXIT DISPLAY 
        END DISPLAY 

     LET g_rec_b2 = g_cnt0 - 1

    #  IF INFIELD(hrcea) THEN            #NO.130618
    #     DISPLAY NULL TO FORMONLY.cn2
         DISPLAY g_rec_b2 TO FORMONLY.cn2
    #  END IF
     LET g_cnt0 = 0
      
END FUNCTION 

FUNCTION i045_hrcec(l_hrcec01,p_wc)
    DEFINE   p_wc            STRING
    DEFINE   l_hrcec01       LIKE hrcec_file.hrcec01
    DEFINE   l_hrat01        LIKE hrat_file.hrat01   #NO.130705
    DEFINE   l_hrbm04        LIKE hrbm_file.hrbm04   #NO.130705
    
      CALL g_hrcec.clear()

        IF cl_null(l_hrcec01) THEN 
           RETURN 
        END IF

   LET g_sql3 = "SELECT hrcec02,hrcec03,hrcec04,'',hrcec05,hrcec06,",
                "hrcec07,hrcec08,hrcec09,hrcec10,hrcec11,hrcec12,",
                "hrcec13,hrcec14,hrcec15,hrcec16",
                " FROM hrcec_file ",
                " WHERE hrcec01 = '",l_hrcec01 CLIPPED,"' ",
        #        " AND ",p_wc CLIPPED,        	#NO.130617
                " ORDER BY hrcec02"
 
    PREPARE i045_prepare4 FROM g_sql3           #預備一下
    DECLARE hrcec_curs CURSOR FOR i045_prepare4

        LET g_cnt1 = 1
        LET g_rec_b3 = 0
    
    FOREACH hrcec_curs INTO g_hrcec[g_cnt1].*       #單身 ARRAY 填充
        LET g_rec_b3 = g_rec_b3 + 1
         IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         	
         	#add-----NO.130705----begin----
        SELECT hrat01 INTO l_hrat01 FROM hrat_file WHERE hratid = g_hrcec[g_cnt1].hrcec04
           LET g_hrcec[g_cnt1].hrcec04 = l_hrat01
       DISPLAY BY NAME g_hrcec[g_cnt1].hrcec04
     
        SELECT hrbm04 INTO l_hrbm04 FROM hrbm_file
         WHERE hrbm03 = g_hrcec[g_cnt1].hrcec03
           LET g_hrcec[g_cnt1].hrcec03 = l_hrbm04

       
       CALL s_code('504',g_hrcec[g_cnt1].hrcec10) RETURNING g_hrag.*
        LET g_hrcec[g_cnt1].hrcec10 = g_hrag.hrag07
        
        SELECT hrat02 INTO g_hrcec[g_cnt1].hrat02_1 #抓取姓名
          FROM hrat_file
         WHERE hrat01 = g_hrcec[g_cnt1].hrcec04 
        
        DISPLAY BY NAME g_hrcec[g_cnt1].hrcec04,g_hrcec[g_cnt1].hrcec03,g_hrcec[g_cnt1].hrcec10,g_hrcec[g_cnt1].hrat02_1      
        
        #add-----NO.130705----end----
         	
         LET g_cnt1 = g_cnt1 + 1
          IF g_cnt1 > g_max_rec THEN
             CALL cl_err('',9035,0)
             EXIT FOREACH
          END IF
    END FOREACH
    CALL g_hrcec.deleteElement(g_cnt1)
               
   DISPLAY ARRAY g_hrcec TO s_hrcec.* ATTRIBUTE(COUNT=g_rec_b3)
        BEFORE DISPLAY
            EXIT DISPLAY 
        END DISPLAY
     
     LET g_rec_b3 = g_cnt1 - 1

   #   IF INFIELD(hrcea) THEN        #NO.130618
   #      DISPLAY NULL TO FORMONLY.cn2
         DISPLAY g_rec_b3 TO FORMONLY.cn2
   #   END IF
      LET g_cnt1 = 0
    
END FUNCTION 

FUNCTION i045_bp(p_ud)#gai
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   
   
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
      DISPLAY ARRAY g_hrce_1 TO s_hrce.* ATTRIBUTE(COUNT=g_row_count,UNBUFFERED)
      
        BEFORE DISPLAY
            CALL cl_navigator_setting(g_curs_index, g_row_count)

        BEFORE ROW 
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()
 
      
 
      ON ACTION accept
         LET l_ac = ARR_CURR()
         LET g_jump = l_ac
         LET g_no_ask = TRUE
         LET g_bp_flag = NULL
         CALL i045_fetch('/')
         CALL cl_set_comp_visible("Page2", FALSE)
         CALL ui.interface.refresh()              
         CALL cl_set_comp_visible("Page2", TRUE)
         EXIT DISPLAY

      ON ACTION item
         LET g_bp_flag = 'Page1'
         LET l_ac = ARR_CURR()
         LET g_jump = l_ac
         LET g_no_ask = TRUE
         IF g_row_count >0 THEN
             CALL i045_fetch('/')
         END IF
         CALL cl_set_comp_visible("Page2", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("Page2", TRUE)
         EXIT DISPLAY
           
      ON ACTION insert                           # A.輸入
         LET g_action_choice='insert'
         EXIT DISPLAY
 
      ON ACTION query                            # Q.查詢
         LET g_action_choice='query'
         EXIT DISPLAY
 
      ON ACTION modify                           # Q.修改
         LET g_action_choice='modify'
         EXIT DISPLAY
 
 #     ON ACTION reproduce                        # C.複製
 #        LET g_action_choice='reproduce'
 #        EXIT DISPLAY
 
      ON ACTION delete                           # R.取消
         LET g_action_choice='delete'
         EXIT DISPLAY
 
      ON ACTION detail                           # B.單身
         LET g_action_choice='detail'
         EXIT DISPLAY

      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION first                            # 第一筆
         CALL i045_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_row_count != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
           ACCEPT DISPLAY                  #No.FUN-530067 HCN TEST
 
      ON ACTION previous                         # P.上筆
         CALL i045_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_row_count != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         CONTINUE DISPLAY                  #No.FUN-530067 HCN TEST
 
      ON ACTION jump                             # 指定筆
         CALL i045_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_row_count != 0 THEN
              CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	       ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next                             # N.下筆
         CALL i045_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_row_count != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	       ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last                             # 最終筆
         CALL i045_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_row_count != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	       ACCEPT DISPLAY                  #No.FUN-530067 HCN TEST
 
       ON ACTION help                             # H.說明
          LET g_action_choice='help'
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT DISPLAY
 
      ON ACTION exit                             # Esc.結束
         LET g_action_choice='exit'
         EXIT DISPLAY 
 
      ON ACTION close 
         LET INT_FLAG=FALSE
         LET g_action_choice='exit'
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION related_document
           LET g_action_choice="related_document"
         EXIT DISPLAY

#      ON ACTION generate_link
#           LET g_action_choice="generate_link"
#         EXIT DISPLAY
         
      
      ON ACTION ghr_confirm
         LET g_action_choice="ghr_confirm"
         EXIT DISPLAY

      ON ACTION ghr_undo_confirm
         LET g_action_choice="ghr_undo_confirm"
         EXIT DISPLAY

      ON ACTION ghri045_a
         LET g_action_choice="ghri045_a"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION exporttoexcel       #FUN-4B0049
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                          
 
   END DISPLAY 
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i045_sh(p_flhrce)#gai
   DEFINE p_flhrce     LIKE type_file.chr1
   DEFINE l_j          LIKE type_file.num5
   DEFINE l_k          LIKE type_file.num5
   DEFINE l_sql        STRING
   

    IF g_hrce.hrce01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF


    CASE  p_flhrce
        WHEN's'  LET  p_flhrce = 's'
        WHEN'n'  LET  p_flhrce = 'n'
    END CASE

    CASE  p_flhrce
    WHEN's'

    IF g_hrce.hrceconf = 'Y' THEN
        CALL cl_err('',9023,0)
        RETURN
    END IF

IF  cl_confirm('aap-222') THEN
                           IF g_hrce.hrceconf = 'N' THEN
                          LET  g_hrce.hrceconf = 'Y'
                          END IF
                       UPDATE hrce_file
                          SET hrceconf = 'Y'
                        WHERE hrce01 = g_hrce.hrce01
                           
END IF

     WHEN'n'

    IF g_hrce.hrceconf = 'N' THEN
        CALL cl_err('',9025,0)
        RETURN
    END IF

IF  cl_confirm('aap-224') THEN
                           IF g_hrce.hrceconf = 'Y' THEN
                          LET g_hrce.hrceconf = 'N'
                          END IF
                       UPDATE hrce_file
                          SET hrceconf = 'N'
                        WHERE hrce01 = g_hrce.hrce01
END IF
    END CASE
        IF SQLCA.sqlcode THEN
           CALL cl_err3("upd","hrce_file",g_hrce01_t,"",SQLCA.sqlcode,"","",1) 
        ELSE
           DISPLAY BY NAME g_hrce.hrceconf
      	   LET l_sql = "select distinct hrcec04,hrcec16 from hrcec_file,hrce_file where hrcec01 = '",g_hrce.hrce01 CLIPPED,"' and hrcec01 = hrce01 and hrceconf = 'Y' ORDER BY hrcec04 "
           PREPARE i045_prepare_2 FROM l_sql           #預備一下
           DECLARE hrce_curs_2 CURSOR FOR i045_prepare_2

           CALL g_hrcec_1.clear()

           LET g_cnt = 1
    
           FOREACH hrce_curs_2 INTO g_hrcec_1[g_cnt].*
                IF SQLCA.sqlcode THEN
                   CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
                   EXIT FOREACH
                END IF
        
                IF g_hrcec_1[g_cnt].hrcec16 = 'N' THEN 
                   FOR l_k = 0 TO g_hrce.hrce05 - g_hrce.hrce03 
                       SELECT COUNT(*) INTO l_j FROM hrcp_file
                        WHERE hrcp02 = g_hrcec_1[g_cnt].hrcec04
                          AND hrcp03 = g_hrce.hrce03 + l_k
                       IF l_j > = 0 THEN 
                          UPDATE hrcp_file
                          SET hrcp35 = 'N'
                          WHERE hrcp02 = g_hrcec_1[g_cnt].hrcec04
                          AND hrcp03 = g_hrce.hrce03 + l_k
                          AND hrcpconf = 'N'
                       END IF 
                   END FOR 
                END IF 
        
                LET g_cnt = g_cnt + 1
                    IF g_cnt > g_max_rec THEN
                       CALL cl_err('',9035,0)
                       EXIT FOREACH
                    END IF
         
           END FOREACH 
           CALL g_hrcec_1.deleteElement(g_cnt)
        END IF



        CALL i045_show()
        CALL i045_b_fill_1(g_wc)   #added by yeap NO.130828

END FUNCTION

PRIVATE FUNCTION i045_set_entry(p_cmd)#gai
DEFINE   p_cmd     LIKE type_file.chr1
        IF p_cmd = 'u' THEN
        CALL cl_set_comp_entry("hrceb03,hrceb04,hrceb05,hrceb06",TRUE)
        CALL cl_set_comp_entry("hrcea03,hrcea04,hrcea05,hrcea06,hrcea07,hrcea08",TRUE)
        CALL cl_set_comp_entry("hrcea09,hrcea10,hrcea11,hrcea12,hrcea13",TRUE)#NO.130625
        CALL cl_set_comp_entry("hrcec05,hrcec06,hrcec07,hrcec08,hrcec15",TRUE)#NO.130625
        END IF 
        
        IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
        CALL cl_set_comp_entry("hrceb03,hrceb04,hrceb05,hrceb06",TRUE)
        CALL cl_set_comp_entry("hrcea03,hrcea04,hrcea05,hrcea06,hrcea07,hrcea08",TRUE)
        CALL cl_set_comp_entry("hrcea09,hrcea10,hrcea11,hrcea12,hrcea13",TRUE)
        CALL cl_set_comp_entry("hrcec05,hrcec06,hrcec07,hrcec08,hrcec15",TRUE)#NO.130625
        END IF 
        
END FUNCTION

PRIVATE FUNCTION i045_set_no_entry(p_cmd)#gai
   DEFINE   p_cmd     LIKE type_file.chr1

   IF p_cmd = 'u' THEN 
       CALL cl_set_comp_entry("hrat02,hrceb01,hrceb02,hrcea01,hrcea02",FALSE)
       CALL cl_set_comp_entry("hrcec02,hrcec03,hrcec04,hrcec10,hrcec11,hrcec12",FALSE)
      # CALL cl_set_comp_entry("hrcec13,hrcec14,hrcec15,hrcec16",FALSE)
       CALL cl_set_comp_entry("hrcec13,hrcec14,hrcec16",FALSE)
   END IF 
       
   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("hrceb01,hrceb02,hrcea01,hrcea02",FALSE)
       CALL cl_set_comp_entry("hrcec02,hrcec03,hrcec04,hrcec10,hrcec11,hrcec12",FALSE)
      # CALL cl_set_comp_entry("hrcec13,hrcec14,hrcec15,hrcec16",FALSE)
       CALL cl_set_comp_entry("hrcec13,hrcec14,hrcec16",FALSE)
   END IF 

END FUNCTION
	
#----------NO.130828  added by yeap --------str---------------
FUNCTION i045_b_fill_1(p_wc)
    DEFINE   p_wc            STRING
    DEFINE   l_hrceb01       LIKE hrceb_file.hrceb01
    DEFINE   l_hrat041        LIKE hrat_file.hrat04   #NO.130619
    DEFINE   l_hrat051        LIKE hrat_file.hrat05   #NO.130619
    DEFINE   l_hrat19        LIKE hrat_file.hrat19   #NO.130619
    DEFINE   l_hrat042        LIKE hrat_file.hrat04   #NO.130619
    DEFINE   l_hrat052        LIKE hrat_file.hrat05   #NO.130619
    DEFINE   l_hrat01        LIKE hrat_file.hrat01   #NO.130705

    IF cl_null(g_hrce.hrce01) THEN 
       RETURN 
    END IF
    
   
#20150401 add by yinbq for 资料清单没有 添加明细查询条件进行过滤
  # LET g_sql1= "SELECT DISTINCT 'N',hrce01,hrce02,hrce03,hrce04,hrce05,hrce06,hrce07,hrce08,",
  #              "hrce09,hrce10,hrce12,hrce11,hrce13,hrceacti ",
  #              " FROM hrce_file,hrceb_file,hrat_file ",
  #              " WHERE hrce01=hrceb01 AND hrceb03=hratid AND ",p_wc CLIPPED," AND ",p_wc3 CLIPPED,   #NO.130617
  #              " ORDER BY hrce01"
   LET g_sql1= "SELECT 'N',hrce01,hrce02,hrce03,hrce04,hrce05,hrce06,hrce07,hrce08,",
                "hrce09,hrce10,hrce12,hrce11,hrce13,hrceacti ",
                " FROM hrce_file ",
                " WHERE ",p_wc CLIPPED,   #NO.130617
                " ORDER BY hrce01"
#20150401 add by yinbq for 资料清单没有 添加明细查询条件进行过滤
    PREPARE i045_prepare_1 FROM g_sql1           #預備一下
    DECLARE hrce_curs_1 CURSOR FOR i045_prepare_1

    CALL g_hrce_1.clear()

    LET g_cnt = 1
    
    FOREACH hrce_curs_1 INTO g_hrce_1[g_cnt].*
         IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        
        SELECT hrbm04 INTO g_hrce_1[g_cnt].hrce02 FROM hrbm_file
        WHERE hrbm03=g_hrce_1[g_cnt].hrce02
        CALL s_code('504',g_hrce_1[g_cnt].hrce08) RETURNING g_hrag.*
        LET g_hrce_1[g_cnt].hrce08 = g_hrag.hrag07
        
        
        LET g_cnt = g_cnt + 1
         IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
         END IF
         
    END FOREACH 
    CALL g_hrce_1.deleteElement(g_cnt)
    DISPLAY ARRAY g_hrce_1 TO s_hrce.* ATTRIBUTE(COUNT=g_row_count)
       BEFORE DISPLAY
              EXIT DISPLAY
        END DISPLAY
    
   LET g_cnt = 0
   
END FUNCTION 
	
	
FUNCTION i045_confirm(p_cmd) 
  DEFINE p_cmd        LIKE type_file.chr1
  DEFINE l_i          LIKE type_file.num5
  DEFINE l_j          LIKE type_file.num5
  DEFINE l_k          LIKE type_file.num5
  DEFINE l_sql        STRING
  
  CALL cl_set_comp_visible('sure',TRUE)
  
  INPUT ARRAY g_hrce_1 WITHOUT DEFAULTS FROM s_hrce.*
     ATTRIBUTE (COUNT=g_row_count,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)

      ON ACTION sel_all
         LET g_action_choice="sel_all"
         FOR l_i = 1 TO g_row_count
             LET g_hrce_1[l_i].sure = 'Y'
             DISPLAY BY NAME g_hrce_1[l_i].sure
         END FOR
         
      ON ACTION sel_none
         LET g_action_choice="sel_none"
         FOR l_i = 1 TO g_row_count
             LET g_hrce_1[l_i].sure = 'N'
             DISPLAY BY NAME g_hrce_1[l_i].sure
         END FOR
         
      ON ACTION accept
         FOR l_i = 1 TO g_row_count
             IF g_hrce_1[l_i].sure = 'Y' THEN
                IF g_hrce_1[l_i].hrceacti = 'N' THEN 
                   CONTINUE FOR
                END IF 
                UPDATE hrce_file SET hrceconf = p_cmd WHERE hrce01 = g_hrce_1[l_i].hrce01
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","hrce_file",g_hrce01_t,"",SQLCA.sqlcode,"","",1) 
                   CONTINUE FOR 
                ELSE
      	           DISPLAY BY NAME g_hrce.hrceconf
      	           LET l_sql = "select distinct hrcec04,hrcec16 from hrcec_file,hrce_file where hrcec01 = '",g_hrce.hrce01 CLIPPED,"' and hrcec01 = hrce01 and hrceconf = 'Y' ORDER BY hrcec04 "
                   PREPARE i045_prepare_3 FROM l_sql           #預備一下
                   DECLARE hrce_curs_3 CURSOR FOR i045_prepare_3

                   CALL g_hrcec_1.clear()

                   LET g_cnt = 1
    
                   FOREACH hrce_curs_3 INTO g_hrcec_1[g_cnt].*
                        IF SQLCA.sqlcode THEN
                           CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
                           EXIT FOREACH
                        END IF
        
                        IF g_hrcec_1[g_cnt].hrcec16 = 'N' THEN 
                        	 FOR l_k = 0 TO g_hrce.hrce05 - g_hrce.hrce03 
                        	     SELECT COUNT(*) INTO l_j FROM hrcp_file
                        	      WHERE hrcp02 = g_hrcec_1[g_cnt].hrcec04
                                  AND hrcp03 = g_hrce.hrce03 + l_k
                               IF l_j > = 0 THEN 
                                  UPDATE hrcp_file
                                     SET hrcp35 = 'N'
                                   WHERE hrcp02 = g_hrcec_1[g_cnt].hrcec04
                                     AND hrcp03 = g_hrce.hrce03 + l_k
                                     AND hrcpconf = 'N'
                               END IF 
                           END FOR 
                        END IF 
        
                        LET g_cnt = g_cnt + 1
                        IF g_cnt > g_max_rec THEN
                           CALL cl_err('',9035,0)
                           EXIT FOREACH
                        END IF
         
                   END FOREACH 
                   CALL g_hrcec_1.deleteElement(g_cnt)
                END IF
                 
             END IF
         END FOR
         EXIT INPUT

     ON ACTION CANCEL
        LET INT_FLAG=0
        EXIT INPUT 
        
  END INPUT
  CALL cl_set_comp_visible('sure',FALSE)
  CALL i045_b_fill_1(g_wc)
END FUNCTION 
#----------NO.130828  added by yeap --------end---------------

FUNCTION i045_menu()
    DEFINE l_cmd    STRING

    WHILE TRUE 
           IF g_action_flag = 'Y' OR cl_null(g_action_flag)THEN 
           	  CALL i045_b_fill(g_wc)
           	  CALL i045_bp_main("G")
           ELSE
           	LET g_wc = "1=1" 
              CALL i045_b_fill_1(g_wc)
              CALL i045_b_menu()
           END IF   
              
      CASE g_action_choice
        	 WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i045_b()
            ELSE
               LET g_action_choice = NULL
            END IF
        
           WHEN "item_list"
              LET g_action_choice = ""  #MOD-8A0193 add
              CALL i045_b_menu()   #MOD-8A0193
              LET g_action_flag = 'Y'
              LET g_action_choice = ""  #MOD-8A0193 add   

           WHEN "insert"
            IF cl_chk_act_auth() THEN
                 CALL i045_a()
            END IF

           WHEN "query"
            IF cl_chk_act_auth() THEN
                 CALL i045_q()
                 CALL i045_b_fill_1(g_wc)   #added by yeap NO.130828
            END IF
            	
           WHEN "modify"
            IF cl_chk_act_auth() THEN
                 CALL i045_u()
            END IF

        WHEN "delete"
            IF cl_chk_act_auth() THEN
                 CALL i045_r()
            END IF

        WHEN "help"
            CALL cl_show_help()

        WHEN "exit"
            LET g_action_choice = "exit"
            EXIT WHILE

        WHEN "controlg"
            CALL cl_cmdask()

        WHEN "locale"
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()

#        WHEN "g_idle_seconds"
#           CALL cl_on_idle()
#           CONTINUE WHILE

        WHEN "ghr_confirm"
            IF cl_chk_act_auth() THEN
                 CALL i045_sh('s')
            END IF
            	
        WHEN "ghr_undo_confirm"
           IF cl_chk_act_auth() THEN
                 CALL i045_sh('n')
            END IF

        WHEN "ghri045_a"
           IF cl_chk_act_auth() THEN
              RUN "$FGLRUN $GHRi/ghri045a"
              CALL i045_show()
              CALL i045_b_fill_1(g_wc)   #added by yeap NO.130828
           END IF
            
        
        WHEN "about"
           CALL cl_about()

        WHEN "close"
           LET INT_FLAG=FALSE
           LET g_action_choice = "exit"
           EXIT WHILE
           	
        WHEN "exporttoexcel"   #No.FUN-4B0020
           IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrce_1),'','')
           END IF   
      END CASE 
   END WHILE 
END FUNCTION
	
FUNCTION i045_bp_main(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL SET_COUNT(g_rec_b1)
   CALL SET_COUNT(g_rec_b2)
   CALL SET_COUNT(g_rec_b3)

   DIALOG ATTRIBUTES(UNBUFFERED) 
   
   DISPLAY ARRAY g_hrceb TO s_hrceb.* ATTRIBUTE(COUNT=g_rec_b1)
      
        BEFORE DISPLAY
            CALL cl_navigator_setting(g_curs_index, g_row_count)

        BEFORE ROW 
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()
 
      ON ACTION accept
         LET g_action_choice="detail"
         EXIT DIALOG
      END DISPLAY 
              
   DISPLAY ARRAY g_hrcea TO s_hrcea.* ATTRIBUTE(COUNT=g_rec_b2)
        BEFORE DISPLAY
            CALL cl_navigator_setting(g_curs_index, g_row_count)
        BEFORE ROW 
            LET l_ac2 = ARR_CURR()
            CALL cl_show_fld_cont()
 
      ON ACTION accept
         LET g_action_choice="detail"
         EXIT DIALOG
        END DISPLAY 
           
   DISPLAY ARRAY g_hrcec TO s_hrcec.* ATTRIBUTE(COUNT=g_rec_b3)
        BEFORE DISPLAY
            CALL cl_navigator_setting(g_curs_index, g_row_count)
        BEFORE ROW 
            LET l_ac3 = ARR_CURR()
            CALL cl_show_fld_cont()
 
      ON ACTION accept
         LET g_action_choice="detail"
         EXIT DIALOG
        END DISPLAY 
  
  ON ACTION item_list 
     LET g_action_choice="item_list"  
     EXIT DIALOG
         
  ON ACTION insert
     LET g_action_choice="insert"
     EXIT DIALOG
     
  ON ACTION query
     LET g_action_choice="query"
     EXIT DIALOG
  
  ON ACTION modify
     LET g_action_choice="modify"
     EXIT DIALOG
     
  ON ACTION delete
     LET g_action_choice="delete"
     EXIT DIALOG
     
  ON ACTION first
     CALL i045_fetch('F')
     CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
       IF g_row_count != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
       END IF
       ACCEPT DIALOG  
  
  
  ON ACTION previous
     CALL i045_fetch('P')
     CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
       IF g_row_count != 0 THEN
          CALL fgl_set_arr_curr(1)  ######add in 040505
       END IF
	     ACCEPT DIALOG 
  
  
  ON ACTION jump
     CALL i045_fetch('/')
     CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
       IF g_row_count != 0 THEN
          CALL fgl_set_arr_curr(1)  ######add in 040505
       END IF
	     ACCEPT DIALOG
  
  
  ON ACTION next
     CALL i045_fetch('N')
     CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
       IF g_row_count != 0 THEN
          CALL fgl_set_arr_curr(1)  ######add in 040505
       END IF
	   ACCEPT DIALOG
  
  
  ON ACTION last
     CALL i045_fetch('L')
     CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
       IF g_row_count != 0 THEN
          CALL fgl_set_arr_curr(1)  ######add in 040505
       END IF
       ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
     
  ON ACTION detail
     LET g_action_choice="detail"
     LET l_ac = 1
     EXIT DIALOG
     
  ON ACTION ghr_confirm
     LET g_action_choice="ghr_confirm"
     EXIT DIALOG
     
  ON ACTION ghr_undo_confirm
     LET g_action_choice="ghr_undo_confirm"
     EXIT DIALOG
     
  ON ACTION output
     LET g_action_choice="output"
     EXIT DIALOG

  ON ACTION help
     LET g_action_choice="help"
     EXIT DIALOG
  
  ON ACTION locale
     LET g_action_choice="locale"
     EXIT DIALOG
  
  ON ACTION exit
     LET g_action_choice="exit"
     EXIT DIALOG
  
  ON ACTION ghri045_a
     LET g_action_choice="ghri045_a"
     EXIT DIALOG

     
  ON ACTION controlg
     LET g_action_choice="controlg"
     EXIT DIALOG
  
  ON ACTION close  
     LET INT_FLAG=FALSE 		#MOD-570244	mars
     LET g_action_choice="exit"
     EXIT DIALOG
  
  ON IDLE g_idle_seconds
     CALL cl_on_idle()
     CONTINUE DIALOG
  
  ON ACTION about       
     LET g_action_choice="about"
     EXIT DIALOG
  
  ON ACTION exporttoexcel       #FUN-4B0025
     LET g_action_choice = 'exporttoexcel'
     EXIT DIALOG
  
  AFTER DIALOG
     CONTINUE DIALOG
  
  ON ACTION controls                           #No.FUN-6B0032             
     CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
  
  ON ACTION related_document                #No.FUN-6A0162  相關文件
     LET g_action_choice="related_document"          
     EXIT DIALOG
  
 
  END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION
