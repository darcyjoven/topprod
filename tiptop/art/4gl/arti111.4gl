# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: arti111.4gl
# Descriptions...: 商品條碼維護作業 
# Date & Author..: No.FUN-870100 09/06/10 By lala
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-A30030 10/03/15 By Cockroach err_msg:aim-944-->art-648
# Modify.........: No:FUN-A30116 10/05/12 By Cockroach rta03 開窗q_smc-->q_smd1
# Modify.........: No:FUN-A30116 10/06/10 By Cockroach 複製功能意義不大,暫時關閉此功能 
# Modify.........: No:FUN-A50011 10/06/18 By yangfeng   增加商品條碼整批生成/刪除的功能
# Modify.........: No:FUN-A50011 10/06/25 By yangfeng   在行業別為SLK的情況下，給單身增加多個欄位
# Modify.........: No.FUN-A90048 10/09/27 By huangtao 修改料號欄位控管以及開窗
# Modify.........: No.FUN-AA0059 10/10/25 By chenying 料號開窗控管 
# Modify.........: No.TQC-AC0269 10/12/18 By chenmoyan MARK服飾版所加內容
# Modify.........: No.TQC-AC0279 10/12/20 By suncx 單位編號管控BUG修改    
# Modify.........: No.MOD-AC0181 10/12/30 By huangtao 修改單位開窗
# Modify.........: No.MOD-B30327 11/03/15 By wangxin 修改單身資料后更新已傳POS否為N
# Modify.........: No:FUN-B40071 11/04/29 by jason 已傳POS否狀態調整
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-B90102 11/09/21 By qiaozy  服飾版 增加商品條碼整批生成/刪除的功能
# Modify.........: No.FUN-B90049 12/02/01 By nanbing 取消rtapos
# Modify.........: No.FUN-C20022 12/02/09 By pauline 修改時先將POS狀態更新為4,修改確認完成後才更新回'2'
# Modify.........: No.FUN-C60024 12/06/12 By POS邏輯調整，修改為關聯價格策略
# Modify.........: No.FUN-C60088 12/06/25 By qiaozy 修改agd03_a,agd03_b的賦值
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30033 13/04/10 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:FUN-D40001 13/04/17 By xumm 条码逻辑调整
# Modify.........: No:TQC-D40044 13/04/19 By dongsz 維護單位時，檢查是否存在庫存單位轉化率，存在時才能維護

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
   g_rta01        LIKE rta_file.rta01,
   g_rta02        LIKE rta_file.rta02,
   g_rta01_t      LIKE rta_file.rta01,
   g_ima1008      LIKE ima_file.ima1008,
   g_ima02        LIKE ima_file.ima02,
   g_ima1009      LIKE ima_file.ima1009,
   g_ima1004      LIKE ima_file.ima1004,
   g_ima1007      LIKE ima_file.ima1007,
   g_ima1005      LIKE ima_file.ima1005,
   g_ima1006      LIKE ima_file.ima1006,
#No.FUN-A50011 ----begin-----
   g_rta          DYNAMIC ARRAY OF RECORD
      rta02          LIKE rta_file.rta02,
#TQC-AC0269 --Begin
#     rta06          LIKE rta_file.rta06,
#     rta07          LIKE rta_file.rta07,
#     rta08          LIKE rta_file.rta08,
#     rta09          LIKE rta_file.rta09,
#     rta10          LIKE rta_file.rta10, 
#     rta11          LIKE rta_file.rta11,
#     agd03_a        LIKE agd_file.agd03,
#     agd03_b        LIKE agd_file.agd03, 
#TQC-AC0269 --End
#FUN-B90102----ADD---BEGIN -
      rta06          LIKE rta_file.rta06,
      rta07          LIKE rta_file.rta07,
      rta08          LIKE rta_file.rta08,
      rta09          LIKE rta_file.rta09,
      rta10          LIKE rta_file.rta10, 
      rta11          LIKE rta_file.rta11,
      agd03_a        LIKE agd_file.agd03,
      agd03_b        LIKE agd_file.agd03,
#FUN-B90102----ADD---end--- -
      rta03          LIKE rta_file.rta03,
      rta03_desc     LIKE type_file.chr1000,
      rta04          LIKE rta_file.rta04,
      rta05          LIKE rta_file.rta05,
      rtaacti        LIKE rta_file.rtaacti,
#     rtapos         LIKE rta_file.rtapos             #FUN-B90049 mark
#TQC-AC0269 --Begin
#     rtaud01        LIKE rta_file.rtaud01,
#     rtaud02        LIKE rta_file.rtaud02,
#     rtaud03        LIKE rta_file.rtaud03,
#     rtaud04        LIKE rta_file.rtaud04,
#     rtaud05        LIKE rta_file.rtaud05,
#     rtaud06        LIKE rta_file.rtaud06,
#     rtaud07        LIKE rta_file.rtaud07,
#     rtaud08        LIKE rta_file.rtaud08,
#     rtaud09        LIKE rta_file.rtaud09,
#     rtaud10        LIKE rta_file.rtaud10
#TQC-AC0269 --End
#FUN-B90102 --Begin
      rtaud01        LIKE rta_file.rtaud01,
      rtaud02        LIKE rta_file.rtaud02,
      rtaud03        LIKE rta_file.rtaud03,
      rtaud04        LIKE rta_file.rtaud04,
      rtaud05        LIKE rta_file.rtaud05,
      rtaud06        LIKE rta_file.rtaud06,
      rtaud07        LIKE rta_file.rtaud07,
      rtaud08        LIKE rta_file.rtaud08,
      rtaud09        LIKE rta_file.rtaud09,
      rtaud10        LIKE rta_file.rtaud10
#FUN-B90102 --End
                  END RECORD,
   g_rta_t        RECORD
      rta02          LIKE rta_file.rta02,
#TQC-AC0269 --Begin
#     rta06          LIKE rta_file.rta06,
#     rta07          LIKE rta_file.rta07,
#     rta08          LIKE rta_file.rta08,
#     rta09          LIKE rta_file.rta09,
#     rta10          LIKE rta_file.rta10, 
#     rta11          LIKE rta_file.rta11,
#     agd03_a        LIKE agd_file.agd03,
#     agd03_b        LIKE agd_file.agd03, 
#TQC-AC0269 --End
#FUN-B90102----ADD---BEGIN -
      rta06          LIKE rta_file.rta06,
      rta07          LIKE rta_file.rta07,
      rta08          LIKE rta_file.rta08,
      rta09          LIKE rta_file.rta09,
      rta10          LIKE rta_file.rta10, 
      rta11          LIKE rta_file.rta11,
      agd03_a        LIKE agd_file.agd03,
      agd03_b        LIKE agd_file.agd03,
#FUN-B90102----ADD---BEGIN 
      rta03          LIKE rta_file.rta03,
      rta03_desc     LIKE type_file.chr1000,
      rta04          LIKE rta_file.rta04,
      rta05          LIKE rta_file.rta05,
      rtaacti        LIKE rta_file.rtaacti,
#     rtapos         LIKE rta_file.rtapos             #FUN-B90049 mark
#TQC-AC0269 --Begin
#     rtaud01        LIKE rta_file.rtaud01,
#     rtaud02        LIKE rta_file.rtaud02,
#     rtaud03        LIKE rta_file.rtaud03,
#     rtaud04        LIKE rta_file.rtaud04,
#     rtaud05        LIKE rta_file.rtaud05,
#     rtaud06        LIKE rta_file.rtaud06,
#     rtaud07        LIKE rta_file.rtaud07,
#     rtaud08        LIKE rta_file.rtaud08,
#     rtaud09        LIKE rta_file.rtaud09,
#     rtaud10        LIKE rta_file.rtaud10
#TQC-AC0269 --End
#FUN-B90102 --Begin
      rtaud01        LIKE rta_file.rtaud01,
      rtaud02        LIKE rta_file.rtaud02,
      rtaud03        LIKE rta_file.rtaud03,
      rtaud04        LIKE rta_file.rtaud04,
      rtaud05        LIKE rta_file.rtaud05,
      rtaud06        LIKE rta_file.rtaud06,
      rtaud07        LIKE rta_file.rtaud07,
      rtaud08        LIKE rta_file.rtaud08,
      rtaud09        LIKE rta_file.rtaud09,
      rtaud10        LIKE rta_file.rtaud10
#FUN-B90102 --End
                  END RECORD,
#No.FUN-A50011 ----end------
   g_name         LIKE type_file.chr20,
   g_wc,g_sql     STRING,
   g_ss           LIKE type_file.chr1,
   l_ac           LIKE type_file.num5,
   g_argv1        LIKE rta_file.rta01,
   g_rec_b        LIKE type_file.num5,
   g_cn2          LIKE type_file.num5
DEFINE g_forupd_sql        STRING            #SELECT ... FOR UPDATE  SQL
DEFINE g_chr               LIKE rta_file.rta01
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_no_ask            LIKE type_file.num5          
DEFINE g_jump              LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_curs_index        LIKE type_file.num10
#FUN-C60024--start add-------------------------
##FUN-C20022 add START
#DEFINE g_rtepos  DYNAMIC ARRAY OF RECORD
#           rte01           LIKE rte_file.rte01,
#           rtepos          LIKE rte_file.rtepos
#                 END RECORD
#DEFINE g_rtepos_num        LIKE type_file.num5
#DEFINE g_posflag           LIKE type_file.chr1
##FUN-C20022 add END 
#FUN-C60024--end add--------------------------

#FUN-C60024--start add------------------------
DEFINE g_rtgpos         DYNAMIC ARRAY OF RECORD
          rtg01            LIKE rtg_file.rtg01,
          rtgpos           LIKE rtg_file.rtgpos  
                        END RECORD
DEFINE g_rtgpos_num        LIKE type_file.num5 
#FUN-C60024--end add--------------------------

MAIN
   DEFINE p_row,p_col      LIKE type_file.num5
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1)
      RETURNING g_time
   LET g_argv1 = ARG_VAL(1)
   LET g_rta01 = NULL
   LET g_rta01_t = NULL
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW i111_w AT p_row,p_col WITH FORM "art/42f/arti111"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   #FUN-870100---start
#FUN-B90049 ---------------mark
#   IF g_aza.aza88 = 'N' THEN
#     CALL cl_set_comp_visible('rtapos',FALSE)
#  END IF
#FUN-B90049 ---------------mark
   #FUN-870100---end
#TQC-AC0269 --Begin
#  #No.FUN-A50011 ------begin----- 
#  CALL cl_set_comp_visible("rta06,rta07,rta08,rta09,rta10,rta11,agd03_a,agd03_b,rtaud01,rtaud02,
#                            rtaud03,rtaud04,rtaud05,rtaud06,rtaud07,rtaud08,rtaud09,rtaud10",FALSE)                     
#  IF s_industry('slk') THEN
#     CALL cl_set_comp_visible("rta06,rta07,rta08,rta09,rta10,rta11,agd03_a,agd03_b,rtaud01,rtaud02,
#                               rtaud03,rtaud04,rtaud05,rtaud06,rtaud07,rtaud08,rtaud09,rtaud10",TRUE)           
#  END IF 
#  #No.FUN-A50011 ------end-------
#TQC-AC0269 --End

#FUN-B90102 --add---Begin-------
  CALL cl_set_comp_visible("rta06,rta07,rta08,rta09,rta10,rta11,agd03_a,agd03_b,rtaud01,rtaud02,
                            rtaud03,rtaud04,rtaud05,rtaud06,rtaud07,rtaud08,rtaud09,rtaud10",FALSE)                     
  IF s_industry('slk') THEN
     CALL cl_set_comp_visible("rta06,rta07,rta08,rta09,rta10,rta11,agd03_a,agd03_b
                               ",TRUE)           
  END IF 
#FUN-B90102 --add---End----

   CALL cl_ui_init()

#No.FUN-B90102--add---begin--
   CALL cl_set_act_visible("generate_codebar,delete_codebar",FALSE)
   IF s_industry("slk") THEN
      CALL cl_set_act_visible("generate_codebar,delete_codebar",TRUE)
   END IF
#No.FUN-B90102--add---end----
 
   IF NOT cl_null(g_argv1) THEN CALL i111_q() END IF
 
   CALL i111_menu()
 
   CLOSE WINDOW i111_w
   CALL cl_used(g_prog,g_time,2)
      RETURNING g_time
 
END MAIN
 
FUNCTION i111_curs()
DEFINE  l_rtz02        LIKE rtz_file.rtz02
DEFINE  l_rtz04        LIKE rtz_file.rtz04
#DEFINE  l_ima151       LIKE ima_file.ima151             #No.FUN-A50011 #TQC-AC0269
DEFINE  l_ima151       LIKE ima_file.ima151              #FUN-B90102---ADD--
 
   IF cl_null(g_argv1) THEN
      CLEAR FORM
      CALL g_rta.clear()
      CALL cl_set_head_visible("","YES")
      INITIALIZE g_rta01 TO NULL
#No.FUN-A50011 ------begin-----
      CONSTRUCT g_wc ON rta01,rta02,
#                       rta06,rta07,rta08,rta09,rta10,rta11,        #TQC-AC0269
                        rta06,rta07,rta08,rta09,rta10,rta11,        #FUN-B90102---ADD--
#                       rta03,rta04,rta05,rtaacti,rtapos,           #FUN-B90049 mark
                        rta03,rta04,rta05,rtaacti,                  #FUN-B90049
#                       rtaud01,rtaud02,rtaud03,rtaud04,rtaud05,    #TQC-AC0269 
#                       rtaud06,rtaud07,rtaud08,rtaud09,rtaud10     #TQC-AC0269
                        rtaud01,rtaud02,rtaud03,rtaud04,rtaud05,    #FUN-B90102---ADD-- 
                        rtaud06,rtaud07,rtaud08,rtaud09,rtaud10     #FUN-B90102---ADD--
           FROM rta01,s_rta[1].rta02,
#             s_rta[1].rta06,s_rta[1].rta07,s_rta[1].rta08,s_rta[1].rta09,        #TQC-AC0269
#             s_rta[1].rta10,s_rta[1].rta11,                                      #TQC-AC0269
              s_rta[1].rta06,s_rta[1].rta07,s_rta[1].rta08,s_rta[1].rta09,  #FUN-B90102---ADD--
              s_rta[1].rta10,s_rta[1].rta11,                                #FUN-B90102---ADD--
              s_rta[1].rta03,s_rta[1].rta04,
#             s_rta[1].rta05,s_rta[1].rtaacti,s_rta[1].rtapos,       #FUN-B90049 mark
              s_rta[1].rta05,s_rta[1].rtaacti,                      #FUN-B90049 add
#TQC-AC0269 --Begin
#             s_rta[1].rtaud01,s_rta[1].rtaud02,s_rta[1].rtaud03,s_rta[1].rtaud04,  
#             s_rta[1].rtaud05,s_rta[1].rtaud06,s_rta[1].rtaud07,s_rta[1].rtaud08,    
#             s_rta[1].rtaud09,s_rta[1].rtaud10                                      
#TQC-AC0269 --End
              s_rta[1].rtaud01,s_rta[1].rtaud02,s_rta[1].rtaud03,s_rta[1].rtaud04,#FUN-B90102---ADD--
              s_rta[1].rtaud05,s_rta[1].rtaud06,s_rta[1].rtaud07,s_rta[1].rtaud08,#FUN-B90102---ADD--
              s_rta[1].rtaud09,s_rta[1].rtaud10                                   #FUN-B90102---ADD--
#No.FUN-A50011 ------end-------
         
         BEFORE CONSTRUCT
#FUN-B90102---ADD--BEGIN--
            IF s_industry('slk') THEN
               CALL cl_set_comp_visible("agd03_a,agd03_b",TRUE)
            END IF
#FUN-B90102---ADD--END---
            
            CALL cl_qbe_init()
#TQC-AC0269 --Begin
#IF s_industry('slk') THEN
#            CALL cl_set_comp_visible("agd03_a,agd03_b",TRUE)     #No.FUN-A50011 
#END IF
#TQC-AC0269 --End


         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION controlp
            CASE 
               WHEN INFIELD(rta01) 
                     CALL cl_init_qry_var()                                                                                         
                     LET g_qryparam.form = "q_rta"                                                                                  
                     LET g_qryparam.state = "c"                                                                                     
                     CALL cl_create_qry() RETURNING g_qryparam.multiret 
                     DISPLAY g_qryparam.multiret TO rta01
               WHEN INFIELD(rta03)                                                                                               
                     CALL cl_init_qry_var()                                                                                         
                     LET g_qryparam.form = "q_rta03"                                                                                  
                     LET g_qryparam.state = "c"                                                                                     
                     CALL cl_create_qry() RETURNING g_qryparam.multiret                                                             
                     DISPLAY g_qryparam.multiret TO s_rta[1].rta03                                                                                                                                                            
#TQC-AC0269 --Begin
#No.FUN-A50011 ----begin-----
#              WHEN INFIELD(rta11)     
#                    CALL cl_init_qry_var()                                                                                         
#                    LET g_qryparam.form = "q_pmc01"                                                                                  
#                    LET g_qryparam.state = "c"                                                                                     
#                    CALL cl_create_qry() RETURNING g_qryparam.multiret                                                             
#                    DISPLAY g_qryparam.multiret TO rta11                                                                                                                                                            
#                    NEXT FIELD rta11
#No.FUN-A50011 ----end-----
#No.TQC-AC0269 --End

#No.FUN-B90102 ----begin-----
               WHEN INFIELD(rta11)     
                    CALL cl_init_qry_var()                                                                                         
                    LET g_qryparam.form = "q_pmc01"                                                                                  
                    LET g_qryparam.state = "c"                                                                                     
                    CALL cl_create_qry() RETURNING g_qryparam.multiret                                                             
                    DISPLAY g_qryparam.multiret TO rta11                                                                                                                                                            
                    NEXT FIELD rta11
#No.FUN-B90102 ----end-----
               OTHERWISE                                                                                                          
                     EXIT CASE                                                                                                      
            END CASE
#TQC-AC0269 --Begin
##No.FUN-A50011  -----begin---
#      AFTER CONSTRUCT
#IF s_industry("slk") THEN
#      LET g_rta01 = GET_FLDBUF(rta01)
#      SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01 = g_rta01
#      IF l_ima151 = 'Y' THEN
#         CALL cl_set_comp_visible("agd03_a,agd03_b",FALSE)
#      ELSE
#         CALL cl_set_comp_visible("agd03_a,agd03_b",TRUE) 
#      END IF
#END IF
#No.FUN-A50011  -----end---  
#TQC-AC0269 --End

##No.FUN-B90102  -----begin---
      AFTER CONSTRUCT
         IF s_industry("slk") THEN
            LET g_rta01 = GET_FLDBUF(rta01)
            SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01 = g_rta01
            IF l_ima151 = 'Y' THEN
               CALL cl_set_comp_visible("agd03_a,agd03_b",FALSE)
            ELSE
               CALL cl_set_comp_visible("agd03_a,agd03_b",TRUE) 
            END IF
         END IF
#No.FUN-B90102  -----end--- 
            
         ON ACTION about
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
 
         ON ACTION controlg
            CALL cl_cmdask()
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
      IF INT_FLAG THEN
         RETURN
      END IF
   ELSE
      LET g_wc=" rta01='",g_argv1,"'"
   END IF

   SELECT rtz02,rtz04 INTO l_rtz02,l_rtz04 FROM rtz_file WHERE rtz01 = g_plant
 
   IF NOT cl_null(l_rtz04) THEN
      LET g_sql= "SELECT UNIQUE rta01 FROM rta_file ",                                                                              
                 " WHERE ", g_wc CLIPPED,
                 " AND rta01 IN (SELECT rte03 FROM rte_file ",
                 " WHERE rte01 = '",l_rtz04,"')"
   ELSE
      LET g_sql= "SELECT UNIQUE rta01 FROM rta_file ",                                                                              
                " WHERE ", g_wc CLIPPED
   END IF 
   PREPARE i111_prepare FROM g_sql
   DECLARE i111_b_curs
      SCROLL CURSOR WITH HOLD FOR i111_prepare
   IF NOT cl_null(l_rtz04) THEN
      LET g_sql = "SELECT COUNT(DISTINCT rta01) FROM rta_file ",
                  " WHERE ",g_wc CLIPPED,
                  " AND rta01 IN (SELECT rte03 FROM rte_file ",
                  " WHERE rte01 = '",l_rtz04,"')"
   ELSE 
      LET g_sql = "SELECT COUNT(DISTINCT rta01) FROM rta_file ",
                  " WHERE ",g_wc CLIPPED
   END IF 
   PREPARE i111_precount FROM g_sql
   DECLARE i111_count CURSOR FOR i111_precount
 
END FUNCTION
 
FUNCTION i111_menu()
   DEFINE l_cmd   LIKE type_file.chr1000
 
   WHILE TRUE
      CALL i111_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i111_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i111_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i111_r()
            END IF
         #WHEN "modify"
         #   IF cl_chk_act_auth() THEN
         #      CALL i111_u()
         #   END IF
       # WHEN "reproduce"   #FUN-A30116 mark
       #    IF cl_chk_act_auth() THEN
       #       CALL i111_copy()
       #    END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i111_out()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i111_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#TQC-AC0269 --Begin
#No.FUN-A50011 -----begin-----
#        WHEN "generate_codebar"
#           IF cl_chk_act_auth() THEN
#              CALL i111_generate_codebar()
#           END IF
#        WHEN "delete_codebar"
#           IF cl_chk_act_auth() THEN
#              CALL i111_delete_codebar()
#           END IF
#No.FUN-A50011 -----end-----
#TQC-AC0269 --End
         WHEN "related_document"
            IF cl_chk_act_auth() THEN
               IF g_rta01 IS NOT NULL THEN
                  LET g_doc.column1 = "rta01"
                  LET g_doc.value1 = g_rta01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rta),'','')
            END IF
