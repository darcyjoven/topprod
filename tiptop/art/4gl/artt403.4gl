# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: artt403.4gl
# Descriptions...: 組合促銷變更維護作業
# Date & Author..: NO.FUN-A80104 10/09/06 By lixia 
# Modify.........: No.FUN-AA0059 10/10/28 By chenying 料號開窗控管 
# Modify.........: No.FUN-AB0033 10/11/10 By wangxin 促銷BUG調整
# Modify.........: No.FUN-AB0025 10/11/12 By vealxu AFTER FIELD rbg08 應判斷 if g_rbg[l_ac2].rbg07="01" 要 call s_chk_item_no
# Modify.........: No.FUN-AB0101 10/11/26 By vealxu 料號檢查部份邏輯修改：如果對應營運中心有設產品策略，則抓產品策略的料號
# Modify.........: No.MOD-AC0189 10/12/20 By shenyang 修改5.25CT1 bug
# Modify.........: No:TQC-AC0326 10/12/24 By wangxin 促銷變更單要管控，審核、發布後的才可變更,
#                                                    生效營運中心中有對應的促銷單並且審核、發布， 才可審核對應的變更單,
#                                                    生效營運中心中有對應的促銷單的未審核變更單則不可審核當前促銷變更單
# Modify.........: No.TQC-B10003 11/01/05 By shenyang 修改5.25PT bug
# Modify.........: No.FUN-B30028 11/03/11 By huangtao 移除簽核相關欄位
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60071 11/06/17 By baogc 添加確認時對組合數量的控管
# Modify.........: No.FUN-B80085 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外 
# Modify.........: No.FUN-BC0078 11/12/22 By pauline GP5.3 artt403 一般促銷變更單促銷功能優化

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.TQC-C20328 12/02/21 By pauline 增加artt402_2參數
# Modify.........: No.TQC-C20378 12/02/22 By pauline 把原會員促銷方式的有效碼UPDATE為'N'
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C60041 12/06/15 By huangtao變更生效門店時，對相應的門店資料做更顯
# Modify.........: No.TQC-D30007 13/03/04 By pauline 組合數量計算錯誤,未過濾plantCode
# Modify.........: No.MOD-D40005 13/04/01 By SunLM t403_check_rbe21t的SQL都少了所屬營運中心的條件
# Modify.........: No:FUN-D30033 13/04/18 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    #单头
    g_rbe           RECORD LIKE rbe_file.*,      
    g_rbe_t         RECORD LIKE rbe_file.*,  
    g_rbe_o         RECORD LIKE rbe_file.*, 
    g_rbe01_t       LIKE rbe_file.rbe01,
    g_rbe02_t       LIKE rbe_file.rbe02,          #變更單號 (舊值)
    g_rbe03_t       LIKE rbe_file.rbe03,          #變更序號 (舊值)   
    g_rbeplant_t    LIKE rbe_file.rbeplant,      
    #第一单身
    g_rbf             DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
        type          LIKE type_file.chr1,   #類型 0.新增 1.修改
        before        LIKE type_file.chr1,   #0:初始 
        rbf06_1       LIKE rbf_file.rbf06,   #組別
        rbf07_1       LIKE rbf_file.rbf07,   #參與方式
        rbf08_1       LIKE rbf_file.rbf08,   #數量        
        rbfacti_1     LIKE rbf_file.rbfacti, #有效碼

        after         LIKE type_file.chr1,   #1:修改
        rbf06         LIKE rbf_file.rbf06,   
        rbf07         LIKE rbf_file.rbf07,   
        rbf08         LIKE rbf_file.rbf08,                 
        rbfacti       LIKE rbf_file.rbfacti 
                      END RECORD,
    g_rbf_t           RECORD                 #程式變數 (舊值)
        type          LIKE type_file.chr1,   #類型 0.新增 1.修改
        before        LIKE type_file.chr1,   #0:初始 
        rbf06_1       LIKE rbf_file.rbf06,   #組別
        rbf07_1       LIKE rbf_file.rbf07,   #參與方式
        rbf08_1       LIKE rbf_file.rbf08,   #數量        
        rbfacti_1     LIKE rbf_file.rbfacti, #有效碼

        after         LIKE type_file.chr1,   #1:修改
        rbf06         LIKE rbf_file.rbf06,   
        rbf07         LIKE rbf_file.rbf07,   
        rbf08         LIKE rbf_file.rbf08,   
        rbfacti       LIKE rbf_file.rbfacti 
                      END RECORD,
    g_rbf_o           RECORD                 #程式變數 (舊值)
        type          LIKE type_file.chr1,   #類型 0.新增 1.修改
        before        LIKE type_file.chr1,   #0:初始 
        rbf06_1       LIKE rbf_file.rbf06,   #組別
        rbf07_1       LIKE rbf_file.rbf07,   #參與方式
        rbf08_1       LIKE rbf_file.rbf08,   #數量        
        rbfacti_1     LIKE rbf_file.rbfacti, #有效碼

        after         LIKE type_file.chr1,   #1:修改
        rbf06         LIKE rbf_file.rbf06,   
        rbf07         LIKE rbf_file.rbf07,   
        rbf08         LIKE rbf_file.rbf08,   
        rbfacti       LIKE rbf_file.rbfacti 
                      END RECORD
    #第二单身
DEFINE  
    g_rbg             DYNAMIC ARRAY OF RECORD  
        type1         LIKE type_file.chr1,       
        before1       LIKE type_file.chr1,
        rbg06_1       LIKE rbg_file.rbg06,
        rbg07_1       LIKE rbg_file.rbg07,
        rbg08_1       LIKE rbg_file.rbg08,
        rbg08_1_desc  LIKE ima_file.ima02,
        rbg09_1       LIKE rbg_file.rbg09,
        rbg09_1_desc  LIKE gfe_file.gfe02,
        rbgacti_1     LIKE rbg_file.rbgacti,

        after1        LIKE type_file.chr1,
        rbg06         LIKE rbg_file.rbg06,  
        rbg07         LIKE rbg_file.rbg07,  
        rbg08         LIKE rbg_file.rbg08,  
        rbg08_desc    LIKE ima_file.ima02,  
        rbg09         LIKE rbg_file.rbg09,  
        rbg09_desc    LIKE gfe_file.gfe02,  
        rbgacti       LIKE rbg_file.rbgacti  
                      END RECORD,
    g_rbg_t           RECORD 
        type1         LIKE type_file.chr1,       
        before1       LIKE type_file.chr1,
        rbg06_1       LIKE rbg_file.rbg06,
        rbg07_1       LIKE rbg_file.rbg07,
        rbg08_1       LIKE rbg_file.rbg08,
        rbg08_1_desc  LIKE ima_file.ima02,
        rbg09_1       LIKE rbg_file.rbg09,
        rbg09_1_desc  LIKE gfe_file.gfe02,
        rbgacti_1     LIKE rbg_file.rbgacti,

        after1        LIKE type_file.chr1,
        rbg06         LIKE rbg_file.rbg06,  
        rbg07         LIKE rbg_file.rbg07,  
        rbg08         LIKE rbg_file.rbg08,  
        rbg08_desc    LIKE ima_file.ima02,  
        rbg09         LIKE rbg_file.rbg09,  
        rbg09_desc    LIKE gfe_file.gfe02,  
        rbgacti       LIKE rbg_file.rbgacti  
                      END RECORD,
    g_rbg_o           RECORD
        type1         LIKE type_file.chr1,       
        before1       LIKE type_file.chr1,
        rbg06_1       LIKE rbg_file.rbg06,
        rbg07_1       LIKE rbg_file.rbg07,
        rbg08_1       LIKE rbg_file.rbg08,
        rbg08_1_desc  LIKE ima_file.ima02,
        rbg09_1       LIKE rbg_file.rbg09,
        rbg09_1_desc  LIKE gfe_file.gfe02,
        rbgacti_1     LIKE rbg_file.rbgacti,

        after1        LIKE type_file.chr1,
        rbg06         LIKE rbg_file.rbg06,  
        rbg07         LIKE rbg_file.rbg07,  
        rbg08         LIKE rbg_file.rbg08,  
        rbg08_desc    LIKE ima_file.ima02,  
        rbg09         LIKE rbg_file.rbg09,  
        rbg09_desc    LIKE gfe_file.gfe02,  
        rbgacti       LIKE rbg_file.rbgacti  
                      END RECORD    

DEFINE
    g_wc,g_wc1,g_wc2,g_sql    string,  
    l_flag              LIKE type_file.chr1,    
    g_flag_b            LIKE type_file.chr1,
    g_argv1     	    LIKE pmn_file.pmn01,    
    g_argv2             LIKE pmn_file.pmn02,    
    g_argv3             STRING,                  
    g_rec_b1            LIKE type_file.num5,    #單身筆數 
    g_rec_b2            LIKE type_file.num5,    #單身筆數
    g_t1                LIKE oay_file.oayslip,  
    g_sta               LIKE ze_file.ze03,      
    l_ac_1              LIKE type_file.num5,    
    l_ac1               LIKE type_file.num5,    #目前處理的ARRAY CNT  
    l_ac2               LIKE type_file.num5     #目前處理的ARRAY CNT 
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
DEFINE   g_term         LIKE rbe_file.rbe10     
DEFINE   g_price        LIKE rbe_file.rbe09    
DEFINE   l_dbs_tra      LIKE azw_file.azw05    
DEFINE   l_plant_new    LIKE azp_file.azp01    
 
DEFINE l_azp02          LIKE azp_file.azp02
DEFINE g_rtz05          LIKE rtz_file.rtz05  #價格策略
DEFINE g_rtz04          LIKE rtz_file.rtz04  #FUN-AB0101
DEFINE l_tt   DATETIME YEAR TO FRACTION(4)
DEFINE l_tp   DATETIME YEAR TO FRACTION(4)
define l_tt1 like type_file.chr30
DEFINE g_b_flag         STRING                  #FUN-D30033 Add 
#FUN-BC0078 add START
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


#FUN-BC0078 add END
MAIN
    #IF FGL_GETENV("FGLGUI") <> "0" THEN
    #   OPTIONS                                #改變一些系統預設值
    #       INPUT NO WRAP,
    #       FIELD ORDER FORM                   #整個畫面會依照p_per所設定的欄位順序(忽略4gl寫的順序)  #FUN-730068
    #   DEFER INTERRUPT
    #END IF

    #DISPLAY EXTEND ( TODAY, YEAR TO FRACTION(4) )

    #LET l_tt =CURRENT YEAR TO FRACTION(4)
    #LET l_tt1 = l_tt
    #LET l_tt1 = l_tt1[1,4],l_tt1[6,7],l_tt1[9,10],l_tt1[12,13],l_tt1[15,16],l_tt1[18,19],l_tt1[21,22]
    #LET l_tt = (CURRENT YEAR TO FRACTION(4)) USING 'YYYYMMDDHH24MISSFF'
    #LET l_tt1 = g_today USING 'YYYYMMDD'," ",TIME
    OPTIONS
      INPUT NO WRAP
    DEFER INTERRUPT
    
    LET g_argv1     = ARG_VAL(1)          # 參數值(1) - 制定機構
    LET g_argv2     = ARG_VAL(2)          # 參數值(1) - 促銷單號  
    LET g_argv3     = ARG_VAL(3)          # 參數值(3) - 營運中心  

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
    LET g_forupd_sql = "SELECT * FROM rbe_file WHERE rbe01 = ? AND rbe02 = ? AND rbe03 =? AND rbeplant = ? FOR UPDATE" 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t403_cl CURSOR FROM g_forupd_sql
 
    OPEN WINDOW t403_w WITH FORM "art/42f/artt403"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
    CALL cl_set_comp_visible("rbe13,rbe14,rbe24,rbe25",FALSE)  #FUN-BC0078 add
    CALL cl_set_comp_visible("rbe13t,rbe14t,rbe24t,rbe25t",FALSE)  #FUN-BC0078 add
    CALL cl_set_comp_required("rbk14",FALSE)  #FUN-BC0078 add
    LET g_rbe.rbe01=g_plant
    DISPLAY BY NAME g_rbe.rbe01 
    SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01=g_plant
    DISPLAY l_azp02 TO rbe01_desc
    SELECT rtz04 INTO g_rtz04 FROM rtz_file WHERE rtz01 = g_plant    #FUN-AB0101 產品策略
    SELECT rtz05 INTO g_rtz05 FROM rtz_file WHERE rtz01=g_plant #價格策略 
    CALL t403_menu()
    CLOSE t403_cl
    CLOSE WINDOW t403_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
#QBE 查詢資料
FUNCTION t403_cs()
   DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = "rbe01 = '",g_argv1,"' "
      IF NOT cl_null(g_argv2) THEN
         LET g_wc = g_wc," AND rbe02='",g_argv2,"'"
         IF NOT cl_null(g_argv3) THEN
            LET g_wc = g_wc," AND rbeplant='",g_argv3,"'"
         END IF
      END IF
      LET g_wc1= " 1=1"
      LET g_wc2= " 1=1"
      LET g_rbe.rbe01=g_argv1
      DISPLAY BY NAME g_rbe.rbe01
      LET g_rbe.rbe02=g_argv2      
      DISPLAY BY NAME g_rbe.rbe02 
      LET g_rbe.rbeplant=g_argv3     
      DISPLAY BY NAME g_rbe.rbeplant 
   ELSE
      CLEAR FORM          
      CALL g_rbf.clear()
      CALL g_rbg.clear()
      CALL g_rbk.clear()  #FUN-BC0078 add
      CALL cl_set_head_visible("","YES")   
      INITIALIZE g_rbe.* TO NULL    
#      CONSTRUCT BY NAME g_wc ON rbe01,rbe02,rbe32,rbe03,rbeplant,rbemksg,rbe900,rbeconf,rbecond,   #FUN-B30028 mark
       CONSTRUCT BY NAME g_wc ON rbe01,rbe02,rbe32,rbe03,rbeplant,rbeconf,rbecond,                  #FUN-B30028
                               #rbeconu,rbe22,rbe04,rbe04t,rbe05,rbe05t,rbe06,rbe06t,rbe07,rbe07t,  #FUN-BC0078 mark
                                rbeconu,rbe22,                                                      #FUN-BC0078 add
                                rbe10,rbe10t,
                                rbe11,rbe11t,rbe12,rbe12t,rbe13,rbe13t,rbe14,rbe14t,rbe15,rbe15t,
                                rbe16,rbe16t,rbe17,rbe17t,rbe18,rbe18t,rbe19,rbe19t,rbe20,rbe20t,
                                rbe21,rbe21t,rbe23,rbe23t,rbe24,rbe24t,rbe25,rbe25t,rbe26,rbe26t,
                               #rbe27,rbe27t,rbe28,rbe28t,rbe29,rbe29t,rbe30,rbe30t,rbe31,rbe31t,   #FUN-BC0078 mark
                                rbe27,rbe27t, #FUN-BC0078 add
                                rbeuser,rbegrup,rbeoriu,rbemodu,rbedate,rbeorig,rbeacti,rbecrat              
         BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
         ON ACTION CONTROLP
            CASE
            WHEN INFIELD(rbe01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rae01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rbe01
                  NEXT FIELD rbe01
      
               WHEN INFIELD(rbe02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rae02"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rbe02
                  NEXT FIELD rbe02
      
               WHEN INFIELD(rbe32)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rae03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rbe32
                  NEXT FIELD rbe32
                  
            WHEN INFIELD(rbeconu)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                        
                  LET g_qryparam.form ="q_raeconu"                                                                                    
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO rbeconu                                                                              
                  NEXT FIELD rbeconu

            WHEN INFIELD(rbeplant)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                        
                  LET g_qryparam.form ="q_raeplant"                                                                                    
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO rbeplant                                                                              
                  NEXT FIELD rbeplant
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
      IF INT_FLAG THEN  RETURN END IF 
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rbeuser', 'rbegrup')
  
      DIALOG ATTRIBUTES(UNBUFFERED)    #FUN-BC0078 add

#FUN-BC0078 add START
      CONSTRUCT g_wc3 ON rbk08,rbk09,rbk10,rbk11,rbk12,rbk13,rab14,rbkacti
          FROM s_rbk[1].rbk08,s_rbk[1].rbk09,s_rbk[1].rbk10,
               s_rbk[1].rbk11,s_rbk[1].rbk12,s_rbk[1].rbk13,s_rbk[1].rbk14, s_rbk[1].rbkacti

            BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)
      END CONSTRUCT
#FUN-BC0078 add END

      CONSTRUCT g_wc1 ON b.rbf06,b.rbf07,b.rbf08,b.rbfacti
           FROM s_rbf[1].rbf06,s_rbf[1].rbf07,s_rbf[1].rbf08,s_rbf[1].rbfacti 

       	BEFORE CONSTRUCT
       	   CALL cl_qbe_display_condition(lc_qbe_sn)
       #FUN-BC0078 mark START
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
       #FUN-BC0078 mark END

      END CONSTRUCT
     #IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF  #FUN-BC0078 mark 

      CONSTRUCT g_wc2 ON b.rbg06,b.rbg07,b.rbg08,b.rbg09,b.rbgacti
           FROM s_rbg[1].rbg06,s_rbg[1].rbg07,s_rbg[1].rbg08,s_rbg[1].rbg09,s_rbg[1].rbgacti

         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
      #FUN-BC0078 mark START
      #  ON IDLE g_idle_seconds
      #     CALL cl_on_idle()
      #     CONTINUE CONSTRUCT

      #  ON ACTION about
      #     CALL cl_about()

      #  ON ACTION help
      #     CALL cl_show_help()

      #  ON ACTION controlg
      #     CALL cl_cmdask()

      #  ON ACTION qbe_save
      #     CALL cl_qbe_save()
      #FUN-BC0078 mark END
      END CONSTRUCT

    #FUN-BC0078 add START
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

    #FUN-BC0078 add END

      IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
      
      END DIALOG  #FUN-BC0078 add
   END IF

   LET g_wc1 = g_wc1 CLIPPED
   LET g_wc2 = g_wc2 CLIPPED
   LET g_wc  = g_wc  CLIPPED
   LET g_wc3 = g_wc3 CLIPPED  #FUN-BC0078 add

   IF cl_null(g_wc) THEN
      LET g_wc =" 1=1"
   END IF
   IF cl_null(g_wc1) THEN
      LET g_wc1=" 1=1"
   END IF
   IF cl_null(g_wc2) THEN
      LET g_wc2=" 1=1"
   END IF
   #FUN-BC0078 add START
   IF cl_null(g_wc3) THEN
      LET g_wc3 =" 1=1"
   END IF
   #FUN-BC0078 add END
   LET g_sql= "SELECT UNIQUE rbe01,rbe02,rbe03,rbeplant ",
              #FUN-AB0033 -------------start--------------
              "  FROM rbe_file LEFT OUTER JOIN rbf_file b ",
              "      ON (b.rbf01=rbe01 AND b.rbf02=rbe02 AND b.rbf03=rbe03 AND b.rbfplant=rbeplant)",   #FUN-BC0078 add
              "  LEFT OUTER JOIN rbg_file b ",
              "      ON (b.rbf01=b.rbg01 AND b.rbf02=b.rbg02 AND b.rbf03=b.rbg03 AND b.rbfplant=b.rbgplant ) ",
              #" WHERE rbe01 = b.rbf01 ",
              #"   AND rbe02 = b.rbf02 ",
              #"   AND rbe03 = b.rbf03 ",
              #"   AND rbeplant = b.rbfplant ",
              "  WHERE ",g_wc1 CLIPPED,
              #FUN-AB0033 --------------end---------------
              "   AND ", g_wc CLIPPED, " AND ", g_wc2 CLIPPED,
              " ORDER BY rbe01,rbe02,rbeplant "   
   PREPARE t403_prepare FROM g_sql      #預備一下
   DECLARE t403_cs                      #宣告成可捲動的
    SCROLL CURSOR WITH HOLD FOR t403_prepare
    
   LET g_sql= "SELECT  COUNT(DISTINCT rbe01||rbe02||rbe03||rbeplant) ",
              #FUN-AB0033 -------------start--------------
              "  FROM  rbe_file LEFT OUTER JOIN rbf_file b ",
              "      ON (b.rbf01=rbe01 AND b.rbf02=rbe02 AND b.rbf03=rbe03 AND b.rbfplant=rbeplant)",   #FUN-BC0078 add
              " LEFT OUTER JOIN rbg_file b ",
              "      ON (b.rbf01=b.rbg01 AND b.rbf02=b.rbg02 AND b.rbf03=b.rbg03 AND b.rbfplant=b.rbgplant ) ",
              #" WHERE  rbe01 = b.rbf01 ",
              #"   AND  rbe02 = b.rbf02 ",
              #"   AND  rbe03 = b.rbf03 ",
              #"   AND  rbeplant = b.rbfplant ",
              "  WHERE ",g_wc1 CLIPPED,
              #FUN-AB0033 --------------end---------------
              "   AND ", g_wc CLIPPED, " AND ", g_wc2 CLIPPED,
              " ORDER BY rbe01,rbe02,rbeplant "
   PREPARE t403_precount FROM g_sql
   DECLARE t403_count CURSOR FOR t403_precount 
END FUNCTION
 
FUNCTION t403_menu()
   DEFINE l_partnum    STRING
   DEFINE l_supplierid STRING
   DEFINE l_status     LIKE type_file.num10
 
   WHILE TRUE
      CALL t403_bp("G")
      CASE g_action_choice
         WHEN "insert"                  #新增
            IF cl_chk_act_auth() THEN
               CALL t403_a()
            END IF
 
         WHEN "query"                   #查詢
            IF cl_chk_act_auth() THEN
               CALL t403_q()
            END IF
 
         WHEN "delete"                  #刪除
            IF cl_chk_act_auth() THEN
               CALL t403_r()
            END IF
 
         WHEN "modify"                  #修改
            IF cl_chk_act_auth() THEN
               CALL t403_u()
            END IF
 
         WHEN "invalid"                #无效
            IF cl_chk_act_auth() THEN
               CALL t403_x()
            END IF 

         WHEN "detail"                 #單身
            IF cl_chk_act_auth() THEN
              #FUN-BC0078 mark START
              #IF g_flag_b = '1' THEN
              #   CALL t403_b1()
              #ELSE
              #   CALL t403_b2()
              #END IF
              #FUN-BC0078 mark START
               CALL t403_b()  #FUN-BC0078 add
            ELSE
               LET g_action_choice = NULL
            END IF 

         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
   
         WHEN "alter_organization"           #生效機構
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_rbe.rbe02) THEN
                  CALl t402_1(g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,'2',g_rbe.rbeplant,g_rbe.rbeconf)
               ELSE
                  CALL cl_err('',-400,0)
               END IF
            END IF

         WHEN "alter_memberlevel"           #會員等級促銷
            IF cl_chk_act_auth() THEN
              IF NOT cl_null(g_rbe.rbe02) THEN
                #IF g_rbe.rbe12t = 'Y' THEN        #MOD-AC0189  #FUN-BC0078 mark
                 IF g_rbe.rbe12t <> '0' THEN
                   #CALl t402_2(g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,'2',g_rbe.rbeplant,g_rbe.rbeconf,g_rbe.rbe10)  #FUN-BC0078 mark
                    CALl t402_2(g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,'2',g_rbe.rbeplant,
                                g_rbe.rbeconf,g_rbe.rbe10,g_rbe.rbe12t,'')  #FUN-BC0078 add #TQC-C20328 add '' 
                 ELSE
                    CALL cl_err('','art507',0)
                 END IF
              ELSE
                 CALL cl_err('',-400,0)
              END IF
            END IF

         WHEN "alter_gift"                  #換贈資料
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_rbe.rbe02) THEN
                  CALL t403_gift(g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,'2',g_rbe.rbeplant,g_rbe.rbeconf,g_rbe.rbe10)
               ELSE
                  CALL cl_err('',-400,0)
               END IF
            END IF
 
         WHEN "confirm"               #確認
            IF cl_chk_act_auth() THEN
               CALL t403_yes()  
            END IF
        
        #FUN-AB0033 mark --------------start-----------------
        #WHEN "void"                  #作廢
        #    IF cl_chk_act_auth() THEN
        #       CALL t403_v()
        #    END IF    
        
 
        #WHEN "issuance"              #發布
        #   IF cl_chk_act_auth() THEN
        #      CALL t403_iss()
        #   END IF
        #FUN-AB0033 mark ---------------end------------------

         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rbf),'','')
            END IF
            
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_rbe.rbe02 IS NOT NULL THEN
                 LET g_doc.column1 = "rbe02"
                 LET g_doc.value1 = g_rbe.rbe02
                 CALL cl_doc()
               END IF
         END IF         
      END CASE
   END WHILE     
END FUNCTION 
 
FUNCTION t403_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF 
   LET g_action_choice = " " 
   CALL cl_set_act_visible("accept,cancel", FALSE) 
   DIALOG ATTRIBUTES(UNBUFFERED)
#FUN-BC0078 add START
      DISPLAY ARRAY g_rbk TO s_rbk.*  ATTRIBUTE(COUNT=g_rec_b2)
   
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            LET g_b_flag='1'     #FUN-D30033 Add

         BEFORE ROW
            LET l_ac2 = ARR_CURR()
            CALL cl_show_fld_cont()
      END DISPLAY
#FUN-BC0078 add END
      DISPLAY ARRAY g_rbf TO s_rbf.* ATTRIBUTE(COUNT=g_rec_b1)
 
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            LET g_b_flag='2'   #FUN-D30033 Add

         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()
#FUN-BC0078 mark START 
#        ON ACTION insert
#           LET g_action_choice="insert"
#           EXIT DIALOG
#
#        ON ACTION query
#           LET g_action_choice="query"
#           EXIT DIALOG
#
#        ON ACTION delete
#           LET g_action_choice="delete"
#           EXIT DIALOG
#
#        ON ACTION modify
#           LET g_action_choice="modify"
#           EXIT DIALOG
#
#        ON ACTION first
#           CALL t403_fetch('F')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG
#
#        ON ACTION previous
#           CALL t403_fetch('P')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG
#
#        ON ACTION jump
#           CALL t403_fetch('/')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG
#
#        ON ACTION next
#           CALL t403_fetch('N')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG
#
#        ON ACTION last
#           CALL t403_fetch('L')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG
#
#        ON ACTION invalid
#           LET g_action_choice="invalid"
#           EXIT DIALOG 

#        ON ACTION detail
#           LET g_action_choice = "detail"
#           LET g_flag_b = '1'
#           LET l_ac1 = 1
#           EXIT DIALOG

#        ON ACTION help
#           LET g_action_choice = "help"
#           EXIT DIALOG

#        ON ACTION locale
#           CALL cl_dynamic_locale()
#           CALL cl_show_fld_cont()
#
#        ON ACTION exit
#           LET g_action_choice = "exit"
#           EXIT DIALOG
#     
#        ON ACTION alter_organization                #生效機構
#           LET g_action_choice =  "alter_organization" 
#           EXIT DIALOG

#        ON ACTION alter_memberlevel                 #會員促銷
#           LET g_action_choice = "alter_memberlevel"
#           EXIT DIALOG

#        ON ACTION alter_gift
#           LET g_action_choice = "alter_gift"
#           EXIT DIALOG

#        #FUN-AB0033 mark ----------start-----------   
#        #ON ACTION void
#        #   LET g_action_choice="void"
#        #   EXIT DIALOG
#        
#        #ON ACTION issuance                    #發布      
#        #   LET g_action_choice = "issuance"  
#        #   EXIT DIALOG
#        #FUN-AB0033 mark -----------end------------
#        
#        ON ACTION confirm
#           LET g_action_choice = "confirm"
#           EXIT DIALOG
#                                                                                                                          
#        ON ACTION controlg
#           LET g_action_choice="controlg"
#           EXIT DIALOG
#
#        ON ACTION accept
#           LET g_action_choice="detail"
#           LET g_flag_b = '1'
#           LET l_ac1 = ARR_CURR()
#           EXIT DIALOG
#
#        ON ACTION cancel
#           LET INT_FLAG=FALSE
#           LET g_action_choice="exit"
#           EXIT DIALOG
#
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE DIALOG
#
#        ON ACTION about 
#           CALL cl_about()
#
#        ON ACTION exporttoexcel
#           LET g_action_choice = 'exporttoexcel'
#           EXIT DIALOG
#
#        AFTER DISPLAY
#           CONTINUE DIALOG
#
#        ON ACTION controls       
#           CALL cl_set_head_visible("","AUTO")
#
#        ON ACTION related_document
#           LET g_action_choice="related_document"          
#           EXIT DIALOG
#FUN-BC0078 mark END
      END DISPLAY 
    
      DISPLAY ARRAY g_rbg TO s_rbg.* ATTRIBUTE(COUNT=g_rec_b2)
 
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            LET g_b_flag='3'    #FUN-D30033 Add

         BEFORE ROW
            LET l_ac2 = ARR_CURR()
            CALL cl_show_fld_cont()
#FUN-BC0078 mark START 
#        ON ACTION insert
#           LET g_action_choice="insert"
#           EXIT DIALOG
#
#        ON ACTION query
#           LET g_action_choice="query"
#           EXIT DIALOG
#
#        ON ACTION delete
#           LET g_action_choice="delete"
#           EXIT DIALOG
#
#        ON ACTION modify
#           LET g_action_choice="modify"
#           EXIT DIALOG
#
#        ON ACTION first
#           CALL t403_fetch('F')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG
#
#        ON ACTION previous
#           CALL t403_fetch('P')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG
#
#        ON ACTION jump
#           CALL t403_fetch('/')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG
#
#        ON ACTION next
#           CALL t403_fetch('N')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG
#
#        ON ACTION last
#           CALL t403_fetch('L')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG
#
#        ON ACTION invalid
#           LET g_action_choice="invalid"
#           EXIT DIALOG

#        ON ACTION detail
#           LET g_action_choice="detail"
#           LET g_flag_b = '2'
#           LET l_ac2 = 1
#           EXIT DIALOG
#
#        ON ACTION help
#           LET g_action_choice = "help"
#           EXIT DIALOG
#
#        ON ACTION locale
#           CALL cl_dynamic_locale()
#           CALL cl_show_fld_cont()
#
#        ON ACTION exit
#           LET g_action_choice = "exit"
#           EXIT DIALOG
#     
#        ON ACTION confirm
#           LET g_action_choice = "confirm"
#           EXIT DIALOG

#        ON ACTION alter_memberlevel                 #會員促銷
#           LET g_action_choice = "alter_memberlevel"
#           EXIT DIALOG
#                                                                                                                         
#        ON ACTION alter_organization          #生效機構
#           LET g_action_choice = "alter_organization" 
#           EXIT DIALOG

#        ON ACTION alter_gift
#           LET g_action_choice = "alter_gift"
#           EXIT DIALOG   

#        ON ACTION controlg
#           LET g_action_choice="controlg"
#           EXIT DIALOG
#
#        ON ACTION accept
#           LET g_action_choice="detail"
#           LET g_flag_b = '2'
#           LET l_ac2 = ARR_CURR()
#           EXIT DIALOG
#
#        #FUN-AB0033 mark ----------start-----------   
#        #ON ACTION void
#        #   LET g_action_choice="void"
#        #   EXIT DIALOG
#        
#        #ON ACTION issuance                    #發布      
#        #   LET g_action_choice = "issuance"  
#        #   EXIT DIALOG
#        #FUN-AB0033 mark -----------end------------

#        ON ACTION cancel
#           LET INT_FLAG=FALSE
#           LET g_action_choice="exit"
#           EXIT DIALOG
#
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE DIALOG
#
#        ON ACTION about 
#           CALL cl_about()
#
#        ON ACTION exporttoexcel
#           LET g_action_choice = 'exporttoexcel'
#           EXIT DIALOG
#
#        ON ACTION controls       
#           CALL cl_set_head_visible("","AUTO")
#
#        ON ACTION related_document
#           LET g_action_choice="related_document"          
#           EXIT DIALOG
#FUN-BC0078 mark END
      END DISPLAY 
#FUN-BC0078 add START

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
            CALL t403_fetch('F')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG

         ON ACTION previous
            CALL t403_fetch('P')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG

         ON ACTION jump
            CALL t403_fetch('/')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG

         ON ACTION next
            CALL t403_fetch('N')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG

         ON ACTION last
            CALL t403_fetch('L')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG

         ON ACTION invalid
            LET g_action_choice="invalid"
            EXIT DIALOG

         ON ACTION detail
            LET g_action_choice = "detail"
            LET g_flag_b = '1'
            LET l_ac1 = 1
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

         ON ACTION alter_organization                #生效機構
            LET g_action_choice =  "alter_organization"
            EXIT DIALOG

         ON ACTION alter_memberlevel                 #會員促銷
            LET g_action_choice = "alter_memberlevel"
            EXIT DIALOG

         ON ACTION alter_gift
            LET g_action_choice = "alter_gift"
            EXIT DIALOG

         #FUN-AB0033 mark ----------start-----------
         #ON ACTION void
         #   LET g_action_choice="void"
         #   EXIT DIALOG

         #ON ACTION issuance                    #發布
         #   LET g_action_choice = "issuance"
         #   EXIT DIALOG
         #FUN-AB0033 mark -----------end------------

         ON ACTION confirm
            LET g_action_choice = "confirm"
            EXIT DIALOG

         ON ACTION controlg
            LET g_action_choice="controlg"
            EXIT DIALOG

         ON ACTION accept
            LET g_action_choice="detail"
            LET g_flag_b = '1'
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
#FUN-BC0078 add END
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)  
END FUNCTION

#Query 查詢
FUNCTION t403_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   CALL cl_msg("")    
 
   CLEAR FORM
   CALL g_rbf.clear()
   #CALL cl_set_comp_visible("rbe28,rbe29,rbe30,rbe31",TRUE)
   #CALL cl_set_comp_visible("rbe15,rbe16,rbe17",TRUE)
   CALL t403_cs()                    #取得查詢條件
   IF INT_FLAG THEN                  #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN t403_cs                      #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_rbe.rbe02 TO NULL
   ELSE
      CALL t403_fetch('F')            #讀出TEMP第一筆並顯示
      OPEN t403_count
      FETCH t403_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
  END IF 
END FUNCTION
 
#處理資料的讀取
FUNCTION t403_fetch(p_flag)
    DEFINE  p_flag          LIKE type_file.chr1       #處理方式
    CALL cl_msg("")
    CASE p_flag
       WHEN 'N' FETCH NEXT     t403_cs INTO g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,g_rbe.rbeplant
       WHEN 'P' FETCH PREVIOUS t403_cs INTO g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,g_rbe.rbeplant
       WHEN 'F' FETCH FIRST    t403_cs INTO g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,g_rbe.rbeplant
       WHEN 'L' FETCH LAST     t403_cs INTO g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,g_rbe.rbeplant
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
          FETCH ABSOLUTE g_jump t403_cs INTO g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,g_rbe.rbeplant
          LET g_no_ask = FALSE
    END CASE 
    IF SQLCA.sqlcode THEN                         #有麻煩
        INITIALIZE g_rbe.* TO NULL 
        CALL cl_err(g_rbe.rbe01,SQLCA.sqlcode,0)
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
    SELECT * INTO g_rbe.* FROM rbe_file
     WHERE rbe01 = g_rbe.rbe01 AND rbe02 = g_rbe.rbe02 
       AND rbe03 = g_rbe.rbe03 AND rbeplant = g_rbe.rbeplant
    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_rbe.rbe01,SQLCA.sqlcode,0)
        INITIALIZE g_rbe.* TO NULL   
        RETURN
    END IF
    LET g_data_owner = g_rbe.rbeuser     
    LET g_data_group = g_rbe.rbegrup    
    LET g_data_plant = g_rbe.rbeplant 
    CALL t403_show() 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t403_show()
    DEFINE  l_gen02  LIKE gen_file.gen02
    DEFINE  l_azp02  LIKE azp_file.azp02
    DEFINE  l_raa03  LIKE raa_file.raa03
    LET g_rbe_t.* = g_rbe.*
    LET g_rbe_o.* = g_rbe.*
