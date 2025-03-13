# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: almt552.4gl
# Descriptions...: 卡、券生效范围变更作业
# Date & Author..: No:FUN-960058 09/11/03 By destiny
# Modify.........: No:FUN-9B0136 09/11/27 By shiwuying
# Modify.........: No:FUN-A20034 10/02/08 By shiwuying 增加促銷生效範圍
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-A40015 10/04/06 By shiwuying 門店改抓azw01,rtz13->azp02
# Modify.........: No:FUN-A50056 10/05/13 By shiwuying pos處理
# Modify.........: No:TQC-A60048 10/06/12 By houlia ltc03查詢時開窗當出
# Modify.........: No:TQC-A60047 10/06/12 By houlia 維護報錯信息 
# Modify.........: No:TQC-A60065 10/06/17 By houlia 調整促銷變更時審核問題 
# Modify.........: No:TQC-A60083 10/06/21 By houlia construct添加ltaacti
# Modify.........: No:FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore
# Modify.........: No:TQC-A60122 10/07/07 By Carrier del_all()后显示正常信息 & 画面清空
# Modify.........: No:MOD-A70071 10/07/08 By Carrier 审核后,image即时显示
# Modify.........: No:FUN-A70130 10/08/06 By wangxin 修正取號時及check編號所傳入的模組代碼及單據性質代碼
# Modify.........: No.FUN-A70130 10/08/10 By huangtao 取消lrk_file所有相關資料
# Modify.........: No:FUN-A80148 10/09/02 By lixh1 因為 lma_file 表已不再使用,所以將lma_file改為rtz_file的相應欄位
# Modify.........: No:FUN-B40071 11/05/09 by jason 已傳POS否狀態調整
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B60118 11/06/22 By huangtao lpjpos值已設置為1/2/3,不可再用Y/N來判斷 
# Modify.........: No.FUN-B80060 11/08/05 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外
# Modify.........: No.FUN-BB0054 12/01/11 By pauline 移除 lta02 下拉項的 3 ~ 6,點選確認補入 update lph_file
# Modify.........: No.TQC-C30136 12/03/08 By fengrui 處理ON ACITON衝突問題
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-D30033 13/04/09 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"
#No.FUN-960058--begin 
DEFINE g_lta         RECORD LIKE lta_file.*,     
       g_lta_t       RECORD LIKE lta_file.*,    
       g_lta_o       RECORD LIKE lta_file.*,
       g_lta01_t     LIKE lta_file.lta01, 
       g_lta02_t     LIKE lta_file.lta02,    
       g_ltb         DYNAMIC ARRAY OF RECORD    
          ltb03      LIKE ltb_file.ltb03,
          ltb04      LIKE ltb_file.ltb04,
          azp02      LIKE azp_file.azp02,
          ltb05      LIKE ltb_file.ltb05,
          ltb06      LIKE ltb_file.ltb06, 
          ltb07      LIKE ltb_file.ltb07        
                     END RECORD,
       g_ltb_t       RECORD      
          ltb03      LIKE ltb_file.ltb03,
          ltb04      LIKE ltb_file.ltb04,
          azp02      LIKE azp_file.azp02,
          ltb05      LIKE ltb_file.ltb05,
          ltb06      LIKE ltb_file.ltb06, 
          ltb07      LIKE ltb_file.ltb07          
                     END RECORD,              
        g_ltb_o      RECORD         
          ltb03      LIKE ltb_file.ltb03,
          ltb04      LIKE ltb_file.ltb04,
          azp02      LIKE azp_file.azp02,
          ltb05      LIKE ltb_file.ltb05,
          ltb06      LIKE ltb_file.ltb06, 
          ltb07      LIKE ltb_file.ltb07        
                     END RECORD,    
       g_ltc         DYNAMIC ARRAY OF RECORD    
          ltc03      LIKE ltc_file.ltc03,
          lph02      LIKE lph_file.lph02       
                     END RECORD,       
       g_ltc_t       RECORD    
          ltc03      LIKE ltc_file.ltc03,
          lph02      LIKE lph_file.lph02       
                     END RECORD,     
       g_ltc_o       RECORD    
          ltc03      LIKE ltc_file.ltc03,
          lph02      LIKE lph_file.lph02      
                     END RECORD,                                                              
       g_sql         STRING,                      
       g_wc          STRING,                       
       g_wc2         STRING,  
       g_wc3         STRING,                    
       g_rec_b       LIKE type_file.num5,  
       g_rec_d       LIKE type_file.num5,   
       g_cnt1        LIKE type_file.num5,     
       l_ac          LIKE type_file.num5,
       l_ad          LIKE type_file.num5
DEFINE g_ltb01             LIKE ltb_file.ltb01
DEFINE g_ltb02             LIKE ltb_file.ltb02    
DEFINE g_forupd_sql        STRING                 
DEFINE g_before_input_done LIKE type_file.num5   
DEFINE g_chr               LIKE type_file.chr1   
DEFINE g_cnt               LIKE type_file.num10   
DEFINE g_i                 LIKE type_file.num5    
DEFINE g_msg               LIKE ze_file.ze03      
DEFINE g_curs_index        LIKE type_file.num10   
DEFINE g_row_count         LIKE type_file.num10   
DEFINE g_jump              LIKE type_file.num10   
DEFINE g_no_ask           LIKE type_file.num5  
DEFINE g_void              LIKE type_file.chr1
DEFINE g_confirm           LIKE type_file.chr1
DEFINE g_newno             LIKE lta_file.lta01
DEFINE g_date              LIKE lta_file.ltadate
DEFINE g_modu              LIKE lta_file.ltamodu
#DEFINE g_kindtype          LIKE lrk_file.lrkkind      #FUN-A70130   mark
#DEFINE g_kindslip          LIKE lrk_file.lrkslip      #FUN-A70130   mark
DEFINE g_kindtype         LIKE oay_file.oaytype        #FUN-A70130
DEFINE g_kindslip          LIKE oay_file.oayslip        #FUN-A70130
DEFINE g_b_flag            STRING 
DEFINE g_lta02             LIKE lta_file.lta02   #No.FUN-A20034
 
MAIN
   OPTIONS                               
        INPUT NO WRAP    #No.FUN-9B0136
    #   FIELD ORDER FORM #No.FUN-9B0136
   DEFER INTERRUPT              
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF 
  
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_forupd_sql = "SELECT * FROM lta_file WHERE lta01 = ? AND lta02 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t552_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW t552_w WITH FORM "alm/42f/almt552"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()  
 
   #LET g_kindtype = '45' #FUN-A70130

   LET g_kindtype = 'O1' #FUN-A70130
   CALL t552_menu()
   CLOSE WINDOW t552_w 
   
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t552_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01    
 
      CLEAR FORM 
      CALL g_ltb.clear()  
      CALL g_ltc.clear()
  
      CALL cl_set_head_visible("","YES")   
      INITIALIZE g_lta.* TO NULL     
