# Prog. Version..: '5.25.04-11.09.23(00007)'     #
#
# Pattern name...: aglt004.4gl
# Descriptions...: 长期投资成本法轉權益法作業
# Date & Author..: 10/11/04 By lutingting
# Modify.........: NO.FUN-B40104 11/05/05 By xjll  合並報表回收產品
# Modify.........: No.FUN-B60134 11/06/27 By xjll  根据大連華錄修改部份程式 
# Modify.........: No.FUN-B80135 11/08/22 By minpp    相關日期欄位不可小於關帳日期
# Modify.........: No.FUN-B90009 11/09/01 By lutingting自動產生單身時,aeo22(調整科目-本年)默認值改為給aaw14合併投資收益科目 
# Modify.........: No.FUN-B90018 11/09/02 By lutingting自動產生單身時,第二單身抓取axqq_file的條件還要增加當前族群是分層合併
# Modify.........: No.FUN-B90034 11/09/05 By lutingting單頭幣別取合併族群最上層公司的記帳幣別
# Modify.........: No.FUN-B90057 11/09/06 By lutingting調整分錄改為借:長投 貸:投資收益,不再拆分
# Modify.........: NO.130805     13/08/05 by xiayan aaw_file--->aaz_file
# Modify.........: NO.130806     13/08/06 by xiayan 产生分录逻辑修正
# Modify.........: NO.130808     13/08/08 by tangyh 产生的调整作业单据日期应为当月的最后一天

DATABASE ds
 
#GLOBALS "../../config/top.global"     #yangtt 130819
GLOBALS "../../../tiptop/config/top.global"  #yangtt 130819
 
DEFINE g_aen01          LIKE aen_file.aen01,
       g_aen02          LIKE aen_file.aen02,
       g_aen03          LIKE aen_file.aen03,
       g_aen05          LIKE aen_file.aen05,
       g_aen09          LIKE aen_file.aen09,
       g_aen04          LIKE aen_file.aen04,
       g_aen10          LIKE aen_file.aen10,
       g_aen11          LIKE aen_file.aen11,
       g_aen01_t        LIKE aen_file.aen01,
       g_aen02_t        LIKE aen_file.aen02,
       g_aen03_t        LIKE aen_file.aen03,
       g_aen05_t        LIKE aen_file.aen05,
       g_aen04_t        LIKE aen_file.aen04,
       g_aen09_t        LIKE aen_file.aen09,
       g_aen10_t        LIKE aen_file.aen10,
       g_aen11_t        LIKE aen_file.aen11,
       g_aen01_o        LIKE aen_file.aen01,
       g_aen02_O        LIKE aen_file.aen02,
       g_aen03_o        LIKE aen_file.aen03,
       g_aen05_o        LIKE aen_file.aen05,
       g_aen04_o        LIKE aen_file.aen04,
       g_aen09_o        LIKE aen_file.aen09,
       g_aen10_o        LIKE aen_file.aen10,
       g_aen11_o        LIKE aen_file.aen11,
       b_aen            RECORD LIKE aen_file.*,
       g_aen            DYNAMIC ARRAY OF RECORD            #程式變數(Program Variables)
                           aen06 LIKE aen_file.aen06,      #長期股權投資科目#
                           aen07 LIKE aen_file.aen07,      #子公司關係人編號#
                           aen08 LIKE aen_file.aen08      #金額#
                        END RECORD,
       g_aen_t          RECORD
                           aen06 LIKE aen_file.aen06,
                           aen07 LIKE aen_file.aen07,
                           aen08 LIKE aen_file.aen08
                        END RECORD,
       b_aeo            RECORD LIKE aeo_file.*,
       g_aeo            DYNAMIC ARRAY OF RECORD            #程式變數(Program Variables)
                           aeo06 LIKE aeo_file.aeo06,      #被投資公司#
                           aeo06_desc LIKE axz_file.axz02, #被投资公司名称
                           aeo08 LIKE aeo_file.aeo08,      #母公司關係人編號#
                           aeo07 LIKE aeo_file.aeo07,      #所有者權益科目#
                           aeo09 LIKE aeo_file.aeo09,      #子公司幣別#
                           aeo10 LIKE aeo_file.aeo10,      #金額#
                           aeo19 LIKE aeo_file.aeo19,      #本期发生额   
                           aeo11 LIKE aeo_file.aeo11,      #再衡量匯率#
                           aeo12 LIKE aeo_file.aeo12,      #轉換匯率#
                           aeo13 LIKE aeo_file.aeo13,      #合並報表金額#
                           aeo20 LIKE aeo_file.aeo20,      #本期发生额  
                           aeo14_1 LIKE aeo_file.aeo14,    #年初投资比例 
                           aeo14 LIKE aeo_file.aeo14,      #投資比例#
                           aeo15 LIKE aeo_file.aeo15,      #投資公司股權科目#
                           aeo16 LIKE aeo_file.aeo16,      #金額#
                           aeo21 LIKE aeo_file.aeo21,      #本期发生额  
                           aeo17 LIKE aeo_file.aeo17,       #投資公司調整科目#
                           aeo22 LIKE aeo_file.aeo22       #本期发生额 
                        END RECORD,
       g_aeo_t          RECORD
                           aeo06 LIKE aeo_file.aeo06,      #被投資公司#
                           aeo06_desc LIKE axz_file.axz02, #被投资公司名称
                           aeo08 LIKE aeo_file.aeo08,      #母公司關係人編號#
                           aeo07 LIKE aeo_file.aeo07,      #所有者權益科目#
                           aeo09 LIKE aeo_file.aeo09,      #子公司幣別#
                           aeo10 LIKE aeo_file.aeo10,      #金額#
                           aeo19 LIKE aeo_file.aeo19,      #本期发生额   
                           aeo11 LIKE aeo_file.aeo11,      #再衡量匯率#
                           aeo12 LIKE aeo_file.aeo12,      #轉換匯率#
                           aeo13 LIKE aeo_file.aeo13,      #合並報表金額#
                           aeo20 LIKE aeo_file.aeo20,      #本期发生额  
                           aeo14_1 LIKE aeo_file.aeo14,    
                           aeo14 LIKE aeo_file.aeo14,      #投資比例#
                           aeo15 LIKE aeo_file.aeo15,      #投資公司股權科目#
                           aeo16 LIKE aeo_file.aeo16,      #金額#
                           aeo21 LIKE aeo_file.aeo21,      #本期发生额  
                           aeo17 LIKE aeo_file.aeo17,       #投資公司調整科目#
                           aeo22 LIKE aeo_file.aeo22       #本期发生额 
                        END RECORD,
       g_wc,g_wc2,g_sql string,                   
       g_rec_b1         LIKE type_file.num5,     
       l_ac1            LIKE type_file.num5,    
       p_row,p_col      LIKE type_file.num5    
#主程式開始
DEFINE g_forupd_sql     STRING                     
DEFINE g_before_input_done   LIKE type_file.num5  
DEFINE g_chr            LIKE type_file.chr1      
DEFINE g_chr2           LIKE type_file.chr1     
DEFINE g_chr3           LIKE type_file.chr1     
DEFINE g_cnt            LIKE type_file.num10    
DEFINE g_i              LIKE type_file.num5     
DEFINE g_msg            LIKE type_file.chr1000  
DEFINE g_str            STRING                  
DEFINE g_wc_gl          STRING                  
DEFINE g_row_count      LIKE type_file.num10    
DEFINE g_curs_index     LIKE type_file.num10    
DEFINE g_jump           LIKE type_file.num10    
DEFINE l_ac2            LIKE type_file.num5     
DEFINE g_rec_b2         LIKE type_file.num5    
DEFINE g_wc3            STRING                
DEFINE g_b_flag         STRING               
DEFINE t_azi04_1        LIKE azi_file.azi04   #母公司币别取位
DEFINE t_azi04_2        LIKE azi_file.azi04   #子公司币别取位 
DEFINE mi_no_ask        LIKE type_file.num5
DEFINE g_aaw            RECORD LIKE aaw_file.*
DEFINE g_aaz            RECORD LIKE aaz_file.*   #NO.130805 add
#FUN-B80135--add--str--
DEFINE g_aaa07          LIKE aaa_file.aaa07
DEFINE g_year           LIKE type_file.chr4
DEFINE g_month          LIKE type_file.chr2
#FUN-B80135--add—end--
#130808 add by tangyh--str
DEFINE g_yy             LIKE type_file.chr4  
DEFINE g_mm             LIKE type_file.chr2
DEFINE g_bdate          LIKE axi_file.axi02
DEFINE g_edate          LIKE axi_file.axi02
#130808 add by tangyh--end  
  
MAIN
   IF FGL_GETENV("FGLGUI") <> "0" THEN
      OPTIONS                               #改變一些系統預設值
         INPUT NO WRAP
   END IF
 
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CGL")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
     RETURNING g_time   
  
   #FUN-B80135--add--str--
#NO.130805 modify--------------------begin
   #SELECT aaa07 INTO g_aaa07 FROM aaa_file,aaw_file
   # WHERE aaa01 = aaw01 AND aaw00 = '0'
   SELECT aaa07 INTO g_aaa07 FROM aaa_file,aaz_file
    WHERE aaa01 = aaz641 AND aaz00 = '0'
#NO.130805 modify----------------------end
   LET g_year = YEAR(g_aaa07)
   LET g_month= MONTH(g_aaa07)
   #FUN-B80135--add--end 

   #SELECT * INTO g_aaw.* FROM aaw_file WHERE aaw00 = '0'  #NO.130805 mark
   SELECT * INTO g_aaz.* FROM aaz_file WHERE aaz00 = '0'   #NO.130805 modify

   IF g_bgjob='N' OR cl_null(g_bgjob) THEN
      LET p_row = 2 LET p_col = 3
      OPEN WINDOW t004_w AT p_row,p_col
        WITH FORM "agl/42f/aglt004"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
      
      CALL cl_ui_init()
   END IF
 
   CALL cl_set_comp_visible("aeo08",FALSE)
   CALL t004_menu()
 
   CLOSE WINDOW t004_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2)    #計算使用時間 (退出使間) 
      RETURNING g_time  
 
END MAIN

