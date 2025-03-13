# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: artt131.4gl
# Descriptions...: 採購協議調整單
# Date & Author..: No:FUN-870006 08/07/28 By  Sunyanchun
# Modify.........: No:FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-870007 09/12/09 By Cockroach PASS NO.
# Modify.........: No:TQC-A10128 10/01/18 By Cockroach 添加g_data_plant管控 
# Modify.........: No:TQC-A20003 10/02/03 By Cockroach 開放商品錄入，非當前采購協議里的商品亦可錄入
# Modify.........: No:FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:TQC-A30029 10/03/12 By Cockroach 確認時未帶出審核人員及其名稱
# Modify.........: No:TQC-A30041 10/03/16 By Cockroach add oriu/orig
# Modify.........: No:FUN-A50102 10/06/09 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-A70130 10/08/06 By shaoyong  ART單據性質調整
# Modify.........: No:FUN-A70130 10/08/11 By huangtao 修改q_oay*()的參數
# Modify.........: No:FUN-AA0059 10/10/28 By huangtao 修改料號的管控
# Modify.........: No:TQC-AB0221 10/11/29 By shenyang GP5.2 SOP流程修改
# Modify.........: No:TQC-AC0112 10/12/16 By huangtao 單頭新增稅別稅率等，修改變更審核
# Modify.........: No:FUN-B30084 11/03/18 By huangtao 增加變更發出、取消審核、狀態碼
# Modify.........: No:MOD-B30708 11/03/30 By lilingyu rtw14(調整人(供應商)),拿掉其欄位值控管
# Modify.........: No:TQC-B40117 11/04/14 By huangtao 當前營運中心採購協議更新失敗
# Modify.........: No:FUN-B40031 11/04/20 By shiwuying 增加协议生效、截止日期
# Modify.........: No:TQC-B50149 11/05/26 By shiwuying Bug修改及功能调整
# Modify.........: No.FUN-B50064 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80085 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外 
# Modify.........: No.FUN-B90094 11/09/13 By pauline 修改錯誤訊息內容

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:TQC-C20197 12/02/16 by fanbj 單身新增，料號應符合採購合約中限定的產品分類和品牌
# Modify.........: No.FUN-C30226 12/03/19 By pauline 有效日期應控卡於合約生效期內
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C80046 12/08/17 By bart 複製後停在新資料畫面
# Modify.........: No.TQC-C60107 12/09/17 By SunLM 判断和生成是否,新增加的营运中心没有对应的采购协议
# Modify.........: No.CHI-C80041 12/11/28 By bart 取消單頭資料控制
# Modify.........: No.FUN-C10018 12/12/21 By pauline 確認變更發出後自動產生artt111的資料
# Modify.........: No:FUN-D20039 13/01/20 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」
# Modify.........: No.CHI-D20015 13/03/26 By xumm 取消確認賦值確認異動時間和人員
# Modify.........: No.TQC-D40024 13/04/11 By chenjing 修改取消審核報錯問題
# Modify.........: No:FUN-D30033 13/04/12 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#Module Variables
DEFINE g_rtw         RECORD LIKE rtw_file.*,
       g_rtw_t       RECORD LIKE rtw_file.*,
       g_rtw_o       RECORD LIKE rtw_file.*,
#TQC-AC0112 -------------STA
       g_rts06       LIKE rts_file.rts06,
       g_gec04       LIKE gec_file.gec04,
       g_gec07       LIKE gec_file.gec07,
#TQC-AC0112 -------------END
       g_rtw01_t     LIKE rtw_file.rtw01,
       g_rtw02_t     LIKE rtw_file.rtw02,
       g_rtwplant_t    LIKE rtw_file.rtwplant,
       g_t1          LIKE oay_file.oayslip,
       g_sheet       LIKE oay_file.oayslip,
       g_ydate       LIKE type_file.dat,
       g_rtx         DYNAMIC ARRAY OF RECORD
           rtx03          LIKE rtx_file.rtx03,
           rtx04          LIKE rtx_file.rtx04,
           ima02          LIKE ima_file.ima02,
           ima021         LIKE ima_file.ima021,
           ima1004        LIKE ima_file.ima1004,
           ima1005        LIKE ima_file.ima1005,
           ima1009        LIKE ima_file.ima1009,
           ima1007        LIKE ima_file.ima1007,
           rtx05          LIKE rtx_file.rtx05,
           rtx05_desc     LIKE gfe_file.gfe02,
           rtx06          LIKE rtx_file.rtx06,
           rtx07          LIKE rtx_file.rtx07,
           rtx08          LIKE rtx_file.rtx08,
           rtx09          LIKE rtx_file.rtx09,
           rtx10          LIKE rtx_file.rtx10,
           rtx11          LIKE rtx_file.rtx11,
           rtx12          LIKE rtx_file.rtx12,
           rtx13          LIKE rtx_file.rtx13,
           rtx14          LIKE rtx_file.rtx14,
           rtx15          LIKE rtx_file.rtx15,
           rtx16          LIKE rtx_file.rtx16,
           rtx17          LIKE rtx_file.rtx17,
           rtx18          LIKE rtx_file.rtx18,
           rtx19          LIKE rtx_file.rtx19,
           rtx20          LIKE rtx_file.rtx20           
                     END RECORD,
       g_rtx_t       RECORD
           rtx03          LIKE rtx_file.rtx03,
           rtx04          LIKE rtx_file.rtx04,
           ima02          LIKE ima_file.ima02,
           ima021         LIKE ima_file.ima021,
           ima1004        LIKE ima_file.ima1004,
           ima1005        LIKE ima_file.ima1005,
           ima1009        LIKE ima_file.ima1009,
           ima1007        LIKE ima_file.ima1007,
           rtx05          LIKE rtx_file.rtx05,
           rtx05_desc     LIKE gfe_file.gfe02,
           rtx06          LIKE rtx_file.rtx06,
           rtx07          LIKE rtx_file.rtx07,
           rtx08          LIKE rtx_file.rtx08,
           rtx09          LIKE rtx_file.rtx09,
           rtx10          LIKE rtx_file.rtx10,
           rtx11          LIKE rtx_file.rtx11,
           rtx12          LIKE rtx_file.rtx12,
           rtx13          LIKE rtx_file.rtx13,
           rtx14          LIKE rtx_file.rtx14,
           rtx15          LIKE rtx_file.rtx15,
           rtx16          LIKE rtx_file.rtx16,
           rtx17          LIKE rtx_file.rtx17,
           rtx18          LIKE rtx_file.rtx18,
           rtx19          LIKE rtx_file.rtx19,
           rtx20          LIKE rtx_file.rtx20 
                     END RECORD,
       g_rtx_o       RECORD 
           rtx03          LIKE rtx_file.rtx03,
           rtx04          LIKE rtx_file.rtx04,
           ima02          LIKE ima_file.ima02,
           ima021         LIKE ima_file.ima021,
           ima1004        LIKE ima_file.ima1004,
           ima1005        LIKE ima_file.ima1005,
           ima1009        LIKE ima_file.ima1009,
           ima1007        LIKE ima_file.ima1007,
           rtx05          LIKE rtx_file.rtx05,
           rtx05_desc     LIKE gfe_file.gfe02,
           rtx06          LIKE rtx_file.rtx06,
           rtx07          LIKE rtx_file.rtx07,
           rtx08          LIKE rtx_file.rtx08,
           rtx09          LIKE rtx_file.rtx09,
           rtx10          LIKE rtx_file.rtx10,
           rtx11          LIKE rtx_file.rtx11,
           rtx12          LIKE rtx_file.rtx12,
           rtx13          LIKE rtx_file.rtx13,
           rtx14          LIKE rtx_file.rtx14,
           rtx15          LIKE rtx_file.rtx15,
           rtx16          LIKE rtx_file.rtx16,
           rtx17          LIKE rtx_file.rtx17,
           rtx18          LIKE rtx_file.rtx18,
           rtx19          LIKE rtx_file.rtx19,
           rtx20          LIKE rtx_file.rtx20 
                     END RECORD,
       g_sql         STRING,
       g_wc          STRING,
       g_wc2         STRING,
       g_rec_b       LIKE type_file.num5,
       l_ac          LIKE type_file.num5
 
DEFINE p_row,p_col         LIKE type_file.num5
#DEFINE g_gec07             LIKE gec_file.gec07
DEFINE g_forupd_sql        STRING
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num5
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE mi_no_ask           LIKE type_file.num5
DEFINE g_argv1             LIKE rtw_file.rtw01
DEFINE g_argv2             STRING 
DEFINE  g_rtz04    LIKE rtz_file.rtz04 #商品策略 #TQC-A20003 ADD
 