#    DISPLAY BY NAME g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe32,g_rbe.rbe03,g_rbe.rbeplant,g_rbe.rbemksg,g_rbe.rbe900,  #FUN-B30028 mark
     DISPLAY BY NAME g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe32,g_rbe.rbe03,g_rbe.rbeplant,                             #FUN-B30028
                   #g_rbe.rbeconf,g_rbe.rbecond,g_rbe.rbeconu,g_rbe.rbe22,g_rbe.rbe04,  #FUN-BC0078 mark
                   #g_rbe.rbe04t,g_rbe.rbe05,g_rbe.rbe05t,g_rbe.rbe06,g_rbe.rbe06t,g_rbe.rbe07,g_rbe.rbe07t,  #FUN-BC0078 mark
                    g_rbe.rbeconf,g_rbe.rbecond,g_rbe.rbeconu,g_rbe.rbe22,                        #FUN-BC0078 add
                    g_rbe.rbe10,g_rbe.rbe10t,g_rbe.rbe11,g_rbe.rbe11t,g_rbe.rbe12,g_rbe.rbe12t,g_rbe.rbe13,
                    g_rbe.rbe13t,g_rbe.rbe14,g_rbe.rbe14t,g_rbe.rbe15,g_rbe.rbe15t,g_rbe.rbe16,g_rbe.rbe16t,
                    g_rbe.rbe17,g_rbe.rbe17t,g_rbe.rbe18,g_rbe.rbe18t,g_rbe.rbe19,g_rbe.rbe19t,g_rbe.rbe20,
                    g_rbe.rbe20t,g_rbe.rbe21,g_rbe.rbe21t,g_rbe.rbe23,g_rbe.rbe23t,g_rbe.rbe24,g_rbe.rbe24t,
                   #g_rbe.rbe25,g_rbe.rbe25t,g_rbe.rbe26,g_rbe.rbe26t,g_rbe.rbe27,g_rbe.rbe27t,g_rbe.rbe28,  #FUN-BC0078 mark
                   #g_rbe.rbe28t,g_rbe.rbe29,g_rbe.rbe29t,g_rbe.rbe30,g_rbe.rbe30t,g_rbe.rbe31,g_rbe.rbe31t, #FUN-BC0078 mark
                    g_rbe.rbe25,g_rbe.rbe25t,g_rbe.rbe26,g_rbe.rbe26t,g_rbe.rbe27,g_rbe.rbe27t,   #FUN-BC0078 add
                    g_rbe.rbeuser,g_rbe.rbegrup,g_rbe.rbeoriu,g_rbe.rbemodu,g_rbe.rbedate,g_rbe.rbeorig,
                    g_rbe.rbeacti,g_rbe.rbecrat
    #CALL cl_set_comp_visible("rbe28,rbe29,rbe30,rbe31",g_rbe.rbe27='Y')
    #CALL cl_set_comp_visible("rbe15,rbe16,rbe17",g_rbe.rbe11='N')
    SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rbe.rbe01
    DISPLAY l_azp02 TO FORMONLY.rbe01_desc
    SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_reb.rbeplant
    DISPLAY l_azp02 TO FORMONLY.rbeplant_desc
    SELECT raa03 INTO l_raa03 FROM raa_file WHERE raa01 = g_rbe.rbe01 AND raa02 = g_rbe.rbe32
    DISPLAY l_raa03 TO FORMONLY.rbe32_desc
    SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_rbe.rbeconu
    DISPLAY l_gen02 TO FORMONLY.rbeconu_desc
    IF NOT g_rbe.rbeconf='X' THEN LET g_chr='N' END IF 
    IF g_rbe.rbeconf='I' OR g_rbe.rbeconf='Y' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF 
    CALL cl_set_field_pic(g_chr2,"","","",g_chr,"")   
    CALL cl_set_act_visible("alter_gift",g_rbe.rbe27t='Y')    
    CALL t403_b1_fill(g_wc1)          #單身1
    CALL t403_b2_fill(g_wc2)          #單身2
    CALL t403_b3_fill(g_wc2) #FUN-BC0078 add
    CALL cl_show_fld_cont()          
END FUNCTION
 
FUNCTION t403_b1_fill(p_wc1)              #單身1
    DEFINE p_wc1        STRING 
    LET g_sql = " SELECT '',a.rbf05,a.rbf06,a.rbf07,a.rbf08,a.rbfacti,",
                "           b.rbf05,b.rbf06,b.rbf07,b.rbf08,b.rbfacti ",
                "   FROM rbf_file b LEFT OUTER JOIN rbf_file a",
                "     ON (b.rbf01=a.rbf01 AND b.rbf02=a.rbf02 AND b.rbf03=a.rbf03 AND ",
                "         b.rbf04=a.rbf04 AND b.rbf06=a.rbf06 AND b.rbfplant=a.rbfplant AND b.rbf05<>a.rbf05 ) ",
                "  WHERE b.rbf01 = '",g_rbe.rbe01, "' AND b.rbfplant='",g_rbe.rbeplant,"'",
                "    AND b.rbf05='1' ",  
                "    AND b.rbf02 = '",g_rbe.rbe02, "' AND b.rbf03=",g_rbe.rbe03," AND ", p_wc1 CLIPPED,
                "  ORDER BY b.rbf04 " 
    PREPARE t403_b1_prepare FROM g_sql                     #預備一下
    DECLARE rbf_cs CURSOR FOR t403_b1_prepare
    CALL g_rbf.clear()
    LET g_rec_b1 = 0
    LET g_cnt = 1
    FOREACH rbf_cs INTO g_rbf[g_cnt].*
        IF SQLCA.sqlcode THEN
           CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
 
        IF g_rbf[g_cnt].before='0' THEN
           LET g_rbf[g_cnt].type='1'
        ELSE 
           LET g_rbf[g_cnt].type='0'
        END IF
       
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_rbf.deleteElement(g_cnt)
    CALL cl_set_comp_entry("type",FALSE) 
    LET g_rec_b1 = g_cnt-1
    DISPLAY g_rec_b1 TO FORMONLY.cn1
END FUNCTION
 
FUNCTION t403_b2_fill(p_wc2)              #單身2
    DEFINE p_wc2          STRING 
    LET g_sql = " SELECT '',a.rbg05,a.rbg06,a.rbg07,a.rbg08,'',a.rbg09,'',a.rbgacti, ",
                "           b.rbg05,b.rbg06,b.rbg07,b.rbg08,'',b.rbg09,'',b.rbgacti  ",
                "   FROM rbg_file b LEFT OUTER JOIN rbg_file a",
                "     ON (b.rbg01=a.rbg01 AND b.rbg02=a.rbg02 AND b.rbg03=a.rbg03 AND b.rbg04=a.rbg04 AND ",
                "         b.rbg06=a.rbg06 AND b.rbg07=a.rbg07 AND b.rbgplant=a.rbgplant AND b.rbg05<>a.rbg05 ) ",
                "  WHERE b.rbg01 = '",g_rbe.rbe01, "' AND b.rbgplant='",g_rbe.rbeplant,"'",
                "    AND b.rbg05='1'  ", 
                "    AND b.rbg02 = '",g_rbe.rbe02, "' AND b.rbg03=",g_rbe.rbe03," AND ", p_wc2 CLIPPED,
                "  ORDER BY b.rbg04 " 
    PREPARE t403_b2_prepare FROM g_sql                     #預備一下
    DECLARE rbg_cs CURSOR FOR t403_b2_prepare
    CALL g_rbg.clear()
    LET g_rec_b2 = 0
    LET g_cnt = 1
    FOREACH rbg_cs INTO g_rbg[g_cnt].*
        IF SQLCA.sqlcode THEN
           CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
 
        IF g_rbg[g_cnt].before1='0' THEN
           LET g_rbg[g_cnt].type1='1'
        ELSE 
           LET g_rbg[g_cnt].type1='0'
        END IF
        SELECT gfe02 INTO g_rbg[g_cnt].rbg09_desc FROM gfe_file
           WHERE gfe01 = g_rbg[g_cnt].rbg09
        SELECT gfe02 INTO g_rbg[g_cnt].rbg09_1_desc FROM gfe_file
           WHERE gfe01 = g_rbg[g_cnt].rbg09  
        CALL t403_rbg08('d',g_cnt)
        CALL t403_rbg08_1('d',g_cnt)            
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_rbg.deleteElement(g_cnt)
    CALL cl_set_comp_entry("type1",FALSE) 
    LET g_rec_b2 = g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cn2
END FUNCTION

FUNCTION t403_a()
    DEFINE l_n    LIKE  type_file.num5  
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_rbf.clear()
    CALL g_rbg.clear()
    CALL g_rbk.clear()  #FUN-BC0078 add

    INITIALIZE g_rbe.* LIKE rbe_file.*               #DEFAULT 設定
    INITIALIZE g_rbe_t.* LIKE rbe_file.*             #DEFAULT 設定
    INITIALIZE g_rbe_o.* LIKE rbe_file.*             #DEFAULT 設定
    LET g_rbe.rbe01 = g_plant 
    CALL cl_opmsg('a')
    WHILE TRUE      
     #FUN-BC0078 mark START 
     #LET g_rbe.rbe04 = g_today        #促銷開始日期
     #LET g_rbe.rbe05 = g_today        #促銷結束日期
     #LET g_rbe.rbe06 = '00:00:00'     #促銷開始時間
     #LET g_rbe.rbe07 = '23:59:59'     #促銷結束時間
     #FUN-BC0078 mark END
      LET g_rbe.rbe10 = '1'
      LET g_rbe.rbe11 = 'N'
      LET g_rbe.rbe12 = 'N'
      LET g_rbe.rbe13 = 'N'
      LET g_rbe.rbe14 = 'Y'
      LET g_rbe.rbe15 = 0               #特賣價
      #LET g_rbe.rbe16 = 0               #折扣率%
      LET g_rbe.rbe17 = 0               #折讓額
      LET g_rbe.rbe18 = 0               #會員特賣價
      #LET g_rbe.rbe19 = 0               #會員折扣率%
      LET g_rbe.rbe20 = 0               #會員折讓額 
      LET g_rbe.rbe21 = 0               #組合總量
     #FUN-BC0078 mark START
     #LET g_rbe.rbe04t = g_today        #促銷開始日期
     #LET g_rbe.rbe05t = g_today        #促銷結束日期
     #LET g_rbe.rbe06t = '00:00:00'     #促銷開始時間
     #LET g_rbe.rbe07t = '23:59:59'     #促銷結束時間
     #FUN-BC0078 mark END
      LET g_rbe.rbe10t = '1'
      LET g_rbe.rbe11t = 'N'
      LET g_rbe.rbe12t = 'N'
      LET g_rbe.rbe13t = 'N'
      LET g_rbe.rbe14t = 'Y'
      LET g_rbe.rbe15t = 0          #特賣價
      #LET g_rbe.rbe16t = 0          #折扣率%
      LET g_rbe.rbe17t = 0          #折讓額
      LET g_rbe.rbe18t = 0          #會員特賣價
      #LET g_rbe.rbe19t = 0          #會員折扣率%
      LET g_rbe.rbe20t = 0          #會員折讓額 
      LET g_rbe.rbe21t = 0          #組合總量

      LET g_rbe.rbe08 = 'N'    #no use
      LET g_rbe.rbe09 = 'N'    #no use
      LET g_rbe.rbe08t = 'N'   #no use
      LET g_rbe.rbe09t = 'N'   #no use        

      LET g_rbe.rbe23 = 'N'
      LET g_rbe.rbe24 = 'N'
      LET g_rbe.rbe25 = 'N'
      LET g_rbe.rbe26 = 'N'
      LET g_rbe.rbe27 = 'N'
     #FUN-BC0078 mark START
     #LET g_rbe.rbe28 = '1'
     #LET g_rbe.rbe29 = '1'
     #LET g_rbe.rbe30 = '1'
     #LET g_rbe.rbe31 =  1
     #FUN-BC0078 mark END
      LET g_rbe.rbe23t = 'N'
      LET g_rbe.rbe24t = 'N'
      LET g_rbe.rbe25t = 'N'
      LET g_rbe.rbe26t = 'N'
      LET g_rbe.rbe27t = 'N'
     #FUN-BC0078 mark START
     #LET g_rbe.rbe28t = '1'
     #LET g_rbe.rbe29t = '1'
     #LET g_rbe.rbe30t = '1'
     #LET g_rbe.rbe31t =  1
     #FUN-BC0078 mark END 
      LET g_rbe.rbe900   = '0'
      LET g_rbe.rbeconf  = 'N'
      LET g_rbe.rbemksg  = 'N'
      LET g_rbe.rbeacti  = 'Y'
      LET g_rbe.rbeuser  = g_user
      LET g_rbe.rbeoriu  = g_user  
      LET g_rbe.rbeorig  = g_grup  
      LET g_rbe.rbegrup  = g_grup
      LET g_rbe.rbecrat  = g_today
      LET g_rbe.rbeplant = g_plant
      LET g_rbe.rbelegal = g_legal
      LET g_data_plant   = g_plant     
     #FUN-BC0078 add START
      IF cl_null(g_rbe.rbe28) THEN LET g_rbe.rbe28 = ' ' END IF
      IF cl_null(g_rbe.rbe29) THEN LET g_rbe.rbe29 = ' ' END IF
      IF cl_null(g_rbe.rbe30) THEN LET g_rbe.rbe30 = ' ' END IF
      IF cl_null(g_rbe.rbe31) THEN LET g_rbe.rbe31 = ' ' END IF
      IF cl_null(g_rbe.rbe28t) THEN LET g_rbe.rbe28t = ' ' END IF
      IF cl_null(g_rbe.rbe29t) THEN LET g_rbe.rbe29t = ' ' END IF
      IF cl_null(g_rbe.rbe30t) THEN LET g_rbe.rbe30t = ' ' END IF
      IF cl_null(g_rbe.rbe31t) THEN LET g_rbe.rbe31t = ' ' END IF
     #FUN-BC0078 add END 
 
      SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rbe.rbe01
      DISPLAY l_azp02 TO rbe01_desc
      SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_reb.rbeplant
      DISPLAY l_azp02 TO rbeplant_desc
        
      CALL t403_i("a")                   #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_rbe.* TO NULL
         LET INT_FLAG = 0
         EXIT WHILE
      END IF
      IF cl_null(g_rbe.rbe02) THEN
         CONTINUE WHILE
      END IF
      BEGIN WORK
         INSERT INTO rbe_file VALUES(g_rbe.*)
         IF SQLCA.sqlcode THEN
         #   ROLLBACK WORK       # FUN-B80085---回滾放在報錯後---
            CALL cl_err3("ins","rbe_file",g_rbe.rbe02,"",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK        # FUN-B80085--add--
            CONTINUE WHILE
         END IF

      SELECT * INTO g_rbe.* FROM rbe_file
       WHERE rbe01 = g_rbe.rbe01 AND rbe02 = g_rbe.rbe02
         AND rbe03 = g_rbe.rbe03 AND rbeplant = g_rbe.rbeplant
        LET g_rbe_t.* = g_rbe.*
        LET g_rbe_o.* = g_rbe.*
        CALL cl_set_act_visible("alter_gift",g_rbe.rbe27t='Y')
        #CALl t402_1(g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,'2',g_rbe.rbeplant,g_rbe.rbeconf) #FUN-AB0033 mark
        CALL g_rbf.clear()
        CALL g_rbg.clear()
        CALL g_rbk.clear()  #FUN-BC0078 add
        LET g_rec_b1 = 0
        LET g_rec_b2 = 0  
        LET g_rec_b3 = 0   #FUN-BC0078 add
       #FUN-BC0078 mark START
       #CALL t403_b1()
       #CALL t403_b2() 
       #FUN-BC0078 mark END
        CALL t403_b()   #FUN-BC0078 add
        EXIT WHILE
    END WHILE
END FUNCTION
#單頭
FUNCTION t403_i(p_cmd)
    DEFINE     p_cmd           LIKE type_file.chr1,    #a:輸入 u:更改  
               l_cmd           LIKE type_file.chr1000, 
               l_rbe03         LIKE type_file.num5,    #變更序號
               l_n             LIKE type_file.num5 
    DEFINE     l_date          LIKE rbe_file.rbe04
    DEFINE     l_time1         LIKE type_file.num5
    DEFINE     l_time2         LIKE type_file.num5
    DEFINE     l_price         LIKE rbe_file.rbe15
    DEFINE     l_discount      LIKE rbe_file.rbe16
    
    CALL cl_set_head_visible("","YES") 
#FUN-B30028 --------------STA
#   DISPLAY BY NAME g_rbe.rbe01,g_rbe.rbeplant,g_rbe.rbe900,g_rbe.rbeconf,
#                   g_rbe.rbemksg,g_rbe.rbeoriu,g_rbe.rbeorig,g_rbe.rbeuser,
    DISPLAY BY NAME g_rbe.rbe01,g_rbe.rbeplant,g_rbe.rbeconf,
                    g_rbe.rbeoriu,g_rbe.rbeorig,g_rbe.rbeuser, 
#FUN-B30028 --------------END
                    g_rbe.rbegrup,g_rbe.rbecrat,g_rbe.rbeacti    
#    INPUT BY NAME g_rbe.rbe02,g_rbe.rbemksg,g_rbe.rbe04t,g_rbe.rbe05t,g_rbe.rbe06t,   #FUN-B30028 mark
    #INPUT BY NAME g_rbe.rbe02,g_rbe.rbe04t,g_rbe.rbe05t,g_rbe.rbe06t,                 #FUN-B30028     #FUN-BC0078 mark  
    #             g_rbe.rbe07t,g_rbe.rbe10t,g_rbe.rbe11t,g_rbe.rbe12t,g_rbe.rbe13t,    #FUN-BC0078 mark
     INPUT BY NAME g_rbe.rbe02,g_rbe.rbe10t,g_rbe.rbe11t,g_rbe.rbe12t,g_rbe.rbe13t,               #FUN-BC0078 add 
                   g_rbe.rbe14t,g_rbe.rbe15t,g_rbe.rbe16t,g_rbe.rbe17t,g_rbe.rbe18t,
                   g_rbe.rbe19t,g_rbe.rbe20t,g_rbe.rbe21t,g_rbe.rbe23t,g_rbe.rbe24t,
                  #g_rbe.rbe25t,g_rbe.rbe26t,g_rbe.rbe27t,g_rbe.rbe28t,g_rbe.rbe29t,  #FUN-BC0078 mark
                  #g_rbe.rbe30t,g_rbe.rbe31t                                          #FUN-BC0078 mark
                   g_rbe.rbe25t,g_rbe.rbe26t,g_rbe.rbe27t      #FUN-BC0078 add
                   WITHOUT DEFAULTS
                  
        BEFORE INPUT
           CALL cl_set_docno_format("rbe02")
           LET  g_before_input_done = FALSE
           CALL t403_set_entry(p_cmd)
           CALL t403_set_no_entry(p_cmd)
           CALL t403_rbe10t_entry(g_rbe.rbe10t)
           LET  g_before_input_done = TRUE
          #CALL cl_set_comp_entry("rbe31t",g_rbe.rbe30t<>'1')  #FUN-BC0078 mark
           #CALL cl_set_comp_visible("rbe28t,rbe29t,rbe30t,rbe31t",g_rbe.rbe27t='Y')
           #CALL cl_set_comp_visible("rbe15t,rbe16t,rbe17t",g_rbe.rbe11t='N')
 
        AFTER FIELD rbe02                   #促銷單號
            IF NOT cl_null(g_rbe.rbe02) THEN
               IF cl_null(g_rbe_t.rbe02) OR (g_rbe.rbe02 != g_rbe_t.rbe02) THEN
                  CALL t403_rbe02()  
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_rbe.rbe02,g_errno,0)
                     NEXT FIELD rbe02
                  END IF
               END IF
            ELSE
               NEXT FIELD rbe02t
            END IF
        #FUN-AB0033 mark ------------start-----------------    
        #AFTER FIELD rbe04t,rbe05t  #開始,結束日期
        #   LET l_date = FGL_DIALOG_GETBUFFER()
        #   IF p_cmd='a' OR (p_cmd='u' AND 
        #      (DATE(l_date)<>g_rbe_t.rbe04t OR DATE(l_date)<>g_rbe_t.rbe05t)) THEN 
        #       IF INFIELD(rbe04t) THEN
        #          IF NOT cl_null(g_rbe.rbe05t) THEN
        #             IF DATE(l_date)>g_rbe.rbe05t THEN
        #                CALL cl_err('','art-201',0)
        #                NEXT FIELD rbe04t
        #             END IF
        #          END IF
        #       END IF
        #       IF INFIELD(rbe05t) THEN
        #          IF NOT cl_null(g_rbe.rbe04t) THEN
        #             IF DATE(l_date)<g_rbe.rbe04t THEN
        #                CALL cl_err('','art-201',0)
        #                NEXT FIELD rbe05t
        #             END IF
        #          END IF
        #       END IF 
        #   END IF
        #FUN-AB0033 mark -------------end------------------    
     #FUN-BC0078 mark START
     # AFTER FIELD rbe06t  #開始時間
     #   IF NOT cl_null(g_rbe.rbe06t) THEN
     #      IF p_cmd = "a" OR                    
     #             (p_cmd = "u" AND g_rbe.rbe06t<>g_rbe_t.rbe06t) THEN 
     #         CALL t403_chktime(g_rbe.rbe06t) RETURNING l_time1
     #         IF NOT cl_null(g_errno) THEN
     #             CALL cl_err('',g_errno,0)
     #             NEXT FIELD rbe06t
     #         ELSE
     #           IF NOT cl_null(g_rbe.rbe07t) THEN
     #              CALL t403_chktime(g_rbe.rbe07t) RETURNING l_time2
     #              IF l_time1>=l_time2 THEN
     #                 CALL cl_err('','art-207',0)
     #                 NEXT FIELD rbe06t   
     #              END IF
     #           END IF
     #         END IF
     #       END IF
     #   END IF
     #   
     # AFTER FIELD rbe07t  #結束時間
     #   IF NOT cl_null(g_rbe.rbe07t) THEN
     #      IF p_cmd = "a" OR                    
     #             (p_cmd = "u" AND g_rbe.rbe07<>g_rbe_t.rbe07t) THEN 
     #          CALL t403_chktime(g_rbe.rbe07) RETURNING l_time2
     #          IF NOT cl_null(g_errno) THEN
     #             CALL cl_err('',g_errno,0)
     #             NEXT FIELD rbe07t
     #          ELSE
     #             IF NOT cl_null(g_rbe.rbe06t) THEN
     #                CALL t403_chktime(g_rbe.rbe06t) RETURNING l_time1
     #                IF l_time1>=l_time2 THEN
     #                   CALL cl_err('','art-207',0)
     #                   NEXT FIELD rbe07t
     #                END IF
     #             END IF
     #          END IF
     #      END IF
     #   END IF    
     #FUN-BC0078 mark END

        AFTER FIELD rbe10t
         IF NOT cl_null(g_rbe.rbe10t) THEN
            IF g_rbe_o.rbe10t IS NULL OR
               (g_rbe.rbe10t != g_rbe_o.rbe10t ) THEN
               IF g_rbe.rbe10t NOT MATCHES '[123]' THEN
                  LET g_rbe.rbe10t = g_rbe_o.rbe10t
                  NEXT FIELD rbe10t
               ELSE
                  CALL t403_rbe10t_entry(g_rbe.rbe10t)
               END IF
            END IF
         END IF 

        ON CHANGE rbe10t
           IF NOT cl_null(g_rbe.rbe10t) THEN
              CALL t403_rbe10t_entry(g_rbe.rbe10t)
           END IF

        ON CHANGE rbe11t    #是否會員專享
           IF NOT cl_null(g_rbe.rbe11t) THEN
              CALL t403_rbe10t_entry(g_rbe.rbe10t)
           END IF 

        ON CHANGE rbe12t
           IF NOT cl_null(g_rbe.rbe12t) THEN
              CALL t403_rbe10t_entry(g_rbe.rbe10t)
             #FUN-BC0078 add START
              IF (g_rbe.rbe12t <> g_rbe.rbe12 AND g_rbe.rbe12 <> '0') THEN
                  LET l_n = 0
                  SELECT COUNT(*) INTO l_n FROM rap_file
                    WHERE rap01 = g_rbe.rbe01 AND rap02 = g_rbe.rbe02
                      AND rap03 = '2' AND rap09 = g_rbe.rbe12
                      AND rapplant = g_rbe.rbeplant
                   IF l_n > 0 THEN
                      IF NOT cl_confirm('art-789') THEN
                        LET g_rbe.rbe12t = g_rbe.rbe12
                        NEXT FIELD rbe12t
                      ELSE
                        CALL t403_rbp()
                      END IF
                  END IF
              ELSE
                 CALL t403_delrbp()
              END IF
             #FUN-BC0078 add END
           END IF 

       #BEFORE FIELD rbe05t,rbe06t,rbe07t,rbe10t,rbe11t   #FUN-BC0078 mark
        BEFORE FIELD rbe10t,rbe11t  #FUN-BC0078 add
           IF NOT cl_null(g_rbe.rbe10t) THEN
              CALL t403_rbe10t_entry(g_rbe.rbe10t)
           END IF 

        AFTER FIELD rbe15t,rbe18t    #特賣價
           LET l_price = FGL_DIALOG_GETBUFFER()
           IF l_price <= 0 THEN
              CALL cl_err('','art-180',0)
              NEXT FIELD CURRENT
           ELSE
              DISPLAY BY NAME g_rbe.rbe15t,g_rbe.rbe18t
           END IF

        AFTER FIELD rbe16t,rbe19t   #折扣率
           LET l_discount = FGL_DIALOG_GETBUFFER()
           IF l_discount < 0 OR l_discount > 100 THEN
              CALL cl_err('','atm-384',0)
              NEXT FIELD CURRENT
           ELSE
              DISPLAY BY NAME g_rbe.rbe16t,g_rbe.rbe19t
           END IF

       AFTER FIELD rbe17t,rbe20t    #折讓額
          LET l_price = FGL_DIALOG_GETBUFFER()
          IF l_price <= 0 THEN
             CALL cl_err('','art-653',0)
             NEXT FIELD CURRENT
          ELSE
             DISPLAY BY NAME g_rbe.rbe17t,g_rbe.rbe20t
          END IF  

       AFTER FIELD rbe21t  #組合數量
          IF NOT cl_null(g_rbe.rbe21t) THEN
             IF p_cmd = "a" OR                    
                (p_cmd = "u" AND g_rbe.rbe21t<>g_rbe_t.rbe21t) THEN 
                 IF g_rbe.rbe21t<0 THEN          
                    CALL cl_err('','aem-042',0)              
                    NEXT FIELD rbe21t
                 END IF
                 CALL t403_rbe21t_check()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_rbe.rbe21t,g_errno,0)
                    NEXT FIELD rbe21t
                 END IF
              END IF
           END IF

     #FUN-BC0078 mark START
     #ON CHANGE rbe27t
     #   IF NOT cl_null(g_rbe.rbe27t) THEN
     #      CALL cl_set_comp_visible("rbe28t,rbe29t,rbe30t,rbe31t",g_rbe.rbe27t='Y')
     #   END IF
 
     #ON CHANGE rbe30t
     #   IF NOT cl_null(g_rbe.rbe30t) THEN
     #      IF g_rbe.rbe30t='1' THEN
     #         LET g_rbe.rbe31t=1
     #         CALL cl_set_comp_entry("rbe31t",FALSE)
     #         DISPLAY BY NAME g_rbe.rbe31t
     #      ELSE 
     #         LET g_rbe.rbe31t=2
     #         CALL cl_set_comp_entry("rbe31t",TRUE)
     #         DISPLAY BY NAME g_rbe.rbe31t
     #      END IF
     #   END IF

     #BEFORE FIELD rbe31t
     #   IF NOT cl_null(g_rbe.rbe30t) THEN
     #      IF g_rbe.rbe30t='1' THEN
     #         LET g_rbe.rbe31t=1
     #         CALL cl_set_comp_entry("rbe31t",FALSE)
     #         DISPLAY BY NAME g_rbe.rbe31t
     #      ELSE
     #         LET g_rbe.rbe31t=2
     #         CALL cl_set_comp_entry("rbe31t",TRUE)
     #         DISPLAY BY NAME g_rbe.rbe31t
     #      END IF
     #   END IF

     # AFTER FIELD rbe31t
     #    IF NOT cl_null(g_rbe.rbe31t) THEN
     #       IF g_rbe.rbe31t<=1 THEN
     #          CALL cl_err('','art-659',0)
     #          NEXT FIELD rbe31t
     #       END IF
     #    END IF    
     #FUN-BC0078 mark END 
     
      AFTER INPUT
         LET g_rbe.rbeuser = s_get_data_owner("rbe_file") #FUN-C10039
         LET g_rbe.rbegrup = s_get_data_group("rbe_file") #FUN-C10039
         LET l_flag='N'
         IF INT_FLAG THEN
            EXIT INPUT
         END IF 
         IF l_flag='Y' THEN
             CALL cl_err('','9033',0)
             NEXT FIELD rbe02
         END IF
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         CALL t403_delrbp()   #FUN-BC0078 add
             
         #FUN-AB0033 add ----------------start-------------------
        #FUN-BC0078 mark START
        #IF NOT cl_null(g_rbe.rbe04t) AND NOT cl_null(g_rbe.rbe05t) THEN
        #   IF g_rbe.rbe04t > g_rbe.rbe05t THEN
        #      CALL cl_err('','art-201',0)
        #      NEXT FIELD rbe04t
        #   END IF
        #END IF
        #FUN-BC0078 mark END
         #FUN-AB0033 add -----------------end--------------------
            
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add 
 
        ON ACTION CONTROLP
           CASE   
                WHEN INFIELD(rbe02) #查詢符合條件的單號
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_rae02"
                     CALL cl_create_qry() RETURNING g_rbe.rbe02
                     DISPLAY BY NAME g_rbe.rbe02                     
                     NEXT FIELD rbe02                  
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

FUNCTION t403_rbe02()
   DEFINE l_rae03   LIKE  rae_file.rae03
   DEFINE l_rae04   LIKE  rae_file.rae04
   DEFINE l_rae05   LIKE  rae_file.rae05
   DEFINE l_rae06   LIKE  rae_file.rae06
   DEFINE l_rae07   LIKE  rae_file.rae07
   DEFINE l_rae10   LIKE  rae_file.rae10
   DEFINE l_rae11   LIKE  rae_file.rae11
   DEFINE l_rae12   LIKE  rae_file.rae12
   DEFINE l_rae13   LIKE  rae_file.rae13
   DEFINE l_rae14   LIKE  rae_file.rae14
   DEFINE l_rae15   LIKE  rae_file.rae15
   DEFINE l_rae16   LIKE  rae_file.rae16
   DEFINE l_rae17   LIKE  rae_file.rae17
   DEFINE l_rae18   LIKE  rae_file.rae18
   DEFINE l_rae19   LIKE  rae_file.rae19
   DEFINE l_rae20   LIKE  rae_file.rae20
   DEFINE l_rae21   LIKE  rae_file.rae21
   DEFINE l_rae22   LIKE  rae_file.rae22
   DEFINE l_rae23   LIKE  rae_file.rae23
   DEFINE l_rae24   LIKE  rae_file.rae24
   DEFINE l_rae25   LIKE  rae_file.rae25
   DEFINE l_rae26   LIKE  rae_file.rae26
   DEFINE l_rae27   LIKE  rae_file.rae27
   DEFINE l_rae28   LIKE  rae_file.rae28
   DEFINE l_rae29   LIKE  rae_file.rae29
   DEFINE l_rae30   LIKE  rae_file.rae30
   DEFINE l_rae31   LIKE  rae_file.rae31
   DEFINE l_raeconf LIKE  rae_file.raeconf
   DEFINE l_raeacti LIKE  rae_file.raeacti
   DEFINE l_n       LIKE type_file.num5 
   DEFINE l_n1      LIKE type_file.num5
   DEFINE l_raa03   LIKE raa_file.raa03 
   
   LET g_errno = ''
   LET l_n1 = 0
   SELECT rae03,rae04,rae05,rae06,rae07,rae10,rae11,rae12,rae13,rae14,
          rae15,rae16,rae17,rae18,rae19,rae20,rae21,rae22,rae23,rae24,rae25,
          rae26,rae27,rae28,rae29,rae30,rae31,raeconf,raeacti
     INTO l_rae03,l_rae04,l_rae05,l_rae06,l_rae07,l_rae10,l_rae11,l_rae12,
          l_rae13,l_rae14,l_rae15,l_rae16,l_rae17,l_rae18,l_rae19,l_rae20,
          l_rae21,l_rae22,l_rae23,l_rae24,l_rae25,l_rae26,l_rae27,l_rae28,
          l_rae29,l_rae30,l_rae31,l_raeconf,l_raeacti
     FROM rae_file
    WHERE rae01=g_rbe.rbe01 AND rae02=g_rbe.rbe02 AND raeplant=g_rbe.rbeplant     
  CASE                          
     WHEN SQLCA.sqlcode=100   LET g_errno='art-196'  
     WHEN l_raeacti='N'       LET g_errno='9028'    
     WHEN l_raeconf<>'Y'      LET g_errno='art-195' 
    OTHERWISE   
    LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE 
  
  SELECT MAX(rbe03) INTO l_n FROM rbe_file
   WHERE rbe01=g_rbe.rbe01 AND rbe02=g_rbe.rbe02 AND rbeplant=g_rbe.rbeplant
  IF cl_null(l_n) OR l_n=0 THEN
     LET g_rbe.rbe03=1 
  ELSE 
     LET g_rbe.rbe03=l_n+1 
  END IF
 
  IF cl_null(g_errno) THEN 
     SELECT COUNT(*) INTO l_n1 FROM rbe_file 
      WHERE rbe01=g_rbe.rbe01 
        AND rbe02=g_rbe.rbe02 
        AND rbe03<g_rbe.rbe03
        #AND rbeconf NOT IN('I','X') #FUN-AB0033 mark
        AND rbeconf = 'N'  #FUN-AB0033 add
        AND rbeplant=g_rbe.rbeplant
     IF l_n1 > 0 THEN
        LET g_errno='art-682'
        RETURN
     END IF 
     
     #TQC-AC0326 add --------------------begin---------------------
     LET l_n1 = 0
     SELECT COUNT(*) INTO l_n1 FROM raq_file 
      WHERE raq01=g_rbe.rbe01 AND raq02=g_rbe.rbe02 AND raqplant=g_rbe.rbeplant 
      AND raq03='2' AND raqacti='Y' AND raq05='N'
     IF l_n1 > 0 THEN
        LET g_errno='art-999'
        RETURN
     END IF
     #TQC-AC0326 add ---------------------end----------------------
     
     LET g_rbe.rbe32 = l_rae03
    #FUN-BC0078 mark START
    #LET g_rbe.rbe04 = l_rae04
    #LET g_rbe.rbe05 = l_rae05
    #LET g_rbe.rbe06 = l_rae06
    #LET g_rbe.rbe07 = l_rae07
    #FUN-BC0078 mark END
     LET g_rbe.rbe10 = l_rae10
     LET g_rbe.rbe11 = l_rae11
     LET g_rbe.rbe12 = l_rae12
     LET g_rbe.rbe13 = l_rae13
     LET g_rbe.rbe14 = l_rae14
     LET g_rbe.rbe15 = l_rae15
     LET g_rbe.rbe16 = l_rae16
     LET g_rbe.rbe17 = l_rae17
     LET g_rbe.rbe18 = l_rae18
     LET g_rbe.rbe19 = l_rae19
     LET g_rbe.rbe20 = l_rae20
     LET g_rbe.rbe21 = l_rae21
     LET g_rbe.rbe22 = l_rae22
     LET g_rbe.rbe23 = l_rae23
     LET g_rbe.rbe24 = l_rae24
     LET g_rbe.rbe25 = l_rae25
     LET g_rbe.rbe26 = l_rae26
     LET g_rbe.rbe27 = l_rae27
    #FUN-BC0078 mark START
    #LET g_rbe.rbe28 = l_rae28
    #LET g_rbe.rbe29 = l_rae29
    #LET g_rbe.rbe30 = l_rae30
    #LET g_rbe.rbe31 = l_rae31
    #FUN-BC0078 mark END
    #FUN-C60041 -----------STA
     LET g_rbe.rbe28 = l_rae28
     LET g_rbe.rbe29 = l_rae29
     LET g_rbe.rbe31 = l_rae31
    #FUN-C60041 -----------END
    #DISPLAY BY NAME g_rbe.rbe32,g_rbe.rbe03,g_rbe.rbe04,g_rbe.rbe05,g_rbe.rbe06,  #FUN-BC0078 mark 
    #                g_rbe.rbe07,g_rbe.rbe10,g_rbe.rbe11,g_rbe.rbe12,g_rbe.rbe13,  #FUN-BC0078 mark
     DISPLAY BY NAME g_rbe.rbe32,g_rbe.rbe03,g_rbe.rbe10,g_rbe.rbe11,g_rbe.rbe12,g_rbe.rbe13,    #FUN-BC0078 add
                     g_rbe.rbe14,g_rbe.rbe15,g_rbe.rbe16,g_rbe.rbe17,g_rbe.rbe18,
                     g_rbe.rbe19,g_rbe.rbe20,g_rbe.rbe21,g_rbe.rbe22,g_rbe.rbe23,
                     g_rbe.rbe24,g_rbe.rbe25,g_rbe.rbe26,g_rbe.rbe27
                    #g_rbe.rbe28, g_rbe.rbe29,g_rbe.rbe30,g_rbe.rbe31  #FUN-BC0078 mark
     SELECT raa03 INTO l_raa03 FROM raa_file WHERE raa01 = g_rbe.rbe01 AND raa02 = g_rbe.rbe32
     DISPLAY l_raa03 TO FORMONLY.rbe32_desc                  
     IF cl_null(g_rbe_t.rbe02) THEN  
       #FUN-BC0078 mark START
       #LET g_rbe.rbe04t = l_rae04
       #LET g_rbe.rbe05t = l_rae05
       #LET g_rbe.rbe06t = l_rae06
       #LET g_rbe.rbe07t = l_rae07
       #FUN-BC0078 mark END
        LET g_rbe.rbe10t = l_rae10
        LET g_rbe.rbe11t = l_rae11
        LET g_rbe.rbe12t = l_rae12
        LET g_rbe.rbe13t = l_rae13
        LET g_rbe.rbe14t = l_rae14
        LET g_rbe.rbe15t = l_rae15
        LET g_rbe.rbe16t = l_rae16
        LET g_rbe.rbe17t = l_rae17
        LET g_rbe.rbe18t = l_rae18
        LET g_rbe.rbe19t = l_rae19
        LET g_rbe.rbe20t = l_rae20
        LET g_rbe.rbe21t = l_rae21
        LET g_rbe.rbe23t = l_rae23
        LET g_rbe.rbe24t = l_rae24
        LET g_rbe.rbe25t = l_rae25
        LET g_rbe.rbe26t = l_rae26
        LET g_rbe.rbe27t = l_rae27
       #FUN-BC0078 mark START
       #LET g_rbe.rbe28t = l_rae28
       #LET g_rbe.rbe29t = l_rae29
       #LET g_rbe.rbe30t = l_rae30
       #LET g_rbe.rbe31t = l_rae31              
       #FUN-BC0078 mark END 
       #FUN-C60041 -------------STA
        LET g_rbe.rbe28t = l_rae28
        LET g_rbe.rbe29t = l_rae29
        LET g_rbe.rbe31t = l_rae31
       #FUN-C60041 -------------END
       #DISPLAY BY NAME g_rbe.rbe04t,g_rbe.rbe05t,g_rbe.rbe06t,g_rbe.rbe07t,  #FUN-BC0078 mark
       #                g_rbe.rbe10t,g_rbe.rbe11t,g_rbe.rbe12t,g_rbe.rbe13t,  #FUN-BC0078 mark
        DISPLAY BY NAME g_rbe.rbe10t,g_rbe.rbe11t,g_rbe.rbe12t,g_rbe.rbe13t,  #FUN-BC0078 add
                        g_rbe.rbe14t,g_rbe.rbe15t,g_rbe.rbe16t,g_rbe.rbe17t,
                        g_rbe.rbe18t,g_rbe.rbe19t,g_rbe.rbe20t,g_rbe.rbe21t,
                        g_rbe.rbe23t,g_rbe.rbe24t,g_rbe.rbe25t,g_rbe.rbe26t,
                       #g_rbe.rbe27t,g_rbe.rbe28t,g_rbe.rbe29t,g_rbe.rbe30t   #FUN-BC0078 mark
                        g_rbe.rbe27t           #FUN-BC0078 add
     END IF                     
  END IF
