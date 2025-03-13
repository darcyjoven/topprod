# Prog. Version..: '5.30.06-13.04.22(00001)'     #
# PROG. VERSION..: '5.25.04-11.09.14(00000)'     #
#
# PATTERN NAME...: abat210
# DESCRIPTIONS...: 工单条码查询
# DATE & AUTHOR..: No.DEV-CA0014 12/10/29 By TSD.Hiyawus
# Modify.........: No.DEV-CB0020 12/11/29 By Mandy Err massage 訊息呈現調整
# Modify.........: No.DEV-CC0007 12/01/04 By Mandy 批號(imgb04)隱藏
# Modify.........: No.DEV-D10005 13/01/22 By Nina  入庫數量=完工數量時，需控卡不可再產生完工入庫單
# Modify.........: No.DEV-D30025 13/03/12 By Nina---GP5.3 追版:以上為GP5.25 的單號---


DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../aba/4gl/barcode.global"
 

DEFINE 
    tm   RECORD                             
        a          LIKE type_file.chr1,            
        b          LIKE type_file.chr1             
         END  RECORD,                       
    g_sfb    DYNAMIC ARRAY OF RECORD       
         sfb01     LIKE  sfb_file.sfb01,       #工单号
         sfb05     LIKE  sfb_file.sfb05,       #料件
         ima02     LIKE  ima_file.ima02,       #品名
         ima021    LIKE  ima_file.ima021,      #规格
         sfb04     LIKE  sfb_file.sfb04,       #工单状态
         sfb08     LIKE  sfb_file.sfb08,       #生产数量
         sfb09     LIKE  sfb_file.sfb09,       #入库数量
         sets      LIKE  sfb_file.sfb08        #齐套数量
           END  RECORD,                     
    g_max    DYNAMIC ARRAY OF RECORD        
         sets      LIKE  sfb_file.sfb08        #最大入库包数量
           END RECORD,
    g_imgb    DYNAMIC ARRAY OF RECORD  
        imgb01     LIKE imgb_file.imgb01,      #条码
        ibb05      LIKE ibb_file.ibb05,         #
        imgb02     LIKE imgb_file.imgb02,      #仓库
        imgb03     LIKE imgb_file.imgb03,      #库位
        imgb04     LIKE imgb_file.imgb04,      #批号
        imgb05     LIKE imgb_file.imgb05,      #数量
        more       LIKE imgb_file.imgb05,      #多
        less       LIKE imgb_file.imgb05       #缺
            END  RECORD,
    g_wc,g_wc2,g_sql     STRING,  
    g_rec_b        LIKE type_file.num10,       #單身筆數  
    g_rec_b2       LIKE type_file.num10,       #單身筆數  
    g_row_count    LIKE type_file.num5,
    g_curs_index   LIKE type_file.num5,
    mi_no_ask      LIKE type_file.num5,
    g_jump         LIKE type_file.num5,
    l_ac           LIKE type_file.num10,       #目前處理的ARRAY CNT  
    l_ac2          LIKE type_file.num10,       #目前處理的ARRAY CNT  
    g_chr          LIKE type_file.chr1,
    g_flag         LIKE type_file.chr1,
    g_msg          STRING

DEFINE g_forupd_sql STRING   
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_cnt           LIKE type_file.num10      
DEFINE g_i             LIKE type_file.num5 
DEFINE i               LIKE type_file.num5 
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
 
   CALL  cl_used(g_prog,g_time,1)  
      RETURNING g_time    
   LET p_row = 3 LET p_col = 14
   OPEN WINDOW t210_w AT p_row,p_col WITH FORM "aba/42f/abat210"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()

   #No.DEV-CA0014 --add-- 強制隱藏欄位more,less
   #因此程式因無使用到more,less欄位之必要性 
   #原客戶是只在p_per不顯示此欄位,改由程式控制
   CALL cl_set_comp_visible("more,less",FALSE)
   #No.DEV-CA0014 --end--
   CALL cl_set_comp_visible("imgb04",FALSE) #DEV-CC0007 add 批號(imgb04)欄位隱藏

   CALL t210_menu()
   CLOSE WINDOW t210_w               
   CALL  cl_used(g_prog,g_time,2)   
      RETURNING g_time    
END MAIN 
 

FUNCTION t210_menu()
   DEFINE l_sfv09   LIKE   sfv_file.sfv09    #DEV-D10005 add

   WHILE TRUE
      CALL t210_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL t210_q()
            END IF            
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "wo_exp"
            IF l_ac = 0 THEN CONTINUE WHILE END IF 
           #DEV-D10005 add str---------------
            SELECT SUM(sfv09) INTO l_sfv09    #捉取實際入庫數
              FROM sfv_file
             WHERE sfv11 = g_sfb[l_ac].sfb01
            IF cl_null(l_sfv09) THEN LET l_sfv09 = 0  END IF
            IF g_sfb[l_ac].sfb08 = l_sfv09 THEN
               CALL cl_err('','aba-010',1)
            ELSE
           #DEV-D10005 add end---------------
               CALL t210_wo_exp(g_sfb[l_ac].sfb01)
               CALL t210_show()
            END IF          #DEV-D10005 add 
      END CASE
   END WHILE
