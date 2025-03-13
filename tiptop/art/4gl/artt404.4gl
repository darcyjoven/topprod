# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: artt404.4gl
# Descriptions...: 滿額促銷變更維護作業
# Date & Author..: NO.FUN-A80121 10/09/06 By shenyang
# Modify.........: No.FUN-AA0059 10/10/28 By chenying 料號開窗控管
# Modify.........: No.FUN-AB0033 10/11/10 By wangxin 促銷BUG調整
# Modify.........: No.FUN-AB0025 10/11/12 By vealxu AFTER FIELD rbj08 應判斷 if g_rbj[l_ac2].rbj07="01" 要 call s_chk_item_no()
# Modify.......... No.FUN-AB0101 10/11/26 By vealxu 料號檢查部份邏輯修改：如果對應營運中心有設產品策略，則抓產品策略的料號
# Modify.........: No:TQC-AC0326 10/12/24 By wangxin 促銷變更單要管控，審核、發布後的才可變更,
#                                                    生效營運中心中有對應的促銷單並且審核、發布， 才可審核對應的變更單,
#                                                    生效營運中心中有對應的促銷單的未審核變更單則不可審核當前促銷變更單
# Modify.........: No:FUN-B30028 11/03/11 By huangtao 移除簽核相關欄位
# Modify.........: No:MOD-B30045 11/04/01 By baogc 满量逻辑修改
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80085 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外
# Modify.........: No.FUN-B80095 11/08/25 By baogc 滿量邏輯修改
# Modify.........: No.FUN-BC0126 11/12/30 By pauline GP5.3 artt404 一般促銷變更單促銷功能優化
# Modify.........: No.TQC-C20002 12/02/01 By pauline 折讓基數可輸入0,且折讓基數不可大於滿額金額或滿量數量
# NO.FUN-A80121---begin--
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.TQC-C20328 12/02/21 By pauline 增加artt402_2參數,避免在輸入會員促銷方式組別時錯誤
# Modify.........: No.TQC-C20378 12/02/22 By pauline 把原會員促銷方式的有效碼UPDATE為'N'  
# Modify.........: No.TQC-C30030 12/03/01 By pauline INPUT 控制錯誤 
# Modify.........: No.FUN-C30151 12/03/20 By pauline 當促銷為折扣時且條件為滿量,增加折扣基數
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C60041 12/06/14 By huangtao變更生效門店時，對相應的門店資料做更顯
# Modify.........: No:FUN-D30033 13/04/18 by chenjing 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE
    #单头
    g_rbh           RECORD LIKE rbh_file.*,      
    g_rbh_t         RECORD LIKE rbh_file.*,  
    g_rbh_o         RECORD LIKE rbh_file.*, 
    g_rbh01_t       LIKE rbh_file.rbh01,
    g_rbh02_t       LIKE rbh_file.rbh02,         
    g_rbh03_t       LIKE rbh_file.rbh03,            
    g_rbhplant_t    LIKE rbh_file.rbhplant, 
 #第一单身
    g_rbi             DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
        type          LIKE type_file.chr1,   #類型 0.新增 1.修改
        before        LIKE type_file.chr1,   
        rbi06_1       LIKE rbi_file.rbi06,   
        rbi07_1       LIKE rbi_file.rbi07,   
        rbi08_1       LIKE rbi_file.rbi08,   
        rbi13_1       LIKE rbi_file.rbi13,  #FUN-BC0126 add
        rbi09_1       LIKE rbi_file.rbi09,   
        rbi10_1       LIKE rbi_file.rbi10,   
        rbi11_1       LIKE rbi_file.rbi11,  
        rbi12_1       LIKE rbi_file.rbi12,        
        rbiacti_1     LIKE rbi_file.rbiacti,

        after         LIKE type_file.chr1,   
        rbi06       LIKE rbi_file.rbi06,   
        rbi07       LIKE rbi_file.rbi07,   
        rbi08       LIKE rbi_file.rbi08,   
        rbi13       LIKE rbi_file.rbi13,  #FUN-BC0126 add
        rbi09       LIKE rbi_file.rbi09,   
        rbi10       LIKE rbi_file.rbi10,   
        rbi11       LIKE rbi_file.rbi11,   
        rbi12       LIKE rbi_file.rbi12,         
        rbiacti     LIKE rbi_file.rbiacti    
                      END RECORD,
   g_rbi_t           RECORD                 
       type          LIKE type_file.chr1,   
        before        LIKE type_file.chr1,   
        rbi06_1       LIKE rbi_file.rbi06,   
        rbi07_1       LIKE rbi_file.rbi07,   
        rbi08_1       LIKE rbi_file.rbi08,   
        rbi13_1       LIKE rbi_file.rbi13,  #FUN-BC0126 add
        rbi09_1       LIKE rbi_file.rbi09,   
        rbi10_1       LIKE rbi_file.rbi10,   
        rbi11_1       LIKE rbi_file.rbi11,   
        rbi12_1       LIKE rbi_file.rbi12,         
        rbiacti_1     LIKE rbi_file.rbiacti, 

        after         LIKE type_file.chr1,  
        rbi06       LIKE rbi_file.rbi06,   
        rbi07       LIKE rbi_file.rbi07,  
        rbi08       LIKE rbi_file.rbi08,   
        rbi13       LIKE rbi_file.rbi13,  #FUN-BC0126 add
        rbi09       LIKE rbi_file.rbi09,   
        rbi10       LIKE rbi_file.rbi10,   
        rbi11       LIKE rbi_file.rbi11,   
        rbi12       LIKE rbi_file.rbi12,        
        rbiacti     LIKE rbi_file.rbiacti   
                      END RECORD,
  g_rbi_o           RECORD                 
        type          LIKE type_file.chr1,   
        before        LIKE type_file.chr1,   
        rbi06_1       LIKE rbi_file.rbi06,   
        rbi07_1       LIKE rbi_file.rbi07,   
        rbi08_1       LIKE rbi_file.rbi08,   
        rbi13_1       LIKE rbi_file.rbi13,  #FUN-BC0126 add
        rbi09_1       LIKE rbi_file.rbi09,   
        rbi10_1       LIKE rbi_file.rbi10,   
        rbi11_1       LIKE rbi_file.rbi11,   
        rbi12_1       LIKE rbi_file.rbi12,         
        rbiacti_1     LIKE rbi_file.rbiacti, 

        after         LIKE type_file.chr1,  
        rbi06       LIKE rbi_file.rbi06,  
        rbi07       LIKE rbi_file.rbi07,   
        rbi08       LIKE rbi_file.rbi08,   
        rbi13       LIKE rbi_file.rbi13,  #FUN-BC0126 add
        rbi09       LIKE rbi_file.rbi09,   
        rbi10       LIKE rbi_file.rbi10,   
        rbi11       LIKE rbi_file.rbi11,   
        rbi12       LIKE rbi_file.rbi12,         
        rbiacti     LIKE rbi_file.rbiacti   
                      END RECORD
 #第二单身
DEFINE  
    g_rbj             DYNAMIC ARRAY OF RECORD  
        type1         LIKE type_file.chr1,       
        before1       LIKE type_file.chr1,
        rbj06_1       LIKE rbj_file.rbj06,
        rbj07_1       LIKE rbj_file.rbj07,
        rbj08_1       LIKE rbj_file.rbj08,
        rbj08_desc_1  LIKE ima_file.ima02,
        rbj09_1       LIKE rbj_file.rbj09,
        rbj09_desc_1  LIKE gfe_file.gfe02,
        rbjacti_1     LIKE rbj_file.rbjacti,

        after1        LIKE type_file.chr1,
        rbj06         LIKE rbj_file.rbj06,  
        rbj07         LIKE rbj_file.rbj07,  
        rbj08         LIKE rbj_file.rbj08,  
        rbj08_desc    LIKE ima_file.ima02,  
        rbj09         LIKE rbj_file.rbj09,  
        rbj09_desc    LIKE gfe_file.gfe02,  
        rbjacti       LIKE rbj_file.rbjacti  
                      END RECORD,
   g_rbj_t             RECORD  
        type1         LIKE type_file.chr1,       
        before1       LIKE type_file.chr1,
        rbj06_1       LIKE rbj_file.rbj06,
        rbj07_1       LIKE rbj_file.rbj07,
        rbj08_1       LIKE rbj_file.rbj08,
        rbj08_desc_1  LIKE ima_file.ima02,
        rbj09_1       LIKE rbj_file.rbj09,
        rbj09_desc_1  LIKE gfe_file.gfe02,
        rbjacti_1     LIKE rbj_file.rbjacti,

        after1        LIKE type_file.chr1,
        rbj06         LIKE rbj_file.rbj06,  
        rbj07         LIKE rbj_file.rbj07,  
        rbj08         LIKE rbj_file.rbj08,  
        rbj08_desc    LIKE ima_file.ima02,  
        rbj09         LIKE rbj_file.rbj09,  
        rbj09_desc    LIKE gfe_file.gfe02,  
        rbjacti       LIKE rbj_file.rbjacti  
                      END RECORD,
   g_rbj_o             RECORD  
        type1         LIKE type_file.chr1,       
        before1       LIKE type_file.chr1,
        rbj06_1       LIKE rbj_file.rbj06,
        rbj07_1       LIKE rbj_file.rbj07,
        rbj08_1       LIKE rbj_file.rbj08,
        rbj08_desc_1  LIKE ima_file.ima02,
        rbj09_1       LIKE rbj_file.rbj09,
        rbj09_desc_1  LIKE gfe_file.gfe02,
        rbjacti_1     LIKE rbj_file.rbjacti,

        after1        LIKE type_file.chr1,
        rbj06         LIKE rbj_file.rbj06,  
        rbj07         LIKE rbj_file.rbj07,  
        rbj08         LIKE rbj_file.rbj08,  
        rbj08_desc    LIKE ima_file.ima02,  
        rbj09         LIKE rbj_file.rbj09,  
        rbj09_desc    LIKE gfe_file.gfe02,  
        rbjacti       LIKE rbj_file.rbjacti  
                      END RECORD
                      
DEFINE
    g_wc,g_wc1,g_wc2,g_sql    string,  
    l_flag              LIKE type_file.chr1,    
    g_flag_b            LIKE type_file.chr1,
    g_argv1        	    LIKE pmn_file.pmn01,    
    g_argv2             LIKE pmn_file.pmn02,    
    g_argv3             STRING,                  
    g_rec_b1            LIKE type_file.num5,    
    g_rec_b2            LIKE type_file.num5,   
    g_t1                LIKE oay_file.oayslip,  
    g_sta               LIKE ze_file.ze03,      
    l_ac_1              LIKE type_file.num5,    
    l_ac1               LIKE type_file.num5,     
    l_ac2               LIKE type_file.num5      
DEFINE   g_laststage    LIKE type_file.chr1     
DEFINE   p_row,p_col    LIKE type_file.num5     
DEFINE   g_forupd_sql   STRING                  #SELECT ...  FOR UPDATE SQL
DEFINE   g_chr          LIKE type_file.chr1     
DEFINE   g_chr2         LIKE type_file.chr1    
DEFINE   g_cnt          LIKE type_file.num10    
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose
DEFINE   g_msg          LIKE ze_file.ze03       
DEFINE   g_before_input_done  LIKE type_file.num5  
DEFINE   g_row_count    LIKE type_file.num10    
DEFINE   g_curs_index   LIKE type_file.num10    
DEFINE   g_jump         LIKE type_file.num10    
DEFINE   g_no_ask       LIKE type_file.num5     
DEFINE   g_smy62        LIKE smy_file.smy62     
DEFINE   g_error        LIKE type_file.chr10
DEFINE   g_term         LIKE rbh_file.rbh10     
DEFINE   g_price        LIKE rbh_file.rbh09    
DEFINE   l_dbs_tra      LIKE azw_file.azw05    
DEFINE   l_plant_new    LIKE azp_file.azp01    
 
DEFINE l_azp02             LIKE azp_file.azp02
DEFINE g_rtz05             LIKE rtz_file.rtz05  
DEFINE g_rtz04             LIKE rtz_file.rtz04         #FUN-AB0101
DEFINE l_tt   DATETIME YEAR TO FRACTION(4)
DEFINE l_tp   DATETIME YEAR TO FRACTION(4)
DEFINE l_tt1 like type_file.chr30
DEFINE cb    ui.ComboBox                         #MOD-B30045 ADD
#FUN-BC0126 add START
DEFINE
       g_rbk         DYNAMIC ARRAY OF RECORD
           type2          LIKE type_file.chr1,   #類型 0.新增 1.修改
           before2        LIKE type_file.chr1,   #0:初始
           rbk08_1        LIKE rbk_file.rbk08,
           rbk09_1        LIKE rbk_file.rbk09,
           rbk10_1        LIKE rbk_file.rbk10,
           rbk11_1        LIKE rbk_file.rbk11,
           rbk12_1        LIKE rbk_file.rbk12,
           rbk13_1        LIKE rbk_file.rbk13,
           rbk14_1        LIKE rbk_file.rbk13,
           rbkacti_1      LIKE rbk_file.rbkacti,
           after2         LIKE type_file.chr1,   #1:修改
           rbk08          LIKE rbk_file.rbk08,
           rbk09          LIKE rbk_file.rbk09,
           rbk10          LIKE rbk_file.rbk10,
           rbk11          LIKE rbk_file.rbk11,
           rbk12          LIKE rbk_file.rbk12,
           rbk13          LIKE rbk_file.rbk13,
           rbk14          LIKE rbk_file.rbk13,
           rbkacti        LIKE rbk_file.rbkacti
                     END RECORD,
       g_rbk_t       RECORD
           type2          LIKE type_file.chr1,   #類型 0.新增 1.修改
           before2        LIKE type_file.chr1,   #0:初始
           rbk08_1        LIKE rbk_file.rbk08,
           rbk09_1        LIKE rbk_file.rbk09,
           rbk10_1        LIKE rbk_file.rbk10,
           rbk11_1        LIKE rbk_file.rbk11,
           rbk12_1        LIKE rbk_file.rbk12,
           rbk13_1        LIKE rbk_file.rbk13,
           rbk14_1        LIKE rbk_file.rbk13,
           rbkacti_1      LIKE rbk_file.rbkacti,
           after2         LIKE type_file.chr1,   #1:修改
           rbk08          LIKE rbk_file.rbk08,
           rbk09          LIKE rbk_file.rbk09,
           rbk10          LIKE rbk_file.rbk10,
           rbk11          LIKE rbk_file.rbk11,
           rbk12          LIKE rbk_file.rbk12,
           rbk13          LIKE rbk_file.rbk13,
           rbk14          LIKE rbk_file.rbk13,
           rbkacti        LIKE rbk_file.rbkacti
                     END RECORD,
       g_rbk_o       RECORD
           type2          LIKE type_file.chr1,   #類型 0.新增 1.修改
           before2        LIKE type_file.chr1,   #0:初始
           rbk08_1        LIKE rbk_file.rbk08,
           rbk09_1        LIKE rbk_file.rbk09,
           rbk10_1        LIKE rbk_file.rbk10,
           rbk11_1        LIKE rbk_file.rbk11,
           rbk12_1        LIKE rbk_file.rbk12,
           rbk13_1        LIKE rbk_file.rbk13,
           rbk14_1        LIKE rbk_file.rbk13,
           rbkacti_1      LIKE rbk_file.rbkacti,
           after2         LIKE type_file.chr1,   #1:修改
           rbk08          LIKE rbk_file.rbk08,
           rbk09          LIKE rbk_file.rbk09,
           rbk10          LIKE rbk_file.rbk10,
           rbk11          LIKE rbk_file.rbk11,
           rbk12          LIKE rbk_file.rbk12,
           rbk13          LIKE rbk_file.rbk13,
           rbk14          LIKE rbk_file.rbk13,
           rbkacti        LIKE rbk_file.rbkacti
                     END RECORD
DEFINE g_wc3               STRING,
       g_rec_b3            LIKE type_file.num5,    #單身筆數
       l_ac3               LIKE type_file.num5,
       g_n                 LIKE type_file.num5

DEFINE g_flag            LIKE type_file.chr1    #FUN-C60041 add
DEFINE g_b_flag            LIKE type_file.chr1   #FUN-D30033  add
#FUN-BC0126 add END
MAIN
    IF FGL_GETENV("FGLGUI") <> "0" THEN
       OPTIONS                                
           INPUT NO WRAP,
           FIELD ORDER FORM                  #整個畫面會依照p_per所設定的欄位順序(忽略4gl寫的順序)  #FUN-730068
       DEFER INTERRUPT
    END IF

    DISPLAY EXTEND ( TODAY, YEAR TO FRACTION(4) )

    LET l_tt =CURRENT YEAR TO FRACTION(4)
    LET l_tt1 = l_tt
    LET l_tt1 = l_tt1[1,4],l_tt1[6,7],l_tt1[9,10],l_tt1[12,13],l_tt1[15,16],l_tt1[18,19],l_tt1[21,22]
    LET l_tt = (CURRENT YEAR TO FRACTION(4)) USING 'YYYYMMDDHH24MISSFF'
    LET l_tt1 = g_today USING 'YYYYMMDD'," ",TIME

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ART")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time 

    LET g_wc2=' 1=1'
    LET g_wc1=' 1=1'
    LET g_forupd_sql = "SELECT * FROM rbh_file WHERE rbh01 = ? AND rbh02 = ? AND rbh03 =? AND rbhplant = ? FOR UPDATE" 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t404_cl CURSOR FROM g_forupd_sql
 
    LET g_rbh.rbh01 = g_plant
    LET g_argv1     = ARG_VAL(1)         # 參數值(1) - 制定機構
    LET g_argv2     = ARG_VAL(2)           # 參數值(1) - 促銷單號  
    LET g_argv3     = ARG_VAL(3)          # 參數值(3) - 營運中心  
 
    OPEN WINDOW t404_w WITH FORM "art/42f/artt404"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()

###-MOD-B30045- ADD - BEGIN ------------------------------------------
    LET cb = ui.ComboBox.forName("rbh10t")
    CALL cb.removeItem('1')
###-MOD-B30045- ADD -  END  ------------------------------------------
    #FUN-BC0126 add START
    CALL cl_set_comp_visible("rbh14,rbh15,rbh16,rbh17",FALSE)  
    CALL cl_set_comp_visible("rbh14t,rbh15t,rbh16t,rbh17t",FALSE)  
    CALL cl_set_comp_required("rbk14",FALSE)  #FUN-BC0126 add
   #IF g_rbh.rbh10t = 2 THEN   #FUN-C30151 mark
    IF g_rbh.rbh10t = 2 AND g_rbh.rbh25t = '1' THEN   #FUN-C30151 add
       CALL cl_set_comp_visible('rbi13',FALSE)  
       CALL cl_set_comp_visible('rbi13_1',FALSE)   #FUN-C30151 add
       CALL cl_set_comp_visible('dummy27',FALSE)   #FUN-C30151 add
    ELSE
       CALL cl_set_comp_visible('rbi13',TRUE)
       CALL cl_set_comp_visible('rbi13_1',TRUE)   #FUN-C30151 add
       CALL cl_set_comp_visible('dummy27',TRUE)   #FUN-C30151 add
    END IF
    #FUN-BC0126 add END

    LET g_rbh.rbh01=g_plant
    DISPLAY BY NAME g_rbh.rbh01 
    SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01=g_plant
    DISPLAY l_azp02 TO rbh01_desc
    SELECT rtz04 INTO g_rtz04 FROM rtz_file WHERE rtz01=g_plant #FUN-AB0101
    SELECT rtz05 INTO g_rtz05 FROM rtz_file WHERE rtz01=g_plant #�r������ 
    CALL t404_menu()
    CLOSE t404_cl
    CLOSE WINDOW t404_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
#QBE 查詢資料
FUNCTION t404_cs()
   DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = "rbh01 = '",g_argv1,"' "
      IF NOT cl_null(g_argv2) THEN
         LET g_wc = g_wc," AND rbh02='",g_argv2,"'"
         IF NOT cl_null(g_argv3) THEN
            LET g_wc = g_wc," AND rbhplant='",g_argv3,"'"
         END IF
      END IF
      LET g_wc1= " 1=1"
      LET g_wc2= " 1=1"
      LET g_rbh.rbh01=g_argv1
      DISPLAY BY NAME g_rbh.rbh01
      LET g_rbh.rbh02=g_argv2      
      DISPLAY BY NAME g_rbh.rbh02 
      LET g_rbh.rbhplant=g_argv3     
      DISPLAY BY NAME g_rbh.rbhplant 
   ELSE
      CLEAR FORM          
      CALL g_rbi.clear()
      CALL cl_set_head_visible("","YES")   
      INITIALIZE g_rbh.* TO NULL    
#      CONSTRUCT BY NAME g_wc ON rbh01,rbh02,rbh03,rbh26,rbhplant,rbhmksg,rbh900,rbhconf,rbhcond,    #FUN-B30028 mark
       CONSTRUCT BY NAME g_wc ON rbh01,rbh02,rbh03,rbh26,rbhplant,rbhconf,rbhcond,                   #FUN-B30028
                               #rbhconu,rbh24,rbh04,rbh04t,rbh05,rbh05t,rbh06,rbh06t,rbh07,rbh07t,   #FUN-BC0126 mark
                                rbhconu,rbh24,       #FUN-BC0126 add
                                rbh10,rbh10t,
                                rbh11,rbh11t,rbh25,rbh25t,        #FUN-BC0126 add rbh25
                                rbh12,rbh12t,rbh13,rbh13t,rbh14,rbh14t,rbh15,rbh15t,
                                rbh16,rbh16t,rbh17,rbh17t,rbh18,rbh18t,rbh19,rbh19t,
                               #rbh20,rbh20t,rbh21,rbh21t,rbh22,rbh22t,rbh23,rbh23t,  #FUN-BC0126 mark
                                rbhuser,rbhgrup,rbhoriu,rbhmodu,rbhdate,rbhorig,rbhacti,rbhcrat              
         BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
         ON ACTION CONTROLP          
         #FUN-BC0126 add START
            CASE
               WHEN INFIELD(rbh01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rah01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rbh01
                  NEXT FIELD rbh01

               WHEN INFIELD(rbh02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rah02"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rbh02
                  NEXT FIELD rbh02

               WHEN INFIELD(rbhplant)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rahplant"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rbhplant
                  NEXT FIELD rbhplant

               WHEN INFIELD(rbhconu)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rabconu"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rbhconu
                  NEXT FIELD rbhconu

               WHEN INFIELD(rbh26)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rah03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rbh26
                  NEXT FIELD rbh26

               OTHERWISE EXIT CASE
            END CASE
         #FUN-BC0126 add END
 
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
      IF INT_FLAG THEN  RETURN END IF 
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rbhuser', 'rbhgrup')

      DIALOG ATTRIBUTES(UNBUFFERED)    #FUN-BC0126 add

#FUN-BC0126 add START
      CONSTRUCT g_wc3 ON rbk08,rbk09,rbk10,rbk11,rbk12,rbk13,rab14,rbkacti
          FROM s_rbk[1].rbk08,s_rbk[1].rbk09,s_rbk[1].rbk10,
               s_rbk[1].rbk11,s_rbk[1].rbk12,s_rbk[1].rbk13,s_rbk[1].rbk14, s_rbk[1].rbkacti

            BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)
      END CONSTRUCT
#FUN-BC0126 add END
 
      CONSTRUCT g_wc1 ON b.rbi06,b.rbi07,b.rbi08,b.rbi13,b.rbi09,b.rbi10,b.rbi11,b.rbi12,b.rbiacti  #FUN-BC0126 add rbi13
           FROM s_rbi[1].rbi06,s_rbi[1].rbi07,s_rbi[1].rbi08,s_rbi[1].rbi13,s_rbi[1].rbi09,s_rbi[1].rbi10,  #FUN-BC0126 add rbi13
           s_rbi[1].rbi11,s_rbi[1].rbi12,s_rbi[1].rbiacti 

       	BEFORE CONSTRUCT
       	   CALL cl_qbe_display_condition(lc_qbe_sn)
       #FUN-BC0126 mark START
       # ON IDLE g_idle_seconds
       #    CALL cl_on_idle()
       #    CONTINUE CONSTRUCT
 
       # ON ACTION about        
       #    CALL cl_about()     
 
       # ON ACTION help        
       #    CALL cl_show_help() 
 
       # ON ACTION controlg    
       #    CALL cl_cmdask()  

       # ON ACTION qbe_save
       #    CALL cl_qbe_save()
       #FUN-BC0126 mark END
 
      END CONSTRUCT
     #IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF  #FUN-BC0126 mark

      CONSTRUCT g_wc2 ON b.rbj06,b.rbj07,b.rbj08,b.rbj09,b.rbjacti
           FROM s_rbj[1].rbj06,s_rbj[1].rbj07,s_rbj[1].rbj08,s_rbj[1].rbj09,s_rbj[1].rbjacti

         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
       #FUN-BC0126 mark START
       # ON IDLE g_idle_seconds
       #    CALL cl_on_idle()
       #    CONTINUE CONSTRUCT

       # ON ACTION about
       #    CALL cl_about()

       # ON ACTION help
       #    CALL cl_show_help()

       # ON ACTION controlg
       #    CALL cl_cmdask()

       # ON ACTION qbe_save
       #    CALL cl_qbe_save()
       #FUN-BC0126 mark END
      END CONSTRUCT
    #FUN-BC0126 add START
      ON ACTION ACCEPT
          ACCEPT DIALOG

      ON ACTION cancel
         LET INT_FLAG = 1
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION qbe_save
         CALL cl_qbe_save()

    #FUN-BC0126 add END

      IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
      END DIALOG  #FUN-BC0126 add
   END IF

   LET g_wc1 = g_wc1 CLIPPED
   LET g_wc2 = g_wc2 CLIPPED
   LET g_wc  = g_wc  CLIPPED
   LET g_wc3 = g_wc3 CLIPPED  #FUN-BC0126 add

   IF cl_null(g_wc) THEN
      LET g_wc =" 1=1"
   END IF
   IF cl_null(g_wc1) THEN
      LET g_wc1=" 1=1"
   END IF
   IF cl_null(g_wc2) THEN
      LET g_wc2=" 1=1"
   END IF
   #FUN-BC0126 add START
   IF cl_null(g_wc3) THEN
      LET g_wc3 =" 1=1"
   END IF
   #FUN-BC0126 add END

   LET g_sql= "SELECT UNIQUE rbh01,rbh02,rbh03,rbhplant ",
              #FUN-AB0033 -------------start--------------
              "  FROM rbh_file LEFT OUTER JOIN rbi_file b ",
              "      ON (b.rbi01=rbh01 AND b.rbi02=rbh02 AND b.rbi03=rbh03 AND b.rbiplant=rbhplant)",   #FUN-BC0126 add
              " LEFT OUTER JOIN rbj_file b ",
              "      ON (b.rbi01=b.rbj01 AND b.rbi02=b.rbj02 AND b.rbi03=b.rbj03 AND b.rbiplant=b.rbjplant ) ",
              #" WHERE rbh01 = b.rbi01 ",
              #"   AND rbh02 = b.rbi02 ",
              #"   AND rbh03 = b.rbi03 ",
              #"   AND rbhplant = b.rbiplant ",
              "  WHERE ",g_wc1 CLIPPED,
              #FUN-AB0033 --------------end---------------
              "   AND ", g_wc CLIPPED, " AND ", g_wc2 CLIPPED,
              " ORDER BY rbh01,rbh02,rbhplant "   
   PREPARE t404_prepare FROM g_sql      #預備一下
   DECLARE t404_cs                      #宣告成可捲動的
    SCROLL CURSOR WITH HOLD FOR t404_prepare
    
   LET g_sql= "SELECT  COUNT(DISTINCT rbh01||rbh02||rbh03||rbhplant) ",
              #FUN-AB0033 -------------start--------------
              "  FROM  rbh_file LEFT OUTER JOIN rbi_file b ",
              "      ON (b.rbi01=rbh01 AND b.rbi02=rbh02 AND b.rbi03=rbh03 AND b.rbiplant=rbhplant)",   #FUN-BC0126 add
              " LEFT OUTER JOIN rbj_file b ",
              "      ON (b.rbi01=b.rbj01 AND b.rbi02=b.rbj02 AND b.rbi03=b.rbj03 AND b.rbiplant=b.rbjplant ) ",
              #" WHERE  rbh01 = b.rbi01 ",
              #"   AND  rbh02 = b.rbi02 ",
              #"   AND  rbh03 = b.rbi03 ",
              #"   AND  rbhplant = b.rbiplant ",
              "  WHERE ",g_wc1 CLIPPED,
              #FUN-AB0033 --------------end---------------
              "   AND ", g_wc CLIPPED, " AND ", g_wc2 CLIPPED,
              " ORDER BY rbh01,rbh02,rbhplant "
   PREPARE t404_precount FROM g_sql
   DECLARE t404_count CURSOR FOR t404_precount 
END FUNCTION


FUNCTION t404_menu()
   DEFINE l_partnum    STRING
   DEFINE l_supplierid STRING
   DEFINE l_status     LIKE type_file.num10
 
   WHILE TRUE
      CALL t404_bp("G")
      CASE g_action_choice
         WHEN "insert"                  #新增
            IF cl_chk_act_auth() THEN
               CALL t404_a()
            END IF
 
         WHEN "query"                   #查詢
            IF cl_chk_act_auth() THEN
               CALL t404_q()
            END IF
 
         WHEN "delete"                  #刪除
            IF cl_chk_act_auth() THEN
               CALL t404_r()
            END IF
 
         WHEN "modify"                  #修改
            IF cl_chk_act_auth() THEN
               CALL t404_u()
            END IF
 
         WHEN "invalid"                #无效
            IF cl_chk_act_auth() THEN
               CALL t404_x()
            END IF 

         WHEN "detail"                 #單身
            IF cl_chk_act_auth() THEN
              #FUN-BC0126 mark START 
              #IF g_flag_b = '1' THEN
              #   CALL t404_b1()
              #ELSE
              #   CALL t404_b2()
              #END IF
              #FUN-BC0126 mark END
               CALL t404_b()  #FUN-BC0126 add
            ELSE
               LET g_action_choice = NULL
            END IF 

         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
   
         WHEN "alter_organization"           #生效機構
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_rbh.rbh02) THEN
                 CALl t402_1(g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,'3',g_rbh.rbhplant,g_rbh.rbhconf)
               ELSE
                  CALL cl_err('',-400,0)
               END IF
            END IF

         WHEN "alter_Memberlevel"           #會員等級促銷
            IF cl_chk_act_auth() THEN
              IF NOT cl_null(g_rbh.rbh02) THEN
                 IF l_ac1 = 0 THEN LET l_ac1 = 1 END IF  #FUN-BC0126 add
                 IF g_rbi[l_ac1].rbi10 <> '0' THEN  #FUN-BC0126 add
                   #CALl t402_2(g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,'3',g_rbh.rbhplant,g_rbh.rbhconf,g_rbh.rbh10)  #FUN-BC0126 mark
                    CALl t402_2(g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,'3',g_rbh.rbhplant,g_rbh.rbhconf,
                                g_rbh.rbh10t,g_rbi[l_ac1].rbi10,g_rbi[l_ac1].rbi06)  #FUN-BC0126 add  #TQC-C20328 add rbi06 
                 END IF  #FUN-BC0126 add
              ELSE
                 CALL cl_err('',-400,0)
              END IF
            END IF

         WHEN "alter_gift"                 #換贈資料
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_rbh.rbh02) THEN
                  CALL t403_gift(g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,'3',g_rbh.rbhplant,g_rbh.rbhconf,g_rbh.rbh10)
               ELSE
                  CALL cl_err('',-400,0)
               END IF
            END IF
 
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t404_yes()
            END IF
            
        #FUN-AB0033 mark --------------start-----------------    
        #WHEN "void"                  #作廢
        #    IF cl_chk_act_auth() THEN
        #       CALL t404_v()
        #    END IF  
                   
 
        #WHEN "issuance"              #發布
        #   IF cl_chk_act_auth() THEN
        #      CALL t404_iss()
        #   END IF
        #FUN-AB0033 mark ---------------end------------------
        
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rbi),'','')
            END IF
            
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_rbh.rbh02 IS NOT NULL THEN
                 LET g_doc.column1 = "rbh02"
                 LET g_doc.value1 = g_rbh.rbh02
                 CALL cl_doc()
               END IF
         END IF
         
      END CASE
   END WHILE   
  
END FUNCTION

FUNCTION t404_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF 
   LET g_action_choice = " " 
   CALL cl_set_act_visible("accept,cancel", FALSE) 
   DIALOG ATTRIBUTES(UNBUFFERED)

#FUN-BC0126 add START
   #  DISPLAY ARRAY g_rbk TO s_rbk.*  ATTRIBUTE(COUNT=g_rec_b2)    #FUN-D30033
      DISPLAY ARRAY g_rbk TO s_rbk.*  ATTRIBUTE(COUNT=g_rec_b3)    #FUN-D30033

         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            LET g_b_flag = '3'   #FUN-D30033 add

         BEFORE ROW
            LET l_ac2 = ARR_CURR()
            CALL cl_show_fld_cont()
      END DISPLAY
#FUN-BC0126 add END

      DISPLAY ARRAY g_rbi TO s_rbi.* ATTRIBUTE(COUNT=g_rec_b1)
 
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            LET g_b_flag = '1'   #FUN-D30033 add
         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()

       #FUN-BC0126 mark START 
       # ON ACTION insert
       #    LET g_action_choice="insert"
       #    EXIT DIALOG
 
       # ON ACTION query
       #    LET g_action_choice="query"
       #    EXIT DIALOG
 
       # ON ACTION delete
       #    LET g_action_choice="delete"
       #    EXIT DIALOG
 
       # ON ACTION modify
       #    LET g_action_choice="modify"
       #    EXIT DIALOG
 
       # ON ACTION first
       #    CALL t404_fetch('F')
       #    CALL cl_navigator_setting(g_curs_index, g_row_count)
       #    ACCEPT DIALOG
 
       # ON ACTION previous
       #    CALL t404_fetch('P')
       #    CALL cl_navigator_setting(g_curs_index, g_row_count)
       #    ACCEPT DIALOG
 
       # ON ACTION jump
       #    CALL t404_fetch('/')
       #    CALL cl_navigator_setting(g_curs_index, g_row_count)
       #    ACCEPT DIALOG
 
       # ON ACTION next
       #    CALL t404_fetch('N')
       #    CALL cl_navigator_setting(g_curs_index, g_row_count)
       #    ACCEPT DIALOG
 
       # ON ACTION last
       #    CALL t404_fetch('L')
       #    CALL cl_navigator_setting(g_curs_index, g_row_count)
       #    ACCEPT DIALOG
 
       # ON ACTION invalid
       #    LET g_action_choice="invalid"
       #    EXIT DIALOG 

       # ON ACTION detail
       #    LET g_action_choice = "detail"
       #    LET g_flag_b = '1'
       #    LET l_ac1 = 1
       #    EXIT DIALOG

       # ON ACTION help
       #    LET g_action_choice = "help"
       #    EXIT DIALOG

       # ON ACTION locale
       #    CALL cl_dynamic_locale()
       #    CALL cl_show_fld_cont()
 
       # ON ACTION exit
       #    LET g_action_choice = "exit"
       #    EXIT DIALOG
      
       # ON ACTION alter_organization                #生效機構
       #    LET g_action_choice =  "alter_organization" 
       #    EXIT DIALOG

       # ON ACTION alter_Memberlevel                 #會員促銷
       #    LET g_action_choice = "alter_Memberlevel"
       #    EXIT DIALOG

       # ON ACTION alter_gift
       #    LET g_action_choice = "alter_gift"
       #    EXIT DIALOG 
       #    
       # #FUN-AB0033 mark ----------start-----------   
       # #ON ACTION void
       # #   LET g_action_choice="void"
       # #   EXIT DIALOG
       # 
       # #ON ACTION issuance                   #發布     
       # #   LET g_action_choice = "issuance"  
       # #   EXIT DIALOG
       # #FUN-AB0033 mark -----------end------------  

       # ON ACTION confirm
       #    LET g_action_choice = "confirm"
       #    EXIT DIALOG

       # 
       #                                                                                                                            
       # ON ACTION controlg
       #    LET g_action_choice="controlg"
       #    EXIT DIALOG
 
       # ON ACTION accept
       #    LET g_action_choice="detail"
       #    LET g_flag_b = '1'
       #    LET l_ac1 = ARR_CURR()
       #    EXIT DIALOG
 
       # ON ACTION cancel
       #    LET INT_FLAG=FALSE
       #    LET g_action_choice="exit"
       #    EXIT DIALOG
 
       # ON IDLE g_idle_seconds
       #    CALL cl_on_idle()
       #    CONTINUE DIALOG
 
       # ON ACTION about 
       #    CALL cl_about()
 
       # ON ACTION exporttoexcel
       #    LET g_action_choice = 'exporttoexcel'
       #    EXIT DIALOG
 
       # AFTER DISPLAY
       #    CONTINUE DIALOG
 
       # ON ACTION controls       
       #    CALL cl_set_head_visible("","AUTO")
 
       # ON ACTION related_document
       #    LET g_action_choice="related_document"          
       #    EXIT DIALOG
       #FUN-BC0126 mark END
      END DISPLAY 
    
      DISPLAY ARRAY g_rbj TO s_rbj.* ATTRIBUTE(COUNT=g_rec_b2)
 
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            LET g_b_flag = '2'   #FUN-D30033 add
         BEFORE ROW
            LET l_ac2 = ARR_CURR()
            CALL cl_show_fld_cont()

       #FUN-BC0126 mark START 
       # ON ACTION insert
       #    LET g_action_choice="insert"
       #    EXIT DIALOG
 
       # ON ACTION query
       #    LET g_action_choice="query"
       #    EXIT DIALOG
 
       # ON ACTION delete
       #    LET g_action_choice="delete"
       #    EXIT DIALOG
 
       # ON ACTION modify
       #    LET g_action_choice="modify"
       #    EXIT DIALOG
 
       # ON ACTION first
       #    CALL t404_fetch('F')
       #    CALL cl_navigator_setting(g_curs_index, g_row_count)
       #    ACCEPT DIALOG
 
       # ON ACTION previous
       #    CALL t404_fetch('P')
       #    CALL cl_navigator_setting(g_curs_index, g_row_count)
       #    ACCEPT DIALOG
 
       # ON ACTION jump
       #    CALL t404_fetch('/')
       #    CALL cl_navigator_setting(g_curs_index, g_row_count)
       #    ACCEPT DIALOG
 
       # ON ACTION next
       #    CALL t404_fetch('N')
       #    CALL cl_navigator_setting(g_curs_index, g_row_count)
       #    ACCEPT DIALOG
 
       # ON ACTION last
       #    CALL t404_fetch('L')
       #    CALL cl_navigator_setting(g_curs_index, g_row_count)
       #    ACCEPT DIALOG
 
       # ON ACTION invalid
       #    LET g_action_choice="invalid"
       #    EXIT DIALOG

       # ON ACTION detail
       #    LET g_action_choice="detail"
       #    LET g_flag_b = '2'
       #    LET l_ac2 = 1
       #    EXIT DIALOG
 
       # ON ACTION help
       #    LET g_action_choice = "help"
       #    EXIT DIALOG
 
       # ON ACTION locale
       #    CALL cl_dynamic_locale()
       #    CALL cl_show_fld_cont()
 
       # ON ACTION exit
       #    LET g_action_choice = "exit"
       #    EXIT DIALOG
      
       # ON ACTION confirm
       #    LET g_action_choice = "confirm"
       #    EXIT DIALOG

       # ON ACTION alter_Memberlevel                 #會員促銷
       #    LET g_action_choice = "alter_Memberlevel"
       #    EXIT DIALOG
       #
       # #FUN-AB0033 mark ------start------
       # #ON ACTION issuance                    #發布      
       # #   LET g_action_choice = "issuance"  
       # #   EXIT DIALOG
       # #FUN-AB0033 mark -------end-------     
       #                                                                                                                            
       # ON ACTION alter_organization               #生效機構
       #    LET g_action_choice = "alter_organization" 
       #    EXIT DIALOG
       #ON ACTION alter_gift
       #    LET g_action_choice = "alter_gift"
       #    EXIT DIALOG      

       # ON ACTION controlg
       #    LET g_action_choice="controlg"
       #    EXIT DIALOG
 
       # ON ACTION accept
       #    LET g_action_choice="detail"
       #    LET g_flag_b = '2'
       #    LET l_ac2 = ARR_CURR()
       #    EXIT DIALOG
 
       # ON ACTION cancel
       #    LET INT_FLAG=FALSE
       #    LET g_action_choice="exit"
       #    EXIT DIALOG
 
       # ON IDLE g_idle_seconds
       #    CALL cl_on_idle()
       #    CONTINUE DIALOG
 
       # ON ACTION about 
       #    CALL cl_about()
 
       # ON ACTION exporttoexcel
       #    LET g_action_choice = 'exporttoexcel'
       #    EXIT DIALOG
 
       # ON ACTION controls       
       #    CALL cl_set_head_visible("","AUTO")
 
       # ON ACTION related_document
       #    LET g_action_choice="related_document"          
       #    EXIT DIALOG
       #FUN-BC0126 mark END
      END DISPLAY
