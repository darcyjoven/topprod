# Prog. Version..: '5.30.06-13.04.22(00010)'     #
# Pattern name...: almi400.4gl
# Descriptions...: 合同维护作业
# Date & Author..: No:FUN-BA0118 2011/10/26 By yangxf 
# Modify.........: No:FUN-C20078 2012/02/17 By yangxf 添加控管:费用方案为比例类型时定义帐期必须大于0,帐期对应帐单实际应收等于零时不可提前出帐
# Modify.........: No:TQC-C20525 2012/02/29 By fanbj 日期區間判斷修改
# Modify.........: No:TQC-C30106 2012/03/06 By yangxf 更改時，如果攤位沒有變化不要自動更新合同費用方案lnt71
# Modify.........: No:MOD-C30450 12/03/13 By shiwuying 定义帐期提示
# Modify.........: No:TQC-C30290 12/03/28 By fanbj alm1206報錯不准確
# Modify.........: No:TQC-C30320 12/03/29 By fanbj 點幫助按鈕沒反應
# Modify.........: No:FUN-C50036 12/05/22 By fanbj 增加pos邏輯
# Modify.........: No:FUN-C60062 12/06/25 By fanbj 增加接收參數
# Modify.........: No.FUN-C80006 12/08/02 By xumeimei 優惠金額調整，正的金額表示優惠
# Modify.........: No.MOD-C80167 12/08/28 By pauline 單頭隱藏時,點選新增時程式會當掉,無法正常作業
# Modify.........: No.CHI-C80041 12/12/26 By bart 排除作廢
# Modify.........: No.FUN-CA0081 13/01/09 By baogc 邏輯調整
# Modify.........: No.CHI-C80041 01/13/21 By bart 排除作廢
# Modify.........: No.CHI-D20015 13/03/26 By fengrui 統一確認和取消確認時確認人員和確認日期的寫法
# Modify.........: No.FUN-D30033 13/04/12 By minpp 單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
GLOBALS "../../config/top.global"

DEFINE g_lnt     RECORD LIKE lnt_file.*                 #合同单头基本资料
DEFINE g_lne     RECORD LIKE lne_file.*                 #合同单头商户资料
DEFINE g_lnt_t   RECORD LIKE lnt_file.*                 #合同单头基本资料备份 
DEFINE g_lne_t   RECORD LIKE lne_file.*                 #合同单头商户资料备份
DEFINE g_lnv     DYNAMIC ARRAY OF RECORD                #合同费用标准
                 lnv03      LIKE lnv_file.lnv03,        #项次
                 lnv04      LIKE lnv_file.lnv04,        #费用编号
                 oaj02      LIKE oaj_file.oaj02,        #费用名称     
                 oaj05      LIKE oaj_file.oaj05,        #发票别
                 lnv18      LIKE lnv_file.lnv18,        #费用方案
                 lnv181     LIKE lnv_file.lnv181,       #费用方案版本号
                 lnv16      LIKE lnv_file.lnv16,        #开始日期
                 lnv17      LIKE lnv_file.lnv17,        #结束日期
                 lnv07      LIKE lnv_file.lnv07,        #费用标准 
                 lnv02      LIKE lnv_file.lnv02         #合同版本
                 END RECORD,
       g_lnv_t   RECORD                               
                 lnv03      LIKE lnv_file.lnv03,        
                 lnv04      LIKE lnv_file.lnv04,
                 oaj02      LIKE oaj_file.oaj02,            
                 oaj05      LIKE oaj_file.oaj05,     
                 lnv18      LIKE lnv_file.lnv18,
                 lnv181     LIKE lnv_file.lnv181,
                 lnv16      LIKE lnv_file.lnv16,
                 lnv17      LIKE lnv_file.lnv17,
                 lnv07      LIKE lnv_file.lnv07,
                 lnv02      LIKE lnv_file.lnv02
                 END RECORD,
       g_lit     DYNAMIC ARRAY OF RECORD                #合同费用优惠标准
                 lit03      LIKE lit_file.lit03,        #项次
                 lit04      LIKE lit_file.lit04,        #费用编号
                 oaj02_1    LIKE oaj_file.oaj02,        #费用名称
                 oaj05_1    LIKE oaj_file.oaj05,        #费用性质
                 lit05      LIKE lit_file.lit05,        #优惠单号
                 lit06      LIKE lit_file.lit06,        #优惠金额
                 lit07      LIKE lit_file.lit07,        #优惠开始日期
                 lit08      LIKE lit_file.lit08,        #优惠结束日期
                 lit02      LIKE lit_file.lit02         #合同版本 
                 END RECORD,
       g_lit_t   RECORD                                
                 lit03      LIKE lit_file.lit03,    
                 lit04      LIKE lit_file.lit04,   
                 oaj02_1    LIKE oaj_file.oaj02,  
                 oaj05_1    LIKE oaj_file.oaj05, 
                 lit05      LIKE lit_file.lit05,
                 lit06      LIKE lit_file.lit06,
                 lit07      LIKE lit_file.lit07,
                 lit08      LIKE lit_file.lit08,
                 lit02      LIKE lit_file.lit02 
                 END RECORD,
       g_lnw     DYNAMIC ARRAY OF RECORD                #合同其他费用
                 lnw11      LIKE lnw_file.lnw11,        #项次
                 lnw03      LIKE lnw_file.lnw03,        #费用编码
                 oaj02_2    LIKE oaj_file.oaj02,        #费用名称
                 oaj05_2    LIKE oaj_file.oaj05,        #合同性质
                 lnw08      LIKE lnw_file.lnw08,        #开始日期
                 lnw09      LIKE lnw_file.lnw09,        #结束日期
                 lnw06      LIKE lnw_file.lnw06,        #费用金额 
                 lnw02      LIKE lnw_file.lnw02         #合同版本                 
                 END RECORD,
       g_lnw_t   RECORD                                 #合同其他费用备份
                 lnw11      LIKE lnw_file.lnw11,
                 lnw03      LIKE lnw_file.lnw03,
                 oaj02_2    LIKE oaj_file.oaj02,
                 oaj05_2    LIKE oaj_file.oaj05,
                 lnw08      LIKE lnw_file.lnw08,
                 lnw09      LIKE lnw_file.lnw09,
                 lnw06      LIKE lnw_file.lnw06,
                 lnw02      LIKE lnw_file.lnw02 
                 END RECORD,
       g_liu DYNAMIC ARRAY OF RECORD                     #合同账期定义付款
                 liu03      LIKE liu_file.liu03,         #项次
                 liu04      LIKE liu_file.liu04,         #费用编码
                 oaj02_3    LIKE oaj_file.oaj02,         #费用名称
                 oaj05_3    LIKE oaj_file.oaj05,         #费用性质  
                 liu05      LIKE liu_file.liu05,         #付款方式
                 lnr02      LIKE lnr_file.lnr02,         #付款周期名称
                 liu06      LIKE liu_file.liu06,         #付款周期
                 liu07      LIKE liu_file.liu07,         #出账期
                 liu08      LIKE liu_file.liu08          #出账日
                 END RECORD,
       g_liu_t  RECORD                                   #合同账期定义付款备份
                 liu03      LIKE liu_file.liu03,
                 liu04      LIKE liu_file.liu04,
                 oaj02_3    LIKE oaj_file.oaj02,
                 oaj05_3    LIKE oaj_file.oaj05,
                 liu05      LIKE liu_file.liu05,
                 lnr02      LIKE lnr_file.lnr02,
                 liu06      LIKE liu_file.liu06,
                 liu07      LIKE liu_file.liu07,
                 liu08      LIKE liu_file.liu08 
                 END RECORD,
       g_lnu     DYNAMIC ARRAY OF RECORD                 #合同场地
                  lnu06      LIKE  lnu_file.lnu06,       #项次
                  lnu03      LIKE  lnu_file.lnu03,       #场地编号
                  lnu05      LIKE  lnu_file.lnu05,       #建筑面积 
                  lnu07      LIKE  lnu_file.lnu07,       #测量面积
                  lnu04      LIKE  lnu_file.lnu04,       #经营面积 
                  lnu08      LIKE  lnu_file.lnu08,       #楼栋编号
                  lmb03_1    LIKE  lmb_file.lmb03,       #楼栋名称
                  lnu09      LIKE  lnu_file.lnu09,       #楼层编号
                  lmc04_1    LIKE  lmc_file.lmc04,       #楼层名称
                  lnu10      LIKE  lnu_file.lnu10,       #区域编号
                  lmy04_1    LIKE  lmy_file.lmy04,       #区域名称
                  lnu02      LIKE  lnu_file.lnu02        #合同版本     
                 END RECORD,    
       g_lnu_t   RECORD                                  #合同场地备份 
                  lnu06      LIKE  lnu_file.lnu06, 
                  lnu03      LIKE  lnu_file.lnu03, 
                  lnu05      LIKE  lnu_file.lnu05, 
                  lnu07      LIKE  lnu_file.lnu07,
                  lnu04      LIKE  lnu_file.lnu04,
                  lmb03_1    LIKE  lmb_file.lmb03,
                  lnu09      LIKE  lnu_file.lnu09,
                  lmc04_1    LIKE  lmc_file.lmc04,
                  lnu10      LIKE  lnu_file.lnu10,
                  lmy04_1    LIKE  lmy_file.lmy04,
                  lnu02      LIKE  lnu_file.lnu02 
                 END RECORD, 
       g_lny     DYNAMIC ARRAY OF RECORD                 #合同其他品牌 
                  lny04      LIKE lny_file.lny04,        #项次
                  lny03      LIKE lny_file.lny03,        #品牌编号
                  tqa02_2    LIKE tqa_file.tqa02,        #品牌名称
                  lny02      LIKE lny_file.lny02         #合同版本
                 END RECORD,  
       g_lny_t   RECORD                                  #合同其他品牌备份 
                  lny04      LIKE lny_file.lny04,
                  lny03      LIKE lny_file.lny03,
                  tqa02_2    LIKE tqa_file.tqa02,
                  lny02      LIKE lny_file.lny02
                 END RECORD, 
       g_liw     DYNAMIC ARRAY OF RECORD                 #合同账单
                     liw03       LIKE liw_file.liw03,
                     liw04       LIKE liw_file.liw04,
                     oaj02       LIKE oaj_file.oaj02,
                     liw05_desc  LIKE type_file.chr100,
                     liw06       LIKE liw_file.liw06,
                     liw07       LIKE liw_file.liw07,
                     liw08       LIKE liw_file.liw08,
                     liw09       LIKE liw_file.liw09,
                     liw10       LIKE liw_file.liw10,
                     liw11       LIKE liw_file.liw11,
                     liw12       LIKE liw_file.liw12,
                     liw13       LIKE liw_file.liw13,
                     liw14       LIKE liw_file.liw14,
                     liw14_desc  LIKE liw_file.liw14,
                     liw15       LIKE liw_file.liw15,
                     liw16       LIKE liw_file.liw16,
                     liw18       LIKE liw_file.liw18,
                     liw17       LIKE liw_file.liw17,
                     liw02       LIKE liw_file.liw02
                 END RECORD,
       g_liv     DYNAMIC ARRAY OF RECORD                   #合同日核算
                     liv03       LIKE liv_file.liv03,
                     liv04       LIKE liv_file.liv04,
                     liv05       LIKE liv_file.liv05,
                     oaj02       LIKE oaj_file.oaj02,
                     liv06       LIKE liv_file.liv06,
                     liv07       LIKE liv_file.liv07,
                     liv071      LIKE liv_file.liv071,
                     liv08       LIKE liv_file.liv08,
                     liv09       LIKE liv_file.liv09, 
                     liv02       LIKE liv_file.liv02
                 END RECORD,
       g_liv_t   RECORD                   #合同日核算
                     liv03       LIKE liv_file.liv03,
                     liv04       LIKE liv_file.liv04,
                     liv05       LIKE liv_file.liv05,
                     oaj02       LIKE oaj_file.oaj02,
                     liv06       LIKE liv_file.liv06,
                     liv07       LIKE liv_file.liv07,
                     liv071      LIKE liv_file.liv071,
                     liv08       LIKE liv_file.liv08,
                     liv09       LIKE liv_file.liv09,
                     liv02       LIKE liv_file.liv02
                 END RECORD,
       g_liw1    DYNAMIC ARRAY OF RECORD                   #提前出账
                    chk          LIKE type_file.chr1,
                    liw05_desc   LIKE type_file.chr100,
                    liw06        LIKE liw_file.liw06 
                 END RECORD 
DEFINE l_ac,l_ac2,l_ac3,l_ac4,l_ac5             LIKE type_file.num5
DEFINE l_ac6,l_ac7,l_ac8,l_ac9,l_ac10           LIKE type_file.num5
DEFINE l_ac11                                   LIKE type_file.num5
DEFINE g_cnt                                    LIKE type_file.num5
DEFINE g_wc,g_wc2,g_wc3,g_wc4,g_wc5,g_wc6,g_wc7 LIKE type_file.chr500
DEFINE g_rec_b                                  LIKE type_file.num5
DEFINE g_no_ask                                 LIKE type_file.num5
DEFINE g_sql,g_msg                              STRING
DEFINE g_curs_index,g_row_count,g_jump          LIKE type_file.num5
DEFINE g_forupd_sql                             STRING
DEFINE g_rec_b2,g_rec_b3,g_rec_b4,g_rec_b10     LIKE type_file.num5,
       g_rec_b5,g_rec_b6,g_rec_b8,g_rec_b9      LIKE type_file.num5
DEFINE g_before_input_done                      LIKE type_file.num5       
DEFINE g_rtz13      LIKE rtz_file.rtz13,    #门店编号名称
       g_azt02      LIKE azt_file.azt02,    #法人名称
       g_lne05      LIKE lne_file.lne05,    #商户编号名称
       g_tqa02      LIKE tqa_file.tqa02,    #摊位用途名称
       g_lmb03      LIKE lmb_file.lmb03,    #楼栋名称
       g_lmc04      LIKE lmc_file.lmc04,    #楼层名称
       g_lmy04      LIKE lmy_file.lmy04,    #区域编号名称
       g_gen02      LIKE gen_file.gen02,    #业务人员名称
       g_gem02      LIKE gem_file.gem02,    #部门名称
       g_gen02_1    LIKE gen_file.gen02,     
       g_gen02_2    LIKE gen_file.gen02 
DEFINE g_flag_b     LIKE type_file.chr1       
DEFINE g_flag       LIKE type_file.chr1
DEFINE g_azp01_cnt  LIKE type_file.num5
DEFINE g_azp01      DYNAMIC ARRAY OF LIKE azp_file.azp01 
DEFINE g_tenant_tot LIKE type_file.num10
DEFINE g_t1         LIKE oay_file.oayslip
DEFINE g_close      LIKE type_file.chr1
DEFINE g_lla01      LIKE lla_file.lla01
DEFINE g_lla03      LIKE lla_file.lla03
DEFINE g_lla04      LIKE lla_file.lla04
DEFINE g_argv1      LIKE lnt_file.lnt01      #FUN-C60062 add

MAIN

   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
   
   LET g_argv1=ARG_VAL(1)                    #FUN-C60062 add
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   WHENEVER ERROR CALL cl_err_msg_log
   IF (NOT cl_setup("ALM")) THEN  
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   LET g_forupd_sql = "SELECT * FROM lnt_file WHERE lnt01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

   DECLARE i400_cl CURSOR FROM g_forupd_sql
   OPEN WINDOW i400_w WITH FORM "alm/42f/almi400"         
                      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()

   #FUN-C60062--start add---------------------------------------
   IF NOT cl_null(g_argv1) THEN
      CALL i400_q()
   END IF
   #FUN-C60062--end add-----------------------------------------

    #初始化查询条件
    LET g_wc ="1=1"
    LET g_wc2="1=1"
    LET g_wc3="1=1"
    LET g_wc4="1=1"
    LET g_wc5="1=1"
    LET g_wc6="1=1"
    LET g_wc7="1=1"
    IF g_aza.aza88 = 'Y' THEN
       CALL cl_set_comp_visible("lntpos",TRUE)
    ELSE
       CALL cl_set_comp_visible("lntpos",FALSE)
    END IF
    SELECT lla01,lla03,lla04 INTO g_lla01,g_lla03,g_lla04 FROM lla_file
     WHERE llastore = g_plant

    CALL i400_menu()
    CLOSE WINDOW i400_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION i400_menu()
    WHILE TRUE
        CALL i400_bp()
        CASE g_action_choice
           WHEN "insert"
              IF cl_chk_act_auth() THEN
                 CALL i400_a()
              END IF
           
           WHEN "detail"
              IF cl_chk_act_auth() THEN
                 CASE g_flag_b
                      WHEN '3' CALL i400_b3()
                      WHEN '4' CALL i400_b4()
                      WHEN '6' CALL i400_b6()
                 END CASE      
              END IF
              
           WHEN "modify"
              IF cl_chk_act_auth() THEN
                 CALL i400_u()
              END IF
              
           WHEN "delete"
              IF cl_chk_act_auth() THEN
                 CALL i400_r()
              END IF
              
           WHEN "query"
              IF cl_chk_act_auth() THEN
                 CALL i400_q()
              END IF
              
           WHEN "controlg"
              IF cl_chk_act_auth() THEN
                 CALL cl_cmdask()
              END IF
              
           WHEN "EXIT"
              IF cl_chk_act_auth() THEN
                 EXIT WHILE
              END IF
           
           WHEN "invalid"
              IF cl_chk_act_auth() THEN
                 CALL i400_x()
              END IF

           #执行标准
           WHEN "re_get_fs"
              IF cl_chk_act_auth() THEN
                 CALL i400_standards()
                 CALL i400_upd()
                 CALL i400_b_fill()
              END IF 

           #执行优惠
           WHEN "preferential" 
              IF cl_chk_act_auth() THEN
                CALL i400_ins_lit()             #抓取优惠信息并产生优惠信息的日核算
              END IF

           #其他费用
           WHEN "other_fare_standard"
              IF cl_chk_act_auth() THEN
                 CALL i400_ins_lnw()
              END IF

           #定义付款
           WHEN "define_period_payment"
              IF cl_chk_act_auth() THEN
                 CALL i400_ins_liu()             #可抓取标准、优惠、其他费用的费用编号到定义付款中
              END IF
        
           #签订合同-生成账单
           WHEN "gen_bill"
              IF cl_chk_act_auth() THEN
                 IF NOT cl_null(g_lnt.lnt01) THEN
                    CALL i400sub_generate_bill(g_lnt.lnt01,'1')
                    CALL i400_upd()
                 ELSE
                    CALL cl_err('',-400,1)
                 END IF                 
              END IF
           
           #签订合同-初审拒绝
           WHEN "first_deny"
              IF cl_chk_act_auth() THEN
                 CALL i400_deny1()
              END IF
           #签订合同-初审通过
           WHEN "first_confirm"
              IF cl_chk_act_auth() THEN
                 CALL i400_y1()
              END IF
           #签订合同-取消初审
           WHEN "undo_confirm"
              IF cl_chk_act_auth() THEN
                 CALL i400_unconfirm()
              END IF
           #签订合同-终审拒绝
           WHEN "final_deny"
              IF cl_chk_act_auth() THEN
                 CALL i400_deny2()
              END IF
           #签订合同-终审通过
           WHEN "final_confirm"
              IF cl_chk_act_auth() THEN
                 CALL i400_y()
              END IF
           #签订合同--取消终审
           WHEN "undo_confirm_1"
              IF cl_chk_act_auth() THEN
                 CALL i400_unconfirm_1()
              END IF
           #查询账单
           WHEN "qry_fare"
              IF cl_chk_act_auth() THEN
                 IF NOT cl_null(g_lnt.lnt01) THEN
                    CALL i400_qry_fare()                  
                 END IF
              END IF
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_lnt.lnt01 IS NOT NULL THEN
                    LET g_doc.column1 = "lnt01"
                    LET g_doc.value1 = g_lnt.lnt01
                    CALL cl_doc()
                 END IF
              END IF

        #TQC-C30320--start add---------------------
        WHEN "help"
           CALL cl_show_help()
        #TQC-C30320--end add----------------------- 

        END CASE
    
    END WHILE
END FUNCTION

FUNCTION i400_bp()
     LET g_action_choice=NULL
     CALL cl_set_act_visible("accept,cancel", FALSE)
     DIALOG ATTRIBUTES(UNBUFFERED)
     
         DISPLAY ARRAY g_lnv TO s_lnv.* ATTRIBUTE(COUNT=g_rec_b)
            
             BEFORE DISPLAY
                DISPLAY g_rec_b TO FORMONLY.cn2
                CALL cl_navigator_setting( g_curs_index, g_row_count )
                BEFORE ROW
                   LET l_ac = ARR_CURR()
                   CALL cl_show_fld_cont()
         END DISPLAY
         
         DISPLAY ARRAY g_lit TO s_lit.* ATTRIBUTE(COUNT=g_rec_b2)
             BEFORE DISPLAY  
                DISPLAY g_rec_b2 TO FORMONLY.cn2
                CALL cl_navigator_setting( g_curs_index, g_row_count )
                BEFORE ROW 
                   LET l_ac2 = ARR_CURR()
                   CALL cl_show_fld_cont() 
                
         END DISPLAY
         
         DISPLAY ARRAY g_lnw TO s_lnw.* ATTRIBUTE(COUNT=g_rec_b3)
             BEFORE DISPLAY 
                DISPLAY g_rec_b3 TO FORMONLY.cn2
                CALL cl_navigator_setting( g_curs_index, g_row_count )
                BEFORE ROW 
                   LET l_ac3 = ARR_CURR()
                   CALL cl_show_fld_cont()

            ON ACTION detail
               LET g_action_choice = "detail"
               LET g_flag_b = '3'
               LET l_ac3 = 1
               EXIT DIALOG

            ON ACTION ACCEPT
               LET g_action_choice="detail"
               LET g_flag_b = '3'
               LET l_ac3 = ARR_CURR()
               EXIT DIALOG                   
                   
         END DISPLAY
         
         DISPLAY ARRAY g_liu TO s_liu.* ATTRIBUTE(COUNT = g_rec_b4)
         
             BEFORE DISPLAY 
                DISPLAY g_rec_b4 TO FORMONLY.cn2
                CALL cl_navigator_setting( g_curs_index, g_row_count )
                BEFORE ROW 
                   LET l_ac4 = ARR_CURR()
                   CALL cl_show_fld_cont() 

            ON ACTION detail
               LET g_action_choice = "detail"
               LET g_flag_b = '4'
               LET l_ac4 = 1
               EXIT DIALOG

            ON ACTION ACCEPT
               LET g_action_choice="detail"
               LET g_flag_b = '4'
               LET l_ac4 = ARR_CURR()
               EXIT DIALOG                      
                
         END DISPLAY

         DISPLAY ARRAY g_lnu TO s_lnu.* ATTRIBUTE(COUNT = g_rec_b5)
         
             BEFORE DISPLAY 
                DISPLAY g_rec_b5 TO FORMONLY.cn2
                CALL cl_navigator_setting( g_curs_index, g_row_count )
                BEFORE ROW 
                   LET l_ac5 = ARR_CURR()
                   CALL cl_show_fld_cont() 
                 
                
         END DISPLAY

         DISPLAY ARRAY g_lny TO s_lny.* ATTRIBUTE(COUNT = g_rec_b6)
         
             BEFORE DISPLAY 
                DISPLAY g_rec_b6 TO FORMONLY.cn2
                CALL cl_navigator_setting( g_curs_index, g_row_count )
                BEFORE ROW 
                   LET l_ac6 = ARR_CURR()
                   CALL cl_show_fld_cont() 

            ON ACTION detail
               LET g_action_choice = "detail"
               LET g_flag_b = '6'
               LET l_ac6 = 1
               EXIT DIALOG

            ON ACTION ACCEPT
               LET g_action_choice="detail"
               LET g_flag_b = '6'
               LET l_ac6 = ARR_CURR()
               EXIT DIALOG                      
                
        END DISPLAY
        ON ACTION controlg
           LET g_action_choice='controlg'
            EXIT DIALOG
         
         ON ACTION insert
            LET g_action_choice='insert'
            EXIT DIALOG
            
         ON ACTION modify
            LET g_action_choice='modify'
            EXIT DIALOG
            
#FUN-C20078 mark begin ----
#         ON ACTION detail
#            LET g_action_choice='detail'
#            EXIT DIALOG
#FUN-C20078 mark end ------

         ON ACTION query
            LET g_action_choice='query'
            EXIT DIALOG
            
         ON ACTION delete
            LET g_action_choice='delete'
            EXIT DIALOG

         ON ACTION invalid
            LET g_action_choice="invalid"
            EXIT DIALOG
 
         ON ACTION output
            LET g_action_choice='output'
            EXIT DIALOG

         ON ACTION first
            CALL i400_fetch('F')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            EXIT DIALOG
            
         ON ACTION next
            CALL i400_fetch('N')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            EXIT DIALOG
            
         ON ACTION previous
            CALL i400_fetch('P')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            EXIT DIALOG
            
         ON ACTION last
            CALL i400_fetch('L')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            EXIT DIALOG
         
         ON ACTION close
            LET g_action_choice="EXIT"
            EXIT DIALOG
         
         ON ACTION exit
            LET g_action_choice="EXIT"
            EXIT DIALOG
            
         ON ACTION controls              
            CALL cl_set_head_visible("","AUTO")
         
         ON ACTION help
            LET g_action_choice="help"
            EXIT DIALOG
         
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
         
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
 
         #执行标准
         ON ACTION re_get_fs
            LET g_action_choice="re_get_fs"
            EXIT DIALOG
         
         #执行优惠
         ON ACTION preferential
            LET g_action_choice="preferential"
            EXIT DIALOG
         
         #其他费用
         ON ACTION other_fare_standard
            LET g_action_choice="other_fare_standard"
            EXIT DIALOG
         
         #定义付款
         ON ACTION define_period_payment
            LET g_action_choice="define_period_payment"
            EXIT DIALOG
         
         #生成账单
         ON ACTION gen_bill
            LET g_action_choice="gen_bill"
            EXIT DIALOG
            
         #初审拒绝
         ON ACTION first_deny
            LET g_action_choice="first_deny"
            EXIT DIALOG
         
         #初审通过
         ON ACTION first_confirm
            LET g_action_choice="first_confirm"
            EXIT DIALOG
         
         #取消初审
         ON ACTION undo_confirm
            LET g_action_choice="undo_confirm"
            EXIT DIALOG

         #终审拒绝
         ON ACTION final_deny
            LET g_action_choice="final_deny"
            EXIT DIALOG
    
         #终审通过
         ON ACTION final_confirm
            LET g_action_choice="final_confirm"
            EXIT DIALOG
            
         #取消审核
         ON ACTION undo_confirm_1
            LET g_action_choice="undo_confirm_1"
            EXIT DIALOG

         #查询账单
         ON ACTION qry_fare
            LET g_action_choice="qry_fare"
            EXIT DIALOG
   
         ON ACTION related_document
            LET g_action_choice="related_document"
            EXIT DIALOG
 
         AFTER DIALOG
           CONTINUE DIALOG
            
      END DIALOG
      CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i400_cs()
