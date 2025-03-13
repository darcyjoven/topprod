# Prog. Version..: '5.30.06-13.04.22(00003)'     #
# PROG. VERSION..: '5.25.04-11.09.14(00000)'     #
#
# PATTERN NAME...: abaq100
# DESCRIPTIONS...: 仓库条码查询
# DATE & AUTHOR..: 12/10/15  By qiaozy
# Modify.........: No.DEV-CA0007 12/10/19 By jingll 接收外部參數以做查詢 
# Modify.........: No:DEV-CB0002 12/11/07 By TSD.JIE
#                  1. 調整外部查詢時，無資料
#                  2. 調整畫面顯示不正確
# Modify.........: No.DEV-CC0001 12/12/04 By Mandy 隱藏右側"數量"欄位(ibb07)
# MOdify.........: No.DEV-CC0009 13/01/08 By Nina  增加接收的外部參數
# Modify.........: No.DEV-D30025 13/03/11 By Nina  GP5.3 追版:以上為GP5.25 的單號
# Modify.........: No.DEV-D30055 13/03/28 By Nina  (1)右側畫面增加ibb11、ibb12、ibb13、ibbacti欄位
#                                                  (2)由單據串至abaq100,來源單據(ibb03)應塞選該單據的資料才顯示
# Modify.........: No.DEV-D40015 13/04/16 By Nina  (1)透過單據串查時，不使用的條碼(ibb11='N')無需顯示
#                                                  (2)若為單據串接開啟時，依<批序號/包號>顯示右側欄位  

#DEV-CA0003----ADD--- 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
 
    g_iba    DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
         iba01        LIKE iba_file.iba01,
         iba02        LIKE iba_file.iba02,
         iba03        LIKE iba_file.iba03,
         iba04        LIKE iba_file.iba04,
         iba05        LIKE iba_file.iba05,
         iba06        LIKE iba_file.iba06,
         iba07        LIKE iba_file.iba07,
         iba08        LIKE iba_file.iba08,
         iba09        LIKE iba_file.iba09,
         iba10        LIKE iba_file.iba10,
         iba11        LIKE iba_file.iba11
           END  RECORD,
    g_ibb    DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
         ibb01        LIKE ibb_file.ibb01,
         ibb02        LIKE ibb_file.ibb02,
         ibb03        LIKE ibb_file.ibb03,
         ibb04        LIKE ibb_file.ibb04,
         ibb05        LIKE ibb_file.ibb05,
         ibb06        LIKE ibb_file.ibb06,
         ima02        LIKE ima_file.ima02,
         ima021       LIKE ima_file.ima021,
         ibb07        LIKE ibb_file.ibb07,
         ibb08        LIKE ibb_file.ibb08,
         ibb09        LIKE ibb_file.ibb09,
         ibb10        LIKE ibb_file.ibb10,
        #DEV-D30055 add str---------------
         ibb11        LIKE ibb_file.ibb11,
         ibb12        LIKE ibb_file.ibb12,
         ibb13        LIKE ibb_file.ibb13,
         ibbacti      LIKE ibb_file.ibbacti 
        #DEV-D30055 add end---------------
            END  RECORD,
    g_wc,g_wc2,g_sql     STRING,  
    g_rec_b         LIKE type_file.num10,                #單身筆數  
    g_rec_b2        LIKE type_file.num10,                #單身筆數  
    g_row_count     LIKE type_file.num5,
    g_curs_index    LIKE type_file.num5,
    mi_no_ask       LIKE type_file.num5,
    g_jump          LIKE type_file.num5,
    l_ac            LIKE type_file.num10,                 #目前處理的ARRAY CNT  
    l_ac2           LIKE type_file.num10,                 #目前處理的ARRAY CNT  
    g_chr           LIKE type_file.chr1,
    g_flag          LIKE type_file.chr1,
    g_msg           STRING

DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_cnt           LIKE type_file.num10      
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose  
DEFINE i               LIKE type_file.num5     #count/index for any purpose  
DEFINE p_row,p_col     LIKE type_file.num5    
DEFINE g_zz01          LIKE zz_file.zz01
DEFINE g_form          LIKE type_file.chr1
DEFINE g_argv1         LIKE type_file.chr20   #DEV-CA0007--add
DEFINE g_argv2         LIKE type_file.chr20   #DEV-CA0009 add
DEFINE g_ima931        LIKE ima_file.ima931   #DEV-D40015 add