#     CONSTRUCT BY NAME g_wc ON lta01,lta02,lta03,lta04,lta05,lta06,ltauser,
#                               ltagrup,ltamodu,ltadate,ltacrat,ltaorig,ltaoriu
      CONSTRUCT BY NAME g_wc ON lta01,lta02,lta03,lta04,lta05,lta06,ltauser,
                                ltagrup,ltamodu,ltadate,ltacrat,ltaorig,ltaoriu,ltaacti       #TQC-A60083  -add ltaacti
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()       
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(lta01) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lta01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lta01
                  NEXT FIELD lta01           
               OTHERWISE EXIT CASE
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
      
        
         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
      
      END CONSTRUCT
      
      IF INT_FLAG THEN
         RETURN
      END IF
 
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ltauser', 'ltagrup')
 
      CONSTRUCT g_wc2 ON ltb03,ltb04,ltb05,ltb06,ltb07
              FROM s_ltb[1].ltb03,s_ltb[1].ltb04,s_ltb[1].ltb05,s_ltb[1].ltb06,
                   s_ltb[1].ltb07
                
 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         
         ON ACTION CONTROLP
            CASE              
             WHEN INFIELD(ltb04) 
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_ltb04"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ltb04
               NEXT FIELD ltb04
               
             WHEN INFIELD(ltb05) 
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_ltb05"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ltb05
               NEXT FIELD ltb05          
             OTHERWISE EXIT CASE  
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
      
      LET g_wc2 = g_wc2 CLIPPED   
      
      CONSTRUCT g_wc3 ON ltc03
                    FROM s_ltc[1].ltc03
                
 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         
         ON ACTION CONTROLP
            CASE              
             WHEN INFIELD(ltc03) 
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_ltc03"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ltc03
#              NEXT FIELD ltc03s
               NEXT FIELD ltc03    #TQC-A60048
             OTHERWISE EXIT CASE  
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
      
      LET g_wc3 = g_wc3 CLIPPED  
      CASE WHEN g_wc2=" 1=1 " AND g_wc3=" 1=1 " 
            LET g_sql= "SELECT lta01,lta02 FROM lta_file ",
                      " WHERE ", g_wc CLIPPED,
                      " ORDER BY lta01,lta02"
           WHEN g_wc2<>" 1=1 " AND g_wc3=" 1=1 "   
            LET g_sql= "SELECT UNIQUE lta01,lta02 ",
                       "  FROM lta_file, ltb_file ",
                       " WHERE lta01 = ltb01",
                       "   AND lta02 = ltb02",
                       "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                       " ORDER BY lta01,lta02"   
           WHEN g_wc2=" 1=1 " AND g_wc3<>" 1=1 "   
            LET g_sql= "SELECT UNIQUE lta01,lta02 ",
                       "  FROM lta_file, ltc_file ",
                       " WHERE lta01 = ltc01",
                       "   AND lta02 = ltc02",
                       "   AND ", g_wc CLIPPED, " AND ",g_wc3 CLIPPED,
                       " ORDER BY lta01,lta02"       
           WHEN g_wc2<>" 1=1 " AND g_wc3<>" 1=1 "  
            LET g_sql= "SELECT UNIQUE lta01,lta02 ",
                       "  FROM lta_file,ltb_file,ltc_file ",
                       " WHERE lta01 = ltc01 AND lta02 = ltc02",
                       "   AND lta01 = ltb01 AND lta02 = ltb02",
                       "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                       " AND ",g_wc3 CLIPPED,
                       " ORDER BY lta01,lta02"                                                        
      END CASE    
  
   PREPARE t552_prepare FROM g_sql
   DECLARE t552_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t552_prepare

      CASE WHEN g_wc2=" 1=1 " AND g_wc3=" 1=1 " 
            LET g_sql= "SELECT count(*) FROM lta_file ",
                      " WHERE ", g_wc CLIPPED
           WHEN g_wc2<>" 1=1 " AND g_wc3=" 1=1 "   
            LET g_sql="SELECT COUNT(DISTINCT lta01,lta02) ",
                      "FROM lta_file,ltb_file WHERE ",
                      "lta01=ltb01 AND lta02 = ltb02 and ",
                       g_wc CLIPPED," AND ",g_wc2 CLIPPED                       
           WHEN g_wc2=" 1=1 " AND g_wc3<>" 1=1 "   
            LET g_sql="SELECT COUNT(DISTINCT lta01,lta02) ",
                      " FROM lta_file,ltc_file WHERE ",
                      " lta01=ltc01 AND lta02 = ltc02 and ",
                       g_wc CLIPPED," AND ",g_wc3 CLIPPED        
           WHEN g_wc2<>" 1=1 " AND g_wc3<>" 1=1 "  
            LET g_sql= "SELECT COUNT(DISTINCT lta01,lta02) ",
                       "  FROM lta_file,ltb_file,ltc_file ",
                       " WHERE lta01 = ltc01 AND lta02 = ltc02",
                       "   AND lta01 = ltb01 AND lta02 = ltb02",
                       "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                       " AND ",g_wc3 CLIPPED                                                      
      END CASE    
       
   PREPARE t552_precount FROM g_sql
   DECLARE t552_count CURSOR FOR t552_precount
 
END FUNCTION
 
FUNCTION t552_menu()
#DEFINE  l_lrkdmy2       LIKE lrk_file.lrkdmy2       #FUN-A70130   mark
DEFINE   l_oayconf       LIKE oay_file.oayconf       #FUN-A70130
 
   WHILE TRUE
      CALL t552_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t552_a()                                            
                LET g_kindslip=s_get_doc_no(g_lta.lta01)                                         
                IF NOT cl_null(g_kindslip) THEN  
      #FUN-A70130 ----------------------start--------------------------------                
      #             SELECT lrkdmy2 INTO l_lrkdmy2 FROM lrk_file                                      
      #              WHERE lrkslip = g_kindslip                                              
      #              IF l_lrkdmy2 = 'Y' THEN 
                    SELECT oayconf  INTO l_oayconf FROM oay_file
                    WHERE oayslip = g_kindslip
                    IF l_oayconf = 'Y' THEN
      #FUN-A70130 ----------------------end----------------------------------      
                       CALL t552_confirm()                                                               
                       CALL t552_pic()
                    END IF                      
                END IF       
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t552_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t552_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t552_u()   
            END IF

         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t552_x()
            END IF
             
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t552_confirm()
            END IF 
             CALL t552_pic()                        
                
         WHEN "detail"
           IF cl_chk_act_auth() THEN         
             IF g_b_flag IS NULL OR g_b_flag ='1' THEN
                 CALL t552_b('a')
              ELSE 
              	 CALL t552_b1('a')
              END IF 
           ELSE
              LET g_action_choice = NULL
           END IF
            
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"    
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ltb),'','')
            END IF
         
         WHEN "related_document"  
              IF cl_chk_act_auth() THEN
                 IF g_lta.lta01 IS NOT NULL THEN
                 LET g_doc.column1 = "lta01"
                 LET g_doc.value1 = g_lta.lta01
                 CALL cl_doc()
               END IF
         END IF      
        
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t552_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   DIALOG ATTRIBUTES(UNBUFFERED)   
   DISPLAY ARRAY g_ltb TO s_ltb.* ATTRIBUTE(COUNT=g_rec_b)
     BEFORE DISPLAY
        CALL cl_set_act_visible("accept,cancel",FALSE )  
         LET g_b_flag='1'
        CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()  
              
      #TQC-C30136--mark--str--
      #ON ACTION accept
      #   LET g_action_choice="detail"
      #   LET l_ac = ARR_CURR()
      #   EXIT DIALOG
      #TQC-C30136--mark--end--
   END DISPLAY
   
   DISPLAY ARRAY g_ltc TO s_ltc.* ATTRIBUTE(COUNT=g_rec_d)
      BEFORE DISPLAY
         CALL cl_set_act_visible("accept,cancel",FALSE )  
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         LET g_b_flag='2'
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont() 
      #TQC-C30136--mark--str--
      #ON ACTION accept
      #   LET g_action_choice="detail"
      #   LET l_ac = ARR_CURR()
      #   EXIT DIALOG
      #TQC-C30136--mark--end--
   END DISPLAY 
   
   BEFORE DIALOG   
       ON ACTION insert
         LET g_action_choice="insert"
         EXIT DIALOG

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DIALOG

      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DIALOG
            
      ON ACTION first
         CALL t552_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION previous
         CALL t552_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION jump
         CALL t552_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION next
         CALL t552_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION last
         CALL t552_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG


      ON ACTION  ltb
         LET g_b_flag ='1'
         LET g_action_choice="detail"
         EXIT DIALOG
         
      ON ACTION  ltc
         LET g_b_flag ='2'
         LET g_action_choice="detail"
         EXIT DIALOG
         
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DIALOG
         
      ON ACTION confirm 
         LET g_action_choice="confirm"
         IF cl_chk_act_auth() THEN
            CALL t552_confirm()
         END IF 

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DIALOG

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DIALOG

      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()       

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

      ON ACTION cancel
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
               
      AFTER DIALOG
         CONTINUE DIALOG
   END DIALOG 
   
   CALL cl_set_act_visible("accept,cancel",TRUE) 
END FUNCTION
 
FUNCTION t552_bp_refresh()
  DISPLAY ARRAY g_ltb TO s_ltb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
  DISPLAY ARRAY g_ltc TO s_ltc.* ATTRIBUTE(COUNT=g_rec_d,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
 
END FUNCTION
 
FUNCTION t552_a()
   DEFINE li_result   LIKE type_file.num5   
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10  
   DEFINE l_n         LIKE type_file.num5 
     
   MESSAGE ""
   CLEAR FORM
   LET g_success = 'Y'
   
   CALL g_ltb.clear()
   CALL g_ltc.clear()
   LET g_wc = NULL
   LET g_wc2= NULL 
   LET g_wc3= NULL 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_lta.* LIKE lta_file.*         
   LET g_lta01_t = NULL
   LET g_lta02_t = NULL 
   LET g_lta_t.* = g_lta.*
   LET g_lta_o.* = g_lta.*
   CALL cl_opmsg('a')
   
   WHILE TRUE
      LET g_lta.ltauser=g_user
      LET g_lta.ltaacti='Y'
      LET g_lta.ltaoriu = g_user 
      LET g_lta.ltaorig = g_grup 
      LET g_lta.ltacrat=g_today
      LET g_lta.ltagrup=g_grup
      LET g_lta.lta03 = 'N'
      CALL t552_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                  
         INITIALIZE g_lta.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_lta.lta01) THEN    
         CONTINUE WHILE
      END IF
 
      BEGIN WORK
      CALL s_auto_assign_no("alm",g_lta.lta01,g_lta.ltacrat,g_kindtype,"lta_file","lta01","","","")
         RETURNING li_result,g_lta.lta01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_lta.lta01
 
      INSERT INTO lta_file VALUES (g_lta.*)    
 
      IF SQLCA.sqlcode THEN                   
      #   ROLLBACK WORK        # FUN-B80060 下移兩行
         CALL cl_err3("ins","lta_file",g_lta.lta01,"",SQLCA.sqlcode,"","",1)  
         ROLLBACK WORK        # FUN-B80060
         CONTINUE WHILE
      ELSE
         COMMIT WORK      
         CALL cl_flow_notify(g_lta.lta01,'I')
      END IF
 
      SELECT * INTO g_lta.* FROM lta_file
       WHERE lta01 = g_lta.lta01
      LET g_lta01_t = g_lta.lta01       
      LET g_lta02_t = g_lta.lta02
      LET g_lta_t.* = g_lta.*
      LET g_lta_o.* = g_lta.*
      CALL g_ltb.clear()
      CALL g_ltc.clear()
      LET g_rec_b = 0  
      LET g_rec_d = 0 
      CALL t552_b('a')                 
      CALL t552_b1('a')
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t552_u()
DEFINE l_n       LIKE type_file.num5
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lta.lta01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_lta.lta03 = 'Y' THEN 
      CALL cl_err(g_lta.lta01,'alm-027',1)
      RETURN 
   END IF 
 
   IF g_lta.ltaacti='N' THEN 
      CALL cl_err(g_lta.lta01,'alm-147',1)
      RETURN 
   END IF  
   
    SELECT COUNT(*) INTO l_n FROM ltc_file
     WHERE ltc01 = g_lta.lta01
       AND ltc02 = g_lta.lta02
       AND ltc03 IS NOT NULL     
   IF l_n>0 THEN 
      CALL cl_err('','alm-842',1)
      RETURN 
   END IF     
   SELECT * INTO g_lta.* FROM lta_file
    WHERE lta01=g_lta.lta01
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_lta01_t = g_lta.lta01
   LET g_lta02_t = g_lta.lta02
   BEGIN WORK
 
   OPEN t552_cl USING g_lta_t.lta01,g_lta_t.lta02
   IF STATUS THEN
      CALL cl_err("OPEN t552_cl:", STATUS, 1)
      CLOSE t552_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t552_cl INTO g_lta.*                    
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_lta.lta01,SQLCA.sqlcode,0)   
       CLOSE t552_cl
       ROLLBACK WORK
       RETURN
   END IF
  
  LET g_date = g_lta.ltadate
  LET g_modu = g_lta.ltamodu  
                                                                      
   CALL t552_show()
 
   WHILE TRUE
      LET g_lta01_t = g_lta.lta01
      LET g_lta02_t = g_lta.lta02
      LET g_lta_o.* = g_lta.*
      LET g_lta_t.* = g_lta.*
      LET g_lta.ltamodu=g_user
      LET g_lta.ltadate=g_today
      CALL t552_i("u")    
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_lta_t.ltadate = g_date
         LET g_lta_t.ltamodu = g_modu
         LET g_lta.*=g_lta_t.*         
         CALL t552_show()
         CALL cl_err('','9001',0)     
         RETURN        
         EXIT WHILE
      END IF
 
      IF g_lta.lta01 != g_lta01_t OR g_lta.lta02 != g_lta02_t THEN      
         UPDATE ltb_file SET ltb01 = g_lta.lta01,
                             ltb02 = g_lta.lta02
          WHERE ltb01 = g_lta01_t AND ltb02=g_lta_t.lta02
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","ltb_file",g_lta01_t,"",SQLCA.sqlcode,"","pmx",1)  
            CONTINUE WHILE
         END IF     
      END IF
 
      UPDATE lta_file SET lta_file.* = g_lta.*
       WHERE lta01 = g_lta01_t AND lta02 = g_lta02_t
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","lta_file","","",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t552_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lta.lta01,'U')
   CALL t552_show()
   CALL t552_b_fill("1=1")
   CALL t552_b1_fill("1=1")
   #CALL t552_bp_refresh()
 
