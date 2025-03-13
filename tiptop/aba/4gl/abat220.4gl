# Prog. Version..: '5.30.06-13.04.22(00001)'     #
# PROG. VERSION..: '5.25.04-11.09.14(00000)'     #
#
# PATTERN NAME...: abat220
# DESCRIPTIONS...: 工单条码完工入库作业
# DATE & AUTHOR..: No:DEV-CA0015 2012/10/30 By TSD.JIE
# Modify.........: No.DEV-CB0020 12/11/29 By Mandy Err massage 訊息呈現調整
# Modify.........: No.DEV-CC0001 12/12/07 By Mandy t220_c_fill()限制僅顯示料號的條碼產生時機點為"H"的資料
# Modify.........: No.DEV-CC0007 12/01/04 By Mandy 批號(imgb04)隱藏
# Modify.........: No.DEV-D10005 13/01/23 By Nina  入庫數量=完工數量時，需控卡不可再產生完工入庫單
# Modify.........: No.DEV-D30025 13/03/12 By Nina---GP5.3 追版:以上為GP5.25 的單號---
 

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/barcode.global"
 
DEFINE 
    tm   RECORD    #程式變數(Program Variables)
         a      LIKE type_file.chr1,
         b      LIKE type_file.chr1
         END  RECORD,
    g_oea    DYNAMIC ARRAY OF RECORD
         oea01  LIKE  oea_file.oea01,
         oea03  LIKE  oea_file.oea03,
         oea032 LIKE  oea_file.oea032,
         oba01  LIKE  oba_file.oba01,
         oba02  LIKE  oba_file.oba02,
         ruku   LIKE  type_file.chr1
           END RECORD,
    g_oea_t    RECORD
         oea01  LIKE  oea_file.oea01,
         oea03  LIKE  oea_file.oea03,
         oea032 LIKE  oea_file.oea032,
         oba01  LIKE  oba_file.oba01,
         oba02  LIKE  oba_file.oba02,
         ruku   LIKE  type_file.chr1       #入庫否
           END RECORD,
    g_sfb    DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
         sfb01  LIKE  sfb_file.sfb01,      #工单号
         sfb05  LIKE  sfb_file.sfb05,      #料件
         ima02  LIKE  ima_file.ima02,      #品名
         ima021 LIKE  ima_file.ima021,     #规格
         sfb04  LIKE  sfb_file.sfb04,      #工单状态
         sfb08  LIKE  sfb_file.sfb08,      #生产数量
         sfb09  LIKE  sfb_file.sfb09,      #入库数量
         sets   LIKE  sfb_file.sfb08       #齐套数量
           END  RECORD,
    g_max    DYNAMIC ARRAY OF RECORD
         sets   LIKE  sfb_file.sfb08       #最大入库包数量
           END RECORD,
    g_imgb    DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        imgb01    LIKE imgb_file.imgb01,   #条码
       #iba12     LIKE iba_file.iba12,     #       #No:DEV-CA0015--mark
        ibb05     LIKE ibb_file.ibb05,     #包號   #No:DEV-CA0015--add
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
    g_rec_b3        LIKE type_file.num10,
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
DEFINE g_one           LIKE type_file.chr1
 
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
    OPEN WINDOW t220_w AT p_row,p_col WITH FORM "aba/42f/abat220"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
    CALL cl_set_comp_visible("more,less",FALSE)#多、缺   #No:DEV-CA0015--add
    CALL cl_set_comp_visible("sets",FALSE)     #期套數   #No:DEV-CA0015--add
    CALL cl_set_comp_visible("imgb04",FALSE) #DEV-CC0007 add 批號(imgb04)欄位隱藏
    CALL t220_menu( )
    CLOSE WINDOW t220_w                  #結束畫面
    CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) 
       RETURNING g_time    
END MAIN 
 