MAIN
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("aba")) THEN
      EXIT PROGRAM
   END IF

   LET g_argv1=ARG_VAL(1)   #DEV-CA0007--add
   LET g_argv2=ARG_VAL(2)   #DEV-CA0009 add

    CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
       RETURNING g_time    
    LET p_row = 3 LET p_col = 14
    OPEN WINDOW q100_w AT p_row,p_col WITH FORM "aba/42f/abaq100"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
    CALL cl_set_comp_visible('ibb07',FALSE) #DEV-CC0001 add
   #DEV-D40015 add str--------------
   #若料號為包號管理ima931 = 'Y'，才顯示包號相關欄位
    IF NOT cl_null(g_argv1) OR g_argv1<>' ' THEN 
       LET g_ima931 = ''
       SELECT ima931 INTO g_ima931
         FROM ima_file
        WHERE ima01 = (SELECT MIN(ibb06) FROM ibb_file WHERE ibb03 = g_argv1)

       IF g_ima931 = 'Y' THEN
          CALL cl_set_comp_visible('ibb05',TRUE) 
          CALL cl_set_comp_visible('ibb08',TRUE) 
          CALL cl_set_comp_visible('ibb09',TRUE) 
          CALL cl_set_comp_visible('ibb10',TRUE) 
          CALL cl_set_comp_visible('ibb07',FALSE) 
       ELSE
          CALL cl_set_comp_visible('ibb05',FALSE) 
          CALL cl_set_comp_visible('ibb08',FALSE) 
          CALL cl_set_comp_visible('ibb09',FALSE) 
          CALL cl_set_comp_visible('ibb10',FALSE) 
          CALL cl_set_comp_visible('ibb07',TRUE)
       END IF
    END IF
   #DEV-D40015 add end--------------
    #DEV-CA0007--add---begin--------- 
     IF NOT cl_null(g_argv1) THEN  
        CALL q100_q()
     END IF
    #DEV-CA0007--add---end-----------
    CALL q100_menu()
    CLOSE WINDOW q100_w                  #結束畫面
    CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) 
       RETURNING g_time    
END MAIN 
 
FUNCTION q100_menu()
 
   WHILE TRUE
      CALL q100_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q100_q()
            END IF            
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION

FUNCTION q100_q()

   MESSAGE ""
   CLEAR FORM
   CALL g_iba.clear()
   CALL g_ibb.CLEAR()
 
   CALL q100_cs()
   CALL q100_show()
 
END FUNCTION

FUNCTION q100_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
   CLEAR FORM 
    CALL cl_set_head_visible("","YES")
    CALL g_iba.clear()
    CALL g_ibb.CLEAR()

    IF NOT cl_null(g_argv1) OR g_argv1<>' ' THEN  #DEV-CA0007
       LET g_wc = " 1=1"                          #DEV-CA0007
       LET g_wc2 = " ibb03 ='",g_argv1,"'",       #DEV-CA0007
                   " AND ibb11 <> 'N' "           #DEV-D40015 add
      #DEV-CC0009 add str----------
       IF NOT cl_null(g_argv2) OR g_argv2 <> ' ' THEN 
          LET g_wc2 = g_wc2 , " AND ibb09 = '" , g_argv2 , "'"
       END IF
      #DEV-CC0009 add end---------- 
    ELSE
      DIALOG ATTRIBUTES(UNBUFFERED)
         CONSTRUCT g_wc ON iba01,iba02,iba03,iba04,iba05,iba06,iba07,iba08,iba09,
                   iba10,iba11  
              FROM s_iba[1].iba01,s_iba[1].iba02,s_iba[1].iba03,s_iba[1].iba04,
                   s_iba[1].iba05,s_iba[1].iba06,s_iba[1].iba07,s_iba[1].iba08,
                   s_iba[1].iba09,s_iba[1].iba10,s_iba[1].iba11
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         END CONSTRUCT
         CONSTRUCT g_wc2 ON ibb01,ibb02,ibb03,ibb04,ibb05,ibb06,ibb07,ibb08,ibb09,
                            ibb10,ibb11,ibb12,ibb13,ibbacti                          #DEV-D30055 add
              FROM s_ibb[1].ibb01,s_ibb[1].ibb02,s_ibb[1].ibb03,s_ibb[1].ibb04,
                   s_ibb[1].ibb05,s_ibb[1].ibb06,s_ibb[1].ibb07,s_ibb[1].ibb08,
                   s_ibb[1].ibb09,s_ibb[1].ibb10,
                   s_ibb[1].ibb11,s_ibb[1].ibb12,s_ibb[1].ibb13,s_ibb[1].ibbacti     #DEV-D30055 add
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         END CONSTRUCT
         
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG 
    
         ON ACTION about
            CALL cl_about()
    
         ON ACTION HELP
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

         ON ACTION exit
            LET INT_FLAG = TRUE
            EXIT DIALOG

         ON ACTION close
            LET INT_FLAG = TRUE
            EXIT DIALOG
         
 #        ON ACTION controlp
 #           CASE
 #              WHEN INFIELD(img01)
 #                 CALL cl_init_qry_var()
 #                 LET g_qryparam.state = 'c'
 #                 LET g_qryparam.form ="q_img"
 #                 CALL cl_create_qry() RETURNING g_qryparam.multiret
 #                 DISPLAY g_qryparam.multiret TO img01
 #                 NEXT FIELD img01
 #             
 #              OTHERWISE EXIT CASE
 #           END CASE
      
   
   END DIALOG 
  END IF   #DEV-CA0007--add

   IF INT_FLAG THEN 
       LET INT_FLAG = FALSE
       LET g_wc = null
       RETURN 
   END IF 
#   IF cl_null(g_wc) THEN LET g_wc = " 1=1 " END IF 
   IF cl_null(g_wc2) THEN LET g_wc = " 1=1 " END IF
 
