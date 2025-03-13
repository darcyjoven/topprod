# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: artt551.4gl
# Descriptions...: 成本代銷供應商對帳單
# Date & Author..: NO:FUN-960130 08/10/28 BY Sunyanchun
# Modify.........: No:FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO:TQC-9B0016 09/11/04 By liuxqa rowid修改。
# Modify.........: NO:FUN-9B0068 09/11/10 BY lilingyu 臨時表字段改成LIKE的形式
# Modify.........: NO:FUN-9B0025 09/12/07 By cockroach 修改rvd03的判斷
# Modify.........: No:FUN-9C0075 09/12/16 By cockroach xxx930-->xxxplant
#                                                      无单身资料带出时取消插入rvd_file的数据
# Modify.........: No:FUN-9C0133 09/12/24 By Cockroach rvv03取消4,5判斷，直接插入
# Modify.........: No:FUN-9C0163 09/12/29 By Cockroach 程序查詢DOWN出去
# Modify.........: No:FUN-A10008 10/01/06 By Cockroach 錄入報錯
# Modify.........: No:TQC-A10058 10/01/08 By Cockroach 審核報錯
# Modify.........: No:FUN-A10036 10/01/13 By baofei 手動修改INSERT INTO xxx_file ，增加xxx_file xxxoriu, xxxorig這二個欄位
# Modify.........: No:TQC-A10128 10/01/18 By Cockroach 添加g_data_plant管控
# Modify.........: No:FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:TQC-A30030 10/03/12 By Cockroach BUG處理
# Modify.........: No:TQC-A30041 10/03/16 By Cockrocah add oriu/orig
# Modify.........: No:FUN-A50102 10/06/10 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-A70130 10/08/06 By shaoyong  ART單據性質調整
# Modify.........: No:FUN-A70130 10/08/11 By huangtao 修改q_oay*()的參數,q_smy改为q_oay
# Modify.........: No:FUN-A80105 10/08/24 By lixh1   MARK 掉 oaj06 程式碼
# Modify.........: No:TQC-AC0138 10/12/15 By suncx 代銷供應商對賬單單身產生異常    
# Modify.........: No:TQC-AC0416 11/01/06 By huangtao 費用對賬抓取是根據費用單的單據日期抓取
# Modify.........: No:TQC-B10045 11/01/07 By shiwuying 审核判断费用对账
# Modify.........: No:MOD-B50066 11/05/09 By Summer 取消結束日的控管,另外加入結束日不允許早於對帳開始日的控管
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:TQC-B60065 11/06/15 By shiwuying 扣率代銷抓虛擬類型rvu27='2'的入庫單
# Modify.........: No:TQC-B60163 11/06/20 By yangxf mark掉對賬營運中心的查詢action
# Modify.........: No:TQC-B60250 11/06/20 By shiwuying 銷售對賬時計算未對賬數量排除作廢的單據
# Modify.........: No:FUN-B60150 11/06/28 By shiwuying 成本代销改善
# Modify.........: No:FUN-B60150 11/06/28 By baogc 成本代销改善
# Modify.........: No:FUN-B70074 11/07/20 By fengrui 添加行業別表的新增於刪除
# Modify.........: No.FUN-B80085 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外 
# Modify.........: No:TQC-BB0125 11/11/24 pauline 控卡user,group
# Modify.........: No:FUN-BB0084 11/11/25 lixh1增加數量欄位小數取位
# MOdify.........: No.FUN-BB0085 11/11/28 xianghui 增加數量欄位小數取位
# Modify.........: No:FUN-BC0124 11/12/28 By suncx 由於費用單結構調整，調整抓取費用單對應欄位,調整的欄位費用類型、財務單號

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:TQC-C50164 12/05/21 by fanbj 刪除後單頭資料沒有清空
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No.TQC-C80151 12/08/24 By yangxf 對賬營運中心控管與開窗不符
# Modify.........: No:FUN-C90049 12/10/19 By Lori 預設成本倉與非成本倉改從s_get_defstore取
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
#                         lua02        LIKE lua_file.lua02,     #TQC-AC0138 ADD #FUN-BC0124 mark
#                         lua24        LIKE lua_file.lua24,     #TQC-AC0138 ADD #FUN-BC0124 mark
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
#                         lua02        LIKE lua_file.lua02,     #TQC-AC0138 ADD #FUN-BC0124 mark
#                         lua24        LIKE lua_file.lua24,     #TQC-AC0138 ADD #FUN-BC0124 mark
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
 
 
  #LET g_forupd_sql= " SELECT * FROM rvc_file WHERE rvc00 = ? AND rcv01 = ? FOR UPDATE  "  #FUN-A10008 MARK
   LET g_forupd_sql= " SELECT * FROM rvc_file WHERE rvc00 = ? AND rvc01 = ? FOR UPDATE  "  #FUN-A10008 ADD
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t551_cl CURSOR FROM g_forupd_sql
 
   LET g_b_flag = '1'
 
   LET p_row = 2  LET p_col = 9 
   OPEN WINDOW t551_w AT p_row,p_col WITH FORM "art/42f/artt551"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   IF (NOT cl_null(g_argv1)) AND (NOT cl_null(g_argv2)) THEN
      CALL t551_q()
   END IF   
 
   CALL t551_menu()
   CLOSE WINDOW t551_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t551_cs()
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
      CONSTRUCT BY NAME g_wc ON
                rvc01,rvc02,rvc03,rvc04,rvc05,rvc06,
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
                    LET g_qryparam.form = "q_rvc01"
                    LET g_qryparam.default1 = g_rvc.rvc01
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rvc01
                    NEXT FIELD rvc01
                    
                 WHEN INFIELD(rvc03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_rvc03"
                    LET g_qryparam.default1 = g_rvc.rvc03
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rvc03
                    NEXT FIELD rvc03
                      
                 WHEN INFIELD(rvcconu)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form = "q_rvcconu"
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
                      LET g_qryparam.form     = "q_rvg03"
                      LET g_qryparam.default1 = g_rvg[1].rvg03
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO rvg03
                      NEXT FIELD rvg03
                      
                 WHEN INFIELD(rvg05)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.form     = "q_rvg05"
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
                      LET g_qryparam.form     = "q_rvf03"
                      LET g_qryparam.default1 = g_rvf[1].rvf03
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO rvf03
                      NEXT FIELD rvf03
                  WHEN INFIELD(rvf05)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.form     = "q_rvf05"
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
                      LET g_qryparam.form     = "q_rve03_1"
                      LET g_qryparam.default1 = g_rve[1].rve03
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO rve03
                      NEXT FIELD rve03
                      
                 WHEN INFIELD(rve04)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.form     = "q_rve04_1"
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
   IF g_wc1 <> " 1=1" THEN
      LET l_table = l_table,",rvg_file" 
      LET l_where = l_where," AND rvg00 = rvc00 AND rvg01 = rvc01 AND ",g_wc1
   END IF
   IF g_wc2 <> " 1=1" THEN
      LET l_table = l_table,",rvf_file"
      LET l_where = l_where," AND rvf00 = rvc00 AND rvf01 = rvc01 AND ",g_wc2
   END IF
   IF g_wc3 <> " 1=1" THEN 
      LET l_table = l_table,",rve_file" 
      LET l_where = l_where," AND rve00 = rvc00 AND rve01 = rvc01 AND ",g_wc3
   END IF
   LET l_where = l_where," AND rvc00 ='2' AND (rvc02 = '2' OR rvc02 = '3') "
   LET g_sql = g_sql,l_table,l_where
   PREPARE t551_prepare FROM g_sql
   DECLARE t551_cs SCROLL CURSOR WITH HOLD FOR t551_prepare
 
   LET g_sql = "SELECT COUNT(DISTINCT rvc00||rvc01) ",l_table,l_where
   PREPARE t551_precount FROM g_sql
   DECLARE t551_count CURSOR FOR t551_precount
END FUNCTION
 
FUNCTION t551_menu()
 
   WHILE TRUE
      IF g_action_choice = "exit"  THEN
         EXIT WHILE
      END IF
 
      CASE g_b_flag
         WHEN '1'
            CALL t551_bp("G")
            CALL t551_b_fill(g_wc1)
         WHEN '2'
            CALL t551_bp1("G")
            CALL t551_b1_fill(g_wc2)
         WHEN '3'
            CALL t551_bp2("G")
            CALL t551_b2_fill(g_wc3)
      END CASE
 
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t551_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t551_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t551_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t551_u()
            END IF
 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t551_copy()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
                  IF g_b_flag = 1 THEN
                     CALL t551_b()
                  END IF
                  IF g_b_flag = 2 THEN
                     CALL t551_b1()
                  END IF
                  IF g_b_flag = 3 THEN
                     CALL t551_b2()
                  END IF
            END IF
 
         WHEN "invalid"                                                                                                             
            IF cl_chk_act_auth() THEN           
               CALL t551_x()  
            END IF
 
         WHEN "exporttoexcel"                                                                                                       
            IF cl_chk_act_auth() THEN                                                                                               
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rvc),'','')                                 
            END IF
 
         WHEN "output"                                                                                                              
            IF cl_chk_act_auth() THEN                                                                                               
               CALL t551_out()                                                                                                      
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "confirm"                                                                                                             
            IF cl_chk_act_auth() THEN            
               CALL t551_yes()
            END IF                                                                                                                  
                                                                                                                                    
         WHEN "void"                                                                                                                 
            IF cl_chk_act_auth() THEN     
               CALL t551_void(1) 
            END IF
  
         #FUN-D20039 ---------sta
         WHEN "undo_void"                                        
            IF cl_chk_act_auth() THEN     
               CALL t551_void(2)         
            END IF    
         #FUN-D20039 ---------end

         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "curr_plant"
            IF cl_chk_act_auth() THEN     
               CALL t551_org() 
            END IF
            
         WHEN "sell"
            LET g_b_flag = "1"
            CALL t551_b_fill(g_wc1)        
            CALL t551_bp_refresh()
 
         WHEN "in_store"
            LET g_b_flag = "2"
            CALL t551_b1_fill(g_wc2) 
            CALL t551_bp1_refresh()       
 
         WHEN "feiyong"
            LET g_b_flag = "3"
            CALL t551_b2_fill(g_wc3)            
            CALL t551_bp2_refresh()
 
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
FUNCTION t551_void(p_type)
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
 
   OPEN t551_cl USING g_rvc.rvc00,g_rvc.rvc01
   IF STATUS THEN
      CALL cl_err("OPEN t551_cl:", STATUS, 1)
      CLOSE t551_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t551_cl INTO g_rvc.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rvc.rvc01,SQLCA.sqlcode,0)
      CLOSE t551_cl
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
 
   CLOSE t551_cl
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
FUNCTION t551_check_number()
DEFINE l_i     LIKE type_file.num5
 
    FOR l_i = 1 TO g_rvg.getLength()
       IF g_rvg[l_i].rvg02 IS NULL THEN
          CONTINUE FOR
       END IF
       IF g_rvg[l_i].num_uncheck1 < g_rvg[l_i].rvg08 THEN
          RETURN 0
       END IF
    END FOR
    FOR l_i = 1 TO g_rvf.getLength()
       IF g_rvf[l_i].rvf02 IS NULL THEN
          CONTINUE FOR
       END IF
       IF g_rvf[l_i].num_uncheck < g_rvf[l_i].rvf08 THEN
          RETURN 0
       END IF
    END FOR
    RETURN 1
END FUNCTION
FUNCTION t551_check()
DEFINE l_rvg03       LIKE rvg_file.rvg03
DEFINE l_rvg04       LIKE rvg_file.rvg04
DEFINE l_rvg05       LIKE rvg_file.rvg05
DEFINE l_rvg06       LIKE rvg_file.rvg06
DEFINE l_rvg08       LIKE rvg_file.rvg08
DEFINE l_sell_sum    LIKE rvg_file.rvg08
DEFINE l_in_sum      LIKE rvg_file.rvg08
DEFINE l_sum         LIKE rvg_file.rvg08
DEFINE l_sum1        LIKE rvg_file.rvg08
DEFINE l_sum2        LIKE rvg_file.rvg08
DEFINE l_rvf03       LIKE rvf_file.rvf03
DEFINE l_rvf04       LIKE rvf_file.rvf04
DEFINE l_rvf05       LIKE rvf_file.rvf05
DEFINE l_rvf06       LIKE rvf_file.rvf06
DEFINE l_rvf08       LIKE rvf_file.rvf08
DEFINE l_rvd03       LIKE rvd_file.rvd03
DEFINE l_ogb04       LIKE ogb_file.ogb04
DEFINE l_rvv31       LIKE rvv_file.rvv31
DEFINE l_shop        LIKE ima_file.ima01
DEFINE l_dbs         LIKE azp_file.azp03
 
    DROP table temp_x
#FUN-9B0068 --BEGIN--
#    CREATE TEMP TABLE temp_x
#    (flag       VARCHAR(1),          #標識銷售還是庫存:1.銷售 2.庫存
#     org        VARCHAR(10),         #對帳機構
#     type1      VARCHAR(1),          #1.出貨(入庫) 2. 退貨(倉退) 
#     shop       VARCHAR(40),         #商品
#    num        SMALLINT);           #對帳數量

    CREATE TEMP TABLE temp_x(
    flag       LIKE type_file.chr1 ,
     org       LIKE type_file.chr12 ,
     type1     LIKE type_file.chr1, 
     shop      LIKE type_file.chr50, 
    num        LIKE type_file.num10) 
#FUN-9B0068 --END--
   
    #從銷售對帳單身中把對帳機構、類型、商品、對帳數量insert into temp table    
    LET g_sql = "SELECT rvg03,rvg04,rvg05,rvg06,rvg08 FROM rvg_file ",
                " WHERE rvg00 ='",g_rvc.rvc00,"' AND rvg01 = '",g_rvc.rvc01,"'",
                "   AND rvg07 = 'Y' ",
                "  AND rvg08 != 0 "
    PREPARE pre_rvg04 FROM g_sql
    DECLARE rvg04_curs CURSOR FOR pre_rvg04
 
    FOREACH rvg04_curs INTO l_rvg03,l_rvg04,l_rvg05,l_rvg06,l_rvg08
      #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_rvg03
       LET g_plant_new = l_rvg03
       CALL s_gettrandbs()
       LET l_dbs=g_dbs_tra
       LET l_dbs = s_dbstring(l_dbs CLIPPED)
 
       IF l_rvg04 = '1' THEN
          #LET g_sql = "SELECT ogb04 FROM ",l_dbs,"ogb_file ", #FUN-A50102
          LET g_sql = "SELECT ogb04 FROM ",cl_get_target_table(l_rvg03, 'ogb_file'), #FUN-A50102
                      " WHERE ogb01 = '",l_rvg05,"' AND ogb03 = '",l_rvg06,"'"
       ELSE
          #LET g_sql = "SELECT ohb04 FROM ",l_dbs,"ohb_file ", #FUN-A50102
          LET g_sql = "SELECT ohb04 FROM ",cl_get_target_table(l_rvg03, 'ohb_file'), #FUN-A50102
                      " WHERE ohb01 = '",l_rvg05,"' AND ohb03 = '",l_rvg06,"'"
       END IF
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
       CALL cl_parse_qry_sql(g_sql, l_rvg03) RETURNING g_sql  #FUN-A50102
       PREPARE pre_ogb_sell FROM g_sql
       EXECUTE pre_ogb_sell INTO l_ogb04
 
       IF l_ogb04 IS NULL THEN LET l_ogb04 = 0 END IF
       INSERT INTO temp_x VALUES('1',l_rvg03,l_rvg04,l_ogb04,l_rvg08)
       IF SQLCA.SQLCODE THEN
          CALL cl_err('',SQLCA.SQLCODE,0)
          DROP table temp_x
          RETURN 0
       END IF
    END FOREACH
 
    #從庫存對帳單身中把對帳機構、類型、商品、對帳數量insert into temp table    
    LET g_sql = "SELECT rvf03,rvf04,rvf05,rvf06,rvf08 FROM rvf_file ",
                " WHERE rvf00 = '",g_rvc.rvc00,"' AND rvf01 = '",g_rvc.rvc01,"'",
                "   AND rvfplant = '",g_rvc.rvcplant,"' AND rvf07 = 'Y' "
    PREPARE pre_rvf05 FROM g_sql 
    DECLARE rvf05_curs CURSOR FOR pre_rvf05
 
    FOREACH rvf05_curs INTO l_rvf03,l_rvf04,l_rvf05,l_rvf06,l_rvf08
      #FUN-9C0075 ADD------------
      #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_rvf03
       LET g_plant_new = l_rvf03
       CALL s_gettrandbs()
       LET l_dbs=g_dbs_tra
       LET l_dbs = s_dbstring(l_dbs CLIPPED)
      #FUN-9C0075 END----------    
       #LET g_sql = "SELECT rvv31 FROM ",l_dbs,"rvv_file WHERE rvv01 = '", #FUN-A50102
       LET g_sql = "SELECT rvv31 FROM ",cl_get_target_table(l_rvf03, 'rvv_file')," WHERE rvv01 = '", #FUN-A50102
                   l_rvf05,"' AND rvv02 = '",l_rvf06,"' AND rvv03 = '",l_rvf04,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
       CALL cl_parse_qry_sql(g_sql, l_rvf03) RETURNING g_sql  #FUN-A50102            
       PREPARE pre_rvv5 FROM g_sql
       EXECUTE pre_rvv5 INTO l_rvv31
 
       #IF l_rvf04 = '4' THEN
       #   LET "SELECT rvv31 FROM ",l_dbs,"rvv_file WHERE rvv01='",l_rvf05,
       #       "' AND rvv02='",l_rvf06,"' AND rvv03 = '4'"
       #ELSE
       #   SELECT rvv31 INTO l_rvv31 FROM rvv_file WHERE rvv01 = l_rvf05
       #      AND rvv02 = l_rvf06 AND rvv03 = '5'
       #END IF
       INSERT INTO temp_x VALUES('2',l_rvf03,l_rvf04,l_rvv31,l_rvf08)
       IF SQLCA.SQLCODE THEN
          CALL cl_err('',SQLCA.SQLCODE,0)
          DROP table temp_x
          RETURN 0
       END IF
    END FOREACH
 
    #比較銷售對帳數量和庫存對帳數量是否相等
    LET g_sql = "SELECT DISTINCT rvd03 FROM rvd_file ",
                " WHERE rvd00 = '",g_rvc.rvc00,"' AND rvd01 = '",g_rvc.rvc01,"'",
                "   AND rvdplant = '",g_rvc.rvcplant,"'"
    PREPARE pre_rvg03 FROM g_sql
    DECLARE rvg03_curs CURSOR FOR pre_rvg03
    FOREACH rvg03_curs INTO l_rvd03
       IF l_rvd03 IS NULL THEN CONTINUE FOREACH END IF
       LET g_sql = "SELECT DISTINCT shop FROM temp_x WHERE org = '",l_rvd03,"' GROUP BY shop"
       PREPARE pre_x FROM g_sql
       DECLARE x_curs CURSOR FOR pre_x
       FOREACH x_curs INTO l_shop
          #該對帳機構銷售商品對帳總數量
          SELECT SUM(num) INTO l_sum1 FROM temp_x WHERE flag ='1' AND org = l_rvd03 AND type1 = '1' AND shop = l_shop
          SELECT SUM(num) INTO l_sum2 FROM temp_x WHERE flag ='1' AND org = l_rvd03 AND type1 = '2' AND shop = l_shop
          IF l_sum1 IS NULL THEN LET l_sum1 = 0 END IF
          IF l_sum2 IS NULL THEN LET l_sum2 = 0 END IF
          LET l_sell_sum = l_sum1 - l_sum2
 
          #該對帳機構入庫商品對帳總數量
          SELECT SUM(num) INTO l_sum1 FROM temp_x WHERE flag ='2' AND org = l_rvd03 AND type1 = '1' AND shop = l_shop
          SELECT SUM(num) INTO l_sum2 FROM temp_x WHERE flag ='2' AND org = l_rvd03 AND type1 = '3' AND shop = l_shop
          IF l_sum1 IS NULL THEN LET l_sum1 = 0 END IF
          IF l_sum2 IS NULL THEN LET l_sum2 = 0 END IF
          LET l_in_sum = l_sum1 - l_sum2
          
          #出貨數量和入庫數量不等，不能對帳
          IF l_sell_sum != l_in_sum THEN
             DROP table temp_x
             RETURN 0
          END IF
       END FOREACH
    END FOREACH
    DROP TABLE temp_x
    RETURN 1