END FUNCTION

#單身1
#FUN-BC0078 mark START 
#FUNCTION t403_b1()
#  DEFINE  l_ac1_t         LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680136 SMALLINT
#          l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-680136 SMALLINT
#          l_cnt           LIKE type_file.num5,                #No.MOD-650101 add  #No.FUN-680136 SMALLINT
#          l_lock_sw       LIKE type_file.chr1,                #單身鎖住否  #No.FUN-680136 VARCHAR(1)
#          l_allow_insert  LIKE type_file.num5,    #可新增否  #No.FUN-680136 SMALLINT
#          l_allow_delete  LIKE type_file.num5,    #可刪除否  #No.FUN-680136 SMALLINT
#          p_cmd           LIKE type_file.chr1                  #處理狀態  #No.FUN-680136 VARCHAR(1)
#  
#  DEFINE l_rbf04_curr  LIKE rbf_file.rbf04 
#  DEFINE l_price       LIKE rac_file.rac05
#  DEFINE l_discount    LIKE rac_file.rac06
#  DEFINE l_date        LIKE rac_file.rac12
#  DEFINE l_time1       LIKE type_file.num5
#  DEFINE l_time2       LIKE type_file.num5

#   LET g_action_choice = ""
#   IF s_shut(0) THEN RETURN END IF
#   IF cl_null(g_rbe.rbe02) THEN
#      RETURN
#   END IF
#   SELECT * INTO g_rbe.* FROM rbe_file
#    WHERE rbe01 = g_rbe.rbe01 AND rbe02 = g_rbe.rbe02 
#      AND rbe03 = g_rbe.rbe03 AND rbeplant = g_rbe.rbeplant

#   IF g_rbe.rbeacti ='N' THEN    #檢查資料是否為無效
#      CALL cl_err(g_rbe.rbe01||g_rbe.rbe02,'mfg1000',1)
#      RETURN
#   END IF 
#   IF g_rbe.rbeconf = 'Y' OR g_rbe.rbeconf = 'I'  THEN
#      CALL cl_err('','art-024',1)
#      RETURN
#   END IF
#   #TQC-AC0326 add ---------begin----------
#   IF g_rbe.rbe01 <> g_rbe.rbeplant THEN
#      CALL cl_err('','art-977',0)
#      RETURN
#   END IF
#   #TQC-AC0326 add ----------end-----------
#   #FUN-AB0033 mark ------start------
#   #IF g_rbe.rbeconf = 'X' THEN
#   #   CALL cl_err('','art-025',1)
#   #   RETURN
#   #END IF 
#   #FUN-AB0033 mark -------end-------
#   CALL cl_opmsg('b')
#   LET g_forupd_sql = " SELECT b.rbf04,'','','','','','',",
#                      "                   b.rbf05,b.rbf06,b.rbf07,b.rbf08,b.rbfacti ",
#                      "   FROM rbf_file b ",
#                      "  WHERE b.rbf01 = ?  AND b.rbf02 = ? AND b.rbf03= ? AND b.rbfplant= ? ",
#                      "    AND b.rbf06 = ? ",
#                      "    FOR UPDATE "                   
#   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#   DECLARE t403_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
#   LET l_ac1_t = 0
#       LET l_allow_insert = cl_detail_input_auth("insert")
#       LET l_allow_delete = cl_detail_input_auth("delete")
#
#       INPUT ARRAY g_rbf WITHOUT DEFAULTS FROM s_rbf.*
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
#          #LET l_newline = 'N' #No:7629 一開始先設 "為新增的項次否='N'"
#           LET l_ac1 = ARR_CURR()
#           LET l_lock_sw = 'N'            #DEFAULT
#           LET l_n  = ARR_COUNT()
#           BEGIN WORK
#
#           OPEN t403_cl USING g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,g_rbe.rbeplant
#           IF STATUS THEN
#              CALL cl_err("OPEN t403_cl:", STATUS, 1)
#              CLOSE t403_cl
#              ROLLBACK WORK
#              RETURN
#           END IF
#           FETCH t403_cl INTO g_rbe.*            # 鎖住將被更改或取消的資料
#           IF SQLCA.sqlcode THEN
#              CALL cl_err(g_rbe.rbe01||g_rbe.rbe02,SQLCA.sqlcode,0)      # 資料被他人LOCK
#              CLOSE t403_cl
#              ROLLBACK WORK
#              RETURN
#           END IF
#           IF g_rec_b1>=l_ac1 THEN
#               LET p_cmd='u'
#               LET g_rbf_t.* = g_rbf[l_ac1].*  #BACKUP
#               LET g_rbf_o.* = g_rbf[l_ac1].*  #BACKUP
#TQC-B10003--mark--begin
#                IF p_cmd='u' THEN    #組別不可輸入
#                   CALL cl_set_comp_entry("rbf06",FALSE)
#                ELSE
#                   CALL cl_set_comp_entry("rbf06",TRUE)
#                END IF  
#TQC-B10003--mark--end 
#               OPEN t403_bcl USING g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,g_rbe.rbeplant,g_rbf_t.rbf06                    
#               IF STATUS THEN
#                   CALL cl_err("OPEN t403_bcl:", STATUS, 1)
#               ELSE
#                   #FETCH t403_bcl INTO l_rbf04_curr,g_rbf[l_ac1].*
#                   SELECT b.rbf04,'',a.rbf05,a.rbf06,a.rbf07,a.rbf08,a.rbfacti,
#                          b.rbf05,b.rbf06,b.rbf07,b.rbf08,b.rbfacti
#                     INTO l_rbf04_curr,g_rbf[l_ac1].*
#                     FROM rbf_file b LEFT OUTER JOIN rbf_file a
#                       ON (b.rbf01=a.rbf01 AND b.rbf02=a.rbf02 AND b.rbf03=a.rbf03 
#                      AND  b.rbf04=a.rbf04 AND b.rbf06=a.rbf06 AND b.rbfplant=a.rbfplant 
#                      AND b.rbf05<>a.rbf05 )
#                    WHERE b.rbf01 =g_rbe.rbe01  AND b.rbf02 =g_rbe.rbe02 AND b.rbf03=g_rbe.rbe03
#                      AND b.rbfplant=g_rbe.rbeplant  
#                      AND b.rbf06 = g_rbf_t.rbf06 
#                      AND b.rbf05='1' 
#                   IF SQLCA.sqlcode THEN
#                       CALL cl_err(g_rbf_t.type||g_rbf_t.rbf06,SQLCA.sqlcode,1)
#                       LET l_lock_sw = "Y"                       
#                   END IF
#                   IF g_rbf[l_ac1].before='0' THEN
#                      LET g_rbf[l_ac1].type ='1'
#                   ELSE
#                      LET g_rbf[l_ac1].type ='0'
#                   END IF                  
#               END IF
#               CALL cl_show_fld_cont()      
#           END IF
#           CALL t403_rbf_entry(g_rbf[l_ac1].rbf07) 

#       BEFORE INSERT
#           #DISPLAY "BEFORE INSERT!"
#           LET l_n = ARR_COUNT()
#           LET p_cmd='a'
#           INITIALIZE g_rbf[l_ac1].* TO NULL 
#           LET g_rbf[l_ac1].type = '0'      
#           LET g_rbf[l_ac1].before = '0'
#           LET g_rbf[l_ac1].after  = '1'
#           LET g_rbf_t.* = g_rbf[l_ac1].*         #新輸入資料
#           LET g_rbf_o.* = g_rbf[l_ac1].*
#TQC-B10003-mark-begin
#           IF p_cmd='u' THEN    #組別不可輸入
#              CALL cl_set_comp_entry("rbf06",FALSE)
#           ELSE
#              CALL cl_set_comp_entry("rbf06",TRUE)
#           END IF   
#TQC-B10003--mark--end
#           SELECT MAX(rbf04)+1 INTO l_rbf04_curr 
#             FROM rbf_file
#            WHERE rbf01=g_rbe.rbe01
#              AND rbf02=g_rbe.rbe02 
#              AND rbf03=g_rbe.rbe03 
#              AND rbfplant=g_rbe.rbeplant
#             IF l_rbf04_curr IS NULL OR l_rbf04_curr=0 THEN
#                LET l_rbf04_curr = 1
#             END IF
#          CALL t403_rbf_entry(g_rbf[l_ac1].rbf07)    
#          CALL cl_show_fld_cont()
#          NEXT FIELD rbf06     
#       
#       AFTER INSERT
#           IF INT_FLAG THEN
#              CALL cl_err('',9001,0)
#              LET INT_FLAG = 0
#              CANCEL INSERT
#           END IF 
#           SELECT COUNT(*) INTO l_n FROM rbf_file
#            WHERE rbf01=g_rbe.rbe01 AND rbf02=g_rbe.rbe02
#              AND rbf03=g_rbe.rbe03 AND rbfplant=g_rbe.rbeplant
#              AND rbf06=g_rbf[l_ac1].rbf06                
#           IF l_n>0 THEN 
#              CALL cl_err('',-239,0)
#              LET g_rbf[l_ac1].* = g_rbf_t.*
#              NEXT FIELD rbf06
#           END IF  
#           IF g_rbf[l_ac1].type= '0' THEN  #新增時
#              INSERT INTO rbf_file(rbf01,rbf02,rbf03,rbf04,rbf05,rbf06,rbf07,
#                                   rbf08,rbfacti,rbfplant,rbflegal)
#              VALUES(g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,l_rbf04_curr,g_rbf[l_ac1].after,
#                     g_rbf[l_ac1].rbf06,g_rbf[l_ac1].rbf07,g_rbf[l_ac1].rbf08,
#                     g_rbf[l_ac1].rbfacti,g_rbe.rbeplant,g_rbe.rbelegal) 
#              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                 CALL cl_err3("ins","rbf_file",g_rbe.rbe02||g_rbf[l_ac1].after||g_rbf[l_ac1].rbf06,"",SQLCA.sqlcode,"","",1)
#                 CANCEL INSERT
#              ELSE
#                 #MESSAGE 'INSERT O.K'
#                 COMMIT WORK
#                 LET g_rec_b1=g_rec_b1+1
#                 DISPLAY g_rec_b1 TO FORMONLY.cn1
#              END IF           
#           ELSE  #修改時
#              INSERT INTO rbf_file(rbf01,rbf02,rbf03,rbf04,rbf05,rbf06,rbf07,
#                                   rbf08,rbfacti,rbfplant,rbflegal)                                    
#              VALUES(g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,l_rbf04_curr,g_rbf[l_ac1].after,
#                     g_rbf[l_ac1].rbf06,g_rbf[l_ac1].rbf07,g_rbf[l_ac1].rbf08,
#                     g_rbf[l_ac1].rbfacti,g_rbe.rbeplant,g_rbe.rbelegal)
#              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                 CALL cl_err3("ins","rbf_file",g_rbe.rbe02||g_rbf[l_ac1].after||g_rbf[l_ac1].rbf06,"",SQLCA.sqlcode,"","",1)
#                 CANCEL INSERT 
#              #ELSE
#              #   MESSAGE 'INSERT value.after O.K' 
#              END IF
#              INSERT INTO rbf_file(rbf01,rbf02,rbf03,rbf04,rbf05,rbf06,rbf07,
#                                   rbf08,rbfacti,rbfplant,rbflegal)                                    
#              VALUES(g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,l_rbf04_curr,g_rbf[l_ac1].before,
#                     g_rbf[l_ac1].rbf06_1,g_rbf[l_ac1].rbf07_1,g_rbf[l_ac1].rbf08_1,
#                     g_rbf[l_ac1].rbfacti_1,g_rbe.rbeplant,g_rbe.rbelegal)
#              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                 CALL cl_err3("ins","rbf_file",g_rbe.rbe02||g_rbf[l_ac1].before||g_rbf[l_ac1].rbf06,"",SQLCA.sqlcode,"","",1)
#                 CANCEL INSERT
#              ELSE
#                 #MESSAGE 'INSERT value.before O.K'
#                 COMMIT WORK
#                 LET g_rec_b1=g_rec_b1+1
#                 DISPLAY g_rec_b1 TO FORMONLY.cn1
#              END IF
#           END IF 
#       
#       #FUN-AB0033 mark -----------------start--------------------
#       #BEFORE FIELD rbf06
#       #   IF g_rbf[l_ac1].rbf06 IS NULL OR g_rbf[l_ac1].rbf06 = 0 THEN
#       #      SELECT max(rbf06)+1
#       #        INTO g_rbf[l_ac1].rbf06
#       #        FROM rbf_file
#       #       WHERE rbf02 = g_rbe.rbe02 AND rbf01 = g_rbe.rbe01
#       #         AND rbf03 = g_rbe.rbe03 AND rbfplant = g_rbe.rbeplant
#       #      IF g_rbf[l_ac1].rbf06 IS NULL THEN
#       #         LET g_rbf[l_ac1].rbf06 = 1
#       #      END IF
#       #   END IF
#       #FUN-AB0033 mark ------------------end---------------------       
#    
#       AFTER FIELD rbf06
#          IF NOT cl_null(g_rbf[l_ac1].rbf06) THEN
#             IF (g_rbf[l_ac1].rbf06 <> g_rbf_t.rbf06
#                OR cl_null(g_rbf_t.rbf06)) THEN 
#                SELECT COUNT(*) INTO l_n 
#                  FROM raf_file
#                 WHERE raf01=g_rbe.rbe01 AND raf02=g_rbe.rbe02
#                   AND rafplant=g_rbe.rbeplant AND raf03=g_rbf[l_ac1].rbf06
#                IF l_n=0 THEN
#                   IF NOT cl_confirm('art-677') THEN   #確定新增?
#                      NEXT FIELD rbf06
#                   ELSE
#                      CALL t403_b1_init()
#                   END IF
#                ELSE
#                   IF NOT cl_confirm('art-676') THEN   #確定修改?
#                      NEXT FIELD rbf06
#                   ELSE
#                      CALL t403_b1_find()   
#                   END IF           
#                END IF
#             END IF       
#          END IF
#          
#     BEFORE FIELD rbf07   #rbe21為空時，只能為1
#        IF NOT cl_null(g_rbe.rbe21t) AND g_rbe.rbe21t<>0 THEN     #TQC-B10003
#           CALL cl_set_comp_entry("rbf07",TRUE)
#        ELSE
#           LET g_rbf[l_ac1].rbf07='1'
#       #   CALL cl_set_comp_entry("rbf07",FALSE)      #TQC-B10003--mark
#        END IF

#     AFTER FIELD rbf07
#        IF NOT cl_null(g_rbf[l_ac1].rbf07) THEN
#           IF g_rbf_o.rbf07 IS NULL OR
#              (g_rbf[l_ac1].rbf07 != g_rbf_o.rbf07 ) THEN
#              IF g_rbf[l_ac1].rbf07 NOT MATCHES '[12]' THEN
#                 LET g_rbf[l_ac1].rbf07= g_rbf_o.rbf07
#                 NEXT FIELD rbf07
#              ELSE
#                 CALL t403_rbf_entry(g_rbf[l_ac1].rbf07)
#              END IF
#           END IF
#        END IF        
#            
#     ON CHANGE rbf07
#        IF NOT cl_null(g_rbf[l_ac1].rbf07) THEN
#           CALL t403_rbf_entry(g_rbf[l_ac1].rbf07)
#        END IF 
#       
#     AFTER FIELD rbf08      
#        IF NOT cl_null(g_rbf[l_ac1].rbf08) THEN
#           IF g_rbf_o.rbf08 IS NULL OR g_rbf_o.rbf08=0 OR
#              (g_rbf[l_ac1].rbf08 != g_rbf_o.rbf08 ) THEN
#              CALL t403_rbf08_check(g_rbf[l_ac1].rbf08)
#              IF NOT cl_null(g_errno) THEN
#                 CALL cl_err('rbf08',g_errno,0)
#                 LET g_rbf[l_ac1].rbf08= g_rbf_o.rbf08
#                 NEXT FIELD rbf08
#              ELSE
#                 DISPLAY BY NAME g_rbf[l_ac1].rbf08
#              END IF 
#           END IF 
#        END IF 
#        
#      BEFORE DELETE
#          #DISPLAY "BEFORE DELETE"
#          IF g_rbf_t.rbf06 > 0 AND g_rbf_t.rbf06 IS NOT NULL THEN
#             IF NOT cl_delb(0,0) THEN
#                CANCEL DELETE
#             END IF
#             SELECT COUNT(*) INTO l_n FROM rbg_file
#              WHERE rbg01=g_rbe.rbe01 AND rbg02=g_rbe.rbe02
#                AND rbg03=g_rbe.rbe03 AND rbgplant=g_rbe.rbeplant
#                AND rbg06=g_rbf_t.rbf06
#             IF l_n>0 THEN
#                CALL cl_err(g_rbf_t.rbf06,'art-664',0)  #已在第二單身使用
#                CANCEL DELETE
#             ELSE 
#                SELECT COUNT(*) INTO l_n FROM rbp_file
#                 WHERE rbp01=g_rbe.rbe01 AND rbp02=g_rbe.rbe02 AND rbp04='2'
#                   AND rbp03=g_rbe.rbe03 AND rbpplant=g_rbe.rbeplant
#                   AND rbp07=g_rbf_t.rbf06  #組別
#                IF l_n>0 THEN
#                   CALL cl_err(g_rbf_t.rbf06,'art-665',0) #會員等級促銷中使用
#                   CANCEL DELETE 
#                END IF
#             END IF             
#             IF l_lock_sw = "Y" THEN
#                CALL cl_err("", -263, 1)
#                CANCEL DELETE
#             END IF
#             DELETE FROM rbf_file
#              WHERE rbf02 = g_rbe.rbe02 AND rbf01 = g_rbe.rbe01
#                AND rbf03 = g_rbe.rbe03 AND rbf04 = l_rbf04_curr
#                AND rbf06 = g_rbf_t.rbf06  
#                AND rbfplant = g_rbe.rbeplant
#             IF SQLCA.sqlcode THEN
#                CALL cl_err3("del","rbf_file",g_rbe.rbe01,g_rbf_t.rbf06,SQLCA.sqlcode,"","",1) 
#                ROLLBACK WORK
#                CANCEL DELETE 
#             END IF
#             CALL t403_upd_log() 
#             LET g_rec_b1=g_rec_b1-1
#          END IF
#          COMMIT WORK
#
#       ON ROW CHANGE
#          IF INT_FLAG THEN
#             CALL cl_err('',9001,0)
#             LET INT_FLAG = 0
#             LET g_rbf[l_ac1].* = g_rbf_t.*
#             CLOSE t403_bcl
#             ROLLBACK WORK
#             EXIT INPUT
#          END IF
#          IF cl_null(g_rbf[l_ac1].rbf07) THEN
#             NEXT FIELD rbf07
#          END IF
#            
#          IF l_lock_sw = 'Y' THEN
#             CALL cl_err(g_rbf[l_ac1].rbf06,-263,1)
#             LET g_rbf[l_ac1].* = g_rbf_t.*
#          ELSE
#             UPDATE rbf_file SET rbf07  =g_rbf[l_ac1].rbf07,
#                                 rbf06  =g_rbf[l_ac1].rbf06,  #TQC-B60071 ADD
#                                 rbf08  =g_rbf[l_ac1].rbf08,
#                                 rbfacti=g_rbf[l_ac1].rbfacti
#              WHERE rbf02 = g_rbe.rbe02 AND rbf01=g_rbe.rbe01
#                AND rbf03 = g_rbe.rbe03 AND rbf06=g_rbf_t.rbf06
#                AND rbf05='1' 
#                AND rbfplant = g_rbe.rbeplant 
#             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                CALL cl_err3("upd","rbf_file",g_rbe.rbe01,g_rbf_t.rbf06,SQLCA.sqlcode,"","",1) 
#                LET g_rbf[l_ac1].* = g_rbf_t.*
#             ELSE                 
#-TQC-B60071 - ADD - BEGIN ---------------------------------------------
#                IF cl_null(g_rbf_t.rbf06_1) THEN
#                   IF NOT cl_null(g_rbf[l_ac1].rbf06_1) THEN
#                      INSERT INTO rbf_file(rbf01,rbf02,rbf03,rbf04,rbf05,rbf06,rbf07,
#                                           rbf08,rbfacti,rbfplant,rbflegal)
#                      VALUES(g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,l_rbf04_curr,g_rbf[l_ac1].before,
#                             g_rbf[l_ac1].rbf06_1,g_rbf[l_ac1].rbf07_1,g_rbf[l_ac1].rbf08_1,
#                             g_rbf[l_ac1].rbfacti_1,g_rbe.rbeplant,g_rbe.rbelegal)
#                   END IF
#                ELSE
#                   IF NOT cl_null(g_rbf[l_ac1].rbf06_1) THEN
#                      UPDATE rbf_file SET rbf06   = g_rbf[l_ac1].rbf06_1,
#                                          rbf07   = g_rbf[l_ac1].rbf07_1,
#                                          rbf08   = g_rbf[l_ac1].rbf08_1,
#                                          rbfacti = g_rbf[l_ac1].rbfacti_1
#                      WHERE rbf02 = g_rbe.rbe02 AND rbf01 = g_rbe.rbe01
#                        AND rbf03 = g_rbe.rbe03 AND rbf06 = g_rbf_t.rbf06_1
#                        AND rbf05 = '0'
#                        AND rbfplant = g_rbe.rbeplant
#                   ELSE
#                      DELETE FROM rbf_file
#                       WHERE rbf02 = g_rbe.rbe02 AND rbf01 = g_rbe.rbe01
#                         AND rbf03 = g_rbe.rbe03 AND rbf06 = g_rbf_t.rbf06_1
#                         AND rbf05 = '0'
#                         AND rbfplant = g_rbe.rbeplant
#                   END IF
#                END IF
#-TQC-B60071 - ADD -  END  ---------------------------------------------
#                #MESSAGE 'UPDATE rbf_file O.K'
#                CALL t403_upd_log() 
#                COMMIT WORK
#             END IF
#          END IF
#
#       AFTER ROW
#          #DISPLAY  "AFTER ROW!!"
#          LET l_ac1 = ARR_CURR()
#          LET l_ac1_t = l_ac1
#          IF INT_FLAG THEN
#             CALL cl_err('',9001,0)
#             LET INT_FLAG = 0
#             IF p_cmd = 'u' THEN
#                LET g_rbf[l_ac1].* = g_rbf_t.*
#             END IF
#             CLOSE t403_bcl
#             ROLLBACK WORK
#             EXIT INPUT
#          END IF
#          CLOSE t403_bcl
#          COMMIT WORK
#
#       ON ACTION alter_memberlevel    #會員等級促銷
#          IF NOT cl_null(g_rbe.rbe02) THEN
#             IF g_rbe.rbe12t = 'Y'  THEN     #MOD-AC0189  
#                CALl t402_2(g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,'2',g_rbe.rbeplant,g_rbe.rbeconf,g_rbe.rbe10) 
#             ELSE
#                CALL cl_err('','art507',0)
#             END IF
#          ELSE
#             CALL cl_err('',-400,0)
#          END IF
#      
#      ON ACTION CONTROLO
#          IF INFIELD(rbf06) AND l_ac1 > 1 THEN
#             LET g_rbf[l_ac1].* = g_rbf[l_ac1-1].*
#             LET g_rec_b1 = g_rec_b1+1
#             NEXT FIELD rbf06
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
#   CLOSE t403_bcl
#   COMMIT WORK
#   #CALL t403_delall()   #FUN-AB0033 mark
#END FUNCTION          
#單身2
#FUNCTION t403_b2()
#   DEFINE  l_ac2_t         LIKE type_file.num5,
#           l_cnt           LIKE type_file.num5,
#           l_n             LIKE type_file.num5,
#           l_lock_sw       LIKE type_file.chr1,
#           p_cmd           LIKE type_file.chr1,
#           l_allow_insert  LIKE type_file.num5,
#           l_allow_delete  LIKE type_file.num5
#   DEFINE  l_ima25         LIKE ima_file.ima25
#   DEFINE  l_rbg04_curr    LIKE rbg_file.rbg04 
#   LET g_action_choice = "" 
#   IF s_shut(0) THEN
#      RETURN
#   END IF 
#   IF g_rbe.rbe02 IS NULL THEN
#      RETURN
#   END IF 
#   SELECT * INTO g_rbe.* FROM rbe_file
#    WHERE rbe01 = g_rbe.rbe01
#      AND rbe02 = g_rbe.rbe02 
#      AND rbe03 = g_rbe.rbe03 
#      AND rbeplant = g_rbe.rbeplant
#
#   IF g_rbe.rbeacti ='N' THEN
#      CALL cl_err(g_rbe.rbe02,'mfg1000',0)
#      RETURN
#   END IF    
#   IF g_rbe.rbeconf = 'Y' OR  g_rbe.rbeconf = 'I' THEN
#      CALL cl_err('','art-024',0)
#      RETURN
#   END IF
#   #TQC-AC0326 add ---------begin----------
#   IF g_rbe.rbe01 <> g_rbe.rbeplant THEN
#      CALL cl_err('','art-977',0)
#      RETURN
#   END IF
#   #TQC-AC0326 add ----------end-----------
#   #FUN-AB0033 mark ------start------
#   #IF g_rbe.rbeconf = 'X' THEN                                                                                             
#   #   CALL cl_err('','art-025',0)                                                                                          
#   #   RETURN                                                                                                               
#   #END IF
#   #FUN-AB0033 mark -------end-------
#   CALL cl_opmsg('b')
#  
#   LET g_forupd_sql = " SELECT *  ",
#                      "   FROM rbg_file ",
#                      "  WHERE rbg01 = ? AND rbg02 = ? ",
#                      "    AND rbg03=? AND rbgplant=?  AND rbg06=? AND rbg07=? ",  
#                      "    AND rbg08=? AND rbg09=?  FOR UPDATE   "
#   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#   DECLARE t4031_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

#   LET l_ac2_t = 0
#   LET l_allow_insert = cl_detail_input_auth("insert")
#   LET l_allow_delete = cl_detail_input_auth("delete")
#       
#   INPUT ARRAY g_rbg WITHOUT DEFAULTS FROM s_rbg.*
#   ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
#             INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
#             APPEND ROW=l_allow_insert)
#
#       BEFORE INPUT
#          #DISPLAY "BEFORE INPUT!"
#          IF g_rec_b2 != 0 THEN
#             CALL fgl_set_arr_curr(l_ac2)
#          END IF
#
#       BEFORE ROW
#          #DISPLAY "BEFORE ROW!"
#          LET p_cmd = ''
#          LET l_ac2 = ARR_CURR()
#          LET l_lock_sw = 'N'            #DEFAULT
#          LET l_n  = ARR_COUNT()
#          #CALL t403_rbg07_chk() 
#
#          BEGIN WORK 
#          OPEN t403_cl USING g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,g_rbe.rbeplant
#          IF STATUS THEN
#             CALL cl_err("OPEN t403_cl:", STATUS, 1)
#             CLOSE t403_cl
#             ROLLBACK WORK
#             RETURN
#          END IF 
#          FETCH t403_cl INTO g_rbe.*
#          IF SQLCA.sqlcode THEN
#             CALL cl_err(g_rbe.rbe02,SQLCA.sqlcode,0)
#             CLOSE t403_cl
#             ROLLBACK WORK
#             RETURN
#          END IF
#
#          IF g_rec_b2 >= l_ac2 THEN
#             LET p_cmd = 'u'
#             LET g_rbg_t.* = g_rbg[l_ac2].*  #BACKUP
#             LET g_rbg_o.* = g_rbg[l_ac2].*  #BACKUP
#             CALL t403_rbg07()
#             IF cl_null(g_rbg_t.rbg09) THEN
#                LET g_rbg_t.rbg09=' '
#             END IF   
#             OPEN t4031_bcl USING g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,g_rbe.rbeplant,
#                                  g_rbg_t.rbg06,g_rbg_t.rbg07,g_rbg_t.rbg08,g_rbg_t.rbg09
#             IF STATUS THEN
#                CALL cl_err("OPEN t4031_bcl:", STATUS, 1)
#                LET l_lock_sw = "Y"
#             ELSE
#                #FETCH t4031_bcl INTO l_rbg04_curr,g_rbg[l_ac2].*                   
#                SELECT b.rbg04,'',a.rbg05,a.rbg06,a.rbg07,a.rbg08,'',a.rbg09,'',a.rbgacti,
#                       b.rbg05,b.rbg06,b.rbg07,b.rbg08,'',b.rbg09,'',b.rbgacti
#                  INTO l_rbg04_curr,g_rbg[l_ac2].*
#                  FROM rbg_file b LEFT OUTER JOIN rbg_file a
#                    ON (b.rbg01=a.rbg01 AND b.rbg02=a.rbg02 AND b.rbg03=a.rbg03 AND b.rbg04=a.rbg04 
#                   AND b.rbg06=a.rbg06 AND b.rbg07=a.rbg07 AND b.rbgplant=a.rbgplant AND b.rbg05<>a.rbg05 )
#                 WHERE b.rbg01 =g_rbe.rbe01 AND b.rbg02 =g_rbe.rbe02 
#                   AND b.rbg03=g_rbe.rbe03 AND b.rbgplant=g_rbe.rbeplant  AND b.rbg06=g_rbg_t.rbg06
#                   AND b.rbg07=g_rbg_t.rbg07   AND b.rbg05='1' 
#                   AND b.rbg08=g_rbg_t.rbg08   AND b.rbg09=g_rbg_t.rbg09                 
#                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_rbg_t.rbg06,SQLCA.sqlcode,1)
#                   LET l_lock_sw = "Y"
#                END IF
#                IF g_rbg[l_ac1].before1='0' THEN
#                   LET g_rbg[l_ac1].type1 ='1'
#                ELSE
#                   LET g_rbg[l_ac1].type1 ='0'
#                END IF 
#                CALL t403_rbg08('d',l_ac2)
#                CALL t403_rbg08_1('d',l_ac2)
#                CALL t403_rbg09('d')
#             END IF
#          END IF 
#
#       BEFORE INSERT
#           LET l_n = ARR_COUNT()
#           LET p_cmd='a'
#           INITIALIZE g_rbg[l_ac2].* TO NULL 
#           LET g_rbg[l_ac2].type1 = '0'      
#           LET g_rbg[l_ac2].before1 = '0'
#           LET g_rbg[l_ac2].after1  = '1'  
#          #LET g_rbg[l_ac2].rbg07   = '01'             #Body default
#           LET g_rbg[l_ac2].rbgacti = 'Y' 
#          SELECT MIN(rbf06) INTO g_rbg[l_ac2].rbg06 FROM rbf_file
#           WHERE rbf01=g_rbe.rbe01 
#             AND rbf02=g_rbe.rbe02 
#             AND rbf03=g_rbe.rbe03 
#             AND rbfplant=g_rbe.rbeplant
#             
#           LET g_rbg_t.* = g_rbg[l_ac2].*         #新輸入資料
#           LET g_rbg_o.* = g_rbg[l_ac2].*         #新輸入資料
#           
#           SELECT MAX(rbg04)+1 INTO l_rbg04_curr 
#             FROM rbg_file
#            WHERE rbg01=g_rbe.rbe01
#              AND rbg02=g_rbe.rbe02 
#              AND rbg03=g_rbe.rbe03 
#              AND rbgplant=g_rbe.rbeplant
#             IF l_rbg04_curr IS NULL OR l_rbg04_curr=0 THEN
#                LET l_rbg04_curr = 1
#             END IF
#           IF cl_null(g_rbg[l_ac2].rbg09) THEN
#             LET g_rbg[l_ac2].rbg09 = ' '
#           END IF  
#           CALL cl_show_fld_cont()
#           NEXT FIELD rbg06 
#
#       AFTER INSERT
#           IF INT_FLAG THEN
#              CALL cl_err('',9001,0)
#              LET INT_FLAG = 0
#              CANCEL INSERT
#           END IF
#           IF cl_null(g_rbg[l_ac2].rbg09) THEN
#              LET g_rbg[l_ac2].rbg09=' '
#           END IF
#           IF cl_null(g_rbg[l_ac2].rbg09_1) THEN
#              LET g_rbg[l_ac2].rbg09_1=' '
#           END IF
#           SELECT COUNT(*) INTO l_n FROM rbg_file
#            WHERE rbg01=g_rbe.rbe01 AND rbg02=g_rbe.rbe02
#              AND rbg03=g_rbe.rbe03 AND rbgplant=g_rbe.rbeplant
#              AND rbg06=g_rbg[l_ac2].rbg06 
#              AND rbg07=g_rbg[l_ac2].rbg07 
#              AND rbg08=g_rbg[l_ac2].rbg08 
#              AND rbg09=g_rbg[l_ac2].rbg09
#           IF l_n>0 THEN 
#              CALL cl_err('',-239,0)
#              #LET g_rbg[l_ac2].* = g_rbg_t.*
#              NEXT FIELD rbg06
#           END IF       
#           IF g_rbg[l_ac2].type1= '0' THEN               
#              INSERT INTO rbg_file(rbg01,rbg02,rbg03,rbg04,rbg05,rbg06,rbg07,rbg08,rbg09,                                     
#                                   rbgacti,rbgplant,rbglegal)
#              VALUES(g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,l_rbg04_curr,g_rbg[l_ac2].after1,
#                     g_rbg[l_ac2].rbg06,g_rbg[l_ac2].rbg07,g_rbg[l_ac2].rbg08,g_rbg[l_ac2].rbg09, 
#                     g_rbg[l_ac2].rbgacti,g_rbe.rbeplant,g_rbe.rbelegal) 
#              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                 CALL cl_err3("ins","rbg_file",g_rbe.rbe02||g_rbg[l_ac2].after1||g_rbg[l_ac2].rbg06,"",SQLCA.sqlcode,"","",1)
#                 CANCEL INSERT
#              ELSE
#                 CALL s_showmsg_init()
#                 LET g_errno=' '
#                 #CALL t403_repeat(g_rbg[l_ac2].rbg06)  #check
#                 CALL s_showmsg()
#                 IF NOT cl_null(g_errno) THEN
#                    LET g_rbg[l_ac2].* = g_rbg_t.*
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
#              INSERT INTO rbg_file(rbg01,rbg02,rbg03,rbg04,rbg05,rbg06,rbg07,rbg08,rbg09,                                    
#                                   rbgacti,rbgplant,rbglegal)
#              VALUES(g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,l_rbg04_curr,g_rbg[l_ac2].after1,
#                     g_rbg[l_ac2].rbg06,g_rbg[l_ac2].rbg07,g_rbg[l_ac2].rbg08,g_rbg[l_ac2].rbg09, 
#                     g_rbg[l_ac2].rbgacti,g_rbe.rbeplant,g_rbe.rbelegal) 
#              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                 CALL cl_err3("ins","rbg_file",g_rbe.rbe02||g_rbg[l_ac2].after1||g_rbg[l_ac2].rbg06,"",SQLCA.sqlcode,"","",1)
#                 CANCEL INSERT 
#              #ELSE
#                 #MESSAGE 'INSERT value.after O.K' 
#              END IF
#              INSERT INTO rbg_file(rbg01,rbg02,rbg03,rbg04,rbg05,rbg06,rbg07,rbg08,rbg09,                                     
#                                   rbgacti,rbgplant,rbglegal)
#              VALUES(g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,l_rbg04_curr,g_rbg[l_ac2].before1,
#                     g_rbg[l_ac2].rbg06_1,g_rbg[l_ac2].rbg07_1,g_rbg[l_ac2].rbg08_1,g_rbg[l_ac2].rbg09_1, 
#                     g_rbg[l_ac2].rbgacti_1,g_rbe.rbeplant,g_rbe.rbelegal) 
#              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                 CALL cl_err3("ins","rbg_file",g_rbe.rbe02||g_rbg[l_ac2].before1||g_rbg[l_ac2].rbg06_1,"",SQLCA.sqlcode,"","",1)
#                 CANCEL INSERT               
#              ELSE
#                 CALL s_showmsg_init()
#                 LET g_errno=' '
#                 #CALL t403_repeat(g_rbg[l_ac2].rbg06)  #check
#                 CALL s_showmsg()
#                 IF NOT cl_null(g_errno) THEN
#                    LET g_rbg[l_ac2].* = g_rbg_t.*
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
#     AFTER FIELD rbg06
#        IF NOT cl_null(g_rbg[l_ac2].rbg06) THEN
#           IF g_rbg_o.rbg06 IS NULL OR (g_rbg[l_ac2].rbg06 != g_rbg_o.rbg06 ) THEN
#              CALL t403_rbg06()    #檢查其有效性          
#              IF NOT cl_null(g_errno) THEN
#                 CALL cl_err(g_rbg[l_ac2].rbg06,g_errno,0)
#                 LET g_rbg[l_ac2].rbg06 = g_rbg_o.rbg06
#                 NEXT FIELD rbg06
#              END IF