DEFINE  l_table         LIKE    type_file.chr1000
DEFINE  l_where         LIKE    type_file.chr1000

     #FUN-C60062--start add-------------------------------------
     IF NOT cl_null(g_argv1) THEN
        LET g_wc = " lnt01 = '",g_argv1,"'"
        LET g_wc2 = " 1=1" 
        LET g_wc3 = " 1=1"
        LET g_wc4 = " 1=1"
        LET g_wc5 = " 1=1"
        LET g_wc6 = " 1=1"
        LET g_wc7 = " 1=1"  
     ELSE
     #FUN-C60062--end add---------------------------------------
        DIALOG ATTRIBUTE (UNBUFFERED)
             CONSTRUCT BY NAME g_wc ON   lntplant,lntlegal,lnt01,lnt02,lnt03,lnt04,
                                         lnt06,lnt55,lnt56,lnt16,lnt57,lnt45,lnt58,lnt54,
                                         lnt59,lnt08,lnt09,lnt60,lnt11,lnt61,lnt10,
                                         lnt17,lnt18,lnt51,lnt21,lnt22,lnt62,lnt63,
                                         lnt64,lnt65,lnt66,lnt67,lnt68,lnt69,lnt48,
                                         lnt26,lnt27,lnt28,lnt47,lnt46,lnt29,lntpos,
                                         lnt30,lnt31,lnt32,lnt33,lnt35,lnt36,lnt37,
                                         lnt70,lnt71,lnt72,lntuser,lntgrup,lntoriu, 
                                         lntmodu,lntdate,lntorig,lntacti,lntcrat
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()

                ON ACTION controlp
                   CASE          
                      #门店编号 
                      WHEN INFIELD(lntplant)
                           CALL cl_init_qry_var()
                           LET g_qryparam.state = 'c'
                           LET g_qryparam.form = "q_lntplant"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO lntplant
                           NEXT FIELD lntplant
                           
                      #法人
                      WHEN INFIELD(lntlegal)
                           CALL cl_init_qry_var()
                           LET g_qryparam.state = 'c'
                           LET g_qryparam.form = "q_lntlegal"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO lntlegal
                           NEXT FIELD lntlegal                        

                      #合同编号
                      WHEN INFIELD(lnt01)
                           CALL cl_init_qry_var()
                           LET g_qryparam.state = 'c'
                           LET g_qryparam.form = "q_lnt01"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO lnt01
                           NEXT FIELD lnt01 

                      #商户编号     
                      WHEN INFIELD(lnt04)
                           CALL cl_init_qry_var()
                           LET g_qryparam.state = 'c'
                           LET g_qryparam.form = "q_lnt04"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO lnt04
                           NEXT FIELD lnt04 

                      #摊位编号    
                      WHEN INFIELD(lnt06)
                           CALL cl_init_qry_var()
                           LET g_qryparam.state = 'c'
                           LET g_qryparam.form = "q_lnt06"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO lnt06
                           NEXT FIELD lnt06 

                      #摊位用途
                      WHEN INFIELD(lnt55)
                           CALL cl_init_qry_var()
                           LET g_qryparam.state = 'c'
                           LET g_qryparam.form = "q_lnt55"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO lnt55
                           NEXT FIELD lnt55 

                      #楼栋编号      
                      WHEN INFIELD(lnt08)
                           CALL cl_init_qry_var()
                           LET g_qryparam.state = 'c'
                           LET g_qryparam.form = "q_lnt08"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO lnt08
                           NEXT FIELD lnt08 

                      #楼层编号      
                      WHEN INFIELD(lnt09)
                           CALL cl_init_qry_var()
                           LET g_qryparam.state = 'c'
                           LET g_qryparam.form = "q_lnt09"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO lnt09
                           NEXT FIELD lnt09 

                      #区域编号     
                      WHEN INFIELD(lnt60)
                           CALL cl_init_qry_var()
                           LET g_qryparam.state = 'c'
                           LET g_qryparam.form = "q_lnt60"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO lnt60
                           NEXT FIELD lnt60 

                      #业务人员     
                      WHEN INFIELD(lnt62)
                           CALL cl_init_qry_var()
                           LET g_qryparam.state = 'c'
                           LET g_qryparam.form = "q_lnt62"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO lnt62
                           NEXT FIELD lnt62 

                      #部门     
                      WHEN INFIELD(lnt63)
                           CALL cl_init_qry_var()
                           LET g_qryparam.state = 'c'
                           LET g_qryparam.form = "q_lnt63"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO lnt63
                           NEXT FIELD lnt63 

                      #初审人     
                      WHEN INFIELD(lnt27)
                           CALL cl_init_qry_var()
                           LET g_qryparam.state = 'c'
                           LET g_qryparam.form = "q_lnt27"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO lnt27
                           NEXT FIELD lnt27 

                      #终审人     
                      WHEN INFIELD(lnt47)
                           CALL cl_init_qry_var()
                           LET g_qryparam.state = 'c'
                           LET g_qryparam.form = "q_lnt47"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO lnt47
                           NEXT FIELD lnt47

                      #主品牌     
                      WHEN INFIELD(lnt30)
                           CALL cl_init_qry_var()
                           LET g_qryparam.state = 'c'
                           LET g_qryparam.form = "q_lnt30_2"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO lnt30
                           NEXT FIELD lnt30

                      #经营大类     
                      WHEN INFIELD(lnt31)
                           CALL cl_init_qry_var()
                           LET g_qryparam.state = 'c'
                           LET g_qryparam.form = "q_lnt31"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO lnt31
                           NEXT FIELD lnt31

                      #经营中类     
                      WHEN INFIELD(lnt32)
                           CALL cl_init_qry_var()
                           LET g_qryparam.state = 'c'
                           LET g_qryparam.form = "q_lnt32_1"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO lnt32
                           NEXT FIELD lnt32

                      #经营小类     
                      WHEN INFIELD(lnt33)
                           CALL cl_init_qry_var()
                           LET g_qryparam.state = 'c'
                           LET g_qryparam.form = "q_lnt33_1"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO lnt33
                           NEXT FIELD lnt33 

                      #税别     
                      WHEN INFIELD(lnt35)
                           CALL cl_init_qry_var()
                           LET g_qryparam.state = 'c'
                           LET g_qryparam.form = "q_lnt35"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO lnt35
                           NEXT FIELD lnt35

                      #预租协议     
                      WHEN INFIELD(lnt70)
                           CALL cl_init_qry_var()
                           LET g_qryparam.state = 'c'
                           LET g_qryparam.form = "q_lnt70"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO lnt70
                           NEXT FIELD lnt70   

                      WHEN INFIELD(lnt71)
                           CALL cl_init_qry_var()
                           LET g_qryparam.state = 'c'
                           LET g_qryparam.form = "q_lnt71"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO lnt71
                           NEXT FIELD lnt71 
                   END CASE           
 
             END CONSTRUCT
             
             CONSTRUCT g_wc2 ON lnv03,lnv04,lnv18,lnv181,lnv16,lnv17,
                                lnv07,lnv02
                                     FROM s_lnv[1].lnv03,s_lnv[1].lnv04,
                                          s_lnv[1].lnv18,s_lnv[1].lnv181,
                                          s_lnv[1].lnv16,s_lnv[1].lnv17,s_lnv[1].lnv07,
                                          s_lnv[1].lnv02
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
                 
               ON ACTION controlp
                   CASE          
                      #费用编号 
                      WHEN INFIELD(lnv04)
                           CALL cl_init_qry_var()
                           LET g_qryparam.state = 'c'
                           LET g_qryparam.form = "q_lnv04"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO lnv04
                           NEXT FIELD lnv04

                      #费用方案     
                      WHEN INFIELD(lnv18)
                           CALL cl_init_qry_var()
                           LET g_qryparam.state = 'c'
                           LET g_qryparam.form = "q_lnv18"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO lnv18
                           NEXT FIELD lnv18 
                           
                   END CASE             
            
             END CONSTRUCT        
             
             CONSTRUCT g_wc3 ON lit03,lit04,lit05,lit06,lit07,lit08,lit02
                                     FROM s_lit[1].lit03,s_lit[1].lit04,
                                          s_lit[1].lit05,s_lit[1].lit06,s_lit[1].lit07,
                                          s_lit[1].lit08,s_lit[1].lit02
                BEFORE CONSTRUCT
                   CALL cl_qbe_init()
                ON ACTION controlp
                   CASE 
                      #费用编号
                      WHEN INFIELD(lit04)
                           CALL cl_init_qry_var()
                           LET g_qryparam.state = 'c'
                           LET g_qryparam.form = "q_lit04"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO lit04
                           NEXT FIELD lit04

                      #优惠单号      
                      WHEN INFIELD(lit05)
                           CALL cl_init_qry_var()
                           LET g_qryparam.state = 'c'
                           LET g_qryparam.form = "q_lit05"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO lit05
                           NEXT FIELD lit05
                           
                    END CASE 
             END CONSTRUCT
             
             
             CONSTRUCT g_wc4 ON lnw11,lnw03,lnw08,lnw09,lnw06,lnw02
                                     FROM s_lnw[1].lnw11,s_lnw[1].lnw03,
                                          s_lnw[1].lnw08,s_lnw[1].lnw09,
                                          s_lnw[1].lnw06,s_lnw[1].lnw02
                 BEFORE CONSTRUCT
                    CALL cl_qbe_init()
                 ON ACTION controlp 
                    CASE 
                       #费用编号
                       WHEN INFIELD(lnw03)
                            CALL cl_init_qry_var()
                            LET g_qryparam.state = 'c'
                            LET g_qryparam.form = "q_lnw03"
                            CALL cl_create_qry() RETURNING g_qryparam.multiret
                            DISPLAY g_qryparam.multiret TO lnw03
                            NEXT FIELD lnw03    
                     END CASE         
                 
             END CONSTRUCT

             CONSTRUCT g_wc5 ON liu03,liu04,liu05,liu06,liu07,liu08
                           FROM s_liu[1].liu03,s_liu[1].liu04,
                                s_liu[1].liu05,s_liu[1].liu06,s_liu[1].liu07,s_liu[1].liu08
                 BEFORE CONSTRUCT
                    CALL cl_qbe_init()
                 ON ACTION controlp 
                    CASE 
                       #费用编号
                       WHEN INFIELD(liu04)
                            CALL cl_init_qry_var()
                            LET g_qryparam.state = 'c'
                            LET g_qryparam.form = "q_liu04"
                            CALL cl_create_qry() RETURNING g_qryparam.multiret
                            DISPLAY g_qryparam.multiret TO liu04
                            NEXT FIELD liu04    
                       #付款方式编号
                       WHEN INFIELD(liu05)
                            CALL cl_init_qry_var()
                            LET g_qryparam.state = 'c'
                            LET g_qryparam.form = "q_liu05"
                            CALL cl_create_qry() RETURNING g_qryparam.multiret
                            DISPLAY g_qryparam.multiret TO liu05
                            NEXT FIELD liu05
                   END CASE      
             END CONSTRUCT 

             CONSTRUCT g_wc6 ON lnu06,lnu03,lnu05,lnu07,lnu04,lnu08,lnu09,lnu10,lnu02
                           FROM s_lnu[1].lnu06,s_lnu[1].lnu03,s_lnu[1].lnu05,s_lnu[1].lnu07,s_lnu[1].lnu04,
                                s_lnu[1].lnu08,s_lnu[1].lnu09,s_lnu[1].lnu10,s_lnu[1].lnu02
                 BEFORE CONSTRUCT 
                    CALL cl_qbe_init()
                 ON ACTION controlp
                    CASE 
                       #场地编号
                       WHEN INFIELD(lnu03)
                            CALL cl_init_qry_var()
                            LET g_qryparam.state = 'c'
                            LET g_qryparam.form = "q_lnu03"
                            CALL cl_create_qry() RETURNING g_qryparam.multiret
                            DISPLAY g_qryparam.multiret TO lnu03
                            NEXT FIELD lnu03 

                       #楼栋编号
                       WHEN INFIELD(lnu08)
                            CALL cl_init_qry_var()
                            LET g_qryparam.state = 'c'
                            LET g_qryparam.form = "q_lnu08"
                            CALL cl_create_qry() RETURNING g_qryparam.multiret
                            DISPLAY g_qryparam.multiret TO lnu08
                            NEXT FIELD lnu08 

                       #楼层编号     
                       WHEN INFIELD(lnu09)
                            CALL cl_init_qry_var()
                            LET g_qryparam.state = 'c'
                            LET g_qryparam.form = "q_lnu09"
                            CALL cl_create_qry() RETURNING g_qryparam.multiret
                            DISPLAY g_qryparam.multiret TO lnu09
                            NEXT FIELD lnu09 

                       #区域编号     
                       WHEN INFIELD(lnu10)
                            CALL cl_init_qry_var()
                            LET g_qryparam.state = 'c'
                            LET g_qryparam.form = "q_lnu10"
                            CALL cl_create_qry() RETURNING g_qryparam.multiret
                            DISPLAY g_qryparam.multiret TO lnu10
                            NEXT FIELD lnu10                         
                     END CASE
                 
             END CONSTRUCT      

             CONSTRUCT g_wc7 ON lny04,lny03,lny02
                           FROM s_lny[1].lny04,s_lny[1].lny03,s_lny[1].lny02
                 BEFORE CONSTRUCT 
                    CALL cl_qbe_init()
                 ON ACTION controlp
                    CASE 
                        WHEN INFIELD(lny03)
                             CALL cl_init_qry_var()
                             LET g_qryparam.state = 'c'
                             LET g_qryparam.form = "q_lny03"
                             CALL cl_create_qry() RETURNING g_qryparam.multiret
                             DISPLAY g_qryparam.multiret TO lny03
                             NEXT FIELD lny03                      
                     END CASE
                 
             END CONSTRUCT           
             ON ACTION controlg
                CALL cl_cmdask()
             
             ON ACTION close
                LET INT_FLAG=1
                EXIT DIALOG
             
             ON ACTION accept
                EXIT DIALOG
             
             ON ACTION cancel
                LET INT_FLAG=1
                EXIT DIALOG
              
         END DIALOG
      END IF                         #FUN-C60062 add  
      
      IF INT_FLAG THEN
         RETURN
      END IF
      
      #查询SQL
       LET g_sql = "SELECT UNIQUE lnt01 "
       LET l_table = " FROM lnt_file " 
 
       LET l_where = " WHERE ",g_wc
       IF g_wc2 <> " 1=1" THEN
          LET l_table = l_table,",lnv_file"
          LET l_where = l_where," AND lnt01 = lnv01 AND ",g_wc2
       END IF
       IF g_wc3 <> " 1=1" THEN
          LET l_table = l_table,",lit_file"
          LET l_where = l_where," AND lnt01 = lit01 AND ",g_wc3
       END IF 
       IF g_wc4 <> " 1=1" THEN
          LET l_table = l_table,",lnw_file"
          LET l_where = l_where," AND lnt01 = lnw01 AND ",g_wc4
       END IF
       IF g_wc5 <> " 1=1" THEN
          LET l_table = l_table,",liu_file"
          LET l_where = l_where," AND lnt01 = liu01 AND ",g_wc5
       END IF
       IF g_wc6 <> " 1=1" THEN
          LET l_table = l_table,",lnu_file"
          LET l_where = l_where," AND lnt01 = lnu01 AND ",g_wc6
       END IF
       IF g_wc7 <> " 1=1" THEN
          LET l_table = l_table,",lny_file"
          LET l_where = l_where," AND lnt01 = lny01 AND ",g_wc7
       END IF
       LET g_sql = g_sql,l_table,l_where," ORDER BY lnt01"
      PREPARE i400_pre FROM g_sql
      DECLARE i400_cur SCROLL CURSOR WITH HOLD FOR i400_pre
      
      #查询总笔数
      LET g_sql = "SELECT COUNT(DISTINCT lnt01) ",l_table,l_where
      PREPARE i400_count_pre FROM g_sql
      DECLARE i400_count CURSOR FOR i400_count_pre
      
END FUNCTION

FUNCTION i400_q()
   
    LET g_row_count = 0
    LET g_curs_index = 0
    CLEAR FORM
    INITIALIZE g_lnt.* TO NULL
    INITIALIZE g_lne.* TO NULL
    CALL g_lnv.clear()
    CALL g_lit.clear()
    CALL g_lnw.clear()
    CALL g_liu.clear()
    CALL g_lnu.clear()
    CALL g_lny.clear() 
    CALL i400_cs()
    
    IF INT_FLAG THEN
       LET INT_FLAG=0
       CALL cl_err('',STATUS,0)
       INITIALIZE g_lnt.* TO NULL
       RETURN
    END IF
    
    OPEN i400_cur
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_lnt.* TO NULL
    ELSE
       OPEN i400_count 
       
       FETCH i400_count INTO g_row_count
       
       CALL i400_fetch("F")
       
    END IF
    
END FUNCTION

FUNCTION i400_fetch(p_flag)
    DEFINE p_flag  LIKE type_file.chr1
    
    CLEAR FORM
    INITIALIZE g_lnt.* TO NULL
    INITIALIZE g_lne.* TO NULL 
    CALL g_lnv.clear()
    CALL g_lit.clear()
    CALL g_lnw.clear()
    CALL g_liu.clear()
    CALL g_lnu.clear()
    CALL g_lny.clear()
    
    CASE p_flag
      WHEN "F" FETCH FIRST    i400_cur INTO g_lnt.lnt01
      WHEN "P" FETCH PREVIOUS i400_cur INTO g_lnt.lnt01
      WHEN "N" FETCH NEXT     i400_cur INTO g_lnt.lnt01
      WHEN "L" FETCH LAST     i400_cur INTO g_lnt.lnt01
      WHEN "/" 
            IF (NOT g_no_ask) THEN 
              CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
              PROMPT g_msg CLIPPED,': ' FOR g_jump
                 
                 ON ACTION control
                    CALL cl_cmdask()
                    
              END PROMPT
              
              IF INT_FLAG THEN
                 LET INT_FLAG=0
                 RETURN
              END IF
            END IF
              
            FETCH ABSOLUTE g_jump i400_cur INTO g_lnt.lnt01
              
    END CASE
    
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       RETURN
    ELSE
    
       CASE p_flag
         WHEN "F"  LET g_curs_index=1
         WHEN "P"  LET g_curs_index=g_curs_index-1
         WHEN "N"  LET g_curs_index=g_curs_index+1
         WHEN "L"  LET g_curs_index=g_row_count
         CALL cl_navigator_setting( g_curs_index, g_row_count )
       END CASE
    END IF
    SELECT * INTO g_lnt.* FROM lnt_file WHERE lnt01 = g_lnt.lnt01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","lnt_file","","",SQLCA.sqlcode,"","",1)
       INITIALIZE g_lnt.* TO NULL
       RETURN
    END IF
    
    DISPLAY g_curs_index TO idx
    DISPLAY g_row_count TO cnt
    CALL i400_show()
    
END FUNCTION

FUNCTION i400_desc()
DEFINE l_rtz13   LIKE rtz_file.rtz13,
       l_azt02   LIKE azt_file.azt02,
       l_lne05   LIKE lne_file.lne05,
       l_tqa02   LIKE tqa_file.tqa02,
       l_lmb03   LIKE lmb_file.lmb03,
       l_lmc04   LIKE lmc_file.lmc04,
       l_lmy04   LIKE lmy_file.lmy04,
       l_gen02   LIKE gen_file.gen02,
       l_gem02   LIKE gem_file.gem02,
       l_gen02_1 LIKE gen_file.gen02,
       l_gen02_2 LIKE gen_file.gen02,
       l_tqa02_1 LIKE tqa_file.tqa02,
       l_oba02   LIKE oba_file.oba02,
       l_oba02_1 LIKE oba_file.oba02,
       l_oba02_2 LIKE oba_file.oba02
 
   SELECT rtz13 INTO l_rtz13 FROM rtz_file
    WHERE rtz01=g_lnt.lntplant
    DISPLAY l_rtz13 TO rtz13 

   SELECT azt02 INTO l_azt02 FROM azt_file
    WHERE azt01=g_lnt.lntlegal
    DISPLAY l_azt02 TO azt02

   SELECT lne05 INTO l_lne05 FROM lne_file
    WHERE lne01 = g_lnt.lnt04
    DISPLAY l_lne05 TO lne05  

   SELECT tqa02 INTO l_tqa02 FROM tqa_file
    WHERE tqa01 = g_lnt.lnt55
      AND tqa03 = '30'
    DISPLAY l_tqa02 TO tqa02  

   SELECT lmb03 INTO l_lmb03 FROM lmb_file
    WHERE lmb02 = g_lnt.lnt08
    DISPLAY l_lmb03 TO lmb03 

   SELECT lmc04 INTO l_lmc04 FROM lmc_file
    WHERE lmc03 = g_lnt.lnt09
    DISPLAY l_lmc04 TO lmc04 

   SELECT lmy04 INTO l_lmy04 FROM lmy_file
    WHERE lmy03 = g_lnt.lnt60
    DISPLAY l_lmy04 TO lmy04 

   SELECT gen02 INTO l_gen02 FROM gen_file
    WHERE gen01 = g_lnt.lnt62
    DISPLAY l_gen02 TO gen02

   SELECT gem02 INTO l_gem02 FROM gem_file
    WHERE gem01 = g_lnt.lnt63
    DISPLAY l_gem02 TO gem02

   SELECT gen02 INTO l_gen02_1 FROM gen_file
    WHERE gen01 = g_lnt.lnt27
    DISPLAY l_gen02_1 TO gen02_1

   SELECT gen02 INTO l_gen02_2 FROM gen_file
    WHERE gen01 = g_lnt.lnt47
    DISPLAY l_gen02_2 TO gen02_2

   SELECT tqa02 INTO l_tqa02_1 FROM tqa_file 
    WHERE tqa01 = g_lnt.lnt30
      AND tqa03 = '2' 
    DISPLAY l_tqa02_1 TO tqa02_1

   SELECT oba02 INTO l_oba02 FROM oba_file
    WHERE oba01 = g_lnt.lnt31
    DISPLAY l_oba02 TO oba02 

   SELECT oba02 INTO l_oba02_1 FROM oba_file 
    WHERE oba01 = g_lnt.lnt32
    DISPLAY l_oba02_1 TO oba02_1

   SELECT oba02 INTO l_oba02_2 FROM oba_file 
    WHERE oba01 = g_lnt.lnt33
    DISPLAY l_oba02_2 TO oba02_2 
END FUNCTION 

FUNCTION i400_ins_lnu()
    DEFINE l_n   LIKE type_file.num5
    DEFINE l_sql STRING     
    DEFINE l_lnu RECORD LIKE lnu_file.*
    LET l_sql = "SELECT '','',lie02,lie07,lie05,'','','',lie06,lmf03,lie03,lie04 ",
                "  FROM lie_file,lmf_file WHERE lie01 = lmf01 AND lmf01 = '",g_lnt.lnt06,"'"
    DECLARE l_area_cur CURSOR FROM l_sql 
    FOREACH l_area_cur INTO l_lnu.*
       SELECT MAX(lnu06) + 1  INTO l_lnu.lnu06
         FROM lnu_file
        WHERE lnu01 = g_lnt.lnt01 
          AND lnuplant = g_lnt.lntplant
       IF cl_null(l_lnu.lnu06) THEN
           LET l_lnu.lnu06 = 1
       END IF 
       LET l_lnu.lnu02 = g_lnt.lnt02
       LET l_lnu.lnuplant = g_lnt.lntplant 
       LET l_lnu.lnulegal = g_lnt.lntlegal
       LET l_lnu.lnu01 = g_lnt.lnt01
       INSERT INTO lnu_file VALUES l_lnu.*
    END FOREACH
END FUNCTION 

FUNCTION i400_ins_lny()
   DEFINE l_sql STRING
   DEFINE l_lny RECORD LIKE lny_file.*
   LET l_sql = "SELECT '','',lnf03,'','','' FROM lnf_file ",
               " WHERE lnf01 = '",g_lnt.lnt04,"'"
   DECLARE l_ins_lny_cur CURSOR FROM l_sql
   FOREACH l_ins_lny_cur INTO l_lny.*
     LET l_lny.lny01 = g_lnt.lnt01 
     LET l_lny.lny02 = g_lnt.lnt02
     LET l_lny.lnyplant = g_lnt.lntplant
     LET l_lny.lnylegal = g_lnt.lntlegal
     SELECT MAX(lny04) + 1 INTO l_lny.lny04    
       FROM lny_file
      WHERE lny01 = g_lnt.lnt01
     IF cl_null(l_lny.lny04) THEN
        LET l_lny.lny04 = 1 
     END IF  
     INSERT INTO lny_file VALUES l_lny.*
   END FOREACH
END FUNCTION 

#抓取合同期内满足条件的优惠单
FUNCTION i400_ins_lit()
   DEFINE l_sql     STRING
   DEFINE l_liv06     LIKE liv_file.liv06
   DEFINE l_liv06_cut LIKE liv_file.liv06
   DEFINE l_date      LIKE lit_file.lit06 
   DEFINE l_ljb03     LIKE ljb_file.ljb03
   DEFINE l_lit04     LIKE lit_file.lit04
   DEFINE l_differences LIKE liv_file.liv06
   DEFINE l_sum_lit08 LIKE lit_file.lit08
   DEFINE l_lit   RECORD LIKE lit_file.*
   DEFINE l_liv   RECORD LIKE liv_file.*
   DEFINE l_lij05     LIKE lij_file.lij05

   IF cl_null(g_lnt.lnt01) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
   IF cl_null(g_lnt.lnt71) THEN
      CALL cl_err(g_lnt.lnt01,'alm1182',0)
      RETURN
   END IF
   IF g_lnt.lntacti <> 'Y' THEN
      CALL cl_err(g_lnt.lnt01,'ask-033',0)
      RETURN
   END IF 
   IF g_lnt.lnt26 = 'Y' THEN
      CALL cl_err(g_lnt.lnt01,'alm1264',0) 
      RETURN   
   END IF
   IF g_lnt.lnt26 = 'A' THEN
      CALL cl_err(g_lnt.lnt01,'alm1178',0)
      RETURN
   END IF
   IF g_lnt.lnt26 = 'S' THEN
      CALL cl_err(g_lnt.lnt01,'alm-300',0)
      RETURN
   END IF
   IF g_lnt.lnt26 = 'B' THEN
      CALL cl_err(g_lnt.lnt01,'alm1179',0)
      RETURN
   END IF
   IF g_lnt.lnt26 = 'F' THEN
      CALL cl_err(g_lnt.lnt01,'alm1264',0)
      RETURN
   END IF
   IF g_lnt.lnt26 = 'E' THEN
      CALL cl_err(g_lnt.lnt01,'alm-483',0)
      RETURN
   END IF      
   LET g_success = 'Y'
   BEGIN WORK 
   CALL s_showmsg_init()
   IF g_rec_b2 > 0 THEN
      IF NOT cl_confirm('alm-314') THEN    #是否重新执行优惠标准
         RETURN
      ELSE 
         DELETE FROM liv_file WHERE liv01 = g_lnt.lnt01 AND liv08 = '2'    #删除优惠标准的日核算
         DELETE FROM lit_file WHERE lit01 = g_lnt.lnt01                    #删除优惠标准的资料
      END IF 
   END IF     
   LET l_sql = "SELECT '','','',ljb04,lja01,ljb05,ljb06,ljb07,'','' ",
               "  FROM lij_file,lja_file,ljb_file",
               " WHERE lij01 = '",g_lnt.lnt71,
               "'  AND lja01 = ljb01",
               "   AND lij02 = ljb04",
               "   AND lja06 = '",g_lnt.lnt06,"'",
               "   AND lja12 = '",g_lnt.lnt04,"'",
               "   AND lja14 = '",g_lnt.lnt17,"'",
               "   AND lja15 = '",g_lnt.lnt18,"'",
               "   AND lja16 = '",g_lnt.lnt51,"'",
               "   AND lja05 IS NULL",
               "   AND ljaconf <> 'X' "  #CHI-C80041
   DECLARE i400_lit_curs_1 CURSOR FROM l_sql
   FOREACH i400_lit_curs_1 INTO l_lit.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach i400_lit_curs',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      LET l_lit.lit01 = g_lnt.lnt01
      LET l_lit.lit02 = g_lnt.lnt02
      SELECT MAX(lit03) + 1 INTO  l_lit.lit03
        FROM lit_file
       WHERE lit01 = g_lnt.lnt01
      IF cl_null(l_lit.lit03) THEN
         LET l_lit.lit03 = 1
      END IF 
      LET l_lit.litplant = g_lnt.lntplant
      LET l_lit.litlegal = g_lnt.lntlegal
      INSERT INTO lit_file VALUES l_lit.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','ins lit',SQLCA.sqlcode,1)
         LET g_success = 'N'
         ROLLBACK WORK
      END IF
      #计算日核算
      LET l_liv06 = l_lit.lit08 / (l_lit.lit07 - l_lit.lit06 + 1) 
      LET l_liv06 = cl_digcut(l_liv06,g_lla04)
      LET l_date = l_lit.lit06 
      LET l_liv.liv01 = g_lnt.lnt01
      LET l_liv.liv02 = l_lit.lit02
      LET l_liv.liv05 = l_lit.lit04
      LET l_liv.liv06 = l_liv06
      LET l_liv.liv07 = l_lit.lit05
      LET l_liv.liv071 = ''
      LET l_liv.liv08 = '2'
      SELECT ljb03 INTO l_liv.liv09 
        FROM ljb_file
       WHERE ljb01 = l_lit.lit05
         AND ljb04 = l_lit.lit04
         AND ljb05 = l_lit.lit06
      LET l_liv.livplant = g_plant
      LET l_liv.livlegal = g_legal
      #差异计算
      LET l_liv06_cut = l_liv06 * (l_lit.lit07 - l_lit.lit06 + 1)
      LET l_differences = l_lit.lit08 - l_liv06_cut
      LET l_differences = cl_digcut(l_differences,g_lla04)
      SELECT lij05 INTO l_lij05 FROM lij_file
       WHERE lij01 = g_lnt.lnt71
         AND lij02 = l_lit.lit04
      WHILE TRUE
         SELECT MAX(liv03) + 1 INTO l_liv.liv03
           FROM liv_file
          WHERE liv01 = g_lnt.lnt01
         IF cl_null(l_liv.liv03) THEN
            LET l_liv.liv03 = 1
         END IF 
         LET l_liv.liv04 = l_date
         LET l_liv.liv06 = l_liv06
         IF g_lla01 = '2' AND l_lit.lit07 = l_date THEN
         #将差异金额计算到日核算的最后一天中
            LET l_liv.liv06 = l_liv.liv06 + l_differences
         END IF
         IF g_lla01 = '1' AND l_lit.lit06 = l_date THEN
         #将差异金额计算到日核算的第一天中
            LET l_liv.liv06 = l_liv.liv06 + l_differences
         END IF
         #By shi IF收付实现制，产生一笔日核算，放在开始日期这一天
         IF l_lij05 = '1' THEN
            LET l_liv.liv06 = l_lit.lit08
         END IF
         INSERT INTO liv_file VALUES l_liv.*
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('','','ins liv',SQLCA.sqlcode,1)
            LET g_success = 'N'
            ROLLBACK WORK
         END IF
         IF l_lij05 = '1' THEN EXIT WHILE END IF
         LET l_date = l_date + 1 
         IF l_date > l_lit.lit07 THEN
            EXIT WHILE 
         END IF
      END WHILE
     ##差异计算 By shi移动while里面处理
     #LET l_liv06_cut = l_liv06 * (l_lit.lit07 - l_lit.lit06 + 1) 
     #LET l_differences = l_lit.lit08 - l_liv06_cut 
     #LET l_differences = cl_digcut(l_differences,g_lla04) 
     #IF g_lla01 = '2' THEN
     ##将差异金额计算到日核算的最后一天中
     #  UPDATE liv_file SET liv06 = l_liv06 + l_differences
     #   WHERE liv01 = g_lnt.lnt01
     #     AND liv05 = l_lit.lit04
     #     AND liv08 = '2'
     #     AND liv04 = l_lit.lit07 
     #   IF SQLCA.sqlerrd[3]=0 THEN
     #      CALL cl_err3("upd","liv_file",g_lnt.lnt01,"",SQLCA.sqlcode,"","",1)
     #      ROLLBACK WORK
     #      RETURN
     #   END IF    
     #END IF 
     #IF g_lla01 = '1' THEN
     ##将差异金额计算到日核算的第一天中
     #  UPDATE liv_file SET liv06 = l_liv06 + l_differences
     #   WHERE liv01 = g_lnt.lnt01
     #     AND liv05 = l_lit.lit04
     #     AND liv08 = '2'
     #     AND liv04 = l_lit.lit06
     #   IF SQLCA.sqlerrd[3]=0 THEN
     #      CALL cl_err3("upd","liv_file",g_lnt.lnt01,"",SQLCA.sqlcode,"","",1)
     #      ROLLBACK WORK
     #      RETURN
     #   END IF
     #END IF 
   END FOREACH
   #更新单头费用栏位的值
   CALL i400_upd()
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_err('','alm1328',0) #执行成功
   ELSE 
      CALL s_showmsg()
      CALL cl_err('','alm1329',0) #执行失败  
   END IF 
   CALL i400_b_fill()
   IF g_rec_b2 = 0 THEN
      CALL cl_err('','alm1183',0)
   END IF
END FUNCTION