MAIN
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
 
   LET g_argv1=ARG_VAL(1)
   LET g_argv2=ARG_VAL(2)
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_forupd_sql = "SELECT * FROM rtw_file WHERE rtw01 = ? AND rtw02 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t131_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 2 LET p_col = 9
 
   OPEN WINDOW t131_w AT p_row,p_col WITH FORM "art/42f/artt131"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()

     SELECT rtz04 INTO g_rtz04 FROM rtz_file   #TQC-A20003 ADD
      WHERE rtz01 = g_plant
 
   IF NOT cl_null(g_argv1) THEN
      CALL t131_q()
   END IF
 
   CALL t131_menu()
   CLOSE WINDOW t131_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t131_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
   CLEAR FORM 
   CALL g_rtx.clear()
  
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = " rtw01 = '",g_argv1,"'"
   ELSE
      CALL cl_set_head_visible("","YES")
      INITIALIZE g_rtw.* TO NULL
      CONSTRUCT BY NAME g_wc ON rtw01,rtw02,rtw03,rtw04,rtw05,rtw06,
                                rtw07,rtw08,rtw09,rtw10,
                               #FUN-B40031 Begin---
                               #rtw11,rtw12,rtw13,rtwplant,rtw14,
                               #rtw15,rtwconf,rtwcond,rtwconu,
                               #rtw900,                                      #FUN-B30084 add
                                rtw11,rtw17,rtw18,rtw12,rtw13,rtw14,rtw15,
                                rtwplant,rtw900,rtwconf,rtwcond,rtwconu,
                               #FUN-B40031 End-----
                              # rtwmksg,rtw16,rtw900,rtwuser,#TQC-AB0221
                                rtw16,rtwuser,        #TQC-AB0221 
                                rtwgrup,rtwmodu,rtwdate,rtwacti,
                                rtwcrat,rtworiu,rtworig      #TQC-A30041 ADD
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(rtw01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rtw01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rtw01
                  NEXT FIELD rtw01
      
               WHEN INFIELD(rtw02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rtw02"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rtw02
                  NEXT FIELD rtw02
                  
               WHEN INFIELD(rtw03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.arg1 = g_plant
                  LET g_qryparam.form ="q_rtw03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rtw03
                  NEXT FIELD rtw03
       
               WHEN INFIELD(rtwconu)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                        
                  LET g_qryparam.form ="q_rtwconu"                                                                                    
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO rtwconu                                                                              
                  NEXT FIELD rtwconu

#MOD-B30708 --begin--                  
#               WHEN INFIELD(rtw14)
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state = 'c'
#                  LET g_qryparam.form ="q_rtw14"
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO rtw14
#                  NEXT FIELD rtw14
#MOD-B30708 --end--                  
                  
               WHEN INFIELD(rtw15)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rtw15"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rtw15
                  NEXT FIELD rtw15
                  
               WHEN INFIELD(rtwplant)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_azp"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rtwplant
                  NEXT FIELD rtwplant
               OTHERWISE EXIT CASE
            END CASE
      
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
      
         ON ACTION about
            CALL cl_about()
      
         ON ACTION HELP
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
   END IF
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN
   #      LET g_wc = g_wc clipped," AND rtwuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN
   #      LET g_wc = g_wc clipped," AND rtwgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN
   #      LET g_wc = g_wc clipped," AND rtwgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rtwuser', 'rtwgrup')
   #End:FUN-980030
 
   IF NOT cl_null(g_argv1) THEN
      LET g_wc2 = ' 1=1'     
   ELSE
      CONSTRUCT g_wc2 ON rtx03,rtx04,rtx05,rtx06,rtx07,rtx08,
                         rtx09,rtx10,rtx11,rtx12,rtx13,rtx14,
                         rtx15,rtx16,rtx17,rtx18,rtx19,rtx20
              FROM s_rtx[1].rtx03,s_rtx[1].rtx04,s_rtx[1].rtx05,
                   s_rtx[1].rtx06,s_rtx[1].rtx07,s_rtx[1].rtx08,
                   s_rtx[1].rtx09,s_rtx[1].rtx10,s_rtx[1].rtx11,
                   s_rtx[1].rtx12,s_rtx[1].rtx13,s_rtx[1].rtx14,
                   s_rtx[1].rtx15,s_rtx[1].rtx16,s_rtx[1].rtx17,
                   s_rtx[1].rtx18,s_rtx[1].rtx19,s_rtx[1].rtx20
 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
   
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(rtx04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rtx04"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rtx04
                  NEXT FIELD rtx04
                  
               WHEN INFIELD(rtx05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rtx05"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rtx05
                  NEXT FIELD rtx05
            END CASE
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
    
         ON ACTION about
            CALL cl_about()
    
         ON ACTION HELP
            CALL cl_show_help()
    
         ON ACTION controlg
            CALL cl_cmdask()
    
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END CONSTRUCT
   
      IF INT_FLAG THEN
         RETURN
      END IF
    END IF
 
   IF g_wc2 = " 1=1" THEN
      LET g_sql = "SELECT rtw01,rtw02 FROM rtw_file ",
                  " WHERE rtwplant IN ",g_auth," AND ",g_wc CLIPPED,
                  " ORDER BY rtw01"
   ELSE
      LET g_sql = "SELECT UNIQUE rtw01,rtw02,rtwplant ",
                  "  FROM rtw_file, rtx_file ",
                  " WHERE rtw01 = rtx01 AND rtw02=rtx02 AND rtwplant=rtxplant ",
                  "   AND rtwplant IN ",g_auth," AND ",g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                  " ORDER BY rtw01"
   END IF
 
   PREPARE t131_prepare FROM g_sql
   DECLARE t131_cs
       SCROLL CURSOR WITH HOLD FOR t131_prepare
 
   IF g_wc2 = " 1=1" THEN
      LET g_sql="SELECT COUNT(*) FROM rtw_file WHERE rtwplant IN ",g_auth," AND ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(*) FROM rtw_file,rtx_file WHERE ",
                "rtx01=rtw01 AND AND rtw02=rtx02 AND rtwplant=rtxplant AND ",
                "rtwplant IN ",g_auth," AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
 
   PREPARE t131_precount FROM g_sql
   DECLARE t131_count CURSOR FOR t131_precount
 
END FUNCTION
 
FUNCTION t131_menu()
   DEFINE l_partnum    STRING
   DEFINE l_supplierid STRING
   DEFINE l_status     LIKE type_file.num10
 
   WHILE TRUE
      CALL t131_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t131_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t131_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
                  CALL t131_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
                  CALL t131_u()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
                  CALL t131_x()
            END IF
 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
                  CALL t131_copy()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
                  CALL t131_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
     #   WHEN "output"                    #TQC-AB0221
     #      IF cl_chk_act_auth() THEN     #TQC-AB0221
     #         CALL t131_out()            #TQC-AB0221 
     #      END IF                        #TQC-AB0221
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
   
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
                  CALL t131_yes()
            END IF
#FUN-B30084 -------------STA
        WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t131_z()
            END IF
#FUN-B30084 -------------END 
 
        WHEN "void"
            IF cl_chk_act_auth() THEN
                  CALL t131_void(1)
            END IF

        #FUN-D20039 --------------sta
        WHEN "undo_void"
            IF cl_chk_act_auth() THEN
                  CALL t131_void(2)
            END IF
        #FUN-D20039 --------------end
 
#FUN-B30084 -------------STA
        WHEN "change_post"
            IF cl_chk_act_auth() THEN
               CALL t131_post()
            END IF

#FUN-B30084 -------------END
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rtx),'','')
            END IF
            
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_rtw.rtw01 IS NOT NULL THEN
                 LET g_doc.column1 = "rtw01"
                 LET g_doc.value1 = g_rtw.rtw01
                 CALL cl_doc()
               END IF
         END IF
         
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t131_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rtx TO s_rtx.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
 
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
 
      ON ACTION first
         CALL t131_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL t131_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL t131_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL t131_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL t131_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
   #  ON ACTION output                  #TQC-AB0221
   #     LET g_action_choice="output"   #TQC-AB0221
   #     EXIT DISPLAY                   #TQC-AB0221
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
 
#FUN-B30084 ----------------STA
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
#FUN-B30084 ----------------END

      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
          
      #FUN-D20039 -------------sta     
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20039 -------------end
 
#FUN-B30084 ----------------STA
      ON ACTION change_post
         LET g_action_choice="change_post"
         EXIT DISPLAY

#FUN-B30084 ----------------END
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
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls       
         CALL cl_set_head_visible("","AUTO")
 
      ON ACTION related_document
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION t131_yes()
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_gen02    LIKE gen_file.gen02 
DEFINE l_rts02    LIKE rts_file.rts02
DEFINE l_azp03    LIKE azp_file.azp03
DEFINE l_rtoplant   LIKE rto_file.rtoplant
DEFINE l_rtx      RECORD LIKE rtx_file.*
DEFINE l_count    LIKE type_file.num5
DEFINE l_rto02    LIKE rtp_file.rtp02
DEFINE l_n        LIKE type_file.num5   #TQC-A20003 ADD 
DEFINE l_rts06    LIKE rts_file.rts06
DEFINE l_rts07    LIKE rts_file.rts07
DEFINE l_rtt06    LIKE rtt_file.rtt06
DEFINE l_rtt06t   LIKE rtt_file.rtt06t
DEFINE l_gec07    LIKE gec_file.gec07

   IF g_rtw.rtw01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
#CHI-C30107 --------------- add ----------------- begin
   IF g_rtw.rtwconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rtw.rtwconf = 'X' THEN CALL cl_err(g_rtw.rtw01,'art-868',0) RETURN END IF  
   IF g_rtw.rtwacti = 'N' THEN CALL cl_err('','art-145',0) RETURN END IF
   IF NOT cl_confirm('art-026') THEN RETURN END IF
#CHI-C30107 --------------- add ----------------- end
   SELECT * INTO g_rtw.* FROM rtw_file WHERE rtw01=g_rtw.rtw01
   IF g_rtw.rtwconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
 #  IF g_rtw.rtwconf = 'X' THEN CALL cl_err(g_rtw.rtw01,'9024',0) RETURN END IF     #FUN-B90094 mark 
   IF g_rtw.rtwconf = 'X' THEN CALL cl_err(g_rtw.rtw01,'art-868',0) RETURN END IF     #FUN-B90094 add
   IF g_rtw.rtwacti = 'N' THEN CALL cl_err('','art-145',0) RETURN END IF
 
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM rtx_file
    WHERE rtx01=g_rtw.rtw01 AND rtx02=g_rtw.rtw02 
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
 
#  IF NOT cl_confirm('art-026') THEN RETURN END IF #CHI-C30107 mark
   LET g_success = 'Y'
#FUN-B30084 -----------------mark
#  LET g_sql = "SELECT * FROM rtx_file WHERE rtx01='",g_rtw.rtw01,
#              "' AND rtx02='",g_rtw.rtw02,"' AND rtxplant='",g_rtw.rtwplant,"'"
#  
#  PREPARE t131_pbx FROM g_sql
#  DECLARE rtx_cur CURSOR FOR t131_pbx
#  LET g_cnt = 1
#  BEGIN WORK 
#  LET g_success = 'Y'
#
#  #獲取當前協議的簽定機構
#  #SELECT A.rts02 INTO l_rts02 FROM rts_file A WHERE A.rts01=g_rtw.rtw03
#  #   AND A.rtsplant=g_rtw.rtwplant AND A.rts03 = 
#  #   (SELECT MAX(rts03) FROM rts_file B
#  #       WHERE A.rts01=B.rts01 AND A.rtsplant=B.rtsplant GROUP BY B.rts01,B.rtsplant)
#  #獲取最大的合同版本號
#  SELECT MAX(rto02) INTO l_rto02 FROM rto_file WHERE rto01=g_rtw.rtw05 AND rto03=g_rtw.rtw02
#      AND rtoplant=g_rtw.rtwplant
#
#  #遍歷單頭合同中所有生效機構
#  #LET g_sql = "SELECT rtp05 FROM rtp_file A WHERE A.rtp01='",g_rtw.rtw05,
#  #            "' AND A.rtp03='",g_rtw.rtwplant,"' AND A.rtpplant='",g_rtw.rtwplant,
#  #            "' AND A.rtp02=(SELECT MAX(rtp02) FROM rtp_file B WHERE ",
#  #            "A.rtp01=B.rtp01 AND A.rtpplant=B.rtpplant AND B.rtp03='",
#  #            l_rts02,"' GROUP BY B.rtp01,B.rtp03,B.rtpplant )"
#  LET g_sql = "SELECT rtoplant FROM rto_file WHERE rto01='",g_rtw.rtw05,                                                          
#              "' AND rto03='",g_rtw.rtw02,                                                      
#              "' AND rto02='",l_rto02,"'"                                                           
#  PREPARE t131_pbp FROM g_sql
#  DECLARE rtp_cur CURSOR FOR t131_pbp
#
#  FOREACH rtp_cur INTO l_rtoplant
#     IF SQLCA.sqlcode THEN
#        CALL cl_err('foreach:',SQLCA.sqlcode,1)
#        EXIT FOREACH
#     END IF
#     #如果有效機構中包含當前機構，不用更新（下面單獨更新）
#     IF l_rtoplant = g_rtw.rtwplant THEN
#        CONTINUE FOREACH
#     END IF
#     #找出當前有效機構的數據庫代碼
#     SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01=l_rtoplant
#     #更新采購協議的版本號                                                                                                         
#     #LET g_sql = "UPDATE ",s_dbstring(l_azp03 CLIPPED),"rts_file SET rts03 = rts03 + 1 ", #FUN-A50102
#     LET g_sql = "UPDATE ",cl_get_target_table(l_rtoplant, 'rts_file')," SET rts03 = rts03 + 1 ", #FUN-A50102
#                 " WHERE rts01='",g_rtw.rtw03,"' AND rts02='",g_rtw.rtw02,
#                 "' AND rtsplant='",l_rtoplant,"'"
#     CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
#     CALL cl_parse_qry_sql(g_sql, l_rtoplant) RETURNING g_sql  #FUN-A50102            
#     PREPARE t131_updrts from g_sql                                                                                             
#     EXECUTE t131_updrts                                                      
#     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN                                                                                 
#        CALL cl_err3("upd","rts_file",g_rtw.rtw03,"",SQLCA.sqlcode,"","",1)                                                        
#        ROLLBACK WORK                                                                                                              
#        RETURN                                                                                                                     
#     END IF
#     #取出調整單單身中所有的商品，更新采購協議
#     FOREACH rtx_cur INTO l_rtx.*
#        IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#        END IF
#        IF cl_null(l_rtx.rtx08) THEN LET l_rtx.rtx08 = 0 END IF
#        IF cl_null(l_rtx.rtx09) THEN LET l_rtx.rtx09 = 0 END IF
#        IF cl_null(l_rtx.rtx10) THEN LET l_rtx.rtx10 = 0 END IF
#        IF cl_null(l_rtx.rtx11) THEN LET l_rtx.rtx11 = 0 END IF
#        IF cl_null(l_rtx.rtx12) THEN LET l_rtx.rtx12 = 0 END IF
#        IF cl_null(l_rtx.rtx16) THEN LET l_rtx.rtx16 = 0 END IF
#        IF cl_null(l_rtx.rtx14) THEN LET l_rtx.rtx14 = 0 END IF
#        IF cl_null(l_rtx.rtx18) THEN LET l_rtx.rtx18 = 0 END IF

#        #TQC-A20003-------------------------------------------------------------------------
#        # 若單身此筆不在原采購協議rtt_file中，則INSERT!
#        SELECT COUNT(*) INTO l_n FROM rtt_file 
#         WHERE rtt01=g_rtw.rtw03 AND rtt02=g_rtw.rtw02 
#           AND rtt04=l_rtx.rtx04 AND rttplant=l_rtoplant
#        IF l_n=0 OR cl_null(l_n) THEN
#           SELECT MAX(rtt03) INTO l_n FROM rtt_file
#            WHERE rtt01=g_rtw.rtw03 AND rtt02=g_rtw.rtw02
#              AND rttplant =l_rtoplant
#           LET l_n=l_n + 1
#           SELECT rttlegal INTO l_rtx.rtxlegal FROM rtt_file
#            WHERE rtt01=g_rtw.rtw03 AND rtt02=g_rtw.rtw02
#              AND rtt03='1' AND rttplant=l_rtoplant 
#           
#           IF g_rtw.rtw07 ='1' OR g_rtw.rtw07='2' THEN  
#              SELECT rts06,rts07 INTO l_rts06,l_rts07 FROM rts_file
#               WHERE rts01 = g_rtw.rtw03 AND rts02=g_rtw.rtw02
#                 AND rts03 = g_rtw.rtw04 AND rtsplant=l_rtoplant

#              IF NOT cl_null(l_rts06) THEN
#                 SELECT gec07 INTO l_gec07 FROM gec_file
#                  WHERE gec01=l_rts06 AND gec011 = '1'
#                 IF cl_null(l_gec07) THEN LET l_gec07 ='N' END IF
#                 IF l_gec07='Y' THEN
#                    LET l_rtt06 = l_rtx.rtx08  
#                    LET l_rtt06t= l_rtx.rtx08 * (1+l_rts07/100)
#                 ELSE
#                    LET l_rtt06t= l_rtx.rtx08
#                    LET l_rtt06 = l_rtx.rtx08 / (1+l_rts07/100)
#                 END IF
#              END IF      
#           ELSE 
#              LET l_rtt06 = 0
#              LET l_rtt06t= 0
#           END IF
#           INSERT INTO rtt_file(rtt01,rtt02,rtt03,rtt04,rtt05,rtt06,rtt06t,rtt07,rtt08,
#                                rtt09,rtt10,rtt11,rtt12,rtt13,rtt14,rtt15,rttplant,rttlegal) 
#                         VALUES(g_rtw.rtw03,g_rtw.rtw02,l_n,l_rtx.rtx04,l_rtx.rtx05,
#                                l_rtt06,l_rtt06t,l_rtx.rtx09,l_rtx.rtx10,l_rtx.rtx11,
#                                l_rtx.rtx12,l_rtx.rtx14,l_rtx.rtx16,l_rtx.rtx18,l_rtx.rtx05,
#                                'Y',l_rtoplant,l_rtx.rtxlegal)
#        END IF 

#        #TQC-A20003 ADD END-----------------------------------------------------------------
#        #更新采購協議                                                                                                        
#        #LET g_sql = "UPDATE ",s_dbstring(l_azp03 CLIPPED),"rtt_file SET rtt06 ='" CLIPPED,l_rtx.rtx08, #FUN-A50102
#    #TQC-AC0112 -------------------STA
#    #   LET g_sql = "UPDATE ",cl_get_target_table(l_rtoplant, 'rtt_file')," SET rtt06 ='" CLIPPED,l_rtx.rtx08,  #FUN-A50102
#    #                                "',rtt07 ='" CLIPPED,l_rtx.rtx09,                                                                                
#    #                                "', rtt08 ='" CLIPPED,l_rtx.rtx10,"',rtt09 ='" CLIPPED,l_rtx.rtx11,
#    #                                "', rtt10 ='" CLIPPED,l_rtx.rtx12,"',rtt12 ='" CLIPPED,l_rtx.rtx16,
#    #                                "', rtt13 ='" CLIPPED,l_rtx.rtx18,"',rtt15 ='" CLIPPED,l_rtx.rtx20,
#    #                                "',rtt11='" CLIPPED,l_rtx.rtx14,                                                       
#    #               "' WHERE rtt01='",g_rtw.rtw03,"' AND rtt02='",g_rtw.rtw02,                                              
#    #               "' AND rtt04='",l_rtx.rtx04,"' AND rttplant='",l_rtoplant,"'"
#        IF g_gec07 = 'Y' THEN
#            LET g_sql = "UPDATE ",cl_get_target_table(l_rtoplant, 'rtt_file')," SET rtt06t ='" CLIPPED,l_rtx.rtx08, 
#                                     "',rtt06 ='" CLIPPED,l_rtx.rtx08/(1+g_gec04/100),
#                                     "',rtt07 ='" CLIPPED,l_rtx.rtx09,
#                                     "', rtt08 ='" CLIPPED,l_rtx.rtx10,"',rtt09 ='" CLIPPED,l_rtx.rtx11,
#                                     "', rtt10 ='" CLIPPED,l_rtx.rtx12,"',rtt12 ='" CLIPPED,l_rtx.rtx16,
#                                     "', rtt13 ='" CLIPPED,l_rtx.rtx18,"',rtt15 ='" CLIPPED,l_rtx.rtx20,
#                                     "',rtt11='" CLIPPED,l_rtx.rtx14,
#                    "' WHERE rtt01='",g_rtw.rtw03,"' AND rtt02='",g_rtw.rtw02,
#                    "' AND rtt04='",l_rtx.rtx04,"' AND rttplant='",l_rtoplant,"'"
#        ELSE
#            LET g_sql = "UPDATE ",cl_get_target_table(l_rtoplant, 'rtt_file')," SET rtt06 ='" CLIPPED,l_rtx.rtx08,  
#                                     "',rtt06t ='" CLIPPED,l_rtx.rtx08*(1+g_gec04/100),
#                                     "',rtt07 ='" CLIPPED,l_rtx.rtx09,
#                                     "', rtt08 ='" CLIPPED,l_rtx.rtx10,"',rtt09 ='" CLIPPED,l_rtx.rtx11,
#                                     "', rtt10 ='" CLIPPED,l_rtx.rtx12,"',rtt12 ='" CLIPPED,l_rtx.rtx16,
#                                     "', rtt13 ='" CLIPPED,l_rtx.rtx18,"',rtt15 ='" CLIPPED,l_rtx.rtx20,
#                                     "',rtt11='" CLIPPED,l_rtx.rtx14,
#                    "' WHERE rtt01='",g_rtw.rtw03,"' AND rtt02='",g_rtw.rtw02,
#                    "' AND rtt04='",l_rtx.rtx04,"' AND rttplant='",l_rtoplant,"'"
#        END IF
#     #TQC-AC0112 -------------------END
#        CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
#        CALL cl_parse_qry_sql(g_sql, l_rtoplant) RETURNING g_sql    #FUN-A50102
#        PREPARE t131_updrtt from g_sql
#        EXECUTE t131_updrtt
#        
#        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#           CALL cl_err3("upd","rtt_file",g_rtw.rtw03,"",SQLCA.sqlcode,"","",1)
#           ROLLBACK WORK
#           RETURN
#        END IF
#     END FOREACH
#  END FOREACH
#
# #更新當前機構采購協議
# #找出當前有效機構的數據庫代碼                                                                                               
# SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01=g_rtw.rtwplant                                                                   
# #更新協議的版本號                                                                                                                
# #LET g_sql = "UPDATE ",s_dbstring(l_azp03 CLIPPED),"rts_file SET rts03 = rts03 + 1", #FUN-A50102
# LET g_sql = "UPDATE ",cl_get_target_table(l_rtoplant, 'rts_file')," SET rts03 = rts03 + 1", #FUN-A50102
#             " WHERE rts01='",g_rtw.rtw03,"' AND rts02='",g_rtw.rtw02,
#             "' AND rtsplant='",g_rtw.rtwplant,"'" 
# CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
# CALL cl_parse_qry_sql(g_sql, l_rtoplant) RETURNING g_sql    #FUN-A50102
# PREPARE t131_updrts_2 from g_sql   
# EXECUTE t131_updrts_2                                                    
# IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN                                                                                    
#    CALL cl_err3("upd","rtsile",g_rtw.rtw03,"",SQLCA.sqlcode,"","",1)                                                           
#    ROLLBACK WORK                                                                                                                 
#    RETURN                                                                                                                        
# END IF
#
# FOREACH rtx_cur INTO l_rtx.*
#    IF SQLCA.sqlcode THEN
#         CALL cl_err('foreach:',SQLCA.sqlcode,1)
#         EXIT FOREACH
#    END IF
#    IF cl_null(l_rtx.rtx08) THEN LET l_rtx.rtx08 = 0 END IF                                                                    
#    IF cl_null(l_rtx.rtx09) THEN LET l_rtx.rtx09 = 0 END IF                                                                    
#    IF cl_null(l_rtx.rtx10) THEN LET l_rtx.rtx10 = 0 END IF                                                                    
#    IF cl_null(l_rtx.rtx11) THEN LET l_rtx.rtx11 = 0 END IF                                                                    
#    IF cl_null(l_rtx.rtx12) THEN LET l_rtx.rtx12 = 0 END IF                                                                    
#    IF cl_null(l_rtx.rtx16) THEN LET l_rtx.rtx16 = 0 END IF                                                                    
#    IF cl_null(l_rtx.rtx14) THEN LET l_rtx.rtx14 = 0 END IF                                                                    
#    IF cl_null(l_rtx.rtx18) THEN LET l_rtx.rtx18 = 0 END IF 
#
#    #TQC-A20003-------------------------------------------------------------------------
#    # 若單身此筆不在原采購協議rtt_file中，則INSERT!
#    SELECT COUNT(*) INTO l_n FROM rtt_file 
#     WHERE rtt01=g_rtw.rtw03 AND rtt02=g_rtw.rtw02 
#       AND rtt04=l_rtx.rtx04 AND rttplant=g_rtw.rtwplant
#    IF l_n=0 OR cl_null(l_n) THEN
#       SELECT MAX(rtt03) INTO l_n FROM rtt_file
#        WHERE rtt01=g_rtw.rtw03 AND rtt02=g_rtw.rtw02
#          AND rttplant=g_rtw.rtwplant
#       LET l_n=l_n + 1

#       IF g_rtw.rtw07 ='1' OR g_rtw.rtw07='2' THEN  
#          SELECT rts06,rts07 INTO l_rts06,l_rts07 FROM rts_file
#           WHERE rts01 = g_rtw.rtw03 AND rts02=g_rtw.rtw02
#             AND rts03 = g_rtw.rtw04 AND rtsplant=g_rtw.rtwplant

#          IF NOT cl_null(l_rts06) THEN
#             SELECT gec07 INTO l_gec07 FROM gec_file
#              WHERE gec01=l_rts06 AND gec011 = '1'
#             IF cl_null(l_gec07) THEN LET l_gec07 ='N' END IF
#             IF l_gec07='Y' THEN
#                LET l_rtt06 = l_rtx.rtx08  
#                LET l_rtt06t= l_rtx.rtx08 * (1+l_rts07/100)
#             ELSE
#                LET l_rtt06t= l_rtx.rtx08
#                LET l_rtt06 = l_rtx.rtx08 / (1+l_rts07/100)
#             END IF
#          END IF      
#       ELSE 
#          LET l_rtt06 = 0
#          LET l_rtt06t= 0
#       END IF
#       INSERT INTO rtt_file(rtt01,rtt02,rtt03,rtt04,rtt05,rtt06,rtt06t,rtt07,rtt08,
#                            rtt09,rtt10,rtt11,rtt12,rtt13,rtt14,rtt15,rttplant,rttlegal) 
#                     VALUES(g_rtw.rtw03,g_rtw.rtw02,l_n,l_rtx.rtx04,l_rtx.rtx05,
#                            l_rtt06,l_rtt06t,l_rtx.rtx09,l_rtx.rtx10,l_rtx.rtx11,
#                            l_rtx.rtx12,l_rtx.rtx14,l_rtx.rtx16,l_rtx.rtx18,l_rtx.rtx05,
#                            'Y',g_rtw.rtwplant,l_rtx.rtxlegal)
#    END IF 

#    #TQC-A20003 ADD END-----------------------------------------------------------------
#    #LET g_sql = "UPDATE ",s_dbstring(l_azp03 CLIPPED),"rtt_file SET rtt06 ='",l_rtx.rtx08, #FUN-A50102
# #TQC-AC0112 ----------------STA
# #    LET g_sql = "UPDATE ",cl_get_target_table(l_rtoplant, 'rtt_file')," SET rtt06 ='",l_rtx.rtx08, #FUN-A50102
# #                "', rtt07 ='",l_rtx.rtx09,"',rtt11='",l_rtx.rtx14,                               
# #                "', rtt08 ='",l_rtx.rtx10,"',rtt09='",l_rtx.rtx11,                                           
# #                "', rtt10 ='",l_rtx.rtx12,"',rtt12 ='",l_rtx.rtx16,                                           
# #                "', rtt13 ='",l_rtx.rtx18,"',rtt15 ='",l_rtx.rtx20,                                           
# #                "' WHERE rtt01='",g_rtw.rtw03,"' AND rtt02='",g_rtw.rtw02,                                                         
# #                "' AND rtt04='",l_rtx.rtx04,"' AND rttplant='",g_rtw.rtwplant,"'"
#    IF g_gec07 = 'Y' THEN
#        LET g_sql = "UPDATE ",cl_get_target_table(l_rtoplant, 'rtt_file')," SET rtt06 ='",l_rtx.rtx08/(1+g_gec04/100), 
#                    "', rtt06t ='",l_rtx.rtx08,
#                    "', rtt07 ='",l_rtx.rtx09,"',rtt11='",l_rtx.rtx14,
#                    "', rtt08 ='",l_rtx.rtx10,"',rtt09='",l_rtx.rtx11,
#                    "', rtt10 ='",l_rtx.rtx12,"',rtt12 ='",l_rtx.rtx16,
#                    "', rtt13 ='",l_rtx.rtx18,"',rtt15 ='",l_rtx.rtx20,
#                    "' WHERE rtt01='",g_rtw.rtw03,"' AND rtt02='",g_rtw.rtw02,
#                    "' AND rtt04='",l_rtx.rtx04,"' AND rttplant='",g_rtw.rtwplant,"'"
#    ELSE
#        LET g_sql = "UPDATE ",cl_get_target_table(l_rtoplant, 'rtt_file')," SET rtt06 ='",l_rtx.rtx08,
#                    "', rtt06t ='",l_rtx.rtx08*(1+g_gec04/100),
#                    "', rtt07 ='",l_rtx.rtx09,"',rtt11='",l_rtx.rtx14,
#                    "', rtt08 ='",l_rtx.rtx10,"',rtt09='",l_rtx.rtx11,
#                    "', rtt10 ='",l_rtx.rtx12,"',rtt12 ='",l_rtx.rtx16,
#                    "', rtt13 ='",l_rtx.rtx18,"',rtt15 ='",l_rtx.rtx20,
#                    "' WHERE rtt01='",g_rtw.rtw03,"' AND rtt02='",g_rtw.rtw02,
#                    "' AND rtt04='",l_rtx.rtx04,"' AND rttplant='",g_rtw.rtwplant,"'"
#    END IF
# #TQC-AC0112 ---------------END
#     CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
#     CALL cl_parse_qry_sql(g_sql, l_rtoplant) RETURNING g_sql    #FUN-A50102
#     PREPARE t131_updrts_1 from g_sql                                                                                                  
#     EXECUTE t131_updrts_1
#     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#        CALL cl_err3("upd","rtt_file",g_rtw.rtw03,"",SQLCA.sqlcode,"","",1)
#        ROLLBACK WORK
#        RETURN
#     END IF
#  END FOREACH
#FUN-B30084 -------------------mark 
   BEGIN WORK
   #更新單頭的審核碼、審核日期、審核人
   OPEN t131_cl USING g_rtw.rtw01,g_rtw.rtw02
   
   IF STATUS THEN
      CALL cl_err("OPEN t131_cl:", STATUS, 1)
      CLOSE t131_cl
#      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t131_cl INTO g_rtw.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rtw.rtw01,SQLCA.sqlcode,0)
      CLOSE t131_cl 
#      ROLLBACK WORK 
      RETURN
   END IF
 
   UPDATE rtw_file SET rtwconf='Y',
                       rtw900 = '1',           #FUN-B30084 add
                       rtwcond=g_today, 
                       rtwconu=g_user
     WHERE rtw01=g_rtw.rtw01
       AND rtw02=g_rtw.rtw02 
   IF SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   END IF
 
   IF g_success = 'Y' THEN
      LET g_rtw.rtwconf='Y'
      LET g_rtw.rtwconu=g_user           #TQC-A30029 ADD
      LET g_rtw.rtwcond=g_today          #TQC-A30029 ADD
      CLOSE t131_cl
      COMMIT WORK
      CALL cl_flow_notify(g_rtw.rtw01,'Y')
   ELSE
      CLOSE t131_cl
      ROLLBACK WORK
   END IF
 
   SELECT * INTO g_rtw.* FROM rtw_file 
      WHERE rtw01=g_rtw.rtw01 AND rtw02=g_rtw.rtw02
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rtw.rtwconu
   DISPLAY BY NAME g_rtw.rtwconf                                                                                         
   DISPLAY BY NAME g_rtw.rtwcond                                                                                         
   DISPLAY BY NAME g_rtw.rtwconu
   DISPLAY BY NAME g_rtw.rtw900
   DISPLAY l_gen02 TO FORMONLY.rtwconu_desc
    #CKP
   IF g_rtw.rtwconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_rtw.rtwconf,"","","",g_chr,"")
   CALL cl_flow_notify(g_rtw.rtw01,'V')
END FUNCTION
 
FUNCTION t131_void(p_type)
DEFINE p_type    LIKE type_file.chr1   #FUN-D20039  add '1' 作废  '2' 取消作废
DEFINE l_n LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_rtw.* FROM rtw_file WHERE rtw01=g_rtw.rtw01
   IF g_rtw.rtw01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   #FUN-D20039 ----------sta
    IF p_type = 1 THEN
       IF g_rtw.rtwconf='X' THEN RETURN END IF
    ELSE
       IF g_rtw.rtwconf<>'X' THEN RETURN END IF
    END IF
   #FUN-D20039 ----------end
   IF g_rtw.rtwconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rtw.rtwacti = 'N' THEN CALL cl_err(g_rtw.rtw01,'art-142',0) RETURN END IF
  #IF g_rtw.rtwconf = 'X' THEN CALL cl_err('','art-148',0) RETURN END IF #TQC-AB0221
   BEGIN WORK
 
   OPEN t131_cl USING g_rtw.rtw01,g_rtw.rtw02
   IF STATUS THEN
      CALL cl_err("OPEN t131_cl:", STATUS, 1)
      CLOSE t131_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t131_cl INTO g_rtw.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rtw.rtw01,SQLCA.sqlcode,0)
      CLOSE t131_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   IF cl_void(0,0,g_rtw.rtwconf) THEN
      LET g_chr = g_rtw.rtwconf
      IF g_rtw.rtwconf = 'N' THEN
         LET g_rtw.rtwconf = 'X'
      ELSE
         LET g_rtw.rtwconf = 'N'
      END IF
 
      UPDATE rtw_file SET rtwconf=g_rtw.rtwconf,
                          rtwmodu=g_user,
                          rtwdate=g_today
       WHERE rtw01 = g_rtw.rtw01
         AND rtw02=g_rtw.rtw02 
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("upd","rtw_file",g_rtw.rtw01,"",SQLCA.sqlcode,"","up rtwconf",1)
          LET g_rtw.rtwconf = g_chr
          ROLLBACK WORK
          RETURN
       END IF
   END IF
 
   CLOSE t131_cl
   COMMIT WORK
 
   SELECT * INTO g_rtw.* FROM rtw_file 
      WHERE rtw01=g_rtw.rtw01 AND rtw02=g_rtw.rtw02 
   DISPLAY BY NAME g_rtw.rtwconf                                                                                        
   DISPLAY BY NAME g_rtw.rtwmodu                                                                                        
   DISPLAY BY NAME g_rtw.rtwdate
    #CKP
   IF g_rtw.rtwconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_rtw.rtwconf,"","","",g_chr,"")
 
   CALL cl_flow_notify(g_rtw.rtw01,'V')
