# Prog. Version..: '5.30.06-13.04.22(00001)'     #
# PROG. VERSION..: '5.25.04-11.09.14(00000)'     #
#
# PATTERN NAME...: abaq410
# DESCRIPTIONS...: 訂單條碼查詢作業
# DATE & AUTHOR..: No:DEV-CB0013 2012/11/20 By TSD.JIE
# Modify.........: No.DEV-D30025 2013/03/11 By Nina---GP5.3 追版:以上為GP5.25 的單號---
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/barcode.global"
 
DEFINE 
 
    tm   RECORD    #程式變數(Program Variables)
        b   LIKE type_file.chr1
         END  RECORD,
    g_oeb    DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
         oeb01  LIKE  oeb_file.oeb01,      #工单号
         oeb03  LIKE  oeb_file.oeb03,      #订单项次
         oeb04  LIKE  oeb_file.oeb04,      #料件
         ima02  LIKE  ima_file.ima02,      #品名
         ima021 LIKE  ima_file.ima021,     #规格
        #ima76  LIKE  ima_file.ima76,      #条码类型 #No:DEV-CB0013--mark
         oeb12  LIKE  oeb_file.oeb12,      #生产数量
         oeb24  LIKE  oeb_file.oeb24,      #出货数量
         sets   LIKE  oeb_file.oeb12       #齐套数量
           END  RECORD,
    g_imgb    DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        imgb01    LIKE imgb_file.imgb01,   #条码
       #iba12     LIKE iba_file.iba12,     #包號 #No:DEV-CB0013--mark
        ibb05     LIKE ibb_file.ibb05,     #包號 #No:DEV-CB0013--add
        imgb02    LIKE imgb_file.imgb02,   #仓库
        imgb03    LIKE imgb_file.imgb03,   #库位  
        imgb04    LIKE imgb_file.imgb04,   #批号
        imgb05    LIKE imgb_file.imgb05,   #数量
        more          LIKE imgb_file.imgb05,   #多
        less          LIKE imgb_file.imgb05    #缺
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
 
MAIN
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABA")) THEN
      EXIT PROGRAM
   END IF
 
    CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
       RETURNING g_time    
    LET p_row = 3 LET p_col = 14
    OPEN WINDOW q410_w AT p_row,p_col WITH FORM "aba/42f/abaq410"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
    CALL cl_set_comp_visible("imgb04,more,less",FALSE) #No:DEV-CB0002--add  不需要了
    CALL q410_menu()
    CLOSE WINDOW q410_w                  #結束畫面
    CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) 
       RETURNING g_time    
END MAIN 
 
FUNCTION q410_menu()
 
   WHILE TRUE
      CALL q410_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q410_q()
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

FUNCTION q410_q()

   MESSAGE ""
   CLEAR FORM
   CALL g_oeb.clear()
   CALL g_imgb.CLEAR()
 
   CALL q410_cs()
   #No:DEV-CB0002--add--begin
   IF INT_FLAG THEN 
      LET INT_FLAG = FALSE
      RETURN 
   END IF 
   #No:DEV-CB0002--add--end
   CALL q410_show()
 
END FUNCTION