#             IF NOT cl_null(g_rbg[l_ac2].rbg07) AND NOT cl_null(g_rbg[l_ac2].rbg08) THEN
#                SELECT COUNT(*) INTO l_n 
#                 FROM rag_file
#                WHERE rag01=g_rbe.rbe01 AND rag02=g_rbe.rbe02
#                  AND ragplant=g_rbe.rbeplant 
#                  AND rag03=g_rbg[l_ac2].rbg06
#                  AND rag04=g_rbg[l_ac2].rbg07
#                  AND rag05=g_rbg[l_ac2].rbg08
#                IF l_n=0 THEN
#                   IF NOT cl_confirm('art-678') THEN
#                      NEXT FIELD rbg06
#                   ELSE
#                      CALL t403_b2_init()
#                   END IF
#                ELSE
#                   IF NOT cl_confirm('art-679') THEN
#                      NEXT FIELD rbg06
#                   ELSE
#                      CALL t403_b2_find()   
#                   END IF           
#                END IF
#             END IF 
#           END IF  
#        END IF 

#     #BEFORE FIELD rbg07 
#     #   IF NOT cl_null(g_rbg[l_ac2].rbg06) THEN
#     #      CALL t403_rbg07_chk()
#     #   END IF

#     AFTER FIELD rbg07
#        IF NOT cl_null(g_rbg[l_ac2].rbg07) THEN
#           IF g_rbg_o.rbg07 IS NULL OR (g_rbg[l_ac2].rbg07 != g_rbg_o.rbg07 ) THEN 
#             IF NOT cl_null(g_rbg[l_ac2].rbg08) AND NOT cl_null(g_rbg[l_ac2].rbg06) THEN
#                SELECT COUNT(*) INTO l_n 
#                 FROM rag_file
#                WHERE rag01=g_rbe.rbe01 AND rag02=g_rbe.rbe02
#                  AND ragplant=g_rbe.rbeplant 
#                  AND rag03=g_rbg[l_ac2].rbg06
#                  AND rag04=g_rbg[l_ac2].rbg07
#                  AND rag05=g_rbg[l_ac2].rbg08
#                IF l_n=0 THEN
#                   IF NOT cl_confirm('art-678') THEN    #確定新增?
#                      NEXT FIELD rbg07
#                   ELSE
#                      CALL t403_b2_init()
#                   END IF
#                ELSE
#                   IF NOT cl_confirm('art-679') THEN    #確定修改?
#                      NEXT FIELD rbg07
#                   ELSE
#                      CALL t403_b2_find()   
#                   END IF           
#                END IF
#             END IF  
#              CALL t403_rbg07() 
#              #FUN-AB0033 mark --------------start-----------------
#              #IF NOT cl_null(g_errno) THEN
#              #   CALL cl_err(g_rbg[l_ac2].rbg07,g_errno,0)
#              #   LET g_rbg[l_ac2].rbg07 = g_rbg_o.rbg07
#              #   NEXT FIELD rbg07
#              #END IF
#              #FUN-AB0033 mark ---------------end------------------
#           END IF  
#        END IF  

#     ON CHANGE rbg07
#        IF NOT cl_null(g_rbg[l_ac2].rbg07) THEN
#           CALL t403_rbg07()   
#           LET g_rbg[l_ac2].rbg08=NULL
#           LET g_rbg[l_ac2].rbg08_desc=NULL
#           LET g_rbg[l_ac2].rbg09=NULL
#           LET g_rbg[l_ac2].rbg09_desc=NULL
#           DISPLAY BY NAME g_rbg[l_ac2].rbg08,g_rbg[l_ac2].rbg08_desc
#           DISPLAY BY NAME g_rbg[l_ac2].rbg09,g_rbg[l_ac2].rbg09_desc
#        END IF
# 
#     BEFORE FIELD rbg08,rbg09
#        IF NOT cl_null(g_rbg[l_ac2].rbg07) THEN
#           CALL t403_rbg07()            
#        END IF

#     AFTER FIELD rbg08
#        IF NOT cl_null(g_rbg[l_ac2].rbg08) THEN
#           #FUN-AB0025 ----------add start------------
#           IF g_rbg[l_ac2].rbg07 = '01' THEN
#              IF NOT s_chk_item_no(g_rbg[l_ac2].rbg08,'') THEN
#                 CALL cl_err('',g_errno,1)
#                 LET g_rbg[l_ac2].rbg08 = g_rbg_o.rbg08
#                 NEXT FIELD rbg08     
#              END IF
#           END IF
#           #FUN-AB0025 ---------add end----------------
#           IF g_rbg_o.rbg08 IS NULL OR (g_rbg[l_ac2].rbg08 != g_rbg_o.rbg08 ) THEN               
#              CALL t403_rbg08('a',l_ac2) 
#              IF NOT cl_null(g_errno) THEN
#                 CALL cl_err(g_rbg[l_ac2].rbg08,g_errno,0)
#                 LET g_rbg[l_ac2].rbg08 = g_rbg_o.rbg08
#                 NEXT FIELD rbg08
#              END IF
#TQC-B10003 --ADD--begin
#           IF cl_null(g_rbg[l_ac2].rbg06_1) AND cl_null(g_rbg[l_ac2].rbg07_1) AND cl_null(g_rbg[l_ac2].rbg08_1) THEN
#              IF NOT cl_null(g_rbg[l_ac2].rbg07)  AND NOT cl_null(g_rbg[l_ac2].rbg06)  THEN
#                 SELECT COUNT(*) INTO l_n
#                  FROM rag_file
#                 WHERE rag01=g_rbe.rbe01 AND rag02=g_rbe.rbe02
#                   AND ragplant=g_rbe.rbeplant
#                   AND rag03=g_rbg[l_ac2].rbg06
#                   AND rag04=g_rbg[l_ac2].rbg07
#                   AND rag05=g_rbg[l_ac2].rbg08
#                 IF l_n=0 THEN
#                    IF NOT cl_confirm('art-678') THEN
#                       NEXT FIELD rbg06
#                    ELSE
#                       CALL t403_b2_init()
#                    END IF
#                 ELSE
#                    IF NOT cl_confirm('art-679') THEN
#                       NEXT FIELD rbg06
#                    ELSE
#                       CALL t403_b2_find()
#                    END IF
#                 END IF
#              END IF
#           END IF
#TQC-B10003 --ADD --END
#           END IF  
#        END IF  
#TQC-B10003 --ADD--- begin      
#     ON CHANGE rbg08
#        IF NOT cl_null(g_rbg[l_ac2].rbg08) THEN
#           IF g_rbg[l_ac2].rbg07 = '01' THEN
#              IF NOT s_chk_item_no(g_rbg[l_ac2].rbg08,'') THEN
#                 CALL cl_err('',g_errno,1)
#                 LET g_rbg[l_ac2].rbg08 = g_rbg_o.rbg08
#                 NEXT FIELD rbg08
#              END IF
#           END IF
#           IF g_rbg_o.rbg08 IS NULL OR (g_rbg[l_ac2].rbg08 != g_rbg_o.rbg08 ) THEN
#              CALL t403_rbg08('a',l_ac2)
#              IF NOT cl_null(g_errno) THEN
#                 CALL cl_err(g_rbg[l_ac2].rbg08,g_errno,0)
#                 LET g_rbg[l_ac2].rbg08 = g_rbg_o.rbg08
#                 NEXT FIELD rbg08
#              END IF
#           END IF
#        END IF 
#TQC-B10003 --ADD ---end
#     AFTER FIELD rbg09
#        IF NOT cl_null(g_rbg[l_ac2].rbg09) THEN
#           IF g_rbg_o.rbg09 IS NULL OR (g_rbg[l_ac2].rbg09 != g_rbg_o.rbg09 ) THEN               
#              CALL t403_rbg09('a')
#              IF NOT cl_null(g_errno) THEN
#                 CALL cl_err(g_rbg[l_ac2].rbg09,g_errno,0)
#                 LET g_rbg[l_ac2].rbg09 = g_rbg_o.rbg09
#                 NEXT FIELD rbg09
#              END IF
#           END IF  
#        END IF        
#       
#       BEFORE DELETE
#          #DISPLAY "BEFORE DELETE"
#          IF g_rbg_t.rbg06 > 0 AND g_rbg_t.rbg06 IS NOT NULL THEN
#             IF NOT cl_delb(0,0) THEN
#                CANCEL DELETE
#             END IF
#             IF l_lock_sw = "Y" THEN
#                CALL cl_err("", -263, 1)
#                CANCEL DELETE
#             END IF
#             IF cl_null(g_rbg_t.rbg09) THEN
#                LET g_rbg_t.rbg09=' '
#             END IF   
#             DELETE FROM rbg_file
#              WHERE rbg02 = g_rbe.rbe02   AND rbg01 = g_rbe.rbe01
#                AND rbg03 = g_rbe.rbe03   AND rbg04 = l_rbg04_curr
#                AND rbg06 = g_rbg_t.rbg06 
#                AND rbgplant = g_rbe.rbeplant
#             IF SQLCA.sqlcode THEN
#                CALL cl_err3("del","rbg_file",g_rbe.rbe02,g_rbg_t.rbg06,SQLCA.sqlcode,"","",1)
#                ROLLBACK WORK
#                CANCEL DELETE
#             END IF
#             CALL t403_upd_log() 
#             LET g_rec_b2=g_rec_b2-1
#          END IF
#          COMMIT WORK
#
#       ON ROW CHANGE
#          IF INT_FLAG THEN
#             CALL cl_err('',9001,0)
#             LET INT_FLAG = 0
#             LET g_rbg[l_ac2].* = g_rbg_t.*
#             CLOSE t4031_bcl
#             ROLLBACK WORK
#             EXIT INPUT
#          END IF
#          IF cl_null(g_rbg[l_ac2].rbg09) THEN
#             LET g_rbg[l_ac2].rbg09=' '
#          END IF 
#          IF cl_null(g_rbg_t.rbg09) THEN
#             LET g_rbg_t.rbg09=' '
#          END IF 
#          IF l_lock_sw = 'Y' THEN
#             CALL cl_err(g_rbg[l_ac2].rbg06,-263,1)
#             LET g_rbg[l_ac2].* = g_rbg_t.*
#          ELSE
#             IF g_rbg[l_ac2].rbg06<>g_rbg_t.rbg06 OR
#                g_rbg[l_ac2].rbg07<>g_rbg_t.rbg07 OR
#                g_rbg[l_ac2].rbg08<>g_rbg_t.rbg08 OR
#                g_rbg[l_ac2].rbg09<>g_rbg_t.rbg09 THEN
#                SELECT COUNT(*) INTO l_n FROM rbg_file
#                 WHERE rbg01 =g_rbe.rbe01 AND rbg02 = g_rbe.rbe02
#                   AND rbg03=g_rbe.rbe03
#                   AND rbg06 = g_rbg[l_ac2].rbg06 
#                   AND rbg07 = g_rbg[l_ac2].rbg07
#                   AND rbg08 = g_rbg[l_ac2].rbg08 
#                   AND rbg09 = g_rbg[l_ac2].rbg09
#                   AND rbgplant = g_rbe.rbeplant
#                IF l_n>0 THEN 
#                   CALL cl_err('',-239,0)
#                  #LET g_rbg[l_ac2].* = g_rbg_t.*
#                   NEXT FIELD rbg06
#                END IF
#             END IF                           
#                UPDATE rbg_file SET rbg06=g_rbg[l_ac2].rbg06,
#                                    rbg07=g_rbg[l_ac2].rbg07,
#                                    rbg08=g_rbg[l_ac2].rbg08,
#                                    rbg09=g_rbg[l_ac2].rbg09,
#                                    rbgacti=g_rbg[l_ac2].rbgacti
#                WHERE rbg02 = g_rbe.rbe02 AND rbg01=g_rbe.rbe01 AND rbg03=g_rbe.rbe03 
#                  AND rbg04 = l_rbg04_curr AND rbg05='1'
#                  AND rbg06=g_rbg_t.rbg06 AND rbg07=g_rbg_t.rbg07
#                  AND rbg08=g_rbg_t.rbg08 AND rbg09=g_rbg_t.rbg09
#                  AND rbgplant = g_rbe.rbeplant                
#             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                CALL cl_err3("upd","rbg_file",g_rbe.rbe02,g_rbg_t.rbg06,SQLCA.sqlcode,"","",1) 
#                LET g_rbg[l_ac2].* = g_rbg_t.*
#                ROLLBACK WORK 
#             ELSE                
#                CALL s_showmsg_init()
#                LET g_errno=' '
#                #CALL t403_repeat(g_rbg[l_ac1].rbg06)  #check
#                CALL s_showmsg()
#                IF NOT cl_null(g_errno) THEN
#                   LET g_rbg[l_ac2].* = g_rbg_t.*
#                   ROLLBACK WORK 
#                   NEXT FIELD PREVIOUS
#                ELSE
#                   #MESSAGE 'UPDATE O.K'
#                   CALL t403_upd_log() 
#                   COMMIT WORK
#                END IF              
#             END IF
#          END IF
#
#       AFTER ROW
#          #DISPLAY  "AFTER ROW!!"
#          LET l_ac2 = ARR_CURR()
#          LET l_ac2_t = l_ac2
#          IF INT_FLAG THEN
#             CALL cl_err('',9001,0)
#             LET INT_FLAG = 0
#             IF p_cmd = 'u' THEN
#                LET g_rbg[l_ac2].* = g_rbg_t.*
#             END IF
#             CLOSE t4031_bcl
#             ROLLBACK WORK
#             EXIT INPUT
#          END IF
#         #CALL t403_repeat(g_rbg[l_ac2].rbg06)  #check
#          CLOSE t4031_bcl
#          COMMIT WORK
#
#       ON ACTION CONTROLO
#          IF INFIELD(rbg06) AND l_ac2 > 1 THEN
#             LET g_rbg[l_ac2].* = g_rbg[l_ac2-1].*
#             LET g_rec_b2 = g_rec_b2+1
#            #LET l_rbg04_curr=l_rbg04_curr+1
#             NEXT FIELD rbg06
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
#            WHEN INFIELD(rbg08)
#                CALL cl_init_qry_var()
#                CASE g_rbg[l_ac2].rbg07
#                   WHEN '01'
#                    # IF cl_null(g_rtz05) THEN            #FUN-AB0101 mark
#FUN-AA0059---------mod------------str-----------------                       
#                          LET g_qryparam.form="q_ima"
#                         CALL q_sel_ima(FALSE, "q_ima","",g_rbg[l_ac2].rbg08,"","","","","",'' ) 
#                           RETURNING  g_rbg[l_ac2].rbg08
#FUN-AA0059---------mod------------end-----------------
#                   #  ELSE                                  #FUN-AB0101
#                   #     LET g_qryparam.form = "q_rtg03_1"  #FUN-AB0101 
#                   #     LET g_qryparam.arg1 = g_rtz05      #FUN-AB0101
#                   #  END IF                                #FUN-AB0101
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
#              # IF g_rbg[l_ac2].rbg07 != '01' OR (g_rbg[l_ac2].rbg07 = '01' AND NOT cl_null(g_rtz05)) THEN  #FUN-AA0059 ADD    #FUN-AB0101 mark
#                IF g_rbg[l_ac2].rbg07 != '01' THEN                             #FUN-AB0101 
#                   LET g_qryparam.default1 = g_rbg[l_ac2].rbg08
#                   CALL cl_create_qry() RETURNING g_rbg[l_ac2].rbg08
#                END IF   #FUN-AA0059  
#                CALL t403_rbg08('d',l_ac2)
#                NEXT FIELD rbg08
#             WHEN INFIELD(rbg09)
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = "q_gfe02"
#                SELECT DISTINCT ima25
#                  INTO l_ima25
#                  FROM ima_file
#                 WHERE ima01=g_rbg[l_ac2].rbg08  
#                LET g_qryparam.arg1 = l_ima25
#                LET g_qryparam.default1 = g_rbg[l_ac2].rbg09
#                CALL cl_create_qry() RETURNING g_rbg[l_ac2].rbg09
#                CALL t403_rbg09('d')
#                NEXT FIELD rbg09
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
#   CALL t403_upd_log()    
#   CLOSE t4031_bcl
#   COMMIT WORK

#END FUNCTION
#FUN-BC0078 mark START 
FUNCTION t403_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_rbe.rbe02 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF

   SELECT * INTO g_rbe.* FROM rbe_file
    WHERE rbe02 = g_rbe.rbe02 
      AND rbe01=g_rbe.rbe01
      AND rbe03 = g_rbe.rbe03  
      AND rbeplant = g_rbe.rbeplant

    IF g_rbe.rbeacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_rbe.rbe02,9027,0)
       RETURN
    END IF
    #TQC-AC0326 add begin------------
    IF g_rbe.rbeplant<>g_plant THEN
       CALL cl_err('','art-024',0)
       RETURN
    END IF    
    #TQC-AC0326 add end--------------
    #IF g_rbe.rbeconf = 'Y' THEN
    IF g_rbe.rbeconf = 'Y' OR g_rbe.rbeconf = 'I'  THEN
       CALL cl_err('','art-024',0)
       RETURN
    END IF
    #TQC-AC0326 add ---------begin----------
    IF g_rbe.rbe01 <> g_rbe.rbeplant THEN
       CALL cl_err('','art-977',0)
       RETURN
    END IF
    #TQC-AC0326 add ----------end-----------
    #FUN-AB0033 mark ------start------
    #IF g_rbe.rbeconf = 'X' THEN
    #   CALL cl_err('','art-025',0)
    #   RETURN
    #END IF
    #FUN-AB0033 mark -------end-------
    CALL cl_opmsg('u')

    LET g_rbe01_t = g_rbe.rbe01
    LET g_rbe02_t = g_rbe.rbe02  
    LET g_rbe03_t = g_rbe.rbe03  
    LET g_rbeplant_t = g_rbe.rbeplant 
    LET g_rbe_o.* = g_rbe.*

    BEGIN WORK
    LET g_success ='Y'
 
    OPEN t403_cl USING g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,g_rbe.rbeplant
    IF STATUS THEN
       CALL cl_err("OPEN t403_cl:", STATUS, 1)
       CLOSE t403_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t403_cl INTO g_rbe.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rbe.rbe01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t403_cl
        ROLLBACK WORK
        RETURN
    END IF

    CALL t403_show()
    WHILE TRUE
        LET g_rbe01_t = g_rbe.rbe01
        LET g_rbe02_t = g_rbe.rbe02   
        LET g_rbe03_t = g_rbe.rbe03   
        LET g_rbeplant_t = g_rbe.rbeplant 
        LET g_rbe.rbemodu=g_user
        LET g_rbe.rbedate=g_today
        CALL t403_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET g_success ='N'
            LET INT_FLAG = 0
            LET g_rbe.*=g_rbe_o.*
            CALL t403_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        UPDATE rbe_file SET rbe_file.* = g_rbe.*
            WHERE rbe01 = g_rbe.rbe01 AND rbe02 = g_rbe.rbe02
              AND rbe03 = g_rbe.rbe03 AND rbeplant = g_rbe.rbeplant
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           CALL cl_err3("upd","rbe_file","","",SQLCA.sqlcode,"","",1)
           CONTINUE WHILE
        END IF 
        EXIT WHILE
    END WHILE
    CLOSE t403_cl
    COMMIT WORK
    CALL cl_flow_notify(g_rbe.rbe02,'U')
    CALL cl_set_act_visible("alter_gift",g_rbe.rbe27t='Y')
    CALL t403_b1_fill("1=1")
    CALL t403_b2_fill("1=1")
    CALL t403_b3_fill(g_wc2) #FUN-BC0078 add
 
    COMMIT WORK
END FUNCTION 
 
FUNCTION t403_r()
   DEFINE l_flag LIKE type_file.chr1 
    IF s_shut(0) THEN RETURN END IF
    IF g_rbe.rbe02 IS NULL THEN
       CALL cl_err("",-400,0)                  
       RETURN
    END IF
 
    SELECT * INTO g_rbe.* FROM rbe_file
    WHERE rbe02 = g_rbe.rbe02 AND rbe01=g_rbe.rbe01
      AND rbe03 = g_rbe.rbe03 AND rbeplant = g_rbe.rbeplant

    IF g_rbe.rbeacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_rbe.rbe02,9027,0)
       RETURN
    END IF

    IF g_rbe.rbeconf = 'Y' OR  g_rbe.rbeconf = 'I'  THEN
       CALL cl_err('','art-023',0)
       RETURN
    END IF
    #FUN-AB0033 mark ------start------
    #IF g_rbe.rbeconf = 'X' THEN
    #   CALL cl_err('','9024',0)
    #   RETURN
    #END IF
    #FUN-AB0033 mark ------start------
    BEGIN WORK
 
    OPEN t403_cl USING g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,g_rbe.rbeplant
    IF STATUS THEN
       CALL cl_err("OPEN t403_cl:", STATUS, 1)
       CLOSE t403_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t403_cl INTO g_rbe.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rbe.rbe02,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL t403_show()
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL            
        LET g_doc.column1 = "rbe01"          
        LET g_doc.column2 = "rbe02"           
        LET g_doc.value1 = g_rbe.rbe01        
        LET g_doc.value2 = g_rbe.rbe02       
        CALL cl_del_doc()               
         DELETE FROM rbe_file WHERE rbe01 = g_rbe.rbe01
                                AND rbe02 = g_rbe.rbe02
                                AND rbe03 = g_rbe.rbe03
                                AND rbeplant = g_rbe.rbeplant
         DELETE FROM rbf_file WHERE rbf01 = g_rbe.rbe01
                                AND rbf02 = g_rbe.rbe02
                                AND rbf03 = g_rbe.rbe03
                                AND rbfplant = g_rbe.rbeplant
         DELETE FROM rbg_file WHERE rbg01 = g_rbe.rbe01
                                AND rbg02 = g_rbe.rbe02 
                                AND rbg03 = g_rbe.rbe03
                                AND rbgplant = g_rbe.rbeplant 
         DELETE FROM rbq_file WHERE rbq01 = g_rbe.rbe01
                                AND rbq02 = g_rbe.rbe02 
                                AND rbq03 = g_rbe.rbe03
                                AND rbqplant = g_rbe.rbeplant
                                AND rbq04='2'
         DELETE FROM rbp_file WHERE rbp01 = g_rbe.rbe01
                                AND rbp02 = g_rbe.rbe02
                                AND rbp03 = g_rbe.rbe03
                                AND rbpplant = g_rbe.rbeplant
                                AND rbp04='2'
         DELETE FROM rbr_file WHERE rbr01 = g_rbe.rbe01
                                AND rbr02 = g_rbe.rbe02 
                                AND rbr03 = g_rbe.rbe03
                                AND rbrplant = g_rbe.rbeplant
                                AND rbr04='2'
         DELETE FROM rbs_file WHERE rbs01 = g_rbe.rbe01
                                AND rbs02 = g_rbe.rbe02
                                AND rbs03 = g_rbe.rbe03
                                AND rbsplant = g_rbe.rbeplant
                                AND rbs04='2'                       
       #FUN-BC0078 add START
         DELETE FROM rbk_file WHERE rbk01 = g_rbe.rbe01
                                AND rbk02 = g_rbe.rbe02
                                AND rbk03 = g_rbe.rbe03
                                AND rbkplant = g_rbe.rbeplant
                                AND rbk05='2'
       #FUN-BC0078 add END
         INITIALIZE g_rbe.* TO NULL
         CLEAR FORM
         CALL g_rbf.clear()
         CALL g_rbg.clear()
         CALL g_rbk.clear()  #FUN-BC0078 add
         OPEN t403_count
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE t403_cs
            CLOSE t403_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         FETCH t403_count INTO g_row_count
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t403_cs
            CLOSE t403_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t403_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t403_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL t403_fetch('/')
         END IF
    END IF
    COMMIT WORK
END FUNCTION

#FUNCTION t403_rbg07_chk() 
#   DEFINE l_rbf07   LIKE rbf_file.rbf07
#   SELECT DISTINCT rbf07 INTO l_rbf07 FROM rbf_file
#    WHERE rbf01=g_rbe.rbe01 AND rbf02=g_rbe.rbe02
#      AND rbfplant=g_rbe.rbeplant AND rbf05='1'
#      AND rbf03=g_rbg[l_ac2].rbg06
#
#   IF cl_null(l_rbf07) THEN
#      SELECT DISTINCT raf04 INTO l_rbf07 FROM raf_file
#       WHERE raf01=g_rbe.rbe01 AND raf02 = g_rbe.rbe02
#         AND rafplant =g_rbe.rbeplant 
#         AND raf03=g_rbg[l_ac2].rbg06
#   END IF
#
#   IF l_rbf07 = '1' THEN
#      LET g_rbg[l_ac2].rbg07='01'
#      CALL cl_set_comp_entry("rbg07",FALSE) 
#   ELSE
#      CALL cl_set_comp_entry("rbg07",TRUE)
#   END IF
#END FUNCTION

FUNCTION t403_rbg06() 
   DEFINE l_n     LIKE type_file.num5
   DEFINE l_racacti     LIKE rac_file.racacti
   LET g_errno = ' '
   LET l_n=0

   SELECT COUNT(*) INTO l_n FROM rbf_file
    WHERE rbf01 = g_rbe.rbe01 AND rbf02 = g_rbe.rbe02
      AND rbf03 = g_rbe.rbe03 AND rbfplant=g_rbe.rbeplant
      AND rbf06 = g_rbg[l_ac2].rbg06 AND rbf05='1'
      AND rbfacti='Y'

   IF l_n<1 THEN  
      SELECT COUNT(*) INTO l_n FROM raf_file
       WHERE raf01=g_rbe.rbe01 AND raf02=g_rbe.rbe02
         AND rafplant=g_rbe.rbeplant 
         AND raf03=g_rbg[l_ac2].rbg06
         AND rafacti='Y'
      IF l_n<1 THEN
         LET g_errno = 'art-669'     #當前組別不在第一單身中,也不在原促銷單中
      END IF
   END IF
END FUNCTION

FUNCTION t403_rbg07()
   IF g_rbg[l_ac2].rbg07='01' THEN
      CALL cl_set_comp_entry("rbg09",TRUE)
      CALL cl_set_comp_required("rbg09",TRUE)
   ELSE
      CALL cl_set_comp_entry("rbg09",FALSE)
   END IF
END FUNCTION

FUNCTION t403_rbg08_1(p_cmd,p_cnt)
   DEFINE l_n         LIKE type_file.num5
   DEFINE p_cmd       LIKE type_file.chr1 
   DEFINE p_cnt       LIKE type_file.num5 
   DEFINE l_imaacti   LIKE ima_file.imaacti, 
          l_ima02     LIKE ima_file.ima02,
          l_ima25     LIKE ima_file.ima25
   DEFINE l_obaacti   LIKE oba_file.obaacti,
          l_oba02     LIKE oba_file.oba02
   DEFINE l_tqaacti   LIKE tqa_file.tqaacti,
          l_tqa02     LIKE tqa_file.tqa02,
          l_tqa05     LIKE tqa_file.tqa05,
          l_tqa06     LIKE tqa_file.tqa06
   LET g_errno = ' '   
   
   CASE g_rbg[p_cnt].rbg07_1
      WHEN '01'
       #IF cl_null(g_rtz05) THEN      #FUN-AB0101 mark
        IF cl_null(g_rtz04) THEN      #FUN-AB0101
           SELECT DISTINCT ima02,ima25,imaacti
             INTO l_ima02,l_ima25,l_imaacti
             FROM ima_file
            WHERE ima01=g_rbg[p_cnt].rbg08_1  
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
            WHERE ima01 = rte03 AND ima01=g_rbg[p_cnt].rbg08_1
              AND rte01 = g_rtz04                               #FUN-AB0101 
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
          WHERE oba01=g_rbg[p_cnt].rbg08_1 AND obaacti='Y'
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
          WHERE tqa01=g_rbg[p_cnt].rbg08_1 AND tqa03='1' AND tqaacti='Y' 
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
          WHERE tqa01=g_rbg[p_cnt].rbg08_1 AND tqa03='2' AND tqaacti='Y'
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
          WHERE tqa01=g_rbg[p_cnt].rbg08_1 AND tqa03='3' AND tqaacti='Y'
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
          WHERE tqa01=g_rbg[p_cnt].rbg08_1 AND tqa03='4' AND tqaacti='Y'
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
          WHERE tqa01=g_rbg[p_cnt].rbg08_1 AND tqa03='5' AND tqaacti='Y'
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
          WHERE tqa01=g_rbg[p_cnt].rbg08_1 AND tqa03='6' AND tqaacti='Y'
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
          WHERE tqa01=g_rbg[p_cnt].rbg08_1 AND tqa03='27' AND tqaacti='Y'
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
      CASE g_rbg[p_cnt].rbg07_1
         WHEN '01'
            LET g_rbg[p_cnt].rbg08_1_desc = l_ima02
            IF cl_null(g_rbg[p_cnt].rbg09_1) THEN
               LET g_rbg[p_cnt].rbg09_1   = l_ima25
            END IF
            SELECT gfe02 INTO g_rbg[p_cnt].rbg09_1_desc FROM gfe_file
             WHERE gfe01=g_rbg[p_cnt].rbg09_1 AND gfeacti='Y'
         WHEN '02'
            LET g_rbg[p_cnt].rbg09_1 = ''
            LET g_rbg[p_cnt].rbg09_1_desc = ''
            LET g_rbg[p_cnt].rbg08_1_desc = l_oba02
         WHEN '09'
            LET g_rbg[p_cnt].rbg09_1 = ''
            LET g_rbg[p_cnt].rbg09_1_desc = ''
            LET g_rbg[p_cnt].rbg08_1_desc = l_tqa02 CLIPPED,">"
            LET l_tqa02 = l_tqa05
            LET g_rbg[p_cnt].rbg08_1_desc = g_rbg[p_cnt].rbg08_1_desc CLIPPED,":",l_tqa02 CLIPPED,"-"
            LET l_tqa02 = l_tqa06
            LET g_rbg[p_cnt].rbg08_1_desc = g_rbg[p_cnt].rbg08_1_desc CLIPPED,l_tqa02 CLIPPED
         OTHERWISE
            LET g_rbg[p_cnt].rbg09_1 = ''
            LET g_rbg[p_cnt].rbg09_1_desc = ''
            LET g_rbg[p_cnt].rbg08_1_desc = l_tqa02
      END CASE
      DISPLAY BY NAME g_rbg[p_cnt].rbg08_1_desc,g_rbg[p_cnt].rbg09_1,g_rbg[p_cnt].rbg09_1_desc
   END IF
END FUNCTION

FUNCTION t403_rbg09(p_cmd)
    DEFINE p_cmd       LIKE type_file.chr1   
    DEFINE l_gfe02     LIKE gfe_file.gfe02
    DEFINE l_gfeacti   LIKE gfe_file.gfeacti
    DEFINE l_ima25     LIKE ima_file.ima25
    DEFINE l_flag      LIKE type_file.num5,
           l_fac       LIKE ima_file.ima31_fac   
   LET g_errno = ' '
   IF g_rbg[l_ac2].rbg07<>'01' THEN
      RETURN
   END IF
   IF NOT cl_null(g_rbg[l_ac2].rbg08) THEN
      SELECT DISTINCT ima25
        INTO l_ima25
        FROM ima_file
       WHERE ima01=g_rbg[l_ac2].rbg08 
      CALL s_umfchk(g_rbg[l_ac2].rbg08,l_ima25,g_rbg[l_ac2].rbg09)
         RETURNING l_flag,l_fac   
      IF l_flag = 1 THEN
         LET g_errno = 'ams-823'
         RETURN
      END IF
   END IF
   SELECT gfe02,gfeacti
     INTO l_gfe02,l_gfeacti
     FROM gfe_file 
    WHERE gfe01 = g_rbg[l_ac2].rbg09 AND gfeacti = 'Y' 
   CASE 
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'mfg3377'
      WHEN l_gfeacti='N'       LET g_errno ='9028'
      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------' 
   END CASE
   IF cl_null(g_errno) OR p_cmd='d' THEN 
      LET g_rbg[l_ac2].rbg09_desc=l_gfe02
      DISPLAY BY NAME g_rbg[l_ac2].rbg09_desc
   END IF    
END FUNCTION 

FUNCTION t403_upd_log()
   LET g_rbe.rbemodu = g_user
   LET g_rbe.rbedate = g_today
   UPDATE rbe_file SET rbemodu = g_rbe.rbemodu,
                       rbedate = g_rbe.rbedate
    WHERE rbe01 = g_rbe.rbe01 AND rbe02 = g_rbe.rbe02
      AND rbe03 = g_rbe.rbe03 AND rbeplant = g_rbe.rbeplant
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","rbe_file",g_rbe.rbemodu,g_rbe.rbedate,SQLCA.sqlcode,"","",1)
   END IF
   DISPLAY BY NAME g_rbe.rbemodu,g_rbe.rbedate
   MESSAGE 'UPDATE rbe_file O.K.'
