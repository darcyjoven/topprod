# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aqcq112.4gl
# Descriptions...: 測量值查詢作業
# Date & Author..: 01/05/25 By Melody
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-550063 05/05/19 By day   單據編號加大            
# Modify.........: No.MOD-5A0169 05/10/14 By Rosayu 上、下筆時，單身資料會錯誤
# Modify.........: No.FUN-680104 06/08/26 By Czl  類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-7C0157 07/12/21 By Pengu 單身無法正常顯示資料
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_aqc          RECORD 
             g_no       LIKE qct_file.qct01,       #No.FUN-680104 VARCHAR(16) #No.FUN-550063 
             g_1        LIKE type_file.num5,       #No.FUN-680104 SMALLINT
             g_2        LIKE type_file.num5,       #No.FUN-680104 SMALLINT
             g_seq      LIKE type_file.num5,       #No.FUN-680104 SMALLINT
             item       LIKE qct_file.qct04,       #No.FUN-680104 VARCHAR(04)
             azf03      LIKE azf_file.azf03,       #No.FUN-680104 VARCHAR(10)
             qty        LIKE qct_file.qct11,       #No.FUN-680104 DEC(12,3)
             a          LIKE type_file.chr1,       #No.FUN-680104 VARCHAR(01)
             upnum      LIKE qct_file.qct131,      #No.FUN-680104 DEC(7,2)
             donum      LIKE qct_file.qct132       #No.FUN-680104 DEC(7,2)
                    END RECORD,
#        g_aqc_arrno    SMALLINT,              #程式變數的個數
#        g_aqc_sarrno   SMALLINT,              #螢幕變數的個數
#        g_aqc_pageno   SMALLINT,              #頁數
         g_num          ARRAY[500] of LIKE qct_file.qct131,  #No.FUN-680104 DEC(7,2)
         g_sql          STRING,                    #No.FUN-580092 HCN        #No.FUN-680104
         g_rec_b        LIKE type_file.num5,       #單身筆數 #No.FUN-680104 SMALLINT
         l_ac           LIKE type_file.num5,       #目前處理的ARRAY CNT        #No.FUN-680104 SMALLINT
         l_sl           LIKE type_file.num5,       #No.FUN-680104 SMALLINT
         g_no           LIKE qct_file.qct01,       #No.FUN-680104 VARCHAR(16) #No.FUN-550063
         g_1            LIKE type_file.num5,       #No.FUN-680104 SMALLINT
         g_2            LIKE type_file.num5,       #No.FUN-680104 SMALLINT
         g_seq          LIKE type_file.num5        #No.FUN-680104 SMALLINT
 
DEFINE   g_cnt           LIKE type_file.num10      #No.FUN-680104 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000    #No.FUN-680104 VARCHAR(72)
DEFINE   g_status        LIKE type_file.num5       #No.FUN-680104 SMALLINT  
DEFINE   g_row_count    LIKE type_file.num10       #No.FUN-680104 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680104 SMALLINT
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0085
    DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680104 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
  
     IF (NOT cl_user()) THEN
         EXIT PROGRAM
     END IF
     WHENEVER ERROR CALL cl_err_msg_log
     IF (NOT cl_setup("AQC")) THEN
        EXIT PROGRAM
     END IF
 
    # 2003/12/02 by Hiko : 先這樣判斷.
{    IF (NUM_ARGS() != 4) THEN
       DISPLAY "The number of program arguments is 4."
       EXIT PROGRAM
    END IF
}
    LET g_no=ARG_VAL(1)
    LET g_1=ARG_VAL(2)
    LET g_2=ARG_VAL(3)
    LET g_status=ARG_VAL(4)
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
 
    LET p_row = 5 LET p_col = 29
 
    OPEN WINDOW q112_w AT p_row,p_col WITH FORM "aqc/42f/aqcq112" 
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
#    CALL cl_shwtit(3,54,'aqcq112')
    WHENEVER ERROR CONTINUE
 
