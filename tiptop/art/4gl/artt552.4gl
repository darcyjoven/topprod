# Prog. Version..: '5.30.06-13.04.22(00010)'     #
# 
# Pattern name...: artt552.4gl
# Descriptions...: 聯營對帳單
# Date & Author..: No:FUN-960130 08/10/28 BY Sunyanchun
# Modify.........: No:FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9B0025 09/12/07 By cockroach 修改rvd03的判斷
# Modify.........: No:FUN-9C0075 09/12/16 By cockroach 无单身资料带出时取消插入rvd_file的数据
# Modify.........: No:TQC-A10128 10/01/18 By Cockroach 添加g_data_plant管控 
# Modify.........: No:FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:TQC-A30030 10/03/12 By Cockroach BUG處理
# Modify.........: No:TQC-A30041 10/03/16 By Cockroach ADD oriu/orig
# Modify.........: No:FUN-A50102 10/06/12 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-A70130 10/08/06 By shaoyong  ART單據性質調整,q_smy改为q_oay
# Modify.........: No:FUN-A80105 10/08/24 By lixh1  MARK 掉 oaj06 程式碼
# Modify.........: No:TQC-AC0136 10/12/17 By baogc 在費用對賬頁簽添加欄位費用類型和財務單號和單身異常
# Modify.........: No:TQC-AC0417 11/01/06 By huangtao 費用對賬是根據費用單的費用日期抓取資料
# Modify.........: No:TQC-B10045 11/01/07 By shiwuying 审核判断费用对账
# Modify.........: No:FUN-B40031 11/04/18 By shiwuying 联营对账逻辑调整
# Modify.........: No:FUN-B40098 11/05/19 By shiwuying Bug
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:TQC-B60065 11/06/15 By shiwuying 新增入庫單虛擬類型=4
# Modify.........: No:FUN-B60099 11/06/20 By shiwuying 金額計算錯誤，根據對賬數量來算
# Modify.........: No:TQC-B60250 11/06/20 By shiwuying 銷售對賬時計算未對賬數量排除作廢的單據
# Modify.........: No.FUN-B80085 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外
# Modify.........: No:TQC-BB0125 11/11/29 by pauline 控卡user,group
# Modify.........: No:FUN-BB0072 11/11/15 By baogc 產生虛擬單據時，經營方式為'1:經銷'
# Modify.........: No:FUN-BC0124 11/12/28 By suncx 由於費用單結構調整，調整抓取費用單對應欄位,調整的欄位費用類型、財務單號
# Modify.........: No:FUN-BB0086 12/01/14 By tanxc 增加數量欄位小數取位  
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:TQC-C50164 12/05/21 by fanbj 刪除後單頭資料沒有清空
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.TQC-C80151 12/08/24 By yangxf 對賬營運中心控管與開窗不符
# Modify.........: No:FUN-C90050 12/10/25 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得
# Modify.........: No:FUN-D20039 13/01/20 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」
# Modify.........: No:FUN-D30033 13/04/12 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_rvg         DYNAMIC ARRAY OF RECORD
                         rvg02          LIKE rvg_file.rvg02,
                         rvg03          LIKE rvg_file.rvg03,
			 rvg03_desc     LIKE azp_file.azp02,
                         rvg04          LIKE rvg_file.rvg04,
                         rvg05          LIKE rvg_file.rvg05,
                         rvg06          LIKE rvg_file.rvg06,
                         ogb04_ohb04    LIKE ogb_file.ogb04,
                         ogb06_ohb06    LIKE ogb_file.ogb06,
                         ogb05_ohb05    LIKE ogb_file.ogb05,
                         ogb05_desc     LIKE gfe_file.gfe02,
                         ogb13_ohb13    LIKE ogb_file.ogb13,
                         ogb12_ohb12    LIKE ogb_file.ogb12,
                         ogb14_ohb14    LIKE ogb_file.ogb14,
                         ogb14t_ohb14t  LIKE ogb_file.ogb14t,
                         num_uncheck1   LIKE ogb_file.ogb12,
                         rvg07          LIKE rvg_file.rvg07,
                         rvg08          LIKE rvg_file.rvg08
                       END RECORD
DEFINE   g_rvg_t       RECORD
                         rvg02          LIKE rvg_file.rvg02,
                         rvg03          LIKE rvg_file.rvg03,
                         rvg03_desc     LIKE azp_file.azp02,
                         rvg04          LIKE rvg_file.rvg04,
                         rvg05          LIKE rvg_file.rvg05,
                         rvg06          LIKE rvg_file.rvg06,
                         ogb04_ohb04    LIKE ogb_file.ogb04,
                         ogb06_ohb06    LIKE ogb_file.ogb06,
                         ogb05_ohb05    LIKE ogb_file.ogb05,
                         ogb05_desc     LIKE gfe_file.gfe02,
                         ogb13_ohb13    LIKE ogb_file.ogb13,
                         ogb12_ohb12    LIKE ogb_file.ogb12,
                         ogb14_ohb14    LIKE ogb_file.ogb14,
                         ogb14t_ohb14t  LIKE ogb_file.ogb14t,
                         num_uncheck1   LIKE ogb_file.ogb12,
                         rvg07          LIKE rvg_file.rvg07,
                         rvg08          LIKE rvg_file.rvg08
                        END RECORD
 
DEFINE   g_rve        DYNAMIC ARRAY OF RECORD
                         rve02        LIKE rve_file.rve02,
                         rve03        LIKE rve_file.rve03,
                         rve03_desc   LIKE azp_file.azp02,
                         rve04        LIKE rve_file.rve04,
#                         lua02        LIKE lua_file.lua02,    #TQC-AC0136 ADD #FUN-BC0124 mark
#                         lua24        LIKE lua_file.lua24,    #TQC-AC0136 ADD #FUN-BC0124 mark
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
#                         lua02        LIKE lua_file.lua02,    #TQC-AC0136 ADD #FUN-BC0124 mark
#                         lua24        LIKE lua_file.lua24,    #TQC-AC0136 ADD #FUN-BC0124 mark
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
         g_rec_b        LIKE type_file.num5,
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
DEFINE   l_ac           LIKE type_file.num5
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
 
 
   LET g_forupd_sql= " SELECT * FROM rvc_file WHERE rvc00 = ? AND rvc01 = ? AND rvcplant = ? FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t552_cl CURSOR FROM g_forupd_sql
 
   LET g_b_flag = '1'
 
   LET p_row = 2  LET p_col = 9 
   OPEN WINDOW t552_w AT p_row,p_col WITH FORM "art/42f/artt552"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   IF (NOT cl_null(g_argv1)) AND (NOT cl_null(g_argv2)) THEN
      CALL t552_q()
   END IF   
 
   DISPLAY '4' TO rvc02
 
   CALL t552_menu()
   CLOSE WINDOW t552_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t552_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01
DEFINE  l_table         LIKE    type_file.chr1000
DEFINE  l_where         LIKE    type_file.chr1000
 
   IF (NOT cl_null(g_argv1)) AND (NOT cl_null(g_argv2)) THEN
      LET g_wc = " rvc01 = '",g_argv1,"'",
                 " AND rvcplant = '",g_argv2,"'"
      LET g_wc2=" 1=1 "
   ELSE
      CLEAR FORM
      LET g_action_choice=" " 
      CALL cl_set_head_visible("","YES")
      INITIALIZE g_rvc.* TO NULL
      DISPLAY '4' TO rvc02
      CONSTRUCT BY NAME g_wc ON
                rvc01,rvc03,rvc04,rvc05,rvc06,
                rvcconf,rvccond,rvcconu,rvcplant,
                rvcuser,rvcgrup,rvcmodu,
                rvcdate,rvcacti,rvccrat
               ,rvcoriu,rvcorig            #TQC-A30041 ADD
      
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
      
         ON ACTION controlp
            CASE WHEN INFIELD(rvc01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_rvc01_2"
                    LET g_qryparam.default1 = g_rvc.rvc01
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rvc01
                    NEXT FIELD rvc01
                    
                 WHEN INFIELD(rvc03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_rvc03_2"
                    LET g_qryparam.default1 = g_rvc.rvc03
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rvc03
                    NEXT FIELD rvc03
                      
                 WHEN INFIELD(rvcconu)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form = "q_rvcconu_2"
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
      
      CONSTRUCT g_wc1 ON rvg02,rvg03,rvg04,rvg05,rvg06,rvg07,rvg08
                    FROM s_rvg[1].rvg02,s_rvg[1].rvg03,s_rvg[1].rvg04,
                         s_rvg[1].rvg05,s_rvg[1].rvg06,s_rvg[1].rvg07,
                         s_rvg[1].rvg08
                         
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
      
         ON ACTION controlp
            CASE WHEN INFIELD(rvg03)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.form     = "q_rvg03_2"
                      LET g_qryparam.default1 = g_rvg[1].rvg03
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO rvg03
                      NEXT FIELD rvg03
                      
                 WHEN INFIELD(rvg05)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.form     = "q_rvg05_2"
                      LET g_qryparam.default1 = g_rvg[1].rvg05
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO rvg05
                      NEXT FIELD rvg05
                      
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
                      LET g_qryparam.form     = "q_rve03_2"
                      LET g_qryparam.default1 = g_rve[1].rve03
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO rve03
                      NEXT FIELD rve03
                      
                 WHEN INFIELD(rve04)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.form     = "q_rve04_2"
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
 
   LET g_sql = "SELECT UNIQUE rvc00,rvc01,rvcplant " 
   LET l_table = " FROM rvc_file "
   LET l_where = " WHERE ",g_wc 
   IF g_wc1 <> " 1=1" THEN
      LET l_table = l_table,",rvg_file" 
      LET l_where = l_where," AND rvg00 = rvc00 AND rvg01 = rvc01 AND rvgplant = rvcplant AND ",g_wc1
   END IF
   IF g_wc3 <> " 1=1" THEN 
      LET l_table = l_table,",rve_file" 
      LET l_where = l_where," AND rve00 = rvc00 AND rve01 = rvc01 AND rveplant = rvcplant AND ",g_wc3
   END IF
  #LET l_where = l_where," AND rvc00 ='3' AND rvc02 = '4' " #FUN-B40031
   LET l_where = l_where," AND rvc00 ='4' AND rvc02 = '4' " #FUN-B40031
   LET g_sql = g_sql,l_table,l_where
   PREPARE t552_prepare FROM g_sql
   DECLARE t552_cs SCROLL CURSOR WITH HOLD FOR t552_prepare
 
   LET g_sql = "SELECT COUNT(DISTINCT rvc00||rvc01||rvcplant) ",l_table,l_where
   PREPARE t552_precount FROM g_sql
   DECLARE t552_count CURSOR FOR t552_precount
END FUNCTION
FUNCTION t552_menu()
 
   WHILE TRUE
      IF g_action_choice = "exit"  THEN
         EXIT WHILE
      END IF
 
      CASE g_b_flag
         WHEN '1'
            CALL t552_bp("G")
            CALL t552_b_fill(g_wc1)
         WHEN '3'
            CALL t552_bp2("G")
            CALL t552_b2_fill(g_wc3)
      END CASE
 
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t552_a()
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
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
                  IF g_b_flag = 1 THEN
                     CALL t552_b()
                  END IF
                  IF g_b_flag = 3 THEN
                     CALL t552_b2()
                  END IF
            END IF
 
         WHEN "invalid"                                                                                                             
            IF cl_chk_act_auth() THEN           
                  CALL t552_x()  
            END IF
 
         WHEN "exporttoexcel"                                                                                                       
            IF cl_chk_act_auth() THEN                                                                                               
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rvc),'','')                                 
            END IF
 
         WHEN "output"                                                                                                              
            IF cl_chk_act_auth() THEN                                                                                               
               CALL t552_out()                                                                                                      
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "confirm"                                                                                                             
            IF cl_chk_act_auth() THEN            
               CALL t552_yes()
            END IF                                                                                                                  
                                                                                                                                    
         WHEN "void"                                                                                                                 
            IF cl_chk_act_auth() THEN     
               CALL t552_void(1) 
            END IF
          
         #FUN-D20039 ----------sta
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t552_void(2)   
            END IF
         #FUN-D20039 ----------end

         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "curr_plant"
            IF cl_chk_act_auth() THEN     
                CALL t552_org() 
            END IF
            
         WHEN "sell"
            LET g_b_flag = "1"
            CALL t552_b_fill(g_wc1)        
            CALL t552_bp_refresh()     
 
         WHEN "feiyong"
            LET g_b_flag = "3"
            CALL t552_b2_fill(g_wc3)            
            CALL t552_bp2_refresh()
 
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
FUNCTION t552_void(p_type)
DEFINE p_type    LIKE type_file.chr1   #FUN-D20039  add '1' 作废  '2' 取消作废
DEFINE l_n LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_rvc.* FROM rvc_file WHERE rvc01 = g_rvc.rvc01
                                         AND rvc00 = g_rvc.rvc00
                                         AND rvcplant = g_rvc.rvcplant
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
 
   OPEN t552_cl USING g_rvc.rvc00,g_rvc.rvc01,g_rvc.rvcplant
   IF STATUS THEN
      CALL cl_err("OPEN t552_cl:", STATUS, 1)
      CLOSE t552_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t552_cl INTO g_rvc.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rvc.rvc01,SQLCA.sqlcode,0)
      CLOSE t552_cl
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
         AND rvcplant = g_rvc.rvcplant
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("upd","rvc_file",g_rvc.rvc01,"",SQLCA.sqlcode,"","up rvcconf",1)
          LET g_rvc.rvcconf = g_chr
          ROLLBACK WORK
          RETURN
       END IF
   END IF
 
   CLOSE t552_cl
   COMMIT WORK
 
   SELECT * INTO g_rvc.* FROM rvc_file WHERE rvc01=g_rvc.rvc01
                                         AND rvc00 = g_rvc.rvc00
                                         AND rvcplant = g_rvc.rvcplant
   DISPLAY BY NAME g_rvc.rvcconf                                                                                        
   DISPLAY BY NAME g_rvc.rvcmodu                                                                                        
   DISPLAY BY NAME g_rvc.rvcdate
    #CKP
   IF g_rvc.rvcconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_rvc.rvcconf,"","","",g_chr,"")
 
   CALL cl_flow_notify(g_rvc.rvc01,'V')
 
END FUNCTION
FUNCTION t552_check_number()
DEFINE l_i     LIKE type_file.num5
 
    FOR l_i = 1 TO g_rvg.getLength()
       IF g_rvg[l_i].rvg02 IS NULL THEN
          CONTINUE FOR
       END IF
       IF g_rvg[l_i].num_uncheck1 < g_rvg[l_i].rvg08 THEN
          RETURN 0
       END IF
    END FOR
    RETURN 1