END FUNCTION

FUNCTION t403_chktime(p_time)  #check 時間格式
    #yemy 20130517  --Begin
    DEFINE p_time      LIKE type_file.chr8   
    DEFINE l_second    LIKE type_file.num5
    #yemy 20130517  --End  
    DEFINE l_hour      LIKE type_file.num5
    DEFINE l_min       LIKE type_file.num5 
    LET g_errno=''
    IF p_time[1,1] MATCHES '[012]' AND
       p_time[2,2] MATCHES '[0123456789]' AND
       p_time[3,3] =':' AND
       p_time[4,4] MATCHES '[012345]' AND 
       p_time[5,5] MATCHES '[0123456789]' AND
       #yemy 20130517  --Begin
       p_time[6,6] =':' AND
       p_time[7,7] MATCHES '[012345]' AND 
       p_time[8,8] MATCHES '[0123456789]' THEN
       #yemy 20130517  --End  
       IF p_time[1,2]<'00' OR p_time[1,2]>='24' OR
          p_time[4,5]<'00' OR p_time[4,5]>='60' OR
       #yemy 20130517  --Begin
          p_time[7,8]<'00' OR p_time[7,8]>='60' THEN
       #yemy 20130517  --End  
          LET g_errno='art-209' 
       END IF
    ELSE
       LET g_errno='art-209'
    END IF
    IF cl_null(g_errno) THEN         
       LET l_hour=p_time[1,2]
       LET l_min = p_time[4,5]
       #yemy 20130517  --Begin
       #RETURN l_hour*60+l_min
       RETURN l_hour*3600+l_min*60+l_second
       #yemy 20130517  --End  
    ELSE
       RETURN NULL
    END IF
END FUNCTION

FUNCTION t403_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1 
   #新增時rbe02開放
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("rbe02",TRUE)
      CALL cl_set_comp_required("rbe02",TRUE)
   END IF
   #CALL cl_set_comp_entry("rbemksg",TRUE) #FUN-AB0033 mark
 #  CALL cl_set_comp_entry("rbemksg",FALSE)  #FUN-AB0033 add   #FUN-B30028 mark
  #FUN-BC0078 mark START
  #CALL cl_set_comp_entry("g_rbe.rbe04t,g_rbe.rbe05t,g_rbe.rbe06t,g_rbe.rbe07t,  
  #                        g_rbe.rbe14t,g_rbe.rbe15t,g_rbe.rbe16t,g_rbe.rbe17t,
  #                        g_rbe.rbe18t,g_rbe.rbe19t,g_rbe.rbe20t,g_rbe.rbe21t,
  #                        g_rbe.rbe23t,g_rbe.rbe24t,g_rbe.rbe25t,g_rbe.rbe26t,
  #                        g_rbe.rbe27t,g_rbe.rbe28t,g_rbe.rbe29t,g_rbe.rbe30t,  
  #                        g_rbe.rbe31t",TRUE)                                   
  #FUN-BC0078 mark END
   CALL cl_set_comp_entry("g_rbe.rbe10t,g_rbe.rbe11t,g_rbe.rbe12t,g_rbe.rbe13t,
                           g_rbe.rbe14t,g_rbe.rbe15t,g_rbe.rbe16t,g_rbe.rbe17t,
                           g_rbe.rbe18t,g_rbe.rbe19t,g_rbe.rbe20t,g_rbe.rbe21t,
                           g_rbe.rbe23t,g_rbe.rbe24t,g_rbe.rbe25t,g_rbe.rbe26t,
                           g_rbe.rbe27t",TRUE)                                   #FUN-BC0078  add
END FUNCTION

FUNCTION t403_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey = 'N' THEN
      CALL cl_set_comp_entry("rbe02",FALSE)  
   END IF
END FUNCTION 
 
FUNCTION t403_x()
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rbe.rbe02 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   IF g_rbe.rbeconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   #IF g_rbe.rbeconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF #FUN-AB0033 mark 
   #IF g_rbe.rbeconf = 'I' THEN CALL cl_err('',9023,0) RETURN END IF #FUN-AB0033 mark 
   BEGIN WORK 
   OPEN t403_cl USING g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,g_rbe.rbeplant
   IF STATUS THEN
      CALL cl_err("OPEN t403_cl:", STATUS, 1)
      CLOSE t403_cl
      RETURN
   END IF
 
   FETCH t403_cl INTO g_rbe.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rbe.rbe01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   LET g_success = 'Y' 
   CALL t403_show() 
   IF cl_exp(0,0,g_rbe.rbeacti) THEN
      LET g_chr=g_rbe.rbeacti
      IF g_rbe.rbeacti='Y' THEN
         LET g_rbe.rbeacti='N'
      ELSE
         LET g_rbe.rbeacti='Y'
      END IF
 
      UPDATE rbe_file SET rbeacti=g_rbe.rbeacti,
                          rbemodu=g_user,
                          rbedate=g_today
       WHERE rbe02 = g_rbe.rbe02 AND rbe01=g_rbe.rbe01
         AND rbe03 = g_rbe.rbe03 AND rbeplant = g_rbe.rbeplant
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","rbe_file",g_rbe.rbe01,"",SQLCA.sqlcode,"","",1) 
         LET g_rbe.rbeacti=g_chr
      END IF
   END IF
 
   CLOSE t403_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_rbe.rbe02,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT rbeacti,rbemodu,rbedate
     INTO g_rbe.rbeacti,g_rbe.rbemodu,g_rbe.rbedate FROM rbe_file 
       WHERE rbe02 = g_rbe.rbe02 AND rbe01=g_rbe.rbe01
         AND rbe03 = g_rbe.rbe03 AND rbeplant = g_rbe.rbeplant

   DISPLAY BY NAME g_rbe.rbeacti,g_rbe.rbemodu,g_rbe.rbedate
END FUNCTION 

FUNCTION t403_b2_find()
   LET g_rbg[l_ac2].type1  ='1'
   LET g_rbg[l_ac2].before1='0'
   LET g_rbg[l_ac2].after1 ='1'
   
   SELECT rag03,rag04,rag05,rag06,ragacti  
     INTO g_rbg[l_ac2].rbg06_1,g_rbg[l_ac2].rbg07_1,g_rbg[l_ac2].rbg08_1,
          g_rbg[l_ac2].rbg09_1,g_rbg[l_ac2].rbgacti_1
     FROM rag_file
    WHERE rag01=g_rbe.rbe01 AND rag02=g_rbe.rbe02 AND ragplant=g_rbe.rbeplant
      AND rag03=g_rbg[l_ac2].rbg06 AND rag04=g_rbg[l_ac2].rbg07 AND rag05 =g_rbg[l_ac2].rbg08  #TQC-B10003
      
   CALL t403_rbg08_1('d',l_ac2)
   IF NOT cl_null(g_rbg[l_ac2].rbg09_1) THEN
      SELECT gfe02 INTO g_rbg[l_ac2].rbg09_1_desc 
        FROM gfe_file
       WHERE gfe01 = g_rbg[l_ac2].rbg09_1  
      DISPLAY BY NAME g_rbg[l_ac2].rbg09_1_desc
   END IF   
   DISPLAY BY NAME g_rbg[l_ac2].rbg06_1,g_rbg[l_ac2].rbg07_1,g_rbg[l_ac2].rbg08_1,
                   g_rbg[l_ac2].rbg09_1,g_rbg[l_ac2].rbgacti_1
      
   DISPLAY BY NAME g_rbg[l_ac2].type1,g_rbg[l_ac2].before1,g_rbg[l_ac2].after1
END FUNCTION 

FUNCTION t403_b2_init()
   LET g_rbg[l_ac2].type1    ='0'
   LET g_rbg[l_ac2].before1  =' '
   LET g_rbg[l_ac2].after1   ='1'
   LET g_rbg[l_ac2].rbg06_1 = NULL
   LET g_rbg[l_ac2].rbg07_1 = NULL
   LET g_rbg[l_ac2].rbg08_1 = NULL
   LET g_rbg[l_ac2].rbg08_1_desc = NULL
   LET g_rbg[l_ac2].rbg09_1 = NULL
   LET g_rbg[l_ac2].rbg08_1_desc = NULL
   LET g_rbg[l_ac2].rbgacti_1 = NULL
   CALL t403_rbg07()
END FUNCTION 

#根據促銷方式不同顯示相應的字段  
FUNCTION t403_rbe10t_entry(p_rbe10t)
DEFINE p_rbe10t    LIKE rbe_file.rbe10   

   CASE p_rbe10t
      WHEN '1'
         CALL cl_set_comp_entry("rbe15t",TRUE)
         CALL cl_set_comp_entry("rbe16t",FALSE)
         CALL cl_set_comp_entry("rbe17t",FALSE)
         CALL cl_set_comp_required("rbe15t",TRUE)
         IF NOT cl_null(g_rbe_o.rbe15t) THEN  #FUN-AB0033 add
         LET g_rbe.rbe15t = g_rbe_o.rbe15t  #特賣價
         END IF     #FUN-AB0033 add
         LET g_rbe.rbe17t = 0              #折讓額
      WHEN '2'
         CALL cl_set_comp_entry("rbe15t",FALSE)
         CALL cl_set_comp_entry("rbe16t",TRUE)
         CALL cl_set_comp_entry("rbe17t",FALSE)
         CALL cl_set_comp_required("rbe16t",TRUE)
         LET g_rbe.rbe15t = 0              #特賣價
         LET g_rbe.rbe17t = 0              #折讓額
      WHEN '3'
         CALL cl_set_comp_entry("rbe15t",FALSE)
         CALL cl_set_comp_entry("rbe16t",FALSE)
         CALL cl_set_comp_entry("rbe17t",TRUE)
         CALL cl_set_comp_required("rbe17t",TRUE)
         LET g_rbe.rbe15t = 0              #特賣價
         IF NOT cl_null(g_rbe_o.rbe17t) THEN    #FUN-AB0033 add
         LET g_rbe.rbe17t = g_rbe_o.rbe17t  #折讓額
         END IF          #FUN-AB0033 add
      OTHERWISE
         CALL cl_set_comp_entry("rbe15t",TRUE)
         CALL cl_set_comp_entry("rbe16t",TRUE)
         CALL cl_set_comp_entry("rbe17t",TRUE)
         CALL cl_set_comp_required("rbe15t",TRUE)
         CALL cl_set_comp_required("rbe16t",TRUE)
         CALL cl_set_comp_required("rbe17t",TRUE)
         IF NOT cl_null(g_rbe_o.rbe15t) AND NOT cl_null(g_rbe_o.rbe17t) THEN   #FUN-AB0033 add
         LET g_rbe.rbe15t = g_rbe_o.rbe15t  #特賣價
         LET g_rbe.rbe17t = g_rbe_o.rbe17t  #折讓額
         END IF     #FUN-AB0033 add
   END CASE    
  #IF g_rbe.rbe12t = 'Y' THEN  #FUN-BC0078 mark
   IF g_rbe.rbe12t <> '0' THEN  #FUN-BC0078 add
      CALL cl_set_comp_entry("rbe18t,rbe19t,rbe20t",FALSE)
      LET g_rbe.rbe18t = 0              #會員特賣價
      LET g_rbe.rbe20t = 0              #會員折讓額      
   ELSE
      CASE p_rbe10t
         WHEN '1'
            CALL cl_set_comp_entry("rbe18t",TRUE)
            CALL cl_set_comp_entry("rbe19t",FALSE)
            CALL cl_set_comp_entry("rbe20t",FALSE)
            CALL cl_set_comp_required("rbe18t",TRUE)
            IF NOT cl_null(g_rbe_o.rbe18t) THEN   #FUN-AB0033 add
            LET g_rbe.rbe18t = g_rbe_o.rbe18t  #會員特賣價
            END IF                           #FUN-AB0033 add
            LET g_rbe.rbe20t = 0              #會員折讓額      
         WHEN '2'
            CALL cl_set_comp_entry("rbe18t",FALSE)
            CALL cl_set_comp_entry("rbe19t",TRUE)
            CALL cl_set_comp_entry("rbe20t",FALSE)
            CALL cl_set_comp_required("rbe19t",TRUE)
            LET g_rbe.rbe18t = 0              #會員特賣價
            LET g_rbe.rbe20t = 0              #會員折讓額      
         WHEN '3'
            CALL cl_set_comp_entry("rbe18t",FALSE)
            CALL cl_set_comp_entry("rbe19t",FALSE)
            CALL cl_set_comp_entry("rbe20t",TRUE)
            CALL cl_set_comp_required("rbe20t",TRUE)
            LET g_rbe.rbe18t = 0              #會員特賣價
            IF NOT cl_null(g_rbe_o.rbe20t) THEN   #FUN-AB0033 add
            LET g_rbe.rbe20t = g_rbe_o.rbe20t  #會員折讓額   
            END IF     #FUN-AB0033 add
         OTHERWISE 
            CALL cl_set_comp_entry("rbe18t",TRUE)
            CALL cl_set_comp_entry("rbe19t",TRUE)
            CALL cl_set_comp_entry("rbe20t",TRUE)
            CALL cl_set_comp_required("rbe18t",TRUE)
            CALL cl_set_comp_required("rbe19t",TRUE)
            CALL cl_set_comp_required("rbe20t",TRUE)
            IF NOT cl_null(g_rbe_o.rbe18t) AND NOT cl_null(g_rbe_o.rbe20t) THEN  #FUN-AB0033 add
            LET g_rbe.rbe18t = g_rbe_o.rbe18t  #會員特賣價
            LET g_rbe.rbe20t = g_rbe_o.rbe20t  #會員折讓額   
            END IF     #FUN-AB0033 add
      END CASE
      IF g_rbe.rbe11t = 'Y' THEN
         CALL cl_set_comp_entry("rbe15t,rbe16t,rbe17t",FALSE)
         LET g_rbe.rbe15t = 0             
         LET g_rbe.rbe16t = 0              
         LET g_rbe.rbe17t = 0       
     END IF    
   END IF    
END FUNCTION

FUNCTION t403_rbe21t_check()
   DEFINE l_sum,l_sum1     LIKE rbe_file.rbe21
   LET g_errno=' '
   IF NOT cl_null(g_rbe.rbe21t) AND g_rbe.rbe21t<>0 THEN
      SELECT SUM(raf05) INTO l_sum FROM raf_file
          WHERE raf01 = g_rbe.rbe01
            AND raf02 = g_rbe.rbe02
            AND rafplant = g_rbe.rbeplant 
            AND rafacti  = 'Y'
            AND raf03 NOT IN 
         (SELECT rbf06 FROM rbf_file
          WHERE rbf01 = g_rbe.rbe01
            AND rbf02 = g_rbe.rbe02
            AND rbf03 = g_rbe.rbe03
            AND rbf05 = '0'
            AND rbfplant = g_rbe.rbeplant 
            AND rbfacti  = 'Y' )      
         SELECT SUM(rbf08) INTO l_sum1 FROM rbf_file
          WHERE rbf01 = g_rbe.rbe01
            AND rbf02 = g_rbe.rbe02
            AND rbf03 = g_rbe.rbe03
            AND rbf05 = '1'
            AND rbfplant = g_rbe.rbeplant 
            AND rbfacti  = 'Y'
      IF cl_null(l_sum) THEN
         LET l_sum = 0
      END IF 
      IF cl_null(l_sum1) THEN
         LET l_sum1 = 0
      END IF      
      LET l_sum = l_sum + l_sum1      
      IF g_rbe.rbe21t<l_sum THEN
         LET g_errno='art-657'
         RETURN
      END IF
   END IF 
END FUNCTION
  
FUNCTION t403_rbg08(p_cmd,p_cnt)
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
   
   CASE g_rbg[p_cnt].rbg07
      WHEN '01'
      # IF cl_null(g_rtz05) THEN                 #FUN-AB01010
        IF cl_null(g_rtz04) THEN                 #FUN-AB01010
           SELECT DISTINCT ima02,ima25,imaacti
             INTO l_ima02,l_ima25,l_imaacti
             FROM ima_file
            WHERE ima01=g_rbg[p_cnt].rbg08  
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
            WHERE ima01 = rte03 AND ima01=g_rbg[p_cnt].rbg08
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
          WHERE oba01=g_rbg[p_cnt].rbg08 AND obaacti='Y'
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
          WHERE tqa01=g_rbg[p_cnt].rbg08 AND tqa03='1' AND tqaacti='Y' 
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
          WHERE tqa01=g_rbg[p_cnt].rbg08 AND tqa03='2' AND tqaacti='Y'
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
          WHERE tqa01=g_rbg[p_cnt].rbg08 AND tqa03='3' AND tqaacti='Y'
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
          WHERE tqa01=g_rbg[p_cnt].rbg08 AND tqa03='4' AND tqaacti='Y'
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
          WHERE tqa01=g_rbg[p_cnt].rbg08 AND tqa03='5' AND tqaacti='Y'
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
          WHERE tqa01=g_rbg[p_cnt].rbg08 AND tqa03='6' AND tqaacti='Y'
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
          WHERE tqa01=g_rbg[p_cnt].rbg08 AND tqa03='27' AND tqaacti='Y'
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
      CASE g_rbg[p_cnt].rbg07
         WHEN '01'
            LET g_rbg[p_cnt].rbg08_desc = l_ima02
            IF cl_null(g_rbg[p_cnt].rbg09) THEN
               LET g_rbg[p_cnt].rbg09   = l_ima25
            END IF
            SELECT gfe02 INTO g_rbg[p_cnt].rbg09_desc FROM gfe_file
             WHERE gfe01=g_rbg[p_cnt].rbg09 AND gfeacti='Y'
         WHEN '02'
            LET g_rbg[p_cnt].rbg09 = ''
            LET g_rbg[p_cnt].rbg09_desc = ''
            LET g_rbg[p_cnt].rbg08_desc = l_oba02
         WHEN '09'
            LET g_rbg[p_cnt].rbg09 = ''
            LET g_rbg[p_cnt].rbg09_desc = ''
            LET g_rbg[p_cnt].rbg08_desc = l_tqa02 CLIPPED,">"
            LET l_tqa02 = l_tqa05
            LET g_rbg[p_cnt].rbg08_desc = g_rbg[p_cnt].rbg08_desc CLIPPED,":",l_tqa02 CLIPPED,"-"
            LET l_tqa02 = l_tqa06
            LET g_rbg[p_cnt].rbg08_desc = g_rbg[p_cnt].rbg08_desc CLIPPED,l_tqa02 CLIPPED
         OTHERWISE
            LET g_rbg[p_cnt].rbg09 = ''
            LET g_rbg[p_cnt].rbg09_desc = ''
            LET g_rbg[p_cnt].rbg08_desc = l_tqa02
      END CASE
      DISPLAY BY NAME g_rbg[p_cnt].rbg08_desc,g_rbg[p_cnt].rbg09,g_rbg[p_cnt].rbg09_desc
   END IF
END FUNCTION 
  
FUNCTION t403_rbf_entry(p_rbf07)
   DEFINE p_rbf07    LIKE rbf_file.rbf07
   IF p_rbf07='1' THEN
      CALL cl_set_comp_entry("rbf08",TRUE)
      CALL cl_set_comp_required("rbf08",TRUE)
      IF cl_null(g_rbf_o.rbf08) THEN
         LET g_rbf_o.rbf08 = 0
      END IF
      LET g_rbf[l_ac1].rbf08=g_rbf_o.rbf08
      DISPLAY BY NAME g_rbf[l_ac1].rbf08
   ELSE 
      CALL cl_set_comp_entry("rbf08",FALSE)   
      LET g_rbf[l_ac1].rbf08=0
      DISPLAY BY NAME g_rbf[l_ac1].rbf08
   END IF
END FUNCTION

FUNCTION t403_rbf08_check(p_rbf08)
   DEFINE p_rbf08    LIKE rbf_file.rbf08
   DEFINE l_sum      LIKE rbf_file.rbf08
   DEFINE l_sum1     LIKE rbf_file.rbf08
   DEFINE l_sum2     LIKE rbf_file.rbf08
   LET g_errno=' '   
   IF g_rbf[l_ac1].rbf07='1' THEN
      IF p_rbf08<=0 THEN
         LET g_errno='aem-042'
         RETURN
      END IF
   END IF
   IF NOT cl_null(g_rbe.rbe21t) AND g_rbe.rbe21t<>0 THEN
      IF p_rbf08>g_rbe.rbe21t THEN
         LET g_errno='art-657'
         RETURN
      ELSE
         SELECT SUM(raf05) INTO l_sum FROM raf_file
          WHERE raf01 = g_rbe.rbe01
            AND raf02 = g_rbe.rbe02
            AND rafplant = g_rbe.rbeplant 
            AND rafacti  = 'Y'
            AND raf03 NOT IN 
         (SELECT rbf06 FROM rbf_file
          WHERE rbf01 = g_rbe.rbe01
            AND rbf02 = g_rbe.rbe02
            AND rbf03 = g_rbe.rbe03
            AND rbf05 = '0'
            AND rbfplant = g_rbe.rbeplant 
            AND rbfacti  = 'Y' )      
         SELECT SUM(rbf08) INTO l_sum1 FROM rbf_file
          WHERE rbf01 = g_rbe.rbe01
            AND rbf02 = g_rbe.rbe02
            AND rbf03 = g_rbe.rbe03
            AND rbf05 = '1'
            AND rbfplant = g_rbe.rbeplant 
            AND rbfacti  = 'Y'         
         IF cl_null(l_sum) THEN 
            LET l_sum = 0
         END IF
         IF cl_null(l_sum1) THEN 
            LET l_sum1 = 0
         END IF
         IF cl_null(g_rbf[l_ac1].rbf08_1) THEN
            LET l_sum = l_sum+l_sum1+p_rbf08
         ELSE
            LET l_sum = l_sum+l_sum1+p_rbf08-g_rbf[l_ac1].rbf08_1
         END IF
         IF g_rbe.rbe21t<l_sum THEN
            LET g_errno='art-657'
            RETURN
         END IF
      END IF
   END IF 
END FUNCTION

FUNCTION t403_b1_init() 
    LET g_rbf[l_ac1].type    ='0'
    LET g_rbf[l_ac1].before  =' '
    LET g_rbf[l_ac1].after   ='1'
    LET g_rbf[l_ac1].rbf07 = '1'      #參與方式 1:必選 2: 可選 
    LET g_rbf[l_ac1].rbf08 =  0
    LET g_rbf[l_ac1].rbfacti = 'Y'
    LET g_rbf[l_ac1].rbf06_1 = NULL
    LET g_rbf[l_ac1].rbf07_1 = NULL
    LET g_rbf[l_ac1].rbf08_1 = NULL     
    LET g_rbf[l_ac1].rbfacti_1 = NULL 
    CALL cl_set_comp_entry("rbf08",TRUE)
    CALL cl_set_comp_required("rbf08",TRUE)  
END FUNCTION

FUNCTION t403_b1_find()
   LET g_rbf[l_ac1].type  ='1'
   LET g_rbf[l_ac1].before='0'
   LET g_rbf[l_ac1].after ='1'
   
   SELECT raf03,raf04,raf05,rafacti  
     INTO g_rbf[l_ac1].rbf06_1,g_rbf[l_ac1].rbf07_1,g_rbf[l_ac1].rbf08_1,g_rbf[l_ac1].rbfacti_1
     FROM raf_file
    WHERE raf01=g_rbe.rbe01 
      AND raf02=g_rbe.rbe02 
      AND raf03=g_rbf[l_ac1].rbf06 
      AND rafplant=g_rbe.rbeplant
      
   #FUN-AB0033 add -----------------start-----------------  
   LET g_rbf[l_ac1].rbf06 = g_rbf[l_ac1].rbf06_1
   LET g_rbf[l_ac1].rbf07 = g_rbf[l_ac1].rbf07_1
   LET g_rbf[l_ac1].rbf08 = g_rbf[l_ac1].rbf08_1
   LET g_rbf[l_ac1].rbfacti = g_rbf[l_ac1].rbfacti_1
   
   DISPLAY BY NAME g_rbf[l_ac1].rbf06,g_rbf[l_ac1].rbf07,g_rbf[l_ac1].rbf08,g_rbf[l_ac1].rbfacti 
   #FUN-AB0033 add ------------------end------------------
      
   DISPLAY BY NAME  g_rbf[l_ac1].rbf06_1,g_rbf[l_ac1].rbf07_1,g_rbf[l_ac1].rbf08_1,g_rbf[l_ac1].rbfacti_1
   DISPLAY BY NAME  g_rbf[l_ac1].type,g_rbf[l_ac1].before,g_rbf[l_ac1].after       
END FUNCTION 

FUNCTION t403_delall() 
   SELECT COUNT(*) INTO g_cnt FROM rbf_file
    WHERE rbf02 = g_rbe.rbe02 AND rbf01 = g_rbe.rbe01
      AND rbf03 = g_rbe.rbe03
      AND rbfplant = g_rbe.rbeplant
 
   IF g_cnt = 0 THEN
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM rbe_file WHERE rbe01 = g_rbe.rbe01 AND rbe02=g_rbe.rbe02 
                             AND rbe03=g_rbe.rbe03   AND rbeplant=g_rbe.rbeplant
      DELETE FROM rbq_file WHERE rbq01 = g_rbe.rbe01 AND rbq02=g_rbe.rbe02  AND rbq03=g_rbe.rbe03
                             AND rbq04='2' AND rbqplant=g_rbe.rbeplant
      CALL g_rbf.clear()
   END IF
END FUNCTION

#同一商品同一單位在同一機構中不能在同一時間參與兩種及以上的一般促銷
#p_group :組別
#FUNCTION t403_repeat(p_group)     
#DEFINE p_group    LIKE raf_file.raf03
#DEFINE l_n        LIKE type_file.num5
#DEFINE l_rbg08    LIKE rbg_file.rbg08
#DEFINE l_rbg09    LIKE rbg_file.rbg09
#DEFINE l_rbe04    LIKE rbe_file.rbe04
#DEFINE l_rbe05    LIKE rbe_file.rbe05
#DEFINE l_rbe06    LIKE rbe_file.rbe06
#DEFINE l_rbe07    LIKE rbe_file.rbe07
#
#   LET l_n=0
#   LET g_errno =' '
#   SELECT COUNT(rbg07) INTO l_n FROM rbg_file
#    WHERE rbg01=g_rbe.rbe01 AND rbg02=g_rbe.rbe02
#      AND rbgplant=g_rbe.rbeplant AND rbg03=p_group
#      AND rbgacti='Y'
#   IF l_n<1 THEN RETURN END IF 
#   
#   CALL t303sub_chk('2',g_rbe.rbeplant,g_rbe.rbe01,g_rbe.rbe02,p_group,g_rbe.rbe04,g_rbe.rbe05,g_rbe.rbe06,g_rbe.rbe07)
#END FUNCTION

#FUN-C60041 ----------mark-----------begin
#FUNCTION t403_iss() 
#  DEFINE l_cnt      LIKE type_file.num5
#  DEFINE l_dbs      LIKE azp_file.azp03   
#  DEFINE l_sql      STRING
#  DEFINE l_raq04    LIKE raq_file.raq04
#  DEFINE l_rtz11    LIKE rtz_file.rtz11
#  DEFINE l_rbelegal LIKE rbe_file.rbelegal
#  DEFINE l_n        LIKE type_file.num5
# 
#  IF s_shut(0) THEN
#     RETURN
#  END IF
#  IF g_rbe.rbe02 IS NULL THEN
#     CALL cl_err('',-400,0)
#     RETURN
#  END IF 
#  SELECT * INTO g_rbe.* FROM rbe_file 
#   WHERE rbe02 = g_rbe.rbe02 AND rbe01=g_rbe.rbe01
#     AND rbe03 = g_rbe.rbe03 AND rbeplant = g_rbe.rbeplant

#  #IF g_rbe.rbe01<>g_rbe.rbeplant THEN   #FUN-AB0033 mark
#  #   CALL cl_err('','art-663',0)        #FUN-AB0033 mark
#  #   RETURN                             #FUN-AB0033 mark
#  #END IF                                #FUN-AB0033 mark

#  IF g_rbe.rbeacti ='N' THEN
#     CALL cl_err(g_rbe.rbe01,'mfg1000',0)
#     RETURN
#  END IF
#  
#  IF g_rbe.rbeconf = 'N' THEN
#     CALL cl_err('','art-656',0)   #此筆資料未確認不可發布
#     RETURN
#  END IF
#  
#  #FUN-AB0033 mark ------start--------
#  #IF g_rbe.rbeconf = 'X' THEN
#  #   CALL cl_err('','art-661',0)
#  #   RETURN
#  #END IF
#  
#  #IF g_rbe.rbeconf = 'I' THEN
#  #   CALL cl_err('','art-662',0)
#  #   RETURN
#  #END IF
#  #FUN-AB0033 mark -------end---------

#  #SELECT COUNT(*) INTO l_cnt FROM rbq_file 
#  # WHERE rbq01 = g_rbe.rbe01 AND rbq02=g_rbe.rbe02 
#  #   AND rbq03 = g_rbe.rbe03 AND rbqplant=g_rbe.rbeplant 
#  #   #AND rbq04='2' AND rbqacti='Y' AND rbq08='N'
#  #   AND rbq04='2'  AND rbq08='N'
#  #IF l_cnt=0 THEN
#  #   CALL cl_err('','art-662',0)
#  #   RETURN
#  #END IF  
#
#  #OPEN t403_cl USING g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,g_rbe.rbeplant
#  #IF STATUS THEN
#  #   CALL cl_err("OPEN t403_cl:", STATUS, 1)
#  #   CLOSE t403_cl
#  #   ROLLBACK WORK
#  #   RETURN
#  #END IF
#  
#  #FUN-AB0033 mark --------------start-----------------
#  #SELECT COUNT(*) INTO l_cnt FROM rbf_file
#  # WHERE rbf01 = g_rbe.rbe01 AND rbf02 = g_rbe.rbe02
#  #   AND rbf03 = g_rbe.rbe03 AND rbfplant = g_rbe.rbeplant 
#  #IF l_cnt = 0 THEN #單身無有效資料不能確認
#  #   CALL cl_err('','art-548',0)
#  #   RETURN
#  #END IF
#  
#  #IF NOT cl_confirm('art-660') THEN 
#  #   RETURN
#  #END IF     
#  #FUN-AB0033 mark --------------start-----------------

#  CALL t403_temptable("1")
#  DROP TABLE rbe_temp
#  SELECT * FROM rbe_file WHERE 1 = 0 INTO TEMP rbe_temp
#  DROP TABLE rbf_temp
#  SELECT * FROM rbf_file WHERE 1 = 0 INTO TEMP rbf_temp
#  DROP TABLE rbg_temp
#  SELECT * FROM rbg_file WHERE 1 = 0 INTO TEMP rbg_temp  
#  DROP TABLE rbp_temp
#  SELECT * FROM rbp_file WHERE 1 = 0 INTO TEMP rbp_temp  
#  DROP TABLE rbq_temp
#  SELECT * FROM rbq_file WHERE 1 = 0 INTO TEMP rbq_temp
#  DROP TABLE rbr_temp
#  SELECT * FROM rbr_file WHERE 1 = 0 INTO TEMP rbr_temp  
#  DROP TABLE rbs_temp
#  SELECT * FROM rbs_file WHERE 1 = 0 INTO TEMP rbs_temp   
#  DROP TABLE rbk_temp                 #FUN-BC0078 add
#  SELECT * FROM rbk_file WHERE 1 = 0 INTO TEMP rbk_temp   #FUN-BC0078 add 

#  DROP TABLE rae_temp
#  SELECT * FROM rae_file WHERE 1 = 0 INTO TEMP rae_temp
#  DROP TABLE raf_temp
#  SELECT * FROM raf_file WHERE 1 = 0 INTO TEMP raf_temp
#  DROP TABLE rag_temp
#  SELECT * FROM rag_file WHERE 1 = 0 INTO TEMP rag_temp
#  DROP TABLE rap_temp
#  SELECT * FROM rap_file WHERE 1 = 0 INTO TEMP rap_temp
#  DROP TABLE raq_temp
#  SELECT * FROM raq_file WHERE 1 = 0 INTO TEMP raq_temp
#  DROP TABLE rar_temp
#  SELECT * FROM rar_file WHERE 1 = 0 INTO TEMP rar_temp
#  DROP TABLE ras_temp 
#  SELECT * FROM ras_file WHERE 1 = 0 INTO TEMP ras_temp
#  DROP TABLE rak_temp             #FUN-BC0078 add
#  SELECT * FROM rak_file WHERE 1 = 0 INTO TEMP rak_temp  #FUN-BC0078 add 

#  
#  #BEGIN WORK  #TQC-AC0326 mark 將確認和發佈放到一個事務中
#  LET g_success = 'Y'
#  #UPDATE rbe_file SET rbeconf='I'
#  # WHERE  rbe02 = g_rbe.rbe02 AND rbe01 = g_rbe.rbe01
#  #   AND rbe03 = g_rbe.rbe03  AND rbeplant = g_rbe.rbeplant
#  #IF SQLCA.sqlerrd[3]=0 THEN
#  #   LET g_success='N'
#  #END IF
#  
#  
#  CALL s_showmsg_init()   
#  CALL t403_iss_upd()  

#  IF g_success = 'N' THEN
#     CALL s_showmsg()
#     ROLLBACK WORK
#     RETURN
#  END IF
#  IF g_success = 'Y' THEN #拋磚成功
#     COMMIT WORK
#     MESSAGE "OK !"
#     LET g_rbe.rbeconf='Y'  
#     DISPLAY BY NAME g_rbe.rbeconf
#     CALL s_showmsg()
#     
#  END IF
#  #DISPLAY BY NAME g_rbe.rbeconf  #FUN-AB0033 mark
#  DROP TABLE rbe_temp
#  DROP TABLE rbf_temp
#  DROP TABLE rbg_temp
#  DROP TABLE rbp_temp
#  DROP TABLE rbq_temp
#  DROP TABLE rbr_temp
#  DROP TABLE rbs_temp
#  DROP TABLE rbk_temp  #FUN-BC0078 add

#  DROP TABLE rae_temp
#  DROP TABLE raf_temp
#  DROP TABLE rag_temp
#  DROP TABLE rap_temp
#  DROP TABLE raq_temp
#  DROP TABLE rar_temp
#  DROP TABLE ras_temp
#  DROP TABLE rak_temp  #FUN-BC0078 add
#  CALL t403_temptable("2")
#END FUNCTION 
#FUN-C60041 -------------mark---------------end
#FUN-C60041 ----------------STA
FUNCTION t403_iss()
   SELECT * INTO g_rbe.* FROM rbe_file
    WHERE rbe02 = g_rbe.rbe02 AND rbe01=g_rbe.rbe01
      AND rbe03 = g_rbe.rbe03 AND rbeplant = g_rbe.rbeplant
   CALL s_showmsg_init()
   CALL t403_iss_upd()
   IF g_success = 'N' THEN
      CALL s_showmsg()
   END IF
END FUNCTION
#FUN-C60041 ----------------END

FUNCTION t403_iss_upd() 
   DEFINE l_cnt      LIKE type_file.num5
   DEFINE l_dbs      LIKE azp_file.azp03   
   DEFINE l_n        LIKE type_file.num5
   DEFINE l_sql      STRING
   DEFINE l_rtz11    LIKE rtz_file.rtz11
   DEFINE l_rbelegal LIKE rbe_file.rbelegal
   DEFINE l_raqacti  LIKE raq_file.raqacti
   DEFINE l_raq04    LIKE raq_file.raq04

  #LET l_sql="SELECT raq04,raqacti FROM raq_file ", #生效營運中心 有效碼  #FUN-BC0078 mark
   LET l_sql="SELECT DISTINCT raq04 FROM raq_file ",
             " WHERE raq01=?   AND raq02=?",
             "   AND raq03='2' AND raqplant=?"
   PREPARE raq_pre FROM l_sql
   DECLARE raq_cs CURSOR FOR raq_pre
   FOREACH raq_cs USING g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbeplant
                 #INTO l_raq04,l_raqacti #FUN-BC0078 mark
                  INTO l_raq04   #FUN-BC0078 add 
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         CALL s_errmsg('','','Foreach rbq_cs:',SQLCA.sqlcode,1)                         
         EXIT FOREACH 
      END IF  
      LET l_n = 0
   #FUN-BC0078 add START
      LET l_sql="SELECT COUNT(*) FROM raq_file ",
                " WHERE raq01='",g_rbe.rbe01,"'",
                " AND raq02= '",g_rbe.rbe02,"'",
                "   AND raq03='2' AND raqplant='",g_rbe.rbeplant,"'",
                "   AND raq04='",l_raq04,"'",
                "   AND raqacti = 'Y' "
      PREPARE raq_pre1 FROM l_sql
      EXECUTE raq_pre1 INTO l_n
      IF l_n = 0 OR cl_null(l_n) THEN
         LET l_raqacti = 'N'
      ELSE
         LET l_raqacti = 'Y'
      END IF
   #FUN-BC0078 add END 
      IF g_rbe.rbeplant<>l_raq04 THEN 
         SELECT COUNT(*) INTO l_cnt FROM azw_file
          WHERE azw07 = g_rbe.rbeplant
            AND azw01 = l_raq04
         IF l_cnt = 0 THEN
            CONTINUE FOREACH
         END IF
      END IF

      SELECT azw02 INTO l_rbelegal FROM azw_file
       WHERE azw01 = l_raq04 AND azwacti='Y'
      SELECT rtz11 INTO l_rtz11 FROM rtz_file WHERE rtz01 = l_raq04

      IF l_raqacti='N' THEN  #營運中心無效時
         IF g_rbe.rbeplant <> l_raq04 THEN
            CALL t403_iss_chk(l_raq04) RETURNING l_n #判斷營運中心l_raq04下是否有資料查ra表
            #营运中心无效时，不是本中心只有ra表有资料才更新
            IF l_n>0 THEN    #UPDATE      #若營運中心l_raq04下有資料則先插入此變更單再走審核段
               CALL t403_iss_trans(l_raq04) #拋磚當前變更單到營運中心l_raq04下,相同机构更新否则插入rb表  
               IF g_success = 'N' THEN
                  EXIT FOREACH
               END IF
               IF l_rtz11='N' THEN 
                 #CALL s_showmsg_init()      #FUN-C60041
                  LET g_errno=' ' 
                  CALL t403sub_y_upd(g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,l_raq04) #更新ra表
                 #CALL s_showmsg()           #FUN-C60041
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
         #ELSE
         #   CALL t403_iss_trans(l_raq04)#拋磚當前變更單到營運中心l_raq04下,相同机构更新否则插入rb表  
         #   IF g_success = 'N' THEN
         #      EXIT FOREACH
         #   END IF
         #END IF
      ELSE                 #營運中心有效時  
#FUN-C60041 --------mark ---------begin      	    	
#        CALL t403_iss_trans(l_raq04)#拋磚當前變更單到營運中心l_raq04下,相同机构更新否则插入rb表 
#        IF g_success = 'N' THEN
#           EXIT FOREACH
#        END IF
#FUN-C60041 --------mark-----------end
         CALL t403_iss_chk(l_raq04) RETURNING l_n #判斷營運中心l_raq04下是否有資料查ra表
         IF l_n>0 THEN    #UPDATE 
#FUN-C60041 --------------STA
            CALL t403_iss_trans(l_raq04)#拋磚當前變更單到營運中心l_raq04下,相同机构更新否则插入rb表
            IF g_success = 'N' THEN
               EXIT FOREACH
            END IF
#FUN-C60041 --------------END
            IF l_rtz11='N' THEN     #若營運中心l_raq04下有資料則直接走審核段 
              #CALL s_showmsg_init()    #FUN-C60041
               LET g_errno=' '
               CALL t403sub_y_upd(g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,l_raq04)
              #CALL s_showmsg()         #FUN-C60041
               IF NOT cl_null(g_errno) THEN
                  LET g_success = 'N'
                 #ROLLBACK WORK         #FUN-C60041
               END IF
               IF g_success = 'N' THEN
                  EXIT FOREACH
               END IF
            END IF 
         ELSE   #INSERT #或者是此l_raq04為新增有效或原來無效變更為有效，此時走原artt303發布邏輯
            CALL t403_iss_pretrans(l_raq04) #插入ra表中
            IF g_success = 'N' THEN
               EXIT FOREACH
            END IF
         END IF  #UPDATE&INSERT 
      END IF
   END FOREACH
END FUNCTION

 
FUNCTION t403_yes()
   DEFINE l_cnt      LIKE type_file.num5
   DEFINE l_gen02    LIKE gen_file.gen02 
   DEFINE l_rxx04    LIKE rxx_file.rxx04
#TQC-B10003--ADD--begin
   DEFINE l_raf03    LIKE raf_file.raf03
   DEFINE l_raf04    LIKE raf_file.raf04
   DEFINE l_rafacti  LIKE raf_file.rafacti
   DEFINE l_rbf07    LIKE rbf_file.rbf07
   DEFINE l_rbfacti  LIKE rbf_file.rbfacti 
   DEFINE l_sql      STRING
   DEFINE l_raq04    LIKE raq_file.raq04
#TQC-B10003--ADD--end
   DEFINE l_rbf06    LIKE rbf_file.rbf06  #FUN-BC0078 add
   IF s_shut(0) THEN
      RETURN
   END IF

   CALL t403_temptable("1")
   
   IF g_rbe.rbe02 IS NULL THEN CALL cl_err(g_rbe.rbe02,-400,0) RETURN END IF
#CHI-C30107 --------------- add --------------------- begin
   IF g_rbe.rbeconf = 'Y' THEN CALL cl_err(g_rbe.rbe02,9023,0) RETURN END IF
   IF g_rbe.rbeacti = 'N' THEN CALL cl_err(g_rbe.rbe02,'art-145',0) RETURN END IF
   SELECT * INTO g_rbe.* FROM rbe_file
    WHERE rbe02 = g_rbe.rbe02 AND rbe01 = g_rbe.rbe01
      AND rbe03 = g_rbe.rbe03 AND rbeplant = g_rbe.rbeplant
   IF NOT cl_confirm('art-026') THEN RETURN END IF 
#CHI-C30107 --------------- add --------------------- end   
      #TQC-AC0326 add --------------------begin----------------------
      #生效營運中心中有對應的促銷單並且審核、發布， 才可審核對應的變更單
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM rae_file,raq_file
      WHERE raq01 =  g_rbe.rbe01  AND raq02 = g_rbe.rbe02  AND  raq03 = '2'
        AND raq04 =  g_rbe.rbeplant  AND  raqplant = g_rbe.rbeplant AND  raqacti = 'Y'
        AND rae01 =  raq01
        AND rae02 =  raq02
        AND raeplant = raqplant
        AND (raeconf != 'Y' OR raq05 = 'N') 
     IF l_cnt > 0 THEN
        CALL cl_err(g_rbe.rbe02,'art-998',0)
        RETURN
     END IF
      
      #生效營運中心中有對應的促銷單的未審核變更單序號最小的才可以變更
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM rbe_file 
       WHERE rbe01=g_rbe.rbe01 
         AND rbe02=g_rbe.rbe02 
         AND rbe03<g_rbe.rbe03
         AND rbeconf = 'N'  
         AND rbeplant=g_rbe.rbeplant
      IF l_cnt > 0 THEN
         CALL cl_err(g_rbe.rbe02,'art-997',0)
         RETURN
      END IF
      #TQC-AC0326 add ---------------------end-----------------------
   #FUN-BC0078 add START
      IF g_rbe.rbe12 <> g_rbe.rbe12t AND g_rbe.rbe12t <> '0' THEN
         SELECT COUNT(*) INTO l_cnt FROM rbp_file
           WHERE rbp01 = g_rbe.rbe01 AND rbp02 = g_rbe.rbe02
             AND rbp03 = g_rbe.rbe03 AND rbp04 = '2'
             AND rbp12 = g_rbe.rbe12t AND rbp06 = '1'
             AND rbpplant = g_rbe.rbeplant
         IF l_cnt < 1 THEN
             CALL cl_err('','art-795',0)
             RETURN
         END IF         
      END IF
      LET g_sql = " SELECT b.rbf06",
                "   FROM rbf_file b LEFT OUTER JOIN rbf_file a",
                "     ON (b.rbf01=a.rbf01 AND b.rbf02=a.rbf02 AND b.rbf03=a.rbf03 AND ",
                "         b.rbf04=a.rbf04 AND b.rbf06=a.rbf06 AND b.rbfplant=a.rbfplant AND b.rbf05<>a.rbf05 ) ",
                "  WHERE b.rbf01 = '",g_rbe.rbe01, "' AND b.rbfplant='",g_rbe.rbeplant,"'",
                "    AND b.rbf05='1' AND RTRIM(a.rbf06) IS NULL ",
                "    AND b.rbf02 = '",g_rbe.rbe02, "' AND b.rbf03=",g_rbe.rbe03
     PREPARE t403_b1_prepare3 FROM g_sql
     DECLARE rbf_cs2 CURSOR FOR t403_b1_prepare3
     FOREACH rbf_cs2 INTO l_rbf06
        SELECT COUNT(*) INTO l_cnt FROM rbg_file
           WHERE rbg01 = g_rbe.rbe01 AND rbg02 = g_rbe.rbe02
             AND rbg03 = g_rbe.rbe03 AND rbg06 = l_rbf06
             AND rbgplant = g_rbe.rbeplant
        IF l_cnt < 1 THEN
           CALL cl_err('','art-790',0)
           RETURN
        END IF
     END FOREACH
   #FUN-BC0078 add END

#TQC-B10003 -- add-- begin
      IF g_rbe.rbe21t = 0 OR cl_null(g_rbe.rbe21t) THEN
         LET l_sql="SELECT raf03,raf04,rafacti FROM ",cl_get_target_table(l_raq04, 'raf_file'),
                   " WHERE raf01='",g_rbe.rbe01,"'",
                   "   AND raf02='",g_rbe.rbe02,"'",
                   "   AND rafplant='",g_rbe.rbeplant,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql
         PREPARE s_sel_raf03_pre FROM l_sql
         DECLARE s_sel_raf03_cs CURSOR FOR s_sel_raf03_pre 
         FOREACH s_sel_raf03_cs INTO l_raf03,l_raf04,l_rafacti
            IF l_raf04 = '2' THEN 
               SELECT rbf07,rbfacti into l_rbf07,l_rbfacti
               FROM rbf_file
               WHERE rbf01=g_rbe.rbe01 AND rbf02=g_rbe.rbe02
               AND rbfplant=g_rbe.rbeplant AND rbf06=l_raf03
                 IF l_rbf07 = '2' AND l_rbfacti = 'Y' THEN 
                    CALL cl_err('','art509',0)
                    RETURN
                 END IF
                 IF cl_null(l_rbf07) AND cl_null(l_rbfacti) THEN
                    CALL cl_err('','art509',0)
                    RETURN
                 END IF
            END IF
         END FOREACH
      END IF  
#TQC-B10003 -- add-- end
   SELECT * INTO g_rbe.* FROM rbe_file 
    WHERE rbe02 = g_rbe.rbe02 AND rbe01 = g_rbe.rbe01
      AND rbe03 = g_rbe.rbe03 AND rbeplant = g_rbe.rbeplant
   IF g_rbe.rbeconf = 'Y' THEN CALL cl_err(g_rbe.rbe02,9023,0) RETURN END IF
   #IF g_rbe.rbeconf = 'X' THEN CALL cl_err(g_rbe.rbe02,'9024',0) RETURN END IF  #FUN-AB0033 mark
   IF g_rbe.rbeacti = 'N' THEN CALL cl_err(g_rbe.rbe02,'art-145',0) RETURN END IF
   #IF g_rbe.rbeconf = 'I' THEN CALL cl_err(g_rbe.rbe02,9023,0) RETURN END IF    #FUN-AB0033 mark

   #-TQC-B60071- ADD - BEGIN -----------------------------------
   IF NOT cl_null(g_rbe.rbe21t) AND g_rbe.rbe21t > 0 THEN
      LET g_errno = NULL
      CALL t403_check_rbe21t()
      IF NOT cl_null(g_errno) THEN
         CALL cl_err('',g_errno,0)
         RETURN
      END IF
   END IF

   LET g_errno = NULL
   CALL t403_check_rbf06()
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
      RETURN
   END IF
   #-TQC-B60071- ADD -  END  -----------------------------------
   
   #FUN-AB0033 mark --------------start-----------------
   #LET l_cnt=0
   #SELECT COUNT(*) INTO l_cnt
   #  FROM rbf_file
   # WHERE rbf02 = g_rbe.rbe02 AND rbf01=g_rbe.rbe01
   #   AND rbf03=g_rbe.rbe03 AND rbfplant = g_rbe.rbeplant
   #IF l_cnt=0 OR l_cnt IS NULL THEN
   #   CALL cl_err('','mfg-009',0)
   #   RETURN
   #END IF
   #FUN-AB0033 mark ---------------end------------------
#  IF NOT cl_confirm('art-026') THEN RETURN END IF #CHI-C30107 mark
   CALL t403_create_temp_table()         #FUN-C60041 add
   BEGIN WORK
   OPEN t403_cl USING g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,g_rbe.rbeplant
   
   IF STATUS THEN
      CALL cl_err("OPEN t403_cl:", STATUS, 1)
      CLOSE t403_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t403_cl INTO g_rbe.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rbe.rbe02,SQLCA.sqlcode,0)
      CLOSE t403_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   LET g_success = 'Y'
   
   UPDATE rbe_file SET rbeconf='Y',
                       rbecond=g_today, 
                       rbeconu=g_user
    WHERE  rbe02 = g_rbe.rbe02 AND rbe01 = g_rbe.rbe01
      AND rbe03 = g_rbe.rbe03  AND rbeplant = g_rbe.rbeplant
   IF SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   END IF
 
   IF g_success = 'Y' THEN
      CALL s_showmsg_init()
      LET g_errno=' '
      CALL t403sub_y_upd(g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,g_rbe.rbeplant)
      
      CALL s_showmsg()
      IF NOT cl_null(g_errno) THEN
         LET g_success = 'N'
         ROLLBACK WORK
      END IF
   END IF   
