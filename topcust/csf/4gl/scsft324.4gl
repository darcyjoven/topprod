# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Program code...: cect324.4gl
# Program name...: Run Card完工入庫維護作業
# Modify.........: Modify By Carol:領料單如有輸入單號別則自動產生一張領料單
#                                  無須領料單先建立單頭再由K.領料產生insert單身
# Modify.........: Modify By Carol:1999/04/14 完工入庫數量check最小套數數量
# Modify.........: 99/08/18 By Carol:工單完工時未使用消秏性料件則不可產生領料單
# Modify.........: No:7695 03/07/31 Carol 程式第733行


DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"


DEFINE g_ima918  LIKE ima_file.ima918  #No.FUN-810036
DEFINE g_ima921  LIKE ima_file.ima921  #No.FUN-810036    #NO.FUN-9B0016
DEFINE l_i       LIKE type_file.num5   #No.FUN-860045
DEFINE l_r       LIKE type_file.chr1   #No.FUN-860045
DEFINE l_fac     LIKE img_file.img34   #No.FUN-860045
#
DEFINE g_rec_b1           LIKE type_file.num5,   #單身二筆數 ##FUN-B30170
       l_ac1              LIKE type_file.num5    #目前處理的ARRAY CNT  #FUN-B30170
#FUN-B30170 add -end---------------------------
#模組變數(Module Variables)
DEFINE
    g_tc_sna   RECORD LIKE tc_sna_file.*,
    g_sfb   RECORD LIKE sfb_file.*,
    g_tc_sna_t RECORD LIKE tc_sna_file.*,
    g_tc_sna_o RECORD LIKE tc_sna_file.*,
    g_yy,g_mm       LIKE type_file.num5,        #No.FUN-680121 SMALLINT,              #
    b_tc_snb           RECORD LIKE tc_snb_file.*,
    g_ima           RECORD LIKE ima_file.*,     #-No.MOD-530603
    g_tc_snb16         LIKE tc_snb_file.tc_snb16,        #-No.MOD-530603
    g_ima86         LIKE ima_file.ima86,
    g_img09         LIKE img_file.img09,
    g_img10         LIKE img_file.img10,
    g_ima571        LIKE ima_file.ima571,
    g_min_set       LIKE sfb_file.sfb08,
    g_over_qty      LIKE sfb_file.sfb08,
    
    
    

    g_tc_snb    DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables)
             tc_snb03     LIKE tc_snb_file.tc_snb03,    #项次
             tc_snb17     LIKE tc_snb_file.tc_snb17,    #FQC单号
             tc_snb20     LIKE tc_snb_file.tc_snb20,    #LOT 
             tc_snb11     LIKE tc_snb_file.tc_snb11,    #工单单号
             #FUN-BC0104---add---str
             tc_snb46     LIKE tc_snb_file.tc_snb46,    #QC判定结果
             qcl02     LIKE qcl_file.qcl02,
             tc_snb47     LIKE tc_snb_file.tc_snb47,    #QC判定项次
             #FUN-BC0104---add---end
             tc_snb04     LIKE tc_snb_file.tc_snb04,    #料号
             ima02     LIKE ima_file.ima02,    #品名
             ima021    LIKE ima_file.ima021,   #规格
             tc_snb08     LIKE tc_snb_file.tc_snb08,    #库存单位 
             tc_snb05     LIKE tc_snb_file.tc_snb05,    #仓库
             tc_snb06     LIKE tc_snb_file.tc_snb06,    #库位
             tc_snb07     LIKE tc_snb_file.tc_snb07,    #批号
             tc_snb09     LIKE tc_snb_file.tc_snb09,    #入库量
             tc_snb33     LIKE tc_snb_file.tc_snb33,    #单位二
             tc_snb34     LIKE tc_snb_file.tc_snb34,    #单位二转换率
             tc_snb35     LIKE tc_snb_file.tc_snb35,    #单位二数量
             tc_snb30     LIKE tc_snb_file.tc_snb30,    #单位一
             tc_snb31     LIKE tc_snb_file.tc_snb31,    #单位一换算率
             tc_snb32     LIKE tc_snb_file.tc_snb32,    #单位一数量
             tc_snb41     LIKE tc_snb_file.tc_snb41,    #项目编号
             tc_snb42     LIKE tc_snb_file.tc_snb42,    #WBS编码
             tc_snb43     LIKE tc_snb_file.tc_snb43,    #活动编码
             tc_snb44     LIKE tc_snb_file.tc_snb44,    #理由码
             tc_snb12     LIKE tc_snb_file.tc_snb12,    #备注
             tc_snb930    LIKE tc_snb_file.tc_snb930,   #成本中心
             gem02c    LIKE gem_file.gem02,    #作业说明
             tc_snbud07   LIKE tc_snb_file.tc_snbud07 #hlf-07751
             ,l_min    LIKE tc_snb_file.tc_snb09   #add by guanyao160901
             END RECORD,
    g_tc_snb_t  RECORD
             tc_snb03     LIKE tc_snb_file.tc_snb03,
             tc_snb17     LIKE tc_snb_file.tc_snb17,    #FUN-550012
             tc_snb20     LIKE tc_snb_file.tc_snb20,
             tc_snb11     LIKE tc_snb_file.tc_snb11,
             #FUN-BC0104---add---str
             tc_snb46     LIKE tc_snb_file.tc_snb46,
             qcl02     LIKE qcl_file.qcl02,
             tc_snb47     LIKE tc_snb_file.tc_snb47,
             #FUN-BC0104---add---end
             tc_snb04     LIKE tc_snb_file.tc_snb04,
             ima02     LIKE ima_file.ima02,
             ima021    LIKE ima_file.ima021,
             tc_snb08     LIKE tc_snb_file.tc_snb08,
             tc_snb05     LIKE tc_snb_file.tc_snb05,
             tc_snb06     LIKE tc_snb_file.tc_snb06,
             tc_snb07     LIKE tc_snb_file.tc_snb07,
             tc_snb09     LIKE tc_snb_file.tc_snb09,
             tc_snb33     LIKE tc_snb_file.tc_snb33,
             tc_snb34     LIKE tc_snb_file.tc_snb34,
             tc_snb35     LIKE tc_snb_file.tc_snb35,
             tc_snb30     LIKE tc_snb_file.tc_snb30,
             tc_snb31     LIKE tc_snb_file.tc_snb31,
             tc_snb32     LIKE tc_snb_file.tc_snb32,
             tc_snb41     LIKE tc_snb_file.tc_snb41,
             tc_snb42     LIKE tc_snb_file.tc_snb42,
             tc_snb43     LIKE tc_snb_file.tc_snb43,
             tc_snb44     LIKE tc_snb_file.tc_snb44,
             tc_snb12     LIKE tc_snb_file.tc_snb12,
             tc_snb930    LIKE tc_snb_file.tc_snb930, #FUN-670103
             gem02c    LIKE gem_file.gem02,  #FUN-670103
             tc_snbud07   LIKE tc_snb_file.tc_snbud07
             ,l_min    LIKE tc_snb_file.tc_snb09   #add by guanyao160901
             END RECORD,
    g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_tc_sna01         LIKE tc_sna_file.tc_sna01,
    g_cmd           LIKE type_file.chr1000, #No.FUN-680121 VARCHAR(200)
    g_t1            LIKE oay_file.oayslip,               #No.FUN-550067  #No.FUN-680121 VARCHAR(5)
    g_buf           LIKE type_file.chr1000, #No.FUN-680121 VARCHAR(20)
#   tot1,tot2,tot3  LIKE ima_file.ima26,    #No.FUN-680121 DECIMAL(12,3),
    tot1,tot2,tot3  LIKE type_file.num15_3, ###GP5.2  #NO.FUN-A20044
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-680121 SMALLINT
    g_imd10         LIKE imd_file.imd10,
    un_post_qty     LIKE img_file.img10,  #No.FUN-680121 DEC(15,5),
    tmp_qty         LIKE img_file.img10,  #No.FUN-680121 DEC(15,3),
    tmp_woqty      LIKE img_file.img10,  #No.MOD-880232 add
    g_sgm311        LIKE sgm_file.sgm311,
    g_sgm315        LIKE sgm_file.sgm315,
    g_sgm_out       LIKE sgm_file.sgm311,
    l_program       LIKE ima_file.ima34,  #No.FUN-680121 VARCHAR(10),
    l_za05          LIKE za_file.za05,
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-680121 SMALLINT
DEFINE   g_argv    LIKE type_file.chr1     #No.FUN-680121 VARCHAR(1)        #1.完工入庫 2.入庫退回
DEFINE   g_argv1   LIKE tc_sna_file.tc_sna01     #No.FUN-630010
DEFINE   g_argv2   STRING                  #No.FUN-630010
DEFINE   u_sign	   LIKE type_file.num5    #No.FUN-680121 SMALLINT
 
DEFINE g_forupd_sql         STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-680121 SMALLINT
DEFINE g_chr           LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10   #No.FUN-680121 INTEGER
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680121 SMALLINT
DEFINE g_msg           LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(72)
DEFINE g_row_count     LIKE type_file.num10   #No.FUN-680121 INTEGER
DEFINE g_curs_index    LIKE type_file.num10   #No.FUN-680121 INTEGER
DEFINE g_jump          LIKE type_file.num10   #No.FUN-680121 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5    #No.FUN-680121 SMALLINT
DEFINE g_post          LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
DEFINE g_void          LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
DEFINE g_imm01         LIKE imm_file.imm01      #No.FUN-610090
DEFINE g_unit_arr      DYNAMIC ARRAY OF RECORD  #No.FUN-610090
                          unit   LIKE ima_file.ima25,
                          fac    LIKE img_file.img21,
                          qty    LIKE img_file.img10
                       END RECORD
 
DEFINE
    g_yes               LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(01),
    g_imgg10_2          LIKE img_file.img10,
    g_imgg10_1          LIKE img_file.img10,
    g_change            LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(01),
    g_ima25             LIKE ima_file.ima25,
    g_ima906            LIKE ima_file.ima906,
    g_ima907            LIKE ima_file.ima907,
    g_imgg00            LIKE imgg_file.imgg00,
    g_imgg10            LIKE imgg_file.imgg10,
    g_sw                LIKE type_file.num5,    #No.FUN-680121 SMALLINT,
    g_factor            LIKE inb_file.inb08_fac,
    g_tot               LIKE img_file.img10,
    g_qty               LIKE img_file.img10
DEFINE g_tc_snb30_t        LIKE tc_snb_file.tc_snb30     #No.FUN-BB0086
DEFINE g_tc_snb35_t        LIKE tc_snb_file.tc_snb35     #No.FUN-BB0086
DEFINE g_tc_snb33_t        LIKE tc_snb_file.tc_snb33     #No.FUN-BB0086
DEFINE g_tc_snb09_t        LIKE tc_snb_file.tc_snb09       #FUN-BC0104
DEFINE g_multi_tc_snb20    STRING                  #add by guanyao160805
#DEFINE l_img_table      STRING                 #FUN-C70087 #FUN-CC0095
#DEFINE l_imgg_table     STRING                 #FUN-C70087 #FUN-CC0095

FUNCTION scsft324(p_argv,p_argv1,p_argv2)
 
DEFINE  p_argv   LIKE type_file.chr1,   #No.FUN-680121 VARCHAR(1)  #No.FUN-6A0090
        p_argv1  LIKE tc_sna_file.tc_sna01,   #No.FUN-630010
        p_argv2  STRING                 #No.FUN-630010
 
   WHENEVER ERROR CONTINUE
    #CALL s_padd_img_create() RETURNING l_img_table   #FUN-C70087  #FUN-CC0095
    #CALL s_padd_imgg_create() RETURNING l_imgg_table #FUN-C70087  #FUN-CC0095
    CALL t324_mu_ui()
 
    LET g_forupd_sql = "SELECT * FROM tc_sna_file WHERE tc_sna01 = ? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t324_cl CURSOR FROM g_forupd_sql
 
    LET g_argv = p_argv
    IF g_argv = '2' THEN
       LET u_sign=-1
    ELSE
       LET u_sign=1
    END IF
    LET g_argv1 = p_argv1       #No.FUN-630010
    LET g_argv2 = p_argv2       #No.FUN-630010
 
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
 
    IF NOT cl_null(g_argv1) THEN
       CASE g_argv2
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL t324_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
             IF cl_chk_act_auth() THEN
                CALL t324_a()
             END IF
          OTHERWISE
             CALL t324_q()
       END CASE
    END IF
 
    CALL t324_menu()
    #CALL s_padd_img_drop(l_img_table)   #FUN-C70087  #FUN-CC0095
    #CALL s_padd_imgg_drop(l_imgg_table) #FUN-C70087  #FUN-CC0095
END FUNCTION
 
FUNCTION t324_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    CALL g_tc_snb.clear()
 
    IF cl_null(g_argv1) THEN               #No.FUN-630010
       IF g_argv='1' THEN
          CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_tc_sna.* TO NULL    #No.FUN-750051
          CONSTRUCT BY NAME g_wc ON
             #tc_sna01,tc_sna02,tc_sna04,tc_sna08,tc_sna09,tc_sna06,tc_sna05,tc_sna07,tc_snaconf, #FUN-660137 #FUN-810045
             tc_sna01, tc_sna02,tc_sna04,tc_sna08,tc_sna09,tc_sna06,tc_sna07,tc_snaconf, #FUN-660137        #FUN-810045
             tc_snapost,tc_snauser,tc_snagrup,tc_snamodu,tc_snadate
 
                  BEFORE CONSTRUCT
                     CALL cl_qbe_init()
 
           ON ACTION controlp
             CASE 

             WHEN INFIELD(tc_sna01) #查詢單据
            #MOD-4A0252 入庫單號開窗
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = "c"
                       LET g_qryparam.form  = "q_tc_sna" 
                      
                       LET g_qryparam.where = " tc_sna01[1,",g_doc_len,"] "    #FUN-B40029
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO tc_sna01
                       NEXT FIELD tc_sna01
 
                  WHEN INFIELD(tc_sna04)
                       CALL cl_init_qry_var()
                       LET g_qryparam.state    = "c"
                       LET g_qryparam.form ="q_eca1"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO tc_sna04
                       NEXT FIELD tc_sna04

               {
                WHEN INFIELD(tc_sna06) #專案代號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_pja2"  #FUN-810045
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO tc_sna06
                   NEXT FIELD tc_sna06
                   
                 WHEN INFIELD(tc_sna09)   #領料單號 #MOD-4A0252
                   CALL cl_init_qry_var()
                   LET g_qryparam.state= "c"
                   LET g_qryparam.form ="q_sfp1"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO tc_sna09
                   NEXT FIELD tc_sna09
                   }
               END CASE
 
             ON IDLE g_idle_seconds
                CALL cl_on_idle()
                CONTINUE CONSTRUCT
 
                   ON ACTION qbe_select
                      CALL cl_qbe_list() RETURNING lc_qbe_sn
                      CALL cl_qbe_display_condition(lc_qbe_sn)
 
          END CONSTRUCT
 
       ELSE
          CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
          CONSTRUCT BY NAME g_wc ON
             tc_sna01,tc_sna02,tc_sna04,tc_sna06,tc_sna07,tc_sna08,tc_sna09,tc_snaconf, #FUN-660137         #FUN-810045
             tc_snapost,tc_snauser,tc_snagrup,tc_snamodu,tc_snadate
 
                  BEFORE CONSTRUCT
                     CALL cl_qbe_init()
           ON ACTION controlp
             CASE WHEN INFIELD(tc_sna01) #查詢單据
                       LET g_t1=s_get_doc_no(g_tc_sna.tc_sna01)         #No.FUN-550067
                       LET g_sql = " (smy73 <> 'Y' OR smy73 is null)"  #TQC-AC0294 add
                       CALL smy_qry_set_par_where(g_sql)               #TQC-AC0294 add 
                       IF g_argv='0' THEN
                          CALL q_smy( FALSE, TRUE,g_t1,'ASF','9') RETURNING g_t1  #TQC-670008
                       ELSE
                          CALL q_smy( FALSE, TRUE,g_t1,'ASF','A') RETURNING g_t1  #TQC-670008
                       END IF
                       LET g_qryparam.multiret=g_t1
                       DISPLAY g_qryparam.multiret TO tc_sna01
                       NEXT FIELD tc_sna01
 
                  WHEN INFIELD(tc_sna04)
                       CALL cl_init_qry_var()
                       LET g_qryparam.state    = "c"
                       LET g_qryparam.form ="q_eca1"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO tc_sna04
                       NEXT FIELD tc_sna04
               END CASE
 
             ON IDLE g_idle_seconds
                CALL cl_on_idle()
                CONTINUE CONSTRUCT
 
                   ON ACTION qbe_select
                      CALL cl_qbe_list() RETURNING lc_qbe_sn
                      CALL cl_qbe_display_condition(lc_qbe_sn)
 
          END CONSTRUCT
 
       END IF
 
       IF INT_FLAG THEN RETURN END IF
    ELSE
       LET g_wc = " tc_sna01 = '",g_argv1 CLIPPED,"'"
    END IF
 
    #資料權限的檢查
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('tc_snauser', 'tc_snagrup')
 
    IF cl_null(g_argv1) THEN               #No.FUN-630010
       CONSTRUCT g_wc2 ON tc_snb03,tc_snb17,tc_snb20,tc_snb11, 
                          tc_snb46,qcl02,tc_snb47,   #FUN-BC0104 add
                          tc_snb04,tc_snb08,tc_snb05,   #FUN-550012
                          tc_snb06,tc_snb07,tc_snb09,
                          tc_snb33,tc_snb34,tc_snb35,tc_snb30,
                          tc_snb31,tc_snb32, tc_snb41,tc_snb42,tc_snb43,tc_snb44,    
                          tc_snb12,tc_snb930,tc_snbud07 #FUN-670103
                     FROM s_tc_snb[1].tc_snb03, s_tc_snb[1].tc_snb17, s_tc_snb[1].tc_snb20, s_tc_snb[1].tc_snb11, 
                          s_tc_snb[1].tc_snb46, s_tc_snb[1].qcl02, s_tc_snb[1].tc_snb47, 
                          s_tc_snb[1].tc_snb04, s_tc_snb[1].tc_snb08, s_tc_snb[1].tc_snb05,
                          s_tc_snb[1].tc_snb06, s_tc_snb[1].tc_snb07, s_tc_snb[1].tc_snb09,
                          s_tc_snb[1].tc_snb33, s_tc_snb[1].tc_snb34,s_tc_snb[1].tc_snb35, s_tc_snb[1].tc_snb30,
                          s_tc_snb[1].tc_snb31,s_tc_snb[1].tc_snb32,s_tc_snb[1].tc_snb41,s_tc_snb[1].tc_snb42,s_tc_snb[1].tc_snb43,s_tc_snb[1].tc_snb44,  #FUN-810045 add
                          s_tc_snb[1].tc_snb12,s_tc_snb[1].tc_snb930,s_tc_snb[1].tc_snbud07 #FUN-670103
 
                   BEFORE CONSTRUCT
                      CALL cl_qbe_display_condition(lc_qbe_sn)
 
           ON ACTION controlp
              CASE WHEN INFIELD(tc_snb20)    #Run Card
                        CALL q_shm2(TRUE,TRUE,'','')
                             RETURNING g_tc_snb[1].tc_snb20
                        DISPLAY BY NAME g_tc_snb[1].tc_snb20
                        NEXT FIELD tc_snb20
                        WHEN INFIELD(tc_snb17)    #FQC單號
                        CALL cl_init_qry_var()
                        LET g_qryparam.state= "c"
                        LET g_qryparam.construct = "Y"
                        LET g_qryparam.form ="q_qcf4"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO tc_snb17
                        NEXT FIELD tc_snb17
 
                   WHEN INFIELD(tc_snb11)    #工單單號
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.construct ="Y"
                        LET g_qryparam.form ="q_sfb01"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO tc_snb11
                        NEXT FIELD tc_snb11
                  WHEN INFIELD(tc_snb05)
                    CALL cl_init_qry_var()
                    #Mod No.FUN-AA0082
                    #LET g_qryparam.form     = "q_ime"
                     LET g_qryparam.form     = "q_ecd2"
                    #End Mod No.FUN-AA0082
                     LET g_qryparam.state    = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO tc_snb05
                  WHEN INFIELD(tc_snb06)
                    #Mod No.FUN-AA0082
                    #CALL cl_init_qry_var()
                    #LET g_qryparam.form     = "q_ime"
                    #LET g_qryparam.state    = "c"
                    #CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_ime_1(TRUE,TRUE,"","","",g_plant,"","","")
                         RETURNING g_qryparam.multiret
                    #End Mod No.FUN-AA0082
                     DISPLAY g_qryparam.multiret TO tc_snb06
                     NEXT FIELD tc_snb06
                  WHEN INFIELD(tc_snb07)
                     CALL cl_init_qry_var()
                    #Mod No.FUN-AA0082
                    #LET g_qryparam.form     = "q_ime"
                     LET g_qryparam.form     = "q_tc_snb07"
                    #End Mod No.FUN-AA0082
                     LET g_qryparam.state    = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO tc_snb07
                     NEXT FIELD tc_snb07
                  WHEN INFIELD(tc_snb33)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO tc_snb33
                     NEXT FIELD tc_snb33
                  WHEN INFIELD(tc_snb30)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO tc_snb30
                     NEXT FIELD tc_snb30
                     {
                  WHEN INFIELD(tc_snb930)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form  = "q_gem4"
                     LET g_qryparam.state = "c"   #多選
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO tc_snb930
                     NEXT FIELD tc_snb930
                     
                 WHEN INFIELD(tc_snb41) #專案
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_pja2"  
                   LET g_qryparam.state = "c"   #多選
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO tc_snb41
                   NEXT FIELD tc_snb41
                 WHEN INFIELD(tc_snb42)  #WBS
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_pjb4"
                   LET g_qryparam.state = "c"   #多選
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO tc_snb42
                   NEXT FIELD tc_snb42
                 WHEN INFIELD(tc_snb43)  #活動
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_pjk3"
                   LET g_qryparam.state = "c"   #多選
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO tc_snb43
                   NEXT FIELD tc_snb43
                   
                 WHEN INFIELD(tc_snb44)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_azf01a"                   #No.FUN-930145
                   LET g_qryparam.state = "c"   #多選
                   LET g_qryparam.arg1 = 'C'                         #No.FUN-930145
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO tc_snb44
                   NEXT FIELD tc_snb44

                 #FUN-BC0104---add---str
                WHEN INFIELD(tc_snb46)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_qco1"     
                  LET g_qryparam.state = "c"   
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_snb46
                  NEXT FIELD tc_snb46

                WHEN INFIELD(tc_snb47)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_qco1"    
                  LET g_qryparam.state = "c"   
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_snb47
                  NEXT FIELD tc_snb47
                #FUN-BC0104---add---end
                }
              END CASE
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
          ON ACTION qbe_save
          CALL cl_qbe_save()
 
       END CONSTRUCT
 
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    ELSE
       LET g_wc2 = " 1=1"
    END IF

     IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT tc_sna01 FROM tc_sna_file",
                   " WHERE ", g_wc CLIPPED,
                   "   AND tc_sna00 = '",g_argv,"'",
                   " ORDER BY 1"
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE tc_sna_file.tc_sna01 ",
                   "  FROM tc_sna_file, tc_snb_file",
                   " WHERE tc_sna01 = tc_snb01",
                   "   AND tc_sna00 = '",g_argv,"'",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY 1"
    END IF
 
    PREPARE t324_prepare FROM g_sql
    DECLARE t324_cs                         #SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR t324_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
          LET g_sql="SELECT COUNT(*) FROM tc_sna_file ",
                    " WHERE ",g_wc CLIPPED,
                    "   AND tc_sna00 = '",g_argv,"'"
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT tc_sna01) FROM tc_sna_file,tc_snb_file WHERE ",
                  "tc_sna01=tc_snb01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                  "   AND tc_sna00 = '",g_argv,"'"
    END IF
 
    PREPARE t324_precount FROM g_sql
    DECLARE t324_count CURSOR FOR t324_precount
 