END FUNCTION

FUNCTION t552_x()
 
    IF g_lta.lta01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_lta.lta03 = 'Y' THEN 
       CALL cl_err(g_lta.lta01,'alm-028',1)
       RETURN 
    END IF
    let g_lta_t.*=g_lta.*
    BEGIN WORK
 
    OPEN t552_cl USING g_lta.lta01,g_lta.lta02
    IF STATUS THEN
       CALL cl_err("OPEN t552_cl:", STATUS, 1)
       CLOSE t552_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t552_cl INTO g_lta.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lta.lta01,SQLCA.sqlcode,1)
       RETURN
    END IF

    CALL t552_show()
    IF cl_exp(0,0,g_lta.ltaacti) THEN
        LET g_chr=g_lta.ltaacti
        IF g_lta.ltaacti='Y' THEN
            LET g_lta.ltaacti='N'
        ELSE
            LET g_lta.ltaacti='Y'
        END IF
        LET g_lta.ltamodu=g_user                  
        LET g_lta.ltadate = g_today
        UPDATE lta_file
            SET ltaacti=g_lta.ltaacti,
                ltamodu=g_lta.ltauser,
                ltadate=g_lta.ltadate
            WHERE lta01=g_lta.lta01
              and lta02=g_lta.lta02
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_lta.lta01,SQLCA.sqlcode,0)
            LET g_lta.ltaacti=g_chr
            LET g_lta.ltamodu=g_lta_t.ltamodu
            LET g_lta.ltadate=g_lta_t.ltadate
        END IF
        DISPLAY BY NAME g_lta.ltaacti
    END IF
    CALL t552_pic()
    CLOSE t552_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t552_i(p_cmd)
DEFINE    l_n         LIKE type_file.num5
DEFINE    p_cmd       LIKE type_file.chr1    
DEFINE    li_result   LIKE type_file.num5
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_lta.lta01,g_lta.lta02,g_lta.lta06,g_lta.lta03,g_lta.lta04,g_lta.lta05,
                   g_lta.ltauser,g_lta.ltamodu,g_lta.ltagrup,g_lta.ltadate,g_lta.ltacrat,
                   g_lta.ltaacti,g_lta.ltaoriu,g_lta.ltaorig
  
   INPUT BY NAME g_lta.lta01,g_lta.lta02,g_lta.lta06          
            WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t552_set_entry(p_cmd)
         CALL t552_set_no_entry(p_cmd)
         CALL cl_set_docno_format("lta01")
         LET g_before_input_done = TRUE       
 
      AFTER FIELD lta01
       IF NOT cl_null(g_lta.lta01) THEN                                                                                          
            CALL s_check_no("alm",g_lta.lta01,g_lta01_t,g_kindtype,"lta_file","lta01","")
                 RETURNING li_result,g_lta.lta01
            IF (NOT li_result) THEN
               LET g_lta.lta01=g_lta_t.lta01
               NEXT FIELD lta01
            END IF
              DISPLAY BY NAME g_lta.lta01
            END IF    
   
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                 
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
 
      ON ACTION controlp
         CASE    
            WHEN INFIELD(lta01)
               LET g_kindslip = s_get_doc_no(g_lta.lta01)
             #  CALL q_lrk(FALSE,FALSE,g_kindslip,g_kindtype,'ALM') RETURNING g_kindslip  #FUN-A70130  mark
              CALL q_oay(FALSE,FALSE,g_kindslip,g_kindtype,'ALM') RETURNING g_kindslip  #FUN-A70130  add
               LET g_lta.lta01 = g_kindslip
               DISPLAY BY NAME g_lta.lta01
               NEXT FIELD lta01
 
            OTHERWISE EXIT CASE
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()      
 
      ON ACTION help         
         CALL cl_show_help()  
 
   END INPUT
END FUNCTION
 
FUNCTION t552_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_ltb.clear()
   CALL g_ltc.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t552_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_lta.* TO NULL
      RETURN
   END IF
 
   OPEN t552_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_lta.* TO NULL
   ELSE
      OPEN t552_count
      FETCH t552_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL t552_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION t552_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式  
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t552_cs INTO g_lta.lta01,g_lta.lta02
      WHEN 'P' FETCH PREVIOUS t552_cs INTO g_lta.lta01,g_lta.lta02
      WHEN 'F' FETCH FIRST    t552_cs INTO g_lta.lta01,g_lta.lta02
      WHEN 'L' FETCH LAST     t552_cs INTO g_lta.lta01,g_lta.lta02
      WHEN '/'
            IF (NOT g_no_ask) THEN     
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg     
         CALL cl_cmdask()     
 
                END PROMPT
                IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump t552_cs INTO g_lta.lta01,g_lta.lta02
            LET g_no_ask = FALSE    
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lta.lta01,SQLCA.sqlcode,0)
      INITIALIZE g_lta.* TO NULL              
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting( g_curs_index, g_row_count )
      DISPLAY g_curs_index TO FORMONLY.idx   
   END IF
 
   SELECT * INTO g_lta.* FROM lta_file WHERE lta01 = g_lta.lta01 AND lta02 = g_lta.lta02
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","lta_file","","",SQLCA.sqlcode,"","",1)  
      INITIALIZE g_lta.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_lta.ltauser        
   LET g_data_group = g_lta.ltagrup     
   CALL t552_show()
 
END FUNCTION
 
FUNCTION t552_show()
 
   LET g_lta_t.* = g_lta.*                
   LET g_lta_o.* = g_lta.*                
   LET g_lta01_t = g_lta.lta01
   LET g_lta02_t = g_lta.lta02
   DISPLAY BY NAME g_lta.lta01,g_lta.lta02,g_lta.lta06,g_lta.lta03,g_lta.lta04,g_lta.lta05,
                   g_lta.ltauser,g_lta.ltamodu,g_lta.ltagrup,g_lta.ltadate,g_lta.ltacrat,
                   g_lta.ltaacti,g_lta.ltaoriu,g_lta.ltaorig
   
   CALL t552_pic()  
   CALL t552_b_fill(g_wc2)              
   CALL t552_b1_fill(g_wc3)
   CALL cl_show_fld_cont()    
END FUNCTION
  