END FUNCTION

#FUN-B30084 -------------------STA
FUNCTION t131_post()
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_gen02    LIKE gen_file.gen02
DEFINE l_rts02    LIKE rts_file.rts02
DEFINE l_azp03    LIKE azp_file.azp03
DEFINE l_rtoplant   LIKE rto_file.rtoplant
DEFINE l_rtx      RECORD LIKE rtx_file.*
DEFINE l_count    LIKE type_file.num5
DEFINE l_rto02    LIKE rtp_file.rtp02
DEFINE l_n        LIKE type_file.num5   
DEFINE l_rts06    LIKE rts_file.rts06
DEFINE l_rts07    LIKE rts_file.rts07
DEFINE l_rtt06    LIKE rtt_file.rtt06
DEFINE l_rtt06t   LIKE rtt_file.rtt06t
DEFINE l_gec07    LIKE gec_file.gec07


   IF g_rtw.rtw01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF

   SELECT * INTO g_rtw.* FROM rtw_file WHERE rtw01=g_rtw.rtw01
   IF g_rtw.rtwconf <> 'Y' THEN CALL cl_err(g_rtw.rtw01,'alm-194',0) RETURN END IF
   IF g_rtw.rtw900 = '2' THEN CALL cl_err(g_rtw.rtw01,'alm-937',0) RETURN END IF
   IF g_rtw.rtwacti = 'N' THEN CALL cl_err('','aec-090',0) RETURN END IF

   IF NOT cl_confirm('art-859') THEN RETURN END IF
   ##TQC-C60107 创建临时表
   DROP TABLE rts_temp
   SELECT * FROM rts_file WHERE 1=0 INTO TEMP rts_temp
   DROP TABLE rtt_temp
   SELECT * FROM rtt_file WHERE 1=0 INTO TEMP rtt_temp
   ##TQC-C60107 创建临时表
   LET g_sql = "SELECT * FROM rtx_file WHERE rtx01='",g_rtw.rtw01,
               "' AND rtx02='",g_rtw.rtw02,"' AND rtxplant='",g_rtw.rtwplant,"'"

   PREPARE t131_pbx FROM g_sql
   DECLARE rtx_cur CURSOR FOR t131_pbx
   LET g_cnt = 1
   BEGIN WORK
   LET g_success = 'Y'
   ##TQC-C60107 add此函数用来判断和生成是否,新增加的营运中心没有对应的采购协议
   CALL t131_transfer() #TQC-C60107 add
   #獲取最大的合同版本號
   SELECT MAX(rto02) INTO l_rto02 FROM rto_file WHERE rto01=g_rtw.rtw05 AND rto03=g_rtw.rtw02
       AND rtoplant=g_rtw.rtwplant

   #遍歷單頭合同中所有生效機構
  #FUN-B40031 Begin---
  #LET g_sql = "SELECT rtoplant FROM rto_file WHERE rto01='",g_rtw.rtw05,
  #            " WHERE rto01='",g_rtw.rtw05,
  #            "' AND rto03='",g_rtw.rtw02,
  #            "' AND rto02='",l_rto02,"'"
   LET g_sql = "SELECT DISTINCT rtp05 FROM ",cl_get_target_table(g_rtw.rtw02, 'rtp_file'),
               " WHERE rtp01='",g_rtw.rtw05,"'",
               "   AND rtp02='",l_rto02,"'",
               "   AND rtp03='",g_rtw.rtw02,"'",
               "   AND rtpplant='",g_rtw.rtw02,"'"
  #FUN-B40031 End-----
   PREPARE t131_pbp FROM g_sql
   DECLARE rtp_cur CURSOR FOR t131_pbp
   FOREACH rtp_cur INTO l_rtoplant
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #如果有效機構中包含當前機構，不用更新（下面單獨更新）
      IF l_rtoplant = g_rtw.rtwplant THEN
         CONTINUE FOREACH
      END IF
      #找出當前有效機構的數據庫代碼
      SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01=l_rtoplant
      #更新采購協議的版本號
      #LET g_sql = "UPDATE ",s_dbstring(l_azp03 CLIPPED),"rts_file SET rts03 = rts03 + 1 ", #FUN-A50102
      LET g_sql = "UPDATE ",cl_get_target_table(l_rtoplant, 'rts_file')," SET rts03 = rts03 + 1 ", #FUN-A50102
                                                                        "    ,rts08 = '",g_rtw.rtw17,"'", #FUN-B40031                   
                  " WHERE rts01='",g_rtw.rtw03,"' AND rts02='",g_rtw.rtw02,
                  "' AND rtsplant='",l_rtoplant,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
      CALL cl_parse_qry_sql(g_sql, l_rtoplant) RETURNING g_sql  #FUN-A50102
      PREPARE t131_updrts from g_sql
      EXECUTE t131_updrts
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rts_file",g_rtw.rtw03,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         RETURN
      END IF
      #取出調整單單身中所有的商品，更新采購協議
      FOREACH rtx_cur INTO l_rtx.*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF cl_null(l_rtx.rtx08) THEN LET l_rtx.rtx08 = 0 END IF
         IF cl_null(l_rtx.rtx09) THEN LET l_rtx.rtx09 = 0 END IF
         IF cl_null(l_rtx.rtx10) THEN LET l_rtx.rtx10 = 0 END IF
         IF cl_null(l_rtx.rtx11) THEN LET l_rtx.rtx11 = 0 END IF
         IF cl_null(l_rtx.rtx12) THEN LET l_rtx.rtx12 = 0 END IF
         IF cl_null(l_rtx.rtx16) THEN LET l_rtx.rtx16 = 0 END IF
         IF cl_null(l_rtx.rtx14) THEN LET l_rtx.rtx14 = 0 END IF
         IF cl_null(l_rtx.rtx18) THEN LET l_rtx.rtx18 = 0 END IF
       # 若單身此筆不在原采購協議rtt_file中，則INSERT!
        #FUN-B40031 Begin---
        #SELECT COUNT(*) INTO l_n FROM rtt_file
        # WHERE rtt01=g_rtw.rtw03 AND rtt02=g_rtw.rtw02
        #   AND rtt04=l_rtx.rtx04 AND rttplant=l_rtoplant
         LET l_n=0
         LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_rtoplant, 'rtt_file'),
                     " WHERE rtt01='",g_rtw.rtw03,"' AND rtt02='",g_rtw.rtw02,"'",
                     "   AND rtt04='",l_rtx.rtx04,"' AND rttplant='",l_rtoplant,"'"
         PREPARE t131_sel_rtt FROM g_sql
         EXECUTE t131_sel_rtt INTO l_n
        #FUN-B40031 End-----
         IF l_n=0 OR cl_null(l_n) THEN
           #TQC-B50149 Begin---
           #SELECT MAX(rtt03) INTO l_n FROM rtt_file
           # WHERE rtt01=g_rtw.rtw03 AND rtt02=g_rtw.rtw02
           #   AND rttplant =l_rtoplant
           #LET l_n=l_n + 1
           #SELECT rttlegal INTO l_rtx.rtxlegal FROM rtt_file
           # WHERE rtt01=g_rtw.rtw03 AND rtt02=g_rtw.rtw02
           #   AND rtt03='1' AND rttplant=l_rtoplant
            LET g_sql = "SELECT MAX(rtt03) FROM ",cl_get_target_table(l_rtoplant,'rtt_file'),
                        " WHERE rtt01='",g_rtw.rtw03,"' AND rtt02='",g_rtw.rtw02,"'",
                        "   AND rttplant='",l_rtoplant,"'"
            PREPARE t131_sel_rtt1 FROM g_sql
            EXECUTE t131_sel_rtt1 INTO l_n
            IF cl_null(l_n) THEN LET l_n = 0 END IF
            LET l_n=l_n + 1
            LET g_sql = "SELECT rttlegal FROM ",cl_get_target_table(l_rtoplant,'rtt_file'),
                        " WHERE rtt01='",g_rtw.rtw03,"' AND rtt02='",g_rtw.rtw02,"'",
                        "   AND rtt03='1' AND rttplant='",l_rtoplant,"'"
            PREPARE t131_sel_rtt2 FROM g_sql
            EXECUTE t131_sel_rtt2 INTO l_rtx.rtxlegal
           #TQC-B50149 End-----
            IF g_rtw.rtw07 ='1' OR g_rtw.rtw07='2' THEN
              #TQC-B50149 Begin---
              #SELECT rts06,rts07 INTO l_rts06,l_rts07 FROM rts_file
              # WHERE rts01 = g_rtw.rtw03 AND rts02=g_rtw.rtw02
              #   AND rts03 = g_rtw.rtw04 AND rtsplant=l_rtoplant
               LET g_sql = " SELECT rts06,rts07 FROM ",cl_get_target_table(l_rtoplant,'rts_file'),
                           "  WHERE rts01 = '",g_rtw.rtw03,"' AND rts02='",g_rtw.rtw02,"'",
                           "    AND rts03 = '",g_rtw.rtw04,"' AND rtsplant='",l_rtoplant,"'"
               PREPARE t131_sel_rts3 FROM g_sql
               EXECUTE t131_sel_rts3 INTO l_rts06,l_rts07
              #TQC-B50149 End-----
               IF NOT cl_null(l_rts06) THEN
                  SELECT gec07 INTO l_gec07 FROM gec_file
                   WHERE gec01=l_rts06 AND gec011 = '1'
                  IF cl_null(l_gec07) THEN LET l_gec07 ='N' END IF
                  IF l_gec07='Y' THEN
                     LET l_rtt06 = l_rtx.rtx08
                     LET l_rtt06t= l_rtx.rtx08 * (1+l_rts07/100)
                  ELSE
                     LET l_rtt06t= l_rtx.rtx08
                     LET l_rtt06 = l_rtx.rtx08 / (1+l_rts07/100)
                  END IF
               END IF
            ELSE
               LET l_rtt06 = 0
               LET l_rtt06t= 0
            END IF
           #TQC-B50149 Begin---
           #INSERT INTO rtt_file(rtt01,rtt02,rtt03,rtt04,rtt05,rtt06,rtt06t,rtt07,rtt08,
           #                     rtt16,  #FUN-B40031
           #                     rtt09,rtt10,rtt11,rtt12,rtt13,rtt14,rtt15,rttplant,rttlegal)
           #              VALUES(g_rtw.rtw03,g_rtw.rtw02,l_n,l_rtx.rtx04,l_rtx.rtx05,
           #                     l_rtt06,l_rtt06t,l_rtx.rtx09,l_rtx.rtx10,
           #                     g_rtw.rtw04+1,l_rtx.rtx11,   #FUN-B40031
           #                     l_rtx.rtx12,l_rtx.rtx14,l_rtx.rtx16,l_rtx.rtx18,l_rtx.rtx05,
           #                     'Y',l_rtoplant,l_rtx.rtxlegal)
            LET g_rtw.rtw04 = g_rtw.rtw04 + 1
            LET g_sql = "INSERT INTO ",cl_get_target_table(l_rtoplant,'rtt_file'),
                        "  (rtt01,rtt02,rtt03,rtt04,rtt05,rtt06,rtt06t,",
                        "   rtt07,rtt08,rtt16,rtt09,rtt10,rtt11,rtt12,",
                        "   rtt13,rtt14,rtt15,rttplant,rttlegal) ",
                        "VALUES(?,?,?,?,?,?,?, ?,?,?,?,?,?,?, ?,?,?,?,?)"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,l_rtoplant) RETURNING g_sql
            PREPARE ins_rtt_p FROM g_sql
            EXECUTE ins_rtt_p USING g_rtw.rtw03,g_rtw.rtw02,l_n,l_rtx.rtx04,l_rtx.rtx05,
                                    l_rtt06,l_rtt06t,l_rtx.rtx09,l_rtx.rtx10,g_rtw.rtw04,
                                    l_rtx.rtx11,l_rtx.rtx12,l_rtx.rtx14,l_rtx.rtx16,l_rtx.rtx18,
                                    l_rtx.rtx05,'Y',l_rtoplant,l_rtx.rtxlegal
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("ins","rtt_file",g_rtw.rtw03,"",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               RETURN
            END IF
           #TQC-B50149 End-----
         END IF

         #更新采購協議
         #LET g_sql = "UPDATE ",s_dbstring(l_azp03 CLIPPED),"rtt_file SET rtt06 ='" CLIPPED,l_rtx.rtx08, #FUN-A50102
         IF g_gec07 = 'Y' THEN
             LET g_sql = "UPDATE ",cl_get_target_table(l_rtoplant, 'rtt_file')," SET rtt06t ='" CLIPPED,l_rtx.rtx08,
                                      "',rtt06 ='" CLIPPED,l_rtx.rtx08/(1+g_gec04/100),
                                      "',rtt07 ='" CLIPPED,l_rtx.rtx09,
                                      "', rtt08 ='" CLIPPED,l_rtx.rtx10,"',rtt09 ='" CLIPPED,l_rtx.rtx11,
                                      "', rtt10 ='" CLIPPED,l_rtx.rtx12,"',rtt12 ='" CLIPPED,l_rtx.rtx16,
                                      "', rtt13 ='" CLIPPED,l_rtx.rtx18,"',rtt15 ='" CLIPPED,l_rtx.rtx20,
                                      "',rtt11='" CLIPPED,l_rtx.rtx14,
                                      "',rtt16='" CLIPPED,g_rtw.rtw04+1, #FUN-B40031
                     "' WHERE rtt01='",g_rtw.rtw03,"' AND rtt02='",g_rtw.rtw02,
                     "' AND rtt04='",l_rtx.rtx04,"' AND rttplant='",l_rtoplant,"'"
         ELSE
             LET g_sql = "UPDATE ",cl_get_target_table(l_rtoplant, 'rtt_file')," SET rtt06 ='" CLIPPED,l_rtx.rtx08,
                                      "',rtt06t ='" CLIPPED,l_rtx.rtx08*(1+g_gec04/100),
                                      "',rtt07 ='" CLIPPED,l_rtx.rtx09,
                                      "', rtt08 ='" CLIPPED,l_rtx.rtx10,"',rtt09 ='" CLIPPED,l_rtx.rtx11,
                                      "', rtt10 ='" CLIPPED,l_rtx.rtx12,"',rtt12 ='" CLIPPED,l_rtx.rtx16,
                                      "', rtt13 ='" CLIPPED,l_rtx.rtx18,"',rtt15 ='" CLIPPED,l_rtx.rtx20,
                                      "',rtt11='" CLIPPED,l_rtx.rtx14,
                                      "',rtt16='" CLIPPED,g_rtw.rtw04+1, #FUN-B40031
                     "' WHERE rtt01='",g_rtw.rtw03,"' AND rtt02='",g_rtw.rtw02,
                     "' AND rtt04='",l_rtx.rtx04,"' AND rttplant='",l_rtoplant,"'"
         END IF
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql            
         CALL cl_parse_qry_sql(g_sql, l_rtoplant) RETURNING g_sql    
         PREPARE t131_updrtt from g_sql
         EXECUTE t131_updrtt

         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","rtt_file",g_rtw.rtw03,"",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            RETURN
         END IF
      END FOREACH
   END FOREACH

  #更新當前機構采購協議
  #找出當前有效機構的數據庫代碼
  SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01=g_rtw.rtwplant
  #更新協議的版本號
  #LET g_sql = "UPDATE ",s_dbstring(l_azp03 CLIPPED),"rts_file SET rts03 = rts03 + 1", #FUN-A50102
#  LET g_sql = "UPDATE ",cl_get_target_table(l_rtoplant, 'rts_file')," SET rts03 = rts03 + 1", #FUN-A50102   #TQC-B40117 mark
   LET g_sql = "UPDATE ",cl_get_target_table(g_rtw.rtwplant, 'rts_file')," SET rts03 = rts03 + 1",           #TQC-B40117 add
                                                                         "    ,rts08 = '",g_rtw.rtw17,"'", #FUN-B40031
              " WHERE rts01='",g_rtw.rtw03,"' AND rts02='",g_rtw.rtw02,
              "' AND rtsplant='",g_rtw.rtwplant,"'"
  CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
#  CALL cl_parse_qry_sql(g_sql, l_rtoplant) RETURNING g_sql    #FUN-A50102                                    #TQC-B40117 mark
  CALL cl_parse_qry_sql(g_sql, g_rtw.rtwplant) RETURNING g_sql                                                    #TQC-B40117 add
  PREPARE t131_updrts_2 from g_sql
  EXECUTE t131_updrts_2
  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
     CALL cl_err3("upd","rtsile",g_rtw.rtw03,"",SQLCA.sqlcode,"","",1)
     ROLLBACK WORK
     RETURN
  END IF

  FOREACH rtx_cur INTO l_rtx.*
     IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
     END IF
     IF cl_null(l_rtx.rtx08) THEN LET l_rtx.rtx08 = 0 END IF
     IF cl_null(l_rtx.rtx09) THEN LET l_rtx.rtx09 = 0 END IF
     IF cl_null(l_rtx.rtx10) THEN LET l_rtx.rtx10 = 0 END IF
     IF cl_null(l_rtx.rtx11) THEN LET l_rtx.rtx11 = 0 END IF
     IF cl_null(l_rtx.rtx12) THEN LET l_rtx.rtx12 = 0 END IF
     IF cl_null(l_rtx.rtx16) THEN LET l_rtx.rtx16 = 0 END IF
     IF cl_null(l_rtx.rtx14) THEN LET l_rtx.rtx14 = 0 END IF
     IF cl_null(l_rtx.rtx18) THEN LET l_rtx.rtx18 = 0 END IF

     #TQC-A20003-------------------------------------------------------------------------
     # 若單身此筆不在原采購協議rtt_file中，則INSERT!
     SELECT COUNT(*) INTO l_n FROM rtt_file
      WHERE rtt01=g_rtw.rtw03 AND rtt02=g_rtw.rtw02
        AND rtt04=l_rtx.rtx04 AND rttplant=g_rtw.rtwplant
     IF l_n=0 OR cl_null(l_n) THEN
        SELECT MAX(rtt03) INTO l_n FROM rtt_file
         WHERE rtt01=g_rtw.rtw03 AND rtt02=g_rtw.rtw02
           AND rttplant=g_rtw.rtwplant
        LET l_n=l_n + 1

        IF g_rtw.rtw07 ='1' OR g_rtw.rtw07='2' THEN
           SELECT rts06,rts07 INTO l_rts06,l_rts07 FROM rts_file
            WHERE rts01 = g_rtw.rtw03 AND rts02=g_rtw.rtw02
              AND rts03 = g_rtw.rtw04 AND rtsplant=g_rtw.rtwplant

           IF NOT cl_null(l_rts06) THEN
              SELECT gec07 INTO l_gec07 FROM gec_file
               WHERE gec01=l_rts06 AND gec011 = '1'
              IF cl_null(l_gec07) THEN LET l_gec07 ='N' END IF
              IF l_gec07='Y' THEN
                 LET l_rtt06 = l_rtx.rtx08
                 LET l_rtt06t= l_rtx.rtx08 * (1+l_rts07/100)
              ELSE
                 LET l_rtt06t= l_rtx.rtx08
                 LET l_rtt06 = l_rtx.rtx08 / (1+l_rts07/100)
              END IF
           END IF
        ELSE
           LET l_rtt06 = 0
           LET l_rtt06t= 0
        END IF  
        INSERT INTO rtt_file(rtt01,rtt02,rtt03,rtt04,rtt05,rtt06,rtt06t,rtt07,rtt08,
                             rtt16,  #FUN-B40031
                             rtt09,rtt10,rtt11,rtt12,rtt13,rtt14,rtt15,rttplant,rttlegal)
                      VALUES(g_rtw.rtw03,g_rtw.rtw02,l_n,l_rtx.rtx04,l_rtx.rtx05,
                             l_rtt06,l_rtt06t,l_rtx.rtx09,l_rtx.rtx10,g_rtw.rtw04+1,l_rtx.rtx11, #FUN-B40031
                             l_rtx.rtx12,l_rtx.rtx14,l_rtx.rtx16,l_rtx.rtx18,l_rtx.rtx05,
                             'Y',g_rtw.rtwplant,l_rtx.rtxlegal)
     END IF

     IF g_gec07 = 'Y' THEN
         LET g_sql = "UPDATE ",cl_get_target_table(g_rtw.rtwplant, 'rtt_file')," SET rtt06 ='",l_rtx.rtx08/(1+g_gec04/100),
                     "', rtt06t ='",l_rtx.rtx08,
                     "', rtt07 ='",l_rtx.rtx09,"',rtt11='",l_rtx.rtx14,
                     "', rtt08 ='",l_rtx.rtx10,"',rtt09='",l_rtx.rtx11,
                     "', rtt10 ='",l_rtx.rtx12,"',rtt12 ='",l_rtx.rtx16,
                     "', rtt13 ='",l_rtx.rtx18,"',rtt15 ='",l_rtx.rtx20,
                     "',rtt16='" CLIPPED,g_rtw.rtw04+1, #FUN-B40031
                     "' WHERE rtt01='",g_rtw.rtw03,"' AND rtt02='",g_rtw.rtw02,
                     "' AND rtt04='",l_rtx.rtx04,"' AND rttplant='",g_rtw.rtwplant,"'"
     ELSE
         LET g_sql = "UPDATE ",cl_get_target_table(g_rtw.rtwplant, 'rtt_file')," SET rtt06 ='",l_rtx.rtx08,
                     "', rtt06t ='",l_rtx.rtx08*(1+g_gec04/100),
                     "', rtt07 ='",l_rtx.rtx09,"',rtt11='",l_rtx.rtx14,
                     "', rtt08 ='",l_rtx.rtx10,"',rtt09='",l_rtx.rtx11,
                     "', rtt10 ='",l_rtx.rtx12,"',rtt12 ='",l_rtx.rtx16,
                     "', rtt13 ='",l_rtx.rtx18,"',rtt15 ='",l_rtx.rtx20,
                     "',rtt16='" CLIPPED,g_rtw.rtw04+1, #FUN-B40031
                     "' WHERE rtt01='",g_rtw.rtw03,"' AND rtt02='",g_rtw.rtw02,
                     "' AND rtt04='",l_rtx.rtx04,"' AND rttplant='",g_rtw.rtwplant,"'"
     END IF
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
#      CALL cl_parse_qry_sql(g_sql, l_rtoplant) RETURNING g_sql    #FUN-A50102               #TQC-B40117 mark
      CALL cl_parse_qry_sql(g_sql, g_rtw.rtwplant) RETURNING g_sql                               #TQC-B40117 add
      PREPARE t131_updrts_1 from g_sql
      EXECUTE t131_updrts_1
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rtt_file",g_rtw.rtw03,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         RETURN
      END IF
   END FOREACH
 #更新單頭的審核碼、審核日期、審核人
   OPEN t131_cl USING g_rtw.rtw01,g_rtw.rtw02

   IF STATUS THEN
      CALL cl_err("OPEN t131_cl:", STATUS, 1)
      CLOSE t131_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t131_cl INTO g_rtw.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rtw.rtw01,SQLCA.sqlcode,0)
      CLOSE t131_cl
      ROLLBACK WORK
      RETURN
   END IF

   UPDATE rtw_file SET rtw900='2'
     WHERE rtw01=g_rtw.rtw01
       AND rtw02=g_rtw.rtw02
   IF SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   END IF

  #FUN-C10018 add START
   IF cl_confirm('art1100') THEN
      CALL t131_ins_rti()
   END IF
  #FUN-C10018 add END

   IF g_success = 'Y' THEN
      CLOSE t131_cl
      COMMIT WORK
   ELSE
      CLOSE t131_cl
      ROLLBACK WORK
   END IF
   SELECT * INTO g_rtw.* FROM rtw_file
      WHERE rtw01=g_rtw.rtw01 AND rtw02=g_rtw.rtw02
   DISPLAY BY NAME g_rtw.rtw900