END FUNCTION
FUNCTION t552_yes()
DEFINE l_cnt1         LIKE type_file.num5
DEFINE l_cnt2         LIKE type_file.num5
DEFINE l_cnt3         LIKE type_file.num5
DEFINE l_cnt4         LIKE type_file.num5
DEFINE l_count        LIKE type_file.num5
DEFINE l_gen02        LIKE gen_file.gen02
DEFINE l_rvd03        LIKE rvd_file.rvd03
DEFINE l_rvg08        LIKE rvg_file.rvg08
DEFINE l_flag         LIKE type_file.num5
DEFINE l_org          LIKE azp_file.azp01
 
    IF g_rvc.rvc01 IS NULL OR g_rvc.rvcplant IS NULL THEN 
       CALL cl_err('',-400,0) 
       RETURN 
    END IF
#CHI-C30107 --------------- add --------------- begin
    IF g_rvc.rvcconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    IF g_rvc.rvcconf = 'X' THEN CALL cl_err(g_rvc.rvc01,'9024',0) RETURN END IF
    IF g_rvc.rvcacti = 'N' THEN CALL cl_err(g_rvc.rvc01,'art-142',0) RETURN END IF
    IF NOT cl_confirm('art-026') THEN RETURN END IF
#CHI-C30107 --------------- add --------------- end
    SELECT * INTO g_rvc.* FROM rvc_file WHERE rvc01=g_rvc.rvc01 
                                          AND rvcplant=g_rvc.rvcplant
                                          AND rvc00 = g_rvc.rvc00
    IF g_rvc.rvcconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    IF g_rvc.rvcconf = 'X' THEN CALL cl_err(g_rvc.rvc01,'9024',0) RETURN END IF 
    IF g_rvc.rvcacti = 'N' THEN CALL cl_err(g_rvc.rvc01,'art-142',0) RETURN END IF
   
    SELECT SUM(rvg08) INTO l_rvg08 FROM rvg_file
       WHERE rvg00 = g_rvc.rvc00
         AND rvg01 = g_rvc.rvc01
         AND rvgplant = g_rvc.rvcplant
    IF l_rvg08 IS NULL THEN LET l_rvg08 = 0 END IF
   #TQC-B10045 Begin---
   #IF l_rvg08 = 0 THEN 
    LET g_cnt = 0
    SELECT count(*) INTO g_cnt FROM rve_file
       WHERE rve00 = g_rvc.rvc00
         AND rve01 = g_rvc.rvc01
         AND rveplant = g_rvc.rvcplant
    IF cl_null(g_cnt) THEN LET g_cnt = 0 END IF
    IF l_rvg08 = 0 AND g_cnt = 0 THEN 
   #TQC-B10045 End-----
       CALL cl_err('','art-509',0) 
       RETURN 
    END IF
 
    #  
    #IF NOT t552_check() THEN 
    #   CALL cl_err(l_rvd03,'art-508',0)
    #   RETURN
    #END IF
    #
    IF NOT t552_check_number() THEN
       CALL cl_err('','art-507',0)
       RETURN
    END IF
 
    CALL s_showmsg_init()
    #檢查對帳機構中所有的上級機構和下機構機構是否已經對過帳
    CALL s_check(g_rvc.rvc00,g_rvc.rvc01,g_rvc.rvcplant,g_rvc.rvc03,g_rvc.rvc04,g_rvc.rvc05)
       RETURNING l_flag
    IF l_flag = 0 THEN
       CALL s_showmsg()
       RETURN
    END IF
 
#   IF NOT cl_confirm('art-026') THEN RETURN END IF #CHI-C30107 mark
   #FUN-B40031 Begin---
    SELECT rvg02,rvg03,rvg04,rvg05,rvg06,ogb04,ogb05,ogb14t,rvg08,ogb46
      FROM rvg_file,ogb_file
     WHERE 1=0
      INTO TEMP t552_temp
   #FUN-B40031 End-----
    BEGIN WORK
    OPEN t552_cl USING g_rvc.rvc00,g_rvc.rvc01,g_rvc.rvcplant
    IF STATUS THEN
       CALL cl_err("OPEN t552_cl:", STATUS, 1)
       CLOSE t552_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t552_cl INTO g_rvc.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_rvc.rvc01,SQLCA.sqlcode,0)
       CLOSE t552_cl 
       ROLLBACK WORK 
       RETURN
    END IF
 
    LET g_success = 'Y'
    LET l_cnt1 = 0
    LET l_cnt3 = 0
    LET l_cnt4 = 0
   
    SELECT COUNT(*) INTO l_cnt1 FROM rvg_file
       WHERE rvg01 = g_rvc.rvc01 
         AND rvg00 = g_rvc.rvc00 
         AND rvgplant = g_rvc.rvcplant
 
    SELECT COUNT(*) INTO l_cnt3 FROM rve_file 
       WHERE rve01=g_rvc.rvc01 
         AND rve00 = g_rvc.rvc00 
         AND rveplant=g_rvc.rvcplant
    IF l_cnt1 = 0 AND l_cnt3 = 0 THEN 
       CALL cl_err('','mfg-009',0)
       ROLLBACK WORK
       RETURN
    END IF
 
    UPDATE rvc_file SET rvcconf='Y',
                        rvccond=g_today, 
                        rvcconu=g_user
        WHERE rvc01 = g_rvc.rvc01 
          AND rvc00 = g_rvc.rvc00
          AND rvcplant = g_rvc.rvcplant
   IF SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
  #FUN-B40031 Begin---
   ELSE
      CALL t552_ins_apmt723()
  #FUN-B40031 End-----
   END IF
 
   IF g_success = 'Y' THEN
      LET g_rvc.rvcconf='Y'
      LET g_rvc.rvcconu=g_user      #TQC-A30030 ADD
      LET g_rvc.rvccond=g_today     #TQC-A30030 ADD
      COMMIT WORK
      CALL cl_flow_notify(g_rvc.rvc01,'Y')
   ELSE
      ROLLBACK WORK
   END IF
   CALL s_showmsg()  #FUN-B40031
   
   SELECT * INTO g_rvc.* FROM rvc_file WHERE rvc01=g_rvc.rvc01 
                                         AND rvcplant=g_rvc.rvcplant
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

