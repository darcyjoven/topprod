# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: artt603.4gl
# Descriptions...: 商品
# Date & Author..: NO.FUN-960130 09/10/07 By  Sunyanchun
# Modify.........: No:FUN-A10012 10/01/06 By destiny rxw03可以等于0 
# Modify.........: No.TQC-A10128 10/01/18 By Cockroach 添加g_data_plant管控
# Modify.........: No:TQC-A10131 10/01/19 By destiny rxn05开窗有错  
# Modify.........: No:TQC-A20011 10/01/26 By destiny 销售单订单单号不能重复
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A70130 10/08/06 By shaoyong  ART單據性質調整,q_smy改为q_oay
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管 
# Modify.........: No.FUN-AA0059 10/10/28 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No.FUN-AB0016 10/11/03 By houlia 倉庫權限使用控管修改
# Modify.........: No.FUN-B30012 11/03/10 By baogc 有關換贈信息修改
# Modify.........: No.FUN-B40006 11/04/12 By baogc 修改訂單欄位的相關邏輯
# Modify.........: No.FUN-B50064 11/06/08 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80085 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外
# Modify.........: No:FUN-BB0086 11/12/31 By tanxc 增加數量欄位小數取位
# Modify.........: No:TQC-C20183 12/02/20 By fengrui 數量欄位小數取位處理
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C80046 12/08/17 By bart 複製後停在新資料畫面
# Modify.........: No:FUN-C90049 12/10/19 By Lori 預設成本倉與非成本倉改從s_get_defstore取
# Modify.........: No:FUN-D20039 13/01/20 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」
# Modify.........: No:FUN-D30033 13/04/12 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE g_rxm         RECORD LIKE rxm_file.*,
       g_rxm_t       RECORD LIKE rxm_file.*,
       g_rxm_o       RECORD LIKE rxm_file.*,
       g_t1          LIKE oay_file.oayslip,
       g_rxn         DYNAMIC ARRAY OF RECORD
           rxn02          LIKE rxn_file.rxn02,
           rxn03          LIKE rxn_file.rxn03,
           rxn04          LIKE rxn_file.rxn04,
           rxn05          LIKE rxn_file.rxn05,
           rxn06          LIKE rxn_file.rxn06,
           l_oma10        LIKE oma_file.oma10,    #FUN-B30012 ADD
           rxn07          LIKE rxn_file.rxn07,
           rxn08          LIKE rxn_file.rxn08
                     END RECORD,
       g_rxn_t       RECORD
           rxn02          LIKE rxn_file.rxn02,
           rxn03          LIKE rxn_file.rxn03,
           rxn04          LIKE rxn_file.rxn04,
           rxn05          LIKE rxn_file.rxn05,
           rxn06          LIKE rxn_file.rxn06,
           l_oma10        LIKE oma_file.oma10,    #FUN-B30012 ADD
           rxn07          LIKE rxn_file.rxn07,
           rxn08          LIKE rxn_file.rxn08
                     END RECORD,
       g_rxn_o       RECORD 
           rxn02          LIKE rxn_file.rxn02,
           rxn03          LIKE rxn_file.rxn03,
           rxn04          LIKE rxn_file.rxn04,
           rxn05          LIKE rxn_file.rxn05,
           rxn06          LIKE rxn_file.rxn06,
           l_oma10        LIKE oma_file.oma10,    #FUN-B30012 ADD
           rxn07          LIKE rxn_file.rxn07,
           rxn08          LIKE rxn_file.rxn08
                     END RECORD,
       g_rxo         DYNAMIC ARRAY OF RECORD
           rxo02          LIKE rxo_file.rxo02,
           rxo14          LIKE rxo_file.rxo14,    #FUN-B30012 ADD
           rxo03          LIKE rxo_file.rxo03,
       #   rxo04          LIKE rxo_file.rxo04,    #FUN-B30012 MARK
       #   rxo04_desc     LIKE imd_file.imd02,    #FUN-B30012 MARK
           rxo05          LIKE rxo_file.rxo05,
           rxo05_desc     LIKE gfe_file.gfe02,
           rxo04          LIKE rxo_file.rxo04,    #FUN-B30012 ADD
           rxo04_desc     LIKE imd_file.imd02,    #FUN-B30012 ADD
           rxo06          LIKE rxo_file.rxo06,
           rxo07          LIKE rxo_file.rxo07,
           rxo08          LIKE rxo_file.rxo08,
           rxo09          LIKE rxo_file.rxo09,
           rxo10          LIKE rxo_file.rxo10,
       #   rxo11          LIKE rxo_file.rxo11,    #FUN-B30012 MARK
           rxo12          LIKE rxo_file.rxo12,
           rxo11          LIKE rxo_file.rxo11,    #FUN-B30012 ADD
           rxo13          LIKE rxo_file.rxo13
                     END RECORD,
       g_rxo_t       RECORD
           rxo02          LIKE rxo_file.rxo02,
           rxo14          LIKE rxo_file.rxo14,    #FUN-B30012 ADD
           rxo03          LIKE rxo_file.rxo03,
       #   rxo04          LIKE rxo_file.rxo04,    #FUN-B30012 MARK
       #   rxo04_desc     LIKE imd_file.imd02,    #FUN-B30012 MARK
           rxo05          LIKE rxo_file.rxo05,
           rxo05_desc     LIKE gfe_file.gfe02,
           rxo04          LIKE rxo_file.rxo04,    #FUN-B30012 ADD
           rxo04_desc     LIKE imd_file.imd02,    #FUN-B30012 ADD
           rxo06          LIKE rxo_file.rxo06,
           rxo07          LIKE rxo_file.rxo07,
           rxo08          LIKE rxo_file.rxo08,
           rxo09          LIKE rxo_file.rxo09,
           rxo10          LIKE rxo_file.rxo10,
       #   rxo11          LIKE rxo_file.rxo11,    #FUN-B30012 MARK
           rxo12          LIKE rxo_file.rxo12,
           rxo11          LIKE rxo_file.rxo11,    #FUN-B30012 ADD
           rxo13          LIKE rxo_file.rxo13
                     END RECORD,
       g_rxo_o       RECORD
           rxo02          LIKE rxo_file.rxo02,
           rxo14          LIKE rxo_file.rxo14,    #FUN-B30012 ADD
           rxo03          LIKE rxo_file.rxo03,
       #   rxo04          LIKE rxo_file.rxo04,    #FUN-B30012 MARK
       #   rxo04_desc     LIKE imd_file.imd02,    #FUN-B30012 MARK
           rxo05          LIKE rxo_file.rxo05,
           rxo05_desc     LIKE gfe_file.gfe02,
           rxo04          LIKE rxo_file.rxo04,    #FUN-B30012 ADD
           rxo04_desc     LIKE imd_file.imd02,    #FUN-B30012 ADD
           rxo06          LIKE rxo_file.rxo06,
           rxo07          LIKE rxo_file.rxo07,
           rxo08          LIKE rxo_file.rxo08,
           rxo09          LIKE rxo_file.rxo09,
           rxo10          LIKE rxo_file.rxo10,
       #   rxo11          LIKE rxo_file.rxo11,    #FUN-B30012 MARK
           rxo12          LIKE rxo_file.rxo12,
           rxo11          LIKE rxo_file.rxo11,    #FUN-B30012 ADD
           rxo13          LIKE rxo_file.rxo13
                     END RECORD,
       g_temp        DYNAMIC ARRAY OF RECORD
           temp01         LIKE type_file.chr1,
           temp02         LIKE rwf_file.rwf04,
           temp03         LIKE rwf_file.rwf03,
           temp04         LIKE rwf_file.rwf21,
           temp05         LIKE rwf_file.rwf22,
           temp06         LIKE rwf_file.rwf11,
           temp07         LIKE rwf_file.rwf19,
           temp08         LIKE rwf_file.rwf16,
           temp09         LIKE rwf_file.rwf12,
           temp10         LIKE rwg_file.rwg06,
           temp11         LIKE rwg_file.rwg11,
           temp12         LIKE rwk_file.rwk08,
           temp13         LIKE rwk_file.rwk09,
           temp14         LIKE rwk_file.rwk08
                     END RECORD,
       g_temp2       DYNAMIC ARRAY OF RECORD
           temp101         LIKE rwg_file.rwg04,
           temp102         LIKE rwg_file.rwg05,
           temp103         LIKE rwg_file.rwg06,
           temp104         LIKE ima_file.ima02,
           temp105         LIKE rwg_file.rwg09,
           temp106         LIKE rwg_file.rwg11
                     END RECORD,
       g_sql         STRING,
       g_wc          STRING, 
       g_wc1         STRING,
       g_wc2         STRING,
       g_rec_b       LIKE type_file.num5,
       l_ac1         LIKE type_file.num5,
       l_ac3         LIKE type_file.num5,
       l_ac          LIKE type_file.num5
 