#No.FUN-B90102 -----begin-----
        WHEN "generate_codebar"
           IF cl_chk_act_auth() THEN
              CALL i111_generate_codebar()
           END IF
        WHEN "delete_codebar"
           IF cl_chk_act_auth() THEN
              CALL i111_delete_codebar()
           END IF
#No.FUN-B90102 -----end----- 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i111_a()
   MESSAGE ""
   CLEAR FORM
   CALL g_rta.clear()
   INITIALIZE g_rta01 LIKE rta_file.rta01
   LET g_rta01_t = NULL
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL i111_i("a")
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b=0
      CALL g_rta.clear()
  {    IF g_ss='Y' THEN
         CALL i111_b_fill('1=1')
      ELSE
         CALL g_rta.clear()
      END IF
} 
      CALL i111_b()
      LET g_rta01_t = g_rta01
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION i111_u()
   IF g_rta01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_rta01_t = g_rta01
   WHILE TRUE
      CALL i111_i("u")
      IF INT_FLAG THEN
         LET g_rta01=g_rta01_t
         DISPLAY g_rta01 TO rta01
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION i111_i(p_cmd)
   DEFINE p_cmd           LIKE type_file.chr1
 
   LET g_ss='Y'
   CALL cl_set_head_visible("","YES")
 
   INPUT g_rta01 WITHOUT DEFAULTS FROM rta01
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i111_set_entry(p_cmd)
         CALL i111_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
#TQC-AC0269 --Begin
#IF s_industry('slk') THEN
#         CALL cl_set_comp_visible("agd03_a,agd03_b",TRUE)       #No.FUN-A50011
#END IF
#TQC-AC0269 --End

#FUN-B90102 --Begin
         IF s_industry('slk') THEN
            CALL cl_set_comp_visible("agd03_a,agd03_b",TRUE)
         END IF
#FUN-B90102 --End
         NEXT FIELD rta01
 
      AFTER FIELD rta01
         IF NOT cl_null(g_rta01) THEN
#NO.FUN-A90048 add -----------start--------------------     
          IF NOT s_chk_item_no(g_rta01,'') THEN
             CALL cl_err('',g_errno,1)
             LET g_rta01= g_rta01_t 
             NEXT FIELD rta01
          END IF
#NO.FUN-A90048 add ------------end --------------------    
            IF g_rta01 != g_rta01_t OR g_rta01_t IS NULL THEN
               SELECT UNIQUE rta01 INTO g_chr
                  FROM rta_file
                  WHERE rta01=g_rta01
               IF SQLCA.sqlcode THEN
                  IF p_cmd='a' THEN
                     LET g_ss='N'
                  END IF
               ELSE
                  IF p_cmd='u' THEN
                     CALL cl_err(g_rta01,-239,0)
                     LET g_rta01=g_rta01_t
                     NEXT FIELD rta01
                  END IF
               END IF
               CALL i111_rta01(g_rta01)
               IF NOT cl_null(g_errno)  THEN      
                 CALL cl_err('',g_errno,0)                                                                                          
                 NEXT FIELD rta01                                                                                                   
               END IF 
            END IF
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(rta01)
       #No.FUN-A90048 ------------start----------------------     
       #        CALL cl_init_qry_var()
       #        LET g_qryparam.form = "q_ima"
       #        LET g_qryparam.default1 = g_rta01
       #        CALL cl_create_qry() RETURNING g_rta01
                CALL q_sel_ima( FALSE, "q_ima","",g_rta01,"","","","","",'') 
                            RETURNING g_rta01
       #No.FUN-A90048 ------------end ------------------------
               DISPLAY g_rta01 TO rta01
               NEXT FIELD rta01
         END CASE
               
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode())
            RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
   END INPUT
END FUNCTION
 
FUNCTION i111_rta01(p_rta01)
DEFINE                                                                                                                              
    p_cmd           LIKE type_file.chr1,                                                                                            
    l_imaacti       LIKE ima_file.imaacti,
    p_rta01         LIKE rta_file.rta01
    
    LET g_errno = ' '
    SELECT ima02,ima1004,ima1005,ima1006,ima1007,ima1008,ima1009 
        INTO g_ima02,g_ima1004,g_ima1005,g_ima1006,g_ima1007,
             g_ima1008,g_ima1009 
    FROM ima_file WHERE ima01 = p_rta01 and imaacti = 'Y'
    
    CASE                                                                                                                            
       WHEN SQLCA.SQLCODE = 100                                                                                                    
                          LET g_errno = 'art-013'                                                                                 
       WHEN l_imaacti='N' LET g_errno = '9028'                                                                                    
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                          DISPLAY g_ima1008 TO FORMONLY.ima1008 
                          DISPLAY g_ima02 TO FORMONLY.ima02
                          DISPLAY g_ima1009 TO FORMONLY.ima1009
                          DISPLAY g_ima1004 TO FORMONLY.ima1004
                          DISPLAY g_ima1007 TO FORMONLY.ima1007
                          DISPLAY g_ima1005 TO FORMONLY.ima1005
                          DISPLAY g_ima1006 TO FORMONLY.ima1006                                                            
    END CASE
END FUNCTION
FUNCTION i111_rta03()
DEFINE                                                                                                                              
    p_cmd           LIKE type_file.chr1,                                                                                            
    l_gfeacti       LIKE gfe_file.gfeacti
    
    SELECT gfeacti,gfe02 INTO l_gfeacti,g_rta[l_ac].rta03_desc FROM gfe_file 
       WHERE gfe01=g_rta[l_ac].rta03
 
    CASE                                                                                                                            
       WHEN SQLCA.SQLCODE = 100                                                                                                    
                          LET g_errno = 'art-066'                                                                                 
       WHEN l_gfeacti='N' LET g_errno = '9028'                                                                                    
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                          DISPLAY g_rta[l_ac].rta03_desc TO FORMONLY.rta03_desc                                                           
    END CASE 
END FUNCTION  
FUNCTION i111_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   INITIALIZE g_rta01 TO NULL
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   DISPLAY ' ' TO FORMONLY.cnt
   CALL i111_curs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN i111_b_curs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_rta01 TO NULL
   ELSE
      CALL i111_fetch('F')
      OPEN i111_count
      FETCH i111_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
   END IF
END FUNCTION
 
FUNCTION i111_fetch(p_flag)
   DEFINE
      p_flag          LIKE type_file.chr1
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i111_b_curs INTO g_rta01
      WHEN 'P' FETCH PREVIOUS i111_b_curs INTO g_rta01
      WHEN 'F' FETCH FIRST    i111_b_curs INTO g_rta01
      WHEN 'L' FETCH LAST     i111_b_curs INTO g_rta01
      WHEN '/'
         IF (NOT g_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0                #add for prompt bug
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
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
        END IF
        FETCH ABSOLUTE g_jump i111_b_curs INTO g_rta01
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rta01,SQLCA.sqlcode,0)
   ELSE
      CALL i111_show()
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
 
FUNCTION i111_show()
   DISPLAY g_rta01 TO rta01
   CALL i111_rta01(g_rta01)
   CALL i111_b_fill(g_wc)
   CALL cl_show_fld_cont()
END FUNCTION
 
 
FUNCTION i111_r()
DEFINE  l_cnt    LIKE type_file.num5   #FUN-B90049 add
   IF g_rta01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
#FUN-C60024--start mark--------------
##FUN-B90049 -------------------STA
#   SELECT COUNT(*) INTO l_cnt  FROM rte_file
#    WHERE rte03 =  g_rta01 AND  NOT ((rtepos = '1') OR (rtepos = '3' AND rte07 = 'N'))
#   IF l_cnt > 0 THEN
#      CALL cl_err('','art-863',0)                   
#      RETURN
#   END IF
##FUN-B90049 -------------------END   
#FUN-C60024--end mark-------------

   #FUN-C60024--start add--------------------------------
   IF g_aza.aza88='Y' THEN
      SELECT COUNT(*) INTO l_cnt
        FROM rta_file,rtg_file,rtz_file
       WHERE rtg03 = rta01
         AND rtg04 = rta03
         AND rtz05 = rtg01
         AND rta01 = g_rta01
         AND NOT ((rtgpos = '1') OR (rtgpos = '3' AND rtg09 = 'N'))
      
      IF l_cnt > 0 THEN
         CALL cl_err('','art1071',0)
         RETURN
      END IF 
   END IF 
   #FUN-C60024--end add----------------------------------

   IF cl_delh(0,0) THEN
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "rta01"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_rta01       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                      #No.FUN-9B0098 10/02/24
      DELETE FROM rta_file WHERE rta01 = g_rta01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("del","rta_file",g_rta01,"",SQLCA.sqlcode,"","BODY DELETE:",1)
      ELSE
         CLEAR FORM
         CALL g_rta.clear()
         OPEN i111_count                                                                                                       
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE i111_b_curs
            CLOSE i111_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         FETCH i111_count INTO g_row_count                                                                                                                                                                                         
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i111_b_curs
            CLOSE i111_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i111_b_curs                                                                                                      
         IF g_curs_index = g_row_count + 1 THEN                                                                                     
            LET g_jump = g_row_count                                                                                                
            CALL i111_fetch('L')                                                                                               
         ELSE                                                                                                                       
            LET g_jump = g_curs_index                                                                                               
            LET g_no_ask = TRUE                                                                         
            CALL i111_fetch('/')                                                                                               
         END IF
      END IF
   END IF
END FUNCTION
 
FUNCTION i111_chk_rta05()
DEFINE l_i          LIKE type_file.num5
DEFINE l_length     LIKE type_file.num5
 
   LET l_length = LENGTH(g_rta[l_ac].rta05)
   LET g_errno = ' '
 
   IF g_rta[l_ac].rta04 = '2' THEN RETURN END IF
   IF l_length = 12 OR l_length = 7 THEN
      FOR l_i=1 TO l_length                                                                                                            
         IF g_rta[l_ac].rta05[l_i] NOT MATCHES "[0-9]" THEN                                                                       
            LET g_errno = 'art-015' 
            RETURN                                                                                                            
         END IF                                                                                                                        
      END FOR
   ELSE
      IF l_length = 13 OR l_length = 8 THEN 
         FOR l_i=1 TO l_length                                                                                                         
            IF g_rta[l_ac].rta05[l_i] NOT MATCHES "[0-9]" THEN                                                                         
               LET g_errno = 'art-015'  
               RETURN                                                                                              
            END IF                                                                                                                     
         END FOR
         CALL i111_chk_code()
      ELSE
         LET g_errno = 'art-015'   
         RETURN
      END IF
   END IF
   
END FUNCTION
FUNCTION i111_rta03_check()
DEFINE l_n         LIKE type_file.num5
 
   SELECT COUNT(*) INTO l_n FROM rta_file 
      WHERE rta01=g_rta01 AND rta03 = g_rta[l_ac].rta03
 
   IF l_n > 0 THEN
      RETURN FALSE
   END IF
 
   RETURN TRUE
END FUNCTION
FUNCTION i111_chk_repeat()
DEFINE  l_n             LIKE type_file.num5
   
  #FUN-D40001-----Mark&Add----Str
  #SELECT COUNT(*) INTO l_n FROM rta_file
  #   WHERE rta05=g_rta[l_ac].rta05
   SELECT COUNT(*) INTO l_n FROM rta_file
    WHERE rta01=g_rta01
      AND rta05=g_rta[l_ac].rta05
  #FUN-D40001-----Mark&Add----End
    IF l_n > 0 THEN
       RETURN FALSE
    END IF
    RETURN TRUE
END FUNCTION
#FUN-D40001-----Add----Str
FUNCTION i111_chk_repeat1()
   DEFINE  l_n             LIKE type_file.num5

   SELECT COUNT(*) INTO l_n FROM rta_file
    WHERE rta01<>g_rta01
      AND rta05=g_rta[l_ac].rta05
      AND rtaacti = 'Y'
   IF l_n > 0 THEN
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION
#FUN-D40001-----Add----End
FUNCTION i111_check_unit()
DEFINE l_ima25     LIKE ima_file.ima25
DEFINE l_smc02     LIKE smc_file.smc02
DEFINE l_sql       STRING
 
   SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = g_rta01
   IF g_rta[l_ac].rta03 = l_ima25 THEN RETURN TRUE END IF
   
   LET l_sql = "SELECT smc02 FROM smc_file WHERE smc01 = '",l_ima25,"'"
   PREPARE smc_cur FROM l_sql
 
   FOREACH smc_cur INTO l_smc02
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach ',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      IF l_smc02 = g_rta[l_ac].rta03 THEN
         RETURN TRUE
      END IF
      LET l_smc02 = ''
   END FOREACH
   
   RETURN FALSE
END FUNCTION
FUNCTION i111_b()
   DEFINE
      l_ac_t          LIKE type_file.num5,
      l_n             LIKE type_file.num5,
#     l_n1            LIKE type_file.num5,      #No.FUN-A50011 #TQC-AC0269
      l_n1            LIKE type_file.num5,      #No.FUN-B90102--ADD---
      l_n2            LIKE type_file.num5,
      l_lock_sw       LIKE type_file.chr1,
      p_cmd           LIKE type_file.chr1,
      l_tot           LIKE type_file.num5,
      l_allow_insert  LIKE type_file.num5,
      l_allow_delete  LIKE type_file.num5,
      l_cnt           LIKE type_file.num5,
      l_rowno         LIKE type_file.num5,
      l_temp          STRING,
      l_length        LIKE type_file.num5,
      l_i             LIKE type_file.num5,
      l_ima25         LIKE ima_file.ima25,
      l_flag          LIKE type_file.chr1,
      l_fac           LIKE type_file.num20_6,    #FUN-B90102----