END FUNCTION

FUNCTION t131_z()
DEFINE l_chr          LIKE type_file.chr1
DEFINE l_gen02        LIKE gen_file.gen02

   IF g_rtw.rtw01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_rtw.* FROM rtw_file WHERE rtw01=g_rtw.rtw01 AND rtw02 =g_rtw.rtw02
   IF g_rtw.rtw900 = '2' THEN CALL cl_err('','art-123',0) RETURN END IF
   IF g_rtw.rtwconf = 'N' THEN CALL cl_err('',9025,0) RETURN END IF
 #  IF g_rtw.rtwconf = 'X' THEN CALL cl_err(g_rtw.rtw01,'9024',0) RETURN END IF   #FUN-B90094 mark
   IF g_rtw.rtwconf = 'X' THEN CALL cl_err(g_rtw.rtw01,'art-868',0) RETURN END IF     #FUN-B90094 add

   IF NOT cl_confirm('aco-729') THEN RETURN END IF

   BEGIN WORK
   OPEN t131_cl USING g_rtw.rtw01,g_rtw.rtw02
   IF STATUS THEN
      CALL cl_err("OPEN t131_cl:", STATUS, 1)
      CLOSE t131_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t131_cl INTO g_rtw.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rtw.rtw01,SQLCA.sqlcode,0)
      CLOSE t131_cl
      ROLLBACK WORK
      RETURN
   END IF

   LET g_success = 'Y'
   UPDATE rtw_file
      SET rtwconf = 'N',
          rtw900  = '0',
         #CHI-D20015 Mark&Add Str
         #rtwcond = '',
         #rtwconu = ''
       #TQC-D40024--str--
        # rtwcond = g_user,
        # rtwconu = g_today
          rtwcond = g_today,
          rtwconu = g_user 
       #TQC-D40024--end--
         #CHI-D20015 Mark&Add End
    WHERE rtw01=g_rtw.rtw01 AND rtw02=g_rtw.rtw02 
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("upd","rtw_file",g_rtw.rtw01,"",SQLCA.sqlcode,"","",0)
      LET g_success='N'
   END IF

   IF g_success = 'Y' THEN
      LET g_rtw.rtwconf='N'
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   SELECT * INTO g_rtw.* FROM rtw_file WHERE rtw01=g_rtw.rtw01 AND rtw02=g_rtw.rtw02
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rtw.rtwconu
   DISPLAY BY NAME g_rtw.rtw900
   DISPLAY BY NAME g_rtw.rtwconf
   DISPLAY BY NAME g_rtw.rtwcond
   DISPLAY BY NAME g_rtw.rtwconu
   DISPLAY l_gen02 TO FORMONLY.rtwconu_desc
   IF g_rtw.rtwconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_rtw.rtwconf,"","","",g_chr,"")
  
END FUNCTION

#FUN-B30084 -------------------END

FUNCTION t131_bp_refresh()
  DISPLAY ARRAY g_rtx TO s_rtx.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
 
END FUNCTION
 
FUNCTION t131_a()
   DEFINE li_result   LIKE type_file.num5
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10
   DEFINE l_gen02     LIKE gen_file.gen02
   DEFINE l_azp02     LIKE azp_file.azp02
 
   MESSAGE ""
   CLEAR FORM
   CALL g_rtx.clear()
   LET g_wc = NULL
   LET g_wc2= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_rtw.* LIKE rtw_file.*
   LET g_rtw01_t = NULL
   LET g_rtw02_t = NULL
   LET g_rtwplant_t = NULL
 
   LET g_rtw_t.* = g_rtw.*
   LET g_rtw_o.* = g_rtw.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_rtw.rtwuser=g_user
      LET g_rtw.rtworiu = g_user #FUN-980030
      LET g_rtw.rtworig = g_grup #FUN-980030
      LET g_data_plant  =g_plant #TQC-A10128 ADD
      LET g_rtw.rtwgrup=g_grup
      LET g_rtw.rtwacti='Y'
      LET g_rtw.rtwcrat = g_today
      LET g_rtw.rtw02 = g_plant
      
      LET g_rtw.rtw15 = g_user
      LET g_rtw.rtwconf = 'N'
      LET g_rtw.rtwmksg = 'N'       #TQC-AB0221
      LET g_rtw.rtwplant = g_plant
      LET g_rtw.rtw900 = '0'
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_user     
      SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_plant
      DISPLAY l_azp02 TO FORMONLY.rtw02_desc
      DISPLAY l_azp02 TO FORMONLY.rtwplant_desc
      DISPLAY l_gen02 TO FORMONLY.rtw15_desc
      SELECT azw02 INTO g_rtw.rtwlegal FROM azw_file
       WHERE azw01 = g_plant
      CALL t131_i("a")
 
      IF INT_FLAG THEN
         INITIALIZE g_rtw.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_rtw.rtw01) THEN
         CONTINUE WHILE
      END IF
 
      BEGIN WORK
#     CALL s_auto_assign_no("axm",g_rtw.rtw01,g_today,"","rtw_file","rtw01,rtwplant","","","")   #FUN-A70130 mark                                    
      CALL s_auto_assign_no("art",g_rtw.rtw01,g_today,"A6","rtw_file","rtw01,rtwplant","","","")   #FUN-A70130 mod                                      
         RETURNING li_result,g_rtw.rtw01                                                                                           
      IF (NOT li_result) THEN                                                                                                      
         CONTINUE WHILE                                                                                                           
      END IF
      DISPLAY BY NAME g_rtw.rtw01
      INSERT INTO rtw_file VALUES (g_rtw.*)
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      #   ROLLBACK WORK          #FUN-B80085---回滾放在報錯後---
         CALL cl_err3("ins","rtw_file",g_rtw.rtw01,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK           #FUN-B80085--add--
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_rtw.rtw01,'I')
      END IF
 
      SELECT * INTO g_rtw.* FROM rtw_file
       WHERE rtw01 = g_rtw.rtw01 AND rtw02=g_rtw.rtw02
           
      LET g_rtw01_t = g_rtw.rtw01
      LET g_rtw02_t = g_rtw.rtw02
      LET g_rtwplant_t = g_rtw.rtwplant
      LET g_rtw_t.* = g_rtw.*
      LET g_rtw_o.* = g_rtw.*
      CALL g_rtx.clear()
 
      LET g_rec_b = 0
      CALL t131_b()
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t131_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rtw.rtw01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rtw.* FROM rtw_file
    WHERE rtw01=g_rtw.rtw01 AND rtw02=g_rtw.rtw02
 
   IF g_rtw.rtwacti ='N' THEN
      CALL cl_err(g_rtw.rtw01,'mfg1000',0)
      RETURN
   END IF
   
   IF g_rtw.rtwconf = 'Y' THEN
      CALL cl_err('','art-024',0)
      RETURN
   END IF
 
   IF g_rtw.rtwconf = 'X' THEN
      CALL cl_err('','art-025',0)
      RETURN
   END IF
   
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_rtw01_t = g_rtw.rtw01
   LET g_rtw02_t = g_rtw.rtw02
   LET g_rtwplant_t = g_rtw.rtwplant
 
   BEGIN WORK
 
   OPEN t131_cl USING g_rtw.rtw01,g_rtw.rtw02
 
   IF STATUS THEN
      CALL cl_err("OPEN t131_cl:", STATUS, 1)
      CLOSE t131_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t131_cl INTO g_rtw.*
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_rtw.rtw01,SQLCA.sqlcode,0)
       CLOSE t131_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t131_show()
 
   WHILE TRUE
      LET g_rtw01_t = g_rtw.rtw01
      LET g_rtw02_t = g_rtw.rtw02
      LET g_rtwplant_t = g_rtw.rtwplant
      LET g_rtw_o.* = g_rtw.*
      LET g_rtw.rtwmodu=g_user
      LET g_rtw.rtwdate=g_today
 
      CALL t131_i("u")
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_rtw.*=g_rtw_t.*
         CALL t131_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_rtw.rtw01 != g_rtw01_t THEN
         UPDATE rtx_file SET rtx01 = g_rtw.rtw01
           WHERE rtx01 = g_rtw01_t AND rtw02=g_rtw.rtw02
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","rtx_file",g_rtw01_t,"",SQLCA.sqlcode,"","rtx",1)  #No.FUN-660129
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE rtw_file SET rtw_file.* = g_rtw.*
       WHERE rtw01 = g_rtw.rtw01
         AND rtw02 = g_rtw.rtw02
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rtw_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t131_cl
   COMMIT WORK
   CALL cl_flow_notify(g_rtw.rtw01,'U')
 
   CALL t131_b_fill("1=1")
   CALL t131_bp_refresh()
 
END FUNCTION
 
