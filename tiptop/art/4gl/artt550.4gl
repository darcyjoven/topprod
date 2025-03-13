# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: artt550.4gl
# Descriptions...: 經銷供應商對帳單
# Date & Author..: NO.FUN-960130 08/10/28 BY Sunyanchun
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0025 09/12/07 By cockroach 修改rvd03的判斷
# Modify.........: No.FUN-9C0075 09/12/16 By cockroach xxx930-->xxxplant
#                                                      補全t550_insrve()
# Modify.........: No.TQC-A10128 10/01/18 By Cockroach 添加g_data_plant管控
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A30030 10/03/12 By Cockroach BUG處理
# Modify.........: No.TQC-A30041 10/03/16 By Cockroach add orig/oriu
# Modify.........: No.FUN-A50102 10/06/10 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A70130 10/08/06 By shaoyong  ART單據性質調整,q_smy改为q_oay
# Modify.........: No.FUN-A80105 10/08/24 By lixh1   MARK 掉 oaj06 程式碼
# Modify.........: No.TQC-AB0370 10/11/30 By huangtao
# Modify.........: No.TQC-AC0136 10/12/15 By baogc  在費用對賬頁簽添加費用類型和財務單號兩個欄位
# Modify.........: No.TQC-AC0138 10/12/16 By suncx 費用對賬單身資料抓取改跨庫方式查詢
# Modify.........: No.TQC-AC0415 11/01/06 By huangtao 費用對賬的時候是根據費用單單據日期抓取
# Modify.........: No:TQC-B10045 11/01/07 By shiwuying 审核判断费用对账
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:TQC-B60065 11/06/15 By shiwuying 经销对账抓虛擬類型=1.经销 OR ' ' 的入库单
# Modify.........: No:FUN-B60150 11/06/30 By baogc 庫存對帳抓小於等於單頭截止日期的入庫/倉退單
# Modify.........: No.FUN-B80085 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外
# Modify.........: No:TQC-BB0125 11/11/24 by pauline 控卡user,group 
# Modify.........: No:FUN-BC0124 11/12/28 By suncx 由於費用單結構調整，調整抓取費用單對應欄位,調整的欄位費用類型、財務單號
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:TQC-C50164 12/05/21 by fanbj 刪除後單頭資料沒有清空
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.TQC-C80151 12/08/24 By yangxf 對賬營運中心控管與開窗不符
# Modify.........: No:FUN-D20039 13/01/20 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」
# Modify.........: No:FUN-D30033 13/04/15 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
                                              
DEFINE   g_rvf          DYNAMIC ARRAY OF RECORD
                         rvf02        LIKE rvf_file.rvf02,
                         rvf03        LIKE rvf_file.rvf03,
                         rvf03_desc   LIKE azp_file.azp02,
                         rvf04        LIKE rvf_file.rvf04,
                         rvf05        LIKE rvf_file.rvf05,
                         rvf06        LIKE rvf_file.rvf06,
                         rvv31        LIKE rvv_file.rvv31,
                         rvv031       LIKE rvv_file.rvv031,
                         rvv35        LIKE rvv_file.rvv35,
                         rvv35_desc   LIKE gfe_file.gfe02,
                         rvv38        LIKE rvv_file.rvv38,
                         rvv38t       LIKE rvv_file.rvv38t,
                         rvv17        LIKE rvv_file.rvv17,
                         rvv39        LIKE rvv_file.rvv39,
                         rvv39t       LIKE rvv_file.rvv39t,
                         num_uncheck  LIKE rvv_file.rvv17,
                         rvf07        LIKE rvf_file.rvf07,
                         rvf08        LIKE rvf_file.rvf08
                        END RECORD
DEFINE   g_rvf_t        RECORD
                         rvf02        LIKE rvf_file.rvf02,
                         rvf03        LIKE rvf_file.rvf03,
                         rvf03_desc   LIKE azp_file.azp02,
                         rvf04        LIKE rvf_file.rvf04,
                         rvf05        LIKE rvf_file.rvf05,
                         rvf06        LIKE rvf_file.rvf06,
                         rvv31        LIKE rvv_file.rvv31,
                         rvv031       LIKE rvv_file.rvv031,
                         rvv35        LIKE rvv_file.rvv35,
                         rvv35_desc   LIKE gfe_file.gfe02,
                         rvv38        LIKE rvv_file.rvv38,
                         rvv38t       LIKE rvv_file.rvv38t,
                         rvv17        LIKE rvv_file.rvv17,
                         rvv39        LIKE rvv_file.rvv39,
                         rvv39t       LIKE rvv_file.rvv39t,
                         num_uncheck  LIKE rvv_file.rvv17,
                         rvf07        LIKE rvf_file.rvf07,
                         rvf08        LIKE rvf_file.rvf08
                        END RECORD
DEFINE   g_rve        DYNAMIC ARRAY OF RECORD
                         rve02        LIKE rve_file.rve02,
                         rve03        LIKE rve_file.rve03,
                         rve03_desc   LIKE azp_file.azp02,
                         rve04        LIKE rve_file.rve04,
#                         lua02        LIKE lua_file.lua02,     #TQC-AC0136 ADD  #FUN-BC0124 mark
#                         lua24        LIKE lua_file.lua24,     #TQC-AC0136 ADD  #FUN-BC0124 mark
                         rve05        LIKE rve_file.rve05,
                         lub03        LIKE lub_file.lub03,
                         oaj02        LIKE oaj_file.oaj02,
                         lub09        LIKE lub_file.lub09,     #FUN-BC0124 add
#                         oaj06        LIKE oaj_file.oaj06,    #FUN-A80105
                         lub04        LIKE lub_file.lub04,
                         lub04t       LIKE lub_file.lub04t,
                         lub14        LIKE lub_file.lub14,     #FUN-BC0124 add
                         rve06        LIKE rve_file.rve06
                        END RECORD
DEFINE   g_rve_t      RECORD 
                         rve02        LIKE rve_file.rve02,
                         rve03        LIKE rve_file.rve03,
                         rve03_desc   LIKE azp_file.azp02,
                         rve04        LIKE rve_file.rve04,
#                         lua02        LIKE lua_file.lua02,     #TQC-AC0136 ADD  #FUN-BC0124 mark
#                         lua24        LIKE lua_file.lua24,     #TQC-AC0136 ADD  #FUN-BC0124 mark
                         rve05        LIKE rve_file.rve05,
                         lub03        LIKE lub_file.lub03,
                         oaj02        LIKE oaj_file.oaj02,
                         lub09        LIKE lub_file.lub09,     #FUN-BC0124 add
#                         oaj06        LIKE oaj_file.oaj06,    #FUN-A80105
                         lub04        LIKE lub_file.lub04,
                         lub04t       LIKE lub_file.lub04t,
                         lub14        LIKE lub_file.lub14,     #FUN-BC0124 add
                         rve06        LIKE rve_file.rve06
                        END RECORD      
DEFINE   g_rvd        DYNAMIC ARRAY OF RECORD     
                         rvd02        LIKE rvd_file.rvd02,
                         rvd03        LIKE rvd_file.rvd03,
                         rvd03_desc   LIKE azp_file.azp02             
                      END RECORD
DEFINE   g_rvd_t      RECORD
                         rvd02        LIKE rvd_file.rvd02,
                         rvd03        LIKE rvd_file.rvd03,
                         rvd03_desc   LIKE azp_file.azp02             
                       END RECORD
                         
DEFINE   g_rvc          RECORD LIKE rvc_file.*,
         g_rvc_t        RECORD LIKE rvc_file.*,
         g_rvc00_t      LIKE rvc_file.rvc00,
         g_rvc01_t      LIKE rvc_file.rvc01,
         g_rvcplant_t     LIKE rvc_file.rvcplant,
         g_wc,g_wc1,g_wc2,g_wc3     STRING,
         g_sql          STRING,
         g_rec_b1       LIKE type_file.num5,
         g_rec_b2       LIKE type_file.num5,
         g_rec_b3       LIKE type_file.num5
DEFINE   g_dbs_atm      LIKE type_file.chr1000
DEFINE   p_row,p_col    LIKE type_file.num5
DEFINE   g_b_flag       LIKE type_file.num5
DEFINE   g_row_count    LIKE type_file.num10
DEFINE   g_curs_index   LIKE type_file.num10
DEFINE   g_i            LIKE type_file.num5
DEFINE   g_before_input_done  LIKE type_file.num5
DEFINE   g_forupd_sql   STRING
DEFINE   g_msg          LIKE type_file.chr1000
DEFINE   g_cnt          LIKE type_file.num5
DEFINE   g_jump         LIKE type_file.num10
DEFINE   mi_no_ask      LIKE type_file.num5
DEFINE   g_argv1        LIKE rvc_file.rvc01
DEFINE   g_argv2        LIKE rvc_file.rvc02
DEFINE   g_flag         LIKE type_file.chr1
DEFINE   l_ac1          LIKE type_file.num5
DEFINE   l_ac2          LIKE type_file.num5
DEFINE   l_ac3          LIKE type_file.num5
DEFINE   g_chr          LIKE type_file.chr1
DEFINE   g_rvcplant_desc  LIKE azp_file.azp02
DEFINE   g_t1           LIKE oay_file.oayslip
MAIN
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_argv1 =ARG_VAL(1)
   LET g_argv2 =ARG_VAL(2)
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
 
   LET g_forupd_sql= " SELECT * FROM rvc_file WHERE rvc00 = ? AND rvc01 = ? FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t550_cl CURSOR FROM g_forupd_sql
 
   LET g_b_flag = '2'
 
   LET p_row = 2  LET p_col = 9 
   OPEN WINDOW t550_w AT p_row,p_col WITH FORM "art/42f/artt550"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   IF (NOT cl_null(g_argv1)) AND (NOT cl_null(g_argv2)) THEN
      CALL t550_q()
   END IF   
   DISPLAY '1' TO rvc02
   CALL t550_menu()
 
   CLOSE WINDOW t550_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t550_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01