#     l_ima151        LIKE ima_file.ima151,     #No.FUN-A50011 #TQC-AC0269
#     l_agd03_a       LIKE agd_file.agd03,    #No.FUN-A50011   #TQC-AC0269
#     l_agd03_b       LIKE agd_file.agd03     #No.FUN-A50011   #TQC-AC0269
#FUN-B90102---ADD--BEGIN--
      l_ima151        LIKE ima_file.ima151,
      l_agd03_a       LIKE agd_file.agd03,
      l_agd03_b       LIKE agd_file.agd03
#FUN-B90102----ADD--END---
#FUN-C60088----ADD----STR---
   DEFINE l_ima940_1  LIKE ima_file.ima940
   DEFINE l_ima940_2  LIKE ima_file.ima940
   DEFINE l_ima941_1  LIKE ima_file.ima941
   DEFINE l_ima941_2  LIKE ima_file.ima941
#FUN-C60088----ADD----END----
 
   DEFINE l_sql       STRING                    #FUN-C20022 add
   #DEFINE l_rtepos    LIKE rte_file.rtepos      #FUN-C20022 add #FUN-C60024 mark
   #FUN-C60024--start add------------------
   DEFINE l_rtgpos    LIKE rtg_file.rtgpos
   DEFINE l_flag2     LIKE type_file.chr1
   DEFINE l_rta01     LIKE rta_file.rta01
   #FUN-C60024--end add-------------------
 
   LET g_action_choice = ""
   IF g_rta01 IS NULL THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
   #LET g_posflag = 'N' #FUN-C20022 add     #FUN-C60024 mark
   #FUN-C60024--start mark-------------------------------------------------------- 
   ##FUN-C20022 add START
   # IF g_aza.aza88 = 'Y' THEN
   #    SELECT COUNT(*) INTO l_cnt FROM rte_file  #若有資料正在下傳不可修改
   #       WHERE rtepos = '5' AND rte03 = g_rta01
   #    IF l_cnt > 0 THEN
   #       CALL cl_err('','art-894',1)
   #       RETURN
   #    END IF
   #    LET l_sql = " SELECT rte01,rtepos FROM rte_file ",  #儲存原本rtepos的值
   #                " WHERE rte03 = '",g_rta01 CLIPPED,"'"
   #    PREPARE rtepos_pre FROM l_sql
   #    DECLARE rtepos_cur CURSOR FOR rtepos_pre
   #    CALL g_rtepos.clear()
   #    LET g_rtepos_num = 1
   #    FOREACH rtepos_cur INTO g_rtepos[g_rtepos_num].*
   #       IF SQLCA.sqlcode THEN
   #          CALL cl_err('foreach:',SQLCA.sqlcode,1)
   #          EXIT FOREACH
   #       END IF
   #       LET g_rtepos_num  = g_rtepos_num + 1
   #    END FOREACH
   # END IF
   # #FUN-C20022 add END
   #FUN-C60024--end mark----------------------------------------------------------   

   #FUN-C60024--start add---------------------------------------------------------
   IF g_aza.aza88 = 'Y' THEN
      LET l_sql = "SELECT rtg01,rtgpos ",
                  "  FROM rtg_file ,rtz_file",
                  " WHERE rtz05 = rtg01",
                  "   AND rtg03 = '",g_rta01 CLIPPED,"'",
                  "   AND rtg04 = ? "
                  
      PREPARE rtgpos_pre FROM l_sql
      DECLARE rtgpos_cur CURSOR FOR rtgpos_pre

      LET l_sql = "SELECT rta01 FROM rta_file ",
                  " WHERE rta01 = '",g_rta01,"'",
                  "   AND rta03 = ? FOR UPDATE "
      LET l_sql = cl_forupd_sql(l_sql)
      DECLARE i111_b_cur2 CURSOR FROM l_sql      # LOCK CURSOR
   END IF 
   #FUN-C60024--end add-----------------------------------------------------------
      
#TQC-AC0269 --Begin
##No.FUN-A50011  ----begin-----
#IF s_industry("slk") THEN 
#   LET g_forupd_sql = "SELECT rta02,
#                       rta06,rta07,rta08,rta09,rta10,rta11,'','',        
#                       rta03,'',rta04,rta05,rtaacti,rtapos,
#                        rtaud01,rtaud02,rtaud03,rtaud04,rtaud05,         
#                        rtaud06,rtaud07,rtaud08,rtaud09,rtaud10 ",          
#                      " FROM rta_file WHERE rta01= ?  AND rta02= ? ",
#                      " FOR UPDATE"
#ELSE
##TQC-AC0269 --End

#No.FUN-90102  ----begin-----
   IF s_industry("slk") THEN 
      LET g_forupd_sql = "SELECT rta02,",
                         " rta06,rta07,rta08,rta09,rta10,rta11,'','',", 
#                        " rta03,'',rta04,rta05,rtaacti,rtapos,",          #FUN-B90049 mark
                         " rta03,'',rta04,rta05,rtaacti,",                 #FUN-B90049 add 
                         "  rtaud01,rtaud02,rtaud03,rtaud04,rtaud05,",         
                         "  rtaud06,rtaud07,rtaud08,rtaud09,rtaud10 ",          
                         " FROM rta_file WHERE rta01= ?  AND rta02= ? ",
                         " FOR UPDATE"
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   ELSE
#No.FUN-B90102  ----END----
#  LET g_forupd_sql = "SELECT rta02,rta03,'',rta04,rta05,rtaacti,rtapos ",     #FUN-B90049 mark
    LET g_forupd_sql = "SELECT rta02,rta03,'',rta04,rta05,rtaacti ",           #FUN-B90049  add
                         " FROM rta_file WHERE rta01= ? AND rta02= ? ",
                         " FOR UPDATE"
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql) #No.FUN-90102  ----ADD--
#END IF                   #TQC-AC0269
   END IF                    #No.FUN-90102  ----ADD--

#No.FUN-A50011 -----end-----
#   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql) #No.FUN-90102 ----mark----
   DECLARE i111_b_curl CURSOR FROM g_forupd_sql      # LOCK CURSOR
   LET l_ac_t = 0 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_rta WITHOUT DEFAULTS FROM s_rta.*
      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
#TQC-AC0269 --Begin
##No.FUN-A50011  -----begin---
#IF s_industry("slk") THEN
#      SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01 = g_rta01
#      IF l_ima151 = 'Y' THEN
#         CALL cl_set_comp_visible("agd03_a,agd03_b",FALSE)
#      ELSE
#         CALL cl_set_comp_visible("agd03_a,agd03_b",TRUE) 
#         SELECT ima940,ima941 INTO l_agd03_a,l_agd03_b FROM ima_file WHERE ima01 = g_rta01
#      END IF
#END IF
##No.FUN-A50011  -----end---  
#TQC-AC0269 --End

#No.FUN-B90102  -----begin---
         IF s_industry("slk") THEN
            SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01 = g_rta01
            IF l_ima151 = 'Y' THEN
               CALL cl_set_comp_visible("agd03_a,agd03_b",FALSE)
            ELSE
               CALL cl_set_comp_visible("agd03_a,agd03_b",TRUE)
#FUN-C60088-------MARK-----STR---
#               SELECT tqa02 INTO l_agd03_a FROM tqa_file
#                WHERE tqa01 = (SELECT ima940 FROM ima_file WHERE ima01 = g_rta01)
#                  AND tqa03 = '25'
#               SELECT tqa02 INTO l_agd03_b  FROM tqa_file
#                WHERE tqa01 = (SELECT ima941 FROM ima_file WHERE ima01 = g_rta01)
#                  AND tqa03 = '26' 
#FUN-C60088-------MARK-----END---
#FUN-C60088----add----str------
               SELECT ima940 INTO l_ima940_2 FROM ima_file WHERE ima01=g_rta01
               SELECT ima940 INTO l_ima940_1 FROM ima_file
                WHERE ima01 = (SELECT DISTINCT imx00 FROM imx_file WHERE imx000=g_rta01)
               SELECT agd03 INTO l_agd03_a FROM agd_file
                WHERE agd01=l_ima940_1 AND agd02=l_ima940_2
               SELECT ima941 INTO l_ima941_2 FROM ima_file WHERE ima01=g_rta01
               SELECT ima941 INTO l_ima941_1 FROM ima_file
                WHERE ima01 = (SELECT DISTINCT imx00 FROM imx_file WHERE imx000=g_rta01)
               SELECT agd03 INTO l_agd03_b FROM agd_file
                WHERE agd01=l_ima941_1 AND agd02=l_ima941_2
#FUN-C60088----add----end-------
            END IF
         END IF
#No.FUN-B90102  -----end--- 

      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         DISPLAY l_ac  TO FORMONLY.cn2
         LET l_lock_sw = 'N'               #DEFAULT
         #FUN-C60024--start add-----     
         LET l_flag2 = 'N'
         LET g_success = 'Y'
         #FUN-C60024--end add-------
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_rta_t.* = g_rta[l_ac].*  #BACKUP
#FUN-B90049 -----------------------STA
          #FUN-C20022 mark START 
          #IF g_aza.aza88 = 'Y' THEN 
          #   UPDATE rte_file SET rtepos = '2'
          #    WHERE rte03 = g_rta01 AND rtepos = '3'
          #   IF SQLCA.sqlcode   THEN
          #      CALL cl_err3("upd","rte_file",g_rta01_t,"",SQLCA.sqlcode,"","",1)
          #   END IF
          #END IF
          #FUN-C20022 mark END