#FUN-BC0126 add START
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
            CALL t404_fetch('F')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG

         ON ACTION previous
            CALL t404_fetch('P')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG

         ON ACTION jump
            CALL t404_fetch('/')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG

         ON ACTION next
            CALL t404_fetch('N')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG

         ON ACTION last
            CALL t404_fetch('L')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG

         ON ACTION invalid
            LET g_action_choice="invalid"
            EXIT DIALOG

         ON ACTION detail
            LET g_action_choice="detail"
            LET g_flag_b = '2'
            LET l_ac2 = 1
            EXIT DIALOG

         ON ACTION help
            LET g_action_choice = "help"
            EXIT DIALOG

         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()

         ON ACTION exit
            LET g_action_choice = "exit"
            EXIT DIALOG

         ON ACTION confirm
            LET g_action_choice = "confirm"
            EXIT DIALOG

         ON ACTION alter_Memberlevel                 #會員促銷
            LET g_action_choice = "alter_Memberlevel"
            EXIT DIALOG

         #FUN-AB0033 mark ------start------
         #ON ACTION issuance                    #發布
         #   LET g_action_choice = "issuance"
         #   EXIT DIALOG
         #FUN-AB0033 mark -------end-------

         ON ACTION alter_organization               #生效機構
            LET g_action_choice = "alter_organization"
            EXIT DIALOG
        ON ACTION alter_gift
            LET g_action_choice = "alter_gift"
            EXIT DIALOG

         ON ACTION controlg
            LET g_action_choice="controlg"
            EXIT DIALOG

         ON ACTION accept
            LET g_action_choice="detail"
            LET g_flag_b = '2'
            LET l_ac2 = ARR_CURR()
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
#FUN-BC0126 add END
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)  
END FUNCTION
#Query 查詢
FUNCTION t404_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   CALL cl_msg("")    
 
   CLEAR FORM
   CALL g_rbi.clear()
   CALL g_rbj.clear()  #TQC-C20002 add
   CALL g_rbk.clear()  #TQC-C20002 add
   #CALL cl_set_comp_visible("rbh20,rbh21,rbh22,rbh23",TRUE)
   #CALL cl_set_comp_visible("rbh15,rbh16,rbh17",TRUE)
   CALL t404_cs()                     #取得查詢條件
   IF INT_FLAG THEN                  #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN t404_cs                      #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_rbh.rbh02 TO NULL
   ELSE
      CALL t404_fetch('F')             #讀出TEMP第一筆並顯示
      OPEN t404_count
      FETCH t404_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
  END IF 
END FUNCTION


#處理資料的讀取
FUNCTION t404_fetch(p_flag)
    DEFINE  p_flag          LIKE type_file.chr1      #處理方式
    CALL cl_msg("")
    CASE p_flag
       WHEN 'N' FETCH NEXT     t404_cs INTO g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,g_rbh.rbhplant
       WHEN 'P' FETCH PREVIOUS t404_cs INTO g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,g_rbh.rbhplant
       WHEN 'F' FETCH FIRST    t404_cs INTO g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,g_rbh.rbhplant
       WHEN 'L' FETCH LAST     t404_cs INTO g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,g_rbh.rbhplant
       WHEN '/'
          IF (NOT g_no_ask) THEN
              CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
              LET INT_FLAG = 0         #add for prompt bug
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
          FETCH ABSOLUTE g_jump t404_cs INTO g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,g_rbh.rbhplant
          LET g_no_ask = FALSE
    END CASE 
    IF SQLCA.sqlcode THEN                         
        INITIALIZE g_rbh.* TO NULL 
        CALL cl_err(g_rbh.rbh01,SQLCA.sqlcode,0)
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
    SELECT * INTO g_rbh.* FROM rbh_file
     WHERE rbh01 = g_rbh.rbh01 AND rbh02 = g_rbh.rbh02 
       AND rbh03 = g_rbh.rbh03 AND rbhplant = g_rbh.rbhplant
    IF SQLCA.sqlcode THEN                        
        CALL cl_err(g_rbh.rbh01,SQLCA.sqlcode,0)
        INITIALIZE g_rbh.* TO NULL   
        RETURN
    END IF
    LET g_data_owner = g_rbh.rbhuser     
    LET g_data_group = g_rbh.rbhgrup    
    LET g_data_plant = g_rbh.rbhplant 
    CALL t404_show() 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t404_show()
    DEFINE  l_gen02  LIKE gen_file.gen02
    DEFINE  l_azp02  LIKE azp_file.azp02
    DEFINE  l_raa03  LIKE raa_file.raa03
    LET g_rbh_t.* = g_rbh.*
    LET g_rbh_o.* = g_rbh.*
#    DISPLAY BY NAME g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,g_rbh.rbh26,g_rbh.rbhplant,g_rbh.rbhmksg,g_rbh.rbh900,   #FUN-B30028 mark
     DISPLAY BY NAME g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,g_rbh.rbh26,g_rbh.rbhplant,                               #FUN-B30028
                    g_rbh.rbhconf,g_rbh.rbhcond,g_rbh.rbhconu,g_rbh.rbh24,
                   #g_rbh.rbh04,  #FUN-BC0126 mark
                   #g_rbh.rbh04t,g_rbh.rbh05,g_rbh.rbh05t,g_rbh.rbh06,g_rbh.rbh06t,g_rbh.rbh07,g_rbh.rbh07t,  #FUN-BC0126 mark
                    g_rbh.rbh10,g_rbh.rbh10t,g_rbh.rbh11,g_rbh.rbh11t,g_rbh.rbh25,g_rbh.rbh25t,  #FUN-BC0126 add rbh25
                    g_rbh.rbh12,g_rbh.rbh12t,g_rbh.rbh13,
                    g_rbh.rbh13t,g_rbh.rbh14,g_rbh.rbh14t,g_rbh.rbh15,g_rbh.rbh15t,g_rbh.rbh16,g_rbh.rbh16t,
                    g_rbh.rbh17,g_rbh.rbh17t,g_rbh.rbh18,g_rbh.rbh18t,g_rbh.rbh19,g_rbh.rbh19t,
                   #g_rbh.rbh20,  #FUN-BC0126 mark
                   #g_rbh.rbh20t,g_rbh.rbh21,g_rbh.rbh21t,g_rbh.rbh22,g_rbh.rbh22t,g_rbh.rbh23,g_rbh.rbh23t,  #FUN-BC0126 mark
                    g_rbh.rbhuser,g_rbh.rbhgrup,g_rbh.rbhoriu,g_rbh.rbhmodu,g_rbh.rbhdate,g_rbh.rbhorig,
                    g_rbh.rbhacti,g_rbh.rbhcrat
    #CALL cl_set_comp_visible("rbh20,rbh21,rbh22,rbh23",g_rbh.rbh27='Y')
    #CALL cl_set_comp_visible("rbh15,rbh16,rbh17",g_rbh.rbh11='N')
    SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rbh.rbh01
    DISPLAY l_azp02 TO FORMONLY.rbh01_desc
    SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rbh.rbhplant
    DISPLAY l_azp02 TO FORMONLY.rbhplant_desc
    SELECT raa03 INTO l_raa03 FROM raa_file WHERE raa01 = g_rbh.rbh01 AND raa02 = g_rbh.rbh26
    DISPLAY l_raa03 TO FORMONLY.rbh26_desc
    SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_rbh.rbhconu
    DISPLAY l_gen02 TO FORMONLY.rbhconu_desc
    IF NOT g_rbh.rbhconf='X' THEN LET g_chr='N' END IF 
    CALL cl_set_field_pic(g_rbh.rbhconf,"","","",g_chr,"")
   #CALL cl_set_act_visible("gift",g_rbh.rbh19t='Y')  #FUN-BC0126 mark
    CALL cl_set_act_visible("alter_gift",g_rbh.rbh19t='Y')  #FUN-BC0126 add
    #FUN-BC0126 add START
   #IF g_rbh.rbh10t = 2 THEN  #FUN-C30151 mark
    IF g_rbh.rbh10t = 2 AND g_rbh.rbh25t = '1' THEN  #FUN-C30151 add
       CALL cl_set_comp_visible('rbi13',FALSE)  
       CALL cl_set_comp_visible('rbi13_1',FALSE)   #FUN-C30151 add 
       CALL cl_set_comp_visible('dummy27',FALSE)   #FUN-C30151 add
    ELSE
       CALL cl_set_comp_visible('rbi13',TRUE)
       CALL cl_set_comp_visible('rbi13_1',TRUE)   #FUN-C30151 add
       CALL cl_set_comp_visible('dummy27',TRUE)   #FUN-C30151 add
    END IF
    #FUN-BC0126 add END
    CALL t404_rbh10t()
    CALL t404_rbh11t()
    CALL t404_rbi13_text()   #FUN-C30151 add 
    CALL t404_b1_fill(g_wc1)         #單身1
    CALL t404_b2_fill(g_wc2)          #單身2
    CALL t404_b3_fill(g_wc3)  #FUN-BC0126 add
    CALL cl_show_fld_cont()          
END FUNCTION
 
FUNCTION t404_b1_fill(p_wc1)              #單身1
    DEFINE p_wc1        STRING 
    LET g_sql = " SELECT '',a.rbi05,a.rbi06,a.rbi07,a.rbi08,a.rbi13,a.rbi09,a.rbi10,a.rbi11,a.rbi12,a.rbiacti,",  #FUN-BC0126 add 
                "           b.rbi05,b.rbi06,b.rbi07,b.rbi08,b.rbi13,b.rbi09,b.rbi10,b.rbi11,b.rbi12,b.rbiacti ",  #FUN-BC0126 add rbi13
                "   FROM rbi_file b LEFT OUTER JOIN rbi_file a",
                "     ON (b.rbi01=a.rbi01 AND b.rbi02=a.rbi02 AND b.rbi03=a.rbi03 AND ",
                "         b.rbi04=a.rbi04 AND b.rbi06=a.rbi06 AND b.rbiplant=a.rbiplant AND b.rbi05<>a.rbi05 ) ",
                "  WHERE b.rbi01 = '",g_rbh.rbh01, "' AND b.rbiplant='",g_rbh.rbhplant,"'",
                "    AND b.rbi05='1' ",  #AND a.rbi05='0' ",
                "    AND b.rbi02 = '",g_rbh.rbh02, "' AND b.rbi03=",g_rbh.rbh03," AND ", p_wc1 CLIPPED,
                "  ORDER BY b.rbi04 " 
    PREPARE t404_b1_prepare FROM g_sql                     
    DECLARE rbi_cs CURSOR FOR t404_b1_prepare
    CALL g_rbi.clear()
    LET g_rec_b1 = 0
    LET g_cnt = 1
    FOREACH rbi_cs INTO g_rbi[g_cnt].*
        IF SQLCA.sqlcode THEN
           CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
 
        IF g_rbi[g_cnt].before='0' THEN
           LET g_rbi[g_cnt].type='1'
        ELSE 
           LET g_rbi[g_cnt].type='0'
        END IF
       
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_rbi.deleteElement(g_cnt)
    CALL cl_set_comp_entry("type",FALSE) 
    LET g_rec_b1 = g_cnt-1
    DISPLAY g_rec_b1 TO FORMONLY.cn1
END FUNCTION
 
FUNCTION t404_b2_fill(p_wc2)              #單身2
    DEFINE p_wc2          STRING 
    LET g_sql = " SELECT '',a.rbj05,a.rbj06,a.rbj07,a.rbj08,'',a.rbj09,'',a.rbjacti, ",
                "           b.rbj05,b.rbj06,b.rbj07,b.rbj08,'',b.rbj09,'',b.rbjacti  ",
                "   FROM rbj_file b LEFT OUTER JOIN rbj_file a",
                "     ON (b.rbj01=a.rbj01 AND b.rbj02=a.rbj02 AND b.rbj03=a.rbj03 AND b.rbj04=a.rbj04 AND ",
                "         b.rbj06=a.rbj06 AND b.rbj07=a.rbj07 AND b.rbjplant=a.rbjplant AND b.rbj05<>a.rbj05 ) ",
                "  WHERE b.rbj01 = '",g_rbh.rbh01, "' AND b.rbjplant='",g_rbh.rbhplant,"'",
                "    AND b.rbj05='1'  ", #AND a.rbj05='0' ",
                "    AND b.rbj02 = '",g_rbh.rbh02, "' AND b.rbj03=",g_rbh.rbh03," AND ", p_wc2 CLIPPED,
                "  ORDER BY b.rbj04 " 
    PREPARE t404_b2_prepare FROM g_sql                     
    DECLARE rbj_cs CURSOR FOR t404_b2_prepare
    CALL g_rbj.clear()
    LET g_rec_b2 = 0
    LET g_cnt = 1
    FOREACH rbj_cs INTO g_rbj[g_cnt].*
        IF SQLCA.sqlcode THEN
           CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
 
        IF g_rbj[g_cnt].before1='0' THEN
           LET g_rbj[g_cnt].type1='1'
        ELSE 
           LET g_rbj[g_cnt].type1='0'
        END IF
        SELECT gfe02 INTO g_rbj[g_cnt].rbj09_desc FROM gfe_file
           WHERE gfe01 = g_rbj[g_cnt].rbj09
        SELECT gfe02 INTO g_rbj[g_cnt].rbj09_desc_1 FROM gfe_file
           WHERE gfe01 = g_rbj[g_cnt].rbj09  
        CALL t404_rbj08('d',g_cnt)
        CALL t404_rbj08_1('d',g_cnt)            
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_rbj.deleteElement(g_cnt)
    CALL cl_set_comp_entry("type1",FALSE) 
    LET g_rec_b2 = g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cn2
END FUNCTION

FUNCTION t404_a()
    DEFINE l_n    LIKE  type_file.num5  
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_rbi.clear()
    CALL g_rbj.clear()
    CALL g_rbk.clear()  #FUN-BC0126 add

    INITIALIZE g_rbh.* LIKE rbh_file.*               #DEFAULT 設定
    INITIALIZE g_rbh_t.* LIKE rbh_file.*            #DEFAULT 設定
    INITIALIZE g_rbh_o.* LIKE rbh_file.*             #DEFAULT 設定
    LET g_rbh.rbh01 = g_plant 
    CALL cl_opmsg('a')
    WHILE TRUE       
     #FUN-BC0126 mark START
     #LET g_rbh.rbh04 = g_today        #促銷開始日期
     #LET g_rbh.rbh05 = g_today        #促銷結束日期
     #LET g_rbh.rbh06 = '00:00:00'     #促銷開始時間
     #LET g_rbh.rbh07 = '23:59:59'     #促銷結束時間
     #FUN-BC0126 mark END
      LET g_rbh.rbh10 = '2'
      LET g_rbh.rbh11 = '1'
      LET g_rbh.rbh12 = 'N'
      LET g_rbh.rbh13 = 'N'
      LET g_rbh.rbh14 = 'N'
      LET g_rbh.rbh15 = 'Y'             
                    
     #FUN-BC0126 mark START
     #LET g_rbh.rbh04t = g_today        
     #LET g_rbh.rbh05t = g_today       
     #LET g_rbh.rbh06t = '00:00:00'     
     #LET g_rbh.rbh07t = '23:59:59'     
     #FUN-BC0126 mark END
      LET g_rbh.rbh10t = '2'
      LET g_rbh.rbh11t = '1'
      LET g_rbh.rbh12t = 'N'
      LET g_rbh.rbh13t = 'N'
      LET g_rbh.rbh14t = 'N'
      LET g_rbh.rbh15t = 'Y'          
            

      LET g_rbh.rbh08 = 'N'    #no use
      LET g_rbh.rbh09 = 'N'    #no use
      LET g_rbh.rbh08t = 'N'   #no use
      LET g_rbh.rbh09t = 'N'   #no use        


      LET g_rbh.rbh16 = 'N'
      LET g_rbh.rbh17 = 'N'
      LET g_rbh.rbh18 = 'N'
      LET g_rbh.rbh16t = 'N'
      LET g_rbh.rbh17t = 'N'
      LET g_rbh.rbh18t = 'N'
     
      
      
      LET g_rbh.rbh19 = 'N'
     #FUN-BC0126 mark START
     #LET g_rbh.rbh20 = '1'
     #LET g_rbh.rbh21 = '1'
     #LET g_rbh.rbh22 = '1'
     #LET g_rbh.rbh23 = 1
     #FUN-BC0126 mark END     
 
      LET g_rbh.rbh19t = 'N'
     #FUN-BC0126 mark START
     #LET g_rbh.rbh20t = '1'
     #LET g_rbh.rbh21t = '1'
     #LET g_rbh.rbh22t = '1'
     #LET g_rbh.rbh23t = 1
     #FUN-BC0126 mark END
      
      LET g_rbh.rbh25 = '1'
      LET g_rbh.rbh25t = '1'
      LET g_rbh.rbh900   = '0'
      LET g_rbh.rbhconf  = 'N'
      LET g_rbh.rbhmksg  = 'N'
      LET g_rbh.rbhacti  = 'Y'
      LET g_rbh.rbhuser  = g_user
      LET g_rbh.rbhoriu  = g_user  
      LET g_rbh.rbhorig  = g_grup  
      LET g_rbh.rbhgrup  = g_grup
      LET g_rbh.rbhcrat  = g_today
      LET g_rbh.rbhplant = g_plant
      LET g_rbh.rbhlegal = g_legal
      LET g_data_plant   = g_plant      
 
      SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rbh.rbh01
      DISPLAY l_azp02 TO rbh01_desc
     #SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_reb.rbhplant  #FUN-BC0126 mark
      SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rbh.rbhplant  #FUN-BC0126 add
      DISPLAY l_azp02 TO rbhplant_desc
        
      CALL t404_i("a")                   
      IF INT_FLAG THEN                   
         INITIALIZE g_rbh.* TO NULL
         LET INT_FLAG = 0
         EXIT WHILE
      END IF
      IF cl_null(g_rbh.rbh02) THEN
         CONTINUE WHILE
      END IF
      #FUN-BC0126 add START
      IF cl_null(g_rbh.rbh20) THEN LET g_rbh.rbh20 = ' ' END IF
      IF cl_null(g_rbh.rbh20t) THEN LET g_rbh.rbh20t = ' ' END IF
      IF cl_null(g_rbh.rbh21) THEN LET g_rbh.rbh21 = ' ' END IF
      IF cl_null(g_rbh.rbh21t) THEN LET g_rbh.rbh21t = ' ' END IF
      IF cl_null(g_rbh.rbh22) THEN LET g_rbh.rbh22 = ' ' END IF
      IF cl_null(g_rbh.rbh22t) THEN LET g_rbh.rbh22t = ' ' END IF
      #FUN-BC0126 add END    
      BEGIN WORK
         INSERT INTO rbh_file VALUES(g_rbh.*)
         IF SQLCA.sqlcode THEN
         #   ROLLBACK WORK        # FUN-B80085---回滾放在報錯後---
            CALL cl_err3("ins","rbh_file",g_rbh.rbh02,"",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK         #FUN-B80085--add--
            CONTINUE WHILE
         END IF

      SELECT * INTO g_rbh.* FROM rbh_file
       WHERE rbh01 = g_rbh.rbh01 AND rbh02 = g_rbh.rbh02
         AND rbh03 = g_rbh.rbh03 AND rbhplant = g_rbh.rbhplant
        LET g_rbh_t.* = g_rbh.*
        LET g_rbh_o.* = g_rbh.*
       #CALL cl_set_act_visible("gift",g_rbh.rbh19t='Y')  #FUN-BC0126 mark
        CALL cl_set_act_visible("alter_gift",g_rbh.rbh19t='Y')  #FUN-BC0126 add
        #CALL t402_1(g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,'3',g_rbh.rbhplant,g_rbh.rbhconf) #FUN-AB0033 mark
        CALL g_rbi.clear()
        CALL g_rbj.clear() 
        CALL g_rbk.clear()  #FUN-BC0126 add
        CALL t404_rbh10t()
        CALL t404_rbh11t()
        LET g_rec_b1 = 0
        LET g_rec_b2 = 0
        LET g_rec_b3 = 0 #FUN-BC0126 add
       #FUN-BC0126 mark START
       #CALL t404_b1()
       #CALL t404_b2() 
       #FUN-BC0126 mark END
        CALL t404_b()  #FUN-BC0126 add
        EXIT WHILE
    END WHILE
END FUNCTION


#單頭
FUNCTION t404_i(p_cmd)
    DEFINE     p_cmd           LIKE type_file.chr1,     
               l_cmd           LIKE type_file.chr1000, 
               l_rbh03         LIKE type_file.num5,    
               l_n             LIKE type_file.num5 
    DEFINE     l_date          LIKE rbh_file.rbh04
    DEFINE     l_time1         LIKE type_file.num5
    DEFINE     l_time2         LIKE type_file.num5
    DEFINE     l_price         LIKE rbh_file.rbh15
    DEFINE     l_discount      LIKE rbh_file.rbh16

    
    
    CALL cl_set_head_visible("","YES") 

    
#    DISPLAY BY NAME g_rbh.rbh01,g_rbh.rbhplant,g_rbh.rbhmksg,g_rbh.rbh900,g_rbh.rbhconf,        #FUN-B30028 mark
     DISPLAY BY NAME g_rbh.rbh01,g_rbh.rbhplant,g_rbh.rbhconf,                                   #FUN-B30028
                    g_rbh.rbhoriu,g_rbh.rbhorig,g_rbh.rbhuser,
                    g_rbh.rbhgrup,g_rbh.rbhcrat,g_rbh.rbhacti    
#    INPUT BY NAME g_rbh.rbh02,g_rbh.rbhmksg,g_rbh.rbh04t,g_rbh.rbh05t,g_rbh.rbh06t,             #FUN-B30028 mark
     INPUT BY NAME g_rbh.rbh02,
                 #g_rbh.rbh04t,g_rbh.rbh05t,g_rbh.rbh06t,                           #FUN-B30028       #FUN-BC0126 mark
                 #g_rbh.rbh07t,  #FUN-BC0126 mark
                  g_rbh.rbh10t,g_rbh.rbh11t,g_rbh.rbh25t,  #FUN-BC0126 add rbh25
                  g_rbh.rbh12t,g_rbh.rbh13t,
                  g_rbh.rbh14t,g_rbh.rbh15t,g_rbh.rbh16t,g_rbh.rbh17t,g_rbh.rbh18t,
                  g_rbh.rbh19t
                 #g_rbh.rbh20t,g_rbh.rbh21t,g_rbh.rbh22t,g_rbh.rbh23t  #FUN-BC0126 mark
                  WITHOUT DEFAULTS
     
        BEFORE INPUT
         
           CALL cl_set_docno_format("rbh02")
           LET  g_before_input_done = FALSE
           CALL t404_set_entry(p_cmd)
           CALL t404_set_no_entry(p_cmd)
          # CALL t404_rbh10t_entry(g_rbh.rbh10t)
           LET  g_before_input_done = TRUE
           CALL cl_set_comp_entry("rbh23t",g_rbh.rbh22t<>'1')
           #CALL cl_set_comp_visible("rbh20t,rbh21t,rbh22t,rbh23t",g_rbh.rbh19t='Y')
           #CALL cl_set_comp_visible("rbh15t,rbh16t,rbh17t",g_rbh.rbh11t='N')
###-MOD-B30045- ADD - BEGIN -------------------------------
          #FUN-BC0126 mark START
          #IF g_rbh.rbh19t = 'Y' THEN
          #   CALL cl_set_comp_entry("rbh20t,rbh21t,rbh22t,rbh23t",TRUE)
          #ELSE
          #   CALL cl_set_comp_entry("rbh20t,rbh21t,rbh22t,rbh23t",FALSE)
          #END IF
          #FUN-BC0126 mark END
###-MOD-B30045- ADD -  end  -------------------------------

        AFTER FIELD rbh02                    #促銷單號̖
            IF NOT cl_null(g_rbh.rbh02) THEN
               IF cl_null(g_rbh_t.rbh02) OR (g_rbh.rbh02 != g_rbh_t.rbh02) THEN
                  CALL t404_rbh02()  
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_rbh.rbh02,g_errno,0)
                     NEXT FIELD rbh02
                  END IF
               END IF
            ELSE
               NEXT FIELD rbh02
         END IF
        #FUN-AB0033 mark ------------start-----------------
        #AFTER FIELD rbh04t,rbh05t  
        #   LET l_date = FGL_DIALOG_GETBUFFER()
        #   IF p_cmd='a' OR (p_cmd='u' AND 
        #      (DATE(l_date)<>g_rbh_t.rbh04t OR DATE(l_date)<>g_rbh_t.rbh05t)) THEN 
        #       IF INFIELD(rbh04t) THEN
        #          IF NOT cl_null(g_rbh.rbh05t) THEN
        #             IF DATE(l_date)>g_rbh.rbh05t THEN
        #                CALL cl_err('','art-201',0)
        #                NEXT FIELD rbh04t
        #             END IF
        #          END IF
        #       END IF
        #       IF INFIELD(rbh05t) THEN
        #          IF NOT cl_null(g_rbh.rbh04t) THEN
        #             IF DATE(l_date)<g_rbh.rbh04t THEN
        #                CALL cl_err('','art-201',0)
        #                NEXT FIELD rbh05t
        #             END IF
        #          END IF
        #       END IF 
        #   END IF
        #FUN-AB0033 mark -------------end------------------   
      #FUN-BC0126 mark START
      #AFTER FIELD rbh06t  
      #  IF NOT cl_null(g_rbh.rbh06t) THEN
      #     IF p_cmd = "a" OR                    
      #            (p_cmd = "u" AND g_rbh.rbh06t<>g_rbh_t.rbh06t) THEN 
      #        CALL t404_chktime(g_rbh.rbh06t) RETURNING l_time1
      #        IF NOT cl_null(g_errno) THEN
      #            CALL cl_err('',g_errno,0)
      #            NEXT FIELD rbh06t
      #        ELSE
      #          IF NOT cl_null(g_rbh.rbh07t) THEN
      #             CALL t404_chktime(g_rbh.rbh07t) RETURNING l_time2
      #             IF l_time1>=l_time2 THEN
      #                CALL cl_err('','art-207',0)
      #                NEXT FIELD rbh06t   
      #             END IF
      #          END IF
      #        END IF
      #      END IF
      #  END IF
      #  
      #AFTER FIELD rbh07t  
      #  IF NOT cl_null(g_rbh.rbh07t) THEN
      #     IF p_cmd = "a" OR                    
      #            (p_cmd = "u" AND g_rbh.rbh07<>g_rbh_t.rbh07t) THEN 
      #         CALL t404_chktime(g_rbh.rbh07) RETURNING l_time2
      #         IF NOT cl_null(g_errno) THEN
      #            CALL cl_err('',g_errno,0)
      #            NEXT FIELD rbh07t
      #         ELSE
      #            IF NOT cl_null(g_rbh.rbh06t) THEN
      #               CALL t404_chktime(g_rbh.rbh06t) RETURNING l_time1
      #               IF l_time1>=l_time2 THEN
      #                  CALL cl_err('','art-207',0)
      #                  NEXT FIELD rbh07t
      #               END IF
      #            END IF
      #         END IF
      #     END IF
      #  END IF  
      #FUN-BC0126 mark END     

      ON CHANGE rbh10t #促銷方式
          CALL t404_rbh10t()
      AFTER FIELD rbh10t
#FUN-B80095 Mark Begin ---
#去除滿額促銷作業中的邏輯判斷：條件規則為2:滿量時促銷方式只能選2:折扣且不可設置分段計算!
####-MOD-B30045- ADD - BEGIN ------------------------------------
#         IF g_rbh.rbh25 = '2' AND (g_rbh.rbh10t = '3' OR g_rbh.rbh12t = 'Y') THEN
#            CALL cl_err('','art-133',0)
#            NEXT FIELD rbh10t
#         END IF
####-MOD-B30045- ADD -  END  ------------------------------------
#FUN-B80095 Mark End -----
         CALL t404_rbh10t()

#FUN-B80095 Mark Begin ---
#去除滿額促銷作業中的邏輯判斷：條件規則為2:滿量時促銷方式只能選2:折扣且不可設置分段計算!         
####-MOD-B30045- ADD - BEGIN ------------------------------------
#      AFTER FIELD rbh12t
#         IF g_rbh.rbh25 = '2' AND (g_rbh.rbh10t = '3' OR g_rbh.rbh12t = 'Y') THEN
#            CALL cl_err('','art-133',0)
#            NEXT FIELD rbh12t
#         END IF
####-MOD-B30045- ADD -  END  ------------------------------------
#FUN-B80095 Mark End -----

      ON CHANGE rbh11t #參與方式
         IF NOT cl_null(g_rbh.rbh11t) THEN
            IF g_rbh.rbh11t='1' THEN
               SELECT COUNT(*) INTO l_n 
                 FROM rbj_file
                WHERE rbj01=g_rbh.rbh01 AND rbj02=g_rbh.rbh02
                  AND rbjplant=g_rbh.rbhplant
               IF l_n>0 THEN
                  CALL cl_err(g_rbh.rbh02,'art-668',0) 
                  LET g_rbh.rbh11t=g_rbh_t.rbh11t
               END IF
                 #IF cl_confirm('art-668') THEN
                 #   IF cl_confirm('art-669') THEN
                 #      DELETE FROM raj_file
                 #       WHERE raj01=g_rah.rah01 AND raj02=g_rah.rah02
                 #         AND rajplant=g_rah.rahplant 
                 #      CALL g_raj.clear()
                 #   ELSE
                 #      LET g_rah.rah11=g_rah_t.rah11
                 #   END IF
                 #ELSE
                 #   LET g_rah.rah11=g_rah_t.rah11
                 #END IF
            END IF
         END IF 
         CALL t404_rbh11t()
      AFTER FIELD rbh11t #參與方式
         CALL t404_rbh11t()
      ON CHANGE rbh19t
###-MOD-B30045- MARK - BEGIN -------------------------------
#        IF NOT cl_null(g_rbh.rbh19t) THEN
#           CALL cl_set_comp_visible("rbh20t,rbh21t,rbh22t,rbh23t",g_rbh.rbh19t='Y')
#        END IF
###-MOD-B30045- MARK - end  -------------------------------
###-MOD-B30045- ADD - BEGIN -------------------------------
        #FUN-BC0126 mark START
        #IF g_rbh.rbh19t = 'Y' THEN
        #   CALL cl_set_comp_entry("rbh20t,rbh21t,rbh22t,rbh23t",TRUE)
        #ELSE
        #   CALL cl_set_comp_entry("rbh20t,rbh21t,rbh22t,rbh23t",FALSE)
        #END IF
        #FUN-BC0126 mark END
###-MOD-B30045- ADD -  end  -------------------------------

     #FUN-BC0126 mark START
     #ON CHANGE rbh22t
     #   IF NOT cl_null(g_rbh.rbh22t) THEN
     #      IF g_rbh.rbh22t='1' THEN
     #         LET g_rbh.rbh23t = 1
     #         CALL cl_set_comp_entry("rbh23t",FALSE)
     #         DISPLAY BY NAME g_rbh.rbh23t
     #      ELSE 
     #         LET g_rbh.rbh23t = 2
     #         CALL cl_set_comp_entry("rbh23t",TRUE)
     #         DISPLAY BY NAME g_rbh.rbh23t
     #      END IF
     #   END IF

     #BEFORE FIELD rbh23t
     #   IF NOT cl_null(g_rbh.rbh22t) THEN
     #      IF g_rbh.rbh22t='1' THEN
     #         LET g_rbh.rbh23t=1
     #         CALL cl_set_comp_entry("rbh23t",FALSE)
     #         DISPLAY BY NAME g_rbh.rbh23t
     #      ELSE
     #         LET g_rbh.rbh23t=2
     #         CALL cl_set_comp_entry("rbh23t",TRUE)
     #         DISPLAY BY NAME g_rbh.rbh23t
     #      END IF
     #   END IF

     # AFTER FIELD rbh23t
     #    IF NOT cl_null(g_rbh.rbh23t) THEN
     #       IF g_rbh.rbh23t<=1 THEN
     #          CALL cl_err('','art-659',0)
     #          NEXT FIELD rbh23t
     #       END IF
     #    END IF    
     #FUN-BC0126 mark END           

        AFTER INPUT
           LET g_rbh.rbhuser = s_get_data_owner("rbh_file") #FUN-C10039
           LET g_rbh.rbhgrup = s_get_data_group("rbh_file") #FUN-C10039
            LET l_flag='N'
            IF INT_FLAG THEN
               EXIT INPUT
            END IF 
            IF l_flag='Y' THEN
                CALL cl_err('','9033',0)
                NEXT FIELD rbh02
            END IF
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
        
         #FUN-AB0033 add ----------------start-------------------
        #FUN-BC0126 mark START
        #IF NOT cl_null(g_rbh.rbh04t) AND NOT cl_null(g_rbh.rbh05t) THEN
        #   IF g_rbh.rbh04t > g_rbh.rbh05t THEN
        #      CALL cl_err('','art-201',0)
        #      NEXT FIELD rbh04t
        #   END IF
        #END IF
        #FUN-BC0126 mark END
         #FUN-AB0033 add -----------------end-------------------- 
         
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add 
 
        ON ACTION CONTROLP
           CASE   
                WHEN INFIELD(rbh02) 
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_rah02"
                     CALL cl_create_qry() RETURNING g_rbh.rbh02
                     DISPLAY BY NAME g_rbh.rbh02
                     CALL t404_rbh02()
                     NEXT FIELD rbh02
               OTHERWISE EXIT CASE
             END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about   
         CALL cl_about()     
 
      ON ACTION help        
         CALL cl_show_help()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
         
      ON ACTION controlg   
         CALL cl_cmdask()  
    END INPUT     
    
END FUNCTION