END FUNCTION
FUNCTION t551_yes()
DEFINE l_cnt1         LIKE type_file.num5
DEFINE l_cnt2         LIKE type_file.num5
DEFINE l_cnt3         LIKE type_file.num5
DEFINE l_cnt4         LIKE type_file.num5
DEFINE l_count        LIKE type_file.num5
DEFINE l_gen02        LIKE gen_file.gen02
DEFINE l_rvd03        LIKE rvd_file.rvd03
DEFINE l_rvf08        LIKE rvf_file.rvf08
DEFINE l_rvg08        LIKE rvg_file.rvg08
DEFINE l_flag         LIKE type_file.num5
DEFINE l_org          LIKE azp_file.azp01
 
    IF g_rvc.rvc01 IS NULL OR g_rvc.rvcplant IS NULL THEN 
       CALL cl_err('',-400,0) 
       RETURN 
    END IF
#CHI-C30107 ----------------- add ---------------------- begin
    IF g_rvc.rvcconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    IF g_rvc.rvcconf = 'X' THEN CALL cl_err(g_rvc.rvc01,'9024',0) RETURN END IF
    IF g_rvc.rvcacti = 'N' THEN CALL cl_err(g_rvc.rvc01,'art-142',0) RETURN END IF
    IF NOT cl_confirm('art-026') THEN RETURN END IF 
#CHI-C30107 ----------------- add ---------------------- end
    SELECT * INTO g_rvc.* FROM rvc_file WHERE rvc01=g_rvc.rvc01 
                                          AND rvcplant=g_rvc.rvcplant
                                          AND rvc00 = g_rvc.rvc00
    IF g_rvc.rvcconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    IF g_rvc.rvcconf = 'X' THEN CALL cl_err(g_rvc.rvc01,'9024',0) RETURN END IF 
    IF g_rvc.rvcacti = 'N' THEN CALL cl_err(g_rvc.rvc01,'art-142',0) RETURN END IF
   
    #檢查銷售單身和庫存單身的對帳數量是否為0
    SELECT SUM(rvf08) INTO l_rvf08 FROM rvf_file
         WHERE rvf00 = g_rvc.rvc00
           AND rvf01 = g_rvc.rvc01
           AND rvfplant = g_rvc.rvcplant
    IF l_rvf08 IS NULL THEN LET l_rvf08 = 0 END IF
    SELECT SUM(rvg08) INTO l_rvg08 FROM rvg_file
       WHERE rvg00 = g_rvc.rvc00
         AND rvg01 = g_rvc.rvc01
         AND rvgplant = g_rvc.rvcplant
    IF l_rvg08 IS NULL THEN LET l_rvg08 = 0 END IF
   #TQC-B10045 Begin---
   #IF l_rvf08 = 0 AND l_rvg08 = 0 THEN 
    LET g_cnt = 0
    SELECT count(*) INTO g_cnt FROM rve_file
       WHERE rve00 = g_rvc.rvc00
         AND rve01 = g_rvc.rvc01
         AND rveplant = g_rvc.rvcplant
    IF cl_null(g_cnt) THEN LET g_cnt = 0 END IF
    IF l_rvf08 = 0 AND l_rvg08 = 0 AND g_cnt = 0 THEN 
   #TQC-B10045 End-----
       CALL cl_err('','art-509',0) 
       RETURN 
    END IF
 
    #檢查銷售數量和庫存對帳數量是否一致   
    IF NOT t551_check() THEN 
       CALL cl_err(l_rvd03,'art-537',0)
       RETURN
    END IF
    #檢查未對帳數量是否大于對帳數量
    IF NOT t551_check_number() THEN
       CALL cl_err('','art-508',0)
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
 
    CALL t400_create_temp()
#   IF NOT cl_confirm('art-026') THEN RETURN END IF #CHI-C30107 mark
    BEGIN WORK
    OPEN t551_cl USING g_rvc.rvc00,g_rvc.rvc01
    IF STATUS THEN
       CALL cl_err("OPEN t551_cl:", STATUS, 1)
       CLOSE t551_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t551_cl INTO g_rvc.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_rvc.rvc01,SQLCA.sqlcode,0)
       CLOSE t551_cl 
       ROLLBACK WORK 
       RETURN
    END IF
 
    LET g_success = 'Y'
    LET l_cnt1 = 0
    LET l_cnt2 = 0
    LET l_cnt3 = 0
    LET l_cnt4 = 0
   
    SELECT COUNT(*) INTO l_cnt1 FROM rvg_file
       WHERE rvg01 = g_rvc.rvc01 
         AND rvg00 = g_rvc.rvc00 
         AND rvgplant = g_rvc.rvcplant
   
    SELECT COUNT(*) INTO l_cnt2 FROM rvf_file                                                                                   
       WHERE rvf01 = g_rvc.rvc01 
         AND rvf00 = g_rvc.rvc00 
         AND rvfplant=g_rvc.rvcplant
 
    SELECT COUNT(*) INTO l_cnt3 FROM rve_file                                                                                
       WHERE rve01=g_rvc.rvc01 
         AND rve00 = g_rvc.rvc00 
         AND rveplant=g_rvc.rvcplant
    #獲取第四個單身的數據行數
 
    IF l_cnt1 = 0 AND l_cnt2 = 0 AND l_cnt3 = 0 THEN 
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
   END IF
 
   #CALL t551_y1() RETURNING l_flag 
   IF l_flag = 0 THEN
      LET g_success = 'N'
   END IF
 
#FUN-B60150 ADD - BEGIN ----------------------------
   IF g_azw.azw04 = '2' AND g_success = 'Y' THEN
      IF g_sma.sma146 = '1' AND g_rvc.rvc02 = '2' THEN
         CALL s_showmsg_init()
         CALL t620sub1_post('3',g_rvc.rvc01)
         CALL s_showmsg()
      END IF
   END IF
#FUN-B60150 ADD -  END  ----------------------------

   IF g_success = 'Y' THEN
      LET g_rvc.rvcconf='Y'
      LET g_rvc.rvcconu=g_user     #TQC-A30030
      LET g_rvc.rvccond=g_today    #TQC-A30030
      COMMIT WORK
      CALL cl_flow_notify(g_rvc.rvc01,'Y')
   ELSE
      ROLLBACK WORK
   END IF
   
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
#把兩個單身分別放到兩個臨時表中
FUNCTION t400_create_temp()
DEFINE l_ima25    LIKE ima_file.ima25
DEFINE l_flag     LIKE type_file.chr1
DEFINE l_fac      LIKE type_file.num20_6
DEFINE l_msg      LIKE type_file.chr1000
 
   DROP TABLE rvf_temp
#FUN-9B0068 --BEGIN--   
#   CREATE TEMP TABLE rvf_temp
#   (rvf02    SMALLINT,
#    rvf03    VARCHAR(10),
#    rvf03_c  VARCHAR(50),
#    rvf04    VARCHAR(1),
#    rvf05    VARCHAR(16),
#    rvf06    SMALLINT,
#    rvv31    VARCHAR(40),
#    rvv031   VARCHAR(120),
#    rvv35    VARCHAR(4),
#    rvv35_c  VARCHAR(50),
#    rvv38    DECIMAL,
#    rvv38t   DECIMAL,
#    rvv17    DECIMAL,
#    rvv39    DECIMAL,
#    rvv39t   DECIMAL,
#    num      DECIMAL,
#    rvf07    VARCHAR(1),
#    rvf08    SMALLINT)

   CREATE TEMP TABLE rvf_temp(
    rvf02    LIKE rvf_file.rvf02,
    rvf03    LIKE rvf_file.rvf03,
    rvf03_c  LIKE type_file.chr50,
    rvf04    LIKE rvf_file.rvf04,
    rvf05    LIKE rvf_file.rvf05,
    rvf06    LIKE rvf_file.rvf05,
    rvv31    LIKE rvv_file.rvv31,
    rvv031   LIKE rvv_file.rvv031,
    rvv35    LIKE rvv_file.rvv35,
    rvv35_c  LIKE type_file.chr50,
    rvv38    LIKE rvv_file.rvv38,
    rvv38t   LIKE rvv_file.rvv38,
    rvv17    LIKE rvv_file.rvv17,
    rvv39    LIKE rvv_file.rvv39,
    rvv39t   LIKE rvv_file.rvv39,
    num      LIKE type_file.num10,
    rvf07    LIKE rvf_file.rvf07,
    rvf08    LIKE rvf_file.rvf08 )
#FUN-9B0068 --END-- 
   LET g_cnt = 1
   FOR g_cnt=1 TO g_rvf.getLength()
      IF g_rvf[g_cnt].rvf07 = 'N' OR g_rvf[g_cnt].rvf08 = 0 THEN
         CONTINUE FOR
      END IF
      SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = g_rvf[g_cnt].rvv31
      CALL s_umfchk(g_rvf[g_cnt].rvv31,g_rvf[g_cnt].rvv35,l_ima25)
         RETURNING l_flag,l_fac
      IF l_flag = 1 THEN
         LET l_msg = g_rvf[g_cnt].rvv35,"->",l_ima25
         CALL cl_err(l_msg CLIPPED,'aqc-500',1)
         RETURN 0
      END IF
      
      LET g_rvf[g_cnt].rvf08 = g_rvf[g_cnt].rvf08*l_fac
      LET g_rvf[g_cnt].rvv17 = g_rvf[g_cnt].rvv17*l_fac
      #LET g_rvf[g_cnt].rvv38 = (g_rvf[g_cnt].rvv39*l_fac)/g_rvf[g_cnt].rvv17
      LET g_rvf[g_cnt].rvv38 = g_rvf[g_cnt].rvv38*l_fac
      #LET g_rvf[g_cnt].rvv38t = (g_rvf[g_cnt].rvv39t*l_fac)/g_rvf[g_cnt].rvv17
      LET g_rvf[g_cnt].rvv38t = g_rvf[g_cnt].rvv38t*l_fac
      #LET g_rvf[g_cnt].rvv39 = ((g_rvf[g_cnt].rvv39*l_fac)/g_rvf[g_cnt].rvv17)*g_rvf[g_cnt].rvf08
      #LET g_rvf[g_cnt].rvv39t =((g_rvf[g_cnt].rvv39t*l_fac)/g_rvf[g_cnt].rvv17)*g_rvf[g_cnt].rvf08
      LET g_rvf[g_cnt].rvv39 = g_rvf[g_cnt].rvv39*l_fac
      LET g_rvf[g_cnt].rvv39t =g_rvf[g_cnt].rvv39t*l_fac
      LET g_rvf[g_cnt].num_uncheck = g_rvf[g_cnt].num_uncheck*l_fac
 
      INSERT INTO rvf_temp VALUES(g_rvf[g_cnt].*)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","rvf_temp",g_rvf[g_cnt].rvv31,"",SQLCA.sqlcode,"","",1)  
         RETURN 0 
      END IF
   END FOR
 
   DROP TABLE rvg_temp
#FUN-9B0068 --begin--   
#   CREATE TEMP TABLE rvg_temp
#   (rvg02    SMALLINT,
#    rvg03    VARCHAR(10),
#    rvg03_c  VARCHAR(50),
#    rvg04    VARCHAR(1),
#    rvg05    VARCHAR(16),
#    rvg06    SMALLINT,
#    ogb04    VARCHAR(40),
#    ogb06    VARCHAR(50),
#    ogb05    VARCHAR(120),
#    ogb05_c  VARCHAR(50),
#    ogb13    DECIMAL,
#    ogb12    SMALLINT,
#    ogb14    DECIMAL,
#    ogb14t   DECIMAL,
#    num      SMALLINT,
#    rvg07    VARCHAR(1),
#    rvg08    SMALLINT)
    
   CREATE TEMP TABLE rvg_temp(
    rvg02    LIKE rvg_file.rvg02,
    rvg03    LIKE rvg_file.rvg03,
    rvg03_c  LIKE type_file.chr50,
    rvg04    LIKE rvg_file.rvg04,
    rvg05    LIKE rvg_file.rvg05,
    rvg06    LIKE rvg_file.rvg06,
    ogb04    LIKE ogb_file.ogb04,
    ogb06    LIKE ogb_file.ogb06,
    ogb05    LIKE ogb_file.ogb05,
    ogb05_c  LIKE type_file.chr50,
    ogb13    LIKE ogb_file.ogb13,
    ogb12    LIKE ogb_file.ogb12,
    ogb14    LIKE ogb_file.ogb14,
    ogb14t   LIKE ogb_file.ogb14t,
    num      LIKE type_file.num10,
    rvg07    LIKE rvg_file.rvg07,
    rvg08    LIKE rvg_file.rvg08)
#FUN-9B0068 --end--  
 
   LET g_cnt = 1
   FOR g_cnt=1 TO g_rvg.getLength()
      IF g_rvg[g_cnt].rvg07 = 'N' OR g_rvg[g_cnt].rvg08 = 0 THEN
         CONTINUE FOR
      END IF
      SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = g_rvg[g_cnt].ogb04_ohb04
      CALL s_umfchk(g_rvg[g_cnt].ogb04_ohb04,g_rvg[g_cnt].ogb05_ohb05,l_ima25)
         RETURNING l_flag,l_fac
      IF l_flag = 1 THEN
         LET l_msg = g_rvg[g_cnt].ogb05_ohb05,"->",l_ima25
         CALL cl_err(l_msg CLIPPED,'aqc-500',1)
         RETURN 0
      END IF
 
      LET g_rvg[g_cnt].ogb13_ohb13 = g_rvg[g_cnt].ogb13_ohb13*l_fac
      LET g_rvg[g_cnt].ogb12_ohb12 = g_rvg[g_cnt].ogb12_ohb12*l_fac
      LET g_rvg[g_cnt].ogb14_ohb14 = g_rvg[g_cnt].ogb14_ohb14*l_fac
      LET g_rvg[g_cnt].ogb14t_ohb14t = g_rvg[g_cnt].ogb14t_ohb14t*l_fac
      LET g_rvg[g_cnt].rvg08 = g_rvg[g_cnt].rvg08*l_fac
      LET g_rvg[g_cnt].num_uncheck1 = g_rvg[g_cnt].num_uncheck1*l_fac
 
      INSERT INTO rvg_temp VALUES(g_rvg[g_cnt].*)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","rvg_temp",g_rvf[g_cnt].rvv31,"",SQLCA.sqlcode,"","",1)  
         RETURN 0 
      END IF
   END FOR