#FUN-B90049 -----------------------END 

          #FUN-C60024 add begin ----
          IF g_aza.aza88 = 'Y' THEN
             
             SELECT COUNT(*) INTO l_n
               FROM rtg_file,rtz_file 
              WHERE rtz05 = rtg01
                AND rtg03 = g_rta01
                AND rtg04 = g_rta[l_ac].rta03
                AND rtgpos <> '1' 

             IF l_n > 0 THEN
                CALL cl_set_comp_entry("rta02,rta03,rta04,rta05",FALSE)
             ELSE 
                CALL cl_set_comp_entry("rta02,rta03,rta04,rta05",TRUE) 
             END IF 

             BEGIN WORK
             OPEN i111_b_cur2 USING g_rta_t.rta03
             IF STATUS THEN
                CALL cl_err("OPEN i111_b_cur2:", STATUS, 1)
                CLOSE i111_b_cur2
                ROLLBACK WORK
                RETURN
             ELSE
                FETCH i111_b_cur2 INTO l_rta01
                IF STATUS THEN
                   CALL cl_err("FETCH i111_b_cur2:", STATUS, 1)
                   LET l_lock_sw = "Y"
                   CLOSE i111_b_cur2
                   ROLLBACK WORK
                   RETURN
                END IF
                CALL g_rtgpos.clear()
                LET g_rtgpos_num = 1
                FOREACH rtgpos_cur USING g_rta[l_ac].rta03 INTO g_rtgpos[g_rtgpos_num].* 
                   IF SQLCA.sqlcode THEN
                      CALL cl_err('foreach:',SQLCA.sqlcode,1)
                      EXIT FOREACH
                   END IF
                   LET g_rtgpos_num = g_rtgpos_num + 1
                END FOREACH    
                CALL g_rtgpos.deleteElement(g_rtgpos_num)
                LET g_rtgpos_num = g_rtgpos_num -1 
               
                UPDATE rtg_file 
                   SET rtgpos = '4'
                 WHERE rtg03 = g_rta01
                   AND rtg04 = g_rta[l_ac].rta03
                   AND rtg01 IN (SELECT DISTINCT rtz05 from rtz_file)
                IF STATUS THEN
                   CALL cl_err("OPEN i111_b_curl:", STATUS, 1)
                END IF               
             END IF   
             CLOSE i111_b_curl
             COMMIT WORK 
          END IF 
          #FUN-C60024 add end -----

          #FUN-C60024--start mark---------------------------------------------------- 
          ##FUN-C20022 add START
          #  IF g_aza.aza88 = 'Y' THEN
          #     UPDATE rte_file SET rtepos = '4'  #將rtepos 修改成4
          #      WHERE rte03 = g_rta01
          #     IF SQLCA.sqlcode   THEN
          #        CALL cl_err3("upd","rte_file",g_rta01_t,"",SQLCA.sqlcode,"","",1)
          #     END IF
          #  END IF
          ##FUN-C20022 add END
          #FUN-C60024--end mark------------------------------------------------------
            BEGIN WORK
            OPEN i111_b_curl USING g_rta01,g_rta_t.rta02
            IF STATUS THEN
               CALL cl_err("OPEN i111_b_curl:", STATUS, 1)
               LET l_lock_sw = "Y"
            #FUN-C60024--start add------------------------
            ELSE 
               FETCH i111_b_curl INTO g_rta[l_ac].* 
               IF STATUS THEN
                  CALL cl_err("OPEN i111_b_curl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               END IF
            #FUN-C60024--end add--------------------------
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         CALL cl_set_comp_entry("rta02,rta03,rta04,rta05",TRUE)    #FUN-C60024 add
         INITIALIZE g_rta[l_ac].* TO NULL
         LET g_rta_t.* = g_rta[l_ac].*
         LET g_rta[l_ac].rta04 = '1'
         LET g_rta[l_ac].rtaacti = 'Y'
#        LET g_rta[l_ac].rtapos = '1' #NO.FUN-B40071     #FUN-B90049  mark
#TQC-AC0269 --Begin
##No.FUN-A50011 ----begin----
#IF s_industry('slk') THEN
#         IF l_ima151 = 'Y' THEN
#         LET g_rta[l_ac].agd03_a = l_agd03_a;
#         LET g_rta[l_ac].agd03_b = l_agd03_b;
#         END IF
#END IF     
##No.FUN-A50011 ----end-----
#        DISPLAY BY NAME g_rta[l_ac].rtapos,g_rta[l_ac].agd03_a,g_rta[l_ac].agd03_b,g_rta[l_ac].rtaacti
#TQC-AC0269 --End

#No.FUN-B90102 ---ADD-begin----
         IF s_industry('slk') THEN
            LET g_rta[l_ac].agd03_a = l_agd03_a
            LET g_rta[l_ac].agd03_b = l_agd03_b
         END IF     
#         DISPLAY BY NAME g_rta[l_ac].rtapos,g_rta[l_ac].agd03_a,g_rta[l_ac].agd03_b,g_rta[l_ac].rtaacti        #FUN-B90049 mark
         DISPLAY BY NAME g_rta[l_ac].agd03_a,g_rta[l_ac].agd03_b,g_rta[l_ac].rtaacti                            #FUN-B90049 add
#FUN-B90102---------ADD--END---        
         CALL cl_show_fld_cont()
         NEXT FIELD rta02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         
         #FUN-C60024--start add---------------------------
         IF g_aza.aza88='Y' THEN  
            SELECT COUNT(*) INTO l_cnt
              FROM rtg_file,rtz_file
             WHERE rtz05 = rtg01 
               AND rtg03 = g_rta01
               AND rtg04 = g_rta[l_ac].rta03
               AND rtgpos = '3'
            
            CALL g_rtgpos .clear()
            LET g_rtgpos_num = 1
            IF l_cnt > 0 THEN
               FOREACH rtgpos_cur  USING g_rta[l_ac].rta03 INTO g_rtgpos[g_rtgpos_num].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('foreach ',SQLCA.sqlcode,1)
                     EXIT FOREACH
                  END IF
                  LET g_rtgpos_num = g_rtgpos_num + 1
               END FOREACH
               CALL g_rtgpos.deleteElement(g_rtgpos_num)
               LET g_rtgpos_num = g_rtgpos_num - 1

               UPDATE rtg_file
                  SET rtgpos = '2'
                WHERE rtg03 = g_rta01
                  AND rtg04 = g_rta[l_ac].rta03
                  AND rtgpos = '3'
                  AND rtg01 IN (SELECT DISTINCT rtz05 FROM rtz_file)
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","rtg_file","","",SQLCA.sqlcode,"","",1)
                  CANCEL INSERT
               END IF   
            END IF   
         END IF 
         #FUN-C60024--end add-----------------------------
 
#TQC-AC0269 --Begin
##No.FUN-A50011 ----begin----
#IF s_industry("slk") THEN
#         INSERT INTO rta_file(rta01,rta02,
#                       rta06,rta07,rta08,rta09,rta10,rta11,        
#                       rta03,rta04,rta05,rtaacti,rtapos,
#                       rtaud01,rtaud02,rtaud03,rtaud04,rtaud05,         #No.FUN-A50011
#                       rtaud06,rtaud07,rtaud08,rtaud09,rtaud10           #No.FUN-A50011
#                       )      
#            VALUES(g_rta01,g_rta[l_ac].rta02,
#                       g_rta[l_ac].rta06,g_rta[l_ac].rta07,             
#                       g_rta[l_ac].rta08,g_rta[l_ac].rta09,
#                       g_rta[l_ac].rta10,g_rta[l_ac].rta11,
#                       g_rta[l_ac].rta03,g_rta[l_ac].rta04,
#                       g_rta[l_ac].rta05,g_rta[l_ac].rtaacti,g_rta[l_ac].rtapos,
#                       g_rta[l_ac].rtaud01,g_rta[l_ac].rtaud02,         
#                       g_rta[l_ac].rtaud03,g_rta[l_ac].rtaud04,
#                       g_rta[l_ac].rtaud05,g_rta[l_ac].rtaud06,
#                       g_rta[l_ac].rtaud07,g_rta[l_ac].rtaud08,
#                       g_rta[l_ac].rtaud09,g_rta[l_ac].rtaud10
#                       )      
#ELSE
#TQC-AC0269 --End


#No.FUN-A50011 ----begin----
         IF s_industry("slk") THEN
            INSERT INTO rta_file(rta01,rta02,
                        rta06,rta07,rta08,rta09,rta10,rta11,        
                        rta03,rta04,rta05,rtaacti,rtapos,   
                        rtaud01,rtaud02,rtaud03,rtaud04,rtaud05,
                        rtaud06,rtaud07,rtaud08,rtaud09,rtaud10
                        )      
                 VALUES(g_rta01,g_rta[l_ac].rta02,
                        g_rta[l_ac].rta06,g_rta[l_ac].rta07,             
                        g_rta[l_ac].rta08,g_rta[l_ac].rta09,
                        g_rta[l_ac].rta10,g_rta[l_ac].rta11,
                        g_rta[l_ac].rta03,g_rta[l_ac].rta04,
#                        g_rta[l_ac].rta05,g_rta[l_ac].rtaacti,g_rta[l_ac].rtapos,          #FUN-B90049 mark
                         g_rta[l_ac].rta05,g_rta[l_ac].rtaacti,'N',                          #FUN-B90049 add
                        g_rta[l_ac].rtaud01,g_rta[l_ac].rtaud02,         
                        g_rta[l_ac].rtaud03,g_rta[l_ac].rtaud04,
                        g_rta[l_ac].rtaud05,g_rta[l_ac].rtaud06,
                        g_rta[l_ac].rtaud07,g_rta[l_ac].rtaud08,
                        g_rta[l_ac].rtaud09,g_rta[l_ac].rtaud10
                        )      
         ELSE
#FUN-B90102 --ADD--End
          #  INSERT INTO rta_file(rta01,rta02,rta03,rta04,rta05,rtaacti,rtapos)     #FUN-B90049 Mark 
             INSERT INTO rta_file(rta01,rta02,rta03,rta04,rta05,rtaacti) #FUN-B90049 add
                VALUES(g_rta01,g_rta[l_ac].rta02,g_rta[l_ac].rta03,g_rta[l_ac].rta04,
#                        g_rta[l_ac].rta05,g_rta[l_ac].rtaacti,g_rta[l_ac].rtapos)  #FUN-B90049 Mark
                    g_rta[l_ac].rta05,g_rta[l_ac].rtaacti)                             #FUN-B90049 add                        
#END IF     #TQC-AC0269
         END IF       #FUN-B90102 --ADD--
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
            CALL cl_err3("ins","rta_file",g_rta[l_ac].rta02,"",SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            #LET g_posflag = 'Y'  #add                  #FUN-C60024 add
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      BEFORE FIELD rta02
         IF p_cmd = 'a' THEN
            LET l_rowno = 0
            SELECT MAX(rta02) INTO l_rowno FROM rta_file
               WHERE rta01 = g_rta01
            IF cl_null(l_rowno) THEN LET l_rowno = 0 END IF
            LET g_rta[l_ac].rta02 = l_rowno + 1
            #DISPLAY BY NAME g_rta[l_ac].rta02
         END IF
      
      AFTER FIELD rta03
         IF NOT cl_null(g_rta[l_ac].rta03) THEN
            IF p_cmd='a' OR
               (p_cmd='u' AND g_rta[l_ac].rta03 != g_rta_t.rta03) THEN 
              #SELECT ima25 INTO l_ima25 FROM ima_file FROM WHERE ima01 = g_rta01     #TQC-D40044 mark
               SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = g_rta01          #TQC-D40044 add
               IF l_ima25 != g_rta[l_ac].rta03 THEN
                  CALL s_umfchk(g_rta01,l_ima25,g_rta[l_ac].rta03) 
                     RETURNING l_flag,l_fac
                  IF l_flag = 1 THEN
                     CALL cl_err('','art-214',0)         
                     NEXT FIELD rta03
                  END IF
               END IF
               CALL i111_rta03()
               IF NOT cl_null(g_errno)  THEN                                                                                     
                  CALL cl_err('',g_errno,0)                                                                                         
                  NEXT FIELD rta03                                                                                                  
               END IF
            END IF
         ELSE
            #TQC-AC0279 add--begin----------
            CALL cl_err('','alm-917',0)
            NEXT FIELD rta03
            #TQC-AC0279 add---end-----------
         END IF
      AFTER FIELD rta04 
         IF NOT cl_null(g_rta[l_ac].rta04) THEN
           #CALL i111_chk_rta05()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_rta[l_ac].rta05,g_errno,0)
               NEXT FIELD rta05
            END IF
         END IF
      AFTER FIELD rta05
         IF NOT cl_null(g_rta[l_ac].rta05) THEN
            IF p_cmd='a' OR  
               (p_cmd='u' AND g_rta[l_ac].rta05 != g_rta_t.rta05) THEN
               CALL i111_chk_rta05()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rta[l_ac].rta05,g_errno,0)
                  NEXT FIELD rta05
               END IF
               IF NOT i111_chk_repeat() THEN
                 #CALL cl_err(g_rta[l_ac].rta05,'art-016',0)    #FUN-D40001 Mark
                  CALL cl_err(g_rta[l_ac].rta05,'art-154',0)    #FUN-D40001 Add
                  NEXT FIELD rta05
               END IF
               #FUN-D40001----Add-----Str
               IF NOT i111_chk_repeat1() THEN
                  CALL cl_err(g_rta[l_ac].rta05,'art-803',0)
                  LET g_rta[l_ac].rta05 = g_rta_t.rta05
                  NEXT FIELD rta05
               END IF
               #FUN-D40001----Add-----End
            END IF
         END IF
    
       #FUN-D40001----Add-----Str
       AFTER FIELD rtaacti
          IF g_rta[l_ac].rtaacti = 'Y' THEN
             IF NOT i111_chk_repeat1() THEN
                CALL cl_err(g_rta[l_ac].rtaacti,'art-803',0)
                LET g_rta[l_ac].rtaacti = g_rta_t.rtaacti
                NEXT FIELD rtaacti
             END IF
          END IF
       #FUN-D40001----Add-----End
#TQC-AC0269 --Begin
##No.FUN-A50011 ----begin---
#      AFTER FIELD rta06
#         IF NOT cl_null(g_rta[l_ac].rta06) THEN
#            SELECT count(*) INTO l_n2 FROM rta_file WHERE rta01 = g_rta01 AND rta06 = g_rta[l_ac].rta06 
#            IF l_n2 > 0 THEN
#               CALL cl_err('',-239,1)
#               LET g_rta[l_ac].rta06 = NULL
#               NEXT FIELD rta06
#            END IF
#         ELSE 
#            CALL cl_err('',-1124,1)
#            NEXT FIELD rta06
#         END IF
#      AFTER FIELD rta11
#         IF NOT cl_null(g_rta[l_ac].rta11) THEN
#            SELECT count(pmc01) INTO l_n1 FROM pmc_file WHERE pmc01 = g_rta[l_ac].rta11
#            IF l_n1 > 0 THEN
#               DISPLAY g_rta[l_ac].rta11 TO rta11
#            ELSE
#               CALL cl_err('','art-354',1)
#               LET g_rta[l_ac].rta11 = NULL
#               NEXT FIELD rta11
#            END IF
#         ELSE
#            CALL cl_err('',-1124,1)
#            NEXT FIELD rta11
#         END IF  
##No.FUN-A50011 ----end---
#TQC-AC0269 --End  

#No.FUN-B90102 ----begin---
      AFTER FIELD rta06
         IF NOT cl_null(g_rta[l_ac].rta06) THEN
            IF p_cmd='a' OR (p_cmd = "u" AND g_rta[l_ac].rta06!=g_rta_t.rta06) THEN
               SELECT count(*) INTO l_n2 FROM rta_file WHERE rta01 = g_rta01 AND rta06 = g_rta[l_ac].rta06 
               IF l_n2 > 0 THEN
                  CALL cl_err('',-239,1)
                  LET g_rta[l_ac].rta06 = NULL
                  NEXT FIELD rta06
               END IF
            END IF
         ELSE 
            CALL cl_err('',-1124,1)
            NEXT FIELD rta06
         END IF
      AFTER FIELD rta11
         IF NOT cl_null(g_rta[l_ac].rta11) THEN
            SELECT count(pmc01) INTO l_n1 FROM pmc_file WHERE pmc01 = g_rta[l_ac].rta11 AND pmc05='1'
            IF l_n1 > 0 THEN
               DISPLAY g_rta[l_ac].rta11 TO rta11
            ELSE
               CALL cl_err('','art-354',1)
               LET g_rta[l_ac].rta11 = NULL
               NEXT FIELD rta11
            END IF
         END IF  
#No.FUN-B90102 ----end---

      BEFORE DELETE
         IF g_rta_t.rta02 IS NOT NULL AND g_rta_t.rta03 IS NOT NULL THEN
           IF g_aza.aza88='Y' THEN
             #FUN-B40071 --START--
              #IF NOT (g_rta[l_ac].rtaacti='N' AND g_rta[l_ac].rtapos='Y') THEN
              #  #CALL cl_err("", 'aim-944', 1)  #FUN-A30030 MARK
              #   CALL cl_err("", 'art-648', 1)  #ADD
              #   CANCEL DELETE
              #END IF

#FUN-B90049 ------------------STA
#             IF NOT ((l_rtapos = '3' AND g_rta[l_ac].rtaacti='N')
#                        OR (l_rtapos = '1')) THEN 
              #FUN-C60024--start mark--------------------------
              #SELECT COUNT(*) INTO l_cnt  FROM rte_file
              # WHERE rte03 =  g_rta01 AND  NOT ((rtepos = '1') OR (rtepos = '3' AND rte07 = 'N'))
              #FUN-C60024--end  mark---------------------------

              #FUN-C60024--start add-------------------------------------
                 SELECT COUNT(*) INTO l_cnt 
                   FROM rtg_file,rtz_file
                  WHERE rtz05 = rtg01
                    AND rtg03 = g_rta01
                    AND rtg04 = g_rta_t.rta03
                    AND NOT ((rtgpos = '1') OR (rtgpos = '3' AND rtg09 = 'N'))
              #FUN-C60024--end add---------------------------------------
              IF l_cnt > 0 THEN               
#FUN-B90049 ------------------END
                
#                CALL cl_err('','apc-139',0)                   #FUN-B90049 mark
                 #CALL cl_err('','art-863',0)                   #FUN-B90049 add
                 CALL cl_err('','art1071',0)                   #FUN-C60024 add
                 CANCEL DELETE            
                 RETURN
              END IF    
             #FUN-B40071 --END--
           END IF
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)

              #FUN-C60024--start mark--------- 
              ##FUN-C20022 add START
              # IF g_posflag <> 'Y' THEN
              #    LET g_posflag = 'N'
              # END IF
              ##FUN-C20022 add END
              #FUN-C60024--end mark----------

               ROLLBACK WORK
               CANCEL DELETE
            END IF
            DELETE FROM rta_file
               WHERE rta01 = g_rta01 AND
                     rta02 = g_rta_t.rta02
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL cl_err3("del","rta_file",g_rta_t.rta02,g_rta_t.rta03,SQLCA.sqlcode,"","",1)
               LET l_ac_t = l_ac
               EXIT INPUT
            END IF
            LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
               MESSAGE "Delete OK"
               CLOSE i111_b_curl
               #LET g_posflag = 'Y'  #FUN-C20022 add   #FUN-C60024 mark
               COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_rta[l_ac].* = g_rta_t.*
            CLOSE i111_b_curl
 
           #FUN-C60024--start mark--------
           ##FUN-C20022 add START
           # IF g_posflag <> 'Y' THEN
           #    LET g_posflag = 'N'
           # END IF
           ##FUN-C20022 add END
           #FUN-C60024--end mark----------

            ROLLBACK WORK
            EXIT INPUT
         END IF

         LET l_flag2 = 'Y'           #FUN-C60024 add
  
         IF g_aza.aza88='Y' THEN     #FUN-A30030 ADD 
            #FUN-C60024--start add----------------------------------
            FOR l_i = 1 TO g_rtgpos_num 
               LET l_rtgpos = ''
               IF g_rtgpos[l_i].rtgpos <> '1' THEN
                  LET l_rtgpos = '2'
               ELSE
                  LET l_rtgpos = '1'
               END IF 
          
              UPDATE rtg_file 
                 SET rtgpos = l_rtgpos
               WHERE rtg03 = g_rta01
                 AND rtg04 = g_rta_t.rta03
                 AND rtg01 = g_rtgpos[l_i].rtg01
           
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rtg_file","","",SQLCA.sqlcode,"","",1)
                 LET g_success = 'N'
                 EXIT FOR
              END IF   
           END FOR
           IF g_success = 'Y' THEN
              UPDATE rtg_file
                 SET rtgpos = '2'
               WHERE rtg03 = g_rta01
                 AND rtg04 = g_rta[l_ac].rta03
                 AND rtgpos = '3'
                 AND rtg01 IN (SELECT DISTINCT rtz05 FROM rtz_file)
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","rtg_file","","",SQLCA.sqlcode,"","",1)
                 LET g_success = 'N'
              END IF  
           END IF
         #FUN-C60024--end add------------------------------------