DEFINE  l_table         LIKE    type_file.chr1000
DEFINE  l_where         LIKE    type_file.chr1000
 
   IF (NOT cl_null(g_argv1)) AND (NOT cl_null(g_argv2)) THEN
      LET g_wc = " rvc01 = '",g_argv1,"'"
      LET g_wc2=" 1=1 "
   ELSE
      CLEAR FORM
      LET g_action_choice=" " 
      CALL cl_set_head_visible("","YES")
      INITIALIZE g_rvc.* TO NULL
      DISPLAY '1' TO rvc02
      CONSTRUCT BY NAME g_wc ON
                rvc01,rvc03,rvc04,rvc05,rvc06,
                rvcconf,rvccond,rvcconu,rvcplant,
                rvcuser,rvcgrup,rvcmodu,
                rvcdate,rvcacti,rvccrat
               ,rvcoriu,rvcorig        #TQC-A30041 ADD
      
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
      
         ON ACTION controlp
            CASE WHEN INFIELD(rvc01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_rvc01_1"
                    LET g_qryparam.default1 = g_rvc.rvc01
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rvc01
                    NEXT FIELD rvc01
                    
                 WHEN INFIELD(rvc03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_rvc03_1"
                    LET g_qryparam.default1 = g_rvc.rvc03
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rvc03
                    NEXT FIELD rvc03
                      
                 WHEN INFIELD(rvcconu)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form = "q_rvcconu_1"
                      LET g_qryparam.default1 = g_rvc.rvcconu
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO rvcconu
                      NEXT FIELD rvcconu
                      
                #TQC-A30030 ADD----------------------------
                 WHEN INFIELD(rvcplant)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form = "q_azp"
                      LET g_qryparam.default1 = g_rvc.rvcplant
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO rvcplant
                      NEXT FIELD rvcplant
                #TQC-A30030 END---------------------------

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
      
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT CONSTRUCT
      
         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
      END CONSTRUCT
      
      IF INT_FLAG OR g_action_choice = "exit" THEN
         RETURN
      END IF
 
      #Begin:FUN-980030
      #      IF g_priv2='4' THEN
      #         LET g_wc = g_wc clipped," AND rvcuser = '",g_user,"'"
      #      END IF
      #      IF g_priv3='4' THEN
      #         LET g_wc = g_wc clipped," AND rvcgrup MATCHES '",g_grup CLIPPED,"*'"
      #      END IF
      
      #      IF g_priv3 MATCHES "[5678]" THEN
      #         LET g_wc = g_wc clipped," AND rvcgrup IN ",cl_chk_tgrup_list()
      #      END IF
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rvcuser', 'rvcgrup')
      #End:FUN-980030
      
      CONSTRUCT g_wc2 ON rvf02,rvf03,rvf04,rvf05,rvf06,rvf07,rvf08 
           FROM s_rvf[1].rvf02,s_rvf[1].rvf03,s_rvf[1].rvf04,
                s_rvf[1].rvf05,s_rvf[1].rvf06,s_rvf[1].rvf07,
                s_rvf[1].rvf08
                
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
      
         ON ACTION controlp
            CASE WHEN INFIELD(rvf03)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.form     = "q_rvf03_1"
                      LET g_qryparam.default1 = g_rvf[1].rvf03
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO rvf03
                      NEXT FIELD rvf03
                  WHEN INFIELD(rvf05)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.form     = "q_rvf05_1"
                      LET g_qryparam.default1 = g_rvf[1].rvf05
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO rvf05
                      NEXT FIELD rvf05
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
      
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END CONSTRUCT
      IF INT_FLAG THEN
         RETURN
      END IF
      
      CONSTRUCT g_wc3 ON rve02,rve03,rve04,rve05,rve06
           FROM s_rve[1].rve02,s_rve[1].rve03,s_rve[1].rve04,
                s_rve[1].rve05,s_rve[1].rve06
                
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
      
         ON ACTION controlp
            CASE WHEN INFIELD(rve03)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.form     = "q_rve03"
                      LET g_qryparam.default1 = g_rve[1].rve03
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO rve03
                      NEXT FIELD rve03
                      
                 WHEN INFIELD(rve04)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.form     = "q_rve04"
                      LET g_qryparam.default1 = g_rve[1].rve04
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO rve04
                      NEXT FIELD rve04
 
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
      
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END CONSTRUCT
      IF INT_FLAG THEN
         RETURN
      END IF
   END IF
 
   LET g_sql = "SELECT UNIQUE rvc00,rvc01 " 
   LET l_table = " FROM rvc_file "
   LET l_where = " WHERE ",g_wc 
   IF g_wc2 <> " 1=1" THEN
      LET l_table = l_table,",rvf_file"
      LET l_where = l_where," AND rvf00 = rvc00 AND rvf01 = rvc01 AND ",g_wc2
   END IF
   IF g_wc3 <> " 1=1" THEN 
      LET l_table = l_table,",rve_file" 
      LET l_where = l_where," AND rve00 = rvc00 AND rve01 = rvc01 AND ",g_wc3
   END IF
   LET l_where = l_where," AND rvc00 = '1' AND rvc02 = '1' "
   LET g_sql = g_sql,l_table,l_where
 
   PREPARE t550_prepare FROM g_sql
   DECLARE t550_cs SCROLL CURSOR WITH HOLD FOR t550_prepare
 
   LET g_sql = "SELECT COUNT(DISTINCT rvc00||rvc01) ",l_table,l_where
   PREPARE t550_precount FROM g_sql
   DECLARE t550_count CURSOR FOR t550_precount
END FUNCTION
 
FUNCTION t550_menu()
 
   WHILE TRUE
      IF g_action_choice = "exit"  THEN
         EXIT WHILE
      END IF
 
      CASE g_b_flag
         WHEN '2'
            CALL t550_bp1("G")
            CALL t550_b1_fill(g_wc2)
         WHEN '3'
            CALL t550_bp2("G")
            CALL t550_b2_fill(g_wc3)
         OTHERWISE 
            CALL t550_bp1("G")
            CALL t550_b1_fill(g_wc2)
      END CASE
 
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t550_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t550_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t550_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t550_u()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               IF g_b_flag = 2 THEN
                  CALL t550_b1()
               END IF
               IF g_b_flag = 3 THEN
                  CALL t550_b2()
               END IF
            END IF
 
         WHEN "invalid"                                                                                                             
            IF cl_chk_act_auth() THEN           
               CALL t550_x()  
            END IF
 
         WHEN "exporttoexcel"                                                                                                       
            IF cl_chk_act_auth() THEN                                                                                               
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rvc),'','')         
            END IF
    #TQC-AB0370  ----------------mark
    #    WHEN "output"                 
    #       IF cl_chk_act_auth() THEN 
    #          #CALL t550_out() 
    #       END IF
    #TQC-AB0370 -----------------mark
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "confirm"                                                                                                             
            IF cl_chk_act_auth() THEN            
               CALL t550_yes()
            END IF                                                                                                                  
                                                                                                                                    
         WHEN "void"                                                                                                                 
            IF cl_chk_act_auth() THEN     
               CALL t550_void(1) 
            END IF
        
         #FUN-D20039 -------------sta
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t550_void(2)
            END IF
         #FUN-D20039 -------------end
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "curr_plant"
            IF cl_chk_act_auth() THEN     
               CALL t550_org() 
            END IF
            
         WHEN "in_store"
            LET g_b_flag = "2"
            CALL t550_b1_fill(g_wc2) 
            CALL t550_bp1_refresh()       
 
         WHEN "feiyong"
            LET g_b_flag = "3"
            CALL t550_b2_fill(g_wc3)            
            CALL t550_bp2_refresh()
 
       WHEN "related_document"
          IF cl_chk_act_auth() THEN
             IF g_rvc.rvc01 IS NOT NULL THEN
                LET g_doc.column1 = "rvc01"
                LET g_doc.column2 = "rvc02"
                LET g_doc.value1 = g_rvc.rvc01
                LET g_doc.value2 = g_rvc.rvc02
                CALL cl_doc()
             END IF 
          END IF
      END CASE
   END WHILE
END FUNCTION
FUNCTION t550_void(p_type)
DEFINE p_type    LIKE type_file.chr1   #FUN-D20039  add '1' 作废  '2' 取消作废
DEFINE l_n LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_rvc.* FROM rvc_file WHERE rvc01 = g_rvc.rvc01
                                         AND rvc00 = g_rvc.rvc00
   IF g_rvc.rvc01 IS NULL OR g_rvc.rvc00 IS NULL 
      OR g_rvc.rvcplant IS NULL THEN 
      CALL cl_err('',-400,0) 
      RETURN 
   END IF
   #FUN-D20039 ----------sta
    IF p_type = 1 THEN
       IF g_rvc.rvcconf='X' THEN RETURN END IF
    ELSE
       IF g_rvc.rvcconf<>'X' THEN RETURN END IF
    END IF
    #FUN-D20039 ----------end
   IF g_rvc.rvcconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rvc.rvcacti = 'N' THEN CALL cl_err(g_rvc.rvc01,'art-142',0) RETURN END IF

   BEGIN WORK
 
   OPEN t550_cl USING g_rvc.rvc00,g_rvc.rvc01
   IF STATUS THEN
      CALL cl_err("OPEN t550_cl:", STATUS, 1)
      CLOSE t550_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t550_cl INTO g_rvc.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rvc.rvc01,SQLCA.sqlcode,0)
      CLOSE t550_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   IF cl_void(0,0,g_rvc.rvcconf) THEN
      LET g_chr = g_rvc.rvcconf
      IF g_rvc.rvcconf = 'N' THEN
         LET g_rvc.rvcconf = 'X'
      ELSE
         LET g_rvc.rvcconf = 'N'
      END IF
 
      UPDATE rvc_file SET rvcconf=g_rvc.rvcconf,
                          rvcmodu=g_user,
                          rvcdate=g_today
       WHERE rvc01 = g_rvc.rvc01
         AND rvc00 = g_rvc.rvc00
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("upd","rvc_file",g_rvc.rvc01,"",SQLCA.sqlcode,"","up rvcconf",1)
          LET g_rvc.rvcconf = g_chr
          ROLLBACK WORK
          RETURN
       END IF
   END IF
 
   CLOSE t550_cl
   COMMIT WORK
 
   SELECT * INTO g_rvc.* FROM rvc_file WHERE rvc01=g_rvc.rvc01
                                         AND rvc00 = g_rvc.rvc00
   DISPLAY BY NAME g_rvc.rvcconf                                                                                        
   DISPLAY BY NAME g_rvc.rvcmodu                                                                                        
   DISPLAY BY NAME g_rvc.rvcdate
    #CKP
   IF g_rvc.rvcconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_rvc.rvcconf,"","","",g_chr,"")
 
   CALL cl_flow_notify(g_rvc.rvc01,'V')
 
END FUNCTION
FUNCTION t550_yes()
DEFINE l_cnt1         LIKE type_file.num5
DEFINE l_cnt2         LIKE type_file.num5
DEFINE l_cnt3         LIKE type_file.num5
DEFINE l_cnt4         LIKE type_file.num5
DEFINE l_count        LIKE type_file.num5
DEFINE l_gen02        LIKE gen_file.gen02
DEFINE l_rvd03        LIKE rvd_file.rvd03
DEFINE l_rvf08        LIKE rvf_file.rvf08
DEFINE l_flag         LIKE type_file.num5
DEFINE l_org          LIKE azp_file.azp01
 
    IF g_rvc.rvc01 IS NULL OR g_rvc.rvcplant IS NULL THEN 
       CALL cl_err('',-400,0) 
       RETURN 
    END IF
#CHI-C30107 -------------- add --------------- begin
    IF g_rvc.rvcconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    IF g_rvc.rvcconf = 'X' THEN CALL cl_err(g_rvc.rvc01,'9024',0) RETURN END IF
    IF g_rvc.rvcacti = 'N' THEN CALL cl_err(g_rvc.rvc01,'art-142',0) RETURN END IF
    IF NOT cl_confirm('art-026') THEN RETURN END IF
#CHI-C30107 -------------- add --------------- end
    SELECT * INTO g_rvc.* FROM rvc_file WHERE rvc01=g_rvc.rvc01 
                                          AND rvc00 = g_rvc.rvc00
    IF g_rvc.rvcconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    IF g_rvc.rvcconf = 'X' THEN CALL cl_err(g_rvc.rvc01,'9024',0) RETURN END IF 
    IF g_rvc.rvcacti = 'N' THEN CALL cl_err(g_rvc.rvc01,'art-142',0) RETURN END IF
 
    SELECT SUM(rvf08) INTO l_rvf08 FROM rvf_file 
        WHERE rvf00 = g_rvc.rvc00
          AND rvf01 = g_rvc.rvc01
    IF l_rvf08 IS NULL THEN LET l_rvf08 = 0 END IF
   #TQC-B10045 Begin---
   #IF l_rvf08 = 0 THEN CALL cl_err('','art-509',0) RETURN END IF
    LET g_cnt = 0
    SELECT count(*) INTO g_cnt FROM rve_file
       WHERE rve00 = g_rvc.rvc00
         AND rve01 = g_rvc.rvc01
         AND rveplant = g_rvc.rvcplant
    IF cl_null(g_cnt) THEN LET g_cnt = 0 END IF
    IF l_rvf08 = 0 AND g_cnt = 0 THEN CALL cl_err('','art-509',0) RETURN END IF
   #TQC-B10045 End-----
 
    CALL s_showmsg_init()
    #檢查對帳機構中所有的上級機構和下機構機構是否已經對過帳
    CALL s_check(g_rvc.rvc00,g_rvc.rvc01,g_rvc.rvcplant,g_rvc.rvc03,g_rvc.rvc04,g_rvc.rvc05)
       RETURNING l_flag
    IF l_flag = 0 THEN
       CALL s_showmsg()
       RETURN
    END IF
 
#   IF NOT cl_confirm('art-026') THEN RETURN END IF #CHI-C30107 mark
    BEGIN WORK
    OPEN t550_cl USING g_rvc.rvc00,g_rvc.rvc01
    IF STATUS THEN
       CALL cl_err("OPEN t550_cl:", STATUS, 1)
       CLOSE t550_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t550_cl INTO g_rvc.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_rvc.rvc01,SQLCA.sqlcode,0)
       CLOSE t550_cl 
       ROLLBACK WORK 
       RETURN
    END IF
 
    LET g_success = 'Y'
    LET l_cnt2 = 0
    LET l_cnt3 = 0
   
    SELECT COUNT(*) INTO l_cnt2 FROM rvf_file                                                                                   
       WHERE rvf01 = g_rvc.rvc01 
         AND rvf00 = g_rvc.rvc00 
 
    SELECT COUNT(*) INTO l_cnt3 FROM rve_file
       WHERE rve01=g_rvc.rvc01 
         AND rve00 = g_rvc.rvc00 
 
    IF l_cnt2 = 0 AND l_cnt3 = 0 THEN 
       CALL cl_err('','mfg-009',0)
       ROLLBACK WORK
       RETURN
    END IF
 
    UPDATE rvc_file SET rvcconf='Y',
                        rvccond=g_today, 
                        rvcconu=g_user
        WHERE rvc01 = g_rvc.rvc01 
          AND rvc00 = g_rvc.rvc00
   IF SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   END IF
 
   IF g_success = 'Y' THEN
      LET g_rvc.rvcconf='Y'
      LET g_rvc.rvccond=g_today    #TQC-A30030 ADD
      LET g_rvc.rvcconu=g_user     #TQC-A30030 ADD
      COMMIT WORK
      CALL cl_flow_notify(g_rvc.rvc01,'Y')
   ELSE
      ROLLBACK WORK
   END IF
   
   SELECT * INTO g_rvc.* FROM rvc_file WHERE rvc01=g_rvc.rvc01 
                                         AND rvc00 = g_rvc.rvc00
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rvc.rvcconu
   DISPLAY BY NAME g_rvc.rvcconf                                                                                         
   DISPLAY BY NAME g_rvc.rvccond                                                                                         
   DISPLAY BY NAME g_rvc.rvcconu
   DISPLAY l_gen02 TO FORMONLY.rvcconu_desc
    #CKP
   IF g_rvc.rvcconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_rvc.rvcconf,"","","",g_chr,"")
 
   CALL cl_flow_notify(g_rvc.rvc01,'V')
END FUNCTION
 
FUNCTION t550_rvcplant()
DEFINE l_azp02    LIKE  azp_file.azp02
 
    SELECT azp02 INTO l_azp02 FROM azp_file
       WHERE azp01 = g_plant
    DISPLAY l_azp02 TO FORMONLY.rvcplant_desc