#抓取合同费用项中的费用编号，INSERT到单身
FUNCTION i400_ins_lnw()
   DEFINE l_sql   STRING      
   DEFINE l_lij02 LIKE lij_file.lij02 
   DEFINE l_lnw   RECORD LIKE lnw_file.*
   IF cl_null(g_lnt.lnt01) THEN
      RETURN
   END IF 
   IF cl_null(g_lnt.lnt71) THEN
      CALL cl_err(g_lnt.lnt01,'alm1182',0)
      RETURN
   END IF
   IF g_lnt.lntacti <> 'Y' THEN
      CALL cl_err(g_lnt.lnt01,'ask-033',0)
      RETURN
   END IF
   IF g_lnt.lnt26 = 'Y' THEN
      CALL cl_err(g_lnt.lnt01,'alm1265',0)
      RETURN
   END IF
   IF g_lnt.lnt26 = 'A' THEN
      CALL cl_err(g_lnt.lnt01,'alm1178',0)
      RETURN
   END IF
   IF g_lnt.lnt26 = 'S' THEN
      CALL cl_err(g_lnt.lnt01,'alm-300',0)
      RETURN
   END IF
   IF g_lnt.lnt26 = 'B' THEN
      CALL cl_err(g_lnt.lnt01,'alm1179',0)
      RETURN
   END IF
   IF g_lnt.lnt26 = 'F' THEN
      CALL cl_err(g_lnt.lnt01,'alm1265',0)
      RETURN
   END IF
   IF g_lnt.lnt26 = 'E' THEN
      CALL cl_err(g_lnt.lnt01,'alm-483',0)
      RETURN
   END IF
   IF g_rec_b3 > 0 THEN
      CALL i400_b_fill()
      CALL i400_b3()
      RETURN
   END IF 
   LET l_sql = "SELECT lij02",
               "  FROM lij_file WHERE lij01 = '",g_lnt.lnt71,"' AND lij06 = 'N'"      
   DECLARE l_free_cur CURSOR FROM l_sql
   FOREACH l_free_cur INTO l_lij02 
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach l_free_curs',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET l_lnw.lnw01 = g_lnt.lnt01 
      LET l_lnw.lnw02 = g_lnt.lnt02
      LET l_lnw.lnw03 = l_lij02
      LET l_lnw.lnw05 = ''
      LET l_lnw.lnw06 = 0 
      LET l_lnw.lnw06 = cl_digcut(l_lnw.lnw06,g_lla04)
      LET l_lnw.lnw07 = ' '
      LET l_lnw.lnw08 = g_lnt.lnt21
      LET l_lnw.lnw09 = g_lnt.lnt22
      LET l_lnw.lnw10 = ''
      LET l_lnw.lnwlegal = g_lnt.lntlegal
      LET l_lnw.lnwplant = g_lnt.lntplant
      SELECT MAX(lnw11) + 1 INTO l_lnw.lnw11
        FROM lnw_file
       WHERE lnw01 = g_lnt.lnt01
      IF cl_null(l_lnw.lnw11) THEN
         LET l_lnw.lnw11 = 1
      END IF 
      INSERT INTO lnw_file VALUES l_lnw.*
   END FOREACH
   CALL i400_b_fill()
   CALL i400_b3()
END FUNCTION 

FUNCTION i400_ins_liu()
   DEFINE l_n     LIKE type_file.num5
   DEFINE l_sql   STRING
   DEFINE l_liu04 LIKE liu_file.liu04
   DEFINE l_liu   RECORD LIKE liu_file.*

   IF cl_null(g_lnt.lnt71) THEN
      CALL cl_err(g_lnt.lnt01,'alm1182',0)
      RETURN
   END IF
   IF g_lnt.lntacti <> 'Y' THEN
      CALL cl_err(g_lnt.lnt01,'ask-033',0)
      RETURN
   END IF
   IF g_lnt.lnt26 = 'Y' THEN
      CALL cl_err(g_lnt.lnt01,'alm1266',0)
      RETURN
   END IF
   IF g_lnt.lnt26 = 'A' THEN
      CALL cl_err(g_lnt.lnt01,'alm1178',0)
      RETURN
   END IF
   IF g_lnt.lnt26 = 'S' THEN
      CALL cl_err(g_lnt.lnt01,'alm-300',0)
      RETURN
   END IF
   IF g_lnt.lnt26 = 'B' THEN
      CALL cl_err(g_lnt.lnt01,'alm1179',0)
      RETURN
   END IF
   IF g_lnt.lnt26 = 'F' THEN
      CALL cl_err(g_lnt.lnt01,'alm1266',0)
      RETURN
   END IF
   IF g_lnt.lnt26 = 'E' THEN
      CALL cl_err(g_lnt.lnt01,'alm-483',0)
      RETURN
   END IF
  #MOD-C30450 Begin---
  #IF g_rec_b4 > 0 THEN
  #   CALL i400_b_fill()
  #   CALL i400_b4()
  #   RETURN
  #END IF 
   IF g_rec_b4 > 0 THEN
      IF cl_confirm('alm1401') THEN
         DELETE FROM liu_file WHERE liu01= g_lnt.lnt01
         IF SQLCA.sqlcode THEN
            CALL cl_err('del liu',SQLCA.sqlcode,1)
            RETURN
         END IF
      ELSE
         CALL i400_b_fill()
         CALL i400_b4()
         RETURN
      END IF
   END IF
  #MOD-C30450 End-----
   LET l_sql = "SELECT DISTINCT lnv04",  #FUN-CA0081 Add DISTINCT
               "  FROM lnv_file,lnt_file",
               " WHERE lnt01 = '",g_lnt.lnt01,"'",
               "   AND lnt01 = lnv01 ",
               " UNION SELECT lnw03 FROM lnw_file,lnt_file WHERE lnt01 = lnw01 AND lnt01 = '",g_lnt.lnt01,"'"
   DECLARE ins_liu_cur CURSOR FROM l_sql  
   #抓取标准费用中的费用编号
   FOREACH ins_liu_cur INTO l_liu04
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach ins_liu_cur',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET l_liu.liu01 = g_lnt.lnt01
      LET l_liu.liu02 = g_lnt.lnt02
      SELECT MAX(liu03) + 1 INTO l_liu.liu03
        FROM liu_file
       WHERE liu01 = g_lnt.lnt01
      IF cl_null(l_liu.liu03) THEN
         LET l_liu.liu03 = 1
      END IF 
      LET l_liu.liu04 = l_liu04
      SELECT lij03,lij07,lij08,lij05
        INTO l_liu.liu05,l_liu.liu06,l_liu.liu07,l_liu.liu08
        FROM lij_file
       WHERE lij01 = g_lnt.lnt71
         AND lij02 = l_liu04
      LET l_liu.liuplant = g_lnt.lntplant
      LET l_liu.liulegal = g_lnt.lntlegal
     #FUN-CA0081 Add Begin ---
     #若當前費用編號在合同日期內存在類型為2.比例標準的費用設置,則出賬期默認給付款方式的月份數
      LET l_n = 0 
      SELECT COUNT(*) INTO l_n FROM lip_file WHERE lip01 IN (SELECT lnv18 FROM lnv_file WHERE lnv01 = g_lnt.lnt01 AND lnv04 = l_liu04 AND lip04 = '2')
      IF l_n = 0 THEN
         SELECT COUNT(*) INTO l_n FROM lil_file WHERE lil01 IN (SELECT lnv18 FROM lnv_file WHERE lnv01 = g_lnt.lnt01 AND lnv04 = l_liu04 AND lil00 = '2')
      END IF
      IF l_n > 0 THEN
         SELECT lnr03 INTO l_liu.liu06 FROM lnr_file WHERE lnr01 = l_liu.liu05
      END IF
     #FUN-CA0081 Add End -----
      INSERT INTO liu_file VALUES l_liu.*
   END FOREACH
   CALL i400_b_fill()
   CALL i400_b4()
END FUNCTION 

FUNCTION i400_lnt62(p_cmd)
DEFINE l_genacti    LIKE gen_file.genacti
DEFINE p_cmd        LIKE type_file.chr1
DEFINE l_gem02      LIKE gem_file.gem02
   LET g_errno = ''
   SELECT genacti,gen02,gen03
     INTO l_genacti,g_gen02,g_lnt.lnt63
     FROM gen_file
    WHERE gen01 = g_lnt.lnt62 
   CASE 
      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'anm-207'       #此业务员不存在
                               LET g_gen02 = ''
                               LET g_lnt.lnt63 = ''
      WHEN l_genacti <> 'Y'    LET g_errno = 'alm-879'       #此业务员无效  
                               LET g_gen02 = ''
                               LET g_lnt.lnt63 = ''
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF p_cmd= 'd' OR cl_null(g_errno) THEN
      SELECT gem02 INTO l_gem02
        FROM gem_file
       WHERE gem01 = g_lnt.lnt63
   END IF 
   DISPLAY g_gen02 TO gen02
   DISPLAY l_gem02 TO gem02
END FUNCTION 

FUNCTION i400_lnt63()
DEFINE l_gemacti    LIKE gem_file.gemacti
DEFINE l_n          LIKE type_file.num5
   LET g_errno = ''
   SELECT gemacti,gem02
     INTO l_gemacti,g_gem02
     FROM gem_file
    WHERE gem01 = g_lnt.lnt63 
   CASE 
      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-039'      #部门编号不存在
                               LET g_gem02 = ''
      WHEN l_gemacti <> 'Y'    LET g_errno = 'asf-472'      #部门编号无效   
                               LET g_gem02 = ''
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF NOT cl_null(g_lnt.lnt62) AND cl_null(g_errno) THEN
      SELECT COUNT(*) INTO l_n
        FROM gen_file,gem_file
       WHERE gen01 = g_lnt.lnt62
         AND gen03 = gem01
         AND gem01 = g_lnt.lnt63
     IF l_n = 0 THEN
        LET g_errno = 'apj-033'
        RETURN 
     END IF 
   END IF 
   DISPLAY g_gem02 TO gem02
END FUNCTION 

FUNCTION i400_lnt71()
   DEFINE l_liiconf  LIKE lii_file.liiconf
   DEFINE l_liiacti  LIKE lii_file.liiacti
   DEFINE l_lii03    LIKE lii_file.lii03,
          l_lii04    LIKE lii_file.lii04,
          l_lii05    LIKE lii_file.lii05
   LET g_errno = ''
   SELECT liiconf,liiacti,lii03,lii04,lii05 
     INTO l_liiconf,l_liiacti,l_lii03,l_lii04,l_lii05
     FROM lii_file
    WHERE lii01 = g_lnt.lnt71
      AND liiplant = g_plant
   CASE 
      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'alm1261'            #无此费用项方案
      WHEN l_liiconf =  'N'    LET g_errno = 'alm1262'            #费用项方案未审核
      WHEN l_liiacti <> 'Y'    LET g_errno = 'alm1263'            #费用项方案无效
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE 
   IF NOT cl_null(g_lnt.lnt06) THEN
      IF g_lnt.lnt55 <> l_lii05 THEN
         LET g_errno = 'alm1269'
         RETURN
      END IF 
      IF g_lnt.lnt08 <> l_lii03 THEN
         LET g_errno = 'alm1270'
         RETURN
      END IF 
      IF g_lnt.lnt09 <> l_lii04 THEN
         LET g_errno = 'alm1271'
         RETURN
      END IF  
   END IF 
END FUNCTION 

FUNCTION i400_a()
    DEFINE li_result  LIKE type_file.num5 
    DEFINE l_n        LIKE type_file.num5
    DEFINE l_rtz13    LIKE rtz_file.rtz13,
           l_azt02    LIKE azt_file.azt02
    #清空 单头和单身
    CLEAR FORM
    INITIALIZE g_lnt.* TO NULL
    LET g_lnt_t.* = g_lnt.*
    INITIALIZE g_lne.* TO NULL
    CALL g_lnv.clear()
    CALL g_lit.clear()
    CALL g_lnw.clear()
    CALL g_liu.clear()
    CALL g_lnu.clear()
    CALL g_lny.clear()
    IF s_shut(0) THEN
       RETURN
    END IF
    WHILE TRUE
       LET g_lnt.lntplant=g_plant
       LET g_lnt.lntlegal=g_legal
       LET g_lnt.lnt02='0'
       LET g_lnt.lnt03=g_today
       LET g_lnt.lnt16 = '0'
       LET g_lnt.lnt51 = 0
       LET g_lnt.lnt54 = '1'
       LET g_lnt.lnt45 = 'Y'
       LET g_lnt.lnt58 = 'N'
       LET g_lnt.lnt59 = 'N'
       LET g_lnt.lnt26 = 'N'
       LET g_lnt.lnt48 = '0' 
       LET g_lnt.lnt57 = 'Y'
       LET g_lnt.lnt38 = ' '
       LET g_lnt.lnt72 = 1
       LET g_lnt.lnt73 = ' '
       LET g_lnt.lntpos = '1'
       LET g_lnt.lnt62 = g_user
       LET g_lnt.lnt63 = g_grup
       LET g_lnt.lntuser=g_user
       LET g_lnt.lntgrup=g_grup
       LET g_lnt.lntacti = 'Y'
       LET g_lnt.lntcrat=g_today
       LET g_lnt.lntoriu=g_user
       LET g_lnt.lntorig=g_grup

       SELECT rtz13 INTO l_rtz13 FROM rtz_file
        WHERE rtz01=g_lnt.lntplant
        DISPLAY l_rtz13 TO rtz13
    
       SELECT azt02 INTO l_azt02 FROM azt_file
        WHERE azt01=g_lnt.lntlegal
        DISPLAY l_azt02 TO azt02
         
       CALL i400_i('a')
       
       IF INT_FLAG THEN
          LET INT_FLAG=0
          CALL cl_err('',STATUS,0)
          INITIALIZE g_lnt.* TO NULL
          DISPLAY BY NAME g_lnt.*
          CLEAR FORM
          EXIT WHILE
       END IF
       
       CALL s_auto_assign_no("alm",g_lnt.lnt01,g_today,"03","lnt_file","lnt01","","","") 
         RETURNING li_result,g_lnt.lnt01
       IF (NOT li_result) THEN
          CONTINUE WHILE
       END IF
       DISPLAY BY NAME g_lnt.lnt01
       INSERT INTO lnt_file VALUES(g_lnt.*)
       MESSAGE ""
       IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","lnt_file",
                        g_lnt.lnt01,"",SQLCA.sqlcode,"","",1)
           ROLLBACK WORK
           CONTINUE WHILE    
       ELSE
          LET g_lnt_t.* = g_lnt.*
          LET g_lne_t.* = g_lne.*
          CALL g_lnv.clear()
          CALL g_lnw.clear()
          CALL g_liu.clear()
          CALL g_lit.clear()
          CALL g_lnu.clear()
          CALL g_lny.clear() 
          #场地插入到合同场地
          CALL i400_ins_lnu()
          #插入其他品牌到合同其他品牌
          CALL i400_ins_lny()
          CALL i400_b_fill()
          EXIT WHILE
       END IF
    END WHILE
    
END FUNCTION