END FUNCTION

FUNCTION q100_show()
DEFINE  l_ima02   LIKE ima_file.ima02
DEFINE  l_ima021  LIKE ima_file.ima021   #FUN-AA0086
   
   CALL q100_b_fill(g_wc,g_wc2)
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION q100_b_fill(p_wc,p_wc2)
DEFINE p_wc2   STRING
DEFINE p_wc    STRING
   IF cl_null(p_wc2) OR p_wc2=" 1=1" THEN 
      LET g_sql = "SELECT iba01,iba02,iba03,iba04,iba05,iba06,iba07,iba08,iba09,iba10,iba11 ",
                  "  FROM iba_file ",
                  " WHERE iba01<>' ' AND ",p_wc,
                  "  ORDER BY iba01,iba02 "
   ELSE
      LET g_sql = "SELECT iba01,iba02,iba03,iba04,iba05,iba06,iba07,iba08,iba09,iba10,iba11 ",
                  "  FROM iba_file,ibb_file ",
                 #" WHERE iba01=ibb01 AND iba01<>'' AND ",p_wc ," AND ",p_wc2 ,  #No:DEV-CB0002--mark
                  " WHERE iba01=ibb01 AND iba01<>' ' AND ",p_wc ," AND ",p_wc2 , #No:DEV-CB0002--add
                  "  ORDER BY iba01,iba02 " 
   END IF               
   PREPARE q100_pb FROM g_sql
   DECLARE iba_cs CURSOR FOR q100_pb
 
   CALL g_iba.clear()
   LET g_cnt = 1
 
   FOREACH iba_cs INTO g_iba[g_cnt].*
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
   CALL g_iba.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   LET g_cnt = 0

END FUNCTION

FUNCTION q100_d_fill(p_iba01,p_wc2)  #DEV-D30055 add  p_wc2
DEFINE p_iba01  LIKE  iba_file.iba01
DEFINE p_wc2   STRING                #DEV-D30055 add  p_wc2

   IF cl_null(p_wc2) THEN LET p_wc2 = ' 1=1' END IF   #DEV-D30055 add

   LET g_sql = "SELECT ibb01,ibb02,ibb03,ibb04,ibb05,ibb06,'','',ibb07,ibb08,ibb09,ibb10, ",
               "       ibb11,ibb12,ibb13,ibbacti ",                        #DEV-D30055 add
               "  FROM ibb_file ",
               " WHERE ibb01= '",p_iba01,"' ",
               "   AND ",p_wc2,                                  #DEV-D30055 add
               " ORDER BY ibb01,ibb02,ibb03,ibb04,ibb05,ibb06 "
               
   PREPARE q100_pb_d FROM g_sql
   DECLARE ibb_cs CURSOR FOR q100_pb_d
 
   CALL g_ibb.clear()
   LET g_cnt = 1
 
   FOREACH ibb_cs INTO g_ibb[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT ima02,ima021 INTO g_ibb[g_cnt].ima02,g_ibb[g_cnt].ima021
         FROM ima_file 
        WHERE ima01=g_ibb[g_cnt].ibb06
        
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_ibb.deleteElement(g_cnt)
   LET g_rec_b2=g_cnt-1
   LET g_cnt = 0

END FUNCTION
  
FUNCTION q100_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
   DEFINE   l_sql  STRING
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel,close", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
    
      DISPLAY ARRAY g_iba TO s_iba.* ATTRIBUTE(COUNT=g_rec_b)
          BEFORE DISPLAY 
            IF l_ac > 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF 
            
          BEFORE ROW 
             LET l_ac  = ARR_CURR()
             IF l_ac  > 0 THEN
                CALL q100_d_fill(g_iba[l_ac].iba01,g_wc2)   #DEV-D30055 add g_wc2
             END IF 
             CALL cl_show_fld_cont()
      END DISPLAY 
      
      DISPLAY ARRAY g_ibb TO s_ibb.* ATTRIBUTE(COUNT=g_rec_b2)
          BEFORE DISPLAY 
            IF l_ac2 > 0 THEN
               CALL fgl_set_arr_curr(l_ac2)
            END IF 
            
          BEFORE ROW 
             LET l_ac2  = ARR_CURR()
             IF l_ac2  > 0 THEN
             
             END IF 
             CALL cl_show_fld_cont()
      END DISPLAY 
      
      BEFORE DIALOG 
         IF l_ac > 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF 


     ON ACTION query
        LET g_action_choice="query"
        EXIT DIALOG

      
      ON ACTION HELP
         LET g_action_choice="help"
         EXIT DIALOG 

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   
         LET g_action_choice = 'locale'
         EXIT DIALOG 

      ON ACTION EXIT
         LET g_action_choice="exit"
         EXIT DIALOG 
         
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
      ON ACTION controls                          
         CALL cl_set_head_visible("","AUTO")
 
      ON ACTION CANCEL
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      AFTER DIALOG
         CONTINUE DIALOG
   END DIALOG 
   CALL cl_set_act_visible("accept,cancel,close", TRUE)
END FUNCTION
#DEV-CA0003----ADD------
#DEV-D30025--add