FUNCTION t131_i(p_cmd)
DEFINE
   l_pmc05      LIKE pmc_file.pmc05,
   l_pmc30      LIKE pmc_file.pmc30,
   l_n          LIKE type_file.num5,
   p_cmd        LIKE type_file.chr1,
   li_result    LIKE type_file.num5
 DEFINE l_rts08 LIKE rts_file.rts08 #FUN-B40031
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_rtw.rtw01,g_rtw.rtw02,g_rtw.rtw03,g_rtw.rtw04,
       g_rtw.rtw05,g_rtw.rtw06,g_rtw.rtw07,g_rtw.rtw08,g_rtw.rtw09,
       g_rtw.rtw10,g_rtw.rtw11,g_rtw.rtw12,g_rtw.rtw13,g_rtw.rtw14,
       g_rtw.rtw15,g_rtw.rtwconf,g_rtw.rtwconu,g_rtw.rtwcond,
       g_rtw.rtw900,                                                        #FUN-B30084 add
     #  g_rtw.rtwplant,g_rtw.rtw900,g_rtw.rtw16,g_rtw.rtwmksg,g_rtw.rtwuser,#TQC-AB0221 
       g_rtw.rtwplant,g_rtw.rtw16,g_rtw.rtwuser,               #TQC-AB0221 
       g_rtw.rtwmodu,g_rtw.rtwgrup,g_rtw.rtwdate,g_rtw.rtwacti,g_rtw.rtwcrat
      ,g_rtw.rtworiu,g_rtw.rtworig       #TQC-A30041 ADD
 
   CALL cl_set_head_visible("","YES")
   INPUT BY NAME g_rtw.rtw01,g_rtw.rtw02,g_rtw.rtw03, g_rtw.rtworiu,g_rtw.rtworig,
                 g_rtw.rtw17, #FUN-B40031
                 g_rtw.rtw12,g_rtw.rtw13,g_rtw.rtw14,
               # g_rtw.rtw15,g_rtw.rtw16,g_rtw.rtwplant,g_rtw.rtwmksg,#TQC-AB0221 
                 g_rtw.rtw15,g_rtw.rtw16,g_rtw.rtwplant,              #TQC-AB0221 
                 g_rtw.rtwconf,g_rtw.rtwcond,
                 g_rtw.rtwconu,g_rtw.rtwuser,
                 g_rtw.rtwmodu,g_rtw.rtwacti,g_rtw.rtwgrup,
                 g_rtw.rtwdate,g_rtw.rtwcrat
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t131_set_entry(p_cmd)
         CALL t131_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         IF g_rtw.rtw07='1' OR g_rtw.rtw07='2' THEN                                                                           
            CALL cl_set_comp_entry("rtw12",TRUE)                                                                              
            CALL cl_set_comp_entry("rtw13",FALSE)                                                                             
         END IF                                                                                                               
         IF g_rtw.rtw07='3' OR g_rtw.rtw07='4' THEN                                                                           
            CALL cl_set_comp_entry("rtw12",FALSE)                                                                             
            CALL cl_set_comp_entry("rtw13",TRUE)                                                                              
         END IF
         CALL cl_set_docno_format("rtw01")
 
      AFTER FIELD rtw01
         IF NOT cl_null(g_rtw.rtw01) THEN
            IF p_cmd='a' OR 
               (p_cmd='u' AND g_rtw.rtw01 != g_rtw_t.rtw01) THEN
#              CALL s_check_no("axm",g_rtw.rtw01,g_rtw01_t,"A6","rtw_file","rtw01,rtwplant","") #FUN-A70130 mark                                    
               CALL s_check_no("art",g_rtw.rtw01,g_rtw01_t,"A6","rtw_file","rtw01,rtwplant","") #FUN-A70130 mod                                     
                    RETURNING li_result,g_rtw.rtw01                                                                                 
               IF (NOT li_result) THEN                                                                                            
                  LET g_rtw.rtw01=g_rtw_t.rtw01                                                                                   
                  NEXT FIELD rtw01                                                                                                
               END IF
               #SELECT COUNT(*) INTO l_n FROM rtw_file
               #   WHERE rtw01=g_rtw.rtw01 AND rtw02 = g_rtw.rtw02
               #     AND rtwplant=g_rtw.rtwplant
               #IF l_n > 0 THEN
               #   CALL cl_err(g_rtw.rtw01,'art-160',0)
               #   NEXT FIELD rtw01
               #END IF
            END IF
         END IF
      #AFTER FIELD rtw02
      #   IF NOT cl_null(g_rtw.rtw02) THEN
      #      IF p_cmd='a' OR 
      #         (p_cmd='u' AND g_rtw.rtw02 != g_rtw_t.rtw02) THEN
      #         SELECT COUNT(*) INTO l_n FROM rtw_file
      #            WHERE rtw01=g_rtw.rtw01 AND rtw02 = g_rtw.rtw02
      #              AND rtwplant=g_rtw.rtwplant
      #         IF l_n > 0 THEN
      #            CALL cl_err(g_rtw.rtw01,'art-160',0)
      #            NEXT FIELD rtw01
      #         END IF
      #         CALL t131_rtw02()
      #         IF NOT cl_null(g_errno) THEN
      #            CALL cl_err('',g_errno,0)                                                                                          
      #            NEXT FIELD rtw02
      #         END IF
      #         IF NOT t131_plant_issame() THEN
      #            CALL cl_err('','art-161',0)
      #            NEXT FIELD rtw02
      #         END IF
      #         CALL t131_rtw03()
      #         IF NOT cl_null(g_errno) THEN
      #            CALL cl_err('',g_errno,0)                                                                                          
      #            NEXT FIELD rtw03
      #         END IF
      #        CALL t131_get_data()
      #      END IF
      #   END IF
         
      AFTER FIELD rtw03
         IF NOT cl_null(g_rtw.rtw03) THEN
            IF p_cmd='a' OR 
               (p_cmd='u' AND g_rtw.rtw03 != g_rtw_t.rtw03) THEN
               IF NOT t131_plant_issame() THEN
                  CALL cl_err('','art-161',0)
                  NEXT FIELD rtw03
               END IF
            
               CALL t131_rtw03()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)                                                                                    
                  NEXT FIELD rtw03
               END IF
               CALL t131_get_data()
               IF g_rtw.rtw07='1' OR g_rtw.rtw07='2' THEN
                  CALL cl_set_comp_entry("rtw12",TRUE)
                  CALL cl_set_comp_entry("rtw13",FALSE)
               END IF
               IF g_rtw.rtw07='3' OR g_rtw.rtw07='4' THEN
                  CALL cl_set_comp_entry("rtw12",FALSE)
                  CALL cl_set_comp_entry("rtw13",TRUE)
               END IF
              #LET g_rtw.rtw17=g_today #FUN-B40031 ##TQC-B50149 Mark
               LET g_rtw.rtw18=''      #FUN-B40031
            END IF
         END IF
   
     #FUN-B40031 Begin---
      AFTER FIELD rtw17
         IF NOT cl_null(g_rtw.rtw17) AND NOT cl_null(g_rtw.rtw03) THEN
            SELECT rts08 INTO l_rts08 FROM rts_file
             WHERE rts01 = g_rtw.rtw03
               AND rts02 = g_rtw.rtw02
               AND rts03 = g_rtw.rtw04
           #IF g_rtw.rtw17 > g_rtw.rtw09 OR g_rtw.rtw17 <= l_rts08 THEN #TQC-B50149
           #IF g_rtw.rtw17 > g_rtw.rtw09 OR g_rtw.rtw17 < l_rts08 OR g_rtw.rtw17 <= g_today THEN  #TQC-B50149  #FUN-C30226 mark
            IF g_rtw.rtw17 < g_rtw.rtw08 OR g_rtw.rtw17 > g_rtw.rtw09 THEN  #FUN-C30226 add
              #CALL cl_err(g_rtw.rtw17,'art-694',0)
              #CALL cl_err_msg(NULL,"art-694",l_rts08,1)  #FUN-C30226 mark
               CALL cl_err_msg(NULL,"art-694",g_rtw.rtw08 CLIPPED||'|'||g_rtw.rtw09,1)  #FUN-C30226 add
               NEXT FIELD rtw17
            END IF
         ELSE 
            LET g_rtw.rtw17 = ''
            IF NOT cl_null(g_rtw.rtw03) THEN
               CALL cl_err('','aim-927',0)
               NEXT FIELD rtw17
            END IF
         END IF
         LET g_rtw.rtw18 = ''
         DISPLAY BY NAME g_rtw.rtw17,g_rtw.rtw18
     #FUN-B40031 End-----
 
      AFTER FIELD rtw12                                                                                                             
         IF NOT cl_null(g_rtw.rtw12) THEN                                                                                           
            IF p_cmd='a' OR                                                                                                         
               (p_cmd='u' AND g_rtw.rtw12 != g_rtw_t.rtw12) THEN                                                                    
               IF g_rtw.rtw12 <= 0 THEN                                                                                             
                  CALL cl_err('','art-181',0)                                                                                       
                  NEXT FIELD rtw12                                                                                                  
               END IF                                                                                                               
            END IF                                                                                                                  
         END IF
 
      AFTER FIELD rtw13
         IF NOT cl_null(g_rtw.rtw13) THEN
#            IF p_cmd='a' OR                                        #MOD-B30708 
#               (p_cmd='u' AND g_rtw.rtw14 != g_rtw_t.rtw14) THEN   #MOD-B30708
               IF g_rtw.rtw13 <= 0 THEN
                  CALL cl_err('','art-183',0)
                  NEXT FIELD rtw13
               END IF
#            END IF                                                 #MOD-B30708 
         END IF

#MOD-B30708 --begin--              
#      AFTER FIELD rtw14
#         IF NOT cl_null(g_rtw.rtw14) THEN
#            IF p_cmd='a' OR 
#               (p_cmd='u' AND g_rtw.rtw14 != g_rtw_t.rtw14) THEN  
#               CALL t131_rtw14(g_rtw.rtw14)
#               IF NOT cl_null(g_errno) THEN
#                  LET g_rtw.rtw14 = ''
#                  DISPLAY '' TO rtw14_desc
#                  CALL cl_err('',g_errno,0)                                                                                       
#                  NEXT FIELD rtw14
#               END IF
#            END IF
#         ELSE
#            DISPLAY '' TO rtw14_desc
#         END IF
#MOD-B30708 --end--
         
      AFTER FIELD rtw15
         IF NOT cl_null(g_rtw.rtw15) THEN
            IF p_cmd='a' OR 
               (p_cmd='u' AND g_rtw.rtw15 != g_rtw_t.rtw15) THEN  
               CALL t131_rtw15(g_rtw.rtw15)
               IF NOT cl_null(g_errno) THEN
                  LET g_rtw.rtw15 = ''
                  DISPLAY '' TO rtw15_desc
                  CALL cl_err('',g_errno,0)                                                                                     
                  NEXT FIELD rtw15
               END IF
            END IF
         ELSE
            DISPLAY '' TO rtw15_desc
         END IF

     #TQC-B50149 Begin---
      AFTER INPUT
         LET g_rtw.rtwuser = s_get_data_owner("rtw_file") #FUN-C10039
         LET g_rtw.rtwgrup = s_get_data_group("rtw_file") #FUN-C10039
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF NOT cl_null(g_rtw.rtw17) AND NOT cl_null(g_rtw.rtw03) THEN
            SELECT rts08 INTO l_rts08 FROM rts_file
             WHERE rts01 = g_rtw.rtw03
               AND rts02 = g_rtw.rtw02
               AND rts03 = g_rtw.rtw04
           #IF g_rtw.rtw17 > g_rtw.rtw09 OR g_rtw.rtw17 < l_rts08 OR g_rtw.rtw17 <= g_today THEN   #FUN-C30226 mark
            IF g_rtw.rtw17 < g_rtw.rtw08 OR g_rtw.rtw17 > g_rtw.rtw09 THEN  #FUN-C30226 add
              #CALL cl_err(g_rtw.rtw17,'art-694',0)
              #CALL cl_err_msg(NULL,"art-694",l_rts08,1)  #FUN-C30226 mark
               CALL cl_err_msg(NULL,"art-694",g_rtw.rtw08 CLIPPED||'|'||g_rtw.rtw09,1)  #FUN-C30226 add
               NEXT FIELD rtw17
            END IF
         END IF
     #TQC-B50149 End-----

      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(rtw01)                                                                                                    
                LET g_t1=s_get_doc_no(g_rtw.rtw01)                                                                                  
                CALL q_oay(FALSE,FALSE,g_t1,'A6','art') RETURNING g_t1       #FUN-A70130                                                         
                LET g_rtw.rtw01=g_t1                                                                                                
                DISPLAY BY NAME g_rtw.rtw01                                                                                         
                NEXT FIELD rtw01 
            #WHEN INFIELD(rtw02)
            #   CALL cl_init_qry_var()
            #   LET g_qryparam.form ="q_tqb01"
            #   LET g_qryparam.default1 = g_rtw.rtw02
            #   CALL cl_create_qry() RETURNING g_rtw.rtw02
            #   DISPLAY BY NAME g_rtw.rtw02
            #   CALL t131_rtw02()
            #   NEXT FIELD rtw02
            
            WHEN INFIELD(rtw03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_rts"
               LET g_qryparam.arg1 = g_rtw.rtw02
               LET g_qryparam.default1 = g_rtw.rtw03
               CALL cl_create_qry() RETURNING g_rtw.rtw03
               DISPLAY BY NAME g_rtw.rtw03
               CALL t131_rtw03()
               NEXT FIELD rtw03

#MOD-B30708 --begin--               
#            WHEN INFIELD(rtw14)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_gen"
#               LET g_qryparam.default1 = g_rtw.rtw14
#               CALL cl_create_qry() RETURNING g_rtw.rtw14
#               DISPLAY BY NAME g_rtw.rtw14
#               CALL t131_rtw14(g_rtw.rtw14)
#               NEXT FIELD rtw14
#MOD-B30708 --end--
               
            WHEN INFIELD(rtw15)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gen"
               LET g_qryparam.default1 = g_rtw.rtw15
               CALL cl_create_qry() RETURNING g_rtw.rtw15
               DISPLAY BY NAME g_rtw.rtw15
               CALL t131_rtw15(g_rtw.rtw15)
               NEXT FIELD rtw15
               
            OTHERWISE EXIT CASE
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION HELP
         CALL cl_show_help()
 
   END INPUT
 
END FUNCTION

#MOD-B30708 --begin--
#FUNCTION t131_rtw14(p_no)
#DEFINE  l_gen02     LIKE  gen_file.gen02
#DEFINE  l_genacti   LIKE  gen_file.genacti
#DEFINE  p_no        LIKE  gen_file.gen02
# 
#     SELECT gen02,genacti INTO l_gen02,l_genacti FROM gen_file
#         WHERE gen01 = p_no
#         
#     CASE WHEN SQLCA.SQLCODE = 100  
#                           LET g_errno = 'art-162'
#        WHEN l_genacti='N' LET g_errno = '9028'
#        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
#                           DISPLAY l_gen02 TO FORMONLY.rtw14_desc
#     END CASE
#END FUNCTION
#MOD-B30708 --end--
 
FUNCTION t131_rtw15(p_no)                                                                                                           
DEFINE  l_gen02     LIKE  gen_file.gen02                                                                                            
DEFINE  l_genacti   LIKE  gen_file.genacti                                                                                          
DEFINE  p_no        LIKE  gen_file.gen02                                                                                            
                                                                                                                                    
     SELECT gen02,genacti INTO l_gen02,l_genacti FROM gen_file                                                                      
         WHERE gen01 = p_no                                                                                                         
                                                                                                                                    
     CASE WHEN SQLCA.SQLCODE = 100                                                                                                  
                           LET g_errno = 'art-162'                                                                                  
        WHEN l_genacti='N' LET g_errno = '9028'                                                                                     
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'                                                              
                           DISPLAY l_gen02 TO FORMONLY.rtw15_desc                                                                   
     END CASE                                                                                                                       
END FUNCTION
#檢查簽定機構和調整機構是不是一致
FUNCTION t131_plant_issame()
DEFINE  l_rts02     LIKE  rts_file.rts02
 
   IF g_rtw.rtw02 IS NOT NULL AND g_rtw.rtw03 IS NOT NULL THEN
      SELECT rts02 INTO l_rts02 
         FROM rts_file WHERE rts01 = g_rtw.rtw03 
         AND rts02 = g_rtw.rtw02
         AND rtsplant = g_rtw.rtwplant
      IF l_rts02<>g_rtw.rtw02 THEN RETURN FALSE END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION t131_get_data()
DEFINE  l_pmc03   LIKE  pmc_file.pmc03
   IF NOT cl_null(g_rtw.rtw03) AND NOT cl_null(g_rtw.rtw02) 
      AND NOT cl_null(g_rtw.rtwplant) THEN
#TQC-AC0112 --------------STA
#    SELECT rts03,rts04 INTO g_rtw.rtw04,g_rtw.rtw05 
#         FROM rts_file WHERE rts01 = g_rtw.rtw03 
#         AND rts02 = g_rtw.rtw02
#         AND rtsplant = g_rtw.rtwplant
     SELECT rts03,rts04,rts06 INTO g_rtw.rtw04,g_rtw.rtw05,g_rts06
       FROM rts_file WHERE rts01 = g_rtw.rtw03
        AND rts02 = g_rtw.rtw02
        AND rtsplant = g_rtw.rtwplant
     SELECT gec04,gec07 INTO g_gec04,g_gec07 
       FROM gec_file WHERE gec01 = g_rts06
        AND gec011 = '1'
#TQC-AC0112 ---------------END
         
      SELECT rto05,rto06,rto08,rto09,rto10,rto11                                                                                   
           INTO g_rtw.rtw06,g_rtw.rtw07,g_rtw.rtw08,g_rtw.rtw09,                                                                    
                g_rtw.rtw10,g_rtw.rtw11                                                                                             
           FROM rto_file                                                                                                            
           WHERE rto01=g_rtw.rtw05 AND 
                 rto02=(SELECT MAX(rto02) FROM rto_file WHERE rto01=g_rtw.rtw05
                 AND rto03=g_rtw.rtw02 AND rtoplant=g_plant) AND                                                                        
                 rto03=g_rtw.rtw02 AND rtoplant=g_plant       
      SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01=g_rtw.rtw06
      DISPLAY l_pmc03 TO FORMONLY.rtw06_desc
#TQC-AC0112 --------------STA
      DISPLAY g_rts06 TO FORMONLY.rts06
      DISPLAY g_gec04 TO FORMONLY.gec04
      DISPLAY g_gec07 TO FORMONLY.gec07
#TQC-AC0112 ---------------END

      DISPLAY BY NAME g_rtw.rtw04,g_rtw.rtw05,g_rtw.rtw06,
                      g_rtw.rtw07,g_rtw.rtw08,g_rtw.rtw09,
                      g_rtw.rtw10,g_rtw.rtw11
   END IF
END FUNCTION
FUNCTION t131_rtw02()
DEFINE l_azp02      LIKE  azp_file.azp02
 
   SELECT azp02
     INTO l_azp02
     FROM azp_file WHERE azp01 = g_rtw.rtw02
 
   CASE WHEN SQLCA.SQLCODE = 100  
                           LET g_errno = 'art-044'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                           DISPLAY l_azp02 TO FORMONLY.rtw02_desc
   END CASE
END FUNCTION
 
 
FUNCTION t131_rtw03()
    DEFINE l_rts03   LIKE rts_file.rts03,
           l_rtsacti LIKE rts_file.rtsacti,
           l_rtsconf LIKE rts_file.rtsconf,
           l_n       LIKE type_file.num5
 
   LET g_errno = " "
   SELECT COUNT(*) INTO l_n FROM rts_file
      WHERE rts01=g_rtw.rtw03 AND rts02=g_rtw.rtw02 AND rtsplant=g_rtw.rtwplant
        AND rtsconf <> 'X' #CHI-C80041
   IF l_n=0 OR l_n IS NULL THEN
      LET g_errno = 'art-167'
      RETURN
   END IF
   IF NOT cl_null(g_rtw.rtw03) AND NOT cl_null(g_rtw.rtw02)
      AND NOT cl_null(g_rtw.rtwplant) THEN
      SELECT rts03,rtsacti,rtsconf INTO l_rts03,l_rtsacti,l_rtsconf
         FROM rts_file WHERE rts01 = g_rtw.rtw03 
                         AND rts02 = g_rtw.rtw02
                         AND rtsplant = g_rtw.rtwplant
 
      CASE WHEN SQLCA.SQLCODE = 100  
                              LET g_errno = 'art-157'
           WHEN l_rtsacti='N' LET g_errno = '9028'
           WHEN l_rtsconf='N' LET g_errno = 'art-166'
         # WHEN l_rtsconf='X' LET g_errno = 'art-166'   #FUN-B90094 mark
           WHEN l_rtsconf='X' LET g_errno = 'art-868'   #FUN-B90094 add          
           OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                              #DISPLAY BY NAME rtw04
      END CASE 
   END IF
 
END FUNCTION
 
FUNCTION t131_rtx04()
   DEFINE l_imaacti LIKE ima_file.imaacti
   #TQC-C20197--start add-----------------------------------
   DEFINE l_n       LIKE type_file.num10    
   DEFINE l_n1      LIKE type_file.num10
   DEFINE l_flag    LIKE type_file.chr1
   DEFINE l_ima131  LIKE ima_file.ima131    
   DEFINE l_rtq06   LIKE rtq_file.rtq06     
   DEFINE l_rtq06_1 LIKE rtq_file.rtq06     
   #TQC-C20197--end add-------------------------------------
   
   LET g_errno = " "
 
   SELECT ima02,ima021,ima1004,ima1005,ima1009,ima1007,ima25,imaacti
     INTO g_rtx[l_ac].ima02,g_rtx[l_ac].ima021,
          g_rtx[l_ac].ima1004,g_rtx[l_ac].ima1005,
          g_rtx[l_ac].ima1009,g_rtx[l_ac].ima1007,
          g_rtx[l_ac].rtx05,l_imaacti
     FROM ima_file WHERE ima01 = g_rtx[l_ac].rtx04
 
   CASE WHEN SQLCA.SQLCODE = 100  
                           LET g_errno = 'art-037'
        WHEN l_imaacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                           DISPLAY BY NAME g_rtx[l_ac].ima02,g_rtx[l_ac].ima021,
                                           g_rtx[l_ac].ima1004,g_rtx[l_ac].ima1005,
                                           g_rtx[l_ac].ima1009,g_rtx[l_ac].ima1007,
                                           g_rtx[l_ac].rtx05 
                           SELECT gfe02 INTO g_rtx[l_ac].rtx05_desc 
                              FROM gfe_file WHERE gfe01 = g_rtx[l_ac].rtx05
                           DISPLAY g_rtx[l_ac].rtx05_desc TO FORMONLY.rtx05_desc
   END CASE
   #TQC-C20197--start add---------------------------
   IF cl_null(g_errno) THEN
      SELECT distinct ima131 INTO l_ima131
        FROM ima_file
       WHERE ima01 = g_rtx[l_ac].rtx04
      
      SELECT rtq06 INTO l_rtq06
        FROM rtq_file
       WHERE rtq01 = g_rtw.rtw05
         AND rtq03 = g_rtw.rtw02
         AND rtq05 = '1'
         AND rtqplant = g_plant

      SELECT rtq06 INTO l_rtq06_1
        FROM rtq_file
       WHERE rtq01 = g_rtw.rtw05
         AND rtq03 = g_rtw.rtw02
         AND rtq05 = '2'
         AND rtqplant = g_plant
      
      CASE
         WHEN NOT cl_null(l_rtq06) AND NOT cl_null(l_rtq06_1) 
            IF cl_null(l_ima131) OR cl_null(g_rtx[l_ac].ima1005) THEN
               LET l_flag = '1'
            ELSE
               SELECT COUNT(*) INTO l_n
                 FROM rtq_file
                WHERE rtq01 = g_rtw.rtw05
                  AND rtq03 = g_rtw.rtw02
                  AND rtq05 = '1'
                  AND rtq06 = l_ima131
                
               SELECT COUNT(*) INTO l_n1
                 FROM rtq_file
                WHERE rtq01 = g_rtw.rtw05
                  AND rtq03 = g_rtw.rtw02
                  AND rtq05 = '2'
                  AND rtq06 = g_rtx[l_ac].ima1005
               
               IF l_n1 = 0 OR l_n = 0 THEN
                  LET l_flag = '1'
               END IF   
            END IF   
         WHEN NOT cl_null(l_rtq06) AND cl_null(l_rtq06_1)
            IF cl_null(l_ima131) THEN
               LET l_flag = '1' 
            ELSE
               SELECT COUNT(*) INTO l_n1
                 FROM rtq_file
                WHERE rtq01 = g_rtw.rtw05
                  AND rtq03 = g_rtw.rtw02
                  AND rtq05 = '1'
                  AND rtq06 = l_ima131
               IF l_n1 = 0 THEN
                   LET l_flag = '1'
               END IF 
            END IF    
         WHEN cl_null(l_rtq06) AND NOT cl_null(l_rtq06_1)
            IF cl_null(g_rtx[l_ac].ima1005) THEN
               LET l_flag = '1' 
            ELSE
               SELECT COUNT(*) INTO l_n
                 FROM rtq_file
                WHERE rtq01 = g_rtw.rtw05
                  AND rtq03 = g_rtw.rtw02
                  AND rtq05 = '2'
                  AND rtq06 = g_rtx[l_ac].ima1005         
               IF l_n = 0 THEN
                  LET l_flag = '1' 
               END IF   
            END IF 
      END CASE 

      IF l_flag = '1' THEN
         LET g_errno = 'art-851'
      END IF
   END IF
   #TQC-C20197--end add-----------------------------
   
END FUNCTION
 
FUNCTION t131_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_rtx.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t131_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_rtw.* TO NULL
      RETURN
   END IF
 
   OPEN t131_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_rtw.* TO NULL
   ELSE
      OPEN t131_count
      FETCH t131_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL t131_fetch('F')
   END IF
 
END FUNCTION
 
FUNCTION t131_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t131_cs INTO g_rtw.rtw01,g_rtw.rtw02
      WHEN 'P' FETCH PREVIOUS t131_cs INTO g_rtw.rtw01,g_rtw.rtw02
      WHEN 'F' FETCH FIRST    t131_cs INTO g_rtw.rtw01,g_rtw.rtw02
      WHEN 'L' FETCH LAST     t131_cs INTO g_rtw.rtw01,g_rtw.rtw02
      WHEN '/'
         IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
            PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
               ON ACTION about
                  CALL cl_about()
 
               ON ACTION HELP
                  CALL cl_show_help()
 
               ON ACTION controlg
                  CALL cl_cmdask()
 
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
        END IF
        FETCH ABSOLUTE g_jump t131_cs INTO g_rtw.rtw01,g_rtw.rtw02
        LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rtw.rtw01,SQLCA.sqlcode,0)
      INITIALIZE g_rtw.* TO NULL
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
 
   SELECT * INTO g_rtw.* FROM rtw_file WHERE rtw01 = g_rtw.rtw01 AND rtw02 = g_rtw.rtw02
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","rtw_file","","",SQLCA.sqlcode,"","",1)
      INITIALIZE g_rtw.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_rtw.rtwuser
   LET g_data_group = g_rtw.rtwgrup
   LET g_data_plant = g_rtw.rtwplant   #TQC-A10128 ADD
   CALL t131_set_visible()
   CALL t131_show()
 