FUNCTION t404_rbh02()
   DEFINE l_rah03   LIKE  rah_file.rah03
   DEFINE l_rah04   LIKE  rah_file.rah04
   DEFINE l_rah05   LIKE  rah_file.rah05
   DEFINE l_rah06   LIKE  rah_file.rah06
   DEFINE l_rah07   LIKE  rah_file.rah07
   DEFINE l_rah10   LIKE  rah_file.rah10
   DEFINE l_rah11   LIKE  rah_file.rah11
   DEFINE l_rah12   LIKE  rah_file.rah12
   DEFINE l_rah13   LIKE  rah_file.rah13
   DEFINE l_rah14   LIKE  rah_file.rah14
   DEFINE l_rah15   LIKE  rah_file.rah15
   DEFINE l_rah16   LIKE  rah_file.rah16
   DEFINE l_rah17   LIKE  rah_file.rah17
   DEFINE l_rah18   LIKE  rah_file.rah18
   DEFINE l_rah19   LIKE  rah_file.rah19
   DEFINE l_rah20   LIKE  rah_file.rah20
   DEFINE l_rah21   LIKE  rah_file.rah21
   DEFINE l_rah22   LIKE  rah_file.rah22
   DEFINE l_rah23   LIKE  rah_file.rah23
   DEFINE l_rah24   LIKE  rah_file.rah24
   DEFINE l_rah25   LIKE  rah_file.rah25
   DEFINE l_rahconf LIKE  rah_file.rahconf
   DEFINE l_rahacti LIKE  rah_file.rahacti
   DEFINE l_n       LIKE type_file.num5 
   DEFINE l_raa03   LIKE raa_file.raa03 
   DEFINE l_n1      LIKE type_file.num5
   
   LET g_errno = ''
   LET l_n1 = 0
   SELECT rah03,rah04,rah05,rah06,rah07,rah10,rah11,rah12,rah13,rah14,
          rah15,rah16,rah17,rah18,rah19,rah20,rah21,rah22,rah23,rah24,rah25,
          rahconf,rahacti
     INTO l_rah03,l_rah04,l_rah05,l_rah06,l_rah07,l_rah10,l_rah11,l_rah12,
          l_rah13,l_rah14,l_rah15,l_rah16,l_rah17,l_rah18,l_rah19,l_rah20,
          l_rah21,l_rah22,l_rah23,l_rah24,l_rah25,l_rahconf,l_rahacti
     FROM rah_file
    WHERE rah01=g_rbh.rbh01 AND rah02=g_rbh.rbh02 AND rahplant=g_rbh.rbhplant     
  CASE                          
     WHEN SQLCA.sqlcode=100   LET g_errno='art-196'  
     WHEN l_rahacti='N'       LET g_errno='9028'    
     WHEN l_rahconf<>'Y'      LET g_errno='art-195' 
    OTHERWISE   
    LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE 
  
  SELECT MAX(rbh03) INTO l_n FROM rbh_file
   WHERE rbh01=g_rbh.rbh01 AND rbh02=g_rbh.rbh02 AND rbhplant=g_rbh.rbhplant
  IF cl_null(l_n) OR l_n=0 THEN
     LET g_rbh.rbh03=1 
  ELSE 
     LET g_rbh.rbh03=l_n+1 
  END IF
 

  IF cl_null(g_errno) THEN 
    SELECT COUNT(*) INTO l_n1 FROM rbh_file 
      WHERE rbh01=g_rbh.rbh01 
        AND rbh02=g_rbh.rbh02 
        AND rbh03<g_rbh.rbh03
        #AND rbhconf NOT IN('I','X') #FUN-AB0033 mark
        AND rbhconf = 'N'  #FUN-AB0033 add
        AND rbhplant=g_rbh.rbhplant
     IF l_n1 > 0 THEN
        LET g_errno='art-682'
        RETURN
     END IF 
     
     #TQC-AC0326 add --------------------begin---------------------
     LET l_n1 = 0
     SELECT COUNT(*) INTO l_n1 FROM raq_file 
      WHERE raq01=g_rbh.rbh01 AND raq02=g_rbh.rbh02 AND raqplant=g_rbh.rbhplant 
        AND raq03='3' AND raqacti='Y' AND raq05='N'
        AND raq04 = g_rbh.rbhplant          #FUN-C60041 add
     IF l_n1 > 0 THEN
        LET g_errno='art-999'
        RETURN
     END IF
     #TQC-AC0326 add ---------------------end----------------------
     
     LET g_rbh.rbh26 = l_rah03
    #FUN-BC0126 mark START
    #LET g_rbh.rbh04 = l_rah04
    #LET g_rbh.rbh05 = l_rah05
    #LET g_rbh.rbh06 = l_rah06
    #LET g_rbh.rbh07 = l_rah07
    #FUN-BC0126 mark END
     LET g_rbh.rbh10 = l_rah10
     LET g_rbh.rbh11 = l_rah11
     LET g_rbh.rbh12 = l_rah12
     LET g_rbh.rbh13 = l_rah13
     LET g_rbh.rbh14 = l_rah14
     LET g_rbh.rbh15 = l_rah15
     LET g_rbh.rbh16 = l_rah16
     LET g_rbh.rbh17 = l_rah17
     LET g_rbh.rbh18 = l_rah18
     LET g_rbh.rbh19 = l_rah19
    #FUN-BC0126 mark START
    #LET g_rbh.rbh20 = l_rah20
    #LET g_rbh.rbh21 = l_rah21
    #LET g_rbh.rbh22 = l_rah22
    #LET g_rbh.rbh23 = l_rah23
    #FUN-BC0126 mark END
    #FUN-C60041 -----------STA
     LET g_rbh.rbh20 = l_rah20
     LET g_rbh.rbh21 = l_rah21
     LET g_rbh.rbh23 = l_rah23
    #FUN-C60041 -----------END
     LET g_rbh.rbh24 = l_rah24
     LET g_rbh.rbh25 = l_rah25    #MOD-B30045 ADD

     
     DISPLAY BY NAME g_rbh.rbh26,g_rbh.rbh03,
                    #g_rbh.rbh04,g_rbh.rbh05,g_rbh.rbh06,  #FUN-BC0126 mark
                    #g_rbh.rbh07,  #FUN-BC0126 mark
                     g_rbh.rbh10,g_rbh.rbh11,g_rbh.rbh12,g_rbh.rbh13,
                     g_rbh.rbh14,g_rbh.rbh15,g_rbh.rbh16,g_rbh.rbh17,g_rbh.rbh18,
                     g_rbh.rbh19,
                    #g_rbh.rbh20,g_rbh.rbh21,g_rbh.rbh22,g_rbh.rbh23,  #FUN-BC0126 mark
                     g_rbh.rbh24,g_rbh.rbh25  #FUN-BC0126 add rbh25
     SELECT raa03 INTO l_raa03 FROM raa_file WHERE raa01 = g_rbh.rbh01 AND raa02 = g_rbh.rbh26
     DISPLAY l_raa03 TO FORMONLY.rbh26_desc                  
     IF cl_null(g_rbh_t.rbh02) THEN  
       #FUN-BC0126 mark START
       #LET g_rbh.rbh04t = l_rah04
       #LET g_rbh.rbh05t = l_rah05
       #LET g_rbh.rbh06t = l_rah06
       #LET g_rbh.rbh07t = l_rah07
       #FUN-BC0126 mark END
        LET g_rbh.rbh10t = l_rah10
        LET g_rbh.rbh11t = l_rah11
        LET g_rbh.rbh12t = l_rah12
        LET g_rbh.rbh13t = l_rah13
        LET g_rbh.rbh14t = l_rah14
        LET g_rbh.rbh15t = l_rah15
        LET g_rbh.rbh16t = l_rah16
        LET g_rbh.rbh17t = l_rah17
        LET g_rbh.rbh18t = l_rah18
        LET g_rbh.rbh19t = l_rah19
       #FUN-BC0126 mark START
       #LET g_rbh.rbh20t = l_rah20
       #LET g_rbh.rbh21t = l_rah21
       #LET g_rbh.rbh22t = l_rah22
       #LET g_rbh.rbh23t = l_rah23
       #FUN-BC0126 mark END
       #FUN-C60041 -------------STA
        LET g_rbh.rbh20t = l_rah20
        LET g_rbh.rbh21t = l_rah21
        LET g_rbh.rbh23t = l_rah23
       #FUN-C60041 -------------END
        LET g_rbh.rbh25t = l_rah25    #MOD-B30045 ADD

                    
        DISPLAY BY NAME #g_rbh.rbh04t,g_rbh.rbh05t,g_rbh.rbh06t,g_rbh.rbh07t,  #FUN-BC0126 mark 
                        g_rbh.rbh10t,g_rbh.rbh11t,g_rbh.rbh12t,g_rbh.rbh13t,
                        g_rbh.rbh14t,g_rbh.rbh15t,g_rbh.rbh16t,g_rbh.rbh17t,
                        g_rbh.rbh18t,g_rbh.rbh19t,g_rbh.rbh25t  #FUN-BC0126 add rbh25t
                       #g_rbh.rbh20t,g_rbh.rbh21t,  #FUN-BC0126 mark
                       #g_rbh.rbh22t,g_rbh.rbh23t   #FUN-BC0126 mark
     END IF                     
  END IF

  
END FUNCTION

#單身1
#FUN-BC0126 mark START
#FUNCTION t404_b1()
#  DEFINE  l_ac1_t         LIKE type_file.num5,                
#          l_n             LIKE type_file.num5,                
#          l_cnt           LIKE type_file.num5,                
#          l_lock_sw       LIKE type_file.chr1,               
#          l_allow_insert  LIKE type_file.num5,    
#          l_allow_delete  LIKE type_file.num5,    
#          p_cmd           LIKE type_file.chr1                 
#  
#  DEFINE l_rbi04_curr  LIKE rbi_file.rbi04 
#  DEFINE l_price       LIKE rac_file.rac05
#  DEFINE l_discount    LIKE rac_file.rac06
#  DEFINE l_date        LIKE rac_file.rac12
#  DEFINE l_time1       LIKE type_file.num5
#  DEFINE l_time2       LIKE type_file.num5

#   LET g_action_choice = ""
#   IF s_shut(0) THEN RETURN END IF
#   IF cl_null(g_rbh.rbh02) THEN
#      RETURN
#   END IF
#   SELECT * INTO g_rbh.* FROM rbh_file
#    WHERE rbh01 = g_rbh.rbh01 AND rbh02 = g_rbh.rbh02 
#      AND rbh03 = g_rbh.rbh03 AND rbhplant = g_rbh.rbhplant

#   IF g_rbh.rbhacti ='N' THEN   
#      CALL cl_err(g_rbh.rbh01||g_rbh.rbh02,'mfg1000',1)
#      RETURN
#   END IF 
#   IF g_rbh.rbhconf = 'Y'  OR g_rbh.rbhconf = 'I'   THEN
#      CALL cl_err('','art-024',1)
#      RETURN
#   END IF
#   #TQC-AC0326 add ---------begin----------
#   IF g_rbh.rbh01 <> g_rbh.rbhplant THEN
#      CALL cl_err('','art-977',0)
#      RETURN
#   END IF
#   #TQC-AC0326 add ----------end-----------
#   #FUN-AB0033 mark ------start------
#   #IF g_rbh.rbhconf = 'X' THEN
#   #   CALL cl_err('','art-025',1)
#   #   RETURN
#   #END IF 
#   #FUN-AB0033 mark -------end-------
#   CALL cl_opmsg('b')
##   LET g_forupd_sql = " SELECT b.rbi04,'',a.rbi05,a.rbi06,a.rbi07,a.rbi08,a.rbi09,a.rbi10,a.rbi11,a.rbi12,a.rbiacti,",
##                      "                   b.rbi05,b.rbi06,b.rbi07,b.rbi08,b.rbi09,b.rbi10,b.rbi11,b.rbi12,b.rbiacti ",
##                      "   FROM rbi_file b LEFT OUTER JOIN rbi_file a",
##                      "     ON (b.rbi01=a.rbi01 AND b.rbi02=a.rbi02 AND b.rbi03=a.rbi03 ",
##                      "         b.rbi04=a.rbi04 AND b.rbi06=a.rbi06 AND b.rbiplant=a.rbiplant AND b.rbi05<>a.rbi05 ) ",
##                      "  WHERE b.rbi01 = ?  AND b.rbi02 = ? AND b.rbi03= ? AND b.rbiplant= ? ",
##                      "    AND b.rbi06 = ? ",
##                      "    AND b.rbi05='1' ", #AND a.rbi05='0' ",
##                      "    FOR UPDATE "

#   LET g_forupd_sql = " SELECT b.rbi04,'','','','','','','','','',''",
#                      "                   b.rbi05,b.rbi06,b.rbi07,b.rbi08,b.rbi09,b.rbi10,b.rbi11,b.rbi12,b.rbiacti ",  
#                      "   FROM rbi_file b ",
#                      "  WHERE b.rbi01 = ?  AND b.rbi02 = ? AND b.rbi03= ? AND b.rbiplant= ? ",
#                      "    AND b.rbi06 = ? ",
#                      "    FOR UPDATE "                    
#   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#   DECLARE t404_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
#   LET l_ac1_t = 0
#       LET l_allow_insert = cl_detail_input_auth("insert")
#       LET l_allow_delete = cl_detail_input_auth("delete")
#
#       INPUT ARRAY g_rbi WITHOUT DEFAULTS FROM s_rbi.*
#             ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
#             INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
#
#       BEFORE INPUT
#           IF g_rec_b1 != 0 THEN
#              CALL fgl_set_arr_curr(l_ac1)
#           END IF
#
#       BEFORE ROW
#           LET p_cmd = ''
#          #LET l_newline = 'N' 
#           LET l_ac1 = ARR_CURR()
#           LET l_lock_sw = 'N'            #DEFAULT
#           LET l_n  = ARR_COUNT()
#           BEGIN WORK
#
#           OPEN t404_cl USING g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,g_rbh.rbhplant
#           IF STATUS THEN
#              CALL cl_err("OPEN t404_cl:", STATUS, 1)
#              CLOSE t404_cl
#              ROLLBACK WORK
#              RETURN
#           END IF
#           FETCH t404_cl INTO g_rbh.*           
#           IF SQLCA.sqlcode THEN
#              CALL cl_err(g_rbh.rbh01||g_rbh.rbh02,SQLCA.sqlcode,0)      
#              CLOSE t404_cl
#              ROLLBACK WORK
#              RETURN
#           END IF
#           IF g_rec_b1>=l_ac1 THEN
#               LET p_cmd='u'
#               LET g_rbi_t.* = g_rbi[l_ac1].*  #BACKUP
#               LET g_rbi_o.* = g_rbi[l_ac1].*  #BACKUP
#              
#               OPEN t404_bcl USING g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,g_rbh.rbhplant,g_rbi_t.rbi06 
#                                   
#               IF STATUS THEN
#                   CALL cl_err("OPEN t404_bcl:", STATUS, 1)
#               ELSE
#                   # FETCH t404_bcl INTO l_rbi04_curr,g_rbi[l_ac1].*
#                 SELECT b.rbi04,'',a.rbi05,a.rbi06,a.rbi07,a.rbi08,a.rbi09,a.rbi10,a.rbi11,a.rbi12,a.rbiacti, 
#                                   b.rbi05,b.rbi06,b.rbi07,b.rbi08,b.rbi09,b.rbi10,b.rbi11,b.rbi12,b.rbiacti  
#                     INTO l_rbi04_curr,g_rbi[l_ac1].*
#                     FROM rbi_file b LEFT OUTER JOIN rbi_file a
#                       ON (b.rbi01=a.rbi01 AND b.rbi02=a.rbi02 AND b.rbi03=a.rbi03 
#                      AND  b.rbi04=a.rbi04 AND b.rbi06=a.rbi06 AND b.rbiplant=a.rbiplant 
#                      AND b.rbi05<>a.rbi05 )
#                    WHERE b.rbi01 =g_rbh.rbh01  AND b.rbi02 =g_rbh.rbh02 AND b.rbi03=g_rbh.rbh03
#                      AND b.rbiplant=g_rbh.rbhplant
#                      AND b.rbi06 = g_rbi_t.rbi06 
#                      AND b.rbi05='1' 
#                   IF SQLCA.sqlcode THEN
#                       CALL cl_err(g_rbi_t.type||g_rbi_t.rbi06,SQLCA.sqlcode,1)
#                       LET l_lock_sw = "Y"
#                   END IF
#                   IF g_rbi[l_ac1].before='0' THEN
#                      LET g_rbi[l_ac1].type ='1'
#                   ELSE
#                      LET g_rbi[l_ac1].type ='0'
#                   END IF                  
#               END IF
#               CALL cl_show_fld_cont()      
#           END IF 
#           CALL t404_rbi_entry(g_rbh.rbh10t)
#   BEFORE INSERT
#           DISPLAY "BEFORE INSERT!"
#           LET l_n = ARR_COUNT()
#           LET p_cmd='a'
#           INITIALIZE g_rbi[l_ac1].* TO NULL 
#           LET g_rbi[l_ac1].type = '0'      
#           LET g_rbi[l_ac1].before = '0'
#           LET g_rbi[l_ac1].after  = '1'
#           LET g_rbi_t.* = g_rbi[l_ac1].*         #新輸入資料
#           LET g_rbi_o.* = g_rbi[l_ac1].*
#           IF p_cmd='u' THEN    #組別不可輸入
#              CALL cl_set_comp_entry("rbi06",FALSE)
#           ELSE
#              CALL cl_set_comp_entry("rbi06",TRUE)
#           END IF   
#           SELECT MAX(rbi04)+1 INTO l_rbi04_curr 
#             FROM rbi_file
#            WHERE rbi01=g_rbh.rbh01
#              AND rbi02=g_rbh.rbh02 
#              AND rbi03=g_rbh.rbh03 
#              AND rbiplant=g_rbh.rbhplant
#             IF l_rbi04_curr IS NULL OR l_rbi04_curr=0 THEN
#                LET l_rbi04_curr = 1
#             END IF
#        #  CALL t404_rbi_entry(g_rbi[l_ac1].rbi07)    
#          CALL cl_show_fld_cont()
#          NEXT FIELD rbi06 

#       AFTER INSERT
#           IF INT_FLAG THEN
#              CALL cl_err('',9001,0)
#              LET INT_FLAG = 0
#              CANCEL INSERT
#           END IF
#            
#           IF g_rbi[l_ac1].type= '0' THEN
#             IF cl_null(g_rbi[l_ac1].rbi09) THEN LET g_rbi[l_ac1].rbi09 = 0  END IF
#             IF cl_null(g_rbi[l_ac1].rbi12) THEN LET g_rbi[l_ac1].rbi12 = 0  END IF
#              INSERT INTO rbi_file(rbi01,rbi02,rbi03,rbi04,rbi05,rbi06,rbi07,
#                                   rbi08,rbi09,rbi10,rbi11,rbi12,rbiacti,rbiplant,rbilegal)
#              VALUES(g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,l_rbi04_curr,g_rbi[l_ac1].after,
#                     g_rbi[l_ac1].rbi06,g_rbi[l_ac1].rbi07,g_rbi[l_ac1].rbi08,g_rbi[l_ac1].rbi09,  
#                     g_rbi[l_ac1].rbi10,g_rbi[l_ac1].rbi11,g_rbi[l_ac1].rbi12,
#                     g_rbi[l_ac1].rbiacti,g_rbh.rbhplant,g_rbh.rbhlegal) 
#              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                 CALL cl_err3("ins","rbi_file",g_rbh.rbh02||g_rbi[l_ac1].after||g_rbi[l_ac1].rbi06,"",SQLCA.sqlcode,"","",1)
#                 CANCEL INSERT
#              ELSE
#                 MESSAGE 'INSERT O.K'
#                 COMMIT WORK
#                 LET g_rec_b1=g_rec_b1+1
#                 DISPLAY g_rec_b1 TO FORMONLY.cn1
#              END IF
#          
#           ELSE
#            IF cl_null(g_rbi[l_ac1].rbi09) THEN LET g_rbi[l_ac1].rbi09 = 0  END IF
#            IF cl_null(g_rbi[l_ac1].rbi12) THEN LET g_rbi[l_ac1].rbi12 = 0  END IF
#              INSERT INTO rbi_file(rbi01,rbi02,rbi03,rbi04,rbi05,rbi06,rbi07,
#                                   rbi08,rbi09,rbi10,rbi11,rbi12,rbiacti,rbiplant,rbilegal)  
#              VALUES(g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,l_rbi04_curr,g_rbi[l_ac1].after,
#                     g_rbi[l_ac1].rbi06,g_rbi[l_ac1].rbi07,g_rbi[l_ac1].rbi08,g_rbi[l_ac1].rbi09,  
#                     g_rbi[l_ac1].rbi10,g_rbi[l_ac1].rbi11,g_rbi[l_ac1].rbi12,
#                     g_rbi[l_ac1].rbiacti,g_rbh.rbhplant,g_rbh.rbhlegal)
#              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                 CALL cl_err3("ins","rbi_file",g_rbh.rbh02||g_rbi[l_ac1].after||g_rbi[l_ac1].rbi06,"",SQLCA.sqlcode,"","",1)
#                 CANCEL INSERT 
#              ELSE
#                 MESSAGE 'INSERT value.after O.K' 
    #FUN-C60041 -------------END
#              END IF
#            IF cl_null(g_rbi[l_ac1].rbi09_1) THEN LET g_rbi[l_ac1].rbi09_1 = 0  END IF
#            IF cl_null(g_rbi[l_ac1].rbi12_1) THEN LET g_rbi[l_ac1].rbi12_1 = 0  END IF
#              INSERT INTO rbi_file(rbi01,rbi02,rbi03,rbi04,rbi05,rbi06,rbi07,
#                                   rbi08,bi09,rbi10,rbi11,rbi12,rbiacti,rbiplant,rbilegal)   
#              VALUES(g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,l_rbi04_curr,g_rbi[l_ac1].before,
#                     g_rbi[l_ac1].rbi06_1,g_rbi[l_ac1].rbi07_1,g_rbi[l_ac1].rbi08_1,g_rbi[l_ac1].rbi09_1, 
#                     g_rbi[l_ac1].rbi10_1,g_rbi[l_ac1].rbi11_1,g_rbi[l_ac1].rbi12_1,
#                     g_rbi[l_ac1].rbiacti_1,g_rbh.rbhplant,g_rbh.rbhlegal)
#              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                 CALL cl_err3("ins","rbi_file",g_rbh.rbh02||g_rbi[l_ac1].before||g_rbi[l_ac1].rbi06,"",SQLCA.sqlcode,"","",1)
#                 CANCEL INSERT
#              ELSE
#                 MESSAGE 'INSERT value.before O.K'
#                 COMMIT WORK
#                 LET g_rec_b1=g_rec_b1+1
#                 DISPLAY g_rec_b1 TO FORMONLY.cn1
#              END IF
#           END IF
#
#          
#       #FUN-AB0033 mark -----------------start--------------------
#       #BEFORE FIELD rbi06
#       #   IF g_rbi[l_ac1].rbi06 IS NULL OR g_rbi[l_ac1].rbi06 = 0 THEN
#       #      SELECT max(rbi06)+1
#       #        INTO g_rbi[l_ac1].rbi06
#       #        FROM rbi_file
#       #       WHERE rbi02 = g_rbh.rbh02 AND rbi01 = g_rbh.rbh01
#       #         AND rbi03 = g_rbh.rbh03 AND rbiplant = g_rbh.rbhplant
#       #      IF g_rbi[l_ac1].rbi06 IS NULL THEN
#       #         LET g_rbi[l_ac1].rbi06 = 1
#       #      END IF
#       #   END IF    
#       #FUN-AB0033 mark ------------------end---------------------    
#    
#       AFTER FIELD rbi06
#          IF NOT cl_null(g_rbi[l_ac1].rbi06) THEN
#             IF (g_rbi[l_ac1].rbi06 <> g_rbi_t.rbi06
#                OR cl_null(g_rbi_t.rbi06)) THEN 
#                SELECT COUNT(*) INTO l_n 
#                  FROM rai_file
#                 WHERE rai01=g_rbh.rbh01 AND rai02=g_rbh.rbh02
#                   AND raiplant=g_rbh.rbhplant AND rai03=g_rbi[l_ac1].rbi06
#                IF l_n=0 THEN
#                   IF NOT cl_confirm('art-677') THEN  
#                      NEXT FIELD rbi06
#                   ELSE
#                      CALL t404_b1_init()
#                   END IF
#                ELSE
#                   IF NOT cl_confirm('art-676') THEN  
#                      NEXT FIELD rbi06
#                   ELSE
#                      CALL t404_b1_find()   
#                   END IF           
#                END IF
#             END IF       
#          END IF
#               AFTER FIELD rbi07
#        IF NOT cl_null(g_rbi[l_ac1].rbi07) THEN
#           IF g_rbi_o.rbi07 IS NULL OR
#              (g_rbi[l_ac1].rbi07 != g_rbi_o.rbi07 ) THEN
#              IF g_rbi[l_ac1].rbi07 <= 0 THEN
#                 CALL cl_err(g_rbi[l_ac1].rbi07,'aec-020',0)
#                 LET g_rbi[l_ac1].rbi07= g_rbi_o.rbi07
#                 NEXT FIELD rbi07
#              END IF
#           END IF
#        END IF

#      
#                       
#  #  AFTER FIELD rbi07      
#  #      IF NOT cl_null(g_rbi[l_ac1].rbi07) THEN
#  #         IF g_rbi_o.rbi07=0 OR
#  #            (g_rbi[l_ac1].rbi07 != g_rbi_o.rbi07 ) THEN
#  #            CALL t404_rbi_entry(g_rbi[l_ac1].rbi07)
#  #            IF NOT cl_null(g_errno) THEN
#  #               CALL cl_err('rbi07',g_errno,0)
#  #               LET g_rbi[l_ac1].rbi07= g_rbi_o.rbi07
#  #               NEXT FIELD rbi07
#  #            ELSE
#  #               DISPLAY BY NAME g_rbi[l_ac1].rbi07
#  #            END IF 
#  #         END IF 
#  #      END IF 


#  #   ON CHANGE rbi07
#  #      IF NOT cl_null(g_rbi[l_ac1].rbi07) THEN
#  #         CALL t404_rbi_entry(g_rbi[l_ac1].rbi07)
#  #      END IF                             
#                   
#     ON CHANGE rbi10
#        IF NOT cl_null(g_rbi[l_ac1].rbi10) THEN
#           CALL t404_rbi_entry(g_rbh.rbh10t)
#        END IF         
#    AFTER FIELD rbi10
#        IF g_rbi[l_ac1].rbi10 = 'Y' THEN
#          #LET g_rbi[l_ac1].rbi11 = ''  
#           LET g_rbi[l_ac1].rbi11 = NULL   
#           LET g_rbi[l_ac1].rbi12 = 0
#           DISPLAY BY NAME g_rbi[l_ac1].rbi11,g_rbi[l_ac1].rbi12
#        ELSE 
#  #        IF g_rbh.rbh10t = '3' AND g_rbi[l_ac1].rbi09 <= 0 THEN    #TQC-A80156
#           IF g_rbh.rbh10t = '3' AND (g_rbi[l_ac1].rbi12 <= 0 ) THEN   #TQC-A80156
#             CALL cl_err('','art-180',0)
#             NEXT FIELD rbi12
#           END IF
#           IF g_rbh.rbh10t = '2' AND g_rbi[l_ac1].rbi11 IS NULL THEN
#             NEXT FIELD rbi11
#           END IF
#        END IF
#        
#     BEFORE FIELD rbi08,rbi09,rbi11,rbi12
#        IF NOT cl_null(g_rbi[l_ac1].rbi07) THEN
#           CALL t404_rbi_entry(g_rbh.rbh10t)
#        END IF

#     

#     AFTER FIELD rbi08,rbi11   
#          LET l_discount = FGL_DIALOG_GETBUFFER()
#          IF l_discount < 0 OR l_discount > 100 THEN
#             CALL cl_err('','atm-384',0)
#             NEXT FIELD CURRENT
#          ELSE
#             DISPLAY BY NAME g_rbi[l_ac1].rbi08,g_rbi[l_ac1].rbi11
#          END IF

#     AFTER FIELD rbi09,rbi12   
#        LET l_price = FGL_DIALOG_GETBUFFER()
#        IF l_price <= 0 THEN
#           CALL cl_err('','art-653',0)
#           NEXT FIELD CURRENT
#        ELSE
#           DISPLAY BY NAME g_rbi[l_ac1].rbi09,g_rbi[l_ac1].rbi12
#          #DISPLAY BY NAME CURRENT
#        END IF
#      
#        
#      BEFORE DELETE
#          DISPLAY "BEFORE DELETE"
#          IF g_rbi_t.rbi06 > 0 AND g_rbi_t.rbi06 IS NOT NULL THEN
#             IF NOT cl_delb(0,0) THEN
#                CANCEL DELETE
#             END IF
#             SELECT COUNT(*) INTO l_n FROM rbj_file
#              WHERE rbj01=g_rbh.rbh01 AND rbh02=g_rbh.rbh02
#                AND rbj03=g_rbh.rbh03 AND rbjplant=g_rbh.rbhplant
#                AND rbj06=g_rbi_t.rbi06
#             IF l_n>0 THEN
#                CALL cl_err(g_rbi_t.rbi06,'art-664',0)
#                CANCEL DELETE
#             ELSE 
#                SELECT COUNT(*) INTO l_n FROM rbp_file
#                 WHERE rbp01=g_rbh.rbh01 AND rap02=g_rbh.rbh02 AND rap04='2'
#                   AND rbp03=g_rbh.rbh03 AND rapplant=g_rbh.rbhplant
#                   AND rbp07=g_rbi_t.rbi06
#                IF l_n>0 THEN
#                   CALL cl_err(g_rbi_t.rbi06,'art-665',0)
#                   CANCEL DELETE 
#                END IF
#             END IF
#            
#             IF l_lock_sw = "Y" THEN
#                CALL cl_err("", -263, 1)
#                CANCEL DELETE
#             END IF
#             DELETE FROM rbi_file
#              WHERE rbi02 = g_rbh.rbh02 AND rbi01 = g_rbh.rbh01
#                AND rbi03 = g_rbh.rbh03 AND rbi04 = l_rbi04_curr
#               # AND rbi06 = g_rbi_t.rbi06  
#                AND rbiplant = g_rbh.rbhplant
#             IF SQLCA.sqlcode THEN
#                CALL cl_err3("del","rbi_file",g_rbh.rbh01,g_rbi_t.rbi06,SQLCA.sqlcode,"","",1) 
#                ROLLBACK WORK
#                CANCEL DELETE 
#             END IF
#             CALL t404_upd_log() 
#             LET g_rec_b1=g_rec_b1-1
#          END IF
#          COMMIT WORK
#
#       ON ROW CHANGE
#          IF INT_FLAG THEN
#             CALL cl_err('',9001,0)
#             LET INT_FLAG = 0
#             LET g_rbi[l_ac1].* = g_rbi_t.*
#             CLOSE t404_bcl
#             ROLLBACK WORK
#             EXIT INPUT
#          END IF
#          IF cl_null(g_rbi[l_ac1].rbi07) THEN
#             NEXT FIELD rbi07
#          END IF
#            
#          IF l_lock_sw = 'Y' THEN
#             CALL cl_err(g_rbi[l_ac1].rbi06,-263,1)
#             LET g_rbi[l_ac1].* = g_rbi_t.*
#          ELSE
#             UPDATE rbi_file SET rbi06  =g_rbi[l_ac1].rbi06,
#                                 rbi07  =g_rbi[l_ac1].rbi07,
#                                 rbi08  =g_rbi[l_ac1].rbi08,
#                                 rbi09  =g_rbi[l_ac1].rbi09,
#                                 rbi10  =g_rbi[l_ac1].rbi10,
#                                 rbi11  =g_rbi[l_ac1].rbi11,
#                                 rbi12  =g_rbi[l_ac1].rbi12,
#                                 rbiacti=g_rbi[l_ac1].rbiacti
#              WHERE rbi02 = g_rbh.rbh02 AND rbi01=g_rbh.rbh01
#                AND rbi03 = g_rbh.rbh03 AND rbi06=g_rbi_t.rbi06 
#                AND rbiplant = g_rbh.rbhplant
#             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                CALL cl_err3("upd","rbi_file",g_rbh.rbh01,g_rbi_t.rbi06,SQLCA.sqlcode,"","",1) 
#                LET g_rbi[l_ac1].* = g_rbi_t.*
#             ELSE                 
#                MESSAGE 'UPDATE rbi_file O.K'
#                CALL t404_upd_log() 
#                COMMIT WORK
#             END IF
#          END IF
#
#       AFTER ROW
#          DISPLAY  "AFTER ROW!!"
#          LET l_ac1 = ARR_CURR()
#          LET l_ac1_t = l_ac1
#          IF INT_FLAG THEN
#             CALL cl_err('',9001,0)
#             LET INT_FLAG = 0
#             IF p_cmd = 'u' THEN
#                LET g_rbi[l_ac1].* = g_rbi_t.*
#             END IF
#             CLOSE t404_bcl
#             ROLLBACK WORK
#             EXIT INPUT
#          END IF
#          CLOSE t404_bcl
#          COMMIT WORK
#
#       ON ACTION alter_memberlevel    
#          IF NOT cl_null(g_rbh.rbh02) THEN
#             CALl t402_2(g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,'3',g_rbh.rbhplant,g_rbh.rbhconf,g_rbh.rbh10)  
#          ELSE
#             CALL cl_err('',-400,0)
#          END IF
#      
#      ON ACTION CONTROLO
#          IF INFIELD(rbi06) AND l_ac1 > 1 THEN
#             LET g_rbi[l_ac1].* = g_rbi[l_ac1-1].*
#             LET g_rec_b1 = g_rec_b1+1
#             NEXT FIELD rbi06
#          END IF
#
#     ON ACTION CONTROLR
#          CALL cl_show_req_fields()
#
#     ON ACTION CONTROLG
#          CALL cl_cmdask()
#      
#     ON ACTION CONTROLF
#        CALL cl_set_focus_form(ui.Interface.getRootNode()) 
#           RETURNING g_fld_name,g_frm_name
#        CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
#
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE INPUT
#
#     ON ACTION about
#        CALL cl_about()
#
#     ON ACTION HELP
#        CALL cl_show_help()
#
#     ON ACTION controls         
#        CALL cl_set_head_visible("","AUTO")
#   END INPUT    
#   CLOSE t404_bcl
#   COMMIT WORK
#   #CALL t404_delall()  #FUN-AB0033 mark
#END FUNCTION  
#
#
#單身2
#FUNCTION t404_b2()
#   DEFINE  l_ac2_t         LIKE type_file.num5,
#           l_cnt           LIKE type_file.num5,
#           l_n             LIKE type_file.num5,
#           l_lock_sw       LIKE type_file.chr1,
#           p_cmd           LIKE type_file.chr1,
#           l_allow_insert  LIKE type_file.num5,
#           l_allow_delete  LIKE type_file.num5
#   DEFINE l_ima25      LIKE ima_file.ima25
#   DEFINE l_rbj04_curr LIKE rbj_file.rbj04 
#   LET g_action_choice = ""
#
#   IF s_shut(0) THEN
#      RETURN
#   END IF
#
#   IF g_rbh.rbh02 IS NULL THEN
#      RETURN
#   END IF
#
#   SELECT * INTO g_rbh.* FROM rbh_file
#    WHERE rbh01=g_rbh.rbh01
#      AND rbh02 = g_rbh.rbh02 
#      AND rbh03 = g_rbh.rbh03 
#      AND rbhplant = g_rbh.rbhplant
#
#   IF g_rbh.rbhacti ='N' THEN
#      CALL cl_err(g_rbh.rbh02,'mfg1000',0)
#      RETURN
#   END IF    
#   IF g_rbh.rbhconf = 'Y' OR g_rbh.rbhconf = 'I' THEN
#      CALL cl_err('','art-024',0)
#      RETURN
#   END IF
#   #TQC-AC0326 add ---------begin----------
#   IF g_rbh.rbh01 <> g_rbh.rbhplant THEN
#      CALL cl_err('','art-977',0)
#      RETURN
#   END IF
#   #TQC-AC0326 add ----------end-----------
#   #FUN-AB0033 mark ------start------
#   #IF g_rbh.rbhconf = 'X' THEN                                                                                             
#   #   CALL cl_err('','art-025',0)                                                                                          
#   #   RETURN                                                                                                               
#   #END IF
#   #FUN-AB0033 mark -------end-------
#   IF g_rbh.rbh11t = '1' THEN
#      CALL cl_err(g_rbh.rbh02,'art-667',0)
#      RETURN
#   END IF
#   
#   
#   CALL cl_opmsg('b')
#  
# #   LET g_forupd_sql = " SELECT b.rbj04,'',a.rbj05,a.rbj06,a.rbj07,a.rbj08,'',a.rbj09,'',a.rbjacti, ",
# #                     "                   b.rbj05,b.rbj06,b.rbj07,b.rbj08,'',b.rbj09,'',b.rbjacti  ",
# #                     "   FROM rbj_file b LEFT OUTER JOIN rbj_file a",
# #                     "     ON (b.rbj01=a.rbj01 AND b.rbj02=a.rbj02 AND b.rbj03=a.rbj03 AND b.rbj04=a.rbj04 ",
# #                     "         b.rbj06=a.rbj06 AND b.rbj07=a.rbj07 AND b.rbjplant=a.rbjplant AND b.rbj05<>a.rbj05 ) ",
# #                     "  WHERE b.rbj01 = ? AND b.rbj02 = ? ",
# #                    "    AND b.rbj03=? AND b.rbjplant=?  AND b.rbj06=? AND b.rbj07=? ",  
# #                    "    AND b.rbj05='1'", 
# #                    "    FOR UPDATE   "

#   LET g_forupd_sql = " SELECT *  ",
#                      "   FROM rbj_file ",
#                      "  WHERE rbj01 = ? AND rbj02 = ? ",
#                      "    AND rbj03=? AND rbjplant=?  AND rbj06=? AND rbj07=? ",  
#                      "    AND rbj08=? AND rbj09=?  FOR UPDATE   "
#                      
#   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#   DECLARE t4031_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

#   LET l_ac2_t = 0
#   LET l_allow_insert = cl_detail_input_auth("insert")
#   LET l_allow_delete = cl_detail_input_auth("delete")
#       
#   INPUT ARRAY g_rbj WITHOUT DEFAULTS FROM s_rbj.*
#   ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
#             INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
#             APPEND ROW=l_allow_insert)
#
#       BEFORE INPUT
#          DISPLAY "BEFORE INPUT!"
#          IF g_rec_b2 != 0 THEN
#             CALL fgl_set_arr_curr(l_ac2)
#          END IF
#
#       BEFORE ROW
#          DISPLAY "BEFORE ROW!"
#          LET p_cmd = ''
#          LET l_ac2 = ARR_CURR()
#          LET l_lock_sw = 'N'            #DEFAULT
#          LET l_n  = ARR_COUNT()
#        #  CALL t404_rbj07_chk() 
#
#          BEGIN WORK 
#          OPEN t404_cl USING g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,g_rbh.rbhplant
#          IF STATUS THEN
#             CALL cl_err("OPEN t404_cl:", STATUS, 1)
#             CLOSE t404_cl
#             ROLLBACK WORK
#             RETURN
#          END IF 
#          FETCH t404_cl INTO g_rbh.*
#          IF SQLCA.sqlcode THEN
#             CALL cl_err(g_rbh.rbh02,SQLCA.sqlcode,0)
#             CLOSE t404_cl
#             ROLLBACK WORK
#             RETURN
#          END IF
#
#          IF g_rec_b2 >= l_ac2 THEN
#             LET p_cmd='u'
#             LET g_rbj_t.* = g_rbj[l_ac2].*  #BACKUP
#             LET g_rbj_o.* = g_rbj[l_ac2].*  #BACKUP
#             CALL t404_rbj07()   
#             OPEN t4031_bcl USING g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,g_rbh.rbhplant,
#                                  g_rbj_t.rbj06,g_rbj_t.rbj07
#             IF STATUS THEN
#                CALL cl_err("OPEN t4031_bcl:", STATUS, 1)
#                LET l_lock_sw = "Y"
#             ELSE
#               # FETCH t4031_bcl INTO l_rbj04_curr,g_rbj[l_ac2].*
#               SELECT b.rbj04,'',a.rbj05,a.rbj06,a.rbj07,a.rbj08,'',a.rbj09,'',a.rbjacti,
#                       b.rbj05,b.rbj06,b.rbj07,b.rbj08,'',b.rbj09,'',b.rbjacti
#                  INTO l_rbj04_curr,g_rbj[l_ac2].*
#                  FROM rbj_file b LEFT OUTER JOIN rbj_file a
#                    ON (b.rbj01=a.rbj01 AND b.rbj02=a.rbj02 AND b.rbj03=a.rbj03 AND b.rbj04=a.rbj04 
#                   AND b.rbj06=a.rbj06 AND b.rbj07=a.rbj07 AND b.rbjplant=a.rbjplant AND b.rbj05<>a.rbj05 )
#                 WHERE b.rbj01 =g_rbh.rbh01 AND b.rbj02 =g_rbh.rbh02 
#                   AND b.rbj03=g_rbh.rbh03 AND b.rbjplant=g_rbh.rbhplant  AND b.rbj06=g_rbj_t.rbj06
#                   AND b.rbj07=g_rbj_t.rbj07   AND b.rbj05='1' 
#                   AND b.rbj08=g_rbj_t.rbj09   AND b.rbj09=g_rbj_t.rbj09  

#               IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_rbj_t.rbj06,SQLCA.sqlcode,1)
#                   LET l_lock_sw = "Y"
#                END IF
#                CALL t404_rbj08('d',l_ac2)
#                CALL t404_rbj09('d')
#             END IF
#          END IF 
#       BEFORE INSERT
#           LET l_n = ARR_COUNT()
#           LET p_cmd='a'
#           INITIALIZE g_rbj[l_ac2].* TO NULL 
#           LET g_rbj[l_ac2].type1 = '0'      
#           LET g_rbj[l_ac2].before1 = '0'
#           LET g_rbj[l_ac2].after1  = '1'  
#          #LET g_rbj[l_ac2].rbj07   = '01'             #Body default
#           LET g_rbj[l_ac2].rbjacti = 'Y' 
#          SELECT MIN(rbi06) INTO g_rbj[l_ac2].rbj06 FROM rbi_file
#           WHERE rbi01=g_rbh.rbh01 
#             AND rbi02=g_rbh.rbh02 
#             AND rbi03=g_rbh.rbh03 
#             AND rbiplant=g_rbh.rbhplant
#             
#           LET g_rbj_t.* = g_rbj[l_ac2].*         #新輸入資料
#           LET g_rbj_o.* = g_rbj[l_ac2].*         #新輸入資料
#           
#           SELECT MAX(rbj04)+1 INTO l_rbj04_curr 
#             FROM rbj_file
#            WHERE rbj01=g_rbh.rbh01
#              AND rbj02=g_rbh.rbh02 
#              AND rbj03=g_rbh.rbh03 
#              AND rbjplant=g_rbh.rbhplant
#             IF l_rbj04_curr IS NULL OR l_rbj04_curr=0 THEN
#                LET l_rbj04_curr = 1
#             END IF
#           IF cl_null(g_rbj[l_ac1].rbj09) THEN
#             LET g_rbj[l_ac2].rbj09 = ' '
#           END IF  
#           CALL cl_show_fld_cont()
#           NEXT FIELD rbj06 