FUNCTION t552_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lta.lta01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   
   IF g_lta.lta03 = 'Y' THEN 
      CALL cl_err(g_lta.lta01,'alm-028',1)
      RETURN 
   END IF
 
   IF g_lta.ltaacti='N' THEN 
      CALL cl_err(g_lta.lta01,'alm-147',1)
      RETURN 
   END IF   
   
   SELECT * INTO g_lta.* FROM lta_file
    WHERE lta01=g_lta.lta01 AND lta02=g_lta.lta02
    BEGIN WORK
 
   OPEN t552_cl USING g_lta_t.lta01,g_lta_t.lta02
   IF STATUS THEN
      CALL cl_err("OPEN t552_cl:", STATUS, 1)
      CLOSE t552_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t552_cl INTO g_lta.*              
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lta.lta01,SQLCA.sqlcode,0)         
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t552_show()
 
   IF cl_delh(0,0) THEN                   
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "lta01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_lta.lta01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                                            #No.FUN-9B0098 10/02/24
      DELETE FROM lta_file WHERE lta01 = g_lta_t.lta01 
                             AND lta02 = g_lta_t.lta02
      DELETE FROM ltb_file WHERE ltb01 = g_lta_t.lta01 
                             AND ltb02 = g_lta_t.lta02
      DELETE FROM ltc_file WHERE ltc01 = g_lta_t.lta01 
                             AND ltc02 = g_lta_t.lta02                       
      CLEAR FORM
      CALL g_ltb.clear()
      CALL g_ltc.clear()
      OPEN t552_count
      #FUN-B50063-add-start--
      IF STATUS THEN
         CLOSE t552_cs
         CLOSE t552_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end-- 
      FETCH t552_count INTO g_row_count
      #FUN-B50063-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t552_cs
         CLOSE t552_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t552_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t552_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE     
         CALL t552_fetch('/')
      END IF
   END IF
 
   CLOSE t552_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lta.lta01,'D')
END FUNCTION
 
FUNCTION t552_b(p_w)
DEFINE   l_ac_t          LIKE type_file.num5               
DEFINE   l_n             LIKE type_file.num5    
DEFINE   l_n1            LIKE type_file.num5      
DEFINE   l_n2            LIKE type_file.num5         
DEFINE   l_cnt           LIKE type_file.num5             
DEFINE   l_lock_sw       LIKE type_file.chr1            
DEFINE   p_cmd           LIKE type_file.chr1               
DEFINE   l_allow_insert  LIKE type_file.num5               
DEFINE   l_allow_delete  LIKE type_file.num5     
DEFINE  p_w              LIKE type_file.chr1
   
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_lta.lta01 IS NULL THEN
       CALL cl_err('',-400,1)
       RETURN
    END IF
    IF g_lta.lta03 = 'Y' THEN 
       CALL cl_err('','alm-097',1)
       RETURN
    END IF 
    IF g_lta.ltaacti='N' THEN 
       CALL cl_err(g_lta.lta01,'alm-147',1)
       RETURN 
    END IF   
 
    SELECT * INTO g_lta.* FROM lta_file
     WHERE lta01=g_lta.lta01 AND lta02=g_lta.lta02
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT ltb03,ltb04,'',ltb05,ltb06,ltb07 from ltb_file", 
                       " WHERE ltb01 =? and ltb02 =? and ltb03 = ?",
                       "  FOR UPDATE "
                         
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t552_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_ltb WITHOUT DEFAULTS FROM s_ltb.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN t552_cl USING g_lta.lta01,g_lta.lta02
           IF STATUS THEN
              CALL cl_err("OPEN t552_cl:", STATUS, 1)
              CLOSE t552_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t552_cl INTO g_lta.*           
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_lta.lta01,SQLCA.sqlcode,0)     
              CLOSE t552_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_ltb_t.* = g_ltb[l_ac].*  #BACKUP
              LET g_ltb_o.* = g_ltb[l_ac].*  #BACKUP
              OPEN t552_bcl USING g_lta.lta01,g_lta.lta02,g_ltb_t.ltb03
              IF STATUS THEN
                 CALL cl_err("OPEN t552_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t552_bcl INTO g_ltb[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_ltb_t.ltb03,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 ELSE 
                	  CALL t552_ltb04('d')                    
                 END IF   
              END IF
              CALL cl_show_fld_cont()    
#              CALL t552_set_entry_b(p_cmd)    
#              CALL t552_set_no_entry_b(p_cmd) 
           END IF
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_ltb[l_ac].* TO NULL      
           LET g_ltb_t.* = g_ltb[l_ac].*       
           LET g_ltb_o.* = g_ltb[l_ac].*      
           LET g_ltb[l_ac].ltb07 = 'Y'
           #LET g_ltb[l_ac].ltb05 =' '
           CALL cl_show_fld_cont()        
#           CALL t552_set_entry_b(p_cmd)   
#           CALL t552_set_no_entry_b(p_cmd)
           NEXT FIELD ltb03
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF          
           IF cl_null(g_ltb[l_ac].ltb03) THEN
              CALL cl_err('','alm-062',1)
              NEXT FIELD ltb03 
           END IF
          INSERT INTO ltb_file(ltb01,ltb02,ltb03,ltb04,ltb05,ltb06,ltb07)
          VALUES(g_lta.lta01,g_lta.lta02,
                 g_ltb[l_ac].ltb03,g_ltb[l_ac].ltb04,
                 g_ltb[l_ac].ltb05,g_ltb[l_ac].ltb06,g_ltb[l_ac].ltb07)
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","ltb_file",g_lta.lta01,g_ltb[l_ac].ltb03,SQLCA.sqlcode,"","",1)  
             CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF      

       BEFORE FIELD ltb03   
         IF cl_null(g_ltb[l_ac].ltb03) OR cl_null(g_ltb_t.ltb03) THEN 
            SELECT max(ltb03)+1 INTO g_ltb[l_ac].ltb03 FROM ltb_file      
             WHERE ltb01=g_lta.lta01 AND ltb02=g_lta.lta02  
            IF cl_null(g_ltb[l_ac].ltb03) OR g_ltb[l_ac].ltb03 <= 0 THEN 
               LET g_ltb[l_ac].ltb03 = 1 
            END IF  
         END IF   
          
        AFTER FIELD ltb03         
          IF NOT cl_null(g_ltb[l_ac].ltb03) THEN  
             IF p_cmd = 'a' OR (p_cmd = 'u' AND g_ltb[l_ac].ltb03 != g_ltb_t.ltb03) THEN             
                SELECT COUNT(*) INTO l_n FROM ltb_file 
                 WHERE ltb01=g_lta.lta01 AND ltb02=g_lta.lta02
                   AND ltb03=g_ltb[l_ac].ltb03
                IF l_n>0 THEN 
                   CALL cl_err('','-239',1)
                   LET g_ltb[l_ac].ltb03=g_ltb_t.ltb03
                   NEXT FIELD ltb03
                END IF 
             END IF            
         END IF 

        AFTER FIELD ltb04         
          IF NOT cl_null(g_ltb[l_ac].ltb04) THEN  
             IF p_cmd = 'a' OR (p_cmd = 'u' AND g_ltb[l_ac].ltb04 != g_ltb_t.ltb04) THEN  
                CALL t552_check()        
                IF NOT cl_null(g_errno) THEN 
                   CALL cl_err('',g_errno,1)
                   LET g_ltb[l_ac].ltb04=g_ltb_t.ltb04
                   NEXT FIELD ltb04
                END IF 
                CALL t552_ltb04('a')
                IF NOT cl_null(g_errno) THEN 
                   CALL cl_err('',g_errno,1)
                   LET g_ltb[l_ac].ltb04=g_ltb_t.ltb04
                   NEXT FIELD ltb04
                END IF 
             END IF     
         ELSE 
         	  LET g_ltb[l_ac].azp02=''
         	  DISPLAY '' TO g_ltb[l_ac].azp02       
         END IF 

        AFTER FIELD ltb05
           IF g_ltb[l_ac].ltb05 IS NOT NULL THEN                          
              IF g_ltb[l_ac].ltb05 != g_ltb_t.ltb05 OR
                 g_ltb_t.ltb05 IS NULL THEN
                 IF cl_null(g_ltb[l_ac].ltb04) THEN           
                 #   CALL t552_check()
                 #   IF NOT cl_null(g_errno) THEN 
                 #      CALL cl_err('',g_errno,1)       
                 #      LET g_ltb[l_ac].ltb05 = g_ltb_t.ltb05                                                                        
                 #      NEXT FIELD ltb05   
                 #   END IF          
                 #ELSE                     
                 	  IF cl_null(g_ltb[l_ac].ltb05) THEN 
                 	     CALL cl_err('','alm-843',1)
                 	     NEXT FIELD ltb04     
                 	  ELSE          
                 	     #SELECT lmlstore INTO g_ltb[l_ac].ltb04 FROM lml_file 
                 	     # WHERE lml01=g_ltb[l_ac].ltb05
                 	     #IF cl_null(g_ltb[l_ac].ltb04) THEN 
                 	     #   CALL cl_err('','alm-837',1)
                 	     #   LET g_ltb[l_ac].ltb05 = g_ltb_t.ltb05
                 	     #   NEXT FIELD ltb05
                 	     #ELSE 
                 	     #   SELECT rtz13 INTO g_ltb[l_ac].rtz13 FROM rtz_file
                 	     #    WHERE rtz01=g_ltb[l_ac].ltb04
                             #No.FUN-A40015 -BEGIN-----
                             #SELECT rtz13,lmlstore INTO g_ltb[l_ac].rtz13,g_ltb[l_ac].ltb04
                             #  FROM lml_file,rtz_file
                             # WHERE lml01=g_ltb[l_ac].ltb05 
                             #   AND lmlstore=rtz01
                              SELECT lmlstore INTO g_ltb[l_ac].ltb04
                                FROM lml_file
                               WHERE lml01=g_ltb[l_ac].ltb05
                             #No.FUN-A40015 -END-------
                       IF SQLCA.sqlcode=100 THEN 
                          CALL cl_err('','alm-837',1)       
                          LET g_ltb[l_ac].ltb04=g_ltb_t.ltb04
                          LET g_ltb[l_ac].ltb05=g_ltb_t.ltb05                                                                        
                          NEXT FIELD ltb05   
                       ELSE 
                       	  SELECT COUNT(*) INTO l_n1 FROM ltb_file 
                           WHERE ltb01=g_lta.lta01 AND ltb02=g_lta.lta02
                             AND ltb04=g_ltb[l_ac].ltb04
                             AND ltb05=g_ltb[l_ac].ltb05
                          IF l_n1>0 THEN
                             CALL cl_err('','alm-835',1)       
                             LET g_ltb[l_ac].ltb04=g_ltb_t.ltb04
                             LET g_ltb[l_ac].azp02=g_ltb_t.azp02
                             LET g_ltb[l_ac].ltb05=g_ltb_t.ltb05                                                                        
                             NEXT FIELD ltb05
                          ELSE
                            #No.FUN-A40015 -BEGIN-----
                             SELECT azp02 INTO g_ltb[l_ac].azp02 FROM azp_file
                              WHERE azp01 = g_ltb[l_ac].ltb04
                            #No.FUN-A40015 -END-------
                       	     DISPLAY BY NAME g_ltb[l_ac].azp02
                 	           DISPLAY BY NAME g_ltb[l_ac].ltb04
                 	        END IF 
                       END IF                   	        
                 	     #END IF                        
                 	  END IF 
                 END IF
                 CALL t552_ltb05()
                 IF NOT cl_null(g_errno) THEN 
                   CALL cl_err('',g_errno,1)
                   LET g_ltb[l_ac].ltb05 = g_ltb_t.ltb05
                   NEXT FIELD ltb05
                 END IF   
                 CALL t552_check()
                 IF NOT cl_null(g_errno) THEN 
                    CALL cl_err('',g_errno,1)       
                    LET g_ltb[l_ac].ltb05 = g_ltb_t.ltb05                                                                        
                    NEXT FIELD ltb05   
                 END IF 
              END IF      
           ELSE 
           	  LET g_ltb[l_ac].ltb05=' ' 
              CALL t552_check()
              IF NOT cl_null(g_errno) THEN 
                 CALL cl_err('',g_errno,1)       
                 LET g_ltb[l_ac].ltb05 = g_ltb_t.ltb05                                                                        
                 NEXT FIELD ltb05   
              END IF            	  
           END IF  
                           
        BEFORE DELETE                      #是否取消單身
           DISPLAY "BEFORE DELETE"
           IF g_ltb_t.ltb03 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM ltb_file
               WHERE ltb01 = g_lta.lta01
                 AND ltb03 = g_ltb_t.ltb03
                 AND ltb02 = g_lta.lta02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","ltb_file",g_lta.lta01,g_ltb_t.ltb03,SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_ltb[l_ac].* = g_ltb_t.*
              CLOSE t552_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_ltb[l_ac].ltb03,-263,1)
              LET g_ltb[l_ac].* = g_ltb_t.*
           ELSE       	       
              UPDATE ltb_file SET ltb03=g_ltb[l_ac].ltb03,
                                  ltb04=g_ltb[l_ac].ltb04,
                                  ltb05=g_ltb[l_ac].ltb05,
                                  ltb06=g_ltb[l_ac].ltb06,
                                  ltb07=g_ltb[l_ac].ltb07  
               WHERE ltb01 = g_lta.lta01
                 AND ltb03 = g_ltb_t.ltb03
                 AND ltb02 = g_lta.lta02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","ltb_file",g_lta.lta01,g_ltb_t.ltb03,SQLCA.sqlcode,"","",1)  
                 LET g_ltb[l_ac].* = g_ltb_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"      
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac     #FUN-D30033 Mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_ltb[l_ac].* = g_ltb_t.*
              #FUN-D30033--add--str--
              ELSE
                 CALL g_ltb.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end--  
              END IF
              CLOSE t552_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac     #FUN-D30033 Add
           CLOSE t552_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(ltb03) AND l_ac > 1 THEN
              LET g_ltb[l_ac].* = g_ltb[l_ac-1].*
              LET g_ltb[l_ac].ltb03 = g_rec_b + 1
              NEXT FIELD ltb03
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()       
 
        ON ACTION controlp
           CASE          
             WHEN INFIELD(ltb04) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azw" #No.FUN-A40015
               LET g_qryparam.default1 = g_ltb[l_ac].ltb04     
               CALL cl_create_qry() RETURNING g_ltb[l_ac].ltb04
               DISPLAY BY NAME g_ltb[l_ac].ltb04
               NEXT FIELD ltb04            
             WHEN INFIELD(ltb05) 
               CALL cl_init_qry_var()
                 IF NOT cl_null(g_ltb[l_ac].ltb04) THEN 
                    LET g_qryparam.form ="q_lml1"
                    LET g_qryparam.arg1 =g_ltb[l_ac].ltb04
                 ELSE
                 	  LET g_qryparam.form ="q_lml"
                 END IF                
               LET g_qryparam.default1 = g_ltb[l_ac].ltb05     
               CALL cl_create_qry() RETURNING g_ltb[l_ac].ltb05
               DISPLAY BY NAME g_ltb[l_ac].ltb05
               NEXT FIELD ltb05                
               OTHERWISE EXIT CASE
            END CASE
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()     
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controls                              
         CALL cl_set_head_visible("","AUTO")      
    END INPUT
  
    IF p_w = 'u' THEN 
       LET g_lta.ltamodu = g_user
       LET g_lta.ltadate = g_today
    ELSE
   	   LET g_lta.ltamodu = NULL
       LET g_lta.ltadate = NULL 
   	END IF     
    UPDATE lta_file SET ltamodu = g_lta.ltamodu,
                        ltadate = g_lta.ltadate
     WHERE lta01 = g_lta.lta01
       AND lta02=g_lta.lta02
    
    DISPLAY BY NAME g_lta.ltamodu,g_lta.ltadate
  
    CLOSE t552_bcl
    COMMIT WORK
    CALL t552_delall()
 
