# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: agli142
# Descriptions...: 內部管理分錄維護作業
# Date & Author..: 06/08/01 By Sarah
# Modify.........: No.FUN-680098 06/08/28 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-780068 07/11/15 By Sarah 當不使用多帳別功能時，隱藏npptype
# Modify.........: No.FUN-8C0050 08/04/27 By ve007 將s_fsgl的_bp函數移入程序內部
# Modify.........: No.TQC-960359 09/06/25 By chenmoyan 單身沒有資料的情況下按明細資
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../sub/4gl/s_fsgl.global"      #No.FUN-8C0050
 
DEFINE g_npp                 RECORD LIKE npp_file.*,
#No.FUN-8C0050 --begin--
#       g_npq                 DYNAMIC ARRAY of RECORD    #程式變數(Program Variables)
#                    npq02     LIKE npq_file.npq02,
#                    npq03     LIKE npq_file.npq03,
#                    aag02     LIKE aag_file.aag02,
#                    npq05     LIKE npq_file.npq05,
#                    npq06     LIKE npq_file.npq06,
#                    npq24     LIKE npq_file.npq24,
#                    npq25     LIKE npq_file.npq25,
#                    npq07f    LIKE npq_file.npq07f,
#                    npq07     LIKE npq_file.npq07,
#                    npq21     LIKE npq_file.npq21,
#                    npq22     LIKE npq_file.npq22,
#                    npq23     LIKE npq_file.npq23,
#                    npq15     LIKE npq_file.npq15,
#                    npq08     LIKE npq_file.npq08,
#                    npq11     LIKE npq_file.npq11,
#                    npq12     LIKE npq_file.npq12,
#                    npq13     LIKE npq_file.npq13,
#                    npq14     LIKE npq_file.npq14,
#                    npq31     LIKE npq_file.npq31,  #異動碼5
#                    npq32     LIKE npq_file.npq32,  #異動碼6
#                    npq33     LIKE npq_file.npq33,  #異動碼7
#                    npq34     LIKE npq_file.npq34,  #異動碼8
#                    npq35     LIKE npq_file.npq35,  #異動碼9
#                    npq36     LIKE npq_file.npq36,  #異動碼10
#                    npq37     LIKE npq_file.npq37,  #關係人異動碼
#                    npq04     LIKE npq_file.npq04
#                             END RECORD,
#       g_npq_t               RECORD                 #程式變數(Program Variables)
#                    npq02     LIKE npq_file.npq02,
#                    npq03     LIKE npq_file.npq03,
#                    aag02     LIKE aag_file.aag02,
#                    npq05     LIKE npq_file.npq05,
#                    npq06     LIKE npq_file.npq06,
#                    npq24     LIKE npq_file.npq24,
#                    npq25     LIKE npq_file.npq25,
#                    npq07f    LIKE npq_file.npq07f,
#                    npq07     LIKE npq_file.npq07,
#                    npq21     LIKE npq_file.npq21,
#                    npq22     LIKE npq_file.npq22,
#                    npq23     LIKE npq_file.npq23,
#                    npq15     LIKE npq_file.npq15,
#                    npq08     LIKE npq_file.npq08,
#                    npq11     LIKE npq_file.npq11,
#                    npq12     LIKE npq_file.npq12,
#                    npq13     LIKE npq_file.npq13,
#                    npq14     LIKE npq_file.npq14,
#                    npq31     LIKE npq_file.npq31,  #異動碼5
#                    npq32     LIKE npq_file.npq32,  #異動碼6
#                    npq33     LIKE npq_file.npq33,  #異動碼7
#                    npq34     LIKE npq_file.npq34,  #異動碼8
#                    npq35     LIKE npq_file.npq35,  #異動碼9
#                    npq36     LIKE npq_file.npq36,  #異動碼10
#                    npq37     LIKE npq_file.npq37,  #關係人異動碼
#                    npq04     LIKE npq_file.npq04
#                             END RECORD,
#No.8C0050 --end--                                
       g_sql                 STRING,                #No.FUN-580092 HCN   
       g_wc                  STRING,                #No.FUN-580092 HCN   
       g_buf                 LIKE type_file.chr20,         #No.FUN-680098 VARCHAR(20) 
       g_argv1               LIKE type_file.chr2,     #系統別#No.FUN-680098 VARCHAR(2)
       g_argv2               LIKE type_file.num5,   #類別  #No.FUN-680098 SMALLINT
       g_argv3               LIKE type_file.chr20,  #單號  #No.FUN-680098 VARCHAR(20)
       g_argv4               LIKE npq_file.npq07,   #本幣金額
       g_argv5               LIKE aaa_file.aaa01,   #帳別
       g_argv6               LIKE type_file.num5,   #異動序號 #No.FUN-680098  SMALLINT
       g_argv7               LIKE type_file.chr1    #確認碼   #No.FUN-680098  VARCHAR(1)
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8           #No.FUN-6A0073
   DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680098 SMALLINT
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                         # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   LET g_argv1 = ARG_VAL(1)    #CC
   LET g_argv2 = ARG_VAL(2)    #類別
   LET g_argv3 = ARG_VAL(3)    #單號
   LET g_argv4 = ARG_VAL(4)    #本幣金額
   LET g_argv5 = ARG_VAL(5)    #帳別
   LET g_argv6 = ARG_VAL(6)    #異動序號
   LET g_argv7 = ARG_VAL(7)    #確認碼
 
   LET p_row = 3 LET p_col = 10
   OPEN WINDOW s_fsgl_w AT p_row,p_col WITH FORM "sub/42f/s_fsgl"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
   CALL s_fsgl_show_filed()  #FUN-5C0015 051216 BY GILL
  #str FUN-780068 add
  #當不使用多帳別功能時，隱藏npptype
   IF g_aza.aza63 = 'N' THEN
      CALL cl_set_comp_visible("npptype",FALSE)
   END IF
  #end FUN-780068 add
 
   CALL i142_menu()
 
   CLOSE WINDOW s_fsgl_w                               #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION i142_menu()
 
   WHILE TRUE
#      CALL s_fsgl_bp1("G")
       CALL i142_bp("G")     #No.FUN-8C0050
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL s_fsgl_q('CC')
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL s_fsgl_r()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL s_fsgl_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL s_fsgl_out('agli142')
            END IF
         WHEN "query_detail"   #明細查詢
            IF cl_chk_act_auth() THEN
               IF l_ac > 0 THEN       #No.TQC-960359
                  CALL s_fsgl_d()
               END IF                 #No.TQC-960359
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL s_fsgl_exporttoexcel()
            END IF
      END CASE
   END WHILE
END FUNCTION
 
#No.FUN-8C0050  --begin--
FUNCTION i142_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1        
 
   IF p_ud <> "G"  OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_npq TO s_npq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                  
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION first
         CALL s_fsgl_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                   
 
      ON ACTION previous
         CALL s_fsgl_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY                   
 
      ON ACTION jump
         CALL s_fsgl_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                 
 
      ON ACTION next
         CALL s_fsgl_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                   
 
      ON ACTION last
         CALL s_fsgl_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY                  
 
      #@ON ACTION 明細查詢
      ON ACTION query_detail
         LET g_action_choice = "query_detail"
         LET g_npq_t.* = g_npq[l_ac].*
         EXIT DISPLAY
 
      ON ACTION exporttoexcel
         LET g_action_choice = "exporttoexcel"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                  
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
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
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls
         LET g_action_choice="controls"
         EXIT DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#NO.FUN-8C0050 --end--
