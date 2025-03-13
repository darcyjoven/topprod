# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axci100
# Descriptions...: 成本分錄底稿維護作業 
# Date & Author..: 05/01/25 By Carol
# Modify.........: No.FUN-510041 05/01/25 By Carol 新增成本拋轉傳票功能
# Modify.........: No.FUN-550025 05/05/16 By vivien 單據編號格式放大 
# Modify.........: No.MOD-560228 05/07/20 By ching Fix單身loop
# Modify.........: No.MOD-580175 05/08/17 By Claire 警告借貸不平衡
# Modify.........: No.FUN-5C0015 05/12/16 By Jack npq_file 增加新欄位及檢查
# Modify.........: No.FUN-5C0015 06/02/14 BY GILL 用s_ahe_qry取代q_aee
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-670039 06/07/12 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-660165 06/08/15 By Sarah 改變畫面顯示方式,直接CALL分錄底稿s_fsgl的畫面跟4gl來維護程式
# Modify.........: No.FUN-680122 06/09/07 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0019 06/10/05 By jamie FUNCTION i100_q() 一開始應清空g_npp.*值
# Modify.........: No.FUN-6A0146 06/10/27 By bnlent l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/16 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.FUN-780068 07/11/15 By Sarah 當不使用多帳別功能時，隱藏npptype
# Modify.........: No.FUN-8C0050 09/04/27 By ve007 s_fsgl的bp函數寫回各程序中 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../sub/4gl/s_fsgl.global"      #No.FUN-8C0050
 
 
#start FUN-660165 add
DEFINE
    g_argv1         LIKE type_file.chr2,      # Prog. Version..: '5.30.06-13.03.12(02),              #系統別
    g_argv2         LIKE type_file.num5,      #No.FUN-680122 SMALLINT,              #類別
    g_argv3         LIKE type_file.chr20,     #No.FUN-680122 VARCHAR(20),              #單號
    g_argv4         LIKE npq_file.npq07,      #本幣金額
    g_argv5         LIKE aaa_file.aaa01,      #帳別
    g_argv6         LIKE type_file.num5,      #No.FUN-680122 SMALLINT,              #異動序號
    g_argv7         LIKE type_file.chr1       # Prog. Version..: '5.30.06-13.03.12(01)               #確認碼
 
MAIN
#  DEFINE l_time       LIKE type_file.chr8      #No.FUN-6A0146
   DEFINE p_row,p_col  LIKE type_file.num5      #No.FUN-680122 SMALLINT
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			   # Supress DEL key function
   WHENEVER ERROR CONTINUE
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time      #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
 
   LET g_argv1 = 'CA'          # CA
   LET g_argv2 = 1             # 1
   LET g_argv3 = ARG_VAL(3)    # 單號
   LET g_argv4 = ARG_VAL(4)    # 本幣金額
   LET g_argv5 = g_ccz.ccz12   # 帳別   #MOD-5C0103
   LET g_argv6 = ARG_VAL(6)    # 異動序號
   LET g_argv7 = ARG_VAL(7)    # 確認碼
 
   LET p_row = 3 LET p_col = 2
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
   CALL i100_menu()
 
   CLOSE WINDOW s_fsgl_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time      #計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
FUNCTION i100_menu()
 
   WHILE TRUE
    # CALL s_fsgl_bp2("G")
      CALL i100_bp("G")     #No.FUN-8C0050
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
               CALL s_fsgl_q('CA')
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
               CALL s_fsgl_out('axci100')
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "controls"                                 #No.FUN-6A0092
           CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092     
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL s_fsgl_exporttoexcel()
            END IF
      END CASE
   END WHILE
 
END FUNCTION
 
#NO.FUN-8C0050  --begin--
FUNCTION i100_bp(p_ud)
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
 
      ON ACTION controls
         LET g_action_choice="controls"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