#TQC-AC0269 --Begin
#No.FUN-A50011 -----begin----
#           IF g_rta[l_ac].rta02<>g_rta_t.rta02 OR g_rta[l_ac].rta03<>g_rta_t.rta03 OR g_rta[l_ac].rta04<>g_rta_t.rta04 
#              OR g_rta[l_ac].rta05<>g_rta_t.rta05 OR g_rta[l_ac].rtaacti<>g_rta_t.rtaacti
#              OR g_rta[l_ac].rta06<>g_rta_t.rta06  OR g_rta[l_ac].rta07<>g_rta_t.rta07
#              OR g_rta[l_ac].rta09<>g_rta_t.rta09  OR g_rta[l_ac].rta08<>g_rta_t.rta08
#              OR g_rta[l_ac].rta10<>g_rta_t.rta10  OR g_rta[l_ac].rta11<>g_rta_t.rta11
#              OR g_rta[l_ac].rtaud01<>g_rta_t.rtaud01   OR g_rta[l_ac].rtaud02<>g_rta_t.rtaud02
#              OR g_rta[l_ac].rtaud03<>g_rta_t.rtaud03   OR g_rta[l_ac].rtaud04<>g_rta_t.rtaud04 
#              OR g_rta[l_ac].rtaud05<>g_rta_t.rtaud05   OR g_rta[l_ac].rtaud06<>g_rta_t.rtaud06
#              OR g_rta[l_ac].rtaud07<>g_rta_t.rtaud07   OR g_rta[l_ac].rtaud08<>g_rta_t.rtaud08
#              OR g_rta[l_ac].rtaud09<>g_rta_t.rtaud09   OR g_rta[l_ac].rtaud10<>g_rta_t.rtaud10      THEN        
#              LET g_rta[l_ac].rtapos = 'N'
#              DISPLAY BY NAME g_rta[l_ac].rtapos
#           END IF
#No.FUN-A50011 -----end-----
#TQC-AC0269 --End
#No.FUN-B90102 -----begin----
#            IF g_rta[l_ac].rta02<>g_rta_t.rta02 OR g_rta[l_ac].rta03<>g_rta_t.rta03 OR g_rta[l_ac].rta04<>g_rta_t.rta04 
#               OR g_rta[l_ac].rta05<>g_rta_t.rta05 OR g_rta[l_ac].rtaacti<>g_rta_t.rtaacti
#               OR g_rta[l_ac].rta06<>g_rta_t.rta06  OR g_rta[l_ac].rta07<>g_rta_t.rta07
#               OR g_rta[l_ac].rta09<>g_rta_t.rta09  OR g_rta[l_ac].rta08<>g_rta_t.rta08
#               OR g_rta[l_ac].rta10<>g_rta_t.rta10  OR g_rta[l_ac].rta11<>g_rta_t.rta11
#               OR g_rta[l_ac].rtaud01<>g_rta_t.rtaud01   OR g_rta[l_ac].rtaud02<>g_rta_t.rtaud02
#               OR g_rta[l_ac].rtaud03<>g_rta_t.rtaud03   OR g_rta[l_ac].rtaud04<>g_rta_t.rtaud04 
#               OR g_rta[l_ac].rtaud05<>g_rta_t.rtaud05   OR g_rta[l_ac].rtaud06<>g_rta_t.rtaud06
#               OR g_rta[l_ac].rtaud07<>g_rta_t.rtaud07   OR g_rta[l_ac].rtaud08<>g_rta_t.rtaud08
#               OR g_rta[l_ac].rtaud09<>g_rta_t.rtaud09   OR g_rta[l_ac].rtaud10<>g_rta_t.rtaud10      THEN        
#               LET g_rta[l_ac].rtapos = 'N'
#               DISPLAY BY NAME g_rta[l_ac].rtapos
#            END IF
#No.FUN-B90102 -----end-----
         END IF
         #FUN-C60024--start add----------------------------
         IF g_success = 'N' THEN
            LET g_rta[l_ac].* = g_rta_t.*
            ROLLBACK WORK  
         ELSE
         #FUN-C60024--end add------------------------------
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_rta[l_ac].rta02,-263,1)
               LET g_rta[l_ac].* = g_rta_t.*
            ELSE
   #TQC-AC0269 --Begin
   ##No.FUN-A50011 -----begin----
   #IF s_industry('slk') THEN
   #            UPDATE rta_file SET rta02 = g_rta[l_ac].rta02,
   #                                rta03 = g_rta[l_ac].rta03,
   #                                rta04 = g_rta[l_ac].rta04,
   #                                rta05 = g_rta[l_ac].rta05,
   #                                rtaacti = g_rta[l_ac].rtaacti,
   #                                rtapos = g_rta[l_ac].rtapos,
   #                                rta06 = g_rta[l_ac].rta06,
   #                                 rta07 = g_rta[l_ac].rta07,
   #                                 rta08 = g_rta[l_ac].rta08,
   #                                 rta09 = g_rta[l_ac].rta09,
   #                                 rta10 = g_rta[l_ac].rta10,
   #                                 rta11 = g_rta[l_ac].rta11,
   #                                 rtaud01 = g_rta[l_ac].rtaud01,rtaud02 = g_rta[l_ac].rtaud02,
   #                                 rtaud03 = g_rta[l_ac].rtaud03,rtaud04 = g_rta[l_ac].rtaud04,
   #                                 rtaud05 = g_rta[l_ac].rtaud05,rtaud06 = g_rta[l_ac].rtaud06,
   #                                 rtaud07 = g_rta[l_ac].rtaud07,rtaud08 = g_rta[l_ac].rtaud08,
   #                                 rtaud09 = g_rta[l_ac].rtaud09,rtaud10 = g_rta[l_ac].rtaud10
   #               WHERE rta01=g_rta01
   #                 AND rta02=g_rta_t.rta02
   #ELSE
   #TQC-AC0269 --End
   
   
   #No.FUN-B90102 ---ADD----begin----
            IF s_industry('slk') THEN
               UPDATE rta_file SET rta02 = g_rta[l_ac].rta02,
                                   rta03 = g_rta[l_ac].rta03,
                                   rta04 = g_rta[l_ac].rta04,
                                   rta05 = g_rta[l_ac].rta05,
                                   rtaacti = g_rta[l_ac].rtaacti,
   #                                rtapos = g_rta[l_ac].rtapos,          #FUN-B90049 mark
                                   rta06 = g_rta[l_ac].rta06,
                                   rta07 = g_rta[l_ac].rta07,
                                   rta08 = g_rta[l_ac].rta08,
                                   rta09 = g_rta[l_ac].rta09,
                                   rta10 = g_rta[l_ac].rta10,
                                   rta11 = g_rta[l_ac].rta11,
                                   rtaud01 = g_rta[l_ac].rtaud01,rtaud02 = g_rta[l_ac].rtaud02,
                                   rtaud03 = g_rta[l_ac].rtaud03,rtaud04 = g_rta[l_ac].rtaud04,
                                   rtaud05 = g_rta[l_ac].rtaud05,rtaud06 = g_rta[l_ac].rtaud06,
                                   rtaud07 = g_rta[l_ac].rtaud07,rtaud08 = g_rta[l_ac].rtaud08,
                                   rtaud09 = g_rta[l_ac].rtaud09,rtaud10 = g_rta[l_ac].rtaud10
                  WHERE rta01=g_rta01
                    AND rta02=g_rta_t.rta02
            ELSE
   #FUN-B90102--ADD---END-----
              #FUN-B40071 --STRAR--
               #LET g_rta[l_ac].rtapos = 'N'   #MOD-B30327 add
   #FUN-B90049 ---------------STA            
               #IF g_rta[l_ac].rtapos <> '1' THEN
               #   LET g_rta[l_ac].rtapos = '2'
               #END IF
             #FUN-C20022 mark START
             #IF g_aza.aza88 = 'Y' THEN
             #   UPDATE rte_file SET rtepos = '2'
             #    WHERE rte03 = g_rta01 AND rtepos = '3'
             #   IF SQLCA.sqlcode  THEN
             #      CALL cl_err3("upd","rte_file",g_rta01_t,"",SQLCA.sqlcode,"","",1)
             #   END IF
             #END IF
             #FUN-C20022 mark END
   #FUN-B90049 ---------------END           
              
              #FUN-B40071 --END--
               UPDATE rta_file SET rta02 = g_rta[l_ac].rta02,
                                   rta03 = g_rta[l_ac].rta03,
                                   rta04 = g_rta[l_ac].rta04,
                                   rta05 = g_rta[l_ac].rta05,
                                   rtaacti = g_rta[l_ac].rtaacti
    #                              rtapos = g_rta[l_ac].rtapos   #FUN-B90049  mark
                  WHERE rta01=g_rta01
                    AND rta02=g_rta_t.rta02
   #END IF #TQC-AC0269
   END IF    #FUN-B90102--ADD---
   #No.FUN-A50011 -----end----        
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                  CALL cl_err3("upd","rta_file",g_rta01,g_rta_t.rta02,SQLCA.sqlcode,"","",1)
                  LET g_rta[l_ac].* = g_rta_t.*
               ELSE
                  #LET g_posflag = 'Y' #FUN-C20022 add    #FUN-C60024 mark
                  MESSAGE 'UPDATE O.K'
               END IF
            END IF
         END IF                                        #FUN-C60024 add 
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac     #FUN-D30033 Mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            #FUN-C60024--start add---------
            CLOSE i111_b_curl
            ROLLBACK WORK 
            #FUN-C60024--end add-----------

            IF p_cmd='u' THEN

               #FUN-C60024--start add-----------------------------
               IF g_aza.aza88 = 'Y' AND l_lock_sw <> 'Y' THEN
                  FOR l_i = 1 TO g_rtgpos_num 
                     IF cl_null(g_rtgpos[l_i].rtg01) OR cl_null(g_rtgpos[l_i].rtgpos) THEN
                        CONTINUE FOR
                     END IF 

                     CALL i111_upd(g_rtgpos[l_i].rtg01,g_rta_t.rta03,g_rtgpos[l_i].rtgpos)
                  END FOR 
               END IF 

               #FUN-C60024--end add-------------------------------

               LET g_rta[l_ac].* = g_rta_t.*
            #FUN-C60024--start add-------------
            ELSE
               CALL g_rta.deleteElement(l_ac)
               #FUN-D30033--add--str--
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
               #FUN-D30033--add--end--
            #FUN-C60024--end add---------------
            END IF
            CLOSE i111_b_curl

           #FUN-C60024--start mark----
           ##FUN-C20022 add START
           # IF g_posflag <> 'Y' THEN
           #    LET g_posflag = 'N'
           # END IF
           ##FUN-C20022 add END
           #FUN-C60024--end mark-----

            #ROLLBACK WORK             #FUN-C60024 add
            EXIT INPUT
         END IF

         #FUN-C60024--start add-----------------------------------
         IF g_aza.aza88='Y' THEN
            IF (l_flag2 <> 'Y' AND NOT INT_FLAG) OR (g_success = 'N') THEN
               FOR l_i = 1 TO g_rtgpos_num
                  IF cl_null(g_rtgpos[l_i].rtg01) OR cl_null(g_rtgpos[l_i].rtgpos) THEN
                     CONTINUE FOR
                  END IF
                  LET l_rtgpos = ''
                  IF g_rtgpos[l_i].rtgpos <> '1' THEN
                     LET l_rtgpos = '2'
                  ELSE
                     LET l_rtgpos = '1'   
                  END IF 
                 
                  CALL i111_upd(g_rtgpos[l_i].rtg01,g_rta[l_ac].rta03,l_rtgpos) 
               END FOR   
            END IF          
         END IF 
         #FUN-C60024--end add-------------------------------------
         LET l_ac_t = l_ac     #FUN-D30033 Add
         CLOSE i111_b_curl
         COMMIT WORK
     
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(rta03)
               CALL cl_init_qry_var()
              #LET g_qryparam.form = "q_smc"   #FUN-A30116 MARK
              # LET g_qryparam.form = "q_smd1"   # add      #MOD-AC0181 mark
               LET g_qryparam.form = "q_gfe"                #MOD-AC0181 
              #SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = g_rta01
              #LET g_qryparam.arg1 = g_rta01   #FUN-A30116 ADD
              #LET g_qryparam.arg2 = l_ima25
               LET g_qryparam.default1 = g_rta[l_ac].rta03
               CALL cl_create_qry() RETURNING g_rta[l_ac].rta03
               CALL i111_rta03()                            #MOD-AC0181
               DISPLAY g_rta[l_ac].rta03 TO rta03
               NEXT FIELD rta03
#TQC-AC0269 --Begin
#No.FUN-A50011 ----begin----
#           WHEN INFIELD(rta11)   
#              CALL cl_init_qry_var()                                                                                         
#              LET g_qryparam.form = "q_pmc01"                                                                                  
#              LET g_qryparam.default1 = g_rta[l_ac].rta11                                                                                     
#              CALL cl_create_qry() RETURNING g_rta[l_ac].rta11
#              DISPLAY g_rta[l_ac].rta11 TO rta11                                                                                                                                                            
#              NEXT FIELD rta11
#No.FUN-A50011 -----end----
#TQC-AC0269 --End

#No.FUN-B90102 ----begin----
           WHEN INFIELD(rta11)   
              CALL cl_init_qry_var()                                                                                         
              LET g_qryparam.form = "q_pmc01"                                                                                  
              LET g_qryparam.default1 = g_rta[l_ac].rta11                                                                                     
              CALL cl_create_qry() RETURNING g_rta[l_ac].rta11
              DISPLAY g_rta[l_ac].rta11 TO rta11                                                                                                                                                            
              NEXT FIELD rta11
#No.FUN-B90102 -----end----
         END CASE
 
      ON ACTION Check_Digit 
         IF INFIELD(rta05) THEN
            IF g_rta[l_ac].rta05 IS NOT NULL THEN
               LET l_length = LENGTH(g_rta[l_ac].rta05)
               IF l_length=7 OR l_length=12 THEN 
                  CALL i111_create_code(g_rta[l_ac].rta05) RETURNING l_temp
                  LET g_rta[l_ac].rta05 = g_rta[l_ac].rta05,l_temp
                  DISPLAY BY NAME g_rta[l_ac].rta05                                                                                    
                  NEXT FIELD rta05
               ELSE 
                  IF LENGTH(g_rta[l_ac].rta05) != 7 OR LENGTH(g_rta[l_ac].rta05) != 8
                     OR LENGTH(g_rta[l_ac].rta05) != 12 OR LENGTH(g_rta[l_ac].rta05) != 13 THEN
                     CALL cl_err('','art-576',0)
                     NEXT FIELD rta05
                  END IF
                  CALL i111_chk_code()
                  IF NOT cl_null(g_errno) THEN
                     LET l_temp = ' '
                     FOR l_i=1 TO l_length-1 
                        LET l_temp = l_temp,g_rta[l_ac].rta05[l_i]
                     END FOR
                     LET g_rta[l_ac].rta05 = l_temp.trim()
                     CALL i111_create_code(g_rta[l_ac].rta05) RETURNING l_temp
                     LET g_rta[l_ac].rta05 = g_rta[l_ac].rta05,l_temp
                     DISPLAY BY NAME g_rta[l_ac].rta05
                     #CALL cl_err('','art-019',0)
                     NEXT FIELD rta05
                  ELSE 
                     CALL cl_err('','art-018',0)
                     NEXT FIELD rta05 
                  END IF 
               END IF
            ELSE
               CALL cl_err('','art-021',0)
               NEXT FIELD rta05
            END IF
         END IF
      ON ACTION CONTROLO
         IF INFIELD(rta03) AND l_ac > 1 THEN
            LET g_rta[l_ac].* = g_rta[l_ac-1].*
            DISPLAY g_rta[l_ac].* TO s_rta[l_ac].*
            NEXT FIELD rta05
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
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
   #FUN-C60024--start mark---------------------------------------- 
   ##FUN-C20022 add START
   # IF g_aza.aza88 = 'Y' THEN 
   #    IF g_posflag = 'Y' THEN
   #       FOR l_i = 1 TO g_rtepos_num
   #          IF cl_null(g_rtepos[l_i].rte01) OR cl_null(g_rtepos[l_i].rtepos) THEN CONTINUE FOR END IF
   #          LET l_rtepos = ' '
   #          IF g_rtepos[l_i].rtepos <> '1' THEN
   #              LET l_rtepos = '2'
   #          ELSE
   #              LET l_rtepos = '1'
   #          END IF
   #          UPDATE rte_file SET rtepos = l_rtepos
   #             WHERE rte01 = g_rtepos[l_i].rte01 AND rte03 = g_rta01
   #       END FOR
   #    ELSE
   #       FOR l_i = 1 TO g_rtepos_num
   #          IF cl_null(g_rtepos[l_i].rte01) OR cl_null(g_rtepos[l_i].rtepos) THEN CONTINUE FOR END IF
   #          UPDATE rte_file SET rtepos = g_rtepos[l_i].rtepos 
   #             WHERE rte01 = g_rtepos[l_i].rte01 AND rte03 = g_rta01
   #       END FOR
   #    END IF
   # END IF
   ##FUN-C20022 add END 
   #FUN-C60024--end mark-------------------------------------- 
   CLOSE i111_b_curl
 
END FUNCTION

#FUN-C60024--start add----------------------------
FUNCTION i111_upd(p_rtg01,p_rtg04,p_rtgpos)
   DEFINE p_rtg01        LIKE rtg_file.rtg01
   DEFINE p_rtg04        LIKE rtg_file.rtg04
   DEFINE p_rtgpos       LIKE rtg_file.rtgpos

   UPDATE rtg_file
      SET rtgpos = p_rtgpos
    WHERE rtg01 = p_rtg01
      AND rtg03 = g_rta01
      AND rtg04 = p_rtg04
     
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","rtg_file","","",SQLCA.sqlcode,"","",1)
   END IF
   
END FUNCTION
#FUN-C60024--end add------------------------------
 
FUNCTION i111_chk_code()
DEFINE l_length      LIKE  type_file.num5,                                                                                          
       l_i           LIKE  type_file.num5,                                                                                          
       l_mod         LIKE  type_file.num5,                                                                                          
       l_num1        LIKE  type_file.num5,                                                                                          
       l_num2        LIKE  type_file.num5,                                                                                          
       l_total       LIKE  type_file.num5,                                                                                          
       l_result      LIKE  type_file.num5,                                                                                          
       l_temp        STRING,
       l_rta05       LIKE  rta_file.rta05
 
    LET l_temp = g_rta[l_ac].rta05
    LET l_temp = l_temp.trim()
    LET g_rta[l_ac].rta05 = l_temp
    LET l_length = LENGTH(g_rta[l_ac].rta05)
    LET l_temp = ''
    LET g_errno = ' '
    FOR l_i=1 TO l_length-1
       LET l_temp = l_temp,g_rta[l_ac].rta05[l_i]
    END FOR
 
    CALL i111_create_code(l_temp) RETURNING l_num1
    LET l_num2 = g_rta[l_ac].rta05[l_length]
    IF l_num1 != l_num2 THEN
       LET g_errno = 'art-017'
       RETURN
    END IF
 
END FUNCTION
 
FUNCTION i111_create_code(p_code)
DEFINE l_length      LIKE  type_file.num5,
       l_i           LIKE  type_file.num5,
       l_mod         LIKE  type_file.num5,
       l_num1        LIKE  type_file.num5,
       l_num2        LIKE  type_file.num5,
       l_total       LIKE  type_file.num5,
       l_result      LIKE  type_file.num5,
       l_temp        STRING,
       p_code        LIKE  type_file.chr1000
 
    LET l_length = LENGTH(p_code)
    LET l_num1 = 0 
    LET l_num2 = 0 
    FOR l_i=1 TO l_length
       LET l_mod = l_i MOD 2
       IF l_mod = 0 THEN
          LET l_num2 = l_num2 + p_code[l_i]
       ELSE
       	  LET l_num1 = l_num1 + p_code[l_i]
       END IF 
    END FOR 
    
    LET l_total = l_num1 + l_num2*3
    LET l_result = 10 - (l_total MOD 10)
    IF l_result = 10 THEN
       LET l_result = 0
    END IF
    LET l_temp = l_result
    LET l_temp = l_temp.trim()
 
    LET l_result = l_temp
    RETURN l_result
END FUNCTION
 
FUNCTION i111_b_fill(p_wc)              #BODY FILL UP
DEFINE  l_sql    LIKE  type_file.chr1000,
        p_wc     LIKE  type_file.chr1000,
        l_ima151 LIKE  ima_file.ima151

#TQC-AC0269 --Begin
##No.FUN-A50011 -----begin-----
#IF s_industry("slk") THEN 
#   SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01 = g_rta01
#   IF l_ima151 = 'Y' THEN
#      CALL cl_set_comp_visible("agd03_a,agd03_b",FALSE)
#   ELSE
#      CALL cl_set_comp_visible("agd03_a,agd03_b",TRUE) 
#   END IF
#   LET l_sql = "SELECT rta02,
#                       rta06,rta07,rta08,rta09,rta10,rta11,'','',        
#                       rta03,'',rta04,rta05,rtaacti,rtapos,
#                        rtaud01,rtaud02,rtaud03,rtaud04,rtaud05,        
#                        rtaud06,rtaud07,rtaud08,rtaud09,rtaud10",        
#               " FROM rta_file WHERE rta01='",g_rta01,"' AND ",p_wc
#ELSE
#TQC-AC0269 --End


#No.FUN-B90102 ----ADD---begin-----
   IF s_industry("slk") THEN 
      SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01 = g_rta01
      IF l_ima151 = 'Y' THEN
         CALL cl_set_comp_visible("agd03_a,agd03_b",FALSE)
      ELSE
         CALL cl_set_comp_visible("agd03_a,agd03_b",TRUE) 
      END IF
      LET l_sql = "SELECT rta02,",
                      "   rta06,rta07,rta08,rta09,rta10,rta11,'','',",        
#                      "   rta03,'',rta04,rta05,rtaacti,rtapos,",                    #FUN-B90049 mark
                       "   rta03,'',rta04,rta05,rtaacti,",                           #FUN-B90049 add
                      "   rtaud01,rtaud02,rtaud03,rtaud04,rtaud05,",        
                      "   rtaud06,rtaud07,rtaud08,rtaud09,rtaud10",     
                   " FROM rta_file WHERE rta01='",g_rta01,"' AND ",p_wc
   ELSE
#FUN-B90102---ADD----END----
#   LET l_sql = "SELECT rta02,rta03,'',rta04,rta05,rtaacti,rtapos ",                  #FUN-B90049 mark
     LET l_sql = "SELECT rta02,rta03,'',rta04,rta05,rtaacti ",                        #FUN-B90049 add
                  " FROM rta_file WHERE rta01='",g_rta01,"' AND ",p_wc
#END IF  #TQC-AC0269
   END IF   #No.FUN-B90102 ----ADD-
#No.FUN-A50011 -----end-----
   PREPARE rta_prepare2 FROM l_sql
   DECLARE rta_curs CURSOR FOR rta_prepare2
   CALL g_rta.clear()
 
   LET g_cnt = 1