FUNCTION t004_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01   
 
   CLEAR FORM                             #清除畫面
   CALL g_aeo.clear()
   CALL g_aen.clear()
   INITIALIZE g_aen01 TO NULL
   INITIALIZE g_aen02 TO NULL
   INITIALIZE g_aen03 TO NULL
   INITIALIZE g_aen05 TO NULL
   INITIALIZE g_aen09 TO NULL
   INITIALIZE g_aen04 TO NULL
   INITIALIZE g_aen10 TO NULL
   DISPLAY g_aen11 TO aen11
   CALL cl_set_head_visible("","YES")      
   
      DIALOG ATTRIBUTES(UNBUFFERED)
     
      CONSTRUCT g_wc ON aen01,aen02,aen03,aen05,aen09,aen04,aen11,aen10,
                        aen06,aen07,aen08
              FROM aen01,aen02,aen03,aen05,aen09,aen04,aen11,aen10,
                   s_aen[1].aen06,s_aen[1].aen07,s_aen[1].aen08

             #Modifi NO.FUN-B40104  增加查询开窗功能      
         #yangtt---130819---mark--str--
         #ON ACTION CONTROLP
         #   CASE
         #      WHEN INFIELD(aen03)
         #         CALL cl_init_qry_var()
         #        LET g_qryparam.form = "q_aen03"
         #        LET g_qryparam.state = "c"
         #        CALL cl_create_qry() RETURNING g_qryparam.multiret
         #        DISPLAY g_qryparam.multiret TO aen03
         #        NEXT FIELD aen05   
         #      
         #      WHEN INFIELD(aen05) 
         #        CALL cl_init_qry_var()
         #        LET g_qryparam.form = "q_aen05"
         #        LET g_qryparam.state = "c"
         #        CALL cl_create_qry() RETURNING g_qryparam.multiret
         #        DISPLAY g_qryparam.multiret TO aen05
         #        NEXT FIELD aen09

         #       WHEN INFIELD(aen04)
         #        CALL cl_init_qry_var()
         #        LET g_qryparam.form = "q_aen04"
         #        LET g_qryparam.state = "c"
         #        CALL cl_create_qry() RETURNING g_qryparam.multiret
         #        DISPLAY g_qryparam.multiret TO aen04
         #        NEXT FIELD aen11
         #       
         #      
         #       WHEN INFIELD(aen06)
         #        CALL cl_init_qry_var()
         #        LET g_qryparam.form = "q_aen06"
         #        LET g_qryparam.state = "c"
         #        CALL cl_create_qry() RETURNING g_qryparam.multiret
         #        DISPLAY g_qryparam.multiret TO aen06
         #        NEXT FIELD aen06

         #        
         #       WHEN INFIELD(aen07)
         #        CALL cl_init_qry_var()
         #        LET g_qryparam.form = "q_aen07"
         #        LET g_qryparam.state = "c"
         #        CALL cl_create_qry() RETURNING g_qryparam.multiret
         #        DISPLAY g_qryparam.multiret TO aen07
         #        NEXT FIELD aen08
         # 

         #     
         #        OTHERWISE EXIT CASE
         #     END CASE
         #yangtt---130819---mark--end--
		  BEFORE CONSTRUCT
		    CALL cl_qbe_display_condition(lc_qbe_sn)      

      END CONSTRUCT      

      CONSTRUCT g_wc2 ON aeo06,aeo08,aeo07,aeo09,aeo10,aeo19,aeo11,   
                         aeo12,aeo13,aeo20,aeo14,aeo14_1,aeo15,aeo16,aeo21,aeo17,aeo22
              FROM s_aeo[1].aeo06,s_aeo[1].aeo08,s_aeo[1].aeo07,
                   s_aeo[1].aeo09,s_aeo[1].aeo10,s_aeo[1].aeo19,s_aeo[1].aeo11,
                   s_aeo[1].aeo12,s_aeo[1].aeo13,s_aeo[1].aeo20,s_aeo[1].aeo14,
                   s_aeo[1].aeo14_1, 
                   s_aeo[1].aeo15,s_aeo[1].aeo16,s_aeo[1].aeo21,s_aeo[1].aeo17,
                   s_aeo[1].aeo22
 
		  BEFORE CONSTRUCT
		    CALL cl_qbe_display_condition(lc_qbe_sn)      

      END CONSTRUCT

          ON ACTION CONTROLP
             CASE
         #yangtt---130819---add---str--
                WHEN INFIELD(aen03)
                   CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aen03"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aen03
                  NEXT FIELD aen05

                WHEN INFIELD(aen05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aen05"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aen05
                  NEXT FIELD aen09

                 WHEN INFIELD(aen04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aen04"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aen04
                  NEXT FIELD aen11


                 WHEN INFIELD(aen06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aen06"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aen06
                  NEXT FIELD aen06


                 WHEN INFIELD(aen07)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aen07"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aen07
                  NEXT FIELD aen08
         #yangtt---130819---add---end--

                WHEN INFIELD(aen01)
                   CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aen"
                  LET g_qryparam.arg1 = "2"       #No.TQC-A90057
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aen01
                NEXT FIELD aen01
              

               WHEN INFIELD(aeo06)
                   CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aeo06"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aeo06
                NEXT FIELD aeo06

                WHEN INFIELD(aeo07)
                   CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aeo07"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aeo07
                  NEXT FIELD aeo07
                     
                WHEN INFIELD(aeo15)
                   CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aeo15"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aeo15
                  NEXT FIELD aeo15
   
                 WHEN INFIELD(aeo17)
                   CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aeo17"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aeo17
                  NEXT FIELD aeo17
        
            
                  WHEN INFIELD(aeo22)
                   CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aeo22"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aeo22
                  NEXT FIELD aeo22  
                  OTHERWISE EXIT CASE
            END CASE
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
 
          ON ACTION about        
             CALL cl_about()     
 
          ON ACTION help         
             CALL cl_show_help()  
 
          ON ACTION controlg     
             CALL cl_cmdask()     
 
          ON ACTION qbe_save
		         CALL cl_qbe_save()

          ON ACTION accept
             EXIT DIALOG

          ON ACTION cancel
             LET INT_FLAG = TRUE
             EXIT DIALOG		       
      END DIALOG
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         RETURN
      END IF

   IF cl_null(g_wc2) THEN
      LET g_wc2 =' 1=1' 
   END IF  

   IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
      LET g_sql = "SELECT UNIQUE aen01,aen02,aen03,aen04,aen05,aen11 FROM aen_file",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY aen01,aen02,aen03,aen04,aen05,aen11"
   ELSE                              # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE aen01,aen02,aen03,aen04,aen05,aen11 ",
                  "  FROM aen_file,aeo_file",
                  " WHERE aen01 = aeo01 AND aen02 = aeo02 AND aen03 = aeo03 ",
                  "   AND aen04 = aeo04 AND aen05 = aeo05 ",
                  "   AND ",g_wc CLIPPED,
                  "   AND ",g_wc2 CLIPPED,
                  " ORDER BY aen01,aen02,aen03,aen04,aen05,aen11"
   END IF

   PREPARE t004_prepare FROM g_sql
   DECLARE t004_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t004_prepare

   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT UNIQUE aen01,aen02,aen03,aen04,aen05,aen11 FROM aen_file",
                " WHERE ", g_wc CLIPPED,
                " INTO TEMP x "
   ELSE
      LET g_sql="SELECT UNIQUE aen01,aen02,aen03,aen04,aen05,aen11 ",
                "  FROM aen_file,aeo_file",
                " WHERE aen01 = aeo01 AND aen02 = aeo02 AND aen03 = aeo03 ",
                "   AND aen04 = aeo04 AND aen05 = aeo05 ",
                "   AND ",g_wc CLIPPED,
                "   AND ",g_wc2 CLIPPED,
                " INTO TEMP x "
   END IF
   DROP TABLE x 
   PREPARE t004_pre_x FROM g_sql
   EXECUTE t004_pre_x
   LET g_sql = "SELECT COUNT(*) FROM x"
   PREPARE t004_precount FROM g_sql
   DECLARE t004_count CURSOR FOR t004_precount
 
END FUNCTION
 
FUNCTION t004_menu()
 
   WHILE TRUE
      CALL t004_bp("G")
      CALL cl_set_act_visible("close",FALSE)
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t004_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t004_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t004_r()
            END IF
 
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               #CASE g_b_flag                
               #     WHEN '1'
                              CALL t004_b1() 
                    #WHEN '2' CALL t004_b2() 
               #END CASE                     
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "gen_entry"    #產生調整分錄#
            CALL t004_v()
 
         WHEN "qry_sheet"    #查詢調整分錄#
            IF cl_chk_act_auth() THEN
               LET g_msg="aglt0011 '",g_aen11,"' '",g_aen10,"' "
              CALL cl_cmdrun_wait(g_msg CLIPPED)
            END IF
     END CASE
   END WHILE
END FUNCTION
 
FUNCTION t004_a()
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
   CALL g_aeo.clear()
   CALL g_aen.clear()                           
   INITIALIZE g_aen01 LIKE aen_file.aen01  #DEFAULT 設定
   INITIALIZE g_aen02 LIKE aen_file.aen02  #DEFAULT 設定
   INITIALIZE g_aen03 LIKE aen_file.aen03  #DEFAULT 設定
   INITIALIZE g_aen05 LIKE aen_file.aen09  #DEFAULT 設定
   INITIALIZE g_aen09 LIKE aen_file.aen09  #DEFAULT 設定
   INITIALIZE g_aen04 LIKE aen_file.aen04  #DEFAULT 設定
   INITIALIZE g_aen10 LIKE aen_file.aen10  #DEFAULT 設定
   INITIALIZE g_aen11 LIKE aen_file.aen11  #DEFAULT 設定
   INITIALIZE g_aen01_t LIKE aen_file.aen01  #DEFAULT 設定
   INITIALIZE g_aen02_t LIKE aen_file.aen02  #DEFAULT 設定
   INITIALIZE g_aen03_t LIKE aen_file.aen03  #DEFAULT 設定
   INITIALIZE g_aen05_t LIKE aen_file.aen09  #DEFAULT 設定
   INITIALIZE g_aen09_t LIKE aen_file.aen09  #DEFAULT 設定
   INITIALIZE g_aen04_t LIKE aen_file.aen04  #DEFAULT 設定
   INITIALIZE g_aen10_t LIKE aen_file.aen10  #DEFAULT 設定
   INITIALIZE g_aen11_t LIKE aen_file.aen11  #DEFAULT 設定
   #SELECT aaw01 INTO g_aen11 FROM aaw_file WHERE aaw00 = '0'  #130801 mark by tangyh
   SELECT aaz641 INTO g_aen11 FROM aaz_file WHERE aaz00 = '0'  #130801 mod by tangyh
   DISPLAY g_aen11 TO aen11
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL t004_i("a")                #輸入單頭
      IF INT_FLAG THEN
         LET g_aen01 = NULL 
         LET g_aen02 = NULL
         LET g_aen03 = NULL
         LET g_aen04 = NULL 
         LET g_aen05 = NULL
         LET g_aen09 = NULL
         LET g_aen10 = NULL 
         LET g_aen11 = NULL
         DISPLAY g_aen01,g_aen02,g_aen03,g_aen05,g_aen09,g_aen04,g_aen10,g_aen11 
              TO aen01,aen02,aen03,aen05,aen09,aen04,aen10,g_aen11
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF g_aen01 IS NULL THEN   #KEY不可空白
         CONTINUE WHILE
      END IF 
      IF g_aen02 IS NULL THEN   #KEY不可空白
         CONTINUE WHILE
      END IF 
      IF g_aen03 IS NULL THEN   #KEY不可空白
         CONTINUE WHILE
      END IF 
      IF g_aen04 IS NULL THEN   #KEY不可空白
         CONTINUE WHILE
      END IF 
      IF g_aen05 IS NULL THEN   #KEY不可空白
         CONTINUE WHILE
      END IF 

      CALL g_aen.clear()
      LET g_rec_b1=0
      CALL g_aeo.clear()   
      LET g_rec_b2=0        
 
      LET l_ac1=1
    
      CALL t004_g_b()                  #自动生成单身   #101125 
      CALL t004_b1()                   #輸入單身
      #CALL t004_b2()       

      LET g_aen01_t = g_aen01    ##保留舊值 
      LET g_aen02_t = g_aen02    ##保留舊值 
      LET g_aen03_t = g_aen03    ##保留舊值
      LET g_aen04_t = g_aen04    ##保留舊值 
      LET g_aen05_t = g_aen05    ##保留舊值
      LET g_aen10_t = g_aen10    ##保留舊值
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t004_u()
   DEFINE l_yy,l_mm   LIKE type_file.num5               #No.FUN-680123 SMALLINT
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_aen01) OR cl_null(g_aen02) OR cl_null(g_aen03) OR cl_null(g_aen04)
      OR cl_null(g_aen11) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF 
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_success = 'Y'   #MOD-730060
    BEGIN WORK
 
    WHILE TRUE
        CALL t004_i('u')
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           EXIT WHILE
        END IF 
        EXIT WHILE
    END WHILE
    IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF   #MOD-730060
END FUNCTION
 
 
#處理INPUT
FUNCTION t004_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1       #a:輸入 u:更改
  DEFINE l_flag          LIKE type_file.chr1       #判斷必要欄位是否有輸入
  DEFINE l_n             LIKE type_file.num5      
  DEFINE l_cnt           LIKE type_file.num5

    DISPLAY g_aen01,g_aen02,g_aen03,g_aen05,g_aen09,g_aen04,g_aen10,g_aen11
         TO aen01,aen02,aen03,g_aen05,aen09,aen04,aen10,g_aen11

    CALL cl_set_head_visible("","YES")      
 
    INPUT g_aen01,g_aen02,g_aen03,g_aen05
        WITHOUT DEFAULTS
        FROM aen01,aen02,aen03,aen05
 
        BEFORE INPUT
          LET g_before_input_done = FALSE
          LET g_before_input_done = TRUE
 
        AFTER FIELD aen01
            IF cl_null(g_aen01) THEN
               NEXT FIELD aen01
            END IF
            #No.FUN-B80135--add--str--
            IF NOT cl_null(g_aen01) THEN
               IF g_aen01 < 0 THEN
                  CALL cl_err(g_aen01,'apj-035',0)
                  NEXT FIELD aen01
               END IF
 
                IF g_aen01<g_year  THEN 
                   CALL cl_err(g_aen01,'axm-164',0)
                   NEXT FIELD aen01
                END IF
                IF g_aen01=g_year AND g_aen02 <= g_month THEN
                   CALL cl_err(g_aen02,'axm-164',0)
                   NEXT FIELD aen02
                END IF
            END IF
            #No.FUN-B80135--add--end
            
 
        AFTER FIELD aen02
           IF NOT cl_null(g_aen02) THEN
               IF g_aen02 < 1 OR g_aen02 > 12 THEN
                  CALL cl_err(' ','agl-020',0)
                  NEXT FIELD aen02
               END IF
           #FUN-B80135--add--str--
               IF g_aen01=g_year AND g_aen02<=g_month THEN
                  CALL cl_err(g_aen02,'axm-164',0)
                  NEXT FIELD aen02
               END IF
            #FUN-B80135--add--end
           ELSE 
              NEXT FIELD aen02
           END IF

        AFTER FIELD aen03
            IF NOT cl_null(g_aen03) THEN
               CALL t004_aen03(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('aen03',g_errno,0)
                  NEXT FIELD aen03
               END IF 
               #FUN-B90034--add--str--
               SELECT axz06 INTO g_aen09 FROM axz_file,axa_file
                WHERE axz01 = axa02 AND axa01 = g_aen03
                  AND axa04 = 'Y'
               DISPLAY g_aen09 TO aen09
               SELECT azi04 INTO t_azi04_1 FROM azi_file
                WHERE azi01 = g_aen09
               #FUN-B90034--add--end
            ELSE
               NEXT FIELD aen03
            END IF 

        AFTER FIELD aen05
            IF NOT cl_null(g_aen05) THEN
               IF g_aen05!=g_aen05_t OR g_aen05_t IS NULL THEN
                  SELECT COUNT(*) INTO l_cnt FROM axa_file
                   WHERE axa01 = g_aen03 AND axa02 = g_aen05
                  IF l_cnt<1 THEN
                     CALL cl_err('','agl-325',0)
                     LET g_aen05 = g_aen05_t
                     NEXT FIELD aen05
#FUN-B90034--mark--str--
#                 ELSE
#                    SELECT axz07 INTO g_aen09 FROM axz_file
#                     WHERE axz01 = g_aen05
#                    DISPLAY g_aen09 TO aen09
#                    SELECT azi04 INTO t_azi04_1 FROM azi_file
#                     WHERE azi01 = g_aen09
#FUN-B90034--mark--end
                  END IF
               END IF
            END IF

       # AFTER FIELD aen10
       #     IF NOT cl_null(g_aen10) THEN
       #        CALL t004_aen10()
       #        IF NOT cl_null(g_errno) THEN
       #           CALL cl_err('aen10',g_errno,0)
       #           NEXT FIELD aen10
       #        END IF 
       #     ELSE
       #        NEXT FIELD aen10
       #     END IF 
        AFTER INPUT 
            IF INT_FLAG THEN EXIT INPUT END IF
            IF p_cmd = 'a' THEN
               IF NOT cl_null(g_aen01) AND NOT cl_null(g_aen02) AND 
                  NOT cl_null(g_aen03) AND NOT cl_null(g_aen05) THEN
                  IF g_aen01_t IS NULL OR (g_aen01!=g_aen01_t) OR
                     g_aen02_t IS NULL OR (g_aen02!=g_aen02_t) OR
                     g_aen03_t IS NULL OR (g_aen03!=g_aen03_t) OR
                     g_aen05_t IS NULL OR (g_aen05!=g_aen05_t) THEN
                     SELECT COUNT(*) INTO l_n FROM aen_file
                      WHERE aen01 = g_aen01 AND aen02 = g_aen02
                        AND aen03 = g_aen03 AND aen05 = g_aen05
                     IF l_n>0 THEN
                        CALL cl_err('',-239,0)
                        NEXT FIELD aen01
                     END IF 
                  END IF  
               END IF  
            END IF 
 
        ON ACTION CONTROLP     #ok
            CASE
               WHEN INFIELD(aen03)   #族群编号
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_axa1"
                  LET g_qryparam.default1 = g_aen03
                  CALL cl_create_qry() RETURNING g_aen03
                  DISPLAY g_aen03 TO aen03
                  CALL t004_aen03('d')
                  NEXT FIELD aen03
               WHEN INFIELD(aen05)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_axa3"
                     LET g_qryparam.default1 = g_aen05
                     LET g_qryparam.arg1 = g_aen03
                     CALL cl_create_qry() RETURNING g_aen05
                     DISPLAY g_aen05 TO aen05
                     NEXT FIELD aen05
              # WHEN INFIELD(aen10)
              #    CALL q_aac(FALSE,TRUE,g_aen10,'A','','','AGL') RETURNING g_aen10
              #    DISPLAY g_aen10 TO aen10
              #    NEXT FIELD aen10
            END CASE
 
        ON ACTION CONTROLF                  #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
       #ON ACTION CONTROLZ  #yangtt 130819
        ON ACTION CONTROLR  #yangtt 130819
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

FUNCTION t004_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_aen01 TO NULL
    INITIALIZE g_aen02 TO NULL
    INITIALIZE g_aen03 TO NULL
    INITIALIZE g_aen04 TO NULL
    INITIALIZE g_aen05 TO NULL
    INITIALIZE g_aen10 TO NULL
   #MESSAGE ""
    CALL cl_msg("")                          #FUN-640246
 
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t004_cs()
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       RETURN
    END IF
   #MESSAGE " SEARCHING ! "
    CALL cl_msg(" SEARCHING ! ")                              #FUN-640246
 
    OPEN t004_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_aen01 TO NULL
        INITIALIZE g_aen02 TO NULL
        INITIALIZE g_aen03 TO NULL
        INITIALIZE g_aen04 TO NULL
        INITIALIZE g_aen05 TO NULL
        INITIALIZE g_aen10 TO NULL
        INITIALIZE g_aen11 TO NULL
    ELSE
        OPEN t004_count
        FETCH t004_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t004_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
   #MESSAGE ""
    CALL cl_msg("")                              #FUN-640246
 
END FUNCTION
 
FUNCTION t004_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,              #No.FUN-680123 VARCHAR(1),               #處理方式
    l_abso          LIKE type_file.num10              #No.FUN-680123 INTEGER                #絕對的筆數
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t004_cs INTO g_aen01,g_aen02,g_aen03,g_aen04,g_aen05,g_aen11
        WHEN 'P' FETCH PREVIOUS t004_cs INTO g_aen01,g_aen02,g_aen03,g_aen04,g_aen05,g_aen11
        WHEN 'F' FETCH FIRST    t004_cs INTO g_aen01,g_aen02,g_aen03,g_aen04,g_aen05,g_aen11
        WHEN 'L' FETCH LAST     t004_cs INTO g_aen01,g_aen02,g_aen03,g_aen04,g_aen05,g_aen11
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
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
            FETCH ABSOLUTE g_jump t004_cs INTO g_aen01,g_aen02,g_aen03,g_aen04,g_aen05,g_aen11
            LET mi_no_ask = FALSE
    END CASE
 
    SELECT UNIQUE aen01,aen02,aen03,aen04,aen05,aen10,aen11
      INTO g_aen01,g_aen02,g_aen03,g_aen04,g_aen05,g_aen10,g_aen11
      FROM aen_file
     WHERE aen01 = g_aen01 AND aen02 = g_aen02 AND aen03 = g_aen03
       AND aen05 = g_aen05 AND aen04 = g_aen04 AND aen11 = g_aen11
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_aen01 TO NULL
        INITIALIZE g_aen02 TO NULL
        INITIALIZE g_aen03 TO NULL
        INITIALIZE g_aen04 TO NULL
        INITIALIZE g_aen05 TO NULL
        INITIALIZE g_aen10 TO NULL
        INITIALIZE g_aen11 TO NULL
    ELSE
       CALL t004_show()
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
 
FUNCTION t004_show()
   DISPLAY g_aen01 TO aen01
   DISPLAY g_aen02 TO aen02
   DISPLAY g_aen03 TO aen03
   DISPLAY g_aen04 TO aen04
   DISPLAY g_aen05 TO aen05
   DISPLAY g_aen10 TO aen10
   DISPLAY g_aen11 TO aen11  
  
   #FUN-B90034--mod--str-
   #SELECT axz07 INTO g_aen09 FROM axz_file WHERE axz01 = g_aen05 
   SELECT axz06 INTO g_aen09 FROM axz_file,axa_file
    WHERE axz01 = axa02 AND axa01 = g_aen03
      AND axa04 = 'Y'
   #FUN-B90034--mod--end
   DISPLAY g_aen09 TO aen09
   CALL t004_b_fill(g_wc)
   CALL t004_b_fill2(g_wc2) 
END FUNCTION
 
FUNCTION t004_r()
    DEFINE l_chr,l_sure LIKE type_file.chr1,              #No.FUN-680123 VARCHAR(1),
           l_n          LIKE type_file.num5               #No.FUN-680123 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF g_aen01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_aen02 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_aen03 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_aen04 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_aen11 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT aen10 INTO g_aen10 FROM aen_file WHERE aen01 = g_aen01
       AND aen02 = g_aen02 AND aen03 = g_aen03 AND aen05 = g_aen05
    IF NOT cl_null(g_aen10) THEN 
       #CALL cl_err('','agl-353',0)  #NO.130806 mark
       CALL cl_err('','cgl-400',0)   #NO.130806 modify
       RETURN 
    END IF 

    BEGIN WORK
    IF cl_delh(15,16) THEN
        DELETE FROM aen_file WHERE aen01 = g_aen01 AND aen02 = g_aen02 AND aen03 = g_aen03
                               AND aen04 = g_aen04 AND aen11 = g_aen11 AND aen05 = g_aen05
        IF SQLCA.SQLERRD[3]=0
             THEN CALL cl_err3("del","aen_file","","","","","No aen deleted",1) 
             ROLLBACK WORK RETURN
        END IF 
        DELETE FROM aeo_file WHERE aeo01 = g_aen01 AND aeo02 = g_aen02
           AND aeo03 = g_aen03 AND aeo04 = g_aen04
           AND aeo05 = g_aen05 
        LET g_msg=TIME
        CLEAR FORM
        CALL g_aeo.clear()
        CALL g_aen.clear()
        MESSAGE ""
        LET g_sql = "SELECT UNIQUE aen01,aen02,aen03,aen04,aen05,aen11",
                    "  FROM aen_file ",
                    "  INTO TEMP y"
        DROP TABLE y
        PREPARE t004_pre_y FROM g_sql
        EXECUTE t004_pre_y
        LET g_sql = "SELECT COUNT(*) FROM y"
        PREPARE t004_precount2 FROM g_sql
        DECLARE t004_count2 CURSOR FOR t004_precount2
        OPEN t004_count2
        FETCH t004_count2 INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN t004_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL t004_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL t004_fetch('/')
        END IF
 
    END IF
    COMMIT WORK
END FUNCTION
 
FUNCTION t004_b1()
DEFINE l_ac1_t          LIKE type_file.num5,  
       l_row,l_col     LIKE type_file.num5,  
       l_n,l_cnt       LIKE type_file.num5, 
       l_lock_sw       LIKE type_file.chr1, 
       p_cmd           LIKE type_file.chr1, 
       l_b2            LIKE type_file.chr1000,
       l_allow_insert  LIKE type_file.num5, 
       l_allow_delete  LIKE type_file.num5, 
       l_ac2_t         LIKE type_file.num5
DEFINE l_axz01         LIKE axz_file.axz01   
    SELECT azi04 INTO t_azi04_1 FROM azi_file WHERE azi01 = g_aen09
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF 
  
#NO.130806 add--------------begin
    SELECT aen10 INTO g_aen10 FROM aen_file WHERE aen01 = g_aen01
       AND aen02 = g_aen02 AND aen03 = g_aen03 AND aen05 = g_aen05
    IF NOT cl_null(g_aen10) THEN 
       CALL cl_err('','cgl-400',0)   #NO.130806 modify
       RETURN 
    END IF    
#NO.130806 add----------------end

    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT aen06,aen07,aen08 FROM aen_file ",
                       "  WHERE aen01 = ? AND aen02 = ? AND aen03 = ? AND aen04 = ? ",
                       "    AND aen05 = ? AND aen06 = ? AND aen07 = ? AND aen11 = ? ",
                       "    FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t004_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET g_forupd_sql = " SELECT * FROM aeo_file WHERE aeo01 = ? AND aeo02 = ? AND aeo03 = ? ",
                       "    AND aeo04 = ? AND aeo05 = ? AND aeo06 = ? AND aeo07 = ? AND aeo18 = ?",
                       "    FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t004_bcl_aeo CURSOR FROM g_forupd_sql
                      
    LET l_ac1_t = 0  
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    IF g_rec_b1>0 THEN LET l_ac1 = 1 END IF 
    IF g_rec_b2>0 THEN LET l_ac2 = 1 END IF 


    DIALOG ATTRIBUTES(UNBUFFERED)  
      INPUT ARRAY g_aen  FROM s_aen.*
            ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS = TRUE,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b1 != 0 THEN
               CALL fgl_set_arr_curr(l_ac1)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac1 = ARR_CURR()
            DISPLAY l_ac1 TO FORMONLY.cn3
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
 
            IF g_rec_b1>=l_ac1 THEN
               BEGIN WORK
               LET g_success = 'Y'
               LET p_cmd='u'
               LET g_aen01_t = g_aen01         #BACKUP
               LET g_aen02_t = g_aen02         #BACKUP
               LET g_aen03_t = g_aen03         #BACKUP
               LET g_aen04_t = g_aen04         #BACKUP
               LET g_aen05_t = g_aen05         #BACKUP
               LET g_aen10_t = g_aen10         #BACKUP
               LET g_aen11_t = g_aen11         #BACKUP
               LET g_aen_t.* = g_aen[l_ac1].*  #BACKUP
               OPEN t004_bcl USING g_aen01,g_aen02,g_aen03,g_aen04,g_aen05,
                                   g_aen_t.aen06,g_aen_t.aen07,g_aen11
               IF STATUS THEN
                  CALL cl_err("OPEN t004_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
                  CLOSE t004_bcl
                  ROLLBACK WORK
               ELSE
                  FETCH t004_bcl INTO g_aen[l_ac1].*
                  IF SQLCA.sqlcode THEN
                      CALL cl_err('lock aen',SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_success = 'N'   #MOD-730060
               CANCEL INSERT
            END IF
            INSERT INTO aen_file(aen01,aen02,aen03,aen04,aen05,aen06,aen07,aen08,aen09,aen10,aen11,aenlegal)
                          VALUES(g_aen01,g_aen02,g_aen03,g_aen04,g_aen05,g_aen[l_ac1].aen06,
                                 g_aen[l_ac1].aen07,g_aen[l_ac1].aen08,g_aen09,
                                 g_aen10,g_aen11,g_legal)
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               LET g_success = 'N'   #MOD-730060
               CALL cl_err3("ins","aen_file",g_aen05,g_aen[l_ac1].aen06,SQLCA.sqlcode,"","ins aen",1)
               CANCEL INSERT
               ROLLBACK WORK
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b1=g_rec_b1+1
               DISPLAY g_rec_b1 TO FORMONLY.cn2
               COMMIT WORK
            END IF


        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_aen[l_ac1].* TO NULL      #900423
            LET g_aen_t.* = g_aen[l_ac1].*
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD aen06
 
 
        AFTER FIELD aen06
            IF NOT cl_null(g_aen[l_ac1].aen06) THEN
                  CALL t004_aag('a',g_aen[l_ac1].aen06)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_aen[l_ac1].aen06,g_errno,0)
                     NEXT FIELD aen06
                  END IF 
                  IF g_aen[l_ac1].aen06! = g_aen_t.aen06 OR g_aen_t.aen06 IS NULL THEN 
                      CALL t004_get_aen08()
                  END IF 
            END IF 
        AFTER FIELD aen07 
            IF NOT cl_null(g_aen[l_ac1].aen07) THEN
                  IF g_aen[l_ac1].aen07! = g_aen_t.aen07 OR g_aen_t.aen07 IS NULL THEN
                     CALL t004_get_aen08()
                  END IF 
            END IF

        AFTER FIELD aen08
            IF NOT cl_null(g_aen[l_ac1].aen08) THEN
               IF g_aen[l_ac1].aen08<0 THEN
                  NEXT FIELD aen08
               END IF 
            END IF 
        BEFORE DELETE                            #是否取消單身
            IF g_aen_t.aen06 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   LET g_success = 'N'
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   LET g_success = 'N' 
                   CANCEL DELETE
                END IF
                DELETE FROM aen_file
                 WHERE aen01 = g_aen01 AND aen02 = g_aen02 AND aen03 = g_aen03
                   AND aen04 = g_aen04 AND aen05 = g_aen05
                   AND aen06 = g_aen_t.aen06 AND aen07 = g_aen_t.aen07
                   AND aen11 = g_aen11 
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","aen_file","","",SQLCA.sqlcode,"","",1)  
                    LET g_success = 'N' 
                    CANCEL DELETE
                END IF
                IF g_success = 'Y' THEN
                   LET g_rec_b1=g_rec_b1-1
                   DISPLAY g_rec_b1 TO FORMONLY.cn2
                   COMMIT WORK
                ELSE
                   ROLLBACK WORK
                END IF
            END IF 
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_aen[l_ac1].* = g_aen_t.*
               CLOSE t004_bcl
               ROLLBACK WORK
               EXIT DIALOG
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_aen[l_ac1].aen06,-263,1)
               LET g_aen[l_ac1].* = g_aen_t.*
               LET g_success='N'   #MOD-730060
            ELSE
               UPDATE aen_file SET aen06 = g_aen[l_ac1].aen06,
                                   aen07 = g_aen[l_ac1].aen07,
                                   aen08 = g_aen[l_ac1].aen08
                WHERE aen01 = g_aen01 AND aen02 = g_aen02 AND aen03 = g_aen03
                  AND aen04 = g_aen04 AND aen05 = g_aen05 
                  AND aen06 = g_aen_t.aen06 AND aen07 = g_aen_t.aen07
                  AND aen11 = g_aen11
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","aen_file","","",SQLCA.sqlcode,"","upd aen",1) 
                  LET g_aen[l_ac1].* = g_aen_t.*
                  LET g_success='N'   
               END IF
            END IF
            IF g_success = 'Y' THEN
               MESSAGE 'UPDAET O.K'
               COMMIT WORK
            ELSE
               MESSAGE 'UPDATE ERR'
               ROLLBACK WORK
            END IF
 
        AFTER ROW
            LET l_ac1 = ARR_CURR()
            LET l_ac1_t = l_ac1
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_aen[l_ac1].* = g_aen_t.*
               END IF
               CLOSE t004_bcl
               ROLLBACK WORK
               EXIT DIALOG
            END IF
            CLOSE t004_bcl
            COMMIT WORK
 
       #yangtt---130819--mark---end--
       #ON ACTION controls                 
       # CALL cl_set_head_visible("","AUTO")
 
       #ON ACTION CONTROLP
       #    CASE
       #        WHEN INFIELD(aen06)
       #             CALL cl_init_qry_var()
       #             LET g_qryparam.form = "q_aag02"
       #             LET g_qryparam.default1 = g_aen[l_ac1].aen06
       #             LET g_qryparam.arg1 = g_aen11
       #             CALL cl_create_qry() RETURNING g_aen[l_ac1].aen06
       #             DISPLAY BY NAME g_aen[l_ac1].aen06
       #             NEXT FIELD aen06
       #       WHEN INFIELD(aen07)
       #             CALL cl_init_qry_var()
       #             LET g_qryparam.form = "q_axz"
       #             LET g_qryparam.default1 = g_aen[l_ac1].aen07
       #             CALL cl_create_qry() RETURNING g_aen[l_ac1].aen07
       #             DISPLAY BY NAME g_aen[l_ac1].aen07
       #             NEXT FIELD aen07
       #       OTHERWISE EXIT CASE
       #    END CASE
 
       #ON ACTION CONTROLZ
       #   CALL cl_show_req_fields()
 
       #ON ACTION CONTROLG
       #   CALL cl_cmdask()
 
 
       #ON ACTION CONTROLF
       # CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
       # CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
       # ON IDLE g_idle_seconds
       #    CALL cl_on_idle()
       #    CONTINUE DIALOG
 
       # ON ACTION about        
       #    CALL cl_about()    
 
       # ON ACTION help          
       #    CALL cl_show_help() 
       #yangtt---130819--mark---end--
 
 
      END INPUT
     
      INPUT ARRAY g_aeo FROM s_aeo.*
            ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS = TRUE,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b2 != 0 THEN
               CALL fgl_set_arr_curr(l_ac2)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac2 = ARR_CURR()
            DISPLAY l_ac2 TO FORMONLY.cn3
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
            LET g_success = 'Y'   
            BEGIN WORK
 
            IF g_rec_b2>=l_ac2 THEN
               LET p_cmd='u'
               LET g_aeo_t.* = g_aeo[l_ac2].*  #BACKUP
               OPEN t004_bcl_aeo USING g_aen01,g_aen02,g_aen03,g_aen04,g_aen05,
                                       g_aeo_t.aeo06,g_aeo_t.aeo07,g_aen11                                       
               IF STATUS THEN
                  CALL cl_err("OPEN t004_bcl_aeo:", STATUS, 1)
                  LET l_lock_sw = "Y"
                  CLOSE t004_bcl_aeo
                  ROLLBACK WORK
               ELSE
                  FETCH t004_bcl_aeo INTO b_aeo.*
                  IF SQLCA.sqlcode THEN
                      CALL cl_err('lock aeo',SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                  ELSE
                      CALL t004_b_move_to()
                  END IF
               END IF
               CALL cl_show_fld_cont()    
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_success = 'N'   
               CANCEL INSERT
            END IF
            CALL t004_b_move_back()     
                    
            INSERT INTO aeo_file VALUES(b_aeo.aeo01,b_aeo.aeo02,b_aeo.aeo03,b_aeo.aeo04,
                                        b_aeo.aeo05,b_aeo.aeo06,b_aeo.aeo07,b_aeo.aeo08,
                                        b_aeo.aeo09,b_aeo.aeo10,b_aeo.aeo11,b_aeo.aeo12,
                                        b_aeo.aeo13,b_aeo.aeo14,b_aeo.aeo15,b_aeo.aeo16,
                                        b_aeo.aeo17,b_aeo.aeo18,b_aeo.aeo19,b_aeo.aeo20,
                                        b_aeo.aeo21,b_aeo.aeo22,b_aeo.aeolegal)
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               LET g_success = 'N'   
               CALL cl_err3("ins","aeo_file","","",SQLCA.sqlcode,"","ins aeo",1)  
               CANCEL INSERT
               ROLLBACK WORK
            ELSE
               MESSAGE 'INSERT O.K'                                
               LET g_rec_b2=g_rec_b2+1
               DISPLAY g_rec_b2 TO FORMONLY.cn3
               COMMIT WORK
            END IF
            
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_aeo[l_ac2].* TO NULL    
            LET b_aeo.aeo01=g_aen01
            LET b_aeo.aeo02=g_aen02
            LET b_aeo.aeo03=g_aen03
            LET b_aeo.aeo04=g_aen04
            LET b_aeo.aeo05=g_aen05
            LET b_aeo.aeo11=g_aen11      
            LET b_aeo.aeolegal=g_legal     
            LET g_aeo_t.* = g_aeo[l_ac2].*
            CALL cl_show_fld_cont()      
            NEXT FIELD aeo06
 
        AFTER FIELD aeo06  #被投公司编号
           IF NOT cl_null(g_aeo[l_ac2].aeo06) THEN 
              IF p_cmd = 'a' OR ( g_aeo_t.aeo06! = g_aeo[l_ac2].aeo06 OR g_aeo_t.aeo06 IS NULL) THEN
                 LET l_n = 0
                 SELECT COUNT(*) INTO l_n FROM aeo_file
                  WHERE aeo01 = g_aen01 AND aeo02 = g_aen02
                    AND aeo03 = g_aen03 AND aeo04 = g_aen04
                    AND aeo05 = g_aen05 AND aeo06 = g_aeo[l_ac2].aeo06
                    AND aeo07 = g_aeo[l_ac2].aeo07
                 IF l_n>0 THEN
                    CALL cl_err('',-239,0)
                    LET g_aeo[l_ac2].aeo06 = g_aeo_t.aeo06
                    NEXT FIELD aeo06
                 END IF 
                 SELECT axz01 INTO l_axz01 FROM axz_file WHERE axz08 = g_aeo[l_ac2].aeo06
                    AND axz01 IN(SELECT axb04 FROM axa_file,axb_file
                                  WHERE axa01 = axb01 AND axa02 = axb02
                                    AND axa03 = axb03 AND axa01 = g_aen03
                                    AND axa02 = g_aen05 )
                 LET l_n = 0
                  SELECT COUNT(*) INTO l_n FROM axz_file
                   WHERE axz08 = g_aeo[l_ac2].aeo06
                 IF l_n<1 THEN 
                    LET g_aeo[l_ac2].aeo06 = g_aeo_t.aeo06
                    CALL cl_err('','agl-323',0)
                    NEXT FIELD aeo06
                 ELSE
                    SELECT axz02,axz06 INTO g_aeo[l_ac2].aeo06_desc,g_aeo[l_ac2].aeo09 FROM axz_file
                     WHERE axz01 = l_axz01    
                    DISPLAY BY NAME g_aeo[l_ac2].aeo06_desc 
                    DISPLAY BY NAME g_aeo[l_ac2].aeo09
                    SELECT azi04 INTO t_azi04_2 FROM azi_file
                     WHERE azi01 = g_aeo[l_ac2].aeo09
                     CALL s_get_aeo14(g_aen03,g_aen05,l_axz01,g_aen01,g_aen02) 
                          RETURNING g_aeo[l_ac2].aeo14
                     CALL s_get_aeo14_1(g_aen03,g_aen05,l_axz01,g_aen01,g_aen02)
                          RETURNING g_aeo[l_ac2].aeo14_1
                    DISPLAY BY NAME g_aeo[l_ac2].aeo14
                    CALL t004_get_aeo10(l_axz01,g_aeo[l_ac2].aeo07)
                      RETURNING g_aeo[l_ac2].aeo10,g_aeo[l_ac2].aeo19
                    CALL t004_get_aeo13(g_aeo[l_ac2].aeo10,g_aeo[l_ac2].aeo19,g_aeo[l_ac2].aeo11,g_aeo[l_ac2].aeo12)
                       RETURNING g_aeo[l_ac2].aeo13,g_aeo[l_ac2].aeo20
                    CALL t004_get_aeo16(g_aeo[l_ac2].aeo13,g_aeo[l_ac2].aeo20,g_aeo[l_ac2].aeo14,g_aeo[l_ac2].aeo14_1)  
                       RETURNING g_aeo[l_ac2].aeo16,g_aeo[l_ac2].aeo21
                 END IF 
              END IF 
           ELSE
              NEXT FIELD aeo06
           END IF   

        AFTER FIELD aeo07   #所有者权益科目
           IF NOT cl_null(g_aeo[l_ac2].aeo07) THEN
              IF g_aeo[l_ac2].aeo07!=g_aeo_t.aeo07 OR g_aeo_t.aeo07 IS NULL THEN
                 LET l_n = 0
                 SELECT COUNT(*) INTO l_n FROM aeo_file
                  WHERE aeo01 = g_aen01 AND aeo02 = g_aen02
                    AND aeo03 = g_aen03 AND aeo04 = g_aen04
                    AND aeo05 = g_aen05 AND aeo06 = g_aeo[l_ac2].aeo06
                    AND aeo07 = g_aeo[l_ac2].aeo07
                 IF l_n>0 THEN
                    CALL cl_err('',-239,0)
                    LET g_aeo[l_ac2].aeo07 = g_aeo_t.aeo07
                    NEXT FIELD aeo07
                 END IF
                 CALL t004_aag('a',g_aeo[l_ac2].aeo07)         
                 IF NOT cl_null(g_errno) THEN
                    LET g_aeo[l_ac2].aeo07 = g_aeo_t.aeo07
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD aeo07
                 ELSE
                    SELECT axz01 INTO l_axz01 FROM axz_file WHERE axz08 = g_aeo[l_ac2].aeo06
                       AND axz01 IN(SELECT axb04 FROM axa_file,axb_file
                                     WHERE axa01 = axb01 AND axa02 = axb02
                                      AND axa03 = axb03 AND axa01 = g_aen03
                                       AND axa02 = g_aen05 )
                    SELECT azi04 INTO t_azi04_2 FROM azi_file
                     WHERE azi01 = g_aeo[l_ac2].aeo09
                    CALL t004_get_aeo10(l_axz01,g_aeo[l_ac2].aeo07)
                      RETURNING g_aeo[l_ac2].aeo10,g_aeo[l_ac2].aeo19
                    CALL t004_get_aeo13(g_aeo[l_ac2].aeo10,g_aeo[l_ac2].aeo19,g_aeo[l_ac2].aeo11,g_aeo[l_ac2].aeo12)
                       RETURNING g_aeo[l_ac2].aeo13,g_aeo[l_ac2].aeo20
                    CALL t004_get_aeo16(g_aeo[l_ac2].aeo13,g_aeo[l_ac2].aeo20,g_aeo[l_ac2].aeo14,g_aeo[l_ac2].aeo14_1)  
                       RETURNING g_aeo[l_ac2].aeo16,g_aeo[l_ac2].aeo21
                 END IF 
              END IF 
           END IF 

        AFTER FIELD aeo11  #再衡量汇率 
           IF NOT cl_null(g_aeo[l_ac2].aeo11) THEN
              IF g_aeo[l_ac2].aeo11! = g_aeo_t.aeo11 OR g_aeo_t.aeo11 IS NULL THEN
                 IF g_aeo[l_ac2].aeo11 <0 THEN
                    CALL cl_err('','aim-223',0)
                    NEXT FIELD aeo11
                 ELSE
                    CALL t004_get_aeo13(g_aeo[l_ac2].aeo10,g_aeo[l_ac2].aeo19,g_aeo[l_ac2].aeo11,g_aeo[l_ac2].aeo12)
                       RETURNING g_aeo[l_ac2].aeo13,g_aeo[l_ac2].aeo20
                    CALL t004_get_aeo16(g_aeo[l_ac2].aeo13,g_aeo[l_ac2].aeo20,g_aeo[l_ac2].aeo14,g_aeo[l_ac2].aeo14_1)   
                       RETURNING g_aeo[l_ac2].aeo16,g_aeo[l_ac2].aeo21
                    DISPLAY BY NAME g_aeo[l_ac2].aeo13
                    DISPLAY BY NAME g_aeo[l_ac2].aeo20
                    DISPLAY BY NAME g_aeo[l_ac2].aeo16
                    DISPLAY BY NAME g_aeo[l_ac2].aeo21
                 END IF 
              END IF
           END IF 

        AFTER FIELD aeo12  #转换汇率
           IF NOT cl_null(g_aeo[l_ac2].aeo12) THEN
              IF g_aeo[l_ac2].aeo12! = g_aeo_t.aeo12 OR g_aeo_t.aeo12 IS NULL THEN
                 IF g_aeo[l_ac2].aeo12 <0 THEN
                    CALL cl_err('','aim-223',0) 
                    NEXT FIELD aeo12
                 ELSE
                    CALL t004_get_aeo13(g_aeo[l_ac2].aeo10,g_aeo[l_ac2].aeo19,g_aeo[l_ac2].aeo11,g_aeo[l_ac2].aeo12)
                       RETURNING g_aeo[l_ac2].aeo13,g_aeo[l_ac2].aeo20
                    CALL t004_get_aeo16(g_aeo[l_ac2].aeo13,g_aeo[l_ac2].aeo20,g_aeo[l_ac2].aeo14,g_aeo[l_ac2].aeo14_1)   
                       RETURNING g_aeo[l_ac2].aeo16,g_aeo[l_ac2].aeo21
                    DISPLAY BY NAME g_aeo[l_ac2].aeo13
                    DISPLAY BY NAME g_aeo[l_ac2].aeo20
                    DISPLAY BY NAME g_aeo[l_ac2].aeo16
                    DISPLAY BY NAME g_aeo[l_ac2].aeo21
                 END IF 
              END IF 
           END IF  

        AFTER FIELD aeo14   #投资比例%
           IF NOT cl_null(g_aeo[l_ac2].aeo14) THEN
              IF g_aeo[l_ac2].aeo14!=g_aeo_t.aeo14 OR g_aeo_t.aeo14 IS NULL THEN
                 IF g_aeo[l_ac2].aeo14<0 THEN
                    CALL cl_err('','aim-223',0)
                    NEXT FIELD aeo14
                 ELSE
                    CALL t004_get_aeo16(g_aeo[l_ac2].aeo13,g_aeo[l_ac2].aeo20,g_aeo[l_ac2].aeo14,g_aeo[l_ac2].aeo14_1)  
                       RETURNING g_aeo[l_ac2].aeo16,g_aeo[l_ac2].aeo21
                    DISPLAY BY NAME g_aeo[l_ac2].aeo16
                    DISPLAY BY NAME g_aeo[l_ac2].aeo21
                 END IF 
              END IF 
           END IF        

        AFTER FIELD aeo15  #投资股权科目
           IF NOT cl_null(g_aeo[l_ac2].aeo15) THEN
              IF g_aeo[l_ac2].aeo15!=g_aeo_t.aeo15 OR g_aeo_t.aeo15 IS NULL THEN
                 CALL t004_aag('a',g_aeo[l_ac2].aeo15)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD aeo15 
                 END IF 
              END IF 
           END IF 

        AFTER FIELD aeo17  #期初余额调整科目
           IF NOT cl_null(g_aeo[l_ac2].aeo17) THEN
              IF g_aeo[l_ac2].aeo17!=g_aeo_t.aeo17 OR g_aeo_t.aeo17 IS NULL THEN
                 CALL t004_aag('a',g_aeo[l_ac2].aeo17)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD aeo17
                 END IF 
              END IF 
           END IF 

        AFTER FIELD aeo22  #本期发生调整科目
           IF NOT cl_null(g_aeo[l_ac2].aeo22) THEN
              IF g_aeo[l_ac2].aeo22!=g_aeo_t.aeo22 OR g_aeo_t.aeo22 IS NULL THEN
                 CALL t004_aag('a',g_aeo[l_ac2].aeo22)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD aeo22
                 END IF
              END IF
           END IF
        BEFORE DELETE                            #是否取消單身
            IF  g_aeo_t.aeo06 IS NOT NULL AND g_aeo_t.aeo06 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   LET g_success = 'N'   
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   LET g_success = 'N'   
                   CANCEL DELETE
                END IF
                DELETE FROM aeo_file
                 WHERE aeo01=g_aen01 AND aeo02 = g_aen02 AND aeo03 = g_aen03
                   AND aeo04=g_aen04 AND aeo05 = g_aen05 
                   AND aeo06=g_aeo_t.aeo06 AND aeo18 = g_aen11
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","aeo_file","","",SQLCA.sqlcode,"","",1)  
                    LET g_success = 'N'
                    CANCEL DELETE
                END IF
                IF g_success = 'Y' THEN
                   LET g_rec_b2=g_rec_b2-1
                   DISPLAY g_rec_b2 TO FORMONLY.cn3
                   #IF cl_null(g_aeo_t.aeo06) THEN
                   #   LET g_rec_b2=g_rec_b2-1
                   #END IF
                   COMMIT WORK
                ELSE
                   ROLLBACK WORK
                END IF
            END IF   
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_aeo[l_ac2].* = g_aeo_t.*
               CLOSE t004_bcl_aeo
               ROLLBACK WORK
               EXIT DIALOG
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err('',-263,1)
               LET g_aeo[l_ac2].* = g_aeo_t.*
               LET g_success='N'   
            ELSE
               CALL t004_b_move_back()
               UPDATE aeo_file SET * = b_aeo.*
                WHERE aeo01=g_aen01 AND aeo02 = g_aen02 AND aeo03 = g_aen03
                  AND aeo04=g_aen04 AND aeo05 = g_aen05 AND aeo06 = g_aeo_t.aeo06  
                  AND aeo07=g_aeo_t.aeo07
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","aeo_file","","",SQLCA.sqlcode,"","upd aeo",1)  
                  LET g_aeo[l_ac2].* = g_aeo_t.*
                  LET g_success='N'   
               END IF 
            END IF 
            IF g_success = 'Y' THEN
               MESSAGE 'UPDAET O.K'
               COMMIT WORK
            ELSE
               MESSAGE 'UPDATE ERR'
               ROLLBACK WORK
            END IF

        AFTER ROW
            LET l_ac2 = ARR_CURR()
            LET l_ac2_t = l_ac2
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_aeo[l_ac2].* = g_aeo_t.*
               END IF
               CLOSE t004_bcl_aeo
               ROLLBACK WORK
               EXIT DIALOG
            END IF
            CLOSE t004_bcl_aeo
            COMMIT WORK
      END INPUT   #yangtt 130819 add
 
        ON ACTION CONTROLP
            CASE
             #yangtt---130819--add--str
                WHEN INFIELD(aen06)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_aag02"
                     LET g_qryparam.default1 = g_aen[l_ac1].aen06
                     LET g_qryparam.arg1 = g_aen11
                     CALL cl_create_qry() RETURNING g_aen[l_ac1].aen06
                     DISPLAY BY NAME g_aen[l_ac1].aen06
                     NEXT FIELD aen06
               WHEN INFIELD(aen07)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_axz"
                     LET g_qryparam.default1 = g_aen[l_ac1].aen07
                     CALL cl_create_qry() RETURNING g_aen[l_ac1].aen07
                     DISPLAY BY NAME g_aen[l_ac1].aen07
                     NEXT FIELD aen07
             #yangtt---130819--add--end
                WHEN INFIELD(aeo06)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_axz"   
                     LET g_qryparam.default1 = g_aeo[l_ac2].aeo06
                     CALL cl_create_qry() RETURNING g_aeo[l_ac2].aeo06
                     DISPLAY BY NAME g_aeo[l_ac2].aeo06
                     NEXT FIELD aeo06
                WHEN INFIELD(aeo07)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_aag02"
                     LET g_qryparam.default1 = g_aeo[l_ac2].aeo07
                     LET g_qryparam.arg1 = g_aen11
                     CALL cl_create_qry() RETURNING g_aeo[l_ac2].aeo07
                     DISPLAY BY NAME g_aeo[l_ac2].aeo07
                     NEXT FIELD aeo07
                WHEN INFIELD(aeo15)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_aag02"
                     LET g_qryparam.default1 = g_aeo[l_ac2].aeo15
                     LET g_qryparam.arg1 = g_aen11
                     CALL cl_create_qry() RETURNING g_aeo[l_ac2].aeo15
                     DISPLAY BY NAME g_aeo[l_ac2].aeo15
                     NEXT FIELD aeo15
               WHEN INFIELD(aeo17)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_aag02"
                     LET g_qryparam.default1 = g_aeo[l_ac2].aeo17
                     LET g_qryparam.arg1 = g_aen11
                     CALL cl_create_qry() RETURNING g_aeo[l_ac2].aeo17
                     DISPLAY BY NAME g_aeo[l_ac2].aeo17
                     NEXT FIELD aeo17
               WHEN INFIELD(aeo22)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_aag02"
                     LET g_qryparam.default1 = g_aeo[l_ac2].aeo22
                     LET g_qryparam.arg1 = g_aen11
                     CALL cl_create_qry() RETURNING g_aeo[l_ac2].aeo22
                     DISPLAY BY NAME g_aeo[l_ac2].aeo22
                     NEXT FIELD aeo22
               OTHERWISE EXIT CASE
            END CASE
    #yangtt--mark---str-- 
    #   ON ACTION CONTROLF
    #    CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
    #    CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
    #    ON IDLE g_idle_seconds
    #       CALL cl_on_idle()
    #       CONTINUE DIALOG
 
    # ON ACTION about         
    #    CALL cl_about()    
 
    # END INPUT
    #yangtt--mark---end-- 
     
      ON ACTION accept
         ACCEPT DIALOG

      ON ACTION cancel
         EXIT DIALOG


      #ON ACTION CONTROLZ  #yangtt 130819
       ON ACTION CONTROLR  #yangtt 130819
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controls                               
         CALL cl_set_head_visible("","AUTO")

    END DIALOG 
     
    CLOSE t004_bcl
    CLOSE t004_bcl_aeo
    COMMIT WORK
    CALL t004_show()
END FUNCTION
 
FUNCTION t004_b_fill(p_wc)              #BODY FILL UP
DEFINE p_wc          LIKE type_file.chr1000   #No.FUN-680123 VARCHAR(200)
 
    IF cl_null(p_wc) THEN LET p_wc = " 1=1" END IF 
    LET g_sql = "SELECT aen06,aen07,aen08 FROM aen_file ",
                " WHERE aen01 = '",g_aen01,"' AND aen02 = '",g_aen02,"'",
                "   AND aen03 = '",g_aen03,"' AND aen04 = '",g_aen04,"'",
                "   AND aen05 = '",g_aen05,"' AND aen11 = '",g_aen11,"'",
                "   AND ",p_wc CLIPPED,                     #單身
                " ORDER BY aen06"
 
    PREPARE t004_pb FROM g_sql
    DECLARE aen_curs                       #SCROLL CURSOR
        CURSOR FOR t004_pb
    CALL g_aen.clear()
    LET g_rec_b1 = 0
    LET g_cnt = 1
    FOREACH aen_curs INTO g_aen[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_aen.deleteElement(g_cnt)
    LET g_rec_b1=g_cnt - 1
    DISPLAY g_rec_b1 TO FORMONLY.cn2
     CALL t004_bp_refresh()
END FUNCTION
 

FUNCTION t004_b_fill2(p_wc2)
DEFINE p_wc2    LIKE type_file.chr1000
DEFINE l_axz01  LIKE axz_file.axz01   
    IF cl_null(p_wc2) THEN LET p_wc2 = " 1=1" END IF 
    LET g_sql = "SELECT aeo06,'',aeo08,aeo07,aeo09,aeo10,aeo19,aeo11,aeo12,",
                "       aeo13,aeo20,'',aeo14,aeo15,aeo16,aeo21,aeo17,aeo22 ",
                "  FROM aeo_file WHERE aeo01 = '",g_aen01,"'",
                "   AND aeo02 = '",g_aen02,"' AND aeo03 = '",g_aen03,"'",
                "   AND aeo04 = '",g_aen04,"'",
                "   AND aeo05 = '",g_aen05,"' AND aeo18 = '",g_aen11,"'",
                "   AND ",p_wc2 CLIPPED,
                " ORDER BY aeo06"
    PREPARE t004_pb_2 FROM g_sql
    DECLARE t004_aeo_curs CURSOR FOR t004_pb_2
    CALL g_aeo.clear()
    LET g_rec_b2 = 0
    LET g_cnt = 1
    FOREACH t004_aeo_curs INTO g_aeo[g_cnt].*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       SELECT axz02 INTO g_aeo[g_cnt].aeo06_desc FROM axz_file WHERE axz01 = g_aeo[g_cnt].aeo06
       SELECT axz01 INTO l_axz01 FROM axz_file WHERE axz08 = g_aeo[g_cnt].aeo06
          AND axz01 IN(SELECT axb04 FROM axa_file,axb_file
                        WHERE axa01 = axb01 AND axa02 = axb02
                          AND axa03 = axb03 AND axa01 = g_aen03
                          AND axa02 = g_aen05 )
       CALL s_get_aeo14_1(g_aen03,g_aen05,l_axz01,g_aen01,g_aen02)  
            RETURNING g_aeo[g_cnt].aeo14_1
       LET g_cnt = g_cnt +1
       IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_aeo.deleteElement(g_cnt)
    LET g_rec_b2=g_cnt - 1
    DISPLAY g_rec_b2 TO FORMONLY.cn2
    CALL t004_bp_refresh_2()
END FUNCTION   

FUNCTION t004_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      #No.FUN-680123 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DIALOG ATTRIBUTES(UNBUFFERED) 
   
   DISPLAY ARRAY g_aen TO s_aen.* ATTRIBUTE(COUNT=g_rec_b1)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         LET g_b_flag='1'     
 
      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         CALL cl_show_fld_cont()  
         
         
      AFTER DISPLAY              
        CONTINUE DIALOG          
        
   END DISPLAY
   DISPLAY ARRAY g_aeo TO s_aeo.* ATTRIBUTE(COUNT=g_rec_b2)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         LET g_b_flag='2'     
         
      BEFORE ROW
         LET l_ac2 = ARR_CURR()
         CALL cl_show_fld_cont()               
 
      AFTER DISPLAY                              
        CONTINUE DIALOG                           
        
   END DISPLAY                                    
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DIALOG                      
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG                     
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DIALOG                    
 
      #ON ACTION modify
      #   LET g_action_choice="modify"
      #   EXIT DIALOG                   

      ON ACTION first
         CALL t004_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b1 != 0 THEN
            CALL DIALOG.setCurrentRow("s_aeo",1)  
         END IF
         EXIT DIALOG
 
      ON ACTION previous
         CALL t004_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b1 != 0 THEN
            CALL DIALOG.setCurrentRow("s_aeo",1)
         END IF
	 EXIT DIALOG
 
      ON ACTION jump
         CALL t004_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b1 != 0 THEN
            CALL DIALOG.setCurrentRow("s_aeo",1)  
         END IF
	 EXIT DIALOG
 
      ON ACTION next
         CALL t004_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b1 != 0 THEN
            CALL DIALOG.setCurrentRow("s_aeo",1)  
         END IF
   	 EXIT DIALOG
 
      ON ACTION last
         CALL t004_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b1 != 0 THEN
            CALL DIALOG.setCurrentRow("s_aeo",1)  
         END IF
	 EXIT DIALOG 
 
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DIALOG 
         LET l_ac1 = 1
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG 
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG                  
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG                   
 
      ON ACTION gen_entry #调整分錄產生
         LET g_action_choice="gen_entry"
         EXIT DIALOG                     
 
      ON ACTION qry_sheet #查询调整分录
         LET g_action_choice="qry_sheet"
         EXIT DIALOG                      
 
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac1 = ARR_CURR()
         EXIT DIALOG           
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DIALOG               
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         EXIT DIALOG                
 

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG            
 
      ON ACTION about       
         CALL cl_about()   
 
      ON ACTION controls                        
         CALL cl_set_head_visible("","AUTO")   
  
      #FUN-4B0017
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG      
      #--
      &include "qry_string.4gl"
   END DIALOG           
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t004_bp_refresh()
 
   #FUN-640246
   IF g_bgjob = 'Y' THEN
      RETURN
   END IF
   #END FUN-640246
 
   DISPLAY ARRAY g_aen TO s_aen.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END DISPLAY
END FUNCTION
       
FUNCTION t004_b_move_to()
   LET g_aeo[l_ac2].aeo06 = b_aeo.aeo06
   SELECT axz02 INTO g_aeo[l_ac2].aeo06_desc FROM aeo_file
    WHERE axa01 = g_aeo[l_ac2].aeo06
   LET g_aeo[l_ac2].aeo07 = b_aeo.aeo07
   LET g_aeo[l_ac2].aeo08 = b_aeo.aeo08
   LET g_aeo[l_ac2].aeo09 = b_aeo.aeo09
   LET g_aeo[l_ac2].aeo10 = b_aeo.aeo10
   LET g_aeo[l_ac2].aeo11 = b_aeo.aeo11
   LET g_aeo[l_ac2].aeo12 = b_aeo.aeo12
   LET g_aeo[l_ac2].aeo13 = b_aeo.aeo13
   LET g_aeo[l_ac2].aeo14 = b_aeo.aeo14
   LET g_aeo[l_ac2].aeo15 = b_aeo.aeo15
   LET g_aeo[l_ac2].aeo16 = b_aeo.aeo16
   LET g_aeo[l_ac2].aeo17 = b_aeo.aeo17
   LET g_aeo[l_ac2].aeo19 = b_aeo.aeo19
   LET g_aeo[l_ac2].aeo20 = b_aeo.aeo20
   LET g_aeo[l_ac2].aeo21 = b_aeo.aeo21
   LET g_aeo[l_ac2].aeo22 = b_aeo.aeo22
END FUNCTION
 
FUNCTION t004_b_move_back()
   INITIALIZE b_aeo.* TO NULL
   LET b_aeo.aeo01 = g_aen01
   LET b_aeo.aeo02 = g_aen02
   LET b_aeo.aeo03 = g_aen03
   LET b_aeo.aeo04 = g_aen04
   LET b_aeo.aeo05 = g_aen05
   LET b_aeo.aeo06 = g_aeo[l_ac2].aeo06 
   LET b_aeo.aeo07 = g_aeo[l_ac2].aeo07 
   SELECT axz08 INTO b_aeo.aeo08 FROM axz_file
    WHERE axz01 = g_aen05 
   LET b_aeo.aeo09 = g_aeo[l_ac2].aeo09 
   LET b_aeo.aeo10 = g_aeo[l_ac2].aeo10 
   LET b_aeo.aeo11 = g_aeo[l_ac2].aeo11 
   LET b_aeo.aeo12 = g_aeo[l_ac2].aeo12 
   LET b_aeo.aeo13 = g_aeo[l_ac2].aeo13 
   LET b_aeo.aeo14 = g_aeo[l_ac2].aeo14 
   LET b_aeo.aeo15 = g_aeo[l_ac2].aeo15  
   LET b_aeo.aeo16 = g_aeo[l_ac2].aeo16 
   LET b_aeo.aeo17 = g_aeo[l_ac2].aeo17  
   LET b_aeo.aeo18 = g_aen11
   LET b_aeo.aeo19 = g_aeo[l_ac2].aeo19
   LET b_aeo.aeo20 = g_aeo[l_ac2].aeo20
   LET b_aeo.aeo21 = g_aeo[l_ac2].aeo21
   LET b_aeo.aeo22 = g_aeo[l_ac2].aeo22
   LET b_aeo.aeolegal = g_legal
END FUNCTION
 

FUNCTION t004_bp_refresh_2()

   IF g_bgjob = 'Y' THEN
      RETURN
   END IF

   DISPLAY ARRAY g_aeo TO s_aeo.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help         
         CALL cl_show_help() 
 
      ON ACTION controlg     
         CALL cl_cmdask()     
 
 
   END DISPLAY
END FUNCTION


FUNCTION t004_aen03(p_cmd)  #族群编号
   DEFINE p_cmd     LIKE type_file.chr1 

   LET g_errno = ' '

   SELECT axa02 INTO g_aen04
     FROM axa_file WHERE axa01 = g_aen03
      AND axa04 = 'Y'

   CASE WHEN SQLCA.sqlcode = 100      LET g_errno = 'agl-246'
     OTHERWISE                        LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY g_aen04 TO aen04
   END IF 
END FUNCTION

FUNCTION t004_aac01(p_t1)
   DEFINE l_aacacti   LIKE aac_file.aacacti
   DEFINE l_aac11     LIKE aac_file.aac11
   DEFINE p_t1        LIKE aac_file.aac01

   LET g_errno = ' '
   SELECT aacacti INTO l_aacacti FROM aac_file
    WHERE aac01 = p_t1

   CASE  WHEN SQLCA.SQLCODE = 100  LET g_errno = 'agl-035'   
         WHEN l_aacacti = 'N'      LET g_errno = 'agl-321'
         WHEN l_aac11<>'Y'         LET g_errno = 'agl-322'
      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION

FUNCTION t004_aag(p_cmd,p_aag01)
DEFINE p_cmd     LIKE type_file.chr1
DEFINE p_aag01   LIKE aag_file.aag01
DEFINE l_aag02   LIKE aag_file.aag02
DEFINE l_aagacti LIKE aag_file.aagacti
DEFINE l_aag07   LIKE aag_file.aag07


   LET g_errno = ' '
   SELECT aag02,aag07,aagacti INTO l_aag02,l_aag07,l_aagacti 
     FROM aag_file
    WHERE aag00 = g_aen11 AND aag01 = p_aag01
   CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-001'
        WHEN l_aagacti = 'N'     LET g_errno = '9028'
        WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
        OTHERWISE           LET g_errno = SQLCA.sqlcode USING '----------'
   END CASE

END FUNCTION

FUNCTION t004_v()
DEFINE l_axi RECORD LIKE axi_file.*
DEFINE l_axj RECORD LIKE axj_file.* 
DEFINE l_aeo RECORD LIKE aeo_file.*
DEFINE l_aeo06_t LIKE aeo_file.aeo06
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_aen08   LIKE aen_file.aen08
DEFINE li_result LIKE type_file.num5
DEFINE l_axi11   LIKE axi_file.axi11
DEFINE l_axi12   LIKE axi_file.axi12
DEFINE l_axz08   LIKE axz_file.axz08
DEFINE g_t1      LIKE aac_file.aac01
DEFINE i         LIKE type_file.num5   
#FUN-B90057--add--str--
DEFINE l_amt     LIKE aeo_file.aeo15
DEFINE l_aeo06   LIKE aeo_file.aeo06
DEFINE l_aeo15   LIKE aeo_file.aeo15
#FUN-B90057--add-end
DEFINE l_aen06   LIKE aen_file.aen06   #NO.130806 add

   SELECT COUNT(*) INTO l_cnt FROM axi_file
    WHERE axi00 = g_aen11 AND axi00 = g_aen11 AND axi01 = g_aen10
   IF l_cnt > 0 THEN
      IF NOT s_ask_entry(g_aen10) THEN RETURN END IF #Genero
   END IF
   DELETE FROM axi_file WHERE axi00 = g_aen11 AND axi01 = g_aen10
   DELETE FROM axj_file WHERE axj00 = g_aen11 AND axj01 = g_aen10 

   LET p_row = 12 LET p_col = 10
   OPEN WINDOW t0041_w AT 14,10 WITH FORM "agl/42f/aglt0041"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("aglt0041")
   INPUT g_t1 WITHOUT DEFAULTS FROM aac01
     AFTER FIELD aac01
        IF NOT cl_null(g_t1) THEN
           CALL t004_aac01(g_t1)
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('aac01',g_errno,0)
              NEXT FIELD aac01
           END IF
        ELSE
           NEXT FIELD aac01
        END IF
     ON ACTION CONTROLP
         CASE WHEN INFIELD(aac01)
              CALL q_aac(FALSE,TRUE,g_t1,'A','','','AGL') RETURNING g_t1
              DISPLAY g_t1 TO aac01
              NEXT FIELD aac01
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

   CLOSE WINDOW t0041_w                 #結束畫面
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   INITIALIZE l_axi.* TO NULL 
   INITIALIZE l_axj.* TO NULL
   INITIALIZE l_aeo.* TO NULL
   CALL s_showmsg_init()
   LET g_success = 'Y'
   BEGIN WORK
   CALL s_auto_assign_no("AGL",g_t1,g_today,"","axi_file","axi01",g_plant,2,g_aen11)
               RETURNING li_result,l_axi.axi01
   IF (NOT li_result) THEN
      CALL s_errmsg('axi_file','axi01',l_axi.axi01,'abm-621',1)
      LET g_success = 'N'
   END IF
   ####产生调整分录单头档
   LET l_axi.axi00 = g_aen11
   #130808 mod by tangyh--str
   #LET l_axi.axi02 = g_today  
   LET g_yy = YEAR(g_today)
 # LET g_mm = MONTH(g_today)  
   LET g_mm = g_aen02   # modify by lily 130809   
   CALL s_azn01(g_yy,g_mm) RETURNING g_bdate,g_edate
   LET l_axi.axi02 = g_edate
   #130808 mod by tangyh--end   
   LET l_axi.axi03 = g_aen01
   LET l_axi.axi04 = g_aen02
   LET l_axi.axi05 = g_aen03
   LET l_axi.axi06 = g_aen05
   SELECT axz05 INTO l_axi.axi07
     FROM axz_file WHERE axz01 = l_axi.axi06
   LET l_axi.axi08 = '1'  #调整作业
   LET l_axi.axi081= 'U'
   LET l_axi.axi11 = 0    #单身产生后回写
   LET l_axi.axi21 = '00' #版本
   LET l_axi.axi12 = 0    #单身产生后回写
   LET l_axi.axiconf = 'Y'
   LET l_axi.axiuser = g_user
   LET l_axi.axigrup = g_grup
   LET l_axi.axilegal=g_legal  #所属法人   
   
   LET l_axi.axi09='N' #added by leizj 130802

   #FUN-B80135--add--str--
    IF l_axi.axi03 < g_year OR (l_axi.axi03 = g_year AND l_axi.axi04<=g_month) THEN
       CALL cl_err('','axm-164',0)
       LET g_success='N'
       RETURN
      END IF
      #FUN-B80135--add--end 

   INSERT INTO axi_file VALUES(l_axi.*)
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL s_errmsg('axi_file','insert',l_axi.axi01,SQLCA.sqlcode,1)    
      LET g_success = 'N'
   END IF 
   #FUN-B90057--add--str--
   LET l_axj.axj01 = l_axi.axi01
   LET l_axj.axj00 = l_axi.axi00
   LET g_sql = "SELECT SUM(aeo16+aeo21),aeo06,aeo15 FROM aeo_file ",
               " WHERE aeo01 = '",g_aen01,"' AND aeo02 = '",g_aen02,"'",
               "   AND aeo03 = '",g_aen03,"' AND aeo04 = '",g_aen04,"'",
               "   AND aeo05 = '",g_aen05,"' AND aeo18 = '",g_aen11,"'",
               " GROUP BY aeo06,aeo15",
               " ORDER BY aeo06,aeo15"
   PREPARE sel_aeo_pre FROM g_sql
   DECLARE sel_aeo_curs CURSOR FOR sel_aeo_pre
   FOREACH sel_aeo_curs INTO l_amt,l_aeo06,l_aeo15 
       IF STATUS THEN
          CALL s_errmsg('aeo_file','foreach','',STATUS,1)
          LET g_success = 'N'
       END IF
       SELECT MAX(axj02+1) INTO l_axj.axj02 FROM axj_file
        WHERE axj00 = l_axi.axi00 AND axj01 = l_axj.axj01
       IF cl_null(l_axj.axj02) THEN LET l_axj.axj02 = 1 END IF 
       #LET l_axj.axj03 = l_aeo15 #NO.130806 mark
       LET l_axj.axj05 = l_aeo06
       LET l_axj.axj06 = '1'
       #SELECT aen08 INTO l_aen08 FROM aen_file WHERE aen01 = g_aen01  #NO.130806 mark
       SELECT aen08,aen06 INTO l_aen08,l_aen06 FROM aen_file WHERE aen01 = g_aen01 #NO.130806 modify
          AND aen02 = g_aen02 AND aen03 = g_aen03 AND aen04 = g_aen04
          #AND aen05 = g_aen05 AND aen06 = l_aeo15 AND aen07 = l_aeo06   #NO.130806 mark
          AND aen05 = g_aen05  AND aen07 = l_aeo06   #NO.130806 modify
       IF cl_null(l_aen08) THEN LET l_aen08 = 0 END IF
       LET l_axj.axj03 = l_aen06   #NO.130806 add
       LET l_axj.axj07 = l_amt-l_aen08  
       LET l_axj.axjlegal = g_legal
       INSERT INTO axj_file VALUES(l_axj.*)    ##借方
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL s_errmsg('axj_file','insert',l_axi.axi01,SQLCA.sqlcode,1)
          LET g_success = 'N'
       END IF
       SELECT MAX(axj02+1) INTO l_axj.axj02 FROM axj_file
        WHERE axj00 = l_axi.axi00 AND axj01 = l_axj.axj01
       IF cl_null(l_axj.axj02) THEN LET l_axj.axj02 = 1 END IF
       LET l_axj.axj06 = '2'
       #LET l_axj.axj03 = g_aaw.aaw14    ###投資收益  #NO.130805 mark
       LET l_axj.axj03 = g_aaz.aaz103    ###投資收益  #NO.130805 modify
       INSERT INTO axj_file VALUES(l_axj.*)    ##借方
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL s_errmsg('axj_file','insert',l_axi.axi01,SQLCA.sqlcode,1)
          LET g_success = 'N'
       END IF
   END FOREACH
   #FUN-B90057--add--end
#FUN-B90057--mark--str--
#  LET g_sql = "SELECT * FROM aeo_file ",
#              " WHERE aeo01 = '",g_aen01,"' AND aeo02 = '",g_aen02,"'",
#              "   AND aeo03 = '",g_aen03,"' AND aeo04 = '",g_aen04,"'",
#              "   AND aeo05 = '",g_aen05,"' AND aeo18 = '",g_aen11,"'",
#              " ORDER BY aeo06,aeo07"
#  PREPARE sel_aeo_pre FROM g_sql
#  DECLARE sel_aeo_curs CURSOR FOR sel_aeo_pre
#  FOREACH sel_aeo_curs INTO l_aeo.* 
#      IF STATUS THEN 
#         CALL s_errmsg('aeo_file','foreach','',STATUS,1)
#         LET g_success = 'N'
#      END IF 
#      LET l_axj.axj01 = l_axi.axi01 
#      LET l_axj.axj00 = l_axi.axi00
#      LET l_axz08 = l_aeo.aeo06
#      LET l_axj.axj05 = l_aeo.aeo06
#      LET l_cnt = 0
#      SELECT COUNT(*) INTO l_cnt FROM axj_file WHERE axj00 = l_axj.axj00
#         AND axj01 = l_axj.axj01 AND axj06 = '1'  #借方     
#         AND axj03 = l_aeo.aeo15 
#         AND axj05 = l_axz08
#      IF l_cnt>0 THEN   #相同子公司相同投资公司股权科目借方金额才汇总
#         UPDATE axj_file SET axj07 = axj07+l_aeo.aeo16+l_aeo.aeo21
#          WHERE axj00 = l_axj.axj00 AND axj01 = l_axj.axj01
#            AND axj06 = '1' AND axj03 = l_aeo.aeo15 
#            AND axj05 = l_axz08
#         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#            CALL s_errmsg('axj_file','update',l_axi.axi01,SQLCA.sqlcode,1)
#            LET g_success = 'N'
#         END IF 
#         FOR i= 1 TO 2  
#            ######贷方要新增  
#            SELECT max(axj02) INTO l_axj.axj02 FROM axj_file
#             WHERE axj01 = l_axj.axj01 AND axj00 = l_axj.axj00
#            IF cl_null(l_axj.axj02) THEN LET l_axj.axj02 =0 END IF
#            LET l_axj.axj02 = l_axj.axj02+1
#            LET l_axj.axj06 = '2'
#            IF i = 1 THEN   
#               LET l_axj.axj07 = l_aeo.aeo16
#               LET l_axj.axj03 = l_aeo.aeo17
#            ELSE
#               LET l_axj.axj07 = l_aeo.aeo21
#               LET l_axj.axj03 = l_aeo.aeo22
#            END IF 
#            IF l_axj.axj07 = 0 THEN CONTINUE FOR END IF 
#             LET l_axj.axjlegal=g_legal   #所属法人
#            INSERT INTO axj_file VALUES(l_axj.*)
#            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#               CALL s_errmsg('axj_file','insert',l_axi.axi01,SQLCA.sqlcode,1)
#               LET g_success = 'N'
#            END IF
#         END FOR  
#      ELSE
#         ######借方
#         SELECT max(axj02) INTO l_axj.axj02 FROM axj_file 
#          WHERE axj01 = l_axj.axj01 AND axj00 = l_axj.axj00
#         IF cl_null(l_axj.axj02) THEN LET l_axj.axj02 =0 END IF 
#         LET l_axj.axj02 = l_axj.axj02+1 
#         LET l_axj.axj03 = l_aeo.aeo15
#         LET l_axj.axj06 = '1'
#         LET l_aen08 = 0
#         SELECT aen08 INTO l_aen08 FROM aen_file WHERE aen01 = g_aen01
#            AND aen02 = g_aen02 AND aen03 = g_aen03 AND aen04 = g_aen04
#            AND aen05 = g_aen05 AND aen06 = l_aeo.aeo15 AND aen07 = l_aeo.aeo06
#         IF cl_null(l_aen08) THEN LET l_aen08 = 0 END IF 
#         LET l_axj.axj07 = l_aeo.aeo16+l_aeo.aeo21-l_aen08  
#         LET l_axj.axjlegal = g_legal
#         INSERT INTO axj_file VALUES(l_axj.*) 
#         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#            CALL s_errmsg('axj_file','insert',l_axi.axi01,SQLCA.sqlcode,1)
#            LET g_success = 'N'
#         END IF 

#         FOR i= 1 TO 2  
#            #贷方
#            LET l_axj.axj06 = '2'
#            SELECT max(axj02) INTO l_axj.axj02 FROM axj_file
#             WHERE axj01 = l_axj.axj01 AND axj00 = l_axj.axj00
#            IF cl_null(l_axj.axj02) THEN LET l_axj.axj02 =1 END IF
#            LET l_axj.axj02 = l_axj.axj02+1
#            IF i = 1 THEN
#               LET l_axj.axj03 = l_aeo.aeo17
#               LET l_axj.axj07 = l_aeo.aeo16-l_aen08
#            ELSE
#               LET l_axj.axj03 = l_aeo.aeo22
#               LET l_axj.axj07 = l_aeo.aeo21
#            END IF 
#            IF l_axj.axj07 = 0 THEN CONTINUE FOR END IF 
#            LET l_axj.axjlegal=g_legal     #所属法人
#            INSERT INTO axj_file VALUES(l_axj.*)
#            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#               CALL s_errmsg('axj_file','insert',l_axi.axi01,SQLCA.sqlcode,1)
#               LET g_success = 'N'
#            END IF
#         END FOR 
#      ####INSERT
#      END IF 
#  END FOREACH
#FUN-B90057--mark--end
   #UPDATE axi_file  借方总金额,贷方总金额
   SELECT SUM(axj07) INTO l_axi11 FROM axj_file WHERE axj00 = l_axi.axi00
      AND axj01 = l_axi.axi01 AND axj06 = '1'   #借方
   SELECT SUM(axj07) INTO l_axi12 FROM axj_file WHERE axj00 = l_axi.axi00
      AND axj01 = l_axi.axi01 AND axj06 = '2'   #贷方
   IF cl_null(l_axi11) THEN LET l_axi11 = 0 END IF 
   IF cl_null(l_axi12) THEN LET l_axi12 = 0 END IF 
   UPDATE axi_file SET axi11 = l_axi11,
                       axi12 = l_axi12
    WHERE axi00 = l_axi.axi00
      AND axi01 = l_axi.axi01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL s_errmsg('axi_file','update',l_axi.axi01,SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF 
   UPDATE aen_file SET aen10 = l_axi.axi01
    WHERE aen01 = g_aen01 AND aen02 = g_aen02 AND aen03 = g_aen03
      AND aen04 = g_aen04 AND aen05 = g_aen05 AND aen11 = g_aen11
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL s_errmsg('aen_file','update',l_axi.axi01,SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      LET g_aen10 = l_axi.axi01
      DISPLAY g_aen10 TO aen10
   ELSE
      CALL s_showmsg() 
      ROLLBACK WORK
   END IF 
END FUNCTION 

FUNCTION t004_get_aen08()
DEFINE l_aen08 LIKE aen_file.aen08

    SELECT SUM(aek08-aek09) INTO l_aen08 FROM aek_file 
     WHERE aek01 = g_aen03 AND aek02 = g_aen05
       AND aek04 = g_aen[l_ac1].aen06 
       AND aek05 = g_aen[l_ac1].aen07
       AND aek06 = g_aen01 AND aek07 <= g_aen02 
   IF cl_null(l_aen08) THEN
      LET g_aen[l_ac1].aen08 = 0
   ELSE
      CALL cl_digcut(l_aen08,t_azi04_1) RETURNING l_aen08
      LET g_aen[l_ac1].aen08 = l_aen08
   END IF 
  
END FUNCTION

FUNCTION t004_get_aeo10(p_aeo06,p_aeo07)
DEFINE p_aeo06 LIKE aeo_file.aeo06   #被投资公司
DEFINE p_aeo07 LIKE aeo_file.aeo07   #所有者权益科目
DEFINE l_aeo10 LIKE aeo_file.aeo10   #期初金额
DEFINE l_aeo19 LIKE aeo_file.aeo19   #本期发生额
DEFINE l_amt0  LIKE aeo_file.aeo19   
DEFINE l_amt1  LIKE aeo_file.aeo19

   SELECT SUM(aej08-aej07) INTO l_aeo10 FROM aej_file   #期初余额
    WHERE aej01 = g_aen03 AND aej02 = p_aeo06
      AND aej04 = p_aeo07 AND aej05 = g_aen01
      AND aej06 = 0     #期别
   IF cl_null(l_aeo10) THEN
      SELECT SUM(axq09-axq08) INTO l_aeo10 FROM axq_file
       WHERE axq01 = g_aen03 AND axq04= p_aeo06
         AND axq05 = p_aeo07 AND axq06 = g_aen01-1
         AND axq07  = 12  #期别 
   END IF 
   IF cl_null(l_aeo10) THEN LET l_aeo10 = 0 END IF 
   SELECT SUM(aej08-aej07) INTO l_aeo19 FROM aej_file  #本期发生额
    WHERE aej01 = g_aen03 AND aej02 = p_aeo06
      AND aej04 = p_aeo07 AND aej05 = g_aen01
      AND aej06 BETWEEN 0 AND g_aen02     #期别  
   LET l_aeo19 = l_aeo19-l_aeo10  
   IF cl_null(l_aeo19) THEN
      SELECT SUM(axq09-axq08) INTO l_amt0 FROM axq_file
       WHERE axq01 = g_aen03 AND axq04= p_aeo06
         AND axq05 = p_aeo07 AND axq06 = g_aen01-1
         AND axq07  = 12  #期别
      IF cl_null(l_amt0) THEN LET l_amt0 = 0 END IF 
      SELECT SUM(axq09-axq08) INTO l_amt1 FROM axq_file
       WHERE axq01 = g_aen03 AND axq04= p_aeo06
         AND axq05 = p_aeo07 AND axq06 = g_aen01
         AND axq07  = g_aen02  #期别
      IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF 
      LET l_aeo19 = l_amt1-l_amt0
   END IF 
   IF cl_null(l_aeo10) THEN LET l_aeo10 = 0 END IF 
   IF cl_null(l_aeo19) THEN LET l_aeo19 = 0 END IF 
   CALL cl_digcut(l_aeo10,t_azi04_2) RETURNING l_aeo10
   CALL cl_digcut(l_aeo19,t_azi04_2) RETURNING l_aeo19

   RETURN l_aeo10,l_aeo19
END FUNCTION

FUNCTION t004_get_aeo13(p_aeo10,p_aeo19,p_aeo11,p_aeo12)
DEFINE p_aeo10 LIKE aeo_file.aeo10
DEFINE p_aeo19 LIKE aeo_file.aeo19
DEFINE p_aeo11 LIKE aeo_file.aeo11
DEFINE p_aeo12 LIKE aeo_file.aeo12
DEFINE l_aeo13 LIKE aeo_file.aeo13
DEFINE l_aeo20 LIKE aeo_file.aeo20

  IF cl_null(p_aeo11) THEN LET p_aeo11 = 0 END IF
  IF cl_null(p_aeo12) THEN LET p_aeo12 = 0 END IF
  LET l_aeo13 = p_aeo10*p_aeo11*p_aeo12
  LET l_aeo20 = p_aeo19*p_aeo11*p_aeo12
  CALL cl_digcut(l_aeo13,t_azi04_1) RETURNING l_aeo13
  CALL cl_digcut(l_aeo20,t_azi04_1) RETURNING l_aeo20

  RETURN l_aeo13,l_aeo20
END FUNCTION

FUNCTION t004_get_aeo16(p_aeo13,p_aeo20,p_aeo14,p_aeo14_1)   
DEFINE p_aeo13 LIKE aeo_file.aeo13
DEFINE p_aeo20 LIKE aeo_file.aeo20
DEFINE p_aeo14 LIKE aeo_file.aeo14
DEFINE p_aeo14_1 LIKE aeo_file.aeo14   
DEFINE l_aeo16 LIKE aeo_file.aeo16
DEFINE l_aeo21 LIKE aeo_file.aeo21

  IF cl_null(p_aeo14) THEN LET p_aeo14 = 0 END IF 
  IF cl_null(p_aeo14_1) THEN LET p_aeo14_1 = 0 END IF   
  #LET l_aeo16 = p_aeo13*p_aeo14/100   
  LET l_aeo16 = p_aeo13*p_aeo14_1/100  
  #LET l_aeo21 = p_aeo20*p_aeo14/100  
  LET l_aeo21 = (p_aeo13+p_aeo20)*p_aeo14/100-l_aeo16  
  IF cl_null(l_aeo16) THEN LET l_aeo16 = 0 END IF 
  IF cl_null(l_aeo21) THEN LET l_aeo21 = 0 END IF
  CALL cl_digcut(l_aeo16,t_azi04_1) RETURNING l_aeo16 
  CALL cl_digcut(l_aeo21,t_azi04_1) RETURNING l_aeo21 

  RETURN l_aeo16,l_aeo21
END FUNCTION
FUNCTION t004_g_b()   #自动生成单身 
DEFINE g_axb04 DYNAMIC ARRAY OF LIKE axb_file.axb04
DEFINE g_aag01 DYNAMIC ARRAY OF LIKE aag_file.aag01      #记录长期股权投资科目
#DEFINE g_aag01_1 DYNAMIC ARRAY OF LIKE aag_file.aag01    #记录所有者权益类科目  
DEFINE g_aag01_1 DYNAMIC ARRAY OF RECORD                  
                 aag01 LIKE aag_file.aag01,
                 aag19 LIKE aag_file.aag19
                 END RECORD
DEFINE l_cnt1  LIKE type_file.num5
DEFINE l_cnt2  LIKE type_file.num5
DEFINE l_cnt3  LIKE type_file.num5
DEFINE l_cnt4  LIKE type_file.num5
DEFINE i       LIKE type_file.num5
DEFINE l_axz08 LIKE axz_file.axz08
DEFINE l_axz01 LIKE axz_file.axz01
DEFINE l_axb06 LIKE axb_file.axb06      # No.FUN-B60134
DEFINE l_axqq  RECORD LIKE axqq_file.*  # No.FUN-B60134
DEFINE l_aag19 LIKE aag_file.aag19      # No.FUN-B60134
DEFINE l_axa02 LIKE axa_file.axa02      # NO.FUN-B60134
DEFINE l_axa07 LIKE axa_file.axa07      # No.FUN-B90018 

    IF NOT cl_confirm('agl-443') THEN  RETURN END IF 
    SELECT azi04 INTO t_azi04_1 FROM azi_file
                      WHERE azi01 = g_aen09
    BEGIN WORK
    LET g_success = 'Y'
    CALL s_showmsg_init()
    #####1.所有下属公司
    LET l_cnt1 = 1
    LET l_cnt3 = 1
    LET g_sql = " SELECT axb04 FROM axb_file ",
                "  WHERE axb01 = '",g_aen03,"'",
                "    AND axb02 = '",g_aen05,"'" 
    PREPARE sel_axb04 FROM g_sql
    DECLARE sel_axb04_cur CURSOR FOR sel_axb04
    FOREACH sel_axb04_cur INTO g_axb04[l_cnt1]    #子公司编号
       IF STATUS THEN
          CALL s_errmsg(' ',' ','foreah',STATUS,1)
          LET g_success = 'N'
          EXIT FOREACH
       END IF
       ####2.产生第一单身
       LET l_cnt2 = 1
       LET g_sql = "SELECT aag01 FROM aag_file ",
                   " WHERE aag00 = '",g_aen11,"'", 
                   "   AND aag07 IN ('2','3')",
                   #"   AND aag19 = '",9,"'"      #长期股权投资
                   "   AND aag19 IN ('10','35') "      #长期股权投资
       PREPARE sel_aag01_pre FROM g_sql
       DECLARE sel_aag01_cur CURSOR FOR sel_aag01_pre
       FOREACH sel_aag01_cur INTO g_aag01[l_cnt2]
          IF STATUS THEN
             CALL s_errmsg(' ',' ','foreah',STATUS,1)
             LET g_success = 'N'
             EXIT FOREACH
          END IF
          LET g_aen[l_cnt3].aen06 = g_aag01[l_cnt2]
          SELECT axz08 INTO g_aen[l_cnt3].aen07 
            FROM axz_file
           WHERE axz01 = g_axb04[l_cnt1]
          LET g_aen[l_cnt3].aen08 = 0
          SELECT SUM(aek08-aek09) INTO g_aen[l_cnt3].aen08 FROM aek_file
           WHERE aek01 = g_aen03 AND aek02 = g_aen05
             AND aek04 = g_aen[l_cnt3].aen06
             AND aek05 = g_aen[l_cnt3].aen07
             AND aek06 = g_aen01 AND aek07 <= g_aen02
          IF cl_null(g_aen[l_cnt3].aen08) THEN
             LET g_aen[l_cnt3].aen08 = 0
             CONTINUE FOREACH
          ELSE
             CALL cl_digcut(g_aen[l_cnt3].aen08,t_azi04_1) RETURNING g_aen[l_cnt3].aen08
          END IF 
          INSERT INTO aen_file(aen01,aen02,aen03,aen04,aen05,aen06,aen07,aen08,aen09,aen10,aen11,aenlegal)
                        VALUES(g_aen01,g_aen02,g_aen03,g_aen04,g_aen05,g_aen[l_cnt3].aen06,
                               g_aen[l_cnt3].aen07,g_aen[l_cnt3].aen08,g_aen09,
                               g_aen10,g_aen11,g_legal)
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             LET g_success = 'N'  
             LET g_showmsg=g_aen05,"/",g_aen[l_cnt3].aen06
             CALL s_errmsg('aen05,aen06',g_showmsg,'ins aen',SQLCA.sqlcode,1)
          ELSE 
             LET g_success = 'Y'
          END IF
          LET l_cnt2 = l_cnt2+1
          LET l_cnt3 = l_cnt3+1
       END FOREACH
       LET l_cnt1 = l_cnt1+1
    END FOREACH
    CALL g_aen.deleteElement(l_cnt3)  
    ####3.产生第二单身
    LET l_cnt2 = 1
    LET l_cnt4 = 1
    FOR i = 1 TO g_aen.getLength()
        IF i>1 THEN
           IF g_aen[i].aen07 = g_aen[i-1].aen07 THEN CONTINUE FOR END IF 
        END IF
        SELECT axa07 INTO l_axa07 FROM axa_file WHERE axa01 = g_aen03   #FUN-B90018
      # FUN-B60134--add--str--
      # SELECT axa02 INTO l_axa02 FROM axa_file WHERE axa01 = g_aen03 AND axa04 = 'Y'   #FUN-B90018
        SELECT axz01 INTO l_axz01 FROM axz_file WHERE axz08 = g_aen[i].aen07
           AND axz01 IN(SELECT axb04 FROM axa_file,axb_file
                         WHERE axa01 = axb01 AND axa02 = axb02
                           AND axa03 = axb03 AND axa01 = g_aen03
                           AND axa02 = g_aen05 )
        SELECT axb06 INTO l_axb06 FROM axb_file WHERE axb01 = g_aen03
          #AND axb04 = l_axz01 AND axb02 = l_axa02   #FUN-B90018
           AND axb04 = l_axz01 AND axb02 = g_aen05   #FUN-B90018
       #IF l_axb06 = 'N' THEN   #FUN-B90018
        IF l_axb06 = 'N' AND l_axa07 = 'Y' THEN   #FUN-B90018
           LET g_sql = " SELECT * FROM axqq_file ",
                       "  WHERE axqq04 = '",l_axz01,"' AND axqq06 = '",g_aen01,"'",
                       "    AND axqq07 = '",g_aen02,"' AND axqq12 = '",g_aen09,"'"
           PREPARE sel_axqq_pre FROM g_sql
           DECLARE sel_axqq_cur CURSOR FOR sel_axqq_pre
           FOREACH sel_axqq_cur INTO l_axqq.*
               LET g_aeo[l_cnt4].aeo06 = g_aen[i].aen07   #关系人 
               LET g_aeo[l_cnt4].aeo07 = l_axqq.axqq05
               LET g_aeo[l_cnt4].aeo17 = g_aaz.aaz114
               LET g_aeo[l_cnt4].aeo09 = l_axqq.axqq12
              SELECT azi04 INTO t_azi04_2 FROM azi_file
               WHERE azi01 = g_aeo[l_cnt4].aeo09
              CALL s_get_aeo14(g_aen03,g_aen05,l_axz01,g_aen01,g_aen02)    
                   RETURNING g_aeo[l_cnt4].aeo14
              CALL s_get_aeo14_1(g_aen03,g_aen05,l_axz01,g_aen01,g_aen02) 
                   RETURNING g_aeo[l_cnt4].aeo14_1
              LET g_aeo[l_cnt4].aeo10 =l_axqq.axqq08
              LET g_aeo[l_cnt4].aeo19 =l_axqq.axqq09

              IF g_aeo[l_cnt4].aeo10 =0 AND g_aeo[l_cnt4].aeo19 =0 THEN
                 CONTINUE FOREACH
              END IF
             SELECT axz08 INTO l_axz08 FROM axz_file
              WHERE axz01 = g_aen05
             LET g_aeo[l_cnt4].aeo11 = 1
             LET g_aeo[l_cnt4].aeo12 = 1
             LET g_aeo[l_cnt4].aeo13 = g_aeo[l_cnt4].aeo10
             LET g_aeo[l_cnt4].aeo20 = g_aeo[l_cnt4].aeo19
             CALL s_get_aeo14(g_aen03,g_aen05,l_axz01,g_aen01,g_aen02)   
                  RETURNING g_aeo[l_cnt4].aeo14
             CALL s_get_aeo14_1(g_aen03,g_aen05,l_axz01,g_aen01,g_aen02)
                  RETURNING g_aeo[l_cnt4].aeo14_1
            CALL t004_get_aeo16(g_aeo[l_cnt4].aeo13,g_aeo[l_cnt4].aeo20,g_aeo[l_cnt4].aeo14,g_aeo[l_cnt4].aeo14_1)
                  RETURNING g_aeo[l_cnt4].aeo16,g_aeo[l_cnt4].aeo21
            LET g_aeo[l_cnt4].aeo15 = g_aaz.aaz102
             SELECT aag19 INTO l_aag19 FROM aag_file WHERE aag00 = g_aen11 AND aag01 = l_axqq.axqq05 
            #FUN-B90009--mod--str--
            #IF l_aag19 = '46' THEN
            #   LET g_aeo[l_cnt4].aeo22= g_aaz.aaz103
            #ELSE
            #   LET g_aeo[l_cnt4].aeo22 = g_aeo[l_cnt4].aeo07
            #END IF            
             #LET g_aeo[l_cnt4].aeo22 = g_aaw.aaw14   #NO.130805 mark
             LET g_aeo[l_cnt4].aeo22 = g_aaz.aaz103   #NO.130805 modify
            #FUN-B90009--mod--end
             INSERT INTO aeo_file(aeo01,aeo02,aeo03,aeo04,aeo05,aeo06,aeo07,
                                  aeo08,aeo09,aeo10,aeo11,aeo12,aeo13,aeo14,
                                  aeo15,aeo16,aeo17,aeo18,aeo19,aeo20,aeo21,
                                  aeo22)
                          VALUES(g_aen01,g_aen02,g_aen03,g_aen04,g_aen05,g_aeo[l_cnt4].aeo06,
                                 g_aeo[l_cnt4].aeo07,l_axz08,g_aeo[l_cnt4].aeo09,g_aeo[l_cnt4].aeo10,
                                 g_aeo[l_cnt4].aeo11,g_aeo[l_cnt4].aeo12,g_aeo[l_cnt4].aeo13,
                                 g_aeo[l_cnt4].aeo14,g_aeo[l_cnt4].aeo15,g_aeo[l_cnt4].aeo16,
                                 g_aeo[l_cnt4].aeo17,g_aen11,g_aeo[l_cnt4].aeo19,
                                 g_aeo[l_cnt4].aeo20,g_aeo[l_cnt4].aeo21,g_aeo[l_cnt4].aeo22)
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 LET g_success = 'N'
                 CALL s_errmsg('aen05',g_aen05,'ins aeo',SQLCA.sqlcode,1)
              ELSE
                 LET g_success = 'Y'
              END IF
              LET l_cnt4 = l_cnt4+1
           END FOREACH
        ELSE
 #  FUN-B60134--add--end  
        #LET g_sql = "SELECT aag01 FROM aag_file ",  
        LET g_sql = "SELECT aag01,aag19 FROM aag_file ", 
                    " WHERE aag00 = '",g_aen11,"'",
                    "   AND aag07 IN ('2','3')",
                    #"   AND aag19 IN ('44','45','46','47')"   #权益类 
                    "   AND aag19 IN ('19','20','21','22')"   #权益类 
        PREPARE sel_aag01_cur1 FROM g_sql
        DECLARE sel_aag01_pre1 CURSOR FOR sel_aag01_cur1
        #FOREACH sel_aag01_pre1 INTO g_aag01_1[l_cnt2]       
        FOREACH sel_aag01_pre1 INTO g_aag01_1[l_cnt2].aag01,g_aag01_1[l_cnt2].aag19  
           IF STATUS THEN
              CALL s_errmsg(' ',' ','foreah',STATUS,1)
              LET g_success = 'N'
              EXIT FOREACH
           END IF
           LET g_aeo[l_cnt4].aeo06 = g_aen[i].aen07   #关系人   
           SELECT axz01 INTO l_axz01 FROM axz_file WHERE axz08 = g_aen[i].aen07
              AND axz01 IN(SELECT axb04 FROM axa_file,axb_file
                            WHERE axa01 = axb01 AND axa02 = axb02
                              AND axa03 = axb03 AND axa01 = g_aen03
                              AND axa02 = g_aen05 )
           LET g_aeo[l_cnt4].aeo07 = g_aag01_1[l_cnt2].aag01  
           #LET g_aeo[l_cnt4].aeo17 = g_aaw.aaw06   #NO.130805 mark
           LET g_aeo[l_cnt4].aeo17 = g_aaz.aaz114   #NO.130805 modify
           SELECT axz06 INTO g_aeo[l_cnt4].aeo09 FROM axz_file   #子公司币别
            WHERE axz01 = l_axz01               
           SELECT azi04 INTO t_azi04_2 FROM azi_file
            WHERE azi01 = g_aeo[l_cnt4].aeo09
           CALL s_get_aeo14(g_aen03,g_aen05,l_axz01,g_aen01,g_aen02)   
                RETURNING g_aeo[l_cnt4].aeo14
           CALL s_get_aeo14_1(g_aen03,g_aen05,l_axz01,g_aen01,g_aen02)  
                RETURNING g_aeo[l_cnt4].aeo14_1
           LET g_aeo[l_cnt4].aeo10 = 0
           CALL t004_get_aeo10(l_axz01,g_aeo[l_cnt4].aeo07)               
                      RETURNING g_aeo[l_cnt4].aeo10,g_aeo[l_cnt4].aeo19
           IF g_aeo[l_cnt4].aeo10 =0 AND g_aeo[l_cnt4].aeo19 =0 THEN
              CONTINUE FOREACH    
           END IF
           SELECT axz08 INTO l_axz08 FROM axz_file
            WHERE axz01 = g_aen05
           LET g_aeo[l_cnt4].aeo11 = 1
           LET g_aeo[l_cnt4].aeo12 = 1
           LET g_aeo[l_cnt4].aeo13 = g_aeo[l_cnt4].aeo10
           LET g_aeo[l_cnt4].aeo20 = g_aeo[l_cnt4].aeo19  
           CALL s_get_aeo14(g_aen03,g_aen05,l_axz01,g_aen01,g_aen02) 
                RETURNING g_aeo[l_cnt4].aeo14
           CALL s_get_aeo14_1(g_aen03,g_aen05,l_axz01,g_aen01,g_aen02)
                RETURNING g_aeo[l_cnt4].aeo14_1 
           CALL t004_get_aeo16(g_aeo[l_cnt4].aeo13,g_aeo[l_cnt4].aeo20,g_aeo[l_cnt4].aeo14,g_aeo[l_cnt4].aeo14_1)
                RETURNING g_aeo[l_cnt4].aeo16,g_aeo[l_cnt4].aeo21  
           #LET g_aeo[l_cnt4].aeo15 = g_aaw.aaw13   #NO.130805 mark
           LET g_aeo[l_cnt4].aeo15 = g_aaz.aaz102   #NO.130805 modify
          #FUN-B90009--mod--str--
          #IF g_aag01_1[l_cnt2].aag19 = '22' THEN
          #   LET g_aeo[l_cnt4].aeo22= g_aaw.aaw14
          #ELSE
          #   LET g_aeo[l_cnt4].aeo22 = g_aeo[l_cnt4].aeo07 
          #END IF 
           #LET g_aeo[l_cnt4].aeo22= g_aaw.aaw14  #NO.130805 mark
           LET g_aeo[l_cnt4].aeo22= g_aaz.aaz103  #NO.130805 modify
          #FUN-B90009--mod--end
           INSERT INTO aeo_file(aeo01,aeo02,aeo03,aeo04,aeo05,aeo06,aeo07,
                                aeo08,aeo09,aeo10,aeo11,aeo12,aeo13,aeo14,
                                aeo15,aeo16,aeo17,aeo18,aeo19,aeo20,aeo21,
                                aeo22,aeolegal)
                        VALUES(g_aen01,g_aen02,g_aen03,g_aen04,g_aen05,g_aeo[l_cnt4].aeo06,
                               g_aeo[l_cnt4].aeo07,l_axz08,g_aeo[l_cnt4].aeo09,g_aeo[l_cnt4].aeo10,
                               g_aeo[l_cnt4].aeo11,g_aeo[l_cnt4].aeo12,g_aeo[l_cnt4].aeo13,
                               #g_aeo[l_cnt4].aeo14,' ',g_aeo[l_cnt4].aeo16, 
                               g_aeo[l_cnt4].aeo14,g_aeo[l_cnt4].aeo15,g_aeo[l_cnt4].aeo16, 
                               g_aeo[l_cnt4].aeo17,g_aen11,g_aeo[l_cnt4].aeo19,
                               g_aeo[l_cnt4].aeo20,g_aeo[l_cnt4].aeo21,g_aeo[l_cnt4].aeo22,g_legal)
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              LET g_success = 'N'
              CALL s_errmsg('aen05',g_aen05,'ins aeo',SQLCA.sqlcode,1)
           ELSE
              LET g_success = 'Y'
           END IF
           LET l_cnt2 = l_cnt2+1
           LET l_cnt4 = l_cnt4+1
        END FOREACH
        END IF   # NO.FUN-B60134
    END FOR
    CALL g_aeo.deleteElement(l_cnt4)
    IF g_success = 'Y' THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
       CALL s_showmsg()
    END IF 
    CALL t004_b_fill( '1=1')
    CALL t004_b_fill2( '1=1')
END FUNCTION
#NO.FUN-B40104