FUNCTION i400_i(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE li_result LIKE type_file.num5 
   DEFINE l_gecacti LIKE gec_file.gecacti
   DEFINE l_llc02   LIKE llc_file.llc02
   DEFINE g_t1      LIKE lnt_file.lnt01,
          l_n       LIKE type_file.num5
  
   CALL cl_set_head_visible("","YES")   #MOD-C80167 add
 
   DISPLAY BY NAME g_lnt.lntplant,g_lnt.lntlegal,g_lnt.lnt02,g_lnt.lnt03,
                   g_lnt.lnt16,g_lnt.lnt54,g_lnt.lnt45,g_lnt.lnt57,g_lnt.lnt58,g_lnt.lnt59,
                   g_lnt.lnt26,g_lnt.lnt48,g_lnt.lntpos,g_lnt.lntuser,
                   g_lnt.lntgrup,g_lnt.lntmodu,g_lnt.lntdate,
                   g_lnt.lntacti,g_lnt.lntcrat,g_lnt.lntoriu,g_lnt.lntorig
   INPUT BY NAME g_lnt.lnt01,g_lnt.lnt03,g_lnt.lnt04,g_lnt.lnt06,
                 g_lnt.lnt55,g_lnt.lnt56,g_lnt.lnt16,g_lnt.lnt57,
                 g_lnt.lnt54,g_lnt.lnt45,g_lnt.lnt58,g_lnt.lnt59,
                 g_lnt.lnt17,g_lnt.lnt18,g_lnt.lnt51,g_lnt.lnt21,
                 g_lnt.lnt22,g_lnt.lnt62,g_lnt.lnt63,g_lnt.lnt26,
                 g_lnt.lnt48,g_lnt.lnt28,g_lnt.lnt46,g_lnt.lnt29,
                 g_lnt.lnt30,g_lnt.lnt35,g_lnt.lnt71,g_lnt.lnt72
         WITHOUT DEFAULTS  
    
        BEFORE INPUT
           CALL i400_set_entry(p_cmd)
           CALL i400_set_noentry(p_cmd) 
           IF g_lnt.lnt57 = 'N' THEN
              CALL cl_set_comp_entry("lnt54",FALSE)
           END IF  
           CALL cl_set_docno_format("lnt01")

        #合同单别
        AFTER FIELD lnt01
          IF NOT cl_null(g_lnt.lnt01) THEN
             IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lnt_t.lnt01 <> g_lnt.lnt01) THEN
                 CALL s_check_no("alm",g_lnt.lnt01,g_lnt.lnt01,"K1","lnt_file","lnt01","")
                      RETURNING li_result,g_lnt.lnt01
                 IF (NOT li_result) THEN
                    LET g_lnt.lnt01 = g_lnt_t.lnt01 
                    NEXT FIELD lnt01
                 END IF
                 LET g_t1=s_get_doc_no(g_lnt.lnt01)
                 #由单别带出签核
                 SELECT oayapr INTO g_lnt.lnt25 FROM oay_file WHERE oayslip = g_t1  
             END IF 
          END IF
        
        #商户编号   
        AFTER FIELD lnt04
           IF NOT cl_null(g_lnt.lnt04) THEN
              CALL i400_lnt04(p_cmd) 
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 LET g_lnt.lnt04 = g_lnt_t.lnt04
                 NEXT FIELD lnt04
              END IF     
           ELSE 
              LET g_lne.lne14 = ''
              LET g_lne.lne15 = ''
              LET g_lne.lne43 = ''
              LET g_lne.lne44 = ''
              LET g_lne.lne22 = ''
              LET g_lne.lne50 = ''
              LET g_lne.lne51 = ''
              LET g_lne.lne52 = ''
              LET g_lne.lne53 = ''
              LET g_lnt.lnt30 = ''
              LET g_lnt.lnt35 = ''
              LET g_lnt.lnt70 = ''
              CALL i400_desc()
           END IF
        
        #摊位编号
        AFTER FIELD lnt06
           IF NOT cl_null(g_lnt.lnt06) THEN
              IF NOT cl_null(g_lnt.lnt71) THEN
                 CALL i400_lnt71()
                 IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     LET g_lnt.lnt06 = g_lnt_t.lnt06
                     NEXT FIELD lnt06
                 END IF
              END IF
              CALL i400_lnt06(p_cmd)
              IF NOT cl_null(g_errno) THEN 
                  CALL cl_err('',g_errno,0)
                  LET g_lnt.lnt06 = g_lnt_t.lnt06
                  NEXT FIELD lnt06
              END IF   
              IF NOT cl_null(g_lnt.lnt51) THEN
                 SELECT llc02 INTO l_llc02
                   FROM llc_file
                  WHERE llcstore = g_plant
                    AND llc01 = g_lnt.lnt31
                 IF l_llc02 < g_lnt.lnt51 THEN
                     CALL cl_err('','alm1251',0)                 #免租天数不能大于租赁期限
                     LET g_lnt.lnt06 = g_lnt_t.lnt06
                     NEXT FIELD lnt06
                 END IF                   
              END IF 
           ELSE 
             LET g_lnt.lnt55 = ''
             LET g_lnt.lnt56 = ''
             LET g_lnt.lnt08 = ''
             LET g_lnt.lnt09 = ''
             LET g_lnt.lnt60 = ''
             LET g_lnt.lnt10 = ''
             LET g_lnt.lnt11 = ''
             LET g_lnt.lnt61 = ''
             LET g_lnt.lnt31 = ''
             LET g_lnt.lnt32 = '' 
             LET g_lnt.lnt33 = ''
             LET g_lnt.lnt70 = ''
             CALL i400_desc()
           END IF   

        #统一收银
        ON CHANGE lnt57
           IF g_lnt.lnt57 = 'Y' THEN
              CALL cl_set_comp_entry("lnt54",TRUE) 
           ELSE 
              CALL cl_set_comp_entry("lnt54",FALSE)
           END IF   
           
        AFTER FIELD lnt17,lnt18
           IF NOT cl_null(g_lnt.lnt17) OR NOT cl_null(g_lnt.lnt18) THEN
              IF NOT cl_null(g_lnt.lnt18) THEN
                  LET g_lnt.lnt22 = g_lnt.lnt18
                  DISPLAY BY NAME g_lnt.lnt22
              ELSE 
                  LET g_lnt.lnt22 = ''
                  DISPLAY BY NAME g_lnt.lnt22
              END IF
              
              IF g_lnt.lnt17 > g_lnt.lnt18 THEN
                  CALL cl_err('','alm-302',0)  #起日不可以大于止日
                  CASE
                     WHEN INFIELD(lnt17)
                        LET g_lnt.lnt17 = g_lnt_t.lnt17
                        DISPLAY BY NAME g_lnt.lnt17
                        NEXT FIELD CURRENT
                     WHEN INFIELD(lnt18)
                        LET g_lnt.lnt18 = g_lnt_t.lnt18
                        LET g_lnt.lnt22 = g_lnt_t.lnt22
                        DISPLAY BY NAME g_lnt.lnt18
                        DISPLAY BY NAME g_lnt.lnt22
                        NEXT FIELD CURRENT
                  END CASE
              END IF
              IF NOT cl_null(g_lnt.lnt51) THEN
                 LET g_lnt.lnt21 = g_lnt.lnt17 + g_lnt.lnt51
                 IF g_lnt.lnt21 > g_lnt.lnt22 THEN
                     CALL  cl_err('','alm1118',0)               #免租天数不能大于租赁期限
                     CASE
                        WHEN INFIELD(lnt17)
                           LET g_lnt.lnt17 = g_lnt_t.lnt17
                           LET g_lnt.lnt21 = g_lnt_t.lnt21
                           DISPLAY BY NAME g_lnt.lnt17,g_lnt.lnt21
                           NEXT FIELD CURRENT
                        WHEN INFIELD(lnt18)
                           LET g_lnt.lnt18 = g_lnt_t.lnt18
                           LET g_lnt.lnt22 = g_lnt_t.lnt18
                           DISPLAY BY NAME g_lnt.lnt18,g_lnt.lnt22
                           NEXT FIELD CURRENT
                     END CASE
                 END IF
                 DISPLAY BY NAME g_lnt.lnt17,g_lnt.lnt18,g_lnt.lnt21,g_lnt.lnt22
              END IF
              CALL i400_lnt06(p_cmd)
              IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  CASE 
                     WHEN INFIELD(lnt17)
                        LET g_lnt.lnt17 = g_lnt_t.lnt17
                        DISPLAY BY NAME g_lnt.lnt17
                        NEXT FIELD CURRENT
                     WHEN INFIELD(lnt18) 
                        LET g_lnt.lnt18 = g_lnt_t.lnt18
                        LET g_lnt.lnt22 = g_lnt_t.lnt22
                        DISPLAY BY NAME g_lnt.lnt18
                        DISPLAY BY NAME g_lnt.lnt22
                        NEXT FIELD CURRENT   
                  END CASE 
              END IF
           ELSE 
              LET g_lnt.lnt21 = ''
              LET g_lnt.lnt22 = ''
              IF cl_null(g_lnt.lnt17) THEN
                 LET g_lnt.lnt70 = ''
              END IF 
           END IF     

        AFTER FIELD lnt30 
           IF NOT cl_null(g_lnt.lnt30) THEN
              CALL i400_lnt30(p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 LET g_lnt.lnt30 = g_lnt_t.lnt30
                 DISPLAY '' TO tqa02_1
                 NEXT FIELD lnt30
              END IF 
           ELSE 
              DISPLAY '' TO tqa02_1
           END IF           

        AFTER FIELD lnt35
           IF NOT cl_null(g_lnt.lnt35) THEN
              CALL i400_lnt35(p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 LET g_lnt.lnt35 = g_lnt_t.lnt35
                 NEXT FIELD lnt35
              END IF
           ELSE
              LET g_lnt.lnt36 = ''
              LET g_lnt.lnt37 = ''
              DISPLAY BY NAME g_lnt.lnt36,g_lnt.lnt37
           END IF 

        AFTER FIELD lnt51
           IF NOT cl_null(g_lnt.lnt51) THEN
              IF g_lnt.lnt51 < 0 THEN
                 CALL cl_err('','alm1174',0) 
                 LET g_lnt.lnt51 = g_lnt_t.lnt51
                 NEXT FIELD lnt51
              END IF 
              IF NOT cl_null(g_lnt.lnt17) THEN
                 LET g_lnt.lnt21 = g_lnt.lnt17 + g_lnt.lnt51
                 IF g_lnt.lnt21 > g_lnt.lnt22 THEN
                     CALL cl_err('','alm1118',0)                 #免租天数不能大于租赁期限
                     LET g_lnt.lnt51 = g_lnt_t.lnt51
                     LET g_lnt.lnt21 = g_lnt_t.lnt21
                     DISPLAY BY NAME g_lnt.lnt21
                     NEXT FIELD lnt51
                 END IF 
                 DISPLAY BY NAME g_lnt.lnt21
              END IF 
              IF NOT cl_null(g_lnt.lnt31) THEN
                 SELECT llc02 INTO l_llc02
                   FROM llc_file
                  WHERE llcstore = g_plant 
                    AND llc01 = g_lnt.lnt31
                 IF l_llc02 < g_lnt.lnt51 THEN
                     CALL cl_err('','alm1251',0)                 #免租天数不能大于租赁期限
                     LET g_lnt.lnt51 = g_lnt_t.lnt51
                     LET g_lnt.lnt21 = g_lnt_t.lnt21
                     DISPLAY BY NAME g_lnt.lnt21
                     NEXT FIELD lnt51                    
                 END IF
              END IF 
           END IF 


        AFTER FIELD lnt62
            IF NOT cl_null(g_lnt.lnt62) THEN 
                CALL i400_lnt62(p_cmd)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   LET g_lnt.lnt62 = g_lnt_t.lnt62
                   NEXT FIELD lnt62
                END IF   
            END IF  

        AFTER FIELD lnt63
            IF NOT cl_null(g_lnt.lnt63) THEN 
               CALL i400_lnt63()
               IF NOT cl_null(g_errno) THEN 
                  CALL cl_err('',g_errno,0)
                  LET g_lnt.lnt63 = g_lnt_t.lnt63
                  NEXT FIELD lnt63        
               END IF   
            END IF  

        AFTER FIELD lnt71
            IF NOT cl_null(g_lnt.lnt71) THEN
               CALL i400_lnt71()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_lnt.lnt71 = g_lnt_t.lnt71
                  NEXT FIELD lnt71
               END IF
            END IF 
           
        AFTER FIELD lnt72
            IF NOT cl_null(g_lnt.lnt72) AND g_lnt.lnt72 < 0 THEN
               CALL cl_err('','alm-891',0)
               LET g_lnt.lnt72 = g_lnt_t.lnt72
               NEXT FIELD lnt72
            END IF

        ON ACTION controlp
           CASE 
               #合同单别开窗
               WHEN INFIELD(lnt01)
                    LET g_t1 = s_get_doc_no(g_lnt.lnt01)    
                    CALL q_oay(FALSE,FALSE,'','K1','ALM') RETURNING g_t1 
                    LET g_lnt.lnt01 = g_t1
                    DISPLAY BY NAME g_lnt.lnt01
                    NEXT FIELD lnt01
               
               #商户开窗
               WHEN INFIELD(lnt04)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form="q_lne02"
                    LET g_qryparam.default1=g_lnt.lnt04
                    LET g_qryparam.where = " lne36 = 'Y' AND '",g_lnt.lntplant,"' IN (SELECT lnhstore FROM lnh_file WHERE lnh01=lne01 AND lnh07='1') "
                    CALL cl_create_qry() RETURNING g_lnt.lnt04
                    DISPLAY BY NAME g_lnt.lnt04
                    CALL i400_lnt04('d')
                    NEXT FIELD lnt04
               
               #摊位开窗
               WHEN INFIELD(lnt06)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form="q_lmf03"
                    LET g_qryparam.default1=g_lnt.lnt06
                    LET g_qryparam.arg1 = g_plant
                    CALL cl_create_qry() RETURNING g_lnt.lnt06
                    DISPLAY BY NAME g_lnt.lnt06
                    CALL i400_lnt06('d')
                    NEXT FIELD lnt06

               #业务人员
               WHEN INFIELD(lnt62)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form="q_gen"
                    LET g_qryparam.default1=g_lnt.lnt62
                    CALL cl_create_qry() RETURNING g_lnt.lnt62
                    DISPLAY BY NAME g_lnt.lnt62
                    CALL i400_lnt62('d')
                    NEXT FIELD lnt62

               #部门
               WHEN INFIELD(lnt63)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form="q_gem"
                    LET g_qryparam.default1=g_lnt.lnt63
                    CALL cl_create_qry() RETURNING g_lnt.lnt63
                    DISPLAY BY NAME g_lnt.lnt63
                    CALL i400_lnt63()
                    NEXT FIELD lnt63                   
               
               #品牌     
               WHEN INFIELD(lnt30)
                    CALL cl_init_qry_var()
                    LET g_qryparam.arg1 = '2'
                    LET g_qryparam.form = "q_tqa"
                    LET g_qryparam.default1=g_lnt.lnt30
                    CALL cl_create_qry() RETURNING g_lnt.lnt30
                    DISPLAY BY NAME g_lnt.lnt30
                    CALL i400_lnt30('d')
                    NEXT FIELD lnt30         
               #税别
               WHEN INFIELD(lnt35)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gec9"
                    LET g_qryparam.default1=g_lnt.lnt35
                    CALL cl_create_qry() RETURNING g_lnt.lnt35
                    DISPLAY BY NAME g_lnt.lnt35
                    CALL i400_lnt35('d')
                    NEXT FIELD lnt35

               #费用项方案
               WHEN INFIELD(lnt71)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_lii01"
                    IF NOT cl_null(g_lnt.lnt06) THEN
                       LET g_qryparam.where = "liiplant = '",g_plant,"' AND liiconf = 'Y' AND lii05 = '",g_lnt.lnt55,"'"
                    ELSE
                       LET g_qryparam.where = "liiplant = '",g_plant,"' AND liiconf = 'Y'"
                    END IF 
                    LET g_qryparam.default1=g_lnt.lnt71
                    CALL cl_create_qry() RETURNING g_lnt.lnt71
                    DISPLAY BY NAME g_lnt.lnt71
                    NEXT FIELD lnt71
           END CASE
        ON ACTION controlg
           CALL cl_cmdask()
           
        AFTER INPUT
    END INPUT
    
END FUNCTION

FUNCTION i400_b3()
DEFINE l_ac3_t         LIKE type_file.num5,
       l_n             LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,
       p_cmd           LIKE type_file.chr1,
       l_allow_insert  LIKE type_file.chr1,
       l_allow_delete  LIKE type_file.chr1


   IF cl_null(g_lnt.lnt01) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF 
   IF g_lnt.lntacti <> 'Y' THEN
      CALL cl_err('','ask-033',0)
      RETURN
   END IF
   IF g_lnt.lnt26 = 'Y' THEN
      CALL cl_err('','alm1265',0)
      RETURN
   END IF
   IF g_lnt.lnt26 = 'A' THEN
      CALL cl_err('','alm1178',0)
      RETURN
   END IF
   IF g_lnt.lnt26 = 'S' THEN
      CALL cl_err('','alm-300',0)
      RETURN
   END IF
   IF g_lnt.lnt26 = 'B' THEN
      CALL cl_err('','alm1179',0)
      RETURN
   END IF
   IF g_lnt.lnt26 = 'F' THEN
      CALL cl_err('','alm1265',0)
      RETURN
   END IF
   IF g_lnt.lnt26 = 'E' THEN
      CALL cl_err('','alm-483',0)
      RETURN
   END IF
   IF s_shut(0) THEN RETURN END IF
   LET g_action_choice = ""
   SELECT * INTO g_lnt.* FROM lnt_file
    WHERE lnt01 = g_lnt.lnt01

   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
   LET g_forupd_sql = "SELECT lnw11,lnw03,'','',lnw08,lnw09,lnw06,lnw02 ",
                      "  FROM lnw_file ",
                      " WHERE lnw01 = '",g_lnt.lnt01,
                      "'  AND lnw11 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i400_bcl_3 CURSOR FROM g_forupd_sql      # LOCK CURSOR
      INPUT ARRAY g_lnw WITHOUT DEFAULTS FROM s_lnw.*
         ATTRIBUTE (COUNT=g_rec_b3,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

         BEFORE INPUT
            IF g_rec_b3 != 0 THEN
               CALL fgl_set_arr_curr(l_ac3)
            END IF

         BEFORE ROW
            LET p_cmd=''
            LET l_ac3 = ARR_CURR()
            LET l_lock_sw = 'N'
            LET l_n  = ARR_COUNT()
            BEGIN WORK
            LET g_success = 'N'
            OPEN i400_cl USING g_lnt.lnt01
            IF STATUS THEN
               CALL cl_err("OPEN i400_cl:", STATUS, 1)
               CLOSE i400_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            FETCH i400_cl INTO g_lnt.*
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_lnt.lnt01,SQLCA.sqlcode,0)
               CLOSE i400_cl
               ROLLBACK WORK
               RETURN
            END IF
            IF g_rec_b3>=l_ac3 THEN
               LET p_cmd='u'
               LET g_before_input_done = FALSE
               CALL i400_set_entry_b3(p_cmd)
               CALL i400_set_no_entry_b3(p_cmd)
               LET g_before_input_done = TRUE
               LET g_lnw_t.* = g_lnw[l_ac3].*
               OPEN i400_bcl_3 USING g_lnw_t.lnw11
               IF STATUS THEN
                  CALL cl_err("OPEN i400_bcl_3:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i400_bcl_3 INTO g_lnw[l_ac3].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_lnw_t.lnw03,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE 
                     CALL i400_lnw03('d')
                  END IF
               END IF
               CALL cl_show_fld_cont()
            END IF

         BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            LET g_before_input_done = FALSE
            CALL i400_set_entry_b3(p_cmd)
            CALL i400_set_no_entry_b3(p_cmd)
            LET g_before_input_done = TRUE
            INITIALIZE g_lnw[l_ac3].* TO NULL
            LET g_lnw[l_ac3].lnw02 = 0
            LET g_lnw_t.* = g_lnw[l_ac3].*
            CALL cl_show_fld_cont()
            NEXT FIELD lnw11

         BEFORE FIELD lnw11
            IF g_lnw[l_ac3].lnw11 IS NULL OR g_lnw[l_ac3].lnw11 = 0 THEN
               SELECT max(lnw11)+1
                 INTO g_lnw[l_ac3].lnw11
                 FROM lnw_file
                WHERE lnw01 = g_lnt.lnt01
               IF g_lnw[l_ac3].lnw11 IS NULL THEN
                  LET g_lnw[l_ac3].lnw11 = 1
               END IF
            END IF

         AFTER FIELD lnw11
            IF NOT cl_null(g_lnw[l_ac3].lnw11) THEN
               IF (g_lnw[l_ac3].lnw11 != g_lnw_t.lnw11
                   AND NOT cl_null(g_lnw[l_ac3].lnw11))
                  OR g_lnw_t.lnw11 IS NULL THEN
                  SELECT count(*)
                    INTO l_n
                    FROM lnw_file
                   WHERE lnw01 = g_lnt.lnt01
                     AND lnw11 = g_lnw[l_ac3].lnw11
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_lnw[l_ac3].lnw11 = g_lnw_t.lnw11
                     NEXT FIELD lnw11
                  END IF
               END IF
            END IF            

           
         AFTER FIELD lnw03 
            IF NOT cl_null(g_lnw[l_ac3].lnw03) THEN
               CALL i400_lnw03(p_cmd)                     
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_lnw[l_ac3].lnw03 = g_lnw_t.lnw03
                  NEXT FIELD lnw03
               END IF 
               CALL i400_chk_lnw03()              #判断同一个费用编号在时间区间是否有交集
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_lnw[l_ac3].lnw03 = g_lnw_t.lnw03
                  NEXT FIELD lnw03
               END IF
            ELSE 
               LET g_lnw[l_ac3].oaj02_2   = NULL
               LET g_lnw[l_ac3].oaj05_2   = NULL
            END IF 
         
        AFTER FIELD lnw08
           IF NOT cl_null(g_lnw[l_ac3].lnw08) THEN
              IF g_lnw[l_ac3].lnw08 > g_lnw[l_ac3].lnw09 THEN
                 LET g_lnw[l_ac3].lnw08 = g_lnw_t.lnw08
                 CALL cl_err(g_lnw[l_ac3].lnw08,'mfg6164',0)
                 NEXT FIELD lnw08
              END IF
              IF g_lnw[l_ac3].lnw08 < g_lnt.lnt21 OR g_lnw[l_ac3].lnw08 > g_lnt.lnt22 THEN
                 LET g_lnw[l_ac3].lnw08 = g_lnw_t.lnw08
                 CALL cl_err(g_lnw[l_ac3].lnw08,'alm-862',0)
                 NEXT FIELD lnw08
              END IF
              CALL i400_chk_lnw03()              #判断同一个费用编号在时间区间是否有交集
              IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_lnw[l_ac3].lnw08 = g_lnw_t.lnw08
                  NEXT FIELD lnw08
              END IF
           END IF 
 
        AFTER FIELD lnw09
           IF NOT cl_null(g_lnw[l_ac3].lnw09) THEN
              IF g_lnw[l_ac3].lnw08 > g_lnw[l_ac3].lnw09 THEN
                 LET g_lnw[l_ac3].lnw09 = g_lnw_t.lnw09
                 CALL cl_err(g_lnw[l_ac3].lnw09,'mfg6164',0)
                 NEXT FIELD lnw09
              END IF
              IF g_lnw[l_ac3].lnw09 < g_lnt.lnt21 OR g_lnw[l_ac3].lnw09 > g_lnt.lnt22 THEN
                 LET g_lnw[l_ac3].lnw09 = g_lnw_t.lnw09
                 CALL cl_err(g_lnw[l_ac3].lnw09,'alm-862',0)
                 NEXT FIELD lnw09
              END IF
              CALL i400_chk_lnw03()              #判断同一个费用编号在时间区间是否有交集
              IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_lnw[l_ac3].lnw09 = g_lnw_t.lnw09
                  NEXT FIELD lnw09
              END IF
           END IF 

         AFTER FIELD lnw06
            IF NOT cl_null(g_lnw[l_ac3].lnw06) THEN
               IF g_lnw[l_ac3].lnw06 < 0 THEN
                   CALL cl_err('','axr-029',0)
                   LET g_lnw[l_ac3].lnw06 = g_lnw_t.lnw06
                   NEXT FIELD lnw06
               END IF 
               LET g_lnw[l_ac3].lnw06 = cl_digcut(g_lnw[l_ac3].lnw06,g_lla04)
            END IF 

         AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CLOSE i400_bcl_3
               CANCEL INSERT
            END IF
            INSERT INTO lnw_file(lnw01,lnw11,lnw03,lnw08,lnw09,lnw06,lnw02,lnw07,lnwplant,lnwlegal)
            VALUES(g_lnt.lnt01,g_lnw[l_ac3].lnw11,g_lnw[l_ac3].lnw03,
                   g_lnw[l_ac3].lnw08,g_lnw[l_ac3].lnw09,g_lnw[l_ac3].lnw06,
                   g_lnw[l_ac3].lnw02,' ',g_plant,g_legal)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","lnw_file",g_lnw[l_ac3].lnw11,"",SQLCA.sqlcode,"","",1)
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b3=g_rec_b3+1
               DISPLAY g_rec_b3 TO FORMONLY.cn2
               COMMIT WORK
            END IF
            
         BEFORE DELETE
            IF g_lnw_t.lnw03 IS NOT NULL THEN

               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               INITIALIZE g_doc.* TO NULL
               LET g_doc.column1 = "lnw03"
               LET g_doc.value1 = g_lnw[l_ac3].lnw03
               CALL cl_del_doc()
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
               #删除对应费用编号的日核算
               DELETE FROM liv_file WHERE liv01 = g_lnt_t.lnt01
                                      AND liv05 = g_lnw_t.lnw03
                                      AND liv08 = '1'
                                      AND liv04 BETWEEN g_lnw_t.lnw08 AND g_lnw_t.lnw09
               DELETE FROM lnw_file WHERE lnw01 = g_lnt_t.lnt01 
                                      AND lnw11 = g_lnw_t.lnw11
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","lnw_file",g_lnw_t.lnw03,"",SQLCA.sqlcode,"","",1)
                  EXIT INPUT
               END IF
               LET g_rec_b3=g_rec_b3-1
               DISPLAY g_rec_b3 TO FORMONLY.cn2
               COMMIT WORK
            END IF

         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_lnw[l_ac3].* = g_lnw_t.*
               CLOSE i400_bcl_3
               ROLLBACK WORK
               EXIT  INPUT 
            END IF

            IF l_lock_sw="Y" THEN
               CALL cl_err(g_lnw[l_ac3].lnw03,-263,0)
               LET g_lnw[l_ac3].* = g_lnw_t.*
            ELSE
               UPDATE lnw_file SET lnw11 = g_lnw[l_ac3].lnw11,
                                   lnw03 = g_lnw[l_ac3].lnw03,
                                   lnw08 = g_lnw[l_ac3].lnw08,
                                   lnw09 = g_lnw[l_ac3].lnw09,
                                   lnw06 = g_lnw[l_ac3].lnw06,
                                   lnw02 = g_lnw[l_ac3].lnw02
                         WHERE lnw01 = g_lnt_t.lnt01
                           AND lnw11 = g_lnw_t.lnw11          

               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","lnw_file",g_lnw_t.lnw03,"",SQLCA.sqlcode,"","",1)
                  LET g_lnw[l_ac3].* = g_lnw_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF

         AFTER ROW
            LET l_ac3 = ARR_CURR()
            LET l_ac3_t = l_ac3

            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
              IF p_cmd = 'a' THEN
                 CALL g_lnw.deleteElement(l_ac3)
              END IF
              IF p_cmd='u' THEN
                 LET g_lnw[l_ac3].* = g_lnw_t.*
              END IF
              CLOSE i400_bcl_3
              ROLLBACK WORK
              EXIT INPUT 
            END IF
            CLOSE i400_bcl_3
            COMMIT WORK

      ON ACTION controlp
         CASE 
            WHEN INFIELD(lnw03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_lij"
               LET g_qryparam.arg1 ="'", g_lnt.lnt71,"'"
               LET g_qryparam.default1 = g_lnw[l_ac3].lnw03
               CALL cl_create_qry() RETURNING g_lnw[l_ac3].lnw03
               CALL i400_lnw03('d')
               NEXT FIELD lnw03
         END CASE               
         
      ON ACTION accept
         ACCEPT INPUT 

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
   END INPUT      
   CLOSE i400_bcl_3
   CALL i400_b3_accounting()    #产生其他费用的日核算
   CALL g_lnw.clear()
   CALL i400_b_fill()
END FUNCTION                    
                   
FUNCTION i400_lnw03(p_cmd)
   DEFINE l_oaj02     LIKE oaj_file.oaj02
   DEFINE l_oaj05     LIKE oaj_file.oaj05
   DEFINE l_oajacti   LIKE oaj_file.oajacti
   DEFINE p_cmd       LIKE type_file.chr1
 
   LET g_errno = ' '
   SELECT oaj02,oaj05,oajacti      
     INTO l_oaj02,l_oaj05,l_oajacti 
     FROM oaj_file
    WHERE oaj01 = g_lnw[l_ac3].lnw03
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'alm-313' #費用明細編號不存在
                                  LET l_oaj02 = NULL
                                  LET l_oaj05 = NULL
        WHEN l_oajacti = 'N'      LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) THEN
      SELECT * FROM lnv_file 
       WHERE lnv01 = g_lnt.lnt01 
         AND lnv04 = g_lnw[l_ac3].lnw03
      IF SQLCA.sqlcode = 0 THEN
         LET g_errno = 'alm-572'  #費用標准中已維護此費用內容,不得重復維護!
      END IF
   END IF 
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
       LET g_lnw[l_ac3].oaj02_2 = l_oaj02
       LET g_lnw[l_ac3].oaj05_2 = l_oaj05
   END IF

END FUNCTION 

FUNCTION i400_chk_lnw03()              #判断同一个费用编号在时间区间是否有交集
   DEFINE l_n   LIKE type_file.num5
   LET g_errno = ''
   IF cl_null(g_lnw[l_ac3].lnw03) THEN
      RETURN
   END IF 
   IF NOT cl_null(g_lnw[l_ac3].lnw08) OR NOT cl_null(g_lnw[l_ac3].lnw09) THEN
      SELECT count(*) INTO l_n
        FROM lnw_file
       WHERE lnw03 = g_lnw[l_ac3].lnw03
         AND lnw01 = g_lnt.lnt01 
         AND lnw11 <> g_lnw[l_ac3].lnw11
         AND (g_lnw[l_ac3].lnw08 BETWEEN lnw08 AND lnw09 
          OR g_lnw[l_ac3].lnw09 BETWEEN lnw08 AND lnw09
          OR lnw08 BETWEEN g_lnw[l_ac3].lnw08 AND g_lnw[l_ac3].lnw09) 
      IF l_n > 0 THEN
         LET g_errno = 'alm1176'
      END IF 
   END IF  
END FUNCTION 

FUNCTION i400_b4() 
DEFINE l_ac4_t         LIKE type_file.num5,
       l_n             LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,
       p_cmd           LIKE type_file.chr1,
       l_allow_insert  LIKE type_file.chr1,
       l_allow_delete  LIKE type_file.chr1
DEFINE l_cnt LIKE type_file.num5    #FUN-C20078 add
DEFINE l_lnr03         LIKE lnr_file.lnr03 #FUN-CA0081 Add

   IF cl_null(g_lnt.lnt01) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
   IF g_lnt.lntacti <> 'Y' THEN
      CALL cl_err(g_lnt.lnt01,'ask-033',0)
      RETURN
   END IF
   IF g_lnt.lnt26 = 'Y' THEN
      CALL cl_err(g_lnt.lnt01,'alm1266',0)
      RETURN
   END IF
   IF g_lnt.lnt26 = 'A' THEN
      CALL cl_err(g_lnt.lnt01,'alm1178',0)
      RETURN
   END IF
   IF g_lnt.lnt26 = 'S' THEN
      CALL cl_err(g_lnt.lnt01,'alm-300',0)
      RETURN
   END IF
   IF g_lnt.lnt26 = 'B' THEN
      CALL cl_err(g_lnt.lnt01,'alm1179',0)
      RETURN
   END IF
   IF g_lnt.lnt26 = 'F' THEN
      CALL cl_err(g_lnt.lnt01,'alm1266',0)
      RETURN
   END IF
   IF g_lnt.lnt26 = 'E' THEN
      CALL cl_err(g_lnt.lnt01,'alm-483',0)
      RETURN
   END IF
   IF s_shut(0) THEN RETURN END IF
   LET g_action_choice = ""
   SELECT * INTO g_lnt.* FROM lnt_file
    WHERE lnt01 = g_lnt.lnt01
   LET l_allow_insert = FALSE 
   LET l_allow_delete = FALSE

   LET g_forupd_sql = "SELECT liu03,liu04,'','',liu05,'',liu06,liu07,liu08  FROM liu_file ",
                      " WHERE liu01 = '",g_lnt.lnt01,
                      "'  AND liu03 = ?  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i400_bcl_4 CURSOR FROM g_forupd_sql      # LOCK CURSOR
      INPUT ARRAY g_liu WITHOUT DEFAULTS FROM s_liu.*
         ATTRIBUTE (COUNT=g_rec_b4,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

         BEFORE INPUT
            IF g_rec_b4 != 0 THEN
               CALL fgl_set_arr_curr(l_ac4)
            END IF

         BEFORE ROW
            LET p_cmd=''
            LET l_ac4 = ARR_CURR()
            LET l_lock_sw = 'N'
            LET l_n  = ARR_COUNT()
            BEGIN WORK
            LET g_success = 'N'
            OPEN i400_cl USING g_lnt.lnt01
            IF STATUS THEN
               CALL cl_err("OPEN i400_cl:", STATUS, 1)
               CLOSE i400_cl
               ROLLBACK WORK
               RETURN
            END IF

            FETCH i400_cl INTO g_lnt.*
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_lnt.lnt01,SQLCA.sqlcode,0)
               CLOSE i400_cl
               ROLLBACK WORK
               RETURN
            END IF
            IF g_rec_b4>=l_ac4 THEN
               LET p_cmd='u'
               LET g_before_input_done = FALSE
               LET g_before_input_done = TRUE
               LET g_liu_t.* = g_liu[l_ac4].*
               OPEN i400_bcl_4 USING g_liu_t.liu03
               IF STATUS THEN
                  CALL cl_err("OPEN i400_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i400_bcl_4 INTO g_liu[l_ac4].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_liu_t.liu03,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE
                     SELECT oaj02 INTO g_liu[l_ac4].oaj02_3 FROM oaj_file
                      WHERE oaj01 = g_liu[l_ac4].liu04
                 
                     SELECT oaj05 INTO g_liu[l_ac4].oaj05_3 FROM oaj_file
                      WHERE oaj01 = g_liu[l_ac4].liu04       
            
                     SELECT lnr02 INTO g_liu[l_ac4].lnr02
                       FROM lnr_file
                      WHERE lnr01 = g_liu[l_ac4].liu05
                  END IF
               END IF
               CALL cl_show_fld_cont()
            END IF

         AFTER FIELD liu05
            IF NOT cl_null(g_liu[l_ac4].liu05) THEN
               CALL i400_liu05_1()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('liu05:',g_errno,0)
                  LET g_liu[l_ac4].liu05 = g_liu_t.liu05
                  NEXT FIELD liu05
               END IF
               CALL i400_liu05(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_liu[l_ac4].liu05 = g_liu_t.liu05
                  NEXT FIELD liu05
               END IF 
            END IF 
           #FUN-CA0081 Add Begin ---
            IF NOT cl_null(g_liu[l_ac4].liu06) AND NOT cl_null(g_liu[l_ac4].liu05) THEN
               CALL i400_chk_liu06()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_liu[l_ac4].liu05 = g_liu_t.liu05
                  NEXT FIELD liu05
               END IF
            END IF
           #FUN-CA0081 Add End -----

#FUN-C20078 add begin ---
         AFTER FIELD liu06
           #FUN-CA0081 Mark&Add Begin ---
           #IF g_liu[l_ac4].liu06 <= 0 THEN
           #   SELECT COUNT(*) INTO l_cnt
           #     FROM lil_file
           #    WHERE lil00 = '2'
           #      AND lil01 IN (SELECT lnv18
           #                      FROM lnv_file,liu_file
           #                     WHERE lnv01 = liu01
           #                       AND lnv04 = g_liu[l_ac4].liu04 
           #                       AND liu01 = g_lnt.lnt01)
   
           #   IF l_cnt > 0 THEN
           #      CALL cl_err('','alm1583',0)
           #      LET g_liu[l_ac4].liu06 = g_liu_t.liu06
           #      NEXT FIELD liu06
           #   END IF        
           #   SELECT COUNT(*) INTO l_cnt
           #     FROM lip_file 
           #    WHERE lip04 = '2'
           #      AND lip01 IN (SELECT lnv18
           #                      FROM lnv_file,liu_file
           #                     WHERE lnv01 = liu01 
           #                       AND lnv04 = g_liu[l_ac4].liu04 
           #                       AND liu01 = g_lnt.lnt01)               
           #   IF l_cnt > 0 THEN  
           #      CALL cl_err('','alm1583',0)
           #      LET g_liu[l_ac4].liu06 = g_liu_t.liu06
           #      NEXT FIELD liu06 
           #   END IF  
           #END IF 
            IF NOT cl_null(g_liu[l_ac4].liu06) AND NOT cl_null(g_liu[l_ac4].liu05) THEN
               CALL i400_chk_liu06()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_liu[l_ac4].liu06 = g_liu_t.liu06
                  NEXT FIELD liu06
               END IF
            END IF
           #FUN-CA0081 Mark&Add End -----
#FUN-C20078 add end   ---

         AFTER FIELD liu08
            IF NOT cl_null(g_liu[l_ac4].liu08) THEN
               CALL i400_liu05_1()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('liu08:',g_errno,0)
                  LET g_liu[l_ac4].liu08 = g_liu_t.liu08
                  NEXT FIELD liu08
               END IF
            END IF 
         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_liu[l_ac4].* = g_liu_t.*
               CLOSE i400_bcl_4
               ROLLBACK WORK
               EXIT INPUT 
            END IF

            IF l_lock_sw="Y" THEN
               CALL cl_err(g_liu[l_ac4].liu03,-263,0)
               LET g_liu[l_ac4].* = g_liu_t.*
            ELSE
               UPDATE liu_file SET liu03 = g_liu[l_ac4].liu03,
                                   liu04 = g_liu[l_ac4].liu04,
                                   liu05 = g_liu[l_ac4].liu05,
                                   liu06 = g_liu[l_ac4].liu06,
                                   liu07 = g_liu[l_ac4].liu07,
                                   liu08 = g_liu[l_ac4].liu08
                             WHERE liu01 = g_lnt_t.lnt01
                               AND liu03 = g_liu_t.liu03       
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","liu_file",g_liu_t.liu03,"",SQLCA.sqlcode,"","",1)
                  LET g_liu[l_ac4].* = g_liu_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF

         AFTER ROW
            LET l_ac4 = ARR_CURR()       
           #LET l_ac4_t = l_ac4        #FUN-D30033 

            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_liu[l_ac4].* = g_liu_t.*
               #FUN-D30033----add--str
               ELSE
                  CALL g_liu.deleteElement(l_ac4)
                  IF g_rec_b4 != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac4 = l_ac4_t
                  END IF
               #FUN-D30033---add--end
               END IF
               CLOSE i400_bcl_4
               ROLLBACK WORK
               EXIT INPUT 
            END IF
            LET l_ac4_t = l_ac4        #FUN-D30033
            CLOSE i400_bcl_4
            COMMIT WORK

      ON ACTION controlp
         CASE 
            WHEN INFIELD(liu05)
               CALL cl_init_qry_var()
               LET g_qryparam.form="q_lnr"
               LET g_qryparam.default1=g_liu[l_ac4].liu05
               CALL cl_create_qry() RETURNING g_liu[l_ac4].liu05
               CALL i400_liu05('d')
               NEXT FIELD liu05 

         END CASE 

#FUN-C20078 add begin ---
      AFTER INPUT 
         IF l_ac4 > 0 THEN
           #FUN-CA0081 Mark&Add Begin ---
           #SELECT COUNT(*) INTO l_cnt 
           #  FROM lil_file 
           # WHERE lil00 = '2' 
           #   AND lil01 IN (SELECT lnv18 
           #                   FROM lnv_file,liu_file 
           #                  WHERE lnv01 = liu01 
           #                    AND lnv04 = liu04
           #                    AND liu01 = g_lnt.lnt01 
           #                    AND liu06 <= 0 )            

           #IF l_cnt > 0 THEN
           #   CALL cl_err('','alm1583',0)
           #   NEXT FIELD liu06
           #END IF 
           #SELECT COUNT(*) INTO l_cnt 
           #  FROM lip_file 
           # WHERE lip04 = '2' 
           #   AND lip01 IN (SELECT lnv18 
           #                   FROM lnv_file,liu_file 
           #                  WHERE lnv01 = liu01 
           #                    AND lnv04 = liu04
           #                    AND liu01 = g_lnt.lnt01 
           #                    AND liu06 <= 0 )
           #IF l_cnt > 0 THEN
           #   CALL cl_err('','alm1583',0)
           #   NEXT FIELD liu06
           #END IF  
            IF NOT cl_null(g_liu[l_ac4].liu06) AND NOT cl_null(g_liu[l_ac4].liu05) THEN
               CALL i400_chk_liu06()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_liu[l_ac4].liu06 = g_liu_t.liu06
                  NEXT FIELD liu06
               END IF 
            END IF
           #FUN-CA0081 Mark&Add End -----
         END IF 
#FUN-C20078 add end -----      

      ON ACTION accept
         ACCEPT INPUT 

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
   END INPUT      
   CLOSE i400_bcl_4
END FUNCTION      

FUNCTION i400_liu05(p_cmd)
   DEFINE p_cmd           LIKE type_file.chr1 
   DEFINE l_lnr02         LIKE lnr_file.lnr02
   DEFINE l_lnr04         LIKE lnr_file.lnr04
   LET g_errno = ''
   SELECT lnr02,lnr04 INTO l_lnr02,l_lnr04 
     FROM lnr_file
    WHERE lnr01 = g_liu[l_ac4].liu05
   CASE
      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'alm1066'                #此付款方式编号不存在
                               LET l_lnr02 = ''
      WHEN l_lnr04 <> 'Y'      LET g_errno = 'alm1175'                #此付款方式编号无效
                               LET l_lnr02 = ''
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE   
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_liu[l_ac4].lnr02 = l_lnr02 
   END IF 
END FUNCTION 

FUNCTION i400_liu05_1()
   DEFINE l_lnr03    LIKE lnr_file.lnr03

   LET g_errno = ' '
   SELECT lnr03 INTO l_lnr03
     FROM lnr_file WHERE g_liu[l_ac4].liu05 = lnr01

   IF g_liu[l_ac4].liu08 = '1' AND l_lnr03 > 0 THEN
      LET g_errno = 'alm1074'
   END IF
END FUNCTION

FUNCTION i400_b6()
DEFINE l_ac6_t         LIKE type_file.num5,
       l_n             LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,
       p_cmd           LIKE type_file.chr1,
       l_allow_insert  LIKE type_file.chr1,
       l_allow_delete  LIKE type_file.chr1
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_lnt.lnt01) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
   IF g_lnt.lntacti <> 'Y' THEN
      CALL cl_err('','ask-033',0)
      RETURN
   END IF
   IF g_lnt.lnt26 = 'Y' THEN
      CALL cl_err('','alm1267',0)
      RETURN
   END IF
   IF g_lnt.lnt26 = 'A' THEN
      CALL cl_err('','alm1178',0)
      RETURN
   END IF
   IF g_lnt.lnt26 = 'S' THEN
      CALL cl_err('','alm-300',0)
      RETURN
   END IF
   IF g_lnt.lnt26 = 'B' THEN
      CALL cl_err('','alm1179',0)
      RETURN
   END IF
   IF g_lnt.lnt26 = 'F' THEN
      CALL cl_err('','alm1267',0)
      RETURN
   END IF
   IF g_lnt.lnt26 = 'E' THEN
      CALL cl_err('','alm-483',0)
      RETURN
   END IF
   LET g_action_choice = ""
   SELECT * INTO g_lnt.* FROM lnt_file
    WHERE lnt01 = g_lnt.lnt01
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
   LET g_forupd_sql = "SELECT lny04,lny03,'',lny02 ",
                      "  FROM lny_file", 
                      " WHERE lny01 = '",g_lnt.lnt01,
                      "'  AND lny04 = ?  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i400_bcl_6 CURSOR FROM g_forupd_sql      # LOCK CURSOR   
      INPUT ARRAY g_lny WITHOUT DEFAULTS FROM s_lny.* 
         ATTRIBUTE (COUNT=g_rec_b6,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
         BEFORE INPUT
            IF g_rec_b6 != 0 THEN
               CALL fgl_set_arr_curr(l_ac6)
            END IF
         BEFORE ROW
            LET p_cmd=''
            LET l_ac6 = ARR_CURR()
            LET l_lock_sw = 'N'
            LET l_n  = ARR_COUNT()
            BEGIN WORK
            LET g_success = 'N'
            OPEN i400_cl USING g_lnt.lnt01
            IF STATUS THEN
               CALL cl_err("OPEN i400_cl:", STATUS, 1)
               CLOSE i400_cl
               ROLLBACK WORK
               RETURN
            END IF

            FETCH i400_cl INTO g_lnt.*
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_lnt.lnt01,SQLCA.sqlcode,0)
               CLOSE i400_cl
               ROLLBACK WORK
               RETURN
            END IF
            IF g_rec_b6>=l_ac6 THEN
               LET p_cmd='u'
               LET g_before_input_done = FALSE
               LET g_before_input_done = TRUE
               LET g_lny_t.* = g_lny[l_ac6].*
               OPEN i400_bcl_6 USING g_lny_t.lny04
               IF STATUS THEN
                  CALL cl_err("OPEN i400_bcl_6:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i400_bcl_6 INTO g_lny[l_ac6].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_lny_t.lny04,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE
                     SELECT tqa02 INTO g_lny[l_ac6].tqa02_2
                       FROM tqa_file
                      WHERE tqa01 = g_lny[l_ac6].lny03
                        AND tqa03 = '2'
                  END IF
               END IF
               CALL cl_show_fld_cont()
            END IF

         BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            LET g_before_input_done = FALSE
            LET g_before_input_done = TRUE
            INITIALIZE g_lny[l_ac6].* TO NULL
            LET g_lny[l_ac6].lny02 = g_lnt.lnt02
            LET g_lny_t.* = g_lny[l_ac6].*
            CALL cl_show_fld_cont()
            NEXT FIELD lny04

         BEFORE FIELD lny04
            IF g_lny[l_ac6].lny04 IS NULL OR g_lny[l_ac6].lny04 = 0 THEN
               SELECT max(lny04)+1
                 INTO g_lny[l_ac6].lny04
                 FROM lny_file
                WHERE lny01 = g_lnt.lnt01
               IF g_lny[l_ac6].lny04 IS NULL THEN
                  LET g_lny[l_ac6].lny04 = 1
               END IF
            END IF

         AFTER FIELD lny04
            IF NOT cl_null(g_lny[l_ac6].lny04) THEN
               IF (g_lny[l_ac6].lny04 != g_lny_t.lny04
                   AND NOT cl_null(g_lny[l_ac6].lny04))
                  OR g_lny_t.lny04 IS NULL THEN
                  SELECT count(*)
                    INTO l_n
                    FROM lny_file
                   WHERE lny01 = g_lnt.lnt01
                     AND lny04 = g_lny[l_ac6].lny04
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_lny[l_ac6].lny04 = g_lny_t.lny04
                     NEXT FIELD lny04
                  END IF
               END IF
            END IF 
            
         AFTER FIELD lny03
            IF NOT cl_null(g_lny[l_ac6].lny03) THEN
                CALL i400_lny03(p_cmd)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   LET g_lny[l_ac6].lny03 = g_lny_t.lny03
                   NEXT FIELD lny03
                END IF 
            END IF 

         AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CLOSE i400_bcl_6
               CANCEL INSERT
            END IF
            INSERT INTO lny_file(lny01,lny04,lny03,lny02,lnylegal,lnyplant)
            VALUES(g_lnt.lnt01,g_lny[l_ac6].lny04,g_lny[l_ac6].lny03,
                   g_lny[l_ac6].lny02,g_legal,g_plant)

            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","lny_file",g_lny[l_ac6].lny04,"",SQLCA.sqlcode,"","",1)
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b6=g_rec_b6+1
               DISPLAY g_rec_b6 TO FORMONLY.cn2
               COMMIT WORK
            END IF

         BEFORE DELETE
            IF g_lny_t.lny04 IS NOT NULL THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               INITIALIZE g_doc.* TO NULL
               LET g_doc.column1 = "lny04"
               LET g_doc.value1 = g_lny[l_ac6].lny04
               CALL cl_del_doc()
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
               DELETE FROM lny_file WHERE lny01 = g_lnt_t.lnt01
                                      AND lny04 = g_lny_t.lny04

               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","lny_file",g_lny_t.lny04,"",SQLCA.sqlcode,"","",1)
                  EXIT INPUT 
               END IF
               LET g_rec_b6=g_rec_b6-1
               DISPLAY g_rec_b6 TO FORMONLY.cn2
               COMMIT WORK
            END IF

         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_lny[l_ac6].* = g_lny_t.*
               CLOSE i400_bcl_6
               ROLLBACK WORK
               EXIT INPUT  
            END IF

            IF l_lock_sw="Y" THEN
               CALL cl_err(g_lny[l_ac6].lny02,-263,0)
               LET g_lny[l_ac6].* = g_lny_t.*
            ELSE
               UPDATE lny_file SET lny04 = g_lny[l_ac6].lny04,
                                   lny03 = g_lny[l_ac6].lny03,
                                   lny02 = g_lny[l_ac6].lny02
                             WHERE lny01 = g_lnt_t.lnt01
                               AND lny04 = g_lny_t.lny04    

               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","lny_file",g_lny_t.lny04,"",SQLCA.sqlcode,"","",1)
                  LET g_lny[l_ac6].* = g_lny_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF

         AFTER ROW
            LET l_ac6 = ARR_CURR()
           #LET l_ac6_t = l_ac6         #FUN-D30033

            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_lny[l_ac6].* = g_lny_t.*
               #FUN-D30033----add--str
            ELSE
               CALL g_lny.deleteElement(l_ac6)
               IF g_rec_b6 != 0 THEN
                  LET g_action_choice = "detail"
               END IF
            #FUN-D30033---add--end
               END IF
               CLOSE i400_bcl_6
               ROLLBACK WORK
               EXIT INPUT 
            END IF
            LET l_ac6_t = l_ac6         #FUN-D30033
            CLOSE i400_bcl_6
            COMMIT WORK

       ON ACTION controlp
          CASE
             WHEN INFIELD(lny03)
                CALL cl_init_qry_var()
                LET g_qryparam.arg1 = '2'
                LET g_qryparam.form = "q_tqa"
                LET g_qryparam.default1 = g_lny[l_ac6].lny03
                CALL cl_create_qry() RETURNING g_lny[l_ac6].lny03
                CALL i400_lny03('d')
                NEXT FIELD lny03
          END CASE

      ON ACTION accept
         ACCEPT INPUT 

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
   END INPUT      
   CLOSE i400_bcl_6
END FUNCTION
   
FUNCTION i400_lny03(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_tqa02   LIKE tqa_file.tqa02
   DEFINE l_tqaacti LIKE tqa_file.tqaacti
   LET g_errno = ''
   SELECT tqa02,tqaacti INTO l_tqa02,l_tqaacti
     FROM tqa_file 
    WHERE tqa01 = g_lny[l_ac6].lny03
      AND tqa03 = '2'
   CASE 
      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'alm-796'                #此品牌编号不存在 
      WHEN l_tqaacti <> 'Y'    LET g_errno = 'alm-793'                #此品牌编号无效
                               LET l_tqa02 = ''
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'       
   END CASE 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_lny[l_ac6].tqa02_2 = l_tqa02
   END IF 
END FUNCTION 
 
FUNCTION i400_u()
   DEFINE l_lnt06_t    LIKE lnt_file.lnt06
   DEFINE t_lnt        RECORD LIKE lnt_file.*
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lnt.lnt01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   
   IF g_rec_b > 0 OR g_rec_b2 > 0 OR g_rec_b3 > 0 OR g_rec_b4 > 0  THEN
      CALL cl_err('','alm1177',0)                 #如果单身的标准费用、优惠标准、其他费用标准、定义付款已有资料，则不可修改
      RETURN
   END IF   
   SELECT * INTO g_lnt.* FROM lnt_file
    WHERE lnt01=g_lnt.lnt01
   IF g_lnt.lntplant <> g_plant THEN            
      CALL cl_err(g_lnt.lntplant,'alm-399',0)  
      RETURN
   END IF
   IF g_lnt.lntacti <> 'Y' THEN
      CALL cl_err('','ask-033',0)
      RETURN
   END IF
   IF g_lnt.lnt26 = 'A' THEN
      CALL cl_err('','alm1178',0)
      RETURN
   END IF
   IF g_lnt.lnt26 = 'B' THEN
      CALL cl_err('','alm1179',0)
      RETURN
   END IF
   #合同已審核
   IF g_lnt.lnt26 MATCHES '[YF]' THEN
      CALL cl_err(g_lnt.lnt01,'aap-005',0)
      RETURN
   END IF
   #合同終止
   IF g_lnt.lnt26 = 'S' THEN
      CALL cl_err(g_lnt.lnt01,'alm-300',0)
      RETURN
   END IF
   #合同到期
   IF g_lnt.lnt26 = 'E' THEN
      CALL cl_err(g_lnt.lnt01,'alm-483',0)
      RETURN
   END IF

   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_lnt_t.lnt01 = g_lnt.lnt01
   LET l_lnt06_t = g_lnt.lnt06

   BEGIN WORK
   LET g_success = 'Y'
   OPEN i400_cl USING g_lnt.lnt01
   IF STATUS THEN
      CALL cl_err("OPEN i400_cl:", STATUS, 1)
      CLOSE i400_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i400_cl INTO g_lnt.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lnt.lnt01,SQLCA.sqlcode,0)
      CLOSE i400_cl
      ROLLBACK WORK
      RETURN
   END IF
   CALL i400_show()
   WHILE TRUE
      LET g_lnt_t.lnt01 = g_lnt.lnt01
      LET g_lnt.lntmodu=g_user
      LET g_lnt.lntdate=g_today
      CALL i400_i("u")
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_lnt.*=g_lnt_t.*

         CALL i400_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
  
      IF g_lnt.lnt01 != g_lnt_t.lnt01 THEN
         UPDATE lnu_file SET lnu01 = g_lnt.lnt01
          WHERE lnu01 = g_lnt_t.lnt01
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            LET g_success = 'N'
            CALL cl_err3("upd","lnu_file",g_lnt_t.lnt01,'',SQLCA.sqlcode,"","lnu",1)
            CONTINUE WHILE
         END IF
      END IF
      
      UPDATE lnt_file SET lnt_file.* = g_lnt.*
       WHERE lnt01 = g_lnt_t.lnt01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         LET g_success = 'N'
         CALL cl_err3("upd","lnt_file",g_lnt_t.lnt01,'',SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      IF g_lnt.lnt06 <> l_lnt06_t THEN
         DELETE FROM lnu_file WHERE lnu01 = g_lnt_t.lnt01            
                                AND lnuplant = g_plant
                                AND lnulegal = g_legal
         CALL g_lnu.clear()
         CALL i400_ins_lnu()       #重取场地
      END IF
      UPDATE lnt_file SET lntpos = g_lnt.lntpos
       WHERE lnt01 = g_lnt.lnt01
      DISPLAY BY NAME g_lnt.lntpos
      EXIT WHILE
   END WHILE
    
   CLOSE i400_cl
   IF g_success = 'N' THEN
      ROLLBACK WORK
   ELSE
      COMMIT WORK
   END IF
   CALL cl_flow_notify(g_lnt.lnt01,'U')
 
   CALL i400_b_fill()
END FUNCTION 

FUNCTION i400_show()
    LET g_lnt_t.* = g_lnt.*
    #商户资料
    SELECT * INTO g_lne.*
      FROM lne_file
     WHERE lne01=g_lnt.lnt04
    #主品牌
    DISPLAY BY NAME g_lnt.lntplant,g_lnt.lntlegal,g_lnt.lnt01,g_lnt.lnt02,g_lnt.lnt03,g_lnt.lnt04,
                    g_lnt.lnt06,g_lnt.lnt55,g_lnt.lnt56,g_lnt.lnt16,g_lnt.lnt57,g_lnt.lnt54,
                    g_lnt.lnt45,g_lnt.lnt58,g_lnt.lnt59,g_lnt.lnt08,g_lnt.lnt09,g_lnt.lnt60,
                    g_lnt.lnt11,g_lnt.lnt61,g_lnt.lnt10,g_lnt.lnt17,g_lnt.lnt18,g_lnt.lnt51,
                    g_lnt.lnt21,g_lnt.lnt22,g_lnt.lnt62,g_lnt.lnt63,g_lnt.lnt64,g_lnt.lnt65,
                    g_lnt.lnt66,g_lnt.lnt67,g_lnt.lnt68,g_lnt.lnt69,g_lnt.lnt48,g_lnt.lnt26,
                    g_lnt.lnt27,g_lnt.lnt28,g_lnt.lnt47,g_lnt.lnt46,g_lnt.lnt29,g_lne.lne14,
                    g_lne.lne15,g_lne.lne43,g_lne.lne44,g_lne.lne22,g_lne.lne50,g_lne.lne51,
                    g_lne.lne52,g_lne.lne53,g_lnt.lnt30,g_lnt.lnt31,g_lnt.lnt32,g_lnt.lnt33,
                    g_lnt.lnt35,g_lnt.lnt36,g_lnt.lnt37,g_lnt.lnt70,g_lnt.lnt71,g_lnt.lnt72,
                    g_lnt.lntpos,g_lnt.lntuser,g_lnt.lntgrup,g_lnt.lntoriu,g_lnt.lntmodu,
                    g_lnt.lntdate,g_lnt.lntorig,g_lnt.lntacti,g_lnt.lntcrat
    
    CALL i400_desc()
    CALL cl_set_field_pic(g_lnt.lnt26,"","","","","") 
    CALL i400_b_fill()
END FUNCTION

FUNCTION i400_b_fill()
     
     #查询单身一的SQL
     LET g_sql="SELECT lnv03,lnv04,'','',lnv18,lnv181,lnv16,lnv17,lnv07,lnv02,lnv14 FROM lnv_file WHERE lnv01=? AND ",g_wc2,
               " ORDER BY lnv03"
     PREPARE i400_lnv_pre FROM g_sql
     DECLARE i400_lnv_cur CURSOR FOR i400_lnv_pre
     
     #查询单身二的SQL      
     LET g_sql="SELECT lit03,lit04,'','',lit05,lit06,lit07,lit08,lit02 FROM lit_file WHERE lit01=? AND ",g_wc3,
               " ORDER BY lit03"
     PREPARE i400_lit_pre FROM g_sql
     DECLARE i400_lit_cur CURSOR FOR i400_lit_pre
     
     #查询单身三的SQL      
     LET g_sql="SELECT lnw11,lnw03,'','',lnw08,lnw09,lnw06,lnw02 FROM lnw_file WHERE lnw01=?  AND ",g_wc4,
               " ORDER BY lnw11"
     PREPARE i400_lnw_pre FROM g_sql
     DECLARE i400_lnw_cur CURSOR FOR i400_lnw_pre
     
     #查询单身四的SQL      
     LET g_sql="SELECT liu03,liu04,'','',liu05,'',liu06,liu07,liu08 FROM liu_file WHERE liu01=? AND ",g_wc5,
               " ORDER BY liu03"
     PREPARE i400_liu_pre FROM g_sql
     DECLARE i400_liu_cur CURSOR FOR i400_liu_pre

     #查询单身五的SQL 
     LET g_sql="SELECT lnu06,lnu03,lnu05,lnu07,lnu04,lnu08,'',lnu09,'',lnu10,'',lnu02 FROM lnu_file WHERE lnu01 = ? AND ",g_wc6,
               " ORDER BY lnu06" 
     PREPARE i400_lnu_pre FROM g_sql
     DECLARE i400_lnu_cur CURSOR FOR i400_lnu_pre

     #查询单身六的SQL
     LET g_sql="SELECT lny04,lny03,'',lny02 FROM lny_file WHERE lny01 = ? AND ",g_wc7,
               " ORDER BY lny04" 
     PREPARE i400_lny_pre FROM g_sql
     DECLARE i400_lny_cur CURSOR FOR i400_lny_pre
     
     LET g_cnt=1
     FOREACH i400_lnv_cur USING g_lnt.lnt01 INTO g_lnv[g_cnt].* 
         SELECT oaj02 INTO g_lnv[g_cnt].oaj02 FROM oaj_file
          WHERE oaj01 = g_lnv[g_cnt].lnv04

         SELECT oaj05 INTO g_lnv[g_cnt].oaj05 FROM oaj_file
          WHERE oaj01 = g_lnv[g_cnt].lnv04      

         LET g_cnt=g_cnt+1
     END FOREACH
     LET g_rec_b=g_cnt-1
     CALL g_lnv.deleteElement(g_cnt)
     
     LET g_cnt=1
     FOREACH i400_lit_cur USING g_lnt.lnt01 INTO g_lit[g_cnt].* 
         SELECT oaj02 INTO g_lit[g_cnt].oaj02_1 FROM oaj_file
          WHERE oaj01 = g_lit[g_cnt].lit04

         SELECT oaj05 INTO g_lit[g_cnt].oaj05_1 FROM oaj_file
          WHERE oaj01 = g_lit[g_cnt].lit04 
         LET g_cnt=g_cnt+1
     END FOREACH
     LET g_rec_b2=g_cnt-1
     CALL g_lit.deleteElement(g_cnt)
     
     LET g_cnt=1
     FOREACH i400_lnw_cur USING g_lnt.lnt01 INTO g_lnw[g_cnt].* 
         SELECT oaj02 INTO g_lnw[g_cnt].oaj02_2 FROM oaj_file
          WHERE oaj01 = g_lnw[g_cnt].lnw03

         SELECT oaj05 INTO g_lnw[g_cnt].oaj05_2 FROM oaj_file
          WHERE oaj01 = g_lnw[g_cnt].lnw03         
         
         LET g_cnt=g_cnt+1
     END FOREACH
     LET g_rec_b3=g_cnt-1
     CALL g_lnw.deleteElement(g_cnt)
     
     LET g_cnt=1
     FOREACH i400_liu_cur USING g_lnt.lnt01 INTO g_liu[g_cnt].* 
         SELECT oaj02 INTO g_liu[g_cnt].oaj02_3 FROM oaj_file
          WHERE oaj01 = g_liu[g_cnt].liu04

         SELECT oaj05 INTO g_liu[g_cnt].oaj05_3 FROM oaj_file
          WHERE oaj01 = g_liu[g_cnt].liu04       
  
         SELECT lnr02 INTO g_liu[g_cnt].lnr02
           FROM lnr_file
          WHERE lnr01 = g_liu[g_cnt].liu05
         LET g_cnt=g_cnt+1
     END FOREACH
     LET g_rec_b4=g_cnt-1
     CALL g_liu.deleteElement(g_cnt)

     LET g_cnt=1
     FOREACH i400_lnu_cur USING g_lnt.lnt01 INTO g_lnu[g_cnt].* 
         SELECT lmb03 INTO g_lnu[g_cnt].lmb03_1
           FROM lmb_file
          WHERE lmb02 = g_lnu[g_cnt].lnu08

         SELECT lmc04 INTO g_lnu[g_cnt].lmc04_1
           FROM lmc_file
          WHERE lmc03 = g_lnu[g_cnt].lnu09
  
         SELECT lmy04 INTO g_lnu[g_cnt].lmy04_1
           FROM lmy_file
          WHERE lmy03 = g_lnu[g_cnt].lnu10          
         LET g_cnt=g_cnt+1
     END FOREACH
     LET g_rec_b5=g_cnt-1
     CALL g_lnu.deleteElement(g_cnt)

     LET g_cnt=1
     FOREACH i400_lny_cur USING g_lnt.lnt01 INTO g_lny[g_cnt].* 
         SELECT tqa02 INTO g_lny[g_cnt].tqa02_2
           FROM tqa_file
          WHERE tqa01 = g_lny[g_cnt].lny03          
            AND tqa03 = '2'
         LET g_cnt=g_cnt+1
     END FOREACH
     LET g_rec_b6=g_cnt-1
     CALL g_lny.deleteElement(g_cnt)
     
END FUNCTION

FUNCTION i400_x()

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_lnt.lnt01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF

   IF g_lnt.lnt26 MATCHES '[YFAB]' THEN
      CALL cl_err('','alm1061',0)
      RETURN
   END IF
   BEGIN WORK
   IF g_lnt.lnt26='S' THEN
      CALL cl_err('','alm-931',0)
      RETURN
   END IF

   OPEN i400_cl USING g_lnt.lnt01
   IF STATUS THEN
      CALL cl_err("OPEN i400_cl:", STATUS, 1)
      CLOSE i400_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i400_cl INTO g_lnt.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lnt.lnt01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF

   LET g_success = 'Y'

   CALL i400_show()

   IF cl_exp(0,0,g_lnt.lntacti) THEN
      IF g_lnt.lntacti='Y' THEN
         LET g_lnt.lntacti='N'
      ELSE
         LET g_lnt.lntacti='Y'
      END IF

      UPDATE lnt_file SET lntacti=g_lnt.lntacti,
                          lntmodu=g_user,
                          lntdate=g_today
       WHERE lnt01=g_lnt.lnt01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","lnt_file",g_lnt.lnt01,"",SQLCA.sqlcode,"","",1)
      END IF
   END IF

   CLOSE i400_cl

   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_lnt.lnt01,'V')
   ELSE
      ROLLBACK WORK
   END IF

   SELECT lntacti,lntmodu,lntdate
   INTO g_lnt.lntacti,g_lnt.lntmodu,
        g_lnt.lntdate FROM lnt_file
   WHERE lnt01=g_lnt.lnt01
   DISPLAY BY NAME g_lnt.lntacti,g_lnt.lntmodu,
                   g_lnt.lntdate

END FUNCTION

FUNCTION i400_r()
  DEFINE l_str       string 
  
  IF cl_null(g_lnt.lnt01) THEN
     CALL cl_err('请选择资料','!',0)
     RETURN
  END IF
  
  IF NOT cl_null(g_lnt.lnt26) AND g_lnt.lnt26 !='N' THEN
     CALL cl_err('合同已有审批状态，不能删除资料','!',0)
     RETURN
  END IF
  
  IF g_lnt.lntacti <> 'Y' THEN
     CALL cl_err('','ask-033',0)
     RETURN
  END IF
  SELECT * INTO g_lnt.* FROM lnt_file
   WHERE lnt01=g_lnt.lnt01

  BEGIN WORK

  OPEN i400_cl USING g_lnt.lnt01
  IF STATUS THEN
     CALL cl_err("OPEN i400_cl:", STATUS, 1)
     CLOSE i400_cl
     ROLLBACK WORK
     RETURN
  END IF

  FETCH i400_cl INTO g_lnt.*
  IF SQLCA.sqlcode THEN
     CALL cl_err(g_lnt.lnt01,SQLCA.sqlcode,0)
     ROLLBACK WORK
     RETURN
  END IF
  IF NOT cl_delh(0,0) THEN
     RETURN
  END IF
  CLEAR FORM
  CALL g_lnv.clear()
  CALL g_lit.clear()
  CALL g_lnw.clear()
  CALL g_liu.clear()
  CALL g_lnu.clear()
  CALL g_lny.clear()
  
  BEGIN WORK
  #删除合同单头
  DELETE FROM lnt_file WHERE lnt01=g_lnt.lnt01 
  #删除场地
  DELETE FROM lnu_file WHERE lnu01=g_lnt.lnt01 
  #删除标准费用
  DELETE FROM lnv_file WHERE lnv01=g_lnt.lnt01
  #删除优惠
  DELETE FROM lit_file WHERE lit01=g_lnt.lnt01
  #删除其他费用
  DELETE FROM lnw_file WHERE lnw01=g_lnt.lnt01 
  #删除定义付款
  DELETE FROM liu_file WHERE liu01=g_lnt.lnt01 
  #删除其他品牌
  DELETE FROM lny_file WHERE lny01=g_lnt.lnt01 
  #删除对应日核算
  DELETE FROM liv_file WHERE liv01 = g_lnt.lnt01
  #删除对应账单
  DELETE FROM liw_file WHERE liw01 = g_lnt.lnt01
  
  OPEN i400_count
  FETCH i400_count INTO g_row_count
  DISPLAY g_row_count TO cnt
  
  OPEN i400_cur
  IF g_curs_index = g_row_count + 1 THEN
     LET g_jump = g_row_count
     CALL i400_fetch('L')
  ELSE
     LET g_jump = g_curs_index
     LET g_no_ask = TRUE
     CALL i400_fetch('/')
  END IF
  DISPLAY g_curs_index TO idx
  MESSAGE '删除成功!'
  COMMIT WORK
END FUNCTION

#商户编号控管
FUNCTION i400_lnt04(p_cmd)  
DEFINE l_lne36   LIKE lne_file.lne36   #确认码
DEFINE l_lnh07   LIKE lnh_file.lnh07   #商户状态
DEFINE l_lih14   LIKE lih_file.lih14
DEFINE p_cmd     LIKE type_file.chr1
DEFINE l_tqa02_1 LIKE tqa_file.tqa02
   LET g_errno = ''
   SELECT * INTO g_lne.*
     FROM lne_file
    WHERE lne01=g_lnt.lnt04
   CASE 
      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'alm-a01'         #此商户编号不存在   
      WHEN g_lne.lne36 <> 'Y'  LET g_errno = 'alm-997'         #此商户编号未审核
                               INITIALIZE g_lne.* TO NULL
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) THEN
      SELECT lnh07 INTO l_lnh07 
        FROM lnh_file
       WHERE lnh01 = g_lnt.lnt04
         AND lnhstore = g_plant
      CASE
         WHEN SQLCA.SQLCODE = 100 LET g_errno = 'alm-318'         #该商户在此门店中无签约状况 
         WHEN l_lnh07 <> '1'      LET g_errno = 'alm1043'         #此商户状态不可签约
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
      END CASE      
   END IF 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      #商户名称
      SELECT lne05 INTO g_lne05 FROM lne_file
       WHERE lne01 = g_lnt.lnt04
       DISPLAY g_lne05 TO lne05        
   END IF 
   IF cl_null(g_errno) AND p_cmd <> 'd' THEN
      #显示商户资料
       DISPLAY BY NAME g_lne.lne14,g_lne.lne15,g_lne.lne43,
                       g_lne.lne44,g_lne.lne22,g_lne.lne50,
                       g_lne.lne51,g_lne.lne52,g_lne.lne53
      #税别
      LET g_lnt.lnt35 = g_lne.lne40
      SELECT gec04,gec07 INTO g_lnt.lnt36,g_lnt.lnt37
        FROM gec_file
       WHERE gec01 = g_lnt.lnt35
      DISPLAY BY NAME g_lnt.lnt35,g_lnt.lnt36,g_lnt.lnt37
      #主品牌
      LET g_lnt.lnt30=g_lne.lne08 
      DISPLAY BY NAME g_lnt.lnt30      
      SELECT tqa02 INTO l_tqa02_1 FROM tqa_file
       WHERE tqa01 = g_lnt.lnt30
         AND tqa03 = '2'
       DISPLAY l_tqa02_1 TO tqa02_1      
      #预租协议
       IF NOT cl_null(g_lnt.lnt17) AND NOT cl_null(g_lnt.lnt06) THEN
          SELECT MAX(lih14) INTO l_lih14
            FROM lih_file
           WHERE lih07 = g_lnt.lnt06
             AND lih08 = g_lnt.lnt04
             AND lih14 < g_lnt.lnt17
           ORDER BY lih14
          IF NOT cl_null(l_lih14) THEN
             SELECT lih01 INTO g_lnt.lnt70
               FROM lih_file
              WHERE lih07 = g_lnt.lnt06
                AND lih08 = g_lnt.lnt04
                AND lih14 = l_lih14
          END IF
       END IF
   END IF   
END FUNCTION 

#主品牌控管
FUNCTION i400_lnt30(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1
DEFINE l_tqa02_1 LIKE tqa_file.tqa02
DEFINE l_tqaacti LIKE tqa_file.tqaacti
   LET g_errno = ''
   SELECT tqa02,tqaacti INTO l_tqa02_1,l_tqaacti
     FROM tqa_file
    WHERE tqa01 = g_lnt.lnt30
      AND tqa03 = '2'
   CASE
      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'alm1128'         #此主品牌编号不存在
      WHEN l_tqaacti <> 'Y'    LET g_errno = 'alm1190'         #此主品牌编号无效
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN    
       DISPLAY l_tqa02_1 TO tqa02_1
   END IF 
END FUNCTION  

#税别控管
FUNCTION i400_lnt35(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1
DEFINE l_gecacti LIKE gec_file.gecacti
    LET g_errno = ''
    SELECT gecacti INTO l_gecacti
      FROM gec_file
     WHERE gec01 = g_lnt.lnt35
       AND gec011 = '2'
   CASE
      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'art-931'         #此税别不存在       
                               LET g_lnt.lnt36 = ''
                               LET g_lnt.lnt37 = ''
      WHEN l_gecacti <> 'Y'    LET g_errno = 'alm-142'         #此税别无效       
                               LET g_lnt.lnt36 = ''
                               LET g_lnt.lnt37 = ''
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
       SELECT gec04,gec07 INTO g_lnt.lnt36,g_lnt.lnt37
         FROM gec_file
        WHERE gec01 = g_lnt.lnt35
       DISPLAY BY NAME g_lnt.lnt36,g_lnt.lnt37
   END IF 
END FUNCTION 

#摊位编号控管
FUNCTION i400_lnt06(p_cmd) 
DEFINE p_cmd    LIKE type_file.chr1
DEFINE l_lmf06   LIKE lmf_file.lmf06     #确认码
DEFINE l_lmfacti LIKE lmf_file.lmfacti   #有效码 
DEFINE l_lih14   LIKE lih_file.lih14
DEFINE l_n       LIKE type_file.num5
DEFINE l_date    LIKE lii_file.lii02
DEFINE l_lnt71   LIKE lnt_file.lnt71
DEFINE l_sql     STRING
DEFINE l_lnt32   LIKE lnt_file.lnt32, 
       l_oba02   LIKE oba_file.oba02,
       l_oba02_1 LIKE oba_file.oba02,
       l_oba02_2 LIKE oba_file.oba02
    LET g_errno = ''
    IF cl_null(g_lnt.lnt06) THEN
       RETURN
    END IF 
    LET g_lnt.lnt70 = ''
    DISPLAY BY NAME g_lnt.lnt70
    SELECT lmf06,lmfacti INTO l_lmf06,l_lmfacti
      FROM lmf_file
     WHERE lmf01 = g_lnt.lnt06
       AND lmfstore = g_lnt.lntplant
       AND lmflegal = g_lnt.lntlegal
   CASE 
      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'alm-042'                #此摊位编号不存在   
      WHEN l_lmf06 <> 'Y'      LET g_errno = 'alm1063'                #此摊位编号未审核
      WHEN l_lmfacti <> 'Y'    LET g_errno = 'alm-877'                #此摊位编号无效
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN 
      CALL i400_chk_lnt06()
      IF cl_null(g_errno) OR p_cmd = 'd' THEN
          #带出门牌号、摊位用途、楼栋、楼层、建筑面积、测量面积、经营面积 
          SELECT lmf13,lmf12,lmf03,lmf04,lmf09,lmf10,lmf11 
            INTO g_lnt.lnt56,g_lnt.lnt55,g_lnt.lnt08,
                 g_lnt.lnt09,g_lnt.lnt11,g_lnt.lnt61,g_lnt.lnt10
            FROM lmf_file
           WHERE lmf01 = g_lnt.lnt06
             AND lmflegal = g_lnt.lntlegal
             AND lmfstore = g_lnt.lntplant
         DISPLAY BY NAME g_lnt.lnt56,g_lnt.lnt55,g_lnt.lnt08,
                         g_lnt.lnt09,g_lnt.lnt11,g_lnt.lnt61,g_lnt.lnt10   
        #摊位用途名称
         SELECT tqa02 INTO g_tqa02 FROM tqa_file
          WHERE tqa01 = g_lnt.lnt55
            AND tqa03 = '30'
         DISPLAY g_tqa02 TO tqa02
        #楼栋名称
         SELECT lmb03 INTO g_lmb03 FROM lmb_file
          WHERE lmb02 = g_lnt.lnt08
         DISPLAY g_lmb03 TO lmb03
        #楼层名称
         SELECT lmc04 INTO g_lmc04 FROM lmc_file
          WHERE lmc03 = g_lnt.lnt09
          DISPLAY g_lmc04 TO lmc04
        #区域
         SELECT DISTINCT lie04 INTO g_lnt.lnt60
           FROM lie_file
          WHERE lie01 = g_lnt.lnt06
        IF SQLCA.SQLCODE = '-284' THEN
            LET g_lnt.lnt60 = '' 
        END IF  
        #区域名称
        IF NOT cl_null(g_lnt.lnt60) THEN 
           SELECT lmy04 INTO g_lmy04 FROM lmy_file
            WHERE lmy03 = g_lnt.lnt60
        ELSE 
           LET g_lmy04 = ''
        END IF 
        DISPLAY g_lmy04 TO lmy04
        #小类
        SELECT lml02 INTO g_lnt.lnt33
          FROM lml_file
         WHERE lml01 = g_lnt.lnt06
        #中类、大类
        SELECT oba13 INTO g_lnt.lnt32 
          FROM oba_file
         WHERE oba01 = g_lnt.lnt33
        IF cl_null(g_lnt.lnt32) THEN
           LET g_lnt.lnt32 = g_lnt.lnt33
           LET g_lnt.lnt31 = g_lnt.lnt33
        ELSE 
           LET l_lnt32 = g_lnt.lnt32
           WHILE TRUE
               SELECT oba13 INTO g_lnt.lnt31
                 FROM oba_file
                WHERE oba01 = l_lnt32
              IF cl_null(g_lnt.lnt31) THEN
                 LET g_lnt.lnt31 = l_lnt32
                 EXIT WHILE
              ELSE 
                 LET l_lnt32 = g_lnt.lnt31  
              END IF  
           END WHILE   
        END IF 
        SELECT oba02 INTO l_oba02 FROM oba_file
         WHERE oba01 = g_lnt.lnt31
         DISPLAY l_oba02 TO oba02
     
        SELECT oba02 INTO l_oba02_1 FROM oba_file
         WHERE oba01 = g_lnt.lnt32
         DISPLAY l_oba02_1 TO oba02_1
     
        SELECT oba02 INTO l_oba02_2 FROM oba_file
         WHERE oba01 = g_lnt.lnt33
         DISPLAY l_oba02_2 TO oba02_2
         DISPLAY BY NAME g_lnt.lnt60,g_lnt.lnt31,g_lnt.lnt32,g_lnt.lnt33
        #预租协议
         IF NOT cl_null(g_lnt.lnt17) AND NOT cl_null(g_lnt.lnt04) THEN
            SELECT MAX(lih14) INTO l_lih14
              FROM lih_file 
             WHERE lih07 = g_lnt.lnt06
               AND lih08 = g_lnt.lnt04
               AND lih14 < g_lnt.lnt17
               AND lihconf = 'Y'
             ORDER BY lih14
            IF NOT cl_null(l_lih14) THEN
               SELECT lih01 INTO g_lnt.lnt70
                 FROM lih_file
                WHERE lih07 = g_lnt.lnt06
                  AND lih08 = g_lnt.lnt04  
                  AND lih14 = l_lih14
                  AND lihconf = 'Y'
            END IF 
         END IF  
        #合同费用项方案
#       IF NOT cl_null(g_lnt.lnt06) THEN                                            #TQC-C30106 mark
        IF NOT cl_null(g_lnt.lnt06) AND                                             #TQC-C30106 add
           (cl_null(g_lnt_t.lnt06) OR g_lnt.lnt06 != g_lnt_t.lnt06) THEN           #TQC-C30106 add
            LET l_sql = "SELECT lii01 FROM lii_file WHERE lii03 = '",g_lnt.lnt08,"'",
                        " AND lii04 = '",g_lnt.lnt09,"'",
                        " AND lii05 = '",g_lnt.lnt55,"'",
                        " AND liiplant = '",g_lnt.lntplant,"'",
                        " AND liiconf = 'Y' ORDER BY lii02 DESC"
            PREPARE i400_pre_1 FROM l_sql
            DECLARE i400_cur_1 SCROLL CURSOR WITH HOLD FOR i400_pre_1
            OPEN i400_cur_1
            FETCH FIRST i400_cur_1 INTO g_lnt.lnt71
            IF cl_null(g_lnt.lnt71) THEN 
               LET l_sql = "SELECT lii01 FROM lii_file WHERE lii03 = '",g_lnt.lnt08,"'",
                           " AND lii05 = '",g_lnt.lnt55,"'",
                           " AND liiplant = '",g_lnt.lntplant,"'",
                           " AND liiconf = 'Y' ORDER BY lii02 DESC"
               PREPARE i400_pre_2 FROM l_sql
               DECLARE i400_cur_2 SCROLL CURSOR WITH HOLD FOR i400_pre_2
               OPEN i400_cur_2
               FETCH FIRST i400_cur_2 INTO g_lnt.lnt71       
               IF cl_null(g_lnt.lnt71) THEN
                  LET l_sql = "SELECT lii01 FROM lii_file ",
                              " WHERE lii05 = '",g_lnt.lnt55,"'",
                              " AND liiplant = '",g_lnt.lntplant,"'",
                              " AND liiconf = 'Y' ORDER BY lii02 DESC"
                  PREPARE i400_pre_3 FROM l_sql
                  DECLARE i400_cur_3 SCROLL CURSOR WITH HOLD FOR i400_pre_3
                  OPEN i400_cur_3
                  FETCH FIRST i400_cur_3 INTO g_lnt.lnt71
               END IF                       
            END IF 
         END IF 
         DISPLAY BY NAME g_lnt.lnt70,g_lnt.lnt71
      END IF 
   END IF    

END FUNCTION 

#CHECK 摊位+租赁时间区间是否重复 
FUNCTION i400_chk_lnt06()
DEFINE l_n       LIKE type_file.num5
DEFINE l_i       LIKE type_file.num5
      IF cl_null(g_lnt.lnt06) OR cl_null(g_lnt.lnt04) THEN
         RETURN 
      END IF
      #判断在租赁期间内该摊位是否存在于预租协议里    
      IF NOT cl_null(g_lnt.lnt17) AND cl_null(g_lnt.lnt18) THEN
         #不是当前商户的预租协议
         SELECT COUNT(*) INTO l_n 
           FROM lih_file  
          WHERE lih07 = g_lnt.lnt06
            AND lih08 <> g_lnt.lnt04
            AND lihconf = 'Y'
            AND g_lnt.lnt17 BETWEEN lih14 AND lih15
         #是当前商户的预租协议
         SELECT COUNT(*) INTO l_i
           FROM lih_file
          WHERE lih07 = g_lnt.lnt06
            AND lih08 = g_lnt.lnt04
            AND lihconf = 'Y'
            AND g_lnt.lnt17 BETWEEN lih14 AND lih15
      END IF 
      IF cl_null(g_lnt.lnt17) AND NOT cl_null(g_lnt.lnt18) THEN
         #不是当前商户的预租协议
         SELECT COUNT(*) INTO l_n 
           FROM lih_file  
          WHERE lih07 = g_lnt.lnt06
            AND lih08 <> g_lnt.lnt04
            AND lihconf = 'Y'
            AND g_lnt.lnt18 BETWEEN lih14 AND lih15  

         #是当前商户的预租协议
         SELECT COUNT(*) INTO l_i
           FROM lih_file
          WHERE lih07 = g_lnt.lnt06
            AND lih08 = g_lnt.lnt04
            AND lihconf = 'Y'
            AND g_lnt.lnt18 BETWEEN lih14 AND lih15
      END IF 
      IF NOT cl_null(g_lnt.lnt17) AND NOT cl_null(g_lnt.lnt18) THEN
         #不是当前商户的预租协议 
         SELECT COUNT(*) INTO l_n
           FROM lih_file
          WHERE lih07 = g_lnt.lnt06
            AND lihconf = 'Y'
            AND lih08 <> g_lnt.lnt04
            AND (g_lnt.lnt17 BETWEEN lih14 AND lih15
             OR lih14 BETWEEN g_lnt.lnt17 AND g_lnt.lnt18 
             OR lih15 BETWEEN g_lnt.lnt17 AND g_lnt.lnt18 )   

         #是当前商户的预租协议
         SELECT COUNT(*) INTO l_i
           FROM lih_file
          WHERE lih07 = g_lnt.lnt06
            AND lihconf = 'Y'
            AND lih08 = g_lnt.lnt04
            AND (g_lnt.lnt17 BETWEEN lih14 AND lih15
             OR lih14 BETWEEN g_lnt.lnt17 AND g_lnt.lnt18
             OR lih15 BETWEEN g_lnt.lnt17 AND g_lnt.lnt18 )
      END IF 
      IF l_n > 0 THEN
         LET g_errno = 'alm1313'  #摊位编号在租赁期间内已存在于预租协议 
         RETURN
      END IF
      IF l_i > 0 THEN
         LET g_errno = 'alm1191'  #请先终止本商户在租赁期间内的预租协议
      END IF
      
      #判断在租赁期间内该摊位是否存在于已审核的合同中
      IF NOT cl_null(g_lnt.lnt17) AND cl_null(g_lnt.lnt18) THEN
         SELECT COUNT(*) INTO l_n
           FROM lnt_file
          WHERE lnt06 = g_lnt.lnt06
            AND (lnt26 = 'Y' OR lnt26 = 'F')
            AND g_lnt.lnt17 BETWEEN lnt17 AND lnt18
      END IF 
      IF cl_null(g_lnt.lnt17) AND NOT cl_null(g_lnt.lnt18) THEN
         SELECT COUNT(*) INTO l_n 
           FROM lnt_file  
          WHERE lnt06 = g_lnt.lnt06
            AND (lnt26 = 'Y' OR lnt26 = 'F')
            AND g_lnt.lnt18 BETWEEN lnt17 AND lnt18   
      END IF  
      IF NOT cl_null(g_lnt.lnt17) AND NOT cl_null(g_lnt.lnt18) THEN
         SELECT COUNT(*) INTO l_n
           FROM lnt_file
          WHERE lnt06 = g_lnt.lnt06
            AND (lnt26 = 'Y' OR lnt26 = 'F')
            AND (g_lnt.lnt17 BETWEEN lnt17 AND lnt18
             OR lnt17 BETWEEN g_lnt.lnt17 AND g_lnt.lnt18
             OR lnt18 BETWEEN g_lnt.lnt17 AND g_lnt.lnt18 )  
      END IF 
      IF l_n > 0 THEN
         LET g_errno = 'alm1185'  #摊位编号在租赁期间内已存在于已审核的合同中
         RETURN
      END IF
END FUNCTION 

FUNCTION i400_set_entry(p_cmd)
   DEFINE p_cmd    LIKE type_file.chr1
   IF p_cmd='a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("lnt01",TRUE)
   END IF

END FUNCTION


FUNCTION i400_set_noentry(p_cmd)
   DEFINE p_cmd    LIKE type_file.chr1
   IF p_cmd='u' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("lnt01",FALSE)
   END IF

END FUNCTION

#初审拒绝
FUNCTION i400_deny1()  #初審拒絕
   DEFINE l_gen02_1 LIKE gen_file.gen02
   DEFINE l_lmf05    LIKE lmf_file.lmf05
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lnt.lnt01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lnt.* FROM lnt_file
    WHERE lnt01=g_lnt.lnt01
   IF g_lnt.lntplant <> g_plant THEN    
      CALL cl_err(g_lnt.lntplant,'alm-399',0) 
      RETURN
   END IF
   IF g_lnt.lnt26 = 'B' THEN
      CALL cl_err(g_lnt.lnt01,'alm-995',0)  #已終審拒絕
      RETURN 
   END IF  
   IF g_lnt.lnt26 = 'A' THEN
     CALL cl_err(g_lnt.lnt01,'alm-h02',0)   #已经初审拒绝 
     RETURN
   END IF
   IF g_lnt.lnt26 = 'F' THEN
      CALL cl_err(g_lnt.lnt01,'alm1219',0)  #合同已初審
      RETURN
   END IF
   IF g_lnt.lnt26 = 'Y' THEN
      CALL cl_err(g_lnt.lnt01,'alm1220',0)  #合同已終審
      RETURN
   END IF
   IF g_lnt.lnt26 = 'S' THEN
      CALL cl_err(g_lnt.lnt01,'alm1221',0)  #合同終止
      RETURN
   END IF
   IF g_lnt.lnt26 = 'E' THEN
      CALL cl_err(g_lnt.lnt01,'alm1222',0)  #合同到期
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN i400_cl USING g_lnt.lnt01
   IF STATUS THEN
      CALL cl_err("OPEN i400_cl:", STATUS, 1)
      CLOSE i400_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i400_cl INTO g_lnt.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lnt.lnt01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL i400_show()
 
   IF cl_confirm('alm-591') THEN             #是否確定初審拒絕 (Y/N)?
      LET g_lnt.lntmodu = g_user
      LET g_lnt.lntdate = g_today
      UPDATE lnt_file SET lnt48 = '1',
                          lnt26 = 'A',    
                          lnt27 = g_user, 
                          lnt28 = g_today, 
                          lntmodu = g_lnt.lntmodu,
                          lntdate = g_lnt.lntdate                          
       WHERE lnt01=g_lnt.lnt01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","lnt_file",g_lnt.lnt01,"",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
      END IF
   END IF
 
   CLOSE i400_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_lnt.lnt01,'V')
   ELSE
      ROLLBACK WORK
   END IF
   SELECT * INTO g_lnt.* FROM lnt_file
    WHERE lnt01 = g_lnt.lnt01
   DISPLAY BY NAME g_lnt.lnt48,g_lnt.lnt26,g_lnt.lnt27,g_lnt.lnt28 
   CALL cl_set_field_pic(g_lnt.lnt26,'','','','','')
   SELECT gen02 INTO l_gen02_1 FROM gen_file WHERE gen01=g_lnt.lnt27
   DISPLAY l_gen02_1 TO gen02_1 
END FUNCTION

FUNCTION i400_y1()  #初审
   DEFINE l_lmf05    LIKE lmf_file.lmf05
   DEFINE l_gen02_1  LIKE gen_file.gen02
   DEFINE l_liw09    LIKE liw_file.liw09 
   DEFINE l_liw10    LIKE liw_file.liw10
   DEFINE l_liw11    LIKE liw_file.liw11
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lnt.lnt01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lnt.* FROM lnt_file
    WHERE lnt01=g_lnt.lnt01
   IF g_lnt.lntplant <> g_plant THEN       
      CALL cl_err(g_lnt.lntplant,'alm-399',0)
      RETURN
   END IF
   #沒有費用標準不可初審
   IF g_rec_b = 0 THEN 
      CALL  cl_err(g_lnt.lnt01,'alm-991',0)
      RETURN
   END IF  
   #沒有定義付款，不可初審
   IF g_rec_b4 = 0 THEN
      CALL  cl_err(g_lnt.lnt01,'alm-992',0)
      RETURN
   END IF 
   #合同開始終止流程，不能初審
   IF g_lnt.lnt48 MATCHES '[4567]' THEN
       CALL  cl_err(g_lnt.lnt01,'alm-993',0) #合同開始終止流程，不能拒絕！
       RETURN
   END IF
   #合同已初審
   IF g_lnt.lnt26 = 'F' THEN
      CALL cl_err(g_lnt.lnt01,'alm1214',0)  #合同已一審,不可異動
      RETURN
   END IF
   #合同已初審拒絕
   IF g_lnt.lnt26 = 'A' THEN
      CALL cl_err(g_lnt.lnt01,'alm1215',0)
      RETURN
   END IF
   #合同已終審拒絕
   IF g_lnt.lnt26 = 'B' THEN
      CALL cl_err(g_lnt.lnt01,'alm-994',0)
      RETURN
   END IF 
   #合同已終審
   IF g_lnt.lnt26 = 'Y' THEN
      CALL cl_err(g_lnt.lnt01,'alm1216',0)  #合同已終審,不可異動
      RETURN
   END IF
   #合同已終止
   IF g_lnt.lnt26 = 'S' THEN
      CALL cl_err(g_lnt.lnt01,'alm1217',0)
      RETURN
   END IF
   #合同到期
   IF g_lnt.lnt26 = 'E' THEN
      CALL cl_err(g_lnt.lnt01,'alm1218',0)
      RETURN
   END IF
   #合同租赁期间内是否有其他合同或预租协议
   CALL i400_confirm_chk()
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
      RETURN
   END IF   
   #如果没有产生账单，不可初审
   LET g_cnt = 0
   SELECT COUNT(*) INTO g_cnt
     FROM liw_file
    WHERE liw01 = g_lnt.lnt01
   IF g_cnt = 0 THEN
     CALL cl_err('','alm1192',0)
     RETURN
   END IF 

   #如果合同单头标准费用不等于账单标准费用
   SELECT SUM(liw09) INTO l_liw09
     FROM liw_file
    WHERE liw01 = g_lnt.lnt01 
   IF cl_null(l_liw09) THEN
      LET l_liw09 = 0
   END IF 
   IF (g_lnt.lnt64 + g_lnt.lnt66) <> l_liw09 THEN
      CALL cl_err('','alm1193',0)
      RETURN
   END IF 
   #如果合同单头的优惠金额不等于账单优惠金
   SELECT SUM(liw10) INTO l_liw10
     FROM liw_file 
    WHERE liw01 = g_lnt.lnt01
   IF cl_null(l_liw10) THEN
      LET l_liw10 = 0
   END IF
   IF g_lnt.lnt65 <> l_liw10 THEN
      CALL cl_err('','alm1194',0)
      RETURN
   END IF
   #合同单头的终止金额不等于账单终止金
   SELECT SUM(liw11) INTO l_liw11
     FROM liw_file 
    WHERE liw01 = g_lnt.lnt01
   IF cl_null(l_liw11) THEN
      LET l_liw11 = 0
   END IF
   IF g_lnt.lnt67 <> l_liw11 THEN
      CALL cl_err('','alm1195',0)
      RETURN
   END IF
   #判斷攤位在此租賃期間是否已被其他合同使用
   LET g_cnt = 0
   SELECT COUNT(*) INTO g_cnt FROM lnt_file
    WHERE lnt17 < g_lnt.lnt18 AND lnt18 > g_lnt.lnt17
      AND lnt06 = g_lnt.lnt06 AND lnt26 = 'Y'
      AND lnt26 <> 'S'
   IF g_cnt > 1 THEN
      CALL cl_err(g_lnt.lnt06,'alm-317',0)
      RETURN
   END IF
 
   #判斷攤位是否存在预租协议被使用
   LET g_cnt = 0
   SELECT COUNT(*) INTO g_cnt
     FROM lih_file
    WHERE lih07 = g_lnt.lnt06
      AND lihconf = 'Y'
      AND (g_lnt.lnt21 BETWEEN lih14 AND lih15
       OR lih14 BETWEEN g_lnt.lnt21 AND g_lnt.lnt22
       OR lih15 BETWEEN g_lnt.lnt21 AND g_lnt.lnt22 )
   IF g_cnt > 0 THEN
      LET g_errno = 'alm-878'  #摊位编号在租赁期间内已存在于预租协议
      RETURN
   END IF    
   BEGIN WORK
 
   OPEN i400_cl USING g_lnt.lnt01
   IF STATUS THEN
      CALL cl_err("OPEN i400_cl:", STATUS, 1)
      CLOSE i400_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i400_cl INTO g_lnt.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lnt.lnt01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL i400_show()
 
   IF cl_confirm('alm-583') THEN  #是否確定執行初審 (Y/N) ?
      LET g_lnt.lntmodu = g_user
      LET g_lnt.lntdate = g_today
      UPDATE lnt_file SET lnt26 = 'F',
                          lnt48 = '1',
                          lnt27 = g_user,
                          lnt28 = g_today,
                          lntmodu = g_lnt.lntmodu,
                          lntdate = g_lnt.lntdate
       WHERE lnt01=g_lnt.lnt01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","lnt_file",g_lnt.lnt01,"",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
      END IF
   END IF
 
   CLOSE i400_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_lnt.lnt01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT lnt26,lnt27,lnt28,lnt48 INTO g_lnt.lnt26,g_lnt.lnt27,g_lnt.lnt28,g_lnt.lnt48
     FROM lnt_file
    WHERE lnt01 = g_lnt.lnt01

   SELECT gen02 INTO l_gen02_1 FROM gen_file
    WHERE gen01 = g_lnt.lnt27
    DISPLAY l_gen02_1 TO gen02_1 

   CALL cl_set_field_pic(g_lnt.lnt26,'','','','','')
   DISPLAY BY NAME g_lnt.lnt26,g_lnt.lnt27,g_lnt.lnt28,g_lnt.lnt48
 
END FUNCTION

FUNCTION i400_deny2()  #終審拒絕
   DEFINE l_gen02_2 LIKE gen_file.gen02
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lnt.lnt01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lnt.* FROM lnt_file
    WHERE lnt01=g_lnt.lnt01
   IF g_lnt.lntplant <> g_plant THEN          
      CALL cl_err(g_lnt.lntplant,'alm-399',0) 
      RETURN
   END IF
 
   IF g_lnt.lnt26 = 'B' THEN
      CALL  cl_err(g_lnt.lnt01,'alm-986',0) #合同終審已拒絕，不能再次終審拒絕！
      RETURN
   END IF 

   IF g_lnt.lnt48 MATCHES '[4567]' THEN
       CALL  cl_err(g_lnt.lnt01,'alm-987',0) #合同開始終止流程，不能拒絕！
       RETURN
   END IF 

   IF g_lnt.lnt26 = 'N' THEN
      CALL cl_err(g_lnt.lnt01,'alm-590',0)  #合同未初審,不可終審拒絕!
      RETURN
   END IF
   #合同已終審
   IF g_lnt.lnt26 = 'Y' THEN
      CALL cl_err(g_lnt.lnt01,'alm1211',0)
      RETURN
   END IF
 
   #合同終止
   IF g_lnt.lnt26 = 'S' THEN
      CALL cl_err(g_lnt.lnt01,'alm1212',0)
      RETURN
   END IF
   #合同到期
   IF g_lnt.lnt26 = 'E' THEN
      CALL cl_err(g_lnt.lnt01,'alm1213',0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN i400_cl USING g_lnt.lnt01
   IF STATUS THEN
      CALL cl_err("OPEN i400_cl:", STATUS, 1)
      CLOSE i400_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i400_cl INTO g_lnt.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lnt.lnt01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL i400_show()
 
   IF cl_confirm('alm-592') THEN             #是否確定終審拒絕 (Y/N)?
      LET g_lnt.lntmodu = g_user
      LET g_lnt.lntdate = g_today
      UPDATE lnt_file SET lnt48 = '1',
                          lnt26 = 'B',       
                          lnt47 = g_user,
                          lnt46 = g_today,
                          lntmodu = g_lnt.lntmodu,
                          lntdate = g_lnt.lntdate
       WHERE lnt01=g_lnt.lnt01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","lnt_file",g_lnt.lnt01,"",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
      END IF
      UPDATE lmf_file SET lmf05='1'
       WHERE lmf01 = g_lnt.lnt06
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","lmf_file",g_lnt.lnt06,"",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
      END IF
   END IF
 
   CLOSE i400_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_lnt.lnt01,'V')
   ELSE
      ROLLBACK WORK
   END IF
   SELECT lnt48,lnt26,lnt27,lnt28,lnt46,lnt47
     INTO g_lnt.lnt48,g_lnt.lnt26,g_lnt.lnt27,g_lnt.lnt28,
          g_lnt.lnt46,g_lnt.lnt47
     FROM lnt_file
    WHERE lnt01 = g_lnt.lnt01

   SELECT gen02 INTO l_gen02_2 FROM gen_file
    WHERE gen01 = g_lnt.lnt47
    DISPLAY l_gen02_2 TO gen02_2 
   DISPLAY BY NAME g_lnt.lnt48,g_lnt.lnt26,g_lnt.lnt27,
                   g_lnt.lnt28,g_lnt.lnt46,g_lnt.lnt47
 
END FUNCTION

FUNCTION i400_y()  #終審
   DEFINE l_gen02_2 LIKE gen_file.gen02
   DEFINE l_sql     STRING
   DEFINE l_liw05   LIKE liw_file.liw05,
          l_liw06   LIKE liw_file.liw06,
          l_liw01   LIKE liw_file.liw01
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lnt.lnt01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lnt.* FROM lnt_file
    WHERE lnt01=g_lnt.lnt01
   IF g_lnt.lntplant <> g_plant THEN  
      CALL cl_err(g_lnt.lntplant,'alm-399',0)    
      RETURN
   END IF
 
   IF g_lnt.lnt26 = 'N' THEN
      CALL cl_err(g_lnt.lnt01,'alm-586',0)  #合同未一審,不可進行終審!
      RETURN
   END IF
   #合同已終審
   IF g_lnt.lnt26 = 'Y' THEN
      CALL cl_err(g_lnt.lnt01,'alm1208',0)
      RETURN
   END IF
   #已初審拒絕
   IF g_lnt.lnt26 = 'A' THEN
      CALL cl_err(g_lnt.lnt01,'alm-988',0)
      RETURN
   END IF   
   #已終審拒絕
   IF g_lnt.lnt26 = 'B' THEN
      CALL cl_err(g_lnt.lnt01,'alm-989',0)
      RETURN
   END IF 
   #合同終止
   IF g_lnt.lnt26 = 'S' THEN
      CALL cl_err(g_lnt.lnt01,'alm1209',0)
      RETURN
   END IF
   #合同到期
   IF g_lnt.lnt26 = 'E' THEN
      CALL cl_err(g_lnt.lnt01,'alm1210',0)
      RETURN
   END IF
   #合同租赁期间内是否有其他合同或预租协议
   CALL i400_confirm_chk()
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
      RETURN
   END IF  
   BEGIN WORK
 
   OPEN i400_cl USING g_lnt.lnt01
   IF STATUS THEN
      CALL cl_err("OPEN i400_cl:", STATUS, 1)
      CLOSE i400_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i400_cl INTO g_lnt.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lnt.lnt01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
   
   LET g_success = 'Y'
 
   CALL i400_show()
 
   IF cl_confirm('alm-587') THEN   #是否確定執行終審 (Y/N) ?
      LET g_lnt.lntmodu = g_user
      LET g_lnt.lntdate = g_today
      UPDATE lnt_file SET lnt26 = 'Y',
                          lnt48 = '1',
                          lnt47 = g_user,
                          lnt46 = g_today,
                          lntmodu = g_lnt.lntmodu,
                          lntdate = g_lnt.lntdate
       WHERE lnt01=g_lnt.lnt01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","lnt_file",g_lnt.lnt01,"",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
      END IF
      #IF g_lnt.lnt17 <= g_today THEN   #TQC-C20525 mark
      IF g_lnt.lnt17 <= g_today AND g_today <= g_lnt.lnt18 THEN  #TQC-C20525 add
         #攤位狀態置為已使用
         UPDATE lmf_file SET lmf05='2'
          WHERE lmf01 = g_lnt.lnt06
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","lmf_file",g_lnt.lnt06,"",SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
         END IF
      END IF 
      CALL p101_upd_ratio_bill(g_lnt.lnt01,g_today,'',g_plant,'2') #FUN-C20078
      DECLARE sel_liw_cs_1 CURSOR FOR SELECT DISTINCT liw01,liw05,liw06
                                        FROM liw_file
                                       WHERE liw01 = g_lnt.lnt01
                                         AND liw06 <= g_today
                                         AND liw17 = 'N'
                                         AND liw16 IS NULL
                                       ORDER BY liw06
      FOREACH sel_liw_cs_1 INTO l_liw01,l_liw05,l_liw06
         IF SQLCA.SQLCODE THEN
            CALL cl_err('foreach:',SQLCA.SQLCODE,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF 
         CALL i400sub_gen_expense_bill(l_liw01,l_liw05,l_liw06,g_lnt.lntplant)
      END FOREACH
      SELECT * INTO g_lnt.* FROM lnt_file WHERE lnt01 = g_lnt.lnt01
      #产生变更单
      CALL i400_ins_lji()
   END IF
   CLOSE i400_cl
   IF g_success = 'Y' THEN
      MESSAGE ""
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   SELECT gen02 INTO l_gen02_2 FROM gen_file
    WHERE gen01 = g_lnt.lnt47
    DISPLAY l_gen02_2 TO gen02_2   
   CALL cl_set_field_pic(g_lnt.lnt26,'','','','','')
   DISPLAY BY NAME g_lnt.lntpos,g_lnt.lnt26,g_lnt.lnt46,g_lnt.lnt47,g_lnt.lnt48  
END FUNCTION

FUNCTION i400_ins_lji()
   DEFINE li_result   LIKE type_file.num5
   DEFINE l_lji       RECORD LIKE lji_file.*   
   DEFINE l_ljj       RECORD LIKE ljj_file.*
   DEFINE l_ljk       RECORD LIKE ljk_file.*
   DEFINE l_ljl       RECORD LIKE ljl_file.*
   DEFINE l_ljm       RECORD LIKE ljm_file.*
   DEFINE l_ljn       RECORD LIKE ljn_file.*
   DEFINE l_ljo       RECORD LIKE ljo_file.*
   SELECT oayslip INTO l_lji.lji01 
     FROM oay_file
    WHERE oaytype = 'P9'
   CALL s_auto_assign_no("alm",l_lji.lji01,g_today,'P9',"lji_file",
                         "lji01","","","") RETURNING li_result,l_lji.lji01
   IF (NOT li_result) THEN
     RETURN 
   END IF
   LET l_lji.lji02 = ' '
   LET l_lji.ljiplant = g_lnt.lntplant
   LET l_lji.ljilegal = g_lnt.lntlegal
   LET l_lji.lji03 = ' ' 
   LET l_lji.lji04 = g_lnt.lnt01
   LET l_lji.lji05 = 0
   LET l_lji.lji06 = g_lnt.lnt03
   LET l_lji.lji17 = g_lnt.lnt16
   LET l_lji.lji07 = g_lnt.lnt04
   LET l_lji.lji08 = g_lnt.lnt06
   LET l_lji.lji09 = g_lnt.lnt55
   LET l_lji.lji10 = g_lnt.lnt56
   LET l_lji.lji48 = g_lnt.lnt57
   LET l_lji.lji18 = g_lnt.lnt54
   LET l_lji.lji19 = g_lnt.lnt45
   LET l_lji.lji20 = g_lnt.lnt58
   LET l_lji.lji21 = g_lnt.lnt59
   LET l_lji.lji11 = g_lnt.lnt08
   LET l_lji.lji12 = g_lnt.lnt09
   LET l_lji.lji13 = g_lnt.lnt60
   LET l_lji.lji14 = g_lnt.lnt11
   LET l_lji.lji15 = g_lnt.lnt61
   LET l_lji.lji16 = g_lnt.lnt10
   LET l_lji.lji141 = ''
   LET l_lji.lji151 = ''
   LET l_lji.lji161 = ''
   LET l_lji.lji22 = g_lnt.lnt17
   LET l_lji.lji23 = g_lnt.lnt18
   LET l_lji.lji24 = g_lnt.lnt51 
   LET l_lji.lji25 = g_lnt.lnt21
   LET l_lji.lji26 = g_lnt.lnt22
   LET l_lji.lji27 = ' '
   LET l_lji.lji28 = ' '
   LET l_lji.lji29 = ' '
   LET l_lji.lji32 = g_lnt.lnt64
   LET l_lji.lji33 = g_lnt.lnt65
   LET l_lji.lji34 = g_lnt.lnt66
   LET l_lji.lji35 = g_lnt.lnt67
   LET l_lji.lji36 = g_lnt.lnt68
   LET l_lji.lji37 = g_lnt.lnt69
   LET l_lji.lji43 = g_lnt.lnt48 
   LET l_lji.ljiconf = g_lnt.lnt26
   LET l_lji.lji44 = g_lnt.lnt27
   LET l_lji.lji45 = g_lnt.lnt28
   LET l_lji.lji46 = g_lnt.lnt47
   LET l_lji.lji47 = g_lnt.lnt46
   LET l_lji.lji42 = g_lnt.lnt29
   LET l_lji.ljiuser = g_lnt.lntuser
   LET l_lji.ljigrup = g_lnt.lntgrup
   LET l_lji.ljidate = g_lnt.lntdate
   LET l_lji.ljiacti = g_lnt.lntacti
   LET l_lji.ljicrat = g_lnt.lntcrat
   LET l_lji.ljioriu = g_lnt.lntorig
   LET l_lji.ljiorig = g_lnt.lntorig
   LET l_lji.ljimksg = ' ' 
   LET l_lji.lji30 = g_lnt.lnt62
   LET l_lji.lji31 = g_lnt.lnt63
   LET l_lji.lji38 = g_lnt.lnt30
   LET l_lji.lji381 = ''
   LET l_lji.lji49 = g_lnt.lnt31
   LET l_lji.lji50 = g_lnt.lnt32
   LET l_lji.lji51 = g_lnt.lnt33
   LET l_lji.lji52 = g_lnt.lnt35
   LET l_lji.lji53 = g_lnt.lnt36
   LET l_lji.lji54 = g_lnt.lnt37
   LET l_lji.lji39 = g_lnt.lnt70 
   LET l_lji.lji40 = g_lnt.lnt71
   LET l_lji.lji41 = g_lnt.lnt72
   INSERT INTO lji_file VALUES (l_lji.*)
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err3("ins","lji_file",l_lji.lji01,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
   LET g_sql = "SELECT lnv01,lnv02,lnv03,lnv04,lnv18,lnv181,lnv16,lnv17,lnv07,lnvlegal,lnvplant",
               "  FROM lnv_file WHERE lnv01 = '",g_lnt.lnt01,"' ORDER BY lnv03"   
   PREPARE i400_lnv_pre_1 FROM g_sql
   DECLARE i400_lnv_cur_1 CURSOR FOR i400_lnv_pre_1

   #查询单身二的SQL
   LET g_sql="SELECT * ",
             " FROM lit_file WHERE lit01='",g_lnt.lnt01,"'",
             " ORDER BY lit03"
   PREPARE i400_lit_pre_1 FROM g_sql
   DECLARE i400_lit_cur_1 CURSOR FOR i400_lit_pre_1

   #查询单身三的SQL
   LET g_sql="SELECT lnw01,lnw02,lnw11,lnw03,lnw08,lnw09,lnw06,lnwlegal,lnwplant",
             "  FROM lnw_file WHERE lnw01='",g_lnt.lnt01,"'",
             " ORDER BY lnw11"
   PREPARE i400_lnw_pre_1 FROM g_sql
   DECLARE i400_lnw_cur_1 CURSOR FOR i400_lnw_pre_1

   #查询单身四的SQL
   LET g_sql="SELECT * FROM liu_file WHERE liu01='",g_lnt.lnt01,"'",
             " ORDER BY liu03"
   PREPARE i400_liu_pre_1 FROM g_sql
   DECLARE i400_liu_cur_1 CURSOR FOR i400_liu_pre_1

   #查询单身五的SQL
   LET g_sql="SELECT lnu01,lnu02,lnu06,lnu03,lnu08,lnu09,lnu10,lnu05,lnu07,lnu04,lnulegal,lnuplant",
             " FROM lnu_file WHERE lnu01 = '",g_lnt.lnt01,"'",
             " ORDER BY lnu06"
   PREPARE i400_lnu_pre_1 FROM g_sql
   DECLARE i400_lnu_cur_1 CURSOR FOR i400_lnu_pre_1

   #查询单身六的SQL
   LET g_sql="SELECT lny01,lny02,lny04,lny03,lnylegal,lnyplant FROM lny_file WHERE lny01 = '",g_lnt.lnt01,"'",
             " ORDER BY lny04"
   PREPARE i400_lny_pre_1 FROM g_sql
   DECLARE i400_lny_cur_1 CURSOR FOR i400_lny_pre_1
   INITIALIZE l_ljj.* TO NULL
   INITIALIZE l_ljk.* TO NULL
   INITIALIZE l_ljl.* TO NULL
   INITIALIZE l_ljm.* TO NULL
   INITIALIZE l_ljn.* TO NULL
   INITIALIZE l_ljo.* TO NULL
   FOREACH i400_lnv_cur_1 INTO l_ljj.*
      LET l_ljj.ljj01 = l_lji.lji01
      INSERT INTO ljj_file VALUES (l_ljj.*)     
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("ins","ljj_file",l_ljj.ljj01,"",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
         RETURN
      END IF
   END FOREACH

   FOREACH i400_lit_cur_1 INTO l_ljk.*
      LET l_ljk.ljk01 = l_lji.lji01
      INSERT INTO ljk_file VALUES (l_ljk.*)
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("ins","ljk_file",l_ljk.ljk01,"",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
         RETURN
      END IF
   END FOREACH

   FOREACH i400_lnw_cur_1 INTO l_ljl.*
      LET l_ljl.ljl01 = l_lji.lji01
      INSERT INTO ljl_file VALUES (l_ljl.*)
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("ins","ljl_file",l_ljl.ljl01,"",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
         RETURN
      END IF
   END FOREACH

   FOREACH i400_liu_cur_1 INTO l_ljm.*
      LET l_ljm.ljm01 = l_lji.lji01
      INSERT INTO ljm_file VALUES (l_ljm.*)
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("ins","ljm_file",l_ljm.ljm01,"",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
         RETURN
      END IF
   END FOREACH

   FOREACH i400_lnu_cur_1 INTO l_ljn.*
      LET l_ljn.ljn01 = l_lji.lji01
      INSERT INTO ljn_file VALUES (l_ljn.*)
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("ins","ljn_file",l_ljn.ljn01,"",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
         RETURN
      END IF
   END FOREACH

   FOREACH i400_lny_cur_1 INTO l_ljo.*
      LET l_ljo.ljo01 = l_lji.lji01
      INSERT INTO ljo_file VALUES (l_ljo.*)
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("ins","ljo_file",l_ljo.ljo01,"",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
         RETURN
      END IF
   END FOREACH
   #将日核算插入变更日核算
    INSERT INTO ljp_file SELECT * FROM liv_file WHERE liv01 = g_lnt.lnt01 
    IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
       CALL cl_err3("ins","ljp_file",g_lnt.lnt01,"",SQLCA.sqlcode,"","",1)
       LET g_success = 'N'
       RETURN
    END IF
    UPDATE ljp_file SET ljp01 = l_lji.lji01
     WHERE ljp01 = g_lnt.lnt01
     IF SQLCA.sqlerrd[3]=0 THEN
        CALL cl_err3("upd","ljp_file",l_lji.lji01,"",SQLCA.sqlcode,"","",1)
        LET g_success = 'N'
        RETURN
     END IF  
   #将账单插入变更账单表里
    INSERT INTO ljq_file SELECT * FROM liw_file WHERE liw01 = g_lnt.lnt01
    IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
       CALL cl_err3("ins","ljq_file",g_lnt.lnt01,"",SQLCA.sqlcode,"","",1)
       LET g_success = 'N'
       RETURN
    END IF
    UPDATE ljq_file SET ljq01 = l_lji.lji01
     WHERE ljq01 = g_lnt.lnt01
     IF SQLCA.sqlerrd[3]=0 THEN
        CALL cl_err3("upd","ljq_file",l_lji.lji01,"",SQLCA.sqlcode,"","",1)
        LET g_success = 'N'
        RETURN
     END IF
END FUNCTION

FUNCTION i400_unconfirm()
   DEFINE l_n        LIKE type_file.num5,
          l_lnt26    LIKE lnt_file.lnt26,
          l_lnt48    LIKE lnt_file.lnt48

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_lnt.lnt01 IS NULL OR g_lnt.lntplant IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_lnt.*
     FROM lnt_file
    WHERE lnt01 = g_lnt.lnt01

    LET l_lnt26 = g_lnt.lnt26
    LET l_lnt48   = g_lnt.lnt48

   IF g_lnt.lnt26 <> 'Y' AND g_lnt.lnt26 <> 'F' THEN
      CALL cl_err('','alm1314',0)
      RETURN
   END IF

   IF g_lnt.lnt26 = 'Y' THEN
      CALL cl_err('','alm1316',0)
      RETURN
   END IF 

   IF g_lnt.lnt48 = '2' THEN
      CALL cl_err('','alm1315',0)
      RETURN
   END IF
   
   LET g_cnt = 0
   SELECT COUNT(*) INTO g_cnt FROM lje_file
    WHERE lje04 = g_lnt.lnt01             
   #合同已终止，不可取消审核
   IF g_cnt>0 THEN                        
      #CALL cl_err('','alm1206',0)        #TQC-C30290 mark 
      CALL cl_err('','alm1614',0)         #TQC-C30290 add 
      RETURN 
   END IF
   #合同已变更，不可取消审核 
   SELECT COUNT(*) INTO g_cnt FROM lji_file
     WHERE lji04 = g_lnt.lnt01
       AND lji05 > 0
   IF g_cnt>0 THEN
      CALL cl_err('','alm1207',0)
      RETURN
   END IF
   #该合同已产生费用单，不可取消审核
   SELECT COUNT(*) INTO g_cnt FROM lua_file
    WHERE lua04 = g_lnt.lnt04
   IF g_cnt>0 THEN
      CALL cl_err('','alm-491',0)
      RETURN
   END IF     
   LET g_success = 'Y'

   BEGIN WORK
   OPEN i400_cl USING g_lnt.lnt01
   IF STATUS THEN
      CALL cl_err("open i400_cl:",STATUS,1)
      CLOSE i400_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i400_cl INTO g_lnt.*
   IF SQLCA.sqlcode  THEN
      CALL cl_err(g_lnt.lnt01,SQLCA.sqlcode,0)
      CLOSE i400_cl
      ROLLBACK WORK
      RETURN
   END IF

   IF NOT cl_confirm('alm-008') THEN
      RETURN
   ELSE
      IF g_lnt.lntpos = '3' THEN
         LET g_lnt.lntpos = '2' 
      END IF 
      LET g_lnt.lnt48 = '0'
      LET g_lnt.lnt26 = 'N'
      LET g_lnt.lntmodu = g_user
      LET g_lnt.lntdate = g_today
      #CHI-D20015--modify--str--
      #LET g_lnt.lnt27 = ''
      #LET g_lnt.lnt47 = ''
      #LET g_lnt.lnt28 = ''
      #LET g_lnt.lnt46 = ''
      LET g_lnt.lnt27 = g_user
      LET g_lnt.lnt28 = g_today
      #CHI-D20015--modify--str--
      UPDATE lnt_file
         SET lnt26 = g_lnt.lnt26,
             lntmodu = g_lnt.lntmodu ,
             lntdate = g_lnt.lntdate,
             lnt48 = g_lnt.lnt48,
             lnt27 = g_lnt.lnt27,
             lnt28 = g_lnt.lnt28,
             #lnt47 = g_lnt.lnt47,  #CHI-D20015 mark
             #lnt46 = g_lnt.lnt46,  #CHI-D20015 mark
             lntpos = g_lnt.lntpos
       WHERE lnt01 = g_lnt.lnt01

      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('upd lnt:',SQLCA.sqlcode,0)
         LET g_lnt.lnt48 = l_lnt48
         LET g_lnt.lnt26 = l_lnt26
         DISPLAY BY NAME g_lnt.lnt26,g_lnt.lnt48
         RETURN
      ELSE
         DISPLAY BY NAME g_lnt.lnt26,g_lnt.lnt48,g_lnt.lnt27,g_lnt.lnt28,
                         g_lnt.lnt46,g_lnt.lnt47,g_lnt.lntmodu,g_lnt.lntdate
         DISPLAY '' TO gen02_1
         DISPLAY '' TO gen02_2
         CALL cl_set_field_pic(g_lnt.lnt26,"","","","","")
      END IF
   END IF
   CLOSE i400_cl
   COMMIT WORK
END FUNCTION 

FUNCTION i400_unconfirm_1()
   DEFINE l_n        LIKE type_file.num5,
          l_lnt26    LIKE lnt_file.lnt26,
          l_lnt48    LIKE lnt_file.lnt48,
          l_lji01    LIKE lji_file.lji01

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_lnt.lnt01 IS NULL OR g_lnt.lntplant IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_lnt.*
     FROM lnt_file
    WHERE lnt01 = g_lnt.lnt01

   #FUN-C50036--start add----------------------
   IF g_lnt.lntpos = '3' OR g_lnt.lntpos = '2' THEN
      CALL cl_err('','alm1623',0)
      RETURN
   END IF 
   #FUN-C50036--end add------------------------ 

    LET l_lnt26 = g_lnt.lnt26
    LET l_lnt48   = g_lnt.lnt48

    IF g_lnt.lnt26 <> 'Y' THEN
       CALL cl_err('','alm1317',0)
       RETURN
    END IF
 
    IF g_lnt.lnt48 = '2' THEN
       CALL cl_err('','alm1163',0)
       RETURN
    END IF

   LET g_cnt = 0
   SELECT COUNT(*) INTO g_cnt FROM lje_file
    WHERE lje04 = g_lnt.lnt01              
   #合同已终止，不可取消审核
   IF g_cnt>0 THEN                          
      #CALL cl_err('','alm1206',0)           #TQC-C30290 mark     
      CALL cl_err('','alm1614',0)            #TQC-C30290 add
      RETURN
   END IF
   #合同已变更，不可取消审核
   SELECT COUNT(*) INTO g_cnt FROM lji_file
     WHERE lji04 = g_lnt.lnt01
       AND lji05 <> 0
   IF g_cnt>0 THEN
      CALL cl_err('','alm1207',0)
      RETURN
   END IF
   #已有合同优惠变更申请
   SELECT COUNT(*) INTO g_cnt FROM lja_file
    WHERE lja05 = g_lnt.lnt01
      AND lja02 = '1'
      AND ljaconf <> 'X'  #CHI-C80041
   IF g_cnt>0 THEN
      CALL cl_err('','alm1331',0)
      RETURN
   END IF
   #已有合同辅助信息变更申请
   SELECT COUNT(*) INTO g_cnt FROM lja_file
    WHERE lja05 = g_lnt.lnt01
      AND lja02 = '2'
      AND ljaconf <> 'X'  #CHI-C80041
   IF g_cnt>0 THEN
      CALL cl_err('','alm1332',0)
      RETURN
   END IF
   #已有合同延期变更申请
   SELECT COUNT(*) INTO g_cnt FROM lja_file
    WHERE lja05 = g_lnt.lnt01
      AND lja02 = '3'
      AND ljaconf <> 'X'  #CHI-C80041
   IF g_cnt>0 THEN
      CALL cl_err('','alm1333',0)
      RETURN
   END IF
   #已有合同面积变更申请
   SELECT COUNT(*) INTO g_cnt FROM lja_file
    WHERE lja05 = g_lnt.lnt01
      AND lja02 = '4'
      AND ljaconf <> 'X'  #CHI-C80041
   IF g_cnt>0 THEN
      CALL cl_err('','alm1334',0)
      RETURN
   END IF
   #该合同已产生费用单，不可取消审核
   SELECT COUNT(*) INTO g_cnt FROM lua_file
    WHERE lua04 = g_lnt.lnt01
   IF g_cnt>0 THEN
      CALL cl_err('','alm-491',0)
      RETURN
   END IF
   LET g_success = 'Y'

   BEGIN WORK
   OPEN i400_cl USING g_lnt.lnt01
   IF STATUS THEN
      CALL cl_err("open i400_cl:",STATUS,1)
      CLOSE i400_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i400_cl INTO g_lnt.*
   IF SQLCA.sqlcode  THEN
      CALL cl_err(g_lnt.lnt01,SQLCA.sqlcode,0)
      CLOSE i400_cl
      ROLLBACK WORK
      RETURN
   END IF

   IF NOT cl_confirm('alm-008') THEN
      RETURN
   ELSE
      IF g_lnt.lntpos = '3' THEN
         LET g_lnt.lntpos = '2'
      END IF
      LET g_lnt.lnt48 = '1'
      LET g_lnt.lnt26 = 'F'
      LET g_lnt.lntmodu = g_user
      LET g_lnt.lntdate = g_today
      #CHI-D20015--modify--str--
      #LET g_lnt.lnt46 = ''
      #LET g_lnt.lnt47 = ''
      LET g_lnt.lnt46 = g_user 
      LET g_lnt.lnt47 = g_today
      #CHI-D20015--modify--str--
      UPDATE lnt_file
         SET lnt26 = g_lnt.lnt26,
             lntmodu = g_lnt.lntmodu ,
             lntdate = g_lnt.lntdate,
             lnt48 = g_lnt.lnt48,
             lnt27 = g_lnt.lnt27,
             lnt28 = g_lnt.lnt28,
             lnt47 = g_lnt.lnt47,
             lnt46 = g_lnt.lnt46,
             lntpos = g_lnt.lntpos
       WHERE lnt01 = g_lnt.lnt01

      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('upd lnt:',SQLCA.sqlcode,0)
         LET g_lnt.lnt48 = l_lnt48
         LET g_lnt.lnt26 = l_lnt26
         DISPLAY BY NAME g_lnt.lnt26,g_lnt.lnt48
         RETURN
      ELSE
         #IF g_lnt.lnt17 <= g_today THEN   #TQC-C20525 mark
         IF g_lnt.lnt17 <= g_today AND g_today <= g_lnt.lnt18 THEN #TQC-C20525 add
            #攤位狀態置為未使用
            UPDATE lmf_file SET lmf05='1'
             WHERE lmf01 = g_lnt.lnt06
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
               CALL cl_err3("upd","lmf_file",g_lnt.lnt06,"",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               RETURN
            END IF
         END IF
         #删除变更单的相关表
         SELECT lji01 INTO l_lji01
           FROM lji_file 
          WHERE lji04 = g_lnt.lnt01
            AND lji05 = '0'
         DELETE FROM ljj_file WHERE ljj01 = l_lji01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","ljj_file",l_lji01,"",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            RETURN
         END IF
         DELETE FROM ljk_file WHERE ljk01 = l_lji01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","ljk_file",l_lji01,"",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            RETURN
         END IF
         DELETE FROM ljl_file WHERE ljl01 = l_lji01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","ljl_file",l_lji01,"",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            RETURN
         END IF
         DELETE FROM ljm_file WHERE ljm01 = l_lji01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","ljm_file",l_lji01,"",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            RETURN
         END IF
         DELETE FROM ljn_file WHERE ljn01 = l_lji01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","ljn_file",l_lji01,"",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            RETURN
         END IF
         DELETE FROM ljo_file WHERE ljo01 = l_lji01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","ljo_file",l_lji01,"",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            RETURN
         END IF
         DELETE FROM lji_file WHERE lji01 = l_lji01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","lji_file",l_lji01,"",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            RETURN
         END IF
         DELETE FROM ljp_file WHERE ljp01 = l_lji01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","ljp_file",l_lji01,"",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            RETURN
         END IF
         DELETE FROM ljq_file WHERE ljq01 = l_lji01 
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","ljq_file",l_lji01,"",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            RETURN
         END IF
         DISPLAY BY NAME g_lnt.lnt26,g_lnt.lnt48,g_lnt.lnt27,g_lnt.lnt28,
                         g_lnt.lnt46,g_lnt.lnt47,g_lnt.lntmodu,g_lnt.lntdate
         DISPLAY '' TO gen02_2
         CALL cl_set_field_pic(g_lnt.lnt26,"","","","","")
      END IF
   END IF
   CLOSE i400_cl
   COMMIT WORK
END FUNCTION

FUNCTION i400_confirm_chk()
   DEFINE l_n LIKE type_file.num5
   LET g_errno = ''
   #在合同租赁日期内是否有其他合同
   SELECT COUNT(*) INTO l_n
     FROM lnt_file 
    WHERE lnt01 <> g_lnt.lnt01
      AND lnt06 = g_lnt.lnt06
      AND lnt26 = 'Y'
      AND (lnt17 BETWEEN g_lnt.lnt17 AND g_lnt.lnt18
       OR  lnt18 BETWEEN g_lnt.lnt17 AND g_lnt.lnt18
       OR  g_lnt.lnt17 BETWEEN lnt17 AND lnt18) 
   IF l_n > 0 THEN
      LET g_errno = 'alm1336'
      RETURN
   END IF  
   #在合同租赁日期内是否有预租协议
   SELECT COUNT(*) INTO l_n
     FROM lih_file 
    WHERE lih07 = g_lnt.lnt06
      AND (lih14 BETWEEN g_lnt.lnt17 AND g_lnt.lnt18
       OR  lih15 BETWEEN g_lnt.lnt17 AND g_lnt.lnt18
       OR  g_lnt.lnt17 BETWEEN lih14 AND lih15)
      AND lihconf <> 'S'
   IF l_n > 0 THEN
      LET g_errno = 'alm1337'
      RETURN
   END IF      
END FUNCTION 

FUNCTION i400_qry_fare()
   DEFINE l_sql     STRING 
   DEFINE l_n       LIKE type_file.num5
   DEFINE l_liw05_s STRING
   DEFINE l_liw05   LIKE liw_file.liw05
   DEFINE l_msg     STRING
   DEFINE l_msg1    STRING
   DEFINE l_liw09   LIKE liw_file.liw09,     #标准费用汇总
          l_liw10   LIKE liw_file.liw10,     #优惠费用汇总
          l_liw11   LIKE liw_file.liw11,     #终止费用汇总
          l_liw12   LIKE liw_file.liw12,     #抹零金额汇总
          l_liw13   LIKE liw_file.liw13,     #实际应收汇总
          l_liw14   LIKE liw_file.liw14,     #已收金额汇总
          l_liw15   LIKE liw_file.liw15,     #清算金额汇总
          l_liw14_desc LIKE liw_file.liw14 #未收金额汇总

   OPEN WINDOW i400_qry_w WITH FORM "alm/42f/almi400_qry"
        ATTRIBUTE(STYLE=g_win_style CLIPPED)
   CALL cl_ui_locale("almi400_qry")
   CALL cl_set_comp_visible("liw18",FALSE) #By shi Mark
   CALL i400_qry_fare_show()
   CALL i400_qry_menu()
   CLOSE WINDOW i400_qry_w
  #IF g_flag = 'Y' THEN
   IF g_lnt.lnt26 = 'N' THEN
      CALL i400_upd()            #更新单头费用
      CALL i400_b_fill()         #更新单身
   END IF 
END FUNCTION 

FUNCTION i400_qry_fare_show()
   DEFINE l_sql     STRING
   DEFINE l_n       LIKE type_file.num5
   DEFINE l_liw05_s STRING
   DEFINE l_liw05   LIKE liw_file.liw05
   DEFINE l_msg     STRING
   DEFINE l_msg1    STRING
   DEFINE l_liw09   LIKE liw_file.liw09,     #标准费用汇总
          l_liw10   LIKE liw_file.liw10,     #优惠费用汇总
          l_liw11   LIKE liw_file.liw11,     #终止费用汇总
          l_liw12   LIKE liw_file.liw12,     #抹零金额汇总
          l_liw13   LIKE liw_file.liw13,     #实际应收汇总
          l_liw14   LIKE liw_file.liw14,     #已收金额汇总
          l_liw15   LIKE liw_file.liw15,     #清算金额汇总
          l_liw14_desc LIKE liw_file.liw14 #未收金额汇总
   LET l_sql = "SELECT liw03,liw04,'','',liw06,liw07,liw08,liw09,liw10,",
               "liw11,liw12,liw13,liw14,'',liw15,liw16,liw18,liw17,liw02 ",
               "  FROM liw_file ",
               " WHERE liw01 = '",g_lnt.lnt01,"'",
               " ORDER BY liw05,liw06,liw04"
   DECLARE sel_liw_cs CURSOR FROM l_sql
   LET l_n = 1
   LET l_liw09 = 0
   LET l_liw10 = 0
   LET l_liw11 = 0
   LET l_liw12 = 0
   LET l_liw13 = 0
   LET l_liw14 = 0
   LET l_liw15 = 0
   LET l_liw14_desc = 0
   CALL g_liw.clear()
   FOREACH sel_liw_cs INTO g_liw[l_n].*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF
      SELECT oaj02 INTO g_liw[l_n].oaj02
        FROM oaj_file
       WHERE oaj01 = g_liw[l_n].liw04
      SELECT liw05 INTO l_liw05
        FROM liw_file
       WHERE liw01 = g_lnt.lnt01
         AND liw03 = g_liw[l_n].liw03
      CALL cl_getmsg('alm1188',g_lang) RETURNING l_msg
      CALL cl_getmsg('alm1189',g_lang) RETURNING l_msg1
      LET l_liw05_s = l_liw05
      LET g_liw[l_n].liw05_desc = l_msg,l_liw05_s.trim(),l_msg1
      IF cl_null(g_liw[l_n].liw09) THEN
         LET g_liw[l_n].liw09 = 0
      END IF
      IF cl_null(g_liw[l_n].liw10) THEN
         LET g_liw[l_n].liw10 = 0
      END IF
      IF cl_null(g_liw[l_n].liw11) THEN
         LET g_liw[l_n].liw11 = 0
      END IF
      IF cl_null(g_liw[l_n].liw12) THEN
         LET g_liw[l_n].liw12 = 0
      END IF
      IF cl_null(g_liw[l_n].liw13) THEN
         LET g_liw[l_n].liw13 = 0
      END IF
      IF cl_null(g_liw[l_n].liw14) THEN
         LET g_liw[l_n].liw14 = 0
      END IF
      IF cl_null(g_liw[l_n].liw15) THEN
         LET g_liw[l_n].liw15 = 0
      END IF
      LET g_liw[l_n].liw14_desc = g_liw[l_n].liw13 - g_liw[l_n].liw14-g_liw[l_n].liw15
      LET l_liw09 = l_liw09 + g_liw[l_n].liw09
      LET l_liw10 = l_liw10 + g_liw[l_n].liw10
      LET l_liw11 = l_liw11 + g_liw[l_n].liw11
      LET l_liw12 = l_liw12 + g_liw[l_n].liw12
      LET l_liw13 = l_liw13 + g_liw[l_n].liw13
      LET l_liw14 = l_liw14 + g_liw[l_n].liw14
      LET l_liw15 = l_liw15 + g_liw[l_n].liw15
      LET l_liw14_desc = l_liw14_desc + g_liw[l_n].liw14_desc
      LET l_n = l_n + 1
   END FOREACH
   CALL g_liw.deleteElement(l_n)
   LET g_rec_b8 = l_n - 1
   DISPLAY l_liw09 TO liw09_c
   DISPLAY l_liw10 TO liw10_c
   DISPLAY l_liw11 TO liw11_c
   DISPLAY l_liw12 TO liw12_c
   DISPLAY l_liw13 TO liw13_c
   DISPLAY l_liw14 TO liw14_c
   DISPLAY l_liw15 TO liw15_c
   DISPLAY l_liw14_desc TO liw14_desc_c

END FUNCTION 

FUNCTION i400_qry_menu()
   WHILE TRUE
      CALL i400_qry_bp("G")
      CASE g_action_choice
         #合同日核算
         WHEN "contract"
            IF g_rec_b8 > 0 THEN
               CALL i400_contract()
            ELSE
               CALL cl_err('',-400,1)
            END IF 
         #费单查询
         WHEN "cost"
            IF g_rec_b8 > 0 THEN 
               LET g_msg = "artt610 '1' '",g_liw[l_ac8].liw16,"' '' ''" 
               CALL cl_cmdrun_wait(g_msg)
            ELSE 
               CALL cl_err('',-400,1)
            END IF            

         #提前出账
         WHEN "ChuZhang"
            IF g_rec_b8 > 0 THEN
                CALL i400_ChuZhang()      
            ELSE  
                CALL cl_err('',-400,1)
            END IF 

         WHEN "exit"
            EXIT WHILE   
      END CASE
   END WHILE
END FUNCTION 

FUNCTION i400_qry_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_liw TO s_liw.* ATTRIBUTE(COUNT=g_rec_b8)
      BEFORE DISPLAY
        CALL cl_navigator_setting( g_curs_index, g_row_count)

      BEFORE ROW
        LET l_ac8 = ARR_CURR()
        CALL cl_show_fld_cont()
      #合同日核算
      ON ACTION contract
         LET g_action_choice="contract"
         EXIT DISPLAY 

      #费用单查询
      ON ACTION cost
         LET g_action_choice="cost"
         EXIT DISPLAY 

      #提前出账
      ON ACTION ChuZhang
         LET g_action_choice="ChuZhang"
         EXIT DISPLAY   
    
      ON ACTION HELP
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION EXIT
         LET g_action_choice="exit"
         EXIT DISPLAY
     
      ON ACTION close
         LET g_action_choice="exit"
         LET INT_FLAG = 0 
         EXIT DISPLAY

      ON ACTION controlg
         CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about
         CALL cl_about()
   END DISPLAY 
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION 

FUNCTION i400_contract()
   DEFINE l_sql   STRING
   DEFINE l_n     LIKE type_file.num5
   DEFINE l_liv06 LIKE liv_file.liv06
          
   OPEN WINDOW i400_5_w WITH FORM "alm/42f/almi400_5"
        ATTRIBUTE(STYLE=g_win_style CLIPPED)
   CALL cl_ui_locale("almi400_5") 
   LET l_sql = "SELECT liv03,liv04,liv05,'',liv06,liv07,liv071,liv08,liv09,liv02",
               "  FROM liv_file ",
               " WHERE liv01 = '",g_lnt.lnt01,"'",
               "   AND liv05 = '",g_liw[l_ac8].liw04,"'",   
               "   AND liv04 BETWEEN '",g_liw[l_ac8].liw07,"'",
               "                 AND '",g_liw[l_ac8].liw08,"'",
               "   AND liv02 = '",g_liw[l_ac8].liw02,"'",
               " ORDER BY liv04"   
   DECLARE sel_liv_cs CURSOR FROM l_sql
   CALL g_liv.clear()
   LET l_n = 1
   LET l_liv06 = 0
   FOREACH sel_liv_cs INTO g_liv[l_n].*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF       
      SELECT oaj02 INTO g_liv[l_n].oaj02
        FROM oaj_file
       WHERE oaj01 = g_liv[l_n].liv05
      LET l_liv06 = l_liv06 + g_liv[l_n].liv06
      LET l_n = l_n + 1
   END FOREACH  
   LET g_rec_b9 = l_n - 1
   CALL g_liv.deleteElement(l_n)
   DISPLAY l_liv06 TO liv06_c
   CALL i400_5_menu() 
   CLOSE WINDOW i400_5_w
  #IF g_flag = 'Y' THEN
      CALL i400_qry_fare_show()   #显示账单
  #END IF 
END FUNCTION 

FUNCTION i400_5_menu()
   WHILE TRUE
      CALL i400_5_bp("G")
      CASE g_action_choice
         WHEN "exit"
            EXIT WHILE
         WHEN "detail"
            CALL i400_5_b()
            IF g_flag = 'Y' THEN
               CALL i400sub_generate_bill(g_lnt.lnt01,'1')
            END IF 
      END CASE
   END WHILE

END FUNCTION 

FUNCTION i400_5_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_liv TO s_liv.* ATTRIBUTE(COUNT=g_rec_b9)
      BEFORE DISPLAY
        CALL cl_navigator_setting( g_curs_index, g_row_count)
   
      BEFORE ROW
        LET l_ac9 = ARR_CURR()
        CALL cl_show_fld_cont()

      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY

      ON ACTION ACCEPT
         LET g_action_choice="detail"
         LET l_ac11 = ARR_CURR()
         EXIT DISPLAY


      ON ACTION HELP
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION EXIT
         LET g_action_choice="exit"
         LET INT_FLAG = 0
         EXIT DISPLAY

      ON ACTION close
         LET g_action_choice="exit"
         LET INT_FLAG = 0
         EXIT DISPLAY 

      ON ACTION controlg
         CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about
         CALL cl_about()
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION 

FUNCTION i400_ChuZhang()
   DEFINE l_sql     STRING
   DEFINE l_msg     STRING
   DEFINE l_msg1    STRING
   DEFINE l_liw05_s STRING
   DEFINE l_liw05   LIKE liw_file.liw05
   DEFINE l_n       LIKE type_file.num5
   DEFINE l_n1      LIKE type_file.num5
   DEFINE l_flag    LIKE type_file.chr1
   DEFINE l_liw     DYNAMIC ARRAY OF RECORD                   #提前出账
                      liw05        LIKE liw_file.liw05,
                      liw06        LIKE liw_file.liw06
                    END RECORD
   IF g_lnt.lnt26 <> 'Y' THEN 
      CALL cl_err('','alm1303',0)
      RETURN
   END IF 
   LET l_sql = "SELECT DISTINCT liw05,liw06",
               "  FROM liw_file",
               " WHERE liw01 = '",g_lnt.lnt01,"'",
               "   AND liw17 = 'N'",
               "   AND liw16 IS NULL",
               " ORDER BY liw05,liw06"
   DECLARE sel_liw_cs_2 CURSOR FROM l_sql
   CALL g_liw1.clear()
   LET l_n = 1
   FOREACH sel_liw_cs_2 INTO l_liw[l_n].*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF
      SELECT DISTINCT liw05 INTO l_liw05 
        FROM liw_file 
       WHERE liw01 = g_lnt.lnt01
         AND liw17 = 'N'
         AND liw16 IS NULL
         AND liw06 = l_liw[l_n].liw06
      CALL cl_getmsg('alm1188',g_lang) RETURNING l_msg
      CALL cl_getmsg('alm1189',g_lang) RETURNING l_msg1
      LET l_liw05_s = l_liw05 
      LET g_liw1[l_n].liw05_desc = l_msg,l_liw05_s.trim(),l_msg1
      LET g_liw1[l_n].liw06 = l_liw[l_n].liw06
      LET g_liw1[l_n].chk = 'N'
      LET l_n = l_n + 1
   END FOREACH
   CALL g_liw1.deleteElement(l_n)
   CALL l_liw.deleteElement(l_n)
   LET g_rec_b10 = l_n - 1 
   IF g_rec_b10 = 0  THEN
      CALL cl_err('','alm1272',0)           #都已产生费用单，不需再次产生 
      RETURN 
   END IF 
   OPEN WINDOW i400_6_w WITH FORM "alm/42f/almi400_6"
        ATTRIBUTE(STYLE=g_win_style CLIPPED)
   CALL cl_ui_locale("almi400_6")
   DISPLAY g_rec_b10 TO FORMONLY.cnt
   CALL i400_b_6()
   IF g_close = 'N' THEN 
      BEGIN WORK
      LET g_success = 'Y'
      CALL s_showmsg_init()
      LET l_n1 = 1
      WHILE TRUE
         IF g_liw1[l_n1].chk = 'Y' THEN
            SELECT DISTINCT liw05 INTO l_liw05
              FROM liw_file
             WHERE liw01 = g_lnt.lnt01
               AND liw17 = 'N'
               AND liw16 IS NULL
               AND liw06 = g_liw1[l_n1].liw06
            CALL i400sub_gen_expense_bill(g_lnt.lnt01,l_liw05,g_liw1[l_n1].liw06,g_lnt.lntplant)
            IF g_success = 'N' THEN
               EXIT WHILE
            END IF 
            LET l_flag = 'Y'
         END IF
         LET l_n1 = l_n1 + 1
         IF l_n1 > g_rec_b10 THEN
            EXIT WHILE
         END IF
      END WHILE
      CLOSE WINDOW i400_6_w
      CALL s_showmsg()
      IF g_success = 'N' THEN
         CALL cl_err('','alm1341',0)
         ROLLBACK WORK
      ELSE 
         IF l_flag = 'Y' THEN
            COMMIT WORK 
            CALL cl_err('','alm1340',0)
         END IF
      END IF
   ELSE 
      CLOSE WINDOW i400_6_w
   END IF 
   CALL i400_qry_fare_show()
END FUNCTION

FUNCTION i400_choicesall()
   DEFINE l_n             LIKE type_file.num5
   LET l_n = 1
   WHILE TRUE
      LET g_liw1[l_n].chk = 'Y'
      LET l_n = l_n + 1
      IF l_n > g_rec_b10 THEN
         EXIT WHILE
      END IF
   END WHILE   
END FUNCTION 

FUNCTION i400_undo_choicesall()
   DEFINE l_n             LIKE type_file.num5
   LET l_n = 1
   WHILE TRUE
      LET g_liw1[l_n].chk = 'N'
      LET l_n = l_n + 1
      IF l_n > g_rec_b10 THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION

FUNCTION i400_b_6()
   DEFINE l_n             LIKE type_file.num5,
          l_lock_sw       LIKE type_file.chr1,
          l_allow_insert  LIKE type_file.num5,
          l_allow_delete  LIKE type_file.num5
   DEFINE l_cnt           LIKE type_file.num5      #FUN-C20078 add 
   LET g_action_choice = " "
   LET g_close = 'N'
   LET l_allow_insert = FALSE
   LET l_allow_delete = FALSE
   INPUT ARRAY g_liw1 WITHOUT DEFAULTS FROM s_liw_1.*
      ATTRIBUTE (COUNT=g_rec_b10,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

      BEFORE INPUT
         IF g_rec_b10 != 0 THEN
            CALL fgl_set_arr_curr(l_ac10)
         END IF

      BEFORE ROW
         LET l_ac10 = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n  = ARR_COUNT()
         IF g_rec_b10 >= l_ac10 THEN
            LET g_before_input_done = FALSE
            LET g_before_input_done = TRUE
            CALL cl_show_fld_cont()
         END IF

      AFTER FIELD chk
         IF l_ac10 > 1 THEN 
            IF g_liw1[l_ac10-1].chk <> 'Y' AND g_liw1[l_ac10].chk = 'Y' THEN
               CALL cl_err('','alm1273',0)
               LET g_liw1[l_ac10].chk = 'N'
               NEXT FIELD chk
            END IF
         END IF  
         IF l_ac10 < g_rec_b10 THEN
            IF g_liw1[l_ac10].chk = 'N' AND g_liw1[l_ac10+1].chk = 'Y' THEN 
                CALL cl_err('','alm1273',0)   #不可跳选 
                LET g_liw1[l_ac10].chk = 'Y'
                NEXT FIELD chk      
            END IF 
         END IF 
#FUN-C20078 add begin ----
         IF g_liw1[l_ac10].chk = 'Y' THEN
            SELECT COUNT(*) INTO l_cnt
              FROM liw_file 
             WHERE liw01 = g_lnt.lnt01 
               AND liw13 = 0 
               AND liw06 = g_liw1[l_ac10].liw06
            IF l_cnt > 0 THEN
               CALL cl_err('','alm1584',0)
               LET g_liw1[l_ac10].chk = 'N'
               NEXT FIELD chk
            END IF 
         END IF 
#FUN-C20078 add end ---               
      AFTER ROW
         LET l_ac10 = ARR_CURR()
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            EXIT INPUT
         END IF

      ON ACTION accept
         ACCEPT INPUT

      ON ACTION choicesall
         CALL i400_choicesall()     
         CONTINUE INPUT

      ON ACTION undo_choicesall
         CALL i400_undo_choicesall()
         CONTINUE INPUT

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION close
         LET INT_FLAG=1
         LET g_close = 'Y'       
         EXIT INPUT 
 
      ON ACTION cancel
         LET INT_FLAG=1
         LET g_close = 'Y'
         EXIT INPUT

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
   END INPUT
END FUNCTION 

FUNCTION i400_b3_accounting()
   DEFINE l_sql         STRING 
   DEFINE l_date        LIKE lnw_file.lnw08
   DEFINE l_liv06       LIKE liv_file.liv06
   DEFINE l_sum_lnw06   LIKE lnw_file.lnw06
   DEFINE l_sum_lnv07   LIKE lnv_file.lnv07
   DEFINE l_sum         LIKE lnv_file.lnv07
   DEFINE l_differences LIKE liv_file.liv06
   DEFINE l_lij05       LIKE lij_file.lij05
   DEFINE l_lnw   RECORD LIKE lnw_file.*
   DEFINE l_liv   RECORD LIKE liv_file.*
   LET l_sql = "SELECT * ",
               "  FROM lnw_file ",
               " WHERE lnw01 = '",g_lnt.lnt01,"' ORDER BY lnw11"
   DECLARE l_selfree_cur_1 CURSOR FROM l_sql
   BEGIN WORK
   #先删除旧的日核算
   DELETE FROM liv_file WHERE liv01 = g_lnt.lnt01
                          AND liv08 = '1'
                          AND liv05 IN (SELECT lnw03 FROM lnw_file WHERE lnw01 = g_lnt.lnt01)
   IF SQLCA.sqlcode THEN
      CALL cl_err3("del","liv_file",g_lnt.lnt01,"",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
      RETURN
   END IF 
   DELETE FROM lnw_file
    WHERE lnw06 = 0
      AND lnw01 = g_lnt.lnt01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("del","lnw_file",g_lnt.lnt01,"",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
      RETURN
   END IF
   #产生其他费用标准日核算
   FOREACH l_selfree_cur_1 INTO l_lnw.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach l_selfree_cur_1',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT lij05 INTO l_lij05 
        FROM lij_file
       WHERE lij01 = g_lnt.lnt71
         AND lij02 = l_lnw.lnw03     
      IF l_lij05 = '1' THEN                             #如果是收付实现制，直接将金额写到第一笔数据
         SELECT MAX(liv03) + 1 INTO l_liv.liv03
           FROM liv_file
          WHERE liv01 = g_lnt.lnt01
         IF cl_null(l_liv.liv03) THEN
            LET l_liv.liv03 = 1
         END IF        
         LET l_liv.liv01 = g_lnt.lnt01
         LET l_liv.liv02 = l_lnw.lnw02
         LET l_liv.liv04 = l_lnw.lnw08
         LET l_liv.liv05 = l_lnw.lnw03
         LET l_liv.liv06 = l_lnw.lnw06
         LET l_liv.liv07 = ''
         LET l_liv.liv071= ''
         LET l_liv.liv08 = '1'
         LET l_liv.liv09 = '0'
         LET l_liv.livlegal = g_legal
         LET l_liv.livplant = g_plant
         #插入新的日核算
         INSERT INTO liv_file VALUES l_liv.*
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","liv_file",l_lnw.lnw11,"",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            RETURN
         END IF   
      ELSE 
         #计算日核算
         LET l_lnw.lnw06 = cl_digcut(l_lnw.lnw06,g_lla04)
         LET l_liv06 = l_lnw.lnw06 / (l_lnw.lnw09 - l_lnw.lnw08 + 1)
         LET l_liv06 = cl_digcut(l_liv06,g_lla04)
         LET l_date = l_lnw.lnw08
         WHILE TRUE
            SELECT MAX(liv03) + 1 INTO l_liv.liv03
              FROM liv_file
             WHERE liv01 = g_lnt.lnt01
            IF cl_null(l_liv.liv03) THEN
               LET l_liv.liv03 = 1
            END IF 
            LET l_liv.liv01 = g_lnt.lnt01
            LET l_liv.liv02 = l_lnw.lnw02
            LET l_liv.liv04 = l_date
            LET l_liv.liv05 = l_lnw.lnw03
            LET l_liv.liv06 = l_liv06
            LET l_liv.liv07 = ''
            LET l_liv.liv071= ''
            LET l_liv.liv08 = '1'
            LET l_liv.liv09 = '0' 
            LET l_liv.livlegal = g_legal
            LET l_liv.livplant = g_plant
            #插入新的日核算
            INSERT INTO liv_file VALUES l_liv.*
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","liv_file",l_lnw.lnw11,"",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               RETURN
            END IF
            LET l_date = l_date + 1
            IF l_date > l_lnw.lnw09 THEN
               EXIT WHILE
            END IF
         END WHILE
         #差异计算
         LET l_differences = l_lnw.lnw06 - l_liv06 * (l_lnw.lnw09 - l_lnw.lnw08 + 1) 
         LET l_differences = cl_digcut(l_differences,g_lla04)
         IF g_lla01 = '2' THEN
         #将差异合并到最后一天
            UPDATE liv_file SET liv06 = l_liv06 + l_differences
             WHERE liv01 = g_lnt.lnt01
               AND liv05 = l_lnw.lnw03 
               AND liv08 = '1' 
               AND liv04 = l_lnw.lnw09
            IF SQLCA.sqlerrd[3]=0 THEN
               CALL cl_err3("upd","liv_file",g_lnt.lnt01,"",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK  
               RETURN
            END IF 
        END IF 
        IF g_lla01 = '1' THEN
           #将差异合并到第一天
           UPDATE liv_file SET liv06 = l_liv06 + l_differences
            WHERE liv01 = g_lnt.lnt01
              AND liv05 = l_lnw.lnw03
              AND liv08 = '1'
              AND liv04 = l_lnw.lnw08
           IF SQLCA.sqlerrd[3]=0 THEN
              CALL cl_err3("upd","liv_file",g_lnt.lnt01,"",SQLCA.sqlcode,"","",1)
              ROLLBACK WORK
              RETURN
           END IF
        END IF
     END IF 
   END FOREACH
   #更新单头费用栏位的值
   CALL i400_upd() 
   COMMIT WORK
END FUNCTION 

#更新单头费用栏位的值
FUNCTION i400_upd()
DEFINE l_sum_liv06   LIKE liv_file.liv06
DEFINE l_sum_liv06_1 LIKE liv_file.liv06
DEFINE l_sum_liv06_2 LIKE liv_file.liv06
DEFINE l_sum_liv06_3 LIKE liv_file.liv06
   SELECT SUM(liv06) INTO l_sum_liv06                       #抓取标准费用金额总和 
     FROM liv_file
    WHERE liv01 = g_lnt.lnt01
      AND liv08 = '1'
   IF cl_null(l_sum_liv06) THEN
      LET l_sum_liv06 = 0
   END IF 

   SELECT SUM(liv06) INTO l_sum_liv06_1                     #抓取优惠费用金额总和
     FROM liv_file 
    WHERE liv01 = g_lnt.lnt01
      AND liv08 = '2'
   IF cl_null(l_sum_liv06_1) THEN
      LET l_sum_liv06_1 = 0
   END IF

   SELECT SUM(liv06) INTO l_sum_liv06_2                     #抓取终止费用金额总和
     FROM liv_file
    WHERE liv01 = g_lnt.lnt01
      AND liv08 = '3'
   IF cl_null(l_sum_liv06_2) THEN
      LET l_sum_liv06_2 = 0
   END IF

   SELECT SUM(liv06) INTO l_sum_liv06_3                     #抓取抹零费用金额总和
     FROM liv_file
    WHERE liv01 = g_lnt.lnt01
      AND liv08 = '4'
   IF cl_null(l_sum_liv06_3) THEN
      LET l_sum_liv06_3 = 0
   END IF
   
   SELECT SUM(liv06) INTO g_lnt.lnt66                        #抓取质保金费用总和
     FROM liv_file 
    WHERE liv01 = g_lnt.lnt01
      AND liv08 = '1'
      AND (liv05 IN (SELECT lnv04 FROM lnv_file,oaj_file WHERE lnv01 = g_lnt.lnt01
                                                          AND lnv04 = oaj01
                                                          AND oaj05 = '01') 
       OR liv05 IN (SELECT lnw03 FROM lnw_file,oaj_file WHERE lnw01 = g_lnt.lnt01
                                                          AND lnw03 = oaj01
                                                          AND oaj05 = '01')
       OR liv05 IN (SELECT lit04 FROM lit_file,oaj_file WHERE lit01 = g_lnt.lnt01
                                                          AND lit04 = oaj01
                                                          AND oaj05 = '01')) 
   IF cl_null(g_lnt.lnt66) THEN
      LET g_lnt.lnt66 = 0
   END IF
   LET g_lnt.lnt64 = l_sum_liv06 - g_lnt.lnt66
   LET g_lnt.lnt65 = l_sum_liv06_1
   LET g_lnt.lnt67 = l_sum_liv06_2
   LET g_lnt.lnt68 = l_sum_liv06_3
   #LET g_lnt.lnt69 = g_lnt.lnt64 + g_lnt.lnt65 + g_lnt.lnt66 +                             #FUN-C80006 mark
   #                  g_lnt.lnt67 + g_lnt.lnt68                                             #FUN-C80006 mark
   LET g_lnt.lnt69 = g_lnt.lnt64 - g_lnt.lnt65 + g_lnt.lnt66 + g_lnt.lnt67 + g_lnt.lnt68    #FUN-C80006 add
   UPDATE lnt_file SET lnt64 = g_lnt.lnt64,
                       lnt65 = g_lnt.lnt65,
                       lnt66 = g_lnt.lnt66,
                       lnt67 = g_lnt.lnt67,
                       lnt68 = g_lnt.lnt68,
                       lnt69 = g_lnt.lnt69
             WHERE lnt01 = g_lnt.lnt01
   SELECT * INTO g_lnt.* FROM lnt_file WHERE lnt01 = g_lnt.lnt01   
   DISPLAY BY NAME g_lnt.lnt64,g_lnt.lnt65,g_lnt.lnt66,g_lnt.lnt67,g_lnt.lnt68,g_lnt.lnt69
END FUNCTION 

FUNCTION i400_set_entry_b3(p_cmd)
DEFINE p_cmd    LIKE type_file.chr1
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("lnw11,lnw03,lnw06",TRUE)
   END IF 
END FUNCTION 

FUNCTION i400_set_no_entry_b3(p_cmd)
DEFINE p_cmd    LIKE type_file.chr1
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("lnw11,lnw03",FALSE)
   END IF
END FUNCTION 

FUNCTION i400_5_b()
DEFINE l_ac11_t        LIKE type_file.num5,
       l_n             LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,
       p_cmd           LIKE type_file.chr1,
       l_allow_insert  LIKE type_file.chr1,
       l_allow_delete  LIKE type_file.chr1
DEFINE l_liv06         LIKE liv_file.liv06
DEFINE l_lla02         LIKE lla_file.lla02
   LET g_action_choice = ""
   IF g_lnt.lnt26 <> 'N' THEN
      CALL cl_err(g_lnt.lnt01,'alm1505',0)
      RETURN
   END IF
   SELECT lla02 INTO l_lla02 
     FROM lla_file
    WHERE llastore = g_lnt.lntplant
   IF l_lla02 <> 'Y' THEN
      CALL cl_err(g_lnt.lnt01,'alm1506',0)
      RETURN
   END IF        
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_lnt.* FROM lnt_file
    WHERE lnt01 = g_lnt.lnt01
   LET l_allow_insert = FALSE
   LET l_allow_delete = FALSE
   LET g_flag = 'N'
   LET g_forupd_sql = "SELECT liv03,liv04,liv05,'',liv06,liv07,liv071,liv08,liv09,liv02 ",
                      "  FROM liv_file ",
                      " WHERE liv01 = '",g_lnt.lnt01,"'",
                      "   AND liv03 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i400_bcl_11 CURSOR FROM g_forupd_sql      # LOCK CURSOR
      INPUT ARRAY g_liv WITHOUT DEFAULTS FROM s_liv.*
         ATTRIBUTE (COUNT=g_rec_b9,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

         BEFORE INPUT
            IF g_rec_b9!= 0 THEN
               CALL fgl_set_arr_curr(l_ac11)
            END IF

         BEFORE ROW
            LET p_cmd=''
            LET l_ac11 = ARR_CURR()
            LET l_lock_sw = 'N'
            LET l_n  = ARR_COUNT()
            BEGIN WORK
            OPEN i400_cl USING g_lnt.lnt01
            IF STATUS THEN
               CALL cl_err("OPEN i400_cl:", STATUS, 1)
               CLOSE i400_cl
               ROLLBACK WORK
               RETURN
            END IF

            FETCH i400_cl INTO g_lnt.*
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_lnt.lnt01,SQLCA.sqlcode,0)
               CLOSE i400_cl
               ROLLBACK WORK
               RETURN
            END IF
            LET g_success = 'N'
            IF g_rec_b9>=l_ac11 THEN
               LET p_cmd='u'
               LET g_before_input_done = FALSE
               LET g_before_input_done = TRUE
               LET g_liv_t.* = g_liv[l_ac11].*
               CLOSE i400_bcl_11
               OPEN i400_bcl_11 USING g_liv_t.liv03
               IF STATUS THEN
                  CALL cl_err("OPEN i400_bcl_11:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i400_bcl_11 INTO g_liv[l_ac11].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_liv_t.liv03,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE
                    SELECT oaj02 INTO g_liv[l_ac11].oaj02
                      FROM oaj_file
                     WHERE oaj01 = g_liv[l_ac11].liv05
                  END IF
               END IF
               CALL cl_show_fld_cont()
            END IF

         AFTER FIELD liv06 
            IF g_liv[l_ac11].liv08 = '4' THEN
               IF g_liv[l_ac11].liv06 != g_liv_t.liv06 THEN  
                    CALL cl_err('','alm1507',0)
                    LET g_liv[l_ac11].liv06 = g_liv_t.liv06
                    NEXT FIELD liv06
               END IF 
            END IF
    
         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_liv[l_ac11].* = g_liv_t.*
               CLOSE i400_bcl_11
               ROLLBACK WORK
               EXIT INPUT
            END IF

            IF l_lock_sw="Y" THEN
               CALL cl_err(g_liv[l_ac11].liv03,-263,0)
               LET g_liv[l_ac11].* = g_liv_t.*
            ELSE
               UPDATE liv_file SET liv06 = g_liv[l_ac11].liv06
                             WHERE liv01 = g_lnt_t.lnt01
                               AND liv03 = g_liv_t.liv03
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","liv_file",g_liv_t.liv03,"",SQLCA.sqlcode,"","",1)
                  LET g_liv[l_ac11].* = g_liv_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  SELECT SUM(liv06) INTO l_liv06
                    FROM liv_file 
                   WHERE liv01 = g_lnt_t.lnt01
                     AND liv05 = g_liw[l_ac8].liw04
                     AND liv04 BETWEEN g_liw[l_ac8].liw07 AND g_liw[l_ac8].liw08
                     AND liv02 = g_liw[l_ac8].liw02
                  DISPLAY l_liv06 TO liv06_c
                  LET g_flag = 'Y'
                  LET g_success = 'Y'
                  IF NOT cl_null(g_liv[l_ac11].liv07) AND g_liv[l_ac11].liv08 = '1' THEN 
                     CALL i400_upd_lnv()     #更新标准费用单身
                  END IF 
                  IF cl_null(g_liv[l_ac11].liv07) AND g_liv[l_ac11].liv08 = '1' THEN
                     CALL i400_upd_lnw()     #更新其他费用单身
                  END IF 
                  IF g_liv[l_ac11].liv08 = '2' THEN 
                     CALL i400_upd_lit()     #更新优惠标准单身
                  END IF 
                  IF g_success = 'Y' THEN
                     COMMIT WORK
                  ELSE 
                     LET g_liv[l_ac11].* = g_liv_t.*
                     ROLLBACK WORK
                     EXIT INPUT
                  END IF 
               END IF
            END IF

         AFTER ROW
            LET l_ac11 = ARR_CURR()
           #LET l_ac11_t = l_ac11          #FUN-D30033

            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_liv[l_ac11].* = g_liv_t.*
               #FUN-D30033----add--str
               ELSE
                  CALL g_liv.deleteElement(l_ac11)
                  IF g_rec_b9 != 0 THEN
                     LET g_action_choice = "detail"
                  END IF
            #FUN-D30033---add--end
               END IF
               CLOSE i400_bcl_11
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac11_t = l_ac11          #FUN-D30033
            CLOSE i400_bcl_11
            COMMIT WORK

      ON ACTION accept
         ACCEPT INPUT

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
   END INPUT
   CLOSE i400_bcl_11

END FUNCTION 

FUNCTION i400_upd_lnv()     #更新标准费用单身
   DEFINE l_liv06  LIKE liv_file.liv06
   LET l_liv06 = g_liv[l_ac11].liv06 - g_liv_t.liv06
   UPDATE lnv_file SET lnv07 = lnv07 + l_liv06
    WHERE lnv01 = g_lnt.lnt01
      AND lnv04 = g_liv[l_ac11].liv05
      AND lnv18 = g_liv[l_ac11].liv07
      AND g_liv[l_ac11].liv04 BETWEEN lnv16 AND lnv17
   IF SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("upd","lnv_file",g_lnt.lnt01,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
   END IF
END FUNCTION 

FUNCTION i400_upd_lnw()     #更新其他费用单身
   DEFINE l_liv06  LIKE liv_file.liv06
   LET l_liv06 = g_liv[l_ac11].liv06 - g_liv_t.liv06
   UPDATE lnw_file SET lnw06 = lnw06 + l_liv06
    WHERE lnw01 = g_lnt.lnt01
      AND lnw03 = g_liv[l_ac11].liv05
      AND g_liv[l_ac11].liv04 BETWEEN lnw08 AND lnw09
   IF SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("upd","lnw_file",g_lnt.lnt01,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
   END IF
END FUNCTION 

FUNCTION i400_upd_lit()     #更新优惠标准单身
   DEFINE l_liv06  LIKE liv_file.liv06
   LET l_liv06 = g_liv[l_ac11].liv06 - g_liv_t.liv06
   UPDATE lit_file SET lit08 = lit08 + l_liv06
    WHERE lit01 = g_lnt.lnt01
      AND lit04 = g_liv[l_ac11].liv05
      AND lit05 = g_liv[l_ac11].liv07
      AND g_liv[l_ac11].liv04 BETWEEN lit06 AND lit07
   IF SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("upd","lit_file",g_lnt.lnt01,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
   END IF
END FUNCTION 


#FUN-BA0118 Begin--- By shi
FUNCTION i400_standards()

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_lnt.lnt01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_lnt.* FROM lnt_file
    WHERE lnt01=g_lnt.lnt01

   #合同已初审或者终审,不可以重新产生标准费用
   IF g_lnt.lnt26 <> 'N' THEN
      CALL cl_err(g_lnt.lnt01,'alm1146',0)
      LET g_success = 'N'
      RETURN
   END IF
   #已经产生费用单不可重新产生标准费用
   SELECT COUNT(*) INTO g_cnt FROM liw_file
    WHERE liw01 = g_lnt.lnt01
      AND liw16 IS NOT NULL
   IF g_cnt > 0 THEN
      CALL cl_err(g_lnt.lnt01,'alm1147',0)
      LET g_success = 'N'
      RETURN
   END IF

   #单头合同费用项方案必须设置
   IF cl_null(g_lnt.lnt71) THEN
      CALL cl_err(g_lnt.lnt01,'alm1148',0)
      LET g_success = 'N'
      RETURN
   END IF

   #合同费用项方案需设置正确,需要存在标准费用，摊位用途须一致
   LET g_cnt = 0
   SELECT COUNT(*) INTO g_cnt FROM lii_file,lij_file
    WHERE lii01 = lij01
      AND lii01 = g_lnt.lnt71
      AND lii05 = g_lnt.lnt55
      AND liiplant = g_lnt.lntplant
      AND lij06 = 'Y'
      AND liiconf <> 'X'  #CHI-C80041
   IF g_cnt = 0 THEN
      CALL cl_err('','alm1149',0)
      LET g_success = 'N'
      RETURN
   END IF

   CALL i400sub_standard('1',g_lnt.lnt01,g_lnt.lnt21,g_lnt.lnt22)
  #CALL i400_show()

END FUNCTION

#FUN-CA0081 Add Begin ---
FUNCTION i400_chk_liu06()
DEFINE l_cnt   LIKE type_file.num5
DEFINE l_lnr03 LIKE lnr_file.lnr03

   INITIALIZE g_errno TO NULL
   SELECT lnr03 INTO l_lnr03 FROM lnr_file WHERE lnr01 = g_liu[l_ac4].liu05
   IF cl_null(l_lnr03) OR l_lnr03 <= 0 THEN LET l_lnr03 = 1 END IF

   IF g_liu[l_ac4].liu06 < l_lnr03 THEN
      SELECT COUNT(*) INTO l_cnt
        FROM lil_file
       WHERE lil00 = '2'
         AND lil01 IN (SELECT lnv18
                         FROM lnv_file,liu_file
                        WHERE lnv01 = liu01
                          AND lnv04 = g_liu[l_ac4].liu04
                          AND liu01 = g_lnt.lnt01)

      IF l_cnt > 0 THEN
         LET g_errno = 'alm1583'
      END IF
      SELECT COUNT(*) INTO l_cnt
        FROM lip_file
       WHERE lip04 = '2'
         AND lip01 IN (SELECT lnv18
                         FROM lnv_file,liu_file
                        WHERE lnv01 = liu01
                          AND lnv04 = g_liu[l_ac4].liu04
                          AND liu01 = g_lnt.lnt01)
      IF l_cnt > 0 THEN
         LET g_errno = 'alm1583'
      END IF
   END IF
END FUNCTION
#FUN-CA0081 Add End -----

#FUN-BA0118 End-----