#TQC-AC0269 --Begin
##No.FUN-A50011 ---begin---
#IF s_industry("slk") THEN
#   FOREACH rta_curs INTO g_rta[g_cnt].*
#      IF SQLCA.sqlcode THEN
#         CALL cl_err('foreach:',SQLCA.sqlcode,1)
#         EXIT FOREACH
#      END IF
#      SELECT gfe02 INTO g_rta[g_cnt].rta03_desc FROM gfe_file
#         WHERE gfe01 = g_rta[g_cnt].rta03
#      LET g_cnt = g_cnt + 1
#      IF g_cnt > g_max_rec THEN
#         CALL cl_err( '', 9035, 0 )
#         EXIT FOREACH
#      END IF
#   END FOREACH
#ELSE
#TQC-AC0269 --End


#No.FUN-B90102-------ADD----begin---
   IF s_industry("slk") THEN
      FOREACH rta_curs INTO g_rta[g_cnt].*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         SELECT gfe02 INTO g_rta[g_cnt].rta03_desc FROM gfe_file
          WHERE gfe01 = g_rta[g_cnt].rta03
         CALL i111_agd()      
         LET g_cnt = g_cnt + 1
         IF g_cnt > g_max_rec THEN
            CALL cl_err( '', 9035, 0 )
            EXIT FOREACH
         END IF
      END FOREACH
   ELSE
#FUN-B90102-----ADD-----END-------
#   FOREACH rta_curs INTO g_rta[g_cnt].rta02,g_rta[g_cnt].rta03,g_rta[g_cnt].rta03_desc,g_rta[g_cnt].rta04,g_rta[g_cnt].rta05,g_rta[g_cnt].rtaacti,g_rta[g_cnt].rtapos
    FOREACH rta_curs INTO g_rta[g_cnt].rta02,g_rta[g_cnt].rta03,g_rta[g_cnt].rta03_desc,g_rta[g_cnt].rta04,g_rta[g_cnt].rta05,g_rta[g_cnt].rtaacti
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         SELECT gfe02 INTO g_rta[g_cnt].rta03_desc FROM gfe_file
          WHERE gfe01 = g_rta[g_cnt].rta03
         LET g_cnt = g_cnt + 1
         IF g_cnt > g_max_rec THEN
            CALL cl_err( '', 9035, 0 )
            EXIT FOREACH
         END IF
      END FOREACH
#END IF   #TQC-AC0269
   END IF    #FUN-B90102---ADD-----
#No.FUN-A50011 ---end---
   CALL g_rta.deleteElement(g_cnt)
   LET g_cnt = g_cnt - 1
   LET g_rec_b= g_cnt
 
   DISPLAY g_cnt TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
#No.FUN-B90102 ---ADD-begin----
FUNCTION i111_agd()
DEFINE l_agd03_a LIKE agd_file.agd03
DEFINE l_agd03_b LIKE agd_file.agd03
DEFINE l_ima151  LIKE ima_file.ima151
#FUN-C60088---ADD----STR---
DEFINE l_ima940_1 LIKE ima_file.ima940
DEFINE l_ima940_2 LIKE ima_file.ima940
DEFINE l_ima941_1 LIKE ima_file.ima941
DEFINE l_ima941_2 LIKE ima_file.ima941
#FUN-C60088----ADD----END----
   SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01=g_rta01
   IF s_industry('slk') THEN
#FUN-C60088----MARK----STR---
#      SELECT tqa02 INTO l_agd03_a FROM tqa_file
#       WHERE tqa01 = (SELECT ima940 FROM ima_file WHERE ima01 = g_rta01)
#        AND tqa03 = '25'
#      SELECT tqa02 INTO l_agd03_b  FROM tqa_file
#       WHERE tqa01 = (SELECT ima941 FROM ima_file WHERE ima01 = g_rta01)
#         AND tqa03 = '26'
#FUN-C60088----MARK----END---
#FUN-C60088----add----str------

      SELECT ima940 INTO l_ima940_2 FROM ima_file WHERE ima01=g_rta01
      SELECT ima940 INTO l_ima940_1 FROM ima_file
      WHERE ima01 = (SELECT DISTINCT imx00 FROM imx_file WHERE imx000=g_rta01)
      SELECT agd03 INTO l_agd03_a FROM agd_file
       WHERE agd01=l_ima940_1 AND agd02=l_ima940_2
      SELECT ima941 INTO l_ima941_2 FROM ima_file WHERE ima01=g_rta01
      SELECT ima941 INTO l_ima941_1 FROM ima_file
       WHERE ima01 = (SELECT DISTINCT imx00 FROM imx_file WHERE imx000=g_rta01)
      SELECT agd03 INTO l_agd03_b FROM agd_file
       WHERE agd01=l_ima941_1 AND agd02=l_ima941_2
#FUN-C60088----add----end-------
           
      LET g_rta[g_cnt].agd03_a = l_agd03_a
      LET g_rta[g_cnt].agd03_b = l_agd03_b
   END IF
   DISPLAY BY NAME g_rta[g_cnt].agd03_a,g_rta[g_cnt].agd03_b 
END FUNCTION
#FUN-B90102---------ADD--END---

FUNCTION i111_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)


   DISPLAY ARRAY g_rta TO s_rta.*  ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      #ON ACTION modify
      #   LET g_action_choice="modify"
      #   EXIT DISPLAY
      ON ACTION first
         CALL i111_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL i111_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL i111_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL i111_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL i111_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
     #ON ACTION reproduce   #FUN-A30116 MARK
     #   LET g_action_choice="reproduce"
     #   EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
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
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
#TQC-AC0269 --Begin
#No.FUN-A50011 -----begin-----
#     ON ACTION generate_codebar
#        LET g_action_choice = "generate_codebar"
#        EXIT DISPLAY
#     ON ACTION delete_codebar
#        LET g_action_choice = "delete_codebar"
#        EXIT DISPLAY
#No.FUN-A50011 -----end-----
#TQC-AC0269 --End
#No.FUN-B90102 -----begin-----
     ON ACTION generate_codebar
        LET g_action_choice = "generate_codebar"
        EXIT DISPLAY
     ON ACTION delete_codebar
        LET g_action_choice = "delete_codebar"
        EXIT DISPLAY
#No.FUN-B90102 -----end-----
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i111_copy()
DEFINE
   l_newno         LIKE rta_file.rta01,
   l_oldno         LIKE rta_file.rta01,  #FUN-A30116 ADD
   l_n             LIKE type_file.num5
 
   IF g_rta01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   CALL cl_getmsg('copy',g_lang) RETURNING g_msg
   LET INT_FLAG = 0
   CALL cl_set_head_visible("","YES")
 
   INPUT l_newno FROM rta01
      AFTER FIELD rta01
         IF cl_null(l_newno) THEN                                                                                                   
            NEXT FIELD rta01                                                                                                        
         ELSE 
#NO.FUN-A90048 add -----------start--------------------
           IF NOT s_chk_item_no(l_newno,'') THEN
              CALL cl_err('',g_errno,1)
              NEXT FIELD rta01
           END IF