END FUNCTION
FUNCTION t551_y1()
DEFINE l_rvd03    LIKE rvd_file.rvd03
DEFINE l_rtz08    LIKE rtz_file.rtz08  #非成本倉庫
DEFINE l_flag     LIKE type_file.num5
 
    LET g_sql = "SELECT rvd03 FROM rvd_file WHERE rvd00 = '",g_rvc.rvc00,"'",
                "   AND rvd01 = '",g_rvc.rvc01,"' AND rvdplant = '",g_rvc.rvcplant,"'"
    PREPARE pre_rvd1 FROM g_sql
    DECLARE rvd1_curs CURSOR FOR pre_rvd1
    
    FOREACH rvd1_curs INTO l_rvd03
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
       IF l_rvd03 IS NULL THEN CONTINUE FOREACH END IF
       
       CALL t551_store(l_rvd03) RETURNING l_flag   #產生入庫單
       IF l_flag = 0 THEN
          LET g_success = 'N'
          RETURN 0
       END IF
       
       CALL t551_zafa(l_rvd03) RETURNING l_flag   #產生雜發單
       IF l_flag = 0  THEN
          LET g_success = 'N'
          RETURN 0
       END IF
    END FOREACH
 
    RETURN 1
END FUNCTION
 
FUNCTION t551_store(p_org)
DEFINE p_org      LIKE azp_file.azp01
DEFINE l_dbs      LIKE azp_file.azp03
DEFINE l_rtz07    LIKE rtz_file.rtz07  #成本倉庫
DEFINE l_rvv      RECORD LIKE rvv_file.*
DEFINE l_rvv31    LIKE rvv_file.rvv31
DEFINE l_rvv35    LIKE rvv_file.rvv35
#DEFINE l_rvv38    LIKE rvv_file.rvv38
#DEFINE l_rvv38t   LIKE rvv_file.rvv38t
#DEFINE l_rvv39    LIKE rvv_file.rvv39
#DEFINE l_rvv39t   LIKE rvv_file.rvv39t
#DEFINE l_rvv17    LIKE rvv_file.rvv17
#DEFINE l_rvf08    LIKE rvf_file.rvf08
DEFINE l_in_rvv38   LIKE rvv_file.rvv38 
DEFINE l_in_rvv38t  LIKE rvv_file.rvv38t
DEFINE l_in_rvv39   LIKE rvv_file.rvv39 
DEFINE l_in_rvv39t   LIKE rvv_file.rvv39t 
DEFINE l_in_rvv17   LIKE rvv_file.rvv17
DEFINE l_in_rvf08   LIKE rvf_file.rvf08 
DEFINE l_out_rvv38   LIKE rvv_file.rvv38 
DEFINE l_out_rvv38t  LIKE rvv_file.rvv38t
DEFINE l_out_rvv39   LIKE rvv_file.rvv39 
DEFINE l_out_rvv39t   LIKE rvv_file.rvv39t 
DEFINE l_out_rvv17   LIKE rvv_file.rvv17
DEFINE l_out_rvf08   LIKE rvf_file.rvf08 
DEFINE l_cnt         LIKE type_file.num5
DEFINE l_no          LIKE rvu_file.rvu01
DEFINE l_n           LIKE rvu_file.rvu01
DEFINE l_flag        LIKE type_file.num5
DEFINE l_avg_rvv38   LIKE rvv_file.rvv38
DEFINE l_avg_rvv38t  LIKE rvv_file.rvv38t
DEFINE l_avg_rvv39   LIKE rvv_file.rvv39
DEFINE l_avg_rvv39t  LIKE rvv_file.rvv39t
DEFINE l_ima02       LIKE ima_file.ima02
DEFINE l_pmm43       LIKE pmm_file.pmm43
DEFINE l_pmc47       LIKE pmc_file.pmc47

#FUN-9C0075 ADD----- 
  #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = p_org
       LET g_plant_new = p_org  
       CALL s_gettrandbs()
       LET l_dbs=g_dbs_tra
   LET l_dbs = s_dbstring(l_dbs CLIPPED)
#FUN-9C0075 END-------
   SELECT rtz07 INTO l_rtz07 FROM rtz_file WHERE rtz01 = p_org
 
   CALL t511_insrvu(p_org,l_dbs) RETURNING l_flag,l_no
   IF l_flag = 0 THEN RETURN 0 END IF
 
   SELECT pmc47 INTO l_pmc47 FROM pmc_file WHERE pmc01 = g_rvc.rvc03
   SELECT gec04 INTO l_pmm43 FROM gec_file WHERE gec01 = l_pmc47
   IF l_pmm43 IS NULL THEN LET l_pmm43 = 0 END IF
 
   LET g_sql = "SELECT rvv31,rvv35 ",
               " FROM rvf_temp ",
               " WHERE rvf03 = '",p_org,"' ",
               "  GROUP BY rvv31,rvv35 "
   PREPARE pre_rvf_temp FROM g_sql
   DECLARE cur1_rvf CURSOR FOR pre_rvf_temp
   LET l_n = 1
   FOREACH cur1_rvf INTO l_rvv31,l_rvv35
       SELECT SUM(rvv38),SUM(rvv38t),SUM(rvv17),
              SUM(rvv39),SUM(rvv39t),SUM(rvf08)
         INTO l_in_rvv38,l_in_rvv38t,l_in_rvv17,l_in_rvv39,l_in_rvv39t,l_in_rvf08
         FROM rvf_temp
           WHERE rvf04 = '4' AND rvf03 = p_org AND rvv31 = l_rvv31
       IF l_in_rvv38 IS NULL THEN LET l_in_rvv38 = 0 END IF  
       IF l_in_rvv38t IS NULL THEN LET l_in_rvv38t = 0 END IF  
       IF l_in_rvv39 IS NULL THEN LET l_in_rvv39 = 0 END IF  
       IF l_in_rvv39t IS NULL THEN LET l_in_rvv39t = 0 END IF  
       IF l_in_rvv17 IS NULL THEN LET l_in_rvv17 = 0 END IF  
       IF l_in_rvf08 IS NULL THEN LET l_in_rvf08 = 0 END IF
 
       SELECT SUM(rvv38),SUM(rvv38t),SUM(rvv17),
              SUM(rvv39),SUM(rvv39t),SUM(rvf08)
         INTO l_out_rvv38,l_out_rvv38t,l_out_rvv17,l_out_rvv39,l_out_rvv39t,l_out_rvf08
         FROM rvf_temp
           WHERE rvf04 = '5' AND rvf03 = p_org AND rvv31 = l_rvv31
       IF l_out_rvv38 IS NULL THEN LET l_out_rvv38 = 0 END IF  
       IF l_out_rvv38t IS NULL THEN LET l_out_rvv38t = 0 END IF  
       IF l_out_rvv39 IS NULL THEN LET l_out_rvv39 = 0 END IF
       IF l_out_rvv39t IS NULL THEN LET l_out_rvv39t = 0 END IF  
       IF l_out_rvv17 IS NULL THEN LET l_out_rvv17 = 0 END IF
       IF l_out_rvf08 IS NULL THEN LET l_out_rvf08 = 0 END IF
 
       #計算平均單價
       LET l_avg_rvv38 = (l_out_rvv39 + l_in_rvv39)/(l_in_rvv17 + l_out_rvv17)
       LET l_avg_rvv38t = (l_out_rvv39t + l_in_rvv39t)/(l_in_rvv17 + l_out_rvv17)
       LET l_avg_rvv39 = ((l_out_rvv39 + l_in_rvv39)/(l_in_rvv17 + l_out_rvv17))*(l_in_rvf08 - l_out_rvf08)
       LET l_avg_rvv39t = (l_out_rvv39t + l_in_rvv39t)/(l_in_rvv17 + l_out_rvv17)*(l_in_rvf08 - l_out_rvf08)
 
       LET l_in_rvf08 = l_in_rvf08 - l_out_rvf08   #入庫的對帳數量-倉退的對帳數量
       IF l_in_rvf08 < 0 THEN CALL cl_err(l_rvv31,'art-533',1) RETURN 0 END IF
       
       LET l_in_rvv38 = l_in_rvv38 - l_out_rvv38   #入庫稅前單價-倉退的稅前單價
       IF l_in_rvv38 < 0 THEN CALL cl_err(l_rvv31,'art-529',1) RETURN 0 END IF
         
       LET l_in_rvv38t = l_in_rvv38t - l_out_rvv38t   #入庫稅后單價-倉退的稅后單價
       IF l_in_rvv38t < 0 THEN CALL cl_err(l_rvv31,'art-530',1) RETURN 0 END IF
       
       LET l_in_rvv39 = l_in_rvv39 - l_out_rvv39   #入庫稅前金額-倉退的稅金額
       IF l_in_rvv39 < 0 THEN CALL cl_err(l_rvv31,'art-531',1) RETURN 0 END IF
       
       LET l_in_rvv39t = l_in_rvv39t - l_out_rvv39t   #入庫含稅金額-倉退的含稅金額
       IF l_in_rvv39t < 0 THEN CALL cl_err(l_rvv31,'art-532',1) RETURN 0 END IF
 
       LET l_in_rvv17 = l_in_rvv17 - l_out_rvv17   #入庫數量-倉退的數量
       IF l_in_rvv17 < 0 THEN CALL cl_err(l_rvv31,'art-528',1) RETURN 0 END IF
 
       SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01 = l_rvv31
 
       LET l_rvv.rvv03 = '1'
       LET l_rvv.rvv02 = l_n
       LET l_rvv.rvv31 = l_rvv31
       LET l_rvv.rvv031 = l_ima02
       LET l_rvv.rvv35 = l_rvv35
       LET l_rvv.rvv10 = '4'
       LET l_rvv.rvv25 = 'N'
       LET l_rvv.rvv12 = g_rvc.rvc01
       LET l_rvv.rvv17 = l_in_rvf08
       LET l_rvv.rvv32 = l_rtz07
       LET l_rvv.rvv33 = ' '
       LET l_rvv.rvv34 = ' '
       LET l_rvv.rvv38 = l_avg_rvv38
       LET l_rvv.rvv38t = l_avg_rvv38t
       LET l_rvv.rvv39 = l_avg_rvv39
       LET l_rvv.rvv39t = l_avg_rvv39t
       LET l_rvv.rvv17 = s_digqty(l_rvv.rvv17,l_rvv.rvv35)  #FUN-BB0084
       SELECT azw02 INTO l_rvv.rvvlegal FROM azw_file WHERE azw01 = p_org
       #LET g_sql = "INSERT INTO ",l_dbs,"rvv_file(", #FUN-A50102
       LET g_sql = "INSERT INTO ",cl_get_target_table(p_org, 'rvv_file'), #FUN-A50102
                   "(rvv01,rvv02,rvv03,rvv31,rvv031, ",
                   "rvv35,rvv10,rvv25,rvv12,rvv17,",
                   "rvv32,rvv33,rvv34,rvv38,rvv38t,",
                   "rvv39,rvv39t,rvvplant,rvvlegal) VALUES",
                   "(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
       CALL cl_parse_qry_sql(g_sql, p_org) RETURNING g_sql  #FUN-A50102            
       PREPARE pre_ins_rvv FROM g_sql
       EXECUTE pre_ins_rvv USING l_no,l_rvv.rvv02,l_rvv.rvv03,l_rvv.rvv31,l_rvv.rvv031,
                                 l_rvv.rvv35,l_rvv.rvv10,l_rvv.rvv25,l_rvv.rvv12,l_rvv.rvv17,
                                 l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvv.rvv38,l_rvv.rvv38t,
                                 l_rvv.rvv39,l_rvv.rvv39t,p_org,l_rvv.rvvlegal
       IF SQLCA.sqlcode THEN
          CALL cl_err3("ins","rvv_file",l_no,"",SQLCA.sqlcode,"","",1)  
          RETURN 0 
       END IF
 
       #LET g_sql = "SELECT COUNT(*) FROM ",l_dbs,"img_file ", #FUN-A50102
       LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(p_org, 'img_file'), #FUN-A50102
                   " WHERE img01 = '",l_rvv.rvv31,"' AND img02 = '",l_rtz07,"'",
                   "   AND img03 = ' ' AND img04 = ' ' "
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
       CALL cl_parse_qry_sql(g_sql, p_org) RETURNING g_sql  #FUN-A50102                
       PREPARE pre_selimg FROM g_sql
       EXECUTE pre_selimg INTO l_cnt
 
       IF l_cnt IS NULL OR l_cnt = 0 THEN
          IF g_sma.sma892[3,3] ='Y' THEN
             IF cl_confirm('mfg1401') THEN
                CALL s_madd_img(l_rvv31,l_rtz07,' ',' ',l_no,l_n,g_today,
                                p_org)
             END IF
          ELSE
             CALL s_madd_img(l_rvv31,l_rtz07,' ',' ',l_no,l_n,g_today,
                             p_org)
          END IF
       END IF
       CALL s_mupimg(1,l_rvv31,l_rtz07,' ',' ',l_rvv.rvv17,g_today,p_org,' ',l_no,l_n)
 
       LET l_n = l_n + 1
   END FOREACH
   
   RETURN 1  
END FUNCTION
FUNCTION t511_insrvu(p_org,p_dbs)
DEFINE p_org   LIKE azp_file.azp01
DEFINE p_dbs   LIKE azp_file.azp03
DEFINE p_store LIKE rtz_file.rtz07
DEFINE l_rvu   RECORD LIKE rvu_file.*
DEFINE l_rye03 LIKE rye_file.rye03
DEFINE li_result   LIKE type_file.num5
DEFINE l_pmc03     LIKE pmc_file.pmc03
    

    #FUN-C90050 mark begin---
    #LET g_sql = "SELECT rye03 FROM rye_file ",
    #            " WHERE rye01 = 'apm' AND rye02 ='7' ",
    #            "   AND rye05 = '",g_plant,"'"                  #UFN-C90050 add
    #PREPARE pre_rye FROM g_sql
    #EXECUTE pre_rye INTO l_rye03
    #FUN-C90050 mark end-----
    CALL s_get_defslip('apm','7',g_plant,'N') RETURNING l_rye03     #FUN-C90050 add

    IF l_rye03 IS NULL THEN 
       CALL cl_err('','art-300',1)
       RETURN 0,''
    END IF
 
    CALL s_auto_assign_no("apm",l_rye03,g_today,"","rvu_file","rvu01",p_org,"","") 
       RETURNING li_result,l_rvu.rvu01
    IF (NOT li_result) THEN
       RETURN 0,''
    END IF
 
    SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01 = g_rvc.rvc03
 
    LET l_rvu.rvu00 = '1' 
    LET l_rvu.rvu03 = g_today
    LET l_rvu.rvu04 = g_rvc.rvc03
    LET l_rvu.rvu05 = l_pmc03
    LET l_rvu.rvu08 = 'REG'
    LET l_rvu.rvu06 = g_grup
    LET l_rvu.rvu07 = g_user
    LET l_rvu.rvuconf = 'Y'
    LET l_rvu.rvucond = g_today
    LET l_rvu.rvucont = TIME(CURRENT)
    LET l_rvu.rvuconu = g_user
    LET l_rvu.rvupos = 'N'
    LET l_rvu.rvu21 = g_rvc.rvc02
    LET l_rvu.rvu22 = p_org
    LET l_rvu.rvumksg = 'Y'
    LET l_rvu.rvu900 = '0'
    LET l_rvu.rvuplant = p_org
    SELECT azw02 INTO l_rvu.rvulegal FROM azw_file  WHERE azw01 = p_org
    LET l_rvu.rvuuser = g_user
    LET l_rvu.rvuoriu = g_user #FUN-980030
    LET l_rvu.rvuorig = g_grup #FUN-980030
   #LET g_data_plant = g_plant #FUN-980030  #TQC-A10128 MARK
    LET l_rvu.rvugrup = g_grup
    LET l_rvu.rvucrat = g_today
 
    #LET g_sql = "INSERT INTO ",p_dbs,"rvu_file(rvu00,rvu01,rvu03,rvu04,rvu05,", #FUN-A50102
    LET g_sql = "INSERT INTO ",cl_get_target_table(p_org, 'rvu_file'),"(rvu00,rvu01,rvu03,rvu04,rvu05,", #FUN-A50102
                " rvu06,rvu07,rvuconf,rvucond,rvucont,rvuconu,rvupos,rvu21,",
                " rvu22,rvumksg,rvu900,rvuplant,rvuuser,rvugrup,rvucrat,rvu08,rvulegal,rvuoriu,rvuorig) ", #FUN-A10036
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"  #FUN-A10034
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, p_org) RETURNING g_sql  #FUN-A50102                 
    PREPARE pre_insrvu FROM g_sql 
    EXECUTE pre_insrvu USING l_rvu.rvu00,l_rvu.rvu01,l_rvu.rvu03,l_rvu.rvu04,
                             l_rvu.rvu05,l_rvu.rvu06,l_rvu.rvu07,l_rvu.rvuconf,
                             l_rvu.rvucond,l_rvu.rvucont,l_rvu.rvuconu,l_rvu.rvupos,
                             l_rvu.rvu21,l_rvu.rvu22,l_rvu.rvumksg,l_rvu.rvu900,
                             l_rvu.rvuplant,l_rvu.rvuuser,l_rvu.rvugrup,l_rvu.rvucrat,
                             l_rvu.rvu08,l_rvu.rvulegal,g_user,g_grup    #FUN-A10036
    IF SQLCA.SQLCODE THEN
       CALL cl_err3("ins","rvu_file",l_rvu.rvu01,"",SQLCA.sqlcode,"","",1)
       RETURN 0,''
    END IF
 
    RETURN 1,l_rvu.rvu01