#          
#       AFTER INSERT
#           IF INT_FLAG THEN
#              CALL cl_err('',9001,0)
#              LET INT_FLAG = 0
#              CANCEL INSERT
#           END IF
#           IF cl_null(g_rbj[l_ac2].rbj09) THEN
#              LET g_rbj[l_ac2].rbj09=' '
#           END IF
#           IF cl_null(g_rbj[l_ac2].rbj09_1) THEN
#              LET g_rbj[l_ac2].rbj09_1=' '
#           END IF
#           SELECT COUNT(*) INTO l_n FROM rbj_file
#            WHERE rbj01=g_rbh.rbh01 AND rbj02=g_rbh.rbh02
#              AND rbj03=g_rbh.rbh03 AND rbjplant=g_rbh.rbhplant
#              AND rbj06=g_rbj[l_ac2].rbj06 
#              AND rbj07=g_rbj[l_ac2].rbj07 
#              AND rbj08=g_rbj[l_ac2].rbj08 
#              AND rbj09=g_rbj[l_ac2].rbj09
#           IF l_n>0 THEN 
#              CALL cl_err('',-239,0)
#              #LET g_rbj[l_ac2].* = g_rbj_t.*
#              NEXT FIELD rbj06
#           END IF   
#           IF g_rbj[l_ac2].type1= '0' THEN
#              INSERT INTO rbj_file(rbj01,rbj02,rbj03,rbj04,rbj05,
#                                   rbj06,rbj07,rbj08,rbj09, 
#                                   rbjacti,rbjplant,rbjlegal)
#              VALUES(g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,l_rbj04_curr,g_rbj[l_ac2].after1,
#                     g_rbj[l_ac2].rbj06,g_rbj[l_ac2].rbj07,g_rbj[l_ac2].rbj08,g_rbj[l_ac2].rbj09, 
#                     g_rbj[l_ac2].rbjacti,g_rbh.rbhplant,g_rbh.rbhlegal) 
#              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                 CALL cl_err3("ins","rbj_file",g_rbh.rbh02||g_rbj[l_ac2].after1||g_rbj[l_ac2].rbj06,"",SQLCA.sqlcode,"","",1)
#                 CANCEL INSERT
#              ELSE
#                 CALL s_showmsg_init()
#                 LET g_errno=' '
#                 #CALL t403_repeat(g_rbj[l_ac2].rbj06)  #check
#                 CALL s_showmsg()
#                 IF NOT cl_null(g_errno) THEN
#                    LET g_rbj[l_ac2].* = g_rbj_t.*
#                    ROLLBACK WORK
#                    NEXT FIELD PREVIOUS
#                 ELSE
#                    #MESSAGE 'UPDATE O.K'
#                    COMMIT WORK
#                    LET g_rec_b2=g_rec_b2+1
#                    DISPLAY g_rec_b2 TO FORMONLY.cn2
#                 END IF                  
#              END IF
#          
#           ELSE
#              INSERT INTO rbj_file(rbj01,rbj02,rbj03,rbj04,rbj05,
#                                   rbj06,rbj07,rbj08,rbj09, 
#                                   rbjacti,rbjplant,rbjlegal)
#              VALUES(g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,l_rbj04_curr,g_rbj[l_ac2].after1,
#                     g_rbj[l_ac2].rbj06,g_rbj[l_ac2].rbj07,g_rbj[l_ac2].rbj08,g_rbj[l_ac2].rbj09, 
#                     g_rbj[l_ac2].rbjacti,g_rbh.rbhplant,g_rbh.rbhlegal) 
#              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                 CALL cl_err3("ins","rbj_file",g_rbh.rbh02||g_rbj[l_ac2].after1||g_rbj[l_ac2].rbj06,"",SQLCA.sqlcode,"","",1)
#                 CANCEL INSERT 
#             # ELSE
#              #   MESSAGE 'INSERT value.after O.K' 
#              END IF
#              INSERT INTO rbj_file(rbj01,rbj02,rbj03,rbj04,rbj05,
#                                   rbj06,rbj07,rbj08,rbj09, 
#                                   rbjacti,rbjplant,rbjlegal)
#              VALUES(g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,l_rbj04_curr,g_rbj[l_ac2].before1,
#                     g_rbj[l_ac2].rbj06_1,g_rbj[l_ac2].rbj07_1,g_rbj[l_ac2].rbj08_1,g_rbj[l_ac2].rbj09_1, 
#                     g_rbj[l_ac2].rbjacti_1,g_rbh.rbhplant,g_rbh.rbhlegal) 
#              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                 CALL cl_err3("ins","rbj_file",g_rbh.rbh02||g_rbj[l_ac2].before1||g_rbj[l_ac2].rbj06_1,"",SQLCA.sqlcode,"","",1)
#                 CANCEL INSERT               
#              ELSE
#                 CALL s_showmsg_init()
#                 LET g_errno=' '
#                 #CALL t403_repeat(g_rbg[l_ac2].rbg06)  #check
#                 CALL s_showmsg()
#                 IF NOT cl_null(g_errno) THEN
#                    LET g_rbj[l_ac2].* = g_rbj_t.*
#                    ROLLBACK WORK
#                    NEXT FIELD PREVIOUS
#                 ELSE
#                    #MESSAGE 'INSERT value.before O.K'
#                    COMMIT WORK
#                    LET g_rec_b2=g_rec_b2+1
#                    DISPLAY g_rec_b2 TO FORMONLY.cn2
#                 END IF                   
#              END IF
#           END IF 
#        
#         
#     AFTER FIELD rbj06
#        IF NOT cl_null(g_rbj[l_ac2].rbj06) THEN
#           IF g_rbj_o.rbj06 IS NULL OR
#              (g_rbj[l_ac2].rbj06 != g_rbj_o.rbj06 ) THEN
#              CALL t404_rbj06()    #檢查其有效性          
#              IF NOT cl_null(g_errno) THEN
#                 CALL cl_err(g_rbj[l_ac2].rbj06,g_errno,0)
#                 LET g_rbj[l_ac2].rbj06 = g_rbj_o.rbj06
#                 NEXT FIELD rbj06
#              END IF
#              IF NOT cl_null(g_rbj[l_ac2].rbj07) THEN
#                 SELECT COUNT(*) INTO l_n 
#                  FROM rbj_file
#                 WHERE rbj01=g_rbh.rbh01 AND raj02=g_rbh.rbh02
#                   AND rbjplant=g_rbh.rbhplant 
#                   AND rbj03=g_rbj[l_ac2].rbj06
#                   AND rbj04=g_rbj[l_ac2].rbj07
#                 IF l_n=0 THEN
#                    IF NOT cl_confirm('art-678') THEN
#                       NEXT FIELD rbj06
#                    ELSE
#                       CALL t404_b2_init()
#                    END IF
#                 ELSE
#                    IF NOT cl_confirm('art-679') THEN
#                       NEXT FIELD rbj06
#                    ELSE
#                       CALL t404_b2_find()   
#                    END IF           
#                 END IF
#              END IF  
#           END IF  
#        END IF 

#    #  BEFORE FIELD rbj07 
#    #    IF NOT cl_null(g_rbj[l_ac2].rbj06) THEN
#    #       CALL t404_rbj07_chk()
#    #    END IF

#     AFTER FIELD rbj07
#        IF NOT cl_null(g_rbj[l_ac2].rbj07) THEN
#           IF g_rbj_o.rbj07 IS NULL OR
#              (g_rbj[l_ac2].rbj07 != g_rbj_o.rbj07 ) THEN
#              IF NOT cl_null(g_rbj[l_ac2].rbj06) THEN
#                 SELECT COUNT(*) INTO l_n 
#                  FROM raj_file
#                 WHERE raj01=g_rbh.rbh01 AND raj02=g_rbh.rbh02
#                   AND rajplant=g_rbh.rbhplant 
#                   AND raj03=g_rbj[l_ac2].rbj06
#                   AND raj04=g_rbj[l_ac2].rbj07
#                 IF l_n=0 THEN
#                    IF NOT cl_confirm('art-678') THEN    #確定新增?
#                       NEXT FIELD rbj07
#                    ELSE
#                       CALL t404_b2_init()
#                    END IF
#                 ELSE
#                    IF NOT cl_confirm('art-679') THEN    #確定修改?
#                       NEXT FIELD rbj07
#                    ELSE
#                       CALL t404_b2_find()   
#                    END IF           
#                 END IF
#              END IF  
#              CALL t404_rbj07() 
#              #FUN-AB0033 mark --------------start-----------------
#              #IF NOT cl_null(g_errno) THEN
#              #   CALL cl_err(g_rbj[l_ac2].rbj07,g_errno,0)
#              #   LET g_rbj[l_ac2].rbj07 = g_rbj_o.rbj07
#              #   NEXT FIELD rbj07
#              #END IF
#              #FUN-AB0033 mark ---------------end------------------
#           END IF  
#        END IF  

#     ON CHANGE rbj07
#        IF NOT cl_null(g_rbj[l_ac2].rbj07) THEN
#           CALL t404_rbj07()   
#           LET g_rbj[l_ac2].rbj08=NULL
#           LET g_rbj[l_ac2].rbj08_desc=NULL
#           LET g_rbj[l_ac2].rbj09=NULL
#           LET g_rbj[l_ac2].rbj09_desc=NULL

#           DISPLAY BY NAME g_rbj[l_ac2].rbj08,g_rbj[l_ac2].rbj08_desc
#           DISPLAY BY NAME g_rbj[l_ac2].rbj09,g_rbj[l_ac2].rbj09_desc
#        END IF
# 
#     BEFORE FIELD rbj08,rbj09
#        IF NOT cl_null(g_rbj[l_ac2].rbj07) THEN
#           CALL t404_rbj07()            
#        END IF

#     AFTER FIELD rbj08
#        IF NOT cl_null(g_rbj[l_ac2].rbj08) THEN
#           #FUN-AB0025 ---------add start-----------
#           IF g_rbj[l_ac2].rbj07="01" THEN
#              IF NOT s_chk_item_no(g_rbj[l_ac2].rbj08,'') THEN
#                 CALL cl_err('',g_errno,1)
#                 LET g_rbj[l_ac2].rbj08 = g_rbj_o.rbj08
#                 NEXT FIELD rbj08
#              END IF
#           END IF
#           #FUN-AB0025 ----------add end----------------
#           IF g_rbj_o.rbj08 IS NULL OR
#              (g_rbj[l_ac2].rbj08 != g_rbj_o.rbj08 ) THEN
#              CALL t404_rbj08('a',l_ac2) 
#              IF NOT cl_null(g_errno) THEN
#                 CALL cl_err(g_rbj[l_ac2].rbj08,g_errno,0)
#                 LET g_rbj[l_ac2].rbj08 = g_rbj_o.rbj08
#                 NEXT FIELD rbj08
#              END IF
#           END IF  
#        END IF  

#     AFTER FIELD rbj09
#        IF NOT cl_null(g_rbj[l_ac2].rbj09) THEN
#           IF g_rbj_o.rbj09 IS NULL OR
#              (g_rbj[l_ac2].rbj09 != g_rbj_o.rbj09 ) THEN
#              CALL t404_rbj09('a')
#              IF NOT cl_null(g_errno) THEN
#                 CALL cl_err(g_rbj[l_ac2].rbj09,g_errno,0)
#                 LET g_rbj[l_ac2].rbj09 = g_rbj_o.rbj09
#                 NEXT FIELD rbj09
#              END IF
#           END IF  
#        END IF        
#       
#       BEFORE DELETE
#          DISPLAY "BEFORE DELETE"
#          IF g_rbj_t.rbj06 > 0 AND g_rbj_t.rbj06 IS NOT NULL THEN
#             IF NOT cl_delb(0,0) THEN
#                CANCEL DELETE
#             END IF
#             IF l_lock_sw = "Y" THEN
#                CALL cl_err("", -263, 1)
#                CANCEL DELETE
#             END IF
#             DELETE FROM rbj_file
#              WHERE rbj02 = g_rbh.rbh02 AND rbj01 = g_rbh.rbh01
#                AND rbj03 = g_rbh.rbh03 AND rbj04 = l_rbj04_curr
#                AND rbj06 = g_rbj_t.rbj06 
#                AND rbjplant = g_rbh.rbhplant
#             IF SQLCA.sqlcode THEN
#                CALL cl_err3("del","rbj_file",g_rbh.rbh02,g_rbj_t.rbj06,SQLCA.sqlcode,"","",1)
#                ROLLBACK WORK
#                CANCEL DELETE
#             END IF
#             LET g_rec_b1=g_rec_b1-1
#          END IF
#          COMMIT WORK
#
#       ON ROW CHANGE
#          IF INT_FLAG THEN
#             CALL cl_err('',9001,0)
#             LET INT_FLAG = 0
#             LET g_rbj[l_ac2].* = g_rbj_t.*
#             CLOSE t4031_bcl
#             ROLLBACK WORK
#             EXIT INPUT
#          END IF
#          IF cl_null(g_rbj[l_ac2].rbj09) THEN
#             LET g_rbj[l_ac2].rbj09=' '
#          END IF 
#          IF cl_null(g_rbj_t.rbj09) THEN
#             LET g_rbj_t.rbj09=' '
#          END IF 
#          IF l_lock_sw = 'Y' THEN
#             CALL cl_err(g_rbj[l_ac2].rbj06,-263,1)
#             LET g_rbj[l_ac2].* = g_rbj_t.*
#          ELSE
#             IF g_rbj[l_ac2].rbj06<>g_rbj_t.rbj06 OR
#                g_rbj[l_ac2].rbj07<>g_rbj_t.rbj07 OR
#                g_rbj[l_ac2].rbj08<>g_rbj_t.rbj08 OR
#                g_rbj[l_ac2].rbj09<>g_rbj_t.rbj09 THEN
#                SELECT COUNT(*) INTO l_n FROM rbj_file
#                 WHERE rbj01 =g_rbh.rbh01 AND rbj02 = g_rbh.rbh02
#                   AND rbj03=g_rbh.rbh03
#                   AND rbj06 = g_rbj[l_ac2].rbj06 
#                   AND rbj07 = g_rbj[l_ac2].rbj07
#                   AND rbh08 = g_rbj[l_ac2].rbj08 
#                   AND rbj09 = g_rbj[l_ac2].rbj09
#                   AND rbjplant = g_rbh.rbhplant
#                IF l_n>0 THEN 
#                   CALL cl_err('',-239,0)
#                  #LET g_rbj[l_ac2].* = g_rbj_t.*
#                   NEXT FIELD rbj06
#                END IF
#             END IF            
#               UPDATE rbj_file SET rbj06=g_rbj[l_ac2].rbj06,
#                                 rbj07=g_rbj[l_ac2].rbj07,
#                                 rbj08=g_rbj[l_ac2].rbj08,
#                                 rbj09=g_rbj[l_ac2].rbj09,
#                                 rbjacti=g_rbj[l_ac2].rbjacti
#              WHERE rbj02 = g_rbh.rbh02 AND rbj01=g_rbh.rbh01 AND rbj03=g_rbh.rbh03 
#                AND rbj04 = l_rbj04_curr AND rbj05='1'
#                AND rbj06=g_rbj_t.rbj06 AND rbj07=g_rbj_t.rbj07 AND rbjplant = g_rbh.rbhplant
#             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                CALL cl_err3("upd","rbj_file",g_rbh.rbh02,g_rbj_t.rbj06,SQLCA.sqlcode,"","",1) 
#                LET g_rbj[l_ac2].* = g_rbj_t.*
#             ELSE                
#                MESSAGE 'UPDATE O.K'
#                COMMIT WORK                
#             END IF
#          END IF
#
#       AFTER ROW
#          DISPLAY  "AFTER ROW!!"
#          LET l_ac2 = ARR_CURR()
#          LET l_ac2_t = l_ac2
#          IF INT_FLAG THEN
#             CALL cl_err('',9001,0)
#             LET INT_FLAG = 0
#             IF p_cmd = 'u' THEN
#                LET g_rbj[l_ac2].* = g_rbj_t.*
#             END IF
#             CLOSE t4031_bcl
#             ROLLBACK WORK
#             EXIT INPUT
#          END IF
#         #CALL t404_repeat(g_rbj[l_ac2].rbj06)  #check
#          CLOSE t4031_bcl
#          COMMIT WORK
#
#       ON ACTION CONTROLO
#          IF INFIELD(rbj06) AND l_ac2 > 1 THEN
#             LET g_rbj[l_ac2].* = g_rbj[l_ac2-1].*
#             LET g_rec_b2 = g_rec_b2+1
#            #LET l_rbj04_curr=l_rbj04_curr+1
#             NEXT FIELD rbj06
#          END IF
#
#       ON ACTION CONTROLR
#          CALL cl_show_req_fields()
#
#       ON ACTION CONTROLG
#          CALL cl_cmdask()
#
#       ON ACTION controlp
#          CASE
#            WHEN INFIELD(rbj08)
#                CALL cl_init_qry_var()
#                CASE g_rbj[l_ac2].rbj07
#                   WHEN '01'
#                    # IF cl_null(g_rtz05) THEN       #FUN-AB0101 mark
#FUN-AA0059---------mod------------str-----------------
#                         LET g_qryparam.form="q_ima" 
#                         CALL q_sel_ima(FALSE, "q_ima","",g_rbj[l_ac2].rbj08,"","","","","",'' ) 
#                           RETURNING g_rbj[l_ac2].rbj08  
#FUN-AA0059---------mod------------end-----------------         
#                    # ELSE                                    #FUN-AB0101
#                    #    LET g_qryparam.form = "q_rtg03_1"    #FUN-AB0101 
#                    #    LET g_qryparam.arg1 = g_rtz05        #FUN-AB0101
#                    # END IF                                  #FUN-AB0101 
#                   WHEN '02'
#                      LET g_qryparam.form ="q_oba01"
#                   WHEN '03'
#                      LET g_qryparam.form ="q_tqa"
#                      LET g_qryparam.arg1 = '1'
#                   WHEN '04'
#                      LET g_qryparam.form ="q_tqa"
#                      LET g_qryparam.arg1 = '2'
#                   WHEN '05'
#                      LET g_qryparam.form ="q_tqa"
#                      LET g_qryparam.arg1 = '3'
#                   WHEN '06'
#                      LET g_qryparam.form ="q_tqa"
#                      LET g_qryparam.arg1 = '4'
#                   WHEN '07'
#                      LET g_qryparam.form ="q_tqa"
#                      LET g_qryparam.arg1 = '5'
#                   WHEN '08'
#                      LET g_qryparam.form ="q_tqa"
#                      LET g_qryparam.arg1 = '6'
#                   WHEN '09'
#                      LET g_qryparam.form ="q_tqa"
#                      LET g_qryparam.arg1 = '27'
#                END CASE
#              # IF g_rbj[l_ac2].rbj07 != '01' OR (g_rbj[l_ac2].rbj07 = '01' AND NOT cl_null(g_rtz05)) THEN  #FUN-AA0059 add     #FUN-AB0101
#                IF g_rbj[l_ac2].rbj07 != '01' THEN                             #FUN-AB0101
#                   LET g_qryparam.default1 = g_rbj[l_ac2].rbj08
#                   CALL cl_create_qry() RETURNING g_rbj[l_ac2].rbj08
#                END IF                                                                                      #FUN-AA0059 add  
#                CALL t404_rbj08('d',l_ac2)
#                NEXT FIELD rbj08
#             WHEN INFIELD(rbj09)
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = "q_gfe02"
#                SELECT DISTINCT ima25
#                  INTO l_ima25
#                  FROM ima_file
#                 WHERE ima01=g_rbj[l_ac2].rbj08  
#                LET g_qryparam.arg1 = l_ima25
#                LET g_qryparam.default1 = g_rbj[l_ac2].rbj09
#                CALL cl_create_qry() RETURNING g_rbj[l_ac2].rbj09
#                CALL t404_rbj09('d')
#                NEXT FIELD rbj09
#             OTHERWISE EXIT CASE
#           END CASE
#
#     ON ACTION CONTROLF
#        CALL cl_set_focus_form(ui.Interface.getRootNode()) 
#           RETURNING g_fld_name,g_frm_name
#        CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
#
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE INPUT
#
#     ON ACTION about
#        CALL cl_about()
#
#     ON ACTION HELP
#        CALL cl_show_help()
#
#     ON ACTION controls         
#        CALL cl_set_head_visible("","AUTO")
#   END INPUT     
#   CALL t404_upd_log()    
#   CLOSE t4031_bcl
#   COMMIT WORK
#END FUNCTION
#FUN-BC0126 mark END
FUNCTION t404_rbh11t()
   IF NOT cl_null(g_rbh.rbh11t) THEN
      IF g_rbh.rbh11t = '1' THEN
         CALL cl_set_comp_entry("rbj06,rbj07,rbj08,rbj09,rbjacti",FALSE)
         #CALL cl_set_comp_visible("Page6",FALSE)
      ELSE
         CALL cl_set_comp_entry("rbj06,rbj07,rbj08,rbj09,rbjacti",TRUE)
         #CALL cl_set_comp_visible("Page6",TRUE)
      END IF
   END IF
END FUNCTION

FUNCTION t404_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_rbh.rbh02 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF

   SELECT * INTO g_rbh.* FROM rbh_file
    WHERE rbh02 = g_rbh.rbh02 
      AND rbh01=g_rbh.rbh01
      AND rbh03 = g_rbh.rbh03  
      AND rbhplant = g_rbh.rbhplant

    IF g_rbh.rbhacti ='N' THEN    
       CALL cl_err(g_rbh.rbh02,9027,0)
       RETURN
    END IF

    IF g_rbh.rbhconf = 'Y' OR g_rbh.rbhconf = 'I' THEN
       CALL cl_err('','art-024',0)
       RETURN
    END IF
    #TQC-AC0326 add ---------begin----------
    IF g_rbh.rbh01 <> g_rbh.rbhplant THEN
       CALL cl_err('','art-977',0)
       RETURN
    END IF
    #TQC-AC0326 add ----------end-----------
    #FUN-AB0033 mark ------start------
    #IF g_rbh.rbhconf = 'X' THEN
    #   CALL cl_err('','art-025',0)
    #   RETURN
    #END IF
    #FUN-AB0033 mark -------end-------
 
    CALL cl_opmsg('u')

    LET g_rbh01_t = g_rbh.rbh01
    LET g_rbh02_t = g_rbh.rbh02  
    LET g_rbh03_t = g_rbh.rbh03  
    LET g_rbhplant_t = g_rbh.rbhplant 
    LET g_rbh_o.* = g_rbh.*

    BEGIN WORK
    LET g_success ='Y'
 
    OPEN t404_cl USING g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,g_rbh.rbhplant
    IF STATUS THEN
       CALL cl_err("OPEN t404_cl:", STATUS, 1)
       CLOSE t404_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t404_cl INTO g_rbh.*            
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rbh.rbh01,SQLCA.sqlcode,0)      
        CLOSE t404_cl
        ROLLBACK WORK
        RETURN
    END IF

    CALL t404_show()

    WHILE TRUE
        LET g_rbh01_t = g_rbh.rbh01
        LET g_rbh02_t = g_rbh.rbh02   
        LET g_rbh03_t = g_rbh.rbh03   
        LET g_rbhplant_t = g_rbh.rbhplant 
        LET g_rbh.rbhmodu=g_user
        LET g_rbh.rbhdate=g_today

        CALL t404_i("u")                      

        CALL t404_rbi13_text()   #FUN-C30151 add
        IF INT_FLAG THEN
            LET g_success ='N'
            LET INT_FLAG = 0
            LET g_rbh.*=g_rbh_o.*
            CALL t404_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF

        UPDATE rbh_file SET rbh_file.* = g_rbh.*
            WHERE rbh01 = g_rbh.rbh01 AND rbh02 = g_rbh.rbh02
              AND rbh03 = g_rbh.rbh03 AND rbhplant = g_rbh.rbhplant
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           CALL cl_err3("upd","rbh_file","","",SQLCA.sqlcode,"","",1)
           CONTINUE WHILE
        END IF 
        EXIT WHILE
    END WHILE

    CLOSE t404_cl
    COMMIT WORK
    CALL cl_flow_notify(g_rbh.rbh02,'U')
   #CALL cl_set_act_visible("gift",g_rbh.rbh19t='Y')  #FUN-BC0126 mark
    #FUN-BC0126 add START
    CALL cl_set_act_visible("alter_gift",g_rbh.rbh19t='Y')  
   #IF g_rbh.rbh10t = 2 THEN  #FUN-C30151 mark
    IF g_rbh.rbh10t = 2 AND g_rbh.rbh25t = '1' THEN  #FUN-C30151 add
       CALL cl_set_comp_visible('rbi13',FALSE) 
       CALL cl_set_comp_visible('rbi13_1',FALSE)   #FUN-C30151 add
       CALL cl_set_comp_visible('dummy27',FALSE)   #FUN-C30151 add
    ELSE
       CALL cl_set_comp_visible('rbi13',TRUE)
       CALL cl_set_comp_visible('rbi13_1',TRUE)   #FUN-C30151 add
       CALL cl_set_comp_visible('dummy27',TRUE)   #FUN-C30151 add
    END IF
    #FUN-BC0126 add END
    CALL t404_b1_fill("1=1")
    CALL t404_b2_fill("1=1")
    CALL t404_b3_fill(" 1=1")  #FUN-BC0126 add 
    COMMIT WORK
END FUNCTION

FUNCTION t404_r()
   DEFINE l_flag LIKE type_file.chr1 
    IF s_shut(0) THEN RETURN END IF
    IF g_rbh.rbh02 IS NULL THEN
       CALL cl_err("",-400,0)                  
       RETURN
    END IF
 
    SELECT * INTO g_rbh.* FROM rbh_file
    WHERE rbh02 = g_rbh.rbh02 AND rbh01=g_rbh.rbh01
      AND rbh03 = g_rbh.rbh03 AND rbhplant = g_rbh.rbhplant

    IF g_rbh.rbhacti ='N' THEN    
       CALL cl_err(g_rbh.rbh02,9027,0)
       RETURN
    END IF

    IF g_rbh.rbhconf = 'Y' OR g_rbh.rbhconf = 'I' THEN
       CALL cl_err('','art-023',0)
       RETURN
    END IF
    #FUN-AB0033 mark ------start------
    #IF g_rbh.rbhconf = 'X' THEN
    #   CALL cl_err('','9024',0)
    #   RETURN
    #END IF
    #FUN-AB0033 mark -------end-------
    BEGIN WORK
 
    OPEN t404_cl USING g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,g_rbh.rbhplant
    IF STATUS THEN
       CALL cl_err("OPEN t404_cl:", STATUS, 1)
       CLOSE t404_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t404_cl INTO g_rbh.*               
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rbh.rbh02,SQLCA.sqlcode,0)        
        ROLLBACK WORK
        RETURN
    END IF
    CALL t404_show()
    IF cl_delh(0,0) THEN                  
        INITIALIZE g_doc.* TO NULL            
        LET g_doc.column1 = "rbh01"          
        LET g_doc.column2 = "rbh02"           
        LET g_doc.value1 = g_rbh.rbh01        
        LET g_doc.value2 = g_rbh.rbh02       
        CALL cl_del_doc()               
         DELETE FROM rbh_file WHERE rbh01 = g_rbh.rbh01
                                AND rbh02 = g_rbh.rbh02
                                AND rbh03 = g_rbh.rbh03
                                AND rbhplant = g_rbh.rbhplant
         DELETE FROM rbi_file WHERE rbi01 = g_rbh.rbh01
                                AND rbi02 = g_rbh.rbh02
                                AND rbi03 = g_rbh.rbh03
                                AND rbiplant = g_rbh.rbhplant
         DELETE FROM rbj_file WHERE rbj01 = g_rbh.rbh01
                                AND rbj02 = g_rbh.rbh02 
                                AND rbj03 = g_rbh.rbh03
                                AND rbjplant = g_rbh.rbhplant 
         DELETE FROM rbq_file WHERE rbq01 = g_rbh.rbh01
                                AND rbq02 = g_rbh.rbh02 
                                AND rbq03 = g_rbh.rbh03
                                AND rbqplant = g_rbh.rbhplant
                                AND rbq04='3'
         DELETE FROM rbp_file WHERE rbp01 = g_rbh.rbh01
                                AND rbp02 = g_rbh.rbh02
                                AND rbp03 = g_rbh.rbh03
                                AND rbpplant = g_rbh.rbhplant
                                AND rbp04='3'
         DELETE FROM rbr_file WHERE rbr01 = g_rbh.rbh01
                                AND rbr02 = g_rbh.rbh02 
                                AND rbr03 = g_rbh.rbh03
                                AND rbrplant = g_rbh.rbhplant
                                AND rbr04='3'
         DELETE FROM rbs_file WHERE rbs01 = g_rbh.rbh01
                                AND rbs02 = g_rbh.rbh02
                                AND rbs03 = g_rbh.rbh03
                                AND rbsplant = g_rbh.rbhplant
                                AND rbs04='3'                                 
       #FUN-BC0126 add START
         DELETE FROM rbk_file WHERE rbk01 = g_rbh.rbh01
                                AND rbk02 = g_rbh.rbh02
                                AND rbk03 = g_rbh.rbh03
                                AND rbkplant = g_rbh.rbhplant
                                AND rbk05='3'
       #FUN-BC0126 add END
         INITIALIZE g_rbh.* TO NULL
         CLEAR FORM
         CALL g_rbi.clear()
         CALL g_rbj.clear()
         CALL g_rbk.clear()  #FUN-BC0126 add
         OPEN t404_count
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE t404_cs
            CLOSE t404_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         FETCH t404_count INTO g_row_count
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t404_cs
            CLOSE t404_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t404_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t404_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL t404_fetch('/')
         END IF
    END IF
    COMMIT WORK
END FUNCTION


FUNCTION t404_upd_log()
   LET g_rbh.rbhmodu = g_user
   LET g_rbh.rbhdate = g_today
   UPDATE rbh_file SET rbhmodu = g_rbh.rbhmodu,
                       rbhdate = g_rbh.rbhdate
    WHERE rbh01 = g_rbh.rbh01 AND rbh02 = g_rbh.rbh02
      AND rbh03 = g_rbh.rbh03 AND rbhplant = g_rbh.rbhplant
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","rah_file",g_rbh.rbhmodu,g_rbh.rbhdate,SQLCA.sqlcode,"","",1)
   END IF
   DISPLAY BY NAME g_rbh.rbhmodu,g_rbh.rbhdate
   MESSAGE 'UPDATE rbh_file O.K.'
END FUNCTION

FUNCTION t404_chktime(p_time)  
    DEFINE p_time LIKE type_file.chr5
    DEFINE l_hour LIKE type_file.num5
    DEFINE l_min  LIKE type_file.num5 
    LET g_errno=''
    IF p_time[1,1] MATCHES '[012]' AND
       p_time[2,2] MATCHES '[0123456789]' AND
       p_time[3,3] =':' AND
       p_time[4,4] MATCHES '[012345]' AND 
       p_time[5,5] MATCHES '[0123456789]' THEN
       IF p_time[1,2]<'00' OR p_time[1,2]>='24' OR
          p_time[4,5]<'00' OR p_time[4,5]>='60' THEN
          LET g_errno='art-209' 
       END IF
    ELSE
       LET g_errno='art-209'
    END IF
    IF cl_null(g_errno) THEN         
       LET l_hour=p_time[1,2]
       LET l_min = p_time[4,5]
       RETURN l_hour*60+l_min
    ELSE
       RETURN NULL
    END IF
END FUNCTION
FUNCTION t404_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1 
   
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("rbh02",TRUE)
      CALL cl_set_comp_required("rbh02",TRUE)
   END IF
    #CALL cl_set_comp_entry("rbhmksg",TRUE)  #FUN-AB0033 mark
#    CALL cl_set_comp_entry("rbhmksg",FALSE)  #FUN-AB0033 add              #FUN-B30028  mark
   #FUN-BC0126 mark START
   #CALL cl_set_comp_entry("g_rbh.rbh04t,g_rbh.rbh05t,g_rbh.rbh06t,g_rbh.rbh07t,                  
   #                       g_rbh.rbh10t,g_rbh.rbh11t,g_rbh.rbh12t,g_rbh.rbh13t,
   #                       g_rbh.rbh14t,g_rbh.rbh15t,g_rbh.rbh16t,g_rbh.rbh17t,
   #                       g_rbh.rbh18t,g_rbh.rbh19t,g_rbh.rbh20t,g_rbh.rbh21t,
   #                       g_rbh.rbh22t,g_rbh.rbh23t",TRUE)  
   #FUN-BC0126 mark END
   #FUN-BC0126 add START
    CALL cl_set_comp_entry("g_rbh.rbh10t,g_rbh.rbh11t,g_rbh.rbh12t,g_rbh.rbh13t,
                            g_rbh.rbh14t,g_rbh.rbh15t,g_rbh.rbh16t,g_rbh.rbh17t,
                            g_rbh.rbh18t,g_rbh.rbh19t,g_rbh.rbh25t",TRUE)
   #FUN-BC0126 add END
END FUNCTION

FUNCTION t404_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey = 'N' THEN
      CALL cl_set_comp_entry("rbh02",FALSE)  
   END IF
END FUNCTION

 
FUNCTION t404_x()
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rbh.rbh02 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   IF g_rbh.rbhconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   #IF g_rbh.rbhconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF #FUN-AB0033 mark 
   #IF g_rbh.rbhconf = 'I' THEN CALL cl_err('',9023,0) RETURN END IF #FUN-AB0033 mark 
   BEGIN WORK 
   OPEN t404_cl USING g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,g_rbh.rbhplant
   IF STATUS THEN
      CALL cl_err("OPEN t404_cl:", STATUS, 1)
      CLOSE t404_cl
      RETURN
   END IF
 
   FETCH t404_cl INTO g_rbh.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rbh.rbh01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t404_show()
 
   IF cl_exp(0,0,g_rbh.rbhacti) THEN
      LET g_chr=g_rbh.rbhacti
      IF g_rbh.rbhacti='Y' THEN
         LET g_rbh.rbhacti='N'
      ELSE
         LET g_rbh.rbhacti='Y'
      END IF
 
      UPDATE rbh_file SET rbhacti=g_rbh.rbhacti,
                          rbhmodu=g_user,
                          rbhdate=g_today
       WHERE rbh02 = g_rbh.rbh02 AND rbh01=g_rbh.rbh01
         AND rbh03 = g_rbh.rbh03 AND rbhplant = g_rbh.rbhplant
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","rbh_file",g_rbh.rbh01,"",SQLCA.sqlcode,"","",1) 
         LET g_rbh.rbhacti=g_chr
      END IF
   END IF
 
   CLOSE t404_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_rbh.rbh02,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT rbhacti,rbhmodu,rbhdate
     INTO g_rbh.rbhacti,g_rbh.rbhmodu,g_rbh.rbhdate FROM rbh_file 
       WHERE rbh02 = g_rbh.rbh02 AND rbh01=g_rbh.rbh01
         AND rbh03 = g_rbh.rbh03 AND rbhplant = g_rbh.rbhplant

   DISPLAY BY NAME g_rbh.rbhacti,g_rbh.rbhmodu,g_rbh.rbhdate
END FUNCTION 

FUNCTION t404_yes()
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_gen02    LIKE gen_file.gen02 
DEFINE l_rxx04    LIKE rxx_file.rxx04
DEFINE l_rbi10    LIKE rbi_file.rbi10  #FUN-BC0126 add
DEFINE l_rbi10_1  LIKE rbi_file.rbi10  #FUN-BC0126 add
DEFINE l_rbi06    LIKE rbi_file.rbi06  #FUN-BC0126 add
   IF s_shut(0) THEN
      RETURN
   END IF
   
   
   IF g_rbh.rbh02 IS NULL THEN CALL cl_err(g_rbh.rbh02,-400,0) RETURN END IF
#CHI-C30107 ---------------- add ---------------- begin
   IF g_rbh.rbhconf = 'Y' THEN CALL cl_err(g_rbh.rbh02,9023,0) RETURN END IF
   IF g_rbh.rbhacti = 'N' THEN CALL cl_err(g_rbh.rbh02,'art-145',0) RETURN END IF
   IF NOT cl_confirm('art-026') THEN RETURN END IF
   SELECT * INTO g_rbh.* FROM rbh_file
      WHERE rbh02 = g_rbh.rbh02 AND rbh01=g_rbh.rbh01
        AND rbh03=g_rbh.rbh03 AND rbhplant = g_rbh.rbhplant
#CHI-C30107 ---------------- add ---------------- end   
      #TQC-AC0326 add --------------------begin----------------------
         #生效營運中心中有對應的促銷單並且審核、發布， 才可審核對應的變更單
      	 LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM rah_file,raq_file
          WHERE raq01 =  g_rbh.rbh01  AND raq02 = g_rbh.rbh02  AND  raq03 = '3'
            AND raq04 =  g_rbh.rbhplant  AND  raqplant = g_rbh.rbhplant AND  raqacti = 'Y'
            AND rah01 =  raq01
            AND rah02 =  raq02
            AND rahplant = raqplant
            AND (rahconf != 'Y' OR raq05 = 'N')
         IF l_cnt > 0 THEN
            CALL cl_err(g_rbh.rbh02,'art-998',0)
            RETURN
         END IF
         
         #生效營運中心中有對應的促銷單的未審核變更單序號最小的才可以變更
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM rbh_file 
          WHERE rbh01=g_rbh.rbh01 
            AND rbh02=g_rbh.rbh02 
            AND rbh03<g_rbh.rbh03
            AND rbhconf = 'N'  
            AND rbhplant=g_rbh.rbhplant
         IF l_cnt > 0 THEN
            CALL cl_err(g_rbh.rbh02,'art-997',0)
            RETURN
         END IF
      	 #TQC-AC0326 add ---------------------end-----------------------
   SELECT * INTO g_rbh.* FROM rbh_file 
      WHERE rbh02 = g_rbh.rbh02 AND rbh01=g_rbh.rbh01
        AND rbh03=g_rbh.rbh03 AND rbhplant = g_rbh.rbhplant
   IF g_rbh.rbhconf = 'Y' THEN CALL cl_err(g_rbh.rbh02,9023,0) RETURN END IF
   #IF g_rbh.rbhconf = 'X' THEN CALL cl_err(g_rbh.rbh02,'9024',0) RETURN END IF #FUN-AB0033 mark
   IF g_rbh.rbhacti = 'N' THEN CALL cl_err(g_rbh.rbh02,'art-145',0) RETURN END IF
   #IF g_rbh.rbhconf = 'I' THEN CALL cl_err(g_rbh.rbh02,9023,0) RETURN END IF   #FUN-AB0033 mark 
   
   #FUN-AB0033 mark --------------start-----------------
   #LET l_cnt=0
   #SELECT COUNT(*) INTO l_cnt
   #  FROM rbi_file
   # WHERE rbi02 = g_rbh.rbh02 AND rbi01=g_rbh.rbh01
   #   AND rbi03=g_rbh.rbh03 AND rbiplant = g_rbh.rbhplant
   #IF l_cnt=0 OR l_cnt IS NULL THEN
   #   CALL cl_err('','mfg-009',0)
   #   RETURN
   #END IF
   #FUN-AB0033 mark ---------------end------------------

#FUN-BC0126 add START
   LET g_sql = " SELECT b.rbi10", 
               "   FROM rbi_file b LEFT OUTER JOIN rbi_file a",
               "     ON (b.rbi01=a.rbi01 AND b.rbi02=a.rbi02 AND b.rbi03=a.rbi03 AND ",
               "         b.rbi04=a.rbi04 AND b.rbi06=a.rbi06 AND b.rbiplant=a.rbiplant AND b.rbi05<>a.rbi05 ) ",
               "  WHERE b.rbi01 = '",g_rbh.rbh01, "' AND b.rbiplant='",g_rbh.rbhplant,"'",
               "    AND b.rbi05='1' AND RTRIM(a.rbi10) IS NULL",
               "    AND b.rbi02 = '",g_rbh.rbh02, "' AND b.rbi03=",g_rbh.rbh03 ,
               "  ORDER BY b.rbi04 "
   PREPARE t404_b1_prepare1 FROM g_sql
   DECLARE rbi_cs1 CURSOR FOR t404_b1_prepare1 
   FOREACH rbi_cs1 INTO l_rbi10
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF l_rbi10 <> '0' THEN
          LET l_cnt = 0
          SELECT COUNT(*) INTO l_cnt FROM rbp_file
            WHERE rbp01 = g_rbh.rbh01 AND rbp02 = g_rbh.rbh02
              AND rbp03 = g_rbh.rbh03 AND rbp04 = '3'
              AND rbp12 = l_rbi10 AND rbpacti = 'Y'
              AND rbp06 = '1'
              AND rbpplant = g_rbh.rbhplant
          IF l_cnt < 1 THEN
             CALL cl_err('','art-795',0)
             RETURN
          END IF
       END IF
   END FOREACH
#FUN-BC0126 add END
   
#  IF NOT cl_confirm('art-026') THEN RETURN END IF  #CHI-C30107 mark
   CALL t404_create_temp_table()    #FUN-C60041 ADD
   BEGIN WORK
   OPEN t404_cl USING g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,g_rbh.rbhplant
   
   IF STATUS THEN
      CALL cl_err("OPEN t404_cl:", STATUS, 1)
      CLOSE t404_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t404_cl INTO g_rbh.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rbh.rbh02,SQLCA.sqlcode,0)
      CLOSE t404_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   LET g_success = 'Y'
  # LET g_time =TIME
 
   UPDATE rbh_file SET rbhconf='Y',
                       rbhcond=g_today, 
                       rbhcont=g_time, 
                       rbhconu=g_user
     WHERE  rbh02 = g_rbh.rbh02 AND rbh01=g_rbh.rbh01
       AND rbh03=g_rbh.rbh03 AND rbhplant = g_rbh.rbhplant
   IF SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   END IF
 
   IF g_success = 'Y' THEN
      CALL s_showmsg_init()
      LET g_errno=' '
      CALL t404sub_y_upd(g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,g_rbh.rbhplant)
      CALL s_showmsg()
      IF NOT cl_null(g_errno) THEN
         LET g_success = 'N'
         ROLLBACK WORK
      END IF
   END IF 
   #FUN-C60041 -----------STA
   IF g_success = 'Y' THEN
       CALL t404_iss()
   END IF
   #FUN-C60041 -----------END
   IF g_success = 'Y' THEN
      #LET g_rbh.rbhconf='Y'  #FUN-AB0033 mark
      COMMIT WORK
      CALL cl_flow_notify(g_rbh.rbh02,'Y')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT * INTO g_rbh.* FROM rbh_file 
      WHERE rbh02 = g_rbh.rbh02 AND rbh01=g_rbh.rbh01 
        AND rbh03=g_rbh.rbh03 AND rbhplant = g_rbh.rbhplant
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rbh.rbhconu
   DISPLAY BY NAME g_rbh.rbhconf                                                                                         
   DISPLAY BY NAME g_rbh.rbhcond                                                                                         
   DISPLAY BY NAME g_rbh.rbhcont                                                                                         
   DISPLAY BY NAME g_rbh.rbhconu
   DISPLAY l_gen02 TO FORMONLY.rbhconu_desc
    #CKP
   #FUN-AB0033 mark ------start------
   IF NOT g_rbh.rbhconf='X' THEN 
     LET g_chr='N'
   END IF
   #FUN-AB0033 mark ------start------
   CALL cl_set_field_pic(g_rbh.rbhconf,"","","",g_chr,"") 