END FUNCTION
 
FUNCTION t131_show()
DEFINE  l_gen02  LIKE gen_file.gen02
DEFINE  l_azp02  LIKE azp_File.azp02
DEFINE  l_pmc03  LIKE pmc_file.pmc03
 
   LET g_rtw_t.* = g_rtw.*
   LET g_rtw_o.* = g_rtw.*
   DISPLAY BY NAME g_rtw.rtw01,g_rtw.rtw02,g_rtw.rtw03,g_rtw.rtw04, g_rtw.rtworiu,g_rtw.rtworig,
       g_rtw.rtw05,g_rtw.rtw06,g_rtw.rtw07,g_rtw.rtw08,g_rtw.rtw09,
       g_rtw.rtw10,g_rtw.rtw11,g_rtw.rtw12,g_rtw.rtw13,g_rtw.rtw14,
       g_rtw.rtw15,g_rtw.rtwconf,g_rtw.rtwconu,g_rtw.rtwcond,
       g_rtw.rtw900,                                                          #FUN-B30084 add
       g_rtw.rtw17,g_rtw.rtw18, #FUN-B40031
     # g_rtw.rtwplant,g_rtw.rtw900,g_rtw.rtw16,g_rtw.rtwmksg,g_rtw.rtwuser,   #TQC-AB0221
       g_rtw.rtwplant,g_rtw.rtw16,g_rtw.rtwuser,   #TQC-AB0221  
       g_rtw.rtwmodu,g_rtw.rtwgrup,g_rtw.rtwdate,g_rtw.rtwacti,g_rtw.rtwcrat
 
   IF g_rtw.rtwconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF                                                                
   CALL cl_set_field_pic(g_rtw.rtwconf,"","","",g_chr,"")                                                                           
   CALL cl_flow_notify(g_rtw.rtw01,'V')

#TQC-AC0112 ---------------STA
   LET g_rts06 = ''
   SELECT rts06 INTO g_rts06 FROM rts_file
    WHERE rts01 = g_rtw.rtw03
      AND rts02 = g_rtw.rtw02  
   DISPLAY g_rts06 TO FORMONLY.rts06

   LET g_gec04 = ''
   LET g_gec07 = ''
   SELECT gec04,gec07 INTO g_gec04,g_gec07
     FROM gec_file
    WHERE gec01 = g_rts06
      AND gec011 = '1'
   DISPLAY g_gec04 TO FORMONLY.gec04
   DISPLAY g_gec07 TO FORMONLY.gec07
#TQC-AC0112 ---------------END   

   LET l_gen02 = '' 
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rtw.rtwconu
   DISPLAY l_gen02 TO FORMONLY.rtwconu_desc
   
   LET l_azp02 = ''
   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01=g_rtw.rtwplant
   DISPLAY l_azp02 TO FORMONLY.rtwplant_desc
 
   LET l_azp02 = ''
   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01=g_rtw.rtw02
   DISPLAY l_azp02 TO FORMONLY.rtw02_desc
 
   LET l_pmc03 = ''
   SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01=g_rtw.rtw06
   DISPLAY l_pmc03 TO FORMONLY.rtw06_desc
 
   LET l_gen02 = '' 

#MOD-B30708 --begin--   
#   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rtw.rtw14
#   DISPLAY l_gen02 TO FORMONLY.rtw14_desc 
#MOD-B30708 --end--   
   
   LET l_gen02 = '' 
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rtw.rtw15
   DISPLAY l_gen02 TO FORMONLY.rtw15_desc 
 
   CALL t131_b_fill(g_wc2)
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION t131_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rtw.rtw01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   IF g_rtw.rtwconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
#   IF g_rtw.rtwconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF            #FUN-B90094 mark 
   IF g_rtw.rtwconf = 'X' THEN CALL cl_err(g_rtw.rtw01,'art-868',0) RETURN END IF     #FUN-B90094 add
   BEGIN WORK 
   OPEN t131_cl USING g_rtw.rtw01,g_rtw.rtw02
   IF STATUS THEN
      CALL cl_err("OPEN t131_cl:", STATUS, 1)
      CLOSE t131_cl
      RETURN
   END IF
 
   FETCH t131_cl INTO g_rtw.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rtw.rtw01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t131_show()
 
   IF g_rtw.rtwconf = 'Y' THEN
      CALL cl_err('','art-022',0)
      RETURN
   END IF
 
   #BEGIN WORK 
   IF cl_exp(0,0,g_rtw.rtwacti) THEN
      LET g_chr=g_rtw.rtwacti
      IF g_rtw.rtwacti='Y' THEN
         LET g_rtw.rtwacti='N'
      ELSE
         LET g_rtw.rtwacti='Y'
      END IF
 
      UPDATE rtw_file SET rtwacti=g_rtw.rtwacti,
                          rtwmodu=g_user,
                          rtwdate=g_today
       WHERE rtw01=g_rtw.rtw01
         AND rtw02=g_rtw.rtw02
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","rtw_file",g_rtw.rtw01,"",SQLCA.sqlcode,"","",1) 
         LET g_rtw.rtwacti=g_chr
      END IF
   END IF
 
   CLOSE t131_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_rtw.rtw01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT rtwacti,rtwmodu,rtwdate
     INTO g_rtw.rtwacti,g_rtw.rtwmodu,g_rtw.rtwdate FROM rtw_file
    WHERE rtw01=g_rtw.rtw01 AND rtw02=g_rtw.rtw02 
      
   DISPLAY BY NAME g_rtw.rtwacti,g_rtw.rtwmodu,g_rtw.rtwdate
 
END FUNCTION
 