END FUNCTION
#產生雜發單
FUNCTION t551_zafa(p_org)
DEFINE p_org         LIKE azp_file.azp01
DEFINE l_no          LIKE rvu_file.rvu01
DEFINE l_n           LIKE type_file.num5
DEFINE l_cnt         LIKE type_file.num5
DEFINE l_flag        LIKE type_file.num5
DEFINE l_rtz08       LIKE rtz_file.rtz08
DEFINE l_dbs         LIKE azp_file.azp03
DEFINE l_ogb04       LIKE ogb_file.ogb04
DEFINE l_ogb05       LIKE ogb_file.ogb05
#DEFINE l_ogb12       LIKE ogb_file.ogb12
#DEFINE l_ogb13       LIKE ogb_file.ogb13
#DEFINE l_ogb14       LIKE ogb_file.ogb14
#DEFINE l_ogb14t      LIKE ogb_file.ogb14t
#DEFINE l_rvg08       LIKE rvg_file.rvg08
DEFINE l_out_ogb13   LIKE ogb_file.ogb13
DEFINE l_out_ogb12   LIKE ogb_file.ogb12
DEFINE l_out_ogb14   LIKE ogb_file.ogb14
DEFINE l_out_ogb14t  LIKE ogb_file.ogb14t
DEFINE l_out_rvg08   LIKE rvg_file.rvg08
DEFINE l_tui_ogb13   LIKE ogb_file.ogb13
DEFINE l_tui_ogb12   LIKE ogb_file.ogb12
DEFINE l_tui_ogb14   LIKE ogb_file.ogb14
DEFINE l_tui_ogb14t  LIKE ogb_file.ogb14t
DEFINE l_tui_rvg08   LIKE rvg_file.rvg08
DEFINE l_inb         RECORD LIKE inb_file.*
DEFINE l_pmm43       LIKE pmm_file.pmm43
DEFINE l_pmc47       LIKE pmc_file.pmc47
DEFINE l_img01       LIKE img_file.img01
DEFINE l_img02       LIKE img_file.img02
DEFINE l_img03       LIKE img_file.img03
DEFINE l_img04       LIKE img_file.img04
DEFINE l_inbi        RECORD LIKE inbi_file.*  #FUN-B70074 add

#FUN-9C0075 ADD-- 
  #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = p_org
       LET g_plant_new = p_org  
       CALL s_gettrandbs()
       LET l_dbs=g_dbs_tra
   LET l_dbs = s_dbstring(l_dbs CLIPPED)
  #SELECT rtz08 INTO l_rtz08 FROM rtz_file WHERE rtz01 = p_org    #FUN-C90049 mark 
   CALL s_get_noncoststore( p_org ,'') RETURNING l_rtz08    #FUN-C90049 add
   CALL t511_insina(p_org,l_dbs) RETURNING l_flag,l_no
   IF l_flag = 0 THEN RETURN 0 END IF
 
   SELECT pmc47 INTO l_pmc47 FROM pmc_file WHERE pmc01 = g_rvc.rvc03
   SELECT gec04 INTO l_pmm43 FROM gec_file WHERE gec01 = l_pmc47
   IF l_pmm43 IS NULL THEN LET l_pmm43 = 0 END IF
 
   LET g_sql = "SELECT ogb04,ogb05 ",
               " FROM rvg_temp ",
               " WHERE rvg03 = '",p_org,"' ",
               "  GROUP BY ogb04,ogb05 "
 
   PREPARE pre_rvg_temp FROM g_sql
   DECLARE cur1_rvg CURSOR FOR pre_rvg_temp
   LET l_n = 1
   FOREACH cur1_rvf INTO l_ogb04,l_ogb05
      SELECT SUM(ogb13),SUM(ogb12),SUM(ogb14),SUM(ogb14t),SUM(rvg08) 
         INTO l_out_ogb13,l_out_ogb12,l_out_ogb14,l_out_ogb14t,l_out_rvg08
         FROM rvg_temp
           WHERE rvg03 =p_org AND rvg04 = '1' AND ogb04 = l_ogb04
      IF l_out_ogb13 IS NULL THEN LET l_out_ogb13 = 0 END IF
      IF l_out_ogb12 IS NULL THEN LET l_out_ogb12 = 0 END IF
      IF l_out_ogb14 IS NULL THEN LET l_out_ogb14 = 0 END IF
      IF l_out_ogb14t IS NULL THEN LET l_out_ogb14t = 0 END IF
      IF l_out_rvg08 IS NULL THEN LET l_out_rvg08 = 0 END IF
      
      SELECT SUM(ogb13),SUM(ogb12),SUM(ogb14),SUM(ogb14t),SUM(rvg08) 
         INTO l_tui_ogb13,l_tui_ogb12,l_tui_ogb14,l_tui_ogb14t,l_tui_rvg08
         FROM rvg_temp
           WHERE rvg03 =p_org AND rvg04 = '2' AND ogb04 = l_ogb04
      IF l_tui_ogb13 IS NULL THEN LET l_tui_ogb13 = 0 END IF
      IF l_tui_ogb12 IS NULL THEN LET l_tui_ogb12 = 0 END IF
      IF l_tui_ogb14 IS NULL THEN LET l_tui_ogb14 = 0 END IF
      IF l_tui_ogb14t IS NULL THEN LET l_tui_ogb14t = 0 END IF
      IF l_tui_rvg08 IS NULL THEN LET l_tui_rvg08 = 0 END IF
 
      LET l_out_ogb13 = l_out_ogb13 - l_tui_ogb13
      IF l_out_ogb13 <0 THEN CALL cl_err('','art-549',1) RETURN 0 END IF
      LET l_out_ogb14 = l_out_ogb14 - l_tui_ogb14
      IF l_out_ogb14 <0 THEN CALL cl_err('','art-550',1) RETURN 0 END IF
      LET l_out_ogb12 = l_out_ogb12 - l_tui_ogb12
      IF l_out_ogb12 < 0 THEN CALL cl_err('','art-551',1) RETURN 0 END IF
      LET l_out_ogb14t = l_out_ogb14t - l_tui_ogb14t
      IF l_out_ogb14t < 0 THEN CALL cl_err('','art-552',1) RETURN 0 END IF
      LET l_out_rvg08 = l_out_rvg08 - l_tui_rvg08
      IF l_out_rvg08 < 0 THEN CALL cl_err('','art-553',1) RETURN 0 END IF
       
      LET l_inb.inb01 = l_no
      LET l_inb.inb03 = l_n
      LET l_inb.inb04 = l_ogb04
      LET l_inb.inb08 = l_ogb05
      LET l_inb.inb05 = l_rtz08
      LET l_inb.inb06 = ' '
      LET l_inb.inb07 = ' '
      LET l_inb.inb09 = l_out_rvg08
      LET l_inb.inb09 = s_digqty(l_inb.inb09,l_inb.inb08)   #FUN-BB0085
      LET l_inb.inb10 = 'N'
      LET l_inb.inb11 = g_rvc.rvc01
      LET l_inb.inbplant = p_org
      SELECT azw_file INTO l_inb.inblegal FROM azw_file WHERE azw01 = p_org
      LET l_inb.inb08_fac = 1
 
      #LET g_sql = "INSERT INTO ",l_dbs,"inb_file(", #FUN-A50102
      LET g_sql = "INSERT INTO ",cl_get_target_table(p_org, 'inb_file'), #FUN-A50102
                  "(inb01,inb03,inb04,inb05,inb06,",
                  "inb07,inb08,inb09,inb10,inb11,",
                  "inbplant,inb08_fac,inblegal) VALUES(",
                  "?,?,?,?,?, ?,?,?,?,?, ?,?,?)"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
      CALL cl_parse_qry_sql(g_sql, p_org) RETURNING g_sql  #FUN-A50102            
      PREPARE pre_ins_inb FROM g_sql
      EXECUTE pre_ins_inb USING l_inb.inb01,l_inb.inb03,l_inb.inb04,l_inb.inb05,
                                l_inb.inb06,l_inb.inb07,l_inb.inb08,l_inb.inb09,
                                l_inb.inb10,l_inb.inb11,l_inb.inbplant,l_inb.inb08_fac,
                                l_inb.inblegal
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("ins","inb_file",l_inb.inb01,"",SQLCA.sqlcode,"","",1)
         RETURN 0,''
#FUN-B70074--add--insert--
      ELSE
         IF NOT s_industry('std') THEN
            INITIALIZE l_inbi.* TO NULL
            LET l_inbi.inbi01 = l_inb.inb01
            LET l_inbi.inbi03 = l_inb.inb03
            IF NOT s_ins_inbi(l_inbi.*,p_org ) THEN
               RETURN 0,''
            END IF
         END IF 
#FUN-B70074--add--insert--
      END IF
 
       #LET g_sql = "SELECT COUNT(*) FROM ",l_dbs,"img_file ", #FUN-A50102
       LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(p_org, 'img_file'), #FUN-A50102
                   " WHERE img01 = '",l_ogb04,"' AND img02 = '",l_rtz08,"'",
                   "   AND img03 = ' ' AND img04 = ' ' "
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
       CALL cl_parse_qry_sql(g_sql, p_org) RETURNING g_sql  #FUN-A50102            
       PREPARE pre_selimg1 FROM g_sql
       EXECUTE pre_selimg1 INTO l_cnt
 
       IF l_cnt IS NULL OR l_cnt = 0 THEN
          IF g_sma.sma892[3,3] ='Y' THEN
             IF cl_confirm('mfg1401') THEN
                CALL s_madd_img(l_ogb04,l_rtz08,' ',' ',l_no,l_n,g_today,
                                p_org)
             END IF
          ELSE
             CALL s_madd_img(l_ogb04,l_rtz08,' ',' ',l_no,l_n,g_today,
                             p_org)
          END IF
       END IF
 
       #LET g_sql = "SELECT img01,img02,img03,img04 FROM ",l_dbs,"img_file ", #FUN-A50102
       LET g_sql = "SELECT img01,img02,img03,img04 FROM ",cl_get_target_table(p_org, 'img_file'), #FUN-A50102
                   " WHERE img01 = '",l_ogb04,"' AND img02 = '",l_rtz08,"'",
                   "   AND img02 = ' ' AND img03 = ' ' "
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
       CALL cl_parse_qry_sql(g_sql, p_org) RETURNING g_sql  #FUN-A50102             
       PREPARE pre_selrow FROM g_sql
       EXECUTE pre_selrow INTO l_img01,l_img02,l_img03,l_img04 
       CALL s_mupimg(-1,l_ogb04,l_rtz08,' ',' ',l_inb.inb09,g_today,p_org,' ',l_no,l_n)
   
       LET l_n = l_n + 1 
   END FOREACH
 
   RETURN 1
END FUNCTION
FUNCTION t511_insina(p_org,p_dbs)
DEFINE p_dbs         LIKE azp_file.azp03
DEFINE p_org         LIKE azp_file.azp01
DEFINE l_ina         RECORD LIKE ina_file.*
DEFINE l_rye03       LIKE rye_file.rye03
DEFINE li_result   LIKE type_file.num5
 
    #FUN-C90050 mark begin---
    #LET g_sql = "SELECT rye03 FROM rye_file ",
    #            " WHERE rye01 = 'aim' AND rye02 ='1' " 
    #PREPARE pre_rye1 FROM g_sql
    #EXECUTE pre_rye1 INTO l_rye03
    #FUN-C90050 mark end-----

    CALL s_get_defslip('aim','1',g_plant,'N') RETURNING l_rye03     #FUN-C90050 add

    IF l_rye03 IS NULL THEN 
       CALL cl_err('','art-315',1)
       RETURN 0,''
    END IF
 
    CALL s_auto_assign_no("aim",l_rye03,g_today,"","ina_file","ina01",p_org,"","") 
       RETURNING li_result,l_ina.ina01
    IF (NOT li_result) THEN
       RETURN 0,''
    END IF
 
    LET l_ina.ina00 = '1'
    LET l_ina.ina02 = g_today
    LET l_ina.ina03 = g_today
    LET l_ina.ina11 = g_user
    LET l_ina.ina04 = g_grup
    LET l_ina.ina10 = g_rvc.rvc01
    LET l_ina.ina12 = 'N'
    LET l_ina.inaplant = p_org
    SELECT azw_file INTO l_ina.inalegal FROM azw_file WHERE azw01 = p_org
    LET l_ina.inaconf = 'Y'
    LET l_ina.inacond = g_today
    LET l_ina.inaconu = g_user
    LET l_ina.inacont = TIME(CURRENT)
    LET l_ina.ina08 = '0'
    LET l_ina.inapos = 'N'
    LET l_ina.inapost = 'Y'
    LET l_ina.inamksg = 'N'
    LET l_ina.inauser = g_user
    LET l_ina.inagrup = g_grup
    
    #LET g_sql = "INSERT INTO ",p_dbs,"ina_file(", #FUN-A50102
    LET g_sql = "INSERT INTO ",cl_get_target_table(p_org, 'ina_file'), #FUN-A50102
                "(ina00,ina01,ina02,ina03,ina04,",
                "ina10,ina11,ina12,inaplant,inaconf,",
                "inacond,inaconu,inacont,ina08,inapos,",
                "inapost,inamksg,inauser,inagrup,inalegal,inaoriu,inaorig) VALUES",  #FUN-A10036
                "(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?,?)"  #FUN-A10036
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, p_org) RETURNING g_sql  #FUN-A50102            
    PREPARE pre_ins_ina FROM g_sql
    EXECUTE pre_ins_ina USING l_ina.ina00,l_ina.ina01,l_ina.ina02,l_ina.ina03,l_ina.ina04,
                              l_ina.ina10,l_ina.ina11,l_ina.ina12,l_ina.inaplant,l_ina.inaconf,
                              l_ina.inacond,l_ina.inaconu,l_ina.inacont,l_ina.ina08,l_ina.inapos,
                              l_ina.inapost,l_ina.inamksg,l_ina.inauser,l_ina.inagrup,l_ina.inalegal,g_user,g_grup #FUN-A10036
    IF SQLCA.SQLCODE THEN
       CALL cl_err3("ins","ina_file",l_ina.ina01,"",SQLCA.sqlcode,"","",1)
       RETURN 0,''
    END IF
    
    RETURN 1,l_ina.ina01
END FUNCTION
FUNCTION t551_rvcplant()
DEFINE l_azp02    LIKE  azp_file.azp02
 
    SELECT azp02 INTO l_azp02 FROM azp_file
       WHERE azp01 = g_plant
    DISPLAY l_azp02 TO FORMONLY.rvcplant_desc
END FUNCTION
FUNCTION t551_a()
DEFINE li_result   LIKE type_file.num5
DEFINE l_n         LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
 
   CALL g_rvg.clear()
   CALL g_rvf.clear()
   CALL g_rve.clear()
 
   INITIALIZE g_rvc.* LIKE rvc_file.*
   LET g_rvc01_t = NULL
   LET g_rvcplant_t = NULL
   
   CALL cl_opmsg('a')
   WHILE TRUE
       LET g_rvc.rvc00 = '2'
       LET g_rvc.rvc02 = '2'
       LET g_rvc.rvc05 = g_today
       LET g_rvc.rvcplant = g_plant
       LET g_rvc.rvclegal = g_legal
       LET g_rvc.rvcoriu=g_user      #TQC-A30041 ADD
       LET g_rvc.rvcorig=g_grup      #TQC-A30041 ADD
       LET g_rvc.rvcconf = 'N'
       LET g_rvc.rvcuser = g_user
       LET g_rvc.rvcgrup = g_grup
       LET g_rvc.rvcmodu = NULL
       LET g_rvc.rvcdate = NULL
       LET g_rvc.rvcacti = 'Y'
       LET g_rvc.rvccrat = g_today
       LET g_data_plant = g_plant #TQC-A10128 ADD
       CALL t551_rvcplant()
       CALL t551_i("a")
       IF INT_FLAG THEN
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           CLEAR FORM
           CALL g_rvg.clear()
           CALL g_rvf.clear()
           CALL g_rve.clear()
           EXIT WHILE
       END IF
       IF g_rvc.rvc01 IS NULL OR g_rvc.rvcplant IS NULL 
          OR g_rvc.rvc00 IS NULL THEN
          CONTINUE WHILE
       END IF
       BEGIN WORK