DEFINE p_row,p_col         LIKE type_file.num5
DEFINE g_gec07             LIKE gec_file.gec07
DEFINE g_forupd_sql        STRING
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_cnt1              LIKE type_file.num10    #-FUN-B30012 - ADD
DEFINE g_i                 LIKE type_file.num5
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE mi_no_ask           LIKE type_file.num5
DEFINE g_argv1             LIKE rxm_file.rxm01
DEFINE g_argv2             STRING 
DEFINE g_flag              LIKE type_file.num5
DEFINE g_rec_b1            LIKE type_file.num5
DEFINE g_rec_b3            LIKE type_file.num5
DEFINE g_rec_b4            LIKE type_file.num5
DEFINE g_flag_b            LIKE type_file.chr1
DEFINE g_member            LIKE type_file.chr1
DEFINE g_rxo05_t           LIKE rxo_file.rxo05
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_argv1=ARG_VAL(1)
   LET g_argv2=ARG_VAL(2)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
   SELECT * FROM rus_file INTO TEMP rus_tmp 
   SELECT * FROM rus_file INTO TEMP rus_tmp1 
   LET g_sql = "INSERT INTO dsv11.rus_file SELECT * FROM rus_tmp"
   PREPARE pre_sel_rus FROM g_sql
   EXECUTE pre_sel_rus

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_rxm.rxm00 = '1'
   LET g_forupd_sql = "SELECT * FROM rxm_file WHERE rxm00 = ? AND rxm01 = ? AND rxmplant = ? FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t603_cl CURSOR FROM g_forupd_sql
   LET p_row = 2 LET p_col = 9
   OPEN WINDOW t603_w AT p_row,p_col WITH FORM "art/42f/artt603"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   IF NOT cl_null(g_argv1) THEN
      CALL t603_q()
   END IF
   
   DISPLAY BY NAME g_rxm.rxm00 
   CALL t603_menu()
   CLOSE WINDOW t603_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t603_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
   CLEAR FORM 
   CALL g_rxn.clear()
   DISPLAY BY NAME g_rxm.rxm00 
  
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = " rxm01 = '",g_argv1,"'"
   ELSE
      CALL cl_set_head_visible("","YES")
      INITIALIZE g_rxm.* TO NULL
      LET g_rxm.rxm00 = '1' 
      CONSTRUCT BY NAME g_wc ON rxm01,rxm02,rxm03,rxm04,rxm05,
                                rxm06,rxm07,rxmplant,rxmconf,rxmcond,rxmconu,
                       #        rxmmksg,rxm900,rxmuser,                #FUN-B30012 MARK
                                rxmuser,                               #FUN-B30012 ADD
                                rxmgrup,rxmmodu,rxmdate,rxmacti,
                                rxmcrat,rxmoriu,rxmorig
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(rxm01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.arg1='1'
                  LET g_qryparam.form ="q_rxm01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rxm01
                  NEXT FIELD rxm01
      
               WHEN INFIELD(rxm06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rxm06"
                  LET g_qryparam.arg1 = g_rxm.rxm00
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rxm06
                  NEXT FIELD rxm06
       
               WHEN INFIELD(rxmconu)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                        
                  LET g_qryparam.form ="q_rxmconu"                                                                                    
                  LET g_qryparam.arg1 = g_rxm.rxm00
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO rxmconu                                                                              
                  NEXT FIELD rxmconu
               WHEN INFIELD(rxmplant)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                        
                  LET g_qryparam.form ="q_rxmplant"                                                                                    
                  LET g_qryparam.arg1 = g_rxm.rxm00
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO rxmplant                                                                              
                  NEXT FIELD rxmplant
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
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rxmuser', 'rxmgrup')
 
   IF NOT cl_null(g_argv1) THEN
      LET g_wc1 = ' 1=1'     
   ELSE
      CONSTRUCT g_wc1 ON rxn02,rxn03,rxn04,rxn05,rxn06,rxn07,rxn08   
              FROM s_rxn[1].rxn02,s_rxn[1].rxn03,s_rxn[1].rxn04,
                   s_rxn[1].rxn05,s_rxn[1].rxn06,
                   s_rxn[1].rxn07,s_rxn[1].rxn08
 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
   
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(rxn04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rxn04"
                  LET g_qryparam.arg1 = g_rxm.rxm00
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rxn04
                  NEXT FIELD rxn04 
               WHEN INFIELD(rxn05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rxn05"
                  LET g_qryparam.arg1 = g_rxm.rxm00
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rxn05
                  NEXT FIELD rxn05
               WHEN INFIELD(rxn06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rxn06"
                  LET g_qryparam.arg1 = g_rxm.rxm00
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rxn06
                  NEXT FIELD rxn06
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
#      CONSTRUCT g_wc2 ON rxo02,rxo03,rxo04,rxo05,rxo06,rxo07,rxo08,          #FUN-B30012 MARK
       CONSTRUCT g_wc2 ON rxo02,rxo14,rxo03,rxo05,rxo04,rxo06,rxo07,rxo08,    #FUN-B30012 ADD
                          rxo09,rxo10,rxo11,rxo12,rxo13   
#             FROM s_rxo[1].rxo02,s_rxo[1].rxo03,s_rxo[1].rxo04,        #FUN-B30012 MARK
#                  s_rxo[1].rxo05,s_rxo[1].rxo06, s_rxo[1].rxo07,       #FUN-B30012 MARK
              FROM s_rxo[1].rxo02,s_rxo[1].rxo14,s_rxo[1].rxo03,s_rxo[1].rxo05,        #FUN-B30012 ADD
                   s_rxo[1].rxo04,s_rxo[1].rxo06, s_rxo[1].rxo07,                      #FUN-B30012 ADD
                   s_rxo[1].rxo08,s_rxo[1].rxo09,s_rxo[1].rxo10,
#                  s_rxo[1].rxo11,s_rxo[1].rxo12,s_rxo[1].rxo13                        #FUN-B30012 MARK
                   s_rxo[1].rxo12,s_rxo[1].rxo11,s_rxo[1].rxo13                        #FUN-B30012 ADD
 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
   
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(rxo03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rxo03"
                  LET g_qryparam.arg1 = g_rxm.rxm00
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rxo03
                  NEXT FIELD rxo03
               WHEN INFIELD(rxo04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  #FUN-AB0016  --modify
                  #LET g_qryparam.form ="q_rxo04"
                  LET g_qryparam.form ="q_imd01_1"
                  #LET g_qryparam.arg1 = g_rxm.rxm00
                  #FUN-AB0016  --end
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rxo04
                  NEXT FIELD rxo04
               WHEN INFIELD(rxo05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rxo05"
                  LET g_qryparam.arg1 = g_rxm.rxm00
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rxo05
                  NEXT FIELD rxo05 
               WHEN INFIELD(rxo11)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rxo11"
                  LET g_qryparam.arg1 = g_rxm.rxm00
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rxo11
                  NEXT FIELD rxo11
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
    END IF
 
    LET g_sql = "SELECT DISTINCT rxm00,rxm01,rxmplant ",
                "  FROM (rxm_file LEFT OUTER JOIN rxn_file ",
          #     "    ON (rxm00=rxn00 AND rxm01=rxn01 AND rxmplant=rxnplant AND ",g_wc1,")) ",         #FUN-B30012 MARK
                "    ON (rxm00=rxn00 AND rxm01=rxn01 AND rxmplant=rxnplant )) ",                      #FUN-B30012 ADD
                "    LEFT OUTER JOIN rxo_file ON ( rxm00=rxo00 AND rxm01=rxo01 ",
          #     "     AND rxmplant=rxoplant AND ",g_wc2,") ",                                         #FUN-B30012 MARK
                "     AND rxmplant=rxoplant ) ",                                                      #FUN-B30012 ADD
          #     "  WHERE rxm00 = '1' AND ", g_wc CLIPPED,                                             #FUN-B30012 MARK
                "  WHERE rxm00 = '1' AND ", g_wc CLIPPED," AND ",g_wc1 CLIPPED," AND ",g_wc2 CLIPPED, #FUN-B30012 ADD
                " ORDER BY rxm01"
 
   PREPARE t603_prepare FROM g_sql
   DECLARE t603_cs
       SCROLL CURSOR WITH HOLD FOR t603_prepare
 
   #IF g_wc2 = " 1=1" THEN
   #   LET g_sql="SELECT COUNT(*) FROM rxm_file WHERE ",g_wc CLIPPED
   #ELSE
   #   LET g_sql="SELECT COUNT(*) FROM rxm_file,rxn_file WHERE ",
   #             "rxn01=rxm01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   #END IF
   LET g_sql = "SELECT COUNT(DISTINCT rxm00||rxm01||rxmplant) ",
                "  FROM (rxm_file LEFT OUTER JOIN rxn_file ",
        #       "    ON (rxm00=rxn00 AND rxm01=rxn01 AND rxmplant=rxnplant AND ",g_wc1,")) ",         #FUN-B30012 MARK
                "    ON (rxm00=rxn00 AND rxm01=rxn01 AND rxmplant=rxnplant )) ",                      #FUN-B30012 ADD
                "    LEFT OUTER JOIN rxo_file ON ( rxm00=rxO00 AND rxm01=rxO01 ",
        #       "     AND rxmplant=rxoplant AND ",g_wc2,") ",                                         #FUN-B30012 MARK
                "     AND rxmplant=rxoplant ) ",                                                      #FUN-B30012 ADD
        #       "  WHERE rxm00 = '1' AND ", g_wc CLIPPED,                                             #FUN-B30012 MARK
                "  WHERE rxm00 = '1' AND ", g_wc CLIPPED," AND ",g_wc1 CLIPPED," AND ",g_wc2 CLIPPED, #FUN-B30012 ADD
                " ORDER BY rxm01"

   PREPARE t603_precount FROM g_sql
   DECLARE t603_count CURSOR FOR t603_precount
 
END FUNCTION
 
FUNCTION t603_menu()
   DEFINE l_partnum    STRING
   DEFINE l_supplierid STRING
   DEFINE l_status     LIKE type_file.num10
###-FUN-B30012 - ADD - BEGIN ------------------------
   DEFINE l_sql1       STRING
   DEFINE l_bamt       LIKE type_file.num5
   DEFINE l_rxx04      LIKE rxx_file.rxx04
   DEFINE l_i          LIKE type_file.num5
   DEFINE l_rxo10      LIKE rxo_file.rxo10
###-FUN-B30012 - ADD -  END  ------------------------
 
   WHILE TRUE
      CALL t603_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t603_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t603_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t603_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t603_u()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t603_x()
            END IF
 
#         WHEN "reproduce"
#            IF cl_chk_act_auth() THEN
#               CALL t603_copy()
#            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               IF g_flag_b = '1' THEN
                  CALL t603_b()
               ELSE
                  CALL t603_b1()
               END IF
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t603_out()
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
   
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t603_yes()
            END IF
 
         WHEN "kefa"
            IF cl_chk_act_auth() THEN
         #     CALL t603_kefa()             #FUN-B30012 MARK
###-FUN-B30012 - ADD - BEGIN -------------------------------
               LET l_sql1="select rxx04 from rxx_file where rxx00='09' AND rxx01='",g_rxm.rxm01,"' AND rxx03='1'"
               PREPARE t603_prxx04_3 FROM l_sql1
               DECLARE t603_crxx04_3 CURSOR FOR t603_prxx04_3
               LET l_bamt=0
               FOREACH t603_crxx04_3 INTO l_rxx04
                  LET l_bamt=l_rxx04+l_bamt
               END FOREACH
               IF l_bamt>0 THEN
                  CALL cl_err('','art-129',0)
               ELSE
                  CALL s_gifts('00',g_rxm.rxm01,g_rxm.rxmplant,g_rxm.rxm02,'')
                  ###-更新-###
                  IF g_rxm.rxm03 = '1' THEN
                     FOR l_i = 1 TO g_rec_b
                        INITIALIZE l_rxo10 TO NULL
                        SELECT SUM(rxo10) INTO l_rxo10 FROM rxo_file 
                         WHERE rxo00 = g_rxm.rxm00
                           AND rxo01 = g_rxm.rxm01 AND rxo14 = g_rxn[l_i].rxn04
                           AND rxoplant = g_rxm.rxmplant
                        UPDATE rxn_file SET rxn07 = l_rxo10
                         WHERE rxn00 = g_rxm.rxm00
                           AND rxn01 = g_rxm.rxm01
                           AND rxn02 = g_rxn[l_i].rxn02
                           AND rxnplant = g_rxm.rxmplant
                     END FOR
                     CALL t603_b_fill(g_wc1)
                  END IF
                  CALL t603_b1_fill(g_wc2)
                  INITIALIZE l_rxo10 TO NULL
                  SELECT SUM(rxo10) INTO l_rxo10 FROM rxo_file WHERE rxo00 = g_rxm.rxm00
                     AND rxo01 = g_rxm.rxm01 AND rxoplant = g_rxm.rxmplant
                  DISPLAY l_rxo10 TO FORMONLY.sum
               END IF
###-FUN-B30012 - ADD -  END  ----------------------------------
            END IF

        WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t603_void(1)
            END IF
        
        #FUN-D20039 -------------sta
        WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t603_void(2)
            END IF
        #FUN-D20039 -------------end

        WHEN "pay_money"
           IF cl_chk_act_auth() THEN
              CALL t603_pay()
           END IF
        WHEN "money_detail"   
           IF cl_chk_act_auth() THEN   
              CALL s_pay_detail('09',g_rxm.rxm01,g_rxm.rxmplant,g_rxm.rxmconf)  
           END IF

         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rxn),'','')
            END IF
            
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_rxm.rxm01 IS NOT NULL THEN
                 LET g_doc.column1 = "rxm01"
                 LET g_doc.value1 = g_rxm.rxm01
                 CALL cl_doc()
               END IF
         END IF
         
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t603_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE) 
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_rxn TO s_rxn.* ATTRIBUTE(COUNT=g_rec_b)
 
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()
 
         ON ACTION insert
            LET g_action_choice="insert"
            EXIT DIALOG
 
         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG
 
         ON ACTION delete
            LET g_action_choice="delete"
            EXIT DIALOG
 
         ON ACTION modify
            LET g_action_choice="modify"
            EXIT DIALOG
 
         ON ACTION first
            CALL t603_fetch('F')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION previous
            CALL t603_fetch('P')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION jump
            CALL t603_fetch('/')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION next
            CALL t603_fetch('N')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION last
            CALL t603_fetch('L')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION invalid
            LET g_action_choice="invalid"
            EXIT DIALOG
 
#         ON ACTION reproduce
#            LET g_action_choice="reproduce"
#            EXIT DIALOG
 
         ON ACTION detail
            LET g_action_choice="detail"
            LET g_flag_b = '1'
            LET l_ac = 1
            EXIT DIALOG
 
         ON ACTION output
            LET g_action_choice="output"
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
      
         ON ACTION confirm
            LET g_action_choice="confirm"
            EXIT DIALOG
         ON ACTION kefa
            LET g_action_choice="kefa" 
            EXIT DIALOG
         ON ACTION void
            LET g_action_choice="void"
            EXIT DIALOG
         #FUN-D20039 -------------sta
         ON ACTION undo_void
            LET g_action_choice="undo_void"
            EXIT DIALOG
         #FUN-D20039 -------------end
         ON ACTION pay_money      
            LET g_action_choice = "pay_money"  
            EXIT DIALOG
                                                                                                                                    
         ON ACTION money_detail      
            LET g_action_choice = "money_detail"
            EXIT DIALOG
         ON ACTION controlg
            LET g_action_choice="controlg"
            EXIT DIALOG
 
         ON ACTION accept
            LET g_action_choice="detail"
            LET g_flag_b = '1'
            LET l_ac = ARR_CURR()
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
 
         AFTER DISPLAY
            CONTINUE DIALOG
 
         ON ACTION controls       
            CALL cl_set_head_visible("","AUTO")
 
         ON ACTION related_document
            LET g_action_choice="related_document"          
            EXIT DIALOG
      END DISPLAY 
    
      DISPLAY ARRAY g_rxo TO s_rxo.* ATTRIBUTE(COUNT=g_rec_b1)
 
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()
 
         ON ACTION insert
            LET g_action_choice="insert"
            EXIT DIALOG
 
         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG
 
         ON ACTION delete
            LET g_action_choice="delete"
            EXIT DIALOG
 
         ON ACTION modify
            LET g_action_choice="modify"
            EXIT DIALOG
 
         ON ACTION first
            CALL t603_fetch('F')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION previous
            CALL t603_fetch('P')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION jump
            CALL t603_fetch('/')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION next
            CALL t603_fetch('N')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION last
            CALL t603_fetch('L')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION invalid
            LET g_action_choice="invalid"
            EXIT DIALOG
 
#         ON ACTION reproduce
#            LET g_action_choice="reproduce"
#            EXIT DIALOG
 
         ON ACTION detail
            LET g_action_choice="detail"
            LET g_flag_b = '2'
            LET l_ac1 = 1
            EXIT DIALOG
 
         ON ACTION output
            LET g_action_choice="output"
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
      
         ON ACTION confirm
            LET g_action_choice="confirm"
            EXIT DIALOG
         ON ACTION kefa
            LET g_action_choice="kefa" 
            EXIT DIALOG
 
         ON ACTION void
            LET g_action_choice="void"
            EXIT DIALOG

         #FUN-D20039 -------------sta
         ON ACTION undo_void
            LET g_action_choice="undo_void"
            EXIT DIALOG
         #FUN-D20039 -------------end

         ON ACTION pay_money      
            LET g_action_choice = "pay_money"  
            EXIT DIALOG
                                                                                                                                    
         ON ACTION money_detail      
            LET g_action_choice = "money_detail"
            EXIT DIALOG
         ON ACTION controlg
            LET g_action_choice="controlg"
            EXIT DIALOG
 
         ON ACTION accept
            LET g_action_choice="detail"
            LET g_flag_b = '2'
            LET l_ac1 = ARR_CURR()
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
 
         ON ACTION controls       
            CALL cl_set_head_visible("","AUTO")
 
         ON ACTION related_document
            LET g_action_choice="related_document"          
            EXIT DIALOG
      END DISPLAY 
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION t603_kefa()
DEFINE l_i        LIKE type_file.num5
DEFINE l_n        LIKE type_file.num5
DEFINE l_cn       LIKE type_file.num5
DEFINE l_num      LIKE type_file.num5
DEFINE l_sum      LIKE type_file.num5
DEFINE l_flag     LIKE type_file.num5
DEFINE l_ima25    LIKE ima_file.ima25
DEFINE l_rtz08    LIKE rtz_file.rtz08
DEFINE l_temp09   LIKE rxo_file.rxo09
DEFINE l_temp12   LIKE rxo_file.rxo12

   IF g_rxm.rxm01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_rxm.* FROM rxm_file 
      WHERE rxm00 = g_rxm.rxm00 AND rxm01=g_rxm.rxm01
        AND rxmplant = g_rxm.rxmplant
   IF g_rxm.rxmconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rxm.rxmconf = 'X' THEN CALL cl_err(g_rxm.rxm01,'9024',0) RETURN END IF 
   IF g_rxm.rxmacti = 'N' THEN CALL cl_err('','art-145',0) RETURN END IF

   IF g_rxm.rxm03 = '2' OR g_rxm.rxm04 = '3' THEN RETURN END IF

   SELECT COUNT(*) INTO l_n FROM rxn_file WHERE rxn00 = g_rxm.rxm00
       AND rxn01 = g_rxm.rxm01 AND rxnplant = g_rxm.rxmplant
   IF l_n = 0 THEN RETURN END IF
   CALL g_temp.clear()
   CALL g_temp2.clear()
   #SELECT ogb04,ogb05,ogb12,ogb14t FROM ogb_file WHERE 1=0 INTO ogb_tmp
   CALL t603_ins_tmp()

   OPEN WINDOW s120_w1 AT 8,15 WITH FORM "art/42f/artt603_1"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   CALL t603_b_fill2()

   INPUT ARRAY g_temp WITHOUT DEFAULTS FROM s_temp.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=FALSE,DELETE ROW=FALSE,
                   APPEND ROW=FALSE)
      BEFORE ROW
         LET l_ac3 = ARR_CURR()
         CALL t603_b_fill3()

      ON CHANGE temp01
         IF g_temp[l_ac3].temp01 = 'Y' THEN
            FOR l_i = 1 TO g_temp.getLength()
                IF g_temp[l_ac3].temp02 = g_temp[l_i].temp02 AND l_i != l_ac3 THEN
                   IF g_temp[l_ac3].temp01 = 'Y' AND g_temp[l_ac3].temp05 = '1' 
                      AND g_temp[l_i].temp01 = 'Y' THEN
                      LET g_temp[l_ac3].temp01 = 'N'
                      CALL cl_err('','art-912',1)
                   END IF
                END IF
            END FOR
         END IF
         
      AFTER FIELD temp14
         IF g_temp[l_ac3].temp14 IS NOT NULL THEN
            IF g_temp[l_ac3].temp14 <= 0 THEN
               CALL cl_err('','axr-034',0)
               NEXT FIELD temp14
            END IF
            IF g_temp[l_ac3].temp03 = '4' THEN 
               IF g_temp[l_ac3].temp06 =0 THEN
                  IF g_temp[l_ac3].temp04 = '1' THEN
                     LET l_num = (g_temp[l_ac3].temp12/g_temp[l_ac3].temp08)*g_temp[l_ac3].temp11 
                  ELSE
                     LET l_num = g_temp[l_ac3].temp11
                  END IF
               END IF
               IF g_temp[l_ac3].temp06 =1 THEN
                  IF g_temp[l_ac3].temp04 = '1' THEN
                     LET l_sum = 0
                     FOR l_i = 1 TO g_temp2.getLength()
                         LET l_sum = l_sum + g_temp2[l_i].temp106
                     END FOR    
                     LET l_num = g_temp[l_ac3].temp14/l_sum
                  ELSE
                     LET l_num = g_temp[l_ac3].temp11
                  END IF
               END IF
            ELSE
               LET l_num = g_temp[l_ac3].temp11
            END IF
            IF g_temp[l_ac3].temp14 > l_num THEN
               CALL cl_err_msg(NULL,"art-911",l_num,10)
               NEXT FIELD temp14
            END IF 
         END IF
      ON ACTION accept   
         #No.FUN-A10012--begin
         IF cl_null(g_temp[l_ac3].temp02) AND cl_null(g_temp[l_ac3].temp03) AND cl_null(g_temp[l_ac3].temp04) AND
            cl_null(g_temp[l_ac3].temp05) AND cl_null(g_temp[l_ac3].temp06) AND cl_null(g_temp[l_ac3].temp07) AND
            cl_null(g_temp[l_ac3].temp08) AND cl_null(g_temp[l_ac3].temp09) AND cl_null(g_temp[l_ac3].temp10) AND 
            cl_null(g_temp[l_ac3].temp11) AND cl_null(g_temp[l_ac3].temp12) AND cl_null(g_temp[l_ac3].temp13) THEN
            CALL cl_err('','art-618',1)
         ELSE
            EXIT INPUT
         END IF 
         #No.FUN-A10012--end
      ON ACTION all                   
         FOR l_i = 1 TO g_temp.getLength() 
             IF g_temp[l_i].temp05 = '1' THEN CONTINUE FOR END IF
             LET g_temp[l_i].temp01 = 'Y'
         END FOR                      
      ON ACTION no_all                                                                                                              
         FOR l_i = 1 TO g_temp.getLength()
             LET g_temp[l_i].temp01 = 'N'  
         END FOR

   END INPUT

   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW s120_w1
      RETURN
   END IF

   LET l_flag = 1 
   FOR l_i = 1 TO g_temp.getLength()
       IF g_temp[l_i].temp01 = 'Y' THEN
          IF l_flag THEN
             LET l_flag = 0
#             IF NOT cl_confirm('art-910') THEN RETURN END IF
             IF NOT cl_confirm('art-910') THEN EXIT FOR END IF
             DELETE FROM rxo_file WHERE rxo00 = g_rxm.rxm00 AND rxo01=g_rxm.rxm01
                  AND rxoplant = g_rxm.rxmplant
          END IF 
          SELECT MAX(rxo02)+1 INTO l_n FROM rxo_file
               WHERE rxo00 = g_rxm.rxm00 AND rxo01=g_rxm.rxm01 
                 AND rxoplant = g_rxm.rxmplant
          IF l_n IS NULL THEN LET l_n = 1 END IF
         #SELECT rtz08 INTO l_rtz08 FROM rtz_file WHERE rtz01 = g_rxm.rxmplant    #FUN-C90049 mark
          CALL s_get_noncoststore(g_rxm.rxmplant,g_temp[l_i].temp10) RETURNING l_rtz08            #FUN-C90049 add
          SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = g_temp[l_i].temp10

          IF g_member = 'Y' THEN
             SELECT temp16 INTO l_temp09 FROM tmp1
                 WHERE temp02 = g_temp[l_i].temp02
                   AND temp10 = g_temp[l_i].temp10
          ELSE
             SELECT temp15 INTO l_temp09 FROM tmp1
                 WHERE temp02 = g_temp[l_i].temp02
                   AND temp10 = g_temp[l_i].temp10
          END IF
          IF g_temp[l_i].temp03 = '4' THEN
             LET l_temp12 = '1'
          ELSE
             LET l_temp12 = '2'
          END IF
          SELECT COUNT(*) INTO l_cn FROM rxo_file
             WHERE rxo00 = g_rxm.rxm00 AND rxo01=g_rxm.rxm01
               AND rxo03 = g_temp[l_i].temp10
               AND rxoplant = g_rxm.rxmplant
          #IF l_cn >0 THEN
          #   UPDATE rxo_file SET rxo07 = rxo07 + g_temp[l_i].temp14,
          #                       rxo10 = rxo10 + g_temp[l_i].temp14*l_temp09
          #      WHERE rxo00 = g_rxm.rxm00 AND rxo01=g_rxm.rxm01
          #        AND rxo03 = g_rxm.rxm03
          #        AND rxoplant = g_rxm.rxmplant
          #ELSE
             INSERT INTO rxo_file(rxo00,rxo01,rxo02,rxo03,rxo04,rxo05,rxo06,
                                  rxo07,rxo08,rxo09,rxo10,rxo11,rxo12,rxo13,
                                  rxoplant,rxolegal)
                         VALUES(g_rxm.rxm00,g_rxm.rxm01,l_n,g_temp[l_i].temp10,l_rtz08,
                                l_ima25,1,g_temp[l_i].temp14,0,
                                l_temp09,l_temp09*g_temp[l_i].temp14,
                                g_temp[l_i].temp02,l_temp12,NULL,
                                g_rxm.rxmplant,g_rxm.rxmlegal)
          #END IF
          IF SQLCA.SQLCODE THEN
             CALL cl_err('',SQLCA.SQLCODE,1)
             RETURN
          END IF             
       END IF 
   END FOR
   CALL t603_b1_fill(" 1=1")
   CLOSE WINDOW s120_w1
   DROP TABLE ogb_tmp
   DROP TABLE oeb_tmp
   DROP TABLE tmp1
   DROP TABLE tmp2
END FUNCTION
FUNCTION t603_ins_tmp()
DEFINE l_rxn      RECORD LIKE rxn_file.*
DEFINE l_i        LIKE type_file.num5
DEFINE l_n        LIKE type_file.num5
DEFINE l_fac      LIKE type_file.num20_6
DEFINE l_ogb12    LIKE ogb_file.ogb12
DEFINE l_ogb14t   LIKE ogb_file.ogb14t
DEFINE l_ogb04    LIKE ogb_file.ogb04
DEFINE l_ogb05    LIKE ogb_file.ogb05
DEFINE l_ima25    LIKE ima_file.ima25

   DROP TABLE ogb_tmp
   SELECT ogb04,ogb05,ogb12,ogb14t FROM ogb_file WHERE 1=0 INTO TEMP ogb_tmp
   LET g_sql = "SELECT * FROM rxn_file ",
               " WHERE rxn00 = '",g_rxm.rxm00,"' AND rxn01 ='",g_rxm.rxm01,"' ",
               "   AND rxnplant = '",g_rxm.rxmplant,"'"
   PREPARE pre_sel_rxn001 FROM g_sql
   DECLARE cur_rxn001 CURSOR FOR pre_sel_rxn001
   FOREACH cur_rxn001 INTO l_rxn.*
      IF NOT cl_null(l_rxn.rxn04) AND NOT cl_null(l_rxn.rxn05) THEN
         LET g_sql = "SELECT ogb04,ogb05,ogb12,ogb14t FROM ogb_file ",
                     "   WHERE ogb01 = '",l_rxn.rxn04,"'"
      ELSE
         IF NOT cl_null(l_rxn.rxn04) THEN
            LET g_sql = "SELECT ogb04,ogb05,ogb12,ogb14t FROM ogb_file ",
                        "   WHERE ogb01 = '",l_rxn.rxn04,"'" 
         END IF   
         IF NOT cl_null(l_rxn.rxn05) THEN
            LET g_sql = "SELECT oeb04,oeb05,oeb12,oeb14t FROM oeb_file ",
                        "   WHERE oeb01 = '",l_rxn.rxn05,"'"
         END IF
      END IF
      IF g_sql IS NULL THEN CONTINUE FOREACH END IF
      PREPARE pre_sel_rxn05 FROM g_sql
      DECLARE cur_rxn05 CURSOR FOR pre_sel_rxn05
      FOREACH cur_rxn05 INTO l_ogb04,l_ogb05,l_ogb12,l_ogb14t
         SELECT COUNT(*) INTO l_n FROM ogb_tmp WHERE ogb04=l_ogb04 
         SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = l_ogb04
         IF l_n = 0 THEN
            CALL s_umfchk(l_ogb04,l_ogb05,l_ima25) RETURNING l_i,l_fac
            IF l_i THEN CONTINUE FOREACH END IF
            INSERT INTO ogb_tmp VALUES(l_ogb04,l_ogb05,l_ogb12,l_ogb14t)
            LET l_ogb12 = l_ogb12*l_fac
            UPDATE ogb_tmp SET ogb05 = l_ima25,ogb12=l_ogb12 WHERE ogb04=l_ogb04
         ELSE
            CALL s_umfchk(l_ogb04,l_ogb05,l_ima25) RETURNING l_i,l_fac
            IF l_i THEN CONTINUE FOREACH END IF
            LET l_ogb12 = l_ogb12*l_fac
            UPDATE ogb_tmp SET ogb05 = l_ima25,
                               ogb12 = ogb12+l_ogb12,
                               ogb14t = ogb14t+l_ogb14t 
                 WHERE ogb04=l_ogb04
         END IF
      END FOREACH
   END FOREACH   
   SELECT COUNT(*) INTO l_i FROM ogb_tmp 
END FUNCTION

FUNCTION t603_b_fill3()
DEFINE l_cnt         LIKE type_file.num5

   CALL g_temp2.clear()
   LET g_sql = "SELECT * FROM tmp2 WHERE temp101 = '",g_temp[l_ac3].temp02,"'"
   PREPARE pre_sel_tmp2 FROM g_sql
   DECLARE cur_tmp2 CURSOR FOR pre_sel_tmp2

   LET l_cnt = 1
   FOREACH cur_tmp2 INTO g_temp2[l_cnt].*
      IF SQLCA.SQLCODE THEN 
         CALL cl_err('',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   CALL g_temp2.deleteElement(l_cnt)
   LET g_rec_b4 = l_cnt -1

   DISPLAY ARRAY g_temp2 TO s_temp2.* ATTRIBUTE(COUNT=g_rec_b4,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY
END FUNCTION
FUNCTION t603_b_fill2()
DEFINE l_sql        STRING
DEFINE l_rwf        RECORD LIKE rwf_file.*
DEFINE l_cnt        LIKE type_file.num5
DEFINE l_time       LIKE type_file.chr8

   DROP TABLE tmp1
   SELECT chr1 temp01,rwf04 temp02,rwf03 temp03,rwf21 temp04,rwf22 temp05,
        rwf11 temp06,rwf19 temp07,rwf16 temp08,rwf12 temp09,rwg06 temp10,
        rwg11 temp11,rwk08 temp12,rwk09 temp13,rwk08 temp14,rwk09 temp15,
        rwk10 temp16
      FROM type_file,rwf_file,rwg_file,rwk_file WHERE 1=0 INTO TEMP tmp1
   DROP TABLE tmp2
   SELECT rwg04 temp101,rwg05 temp102,rwg06 temp103,ima02 temp104,
          rwg09 temp105,rwg11 temp106 
      FROM rwg_file,ima_file WHERE 1=0 INTO TEMP tmp2

   CALL t603_member() RETURNING g_member

   LET l_time = TIME
   LET l_sql = " SELECT DISTINCT rwf_file.* ",
               " FROM rwf_file ",   
               "    WHERE rwf03 = '4' AND rwfplant = '",g_rxm.rxmplant,"' ", 
               "    AND rwf23 = '2' AND rwf10 = '5' ",
               "    AND rwfconf = 'Y' ",
               "    AND '",g_rxm.rxm02,"' BETWEEN rwf06 AND rwf07 ", 
               "    AND '",l_time,"' BETWEEN rwf08 AND rwf09 ",
               "    AND rwfplant IN (SELECT rwq06 FROM rwq_file ",
               "     WHERE rwf01 = rwq01 AND rwf02 = rwq02 ",
               "       AND rwf03 = rwq03 AND rwf04 = rwq04) " 
   PREPARE pre_sel_rwf01 FROM l_sql
   DECLARE cur_rwf CURSOR FOR pre_sel_rwf01

   FOREACH cur_rwf INTO l_rwf.*
      IF l_rwf.rwf11 = '0' THEN   
         CALL t603_dynamic(l_rwf.*)
      ELSE                
         CALL t603_fix(l_rwf.*)
      END IF 
   END FOREACH
  
   CALL t603_full_sale()

   LET g_sql = "SELECT temp01,temp02,temp03,temp04,temp05, ", 
               "       temp06,temp07,temp08,temp09,temp10, ",
               "       temp11,temp12,temp13,temp14 ",
               "   FROM tmp1 "
   PREPARE pre_sel_tmp1 FROM g_sql
   DECLARE cur_tmp1 CURSOR FOR pre_sel_tmp1
   LET l_cnt = 1
   FOREACH cur_tmp1 INTO g_temp[l_cnt].*
      LET l_cnt = l_cnt + 1
   END FOREACH

   CALL g_temp.deleteElement(l_cnt)
   LET g_rec_b3 = l_cnt -1

   DISPLAY ARRAY g_temp TO s_temp.* ATTRIBUTE(COUNT=g_rec_b3,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY

END FUNCTION
FUNCTION t603_member()
DEFINE l_rxn04        LIKE rxn_file.rxn04
DEFINE l_rxn05        LIKE rxn_file.rxn05
DEFINE l_rxn06        LIKE rxn_file.rxn06
DEFINE l_oga87        LIKE oga_file.oga87

     LET g_sql = "SELECT rxn04,rxn05,rxn06 FROM rxn_file ",
                 "   WHERE rxn00 = '",g_rxm.rxm00,"' ",
                 "     AND rxn01 = '",g_rxm.rxm01,"' ",
                 "     AND rxnplant = '",g_rxm.rxmplant,"' "
     PREPARE pre_sel_rxn06 FROM g_sql
     DECLARE cur_rxn06 CURSOR FOR pre_sel_rxn06
     FOREACH cur_rxn06 INTO l_rxn04,l_rxn05,l_rxn06
        IF l_rxn04 IS NOT NULL THEN
           SELECT oga87 INTO l_oga87 FROM oga_file   
               WHERE oga01 = l_rxn04
        END IF
        IF l_rxn05 IS NOT NULL THEN
           SELECT oea87 INTO l_oga87 FROM oea_file   
               WHERE oea01 = l_rxn05
        END IF
             
        IF NOT cl_null(l_oga87) THEN EXIT FOREACH END IF
     END FOREACH
     IF NOT cl_null(l_oga87) THEN
        RETURN 'Y'
     ELSE
        RETURN 'N'
     END IF
END FUNCTION
FUNCTION t603_full_sale()
DEFINE l_time      LIKE type_file.chr8
DEFINE l_rwk06       LIKE rwk_file.rwk06
DEFINE l_rwk08       LIKE rwk_file.rwk08
DEFINE l_temp        RECORD
           temp01         LIKE type_file.chr1,
           temp02         LIKE rwf_file.rwf04,
           temp03         LIKE rwf_file.rwf03,
           temp04         LIKE rwf_file.rwf21,
           temp05         LIKE rwf_file.rwf22,
           temp06         LIKE rwf_file.rwf11,
           temp07         LIKE rwf_file.rwf19,
           temp08         LIKE rwf_file.rwf16,
           temp09         LIKE rwf_file.rwf12,
           temp10         LIKE rwg_file.rwg06,
           temp11         LIKE rwg_file.rwg11,
           temp12         LIKE rwk_file.rwk08,
           temp13         LIKE rwk_file.rwk09,
           temp14         LIKE rwk_file.rwk08,
           temp15         LIKE rwk_file.rwk09,
           temp16         LIKE rwk_file.rwk10
                     END RECORD
DEFINE l_rwk09        LIKE rwk_file.rwk09
DEFINE l_rwk10        LIKE rwk_file.rwk10
DEFINE l_sql          STRING
DEFINE l_rwi          RECORD LIKE rwi_file.*
DEFINE l_rwj05        LIKE rwj_file.rwj05
DEFINE l_rwj06        LIKE rwj_file.rwj06
DEFINE l_ogb12_sum    LIKE ogb_file.ogb12
DEFINE l_ogb14t_sum   LIKE ogb_file.ogb14t

   LET l_time = TIME

   LET g_sql = "SELECT * FROM rwi_file ",
               "   WHERE (rwi10 = '4' OR rwi10 = '5') ",
               "     AND rwiplant = '",g_rxm.rxmplant,"' ",
               "     AND rwi19 = '2' AND rwiconf = 'Y' ",
               "    AND '",g_rxm.rxm02,"' BETWEEN rwi06 AND rwi07 ", 
               "    AND '",l_time,"' BETWEEN rwi08 AND rwi09 "
   PREPARE pre_sel_rwi FROM g_sql
   DECLARE cur_rwi CURSOR FOR pre_sel_rwi

   FOREACH cur_rwi INTO l_rwi.*
      LET g_sql = "SELECT rwo07 FROM rwo_file ",
                  "   WHERE rwo01 = '",l_rwi.rwi01,"' AND rwo02 = '",l_rwi.rwi02,"'",
                  "     AND rwo03 = '",l_rwi.rwi03,"' AND rwo04 = '",l_rwi.rwi04,"'",
                  "     AND rwo05 = '",l_rwi.rwi14,"'"
      IF l_rwi.rwi13 = '1' THEN
         IF l_rwi.rwi14 = '1' THEN
            LET g_sql = "SELECT * FROM ogb_tmp WHERE ogb04 IN (",g_sql,")" 
         ELSE
            LET g_sql = "SELECT * FROM ogb_tmp WHERE ogb04 IN (",
                        "   SELECT ima01 FROM ima_file WHERE ima131 IN (",g_sql,"))" 
         END IF
      END IF
      IF l_rwi.rwi13 = '2' THEN
         IF l_rwi.rwi14 = '1' THEN
            LET g_sql = "SELECT * FROM ogb_tmp WHERE ogb04 NOT IN (",g_sql,")" 
         ELSE
            LET g_sql = "SELECT * FROM ogb_tmp WHERE ogb04 NOT IN (",
                        "   SELECT ima01 FROM ima_file WHERE ima131 IN (",g_sql,"))" 
         END IF
      END IF
      IF l_rwi.rwi13 = '3' THEN
         LET g_sql = "SELECT * FROM ogb_tmp " 
      END IF

      LET g_sql = "SELECT SUM(ogb12),SUM(ogb14t) FROM (",g_sql,") WHERE ogb04 NOT IN ",
                  "(SELECT DISTINCT rwg06 FROM rwg_file,rwf_file WHERE '",
                  l_time,"' BETWEEN rwf08 AND rwf09 ",  
                  " AND '",g_rxm.rxm02,"' BETWEEN rwf06 AND rwf07 ", 
                  " AND rwf01 = rwg01 AND rwf02 = rwg02 AND rwf03 = rwg03 ",
                  " AND rwf04 = rwg04 AND rwf19 = 'N' AND rwf11 = '2' ",
                  " AND rwfconf = 'Y')"
      PREPARE pre_sel_ogb FROM g_sql
      EXECUTE pre_sel_ogb INTO l_ogb12_sum,l_ogb14t_sum
      IF l_ogb14t_sum IS NULL THEN LET l_ogb14t_sum = 0 END IF

      LET l_sql = "SELECT rwj05,rwj06 FROM rwj_file WHERE rwj01 = '",l_rwi.rwi01,"'",
                  "   AND rwj02 = '",l_rwi.rwi02,"' AND rwj03 = '",l_rwi.rwi03,"'",
                  "   AND rwj04 = '",l_rwi.rwi04,"'"
      PREPARE pre_sel_rwj FROM l_sql
      DECLARE cur_rwj CURSOR FOR pre_sel_rwj
      
      LET l_temp.temp01 = 'N'
      LET l_temp.temp02 = l_rwi.rwi04
      LET l_temp.temp03 = '5'
      LET l_temp.temp04 = l_rwi.rwi12
      LET l_temp.temp05 = l_rwi.rwi18
      LET l_temp.temp06 = ' '
      LET l_temp.temp07 = 'Y'
      LET l_temp.temp08 = 0
      LET l_temp.temp12 = l_ogb12_sum
      LET l_temp.temp13 = l_ogb14t_sum
      FOREACH cur_rwj INTO l_rwj05,l_rwj06
         IF l_rwj06 IS NULL THEN CONTINUE FOREACH END IF
         LET l_sql = "SELECT rwk06,rwk08,rwk09,rwk10 FROM rwk_file ",
                     "   WHERE rwk01 = '",l_rwi.rwi01,"' AND rwk04 = '",l_rwi.rwi04,"'",
                     "   AND rwk02 = '",l_rwi.rwi02,"' AND rwk03 = '",l_rwi.rwi03,"'",
                     "   AND rwk05 = '",l_rwj05,"'"
         PREPARE pre_sel_rwk08 FROM l_sql
         EXECUTE pre_sel_rwk08 INTO l_rwk06,l_rwk08,l_rwk09,l_rwk10
         IF SQLCA.SQLCODE THEN CONTINUE FOREACH END IF
         IF l_ogb14t_sum > l_rwj06 THEN
            LET l_temp.temp09 = l_rwj06
            LET l_temp.temp10 = l_rwk06
            LET l_temp.temp11 = l_rwk08
            LET l_temp.temp14 = l_rwk08
            IF l_rwk09 IS NULL THEN LET l_rwk09 = 0 END IF
            IF l_rwk10 IS NULL THEN LET l_rwk10 = 0 END IF
            LET l_temp.temp15 = l_rwk09
            LET l_temp.temp16 = l_rwk10
            INSERT INTO tmp1 VALUES(l_temp.*)
         END IF
      END FOREACH
   END FOREACH
END FUNCTION
FUNCTION t603_fix(p_rwf)
DEFINE p_rwf        RECORD LIKE rwf_file.*
DEFINE l_rwk06       LIKE rwk_file.rwk06
DEFINE l_rwk08       LIKE rwk_file.rwk08
DEFINE l_temp        RECORD
           temp01         LIKE type_file.chr1,
           temp02         LIKE rwf_file.rwf04,
           temp03         LIKE rwf_file.rwf03,
           temp04         LIKE rwf_file.rwf21,
           temp05         LIKE rwf_file.rwf22,
           temp06         LIKE rwf_file.rwf11,
           temp07         LIKE rwf_file.rwf19,
           temp08         LIKE rwf_file.rwf16,
           temp09         LIKE rwf_file.rwf12,
           temp10         LIKE rwg_file.rwg06,
           temp11         LIKE rwg_file.rwg11,
           temp12         LIKE rwk_file.rwk08,
           temp13         LIKE rwk_file.rwk09,
           temp14         LIKE rwk_file.rwk08,
           temp15         LIKE rwk_file.rwk09,
           temp16         LIKE rwk_file.rwk10
                     END RECORD
DEFINE l_temp2       RECORD
           temp101         LIKE rwg_file.rwg04,
           temp102         LIKE rwg_file.rwg05,
           temp103         LIKE rwg_file.rwg06,
           temp104         LIKE ima_file.ima02,
           temp105         LIKE rwg_file.rwg09,
           temp106         LIKE rwg_file.rwg11
                     END RECORD
DEFINE l_use_sum      LIKE oeb_file.oeb12
DEFINE l_use_num1     LIKE oeb_file.oeb12
DEFINE l_sum          LIKE oeb_file.oeb14t
DEFINE l_ogb12        LIKE ogb_file.ogb12
DEFINE l_ogb14t       LIKE ogb_file.ogb14t
DEFINE l_ogb04        LIKE ogb_file.ogb04
DEFINE l_ogb05        LIKE ogb_file.ogb05
DEFINE l_cn           LIKE type_file.num5
DEFINE l_rwg11        LIKE rwg_file.rwg11
DEFINE l_rwg05        LIKE rwg_file.rwg05
DEFINE l_rwg09        LIKE rwg_file.rwg09
DEFINE l_min          LIKE type_file.num5
DEFINE l_times        LIKE type_file.num5
DEFINE l_rwk09        LIKE rwk_file.rwk09
DEFINE l_rwk10        LIKE rwk_file.rwk10

   LET g_sql = "SELECT ogb04,ogb05,ogb12,ogb14t FROM ogb_tmp ",
               "   WHERE ogb04 IN ",
               " (SELECT rwg06 ",
               "  FROM rwg_file WHERE rwg01 = '",p_rwf.rwf01,"'",
               "   AND rwg02 = '",p_rwf.rwf02,"' AND rwg03 = '",p_rwf.rwf03,"' ",
               "   AND rwg04 = '",p_rwf.rwf04,"') "

   DROP TABLE oeb_tmp
   LET g_sql = g_sql," INTO TEMP oeb_tmp "
   PREPARE pre_sel_rwg1 FROM g_sql
   EXECUTE pre_sel_rwg1

   LET g_sql = "SELECT * FROM oeb_tmp "
   PREPARE pre_sel_tmp FROM g_sql
   DECLARE cur_tmp CURSOR FOR pre_sel_tmp

   #temp01-->temp14
   LET l_temp.temp01 = 'N'
   LET l_temp.temp02 = p_rwf.rwf04
   LET l_temp.temp03 = '4'
   LET l_temp.temp04 = p_rwf.rwf21
   LET l_temp.temp05 = p_rwf.rwf22
   LET l_temp.temp06 = p_rwf.rwf11
   LET l_temp.temp07 = p_rwf.rwf19
   LET l_temp.temp08 = 0
   LET l_temp.temp09 = 0
   FOREACH cur_tmp INTO l_ogb04,l_ogb05,l_ogb12,l_ogb14t
      LET g_sql = "SELECT rwg11 FROM rwg_file ",
                  "   WHERE rwg01 = '",p_rwf.rwf01,"'",
                  "   AND rwg02 = '",p_rwf.rwf02,"' ",
                  "   AND rwg03 = '",p_rwf.rwf03,"' ",
                  "   AND rwg04 = '",p_rwf.rwf04,"'",
                  "   AND rwg06 = '",l_ogb04,"' ",
                  "   AND rwg09 = '",l_ogb05,"' ",
                  "   AND rwgplant='",p_rwf.rwfplant,"' "  
      PREPARE pre_sel_rwg11 FROM g_sql
      EXECUTE pre_sel_rwg11 INTO l_rwg11
      IF SQLCA.SQLCODE = 100 THEN CONTINUE FOREACH END IF
      IF l_rwg11 IS NULL OR l_rwg11 = 0 THEN CONTINUE FOREACH END IF
      LET l_times = l_ogb12/l_rwg11 
      IF l_times = 0 THEN RETURN 'N' END IF
      IF l_cn = 0 THEN LET l_min = l_times END IF
      IF l_times < l_min THEN LET l_min = l_times END IF
      LET l_cn = l_cn + 1

   END FOREACH
   LET l_use_num1 = 0
   LET l_sum = 0
   LET l_cn = 1
   FOREACH cur_tmp INTO l_ogb04,l_ogb05,l_ogb12,l_ogb14t
      LET g_sql = "SELECT rwg05,rwg09,rwg11 FROM rwg_file ",
                  "   WHERE rwg01 = '",p_rwf.rwf01,"'",
                  "   AND rwg02 = '",p_rwf.rwf02,"' ",
                  "   AND rwg03 = '",p_rwf.rwf03,"' ",
                  "   AND rwg04 = '",p_rwf.rwf04,"'",
                  "   AND rwg06 = '",l_ogb04,"' ",
                  "   AND rwg09 = '",l_ogb05,"' ",
                  "   AND rwgplant='",p_rwf.rwfplant,"' "  
      PREPARE pre_sel_rwg12 FROM g_sql
      EXECUTE pre_sel_rwg12 INTO l_rwg05,l_rwg09,l_rwg11

      IF SQLCA.SQLCODE = 100 THEN CONTINUE FOREACH END IF
      IF l_rwg11 IS NULL OR l_rwg11 = 0 THEN CONTINUE FOREACH END IF
      LET l_temp2.temp101 = p_rwf.rwf04
      LET l_temp2.temp102 = l_rwg05
      LET l_temp2.temp103 = l_ogb04
      SELECT ima02 INTO l_temp2.temp104 FROM ima_file WHERE ima01 = l_ogb04 
      LET l_temp2.temp105 = l_rwg09
      LET l_temp2.temp106 = l_rwg11
 
      INSERT INTO tmp2 VALUES(l_temp2.*)
      LET l_use_sum = l_min*l_rwg11
      LET l_use_num1 = l_use_num1 + l_min*l_rwg11
      LET l_sum = l_sum + l_ogb14t
   END FOREACH
   LET l_temp.temp12 = l_use_num1
   LET l_temp.temp13 = l_sum
   LET g_sql = "SELECT rwk06,rwk08,rwk09,rwk10 FROM rwk_file ",
               "   WHERE rwk01 = '",p_rwf.rwf01,"'",
               "   AND rwk02 = '",p_rwf.rwf02,"' ",
               "   AND rwk03 = '",p_rwf.rwf03,"' ",
               "   AND rwk04 = '",p_rwf.rwf04,"'",
               "   AND rwkplant='",p_rwf.rwfplant,"' "  
   PREPARE pre_sel_rwg13 FROM g_sql
   DECLARE cur_rwg13 CURSOR FOR pre_sel_rwg13
   FOREACH cur_rwg13 INTO l_rwk06,l_rwk08,l_rwk09,l_rwk10
      LET l_temp.temp10 = l_rwk06
      LET l_temp.temp11 = l_rwk08
      #LET l_temp.temp14 = l_min*l_rwk08
      IF l_temp.temp04 = '1' THEN
         LET l_temp.temp14 = l_min*l_rwk08
      ELSE
         LET l_temp.temp14 = l_rwk08
      END IF
      LET l_temp.temp15 = l_rwk09
      LET l_temp.temp16 = l_rwk10
      INSERT INTO tmp1 VALUES(l_temp.*) 
   END FOREACH
END FUNCTION
FUNCTION t603_dynamic(p_rwf)
DEFINE p_rwf        RECORD LIKE rwf_file.*
DEFINE l_sum        LIKE ogb_file.ogb12
DEFINE l_sum1       LIKE ogb_file.ogb14t
DEFINE l_temp        RECORD
           temp01         LIKE type_file.chr1,
           temp02         LIKE rwf_file.rwf04,
           temp03         LIKE rwf_file.rwf03,
           temp04         LIKE rwf_file.rwf21,
           temp05         LIKE rwf_file.rwf22,
           temp06         LIKE rwf_file.rwf11,
           temp07         LIKE rwf_file.rwf19,
           temp08         LIKE rwf_file.rwf16,
           temp09         LIKE rwf_file.rwf12,
           temp10         LIKE rwg_file.rwg06,
           temp11         LIKE rwg_file.rwg11,
           temp12         LIKE rwk_file.rwk08,
           temp13         LIKE rwk_file.rwk09,
           temp14         LIKE rwk_file.rwk08,
           temp15         LIKE rwk_file.rwk09,
           temp16         LIKE rwk_file.rwk10
                     END RECORD
DEFINE l_rwk06       LIKE rwk_file.rwk06
DEFINE l_rwk08       LIKE rwk_file.rwk08
DEFINE l_result      LIKE type_file.num5
DEFINE l_mod         LIKE type_file.num5
DEFINE l_times       LIKE type_file.num5
DEFINE l_n           LIKE type_file.num5
DEFINE l_rwk09        LIKE rwk_file.rwk09
DEFINE l_rwk10        LIKE rwk_file.rwk10

   LET g_sql = "SELECT ogb04,ogb05,ogb12,ogb14t FROM ogb_tmp ",
               "   WHERE ogb04 IN ",
               " (SELECT rwg06 ",
               "  FROM rwg_file WHERE rwg01 = '",p_rwf.rwf01,"'",
               "   AND rwg02 = '",p_rwf.rwf02,"' AND rwg03 = '",p_rwf.rwf03,"' ",
               "   AND rwg04 = '",p_rwf.rwf04,"') "

   DROP TABLE oeb_tmp
   LET g_sql = g_sql," INTO TEMP oeb_tmp "
   PREPARE pre_sel_rwg FROM g_sql
   EXECUTE pre_sel_rwg

   SELECT COUNT(*) INTO l_n FROM oeb_tmp
   IF l_n = 0 OR l_n IS NULL THEN
      DROP TABLE oeb_tmp
      RETURN
   END IF

   SELECT SUM(ogb12),SUM(ogb14t) INTO l_sum,l_sum1 FROM ogb_tmp
       WHERE ogb04 IN 
         (SELECT rwg06 
            FROM rwg_file WHERE rwg01 = p_rwf.rwf01
              AND rwg02 = p_rwf.rwf02 AND rwg03 = p_rwf.rwf03
              AND rwg04 = p_rwf.rwf04)
   IF l_sum IS NULL THEN LET l_sum = 0 END IF
   LET l_mod = l_sum MOD p_rwf.rwf16   
   LET l_result = l_sum - l_mod 
   LET l_times = l_result/p_rwf.rwf16
   IF l_times = 0 THEN RETURN END IF

   #LET g_sql = "SELECT * FROM oeb_tmp "
   #temp01-->temp14
   LET l_temp.temp01 = 'N'
   LET l_temp.temp02 = p_rwf.rwf04
   LET l_temp.temp03 = '4'
   LET l_temp.temp04 = p_rwf.rwf21
   LET l_temp.temp05 = p_rwf.rwf22
   LET l_temp.temp06 = p_rwf.rwf11
   LET l_temp.temp07 = p_rwf.rwf19
   LET l_temp.temp08 = p_rwf.rwf16
   LET l_temp.temp09 = 0
   LET l_temp.temp12 = l_result
   LET l_temp.temp13 = l_sum1 
   LET g_sql = "SELECT rwk06,rwk08,rwk09,rwk10 ",
               "   FROM rwk_file ",
               " WHERE rwkplant ='",p_rwf.rwfplant,"' AND rwk01 = '",p_rwf.rwf01,"'",
               "   AND rwk02 = '",p_rwf.rwf02,"' AND rwk03 = '",p_rwf.rwf03,"'",
               "   AND rwk04 = '",p_rwf.rwf04,"'",
               "   AND rwkplant='",p_rwf.rwfplant,"' "  
   PREPARE pre_sel_rwk FROM g_sql
   DECLARE cur_rwk CURSOR FOR pre_sel_rwk
   FOREACH cur_rwk INTO l_rwk06,l_rwk08,l_rwk09,l_rwk10
      LET l_temp.temp10 = l_rwk06
      LET l_temp.temp11 = l_rwk08
      IF l_temp.temp04 = '1' THEN
         LET l_temp.temp14 = (l_temp.temp12/l_temp.temp08)*l_temp.temp11
      ELSE
         LET l_temp.temp14 = l_temp.temp11
      END IF
      LET l_temp.temp15 = l_rwk09
      LET l_temp.temp16 = l_rwk10
      #LET l_temp.temp14 = (l_temp.temp12/l_temp.temp08)*l_temp.temp11
      INSERT INTO tmp1 VALUES(l_temp.*)
   END FOREACH 
END FUNCTION
FUNCTION t603_yes()
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_cnt1     LIKE type_file.num5   #FUN-B30012 ADD
DEFINE l_gen02    LIKE gen_file.gen02 
DEFINE l_rxx04    LIKE rxx_file.rxx04
DEFINE l_rxo10    LIKE rxo_file.rxo10
DEFINE l_ima25    LIKE ima_file.ima25   #FUN-B30012 ADD

#FUN-B30012 --ADD  ----BEGIN---------
DEFINE l_rxo      RECORD LIKE rxo_file.*
DEFINE l_flag     LIKE type_file.num5
DEFINE l_fac      LIKE ima_file.ima31_fac
DEFINE l_qty      LIKE img_file.img10
DEFINE l_img09    LIKE img_file.img09
DEFINE l_img10    LIKE img_file.img10
DEFINE l_oga92    LIKE oga_file.oga92
DEFINE l_i        LIKE type_file.num5
#FUN-B30012 --ADD  -----END----------
 
   IF g_rxm.rxm01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
#CHI-C30107 ---------------- add ---------------- begin 
   IF g_rxm.rxmconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rxm.rxmconf = 'X' THEN CALL cl_err(g_rxm.rxm01,'9024',0) RETURN END IF
   IF g_rxm.rxmacti = 'N' THEN CALL cl_err('','art-145',0) RETURN END IF
   IF NOT cl_confirm('art-026') THEN RETURN END IF
#CHI-C30107 ---------------- add ---------------- end
   SELECT * INTO g_rxm.* FROM rxm_file 
      WHERE rxm00 = g_rxm.rxm00 AND rxm01=g_rxm.rxm01
        AND rxmplant = g_rxm.rxmplant
   IF g_rxm.rxmconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rxm.rxmconf = 'X' THEN CALL cl_err(g_rxm.rxm01,'9024',0) RETURN END IF 
   IF g_rxm.rxmacti = 'N' THEN CALL cl_err('','art-145',0) RETURN END IF
###-FUN-B30012- ADD - BEGIN -----------------------------------
###-是否已經換贈-###
   IF g_rxm.rxm03 = '1' THEN
      FOR l_i = 1 TO g_rec_b
         INITIALIZE l_oga92 TO NULL
         SELECT oga92 INTO l_oga92 FROM oga_file WHERE oga01 = g_rxn[l_i].rxn04
            AND ogaconf = 'Y'
         IF NOT cl_null(l_oga92) THEN
            CALL cl_err('','art-132',0)
            RETURN
         END IF
      END FOR
   END IF
###-FUN-B30012- ADD -  END  -----------------------------------
 
   LET l_cnt=0
   LET l_cnt1 = 0               #FUN-B30012- ADD
   SELECT COUNT(*) INTO l_cnt
     FROM rxn_file
    WHERE rxn00 = g_rxm.rxm00 AND rxn01=g_rxm.rxm01
      AND rxnplant = g_rxm.rxmplant
###-FUN-B30012- ADD - BEGIN -------------------------------
   SELECT COUNT(*) INTO l_cnt1
     FROM rxo_file
    WHERE rxo00 = g_rxm.rxm00 AND rxo01=g_rxm.rxm01
      AND rxoplant = g_rxm.rxmplant
###-FUN-B30012- ADD -  END  -------------------------------
#  IF l_cnt=0 OR l_cnt IS NULL THEN                                    #FUN-B30012- MARK
   IF (l_cnt=0 OR l_cnt IS NULL) AND (l_cnt1=0 OR l_cnt1 IS NULL) THEN #FUN-B30012- ADD
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
   SELECT SUM(rxo10) INTO l_rxo10 FROM rxo_file
       WHERE rxo00 = g_rxm.rxm00 AND rxo01=g_rxm.rxm01
         AND rxoplant = g_rxm.rxmplant
   IF l_rxo10 IS NULL THEN LET l_rxo10 = 0 END IF
   SELECT SUM(rxx04) INTO l_rxx04 FROM rxx_file WHERE rxx00 = '09'
       AND rxx01 = g_rxm.rxm01 AND rxxplant = g_rxm.rxmplant 
   IF l_rxx04 IS NULL THEN LET l_rxx04 = 0 END IF
   IF l_rxx04 < l_rxo10 THEN
      CALL cl_err('','art-919',0)
      RETURN
   END IF
#  IF NOT cl_confirm('art-026') THEN RETURN END IF #CHI-C30107 mark
   BEGIN WORK
   CALL s_showmsg_init()   #FUN-B30012 ADD
   OPEN t603_cl USING g_rxm.rxm00,g_rxm.rxm01,g_rxm.rxmplant
   
   IF STATUS THEN
      CALL cl_err("OPEN t603_cl:", STATUS, 1)
      CLOSE t603_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t603_cl INTO g_rxm.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rxm.rxm01,SQLCA.sqlcode,0)
      CLOSE t603_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   LET g_success = 'Y'
 
   UPDATE rxm_file SET rxmconf='Y',
                       rxmcond=g_today, 
                       rxmconu=g_user
     WHERE  rxm00 = g_rxm.rxm00 AND rxm01=g_rxm.rxm01
       AND rxmplant = g_rxm.rxmplant
   IF SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   END IF
 
####--FUN-B30012--ADD----BEGIN-----------------------
   ###-更新出貨單中贈品發放單號-###
   IF g_rxm.rxm03 = '1' THEN
      FOR l_i = 1 TO g_rec_b
         UPDATE oga_file SET oga92 = g_rxm.rxm01 
          WHERE oga01 = g_rxn[l_i].rxn04
            AND ogaconf = 'Y'
         IF SQLCA.sqlerrd[3]=0 THEN
            LET g_success='N'
         END IF
      END FOR
   END IF

   LET g_sql = "SELECT * FROM rxo_file ",
               " WHERE rxo00 = '",g_rxm.rxm00,"'",
               "   AND rxo01 = '",g_rxm.rxm01,"'",
               "   AND rxoplant = '",g_rxm.rxmplant,"'"
   PREPARE t603_sel_rxo FROM g_sql
   DECLARE t603_sel_rxo_cs CURSOR FOR t603_sel_rxo
   FOREACH t603_sel_rxo_cs INTO l_rxo.*
      IF s_joint_venture(l_rxo.rxo03 ,g_rxm.rxmplant) 
         OR NOT s_internal_item(l_rxo.rxo03,g_rxm.rxmplant ) THEN
         CONTINUE FOREACH
      ELSE
         SELECT img09,img10 INTO l_img09,l_img10 FROM img_file
          WHERE img01 = l_rxo.rxo03
            AND img02 = l_rxo.rxo04  AND img03 = ' '
            AND img04 = ' '
         IF SQLCA.sqlcode = 100 THEN
            CALL s_errmsg('sel','','img_file',-1281,1)
            LET g_success = 'N'
            CONTINUE FOREACH
         END IF
      END IF
      
      SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = l_rxo.rxo03
      CALL s_umfchk(l_rxo.rxo03,l_rxo.rxo05,l_ima25)
         RETURNING l_flag,l_fac
      IF l_flag = 1 THEN
         CALL s_errmsg('sel',l_rxo.rxo03,'smd_file smc_file','aic-907',1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      LET l_qty = l_rxo.rxo07 * l_fac
      CALL s_upimg(l_rxo.rxo03,l_rxo.rxo04,' ',' ',-1,l_qty,g_today,
                   l_rxo.rxo03,l_rxo.rxo04,' ',' ',g_rxm.rxm01,
                   l_rxo.rxo02,l_rxo.rxo05,l_rxo.rxo07,
                   '','','','','','','','','','')
      CALL t603_tlf(l_rxo.*)
   END FOREACH
####--FUN-B30012--ADD-----END------------------------

   IF g_success = 'Y' THEN
      LET g_rxm.rxmconf='Y'
      COMMIT WORK
      CALL cl_flow_notify(g_rxm.rxm01,'Y')
   ELSE
      CALL s_showmsg()     #FUN-B30012--ADD
      ROLLBACK WORK
   END IF
 
   SELECT * INTO g_rxm.* FROM rxm_file 
      WHERE rxm00 = g_rxm.rxm00 AND rxm01=g_rxm.rxm01 
        AND rxmplant = g_rxm.rxmplant
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rxm.rxmconu
   DISPLAY BY NAME g_rxm.rxmconf                                                                                         
   DISPLAY BY NAME g_rxm.rxmcond                                                                                         
   DISPLAY BY NAME g_rxm.rxmconu
   DISPLAY l_gen02 TO FORMONLY.rxmconu_desc
    #CKP
   IF g_rxm.rxmconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_rxm.rxmconf,"","","",g_chr,"")
 
   CALL cl_flow_notify(g_rxm.rxm01,'V')
END FUNCTION

####--FUN-B30012--ADD----BEGIN-----------------------
###記錄異動###
FUNCTION t603_tlf(p_rxo)
DEFINE p_rxo       RECORD LIKE rxo_file.*
DEFINE l_img09     LIKE img_file.img09,
       l_img10     LIKE img_file.img10,
       l_img26     LIKE img_file.img26

   SELECT img09,img10,img26 INTO l_img09,l_img10,l_img26
     FROM img_file WHERE img01 = p_rxo.rxo03  AND img02 = p_rxo.rxo04
      AND img03 = ' '  AND img04 = ' '
   INITIALIZE g_tlf.* TO NULL
   LET g_tlf.tlf01 = p_rxo.rxo03
   LET g_tlf.tlf02 = 50
   LET g_tlf.tlf021 = p_rxo.rxo04
   LET g_tlf.tlf022 = ' '
   LET g_tlf.tlf023 = ' '
   LET g_tlf.tlf024 = l_img10
   LET g_tlf.tlf025 = l_img09
   LET g_tlf.tlf026 = g_rxm.rxm01
   LET g_tlf.tlf027 = p_rxo.rxo02
   LET g_tlf.tlf03 = 15
   LET g_tlf.tlf032 = ' '
   LET g_tlf.tlf033 = ' '
   LET g_tlf.tlf036 = g_rxm.rxm01
   LET g_tlf.tlf037 = p_rxo.rxo02
   LET g_tlf.tlf04 = ' '
   LET g_tlf.tlf05 = ' '
   LET g_tlf.tlf06 = g_today
   LET g_tlf.tlf07=g_today
   LET g_tlf.tlf08=TIME
   LET g_tlf.tlf09=g_user
   LET g_tlf.tlf10=p_rxo.rxo07
   LET g_tlf.tlf11=p_rxo.rxo05
   LET g_tlf.tlf12=p_rxo.rxo06
   LET g_tlf.tlf13='artt603'
   LET g_tlf.tlf15=l_img26
   LET g_tlf.tlf19 = ' '
   LET g_tlf.tlf60=p_rxo.rxo06
   LET g_tlf.tlf930 = p_rxo.rxoplant
   LET g_tlf.tlf903 = ' '
   LET g_tlf.tlf904 = ' '
   LET g_tlf.tlf905 = g_rxm.rxm01
   LET g_tlf.tlf906 = p_rxo.rxo02
   LET g_tlf.tlf907 = -1
   CALL s_imaQOH(p_rxo.rxo03) RETURNING g_tlf.tlf18
   CALL s_tlf(1,0)
END FUNCTION
####--FUN-B30012--ADD-----END------------------------
 
FUNCTION t603_void(p_type)
DEFINE p_type    LIKE type_file.chr1   #FUN-D20039  add '1' 作废  '2' 取消作废
DEFINE l_n          LIKE type_file.num5

###-FUN-B30012 - ADD - BEGIN ------------------------
DEFINE l_sql1       STRING
DEFINE l_bamt       LIKE type_file.num5
DEFINE l_rxx04      LIKE rxx_file.rxx04
###-FUN-B30012 - ADD -  END  ------------------------
 
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_rxm.* FROM rxm_file 
      WHERE rxm00 = g_rxm.rxm00 AND rxm01=g_rxm.rxm01
        AND rxmplant = g_rxm.rxmplant
   #FUN-D20039 ----------sta
    IF p_type = 1 THEN
       IF g_rxm.rxmconf='X' THEN RETURN END IF
    ELSE
       IF g_rxm.rxmconf <>'X' THEN RETURN END IF
    END IF
    #FUN-D20039 ----------end
   IF g_rxm.rxm01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_rxm.rxmconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rxm.rxmacti = 'N' THEN CALL cl_err(g_rxm.rxm01,'art-142',0) RETURN END IF
  # IF g_rxm.rxmconf = 'X' THEN CALL cl_err('','art-148',0) RETURN END IF  #FUN-D20039 mark
   
###-FUN-B30012 - ADD - BEGIN ----------------------------------
   LET l_sql1="select rxx04 from rxx_file where rxx00='09' AND rxx01='",g_rxm.rxm01,"' AND rxx03='1'"
   PREPARE t603_prxx04_5 FROM l_sql1
   DECLARE t603_crxx04_5 CURSOR FOR t603_prxx04_5
   LET l_bamt=0
   FOREACH t603_crxx04_5 INTO l_rxx04
       LET l_bamt=l_rxx04+l_bamt
   END FOREACH
   IF l_bamt>0 THEN
      CALL cl_err('','art-129',0)
      RETURN
   END IF
###-FUN-B30012 - ADD -  END  ----------------------------------

   BEGIN WORK
 
   OPEN t603_cl USING g_rxm.rxm00,g_rxm.rxm01,g_rxm.rxmplant
   IF STATUS THEN
      CALL cl_err("OPEN t603_cl:", STATUS, 1)
      CLOSE t603_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t603_cl INTO g_rxm.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rxm.rxm01,SQLCA.sqlcode,0)
      CLOSE t603_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   IF cl_void(0,0,g_rxm.rxmconf) THEN
      LET g_chr = g_rxm.rxmconf
      IF g_rxm.rxmconf = 'N' THEN
         LET g_rxm.rxmconf = 'X'
      ELSE
         LET g_rxm.rxmconf = 'N'
      END IF
 
      UPDATE rxm_file SET rxmconf=g_rxm.rxmconf,
                          rxmmodu=g_user,
                          rxmdate=g_today
       WHERE rxm01 = g_rxm.rxm01
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("upd","rxm_file",g_rxm.rxm01,"",SQLCA.sqlcode,"","up rxmconf",1)
          LET g_rxm.rxmconf = g_chr
          ROLLBACK WORK
          RETURN
       END IF
   END IF
 
   CLOSE t603_cl
   COMMIT WORK
 
   SELECT * INTO g_rxm.* FROM rxm_file WHERE rxm01=g_rxm.rxm01
   DISPLAY BY NAME g_rxm.rxmconf                                                                                        
   DISPLAY BY NAME g_rxm.rxmmodu                                                                                        
   DISPLAY BY NAME g_rxm.rxmdate
    #CKP
   IF g_rxm.rxmconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_rxm.rxmconf,"","","",g_chr,"")
 
   CALL cl_flow_notify(g_rxm.rxm01,'V')
END FUNCTION
FUNCTION t603_bp_refresh()
  DISPLAY ARRAY g_rxn TO s_rxn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        CALL SET_COUNT(g_rec_b+1)
        CALL fgl_set_arr_curr(g_rec_b+1)
        CALL cl_show_fld_cont()
        EXIT DISPLAY
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
 
END FUNCTION
 
FUNCTION t603_a()
   DEFINE li_result   LIKE type_file.num5
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10
   DEFINE l_cnt       LIKE type_file.num10
   DEFINE l_azp02     LIKE azp_file.azp02
   DEFINE l_gen02     LIKE gen_file.gen02
   DEFINE l_i         LIKE type_file.num5   #FUN-B30012 ADD
   DEFINE l_rxo10     LIKE rxo_file.rxo10   #FUN-B30012 ADD

   MESSAGE ""
   CLEAR FORM
   CALL g_rxn.clear() 
   CALL g_rxo.clear()
   LET g_wc = NULL
   LET g_wc2= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_rxm.* LIKE rxm_file.*
   LET g_rxm.rxm00 = '1' 
   LET g_rxm_t.* = g_rxm.*
   LET g_rxm_o.* = g_rxm.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_rxm.rxmuser=g_user
      LET g_rxm.rxmoriu = g_user  
      LET g_rxm.rxmorig = g_grup  
      LET g_rxm.rxmgrup=g_grup
      LET g_rxm.rxmacti='Y'
      LET g_rxm.rxmcrat = g_today
      LET g_rxm.rxmconf = 'N'
      LET g_rxm.rxm00 = '1'
      LET g_rxm.rxm02 = g_today
      LET g_rxm.rxm03 = '1'
      LET g_rxm.rxm06 = g_user
      LET g_rxm.rxmplant = g_plant
      LET g_rxm.rxmlegal = g_legal
      LET g_rxm.rxmmksg = 'N'
      LET g_rxm.rxm900 = '0'
      LET g_data_plant = g_plant #TQC-A10128 ADD

      SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rxm.rxmplant
      DISPLAY l_azp02 TO rxmplant_desc
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_rxm.rxm06
      DISPLAY l_gen02 TO rxm06_desc
      CALL t603_i("a")
 
      IF INT_FLAG THEN
         INITIALIZE g_rxm.* TO NULL
         LET g_rxm.rxm00 = '1' 
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_rxm.rxm01) THEN
         CONTINUE WHILE
      END IF
 
      BEGIN WORK
#     CALL s_auto_assign_no("art",g_rxm.rxm01,g_today,"","rxm_file","rxm01",g_rxm.rxmplant,"","")  #FUN-A70130 mark
#     CALL s_auto_assign_no("art",g_rxm.rxm01,g_today,"D1","rxm_file","rxm01",g_rxm.rxmplant,"","")  #FUN-A70130 mod #FUN-B30012 MARK
      CALL s_auto_assign_no("art",g_rxm.rxm01,g_today,"I7","rxm_file","rxm01",g_rxm.rxmplant,"","")  #FUN-B30012 ADD
         RETURNING li_result,g_rxm.rxm01 
      IF (NOT li_result) THEN  CONTINUE WHILE  END IF 
      DISPLAY BY NAME g_rxm.rxm01
      INSERT INTO rxm_file VALUES (g_rxm.*)
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      #   ROLLBACK WORK           # FUN-B80085---回滾放在報錯後---
         CALL cl_err3("ins","rxm_file",g_rxm.rxm01,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK            #FUN-B80085--add--
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_rxm.rxm01,'I')
      END IF
 
      LET g_rxm_t.* = g_rxm.*
      LET g_rxm_o.* = g_rxm.*
      CALL g_rxn.clear()
      CALL g_rxo.clear()
      LET g_rec_b = 0 
      LET g_rec_b1 = 0
      CALL t603_b()
#     IF g_rxm.rxm03 = '1' THEN CALL t603_kefa() END IF  #FUN-B30012 MARK 
 ###-FUN-B30012 - ADD - BEGIN -------------------------------------------
      IF g_rxm.rxm03 = '1' THEN
         IF g_rec_b > 0 THEN
            CALL s_gifts('00',g_rxm.rxm01,g_rxm.rxmplant,g_rxm.rxm02,'')
            ###-更新-###
            IF g_rxm.rxm03 = '1' THEN
               FOR l_i = 1 TO g_rec_b
                  INITIALIZE l_rxo10 TO NULL
                  SELECT SUM(rxo10) INTO l_rxo10 FROM rxo_file
                   WHERE rxo00 = g_rxm.rxm00
                     AND rxo01 = g_rxm.rxm01 AND rxo14 = g_rxn[l_i].rxn04
                     AND rxoplant = g_rxm.rxmplant
                  UPDATE rxn_file SET rxn07 = l_rxo10
                   WHERE rxn00 = g_rxm.rxm00
                     AND rxn01 = g_rxm.rxm01
                     AND rxn02 = g_rxn[l_i].rxn02
                     AND rxnplant = g_rxm.rxmplant
               END FOR
               CALL t603_b_fill(g_wc1)
            END IF
         END IF
         CALL t603_b1_fill(g_wc2)
         IF g_rec_b1 > 0 THEN
            CALL t603_b1()
         END IF 
      ELSE
         CALL t603_b1()
      END IF
      INITIALIZE l_rxo10 TO NULL
      SELECT SUM(rxo10) INTO l_rxo10 FROM rxo_file WHERE rxo00 = g_rxm.rxm00
         AND rxo01 = g_rxm.rxm01 AND rxoplant = g_rxm.rxmplant
      DISPLAY l_rxo10 TO FORMONLY.sum
 ###-FUN-B30012 - ADD -  END  -------------------------------------------
#     CALL t603_b1()             #FUN-B30012 MARK
      EXIT WHILE
   END WHILE
   CALL cl_set_act_visible("kefa",g_rxm.rxm03='1')  #FUN-B30012 ADD
   CALL t603_delall()            #FUN-B30012 ADD
 
END FUNCTION
 
FUNCTION t603_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rxm.rxm01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
  
   SELECT * INTO g_rxm.* FROM rxm_file 
      WHERE rxm00 = g_rxm.rxm00 AND rxm01=g_rxm.rxm01
        AND rxmplant = g_rxm.rxmplant
   IF g_rxm.rxmacti ='N' THEN
      CALL cl_err(g_rxm.rxm01,'mfg1000',0)
      RETURN
   END IF
   
   IF g_rxm.rxmconf = 'Y' THEN
      CALL cl_err('','art-024',0)
      RETURN
   END IF
 
   IF g_rxm.rxmconf = 'X' THEN
      CALL cl_err('','art-025',0)
      RETURN
   END IF
      
   MESSAGE ""
   CALL cl_opmsg('u')
 
   BEGIN WORK
 
   OPEN t603_cl USING g_rxm.rxm00,g_rxm.rxm01,g_rxm.rxmplant
 
   IF STATUS THEN
      CALL cl_err("OPEN t603_cl:", STATUS, 1)
      CLOSE t603_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t603_cl INTO g_rxm.*
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_rxm.rxm01,SQLCA.sqlcode,0)
       CLOSE t603_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t603_show()
 
   WHILE TRUE
      LET g_rxm_o.* = g_rxm.*
      LET g_rxm.rxmmodu=g_user
      LET g_rxm.rxmdate=g_today
 
      CALL t603_i("u")
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_rxm.*=g_rxm_t.*
         CALL t603_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_rxm.rxm01 != g_rxm_t.rxm01 THEN
         UPDATE rxn_file SET rxn01 = g_rxm.rxm01
           WHERE rxn00 = g_rxm_t.rxm00 AND rxn01 = g_rxm_t.rxm01
             AND rxnplant = g_rxm_t.rxmplant
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","rxn_file",g_rxm_t.rxm01,"",SQLCA.sqlcode,"","rxn",1)
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE rxm_file SET rxm_file.* = g_rxm.*
         WHERE rxm00 = g_rxm.rxm00 AND rxm01 = g_rxm.rxm01  
           AND rxmplant = g_rxm.rxmplant
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rxm_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t603_cl
   COMMIT WORK
   CALL cl_flow_notify(g_rxm.rxm01,'U')
 
   CALL t603_b_fill("1=1")
   CALL t603_b1_fill("1=1")

END FUNCTION
 
FUNCTION t603_i(p_cmd)
DEFINE
   l_pmc05   LIKE pmc_file.pmc05,
   l_pmc30   LIKE pmc_file.pmc30,
   l_n       LIKE type_file.num5,
   p_cmd     LIKE type_file.chr1,
   li_result   LIKE type_file.num5
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_rxm.rxm00,g_rxm.rxm02,g_rxm.rxm03,g_rxm.rxm06,
         #         g_rxm.rxmplant,g_rxm.rxmconf,g_rxm.rxmmksg,g_rxm.rxm900,#FUN-B30012 MARK
                   g_rxm.rxmplant,g_rxm.rxmconf,                           #FUN-B30012 ADD
                   g_rxm.rxmuser,g_rxm.rxmmodu,g_rxm.rxmgrup,g_rxm.rxmdate,
                   g_rxm.rxmacti,g_rxm.rxmcrat,g_rxm.rxmoriu,g_rxm.rxmorig
 
   CALL cl_set_head_visible("","YES") 
   
   INPUT BY NAME g_rxm.rxm01,g_rxm.rxm02,g_rxm.rxm03,g_rxm.rxm04,g_rxm.rxm05,
        #        g_rxm.rxm06,g_rxm.rxm07,g_rxm.rxmmksg,         #FUN-B30012 MARK
                 g_rxm.rxm06,g_rxm.rxm07,                       #FUN-B30012 ADD
                 g_rxm.rxmoriu,g_rxm.rxmorig,
                 g_rxm.rxmmodu,g_rxm.rxmacti,g_rxm.rxmgrup,
                 g_rxm.rxmdate,g_rxm.rxmcrat
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t603_set_entry(p_cmd)
         CALL t603_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
#         CALL cl_set_comp_visible('kefa',TRUE)
         CALL cl_set_docno_format("rxm01")
          
      AFTER FIELD rxm01
         IF NOT cl_null(g_rxm.rxm01) THEN
            IF p_cmd='a' OR 
               (p_cmd='u' AND g_rxm.rxm01 != g_rxm_t.rxm01) THEN 
#              CALL s_check_no("art",g_rxm.rxm01,g_rxm_t.rxm01,"9","rxm_file","rxm01","") #FUN-A70130 mark
#              CALL s_check_no("art",g_rxm.rxm01,g_rxm_t.rxm01,"D1","rxm_file","rxm01","") #FUN-A70130 mod  #FUN-B30012 MARK
               CALL s_check_no("art",g_rxm.rxm01,g_rxm_t.rxm01,"I7","rxm_file","rxm01","") #FUN-B30012 ADD
                  RETURNING li_result,g_rxm.rxm01
               DISPLAY BY NAME g_rxm.rxm01
               IF (NOT li_result) THEN                                                                                              
                  LET g_rxm.rxm01=g_rxm_t.rxm01                                                                                     
                  NEXT FIELD rxm01                                                                                                  
               END IF
            END IF
         END IF 

      AFTER FIELD rxm06
         IF NOT cl_null(g_rxm.rxm06) THEN
            IF p_cmd='a' OR 
               (p_cmd='u' AND g_rxm.rxm06 != g_rxm_t.rxm06) THEN
               CALL t603_rxm06()                                                                                                  
               IF NOT cl_null(g_errno)  THEN                                                                                         
                  CALL cl_err('',g_errno,0)                                                                                          
                  NEXT FIELD rxm06                                                                                                   
               END IF
            END IF
         END IF
            
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
 
      ON ACTION controlp
         CASE 
            WHEN INFIELD(rxm01)                                                                                                      
              LET g_t1=s_get_doc_no(g_rxm.rxm01)                                                                                    
#             CALL q_smy(FALSE,FALSE,g_t1,'ART','9') RETURNING g_t1   #FUN-A70130--mark--                                                              
#             CALL q_oay(FALSE,FALSE,g_t1,'D1','ART') RETURNING g_t1   #FUN-A70130--mod-- #FUN-B30012 MARK
              CALL q_oay(FALSE,FALSE,g_t1,'I7','ART') RETURNING g_t1   #FUN-B30012 ADD
              LET g_rxm.rxm01 = g_t1                                                                                                
              DISPLAY BY NAME g_rxm.rxm01                                                                                           
              NEXT FIELD rxm01
            WHEN INFIELD(rxm06)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gen"
               LET g_qryparam.default1 = g_rxm.rxm06
               CALL cl_create_qry() RETURNING g_rxm.rxm06
               DISPLAY BY NAME g_rxm.rxm06
               CALL t603_rxm06()
               NEXT FIELD rxm06
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
FUNCTION t603_rxm06()
DEFINE l_gen02    LIKE gen_file.gen02

   LET g_errno = ' '
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_rxm.rxm06 AND genacti = 'Y'

   CASE
      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'proj-15'
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   DISPLAY l_gen02 TO rxm06_desc
END FUNCTION
  
FUNCTION t603_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_rxn.clear()
   CALL g_rxo.clear()     #FUN-B30012 ADD
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t603_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_rxm.* TO NULL
      LET g_rxm.rxm00 = '1' 
      RETURN
   END IF
 
   OPEN t603_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_rxm.* TO NULL
      LET g_rxm.rxm00 = '1' 
   ELSE
      OPEN t603_count
      FETCH t603_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL t603_fetch('F')
   END IF
 
END FUNCTION
 
FUNCTION t603_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t603_cs INTO g_rxm.rxm00,g_rxm.rxm01,g_rxm.rxmplant
      WHEN 'P' FETCH PREVIOUS t603_cs INTO g_rxm.rxm00,g_rxm.rxm01,g_rxm.rxmplant
      WHEN 'F' FETCH FIRST    t603_cs INTO g_rxm.rxm00,g_rxm.rxm01,g_rxm.rxmplant
      WHEN 'L' FETCH LAST     t603_cs INTO g_rxm.rxm00,g_rxm.rxm01,g_rxm.rxmplant
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
        FETCH ABSOLUTE g_jump t603_cs INTO g_rxm.rxm00,g_rxm.rxm01,g_rxm.rxmplant
        LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rxm.rxm01,SQLCA.sqlcode,0)
      INITIALIZE g_rxm.* TO NULL
      LET g_rxm.rxm00 = '1' 
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
 
   SELECT * INTO g_rxm.* FROM rxm_file 
       WHERE rxm00 = g_rxm.rxm00 AND rxm01 = g_rxm.rxm01
         AND rxmplant = g_rxm.rxmplant
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","rxm_file","","",SQLCA.sqlcode,"","",1)
      INITIALIZE g_rxm.* TO NULL
      LET g_rxm.rxm00 = '1' 
      RETURN
   END IF
 
   LET g_data_owner = g_rxm.rxmuser
   LET g_data_group = g_rxm.rxmgrup
   LET g_data_plant = g_rxm.rxmplant #TQC-A10128 ADD
 
   CALL t603_show()
 
END FUNCTION
 
FUNCTION t603_show()
DEFINE  l_gen02  LIKE gen_file.gen02
DEFINE  l_azp02  LIKE azp_file.azp02
DEFINE  l_sum    LIKE rxn_file.rxn07    #FUN-B30012 ADD
 
   LET g_rxm_t.* = g_rxm.*
   LET g_rxm_o.* = g_rxm.*
   DISPLAY BY NAME g_rxm.rxm00,g_rxm.rxm01,g_rxm.rxm02,g_rxm.rxm03,  
                   g_rxm.rxm04,g_rxm.rxm05,g_rxm.rxm06,g_rxm.rxm07,
                   g_rxm.rxmplant,g_rxm.rxmconf,g_rxm.rxmcond,
         #         g_rxm.rxmconu,g_rxm.rxm900,g_rxm.rxmmksg,    #FUN-B30012 MARK
                   g_rxm.rxmconu,                               #FUN-B30012 ADD
                   g_rxm.rxmoriu,g_rxm.rxmorig,g_rxm.rxmuser,
                   g_rxm.rxmmodu,g_rxm.rxmacti,g_rxm.rxmgrup,
                   g_rxm.rxmdate,g_rxm.rxmcrat
 
   IF g_rxm.rxmconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF                                                                
   CALL cl_set_field_pic(g_rxm.rxmconf,"","","",g_chr,"")                                                                           
   CALL cl_flow_notify(g_rxm.rxm01,'V') 
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rxm.rxmconu
   DISPLAY l_gen02 TO FORMONLY.rxmconu_desc
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rxm.rxm06
   DISPLAY l_gen02 TO FORMONLY.rxm06_desc
   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rxm.rxmplant
   DISPLAY l_azp02 TO FORMONLY.rxmplant_desc
###-FUN-B30012- ADD - BEGIN -------------------------------------------
   SELECT SUM(rxo10) INTO l_sum FROM rxo_file WHERE rxo00 = g_rxm.rxm00
      AND rxo01 = g_rxm.rxm01 AND rxoplant = g_rxm.rxmplant
   DISPLAY l_sum TO FORMONLY.sum
###-FUN-B30012- ADD -  END  -------------------------------------------

   IF g_rxm.rxm03 = '1' THEN
   #  CALL cl_set_comp_visible("rxo11,rxo12",TRUE)        #FUN-B30012 MARK
      CALL cl_set_comp_visible("rxo11,rxo12,rxo14",TRUE)  #FUN-B30012 ADD
   ELSE
   #  CALL cl_set_comp_visible("rxo11,rxo12",FALSE)       #FUN-B30012 MARK
      CALL cl_set_comp_visible("rxo11,rxo12,rxo14",FALSE) #FUN-B30012 ADD
   END IF                        
   
   CALL cl_set_act_visible("kefa",g_rxm.rxm03='1')
   CALL t603_b_fill(g_wc1)
   CALL t603_b1_fill(g_wc2)
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION t603_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rxm.rxm01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   IF g_rxm.rxmconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rxm.rxmconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
   BEGIN WORK 
   OPEN t603_cl USING g_rxm.rxm00,g_rxm.rxm01,g_rxm.rxmplant
   IF STATUS THEN
      CALL cl_err("OPEN t603_cl:", STATUS, 1)
      CLOSE t603_cl
      RETURN
   END IF
 
   FETCH t603_cl INTO g_rxm.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rxm.rxm01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t603_show()
 
   IF g_rxm.rxmconf = 'Y' THEN
      CALL cl_err('','art-022',0)
      RETURN
   END IF 
   
   IF cl_exp(0,0,g_rxm.rxmacti) THEN
      LET g_chr=g_rxm.rxmacti
      IF g_rxm.rxmacti='Y' THEN
         LET g_rxm.rxmacti='N'
      ELSE
         LET g_rxm.rxmacti='Y'
      END IF
 
      UPDATE rxm_file SET rxmacti=g_rxm.rxmacti,
                          rxmmodu=g_user,
                          rxmdate=g_today
       WHERE rxm00 = g_rxm.rxm00 AND rxm01=g_rxm.rxm01
         AND rxmplant = g_rxm.rxmplant
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","rxm_file",g_rxm.rxm01,"",SQLCA.sqlcode,"","",1) 
         LET g_rxm.rxmacti=g_chr
      END IF
   END IF
 
   CLOSE t603_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_rxm.rxm01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT rxmacti,rxmmodu,rxmdate
     INTO g_rxm.rxmacti,g_rxm.rxmmodu,g_rxm.rxmdate FROM rxm_file
    WHERE rxm00 = g_rxm.rxm00 AND rxm01=g_rxm.rxm01
      AND rxmplant = g_rxm.rxmplant

   DISPLAY BY NAME g_rxm.rxmacti,g_rxm.rxmmodu,g_rxm.rxmdate
 
END FUNCTION
 
FUNCTION t603_r()
###-FUN-B30012 - ADD - BEGIN ------------------------
DEFINE l_sql1       STRING
DEFINE l_bamt       LIKE type_file.num5
DEFINE l_rxx04      LIKE rxx_file.rxx04
###-FUN-B30012 - ADD -  END  ------------------------
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rxm.rxm01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rxm.* FROM rxm_file
     WHERE rxm00 = g_rxm.rxm00 AND rxm01=g_rxm.rxm01
      AND rxmplant = g_rxm.rxmplant
 
   IF g_rxm.rxmconf = 'Y' THEN
      CALL cl_err('','art-023',1)
      RETURN
   END IF
   IF g_rxm.rxmconf = 'X' THEN 
      CALL cl_err('','9024',0)
      RETURN
   END IF
   IF g_rxm.rxmacti = 'N' THEN
      CALL cl_err('','aic-201',0)
      RETURN
   END IF
###-FUN-B30012 - ADD - BEGIN ----------------------------------
   LET l_sql1="select rxx04 from rxx_file where rxx00='09' AND rxx01='",g_rxm.rxm01,"' AND rxx03='1'"
   PREPARE t603_prxx04_4 FROM l_sql1
   DECLARE t603_crxx04_4 CURSOR FOR t603_prxx04_4
   LET l_bamt=0
   FOREACH t603_crxx04_4 INTO l_rxx04
       LET l_bamt=l_rxx04+l_bamt
   END FOREACH
   IF l_bamt>0 THEN
      CALL cl_err('','art-129',0)
      RETURN
   END IF
###-FUN-B30012 - ADD -  END  ----------------------------------
  
   BEGIN WORK
 
   OPEN t603_cl USING g_rxm.rxm00,g_rxm.rxm01,g_rxm.rxmplant
   IF STATUS THEN
      CALL cl_err("OPEN t603_cl:", STATUS, 1)
      CLOSE t603_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t603_cl INTO g_rxm.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rxm.rxm01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t603_show()
 
   IF cl_delh(0,0) THEN 
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "rxm01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_rxm.rxm01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
      DELETE FROM rxm_file WHERE rxm00 = g_rxm.rxm00 AND rxm01 = g_rxm.rxm01
         AND rxmplant = g_rxm.rxmplant
      DELETE FROM rxn_file WHERE rxn00 = g_rxm.rxm00 AND rxn01 = g_rxm.rxm01
         AND rxnplant = g_rxm.rxmplant 
      DELETE FROM rxo_file WHERE rxo00 = g_rxm.rxm00 AND rxo01 = g_rxm.rxm01
         AND rxoplant = g_rxm.rxmplant

      CLEAR FORM
      CALL g_rxn.clear() 
      CALL g_rxo.clear()

      OPEN t603_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE t603_cl
         CLOSE t603_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH t603_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t603_cl
         CLOSE t603_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t603_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t603_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t603_fetch('/')
      END IF
   END IF
 
   CLOSE t603_cl
   COMMIT WORK
   CALL cl_flow_notify(g_rxm.rxm01,'D')
END FUNCTION
 
FUNCTION t603_b()
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
DEFINE l_rtz04   LIKE rtz_file.rtz04
DEFINE l_azp03   LIKE azp_file.azp03
DEFINE l_line    LIKE type_file.num5
DEFINE l_sql1    STRING
DEFINE l_bamt    LIKE type_file.num5
DEFINE l_rxx04   LIKE rxx_file.rxx04

    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_rxm.rxm01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_rxm.* FROM rxm_file
     WHERE rxm00 = g_rxm.rxm00 AND rxm01=g_rxm.rxm01
       AND rxmplant = g_rxm.rxmplant
 
    IF g_rxm.rxm03 <> '1' THEN RETURN END IF       #FUN-B30012 ADD

    IF g_rxm.rxmacti ='N' THEN
       CALL cl_err(g_rxm.rxm01,'mfg1000',0)
       RETURN
    END IF
    
    IF g_rxm.rxmconf = 'Y' THEN
       CALL cl_err('','art-024',0)
       RETURN
    END IF
    IF g_rxm.rxmconf = 'X' THEN                                                                                             
       CALL cl_err('','art-025',0)                                                                                          
       RETURN                                                                                                               
    END IF
###-FUN-B30012 - ADD - BEGIN ----------------------------------
    IF g_rec_b1 > 0 THEN
       CALL cl_err('','art-130',0)
       RETURN
    END IF
    LET l_sql1="select rxx04 from rxx_file where rxx00='09' AND rxx01='",g_rxm.rxm01,"' AND rxx03='1'"
    PREPARE t603_prxx04_1 FROM l_sql1
    DECLARE t603_crxx04_1 CURSOR FOR t603_prxx04_1
    LET l_bamt=0
    FOREACH t603_crxx04_1 INTO l_rxx04
        LET l_bamt=l_rxx04+l_bamt
    END FOREACH
    IF l_bamt>0 THEN
       CALL cl_err('','art-129',0)
       RETURN
    END IF
###-FUN-B30012 - ADD -  END  ----------------------------------
    CALL cl_opmsg('b')
 
#   LET g_forupd_sql = "SELECT rxn02,rxn03,rxn04,rxn05,rxn06,rxn07,rxn08",    #FUN-B30012 MARK
    LET g_forupd_sql = "SELECT rxn02,rxn03,rxn04,rxn05,rxn06,'',rxn07,rxn08", #FUN-B30012 ADD
                       "  FROM rxn_file ",
                       " WHERE rxn00 = ? AND rxn01=? AND rxn02=? AND rxnplant = ? ",
                       " FOR UPDATE   "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t603_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_line = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_rxn WITHOUT DEFAULTS FROM s_rxn.*
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
 
           OPEN t603_cl USING g_rxm.rxm00,g_rxm.rxm01,g_rxm.rxmplant
           IF STATUS THEN
              CALL cl_err("OPEN t603_cl:", STATUS, 1)
              CLOSE t603_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t603_cl INTO g_rxm.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_rxm.rxm01,SQLCA.sqlcode,0)
              CLOSE t603_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_rxn_t.* = g_rxn[l_ac].*  #BACKUP
              LET g_rxn_o.* = g_rxn[l_ac].*  #BACKUP
              OPEN t603_bcl USING g_rxm.rxm00,g_rxm.rxm01,g_rxn_t.rxn02,g_rxm.rxmplant
              IF STATUS THEN
                 CALL cl_err("OPEN t603_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t603_bcl INTO g_rxn[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_rxn_t.rxn02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
       #FUN-B30012  ADD ----BEGIN-----------------------
                 SELECT oma10 INTO g_rxn[l_ac].l_oma10 FROM oma_file,oga_file
                  WHERE oga01 = g_rxn[l_ac].rxn04
                    AND oga10 = oma01
       #FUN-B30012  ADD -----END------------------------
              END IF
          END IF 
##FUN-B30012  MARK ----BEGIN-----------------------
#         IF g_rxn[l_ac].rxn04 IS NOT NULL THEN
#            CALL cl_set_comp_entry("rxn05",FALSE)
#         ELSE
#            CALL cl_set_comp_entry("rxn05",TRUE)
#         END IF
##FUN-B30012  MARK -----END------------------------
           
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_rxn[l_ac].* TO NULL
           LET g_rxn[l_ac].rxn03 = g_today            #Body default
#          CALL cl_set_comp_entry('rxn05',TRUE)       #FUN-B30012  MARK 
           CALL cl_set_comp_entry('rxn05',cl_null(g_rxn[l_ac].rxn04)) #FUN-B40006 ADD
           LET g_rxn_t.* = g_rxn[l_ac].*
           LET g_rxn_o.* = g_rxn[l_ac].*
           CALL cl_show_fld_cont()
           NEXT FIELD rxn02
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF cl_null(g_rxn[l_ac].rxn04) AND cl_null(g_rxn[l_ac].rxn05)
              AND cl_null(g_rxn[l_ac].rxn06) THEN
              CALL cl_err('','art-629',0)
              DISPLAY BY NAME g_rxn[l_ac].rxn07
           #  NEXT FIELD rxn04     #FUN-B40006 MARK
              CANCEL INSERT        #FUN-B40006 ADD
           END IF
           IF g_rxn[l_ac].rxn07 IS NULL THEN LET g_rxn[l_ac].rxn07 = 0 END IF
           INSERT INTO rxn_file(rxn00,rxn01,rxn02,rxn03,rxn04,rxn05,rxn06,
                                rxn07,rxn08,rxnplant,rxnlegal)   
           VALUES(g_rxm.rxm00,g_rxm.rxm01,g_rxn[l_ac].rxn02,
                  g_rxn[l_ac].rxn03,g_rxn[l_ac].rxn04,
                  g_rxn[l_ac].rxn05,g_rxn[l_ac].rxn06,
                  g_rxn[l_ac].rxn07,g_rxn[l_ac].rxn08,
                  g_rxm.rxmplant,g_rxm.rxmlegal)   
                 
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err3("ins","rxn_file",g_rxm.rxm01,g_rxn[l_ac].rxn02,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
           END IF
 
        BEFORE FIELD rxn02
           IF g_rxn[l_ac].rxn02 IS NULL OR g_rxn[l_ac].rxn02 = 0 THEN
              SELECT max(rxn02)+1
                INTO g_rxn[l_ac].rxn02
                FROM rxn_file
               WHERE rxn00 = g_rxm.rxm00 AND rxn01 = g_rxm.rxm01
                 AND rxnplant = g_rxm.rxmplant
              IF g_rxn[l_ac].rxn02 IS NULL THEN
                 LET g_rxn[l_ac].rxn02 = 1
              END IF
           END IF
 
        AFTER FIELD rxn02
           IF NOT cl_null(g_rxn[l_ac].rxn02) THEN
              IF g_rxn[l_ac].rxn02 != g_rxn_t.rxn02
                 OR g_rxn_t.rxn02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM rxn_file
                  WHERE rxn00 = g_rxm.rxm00 AND rxn01 = g_rxm.rxm01
                    AND rxn02 = g_rxn[l_ac].rxn02 AND rxnplant = g_rxm.rxmplant
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_rxn[l_ac].rxn02 = g_rxn_t.rxn02
                    NEXT FIELD rxn02
                 END IF
              END IF
           END IF
 
      AFTER FIELD rxn03
         IF NOT cl_null(g_rxn[l_ac].rxn03) THEN
            CALL t603_rxn04_3()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_rxn[l_ac].rxn04,g_errno,0)
               NEXT FIELD rxn04
            END IF
         END IF
      AFTER FIELD rxn04
         IF NOT cl_null(g_rxn[l_ac].rxn04) THEN
            IF g_rxn_o.rxn04 IS NULL OR
               (g_rxn[l_ac].rxn04 != g_rxn_o.rxn04 ) THEN
               CALL t603_rxn04()    #檢查其有效性及帶出值          
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rxn[l_ac].rxn04,g_errno,0)
                  NEXT FIELD rxn04
               END IF
               CALL t603_check()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rxn[l_ac].rxn04,g_errno,0)
                  NEXT FIELD rxn04
               END IF
               CALL t603_rxn04_3()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rxn[l_ac].rxn04,g_errno,0)
                  NEXT FIELD rxn04
               END IF
               CALL t603_kehu('1')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rxn[l_ac].rxn04,g_errno,0)
                  NEXT FIELD rxn04
               END IF
               CALL t603_check_rxn04()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rxn[l_ac].rxn04,g_errno,0)
                  NEXT FIELD rxn04
               END IF
            END IF  
         END IF 