FUNCTION t131_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rtw.rtw01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rtw.* FROM rtw_file
    WHERE rtw01=g_rtw.rtw01
      AND rtw02=g_rtw.rtw02
 
   IF g_rtw.rtwconf = 'Y' THEN
      CALL cl_err('','art-023',1)
      RETURN
   END IF
   IF g_rtw.rtwconf = 'X' THEN 
    #  CALL cl_err('','9024',0)  #FUN-B90094  mark
      CALL cl_err('','art-868',0) #FUN-B90094 add
      RETURN
   END IF
   IF g_rtw.rtwacti = 'N' THEN
      CALL cl_err('','aic-201',0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t131_cl USING g_rtw.rtw01,g_rtw.rtw02
   IF STATUS THEN
      CALL cl_err("OPEN t131_cl:", STATUS, 1)
      CLOSE t131_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t131_cl INTO g_rtw.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rtw.rtw01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t131_show()
 
   IF cl_delh(0,0) THEN 
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "rtw01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_rtw.rtw01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
      DELETE FROM rtw_file WHERE rtw01 = g_rtw.rtw01 
         AND rtw02=g_rtw.rtw02        
      DELETE FROM rtx_file WHERE rtx01 = g_rtw.rtw01
         AND rtx02=g_rtw.rtw02
      CLEAR FORM
      CALL g_rtx.clear()
      OPEN t131_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE t131_cs
         CLOSE t131_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH t131_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t131_cs
         CLOSE t131_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t131_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t131_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t131_fetch('/')
      END IF
   END IF
 
   CLOSE t131_cl
   COMMIT WORK
   CALL cl_flow_notify(g_rtw.rtw01,'D')
END FUNCTION
 
FUNCTION t131_set_visible()
   IF g_rtw.rtw07='1' OR g_rtw.rtw07='2' THEN                                                                                      
      CALL cl_set_comp_entry("rtx08",TRUE) 
      CALL cl_set_comp_visible("rtx13,rtx14",FALSE) 
   ELSE
      CALL cl_set_comp_entry("rtx08",FALSE)
      CALL cl_set_comp_visible("rtx13,rtx14",TRUE) 
   END IF                                                                                                                          
   IF g_rtw.rtw07='3' OR g_rtw.rtw07='4' THEN
      CALL cl_set_comp_entry("rtx08",FALSE)                                                                                        
      CALL cl_set_comp_visible("rtx06,rtx07,rtx08,rtx09,rtx10,rtx11,rtx12",FALSE)   
   ELSE
      CALL cl_set_comp_entry("rtx08",TRUE)
       CALL cl_set_comp_visible("rtx06,rtx07,rtx08,rtx09,rtx10,rtx11,rtx12",TRUE)                                               
   END IF                                                                                                                          
   IF g_rtw.rtw07='4' THEN                                                                                                         
      CALL cl_set_comp_visible("rtx15,rtx17,rtx16,rtx18",FALSE)
   ELSE
      CALL cl_set_comp_visible("rtx15,rtx17,rtx16,rtx18",TRUE)                                                                    
   END IF
END FUNCTION
FUNCTION t131_init_detail()
   IF g_rtw.rtw07='1' OR g_rtw.rtw07='2' THEN                                                                               
      LET g_rtx[l_ac].rtx13 = NULL                                                                                          
      LET g_rtx[l_ac].rtx14 = NULL                                                                                          
   END IF                                                                                                                   
   IF g_rtw.rtw07='3' OR g_rtw.rtw07='4' THEN                                                                               
      LET g_rtx[l_ac].rtx06 = NULL                                                                                          
      LET g_rtx[l_ac].rtx07 = NULL                                                                                          
      LET g_rtx[l_ac].rtx08 = NULL                                                                                          
      LET g_rtx[l_ac].rtx09 = NULL                                                                                          
      LET g_rtx[l_ac].rtx10 = NULL                                                                                          
      LET g_rtx[l_ac].rtx11 = NULL                                                                                          
      LET g_rtx[l_ac].rtx12 = NULL                                                                                          
   END IF                                                                                                                   
   IF g_rtw.rtw07='4' THEN                                                                                                  
      LET g_rtx[l_ac].rtx15 = NULL                                                                                          
      LET g_rtx[l_ac].rtx16 = NULL                                                                                          
      LET g_rtx[l_ac].rtx17 = NULL                                                                                          
      LET g_rtx[l_ac].rtx18 = NULL                                                                                          
   END IF
END FUNCTION
FUNCTION t131_b()
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_n1            LIKE type_file.num5,
    l_n2            LIKE type_file.num5,
    l_n3            LIKE type_file.num5,
    l_cnt           LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_misc          LIKE gef_file.gef01,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5,
    l_pmc05         LIKE pmc_file.pmc05,
    l_pmc30         LIKE pmc_file.pmc30
 
DEFINE l_ima02    LIKE ima_file.ima02,
       l_ima44    LIKE ima_file.ima44,
       l_ima021   LIKE ima_file.ima021,
       l_imaacti  LIKE ima_file.imaacti
DEFINE  l_s      LIKE type_file.chr1000 
DEFINE  l_m      LIKE type_file.chr1000 
DEFINE  i        LIKE type_file.num5
DEFINE  l_s1     LIKE type_file.chr1000 
DEFINE  l_m1     LIKE type_file.chr1000 
DEFINE  i1       LIKE type_file.num5
DEFINE l_rtz04   LIKE rtz_file.rtz04
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_rtw.rtw01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_rtw.* FROM rtw_file
     WHERE rtw01=g_rtw.rtw01 AND rtw02=g_rtw.rtw02
 
    IF g_rtw.rtwacti ='N' THEN
       CALL cl_err(g_rtw.rtw01,'mfg1000',0)
       RETURN
    END IF
    
    IF g_rtw.rtwconf = 'Y' THEN
       CALL cl_err('','art-024',0)
       RETURN
    END IF
    IF g_rtw.rtwconf = 'X' THEN                                                                                             
       CALL cl_err('','art-025',0)                                                                                          
       RETURN                                                                                                               
    END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT rtx03,rtx04,'','','','','','',",
                       "rtx05,'',rtx06,rtx07,rtx08,rtx09,",
                       "rtx10,rtx11,rtx12,rtx13,rtx14,rtx15,",
                       "rtx16,rtx17,rtx18,rtx19,rtx20 ",
                       "  FROM rtx_file ",
                       " WHERE rtx01=? AND rtx02=? AND rtx03=? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t131_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    CALL t131_set_visible()
 
    INPUT ARRAY g_rtx WITHOUT DEFAULTS FROM s_rtx.*
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
 
           OPEN t131_cl USING g_rtw.rtw01,g_rtw.rtw02
           IF STATUS THEN
              CALL cl_err("OPEN t131_cl:", STATUS, 1)
              CLOSE t131_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t131_cl INTO g_rtw.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_rtw.rtw01,SQLCA.sqlcode,0)
              CLOSE t131_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_rtx_t.* = g_rtx[l_ac].*  #BACKUP
              LET g_rtx_o.* = g_rtx[l_ac].*  #BACKUP
              OPEN t131_bcl USING g_rtw.rtw01,g_rtw.rtw02,
                                  g_rtx_t.rtx03
              IF STATUS THEN
                 CALL cl_err("OPEN t131_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t131_bcl INTO g_rtx[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_rtx_t.rtx03,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL t131_rtx04() 
              END IF
          END IF 
           
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_rtx[l_ac].* TO NULL
           LET g_rtx[l_ac].rtx07 = g_rtw.rtw12
           LET g_rtx[l_ac].rtx14 = g_rtw.rtw13 
           LET g_rtx_t.* = g_rtx[l_ac].*
           LET g_rtx_o.* = g_rtx[l_ac].*
           CALL cl_show_fld_cont()
           NEXT FIELD rtx03
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           CALL t131_init_detail()
           INSERT INTO rtx_file(rtx01,rtx02,rtx03,rtx04,rtx05,rtx06,
                                rtx07,rtx08,rtx09,rtx10,rtx11,rtx12,
                                rtx13,rtx14,rtx15,rtx16,rtx17,rtx18,
                                rtx19,rtx20,rtxplant,rtxlegal) VALUES
                 (g_rtw.rtw01,g_rtw.rtw02,g_rtx[l_ac].rtx03,
                  g_rtx[l_ac].rtx04,g_rtx[l_ac].rtx05,
                  g_rtx[l_ac].rtx06,g_rtx[l_ac].rtx07,
                  g_rtx[l_ac].rtx08,g_rtx[l_ac].rtx09,
                  g_rtx[l_ac].rtx10,g_rtx[l_ac].rtx11,
                  g_rtx[l_ac].rtx12,g_rtx[l_ac].rtx13,
                  g_rtx[l_ac].rtx14,g_rtx[l_ac].rtx15,
                  g_rtx[l_ac].rtx16,g_rtx[l_ac].rtx17,
                  g_rtx[l_ac].rtx18,g_rtx[l_ac].rtx19,
                  g_rtx[l_ac].rtx20,g_rtw.rtwplant,g_rtw.rtwlegal)
                 
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err3("ins","rtx_file",g_rtw.rtw01,g_rtx[l_ac].rtx03,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        BEFORE FIELD rtx03
           IF g_rtx[l_ac].rtx03 IS NULL OR g_rtx[l_ac].rtx03 = 0 THEN
              SELECT MAX(rtx03)+1
                INTO g_rtx[l_ac].rtx03
                FROM rtx_file
               WHERE rtx01 = g_rtw.rtw01
                 AND rtx02 = g_rtw.rtw02
              IF g_rtx[l_ac].rtx03 IS NULL THEN
                 LET g_rtx[l_ac].rtx03 = 1
              END IF
           END IF
 
        AFTER FIELD rtx03
           IF NOT cl_null(g_rtx[l_ac].rtx03) THEN
              IF g_rtx[l_ac].rtx03 != g_rtx_t.rtx03
                 OR g_rtx_t.rtx03 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM rtx_file
                  WHERE rtx01 = g_rtw.rtw01
                    AND rtx02 = g_rtw.rtw02
                    AND rtx03 = g_rtx[l_ac].rtx03
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_rtx[l_ac].rtx03 = g_rtx_t.rtx03
                    NEXT FIELD rtx03
                 END IF
              END IF
           END IF
        AFTER FIELD rtx04
           IF NOT cl_null(g_rtx[l_ac].rtx04) THEN
#FUN-AA0059 ---------------------start----------------------------
              IF NOT s_chk_item_no(g_rtx[l_ac].rtx04,"") THEN
                 CALL cl_err('',g_errno,1)
                 LET g_rtx[l_ac].rtx04= g_rtx_t.rtx04
                 NEXT FIELD rtx04
              END IF
#FUN-AA0059 ---------------------end-------------------------------
              IF g_rtx[l_ac].rtx04 != g_rtx_t.rtx04
                 OR g_rtx_t.rtx04 IS NULL THEN
                 IF NOT t131_check_rtx04() THEN
                    IF NOT t131_check_rtx04_new() THEN   #TQC-A20003 ADD
                       CALL cl_err('','art-641',0)
                       NEXT FIELD rtx04 
                    END IF 
                   #CALL cl_err('','art-165',0)          #TQC-A20003 MARK 
                   #NEXT FIELD rtx04
                 END IF
                 IF NOT t131_rtx04_count() THEN
                    CALL cl_err('','art-048',0)
                    NEXT FIELD rtx04
                 END IF
                 CALL t131_rtx04()
                 IF NOT cl_null(g_errno) THEN                                                                                  
                    CALL cl_err(g_rtx[l_ac].rtx04,g_errno,0)                                                                    
                    LET g_rtx[l_ac].rtx03 = g_rtx_o.rtx04                                                                      
                    DISPLAY BY NAME g_rtx[l_ac].rtx04                                                                            
                    NEXT FIELD rtx04                                                                                    
                 END IF
                 CALL t131_get_default()
              END IF
           END IF
           
        AFTER FIELD rtx07
           IF NOT cl_null(g_rtx[l_ac].rtx07) THEN
              IF g_rtx[l_ac].rtx07<=0 THEN
                 CALL cl_err('','art-181',0)
                 NEXT FIELD rtx07
              END IF
              IF NOT cl_null(g_rtx[l_ac].rtx06) THEN
                 LET g_rtx[l_ac].rtx08 = (g_rtx[l_ac].rtx06*g_rtx[l_ac].rtx07)/100
              END IF
           ELSE
              IF NOT cl_null(g_rtx[l_ac].rtx06) THEN
                 LET g_rtx[l_ac].rtx08 = g_rtx[l_ac].rtx06
              END IF
           END IF
 
        AFTER FIELD rtx08
           IF NOT cl_null(g_rtx[l_ac].rtx08) THEN
              IF g_rtx[l_ac].rtx08 <= 0 THEN
                 CALL cl_err('','art-180',0)
                 NEXT FIELD rtx08
              END IF
              IF NOT cl_null(g_rtx[l_ac].rtx06) AND g_rtx[l_ac].rtx06 != 0 THEN
                 LET g_rtx[l_ac].rtx07 = (g_rtx[l_ac].rtx08/g_rtx[l_ac].rtx06)*100
              END IF
           END IF
        AFTER FIELD rtx09
           IF NOT cl_null(g_rtx[l_ac].rtx09) THEN
              IF g_rtx[l_ac].rtx09 < 0 THEN
                 CALL cl_err('','art-184',0)
                 NEXT FIELD rtx09
              END IF
           END IF
 
        AFTER FIELD rtx10                                                                                                           
           IF NOT cl_null(g_rtx[l_ac].rtx10) THEN                                                                                   
              IF g_rtx[l_ac].rtx10 < 0 THEN                                                                                        
                 CALL cl_err('','art-184',0)                                                                                        
                 NEXT FIELD rtx10                                                                                                   
              END IF                                                                                                                
           END IF
 
        AFTER FIELD rtx11                                                                                                           
           IF NOT cl_null(g_rtx[l_ac].rtx11) THEN                                                                                   
              IF g_rtx[l_ac].rtx11 < 0 THEN                                                                                        
                 CALL cl_err('','art-184',0)                                                                                        
                 NEXT FIELD rtx11                                                                                                   
              END IF                                                                                                                
           END IF
   
        AFTER FIELD rtx12                                                                                                           
           IF NOT cl_null(g_rtx[l_ac].rtx12) THEN                                                                                   
              IF g_rtx[l_ac].rtx12 <= 0 THEN                                                                                        
                 CALL cl_err('','art-185',0)                                                                                        
                 NEXT FIELD rtx12                                                                                                   
              END IF                                                                                                                
           END IF
 
        AFTER FIELD rtx13                                                                                                           
           IF NOT cl_null(g_rtx[l_ac].rtx13) THEN                                                                                   
              IF g_rtx[l_ac].rtx13 <= 0 THEN                                                                                        
                 CALL cl_err('','art-185',0)                                                                                        
                 NEXT FIELD rtx13                                                                                                   
              END IF                                                                                                                
           END IF
 
       AFTER FIELD rtx14                                                                                                           
           IF NOT cl_null(g_rtx[l_ac].rtx14) THEN                                                                                   
              IF g_rtx[l_ac].rtx14 < 0 THEN                                                                                        
                 CALL cl_err('','art-185',0)                                                                                        
                 NEXT FIELD rtx14                                                                                                   
              END IF                                                                                                                
           END IF
 
        AFTER FIELD rtx16                                                                                                           
           IF NOT cl_null(g_rtx[l_ac].rtx16) THEN                                                                                   
              IF g_rtx[l_ac].rtx16 < 0 THEN                                                                                        
                 CALL cl_err('','art-184',0)                                                                                        
                 NEXT FIELD rtx16                                                                                                   
              END IF                                                                                                                
           END IF
 
        AFTER FIELD rtx18
           IF NOT cl_null(g_rtx[l_ac].rtx18) THEN
              IF g_rtx[l_ac].rtx18 < 0 THEN
                 CALL cl_err('','art-184',0)
                 NEXT FIELD rtx18
              END IF
           END IF
 
        BEFORE DELETE
           DISPLAY "BEFORE DELETE"
           IF g_rtx_t.rtx03 > 0 AND g_rtx_t.rtx03 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rtx_file
                WHERE rtx01 = g_rtw.rtw01
                  AND rtx02 = g_rtw.rtw02
                  AND rtx03 = g_rtx_t.rtx03
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rtx_file",g_rtw.rtw01,g_rtx_t.rtx03,SQLCA.sqlcode,"","",1)  #No.FUN-660129
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
              LET g_rtx[l_ac].* = g_rtx_t.*
              CLOSE t131_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CALL t131_init_detail()
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rtx[l_ac].rtx03,-263,1)
              LET g_rtx[l_ac].* = g_rtx_t.*
           ELSE
              UPDATE rtx_file SET rtx08=g_rtx[l_ac].rtx08,
                                  rtx03=g_rtx[l_ac].rtx03,
                                  rtx04=g_rtx[l_ac].rtx04,
                                  rtx05=g_rtx[l_ac].rtx05,
                                  rtx06=g_rtx[l_ac].rtx06,
                                  rtx07=g_rtx[l_ac].rtx07,
                                  rtx09=g_rtx[l_ac].rtx09,
                                  rtx10=g_rtx[l_ac].rtx10,
                                  rtx11=g_rtx[l_ac].rtx11,
                                  rtx12=g_rtx[l_ac].rtx12,
                                  rtx13=g_rtx[l_ac].rtx13,
                                  rtx14=g_rtx[l_ac].rtx14,
                                  rtx15=g_rtx[l_ac].rtx15,
                                  rtx16=g_rtx[l_ac].rtx16,
                                  rtx17=g_rtx[l_ac].rtx17,
                                  rtx18=g_rtx[l_ac].rtx18,
                                  rtx19=g_rtx[l_ac].rtx19,
                                  rtx20=g_rtx[l_ac].rtx20
               WHERE rtx01=g_rtw.rtw01
                 AND rtx02=g_rtw.rtw02
                 AND rtx03=g_rtx_t.rtx03
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rtx_file",g_rtw.rtw01,g_rtx_t.rtx03,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 LET g_rtx[l_ac].* = g_rtx_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
        #  LET l_ac_t = l_ac   #FUN-D30033 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rtx[l_ac].* = g_rtx_t.*
            #FUN-D30033--add--str--
              ELSE
                 CALL g_rtx.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
            #FUN-D30033--add--end--
              END IF
              CLOSE t131_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac   #FUN-D30033 add
           CLOSE t131_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO
           IF INFIELD(rtx03) AND l_ac > 1 THEN
              LET g_rtx[l_ac].* = g_rtx[l_ac-1].*
              LET g_rtx[l_ac].rtx03 = g_rec_b + 1
              NEXT FIELD rtx03
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(rtx04)
               #TQC-B50149 Begin---
               # CALL cl_init_qry_var()
               ##TQC-A20003 MARK&AND START------------
               ##LET g_qryparam.form ="q_rtt04_1"
               ##LET g_qryparam.arg1 = g_rtw.rtw03
               ##LET g_qryparam.arg2 = g_rtw.rtw02
               ##LET g_qryparam.arg3 = g_rtw.rtwplant
               # LET g_qryparam.form ="q_rte03_3"
               # LET g_qryparam.arg1 = g_rtz04
               ##TQC-A20003 END-----------------------
               # LET g_qryparam.default1 = g_rtx[l_ac].rtx04
               # CALL cl_create_qry() RETURNING g_rtx[l_ac].rtx04
                 CALL q_sel_ima(FALSE, "q_ima","",g_rtx[l_ac].rtx04,"","","","","",'' )
                    RETURNING g_rtx[l_ac].rtx04
               #TQC-B50149 End-----
                 DISPLAY BY NAME g_rtx[l_ac].rtx04
                 NEXT FIELD rtx04
              OTHERWISE EXIT CASE
            END CASE
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) 
            RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION HELP
         CALL cl_show_help()
 
      ON ACTION controls         
         CALL cl_set_head_visible("","AUTO")
    END INPUT
    IF p_cmd = 'u' THEN
       LET g_rtw.rtwmodu = g_user
       LET g_rtw.rtwdate = g_today
       UPDATE rtw_file SET rtwmodu = g_rtw.rtwmodu,rtwdate = g_rtw.rtwdate
        WHERE rtw01 = g_rtw.rtw01 AND rtw02=g_rtw.rtw02
     
       DISPLAY BY NAME g_rtw.rtwmodu,g_rtw.rtwdate
    END IF
 
    CLOSE t131_bcl
    COMMIT WORK
#   CALL t131_delall()       #CHI-C30002 mark
    CALL t131_delHeader()     #CHI-C30002 add
 
END FUNCTION
 

#CHI-C30002 -------- add -------- begin
FUNCTION t131_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_rtw.rtw01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM rtw_file ",
                  "  WHERE rtw01 LIKE '",l_slip,"%' ",
                  "    AND rtw01 > '",g_rtw.rtw01,"'"
      PREPARE t131_pb1 FROM l_sql 
      EXECUTE t131_pb1 INTO l_cnt
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
         CALL t131_void(1)
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM rtw_file WHERE rtw01 = g_rtw.rtw01
                                AND rtw02=g_rtw.rtw02
         INITIALIZE g_rtw.*  TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t131_delall()
#
#  SELECT COUNT(*) INTO g_cnt FROM rtx_file
#   WHERE rtx01 = g_rtw.rtw01 AND rtx02=g_rtw.rtw02
#
#  IF g_cnt = 0 THEN
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM rtw_file WHERE rtw01 = g_rtw.rtw01
#        AND rtw02=g_rtw.rtw02
#  END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end

#檢查錄入的商品在當前采購協議中的有效日期內是否存在于其他采購協議中
FUNCTION t131_check_rtx04_new()   #TQC-A20003 add
DEFINE  l_n    LIKE type_file.num5
 
   SELECT COUNT(DISTINCT rts01) INTO l_n FROM rts_file,rtt_file,rto_file a,rto_file b
    WHERE rtt04 = g_rtx[l_ac].rtx04                                                
      AND rtt01 = rts01 AND rtt02 = rts02
      AND rts04 = a.rto01 
      AND a.rto01 = b.rto01
      AND a.rto02 = b.rto02
      AND a.rto03 = b.rto03
      AND a.rtoplant = b.rtoplant
      AND rtsconf <> 'X' #CHI-C80041
      AND a.rto02 = (SELECT MAX(rto02) FROM rto_file WHERE rto01 = b.rto01
                      AND rto03 = b.rto03 AND rtoplant = b.rtoplant) 
      AND a.rto05 = g_rtw.rtw06
      AND a.rto06 = g_rtw.rtw07
      AND (   (a.rto08 BETWEEN g_rtw.rtw08 AND g_rtw.rtw09)
           OR (a.rto09 BETWEEN g_rtw.rtw08 AND g_rtw.rtw09))
      AND rtsplant = g_rtw.rtwplant
      AND rtsplant = a.rtoplant 

   IF l_n = 0 OR l_n IS NULL THEN
      RETURN TRUE
   END IF
   RETURN FALSE
END FUNCTION

#檢查錄入的商品是否在采購協議中維護
FUNCTION t131_check_rtx04()
DEFINE  l_n    LIKE type_file.num5

   SELECT COUNT(*) INTO l_n FROM rtt_file
    WHERE rtt01=g_rtw.rtw03 AND rtt02=g_rtw.rtw02
      AND rtt04=g_rtx[l_ac].rtx04
   IF l_n = 0 OR l_n IS NULL THEN
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION


#判斷單身中商品是否重復
FUNCTION t131_rtx04_count()
DEFINE  l_n     LIKE  type_file.num5
 
    SELECT COUNT(*) INTO l_n FROM rtx_file
     WHERE rtx01=g_rtw.rtw01 AND rtx02=g_rtw.rtw02 
       AND rtx04 = g_rtx[l_ac].rtx04
    IF l_n = 0 OR l_n IS NULL THEN
       RETURN TRUE
    END IF
    RETURN FALSE