#FUN-B40031 Begin---
FUNCTION t552_ins_apmt723()
 DEFINE l_rvg     RECORD
                   rvg02    LIKE rvg_file.rvg02,
                   rvg03    LIKE rvg_file.rvg03,
                   rvg04    LIKE rvg_file.rvg04,
                   rvg05    LIKE rvg_file.rvg05,
                   rvg06    LIKE rvg_file.rvg06,
                   ogb04    LIKE ogb_file.ogb04,
                   ogb05    LIKE ogb_file.ogb05,
                   ogb14t   LIKE ogb_file.ogb14t,
                   rvg08    LIKE rvg_file.rvg08,
                   ogb46    LIKE ogb_file.ogb46
                  END RECORD
 DEFINE l_rvg1    RECORD
                   rvg03    LIKE rvg_file.rvg03,
                   ogb04    LIKE ogb_file.ogb04,
                   ogb05    LIKE ogb_file.ogb05,
                   rvg08    LIKE rvg_file.rvg08,
                   ogb14t   LIKE ogb_file.ogb14t
                  END RECORD
 DEFINE l_rvu113  LIKE rvu_file.rvu113  #FUN-B40098
 DEFINE l_rvu114  LIKE rvu_file.rvu114  #FUN-B40098

  #FUN-B40098 Begin---
   LET g_sql = "SELECT pmc22 ",
               "  FROM ",cl_get_target_table(g_rvc.rvcplant, 'pmc_file'),
               " WHERE pmc01='",g_rvc.rvc03,"'"
   PREPARE t552_sel_pmc1 FROM g_sql
   EXECUTE t552_sel_pmc1 INTO l_rvu113
   #汇率
   IF g_aza.aza17 = l_rvu113 THEN
      LET l_rvu114 = 1
   ELSE
      CALL s_curr3(l_rvu113,g_today,g_sma.sma904)
         RETURNING l_rvu114
   END IF
   IF cl_null(l_rvu114) THEN LET l_rvu114 = 1 END IF
  #FUN-B40098 End-----
   DELETE FROM t552_temp
   LET g_sql = " SELECT rvg02,rvg03,rvg04,rvg05,rvg06,'','','',rvg08,'' ",
               "   FROM rvg_file",
               "  WHERE rvg01='",g_rvc.rvc01,"' ",
               "    AND rvg00='4' AND rvg07='Y'"
   PREPARE t552_sel_rvg FROM g_sql
   DECLARE t552_sel_rvg_cs CURSOR FOR t552_sel_rvg
   FOREACH t552_sel_rvg_cs INTO l_rvg.*
      IF STATUS THEN
         CALL s_errmsg("rvg01",l_rvg.rvg02,"t552_sel_rvg_cs",STATUS,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF

      IF l_rvg.rvg04='1' THEN
        #LET g_sql = " SELECT ogb04,ogb05,ogb14t,COALESCE(ogb46,0) ",                    #FUN-B40098
        #LET g_sql = " SELECT ogb04,ogb05,ogb14t*oga24/",l_rvu114,",COALESCE(ogb46,0) ", #FUN-B40098 #FUN-B60099
         LET g_sql = " SELECT ogb04,ogb05,(ogb14t*oga24/",l_rvu114,")*(",l_rvg.rvg08,"/ogb12),COALESCE(ogb46,0) ", #FUN-B60099
                     "   FROM ",cl_get_target_table(l_rvg.rvg03, 'ogb_file'),",",
                                cl_get_target_table(l_rvg.rvg03, 'oga_file'),
                     "  WHERE ogb01 = '",l_rvg.rvg05,"'",
                     "    AND ogb03 = '",l_rvg.rvg06,"'",
                     "    AND oga01 = ogb01 "
      ELSE
        #LET g_sql = " SELECT ohb04,ohb05,ohb14t*(-1),COALESCE(ohb66,0) ",                    #FUN-B40098
        #LET g_sql = " SELECT ohb04,ohb05,ohb14t*(-1)*oha24/",l_rvu114,",COALESCE(ohb66,0) ", #FUN-B40098               #FUN-B60099
         LET g_sql = " SELECT ohb04,ohb05,(ohb14t*(-1)*oha24/",l_rvu114,")*(",l_rvg.rvg08,"/ohb12),COALESCE(ohb66,0) ", #FUN-B60099
                     "   FROM ",cl_get_target_table(l_rvg.rvg03, 'ohb_file'),",",
                                cl_get_target_table(l_rvg.rvg03, 'oha_file'),
                     "  WHERE ohb01 = '",l_rvg.rvg05,"'",
                     "    AND ohb03 = '",l_rvg.rvg06,"'",
                     "    AND oha01 = ohb01 "
      END IF
      PREPARE t552_selogb FROM g_sql
      EXECUTE t552_selogb INTO l_rvg.ogb04,l_rvg.ogb05,
                               l_rvg.ogb14t,l_rvg.ogb46
      INSERT INTO t552_temp VALUES(l_rvg.rvg02,l_rvg.rvg03,l_rvg.rvg04,l_rvg.rvg05,
                                      l_rvg.rvg06,l_rvg.ogb04,l_rvg.ogb05,
                                      l_rvg.ogb14t,l_rvg.rvg08,l_rvg.ogb46)
     #总含税金额=ogb14t*对账数量/ogb12
     #INSERT INTO t552_temp ……
   END FOREACH

   UPDATE t552_temp SET rvg08=rvg08*(-1) WHERE rvg04='2'

   DECLARE t552_sel_rvg03 CURSOR FOR
    SELECT rvg03,ogb04,ogb05,SUM(rvg08),SUM(ogb14t*(100-ogb46)/100) FROM t552_temp
     GROUP BY rvg03,ogb04,ogb05
     ORDER BY rvg03,ogb04,ogb05
   FOREACH t552_sel_rvg03 INTO l_rvg1.*
      IF STATUS THEN
         CALL s_errmsg("rvg01",l_rvg1.rvg03,"t552_sel_rvg03",STATUS,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF

      IF l_rvg1.ogb14t >= 0 THEN
         CALL t552_insrvu('1',l_rvg1.*)
      ELSE
         CALL t552_insrvu('3',l_rvg1.*)
      END IF

   END FOREACH
END FUNCTION

FUNCTION t552_insrvu(p_rvu00,p_rvg)
 DEFINE p_rvu00    LIKE rvu_file.rvu00
 DEFINE l_rvu      RECORD LIKE rvu_file.*
 DEFINE l_rvv      RECORD LIKE rvv_file.*
 DEFINE p_rvg     RECORD
                   rvg03    LIKE rvg_file.rvg03,
                   ogb04    LIKE ogb_file.ogb04,
                   ogb05    LIKE ogb_file.ogb05,
                   rvg08    LIKE rvg_file.rvg08,
                   ogb14t   LIKE ogb_file.ogb14t
                  END RECORD
 DEFINE l_rvw06f   LIKE rvw_file.rvw06f
 DEFINE l_gec05    LIKE gec_file.gec05
 DEFINE l_gec07    LIKE gec_file.gec07
 DEFINE l_yy       LIKE type_file.num5
 DEFINE l_mm       LIKE type_file.num5
 DEFINE l_n        LIKE type_file.num5
 DEFINE li_result  LIKE type_file.num5

   IF p_rvu00='1' THEN
      LET g_sql = "SELECT * FROM ",cl_get_target_table(p_rvg.rvg03, 'rvu_file'),
                  " WHERE rvu25='",g_rvc.rvc01,"'",
                  "   AND rvu00='1'"
   ELSE
      LET g_sql = "SELECT * FROM ",cl_get_target_table(p_rvg.rvg03, 'rvu_file'),
                  " WHERE rvu25='",g_rvc.rvc01,"'",
                  "   AND rvu00='3'"
   END IF
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,p_rvg.rvg03) RETURNING g_sql
   PREPARE t552_sel_ogb1 FROM g_sql
   EXECUTE t552_sel_ogb1 INTO l_rvu.*
   IF cl_null(l_rvu.rvu01) THEN
      INITIALIZE l_rvu.* TO NULL
      LET l_rvu.rvu00 = p_rvu00
     { IF g_azw.azw04='2' THEN
         IF l_rva.rva29 = '1' THEN
            LET l_rvu.rvu00='1'
         ELSE
            LET l_rvu.rvu00='4'
         END IF
      ELSE
         LET l_rvu.rvu00='1'
      END IF }                        #異動類別
      LET l_rvu.rvu02=''             #驗收單號
      LET l_rvu.rvu03=g_today        #異動日期                                      
     
      #日期<=關帳日期
      IF NOT cl_null(g_sma.sma53) AND l_rvu.rvu03 <= g_sma.sma53 THEN
         CALL s_errmsg("","",l_rvu.rvu03,"mfg9999",1)
         LET g_success='N'
         RETURN
      END IF
      CALL s_yp(l_rvu.rvu03) RETURNING l_yy,l_mm
      IF (l_yy*12+l_mm)>(g_sma.sma51*12+g_sma.sma52)THEN #不可大於現行年月
         CALL s_errmsg("","",l_rvu.rvu03,"mfg6091",1)
         LET g_success='N'
         RETURN
      END IF
     
      #FUN-C90050 mark begin---
      #LET g_sql = "SELECT rye03 FROM ",cl_get_target_table(p_rvg.rvg03, 'rye_file'),
      #            " WHERE rye01='apm' AND ryeacti='Y'" 
      #IF l_rvu.rvu00='1' THEN
      #   LET g_sql = g_sql CLIPPED," AND rye02='7' "
      #ELSE
      #   LET g_sql = g_sql CLIPPED," AND rye02='4' "
      #END IF
      #PREPARE t552_sel_rye FROM g_sql
      #EXECUTE t552_sel_rye INTO l_rvu.rvu01
      ##FUN-B60099 Begin---
      # IF SQLCA.sqlcode = 100 THEN
      #    CALL s_errmsg("","",l_rvu.rvu01,"art-330",1)
      #    LET g_success='N'
      #    RETURN
      # END IF
      ##FUN-B60099 End-----
      #FUN-C90050 mark end-----

      #FUN-C90050 add begin---
      IF l_rvu.rvu00='1' THEN
         CALL s_get_defslip('apm','7',p_rvg.rvg03,'N') RETURNING l_rvu.rvu01
      ELSE
         CALL s_get_defslip('apm','4',p_rvg.rvg03,'N') RETURNING l_rvu.rvu01
      END IF
      IF cl_null(l_rvu.rvu01) THEN
         CALL s_errmsg("","",l_rvu.rvu01,"art-330",1)
         LET g_success = 'N'
         RETURN
      END IF
      #FUN-C90050 add end-----

      CALL s_auto_assign_no("apm",l_rvu.rvu01,l_rvu.rvu03,"","","",p_rvg.rvg03,"","")
           RETURNING li_result,l_rvu.rvu01
      IF (NOT li_result) THEN
         LET g_success='N'
         RETURN
      END IF
     
      LET l_rvu.rvu04=g_rvc.rvc03                  #廠商編號
      LET g_sql = "SELECT pmc03,pmc17,pmc49,pmc22,pmc47 ",
                  "  FROM ",cl_get_target_table(p_rvg.rvg03, 'pmc_file'),
                  " WHERE pmc01='",g_rvc.rvc03,"'"
      PREPARE t552_sel_pmc FROM g_sql
      EXECUTE t552_sel_pmc INTO l_rvu.rvu05,l_rvu.rvu111,l_rvu.rvu112,
                                l_rvu.rvu113,l_rvu.rvu115
      LET g_sql = "SELECT gec04 ",
                  "  FROM ",cl_get_target_table(p_rvg.rvg03, 'gec_file'),
                  " WHERE gec01='",l_rvu.rvu115,"'",
                  "   AND gec011='1'"
      PREPARE t552_sel_gec FROM g_sql
      EXECUTE t552_sel_gec INTO l_rvu.rvu12
      #汇率
      IF g_aza.aza17 = l_rvu.rvu113 THEN
         LET l_rvu.rvu114 = 1
      ELSE
         CALL s_curr3(l_rvu.rvu113,g_today,g_sma.sma904)
            RETURNING l_rvu.rvu114
      END IF
      LET l_rvu.rvu25=g_rvc.rvc01
      LET l_rvu.rvu06=g_grup        #部門
      LET l_rvu.rvu07=g_user        #人員
      LET l_rvu.rvu08='REG'         #性質
      LET l_rvu.rvu09=NULL
      LET l_rvu.rvuacti='Y'
      LET l_rvu.rvu20='N'           #三角貿易拋轉否
      LET l_rvu.rvu99=''
      LET l_rvu.rvuuser=g_user
      LET l_rvu.rvugrup=g_grup
      LET l_rvu.rvumodu=' '
      LET l_rvu.rvudate=g_today
     #LET l_rvu.rvu21 = '4' #FUN-BB0072 Mark
      LET l_rvu.rvu21 = '1' #FUN-BB0072 Add
      LET l_rvu.rvu27 = '4' #TQC-B60065 #产生虚拟类型为4.联营入库的入库单
      LET l_rvu.rvuplant = p_rvg.rvg03
      SELECT azw02 INTO l_rvu.rvulegal
        FROM azw_file
       WHERE azw01 = p_rvg.rvg03
      LET g_sql = "SELECT rty12,rty04 ",
                  "  FROM ",cl_get_target_table(p_rvg.rvg03, 'rty_file'),
                  " WHERE rty01 = '",p_rvg.rvg03,"'",
                  "   AND rty02 = '",p_rvg.ogb04,"'"
      PREPARE t552_sel_rty FROM g_sql
      EXECUTE t552_sel_rty INTO l_rvu.rvu22,l_rvu.rvu23
      LET l_rvu.rvu900 = '1'
      LET l_rvu.rvumksg = 'N'
      LET l_rvu.rvuconf='Y'         #確認碼
      LET l_rvu.rvucond = g_today
      LET l_rvu.rvucont = g_time
      LET l_rvu.rvuconu = g_user
      LET l_rvu.rvu17='0'
      LET l_rvu.rvucrat = g_today
      LET l_rvu.rvupos = 'N'
      LET l_rvu.rvuoriu = g_user
      LET l_rvu.rvuorig = g_grup
      LET l_rvu.rvuud13 = NULL
      LET l_rvu.rvuud14 = NULL
      LET l_rvu.rvuud15 = NULL
      
      INSERT INTO rvu_file VALUES (l_rvu.*)
      IF STATUS THEN
         CALL s_errmsg("rvu01",l_rvu.rvu01,"ins rvu:2",STATUS,1)
         LET g_success='N'
         RETURN
      END IF
   END IF
   #-->單身
   LET l_rvv.rvv01=l_rvu.rvu01     #單號
   LET g_sql = "SELECT MAX(rvv02)+1 ",
               "  FROM ",cl_get_target_table(p_rvg.rvg03, 'rvv_file'),
               " WHERE rvv01='",l_rvu.rvu01,"'"
   PREPARE t552_sel_rvv FROM g_sql
   EXECUTE t552_sel_rvv INTO l_rvv.rvv02
   IF cl_null(l_rvv.rvv02) THEN LET l_rvv.rvv02=1 END IF
   LET l_rvv.rvv03=p_rvu00         #異動類別
   LET l_rvv.rvv04=''              #驗收單號
   LET l_rvv.rvv05=''              #驗收項次
   LET l_rvv.rvv06=g_rvc.rvc03     #廠商
   LET l_rvv.rvv09=g_today         #異動日期 
   IF p_rvg.rvg08 < 0 THEN
      LET p_rvg.rvg08 = p_rvg.rvg08 * (-1)
   END IF
   LET l_rvv.rvv17=p_rvg.rvg08     #數量
   LET l_rvv.rvv18=''
   LET l_rvv.rvv23=0
   LET l_rvv.rvv24=NULL
   LET l_rvv.rvv25='N'
   LET l_rvv.rvv26=NULL
   LET l_rvv.rvv31=p_rvg.ogb04
   LET g_sql = "SELECT ima02 ",
               "  FROM ",cl_get_target_table(p_rvg.rvg03, 'ima_file'),
               " WHERE ima01='",p_rvg.ogb04,"'"
   PREPARE t552_sel_ima FROM g_sql
   EXECUTE t552_sel_ima INTO l_rvv.rvv031
   LET l_rvv.rvv32=''
   LET l_rvv.rvv33=''
   LET l_rvv.rvv34=''
   LET l_rvv.rvv35=p_rvg.ogb05
   LET l_rvv.rvv17=s_digqty(l_rvv.rvv17,l_rvv.rvv35)   #No.FUN-BB0086
   LET l_rvv.rvv35_fac=1
   LET l_rvv.rvv36=''
   LET l_rvv.rvv37=''
   LET l_rvv.rvv40='N'
   LET l_rvv.rvv86=p_rvg.ogb05
   LET l_rvv.rvv86=p_rvg.rvg08
   LET l_rvv.rvv930=s_costcenter(l_rvu.rvu06)
   LET l_rvv.rvv88=0
   LET l_rvv.rvvud13=NULL
   LET l_rvv.rvvud14=NULL
   LET l_rvv.rvvud15=NULL
   LET l_rvv.rvv89='N'
   LET l_rvv.rvvplant=p_rvg.rvg03
   SELECT azw02 INTO l_rvv.rvvlegal
     FROM azw_file
    WHERE azw01 = p_rvg.rvg03
  #LET l_rvv.rvv10='3'  #其他 #FUN-B40098
   
   LET l_rvv.rvv82=p_rvg.rvg08
   LET l_rvv.rvv85=p_rvg.rvg08
   IF g_sma.sma115 = 'Y' THEN
      LET l_rvv.rvv80=p_rvg.ogb05
      LET l_rvv.rvv81=1
      LET l_rvv.rvv82=p_rvg.rvg08
      LET l_rvv.rvv82=s_digqty(l_rvv.rvv82,l_rvv.rvv80)   #No.FUN-BB0086
      LET l_rvv.rvv83=p_rvg.ogb05
      LET l_rvv.rvv84=1
      LET l_rvv.rvv85=p_rvg.rvg08
      LET l_rvv.rvv85=s_digqty(l_rvv.rvv85,l_rvv.rvv83)   #No.FUN-BB0086
   END IF
   LET l_rvv.rvv86=p_rvg.ogb05
   LET l_rvv.rvv87=p_rvg.rvg08
   LET l_rvv.rvv87=s_digqty(l_rvv.rvv87,l_rvv.rvv86)   #No.FUN-BB0086
   
   LET t_azi03=''
   LET t_azi04=''
   SELECT azi03,azi04 INTO t_azi03,t_azi04 
     FROM azi_file
    WHERE azi01=l_rvu.rvu113
   IF cl_null(t_azi03) THEN LET t_azi03=0 END IF
   IF cl_null(t_azi04) THEN LET t_azi04=0 END IF
   
   IF p_rvg.ogb14t < 0 THEN
      LET p_rvg.ogb14t = p_rvg.ogb14t * (-1)
   END IF
   LET l_rvv.rvv38t=p_rvg.ogb14t/p_rvg.rvg08
   LET l_rvv.rvv39t=p_rvg.ogb14t
   CALL cl_digcut(l_rvv.rvv38t,t_azi03) RETURNING l_rvv.rvv38t   
   CALL cl_digcut(l_rvv.rvv39t,t_azi04) RETURNING l_rvv.rvv39t
   IF l_rvu.rvu00='1' THEN
      #不使用單價*數量=金額, 改以金額回推稅率, 以避免小數位差的問題
      LET g_sql = "SELECT gec05,gec07 ",
                  "  FROM ",cl_get_target_table(p_rvg.rvg03, 'gec_file'),
                  " WHERE gec01='",l_rvu.rvu115,"'"
      PREPARE t552_sel_gec1 FROM g_sql
      EXECUTE t552_sel_gec1 INTO l_gec05,l_gec07
      IF SQLCA.SQLCODE = 100 THEN
         CALL s_errmsg("rvu01",l_rvu.rvu01,"sel gec",'mfg3192',1)
         LET g_success = 'N'
         RETURN
      END IF
      IF l_gec07='Y' THEN
         IF l_gec05 = 'T' THEN
            LET l_rvw06f = l_rvv.rvv39t * (l_rvu.rvu12/100)
            LET l_rvw06f = cl_digcut(l_rvw06f , t_azi04)
            LET l_rvv.rvv39 = l_rvv.rvv39t - l_rvw06f 
            LET l_rvv.rvv39 = cl_digcut(l_rvv.rvv39 , t_azi04)  
         ELSE
            LET l_rvv.rvv39 = l_rvv.rvv39t / ( 1 + l_rvu.rvu12/100)
            LET l_rvv.rvv39 = cl_digcut(l_rvv.rvv39 , t_azi04)  
         END IF 
      ELSE
         LET l_rvv.rvv39 = l_rvv.rvv39t / ( 1 + l_rvu.rvu12/100)
         LET l_rvv.rvv39 = cl_digcut( l_rvv.rvv39t , t_azi04)  
      END IF
   ELSE
      #不使用單價*數量=金額,改以金額回推稅率,以避免小數位差的問題
      LET g_sql = "SELECT gec07 ",
                  "  FROM ",cl_get_target_table(p_rvg.rvg03, 'gec_file'),
                  " WHERE gec01='",l_rvu.rvu115,"'"
      PREPARE t552_sel_gec2 FROM g_sql
      EXECUTE t552_sel_gec2 INTO l_gec07
      IF SQLCA.SQLCODE = 100 THEN
         CALL s_errmsg("rvu01",l_rvu.rvu01,"sel gec",'mfg3192',1)
         LET g_success = 'N'
         RETURN
      END IF
      IF l_gec07 = 'Y' THEN
         LET l_rvv.rvv39 = l_rvv.rvv39t / ( 1 + l_rvu.rvu12/100)
         LET l_rvv.rvv39 = cl_digcut(l_rvv.rvv39 , t_azi04)
      ELSE
         LET l_rvv.rvv39 = l_rvv.rvv39t / ( 1 + l_rvu.rvu12/100)
         LET l_rvv.rvv39 = cl_digcut( l_rvv.rvv39t , t_azi04)
      END IF
   END IF
   LET l_rvv.rvv38 = l_rvv.rvv38t / ( 1 + l_rvu.rvu12/100)
   LET l_rvv.rvv38 = cl_digcut( l_rvv.rvv38 , t_azi03)
   
  #IF l_rvv.rvv10 IS NULL THEN LET l_rvv.rvv10 = '1' END IF #FUN-B40098
   IF l_rvv.rvv10 IS NULL THEN LET l_rvv.rvv10 = '4' END IF #FUN-B40098
   INSERT INTO rvv_file VALUES (l_rvv.*)
   IF STATUS THEN
      LET g_showmsg = l_rvv.rvv01,"/",l_rvv.rvv02
      CALL s_errmsg("rvv01,rvv02",g_showmsg,"i rvv:",SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION
#FUN-B40031 End-----
 
FUNCTION t552_rvcplant()
DEFINE l_azp02    LIKE  azp_file.azp02
 
    SELECT azp02 INTO l_azp02 FROM azp_file
       WHERE azp01 = g_plant
    DISPLAY l_azp02 TO FORMONLY.rvcplant_desc
END FUNCTION
FUNCTION t552_a()
DEFINE li_result   LIKE type_file.num5
DEFINE l_n         LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
 
   CALL g_rvg.clear()
   CALL g_rve.clear()
 
   INITIALIZE g_rvc.* LIKE rvc_file.*
   LET g_rvc01_t = NULL
   LET g_rvcplant_t = NULL
   
   CALL cl_opmsg('a')
   WHILE TRUE
      #LET g_rvc.rvc00 = '3' #FUN-B40031
       LET g_rvc.rvc00 = '4' #FUN-B40031
       LET g_rvc.rvc02 = '4'
       LET g_rvc.rvc05 = g_today
       LET g_rvc.rvcplant = g_plant
       LET g_rvc.rvclegal = g_legal
       LET g_rvc.rvcconf = 'N'
       LET g_rvc.rvcuser = g_user
       LET g_rvc.rvcoriu = g_user #FUN-980030
       LET g_rvc.rvcorig = g_grup #FUN-980030
       LET g_data_plant = g_plant #TQC-A10128 ADD
       LET g_rvc.rvcgrup = g_grup
       LET g_rvc.rvcmodu = NULL
       LET g_rvc.rvcdate = NULL
       LET g_rvc.rvcacti = 'Y'
       LET g_rvc.rvccrat = g_today
       CALL t552_rvcplant()
       CALL t552_i("a")
       IF INT_FLAG THEN
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           CLEAR FORM
           DISPLAY '4' TO rvc02
           CALL g_rvg.clear()
           CALL g_rve.clear()
           EXIT WHILE
       END IF
       IF g_rvc.rvc01 IS NULL OR g_rvc.rvcplant IS NULL 
          OR g_rvc.rvc00 IS NULL THEN
          CONTINUE WHILE
       END IF
       BEGIN WORK
#      CALL s_auto_assign_no("art",g_rvc.rvc01,g_today,"","rvc_file","rvc00,rvc01,rvcplant","","","") #FUN-A70130 mark
       CALL s_auto_assign_no("art",g_rvc.rvc01,g_today,"E5","rvc_file","rvc00,rvc01,rvcplant","","","") #FUN-A70130 mod
          RETURNING li_result,g_rvc.rvc01
       IF (NOT li_result) THEN                                                                           
           CONTINUE WHILE                                                                     
       END IF
       DISPLAY BY NAME g_rvc.rvc01
       INSERT INTO rvc_file VALUES(g_rvc.*)     # DISK WRITE
       IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
       #   ROLLBACK WORK               # FUN-B80085---回滾放在報錯後---
          CALL cl_err3("ins","rvc_file",g_rvc.rvc01,g_rvc.rvcplant,SQLCA.SQLCODE,"","",1) 
          ROLLBACK WORK                #FUN-B80085--add--
          CONTINUE WHILE
       ELSE
          #FUN-B80085增加空白行

          SELECT * FROM rvd_file WHERE rvd00 =g_rvc.rvc00 AND rvd01=g_rvc.rvc01
                                   AND rvd02 = '1' AND rvdplant=g_rvc.rvcplant
          IF SQLCA.SQLCODE = 100 THEN 
             INSERT INTO rvd_file(rvd00,rvd01,rvd02,rvd03,rvdplant,rvdlegal)
                            VALUES(g_rvc.rvc00,g_rvc.rvc01,1,g_rvc.rvcplant,
                                   g_rvc.rvcplant,g_rvc.rvclegal)
             IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
             #   ROLLBACK WORK          # FUN-B80085---回滾放在報錯後---
                CALL cl_err3("ins","rvc_file",g_rvc.rvc01,g_rvc.rvcplant,SQLCA.SQLCODE,"","",1) 
                ROLLBACK WORK                #FUN-B80085--add--
                CONTINUE WHILE
             END IF
          END IF
          COMMIT WORK
          LET g_rvc_t.* = g_rvc.*
       END IF
       LET g_rec_b=0
       LET g_rec_b2=0
 
       CALL t552_org()
       #
       CALL t552_insrvg()
       CALL t552_insrve()
       #如果單身沒有合乎條件的資料自動刪除單頭       
       
       SELECT COUNT(*) INTO l_n FROM rvg_file
           WHERE rvg00 = g_rvc.rvc00
             AND rvg01 = g_rvc.rvc01
             AND rvgplant = g_rvc.rvcplant
       IF l_n IS NULL THEN LET l_n = 0 END IF
 
       IF l_n = 0 THEN
          SELECT COUNT(*) INTO l_n FROM rve_file
               WHERE rve00 = g_rvc.rvc00
                 AND rve01 = g_rvc.rvc01
                 AND rveplant = g_rvc.rvcplant
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
       
       CALL t552_b_fill(" 1=1 ")
       CALL t552_b2_fill(" 1=1 ")
    
       CALL t552_b()                                                                                                         
       CALL t552_b2()
       CALL t552_delall()
       EXIT WHILE
   END WHILE
END FUNCTION
FUNCTION t552_insrve()
DEFINE l_rvd03   LIKE rvd_file.rvd03
 
#TQC-AC0136 add begin--------------------
DEFINE l_lub01   LIKE lub_file.lub01
DEFINE l_lub02   LIKE lub_file.lub02
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_dbs     LIKE azp_file.azp03
DEFINE l_n       LIKE type_file.num5
#TQC-AC0136 add -end--------------------- 
#   LET g_sql = "SELECT DISTINCT rvd03 FROM rvd_file WHERE rvd00 = '2' ",               #TQC-AC0136 MARK
    LET g_sql = "SELECT DISTINCT rvd03 FROM rvd_file WHERE rvd00 = '",g_rvc.rvc00,"'",  #TQC-AC0136 ADD
                " AND rvd01 = '",g_rvc.rvc01,"' AND rvdplant = '",g_rvc.rvcplant,"'"
    PREPARE pre_get_rvd FROM g_sql
    DECLARE pre_rvd_cur CURSOR FOR pre_get_rvd
  

    LET g_cnt = 1     #TQC-AC0136 add
    LET l_cnt = 1     #TQC-AC0136 add 
    BEGIN WORK   
    #
    FOREACH pre_rvd_cur INTO l_rvd03
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF l_rvd03 IS NULL THEN CONTINUE FOREACH END IF
 #TQC-AC0136 mark begin--------------------  
 #     LET g_sql = "SELECT lub01,lub02 FROM lub_file WHERE rub01 = rua01 ",
 #                 "  AND rua15 = 'Y' AND rua17 BETWEEN '",g_rvc.rvc04,"'",
 #                 " AND '",g_rvc.rvc05,"'"
 #  END FOREACH
 #  COMMIT WORK
 #TQC-AC0136 mark -end---------------------

 #TQC-AC0136 add begin--------------------
       LET g_plant_new = l_rvd03
       CALL s_gettrandbs()
       LET l_dbs=g_dbs_tra
       LET l_dbs = s_dbstring(l_dbs CLIPPED)

       LET g_sql = "SELECT lub01,lub02 ",
                   "  FROM ",cl_get_target_table(l_rvd03, 'lua_file'),",",cl_get_target_table(l_rvd03, 'lub_file'),
                   " WHERE lub01 = lua01 ",
                   "   AND lua15 = 'Y' AND lua06 = '",g_rvc.rvc03,"'",
         #          "   AND lua17 BETWEEN '",g_rvc.rvc04,"' AND '",g_rvc.rvc05,"'",         #TQC-AC0417 mark
                   "   AND lua09 BETWEEN '",g_rvc.rvc04,"' AND '",g_rvc.rvc05,"'",         #TQC-AC0417
                   " AND lubplant = '",l_rvd03,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql
       CALL cl_parse_qry_sql(g_sql, l_rvd03) RETURNING g_sql
       PREPARE pre_lub FROM g_sql
       DECLARE pre_lub_cur CURSOR FOR pre_lub
       FOREACH pre_lub_cur INTO l_lub01,l_lub02
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          IF cl_null(l_lub01) OR cl_null(l_lub02)  THEN CONTINUE FOREACH END IF
          SELECT COUNT(*) INTO l_n FROM rve_file
         # WHERE rve00 = '3' AND rve03 = l_rvd03 #FUN-B40031
           WHERE rve00 = '4' AND rve03 = l_rvd03 #FUN-B40031
             AND rve05 = l_lub02 AND rve04 = l_lub01
           IF l_n > 0 THEN
              CONTINUE FOREACH
           END IF
          INSERT INTO rve_file(rve00,rve01,rve02,rve03,rve04,rve05,rve06,
                              rveplant,rvelegal)
                       #VALUES('3',g_rvc.rvc01,g_cnt,l_rvd03,l_lub01, #FUN-B40031
                        VALUES('4',g_rvc.rvc01,g_cnt,l_rvd03,l_lub01, #FUN-B40031
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
 #TQC-AC0136 add -end---------------------
END FUNCTION
FUNCTION t552_insrvg()
DEFINE l_rvd03   LIKE rvd_file.rvd03
DEFINE l_ogb01   LIKE ogb_file.ogb01
DEFINE l_ogb03   LIKE ogb_file.ogb03
DEFINE l_ogb12   LIKE ogb_file.ogb12
DEFINE l_ohb01   LIKE ohb_file.ohb01
DEFINE l_ohb03   LIKE ohb_file.ohb03
DEFINE l_ohb12   LIKE ohb_file.ohb12
DEFINE l_sum     LIKE ohb_file.ohb12
DEFINE l_cnt     LIKE type_file.num5
 
    #
    LET g_sql = "SELECT DISTINCT rvd03 FROM rvd_file ",
                " WHERE rvd00 = '",g_rvc.rvc00,"'",
                " AND rvd01 = '",g_rvc.rvc01,"' AND rvdplant = '",
                g_rvc.rvcplant,"'"
    PREPARE pre_get_rvd1 FROM g_sql
    DECLARE pre_rvd_cur1 CURSOR FOR pre_get_rvd1
   
    BEGIN WORK   
    #
    LET g_cnt = 1
   #LET l_cnt = 1 #FUN-B40031 MARK
    FOREACH pre_rvd_cur1 INTO l_rvd03
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF l_rvd03 IS NULL THEN CONTINUE FOREACH END IF
 
      #FUN-B40031 Begin---
      #LET g_sql = "SELECT DISTINCT ogb01,ogb03,ogb12 FROM ogb_file,oga_file,rty_file ",
       LET g_sql = "SELECT DISTINCT ogb01,ogb03,ogb12 ",
                   "  FROM ",cl_get_target_table(l_rvd03, 'oga_file'),",",
                             cl_get_target_table(l_rvd03, 'ogb_file'),",",
                             cl_get_target_table(l_rvd03, 'rty_file'),
      #FUN-B40031 End-----
                   " WHERE ogb01 = oga01 AND ogaconf = 'Y' ",
                   "   AND ogacond BETWEEN '",g_rvc.rvc04,
                   "' AND '",g_rvc.rvc05,"'",
      #             "   AND ogb930 = '",l_rvd03,"'",                          #TQC-AC0417 mark
                   "   AND ogbplant = '",l_rvd03,"'",                         #TQC-AC0417
                   " AND rty02 = ogb04 AND rty01 ='",l_rvd03,"' AND ",
                   "  rty05 = '",g_rvc.rvc03,"' AND rtyacti = 'Y' ",
                   " AND rty06=ogb44 AND rty06 = '",g_rvc.rvc02,"'"
       PREPARE pre_ogb FROM g_sql
       DECLARE pre_ogb_cur CURSOR FOR pre_ogb
       FOREACH pre_ogb_cur INTO l_ogb01,l_ogb03,l_ogb12
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          IF cl_null(l_ogb01) OR cl_null(l_ogb03) THEN CONTINUE FOREACH END IF
          
          #
          SELECT SUM(rvg08) INTO l_sum FROM rvg_file,rvc_file 
               WHERE rvc00 = rvg00
                 AND rvc01 = rvg01
                 AND rvcplant= rvgplant
              #  AND rvcconf = 'Y'  #TQC-B60065
                 AND rvcconf <> 'X' #TQC-B60065
                 AND rvg00 = g_rvc.rvc00 
                 AND rvg05 = l_ogb01 
                 AND rvg06 = l_ogb03
          IF l_sum IS NULL THEN LET l_sum = 0 END IF
          LET l_ogb12 = l_ogb12 - l_sum 
          IF l_ogb12 <= 0 THEN CONTINUE FOREACH END IF
          INSERT INTO rvg_file 
     #       VALUES(g_rvc.rvc00,g_rvc.rvc01,g_cnt,l_rvd03,'1',l_ogb01,l_ogb03,'Y',l_ogb12,g_rvc.rvcplant) #TQC-AC0136 MARK
             VALUES(g_rvc.rvc00,g_rvc.rvc01,g_cnt,l_rvd03,'1',l_ogb01,l_ogb03,'Y',  #TQC-AC0136 ADD
                    l_ogb12,g_rvc.rvclegal,g_rvc.rvcplant)                          #TQC-AC0136 ADD
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","rvg_file",g_rvc.rvc01,"",SQLCA.sqlcode,"","",1)
             ROLLBACK WORK
             RETURN
          END IF
          LET g_cnt = g_cnt + 1
       END FOREACH
 
      #FUN-B40031 Begin---
      #LET g_sql = "SELECT DISTINCT ohb01,ohb03,ohb12 FROM ohb_file,oha_file,rty_file ",
       LET g_sql = "SELECT DISTINCT ohb01,ohb03,ohb12 ",
                   "  FROM ",cl_get_target_table(l_rvd03, 'oha_file'),",",
                             cl_get_target_table(l_rvd03, 'ohb_file'),",",
                             cl_get_target_table(l_rvd03, 'rty_file'),
      #FUN-B40031 End-----
                   " WHERE oha01 = ohb01 AND ohaconf = 'Y' ",
                   "   AND ohacond BETWEEN '",g_rvc.rvc04,"' AND '",
     #              g_rvc.rvc05,"' AND ohb930 = '",l_rvd03,"'",                   #TQC-AC0417  mark
                   g_rvc.rvc05,"' AND ohbplant = '",l_rvd03,"'",                  #TQC-AC0417
                   " AND rty02 = ohb04 AND rty01 = '",l_rvd03,"'",
                   " AND rty05 = '",g_rvc.rvc03,"' AND rtyacti = 'Y' ",
                   " AND ohb64 = rty06 AND rty06 = '",g_rvc.rvc00,"'" 
       PREPARE pre_ohb FROM g_sql
       DECLARE pre_ohb_cur CURSOR FOR pre_ohb
       FOREACH pre_ohb_cur INTO l_ohb01,l_ohb03,l_ohb12
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          IF cl_null(l_ohb01) OR cl_null(l_ohb03) THEN CONTINUE FOREACH END IF
          
          #未對帳數量必須大于已經對帳數量之和
          SELECT SUM(rvg08) INTO l_sum FROM rvg_file,rvc_file 
               WHERE rvc00 = rvg00
                 AND rvc01 = rvg01
                 AND rvcplant= rvgplant
               # AND rvcconf = 'Y'  #TQC-B60250
                 AND rvcconf <> 'X' #TQC-B60250
                 AND rvg00 = g_rvc.rvc00 
                 AND rvg05 = l_ohb01 
                 AND rvg06 = l_ohb03
          IF l_sum IS NULL THEN LET l_sum = 0 END IF
          LET l_ohb12 = l_ohb12 - l_sum
          IF l_ohb12 <= 0 THEN CONTINUE FOREACH END IF
 
          INSERT INTO rvg_file 
      #      VALUES(g_rvc.rvc00,g_rvc.rvc01,g_cnt,l_rvd03,'2',l_ohb01,l_ohb03,'Y',l_ohb12,g_rvc.rvcplant) #TQC-AC0136 MARK
            #VALUES(g_rvc.rvc00,g_rvc.rvc01,g_cnt,l_rvd03,'3',                     #TQC-AC0136 ADD
             VALUES(g_rvc.rvc00,g_rvc.rvc01,g_cnt,l_rvd03,'2',                     #FUN-B40031
                    l_ohb01,l_ohb03,'Y',l_ohb12,g_rvc.rvclegal,g_rvc.rvcplant)     #TQC-AC0136 ADD
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","rvg_file",g_rvc.rvc01,"",SQLCA.sqlcode,"","",1)
             ROLLBACK WORK
             RETURN
          END IF
         #LET l_cnt = l_cnt + 1 #FUN-B40031
          LET g_cnt = g_cnt + 1 #FUN-B40031
       END FOREACH
    END FOREACH
 
    COMMIT WORK
END FUNCTION
 
FUNCTION t552_org()
 
    IF cl_null(g_rvc.rvc00) OR cl_null(g_rvc.rvc01)
       OR cl_null(g_rvc.rvcplant) THEN
       RETURN
    END IF
 
    LET p_row = 4 LET p_col = 10
    OPEN WINDOW t552_1_w AT p_row,p_col WITH FORM "art/42f/artt551_1"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
  
    CALL cl_ui_init()
    
    CALL t552_1_fill(" 1=1 ")
    CALL t552_1_b()
    CALL t552_1_menu()
    CLOSE WINDOW t552_1_w
    LET g_action_choice = ""
END FUNCTION
FUNCTION t552_1_menu()
WHILE TRUE
      CALL t552_1_bp("G")
      CASE g_action_choice
      
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t552_1_q()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t552_1_b()
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
FUNCTION t552_1_bp(p_ud)
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
FUNCTION t552_1_q()
 
   CLEAR FORM
   CALL g_rvd.clear()
   DISPLAY ' ' TO FORMONLY.cn2
 
   CONSTRUCT g_wc3 ON rvd02,rvd03 FROM s_rvd[1].rvd02,s_rvd[1].rvd03
        BEFORE CONSTRUCT 
           CALL cl_qbe_init()
        ON ACTION controlp
           CASE WHEN INFIELD(rvd03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.arg1 = g_rvc.rvc00
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
   CALL t552_1_fill(g_wc3)
END FUNCTION 
FUNCTION t552_1_b()
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
          AND rvcplant=g_rvc.rvcplant
          AND rvc00 = g_rvc.rvc00
        
    IF g_rvc.rvcacti = 'N' THEN CALL cl_err('','mfg1000',0) RETURN END IF     
    IF g_rvc.rvcconf='Y' THEN CALL cl_err('','art-046',0) RETURN END IF
    IF g_rvc.rvcconf='X' THEN CALL cl_err('',9024,0) RETURN END IF
 
    LET g_forupd_sql="SELECT rvd02,rvd03,'' FROM rvd_file ",
                     " WHERE rvd00 = '",g_rvc.rvc00,"'",
                     " AND rvd01 = '",g_rvc.rvc01,"'",
                     "   AND rvdplant = '",g_rvc.rvcplant,"'",
                     "   AND rvd02 = ? FOR UPDATE  "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t552_1_bcl CURSOR FROM g_forupd_sql
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
             OPEN t552_1_bcl USING g_rvd_t.rvd02
             IF STATUS THEN
                CALL cl_err("OPEN t552_1_bcl:",STATUS,1)
                LET l_lock_sw='Y'
             ELSE
                FETCH t552_1_bcl INTO g_rvd[l_ac3].*
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_rvd_t.rvd02,SQLCA.sqlcode,1)
                   LET l_lock_sw="Y"
                END IF
                CALL t552_rvd03()
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
                        VALUES(g_rvc.rvc00,g_rvc.rvc01,g_rvd[l_ac3].rvd02,
                               g_rvd[l_ac3].rvd03,g_rvc.rvcplant,g_rvc.rvclegal)
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","rvc_file",g_rvc.rvc01,g_rvd[l_ac3].rvd02,SQLCA.sqlcode,"","",1)
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
               WHERE rvd01 = g_rvc.rvc01 
                 AND rvd00 = g_rvc.rvc00
                 AND rvdplant = g_rvc.rvcplant
             IF g_rvd[l_ac3].rvd02 IS NULL THEN LET g_rvd[l_ac3].rvd02 = 1 END IF
          END IF
       AFTER FIELD rvd02 
          IF NOT cl_null(g_rvd[l_ac3].rvd02) THEN
             IF g_rvd[l_ac3].rvd02 != g_rvd_t.rvd02
                OR g_rvd_t.rvd02 IS NULL THEN
                SELECT count(*) INTO l_n FROM rvd_file
                   WHERE rvd00 = g_rvc.rvc00 
                     AND rvd01 = g_rvc.rvc01
                     AND rvd02 = g_rvd[l_ac3].rvd02 
                     AND rvdplant = g_rvc.rvcplant
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
                     AND rvdplant = g_rvc.rvcplant
                     AND rvd03 = g_rvd[l_ac3].rvd03
                IF l_n IS NULL THEN LET l_n = 0 END IF
                IF l_n > 0 THEN
                   CALL cl_err(g_rvd[l_ac3].rvd03,-239,1)
                   NEXT FIELD rvd03
                END IF
                CALL t552_rvd03()
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
                                     AND rvd02 = g_rvd_t.rvd02 AND rvdplant = g_rvc.rvcplant
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
              CLOSE t552_1_bcl
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
                    AND rvd00 = g_rvc.rvc00 AND rvdplant = g_rvc.rvcplant
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
#          LET l_ac3_t = l_ac3      #FUN-D30033 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rvd[l_ac3].* = g_rvd_t.*
              #FUN-D30033---add---str---
              ELSE
                 CALL g_rvd.deleteElement(l_ac3)
                 IF g_rec_b3 != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac3 = l_ac3_t
                 END IF
              #FUN-D30033---add---end---
              END IF
              CLOSE t552_1_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac3_t = l_ac3      #FUN-D30033 add
           CLOSE t552_1_bcl
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
                #LET g_qryparam.form ="q_tqb01_2"   #FUN-9B0025 MARK 
                #LET g_qryparam.where = "tqb01 IN ",g_auth  #FUN-9B0025 MARK
                 LET g_qryparam.form ="q_azp"   #FUN-9B0025 ADD
                 LET g_qryparam.where = " azp01 IN ",g_auth," "   #TQC-AC0136 add
                 LET g_qryparam.default1 = g_rvd[l_ac3].rvd03
                 CALL cl_create_qry() RETURNING g_rvd[l_ac3].rvd03
                 DISPLAY BY NAME g_rvd[l_ac3].rvd03
                 CALL t552_rvd03()
                 NEXT FIELD rvd03
           END CASE
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
    END INPUT
    CLOSE t552_1_bcl
    COMMIT WORK
END FUNCTION
FUNCTION t552_rvd03()
DEFINE l_n        LIKE type_file.num5
DEFINE l_sql      STRING     #TQC-C80151 add

       LET g_errno = ''      #TQC-C80151 add
       SELECT azp02 INTO g_rvd[l_ac3].rvd03_desc FROM azp_file 
           WHERE azp01 = g_rvd[l_ac3].rvd03
       CASE
          WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
          OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------' 
       END CASE
 
       IF cl_null(g_errno) THEN
         #FUN-9B0025 MARK & ADD START------
         #LET g_sql = "SELECT COUNT(*) FROM azw_file WHERE azw01 = '",
         #            g_rvd[l_ac3].rvd03,"' AND azw01 IN ",g_auth
         #PREPARE pre_azw FROM g_sql
         #EXECUTE pre_azw INTO l_n
        #TQC-C80151 mark begin ---
         #SELECT COUNT(*) INTO l_n FROM azp_file
         # WHERE azp01 IN (SELECT azw01 FROM azw_file
         #                  WHERE azw07=g_rvc.rvcplant OR azw01=g_rvc.rvcplant)
         # AND azp01 = g_rvd[l_ac3].rvd03 
         ##FUN-9B0025 MARK &ADD END--------- 
         #TQC-C80151 mark end ---
         #TQC-C80151 add begin ---
          LET l_sql = "SELECT COUNT(*) FROM azp_file ",
                      " WHERE azp01 IN ",g_auth,
                      "   AND azp01 = '",g_rvd[l_ac3].rvd03,"'"
          PREPARE t552_sel_azp01 FROM l_sql
          EXECUTE t552_sel_azp01 INTO l_n
         #TQC-C80151 add end ---
          IF l_n IS NULL THEN LET l_n = 0 END IF
          IF l_n = 0 THEN LET g_errno = 'art-500' END IF
       END IF
END FUNCTION
 
FUNCTION t552_1_bp_refresh()
  DISPLAY ARRAY g_rvd TO s_rvd.* ATTRIBUTE(COUNT=g_rec_b3,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
 
END FUNCTION
FUNCTION t552_1_fill(p_wc2)
DEFINE p_wc2   STRING
 
    LET g_sql = "SELECT rvd02,rvd03,'' FROM rvd_file ",
                " WHERE rvd01 ='",g_rvc.rvc01,"'",
                " AND rvd00 = '",g_rvc.rvc00,"'",
                "   AND rvdplant = '",g_rvc.rvcplant,"'"
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    LET g_sql=g_sql CLIPPED," ORDER BY rvd02 "
  
    PREPARE t552_1_pb FROM g_sql
    DECLARE rvd_1_cs CURSOR FOR t552_1_pb
 
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
   CALL t552_1_bp_refresh()
END FUNCTION
FUNCTION t552_delall()
DEFINE l_cnt1      LIKE type_file.num5
DEFINE l_cnt2      LIKE type_file.num5
DEFINE l_cnt3      LIKE type_file.num5
DEFINE l_cnt4      LIKE type_file.num5
DEFINE l_count     LIKE type_file.num5
 
   LET l_cnt1 = 0
   LET l_cnt2 = 0
   LET l_cnt3 = 0
   LET l_count = 0
 
   SELECT COUNT(*) INTO l_cnt1 FROM rvg_file
       WHERE rvg01=g_rvc.rvc01 
         AND rvg00 = g_rvc.rvc00 
         AND rvgplant=g_rvc.rvcplant
   
   SELECT COUNT(*) INTO l_cnt3 FROM rve_file                                        
       WHERE rve01 = g_rvc.rvc01 
         AND rve00 = g_rvc.rvc00
         AND rveplant=g_rvc.rvcplant
 
   IF l_cnt1=0 AND l_cnt3=0 THEN
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM rvc_file WHERE rvc01 = g_rvc.rvc01 
                             AND rvcplant = g_rvc.rvcplant
                             AND rvc00 = g_rvc.rvc00
      DELETE FROM rvd_file WHERE rvd00 = g_rvc.rvc00
                             AND rvd01 = g_rvc.rvc01
                             AND rvdplant = g_rvc.rvcplant
   END IF
 
END FUNCTION
 
FUNCTION t552_x()
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
   OPEN t552_cl USING g_rvc.rvc00,g_rvc.rvc01,g_rvc.rvcplant                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err("OPEN t552_cl:", STATUS, 1)                                                                                       
      CLOSE t552_cl       
      ROLLBACK WORK                                                                                                          
      RETURN                                                                                                                        
   END IF
   FETCH t552_cl INTO g_rvc.*                                                                                                       
   IF SQLCA.sqlcode THEN                                                                                                            
      CALL cl_err(g_rvc.rvc01,SQLCA.sqlcode,0)                                                                                      
      RETURN                                                                                                                        
   END IF
   LET g_success = 'Y'
   CALL t552_show()
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
         AND rvcplant = g_rvc.rvcplant 
         AND rvc00 = g_rvc.rvc00                                                                                                    
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN                                                                                   
         CALL cl_err3("upd","rvc_file",g_rvc.rvc01,"",SQLCA.sqlcode,"","",1)                                         
         LET g_rvc.rvcacti=g_chr                                                                                                    
      END IF                                                                                                                        
   END IF
 
   CLOSE t552_cl                                                                                                                    
                                                                                                                                    
   IF g_success = 'Y' THEN                                                                                                          
      COMMIT WORK                                                                                                                   
      CALL cl_flow_notify(g_rvc.rvc01,'V')                                                                                          
   ELSE                                                                                                                             
      ROLLBACK WORK                                                                                                                 
   END IF                                                                                                                           
                                                                                                                                    
   SELECT rvcacti,rvcmodu,rvcdate                                                                                                   
     INTO g_rvc.rvcacti,g_rvc.rvcmodu,g_rvc.rvcdate FROM rvc_file                                                                   
    WHERE rvc01=g_rvc.rvc01 
      AND rvcplant = g_rvc.rvcplant
      AND rvc00 = g_rvc.rvc00
   DISPLAY BY NAME g_rvc.rvcacti,g_rvc.rvcmodu,g_rvc.rvcdate
END FUNCTION
 
FUNCTION t552_u()
 
   IF s_shut(0) THEN RETURN END IF
   IF g_rvc.rvc01 IS NULL OR g_rvc.rvcplant IS NULL THEN 
      CALL cl_err('',-400,2) RETURN 
   END IF
   SELECT * INTO g_rvc.* FROM rvc_file WHERE rvc00 = g_rvc.rvc00 AND rvc01 = g_rvc.rvc01 AND rvcplant = g_rvc.rvcplant
 
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
   OPEN t552_cl USING g_rvc.rvc00,g_rvc.rvc01,g_rvc.rvcplant
   FETCH t552_cl INTO g_rvc.*
   IF SQLCA.SQLCODE THEN
      CALL cl_err(g_rvc.rvc01,SQLCA.SQLCODE,0)
      CLOSE t552_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   CALL t552_show()
   WHILE TRUE
      LET g_rvc01_t = g_rvc.rvc01
      LET g_rvc.rvcmodu=g_user
      LET g_rvc.rvcdate=g_today
      CALL t552_i("u")
      IF INT_FLAG THEN
          LET INT_FLAG = 0
          LET g_rvc.*=g_rvc_t.*
          CALL t552_show()
          CALL cl_err('','9001',0)
          EXIT WHILE
      END IF
      UPDATE rvc_file SET rvc_file.* = g_rvc.* WHERE rvc00 = g_rvc.rvc00 AND rvc01 = g_rvc.rvc01 AND rvcplant = g_rvc.rvcplant
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("upd","rvc_file",g_rvc.rvc01,g_rvc.rvc02,SQLCA.SQLCODE,"","",1)  #No.FUN-660104
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE t552_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION t552_i(p_cmd)
   DEFINE p_cmd        LIKE type_file.chr1,
          l_n          LIKE type_file.num5,
          li_result    LIKE type_file.num5,
          l_azp02      LIKE azp_file.azp02,
          l_gen02      LIKE gen_file.gen02,
          l_pmc03      LIKE pmc_file.pmc03
          
   DISPLAY BY NAME
      g_rvc.rvc01,g_rvc.rvc02,g_rvc.rvc03,g_rvc.rvc04,g_rvc.rvc05,
      g_rvc.rvc06,g_rvc.rvcconf,g_rvc.rvccond,g_rvc.rvcconu,
      g_rvc.rvcplant,g_rvc.rvcuser,g_rvc.rvcmodu,g_rvc.rvcacti,
      g_rvc.rvcgrup,g_rvc.rvcdate,g_rvc.rvccrat
     ,g_rvc.rvcoriu,g_rvc.rvcorig       #TQC-A30041 ADD
   
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
           CALL t552_set_entry(p_cmd)
           CALL t552_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
           CALL cl_set_docno_format("rvc01")
           CALL cl_set_comp_entry("rvc02",FALSE)
 
       AFTER FIELD rvc01
           IF NOT cl_null(g_rvc.rvc01) THEN
              IF (p_cmd='a') OR (p_cmd='u' AND g_rvc.rvc01!=g_rvc_t.rvc01) THEN
#                CALL s_check_no("art",g_rvc.rvc01,g_rvc01_t,"O","rvc_file","rvc00,rvc01,rvcplant","") #FUN-A70130 mark
                 CALL s_check_no("art",g_rvc.rvc01,g_rvc01_t,"E5","rvc_file","rvc00,rvc01,rvcplant","") #FUN-A70130 mod
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
                 CALL t552_rvc03()
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
#               CALL q_smy(FALSE,FALSE,g_t1,'ART','O') RETURNING g_t1  #FUN-A70130--mark--
                CALL q_oay(FALSE,FALSE,g_t1,'E5','ART') RETURNING g_t1  #FUN-A70130--mod--
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
             EXIT INPUT
          END IF
          IF g_rvc.rvc04 > g_rvc.rvc05 THEN
             CALL cl_err('','art-501',0)
             NEXT FIELD rvc05
          END IF
 
   END INPUT
END FUNCTION
FUNCTION t552_rvc03()
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
FUNCTION t552_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_rvc.* TO NULL
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt
   CALL t552_cs()
   IF INT_FLAG OR g_action_choice="exit" THEN
      LET INT_FLAG = 0
      INITIALIZE g_rvc.* TO NULL
      CALL g_rvg.clear()
      CALL g_rve.clear()
      RETURN
   END IF
 
   MESSAGE " SEARCHING ! "
   OPEN t552_cs
   IF SQLCA.SQLCODE THEN
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_rvc.* TO NULL
   ELSE
      OPEN t552_count
      FETCH t552_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t552_fetch('F')
   END IF
   MESSAGE ""
END FUNCTION
 
FUNCTION t552_fetch(p_flag)
   DEFINE   p_flag   LIKE type_file.chr1,
            l_abso   LIKE type_file.num10
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t552_cs INTO g_rvc.rvc00,g_rvc.rvc01,g_rvc.rvcplant
      WHEN 'P' FETCH PREVIOUS t552_cs INTO g_rvc.rvc00,g_rvc.rvc01,g_rvc.rvcplant
      WHEN 'F' FETCH FIRST    t552_cs INTO g_rvc.rvc00,g_rvc.rvc01,g_rvc.rvcplant
      WHEN 'L' FETCH LAST     t552_cs INTO g_rvc.rvc00,g_rvc.rvc01,g_rvc.rvcplant
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
         FETCH ABSOLUTE g_jump t552_cs INTO g_rvc.rvc00,g_rvc.rvc01,g_rvc.rvcplant
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.SQLCODE THEN
      INITIALIZE g_rvc.* TO NULL
      CALL g_rvg.clear()
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
   SELECT * INTO g_rvc.* FROM rvc_file WHERE rvc00 = g_rvc.rvc00 AND rvc01 = g_rvc.rvc01 AND rvcplant = g_rvc.rvcplant
   IF SQLCA.SQLCODE THEN
      INITIALIZE g_rvc.* TO NULL
      CALL g_rvg.clear()
      CALL g_rve.clear()
      CALL cl_err3("sel","rvc_file",g_rvc.rvc01,g_rvc.rvc02,SQLCA.SQLCODE,"","",1)  #No.FUN-660104
      RETURN
   END IF
   LET g_data_owner = g_rvc.rvcuser    #TQC-BB0125 add
   LET g_data_group = g_rvc.rvcgrup    #TQC-BB0125 add
   LET g_data_plant = g_rvc.rvcplant #TQC-A10128 ADD 
   CALL t552_show()
END FUNCTION
 
FUNCTION t552_show()
   DEFINE l_odb02    LIKE odb_file.odb02
   DEFINE l_azp02    LIKE azp_file.azp02
   DEFINE l_gen02    LIKE gen_file.gen02
   DEFINE l_gem02    LIKE gem_file.gem02
   DEFINE l_pmc03    LIKE pmc_file.pmc03
 
   DISPLAY BY NAME g_rvc.rvcoriu,g_rvc.rvcorig,
      g_rvc.rvc01,g_rvc.rvc02,g_rvc.rvc03,g_rvc.rvc04,g_rvc.rvc05,
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
   CALL t552_b_fill(g_wc1)
   CALL t552_b2_fill(g_wc3)
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION t552_b()
DEFINE
   l_ac_t          LIKE type_file.num5,
   l_n             LIKE type_file.num5,
   l_qty           LIKE type_file.num10,
   l_lock_sw       LIKE type_file.chr1,
   p_cmd           LIKE type_file.chr1,
   l_allow_insert  LIKE type_file.num5,
   l_allow_delete  LIKE type_file.num5,
   l_cnt           LIKE type_file.num5
  
   LET g_b_flag = 1
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF g_rvc.rvc01 IS NULL OR g_rvc.rvcplant IS NULL 
      OR g_rvc.rvc00 IS NULL THEN 
      RETURN 
   END IF
   SELECT * INTO g_rvc.* FROM rvc_file
        WHERE rvc01=g_rvc.rvc01 
          AND rvcplant=g_rvc.rvcplant 
          AND rvc00=g_rvc.rvc00
          
   IF g_rvc.rvcacti = 'N' THEN CALL cl_err('','mfg1000',0) RETURN END IF     
   IF g_rvc.rvcconf='Y' THEN CALL cl_err('','art-046',0) RETURN END IF
	 IF g_rvc.rvcconf='X' THEN CALL cl_err('',9024,0) RETURN END IF
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT rvg02,rvg03,'',rvg04,rvg05,rvg06,",
                      " '','','','','','','','','',rvg07,rvg08 ",
                      "  FROM rvg_file ",
                      " WHERE rvg01=? AND rvg00= '",g_rvc.rvc00,"'",
                      "   AND rvg02=? AND rvgplant='",g_rvc.rvcplant,
                      "' FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t552_bc1 CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
   LET l_allow_insert = FALSE
   LET l_allow_delete = FALSE
 
   INPUT ARRAY g_rvg WITHOUT DEFAULTS FROM s_rvg.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
       BEFORE ROW
           LET p_cmd=''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN t552_cl USING g_rvc.rvc00,g_rvc.rvc01,g_rvc.rvcplant
           IF STATUS THEN
              CALL cl_err("OPEN t552_cl:", STATUS, 1)
              CLOSE t552_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t552_cl INTO g_rvc.*
           IF SQLCA.SQLCODE THEN
              CALL cl_err(g_rvc.rvc01,SQLCA.SQLCODE,0)
              CLOSE t552_cl
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b>=l_ac THEN
              LET p_cmd='u'
              LET g_rvg_t.* = g_rvg[l_ac].*  #BACKUP
              LET l_lock_sw = 'N'              #DEFAULT
              OPEN t552_bc1 USING g_rvc.rvc01,g_rvg_t.rvg02
              IF STATUS THEN
                 CALL cl_err("OPEN t552_bc1:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t552_bc1 INTO g_rvg[l_ac].*
                 IF SQLCA.SQLCODE THEN
                    CALL cl_err(g_rvg_t.rvg03,SQLCA.SQLCODE , 1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL t552_b_get_data()
              CALL cl_show_fld_cont()
              IF g_rvg[l_ac].rvg07 = 'Y' THEN
                 CALL cl_set_comp_entry("rvg08",TRUE)
              ELSE
                 CALL cl_set_comp_entry("rvg08",FALSE)
              END IF     
           END IF
 
       BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_rvg[l_ac].* TO NULL
           LET g_rvg_t.* = g_rvg[l_ac].*
           LET g_rvg[l_ac].rvg07 = 'Y'
           LET g_rvg[l_ac].rvg08 = g_rvg[l_ac].num_uncheck1
           CALL cl_show_fld_cont()
           NEXT FIELD rvg07
 
       AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO rvg_file(rvg00,rvg01,rvg02,rvg03,rvg04,rvg05,rvg06,rvg07,rvg08,rvgplant,rvglegal)
                         VALUES(g_rvc.rvc00,g_rvc.rvc01,g_rvg[l_ac].rvg02,g_rvg[l_ac].rvg03,
                                g_rvg[l_ac].rvg04,g_rvg[l_ac].rvg05,g_rvg[l_ac].rvg06,           
                                g_rvg[l_ac].rvg07,g_rvg[l_ac].rvg08,g_rvc.rvcplant,g_rvc.rvclegal)
                                
           IF SQLCA.SQLCODE THEN
              CALL cl_err3("ins","rvg_file",g_rvc.rvc01,g_rvc.rvcplant,SQLCA.SQLCODE,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1   
           END IF
 
       BEFORE FIELD rvg02
           IF g_rvg[l_ac].rvg02 IS NULL OR
              g_rvg[l_ac].rvg02 = 0 THEN
              SELECT max(rvg02)+1 INTO g_rvg[l_ac].rvg02
                FROM rvg_file
               WHERE rvg01 = g_rvc.rvc01 
                 AND rvg00 = g_rvc.rvc00
                 AND rvgplant=g_rvc.rvcplant
              IF g_rvg[l_ac].rvg02 IS NULL THEN
                 LET g_rvg[l_ac].rvg02 = 1
              END IF
           END IF
 
       AFTER FIELD rvg02
           IF NOT cl_null(g_rvg[l_ac].rvg02) THEN
              IF g_rvg[l_ac].rvg02 != g_rvg_t.rvg02 OR
                 g_rvg_t.rvg02 IS NULL THEN
                 SELECT count(*) INTO l_n
                   FROM rvg_file
                  WHERE rvg01 = g_rvc.rvc01 
                    AND rvg00 = g_rvc.rvc00
                    AND rvg02 = g_rvg[l_ac].rvg02
                    AND rvgplant=g_rvc.rvcplant
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_rvg[l_ac].rvg02 = g_rvg_t.rvg02
                    NEXT FIELD rvg02
                 END IF
              END IF
           END IF
       AFTER FIELD rvg07
          IF NOT cl_null(g_rvg[l_ac].rvg07) THEN
             IF g_rvg[l_ac].rvg07 != g_rvg_t.rvg07
                OR g_rvg_t.rvg07 IS NULL THEN
                IF g_rvg[l_ac].rvg07 = 'Y' THEN
                   LET g_rvg[l_ac].rvg08 = g_rvg[l_ac].num_uncheck1
                   CALL cl_set_comp_entry("rvg08",TRUE)
                ELSE
                   LET g_rvg[l_ac].rvg08 = 0
                   CALL cl_set_comp_entry("rvg08",FALSE)
                END IF    
             END IF
          END IF
 
       ON CHANGE rvg07
          IF g_rvg[l_ac].rvg07 = 'Y' THEN
             LET g_rvg[l_ac].rvg08 = g_rvg[l_ac].num_uncheck1
             CALL cl_set_comp_entry("rvg08",TRUE)
          ELSE
             LET g_rvg[l_ac].rvg08 = 0
             CALL cl_set_comp_entry("rvg08",FALSE)
          END IF    
 
       AFTER FIELD rvg08
          IF g_rvg[l_ac].rvg08 IS NOT NULL THEN
             IF g_rvg[l_ac].rvg08 > g_rvg[l_ac].num_uncheck1 THEN
                CALL cl_err('','art-505',0)
                NEXT FIELD rvg08
             END IF
          END IF
 
       ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rvg[l_ac].* = g_rvg_t.*
              CLOSE t552_bc1
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rvg[l_ac].rvg03,-263,1)
              LET g_rvg[l_ac].* = g_rvg_t.*
           ELSE
              UPDATE rvg_file SET rvg07 = g_rvg[l_ac].rvg07,
                                  rvg08 = g_rvg[l_ac].rvg08                                
               WHERE rvg01=g_rvc.rvc01 
                 AND rvg00=g_rvc.rvc00 
                 AND rvg02=g_rvg_t.rvg02
                 AND rvgplant= g_rvc.rvcplant
              IF SQLCA.SQLCODE THEN
                 CALL cl_err3("upd","rvg_file",g_rvc.rvc01,g_rvc.rvcplant,SQLCA.SQLCODE,"","",1)  #No.FUN-660104
                 LET g_rvg[l_ac].* = g_rvg_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
       AFTER ROW
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rvg[l_ac].* = g_rvg_t.*
              END IF
              CLOSE t552_bc1
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE t552_bc1
           COMMIT WORK
 
       ON ACTION CONTROLO
          IF INFIELD(rvg03) AND l_ac > 1 THEN
             LET g_rvg[l_ac].* = g_rvg[l_ac-1].*
             NEXT FIELD rvg03
          END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLF
          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
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
           AND rvcplant= g_rvc.rvcplant  
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("upd","rvc_file",g_rvc.rvc01,g_rvc.rvc02,SQLCA.SQLCODE,"","upd rvc",1)  #No.FUN-660104
      END IF
       DISPLAY BY NAME g_rvc.rvcmodu,g_rvc.rvcdate
   END IF
   CLOSE t552_bc1
   COMMIT WORK
END FUNCTION
#
FUNCTION t552_b_get_data()
DEFINE l_sum     LIKE ohb_file.ohb12
DEFINE l_dbs     LIKE azp_file.azp03

   #FUN-9C0075 ADD-------- 
   #SELECT azp02,azp03 INTO g_rvg[l_ac].rvg03_desc,l_dbs FROM azp_file
   #     WHERE azp01 = g_rvg[l_ac].rvg03
    SELECT azp02 INTO g_rvg[l_ac].rvg03_desc FROM azp_file
         WHERE azp01 = g_rvg[l_ac].rvg03
   #   LET g_plant_new =  g_rvg[g_cnt].rvg03 #FUN-B40031
       LET g_plant_new =  g_rvg[l_ac].rvg03  #FUN-B40031
       CALL s_gettrandbs()
       LET l_dbs=g_dbs_tra
       LET l_dbs = s_dbstring(l_dbs CLIPPED)
   #FUN-9C0075 END---- 
    IF g_rvg[l_ac].rvg04 = '1' THEN
       LET g_sql = "SELECT ogb04,ogb06,ogb05,ogb13,ogb12,ogb14,ogb14t ",
                  #" FROM ",l_dbs,"ogb_file ", #FUN-A50102
                  #" FROM ",cl_get_target_table(g_rvg[g_cnt].rvg03, 'ogb_file'), #FUN-A50102 #FUN-B40031
                   " FROM ",cl_get_target_table(g_rvg[l_ac].rvg03, 'ogb_file'),  #FUN-B40031
                   "  WHERE ogb01 = '",g_rvg[l_ac].rvg05,"'", 
                   "    AND ogb03 = '",g_rvg[l_ac].rvg06,"'",
           #        "    AND ogb930 = '",g_rvg[l_ac].rvg03,"'"                          #TQC-AC0417 mark
                    "    AND ogbplant = '",g_rvg[l_ac].rvg03,"'"                        #TQC-AC0417
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
      #CALL cl_parse_qry_sql(g_sql, g_rvg[g_cnt].rvg03) RETURNING g_sql  #FUN-A50102 #FUN-B40031
       CALL cl_parse_qry_sql(g_sql, g_rvg[l_ac].rvg03) RETURNING g_sql   #FUN-B40031
       PREPARE pre_get_ogb FROM g_sql
       EXECUTE pre_get_ogb INTO g_rvg[l_ac].ogb04_ohb04,g_rvg[l_ac].ogb06_ohb06,
                                g_rvg[l_ac].ogb05_ohb05,
                                g_rvg[l_ac].ogb13_ohb13,g_rvg[l_ac].ogb12_ohb12,
                                g_rvg[l_ac].ogb14_ohb14,g_rvg[l_ac].ogb14t_ohb14t
      ELSE
      	 LET g_sql = "SELECT ohb04,ohb06,ohb05,ohb13,ohb12,ohb14,ohb14t ",
                    #" FROM ",l_dbs,"ohb_file ", #FUN-A50102
                    #" FROM ",cl_get_target_table(g_rvg[g_cnt].rvg03, 'ohb_file'), #FUN-A50102 #FUN-B40031
                     " FROM ",cl_get_target_table(g_rvg[l_ac].rvg03, 'ohb_file'),  #FUN-B40031
                     " WHERE ohb01 = '",g_rvg[l_ac].rvg05,"'", 
                     "   AND ohb03 = '",g_rvg[l_ac].rvg06,"'",
           #          "   AND ohb930 = '",g_rvg[l_ac].rvg03,"'"                        #TQC-AC0417 mark
                     "   AND ohbplant = '",g_rvg[l_ac].rvg03,"'"                       #TQC-AC0417
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
        #CALL cl_parse_qry_sql(g_sql, g_rvg[g_cnt].rvg03) RETURNING g_sql  #FUN-A50102 #FUN-B40031
         CALL cl_parse_qry_sql(g_sql, g_rvg[l_ac].rvg03) RETURNING g_sql   #FUN-B40031
         PREPARE pre_get_ohb FROM g_sql
         EXECUTE pre_get_ohb INTO g_rvg[l_ac].ogb04_ohb04,g_rvg[l_ac].ogb06_ohb06,
                                  g_rvg[l_ac].ogb05_ohb05,
                                  g_rvg[l_ac].ogb13_ohb13,g_rvg[l_ac].ogb12_ohb12,
                                  g_rvg[l_ac].ogb14_ohb14,g_rvg[l_ac].ogb14t_ohb14t
      END IF
      #計算該單、項次已經對帳數量
      SELECT SUM(rvg08) INTO l_sum FROM rvg_file,rvc_file 
               WHERE rvc00 = rvg00
                 AND rvc01 = rvg01
                 AND rvcplant= rvgplant
                 AND rvcconf = 'Y'
                 AND rvg00 = g_rvc.rvc00
                 AND rvg05 = g_rvg[l_ac].rvg05 
                 AND rvg06 = g_rvg[l_ac].rvg06
                 AND rvgplant = g_rvg[l_ac].rvg03
 
      IF l_sum IS NULL THEN LET l_sum = 0 END IF
      LET g_rvg[l_ac].num_uncheck1 = g_rvg[l_ac].ogb12_ohb12 - l_sum 
 
      SELECT gfe02 INTO g_rvg[l_ac].ogb05_desc 
         FROM gfe_file
         WHERE gfe01 = g_rvg[l_ac].ogb05_ohb05
END FUNCTION
 
FUNCTION t552_b2()
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
   IF g_rvc.rvcacti = 'N' THEN CALL cl_err('','mfg1000',0) RETURN END IF     
   IF g_rvc.rvcconf='X' THEN CALL cl_err('',9024,0) RETURN END IF
   
   CALL cl_opmsg('b')
 
 # LET g_forupd_sql = "SELECT rve02,rve03,'',rve04,rve05,",        #TQC-AC0136 MARK
 # LET g_forupd_sql = "SELECT rve02,rve03,'',rve04,'','',rve05,",  #TQC-AC0136 ADD 
   LET g_forupd_sql = "SELECT rve02,rve03,'',rve04,rve05,'','',",  #FUN-BC0124 add 
                     # "'','','','','',rve06 ",   #FUN-A80105
                      "'','','','',rve06 ",       #FUN-A80105                
                      "  FROM rve_file ",
                      " WHERE rve01=? AND rve00='",g_rvc.rvc00,"'",
                      "   AND rve02=? AND rveplant='",g_rvc.rvcplant,"'",
                      "   FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t552_bc3 CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
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
 
           OPEN t552_cl USING g_rvc.rvc00,g_rvc.rvc01,g_rvc.rvcplant
           IF STATUS THEN
              CALL cl_err("OPEN t552_cl:", STATUS, 1)
              CLOSE t552_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t552_cl INTO g_rvc.*
           IF SQLCA.SQLCODE THEN
              CALL cl_err(g_rvc.rvc01,SQLCA.SQLCODE,0)
              CLOSE t552_cl
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b2>=l_ac2 THEN
              LET p_cmd='u'
              LET g_rve_t.* = g_rve[l_ac2].*   #BACKUP
              LET l_lock_sw = 'N'              #DEFAULT
              OPEN t552_bc3 USING g_rvc.rvc01,g_rve_t.rve02
              IF STATUS THEN
                 CALL cl_err("OPEN t552_bc3:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t552_bc3 INTO g_rve[l_ac2].*
                 IF SQLCA.SQLCODE THEN
                    CALL cl_err(g_rve_t.rve02,SQLCA.SQLCODE , 1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL t552_b2_get_data()
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
              CLOSE t552_bc3
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
                 AND rveplant= g_rvc.rvcplant
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
              CLOSE t552_bc3
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE t552_bc3
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
           AND rvcplant = g_rvc.rvcplant
           AND rvc00 = g_rvc.rvc00
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("upd","rvc_file",g_rvc.rvc01,g_rvc.rvcplant,SQLCA.SQLCODE,"","upd rvc",1)  #No.FUN-660104
      END IF
      DISPLAY BY NAME g_rvc.rvcmodu,g_rvc.rvcdate
   END IF
   CLOSE t552_bc3
   COMMIT WORK
END FUNCTION
FUNCTION t552_b2_get_data()
DEFINE l_sql   STRING    #TQC-AC0136 ADD

   SELECT azp02 INTO g_rve[l_ac2].rve03_desc              #TQC-AC0136 ADD
     FROM azp_file WHERE azp01 = g_rve[l_ac2].rve03       #TQC-AC0136 ADD
  #FUN-B40031 Begin---
  ##TQC-AC0136 add -begin----------------------
  #LET l_sql = "SELECT lua02,lua24,lub03,lub04,lub04t ",
  #            "  FROM ",cl_get_target_table(g_rve[g_cnt].rve03, 'lua_file'),
  #            "      ,",cl_get_target_table(g_rve[g_cnt].rve03, 'lub_file'),
  #            " WHERE lua01 = '",g_rve[g_cnt].rve04,"'",
  #            "   AND lua01 = lub01 AND lub02 = '",g_rve[g_cnt].rve05,"'"
  #CALL cl_replace_sqldb(l_sql) RETURNING l_sql
  #CALL cl_parse_qry_sql(l_sql, g_rve[g_cnt].rve03) RETURNING l_sql
  #PREPARE pre_sel_lua1 FROM l_sql
  #EXECUTE pre_sel_lua1 INTO g_rve[g_cnt].lua02,g_rve[g_cnt].lua24,
  #                         g_rve[g_cnt].lub03,g_rve[g_cnt].lub04,
  #                         g_rve[g_cnt].lub04t

  #LET l_sql = "SELECT oaj02 FROM ",cl_get_target_table(g_rve[g_cnt].rve03, 'oaj_file'),
  #               " WHERE oaj01 = '",g_rve[g_cnt].lub03,"'"
  #   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
  #   CALL cl_parse_qry_sql(l_sql, g_rve[g_cnt].rve03) RETURNING l_sql
  #   PREPARE pre_sel_oaj1 FROM l_sql
  #   EXECUTE pre_sel_oaj1 INTO g_rve[g_cnt].oaj02
  ##TQC-AC0136 add --end-----------------------

  #LET l_sql = "SELECT lua02,lua24,lub03,lub04,lub04t ",
   LET l_sql = "SELECT lub09,lub14,lub03,lub04,lub04t ",  #FUN-BC0124 lua02,lua24-->lub09,lub14
               "  FROM ",cl_get_target_table(g_rve[l_ac2].rve03, 'lua_file'),
               "      ,",cl_get_target_table(g_rve[l_ac2].rve03, 'lub_file'),
               " WHERE lua01 = '",g_rve[l_ac2].rve04,"'",
               "   AND lua01 = lub01 AND lub02 = '",g_rve[l_ac2].rve05,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql, g_rve[l_ac2].rve03) RETURNING l_sql
   PREPARE pre_sel_lua1 FROM l_sql
  #EXECUTE pre_sel_lua1 INTO g_rve[l_ac2].lua02,g_rve[l_ac2].lua24,
   EXECUTE pre_sel_lua1 INTO g_rve[l_ac2].lub09,g_rve[l_ac2].lub14,   #FUN-BC0124 lua02,lua24-->lub09,lub14
                             g_rve[l_ac2].lub03,g_rve[l_ac2].lub04,
                             g_rve[l_ac2].lub04t

   LET l_sql = "SELECT oaj02 FROM ",cl_get_target_table(g_rve[l_ac2].rve03, 'oaj_file'),
                  " WHERE oaj01 = '",g_rve[l_ac2].lub03,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, g_rve[l_ac2].rve03) RETURNING l_sql
      PREPARE pre_sel_oaj1 FROM l_sql
      EXECUTE pre_sel_oaj1 INTO g_rve[l_ac2].oaj02
  #FUN-B40031 End-----

END FUNCTION
FUNCTION t552_b_fill(p_wc)
DEFINE l_sql   STRING
DEFINE p_wc    STRING   
DEFINE l_sum     LIKE ohb_file.ohb12
DEFINE l_dbs     LIKE azp_file.azp03
 
   LET l_sql = "SELECT rvg02,rvg03,'',rvg04,rvg05,rvg06,",
               "'','','','','','','','','',rvg07,rvg08 ",
               "  FROM rvg_file ",
               "WHERE rvg01 = '",g_rvc.rvc01,"'",
               " AND rvg00 ='",g_rvc.rvc00,"'",
               " AND rvgplant='",g_rvc.rvcplant,"'"
               
   IF NOT cl_null(p_wc) THEN
      LET l_sql = l_sql," AND ",p_wc," ORDER BY rvg03"
   ELSE
      LET l_sql = l_sql," ORDER BY rvg02"
   END IF
   DECLARE t552_cr1 CURSOR FROM l_sql
   CALL g_rvg.clear()
 
   LET g_rec_b = 0
   LET g_cnt = 1
   FOREACH t552_cr1 INTO g_rvg[g_cnt].*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF
     #FUN-9C0075 ADD---------------------- 
    # SELECT azp02,azp03 INTO g_rvg[g_cnt].rvg03_desc,l_dbs FROM azp_file 
    #    WHERE azp01 = g_rvg[g_cnt].rvg03
      SELECT azp02 INTO g_rvg[g_cnt].rvg03_desc FROM azp_file
         WHERE azp01 = g_rvg[g_cnt].rvg03
       LET g_plant_new =  g_rvg[g_cnt].rvg03
       CALL s_gettrandbs()
       LET l_dbs=g_dbs_tra
    #FUN-9C0075 END-------------------
      LET l_dbs = s_dbstring(l_dbs CLIPPED)
      IF g_rvg[g_cnt].rvg04 = '1' THEN
         LET g_sql = "SELECT ogb04,ogb06,ogb05,ogb13,ogb12,ogb14,ogb14t ",
                    #" FROM ",l_dbs,"ogb_file ", #FUN-A50102
                     " FROM ",cl_get_target_table(g_rvg[g_cnt].rvg03, 'ogb_file'), #FUN-A50102
                     "  WHERE ogb01 = '",g_rvg[g_cnt].rvg05,"'", 
                     "    AND ogb03 = '",g_rvg[g_cnt].rvg06,"'",
    #                 "    AND ogb930 = '",g_rvg[g_cnt].rvg03,"'"                  #TQC-AC0417 mark
                     "    AND ogbplant = '",g_rvg[g_cnt].rvg03,"'"                 #TQC-AC0417
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
         CALL cl_parse_qry_sql(g_sql, g_rvg[g_cnt].rvg03) RETURNING g_sql  #FUN-A50102            
         PREPARE pre_get_ogb1 FROM g_sql
         EXECUTE pre_get_ogb1 INTO g_rvg[g_cnt].ogb04_ohb04,g_rvg[g_cnt].ogb06_ohb06,
                                   g_rvg[g_cnt].ogb05_ohb05,
                                   g_rvg[g_cnt].ogb13_ohb13,g_rvg[g_cnt].ogb12_ohb12,
                                   g_rvg[g_cnt].ogb14_ohb14,g_rvg[g_cnt].ogb14t_ohb14t
      ELSE
      	 LET g_sql = "SELECT ohb04,ohb06,ohb05,ohb13,ohb12,ohb14,ohb14t ",
                    #" FROM ",l_dbs,"ohb_file ", #FUN-A50102
                     " FROM ",cl_get_target_table(g_rvg[g_cnt].rvg03, 'ohb_file'), #FUN-A50102
                     "  WHERE ohb01 = '",g_rvg[g_cnt].rvg05,"'", 
                     "    AND ohb03 = '",g_rvg[g_cnt].rvg06,"'",
    #                 "    AND ohb930 = '",g_rvg[g_cnt].rvg03,"'"                   #TQC-AC0417 mark
                     "    AND ohbplant = '",g_rvg[g_cnt].rvg03,"'"                  #TQC-AC0417
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
         CALL cl_parse_qry_sql(g_sql, g_rvg[g_cnt].rvg03) RETURNING g_sql  #FUN-A50102            
         PREPARE pre_get_ohb1 FROM g_sql
         EXECUTE pre_get_ohb1 INTO g_rvg[g_cnt].ogb04_ohb04,g_rvg[g_cnt].ogb06_ohb06,
                                   g_rvg[g_cnt].ogb05_ohb05,
                                   g_rvg[g_cnt].ogb13_ohb13,g_rvg[g_cnt].ogb12_ohb12,
                                   g_rvg[g_cnt].ogb14_ohb14,g_rvg[g_cnt].ogb14t_ohb14t
      END IF
      
      #
      SELECT SUM(rvg08) INTO l_sum FROM rvg_file,rvc_file 
               WHERE rvc00 = rvg00
                 AND rvc01 = rvg01
                 AND rvcplant= rvgplant
                 AND rvcconf = 'Y'
                 AND rvg00 = g_rvc.rvc00
                 AND rvg05 = g_rvg[g_cnt].rvg05 
                 AND rvg06 = g_rvg[g_cnt].rvg06
                 AND rvgplant = g_rvg[g_cnt].rvg03
 
      IF l_sum IS NULL THEN LET l_sum = 0 END IF
      LET g_rvg[g_cnt].num_uncheck1 = g_rvg[g_cnt].ogb12_ohb12 - l_sum
 
      SELECT gfe02 INTO g_rvg[g_cnt].ogb05_desc 
         FROM gfe_file
         WHERE gfe01 = g_rvg[g_cnt].ogb05_ohb05
         
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_rvg.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
 
   LET g_cnt = 0
   CLOSE t552_cr1
   CALL t552_bp_refresh()
END FUNCTION
 
FUNCTION t552_bp_refresh()
  DISPLAY ARRAY g_rvg TO s_rvg.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
END FUNCTION
 
FUNCTION t552_b2_fill(p_wc)
DEFINE l_sql,p_wc        STRING
DEFINE l_dbs     LIKE azp_file.azp03           #TQC-AC0136 add
DEFINE l_rvd03   LIKE rvd_file.rvd03           #TQC-AC0136 add
 
 # LET l_sql = "SELECT rve02,rve03,'',rve04,rve05,'','', ",         #TQC-AC0136 MARK
 # LET l_sql = "SELECT rve02,rve03,'',rve04,'','',rve05,'','',",    #TQC-AC0136 ADD
   LET l_sql = "SELECT rve02,rve03,'',rve04,rve05,'','','','',",    #FUN-BC0124 add
              # " '','','',rve06 ",     #FUN-A80105
               " '','',rve06 ",         #FUN-A80105      
               " FROM rve_file ",       #TQC-AC0136 ADD
      #        " WHERE rve01 = '",g_rvc.rvc01,"' AND rve00 ='2'",  #TQC-AC0136 MARK
              #" WHERE rve01 = '",g_rvc.rvc01,"' AND rve00 ='3'",  #TQC-AC0136 ADD
               " WHERE rve01 = '",g_rvc.rvc01,"' AND rve00 ='4'",  #FUN-B40031
               "   AND rveplant='",g_rvc.rvcplant,"'"
               
   IF NOT cl_null(p_wc) THEN
      LET l_sql = l_sql," AND ",p_wc," ORDER BY rve02"
   ELSE
      LET l_sql = l_sql," ORDER BY rve02"
   END IF
   DECLARE t552_cr3 CURSOR FROM l_sql
 
   CALL g_rve.clear()
   LET g_rec_b2 = 0
 
   LET g_cnt = 1
   FOREACH t552_cr3 INTO g_rve[g_cnt].*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF
#TQC-AC0136 mark -begin--------------------
#     SELECT lub03,lub04,lub04t 
#         INTO g_rve[g_cnt].lub03,g_rve[g_cnt].lub04,
#              g_rve[g_cnt].lub04t 
#         FROM lub_file
#        WHERE lub01 = g_rve[g_cnt].rve04
#          AND lub02 = g_rve[g_cnt].rve05
#TQC-AC0136 mark -end--------------------
#      SELECT oaj02,oaj06                                #FUN-A80105
#        INTO g_rve[g_cnt].oaj02,g_rve[g_cnt].oaj06      #FUN-A80105
#TQC-AC0136 mark -begin--------------------
#     SELECT oaj02                              #FUN-A80105
#       INTO g_rve[g_cnt].oaj02                 #FUN-A80105
#       FROM oaj_file 
#       WHERE oaj01 = g_rve[g_cnt].lub03
#TQC-AC0136 mark -end--------------------
      SELECT azp02 INTO g_rve[g_cnt].rve03_desc
         FROM azp_file WHERE azp01 = g_rve[g_cnt].rve03  

#TQC-AC0136 add-begin--------------------
     #LET l_sql = "SELECT lua02,lua24,lub03,lub04,lub04t ",
      LET l_sql = "SELECT lub09,lub14,lub03,lub04,lub04t ",   #FUN-BC0124 lua02,lua24-->lub09,lub14
                  "  FROM ",cl_get_target_table(g_rve[g_cnt].rve03, 'lua_file'),
                  "      ,",cl_get_target_table(g_rve[g_cnt].rve03, 'lub_file'),
                  " WHERE lua01 = '",g_rve[g_cnt].rve04,"'",
                  "   AND lua01 = lub01 AND lub02 = '",g_rve[g_cnt].rve05,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, g_rve[g_cnt].rve03) RETURNING l_sql
      PREPARE pre_sel_lua FROM l_sql
     #EXECUTE pre_sel_lua INTO g_rve[g_cnt].lua02,g_rve[g_cnt].lua24,
      EXECUTE pre_sel_lua INTO g_rve[g_cnt].lub09,g_rve[g_cnt].lub14,  #FUN-BC0124 lua02,lua24-->lub09,lub14
                               g_rve[g_cnt].lub03,g_rve[g_cnt].lub04,
                               g_rve[g_cnt].lub04t

      LET l_sql = "SELECT oaj02 FROM ",cl_get_target_table(g_rve[g_cnt].rve03, 'oaj_file'),
                  " WHERE oaj01 = '",g_rve[g_cnt].lub03,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, g_rve[g_cnt].rve03) RETURNING l_sql
      PREPARE pre_sel_oaj FROM l_sql
      EXECUTE pre_sel_oaj INTO g_rve[g_cnt].oaj02
#TQC-AC0136 add-end--------------------
      LET g_cnt=g_cnt+1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_rve.deleteElement(g_cnt)
   LET g_rec_b2 = g_cnt - 1
   LET g_cnt = 1
 
   CLOSE t552_cr3
   CALL t552_bp2_refresh()
END FUNCTION
 
FUNCTION t552_bp2_refresh()
  DISPLAY ARRAY g_rve TO s_rve.* ATTRIBUTE(COUNT = g_rec_b2,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
END FUNCTION
 
FUNCTION t552_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rvg TO s_rvg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         IF l_ac != 0 THEN
            CALL t552_b_fill(g_wc1)
            CALL t552_bp_refresh()
         END IF
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
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
   
      ON ACTION invalid
         LET g_action_choice="invalid"                                                                                              
         EXIT DISPLAY
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'                                                                                      
         EXIT DISPLAY
 
      ON ACTION output    
         LET g_action_choice="output"                                                                                               
         EXIT DISPLAY
 
      ON ACTION first
         CALL t552_fetch('F')
         EXIT DISPLAY
 
      ON ACTION previous
         CALL t552_fetch('P')
         EXIT DISPLAY
 
      ON ACTION jump
         CALL t552_fetch('/')
         EXIT DISPLAY
 
      ON ACTION next
         CALL t552_fetch('N')
         EXIT DISPLAY
 
      ON ACTION last
         CALL t552_fetch('L')
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CALL cl_set_field_pic(g_rvc.rvcconf,"","","","","")
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
     
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
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
 
      ON ACTION scale
         LET g_b_flag = '1'
         LET g_action_choice = "scale"
         EXIT DISPLAY
 
      ON ACTION feiyong 
         LET g_b_flag ='3'
         LET g_action_choice = "feiyong"
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
 
FUNCTION t552_bp2(p_ud)
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
 
      ON ACTION output                                                                                                              
         LET g_action_choice="output"                                                                                               
         EXIT DISPLAY
 
      ON ACTION first
         CALL t552_fetch('F')
         EXIT DISPLAY
 
      ON ACTION previous
         CALL t552_fetch('P')
         EXIT DISPLAY
 
      ON ACTION jump
         CALL t552_fetch('/')
         EXIT DISPLAY
 
      ON ACTION next
         CALL t552_fetch('N')
         EXIT DISPLAY
 
      ON ACTION last
         CALL t552_fetch('L')
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
      ON ACTION scale
         LET g_b_flag = '1'
         LET g_action_choice = "scale"
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
 
FUNCTION t552_r()
   DEFINE l_cnt    LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
   IF g_rvc.rvc01 IS NULL OR g_rvc.rvcplant IS NULL 
      OR g_rvc.rvc00 IS NULL THEN 
      CALL cl_err('',-400,2) 
      RETURN 
   END IF
   SELECT * INTO g_rvc.* FROM rvc_file WHERE rvc00 = g_rvc.rvc00 AND rvc01 = g_rvc.rvc01 AND rvcplant = g_rvc.rvcplant
   IF g_rvc.rvcconf='Y' THEN CALL cl_err('','9023',0) RETURN END IF
   IF g_rvc.rvcconf='X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF g_rvc.rvcacti='N' THEN CALL cl_err('','aic-201',0) RETURN END IF
 
   LET g_success = 'Y'
   BEGIN WORK
   OPEN t552_cl USING g_rvc.rvc00,g_rvc.rvc01,g_rvc.rvcplant
   FETCH t552_cl INTO g_rvc.*
   IF SQLCA.SQLCODE THEN
      CALL cl_err(g_rvc.rvc01,SQLCA.SQLCODE,0)
      CLOSE t552_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   LET g_rvc_t.* = g_rvc.*
   CALL t552_show()
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
           AND rvcplant=g_rvc.rvcplant
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","rvg_file",g_rvc.rvc01,g_rvc.rvcplant,SQLCA.SQLCODE,"","(t552_r:delete rvg)",1)
         LET g_success='N'
      END IF
      
      DELETE FROM rvg_file 
         WHERE rvg01 = g_rvc.rvc01 
           AND rvgplant = g_rvc.rvcplant
           AND rvg00 = g_rvc.rvc00
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","rvg_file",g_rvc.rvc01,g_rvc.rvcplant,SQLCA.SQLCODE,"","(t552_r:delete rvg)",1)
         LET g_success='N'
      END IF
 
      DELETE FROM rve_file WHERE rve00 = g_rvc.rvc00 
          AND rve01 = g_rvc.rvc01 AND rveplant = g_rvc.rvcplant
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","rve_file",g_rvc.rvc01,g_rvc.rvcplant,SQLCA.SQLCODE,"","(t552_r:delete rve)",1)  #No.FUN-660104
         LET g_success='N'
      END IF
      DELETE FROM rvd_file WHERE rvd00 = g_rvc.rvc00
          AND rvd01 = g_rvc.rvc01 AND rvdplant = g_rvc.rvcplant
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","rvd_file",g_rvc.rvc01,g_rvc.rvcplant,SQLCA.SQLCODE,"","(t552_r:delete rvd)",1)  #No.FUN-660104
         LET g_success='N'
      END IF
 
      INITIALIZE g_rvc.* TO NULL
      IF g_success = 'Y' THEN
         COMMIT WORK
         CLEAR FORM             #TQC-C50164 add
         LET g_rvc_t.* = g_rvc.*
         CALL g_rvg.clear()
         CALL g_rve.clear()
         OPEN t552_count
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE t552_cs
            CLOSE t552_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         FETCH t552_count INTO g_row_count
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t552_cs
            CLOSE t552_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t552_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t552_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t552_fetch('/')
         END IF
      ELSE
         ROLLBACK WORK
         LET g_rvc.* = g_rvc_t.*
      END IF
   END IF
   CALL t552_show()
END FUNCTION
 
FUNCTION t552_out()
 
END FUNCTION
 
FUNCTION t552_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("rvc01,rvc02,rvc03,rvc04,rvc05",TRUE)
   END IF
END FUNCTION
 
FUNCTION t552_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("rvc01,rvc02,rvc03,rvc04,rvc05",FALSE)
   END IF
END FUNCTION
 