#   LET g_aqc_pageno = 1                   #現在單身頁次
#   LET g_aqc_arrno  = 500                 #變數ARRAY數
#   LET g_aqc_sarrno = 10                  #螢幕ARRAY數
 
    INITIALIZE g_aqc.* TO NULL
#    CALL q112_q() 
IF NOT cl_null(g_no) THEN CALL q112_q() END IF
    CALL q112_menu()
    CLOSE WINDOW q112_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
END MAIN
 
FUNCTION q112_cs()
    CASE g_status
         WHEN '1' LET g_sql="SELECT qct01,qct02,qct021,qct03 FROM qct_file",
                            " WHERE qct01='",g_no,"' ",
                            "   AND qct02='",g_1,"' ",
                            "   AND qct021='",g_2,"' ",
                            "   ORDER BY qct03 "
         WHEN '2' LET g_sql="SELECT qcg01,0,0,qcg03 FROM qcg_file",
                            " WHERE qcg01='",g_no,"' "
         WHEN '3' LET g_sql="SELECT qcn01,0,0,qcn03 FROM qcn_file",
                            " WHERE qcn01='",g_no,"' "
    END CASE
display "g_sql=",g_sql
    PREPARE q112_prepare FROM g_sql                # RUNTIME 編譯
    DECLARE q112_cs SCROLL CURSOR WITH HOLD FOR q112_prepare
 
    CASE g_status
         WHEN '1' LET g_sql="SELECT COUNT(*) FROM qct_file ",
                            " WHERE qct01='",g_no,"' ",
                            "   AND qct02='",g_1,"' ",
                            "   AND qct021='",g_2,"' "
         WHEN '2' LET g_sql="SELECT COUNT(*) FROM qcg_file ",
                            " WHERE qcg01='",g_no,"' "
         WHEN '3' LET g_sql="SELECT COUNT(*) FROM qcn_file ",
                            " WHERE qcn01='",g_no,"' "
    END CASE
    PREPARE q112_precount FROM g_sql
    DECLARE q112_count CURSOR FOR q112_precount
END FUNCTION
 
 
FUNCTION q112_menu()
 
   WHILE TRUE
      CALL q112_bp("G")
      CASE g_action_choice
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"    
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_num),'','')
            END IF
      END CASE
   END WHILE
      CLOSE q112_cs
END FUNCTION
 
 
 
FUNCTION q112_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    CALL g_num.clear()  #MOD-5A0169 add
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q112_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    MESSAGE " SEARCHING ! " 
    OPEN q112_count
    FETCH q112_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN q112_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_no,SQLCA.sqlcode,0)
        INITIALIZE g_aqc.* TO NULL
    ELSE
        CALL q112_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION q112_fetch(p_flaqc)
    DEFINE
        p_flaqc         LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
        l_abso          LIKE type_file.num10         #No.FUN-680104 INTEGER
 
    CASE p_flaqc
        WHEN 'N' FETCH NEXT     q112_cs INTO g_no,g_1,g_2,g_seq
        WHEN 'P' FETCH PREVIOUS q112_cs INTO g_no,g_1,g_2,g_seq
        WHEN 'F' FETCH FIRST    q112_cs INTO g_no,g_1,g_2,g_seq
        WHEN 'L' FETCH LAST     q112_cs INTO g_no,g_1,g_2,g_seq
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
            FETCH ABSOLUTE g_jump q112_cs INTO g_no,g_1,g_2,g_seq
            LET mi_no_ask = FALSE
    END CASE
    display "g_no_fetch=",g_no
    display "g_1_fetch=",g_1
    display "g_2_fetch=",g_2
    display "g_seq_fetch=",g_seq
    IF SQLCA.sqlcode THEN
    display "g_no_fetch=",g_no
    display "g_1_fetch=",g_1
    display "g_2_fetch=",g_2
    display "g_seq_fetch=",g_seq
        CALL cl_err(g_no,SQLCA.sqlcode,0)
        INITIALIZE g_no  TO NULL  #TQC-6B0105
        INITIALIZE g_1   TO NULL  #TQC-6B0105
        INITIALIZE g_2   TO NULL  #TQC-6B0105
        INITIALIZE g_seq TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flaqc
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
 
    CALL q112_show()                      # 重新顯示