FUNCTION q410_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
   CLEAR FORM 
   CALL cl_set_head_visible("","YES")
   INITIALIZE tm.* TO NULL
   CALL g_oeb.clear()
   CALL g_imgb.CLEAR()
   DIALOG ATTRIBUTES(UNBUFFERED)
     
      INPUT BY NAME tm.b 
         BEFORE INPUT
           LET tm.b = 'Y'
           DISPLAY BY NAME tm.b
      
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG 
      
         ON ACTION about
            CALL cl_about()
      
         ON ACTION HELP
            CALL cl_show_help()
      
         ON ACTION controlg
            CALL cl_cmdask()

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
 
      END INPUT 
      
      CONSTRUCT g_wc ON oeb01,oeb03,oeb04,oeb12,oeb24#,ima76     #No:DEV-CB0013--mark ima76
              FROM s_oeb[1].oeb01,s_oeb[1].oeb03,s_oeb[1].oeb04,
                   s_oeb[1].oeb12,s_oeb[1].oeb24#,s_oeb[1].ima76 #No:DEV-CB0013--mark ima76
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
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
         
         ON ACTION controlp
            CASE
               WHEN INFIELD(oeb01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_oeb4"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oeb01
                  NEXT FIELD oeb01
               WHEN INFIELD(oeb04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ima18"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oeb04
                  NEXT FIELD oeb04
               OTHERWISE EXIT CASE
            END CASE
      END CONSTRUCT
   
   END DIALOG 

   IF INT_FLAG THEN 
      #LET INT_FLAG = FALSE #No:DEV-CB0002--mark
       RETURN 
   END IF 
   IF cl_null(g_wc) THEN LET g_wc = " 1=1 " END IF 
 
END FUNCTION

FUNCTION q410_show()
   CALL q410_b_fill()
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION q410_b_fill()
DEFINE p_wc2   STRING

  #LET g_sql = "SELECT oeb01,oeb03,oeb04,ima02,ima021,ima76,oeb12,oeb24,'' ", #No:DEV-CB0013--mark
   LET g_sql = "SELECT oeb01,oeb03,oeb04,ima02,ima021,oeb12,oeb24,'' ",       #No:DEV-CB0013--add
               "  FROM oeb_file,ima_file ",
               " WHERE oeb04 = ima01 ",
               "   AND ",g_wc

   IF tm.b = 'Y' THEN 
      LET g_sql = g_sql," AND oeb12 > oeb24 "
   END IF 
   IF tm.b = 'N' THEN 
      LET g_sql = g_sql," AND oeb12 <= oeb24 "
   END IF 
   LET g_sql = g_sql ," ORDER BY oeb01,oeb03"
               
   PREPARE q410_pb FROM g_sql
   DECLARE oeb_cs CURSOR FOR q410_pb
 
   CALL g_oeb.clear()
   LET g_cnt = 1
 
   FOREACH oeb_cs INTO g_oeb[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
      #No:DEV-CB0013--mark--begin
      #LET g_sql = "SELECT MIN(sets) FROM ( ",
      #            " SELECT imgb01,iba12,nvl(imgb05,0) AS sets ",
      #            "   FROM iba_file,imgb_file ",
      #            "  WHERE iba14 = '",g_oeb[g_cnt].oeb01,"' ",
      #            "    AND iba15 = ",g_oeb[g_cnt].oeb03,
      #            "    AND imgb01(+) = iba01 ",
      #            "    AND imgb00(+) = iba00 ",
      #            " ) "
      #No:DEV-CB0013--mark--end
      #No:DEV-CB0013--add--begin
       LET g_sql = "SELECT MIN(sets) FROM ( ",
                   " SELECT imgb01,ibb05,nvl(imgb05,0) AS sets ",
                   "   FROM ibb_file LEFT JOIN imgb_file ON imgb01 = ibb01",
                   "  WHERE ibb03 = '",g_oeb[g_cnt].oeb01,"' ",
                   "    AND ibb04 = ",g_oeb[g_cnt].oeb03,
                   " ) "
      #No:DEV-CB0013--add--end
       PREPARE get_sets FROM g_sql
       EXECUTE get_sets INTO g_oeb[g_cnt].sets
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_oeb.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   LET g_cnt = 0

   DISPLAY g_rec_b TO cn2
END FUNCTION

FUNCTION q410_d_fill(p_oeb01,p_oeb03,p_oeb04)
DEFINE p_oeb01  LIKE  oeb_file.oeb01
DEFINE p_oeb03  LIKE  oeb_file.oeb03
DEFINE p_oeb04  LIKE  oeb_file.oeb04
DEFINE l_ima76  LIKE  ima_file.ima76


  #No:DEV-CB0013--mark--begin
  #CASE  l_ima76 
  #  #WHEN '10'
  #  
  #  WHEN '50'
  #        LET g_sql = "SELECT iba01,iba12,imgb02,imgb03,imgb04,imgb05,'','' ",
  #            "  FROM iba_file,imgb_file,sfb_file ",
  #            " WHERE iba01 = imgb01(+) ",
  #            "   AND iba00 = imgb00(+) ",
  #            "   AND sfb22 = '",p_oeb01,"' ",
  #            "   AND sfb221 = ",p_oeb03,
  #            "   AND iba14 = sfb01 ",
  #            " ORDER BY iba01,iba12 "
  #  #WHEN '52'
  #  
  #END CASE 
  #No:DEV-CB0013--mark--end

  #No:DEV-CB0002--mark--begin
  ##No:DEV-CB0013--add--begin
  #LET g_sql = "SELECT ibb01,ibb05,imgb02,imgb03,imgb04,imgb05,'','' ",
  #            "  FROM ibb_file LEFT JOIN imgb_file ON ibb01 = imgb01,",
  #            "       sfb_file,ima_file ",
  #            " WHERE sfb22 = '",p_oeb01,"' ",
  #            "   AND sfb221=  ",p_oeb03,
  #            "   AND ibb03 = sfb01 ",
  #            "   AND ima01 = sfb05",
  #            "   AND ima932= 'A' ",
  #            " ORDER BY ibb01,ibb05 "
  ##No:DEV-CB0013--add--end
  #No:DEV-CB0002--mark--end

   #No:DEV-CB0002--add--begin
   LET g_sql = "SELECT ibb01,ibb05,imgb02,imgb03,imgb04,imgb05,'','' ",
               "  FROM ibb_file LEFT OUTER JOIN imgb_file ON ibb01 = imgb01 ",
               " WHERE ibb02 = 'H' ",              #條碼產生時機點 H:訂單包裝單
               "   AND ibb03 = '",p_oeb01,"' ",    #工單單號
               " ORDER BY ibb01,ibb05 "
   #No:DEV-CB0002--add--end

   PREPARE q410_pb_d FROM g_sql
   DECLARE imgb_cs CURSOR FOR q410_pb_d
 
   CALL g_imgb.clear()
   LET g_cnt = 1
 
   FOREACH imgb_cs INTO g_imgb[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
      #No:DEV-CB0002--mark--begin
      #IF g_imgb[g_cnt].imgb05 - g_oeb[l_ac].sets > 0 THEN   #多
      #   LET g_imgb[g_cnt].more = g_imgb[g_cnt].imgb05 - g_oeb[l_ac].sets
      #ELSE IF g_imgb[g_cnt].imgb05 - g_oeb[l_ac].sets < 0 THEN   #少
      #        LET g_imgb[g_cnt].less = g_oeb[l_ac].sets - g_imgb[g_cnt].imgb05
      #     END IF 
      #END IF 
      #No:DEV-CB0002--mark--end
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_imgb.deleteElement(g_cnt)
   LET g_rec_b2=g_cnt-1
   LET g_cnt = 0

   DISPLAY g_rec_b2 TO cn3
END FUNCTION
  
FUNCTION q410_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
   DEFINE   l_sql  STRING
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel,close", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
    
      DISPLAY ARRAY g_oeb TO s_oeb.* ATTRIBUTE(COUNT=g_rec_b)
          BEFORE DISPLAY 
            IF l_ac > 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF 
            
          BEFORE ROW 
             LET l_ac  = ARR_CURR()
             IF l_ac  > 0 THEN
                CALL q410_d_fill(g_oeb[l_ac].oeb01,g_oeb[l_ac].oeb03,g_oeb[l_ac].oeb04)
             END IF 
      END DISPLAY 
      
      DISPLAY ARRAY g_imgb TO s_imgb.* ATTRIBUTE(COUNT=g_rec_b2)
          BEFORE DISPLAY 
            IF l_ac2 > 0 THEN
               CALL fgl_set_arr_curr(l_ac2)
            END IF 
            
          BEFORE ROW 
             LET l_ac2  = ARR_CURR()
             IF l_ac2  > 0 THEN
             
             END IF 
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
#DEV-D30025--add