#      CALL s_auto_assign_no("art",g_rvc.rvc01,g_today,"","rvc_file","rvc00,rvc01,rvcplant","","","")  #FUN-A70130 mark
       CALL s_auto_assign_no("art",g_rvc.rvc01,g_today,"E4","rvc_file","rvc00,rvc01,rvcplant","","","")  #FUN-A70130 mod
          RETURNING li_result,g_rvc.rvc01
       IF (NOT li_result) THEN                                                                           
           CONTINUE WHILE                                                                     
       END IF
       DISPLAY BY NAME g_rvc.rvc01
       LET g_rvc.rvcoriu = g_user      #No.FUN-980030 10/01/04
       LET g_rvc.rvcorig = g_grup      #No.FUN-980030 10/01/04
       INSERT INTO rvc_file VALUES(g_rvc.*)     # DISK WRITE
       IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
       #   ROLLBACK WORK           # FUN-B80085---回滾放在報錯後---
          CALL cl_err3("ins","rvc_file",g_rvc.rvc01,g_rvc.rvcplant,SQLCA.SQLCODE,"","",1) 
          ROLLBACK WORK            # FUN-B80085--add--
          CONTINUE WHILE
       ELSE
          # FUN-B80085 增加空白行


          SELECT * FROM rvd_file WHERE rvd00 =g_rvc.rvc00 AND rvd01=g_rvc.rvc01
                                   AND rvd02 = '1' AND rvdplant=g_rvc.rvcplant
          IF SQLCA.SQLCODE = 100 THEN 
             #insert到生效機構單身檔
            #INSERT INTO rvd_file(rvd00,rvd01,rvd02,rvd03,rvdplant)            #FUN-9B0025 MARK
             INSERT INTO rvd_file(rvd00,rvd01,rvd02,rvd03,rvdplant,rvdlegal)   #FUN-9B0025 ADD LEGAL
                           VALUES(g_rvc.rvc00,g_rvc.rvc01,1,g_rvc.rvcplant,
                                  g_rvc.rvcplant,g_rvc.rvclegal)
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
       LET g_rec_b=0
       LET g_rec_b1=0
       LET g_rec_b2=0
 
       CALL t551_org()
       #為三個單身抓資料，并insert
       CALL t551_insrvg()
       CALL tttl_insrvf()
       #CALL t551_insrve()
       CALL t551_insrve()   #TQC-AC0138 add
       #如果單身沒有合乎條件的資料自動刪除單頭       
       SELECT COUNT(*) INTO l_n FROM rvf_file 
            WHERE rvf00 = g_rvc.rvc00
              AND rvf01 = g_rvc.rvc01
              AND rvfplant = g_rvc.rvcplant
       IF l_n IS NULL THEN LET l_n = 0 END IF
       
       IF l_n = 0 THEN
          SELECT COUNT(*) INTO l_n FROM rvg_file
               WHERE rvg00 = g_rvc.rvc00
                 AND rvg01 = g_rvc.rvc01
                 AND rvgplant = g_rvc.rvcplant
          IF l_n IS NULL THEN LET l_n = 0 END IF
       END IF
 
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
       
       CALL t551_b_fill(" 1=1 ")
       CALL t551_b1_fill(" 1=1 ")
       #CALL t551_b2_fill(" 1=1 ")
       CALL t551_b2_fill(" 1=1 ")     #TQC-AC0138 add
    
       CALL t551_b()                                                                                                        
       CALL t551_b1()                                                                                                             
       CALL t551_b2()
       CALL t551_delall()
       EXIT WHILE
   END WHILE
END FUNCTION
FUNCTION t551_insrve()
DEFINE l_rvd03   LIKE rvd_file.rvd03
#TQC-AC0138 add begin--------------------
DEFINE l_lub01   LIKE lub_file.lub01
DEFINE l_lub02   LIKE lub_file.lub02
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_dbs     LIKE azp_file.azp03
DEFINE l_n       LIKE type_file.num5
#TQC-AC0138 add -end---------------------  
   LET g_sql = "SELECT DISTINCT rvd03 FROM rvd_file WHERE rvd00 = '",g_rvc.rvc00,"'",
               " AND rvd01 = '",g_rvc.rvc01,"' AND rvdplant = '",
               g_rvc.rvcplant,"'"
   PREPARE pre_get_rvd FROM g_sql
   DECLARE pre_rvd_cur CURSOR FOR pre_get_rvd
 
   LET g_cnt = 1     #TQC-AC0138 add 
   LET l_cnt = 1     #TQC-AC0138 add
  
   BEGIN WORK   
   #遍歷所有的對帳機構
   FOREACH pre_rvd_cur INTO l_rvd03
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF l_rvd03 IS NULL THEN CONTINUE FOREACH END IF
   #TQC-AC0138 mark begin--------------------
   #   LET g_sql = "SELECT lub01,lub02 FROM lub_file WHERE rub01 = rua01 ",
   #               "  AND rua15 = 'Y' AND rua17 BETWEEN '",g_rvc.rvc04,"'",
   #               " AND '",g_rvc.rvc05,"'"
   #END FOREACH
   #COMMIT WORK
   #TQC-AC0138 mark -end---------------------
   #TQC-AC0138 add begin--------------------
      LET g_plant_new = l_rvd03
      CALL s_gettrandbs()
      LET l_dbs=g_dbs_tra
      LET l_dbs = s_dbstring(l_dbs CLIPPED)

      LET g_sql = "SELECT lub01,lub02 ",
                  "  FROM ",cl_get_target_table(l_rvd03, 'lua_file'),",",cl_get_target_table(l_rvd03, 'lub_file'),
                  " WHERE lub01 = lua01 ",
                  "   AND lua15 = 'Y' AND lua06 = '",g_rvc.rvc03,"'",
        #          "   AND lua17 BETWEEN '",g_rvc.rvc04,"' AND '",g_rvc.rvc05,"'",          #TQC-AC0416   mark
                  "   AND lua09 BETWEEN '",g_rvc.rvc04,"' AND '",g_rvc.rvc05,"'",           #TQC-AC0416
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
          WHERE rve00 = '2' AND rve03 = l_rvd03
            AND rve05 = l_lub02 AND rve04 = l_lub01
          IF l_n > 0 THEN
             CONTINUE FOREACH
          END IF
         INSERT INTO rve_file(rve00,rve01,rve02,rve03,rve04,rve05,rve06,
                             rveplant,rvelegal)
                       VALUES('2',g_rvc.rvc01,g_cnt,l_rvd03,l_lub01,
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
   #TQC-AC0138 add -end---------------------
END FUNCTION
FUNCTION t551_insrvg()
DEFINE l_rvd03   LIKE rvd_file.rvd03
DEFINE l_ogb01   LIKE ogb_file.ogb01
DEFINE l_ogb03   LIKE ogb_file.ogb03
DEFINE l_ogb12   LIKE ogb_file.ogb12
DEFINE l_ohb01   LIKE ohb_file.ohb01
DEFINE l_ohb03   LIKE ohb_file.ohb03
DEFINE l_ohb12   LIKE ohb_file.ohb12
DEFINE l_sum     LIKE ohb_file.ohb12
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_dbs     LIKE azp_file.azp03
 
    #拿出所有的對帳機構
    LET g_sql = "SELECT DISTINCT rvd03 FROM rvd_file WHERE rvd00 = '",g_rvc.rvc00,"'",
                " AND rvd01 = '",g_rvc.rvc01,"' AND rvdplant = '",
                g_rvc.rvcplant,"'"
    PREPARE pre_get_rvd1 FROM g_sql
    DECLARE pre_rvd_cur1 CURSOR FOR pre_get_rvd1
   
    BEGIN WORK   
    #遍歷所有的對帳機構
    LET g_cnt = 1
   #LET l_cnt = 1  #FUN-A10008 MARK
    FOREACH pre_rvd_cur1 INTO l_rvd03
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF l_rvd03 IS NULL THEN CONTINUE FOREACH END IF
      #FUN-9C0075 ADD--------- 
      #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_rvd03
       LET g_plant_new = l_rvd03
       CALL s_gettrandbs()
       LET l_dbs=g_dbs_tra
       LET l_dbs = s_dbstring(l_dbs CLIPPED)
      #FUN-9C0075 END------------
       #LET g_sql = "SELECT rty02 FROM rty_file ",
       #            " WHERE rty01 = '",l_rvd03,"' AND ",
       #            "  rty05 = '",g_rvc.rvc03,"' AND rtyacti = 'Y' "
 
       #把出貨單審核過的資料insert 到銷售對帳單身
       LET g_sql = "SELECT DISTINCT ogb01,ogb03,ogb12 FROM ",
                   #l_dbs,"ogb_file,",l_dbs,"oga_file,",l_dbs,"rty_file ", #FUN-A50102
                   cl_get_target_table(l_rvd03, 'ogb_file'),",",cl_get_target_table(l_rvd03, 'oga_file'),",",cl_get_target_table(l_rvd03, 'rty_file'), #FUN-A50102
                   " WHERE ogb01 = oga01 AND ogaconf = 'Y' ",
                   "   AND ogacond BETWEEN '",g_rvc.rvc04,
                   "' AND '",g_rvc.rvc05,"'",
                   "   AND ogbplant = '",l_rvd03,"'",
                   " AND rty02 = ogb04 AND rty01 ='",l_rvd03,"' AND ",
                   "  rty05 = '",g_rvc.rvc03,"' AND rtyacti = 'Y' ",
                   " AND rty06=ogb44 AND rty06 = '",g_rvc.rvc02,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
       CALL cl_parse_qry_sql(g_sql, l_rvd03) RETURNING g_sql  #FUN-A50102            
       PREPARE pre_ogb FROM g_sql
       DECLARE pre_ogb_cur CURSOR FOR pre_ogb
       FOREACH pre_ogb_cur INTO l_ogb01,l_ogb03,l_ogb12
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          IF cl_null(l_ogb01) OR cl_null(l_ogb03) THEN CONTINUE FOREACH END IF
          
          #未對帳數量必須大于已經對帳數量之和
          SELECT SUM(rvg08) INTO l_sum FROM rvg_file,rvc_file 
               WHERE rvc00 = rvg00
                 AND rvc01 = rvg01
                 AND rvcplant= rvgplant
               # AND rvcconf = 'Y'  #TQC-B60250
                 AND rvcconf <> 'X' #TQC-B60250
                 AND rvg00 = g_rvc.rvc00 
                 AND rvg05 = l_ogb01 
                 AND rvg06 = l_ogb03
          IF l_sum IS NULL THEN LET l_sum = 0 END IF
          LET l_ogb12 = l_ogb12 - l_sum 
          IF l_ogb12 <= 0 THEN CONTINUE FOREACH END IF
          INSERT INTO rvg_file 
             VALUES(g_rvc.rvc00,g_rvc.rvc01,g_cnt,l_rvd03,'1',l_ogb01,l_ogb03,'Y',l_ogb12,g_rvc.rvclegal,g_rvc.rvcplant) #FUN-A10008 ADD LEGAL
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","rvg_file",g_rvc.rvc01,"",SQLCA.sqlcode,"","",1)
             ROLLBACK WORK
             RETURN
          END IF
          LET g_cnt = g_cnt + 1
       END FOREACH
 
       #把銷退單審核過的資料insert 到銷售對帳單身
       LET g_sql = "SELECT DISTINCT ohb01,ohb03,ohb12 ",
                   #"FROM ",l_dbs,"ohb_file,",l_dbs,"oha_file,",l_dbs,"rty_file ", #FUN-A50102
                   "FROM ",cl_get_target_table(l_rvd03, 'ohb_file'),",",cl_get_target_table(l_rvd03, 'oha_file'),",",cl_get_target_table(l_rvd03, 'rty_file'), #FUN-A50102
                   " WHERE oha01 = ohb01 AND ohaconf = 'Y' ",
                   "   AND ohacond BETWEEN '",g_rvc.rvc04,"' AND '",
                   g_rvc.rvc05,"' AND ohbplant = '",l_rvd03,"'",
                   " AND rty02 = ohb04 AND rty01 = '",l_rvd03,"'",
                   " AND rty05 = '",g_rvc.rvc03,"' AND rtyacti = 'Y' ",
                   " AND ohb64 = rty06 AND rty06 = '",g_rvc.rvc02,"'" 
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
       CALL cl_parse_qry_sql(g_sql, l_rvd03) RETURNING g_sql  #FUN-A50102          
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
             VALUES(g_rvc.rvc00,g_rvc.rvc01,g_cnt,l_rvd03,'2',l_ohb01,l_ohb03,'Y',l_ohb12,g_rvc.rvclegal,g_rvc.rvcplant) #FUN-A10008 ADD LEGAL
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","rvg_file",g_rvc.rvc01,"",SQLCA.sqlcode,"","",1)
             ROLLBACK WORK
             RETURN
          END IF
        # LET l_cnt = l_cnt + 1  #FUN-A10008 MARK
          LET g_cnt = g_cnt + 1  #FUN-A10008 ADD
       END FOREACH
    END FOREACH
 
    COMMIT WORK
END FUNCTION
 
FUNCTION tttl_insrvf()
DEFINE l_rvd03     LIKE rvd_file.rvd03
DEFINE l_rvv03     LIKE rvv_file.rvv03
DEFINE l_rvv01     LIKE rvv_file.rvv01
DEFINE l_rvv02     LIKE rvv_file.rvv02
DEFINE l_rvv17     LIKE rvv_file.rvv17
DEFINE l_sum       LIKE rvv_file.rvv17
DEFINE l_cnt       LIKE type_file.num5
DEFINE l_dbs     LIKE azp_file.azp03
 
    LET g_sql = "SELECT DISTINCT rvd03 FROM rvd_file WHERE rvd00 = '",g_rvc.rvc00,"'",
                " AND rvd01 = '",g_rvc.rvc01,"' AND rvdplant = '",
                g_rvc.rvcplant,"'"
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
 
      #FUN-9C0075 ADD------ 
      #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = = l_rvd03
       LET g_plant_new = l_rvd03
       CALL s_gettrandbs()
       LET l_dbs=g_dbs_tra
       LET l_dbs = s_dbstring(l_dbs CLIPPED)
      #FUN-9C0075 END---------- 
       LET g_sql = "SELECT rvv03,rvv01,rvv02,rvv17 ",
                   #"    FROM ",l_dbs,"rvv_file,",l_dbs,"rvu_file ",#FUN-A50102
                   "    FROM ",cl_get_target_table(l_rvd03, 'rvv_file'),",",cl_get_target_table(l_rvd03, 'rvu_file'),#FUN-A50102
                   "   WHERE rvv01 = rvu01 AND rvv03 = rvu00 ",
                   "     AND rvu04 = '",g_rvc.rvc03,"'",
      #            "     AND rvuconf = 'Y' AND rvucond BETWEEN '",  #FUN-B60150 MARK
      #            g_rvc.rvc04,"' AND '",g_rvc.rvc05,"'",           #FUN-B60150 MARK
                   "     AND rvuconf = 'Y' AND rvucond <= '",g_rvc.rvc05,"' ",  #FUN-B60150 ADD
      #TQC-B60065 Begin---
      #            " AND rvvplant = '",l_rvd03,"'",
      #            " AND rvu21 = '",g_rvc.rvc02,"'" 
                   " AND rvvplant = '",l_rvd03,"'"
       IF g_rvc.rvc02 = '2' THEN #根據參數sma146設置不同取不同的入庫單，後續處理
      #   LET g_sql = g_sql CLIPPED," AND rvu27 = '",g_rvc.rvc02,"'"   #FUN-B60150 MARK
#FUN-B60150 - ADD - BEGIN -----------------------------------------------------------------
          IF g_sma.sma146 = '1' THEN
             LET g_sql = g_sql CLIPPED," AND (rvu27 = '1' OR rvu27 = '') AND rvu21 = '2' "
          ELSE
             LET g_sql = g_sql CLIPPED," AND rvu27 = '2' "
          END IF
#FUN-B60150 - ADD -  END  -----------------------------------------------------------------
       ELSE                     #扣率代銷取虛擬類型='3'的資料
          LET g_sql = g_sql CLIPPED," AND rvu27 = '",g_rvc.rvc02,"'" 
        END IF
      #TQC-B60065 End-----
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
       CALL cl_parse_qry_sql(g_sql, l_rvd03) RETURNING g_sql  #FUN-A50102            
       PREPARE pre_rvv FROM g_sql
       DECLARE pre_rvv_cur CURSOR FOR pre_rvv   
       FOREACH pre_rvv_cur INTO l_rvv03,l_rvv01,l_rvv02,l_rvv17 
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          IF cl_null(l_rvv03) OR cl_null(l_rvv01) OR cl_null(l_rvv02) THEN CONTINUE FOREACH END IF
          
          #未對帳數量必須大于已經對帳數量之和
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

         #FUN-9C0133  MARK & ADD START--------------------------------- 
         #IF l_rvv03 = '4' THEN
         #   INSERT INTO rvf_file VALUES(g_rvc.rvc00,g_rvc.rvc01,g_cnt,l_rvd03,'4',
         #                                l_rvv01,l_rvv02,'Y',l_rvv17,g_rvc.rvcplant)
         #END IF
         #IF l_rvv03 = '5' THEN
         #   INSERT INTO rvf_file VALUES(g_rvc.rvc00,g_rvc.rvc01,g_cnt,l_rvd03,'5',
         #                                l_rvv01,l_rvv02,'Y',l_rvv17,g_rvc.rvcplant)
         #END IF
             INSERT INTO rvf_file VALUES(g_rvc.rvc00,g_rvc.rvc01,g_cnt,l_rvd03,l_rvv03,
                                          l_rvv01,l_rvv02,'Y',l_rvv17,g_rvc.rvclegal,g_rvc.rvcplant) #FUN-A10008 ADD LEGAL
         #FUN-9C0133  MARK & ADD END------------------------------------
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
FUNCTION t551_org()
 
    IF cl_null(g_rvc.rvc00) OR cl_null(g_rvc.rvc01)
       OR cl_null(g_rvc.rvcplant) THEN
       RETURN
    END IF
 
    LET p_row = 4 LET p_col = 10
    OPEN WINDOW t551_1_w AT p_row,p_col WITH FORM "art/42f/artt551_1"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
  
    CALL cl_ui_init()
    
    CALL t551_1_fill(" 1=1 ")
    CALL t551_1_b()
    CALL t551_1_menu()
    CLOSE WINDOW t551_1_w
    LET g_action_choice = ""
END FUNCTION
FUNCTION t551_1_menu()
WHILE TRUE
      CALL t551_1_bp("G")
      CASE g_action_choice
#TQC-B60163 ---------------------start----------------------------         
#         WHEN "query"
#            IF cl_chk_act_auth() THEN
#               CALL t551_1_q()
#            END IF
#TQC-B60163 --------------------end-------------------------------
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t551_1_b()
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
FUNCTION t551_1_bp(p_ud)
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
 
#TQC-B60163 ---------------------start----------------------------
#      ON ACTION query
#         LET g_action_choice="query"
#         EXIT DISPLAY
#TQC-B60163 --------------------end-------------------------------
 
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
FUNCTION t551_1_q()
 
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
   CALL t551_1_fill(g_wc3)
END FUNCTION 
FUNCTION t551_1_b()
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
                     " WHERE rvd00 = '",g_rvc.rvc00,"' AND rvd01 = '",g_rvc.rvc01,"'",
                     "   AND rvdplant = '",g_rvc.rvcplant,"'",
                     "   AND rvd02 = ? FOR UPDATE  "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t551_1_bcl CURSOR FROM g_forupd_sql
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
             OPEN t551_1_bcl USING g_rvd_t.rvd02
             IF STATUS THEN
                CALL cl_err("OPEN t551_1_bcl:",STATUS,1)
                LET l_lock_sw='Y'
             ELSE
                FETCH t551_1_bcl INTO g_rvd[l_ac3].*
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_rvd_t.rvd02,SQLCA.sqlcode,1)
                   LET l_lock_sw="Y"
                END IF
                CALL t551_rvd03()
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
               WHERE rvd01 = g_rvc.rvc01 AND rvd00 = g_rvc.rvc00
                 AND rvdplant = g_rvc.rvcplant
             IF g_rvd[l_ac3].rvd02 IS NULL THEN LET g_rvd[l_ac3].rvd02 = 1 END IF
          END IF
       AFTER FIELD rvd02 
          IF NOT cl_null(g_rvd[l_ac3].rvd02) THEN
             IF g_rvd[l_ac3].rvd02 != g_rvd_t.rvd02
                OR g_rvd_t.rvd02 IS NULL THEN
                SELECT count(*) INTO l_n FROM rvd_file
                   WHERE rvd00 = g_rvc.rvc00 AND rvd01 = g_rvc.rvc01
                     AND rvd02 = g_rvd[l_ac3].rvd02 AND rvdplant = g_rvc.rvcplant
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_rvd[l_ac3].rvd02 = g_rvd_t.rvd02
                   NEXT FIELD rvd02
                END IF 
             END IF
          END IF    
 
       AFTER FIELD rvd03
          IF cl_null(g_rvd[l_ac3].rvd03) THEN  
             CALL cl_err('','aap-099',0)          #FUN-A10008 ADD
             NEXT FIELD rvd03                     #FUN-A10008 ADD
          ELSE
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
                CALL t551_rvd03()
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
              CLOSE t551_1_bcl
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
              CLOSE t551_1_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac3_t = l_ac3      #FUN-D30033 add
           CLOSE t551_1_bcl
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
                #LET g_qryparam.form ="q_tqb01_3"            #FUN-9B0025 MARK 
                #LET g_qryparam.where = "tqb01 IN ",g_auth   #FUN-9B0025 MARK
                 LET g_qryparam.form ="q_azp"                #FUN-9B0025 ADD
                 LET g_qryparam.where = " azp01 IN ",g_auth," "   #TQC-AC0138 add
                 LET g_qryparam.default1 = g_rvd[l_ac3].rvd03
                 CALL cl_create_qry() RETURNING g_rvd[l_ac3].rvd03
                 DISPLAY BY NAME g_rvd[l_ac3].rvd03
                 CALL t551_rvd03()
                 NEXT FIELD rvd03
           END CASE
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
    END INPUT
    CLOSE t551_1_bcl
    COMMIT WORK