##FUN-B30012  MARK -----BEGIN----------------------
#        IF NOT cl_null(g_rxn[l_ac].rxn04) THEN  
#           CALL cl_set_comp_entry('rxn05',FALSE)
#        ELSE  
#           CALL cl_set_comp_entry('rxn05',TRUE)    
#        END IF   
#        BEFORE FIELD rxn05
#           IF NOT cl_null(g_rxn[l_ac].rxn04) THEN
#              CALL cl_set_comp_entry('rxn05',FALSE)
#           ELSE   
#              CALL cl_set_comp_entry('rxn05',TRUE)
#           END IF
#
#       AFTER FIELD rxn05
#        IF NOT cl_null(g_rxn[l_ac].rxn05) THEN
#           IF g_rxn_o.rxn05 IS NULL OR
#              (g_rxn[l_ac].rxn05 != g_rxn_o.rxn05 ) THEN
#              CALL t603_rxn05()    #檢查其有效性及帶出值          
#              IF NOT cl_null(g_errno) THEN
#                 CALL cl_err(g_rxn[l_ac].rxn05,g_errno,0)
#                 NEXT FIELD rxn05
#              END IF
#              CALL t603_check()
#              IF NOT cl_null(g_errno) THEN
#                 CALL cl_err(g_rxn[l_ac].rxn05,g_errno,0)
#                 NEXT FIELD rxn05
#              END IF
#              CALL t603_kehu('2')
#              IF NOT cl_null(g_errno) THEN
#                 CALL cl_err(g_rxn[l_ac].rxn05,g_errno,0)
#                 NEXT FIELD rxn05
#              END IF
#              CALL t603_check_rxn05()
#              IF NOT cl_null(g_errno) THEN
#                 CALL cl_err(g_rxn[l_ac].rxn05,g_errno,0)
#                 NEXT FIELD rxn05
#              END IF               
#           END IF  
#        END IF         
##FUN-B30012  MARK -----END------------------------
###-FUN-B40006- ADD - BEGIN -----------------------------------
         IF NOT cl_null(g_rxn[l_ac].rxn04) THEN
            CALL cl_set_comp_entry('rxn05',FALSE)
         ELSE
            CALL cl_set_comp_entry('rxn05',TRUE)
         END IF
         BEFORE FIELD rxn05
            IF NOT cl_null(g_rxn[l_ac].rxn04) THEN
               CALL cl_set_comp_entry('rxn05',FALSE)
            ELSE
               CALL cl_set_comp_entry('rxn05',TRUE)
            END IF
 
        AFTER FIELD rxn05
         IF NOT cl_null(g_rxn[l_ac].rxn05) THEN
            IF g_rxn_o.rxn05 IS NULL OR
               (g_rxn[l_ac].rxn05 != g_rxn_o.rxn05 ) THEN
               CALL t603_rxn05()    #檢查其有效性及帶出值
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rxn[l_ac].rxn05,g_errno,0)
                  NEXT FIELD rxn05
               END IF
               CALL t603_check()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rxn[l_ac].rxn05,g_errno,0)
                  NEXT FIELD rxn05
               END IF
               CALL t603_kehu('2')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rxn[l_ac].rxn05,g_errno,0)
                  NEXT FIELD rxn05
               END IF
               CALL t603_check_rxn05()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rxn[l_ac].rxn05,g_errno,0)
                  NEXT FIELD rxn05
               END IF
            END IF
         END IF