END FUNCTION
 
FUNCTION t324_menu()
DEFINE l_cmd        LIKE type_file.chr1000   #FUN-BC0104
 
   WHILE TRUE
      CALL t324_bp("G")
      CASE g_action_choice
           WHEN "insert"
              IF cl_chk_act_auth() THEN
                 CALL t324_a()
              END IF
           WHEN "query"
              IF cl_chk_act_auth() THEN
                 CALL t324_q()
              END IF
           WHEN "delete"
              IF cl_chk_act_auth() THEN
                 CALL t324_r()
              END IF
           WHEN "modify"
              IF cl_chk_act_auth() THEN
                 CALL t324_u()
              END IF
           WHEN "detail"
              IF cl_chk_act_auth() THEN
                 CALL t324_b()
              ELSE
                 LET g_action_choice = NULL
              END IF
           WHEN "output"
              IF cl_chk_act_auth() THEN
                 CALL t324_out()
              END IF
           WHEN "help"
              CALL cl_show_help()
           WHEN "exit"
              EXIT WHILE
           WHEN "controlg"
              CALL cl_cmdask()
           WHEN "confirm"
              IF cl_chk_act_auth() THEN
                 CALL t324_y_chk()
                 IF g_success = "Y" THEN
                    CALL t324_y_upd()
                 END IF
              END IF
           WHEN "undo_confirm"
              IF cl_chk_act_auth() THEN
                 CALL t324_z()
              END IF
           WHEN "void"
              IF cl_chk_act_auth() THEN
                #CALL t324_x()    #CHI-D20010
                 CALL t324_x(1)   #CHI-D20010
                 CALL t324_show() #FUN-BC0104
              END IF
              CALL t324_pic() #圖形顯示 #FUN-660137
           #CHI-D20010---begin
           WHEN "undo_void"
              IF cl_chk_act_auth() THEN
                 CALL t324_x(2)
                 CALL t324_show() #FUN-BC0104
              END IF
              CALL t324_pic() #圖形顯示 #FUN-660137
           #CHI-D20010---end
           WHEN "stock_post"
              IF cl_chk_act_auth() THEN
                 CALL t324_s()
              END IF
              CALL t324_pic() #圖形顯示 #FUN-660137
           WHEN "undo_post"
              IF cl_chk_act_auth() THEN
                 CALL t324_w()
                
              END IF
              CALL t324_pic() #圖形顯示 #FUN-660137
           WHEN "gen_mat_wtdw"
              IF cl_chk_act_auth() THEN
                 CALL t324_k()
              END IF
          
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_snb),'','')
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_tc_sna.tc_sna01 IS NOT NULL THEN
                 LET g_doc.column1 = "tc_sna01"
                 LET g_doc.value1 = g_tc_sna.tc_sna01
                 CALL cl_doc()
               END IF
         END IF
         #FUN-BC0104---add---str
          WHEN "qc_determine_storage"
            IF cl_chk_act_auth() THEN
               LET  l_cmd = "aqcp107 '2' '' '' '' '' '' '' '' '' 'N'"
               CALL cl_cmdrun(l_cmd)
            END IF
         #FUN-BC0104---add---end
       

      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t324_a()
DEFINE li_result LIKE type_file.num5                 #No.FUN-550067  #No.FUN-680121 SMALLINT
DEFINE   l_no  VARCHAR(20)

    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_tc_snb.clear()
    INITIALIZE g_tc_sna.* TO NULL
    LET g_tc_sna_o.* = g_tc_sna.*
    LET g_tc_sna_t.* = g_tc_sna.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_tc_sna.tc_sna00 = g_argv
        LET g_tc_sna.tc_sna02 = g_today
        LET g_tc_sna.tc_snapost='N'
        LET g_tc_sna.tc_snaconf='N' #FUN-660137
        LET g_tc_sna.tc_snauser=g_user
        LET g_tc_sna.tc_snaoriu = g_user #FUN-980030
        LET g_tc_sna.tc_snaorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_tc_sna.tc_snagrup=g_grup
        LET g_tc_sna.tc_snadate=g_today
       # LET g_tc_sna.tc_sna04=g_grup #FUN-670103
        LET g_tc_sna.tc_snaplant = g_plant #FUN-980008 add
        LET g_tc_sna.tc_snalegal = g_legal #FUN-980008 add
        CALL t324_i("a")                #輸入單頭
        IF INT_FLAG THEN
           LET INT_FLAG=0 CALL cl_err('',9001,0)
           INITIALIZE g_tc_sna.* TO NULL
           ROLLBACK WORK EXIT WHILE
        END IF
        IF g_tc_sna.tc_sna01 IS NULL THEN CONTINUE WHILE END IF
        BEGIN WORK    #No:7829
       # CALL s_auto_assign_no("asf",g_tc_sna.tc_sna01,g_tc_sna.tc_sna02,"A","tc_sna_file","tc_sna01","","","")
        #  RETURNING li_result,g_tc_sna.tc_sna01
       # IF (NOT li_result) THEN
       #    ROLLBACK WORK
        #   CONTINUE WHILE
       # END IF
        CALL p_zl_auno88('') RETURNING l_no 

        LET  g_tc_sna.tc_sna01=l_no
        DISPLAY BY NAME g_tc_sna.tc_sna01
        #FUN-A80128---add---str--
        LET g_tc_sna.tc_sna15   = '0'
        LET g_tc_sna.tc_sna16   = g_user
        LET g_tc_sna.tc_snamksg = 'N' 
        #FUN-A80128---add---end--
        INSERT INTO tc_sna_file VALUES (g_tc_sna.*)
        IF STATUS THEN
           CALL cl_err3("ins","tc_sna_file",g_tc_sna.tc_sna01,"",STATUS,"","",1)  #No.FUN-660128
           ROLLBACK WORK   #No:7829
           CONTINUE WHILE
        END IF
 
        COMMIT WORK
 
        CALL cl_flow_notify(g_tc_sna.tc_sna01,'I')
 
        SELECT tc_sna01 INTO g_tc_sna.tc_sna01 FROM tc_ina_file WHERE tc_sna01 = g_tc_sna.tc_sna01
        LET g_tc_sna_t.* = g_tc_sna.*
 
 
        CALL g_tc_snb.clear()
        LET g_rec_b = 0
        CALL t324_b()                   #輸入單身
 
        SELECT COUNT(*) INTO g_cnt FROM tc_snb_file WHERE tc_snb01=g_tc_sna.tc_sna01
        IF g_cnt>0 THEN
           IF g_smy.smyprint='Y' THEN
              IF cl_confirm('mfg9392') THEN CALL t324_out() END IF
           END IF
           IF g_smy.smydmy4='Y' THEN CALL t324_s() END IF
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t324_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_tc_sna.tc_sna01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_tc_sna.* FROM tc_sna_file WHERE tc_sna01 = g_tc_sna.tc_sna01
    IF g_tc_sna.tc_snapost = 'Y' THEN CALL cl_err('','mfg0175',0) RETURN END IF
    IF g_tc_sna.tc_snaconf = 'Y' THEN CALL cl_err('','9023',0) RETURN END IF #FUN-660137
    IF g_tc_sna.tc_snaconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF #FUN-660137
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_tc_sna_o.* = g_tc_sna.*
 
    BEGIN WORK
 
    OPEN t324_cl USING g_tc_sna.tc_sna01
    IF STATUS THEN
       CALL cl_err("OPEN t324_cl:", STATUS, 1)
       CLOSE t324_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t324_cl INTO g_tc_sna.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tc_sna.tc_sna01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t324_cl ROLLBACK WORK RETURN
    END IF
    CALL t324_show()
    WHILE TRUE
        LET g_tc_sna.tc_snamodu=g_user
        LET g_tc_sna.tc_snadate=g_today
        CALL t324_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_tc_sna.*=g_tc_sna_t.*
            CALL t324_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        UPDATE tc_sna_file SET * = g_tc_sna.* WHERE tc_sna01 = g_tc_sna_o.tc_sna01
        IF STATUS OR SQLCA.SQLERRD[3]=0  THEN
           CALL cl_err3("upd","tc_sna_file",g_tc_sna_t.tc_sna01,"",STATUS,"","",1)  #No.FUN-660128
           CONTINUE WHILE
        END IF
        IF g_tc_sna.tc_sna01 != g_tc_sna_t.tc_sna01 THEN CALL t324_chkkey() END IF
        EXIT WHILE
    END WHILE
 
    CLOSE t324_cl
    COMMIT WORK
    CALL cl_flow_notify(g_tc_sna.tc_sna01,'U')
 
END FUNCTION
 
FUNCTION t324_chkkey()
    UPDATE tc_snb_file SET tc_snb01=g_tc_sna.tc_sna01 WHERE tc_snb01=g_tc_sna_t.tc_sna01
    IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err3("upd","tc_snb_file",g_tc_sna_t.tc_sna01,"",STATUS,"","upd tc_snb01",1)  #No.FUN-660128
       LET g_tc_sna.*=g_tc_sna_t.* CALL t324_show() ROLLBACK WORK RETURN
    END IF
END FUNCTION
 