END FUNCTION

FUNCTION t552_check()
    DEFINE   l_n       LIKE type_file.num5
    DEFINE   l_n1      LIKE type_file.num5
    
    LET g_errno = " "        
    IF NOT cl_null(g_ltb[l_ac].ltb04) AND g_ltb[l_ac].ltb05 IS NOT NULL THEN 
       SELECT COUNT(*) INTO l_n FROM ltb_file 
        WHERE ltb01=g_lta.lta01 AND ltb02=g_lta.lta02
          AND ltb04=g_ltb[l_ac].ltb04
          AND ltb05=g_ltb[l_ac].ltb05
       IF l_n>0 THEN 
          LET g_errno='alm-835'
          RETURN 
       END IF     
       IF NOT cl_null(g_ltb[l_ac].ltb05) THEN                
          SELECT COUNT(*) INTO l_n1 FROM lml_file
           WHERE lml01=g_ltb[l_ac].ltb05
             AND lmlstore=g_ltb[l_ac].ltb04
          IF l_n1=0 THEN 
             LET g_errno='alm-837'
             RETURN 
          END IF   
       END IF     
    END IF 
    
END FUNCTION

FUNCTION t552_ltb04(p_cmd)
    DEFINE   p_cmd     LIKE type_file.chr1
    DEFINE   l_azp02   LIKE azp_file.azp02  #No.FUN-A40015
    DEFINE   l_rtz28   LIKE rtz_file.rtz28  #FUN-A80148
    
    LET g_errno = " "    
   #No.FUN-A40015 -BEGIN-----
   #SELECT rtz13,rtz28 INTO l_rtz13,l_rtz28 FROM rtz_file WHERE rtz01=g_ltb[l_ac].ltb04
   #CASE
   #   WHEN SQLCA.sqlcode=100   LET g_errno='anm-027'
   #                            LET l_rtz13=NULL
   #   WHEN l_rtz28 !='Y'       LET g_errno='9029'
   #   OTHERWISE
   #        LET g_errno=SQLCA.sqlcode USING '------'
   #END CASE
   #  
   #IF cl_null(g_errno) OR p_cmd ='d' THEN 
   #   LET g_ltb[l_ac].rtz13=l_rtz13
   #   DISPLAY BY NAME g_ltb[l_ac].rtz13
   #END IF
    SELECT azp02 INTO l_azp02 FROM azp_file,azw_file
     WHERE azp01=g_ltb[l_ac].ltb04
       AND azp01=azw01
    CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='anm-027'
                                LET l_azp02=NULL
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
    END CASE
    
    IF cl_null(g_errno) OR p_cmd ='d' THEN
       LET g_ltb[l_ac].azp02=l_azp02
       DISPLAY BY NAME g_ltb[l_ac].azp02
    END IF
   #No.FUN-A40015 -END-------
END FUNCTION 

FUNCTION t552_ltb05()
DEFINE l_lml02      LIKE lml_file.lml02
DEFINE l_lml06      LIKE lml_file.lml06

    LET g_errno = " " 
    SELECT lml02,lml06
      INTO l_lml02,l_lml06
      FROM lml_file 
     WHERE lml01=g_ltb[l_ac].ltb05
      
      CASE WHEN SQLCA.sqlcode=100 LET g_errno='anm-027'
                                  LET l_lml02=NULL 
           WHEN l_lml06='N'       LET g_errno='9028'
      OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
      END CASE 
                 