###-FUN-B40006- ADD -  END  -----------------------------------
        AFTER FIELD rxn07
           IF NOT cl_null(g_rxn[l_ac].rxn07) THEN
              IF g_rxn[l_ac].rxn07 <= 0 THEN
                 CALL cl_err('','alm-342',0)
                 NEXT FIELD rxn07                
              END IF
           END IF
        
        BEFORE DELETE
           DISPLAY "BEFORE DELETE"
           IF g_rxn_t.rxn02 > 0 AND g_rxn_t.rxn02 IS NOT NULL THEN
              LET l_sql1="select rxx04 from rxx_file where rxx00='09' AND rxx01='",g_rxm.rxm01,"' AND rxx03='1'"
              PREPARE t603_prxx04 FROM l_sql1
              DECLARE t603_crxx04 CURSOR FOR t603_prxx04
              LET l_bamt=0
              FOREACH t603_crxx04 INTO l_rxx04
                  LET l_bamt=l_rxx04+l_bamt
              END FOREACH 
              IF l_bamt>0 THEN
                 CALL cl_err('','art-634',1) 
                 CANCEL DELETE
              END IF 
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rxn_file
               WHERE rxn00 = g_rxm.rxm00 AND rxn01 = g_rxm.rxm01
                 AND rxn02 = g_rxn_t.rxn02  AND rxnplant = g_rxm.rxmplant
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rxn_file",g_rxm.rxm01,g_rxn_t.rxn02,SQLCA.sqlcode,"","",1) 
                 ROLLBACK WORK
                 CANCEL DELETE
              ELSE 
                 #FUN-B80085增加空白行

               	 DELETE FROM rxo_file 
               	  WHERE rxo00 = g_rxm.rxm00 AND rxo01 = g_rxm.rxm01
                    AND rxoplant = g_rxm.rxmplant
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","rxo_file",g_rxm.rxm01,g_rxn_t.rxn02,SQLCA.sqlcode,"","",1) 
                    ROLLBACK WORK
                    CANCEL DELETE
                 END IF 
              END IF
              LET g_rec_b=g_rec_b-1
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rxn[l_ac].* = g_rxn_t.*
              CLOSE t603_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF cl_null(g_rxn[l_ac].rxn04) AND cl_null(g_rxn[l_ac].rxn05)
              AND cl_null(g_rxn[l_ac].rxn06) THEN
              CALL cl_err('','art-629',0)
              NEXT FIELD rxn04
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rxn[l_ac].rxn02,-263,1)
              LET g_rxn[l_ac].* = g_rxn_t.*
           ELSE
              SELECT COUNT(*) INTO l_n FROM rxn_file
               WHERE rxn00 = g_rxm.rxm00 AND rxn01=g_rxm.rxm01
                 AND rxn02=g_rxn_t.rxn02 AND rxnplant = g_rxm.rxmplant
              IF l_n = 0 THEN
                 INSERT INTO rxn_file(rxn00,rxn01,rxn02,rxn03,rxn04,rxn05,rxn06,
                                      rxn07,rxn08,rxnplant,rxnlegal)   
                    VALUES(g_rxm.rxm00,g_rxm.rxm01,g_rxn[l_ac].rxn02,
                           g_rxn[l_ac].rxn03,g_rxn[l_ac].rxn04,
                           g_rxn[l_ac].rxn05,g_rxn[l_ac].rxn06,
                           g_rxn[l_ac].rxn07,g_rxn[l_ac].rxn08,
                           g_rxm.rxmplant,g_rxm.rxmlegal)   
              ELSE
                 UPDATE rxn_file SET rxn02=g_rxn[l_ac].rxn02,
                                     rxn03=g_rxn[l_ac].rxn03,
                                     rxn04=g_rxn[l_ac].rxn04,
                                     rxn05=g_rxn[l_ac].rxn05,
                                     rxn06=g_rxn[l_ac].rxn06,
                                     rxn07=g_rxn[l_ac].rxn07,
                                     rxn08=g_rxn[l_ac].rxn08
                   WHERE rxn00 = g_rxm.rxm00 AND rxn01=g_rxm.rxm01
                     AND rxn02=g_rxn_t.rxn02 AND rxnplant = g_rxm.rxmplant
              END IF
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rxn_file",g_rxm.rxm01,g_rxn_t.rxn02,SQLCA.sqlcode,"","",1) 
                 LET g_rxn[l_ac].* = g_rxn_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