#FUN-C60041 ---------mark--------begin
#  #TQC-AC0326 add -----------begin------------
#   IF g_success = 'Y' THEN 
#      CALL t404_iss() 
#   ELSE
#     ROLLBACK WORK    
#   END IF    
#   #TQC-AC0326 add -----------begin------------
#FUN-C60041 ---------mark--------end
   CALL t404_drop_temp_table()   #FUN-C60041 add
END FUNCTION
  
#FUN-AB0033 mark ----------start-----------    
#FUNCTION t404_v()
#   IF s_shut(0) THEN RETURN END IF
#   IF cl_null(g_rbh.rbh02) THEN CALL cl_err('',-400,0) RETURN END IF    
#   
#   SELECT * INTO g_rbh.* FROM rbh_file 
#      WHERE rbh02 = g_rbh.rbh02 AND rbh01=g_rbh.rbh01
#        AND rbh03=g_rbh.rbh03 AND rbhplant = g_rbh.rbhplant 
#        
#   IF g_rbh.rbhconf = 'Y' THEN CALL cl_err(g_rbh.rbh02,9023,0) RETURN END IF
#   IF g_rbh.rbhacti = 'N' THEN CALL cl_err(g_rbh.rbh02,'art-142',0) RETURN END IF
#   IF g_rbh.rbhconf = 'X' THEN CALL cl_err(g_rbh.rbh02,'art-148',0) RETURN END IF
#   IF g_rbh.rbhconf = 'I' THEN CALL cl_err(g_rbh.rbh02,9023,0) RETURN END IF
#   BEGIN WORK
# 
#   OPEN t404_cl USING g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,g_rbh.rbhplant
#   IF STATUS THEN
#      CALL cl_err("OPEN t404_cl:", STATUS, 1)
#      CLOSE t404_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
# 
#   FETCH t404_cl INTO g_rbh.*
#   IF SQLCA.sqlcode THEN
#      CALL cl_err(g_rbh.rbh02,SQLCA.sqlcode,0)
#      CLOSE t404_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
# 
#   IF cl_void(0,0,g_rbh.rbhconf) THEN
#      LET g_chr = g_rbh.rbhconf
#      IF g_rbh.rbhconf = 'N' THEN
#         LET g_rbh.rbhconf = 'X'
#      ELSE
#         LET g_rbh.rbhconf = 'N'
#      END IF
# 
#      UPDATE rbh_file SET rbhconf=g_rbh.rbhconf,
#                          rbhmodu=g_user,
#                          rbhdate=g_today
#       WHERE rbh01 = g_rbh.rbh01  AND rbh02 = g_rbh.rbh02
#         AND rbh03 = g_rbh.rbh03 AND rbhplant = g_rbh.rbhplant  
#       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#          CALL cl_err3("upd","rbh_file",g_rbh.rbh02,"",SQLCA.sqlcode,"","upd rbhconf",1)
#          LET g_rbh.rbhconf = g_chr
#          ROLLBACK WORK
#          RETURN
#       END IF
#   END IF
# 
#   CLOSE t404_cl
#   COMMIT WORK
# 
#   SELECT * INTO g_rbh.* FROM rbh_file 
#    WHERE rbh01 = g_rbh.rbh01  AND rbh02 = g_rbh.rbh02
#      AND rbh03 = g_rbh.rbh03 AND rbhplant = g_rbh.rbhplant  
#   DISPLAY BY NAME g_rbh.rbhconf                                                                                        
#   DISPLAY BY NAME g_rbh.rbhmodu                                                                                        
#   DISPLAY BY NAME g_rbh.rbhdate
#    #CKP
#   IF g_rbh.rbhconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
#   CALL cl_set_field_pic(g_rbh.rbhconf,"","","",g_chr,"")
# 
#   CALL cl_flow_notify(g_rbh.rbh02,'V')  
#END FUNCTION
#FUN-AB0033 mark -----------end------------ 

FUNCTION t404_b2_find()
   LET g_rbj[l_ac2].type1  ='1'
   LET g_rbj[l_ac2].before1='0'
   LET g_rbj[l_ac2].after1 ='1'
   
   SELECT raj03,raj04,raj05,raj06,rajacti  
     INTO g_rbj[l_ac2].rbj06_1,g_rbj[l_ac2].rbj07_1,g_rbj[l_ac2].rbj08_1,
          g_rbj[l_ac2].rbj09_1,g_rbj[l_ac2].rbjacti_1
     FROM raj_file
    WHERE raj01=g_rbh.rbh01 AND raj02=g_rbh.rbh02 AND rajplant=g_rbh.rbhplant
      AND raj03=g_rbj[l_ac2].rbj06 AND raj04=g_rbj[l_ac2].rbj07
      
   CALL t404_rbj08_1('d',l_ac2)
   IF NOT cl_null(g_rbj[l_ac2].rbj09_1) THEN
      SELECT gfe02 INTO g_rbj[l_ac2].rbj09_desc_1 
        FROM gfe_file
       WHERE gfe01 = g_rbj[l_ac2].rbj09_1  
      DISPLAY BY NAME g_rbj[l_ac2].rbj09_desc_1
   END IF   
   DISPLAY BY NAME g_rbj[l_ac2].rbj06_1,g_rbj[l_ac2].rbj07_1,g_rbj[l_ac2].rbj08_1,
                   g_rbj[l_ac2].rbj09_1,g_rbj[l_ac2].rbjacti_1
      
   DISPLAY BY NAME g_rbj[l_ac2].type1,g_rbj[l_ac2].before1,g_rbj[l_ac2].after1
   
END FUNCTION 
 
FUNCTION t404_copy()

END FUNCTION 

#FUN-C60041---------mark--------------begin
#FUNCTION t404_iss() 
#DEFINE l_cnt      LIKE type_file.num5
#DEFINE l_dbs      LIKE azp_file.azp03   
#DEFINE l_sql      STRING
#DEFINE l_raq04    LIKE raq_file.raq04
#DEFINE l_rtz11    LIKE rtz_file.rtz11
#DEFINE l_rbhlegal LIKE rbh_file.rbhlegal
#DEFINE l_n        LIKE type_file.num5

  
#  IF s_shut(0) THEN
#     RETURN
#  END IF

#  IF g_rbh.rbh02 IS NULL THEN
#     CALL cl_err('',-400,0)
#     RETURN
#  END IF
#
#  SELECT * INTO g_rbh.* FROM rbh_file 
#     WHERE rbh02 = g_rbh.rbh02 AND rbh01=g_rbh.rbh01
#       AND rbh03 = g_rbh.rbh03 AND rbhplant = g_rbh.rbhplant

#  #IF g_rbh.rbh01<>g_rbh.rbhplant THEN   #FUN-AB0033 mark
#  #   CALL cl_err('','art-663',0)        #FUN-AB0033 mark
#  #   RETURN                             #FUN-AB0033 mark
#  #END IF                                #FUN-AB0033 mark

#  IF g_rbh.rbhacti ='N' THEN
#     CALL cl_err(g_rbh.rbh01,'mfg1000',0)
#     RETURN
#  END IF
#  
#  IF g_rbh.rbhconf = 'N' THEN
#     CALL cl_err('','art-656',0)   #此筆資料未確認不可發布
#     RETURN
#  END IF
#  
#  #FUN-AB0033 mark ------start--------
#  #IF g_rbh.rbhconf = 'X' THEN
#  #   CALL cl_err('','art-661',0)
#  #   RETURN
#  #END IF
#  #IF g_rbh.rbhconf = 'I' THEN
#  #   CALL cl_err('','art-662',0)
#  #   RETURN
#  #END IF
#  #FUN-AB0033 mark -------end---------
#  
# # SELECT COUNT(*) INTO l_cnt FROM rbq_file 
# #  WHERE rbq01 = g_rbh.rbh01 AND rbq02=g_rbh.rbh02 
# #     AND rbq03 = g_rbh.rbh03 AND rbqplant=g_rbh.rbhplant 
# #     AND rbq04='3' AND rbqacti='Y' AND rbq08='N'
# #     AND rbq04='3'  AND rbq08='N'
# #  IF l_cnt=0 THEN
# #    CALL cl_err('','art-662',0)
# #    RETURN
# #  END IF
# 
#
# # OPEN t404_cl USING g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,g_rbh.rbhplant
# # IF STATUS THEN
#  #   CALL cl_err("OPEN t404_cl:", STATUS, 1)
#  #   CLOSE t404_cl
#  #   ROLLBACK WORK
#  #   RETURN
# # END IF
# 
#  #FUN-AB0033 mark --------------start-----------------
#  #SELECT COUNT(*) INTO l_cnt FROM rbi_file
#  # WHERE rbi01 = g_rbh.rbh01 AND rbi02 = g_rbh.rbh02
#  #   AND rbi03 = g_rbh.rbh03 AND rbiplant = g_rbh.rbhplant 
#  #IF l_cnt = 0 THEN
#  #   CALL cl_err('','art-548',0)
#  #   RETURN
#  #END IF
#  
#  #IF NOT cl_confirm('art-660') THEN 
#  #   RETURN
#  #END IF     
#  #FUN-AB0033 mark --------------start-----------------
#  
# # BEGIN WORK
# # LET g_success = 'Y'
# # CALL s_showmsg_init()
#  
#  DROP TABLE rbh_temp
#  SELECT * FROM rbh_file WHERE 1 = 0 INTO TEMP rbh_temp
#  DROP TABLE rbi_temp
#  SELECT * FROM rbi_file WHERE 1 = 0 INTO TEMP rbi_temp
#  DROP TABLE rbj_temp
#  SELECT * FROM rbj_file WHERE 1 = 0 INTO TEMP rbj_temp  
#  DROP TABLE rbp_temp
#  SELECT * FROM rbp_file WHERE 1 = 0 INTO TEMP rbp_temp  
#  DROP TABLE rbq_temp
#  SELECT * FROM rbq_file WHERE 1 = 0 INTO TEMP rbq_temp  
#   DROP TABLE rbr_temp
#  SELECT * FROM rbr_file WHERE 1 = 0 INTO TEMP rbr_temp  
#  DROP TABLE rbs_temp
#  SELECT * FROM rbs_file WHERE 1 = 0 INTO TEMP rbs_temp 
#  DROP TABLE rbk_temp   #FUN-BC0126 add
#  SELECT * FROM rbk_file WHERE 1 = 0 INTO TEMP rbk_temp  #FUN-BC0126 add

#  DROP TABLE rah_temp
#  SELECT * FROM rah_file WHERE 1 = 0 INTO TEMP rah_temp
#  DROP TABLE rai_temp
#  SELECT * FROM rai_file WHERE 1 = 0 INTO TEMP rai_temp
#  DROP TABLE raj_temp
#  SELECT * FROM raj_file WHERE 1 = 0 INTO TEMP raj_temp
#  DROP TABLE rap_temp
#  SELECT * FROM rap_file WHERE 1 = 0 INTO TEMP rap_temp
#  DROP TABLE raq_temp
#  SELECT * FROM raq_file WHERE 1 = 0 INTO TEMP raq_temp
#   DROP TABLE rar_temp
#  SELECT * FROM rar_file WHERE 1 = 0 INTO TEMP rar_temp  
#  DROP TABLE ras_temp
#  SELECT * FROM ras_file WHERE 1 = 0 INTO TEMP ras_temp
#  DROP TABLE rak_temp  #FUN-BC0126 add
#  SELECT * FROM rak_file WHERE 1 = 0 INTO TEMP rak_temp   #FUN-BC0126 add 
# 
#  #BEGIN WORK  #TQC-AC0326 mark 將確認和發佈放到一個事務中
#  LET g_success = 'Y'
#  #UPDATE rbh_file SET rbhconf='I'
#  # WHERE  rbh02 = g_rbh.rbh02 AND rbh01 = g_rbh.rbh01
#  #   AND rbh03 = g_rbh.rbh03  AND rbhplant = g_rbh.rbhplant
#  #IF SQLCA.sqlerrd[3]=0 THEN
#  #   LET g_success='N'
#  #END IF

#  
#  CALL s_showmsg_init()
#  CALL t404_iss_upd()  

#  IF g_success = 'N' THEN
#     CALL s_showmsg()
#     ROLLBACK WORK
#     RETURN
#  END IF
#  IF g_success = 'Y' THEN #拋磚成功
#     COMMIT WORK
#     MESSAGE "OK !"
#     LET g_rbh.rbhconf= 'Y' 
#     DISPLAY BY NAME g_rbh.rbhconf
#     CALL s_showmsg()
#     
#  END IF
#  #DISPLAY BY NAME g_rbh.rbhconf #FUN-AB0033 mark 
#  DROP TABLE rbh_temp
#  DROP TABLE rbi_temp
#  DROP TABLE rbj_temp
#  DROP TABLE rbp_temp
#  DROP TABLE rbq_temp
#  DROP TABLE rbr_temp
#  DROP TABLE rbs_temp
#  DROP TABLE rbk_temp  #FUN-BC0126 add  
#
#  DROP TABLE rah_temp
#  DROP TABLE rai_temp
#  DROP TABLE raj_temp
#  DROP TABLE rap_temp
#  DROP TABLE raq_temp
#  DROP TABLE rar_temp
#  DROP TABLE ras_temp
#  DROP TABLE rak_temp  #FUN-BC0126 add
#END FUNCTION 
#FUN-C60041---------mark--------------end

#FUN-C60041 -----------------STA
FUNCTION t404_iss()
  SELECT * INTO g_rbh.* FROM rbh_file
   WHERE rbh02 = g_rbh.rbh02 AND rbh01=g_rbh.rbh01
     AND rbh03 = g_rbh.rbh03 AND rbhplant = g_rbh.rbhplant
  CALL s_showmsg_init()
  CALL t404_iss_upd()
  IF g_success = 'N' THEN
     CALL s_showmsg()
  END IF
END FUNCTION

#FUN-C60041 -----------------END

FUNCTION t404_iss_upd() 
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_dbs      LIKE azp_file.azp03   
DEFINE l_n        LIKE type_file.num5
DEFINE l_sql      STRING
DEFINE l_rtz11    LIKE rtz_file.rtz11
DEFINE l_rbhlegal LIKE rbh_file.rbhlegal
DEFINE l_raqacti  LIKE raq_file.raqacti
DEFINE l_raq04    LIKE raq_file.raq04

  #LET l_sql="SELECT raq04,raqacti FROM raq_file ",  #FUN-BC0126 mark
   LET l_sql="SELECT DISTINCT raq04 FROM raq_file ",  #FUN-BC0126 add
             " WHERE raq01=? AND raq02=?",
             "   AND raq03='3' AND raqplant=?"
   PREPARE raq_pre FROM l_sql
   DECLARE raq_cs CURSOR FOR raq_pre
   FOREACH raq_cs USING g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbhplant
                  INTO l_raq04,l_raqacti  
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         CALL s_errmsg('','','Foreach rbq_cs:',SQLCA.sqlcode,1)                         
         EXIT FOREACH 
      END IF   
      IF g_rbh.rbhplant<>l_raq04 THEN 
         SELECT COUNT(*) INTO l_cnt FROM azw_file
          WHERE azw07 = g_rbh.rbhplant
            AND azw01 = l_raq04
         IF l_cnt = 0 THEN
            CONTINUE FOREACH
         END IF
      END IF
   #FUN-BC0126 add START
      LET l_n = 0
      LET l_sql="SELECT COUNT(*) FROM raq_file ",
                " WHERE raq01='",g_rbh.rbh01,"'",
                " AND raq02= '",g_rbh.rbh02,"'",
                "   AND raq03='3' AND raqplant='",g_rbh.rbhplant,"'",
                "   AND raq04='",l_raq04,"'",
                "   AND raqacti = 'Y' "
      PREPARE raq_pre1 FROM l_sql
      EXECUTE raq_pre1 INTO l_n
      IF l_n = 0 OR cl_null(l_n) THEN
         LET l_raqacti = 'N'
      ELSE
         LET l_raqacti = 'Y'
      END IF
   #FUN-BC0126 add END

      SELECT azw02 INTO l_rbhlegal FROM azw_file
       WHERE azw01 = l_raq04 AND azwacti='Y'
      SELECT rtz11 INTO l_rtz11 FROM rtz_file WHERE rtz01 = l_raq04

      IF l_raqacti='N' THEN #營運中心無效時
         IF g_rbh.rbhplant <> l_raq04 THEN
            CALL t404_iss_chk(l_raq04) RETURNING l_n
      
            IF l_n>0 THEN    #UPDATE     #若營運中心l_raq04下有資料則先插入此變更單再走審核段
               CALL t404_iss_trans(l_raq04) 
               IF g_success = 'N' THEN
                  EXIT FOREACH
               END IF
               IF l_rtz11='N' THEN
                  #CALL s_showmsg_init()     #FUN-C60041
                  LET g_errno=' '  
                  CALL t404sub_y_upd(g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,l_raq04)
                  #CALL s_showmsg()          #FUN-C60041
                  IF NOT cl_null(g_errno) THEN
                     LET g_success = 'N'
                    #ROLLBACK WORK           #FUN-C60041
                  END IF 
                END IF 
               IF g_success = 'N' THEN
                  EXIT FOREACH
               END IF
            END IF
            IF g_success = 'N' THEN
               EXIT FOREACH
            ELSE 
               CONTINUE FOREACH
            END IF
         END IF
      ELSE                 #營運中心有效時  
      	 
        #CALL t404_iss_trans(l_raq04) 
        #IF g_success = 'N' THEN
        #   EXIT FOREACH
        #END IF
         CALL t404_iss_chk(l_raq04) RETURNING l_n
         IF l_n>0 THEN    #UPDATE 
#FUN-C60041 -------------STA
            CALL t404_iss_trans(l_raq04)
            IF g_success = 'N' THEN
               EXIT FOREACH
            END IF
#FUN-C60041 -------------END
            IF l_rtz11='N' THEN     #若營運中心l_raq04下有資料則直接走審核段 
              #CALL s_showmsg_init()        #FUN-C60041                                                                                        
               LET g_errno=' ' 
               CALL t404sub_y_upd(g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,l_raq04)
              #CALL s_showmsg()             #FUN-C60041
               IF NOT cl_null(g_errno) THEN
                  LET g_success = 'N'
                 #ROLLBACK WORK             #FUN-C60041
               END IF
               IF g_success = 'N' THEN
                  EXIT FOREACH
               END IF
            END IF 
         ELSE   #INSERT #或者是此l_raq04為新增有效或原來無效變更為有效，此時走原artt302發布邏輯
            CALL t404_iss_pretrans(l_raq04)
            IF g_success = 'N' THEN
               EXIT FOREACH
            END IF
         END IF  #UPDATE&INSERT 
      END IF
   END FOREACH

END FUNCTION
 
#判斷營運中心l_raq04下是否有資料
#返回值：l_n
FUNCTION t404_iss_chk(l_raq04)
DEFINE l_n      LIKE type_file.num5
DEFINE l_sql    STRING
DEFINE l_raq04  LIKE raq_file.raq04

   LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_raq04, 'rah_file'),
             " WHERE rah01='",g_rbh.rbh01,"'",
             "   AND rah02='",g_rbh.rbh02,"'",
             "   AND rahplant='",l_raq04,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql
   PREPARE trans_cnt_rah FROM l_sql
   EXECUTE trans_cnt_rah INTO l_n

   RETURN l_n
END FUNCTION
#拋磚當前變更單到營運中心l_raq04下
#返回值:全局變量g_success 
FUNCTION t404_iss_trans(l_raq04) 
DEFINE l_raq04  LIKE raq_file.raq04
DEFINE l_n        LIKE type_file.num5
DEFINE l_sql      STRING
DEFINE l_rtz11    LIKE rtz_file.rtz11
DEFINE l_rbhlegal LIKE rbh_file.rbhlegal

   SELECT azw02 INTO l_rbhlegal FROM azw_file
    WHERE azw01 = l_raq04 AND azwacti='Y'
   SELECT rtz11 INTO l_rtz11 FROM rtz_file WHERE rtz01 = l_raq04

      IF g_rbh.rbhplant = l_raq04 THEN #與當前機構相同則不拋
         UPDATE raq_file SET raq05='Y' 
          WHERE raq01=g_rbh.rbh01 AND raq02=g_rbh.rbh02 
            AND raq03='3' AND raq04=l_raq04 AND raqplant=g_rbh.rbhplant
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","raq_file",g_rbh.rbh02,"",STATUS,"","",1) 
            LET g_success = 'N'
            RETURN
         END IF
         SELECT COUNT(*) INTO l_n FROM rbq_file
          WHERE rbq01=g_rbh.rbh01 AND rbq02=g_rbh.rbh02 AND rbq03=g_rbh.rbh03
            AND rbq04='3' AND rbq07=l_raq04 AND rbqplant=g_rbh.rbhplant
         IF l_n>0 THEN    #此生效機構有變更記錄
            UPDATE rbq_file SET rbq08='Y' 
             WHERE rbq01=g_rbh.rbh01 AND rbq02=g_rbh.rbh02 AND rbq03=g_rbh.rbh03
               AND rbq04='3' AND rbq06='1' AND rbq07=l_raq04 AND rbqplant=g_rbh.rbhplant
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","rbq_file",g_rbh.rbh02,"",STATUS,"","",1) 
               LET g_success = 'N'
               RETURN
            END IF
         END IF
      ELSE
         UPDATE raq_file SET raq05='Y' 
          WHERE raq01=g_rbh.rbh01 AND raq02=g_rbh.rbh02 
            AND raq03='3' AND raq04=l_raq04 AND raqplant=g_rbh.rbhplant
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","raq_file",g_rbh.rbh02,"",STATUS,"","",1) 
            LET g_success = 'N'
            RETURN
         END IF
         SELECT COUNT(*) INTO l_n FROM rbq_file
          WHERE rbq01=g_rbh.rbh01 AND rbq02=g_rbh.rbh02 AND rbq03=g_rbh.rbh03
            AND rbq04='3' AND rbq07=l_raq04 AND rbqplant=g_rbh.rbhplant
         IF l_n>0 THEN    #此生效機構有變更記錄
            UPDATE rbq_file SET rbq08='Y' 
             WHERE rbq01=g_rbh.rbh01 AND rbq02=g_rbh.rbh02 AND rbq03=g_rbh.rbh03
               AND rbq04='3' AND rbq06='1' AND rbq07=l_raq04 AND rbqplant=g_rbh.rbhplant
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","rbq_file",g_rbh.rbh02,"",STATUS,"","",1) 
               LET g_success = 'N'
               RETURN
            END IF
         END IF
        #將數據放入臨時表中處理
         DELETE FROM rbh_temp
         DELETE FROM rbi_temp
         DELETE FROM rbj_temp  
         DELETE FROM rbq_temp
         DELETE FROM rbp_temp
         DELETE FROM rbr_temp
         DELETE FROM rbs_temp
         DELETE FROM rbk_temp #FUN-BC0126 add
         

         INSERT INTO rbh_temp SELECT * FROM rbh_file
          WHERE rbh01 = g_rbh.rbh01 AND rbh02 = g_rbh.rbh02
            AND rbh03 = g_rbh.rbh03 AND rbhplant = g_rbh.rbhplant
         IF l_rtz11='Y' THEN
            UPDATE rbh_temp  SET rbhplant = l_raq04,
                                rbhlegal = l_rbhlegal,
                                rbhconf = 'N',
                                rbhcond = NULL,
                                rbhcont = NULL,
                                rbhconu = NULL
         ELSE
            UPDATE rbh_temp SET rbhplant = l_raq04,
                                rbhlegal = l_rbhlegal,
                                rbhconf = 'Y',
                                rbhcond = g_today,
                                rbhcont = g_time,
                                rbhconu = g_user
         END IF
         INSERT INTO rbi_temp SELECT rbi_file.* FROM rbi_file
                               WHERE rbi01 = g_rbh.rbh01 AND rbi02 = g_rbh.rbh02
                                 AND rbi03 = g_rbh.rbh03 AND rbiplant = g_rbh.rbhplant
         UPDATE rbi_temp SET rbiplant=l_raq04,
                             rbilegal = l_rbhlegal

         INSERT INTO rbj_temp SELECT rbj_file.* FROM rbj_file
                               WHERE rbj01 = g_rbh.rbh01 AND rbj02 = g_rbh.rbh02
                                 AND rbj03 = g_rbh.rbh03 AND rbjplant = g_rbh.rbhplant
         UPDATE rbj_temp SET rbjplant=l_raq04,
                             rbjlegal = l_rbhlegal
         
                             
         INSERT INTO rbp_temp SELECT rbp_file.* FROM rbp_file
                               WHERE rbp01 = g_rbh.rbh01 AND rbp02 = g_rbh.rbh02
                                 AND rbp03 = g_rbh.rbh03  AND rbp04 ='3'
#                                AND rbqplant = g_rbh.rbhplant       #FUN-C60041 mark
                                 AND rbpplant = g_rbh.rbhplant       #FUN-C60041 add
        UPDATE rbp_temp SET rbpplant=l_raq04,
                            rbplegal = l_rbhlegal
         INSERT INTO rbq_temp SELECT * FROM rbq_file
                              WHERE rbq01=g_rbh.rbh01 AND rbq02 = g_rbh.rbh02
                                AND rbq03=g_rbh.rbh03 AND rbq04 ='3' 
                                AND rbqplant = g_rbh.rbhplant
         UPDATE rbq_temp SET rbqplant = l_raq04,
                             rbq08    = 'Y',
                             rbqlegal = l_rbhlegal
         INSERT INTO rbr_temp SELECT rbr_file.* FROM rbr_file
                               WHERE rbr01 = g_rbh.rbh01 AND rbr02 = g_rbh.rbh02
                                 AND rbr03 = g_rbh.rbh03 AND rbr04 ='3' 
                                 AND rbrplant = g_rbh.rbhplant
         UPDATE rbr_temp SET rbrplant=l_raq04,
                             rbrlegal = l_rbhlegal
         INSERT INTO rbs_temp SELECT rbs_file.* FROM rbs_file
                               WHERE rbs01 = g_rbh.rbh01 AND rbs02 = g_rbh.rbh02
                                 AND rbs03 = g_rbh.rbh03 AND rbs04 ='3' 
                                 AND rbsplant = g_rbh.rbhplant
         UPDATE rbs_temp SET rbsplant=l_raq04,
                             rbslegal = l_rbhlegal
         #FUN-BC0126 add START
         INSERT INTO rbk_temp SELECT rbk_file.* FROM rbk_file
                               WHERE rbk01 = g_rbh.rbh01 AND rbk02 = g_rbh.rbh02
                                 AND rbk03 = g_rbh.rbh03 AND rbk05 ='3'
                                 AND rbkplant = g_rbh.rbhplant
         UPDATE rbk_temp SET rbkplant=l_raq04,
                             rbklegal = l_rbhlegal
         #FUN-BC0126 add END
  
        
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rbh_file'),
                     " SELECT * FROM rbh_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql
         PREPARE trans_ins_rbh FROM l_sql
         EXECUTE trans_ins_rbh
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO rbh_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           RETURN
         END IF
         
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rbi_file'), 
                     " SELECT * FROM rbi_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql 
         PREPARE trans_ins_rbi FROM l_sql
         EXECUTE trans_ins_rbi
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO rbi_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           RETURN
         END IF 

         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rbj_file'), 
                     " SELECT * FROM rbj_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql 
         PREPARE trans_ins_rbj FROM l_sql
         EXECUTE trans_ins_rbj
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO rbj_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           RETURN
         END IF 

         
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rbp_file'), 
                     " SELECT * FROM rbp_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql 
         PREPARE trans_ins_rbp FROM l_sql
         EXECUTE trans_ins_rbp
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO rbp_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           RETURN
         END IF 

         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rbq_file'), 
                     " SELECT * FROM rbq_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql 
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql  
         PREPARE trans_ins_rbq FROM l_sql
         EXECUTE trans_ins_rbq
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO rbq_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           RETURN
         END IF

         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rbr_file'), 
                     " SELECT * FROM rbr_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql 
         PREPARE trans_ins_rbr FROM l_sql
         EXECUTE trans_ins_rbr
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO rbr_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           RETURN
         END IF 
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rbs_file'), 
                     " SELECT * FROM rbs_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql 
         PREPARE trans_ins_rbs FROM l_sql
         EXECUTE trans_ins_rbs
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO rbs_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           RETURN
         END IF 

     #FUN-BC0126 add START
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rbk_file'),
                     " SELECT * FROM rbk_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql
         PREPARE trans_ins_rbk FROM l_sql
         EXECUTE trans_ins_rbk
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO rbk_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           RETURN
         END IF
     #FUN-BC0126 add END
      END IF 

END FUNCTION

#變更新增有效營運中心或變更原促銷當中無效營運中心為有效時
#即：若營運中心l_raq04下無此筆促銷變更單時直接插入變更後的一般促銷單
#即：走artt304發布邏輯
#返回值：全局變量g_success
FUNCTION t404_iss_pretrans(l_raq04)
DEFINE l_raq04  LIKE raq_file.raq04
DEFINE l_n        LIKE type_file.num5
DEFINE l_sql      STRING
DEFINE l_rtz11    LIKE rtz_file.rtz11
DEFINE l_rbhlegal LIKE rbh_file.rbhlegal
   LET g_time = TIME
   SELECT azw02 INTO l_rbhlegal FROM azw_file
    WHERE azw01 = l_raq04 AND azwacti='Y'
   SELECT rtz11 INTO l_rtz11 FROM rtz_file WHERE rtz01 = l_raq04

            DELETE FROM rah_temp
            DELETE FROM rai_temp
            DELETE FROM raj_temp
            DELETE FROM raq_temp
            DELETE FROM rap_temp
            DELETE FROM rar_temp
            DELETE FROM ras_temp
            DELETE FROM rak_temp 

           INSERT INTO rah_temp SELECT * FROM rah_file
             WHERE rah01 = g_rbh.rbh01 AND rah02 = g_rbh.rbh02
               AND rahplant = g_rbh.rbhplant
            IF l_rtz11='Y' THEN
               UPDATE rah_temp SET rahplant = l_raq04,
                                   rahlegal = l_rbhlegal,
                                   rahconf = 'N',
                                   rahcond = NULL,
                                   rahcont = NULL,
                                   rahconu = NULL
            ELSE
               UPDATE rah_temp SET rahplant = l_raq04,
                                   rahlegal = l_rbhlegal,
                                   rahconf = 'Y',
                                   rahcond = g_today,
                                   rahcont = g_time,
                                   rahconu = g_user
            END IF
            INSERT INTO rai_temp SELECT rai_file.* FROM rai_file
                                  WHERE rai01 = g_rbh.rbh01 AND rai02 = g_rbh.rbh02
                                    AND raiplant = g_rbh.rbhplant
            UPDATE rai_temp SET raiplant=l_raq04,
                                railegal = l_rbhlegal
   
            INSERT INTO raj_temp SELECT raj_file.* FROM raj_file
                                  WHERE raj01 = g_rbh.rbh01 AND raj02 = g_rbh.rbh02
                                    AND rajplant = g_rbh.rbhplant
            UPDATE raj_temp SET rajplant=l_raq04,
                                rajlegal = l_rbhlegal
            
            INSERT INTO rap_temp SELECT rap_file.* FROM rajpfile
                                  WHERE rap01 = g_rbh.rbh01 AND rap02 = g_rbh.rbh02
                                   AND rap03 ='3' AND rapplant = g_rbh.rbhplant
            UPDATE rap_temp SET rapplant=l_raq04,
                                raplegal = l_rbhlegal
   
            
   
            INSERT INTO raq_temp SELECT * FROM raq_file
             WHERE raq01=g_rbh.rbh01 AND raq02 = g_rbh.rbh02
               AND raq03 ='3' AND raqplant = g_rbh.rbhplant
#FUN-C60041 ----------------STA
#           UPDATE raq_temp SET raqplant = l_raq04,
#                               raq05    = 'Y',
#                               raqlegal = l_rbhlegal
            UPDATE raq_temp SET raqplant = l_raq04,
                                raqlegal = l_rbhlegal,
                                raq05    = 'Y',
                                raq06 = g_today,
                                raq07 = g_time
#FUN-C60041 ----------------END
#FUN-C60041 ---------------------STA
#           INSERT INTO rbr_temp SELECT rbr_file.* FROM rbr_file
#                              WHERE rbr01 = g_rbh.rbh01 AND rbr02 = g_rbh.rbh02
#                                AND rar03 ='3' AND rarplant = g_rbh.rbhplant
#           UPDATE rbr_temp SET rbrplant=l_raq04,
#                               rbrlegal = l_rbhlegal
#           INSERT INTO rbs_temp SELECT rbs_file.* FROM rbs_file
#                              WHERE rbs01 = g_rbh.rbh01 AND rbs02 = g_rbh.rbh02
#                                AND ras03 ='3' AND rasplant = g_rbh.rbhplant
#           UPDATE rbs_temp SET rbsplant=l_raq04,
#                            rbslegal = l_rbhlegal              
            INSERT INTO rar_temp SELECT rar_file.* FROM rar_file
                                  WHERE rar01 = g_rbh.rbh01 AND rar02 = g_rbh.rbh02
                                    AND rar03 ='3' AND rarplant = g_rbh.rbhplant
            UPDATE rar_temp SET rarplant=l_raq04,
                                rarlegal = l_rbhlegal
            INSERT INTO ras_temp SELECT ras_file.* FROM ras_file
                                  WHERE ras01 = g_rbh.rbh01 AND ras02 = g_rbh.rbh02
                                    AND ras03 ='3' AND rasplant = g_rbh.rbhplant
            UPDATE ras_temp SET rasplant=l_raq04,
                             raslegal = l_rbhlegal