#FUN-C60041 -----------STA
   IF g_success = 'Y' THEN
      CALL t403_iss()
   END IF
#FUN-C60041 -----------END 

   IF g_success = 'Y' THEN
      #LET g_rbe.rbeconf='Y'  #FUN-AB0033 mark
      COMMIT WORK
      CALL cl_flow_notify(g_rbe.rbe02,'Y')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT * INTO g_rbe.* FROM rbe_file 
    WHERE rbe02 = g_rbe.rbe02 AND rbe01 = g_rbe.rbe01 
      AND rbe03 = g_rbe.rbe03 AND rbeplant = g_rbe.rbeplant
    SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rbe.rbeconu
    DISPLAY BY NAME g_rbe.rbeconf                                                                                         
    DISPLAY BY NAME g_rbe.rbecond                                                                                         
    DISPLAY BY NAME g_rbe.rbeconu
    DISPLAY l_gen02 TO FORMONLY.rbeconu_desc
    #CKP
    
    IF NOT g_rbe.rbeconf='X' THEN 
       LET g_chr='N'
    END IF

    IF g_rbe.rbeconf='I' OR g_rbe.rbeconf='Y' THEN
      LET g_chr2='Y' 
    ELSE 
      LET g_chr2='N'
   END IF 
   CALL t403_temptable("2")
   CALL cl_set_field_pic(g_chr2,"","","",g_chr,"")
#FUN-C60041 ------------mark ------------begin
#  #TQC-AC0326 add -----------begin------------
#   IF g_success = 'Y' THEN 
#      CALL t403_iss() 
#   ELSE
#     ROLLBACK WORK    
#   END IF    
#   #TQC-AC0326 add -----------begin------------
#FUN-C60041 ------------mark ------------end
   CALL t403_drop_temp_table()              #FUN-C60041 add
END FUNCTION

#FUN-AB0033 mark ----------start-----------          
#FUNCTION t403_v()
#   IF s_shut(0) THEN RETURN END IF
#   IF cl_null(g_rbe.rbe02) THEN CALL cl_err('',-400,0) RETURN END IF    
#   
#   SELECT * INTO g_rbe.* FROM rbe_file 
#      WHERE rbe02 = g_rbe.rbe02 AND rbe01=g_rbe.rbe01
#        AND rbe03=g_rbe.rbe03 AND rbeplant = g_rbe.rbeplant 
#        
#   IF g_rbe.rbeconf = 'Y' THEN CALL cl_err(g_rbe.rbe02,9023,0) RETURN END IF
#   IF g_rbe.rbeconf = 'I' THEN CALL cl_err(g_rbe.rbe02,9023,0) RETURN END IF
#   IF g_rbe.rbeacti = 'N' THEN CALL cl_err(g_rbe.rbe02,'art-142',0) RETURN END IF
#   IF g_rbe.rbeconf = 'X' THEN CALL cl_err(g_rbe.rbe02,'art-148',0) RETURN END IF
#   
#   BEGIN WORK
# 
#   OPEN t403_cl USING g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,g_rbe.rbeplant
#   IF STATUS THEN
#      CALL cl_err("OPEN t403_cl:", STATUS, 1)
#      CLOSE t403_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
# 
#   FETCH t403_cl INTO g_rbe.*
#   IF SQLCA.sqlcode THEN
#      CALL cl_err(g_rbe.rbe02,SQLCA.sqlcode,0)
#      CLOSE t403_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
# 
#   IF cl_void(0,0,g_rbe.rbeconf) THEN
#      LET g_chr = g_rbe.rbeconf
#      IF g_rbe.rbeconf = 'N' THEN
#         LET g_rbe.rbeconf = 'X'
#      ELSE
#         LET g_rbe.rbeconf = 'N'
#      END IF
# 
#      UPDATE rbe_file SET rbeconf=g_rbe.rbeconf,
#                          rbemodu=g_user,
#                          rbedate=g_today
#       WHERE rbe01 = g_rbe.rbe01  AND rbe02 = g_rbe.rbe02
#         AND rbe03 = g_rbe.rbe03 AND rbeplant = g_rbe.rbeplant  
#       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#          CALL cl_err3("upd","rbe_file",g_rbe.rbe02,"",SQLCA.sqlcode,"","upd rbeconf",1)
#          LET g_rbe.rbeconf = g_chr
#          ROLLBACK WORK
#          RETURN
#       END IF
#   END IF
# 
#   CLOSE t403_cl
#   COMMIT WORK
# 
#   SELECT * INTO g_rbe.* FROM rbe_file 
#    WHERE rbe01 = g_rbe.rbe01  AND rbe02 = g_rbe.rbe02
#      AND rbe03 = g_rbe.rbe03 AND rbeplant = g_rbe.rbeplant  
#   DISPLAY BY NAME g_rbe.rbeconf                                                                                        
#   DISPLAY BY NAME g_rbe.rbemodu                                                                                        
#   DISPLAY BY NAME g_rbe.rbedate
#    #CKP
#   IF g_rbe.rbeconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
#   IF g_rbe.rbeconf='I' OR g_rbe.rbeconf='Y' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF  
#   CALL cl_set_field_pic(g_chr2,"","","",g_chr,"")
# 
#   CALL cl_flow_notify(g_rbe.rbe02,'V') 
#END FUNCTION
#FUN-AB0033 mark -----------end------------ 
 
#判斷營運中心l_raq04下是否有資料
#返回值：l_n
FUNCTION t403_iss_chk(l_raq04)
   DEFINE l_n      LIKE type_file.num5
   DEFINE l_sql    STRING
   DEFINE l_raq04  LIKE raq_file.raq04

   LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_raq04, 'rae_file'),
             " WHERE rae01='",g_rbe.rbe01,"'",
             "   AND rae02='",g_rbe.rbe02,"'",
             "   AND raeplant='",l_raq04,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql
   PREPARE trans_cnt_rae FROM l_sql
   EXECUTE trans_cnt_rae INTO l_n
   RETURN l_n
END FUNCTION

#拋磚當前變更單到營運中心l_raq04下
#返回值:全局變量g_success 
FUNCTION t403_iss_trans(l_raq04) 
   DEFINE l_raq04    LIKE raq_file.raq04
   DEFINE l_n        LIKE type_file.num5
   DEFINE l_sql      STRING
   DEFINE l_rtz11    LIKE rtz_file.rtz11
   DEFINE l_rbelegal LIKE rbe_file.rbelegal

   SELECT azw02 INTO l_rbelegal FROM azw_file
    WHERE azw01 = l_raq04 AND azwacti='Y'
   SELECT rtz11 INTO l_rtz11 FROM rtz_file WHERE rtz01 = l_raq04

      IF g_rbe.rbeplant = l_raq04 THEN #與當前機構相同則不拋
         UPDATE raq_file SET raq05='Y' 
          WHERE raq01=g_rbe.rbe01 AND raq02=g_rbe.rbe02 
            AND raq03='2' AND raq04=l_raq04 AND raqplant=g_rbe.rbeplant
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","raq_file",g_rbe.rbe02,"",STATUS,"","",1) 
            LET g_success = 'N'
            RETURN
         END IF
         SELECT COUNT(*) INTO l_n FROM rbq_file
          WHERE rbq01=g_rbe.rbe01 AND rbq02=g_rbe.rbe02 AND rbq03=g_rbe.rbe03
            AND rbq04='2' AND rbq07=l_raq04 AND rbqplant=g_rbe.rbeplant
         IF l_n>0 THEN    #此生效機構有變更記錄
            UPDATE rbq_file SET rbq08='Y' 
             WHERE rbq01=g_rbe.rbe01 AND rbq02=g_rbe.rbe02 AND rbq03=g_rbe.rbe03
               AND rbq04='2' AND rbq06='1' AND rbq07=l_raq04 AND rbqplant=g_rbe.rbeplant
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","rbq_file",g_rbe.rbe02,"",STATUS,"","",1) 
               LET g_success = 'N'
               RETURN
            END IF
         END IF
      ELSE
         UPDATE raq_file SET raq05='Y' 
          WHERE raq01=g_rbe.rbe01 AND raq02=g_rbe.rbe02 
            AND raq03='2' AND raq04=l_raq04 AND raqplant=g_rbe.rbeplant
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","raq_file",g_rbe.rbe02,"",STATUS,"","",1) 
            LET g_success = 'N'
            RETURN
         END IF
         SELECT COUNT(*) INTO l_n FROM rbq_file
          WHERE rbq01=g_rbe.rbe01 AND rbq02=g_rbe.rbe02 AND rbq03=g_rbe.rbe03
            AND rbq04='2' AND rbq07=l_raq04 AND rbqplant=g_rbe.rbeplant
         IF l_n>0 THEN    #此生效機構有變更記錄
            UPDATE rbq_file SET rbq08='Y' 
             WHERE rbq01=g_rbe.rbe01 AND rbq02=g_rbe.rbe02 AND rbq03=g_rbe.rbe03
               AND rbq04='2' AND rbq06='1' AND rbq07=l_raq04 AND rbqplant=g_rbe.rbeplant
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","rbq_file",g_rbe.rbe02,"",STATUS,"","",1) 
               LET g_success = 'N'
               RETURN
            END IF
         END IF
        #將數據放入臨時表中處理
         DELETE FROM rbe_temp
         DELETE FROM rbf_temp
         DELETE FROM rbg_temp  
         DELETE FROM rbq_temp
         DELETE FROM rbp_temp
         DELETE FROM rbr_temp
         DELETE FROM rbs_temp
         DELETE FROM rbk_temp  #FUN-BC0078 add

         INSERT INTO rbe_temp SELECT * FROM rbe_file
                               WHERE rbe01 = g_rbe.rbe01 AND rbe02 = g_rbe.rbe02
                                 AND rbe03 = g_rbe.rbe03 AND rbeplant = g_rbe.rbeplant
         IF l_rtz11='Y' THEN  #下發資料不審核
            UPDATE rbe_temp SET rbeplant = l_raq04,
                                rbelegal = l_rbelegal,
                                rbeconf = 'N',   #審核碼
                                rbecond = NULL,  #審核日期
                                rbeconu = NULL   #審核人 
         ELSE
            UPDATE rbe_temp SET rbeplant = l_raq04,
                                rbelegal = l_rbelegal,
                                rbeconf = 'Y',
                                rbecond = g_today,
                                rbeconu = g_user
         END IF  

         INSERT INTO rbf_temp SELECT rbf_file.* FROM rbf_file
                               WHERE rbf01 = g_rbe.rbe01 AND rbf02 = g_rbe.rbe02
                                 AND rbf03 = g_rbe.rbe03 AND rbfplant = g_rbe.rbeplant
         UPDATE rbf_temp SET rbfplant=l_raq04,
                             rbflegal = l_rbelegal

         INSERT INTO rbg_temp SELECT rbg_file.* FROM rbg_file
                               WHERE rbg01 = g_rbe.rbe01 AND rbg02 = g_rbe.rbe02
                                 AND rbg03 = g_rbe.rbe03 AND rbgplant = g_rbe.rbeplant
         UPDATE rbg_temp SET rbgplant=l_raq04,
                             rbglegal = l_rbelegal

         INSERT INTO rbp_temp SELECT rbp_file.* FROM rbp_file
                               WHERE rbp01 = g_rbe.rbe01  AND rbp02 = g_rbe.rbe02
                                 AND rbp03 = g_rbe.rbe03  AND rbp04 ='2'          
                                 AND rbpplant = g_rbe.rbeplant
         UPDATE rbp_temp SET rbpplant=l_raq04,
                             rbplegal = l_rbelegal

         INSERT INTO rbq_temp SELECT * FROM rbq_file
                               WHERE rbq01=g_rbe.rbe01 AND rbq02 = g_rbe.rbe02
                                 AND rbq03=g_rbe.rbe03 AND rbq04 ='2' 
                                 AND rbqplant = g_rbe.rbeplant
         UPDATE rbq_temp SET rbqplant = l_raq04,
                             rbq08    = 'Y',
                             rbqlegal = l_rbelegal     
         
         INSERT INTO rbr_temp SELECT rbr_file.* FROM rbr_file
                               WHERE rbr01 = g_rbe.rbe01  AND rbr02 = g_rbe.rbe02
                                 AND rbr03 = g_rbe.rbe03  AND rbr04 ='2' 
                                 AND rbrplant = g_rbe.rbeplant
         UPDATE rbr_temp SET rbrplant=l_raq04,
                             rbrlegal = l_rbelegal
                             
         INSERT INTO rbs_temp SELECT rbs_file.* FROM rbs_file
                               WHERE rbs01 = g_rbe.rbe01 AND rbs02 = g_rbe.rbe02
                                 AND rbs03 = g_rbe.rbe03 AND rbs04 ='2' 
                                 AND rbsplant = g_rbe.rbeplant
         UPDATE rbs_temp SET rbsplant=l_raq04,
                             rbslegal = l_rbelegal
       #FUN-BC0078 add START
         INSERT INTO rbk_temp SELECT * FROM rbk_file
                               WHERE rbk01=g_rbe.rbe01 AND rbk02 = g_rbe.rbe02
                                 AND rbk03=g_rbe.rbe03 AND rbk05 = '2'
                                 AND rbkplant = g_rbe.rbeplant
         UPDATE rbk_temp SET rbkplant = l_raq04,
                             rbklegal = l_rbelegal        
       #FUN-BC0078 add END

         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rbe_file'),
                     " SELECT * FROM rbe_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql
         PREPARE trans_ins_rbe FROM l_sql
         EXECUTE trans_ins_rbe
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO rbe_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           RETURN
         END IF
         
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rbf_file'), 
                     " SELECT * FROM rbf_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql 
         PREPARE trans_ins_rbf FROM l_sql
         EXECUTE trans_ins_rbf
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO rbf_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           RETURN
         END IF 

         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rbg_file'), 
                     " SELECT * FROM rbg_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql 
         PREPARE trans_ins_rbg FROM l_sql
         EXECUTE trans_ins_rbg
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO rbg_file:',SQLCA.sqlcode,1)
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
      #FUN-BC0078 add START
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
      #FUN-BC0078 add END
      END IF
END FUNCTION

#變更新增有效營運中心或變更原促銷當中無效營運中心為有效時
#即：若營運中心l_raq04下無此筆促銷變更單時直接插入變更後的組合促銷單
#即：走artt303發布邏輯
#返回值：全局變量g_success
FUNCTION t403_iss_pretrans(l_raq04)
   DEFINE l_raq04    LIKE raq_file.raq04
   DEFINE l_n        LIKE type_file.num5
   DEFINE l_sql      STRING
   DEFINE l_rtz11    LIKE rtz_file.rtz11
   DEFINE l_rbelegal LIKE rbe_file.rbelegal

   LET g_time = TIME
 
   SELECT azw02 INTO l_rbelegal FROM azw_file
    WHERE azw01 = l_raq04 AND azwacti='Y'
   SELECT rtz11 INTO l_rtz11 FROM rtz_file WHERE rtz01 = l_raq04

            DELETE FROM rae_temp
            DELETE FROM raf_temp
            DELETE FROM rag_temp
            DELETE FROM raq_temp
            DELETE FROM rap_temp
            DELETE FROM rar_temp
            DELETE FROM ras_temp
            DELETE FROM rak_temp            #FUN-C60041 add            

            INSERT INTO rae_temp SELECT * FROM rae_file
                                  WHERE rae01 = g_rbe.rbe01 AND rae02 = g_rbe.rbe02
                                    AND raeplant = g_rbe.rbeplant
            IF l_rtz11='Y' THEN
               UPDATE rae_temp SET raeplant = l_raq04,
                                   raelegal = l_rbelegal,
                                   raeconf = 'N',
                                   raecond = NULL,
                                   raecont = NULL,
                                   raeconu = NULL
            ELSE
               UPDATE rae_temp SET raeplant = l_raq04,
                                   raelegal = l_rbelegal,
                                   raeconf = 'Y',
                                   raecond = g_today,
                                   raecont = g_time,
                                   raeconu = g_user
            END IF

            INSERT INTO raf_temp SELECT raf_file.* FROM raf_file
                                  WHERE raf01 = g_rbe.rbe01 AND raf02 = g_rbe.rbe02
                                    AND rafplant = g_rbe.rbeplant
            UPDATE raf_temp SET rafplant=l_raq04,
                                raflegal = l_rbelegal
   
            INSERT INTO rag_temp SELECT rag_file.* FROM rag_file
                                  WHERE rag01 = g_rbe.rbe01 AND rag02 = g_rbe.rbe02
                                    AND ragplant = g_rbe.rbeplant
            UPDATE rag_temp SET ragplant=l_raq04,
                                raglegal = l_rbelegal
   
            INSERT INTO rap_temp SELECT rap_file.* FROM rap_file
                                  WHERE rap01 = g_rbe.rbe01 AND rap02 = g_rbe.rbe02
                                    AND rap03 ='2' AND rapplant = g_rbe.rbeplant
            UPDATE rap_temp SET rapplant=l_raq04,
                                raplegal = l_rbelegal

            INSERT INTO raq_temp SELECT * FROM raq_file
                                  WHERE raq01=g_rbe.rbe01 AND raq02 = g_rbe.rbe02
                                    AND raq03 ='2' AND raqplant = g_rbe.rbeplant
            UPDATE raq_temp SET raqplant = l_raq04,
                                raq05    = 'Y',
                                raqlegal = l_rbelegal                    
            #FUN-C60041 ------------STA
                               ,raq06 = g_today,
                                raq07 = g_time
            #FUN-C60041 ------------END             

            INSERT INTO rar_temp SELECT rar_file.* FROM rar_file
                                  WHERE rar01 = g_rbe.rbe01 AND rar02 = g_rbe.rbe02
                                    AND rar03 ='2' AND rarplant = g_rbe.rbeplant
            UPDATE rar_temp SET rarplant=l_raq04,
                                rarlegal = l_rbelegal

            INSERT INTO ras_temp SELECT ras_file.* FROM ras_file
                                  WHERE ras01 = g_rbe.rbe01 AND ras02 = g_rbe.rbe02
                                    AND ras03 ='2' AND rasplant = g_rbe.rbeplant
            UPDATE ras_temp SET rasplant=l_raq04,
                                raslegal = l_rbelegal           
          #FUN-BC0078 add START
            INSERT INTO rak_temp SELECT rak_file.* FROM rak_file
                                  WHERE rak01 = g_rbe.rbe01 AND rak02 = g_rbe.rbe02
                                    AND rak03 ='2' AND rakplant = g_rbe.rbeplant
            UPDATE rak_temp SET rakplant=l_raq04,
                                raklegal = l_rbelegal
          #FUN-BC0078 add END 
   
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rae_file'),
                        " SELECT * FROM rae_temp"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql
            PREPARE trans_ins_rae FROM l_sql
            EXECUTE trans_ins_rae
            IF SQLCA.sqlcode THEN
              CALL s_errmsg('','','INSERT INTO rae_file:',SQLCA.sqlcode,1)
              LET g_success = 'N'
              RETURN
            END IF
   
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'raf_file'),
                        " SELECT * FROM raf_temp"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql
            PREPARE trans_ins_raf FROM l_sql
            EXECUTE trans_ins_raf
            IF SQLCA.sqlcode THEN
              CALL s_errmsg('','','INSERT INTO raf_file:',SQLCA.sqlcode,1)
              LET g_success = 'N'
              RETURN
            END IF
   
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rag_file'),
                        " SELECT * FROM rag_temp"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql
            PREPARE trans_ins_rag FROM l_sql
            EXECUTE trans_ins_rag
            IF SQLCA.sqlcode THEN
              CALL s_errmsg('','','INSERT INTO rag_file:',SQLCA.sqlcode,1)
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
 
          #FUN-BC0078 add START
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
          #FUN-BC0078 add END

END FUNCTION

FUNCTION t403_temptable(p_type)
   DEFINE p_type     LIKE type_file.num5
   IF p_type = '1' THEN
      SELECT rae01,rae02,rae03,rae04,rae05,rae06,rae07,raeplant FROM rae_file WHERE 1=0 INTO TEMP cx001_temp
      SELECT rag01,rag02,rag03,rag04,rag05,rag06,ragplant FROM rag_file WHERE 1=0 INTO TEMP cx002_temp
      SELECT rag01,rag02,rag03,rag04,rag05,rag06,ragplant FROM rag_file WHERE 1=0 INTO TEMP cx002_temp1
   ELSE
      DROP TABLE cx001_temp
      DROP TABLE cx002_temp
      DROP TABLE cx002_temp1
   END IF
END FUNCTION

#-TQC-B60071- ADD - BEGIN -----------------------------------
FUNCTION t403_check_rbe21t()
DEFINE l_rbf08_n      LIKE type_file.num5
DEFINE l_raf05_n      LIKE type_file.num5
DEFINE l_cnt1         LIKE type_file.num5
DEFINE l_cnt2         LIKE type_file.num5

   LET l_rbf08_n = 0
   LET l_raf05_n = 0
   LET l_cnt1 = 0
   LET l_cnt2 = 0

   #-- << 計算出rbf變更檔中單身一的組合數量 >> --#
   SELECT SUM(rbf08) INTO l_rbf08_n FROM rbf_file 
    WHERE rbf01 = g_rbe.rbe01 AND rbf02 = g_rbe.rbe02 
      AND rbf03 = g_rbe.rbe03 AND rbfacti = 'Y' AND rbf05 = '1'
      AND rbfplant = g_rbe.rbeplant #MOD-D40005 add

   #-- << 計算出raf檔單身一中不包含rbf變更檔單身一中組別的組合數量 >> --#
   SELECT SUM(raf05) INTO l_raf05_n FROM raf_file 
    WHERE raf01 = g_rbe.rbe01 AND raf02 = g_rbe.rbe02 AND rafacti = 'Y' 
      AND rafplant = g_rbe.rbeplant #MOD-D40005 add 
      #AND rafplant = g_rbe.rbe01  #TQC-D30007 add #MOD-D40005 mark
      AND raf03 NOT IN (SELECT rbf06 FROM rbf_file 
                         WHERE rbf01 = g_rbe.rbe01 AND rbf02 = g_rbe.rbe02 
                           AND rbfplant = g_rbe.rbeplant #MOD-D40005 add 
                           AND rbf03 = g_rbe.rbe03 AND rbf05 = '1')

   #-- << 計算出rbf變更檔中單身一參與方式為 '2.可選'的資料數量 >> --#
   SELECT COUNT(*) INTO l_cnt1 FROM rbf_file 
    WHERE rbf01 = g_rbe.rbe01 AND rbf02 = g_rbe.rbe02 
      AND rbf03 = g_rbe.rbe03 AND rbfacti = 'Y' AND rbf07 = '2' AND rbf05 = '1'
      AND rbfplant = g_rbe.rbeplant #MOD-D40005 add

   #-- << 計算出raf檔單身一中不包含rbf變更檔單身一中組別的參與方式為 '2.可選'的資料數量 >> --#
   SELECT COUNT(*) INTO l_cnt2 FROM raf_file 
    WHERE raf01 = g_rbe.rbe01 AND raf02 = g_rbe.rbe02 AND rafacti = 'Y' 
      AND rafplant = g_rbe.rbeplant #MOD-D40005 add
      AND raf04 = '2' AND raf03 NOT IN (SELECT rbf06 FROM rbf_file 
                                         WHERE rbf01 = g_rbe.rbe01 
                                           AND rbf02 = g_rbe.rbe02 
                                           AND rbf03 = g_rbe.rbe03 
                                           AND rbfplant = g_rbe.rbeplant #MOD-D40005 add 
                                           AND rbf05 = '1')

   IF cl_null(l_rbf08_n) THEN LET l_rbf08_n = 0 END IF
   IF cl_null(l_raf05_n) THEN LET l_raf05_n = 0 END IF

   #-- << 判斷變更后單身一的組合總數是否滿足單頭的組合總數的設置 >> --#
   #-- << 即：1.單身一的組合總數大於單頭組合總數 >> --#
   #-- <<     2.單身一的組合總數等於單頭組合總數並且存在參與方式為 '2.可選'的資料 >> --#
   #-- <<     3.單身一的組合總數小於單頭組合總數並且不存在參與方式為 '2.可選'的資料 >> --#
   #-- << 若滿足以上條件的其中一條,則給予報錯信息 >> --#
   IF (l_rbf08_n + l_raf05_n > g_rbe.rbe21t) 
      OR ((l_rbf08_n + l_raf05_n = g_rbe.rbe21t) AND (l_cnt1 + l_cnt2 > 0)) 
      OR ((l_rbf08_n + l_raf05_n < g_rbe.rbe21t) AND (l_cnt1 + l_cnt2 = 0)) THEN
      LET g_errno = 'art-728'
   END IF