END FUNCTION
FUNCTION t550_a()
DEFINE li_result   LIKE type_file.num5
DEFINE l_n         LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
 
   CALL g_rvf.clear()
   CALL g_rve.clear()
 
   INITIALIZE g_rvc.* LIKE rvc_file.*
   LET g_rvc01_t = NULL
   LET g_rvcplant_t = NULL
   
   CALL cl_opmsg('a')
   WHILE TRUE
       LET g_rvc.rvc00 = '1'
       LET g_rvc.rvc02 = '1'
       LET g_rvc.rvc05 = g_today
       LET g_rvc.rvcplant = g_plant
       LET g_rvc.rvclegal = g_legal
       LET g_rvc.rvcconf = 'N'
       LET g_rvc.rvcuser = g_user
       LET g_rvc.rvcoriu = g_user #FUN-980030
       LET g_rvc.rvcorig = g_grup #FUN-980030
       LET g_data_plant  = g_plant #TQC-A10128 ADD
       LET g_rvc.rvcgrup = g_grup
       LET g_rvc.rvcmodu = NULL
       LET g_rvc.rvcdate = NULL
       LET g_rvc.rvcacti = 'Y'
       LET g_rvc.rvccrat = g_today
       CALL t550_rvcplant()
       CALL t550_i("a")
       IF INT_FLAG THEN
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           CLEAR FORM
           DISPLAY '1' TO rvc02
           CALL g_rvf.clear()
           CALL g_rve.clear()
           EXIT WHILE
       END IF
       IF g_rvc.rvc01 IS NULL OR g_rvc.rvcplant IS NULL 
          OR g_rvc.rvc00 IS NULL THEN
          CONTINUE WHILE
       END IF
       BEGIN WORK
      #CALL s_auto_assign_no("art",g_rvc.rvc01,g_today,"","rvc_file","rvc00,rvc01,rvcplant","","","")#No.FUN-A70130
       CALL s_auto_assign_no("art",g_rvc.rvc01,g_today,"E3","rvc_file","rvc00,rvc01,rvcplant","","","")#No.FUN-A70130
          RETURNING li_result,g_rvc.rvc01
       IF (NOT li_result) THEN                                                                           
           CONTINUE WHILE                                                                     
       END IF
       DISPLAY BY NAME g_rvc.rvc01
       INSERT INTO rvc_file VALUES(g_rvc.*)     # DISK WRITE
       IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
       #   ROLLBACK WORK       # FUN-B80085---回滾放在報錯後---
          CALL cl_err3("ins","rvc_file",g_rvc.rvc01,g_rvc.rvcplant,SQLCA.SQLCODE,"","",1) 
          ROLLBACK WORK        # FUN-B80085--add--
          CONTINUE WHILE
       ELSE
          # FUN-B80085增加空白行

          SELECT * FROM rvd_file WHERE rvd00 =g_rvc.rvc00 AND rvd01=g_rvc.rvc01
                                   AND rvd02 = '1'
          IF SQLCA.SQLCODE = 100 THEN 
             INSERT INTO rvd_file(rvd00,rvd01,rvd02,rvd03,rvdplant,rvdlegal)
                           VALUES('1',g_rvc.rvc01,1,g_rvc.rvcplant,g_rvc.rvcplant,
                                  g_rvc.rvclegal)
             IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
             #   ROLLBACK WORK       # FUN-B80085---回滾放在報錯後---
                CALL cl_err3("ins","rvc_file",g_rvc.rvc01,g_rvc.rvcplant,SQLCA.SQLCODE,"","",1) 
                ROLLBACK WORK        # FUN-B80085--add--
                CONTINUE WHILE
             END IF
          END IF
          COMMIT WORK
          LET g_rvc_t.* = g_rvc.*
       END IF
       LET g_rec_b1=0
       LET g_rec_b2=0
 
       CALL t550_org()
       CALL t550_insrvf()
       CALL t550_insrve()
      
       #如果單身沒有合乎條件的資料自動刪除單頭       
       SELECT COUNT(*) INTO l_n FROM rvf_file 
            WHERE rvf00 = g_rvc.rvc00
              AND rvf01 = g_rvc.rvc01
             #AND rvf930 = g_rvc.rvcplant     #FUN-9C0075 MARK
              AND rvfplant=g_rvc.rvcplant     #FUN-9C0075 ADD
       IF l_n IS NULL THEN LET l_n = 0 END IF
       
       IF l_n = 0 THEN
          SELECT COUNT(*) INTO l_n FROM rve_file
               WHERE rve00 = g_rvc.rvc00
                 AND rve01 = g_rvc.rvc01
                #AND rve930 = g_rvc.rvcplant    #FUN-9C0075 MARK
                 AND rveplant=g_rvc.rvcplant    #FUN-9C0075 ADD
          IF l_n IS NULL THEN LET l_n = 0 END IF
       END IF
       IF l_n = 0 THEN 
          CALL cl_err('','apm-204',1)
#FUN-9C0075 ADD---
          DELETE FROM rvd_file WHERE rvd00 = g_rvc.rvc00
               AND rvd01 = g_rvc.rvc01 AND rvdplant = g_rvc.rvcplant 
#FUN-9C0075 END---
          DELETE FROM rvc_file WHERE rvc00 = g_rvc.rvc00
               AND rvc01 = g_rvc.rvc01 AND rvcplant = g_rvc.rvcplant
          RETURN
       END IF
       CALL t550_b1_fill(" 1=1 ")
       CALL t550_b2_fill(" 1=1 ")
                                                                                                       
       CALL t550_b1()                                                                                                             
       CALL t550_b2()
       CALL t550_delall()
       EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION t550_insrve()
DEFINE l_rvd03   LIKE rvd_file.rvd03
#FUN-9C0075 ADD START-------- 
DEFINE l_lub01     LIKE lub_file.lub01
DEFINE l_lub02     LIKE lub_file.lub02 
DEFINE l_cnt       LIKE type_file.num5
DEFINE l_dbs       LIKE azp_file.azp03
#FUN-9C0075 ADD END--------  
DEFINE l_n         LIKE type_file.num5      #TQC-AB0370
  
    LET g_sql = "SELECT DISTINCT rvd03 FROM rvd_file WHERE rvd00 ='",g_rvc.rvc00,
               #"' AND rvd01 = '",g_rvc.rvc01,"' AND rvd930 = '",    #FUN-9C0075 mark 
                "' AND rvd01 = '",g_rvc.rvc01,"' AND rvdplant = '",  #FUN-9C0075 add
                g_rvc.rvcplant,"'"
    PREPARE pre_get_rvd FROM g_sql
    DECLARE pre_rvd_cur CURSOR FOR pre_get_rvd

    LET g_cnt = 1      #FUN-9C0075 ADD 
    LET l_cnt = 1      #FUN-9C0075 ADD 
   
    BEGIN WORK   
    
    FOREACH pre_rvd_cur INTO l_rvd03
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF l_rvd03 IS NULL THEN CONTINUE FOREACH END IF
   #FUN-9C0075 ADD START--------------------- 
#      LET g_sql = "SELECT lub01,lub02 FROM lub_file WHERE rub01 = rua01 ",
#                  "  AND rua15 = 'Y' AND rua17 BETWEEN '",g_rvc.rvc04,"'",
#                  " AND '",g_rvc.rvc05,"'"
#   END FOREACH
#   COMMIT WORK
      #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_rvd03
       LET g_plant_new = l_rvd03
       CALL s_gettrandbs()
       LET l_dbs=g_dbs_tra
       LET l_dbs = s_dbstring(l_dbs CLIPPED)   
    
       LET g_sql = "SELECT lub01,lub02 ",
                   #"  FROM ",l_dbs,"lua_file,",l_dbs,"lub_file ", #FUN-A50102
                   "  FROM ",cl_get_target_table(l_rvd03, 'lua_file'),",",cl_get_target_table(l_rvd03, 'lub_file'), #FUN-A50102
                   " WHERE lub01 = lua01 ",
                   "   AND lua15 = 'Y' AND lua06 = '",g_rvc.rvc03,"'",
        #           "   AND lua17 BETWEEN '",g_rvc.rvc04,"' AND '",g_rvc.rvc05,"'",            #TQC-AC0415   mark
                   "   AND lua09 BETWEEN '",g_rvc.rvc04,"' AND '",g_rvc.rvc05,"'",             #TQC-AC0415
                   " AND lubplant = '",l_rvd03,"'"
                 #  " AND lua11 = '1' " 
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
       CALL cl_parse_qry_sql(g_sql, l_rvd03) RETURNING g_sql    #FUN-A50102
       PREPARE pre_lub FROM g_sql
       DECLARE pre_lub_cur CURSOR FOR pre_lub   
       FOREACH pre_lub_cur INTO l_lub01,l_lub02 
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          IF cl_null(l_lub01) OR cl_null(l_lub02)  THEN CONTINUE FOREACH END IF
#TQC-AB0370 ------------------------STA
          SELECT COUNT(*) INTO l_n FROM rve_file
           WHERE rve00 = '1' AND rve03 = l_rvd03
             AND rve05 = l_lub02 AND rve04 = l_lub01
           IF l_n > 0 THEN
              CONTINUE FOREACH
           END IF
#TQC-AB0370 ------------------------END
          INSERT INTO rve_file(rve00,rve01,rve02,rve03,rve04,rve05,rve06, 
                              rveplant,rvelegal)
                        VALUES('1',g_rvc.rvc01,g_cnt,l_rvd03,l_lub01,
                               l_lub02,'Y',g_rvc.rvcplant,g_rvc.rvclegal) 
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","rve_file",g_rvc.rvc01,"",SQLCA.sqlcode,"","",1)
             ROLLBACK WORK
             RETURN
          END IF
          
          LET g_cnt = g_cnt + 1
       END FOREACH
    END FOREACH
    COMMIT WORK
#FUN-9C0075 ADD END--------------------- 
END FUNCTION
 
FUNCTION t550_insrvf()
DEFINE l_rvd03     LIKE rvd_file.rvd03
DEFINE l_rvv03     LIKE rvv_file.rvv03
DEFINE l_rvv01     LIKE rvv_file.rvv01
DEFINE l_rvv02     LIKE rvv_file.rvv02
DEFINE l_rvv17     LIKE rvv_file.rvv17
DEFINE l_sum       LIKE rvv_file.rvv17
DEFINE l_cnt       LIKE type_file.num5
DEFINE l_dbs       LIKE azp_file.azp03
 
    LET g_sql = "SELECT DISTINCT rvd03 FROM rvd_file ",
                " WHERE rvd00 = '",g_rvc.rvc00,"'",
                " AND rvd01 = '",g_rvc.rvc01,"'" 
    PREPARE pre_get_rvd2 FROM g_sql
    DECLARE pre_rvd_cur2 CURSOR FOR pre_get_rvd2
  
    LET g_cnt = 1
    LET l_cnt = 1
    BEGIN WORK   
    #遍歷所有的對帳機構
    FOREACH pre_rvd_cur2 INTO l_rvd03
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF l_rvd03 IS NULL THEN CONTINUE FOREACH END IF
 
      #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_rvd03
       LET g_plant_new = l_rvd03
       CALL s_gettrandbs()
       LET l_dbs=g_dbs_tra
       LET l_dbs = s_dbstring(l_dbs CLIPPED)
 
       LET g_sql = "SELECT rvv03,rvv01,rvv02,rvv17 ",
                  #"    FROM ",l_dbs,"rvv_file,",l_dbs,"rvu_file ", #FUN-A50102
                   "    FROM ",cl_get_target_table(l_rvd03, 'rvv_file'),",",cl_get_target_table(l_rvd03, 'rvu_file'), #FUN-A50102
                   "   WHERE rvv01 = rvu01 AND rvv03 = rvu00 ",
                   "     AND rvu04 = '",g_rvc.rvc03,"'",
                  #"     AND rvuconf = 'Y' AND rvucond BETWEEN '",  #FUN-B60150 MARK
                  #g_rvc.rvc04,"' AND '",g_rvc.rvc05,"'",           #FUN-B60150 MARK
                   "     AND rvuconf = 'Y' AND rvucond <= '",g_rvc.rvc05,"' ",  #FUN-B60150 ADD
                   " AND rvvplant = '",l_rvd03,"'",
                  #" AND rvu21 = '1' "                       #TQC-B60065
                   " AND (rvu27 = '1' OR rvu27 = ' ') "      #TQC-B60065
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql          #FUN-A50102
       CALL cl_parse_qry_sql(g_sql, l_rvd03) RETURNING g_sql #FUN-A50102            
       PREPARE pre_rvv FROM g_sql
       DECLARE pre_rvv_cur CURSOR FOR pre_rvv   
       FOREACH pre_rvv_cur INTO l_rvv03,l_rvv01,l_rvv02,l_rvv17 
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          IF cl_null(l_rvv03) OR cl_null(l_rvv01) OR cl_null(l_rvv02) THEN CONTINUE FOREACH END IF
          
          #計算該單、項次已經對帳過的數量
          SELECT SUM(rvf08) INTO l_sum FROM rvf_file,rvc_file 
               WHERE rvc00 = rvf00
                 AND rvc01 = rvf01
                 AND rvcplant= rvfplant
               # AND rvcconf = 'Y'  #TQC-B60065
                 AND rvcconf <> 'X' #TQC-B60065
                 AND rvf00 = g_rvc.rvc00
                 AND rvf05 = l_rvv01 
                 AND rvf06 = l_rvv02
          IF l_sum IS NULL THEN LET l_sum = 0 END IF
          LET l_rvv17 = l_rvv17 - l_sum
          IF l_rvv17 <= 0 THEN CONTINUE FOREACH END IF
 
          IF l_rvv03 = '1' THEN
             INSERT INTO rvf_file(rvf00,rvf01,rvf02,rvf03,rvf04,rvf05,rvf06,rvf07,rvf08, #FUN-9C0075 ADD rvf00	
                                  rvfplant,rvflegal)
                           VALUES('1',g_rvc.rvc01,g_cnt,l_rvd03,'1',
                                   l_rvv01,l_rvv02,'Y',l_rvv17,g_rvc.rvcplant,
                                   g_rvc.rvclegal)
          END IF
          IF l_rvv03 = '3' THEN
             INSERT INTO rvf_file(rvf00,rvf01,rvf02,rvf03,rvf04,rvf05,rvf06,rvf07,rvf08,  #FUN-9C0075 ADD rvf00
                                  rvfplant,rvflegal) 
                          VALUES('1',g_rvc.rvc01,g_cnt,l_rvd03,'2',
                                 l_rvv01,l_rvv02,'Y',l_rvv17,g_rvc.rvcplant,
                                 g_rvc.rvclegal)
          END IF
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","rvf_file",g_rvc.rvc01,"",SQLCA.sqlcode,"","",1)
             ROLLBACK WORK
             RETURN
          END IF
          
          LET g_cnt = g_cnt + 1
       END FOREACH
    END FOREACH
 
    COMMIT WORK