END FUNCTION


FUNCTION t210_q()

   MESSAGE ""
   CLEAR FORM
   CALL g_sfb.clear()
   CALL g_max.clear()
   CALL g_imgb.CLEAR()
   CALL t210_cs()
   CALL t210_show()
 
END FUNCTION


FUNCTION t210_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
   CLEAR FORM 
      CALL cl_set_head_visible("","YES")
      INITIALIZE tm.* TO NULL
      DIALOG ATTRIBUTES(UNBUFFERED)
     
      INPUT BY NAME tm.a,tm.b 
         BEFORE INPUT
           LET tm.a = 'N'
           LET tm.b = 'Y'
           DISPLAY BY NAME tm.a,tm.b
      
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
      
      CONSTRUCT g_wc ON sfb01,sfb05,sfb04,sfb08,sfb09
              FROM s_sfb[1].sfb01,s_sfb[1].sfb05,s_sfb[1].sfb04,
                   s_sfb[1].sfb08,s_sfb[1].sfb09
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
               WHEN INFIELD(sfb01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_sfb"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfb01
                  NEXT FIELD sfb01
               WHEN INFIELD(sfb05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ima18"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfb05
                  NEXT FIELD sfb05
               OTHERWISE EXIT CASE
            END CASE
      END CONSTRUCT
   
   END DIALOG 

   IF INT_FLAG THEN 
       LET INT_FLAG = FALSE
       RETURN 
   END IF 
   IF cl_null(g_wc) THEN LET g_wc = " 1=1 " END IF 
END FUNCTION


FUNCTION t210_show()
DEFINE  l_ima02   LIKE ima_file.ima02
DEFINE  l_ima021  LIKE ima_file.ima021  
   
   CALL t210_b_fill()
   CALL cl_show_fld_cont()
END FUNCTION


FUNCTION t210_b_fill()
DEFINE p_wc2   STRING

   LET g_sql = "SELECT sfb01,sfb05,ima02,ima021,sfb04,sfb08,0,'' ",
               "  FROM sfb_file,ima_file ",
               " WHERE sfb05  = ima01 ",
               "   AND ima932 = 'A' ",     #條碼產生時機點 A:工單
               "   AND sfb04 IN('2','3','4','5','6','7') ",
               "   AND ",g_wc
   IF tm.a = 'Y' THEN 
      LET g_sql = g_sql," AND sfb28 = '1' "
   END IF 
   IF tm.b = 'Y' THEN 
      LET g_sql = g_sql," AND sfb08 > sfb09 "
   END IF 
   LET g_sql = g_sql ," ORDER BY sfb01"
               
   PREPARE t210_pb FROM g_sql
   DECLARE sfb_cs CURSOR FOR t210_pb
 
   CALL g_sfb.clear()
   CALL g_max.clear()
   LET g_cnt = 1
 
   FOREACH sfb_cs INTO g_sfb[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
     #入库数量去入库单实抓，可能有的入库单还没过账，没有回写工单入库数量
     #这种情况上，实际也不能再点完工入库操作了。
      SELECT SUM(sfv09) INTO g_sfb[g_cnt].sfb09 
        FROM sfu_file,sfv_file
       WHERE sfu01 = sfv01 
         AND sfv11 = g_sfb[g_cnt].sfb01
         AND sfuconf <> 'X'
      IF cl_null(g_sfb[g_cnt].sfb09) THEN LET g_sfb[g_cnt].sfb09 = 0 END IF

      #No.DEV-CA0014 By TSD.Hiyawus 121030 ---add--- 改寫成LEFT OUTER JOIN寫法
      #LET g_sql = " SELECT MIN(sets),MAX(sets) FROM ( ",           #TSD.Hiyawus 121029 此處MAX(sets)是否撈出做處理,待SD確認。
      #            "    SELECT imgb01,ibb05,SUM(nvl(imgb05,0)) AS sets ",
      #            "      FROM ibb_file,imgb_file ",
      #            "     WHERE ibb03 = '",g_sfb[g_cnt].sfb01,"' ",
      #            "       AND imgb01(+) = ibb01 ",                
      #            "     GROUP BY imgb01,ibb05 ) "              

      LET g_sql = " SELECT MIN(sets) FROM ( ",                     #TSD.Hiyawus 121030 此處MAX(sets)不撈出處理。
                  "    SELECT imgb01,ibb05,SUM(nvl(imgb05,0)) AS sets ",
                  "      FROM iba_file,ibb_file LEFT OUTER JOIN imgb_file ON ibb01 = imgb01 ", 
                  "     WHERE iba01 = ibb01 ",
                  "       AND iba02 = 'H' ",        #類型限定 H:包號
                  "       AND ibb03 = '",g_sfb[g_cnt].sfb01,"' ", 
                  "     GROUP BY imgb01,ibb05 ) "                
      #No.DEV-CA0014 By TSD.Hiyawus 121030 ---end---
                  
      PREPARE get_sets FROM g_sql
      #EXECUTE get_sets INTO g_sfb[g_cnt].sets,g_max[g_cnt].sets   #No.DEV-CA0014 mark By TSD.Hiyawus 121030
      EXECUTE get_sets INTO g_sfb[g_cnt].sets                      #No.DEV-CA0014 add  BY TSD.Hiyawus 121030
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_sfb.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   LET g_cnt = 0
END FUNCTION


FUNCTION t210_d_fill(p_sfb01)
DEFINE p_sfb01  LIKE  sfb_file.sfb01

   #No.DEV-CA0014 By TSD.Hiyawus 121030 ---add--- 改寫成LEFT OUTER JOIN寫法
   #LET g_sql = "SELECT imgb01,ibb05,imgb02,imgb03,imgb04,imgb05,'','' ",
   #            "  FROM ibb_file,imgb_file ",
   #            " WHERE ibb01 = imgb01(+) ",
   #            "   AND ibb03 = '",p_sfb01,"' ",   
   #            "   AND ibb02 = 'A' ",             
   #            " ORDER BY imgb01 "

   LET g_sql = "SELECT imgb01,ibb05,imgb02,imgb03,imgb04,imgb05,'','' ",
               "  FROM iba_file,ibb_file LEFT OUTER JOIN imgb_file ON ibb01 = imgb01 ",
               " WHERE iba01 = ibb01 ",
               "   AND iba02 = 'H' ",              #類型限定 H:包號
               "   AND ibb03 = '",p_sfb01,"' ",    #工單單號
               "   AND ibb02 = 'A' ",              #條碼產生時機點 A:工單
               " ORDER BY imgb01 "
   #No.DEV-CA0014 By TSD.Hiyawus 121030 ---end---
               
   PREPARE t210_pb_d FROM g_sql
   DECLARE imgb_cs CURSOR FOR t210_pb_d
 
   CALL g_imgb.clear()
   LET g_cnt = 1
 
   FOREACH imgb_cs INTO g_imgb[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
     #多
       LET g_imgb[g_cnt].more = g_imgb[g_cnt].imgb05 - g_sfb[l_ac].sets
       IF g_imgb[g_cnt].more = 0 THEN 
          LET g_imgb[g_cnt].more = '' 
       END IF 
     #少
       IF cl_null(g_imgb[g_cnt].imgb05) THEN
          LET g_imgb[g_cnt].less = g_max[l_ac].sets 
       ELSE 
          LET g_imgb[g_cnt].less = g_max[l_ac].sets - g_imgb[g_cnt].imgb05
          IF g_imgb[g_cnt].less = 0 THEN 
             LET g_imgb[g_cnt].less = '' 
          END IF 
       END IF 
       
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_imgb.deleteElement(g_cnt)
   LET g_rec_b2=g_cnt-1
   LET g_cnt = 0
END FUNCTION
  

FUNCTION t210_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
   DEFINE   l_sql  STRING
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel,close", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
    
      DISPLAY ARRAY g_sfb TO s_sfb.* ATTRIBUTE(COUNT=g_rec_b)
          BEFORE DISPLAY 
            IF l_ac > 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF 
            
          BEFORE ROW 
             LET l_ac  = ARR_CURR()
             IF l_ac  > 0 THEN
                CALL t210_d_fill(g_sfb[l_ac].sfb01)
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

     ON ACTION wo_exp
        LET g_action_choice="wo_exp"
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


FUNCTION t210_wo_exp(p_sfb01)
   DEFINE p_sfb01   LIKE sfb_file.sfb01
   DEFINE l_success LIKE type_file.chr1
   DEFINE l_sets    LIKE sfb_file.sfb08
   DEFINE l_sfu01   LIKE sfu_file.sfu01
   DEFINE l_cmd     LIKE type_file.chr1000
   
   IF NOT cl_confirm("abx-080") THEN RETURN END IF 
   CALL s_showmsg_init() #No.DEV-CB0002--add
   CALL s_wo_exp(p_sfb01,FALSE) RETURNING l_success,l_sets,l_sfu01
   CALL s_showmsg() #No.DEV-CB0002--add
   IF l_success = 'Y' THEN
      CALL cl_err(l_sfu01,'aba-012',1)
   ELSE 
     #MESSAGE "Generate Error"         #DEV-CB0020 mark
      CALL cl_err(l_sfu01,'aba-123',1) #DEV-CB0020 add
   END IF 
  
   IF l_success = 'Y' THEN
      LET l_cmd = " asft620"," '",l_sfu01,"' 'query' "
      CALL cl_cmdrun_wait(l_cmd)
   END IF 
END FUNCTION

#DEV-CA0014 ---add---
#DEV-D30025--add