#FUN-C60041 ---------------------END      
          #FUN-BC0126 add START
            INSERT INTO rak_temp SELECT rak_file.* FROM rak_file
                                  WHERE rak01 = g_rbh.rbh01 AND rak02 = g_rbh.rbh02
                                    AND rak03 ='3' AND rakplant = g_rbh.rbhplant
            UPDATE rak_temp SET rakplant=l_raq04,
                                raklegal = l_rbhlegal
          #FUN-BC0126 add END   
   
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rah_file'),
                        " SELECT * FROM rah_temp"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql
            PREPARE trans_ins_rah FROM l_sql
            EXECUTE trans_ins_rah
            IF SQLCA.sqlcode THEN
              CALL s_errmsg('','','INSERT INTO rah_file:',SQLCA.sqlcode,1)
              LET g_success = 'N'
              RETURN
            END IF
   
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rai_file'),
                        " SELECT * FROM rai_temp"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql
            PREPARE trans_ins_rai FROM l_sql
            EXECUTE trans_ins_rai
            IF SQLCA.sqlcode THEN
              CALL s_errmsg('','','INSERT INTO rai_file:',SQLCA.sqlcode,1)
              LET g_success = 'N'
              RETURN
            END IF
   
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'raj_file'),
                        " SELECT * FROM raj_temp"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql
            PREPARE trans_ins_raj FROM l_sql
            EXECUTE trans_ins_raj
            IF SQLCA.sqlcode THEN
              CALL s_errmsg('','','INSERT INTO raj_file:',SQLCA.sqlcode,1)
              LET g_success = 'N'
              RETURN
            END IF
        
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rap_file'),
                        " SELECT * FROM rap_temp"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql
            PREPARE trans_ins_rap FROM l_sql
            EXECUTE trans_ins_rap
            IF SQLCA.sqlcode THEN
              CALL s_errmsg('','','INSERT INTO rap_file:',SQLCA.sqlcode,1)
              LET g_success = 'N'
              RETURN
            END IF
   
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'raq_file'),
                        " SELECT * FROM raq_temp"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql
            PREPARE trans_ins_raq FROM l_sql
            EXECUTE trans_ins_raq
            IF SQLCA.sqlcode THEN
              CALL s_errmsg('','','INSERT INTO raq_file:',SQLCA.sqlcode,1)
              LET g_success = 'N'
              RETURN
            END IF 
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rar_file'), 
                     " SELECT * FROM rar_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql 
         PREPARE trans_ins_rar FROM l_sql
         EXECUTE trans_ins_rar
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO rar_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           RETURN
         END IF 
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'ras_file'), 
                     " SELECT * FROM ras_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql 
         PREPARE trans_ins_ras FROM l_sql
         EXECUTE trans_ins_ras
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO ras_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           RETURN
         END IF 
        #FUN-BC0126 add START
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rak_file'),
                     " SELECT * FROM rak_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql
         PREPARE trans_ins_rak FROM l_sql
         EXECUTE trans_ins_rak
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO rak_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           RETURN
         END IF
        #FUN-BC0126 add END
            
END FUNCTION



FUNCTION t404_b2_init()
   LET g_rbj[l_ac2].type1    ='0'
   LET g_rbj[l_ac2].before1  =' '
   LET g_rbj[l_ac2].after1   ='1'
   LET g_rbj[l_ac2].rbj06_1 = NULL
   LET g_rbj[l_ac2].rbj07_1 = NULL
   LET g_rbj[l_ac2].rbj08_1 = NULL
   LET g_rbj[l_ac2].rbj08_desc_1 = NULL
   LET g_rbj[l_ac2].rbj09_1 = NULL 
   LET g_rbj[l_ac2].rbj09_desc_1 = NULL
   LET g_rbj[l_ac2].rbjacti_1 = NULL
   CALL t404_rbj07()
END FUNCTION  


FUNCTION t404_rbj08(p_cmd,p_cnt)
   DEFINE l_n         LIKE type_file.num5
   DEFINE p_cmd       LIKE type_file.chr1 
   DEFINE p_cnt       LIKE type_file.num5 

   DEFINE    l_imaacti  LIKE ima_file.imaacti, 
             l_ima02    LIKE ima_file.ima02,
             l_ima25    LIKE ima_file.ima25

   DEFINE    l_obaacti  LIKE oba_file.obaacti,
             l_oba02    LIKE oba_file.oba02

   DEFINE    l_tqaacti  LIKE tqa_file.tqaacti,
             l_tqa02    LIKE tqa_file.tqa02,
             l_tqa05    LIKE tqa_file.tqa05,
             l_tqa06    LIKE tqa_file.tqa06

   LET g_errno = ' '    
   
   CASE g_rbj[p_cnt].rbj07
      WHEN '01'
       #IF cl_null(g_rtz05) THEN                  #FUN-AB0101
        IF cl_null(g_rtz04) THEN                  #FUN-AB0101
           SELECT DISTINCT ima02,ima25,imaacti
             INTO l_ima02,l_ima25,l_imaacti
             FROM ima_file
            WHERE ima01=g_rbj[p_cnt].rbj08  
           CASE
              WHEN SQLCA.sqlcode=100   LET g_errno=100
                                       LET l_ima02=NULL
              WHEN l_imaacti='N'       LET g_errno='9028'
              OTHERWISE
              LET g_errno=SQLCA.sqlcode USING '------'
           END CASE
        ELSE    
           SELECT DISTINCT ima02,ima25,rte07
             INTO l_ima02,l_ima25,l_imaacti
             FROM ima_file,rte_file
            WHERE ima01 = rte03 AND ima01=g_rbj[p_cnt].rbj08
              AND rte01 = g_rtz04                        #FUN-AB0101
           CASE
              WHEN SQLCA.sqlcode=100   LET g_errno='art-030'
                                       LET l_ima02=NULL
              WHEN l_imaacti='N'       LET g_errno='9028'
              OTHERWISE
              LET g_errno=SQLCA.sqlcode USING '------'
           END CASE
         END IF
      WHEN '02'
         SELECT DISTINCT oba02,obaacti 
           INTO l_oba02,l_obaacti
           FROM oba_file
          WHERE oba01=g_rbj[p_cnt].rbj08 AND obaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_oba02=NULL
            WHEN l_obaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      WHEN '03'
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbj[p_cnt].rbj08 AND tqa03='1' AND tqaacti='Y' 
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      WHEN '04'
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbj[p_cnt].rbj08 AND tqa03='2' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      WHEN '05'
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbj[p_cnt].rbj08 AND tqa03='3' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      WHEN '06'
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbj[p_cnt].rbj08 AND tqa03='4' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      WHEN '07'
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbj[p_cnt].rbj08 AND tqa03='5' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      WHEN '08'
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbj[p_cnt].rbj08 AND tqa03='6' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      WHEN '09'
         SELECT DISTINCT tqa02,tqa05,tqa06,tqaacti
           INTO l_tqa02,l_tqa05,l_tqa06,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbj[p_cnt].rbj08 AND tqa03='27' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
                                     LET l_tqa05=NULL
                                     LET l_tqa06=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      END CASE

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      CASE g_rbj[p_cnt].rbj07
         WHEN '01'
            LET g_rbj[p_cnt].rbj08_desc = l_ima02
            IF cl_null(g_rbj[p_cnt].rbj09) THEN
               LET g_rbj[p_cnt].rbj09   = l_ima25
            END IF
            SELECT gfe02 INTO g_rbj[p_cnt].rbj09_desc FROM gfe_file
             WHERE gfe01=g_rbj[p_cnt].rbj09 AND gfeacti='Y'
         WHEN '02'
            LET g_rbj[p_cnt].rbj09 = ''
            LET g_rbj[p_cnt].rbj09_desc = ''
            LET g_rbj[p_cnt].rbj08_desc = l_oba02
         WHEN '09'
            LET g_rbj[p_cnt].rbj09 = ''
            LET g_rbj[p_cnt].rbj09_desc = ''
            LET g_rbj[p_cnt].rbj08_desc = l_tqa02 CLIPPED,">"
            LET l_tqa02 = l_tqa05
            LET g_rbj[p_cnt].rbj08_desc = g_rbj[p_cnt].rbj08_desc CLIPPED,":",l_tqa02 CLIPPED,"-"
            LET l_tqa02 = l_tqa06
            LET g_rbj[p_cnt].rbj08_desc = g_rbj[p_cnt].rbj08_desc CLIPPED,l_tqa02 CLIPPED
         OTHERWISE
            LET g_rbj[p_cnt].rbj09 = ''
            LET g_rbj[p_cnt].rbj09_desc = ''
            LET g_rbj[p_cnt].rbj08_desc = l_tqa02
      END CASE
      DISPLAY BY NAME g_rbj[p_cnt].rbj08_desc,g_rbj[p_cnt].rbj09,g_rbj[p_cnt].rbj09_desc
   END IF
END FUNCTION 
 
FUNCTION t404_rbi_entry(p_rbh10t)
 #  DEFINE p_rbi07    LIKE rbi_file.rbi07 
 #  LET g_errno=' '
 #     IF p_rbi07<=0 THEN
 #        LET g_errno='aem-042'
 #        RETURN
 #     END IF
 
#END FUNCTION   

#FUNCTION t404_rbh10t_entry(p_rbh10t)
DEFINE p_rbh10t    LIKE rbh_file.rbh10    
          CASE p_rbh10t             
          WHEN '2'
                CALL cl_set_comp_entry("rbi08",TRUE)
                CALL cl_set_comp_entry("rbi09",FALSE)
                CALL cl_set_comp_required("rbi08",TRUE)
             WHEN '3'
                CALL cl_set_comp_entry("rbi08",FALSE)
                CALL cl_set_comp_entry("rbi09",TRUE)
                CALL cl_set_comp_required("rbi09",TRUE)
             OTHERWISE
                CALL cl_set_comp_entry("rbi08",TRUE)
                CALL cl_set_comp_entry("rbi09",TRUE)
                CALL cl_set_comp_required("rbi08",TRUE)
                CALL cl_set_comp_required("rbi09",TRUE)
          END CASE
           
         #IF g_rbi[l_ac1].rbi10='Y' THEN  #FUN-BC0126 mark
          IF g_rbi[l_ac1].rbi10<>'0' THEN #FUN-BC0126 add
             CALL cl_set_comp_entry("rbi11,rbi12",FALSE)
          ELSE
             CASE p_rbh10t             
               WHEN '2'
                   CALL cl_set_comp_entry("rbi11",TRUE)
                   CALL cl_set_comp_entry("rbi12",FALSE)
                   CALL cl_set_comp_required("rbi11",TRUE)
                WHEN '3'
                   CALL cl_set_comp_entry("rbi11",FALSE)
                   CALL cl_set_comp_entry("rbi12",TRUE)
                   CALL cl_set_comp_required("rbi12",TRUE)
                OTHERWISE
                   CALL cl_set_comp_entry("rbi11",TRUE)
                   CALL cl_set_comp_entry("rbi12",TRUE)
                   CALL cl_set_comp_required("rbi11",TRUE)
                   CALL cl_set_comp_required("rbi12",TRUE)
             END CASE
          END IF  
END FUNCTION
FUNCTION t404_rbh10t()
   IF NOT cl_null(g_rbh.rbh10t) THEN
      IF g_rbh.rbh10t = '2' THEN  #FUN-BC0126 add
     #CASE g_rbh.rbh10t   #FUN-BC0126 mark 
     # WHEN '2'           #FUN-BC0126 mark
                CALL cl_set_comp_visible("dummy5,rbi09,rbi09_1",FALSE)
                CALL cl_set_comp_visible("dummy8,rbi12,rbi12_1",FALSE)   
                CALL cl_set_comp_visible("dummy4,rbi08,rbi08_1",TRUE)
                CALL cl_set_comp_visible("dummy7,rbi11,rbi11_1",TRUE)
               #CALL cl_set_comp_visible("dummy27,rbi13,rbi13_1",FALSE)  #FUN-C30151 mark
               #FUN-C30151 add START
                IF g_rbh.rbh25t = '1' THEN
                   CALL cl_set_comp_visible("dummy27,rbi13,rbi13_1",FALSE)
                ELSE
                   CALL cl_set_comp_visible("dummy27,rbi13,rbi13_1",TRUE)
                END IF
               #FUN-C30151 add END
       ELSE  #FUN-BC0126 add
      #WHEN '3'  #FUN-BC0126 mark 
                CALL cl_set_comp_visible("dummy5,rbi09,rbi09_1",TRUE)
                CALL cl_set_comp_visible("dummy8,rbi12,rbi12_1",TRUE)   
                CALL cl_set_comp_visible("dummy4,rbi08,rbi08_1",FALSE)
                CALL cl_set_comp_visible("dummy7,rbi11,rbi11_1",FALSE)
                CALL cl_set_comp_visible("dummy27,rbi13,rbi13_1",TRUE)
     #END CASE  #FUN-BC0126 mark
      END IF    #FUN-BC0126 add
   END IF
END FUNCTION


FUNCTION t404_rbj06() 
   DEFINE l_n     LIKE type_file.num5
   DEFINE l_raiacti     LIKE rai_file.raiacti
   LET g_errno = ' '
   LET l_n=0

   SELECT COUNT(*) INTO l_n FROM rbi_file
    WHERE rbi01 = g_rbh.rbh01 AND rbi02 = g_rbh.rbh02
      AND rbi03 = g_rbh.rbh03 AND rbiplant=g_rbh.rbhplant
      AND rbi06 = g_rbj[l_ac2].rbj06 AND rbi05='1'
      AND rbiacti='Y'

   IF l_n<1 THEN  
      SELECT COUNT(*) INTO l_n FROM rai_file
       WHERE rai01=g_rbh.rbh01 AND rai02=g_rbh.rbh02
         AND raiplant=g_rbh.rbhplant 
         AND rai03=g_rbj[l_ac2].rbj06
         AND raiacti='Y'
      IF l_n<1 THEN
         LET g_errno = 'art-669'     #當前組別不在第一單身中,也不在原促銷單中
      END IF
   END IF
END FUNCTION

#FUNCTION t404_rbj07_chk() 
#DEFINE l_rbi07    LIKE rbi_file.rbi07
#SELECT DISTINCT rbi07 INTO l_rbi07 FROM rbi_file
#    WHERE rbi01=g_rbh.rbh01 AND rbi02=g_rbh.rbh02
#      AND rbiplant=g_rbh.rbhplant AND rbi05='1'
#      AND rbi03=g_rbj[l_ac2].rbj06 
      
#       IF cl_null(l_rbi07) THEN
#      SELECT DISTINCT rai04 INTO l_rbi07 FROM rai_file
#       WHERE rai01=g_rbh.rbh01 AND rai02 = g_rbh.rbh02
#         AND raiplant =g_rbh.rbhplant 
#         AND rai03=g_rbj[l_ac2].rbj06
#   END IF

#   IF l_rbi07 <=0  THEN
#         LET g_errno='aem-042'
#         RETURN
#      END IF
#END FUNCTION
 

FUNCTION t404_rbj07()
   IF g_rbj[l_ac2].rbj07='01' THEN
      CALL cl_set_comp_entry("rbj09",TRUE)
      CALL cl_set_comp_required("rbj09",TRUE)
   ELSE
      CALL cl_set_comp_entry("rbj09",FALSE)
   END IF
END FUNCTION
FUNCTION t404_rbj08_1(p_cmd,p_cnt)
   DEFINE l_n         LIKE type_file.num5
   DEFINE p_cmd       LIKE type_file.chr1 
   DEFINE p_cnt       LIKE type_file.num5 
   DEFINE l_imaacti   LIKE ima_file.imaacti, 
          l_ima02     LIKE ima_file.ima02,
          l_ima25     LIKE ima_file.ima25
   DEFINE l_obaacti   LIKE oba_file.obaacti,
          l_oba02     LIKE oba_file.oba02
   DEFINE l_tqaacti  LIKE tqa_file.tqaacti,
          l_tqa02    LIKE tqa_file.tqa02,
          l_tqa05    LIKE tqa_file.tqa05,
          l_tqa06    LIKE tqa_file.tqa06
   LET g_errno = ' '   
   
   CASE g_rbj[p_cnt].rbj07_1
      WHEN '01'
      # IF cl_null(g_rtz05) THEN                     #FUN-AB0101
        IF cl_null(g_rtz04) THEN                     #FUN-AB0101 
           SELECT DISTINCT ima02,ima25,imaacti
             INTO l_ima02,l_ima25,l_imaacti
             FROM ima_file
            WHERE ima01=g_rbj[p_cnt].rbj08_1  
           CASE
              WHEN SQLCA.sqlcode=100   LET g_errno=100
                                       LET l_ima02=NULL
              WHEN l_imaacti='N'       LET g_errno='9028'
              OTHERWISE
              LET g_errno=SQLCA.sqlcode USING '------'
           END CASE
        ELSE    
           SELECT DISTINCT ima02,ima25,rte07
             INTO l_ima02,l_ima25,l_imaacti
             FROM ima_file,rte_file
            WHERE ima01 = rte03 AND ima01=g_rbj[p_cnt].rbj08_1
              AND rte01 = g_rtz04                             #FUN-AB0101
           CASE
              WHEN SQLCA.sqlcode=100   LET g_errno='art-030'
                                       LET l_ima02=NULL
              WHEN l_imaacti='N'       LET g_errno='9028'
              OTHERWISE
              LET g_errno=SQLCA.sqlcode USING '------'
           END CASE
         END IF
      WHEN '02'
         SELECT DISTINCT oba02,obaacti 
           INTO l_oba02,l_obaacti
           FROM oba_file
          WHERE oba01=g_rbj[p_cnt].rbj08_1 AND obaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_oba02=NULL
            WHEN l_obaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      WHEN '03'
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbj[p_cnt].rbj08_1 AND tqa03='1' AND tqaacti='Y' 
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      WHEN '04'
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbj[p_cnt].rbj08_1 AND tqa03='2' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      WHEN '05'
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbj[p_cnt].rbj08_1 AND tqa03='3' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      WHEN '06'
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbj[p_cnt].rbj08_1 AND tqa03='4' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      WHEN '07'
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbj[p_cnt].rbj08_1 AND tqa03='5' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      WHEN '08'
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbj[p_cnt].rbj08_1 AND tqa03='6' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      WHEN '09'
         SELECT DISTINCT tqa02,tqa05,tqa06,tqaacti
           INTO l_tqa02,l_tqa05,l_tqa06,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbj[p_cnt].rbj08_1 AND tqa03='27' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
                                     LET l_tqa05=NULL
                                     LET l_tqa06=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      END CASE

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      CASE g_rbj[p_cnt].rbj07_1
         WHEN '01'
            LET g_rbj[p_cnt].rbj08_desc_1 = l_ima02
            IF cl_null(g_rbj[p_cnt].rbj09_1) THEN
               LET g_rbj[p_cnt].rbj09_1   = l_ima25
            END IF
            SELECT gfe02 INTO g_rbj[p_cnt].rbj09_desc_1 FROM gfe_file
             WHERE gfe01=g_rbj[p_cnt].rbj09_1 AND gfeacti='Y'
         WHEN '02'
            LET g_rbj[p_cnt].rbj09_1 = ''
            LET g_rbj[p_cnt].rbj09_desc_1 = ''
            LET g_rbj[p_cnt].rbj08_desc_1 = l_oba02
         WHEN '09'
            LET g_rbj[p_cnt].rbj09_1 = ''
            LET g_rbj[p_cnt].rbj09_desc_1 = ''
            LET g_rbj[p_cnt].rbj08_desc_1 = l_tqa02 CLIPPED,">"
            LET l_tqa02 = l_tqa05
            LET g_rbj[p_cnt].rbj08_desc_1 = g_rbj[p_cnt].rbj08_desc_1 CLIPPED,":",l_tqa02 CLIPPED,"-"
            LET l_tqa02 = l_tqa06
            LET g_rbj[p_cnt].rbj08_desc_1 = g_rbj[p_cnt].rbj08_desc_1 CLIPPED,l_tqa02 CLIPPED
         OTHERWISE
            LET g_rbj[p_cnt].rbj09_1 = ''
            LET g_rbj[p_cnt].rbj09_desc_1 = ''
            LET g_rbj[p_cnt].rbj08_desc_1 = l_tqa02
      END CASE
      DISPLAY BY NAME g_rbj[p_cnt].rbj08_desc_1,g_rbj[p_cnt].rbj09_1,g_rbj[p_cnt].rbj09_desc_1
   END IF
END FUNCTION
FUNCTION t404_rbj09(p_cmd)
    DEFINE p_cmd       LIKE type_file.chr1   
    DEFINE l_gfe02     LIKE gfe_file.gfe02
    DEFINE l_gfeacti   LIKE gfe_file.gfeacti
    DEFINE l_ima25     LIKE ima_file.ima25
    DEFINE l_flag      LIKE type_file.num5,
           l_fac       LIKE ima_file.ima31_fac   
   LET g_errno = ' '
   IF g_rbj[l_ac2].rbj07<>'01' THEN
      RETURN
   END IF
   IF NOT cl_null(g_rbj[l_ac2].rbj08) THEN
      SELECT DISTINCT ima25
        INTO l_ima25
        FROM ima_file
       WHERE ima01=g_rbj[l_ac2].rbj08  

      CALL s_umfchk(g_rbj[l_ac2].rbj08,l_ima25,g_rbj[l_ac2].rbj09)
         RETURNING l_flag,l_fac   
      IF l_flag = 1 THEN
         LET g_errno = 'ams-823'
         RETURN
      END IF
   END IF
   SELECT gfe02,gfeacti
     INTO l_gfe02,l_gfeacti
     FROM gfe_file 
    WHERE gfe01 = g_rbj[l_ac2].rbj09 AND gfeacti = 'Y' 
   CASE 
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'mfg3377'
      WHEN l_gfeacti='N'       LET g_errno ='9028'
      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------' 
   END CASE
   IF cl_null(g_errno) OR p_cmd='d' THEN 
      LET g_rbj[l_ac2].rbj09_desc=l_gfe02
      DISPLAY BY NAME g_rbj[l_ac2].rbj09_desc
   END IF    
END FUNCTION 


FUNCTION t404_b1_init() 
    LET g_rbi[l_ac1].type    ='0'
    LET g_rbi[l_ac1].before  =' '
    LET g_rbi[l_ac1].after   ='1'       
   #LET g_rbi[l_ac1].rbiacti = 'Y'  #FUN-BC0126 mark
    LET g_rbi[l_ac1].rbiacti = 'Y'   #FUN-BC0126 add 
    LET g_rbi[l_ac1].rbi06_1 = NULL
    LET g_rbi[l_ac1].rbi07_1 = NULL
    LET g_rbi[l_ac1].rbi08_1 = NULL
    LET g_rbi[l_ac1].rbi13_1 = NULL   #FUN-BC0126 add 
    LET g_rbi[l_ac1].rbi09_1 = NULL
    LET g_rbi[l_ac1].rbi10_1 = NULL
    LET g_rbi[l_ac1].rbi10 = '0'  #FUN-BC0126 add
    LET g_rbi[l_ac1].rbi11_1 = NULL
    LET g_rbi[l_ac1].rbi12_1 = NULL    
    LET g_rbi[l_ac1].rbiacti_1 = NULL    
END FUNCTION



FUNCTION t404_b1_find() 
DEFINE p_rbh10t    LIKE rbh_file.rbh10
   CASE g_rbh.rbh10t
   WHEN '2'
   LET g_rbi[l_ac1].type  ='1'
   LET g_rbi[l_ac1].before='0'
   LET g_rbi[l_ac1].after ='1'
   
   SELECT rai03,rai04,rai05,rai07,rai08,raiacti,rai10  #FUN-BC0126 add rai10
     INTO g_rbi[l_ac1].rbi06_1,g_rbi[l_ac1].rbi07_1,g_rbi[l_ac1].rbi08_1,
          g_rbi[l_ac1].rbi10_1,g_rbi[l_ac1].rbi11_1,g_rbi[l_ac1].rbiacti_1,g_rbi[l_ac1].rbi13_1  #FUN-BC0126 add rai13
     FROM rai_file
    WHERE rai01=g_rbh.rbh01 
      AND rai02=g_rbh.rbh02 
      AND rai03=g_rbi[l_ac1].rbi06 
      AND raiplant=g_rbh.rbhplant   
      
   #FUN-AB0033 add -----------------start-----------------  
   LET g_rbi[l_ac1].rbi06 = g_rbi[l_ac1].rbi06_1
   LET g_rbi[l_ac1].rbi07 = g_rbi[l_ac1].rbi07_1
   LET g_rbi[l_ac1].rbi08 = g_rbi[l_ac1].rbi08_1
   LET g_rbi[l_ac1].rbi13 = g_rbi[l_ac1].rbi13_1  #FUN-BC0126 add
   LET g_rbi[l_ac1].rbi10 = g_rbi[l_ac1].rbi10_1
   LET g_rbi[l_ac1].rbi11 = g_rbi[l_ac1].rbi11_1
   LET g_rbi[l_ac1].rbiacti = g_rbi[l_ac1].rbiacti_1
   
   DISPLAY BY NAME g_rbi[l_ac1].rbi06,g_rbi[l_ac1].rbi07,g_rbi[l_ac1].rbi08,g_rbi[l_ac1].rbi13,  #FUN-BC0126 add rbi13
                   g_rbi[l_ac1].rbi10,g_rbi[l_ac1].rbi11,g_rbi[l_ac1].rbiacti
   #FUN-AB0033 add ------------------end------------------   
 DISPLAY BY NAME  g_rbi[l_ac1].rbi06_1,g_rbi[l_ac1].rbi07_1,g_rbi[l_ac1].rbi08_1,g_rbi[l_ac1].rbi13_1,   #FUN-BC0126 add rbi13
     g_rbi[l_ac1].rbi10_1,g_rbi[l_ac1].rbi11_1,g_rbi[l_ac1].rbiacti_1
   DISPLAY BY NAME  g_rbi[l_ac1].type,g_rbi[l_ac1].before,g_rbi[l_ac1].after       
WHEN '3'
  LET g_rbi[l_ac1].type  ='1'
   LET g_rbi[l_ac1].before='0'
   LET g_rbi[l_ac1].after ='1'
   
   SELECT rai03,rai04,rai06,rai07,rai09,rai10,raiacti    #FUN-BC0126 add rai10
     INTO g_rbi[l_ac1].rbi06_1,g_rbi[l_ac1].rbi07_1,g_rbi[l_ac1].rbi09_1,
     g_rbi[l_ac1].rbi10_1,g_rbi[l_ac1].rbi12_1,g_rbi[l_ac1].rbi13_1,g_rbi[l_ac1].rbiacti_1  #FUN-BC0126 add rbi13
     FROM rai_file
    WHERE rai01=g_rbh.rbh01 
      AND rai02=g_rbh.rbh02 
      AND rai03=g_rbi[l_ac1].rbi06 
      AND raiplant=g_rbh.rbhplant 
 
#FUN-BC0126 add START
   LET g_rbi[l_ac1].rbi06 = g_rbi[l_ac1].rbi06_1
   LET g_rbi[l_ac1].rbi07 = g_rbi[l_ac1].rbi07_1
   LET g_rbi[l_ac1].rbi09 = g_rbi[l_ac1].rbi09_1
   LET g_rbi[l_ac1].rbi10 = g_rbi[l_ac1].rbi10_1
   LET g_rbi[l_ac1].rbi12 = g_rbi[l_ac1].rbi12_1 
   LET g_rbi[l_ac1].rbi13 = g_rbi[l_ac1].rbi13_1
   LET g_rbi[l_ac1].rbiacti = g_rbi[l_ac1].rbiacti_1

 DISPLAY BY NAME  g_rbi[l_ac1].rbi06,g_rbi[l_ac1].rbi07,g_rbi[l_ac1].rbi09,
     g_rbi[l_ac1].rbi10,g_rbi[l_ac1].rbi12,g_rbi[l_ac1].rbi13,g_rbi[l_ac1].rbiacti  
#FUN-BC0126 add END 
 
 DISPLAY BY NAME  g_rbi[l_ac1].rbi06_1,g_rbi[l_ac1].rbi07_1,g_rbi[l_ac1].rbi09_1,
     g_rbi[l_ac1].rbi10_1,g_rbi[l_ac1].rbi12_1,g_rbi[l_ac1].rbi13_1,g_rbi[l_ac1].rbiacti_1  #FUN-BC0126 add rbi13
     DISPLAY BY NAME  g_rbi[l_ac1].type,g_rbi[l_ac1].before,g_rbi[l_ac1].after
  OTHERWISE
   LET g_rbi[l_ac1].type  ='1'
   LET g_rbi[l_ac1].before='0'
   LET g_rbi[l_ac1].after ='1'
   
   SELECT rai03,rai04,rai05,rai06,rai07,rai08,rai09,rai10,raiacti    #FUN-BC0126 add rai10
     INTO g_rbi[l_ac1].rbi06_1,g_rbi[l_ac1].rbi07_1,g_rbi[l_ac1].rbi08_1,g_rbi[l_ac1].rbi09_1,  
     g_rbi[l_ac1].rbi10_1,g_rbi[l_ac1].rbi11_1,g_rbi[l_ac1].rbi12_1,g_rbi[l_ac1].rbi13_1,g_rbi[l_ac1].rbiacti_1  #FUN-BC0126 add rbi13
     FROM rai_file
    WHERE rai01=g_rbh.rbh01 
      AND rai02=g_rbh.rbh02 
      AND rai03=g_rbi[l_ac1].rbi06 
      AND raiplant=g_rbh.rbhplant  
#FUN-BC0126 add START
   LET g_rbi[l_ac1].rbi06 = g_rbi[l_ac1].rbi06_1
   LET g_rbi[l_ac1].rbi07 = g_rbi[l_ac1].rbi07_1
   LET g_rbi[l_ac1].rbi08 = g_rbi[l_ac1].rbi08_1
   LET g_rbi[l_ac1].rbi09 = g_rbi[l_ac1].rbi09_1
   LET g_rbi[l_ac1].rbi10 = g_rbi[l_ac1].rbi10_1
   LET g_rbi[l_ac1].rbi11 = g_rbi[l_ac1].rbi11_1
   LET g_rbi[l_ac1].rbi12 = g_rbi[l_ac1].rbi12_1
   LET g_rbi[l_ac1].rbi13 = g_rbi[l_ac1].rbi13_1
   LET g_rbi[l_ac1].rbiacti = g_rbi[l_ac1].rbiacti_1

   DISPLAY BY NAME  g_rbi[l_ac1].rbi06,g_rbi[l_ac1].rbi07,g_rbi[l_ac1].rbi08,g_rbi[l_ac1].rbi09,
     g_rbi[l_ac1].rbi10,g_rbi[l_ac1].rbi11,g_rbi[l_ac1].rbi12,g_rbi[l_ac1].rbi13,g_rbi[l_ac1].rbiacti  
#FUN-BC0126 add END
   DISPLAY BY NAME  g_rbi[l_ac1].rbi06_1,g_rbi[l_ac1].rbi07_1,g_rbi[l_ac1].rbi08_1,g_rbi[l_ac1].rbi09_1,
     g_rbi[l_ac1].rbi10_1,g_rbi[l_ac1].rbi11_1,g_rbi[l_ac1].rbi12_1,g_rbi[l_ac1].rbi13_1,g_rbi[l_ac1].rbiacti_1  #FUN-BC0126 add rbi13
   DISPLAY BY NAME  g_rbi[l_ac1].type,g_rbi[l_ac1].before,g_rbi[l_ac1].after
    
END CASE
END FUNCTION 

FUNCTION t404_delall() 
   SELECT COUNT(*) INTO g_cnt FROM rbi_file
    WHERE rbi02 = g_rbh.rbh02 AND rbi01 = g_rbh.rbh01
      AND rbi03 = g_rbh.rbh03
      AND rbiplant = g_rbh.rbhplant
 
   IF g_cnt = 0 THEN
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM rbh_file WHERE rbh01 = g_rbh.rbh01 AND rbh02=g_rbh.rbh02 AND rbhplant=g_rbh.rbhplant
      DELETE FROM rbq_file WHERE rbq01 = g_rbh.rbh01 AND rbq02=g_rbh.rbh02 AND rbq03=g_rbh.rbh03
                             AND rbq04='3' AND rbqplant=g_rbh.rbhplant
      CALL g_rbi.clear()
   END IF
END FUNCTION  

#同一商品同一單位在同一機構中不能在同一時間參與兩種及以上的一般促銷
#p_group :組別
#FUNCTION t404_repeat(p_group)     
#DEFINE p_group    LIKE rai_file.rai03
#DEFINE l_n        LIKE type_file.num5
#DEFINE l_rbj08    LIKE rbj_file.rbj08
#DEFINE l_rbj09    LIKE rbj_file.rbj09
#DEFINE l_rbh04    LIKE rbh_file.rbh04
#DEFINE l_rbh05    LIKE rbh_file.rbh05
#DEFINE l_rbh06    LIKE rbh_file.rbh06
#DEFINE l_rbh07    LIKE rbh_file.rbh07

#   LET l_n=0
#   LET g_errno =' '
#   SELECT COUNT(rbj07) INTO l_n FROM rbj_file
#    WHERE rbj01=g_rbh.rbh01 AND rbj02=g_rbh.rbh02
#      AND rbjplant=g_rbh.rbhplant AND rbj03=p_group
#      AND rbjacti='Y'
#   IF l_n<1 THEN RETURN END IF 
#   CALL t304sub_chk('2',g_rbh.rbhplant,g_rbh.rbh01,g_rbh.rbh02,p_group,g_rbh.rbh04,g_rbh.rbh05,g_rbh.rbh06,g_rbh.rbh07)