END FUNCTION
FUNCTION t550_org()
 
    IF cl_null(g_rvc.rvc00) OR cl_null(g_rvc.rvc01)
       OR cl_null(g_rvc.rvcplant) THEN
       RETURN
    END IF
 
    LET p_row = 4 LET p_col = 10
    OPEN WINDOW t550_1_w AT p_row,p_col WITH FORM "art/42f/artt551_1"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
  
    CALL cl_ui_init()
    
    CALL t550_1_fill(" 1=1 ")
    CALL t550_1_b()
    CALL t550_1_menu()
    CLOSE WINDOW t550_1_w
    LET g_action_choice = ""
END FUNCTION
FUNCTION t550_1_menu()
WHILE TRUE
      CALL t550_1_bp("G")
      CASE g_action_choice
      
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t550_1_q()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t550_1_b()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rvd),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
FUNCTION t550_1_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rvd TO s_rvd.* ATTRIBUTE(COUNT=g_rec_b3,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac3 = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac3 = 1
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac3 = ARR_CURR()
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
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION t550_1_q()
 
   CLEAR FORM
   CALL g_rvd.clear()
   DISPLAY ' ' TO FORMONLY.cn2
 
   CONSTRUCT g_wc3 ON rvd02,rvd03 FROM s_rvd[1].rvd02,s_rvd[1].rvd03
        BEFORE CONSTRUCT 
           CALL cl_qbe_init()
        ON ACTION controlp
           CASE WHEN INFIELD(rvd03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.arg1 = '1'
                   LET g_qryparam.arg2 = g_rvc.rvc01
                   LET g_qryparam.arg3 = g_rvc.rvcplant
                   LET g_qryparam.form = "q_rvd03"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rvd03
            END CASE
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
 
        ON ACTION about
           CALL cl_about()
        ON ACTION controlg
           CALL cl_cmdask()
   END CONSTRUCT       
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc3 = NULL
      LET g_rec_b3 = 0
      RETURN
   END IF
   CALL t550_1_fill(g_wc3)
END FUNCTION 
FUNCTION t550_1_b()
DEFINE l_ac3_t         LIKE type_file.num5,
       l_n             LIKE type_file.num5,
       l_cnt           LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,
       p_cmd           LIKE type_file.chr1,
       l_allow_insert  LIKE type_file.num5,
       l_allow_delete  LIKE type_file.num5
 
    LET g_action_choice=""
    IF s_shut(0) THEN RETURN END IF
 
    SELECT * INTO g_rvc.* FROM rvc_file
       WHERE rvc01=g_rvc.rvc01 
         AND rvc00 = g_rvc.rvc00
        
    IF g_rvc.rvcacti = 'N' THEN CALL cl_err('','mfg1000',0) RETURN END IF     
    IF g_rvc.rvcconf='Y' THEN CALL cl_err('','art-046',0) RETURN END IF
    IF g_rvc.rvcconf='X' THEN CALL cl_err('',9024,0) RETURN END IF
 
    LET g_forupd_sql="SELECT rvd02,rvd03,'' FROM rvd_file ",
                     " WHERE rvd00 = '1' AND rvd01 = '",g_rvc.rvc01,"'",
                     "   AND rvd02 = ? FOR UPDATE  "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t550_1_bcl CURSOR FROM g_forupd_sql
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_rvd WITHOUT DEFAULTS FROM s_rvd.*
        ATTRIBUTE(COUNT=g_rec_b3,MAXCOUNT=g_max_rec,UNBUFFERED,
             INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
             APPEND ROW= l_allow_insert)
 
       BEFORE INPUT
          IF g_rec_b3 !=0 THEN
             CALL fgl_set_arr_curr(l_ac3)
          END IF
       BEFORE ROW 
          LET p_cmd =''
          LET l_ac3 =ARR_CURR()  
          LET l_lock_sw ='N'
          LET l_n =ARR_COUNT()
          
          BEGIN WORK
         
          IF g_rec_b3>=l_ac3 THEN
             LET p_cmd ='u'
             LET g_rvd_t.*=g_rvd[l_ac3].*
             OPEN t550_1_bcl USING g_rvd_t.rvd02
             IF STATUS THEN
                CALL cl_err("OPEN t550_1_bcl:",STATUS,1)
                LET l_lock_sw='Y'
             ELSE
                FETCH t550_1_bcl INTO g_rvd[l_ac3].*
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_rvd_t.rvd02,SQLCA.sqlcode,1)
                   LET l_lock_sw="Y"
                END IF
                CALL t550_rvd03()
             END IF
          END IF   
 
       BEFORE INSERT
          LET l_n=ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE g_rvd[l_ac3].* TO NULL  
          LET g_rvd_t.*=g_rvd[l_ac3].*   
          CALL cl_show_fld_cont()
          NEXT FIELD rvd02
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG=0 
             CANCEL INSERT
          END IF
          INSERT INTO rvd_file(rvd00,rvd01,rvd02,rvd03,rvdplant,rvdlegal) 
                        VALUES('1',g_rvc.rvc01,g_rvd[l_ac3].rvd02,g_rvd[l_ac3].rvd03,
                                g_rvc.rvcplant,g_rvc.rvclegal)
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","rvd_file",g_rvc.rvc01,g_rvd[l_ac3].rvd02,SQLCA.sqlcode,"","",1)
             CANCEL INSERT 
          ELSE
             MESSAGE 'INSERT Ok'
             COMMIT WORK
             LET g_rec_b3 = g_rec_b3 + 1
             DISPLAY g_rec_b3 To FORMONLY.cn2  
          END IF
 
       BEFORE FIELD rvd02
          IF g_rvd[l_ac3].rvd02 IS NULL OR g_rvd[l_ac3].rvd02 = 0 THEN
             SELECT max(rvd02)+1
                INTO g_rvd[l_ac3].rvd02
                FROM rvd_file
               WHERE rvd01 = g_rvc.rvc01 AND rvd00 = '1'
             IF g_rvd[l_ac3].rvd02 IS NULL THEN LET g_rvd[l_ac3].rvd02 = 1 END IF
          END IF
       AFTER FIELD rvd02 
          IF NOT cl_null(g_rvd[l_ac3].rvd02) THEN
             IF g_rvd[l_ac3].rvd02 != g_rvd_t.rvd02
                OR g_rvd_t.rvd02 IS NULL THEN
                SELECT count(*) INTO l_n FROM rvd_file
                   WHERE rvd00 = '1' AND rvd01 = g_rvc.rvc01
                     AND rvd02 = g_rvd[l_ac3].rvd02 
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_rvd[l_ac3].rvd02 = g_rvd_t.rvd02
                   NEXT FIELD rvd02
                END IF 
             END IF
          END IF    
 
       AFTER FIELD rvd03
          IF NOT cl_null(g_rvd[l_ac3].rvd03) THEN  
             IF g_rvd[l_ac3].rvd03 != g_rvd_t.rvd03
                OR g_rvd_t.rvd03 IS NULL THEN 
                SELECT COUNT(*) INTO l_n FROM rvd_file 
                   WHERE rvd00 = g_rvc.rvc00 
                     AND rvd01 = g_rvc.rvc01
                     AND rvd03 = g_rvd[l_ac3].rvd03
                IF l_n IS NULL THEN LET l_n = 0 END IF
                IF l_n > 0 THEN
                   CALL cl_err(g_rvd[l_ac3].rvd03,-239,1)
                   NEXT FIELD rvd03
                END IF
 
                CALL t550_rvd03()
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD rvd03
                END IF
             END IF
          END IF
 
       BEFORE DELETE
          DISPLAY "BEFORE DELETE"
          IF g_rvd_t.rvd02 > 0 AND g_rvd_t.rvd02 IS NOT NULL THEN
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
             DELETE FROM rvd_file  WHERE rvd01 = g_rvc.rvc01 AND rvd00 = g_rvc.rvc00
                                     AND rvd02 = g_rvd_t.rvd02 
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","rvd_file",g_rvc.rvc01,g_rvd_t.rvd02,SQLCA.sqlcode,"","",1)
                ROLLBACK WORK
                CANCEL DELETE
             END IF
             LET g_rec_b3=g_rec_b3-1
             DISPLAY g_rec_b3 TO FORMONLY.cn2
          END IF
          COMMIT WORK
 
       ON ROW CHANGE
          IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rvd[l_ac3].* = g_rvd_t.*
              CLOSE t550_1_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rvd[l_ac3].rvd02,-263,1)
              LET g_rvd[l_ac3].* = g_rvd_t.*
           ELSE
              UPDATE rvd_file SET rvd02=g_rvd[l_ac3].rvd02,
                                  rvd03=g_rvd[l_ac3].rvd03
                  WHERE rvd01=g_rvc.rvc01 AND rvd02=g_rvd_t.rvd02
                    AND rvd00 = g_rvc.rvc00 
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rvd_file",g_rvc.rvc01,g_rvd_t.rvd02,SQLCA.sqlcode,"","",1)
                 LET g_rvd[l_ac3].* = g_rvd_t.*
              ELSE
                 MESSAGE 'UPDATE O.K' 
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           LET l_ac3 = ARR_CURR()
        #  LET l_ac3_t = l_ac3     #FUN-D30033
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rvd[l_ac3].* = g_rvd_t.*
            #FUN-D30033--add--str--
              ELSE
                 CALL g_rvd.deleteElement(l_ac3)
                 IF g_rec_b3 != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac3 = l_ac3_t
                 END IF
            #FUN-D30033--add--end--
              END IF
              CLOSE t550_1_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac3_t = l_ac3     #FUN-D30033
           CLOSE t550_1_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO
           IF INFIELD(rvd02) AND l_ac3 > 1 THEN
              LET g_rvd[l_ac3].* = g_rvd[l_ac3-1].*
              LET g_rvd[l_ac3].rvd02 = g_rec_b3 + 1
              NEXT FIELD rvd02
           END IF
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(rvd03)
                 CALL cl_init_qry_var()
                #LET g_qryparam.form ="q_tqb01_2"     #FUN-9B0025 MARK
                 LET g_qryparam.form ="q_azp"         #FUN-9B0025 ADD
                 #LET g_qryparam.where = "tqb01 IN ",g_auth
                 LET g_qryparam.where = " azp01 IN ",g_auth," "   #TQC-AC0138 add
                 LET g_qryparam.default1 = g_rvd[l_ac3].rvd03
                 CALL cl_create_qry() RETURNING g_rvd[l_ac3].rvd03
                 DISPLAY BY NAME g_rvd[l_ac3].rvd03
                 CALL t550_rvd03()
                 NEXT FIELD rvd03
           END CASE
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
    END INPUT
    CLOSE t550_1_bcl
    COMMIT WORK
 