FUNCTION t220_menu()
  DEFINE l_sfv09   LIKE   sfv_file.sfv09    #DEV-D10005 add

   WHILE TRUE
      CALL t220_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL t220_q()
            END IF            
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "wo_exp"
            IF cl_chk_act_auth() THEN 
               IF l_ac = 0 THEN CONTINUE WHILE END IF 
              #DEV-D10005 add str---------------
               SELECT SUM(sfv09) INTO l_sfv09       #依訂單捉取總入庫數
                 FROM sfv_file,sfb_file
                WHERE sfv_file.sfv11 = sfb_file.sfb01 and           
                      sfb_file.sfb22 = g_oea[l_ac].oea01
               IF cl_null(l_sfv09) THEN LET l_sfv09 = 0 END IF
               IF l_sfv09 = 0 THEN
              #DEV-D10005 add end---------------
                  CALL t220_wo_exp(g_sfb[l_ac].sfb01)
                  CALL t220_show()
              #DEV-D10005 add str---------------
               ELSE
                  CALL cl_err('','aba-010',1)
               END IF     
              #DEV-D10005 add end---------------
            END IF 
         WHEN "accept_a"
            IF cl_chk_act_auth() THEN 
               CALL t220_b()
            END IF 
      END CASE
   END WHILE
END FUNCTION

FUNCTION t220_q()

   MESSAGE ""
   CLEAR FORM
   CALL g_sfb.clear()
   CALL g_max.clear()
   CALL g_oea.CLEAR()
   CALL g_imgb.CLEAR()
   CALL t220_cs()
   CALL t220_show()
 
END FUNCTION