END FUNCTION
FUNCTION t131_get_default()
 #TQC-AC0112 -------------------STA
 #  SELECT rtt06,rtt07,rtt08,rtt09,rtt10,rtt11,rtt12,rtt13,rtt15 
 #     INTO g_rtx[l_ac].rtx06,g_rtx[l_ac].rtx09,
 #          g_rtx[l_ac].rtx10,g_rtx[l_ac].rtx11,
 #          g_rtx[l_ac].rtx12,g_rtx[l_ac].rtx13,
 #          g_rtx[l_ac].rtx15,g_rtx[l_ac].rtx17,
 #          g_rtx[l_ac].rtx19     
 #     FROM rtt_file 
 #     WHERE rtt01=g_rtw.rtw03 AND rtt02=g_rtw.rtw02
 #       AND rtt04=g_rtx[l_ac].rtx04 AND rttplant=g_rtw.rtwplant
    IF g_gec07 = 'Y' THEN
       SELECT rtt06t,rtt07,rtt08,rtt09,rtt10,rtt11,rtt12,rtt13,rtt15
         INTO g_rtx[l_ac].rtx06,g_rtx[l_ac].rtx09,
              g_rtx[l_ac].rtx10,g_rtx[l_ac].rtx11,
              g_rtx[l_ac].rtx12,g_rtx[l_ac].rtx13,
              g_rtx[l_ac].rtx15,g_rtx[l_ac].rtx17,
              g_rtx[l_ac].rtx19
         FROM rtt_file
        WHERE rtt01=g_rtw.rtw03 AND rtt02=g_rtw.rtw02
          AND rtt04=g_rtx[l_ac].rtx04 AND rttplant=g_rtw.rtwplant
    ELSE
       SELECT rtt06,rtt07,rtt08,rtt09,rtt10,rtt11,rtt12,rtt13,rtt15
         INTO g_rtx[l_ac].rtx06,g_rtx[l_ac].rtx09,
              g_rtx[l_ac].rtx10,g_rtx[l_ac].rtx11,
              g_rtx[l_ac].rtx12,g_rtx[l_ac].rtx13,
              g_rtx[l_ac].rtx15,g_rtx[l_ac].rtx17,
              g_rtx[l_ac].rtx19
         FROM rtt_file
        WHERE rtt01=g_rtw.rtw03 AND rtt02=g_rtw.rtw02
          AND rtt04=g_rtx[l_ac].rtx04 AND rttplant=g_rtw.rtwplant
    END IF
       
 #TQC-AC0112 -------------------END
     
    LET g_rtx[l_ac].rtx20 = g_rtx[l_ac].rtx19      
    DISPLAY BY NAME g_rtx[l_ac].rtx06,g_rtx[l_ac].rtx09,
                    g_rtx[l_ac].rtx10,g_rtx[l_ac].rtx11,
                    g_rtx[l_ac].rtx12,g_rtx[l_ac].rtx13,
                    g_rtx[l_ac].rtx15,g_rtx[l_ac].rtx17,
                    g_rtx[l_ac].rtx19,g_rtx[l_ac].rtx20
END FUNCTION
FUNCTION t131_b_fill(p_wc2)
DEFINE p_wc2   STRING
 
   LET g_sql = "SELECT rtx03,rtx04,'','','','','','',",
               "rtx05,'',rtx06,rtx07,rtx08,rtx09,",
               "rtx10,rtx11,rtx12,rtx13,rtx14,rtx15,",
               "rtx16,rtx17,rtx18,rtx19,rtx20 ",
               "  FROM rtx_file ",
               " WHERE rtx01 ='",g_rtw.rtw01,"' AND rtx02='",
               g_rtw.rtw02,"' AND rtxplant='",g_rtw.rtwplant,"'"
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY rtx01,rtx02,rtxplant "
 
   DISPLAY g_sql
 
   PREPARE t131_pb FROM g_sql
   DECLARE rtx_cs CURSOR FOR t131_pb
 
   CALL g_rtx.clear()
   LET g_cnt = 1
 
   FOREACH rtx_cs INTO g_rtx[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
   
       SELECT ima02,ima021,ima1004,ima1005,ima1009,ima1007 
           INTO g_rtx[g_cnt].ima02,g_rtx[g_cnt].ima021,
                g_rtx[g_cnt].ima1004,g_rtx[g_cnt].ima1005,
                g_rtx[g_cnt].ima1009,g_rtx[g_cnt].ima1007    
           FROM ima_file
           WHERE ima01 = g_rtx[g_cnt].rtx04
       IF SQLCA.sqlcode THEN
          CALL cl_err3("sel","ima_file",g_rtx[g_cnt].ima02,"",SQLCA.sqlcode,"","",0)  
          LET g_rtx[g_cnt].ima02 = NULL
       END IF
       SELECT gfe02 INTO g_rtx[g_cnt].rtx05_desc FROM gfe_file
          WHERE gfe01 = g_rtx[g_cnt].rtx05
          
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_rtx.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t131_copy()
   DEFINE l_newno     LIKE rtw_file.rtw01,
          l_oldno     LIKE rtw_file.rtw01,
          li_result   LIKE type_file.num5,
          l_n         LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_rtw.rtw01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL t131_set_entry('a')
 
   CALL cl_set_head_visible("","YES")
   INPUT l_newno FROM rtw01
       #BEFORE INPUT
       #   CALL cl_set_docno_format("rtw01")
 
       AFTER FIELD rtw01
          IF l_newno IS NOT NULL THEN 
             #SELECT COUNT(*) INTO l_n FROM rtw_file
             #    WHERE rtw01=l_newno AND rtw02=g_rtw.rtw02
             #      AND rtwplant=g_rtw.rtwplant
             #IF l_n > 0 THEN
             #   CALL cl_err(l_newno,'-239',0)
             #   NEXT FIELD rtw01
             #END IF
#           CALL s_check_no("axm",l_newno,"","A6","rtw_file","rtw01,rtwplant","")   #FUN-A70130 mark                                    
            CALL s_check_no("art",l_newno,"","A6","rtw_file","rtw01,rtwplant","")   #FUN-A70130 mod                                    
                    RETURNING li_result,l_newno                                                                                 
            IF (NOT li_result) THEN                                                                                              
                LET g_rtw.rtw01=""                                                                                     
                NEXT FIELD rtw01                                                                                                  
            END IF 
            BEGIN WORK                                                                                                              
#           CALL s_auto_assign_no("axm",l_newno,g_today,"","rtw_file","rtw01","","","")    #FUN-A70130 mark                                         
            CALL s_auto_assign_no("art",l_newno,g_today,"A6","rtw_file","rtw01","","","")    #FUN-A70130 mod                                         
               RETURNING li_result,l_newno                                                                                          
            IF (NOT li_result) THEN                                                                                                 
               ROLLBACK WORK                                                                                                        
               NEXT FIELD rtw01                                                                                                     
            ELSE                                                                                                                    
               COMMIT WORK                                                                                                          
            END IF                                                                                                                  
            DISPLAY l_newno TO rtw01 
          END IF
 
      ON ACTION controlp                                                                                                            
         CASE                                                                                                                       
            WHEN INFIELD(rtw01)                                                                                                     
                LET g_t1=s_get_doc_no(g_rtw.rtw01)                                                                                  
                CALL q_oay(FALSE,FALSE,g_t1,'A6','art') RETURNING g_t1        #FUN-A70130                                                       
                LET l_newno = g_t1                                                                                                
                DISPLAY l_newno TO rtw01                                                                                         
                NEXT FIELD rtw01 
         END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
     ON ACTION about
        CALL cl_about()
 
     ON ACTION HELP
        CALL cl_show_help()
 
     ON ACTION controlg
        CALL cl_cmdask()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_rtw.rtw01
      ROLLBACK WORK
      RETURN
   END IF
   BEGIN WORK
 
   DROP TABLE y
 
   SELECT * FROM rtw_file
       WHERE rtw01=g_rtw.rtw01 AND rtw02=g_rtw.rtw02
         AND rtwplant=g_rtw.rtwplant
       INTO TEMP y
 
   UPDATE y
       SET rtw01=l_newno,
           rtw900 = '0',       #FUN-C10018 add
           rtwconf = 'N',
           rtwcond = NULL,
           rtwconu = NULL,
           rtwuser=g_user,
           rtwgrup=g_grup,
           rtworiu=g_user,     #TQC-A30041 ADD
           rtworig=g_grup,     #TQC-A30041 ADD
           rtwmodu=g_user,
           rtwdate=g_today,
           rtwacti='Y',
           rtwcrat=g_today
 
   INSERT INTO rtw_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","rtw_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM rtx_file
       WHERE rtx01=g_rtw.rtw01 AND rtx02=g_rtw.rtw02 
         AND rtxplant=g_rtw.rtwplant 
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF
 
   UPDATE x SET rtx01=l_newno
 
   INSERT INTO rtx_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
   #   ROLLBACK WORK            #FUN-B80085---回滾放在報錯後---
      CALL cl_err3("ins","rtx_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      ROLLBACK WORK             #FUN-B80085--add--
      RETURN
   ELSE
       COMMIT WORK
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_rtw.rtw01
   SELECT rtw_file.* INTO g_rtw.* FROM rtw_file 
    WHERE rtw01 = l_newno AND rtw02=g_rtw.rtw02
   CALL t131_u()
   CALL t131_b()
   #SELECT rtw_file.* INTO g_rtw.* FROM rtw_file  #FUN-C80046
   # WHERE rtw01 = l_oldno AND rtw02=g_rtw.rtw02  #FUN-C80046
   #CALL t131_show()  #FUN-C80046
 
END FUNCTION
 
FUNCTION t131_out()
DEFINE l_cmd   LIKE type_file.chr1000                                                                                           
     
    IF g_wc IS NULL AND g_rtw.rtw01 IS NOT NULL THEN
       LET g_wc = "rtw01='",g_rtw.rtw01,"'"
    END IF        
     
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0)
       RETURN
    END IF
                                                                                                                  
    IF g_wc2 IS NULL THEN                                                                                                           
       LET g_wc2 = ' 1=1'                                                                                                     
    END IF                                                                                                                   
                                                                                                                                    
    LET l_cmd='p_query "artt131" "',g_wc CLIPPED,'" "',g_wc2 CLIPPED,'"'                                                                               
    CALL cl_cmdrun(l_cmd)
END FUNCTION
 
FUNCTION t131_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("rtw01,rtw03",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t131_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("rtw01,rtw03",FALSE)
    END IF
 
END FUNCTION
#FUN-870007 PASS NO. 

#TQC-C60107 add begin
#此函数用来判断和生成是否,新增加的营运中心没有对应的采购协议
FUNCTION t131_transfer()
DEFINE  l_dbname  LIKE azp_file.azp03
DEFINE  l_sql,l_sql2  STRING 
DEFINE  l_n   LIKE type_file.num5
DEFINE  l_rtoplant LIKE rtp_file.rtp05
DEFINE  l_no  LIKE rts_file.rts01
DEFINE  li_result LIKE type_file.num5
DEFINE  l_rts01 LIKE rts_file.rts01
DEFINE  l_legal LIKE rts_file.rtslegal
DEFINE  l_rto02    LIKE rtp_file.rtp02
DEFINE  l_cnt   LIKE type_file.num5
DEFINE  l_rts03  LIKE rts_file.rts03


#如果存在此营运中心的采购协议,则continue foreach,否则插入此营运中心的采购协议
   SELECT MAX(rto02) INTO l_rto02 FROM rto_file WHERE rto01=g_rtw.rtw05 AND rto03=g_rtw.rtw02
       AND rtoplant=g_rtw.rtwplant 
   LET g_sql = "SELECT DISTINCT rtp05 FROM ",cl_get_target_table(g_rtw.rtw02, 'rtp_file'),
               " WHERE rtp01='",g_rtw.rtw05,"'",
               "   AND rtp02='",l_rto02,"'",
               "   AND rtp03='",g_rtw.rtw02,"'",
               "   AND rtpplant='",g_rtw.rtw02,"'"
   PREPARE t131_count2 FROM g_sql
   DECLARE rtp2_cur CURSOR FOR t131_count2
   FOREACH rtp2_cur INTO l_rtoplant
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #如果有效機構中包含當前機構，不用判断
      #IF l_rtoplant = g_rtw.rtwplant THEN
      #   CONTINUE FOREACH
      #END IF
      #判断是否存在此营运中心的采购协议
      LET l_sql2 = "SELECT COUNT(*) FROM ", cl_get_target_table(l_rtoplant, 'rts_file'),
                  " WHERE rts01='",g_rtw.rtw03,"' AND rts02='",g_rtw.rtw02,
                  "' AND rtsplant='",l_rtoplant,"'",
                  "  AND rtsconf <> 'X'" #CHI-C80041
      PREPARE t131_count3 FROM l_sql2
      EXECUTE t131_count3 INTO l_cnt
      #如果不存在此营运中心的采购协议,则插入一笔rts,rtt,来源为该协议的签订机构所对应的采购协议
      IF l_cnt = 0 THEN  
         SELECT MAX(rts03) INTO l_rts03 FROM rts_file
          WHERE rts01 = g_rtw.rtw03 AND rts02= g_rtw.rtw02
            AND rtsconf ='Y' AND rtsplant=g_rtw.rtw02 
            
         DELETE FROM rts_temp
         INSERT INTO rts_temp
         SELECT * FROM rts_file WHERE rts01 = g_rtw.rtw03 AND rts02= g_rtw.rtw02
                                  AND rts03 = l_rts03 AND rtsplant=g_rtw.rtw02
         SELECT azw02 INTO l_legal FROM azw_file WHERE azw01=l_rtoplant
         UPDATE rts_temp SET rtslegal=l_legal,
                             rtsplant=l_rtoplant
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_rtoplant,'rts_file'),   
                     " SELECT * FROM rts_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql           
         CALL cl_parse_qry_sql(l_sql,l_rtoplant) RETURNING l_sql  
         PREPARE trans_ins_rts FROM l_sql
         EXECUTE trans_ins_rts           
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","rts_file","","",SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
         ELSE
            DELETE FROM rtt_temp
            INSERT INTO rtt_temp
            SELECT * FROM rtt_file WHERE rtt01 = g_rtw.rtw03 AND rtt02= g_rtw.rtw02
                                     AND rttplant=g_rtw.rtw02
            UPDATE rtt_temp SET rttlegal=l_legal,
                                rttplant=l_rtoplant
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_rtoplant,'rtt_file'),    
                        " SELECT * FROM rtt_temp"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql              
            CALL cl_parse_qry_sql(l_sql,l_rtoplant) RETURNING l_sql     
            PREPARE trans_ins_rtt FROM l_sql
            EXECUTE trans_ins_rtt
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","rtt_file","","",SQLCA.sqlcode,"","",1)
               LET g_success = 'N'
            END IF
         END IF     
      END IF 
   END FOREACH

END FUNCTION         
#TQC-C60107 add end   


#FUN-C10018 add START
#確認發佈後將資料自動新增到artt100 採購策略變更單
FUNCTION t131_ins_rti()
DEFINE l_rti         RECORD LIKE rti_file.*
DEFINE l_ryn         RECORD LIKE ryn_file.*
DEFINE li_result     LIKE type_file.num5
DEFINE l_t1          LIKE oay_file.oayslip
DEFINE l_n           LIKE type_file.num5
DEFINE l_sql         STRING
DEFINE l_rtx04       LIKE rtx_file.rtx04

   IF g_success = 'N' THEN  RETURN END IF

   #新增artt100單頭
   OPEN WINDOW t131_1_w AT p_row,p_col WITH FORM "art/42f/artt131_1"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   INPUT BY NAME l_rti.rti01

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)


      ON ACTION controlp
         CASE
            WHEN INFIELD(rti01)
               LET l_t1=s_get_doc_no(l_rti.rti01)
               CALL q_oay(FALSE,FALSE,g_t1,'A1','art') RETURNING l_t1
               LET l_rti.rti01 = l_t1
               DISPLAY BY NAME l_rti.rti01
               NEXT FIELD rti01  
            OTHERWISE EXIT CASE
          END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION HELP
         CALL cl_show_help()


   END INPUT

   CALL s_auto_assign_no("art",l_rti.rti01,g_today,'A1',"rti_file",
                         "rti01","","","") RETURNING li_result,l_rti.rti01

   IF (NOT li_result) THEN
      LET g_success = 'N'
      CALL cl_err('','',1)
      LET INT_FLAG  = 0
      CLOSE WINDOW t131_1_w 
      RETURN
   END IF

   LET l_rti.rti02 = '1'  #生效方式 
   LET l_rti.rti03 = NULL 
   LET l_rti.rticonf = 'N'
   LET l_rti.rticrat = g_today
   LET l_rti.rtigrup = g_grup
   LET l_rti.rtilegal = g_legal
   LET l_rti.rtiplant = g_plant
   LET l_rti.rtiuser = g_user
   LET l_rti.rticond = NULL

   INSERT INTO rti_file VALUES(l_rti.*)
   IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
      LET g_success = 'N'
      CALL cl_err('ins rti_file',SQLCA.SQLCODE,1)
      CLOSE WINDOW t131_1_w
      RETURN
   END IF

   #新增artt100 採購策略變更單身

   LET l_ryn.ryn01 = l_rti.rti01   #變更單號
   LET l_ryn.ryn03 = g_rtw.rtw02   #變更營運中心
   LET l_ryn.rynlegal = g_legal
   LET l_ryn.rynplant = g_plant
   LET l_ryn.ryn07 = g_rtw.rtw06   #主供應商
   LET l_ryn.ryn08 = g_rtw.rtw07   #經營方式

   LET l_sql = "SELECT DISTINCT rtx04 FROM rtx_file WHERE rtx01='",g_rtw.rtw01,
               "' AND rtx02='",g_rtw.rtw02,"' AND rtxplant='",g_rtw.rtwplant,"'"

   PREPARE t131_ryn_pre FROM l_sql
   DECLARE t131_ryn_cur CURSOR FOR t131_ryn_pre

   FOREACH t131_ryn_cur INTO l_rtx04
      IF cl_null(l_rtx04) THEN CONTINUE FOREACH END IF
      LET l_n = 0
     #值清空避免舊值殘留問題
      LET l_ryn.ryn02 = NULL
      LET l_ryn.ryn04 = NULL
      LET l_ryn.ryn05 = NULL
      LET l_ryn.ryn06 = NULL
      LET l_ryn.ryn09 = NULL
      LET l_ryn.ryn10 = NULL
      LET l_ryn.ryn11 = NULL
      LET l_ryn.ryn12 = NULL
      LET l_ryn.ryn13 = NULL
      LET l_ryn.ryn14 = NULL
      LET l_ryn.ryn15 = NULL
      SELECT COUNT(*) INTO l_n FROM rty_file
         WHERE rty01 = l_ryn.ryn03
           AND rty02 = l_rtx04
      LET l_ryn.ryn04 = l_rtx04
      #檢查是否存在於arti110內,存在寫入類型為變更,不存在寫入類型為新增
      IF l_n = 0 OR cl_null(l_n) THEN
         LET l_ryn.ryn02 = '2'   #新增
         LET l_ryn.ryn05 = '1'   #採購類型,若為新增則採購類型預設為1.自訂貨
         LET l_ryn.ryn14 = 'Y'
      ELSE
         LET l_ryn.ryn02 = '1'   #變更
        #資料若存在於arti110內則用arti110內的資料為預設值
         SELECT rty03,rty04,rty07,rty08,rty09,rty10,rty11,rtyacti,rty12
          INTO l_ryn.ryn05,l_ryn.ryn06,l_ryn.ryn09,l_ryn.ryn10,
               l_ryn.ryn11,l_ryn.ryn12,l_ryn.ryn13,l_ryn.ryn14,l_ryn.ryn15
          FROM rty_file
            WHERE rty01 = l_ryn.ryn03
              AND rty02 = l_rtx04

      END IF
      INSERT INTO ryn_file VALUES(l_ryn.*)
      IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
         LET g_success = 'N'
         CALL cl_err('ins ryn_file',SQLCA.SQLCODE,1)
         CLOSE WINDOW t131_1_w
         RETURN
      END IF

   END FOREACH

   CLOSE WINDOW t131_1_w
END FUNCTION
#FUN-C10018 add END