END FUNCTION 

FUNCTION t552_b1(p_w)
DEFINE   l_ad_t          LIKE type_file.num5               
DEFINE   l_n             LIKE type_file.num5    
DEFINE   l_n1            LIKE type_file.num5             
DEFINE   l_cnt           LIKE type_file.num5             
DEFINE   l_lock_sw       LIKE type_file.chr1            
DEFINE   p_cmd           LIKE type_file.chr1               
DEFINE   l_allow_insert  LIKE type_file.num5               
DEFINE   l_allow_delete  LIKE type_file.num5     
DEFINE  p_w              LIKE type_file.chr1
   
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_lta.lta01 IS NULL THEN
       CALL cl_err('',-400,1) 
       RETURN
    END IF

    #No.TQC-A60122  --Begin
    SELECT * INTO g_lta.* FROM lta_file
     WHERE lta01=g_lta.lta01 AND lta02=g_lta.lta02
    IF STATUS THEN RETURN END IF
    #No.TQC-A60122  --End  

    IF g_lta.lta03 = 'Y' THEN 
       CALL cl_err('','alm-097',1)
       RETURN
    END IF 
    IF g_lta.ltaacti='N' THEN 
       CALL cl_err(g_lta.lta01,'alm-147',1)
       RETURN 
    END IF   
 
    SELECT * INTO g_lta.* FROM lta_file
     WHERE lta01=g_lta.lta01 AND lta02=g_lta.lta02

   #No.FUN-A20034 -BEGIN-----
    CASE g_lta.lta02
       WHEN '1'
       WHEN '2'
       WHEN '3'
          LET g_lta02 = '0'
       WHEN '4'
          LET g_lta02 = '1'
       WHEN '5'
          LET g_lta02 = '2'
       WHEN '6'
          LET g_lta02 = '3'
    END CASE
   #No.FUN-A20034 -END-------

    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT ltc03,'' from ltc_file", 
                       " WHERE ltc01 =? and ltc02 =? and ltc03 = ?",
                       "  FOR UPDATE "
                         
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t552_bc2 CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_ltc WITHOUT DEFAULTS FROM s_ltc.*
          ATTRIBUTE(COUNT=g_rec_d,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_d != 0 THEN
              CALL fgl_set_arr_curr(l_ad)
           END IF
 
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ad = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN t552_cl USING g_lta.lta01,g_lta.lta02
           IF STATUS THEN
              CALL cl_err("OPEN t552_cl:", STATUS, 1)
              CLOSE t552_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t552_cl INTO g_lta.*           
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_lta.lta01,SQLCA.sqlcode,0)     
              CLOSE t552_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_d >= l_ad THEN
              LET p_cmd='u'
              LET g_ltc_t.* = g_ltc[l_ad].*  
              LET g_ltc_o.* = g_ltc[l_ad].* 
              OPEN t552_bc2 USING g_lta.lta01,g_lta.lta02,g_ltc_t.ltc03
              IF STATUS THEN
                 CALL cl_err("OPEN t552_bc2:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t552_bc2 INTO g_ltc[l_ad].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_ltc_t.ltc03,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 ELSE 
                	  CALL t552_ltc03('d')                    
                 END IF   
              END IF
              CALL cl_show_fld_cont()    
           END IF
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_ltc[l_ad].* TO NULL      
           LET g_ltc_t.* = g_ltc[l_ad].*       
           LET g_ltc_o.* = g_ltc[l_ad].*      
           CALL cl_show_fld_cont()        
           NEXT FIELD ltc03
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF          
           IF cl_null(g_ltc[l_ad].ltc03) THEN
              CALL cl_err('','alm-062',1)
              NEXT FIELD ltc03 
           END IF
          INSERT INTO ltc_file(ltc01,ltc02,ltc03)
          VALUES(g_lta.lta01,g_lta.lta02,g_ltc[l_ad].ltc03)
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","ltc_file",g_lta.lta01,g_ltc[l_ad].ltc03,SQLCA.sqlcode,"","",1)  
             CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_d=g_rec_d+1
              DISPLAY g_rec_d TO FORMONLY.cn3
           END IF      
          
        AFTER FIELD ltc03         
          IF NOT cl_null(g_ltc[l_ad].ltc03) THEN  
             IF p_cmd = 'a' OR (p_cmd = 'u' AND g_ltc[l_ad].ltc03 != g_ltc_t.ltc03) THEN             
                SELECT COUNT(*) INTO l_n FROM ltc_file 
                 WHERE ltc01=g_lta.lta01 AND ltc02=g_lta.lta02
                   AND ltc03=g_ltc[l_ad].ltc03
                IF l_n>0 THEN 
                   CALL cl_err('','-239',1)
                   LET g_ltc[l_ad].ltc03=g_ltc_t.ltc03
                   NEXT FIELD ltc03
                END IF 
                CALL t552_ltc03('a')
                IF NOT cl_null(g_errno) THEN 
                   CALL cl_err('',g_errno,1)
                   LET g_ltc[l_ad].ltc03=g_ltc_t.ltc03
                   NEXT FIELD ltc03
                END IF 
             END IF            
         END IF 
                           
        BEFORE DELETE                      #是否取消單身
           DISPLAY "BEFORE DELETE"
           IF g_ltc_t.ltc03 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM ltc_file
               WHERE ltc01 = g_lta.lta01
                 AND ltc03 = g_ltc_t.ltc03
                 AND ltc02 = g_lta.lta02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","ltc_file",g_lta.lta01,g_ltc_t.ltc03,SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_d=g_rec_d-1
              DISPLAY g_rec_d TO FORMONLY.cn3
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_ltc[l_ad].* = g_ltc_t.*
              CLOSE t552_bc2
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_ltc[l_ad].ltc03,-263,1)
              LET g_ltc[l_ad].* = g_ltc_t.*
           ELSE             
              UPDATE ltc_file SET ltc03=g_ltc[l_ad].ltc03
               WHERE ltc01 = g_lta.lta01
                 AND ltc03 = g_ltc_t.ltc03
                 AND ltc02 = g_lta.lta02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","ltc_file",g_lta.lta01,g_ltc_t.ltc03,SQLCA.sqlcode,"","",1)  
                 LET g_ltc[l_ad].* = g_ltc_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"      
           LET l_ad = ARR_CURR()
          #LET l_ad_t = l_ad     #FUN-D30033 Mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_ltc[l_ad].* = g_ltc_t.*
              #FUN-D30033--add--str--
              ELSE
                 CALL g_ltc.deleteElement(l_ad)
                 IF g_rec_d != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ad = l_ad_t
                 END IF
              #FUN-D30033--add--end--
              END IF
              CLOSE t552_bc2
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ad_t = l_ad     #FUN-D30033 Add
           CLOSE t552_bc2
           COMMIT WORK
  
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()       
 
        ON ACTION controlp
           CASE          
             WHEN INFIELD(ltc03) 
               CALL cl_init_qry_var()
              #No.FUN-A20034 -BEGIN-----
              #IF g_lta.lta02='1' THEN 
              #   LET g_qryparam.form ="q_lph1" 
              #ELSE
              #	  LET g_qryparam.form ="q_lpx"
              #END IF 
               CASE g_lta.lta02
                  WHEN '1'
                     LET g_qryparam.form = "q_lph1"
                  WHEN '2'
                     LET g_qryparam.form = "q_lpx"
                  WHEN '3'
                     LET g_qryparam.form = "q_lqg01"
                     LET g_qryparam.arg1 = g_lta02
                  WHEN '4'
                     LET g_qryparam.form = "q_lqg01"
                     LET g_qryparam.arg1 = g_lta02
                  WHEN '5'
                     LET g_qryparam.form = "q_lqg01"
                     LET g_qryparam.arg1 = g_lta02
                  WHEN '6'
                     LET g_qryparam.form = "q_lqg01"
                     LET g_qryparam.arg1 = g_lta02
               END CASE
              #No.FUN-A20034 -END-------
               LET g_qryparam.default1 = g_ltc[l_ad].ltc03     
               CALL cl_create_qry() RETURNING g_ltc[l_ad].ltc03
               DISPLAY BY NAME g_ltc[l_ad].ltc03
               NEXT FIELD ltc03                  
               OTHERWISE EXIT CASE
            END CASE
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()     
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controls                              
         CALL cl_set_head_visible("","AUTO")      
    END INPUT
  
    IF p_w = 'u' THEN 
       LET g_lta.ltamodu = g_user
       LET g_lta.ltadate = g_today
    ELSE
    	 LET g_lta.ltamodu = NULL
       LET g_lta.ltadate = NULL 
   	END IF     
    UPDATE lta_file SET ltamodu = g_lta.ltamodu,
                        ltadate = g_lta.ltadate
     WHERE lta01 = g_lta.lta01
       AND lta02=g_lta.lta02
    
    DISPLAY BY NAME g_lta.ltamodu,g_lta.ltadate
  
    CLOSE t552_bcl
    COMMIT WORK
    CALL t552_delall()
 
END FUNCTION