FUNCTION t324_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1                  #a:輸入 u:更改  #No.FUN-680121 VARCHAR(1)
  DEFINE l_flag          LIKE type_file.chr1,                #判斷必要欄位是否有輸入  #No.FUN-680121 VARCHAR(1)
         g_tc_sna09         LIKE tc_sna_file.tc_sna09
  DEFINE li_result       LIKE type_file.num5                 #No.FUN-550067  #No.FUN-680121 SMALLINT
  DEFINE l_n             LIKE type_file.num5     #TQC-720063
 
    DISPLAY BY NAME
        g_tc_sna.tc_sna01,
        g_tc_sna.tc_sna02,g_tc_sna.tc_sna04,    #FUN-560195
        g_tc_sna.tc_sna06,g_tc_sna.tc_sna07,g_tc_sna.tc_sna08,g_tc_sna.tc_sna09,g_tc_sna.tc_snaconf, #FUN-660137              #FUN-810045
        g_tc_sna.tc_snapost,g_tc_sna.tc_snauser,g_tc_sna.tc_snagrup,g_tc_sna.tc_snamodu,g_tc_sna.tc_snadate
       CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
       INPUT BY NAME g_tc_sna.tc_snaoriu,g_tc_sna.tc_snaorig,
          g_tc_sna.tc_sna01,
          g_tc_sna.tc_sna02,g_tc_sna.tc_sna04,  #FUN-560195
          g_tc_sna.tc_sna08,g_tc_sna.tc_sna09,g_tc_sna.tc_sna06,g_tc_sna.tc_sna07,g_tc_sna.tc_snaconf, #FUN-660137              #FUN-810045
          g_tc_sna.tc_snapost,g_tc_sna.tc_snauser,g_tc_sna.tc_snagrup,g_tc_sna.tc_snamodu,g_tc_sna.tc_snadate
             WITHOUT DEFAULTS
 
       BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL t324_set_entry(p_cmd)
          CALL t324_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          CALL cl_set_docno_format("tc_sna01")  #No.FUN-550067
          CALL cl_set_docno_format("tc_sna09")  #No.FUN-550067
 
 
        BEFORE FIELD tc_sna01
           CALL t324_set_entry(p_cmd)
          # CALL p_zl_auno88('') RETURNING g_tc_sna.tc_sna01

         #  DISPLAY BY NAME g_tc_sna.tc_sna01
 
        AFTER FIELD tc_sna01
          IF cl_null(g_tc_sna.tc_sna01) THEN NEXT FIELD tc_sna01 END IF
          CALL s_check_no("asf",g_tc_sna.tc_sna01,g_tc_sna_t.tc_sna01,"A","tc_sna_file","tc_sna01","")
             RETURNING li_result,g_tc_sna.tc_sna01
            # CALL p_zl_auno88('') RETURNING g_tc_sna.tc_sna01

           DISPLAY BY NAME g_tc_sna.tc_sna01
           IF (NOT li_result) THEN
        	    NEXT FIELD tc_sna01
           END IF
        #TQC-AC0294-----start------------
           CALL t324_tc_sna01(p_cmd)
           IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_tc_sna.tc_sna01,g_errno,0)
               NEXT FIELD tc_sna01
           END IF
        #TQC-AC0294-----end--------------
	        DISPLAY BY NAME g_smy.smydesc
          CALL t324_set_no_entry(p_cmd)    #FUN-550012
 
        AFTER FIELD tc_sna02
            IF cl_null(g_tc_sna.tc_sna02) THEN NEXT FIELD tc_sna02 END IF
	    IF g_sma.sma53 IS NOT NULL AND g_tc_sna.tc_sna02 <= g_sma.sma53 THEN
	        CALL cl_err('','mfg9999',0) NEXT FIELD tc_sna02
	    END IF
            CALL s_yp(g_tc_sna.tc_sna02) RETURNING g_yy,g_mm
            #不可大於現行年月
            IF (g_yy*12+g_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
               CALL cl_err('','mfg6091',0) NEXT FIELD tc_sna02
            END IF
 
        AFTER FIELD tc_sna04
            IF NOT cl_null(g_tc_sna.tc_sna04) THEN
               LET g_buf = ''
               SELECT eca02 INTO g_buf FROM eca_file WHERE eca01=g_tc_sna.tc_sna04
                  AND ecaacti='Y'   #NO:6950
               IF STATUS THEN
                  CALL cl_err3("sel","eca_file",g_tc_sna.tc_sna04,"",STATUS,"","select gem",1)  #No.FUN-660128
                  NEXT FIELD tc_sna04   
               END IF
               DISPLAY g_buf TO gem02
            END IF
 {
          AFTER FIELD tc_sna06
             IF NOT cl_null(g_tc_sna.tc_sna06) THEN
                SELECT COUNT(*) INTO l_n FROM pja_file
                 WHERE pja01=g_tc_sna.tc_sna06
                   AND pjaacti = 'Y'
                   AND pjaclose='N'     #FUN-960038
                IF l_n = 0 THEN
                   CALL cl_err(g_tc_sna.tc_sna06,'asf-984',0)
                   NEXT FIELD tc_sna06
                END IF
                CALL t324_pja02()
             END IF
 }
          AFTER FIELD tc_sna08
             IF NOT cl_null(g_tc_sna.tc_sna08) THEN
                SELECT COUNT(*) INTO g_cnt FROM ecd_file
                 WHERE ecd1 = g_tc_sna.tc_sna08 AND ecdconf = 'Y'               #FUN-A90035 add sfdconf = 'Y'
                IF g_cnt = 0 THEN
                 # CALL cl_err(g_tc_sna.tc_sna08,'asf-401',0)                    #FUN-A90035 mark
                   CALL cl_err(g_tc_sna.tc_sna08,'aec-099',0)                    #FUN-A90035
                   NEXT FIELD tc_sna08
                END IF
               SELECT ecd02 INTO g_tc_sna.tc_sna09 FROM ecd_file WHERE ecd01=g_tc_sna.tc_sna08 
               
             END IF
 
      
 
        ON ACTION controlp
          CASE 
          
              WHEN INFIELD(tc_sna01) #查詢單据
                    LET g_t1=s_get_doc_no(g_tc_sna.tc_sna01)    #No.FUN-550067
                    LET g_sql = " (smy73 <> 'Y' OR smy73 is null)"  #TQC-AC0294 add
                    CALL smy_qry_set_par_where(g_sql)               #TQC-AC0294 add 
	            IF g_argv='0' THEN
                       CALL q_smy( FALSE, TRUE,g_t1,'ASF','9') RETURNING g_t1  #TQC-670008
                    ELSE
                       CALL q_smy( FALSE, TRUE,g_t1,'ASF','A') RETURNING g_t1  #TQC-670008
	            END IF
                    LET g_tc_sna.tc_sna01=g_t1                 #No.FUN-550067
                    DISPLAY BY NAME g_tc_sna.tc_sna01
                    NEXT FIELD tc_sna01
                    
               WHEN INFIELD(tc_sna04)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_eca1"
                    LET g_qryparam.default1 = g_tc_sna.tc_sna04
                    CALL cl_create_qry() RETURNING g_tc_sna.tc_sna04
                    DISPLAY BY NAME g_tc_sna.tc_sna04
                    NEXT FIELD tc_sna04
 {
              WHEN INFIELD(tc_sna06) #專案代號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pja2"   #FUN-810045
                 LET g_qryparam.default1 = g_tc_sna.tc_sna06
                 CALL cl_create_qry() RETURNING g_tc_sna.tc_sna06
                 DISPLAY BY NAME g_tc_sna.tc_sna06
                 NEXT FIELD tc_sna06
                 }
               WHEN INFIELD(tc_sna08)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_ecd3"
                    LET g_qryparam.default1 = g_tc_sna.tc_sna09
                    CALL cl_create_qry() RETURNING g_tc_sna.tc_sna09
                    DISPLAY BY NAME g_tc_sna.tc_sna09
                    NEXT FIELD tc_sna09
            END CASE
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
    END INPUT
 
END FUNCTION
FUNCTION t324_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("tc_sna02,tc_sna04,tc_sna06,tc_sna07,tc_sna08,tc_sna09",TRUE) #FUN-560195       #FUN-810045 
    END IF
 
END FUNCTION
 
FUNCTION t324_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("tc_sna01",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION t324_set_entry_b(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
 
   CALL cl_set_comp_entry("tc_snb04",TRUE)
   CALL cl_set_comp_entry("tc_snb30,tc_snb32,tc_snb33,tc_snb35",TRUE)
 
   CALL cl_set_comp_entry("tc_snb41,tc_snb42,tc_snb43,tc_snb44",TRUE)  #FUN-810045
 
END FUNCTION
 
FUNCTION t324_set_no_entry_b(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
 
   IF g_ima906 = '1' THEN
      CALL cl_set_comp_entry("tc_snb33,tc_snb35",FALSE)
   END IF
   IF g_ima906 = '3' THEN
      CALL cl_set_comp_entry("tc_snb33",FALSE)
   END IF
 
   IF l_ac > 0 THEN
     IF NOT cl_null(g_tc_snb[l_ac].tc_snb11) THEN
       CALL cl_set_comp_entry("tc_snb41,tc_snb42,tc_snb43,tc_snb44",FALSE)
     END IF
   END IF
 
END FUNCTION
 
FUNCTION t324_set_entry_b1(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
    CALL cl_set_comp_entry("tc_snb04",TRUE)
 
END FUNCTION
 
FUNCTION t324_set_no_entry_b1(p_cmd)
  DEFINE p_cmd    LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
  DEFINE l_cnt    LIKE type_file.num5    #FUN-BCO104
  DEFINE l_ima903 LIKE ima_file.ima903   #FUN-BC0104
  DEFINE l_ima01  LIKE ima_file.ima01   #FUN-BC0104
 
  #FUN-BC0104--begin-add--
  IF l_ac > 0 THEN
     LET l_cnt=0 LET l_ima903=''
     SELECT ima903,ima01 INTO l_ima903,l_ima01 FROM ima_file
      WHERE ima01 = (SELECT sfb05 FROM sfb_file
                      WHERE sfb01 = g_tc_snb[l_ac].tc_snb11)
     IF g_sma.sma104 = 'Y' AND g_sma.sma105 = '2'
        AND l_ima903 = 'Y' THEN #認定聯產品的時機點為:2.完工入庫
        SELECT COUNT(*) INTO l_cnt FROM bmm_file
         WHERE bmm01 = l_ima01
        IF l_cnt >= 1 THEN
           LET g_tc_snb16='Y'
        END IF
     END IF
  END IF
  #FUN-BC0104--end--add---
  IF INFIELD(tc_snb20) AND (cl_null(g_tc_snb16) OR g_tc_snb16<>'Y') THEN
     CALL cl_set_comp_entry("tc_snb04",FALSE)
  END IF
  #FUN-BC0104---add---str---
  IF l_ac >0 THEN
     IF NOT cl_null(g_tc_snb[l_ac].tc_snb46) THEN
        CALL cl_set_comp_entry("tc_snb04",FALSE)
     END IF
  END IF
  #FUN-BC0104---add---end---
END FUNCTION
 
FUNCTION t324_pja02()   #專案名稱
   DEFINE
       l_pja02 LIKE pja_file.pja02 
 
   IF g_tc_sna.tc_sna06 IS NULL THEN RETURN END IF
   LET l_pja02=' '
   LET g_errno=' '
   SELECT pja02 INTO l_pja02
     FROM pja_file
     WHERE pja01=g_tc_sna.tc_sna06 AND pjaacti='Y'
       AND pjaclose='N'     #FUN-960038
   IF SQLCA.sqlcode THEN
      LET g_errno='apj-005'
      LET l_pja02=''
   END IF
   DISPLAY l_pja02 TO FORMONLY.pja02
 
END FUNCTION
 
 
FUNCTION t324_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_tc_sna.* TO NULL               #No.FUN-6A0164
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t324_cs()
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       INITIALIZE g_tc_sna.* TO NULL
       RETURN 
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t324_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_tc_sna.* TO NULL
    ELSE
        OPEN t324_count
        FETCH t324_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t324_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t324_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式  #No.FUN-680121 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數  #No.FUN-680121 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t324_cs INTO g_tc_sna.tc_sna01
        WHEN 'P' FETCH PREVIOUS t324_cs INTO g_tc_sna.tc_sna01
        WHEN 'F' FETCH FIRST    t324_cs INTO g_tc_sna.tc_sna01
        WHEN 'L' FETCH LAST     t324_cs INTO g_tc_sna.tc_sna01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
                END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump t324_cs INTO g_tc_sna.tc_sna01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tc_sna.tc_sna01,SQLCA.sqlcode,0)
        INITIALIZE g_tc_sna.* TO NULL  #TQC-6B0105
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
    END IF
    SELECT * INTO g_tc_sna.* FROM tc_sna_file WHERE tc_sna01 = g_tc_sna.tc_sna01
 
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","tc_sna_file",g_tc_sna.tc_sna01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
       INITIALIZE g_tc_sna.* TO NULL
    ELSE
       LET g_data_owner = g_tc_sna.tc_snauser      #FUN-4C0035 add
       LET g_data_group = g_tc_sna.tc_snagrup      #FUN-4C0035 add
       LET g_data_plant = g_tc_sna.tc_snaplant #FUN-980030
       CALL t324_show()
    END IF
 
END FUNCTION
 
FUNCTION t324_show()
     DEFINE l_smydesc LIKE smy_file.smydesc  #MOD-4C0010
 
    LET g_tc_sna_t.* = g_tc_sna.*                #保存單頭舊值
    SELECT tc_snaconf INTO g_tc_sna.tc_snaconf     #FUN-C40016
      FROM tc_sna_file                       #FUN-C40016
     WHERE tc_sna01 = g_tc_sna.tc_sna01            #FUN-C40016
    DISPLAY BY NAME g_tc_sna.tc_snaoriu,g_tc_sna.tc_snaorig,
        g_tc_sna.tc_sna01,g_tc_sna.tc_sna02,g_tc_sna.tc_sna04,   #FUN-560195
        g_tc_sna.tc_sna06,g_tc_sna.tc_sna07,g_tc_sna.tc_sna08,              #FUN-810045
        g_tc_sna.tc_sna09,g_tc_sna.tc_snaconf, #FUN-660137
        g_tc_sna.tc_snapost,
        g_tc_sna.tc_snauser,g_tc_sna.tc_snagrup,g_tc_sna.tc_snamodu,g_tc_sna.tc_snadate
    LET g_buf = s_get_doc_no(g_tc_sna.tc_sna01)   #No.FUN-550067
     SELECT smydesc INTO l_smydesc FROM smy_file WHERE smyslip=g_buf #MOD-4C0010
     DISPLAY l_smydesc TO smydesc LET g_buf = NULL #MOD-4C0010
    CALL t324_show2()
 
    CALL t324_pic() #圖形顯示 #FUN-660137
 
    CALL t324_b_fill(g_wc2)
END FUNCTION
 
FUNCTION t324_show2()
    SELECT gem02 INTO g_buf FROM gem_file WHERE gem01=g_tc_sna.tc_sna04
                 DISPLAY g_buf TO gem02 LET g_buf = NULL
    SELECT pja02 INTO g_buf FROM pja_file WHERE pja01 = g_tc_sna.tc_sna06 AND pjaacti = 'Y'
    DISPLAY g_buf TO FORMONLY.pja02  
    LET g_buf = NULL        
END FUNCTION
 
FUNCTION t324_r()
    DEFINE l_chr,l_sure  LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
    DEFINE l_i           LIKE type_file.num5   #FUN-810045 add
    DEFINE l_flag        LIKE type_file.chr1    #FUN-B70074 add
    #FUN-BC0104---add---str---
    DEFINE l_tc_snb17         LIKE tc_snb_file.tc_snb17,
           l_tc_snb47         LIKE tc_snb_file.tc_snb47,
           l_cn            LIKE type_file.num5,
           l_c             LIKE type_file.num5
    DEFINE l_tc_snb_a   DYNAMIC ARRAY OF RECORD
           tc_snb17           LIKE tc_snb_file.tc_snb17,
           tc_snb47           LIKE tc_snb_file.tc_snb47
                     END RECORD
    #FUN-BC0104---add---end---
 
    IF s_shut(0) THEN RETURN END IF
    IF g_tc_sna.tc_sna01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_tc_sna.* FROM tc_sna_file WHERE tc_sna01 = g_tc_sna.tc_sna01
    IF g_tc_sna.tc_snapost = 'Y' THEN CALL cl_err('','mfg0175',0) RETURN END IF
    IF g_tc_sna.tc_snaconf = 'Y' THEN CALL cl_err('','9023',0) RETURN END IF #FUN-660137
    IF g_tc_sna.tc_snaconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF #FUN-660137
 
    BEGIN WORK
 
    OPEN t324_cl USING g_tc_sna.tc_sna01
    IF STATUS THEN
       CALL cl_err("OPEN t324_cl:", STATUS, 1)
       CLOSE t324_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t324_cl INTO g_tc_sna.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_tc_sna.tc_sna01,SQLCA.sqlcode,0)
       CLOSE t324_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    CALL t324_show()
 
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "tc_sna01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_tc_sna.tc_sna01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
       MESSAGE "Delete tc_sna,tc_snb!"
       DELETE FROM tc_sna_file WHERE tc_sna01 = g_tc_sna.tc_sna01
       IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("del","tc_sna_file",g_tc_sna.tc_sna01,"",SQLCA.SQLCODE,"","No ina deleted",1)  #No.FUN-660128
          ROLLBACK WORK RETURN
       END IF
       #FUN-BC0104---add---str---
        DECLARE tc_snb03_cur CURSOR FOR SELECT tc_snb17,tc_snb47
                                     FROM tc_snb_file
                                     WHERE tc_snb01 = g_tc_sna.tc_sna01
        LET l_cn = 1
        FOREACH tc_snb03_cur INTO l_tc_snb17,l_tc_snb47
           LET l_tc_snb_a[l_cn].tc_snb17 = l_tc_snb17
           LET l_tc_snb_a[l_cn].tc_snb47 = l_tc_snb47
           LET l_cn = l_cn+1
        END FOREACH
        #FUN-BC0104---add---end---
       DELETE FROM tc_snb_file WHERE tc_snb01 = g_tc_sna.tc_sna01
       #FUN-BC0104---add---str---
        FOR l_c=1 TO l_cn-1
           IF NOT s_iqctype_upd_qco20(l_tc_snb_a[l_c].tc_snb17,0,0,l_tc_snb_a[l_c].tc_snb47,'2') THEN
                   ROLLBACK WORK
                   RETURN
                END IF
        END FOR

      
       IF g_argv='1' THEN
          SELECT COUNT(*) INTO l_i FROM shb_file                                                                                   
               WHERE shb21 = g_tc_sna.tc_sna01                                                                                               
                 AND shbconf = 'Y'     #FUN-A70095 
          IF SQLCA.sqlcode THEN LET l_i = 0  END IF                                                                                
          IF l_i>0 THEN                                                                                                            
             UPDATE shb_file SET shb21 = NULL                                                                                      
              WHERE shb21 = g_tc_sna.tc_sna01                                                                                            
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN                                                                           
                CALL cl_err('upd shb21',SQLCA.sqlcode,1)                                                                           
                ROLLBACK WORK                                                                                                      
                RETURN                                                                                                             
             END IF                                                                                                                
          END IF
       END IF                                                                                                                    
 
       FOR l_i = 1 TO g_rec_b 
          #IF NOT s_del_rvbs("2",g_tc_sna.tc_sna01,g_tc_snb[l_i].tc_snb03,0)  THEN       #FUN-880129   #TQC-B90236 mark
           IF NOT s_lot_del(g_prog,g_tc_sna.tc_sna01,'',0,g_tc_snb[l_i].tc_snb04,'DEL') THEN  #TQC-B90236 add
              ROLLBACK WORK
              RETURN
           END IF
       END FOR
 
     
       CLEAR FORM
       CALL g_tc_snb.clear()
 
       INITIALIZE g_tc_sna.* TO NULL
       MESSAGE ""
       OPEN t324_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE t324_cs
          CLOSE t324_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH t324_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t324_cs
          CLOSE t324_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t324_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t324_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL t324_fetch('/')
       END IF
 
    END IF
 
    CLOSE t324_cl
    COMMIT WORK
    CALL cl_flow_notify(g_tc_sna.tc_sna01,'D')
 
END FUNCTION
 
 
FUNCTION t324_b()
DEFINE
    l_ac_t           LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680121 SMALLINT
    l_row,l_col      LIKE type_file.num5,   #No.FUN-680121 SMALLINT,              #分段輸入之行,列數
    l_n,l_cnt        LIKE type_file.num5,                #檢查重複用  #No.FUN-680121 SMALLINT
    l_lock_sw        LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-680121 VARCHAR(1)
    p_cmd            LIKE type_file.chr1,                 #處理狀態  #No.FUN-680121 VARCHAR(1)
    l_qcf03          LIKE qcf_file.qcf03,   #No.MOD-530603 add
    l_shm28          LIKE shm_file.shm28,   #No.FUN-630104 add
    l_pjb25          LIKE pjb_file.pjb25,          #FUN-810045
 
    l_ima35          LIKE ima_file.ima35,
    l_ima36          LIKE ima_file.ima36,
    l_ecu04          LIKE ecu_file.ecu04,
    l_ecu05          LIKE ecu_file.ecu05,
    l_tc_snb09          LIKE tc_snb_file.tc_snb09,
    l_sgm_out        LIKE tc_snb_file.tc_snb09,
    l_qty1           LIKE tc_snb_file.tc_snb09,
    l_qty2           LIKE tc_snb_file.tc_snb09,
    l_sgm311         LIKe sgm_file.sgm311,
    l_sgm315         LIKe sgm_file.sgm315,
    l_sfb08          LIKE sfb_file.sfb08,
    l_sfb39          LIKE sfb_file.sfb39,
    l_qcf091         LIKE qcf_file.qcf091,
    l_sum_tc_snb09      LIKE tc_snb_file.tc_snb09,    #FUN-550012
    l_date           LIKE type_file.dat,     #No.FUN-680121 DATE,
    l_allow_insert   LIKE type_file.num5,    #可新增否  #No.FUN-680121 SMALLINT
    l_allow_delete   LIKE type_file.num5     #可刪除否  #No.FUN-680121 SMALLINT
DEFINE  l_pjb09      LIKE pjb_file.pjb09     #FUN-850027
DEFINE  l_pjb11      LIKE pjb_file.pjb11     #FUN-850027
DEFINE  l_ima153     LIKE ima_file.ima153    #FUN-910053 
DEFINE  l_azf09      LIKE azf_file.azf09     #No.FUN-930145

DEFINE  l_ecm03      LIKE ecm_file.ecm03     #FUN-A60076
DEFINE  l_ecm012     LIKE ecm_file.ecm012    #FUN-A60076   
DEFINE l_tf          LIKE type_file.chr1                 #No.FUN-BB0086
DEFINE l_case        STRING                  #No.FUN-BB0086
DEFINE l_sum         LIKE qco_file.qco11       #FUN-BC0104 add
DEFINE l_qcl05       LIKE qcl_file.qcl05       #FUN-BC0104 add
DEFINE l_ac2         LIKE type_file.num5     #CHI-C30118
DEFINE l_n1          LIKE type_file.num5     #TQC-D70056
DEFINE l_shm08       LIKE shm_file.shm08
DEFINE l_sum_tc_snb09_1 LIKE tc_snb_file.tc_snb09
DEFINE l_tc_snb09_1     LIKE tc_snb_file.tc_snb09
#str----add by huanglf160922
DEFINE l_year        LIKE type_file.chr30
DEFINE l_months      LIKE type_file.chr30
DEFINE l_day        LIKE type_file.chr30
#str----end by huanglf160922
#str----add by huanglf161014
DEFINE l_sfb22     LIKE sfb_file.sfb22
DEFINE l_oea31     LIKE oea_file.oea31
DEFINE l_oea23     LIKE oea_file.oea23
DEFINE l_oeb05     LIKE oeb_file.oeb05
DEFINE l_oea21     LIKE oea_file.oea21
DEFINE l_year1     LIKE type_file.chr30
DEFINE l_month1    LIKE type_file.chr30
DEFINE l_number    LIKE type_file.chr30  
DEFINE l_type1     LIKE   type_file.num5
DEFINE l_sql       STRING 
#str----end by huanglf161014
    LET g_action_choice = ""
 
    IF g_tc_sna.tc_sna01 IS NULL THEN RETURN END IF
    IF g_tc_sna.tc_snaconf = 'Y' THEN CALL cl_err('','9023',0) RETURN END IF #FUN-660137
    IF g_tc_sna.tc_snaconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF #FUN-660137
      #是否使用FQC功能                               #入庫
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT tc_snb03,tc_snb17,tc_snb20,tc_snb11,tc_snb46,'',tc_snb47,tc_snb04,'','',tc_snb08,tc_snb05,tc_snb06,",  #FUN-550012 #FUN-BC0104 tc_snb46,tc_snb47
                       "       tc_snb07,tc_snb09,tc_snb33,tc_snb34,tc_snb35,tc_snb30,tc_snb31,tc_snb32,tc_snb12,tc_snb930,'',tc_snbud07,'' ", #FUN-670103
                       "  FROM tc_snb_file",
                       " WHERE tc_snb01= ? AND tc_snb03= ? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t324_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    #CKP
    IF g_rec_b=0 THEN CALL g_tc_snb.clear() END IF
 
    INPUT ARRAY g_tc_snb WITHOUT DEFAULTS FROM s_tc_snb.*
 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd='u'
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
            LET g_tc_snb16 = 'N'     #FUN-BC0104
 
            BEGIN WORK
 
            OPEN t324_cl USING g_tc_sna.tc_sna01
            IF STATUS THEN
               CALL cl_err("OPEN t324_cl:", STATUS, 1)
               CLOSE t324_cl
               ROLLBACK WORK
               RETURN
            ELSE
               FETCH t324_cl INTO g_tc_sna.*          # 鎖住將被更改或取消的資料
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_tc_sna.tc_sna01,SQLCA.sqlcode,0)     # 資料被他人LOCK
                  CLOSE t324_cl ROLLBACK WORK RETURN
               END IF
            END IF
 
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_tc_snb_t.* = g_tc_snb[l_ac].*  #BACKUP
                OPEN t324_bcl USING g_tc_sna.tc_sna01,g_tc_snb_t.tc_snb03
                IF STATUS THEN
                   CALL cl_err("OPEN t324_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH t324_bcl INTO g_tc_snb_t.*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err('lock tc_snb',SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   END IF
                   LET g_tc_snb[l_ac].gem02c=s_costcenter_desc(g_tc_snb[l_ac].tc_snb930) #FUN-670103
                   LET g_before_input_done = FALSE
                   CALL t324_set_entry_b('u')
                   CALL t324_set_no_entry_b('u')
                   LET g_before_input_done = TRUE
                 LET g_change='N'  #No.FUN-580029
                END IF
                #FUN-BC0104---add---str---
                CALL t324_set_noentry_tc_snb46()       
                IF NOT cl_null(g_tc_snb[l_ac].tc_snb46) THEN
                   CALL t324_qcl02_desc()
                END IF
                CALL t324_set_entry_b1(p_cmd)
                CALL t324_set_no_entry_b1(p_cmd)
                #FUN-BC0104---add---end---
                CALL cl_show_fld_cont()     #FUN-550037(smin)
              #IF由工單帶入，則不可修改tc_snb41-43
               IF NOT cl_null(g_tc_snb[l_ac].tc_snb11) THEN
                  CALL cl_set_comp_entry("tc_snb41,tc_snb42,tc_snb43,tc_snb44",FALSE)  
               ELSE
                  CALL cl_set_comp_entry("tc_snb41,tc_snb42,tc_snb43,tc_snb44",TRUE)  
               END IF
            END IF

        AFTER INSERT
            IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              #CKP
              INITIALIZE g_tc_snb[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_tc_snb[l_ac].* TO s_tc_snb.*
              CALL g_tc_snb.deleteElement(g_rec_b+1)
              ROLLBACK WORK
              EXIT INPUT
            END IF
            IF g_sma.sma115 = 'Y' THEN
               CALL s_chk_va_setting(g_tc_snb[l_ac].tc_snb04)
                    RETURNING g_cnt,g_ima906,g_ima907
               IF g_cnt=1 THEN
                  NEXT FIELD tc_snb04
               END IF
               CALL t324_du_data_to_correct()
            END IF
            CALL t324_set_origin_field()
            CALL t324_b_else()
           
#
#str-----end by huanglf161014
       #   IF g_success = 'Y' THEN #FUN-810025
           LET l_type1=1
  
            INSERT INTO tc_snb_file (tc_snb01,tc_snb03,tc_snb04,tc_snb05,tc_snb06,tc_snb07,
                                  tc_snb08,tc_snb09,tc_snb11,tc_snb14,
                                  tc_snb46,tc_snb47,            #FUN-BC0104
                                  tc_snb41,tc_snb42,tc_snb43,tc_snb44,   #FUN-810045 add
                                  tc_snb12,tc_snb17,tc_snb20,
                                  tc_snb30,tc_snb31,tc_snb32,tc_snb33,tc_snb34,tc_snb35,tc_snb930,tc_snbud07,   #FUN-550012 #FUN-670103
                                  tc_snbplant,tc_snblegal) #FUN-980008 add
                           VALUES(g_tc_sna.tc_sna01,g_tc_snb[l_ac].tc_snb03,
                                  g_tc_snb[l_ac].tc_snb04,g_tc_snb[l_ac].tc_snb05,
                                  g_tc_snb[l_ac].tc_snb06,g_tc_snb[l_ac].tc_snb07,
                                  g_tc_snb[l_ac].tc_snb08,g_tc_snb[l_ac].tc_snb09,
                                  g_tc_snb[l_ac].tc_snb11,l_type1,
                                  g_tc_snb[l_ac].tc_snb46,g_tc_snb[l_ac].tc_snb47,  #FUN-BC0104
                                  g_tc_snb[l_ac].tc_snb41,g_tc_snb[l_ac].tc_snb42,  #FUN-810045
                                  g_tc_snb[l_ac].tc_snb43,g_tc_snb[l_ac].tc_snb44,  #FUN-810045
                                  g_tc_snb[l_ac].tc_snb12,
                                  g_tc_snb[l_ac].tc_snb17,g_tc_snb[l_ac].tc_snb20,
                                  g_tc_snb[l_ac].tc_snb30,g_tc_snb[l_ac].tc_snb31,
                                  g_tc_snb[l_ac].tc_snb32,g_tc_snb[l_ac].tc_snb33,
                                  g_tc_snb[l_ac].tc_snb34,g_tc_snb[l_ac].tc_snb35,g_tc_snb[l_ac].tc_snb930,   #FUN-550012 #FUN-670103
                                  g_tc_snb[l_ac].tc_snbud07,
                                  g_plant,g_legal) #FUN-980008 add  #hlf-07751
        #  END IF #FUN-810025
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","tc_snb_file",g_tc_sna.tc_sna01,g_tc_snb[l_ac].tc_snb03,SQLCA.sqlcode,"","ins tc_snb",1)  #No.FUN-660128
  
               CANCEL INSERT   #MOD-BA0106
            ELSE

               MESSAGE 'INSERT O.K'
               #FUN-BC0104---add---str
              
               #FUN-BC0104---add---end
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            LET g_before_input_done = FALSE
            CALL t324_set_entry_b('a')
            CALL t324_set_no_entry_b('a')
            LET g_before_input_done = TRUE
            INITIALIZE g_tc_snb[l_ac].* TO NULL      #900423
            LET g_tc_snb_t.* = g_tc_snb[l_ac].*
            LET g_tc_snb[l_ac].tc_snb09=0
            LET g_tc_snb[l_ac].tc_snb31=1
            LET g_tc_snb[l_ac].tc_snb34=1
            LET g_tc_snb[l_ac].tc_snb930=s_costcenter(g_tc_sna.tc_sna04) #FUN-670103
            LET g_tc_snb[l_ac].gem02c=s_costcenter_desc(g_tc_snb[l_ac].tc_snb930) #FUN-670103
            LET g_tc_snb[l_ac].tc_snb41 = g_tc_sna.tc_sna06    #FUN-810045 add
            LET g_change='Y'
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            CALL cl_set_comp_required('tc_snb46,tc_snb47',FALSE)       #FUN-BC0104 add
            CALL cl_set_comp_entry('tc_snb46,tc_snb47',TRUE)     #FUN-BC0104 add
            NEXT FIELD tc_snb03
 
        BEFORE FIELD tc_snb03                            #default 序號
            IF g_tc_snb[l_ac].tc_snb03 IS NULL OR g_tc_snb[l_ac].tc_snb03 = 0 THEN
                SELECT max(tc_snb03)+1 INTO g_tc_snb[l_ac].tc_snb03
                  FROM tc_snb_file WHERE tc_snb01 = g_tc_sna.tc_sna01
                IF g_tc_snb[l_ac].tc_snb03 IS NULL THEN
                    LET g_tc_snb[l_ac].tc_snb03 = 1
                END IF
            END IF
            #FUN-BC0104---add---str---
            IF p_cmd = 'a' THEN
              CALL cl_set_comp_required('tc_snb46,tc_snb47',FALSE)
              CALL cl_set_comp_entry('tc_snb46,tc_snb47',TRUE)
            END IF
           #FUN-BC0104---add---end---
 
        AFTER FIELD tc_snb03                        #check 序號是否重複
            IF cl_null(g_tc_snb[l_ac].tc_snb03) THEN NEXT FIELD tc_snb03 END IF
            IF g_tc_snb[l_ac].tc_snb03 != g_tc_snb_t.tc_snb03 OR
               g_tc_snb_t.tc_snb03 IS NULL THEN
                SELECT count(*) INTO l_n FROM tc_snb_file
                    WHERE tc_snb01 = g_tc_sna.tc_sna01 AND tc_snb03 = g_tc_snb[l_ac].tc_snb03
                IF l_n > 0 THEN
                    LET g_tc_snb[l_ac].tc_snb03 = g_tc_snb_t.tc_snb03
                    CALL cl_err('',-239,0) NEXT FIELD tc_snb03
                END IF
            END IF
 {
        AFTER FIELD tc_snb17
          IF NOT cl_null(g_tc_snb[l_ac].tc_snb17) THEN
                   CALL t324_tc_snb17(p_cmd)
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err('',g_errno,1)
                      NEXT FIELD tc_snb17
                   END IF
             #FUN-BC0104---add---str---
             IF p_cmd = 'a' THEN
                CALL t324_tc_snb46_check() 
             END IF
             #FUN-BC0104---add---end---
          END IF
}
        #FUN-BC0104---add---str---
        BEFORE FIELD tc_snb20
         CALL t324_set_entry_b1(p_cmd)
        #FUN-BC0104---add---end--- 

        AFTER FIELD tc_snb20     #Run Card
         IF cl_null(g_tc_snb[l_ac].tc_snb20) THEN NEXT FIELD tc_snb20 END IF
         #TQC-D70056----add---str--
         #LET g_tc_snb[l_ac].tc_snb07=g_tc_snb[l_ac].tc_snb20   #add by guanyao160901 #modify by huanglf160922
         LET l_year = YEAR (g_today)
         LET l_year = l_year[3,4]
         LET l_months = MONTH(g_today) USING '&&'
         LET l_day = DAY(g_today) USING '&&'
         LET g_tc_snb[l_ac].tc_snb07 = g_tc_snb[l_ac].tc_snb11,"-",l_year,l_months,l_day #add by huanglf160922
         DISPLAY BY NAME g_tc_snb[l_ac].tc_snb07         #add by guanyao160901
     
         #TQC-D70056----add---end--
         #IF cl_null(g_tc_snb_t.tc_snb20) OR g_tc_snb[l_ac].tc_snb20 ! = g_tc_snb_t.tc_snb20 THEN #FUN-BC0104
           SELECT shm012,shm28 INTO g_tc_snb[l_ac].tc_snb11,l_shm28 FROM shm_file
            WHERE shm01 = g_tc_snb[l_ac].tc_snb20
           IF SQLCA.sqlcode THEN
              CALL cl_err3("sel","shm_file",g_tc_snb[l_ac].tc_snb20,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
              NEXT FIELD tc_snb20
           END IF
           LET g_tc_snb[l_ac].tc_snb07 = g_tc_snb[l_ac].tc_snb11,"-",l_year,l_months,l_day #add by huanglf160922 --dongy 160923加在这里 
           DISPLAY BY NAME g_tc_snb[l_ac].tc_snb07         #add by guanyao160901
          #加入RUN CARD 結案碼  
           IF l_shm28='Y' THEN
              CALL cl_err(g_tc_snb[l_ac].tc_snb20,'asf-911',0)
              NEXT FIELD tc_snb20
           END IF
           DISPLAY BY NAME g_tc_snb[l_ac].tc_snb11
           CALL t324_set_no_entry_b(p_cmd) #FUN-810045 end
          
           IF g_argv = '1' THEN
              CALL t324_sfb01(l_ac)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD tc_snb20
              END IF
        
           END IF
        
                
           
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_tc_snb[l_ac].tc_snb11,g_errno,0)
              NEXT FIELD tc_snb20
           END IF
          #FUN-D70008-add---str
          IF g_sma.sma73 = 'Y' THEN #add by guanyao160902
           IF cl_null(l_date) OR l_date > g_tc_sna.tc_sna02 THEN
              IF g_sfb.sfb39 != '2' THEN  
                 CALL cl_err('sel_sfp02','asf-824',1)
                 NEXT FIELD tc_snb20
              END IF                     
           END IF
          END IF 
          #FUN-D70008-add---end
           SELECT ima571 INTO g_ima571 FROM ima_file WHERE ima01=g_sfb.sfb05
           IF g_ima571 IS NULL THEN LET g_ima571=' ' END IF
           LET l_ecu04=0 LET l_ecu05=0
           IF g_sfb.sfb93 = 'Y' THEN  #製程否
              SELECT ecu04,ecu05 INTO l_ecu04,l_ecu05 FROM ecu_file
               WHERE ecu01=g_ima571 AND ecu02=g_sfb.sfb06
              IF g_argv MATCHES '[0]' AND l_ecu04=l_ecu05 THEN
                 CALL cl_err('','asf-702',0) NEXT FIELD tc_snb20
              END IF
           END IF
         #END IF #FUN-BC0104
         CALL t324_set_no_entry_b1(p_cmd)  #FUN-BC0104
 
        AFTER FIELD tc_snb05     #倉庫--作业编码
           IF g_argv MATCHES '[12]' THEN
              IF cl_null(g_tc_snb[l_ac].tc_snb05) THEN NEXT FIELD tc_snb05 END IF
              SELECT  ecd01 INTO g_buf FROM ecd_file
           #    WHERE imd01=g_tc_snb[l_ac].tc_snb05 AND imd10='S'                  #MOD-B50097 mark
                WHERE ecd01=g_tc_snb[l_ac].tc_snb05 AND ecdacti='Y'  #MOD-B50097 add
                  
              IF STATUS THEN
                 CALL cl_err3("sel","ecd_file",g_tc_snb[l_ac].tc_snb05,"","abm-750","","ecd",1)   #No.FUN-660128
                 NEXT FIELD tc_snb05
              END IF
           END IF
        
 
        AFTER FIELD tc_snb06    #-- 作业编码
           
           
               LET g_tc_snb[l_ac].tc_snb06 = '维修站'

          
 
        AFTER FIELD tc_snb07    #批號
          
 
        BEFORE FIELD tc_snb09    #入庫量
           ERROR g_msg
 
        AFTER FIELD tc_snb09    #入庫量
           IF cl_null(g_tc_snb[l_ac].tc_snb09) OR g_tc_snb[l_ac].tc_snb09 <= 0 THEN
              LET g_tc_snb[l_ac].tc_snb09 = 0
              NEXT FIELD tc_snb09
           END IF
        
           CALL t324_set_no_entry_b('a')
           #FUN-BC0104---add---str
     
      
        BEFORE FIELD tc_snb30
           CALL t324_set_no_required()
 
        AFTER FIELD tc_snb30  #第一單位
           IF cl_null(g_tc_snb[l_ac].tc_snb04) THEN 
            NEXT FIELD tc_snb04 
           END IF
        AFTER FIELD tc_snb32  #第一數量
         
        BEFORE DELETE                            #是否取消單身
        
           IF g_tc_snb_t.tc_snb03 > 0 AND (g_tc_snb_t.tc_snb03 IS NOT NULL ) THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
 

               DELETE FROM tc_snb_file
                WHERE tc_snb01 = g_tc_sna.tc_sna01 AND tc_snb03 = g_tc_snb_t.tc_snb03
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","tc_snb_file",g_tc_sna.tc_sna01,g_tc_snb_t.tc_snb03,SQLCA.sqlcode,"","",1)  #No.FUN-660128
                  ROLLBACK WORK
                  CANCEL DELETE

               END IF
              
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
               COMMIT WORK
          END IF 
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_tc_snb[l_ac].* = g_tc_snb_t.*
               CLOSE t324_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
 
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_tc_snb[l_ac].tc_snb03,-263,1)
               LET g_tc_snb[l_ac].* = g_tc_snb_t.*
            ELSE
               IF g_sma.sma115 = 'Y' THEN
                  CALL s_chk_va_setting(g_tc_snb[l_ac].tc_snb04)
                       RETURNING g_cnt,g_ima906,g_ima907
                  IF g_cnt =1 THEN
                     NEXT FIELD tc_snb04
                  END IF
                  CALL t324_du_data_to_correct()
               END IF
               CALL t324_set_origin_field()
 
               CALL t324_b_else()
             END IF
          
               IF g_success = 'Y' THEN
               UPDATE tc_snb_file SET tc_snb01=g_tc_sna.tc_sna01,
                                   tc_snb03=g_tc_snb[l_ac].tc_snb03,
                                   tc_snb04=g_tc_snb[l_ac].tc_snb04,
                                   tc_snb=g_tc_snb[l_ac].tc_snb05,
                                   tc_snb=g_tc_snb[l_ac].tc_snb06,
                                   tc_snb07=g_tc_snb[l_ac].tc_snb07,
                                   tc_snb08=g_tc_snb[l_ac].tc_snb08,
                                   tc_snb09=g_tc_snb[l_ac].tc_snb09,
                                   tc_snb11=g_tc_snb[l_ac].tc_snb11,
                                   tc_snb41=g_tc_snb[l_ac].tc_snb41,  
                                   tc_snb42=g_tc_snb[l_ac].tc_snb42,  
                                   tc_snb43=g_tc_snb[l_ac].tc_snb43,  
                                   tc_snb44=g_tc_snb[l_ac].tc_snb44,  
                                   tc_snb12=g_tc_snb[l_ac].tc_snb12,
                                   tc_snb20=g_tc_snb[l_ac].tc_snb20,
                                   tc_snb30=g_tc_snb[l_ac].tc_snb30,
                                   tc_snb31=g_tc_snb[l_ac].tc_snb31,
                                   tc_snb32=g_tc_snb[l_ac].tc_snb32,
                                   tc_snb33=g_tc_snb[l_ac].tc_snb33,
                                   tc_snb34=g_tc_snb[l_ac].tc_snb34,
                                   tc_snb35=g_tc_snb[l_ac].tc_snb35,
                                   tc_snb930=g_tc_snb[l_ac].tc_snb930,
                                   tc_snbud07=g_tc_snb[l_ac].tc_snbud07               #FUN-670103
                WHERE tc_snb01=g_tc_sna.tc_sna01 AND tc_snb03=g_tc_snb_t.tc_snb03
               END IF
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","tc_snb_file",g_tc_sna.tc_sna01,g_tc_snb_t.tc_snb03,SQLCA.sqlcode,"","upd tc_snb",1)  #No.FUN-660128
                  LET g_tc_snb[l_ac].* = g_tc_snb_t.*
                  ROLLBACK WORK
               ELSE
                  MESSAGE 'UPDATE O.K'
                
	             COMMIT WORK
               END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac     #FUN-D40030 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'a' AND l_ac <= g_tc_snb.getLength() THEN #CHI-C30118 add
                  SELECT ima918,ima921 INTO g_ima918,g_ima921
                    FROM ima_file
                   WHERE ima01 = g_tc_snb[l_ac].tc_snb04
                     AND imaacti = "Y"
                  
                  
               END IF #CHI-C30118 add
               IF p_cmd='u' THEN
                  LET g_tc_snb[l_ac].* = g_tc_snb_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_tc_snb.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE t324_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac     #FUN-D40030 Add
            CLOSE t324_bcl
            COMMIT WORK
            #CKP
           #CALL g_tc_snb.deleteElement(g_rec_b+1)   #FUN-D40030 Mark
 
    #CHI-C30118---add---START 回寫批序料號資料
        AFTER INPUT
          
    #CHI-C30118---add---END
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(tc_snb03) AND l_ac > 1 THEN
                LET g_tc_snb[l_ac].* = g_tc_snb[l_ac-1].*
                LET g_tc_snb[l_ac].tc_snb03 = NULL
                NEXT FIELD tc_snb03
            END IF
 
        ON ACTION controlp
           CASE WHEN INFIELD(tc_snb20)    #Run Card
                    IF p_cmd != 'a' THEN 
                        CALL q_shm2(FALSE,TRUE,'','')   
                           RETURNING g_qryparam.multiret
                      LET g_tc_snb[l_ac].tc_snb20 = g_qryparam.multiret
                      DISPLAY BY NAME g_tc_snb[l_ac].tc_snb20
                      NEXT FIELD tc_snb20
                    ELSE 
                      CALL q_shm2(TRUE,TRUE,'','') RETURNING g_multi_tc_snb20
                      IF NOT cl_null(g_multi_tc_snb20) THEN 
                        
                         CALL t324_b_fill(" 1=1")
                         CALL t324_b()
                         EXIT INPUT 
                      END IF 
                   END IF 
                      #end----mark by guanyao160805
               WHEN INFIELD(tc_snb17)
                    CALL q_qcf(FALSE,TRUE,g_tc_snb[l_ac].tc_snb17,'2') RETURNING g_tc_snb[l_ac].tc_snb17
                    DISPLAY BY NAME g_tc_snb[l_ac].tc_snb17
                    NEXT FIELD tc_snb17
                WHEN INFIELD(tc_snb11)    #工單單號
                     CALL cl_init_qry_var()
                     LET g_qryparam.construct ="Y"
                     LET g_qryparam.form ="q_sfb01"
                     LET g_qryparam.default1 = g_tc_snb[l_ac].tc_snb11
                     CALL cl_create_qry() RETURNING g_tc_snb[l_ac].tc_snb11
                      DISPLAY BY NAME g_tc_snb[l_ac].tc_snb11     #No.MOD-490371
                     NEXT FIELD tc_snb11
               
                WHEN INFIELD(tc_snb30) #單位
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_tc_snb[l_ac].tc_snb30
                     CALL cl_create_qry() RETURNING g_tc_snb[l_ac].tc_snb30
                     DISPLAY BY NAME g_tc_snb[l_ac].tc_snb30
                     NEXT FIELD tc_snb30
 
                WHEN INFIELD(tc_snb33) #單位
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_tc_snb[l_ac].tc_snb33
                     CALL cl_create_qry() RETURNING g_tc_snb[l_ac].tc_snb33
                     DISPLAY BY NAME g_tc_snb[l_ac].tc_snb33
                     NEXT FIELD tc_snb33
              
                  
                WHEN INFIELD(tc_snb44)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_azf01a"                 #No.FUN-930145
                  LET g_qryparam.default1 = g_tc_snb[l_ac].tc_snb44
                  LET g_qryparam.arg1 = 'C'                       #No.FUN-930145  
                  CALL cl_create_qry() RETURNING g_tc_snb[l_ac].tc_snb44
                  DISPLAY BY NAME g_tc_snb[l_ac].tc_snb44
                  NEXT FIELD tc_snb44  
           END CASE
 
        ON ACTION gen_detail
           CALL t324_y_b()
           EXIT INPUT
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
    END INPUT
 
    UPDATE tc_sna_file SET tc_snamodu = g_user,tc_snadate = g_today
     WHERE tc_sna01 = g_tc_sna.tc_sna01
 
    CLOSE t324_bcl
    COMMIT WORK
    IF cl_null(g_tc_sna.tc_sna01) THEN RETURN END IF  #add by guanyao160806
    CALL t324_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t324_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_tc_sna.tc_sna01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM tc_sna_file ",
                  "  WHERE tc_sna01 LIKE '",l_slip,"%' ",
                  "    AND tc_sna01 > '",g_tc_sna.tc_sna01,"'"
      PREPARE t324_pb1 FROM l_sql 
      EXECUTE t324_pb1 INTO l_cnt 
      
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
        #CALL t324_x()  #CHI-D20010
         CALL t324_x(1) #CHI-D20010
         CALL t324_show()
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM tc_sna_file WHERE tc_sna01 = g_tc_sna.tc_sna01
         INITIALIZE g_tc_sna.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION

 
#--->工單相關資料顯示於劃面
FUNCTION  t324_sfb01(p_ac)
   DEFINE l_ima02   LIKE ima_file.ima02,
          l_ima021  LIKE ima_file.ima021,
          l_ima25   LIKE ima_file.ima25,
          l_ima35   LIKE ima_file.ima35,
          l_ima36   LIKE ima_file.ima36,
          l_ima55   LIKE ima_file.ima55,
          l_ima158  LIKE ima_file.ima158,  #FUN-A90057
          l_tc_snb09   LIKE tc_snb_file.tc_snb09,
          l_qcf091  LIKE qcf_file.qcf091,
          l_smydesc LIKE smy_file.smydesc,
          l_cnt     LIKE type_file.num5,    #No.FUN-680121 SMALLINT
          l_d2      LIKE type_file.chr20,   #No.FUN-680121 VARCHAR(15),
          l_d4      LIKE type_file.chr20,   #No.FUN-680121 VARCHAR(20),
          l_no      LIKE oay_file.oayslip,  #No.FUN-680121 VARCHAR(05),            #No.FUN-550067
          l_status  LIKE type_file.num10,   #No.FUN-680121 INTEGER,
          p_ac      LIKE type_file.num5     #No.FUN-680121 SMALLINT
 
   DEFINE l_ecm012  LIKE ecm_file.ecm012    #FUN-A60076
   DEFINE l_ecm03   LIKE ecm_file.ecm03     #FUN-A60076   
   DEFINE l_shm18   LIKE shm_file.shm18     #FUN-A90057

    LET g_errno = ''
    INITIALIZE g_sfb.* TO NULL
 
    LET l_ima02=' '
    LET l_ima021=' '
    LET l_ima25=' '
    LET l_ima35=' '
    LET l_ima36=' '
    LET l_ima55=' '
    
 
    SELECT sfb_file.* INTO g_sfb.* FROM sfb_file
     WHERE sfb01=g_tc_snb[p_ac].tc_snb11
    IF SQLCA.sqlcode THEN
       LET l_status=SQLCA.sqlcode
    ELSE
       LET l_status=0
    END IF

    #str----add by guanyao160907
    IF cl_null(g_sfb.sfbud05) THEN 
       LET g_sfb.sfbud05 = 'N'
    END IF 
    IF g_sfb.sfbud05 = 'Y' THEN 
       LET g_sma.sma73 = 'N'
    ELSE 
       SELECT DISTINCT sma73 INTO g_sma.sma73 FROM sma_file 
    END IF 
    #end----add by guanyao160907
 
# check W/O 是否存在對應之FQC單中 --
   IF NOT cl_null(g_tc_snb[p_ac].tc_snb17) AND g_sma.sma896='Y' THEN
      LET l_qcf091 = 0
      SELECT qcf091 INTO l_qcf091 FROM qcf_file
       WHERE qcf01 = g_tc_snb[p_ac].tc_snb17
         AND qcf03 = g_tc_snb[p_ac].tc_snb20
         AND qcf09 <> '2'                 #NO:6872
         AND qcf14 = 'Y'
      IF SQLCA.sqlcode THEN
         LET g_errno = 'asf-732'
         RETURN
      ELSE
         IF cl_null(l_qcf091) THEN
            LET l_qcf091 = 0
         END IF
      END IF
    END IF
 
    SELECT ima02,ima021,ima35,ima36,ima55,ima158  #FUN-A90057
      INTO l_ima02,l_ima021,l_ima35,l_ima36,l_ima55,l_ima158 FROM ima_file  #FUN-A90057
    WHERE ima01 = g_sfb.sfb05
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","ima_file",g_sfb.sfb05,"",SQLCA.sqlcode,"","sel ima:",1)  #No.FUN-660128
       LET l_status = SQLCA.sqlcode
   ##Add No.FUN-AA0082  #Mark No.FUN-AB0054 此处不做判断，交予单据审核时控管
   #ELSE
   #   IF NOT s_chk_ware(l_ima35) THEN  #检查仓库是否属于当前门店
   #      LET l_ima35 = ' '
   #      LET l_ima36 = ' '
   #   END IF
   ##End Add No.FUN-AA0082
    END IF
 
    LET g_errno=' '
    CASE
       WHEN l_status = NOTFOUND
            LET g_errno = 'mfg9005'
            INITIALIZE g_sfb.* TO NULL
            LET l_ima02=' '
            LET l_ima021=' '
            LET l_ima35=' '
            LET l_ima36=' '
            LET l_ima55=' '
       WHEN g_sfb.sfbacti='N' LET g_errno = '9028'
       WHEN g_argv='0' AND g_sfb.sfb06 IS NULL LET g_errno = 'asf-394'
       WHEN g_sfb.sfb04<'2' OR   g_sfb.sfb28='3'
            LET g_errno='mfg9006'
       WHEN g_sfb.sfb04 ='8'
            LET g_errno='mfg3430'
       OTHERWISE
            LET g_errno = l_status USING '-------'
    END CASE
 
    IF g_sfb.sfb02 = 7 THEN    #委外工單
       LET g_errno='mfg9185'
    END IF
 
    IF g_sfb.sfb02 = 11 THEN    #拆件式工單
       LET g_errno='asf-709'
    END IF

   #FUN-D70008---add---str---
    IF cl_null(g_errno) AND g_sma.sma73 = 'Y' THEN   #add g_sma.sma73 by guanyao160902
       IF g_sfb.sfb04 < '4' AND g_sfb.sfb39 !='2' THEN
          LET g_errno='asf-570'
       END IF
    END IF
   #FUN-D70008---add---end---

    LET g_tc_snb[p_ac].tc_snb04 = g_sfb.sfb05
 {
    IF g_sfb.sfb30 IS NULL OR g_sfb.sfb30 = ' ' THEN
       LET g_tc_snb[p_ac].tc_snb05 = l_ima35
    ELSE
       LET g_tc_snb[p_ac].tc_snb05 = g_sfb.sfb30
    END IF
 }
    IF g_sfb.sfb31 IS NULL OR g_sfb.sfb31 = ' ' THEN
       LET g_tc_snb[p_ac].tc_snb06 = l_ima36
    ELSE
       LET g_tc_snb[p_ac].tc_snb06 = g_sfb.sfb31
    END IF
    #FUN-A90057(S)
    IF l_ima158='Y' AND g_tc_snb[l_ac].tc_snb20 IS NOT NULL THEN
       IF (g_tc_snb[l_ac].tc_snb20 <> g_tc_snb_t.tc_snb20) OR (g_tc_snb_t.tc_snb20 IS NULL) THEN
          SELECT shm18 INTO l_shm18 FROM shm_file
           WHERE shm01 = g_tc_snb[l_ac].tc_snb20
          LET g_tc_snb[l_ac].tc_snb07 = l_shm18
          DISPLAY BY NAME g_tc_snb[l_ac].tc_snb07
       END IF
    END IF
    #FUN-A90057(E)
    LET g_tc_snb[l_ac].tc_snb41 = g_sfb.sfb27
    LET g_tc_snb[l_ac].tc_snb42 = g_sfb.sfb271
    LET g_tc_snb[l_ac].tc_snb43 = g_sfb.sfb50
    LET g_tc_snb[l_ac].tc_snb44 = g_sfb.sfb51
    IF cl_null(g_tc_snb[l_ac].tc_snb41) THEN  LET g_tc_snb[l_ac].tc_snb41 = ' ' END IF
    IF cl_null(g_tc_snb[l_ac].tc_snb42) THEN  LET g_tc_snb[l_ac].tc_snb42 = ' ' END IF 
    IF cl_null(g_tc_snb[l_ac].tc_snb43) THEN  LET g_tc_snb[l_ac].tc_snb43 = ' ' END IF
    IF cl_null(g_tc_snb[l_ac].tc_snb44) THEN  LET g_tc_snb[l_ac].tc_snb44 = ' ' END IF
    DISPLAY BY NAME g_tc_snb[l_ac].tc_snb41,g_tc_snb[l_ac].tc_snb42,
                    g_tc_snb[l_ac].tc_snb43,g_tc_snb[l_ac].tc_snb44  
 
    LET g_tc_snb[p_ac].ima02 = l_ima02
    LET g_tc_snb[p_ac].ima021 = l_ima021
 
    CALL s_schdat_max_sgm03(g_tc_snb[p_ac].tc_snb20) RETURNING l_ecm012,l_ecm03    #FUN-A60076 
    SELECT sgm58 INTO g_tc_snb[p_ac].tc_snb08 FROM sgm_file
     WHERE sgm01=g_tc_snb[p_ac].tc_snb20
     #AND sgm03=(SELECT MAX(sgm03) FROM sgm_file       #FUN-A60076  mark
     #            WHERE sgm01=g_tc_snb[p_ac].tc_snb20)       #FUN-A60076  mark  
      AND sgm03 = l_ecm03            #FUN-A60076
      AND sgm012 = l_pmn012          #FUN-A60076 
    DISPLAY BY NAME g_tc_snb[p_ac].tc_snb04
    DISPLAY BY NAME g_tc_snb[p_ac].tc_snb05
    DISPLAY BY NAME g_tc_snb[p_ac].tc_snb06
    DISPLAY BY NAME g_tc_snb[p_ac].ima02
    DISPLAY BY NAME g_tc_snb[p_ac].ima021
 
    IF g_sma.sma896 = 'Y' AND g_smy.smy57[2,2] = 'Y' THEN
       SELECT SUM(tc_snb09) INTO l_tc_snb09 FROM tc_snb_file,tc_sna_file
        WHERE tc_snb17 = g_tc_snb[l_ac].tc_snb17
          AND (( tc_snb01 != g_tc_sna.tc_sna01 ) OR
               ( tc_snb01 = g_tc_sna.tc_sna01 AND tc_snb03 != g_tc_snb[l_ac].tc_snb03 ))
          AND tc_snb01 = tc_sna01
          AND tc_snaconf !='X' #FUN-660137
       IF cl_null(l_tc_snb09) THEN
          LET l_tc_snb09 = 0
       END IF
       LET g_tc_snb[p_ac].tc_snb09= l_qcf091 - l_tc_snb09
   END IF
 
    IF g_sma.sma115='Y' THEN
       CALL t324_sel_ima()
       CALL t324_set_du_by_origin(g_tc_snb[l_ac].tc_snb04,g_tc_snb[l_ac].tc_snb08,
                                  g_tc_snb[l_ac].tc_snb09,g_tc_snb[l_ac].tc_snb05,
                                  g_tc_snb[l_ac].tc_snb06,g_tc_snb[l_ac].tc_snb07)
            RETURNING g_tc_snb[p_ac].tc_snb30,g_tc_snb[p_ac].tc_snb31,g_tc_snb[p_ac].tc_snb32,
                      g_tc_snb[p_ac].tc_snb33,g_tc_snb[p_ac].tc_snb34,g_tc_snb[p_ac].tc_snb35
       DISPLAY BY NAME g_tc_snb[p_ac].tc_snb30
       DISPLAY BY NAME g_tc_snb[p_ac].tc_snb31
       DISPLAY BY NAME g_tc_snb[p_ac].tc_snb32
       DISPLAY BY NAME g_tc_snb[p_ac].tc_snb33
       DISPLAY BY NAME g_tc_snb[p_ac].tc_snb34
       DISPLAY BY NAME g_tc_snb[p_ac].tc_snb35
    END IF
 
    DISPLAY BY NAME g_tc_snb[p_ac].tc_snb04
    DISPLAY BY NAME g_tc_snb[p_ac].ima02
    DISPLAY BY NAME g_tc_snb[p_ac].ima021
    DISPLAY BY NAME g_tc_snb[p_ac].tc_snb05
    DISPLAY BY NAME g_tc_snb[p_ac].tc_snb06
    DISPLAY BY NAME g_tc_snb[p_ac].tc_snb07
    DISPLAY BY NAME g_tc_snb[p_ac].tc_snb08
    DISPLAY BY NAME g_tc_snb[p_ac].tc_snb09
  
    LET g_tc_snb[l_ac].tc_snb930=g_sfb.sfb98 #FUN-670103
    LET g_tc_snb[l_ac].gem02c=s_costcenter_desc(g_tc_snb[l_ac].tc_snb930) #FUN-670103
    DISPLAY BY NAME g_tc_snb[p_ac].tc_snb930 #FUN-670103
    DISPLAY BY NAME g_tc_snb[p_ac].gem02c #FUN-670103
 
END FUNCTION
 
#--->工單相關資料顯示於劃面
FUNCTION  t324_sfb011(p_ac)
   DEFINE l_ima02   LIKE ima_file.ima02,
          l_ima021  LIKE ima_file.ima021,
          l_ima25   LIKE ima_file.ima25,
          l_ima35   LIKE ima_file.ima35,
          l_ima36   LIKE ima_file.ima36,
          l_ima55   LIKE ima_file.ima55,
          l_tc_snb09   LIKE tc_snb_file.tc_snb09,
          l_smydesc LIKE smy_file.smydesc,
          l_cnt     LIKE type_file.num5,    #No.FUN-680121 SMALLINT
          l_d2      LIKE type_file.chr20,   #No.FUN-680121 VARCHAR(15),
          l_d4      LIKE type_file.chr20,   #No.FUN-680121 VARCHAR(20),
          l_no      LIKE oay_file.oayslip,  #No.FUN-680121 VARCHAR(05),             #No.FUN-550067
          l_status  LIKE type_file.num10,   #No.FUN-680121 INTEGER,
          p_ac      LIKE type_file.num5     #No.FUN-680121 SMALLINT
   DEFINE l_ecm03   LIKE ecm_file.ecm03     #FUN-A60076 
   DEFINE l_ecm012  LIKE ecm_file.ecm012    #FUN-A60076
   
    INITIALIZE g_sfb.* TO NULL
    LET l_ima02=' '
    LET l_ima021=' '
    LET l_ima35=' '
    LET l_ima36=' '
    LET l_ima55=' '
    LET g_min_set = 0
    LET l_tc_snb09 = 0
    SELECT sfb_file.* INTO g_sfb.* FROM  sfb_file
     WHERE sfb01=g_tc_snb[p_ac].tc_snb11
    IF SQLCA.sqlcode THEN
       LET l_status=SQLCA.sqlcode
    ELSE
       LET l_status=0
    END IF
 
    SELECT ima02,ima021,ima35,ima36,ima55
      INTO l_ima02,l_ima021,l_ima35,l_ima36,l_ima55 FROM ima_file
     WHERE ima01 = g_sfb.sfb05
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","ima_file",g_sfb.sfb05,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
       LET l_status = SQLCA.sqlcode
   ##Add No.FUN-AA0082   #Mark No.FUN-AB0054 此处不做判断，交予单据审核时控管
   #ELSE
   #   IF NOT s_chk_ware(l_ima35) THEN  #检查仓库是否属于当前门店
   #      LET l_ima35 = ' '
   #      LET l_ima36 = ' '
   #   END IF
   ##End Add No.FUN-AA0082
    END IF
 
    LET g_errno=' '
    CASE
       WHEN l_status = NOTFOUND
            LET g_errno = 'mfg9005'
            INITIALIZE g_sfb.* TO NULL
            LET l_ima02=' '
            LET l_ima021=' '
            LET l_ima35=' '
            LET l_ima36=' '
            LET l_ima55=' '
       WHEN g_sfb.sfbacti='N' LET g_errno = '9028'
       WHEN g_argv='0' AND g_sfb.sfb06 IS NULL LET g_errno = 'asf-394'
       WHEN g_sfb.sfb04<'2' OR   g_sfb.sfb28='3'
            LET g_errno='mfg9006'
       OTHERWISE
            LET g_errno = l_status USING '-------'
    END CASE
 
    LET g_tc_snb[p_ac].tc_snb04 = g_sfb.sfb05
 
    IF g_argv='2' THEN
       IF g_sfb.sfb30 IS NULL OR g_sfb.sfb30 = ' ' THEN
          LET g_tc_snb[p_ac].tc_snb05 = l_ima35
       ELSE
          LET g_tc_snb[p_ac].tc_snb05 = g_sfb.sfb30
       END IF
       IF g_sfb.sfb31 IS NULL OR g_sfb.sfb31 = ' ' THEN
          LET g_tc_snb[p_ac].tc_snb06 = l_ima36
       ELSE
          LET g_tc_snb[p_ac].tc_snb06 = g_sfb.sfb31
       END IF
       LET g_tc_snb[p_ac].tc_snb09 = g_sfb.sfb09
    END IF
 
    LET g_tc_snb[p_ac].ima02 = l_ima02
    LET g_tc_snb[p_ac].ima021= l_ima021
    CALL s_schdat_max_sgm03(g_tc_snb[p_ac].tc_snb20) RETURNING l_ecm012,l_ecm03    #FUN-A60076  
    SELECT sgm58 INTO g_tc_snb[p_ac].tc_snb08 FROM sgm_file
       WHERE sgm01=g_tc_snb[p_ac].tc_snb20
        #AND sgm03=(SELECT MAX(sgm03) FROM sgm_file  #FUN-A60076 
        #            WHERE sgm01=g_tc_snb[p_ac].tc_snb20)  #FUN-A60076
         AND sgm012 = l_ecm012  #FUN-A60076	  
         AND sgm03 = l_ecm03    #FUN-A60076
 
    IF g_sma.sma115='Y' THEN
       CALL t324_sel_ima()
       CALL t324_set_du_by_origin(g_tc_snb[l_ac].tc_snb04,g_tc_snb[l_ac].tc_snb08,
                                  g_tc_snb[l_ac].tc_snb09,g_tc_snb[l_ac].tc_snb05,
                                  g_tc_snb[l_ac].tc_snb06,g_tc_snb[l_ac].tc_snb07)
            RETURNING g_tc_snb[p_ac].tc_snb30,g_tc_snb[p_ac].tc_snb31,g_tc_snb[p_ac].tc_snb32,
                      g_tc_snb[p_ac].tc_snb33,g_tc_snb[p_ac].tc_snb34,g_tc_snb[p_ac].tc_snb35
       DISPLAY BY NAME g_tc_snb[p_ac].tc_snb30
       DISPLAY BY NAME g_tc_snb[p_ac].tc_snb31
       DISPLAY BY NAME g_tc_snb[p_ac].tc_snb32
       DISPLAY BY NAME g_tc_snb[p_ac].tc_snb33
       DISPLAY BY NAME g_tc_snb[p_ac].tc_snb34
       DISPLAY BY NAME g_tc_snb[p_ac].tc_snb35
    END IF
END FUNCTION
 
FUNCTION t324_b_else()
     IF g_tc_snb[l_ac].tc_snb05 IS NULL THEN LET g_tc_snb[l_ac].tc_snb05 =' ' END IF
     IF g_tc_snb[l_ac].tc_snb06 IS NULL THEN LET g_tc_snb[l_ac].tc_snb06 =' ' END IF
     IF g_tc_snb[l_ac].tc_snb07 IS NULL THEN LET g_tc_snb[l_ac].tc_snb07 =' ' END IF
END FUNCTION
 
FUNCTION t324_delall()
   SELECT COUNT(*) INTO g_cnt FROM tc_snb_file
    WHERE tc_snb01 = g_tc_sna.tc_sna01
   IF g_cnt = 0 THEN 			# 未輸入單身資料, 則取消單頭資料
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM tc_sna_file WHERE tc_sna01 = g_tc_sna.tc_sna01
   END IF
END FUNCTION
 
FUNCTION t324_y_b()
 
   IF g_tc_sna.tc_sna00 != '0' THEN
 
      OPEN WINDOW t324_y_w WITH FORM "asf/42f/cect324y"
            ATTRIBUTE (STYLE = g_win_style CLIPPED)
      CALL cl_ui_locale("cect324y")
 
      CALL t324_y_b1()
 
      CLOSE WINDOW t324_y_w
 
   END IF
 
   CALL t324_b_fill(' 1=1')
   CALL t324_b()
 
END FUNCTION
 
FUNCTION t324_y_b1()
   DEFINE l_sql,l_wc            LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(500)
   DEFINE i,j,k,l_i             LIKE type_file.num10   #No.FUN-680121 INTEGER
   DEFINE in_qty_t,qty_t        LIKE type_file.num10   #No.FUN-680121 INTEGER
   DEFINE l_shm DYNAMIC ARRAY OF RECORD
          shm05      LIKE shm_file.shm05,
          shm01      LIKE shm_file.shm01,
          seq        LIKE type_file.num5,    #No.FUN-680121 SMALLINT,
          qty        LIKE type_file.num10,   #No.FUN-680121 INTEGER,
          y          LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1),
          in_qty     LIKE type_file.num10,   #No.FUN-680121 INTEGER,
          sfb98 LIKE sfb_file.sfb98 #FUN-670103
          END RECORD
   DEFINE l_shm012     LIKE shm_file.shm012
   DEFINE l_tc_snb RECORD LIKE tc_snb_file.*
   DEFINE partno	LIKE sfb_file.sfb05  #No.MOD-490217
   DEFINE tot_qty,qty2  LIKE type_file.num10    #No.FUN-680121 INTEGER
   DEFINE seq1		LIKE type_file.num5     #No.FUN-680121 SMALLINT
 
   DEFINE ware             LIKE img_file.img02,
          loc              LIKE img_file.img03,
          lot	           LIKE img_file.img04,
 
          l_allow_insert   LIKE type_file.num5,                #可新增否  #No.FUN-680121 SMALLINT
          l_allow_delete   LIKE type_file.num5                 #可刪除否  #No.FUN-680121 SMALLINT
   DEFINE l_ecm03          LIKE ecm_file.ecm03    #FUN-A60076
   DEFINE l_ecm012         LIKE ecm_file.ecm012   #FUN-A60076
   DEFINE l_flag          LIKE type_file.chr1    #FUN-B70074
 
   LET seq1=0
   INPUT BY NAME partno,tot_qty,seq1,ware,loc,lot WITHOUT DEFAULTS
      AFTER FIELD partno
        IF partno IS NULL THEN NEXT FIELD partno END IF

      #Add No.FUN-AA0082
      AFTER FIELD ware
        IF NOT cl_null(ware) THEN
           IF NOT s_chk_ware(ware) THEN  #检查仓库是否属于当前门店
              NEXT FIELD ware
           END IF
        END IF
      #End Add No.FUN-AA0082

      AFTER FIELD loc
        IF ware IS NOT NULL OR loc IS NOT NULL THEN
           IF NOT s_chksmz('', g_tc_sna.tc_sna01,ware,loc) THEN
              NEXT FIELD ware
           END IF
        END IF

      ON ACTION controlp
        CASE WHEN INFIELD(partno)    #
#FUN-AB0025---------mod---------------str----------------
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form ="q_ima"
#                 LET g_qryparam.default1 = partno
#                 CALL cl_create_qry() RETURNING partno
                  CALL q_sel_ima(FALSE, "q_ima","",partno,"","","","","",'' )
                    RETURNING partno
#FUN-AB0025--------mod---------------end----------------
                  DISPLAY BY NAME partno
                  NEXT FIELD partno
        END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT
 
   IF INT_FLAG THEN LET INT_FLAG=0 END IF
 
   IF g_tc_sna.tc_sna00='1' THEN
      LET l_sql="SELECT shm05,shm01,sgm03,shm08-shm09,'','',sfb98,shm13", #FUN-670103
                "  FROM shm_file,sfb_file,sgm_file",
                " WHERE shm05 MATCHES '",partno CLIPPED,"'",
                "   AND shm012=sfb01",
                "   AND shm01=sgm01",
                "   AND shm08 > shm09 AND sfb04<'8'"
                IF NOT cl_null(seq1) THEN
                   LET l_sql=l_sql CLIPPED, " AND sgm03=",seq1
                END IF
                LET l_sql=l_sql CLIPPED, " ORDER BY shm05,shm01,sgm03"
   END IF
 
   IF g_tc_sna.tc_sna00='2' THEN
      LET l_sql="SELECT sfb05,sfb01,0,sfb09,'','',sfb98,sfb25",  #FUN-670103
                "  FROM sfb_file",
                " WHERE sfb09>0 AND sfb04<'8'",
                "   AND sfb05 MATCHES '",partno CLIPPED,"'",
                " ORDER BY sfb05,sfb25 DESC"
   END IF
 
   PREPARE t324_y_b1_p FROM l_sql
   DECLARE t324_y_b1_c CURSOR FOR t324_y_b1_p
   LET i=1
   LET qty2=tot_qty
 
   MESSAGE "Waiting..."
   FOREACH t324_y_b1_c INTO l_shm[i].*,l_shm012
      IF g_tc_sna.tc_sna00 = '1' THEN
         IF l_shm[i].qty<=0 THEN CONTINUE FOREACH END IF
      END IF
      IF qty2>0 THEN
         LET l_shm[i].y='Y'
         IF qty2 > l_shm[i].qty THEN
            LET l_shm[i].in_qty=l_shm[i].qty
         ELSE
            LET l_shm[i].in_qty=qty2
         END IF
         LET qty2 = qty2 - l_shm[i].in_qty
      END IF      
      LET i=i+1
 
   END FOREACH
 
   MESSAGE ""
 
   LET l_i = i - 1
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY l_shm WITHOUT DEFAULTS FROM s_shm.*
         ATTRIBUTE(COUNT=l_i,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
        CALL fgl_set_arr_curr(l_ac)
 
      BEFORE ROW
        LET i=ARR_CURR()
 
      BEFORE FIELD y
        LET qty_t=0 LET in_qty_t=0
        FOR k=1 TO l_shm.getLength()
           IF l_shm[k].qty > 0 THEN LET qty_t = qty_t+l_shm[k].qty END IF
           IF l_shm[k].y ='Y' AND l_shm[k].in_qty IS NOT NULL THEN
              LET in_qty_t = in_qty_t+l_shm[k].in_qty
           END IF
        END FOR
        DISPLAY BY NAME qty_t,in_qty_t
 
      BEFORE FIELD in_qty
        IF l_shm[i].y IS NULL OR l_shm[i].y<>'Y'  OR l_shm[i].shm01 IS NULL THEN
           LET l_shm[i].in_qty=NULL
           DISPLAY l_shm[i].in_qty TO s_sfb[j].in_qty
           NEXT FIELD PREVIOUS
        END IF
 
        IF l_shm[i].in_qty IS NULL OR l_shm[i].in_qty = 0 THEN
           LET l_shm[i].in_qty = l_shm[i].qty
           DISPLAY l_shm[i].in_qty TO s_sfb[j].in_qty
        END IF
 
      AFTER FIELD in_qty
        IF l_shm[i].in_qty > l_shm[i].qty THEN
           CALL cl_err('','asf-550',0) NEXT FIELD in_qty
        END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT
 
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
   IF NOT cl_sure(0,0) THEN RETURN END IF
 
   INITIALIZE l_tc_snb.* TO NULL
 
   SELECT MAX(tc_snb03) INTO l_tc_snb.tc_snb03 FROM tc_snb_file WHERE tc_snb01=g_tc_sna.tc_sna01
   IF l_tc_snb.tc_snb03 IS NULL THEN LET l_tc_snb.tc_snb03 = 0 END IF
   FOR k=1 TO l_shm.getLength()
      IF l_shm[k].shm01 IS NULL THEN
         CONTINUE FOR
      END IF
      IF l_shm[k].in_qty IS NULL OR l_shm[k].in_qty<=0 THEN
         CONTINUE FOR
      END IF
      LET l_tc_snb.tc_snb01=g_tc_sna.tc_sna01
      LET l_tc_snb.tc_snb03=l_tc_snb.tc_snb03+1
      LET l_tc_snb.tc_snb04=l_shm[k].shm05
      LET l_tc_snb.tc_snb05=ware
      LET l_tc_snb.tc_snb06=loc
      LET l_tc_snb.tc_snb07=lot
      LET l_tc_snb.tc_snbplant = g_plant #FUN-980008 add
      LET l_tc_snb.tc_snblegal = g_legal #FUN-980008 add
      CALL s_schdat_max_sgm03(l_tc_snb.tc_snb20) RETURNING l_ecm012,l_ecm03   #FUN-A60076
      SELECT sgm58 INTO l_tc_snb.tc_snb08 FROM sgm_file
       WHERE sgm01=l_tc_snb.tc_snb20
        #AND sgm03=(SELECT MAX(sgm03) FROM sgm_file   #FUN-A60076   mark
        #            WHERE sgm01=l_tc_snb.tc_snb20)         #FUN-A60076   mark
         AND sgm03 = l_ecm03     #FUN-A60076 
         AND sgm012 = l_ecm012   #FUN-A60076      
      LET l_tc_snb.tc_snb09=l_shm[k].in_qty
      LET l_tc_snb.tc_snb09 = s_digqty(l_tc_snb.tc_snb09,l_tc_snb.tc_snb08)   #No.FUN-BB0086
      LET l_tc_snb.tc_snb11=l_shm012
       
      IF g_sma.sma115='Y' THEN
         CALL t324_sel_ima()
         CALL t324_set_du_by_origin(l_tc_snb.tc_snb04,l_tc_snb.tc_snb08,
                                    l_tc_snb.tc_snb09,l_tc_snb.tc_snb05,
                                    l_tc_snb.tc_snb06,l_tc_snb.tc_snb07)
              RETURNING l_tc_snb.tc_snb30,l_tc_snb.tc_snb31,l_tc_snb.tc_snb32,
                        l_tc_snb.tc_snb33,l_tc_snb.tc_snb34,l_tc_snb.tc_snb35
      END IF
      LET l_tc_snb.tc_snb930=l_shm[k].sfb98 #FUN-670103
      
      IF g_success = 'Y' THEN
         INSERT INTO tc_snb_file VALUES(l_tc_snb.*)

      END IF
 
      MESSAGE 'ins tc_snb:',l_tc_snb.tc_snb03,l_tc_snb.tc_snb11,STATUS
 
   END FOR
 
END FUNCTION
 
FUNCTION t324_b_askkey()
DEFINE l_wc2           LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON tc_snb03,tc_snb20,tc_snb11,tc_snb04,tc_snb08,tc_snb05,tc_snb06,
                       tc_snb07,tc_snb09,tc_snb41,tc_snb42,tc_snb43,tc_snb44,tc_snb12  #FUN-810045 add tc_snb41-44
            FROM s_tc_snb[1].tc_snb03,s_tc_snb[1].tc_snb20,s_tc_snb[1].tc_snb11,
                 s_tc_snb[1].tc_snb04,s_tc_snb[1].tc_snb08,s_tc_snb[1].tc_snb05,
                 s_tc_snb[1].tc_snb06,s_tc_snb[1].tc_snb07,s_tc_snb[1].tc_snb09,
                 s_tc_snb[1].tc_snb41,s_tc_snb[1].tc_snb42,s_tc_snb[1].tc_snb43,s_tc_snb[1].tc_snb44,  #FUN-810045
                 s_tc_snb[1].tc_snb12
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL t324_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t324_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(200)
 DEFINE l_tc_snbud07      LIKE tc_snb_file.tc_snbud07
 DEFINE l_x            LIKE type_file.num5   #add by guanyao160901
    LET g_sql = "SELECT tc_snb03,tc_snb17,tc_snb20,tc_snb11,tc_snb46,qcl02,tc_snb47,tc_snb04,ima02,ima021,",  #FUN-BC0104 add tc_snb46,qcl02,tc_snb47
                "tc_snb08,tc_snb05,tc_snb06,tc_snb07,tc_snb09,tc_snb33,tc_snb34,",
                "tc_snb35,tc_snb30,tc_snb31,tc_snb32,tc_snb41,tc_snb42,tc_snb43,tc_snb44,tc_snb12,tc_snb930,'',tc_snbud07,''",  #FUN-670103  #FUN-810045
                " FROM tc_snb_file LEFT OUTER JOIN ima_file ON tc_snb04=ima01 ",     #NO.TQC-9A0134 mod
                "               LEFT OUTER JOIN qcl_file ON tc_snb46=qcl01 ",    #FUN-BC0104
                " WHERE tc_snb01 ='",g_tc_sna.tc_sna01,"' AND ",p_wc2 CLIPPED,  #單頭    #No.TQC-9A0134 mod
                " ORDER BY tc_snb03"
    PREPARE t324_pb FROM g_sql
    DECLARE tc_snb_curs CURSOR FOR t324_pb
 
    CALL g_tc_snb.clear()
 
    LET g_cnt = 1
    FOREACH tc_snb_curs INTO g_tc_snb[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
          # add by hlf07751
     #  IF g_tc_snb[g_cnt].tc_snbud07 IS NULL THEN 
       LET l_tc_snbud07 =''
       #str-----mark by guanyao160907
       #SELECT oeb13 INTO l_tc_snbud07 FROM oeb_file 
       #   WHERE oeb01=(SELECT sfb22 FROM sfb_file WHERE sfb01=g_tc_snb[g_cnt].tc_snb11) AND
       #   oeb03=(SELECT sfb221 FROM sfb_file WHERE sfb01=g_tc_snb[g_cnt].tc_snb11)
       #end-----mark by guanyao160907
       #str-----add by guanyao160907
       SELECT oeb13 INTO l_tc_snbud07 FROM oeb_file,sfb_file 
        WHERE oeb01 = sfb22
          AND oeb03 = sfb221
          AND sfb01 = g_tc_snb[g_cnt].tc_snb11
       #end-----add by guanyao160907
       LET  g_tc_snb[g_cnt].tc_snbud07=l_tc_snbud07
       IF g_tc_snb[g_cnt].tc_snbud07!=l_tc_snbud07 THEN  
          UPDATE tc_snb_file SET 
                tc_snbud07=l_tc_snbud07       
           WHERE tc_snb01=g_tc_sna.tc_sna01 AND tc_snb03 =g_tc_snb[g_cnt].tc_snb03
          IF STATUS OR SQLCA.SQLERRD[3]=0  THEN
              
          END IF
       END IF 
      # END IF 
       #str----add by guanyao160901
       IF NOT cl_null(g_tc_snb[g_cnt].tc_snb11) THEN 
          CALL s_minp(g_tc_snb[g_cnt].tc_snb11,g_sma.sma73,0,'','','',g_tc_sna.tc_sna02)  #FUN-C70037 
           RETURNING l_x,g_tc_snb[g_cnt].l_min # default 時不考慮超限率
          IF l_x !=0  THEN
            LET g_tc_snb[g_cnt].l_min = 0
          END IF
       END IF 
       #end----add by guanyao160901
       LET g_tc_snb[g_cnt].gem02c=s_costcenter_desc(g_tc_snb[g_cnt].tc_snb930) #FUN-670103
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    
       
    END FOREACH
    CALL g_tc_snb.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
    #FUN-B30170 add begin-------------------------
    
    LET g_rec_b1 = g_cnt - 1
    #FUN-B30170 add -end--------------------------
END FUNCTION
 
FUNCTION t324_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   #FUN-B30170 add -----------begin-------------
  DIALOG ATTRIBUTE(UNBUFFERED)
     DISPLAY ARRAY g_tc_snb TO s_tc_snb.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
         AFTER DISPLAY
         CONTINUE DIALOG   #因為外層是DIALOG
      END DISPLAY
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
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
         CALL t324_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t324_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t324_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t324_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t324_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION detail
         LET g_action_choice="detail"
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
         CALL t324_mu_ui()   #FUN-610006
         CALL t324_pic() #圖形顯示 #FUN-660137
         EXIT DIALOG
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
    #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DIALOG
    #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DIALOG
#@    ON ACTION 庫存過帳
      ON ACTION stock_post
         LET g_action_choice="stock_post"
         EXIT DIALOG
#@    ON ACTION 過帳還原
      ON ACTION undo_post
         LET g_action_choice="undo_post"
         EXIT DIALOG
#@    ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DIALOG
      #CHI-D20010---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DIALOG 
      #CHI-D20010---end

 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DIALOG
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"  #MOD-580134
         EXIT DIALOG                #MOD-580134
  
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
##
 
      ON ACTION related_document                #No.FUN-6A0164  相關文件
         LET g_action_choice="related_document"          
         EXIT DIALOG 
 
    
      #tianry add end 

      &include "qry_string.4gl"
      
   END DIALOG
   
#   DISPLAY ARRAY g_tc_snb TO s_tc_snb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
# 
#      BEFORE DISPLAY
#         CALL cl_navigator_setting( g_curs_index, g_row_count )
# 
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
#      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
# 
#      ##########################################################################
#      # Standard 4ad ACTION
#      ##########################################################################
#        ON ACTION CONTROLS                                                                                                          
#           CALL cl_set_head_visible("","AUTO")                                                                                      
#    ON ACTION insert
#         LET g_action_choice="insert"
#         EXIT DISPLAY
#      ON ACTION query
#         LET g_action_choice="query"
#         EXIT DISPLAY
#      ON ACTION delete
#         LET g_action_choice="delete"
#         EXIT DISPLAY
#      ON ACTION modify
#         LET g_action_choice="modify"
#         EXIT DISPLAY
#      ON ACTION first
#         CALL t324_fetch('F')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
# 
#      ON ACTION previous
#         CALL t324_fetch('P')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
# 
#      ON ACTION jump
#         CALL t324_fetch('/')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
# 
#      ON ACTION next
#         CALL t324_fetch('N')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
# 
#      ON ACTION last
#         CALL t324_fetch('L')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
# 
#      ON ACTION detail
#         LET g_action_choice="detail"
#         LET l_ac = 1
#         EXIT DISPLAY
#      ON ACTION output
#         LET g_action_choice="output"
#         EXIT DISPLAY
#      ON ACTION help
#         LET g_action_choice="help"
#         EXIT DISPLAY
# 
#      ON ACTION locale
#         CALL cl_dynamic_locale()
#         CALL t324_mu_ui()   #FUN-610006
#         CALL t324_pic() #圖形顯示 #FUN-660137
#         EXIT DISPLAY
# 
#      ON ACTION exit
#         LET g_action_choice="exit"
#         EXIT DISPLAY
# 
#      ##########################################################################
#      # Special 4ad ACTION
#      ##########################################################################
#      ON ACTION controlg
#         LET g_action_choice="controlg"
#         EXIT DISPLAY
#    #@ON ACTION 確認
#      ON ACTION confirm
#         LET g_action_choice="confirm"
#         EXIT DISPLAY
#    #@ON ACTION 取消確認
#      ON ACTION undo_confirm
#         LET g_action_choice="undo_confirm"
#         EXIT DISPLAY
##@    ON ACTION 庫存過帳
#      ON ACTION stock_post
#         LET g_action_choice="stock_post"
#         EXIT DISPLAY
##@    ON ACTION 過帳還原
#      ON ACTION undo_post
#         LET g_action_choice="undo_post"
#         EXIT DISPLAY
##@    ON ACTION 作廢
#      ON ACTION void
#         LET g_action_choice="void"
#         EXIT DISPLAY
##@    ON ACTION 領料產生
#      ON ACTION gen_mat_wtdw
#         LET g_action_choice="gen_mat_wtdw"
#         EXIT DISPLAY
##@    ON ACTION 領料維護
#      ON ACTION maint_mat_wtdw
#         LET g_action_choice="maint_mat_wtdw"
#         EXIT DISPLAY
# 
#      ON ACTION accept
#         LET g_action_choice="detail"
#         LET l_ac = ARR_CURR()
#         EXIT DISPLAY
# 
#      ON ACTION cancel
#         LET INT_FLAG=FALSE 		#MOD-570244	mars
#         LET g_action_choice="exit"  #MOD-580134
#         EXIT DISPLAY                #MOD-580134
#  
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE DISPLAY
# 
#      ON ACTION exporttoexcel
#         LET g_action_choice = 'exporttoexcel'
#         EXIT DISPLAY
###
# 
#      ON ACTION related_document                #No.FUN-6A0164  相關文件
#         LET g_action_choice="related_document"          
#         EXIT DISPLAY 
# 
#      ON ACTION qry_lot
#         LET g_action_choice="qry_lot"
#         EXIT DISPLAY
# 
#      &include "qry_string.4gl"
# 
#   END DISPLAY
   #FUN-B30170 add ------------end---------------
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
 
END FUNCTION
 
 
FUNCTION t324_bp_refresh()
   DISPLAY ARRAY g_tc_snb TO s_tc_snb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
   END DISPLAY
END FUNCTION
 
 
FUNCTION t324_out()
     #str----add by guanyao160811
     IF cl_null(g_tc_sna.tc_sna01) THEN
        RETURN 
     END IF  
     --IF g_tc_sna.tc_snaconf != 'Y' THEN 
        --CALL cl_err('','csf-516',1)
        --RETURN 
     --END IF  
     #end----add by guanyao160811
     
        IF g_tc_sna.tc_snaconf = 'N' THEN 
           CALL cl_err('','csf-516',1)
        ELSE 
           LET g_wc= 'tc_sna01 = "',g_tc_sna.tc_sna01,'"'
           LET g_msg = "csfr324",  #FUN-C30085 add
                  " '",g_today CLIPPED,"' ''",
                   " '",g_lang CLIPPED,"' 'Y' '' '1'",
                   " '",g_wc CLIPPED,"' "
                  ," '1' 'N' 'N' 'Y'" 
           CALL cl_cmdrun(g_msg)
        END IF 
  
    
    
 
END FUNCTION
 
#FUNCTION t324_x()       #CHI-D20010
FUNCTION t324_x(p_type)  #CHI-D20010 
DEFINE l_tc_snb47   LIKE tc_snb_file.tc_snb47,    #FUN-BC0104
       l_tc_snb17   LIKE tc_snb_file.tc_snb17,    #FUN-BC0104
       l_tc_snb46   LIKE tc_snb_file.tc_snb46,    #FUN-BC0104
       l_tc_snb09   LIKE tc_snb_file.tc_snb09     #FUN-BC0104
DEFINE l_flag    LIKE type_file.chr1  #CHI-D20010
DEFINE p_type    LIKE type_file.chr1  #CHI-D20010

   IF s_shut(0) THEN RETURN END IF
 
   SELECT * INTO g_tc_sna.* FROM tc_sna_file WHERE tc_sna01 = g_tc_sna.tc_sna01       #MOD-660086 add
   IF cl_null(g_tc_sna.tc_sna01) THEN CALL cl_err('',-400,0) RETURN END IF   #MOD-660086 add

   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_tc_sna.tc_snaconf ='X' THEN RETURN END IF
   ELSE
      IF g_tc_sna.tc_snaconf <>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t324_cl USING g_tc_sna.tc_sna01
   IF STATUS THEN
      CALL cl_err("OPEN t324_cl:", STATUS, 1)
      CLOSE t324_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t324_cl INTO g_tc_sna.*                       #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_sna.tc_sna01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t324_cl ROLLBACK WORK RETURN
   END IF
   IF cl_null(g_tc_sna.tc_sna01) THEN CALL cl_err('',-400,0) RETURN END IF
   #-->確認不可作廢
   IF g_tc_sna.tc_snapost = 'Y' THEN CALL cl_err('','asf-812',0) RETURN END IF #FUN-660137
   IF g_tc_sna.tc_snaconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF #FUN-660137
   IF g_tc_sna.tc_snaconf = 'X' THEN  LET l_flag = 'X' ELSE LET l_flag = 'N' END IF #CHI-D20010
  #IF cl_void(0,0,g_tc_sna.tc_snaconf)   THEN #FUN-660137  #CHI-D20010
   IF cl_void(0,0,l_flag)   THEN #FUN-660137  #CHI-D20010
      LET g_chr=g_tc_sna.tc_snaconf #FUN-660137
     #IF g_tc_sna.tc_snaconf ='N' THEN #FUN-660137  #CHI-D20010
      IF p_type = 1 THEN #FUN-660137          #CHI-D20010
          LET g_tc_sna.tc_snaconf='X' #FUN-660137
      ELSE
          LET g_tc_sna.tc_snaconf='N' #FUN-660137
      END IF
      UPDATE tc_sna_file
         SET tc_snaconf=g_tc_sna.tc_snaconf, #FUN-660137
             tc_snamodu=g_user,
             tc_snadate=g_today
       WHERE tc_sna01  =g_tc_sna.tc_sna01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("upd","tc_sna_file",g_tc_sna.tc_sna01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
          LET g_tc_sna.tc_snaconf=g_chr #FUN-660137
      #FUN-C40016----------mark----------str----------
      ##FUN-BC0104---add---str---
      #ELSE
      #   DECLARE tc_snb03_cur1 CURSOR FOR SELECT tc_snb09,tc_snb17,tc_snb46,tc_snb47
      #                                   FROM tc_snb_file
      #                                  WHERE tc_snb01 = g_tc_sna.tc_sna01
      #   FOREACH tc_snb03_cur1 INTO l_tc_snb09,l_tc_snb17,l_tc_snb46,l_tc_snb47
      #      IF NOT cl_null(l_tc_snb46) THEN
      #         UPDATE qco_file SET qco20 = qco20-l_tc_snb09 WHERE qco01 = l_tc_snb17
      #                                                     AND qco02 = 0
      #                                                     AND qco04 = l_tc_snb47
      #                                                     AND qco05 = 0
      #         IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      #            CALL cl_err3("upd","qco_file",g_tc_sna.tc_sna01,"",STATUS,"","upd qco20:",1)
      #            ROLLBACK WORK
      #            RETURN
      #         END IF
      #      END IF
      #   END FOREACH
      #   UPDATE tc_snb_file SET tc_snb46 = '',tc_snb47 = ''
      #       WHERE tc_snb01 = g_tc_sna.tc_sna01
      #   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      #      CALL cl_err3("upd","tc_sna_file",g_tc_sna.tc_sna01,"",STATUS,"","upd tc_snb46,tc_snb47:",1)
      #      ROLLBACK WORK
      #      RETURN
      #   END IF
      ##FUN-BC0104---add---end---
      #FUN-C40016----------mark----------end----------
      #FUN-C40016----add----str----
      ELSE
         DECLARE tc_snb03_cur1 CURSOR FOR SELECT tc_snb17,tc_snb46,tc_snb47
                                         FROM tc_snb_file
                                        WHERE tc_snb01 = g_tc_sna.tc_sna01
         FOREACH tc_snb03_cur1 INTO l_tc_snb17,l_tc_snb46,l_tc_snb47
            IF NOT cl_null(l_tc_snb46) THEN
               IF NOT s_iqctype_upd_qco20(l_tc_snb17,0,0,l_tc_snb47,'2') THEN
                  ROLLBACK WORK
                  RETURN
               END IF 
            END IF
         END FOREACH
      #FUN-C40016----add----end----
      END IF
      DISPLAY BY NAME g_tc_sna.tc_snaconf #FUN-660137
   END IF
 
   CLOSE t324_cl
   COMMIT WORK
   CALL cl_flow_notify(g_tc_sna.tc_sna01,'V')
 
END FUNCTION
 
FUNCTION t324_s()       #過帳
 DEFINE l_cnt   LIKE type_file.num5    #No.FUN-680121 SMALLINT
 DEFINE l_flag  LIKE type_file.chr1    #FUN-930109
 DEFINE l_tc_snb05 LIKE tc_snb_file.tc_snb05    #FUN-930109
 DEFINE l_tc_snb06 LIKE tc_snb_file.tc_snb06    #FUN-930109
 DEFINE l_tc_snb03 LIKE tc_snb_file.tc_snb03    #FUN-930109
 DEFINE g_flag  LIKE type_file.chr1    #FUN-930109
 DEFINE l_cnt_img       LIKE type_file.num5     #FUN-C70087
 DEFINE l_cnt_imgg      LIKE type_file.num5     #FUN-C70087
 DEFINE l_sql            STRING                 #FUN-C70087
 DEFINE l_tc_snb           RECORD LIKE tc_snb_file.*  #FUN-C70087
 
   IF s_shut(0) THEN RETURN END IF
   #str----add by guanyao160928
   SELECT smaud03 INTO g_sma.smaud03 FROM sma_file WHERE sma00 ='0'
   IF g_sma.smaud03 = 'Y' THEN 
      CALL cl_err('','csf-087',1)
      EXIT PROGRAM
   END IF 
   #end----add by guanyao160928
   IF g_tc_sna.tc_sna01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_tc_sna.* FROM tc_sna_file WHERE tc_sna01 = g_tc_sna.tc_sna01
   IF g_tc_sna.tc_snapost='Y' THEN RETURN END IF
   IF g_tc_sna.tc_snaconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF g_tc_sna.tc_snaconf = 'N' THEN
      CALL cl_err('','aba-100',1)
      RETURN
   END IF
   SELECT COUNT(*) INTO l_cnt FROM tc_snb_file WHERE tc_snb01 = g_tc_sna.tc_sna01
   IF l_cnt = 0 THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
   IF g_sma.sma53 IS NOT NULL AND g_tc_sna.tc_sna02 <= g_sma.sma53 THEN
      CALL cl_err('','mfg9999',0) RETURN
   END IF
   CALL s_yp(g_tc_sna.tc_sna02) RETURNING g_yy,g_mm
   IF (g_yy*12+g_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
      CALL cl_err(g_yy,'mfg6090',0) RETURN
   END IF
 
   BEGIN WORK

   OPEN t324_cl USING g_tc_sna.tc_sna01
   IF STATUS THEN
      CALL cl_err("OPEN t324_cl:", STATUS, 1)
      CLOSE t324_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_flag = 'Y'
   DECLARE t324_s_cs1 CURSOR FOR SELECT tc_snb03,tc_snb05,tc_snb06 FROM tc_snb_file                                                                              
                                  WHERE tc_snb01 = g_tc_sna.tc_sna01
   CALL s_showmsg_init() 
 
 
   CALL s_showmsg()                                                                                                                 
   IF g_flag='N' THEN                                                                                                            
      RETURN                                                                                                                        
   END IF
  #MOD-AC0057---mark---start---    #將此段搬到FETCH後面 
  #IF NOT cl_confirm('mfg0176') THEN 
  #   CLOSE t324_cl
  #   ROLLBACK WORK
  #   RETURN 
  #END IF
  #MOD-AC0057---mark---end---
 
   #FUN-C70087---begin
  # CALL s_padd_img_init()  #FUN-CC0095
 
   
   DECLARE t324_s_c2 CURSOR FOR SELECT * FROM tc_snb_file
     WHERE tc_snb01 = g_tc_sna.tc_sna01 

   #FUN-CC0095---begin mark
   #LET l_sql = " SELECT COUNT(*) ",
   #            " FROM ",l_img_table CLIPPED #,g_cr_db_str
   #PREPARE cnt_img FROM l_sql
   #LET l_cnt_img = 0
   #EXECUTE cnt_img INTO l_cnt_img
   #
   #LET l_sql = " SELECT COUNT(*) ",
   #            " FROM ",l_imgg_table CLIPPED  #,g_cr_db_str
   #PREPARE cnt_imgg FROM l_sql
   #LET l_cnt_imgg = 0
   #EXECUTE cnt_imgg INTO l_cnt_imgg
   #FUN-CC0095---end    

  
   FETCH t324_cl INTO g_tc_sna.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_tc_sna.tc_sna01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t324_cl ROLLBACK WORK RETURN
   END IF
 
  #MOD-AC0057---add---start---    #將此段搬到FETCH後面 
   IF NOT cl_confirm('mfg0176') THEN 
      CLOSE t324_cl
      ROLLBACK WORK
      RETURN 
   END IF
  #MOD-AC0057---add---end---
   LET g_success = 'Y'
 
 
   UPDATE tc_sna_file SET tc_snapost='Y' WHERE tc_sna01=g_tc_sna.tc_sna01
   IF sqlca.sqlcode THEN LET g_success='N' END IF
 
   IF g_success = 'Y' THEN
      LET g_tc_sna.tc_snapost='Y'
      DISPLAY BY NAME g_tc_sna.tc_snapost
      COMMIT WORK
      CALL cl_flow_notify(g_tc_sna.tc_sna01,'S')
   ELSE
      LET g_tc_sna.tc_snapost='N'
      ROLLBACK WORK
   END IF
   DISPLAY BY NAME g_tc_sna.tc_snapost
 
END FUNCTION

FUNCTION t324_w()
IF cl_null(g_tc_sna.tc_sna01) THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_tc_sna.* FROM tc_sna_file WHERE tc_sna01 = g_tc_sna.tc_sna01
   IF g_tc_sna.tc_snapost<>'Y' THEN RETURN END IF
   BEGIN WORK
 
   OPEN t324_cl USING g_tc_sna.tc_sna01
   IF STATUS THEN
      CALL cl_err("OPEN t324_cl:", STATUS, 1)
      CLOSE t324_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t324_cl INTO g_tc_sna.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_sna.tc_sna01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t324_cl 
      ROLLBACK WORK 
      RETURN
   END IF
  #MOD-AC0057---modify---start---
  #CLOSE t324_cl
   IF NOT cl_confirm('axm-109') THEN 
      CLOSE t324_cl
      ROLLBACK WORK
      RETURN 
   END IF
  #MOD-AC0057---modify---end---
   LET g_success = 'Y'
   UPDATE tc_sna_file SET tc_snapost = 'N' WHERE tc_sna01 = g_tc_sna.tc_sna01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
      LET g_success = 'N' 
   END IF
   IF g_success = 'Y' THEN
      LET g_tc_sna.tc_snapost='N'
      COMMIT WORK
      DISPLAY BY NAME g_tc_sna.tc_snapost
   ELSE
      LET g_tc_sna.tc_snapost='Y'
      ROLLBACK WORK
   END IF
   CLOSE t324_cl         #MOD-AC0057 add
   CALL t324_pic() #圖形顯示

END FUNCTION

FUNCTION t324_k()

END FUNCTION




 
FUNCTION t324_mu_ui()
    CALL cl_set_comp_visible("tc_snb31,tc_snb34",FALSE)
    CALL cl_set_comp_visible("tc_snb30,tc_snb33,tc_snb32,tc_snb35",g_sma.sma115='Y')
    CALL cl_set_comp_visible("tc_snb08,tc_snb09",g_sma.sma115='N')
    IF g_sma.sma122 ='1' THEN
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("tc_snb33",g_msg CLIPPED)
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("tc_snb35",g_msg CLIPPED)
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("tc_snb30",g_msg CLIPPED)
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("tc_snb32",g_msg CLIPPED)
    END IF
    IF g_sma.sma122 ='2' THEN
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("tc_snb33",g_msg CLIPPED)
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("tc_snb35",g_msg CLIPPED)
       CALL cl_getmsg('asm-310',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("tc_snb30",g_msg CLIPPED)
       CALL cl_getmsg('asm-311',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("tc_snb32",g_msg CLIPPED)
    END IF
   IF g_aaz.aaz90='Y' THEN
      CALL cl_set_comp_required("tc_sna04",TRUE)
   END IF
   CALL cl_set_comp_visible("tc_snb930,gem02c",g_aaz.aaz90='Y')
   CALL cl_set_comp_visible("tc_sna06,pja02,tc_snb41,tc_snb42,tc_snb43",g_aza.aza08='Y')
   CALL cl_set_comp_visible("page2",g_sma.sma95='Y')                    #TQC-C80184  add

END FUNCTION
 
FUNCTION t324_sel_ima()
   SELECT ima25,ima906,ima907 INTO g_ima25,g_ima906,g_ima907
     FROM ima_file
    WHERE ima01=g_tc_snb[l_ac].tc_snb04
END FUNCTION
 
FUNCTION t324_set_du_by_origin(p_tc_snb04,p_tc_snb08,p_tc_snb09,p_tc_snb05,p_tc_snb06,p_tc_snb07)
  DEFINE p_tc_snb04     LIKE tc_snb_file.tc_snb04,
         p_tc_snb08     LIKE tc_snb_file.tc_snb08,
         p_tc_snb09     LIKE tc_snb_file.tc_snb09,
         p_tc_snb05     LIKE tc_snb_file.tc_snb05,
         p_tc_snb06     LIKE tc_snb_file.tc_snb06,
         p_tc_snb07     LIKE tc_snb_file.tc_snb07,
         l_tc_snb30     LIKE tc_snb_file.tc_snb30,
         l_tc_snb31     LIKE tc_snb_file.tc_snb31,
         l_tc_snb32     LIKE tc_snb_file.tc_snb32,
         l_tc_snb33     LIKE tc_snb_file.tc_snb33,
         l_tc_snb34     LIKE tc_snb_file.tc_snb34,
         l_tc_snb35     LIKE tc_snb_file.tc_snb35
 
   IF p_tc_snb06 IS NULL THEN LET p_tc_snb06=' ' END IF
   IF p_tc_snb07 IS NULL THEN LET p_tc_snb07=' ' END IF
   SELECT img09 INTO g_img09 FROM img_file
    WHERE img01=p_tc_snb04
      AND img02=p_tc_snb05
      AND img03=p_tc_snb06
      AND img04=p_tc_snb07
   IF cl_null(g_img09) THEN LET g_img09=g_ima25 END IF
 
   LET l_tc_snb30=p_tc_snb08
   LET g_factor = 1
   CALL s_umfchk(p_tc_snb04,l_tc_snb30,g_img09)
        RETURNING g_cnt,g_factor
   IF g_cnt = 1 THEN
      LET g_factor = 1
   END IF
   LET l_tc_snb31=g_factor
   LET l_tc_snb32=p_tc_snb09
   LET l_tc_snb33=g_ima907
   LET g_factor = 1
   CALL s_umfchk(p_tc_snb04,l_tc_snb33,g_img09)
        RETURNING g_cnt,g_factor
   IF g_cnt = 1 THEN
      LET g_factor = 1
   END IF
   LET l_tc_snb34=g_factor
   LET l_tc_snb35=0
   IF g_ima906 = '3' THEN
      LET g_factor = 1
      CALL s_umfchk(p_tc_snb04,l_tc_snb30,l_tc_snb33)
           RETURNING g_cnt,g_factor
      IF g_cnt = 1 THEN
         LET g_factor = 1
      END IF
      LET l_tc_snb35=l_tc_snb32*g_factor
      LET l_tc_snb35 = s_digqty(l_tc_snb35,l_tc_snb33) #FUN-BB0086 add
   END IF
   RETURN l_tc_snb30,l_tc_snb31,l_tc_snb32,l_tc_snb33,l_tc_snb34,l_tc_snb35
 
END FUNCTION
 
#用于default 雙單位/轉換率/數量
FUNCTION t324_du_default(p_cmd)
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ware   LIKE img_file.img02,     #倉庫
            l_loc    LIKE img_file.img03,     #儲
            l_lot    LIKE img_file.img04,     #批
            l_ima25  LIKE ima_file.ima25,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_unit2  LIKE img_file.img09,     #第二單位
            l_fac2   LIKE img_file.img21,     #第二轉換率
            l_qty2   LIKE img_file.img10,     #第二數量
            l_unit1  LIKE img_file.img09,     #第一單位
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            p_cmd    LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1)
            l_factor LIKE ima_file.ima31_fac  #No.FUN-680121 DECIMAL(16,8)
 
    LET l_item = g_tc_snb[l_ac].tc_snb04
    LET l_ware = g_tc_snb[l_ac].tc_snb05
    LET l_loc  = g_tc_snb[l_ac].tc_snb06
    LET l_lot  = g_tc_snb[l_ac].tc_snb07
 
    SELECT ima25,ima906,ima907 INTO l_ima25,l_ima906,l_ima907
      FROM ima_file WHERE ima01 = l_item
 
    SELECT img09 INTO g_img09 FROM img_file
     WHERE img01 = l_item
       AND img02 = l_ware
       AND img03 = l_loc
       AND img04 = l_lot
    IF cl_null(g_img09) THEN LET g_img09 = l_ima25 END IF
 
    IF l_ima906 = '1' THEN  #不使用雙單位
       LET l_unit2 = NULL
       LET l_fac2  = NULL
       LET l_qty2  = NULL
    ELSE
       LET l_unit2 = l_ima907
       CALL s_du_umfchk(l_item,'','','',g_img09,l_ima907,l_ima906)
            RETURNING g_errno,l_factor
       LET l_fac2 = l_factor
       LET l_qty2  = 0
    END IF
    LET l_unit1 = g_img09
    LET l_fac1  = 1
    LET l_qty1  = 0
 
    IF p_cmd = 'a' OR g_change = 'Y' THEN
       LET g_tc_snb[l_ac].tc_snb33 =l_unit2
       LET g_tc_snb[l_ac].tc_snb34 =l_fac2
       LET g_tc_snb[l_ac].tc_snb35 =l_qty2
       LET g_tc_snb[l_ac].tc_snb30 =l_unit1
       LET g_tc_snb[l_ac].tc_snb31 =l_fac1
       LET g_tc_snb[l_ac].tc_snb32 =l_qty1
    END IF
END FUNCTION
 
FUNCTION t324_set_origin_field()
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_tot    LIKE img_file.img10,
            l_fac2   LIKE imn_file.imn34,
            l_qty2   LIKE imn_file.imn35,
            l_fac1   LIKE imn_file.imn31,
            l_qty1   LIKE imn_file.imn32,
            l_factor LIKE ima_file.ima31_fac  #No.FUN-680121 DECIMAL(16,8)
 
    IF g_sma.sma115='N' THEN RETURN END IF  #MOD-590120
    LET l_fac2=g_tc_snb[l_ac].tc_snb34
    LET l_qty2=g_tc_snb[l_ac].tc_snb35
    LET l_fac1=g_tc_snb[l_ac].tc_snb31
    LET l_qty1=g_tc_snb[l_ac].tc_snb32
 
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE g_ima906
          WHEN '1' LET g_tc_snb[l_ac].tc_snb08=g_tc_snb[l_ac].tc_snb30
                   LET g_tc_snb[l_ac].tc_snb09=l_qty1
          WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
                   LET g_tc_snb[l_ac].tc_snb08=g_img09
                   LET g_tc_snb[l_ac].tc_snb09=l_tot
                   LET g_tc_snb[l_ac].tc_snb09=s_digqty(g_tc_snb[l_ac].tc_snb09, g_tc_snb[l_ac].tc_snb08) #FUN-BB0086 add
          WHEN '3' LET g_tc_snb[l_ac].tc_snb08=g_tc_snb[l_ac].tc_snb30
                   LET g_tc_snb[l_ac].tc_snb09=l_qty1
                   IF l_qty2 <> 0 THEN
                      LET g_tc_snb[l_ac].tc_snb34 =l_qty1/l_qty2
                   ELSE
                      LET g_tc_snb[l_ac].tc_snb34 =0
                   END IF
       END CASE
    END IF
 
END FUNCTION
 
FUNCTION t324_set_required()
 
  #兩組雙單位資料不是一定要全部輸入,但是參考單位的時候要全輸入
  IF g_ima906 = '3' THEN
     CALL cl_set_comp_required("tc_snb33,tc_snb35,tc_snb30,tc_snb32",TRUE)
  END IF
  #單位不同,轉換率,數量必KEY
  IF NOT cl_null(g_tc_snb[l_ac].tc_snb30) THEN
     CALL cl_set_comp_required("tc_snb32",TRUE)
  END IF
  IF NOT cl_null(g_tc_snb[l_ac].tc_snb33) THEN
     CALL cl_set_comp_required("tc_snb35",TRUE)
  END IF
 
END FUNCTION
 
FUNCTION t324_set_no_required()
 
  CALL cl_set_comp_required("tc_snb33,tc_snb35,tc_snb30,tc_snb32",FALSE)
 
END FUNCTION
 
#兩組雙單位資料不是一定要全部KEY,如果沒有KEY單位,則把換算率/數量清空
FUNCTION t324_du_data_to_correct()
 
   IF cl_null(g_tc_snb[l_ac].tc_snb33) THEN
      LET g_tc_snb[l_ac].tc_snb34 = NULL
      LET g_tc_snb[l_ac].tc_snb35 = NULL
   END IF
 
   IF cl_null(g_tc_snb[l_ac].tc_snb30) THEN
      LET g_tc_snb[l_ac].tc_snb31 = NULL
      LET g_tc_snb[l_ac].tc_snb32 = NULL
   END IF
   DISPLAY BY NAME g_tc_snb[l_ac].tc_snb31
   DISPLAY BY NAME g_tc_snb[l_ac].tc_snb32
   DISPLAY BY NAME g_tc_snb[l_ac].tc_snb34
   DISPLAY BY NAME g_tc_snb[l_ac].tc_snb35
 
END FUNCTION
 


#檢查單位是否存在於單位檔中
FUNCTION t324_unit(p_key)
    DEFINE p_key     LIKE gfe_file.gfe01,
           l_gfe02   LIKE gfe_file.gfe02,
           l_gfeacti LIKE gfe_file.gfeacti
 
    LET g_errno = ' '
    SELECT gfe02,gfeacti
           INTO l_gfe02,l_gfeacti
           FROM gfe_file WHERE gfe01 = p_key
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg2605'
                            LET l_gfe02 = NULL
         WHEN l_gfeacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
#圖形顯示
FUNCTION t324_pic()
   ##圖形顯示
   IF g_tc_sna.tc_snaconf = 'X' THEN
      LET g_void = 'Y'
   ELSE
      LET g_void = 'N'
   END IF
   CALL cl_set_field_pic(g_tc_sna.tc_snaconf,"",g_tc_sna.tc_snapost,"",g_void,"")
END FUNCTION
 
FUNCTION t324_y_chk()
   DEFINE l_cnt      LIKE type_file.num10   #No.FUN-680121 INTEGER
   DEFINE l_cn       LIKE type_file.num10
   DEFINE l_str      STRING
   DEFINE l_gem01    LIKE gem_file.gem01    #TQC-C60207
   DEFINE l_shm08    LIKE shm_file.shm08
   DEFINE l_tc_snb09    LIKE tc_snb_file.tc_snb09   #add by huanglf161014
#str----add by huanglf161017
   DEFINE l_sfb09    LIKE sfb_file.sfb09
   DEFINE l_sfbud05  LIKE sfb_file.sfbud05
   DEFINE l_min      LIKE tc_snb_file.tc_snb09
   DEFINE l_x        LIKE type_file.num5
#str----end by huanglf1161017
   LET g_success = 'Y'
 

   IF cl_null(g_tc_sna.tc_sna01) THEN 
      CALL cl_err('',-400,0) 
      LET g_success = 'N'
      RETURN 
   END IF
#CHI-C30107 ---------------- add ----------------- begin
   IF g_tc_sna.tc_snaconf='Y' THEN
      LET g_success = 'N'
      CALL cl_err('','9023',0)
      RETURN
   END IF

   IF g_tc_sna.tc_snaconf = 'X' THEN
      LET g_success = 'N'
      CALL cl_err(' ','9024',0)
      RETURN
   END IF

   #SELECT COUNT(*) INTO l_cnt FROM tc_sna_file         #TQC-C90039  mark
   #   WHERE tc_sna01= g_tc_sna.tc_sna01                      #TQC-C90039  mark
   SELECT COUNT(*) INTO l_cnt FROM tc_snb_file          #TQC-C90039  add
      WHERE tc_snb01= g_tc_sna.tc_sna01                       #TQC-C90039  add
   IF l_cnt = 0 THEN
      LET g_success = 'N'
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
 
   IF NOT cl_confirm('axm-108') THEN LET g_success = 'N' RETURN END IF    #TQC-C90042 add  LET g_success = 'N'
#CHI-C30107 ------------- add -------------- end
   SELECT * INTO g_tc_sna.* FROM tc_sna_file WHERE tc_sna01 = g_tc_sna.tc_sna01
   IF g_tc_sna.tc_snaconf='Y' THEN
      LET g_success = 'N'           
      CALL cl_err('','9023',0)      
      RETURN
   END IF
 
   IF g_tc_sna.tc_snaconf = 'X' THEN
      LET g_success = 'N'   
      CALL cl_err(' ','9024',0)
      RETURN
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM tc_sna_file
      WHERE tc_sna01= g_tc_sna.tc_sna01
   IF l_cnt = 0 THEN
      LET g_success = 'N'
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
   
#TQC-C60207 ----------------Begin---------------
   IF NOT cl_null(g_tc_sna.tc_sna04) THEN
      SELECT eca01 INTO l_gem01 FROM eca_file
       WHERE eca01 = g_tc_sna.tc_sna04
         AND ecaacti = 'Y'
      IF STATUS THEN
         LET g_success = 'N'
         CALL cl_err(g_tc_sna.tc_sna04,'abm-750',0)
         RETURN
      END IF
   END IF
#TQC-C60207 ----------------End-----------------


   DECLARE t324_y_chk_c CURSOR FOR SELECT * FROM tc_snb_file
                                   WHERE tc_snb01=g_tc_sna.tc_sna01
   FOREACH t324_y_chk_c INTO b_tc_snb.*   

      
   


         IF g_argv = '1' THEN 
               SELECT  shm08  INTO l_shm08 FROM shm_file WHERE shm01 = b_tc_snb.tc_snb20
            IF b_tc_snb.tc_snb09 > l_shm08 THEN 
              LET b_tc_snb.tc_snb09  = ''
              CALL cl_err(b_tc_snb.tc_snb09,"csf-067",1)
              LET g_success = "N"
            END IF 
  
         END IF 


   END FOREACH
   
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION
 
FUNCTION t324_y_upd()
   #IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30118 mark 移至y_chk最上方
   LET g_success = 'Y'
   BEGIN WORK
 
   OPEN t324_cl USING g_tc_sna.tc_sna01
   IF STATUS THEN
      CALL cl_err("OPEN t324_cl:", STATUS, 1)
      CLOSE t324_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t324_cl INTO g_tc_sna.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_tc_sna.tc_sna01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t324_cl 
       ROLLBACK WORK 
       RETURN
   END IF
   CLOSE t324_cl
   UPDATE tc_sna_file SET tc_snaconf = 'Y' WHERE tc_sna01 = g_tc_sna.tc_sna01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","tc_sna_file",g_tc_sna.tc_sna01,"",STATUS,"","upd tc_snaconf",1)  #No.FUN-660128
      LET g_success = 'N'
   END IF
 
   IF g_success='Y' THEN
      COMMIT WORK
      LET g_tc_sna.tc_snaconf='Y'
      CALL cl_flow_notify(g_tc_sna.tc_sna01,'Y')
   ELSE
      ROLLBACK WORK
      LET g_tc_sna.tc_snaconf='N'
   END IF
   DISPLAY BY NAME g_tc_sna.tc_snaconf
   CALL t324_pic() #圖形顯示
END FUNCTION


FUNCTION t324_z()
   IF cl_null(g_tc_sna.tc_sna01) THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_tc_sna.* FROM tc_sna_file WHERE tc_sna01 = g_tc_sna.tc_sna01
   IF g_tc_sna.tc_snaconf='N' THEN RETURN END IF
   IF g_tc_sna.tc_snaconf='X' THEN CALL cl_err(' ','9024',0) RETURN END IF
   IF g_tc_sna.tc_snapost='Y' THEN
      CALL cl_err('tc_snapost=Y:','afa-101',0)
      RETURN
   END IF
 
  #IF NOT cl_confirm('axm-109') THEN RETURN END IF   #MOD-AC0057 mark
   BEGIN WORK
 
   OPEN t324_cl USING g_tc_sna.tc_sna01
   IF STATUS THEN
      CALL cl_err("OPEN t324_cl:", STATUS, 1)
      CLOSE t324_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t324_cl INTO g_tc_sna.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_sna.tc_sna01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t324_cl 
      ROLLBACK WORK 
      RETURN
   END IF
  #MOD-AC0057---modify---start---
  #CLOSE t324_cl
   IF NOT cl_confirm('axm-109') THEN 
      CLOSE t324_cl
      ROLLBACK WORK
      RETURN 
   END IF
  #MOD-AC0057---modify---end---
   LET g_success = 'Y'
   UPDATE tc_sna_file SET tc_snaconf = 'N' WHERE tc_sna01 = g_tc_sna.tc_sna01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
      LET g_success = 'N' 
   END IF
   IF g_success = 'Y' THEN
      LET g_tc_sna.tc_snaconf='N'
      COMMIT WORK
      DISPLAY BY NAME g_tc_sna.tc_snaconf
   ELSE
      LET g_tc_sna.tc_snaconf='Y'
      ROLLBACK WORK
   END IF
   CLOSE t324_cl         #MOD-AC0057 add
   CALL t324_pic() #圖形顯示
END FUNCTION




#TQC-AC0294-------start------------
FUNCTION t324_tc_sna01(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_slip    LIKE smy_file.smyslip
   DEFINE l_smy73   LIKE smy_file.smy73
 
   LET g_errno = ' '
   IF cl_null(g_tc_sna.tc_sna01) THEN RETURN END IF
   LET l_slip = s_get_doc_no(g_tc_sna.tc_sna01)
 
   SELECT smy73 INTO l_smy73 FROM smy_file
    WHERE smyslip = l_slip
   IF l_smy73 = 'Y' THEN
      LET g_errno = 'asf-876'
   END IF

END FUNCTION
#TQC-AC0294--------end----------------

#No.FUN-BB0086---start---add---
FUNCTION t324_tc_snb32_check(l_qcf091,l_sfb08,l_tc_snb09)
   DEFINE l_qcf091         LIKE qcf_file.qcf091
   DEFINE l_sfb08          LIKE sfb_file.sfb08
   DEFINE l_tc_snb09          LIKE tc_snb_file.tc_snb09
   
   IF NOT cl_null(g_tc_snb[l_ac].tc_snb32) AND NOT cl_null(g_tc_snb[l_ac].tc_snb30) THEN
      IF cl_null(g_tc_snb_t.tc_snb32) OR cl_null(g_tc_snb30_t) OR g_tc_snb_t.tc_snb32 != g_tc_snb[l_ac].tc_snb32 OR g_tc_snb30_t != g_tc_snb[l_ac].tc_snb30 THEN
         LET g_tc_snb[l_ac].tc_snb32=s_digqty(g_tc_snb[l_ac].tc_snb32, g_tc_snb[l_ac].tc_snb30)
         DISPLAY BY NAME g_tc_snb[l_ac].tc_snb32
      END IF
   END IF
   
   IF NOT cl_null(g_tc_snb[l_ac].tc_snb32) THEN
      IF g_tc_snb[l_ac].tc_snb32 < 0 THEN
         CALL cl_err('','aim-391',0)  #
         RETURN FALSE,'tc_snb32'
      END IF
   END IF
   CALL t324_du_data_to_correct()
   CALL t324_set_origin_field()
   CALL t324_unit(g_tc_snb[l_ac].tc_snb08)
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
      RETURN FALSE,'tc_snb05'
   END IF
   IF cl_null(g_tc_snb[l_ac].tc_snb09) OR g_tc_snb[l_ac].tc_snb09 <= 0 THEN
      LET g_tc_snb[l_ac].tc_snb09 = 0
      IF g_ima906 MATCHES '[23]' THEN
         RETURN FALSE,'tc_snb35'
      ELSE
         RETURN FALSE,'tc_snb32'
      END IF
   END IF
 
   
END FUNCTION


FUNCTION t324_set_noentry_tc_snb46()
   CALL cl_set_comp_entry('tc_snb46,tc_snb47',FALSE)
END FUNCTION

FUNCTION t324_set_comp_required(p_tc_snb46,p_tc_snb47)
   DEFINE p_tc_snb46 LIKE tc_snb_file.tc_snb46,
          p_tc_snb47 LIKE tc_snb_file.tc_snb47

   IF NOT cl_null(p_tc_snb46) OR NOT cl_null(p_tc_snb47) THEN
      CALL cl_set_comp_required('tc_snb46,tc_snb47',TRUE)
   END IF
 
   IF cl_null(p_tc_snb46) AND cl_null(p_tc_snb47) THEN
      CALL cl_set_comp_required('tc_snb46,tc_snb47',FALSE)
      LET g_tc_snb[l_ac].qcl02 = ''
   END IF
END FUNCTION

FUNCTION t324_qcl02_desc()

   SELECT qcl02 INTO g_tc_snb[l_ac].qcl02 FROM qcl_file
             WHERE qcl01 = g_tc_snb[l_ac].tc_snb46
      DISPLAY BY NAME g_tc_snb[l_ac].qcl02
   
END FUNCTION


FUNCTION p_zl_auno88(p_slip)
   DEFINE   p_slip VARCHAR(20),                    #單號
            l_yy   VARCHAR(4),
            l_mm   VARCHAR(2),
            l_mxno1 VARCHAR(10),
            l_mxno2 VARCHAR(04),
            l_buf  VARCHAR(6)
 
   LET p_slip=''
   LET l_yy=TODAY USING 'YYYY'
   LET l_mm=TODAY USING 'MM'
   LET l_buf=l_yy,l_mm
   SELECT MAX(tc_sna01) INTO l_mxno1 FROM tc_sna_file
    WHERE tc_sna01[1,6] = l_buf
   LET l_mxno2= l_mxno1[7,10]
   LET p_slip[7,10]=l_mxno2+1 USING '&&&&'
   IF cl_null(p_slip[5,10]) THEN
      IF l_mxno1 IS NULL OR l_mxno1=' ' THEN #最大編號未曾指定
          LET l_mxno2='0000'
          LET p_slip[7,10]=(l_mxno2+1) USING '&&&&'
      END IF
   END IF
   LET p_slip[1,6]=l_buf
   RETURN p_slip
END FUNCTION