#NO.FUN-A90048 add ------------end --------------------  
           #FUN-A30116 ADD----------------
            SELECT COUNT(DISTINCT rta01) INTO l_n
              FROM rta_file
             WHERE rta01=l_newno
            IF l_n>0 THEN
               CALL cl_err(l_newno,-239,0)
               NEXT FIELD rta01
            END IF
           #FUN-A30116 ADD----------------

            CALL i111_rta01(l_newno)
            IF NOT cl_null(g_errno)  THEN  
               CALL cl_err('',g_errno,0)
               NEXT FIELD rta01
            END IF
            DISPLAY l_newno TO rta01                                                                                                
         END IF
 
      ON ACTION CONTROLP                                                                                                            
         CASE                                                                                                                       
            WHEN INFIELD(rta01)   
       #No.FUN-A90048 --------------start -------------------            
       #        CALL cl_init_qry_var()                                                                                               
       #        LET g_qryparam.form = "q_ima"                                                                                        
       #        LET g_qryparam.default1 = l_newno                                                                                    
       #        CALL cl_create_qry() RETURNING l_newno
                CALL q_sel_ima( FALSE, "q_ima","",l_newno,"","","","","",'') 
                            RETURNING l_newno
       #No.FUN-A90048 ---------------end ----------------------
               DISPLAY l_newno TO rta01                                                                                             
               NEXT FIELD rta01                                                                                                     
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
   END INPUT
  
   BEGIN WORK     #FUN-A30116 ADD

   IF INT_FLAG OR l_newno IS NULL THEN
      LET INT_FLAG = 0
      ROLLBACK WORK #FUN-A30116 ADD
      RETURN
   END IF
   SELECT count(*) INTO g_cnt FROM rta_file WHERE rta01 = l_newno
   IF g_cnt > 0 THEN
      CALL cl_err(g_rta01,-239,0)
      ROLLBACK WORK  #FUN-A30116 ADD
      RETURN
   END IF
   DROP TABLE x
   SELECT * FROM rta_file WHERE rta01=g_rta01 INTO TEMP x
   #UPDATE x SET rta01=l_newno,rtapos='N'  #FUN-870100
   #UPDATE x SET rta01=l_newno,rtapos='1'  #FUN-B40071     #FUN-B90049 mark
   INSERT INTO rta_file SELECT * FROM x
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("ins","rta_file",g_rta01,"",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK  #FUN-A30116 ADD
      RETURN
   ELSE
      MESSAGE 'ROW(',l_newno,') O.K'
      COMMIT WORK #FUN-A30116 ADD
   END IF
  
   #FUN-A30116 ADD------
   LET l_oldno = g_rta01
   LET g_rta01 = l_newno
   CALL i111_rta01(g_rta01)
   CALL i111_b_fill(' 1=1')
   CALL cl_show_fld_cont()
   CALL i111_b()  
   #LET g_rta01 = l_oldno    #FUN-C80046
   #CALL i111_rta01(g_rta01) #FUN-C80046
   #CALL i111_b_fill(' 1=1') #FUN-C80046
   #CALL cl_show_fld_cont()  #FUN-C80046
   #FUN-A30116 ADD------

END FUNCTION

FUNCTION i111_out()
DEFINE l_cmd   LIKE type_file.chr1000        
                                                                                   
    IF g_wc IS NULL THEN                                                                                                           
       CALL cl_err('','9057',0)                                                                                                     
       RETURN                                                                                                                       
    END IF                                                                                                                          
    LET l_cmd='p_query "arti111" "',g_wc CLIPPED,'"'                                                                                
    CALL cl_cmdrun(l_cmd)
END FUNCTION
FUNCTION i111_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("rta01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i111_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("rta01",FALSE)
   END IF
 
END FUNCTION

#No.FUN-B90102 -----begin-----
FUNCTION i111_generate_codebar()
  DEFINE l_sql    STRING
  OPEN WINDOW i111_generate_codebar AT 3,4 WITH FORM "art/42f/arti111_1" ATTRIBUTE (STYLE = g_win_style CLIPPED)
  CALL cl_ui_init()
  CALL i111_a_generate()
  CLOSE WINDOW i111_generate_codebar
END FUNCTION 

FUNCTION i111_delete_codebar()
DEFINE l_sql    STRING
  OPEN WINDOW i111_delete_codebar AT 3,4 WITH FORM "art/42f/arti111_2" ATTRIBUTE (STYLE = g_win_style CLIPPED)
  CALL cl_ui_init()
  CALL i111_b_delete()
  CLOSE WINDOW i111_delete_codebar
END FUNCTION	

FUNCTION i111_a_generate()
DEFINE l_ima01    LIKE ima_file.ima01
DEFINE l_ima02    LIKE ima_file.ima02
DEFINE l_ima1004  LIKE ima_file.ima1004
DEFINE l_ima1005  LIKE ima_file.ima1005
DEFINE l_ima1006  LIKE ima_file.ima1006
DEFINE l_ima1007  LIKE ima_file.ima1007
DEFINE l_ima1008  LIKE ima_file.ima1008
DEFINE l_ima1009  LIKE ima_file.ima1009
DEFINE l_imaag    LIKE ima_file.imaag
DEFINE l_imx00    LIKE imx_file.imx00
DEFINE l_imx01    LIKE imx_file.imx01
DEFINE l_imx02    LIKE imx_file.imx02
DEFINE l_rta01    LIKE ima_file.ima01
DEFINE l_rta02    LIke rta_file.rta02
DEFINE l_rta03    LIKE rta_file.rta03
DEFINE l_rta04    LIKE rta_file.rta04
DEFINE l_rta05    LIKE rta_file.rta05
DEFINE l_geh01    LIKE geh_file.geh01
DEFINE l_gei01    LIKE gei_file.gei01
DEFINE l_wc,l_sql,l_sql1    STRING
DEFINE l_n,l_n1,l_n2        LIKE type_file.num5
DEFINE l_radio    LIKE type_file.chr1
DEFINE l_rowno    LIKE type_file.num5
DEFINE l_rta03_t  LIKE rta_file.rta03
DEFINE l_rtaacti  LIKE rta_file.rtaacti
#DEFINE l_rtapos   LIKE rta_file.rtapos                   #FUN-B90049 mark
DEFINE l_flag     LIKE type_file.chr1
DEFINE l_ps       LIKE sma_file.sma46
DEFINE l_r        LIKE type_file.num5

   MESSAGE ""
   CLEAR FORM
   WHILE TRUE
   CONSTRUCT BY NAME l_wc ON ima01,ima1004,ima1005,ima1006,ima1007,ima1008,ima1009 
      ON ACTION controlp
         CASE 
	    WHEN INFIELD(ima01)
               CALL q_sel_ima(TRUE, "q_rta_4"," ima1010 = '1' and imaacti = 'Y'","","","","","","",'') 
                 RETURNING  g_qryparam.multiret
	       DISPLAY g_qryparam.multiret TO ima01
	       NEXT FIELD ima01
	    WHEN INFIELD(ima1004)
	       CALL cl_init_qry_var()
	       LET g_qryparam.form = "q_tqa"
	       LET g_qryparam.arg1 = "1"
	       LET g_qryparam.state = "c"
	       CALL cl_create_qry() RETURNING g_qryparam.multiret
	       DISPLAY g_qryparam.multiret TO ima1004
	       NEXT FIELD ima1004
	    WHEN INFIELD(ima1005)
	       CALL cl_init_qry_var()
	       LET g_qryparam.form = "q_tqa"
	       LET g_qryparam.arg1 = "2"
	       LET g_qryparam.state = "c"
	       CALL cl_create_qry() RETURNING g_qryparam.multiret
	       DISPLAY g_qryparam.multiret TO ima1005
	       NEXT FIELD ima1005
	    WHEN INFIELD(ima1006)
	       CALL cl_init_qry_var()
	       LET g_qryparam.form = "q_tqa"
	       LET g_qryparam.arg1 = "3"
	       LET g_qryparam.state = "c"
	       CALL cl_create_qry() RETURNING g_qryparam.multiret
	       DISPLAY g_qryparam.multiret TO ima1006
	       NEXT FIELD ima1006
	    WHEN INFIELD(ima1007)
	       CALL cl_init_qry_var()
	       LET g_qryparam.form = "q_tqa"
	       LET g_qryparam.arg1 = "4"
	       LET g_qryparam.state = "c"
	       CALL cl_create_qry() RETURNING g_qryparam.multiret
	       DISPLAY g_qryparam.multiret TO ima1007
	       NEXT FIELD ima1007
	    WHEN INFIELD(ima1008)
	       CALL cl_init_qry_var()
	       LET g_qryparam.form = "q_tqa"
	       LET g_qryparam.arg1 = "5"
	       LET g_qryparam.state = "c"
	       CALL cl_create_qry() RETURNING g_qryparam.multiret
	       DISPLAY g_qryparam.multiret TO ima1008
	       NEXT FIELD ima1008
	    WHEN INFIELD(ima1009)
	       CALL cl_init_qry_var()
	       LET g_qryparam.form = "q_tqa"
	       LET g_qryparam.arg1 = "6"
	       LET g_qryparam.state = "c"
	       CALL cl_create_qry() RETURNING g_qryparam.multiret
	       DISPLAY g_qryparam.multiret TO ima1009
	       NEXT FIELD ima1009
         END CASE	   
      ON IDLE g_idle_seconds
         CALL cl_on_idle()

	 CONTINUE CONSTRUCT
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END CONSTRUCT	 
   IF INT_FLAG THEN
      LET INT_FLAG=0
      RETURN
   END IF
   INPUT l_rta04,l_rta03,l_radio,l_geh01,l_gei01 FROM rta04,rta03,radio,geh01,gei01 
      BEFORE INPUT 
         CALL cl_set_comp_entry("geh01,gei01",TRUE)
         LET l_rta04='1'
         LET l_rta03='1'
         LET l_radio ='1'
         DISPLAY l_rta04 TO rta04
         DISPLAY l_rta03 TO rta03
         DISPLAY l_radio TO radio
         CALL cl_set_comp_entry("geh01,gei01",FALSE)
      AFTER FIELD rta04
         IF l_rta04 IS NULL THEN
            CALL cl_err('',-1124,1)
	    NEXT FIELD rta04
	 ELSE 
	    DISPLAY BY NAME l_rta04
	 END IF
      AFTER FIELD rta03
         IF l_rta03 IS NULL THEN
            CALL cl_err('',-1124,1)
            NEXT FIELD rta03
         ELSE
            DISPLAY BY NAME l_rta03
         END IF
      AFTER FIELD radio
         IF l_radio IS NULL THEN
            CALL cl_err('',-1124,1)
	    NEXT FIELD radio
	 END IF
	 IF l_radio = '1'  THEN
            LET l_geh01 = NULL
            LET l_gei01 = NULL 
	    CALL cl_set_comp_entry("geh01,gei01",FALSE)
         ELSE 
            CALL cl_set_comp_entry("geh01,gei01",TRUE)
	 END IF
      ON CHANGE radio
         IF l_radio IS NULL THEN
            CALL cl_err('',-1124,1)
            NEXT FIELD radio
         END IF
         IF l_radio = '1'  THEN
            LET l_geh01 = NULL
            LET l_gei01 = NULL
            CALL cl_set_comp_entry("geh01,gei01",FALSE)
         ELSE
            CALL cl_set_comp_entry("geh01,gei01",TRUE)
            CALL cl_set_comp_required("geh01,gei01",TRUE)
         END IF 
      AFTER FIELD geh01
         IF l_radio = '2' THEN
             IF NOT cl_null(l_geh01) THEN
                LET l_r=0
                SELECT COUNT(*) INTO l_r FROM geh_file WHERE geh01=l_geh01 AND geh04= '7'
                IF l_r=0 THEN
                   CALL cl_err("","art1018",1)
                   NEXT FIELD geh01
                END IF
             END IF
         END IF
      AFTER FIELD gei01
         IF l_radio = '2' THEN
             IF NOT cl_null(l_gei01) THEN
                LET l_r=0
                SELECT COUNT(*) INTO l_r FROM gei_file WHERE gei03 = l_geh01 AND gei01 = l_gei01
                IF l_r=0 THEN
                   CALL cl_err("","art1019",1)
                   NEXT FIELD geh01
                END IF
             END IF
         END IF
      ON ACTION controlp
         CASE 
	    WHEN INFIELD(geh01)
	       CALL cl_init_qry_var()
	       LET g_qryparam.form = "q_geh"
               LET g_qryparam.where = "geh04 = '7'"
               LET g_qryparam.default1 = l_geh01
	       CALL cl_create_qry() RETURNING l_geh01 
               DISPLAY l_geh01 TO geh01
	       NEXT FIELD geh01
	    WHEN INFIELD(gei01)
	       CALL cl_init_qry_var()
	       LET g_qryparam.form = "q_gei"
               LET g_qryparam.where = "gei03 = '",l_geh01,"'"
               LET g_qryparam.default1 = l_gei01
	       CALL cl_create_qry() RETURNING l_gei01 
               DISPLAY l_gei01 TO gei01
	       NEXT FIELD gei01
         END CASE
      AFTER INPUT 
         IF INT_FLAG THEN
            LET INT_FLAG=0
	    RETURN 
       	 END IF
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
   END INPUT
   LET l_n1 = 1
   LET l_rta03_t = l_rta03
   LET l_wc = l_wc CLIPPED
   SELECT sma46 INTO l_ps FROM sma_file 
   LET l_sql = " SELECT count(ima01) FROM ima_file WHERE ", l_wc
   LET l_sql1 = " SELECT ima01 FROM ima_file WHERE ", l_wc
   DECLARE l_cs3 SCROLL CURSOR WITH HOLD FROM l_sql
   DECLARE l_cs4 SCROLL CURSOR WITH HOLD FROM l_sql1
   OPEN l_cs3
   FETCH l_cs3 INTO l_n
   IF l_n > 0 THEN
       WHILE(l_n1 <= l_n)
          IF l_n1 =1 THEN
             OPEN l_cs4
             FETCH ABSOLUTE 1 l_cs4 INTO l_ima01
          ELSE
             FETCH NEXT l_cs4 INTO l_ima01
          END IF
          LET l_rta01 = l_ima01
          LET l_rowno = 0

          IF NOT s_chk_item_no(l_ima01,'') THEN
             CALL cl_err(l_ima01,g_errno,1)
             LET l_n1 = l_n1 + 1
             CONTINUE WHILE
          END IF
          INITIALIZE l_rta05 TO NULL
          SELECT rta05 INTO l_rta05 FROM rta_file WHERE rta01 = l_ima01
          IF NOT cl_null(l_rta05) THEN
             CALL cl_err(l_ima01,"art1010",1)
             LET l_n1 = l_n1 + 1
             CONTINUE WHILE
          END IF 
             
          SELECT MAX(rta02) INTO l_rowno FROM rta_file WHERE rta01 = l_rta01
          IF cl_null(l_rowno) THEN LET l_rowno = 0 END IF
          LET l_rta02 = l_rowno + 1
          LET l_rta03 = l_rta03_t
          IF l_rta03 IS NOT NULL THEN
             IF l_rta03 = '1' THEN 
                 SELECT ima25 INTO l_rta03 FROM ima_file WHERE ima01 = l_rta01
             ELSE 
                 SELECT ima31 INTO l_rta03 FROM ima_file WHERE ima01 = l_rta01
             END IF
          END IF
          LET l_rtaacti = 'Y'
        #LET l_rtapos = 'N'
          IF l_radio = '1' THEN
              LET l_rta05 = l_ima01
          ELSE
             CALL s_auno(l_gei01,'7','') RETURNING l_rta05,l_ima02
          END IF
          SELECT count(*) INTO l_n2 FROM rta_file WHERE rta05 = l_rta05
          IF l_n2 = 0 THEN 
             INSERT INTO rta_file(rta01,rta02,rta03,rta04,rta05,rtaacti,rtapos) 
#            VALUES (l_rta01,l_rta02,l_rta03,l_rta04,l_rta05,l_rtaacti,l_rtapos)         #FUN-B90049 mark
             VALUES (l_rta01,l_rta02,l_rta03,l_rta04,l_rta05,l_rtaacti,'N')              #FUN-B90049 add 
             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","rta_file",l_rta05,"",SQLCA.sqlcode,"","",1)
             ELSE
                MESSAGE "insert O.K"
             END IF
          ELSE 

             MESSAGE "The data has existed"
          END IF
          LET l_n1 = l_n1 + 1
       END WHILE
       CALL cl_end2('1') RETURNING l_flag
       IF l_flag THEN
          CLEAR FORM
          MESSAGE ""
          CONTINUE WHILE
       ELSE
          RETURN
       END IF
   ELSE
      CALL cl_err('','art-889',1)
   END IF
  END WHILE
END FUNCTION

FUNCTION i111_b_delete()
DEFINE l_ima01    LIKE ima_file.ima01
DEFINE l_ima1004  LIKE ima_file.ima1004
DEFINE l_ima1005  LIKE ima_file.ima1005
DEFINE l_ima1006  LIKE ima_file.ima1006
DEFINE l_ima1007  LIKE ima_file.ima1007
DEFINE l_ima1008  LIKE ima_file.ima1008
DEFINE l_ima1009  LIKE ima_file.ima1009
DEFINE l_rta05    LIKE rta_file.rta05
DEFINE l_rta04    LIKE rta_file.rta04
DEFINE l_wc,l_sql,l_sql1   STRING
DEFINE l_n,l_n1,l_n2        LIKE type_file.num5
   
   MESSAGE ""
   CLEAR FORM
   CONSTRUCT BY NAME l_wc ON ima01,ima1004,ima1005,ima1006,ima1007,ima1008,ima1009,rta05 
      ON ACTION controlp
         CASE 
	    WHEN INFIELD(ima01)
               CALL q_sel_ima(TRUE, "q_rta_4"," ima1010 = '1' and imaacti = 'Y'","","","","","","",'')
                 RETURNING  g_qryparam.multiret

	       DISPLAY g_qryparam.multiret TO ima01
	       NEXT FIELD ima01
	    WHEN INFIELD(ima1004)
	       CALL cl_init_qry_var()
	       LET g_qryparam.form = "q_tqa"
	       LET g_qryparam.arg1 = "1"
	       LET g_qryparam.state = "c"
	       CALL cl_create_qry() RETURNING g_qryparam.multiret
	       DISPLAY g_qryparam.multiret TO ima1004
	       NEXT FIELD ima1004
	    WHEN INFIELD(ima1005)
	       CALL cl_init_qry_var()
	       LET g_qryparam.form = "q_tqa"
	       LET g_qryparam.arg1 = "2"
	       LET g_qryparam.state = "c"
	       CALL cl_create_qry() RETURNING g_qryparam.multiret
	       DISPLAY g_qryparam.multiret TO ima1005
	       NEXT FIELD ima1005
	    WHEN INFIELD(ima1006)
	       CALL cl_init_qry_var()
	       LET g_qryparam.form = "q_tqa"
	       LET g_qryparam.arg1 = "3"
	       LET g_qryparam.state = "c"
	       CALL cl_create_qry() RETURNING g_qryparam.multiret
	       DISPLAY g_qryparam.multiret TO ima1006
	       NEXT FIELD ima1006
	    WHEN INFIELD(ima1007)
	       CALL cl_init_qry_var()
	       LET g_qryparam.form = "q_tqa"
	       LET g_qryparam.arg1 = "4"
	       LET g_qryparam.state = "c"
	       CALL cl_create_qry() RETURNING g_qryparam.multiret
	       DISPLAY g_qryparam.multiret TO ima1007
	       NEXT FIELD ima1007
	    WHEN INFIELD(ima1008)
	       CALL cl_init_qry_var()
	       LET g_qryparam.form = "q_tqa"
	       LET g_qryparam.arg1 = "5"
	       LET g_qryparam.state = "c"
	       CALL cl_create_qry() RETURNING g_qryparam.multiret
	       DISPLAY g_qryparam.multiret TO ima1008
	       NEXT FIELD ima1008
	    WHEN INFIELD(ima1009)
	       CALL cl_init_qry_var()
	       LET g_qryparam.form = "q_tqa"
	       LET g_qryparam.arg1 = "6"
	       LET g_qryparam.state = "c"
	       CALL cl_create_qry() RETURNING g_qryparam.multiret
	       DISPLAY g_qryparam.multiret TO ima1009
	       NEXT FIELD ima1009
	    WHEN INFIELD(rta05)
	       CALL cl_init_qry_var()
	       LET g_qryparam.form = "q_rta051"
	       LET g_qryparam.state = "c"
	       CALL cl_create_qry() RETURNING g_qryparam.multiret
	       DISPLAY g_qryparam.multiret TO rta05
	       NEXT FIELD rta05
         END CASE	   
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
	 CONTINUE CONSTRUCT
      ON ACTION exit
         RETURN
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END CONSTRUCT	 
   IF INT_FLAG THEN
      LET  INT_FLAG=0
      RETURN
   END IF
   INPUT l_rta04 FROM rta04 
      BEFORE INPUT 
         LET l_rta04 ='3' 


      AFTER FIELD rta04
         IF l_rta04 IS NULL THEN
            CALL cl_err('',-1124,1)
	    NEXT FIELD rta04
	 ELSE 
	    DISPLAY BY NAME l_rta04
	 END IF
      AFTER INPUT 
         IF INT_FLAG THEN
            LET  INT_FLAG=0
	   RETURN 
       	 END IF
      ON ACTION exit
         RETURN
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
   END INPUT
   LET l_n1 = 1
   LET l_wc = l_wc CLIPPED
   LET l_sql = " SELECT count(ima01) FROM ima_file LEFT OUTER JOIN rta_file ON ima01 = rta01 WHERE ", l_wc
   LET l_sql1 = " SELECT ima01 FROM ima_file LEFT OUTER JOIN rta_file ON ima01 = rta01 WHERE ", l_wc
   DECLARE l_cs1 SCROLL CURSOR WITH HOLD FROM l_sql
   DECLARE l_cs2 SCROLL CURSOR WITH HOLD FROM l_sql1
   OPEN l_cs1
   FETCH l_cs1 INTO l_n
   IF l_n > 0 THEN
      IF cl_delete() THEN
         IF (l_rta04 = '3') THEN
            WHILE(l_n1 <= l_n)
               IF l_n1 =1 THEN
                  OPEN l_cs2
                  FETCH ABSOLUTE 1 l_cs2 INTO l_ima01
               ELSE
                  FETCH NEXT l_cs2 INTO l_ima01
               END IF
                   
               IF NOT s_chk_item_no(l_ima01,'') THEN
                  
                  CALL cl_err(l_ima01,g_errno,1)
                  LET l_n1 = l_n1 + 1
                  CONTINUE WHILE
               END IF

               SELECT count(rta01) INTO l_n2 FROM rta_file WHERE rta01 = l_ima01
               IF l_n2 > 0 THEN 
                  DELETE FROM rta_file WHERE rta01 = l_ima01
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("del","rta_file",l_ima01,"",SQLCA.sqlcode,"","",1)
                  ELSE
                     MESSAGE "delete O.K"
                  END IF
               ELSE 
                  MESSAGE "The column value isn't exite in the rta_file"
               END IF
               LET l_n1 = l_n1 + 1
            END WHILE
         ELSE
            WHILE(l_n1 <= l_n)
               IF l_n1 =1 THEN
                  OPEN l_cs2
                  FETCH ABSOLUTE 1 l_cs2 INTO l_ima01
               ELSE
                  FETCH NEXT l_cs2 INTO l_ima01
               END IF
              
               IF NOT s_chk_item_no(l_ima01,'') THEN
                  CALL cl_err(l_ima01,g_errno,1)
                  LET l_n1 = l_n1 + 1
                  CONTINUE WHILE
               END IF

               SELECT count(rta01) INTO l_n2 FROM rta_file WHERE rta01 = l_ima01
               IF l_n2 > 0 THEN 
                 DELETE FROM rta_file WHERE rta04 = l_rta04 AND rta01 = l_ima01
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("del","rta_file",l_ima01,"",SQLCA.sqlcode,"","",1)
                  ELSE 
                     MESSAGE "delete O.K"
                  END IF
               ELSE 
                  MESSAGE "The column value isn't exite in the rta_file"
               END IF
                  LET l_n1 = l_n1 + 1
            END WHILE
         END IF
      END IF
   ELSE
      CALL cl_err('','art-889',1)
   END IF
END FUNCTION
#No.FUN-B90102 -----end-----



#TQC-AC0269 --Begin
##No.FUN-A50011 -----begin-----
#FUNCTION i111_generate_codebar()
#  DEFINE l_sql    STRING
#  OPTIONS
#     INPUT NO WRAP
#  DEFER INTERRUPT
#  IF(NOT cl_user()) THEN
#     EXIT PROGRAM
#  END IF
#  WHENEVER ERROR CALL cl_err_msg_log
#  IF(NOT cl_setup("ART")) THEN
#     EXIT PROGRAM
#  END IF
#  CALL cl_used(g_prog,g_time,1) RETURNING g_time
#  OPEN WINDOW i100_generate_codebar AT 3,4 WITH FORM "art/42f/arti111_a" ATTRIBUTE (STYLE = g_win_style CLIPPED)
#  CALL cl_ui_init()
#  CALL i111_a_generate()
#  CLOSE WINDOW i100_generate_codebar
#  CALL cl_used(g_prog,g_time,2) RETURNING g_time
#END FUNCTION 
#FUNCTION i111_delete_codebar()
#DEFINE l_sql    STRING
#  OPTIONS
#     INPUT NO WRAP
#  DEFER INTERRUPT
#  IF(NOT cl_user()) THEN
#     EXIT PROGRAM
#  END IF
#  WHENEVER ERROR CALL cl_err_msg_log
#  IF(NOT cl_setup("ART")) THEN
#     EXIT PROGRAM
#  END IF
#  CALL cl_used(g_prog,g_time,1) RETURNING g_time
#  OPEN WINDOW i100_delete_codebar AT 3,4 WITH FORM "art/42f/arti111_b" ATTRIBUTE (STYLE = g_win_style CLIPPED)
#  CALL cl_ui_init()
#  CALL i111_b_delete()
#  CLOSE WINDOW i100_delete_codebar
#  CALL cl_used(g_prog,g_time,2) RETURNING g_time
#END FUNCTION	
#FUNCTION i111_a_generate()
#DEFINE l_ima01    LIKE ima_file.ima01
#DEFINE l_ima02    LIKE ima_file.ima02
#DEFINE l_ima1004  LIKE ima_file.ima1004
#DEFINE l_ima1005  LIKE ima_file.ima1005
#DEFINE l_ima1006  LIKE ima_file.ima1006
#DEFINE l_ima1007  LIKE ima_file.ima1007
#DEFINE l_ima1008  LIKE ima_file.ima1008
#DEFINE l_ima1009  LIKE ima_file.ima1009
#DEFINE l_imaag    LIKE ima_file.imaag
#DEFINE l_imx00    LIKE imx_file.imx00
#DEFINE l_imx01    LIKE imx_file.imx01
#DEFINE l_imx02    LIKE imx_file.imx02
#DEFINE l_rta01    LIKE ima_file.ima01
#DEFINE l_rta02    LIke rta_file.rta02
#DEFINE l_rta03    LIKE rta_file.rta03
#DEFINE l_rta04    LIKE rta_file.rta04
#DEFINE l_rta05    LIKE rta_file.rta05
#DEFINE l_geh01    LIKE geh_file.geh01
#DEFINE l_gei01    LIKE gei_file.gei01
#DEFINE l_wc,l_sql,l_sql1    STRING
#DEFINE l_n,l_n1,l_n2        LIKE type_file.num5
#DEFINE l_radio    LIKE type_file.chr1
#DEFINE l_rowno    LIKE type_file.num5
#DEFINE l_rta03_t  LIKE rta_file.rta03
#DEFINE l_rtaacti  LIKE rta_file.rtaacti
#DEFINE l_rtapos   LIKE rta_file.rtapos
#DEFINE l_flag     LIKE type_file.chr1
#DEFINE l_ps       LIKE sma_file.sma46
#
#   MESSAGE ""
#   CLEAR FORM
#   WHILE TRUE
#   CONSTRUCT BY NAME l_wc ON ima01,ima1004,ima1005,ima1006,ima1007,ima1008,ima1009 
#      ON ACTION controlp
#         CASE 
#	    WHEN INFIELD(ima01)
##FUN-AA0059---------mod------------str-----------------	    
##	       CALL cl_init_qry_var()
##	       LET g_qryparam.form = "q_ima"
##	       LET g_qryparam.where = "ima1010 = '1' and imaacti = 'Y'" 
##	       LET g_qryparam.state = "c"
##	       CALL cl_create_qry() RETURNING g_qryparam.multiret
#               CALL q_sel_ima(TRUE, "q_ima"," ima1010 = '1' and imaacti = 'Y'","","","","","","",'') 
#                 RETURNING  g_qryparam.multiret
##FUN-AA0059---------mod------------end-----------------
#	       DISPLAY g_qryparam.multiret TO ima01
#	       NEXT FIELD ima01
#	    WHEN INFIELD(ima1004)
#	       CALL cl_init_qry_var()
#	       LET g_qryparam.form = "q_tqa"
#	       LET g_qryparam.arg1 = "1"
#	       LET g_qryparam.state = "c"
#	       CALL cl_create_qry() RETURNING g_qryparam.multiret
#	       DISPLAY g_qryparam.multiret TO ima1004
#	       NEXT FIELD ima1004
#	    WHEN INFIELD(ima1005)
#	       CALL cl_init_qry_var()
#	       LET g_qryparam.form = "q_tqa"
#	       LET g_qryparam.arg1 = "2"
#	       LET g_qryparam.state = "c"
#	       CALL cl_create_qry() RETURNING g_qryparam.multiret
#	       DISPLAY g_qryparam.multiret TO ima1005
#	       NEXT FIELD ima1005
#	    WHEN INFIELD(ima1006)
#	       CALL cl_init_qry_var()
#	       LET g_qryparam.form = "q_tqa"
#	       LET g_qryparam.arg1 = "3"
#	       LET g_qryparam.state = "c"
#	       CALL cl_create_qry() RETURNING g_qryparam.multiret
#	       DISPLAY g_qryparam.multiret TO ima1006
#	       NEXT FIELD ima1006
#	    WHEN INFIELD(ima1007)
#	       CALL cl_init_qry_var()
#	       LET g_qryparam.form = "q_tqa"
#	       LET g_qryparam.arg1 = "4"
#	       LET g_qryparam.state = "c"
#	       CALL cl_create_qry() RETURNING g_qryparam.multiret
#	       DISPLAY g_qryparam.multiret TO ima1007
#	       NEXT FIELD ima1007
#	    WHEN INFIELD(ima1008)
#	       CALL cl_init_qry_var()
#	       LET g_qryparam.form = "q_tqa"
#	       LET g_qryparam.arg1 = "5"
#	       LET g_qryparam.state = "c"
#	       CALL cl_create_qry() RETURNING g_qryparam.multiret
#	       DISPLAY g_qryparam.multiret TO ima1008
#	       NEXT FIELD ima1008
#	    WHEN INFIELD(ima1009)
#	       CALL cl_init_qry_var()
#	       LET g_qryparam.form = "q_tqa"
#	       LET g_qryparam.arg1 = "6"
#	       LET g_qryparam.state = "c"
#	       CALL cl_create_qry() RETURNING g_qryparam.multiret
#	       DISPLAY g_qryparam.multiret TO ima1009
#	       NEXT FIELD ima1009
#         END CASE	   
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#	 CONTINUE CONSTRUCT
#      ON ACTION qbe_select
#         CALL cl_qbe_select()
#      ON ACTION qbe_save
#         CALL cl_qbe_save()
#   END CONSTRUCT	 
#   IF INT_FLAG THEN
#      RETURN
#   END IF
#   INPUT l_rta04,l_rta03,l_radio,l_geh01,l_gei01 FROM rta04,rta03,radio,geh01,gei01 
#      BEFORE INPUT 
#         CALL cl_set_comp_entry("geh01,gei01",TRUE)
#      AFTER FIELD rta04
#         IF l_rta04 IS NULL THEN
#            CALL cl_err('',-1124,1)
#	    NEXT FIELD rta04
#	 ELSE 
#	    DISPLAY BY NAME l_rta04
#	 END IF
#      AFTER FIELD radio
#         IF l_radio IS NULL THEN
#            CALL cl_err('',-1124,1)
#	    NEXT FIELD radio
#	 END IF
#	 IF l_radio = '1' OR l_radio = '3' THEN
#            LET l_geh01 = NULL
#            LET l_gei01 = NULL 
#	    CALL cl_set_comp_entry("geh01,gei01",FALSE)
#         ELSE 
#            CALL cl_set_comp_entry("geh01,gei01",TRUE)
#	 END IF
#      AFTER FIELD geh01
#         IF l_radio = '2' THEN
#             IF l_geh01 IS NULL THEN
#                CALL cl_err('',-1124,1)
#                NEXT FIELD geh01
#             END IF
#         END IF
#      AFTER FIELD gei01
#         IF l_radio = '2' THEN
#             IF l_gei01 IS NULL THEN
#                CALL cl_err('',-1124,1)
#                NEXT FIELD gei01
#             END IF
#         END IF
#      ON ACTION controlp
#         CASE 
#	    WHEN INFIELD(geh01)
#	       CALL cl_init_qry_var()
#	       LET g_qryparam.form = "q_geh"
#               LET g_qryparam.where = "geh04 = '7'"
#               LET g_qryparam.default1 = l_geh01
#	       CALL cl_create_qry() RETURNING l_geh01 
#               DISPLAY l_geh01 TO geh01
#	       NEXT FIELD geh01
#	    WHEN INFIELD(gei01)
#	       CALL cl_init_qry_var()
#	       LET g_qryparam.form = "q_gei"
#               LET g_qryparam.where = "gei03 = '",l_geh01,"'"
#               LET g_qryparam.default1 = l_gei01
#	       CALL cl_create_qry() RETURNING l_gei01 
#               DISPLAY l_gei01 TO gei01
#	       NEXT FIELD gei01
#         END CASE
#      AFTER INPUT 
#         IF INT_FLAG THEN
#	    RETURN 
#       	 END IF
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#   END INPUT
#   LET l_n1 = 1
#   LET l_rta03_t = l_rta03
#   LET l_wc = l_wc CLIPPED
#   SELECT sma46 INTO l_ps FROM sma_file 
#   LET l_sql = " SELECT count(ima01) FROM ima_file WHERE ", l_wc
#   LET l_sql1 = " SELECT ima01 FROM ima_file WHERE ", l_wc
#   DECLARE l_cs3 SCROLL CURSOR WITH HOLD FROM l_sql
#   DECLARE l_cs4 SCROLL CURSOR WITH HOLD FROM l_sql1
#   OPEN l_cs3
#   FETCH l_cs3 INTO l_n
#   IF l_n > 0 THEN
#       WHILE(l_n1 <= l_n)
#          IF l_n1 =1 THEN
#             OPEN l_cs4
#             FETCH ABSOLUTE 1 l_cs4 INTO l_ima01
#          ELSE
#             FETCH NEXT l_cs4 INTO l_ima01
#          END IF
#          LET l_rta01 = l_ima01
#          LET l_rowno = 0
#          SELECT MAX(rta02) INTO l_rowno FROM rta_file WHERE rta01 = l_rta01
#          IF cl_null(l_rowno) THEN LET l_rowno = 0 END IF
#          LET l_rta02 = l_rowno + 1
#          LET l_rta03 = l_rta03_t
#          IF l_rta03 IS NOT NULL THEN
#             IF l_rta03 = '1' THEN 
#                 SELECT ima25 INTO l_rta03 FROM ima_file WHERE ima01 = l_rta01
#             ELSE 
#                 SELECT ima31 INTO l_rta03 FROM ima_file WHERE ima01 = l_rta01
#             END IF
#          END IF
#          LET l_rtaacti = 'Y'
#          LET l_rtapos = 'N'
#          IF l_radio = '1' THEN
#              LET l_rta05 = l_ima01
#          ELSE
#              IF l_radio = '3' THEN
#                 SELECT imaag INTO l_imaag FROM ima_file WHERE ima01 = l_ima01
#                 IF l_imaag = '@CHILD' THEN
#                    SELECT imx00,imx01,imx02 INTO l_imx00,l_imx01,l_imx02 FROM imx_file WHERE imx000 = l_ima01
#                    LET l_rta05 = l_imx00,l_ps,l_imx02,l_ps,l_imx01
#                 ELSE 
#                    LET l_rta05 = l_ima01
#                 END IF
#              ELSE
#                 CALL s_auno(l_gei01,'7','') RETURNING l_rta05,l_ima02
#              END IF
#          END IF
#          SELECT count(*) INTO l_n2 FROM rta_file WHERE rta05 = l_rta05
#          IF l_n2 = 0 THEN 
#             INSERT INTO rta_file(rta01,rta02,rta03,rta04,rta05,rtaacti,rtapos) 
#             VALUES (l_rta01,l_rta02,l_rta03,l_rta04,l_rta05,l_rtaacti,l_rtapos)
#             IF SQLCA.sqlcode THEN
#                CALL cl_err3("ins","rta_file",l_rta05,"",SQLCA.sqlcode,"","",1)
#             ELSE 
#                MESSAGE "insert O.K"
#             END IF
#          ELSE 
#             MESSAGE "The data has existed"
#          END IF
#          LET l_n1 = l_n1 + 1
#       END WHILE
#       CALL cl_end2('1') RETURNING l_flag
#       IF l_flag THEN
#          CLEAR FORM
#          MESSAGE ""
#          CONTINUE WHILE
#       ELSE
#          RETURN
#       END IF
#   ELSE
#      CALL cl_err('','art-889',1)
#   END IF
#  END WHILE
#END FUNCTION
#FUNCTION i111_b_delete()
#DEFINE l_ima01    LIKE ima_file.ima01
#DEFINE l_ima1004  LIKE ima_file.ima1004
#DEFINE l_ima1005  LIKE ima_file.ima1005
#DEFINE l_ima1006  LIKE ima_file.ima1006
#DEFINE l_ima1007  LIKE ima_file.ima1007
#DEFINE l_ima1008  LIKE ima_file.ima1008
#DEFINE l_ima1009  LIKE ima_file.ima1009
#DEFINE l_rta05    LIKE rta_file.rta05
#DEFINE l_rta04    LIKE rta_file.rta04
#DEFINE l_wc,l_sql,l_sql1   STRING
#DEFINE l_n,l_n1,l_n2        LIKE type_file.num5
#   
#   MESSAGE ""
#   CLEAR FORM
#   CONSTRUCT BY NAME l_wc ON ima01,ima1004,ima1005,ima1006,ima1007,ima1008,ima1009,rta05 
#      ON ACTION controlp
#         CASE 
#	    WHEN INFIELD(ima01)
##FUN-AA0059---------mod------------str-----------------	    
##	       CALL cl_init_qry_var()
##	       LET g_qryparam.form = "q_ima"
##	       LET g_qryparam.where = "ima1010 = '1' and imaacti = 'Y'" 
##	       LET g_qryparam.state = "c"
##	       CALL cl_create_qry() RETURNING g_qryparam.multiret
#               CALL q_sel_ima(TRUE, "q_ima"," ima1010 = '1' and imaacti = 'Y'","","","","","","",'')
#                 RETURNING  g_qryparam.multiret
##FUN-AA0059---------mod------------end-----------------
#
#	       DISPLAY g_qryparam.multiret TO ima01
#	       NEXT FIELD ima01
#	    WHEN INFIELD(ima1004)
#	       CALL cl_init_qry_var()
#	       LET g_qryparam.form = "q_tqa"
#	       LET g_qryparam.arg1 = "1"
#	       LET g_qryparam.state = "c"
#	       CALL cl_create_qry() RETURNING g_qryparam.multiret
#	       DISPLAY g_qryparam.multiret TO ima1004
#	       NEXT FIELD ima1004
#	    WHEN INFIELD(ima1005)
#	       CALL cl_init_qry_var()
#	       LET g_qryparam.form = "q_tqa"
#	       LET g_qryparam.arg1 = "2"
#	       LET g_qryparam.state = "c"
#	       CALL cl_create_qry() RETURNING g_qryparam.multiret
#	       DISPLAY g_qryparam.multiret TO ima1005
#	       NEXT FIELD ima1005
#	    WHEN INFIELD(ima1006)
#	       CALL cl_init_qry_var()
#	       LET g_qryparam.form = "q_tqa"
#	       LET g_qryparam.arg1 = "3"
#	       LET g_qryparam.state = "c"
#	       CALL cl_create_qry() RETURNING g_qryparam.multiret
#	       DISPLAY g_qryparam.multiret TO ima1006
#	       NEXT FIELD ima1006
#	    WHEN INFIELD(ima1007)
#	       CALL cl_init_qry_var()
#	       LET g_qryparam.form = "q_tqa"
#	       LET g_qryparam.arg1 = "4"
#	       LET g_qryparam.state = "c"
#	       CALL cl_create_qry() RETURNING g_qryparam.multiret
#	       DISPLAY g_qryparam.multiret TO ima1007
#	       NEXT FIELD ima1007
#	    WHEN INFIELD(ima1008)
#	       CALL cl_init_qry_var()
#	       LET g_qryparam.form = "q_tqa"
#	       LET g_qryparam.arg1 = "5"
#	       LET g_qryparam.state = "c"
#	       CALL cl_create_qry() RETURNING g_qryparam.multiret
#	       DISPLAY g_qryparam.multiret TO ima1008
#	       NEXT FIELD ima1008
#	    WHEN INFIELD(ima1009)
#	       CALL cl_init_qry_var()
#	       LET g_qryparam.form = "q_tqa"
#	       LET g_qryparam.arg1 = "6"
#	       LET g_qryparam.state = "c"
#	       CALL cl_create_qry() RETURNING g_qryparam.multiret
#	       DISPLAY g_qryparam.multiret TO ima1009
#	       NEXT FIELD ima1009
#	    WHEN INFIELD(rta05)
#	       CALL cl_init_qry_var()
#	       LET g_qryparam.form = "q_rta05"
#	       LET g_qryparam.state = "c"
#	       CALL cl_create_qry() RETURNING g_qryparam.multiret
#	       DISPLAY g_qryparam.multiret TO rta05
#	       NEXT FIELD rta05
#         END CASE	   
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#	 CONTINUE CONSTRUCT
#      ON ACTION exit
#         RETURN
#      ON ACTION qbe_select
#         CALL cl_qbe_select()
#      ON ACTION qbe_save
#         CALL cl_qbe_save()
#   END CONSTRUCT	 
#   IF INT_FLAG THEN
#      RETURN
#   END IF
#   INPUT l_rta04 FROM rta04 
#      BEFORE INPUT 
#         LET l_rta04 = ""
#      AFTER FIELD rta04
#         IF l_rta04 IS NULL THEN
#            CALL cl_err('',-1124,1)
#	    NEXT FIELD rta04
#	 ELSE 
#	    DISPLAY BY NAME l_rta04
#	 END IF
#      AFTER INPUT 
#         IF INT_FLAG THEN
#	   RETURN 
#       	 END IF
#      ON ACTION exit
#         RETURN
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#   END INPUT
#   LET l_n1 = 1
#   LET l_wc = l_wc CLIPPED
#   LET l_sql = " SELECT count(ima01) FROM ima_file LEFT OUTER JOIN rta_file ON ima01 = rta01 WHERE ", l_wc
#   LET l_sql1 = " SELECT ima01 FROM ima_file LEFT OUTER JOIN rta_file ON ima01 = rta01 WHERE ", l_wc
#   DECLARE l_cs1 SCROLL CURSOR WITH HOLD FROM l_sql
#   DECLARE l_cs2 SCROLL CURSOR WITH HOLD FROM l_sql1
#   OPEN l_cs1
#   FETCH l_cs1 INTO l_n
#   IF l_n > 0 THEN
#      IF cl_delete() THEN
#          IF(l_rta05 IS NULL) THEN 
#             IF(l_rta04 = '3') THEN
#                 WHILE(l_n1 <= l_n)
#                    IF l_n1 =1 THEN
#                       OPEN l_cs2
#                       FETCH ABSOLUTE 1 l_cs2 INTO l_ima01
#                    ELSE
#                       FETCH NEXT l_cs2 INTO l_ima01
#                    END IF
#                    SELECT count(rta01) INTO l_n2 FROM rta_file WHERE rta01 = l_ima01
#                    IF l_n2 > 0 THEN 
#                       DELETE FROM rta_file WHERE rta01 = l_ima01
#                       IF SQLCA.sqlcode THEN
#                          CALL cl_err3("del","rta_file",l_ima01,"",SQLCA.sqlcode,"","",1)
#                       ELSE
#                          MESSAGE "delete O.K"
#                       END IF
#                    ELSE 
#                       MESSAGE "The column value isn't exite in the rta_file"
#                    END IF
#                    LET l_n1 = l_n1 + 1
#                 END WHILE
#             ELSE
#                 WHILE(l_n1 <= l_n)
#                    IF l_n1 =1 THEN
#                       OPEN l_cs2
#                       FETCH ABSOLUTE 1 l_cs2 INTO l_ima01
#                    ELSE
#                       FETCH NEXT l_cs2 INTO l_ima01
#                    END IF
#                    SELECT count(rta01) INTO l_n2 FROM rta_file WHERE rta01 = l_ima01
#                    IF l_n2 > 0 THEN 
#                       DELETE FROM rta_file WHERE rta04 = l_rta04 AND rta01 = l_ima01
#                       IF SQLCA.sqlcode THEN
#                          CALL cl_err3("del","rta_file",l_ima01,"",SQLCA.sqlcode,"","",1)
#                       ELSE 
#                          MESSAGE "delete O.K"
#                       END IF
#                    ELSE 
#                       MESSAGE "The column value isn't exite in the rta_file"
#                    END IF
#                    LET l_n1 = l_n1 + 1
#                 END WHILE
#             END IF
#          ELSE
#             DELETE FROM rta_file WHERE rta05 = l_rta05
#             IF SQLCA.sqlcode THEN
#                CALL cl_err3("del","rta_file",l_ima01,"",SQLCA.sqlcode,"","",1)
#             ELSE 
#                MESSAGE "delete O.K"
#             END IF          
#          END IF
#      END IF
#   ELSE
#      CALL cl_err('','art-889',1)
#   END IF
#END FUNCTION
#No.FUN-A50011 -----end-----
#TQC-AC0269 --End