FUNCTION t552_ltc03(p_cmd)
DEFINE p_cmd       LIKE type_file.chr1
DEFINE l_lph02     LIKE lph_file.lph02
DEFINE l_lph24     LIKE lph_file.lph24
DEFINE l_lpx02     LIKE lpx_file.lpx02
DEFINE l_lpx15     LIKE lpx_file.lpx15
DEFINE l_lqg07     LIKE lqg_file.lqg07   #No.FUN-A20034
DEFINE l_lqgacti   LIKE lqg_file.lqgacti #No.FUN-A20034

    LET g_errno = " "    
   #No.FUN-A20034 -BEGIN-----
    CASE g_lta.lta02
       WHEN '1'
          SELECT lph02,lph24 INTO l_lph02,l_lph24
            FROM lph_file
           WHERE lph01=g_ltc[l_ad].ltc03
          CASE
             WHEN SQLCA.sqlcode=100   LET g_errno='anm-027'
                                      LET l_lph02=NULL
             WHEN l_lph24 !='Y'       LET g_errno='9029'
             OTHERWISE
                LET g_errno=SQLCA.sqlcode USING '------'
          END CASE
          IF cl_null(g_errno) THEN 
             LET g_ltc[l_ad].lph02=l_lph02
          END IF 
       WHEN '2'
          SELECT lpx02,lpx15 INTO l_lpx02,l_lpx15
            FROM lpx_file
           WHERE lpx01=g_ltc[l_ad].ltc03
          CASE
             WHEN SQLCA.sqlcode=100   LET g_errno='anm-027'
                                      LET l_lpx02=NULL
             WHEN l_lpx15 !='Y'       LET g_errno='9029'
             OTHERWISE
                LET g_errno=SQLCA.sqlcode USING '------'
          END CASE    	 
          IF cl_null(g_errno) THEN 
             LET g_ltc[l_ad].lph02=l_lpx02
          END IF
       OTHERWISE
          SELECT lqg07,lqgacti INTO l_lqg07,l_lqgacti
            FROM lqg_file
           WHERE lqg01 = g_ltc[l_ad].ltc03
             AND lqg02 = g_lta02
          CASE
             WHEN SQLCA.sqlcode=100   LET g_errno='anm-027'
             WHEN l_lqg07 != 'Y'      LET g_errno='9029'
             WHEN l_lqgacti = 'N'     LET g_errno='9028'
             OTHERWISE
                LET g_errno=SQLCA.sqlcode USING '------'
          END CASE
          IF cl_null(g_errno) THEN
             LET g_ltc[l_ad].lph02=l_lpx02
          END IF     
    END CASE
   #No.FUN-A20034 -END-------
    IF cl_null(g_errno) OR p_cmd ='d' THEN 
       DISPLAY BY NAME g_ltc[l_ad].lph02
    END IF

END FUNCTION

FUNCTION t552_delall()
DEFINE l_n    LIKE type_file.num5
DEFINE l_n1   LIKE type_file.num5 

   SELECT COUNT(*) INTO l_n FROM ltb_file
    WHERE ltb01 = g_lta.lta01
      AND ltb02 = g_lta.lta02
      AND ltb03 IS NOT NULL 
      
   SELECT COUNT(*) INTO l_n1 FROM ltc_file
    WHERE ltc01 = g_lta.lta01
      AND ltc02 = g_lta.lta02
      AND ltc03 IS NOT NULL       
      
   IF l_n = 0 AND l_n1=0 THEN                  
      CLEAR FORM  #No.TQC-A60122
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM lta_file 
            WHERE lta01 = g_lta.lta01
              AND lta02 = g_lta.lta02
   END IF
 
END FUNCTION
 
FUNCTION t552_b_fill(p_wc2)
DEFINE p_wc2     STRING
DEFINE  l_s      LIKE type_file.chr1000 
DEFINE  l_m      LIKE type_file.chr1000 
DEFINE  i        LIKE type_file.num5
    
    LET g_sql = "SELECT ltb03,ltb04,'',ltb05,ltb06,ltb07 from ltb_file",
                " WHERE ltb01 ='",g_lta.lta01,"' ",
                "   AND ltb02 ='",g_lta.lta02,"' "
     
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY ltb03 "  
   DISPLAY g_sql
   PREPARE t552_pb FROM g_sql
   DECLARE ltb_cs CURSOR FOR t552_pb
 
   CALL g_ltb.clear()
#   CALL g_ltc.clear()
   LET g_cnt = 1
 
   FOREACH ltb_cs INTO g_ltb[g_cnt].*  
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT azp02 INTO g_ltb[g_cnt].azp02 FROM azp_file
        WHERE azp01=g_ltb[g_cnt].ltb04
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_ltb.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION

FUNCTION t552_b1_fill(p_wc3)
DEFINE p_wc3     STRING
DEFINE  l_s      LIKE type_file.chr1000 
DEFINE  l_m      LIKE type_file.chr1000 
DEFINE  i        LIKE type_file.num5
    
    LET g_sql = "SELECT ltc03,'' from ltc_file",
                " WHERE ltc01 ='",g_lta.lta01,"' ",
                "   AND ltc02 ='",g_lta.lta02,"' "
     
   IF NOT cl_null(p_wc3) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc3 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY ltc03 "  
   DISPLAY g_sql
   PREPARE t552_pd FROM g_sql
   DECLARE ltc_cs CURSOR FOR t552_pd
 
#   CALL g_ltb.clear()
   CALL g_ltc.clear()
   LET g_cnt1 = 1
 
   FOREACH ltc_cs INTO g_ltc[g_cnt1].*   
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF g_lta.lta02='1' THEN 
          SELECT lph02 INTO g_ltc[g_cnt1].lph02 FROM lph_file
           WHERE lph01=g_ltc[g_cnt1].ltc03   
       ELSE 
          SELECT lpx02 INTO g_ltc[g_cnt1].lph02 FROM lpx_file
           WHERE lpx01=g_ltc[g_cnt1].ltc03          	
       END IF 
       LET g_cnt1 = g_cnt1 + 1
       IF g_cnt1 > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_ltc.deleteElement(g_cnt1)
 
   LET g_rec_d=g_cnt1-1
   DISPLAY g_rec_d TO FORMONLY.cn3
   LET g_cnt1 = 0
END FUNCTION
  