END FUNCTION
FUNCTION t551_rvd03()
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
         #FUN-9B0025 MARK & ADD START------------    
         #CALL s_find_down_org(g_rvd[l_ac3].rvd03) RETURNING l_auth
         #LET g_sql = "SELECT COUNT(*) FROM azw_file WHERE azw01 = '",
         #            g_rvd[l_ac3].rvd03,"' AND azw01 IN ",l_auth
         #PREPARE pre_azw FROM g_sql
         #EXECUTE pre_azw INTO l_n
        #TQC-C80151 mark begin ---
         # SELECT COUNT(*) INTO l_n FROM azp_file
         #  WHERE azp01 IN (SELECT azw01 FROM azw_file
         #                   WHERE azw07=g_rvc.rvcplant OR azw01=g_rvc.rvcplant)
         #  AND azp01 = g_rvd[l_ac3].rvd03 
         ##FUN-9B0025 MARK &ADD END--------- 
        #TQC-C80151 mark end ---
        #TQC-C80151 add begin ---
          LET l_sql = "SELECT COUNT(*) FROM azp_file ",
                      " WHERE azp01 IN ",g_auth,
                      "   AND azp01 = '",g_rvd[l_ac3].rvd03,"'"
          PREPARE t551_sel_azp01 FROM l_sql
          EXECUTE t551_sel_azp01 INTO l_n
         #TQC-C80151 add end ---
          IF l_n IS NULL THEN LET l_n = 0 END IF
          IF l_n = 0 THEN LET g_errno = 'art-500' END IF
       END IF
END FUNCTION
 