#          LET l_ac_t = l_ac                  #FUN-D30033 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rxn[l_ac].* = g_rxn_t.*
              #FUN-D30033---add---str---
              ELSE
                 CALL g_rxn.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_flag_b = '1'
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033---add---end---
              END IF
              CLOSE t603_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac                  #FUN-D30033 add
           CLOSE t603_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO
           IF INFIELD(rxn02) AND l_ac > 1 THEN
              LET g_rxn[l_ac].* = g_rxn[l_ac-1].*
              LET g_rxn[l_ac].rxn02 = g_rec_b + 1
              NEXT FIELD rxn02
           END IF
 
        ON ACTION CONTROLZ
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(rxn04)
                 CALL cl_init_qry_var()
                 IF g_rxn[l_ac].rxn03 IS NULL THEN
                    LET g_qryparam.form ="q_oga3"
                 ELSE
                    LET g_qryparam.form ="q_oga3_1"
                    LET g_qryparam.arg1 = g_rxn[l_ac].rxn03 
                 END IF
                 LET g_qryparam.where = "oga01 IN (SELECT rxd01 FROM rxd_file) AND oga92 IS NULL"  #FUN-B30012 ADD
                 LET g_qryparam.default1 = g_rxn[l_ac].rxn04
                 CALL cl_create_qry() RETURNING g_rxn[l_ac].rxn04
                 DISPLAY BY NAME g_rxn[l_ac].rxn04
                 CALL t603_rxn04()
                 NEXT FIELD rxn04 
              WHEN INFIELD(rxn05)
                 CALL cl_init_qry_var()
                IF g_rxn[l_ac].rxn03 IS NULL THEN                    #No.TQC-A10131