END FUNCTION
 
FUNCTION q112_show()
    CASE g_status
         WHEN '1' SELECT qct04,azf03,qct11,qct12,qct131,qct132
                    INTO g_aqc.item,g_aqc.azf03,g_aqc.qty,g_aqc.a,
                         g_aqc.upnum,g_aqc.donum
                    FROM qct_file LEFT OUTER JOIN azf_file ON qct04=azf01 AND azf02 ='6'
                   WHERE qct01=g_no AND qct02=g_1 AND qct021=g_2 AND qct03=g_seq
         WHEN '2' SELECT qcg04,azf03,qcg11,qcg12,qcg131,qcg132
                    INTO g_aqc.item,g_aqc.azf03,g_aqc.qty,g_aqc.a,
                         g_aqc.upnum,g_aqc.donum
                    FROM qcg_file LEFT OUTER JOIN azf_file ON qcg04=azf01 AND azf02 = '6'
                   WHERE qcg01=g_no AND qcg03=g_seq 
         WHEN '3' SELECT qcn04,azf03,qcn11,qcn12,qcn131,qcn132
                    INTO g_aqc.item,g_aqc.azf03,g_aqc.qty,g_aqc.a,
                         g_aqc.upnum,g_aqc.donum
                    FROM qcn_file LEFT OUTER JOIN azf_file ON qcn04=azf01 AND azf02 = '6'
                   WHERE qcn01=g_no AND qcn03=g_seq
    END CASE
    
    DISPLAY g_no TO FORMONLY.g_no
    DISPLAY g_1 TO FORMONLY.g_1 
    DISPLAY g_2 TO FORMONLY.g_2 
    DISPLAY g_seq TO FORMONLY.g_seq
    DISPLAY g_aqc.item TO FORMONLY.item
    DISPLAY g_aqc.azf03 TO FORMONLY.azf03
    DISPLAY g_aqc.qty TO FORMONLY.qty  
    DISPLAY g_aqc.a TO FORMONLY.a    
    DISPLAY g_aqc.upnum TO FORMONLY.upnum
    DISPLAY g_aqc.donum TO FORMONLY.donum
   CALL q112_b_fill(' 1=1') #單身  
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q112_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(100)
 
    CASE g_status
         WHEN '1' LET g_sql = "SELECT qctt04 FROM qctt_file",
                              " WHERE qctt01='",g_no,"' ",
                              "   AND qctt02='",g_1,"' ",
                              "   AND qctt021='",g_2,"' ",
                              "   AND qctt03='",g_seq,"' "
         WHEN '2' LET g_sql = "SELECT qcgg04 FROM qcgg_file",
                              " WHERE qcgg01='",g_no,"' ",
                              "   AND qcgg03='",g_seq,"' "
         WHEN '3' LET g_sql = "SELECT qcnn04 FROM qcnn_file",
                              " WHERE qcnn01='",g_no,"' ",
                              "   AND qcnn03='",g_seq,"' "
    END CASE
    PREPARE q112_pb FROM g_sql
    DECLARE aqc_curs CURSOR FOR q112_pb
 
    FOR g_cnt = 1 TO g_num.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_num[g_cnt] TO NULL
    END FOR
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH aqc_curs INTO g_num[g_cnt]   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
#         IF g_cnt > g_aqc_arrno THEN
#             CALL cl_err('',9035,0)
#             EXIT FOREACH
#         END IF
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2 
    CALL g_num.deleteElement(g_cnt)  #MOD-5A0169 add 
    LET g_cnt = 0
 
END FUNCTION
 
 
FUNCTION q112_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_num  TO s_num.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED) 
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION first
         CALL q112_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL q112_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump
         CALL q112_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL q112_fetch('N') 
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last
         CALL q112_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
   
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
    #-----No.MOD-7C0157 mark
    ### No.FUN-530067 --start--
    # AFTER DISPLAY
    #    CONTINUE DISPLAY
    ### No.FUN-530067 ---end---
    #-----No.MOD-7C0157 end
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