END FUNCTION

FUNCTION t403_check_rbf06()
DEFINE l_cnt1   LIKE type_file.num5
DEFINE l_cnt2   LIKE type_file.num5

   SELECT COUNT(*) INTO l_cnt1 FROM rbf_file 
    WHERE rbf01 = g_rbe.rbe01 AND rbf02 = g_rbe.rbe02
      AND rbf03 = g_rbe.rbe03 AND rbf05 = '1'
      AND rbfplant = g_rbe.rbeplant AND rbfacti = 'Y'
      AND rbf06 NOT IN (SELECT rag03 FROM rag_file
                         WHERE rag01 = g_rbe.rbe01 AND rag02 = g_rbe.rbe02
                           AND ragplant = g_rbe.rbeplant AND ragacti = 'Y'
                           AND rag03 NOT IN (SELECT rbg06 FROM rbg_file
                                              WHERE rbg01 = g_rbe.rbe01 AND rbg02 = g_rbe.rbe02
                                                AND rbg03 = g_rbe.rbe03 AND rbg05 = '1'))
      AND rbf06 NOT IN (SELECT rbg06 FROM rbg_file
                         WHERE rbg01 = g_rbe.rbe01 AND rbg02 = g_rbe.rbe02
                           AND rbg03 = g_rbe.rbe03 AND rbg05 = '1'
                           AND rbgacti = 'Y')

   SELECT COUNT(*) INTO l_cnt2 FROM raf_file
    WHERE raf01 = g_rbe.rbe01 AND raf02 = g_rbe.rbe02
      AND rafplant = g_rbe.rbeplant AND rafacti = 'Y'
      AND raf03 NOT IN (SELECT rbf06 FROM rbf_file
                         WHERE rbf01 = g_rbe.rbe01 AND rbf02 = g_rbe.rbe02
                           AND rbf03 = g_rbe.rbe03 AND rbf05 = '1')
      AND raf03 NOT IN (SELECT rag03 FROM rag_file
                         WHERE rag01 = g_rbe.rbe01 AND rag02 = g_rbe.rbe02
                           AND ragplant = g_rbe.rbeplant AND ragacti = 'Y'
                           AND rag03 NOT IN (SELECT rbg06 FROM rbg_file
                                              WHERE rbg01 = g_rbe.rbe01 AND rbg02 = g_rbe.rbe02
                                                AND rbg03 = g_rbe.rbe03 AND rbg05 = '1'))
      AND raf03 NOT IN (SELECT rbg06 FROM rbg_file
                         WHERE rbg01 = g_rbe.rbe01 AND rbg02 = g_rbe.rbe02
                           AND rbg03 = g_rbe.rbe03 AND rbg05 = '1'
                           AND rbgacti = 'Y')

   IF l_cnt1 + l_cnt2 > 0 THEN
      LET g_errno = 'art-730'
   END IF
END FUNCTION
#-TQC-B60071- ADD -  END  ------------------------------------

#FUN-A80104 
#FUN-BC0078 add START
FUNCTION t403_b()
   DEFINE  l_ac1_t         LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680136 SMALLINT
           l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-680136 SMALLINT
           l_cnt           LIKE type_file.num5,                #No.MOD-650101 add  #No.FUN-680136 SMALLINT
           l_lock_sw       LIKE type_file.chr1,                #單身鎖住否  #No.FUN-680136 VARCHAR(1)
           l_allow_insert  LIKE type_file.num5,    #可新增否  #No.FUN-680136 SMALLINT
           l_allow_delete  LIKE type_file.num5,    #可刪除否  #No.FUN-680136 SMALLINT
           p_cmd           LIKE type_file.chr1                  #處理狀態  #No.FUN-680136 VARCHAR(1)
   DEFINE  l_rbf04_curr    LIKE rbf_file.rbf04 
   DEFINE  l_price         LIKE rac_file.rac05
   DEFINE  l_discount      LIKE rac_file.rac06
   DEFINE  l_date          LIKE rac_file.rac12
   #yemy 20130517  --Begin
   DEFINE  l_time1         LIKE type_file.num10
   DEFINE  l_time2         LIKE type_file.num10
   #yemy 20130517  --End  
   DEFINE  l_ac2_t         LIKE type_file.num5
   DEFINE  l_ima25         LIKE ima_file.ima25
   DEFINE  l_rbg04_curr    LIKE rbg_file.rbg04 
   DEFINE l_rbk        RECORD LIKE rbk_file.*
   DEFINE l_ac3_t      LIKE type_file.num5
   DEFINE l_rbk04_curr LIKE rbk_file.rbk04
   DEFINE l_sql            STRING

    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_rbe.rbe02) THEN
       RETURN
    END IF
    SELECT * INTO g_rbe.* FROM rbe_file
     WHERE rbe01 = g_rbe.rbe01 AND rbe02 = g_rbe.rbe02 
       AND rbe03 = g_rbe.rbe03 AND rbeplant = g_rbe.rbeplant

    IF g_rbe.rbeacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_rbe.rbe01||g_rbe.rbe02,'mfg1000',1)
       RETURN
    END IF 
    IF g_rbe.rbeconf = 'Y' OR g_rbe.rbeconf = 'I'  THEN
       CALL cl_err('','art-024',1)
       RETURN
    END IF
    IF g_rbe.rbe01 <> g_rbe.rbeplant THEN
       CALL cl_err('','art-977',0)
       RETURN
    END IF

    CALL cl_opmsg('b')
    LET g_forupd_sql = " SELECT b.rbf04,'','','','','','',",
                       "                   b.rbf05,b.rbf06,b.rbf07,b.rbf08,b.rbfacti ",
                       "   FROM rbf_file b ",
                       "  WHERE b.rbf01 = ?  AND b.rbf02 = ? AND b.rbf03= ? AND b.rbfplant= ? ",
                       "    AND b.rbf06 = ? ",
                       "    FOR UPDATE "                   
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t403_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET g_forupd_sql = " SELECT *  ",
                       "   FROM rbg_file ",
                       "  WHERE rbg01 = ? AND rbg02 = ? ",
                       "    AND rbg03=? AND rbgplant=?  AND rbg06=? AND rbg07=? ",  
                       "    AND rbg08=? AND rbg09=?  FOR UPDATE   "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t4031_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET g_forupd_sql = "SELECT * ",
                       "  FROM rbk_file ",
                       " WHERE rbk01=? AND rbk02=? AND rbk03=? AND rbk05 = '2' ",
                       "   AND rbk06 = '1' AND rbk08 = ? AND rbkplant = ? ",
                       " FOR UPDATE  "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t4032_bcl CURSOR FROM g_forupd_sql

    LET l_ac1_t = 0
    LET l_ac2_t = 0
    LET l_ac3_t = 0

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    DIALOG ATTRIBUTES(UNBUFFERED)


       INPUT ARRAY g_rbk FROM s_rbk.*
             ATTRIBUTE(COUNT=g_rec_b3,MAXCOUNT=g_max_rec,
                       INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                       APPEND ROW=l_allow_insert)
   
           BEFORE INPUT
              IF g_rec_b3 != 0 THEN
                 CALL fgl_set_arr_curr(l_ac3)
              END IF
              LET g_b_flag = '1'   #FUN-D30033 add
              CALL t403_set_rbk11_format("rbk11")
              CALL t403_set_rbk11_format("rbk12")
   
           BEFORE ROW
              LET p_cmd = ''
              LET l_ac3 = ARR_CURR()
              LET l_lock_sw = 'N'            #DEFAULT
              LET l_n  = ARR_COUNT()
              BEGIN WORK
   
              OPEN t403_cl USING g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,g_rbe.rbeplant 
              IF STATUS THEN
                 CALL cl_err("OPEN t403_cl:", STATUS, 1)
                 CLOSE t403_cl
                 ROLLBACK WORK
                 RETURN
              END IF
   
              FETCH t403_cl INTO g_rbe.*
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_rbe.rbe02,SQLCA.sqlcode,0)
                 CLOSE t403_cl
                 ROLLBACK WORK
                 RETURN
              END IF
   
              IF g_rec_b3 >= l_ac3 THEN
                 LET p_cmd='u'
                 LET g_rbk_t.* = g_rbk[l_ac3].*  #BACKUP
                 LET g_rbk_o.* = g_rbk[l_ac3].*  #BACKUP
                 OPEN t4032_bcl USING g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,
                                      g_rbk_t.rbk08,g_rbe.rbeplant
                 IF STATUS THEN
                    CALL cl_err("OPEN t4032_bcl:", STATUS, 1)
                 ELSE                                                       
                    SELECT b.rbk04,'',a.rbk06,a.rbk08,a.rbk09,a.rbk10,a.rbk11,a.rbk12,a.rbk13,a.rbk14,a.rbkacti,
                            b.rbk06,b.rbk08,b.rbk09,b.rbk10,b.rbk11,b.rbk12,b.rbk13,b.rbk14,b.rbkacti 
                        INTO l_rbk04_curr,g_rbk[l_ac3].*
                        FROM rbk_file b LEFT OUTER JOIN rbk_file a 
                          ON (b.rbk01=a.rbk01 AND b.rbk02=a.rbk02 AND b.rbk03=a.rbk03 AND b.rbk04=a.rbk04 
                              AND b.rbk07=a.rbk07 AND b.rbk08=a.rbk08 AND b.rbkplant=a.rbkplant AND b.rbk06<>a.rbk06 )
                       WHERE b.rbk01 = g_rbe.rbe01  AND b.rbk02 = g_rbe.rbe02
                         AND b.rbk03 = g_rbe.rbe03 AND b.rbkplant= g_rbe.rbeplant
                         AND b.rbk08 = g_rbk_t.rbk08
                         AND b.rbk06='1' AND b.rbk05 = '2' 
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_rbk_t.type2||g_rbk_t.rbk08,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"                       
                    END IF
                    IF g_rbk[l_ac3].before2='0' THEN
                       LET g_rbk[l_ac3].type2 ='1'
                    ELSE
                       LET g_rbk[l_ac3].type2 ='0'
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
                WHERE rbk01=g_rbe.rbe01
                  AND rbk02=g_rbe.rbe02
                  AND rbk03=g_rbe.rbe03
                  AND rbk05 = 2
                  AND rbkplant=g_rbe.rbeplant
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
                  VALUES(g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,l_rbk04_curr,'2',
                         g_rbk[l_ac3].after2,0,g_rbk[l_ac3].rbk08,
                         g_rbk[l_ac3].rbk09,g_rbk[l_ac3].rbk10,g_rbk[l_ac3].rbk11,
                         g_rbk[l_ac3].rbk12,g_rbk[l_ac3].rbk13,g_rbk[l_ac3].rbk14,
                         g_rbk[l_ac3].rbkacti,'1',g_rbe.rbelegal,g_rbe.rbeplant)
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("ins","rbd_file",g_rbe.rbe02||g_rbk[l_ac3].after2||g_rbk[l_ac3].rbk08,"",SQLCA.sqlcode,"","",1)
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
                  VALUES(g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,l_rbk04_curr,'2',
                         g_rbk[l_ac3].after2,0,g_rbk[l_ac3].rbk08,
                         g_rbk[l_ac3].rbk09,g_rbk[l_ac3].rbk10,g_rbk[l_ac3].rbk11,
                         g_rbk[l_ac3].rbk12,g_rbk[l_ac3].rbk13,g_rbk[l_ac3].rbk14,
                         g_rbk[l_ac3].rbkacti,'1',g_rbe.rbelegal,g_rbe.rbeplant)
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("ins","rbd_file",g_rbe.rbe02||g_rbk[l_ac3].after2||g_rbk[l_ac3].rbk08,"",SQLCA.sqlcode,"","",1)
                     CANCEL INSERT                       
                  ELSE
                     MESSAGE 'INSERT value.after O.K' 
                  END IF
                  INSERT INTO rbk_file(rbk01,rbk02,rbk03,rbk04,rbk05,rbk06,
                                       rbk07,rbk08,rbk09,rbk10,rbk11,rbk12,
                                       rbk13,rbk14,rbkacti,rbkpos,
                                       rbklegal,rbkplant)
                  VALUES(g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,l_rbk04_curr,'2',
                         g_rbk[l_ac3].before2,0,g_rbk[l_ac3].rbk08_1,
                         g_rbk[l_ac3].rbk09_1,g_rbk[l_ac3].rbk10_1,g_rbk[l_ac3].rbk11_1,
                         g_rbk[l_ac3].rbk12_1,g_rbk[l_ac3].rbk13_1,g_rbk[l_ac3].rbk14_1,
                         g_rbk[l_ac3].rbkacti_1,'1',g_rbe.rbelegal,g_rbe.rbeplant)
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("ins","rbd_file",g_rbe.rbe02||g_rbk[l_ac3].after2||g_rbk[l_ac3].rbk08,"",SQLCA.sqlcode,"","",1)
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
                   SELECT COUNT(*) INTO l_n FROM rbk_file
                     WHERE rbk01 = g_rbe.rbe01 AND rbk02 = g_rbe.rbe02
                       AND rbk03 = g_rbe.rbe03 AND rbk05 = '2'
                       AND rbk08 = g_rbk[l_ac3].rbk08
                   IF l_n > 0 THEN
                      CALL cl_err('','-239',0)
                      NEXT FIELD rbk08
                   END IF
                   LET l_n = 0
                   SELECT COUNT(*) INTO l_n FROM rbk_file
                      WHERE rbk01 = g_rbe.rbe01 AND rbk02 = g_rbe.rbe02 
                        AND rbk03 = g_rbe.rbe03 AND rbk05 = '2' 
                        AND rbkplant = g_rbe.rbeplant AND rbk08 = g_rbk[l_ac3].rbk08
                   IF l_n > 0 THEN
                      CALL cl_err('','-239',0)
                   END IF
                   LET l_n = 0
                   SELECT COUNT(*) INTO l_n FROM rak_file
                      WHERE rak01 = g_rbe.rbe01 AND rak02 = g_rbe.rbe02
                        AND rak03 = '2' 
                        AND rak05 = g_rbk[l_ac3].rbk08 AND rakplant = g_rbe.rbeplant
                   IF l_n = 0 OR cl_null(l_n) THEN       #¥¼¦s¦b©ó»«P¾P³椤,·s¼W
                      IF NOT cl_confirm('art-677') THEN   #½T©w·s¼W?
                         NEXT FIELD rbk08
                      ELSE
                         CALL t403_b3_init()
                     END IF
                   ELSE                                  #¦s¦b©ó»«P¾P³椤,­קï            
                      IF NOT cl_confirm('art-676') THEN  #½T©w­קï
                         NEXT FIELD rbk08
                      ELSE
                         CALL t403_b3_find()   
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
   
         ##yemy 20130517  --Begin
         #BEFORE FIELD rbk11
         #   CALL cl_set_field_format("rbk11","&&:&&:&&")
         ##yemy 20130517  --End  

          AFTER FIELD rbk11
            IF NOT cl_null(g_rbk[l_ac3].rbk11) THEN
               IF p_cmd = "a" OR
                      (p_cmd = "u" AND g_rbk[l_ac3].rbk11<>g_rbk_t.rbk11) THEN
                  CALL t403_chktime(g_rbk[l_ac3].rbk11) RETURNING l_time1
                  IF NOT cl_null(g_errno) THEN
                      CALL cl_err('',g_errno,0)
                      NEXT FIELD rbk11
                  ELSE
                    IF NOT cl_null(g_rbk[l_ac3].rbk12) THEN
                       CALL t403_chktime(g_rbk[l_ac3].rbk12) RETURNING l_time2
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
                    CALL t403_chktime(g_rbk[l_ac3].rbk12) RETURNING l_time2
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err('',g_errno,0)
                       NEXT FIELD rbk12
                    ELSE
                       IF NOT cl_null(g_rbk[l_ac3].rbk11) THEN
                          CALL t403_chktime(g_rbk[l_ac3].rbk11) RETURNING l_time1
                          IF l_time1>=l_time2 THEN
                             CALL cl_err('','art-207',0)
                             NEXT FIELD rbk12
                          END IF
                       END IF
                    END IF
                END IF
             END IF
   
          ON CHANGE rbk13
             CALL t403_set_entry_rbk()
   
          ON CHANGE rbk14
             CALL t403_set_entry_rbk()
   
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
                 WHERE rbk02 = g_rbe.rbe02 AND rbk01 = g_rbe.rbe01
                   AND rbk03 = g_rbe.rbe03 AND rbk04 = l_rbk04_curr
                   AND rbk05 = '2' 
                   AND rbkplant = g_rbe.rbeplant
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","rbk_file",g_rbe.rbe01,g_rbk_t.rbk08,SQLCA.sqlcode,"","",1) 
                   ROLLBACK WORK
                   CANCEL DELETE 
                END IF
                CALL t403_upd_log() 
                LET g_rec_b3=g_rec_b3-1
             END IF
   
          ON ROW CHANGE
             IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                LET g_rbk[l_ac3].* = g_rbk_t.*
                CLOSE t4032_bcl
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
                 WHERE rbk02 = g_rbe.rbe02 AND rbk01=g_rbe.rbe01
                   AND rbk03 = g_rbe.rbe03 AND rbk04=l_rbk04_curr AND rbk05='2'
                   AND rbk06= '1' AND rbkplant = g_rbe.rbeplant
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                   CALL cl_err3("upd","rbk_file",g_rbe.rbe01,g_rbk_t.rbk08,SQLCA.sqlcode,"","",1) 
                   LET g_rbk[l_ac3].* = g_rbk_t.*
                ELSE
                   MESSAGE 'UPDATE rbk_file O.K'
                   CALL t403_upd_log() 
                   COMMIT WORK
                END IF
             END IF
   
          AFTER ROW
             LET l_ac3 = ARR_CURR()
            #LET l_ac3_t = l_ac3      #FUN-D30033 Mark
             IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                IF p_cmd = 'u' THEN
                   LET g_rbk[l_ac3].* = g_rbk_t.*
                END IF
                CLOSE t4032_bcl
                ROLLBACK WORK
                EXIT DIALOG 
             END IF  
             LET l_ac3_t = l_ac3      #FUN-D30033 Add 
             CLOSE t4032_bcl
             COMMIT WORK
   
       END INPUT


       INPUT ARRAY g_rbf FROM s_rbf.*
             ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,
             INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

       BEFORE INPUT
           IF g_rec_b1 != 0 THEN
              CALL fgl_set_arr_curr(l_ac1)
           END IF
           LET g_b_flag = '2'   #FUN-D30033 add
           

       BEFORE ROW
           LET p_cmd = ''
           LET l_ac1 = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
           BEGIN WORK

           OPEN t403_cl USING g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,g_rbe.rbeplant
           IF STATUS THEN
              CALL cl_err("OPEN t403_cl:", STATUS, 1)
              CLOSE t403_cl
              ROLLBACK WORK
              RETURN
           END IF
           FETCH t403_cl INTO g_rbe.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_rbe.rbe01||g_rbe.rbe02,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE t403_cl
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b1>=l_ac1 THEN
               LET p_cmd='u'
               LET g_rbf_t.* = g_rbf[l_ac1].*  #BACKUP
               LET g_rbf_o.* = g_rbf[l_ac1].*  #BACKUP
               OPEN t403_bcl USING g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,g_rbe.rbeplant,g_rbf_t.rbf06                    
               IF STATUS THEN
                   CALL cl_err("OPEN t403_bcl:", STATUS, 1)
               ELSE
                   #FETCH t403_bcl INTO l_rbf04_curr,g_rbf[l_ac1].*
                   SELECT b.rbf04,'',a.rbf05,a.rbf06,a.rbf07,a.rbf08,a.rbfacti,
                          b.rbf05,b.rbf06,b.rbf07,b.rbf08,b.rbfacti
                     INTO l_rbf04_curr,g_rbf[l_ac1].*
                     FROM rbf_file b LEFT OUTER JOIN rbf_file a
                       ON (b.rbf01=a.rbf01 AND b.rbf02=a.rbf02 AND b.rbf03=a.rbf03 
                      AND  b.rbf04=a.rbf04 AND b.rbf06=a.rbf06 AND b.rbfplant=a.rbfplant 
                      AND b.rbf05<>a.rbf05 )
                    WHERE b.rbf01 =g_rbe.rbe01  AND b.rbf02 =g_rbe.rbe02 AND b.rbf03=g_rbe.rbe03
                      AND b.rbfplant=g_rbe.rbeplant  
                      AND b.rbf06 = g_rbf_t.rbf06 
                      AND b.rbf05='1' 
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_rbf_t.type||g_rbf_t.rbf06,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"                       
                   END IF
                   IF g_rbf[l_ac1].before='0' THEN
                      LET g_rbf[l_ac1].type ='1'
                   ELSE
                      LET g_rbf[l_ac1].type ='0'
                   END IF                  
               END IF
               CALL cl_show_fld_cont()      
           END IF
           CALL t403_rbf_entry(g_rbf[l_ac1].rbf07) 

       BEFORE INSERT
           #DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_rbf[l_ac1].* TO NULL 
           LET g_rbf[l_ac1].type = '0'      
           LET g_rbf[l_ac1].before = '0'
           LET g_rbf[l_ac1].after  = '1'
           LET g_rbf_t.* = g_rbf[l_ac1].*         #新輸入資料
           LET g_rbf_o.* = g_rbf[l_ac1].*
           SELECT MAX(rbf04)+1 INTO l_rbf04_curr 
             FROM rbf_file
            WHERE rbf01=g_rbe.rbe01
              AND rbf02=g_rbe.rbe02 
              AND rbf03=g_rbe.rbe03 
              AND rbfplant=g_rbe.rbeplant
             IF l_rbf04_curr IS NULL OR l_rbf04_curr=0 THEN
                LET l_rbf04_curr = 1
             END IF
          CALL t403_rbf_entry(g_rbf[l_ac1].rbf07)    
          CALL cl_show_fld_cont()
          NEXT FIELD rbf06     
       
       AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF 
           SELECT COUNT(*) INTO l_n FROM rbf_file
            WHERE rbf01=g_rbe.rbe01 AND rbf02=g_rbe.rbe02
              AND rbf03=g_rbe.rbe03 AND rbfplant=g_rbe.rbeplant
              AND rbf06=g_rbf[l_ac1].rbf06                
           IF l_n>0 THEN 
              CALL cl_err('',-239,0)
              LET g_rbf[l_ac1].* = g_rbf_t.*
              NEXT FIELD rbf06
           END IF  
           IF g_rbf[l_ac1].type= '0' THEN  #新增時
              INSERT INTO rbf_file(rbf01,rbf02,rbf03,rbf04,rbf05,rbf06,rbf07,
                                   rbf08,rbfacti,rbfplant,rbflegal)
              VALUES(g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,l_rbf04_curr,g_rbf[l_ac1].after,
                     g_rbf[l_ac1].rbf06,g_rbf[l_ac1].rbf07,g_rbf[l_ac1].rbf08,
                     g_rbf[l_ac1].rbfacti,g_rbe.rbeplant,g_rbe.rbelegal) 
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("ins","rbf_file",g_rbe.rbe02||g_rbf[l_ac1].after||g_rbf[l_ac1].rbf06,"",SQLCA.sqlcode,"","",1)
                 CANCEL INSERT
              ELSE
                 #MESSAGE 'INSERT O.K'
                 COMMIT WORK
                 LET g_rec_b1=g_rec_b1+1
                 DISPLAY g_rec_b1 TO FORMONLY.cn1
              END IF           
           ELSE  #修改時
              INSERT INTO rbf_file(rbf01,rbf02,rbf03,rbf04,rbf05,rbf06,rbf07,
                                   rbf08,rbfacti,rbfplant,rbflegal)                                    
              VALUES(g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,l_rbf04_curr,g_rbf[l_ac1].after,
                     g_rbf[l_ac1].rbf06,g_rbf[l_ac1].rbf07,g_rbf[l_ac1].rbf08,
                     g_rbf[l_ac1].rbfacti,g_rbe.rbeplant,g_rbe.rbelegal)
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("ins","rbf_file",g_rbe.rbe02||g_rbf[l_ac1].after||g_rbf[l_ac1].rbf06,"",SQLCA.sqlcode,"","",1)
                 CANCEL INSERT 
              #ELSE
              #   MESSAGE 'INSERT value.after O.K' 
              END IF
              INSERT INTO rbf_file(rbf01,rbf02,rbf03,rbf04,rbf05,rbf06,rbf07,
                                   rbf08,rbfacti,rbfplant,rbflegal)                                    
              VALUES(g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,l_rbf04_curr,g_rbf[l_ac1].before,
                     g_rbf[l_ac1].rbf06_1,g_rbf[l_ac1].rbf07_1,g_rbf[l_ac1].rbf08_1,
                     g_rbf[l_ac1].rbfacti_1,g_rbe.rbeplant,g_rbe.rbelegal)
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("ins","rbf_file",g_rbe.rbe02||g_rbf[l_ac1].before||g_rbf[l_ac1].rbf06,"",SQLCA.sqlcode,"","",1)
                 CANCEL INSERT
              ELSE
                 #MESSAGE 'INSERT value.before O.K'
                 COMMIT WORK
                 LET g_rec_b1=g_rec_b1+1
                 DISPLAY g_rec_b1 TO FORMONLY.cn1
              END IF
           END IF 
    
       AFTER FIELD rbf06
          IF NOT cl_null(g_rbf[l_ac1].rbf06) THEN
             IF (g_rbf[l_ac1].rbf06 <> g_rbf_t.rbf06
                OR cl_null(g_rbf_t.rbf06)) THEN 
                LET l_n = 0
                SELECT COUNT(*) INTO l_n FROM rbf_file
                  WHERE rbf01 = g_rbe.rbe01 AND rbf02 = g_rbe.rbe02
                    AND rbf03 = g_rbe.rbe03 AND rbfplant = g_rbe.rbeplant
                    AND rbf06 = g_rbf[l_ac1].rbf06
                IF l_n > 0 THEN
                   CALL cl_err('','-239',0)
                   NEXT FIELD rbf06
                END IF
                LET l_n =0 
                SELECT COUNT(*) INTO l_n 
                  FROM raf_file
                 WHERE raf01=g_rbe.rbe01 AND raf02=g_rbe.rbe02
                   AND rafplant=g_rbe.rbeplant AND raf03=g_rbf[l_ac1].rbf06
                IF l_n=0 THEN
                   IF NOT cl_confirm('art-677') THEN   #確定新增?
                      NEXT FIELD rbf06
                   ELSE
                      CALL t403_b1_init()
                   END IF
                ELSE
                   IF NOT cl_confirm('art-676') THEN   #確定修改?
                      NEXT FIELD rbf06
                   ELSE
                      CALL t403_b1_find()   
                   END IF           
                END IF
             END IF       
          END IF
          
       BEFORE FIELD rbf07   #rbe21為空時，只能為1
          IF NOT cl_null(g_rbe.rbe21t) AND g_rbe.rbe21t<>0 THEN     
             CALL cl_set_comp_entry("rbf07",TRUE)
          ELSE
             LET g_rbf[l_ac1].rbf07='1'
          END IF
 
       AFTER FIELD rbf07
          IF NOT cl_null(g_rbf[l_ac1].rbf07) THEN
             IF g_rbf_o.rbf07 IS NULL OR
                (g_rbf[l_ac1].rbf07 != g_rbf_o.rbf07 ) THEN
                IF g_rbf[l_ac1].rbf07 NOT MATCHES '[12]' THEN
                   LET g_rbf[l_ac1].rbf07= g_rbf_o.rbf07
                   NEXT FIELD rbf07
                ELSE
                   CALL t403_rbf_entry(g_rbf[l_ac1].rbf07)
                END IF
             END IF
          END IF        
            
       ON CHANGE rbf07
          IF NOT cl_null(g_rbf[l_ac1].rbf07) THEN
             CALL t403_rbf_entry(g_rbf[l_ac1].rbf07)
          END IF 
       
       AFTER FIELD rbf08      
           IF NOT cl_null(g_rbf[l_ac1].rbf08) THEN
             IF g_rbf_o.rbf08 IS NULL OR g_rbf_o.rbf08=0 OR
                (g_rbf[l_ac1].rbf08 != g_rbf_o.rbf08 ) THEN
                CALL t403_rbf08_check(g_rbf[l_ac1].rbf08)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('rbf08',g_errno,0)
                   LET g_rbf[l_ac1].rbf08= g_rbf_o.rbf08
                   NEXT FIELD rbf08
                ELSE
                   DISPLAY BY NAME g_rbf[l_ac1].rbf08
                END IF 
             END IF 
          END IF 
        
       BEFORE DELETE
            IF g_rbf_t.rbf06 > 0 AND g_rbf_t.rbf06 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
               SELECT COUNT(*) INTO l_n FROM rbg_file
                WHERE rbg01=g_rbe.rbe01 AND rbg02=g_rbe.rbe02
                  AND rbg03=g_rbe.rbe03 AND rbgplant=g_rbe.rbeplant
                  AND rbg06=g_rbf_t.rbf06
               IF l_n>0 THEN
                  CALL cl_err(g_rbf_t.rbf06,'art-664',0)  #已在第二單身使用
                  CANCEL DELETE
               ELSE 
                  SELECT COUNT(*) INTO l_n FROM rbp_file
                   WHERE rbp01=g_rbe.rbe01 AND rbp02=g_rbe.rbe02 AND rbp04='2'
                     AND rbp03=g_rbe.rbe03 AND rbpplant=g_rbe.rbeplant
                     AND rbp07=g_rbf_t.rbf06  #組別
                  IF l_n>0 THEN
                     CALL cl_err(g_rbf_t.rbf06,'art-665',0) #會員等級促銷中使用
                     CANCEL DELETE 
                  END IF
               END IF             
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
               DELETE FROM rbf_file
                WHERE rbf02 = g_rbe.rbe02 AND rbf01 = g_rbe.rbe01
                  AND rbf03 = g_rbe.rbe03 AND rbf04 = l_rbf04_curr
                  AND rbf06 = g_rbf_t.rbf06  
                  AND rbfplant = g_rbe.rbeplant
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","rbf_file",g_rbe.rbe01,g_rbf_t.rbf06,SQLCA.sqlcode,"","",1) 
                  ROLLBACK WORK
                  CANCEL DELETE 
               END IF
               CALL t403_upd_log() 
               LET g_rec_b1=g_rec_b1-1
            END IF
            COMMIT WORK
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_rbf[l_ac1].* = g_rbf_t.*
             CLOSE t403_bcl
             ROLLBACK WORK
             EXIT DIALOG 
          END IF
          IF cl_null(g_rbf[l_ac1].rbf07) THEN
             NEXT FIELD rbf07
          END IF
            
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_rbf[l_ac1].rbf06,-263,1)
             LET g_rbf[l_ac1].* = g_rbf_t.*
          ELSE
             UPDATE rbf_file SET rbf07  =g_rbf[l_ac1].rbf07,
                                 rbf06  =g_rbf[l_ac1].rbf06,  #TQC-B60071 ADD
                                 rbf08  =g_rbf[l_ac1].rbf08,
                                 rbfacti=g_rbf[l_ac1].rbfacti
              WHERE rbf02 = g_rbe.rbe02 AND rbf01=g_rbe.rbe01
                AND rbf03 = g_rbe.rbe03 AND rbf06=g_rbf_t.rbf06
                AND rbf05='1' 
                AND rbfplant = g_rbe.rbeplant 
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                CALL cl_err3("upd","rbf_file",g_rbe.rbe01,g_rbf_t.rbf06,SQLCA.sqlcode,"","",1) 
                LET g_rbf[l_ac1].* = g_rbf_t.*
             ELSE                 
                IF cl_null(g_rbf_t.rbf06_1) THEN
                   IF NOT cl_null(g_rbf[l_ac1].rbf06_1) THEN
                      INSERT INTO rbf_file(rbf01,rbf02,rbf03,rbf04,rbf05,rbf06,rbf07,
                                           rbf08,rbfacti,rbfplant,rbflegal)
                      VALUES(g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,l_rbf04_curr,g_rbf[l_ac1].before,
                             g_rbf[l_ac1].rbf06_1,g_rbf[l_ac1].rbf07_1,g_rbf[l_ac1].rbf08_1,
                             g_rbf[l_ac1].rbfacti_1,g_rbe.rbeplant,g_rbe.rbelegal)
                   END IF
                ELSE
                   IF NOT cl_null(g_rbf[l_ac1].rbf06_1) THEN
                      UPDATE rbf_file SET rbf06   = g_rbf[l_ac1].rbf06_1,
                                          rbf07   = g_rbf[l_ac1].rbf07_1,
                                          rbf08   = g_rbf[l_ac1].rbf08_1,
                                          rbfacti = g_rbf[l_ac1].rbfacti_1
                      WHERE rbf02 = g_rbe.rbe02 AND rbf01 = g_rbe.rbe01
                        AND rbf03 = g_rbe.rbe03 AND rbf06 = g_rbf_t.rbf06_1
                        AND rbf05 = '0'
                        AND rbfplant = g_rbe.rbeplant
                   ELSE
                      DELETE FROM rbf_file
                       WHERE rbf02 = g_rbe.rbe02 AND rbf01 = g_rbe.rbe01
                         AND rbf03 = g_rbe.rbe03 AND rbf06 = g_rbf_t.rbf06_1
                         AND rbf05 = '0'
                         AND rbfplant = g_rbe.rbeplant
                   END IF
                END IF
                CALL t403_upd_log() 
                COMMIT WORK
             END IF
          END IF

       AFTER ROW
          LET l_ac1 = ARR_CURR()
         #LET l_ac1_t = l_ac1     #FUN-D30033 Mark
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
                LET g_rbf[l_ac1].* = g_rbf_t.*
             END IF
             CLOSE t403_bcl
             ROLLBACK WORK
             EXIT DIALOG 
          END IF
          LET l_ac1_t = l_ac1     #FUN-D30033 Add  
          CLOSE t403_bcl
          COMMIT WORK

       END INPUT  

       INPUT ARRAY g_rbg FROM s_rbg.*
       ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                 APPEND ROW=l_allow_insert)

       BEFORE INPUT
          IF g_rec_b2 != 0 THEN
             CALL fgl_set_arr_curr(l_ac2)
          END IF
          LET g_b_flag = '3'   #FUN-D30033 add 

       BEFORE ROW
          LET p_cmd = ''
          LET l_ac2 = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()

          BEGIN WORK 
          OPEN t403_cl USING g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,g_rbe.rbeplant
          IF STATUS THEN
             CALL cl_err("OPEN t403_cl:", STATUS, 1)
             CLOSE t403_cl
             ROLLBACK WORK
             RETURN
          END IF 
          FETCH t403_cl INTO g_rbe.*
          IF SQLCA.sqlcode THEN
             CALL cl_err(g_rbe.rbe02,SQLCA.sqlcode,0)
             CLOSE t403_cl
             ROLLBACK WORK
             RETURN
          END IF

          IF g_rec_b2 >= l_ac2 THEN
             LET p_cmd = 'u'
             LET g_rbg_t.* = g_rbg[l_ac2].*  #BACKUP
             LET g_rbg_o.* = g_rbg[l_ac2].*  #BACKUP
             CALL t403_rbg07()
             IF cl_null(g_rbg_t.rbg09) THEN
                LET g_rbg_t.rbg09=' '
             END IF   
             OPEN t4031_bcl USING g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,g_rbe.rbeplant,
                                  g_rbg_t.rbg06,g_rbg_t.rbg07,g_rbg_t.rbg08,g_rbg_t.rbg09
             IF STATUS THEN
                CALL cl_err("OPEN t4031_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE         
                SELECT b.rbg04,'',a.rbg05,a.rbg06,a.rbg07,a.rbg08,'',a.rbg09,'',a.rbgacti,
                       b.rbg05,b.rbg06,b.rbg07,b.rbg08,'',b.rbg09,'',b.rbgacti
                  INTO l_rbg04_curr,g_rbg[l_ac2].*
                  FROM rbg_file b LEFT OUTER JOIN rbg_file a
                    ON (b.rbg01=a.rbg01 AND b.rbg02=a.rbg02 AND b.rbg03=a.rbg03 AND b.rbg04=a.rbg04 
                   AND b.rbg06=a.rbg06 AND b.rbg07=a.rbg07 AND b.rbgplant=a.rbgplant AND b.rbg05<>a.rbg05 )
                 WHERE b.rbg01 =g_rbe.rbe01 AND b.rbg02 =g_rbe.rbe02 
                   AND b.rbg03=g_rbe.rbe03 AND b.rbgplant=g_rbe.rbeplant  AND b.rbg06=g_rbg_t.rbg06
                   AND b.rbg07=g_rbg_t.rbg07   AND b.rbg05='1' 
                   AND b.rbg08=g_rbg_t.rbg08   AND b.rbg09=g_rbg_t.rbg09                 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_rbg_t.rbg06,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
                IF g_rbg[l_ac1].before1='0' THEN
                   LET g_rbg[l_ac1].type1 ='1'
                ELSE
                   LET g_rbg[l_ac1].type1 ='0'
                END IF 
                CALL t403_rbg08('d',l_ac2)
                CALL t403_rbg08_1('d',l_ac2)
                CALL t403_rbg09('d')
             END IF
          END IF 

       BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_rbg[l_ac2].* TO NULL 
           LET g_rbg[l_ac2].type1 = '0'      
           LET g_rbg[l_ac2].before1 = '0'
           LET g_rbg[l_ac2].after1  = '1'  
           LET g_rbg[l_ac2].rbgacti = 'Y' 
          SELECT MIN(rbf06) INTO g_rbg[l_ac2].rbg06 FROM rbf_file
           WHERE rbf01=g_rbe.rbe01 
             AND rbf02=g_rbe.rbe02 
             AND rbf03=g_rbe.rbe03 
             AND rbfplant=g_rbe.rbeplant
             
           LET g_rbg_t.* = g_rbg[l_ac2].*         #新輸入資料
           LET g_rbg_o.* = g_rbg[l_ac2].*         #新輸入資料
           
           SELECT MAX(rbg04)+1 INTO l_rbg04_curr 
             FROM rbg_file
            WHERE rbg01=g_rbe.rbe01
              AND rbg02=g_rbe.rbe02 
              AND rbg03=g_rbe.rbe03 
              AND rbgplant=g_rbe.rbeplant
             IF l_rbg04_curr IS NULL OR l_rbg04_curr=0 THEN
                LET l_rbg04_curr = 1
             END IF
           IF cl_null(g_rbg[l_ac2].rbg09) THEN
             LET g_rbg[l_ac2].rbg09 = ' '
           END IF  
           CALL cl_show_fld_cont()
           NEXT FIELD rbg06 

       AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF cl_null(g_rbg[l_ac2].rbg09) THEN
              LET g_rbg[l_ac2].rbg09=' '
           END IF
           IF cl_null(g_rbg[l_ac2].rbg09_1) THEN
              LET g_rbg[l_ac2].rbg09_1=' '
           END IF
           SELECT COUNT(*) INTO l_n FROM rbg_file
            WHERE rbg01=g_rbe.rbe01 AND rbg02=g_rbe.rbe02
              AND rbg03=g_rbe.rbe03 AND rbgplant=g_rbe.rbeplant
              AND rbg06=g_rbg[l_ac2].rbg06 
              AND rbg07=g_rbg[l_ac2].rbg07 
              AND rbg08=g_rbg[l_ac2].rbg08 
              AND rbg09=g_rbg[l_ac2].rbg09
           IF l_n>0 THEN 
              CALL cl_err('',-239,0)
              NEXT FIELD rbg06
           END IF       
           IF g_rbg[l_ac2].type1= '0' THEN               
              INSERT INTO rbg_file(rbg01,rbg02,rbg03,rbg04,rbg05,rbg06,rbg07,rbg08,rbg09,                                     
                                   rbgacti,rbgplant,rbglegal)
              VALUES(g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,l_rbg04_curr,g_rbg[l_ac2].after1,
                     g_rbg[l_ac2].rbg06,g_rbg[l_ac2].rbg07,g_rbg[l_ac2].rbg08,g_rbg[l_ac2].rbg09, 
                     g_rbg[l_ac2].rbgacti,g_rbe.rbeplant,g_rbe.rbelegal) 
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("ins","rbg_file",g_rbe.rbe02||g_rbg[l_ac2].after1||g_rbg[l_ac2].rbg06,"",SQLCA.sqlcode,"","",1)
                 CANCEL INSERT
              ELSE
                 CALL s_showmsg_init()
                 LET g_errno=' '
                 CALL s_showmsg()
                 IF NOT cl_null(g_errno) THEN
                    LET g_rbg[l_ac2].* = g_rbg_t.*
                    ROLLBACK WORK
                    NEXT FIELD PREVIOUS
                 ELSE
                    COMMIT WORK
                    LET g_rec_b2=g_rec_b2+1
                    DISPLAY g_rec_b2 TO FORMONLY.cn2
                 END IF                  
              END IF
          
           ELSE
              INSERT INTO rbg_file(rbg01,rbg02,rbg03,rbg04,rbg05,rbg06,rbg07,rbg08,rbg09,                                    
                                   rbgacti,rbgplant,rbglegal)
              VALUES(g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,l_rbg04_curr,g_rbg[l_ac2].after1,
                     g_rbg[l_ac2].rbg06,g_rbg[l_ac2].rbg07,g_rbg[l_ac2].rbg08,g_rbg[l_ac2].rbg09, 
                     g_rbg[l_ac2].rbgacti,g_rbe.rbeplant,g_rbe.rbelegal) 
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("ins","rbg_file",g_rbe.rbe02||g_rbg[l_ac2].after1||g_rbg[l_ac2].rbg06,"",SQLCA.sqlcode,"","",1)
                 CANCEL INSERT 
              END IF
              INSERT INTO rbg_file(rbg01,rbg02,rbg03,rbg04,rbg05,rbg06,rbg07,rbg08,rbg09,                                     
                                   rbgacti,rbgplant,rbglegal)
              VALUES(g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,l_rbg04_curr,g_rbg[l_ac2].before1,
                     g_rbg[l_ac2].rbg06_1,g_rbg[l_ac2].rbg07_1,g_rbg[l_ac2].rbg08_1,g_rbg[l_ac2].rbg09_1, 
                     g_rbg[l_ac2].rbgacti_1,g_rbe.rbeplant,g_rbe.rbelegal) 
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("ins","rbg_file",g_rbe.rbe02||g_rbg[l_ac2].before1||g_rbg[l_ac2].rbg06_1,"",SQLCA.sqlcode,"","",1)
                 CANCEL INSERT               
              ELSE
                 CALL s_showmsg_init()
                 LET g_errno=' '
                 CALL s_showmsg()
                 IF NOT cl_null(g_errno) THEN
                    LET g_rbg[l_ac2].* = g_rbg_t.*
                    ROLLBACK WORK
                    NEXT FIELD PREVIOUS
                 ELSE
                    COMMIT WORK
                    LET g_rec_b2=g_rec_b2+1
                    DISPLAY g_rec_b2 TO FORMONLY.cn2
                 END IF                   
              END IF
           END IF 
       
       AFTER FIELD rbg06
          IF NOT cl_null(g_rbg[l_ac2].rbg06) THEN
             IF g_rbg_o.rbg06 IS NULL OR (g_rbg[l_ac2].rbg06 != g_rbg_o.rbg06 ) THEN
                CALL t403_rbg06()    #檢查其有效性          
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_rbg[l_ac2].rbg06,g_errno,0)
                   LET g_rbg[l_ac2].rbg06 = g_rbg_o.rbg06
                   NEXT FIELD rbg06
                END IF
                IF NOT cl_null(g_rbg[l_ac2].rbg07) AND NOT cl_null(g_rbg[l_ac2].rbg08) THEN
                  LET l_n = 0 
                  SELECT COUNT(*) INTO l_n FROM rbg_file
                    WHERE rbg01 = g_rbe.rbe01 AND rbg02 = g_rbe.rbe02
                      AND rbg03 = g_rbe.rbe03 AND rbg06 = g_rbg[l_ac2].rbg06
                      AND rbg07 = g_rbg[l_ac2].rbg07 AND rbg08 = g_rbg[l_ac2].rbg08
                      AND rbgplant = g_rbe.rbeplant
                  IF l_n > 0 THEN 
                     CALL cl_err('','-239',0)
                     NEXT FIELD rbg06
                  END IF   
                  LET l_n = 0 
                  SELECT COUNT(*) INTO l_n 
                   FROM rag_file
                  WHERE rag01=g_rbe.rbe01 AND rag02=g_rbe.rbe02
                    AND ragplant=g_rbe.rbeplant 
                    AND rag03=g_rbg[l_ac2].rbg06
                    AND rag04=g_rbg[l_ac2].rbg07
                    AND rag05=g_rbg[l_ac2].rbg08
                  IF l_n=0 THEN
                     IF NOT cl_confirm('art-678') THEN
                        NEXT FIELD rbg06
                     ELSE
                        CALL t403_b2_init()
                     END IF
                  ELSE
                     IF NOT cl_confirm('art-679') THEN
                        NEXT FIELD rbg06
                     ELSE
                        CALL t403_b2_find()   
                     END IF           
                  END IF
               END IF 
             END IF  
          END IF 

       AFTER FIELD rbg07
          IF NOT cl_null(g_rbg[l_ac2].rbg07) THEN
             IF g_rbg_o.rbg07 IS NULL OR (g_rbg[l_ac2].rbg07 != g_rbg_o.rbg07 ) THEN 
               IF NOT cl_null(g_rbg[l_ac2].rbg08) AND NOT cl_null(g_rbg[l_ac2].rbg06) THEN
                  LET l_n = 0
                  SELECT COUNT(*) INTO l_n FROM rbg_file
                    WHERE rbg01 = g_rbe.rbe01 AND rbg02 = g_rbe.rbe02
                      AND rbg03 = g_rbe.rbe03 AND rbg06 = g_rbg[l_ac2].rbg06
                      AND rbg07 = g_rbg[l_ac2].rbg07 AND rbg08 = g_rbg[l_ac2].rbg08
                      AND rbgplant = g_rbe.rbeplant
                  IF l_n > 0 THEN
                     CALL cl_err('','-239',0)
                     NEXT FIELD rbg07
                  END IF
                  LET l_n = 0 
                  SELECT COUNT(*) INTO l_n 
                   FROM rag_file
                  WHERE rag01=g_rbe.rbe01 AND rag02=g_rbe.rbe02
                    AND ragplant=g_rbe.rbeplant 
                    AND rag03=g_rbg[l_ac2].rbg06
                    AND rag04=g_rbg[l_ac2].rbg07
                    AND rag05=g_rbg[l_ac2].rbg08
                  IF l_n=0 THEN
                     IF NOT cl_confirm('art-678') THEN    #確定新增?
                        NEXT FIELD rbg07
                     ELSE
                        CALL t403_b2_init()
                     END IF
                  ELSE
                     IF NOT cl_confirm('art-679') THEN    #確定修改?
                        NEXT FIELD rbg07
                     ELSE
                        CALL t403_b2_find()   
                     END IF           
                  END IF
               END IF  
             END IF  
          END IF  
  
       ON CHANGE rbg07
          IF NOT cl_null(g_rbg[l_ac2].rbg07) THEN
             CALL t403_rbg07()   
             LET g_rbg[l_ac2].rbg08=NULL
             LET g_rbg[l_ac2].rbg08_desc=NULL
             LET g_rbg[l_ac2].rbg09=NULL
             LET g_rbg[l_ac2].rbg09_desc=NULL
             DISPLAY BY NAME g_rbg[l_ac2].rbg08,g_rbg[l_ac2].rbg08_desc
             DISPLAY BY NAME g_rbg[l_ac2].rbg09,g_rbg[l_ac2].rbg09_desc
          END IF
 
       BEFORE FIELD rbg08,rbg09
          IF NOT cl_null(g_rbg[l_ac2].rbg07) THEN
             CALL t403_rbg07()            
          END IF
 
       AFTER FIELD rbg08
          IF NOT cl_null(g_rbg[l_ac2].rbg08) THEN
             IF g_rbg[l_ac2].rbg07 = '01' THEN
                IF NOT s_chk_item_no(g_rbg[l_ac2].rbg08,'') THEN
                   CALL cl_err('',g_errno,1)
                   LET g_rbg[l_ac2].rbg08 = g_rbg_o.rbg08
                   NEXT FIELD rbg08     
                END IF
             END IF
             IF g_rbg_o.rbg08 IS NULL OR (g_rbg[l_ac2].rbg08 != g_rbg_o.rbg08 ) THEN               
                CALL t403_rbg08('a',l_ac2) 
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_rbg[l_ac2].rbg08,g_errno,0)
                   LET g_rbg[l_ac2].rbg08 = g_rbg_o.rbg08
                   NEXT FIELD rbg08
                END IF
             IF cl_null(g_rbg[l_ac2].rbg06_1) AND cl_null(g_rbg[l_ac2].rbg07_1) AND cl_null(g_rbg[l_ac2].rbg08_1) THEN
                IF NOT cl_null(g_rbg[l_ac2].rbg07)  AND NOT cl_null(g_rbg[l_ac2].rbg06)  THEN
                   LET l_n = 0
                   SELECT COUNT(*) INTO l_n FROM rbg_file
                     WHERE rbg01 = g_rbe.rbe01 AND rbg02 = g_rbe.rbe02
                       AND rbg03 = g_rbe.rbe03 AND rbg06 = g_rbg[l_ac2].rbg06
                       AND rbg07 = g_rbg[l_ac2].rbg07 AND rbg08 = g_rbg[l_ac2].rbg08
                       AND rbgplant = g_rbe.rbeplant
                   IF l_n > 0 THEN
                      CALL cl_err('','-239',0)
                      NEXT FIELD rbg08
                   END IF
                   LET l_n = 0 
                   SELECT COUNT(*) INTO l_n
                    FROM rag_file
                   WHERE rag01=g_rbe.rbe01 AND rag02=g_rbe.rbe02
                     AND ragplant=g_rbe.rbeplant
                     AND rag03=g_rbg[l_ac2].rbg06
                     AND rag04=g_rbg[l_ac2].rbg07
                     AND rag05=g_rbg[l_ac2].rbg08
                   IF l_n=0 THEN
                      IF NOT cl_confirm('art-678') THEN
                         NEXT FIELD rbg06
                      ELSE
                         CALL t403_b2_init()
                      END IF
                   ELSE
                      IF NOT cl_confirm('art-679') THEN
                         NEXT FIELD rbg06
                      ELSE
                         CALL t403_b2_find()
                      END IF
                   END IF
                END IF
             END IF
             END IF  
          END IF  
        
       ON CHANGE rbg08
          IF NOT cl_null(g_rbg[l_ac2].rbg08) THEN
             IF g_rbg[l_ac2].rbg07 = '01' THEN
                IF NOT s_chk_item_no(g_rbg[l_ac2].rbg08,'') THEN
                   CALL cl_err('',g_errno,1)
                   LET g_rbg[l_ac2].rbg08 = g_rbg_o.rbg08
                   NEXT FIELD rbg08
                END IF
             END IF
             IF g_rbg_o.rbg08 IS NULL OR (g_rbg[l_ac2].rbg08 != g_rbg_o.rbg08 ) THEN
                CALL t403_rbg08('a',l_ac2)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_rbg[l_ac2].rbg08,g_errno,0)
                   LET g_rbg[l_ac2].rbg08 = g_rbg_o.rbg08
                   NEXT FIELD rbg08
                END IF
             END IF
          END IF 

       AFTER FIELD rbg09
          IF NOT cl_null(g_rbg[l_ac2].rbg09) THEN
             IF g_rbg_o.rbg09 IS NULL OR (g_rbg[l_ac2].rbg09 != g_rbg_o.rbg09 ) THEN               
                CALL t403_rbg09('a')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_rbg[l_ac2].rbg09,g_errno,0)
                   LET g_rbg[l_ac2].rbg09 = g_rbg_o.rbg09
                   NEXT FIELD rbg09
                END IF
             END IF  
          END IF        
       
       BEFORE DELETE
          IF g_rbg_t.rbg06 > 0 AND g_rbg_t.rbg06 IS NOT NULL THEN
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
             IF cl_null(g_rbg_t.rbg09) THEN
                LET g_rbg_t.rbg09=' '
             END IF   
             DELETE FROM rbg_file
              WHERE rbg02 = g_rbe.rbe02   AND rbg01 = g_rbe.rbe01
                AND rbg03 = g_rbe.rbe03   AND rbg04 = l_rbg04_curr
                AND rbg06 = g_rbg_t.rbg06 
                AND rbgplant = g_rbe.rbeplant
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","rbg_file",g_rbe.rbe02,g_rbg_t.rbg06,SQLCA.sqlcode,"","",1)
                ROLLBACK WORK
                CANCEL DELETE
             END IF
             CALL t403_upd_log() 
             LET g_rec_b2=g_rec_b2-1
          END IF
          COMMIT WORK

       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_rbg[l_ac2].* = g_rbg_t.*
             CLOSE t4031_bcl
             ROLLBACK WORK
             EXIT DIALOG 
          END IF
          IF cl_null(g_rbg[l_ac2].rbg09) THEN
             LET g_rbg[l_ac2].rbg09=' '
          END IF 
          IF cl_null(g_rbg_t.rbg09) THEN
             LET g_rbg_t.rbg09=' '
          END IF 
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_rbg[l_ac2].rbg06,-263,1)
             LET g_rbg[l_ac2].* = g_rbg_t.*
          ELSE
             IF g_rbg[l_ac2].rbg06<>g_rbg_t.rbg06 OR
                g_rbg[l_ac2].rbg07<>g_rbg_t.rbg07 OR
                g_rbg[l_ac2].rbg08<>g_rbg_t.rbg08 OR
                g_rbg[l_ac2].rbg09<>g_rbg_t.rbg09 THEN
                SELECT COUNT(*) INTO l_n FROM rbg_file
                 WHERE rbg01 =g_rbe.rbe01 AND rbg02 = g_rbe.rbe02
                   AND rbg03=g_rbe.rbe03
                   AND rbg06 = g_rbg[l_ac2].rbg06 
                   AND rbg07 = g_rbg[l_ac2].rbg07
                   AND rbg08 = g_rbg[l_ac2].rbg08 
                   AND rbg09 = g_rbg[l_ac2].rbg09
                   AND rbgplant = g_rbe.rbeplant
                IF l_n>0 THEN 
                   CALL cl_err('',-239,0)
                  #LET g_rbg[l_ac2].* = g_rbg_t.*
                   NEXT FIELD rbg06
                END IF
             END IF                           
                UPDATE rbg_file SET rbg06=g_rbg[l_ac2].rbg06,
                                    rbg07=g_rbg[l_ac2].rbg07,
                                    rbg08=g_rbg[l_ac2].rbg08,
                                    rbg09=g_rbg[l_ac2].rbg09,
                                    rbgacti=g_rbg[l_ac2].rbgacti
                WHERE rbg02 = g_rbe.rbe02 AND rbg01=g_rbe.rbe01 AND rbg03=g_rbe.rbe03 
                  AND rbg04 = l_rbg04_curr AND rbg05='1'
                  AND rbg06=g_rbg_t.rbg06 AND rbg07=g_rbg_t.rbg07
                  AND rbg08=g_rbg_t.rbg08 AND rbg09=g_rbg_t.rbg09
                  AND rbgplant = g_rbe.rbeplant                
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                CALL cl_err3("upd","rbg_file",g_rbe.rbe02,g_rbg_t.rbg06,SQLCA.sqlcode,"","",1) 
                LET g_rbg[l_ac2].* = g_rbg_t.*
                ROLLBACK WORK 
             ELSE                
                CALL s_showmsg_init()
                LET g_errno=' '
                #CALL t403_repeat(g_rbg[l_ac1].rbg06)  #check
                CALL s_showmsg()
                IF NOT cl_null(g_errno) THEN
                   LET g_rbg[l_ac2].* = g_rbg_t.*
                   ROLLBACK WORK 
                   NEXT FIELD PREVIOUS
                ELSE
                   #MESSAGE 'UPDATE O.K'
                   CALL t403_upd_log() 
                   COMMIT WORK
                END IF              
             END IF
          END IF

       AFTER ROW
          LET l_ac2 = ARR_CURR()
         #LET l_ac2_t = l_ac2      #FUN-D30033 Mark
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
                LET g_rbg[l_ac2].* = g_rbg_t.*
             END IF
             CLOSE t4031_bcl
             ROLLBACK WORK
             EXIT DIALOG 
          END IF
          LET l_ac2_t = l_ac2      #FUN-D30033 Add
          CLOSE t4031_bcl
          COMMIT WORK
       END INPUT   

       #FUN-D30033--add--begin--
       BEFORE DIALOG
          CASE g_b_flag
               WHEN '1' NEXT FIELD rbk08
               WHEN '2' NEXT FIELD rbf06
               WHEN '3' NEXT FIELD rbg06
          END CASE
       #FUN-D30033--add--end--- 
       ON ACTION ACCEPT
          ACCEPT DIALOG

       ON ACTION CANCEL
          #FUN-D30033--add--str--
          IF g_b_flag = '1' THEN
             IF p_cmd = 'u' THEN
                LET g_rbk[l_ac3].* = g_rbk_t.* 
             ELSE
                CALL g_rbk.deleteElement(l_ac3)
                IF g_rec_b3 != 0 THEN
                   LET g_action_choice = "detail"
                END IF
             END IF
             CLOSE t4032_bcl
             ROLLBACK WORK
          END IF
          IF g_b_flag = '2' THEN
             IF p_cmd = 'u' THEN
                LET g_rbf[l_ac1].* = g_rbf_t.* 
             ELSE
                CALL g_rbf.deleteElement(l_ac1)
                IF g_rec_b1 != 0 THEN
                   LET g_action_choice = "detail"
                END IF
             END IF
             CLOSE t403_bcl
             ROLLBACK WORK
          END IF
          IF g_b_flag = '3' THEN
             IF p_cmd = 'u' THEN
                LET g_rbg[l_ac2].* = g_rbg_t.* 
             ELSE
                CALL g_rbg.deleteElement(l_ac2)
                IF g_rec_b2 != 0 THEN
                   LET g_action_choice = "detail"
                END IF
             END IF
             CLOSE t4031_bcl
             ROLLBACK WORK
          END IF
          #FUN-D30033--add--end--
          EXIT DIALOG

       ON ACTION alter_memberlevel    #會員等級促銷
          IF NOT cl_null(g_rbe.rbe02) THEN
             IF g_rbe.rbe12t <> '0' THEN  
                CALl t402_2(g_rbe.rbe01,g_rbe.rbe02,g_rbe.rbe03,'2',g_rbe.rbeplant,g_rbe.rbeconf,g_rbe.rbe10,g_rbe.rbe12t,'') #TQC-C20328 add '' 
             ELSE
                CALL cl_err('','art507',0)
             END IF
          ELSE
             CALL cl_err('',-400,0)
          END IF

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
 
 
       ON ACTION CONTROLO
          IF INFIELD(rbg06) AND l_ac2 > 1 THEN
             LET g_rbg[l_ac2].* = g_rbg[l_ac2-1].*
             LET g_rec_b2 = g_rec_b2+1
             NEXT FIELD rbg06
          END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()

       ON ACTION CONTROLG
          CALL cl_cmdask()

       ON ACTION controlp
          CASE
            WHEN INFIELD(rbg08)
                CALL cl_init_qry_var()
                CASE g_rbg[l_ac2].rbg07
                   WHEN '01'
                      CALL q_sel_ima(FALSE, "q_ima","",g_rbg[l_ac2].rbg08,"","","","","",'' ) 
                         RETURNING  g_rbg[l_ac2].rbg08
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
                IF g_rbg[l_ac2].rbg07 != '01' THEN                         
                   LET g_qryparam.default1 = g_rbg[l_ac2].rbg08
                   CALL cl_create_qry() RETURNING g_rbg[l_ac2].rbg08
                END IF   #FUN-AA0059  
                CALL t403_rbg08('d',l_ac2)
                NEXT FIELD rbg08
             WHEN INFIELD(rbg09)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gfe02"
                SELECT DISTINCT ima25
                  INTO l_ima25
                  FROM ima_file
                 WHERE ima01=g_rbg[l_ac2].rbg08  
                LET g_qryparam.arg1 = l_ima25
                LET g_qryparam.default1 = g_rbg[l_ac2].rbg09
                CALL cl_create_qry() RETURNING g_rbg[l_ac2].rbg09
                CALL t403_rbg09('d')
                NEXT FIELD rbg09
             OTHERWISE EXIT CASE
           END CASE
   END DIALOG

   CALL t403_upd_log()    
   CLOSE t403_bcl
   CLOSE t4031_bcl
   COMMIT WORK

   CALL t403_b1_fill(g_wc1)          #單身1
   CALL t403_b2_fill(g_wc2)          #單身2
   CALL t403_b3_fill(g_wc2)