FUNCTION t220_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
   CLEAR FORM 
      CALL cl_set_head_visible("","YES")
      INITIALIZE tm.* TO NULL
      DIALOG ATTRIBUTES(UNBUFFERED)
      
      CONSTRUCT g_wc ON oea01,oea03,oea032,oba01,oba02
              FROM s_oea[1].oea01,s_oea[1].oea03,s_oea[1].oea032,
                   s_oea[1].oba01,s_oea[1].oba02
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
               WHEN INFIELD(oea01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_oea03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oea01
                  NEXT FIELD oea01
               WHEN INFIELD(oea03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_occ02"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oea03
                  NEXT FIELD oea03
               WHEN INFIELD(oba01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_oba"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oba01
                  NEXT FIELD oba01
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

FUNCTION t220_b()
DEFINE
    p_style         LIKE type_file.chr1,        
    l_ac_t          LIKE type_file.num5,              
    l_n             LIKE type_file.num5,                
    l_result        BOOLEAN,
    l_idx           LIKE ibc_file.ibc03,
    l_lock_sw       LIKE type_file.chr1,
    l_gen02         LIKE gen_file.gen02,               
    l_sql           STRING,
    p_cmd           LIKE type_file.chr1,               
    l_buf           LIKE imd_file.imd02

    LET g_action_choice = "" 
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
   
    IF g_rec_b = 0 THEN RETURN END IF 
    CALL cl_opmsg('b')
 
    INPUT ARRAY g_oea WITHOUT DEFAULTS FROM s_oea.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,
              UNBUFFERED, INSERT ROW =FALSE ,
              DELETE ROW=FALSE,APPEND ROW=FALSE)
 
      BEFORE INPUT                                                              
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            
      BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_n  = ARR_COUNT()
            LET l_lock_sw = 'N'       
            LET g_success = 'Y'
            LET g_oea_t.* = g_oea[l_ac].*
            CALL t220_set_entry_b()
            CALL t220_set_no_entry_b()
            IF g_rec_b>=l_ac THEN
               BEGIN WORK
               LET p_cmd='u'   
               LET g_oea_t.* = g_oea[l_ac].*  
               CALL t220_c_fill(l_ac)
               CALL t220_d_fill(l_ac)
               CALL t220_fill_refresh()
               CALL ui.Interface.refresh()
              #CALL cl_show_fld_cont()  
            END IF

        AFTER FIELD ruku
           #勾选上时要决断这个系列已经齐套出。
           IF g_oea[l_ac].ruku = 'Y' THEN 
              #检查是否已经有系列勾选
              IF NOT t220_ruku_chk(l_ac)  THEN
                 LET g_oea[l_ac].ruku = 'N' 
                 NEXT FIELD ruku
              END IF 
              CALL t220_chk_qitao(g_oea[l_ac].oea01,g_oea[l_ac].oba01)
                 RETURNING l_result,l_idx
              IF NOT l_result THEN 
                 CALL cl_err(l_idx,'aba-027',0)
                 LET g_oea[l_ac].ruku = g_oea_t.ruku
                 NEXT FIELD ruku
              END IF 
           END IF 
           
        BEFORE INSERT 

           
        AFTER INSERT 
            LET l_ac = ARR_CURR()                                                                                                           
            LET l_ac_t = l_ac     
            IF g_oea[l_ac].oea01 IS NULL THEN 
               CANCEL INSERT
            END IF 
                
        ON ROW CHANGE
           IF INT_FLAG THEN             
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_oea[l_ac].* = g_oea_t.*
              ROLLBACK WORK
              CONTINUE INPUT  
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err('',-263,0)
               LET g_oea[l_ac].* =g_oea_t.*
           ELSE
             # UPDATE sfb_file SET sfb05 = g_sfb[l_ac].sfb05,
             #                     sfb06 = g_sfb[l_ac].sfb06,
             #                     sfb07 = g_sfb[l_ac].sfb07
             # WHERE sfb01 = tm.sfb01
             #   AND sfb03 = g_sfb[l_ac].sfb03
             #  MESSAGE 'UPDATE O.K'
                COMMIT WORK
           END IF
                
        AFTER ROW
           LET l_ac = ARR_CURR()    
           LET l_ac_t = l_ac          
           IF INT_FLAG THEN 
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_oea[l_ac].* = g_oea_t.*
              END IF
              ROLLBACK WORK        
              EXIT INPUT
           END IF
           COMMIT WORK

        ON ACTION CONTROLZ
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
          
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT

        END INPUT
    IF INT_FLAG THEN
       LET INT_FLAG = FALSE
    END IF 

END FUNCTION


FUNCTION t220_show()
   DEFINE  l_ima02   LIKE ima_file.ima02
   DEFINE  l_ima021  LIKE ima_file.ima021   #FUN-AA0086
   
   CALL t220_b_fill()
   IF g_rec_b >0 THEN 
      CALL t220_c_fill(1)
      CALL t220_d_fill(1)
   END IF 
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION t220_b_fill()
   DEFINE p_wc2   STRING

   LET g_sql = "SELECT DISTINCT oea01,oea03,oea032,oba01,oba02,'N' ",
               "  FROM oea_file,oeb_file,oba_file,ima_file ",
               " WHERE oea01 = oeb01 ",
               "   AND oeb04 = ima01 ",
               "   AND ima131 = oba01 ",
              #"   AND ima76 = '52' ",    #No:DEV-CA0015--mark
               "   AND ima932 = 'H' ",    #No:DEV-CA0015--add
               "   AND oeaconf = 'Y' ",
               "   AND oeb70 = 'N' ",
               "   AND ",g_wc CLIPPED 
               
   PREPARE t220_pb FROM g_sql
   DECLARE oeb_cs CURSOR FOR t220_pb
 
   CALL g_oea.CLEAR()
   CALL g_sfb.clear()
   CALL g_max.clear()
   LET g_cnt = 1
 
   FOREACH oeb_cs INTO g_oea[g_cnt].*
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
   CALL g_oea.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO idx
   LET g_cnt = 0

END FUNCTION

FUNCTION t220_c_fill(p_ac)
   DEFINE  p_ac  LIKE type_file.num5

   LET g_sql = "SELECT sfb01,sfb05,ima02,ima021,sfb04,sfb08,sfb09,'' ",
               "  FROM sfb_file,oeb_file,ima_file ",
               " WHERE sfb22 = oeb01 ",
               "   AND sfb221 = oeb03 ",
               "   AND sfb05 = ima01 ",
               "   AND oeb01 = '",g_oea[p_ac].oea01,"' ",
               "   AND ima131 = '",g_oea[p_ac].oba01,"' ",
               "   AND ima932 = 'H' ",    #DEV-CC0001 add 
               " ORDER BY sfb01 "
   PREPARE sfb_pb FROM g_sql
   DECLARE  sfb_cs CURSOR FOR sfb_pb
   
   CALL g_sfb.clear()
   LET g_cnt = 1
   FOREACH sfb_cs INTO g_sfb[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       #入库数量去入库单实抓，可能有的入库单还没过账，没有回写工单入库数量
       #这种情况上，实际也不能再点完工入库操作了。
       SELECT SUM(sfv09) INTO g_sfb[g_cnt].sfb09 FROM sfv_file
        WHERE sfv11 = g_sfb[g_cnt].sfb01
       IF cl_null(g_sfb[g_cnt].sfb09) THEN LET g_sfb[g_cnt].sfb09 = 0 END IF 

     # LET g_sql = "SELECT MIN(sets),MAX(sets) FROM ( ",
     #             " SELECT imgb01,iba12,nvl(imgb05,0) AS sets ",
     #             "   FROM iba_file,imgb_file ",
     #             "  WHERE iba14 = '",g_sfb[g_cnt].sfb01,"' ",
     #             "    AND imgb01(+) = iba01 ",
     #             "    AND imgb00(+) = iba00 ",
     #             " ) "
     # PREPARE get_sets FROM g_sql
     # EXECUTE get_sets INTO g_sfb[g_cnt].sets,g_max[g_cnt].SETs
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF   
   END FOREACH 
   CALL g_sfb.deleteElement(g_cnt)
   LET g_rec_b2 = g_cnt - 1
   DISPLAY g_rec_b2 TO cnt

   

END FUNCTION 

FUNCTION t220_d_fill(p_ac)
   DEFINE p_ac     LIKE  type_file.num5
   DEFINE l_iba01  LIKE iba_file.iba01
  #DEFINE l_iba12  LIKE iba_file.iba12 #No:DEV-CA0015--mark

  #No:DEV-CA0015--mark--begin
  #LET g_sql = "SELECT iba01,iba12,imgb02,imgb03,imgb04,imgb05,'','' ",
  #            "  FROM iba_file,imgb_file ",
  #            " WHERE iba01 = imgb01(+) ",
  #            "   AND iba00 = imgb00(+) ",
  #            "   AND iba11 = '",g_oea[p_ac].oba01,"' ",
  #            "   AND iba04 = '52' ",
  #            "   AND iba14 = '",g_oea[p_ac].oea01,"' ",
  #            " ORDER BY iba01 "
  #No:DEV-CA0015--mark--end
   #No:DEV-CA0015--add--begin
   LET g_sql = "SELECT imgb01,ibb05,imgb02,imgb03,imgb04,imgb05,'','' ",
               "  FROM ibb_file LEFT OUTER JOIN imgb_file ON ibb01 = imgb01 ",
               " WHERE ibb02 = 'H' ",
               "   AND ibb03 = '",g_oea[p_ac].oea01,"' ",
               "   AND ibb09 = '",g_oea[p_ac].oba01,"' ",
               " ORDER BY imgb01 "
   #No:DEV-CA0015--add--end
               
   PREPARE t220_pb_d FROM g_sql
   DECLARE imgb_cs CURSOR FOR t220_pb_d
 
   CALL g_imgb.clear()
   LET g_cnt = 1
 
   FOREACH imgb_cs INTO g_imgb[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
      #IF g_imgb[g_cnt].imgb05 - g_sfb[l_ac].sets > 0 THEN   #多
      #   LET g_imgb[g_cnt].more = g_imgb[g_cnt].imgb05 - g_sfb[l_ac].sets
      #ELSE IF g_imgb[g_cnt].imgb05 - g_sfb[l_ac].sets < 0 THEN   #少
      #        LET g_imgb[g_cnt].less = g_sfb[l_ac].sets - g_imgb[g_cnt].imgb05
      #     END IF 
      #END IF 
     #多
  #    LET g_imgb[g_cnt].more = g_imgb[g_cnt].imgb05 - g_sfb[l_ac].sets
  #    IF g_imgb[g_cnt].more = 0 THEN 
  #       LET g_imgb[g_cnt].more = '' 
  #    END IF 
     #少
  #    IF cl_null(g_imgb[g_cnt].imgb05) THEN
  #       LET g_imgb[g_cnt].less = g_max[l_ac].sets 
  #    ELSE 
  #       LET g_imgb[g_cnt].less = g_max[l_ac].sets - g_imgb[g_cnt].imgb05
  #       IF g_imgb[g_cnt].less = 0 THEN 
  #          LET g_imgb[g_cnt].less = '' 
  #       END IF 
  #    END IF 
       
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_imgb.deleteElement(g_cnt)
   LET g_rec_b3=g_cnt-1
   DISPLAY g_rec_b3 TO cn2
   LET g_cnt = 0

END FUNCTION
  
FUNCTION t220_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
   DEFINE   l_sql  STRING
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel,close", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
    
      DISPLAY ARRAY g_oea TO s_oea.* ATTRIBUTE(COUNT=g_rec_b)
          BEFORE DISPLAY 
            IF l_ac > 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF 
            
          BEFORE ROW 
             LET l_ac  = ARR_CURR()
             IF l_ac  > 0 THEN
                CALL t220_c_fill(l_ac)
                CALL t220_d_fill(l_ac)
             END IF 
      END DISPLAY      
      
      DISPLAY ARRAY g_sfb TO s_sfb.* ATTRIBUTE(COUNT=g_rec_b)
          BEFORE DISPLAY 
            IF l_ac > 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF 
            
          BEFORE ROW 
             LET l_ac2  = ARR_CURR()
             IF l_ac2  > 0 THEN
             
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
         
      ON ACTION accept_a
         LET g_action_choice="accept_a"
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

FUNCTION t220_wo_exp(p_sfb01)
   DEFINE p_sfb01   LIKE sfb_file.sfb01
   DEFINE l_success LIKE type_file.chr1
   DEFINE l_sets    LIKE sfb_file.sfb08
   DEFINE l_sfu01   LIKE sfu_file.sfu01
   DEFINE l_cmd     LIKE type_file.chr1000
   DEFINE l_sfu   dynamic ARRAY OF RECORD 
                 sfu01  LIKE sfu_file.sfu01
                   END RECORD 
   DEFINE l_n       LIKE type_file.num5
   DEFINE l_cnt     LIKE type_file.num5
  
   IF NOT cl_confirm("abx-080") THEN RETURN END IF 
   
   LET l_n = 1
   FOR l_cnt =1 TO g_rec_b 
      IF g_oea[l_cnt].ruku = 'Y' THEN 
         CALL s_so_exp(g_oea[l_cnt].oea01,g_oea[l_cnt].oba01,FALSE)
            RETURNING l_success,l_sfu01
         IF l_success = 'Y' THEN 
            LET l_sfu[l_n].sfu01 = l_sfu01
            LET l_n = l_n + 1
         END IF 
      END IF 
   END FOR 
   IF l_success = 'Y' THEN
      CALL cl_err(l_sfu01,'aba-012',1)
   ELSE 
     #MESSAGE "Generate Error"         #DEV-CB0020 mark
      CALL cl_err(l_sfu01,'aba-123',1) #DEV-CB0020 add
   END IF 
    
   #不需要自动过账，打开对应的单据，手工过账
   IF l_success = 'Y' THEN
      LET l_cmd = " asft620"," '",l_sfu[1].sfu01,"' 'query' "
      CALL cl_cmdrun_wait(l_cmd)
   END IF 
END FUNCTION


FUNCTION t220_set_entry_b()
 
   CALL cl_set_comp_entry("oea01,oea03,oea032,oba01,oba02",FALSE)

END FUNCTION 

FUNCTION t220_set_no_entry_b()
 
   CALL cl_set_comp_entry("ruku",TRUE)

END FUNCTION 


FUNCTION t220_chk_qitao(p_oea01,p_oba01)
   DEFINE p_oea01  LIKE oea_file.oea01
   DEFINE p_oba01  LIKE oba_file.oba01
   DEFINE l_sum    LIKE ibc_file.ibc03
   DEFINE l_cnt    LIKE ibc_file.ibc03

   SELECT DISTINCT ibc03 INTO l_sum FROM ibc_file 
    WHERE ibc01 = p_oea01
      AND ibc00 = '2' 
      AND ibc08 = p_oba01
      
   IF cl_null(l_sum) OR l_sum=0 THEN 
      RETURN FALSE ,1
   END IF 

   FOR l_cnt = 1 TO l_sum 

      IF g_rec_b3 < l_cnt THEN RETURN FALSE ,l_cnt END IF 
      IF cl_null(g_imgb[l_cnt].imgb05) OR g_imgb[l_cnt].imgb05 <=0 THEN 
         RETURN FALSE,l_cnt
      END IF 

   END FOR
   RETURN TRUE,0

END FUNCTION


FUNCTION t220_fill_refresh()
   
   DISPLAY ARRAY g_sfb to s_sfb.* ATTRIBUTE(UNBUFFERED)

     BEFORE DISPLAY 
       EXIT DISPLAY

   END DISPLAY 

   DISPLAY ARRAY g_imgb to s_imgb.* ATTRIBUTE(UNBUFFERED)

     BEFORE DISPLAY 
       EXIT DISPLAY

   END DISPLAY 

END FUNCTION 

FUNCTION t220_ruku_chk(p_i)
   DEFINE p_i  LIKE type_file.num5
   DEFINE l_cnt  LIKE type_file.num5
  
   FOR l_cnt = 1 TO g_rec_b
     IF l_cnt != p_i AND g_oea[l_cnt].ruku = 'Y' THEN
        CALL cl_err('','aba-031',1)
        RETURN FALSE
     END IF 
   END FOR
   RETURN TRUE

END FUNCTION 
#DEV-D30025--add