FUNCTION t551_1_bp_refresh()
  DISPLAY ARRAY g_rvd TO s_rvd.* ATTRIBUTE(COUNT=g_rec_b3,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
 
END FUNCTION
FUNCTION t551_1_fill(p_wc2)
DEFINE p_wc2   STRING
 
    LET g_sql = "SELECT rvd02,rvd03,'' FROM rvd_file ",
                " WHERE rvd01 ='",g_rvc.rvc01,"' AND rvd00 = '",g_rvc.rvc00,"'",
                "   AND rvdplant = '",g_rvc.rvcplant,"'"
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    LET g_sql=g_sql CLIPPED," ORDER BY rvd02 "
  
    PREPARE t551_1_pb FROM g_sql
    DECLARE rvd_1_cs CURSOR FOR t551_1_pb
 
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
   CALL t551_1_bp_refresh()
END FUNCTION
FUNCTION t551_delall()
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
 
   SELECT COUNT(*) INTO l_cnt2 FROM rvf_file                                                                                   
       WHERE rvf01=g_rvc.rvc01 
         AND rvf00 = g_rvc.rvc00
         AND rvfplant=g_rvc.rvcplant
   
   SELECT COUNT(*) INTO l_cnt3 FROM rve_file                                        
       WHERE rve01 = g_rvc.rvc01 
         AND rve00 = g_rvc.rvc00
         AND rveplant=g_rvc.rvcplant
 
   IF l_cnt1=0 AND l_cnt2=0 AND l_cnt3=0 THEN
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM rvc_file WHERE rvc01 = g_rvc.rvc01 
                             AND rvcplant = g_rvc.rvcplant
                             AND rvc00 = g_rvc.rvc00
      DELETE FROM rvd_file WHERE rvd00 = g_rvc.rvc00 AND rvd01 = g_rvc.rvc01
                             AND rvdplant = g_rvc.rvcplant
   END IF
 
END FUNCTION
 
FUNCTION t551_x()
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
   OPEN t551_cl USING g_rvc.rvc00,g_rvc.rvc01                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err("OPEN t551_cl:", STATUS, 1)                                                                                       
      CLOSE t551_cl       
      ROLLBACK WORK                                                                                                          
      RETURN                                                                                                                        
   END IF
   FETCH t551_cl INTO g_rvc.*                                                                                                       
   IF SQLCA.sqlcode THEN                                                                                                            
      CALL cl_err(g_rvc.rvc01,SQLCA.sqlcode,0)                                                                                      
      RETURN                                                                                                                        
   END IF
   LET g_success = 'Y'
   CALL t551_show()
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
 
   CLOSE t551_cl                                                                                                                    
                                                                                                                                    
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
 
FUNCTION t551_u()
 
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
   OPEN t551_cl USING g_rvc.rvc00,g_rvc.rvc01
   FETCH t551_cl INTO g_rvc.*
   IF SQLCA.SQLCODE THEN
      CALL cl_err(g_rvc.rvc01,SQLCA.SQLCODE,0)
      CLOSE t551_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   CALL t551_show()
   WHILE TRUE
      LET g_rvc01_t = g_rvc.rvc01
      LET g_rvc.rvcmodu=g_user
      LET g_rvc.rvcdate=g_today
      CALL t551_i("u")
      IF INT_FLAG THEN
          LET INT_FLAG = 0
          LET g_rvc.*=g_rvc_t.*
          CALL t551_show()
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
   CLOSE t551_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION t551_i(p_cmd)
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
     ,g_rvc.rvcoriu,g_rvc.rvcorig           #TQC-A30041 ADD
   
   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rvc.rvcplant     
   DISPLAY l_azp02 TO FORMONLY.rvcplant_desc
   
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_rvc.rvcconu
   DISPLAY l_gen02 TO FORMONLY.rvcconu_desc
   
   SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01 = g_rvc.rvc03
   DISPLAY l_pmc03 TO FORMONLY.rvc03_desc
   
   CALL cl_set_head_visible("","YES")
   INPUT BY NAME
         g_rvc.rvc01,g_rvc.rvc02,g_rvc.rvc03,g_rvc.rvc04,g_rvc.rvc05,g_rvc.rvc06
     
       WITHOUT DEFAULTS
 
       BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t551_set_entry(p_cmd)
           CALL t551_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
           CALL cl_set_docno_format("rvc01")
 
       AFTER FIELD rvc01
           IF NOT cl_null(g_rvc.rvc01) THEN
              IF (p_cmd='a') OR (p_cmd='u' AND g_rvc.rvc01!=g_rvc_t.rvc01) THEN
#                CALL s_check_no("art",g_rvc.rvc01,g_rvc01_t,"N","rvc_file","rvc00,rvc01,rvcplant","") #FUN-A70130 mark
                 CALL s_check_no("art",g_rvc.rvc01,g_rvc01_t,"E4","rvc_file","rvc00,rvc01,rvcplant","") #FUN-A70130 mod
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
                 CALL t551_rvc03()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD rvc03
                 END IF
              END IF
           END IF
 
       AFTER FIELD rvc05                                                                                                            
          IF NOT cl_null(g_rvc.rvc05) THEN                                                                                          
            #MOD-B50066 mark --start--
            #IF g_rvc.rvc05<g_today THEN
            #   CALL cl_err('','art-459',0)
            #   NEXT FIELD rvc05
            #END IF
            #MOD-B50066 mark --end--
            #MOD-B50066 add --start--
             IF g_rvc.rvc05 < g_rvc.rvc04 THEN
                CALL cl_err('','art-501',0)
                NEXT FIELD rvc05
             END IF
            #MOD-B50066 add --end--
          END IF
          
       ON ACTION controlp
          CASE 
             WHEN INFIELD(rvc01)
                LET g_t1=s_get_doc_no(g_rvc.rvc01)
#               CALL q_smy(FALSE,FALSE,g_t1,'ART','N') RETURNING g_t1  #FUN-A70130--mark--
                CALL q_oay(FALSE,FALSE,g_t1,'E4','ART') RETURNING g_t1  #FUN-A70130--mod--
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
#檢查供應商
FUNCTION t551_rvc03()
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
FUNCTION t551_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_rvc.* TO NULL
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt
   CALL t551_cs()
   IF INT_FLAG OR g_action_choice="exit" THEN
      LET INT_FLAG = 0
      INITIALIZE g_rvc.* TO NULL
      CALL g_rvg.clear()
      CALL g_rvf.clear()
      CALL g_rve.clear()
      RETURN
   END IF
 
   MESSAGE " SEARCHING ! "
   OPEN t551_cs
   IF SQLCA.SQLCODE THEN
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_rvc.* TO NULL
   ELSE
      OPEN t551_count
      FETCH t551_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t551_fetch('F')
   END IF
   MESSAGE ""
END FUNCTION
 
FUNCTION t551_fetch(p_flag)
   DEFINE   p_flag   LIKE type_file.chr1,
            l_abso   LIKE type_file.num10
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t551_cs INTO g_rvc.rvc00,g_rvc.rvc01
      WHEN 'P' FETCH PREVIOUS t551_cs INTO g_rvc.rvc00,g_rvc.rvc01
      WHEN 'F' FETCH FIRST    t551_cs INTO g_rvc.rvc00,g_rvc.rvc01
      WHEN 'L' FETCH LAST     t551_cs INTO g_rvc.rvc00,g_rvc.rvc01
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
         FETCH ABSOLUTE g_jump t551_cs INTO g_rvc.rvc00,g_rvc.rvc01
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.SQLCODE THEN
      INITIALIZE g_rvc.* TO NULL
      CALL g_rvg.clear()
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
      CALL g_rvg.clear()
      CALL g_rvf.clear()
      CALL g_rvf.clear()
      CALL g_rve.clear()
      CALL cl_err3("sel","rvc_file",g_rvc.rvc01,g_rvc.rvc02,SQLCA.SQLCODE,"","",1)  #No.FUN-660104
      RETURN
   END IF
   LET g_data_owner = g_rvc.rvcuser    #TQC-BB0125 add
   LET g_data_group = g_rvc.rvcgrup    #TQC-BB0125 add
   LET g_data_plant = g_rvc.rvcplant  #TQC-A10128 ADD 
   CALL t551_show()
END FUNCTION
 
FUNCTION t551_show()
   DEFINE l_odb02    LIKE odb_file.odb02
   DEFINE l_azp02    LIKE azp_file.azp02
   DEFINE l_gen02    LIKE gen_file.gen02
   DEFINE l_gem02    LIKE gem_file.gem02
   DEFINE l_pmc03    LIKE pmc_file.pmc03
 
   DISPLAY BY NAME
      g_rvc.rvc01,g_rvc.rvc02, g_rvc.rvc03,g_rvc.rvc04,g_rvc.rvc05,
      g_rvc.rvc06,g_rvc.rvcconf,g_rvc.rvccond,g_rvc.rvcconu,
      g_rvc.rvcplant,g_rvc.rvcuser,g_rvc.rvcmodu,g_rvc.rvcacti,
      g_rvc.rvcgrup,g_rvc.rvcdate,g_rvc.rvccrat
     ,g_rvc.rvcoriu,g_rvc.rvcorig      #TQC-A30041 ADD
   
   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rvc.rvcplant     
   DISPLAY l_azp02 TO FORMONLY.rvcplant_desc
   
   SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01 = g_rvc.rvc03
   DISPLAY l_pmc03 TO FORMONLY.rvc03_desc
 
   IF g_rvc.rvcconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF                                                                
   CALL cl_set_field_pic(g_rvc.rvcconf,"","","",g_chr,"")                                                                          
   CALL cl_flow_notify(g_rvc.rvc01,'V') 
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rvc.rvcconu
   DISPLAY l_gen02 TO FORMONLY.rvcconu_desc
   CALL t551_b_fill(g_wc1)
   CALL t551_b1_fill(g_wc2)
   CALL t551_b2_fill(g_wc3)
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION t551_b()
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
   DECLARE t551_bc1 CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
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
 
           OPEN t551_cl USING g_rvc.rvc00,g_rvc.rvc01
           IF STATUS THEN
              CALL cl_err("OPEN t551_cl:", STATUS, 1)
              CLOSE t551_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t551_cl INTO g_rvc.*
           IF SQLCA.SQLCODE THEN
              CALL cl_err(g_rvc.rvc01,SQLCA.SQLCODE,0)
              CLOSE t551_cl
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b>=l_ac THEN
              LET p_cmd='u'
              LET g_rvg_t.* = g_rvg[l_ac].*  #BACKUP
              LET l_lock_sw = 'N'              #DEFAULT
              OPEN t551_bc1 USING g_rvc.rvc01,g_rvg_t.rvg02
              IF STATUS THEN
                 CALL cl_err("OPEN t551_bc1:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t551_bc1 INTO g_rvg[l_ac].*
                 IF SQLCA.SQLCODE THEN
                    CALL cl_err(g_rvg_t.rvg03,SQLCA.SQLCODE , 1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL t551_b_get_data()
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
               WHERE rvg01 = g_rvc.rvc01 AND rvg00 = g_rvc.rvc00
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
              CLOSE t551_bc1
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
              CLOSE t551_bc1
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE t551_bc1
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
   CLOSE t551_bc1
   COMMIT WORK
END FUNCTION
#從出貨單或銷退單中讀數據
FUNCTION t551_b_get_data()
DEFINE l_sum     LIKE ohb_file.ohb12
DEFINE l_dbs     LIKE azp_file.azp03
 
    SELECT azp02,azp03 INTO g_rvg[l_ac].rvg03_desc FROM azp_file 
         WHERE azp01 = g_rvg[l_ac].rvg03
   #TQC-A10058 ADD----------------------
    LET g_plant_new = g_rvg[l_ac].rvg03
    CALL s_gettrandbs()
    LET l_dbs = g_dbs_tra
   #TQC-A10058 ADD----------------------  
    LET l_dbs = s_dbstring(l_dbs CLIPPED)
    
    IF g_rvg[l_ac].rvg04 = '1' THEN
       LET g_sql = "SELECT ogb04,ogb06,ogb05,ogb13,ogb12,ogb14,ogb14t ",
                   #" FROM ",l_dbs,"ogb_file ", #FUN-A50102
                   " FROM ",cl_get_target_table(g_rvg[l_ac].rvg03, 'ogb_file'), #FUN-A50102
                   " WHERE ogb01 = '",g_rvg[l_ac].rvg05,"'", 
                   "   AND ogb03 = '",g_rvg[l_ac].rvg06,"'",
                   "   AND ogbplant = '",g_rvg[l_ac].rvg03,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
       CALL cl_parse_qry_sql(g_sql, g_rvg[l_ac].rvg03) RETURNING g_sql  #FUN-A50102            
       PREPARE pre_ogb_sel FROM g_sql
       EXECUTE pre_ogb_sel INTO g_rvg[l_ac].ogb04_ohb04,g_rvg[l_ac].ogb06_ohb06,
                                g_rvg[l_ac].ogb05_ohb05,
                                g_rvg[l_ac].ogb13_ohb13,g_rvg[l_ac].ogb12_ohb12,
                                g_rvg[l_ac].ogb14_ohb14,g_rvg[l_ac].ogb14t_ohb14t
      ELSE
      	 LET g_sql = "SELECT ohb04,ohb06,ohb05,ohb13,ohb12,ohb14,ohb14t ",
                     #" FROM ",l_dbs,"ohb_file ", #FUN-A50102
                     " FROM ",cl_get_target_table(g_rvg[l_ac].rvg03, 'ohb_file'), #FUN-A50102
                     " WHERE ohb01 = '",g_rvg[l_ac].rvg05,"'", 
                     "   AND ohb03 = '",g_rvg[l_ac].rvg06,"'",
                     "   AND ohbplant = '",g_rvg[l_ac].rvg03,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
         CALL cl_parse_qry_sql(g_sql, g_rvg[l_ac].rvg03) RETURNING g_sql  #FUN-A50102            
         PREPARE pre_ohb_sel FROM g_sql
         EXECUTE pre_ohb_sel INTO g_rvg[l_ac].ogb04_ohb04,g_rvg[l_ac].ogb06_ohb06,
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
FUNCTION t551_b1()
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
        AND rvcplant=g_rvc.rvcplant
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
       "   AND rvf02=? AND rvfplant='",g_rvc.rvcplant,"'",
       " FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t551_bc2 CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
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
 
           OPEN t551_cl USING g_rvc.rvc00,g_rvc.rvc01
           IF STATUS THEN
              CALL cl_err("OPEN t551_cl:", STATUS, 1)
              CLOSE t551_cl
              ROLLBACK WORK
              RETURN
           END IF
           FETCH t551_cl INTO g_rvc.*
           IF SQLCA.SQLCODE THEN
              CALL cl_err(g_rvc.rvc01,SQLCA.SQLCODE,0)
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b1>=l_ac1 THEN
              LET g_rvf_t.* = g_rvf[l_ac1].*  #BACKUP
              LET p_cmd='u'
              OPEN t551_bc2 USING g_rvc.rvc01,g_rvf_t.rvf02
              IF STATUS THEN
                 CALL cl_err("OPEN t551_bc2:", STATUS, 1)
                 CLOSE t551_bc2
                 ROLLBACK WORK
                 RETURN
              END IF
              FETCH t551_bc2 INTO g_rvf[l_ac1].*
              IF SQLCA.SQLCODE THEN
                  CALL cl_err(g_rvf_t.rvf02,SQLCA.SQLCODE,1)
                  LET l_lock_sw = "Y"
              END IF
              CALL t551_b1_get_data()
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
              CLOSE t551_bc2
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
                   AND rvfplant=g_rvc.rvcplant
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
              CLOSE t551_bc2
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE t551_bc2
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
 
   CLOSE t551_bc2
   COMMIT WORK
END FUNCTION
FUNCTION t551_b1_get_data()
DEFINE l_sum     LIKE ohb_file.ohb12
DEFINE l_dbs     LIKE azp_file.azp03

     #FUN-9C0075 ADD---------------- 
     #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = g_rvf[l_ac1].rvf03
       LET g_plant_new = g_rvf[l_ac1].rvf03
       CALL s_gettrandbs()
       LET l_dbs=g_dbs_tra
       LET l_dbs = s_dbstring(l_dbs CLIPPED)
     #FUN-9C0075 END------------ 
      LET g_sql = "SELECT rvv31,rvv031,rvv35,rvv38,rvv38t,rvv17,rvv39,rvv39t ",
                  #" FROM ",l_dbs,"rvv_file ", #FUN-A50102
                  " FROM ",cl_get_target_table(g_rvf[l_ac1].rvf03, 'rvv_file'), #FUN-A50102
                  " WHERE rvv01 = '",g_rvf[l_ac1].rvf05,"'", 
                  "   AND rvv02 = '",g_rvf[l_ac1].rvf06,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
      CALL cl_parse_qry_sql(g_sql, g_rvf[l_ac1].rvf03) RETURNING g_sql  #FUN-A50102            
      PREPARE pre_rvv_sel FROM g_sql    
      EXECUTE pre_rvv_sel INTO g_rvf[l_ac1].rvv31,g_rvf[l_ac1].rvv031,
                               g_rvf[l_ac1].rvv35,g_rvf[l_ac1].rvv38,
                               g_rvf[l_ac1].rvv38t,g_rvf[l_ac1].rvv17,
                               g_rvf[l_ac1].rvv39,g_rvf[l_ac1].rvv39t
          
      SELECT azp02 INTO g_rvf[l_ac1].rvf03_desc 
         FROM azp_file WHERE azp01 = g_rvf[l_ac1].rvf03
         
      SELECT gfe02 INTO g_rvf[l_ac1].rvv35_desc FROM gfe_file 
         WHERE gfe01 = g_rvf[l_ac1].rvv35
 
      #計算該單、項次已經對帳數量
      SELECT SUM(rvf08) INTO l_sum FROM rvf_file,rvc_file 
               WHERE rvc00 = rvf00
                 AND rvc01 = rvf01
                 AND rvcplant= rvfplant
                 AND rvcconf = 'Y'
                 AND rvf00 = g_rvc.rvc00 
                 AND rvf05 = g_rvf[l_ac1].rvf05 
                 AND rvf06 = g_rvf[l_ac1].rvf06
                 AND rvfplant = g_rvf[l_ac1].rvf03
 
      IF l_sum IS NULL THEN LET l_sum = 0 END IF
      LET g_rvf[l_ac1].num_uncheck = g_rvf[l_ac1].rvv17 - l_sum 
END FUNCTION
FUNCTION t551_b2()
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
 
  #LET g_forupd_sql = "SELECT rve02,rve03,'',rvf04,rve05,",               #TQC-AC0138 mark
  #LET g_forupd_sql = "SELECT rve02,rve03,'',rve04,'','',rve05,",         #TQC-AC0138 add
   LET g_forupd_sql = "SELECT rve02,rve03,'',rve04,rve05,'','',",         #FUN-BC0124 add 
                  #    "'','','','','',rve06 ",     #FUN-A80105
                      "'','','','',rve06 ",        #FUN-A80105               
                      "  FROM rve_file ",
                      " WHERE rve01=? AND rve00='",g_rvc.rvc00,"'",
                      "   AND rve02=? AND rveplant='",g_rvc.rvcplant,"'",
                      "   FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t551_bc3 CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
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
 
           OPEN t551_cl USING g_rvc.rvc00,g_rvc.rvc01
           IF STATUS THEN
              CALL cl_err("OPEN t551_cl:", STATUS, 1)
              CLOSE t551_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t551_cl INTO g_rvc.*
           IF SQLCA.SQLCODE THEN
              CALL cl_err(g_rvc.rvc01,SQLCA.SQLCODE,0)
              CLOSE t551_cl
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b2>=l_ac2 THEN
              LET p_cmd='u'
              LET g_rve_t.* = g_rve[l_ac2].*   #BACKUP
              LET l_lock_sw = 'N'              #DEFAULT
              OPEN t551_bc3 USING g_rvc.rvc01,g_rve_t.rve02
              IF STATUS THEN
                 CALL cl_err("OPEN t551_bc3:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t551_bc3 INTO g_rve[l_ac2].*
                 IF SQLCA.SQLCODE THEN
                    CALL cl_err(g_rve_t.rve02,SQLCA.SQLCODE , 1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL t551_b2_get_data()
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
           INSERT INTO rvf_file(rve00,rve01,rve02,rve03,rve04,rve05,rve06,rveplant,rvelegal)
                         VALUES(g_rvc.rvc00,g_rvc.rvc01,g_rve[l_ac2].rve02,
                         g_rve[l_ac2].rve03,g_rve[l_ac2].rve04,g_rve[l_ac2].rve05,
                         g_rve[l_ac2].rve06,g_rvc.rvcplant,g_rvc.rvclegal)                               
           IF SQLCA.SQLCODE THEN
              CALL cl_err3("ins","rvf_file",g_rvc.rvc01,g_rvc.rvcplant,SQLCA.SQLCODE,"","",1)
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
              CLOSE t551_bc3
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
              CLOSE t551_bc3
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE t551_bc3
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
   CLOSE t551_bc3
   COMMIT WORK
END FUNCTION
FUNCTION t551_b2_get_data()
DEFINE l_sql   STRING    #TQC-AC0138 ADD

   SELECT azp02 INTO g_rve[l_ac2].rve03_desc              #TQC-AC0138 ADD
     FROM azp_file WHERE azp01 = g_rve[l_ac2].rve03       #TQC-AC0138 ADD

   #SELECT lua02,lua24 INTO g_rve[l_ac2].lua02,g_rve[l_ac2].lua24  #TQC-AC0138 ADD
   #  FROM lua_file WHERE lua01 = g_rve[l_ac2].rve04               #TQC-AC0138 ADD
   #TQC-AC0138 add -begin----------------------
  #LET l_sql = "SELECT lua02,lua24,lub03,lub04,lub04t ",
   LET l_sql = "SELECT lub09,lub14,lub03,lub04,lub04t ",   #FUN-BC0124 lua02,lua24-->lub09,lub14
               "  FROM ",cl_get_target_table(g_rve[l_ac2].rve03, 'lua_file'),
               "      ,",cl_get_target_table(g_rve[l_ac2].rve03, 'lub_file'),
               " WHERE lua01 = '",g_rve[l_ac2].rve04,"'",
               "   AND lua01 = lub01 AND lub02 = '",g_rve[l_ac2].rve05,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql, g_rve[l_ac2].rve03) RETURNING l_sql
   PREPARE pre_sel_lua1 FROM l_sql
  #EXECUTE pre_sel_lua1 INTO g_rve[g_cnt].lua02,g_rve[g_cnt].lua24,
   EXECUTE pre_sel_lua1 INTO g_rve[l_ac2].lub09,g_rve[l_ac2].lub14,  #FUN-BC0124 lua02,lua24-->lub09,lub14
                            g_rve[l_ac2].lub03,g_rve[l_ac2].lub04,
                            g_rve[l_ac2].lub04t
   
   LET l_sql = "SELECT oaj02 FROM ",cl_get_target_table(g_rve[l_ac2].rve03, 'oaj_file'),
                  " WHERE oaj01 = '",g_rve[l_ac2].lub03,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, g_rve[l_ac2].rve03) RETURNING l_sql
      PREPARE pre_sel_oaj1 FROM l_sql
      EXECUTE pre_sel_oaj1 INTO g_rve[l_ac2].oaj02
   #TQC-AC0138 add --end-----------------------
END FUNCTION
FUNCTION t551_b_fill(p_wc)
DEFINE l_sql   STRING
DEFINE p_wc    STRING   
DEFINE l_sum     LIKE ohb_file.ohb12
DEFINE l_dbs     LIKE azp_file.azp03
DEFINE l_rvd03   LIKE rvd_file.rvd03
 
   LET l_sql = "SELECT rvg02,rvg03,'',rvg04,rvg05,rvg06,",
               "'','','','','','','','','',rvg07,rvg08 ",
               "  FROM rvg_file ",
               "WHERE rvg01 = '",g_rvc.rvc01,"' AND rvg00 ='",g_rvc.rvc00,"'",
               " AND rvgplant='",g_rvc.rvcplant,"'"
               
   IF NOT cl_null(p_wc) THEN
      LET l_sql = l_sql," AND ",p_wc," ORDER BY rvg03"
   ELSE
      LET l_sql = l_sql," ORDER BY rvg02"
   END IF
   DECLARE t551_cr1 CURSOR FROM l_sql
   CALL g_rvg.clear()
 
   LET g_rec_b = 0
   LET g_cnt = 1
   FOREACH t551_cr1 INTO g_rvg[g_cnt].*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF
      SELECT azp02 INTO g_rvg[g_cnt].rvg03_desc FROM azp_file 
         WHERE azp01 = g_rvg[g_cnt].rvg03

     #FUN-9C0075 ADD-------------         
     #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = g_rvg[g_cnt].rvg03
       LET g_plant_new = g_rvg[g_cnt].rvg03  
       CALL s_gettrandbs()
       LET l_dbs=g_dbs_tra
      LET l_dbs = s_dbstring(l_dbs CLIPPED)
     #FUN-9C0075 end-----------
      IF g_rvg[g_cnt].rvg04 = '1' THEN
         LET l_sql = "SELECT ogb04,ogb06,ogb05,ogb13,ogb12,ogb14,ogb14t ",
                     #" FROM ",l_dbs,"ogb_file ", #FUN-A50102
                     " FROM ",cl_get_target_table(g_rvg[g_cnt].rvg03, 'ogb_file'), #FUN-A50102
                     " WHERE ogb01 = '",g_rvg[g_cnt].rvg05,"'",
                     "   AND ogb03 = '",g_rvg[g_cnt].rvg06,"'",
                     "   AND ogbplant = '",g_rvg[g_cnt].rvg03,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
         CALL cl_parse_qry_sql(l_sql, g_rvg[g_cnt].rvg03) RETURNING l_sql  #FUN-A50102            
         PREPARE pre_sel_ogb FROM l_sql
         EXECUTE pre_sel_ogb INTO g_rvg[g_cnt].ogb04_ohb04,g_rvg[g_cnt].ogb06_ohb06,
                                  g_rvg[g_cnt].ogb05_ohb05,
                                  g_rvg[g_cnt].ogb13_ohb13,g_rvg[g_cnt].ogb12_ohb12,
                                  g_rvg[g_cnt].ogb14_ohb14,g_rvg[g_cnt].ogb14t_ohb14t
      ELSE
         LET l_sql = "SELECT ohb04,ohb06,ohb05,ohb13,ohb12,ohb14,ohb14t ",
                     #" FROM ",l_dbs,"ohb_file ", #FUN-A50102
                     " FROM ",cl_get_target_table(g_rvg[g_cnt].rvg03, 'ohb_file'), #FUN-A50102
                     " WHERE ohb01 = '",g_rvg[g_cnt].rvg05,"'", 
                     "   AND ohb03 = '",g_rvg[g_cnt].rvg06,"'",
                     "   AND ohbplant = '",g_rvg[g_cnt].rvg03,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
         CALL cl_parse_qry_sql(l_sql, g_rvg[g_cnt].rvg03) RETURNING l_sql  #FUN-A50102            
         PREPARE pre_sel_ohb FROM l_sql
         EXECUTE pre_sel_ohb INTO g_rvg[g_cnt].ogb04_ohb04,g_rvg[g_cnt].ogb06_ohb06,
                                  g_rvg[g_cnt].ogb05_ohb05,
                                  g_rvg[g_cnt].ogb13_ohb13,g_rvg[g_cnt].ogb12_ohb12,
                                  g_rvg[g_cnt].ogb14_ohb14,g_rvg[g_cnt].ogb14t_ohb14t
      END IF
      
      #計算該單、項次已經對帳數量
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
   CLOSE t551_cr1
   CALL t551_bp_refresh()
END FUNCTION
 
FUNCTION t551_bp_refresh()
  DISPLAY ARRAY g_rvg TO s_rvg.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
END FUNCTION
 
FUNCTION t551_b2_fill(p_wc)
DEFINE l_sql,p_wc        STRING
DEFINE l_dbs     LIKE azp_file.azp03
DEFINE l_rvd03   LIKE rvd_file.rvd03
 
   #LET l_sql = "SELECT rve02,rve03,'',rve04,rve05,'','', ",          #TQC-AC0138 mark
   #LET l_sql = "SELECT rve02,rve03,'',rve04,'','',rve05,'','', ",    #TQC-AC0138 add lua02,lua24
   LET l_sql = "SELECT rve02,rve03,'',rve04,rve05,'','','','', ",     #FUN-BC0124 add  
              # " '','','',rve06 ",     #FUN-A80105
               " '','',rve06 ",         #FUN-A80105         
               " FROM rve_file ",    #FUN-9C0133 ADD
               "WHERE rve01 = '",g_rvc.rvc01,"' AND rve00 ='",g_rvc.rvc00,"'",
               " AND rveplant='",g_rvc.rvcplant,"'"
               
   IF NOT cl_null(p_wc) THEN
      LET l_sql = l_sql," AND ",p_wc," ORDER BY rve02"
   ELSE
      LET l_sql = l_sql," ORDER BY rve02"
   END IF
   DECLARE t551_cr3 CURSOR FROM l_sql
 
   CALL g_rve.clear()
   LET g_rec_b2 = 0
 
   LET g_cnt = 1
 
   FOREACH t551_cr3 INTO g_rve[g_cnt].*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF
      #TQC-AC0138 mark -begin--------------------
      #SELECT lub03,lub04,lub04t 
      #  INTO g_rve[g_cnt].lub03,g_rve[g_cnt].lub04,
      #       g_rve[g_cnt].lub04t 
      #  FROM lub_file
      # WHERE lub01 = g_rve[g_cnt].rve04
      #   AND lub02 = g_rve[g_cnt].rve05

      #SELECT lua02,lua24 INTO g_rve[g_cnt].lua02,g_rve[g_cnt].lua24 #TQC-AC0138 ADD
      #  FROM lua_file                                               #TQC-AC0138 ADD
      # WHERE lua01 = g_rve[g_cnt].rve04                             #TQC-AC0138 ADD

#      SELECT oaj02,oaj06                            #FUN-A80105
#        INTO g_rve[g_cnt].oaj02,g_rve[g_cnt].oaj06  #FUN-A80105
      #SELECT oaj02                           #FUN-A80105
      #  INTO g_rve[g_cnt].oaj02              #FUN-A80105
      #  FROM oaj_file 
      # WHERE oaj01 = g_rve[g_cnt].lub03
      #TQC-AC0138 mark --end---------------------
      
      SELECT azp02 INTO g_rve[g_cnt].rve03_desc
        FROM azp_file WHERE azp01 = g_rve[g_cnt].rve03  
      
      #TQC-AC0138 add -begin----------------------
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
      #TQC-AC0138 add --end-----------------------  
      LET g_cnt=g_cnt+1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_rve.deleteElement(g_cnt)
   LET g_rec_b2 = g_cnt - 1
   LET g_cnt = 1
 
   CLOSE t551_cr3
   CALL t551_bp2_refresh()
END FUNCTION
 
FUNCTION t551_bp2_refresh()
 #DISPLAY ARRAY g_rvf TO s_rve.* ATTRIBUTE(COUNT = g_rec_b2,UNBUFFERED)   #FUN-9C0163 MARK
  DISPLAY ARRAY g_rve TO s_rve.* ATTRIBUTE(COUNT = g_rec_b2,UNBUFFERED)   #FUN-9C0163 ADD
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
END FUNCTION
 
FUNCTION t551_b1_fill(p_wc)
DEFINE l_sql      STRING
DEFINE p_wc       STRING
DEFINE l_sum     LIKE ohb_file.ohb12
DEFINE l_dbs     LIKE azp_file.azp03
DEFINE l_rvd03   LIKE rvd_file.rvd03
 
   LET l_sql = "SELECT rvf02,rvf03,'',rvf04,rvf05,rvf06,",
               "'','','','','', '','','','','',rvf07,rvf08 ",
               " FROM rvf_file ",
               "WHERE rvf01 = '",g_rvc.rvc01,"' AND rvf00 ='",g_rvc.rvc00,"'",
               " AND rvfplant='",g_rvc.rvcplant,"'"
               
   IF NOT cl_null(p_wc) THEN
      LET l_sql = l_sql," AND ",p_wc," ORDER BY rvf02"
   ELSE
   	  LET l_sql = l_sql," ORDER BY rvf02"
   END IF
   DECLARE t551_cr2 CURSOR FROM l_sql
 
   CALL g_rvf.clear()
   LET g_rec_b1 = 0
   LET g_cnt = 1
 
   FOREACH t551_cr2 INTO g_rvf[g_cnt].*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF
     #FUN-9C0075 ADD--------
     #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = g_rvf[g_cnt].rvf03
       LET g_plant_new = g_rvf[g_cnt].rvf03 
       CALL s_gettrandbs()
       LET l_dbs=g_dbs_tra 
       LET l_dbs = s_dbstring(l_dbs CLIPPED)
     #FUN-9C0075 END---------
      LET l_sql = "SELECT rvv31,rvv031,rvv35,rvv38,rvv38t,rvv17,rvv39,rvv39t ",
                  #"FROM ",l_dbs,"rvv_file ", #FUN-A50102
                  "FROM ",cl_get_target_table(g_rvf[g_cnt].rvf03, 'rvv_file'), #FUN-A50102
                  " WHERE rvv01 = '",g_rvf[g_cnt].rvf05,"'", 
                  "   AND rvv02 = '",g_rvf[g_cnt].rvf06,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
      CALL cl_parse_qry_sql(l_sql, g_rvf[g_cnt].rvf03) RETURNING l_sql  #FUN-A50102           
      PREPARE pre_sel_rvv FROM l_sql   
      EXECUTE pre_sel_rvv INTO g_rvf[g_cnt].rvv31,g_rvf[g_cnt].rvv031,
                               g_rvf[g_cnt].rvv35,g_rvf[g_cnt].rvv38,
                               g_rvf[g_cnt].rvv38t,g_rvf[g_cnt].rvv17,
                               g_rvf[g_cnt].rvv39,g_rvf[g_cnt].rvv39t
          
      #計算該單、項次已經對帳數量
      SELECT SUM(rvf08) INTO l_sum FROM rvf_file,rvc_file 
          WHERE rvc00 = rvf00
            AND rvc01 = rvf01
            AND rvcplant= rvfplant
            AND rvcconf = 'Y'
            AND rvf00 = g_rvc.rvc00 
            AND rvf05 = g_rvf[g_cnt].rvf05 
            AND rvf06 = g_rvf[g_cnt].rvf06
            AND rvfplant = g_rvf[g_cnt].rvf03
 
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
   CLOSE t551_cr2
   CALL t551_bp1_refresh()
END FUNCTION
 
FUNCTION t551_bp1_refresh()
  DISPLAY ARRAY g_rvf TO s_rvf.* ATTRIBUTE(COUNT = g_rec_b1,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
END FUNCTION
 
FUNCTION t551_bp(p_ud)
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
            CALL t551_b_fill(g_wc1)
            CALL t551_bp_refresh()
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
 
      #ON ACTION reproduce
      #   LET g_action_choice="reproduce"
      #   EXIT DISPLAY
 
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
         CALL t551_fetch('F')
         EXIT DISPLAY
 
      ON ACTION previous
         CALL t551_fetch('P')
         EXIT DISPLAY
 
      ON ACTION jump
         CALL t551_fetch('/')
         EXIT DISPLAY
 
      ON ACTION next
         CALL t551_fetch('N')
         EXIT DISPLAY
 
      ON ACTION last
         CALL t551_fetch('L')
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

      #FUN-D20039 ----------sta
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20039 ----------end
 
      ON ACTION curr_plant
         LET g_action_choice = "curr_plant"
         EXIT DISPLAY
 
      ON ACTION scale
         LET g_b_flag = '1'
         LET g_action_choice = "scale"
         EXIT DISPLAY
 
      ON ACTION in_store
         LET g_b_flag = '2'
         LET g_action_choice = "in_store"
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
 
FUNCTION t551_bp2(p_ud)
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
 
      ON ACTION output                                                                                                              
         LET g_action_choice="output"                                                                                               
         EXIT DISPLAY
 
      ON ACTION first
         CALL t551_fetch('F')
         EXIT DISPLAY
 
      ON ACTION previous
         CALL t551_fetch('P')
         EXIT DISPLAY
 
      ON ACTION jump
         CALL t551_fetch('/')
         EXIT DISPLAY
 
      ON ACTION next
         CALL t551_fetch('N')
         EXIT DISPLAY
 
      ON ACTION last
         CALL t551_fetch('L')
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
      ON ACTION scale
         LET g_b_flag = '1'
         LET g_action_choice = "scale"
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
 
FUNCTION t551_bp1(p_ud)
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
 
      ON ACTION output                                                                                                              
         LET g_action_choice="output"                                                                                               
         EXIT DISPLAY
 
      ON ACTION first
         CALL t551_fetch('F')
         EXIT DISPLAY
 
      ON ACTION previous
         CALL t551_fetch('P')
         EXIT DISPLAY
 
      ON ACTION jump
         CALL t551_fetch('/')
         EXIT DISPLAY
 
      ON ACTION next
         CALL t551_fetch('N')
         EXIT DISPLAY
 
      ON ACTION last
         CALL t551_fetch('L')
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
 
      ON ACTION scale
         LET g_b_flag = '1'
         LET g_action_choice = "scale"
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
 
FUNCTION t551_r()
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
   OPEN t551_cl USING g_rvc.rvc00,g_rvc.rvc01
   FETCH t551_cl INTO g_rvc.*
   IF SQLCA.SQLCODE THEN
      CALL cl_err(g_rvc.rvc01,SQLCA.SQLCODE,0)
      CLOSE t551_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   LET g_rvc_t.* = g_rvc.*
   CALL t551_show()
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
         CALL cl_err3("del","rvg_file",g_rvc.rvc01,g_rvc.rvcplant,SQLCA.SQLCODE,"","(t551_r:delete rvg)",1)
         LET g_success='N'
      END IF
      
      DELETE FROM rvg_file 
         WHERE rvg01 = g_rvc.rvc01 
           AND rvgplant = g_rvc.rvcplant
           AND rvg00 = g_rvc.rvc00
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","rvg_file",g_rvc.rvc01,g_rvc.rvcplant,SQLCA.SQLCODE,"","(t551_r:delete rvg)",1)
         LET g_success='N'
      END IF
 
      DELETE FROM rvf_file 
         WHERE rvf01 = g_rvc.rvc01 
           AND rvfplant = g_rvc.rvcplant
           AND rvf00 = g_rvc.rvc00
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","rvf_file",g_rvc.rvc01,g_rvc.rvcplant,SQLCA.SQLCODE,"","(t551_r:delete rvf)",1)  #No.FUN-660104
         LET g_success='N'
      END IF
      DELETE FROM rve_file WHERE rve00 = g_rvc.rvc00 AND rve01 = g_rvc.rvc01 AND rveplant = g_rvc.rvcplant
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","rve_file",g_rvc.rvc01,g_rvc.rvcplant,SQLCA.SQLCODE,"","(t551_r:delete rvf)",1)  #No.FUN-660104
         LET g_success='N'
      END IF
      DELETE FROM rvd_file WHERE rvd00 = g_rvc.rvc00 AND rvd01 = g_rvc.rvc01 AND rvdplant = g_rvc.rvcplant
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","rvd_file",g_rvc.rvc01,g_rvc.rvcplant,SQLCA.SQLCODE,"","(t551_r:delete rvf)",1)  #No.FUN-660104
         LET g_success='N'
      END IF
 
      INITIALIZE g_rvc.* TO NULL
      IF g_success = 'Y' THEN
         COMMIT WORK
         CLEAR FORM                  #TQC-C50164 add
         LET g_rvc_t.* = g_rvc.*
         CALL g_rvg.clear()
         CALL g_rvf.clear()
         CALL g_rve.clear()
         OPEN t551_count
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE t551_cs
            CLOSE t551_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end--
         FETCH t551_count INTO g_row_count
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t551_cs
            CLOSE t551_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t551_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t551_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t551_fetch('/')
         END IF
      ELSE
         ROLLBACK WORK
         LET g_rvc.* = g_rvc_t.*
      END IF
   END IF
   CALL t551_show()
END FUNCTION
 
FUNCTION t551_copy()
   DEFINE  l_n                LIKE type_file.num5,
           l_rvc              RECORD LIKE rvc_file.*,
           l_oldno1,l_newno   LIKE rvc_file.rvc01,
           l_oldno            LIKE rvc_file.rvc01,
           l_old_plant        LIKE rvc_file.rvcplant,
           li_result    LIKE type_file.num5
  
   IF s_shut(0) THEN RETURN END IF
   IF g_rvc.rvc01 IS NULL OR g_rvc.rvc02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
  
   LET l_oldno = g_rvc.rvc01
   LET l_old_plant = g_rvc.rvcplant
 
   LET g_before_input_done = FALSE
   CALL t551_set_entry('a')
   CALL cl_set_head_visible("","YES")
   INPUT l_newno FROM rvc01
      AFTER FIELD rvc01
         IF cl_null(l_newno) THEN
            NEXT FIELD rvc01
         ELSE
#           CALL s_check_no("art",l_newno,"","N","rvc_file","rvc00,rvc01,rvcplant","") #FUN-A70130 mark
            CALL s_check_no("art",l_newno,"","E4","rvc_file","rvc00,rvc01,rvcplant","") #FUN-A70130 mod
               RETURNING li_result,l_newno
            IF (NOT li_result) THEN                                                                                            
               LET g_rvc.rvc01=g_rvc_t.rvc01                                                                                   
               NEXT FIELD rvc01                                                                                                
            END IF
            BEGIN WORK
#           CALL s_auto_assign_no("art",l_newno,g_today,"","rvc_file","rvc01","","","")   #FUN-A70130 mark                                  
            CALL s_auto_assign_no("art",l_newno,g_today,"E4","rvc_file","rvc01","","","")   #FUN-A70130 mod                                  
               RETURNING li_result,l_newno                                                                                        
            IF (NOT li_result) THEN
               ROLLBACK WORK                                                                                   
               NEXT FIELD rvc01
            ELSE
               COMMIT WORK                                                                                               
            END IF                                                                                                          
            DISPLAY l_newno TO rvc01
         END IF
   
      ON ACTION controlp                                                                                                           
          CASE                                                                                                                      
             WHEN INFIELD(rvc01)                                                                                                    
                LET g_t1=s_get_doc_no(l_newno)                                                                                  
                CALL q_oay(FALSE,FALSE,g_t1,'N','art') RETURNING g_t1        #FUN-A70130                                                      
                LET l_newno = g_t1                                                                                                
                DISPLAY l_newno TO rvc01                                                                                       
                NEXT FIELD rvc01                                                                                                    
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
      DISPLAY BY NAME g_rvc.rvc01,g_rvc.rvc02
      RETURN
   END IF
   BEGIN WORK
   #---------------COPY HEAD---------------
   DROP TABLE y
   SELECT * FROM rvc_file
    WHERE rvc01=g_rvc.rvc01 AND rvcplant=g_rvc.rvcplant AND rvc00 = g_rvc.rvc00
     INTO TEMP y
   UPDATE y
      SET rvc01 =l_newno,
          rvcconf ='N',
          rvccond=NULL,
          rvcconu=NULL,
          rvcuser=g_user,
          rvcgrup=g_grup,
          rvcoriu=g_user,     #TQC-A30041 ADD
          rvcorig=g_grup,     #TQC-A30041 ADD
          rvcmodu=NULL,
          rvcdate=NULL,
          rvccrat=g_today,
          rvcacti='Y',
          rvcplant = g_plant,
          rvclegal = g_legal
   INSERT INTO rvc_file SELECT * FROM y
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("ins","rvc_file",l_newno,'',SQLCA.SQLCODE,"","ins rvc:",1)  
      LET g_success = 'N'
      ROLLBACK WORK
      RETURN
   END IF
  
   #---------------COPY BODY(1)------------
   DROP TABLE x
   SELECT * FROM rvg_file
    WHERE rvg01=g_rvc.rvc01 AND rvgplant=g_rvc.rvcplant AND rvg00 = g_rvc.rvc00
     INTO TEMP x
   IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3] = 0 THEN
      LET g_msg=g_rvc.rvc01 CLIPPED,'+',g_rvc.rvc02 CLIPPED
      CALL cl_err3("ins","x",g_rvc.rvc01,g_rvc.rvcplant,SQLCA.SQLCODE,"",g_msg,1)  
      RETURN
   END IF
   UPDATE x SET rvg01 = l_newno,
                rvgplant = g_plant,
                rvglegal = g_legal
   INSERT INTO rvg_file SELECT * FROM x
   IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3] = 0 THEN
      LET g_msg=g_rvc.rvc01 CLIPPED,'+',g_rvc.rvc02 CLIPPED
      CALL cl_err3("ins","rvg_file",g_rvc.rvc01,g_rvc.rvc02,SQLCA.SQLCODE,"",g_msg,1) 
      ROLLBACK WORK
      RETURN
   END IF
   LET g_msg=l_newno CLIPPED
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
  
   #---------------COPY BODY(2)------------
   DROP TABLE z
   SELECT * FROM rvf_file
      WHERE rvf01=g_rvc.rvc01 
        AND rvfplant=g_rvc.rvcplant 
        AND rvf00 = g_rvc.rvc00
       INTO TEMP z
   IF SQLCA.SQLCODE THEN
      LET g_msg=g_rvc.rvc01 CLIPPED,'+',g_rvc.rvcplant CLIPPED
      CALL cl_err3("ins","z",g_rvc.rvc01,g_rvc.rvc02,SQLCA.SQLCODE,"",g_msg,1)
      ROLLBACK WORK
      RETURN
   END IF
   UPDATE z SET rvf01 = l_newno,
                rvfplant= g_plant
   INSERT INTO rvf_file SELECT * FROM z
   IF SQLCA.SQLCODE THEN
      LET g_msg=g_rvc.rvc01 CLIPPED,'+',g_rvc.rvc02 CLIPPED
      CALL cl_err3("ins","rvf_file",l_newno,'',SQLCA.SQLCODE,"",g_msg,1)
      ROLLBACK WORK
      RETURN
   END IF
   
   DROP TABLE w
   SELECT * FROM rve_file
      WHERE rve01=g_rvc.rvc01
        AND rve00 = g_rvc.rvc00
        AND rveplant = g_rvc.rvcplant
         
   COMMIT WORK
   SELECT rvc_file.* INTO g_rvc.* FROM rvc_file
      WHERE rvc01 = l_newno AND rvcplant = g_plant
        AND rvc00 = g_rvc.rvc00
      
   CALL t551_u()
   CALL t551_b()
   CALL t551_b1()
   CALL t551_b2()
   #FUN-C80046---begin
   #SELECT rvc_file.* INTO g_rvc.* FROM rvc_file 
   # WHERE rvc01 = l_oldno AND rvcplant = l_old_plant
   #     AND rvc00 = g_rvc.rvc00
   #CALL t551_show()
   #FUN-C80046---end
END FUNCTION
 
FUNCTION t551_out()
 
END FUNCTION
 
FUNCTION t551_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("rvc01,rvc02,rvc03,rvc04,rvc05",TRUE)
   END IF
END FUNCTION
 
FUNCTION t551_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("rvc01,rvc02,rvc03,rvc04,rvc05",FALSE)
   END IF
END FUNCTION
#TQC-9B0016 mod