END FUNCTION
FUNCTION t550_rvd03()
DEFINE l_n        LIKE type_file.num5
DEFINE l_auth     LIKE type_file.chr1000
DEFINE l_sql      STRING     #TQC-C80151 add
 
       LET g_errno = ''      #TQC-C80151 add
       SELECT azp02 INTO g_rvd[l_ac3].rvd03_desc FROM azp_file 
           WHERE azp01 = g_rvd[l_ac3].rvd03
       CASE
          WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
          OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------' 
       END CASE
 
       IF cl_null(g_errno) THEN
         #FUN-9B0025 MARK & ADD START----
         #CALL s_find_down_org(g_rvd[l_ac3].rvd03) RETURNING l_auth
         #LET g_sql = "SELECT COUNT(*) FROM azw_file WHERE azw01 = '",
         #            g_rvd[l_ac3].rvd03,"' AND azw01 IN ",l_auth
         #PREPARE pre_tqb FROM g_sql
         #EXECUTE pre_tqb INTO l_n
         #TQC-C80151 mark begin ---
         #SELECT COUNT(*) INTO l_n FROM azp_file
         #  WHERE azp01 IN (SELECT azw01 FROM azw_file
         #                   WHERE azw07=g_rvc.rvcplant OR azw01=g_rvc.rvcplant)
         #  AND azp01 = g_rvd[l_ac3].rvd03 
         ##FUN-9B0025 MARK &ADD END--------- 
         #TQC-C80151 mark end ---
         #TQC-C80151 add begin ---
          LET l_sql = "SELECT COUNT(*) FROM azp_file ",
                      " WHERE azp01 IN ",g_auth,
                      "   AND azp01 = '",g_rvd[l_ac3].rvd03,"'"
          PREPARE t550_sel_azp01 FROM l_sql
          EXECUTE t550_sel_azp01 INTO l_n
         #TQC-C80151 add end ---
          IF l_n IS NULL THEN LET l_n = 0 END IF
          IF l_n = 0 THEN LET g_errno = 'art-500' END IF
       END IF
END FUNCTION
 