FUNCTION t552_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("lta01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t552_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1   
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("lta01",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION t552_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1   
 
     IF p_cmd = 'a' AND (NOT g_before_input_done) THEN                                                                                
      CALL cl_set_comp_entry("ltb03",TRUE)                                                                                          
     END IF   
 
END FUNCTION
 
FUNCTION t552_set_no_entry_b(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1   
 
   
   IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ltb03",FALSE)                                                                                         
   END IF  
   CALL cl_set_comp_entry("ltb06",FALSE)
END FUNCTION
  
FUNCTION t552_confirm()
  DEFINE l_lta04         LIKE lta_file.lta04    
  DEFINE l_lta05         LIKE lta_file.lta05
  DEFINE l_n             LIKE type_file.num5
  DEFINE l_n1            LIKE type_file.num5
  
   IF cl_null(g_lta.lta01) THEN         
      CALL cl_err('',-400,0)             
      RETURN                                   
   END IF                               
#CHI-C30107 --------- add ---------- begin 
   IF g_lta.lta03 = 'Y' THEN
      CALL cl_err(g_lta.lta01,'alm-005',1)
      RETURN
   END IF
   IF g_lta.ltaacti='N' THEN
      CALL cl_err(g_lta.lta01,'alm-147',1)
      RETURN
   END IF
   IF NOT cl_confirm("alm-006") THEN
       RETURN
   END IF
   SELECT * INTO g_lta.* FROM lta_file
    WHERE lta01 = g_lta.lta01
      AND lta02=g_lta.lta02
#CHI-C30107 --------- add ---------- end
   IF g_lta.lta03 = 'Y' THEN        
      CALL cl_err(g_lta.lta01,'alm-005',1)            
      RETURN                        
   END IF 
   IF g_lta.ltaacti='N' THEN 
      CALL cl_err(g_lta.lta01,'alm-147',1)
      RETURN 
   END IF   
   SELECT * INTO g_lta.* FROM lta_file                                                    
    WHERE lta01 = g_lta.lta01  
      AND lta02=g_lta.lta02                                                      
 
    LET l_lta04 = g_lta.lta04                                     
    LET l_lta05 = g_lta.lta05  

    SELECT COUNT(*) INTO l_n FROM ltb_file
     WHERE ltb01 = g_lta.lta01
       AND ltb02 = g_lta.lta02
       AND ltb03 IS NOT NULL 
       
    SELECT COUNT(*) INTO l_n1 FROM ltc_file
     WHERE ltc01 = g_lta.lta01
       AND ltc02 = g_lta.lta02
       AND ltc03 IS NOT NULL       
       
    IF l_n = 0 OR l_n1=0 THEN   
       CALL cl_err('','alm-841',1)
       RETURN 
    END IF  
    BEGIN WORK
    LET g_success='N'
    OPEN t552_cl USING g_lta.lta01,g_lta.lta02
    
    IF STATUS THEN 
       CALL cl_err("open t552_cl:",STATUS,1)
       CLOSE t552_cl
       ROLLBACK WORK 
       RETURN 
    END IF 
    FETCH t552_cl INTO g_lta.*
    IF SQLCA.sqlcode  THEN 
      CALL cl_err(g_lta.lta01,SQLCA.sqlcode,0)
      CLOSE t552_cl
      ROLLBACK WORK
      RETURN 
    END IF      
#CHI-C30107 ---------- mark ----------- begin                                                                                                               
#  IF NOT cl_confirm("alm-006") THEN                                                                                                
#      RETURN                                                                                                                       
#  ELSE                        
#CHI-C30107 ---------- mark ----------- end                                                                                                     
      LET g_lta.lta03 = 'Y'                                                                                                     
      LET g_lta.lta04 = g_user                                                                                                      
      LET g_lta.lta05 = g_today                                                                                                                                 
      UPDATE lta_file                                                                                                               
         SET lta03 = g_lta.lta03,                                                                                                   
             lta04 = g_lta.lta04,                                                                                                   
             lta05 = g_lta.lta05                                                                                              
       WHERE lta01 = g_lta.lta01
         AND lta02 = g_lta.lta02
       
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN                                                                                
         CALL cl_err('upd lta:',SQLCA.SQLCODE,0)                                                                                                                  
       ELSE                          
       	  LET g_success='Y'       
          DISPLAY BY NAME g_lta.lta03,g_lta.lta04,g_lta.lta05  
          CALL  t552_upd()                                  
       END IF                                                                        
# END IF    #CHI-C30107 mark
  IF g_success='N' THEN 
   #  CALL cl_err('','alm-h01',1)  #TQC-A60047 add    #TQC-A60065  MARK
     ROLLBACK WORK
     LET g_lta.lta03 = "N"                                                                                                      
     LET g_lta.lta04 = l_lta04                                                                                                  
     LET g_lta.lta05 = l_lta05                                                                                              
     DISPLAY BY NAME g_lta.lta03,g_lta.lta04,g_lta.lta05        
     RETURN 
  ELSE
  	 COMMIT WORK
  END IF 
  
  CLOSE t552_cl
  CALL t552_pic()   #No.MOD-A70071
                     
END FUNCTION 

FUNCTION t552_upd()
  DEFINE i               LIKE type_file.num5
  DEFINE j               LIKE type_file.num5
  DEFINE l_n             LIKE type_file.num5
  DEFINE l_lpxpos        LIKE lpx_file.lpxpos #NO.FUN-B40071
  DEFINE l_lpjpos        LIKE lpj_file.lpjpos #No.FUN-B60118
  DEFINE l_lph01         LIKE lph_file.lph01  #FUN-BB0054 add
  DEFINE l_lphpos        LIKE lph_file.lphpos #FUN-BB0054 add
  DEFINE l_sql           STRING               #FUN-BB0054 add
  
  FOR i=1 TO g_rec_b
      FOR j=1 TO g_rec_d
          IF g_ltb[i].ltb06='1' THEN 
             SELECT COUNT(*) INTO l_n FROM lnk_file 
              WHERE lnk01=g_ltc[j].ltc03
          	    AND lnk02=g_lta.lta02
          	    AND lnk03=g_ltb[i].ltb04
          	    AND lnk04=g_ltb[i].ltb05
          	 IF l_n=0 THEN    
                INSERT INTO lnk_file
                VALUES (g_ltc[j].ltc03,g_lta.lta02,g_ltb[i].ltb04,g_ltb[i].ltb05,g_ltb[i].ltb07)
                IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN                                                                                
                   CALL cl_err('ins lnk:',SQLCA.SQLCODE,0)    
                   LET g_success='N'
                   EXIT FOR 
                END IF     
             ELSE 
             	  CONTINUE FOR    
             END IF      
          ELSE
             SELECT COUNT(*) INTO l_n FROM lnk_file 
              WHERE lnk01=g_ltc[j].ltc03
          	    AND lnk02=g_lta.lta02
          	    AND lnk03=g_ltb[i].ltb04
          	    AND lnk04=g_ltb[i].ltb05
          	 IF l_n>0 THEN              	
          	    UPDATE lnk_file 
          	       SET lnk05=g_ltb[i].ltb07
          	     WHERE lnk01=g_ltc[j].ltc03
          	       AND lnk02=g_lta.lta02
          	       AND lnk03=g_ltb[i].ltb04
          	       AND lnk04=g_ltb[i].ltb05
                IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN                                                                                
                   CALL cl_err('upd lnk:',SQLCA.SQLCODE,0)    
                   LET g_success='N'
                   EXIT FOR 
                END IF   
             ELSE 
             	  CONTINUE FOR 
             END IF
          END IF 
      END FOR 
  END FOR 

#TQC-A60065 --mark
 #No.FUN-A50056 -BEGIN-----
#  IF g_success = 'Y' THEN
#     IF g_lta.lta02 = '1' THEN
#        UPDATE lpj_file SET lpjpos = 'N' 
#         WHERE lpj02 IN (SELECT DISTINCT ltc03 FROM ltc_file 
#                          WHERE ltc01 = g_lta.lta01  
#                            AND ltc02 = g_lta.lta02 ) 
#        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN      
#           CALL cl_err('upd lpj:',SQLCA.SQLCODE,0)        
#           LET g_success='N'
#           RETURN  
#        END IF   
#      ELSE                        
#        UPDATE lpx_file SET lpxpos = 'N' 
#         WHERE lpx01 IN (SELECT DISTINCT ltc03 FROM ltc_file 
#                          WHERE ltc01 = g_lta.lta01  
#                            AND ltc02 = g_lta.lta02 ) 
#        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN      
#           CALL cl_err('upd lpx:',SQLCA.SQLCODE,0)    
#           LET g_success='N'
#           RETURN  
#        END IF   
#     END IF
#  END IF
# #No.FUN-A50056 -END-------#TQC-A60065 --end
#TQC-A60065 --begin
  IF g_success = 'Y' THEN
     IF g_lta.lta02 = '1' THEN
        LET g_cnt = 0
#FUN-BB0054 add START
        LET l_sql = " SELECT lph01, lphpos ",
                    " FROM lph_file ",
                    " WHERE lph01 IN ( SELECT DISTINCT ltc03  FROM ltc_file ",
                    "                  WHERE ltc01 = '",g_lta.lta01,"'" ,
                    "                    AND ltc02 = '",g_lta.lta02,"' )"
        PREPARE t552_lphpre FROM l_sql
        DECLARE t552_lphcs CURSOR FOR t552_lphpre
        FOREACH t552_lphcs INTO l_lph01,l_lphpos
           IF l_lphpos <> "1" THEN
              LET l_lphpos = "2"
           ELSE
              LET l_lphpos = "1"
           END IF
           UPDATE lph_file SET lphpos = l_lphpos,
                               lphmodu = g_user,
                               lphdate = g_today
                               WHERE lph01 = l_lph01
           IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
              CALL cl_err('upd lph:',SQLCA.SQLCODE,0)
              LET g_success='N'
              RETURN
           END IF
        END FOREACH
#FUN-BB0054 add END
        SELECT COUNT(*) INTO g_cnt FROM lpj_file
         WHERE lpj02 IN (SELECT DISTINCT ltc03 FROM ltc_file
                          WHERE ltc01 = g_lta.lta01
                            AND ltc02 = g_lta.lta02 )
        IF g_cnt > 0 THEN
#FUN-B60118 ---------------str--------------
        SELECT lpjpos INTO l_lpjpos FROM lpj_file
         WHERE lpj02 IN (SELECT DISTINCT ltc03 FROM ltc_file
                          WHERE ltc01 = g_lta.lta01
                            AND ltc02 = g_lta.lta02 )
        IF l_lpjpos <> '1' THEN
           LET l_lpjpos = '2'
        ELSE
           LET l_lpjpos = '1'
        END IF
           UPDATE lpj_file SET lpjpos = l_lpjpos
#FUN-B60118 --------------end--------------
#          UPDATE lpj_file SET lpjpos = 'N'         #FUN-B60118    mark
            WHERE lpj02 IN (SELECT DISTINCT ltc03 FROM ltc_file
                             WHERE ltc01 = g_lta.lta01
                               AND ltc02 = g_lta.lta02 )
           IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
              CALL cl_err('upd lpj:',SQLCA.SQLCODE,0)
              LET g_success='N'
              RETURN
           END IF
        END IF
     END IF
     IF g_lta.lta02 = '2' THEN
       #FUN-B40071 --START--
        #UPDATE lpx_file SET lpxpos = 'N'
        # WHERE lpx01 IN (SELECT DISTINCT ltc03 FROM ltc_file
        #                  WHERE ltc01 = g_lta.lta01
        #                    AND ltc02 = g_lta.lta02 )
        SELECT lpxpos INTO l_lpxpos FROM lpx_file
         WHERE lpx01 IN (SELECT DISTINCT ltc03 FROM ltc_file
                          WHERE ltc01 = g_lta.lta01
                            AND ltc02 = g_lta.lta02 )
        IF l_lpxpos <> '1' THEN
           LET l_lpxpos = '2'
        ELSE
           LET l_lpxpos = '1'
        END IF
        UPDATE lpx_file SET lpxpos = l_lpxpos
         WHERE lpx01 IN (SELECT DISTINCT ltc03 FROM ltc_file
                          WHERE ltc01 = g_lta.lta01
                            AND ltc02 = g_lta.lta02 )
       #FUN-B40071 --END--
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
           CALL cl_err('upd lpx:',SQLCA.SQLCODE,0)
           LET g_success='N'
           RETURN
        END IF
     END IF
  END IF
#TQC-A60065 --end
END FUNCTION  

FUNCTION t552_pic()
   CASE g_lta.lta03
      WHEN 'Y'  LET g_confirm = 'Y'
                LET g_void = ''
      WHEN 'N'  LET g_confirm = 'N'
                LET g_void = ''
      OTHERWISE LET g_confirm = 'N'
                LET g_void = ''
   END CASE
 
   CALL cl_set_field_pic(g_confirm,"","","",g_void,g_lta.ltaacti)
END FUNCTION
#FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore 