#END FUNCTION
#NO.FUN-A80121 ---end--                                                                           
#FUN-BC0126 add START
FUNCTION t404_b()
   DEFINE  l_ac1_t         LIKE type_file.num5,                
           l_n             LIKE type_file.num5,                
           l_cnt           LIKE type_file.num5,                
           l_lock_sw       LIKE type_file.chr1,               
           l_allow_insert  LIKE type_file.num5,    
           l_allow_delete  LIKE type_file.num5,    
           p_cmd           LIKE type_file.chr1                 
   DEFINE l_rbi04_curr     LIKE rbi_file.rbi04 
   DEFINE l_price          LIKE rac_file.rac05
   DEFINE l_discount       LIKE rac_file.rac06
   DEFINE l_date           LIKE rac_file.rac12
   DEFINE l_time1          LIKE type_file.num5
   DEFINE l_time2          LIKE type_file.num5
   DEFINE l_ac2_t          LIKE type_file.num5
   DEFINE l_ima25          LIKE ima_file.ima25
   DEFINE l_rbj04_curr     LIKE rbj_file.rbj04 
   DEFINE l_rbk            RECORD LIKE rbk_file.*
   DEFINE l_ac3_t          LIKE type_file.num5
   DEFINE l_rbk04_curr     LIKE rbk_file.rbk04
   DEFINE l_sql            STRING
   DEFINE l_flag           LIKE type_file.chr1    #FUN-D30033

    LET g_action_choice = " "
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_rbh.rbh02 IS NULL THEN
       RETURN
    END IF

    CALL t404_rbi13_text()   #FUN-C30151 add
 
    SELECT * INTO g_rbh.* FROM rbh_file
     WHERE rbh01=g_rbh.rbh01
       AND rbh02 = g_rbh.rbh02 
       AND rbh03 = g_rbh.rbh03 
       AND rbhplant = g_rbh.rbhplant
 
    IF g_rbh.rbhacti ='N' THEN
       CALL cl_err(g_rbh.rbh02,'mfg1000',0)
       RETURN
    END IF    
    IF g_rbh.rbhconf = 'Y' OR g_rbh.rbhconf = 'I' THEN
       CALL cl_err('','art-024',0)
       RETURN
    END IF

    IF g_rbh.rbh01 <> g_rbh.rbhplant THEN
       CALL cl_err('','art-977',0)
       RETURN
    END IF
   #TQC-C30030 mark START
   #IF g_rbh.rbh11t = '1' THEN
   #   CALL cl_err(g_rbh.rbh02,'art-667',0)
   #   RETURN
   #END IF
   #TQC-C30030 mark END
   #IF g_rbh.rbh10t = 2 THEN  #FUN-C30151 mark
    IF g_rbh.rbh10t = 2 AND g_rbh.rbh25t = '1' THEN  #FUN-C30151 add
       CALL cl_set_comp_visible('rbi13',FALSE)  
       CALL cl_set_comp_visible('rbi13_1',FALSE)   #FUN-C30151 add
       CALL cl_set_comp_visible('dummy27',FALSE)   #FUN-C30151 add
    ELSE
       CALL cl_set_comp_visible('rbi13',TRUE)
       CALL cl_set_comp_visible('rbi13_1',TRUE)   #FUN-C30151 add
       CALL cl_set_comp_visible('dummy27',TRUE)   #FUN-C30151 add
    END IF
    CALL cl_opmsg('b')

    LET g_forupd_sql = " SELECT b.rbi04,'','','','','','','','','','',",
                       "                   b.rbi05,b.rbi06,b.rbi07,b.rbi08,b.rbi09,b.rbi10,b.rbi11,b.rbi12,b.rbiacti ",
                       "   FROM rbi_file b ",
                       "  WHERE b.rbi01 = ?  AND b.rbi02 = ? AND b.rbi03= ? AND b.rbiplant= ? ",
                       "    AND b.rbi06 = ? ",
                       "    FOR UPDATE "                    
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t404_bcl CURSOR FROM g_forupd_sql 

    LET g_forupd_sql = " SELECT *  ",
                       "   FROM rbj_file ",
                       "  WHERE rbj01 = ? AND rbj02 = ? ",
                       "    AND rbj03=? AND rbjplant=?  AND rbj06=? AND rbj07=? ",  
                       "    FOR UPDATE   "
                       
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t4041_bcl CURSOR FROM g_forupd_sql 

    LET g_forupd_sql = "SELECT * ",
                       "  FROM rbk_file ",
                       " WHERE rbk01=? AND rbk02=? AND rbk03=? AND rbk05 = '3' ",
                       "   AND rbk06 = '1' AND rbk08 = ? AND rbkplant = ? ",
                       " FOR UPDATE  "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t4042_bcl CURSOR FROM g_forupd_sql

    LET l_ac1_t = 0
    LET l_ac2_t = 0
    LET l_ac3_t = 0

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    IF g_rec_b1 > 0 THEN LET l_ac1 = 1 END IF     #FUN-D30033 add
    IF g_rec_b2 > 0 THEN LET l_ac2 = 1 END IF     #FUN-D30033 add
    IF g_rec_b3 > 0 THEN LET l_ac3 = 1 END IF     #FUN-D30033 add 

    DIALOG ATTRIBUTES(UNBUFFERED)

       INPUT ARRAY g_rbk FROM s_rbk.*
             ATTRIBUTE(COUNT=g_rec_b3,MAXCOUNT=g_max_rec,
                       INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                       APPEND ROW=l_allow_insert)
   
          BEFORE INPUT
             IF g_rec_b3 != 0 THEN
                CALL fgl_set_arr_curr(l_ac3)
             END IF
             LET g_b_flag = '3'   #FUN-D30033 add
   
          BEFORE ROW
              LET l_ac3 = ARR_CURR()
              LET p_cmd = '' 
              LET l_lock_sw = 'N'            #DEFAULT
              LET l_n  = ARR_COUNT()
              LET l_flag = '3'               #FUN-D30033
              BEGIN WORK
   
              OPEN t404_cl USING g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,g_rbh.rbhplant 
              IF STATUS THEN
                 CALL cl_err("OPEN t404_cl:", STATUS, 1)
                 CLOSE t404_cl
                 ROLLBACK WORK
                 RETURN
              END IF
   
              FETCH t404_cl INTO g_rbh.*
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_rbh.rbh02,SQLCA.sqlcode,0)
                 CLOSE t404_cl
                 ROLLBACK WORK
                 RETURN
              END IF
   
              IF g_rec_b3 >= l_ac3 THEN
                 LET p_cmd='u'
                 LET g_rbk_t.* = g_rbk[l_ac3].*  #BACKUP
                 LET g_rbk_o.* = g_rbk[l_ac3].*  #BACKUP
                 LET l_sql = " SELECT b.rbk04,'',a.rbk06,a.rbk08,a.rbk09,a.rbk10,a.rbk11,a.rbk12,a.rbk13,a.rbk14,a.rbkacti, ",
                             "                   b.rbk06,b.rbk08,b.rbk09,b.rbk10,b.rbk11,b.rbk12,b.rbk13,b.rbk14,b.rbkacti  ",
                             " FROM rbk_file b LEFT OUTER JOIN rbk_file a ",
                             "          ON (b.rbk01=a.rbk01 AND b.rbk02=a.rbk02 AND b.rbk03=a.rbk03 AND b.rbk04=a.rbk04 ",
                             "              AND b.rbk07=a.rbk07 AND b.rbk08=a.rbk08 AND b.rbkplant=a.rbkplant AND b.rbk06<>a.rbk06 )",
                             "   WHERE b.rbk01 = '",g_rbh.rbh01,"'  AND b.rbk02 = '",g_rbh.rbh02,"' ",
                             "     AND b.rbk03 = '",g_rbh.rbh03,"' AND b.rbkplant='",g_rbh.rbhplant,"' ",
                             "     AND b.rbk08 ='",g_rbk_t.rbk08,"' ",
                             "     AND b.rbk06='1' AND b.rbk05 = '3' "
                 PREPARE sel_rbk_row FROM l_sql
                 EXECUTE sel_rbk_row INTO l_rbk04_curr,g_rbk[l_ac3].*
                 OPEN t4042_bcl USING g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,
                                      g_rbk_t.rbk08,g_rbh.rbhplant
                 IF STATUS THEN
                    CALL cl_err("OPEN t4042_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                 ELSE
                    FETCH t4042_bcl INTO l_rbk.*                    
                    IF SQLCA.sqlcode THEN
                       CALL cl_err(g_rbk_t.rbk08,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                    END IF
                 END IF
              END IF
   
           AFTER INSERT
               IF INT_FLAG THEN
                  CALL cl_err('',9001,0)
                  LET INT_FLAG = 0
                  CANCEL INSERT
               END IF
               IF cl_null(g_rbk[l_ac3].rbk14) THEN LET g_rbk[l_ac3].rbk14 = ' ' END IF 
               IF cl_null(g_rbk[l_ac3].rbk14_1) THEN LET g_rbk[l_ac3].rbk14_1 = ' ' END IF
               SELECT MAX(rbk04) INTO l_rbk04_curr FROM rbk_file
                WHERE rbk01=g_rbh.rbh01
                  AND rbk02=g_rbh.rbh02
                  AND rbk03=g_rbh.rbh03
                  AND rbk05 = 3
                  AND rbkplant=g_rbh.rbhplant
                 IF cl_null(l_rbk04_curr) OR l_rbk04_curr=0 THEN
                    LET l_rbk04_curr = 1
                 ELSE
                    LET l_rbk04_curr = l_rbk04_curr + 1
                 END IF
               IF g_rbk[l_ac3].type2= '0' THEN         
                  INSERT INTO rbk_file(rbk01,rbk02,rbk03,rbk04,rbk05,rbk06,
                                       rbk07,rbk08,rbk09,rbk10,rbk11,rbk12,
                                       rbk13,rbk14,rbkacti,rbkpos,
                                       rbklegal,rbkplant)
                  VALUES(g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,l_rbk04_curr,'3',
                         g_rbk[l_ac3].after2,0,g_rbk[l_ac3].rbk08,
                         g_rbk[l_ac3].rbk09,g_rbk[l_ac3].rbk10,g_rbk[l_ac3].rbk11,
                         g_rbk[l_ac3].rbk12,g_rbk[l_ac3].rbk13,g_rbk[l_ac3].rbk14,
                         g_rbk[l_ac3].rbkacti,'1',g_rbh.rbhlegal,g_rbh.rbhplant)
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("ins","rbd_file",g_rbh.rbh02||g_rbk[l_ac3].after2||g_rbk[l_ac3].rbk08,"",SQLCA.sqlcode,"","",1)
                     CANCEL INSERT
                  ELSE
                     MESSAGE 'INSERT O.K'
                     COMMIT WORK
                     LET g_rec_b3=g_rec_b3 + 1
                     DISPLAY g_rec_b3 TO FORMONLY.cn3
                  END IF
               ELSE                                      
                  INSERT INTO rbk_file(rbk01,rbk02,rbk03,rbk04,rbk05,rbk06,
                                       rbk07,rbk08,rbk09,rbk10,rbk11,rbk12,
                                       rbk13,rbk14,rbkacti,rbkpos,
                                       rbklegal,rbkplant)
                  VALUES(g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,l_rbk04_curr,'3',
                         g_rbk[l_ac3].after2,0,g_rbk[l_ac3].rbk08,
                         g_rbk[l_ac3].rbk09,g_rbk[l_ac3].rbk10,g_rbk[l_ac3].rbk11,
                         g_rbk[l_ac3].rbk12,g_rbk[l_ac3].rbk13,g_rbk[l_ac3].rbk14,
                         g_rbk[l_ac3].rbkacti,'1',g_rbh.rbhlegal,g_rbh.rbhplant)
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("ins","rbd_file",g_rbh.rbh02||g_rbk[l_ac3].after2||g_rbk[l_ac3].rbk08,"",SQLCA.sqlcode,"","",1)
                     CANCEL INSERT                       
                  ELSE
                     MESSAGE 'INSERT value.after O.K' 
                  END IF
                  INSERT INTO rbk_file(rbk01,rbk02,rbk03,rbk04,rbk05,rbk06,
                                       rbk07,rbk08,rbk09,rbk10,rbk11,rbk12,
                                       rbk13,rbk14,rbkacti,rbkpos,
                                       rbklegal,rbkplant)
                  VALUES(g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,l_rbk04_curr,'3',
                         g_rbk[l_ac3].before2,0,g_rbk[l_ac3].rbk08_1,
                         g_rbk[l_ac3].rbk09_1,g_rbk[l_ac3].rbk10_1,g_rbk[l_ac3].rbk11_1,
                         g_rbk[l_ac3].rbk12_1,g_rbk[l_ac3].rbk13_1,g_rbk[l_ac3].rbk14_1,
                         g_rbk[l_ac3].rbkacti_1,'1',g_rbh.rbhlegal,g_rbh.rbhplant)
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("ins","rbd_file",g_rbh.rbh02||g_rbk[l_ac3].after2||g_rbk[l_ac3].rbk08,"",SQLCA.sqlcode,"","",1)
                     CANCEL INSERT                       
                  ELSE
                     MESSAGE 'INSERT value.before O.K' 
                     COMMIT WORK
                     LET g_rec_b3=g_rec_b3 + 1
                     DISPLAY g_rec_b3 TO FORMONLY.cn3
                  END IF
               END IF
   
          BEFORE INSERT
               LET l_n = ARR_COUNT()
               LET p_cmd='a'
               INITIALIZE g_rbk[l_ac3].* TO NULL 
               LET g_rbk[l_ac3].type2 = '0'      
               LET g_rbk[l_ac3].before2 = '0'
               LET g_rbk[l_ac3].after2 = '1'  
               LET g_rbk[l_ac3].rbkacti = 'Y'
               LET g_rbk_t.* = g_rbk[l_ac3].*         
               LET g_rbk_o.* = g_rbk[l_ac3].*         
               CALL cl_show_fld_cont()
               NEXT FIELD rbk08 
   
          AFTER FIELD rbk08 
             IF NOT cl_null(g_rbk[l_ac3].rbk08) THEN
                IF p_cmd = 'a' OR
                   (p_cmd = 'u' AND g_rbk[l_ac3].rbk08 <> g_rbk_t.rbk08) THEN
                   LET l_n = 0 
                   SELECT COUNT(*) INTO l_n FROM rbk_file
                     WHERE rbk01 = g_rbh.rbh01 AND rbk02 = g_rbh.rbh02
                       AND rbk03 = g_rbh.rbh03 AND rbk05 = '3'
                       AND rbk08 = g_rbk[l_ac3].rbk08
                   IF l_n > 0 THEN
                      CALL cl_err('','-239',0)
                      NEXT FIELD rbk08
                   END IF
                   LET l_n = 0
                   SELECT COUNT(*) INTO l_n FROM rbk_file
                      WHERE rbk01 = g_rbh.rbh01 AND rbk02 = g_rbh.rbh02 
                        AND rbk03 = g_rbh.rbh03 AND rbk05 = '3' 
                        AND rbkplant = g_rbh.rbhplant AND rbk08 = g_rbk[l_ac3].rbk08
                   IF l_n > 0 THEN
                      CALL cl_err('','-239',0)
                   END IF
                   LET l_n = 0
                   SELECT COUNT(*) INTO l_n FROM rak_file
                      WHERE rak01 = g_rbh.rbh01 AND rak02 = g_rbh.rbh02
                        AND rak03 = '3' 
                        AND rak05 = g_rbk[l_ac3].rbk08 AND rakplant = g_rbh.rbhplant
                   IF l_n = 0 OR cl_null(l_n) THEN      
                      IF NOT cl_confirm('art-677') THEN  
                         NEXT FIELD rbk08
                      ELSE
                         CALL t404_b3_init()
                     END IF
                   ELSE                                    
                      IF NOT cl_confirm('art-676') THEN  
                         NEXT FIELD rbk08
                      ELSE
                         CALL t404_b3_find()   
                      END IF 
                   END IF
                END IF
             END IF
   
          AFTER FIELD rbk09
             IF NOT cl_null(g_rbk[l_ac3].rbk09) THEN
                IF NOT cl_null(g_rbk[l_ac3].rbk10) THEN
                   IF g_rbk[l_ac3].rbk09 > g_rbk[l_ac3].rbk10 THEN
                      CALL cl_err('','art-201',0)
                      NEXT FIELD rbk09
                   END IF
                END IF
             END IF
   
          AFTER FIELD rbk10
             IF NOT cl_null(g_rbk[l_ac3].rbk10) THEN
                IF NOT cl_null(g_rbk[l_ac3].rbk09) THEN
                   IF g_rbk[l_ac3].rbk09 > g_rbk[l_ac3].rbk10 THEN
                      CALL cl_err('','art-201',0)
                      NEXT FIELD rbk10
                   END IF
                END IF
             END IF
   
          AFTER FIELD rbk11
            IF NOT cl_null(g_rbk[l_ac3].rbk11) THEN
               IF p_cmd = "a" OR
                      (p_cmd = "u" AND g_rbk[l_ac3].rbk11<>g_rbk_t.rbk11) THEN
                  CALL t404_chktime(g_rbk[l_ac3].rbk11) RETURNING l_time1
                  IF NOT cl_null(g_errno) THEN
                      CALL cl_err('',g_errno,0)
                      NEXT FIELD rbk11
                  ELSE
                    IF NOT cl_null(g_rbk[l_ac3].rbk12) THEN
                       CALL t404_chktime(g_rbk[l_ac3].rbk12) RETURNING l_time2
                       IF l_time1>=l_time2 THEN
                          CALL cl_err('','art-207',0)
                          NEXT FIELD rbk11
                       END IF
                    END IF
                  END IF
                END IF
            END IF
           
          AFTER FIELD rbk12
            IF NOT cl_null(g_rbk[l_ac3].rbk12) THEN
                IF p_cmd = "a" OR
                       (p_cmd = "u" AND g_rbk[l_ac3].rbk12<>g_rbk_t.rbk12) THEN
                    CALL t404_chktime(g_rbk[l_ac3].rbk12) RETURNING l_time2
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err('',g_errno,0)
                       NEXT FIELD rbk12
                    ELSE
                       IF NOT cl_null(g_rbk[l_ac3].rbk11) THEN
                          CALL t404_chktime(g_rbk[l_ac3].rbk11) RETURNING l_time1
                          IF l_time1>=l_time2 THEN
                             CALL cl_err('','art-207',0)
                             NEXT FIELD rbk12
                          END IF
                       END IF
                    END IF
                END IF
             END IF
   
          ON CHANGE rbk13
             CALL t404_set_entry_rbk()
   
          ON CHANGE rbk14
             CALL t404_set_entry_rbk()
   
          BEFORE DELETE
             IF g_rbk_t.rbk08 > 0 AND NOT cl_null(g_rbk_t.rbk08) THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM rbk_file
                 WHERE rbk02 = g_rbh.rbh02 AND rbk01 = g_rbh.rbh01
                   AND rbk03 = g_rbh.rbh03 AND rbk04 = l_rbk04_curr
                   AND rbk05 = '3' 
                   AND rbkplant = g_rbh.rbhplant
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","rbk_file",g_rbh.rbh01,g_rbk_t.rbk08,SQLCA.sqlcode,"","",1) 
                   ROLLBACK WORK
                   CANCEL DELETE 
                END IF
                CALL t404_upd_log() 
                LET g_rec_b3=g_rec_b3-1
             END IF
   
          ON ROW CHANGE
             IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                LET g_rbk[l_ac3].* = g_rbk_t.*
                CLOSE t4042_bcl
                ROLLBACK WORK
                EXIT DIALOG 
             END IF
             IF cl_null(g_rbk[l_ac3].rbk08) THEN
                NEXT FIELD rbk08
             END IF
                
             IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_rbk[l_ac3].rbk08,-263,1)
                LET g_rbk[l_ac3].* = g_rbk_t.*
             ELSE
                UPDATE rbk_file SET 
                                    rbk08  =g_rbk[l_ac3].rbk08,
                                    rbk09  =g_rbk[l_ac3].rbk09,
                                    rbk10  =g_rbk[l_ac3].rbk10,
                                    rbk11  =g_rbk[l_ac3].rbk11,
                                    rbk12  =g_rbk[l_ac3].rbk12,
                                    rbk13  =g_rbk[l_ac3].rbk13,
                                    rbk14  =g_rbk[l_ac3].rbk14,
                                    rbkacti=g_rbk[l_ac3].rbkacti
                 WHERE rbk02 = g_rbh.rbh02 AND rbk01=g_rbh.rbh01
                   AND rbk03 = g_rbh.rbh03 AND rbk04=l_rbk04_curr AND rbk05='3'
                   AND rbk06= '1' AND rbkplant = g_rbh.rbhplant
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                   CALL cl_err3("upd","rbk_file",g_rbh.rbh01,g_rbk_t.rbk08,SQLCA.sqlcode,"","",1) 
                   LET g_rbk[l_ac3].* = g_rbk_t.*
                ELSE
                   MESSAGE 'UPDATE rbk_file O.K'
                   CALL t404_upd_log() 
                   COMMIT WORK
                END IF
             END IF
   
          AFTER ROW
             LET l_ac3 = ARR_CURR()
             LET l_ac3_t = l_ac3   
             IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                IF p_cmd = 'u' THEN
                   LET g_rbk[l_ac3].* = g_rbk_t.*
                END IF
                CLOSE t4042_bcl
                ROLLBACK WORK
                EXIT DIALOG 
             END IF  
             CLOSE t4042_bcl
             COMMIT WORK
   
       END INPUT

       INPUT ARRAY g_rbi FROM s_rbi.*
             ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,
             INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

          BEFORE INPUT
             IF g_rec_b1 != 0 THEN
                CALL fgl_set_arr_curr(l_ac1)
             END IF
             LET g_flag = 'Y'    #FUN-C60041 add
             LET g_b_flag = '1'   #FUN-D30033 add
          BEFORE ROW
              LET p_cmd = ''
              LET l_ac1 = ARR_CURR()
              LET l_lock_sw = 'N'            #DEFAULT
              LET l_n  = ARR_COUNT()
              LET l_flag = '1'      #FUN-D30033
              BEGIN WORK
   
              OPEN t404_cl USING g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,g_rbh.rbhplant
              IF STATUS THEN
                 CALL cl_err("OPEN t404_cl:", STATUS, 1)
                 CLOSE t404_cl
                 ROLLBACK WORK
                 RETURN
              END IF
              FETCH t404_cl INTO g_rbh.*           
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_rbh.rbh01||g_rbh.rbh02,SQLCA.sqlcode,0)      
                 CLOSE t404_cl
                 ROLLBACK WORK
                 RETURN
              END IF
              IF g_rec_b1>=l_ac1 THEN
                  LET p_cmd='u'
                  LET g_rbi_t.* = g_rbi[l_ac1].*  #BACKUP
                  LET g_rbi_o.* = g_rbi[l_ac1].*  #BACKUP
                 
                  OPEN t404_bcl USING g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,g_rbh.rbhplant,g_rbi_t.rbi06 
                                      
                  IF STATUS THEN
                      CALL cl_err("OPEN t404_bcl:", STATUS, 1)
                  ELSE
                    SELECT b.rbi04,'',a.rbi05,a.rbi06,a.rbi07,a.rbi08,a.rbi13,a.rbi09,a.rbi10,a.rbi11,a.rbi12,a.rbiacti, 
                                      b.rbi05,b.rbi06,b.rbi07,b.rbi08,b.rbi13,b.rbi09,b.rbi10,b.rbi11,b.rbi12,b.rbiacti   
                        INTO l_rbi04_curr,g_rbi[l_ac1].*
                        FROM rbi_file b LEFT OUTER JOIN rbi_file a
                          ON (b.rbi01=a.rbi01 AND b.rbi02=a.rbi02 AND b.rbi03=a.rbi03 
                         AND  b.rbi04=a.rbi04 AND b.rbi06=a.rbi06 AND b.rbiplant=a.rbiplant 
                         AND b.rbi05<>a.rbi05 )
                       WHERE b.rbi01 =g_rbh.rbh01  AND b.rbi02 =g_rbh.rbh02 AND b.rbi03=g_rbh.rbh03
                         AND b.rbiplant=g_rbh.rbhplant
                         AND b.rbi06 = g_rbi_t.rbi06 
                         AND b.rbi05='1' 
                      IF SQLCA.sqlcode THEN
                          CALL cl_err(g_rbi_t.type||g_rbi_t.rbi06,SQLCA.sqlcode,1)
                          LET l_lock_sw = "Y"
                      END IF
                      IF g_rbi[l_ac1].before='0' THEN
                         LET g_rbi[l_ac1].type ='1'
                      ELSE
                         LET g_rbi[l_ac1].type ='0'
                      END IF                  
                  END IF
                  CALL cl_show_fld_cont()      
              END IF 
              CALL t404_rbi_entry(g_rbh.rbh10t)

    
          BEFORE INSERT
              DISPLAY "BEFORE INSERT!"
              LET l_n = ARR_COUNT()
              LET p_cmd='a'
              INITIALIZE g_rbi[l_ac1].* TO NULL 
              LET g_rbi[l_ac1].type = '0'      
              LET g_rbi[l_ac1].before = '0'
              LET g_rbi[l_ac1].after  = '1'
              LET g_rbi_t.* = g_rbi[l_ac1].*         #新輸入資料
              LET g_rbi_o.* = g_rbi[l_ac1].*
              IF p_cmd='u' THEN    #組別不可輸入
                 CALL cl_set_comp_entry("rbi06",FALSE)
              ELSE
                 CALL cl_set_comp_entry("rbi06",TRUE)
              END IF   
              SELECT MAX(rbi04)+1 INTO l_rbi04_curr 
                FROM rbi_file
               WHERE rbi01=g_rbh.rbh01
                 AND rbi02=g_rbh.rbh02 
                 AND rbi03=g_rbh.rbh03 
                 AND rbiplant=g_rbh.rbhplant
              IF l_rbi04_curr IS NULL OR l_rbi04_curr=0 THEN
                 LET l_rbi04_curr = 1
              END IF
              CALL cl_show_fld_cont()
              NEXT FIELD rbi06 

          AFTER INSERT
              IF INT_FLAG THEN
                 CALL cl_err('',9001,0)
                 LET INT_FLAG = 0
                 CANCEL INSERT
              END IF    
              IF cl_null(g_rbi[l_ac1].rbi13) THEN LET g_rbi[l_ac1].rbi13 = 0  END IF  
              IF cl_null(g_rbi[l_ac1].rbi09) THEN LET g_rbi[l_ac1].rbi09 = 0  END IF
              IF cl_null(g_rbi[l_ac1].rbi12) THEN LET g_rbi[l_ac1].rbi12 = 0  END IF
              IF g_rbi[l_ac1].type= '0' THEN
                 INSERT INTO rbi_file(rbi01,rbi02,rbi03,rbi04,rbi05,rbi06,rbi07,
                                      rbi08,rbi09,rbi10,rbi11,rbi12,rbi13,rbiacti,rbiplant,rbilegal)
                 VALUES(g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,l_rbi04_curr,g_rbi[l_ac1].after,
                        g_rbi[l_ac1].rbi06,g_rbi[l_ac1].rbi07,g_rbi[l_ac1].rbi08,g_rbi[l_ac1].rbi09,
                        g_rbi[l_ac1].rbi10,g_rbi[l_ac1].rbi11,g_rbi[l_ac1].rbi12,g_rbi[l_ac1].rbi13,
                        g_rbi[l_ac1].rbiacti,g_rbh.rbhplant,g_rbh.rbhlegal) 
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                    CALL cl_err3("ins","rbi_file",g_rbh.rbh02||g_rbi[l_ac1].after||g_rbi[l_ac1].rbi06,"",SQLCA.sqlcode,"","",1)
                    CANCEL INSERT
                 ELSE
                    MESSAGE 'INSERT O.K'
                    COMMIT WORK
                    LET g_rec_b1=g_rec_b1+1
                    DISPLAY g_rec_b1 TO FORMONLY.cn1
                 END IF
             
              ELSE
               IF cl_null(g_rbi[l_ac1].rbi09) THEN LET g_rbi[l_ac1].rbi09 = 0  END IF
               IF cl_null(g_rbi[l_ac1].rbi12) THEN LET g_rbi[l_ac1].rbi12 = 0  END IF
                 INSERT INTO rbi_file(rbi01,rbi02,rbi03,rbi04,rbi05,rbi06,rbi07,
                                      rbi08,rbi09,rbi10,rbi11,rbi12,rbi13,rbiacti,rbiplant,rbilegal)                                    
                 VALUES(g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,l_rbi04_curr,g_rbi[l_ac1].after,
                        g_rbi[l_ac1].rbi06,g_rbi[l_ac1].rbi07,g_rbi[l_ac1].rbi08,g_rbi[l_ac1].rbi09,
                        g_rbi[l_ac1].rbi10,g_rbi[l_ac1].rbi11,g_rbi[l_ac1].rbi12,g_rbi[l_ac1].rbi13,
                        g_rbi[l_ac1].rbiacti,g_rbh.rbhplant,g_rbh.rbhlegal)
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                    CALL cl_err3("ins","rbi_file",g_rbh.rbh02||g_rbi[l_ac1].after||g_rbi[l_ac1].rbi06,"",SQLCA.sqlcode,"","",1)
                    CANCEL INSERT 
                 ELSE
                    MESSAGE 'INSERT value.after O.K' 
                 END IF
               IF cl_null(g_rbi[l_ac1].rbi09_1) THEN LET g_rbi[l_ac1].rbi09_1 = 0  END IF
               IF cl_null(g_rbi[l_ac1].rbi12_1) THEN LET g_rbi[l_ac1].rbi12_1 = 0  END IF
                 INSERT INTO rbi_file(rbi01,rbi02,rbi03,rbi04,rbi05,rbi06,rbi07,
                                      rbi08,rbi09,rbi10,rbi11,rbi12,rbi13,rbiacti,rbiplant,rbilegal)                                    
                 VALUES(g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,l_rbi04_curr,g_rbi[l_ac1].before,
                        g_rbi[l_ac1].rbi06_1,g_rbi[l_ac1].rbi07_1,g_rbi[l_ac1].rbi08_1,g_rbi[l_ac1].rbi09_1,
                        g_rbi[l_ac1].rbi10_1,g_rbi[l_ac1].rbi11_1,g_rbi[l_ac1].rbi12_1,g_rbi[l_ac1].rbi13_1,
                        g_rbi[l_ac1].rbiacti_1,g_rbh.rbhplant,g_rbh.rbhlegal)
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                    CALL cl_err3("ins","rbi_file",g_rbh.rbh02||g_rbi[l_ac1].before||g_rbi[l_ac1].rbi06,"",SQLCA.sqlcode,"","",1)
                    CANCEL INSERT
                 ELSE
                    MESSAGE 'INSERT value.before O.K'
                    COMMIT WORK
                    LET g_rec_b1=g_rec_b1+1
                    DISPLAY g_rec_b1 TO FORMONLY.cn1
                 END IF
              END IF

          AFTER FIELD rbi06
              IF NOT cl_null(g_rbi[l_ac1].rbi06) THEN
                 IF (g_rbi[l_ac1].rbi06 <> g_rbi_t.rbi06
                    OR cl_null(g_rbi_t.rbi06)) THEN 
                    LET l_n = 0 
                    SELECT COUNT(*) INTO l_n FROM rbi_file
                      WHERE rbi01 = g_rbh.rbh01 AND rbi02 = g_rbh.rbh02
                        AND rbi03 = g_rbh.rbh03 AND rbiplant = g_rbh.rbhplant
                        AND rbi06 = g_rbi[l_ac1].rbi06 
                    IF l_n > 0 THEN 
                       CALL cl_err('','-239',0)
                       NEXT FIELD rbi06
                    END IF  
                    SELECT COUNT(*) INTO l_n 
                      FROM rai_file
                     WHERE rai01=g_rbh.rbh01 AND rai02=g_rbh.rbh02
                       AND raiplant=g_rbh.rbhplant AND rai03=g_rbi[l_ac1].rbi06
                    IF l_n=0 THEN
                       IF NOT cl_confirm('art-677') THEN  
                          NEXT FIELD rbi06
                       ELSE
                          CALL t404_b1_init()
                       END IF
                    ELSE
                       IF NOT cl_confirm('art-676') THEN  
                          NEXT FIELD rbi06
                       ELSE
                          CALL t404_b1_find()   
                       END IF           
                    END IF
                 END IF       
              END IF
          AFTER FIELD rbi07
              IF NOT cl_null(g_rbi[l_ac1].rbi07) THEN
                 IF g_rbi_o.rbi07 IS NULL OR
                    (g_rbi[l_ac1].rbi07 != g_rbi_o.rbi07 ) THEN
                    IF g_rbi[l_ac1].rbi07 <= 0 THEN
                       CALL cl_err(g_rbi[l_ac1].rbi07,'aec-020',0)
                       LET g_rbi[l_ac1].rbi07= g_rbi_o.rbi07
                       NEXT FIELD rbi07
                    END IF
                 END IF
              END IF

          ON CHANGE rbi10
              IF NOT cl_null(g_rbi[l_ac1].rbi10) THEN
                 CALL t404_rbi_entry(g_rbh.rbh10t)
                 IF (g_rbi[l_ac1].rbi10 <> g_rbi[l_ac1].rbi10_1 AND g_rbi[l_ac1].rbi10_1 <> '0') THEN
                     LET l_n = 0
                     SELECT COUNT(*) INTO l_n FROM rap_file
                       WHERE rap01 = g_rbh.rbh01 AND rap02 = g_rbh.rbh02
                         AND rap03 = '3' AND rap09 = g_rbi[l_ac1].rbi10_1
                         AND rapplant = g_rbh.rbhplant
                      IF l_n > 0 THEN
                         IF NOT cl_confirm('art-789') THEN
                           LET g_rbi[l_ac1].rbi10 = g_rbi[l_ac1].rbi10_1
                           NEXT FIELD rbi10
                         ELSE
                           CALL t404_rbp()
                         END IF
                      END IF
                 ELSE
                    CALL t404_delrbp()
                 END IF
              END IF   

          AFTER FIELD rbi10
              IF g_rbi[l_ac1].rbi10 <> '0' THEN
                 LET g_rbi[l_ac1].rbi11 = ''
                 LET g_rbi[l_ac1].rbi12 = 0
                 DISPLAY BY NAME g_rbi[l_ac1].rbi11,g_rbi[l_ac1].rbi12
              ELSE 
                 IF g_rbh.rbh10t = '3' AND (g_rbi[l_ac1].rbi12 <= 0 ) THEN   
                   CALL cl_err('','art-180',0)
                   NEXT FIELD rbi12
                 END IF
                 IF g_rbh.rbh10t = '2' AND g_rbi[l_ac1].rbi11 IS NULL THEN
                   NEXT FIELD rbi11
                 END IF
              END IF 

          BEFORE FIELD rbi08,rbi09,rbi11,rbi12
             IF NOT cl_null(g_rbi[l_ac1].rbi07) THEN
                CALL t404_rbi_entry(g_rbh.rbh10t)
             END IF

          AFTER FIELD rbi08,rbi11   
              LET l_discount = FGL_DIALOG_GETBUFFER()
              IF l_discount < 0 OR l_discount > 100 THEN
                 CALL cl_err('','atm-384',0)
                 NEXT FIELD CURRENT
              ELSE
                 DISPLAY BY NAME g_rbi[l_ac1].rbi08,g_rbi[l_ac1].rbi11
              END IF
   
          AFTER FIELD rbi09,rbi12   
             LET l_price = FGL_DIALOG_GETBUFFER()
             IF l_price <= 0 THEN
                CALL cl_err('','art-653',0)
                NEXT FIELD CURRENT
             ELSE
                DISPLAY BY NAME g_rbi[l_ac1].rbi09,g_rbi[l_ac1].rbi12               
             END IF

          #TQC-C20002 add START
          AFTER FIELD rbi13 
             IF NOT cl_null(g_rbi[l_ac1].rbi13) THEN
                IF g_rbh.rbh10t = '3' OR g_rbh.rbh10t = '4' THEN
                   IF g_rbi[l_ac1].rbi13 < 0 THEN   
                      CALL cl_err('','art-784',0)
                      NEXT FIELD rbi13
                   END IF                   
                   IF g_rbi[l_ac1].rbi13 = 0 THEN  #當折讓基數為0時顯示訊息提示user
                      IF g_rbh.rbh25t = '1' THEN
                         CALL cl_msgany(p_row,p_col,'art-879')
                      ELSE
                         CALL cl_msgany(p_row,p_col,'art-881')
                      END IF
                   END IF
                   IF g_rbi[l_ac1].rbi13 > g_rbi[l_ac1].rbi07 THEN  #折讓基數不可大於滿額金額或滿量數量
                      CALL cl_err('','art-880',0)
                      NEXT FIELD rbi13
                   END IF
                END IF  
             END IF
          #TQC-C20002 add END

          BEFORE DELETE
              DISPLAY "BEFORE DELETE"
              IF g_rbi_t.rbi06 > 0 AND g_rbi_t.rbi06 IS NOT NULL THEN
                 IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
                 END IF
                 SELECT COUNT(*) INTO l_n FROM rbj_file
                  WHERE rbj01=g_rbh.rbh01 AND rbj02=g_rbh.rbh02
                    AND rbj03=g_rbh.rbh03 AND rbjplant=g_rbh.rbhplant
                    AND rbj06=g_rbi_t.rbi06
                 IF l_n>0 THEN
                    CALL cl_err(g_rbi_t.rbi06,'art-664',0)
                    CANCEL DELETE
                 ELSE 
                    SELECT COUNT(*) INTO l_n FROM rbp_file
                     WHERE rbp01=g_rbh.rbh01 AND rap02=g_rbh.rbh02 AND rap04='2'
                       AND rbp03=g_rbh.rbh03 AND rapplant=g_rbh.rbhplant
                       AND rbp07=g_rbi_t.rbi06
                    IF l_n>0 THEN
                       CALL cl_err(g_rbi_t.rbi06,'art-665',0)
                       CANCEL DELETE 
                    END IF
                 END IF
                
                 IF l_lock_sw = "Y" THEN
                    CALL cl_err("", -263, 1)
                    CANCEL DELETE
                 END IF
                 DELETE FROM rbi_file
                  WHERE rbi02 = g_rbh.rbh02 AND rbi01 = g_rbh.rbh01
                    AND rbi03 = g_rbh.rbh03 AND rbi04 = l_rbi04_curr                  
                    AND rbiplant = g_rbh.rbhplant
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","rbi_file",g_rbh.rbh01,g_rbi_t.rbi06,SQLCA.sqlcode,"","",1) 
                    ROLLBACK WORK
                    CANCEL DELETE 
                 END IF
                #TQC-C20328 add START 
                 LET l_n = 0  #當使用者選擇刪除,也必須把rbp_file的相關資料刪除
                 SELECT COUNT(*) INTO l_n FROM rbp_file
                  WHERE rbp01 = g_rbh.rbh01 AND rbp02 = g_rbh.rbh02
                    AND rbp03 = g_rbh.rbh03 AND rbp04 = '3'
                    AND rbp07 = g_rbi[l_ac1].rbi06
                   #AND rbp12 = g_rbi[l_ac1].rbi10
                 IF l_n > 0 THEN
                    DELETE FROM rbp_file
                     WHERE rbp01 = g_rbh.rbh01 AND rbp02 = g_rbh.rbh02
                       AND rbp03 = g_rbh.rbh03 AND rbp04 = '3'
                       AND rbp07 = g_rbi[l_ac1].rbi06
                 END IF
                #TQC-C20328 add END
                 CALL t404_upd_log() 
                 LET g_rec_b1=g_rec_b1-1
              END IF
              COMMIT WORK

          ON ROW CHANGE
              IF INT_FLAG THEN
                 CALL cl_err('',9001,0)
                 LET INT_FLAG = 0
                 LET g_rbi[l_ac1].* = g_rbi_t.*
                 CLOSE t404_bcl
                 ROLLBACK WORK
                 EXIT DIALOG 
              END IF
              IF cl_null(g_rbi[l_ac1].rbi07) THEN
                 NEXT FIELD rbi07
              END IF
                
              IF l_lock_sw = 'Y' THEN
                 CALL cl_err(g_rbi[l_ac1].rbi06,-263,1)
                 LET g_rbi[l_ac1].* = g_rbi_t.*
              ELSE
                 UPDATE rbi_file SET rbi06  =g_rbi[l_ac1].rbi06,
                                     rbi07  =g_rbi[l_ac1].rbi07,
                                     rbi08  =g_rbi[l_ac1].rbi08,
                                     rbi09  =g_rbi[l_ac1].rbi09,
                                     rbi10  =g_rbi[l_ac1].rbi10,
                                     rbi11  =g_rbi[l_ac1].rbi11,
                                     rbi12  =g_rbi[l_ac1].rbi12,
                                     rbi13  =g_rbi[l_ac1].rbi13,  #FUN-BC0126 add
                                     rbiacti=g_rbi[l_ac1].rbiacti
                  WHERE rbi02 = g_rbh.rbh02 AND rbi01=g_rbh.rbh01
                    AND rbi03 = g_rbh.rbh03 AND rbi06=g_rbi_t.rbi06 
                    AND rbiplant = g_rbh.rbhplant
                    AND rbi05 = '1'
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                    CALL cl_err3("upd","rbi_file",g_rbh.rbh01,g_rbi_t.rbi06,SQLCA.sqlcode,"","",1) 
                    LET g_rbi[l_ac1].* = g_rbi_t.*
                 ELSE                 
                    CALL t404_delrbp()  #TQC-C20378 add
                    MESSAGE 'UPDATE rbi_file O.K'
                    CALL t404_upd_log() 
                    COMMIT WORK
                 END IF
              END IF

          AFTER ROW
              DISPLAY  "AFTER ROW!!"
              LET l_ac1 = ARR_CURR()
              LET l_ac1_t = l_ac1    
              IF INT_FLAG THEN
                 CALL cl_err('',9001,0)
                 LET INT_FLAG = 0
                 IF p_cmd = 'u' THEN
                    LET g_rbi[l_ac1].* = g_rbi_t.*
                 END IF
                 CLOSE t404_bcl
                 ROLLBACK WORK
                 EXIT DIALOG 
              END IF
              CLOSE t404_bcl
              COMMIT WORK
          AFTER INPUT
              LET g_flag = 'N'              #FUN-C60041 add
       END INPUT 

       INPUT ARRAY g_rbj FROM s_rbj.*
          ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)

           BEFORE INPUT
              DISPLAY "BEFORE INPUT!"
              IF g_rec_b2 != 0 THEN
                 CALL fgl_set_arr_curr(l_ac2)
              END IF
              LET g_b_flag = '2'   #FUN-D30033 add
             #TQC-C30030 add START
              IF g_rbh.rbh11t = '1' THEN
                 CALL cl_err(g_rbh.rbh02,'art-667',0)
                 RETURN  
              END IF
             #TQC-C30030 add END
    
           BEFORE ROW
              DISPLAY "BEFORE ROW!"
              LET p_cmd = ''
              LET l_ac2 = ARR_CURR()
              LET l_lock_sw = 'N'            #DEFAULT
              LET l_flag = '2'               #FUN-D30033
              LET l_n  = ARR_COUNT()

              BEGIN WORK 
              OPEN t404_cl USING g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,g_rbh.rbhplant
              IF STATUS THEN
                 CALL cl_err("OPEN t404_cl:", STATUS, 1)
                 CLOSE t404_cl
                 ROLLBACK WORK
                 RETURN
              END IF 
              FETCH t404_cl INTO g_rbh.*
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_rbh.rbh02,SQLCA.sqlcode,0)
                 CLOSE t404_cl
                 ROLLBACK WORK
                 RETURN
              END IF
    
              IF g_rec_b2 >= l_ac2 THEN
                 LET p_cmd='u'
                 LET g_rbj_t.* = g_rbj[l_ac2].*  #BACKUP
                 LET g_rbj_o.* = g_rbj[l_ac2].*  #BACKUP
                 CALL t404_rbj07()   
                 OPEN t4041_bcl USING g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,g_rbh.rbhplant,
                                      g_rbj_t.rbj06,g_rbj_t.rbj07
                 IF STATUS THEN
                    CALL cl_err("OPEN t4041_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                 ELSE
                   SELECT b.rbj04,'',a.rbj05,a.rbj06,a.rbj07,a.rbj08,'',a.rbj09,'',a.rbjacti,
                           b.rbj05,b.rbj06,b.rbj07,b.rbj08,'',b.rbj09,'',b.rbjacti
                      INTO l_rbj04_curr,g_rbj[l_ac2].*
                      FROM rbj_file b LEFT OUTER JOIN rbj_file a
                        ON (b.rbj01=a.rbj01 AND b.rbj02=a.rbj02 AND b.rbj03=a.rbj03 AND b.rbj04=a.rbj04 
                       AND b.rbj06=a.rbj06 AND b.rbj07=a.rbj07 AND b.rbjplant=a.rbjplant AND b.rbj05<>a.rbj05 )
                     WHERE b.rbj01 =g_rbh.rbh01 AND b.rbj02 =g_rbh.rbh02 
                       AND b.rbj03=g_rbh.rbh03 AND b.rbjplant=g_rbh.rbhplant  AND b.rbj06=g_rbj_t.rbj06
                       AND b.rbj07=g_rbj_t.rbj07   AND b.rbj05='1' 
                       AND b.rbj08=g_rbj_t.rbj08   AND b.rbj09=g_rbj_t.rbj09  
   
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_rbj_t.rbj06,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                    END IF
                    CALL t404_rbj08('d',l_ac2)
                    CALL t404_rbj09('d')
                 END IF
              END IF

           BEFORE INSERT
               LET l_n = ARR_COUNT()
               LET p_cmd='a'
               INITIALIZE g_rbj[l_ac2].* TO NULL 
               LET g_rbj[l_ac2].type1 = '0'      
               LET g_rbj[l_ac2].before1 = '0'
               LET g_rbj[l_ac2].after1  = '1'  
               LET g_rbj[l_ac2].rbjacti = 'Y' 
               SELECT MIN(rbi06) INTO g_rbj[l_ac2].rbj06 FROM rbi_file
                WHERE rbi01=g_rbh.rbh01 
                  AND rbi02=g_rbh.rbh02 
                  AND rbi03=g_rbh.rbh03 
                  AND rbiplant=g_rbh.rbhplant
                 
               LET g_rbj_t.* = g_rbj[l_ac2].*         #新輸入資料
               LET g_rbj_o.* = g_rbj[l_ac2].*         #新輸入資料
               
               SELECT MAX(rbj04)+1 INTO l_rbj04_curr 
                 FROM rbj_file
                WHERE rbj01=g_rbh.rbh01
                  AND rbj02=g_rbh.rbh02 
                  AND rbj03=g_rbh.rbh03 
                  AND rbjplant=g_rbh.rbhplant
                 IF l_rbj04_curr IS NULL OR l_rbj04_curr=0 THEN
                    LET l_rbj04_curr = 1
                 END IF
               IF cl_null(g_rbj[l_ac2].rbj09) THEN
                 LET g_rbj[l_ac2].rbj09 = ' '
               END IF  
               CALL cl_show_fld_cont()
               NEXT FIELD rbj06 

           AFTER INSERT
              IF INT_FLAG THEN
                 CALL cl_err('',9001,0)
                 LET INT_FLAG = 0
                 CANCEL INSERT
              END IF
              IF cl_null(g_rbj[l_ac2].rbj09) THEN
                 LET g_rbj[l_ac2].rbj09=' '
              END IF
              IF cl_null(g_rbj[l_ac2].rbj09_1) THEN
                 LET g_rbj[l_ac2].rbj09_1=' '
              END IF
              SELECT COUNT(*) INTO l_n FROM rbj_file
               WHERE rbj01=g_rbh.rbh01 AND rbj02=g_rbh.rbh02
                 AND rbj03=g_rbh.rbh03 AND rbjplant=g_rbh.rbhplant
                 AND rbj06=g_rbj[l_ac2].rbj06 
                 AND rbj07=g_rbj[l_ac2].rbj07 
                 AND rbj08=g_rbj[l_ac2].rbj08 
                 AND rbj09=g_rbj[l_ac2].rbj09
              IF l_n>0 THEN 
                 CALL cl_err('',-239,0)
                 #LET g_rbj[l_ac2].* = g_rbj_t.*
                 NEXT FIELD rbj06
              END IF   
              IF g_rbj[l_ac2].type1= '0' THEN
                 INSERT INTO rbj_file(rbj01,rbj02,rbj03,rbj04,rbj05,
                                      rbj06,rbj07,rbj08,rbj09, 
                                      rbjacti,rbjplant,rbjlegal)
                 VALUES(g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,l_rbj04_curr,g_rbj[l_ac2].after1,
                        g_rbj[l_ac2].rbj06,g_rbj[l_ac2].rbj07,g_rbj[l_ac2].rbj08,g_rbj[l_ac2].rbj09, 
                        g_rbj[l_ac2].rbjacti,g_rbh.rbhplant,g_rbh.rbhlegal) 
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                    CALL cl_err3("ins","rbj_file",g_rbh.rbh02||g_rbj[l_ac2].after1||g_rbj[l_ac2].rbj06,"",SQLCA.sqlcode,"","",1)
                    CANCEL INSERT
                 ELSE
                    CALL s_showmsg_init()
                    LET g_errno=' '
                    #CALL t404_repeat(g_rbj[l_ac2].rbj06)  #check
                    CALL s_showmsg()
                    IF NOT cl_null(g_errno) THEN
                       LET g_rbj[l_ac2].* = g_rbj_t.*
                       ROLLBACK WORK
                       NEXT FIELD PREVIOUS
                    ELSE
                       #MESSAGE 'UPDATE O.K'
                       COMMIT WORK
                       LET g_rec_b2=g_rec_b2+1
                       DISPLAY g_rec_b2 TO FORMONLY.cn2
                    END IF                  
                 END IF             
              ELSE
                 INSERT INTO rbj_file(rbj01,rbj02,rbj03,rbj04,rbj05,
                                      rbj06,rbj07,rbj08,rbj09, 
                                      rbjacti,rbjplant,rbjlegal)
                 VALUES(g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,l_rbj04_curr,g_rbj[l_ac2].after1,
                        g_rbj[l_ac2].rbj06,g_rbj[l_ac2].rbj07,g_rbj[l_ac2].rbj08,g_rbj[l_ac2].rbj09, 
                        g_rbj[l_ac2].rbjacti,g_rbh.rbhplant,g_rbh.rbhlegal) 
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                    CALL cl_err3("ins","rbj_file",g_rbh.rbh02||g_rbj[l_ac2].after1||g_rbj[l_ac2].rbj06,"",SQLCA.sqlcode,"","",1)
                    CANCEL INSERT 
                 END IF
                 INSERT INTO rbj_file(rbj01,rbj02,rbj03,rbj04,rbj05,
                                      rbj06,rbj07,rbj08,rbj09, 
                                      rbjacti,rbjplant,rbjlegal)
                 VALUES(g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,l_rbj04_curr,g_rbj[l_ac2].before1,
                        g_rbj[l_ac2].rbj06_1,g_rbj[l_ac2].rbj07_1,g_rbj[l_ac2].rbj08_1,g_rbj[l_ac2].rbj09_1, 
                        g_rbj[l_ac2].rbjacti_1,g_rbh.rbhplant,g_rbh.rbhlegal) 
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                    CALL cl_err3("ins","rbj_file",g_rbh.rbh02||g_rbj[l_ac2].before1||g_rbj[l_ac2].rbj06_1,"",SQLCA.sqlcode,"","",1)
                    CANCEL INSERT               
                 ELSE
                    CALL s_showmsg_init()
                    LET g_errno=' '
                    CALL s_showmsg()
                    IF NOT cl_null(g_errno) THEN
                       LET g_rbj[l_ac2].* = g_rbj_t.*
                       ROLLBACK WORK
                       NEXT FIELD PREVIOUS
                    ELSE
                       #MESSAGE 'INSERT value.before O.K'
                       COMMIT WORK
                       LET g_rec_b2=g_rec_b2+1
                       DISPLAY g_rec_b2 TO FORMONLY.cn2
                    END IF                   
                 END IF
              END IF 

           AFTER FIELD rbj06
#FUN-C60041 -----------------STA
              IF NOT cl_null(g_rbj[l_ac2].rbj06) AND NOT cl_null(g_rbj[l_ac2].rbj07) THEN
                 SELECT COUNT(*) INTO l_n FROM rbj_file WHERE rbj06 = g_rbj[l_ac2].rbj06 AND rbj07 = g_rbj[l_ac2].rbj07
                                                          AND rbj05 = '1'
                                                          AND rbj01 = g_rbh.rbh01 AND rbj02 = g_rbh.rbh02 AND rbj03 = g_rbh.rbh03
                 IF (l_n >0 AND p_cmd='a') OR (l_n >1 AND p_cmd='u')THEN
                    CALL cl_err('','art-896',0)
                    NEXT FIELD rbj06
                 END IF
              END IF
#FUN-C60041 -----------------END
              IF NOT cl_null(g_rbj[l_ac2].rbj06) THEN
                 IF g_rbj_o.rbj06 IS NULL OR
                    (g_rbj[l_ac2].rbj06 != g_rbj_o.rbj06 ) THEN
                    CALL t404_rbj06()    #檢查其有效性          
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_rbj[l_ac2].rbj06,g_errno,0)
                       LET g_rbj[l_ac2].rbj06 = g_rbj_o.rbj06
                       NEXT FIELD rbj06
                    END IF 
                    IF NOT cl_null(g_rbj[l_ac2].rbj07) THEN
                       LET l_n = 0
                       SELECT COUNT(*) INTO l_n FROM rbj_file
                         WHERE rbj01 = g_rbh.rbh01 AND rbj02 = g_rbh.rbh02
                           AND rbj03 = g_rbh.rbh03 AND rbjplant = g_rbh.rbhplant
                           AND rbj06 = g_rbj[l_ac2].rbj06 
                           AND rbj07 = g_rbj[l_ac2].rbj07
                       IF l_n > 0 THEN
                          CALL cl_err('','-239',0)
                          NEXT FIELD rbj06
                       END IF
                       LET l_n = 0 
                       SELECT COUNT(*) INTO l_n 
                        FROM rbj_file
                       WHERE rbj01=g_rbh.rbh01 AND rbj02=g_rbh.rbh02
                         AND rbjplant=g_rbh.rbhplant 
                         AND rbj06=g_rbj[l_ac2].rbj06
                         AND rbj07=g_rbj[l_ac2].rbj07
                         AND rbj03=g_rbh.rbh03   #TQC-C20328 add
                       IF l_n=0 THEN
                          IF NOT cl_confirm('art-678') THEN
                             NEXT FIELD rbj06
                          ELSE
                             CALL t404_b2_init()
                          END IF
                       ELSE
                          IF NOT cl_confirm('art-679') THEN
                             NEXT FIELD rbj06
                          ELSE
                             CALL t404_b2_find()   
                          END IF           
                       END IF
                    END IF  
                 END IF  
              END IF

           AFTER FIELD rbj07