FUNCTION t550_1_bp_refresh()
  DISPLAY ARRAY g_rvd TO s_rvd.* ATTRIBUTE(COUNT=g_rec_b3,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
 
END FUNCTION
FUNCTION t550_1_fill(p_wc2)
DEFINE p_wc2   STRING
 
    LET g_sql = "SELECT rvd02,rvd03,'' FROM rvd_file ",
                " WHERE rvd01 ='",g_rvc.rvc01,"' AND rvd00 = '1' "
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    LET g_sql=g_sql CLIPPED," ORDER BY rvd02 "
  
    PREPARE t550_1_pb FROM g_sql
    DECLARE rvd_1_cs CURSOR FOR t550_1_pb
 
    CALL g_rvd.clear()
    LET g_cnt = 1
    FOREACH rvd_1_cs INTO g_rvd[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT azp02 INTO g_rvd[g_cnt].rvd03_desc FROM azp_file
           WHERE azp01 = g_rvd[g_cnt].rvd03
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_rvd.deleteElement(g_cnt)
 
   LET g_rec_b3=g_cnt-1
   DISPLAY g_rec_b3 TO FORMONLY.cn2
   LET g_cnt = 0
   CALL t550_1_bp_refresh()
END FUNCTION
FUNCTION t550_delall()
DEFINE l_cnt1      LIKE type_file.num5
DEFINE l_cnt2      LIKE type_file.num5
DEFINE l_cnt3      LIKE type_file.num5
DEFINE l_cnt4      LIKE type_file.num5
DEFINE l_count     LIKE type_file.num5
 
   LET l_cnt1 = 0
   LET l_cnt2 = 0
   LET l_cnt3 = 0
   LET l_count = 0
 
   SELECT COUNT(*) INTO l_cnt2 FROM rvf_file                                                                                   
       WHERE rvf01=g_rvc.rvc01 
         AND rvf00 = g_rvc.rvc00
   
   SELECT COUNT(*) INTO l_cnt3 FROM rve_file                                        
       WHERE rve01 = g_rvc.rvc01 
         AND rve00 = g_rvc.rvc00
 
   IF l_cnt2=0 AND l_cnt3=0 THEN
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM rvc_file WHERE rvc01 = g_rvc.rvc01 
                             AND rvc00 = '1'
      DELETE FROM rvd_file WHERE rvd00 = '1' AND rvd01 = g_rvc.rvc01
   END IF
 
END FUNCTION
 
FUNCTION t550_x()
   IF s_shut(0) THEN                                                                                                                
      RETURN                                                                                                                        
   END IF                                                                                                                           
                                                                                                                                    
   IF g_rvc.rvc01 IS NULL OR g_rvc.rvcplant IS NULL 
      OR g_rvc.rvc00 IS NULL THEN                                                                                                      
      CALL cl_err("",-400,0)                                                                                                        
      RETURN                                                                                                                        
   END IF
   IF g_rvc.rvcconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF                                                                 
   IF g_rvc.rvcconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
   BEGIN WORK                                                                                                                       
   OPEN t550_cl USING g_rvc.rvc00,g_rvc.rvc01                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err("OPEN t550_cl:", STATUS, 1)                                                                                       
      CLOSE t550_cl       
      ROLLBACK WORK                                                                                                          
      RETURN                                                                                                                        
   END IF
   FETCH t550_cl INTO g_rvc.*                                                                                                       
   IF SQLCA.sqlcode THEN                                                                                                            
      CALL cl_err(g_rvc.rvc01,SQLCA.sqlcode,0)                                                                                      
      RETURN                                                                                                                        
   END IF
   LET g_success = 'Y'
   CALL t550_show()
   IF g_rvc.rvcconf = 'Y' THEN                                                                                                      
      CALL cl_err('','art-022',0)                                                                                                   
      RETURN                                                                                                                        
   END IF
 
   IF cl_exp(0,0,g_rvc.rvcacti) THEN                                                                                                
      LET g_chr=g_rvc.rvcacti                                                                                                       
      IF g_rvc.rvcacti='Y' THEN                                                                                                     
         LET g_rvc.rvcacti='N'                                                                                                      
      ELSE                                                                                                                          
         LET g_rvc.rvcacti='Y'                                                                                                      
      END IF                                                                                                                        
                                                                                                                                    
      UPDATE rvc_file SET rvcacti=g_rvc.rvcacti,                                                                                    
                          rvcmodu=g_user,                                                                                           
                          rvcdate=g_today                                                                                           
       WHERE rvc01 = g_rvc.rvc01 
         AND rvc00 = g_rvc.rvc00                                                                                                    
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN                                                                                   
         CALL cl_err3("upd","rvc_file",g_rvc.rvc01,"",SQLCA.sqlcode,"","",1)                                         
         LET g_rvc.rvcacti=g_chr                                                                                                    
      END IF                                                                                                                        
   END IF
 
   CLOSE t550_cl                                                                                                                    
                                                                                                                                    
   IF g_success = 'Y' THEN                                                                                                          
      COMMIT WORK                                                                                                                   
      CALL cl_flow_notify(g_rvc.rvc01,'V')                                                                                          
   ELSE                                                                                                                             
      ROLLBACK WORK                                                                                                                 
   END IF                                                                                                                           
                                                                                                                                    
   SELECT rvcacti,rvcmodu,rvcdate                                                                                                   
     INTO g_rvc.rvcacti,g_rvc.rvcmodu,g_rvc.rvcdate FROM rvc_file                                                                   
    WHERE rvc01=g_rvc.rvc01 
      AND rvc00 = g_rvc.rvc00
   DISPLAY BY NAME g_rvc.rvcacti,g_rvc.rvcmodu,g_rvc.rvcdate
END FUNCTION
 
FUNCTION t550_u()
 
   IF s_shut(0) THEN RETURN END IF
   IF g_rvc.rvc01 IS NULL OR g_rvc.rvcplant IS NULL THEN 
      CALL cl_err('',-400,2) RETURN 
   END IF
   SELECT * INTO g_rvc.* FROM rvc_file WHERE rvc00 = g_rvc.rvc00 AND rvc01 = g_rvc.rvc01
 
   IF g_rvc.rvcconf='Y' THEN CALL cl_err('','9022',0) RETURN END IF
 
   IF g_rvc.rvcconf = 'X' THEN 
      CALL cl_err(g_rvc.rvc01,'art-102',0)                                                                                          
      RETURN
   END IF
   
   IF g_rvc.rvcacti = 'N' THEN                                                                                                      
      CALL cl_err('','mfg1000',0)                                                                                                   
      RETURN                                                                                                                        
   END IF
 
   LET g_success = 'Y'
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_rvc01_t = g_rvc.rvc01
   LET g_rvc_t.* = g_rvc.*
   BEGIN WORK
   OPEN t550_cl USING g_rvc.rvc00,g_rvc.rvc01
   FETCH t550_cl INTO g_rvc.*
   IF SQLCA.SQLCODE THEN
      CALL cl_err(g_rvc.rvc01,SQLCA.SQLCODE,0)
      CLOSE t550_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   CALL t550_show()
   WHILE TRUE
      LET g_rvc01_t = g_rvc.rvc01
      LET g_rvc.rvcmodu=g_user
      LET g_rvc.rvcdate=g_today
      CALL t550_i("u")
      IF INT_FLAG THEN
          LET INT_FLAG = 0
          LET g_rvc.*=g_rvc_t.*
          CALL t550_show()
          CALL cl_err('','9001',0)
          EXIT WHILE
      END IF
      UPDATE rvc_file SET rvc_file.* = g_rvc.* WHERE rvc00 = g_rvc.rvc00 AND rvc01 = g_rvc.rvc01
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("upd","rvc_file",g_rvc.rvc01,g_rvc.rvc02,SQLCA.SQLCODE,"","",1)  #No.FUN-660104
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE t550_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION t550_i(p_cmd)
   DEFINE p_cmd        LIKE type_file.chr1,
          l_n          LIKE type_file.num5,
          li_result    LIKE type_file.num5,
          l_azp02      LIKE azp_file.azp02,
          l_gen02      LIKE gen_file.gen02,
          l_pmc03      LIKE pmc_file.pmc03
          
   DISPLAY BY NAME
      g_rvc.rvc01,g_rvc.rvc02, g_rvc.rvc03,g_rvc.rvc04,g_rvc.rvc05,
      g_rvc.rvc06,g_rvc.rvcconf,g_rvc.rvccond,g_rvc.rvcconu,
      g_rvc.rvcplant,g_rvc.rvcuser,g_rvc.rvcmodu,g_rvc.rvcacti,
      g_rvc.rvcgrup,g_rvc.rvcdate,g_rvc.rvccrat
     ,g_rvc.rvcoriu,g_rvc.rvcorig          #TQC-A30041 ADD
   
   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rvc.rvcplant     
   DISPLAY l_azp02 TO FORMONLY.rvcplant_desc
   
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_rvc.rvcconu
   DISPLAY l_gen02 TO FORMONLY.rvcconu_desc
   
   SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01 = g_rvc.rvc03
   DISPLAY l_pmc03 TO FORMONLY.rvc03_desc
   
   CALL cl_set_head_visible("","YES")
   INPUT BY NAME g_rvc.rvcoriu,g_rvc.rvcorig,
         g_rvc.rvc01,g_rvc.rvc03,g_rvc.rvc04,g_rvc.rvc05,g_rvc.rvc06
     
       WITHOUT DEFAULTS
 
       BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t550_set_entry(p_cmd)
           CALL t550_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
           CALL cl_set_docno_format("rvc01")
 
       AFTER FIELD rvc01
           IF NOT cl_null(g_rvc.rvc01) THEN
              IF (p_cmd='a') OR (p_cmd='u' AND g_rvc.rvc01!=g_rvc_t.rvc01) THEN
#                CALL s_check_no("art",g_rvc.rvc01,g_rvc01_t,"M","rvc_file","rvc00,rvc01,rvcplant","")  #FUN-A70130 mark
                 CALL s_check_no("art",g_rvc.rvc01,g_rvc01_t,"E3","rvc_file","rvc00,rvc01,rvcplant","")  #FUN-A70130 mod
                    RETURNING li_result,g_rvc.rvc01
                 IF (NOT li_result) THEN                                                            
                    LET g_rvc.rvc01=g_rvc_t.rvc01                                                                 
                    NEXT FIELD rvc01                                                                                      
                 END IF
              END IF
           END IF
 
       AFTER FIELD rvc03
           IF NOT cl_null(g_rvc.rvc03) THEN
              IF (p_cmd='a') OR (p_cmd='u' AND g_rvc.rvc03!=g_rvc_t.rvc03) THEN
                 CALL t550_rvc03()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD rvc03
                 END IF
              END IF
           END IF
 
       AFTER FIELD rvc05               
          IF NOT cl_null(g_rvc.rvc05) THEN 
             IF g_rvc.rvc05<g_today THEN
                CALL cl_err('','art-459',0)
                NEXT FIELD rvc05
             END IF
          END IF
          
       ON ACTION controlp
          CASE 
             WHEN INFIELD(rvc01)
                LET g_t1=s_get_doc_no(g_rvc.rvc01)
#               CALL q_smy(FALSE,FALSE,g_t1,'ART','M') RETURNING g_t1  #FUN-A70130--mark--
                CALL q_oay(FALSE,FALSE,g_t1,'E3','ART') RETURNING g_t1  #FUN-A70130--mod--
                LET g_rvc.rvc01=g_t1               
                DISPLAY BY NAME g_rvc.rvc01       
                NEXT FIELD rvc01
 
             WHEN INFIELD(rvc03)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_pmc2"
                LET g_qryparam.default1 = g_rvc.rvc03
                CALL cl_create_qry() RETURNING g_rvc.rvc03
                DISPLAY BY NAME g_rvc.rvc03
                NEXT FIELD rvc03
          END CASE
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
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
 
       AFTER INPUT
          LET g_rvc.rvcuser = s_get_data_owner("rvc_file") #FUN-C10039
          LET g_rvc.rvcgrup = s_get_data_group("rvc_file") #FUN-C10039
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             #LET INT_FLAG = 0
             EXIT INPUT
          END IF
          IF g_rvc.rvc04 > g_rvc.rvc05 THEN
             CALL cl_err('','art-501',0)
             NEXT FIELD rvc05
          END IF
 
   END INPUT
END FUNCTION
#
FUNCTION t550_rvc03()
DEFINE l_pmc03     LIKE pmc_file.pmc03
DEFINE l_pmcacti   LIKE pmc_file.pmcacti
 
   SELECT pmc03,pmcacti INTO l_pmc03,l_pmcacti
      FROM pmc_file WHERE pmc01 = g_rvc.rvc03
 
   CASE
      WHEN SQLCA.SQLCODE = 100  LET g_errno = 'art-056'
      WHEN l_pmcacti='N'        LET g_errno = '9028' 
      OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
                                DISPLAY l_pmc03 TO FORMONLY.rvc03_desc
   END CASE
 
END FUNCTION
FUNCTION t550_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_rvc.* TO NULL
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt
   CALL t550_cs()
   IF INT_FLAG OR g_action_choice="exit" THEN
      LET INT_FLAG = 0
      INITIALIZE g_rvc.* TO NULL
      CALL g_rvf.clear()
      CALL g_rve.clear()
      RETURN
   END IF
 
   MESSAGE " SEARCHING ! "
   OPEN t550_cs
   IF SQLCA.SQLCODE THEN
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_rvc.* TO NULL
   ELSE
      OPEN t550_count
      FETCH t550_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t550_fetch('F')
   END IF
   MESSAGE ""
END FUNCTION
 
FUNCTION t550_fetch(p_flag)
   DEFINE   p_flag   LIKE type_file.chr1,
            l_abso   LIKE type_file.num10
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t550_cs INTO g_rvc.rvc00,g_rvc.rvc01
      WHEN 'P' FETCH PREVIOUS t550_cs INTO g_rvc.rvc00,g_rvc.rvc01
      WHEN 'F' FETCH FIRST    t550_cs INTO g_rvc.rvc00,g_rvc.rvc01
      WHEN 'L' FETCH LAST     t550_cs INTO g_rvc.rvc00,g_rvc.rvc01
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
         FETCH ABSOLUTE g_jump t550_cs INTO g_rvc.rvc00,g_rvc.rvc01
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.SQLCODE THEN
      INITIALIZE g_rvc.* TO NULL
      CALL g_rvf.clear()
      CALL g_rvf.clear()
      CALL g_rve.clear()
      CALL cl_err(g_rvc.rvc01,SQLCA.SQLCODE,0)
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
   SELECT * INTO g_rvc.* FROM rvc_file WHERE rvc00 = g_rvc.rvc00 AND rvc01 = g_rvc.rvc01
   IF SQLCA.SQLCODE THEN
      INITIALIZE g_rvc.* TO NULL
      CALL g_rvf.clear()
      CALL g_rvf.clear()
      CALL g_rve.clear()
      CALL cl_err3("sel","rvc_file",g_rvc.rvc01,g_rvc.rvc02,SQLCA.SQLCODE,"","",1)  #No.FUN-660104
      RETURN
   END IF
   LET g_data_owner = g_rvc.rvcuser    #TQC-BB0125 add
   LET g_data_group = g_rvc.rvcgrup    #TQC-BB0125 add
   LET g_data_plant =g_rvc.rvcplant  #TQC-A10128 ADD 
   CALL t550_show()
END FUNCTION
 
FUNCTION t550_show()
   DEFINE l_odb02    LIKE odb_file.odb02
   DEFINE l_azp02    LIKE azp_file.azp02
   DEFINE l_gen02    LIKE gen_file.gen02
   DEFINE l_gem02    LIKE gem_file.gem02
   DEFINE l_pmc03    LIKE pmc_file.pmc03

 
   DISPLAY BY NAME g_rvc.rvcoriu,g_rvc.rvcorig,
      g_rvc.rvc01,g_rvc.rvc02, g_rvc.rvc03,g_rvc.rvc04,g_rvc.rvc05,
      g_rvc.rvc06,g_rvc.rvcconf,g_rvc.rvccond,g_rvc.rvcconu,
      g_rvc.rvcplant,g_rvc.rvcuser,g_rvc.rvcmodu,g_rvc.rvcacti,
      g_rvc.rvcgrup,g_rvc.rvcdate,g_rvc.rvccrat
   
   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rvc.rvcplant     
   DISPLAY l_azp02 TO FORMONLY.rvcplant_desc
   
   SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01 = g_rvc.rvc03
   DISPLAY l_pmc03 TO FORMONLY.rvc03_desc
 
   IF g_rvc.rvcconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF                                                                
   CALL cl_set_field_pic(g_rvc.rvcconf,"","","",g_chr,"")                                                                          
   CALL cl_flow_notify(g_rvc.rvc01,'V') 
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rvc.rvcconu
   DISPLAY l_gen02 TO FORMONLY.rvcconu_desc
 
   CALL t550_b1_fill(g_wc2)
   CALL t550_b2_fill(g_wc3)
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION t550_b1()
DEFINE
   l_ac1_t         LIKE type_file.num5,
   l_n             LIKE type_file.num5,
   l_qty           LIKE type_file.num10,
   l_lock_sw       LIKE type_file.chr1,
   p_cmd           LIKE type_file.chr1,
   l_allow_insert  LIKE type_file.num5,
   l_allow_delete  LIKE type_file.num5,
   l_cnt           LIKE type_file.num5
 
   LET g_b_flag = '2'
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF g_rvc.rvc01 IS NULL OR g_rvc.rvcplant IS NULL 
      OR g_rvc.rvc00 IS NULL THEN RETURN END IF
      
   SELECT * INTO g_rvc.* FROM rvc_file
      WHERE rvc01=g_rvc.rvc01 
        AND rvc00 = g_rvc.rvc00
   IF g_rvc.rvcacti = 'N' THEN CALL cl_err('','mfg1000',0) RETURN END IF     
   IF g_rvc.rvcconf='Y' THEN CALL cl_err('','art-046',0) RETURN END IF
   IF g_rvc.rvcconf='X' THEN CALL cl_err('',9024,0) RETURN END IF
   
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = 
       "SELECT rvf02,rvf03,'',rvf04,rvf05,rvf06,'','','','',",
       "'','','','','','',rvf07,rvf08 ",
       "  FROM rvf_file ",
       " WHERE rvf01=? AND rvf00='",g_rvc.rvc00,"'",
       "   AND rvf02=? ",
       " FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t550_bc2 CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac1_t = 0
   LET l_allow_insert = FALSE
   LET l_allow_delete = FALSE
 
   INPUT ARRAY g_rvf WITHOUT DEFAULTS FROM s_rvf.*
         ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
           IF g_rec_b1 != 0 THEN
              CALL fgl_set_arr_curr(l_ac1)
              LET l_ac1 = 1
           END IF
 
       BEFORE ROW
           LET p_cmd=''
           LET l_ac1 = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
           BEGIN WORK
 
           OPEN t550_cl USING g_rvc.rvc00,g_rvc.rvc01
           IF STATUS THEN
              CALL cl_err("OPEN t550_cl:", STATUS, 1)
              CLOSE t550_cl
              ROLLBACK WORK
              RETURN
           END IF
           FETCH t550_cl INTO g_rvc.*
           IF SQLCA.SQLCODE THEN
              CALL cl_err(g_rvc.rvc01,SQLCA.SQLCODE,0)
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b1>=l_ac1 THEN
              LET g_rvf_t.* = g_rvf[l_ac1].*  #BACKUP
              LET p_cmd='u'
              OPEN t550_bc2 USING g_rvc.rvc01,g_rvf_t.rvf02
              IF STATUS THEN
                 CALL cl_err("OPEN t550_bc2:", STATUS, 1)
                 CLOSE t550_bc2
                 ROLLBACK WORK
                 RETURN
              END IF
              FETCH t550_bc2 INTO g_rvf[l_ac1].*
              IF SQLCA.SQLCODE THEN
                  CALL cl_err(g_rvf_t.rvf02,SQLCA.SQLCODE,1)
                  LET l_lock_sw = "Y"
              END IF
              CALL t550_b1_get_data()
              CALL cl_show_fld_cont()
              IF g_rvf[l_ac1].rvf07 = 'Y' THEN
                 CALL cl_set_comp_entry("rvf08",TRUE)
              ELSE
                 CALL cl_set_comp_entry("rvf08",FALSE)
              END IF     
           END IF
 
       BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_rvf[l_ac1].* TO NULL
           LET g_rvf_t.* = g_rvf[l_ac1].*
           LET g_rvf[l_ac1].rvf07='Y'
           LET g_rvf[l_ac1].rvf08=g_rvf[l_ac1].num_uncheck
           CALL cl_show_fld_cont()
           NEXT FIELD rvf07
 
       AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO rvf_file(rvf00,rvf01,rvf02,rvf03,rvf04,rvf05,rvf06,rvf07,rvf08,rvfplant,rvflegal)
              VALUES(g_rvc.rvc00,g_rvc.rvc01,g_rvf[l_ac1].rvf02,g_rvf[l_ac1].rvf03,
                     g_rvf[l_ac1].rvf04,g_rvf[l_ac1].rvf05,g_rvf[l_ac1].rvf06,           
                     g_rvf[l_ac1].rvf07,g_rvf[l_ac1].rvf08,g_rvc.rvcplant,g_rvc.rvclegal)
           IF SQLCA.SQLCODE THEN
              CALL cl_err3("ins","rvf_file",g_rvc.rvc01,g_rvc.rvcplant,SQLCA.SQLCODE,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b1=g_rec_b1+1   
           END IF
 
       AFTER FIELD rvf07
          IF NOT cl_null(g_rvf[l_ac1].rvf07) THEN
             IF g_rvf[l_ac1].rvf07 != g_rvf_t.rvf07
                OR g_rvf_t.rvf07 IS NULL THEN
                IF g_rvf[l_ac1].rvf07 = 'Y' THEN
                   LET g_rvf[l_ac1].rvf08 = g_rvf[l_ac1].num_uncheck
                   CALL cl_set_comp_entry("rvf08",TRUE)
                ELSE
                   LET g_rvf[l_ac1].rvf08 = 0
                   CALL cl_set_comp_entry("rvf08",FALSE)
                END IF
             END IF
          END IF
       ON CHANGE rvf07
          IF g_rvf[l_ac1].rvf07 = 'Y' THEN
             LET g_rvf[l_ac1].rvf08 = g_rvf[l_ac1].num_uncheck
             CALL cl_set_comp_entry("rvf08",TRUE)
          ELSE
             LET g_rvf[l_ac1].rvf08 = 0
             CALL cl_set_comp_entry("rvf08",FALSE)
          END IF
 
       AFTER FIELD rvf08
          IF g_rvf[l_ac1].rvf08 IS NOT NULL THEN
             IF g_rvf[l_ac1].rvf08 > g_rvf[l_ac1].num_uncheck THEN
                CALL cl_err('','art-505',0)
                NEXT FIELD rvf08
             END IF
          END IF
 
       ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rvf[l_ac1].* = g_rvf_t.*
              CLOSE t550_bc2
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rvf[l_ac1].rvf02,-263,1) 
              LET g_rvf[l_ac1].* = g_rvf_t.*
           ELSE
              UPDATE rvf_file SET rvf07 = g_rvf[l_ac1].rvf07,
                                  rvf08 = g_rvf[l_ac1].rvf08
                 WHERE rvf01=g_rvc.rvc01 
                   AND rvf00=g_rvc.rvc00
                   AND rvf02=g_rvf_t.rvf02
              IF SQLCA.SQLCODE THEN
                 CALL cl_err3("upd","rvf_file",g_rvc.rvc01,g_rvc.rvcplant,SQLCA.SQLCODE,"","",1)  #No.FUN-660104
                 LET g_rvf[l_ac1].* = g_rvf_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
       AFTER ROW
           LET l_ac1= ARR_CURR()
           LET l_ac1_t = l_ac1
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rvf[l_ac1].* = g_rvf_t.*
              END IF
              CLOSE t550_bc2
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE t550_bc2
           COMMIT WORK
       
       ON ACTION CONTROLO
          IF INFIELD(rvf02) AND l_ac1 > 1 THEN
             LET g_rvf[l_ac1].* = g_rvf[l_ac1-1].*
             NEXT FIELD rvf02
          END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
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
                                                                                                             
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
 
   END INPUT
 
   CLOSE t550_bc2
   COMMIT WORK
END FUNCTION
FUNCTION t550_b1_get_data()
DEFINE l_sum     LIKE ohb_file.ohb12
DEFINE l_dbs     LIKE azp_file.azp03
 
     #FUN-9C0075 ADD-------- 
    # SELECT azw03 INTO l_dbs FROM azw_file WHERE azw01 = g_rvf[l_ac1].rvf03
       LET g_plant_new =  g_rvf[g_cnt].rvf03
       CALL s_gettrandbs()
       LET l_dbs=g_dbs_tra
       LET l_dbs = s_dbstring(l_dbs CLIPPED)
     #FUN-9C0075 end------
      LET g_sql = "SELECT rvv31,rvv031,rvv35,rvv38,rvv38t,rvv17,rvv39,rvv39t ",
                  #" FROM ",l_dbs,"rvv_file ", #FUN-A50102
                  " FROM ",cl_get_target_table(g_rvf[g_cnt].rvf03, 'rvv_file'), #FUN-A50102
                  "  WHERE rvv01 = '",g_rvf[l_ac1].rvf05,"'", 
                  "    AND rvv02 = '",g_rvf[l_ac1].rvf06,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
      CALL cl_parse_qry_sql(g_sql, g_rvf[g_cnt].rvf03) RETURNING g_sql    #FUN-A50102          
      PREPARE pre_sel_rvv FROM g_sql
      EXECUTE pre_sel_rvv INTO g_rvf[l_ac1].rvv31,g_rvf[l_ac1].rvv031,
                               g_rvf[l_ac1].rvv35,g_rvf[l_ac1].rvv38,
                               g_rvf[l_ac1].rvv38t,g_rvf[l_ac1].rvv17,
                               g_rvf[l_ac1].rvv39,g_rvf[l_ac1].rvv39t
          
      SELECT azp02 INTO g_rvf[l_ac1].rvf03_desc 
 #        FROM azw_file WHERE azw01 = g_rvf[l_ac1].rvf03          #TQC-AB0370  mark
          FROM azp_file WHERE azp01 = g_rvf[l_ac1].rvf03          #TQC-AB0370
         
      SELECT gfe02 INTO g_rvf[l_ac1].rvv35_desc FROM gfe_file 
         WHERE gfe01 = g_rvf[l_ac1].rvv35
 
      SELECT SUM(rvf08) INTO l_sum FROM rvf_file,rvc_file 
               WHERE rvc00 = rvf00
                 AND rvc01 = rvf01
                 AND rvcconf = 'Y'
                 AND rvf00 = g_rvc.rvc00 
                 AND rvf05 = g_rvf[l_ac1].rvf05 
                 AND rvf06 = g_rvf[l_ac1].rvf06
 
      IF l_sum IS NULL THEN LET l_sum = 0 END IF
      LET g_rvf[l_ac1].num_uncheck = g_rvf[l_ac1].rvv17 - l_sum 
END FUNCTION
FUNCTION t550_b2()
DEFINE
   l_ac2_t          LIKE type_file.num5,
   l_n             LIKE type_file.num5,
   l_qty           LIKE type_file.num10,
   l_lock_sw       LIKE type_file.chr1,
   p_cmd           LIKE type_file.chr1,
   l_allow_insert  LIKE type_file.num5,
   l_allow_delete  LIKE type_file.num5,
   l_cnt           LIKE type_file.num5
 
   LET g_b_flag = '3'
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF g_rvc.rvc01 IS NULL OR g_rvc.rvcplant IS NULL THEN RETURN END IF
   SELECT * INTO g_rvc.* FROM rvc_file
      WHERE rvc01=g_rvc.rvc01 
        AND rvcplant=g_rvc.rvcplant
        AND rvc00 = g_rvc.rvc00
        
   IF g_rvc.rvcconf='Y' THEN CALL cl_err('','art-046',0) RETURN END IF
   IF g_rvc.rvcconf='X' THEN CALL cl_err('',9024,0) RETURN END IF
   
   CALL cl_opmsg('b')
 
#  LET g_forupd_sql = "SELECT rve02,rve03,'',rve04,rve05,",  #TQC-AC0136 MARK
#  LET g_forupd_sql = "SELECT rve02,rve03,'',rve04,'','',rve05,", #TQC-AC0136 ADD
   LET g_forupd_sql = "SELECT rve02,rve03,'',rve04,rve05,'','',", #FUN-BC0124 add
                  #    "'','','','','',rve06 ",    #FUN-A80105
                      "'','','','',rve06 ",        #FUN-A80105                
                      "  FROM rve_file ",
                      " WHERE rve01=? AND rve00='",g_rvc.rvc00,"'",
                     #"   AND rve02=? AND rve930='",g_rvc.rvcplant,"'",    #FUN-9C0075 mark
                      "   AND rve02=? AND rveplant='",g_rvc.rvcplant,"'",  #FUN-9C0075 add
                      "   FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t550_bc3 CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac2_t = 0
   LET l_allow_insert = FALSE
   LET l_allow_delete = FALSE
 
   INPUT ARRAY g_rve WITHOUT DEFAULTS FROM s_rve.*
         ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
           IF g_rec_b2 != 0 THEN
              CALL fgl_set_arr_curr(l_ac2)
           END IF
 
       BEFORE ROW
           LET p_cmd=''
           LET l_ac2 = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN t550_cl USING g_rvc.rvc00,g_rvc.rvc01
           IF STATUS THEN
              CALL cl_err("OPEN t550_cl:", STATUS, 1)
              CLOSE t550_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t550_cl INTO g_rvc.*
           IF SQLCA.SQLCODE THEN
              CALL cl_err(g_rvc.rvc01,SQLCA.SQLCODE,0)
              CLOSE t550_cl
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b2>=l_ac2 THEN
              LET p_cmd='u'
              LET g_rve_t.* = g_rve[l_ac2].*   #BACKUP
              LET l_lock_sw = 'N'              #DEFAULT
              OPEN t550_bc3 USING g_rvc.rvc01,g_rve_t.rve02
              IF STATUS THEN
                 CALL cl_err("OPEN t550_bc3:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t550_bc3 INTO g_rve[l_ac2].*
                 IF SQLCA.SQLCODE THEN
                    CALL cl_err(g_rve_t.rve02,SQLCA.SQLCODE , 1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL t550_b2_get_data()
              END IF
              CALL cl_show_fld_cont()
           END IF
 
       BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_rve[l_ac2].* TO NULL
           LET g_rve_t.* = g_rve[l_ac2].*
           LET g_rve[l_ac2].rve06 = 'Y'
           CALL cl_show_fld_cont()
           NEXT FIELD rve06
 
       AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO rve_file(rve00,rve01,rve02,rve03,rve04,rve05,rve06,rveplant,rvelegal)
                         VALUES(g_rvc.rvc00,g_rvc.rvc01,g_rve[l_ac2].rve02,
                         g_rve[l_ac2].rve03,g_rve[l_ac2].rve04,g_rve[l_ac2].rve05,
                         g_rve[l_ac2].rve06,g_rvc.rvcplant,g_rvc.rvclegal)                               
           IF SQLCA.SQLCODE THEN
              CALL cl_err3("ins","rve_file",g_rvc.rvc01,g_rvc.rvcplant,SQLCA.SQLCODE,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b2=g_rec_b2+1   
           END IF
 
       ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rve[l_ac2].* = g_rve_t.*
              CLOSE t550_bc3
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rve[l_ac2].rve03,-263,1)
              LET g_rve[l_ac2].* = g_rve_t.*
           ELSE
              UPDATE rve_file SET rve03 = g_rve[l_ac2].rve06
               WHERE rve01=g_rvc.rvc01 
                 AND rve00=g_rvc.rvc00
                 AND rve02=g_rve_t.rve02
              IF SQLCA.SQLCODE THEN
                 CALL cl_err3("upd","rve_file",g_rve_t.rve02,'',SQLCA.SQLCODE,"","",1)  
                 LET g_rve[l_ac2].* = g_rve_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
       AFTER ROW
           LET l_ac2 = ARR_CURR()
           LET l_ac2_t = l_ac2
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rve[l_ac2].* = g_rve_t.*
              END IF
              CLOSE t550_bc3
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE t550_bc3
           COMMIT WORK
 
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
 
       ON ACTION HELP
          CALL cl_show_help()
                                                                                                             
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")     
                                                                                 
   END INPUT
   
   IF p_cmd = 'u' THEN
      LET g_rvc.rvcmodu = g_user
      LET g_rvc.rvcdate = g_today
      UPDATE rvc_file SET rvcmodu = g_rvc.rvcmodu,
                          rvcdate = g_rvc.rvcdate
         WHERE rvc01 = g_rvc.rvc01 
           AND rvc00 = g_rvc.rvc00
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("upd","rvc_file",g_rvc.rvc01,g_rvc.rvcplant,SQLCA.SQLCODE,"","upd rvc",1)  #No.FUN-660104
      END IF
      DISPLAY BY NAME g_rvc.rvcmodu,g_rvc.rvcdate
   END IF
   CLOSE t550_bc3
   COMMIT WORK
END FUNCTION
FUNCTION t550_b2_get_data()
#TQC-AB0370 -----------------STA
   #LET g_sql = " SELECT lub03,oaj02,lub04,lub04t ",
   #LET g_sql = " SELECT lub03,oaj02,lub04,lub04t,lua02,lua24 ",  #TQC-AC0138 add lua02,lua24
   LET g_sql = " SELECT lub03,oaj02,lub04,lub04t,lub09,lub14 ",   #FUN-BC0124 lua02 --> lub09 lua24-->lub14 
               " FROM ",cl_get_target_table(g_rve[l_ac2].rve03, 'lua_file'),   #TQC-AC0138 add
               "     ,",cl_get_target_table(g_rve[l_ac2].rve03, 'lub_file'),  
               " LEFT OUTER JOIN ",cl_get_target_table(g_rve[l_ac2].rve03, 'oaj_file'),
               " ON lub03 = oaj01 ",
               " WHERE lub01 = '",g_rve[l_ac2].rve04,"'",
               "   AND lub02 = '",g_rve[l_ac2].rve05,"'",
               "   AND lua01 = lub01"       #TQC-AC0138 add
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql 
   CALL cl_parse_qry_sql(g_sql, g_rve[l_ac2].rve03) RETURNING g_sql
   PREPARE pre_sel_lub FROM g_sql
   EXECUTE pre_sel_lub INTO g_rve[l_ac2].lub03,g_rve[l_ac2].oaj02,g_rve[l_ac2].lub04,g_rve[l_ac2].lub04t,
                           #g_rve[g_cnt].lua02,g_rve[g_cnt].lua24  #TQC-AC0138 add
                            g_rve[l_ac2].lub09,g_rve[l_ac2].lub14  #FUN-BC0124 lua02 --> lub09 lua24-->lub14

   SELECT azp02 INTO g_rve[l_ac2].rve03_desc
    FROM azp_file WHERE azp01 = g_rve[l_ac2].rve03
   #SELECT lua02,lua24 INTO g_rve[l_ac2].lua02,g_rve[l_ac2].lua24  #TQC-AC0136 ADD   #TQC-AC0138 mark
   #  FROM lua_file WHERE lua01 = g_rve[l_ac2].rve04               #TQC-AC0136 ADD   #TQC-AC0138 mark
        
#TQC-AB0370 -----------------END
END FUNCTION
 
FUNCTION t550_b2_fill(p_wc)
DEFINE l_sql,p_wc        STRING
 
 #  LET l_sql = "SELECT rve02,rve03,'',rve04,rve05,'','', ",       #TQC-AC0136 MARK
  #LET l_sql = "SELECT rve02,rve03,'',rve04,'','',rve05,'','', ",  #TQC-AC0136 ADD #FUN-BC0124 mark
   LET l_sql = "SELECT rve02,rve03,'',rve04,rve05,'','','','', ",        #FUN-BC0124 ADD
            #   " '','','',rve06 FROM rve_file ",      #FUN-A80105
               " '','',rve06 FROM rve_file ",          #FUN-A80105                  
               "WHERE rve01 = '",g_rvc.rvc01,"' AND rve00 ='",g_rvc.rvc00,"'"
               
   IF NOT cl_null(p_wc) THEN
      LET l_sql = l_sql," AND ",p_wc," ORDER BY rve02"
   ELSE
      LET l_sql = l_sql," ORDER BY rve02"
   END IF
   DECLARE t550_cr3 CURSOR FROM l_sql
 
   CALL g_rve.clear()
   LET g_rec_b2 = 0
 
   LET g_cnt = 1
   FOREACH t550_cr3 INTO g_rve[g_cnt].*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF
      #TQC-AC0138 mark -begin-------------------------
      #SELECT lub03,lub04,lub04t 
      #    INTO g_rve[g_cnt].lub03,g_rve[g_cnt].lub04,
      #         g_rve[g_cnt].lub04t 
      #    FROM lub_file
      #   WHERE lub01 = g_rve[g_cnt].rve04
      #     AND lub02 = g_rve[g_cnt].rve05
      #SELECT lua02,lua24 INTO g_rve[g_cnt].lua02,g_rve[g_cnt].lua24 #TQC-AC0136 ADD
      #  FROM lua_file                                               #TQC-AC0136 ADD
      # WHERE lua01 = g_rve[g_cnt].rve04                             #TQC-AC0136 ADD
           
#      SELECT oaj02,oaj06                                #FUN-A80105
      #SELECT oaj02                                       #FUN-A80105
#        INTO g_rve[g_cnt].oaj02,g_rve[g_cnt].oaj06      #FUN-A80105
      #  INTO g_rve[g_cnt].oaj02                          #FUN-A80105
      #  FROM oaj_file 
      #  WHERE oaj01 = g_rve[g_cnt].lub03
      #TQC-AC0138 mark --end---------------------------
      #TQC-AC0138 add --begin--------------------------
      #LET l_sql = "SELECT lua02,lua24,lub03,lub04,lub04t ",
      LET l_sql = "SELECT lub09,lub14,lub03,lub04,lub04t ",    #FUN-BC0124 lua02 --> lub09 lua24-->lub14
                  "  FROM ",cl_get_target_table(g_rve[g_cnt].rve03, 'lua_file'),
                  "      ,",cl_get_target_table(g_rve[g_cnt].rve03, 'lub_file'),
                  " WHERE lua01 = '",g_rve[g_cnt].rve04,"'",
                  "   AND lua01 = lub01 AND lub02 = '",g_rve[g_cnt].rve05,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, g_rve[g_cnt].rve03) RETURNING l_sql
      PREPARE pre_sel_lua FROM l_sql
      #EXECUTE pre_sel_lua INTO g_rve[g_cnt].lua02,g_rve[g_cnt].lua24,
      EXECUTE pre_sel_lua INTO g_rve[g_cnt].lub09,g_rve[g_cnt].lub14,   #FUN-BC0124 lua02 --> lub09 lua24-->lub14
                               g_rve[g_cnt].lub03,g_rve[g_cnt].lub04,
                               g_rve[g_cnt].lub04t
      
      LET l_sql = "SELECT oaj02 FROM ",cl_get_target_table(g_rve[g_cnt].rve03, 'oaj_file'),
                  " WHERE oaj01 = '",g_rve[g_cnt].lub03,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, g_rve[g_cnt].rve03) RETURNING l_sql
      PREPARE pre_sel_oaj FROM l_sql
      EXECUTE pre_sel_oaj INTO g_rve[g_cnt].oaj02
      #TQC-AC0138 add ---end---------------------------
      SELECT azp02 INTO g_rve[g_cnt].rve03_desc
         FROM azp_file WHERE azp01 = g_rve[g_cnt].rve03  
         
      LET g_cnt=g_cnt+1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_rve.deleteElement(g_cnt)
   LET g_rec_b2 = g_cnt - 1
   LET g_cnt = 1
 
   CLOSE t550_cr3
   CALL t550_bp2_refresh()
END FUNCTION
 
FUNCTION t550_bp2_refresh()
  DISPLAY ARRAY g_rve TO s_rve.* ATTRIBUTE(COUNT = g_rec_b2,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
END FUNCTION
 
FUNCTION t550_b1_fill(p_wc)
DEFINE l_sql      STRING
DEFINE p_wc       STRING
DEFINE l_sum     LIKE ohb_file.ohb12
DEFINE l_dbs     LIKE azp_file.azp03
 
   LET l_sql = "SELECT rvf02,rvf03,'',rvf04,rvf05,rvf06,",
               "'','','','','', '','','','','',rvf07,rvf08 ",
               " FROM rvf_file ",
               "WHERE rvf01 = '",g_rvc.rvc01,"' AND rvf00 ='",g_rvc.rvc00,"'"
               
   IF NOT cl_null(p_wc) THEN
      LET l_sql = l_sql," AND ",p_wc," ORDER BY rvf02"
   ELSE
   	  LET l_sql = l_sql," ORDER BY rvf02"
   END IF
   DECLARE t550_cr2 CURSOR FROM l_sql
 
   CALL g_rvf.clear()
   LET g_rec_b1 = 0
   LET g_cnt = 1
   FOREACH t550_cr2 INTO g_rvf[g_cnt].*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF
     #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = g_rvf[g_cnt].rvf03
       LET g_plant_new =  g_rvf[g_cnt].rvf03
       CALL s_gettrandbs()
       LET l_dbs=g_dbs_tra
       LET l_dbs = s_dbstring(l_dbs CLIPPED)
 
      LET g_sql = "SELECT rvv31,rvv031,rvv35,rvv38,rvv38t,rvv17,rvv39,rvv39t ",
                  #" FROM ",l_dbs,"rvv_file ", #FUN-A50102
                  " FROM ",cl_get_target_table(g_rvf[g_cnt].rvf03, 'rvv_file'), #FUN-A50102
                  " WHERE rvv01 = '",g_rvf[g_cnt].rvf05,"'", 
                  "   AND rvv02 = '",g_rvf[g_cnt].rvf06,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
      CALL cl_parse_qry_sql(g_sql, g_rvf[g_cnt].rvf03) RETURNING g_sql  #FUN-A50102            
      PREPARE pre_get_rvf FROM g_sql
      EXECUTE pre_get_rvf INTO g_rvf[g_cnt].rvv31,g_rvf[g_cnt].rvv031,
                               g_rvf[g_cnt].rvv35,g_rvf[g_cnt].rvv38,
                               g_rvf[g_cnt].rvv38t,g_rvf[g_cnt].rvv17,
                               g_rvf[g_cnt].rvv39,g_rvf[g_cnt].rvv39t
      
      SELECT SUM(rvf08) INTO l_sum FROM rvf_file,rvc_file 
               WHERE rvc00 = rvf00
                 AND rvc01 = rvf01
                 AND rvcconf = 'Y'
                 AND rvf00 = g_rvc.rvc00 
                 AND rvf05 = g_rvf[g_cnt].rvf05 
                 AND rvf06 = g_rvf[g_cnt].rvf06
 
      IF l_sum IS NULL THEN LET l_sum = 0 END IF
      LET g_rvf[g_cnt].num_uncheck = g_rvf[g_cnt].rvv17 - l_sum 
 
      SELECT azp02 INTO g_rvf[g_cnt].rvf03_desc 
         FROM azp_file WHERE azp01 = g_rvf[g_cnt].rvf03
         
      SELECT gfe02 INTO g_rvf[g_cnt].rvv35_desc FROM gfe_file 
         WHERE gfe01 = g_rvf[g_cnt].rvv35
         
      LET g_cnt=g_cnt+1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_rvf.deleteElement(g_cnt)
   LET g_rec_b1 = g_cnt - 1
   LET g_cnt = 1
   CLOSE t550_cr2
   CALL t550_bp1_refresh()
END FUNCTION
 
FUNCTION t550_bp1_refresh()
  DISPLAY ARRAY g_rvf TO s_rvf.* ATTRIBUTE(COUNT = g_rec_b1,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
END FUNCTION
 
FUNCTION t550_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rve TO s_rve.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac2 = ARR_CURR()  
 
      ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")                                                                                          
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
 
      #ON ACTION reproduce
      #   LET g_action_choice="reproduce"
      #   EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac2 = 1
         EXIT DISPLAY
 
      ON ACTION invalid                        
         LET g_action_choice="invalid"        
         EXIT DISPLAY
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'  
         EXIT DISPLAY
 
     #ON ACTION output                                                                                                              
     #   LET g_action_choice="output"                                                                                               
     #   EXIT DISPLAY
 
      ON ACTION first
         CALL t550_fetch('F')
         EXIT DISPLAY
 
      ON ACTION previous
         CALL t550_fetch('P')
         EXIT DISPLAY
 
      ON ACTION jump
         CALL t550_fetch('/')
         EXIT DISPLAY
 
      ON ACTION next
         CALL t550_fetch('N')
         EXIT DISPLAY
 
      ON ACTION last
         CALL t550_fetch('L')
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CALL cl_set_field_pic(g_rvc.rvcconf,"","","","","")
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
 
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #FUN-D20039 -----------sta
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20039 -----------end
      ON ACTION curr_plant
         LET g_action_choice = "curr_plant"
         EXIT DISPLAY
 
      ON ACTION in_store
         LET g_b_flag = '2'
         LET g_action_choice = "in_store"
         EXIT DISPLAY
 
      ON ACTION feiyong
         LET g_b_flag = '3'
         LET g_action_choice = "feiyong"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
    
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac2 = ARR_CURR()
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      
      ON ACTION about
         CALL cl_about()
      
      ON ACTION HELP
         CALL cl_show_help()
      
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION related_document
         LET g_action_choice="related_document"          
         EXIT DISPLAY
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION t550_bp1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rvf TO s_rvf.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac1 = ARR_CURR()
 
      ON ACTION CONTROLS 
         CALL cl_set_head_visible("","AUTO")     
 
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
 
      #ON ACTION reproduce
      #   LET g_action_choice="reproduce"
      #   EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac1 = 1
         EXIT DISPLAY
   
      ON ACTION invalid 
         LET g_action_choice="invalid"   
         EXIT DISPLAY                   
                                                                                                                                    
      ON ACTION exporttoexcel          
         LET g_action_choice = 'exporttoexcel' 
         EXIT DISPLAY
 
     #ON ACTION output                        
     #   LET g_action_choice="output"        
     #   EXIT DISPLAY
 
      ON ACTION first
         CALL t550_fetch('F')
         EXIT DISPLAY
 
      ON ACTION previous
         CALL t550_fetch('P')
         EXIT DISPLAY
 
      ON ACTION jump
         CALL t550_fetch('/')
         EXIT DISPLAY
 
      ON ACTION next
         CALL t550_fetch('N')
         EXIT DISPLAY
 
      ON ACTION last
         CALL t550_fetch('L')
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CALL cl_set_field_pic(g_rvc.rvcconf,"","","","","")
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
         
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
 
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #FUN-D20039 ----------sta
       ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20039 ----------end
 
      ON ACTION curr_plant
         LET g_action_choice = "curr_plant"
         EXIT DISPLAY
 
      ON ACTION in_store
         LET g_b_flag = '2'
         LET g_action_choice = "in_store"
         EXIT DISPLAY
 
      ON ACTION feiyong
         LET g_b_flag = '3'
         LET g_action_choice = "feiyong"
         EXIT DISPLAY
   
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac1 = ARR_CURR()
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      
      ON ACTION about
         CALL cl_about()
      
      ON ACTION HELP
         CALL cl_show_help()
      
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION related_document
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION t550_r()
   DEFINE l_cnt    LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
   IF g_rvc.rvc01 IS NULL OR g_rvc.rvcplant IS NULL THEN 
      CALL cl_err('',-400,2) 
      RETURN 
   END IF
   SELECT * INTO g_rvc.* FROM rvc_file WHERE rvc00 = g_rvc.rvc00 AND rvc01 = g_rvc.rvc01
   IF g_rvc.rvcconf='Y' THEN CALL cl_err('','9023',0) RETURN END IF
   IF g_rvc.rvcconf='X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF g_rvc.rvcacti='N' THEN CALL cl_err('','aic-201',0) RETURN END IF
 
   LET g_success = 'Y'
   BEGIN WORK
   OPEN t550_cl USING g_rvc.rvc00,g_rvc.rvc01
   FETCH t550_cl INTO g_rvc.*
   IF SQLCA.SQLCODE THEN
      CALL cl_err(g_rvc.rvc01,SQLCA.SQLCODE,0)
      CLOSE t550_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   LET g_rvc_t.* = g_rvc.*
   CALL t550_show()
   IF cl_delete() THEN
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "rvc01"         #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "rvc02"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_rvc.rvc01      #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_rvc.rvc02      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                        #No.FUN-9B0098 10/02/24
      DELETE FROM rvc_file 
         WHERE rvc01=g_rvc.rvc01
           AND rvc00 = g_rvc.rvc00
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","rvg_file",g_rvc.rvc01,g_rvc.rvcplant,SQLCA.SQLCODE,"","(t550_r:delete rvg)",1)
         LET g_success='N'
      END IF
      
      DELETE FROM rvf_file 
         WHERE rvf01 = g_rvc.rvc01 
           AND rvf00 = g_rvc.rvc00
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","rvf_file",g_rvc.rvc01,g_rvc.rvcplant,SQLCA.SQLCODE,"","(t550_r:delete rvf)",1)  #No.FUN-660104
         LET g_success='N'
      END IF
      DELETE FROM rve_file WHERE rve00 = g_rvc.rvc00 AND rve01 = g_rvc.rvc01
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","rve_file",g_rvc.rvc01,g_rvc.rvcplant,SQLCA.SQLCODE,"","(t550_r:delete rvf)",1)  #No.FUN-660104
         LET g_success='N'
      END IF
      DELETE FROM rvd_file WHERE rvd00 = g_rvc.rvc00 AND rvd01 = g_rvc.rvc01
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","rvd_file",g_rvc.rvc01,g_rvc.rvcplant,SQLCA.SQLCODE,"","(t550_r:delete rvf)",1)  #No.FUN-660104
         LET g_success='N'
      END IF
 
      INITIALIZE g_rvc.* TO NULL
      IF g_success = 'Y' THEN
         COMMIT WORK
         CLEAR FORM             #TQC-C50164 add
         LET g_rvc_t.* = g_rvc.*
         CALL g_rvf.clear()
         CALL g_rve.clear()
         OPEN t550_count
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE t550_cs
            CLOSE t550_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         FETCH t550_count INTO g_row_count
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t550_cs
            CLOSE t550_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t550_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t550_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t550_fetch('/')
         END IF
      ELSE
         ROLLBACK WORK
         LET g_rvc.* = g_rvc_t.*
      END IF
   END IF
   CALL t550_show()
END FUNCTION
 
FUNCTION t550_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("rvc01,rvc03,rvc04,rvc05",TRUE)
   END IF
END FUNCTION
 
FUNCTION t550_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("rvc01,rvc03,rvc04,rvc05",FALSE)
   END IF
END FUNCTION