#                 IF cl_null(g_rxn[l_ac].rxn04) THEN                   #No.TQC-A10131
                    LET g_qryparam.form ="q_oea01"
                 ELSE
                    LET g_qryparam.form ="q_oea01_7"
                    LET g_qryparam.arg1 = g_rxn[l_ac].rxn03
                 END IF
                 LET g_qryparam.default1 = g_rxn[l_ac].rxn05
                 CALL cl_create_qry() RETURNING g_rxn[l_ac].rxn05                 
                 DISPLAY BY NAME g_rxn[l_ac].rxn05                 
                 CALL t603_rxn05()
                 NEXT FIELD rxn05
              #WHEN INFIELD(rxn06)
              #   CALL cl_init_qry_var()
              #   LET g_qryparam.form ="q_oga3"
              #   LET g_qryparam.default1 = g_rxn[l_ac].rxn06
              #   CALL cl_create_qry() RETURNING g_rxn[l_ac].rxn06                 
              #   DISPLAY BY NAME g_rxn[l_ac].rxn06                 
              #   #CALL t603_rxn06()
              #   NEXT FIELD rxn06
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
    
    UPDATE rxm_file SET rxmmodu = g_rxm.rxmmodu,rxmdate = g_rxm.rxmdate
       WHERE rxm01 = g_rxm.rxm01
         AND rxm00 = g_rxm.rxm00
         AND rxmplant = g_rxm.rxmplant 
    DISPLAY BY NAME g_rxm.rxmmodu,g_rxm.rxmdate
     
    CLOSE t603_bcl
    COMMIT WORK
#   CALL t603_delall()   FUN-B30012 MARK
 
END FUNCTION
 
FUNCTION t603_delall()
 
   LET g_cnt1 = 0      #-FUN-B30012 - ADD
   SELECT COUNT(*) INTO g_cnt FROM rxn_file
    WHERE rxn00 = g_rxm.rxm00 AND rxn01 = g_rxm.rxm01
      AND rxnplant = g_rxm.rxmplant
###-FUN-B30012 - ADD - BEGIN ------------------------
   SELECT COUNT(*) INTO g_cnt1 FROM rxo_file
    WHERE rxo00 = g_rxm.rxm00 AND rxo01 = g_rxm.rxm01
      AND rxoplant = g_rxm.rxmplant
###-FUN-B30012 - ADD -  END  ------------------------
 
#  IF g_cnt = 0 THEN
   IF g_cnt = 0 AND g_cnt1 = 0 THEN                 #-FUN-B30012 - ADD
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM rxm_file WHERE rxm01 = g_rxm.rxm01
      CALL g_rxn.clear()
   END IF
END FUNCTION

FUNCTION t603_b1()
DEFINE
    l_ac1_t         LIKE type_file.num5,
    l_cnt           LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5
###-FUN-B30012 - ADD - BEGIN ------------------------
DEFINE l_sql1       STRING
DEFINE l_bamt       LIKE type_file.num5
DEFINE l_rxx04      LIKE rxx_file.rxx04
###-FUN-B30012 - ADD -  END  ------------------------
DEFINE l_case     STRING   #No.FUN-BB0086

 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_rxm.rxm01 IS NULL THEN
       RETURN
    END IF
#   IF g_rxm.rxm03 = '1' THEN RETURN END IF           #FUN-B30012 MARK
   ###FUN-B30012 ADD ----BEGIN----
    IF g_rxm.rxm03 = '1' THEN
       CALL cl_set_comp_entry("rxo02,rxo03,rxo05,rxo07,rxo08,rxo09,rxo10",FALSE)
    ELSE
       CALL cl_set_comp_entry("rxo02,rxo03,rxo05,rxo07,rxo09,rxo10",TRUE)
    END IF
   ###FUN-B30012 ADD -----END-----
 
    SELECT * INTO g_rxm.* FROM rxm_file
     WHERE rxm00 = g_rxm.rxm00 AND rxm01=g_rxm.rxm01
       AND rxmplant = g_rxm.rxmplant
 
    IF g_rxm.rxmacti ='N' THEN
       CALL cl_err(g_rxm.rxm01,'mfg1000',0)
       RETURN
    END IF
    
    IF g_rxm.rxmconf = 'Y' THEN
       CALL cl_err('','art-024',0)
       RETURN
    END IF
    IF g_rxm.rxmconf = 'X' THEN                                                                                             
       CALL cl_err('','art-025',0)                                                                                          
       RETURN                                                                                                               
    END IF