END FUNCTION 

FUNCTION t403_b3_init()

   LET g_rbk[l_ac3].rbk09 = g_today        #ä?·éå?¥æ
   LET g_rbk[l_ac3].rbk11 = '00:00:00'     #ä?·éå????
   LET g_rbk[l_ac3].rbk10 = g_today        #ä?·ç??¥æ
   LET g_rbk[l_ac3].rbk12 = '23:59:59'     #ä?·ç?????
   LET g_rbk[l_ac3].rbkacti = 'Y'

   LET g_rbk[l_ac3].type2    ='0'
   LET g_rbk[l_ac3].before2  =' '
   LET g_rbk[l_ac3].after2   ='1'
   CALL t403_set_entry_rbk()
END FUNCTION

FUNCTION t403_b3_find()

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
         WHERE rak01 = g_rbe.rbe01 AND rak02 = g_rbe.rbe02
           AND rak03 = '2' 
           AND rak05 = g_rbk[l_ac3].rbk08 AND rakplant = g_rbe.rbeplant

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
   CALL t403_set_entry_rbk()

END FUNCTION


FUNCTION t403_set_entry_rbk()

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

FUNCTION t403_b3_fill(p_wc)
DEFINE p_wc            STRING
DEFINE l_sql           STRING

   LET g_sql = " SELECT '',a.rbk06,a.rbk08,a.rbk09,a.rbk10,a.rbk11,a.rbk12,a.rbk13,a.rbk14,a.rbkacti, ",
               "           b.rbk06,b.rbk08,b.rbk09,b.rbk10,b.rbk11,b.rbk12,b.rbk13,b.rbk14,b.rbkacti  ",
               " FROM rbk_file b LEFT OUTER JOIN rbk_file a ",
               "          ON (b.rbk01=a.rbk01 AND b.rbk02=a.rbk02 AND b.rbk03=a.rbk03 AND b.rbk04=a.rbk04 ",
               "              AND b.rbk07=a.rbk07 AND b.rbk08=a.rbk08 AND b.rbkplant=a.rbkplant AND b.rbk06<>a.rbk06 )",
               "   WHERE b.rbk01 = '",g_rbe.rbe01 CLIPPED ,"'  AND b.rbk02 = '",g_rbe.rbe02 CLIPPED ,"' ",
               "     AND b.rbk03 = '",g_rbe.rbe03 CLIPPED ,"' AND b.rbkplant='",g_rbe.rbeplant CLIPPED ,"' ",
               "     AND b.rbk06='1' AND b.rbk05 = '2'"
   IF NOT cl_null(p_wc) THEN
      LET l_sql = l_sql ," AND ", p_wc
   END IF

   PREPARE t403_b3_prepare FROM g_sql                     #預備一下
   DECLARE rbk_cs CURSOR FOR t403_b3_prepare
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
FUNCTION t403_rbp()
DEFINE l_sql             STRING
DEFINE l_rap             RECORD LIKE rap_file.*
DEFINE l_rbp05           LIKE rbp_file.rbp05
DEFINE l_n               LIKE type_file.num5

   IF g_rbe.rbe12t = g_rbe.rbe12 THEN RETURN END IF
   IF g_rbe.rbe12 = '0' THEN RETURN END IF
   SELECT COUNT(*) INTO l_n FROM rbp_file
      WHERE rbp01 = g_rbe.rbe01 AND rbp02 = g_rbe.rbe02
        AND rbp03 = g_rbe.rbe03 AND rbp04 = '2'
        AND rbp06 = '1' AND rbp12 = g_rbe.rbe12
        AND rbpacti = 'N'
   IF l_n > 0 THEN
      RETURN
   END IF

   SELECT MAX(rbp05) INTO l_rbp05 FROM rbp_file
     WHERE rbp01 = g_rbe.rbe01 AND rbp02 = g_rbe.rbe02
       AND rbp03 = g_rbe.rbe03 AND rbp04 = '2'
       AND rbp09 = g_rbe.rbe12t
   IF l_rbp05 = 0 OR cl_null(l_rbp05) THEN
      LET l_rbp05 = 1
   END IF
   LET l_sql = " SELECT * FROM rap_file ",
               " WHERE rap01 = '",g_rbe.rbe01,"' AND rap02 = '",g_rbe.rbe02,"'",
               " AND rap03 = '2' ",
               " AND rap09 = '",g_rbe.rbe12, "'",
               " AND rapplant = '",g_rbe.rbeplant, "'"
   PREPARE t403_sel_rbp FROM l_sql
   DECLARE t403sub_sel_rbp_cs CURSOR FOR t403_sel_rbp
   FOREACH t403sub_sel_rbp_cs INTO l_rap.*
      LET l_rap.rapacti = 'N'

      IF cl_null(l_rap.rap07) THEN LET l_rap.rap07 = 100 END IF
      LET l_sql = "INSERT INTO rbp_file (rbp01,rbp02,rbp03,rbp04,rbp05,rbp06, ",
                  "                      rbp07,rbp08,rbp09,rbp10,rbp11,rbp12, ",
                  "                      rbpacti,rbplegal,rbpplant )",
                  " VALUES ('",g_rbe.rbe01,"','",g_rbe.rbe02,"',",g_rbe.rbe03,",",
                  "         '2',",l_rbp05,",'1',",l_rap.rap04,",'",l_rap.rap05,"',",
                  "          ",l_rap.rap06,",",l_rap.rap07,",",l_rap.rap08,",'",l_rap.rap09,"',",
                  "          '",l_rap.rapacti,"','",g_rbe.rbelegal,"','",g_rbe.rbeplant,"')"


      PREPARE trans_ins_rap1 FROM l_sql
      EXECUTE trans_ins_rap1
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","rap_file",g_rbe.rbe02,"",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
         RETURN
      END IF
   END FOREACH
END FUNCTION

FUNCTION t403_delrbp()
DEFINE l_sql         STRING
DEFINE l_n           LIKE type_file.num5

   IF g_rbe.rbe12t  = g_rbe.rbe12 THEN
      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM rbp_file
         WHERE rbp01 = g_rbe.rbe01 AND rbp02 = g_rbe.rbe02
           AND rbp03 = g_rbe.rbe03 AND rbp04 = '2'
           AND rbp06 = '1' AND rbp12 = g_rbe.rbe12 
           AND rbpacti = 'N'
      IF l_n > 0 THEN
         DELETE FROM rbp_file
            WHERE rbp01 = g_rbe.rbe01 AND rbp02 = g_rbe.rbe02
              AND rbp03 = g_rbe.rbe03 AND rbp04 = '2'
              AND rbp06 = '1' AND rbp12 = g_rbe.rbe12
              AND rbpacti = 'N'
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","rap_file",g_rbe.rbe02,"",SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
   END IF
   IF g_rbe.rbe12t <> g_rbe_o.rbe12t THEN
      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM rbp_file
         WHERE rbp01 = g_rbe.rbe01 AND rbp02 = g_rbe.rbe02
           AND rbp03 = g_rbe.rbe03 AND rbp04 = '2'
           AND rbp06 = '1' AND rbp12 = g_rbe_o.rbe12t
           AND rbpacti = 'Y'  #TQC-C20378 add 
      IF l_n > 0 THEN
         DELETE FROM rbp_file
            WHERE rbp01 = g_rbe.rbe01 AND rbp02 = g_rbe.rbe02
              AND rbp03 = g_rbe.rbe03 AND rbp04 = '2'
              AND rbp06 = '1' AND rbp12 = g_rbe_o.rbe12t
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","rap_file",g_rbe.rbe02,"",SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
   END IF

END FUNCTION
#FUN-BC0078 add END
#FUN-C60041 ---------------------STA
FUNCTION t403_create_temp_table()
   CALL t403_temptable("1")
   DROP TABLE rbe_temp
   SELECT * FROM rbe_file WHERE 1 = 0 INTO TEMP rbe_temp
   DROP TABLE rbf_temp
   SELECT * FROM rbf_file WHERE 1 = 0 INTO TEMP rbf_temp
   DROP TABLE rbg_temp
   SELECT * FROM rbg_file WHERE 1 = 0 INTO TEMP rbg_temp
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

   DROP TABLE rae_temp
   SELECT * FROM rae_file WHERE 1 = 0 INTO TEMP rae_temp
   DROP TABLE raf_temp
   SELECT * FROM raf_file WHERE 1 = 0 INTO TEMP raf_temp
   DROP TABLE rag_temp
   SELECT * FROM rag_file WHERE 1 = 0 INTO TEMP rag_temp
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
FUNCTION t403_drop_temp_table()
   DROP TABLE rbe_temp
   DROP TABLE rbf_temp
   DROP TABLE rbg_temp
   DROP TABLE rbp_temp
   DROP TABLE rbq_temp
   DROP TABLE rbr_temp
   DROP TABLE rbs_temp
   DROP TABLE rbk_temp 

   DROP TABLE rae_temp
   DROP TABLE raf_temp
   DROP TABLE rag_temp
   DROP TABLE rap_temp
   DROP TABLE raq_temp
   DROP TABLE rar_temp
   DROP TABLE ras_temp
   DROP TABLE rak_temp    
   CALL t403_temptable("2")
END FUNCTION
#FUN-C60041 ---------------------END

#yemy 20130517  --Begin
FUNCTION t403_set_rbk11_format(ps_field)
   DEFINE   ps_field     STRING
   DEFINE   lwin_curr    ui.Window
   DEFINE   lfrm_curr    ui.Form
   DEFINE   lnode_item   om.DomNode
   DEFINE   lnode_child  om.DomNode
   DEFINE   ls_picture   STRING              # 單據編號格式設定
   DEFINE   li_i         LIKE type_file.num10             #No.FUN-690005  INTEGER
   DEFINE   ls_tabname   STRING              #No.FUN-720042
 
 
   LET lwin_curr = ui.Window.getCurrent()
   LET lfrm_curr = lwin_curr.getForm()
   IF lfrm_curr IS NULL THEN
      RETURN
   END IF
 
   LET ls_tabname = cl_get_table_name(ps_field)    #No.FUN-720042
   LET lnode_item = lfrm_curr.findNode("FormField",ls_tabname||"."||ps_field)  #No.FUN-720042
   IF lnode_item IS NULL THEN
      LET lnode_item = lfrm_curr.findNode("TableColumn",ls_tabname||"."||ps_field)   #No.FUN-720042
      IF lnode_item IS NULL THEN
         LET lnode_item = lfrm_curr.findNode("Matrix",ls_tabname||"."||ps_field) #FUN-A70010
         IF lnode_item IS NULL THEN
            RETURN
         END IF
      END IF
   END IF
 
   LET lnode_child = lnode_item.getFirstChild()

   LET ls_picture = "XX:XX:XX"
 
   CALL lnode_child.setAttribute("picture",ls_picture)
END FUNCTION
#yemy 20130517  --End  