#FUN-C60041 -----------------STA
              IF NOT cl_null(g_rbj[l_ac2].rbj06) AND NOT cl_null(g_rbj[l_ac2].rbj07) THEN
                 SELECT COUNT(*) INTO l_n FROM rbj_file WHERE rbj06 = g_rbj[l_ac2].rbj06 AND rbj07 = g_rbj[l_ac2].rbj07
                                                          AND rbj05 = '1'
                                                          AND rbj01 = g_rbh.rbh01 AND rbj02 = g_rbh.rbh02 AND rbj03 = g_rbh.rbh03
                 IF (l_n >0 AND p_cmd='a') OR (l_n >1 AND p_cmd='u')THEN
                    CALL cl_err('','art-896',0)
                    NEXT FIELD rbj07
                 END IF
              END IF
#FUN-C60041 -----------------END
              IF NOT cl_null(g_rbj[l_ac2].rbj07) THEN
                 IF g_rbj_o.rbj07 IS NULL OR
                    (g_rbj[l_ac2].rbj07 != g_rbj_o.rbj07 ) THEN
                    IF NOT cl_null(g_rbj[l_ac2].rbj06) THEN
                       LET l_n = 0
                       SELECT COUNT(*) INTO l_n FROM rbj_file
                         WHERE rbj01 = g_rbh.rbh01 AND rbj02 = g_rbh.rbh02
                           AND rbj03 = g_rbh.rbh03 AND rbjplant = g_rbh.rbhplant
                           AND rbj06 = g_rbj[l_ac2].rbj06
                           AND rbj07 = g_rbj[l_ac2].rbj07
                       IF l_n > 0 THEN
                          CALL cl_err('','-239',0)
                          NEXT FIELD rbj07
                       END IF
                       LET l_n = 0
                       SELECT COUNT(*) INTO l_n 
                        FROM raj_file
                       WHERE raj01=g_rbh.rbh01 AND raj02=g_rbh.rbh02
                         AND rajplant=g_rbh.rbhplant 
                         AND raj03=g_rbj[l_ac2].rbj06
                         AND raj04=g_rbj[l_ac2].rbj07
                       IF l_n=0 THEN
                          IF NOT cl_confirm('art-678') THEN    #確定新增?
                             NEXT FIELD rbj07
                          ELSE
                             CALL t404_b2_init()
                          END IF
                       ELSE
                          IF NOT cl_confirm('art-679') THEN    #確定修改?
                             NEXT FIELD rbj07
                          ELSE
                             CALL t404_b2_find()   
                          END IF           
                       END IF
                    END IF  
                    CALL t404_rbj07() 
                 END IF  
              END IF

           ON CHANGE rbj07
              IF NOT cl_null(g_rbj[l_ac2].rbj07) THEN
                 CALL t404_rbj07()   
                 LET g_rbj[l_ac2].rbj08=NULL
                 LET g_rbj[l_ac2].rbj08_desc=NULL
                 LET g_rbj[l_ac2].rbj09=NULL
                 LET g_rbj[l_ac2].rbj09_desc=NULL
     
                 DISPLAY BY NAME g_rbj[l_ac2].rbj08,g_rbj[l_ac2].rbj08_desc
                 DISPLAY BY NAME g_rbj[l_ac2].rbj09,g_rbj[l_ac2].rbj09_desc
              END IF
     
           BEFORE FIELD rbj08,rbj09
              IF NOT cl_null(g_rbj[l_ac2].rbj07) THEN
                 CALL t404_rbj07()            
              END IF

           AFTER FIELD rbj08
              IF NOT cl_null(g_rbj[l_ac2].rbj08) THEN
                 IF g_rbj[l_ac2].rbj07="01" THEN
                    IF NOT s_chk_item_no(g_rbj[l_ac2].rbj08,'') THEN
                       CALL cl_err('',g_errno,1)
                       LET g_rbj[l_ac2].rbj08 = g_rbj_o.rbj08
                       NEXT FIELD rbj08
                    END IF
                 END IF
                 IF g_rbj_o.rbj08 IS NULL OR
                    (g_rbj[l_ac2].rbj08 != g_rbj_o.rbj08 ) THEN
                    CALL t404_rbj08('a',l_ac2) 
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_rbj[l_ac2].rbj08,g_errno,0)
                       LET g_rbj[l_ac2].rbj08 = g_rbj_o.rbj08
                       NEXT FIELD rbj08
                    END IF
                 END IF  
              END IF  

           AFTER FIELD rbj09
              IF NOT cl_null(g_rbj[l_ac2].rbj09) THEN
                 IF g_rbj_o.rbj09 IS NULL OR
                    (g_rbj[l_ac2].rbj09 != g_rbj_o.rbj09 ) THEN
                    CALL t404_rbj09('a')
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_rbj[l_ac2].rbj09,g_errno,0)
                       LET g_rbj[l_ac2].rbj09 = g_rbj_o.rbj09
                       NEXT FIELD rbj09
                    END IF
                 END IF  
              END IF  

           BEFORE DELETE
              DISPLAY "BEFORE DELETE"
              IF g_rbj_t.rbj06 > 0 AND g_rbj_t.rbj06 IS NOT NULL THEN
                 IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
                 END IF
                 IF l_lock_sw = "Y" THEN
                    CALL cl_err("", -263, 1)
                    CANCEL DELETE
                 END IF
                 DELETE FROM rbj_file
                  WHERE rbj02 = g_rbh.rbh02 AND rbj01 = g_rbh.rbh01
                    AND rbj03 = g_rbh.rbh03 AND rbj04 = l_rbj04_curr
                    AND rbj06 = g_rbj_t.rbj06 
                    AND rbjplant = g_rbh.rbhplant
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","rbj_file",g_rbh.rbh02,g_rbj_t.rbj06,SQLCA.sqlcode,"","",1)
                    ROLLBACK WORK
                    CANCEL DELETE
                 END IF
              #  LET g_rec_b1=g_rec_b1-1    #FUN-C60041 mark
                 LET g_rec_b2=g_rec_b2-1    #FUN-C60041 add
              END IF
              COMMIT WORK

           ON ROW CHANGE
              IF INT_FLAG THEN
                 CALL cl_err('',9001,0)
                 LET INT_FLAG = 0
                 LET g_rbj[l_ac2].* = g_rbj_t.*
                 CLOSE t4041_bcl
                 ROLLBACK WORK
                 EXIT DIALOG 
              END IF
              IF cl_null(g_rbj[l_ac2].rbj09) THEN
                 LET g_rbj[l_ac2].rbj09=' '
              END IF 
              IF cl_null(g_rbj_t.rbj09) THEN
                 LET g_rbj_t.rbj09=' '
              END IF 
              IF l_lock_sw = 'Y' THEN
                 CALL cl_err(g_rbj[l_ac2].rbj06,-263,1)
                 LET g_rbj[l_ac2].* = g_rbj_t.*
              ELSE
                 IF g_rbj[l_ac2].rbj06<>g_rbj_t.rbj06 OR
                    g_rbj[l_ac2].rbj07<>g_rbj_t.rbj07 OR
                    g_rbj[l_ac2].rbj08<>g_rbj_t.rbj08 OR
                    g_rbj[l_ac2].rbj09<>g_rbj_t.rbj09 THEN
                    SELECT COUNT(*) INTO l_n FROM rbj_file
                     WHERE rbj01 =g_rbh.rbh01 AND rbj02 = g_rbh.rbh02
                       AND rbj03=g_rbh.rbh03
                       AND rbj06 = g_rbj[l_ac2].rbj06 
                       AND rbj07 = g_rbj[l_ac2].rbj07
                       AND rbh08 = g_rbj[l_ac2].rbj08 
                       AND rbj09 = g_rbj[l_ac2].rbj09
                       AND rbjplant = g_rbh.rbhplant
                    IF l_n>0 THEN 
                       CALL cl_err('',-239,0)
                      #LET g_rbj[l_ac2].* = g_rbj_t.*
                       NEXT FIELD rbj06
                    END IF
                 END IF            
                   UPDATE rbj_file SET rbj06=g_rbj[l_ac2].rbj06,
                                     rbj07=g_rbj[l_ac2].rbj07,
                                     rbj08=g_rbj[l_ac2].rbj08,
                                     rbj09=g_rbj[l_ac2].rbj09,
                                     rbjacti=g_rbj[l_ac2].rbjacti
                  WHERE rbj02 = g_rbh.rbh02 AND rbj01=g_rbh.rbh01 AND rbj03=g_rbh.rbh03 
                    AND rbj04 = l_rbj04_curr AND rbj05='1'
                    AND rbj06=g_rbj_t.rbj06 AND rbj07=g_rbj_t.rbj07 AND rbjplant = g_rbh.rbhplant
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                    CALL cl_err3("upd","rbj_file",g_rbh.rbh02,g_rbj_t.rbj06,SQLCA.sqlcode,"","",1) 
                    LET g_rbj[l_ac2].* = g_rbj_t.*
                 ELSE                
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK                
                 END IF
              END IF

           AFTER ROW
              DISPLAY  "AFTER ROW!!"
              LET l_ac2 = ARR_CURR()
              LET l_ac2_t = l_ac2   
              IF INT_FLAG THEN
                 CALL cl_err('',9001,0)
                 LET INT_FLAG = 0
                 IF p_cmd = 'u' THEN
                    LET g_rbj[l_ac2].* = g_rbj_t.*
                 END IF
                 CLOSE t4041_bcl
                 ROLLBACK WORK
                 EXIT DIALOG 
              END IF
              CLOSE t4041_bcl
              COMMIT WORK

        END INPUT   

      #FUN-D30033--add---begin---
      BEFORE DIALOG
         CASE g_b_flag
            WHEN '1' NEXT FIELD rbi06
            WHEN '2' NEXT FIELD rbj06
            WHEN '3' NEXT FIELD rbk08
         END CASE
      #FUN-D30033--add---end---
        ON ACTION ACCEPT
           ACCEPT DIALOG

        ON ACTION CANCEL
          #TQC-C20328 add START
          IF g_flag = 'Y' AND NOT cl_null(l_ac1) AND l_ac1>0 THEN     #FUN-C60041 add
           LET l_n = 0  #當使用者選擇放棄,也必須把rbp_file的相關資料刪除
           SELECT COUNT(*) INTO l_n FROM rbi_file
             WHERE rbi01 = g_rbh.rbh01 AND rbi02 = g_rbh.rbh02
               AND rbi03 = g_rbh.rbh03 AND rbi06 = g_rbi[l_ac1].rbi06
               AND rbi10 <> '0' AND rbi05 = '1'
           IF l_n = 0 THEN
              LET l_n = 0
              SELECT COUNT(*) INTO l_n FROM rbp_file
               WHERE rbp01 = g_rbh.rbh01 AND rbp02 = g_rbh.rbh02
                 AND rbp03 = g_rbh.rbh03 AND rbp04 = '3'
                 AND rbp06 = '1' AND rbp07 = g_rbi[l_ac1].rbi06
                 AND rbp12 = g_rbi[l_ac1].rbi10
              IF l_n > 0 THEN
                 DELETE FROM rbp_file
                  WHERE rbp01 = g_rbh.rbh01 AND rbp02 = g_rbh.rbh02
                    AND rbp03 = g_rbh.rbh03 AND rbp04 = '3'
                    AND rbp07 = g_rbi[l_ac1].rbi06
              END IF
           END IF
          END IF                                                     #FUN-C60041 add
          #TQC-C20328 add END
      #FUN-D30033--add--str--
         IF l_flag = '1' THEN
            IF p_cmd = 'a' THEN 
               CALL g_rbi.deleteElement(l_ac1)
               IF g_rec_b1 != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac1 = l_ac1_t
               END IF
            END IF
            CLOSE t404_bcl
            ROLLBACK WORK
         END IF
         IF l_flag = '2' THEN
            IF p_cmd = 'a' THEN
               CALL g_rbj.deleteElement(l_ac2)
               IF g_rec_b2 != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac2 = l_ac2_t
               END IF
            END IF
            CLOSE t4041_bcl
            ROLLBACK WORK
         END IF
         IF l_flag = '3' THEN
            IF p_cmd = 'a' THEN
               CALL g_rbk.deleteElement(l_ac3)
               IF g_rec_b3 != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac3 = l_ac3_t
               END IF
            END IF
            CLOSE t4042_bcl
            ROLLBACK WORK
         END IF
      #FUN-D30033--add--end--
           EXIT DIALOG

        ON ACTION alter_memberlevel    
           IF NOT cl_null(g_rbh.rbh02) THEN
              IF l_ac1 = 0 THEN LET l_ac1 = 1 END IF  
              IF g_rbi[l_ac1].rbi10 <> '0' THEN
                 CALl t402_2(g_rbh.rbh01,g_rbh.rbh02,g_rbh.rbh03,'3',g_rbh.rbhplant,g_rbh.rbhconf,
                             g_rbh.rbh10t,g_rbi[l_ac1].rbi10,g_rbi[l_ac1].rbi06)  #TQC-C20328 add rbi06 
              END IF  
           ELSE
              CALL cl_err('',-400,0)
           END IF

        ON ACTION CONTROLO
           IF INFIELD(rbj06) AND l_ac2 > 1 THEN
              LET g_rbj[l_ac2].* = g_rbj[l_ac2-1].*
              LET g_rec_b2 = g_rec_b2+1
              NEXT FIELD rbj06
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
             WHEN INFIELD(rbj08)
                 CALL cl_init_qry_var()
                 CASE g_rbj[l_ac2].rbj07
                    WHEN '01'
                       CALL q_sel_ima(FALSE, "q_ima","",g_rbj[l_ac2].rbj08,"","","","","",'' ) 
                          RETURNING g_rbj[l_ac2].rbj08  
                    WHEN '02'
                       LET g_qryparam.form ="q_oba01"
                    WHEN '03'
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '1'
                    WHEN '04'
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '2'
                    WHEN '05'
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '3'
                    WHEN '06'
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '4'
                    WHEN '07'
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '5'
                    WHEN '08'
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '6'
                    WHEN '09'
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '27'
                 END CASE
                 IF g_rbj[l_ac2].rbj07 != '01' THEN                           
                    LET g_qryparam.default1 = g_rbj[l_ac2].rbj08
                    CALL cl_create_qry() RETURNING g_rbj[l_ac2].rbj08
                 END IF                                                                                   
                 CALL t404_rbj08('d',l_ac2)
                 NEXT FIELD rbj08
                 
              WHEN INFIELD(rbj09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe02"
                 SELECT DISTINCT ima25
                   INTO l_ima25
                   FROM ima_file
                  WHERE ima01=g_rbj[l_ac2].rbj08  
                 LET g_qryparam.arg1 = l_ima25
                 LET g_qryparam.default1 = g_rbj[l_ac2].rbj09
                 CALL cl_create_qry() RETURNING g_rbj[l_ac2].rbj09
                 CALL t404_rbj09('d')
                 NEXT FIELD rbj09
              OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) 
              RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
  
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE DIALOG 
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION HELP
           CALL cl_show_help()
 
        ON ACTION controls         
           CALL cl_set_head_visible("","AUTO")    

    END DIALOG

    CLOSE t404_bcl
    CLOSE t4041_bcl
    CLOSE t4042_bcl
    CALL t404_upd_log() 
    COMMIT WORK

    CALL t404_b1_fill(g_wc1)         #單身1
    CALL t404_b2_fill(g_wc2)         #單身2
    CALL t404_b3_fill(g_wc3)

END FUNCTION 

FUNCTION t404_b3_init()

   LET g_rbk[l_ac3].rbk09 = g_today        
   LET g_rbk[l_ac3].rbk11 = '00:00:00'    
   LET g_rbk[l_ac3].rbk10 = g_today     
   LET g_rbk[l_ac3].rbk12 = '23:59:59'    
   LET g_rbk[l_ac3].rbkacti = 'Y'

   LET g_rbk[l_ac3].type2    ='0'
   LET g_rbk[l_ac3].before2  =' '
   LET g_rbk[l_ac3].after2   ='1'
   CALL t404_set_entry_rbk()

END FUNCTION


FUNCTION t404_b3_find()

   LET g_rbk[l_ac3].type2  ='1'
   LET g_rbk[l_ac3].before2 ='0'
   LET g_rbk[l_ac3].after2 ='1'

   SELECT rak05,rak06, rak07, rak08, rak09, rak10, rak11, rakacti
         INTO g_rbk[l_ac3].rbk08_1,
              g_rbk[l_ac3].rbk09_1, g_rbk[l_ac3].rbk10_1,
              g_rbk[l_ac3].rbk11_1, g_rbk[l_ac3].rbk12_1,
              g_rbk[l_ac3].rbk13_1, g_rbk[l_ac3].rbk14_1,
              g_rbk[l_ac3].rbkacti_1
     FROM rak_file
         WHERE rak01 = g_rbh.rbh01 AND rak02 = g_rbh.rbh02
           AND rak03 = '3' 
           AND rak05 = g_rbk[l_ac3].rbk08 AND rakplant = g_rbh.rbhplant

   LET g_rbk[l_ac3].rbk09 = g_rbk[l_ac3].rbk09_1
   LET g_rbk[l_ac3].rbk10 = g_rbk[l_ac3].rbk10_1
   LET g_rbk[l_ac3].rbk11 = g_rbk[l_ac3].rbk11_1
   LET g_rbk[l_ac3].rbk12 = g_rbk[l_ac3].rbk12_1
   LET g_rbk[l_ac3].rbk13 = g_rbk[l_ac3].rbk13_1
   LET g_rbk[l_ac3].rbk14 = g_rbk[l_ac3].rbk14_1
   LET g_rbk[l_ac3].rbkacti = g_rbk[l_ac3].rbkacti_1

   DISPLAY BY NAME g_rbk[l_ac3].rbk08_1,
                   g_rbk[l_ac3].rbk09_1, g_rbk[l_ac3].rbk10_1,
                   g_rbk[l_ac3].rbk11_1, g_rbk[l_ac3].rbk12_1,
                   g_rbk[l_ac3].rbk13_1, g_rbk[l_ac3].rbk14_1,
                   g_rbk[l_ac3].rbkacti_1

   DISPLAY BY NAME g_rbk[l_ac3].rbk09, g_rbk[l_ac3].rbk10,
                   g_rbk[l_ac3].rbk11, g_rbk[l_ac3].rbk12,
                   g_rbk[l_ac3].rbk13, g_rbk[l_ac3].rbk14,
                   g_rbk[l_ac3].rbkacti

   DISPLAY BY NAME g_rbk[l_ac3].type2,g_rbk[l_ac3].before2,g_rbk[l_ac3].after2
   CALL t404_set_entry_rbk()

END FUNCTION

FUNCTION t404_set_entry_rbk()

   IF cl_null(g_rbk[l_ac3].rbk13) AND cl_null(g_rbk[l_ac3].rbk14) THEN
      CALL cl_set_comp_entry("rbk14",TRUE)
      CALL cl_set_comp_entry("rbk13",TRUE)
   END IF
   IF NOT cl_null(g_rbk[l_ac3].rbk13) THEN
      CALL cl_set_comp_entry("rbk14",FALSE)
   ELSE
      CALL cl_set_comp_entry("rbk14",TRUE)
   END IF
   IF NOT cl_null(g_rbk[l_ac3].rbk14) THEN
      CALL cl_set_comp_entry("rbk13",FALSE)
   ELSE
      CALL cl_set_comp_entry("rbk13",TRUE)
   END IF
END FUNCTION

FUNCTION t404_b3_fill(p_wc)
DEFINE p_wc            STRING
DEFINE l_sql           STRING

   LET g_sql = " SELECT '',a.rbk06,a.rbk08,a.rbk09,a.rbk10,a.rbk11,a.rbk12,a.rbk13,a.rbk14,a.rbkacti, ",
               "           b.rbk06,b.rbk08,b.rbk09,b.rbk10,b.rbk11,b.rbk12,b.rbk13,b.rbk14,b.rbkacti  ",
               " FROM rbk_file b LEFT OUTER JOIN rbk_file a ",
               "          ON (b.rbk01=a.rbk01 AND b.rbk02=a.rbk02 AND b.rbk03=a.rbk03 AND b.rbk04=a.rbk04 ",
               "              AND b.rbk07=a.rbk07 AND b.rbk08=a.rbk08 AND b.rbkplant=a.rbkplant AND b.rbk06<>a.rbk06 )",
               "   WHERE b.rbk01 = '",g_rbh.rbh01 CLIPPED ,"'  AND b.rbk02 = '",g_rbh.rbh02 CLIPPED ,"' ",
               "     AND b.rbk03 = '",g_rbh.rbh03 CLIPPED ,"' AND b.rbkplant='",g_rbh.rbhplant CLIPPED ,"' ",
               "     AND b.rbk06='1' AND b.rbk05 = '3'"
   IF NOT cl_null(p_wc) THEN
      LET l_sql = l_sql ," AND ", p_wc
   END IF

   PREPARE t404_b3_prepare FROM g_sql                     #預備一下
   DECLARE rbk_cs CURSOR FOR t404_b3_prepare
   CALL g_rbk.clear()
   LET g_rec_b3 = 0
   LET g_cnt = 1

   FOREACH rbk_cs INTO g_rbk[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      IF g_rbk[g_cnt].before2='0' THEN
         LET g_rbk[g_cnt].type2='1'
      ELSE
         LET g_rbk[g_cnt].type2='0'
      END IF

      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF

   END FOREACH

   CALL g_rbk.deleteElement(g_cnt)
   LET g_rec_b3 = g_cnt-1
   DISPLAY g_rec_b3 TO FORMONLY.cn3
END FUNCTION

#原促銷方式已有設定資料，將 rap相關資料INSERT 至 rbp_file 且變更後的有效碼為'N'
FUNCTION t404_rbp()
DEFINE l_sql             STRING
DEFINE l_rap             RECORD LIKE rap_file.*
DEFINE l_rbp05           LIKE rbp_file.rbp05
DEFINE l_n               LIKE type_file.num5

   IF g_rbi[l_ac1].rbi10 = g_rbi[l_ac1].rbi10_1 THEN RETURN END IF
   IF g_rbi[l_ac1].rbi10_1 = '0' THEN RETURN END IF
   SELECT COUNT(*) INTO l_n FROM rbp_file
      WHERE rbp01 = g_rbh.rbh01 AND rbp02 = g_rbh.rbh02
        AND rbp03 = g_rbh.rbh03 AND rbp04 = '3'
        AND rbpplant = g_rbh.rbhplant  #TQC-C20328 add
        AND rbp06 = '1' AND rbp12 = g_rbi[l_ac1].rbi10_1 
        AND rbpacti = 'N'
   IF l_n > 0 THEN
      RETURN
   END IF

   SELECT MAX(rbp05) INTO l_rbp05 FROM rbp_file
     WHERE rbp01 = g_rbh.rbh01 AND rbp02 = g_rbh.rbh02
       AND rbp03 = g_rbh.rbh03 AND rbp04 = '4'
       AND rbp09 = g_rbi[l_ac1].rbi10 
   IF l_rbp05 = 0 OR cl_null(l_rbp05) THEN
      LET l_rbp05 = 1
   END IF
   LET l_sql = " SELECT * FROM rap_file ",
               " WHERE rap01 = '",g_rbh.rbh01,"' AND rap02 = '",g_rbh.rbh02,"'",
               " AND rap03 = '3' ",
               " AND rap09 = '",g_rbi[l_ac1].rbi10_1, "'",
               " AND rapplant = '",g_rbh.rbhplant, "'"
   PREPARE t404_sel_rbp FROM l_sql
   DECLARE t404sub_sel_rbp_cs CURSOR FOR t404_sel_rbp
   FOREACH t404sub_sel_rbp_cs INTO l_rap.*
      LET l_rap.rapacti = 'N'

      IF cl_null(l_rap.rap07) THEN LET l_rap.rap07 = 100 END IF
      LET l_sql = "INSERT INTO rbp_file (rbp01,rbp02,rbp03,rbp04,rbp05,rbp06, ",
                  "                      rbp07,rbp08,rbp09,rbp10,rbp11,rbp12, ",
                  "                      rbpacti,rbplegal,rbpplant )",
                  " VALUES ('",g_rbh.rbh01,"','",g_rbh.rbh02,"',",g_rbh.rbh03,",",
                  "         '3',",l_rbp05,",'1',",l_rap.rap04,",'",l_rap.rap05,"',",
                  "          ",l_rap.rap06,",",l_rap.rap07,",",l_rap.rap08,",'",l_rap.rap09,"',",
                  "          '",l_rap.rapacti,"','",g_rbh.rbhlegal,"','",g_rbh.rbhplant,"')"


      PREPARE trans_ins_rap1 FROM l_sql
      EXECUTE trans_ins_rap1
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","rap_file",g_rbh.rbh02,"",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
         RETURN
      END IF
   END FOREACH
END FUNCTION

FUNCTION t404_delrbp()
DEFINE l_sql         STRING
DEFINE l_n           LIKE type_file.num5

   IF g_rbi[l_ac1].rbi10 = g_rbi[l_ac1].rbi10_1 THEN
      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM rbp_file
         WHERE rbp01 = g_rbh.rbh01 AND rbp02 = g_rbh.rbh02
           AND rbp03 = g_rbh.rbh03 AND rbp04 = '3'
           AND rbpplan = g_rbh.rbhplant
           AND rbp06 = '1' AND rbp12 = g_rbi[l_ac1].rbi10_1  
           AND rbpacti = 'N'
      IF l_n > 0 THEN
         DELETE FROM rbp_file
            WHERE rbp01 = g_rbh.rbh01 AND rbp02 = g_rbh.rbh02
              AND rbp03 = g_rbh.rbh03 AND rbp04 = '3'
              AND rbp06 = '1' AND rbp12 = g_rbi[l_ac1].rbi10_1 
              AND rbpacti = 'N'
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","rap_file",g_rbh.rbh02,"",SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
   END IF
  #IF g_rbi[l_ac1].rbi10_1 <> g_rbi[l_ac1].rbi10 THEN
   IF g_rbi_o.rbi10 <> g_rbi[l_ac1].rbi10 THEN  #TQC-C20378 add
      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM rbp_file
         WHERE rbp01 = g_rbh.rbh01 AND rbp02 = g_rbh.rbh02
           AND rbp03 = g_rbh.rbh03 AND rbp04 = '3'
           AND rbpplant = g_rbh.rbhplant  #TQC-C20328 add
           AND rbp06 = '1' AND rbp12 = g_rbi_o.rbi10 
           AND rbpacti = 'Y'  #TQC-C20378 add
      IF l_n > 0 THEN
         DELETE FROM rbp_file
            WHERE rbp01 = g_rbh.rbh01 AND rbp02 = g_rbh.rbh02
              AND rbp03 = g_rbh.rbh03 AND rbp04 = '3'
              AND rbp06 = '1' AND rbp12 = g_rbi_o.rbi10 
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","rap_file",g_rbh.rbh02,"",SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
   END IF

END FUNCTION

#FUN-BC0126 add END 

#FUN-C30151 add START
FUNCTION t404_rbi13_text()
DEFINE l_text    LIKE ze_file.ze03

   IF g_rbh.rbh10t = '2' THEN
      CALL cl_getmsg('art1059',g_lang) RETURNING l_text
   ELSE
      CALL cl_getmsg('art1060',g_lang) RETURNING l_text
   END IF
   CALL cl_set_comp_lab_text('dummy27',l_text) 

   IF g_rbh.rbh25t = '1' THEN
      CALL cl_getmsg('art1061',g_lang) RETURNING l_text
   ELSE
      CALL cl_getmsg('art1062',g_lang) RETURNING l_text
   END IF
   CALL cl_set_comp_lab_text('dummy3',l_text)

END FUNCTION
#FUN-C30151 add END

#FUN-C60041 ---------------STA
FUNCTION t404_create_temp_table()
   DROP TABLE rbh_temp
   SELECT * FROM rbh_file WHERE 1 = 0 INTO TEMP rbh_temp
   DROP TABLE rbi_temp
   SELECT * FROM rbi_file WHERE 1 = 0 INTO TEMP rbi_temp
   DROP TABLE rbj_temp
   SELECT * FROM rbj_file WHERE 1 = 0 INTO TEMP rbj_temp
   DROP TABLE rbp_temp
   SELECT * FROM rbp_file WHERE 1 = 0 INTO TEMP rbp_temp
   DROP TABLE rbq_temp
   SELECT * FROM rbq_file WHERE 1 = 0 INTO TEMP rbq_temp
    DROP TABLE rbr_temp
   SELECT * FROM rbr_file WHERE 1 = 0 INTO TEMP rbr_temp
   DROP TABLE rbs_temp
   SELECT * FROM rbs_file WHERE 1 = 0 INTO TEMP rbs_temp
   DROP TABLE rbk_temp   
   SELECT * FROM rbk_file WHERE 1 = 0 INTO TEMP rbk_temp  

   DROP TABLE rah_temp
   SELECT * FROM rah_file WHERE 1 = 0 INTO TEMP rah_temp
   DROP TABLE rai_temp
   SELECT * FROM rai_file WHERE 1 = 0 INTO TEMP rai_temp
   DROP TABLE raj_temp
   SELECT * FROM raj_file WHERE 1 = 0 INTO TEMP raj_temp
   DROP TABLE rap_temp
   SELECT * FROM rap_file WHERE 1 = 0 INTO TEMP rap_temp
   DROP TABLE raq_temp
   SELECT * FROM raq_file WHERE 1 = 0 INTO TEMP raq_temp
   DROP TABLE rar_temp
   SELECT * FROM rar_file WHERE 1 = 0 INTO TEMP rar_temp
   DROP TABLE ras_temp
   SELECT * FROM ras_file WHERE 1 = 0 INTO TEMP ras_temp
   DROP TABLE rak_temp  
   SELECT * FROM rak_file WHERE 1 = 0 INTO TEMP rak_temp
END FUNCTION

FUNCTION t404_drop_temp_table()
   DROP TABLE rbh_temp
   DROP TABLE rbi_temp
   DROP TABLE rbj_temp
   DROP TABLE rbp_temp
   DROP TABLE rbq_temp
   DROP TABLE rbr_temp
   DROP TABLE rbs_temp
   DROP TABLE rbk_temp   

   DROP TABLE rah_temp
   DROP TABLE rai_temp
   DROP TABLE raj_temp
   DROP TABLE rap_temp
   DROP TABLE raq_temp
   DROP TABLE rar_temp
   DROP TABLE ras_temp
   DROP TABLE rak_temp
END FUNCTION


#FUN-C60041 ---------------END