###-FUN-B30012 - ADD - BEGIN ----------------------------------
    LET l_sql1="select rxx04 from rxx_file where rxx00='09' AND rxx01='",g_rxm.rxm01,"' AND rxx03='1'"
    PREPARE t603_prxx04_2 FROM l_sql1
    DECLARE t603_crxx04_2 CURSOR FOR t603_prxx04_2
    LET l_bamt=0
    FOREACH t603_crxx04_2 INTO l_rxx04
        LET l_bamt=l_rxx04+l_bamt
    END FOREACH
    IF l_bamt>0 THEN
       CALL cl_err('','art-129',0)
       RETURN
    END IF
###-FUN-B30012 - ADD -  END  ----------------------------------
    CALL cl_opmsg('b')
    IF g_rxm.rxm03 <> '1' THEN     ###-FUN-B30012 - ADD
    #  CALL cl_set_comp_visible("rxo11,rxo12",FALSE)         #FUN-B30012 MARK
       CALL cl_set_comp_visible("rxo11,rxo12,rxo14",FALSE)   #FUN-B30012 ADD
###-FUN-B30012 - ADD - BEGIN ------------------------------
    ELSE
       CALL cl_set_comp_visible("rxo11,rxo12,rxo14",TRUE)
    END IF
###-FUN-B30012 - ADD -  END  ------------------------------
#   LET g_forupd_sql = "SELECT rxo02,rxo03,rxo04,'',rxo05,'',rxo06,",   #FUN-B30012 MARK
    LET g_forupd_sql = "SELECT rxo02,rxo14,rxo03,rxo05,'',rxo04,'',rxo06,",   #FUN-B30012 ADD 
#                      "rxo07,rxo08,rxo09,rxo10,rxo11,rxo12,rxo13 ",    #FUN-B30012 MARK
                       "rxo07,rxo08,rxo09,rxo10,rxo12,rxo11,rxo13 ",    #FUN-B30012 ADD
                       "  FROM rxo_file ",
                       " WHERE rxo00 = ? AND rxo01=? AND rxo02=? AND rxoplant = ? ",
                       " FOR UPDATE   "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t6031_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
###-FUN-B30012 - ADD - BEGIN ------------------------------
###如果為消費領贈則不可以新增###
    IF g_rxm.rxm03 = '1' THEN
       LET l_allow_insert = FALSE
    END IF
###-FUN-B30012 - ADD -  END  ------------------------------
 
    INPUT ARRAY g_rxo WITHOUT DEFAULTS FROM s_rxo.*
          ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b1 != 0 THEN
              CALL fgl_set_arr_curr(l_ac1)
           END IF
           LET g_rxo05_t = NULL   #No.FUN-BB0086
 
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac1 = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN t603_cl USING g_rxm.rxm00,g_rxm.rxm01,g_rxm.rxmplant
           IF STATUS THEN
              CALL cl_err("OPEN t603_cl:", STATUS, 1)
              CLOSE t603_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t603_cl INTO g_rxm.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_rxm.rxm01,SQLCA.sqlcode,0)
              CLOSE t603_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b1 >= l_ac1 THEN
              LET p_cmd='u'
              LET g_rxo_t.* = g_rxo[l_ac1].*  #BACKUP
              LET g_rxo_o.* = g_rxo[l_ac1].*  #BACKUP
              LET g_rxo05_t = g_rxo[l_ac1].rxo05   #No.FUN-BB0086
              OPEN t6031_bcl USING g_rxm.rxm00,g_rxm.rxm01,g_rxo_t.rxo02,g_rxm.rxmplant
              IF STATUS THEN
                 CALL cl_err("OPEN t6031_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t6031_bcl INTO g_rxo[l_ac1].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_rxo_t.rxo02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL t603_rxo04('d')
                 CALL t603_rxo05('d')
              END IF
           END IF 
           
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_rxo[l_ac1].* TO NULL
           LET g_rxo[l_ac1].rxo08 = 0            #Body default
           LET g_rxo[l_ac1].rxo07 =  0            #Body default   
           LET g_rxo[l_ac1].rxo09 =  0
           LET g_rxo[l_ac1].rxo10 =  0 
           LET g_rxo[l_ac1].rxo12 = 1
           LET g_rxo_t.* = g_rxo[l_ac1].*
           LET g_rxo_o.* = g_rxo[l_ac1].*
           CALL cl_show_fld_cont()
           NEXT FIELD rxo02
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO rxo_file(rxo00,rxo01,rxo02,rxo03,rxo04,rxo05,rxo06,
                                rxo07,rxo08,rxo09,rxo10,rxo11,rxo12,rxo13,
                  #             rxoplant,rxolegal)             #FUN-B30012 MARK
                                rxo14,rxoplant,rxolegal)       #FUN-B30012 ADD
           VALUES(g_rxm.rxm00,g_rxm.rxm01,g_rxo[l_ac1].rxo02,
                  g_rxo[l_ac1].rxo03,g_rxo[l_ac1].rxo04,
                  g_rxo[l_ac1].rxo05,g_rxo[l_ac1].rxo06,
                  g_rxo[l_ac1].rxo07,g_rxo[l_ac1].rxo08,
                  g_rxo[l_ac1].rxo09,g_rxo[l_ac1].rxo10,
                  g_rxo[l_ac1].rxo11,g_rxo[l_ac1].rxo12,
            #     g_rxo[l_ac1].rxo13,                          #FUN-B30012 MARK
                  g_rxo[l_ac1].rxo13,g_rxo[l_ac1].rxo14,       #FUN-B30012 ADD
                  g_rxm.rxmplant,g_rxm.rxmlegal)   
                 
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err3("ins","rxo_file",g_rxm.rxm01,g_rxo[l_ac1].rxo02,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b1=g_rec_b1+1
           END IF
 
        BEFORE FIELD rxo02
           IF g_rxo[l_ac1].rxo02 IS NULL OR g_rxo[l_ac1].rxo02 = 0 THEN
              SELECT max(rxo02)+1
                INTO g_rxo[l_ac1].rxo02
                FROM rxo_file
               WHERE rxo00 = g_rxm.rxm00 AND rxo01 = g_rxm.rxm01
                 AND rxoplant = g_rxm.rxmplant
              IF g_rxo[l_ac1].rxo02 IS NULL THEN
                 LET g_rxo[l_ac1].rxo02 = 1
              END IF
           END IF
 
        AFTER FIELD rxo02
           IF NOT cl_null(g_rxo[l_ac1].rxo02) THEN
              IF g_rxo[l_ac1].rxo02 != g_rxo_t.rxo02
                 OR g_rxo_t.rxo02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM rxo_file
                  WHERE rxo00 = g_rxm.rxm00 AND rxo01 = g_rxm.rxm01
                    AND rxo02 = g_rxo[l_ac1].rxo02 AND rxoplant = g_rxm.rxmplant
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_rxo[l_ac1].rxo02 = g_rxo_t.rxo02
                    NEXT FIELD rxo02
                 END IF
              END IF
           END IF
 
      AFTER FIELD rxo03
         IF NOT cl_null(g_rxo[l_ac1].rxo03) THEN
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_rxo[l_ac1].rxo03,"") THEN
               CALL cl_err('',g_errno,1)
               LET g_rxo[l_ac1].rxo03= g_rxo_t.rxo03
               NEXT FIELD rxo03
            END IF
#FUN-AA0059 ---------------------end-------------------------------
            IF g_rxo_o.rxo03 IS NULL OR
               (g_rxo[l_ac1].rxo03 != g_rxo_o.rxo03 ) THEN
               CALL t603_rxo03()    #檢查其有效性          
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rxo[l_ac1].rxo03,g_errno,0)
                  LET g_rxo[l_ac1].rxo03 = g_rxo_o.rxo03
                  NEXT FIELD rxo03
               END IF
               CALL t603_compute()
               IF NOT cl_null(g_errno) THEN 
                  CALL cl_err(g_rxo[l_ac1].rxo03,g_errno,0)
                  NEXT FIELD rxo03
               END IF 
            END IF  
         END IF 
      AFTER FIELD rxo04
         IF NOT cl_null(g_rxo[l_ac1].rxo04) THEN
            IF g_rxo_o.rxo04 IS NULL OR
               (g_rxo[l_ac1].rxo04 != g_rxo_o.rxo04 ) THEN
               CALL t603_rxo04('a')    #檢查其有效性          
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rxo[l_ac1].rxo04,g_errno,0)
                  LET g_rxo[l_ac1].rxo04 = g_rxo_o.rxo04
                  NEXT FIELD rxo04
               END IF
            END IF  
         END IF  
         #FUN-AB0016  --modify
         IF NOT s_chk_ware1(g_rxo[l_ac1].rxo04,g_rxm.rxmplant) THEN
            NEXT FIELD rxo04
         END IF 
         #FUN-AB0016  --end
         
      AFTER FIELD rxo05
         LET l_case = ""   #No.FUN-BB0086
         IF NOT cl_null(g_rxo[l_ac1].rxo05) THEN
            IF g_rxo_o.rxo05 IS NULL OR
               (g_rxo[l_ac1].rxo05 != g_rxo_o.rxo05 ) THEN
               CALL t603_rxo05('a')    #檢查其有效性          
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rxo[l_ac1].rxo05,g_errno,0)
                  LET g_rxo[l_ac1].rxo05 = g_rxo_o.rxo05
                  NEXT FIELD rxo05
               END IF
               CALL t603_compute()
               IF NOT cl_null(g_errno) THEN 
                  CALL cl_err(g_rxo[l_ac1].rxo04,g_errno,0)
                  NEXT FIELD rxo05
               END IF
            END IF  
            #No.FUN-BB0086--add--begin--
            IF NOT cl_null(g_rxo[l_ac].rxo07) AND g_rxo[l_ac].rxo07 <> 0 THEN  #TQC-C20183 add
               IF NOT t603_rxo07_check() THEN 
                  LET l_case = "rxo07"
               END IF 
            END IF                                                             #TQC-C20183 add
            IF NOT cl_null(g_rxo[l_ac].rxo08) AND g_rxo[l_ac].rxo08 <> 0 THEN  #TQC-C20183 add
               IF NOT t603_rxo08_check() THEN 
                  LET l_case = "rxo08"
               END IF 
            END IF                                                             #TQC-C20183 add
            LET g_rxo05_t = g_rxo[l_ac].rxo05
            CASE l_case
               WHEN "rxo07" NEXT FIELD rxo07
               WHEN "rxo08" NEXT FIELD rxo08
               OTHERWISE EXIT CASE 
            END CASE 
            #No.FUN-BB0086--add--end--
         END IF
        
        
        AFTER FIELD rxo07
           IF NOT t603_rxo07_check() THEN NEXT FIELD rxo07 END IF   #No.FUN-BB0086
           #No.FUN-BB0086--mark--begin--
           #IF NOT cl_null(g_rxo[l_ac1].rxo07) THEN
           #   IF g_rxo[l_ac1].rxo07 <= 0 THEN
           #      CALL cl_err('','aem-042',0)
           #      NEXT FIELD rxo07                
           #   END IF
           #   IF NOT cl_null(g_rxo[l_ac1].rxo09) THEN 
           #      LET g_rxo[l_ac1].rxo10=g_rxo[l_ac1].rxo07 *g_rxo[l_ac1].rxo09
           #      DISPLAY BY NAME g_rxo[l_ac1].rxo10
           #   END IF 
           #END IF
           #No.FUN-BB0086--mark--end--
        AFTER FIELD rxo08
           IF NOT t603_rxo08_check() THEN NEXT FIELD rxo08 END IF   #No.FUN-BB0086
           #No.FUN-BB0086--mark--begin--
           #IF NOT cl_null(g_rxo[l_ac1].rxo08) THEN
           #   IF g_rxo[l_ac1].rxo08 <= 0 THEN
           #      CALL cl_err('','aem-042',0)
           #      NEXT FIELD rxo08                
           #   END IF
           #END IF
           #No.FUN-BB0086--mark--end--
        AFTER FIELD rxo09
           IF NOT cl_null(g_rxo[l_ac1].rxo09) THEN
              IF g_rxo[l_ac1].rxo09 < 0 THEN
                 CALL cl_err('','alm-061',0)
                 NEXT FIELD rxo09                
              END IF
              IF NOT cl_null(g_rxo[l_ac1].rxo07) THEN 
                 LET g_rxo[l_ac1].rxo10=g_rxo[l_ac1].rxo07 *g_rxo[l_ac1].rxo09
                 DISPLAY BY NAME g_rxo[l_ac1].rxo10
              END IF 
           END IF  
        AFTER FIELD rxo10
           IF NOT cl_null(g_rxo[l_ac1].rxo10) THEN
              IF g_rxo[l_ac1].rxo10 < 0 THEN
                 CALL cl_err('','alm-342',0)
                 NEXT FIELD rxo10                
              END IF
           END IF 
 
        BEFORE DELETE
           DISPLAY "BEFORE DELETE"
           IF g_rxo_t.rxo02 > 0 AND g_rxo_t.rxo02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rxo_file
               WHERE rxo00 = g_rxm.rxm00 AND rxo01 = g_rxm.rxm01
                 AND rxo02 = g_rxo_t.rxo02 AND rxoplant = g_rxm.rxmplant
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rxo_file",g_rxm.rxm01,g_rxo_t.rxo02,SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b1=g_rec_b1-1
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rxo[l_ac1].* = g_rxo_t.*
              CLOSE t6031_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF

           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rxo[l_ac1].rxo02,-263,1)
              LET g_rxo[l_ac1].* = g_rxo_t.*
           ELSE
              UPDATE rxo_file SET rxo02=g_rxo[l_ac1].rxo02,
                                  rxo03=g_rxo[l_ac1].rxo03,
                                  rxo04=g_rxo[l_ac1].rxo04,
                                  rxo05=g_rxo[l_ac1].rxo05,
                                  rxo06=g_rxo[l_ac1].rxo06,
                                  rxo07=g_rxo[l_ac1].rxo07,
                                  rxo08=g_rxo[l_ac1].rxo08,
                                  rxo09=g_rxo[l_ac1].rxo09,
                                  rxo10=g_rxo[l_ac1].rxo10,
                                  rxo11=g_rxo[l_ac1].rxo11,
                                  rxo12=g_rxo[l_ac1].rxo12,
                                  rxo13=g_rxo[l_ac1].rxo13
                                 ,rxo14=g_rxo[l_ac1].rxo14          #FUN-B30012 ADD
               WHERE rxo00 = g_rxm.rxm00 AND rxo01=g_rxm.rxm01
                 AND rxo02=g_rxo_t.rxo02 AND rxoplant = g_rxm.rxmplant
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rxo_file",g_rxm.rxm01,g_rxo_t.rxo02,SQLCA.sqlcode,"","",1) 
                 LET g_rxo[l_ac1].* = g_rxo_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac1 = ARR_CURR()
#          LET l_ac1_t = l_ac1           #FUN-D30033 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rxo[l_ac1].* = g_rxo_t.*
              #FUN-D30033---add---str---
              ELSE
                 CALL g_rxo.deleteElement(l_ac1)
                 IF g_rec_b1 != 0 THEN
                    LET g_flag_b = '2'
                    LET g_action_choice = "detail"
                    LET l_ac1 = l_ac1_t
                 END IF
              #FUN-D30033---add---end---
              END IF
              CLOSE t6031_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac1_t = l_ac1           #FUN-D30033 add
           CLOSE t6031_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO
           IF INFIELD(rxo02) AND l_ac1 > 1 THEN
              LET g_rxo[l_ac1].* = g_rxo[l_ac1-1].*
              LET g_rxo[l_ac1].rxo02 = g_rec_b1 + 1
              NEXT FIELD rxo02
           END IF
 
        ON ACTION CONTROLZ
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(rxo03)
#FUN-AA0059---------mod------------str-----------------              
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_ima"
#                 LET g_qryparam.default1 = g_rxo[l_ac1].rxo03
#                 CALL cl_create_qry() RETURNING g_rxo[l_ac1].rxo03
                  CALL q_sel_ima(FALSE, "q_ima","",g_rxo[l_ac1].rxo03,"","","","","",'' ) 
                   RETURNING  g_rxo[l_ac1].rxo03
#FUN-AA0059---------mod------------end-----------------
                 NEXT FIELD rxo03
              WHEN INFIELD(rxo04)
                #FUN-AB0016  --modify
                #CALL cl_init_qry_var()
                ##LET g_qryparam.form = "q_imd"
                #LET g_qryparam.form = "q_imd02_1"
                #LET g_qryparam.arg1=g_plant
                #LET g_qryparam.default1 = g_rxo[l_ac1].rxo04
                #CALL cl_create_qry() RETURNING g_rxo[l_ac1].rxo04
                 CALL q_imd_1(FALSE,TRUE,g_rxo[l_ac1].rxo04,"",g_plant,"Y","") RETURNING g_rxo[l_ac1].rxo04
                #FUN-AB0016  --end
                 NEXT FIELD rxo04
              WHEN INFIELD(rxo05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.default1 = g_rxo[l_ac1].rxo05
                 CALL cl_create_qry() RETURNING g_rxo[l_ac1].rxo05
                 NEXT FIELD rxo05
#              WHEN INFIELD(rxo11)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_imd"
#                 LET g_qryparam.default1 = g_rxo[l_ac1].rxo11
#                 CALL cl_create_qry() RETURNING g_rxo[l_ac1].rxo11
#                 NEXT FIELD rxo11
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
    
    UPDATE rxm_file SET rxmmodu = g_rxm.rxmmodu,rxmdate = g_rxm.rxmdate
       WHERE rxm01 = g_rxm.rxm01
     
    DISPLAY BY NAME g_rxm.rxmmodu,g_rxm.rxmdate
    
    CLOSE t6031_bcl
    COMMIT WORK
 
END FUNCTION
FUNCTION t603_rxo03() 
DEFINE l_ima1010     LIKE ima_file.ima1010
DEFINE l_imaacti     LIKE ima_file.imaacti

   LET g_errno = ' '

   SELECT imaacti,ima1010 INTO l_imaacti,l_ima1010 FROM ima_file 
      WHERE ima01 = g_rxo[l_ac1].rxo03
   CASE
      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aco-001'
      WHEN l_imaacti = 'N'     LET g_errno = 'art-433'
      WHEN l_ima1010 != '1'    LET g_errno = 'art-434'
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------' 
   END CASE
END FUNCTION
FUNCTION t603_compute()
DEFINE l_ima25       LIKE ima_file.ima25
DEFINE l_flag    LIKE type_file.num5                                                                                           
DEFINE l_fac     LIKE ima_file.ima31_fac

   LET g_errno = ' '
   IF cl_null(g_rxo[l_ac1].rxo03) OR cl_null(g_rxo[l_ac1].rxo05) THEN RETURN END IF
   SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = g_rxo[l_ac1].rxo03
   CALL s_umfchk(g_rxo[l_ac1].rxo03,g_rxo[l_ac1].rxo05,l_ima25)
      RETURNING l_flag,l_fac
   IF l_flag = 1 THEN 
      LET g_errno = 'art-032'  
   ELSE
      LET g_rxo[l_ac1].rxo06 = l_fac
   END IF
END FUNCTION
#No.TQC-A20011--begin
FUNCTION t603_check_rxn04()
DEFINE l_n          LIKE type_file.num5
   
   LET g_errno=''
   SELECT COUNT(*) INTO l_n FROM rxn_file 
    WHERE rxn00=g_rxm.rxm00 
      AND rxnplant=g_rxm.rxmplant
      AND rxn04=g_rxn[l_ac].rxn04
   IF l_n>0 THEN 
      LET g_errno='art-642'
   END IF 
END FUNCTION 

FUNCTION t603_check_rxn05()
DEFINE l_n          LIKE type_file.num5
   
   LET g_errno=''
   SELECT COUNT(*) INTO l_n FROM rxn_file 
    WHERE rxn00=g_rxm.rxm00 
      AND rxnplant=g_rxm.rxmplant 
      AND rxn05=g_rxn[l_ac].rxn05
   IF l_n>0 THEN 
      LET g_errno='art-642'
   END IF 
END FUNCTION  
#No.TQC-A20011--end
FUNCTION t603_rxn04()
DEFINE l_oga51      LIKE oga_file.oga51
DEFINE l_oga02      LIKE oga_file.oga02
DEFINE l_n          LIKE type_file.num5    #FUN-B30012 ADD 
DEFINE l_oga92      LIKE oga_file.oga92    #FUN-B30012 ADD

   LET g_errno = ' '
   SELECT oga16 INTO g_rxn[l_ac].rxn05 FROM oga_file
    WHERE oga01 = g_rxn[l_ac].rxn04
      AND ogaconf = 'Y'
   CASE 
      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'abx-002'
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------' 
   END CASE
   IF NOT cl_null(g_errno) THEN RETURN END IF
###-FUN-B30012- ADD - BEGIN ---------------------------------
###-是否存在換贈信息-###
   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM rxd_file WHERE rxd01 = g_rxn[l_ac].rxn04
   IF l_n = 0 THEN
      LET g_errno = 'art-131'
      RETURN
   END IF
###-是否已經換贈-###
   INITIALIZE l_oga92 TO NULL
   SELECT oga92 INTO l_oga92 FROM oga_file WHERE oga01 = g_rxn[l_ac].rxn04
     AND  ogaconf = 'Y'
   IF l_oga92 IS NOT NULL THEN
      LET g_errno = 'art-132'
      RETURN
   END IF
###-FUN-B30012- ADD -  END  ---------------------------------
###FUN-B30012 - MARK - BEGIN --------------------------------
#  SELECT SUM(rxx04) INTO g_rxn[l_ac].rxn07 FROM rxx_file
#   WHERE rxx00 = '02' AND rxx01 = g_rxn[l_ac].rxn04
###FUN-B30012 - MARK -  END  --------------------------------
#FUN-B30012 ADD  ----BEGIN----
   SELECT oma10 INTO g_rxn[l_ac].l_oma10 
     FROM oma_file,oga_file 
    WHERE oga01 = g_rxn[l_ac].rxn04
      AND oga10 = oma01
#FUN-B30012 ADD  -----END-----
#FUN-B30012 MARK ----BEGIN----
#  IF g_rxn[l_ac].rxn05 IS NOT NULL THEN
#     CALL cl_set_comp_entry("rxn05",FALSE)
#  END IF
#FUN-B30012 MARK -----END-----
END FUNCTION

FUNCTION t603_rxn04_3()
DEFINE l_oga02      LIKE oga_file.oga02

   LET g_errno = ' '
   IF  g_rxn[l_ac].rxn03 IS NULL OR  g_rxn[l_ac].rxn04 IS NULL THEN RETURN END IF
   SELECT oga02 INTO l_oga02 FROM oga_file
      WHERE oga01 = g_rxn[l_ac].rxn04
        AND ogaconf = 'Y'
   IF l_oga02 != g_rxn[l_ac].rxn03 THEN LET g_errno = 'art-914' END IF
END FUNCTION
FUNCTION t603_kehu(p_flag)
DEFINE p_flag        LIKE type_file.chr1
DEFINE l_rxn04       LIKE rxn_file.rxn04
DEFINE l_rxn05       LIKE rxn_file.rxn05
DEFINE l_oga87       LIKE oga_file.oga87
DEFINE l_old_oga87   LIKE oga_file.oga87

   LET g_errno = ' '

   IF p_flag = '1' THEN
      SELECT oga87 INTO l_oga87 FROM oga_file   
         WHERE oga01 = g_rxn[l_ac].rxn04
   END IF
   IF p_flag = '2' THEN
      SELECT oea87 INTO l_oga87 FROM oea_file   
         WHERE oea01 = g_rxn[l_ac].rxn05
   END IF

   LET g_sql = "SELECT rxn04,rxn05 FROM rxn_file ",
               "  WHERE rxn00 = '",g_rxm.rxm00,"' ",
               "    AND rxn01 = '",g_rxm.rxm01,"' ",
               "    AND rxnplant = '",g_rxm.rxmplant,"'"
   PREPARE pre_sel_rxn04 FROM g_sql
   DECLARE cur_rxn04 CURSOR FOR pre_sel_rxn04
   FOREACH cur_rxn04 INTO l_rxn04,l_rxn05
      IF l_rxn04 IS NOT NULL THEN 
         SELECT oga87 INTO l_old_oga87 FROM oga_file   
            WHERE oga01 = l_rxn04
      ELSE
         IF l_rxn05 IS NOT NULL THEN 
            SELECT oea87 INTO l_old_oga87 FROM oea_file   
               WHERE oea01 = l_rxn05
         END IF
      END IF
      IF NOT cl_null(l_oga87) AND NOT cl_null(l_old_oga87) THEN
         IF l_oga87 != l_old_oga87 THEN
            LET g_errno = 'art-913'
            EXIT FOREACH
         END IF
      END IF
   END FOREACH
END FUNCTION

FUNCTION t603_check()
DEFINE l_n      LIKE type_file.num5

   LET g_errno = ' '

   IF cl_null(g_rxn[l_ac].rxn04) OR cl_null(g_rxn[l_ac].rxn05) THEN
      RETURN
   END IF
   
   SELECT COUNT(*) INTO l_n FROM ogb_file 
      WHERE ogb01 = g_rxn[l_ac].rxn04
        AND ogb31 = g_rxn[l_ac].rxn05
   IF l_n = 0 THEN LET g_errno = 'axm-324' END IF

END FUNCTION
FUNCTION t603_rxn05()
DEFINE l_oea62      LIKE oea_file.oea62

   LET g_errno = ' '
   SELECT oea62 INTO l_oea62 FROM oea_file
      WHERE oea01 = g_rxn[l_ac].rxn05
        AND oeaconf = 'Y'
   CASE 
      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'asf-500'
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------' 
   END CASE
   IF g_rxn[l_ac].rxn07 IS NULL THEN
      SELECT SUM(rxx04) INTO g_rxn[l_ac].rxn07 FROM rxx_file
          WHERE rxx00 = '01' AND rxx01 = g_rxn[l_ac].rxn05
   END IF  
END FUNCTION
FUNCTION t603_rxo04(p_cmd)
DEFINE l_imd11     LIKE imd_file.imd11
DEFINE l_imdacti   LIKE imd_file.imdacti
DEFINE l_n         LIKE type_file.num5
DEFINE p_cmd       LIKE type_file.chr1 

   LET g_errno = ' '
   SELECT imd02,imd11,imdacti INTO g_rxo[l_ac1].rxo04_desc,l_imd11,l_imdacti FROM imd_file 
      WHERE imd01 = g_rxo[l_ac1].rxo04 AND imd20=g_plant
   CASE 
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'mfg0094'
      WHEN  l_imd11 = 'N' OR l_imdacti = 'N' LET g_errno = 'axm-993 '
      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------' 
   END CASE
   
   IF cl_null(g_errno) THEN 
      SELECT COUNT(*) INTO l_n FROM jce_file WHERE jce02=g_rxo[l_ac1].rxo04 
      IF l_n>0 THEN 
         LET g_errno='axm-065'
      END IF 
   END IF        
   IF cl_null(g_errno) OR p_cmd='d' THEN 
      DISPLAY BY NAME g_rxo[l_ac1].rxo04_desc
    END IF 
END FUNCTION

FUNCTION t603_rxo05(p_cmd)
DEFINE p_cmd       LIKE type_file.chr1   

   LET g_errno = ' '
   SELECT gfe02 INTO g_rxo[l_ac1].rxo05_desc FROM gfe_file 
      WHERE gfe01 = g_rxo[l_ac1].rxo05 AND gfeacti = 'Y' 
   CASE 
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'mfg3377'
      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------' 
   END CASE
   IF cl_null(g_errno) OR p_cmd='d' THEN 
      DISPLAY BY NAME g_rxo[l_ac1].rxo05_desc
   END IF    
END FUNCTION 
 
FUNCTION t603_b_fill(p_wc2)
DEFINE p_wc2   STRING
 
#  LET g_sql = "SELECT rxn02,rxn03,rxn04,rxn05,rxn06,rxn07,rxn08 ",    #FUN-B30012 ADD
   LET g_sql = "SELECT rxn02,rxn03,rxn04,rxn05,rxn06,'',rxn07,rxn08 ", #FUN-B30012 ADD
               "  FROM rxn_file",
               " WHERE rxn00 = '",g_rxm.rxm00,"' AND rxn01 ='",g_rxm.rxm01,"' ",
               "   AND rxnplant = '",g_rxm.rxmplant,"'"
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY rxn02 "
 
   DISPLAY g_sql
 
   PREPARE t603_pb FROM g_sql
   DECLARE rxn_cs CURSOR FOR t603_pb
 
   CALL g_rxn.clear()
   LET g_cnt = 1
 
   FOREACH rxn_cs INTO g_rxn[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       ###FUN-B30012 ADD  ----BEGIN----
       IF NOT cl_null(g_rxn[g_cnt].rxn04) THEN
          SELECT oma10 INTO g_rxn[g_cnt].l_oma10 
            FROM oma_file,oga_file 
           WHERE oga01 = g_rxn[g_cnt].rxn04
             AND oma01 = oga10
       END IF
       ###FUN-B30012 ADD  -----END-----
     
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_rxn.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   LET g_cnt = 0
 
END FUNCTION
  
FUNCTION t603_b1_fill(p_wc2)
DEFINE p_wc2   STRING
 
#  LET g_sql = "SELECT rxo02,rxo03,rxo04,'',rxo05,'',rxo06,",  #FUN-B30012 MARK
   LET g_sql = "SELECT rxo02,rxo14,rxo03,rxo05,'',rxo04,'',rxo06,",  #FUN-B30012 ADD
#              "rxo07,rxo08,rxo09,rxo10,rxo11,rxo12,rxo13 ",   #FUN-B30012 MARK
               "rxo07,rxo08,rxo09,rxo10,rxo12,rxo11,rxo13 ",   #FUN-B30012 ADD
               "  FROM rxo_file",
               " WHERE rxo00 = '",g_rxm.rxm00,"' AND rxo01 ='",g_rxm.rxm01,"' ",
               "   AND rxoplant = '",g_rxm.rxmplant,"'"
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY rxo02 "
 
   DISPLAY g_sql
 
   PREPARE t603_pb1 FROM g_sql
   DECLARE rxo_cs CURSOR FOR t603_pb1
 
   CALL g_rxo.clear()
   LET g_cnt = 1
 
   FOREACH rxo_cs INTO g_rxo[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT imd02 INTO g_rxo[g_cnt].rxo04_desc FROM imd_file
           WHERE imd01 = g_rxo[g_cnt].rxo04
       SELECT gfe02 INTO g_rxo[g_cnt].rxo05_desc FROM gfe_file
           WHERE gfe01 = g_rxo[g_cnt].rxo05
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_rxo.deleteElement(g_cnt)
 
   LET g_rec_b1=g_cnt-1
   LET g_cnt = 0
 
END FUNCTION

FUNCTION t603_copy()
   DEFINE l_newno     LIKE rxm_file.rxm01,
          l_oldno     LIKE rxm_file.rxm01,
          li_result   LIKE type_file.num5,
          l_n         LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_rxm.rxm01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL t603_set_entry('a')
 
   CALL cl_set_head_visible("","YES")
   INPUT l_newno FROM rxm01
       BEFORE INPUT
         CALL cl_set_docno_format("rxm01")
         
       AFTER FIELD rxm01
          IF l_newno IS NULL THEN
             NEXT FIELD rxm01
          ELSE 
#     	     CALL s_check_no("art",l_newno,"","9","rxm_file","rxm01","")  #FUN-A70130 mark                                                         
#     	     CALL s_check_no("art",l_newno,"","D1","rxm_file","rxm01","")  #FUN-A70130 mod #FUN-B30012 MARK
      	     CALL s_check_no("art",l_newno,"","I7","rxm_file","rxm01","")  #FUN-B30012 ADD
                RETURNING li_result,l_newno                                                                                        
             IF (NOT li_result) THEN                                                                                               
                NEXT FIELD rxm01                                                                                                   
             END IF                                                                                                                
             BEGIN WORK                                                                                                            
#            CALL s_auto_assign_no("art",l_newno,g_today,"","rxm_file","rxm01",g_plant,"","")   #FUN-A70130 mark                                        
#            CALL s_auto_assign_no("art",l_newno,g_today,"D1","rxm_file","rxm01",g_plant,"","")   #FUN-A70130 mod #FUN-B30012 MARK
             CALL s_auto_assign_no("art",l_newno,g_today,"I7","rxm_file","rxm01",g_plant,"","")   #FUN-B30012 ADD
                RETURNING li_result,l_newno  
             IF (NOT li_result) THEN                                                                                               
                ROLLBACK WORK                                                                                                      
                NEXT FIELD rxm01                                                                                                   
             ELSE                                                                                                                  
                COMMIT WORK                                                                                                        
             END IF
          END IF
      ON ACTION controlp
         CASE 
            WHEN INFIELD(rxm01)                                                                                                      
              LET g_t1=s_get_doc_no(g_rxm.rxm01)                                                                                    
#             CALL q_smy(FALSE,FALSE,g_t1,'ART','9') RETURNING g_t1    #FUN-A70130--mark--                                                              
#             CALL q_oay(FALSE,FALSE,g_t1,'D1','ART') RETURNING g_t1   #FUN-A70130--mod--  #FUN-B30012 MARK
              CALL q_oay(FALSE,FALSE,g_t1,'I7','ART') RETURNING g_t1   #FUN-B30012 ADD
              LET l_newno = g_t1                                                                                                
              DISPLAY l_newno TO rxm01                                                                                           
              NEXT FIELD rxm01
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
      DISPLAY BY NAME g_rxm.rxm01
      ROLLBACK WORK
      RETURN
   END IF
   BEGIN WORK
 
   DROP TABLE y
 
   SELECT * FROM rxm_file
       WHERE rxm00 = g_rxm.rxm00 AND rxm01=g_rxm.rxm01
         AND rxmplant = g_rxm.rxmplant
       INTO TEMP y
 
   UPDATE y
       SET rxm01=l_newno,
           rxmplant=g_plant, 
           rxmlegal=g_legal,
           rxmconf = 'N',
           rxmcond = NULL,
           rxmconu = NULL,
           rxmuser=g_user,
           rxmgrup=g_grup,
           rxmmodu=NULL,
           rxmdate=g_today,
           rxmacti='Y',
           rxmcrat=g_today ,
           rxmoriu = g_user,
           rxmorig = g_grup
           
   INSERT INTO rxm_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","rxm_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM rxn_file
       WHERE rxn00 = g_rxm.rxm00 AND rxn01=g_rxm.rxm01 
         AND rxnplant = g_rxm.rxmplant
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF
 
   UPDATE x SET rxn01=l_newno,
                rxnplant = g_plant,
                rxnlegal = g_legal 
 
   INSERT INTO rxn_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
   #   ROLLBACK WORK    # FUN-B80085---回滾放在報錯後---
      CALL cl_err3("ins","rxn_file","","",SQLCA.sqlcode,"","",1) 
      ROLLBACK WORK     #FUN-B80085--add--
      RETURN
   ELSE
      COMMIT WORK
   END IF 
    
   DROP TABLE z
 
   SELECT * FROM rxo_file
       WHERE rxo00 = g_rxm.rxm00 AND rxo01=g_rxm.rxm01 
         AND rxoplant = g_rxm.rxmplant
       INTO TEMP z
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","z","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF
 
   UPDATE z SET rxo01=l_newno,
                rxoplant = g_plant,
                rxolegal = g_legal 
 
   INSERT INTO rxo_file
       SELECT * FROM z   
   IF SQLCA.sqlcode THEN
   #   ROLLBACK WORK         # FUN-B80085---回滾放在報錯後---
      CALL cl_err3("ins","rxo_file","","",SQLCA.sqlcode,"","",1)  
      ROLLBACK WORK     #FUN-B80085--add--
      RETURN
   ELSE
      COMMIT WORK
   END IF    
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_rxm.rxm01
   SELECT rxm_file.* INTO g_rxm.* FROM rxm_file 
      WHERE rxm00=g_rxm.rxm00 AND rxm01 = l_newno
        AND rxmplant = g_rxm.rxmplant
   CALL t603_u()
   CALL t603_b()
   #FUN-C80046---begin
   #SELECT rxm_file.* INTO g_rxm.* FROM rxm_file 
   #    WHERE rxm00=g_rxm.rxm00 AND rxm01 = l_oldno 
   #      AND rxmplant = g_rxm.rxmplant
   #
   #CALL t603_show()
   #FUN-C80046---end
END FUNCTION
 
FUNCTION t603_out()
DEFINE l_cmd   LIKE type_file.chr1000                                                                                           
     
    IF g_wc IS NULL AND g_rxm.rxm01 IS NOT NULL THEN
       LET g_wc = "rxm01='",g_rxm.rxm01,"'"
    END IF        
     
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0)
       RETURN
    END IF
                                                                                                                  
    IF g_wc2 IS NULL THEN                                                                                                           
       LET g_wc2 = ' 1=1'                                                                                                     
    END IF                                                                                                                   
                                                                                                                                    
    LET l_cmd='p_query "artt603" "',g_wc CLIPPED,'" "',g_wc2 CLIPPED,'"'                                                                               
    CALL cl_cmdrun(l_cmd)
END FUNCTION
 
FUNCTION t603_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("rxm01,rxm02,rxm03",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t603_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("rxm01,rxm02,rxm03",FALSE)
    END IF
 
END FUNCTION
FUNCTION t603_pay() 
DEFINE l_rxo10    LIKE rxo_file.rxo10
  
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rxm.rxm01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
  
   SELECT * INTO g_rxm.* FROM rxm_file 
      WHERE rxm00 = g_rxm.rxm00 AND rxm01=g_rxm.rxm01
        AND rxmplant = g_rxm.rxmplant
   IF g_rxm.rxmacti ='N' THEN
      CALL cl_err(g_rxm.rxm01,'mfg1000',0)
      RETURN
   END IF
   
   IF g_rxm.rxmconf = 'Y' THEN
      CALL cl_err('','art-024',0)
      RETURN
   END IF
 
   IF g_rxm.rxmconf = 'X' THEN
      CALL cl_err('','art-025',0)
      RETURN
   END IF

   SELECT SUM(rxo10) INTO l_rxo10 FROM rxo_file
       WHERE rxo00 = g_rxm.rxm00 AND rxo01=g_rxm.rxm01
         AND rxoplant = g_rxm.rxmplant
   IF l_rxo10 IS NULL THEN LET l_rxo10 = 0 END IF
   CALL s_pay('09',g_rxm.rxm01,g_rxm.rxmplant,l_rxo10,g_rxm.rxmconf)      
END FUNCTION
#NO.FUN-960130------end------

#No.FUN-BB0086---add---begin---
FUNCTION t603_rxo07_check()
   IF NOT cl_null(g_rxo[l_ac].rxo07) AND NOT cl_null(g_rxo[l_ac].rxo05) THEN
      IF cl_null(g_rxo_t.rxo07) OR cl_null(g_rxo05_t) OR g_rxo_t.rxo07 != g_rxo[l_ac].rxo07 OR g_rxo05_t != g_rxo[l_ac].rxo05 THEN
         LET g_rxo[l_ac].rxo07=s_digqty(g_rxo[l_ac].rxo07,g_rxo[l_ac].rxo05)
         DISPLAY BY NAME g_rxo[l_ac].rxo07
      END IF
   END IF
   
   IF NOT cl_null(g_rxo[l_ac1].rxo07) THEN
      IF g_rxo[l_ac1].rxo07 <= 0 THEN
         CALL cl_err('','aem-042',0)
         RETURN FALSE            
      END IF
      IF NOT cl_null(g_rxo[l_ac1].rxo09) THEN 
         LET g_rxo[l_ac1].rxo10=g_rxo[l_ac1].rxo07 *g_rxo[l_ac1].rxo09
         DISPLAY BY NAME g_rxo[l_ac1].rxo10
      END IF 
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t603_rxo08_check()
   IF NOT cl_null(g_rxo[l_ac].rxo08) AND NOT cl_null(g_rxo[l_ac].rxo05) THEN
      IF cl_null(g_rxo_t.rxo08) OR cl_null(g_rxo05_t) OR g_rxo_t.rxo08 != g_rxo[l_ac].rxo08 OR g_rxo05_t != g_rxo[l_ac].rxo05 THEN
         LET g_rxo[l_ac].rxo08=s_digqty(g_rxo[l_ac].rxo08,g_rxo[l_ac].rxo05)
         DISPLAY BY NAME g_rxo[l_ac].rxo08
      END IF
   END IF
   
   IF NOT cl_null(g_rxo[l_ac1].rxo08) THEN
      IF g_rxo[l_ac1].rxo08 <= 0 THEN
         CALL cl_err('','aem-042',0)
         RETURN FALSE      
      END IF
   END IF
   RETURN TRUE
END FUNCTION
#No.FUN-BB0086---add---end---
