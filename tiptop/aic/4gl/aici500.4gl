# Prog. Version..: '5.30.06-13.04.22(00004)'     #
# Pattern name...: aici500.4gl
# Descriptions...: ICD工單開立作業
# Date & Author..: NO:FUN-CA0022 12/10/15 By bart
# Modify.........: No.CHI-C90006 12/11/13 By bart 失效判斷
# Modify.........: No.FUN-CC0077 12/12/11 By Nicola 拉出來另單過單
# Modify.........: No:CHI-D20010 13/02/19 By yangtt 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No.FUN-D40030 13/04/07 By xuxz 單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../4gl/aici500.global"

DEFINE g_idu01_t           LIKE idu_file.idu01,   
       g_idv18             LIKE idv_file.idv18,    
       g_rec_b3            LIKE type_file.num5,
       g_cnt_p             LIKE type_file.num5,
       #g_str               STRING,
       g_wc,g_wc2,g_sql    STRING,
       g_sfb01             LIKE sfb_file.sfb01,
    g_idv           DYNAMIC ARRAY OF RECORD        #程式變數(Program Variables)
        idv02       LIKE idv_file.idv02,       #項次
        idv13       LIKE idv_file.idv13,   #領用料號
        ima02_1     LIKE ima_file.ima02,       #品名
        idv12       LIKE idv_file.idv12,   #工程量產區分
        idv14       LIKE idv_file.idv14,   #倉庫      
        idv15       LIKE idv_file.idv15,   #儲位     
        idv16       LIKE idv_file.idv16,   #批號     
        idv23       LIKE idv_file.idv23,   #DATECODE
        idv17       LIKE idv_file.idv17,   #領用單位
        idv18       LIKE idv_file.idv18,   #領用數量
        idv19       LIKE idv_file.idv19,   #參考領用單位
        idv20       LIKE idv_file.idv20,   #參考領用數量
        idv21       LIKE idv_file.idv21,   #作業編號
        idv03       LIKE idv_file.idv03,       #生產料號  
        idv31       LIKE idv_file.idv31,   #客戶料號  
        idv32       LIKE idv_file.idv32,   #WBS編號
        idv25       LIKE idv_file.idv25,   #單位    
        idv26       LIKE idv_file.idv26,   #生產數量
        idv27       LIKE idv_file.idv27,   #參考單位
        idv28       LIKE idv_file.idv28,   #參考數量
        idv04       LIKE idv_file.idv04,       #交貨日
        idv22       LIKE idv_file.idv22,   #製程    
        idv29       LIKE idv_file.idv29,   #下階段廠商
        pmc03_2     LIKE pmc_file.pmc03,       #廠商名稱
        idv24       LIKE idv_file.idv24,   #回貨批號
        idv30       LIKE idv_file.idv30,   #備註
        idv09       LIKE idv_file.idv09
                    END RECORD,
    g_idv_t         RECORD                         #程式變數 (舊值)
        idv02       LIKE idv_file.idv02,       #項次
        idv13       LIKE idv_file.idv13,   #領用料號
        ima02_1     LIKE ima_file.ima02,       #品名
        idv12       LIKE idv_file.idv12,   #工程量產區分
        idv14       LIKE idv_file.idv14,   #倉庫      
        idv15       LIKE idv_file.idv15,   #儲位     
        idv16       LIKE idv_file.idv16,   #批號     
        idv23       LIKE idv_file.idv23,   #DATECODE
        idv17       LIKE idv_file.idv17,   #領用單位
        idv18       LIKE idv_file.idv18,   #領用數量
        idv19       LIKE idv_file.idv19,   #參考領用單位
        idv20       LIKE idv_file.idv20,   #參考領用數量
        idv21       LIKE idv_file.idv21,   #作業編號
        idv03       LIKE idv_file.idv03,       #生產料號
        idv31       LIKE idv_file.idv31,   #客戶料號  
        idv32       LIKE idv_file.idv32,   #WBS編號
        idv25       LIKE idv_file.idv25,   #單位    
        idv26       LIKE idv_file.idv26,   #生產數量
        idv27       LIKE idv_file.idv27,   #參考單位
        idv28       LIKE idv_file.idv28,   #參考數量
        idv04       LIKE idv_file.idv04,       #交貨日
        idv22       LIKE idv_file.idv22,   #製程    
        idv29       LIKE idv_file.idv29,   #下階段廠商
        pmc03_2     LIKE pmc_file.pmc03,       #廠商名稱
        idv24       LIKE idv_file.idv24,   #回貨批號
        idv30       LIKE idv_file.idv30,   #備註
        idv09       LIKE idv_file.idv09
                    END RECORD,
    g_buf           LIKE type_file.chr1000,           
    g_argv1         LIKE oea_file.oea01,        
    g_t1            LIKE oay_file.oayslip,              
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT      
DEFINE g_forupd_sql STRING   
DEFINE g_before_input_done  LIKE type_file.num5          
DEFINE   g_void         LIKE type_file.chr1      
DEFINE   g_confirm      LIKE type_file.chr1 
DEFINE   g_chr          LIKE type_file.chr1          
DEFINE   g_cnt          LIKE type_file.num10           
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose       
DEFINE   g_msg          LIKE type_file.chr1000       
DEFINE   g_row_count    LIKE type_file.num10        
DEFINE   g_curs_index   LIKE type_file.num10        
DEFINE   mi_no_ask      LIKE type_file.num5 
DEFINE   g_jump         LIKE type_file.num10       
DEFINE   g_cmd          LIKE type_file.chr100       
DEFINE   g_pmc03        LIKE pmc_file.pmc03,
         g_pmc03_3      LIKE pmc_file.pmc03
DEFINE   g_ima906       LIKE ima_file.ima906,
         g_ima907       LIKE ima_file.ima907,
         g_ima906_1     LIKE ima_file.ima906,
         g_ima907_1     LIKE ima_file.ima907
DEFINE   g_ecd02        LIKE ecd_file.ecd02  
DEFINE   g_ecu03        LIKE ecu_file.ecu03  

DEFINE g_img_p DYNAMIC ARRAY OF RECORD
               choice    LIKE type_file.chr1,
               img01     LIKE img_file.img01,
               ima02     LIKE ima_file.ima02,
               img02     LIKE img_file.img02,
               img03     LIKE img_file.img03,
               img04     LIKE img_file.img04,
               img10     LIKE img_file.img10,
               imgg10    LIKE imgg_file.imgg10,
               ima25     LIKE ima_file.ima25 
               END RECORD,
       g_img_p_t RECORD
               choice    LIKE type_file.chr1,
               img01     LIKE img_file.img01,
               ima02     LIKE ima_file.ima02,
               img02     LIKE img_file.img02,
               img03     LIKE img_file.img03,
               img04     LIKE img_file.img04,
               img10     LIKE img_file.img10,
               imgg10    LIKE imgg_file.imgg10,
               ima25     LIKE ima_file.ima25 
               END RECORD

#主程式開始
MAIN
   DEFINE p_row,p_col  LIKE type_file.num5
   
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP                       #輸入的方式: 不打轉
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)
   RETURNING g_time

   LET p_row = 2 LET p_col = 9

   OPEN WINDOW i500_w AT p_row,p_col WITH FORM "aic/42f/aici500"
   ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()
   CALL cl_set_comp_visible("chk",FALSE)                               

   CALL i500sub_create_bin_temp()  RETURNING l_table 
   CALL i500sub_create_icout_temp() 

   INITIALIZE g_idu.* TO NULL
   INITIALIZE g_idu_t.* TO NULL
   INITIALIZE g_idu_o.* TO NULL

   LET g_forupd_sql = "SELECT * FROM idu_file WHERE idu01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i500_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR

   CALL i500_menu()


   DROP TABLE icout_temp 
   CLOSE WINDOW i500_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出時間)
   RETURNING g_time
END MAIN

FUNCTION i500_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01  
    CLEAR FORM
    CALL g_idv.clear()

  IF NOT cl_null(g_argv1) THEN
     LET g_wc = " idu01 = '",g_argv1,"'"
     LET g_wc2= " 1=1"
  ELSE
    CALL cl_set_head_visible("","YES")      
    INITIALIZE g_idu.* TO NULL

    CONSTRUCT BY NAME g_wc ON idu01,idu19,idu11,idu25,idu26,idu14,    
                              idu15,idu13,idu16,idu12,idu17,          
                              idu18,idu20,idu21,idu08,idu22,idu02,iduconf,
                              iduuser,idudate,idumodu,idumodd,iduoriu,iduorig    

        BEFORE CONSTRUCT
                  CALL cl_qbe_init()
        ON ACTION controlp
           CASE WHEN INFIELD(idu01) #查詢單据
                     CALL cl_init_qry_var()
                     LET g_qryparam.state  = "c"
                     LET g_qryparam.form = "q_idu01"  
                     LET g_qryparam.default1 = g_idu.idu01
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO idu01
                     NEXT FIELD idu01
                WHEN INFIELD(idu08)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_gem" 
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO idu08
                     NEXT FIELD idu08

                WHEN INFIELD(idu21) #採購人員
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_gen" 
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO idu21
                     NEXT FIELD idu21

                WHEN INFIELD(idu11) #委外廠商
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form = "q_pmc15" 
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO idu11
                     NEXT FIELD idu11

                WHEN INFIELD(idu14) #送貨廠商
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form = "q_pmc15" 
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO idu14
                     NEXT FIELD idu14

                WHEN INFIELD(idu13) #作業編號
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form = "q_ecd02_icd"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO idu13
                     NEXT FIELD idu13

                WHEN INFIELD(idu24)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_pmd01" 
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO idu24
                     NEXT FIELD idu24
                     
                WHEN INFIELD(idu25)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_pmd01" 
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO idu25
                     NEXT FIELD idu25
                     
                WHEN INFIELD(idu23)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_ecu04" 
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO idu23
                     NEXT FIELD idu23

               OTHERWISE
            END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT

       ON ACTION qbe_select
          CALL cl_qbe_list() RETURNING lc_qbe_sn
          CALL cl_qbe_display_condition(lc_qbe_sn)
    END CONSTRUCT

    IF INT_FLAG THEN RETURN END IF

    LET g_wc2= " 1=1"
    CONSTRUCT g_wc2 ON idv02,idv13,idv12,idv14,idv15,idv16,idv23,idv17,
                       idv18,idv19,idv20,idv21,idv03,idv25,idv26,idv27,
                       idv28,idv04,idv22,idv29,idv24,idv30,idv09
                  FROM s_idv[1].idv02,s_idv[1].idv13,s_idv[1].idv12,
                        s_idv[1].idv14,s_idv[1].idv15,s_idv[1].idv16,
                        s_idv[1].idv23,s_idv[1].idv17,s_idv[1].idv18,
                        s_idv[1].idv19,s_idv[1].idv20,s_idv[1].idv21,
                        s_idv[1].idv03    ,s_idv[1].idv25,s_idv[1].idv26,
                        s_idv[1].idv27,s_idv[1].idv28,s_idv[1].idv04,
                        s_idv[1].idv22,s_idv[1].idv29,s_idv[1].idv24,
                        s_idv[1].idv30,s_idv[1].idv09

                BEFORE CONSTRUCT
                   CALL cl_qbe_display_condition(lc_qbe_sn)
        ON ACTION controlp
           CASE WHEN INFIELD(idv13)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_ima" 
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_idv[1].idv13
                     NEXT FIELD idv13

                WHEN INFIELD(idv03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_ima"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_idv[1].idv03
                     NEXT FIELD idv03
                WHEN INFIELD(idv14)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_imd"
                     LET g_qryparam.arg1     = 'SW'        #倉庫類別 
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_idv[1].idv14
                     NEXT FIELD idv14
                WHEN INFIELD(idv21)            #作業編號
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form ="q_ecd02_icd"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_idv[1].idv21
                     NEXT FIELD idv21
                WHEN INFIELD(idv17)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form ="q_gfe"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_idv[1].idv17
                     NEXT FIELD idv17
                WHEN INFIELD(idv19)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form ="q_gfe"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_idv[1].idv19
                     NEXT FIELD idv19
                WHEN INFIELD(idv25)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form ="q_gfe"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_idv[1].idv25
                     NEXT FIELD idv25
                WHEN INFIELD(idv27)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form ="q_gfe"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_idv[1].idv27
                     NEXT FIELD idv27
                WHEN INFIELD(idv29)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form ="q_pmc"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_idv[1].idv29
                     NEXT FIELD idv29
                WHEN INFIELD(idv22)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form ="q_ecu04"  
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_idv[1].idv22
                     NEXT FIELD idv22
           
               OTHERWISE
           END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
       ON ACTION qbe_save
          CALL cl_qbe_save()
    END CONSTRUCT
  END IF  

    IF INT_FLAG THEN RETURN END IF

    #資料權限的檢查
    IF g_priv2='4' THEN                            # 只能使用自己的資料
        LET g_wc = g_wc clipped," AND iduuser = '",g_user,"'"
    END IF
    IF g_wc2=' 1=1'
       THEN LET g_sql="SELECT idu01 FROM idu_file ",
                      " WHERE ",g_wc CLIPPED, " ORDER BY idu01"
       ELSE LET g_sql="SELECT UNIQUE idu01",
                      "  FROM idu_file,idv_file ",
                      " WHERE idu01=idv01",
                      "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                      " ORDER BY idu01"
    END IF
    PREPARE i500_prepare FROM g_sql                # RUNTIME 編譯
    DECLARE i500_cs SCROLL CURSOR WITH HOLD FOR i500_prepare
    IF g_wc2=' 1=1'
       THEN LET g_sql="SELECT COUNT(*) FROM idu_file ",
                      " WHERE ",g_wc CLIPPED
       ELSE LET g_sql="SELECT COUNT(UNIQUE idu01)",
                      "  FROM idu_file,idv_file ",
                      " WHERE idu01=idv01",
                      "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF

    PREPARE i500_precount FROM g_sql
    DECLARE i500_count CURSOR FOR i500_precount

END FUNCTION

FUNCTION i500_menu()
   DEFINE r_type STRING #判斷報表類別
   DEFINE r_type1 STRING #擷取報表類別前2各自元
   WHILE TRUE
      CALL i500_bp("G")
      CASE g_action_choice
           WHEN "insert"
                IF cl_chk_act_auth() AND (g_argv1 IS NULL OR g_argv1=' ') THEN
                   CALL i500_a()
                END IF
           WHEN "query"
                IF cl_chk_act_auth() THEN
                   CALL i500_q()
                END IF
           WHEN "qidc"
                IF cl_chk_act_auth() THEN
                   CALL i500_bp2()
                END IF
           WHEN "delete"
                IF cl_chk_act_auth() AND (g_argv1 IS NULL OR g_argv1=' ')
                   THEN CALL i500_r()
                END IF
           WHEN "modify"
                IF cl_chk_act_auth() AND (g_argv1 IS NULL OR g_argv1=' ')
                   THEN CALL i500_u()
                END IF
           WHEN "detail"   #工單維護
                IF cl_chk_act_auth() THEN
                   CALL i500_b()
                ELSE
                   LET g_action_choice = NULL
                END IF
           WHEN "Bin_set"   #BIN維護
                IF cl_chk_act_auth() THEN
                   IF l_ac > 0 THEN 
                      IF g_idv[l_ac].idv02 > 0 THEN
                         CALL i500_b2(g_idv[l_ac].idv02)
                      END IF 
                   END IF 
                ELSE
                   LET g_action_choice = NULL
                END IF
           WHEN "confirm"  
                IF cl_chk_act_auth() THEN
                    IF cl_confirm('abx-080') THEN
                       CALL i500_y()
                    END IF
                END IF
                CASE g_idu.iduconf
                     WHEN 'Y'   LET g_confirm = 'Y'
                                LET g_void = ''
                     WHEN 'N'   LET g_confirm = 'N'
                                LET g_void = ''
                     WHEN 'X'   LET g_confirm = ''
                                LET g_void = 'Y'
                  OTHERWISE     LET g_confirm = ''
                                LET g_void = ''
                END CASE
                #圖形顯示
                CALL cl_set_field_pic(g_confirm,"","","",g_void,'')
          WHEN "undo_confirm"
                IF cl_chk_act_auth() THEN
                   CALL i500_z()
                END IF
                CASE g_idu.iduconf
                     WHEN 'Y'   LET g_confirm = 'Y'
                                LET g_void = ''
                     WHEN 'N'   LET g_confirm = 'N'
                                LET g_void = ''
                     WHEN 'X'   LET g_confirm = ''
                                LET g_void = 'Y'
                  OTHERWISE     LET g_confirm = ''
                                LET g_void = ''
                END CASE
                #圖形顯示
                CALL cl_set_field_pic(g_confirm,"","","",g_void,'')
          #@WHEN "作廢"
           WHEN "void"
                IF cl_chk_act_auth() THEN
                  #CALL i500_x()   #CHI-D20010
                   CALL i500_x(1)   #CHI-D20010
                END IF
          #CHI-D20010---begin
          WHEN "undo_void"
             IF cl_chk_act_auth() THEN
                CALL i500_x(2)   #CHI-D20010
             END IF
          #CHI-D20010---end
           WHEN "exporttoexcel"     
                IF cl_chk_act_auth() THEN
                   CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_idv),'','')
                END IF
          #@WHEN "驗收狀況"
           WHEN "receiving_status"
                IF cl_null(g_idu.idu01) THEN
                   CALL cl_err('','-400',1)  
                ELSE
                   LET g_cmd = "apmq520 "," '",g_idu.idu01,"'"," ' ' "
                   CALL cl_cmdrun(g_cmd CLIPPED)
                END IF
      
           WHEN "genb"
                IF cl_chk_act_auth() THEN
                   IF g_idu.iduconf='N' THEN 
                      CALL i500_g_b()
                      CALL i500_b()
                   END IF
                END IF

           #WHEN "output"    
           #     IF cl_chk_act_auth() AND NOT cl_null(g_idu.idu01) THEN
           #        #CALL i500_out1()
           #     END IF
                
           WHEN "memo"
                CALL s_asf_memo('a',g_idu.idu01)
           WHEN "help"
                CALL cl_show_help()
           WHEN "exit"
                LET INT_FLAG = 0
                EXIT WHILE
           WHEN "controlg"
                CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION

FUNCTION i500_a()
    DEFINE li_result   LIKE type_file.num5     
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢幕欄位內容                         
    CALL g_idv.clear()
    CALL g_data.clear()
    CALL cl_del_data(l_table)      

    INITIALIZE g_idu.* LIKE idu_file.*
    LET g_idu01_t = NULL
    LET g_idu.idu19 = g_today
    LET g_idu.idu20 = g_today
    LET g_idu.idu21 = g_user
    LET g_idu.iduuser = g_user
    LET g_idu.idudate = g_today
    LET g_idu.iduconf = 'N'
    LET g_idu.idu08 = g_grup 
    LET g_idu.iduplant = g_plant
    LET g_idu.idulegal = g_legal
    LET g_idu.iduorig = g_grup
    LET g_idu.iduoriu = g_user

    DISPLAY s_costcenter_desc(g_idu.idu08) TO FORMONLY.gem02 
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i500_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
           LET INT_FLAG = 0  
           CALL cl_err('',9001,0)
           CLEAR FORM
           CALL g_idv.clear()
           EXIT WHILE
        END IF
        IF cl_null(g_idu.idu01) THEN             # KEY 不可空白
           CONTINUE WHILE
        END IF

        BEGIN WORK   
        CALL s_auto_assign_no("asf",g_idu.idu01,g_idu.idu19,"X","idu_file","idu01","","","")
        RETURNING li_result,g_idu.idu01
      IF (NOT li_result) THEN
         ROLLBACK WORK   
         CONTINUE WHILE                                                                                                       
      END IF                                                                                                                  
      DISPLAY BY NAME g_idu.idu01

        INSERT INTO idu_file VALUES(g_idu.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","idu_file",g_idu.idu01,"",SQLCA.sqlcode,"","",1) 
           ROLLBACK WORK   
           CONTINUE WHILE
        ELSE
           COMMIT WORK    

           CALL cl_flow_notify(g_idu.idu01,'I')

           LET g_idu_t.* = g_idu.*               # 保存上筆資料
           #SELECT idu01 INTO g_idu.idu01 FROM idu_file
           #       WHERE idu01 = g_idu.idu01
        END IF

        CALL g_idv.clear()

        LET g_rec_b = 0
        CALL i500_b()                                                                                                      
        EXIT WHILE
    END WHILE
      LET g_wc=' '   
END FUNCTION

FUNCTION i500_i(p_cmd)
DEFINE  p_cmd           LIKE type_file.chr1,        
        l_flag          LIKE type_file.chr1,         #判斷必要欄位是否有輸入       
        l_n             LIKE type_file.num5     
DEFINE  lc_qbe_sn       LIKE gbm_file.gbm01
DEFINE  li_result       LIKE type_file.num5
DEFINE  l_smydesc       LIKE smy_file.smydesc     
DEFINE  l_gen02         LIKE gen_file.gen02,
        l_gen03         LIKE gen_file.gen03,
        l_gem02         LIKE gem_file.gem02,
        l_acti          LIKE type_file.chr1
DEFINE  l_idu15         LIKE idu_file.idu15

     IF p_cmd = 'a' THEN
         CLEAR FORM                             #清除畫面
         CALL g_process.clear()
         CALL g_process_msg.clear()
         LET g_rec_b = 0
         LET g_rec_b2 = 0
         LET g_wc = NULL
         DELETE FROM icout_temp       
     END IF

    CALL cl_set_head_visible("","YES")       
    INPUT BY NAME
           g_idu.idu01,g_idu.idu19,g_idu.idu11,g_idu.idu25,g_idu.idu26,g_idu.idu14,  
           g_idu.idu24,g_idu.idu15,g_idu.idu13,g_idu.idu23,
           g_idu.idu16,g_idu.idu12,g_idu.idu17,   
           g_idu.idu18,g_idu.idu20,g_idu.idu21,g_idu.idu08,
           g_idu.idu22,g_idu.idu02,g_idu.iduconf,
           g_idu.iduuser,g_idu.idudate,g_idu.idumodu,g_idu.idumodd,g_idu.iduoriu,g_idu.iduorig    
        WITHOUT DEFAULTS

        BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i500_set_entry(p_cmd)
          CALL i500_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE

         CALL cl_set_docno_format("idu01")                                                                                    

        AFTER FIELD idu01
         IF NOT cl_null(g_idu.idu01) THEN         
          IF g_idu.idu01 != g_idu01_t OR g_idu01_t IS NULL THEN 
             CALL s_check_no("asf",g_idu.idu01,g_idu01_t,"X","idu_file","idu01","")
             RETURNING li_result,g_idu.idu01
             DISPLAY BY NAME g_idu.idu01                                                                                       
             IF (NOT li_result) THEN                     
                LET g_idu.idu01=g_idu_o.idu01   
                NEXT FIELD idu01  
             END IF               
             LET g_t1 = s_get_doc_no(g_idu.idu01)
             SELECT smydesc INTO l_smydesc FROM smy_file WHERE smyslip=g_t1
             DISPLAY l_smydesc TO smydesc

          END IF
         END IF  

         AFTER FIELD idu18
            IF NOT cl_null(g_idu.idu18) THEN
               LET g_cnt = 0
               LET g_idu.idu18=s_get_doc_no(g_idu.idu18)
               SELECT COUNT(*) INTO g_cnt FROM smy_file
                WHERE smyslip = g_idu.idu18
                  AND substr(smy57,6,6) = '1'
               IF g_cnt = 0 THEN
                  CALL cl_err('','aic-141',0)
                  NEXT FIELD idu18
               END IF

               CALL s_check_no("asf",g_idu.idu18,"","1","sfb_file","sfb01","")
                    RETURNING li_result,g_idu.idu18
               DISPLAY BY NAME g_idu.idu18
               IF (NOT li_result) THEN
                  NEXT FIELD idu18
               END IF
               LET g_idu.idu18 = s_get_doc_no(g_idu.idu18)
            END IF

         AFTER FIELD idu22 #發料單別
            IF NOT cl_null(g_idu.idu22) THEN
               CALL s_check_no("asf",g_idu.idu22,"","3","sfp_file", "sfp01","")
                    RETURNING li_result,g_idu.idu22
               DISPLAY BY NAME g_idu.idu22
               IF (NOT li_result) THEN
                  NEXT FIELD g_idu.idu22
               END IF
               LET g_idu.idu22 = s_get_doc_no(g_idu.idu22)
            END IF

         AFTER FIELD idu21 #採購人員
           IF NOT cl_null(g_idu.idu21) THEN
              LET l_gen02 = NULL LET l_gen03 = NULL
              SELECT gen02,gen03,genacti INTO l_gen02,l_gen03,l_acti
                FROM gen_file
               WHERE gen01 = g_idu.idu21
              IF SQLCA.sqlcode THEN
                 CALL cl_err('',SQLCA.sqlcode,0)
                 NEXT FIELD idu21
              END IF
              IF l_acti = 'N' THEN
                 CALL cl_err('','9028',0)
                 NEXT FIELD idu21
              END IF
              LET g_idu.idu08 = l_gen03
              DISPLAY BY NAME g_idu.idu08 
              DISPLAY l_gen02 TO gen02
           ELSE
              DISPLAY '' TO gen02
           END IF

         AFTER FIELD idu08 #採購部門
           IF NOT cl_null(g_idu.idu08) THEN
              SELECT gem02,gemacti INTO l_gem02,l_acti FROM gem_file
               WHERE gem01 = g_idu.idu08
              IF SQLCA.sqlcode THEN
                 CALL cl_err('',SQLCA.sqlcode,0)
                 NEXT FIELD idu08
              END IF
              IF l_acti = 'N' THEN
                 CALL cl_err('','9028',0)
                 NEXT FIELD idu08
              END IF
           END IF

         AFTER FIELD idu11 #採購廠商     
           #控制加工廠商與聯絡人關係     
           IF NOT cl_null(g_idu.idu11) THEN
              SELECT pmc03,pmc091 INTO g_pmc03,g_idu.idu12 FROM pmc_file
               WHERE pmc01 = g_idu.idu11
              IF SQLCA.sqlcode THEN
                 CALL cl_err('',SQLCA.sqlcode,0)
                 NEXT FIELD idu11
              END IF
              DISPLAY g_pmc03 TO pmc03
              DISPLAY BY NAME g_idu.idu12              
              
              NEXT FIELD idu25
           ELSE
              Let g_idu.idu12=''
              Let g_idu.idu25=''
              
              DISPLAY BY NAME g_idu.idu12,g_idu.idu25
              NEXT FIELD idu11
           END IF
            
           
         AFTER FIELD idu14 #送貨廠商
           #控制送貨廠商與聯絡人關係         	          
           IF NOT cl_null(g_idu.idu14) THEN
               SELECT pmc03,pmc091 
                 INTO g_pmc03_3,g_idu.idu17
                 FROM pmc_file
                WHERE pmc01 = g_idu.idu14
              IF SQLCA.sqlcode THEN
                 CALL cl_err('',SQLCA.sqlcode,0)
                 NEXT FIELD idu11
              END IF
              DISPLAY g_pmc03_3 TO pmc03_3             
              DISPLAY BY NAME g_idu.idu17    
           END IF
           
         AFTER FIELD idu13 
           IF NOT cl_null(g_idu.idu13) THEN
              SELECT ecd02 INTO g_ecd02 FROM ecd_file
               WHERE ecd01 = g_idu.idu13
              IF SQLCA.sqlcode THEN
                 CALL cl_err('',SQLCA.sqlcode,0)
                 NEXT FIELD idu11
              END IF
              DISPLAY g_ecd02 TO ecd02
           END IF
        
         AFTER FIELD idu20 #扣帳日期
           IF NOT cl_null(g_idu.idu20) THEN
              IF g_sma.sma53 IS NOT NULL AND g_idu.idu20 <= g_sma.sma53 THEN
                 CALL cl_err('','mfg9999',0) NEXT FIELD idu20
              END IF
              CALL s_yp(g_idu.idu20) RETURNING g_yy,g_mm
              IF (g_yy*12+g_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
                 CALL cl_err(g_yy,'mfg6090',0) NEXT FIELD idu20
              END IF
           END IF


         AFTER FIELD idu23 
           IF NOT cl_null(g_idu.idu23) THEN
              SELECT MAX(ecu03) INTO g_ecu03 FROM ecu_file
               WHERE ecu02 = g_idu.idu23
                 AND ecuacti = 'Y'  #CHI-C90006
              IF SQLCA.sqlcode THEN
                 CALL cl_err('',SQLCA.sqlcode,0)
                 NEXT FIELD idu23
              END IF
              DISPLAY g_ecu03 TO ecu03
           END IF
        
         AFTER FIELD idu24
            IF NOT cl_null(g_idu.idu24) or g_idu.idu24 <>'' THEN
               SELECT COUNT(*) INTO g_cnt FROM pmd_file
                WHERE pmd01=g_idu.idu14 AND pmd06=g_idu.idu24
               IF g_cnt=0 THEN 
                  Let g_idu.idu24=''                 
                  Let g_idu.idu15=''
                  Let g_idu.idu16=''
                  Let g_idu.idu17=''
                  NEXT FIELD idu24
               END IF   
              
               IF cl_null(g_idu.idu15) or g_idu.idu15='' THEN  

               ELSE                   
                  SELECT COUNT(*) INTO g_cnt FROM pmd_file
                  WHERE pmd01=g_idu.idu14 AND pmd02=g_idu.idu15 and pmd06=g_idu.idu24
                  IF g_cnt=0 THEN                                       
                     Let g_idu.idu15=''
                     Let g_idu.idu16=''
                     Let g_idu.idu17=''
                     NEXT FIELD idu24
                  ELSE
                     SELECT pmd03
                       INTO g_idu.idu16
                       FROM pmd_file
                      WHERE pmd01=g_idu.idu14 AND pmd02=g_idu.idu15 and pmd06=g_idu.idu24 
                  END IF      
               END IF                                                                   
               DISPLAY BY NAME g_idu.idu14,g_idu.idu24,g_idu.idu15,g_idu.idu16,g_idu.idu17
            END IF
              
         AFTER FIELD idu25         
           IF NOT cl_null(g_idu.idu25) THEN  
            SELECT COUNT(*) INTO g_cnt FROM pmd_file
                WHERE pmd01=g_idu.idu11 and pmd06=g_idu.idu25
                IF g_cnt=0 THEN                                       
                   Let g_idu.idu25=''
                   NEXT FIELD idu25
                END IF              
           END IF 

         AFTER INPUT  #總檢
           IF INT_FLAG THEN EXIT INPUT END IF

        ON ACTION controlp
            CASE WHEN INFIELD(idu01) #查詢單据
                     LET g_t1 = s_get_doc_no(g_idu.idu01)    
                     CALL q_smy(FALSE,TRUE,g_t1,'ASF','X') RETURNING g_t1  
                     LET g_idu.idu01 = g_t1                 
                     DISPLAY BY NAME g_idu.idu01
                     NEXT FIELD idu01
               WHEN INFIELD(idu08)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gem"
                    LET g_qryparam.default1 = g_idu.idu08
                    CALL cl_create_qry() RETURNING g_idu.idu08
                    DISPLAY BY NAME g_idu.idu08
                    NEXT FIELD idu08

               WHEN INFIELD(idu18) #委外單別
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_smy1"
                  LET g_qryparam.where = "smykind= '1' AND smysys = 'asf' ",
                                         "AND substr(smy57,6,6) = '1' "
                  CALL cl_create_qry() RETURNING g_idu.idu18
                  DISPLAY BY NAME g_idu.idu18
                  NEXT FIELD idu18

               WHEN INFIELD(idu22) #發料單別
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_smy1"
                  LET g_qryparam.where = "smykind= '3' AND smysys = 'asf' "
                  CALL cl_create_qry() RETURNING g_idu.idu22
                  DISPLAY BY NAME g_idu.idu22
                  NEXT FIELD idu22

               WHEN INFIELD(idu21) #採購人員
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  CALL cl_create_qry() RETURNING g_idu.idu21
                  DISPLAY BY NAME g_idu.idu21
                  NEXT FIELD idu21

               WHEN INFIELD(idu11) #委外廠商
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pmc15"  
                  CALL cl_create_qry() RETURNING g_idu.idu11
                  DISPLAY BY NAME g_idu.idu11
                  NEXT FIELD idu11

               WHEN INFIELD(idu14) #送貨廠商
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pmc15"  
                  CALL cl_create_qry() RETURNING g_idu.idu14
                  DISPLAY BY NAME g_idu.idu14
                  NEXT FIELD idu14

               WHEN INFIELD(idu13) #作業編號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_ecd02_icd"
                    CALL cl_create_qry() RETURNING g_idu.idu13
                    DISPLAY BY NAME g_idu.idu13
                    NEXT FIELD idu13

                WHEN INFIELD(idu24)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_pmd01"  
                     LET g_qryparam.arg1 = g_idu.idu14
                     CALL cl_create_qry() RETURNING g_idu.idu24,g_idu.idu15
                     DISPLAY BY NAME g_idu.idu24,g_idu.idu15
                     NEXT FIELD idu24
                     
                WHEN INFIELD(idu25)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_pmd01"  
                     LET g_qryparam.arg1 = g_idu.idu11
                     CALL cl_create_qry() RETURNING g_idu.idu25,g_idu.idu26
                     DISPLAY BY NAME g_idu.idu25,g_idu.idu26
                     
                     SELECT pmd04 INTO g_idu.idu12
                       FROM pmd_file
                      WHERE pmd01=g_idu.idu11 AND pmd06=g_idu.idu25
                        AND pmd02=l_idu15
                     DISPLAY BY NAME g_idu.idu12
                     NEXT FIELD idu25
                     
                WHEN INFIELD(idu23)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_ecu04"  
                     CALL cl_create_qry() RETURNING g_idu.idu23
                     DISPLAY BY NAME g_idu.idu23
                     
                     NEXT FIELD idu23
               OTHERWISE EXIT CASE
            END CASE

         ON ACTION CONTROLZ
            CALL cl_show_req_fields()

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()
            EXIT INPUT

         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT

         ON ACTION qbe_save
            CALL cl_qbe_save()

      END INPUT
END FUNCTION

FUNCTION i500_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("idu01",TRUE)
    END IF

END FUNCTION

FUNCTION i500_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("idu01",FALSE)
    END IF
END FUNCTION

FUNCTION i500_q()

         CALL g_process.clear()
         CALL g_process_msg.clear()
         LET g_rec_b = 0
         LET g_rec_b2 = 0
         LET g_wc = NULL
         DELETE FROM icout_temp       

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_idu.* TO NULL             
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cn2
    CALL i500_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0             
        CLEAR FORM
        CALL g_idv.clear()
        RETURN
    END IF
    MESSAGE " SEARCHING ! "

    OPEN i500_count
    FETCH i500_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cn2

    OPEN i500_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_idu.idu01,SQLCA.sqlcode,0)
        INITIALIZE g_idu.* TO NULL
    ELSE
        CALL i500_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION

FUNCTION i500_fetch(p_flidu)
    DEFINE
        p_flidu         LIKE type_file.chr1,         
        l_abso          LIKE type_file.num10         

    CASE p_flidu
        WHEN 'N' FETCH NEXT     i500_cs INTO g_idu.idu01
        WHEN 'P' FETCH PREVIOUS i500_cs INTO g_idu.idu01
        WHEN 'F' FETCH FIRST    i500_cs INTO g_idu.idu01
        WHEN 'L' FETCH LAST     i500_cs INTO g_idu.idu01
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
            FETCH ABSOLUTE g_jump i500_cs INTO g_idu.idu01
            LET mi_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_idu.idu01,SQLCA.sqlcode,0)
        INITIALIZE g_idu.* TO NULL        
        RETURN
    ELSE
       CASE p_flidu
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE

       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF

    SELECT * INTO g_idu.* FROM idu_file       # 重讀DB,因TEMP有不被更新特性
     WHERE idu01 = g_idu.idu01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","idu_file",g_idu.idu01,"",SQLCA.sqlcode,"","",1)  
       INITIALIZE g_idu.* TO NULL
    ELSE
       LET g_sql = "DELETE FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
       PREPARE fetch_prep FROM g_sql
       EXECUTE fetch_prep

       LET g_data_owner = g_idu.iduuser      
       LET g_data_group = ''                 
       CALL i500_show()                      # 重新顯示
    END IF
END FUNCTION

FUNCTION i500_show()
    DEFINE l_smydesc   LIKE smy_file.smydesc        
    LET g_idu_t.* = g_idu.*
    DISPLAY BY NAME
           g_idu.idu01,g_idu.idu02,g_idu.idu08,g_idu.iduconf, 
           g_idu.idu19,g_idu.idu11,g_idu.idu12,g_idu.idu14,
           g_idu.idu15,g_idu.idu13,g_idu.idu16,g_idu.idu17,
           g_idu.idu18,g_idu.idu20,g_idu.idu21,g_idu.idu22,
           g_idu.idu23,g_idu.idu24,g_idu.idu25,
           g_idu.iduuser,g_idu.idudate,g_idu.idumodu,g_idu.idumodd
          ,g_idu.iduoriu,g_idu.iduorig    
          ,g_idu.idu26   

       LET g_t1 = s_get_doc_no(g_idu.idu01)
       SELECT smydesc INTO l_smydesc FROM smy_file WHERE smyslip=g_t1
       DISPLAY l_smydesc TO smydesc
    SELECT pmc03 INTO g_buf FROM pmc_file WHERE pmc01=g_idu.idu11
    DISPLAY g_buf TO pmc03
    SELECT pmc03 INTO g_buf FROM pmc_file WHERE pmc01=g_idu.idu14
    DISPLAY g_buf TO pmc03_3
    SELECT gem02 INTO g_buf FROM gem_file WHERE gem01=g_idu.idu08 
    DISPLAY g_buf TO gem02

    LET g_buf = ''
    SELECT ecd02 INTO g_buf FROM ecd_file WHERE ecd01 = g_idu.idu13 
    DISPLAY g_buf TO ecd02
    LET g_buf = ''
    SELECT ecu03 INTO g_buf FROM ecu_file WHERE ecu02 = g_idu.idu23
    DISPLAY g_buf TO ecu03

    CASE g_idu.iduconf
         WHEN 'Y'   LET g_confirm = 'Y'
                    LET g_void = ''
         WHEN 'N'   LET g_confirm = 'N'
                    LET g_void = ''
         WHEN 'X'   LET g_confirm = ''
                    LET g_void = 'Y'
      OTHERWISE     LET g_confirm = ''
                    LET g_void = ''
    END CASE
    #圖形顯示
    CALL cl_set_field_pic(g_confirm,"","","",g_void,'')

    CALL i500_b_fill(g_wc2)

    CALL cl_show_fld_cont()                   
END FUNCTION

FUNCTION i500_u()
DEFINE l_cnt LIKE type_file.num5

    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_idu.idu01) THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_idu.iduconf = 'Y' THEN CALL cl_err('','afa-096',0) RETURN END IF
    IF g_idu.iduconf = 'X'   THEN CALL cl_err('','9024',0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    BEGIN WORK

    OPEN i500_cl USING g_idu.idu01
    IF STATUS THEN
       CALL cl_err("OPEN i500_cl:", STATUS, 1)
       CLOSE i500_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i500_cl INTO g_idu.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_idu.idu01,SQLCA.sqlcode,0)
       CLOSE i500_cl
       ROLLBACK WORK
       RETURN
    END IF
    LET g_idu01_t = g_idu.idu01
    LET g_idu_o.*=g_idu.*
    LET g_idu.idumodu = g_user
    LET g_idu.idumodd = g_today                  #修改日期
    CALL i500_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i500_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_idu.*=g_idu_t.*
            CALL i500_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE idu_file SET idu_file.* = g_idu.*    # 更新DB
            WHERE idu01 = g_idu.idu01             # COLAUTH?
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","idu_file",g_idu01_t,"",SQLCA.sqlcode,"","",1)  
            CONTINUE WHILE
        END IF
        SELECT COUNT(*) INTO l_cnt FROM idv_file 
           WHERE idv01=g_idu.idu01 AND idv21 <> g_idu.idu13
        IF NOT cl_null(g_idu.idu13) AND l_cnt > 0 THEN
           UPDATE idv_file SET idv21 = g_idu.idu13
              WHERE idv01=g_idu.idu01 AND idv21 <> g_idu.idu13
        END IF
        UPDATE idv_file SET idv22 = g_idu.idu23
              WHERE idv01=g_idu.idu01
       
        EXIT WHILE
    END WHILE

    CLOSE i500_cl
    COMMIT WORK
    CALL i500_show()                          # 顯示最新資料
    CALL cl_flow_notify(g_idu.idu01,'U')

END FUNCTION

FUNCTION i500_r()
    DEFINE l_chr   LIKE type_file.chr1,         
           l_cnt   LIKE type_file.num5          

    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_idu.idu01) THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_idu.iduconf = 'Y' THEN CALL cl_err('','afa-096',0) RETURN END IF
    IF g_idu.iduconf = 'X'   THEN CALL cl_err('','9024',0) RETURN END IF
    SELECT count(*) INTO l_cnt FROM sfb_file 
          WHERE sfb87 <> 'X' AND sfb91= g_idu.idu01
    IF l_cnt > 0 THEN
       CALL cl_err(g_idu.idu01,'asf-330',0)
       RETURN
    END IF
    BEGIN WORK

    OPEN i500_cl USING g_idu.idu01
    IF STATUS THEN
       CALL cl_err("OPEN i500_cl:", STATUS, 1)
       CLOSE i500_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i500_cl INTO g_idu.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_idu.idu01,SQLCA.sqlcode,0)
       CLOSE i500_cl
       ROLLBACK WORK
       RETURN
    END IF
    CALL i500_show()
    IF cl_delh(15,21) THEN
        INITIALIZE g_doc.* TO NULL          
        LET g_doc.column1 = "idu01"         
        LET g_doc.value1 = g_idu.idu01      
        CALL cl_del_doc()                                            
        DELETE FROM idu_file WHERE idu01 =g_idu.idu01
        IF STATUS THEN
          CALL cl_err3("del","idu_file",g_idu.idu01,"",STATUS,"","del idu:",1)  
         RETURN END IF

        DELETE FROM idv_file WHERE idv01 = g_idu.idu01
        IF STATUS THEN
           CALL cl_err3("del","idv_file",g_idu.idu01,"",STATUS,"","del idv:",1)  
         RETURN END IF
        DELETE FROM idw_file WHERE idw01 = g_idu.idu01

        INITIALIZE g_idu.* TO NULL
        CLEAR FORM
        CALL g_idv.clear()
        OPEN i500_count
        FETCH i500_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN i500_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL i500_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL i500_fetch('/')
        END IF
    END IF

    CLOSE i500_cl
    COMMIT WORK
    CALL cl_flow_notify(g_idu.idu01,'D')

END FUNCTION

FUNCTION i500_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)

   DISPLAY ARRAY g_idv TO s_idv.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
         IF l_ac > 0 THEN
            CALL i500_refresh_b2(g_idv[l_ac].idv02)
         ELSE
            CALL i500_refresh_b2(l_ac)
         END IF

      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION qidc  
         LET g_action_choice="qidc"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY

      ON ACTION first
         CALL i500_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                   

      ON ACTION previous
         CALL i500_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                  

      ON ACTION jump
         CALL i500_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                   

      ON ACTION next
         CALL i500_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY                   

      ON ACTION last
         CALL i500_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                  

      #ON ACTION output
      #   LET g_action_choice="output"
      #   EXIT DISPLAY

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

      ON ACTION detail
         LET g_action_choice = "detail"
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION Bin_set
         LET g_action_choice = "Bin_set"
         EXIT DISPLAY

      ON ACTION memo   
         LET g_action_choice = "memo"
         EXIT DISPLAY

      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY

      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY

      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY

      #CHI-D20010---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #CHI-D20010---end

      ON ACTION exporttoexcel      
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      ON ACTION receiving_status
         LET g_action_choice="receiving_status"
         EXIT DISPLAY
    
      ON ACTION genb
         LET g_action_choice="genb"
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

      AFTER DISPLAY
         CONTINUE DISPLAY
   END DISPLAY
    CALL cl_set_act_visible("accept,cancel",TRUE)
END FUNCTION

FUNCTION i500_b_fill(p_wc2)                         
DEFINE   p_wc2           LIKE type_file.chr1000   
DEFINE   l_imnnum        LIKE ade_file.ade05,   
         l_inbnum        LIKE ade_file.ade05   
DEFINE   l_rvv17         LIKE rvv_file.rvv17    
DEFINE   l_nu            LIKE type_file.num5  
DEFINE   l_rvv35         LIKE rvv_file.rvv35  
DEFINE   l_factor        LIKE pml_file.pml09    
DEFINE   l_cnt           LIKE type_file.num5 
DEFINE   l_idw        RECORD LIKE idw_file.*

    IF cl_null(p_wc2) THEN LET p_wc2 = ' 1=1' END IF  

    LET g_sql =
        "SELECT idv02,idv13,ima02,idv12,idv14,idv15,idv16,idv23,",
        " idv17,idv18,idv19,idv20,idv21,idv03,",
        " idv31,idv32,",
        " idv25,idv26,",
        " idv27,idv28,idv04,idv22,idv29,'',idv24,idv30,idv09",
        " FROM idv_file, OUTER ima_file",
        " WHERE idv01 ='",g_idu.idu01,"'",
        "   AND idv13 = ima_file.ima01",
        "   AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY idv02"

    PREPARE i500_pb FROM g_sql
    DECLARE idv_curs CURSOR FOR i500_pb

    CALL g_idv.clear()
    CALL g_data.clear()
    CALL cl_del_data(l_table)   

    LET g_rec_b = 0
    LET g_cnt = 1

    FOREACH idv_curs INTO g_idv[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       SELECT pmc03 INTO g_idv[g_cnt].pmc03_2 FROM pmc_file WHERE pmc01=g_idv[g_cnt].idv29  

        LET l_nu = g_idv[g_cnt].idv02
        LET g_data[l_nu].sel       = 'Y'                         #挑選
        LET g_data[l_nu].rvv01     = ''                          #入庫單號
        LET g_data[l_nu].rvv02     = g_idv[g_cnt].idv02          #入庫單項次b
        LET g_data[l_nu].rvv31     = g_idv[g_cnt].idv13             #料件編號
        LET g_data[l_nu].rvv031    = ''                          #品名
        LET g_data[l_nu].rvv32     = g_idv[g_cnt].idv14             #倉庫
        LET g_data[l_nu].rvv33     = g_idv[g_cnt].idv15             #儲位
        LET g_data[l_nu].rvv34     = g_idv[g_cnt].idv16             #批號
        LET g_data[l_nu].pmn63     = 'Y'                         #急件
        LET g_data[l_nu].sfbiicd10 = 'N'                         #multi die
        LET g_data[l_nu].pmniicd12 = ''                          #廠別
        LET g_data[l_nu].sfbiicd07 = g_idv[g_cnt].idv23             #Date Code
        LET g_data[l_nu].rvv17     = g_idv[g_cnt].idv18             #入庫數量
        LET g_data[l_nu].rvv85     = g_idv[g_cnt].idv20             #入庫數量
        SELECT imaicd01,imaicd04 INTO g_data[l_nu].sfbiicd14,g_data[l_nu].imaicd04
            FROM imaicd_file
            WHERE imaicd00=g_idv[g_cnt].idv13
        SELECT icb05 INTO g_data[l_nu].icb05
            FROM imaicd_file,icb_file
            WHERE imaicd01=icb01 AND imaicd00=g_idv[g_cnt].idv13
        LET g_data[l_nu].sfbiicd14 = g_idv[g_cnt].idv13             
        LET g_data[l_nu].sfbiicd09 = g_idv[g_cnt].idv21             #作業編號
        LET g_data[l_nu].sfb05     = g_idv[g_cnt].idv03                 #完成料號
        LET g_data[l_nu].sfb27     = g_idv[g_cnt].idv31             #專案編號 
        LET g_data[l_nu].sfb271    = g_idv[g_cnt].idv32             #WBS編號 
        SELECT ima02 INTO g_data[l_nu].sfbiicd08 FROM ima_file WHERE ima01=g_idv[g_cnt].idv03
        LET g_data[l_nu].sfb82     = g_idu.idu11             #廠商編號
        LET g_data[l_nu].pmc03_1   = g_pmc03                     #廠商簡稱
        LET g_data[l_nu].sfb08     = g_idv[g_cnt].idv26             #生產數量
        LET g_data[l_nu].sfbiicd06 = g_idv[g_cnt].idv28             #生產參考數量
        LET g_data[l_nu].sfb15     = g_idv[g_cnt].idv04                 #預定交貨日期
        LET g_data[l_nu].sfbiicd02 = ''                          #wafer廠商
        LET g_data[l_nu].sfbiicd03 = ''                          #wafer site
        LET g_data[l_nu].sfb06     = g_idv[g_cnt].idv22             #製程編號
        LET g_data[l_nu].sfbiicd01 = g_idv[g_cnt].idv29             #下階段廠商
        LET g_data[l_nu].pmc03_2   = ''                          #廠商簡稱
        LET g_data[l_nu].sfbiicd13 = g_idv[g_cnt].idv24             #回貨批號
        LET g_data[l_nu].meno      = ''                          #備註

       LET g_cnt = g_cnt + 1

       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH

       LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,"(item1,sel2,item2, ",
                   " idc05,idc06,icf03,icf05,qty1,qty2,ima01,ima02,sfbiicd08_b) ",
                   " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?)"
       PREPARE ins_pre FROM g_sql
       IF STATUS THEN
         CALL cl_err('insert_prep:',status,1) 
         CALL cl_used(g_prog,g_time,2)  RETURNING g_time
         EXIT PROGRAM
       END IF

       DECLARE idw CURSOR FOR
         SELECT * FROM idw_file
         WHERE idw01 = g_idu.idu01
       FOREACH idw INTO l_idw.*

          EXECUTE ins_pre USING l_idw.idw02,l_idw.idw13,l_idw.idw03,
                                l_idw.idw04,l_idw.idw05,l_idw.idw06,
                                l_idw.idw07,l_idw.idw08,l_idw.idw09,
                                l_idw.idw10,l_idw.idw11,l_idw.idw12
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             CALL cl_err('gen data error:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
       END FOREACH

    CALL g_idv.deleteElement(g_cnt)
    LET g_rec_b=(g_cnt-1)

END FUNCTION

FUNCTION i500_fill2(p_ac)
   DEFINE p_ac        LIKE type_file.num10
   DEFINE l_cnt       LIKE type_file.num10
   DEFINE l_sql       STRING   
   DEFINE l_n         LIKE type_file.num5   
   DEFINE l_idv13 LIKE idv_file.idv13 
   DEFINE l_idv14 LIKE idv_file.idv14 
   DEFINE l_idv15 LIKE idv_file.idv15  
   DEFINE l_idv16 LIKE idv_file.idv16 

   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " WHERE item1 = ",p_ac,
               " ORDER BY item2 "
   PREPARE r406_bin_temp01 FROM l_sql
   DECLARE bin_temp_cs CURSOR FOR r406_bin_temp01
   CALL g_idc.clear()
   LET l_cnt = 1
   LET g_rec_b2 = 0

   FOREACH bin_temp_cs INTO p_ac,g_idc[l_cnt].*
      LET g_idc[l_cnt].chk = 'N'   

     LET l_cnt = l_cnt + 1
     IF l_cnt > g_max_rec THEN
        CALL cl_err( '', 9035, 0 )
        EXIT FOREACH
     END IF
   END FOREACH
   CALL g_idc.deleteElement(l_cnt)
   LET g_rec_b2 = l_cnt - 1
   LET l_cnt = 0
END FUNCTION

FUNCTION i500_b()
DEFINE
    l_idv           RECORD LIKE idv_file.*,
    l_ac_t          LIKE type_file.num5,               #未取消的ARRAY CNT     
    l_n             LIKE type_file.num5,                #檢查重複用        
    l_cnt           LIKE type_file.num5,                #檢查重複用        
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否      
    p_cmd           LIKE type_file.chr1,                 #處理狀態        
    l_sfb38         LIKE type_file.dat,           
    l_jump          LIKE type_file.num5,          #判斷是否跳過AFTER ROW的處理
    l_sgt05         LIKE ima_file.ima26,          
    l_weeks         LIKE type_file.num5,          
    l_years         LIKE type_file.num5,         
    l_date1,l_date2 LIKE type_file.dat,          
    l_allow_insert  LIKE type_file.num5,                #可新增否 
    l_allow_delete  LIKE type_file.num5                 #可刪除否    
DEFINE
    l_icb05         LIKE icb_file.icb05,
    l_icb09         LIKE icb_file.icb09,
    l_ecb06         LIKE ecb_file.ecb06,
    l_img10         LIKE img_file.img10, 
    l_idv18     LIKE idv_file.idv18,
    l_idv22     LIKE idv_file.idv22,
    l_ecdicd01      LIKE ecd_file.ecdicd01,    
    l_imaicd01      LIKE imaicd_file.imaicd01,
    l_imaicd02      LIKE imaicd_file.imaicd02,
    l_imaicd04      LIKE imaicd_file.imaicd04 
DEFINE
    #l_t1,l_tmp      LIKE type_file.num5,
    l_img04         LIKE img_file.img04,
    l_sql           STRING,
    l_idv24     LIKE idv_file.idv24,
    l_count         INTEGER,
    buf             base.StringBuffer  
DEFINE t_imaicd04   LIKE imaicd_file.imaicd04      
DEFINE l_idv20  LIKE idv_file.idv20        

    LET g_action_choice = ""
    LET buf = base.StringBuffer.create()

    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_idu.idu01) THEN RETURN END IF

    IF g_idu.iduconf = 'X'   THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_idu.iduconf = 'Y'   THEN CALL cl_err('','axm-101',0) RETURN END IF

    SELECT COUNT(*) INTO g_cnt FROM idv_file WHERE idv01=g_idu.idu01
    IF g_cnt = 0 THEN
       CALL i500_g_b()
    END IF

    CALL cl_opmsg('b')

    LET g_forupd_sql =
        "SELECT idv02,idv13,'',idv12,idv14,idv15,idv16,idv23,",
        " idv17,idv18,idv19,idv20,idv21,idv03,",
        " idv31,idv32,idv25,idv26,",
        " idv27,idv28,idv04,idv22,idv29,'',idv24,idv30,idv09",
        " FROM idv_file",
        " WHERE idv01= ? AND idv02= ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i500_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_idv WITHOUT DEFAULTS FROM s_idv.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            CALL i500_set_entry_b()
            CALL i500_set_no_entry_b()

        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK

            OPEN i500_cl USING g_idu.idu01
            IF STATUS THEN
               CALL cl_err("OPEN i500_cl:", STATUS, 1)
               CLOSE i500_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i500_cl INTO g_idu.*               # 對DB鎖定
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_idu.idu01,SQLCA.sqlcode,0)
               CLOSE i500_cl
               ROLLBACK WORK
               RETURN
            END IF

            CALL i500_set_entry_b()

            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_idv_t.* = g_idv[l_ac].*  #BACKUP
                OPEN i500_bcl USING g_idu.idu01,g_idv_t.idv02
                IF STATUS THEN
                   CALL cl_err("OPEN i500_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i500_bcl INTO g_idv[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_idv_t.idv02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   ELSE
                       SELECT ima02 INTO g_idv[l_ac].ima02_1
                         FROM ima_file
                        WHERE ima01=g_idv[l_ac].idv13 AND imaacti='Y'

                   END IF
                END IF
                CALL cl_show_fld_cont()   
            END IF
            CALL i500_refresh_b2(g_idv[l_ac].idv02)

        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_idv[l_ac].* TO NULL    
            LET g_idv[l_ac].idv09     = 'N' 
            LET g_idv[l_ac].idv12 = '1' 
            LET g_idv[l_ac].idv26 = 0
            LET g_idv[l_ac].idv21 = g_idu.idu13
            LET g_idv[l_ac].idv22 = g_idu.idu23
            LET g_idv[l_ac].idv04 = g_today                       
            LET g_idv_t.* = g_idv[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont() 
            NEXT FIELD idv02

        BEFORE FIELD idv02                        #default 序號
            IF g_idv[l_ac].idv02 IS NULL OR
               g_idv[l_ac].idv02 = 0 THEN
                SELECT max(idv02)+1 INTO g_idv[l_ac].idv02
                   FROM idv_file
                   WHERE idv01 = g_idu.idu01
                IF g_idv[l_ac].idv02 IS NULL THEN
                    LET g_idv[l_ac].idv02 = 1
                END IF
            END IF

        AFTER FIELD idv02                        #check 序號是否重複
            IF NOT cl_null(g_idv[l_ac].idv02) THEN
               IF g_idv[l_ac].idv02 != g_idv_t.idv02 OR
                  g_idv_t.idv02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM idv_file
                    WHERE idv01 = g_idu.idu01
                      AND idv02 = g_idv[l_ac].idv02
                   IF l_n > 0 THEN
                      CALL cl_err('',-239,0)
                      LET g_idv[l_ac].idv02 = g_idv_t.idv02
                      NEXT FIELD idv02
                   END IF
               END IF
            END IF

        AFTER FIELD idv13
           IF NOT cl_null(g_idv[l_ac].idv13) THEN
              SELECT ima02,ima906,ima907,ima25 INTO g_idv[l_ac].ima02_1,g_ima906,g_ima907,g_idv[l_ac].idv17
                 FROM ima_file
                 WHERE ima01=g_idv[l_ac].idv13 AND imaacti='Y'
              IF SQLCA.sqlcode THEN
                 CALL cl_err('sel ima err','abm-202',1)
                 NEXT FIELD idv13
              ELSE
                 IF g_ima906 = '3' THEN
                    LET g_idv[l_ac].idv19 = g_ima907 
                 END IF
                 DISPLAY BY NAME g_idv[l_ac].ima02_1
                 DISPLAY BY NAME g_idv[l_ac].idv17
                 DISPLAY BY NAME g_idv[l_ac].idv19
              END IF
              SELECT imaicd04 INTO l_imaicd04                    #料件狀態
                 FROM imaicd_file,ima_file
                 WHERE ima01=imaicd00 AND ima01=g_idv[l_ac].idv13

              IF cl_null(g_idv[l_ac].idv03) THEN  
                 SELECT MIN(bmb01) INTO  g_idv[l_ac].idv03 FROM bmb_file
                 WHERE bmb03 = g_idv[l_ac].idv13

                 #替代料
                 IF cl_null(g_idv[l_ac].idv03) THEN  
                    SELECT bmb01 INTO  g_idv[l_ac].idv03 
                    FROM (select bmd01,bmd04,bmd05
                          ,bmb01,bmb03,bmb04
                    from bmd_file,bmb_file
                    where bmd01=bmb03
                    and bmd04 =  g_idv[l_ac].idv13
                    and bmdacti='Y'
                    order by bmd01,bmd05 desc) aa         
                    where ROWNUM = 1    
                 END IF
                 
                 #改為讀取下階料號表icm_file                          
                 IF cl_null(g_idv[l_ac].idv03) THEN                 
                    SELECT icm02 INTO  g_idv[l_ac].idv03 
                    FROM (select icm01,icm02 from icm_file
                          WHERE icm01 = g_idv[l_ac].idv13
                          and icmacti='Y'
                          order by icmdate desc) aa         
                    where ROWNUM = 1   
                 END IF   

                 IF SQLCA.sqlcode THEN
                    CALL cl_err('!','abm-742',1)
                 END IF
                 IF cl_null(g_idv[l_ac].idv03) THEN
                    LET g_idv[l_ac].idv03 = g_idv[l_ac].idv13
                 END IF
                 DISPLAY BY NAME g_idv[l_ac].idv03
         
                 SELECT ima906,ima907,ima25#,ta_ima01
                   INTO g_ima906_1,g_ima907_1,g_idv[l_ac].idv25#,g_idv[l_ac].idv31
                    FROM ima_file
                    WHERE ima01=g_idv[l_ac].idv03 AND imaacti='Y'
                 IF SQLCA.sqlcode THEN
                    CALL cl_err('sel ima err','abm-202',1)
                    NEXT FIELD idv03
                 ELSE
                    IF g_ima906_1 = '3' THEN
                       LET g_idv[l_ac].idv27 = g_ima907_1
                    END IF
                    DISPLAY BY NAME g_idv[l_ac].idv25
                    DISPLAY BY NAME g_idv[l_ac].idv27
                 END IF

                 SELECT MAX(pjb02) INTO g_idv[l_ac].idv32
                   FROM pjb_file
                  WHERE pjb01 = g_idv[l_ac].idv31
                    AND pjbacti = 'Y'

              END IF

              IF g_idv[l_ac].idv13 <> g_idv_t.idv13 THEN  
                 SELECT icm02 INTO g_idv[l_ac].idv03 
                   FROM (SELECT icm01,icm02 FROM icm_file
                          WHERE icm01 = g_idv[l_ac].idv13
                            AND icmacti='Y'
                          ORDER BY icmdate DESC) aa         
                    WHERE ROWNUM = 1  
                 DISPLAY BY NAME g_idv[l_ac].idv03  
              END IF
              
              IF g_ima906 = '3' THEN
                 SELECT imgg10 INTO g_idv[l_ac].idv20 FROM imgg_file
                  WHERE imgg01=g_idv[l_ac].idv13 AND imgg02=g_idv[l_ac].idv14
                    AND imgg03=g_idv[l_ac].idv15 AND imgg04=g_idv[l_ac].idv16

                 LET l_idv20 = 0
                 SELECT SUM(idv20) INTO l_idv20 FROM idu_file,idv_file
                  WHERE idu01 = idv01
                    AND iduconf = 'N'
                    AND NOT (idu01 = g_idu.idu01 AND idv02 = g_idv[l_ac].idv02)
                    AND idv13 = g_idv[l_ac].idv13
                    AND idv14 = g_idv[l_ac].idv14
                    AND idv15 = g_idv[l_ac].idv15
                    AND idv16 = g_idv[l_ac].idv16
                    AND idv19 = g_idv[l_ac].idv19
                 IF cl_null(l_idv20) THEN LET l_idv20 = 0 END IF
                 LET g_idv[l_ac].idv20 = g_idv[l_ac].idv20 - l_idv20
              END If
            END IF
            CALL i500_set_no_entry_b()

        AFTER FIELD idv14
            SELECT COUNT(*) INTO l_cnt FROM imd_file
               WHERE imd01=g_idv[l_ac].idv14 AND imdacti='Y'
            IF l_cnt = 0 THEN
               CALL cl_err('sel imd err','aic-034',1)
               NEXT FIELD idv14
            END IF 

        AFTER FIELD idv15
            IF cl_null(g_idv[l_ac].idv15) THEN
               LET g_idv[l_ac].idv15 = ' '
            END IF 

        AFTER FIELD idv16
            IF cl_null(g_idv[l_ac].idv18) THEN
               SELECT img10 INTO g_idv[l_ac].idv18 FROM img_file
                  WHERE img01=g_idv[l_ac].idv13 AND img02=g_idv[l_ac].idv14 
                    AND img03=g_idv[l_ac].idv15 AND img04=g_idv[l_ac].idv16 
               IF SQLCA.sqlcode THEN
                  CALL cl_err('sel img10','aic-331',1)
               ELSE
                  LET l_img10 = 0
                  SELECT SUM(idv18) INTO l_img10 FROM img_file,idv_file,idu_file
                  WHERE img01=g_idv[l_ac].idv13 AND img02=g_idv[l_ac].idv14 
                    AND img03=g_idv[l_ac].idv15 AND img04=g_idv[l_ac].idv16 
                    AND img01=idv13 AND img02=idv14 
                    AND img03=idv15 AND img04=idv16 
                    AND iduconf = 'N' AND idu01=idv01
                    AND idv02 <> g_idv[l_ac].idv02
                  IF cl_null(l_img10) THEN LET l_img10 = 0 END IF
                  LET g_idv[l_ac].idv18 =  g_idv[l_ac].idv18 - l_img10  
               END IF 
               IF g_ima906 = '3' THEN
                  SELECT imgg10 INTO g_idv[l_ac].idv20 FROM imgg_file
                     WHERE imgg01=g_idv[l_ac].idv13 AND imgg02=g_idv[l_ac].idv14 
                       AND imgg03=g_idv[l_ac].idv15 AND imgg04=g_idv[l_ac].idv16 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('!','aic-331',1)
                  END IF 
               END If 
            ELSE
               SELECT COUNT(*) INTO l_cnt FROM img_file
                  WHERE img01=g_idv[l_ac].idv13 AND img02=g_idv[l_ac].idv14 
                    AND img03=g_idv[l_ac].idv15 AND img04=g_idv[l_ac].idv16 
               IF l_cnt = 0 THEN
                  CALL cl_err('!','aic-331',1)
               END IF 
            END IF 
            IF g_idv[l_ac].idv17 = g_idv[l_ac].idv25 THEN
               LET g_idv[l_ac].idv26 = g_idv[l_ac].idv18
            ELSE
               IF cl_null(g_idv[l_ac].idv26) OR g_idv[l_ac].idv18 <> g_idv_t.idv18 OR cl_null(g_idv_t.idv18) THEN
                  SELECT icb05 INTO l_icb05 FROM icb_file,imaicd_file
                      WHERE imaicd00=g_idv[l_ac].idv13 AND imaicd01=icb01 
                  LET g_idv[l_ac].idv26 = g_idv[l_ac].idv18 * l_icb05
                  LET g_idv[l_ac].idv28 = g_idv[l_ac].idv18
               END IF 
            END IF
 
            DECLARE rvbi_cur CURSOR FOR
                SELECT rvbiicd08 FROM rvb_file,rvbi_file
                WHERE rvb01=rvbi01 AND rvb02=rvbi02 AND rvb05=g_idv[l_ac].idv13
                  AND rvb36=g_idv[l_ac].idv14 AND rvb37=g_idv[l_ac].idv15
                  AND rvb38=g_idv[l_ac].idv16
            FOREACH rvbi_cur INTO g_idv[l_ac].idv23
               EXIT FOREACH
            END FOREACH

            CALL i500_set_qty() 
            
            DISPLAY BY NAME g_idv[l_ac].idv16,g_idv[l_ac].idv23,g_idv[l_ac].idv24,g_idv[l_ac].idv26
            DISPLAY BY NAME g_idv[l_ac].idv31,g_idv[l_ac].idv32

        AFTER FIELD idv18
           IF g_idv[l_ac].idv17 = g_idv[l_ac].idv25 THEN
              LET g_idv[l_ac].idv26 = g_idv[l_ac].idv18
              IF l_imaicd04='0' OR l_imaicd04='1' THEN
                 SELECT icb05 INTO l_icb05 FROM icb_file,imaicd_file
                  WHERE imaicd00=g_idv[l_ac].idv13 AND imaicd01=icb01 
                 IF cl_null(l_icb05) THEN LET l_icb05 = 0 END IF  
                 LET g_idv[l_ac].idv28 = g_idv[l_ac].idv18 * l_icb05
              END IF
           ELSE
              #當輸入idv18為0或是由庫存帶入數量時不會變更idv26與idv28
              IF cl_null(g_idv[l_ac].idv26) OR g_idv[l_ac].idv18 <> g_idv_t.idv18 or g_idv[l_ac].idv18=0 THEN

                 SELECT icb05 INTO l_icb05 FROM icb_file,imaicd_file
                  WHERE imaicd00=g_idv[l_ac].idv13 AND imaicd01=icb01 
                 IF cl_null(l_icb05) THEN LET l_icb05 = 0 END IF   
                 LET g_idv[l_ac].idv26 = g_idv[l_ac].idv18 * l_icb05
                 LET g_idv[l_ac].idv28 = g_idv[l_ac].idv18
              END IF
           END IF
           DISPLAY BY NAME g_idv[l_ac].idv26
           DISPLAY BY NAME g_idv[l_ac].idv28
           LET l_img10 = 0
           SELECT img10 INTO l_img10 FROM img_file
            WHERE img01=g_idv[l_ac].idv13 AND img02=g_idv[l_ac].idv14 
              AND img03=g_idv[l_ac].idv15 AND img04=g_idv[l_ac].idv16 

           LET l_idv18 = 0 
           SELECT SUM(idv18) INTO l_idv18 FROM img_file,idv_file,idu_file
            WHERE img01=g_idv[l_ac].idv13 AND img02=g_idv[l_ac].idv14 
              AND img03=g_idv[l_ac].idv15 AND img04=g_idv[l_ac].idv16 
              AND img01=idv13 AND img02=idv14 
              AND img03=idv15 AND img04=idv16 
              AND (idv01 <> g_idu.idu01 OR (idv01=g_idu.idu01 AND idv02 <> g_idv[l_ac].idv02))
              AND idu01=idv01 AND iduconf='N'
           IF cl_null(l_idv18) THEN LET l_idv18 = 0 END IF
           IF l_idv18+g_idv[l_ac].idv18 > l_img10 THEN
              LET g_idv[l_ac].idv18 = l_img10 - l_idv18
              NEXT FIELD idv18
           END IF

           IF l_img10 - l_idv18 <> g_idv[l_ac].idv18 THEN
              #若是重複兩次委工，回來料倉儲批相同，l_idv24就會有值，原始批號的值 add by tenx.winni 20110411
              LET l_idv24 = NULL
              #判斷拆批條件,僅依據批號，查工單最大號回貨批號
              SELECT MAX(idv24) INTO l_idv24 FROM idv_file,idu_file
                 WHERE idv16=g_idv[l_ac].idv16 
                   AND idu01=idv01 
                   AND (idv01 <> g_idu.idu01 OR (idv01=g_idu.idu01 AND idv02 <> g_idv[l_ac].idv02))
                   AND iduconf <> 'X' 
              IF cl_null(l_idv24) THEN #工單中尚未用到原始批號值(料倉儲批)
                 LET l_img04 = NULL
                 #判斷拆批條件,僅依據批號，查庫存批號
                 LET l_sql = "SELECT img04 FROM img_file ",
                             " WHERE img04 LIKE '",g_idv[l_ac].idv16 CLIPPED,"-%'"
                 PREPARE idv24_p FROM l_sql
                 EXECUTE idv24_p INTO l_img04
                 IF cl_null(l_img04) THEN LET l_img04 = ' ' END IF
                 IF cl_null(l_img04) THEN
                    LET g_idv[l_ac].idv24 = g_idv[l_ac].idv16 CLIPPED,'-1'
                 ELSE
                    #LET l_t1  = LENGTH(l_img04)
                    #LET l_tmp = l_img04[l_t1-1,l_t1]
                    #LET l_tmp = l_tmp + 1
                    #IF l_tmp < 10 THEN
                    #   LET g_idv[l_ac].idv24 = g_idv[l_ac].idv16 CLIPPED,'-',l_tmp USING '&'
                    #ELSE
                    #   LET g_idv[l_ac].idv24 = g_idv[l_ac].idv16 CLIPPED,'-',l_tmp USING '&&'
                    IF cl_null(g_idv[l_ac].idv24) THEN
                       LET g_idv[l_ac].idv24 = g_idv[l_ac].idv16 CLIPPED
                    END IF
                 END IF
              ELSE     #工單中已有用到原始批號值(料倉儲批)或已有工單拆批批號
                 LET l_img04 = NULL
                 #判斷拆批條件,僅依據批號，查庫存批號
                 LET l_sql = "SELECT img04 FROM img_file ",
                             " WHERE img04 LIKE '",g_idv[l_ac].idv16 CLIPPED,"-%'"
                 PREPARE idv24_p2 FROM l_sql
                 EXECUTE idv24_p2 INTO l_img04
                 IF cl_null(l_img04) THEN LET l_img04 = ' ' END IF
                 #IF cl_null(l_img04) OR l_img04 < l_idv24 THEN
                    #CALL buf.append(l_idv24)
                    #LET l_count = buf.getIndexOf("-",1)
                    #IF(l_count > 0) THEN   
                        #LET l_t1  = LENGTH(l_idv24)
                        #LET l_tmp = l_idv24[l_t1-1,l_t1]
                        #LET l_tmp = l_tmp + 1

                        #IF l_tmp < 10 THEN
                        #   LET g_idv[l_ac].idv24 = g_idv[l_ac].idv16 CLIPPED,'-',l_tmp USING '&'
                        #ELSE
                        #   LET g_idv[l_ac].idv24 = g_idv[l_ac].idv16 CLIPPED,'-',l_tmp USING '&&'
                        IF cl_null(g_idv[l_ac].idv24) THEN
                           LET g_idv[l_ac].idv24 = g_idv[l_ac].idv16 CLIPPED
                        END IF
                    #ELSE 
                    #   LET g_idv[l_ac].idv24 = g_idv[l_ac].idv16 CLIPPED,'-1'
                    #END IF 
                 #ELSE
                    #LET l_t1  = LENGTH(l_img04)
                    #LET l_tmp = l_img04[l_t1-1,l_t1]
                    #LET l_tmp = l_tmp + 1

                    #IF l_tmp < 10 THEN
                    #   LET g_idv[l_ac].idv24 = g_idv[l_ac].idv16 CLIPPED,'-',l_tmp USING '&'
                    #ELSE
                    #   LET g_idv[l_ac].idv24 = g_idv[l_ac].idv16 CLIPPED,'-',l_tmp USING '&&'
                 #   IF cl_null(g_idv[l_ac].idv24) THEN
                 #      LET g_idv[l_ac].idv24 = g_idv[l_ac].idv16 CLIPPED
                 #   END IF
                 #END IF
              END IF
           ELSE 
              LET g_idv[l_ac].idv24 = g_idv[l_ac].idv16
           END IF
        
        AFTER FIELD idv03
          IF NOT cl_null(g_idv[l_ac].idv03) THEN 
             SELECT COUNT(*) INTO l_cnt FROM bma_file
                WHERE bma01=g_idv[l_ac].idv03 AND bma05 <= g_idu.idu19
             IF l_cnt = 0 THEN
               CALL cl_err('','abm-082',1)
               LET g_idv[l_ac].idv03 = g_idv_t.idv03
               NEXT FIELD idv03
             END IF

            SELECT ima906,ima907,ima25 INTO g_ima906_1,g_ima907_1,g_idv[l_ac].idv25
               FROM ima_file
               WHERE ima01=g_idv[l_ac].idv03 AND imaacti='Y'
            IF SQLCA.sqlcode THEN
               CALL cl_err('sel ima err','abm-202',1)
               NEXT FIELD idv03
            ELSE
               IF g_ima906_1 = '3' THEN
                  LET g_idv[l_ac].idv27 = g_ima907_1
               END IF
               DISPLAY BY NAME g_idv[l_ac].idv03
               DISPLAY BY NAME g_idv[l_ac].idv25
               DISPLAY BY NAME g_idv[l_ac].idv27
            END IF
            #叛斷料號與製程是否配對正確
            SELECT ecdicd01 INTO l_ecdicd01 FROM ecd_file WHERE ecd01=g_idu.idu13

            SELECT imaicd04,imaicd02 INTO l_imaicd04,l_imaicd02 FROM imaicd_file 
               WHERE imaicd00=g_idv[l_ac].idv03

            CASE WHEN l_imaicd04='2' #CP
                      IF l_ecdicd01 <> '2' AND l_ecdicd01 <> '6' THEN
                         CALL cl_err(l_ecdicd01,'aic-336',1)
                         NEXT FIELD idv03
                      END IF 
                 WHEN l_imaicd04='3' #DS AS 
                      IF l_ecdicd01 <> '3' AND l_ecdicd01 <> '4' and l_ecdicd01 <> '6' THEN
                         CALL cl_err(l_ecdicd01,'aic-336',1)
                         NEXT FIELD idv03
                      END IF 
                 WHEN l_imaicd04='4' #FT
                      IF l_ecdicd01 <> '5' AND l_ecdicd01 <> '6' THEN
                         CALL cl_err(l_ecdicd01,'aic-336',1)
                         NEXT FIELD idv03
                      END IF 
            END CASE

            CALL i500_set_qty()

          END IF 

        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF

            IF cl_null(g_idv[l_ac].idv18) THEN LET g_idv[l_ac].idv18 = 0 END IF
            IF cl_null(g_idv[l_ac].idv20) THEN LET g_idv[l_ac].idv20 = 0 END IF
            IF cl_null(g_idv[l_ac].idv26) THEN LET g_idv[l_ac].idv26 = 0 END IF
            IF cl_null(g_idv[l_ac].idv28) THEN LET g_idv[l_ac].idv28 = 0 END IF
            INSERT INTO idv_file
                   (idv01,idv02,idv03,idv04,idv12,idv13,idv14,idv15,idv16,
                    idv17,idv18,idv19,idv20,idv21,idv22,idv23,idv24,
                    idv25,idv26,idv27,idv28,idv29,idv30,idv09,
                    idv31,idv32,
                    idvplant,idvlegal)    
             VALUES(g_idu.idu01,g_idv[l_ac].idv02,g_idv[l_ac].idv03,g_idv[l_ac].idv04,
                    g_idv[l_ac].idv12,g_idv[l_ac].idv13,
                    g_idv[l_ac].idv14,g_idv[l_ac].idv15,
                    g_idv[l_ac].idv16,g_idv[l_ac].idv17,
                    g_idv[l_ac].idv18,g_idv[l_ac].idv19,
                    g_idv[l_ac].idv20,g_idv[l_ac].idv21,
                    g_idv[l_ac].idv22,g_idv[l_ac].idv23,
                    g_idv[l_ac].idv24,g_idv[l_ac].idv25,
                    g_idv[l_ac].idv26,g_idv[l_ac].idv27,
                    g_idv[l_ac].idv28,g_idv[l_ac].idv29,
                    g_idv[l_ac].idv30,g_idv[l_ac].idv09,
                    g_idv[l_ac].idv31,g_idv[l_ac].idv32,
                    g_plant,g_legal)      
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","idv_file",g_idu.idu01,g_idv[l_ac].idv02,SQLCA.sqlcode,"","",1)  #No.FUN-660128
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn3
            END IF

        BEFORE DELETE                            #是否取消單身
            IF g_idv_t.idv02 > 0 AND g_idv_t.idv02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM idv_file
                 WHERE idv01 = g_idu.idu01
                   AND idv02 = g_idv_t.idv02
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","idv_file",g_idu.idu01,g_idv_t.idv02,SQLCA.sqlcode,"","",1)  #No.FUN-660128
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                DELETE FROM idw_file
                 WHERE idw01 = g_idu.idu01 AND idw02 = g_idv_t.idv02
                LET g_rec_b=g_rec_b-1
                CALL i500sub_del_data(l_table,g_idv_t.idv02)

                DISPLAY g_rec_b TO FORMONLY.cn3
                COMMIT WORK
                CALL i500_b_tot()
            END IF

        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_idv[l_ac].* = g_idv_t.*
               CLOSE i500_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_idv[l_ac].idv02,-263,1)
               LET g_idv[l_ac].* = g_idv_t.*
            ELSE
               UPDATE idv_file SET idv02=g_idv[l_ac].idv02,
                                   idv03=g_idv[l_ac].idv03,
                                   idv04=g_idv[l_ac].idv04,
                               idv12=g_idv[l_ac].idv12,
                               idv13=g_idv[l_ac].idv13,
                               idv14=g_idv[l_ac].idv14,
                               idv15=g_idv[l_ac].idv15,
                               idv16=g_idv[l_ac].idv16,
                               idv17=g_idv[l_ac].idv17,
                               idv18=g_idv[l_ac].idv18,
                               idv19=g_idv[l_ac].idv19,
                               idv20=g_idv[l_ac].idv20,
                               idv21=g_idv[l_ac].idv21,
                               idv22=g_idv[l_ac].idv22,
                               idv23=g_idv[l_ac].idv23,
                               idv24=g_idv[l_ac].idv24,
                               idv25=g_idv[l_ac].idv25,
                               idv26=g_idv[l_ac].idv26,
                               idv27=g_idv[l_ac].idv27,
                               idv28=g_idv[l_ac].idv28,
                               idv29=g_idv[l_ac].idv29,
                               idv30=g_idv[l_ac].idv30,
                               idv31=g_idv[l_ac].idv31,
                               idv32=g_idv[l_ac].idv32 
                WHERE idv01=g_idu.idu01
                  AND idv02=g_idv_t.idv02
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","idv_file",g_idu.idu01,g_idv_t.idv02,SQLCA.sqlcode,"","",1)  #No.FUN-660128
                   LET g_idv[l_ac].* = g_idv_t.*
               ELSE
                   UPDATE idw_file
                      SET idw02 = g_idv[l_ac].idv02
                      WHERE idw01 = g_idu.idu01 AND idw02 = g_idv_t.idv02

                   LET l_sql = "UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED,
                               "   SET item1 = ",g_idv[l_ac].idv02,
                               " WHERE item1 = ",g_idv_t.idv02
                   PREPARE i500_upd_b FROM l_sql
                   EXECUTE i500_upd_b

                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
               CALL i500_b_tot()
            END IF

        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac#FUN-D40030 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_idv[l_ac].* = g_idv_t.*
              #FUN-D40030--add--str
               ELSE
                  CALL g_idv.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
              #FUN-D40030--add--end
               END IF
               CLOSE i500_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac#FUN-D40030 add
            CALL i500_b_tot()
            CLOSE i500_bcl
            COMMIT WORK
      ON ACTION controls
       CALL cl_set_head_visible("","AUTO")
        ON ACTION CONTROLZ
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
            CALL cl_cmdask()

        ON ACTION controlp
           CASE WHEN INFIELD(idv13)
                     CALL q_sel_ima(FALSE, "q_ima","",g_idv[l_ac].idv13,"","","","","",'' ) 
                         RETURNING g_idv[l_ac].idv13 
                     DISPLAY BY NAME g_idv[l_ac].idv13
                     NEXT FIELD idv13
                WHEN INFIELD(idv14)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_imd"
                     LET g_qryparam.default1 = g_idv[l_ac].idv14
                     LET g_qryparam.arg1     = 'SW'        #倉庫類別 
                     CALL cl_create_qry() RETURNING g_idv[l_ac].idv14
                     DISPLAY BY NAME g_idv[l_ac].idv14
                     NEXT FIELD idv14
                WHEN INFIELD(idv16) OR INFIELD(idv15)
                     CALL q_idc(FALSE,FALSE,g_idv[l_ac].idv13,g_idv[l_ac].idv14,g_idv[l_ac].idv15,g_idv[l_ac].idv16)
                        RETURNING g_idv[l_ac].idv14,g_idv[l_ac].idv15,g_idv[l_ac].idv16
                     DISPLAY BY NAME g_idv[l_ac].idv15,g_idv[l_ac].idv16
                     NEXT FIELD idv16                     
                WHEN INFIELD(idv03)
                     CALL q_sel_ima(FALSE, "q_ima18","",g_idv[l_ac].idv03,"","","","","",'' )   
                        RETURNING g_idv[l_ac].idv03 
                     DISPLAY BY NAME g_idv[l_ac].idv03
                     NEXT FIELD idv03
                WHEN INFIELD(idv17)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_idv[l_ac].idv17
                     CALL cl_create_qry() RETURNING g_idv[l_ac].idv17
                     DISPLAY BY NAME g_idv[l_ac].idv17
                     NEXT FIELD idv17
                WHEN INFIELD(idv19)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_idv[l_ac].idv19
                     CALL cl_create_qry() RETURNING g_idv[l_ac].idv19
                     DISPLAY BY NAME g_idv[l_ac].idv19
                     NEXT FIELD idv19
                WHEN INFIELD(idv25)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_idv[l_ac].idv25
                     CALL cl_create_qry() RETURNING g_idv[l_ac].idv25
                     DISPLAY BY NAME g_idv[l_ac].idv25
                     NEXT FIELD idv25
                WHEN INFIELD(idv27)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_idv[l_ac].idv27
                     CALL cl_create_qry() RETURNING g_idv[l_ac].idv27
                     DISPLAY BY NAME g_idv[l_ac].idv27
                     NEXT FIELD idv27
                WHEN INFIELD(idv29)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_pmc"
                     LET g_qryparam.default1 = g_idv[l_ac].idv29
                     CALL cl_create_qry() RETURNING g_idv[l_ac].idv29
                     DISPLAY BY NAME g_idv[l_ac].idv29
                     NEXT FIELD idv29
                WHEN INFIELD(idv22)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_ecu04"  
                     LET g_qryparam.default1 = g_idv[l_ac].idv22
                     CALL cl_create_qry() RETURNING g_idv[l_ac].idv22
                     DISPLAY BY NAME g_idv[l_ac].idv22
                     NEXT FIELD idv22
                WHEN INFIELD(idv21)            #作業編號
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_ecd02_icd"
                     LET g_qryparam.default1 = g_idv[l_ac].idv21
                     CALL cl_create_qry() RETURNING g_idv[l_ac].idv21
                     DISPLAY BY NAME g_idv[l_ac].idv21
                     NEXT FIELD idv21
                WHEN INFIELD(idv31) 
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_pja"
                     LET g_qryparam.default1 = g_idv[l_ac].idv31
                     CALL cl_create_qry() RETURNING g_idv[l_ac].idv31
                     DISPLAY BY NAME g_idv[l_ac].idv31
                     NEXT FIELD idv31
            END CASE

        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT

    END INPUT

     LET g_idu.idumodu = g_user
     LET g_idu.idumodd = g_today
     UPDATE idu_file SET idumodu = g_idu.idumodu,idumodd = g_idu.idumodd
      WHERE idu01 = g_idu.idu01
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
        CALL cl_err3("upd","idu_file",g_idu01_t,"",SQLCA.sqlcode,"","upd idu",1) 
     END IF
     DISPLAY BY NAME g_idu.idumodu,g_idu.idumodd

    CLOSE i500_bcl
    COMMIT WORK

    #產生g_data
    CALL g_data.clear()

    LET l_cnt = 0
    DECLARE idv_cur CURSOR FOR
        SELECT * FROM idv_file WHERE idv01=g_idu.idu01
        ORDER BY idv02 
    FOREACH idv_cur INTO l_idv.*

        LET l_cnt = l_idv.idv02
        LET g_data[l_cnt].sel       = 'Y'                         #挑選
        LET g_data[l_cnt].rvv01     = l_idv.idv01                 #入庫單號
        LET g_data[l_cnt].rvv02     = l_idv.idv02                 #入庫單項次b
        LET g_data[l_cnt].rvv31     = l_idv.idv13             #料件編號
        LET g_data[l_cnt].rvv031    = ''                          #品名
        SELECT imaicd04 INTO g_data[l_cnt].imaicd04               #料件狀態
           FROM imaicd_file,ima_file 
           WHERE ima01=imaicd00 AND ima01=l_idv.idv13
        LET g_data[l_cnt].rvv32     = l_idv.idv14             #倉庫
        LET g_data[l_cnt].rvv33     = l_idv.idv15             #儲位
        LET g_data[l_cnt].rvv34     = l_idv.idv16             #批號
        LET g_data[l_cnt].pmn63     = 'Y'                         #急件
        LET g_data[l_cnt].sfbiicd10 = 'N'                         #multi die
        LET g_data[l_cnt].pmniicd12 = ''                          #廠別
        LET g_data[l_cnt].sfbiicd07 = l_idv.idv23             #Date Code
        LET g_data[l_cnt].rvv17     = l_idv.idv18             #入庫數量
        LET g_data[l_cnt].rvv85     = l_idv.idv20             #入庫數量
        SELECT imaicd01,icb05 INTO g_data[l_cnt].sfbiicd14,g_data[l_cnt].icb05  
            FROM imaicd_file,icb_file 
            WHERE imaicd01=icb01 AND imaicd00=l_idv.idv13  
        LET g_data[l_cnt].sfbiicd14 = l_idv.idv13             #Date Code
        LET g_data[l_cnt].sfbiicd09 = l_idv.idv21             #作業編號
        LET g_data[l_cnt].sfb05     = l_idv.idv03                 #完成料號
        LET g_data[l_cnt].sfb27     = l_idv.idv31             #專案編號 
        LET g_data[l_cnt].sfb271    = l_idv.idv32             #WBS編號  
        SELECT ima02 INTO g_data[l_cnt].sfbiicd08 FROM ima_file WHERE ima01=l_idv.idv03 
        LET g_data[l_cnt].sfb82     = g_idu.idu11             #廠商編號
        LET g_data[l_cnt].pmc03_1   = g_pmc03                     #廠商簡稱
        SELECT imaicd04 INTO l_imaicd04 FROM imaicd_file WHERE imaicd00=l_idv.idv03
        IF l_imaicd04 = '2' THEN
           LET g_data[l_cnt].sfb08     = l_idv.idv28          #生產數量
           LET g_data[l_cnt].sfbiicd06 = l_idv.idv26          #生產參考數量
        ELSE
           LET g_data[l_cnt].sfb08     = l_idv.idv26          #生產數量
           LET g_data[l_cnt].sfbiicd06 = l_idv.idv28          #生產參考數量
        END IF
        LET g_data[l_cnt].sfb15     = l_idv.idv04                 #預定交貨日期
        LET g_data[l_cnt].sfbiicd02 = ''                          #wafer廠商
        LET g_data[l_cnt].sfbiicd03 = ''                          #wafer site
        LET g_data[l_cnt].sfb06     = l_idv.idv22             #製程編號
        LET g_data[l_cnt].sfbiicd01 = l_idv.idv29             #下階段廠商
        LET g_data[l_cnt].pmc03_2   = ''                          #廠商簡稱
        LET g_data[l_cnt].sfbiicd13 = l_idv.idv24             #回貨批號
        LET g_data[l_cnt].meno      = ''                          #備註
        CALL i500_ins_bin_temp(l_cnt)
        CALL i500_refresh_b2(l_cnt)
    END FOREACH
    CALL i500_save()
    CALL i500_show()
END FUNCTION

FUNCTION i500_set_qty()
   DEFINE l_imaicd04      LIKE imaicd_file.imaicd04,
          t_imaicd04      LIKE imaicd_file.imaicd04,
          l_icb05         LIKE icb_file.icb05

   #發料料號
   LET l_imaicd04 = ''
   SELECT imaicd04 INTO l_imaicd04 FROM imaicd_file
    WHERE imaicd00 = g_idv[l_ac].idv13
   #生產料號
   LET t_imaicd04 = ''
   SELECT imaicd04 INTO t_imaicd04 FROM imaicd_file
    WHERE imaicd00 = g_idv[l_ac].idv03
          
   IF l_imaicd04 = '1' THEN
      LET l_icb05 = 0
      SELECT icb05 INTO l_icb05 FROM icb_file WHERE icb01 = g_idv[l_ac].idv13
      IF cl_null(l_icb05) THEN LET l_icb05 = 0 END IF
      CASE
         WHEN t_imaicd04 = '2'
            LET g_idv[l_ac].idv26 = g_idv[l_ac].idv18
            LET g_idv[l_ac].idv28 = g_idv[l_ac].idv18 * l_icb05
            
         WHEN t_imaicd04 = '3' OR t_imaicd04 = '4'
            LET g_idv[l_ac].idv26 = g_idv[l_ac].idv18 * l_icb05
            LET g_idv[l_ac].idv28 = NULL
         OTHERWISE EXIT CASE
      END CASE
   END IF
             
   IF l_imaicd04 = '2' THEN
      CASE
         WHEN t_imaicd04 = '2'
            LET g_idv[l_ac].idv26 = g_idv[l_ac].idv18
            LET g_idv[l_ac].idv28 = g_idv[l_ac].idv20
            
         WHEN t_imaicd04 = '3' OR t_imaicd04 = '4'
            LET g_idv[l_ac].idv26 = g_idv[l_ac].idv20
            LET g_idv[l_ac].idv28 = NULL
         OTHERWISE EXIT CASE
      END CASE
   END IF
            
   IF l_imaicd04 = '3' THEN
      CASE
         WHEN t_imaicd04 = '3' OR t_imaicd04 = '4'
            LET g_idv[l_ac].idv26 = g_idv[l_ac].idv18
            LET g_idv[l_ac].idv28 = NULL
         OTHERWISE EXIT CASE
      END CASE
   END IF

END FUNCTION 

FUNCTION i500_set_entry_b()
   DEFINE l_field STRING

   IF INFIELD(idv13) THEN
      CALL cl_set_comp_entry('idv19,idv20',TRUE)
   END IF

END FUNCTION

FUNCTION i500_set_no_entry_b()
  DEFINE p_cmd   LIKE type_file.chr1,
         l_field STRING

    IF INFIELD(idv13) THEN
       IF g_ima906 = '1' THEN
          CALL cl_set_comp_entry('idv19,idv20',FALSE)
       END IF  
    END IF

END FUNCTION

FUNCTION i500_set_entry_b2()
    CALL cl_set_comp_entry("ima01",TRUE)
    CALL cl_set_comp_entry("sfbiicd08_b",TRUE)
END FUNCTION

FUNCTION i500_set_no_entry_b2(p_ac)
    DEFINE p_ac LIKE type_file.num10

    IF g_idc[l_ac2].sel2 = 'N' THEN
       CALL cl_set_comp_entry("ima01",FALSE)
       CALL cl_set_comp_entry("sfbiicd08_b",FALSE)
    ELSE
       #料件狀態為2,且為DG才可維護 ima01
       IF NOT (g_data[p_ac].imaicd04 = '2'
          AND g_idc[l_ac2].icf05 = '1') THEN
          CALL cl_set_comp_entry("ima01",FALSE)
          CALL cl_set_comp_entry("sfbiicd08_b",FALSE)
       END IF
    END IF
END FUNCTION

FUNCTION i500_set_required_b2(p_ac)
   DEFINE p_ac LIKE type_file.num10
   DEFINE l_ecdicd01  LIKE ecd_file.ecdicd01

   #料件狀態為2且為DG必填 ima01
   IF g_idc[l_ac2].sel2 = 'Y' AND
      g_data[p_ac].imaicd04 = '2' AND
      g_idc[l_ac2].icf05 = '1' THEN
      CALL cl_set_comp_required("ima01",TRUE)

      LET l_ecdicd01 = ''
      #若要產生的工單作業群組為456,則產品型號必填
      CALL i500sub_ecdicd01(g_data[p_ac].sfbiicd09)  
           RETURNING l_ecdicd01
      IF l_ecdicd01 MATCHES '[456]' THEN
         CALL cl_set_comp_required("sfbiicd08_b",TRUE)
      END IF
   END IF
END FUNCTION

FUNCTION i500_set_no_required_b2()
    CALL cl_set_comp_required("ima01",FALSE)
    CALL cl_set_comp_required("sfbiicd08_b",FALSE)
END FUNCTION

FUNCTION i500_ins_bin_temp(p_ac)
  DEFINE p_ac        LIKE type_file.num5
  DEFINE l_ecdicd01  LIKE ecd_file.ecdicd01
  DEFINE l_qty       LIKE idc_file.idc08
  DEFINE l_icf01     LIKE icf_file.icf01 #bin item
  DEFINE l_sql       STRING
  DEFINE l_cnt       LIKE type_file.num10
  DEFINE l_imaicd08  LIKE imaicd_file.imaicd08
  DEFINE l_idw08  LIKE idw_file.idw08      
  DEFINE l_idw09  LIKE idw_file.idw09      

  SELECT imaicd08 INTO l_imaicd08 FROM imaicd_file
   WHERE imaicd00 = g_data[p_ac].rvv31
  #入庫料號狀態為[0-2],且須做刻號管理才要維護BIN刻號資料
  IF cl_null(g_data[p_ac].imaicd04) OR
     g_data[p_ac].imaicd04 NOT MATCHES '[0124]' OR    #入庫料號狀態為[0-2]
     cl_null(l_imaicd08) OR l_imaicd08 <> 'Y' THEN  #須做刻號管理
     CALL i500sub_del_data(l_table,p_ac)
     RETURN
  END IF

  IF g_data[p_ac].sel = 'N' THEN
     CALL i500sub_del_data(l_table,p_ac)
     RETURN
  END IF

  #取得庫存數量
  CALL i500sub_qty(g_data[p_ac].sfbiicd09,g_data[p_ac].imaicd04,g_data[p_ac].rvv31,
       g_data[p_ac].rvv32,g_data[p_ac].rvv33,g_data[p_ac].rvv34,g_data[p_ac].sfbiicd10,
       g_data[p_ac].sfbiicd14)
  RETURNING l_qty

  #若g_data[p_ac].sel = 'Y'且無bin維護記錄 =>新增bin維護記錄
  LET g_cnt = 0
  LET l_sql = "SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " WHERE item1 = ",p_ac
   PREPARE r406_bin_temp02 FROM l_sql
   DECLARE bin_count_cs1 CURSOR FOR r406_bin_temp02
   OPEN bin_count_cs1
   FETCH bin_count_cs1 INTO g_cnt
  #bin_temp沒資料就自動新增
  IF g_cnt = 0 THEN
     IF g_data[p_ac].imaicd04 = '2' OR g_data[p_ac].imaicd04 = '4'  THEN
        CALL i500sub_icf01(g_data[p_ac].rvv31,g_data[p_ac].rvv32,g_data[p_ac].rvv33,
                           g_data[p_ac].rvv34,g_data[p_ac].sfbiicd14)
        RETURNING l_icf01
        IF cl_null(l_icf01) THEN CALL cl_err('','aic-132',0) RETURN END IF
        LET l_sql =
            "SELECT 'N',0,idc05,idc06,icf03,icf05,",
            "       (idc08-idc21), ",
            "       idc12 *((idc08-idc21)/idc08),",
            "       '',''",
            "  FROM idc_file,icf_file ",
            " WHERE idc01 = '",g_data[p_ac].rvv31,"'",
            "   AND idc02 = '",g_data[p_ac].rvv32,"'",
            "   AND idc03 = '",g_data[p_ac].rvv33,"'",
            "   AND idc04 = '",g_data[p_ac].rvv34,"'",
            "   AND (idc08 - idc21) > 0 ",
            "   AND idc16 IN ('Y','N') ",
            "   AND idc17 = 'N'",
            "   AND icf01 = '",l_icf01,"'",
            "   AND icf02 = idc06 ",
            "  ORDER BY idc06,idc05 "

        CALL i500sub_ecdicd01(g_data[p_ac].sfbiicd09) RETURNING l_ecdicd01 
        IF l_ecdicd01 MATCHES '[34]' AND g_data[p_ac].sfbiicd10 = 'Y' THEN
           LET l_sql = l_sql CLIPPED, " AND icf05 <> '1' "
        END IF
     ELSE
        LET l_sql =
            "SELECT 'N',0,idc05,idc06,'','',",
            "       (idc08-idc21), ",
            "       idc12 *((idc08-idc21)/idc08), ",
            "       '',''",
            "  FROM idc_file ",
            " WHERE idc01 = '",g_data[p_ac].rvv31,"'",
            "   AND idc02 = '",g_data[p_ac].rvv32,"'",
            "   AND idc03 = '",g_data[p_ac].rvv33,"'",
            "   AND idc04 = '",g_data[p_ac].rvv34,"'",
            "   AND idc17 = 'N'",
            "   AND (idc08 - idc21) > 0 ",
            " ORDER BY idc05,idc06 "
     END IF

     DECLARE bin_gen_cs CURSOR FROM l_sql
     CALL g_idc.clear()
     LET l_cnt = 1
     LET g_rec_b2 = 0

     FOREACH bin_gen_cs INTO g_idc[l_cnt].*
        LET g_idc[l_cnt].item = l_cnt
        IF l_qty = g_data[p_ac].sfb08 OR l_qty = g_data[p_ac].sfbiicd06 THEN #數量若相等就全勾選
           LET g_idc[l_cnt].sel2 = 'Y'
        END IF

        LET l_idw08 = 0
        LET l_idw09 = 0
        SELECT SUM(idw08),SUM(idw09) INTO l_idw08,l_idw09
          FROM idu_file,idv_file,idw_file
         WHERE idu01 = idv01
           AND idv01 = idw01
           AND idv02 = idw02
           AND NOT (idw01 = g_idu.idu01 AND idw02 = p_ac)
           AND idv13= g_data[p_ac].rvv31      #發料料號
           AND idv14= g_data[p_ac].rvv32      #倉
           AND idv15= g_data[p_ac].rvv33      #儲
           AND idv16= g_data[p_ac].rvv34      #批
           AND idw04 = g_idc[l_cnt].idc05
           AND idw05 = g_idc[l_cnt].idc06
           AND idw13 = 'Y'
           AND iduconf  = 'N'     #未確認
        IF cl_null(l_idw08) THEN LET l_idw08 = 0 END IF
        IF cl_null(l_idw09) THEN LET l_idw09 = 0 END IF
        LET g_idc[l_cnt].qty1 = g_idc[l_cnt].qty1 - l_idw08
        LET g_idc[l_cnt].qty2 = g_idc[l_cnt].qty2 - l_idw09

        IF g_idc[l_cnt].qty1 <= 0 THEN CONTINUE FOREACH END IF

        #在勾選單身二後,並且符合料件狀態為2且為刻號性質為D/G時,
        #抓取符合條件(與主生產料號/產品型號不同)的第一筆資料
        #當生產料號與產品型號的預設值
        #(生產料號/產品型號為空白時,才需做此預設動作)
        CALL i500sub_def_idc(g_idc[l_cnt].sel2,g_data[p_ac].imaicd04,g_idc[l_cnt].icf05,
                          g_idc[l_cnt].ima01,g_data[p_ac].rvv31,g_data[p_ac].sfb05,
                          g_idc[l_cnt].sfbiicd08_b,g_data[p_ac].sfbiicd14,g_data[p_ac].sfbiicd08)
             RETURNING g_idc[l_cnt].ima01,
                       g_idc[l_cnt].sfbiicd08_b
    
        #因為後續要用該欄位做group,所以不可存null
        IF cl_null(g_idc[l_cnt].sfbiicd08_b) THEN
           LET g_idc[l_cnt].sfbiicd08_b = ' '
        END IF

        LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,"(item1,sel2,item2, ",
                    " idc05,idc06,icf03,icf05,qty1,qty2,ima01,ima02,sfbiicd08_b,chk) ", 
                    " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?)"
                    
        PREPARE insert_prep FROM g_sql
        IF STATUS THEN
           CALL cl_err('insert_prep:',status,1) 
           CALL cl_used(g_prog,g_time,2)  RETURNING g_time
           EXIT PROGRAM
        END IF   
        EXECUTE insert_prep USING p_ac,g_idc[l_cnt].*     
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           CALL cl_err('gen data error:',SQLCA.sqlcode,1)
           RETURN
        END IF
        LET l_cnt = l_cnt + 1
        IF l_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
      END FOREACH
      CALL g_idc.deleteElement(l_cnt)
      LET g_rec_b2 = l_cnt - 1
      LET l_cnt = 0
  END IF
END FUNCTION

FUNCTION i500_refresh_b2(p_ac)
   DEFINE p_ac LIKE type_file.num5

   CALL i500_fill2(p_ac)
   DISPLAY ARRAY g_idc TO s_idc.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
     BEFORE DISPLAY
     EXIT DISPLAY
   END DISPLAY
END FUNCTION

#單身2
FUNCTION i500_b2(p_ac)
DEFINE p_ac            LIKE type_file.num5
DEFINE t_ac            LIKE type_file.num5
DEFINE l_img04         LIKE img_file.img04,
       l_img10         LIKE img_file.img10,
       l_t1,l_tmp      LIKE type_file.num5,
       l_idv18     LIKE idv_file.idv18,
       l_idv24     LIKE idv_file.idv24
DEFINE l_ac_t          LIKE type_file.num5,              #未取消的ARRAY CNT
       l_imaicd04      LIKE imaicd_file.imaicd04,
       t_imaicd04      LIKE imaicd_file.imaicd04,
       l_cnt           LIKE type_file.num5,              #檢查重複用
       l_sql           STRING,
       l_ecdicd01      LIKE ecd_file.ecdicd01,
       l_qty           LIKE idc_file.idc08,
       l_qty2          LIKE idc_file.idc08,
       l_count         INTEGER, 
       buf             base.StringBuffer  
DEFINE l_idc_s         RECORD
                         sel2      LIKE type_file.chr1,         #勾選
                         item      LIKE type_file.num10,        #項次
                         idc05     LIKE idc_file.idc05,         #刻號
                         idc06     LIKE idc_file.idc06,         #BIN值
                         icf03     LIKE icf_file.icf03,         #BIN值名稱
                         icf05     LIKE icf_file.icf05,         #BIN值屬性
                         qty1      LIKE idc_file.idc08,         #未備置量
                         qty2      LIKE idc_file.idc08,         #未備置量(die)
                         ima01     LIKE ima_file.ima01,         #料號
                         ima02     LIKE ima_file.ima02,         #品名
                         sfbiicd08_b  LIKE sfbi_file.sfbiicd08  #產品型號
                       END RECORD
DEFINE l_idc           RECORD
                         sel2      LIKE type_file.chr1,         #勾選
                         item      LIKE type_file.num10,        #項次
                         idc05     LIKE idc_file.idc05,         #刻號
                         idc06     LIKE idc_file.idc06,         #BIN值
                         icf03     LIKE icf_file.icf03,         #BIN值名稱
                         icf05     LIKE icf_file.icf05,         #BIN值屬性
                         qty1      LIKE idc_file.idc08,         #未備置量
                         qty2      LIKE idc_file.idc08,         #未備置量(die)
                         ima01     LIKE ima_file.ima01,         #料號
                         ima02     LIKE ima_file.ima02,         #品名
                         sfbiicd08_b  LIKE sfbi_file.sfbiicd08  #產品型號
                       END RECORD
   LET buf = base.StringBuffer.create() 
                       
   IF g_rec_b2 = 0 THEN RETURN END IF

    IF g_idu.iduconf = 'X'   THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_idu.iduconf = 'Y'   THEN CALL cl_err('','axm-101',0) RETURN END IF

   #更新bin刻號的最新數量
   CALL i500_upd_bin(p_ac)

   CALL i500sub_ecdicd01(g_data[p_ac].sfbiicd09) RETURNING l_ecdicd01  

   INPUT ARRAY g_idc WITHOUT DEFAULTS FROM s_idc.*
      ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)

      BEFORE INPUT
         IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(l_ac2)
         END IF

      BEFORE ROW
         LET l_ac2 = ARR_CURR()
         LET g_idc_t.* = g_idc[l_ac2].*
         NEXT FIELD sel2

      BEFORE FIELD sel2
         CALL i500_set_entry_b2()
         CALL i500_set_no_required_b2()

      ON CHANGE sel2
         IF g_idc[l_ac2].sel2 = 'Y' THEN
            LET l_qty = 0

            IF l_ecdicd01 = '2' THEN
                LET l_sql = "SELECT SUM(qty1) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                            " WHERE item1 = ",p_ac,
                            "   AND sel2 = 'Y' ",
                            "   AND item2 <> ",g_idc_t.item
                PREPARE r406_bin_temp04 FROM l_sql
                DECLARE bin_sum_cs CURSOR FOR r406_bin_temp04
                OPEN bin_sum_cs
                FETCH bin_sum_cs INTO l_qty
               IF cl_null(l_qty) THEN LET l_qty = 0 END IF
               LET l_qty = l_qty + g_idc[l_ac2].qty1
            ELSE
               LET l_sql = "SELECT SUM(qty2) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                            " WHERE item1 = ",p_ac,
                            "   AND sel2 = 'Y' ",
                            "   AND item2 <> ",g_idc_t.item
                PREPARE r406_bin_temp05 FROM l_sql
                DECLARE bin_sum_cs1 CURSOR FOR r406_bin_temp05
                OPEN bin_sum_cs1
                FETCH bin_sum_cs1 INTO l_qty
               IF cl_null(l_qty) THEN LET l_qty = 0 END IF
               LET l_qty = l_qty + g_idc[l_ac2].qty2
            END IF
         END IF

        CALL i500sub_def_idc(g_idc[l_ac2].sel2,g_data[p_ac].imaicd04,g_idc[l_ac2].icf05,
                          g_idc[l_ac2].ima01,g_data[p_ac].rvv31,g_data[p_ac].sfb05,
                          g_idc[l_ac2].sfbiicd08_b,g_data[p_ac].sfbiicd14,g_data[p_ac].sfbiicd08)
             RETURNING g_idc[l_ac2].ima01,
                       g_idc[l_ac2].sfbiicd08_b
        DISPLAY BY NAME g_idc[l_ac2].ima01,
                        g_idc[l_ac2].sfbiicd08_b

      AFTER FIELD sel2 #挑選
         IF NOT cl_null(g_idc[l_ac2].sel2) THEN
            IF g_idc[l_ac2].sel2 NOT MATCHES '[YN]' THEN
               NEXT FIELD sel2
            END IF
         END IF
         CALL i500_set_no_entry_b2(p_ac)
         CALL i500_set_required_b2(p_ac)

      AFTER FIELD ima01 #料號
         IF NOT cl_null(g_idc[l_ac2].ima01) THEN
            CALL i500_ima01(p_ac)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_idc[l_ac2].ima01,g_errno,0)
               NEXT FIELD ima01
            END IF
         END IF

      AFTER FIELD qty2
         IF NOT cl_null(g_idc[l_ac2].qty2) THEN
            IF g_idc[l_ac2].qty2 < 0 THEN
               CALL cl_err(g_idc[l_ac2].qty2,'afa-043',0)
               NEXT FIELD qty2
            END IF
            LET g_idc[l_ac2].qty1 = g_idc_t.qty1 * g_idc[l_ac2].qty2 / g_idc_t.qty2
            DISPLAY BY NAME g_idc[l_ac2].qty1
         END IF

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_idc[l_ac2].* = g_idc_t.*
            EXIT INPUT
         END IF

         #料件狀態為2且為DG必填 ima01
         IF g_idc[l_ac2].sel2 = 'Y' AND
            g_data[p_ac].imaicd04 = '2' AND
            g_idc[l_ac2].icf05 = '1' THEN
            IF cl_null(g_idc[l_ac2].ima01) THEN
               NEXT FIELD ima01
            END IF
         
            LET l_ecdicd01 = ''
            #若要產生的工單作業群組為456,則產品型號必填
            CALL i500sub_ecdicd01(g_data[p_ac].sfbiicd09)  
                 RETURNING l_ecdicd01
            IF l_ecdicd01 MATCHES '[456]' THEN
               IF cl_null(g_idc[l_ac2].sfbiicd08_b) THEN
                  NEXT FIELD sfbiicd08_b
               END IF
            END IF
         END IF

         #因為後續要用該欄位做group,所以不可存null
         IF cl_null(g_idc[l_ac2].sfbiicd08_b) THEN
            LET g_idc[l_ac2].sfbiicd08_b = ' '
         END IF
         IF cl_null(g_idc[l_ac2].qty2) THEN LET g_idc[l_ac2].qty2 = 0 END IF
         LET l_sql = "UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     "   SET sel2 = '",g_idc[l_ac2].sel2,"',",
                     "       qty1  = ",g_idc[l_ac2].qty1,",",
                     "       qty2  = ",g_idc[l_ac2].qty2,",",
                     "       ima01 = '",g_data[l_ac].sfb05,"',",
                     "       ima02 = '",g_data[l_ac].sfbiicd08,"',",
                     "       sfbiicd08_b = '",g_idc[l_ac2].sfbiicd08_b,"' ",
                     " WHERE item1 = ",p_ac,
                     "   AND item2 = ",g_idc[l_ac2].item
         PREPARE p406_upd_1 FROM l_sql
         EXECUTE p406_upd_1
         IF SQLCA.sqlerrd[3]=0 THEN
            CALL cl_err('upd bin_temp','9050',1)
         END IF
      AFTER ROW
         LET l_ac2 = ARR_CURR()
         LET l_ac_t = l_ac2
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET g_idc[l_ac2].* = g_idc_t.*
            LET INT_FLAG = 0
            EXIT INPUT
         END IF

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION controlp
         CASE
            WHEN INFIELD(ima01)     #料號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_icm02_icd"
               LET g_qryparam.default1 = g_idc[l_ac2].ima01
               LET g_qryparam.arg1 = g_data[p_ac].rvv31
               LET g_qryparam.where = " icm02 <> '",g_data[p_ac].sfb05,"'"
               CALL cl_create_qry() RETURNING g_idc[l_ac2].ima01
               DISPLAY BY NAME g_idc[l_ac2].ima01
               NEXT FIELD ima01

            WHEN INFIELD(sfbiicd08_b) #產品型號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_ick01_icd"
               LET g_qryparam.default1 = g_idc[l_ac2].sfbiicd08_b
               LET g_qryparam.arg1 = g_data[p_ac].sfbiicd14
               LET g_qryparam.where = " ick02 <> '",
                                        g_data[p_ac].sfbiicd08,"'"
               CALL cl_create_qry() RETURNING g_idc[l_ac2].sfbiicd08_b
               DISPLAY BY NAME g_idc[l_ac2].sfbiicd08_b
               NEXT FIELD sfbiicd08_b

            OTHERWISE EXIT CASE
         END CASE

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode())
            RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

       ON ACTION select_all
          LET l_cnt=0
          FOR g_i = 1 TO g_rec_b2   #將所有的設為選擇
              LET g_idc[g_i].sel2='Y'          #設定為選擇
         IF g_idc[g_i].sel2 = 'Y' THEN
             CALL i500sub_def_idc(g_idc[g_i].sel2,g_data[p_ac].imaicd04,g_idc[g_i].icf05,
                          g_idc[g_i].ima01,g_data[p_ac].rvv31,g_data[p_ac].sfb05,
                          g_idc[g_i].sfbiicd08_b,g_data[p_ac].sfbiicd14,g_data[p_ac].sfbiicd08)
             RETURNING g_idc[g_i].ima01,
                       g_idc[g_i].sfbiicd08_b
             DISPLAY BY NAME g_idc[g_i].ima01,
                        g_idc[g_i].sfbiicd08_b

             IF cl_null(g_idc[g_i].sfbiicd08_b) THEN
               LET g_idc[g_i].sfbiicd08_b = ' '
             END IF
             LET l_sql = "UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     "   SET sel2 = '",g_idc[g_i].sel2,"',",
                     "       qty1  = ",g_idc[g_i].qty1,",",
                     "       qty2  = ",g_idc[g_i].qty2,",",
                     "       ima01 = '",g_data[p_ac].sfb05,"',",
                     "       ima02 = '",g_data[p_ac].sfbiicd08,"',",
                     "       sfbiicd08_b = '",g_idc[g_i].sfbiicd08_b,"' ",
                     " WHERE item1 = ",p_ac,
                     "   AND item2 = ",g_idc[g_i].item," "
             PREPARE p406_upd_1a FROM l_sql
             EXECUTE p406_upd_1a
             IF SQLCA.sqlerrd[3]=0 THEN
                CALL cl_err('upd bin_temp','9050',1)
             END IF
         END IF

              LET l_cnt=l_cnt+1                   #累加已選筆數
          END FOR

       ON ACTION cancel_all
          FOR g_i = 1 TO g_rec_b2     #將所有的設為選擇
              LET g_idc[g_i].sel2="N"
         #IF g_idc[g_i].sel2 = 'N' THEN
         #    CALL i500sub_qty(g_data[p_ac].sfbiicd09,g_data[p_ac].imaicd04,g_data[p_ac].rvv31,
         #    g_data[p_ac].rvv32,g_data[p_ac].rvv33,g_data[p_ac].rvv34,g_data[p_ac].sfbiicd10,
         #    g_data[p_ac].sfbiicd14)
         #    RETURNING l_qty
         #   IF (cl_null(g_data[p_ac].sfbiicd10) OR
         #       g_data[p_ac].sfbiicd10 = 'N') AND
         #      g_data[p_ac].imaicd04 = '2' AND l_qty = g_data[p_ac].sfb08 THEN
         #      LET g_idc[g_i].sel2 = 'Y'
         #   END IF
         #END IF
        CALL i500sub_def_idc(g_idc[g_i].sel2,g_data[p_ac].imaicd04,g_idc[g_i].icf05,
                          g_idc[g_i].ima01,g_data[p_ac].rvv31,g_data[p_ac].sfb05,
                          g_idc[g_i].sfbiicd08_b,g_data[p_ac].sfbiicd14,g_data[p_ac].sfbiicd08)
             RETURNING g_idc[g_i].ima01,
                       g_idc[g_i].sfbiicd08_b
        DISPLAY BY NAME g_idc[g_i].ima01,
                        g_idc[g_i].sfbiicd08_b
         IF cl_null(g_idc[g_i].sfbiicd08_b) THEN
            LET g_idc[g_i].sfbiicd08_b = ' '
         END IF
         LET l_sql = "UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     "   SET sel2 = '",g_idc[g_i].sel2,"',",
                     "       qty1  = ",g_idc[g_i].qty1,",",
                     "       qty2  = ",g_idc[g_i].qty2,",",
                     "       ima01 = '",g_data[p_ac].sfb05,"',",
                     "       ima02 = '",g_data[p_ac].sfbiicd08,"',",
                     "       sfbiicd08_b = '",g_idc[g_i].sfbiicd08_b,"' ",
                     " WHERE item1 = ",p_ac,
                     "   AND item2 = ",g_idc[g_i].item," "
         PREPARE p406_upd_1b FROM l_sql
         EXECUTE p406_upd_1b
         IF SQLCA.sqlerrd[3]=0 THEN
            CALL cl_err('upd bin_temp','9050',1)
         END IF


          END FOR
          LET l_cnt = 0

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

   END INPUT

   CALL i500_upd_qty(p_ac) 
   CALL i500_show()        

END FUNCTION               

FUNCTION i500_upd_qty(p_ac)
DEFINE p_ac            LIKE type_file.num5
DEFINE t_ac            LIKE type_file.num5
DEFINE l_img04         LIKE img_file.img04,
       l_img10         LIKE img_file.img10,
       l_t1,l_tmp      LIKE type_file.num5,
       l_idv18     LIKE idv_file.idv18,
       l_idv24     LIKE idv_file.idv24
DEFINE l_ac_t          LIKE type_file.num5,              #未取消的ARRAY CNT
       l_imaicd04      LIKE imaicd_file.imaicd04,
       t_imaicd04      LIKE imaicd_file.imaicd04,
       l_cnt           LIKE type_file.num5,              #檢查重複用
       l_sql           STRING,
       l_ecdicd01      LIKE ecd_file.ecdicd01,
       l_qty           LIKE idc_file.idc08,
       l_qty2          LIKE idc_file.idc08,
       l_count         INTEGER, 
       buf             base.StringBuffer   
DEFINE l_idc_s         RECORD
                         sel2      LIKE type_file.chr1,         #勾選
                         item      LIKE type_file.num10,        #項次
                         idc05     LIKE idc_file.idc05,         #刻號
                         idc06     LIKE idc_file.idc06,         #BIN值
                         icf03     LIKE icf_file.icf03,         #BIN值名稱
                         icf05     LIKE icf_file.icf05,         #BIN值屬性
                         qty1      LIKE idc_file.idc08,         #未備置量
                         qty2      LIKE idc_file.idc08,         #未備置量(die)
                         ima01     LIKE ima_file.ima01,         #料號
                         ima02     LIKE ima_file.ima02,         #品名
                         sfbiicd08_b  LIKE sfbi_file.sfbiicd08  #產品型號
                       END RECORD
DEFINE l_idc           RECORD
                         sel2      LIKE type_file.chr1,         #勾選
                         item      LIKE type_file.num10,        #項次
                         idc05     LIKE idc_file.idc05,         #刻號
                         idc06     LIKE idc_file.idc06,         #BIN值
                         icf03     LIKE icf_file.icf03,         #BIN值名稱
                         icf05     LIKE icf_file.icf05,         #BIN值屬性
                         qty1      LIKE idc_file.idc08,         #未備置量
                         qty2      LIKE idc_file.idc08,         #未備置量(die)
                         ima01     LIKE ima_file.ima01,         #料號
                         ima02     LIKE ima_file.ima02,         #品名
                         sfbiicd08_b  LIKE sfbi_file.sfbiicd08  #產品型號
                       END RECORD

   LET l_qty  = 0
   LET l_qty2 = 0

   LET l_sql = "SELECT SUM(qty1),SUM(qty2) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " WHERE item1 = ",p_ac,
               "   AND sel2 = 'Y' "
   PREPARE r406_bin_temp07 FROM l_sql
   DECLARE bin_sum_cs2 CURSOR FOR r406_bin_temp07
   OPEN bin_sum_cs2
   FETCH bin_sum_cs2 INTO l_qty,l_qty2
   IF cl_null(l_qty) THEN LET l_qty = 0 END IF 
   IF cl_null(l_qty2) THEN LET l_qty2 = 0 END IF 

   #發料料號 
   SELECT imaicd04 INTO l_imaicd04 FROM imaicd_file,idv_file
        WHERE imaicd00=idv13 AND idv01=g_idu.idu01 AND idv02=g_data[p_ac].rvv02
   #生產料號
   SELECT imaicd04 INTO t_imaicd04 FROM imaicd_file,idv_file
        WHERE imaicd00=idv03 AND idv01=g_idu.idu01 AND idv02=g_data[p_ac].rvv02

      IF l_imaicd04 = '1' THEN
         CASE 
            WHEN t_imaicd04 = '2'
               UPDATE idv_file 
                  SET idv18 = l_qty,idv20 = 0, #NULL,
                      idv26 = l_qty,idv28 = l_qty2
                WHERE idv01 = g_idu.idu01 AND idv02 = g_data[p_ac].rvv02
            WHEN t_imaicd04 = '3'
               UPDATE idv_file 
                  SET idv18 = l_qty, idv20 = 0, #NULL,
                      idv26 = l_qty2,idv28 = 0 #NULL
                WHERE idv01 = g_idu.idu01 AND idv02 = g_data[p_ac].rvv02
            WHEN t_imaicd04 = '4'
               UPDATE idv_file 
                  SET idv18 = l_qty, idv20 = 0, #NULL,
                      idv26 = l_qty2,idv28 = 0 #NULL
                WHERE idv01 = g_idu.idu01 AND idv02 = g_data[p_ac].rvv02
         END CASE
         IF SQLCA.sqlcode THEN
            IF SQLCA.sqlcode = 0 THEN LET SQLCA.sqlcode = 9050 END IF
            CALL cl_err('UPD idv_file err1:',SQLCA.sqlcode,1)
         END IF
      END IF
      
      IF l_imaicd04 = '2' THEN
         CASE
            WHEN t_imaicd04 = '2'
               UPDATE idv_file
                  SET idv18 = l_qty,idv20 = l_qty2,
                      idv26 = l_qty,idv28 = l_qty2
                WHERE idv01 = g_idu.idu01 AND idv02 = g_data[p_ac].rvv02
            WHEN t_imaicd04 = '3'
               UPDATE idv_file 
                  SET idv18 = l_qty, idv20 = l_qty2,
                      idv26 = l_qty2,idv28 = 0 #NULL
                WHERE idv01 = g_idu.idu01 AND idv02 = g_data[p_ac].rvv02
            WHEN t_imaicd04 = '4'
               UPDATE idv_file 
                  SET idv18 = l_qty, idv20 = l_qty2 ,
                      idv26 = l_qty2,idv28 = 0 #NULL
                WHERE idv01 = g_idu.idu01 AND idv02 = g_data[p_ac].rvv02
         END CASE
         IF SQLCA.sqlcode THEN
            IF SQLCA.sqlcode = 0 THEN LET SQLCA.sqlcode = 9050 END IF
            CALL cl_err('UPD idv_file err2:',SQLCA.sqlcode,1)
         END IF
      END IF
      
      IF l_imaicd04 = '4' THEN
         CASE 
            WHEN t_imaicd04 = '4'
               UPDATE idv_file SET idv18=l_qty,idv20=0, #NULL ,
                      idv26=l_qty,idv28=0 #NULL
                WHERE idv01=g_idu.idu01 AND idv02=g_data[p_ac].rvv02
         END CASE
         IF SQLCA.sqlcode THEN
            IF SQLCA.sqlcode = 0 THEN LET SQLCA.sqlcode = 9050 END IF
            CALL cl_err('UPD idv_file err3:',SQLCA.sqlcode,1)
         END IF
      END IF

   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " WHERE item1 = ",p_ac,
               " ORDER BY item2 "
   PREPARE i500_bin_pre FROM l_sql
   DECLARE i500_bin_cs CURSOR FOR i500_bin_pre
   FOREACH i500_bin_cs INTO t_ac,l_idc_s.*
           UPDATE idw_file
              SET idw13 = l_idc_s.sel2,idw08=l_idc_s.qty1,
                  idw09 = l_idc_s.qty2,idw10=l_idc_s.ima01,
                  idw11 = l_idc_s.ima02,idw12=l_idc_s.sfbiicd08_b
              WHERE idw01 = g_idu.idu01 AND idw02=p_ac
                AND idw03 = l_idc_s.item
   END FOREACH

END FUNCTION

FUNCTION i500_upd_bin(p_ac)
   DEFINE p_ac        LIKE type_file.num10
   DEFINE l_cnt       LIKE type_file.num10
   DEFINE l_sql       STRING
   DEFINE l_idw08  LIKE idw_file.idw08
   DEFINE l_idw09  LIKE idw_file.idw09

   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " WHERE item1 = ",p_ac,
               " ORDER BY item2 "
   PREPARE i500_upd_bin_p FROM l_sql
   DECLARE i500_upd_bin_c CURSOR FOR i500_upd_bin_p

   CALL g_idc.clear()
   LET l_cnt = 1
   LET g_rec_b2 = 0
   
   FOREACH i500_upd_bin_c INTO p_ac,g_idc[l_cnt].*

      SELECT (idc08-idc21),idc12 *((idc08-idc21)/idc08)
        INTO g_idc[l_cnt].qty1,g_idc[l_cnt].qty2
        FROM idc_file
       WHERE idc01 = g_data[p_ac].rvv31
         AND idc02 = g_data[p_ac].rvv32
         AND idc03 = g_data[p_ac].rvv33
         AND idc04 = g_data[p_ac].rvv34
         AND idc05 = g_idc[l_cnt].idc05
         AND idc06 = g_idc[l_cnt].idc06

      LET l_idw08 = 0
      LET l_idw09 = 0
      SELECT SUM(idw08),SUM(idw09) INTO l_idw08,l_idw09
        FROM idu_file,idv_file,idw_file
       WHERE idu01 = idv01
         AND idv01 = idw01
         AND idv02 = idw02
         AND NOT (idw01 = g_idu.idu01 AND idw02 = p_ac)
         AND idv13= g_data[p_ac].rvv31      #發料料號
         AND idv14= g_data[p_ac].rvv32      #倉
         AND idv15= g_data[p_ac].rvv33      #儲
         AND idv16= g_data[p_ac].rvv34      #批
         AND idw04 = g_idc[l_cnt].idc05
         AND idw05 = g_idc[l_cnt].idc06
         AND idw13 = 'Y'
         AND iduconf  = 'N'     #未確認
      IF cl_null(l_idw08) THEN LET l_idw08 = 0 END IF
      IF cl_null(l_idw09) THEN LET l_idw09 = 0 END IF
      LET g_idc[l_cnt].qty1 = g_idc[l_cnt].qty1 - l_idw08
      LET g_idc[l_cnt].qty2 = g_idc[l_cnt].qty2 - l_idw09

      IF g_idc[l_cnt].qty1 <= 0 THEN CONTINUE FOREACH END IF

      LET l_sql = "UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED,
                  "   SET qty1  =  ",g_idc[l_cnt].qty1,",",
                  "       qty2  =  ",g_idc[l_cnt].qty2,
                  " WHERE item1 = ",p_ac,
                  "   AND item2 = ",g_idc[l_cnt].item," "
      PREPARE p406_upd_2b FROM l_sql
      EXECUTE p406_upd_2b     
      IF SQLCA.sqlcode THEN 
         CALL cl_err('update bin_qty:',SQLCA.sqlcode,1)
         EXIT FOREACH 
      END IF 
      LET l_cnt = l_cnt + 1

      IF l_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_idc.deleteElement(l_cnt)
   LET g_rec_b2 = l_cnt - 1
   LET l_cnt = 0
END FUNCTION 

#生產料號
FUNCTION i500_ima01(p_ac)
  DEFINE p_ac            LIKE type_file.num5
  DEFINE l_icmacti       LIKE icm_file.icmacti,
         l_bmaacti       LIKE bma_file.bmaacti,
         l_bma05         LIKE bma_file.bma05
  DEFINE i,l_n           LIKE type_file.num5
  DEFINE l_sql           STRING    

  SELECT icmacti INTO l_icmacti FROM icm_file
   WHERE icm01 = g_data[p_ac].rvv31
     AND icm02 = g_idc[l_ac2].ima01

  CASE WHEN SQLCA.SQLCODE = 100    LET g_errno = '100'
       WHEN l_icmacti <> 'Y'       LET g_errno = '9028'
       OTHERWISE                   LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF NOT cl_null(g_errno) THEN RETURN END IF

  #不可與生產料號相同吆
  IF g_data[p_ac].sfb05 = g_idc[l_ac2].ima01 THEN
     LET g_errno = 'aic-134'
  END IF
  IF NOT cl_null(g_errno) THEN RETURN END IF

  #要存在bom吆
  SELECT bma05,bmaacti INTO l_bma05,l_bmaacti FROM bma_file
   WHERE bma01 = g_idc[l_ac2].ima01
  CASE WHEN SQLCA.SQLCODE = 100    LET g_errno = 'abm-742'
       WHEN l_bmaacti <> 'Y'       LET g_errno = '9028'
       WHEN l_bma05 IS NULL OR l_bma05 > g_idu.idu20
                                   LET g_errno = 'abm-005'
       OTHERWISE                   LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) THEN
     SELECT ima02 INTO g_idc[l_ac2].ima02 FROM ima_file
      WHERE ima01 = g_idc[l_ac2].ima01
  END IF

  IF NOT cl_null(g_errno) THEN RETURN END IF

  IF g_idc[l_ac2].ima01 != g_idc_t.ima01 OR
     cl_null(g_idc_t.ima01) THEN

     #判斷是此生產料號是否與其他down grade項次的生產料號不同
     LET l_n = 0
     LET l_sql = "SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " WHERE item1 = ",p_ac,
               "   AND item2 != '",g_idc[l_ac2].item,"'",
               "   AND sel2 = 'Y' ",
               "   AND (ima01 != '",g_idc[l_ac2].ima01,"' OR ima01 is null)"
     PREPARE r406_bin_temp09 FROM l_sql
     DECLARE bin_count_cs9 CURSOR FOR r406_bin_temp09
     OPEN bin_count_cs9
     FETCH bin_count_cs9 INTO l_n
     IF l_n > 0 THEN
        #是否將此生產料號更新至其他down grade項次的生產料號?(Y/N)
        IF cl_confirm('aic-135')THEN
           FOR i = 1 TO g_rec_b2
               IF g_idc[i].sel2 != 'Y' THEN
                  CONTINUE FOR
               END IF
               IF g_idc[i].ima01 != g_idc[l_ac2].ima01 THEN
                  LET g_idc[i].ima01 = g_idc[l_ac2].ima01
                  DISPLAY BY NAME g_idc[i].ima01
               END IF
           END FOR
           #更新
           LET l_sql = "UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED,
                       "   SET ima01 = '",g_idc[l_ac2].ima01,"' ",
                       " WHERE item1 = ",p_ac,
                       "   AND sel2 = 'Y' "
           PREPARE p406_upd_2 FROM l_sql
           EXECUTE p406_upd_2
           IF SQLCA.SQLCODE THEN
              LET g_errno = SQLCA.SQLCODE
           END IF
        END IF
     END IF
  END IF
END FUNCTION

#檢查單價,除6.TKY外,其它單價不可為0
FUNCTION i500_chk_price()
    DEFINE l_flag      LIKE type_file.num5,
           l_ecdicd01 LIKE ecd_file.ecdicd01,
           l_pmn31     LIKE pmn_file.pmn31,
           l_pmn31t    LIKE pmn_file.pmn31t,
           l_pmm21     LIKE pmm_file.pmm21,
           l_pmm22     LIKE pmm_file.pmm22,
           l_pmm43     LIKE pmm_file.pmm43,
           l_ecb06     LIKE ecb_file.ecb06,
           l_imaicd01  LIKE imaicd_file.imaicd01,
           l_ima908    LIKE ima_file.ima908,
           l_pmn86     LIKE pmn_file.pmn86,
           l_ima44     LIKE ima_file.ima44,  
           l_ima31     LIKE ima_file.ima31,  
           l_price_unit  LIKE ima_file.ima908   
   DEFINE l_pmc17      LIKE pmc_file.pmc17   
   DEFINE l_pmc49      LIKE pmc_file.pmc49  
   DEFINE l_pmn73      LIKE pmn_file.pmn73  
   DEFINE l_pmn74      LIKE pmn_file.pmn74  

    LET l_flag = 1

    CALL i500sub_ecdicd01(g_data[l_ac].sfbiicd09) RETURNING l_ecdicd01 
    IF NOT cl_null(g_pmm22) THEN
       LET l_pmm22 = g_pmm22
    ELSE
       SELECT pmc22 INTO l_pmm22 FROM pmc_file
        WHERE pmc01 = g_data[l_ac].sfb82
    END IF
    SELECT pmc47,pmc17,pmc49 INTO l_pmm21,l_pmc17,l_pmc49 FROM pmc_file   
     WHERE pmc01 = g_data[l_ac].sfb82

    SELECT gec04 INTO l_pmm43 FROM gec_file
     WHERE gec01= l_pmm21 AND gec011='1'

    IF SQLCA.SQLCODE THEN
       LET l_pmm43 = 0
    ELSE
       IF cl_null(l_pmm43) THEN LET l_pmm43 = 0 END IF
    END IF

    SELECT rvv86 INTO l_pmn86
      FROM rvv_file
     WHERE rvv01=g_data[l_ac].rvv01
       AND rvv02=g_data[l_ac].rvv02

    CASE WHEN l_ecdicd01 = '2' OR l_ecdicd01 = '3'
              #1 若料號之作業群組 = '2.CP' or '3.DS' ,
              #  則採購單價以母體料號取價,
              IF g_sma.sma841 = '8' THEN #依Body取價  
                 SELECT imaicd01 INTO l_imaicd01 FROM imaicd_file
                  WHERE imaicd00 = g_data[l_ac].sfb05
              ELSE                                   
                 LET l_imaicd01 = g_data[l_ac].sfb05  
              END IF                                

              SELECT ima908,ima44,ima31 INTO l_ima908,l_ima44,l_ima31 
                                        FROM ima_file
                                       WHERE ima01=l_imaicd01
              CASE g_sma.sma116
                 WHEN "0"
                    LET l_price_unit =  l_ima44
                 WHEN "1"
                    LET l_price_unit =  l_ima44
                 WHEN "2"
                    LET l_price_unit =  l_ima31
                 WHEN "3"
                    LET l_price_unit =  l_ima908
              END CASE

         WHEN l_ecdicd01 = '4' OR l_ecdicd01 = '5'
              #2 若料號之作業群組 = '4.ASS' or '5.FT' ,
              CALL s_defprice_new(g_data[l_ac].sfbiicd08,g_data[l_ac].sfb82,
                              l_pmm22,g_idu.idu20,g_data[l_ac].sfb08,
                              g_data[l_ac].sfbiicd09,l_pmm21,
                              l_pmm43,'2',l_pmn86,'',l_pmc49,l_pmc17,g_plant)  
                  RETURNING l_pmn31,l_pmn31t,l_pmn73,l_pmn74  
              IF NOT cl_null(l_pmn31) AND NOT cl_null(l_pmn31t) AND
                 l_pmn31 > 0 AND l_pmn31t > 0 THEN
                 LET l_flag = 1
              ELSE
                 LET l_flag = 0
              END IF
         WHEN l_ecdicd01 = '6'
              LET l_flag = 1
              DECLARE ecb_dec CURSOR FOR
               SELECT ecb06 FROM ecb_file
                WHERE ecb01 = g_data[l_ac].sfb05 
                  AND ecb02 = g_data[l_ac].sfb06
              FOREACH ecb_dec INTO l_ecb06
              CALL s_defprice_new(g_data[l_ac].sfbiicd08,g_data[l_ac].sfb82,
                              l_pmm22,g_idu.idu20,g_data[l_ac].sfb08,l_ecb06,l_pmm21,
                              l_pmm43,'2',l_pmn86,'',l_pmc49,l_pmc17,g_plant)   
                  RETURNING l_pmn31,l_pmn31t,l_pmn73,l_pmn74  
                IF cl_null(l_pmn31) OR cl_null(l_pmn31t) OR
                   l_pmn31 <= 0 OR l_pmn31t <= 0 THEN
                   LET l_flag = 0 EXIT FOREACH
                END IF
              END FOREACH
         OTHERWISE
              LET l_flag = 1
    END CASE
    LET l_pmn31  = 0
    LET l_pmn31t = 0
    IF l_flag = 0 THEN
       IF l_ecdicd01 = '6' THEN
          CALL cl_err('','aic-140',1)
       ELSE
          CALL cl_err('','aic-139',1)  #委外要到apmi264維護,非委外-apmi254
       END IF
    END IF
    RETURN l_flag
END FUNCTION

FUNCTION i500_y()
    DEFINE ans          LIKE type_file.num5,       
           l_ct2        LIKE type_file.num5,
           l_err        LIKE type_file.chr1,
           l_idv02      LIKE idv_file.idv02,
           l_idv03      LIKE idv_file.idv03,
           l_idv26  LIKE idv_file.idv26,
           l_idv18  LIKE idv_file.idv18,
           t_imaicd04   LIKE imaicd_file.imaicd04,
           l_cnt,l_cnt2 LIKE type_file.num5,
           l_idv03_1    LIKE idv_file.idv03         
    DEFINE l_sfq01      LIKE sfq_file.sfq01,
           l_sql        STRING,
           l_qty1       LIKE idv_file.idv18,  
           l_qty2       LIKE idv_file.idv18,  
           l_sfq02      LIKE sfq_file.sfq02
    DEFINE l_ecdicd01   LIKE ecd_file.ecdicd01
    DEFINE l_str        STRING                    
    DEFINE l_idv12  LIKE idv_file.idv12    
    DEFINE l_imaicd04   LIKE imaicd_file.imaicd04 
    DEFINE l_idv20  LIKE idv_file.idv20
    DEFINE l_idv28  LIKE idv_file.idv20
    DEFINE l_chk        LIKE type_file.chr1

    IF s_shut(0) THEN RETURN END IF
    IF g_idu.idu01 IS NULL THEN RETURN END IF
    SELECT * INTO g_idu.* FROM idu_file WHERE idu01 = g_idu.idu01
    #SELECT idu01 INTO g_idu.idu01 FROM idu_file WHERE idu01 = g_idu.idu01

    IF g_idu.iduconf='Y' THEN RETURN END IF
    IF g_idu.iduconf = 'X'   THEN CALL cl_err('','9024',0) RETURN END IF

    SELECT COUNT(*) INTO l_cnt FROM idv_file,idu_file,bma_file
        WHERE idv03=bma01 AND idu01=idv01 AND idu01=g_idu.idu01
          AND (bma05 IS NULL OR bma05 > g_idu.idu19)
    IF l_cnt > 0 THEN
       SELECT MIN(idv03) INTO l_idv03 FROM idv_file,idu_file,bma_file
        WHERE idv03=bma01 AND idu01=idv01 AND idu01=g_idu.idu01
          AND (bma05 IS NULL OR bma05 > g_idu.idu19)
       CALL cl_err(l_idv03,'amr-001',1)
       RETURN
    END IF
    SELECT COUNT(*) INTO l_cnt FROM idv_file WHERE idv01 = g_idu.idu01
    IF l_cnt = 0 THEN
       CALL cl_err('','mfg-009',0)
       RETURN
    ELSE
       SELECT COUNT(*) INTO l_ct2 FROM idv_file
           WHERE idv01=g_idu.idu01 AND idv21 = g_idu.idu13
       IF l_cnt <> l_ct2 THEN
          CALL cl_err(g_idu.idu13,'aic-335',1)
          RETURN
       END IF
    END IF
    SELECT ecdicd01 INTO l_ecdicd01 FROM ecd_file WHERE ecd01=g_idu.idu13
    CASE WHEN l_ecdicd01 = '2'   #CP檢查勾選刻號數=領用數量
              LET l_err = 'N'
              LET l_ct2 = 0
              DECLARE idv_cur01 CURSOR FOR
                 SELECT idv02,idv18 
                 FROM idv_file WHERE idv01=g_idu.idu01 ORDER BY idv02
              FOREACH idv_cur01 INTO l_idv02,l_idv18
                 LET l_ct2 = l_ct2 + 1
                 LET l_sql = "SELECT SUM(qty1),SUM(qty2) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                             " WHERE item1 = ",l_ct2,
                             "   AND sel2 = 'Y' "
                 PREPARE bin_p1  FROM l_sql
                 DECLARE bin_c01 CURSOR FOR bin_p1
                 OPEN bin_c01
                 FETCH bin_c01 INTO l_qty1,l_qty2
                 IF cl_null(l_qty1) THEN LET l_qty1 = 0 END IF
                 IF cl_null(l_qty2) THEN LET l_qty2 = 0 END IF
              END FOREACH
              IF l_err = 'Y'  THEN RETURN END IF
         WHEN l_ecdicd01 = '4'   #AS
    END CASE

    LET l_idv18 = 0   LET l_idv20 = 0
    LET l_idv26 = 0   LET l_idv28 = 0
    LET l_err = 'N'
    CALL s_showmsg_init()

    #領用料號有刻號BIN管理時,檢查數量
    DECLARE idv_cur02 CURSOR FOR
        SELECT idv02,idv26,idv18,idv20,idv28  
          FROM idv_file,imaicd_file
         WHERE imaicd00=idv13 AND imaicd08='Y' AND idv01=g_idu.idu01 ORDER BY idv02
    FOREACH idv_cur02 INTO l_idv02,l_idv26,l_idv18,l_idv20,l_idv28  
                 LET l_sql = "SELECT SUM(qty1),SUM(qty2) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                             " WHERE item1 = ",l_idv02,
                             "   AND sel2 = 'Y' "
                 PREPARE bin_p2  FROM l_sql
                 DECLARE bin_c02 CURSOR FOR bin_p2
                 OPEN bin_c02
                 FETCH bin_c02 INTO l_qty1,l_qty2
                 IF cl_null(l_qty1) THEN LET l_qty1 = 0 END IF
                 IF cl_null(l_qty2) THEN LET l_qty2 = 0 END IF

                 LET t_imaicd04 = NULL  
                 SELECT imaicd04 INTO t_imaicd04 FROM imaicd_file,idv_file
                     WHERE imaicd00=idv03 AND idv01=g_idu.idu01 AND idv02=l_idv02

                 #發料料號 
                 LET l_imaicd04 = NULL
                 SELECT imaicd04 INTO l_imaicd04 FROM imaicd_file,idv_file
                  WHERE imaicd00 = idv13 AND idv01 = g_idu.idu01 AND idv02 = l_idv02

                 LET l_chk = 'Y'
                 IF l_imaicd04 = '1' THEN
                    CASE 
                       WHEN t_imaicd04 = '2'
                          IF l_idv18 != l_qty1 OR l_idv26 != l_qty1 OR
                             l_idv28 != l_qty2 THEN
                             LET l_chk = 'N'
                          END IF
                       WHEN t_imaicd04 = '3'
                          IF l_idv18 != l_qty1 OR l_idv26 != l_qty2 THEN
                             LET l_chk = 'N'
                          END IF
                       WHEN t_imaicd04 = '4'
                          IF l_idv18 != l_qty1 OR l_idv26 != l_qty2 THEN
                             LET l_chk = 'N'
                          END IF
                       OTHERWISE EXIT CASE
                    END CASE
                 END IF
                 
                 IF l_imaicd04 = '2' THEN
                    CASE
                       WHEN t_imaicd04 = '2'
                          IF l_idv18 != l_qty1 OR l_idv20 != l_qty2 OR
                             l_idv26 != l_qty1 OR l_idv28 != l_qty2 THEN
                             LET l_chk = 'N'
                          END IF
                       WHEN t_imaicd04 = '3'
                          IF l_idv18 != l_qty1 OR l_idv20 != l_qty2 OR
                             l_idv26 != l_qty2 THEN
                             LET l_chk = 'N'
                          END IF
                       WHEN t_imaicd04 = '4'
                          IF l_idv18 != l_qty1 OR l_idv20 != l_qty2 OR
                             l_idv26 != l_qty2 THEN
                             LET l_chk = 'N'
                          END IF
                       OTHERWISE EXIT CASE
                    END CASE
                 END IF
                 
                 IF l_imaicd04 = '4' THEN
                    CASE 
                       WHEN t_imaicd04 = '4'
                          IF l_idv18 != l_qty1 OR l_idv26 != l_qty1 THEN
                             LET l_chk = 'N'
                          END IF
                       OTHERWISE EXIT CASE
                    END CASE
                 END IF

                 IF l_chk = 'N' THEN
                    # TSD0022=單身一和單身二數量不符合！
                    CALL s_errmsg('idv02',l_idv02,'','TSD0022',1)
                    LET l_err = 'Y'
                 END IF
    END FOREACH
    CALL s_showmsg()    
    IF l_err = 'Y'  THEN RETURN END IF

    # 判斷是否存在核價資料
    DECLARE idv_cur03 CURSOR FOR
     SELECT idv02,idv12,idv03 FROM idv_file WHERE idv01 = g_idu.idu01 ORDER BY idv02
    FOREACH idv_cur03 INTO l_idv02,l_idv12,l_idv03_1
       IF l_idv12 = '1' THEN
          LET l_cnt = 0
          SELECT COUNT(*) INTO l_cnt FROM idu_file,idv_file,pmi_file,pmj_file
           WHERE idu01 = idv01 AND pmi01 = pmj01
             AND idv01 = g_idu.idu01
             AND idv02 = l_idv02     
             AND idu11 = pmi03
             AND idv03 = pmj03      
             AND pmiconf = 'Y'      
          IF l_cnt = 0 THEN
             # 無法抓到單價,請查核..!
             CALL cl_err(l_idv03_1,'axm-333',1)
             LET l_err = 'Y'
             EXIT FOREACH
          END IF
       END IF
    END FOREACH
    IF l_err = 'Y'  THEN RETURN END IF

    BEGIN WORK

      OPEN i500_cl USING g_idu.idu01
      IF STATUS THEN
         CALL cl_err("OPEN i500_cl:", STATUS, 1)
         CLOSE i500_cl
         ROLLBACK WORK
         RETURN
      END IF
      FETCH i500_cl INTO g_idu.*               # 對DB鎖定
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_idu.idu01,SQLCA.sqlcode,0)
         CLOSE i500_cl
         ROLLBACK WORK
         RETURN
      END IF

      LET g_success = 'Y'
      UPDATE idu_file SET iduconf = 'Y' WHERE idu01 = g_idu.idu01
      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","idu_file",g_idu01_t,"",STATUS,"","upd iduconf",1)  
         LET g_success = 'N'
         RETURN
      END IF
      IF g_success = 'Y' THEN
        LET g_idu.iduconf='Y'
        CLOSE i500_cl
        COMMIT WORK
        CALL cl_flow_notify(g_idu.idu01,'Y')
        DISPLAY BY NAME g_idu.iduconf
      ELSE
        LET g_idu.iduconf='N'
        CLOSE i500_cl
        ROLLBACK WORK
      END IF

    CALL i500sub_process()  
    IF g_success='N' THEN
       CALL cl_err('','aic-060',0)
    END IF 
    #CALL i500sub_out()   
    SELECT COUNT(*) INTO l_cnt2 FROM idv_file WHERE idv01 = g_idu.idu01

    BEGIN WORK
    SELECT COUNT(*) INTO l_cnt FROM sfb_file
          WHERE sfb91=g_idu.idu01 AND sfb081 > 0
    IF l_cnt = 0 OR (l_cnt <> l_cnt2) THEN
       DELETE FROM pmm_file  WHERE pmm01 = g_idu.idu01
       DELETE FROM pmn_file  WHERE pmn01 = g_idu.idu01
       DELETE FROM pmni_file WHERE pmni01 = g_idu.idu01
       DECLARE sfq_cur CURSOR FOR
          SELECT sfb01 FROM sfb_file
          WHERE sfb91=g_idu.idu01 AND sfb87='Y'
       FOREACH sfq_cur INTO l_sfq02
           CALL i500_icd_undo_confirm(l_sfq02)
       END FOREACH
       LET g_idu.iduconf = 'N' 
       UPDATE idu_file SET iduconf = 'N' WHERE idu01 = g_idu.idu01
       DISPLAY BY NAME g_idu.iduconf
    END IF
    COMMIT WORK

END FUNCTION

FUNCTION i500_z()
    DEFINE ans     LIKE type_file.num5          
    DEFINE l_sfb01 LIKE sfb_file.sfb01

    IF s_shut(0) THEN RETURN END IF
    SELECT * INTO g_idu.* FROM idu_file WHERE idu01 = g_idu.idu01
    IF g_idu.iduconf='N' THEN RETURN END IF
    IF g_idu.iduconf = 'X'   THEN CALL cl_err('','9024',0) RETURN END IF

   IF g_sma.sma53 IS NOT NULL AND g_idu.idu19 <= g_sma.sma53 THEN
      CALL cl_err('','mfg9999',1) RETURN
   END IF
   #存在非已作廢的委外收貨單資料則不可取消確認
   LET g_cnt=0
   SELECT COUNT(*) INTO g_cnt
                   FROM rva_file,rvb_file,sfb_file
                  WHERE rvb01=rva01
                    AND rvb34=sfb01 AND sfb91 = g_idu.idu01
                    AND rvaconf <>'X'
   IF g_cnt>0 THEN
       CALL cl_err('','aic-216',1)
       RETURN
   END IF

    IF NOT cl_confirm('axm-109') THEN RETURN END IF

    LET g_success = 'Y'
    BEGIN WORK

       DELETE FROM pmm_file  WHERE pmm01 = g_idu.idu01
       DELETE FROM pmn_file  WHERE pmn01 = g_idu.idu01
       DELETE FROM pmni_file WHERE pmni01 = g_idu.idu01

       DECLARE sfb_curz CURSOR FOR
          SELECT sfb01 FROM sfb_file
             WHERE sfb91=g_idu.idu01 AND sfb87='Y'
       FOREACH sfb_curz INTO l_sfb01
           CALL i500_icd_undo_confirm(l_sfb01)
       END FOREACH

    OPEN i500_cl USING g_idu.idu01
    IF STATUS THEN
       CALL cl_err("OPEN i500_cl:", STATUS, 1)
       CLOSE i500_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i500_cl INTO g_idu.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_idu.idu01,SQLCA.sqlcode,0)
       CLOSE i500_cl
       ROLLBACK WORK
       RETURN
    END IF

      IF g_success = 'Y' THEN
         LET g_idu.iduconf='N'
         UPDATE idu_file SET iduconf = 'N' WHERE idu01 = g_idu.idu01
         CLOSE i500_cl
         COMMIT WORK
         DISPLAY BY NAME g_idu.iduconf
      ELSE
         LET g_idu.iduconf='Y'
         CLOSE i500_cl
         ROLLBACK WORK
      END IF
END FUNCTION

FUNCTION i500_b_tot()
   SELECT SUM(idv18) INTO g_idv18 FROM idv_file WHERE idv01 = g_idu.idu01
   IF g_idv18 IS NULL THEN LET g_idv18  = 0 END IF
   DISPLAY g_idv18 TO idv18
END FUNCTION

FUNCTION i500_save()
DEFINE   l_idw    RECORD LIKE idw_file.*,
         l_sql       STRING,
         l_tmp       RECORD
                     item1  LIKE type_file.num5, 
                     sel2   LIKE type_file.chr1, 
                     item2  LIKE type_file.num10, 
                     idc05  LIKE idc_file.idc05, 
                     idc06  LIKE idc_file.idc06, 
                     icf03  LIKE icf_file.icf03, 
                     icf05  LIKE icf_file.icf05, 
                     qty1   LIKE idc_file.idc08, 
                     qty2   LIKE idc_file.idc08, 
                     ima01  LIKE ima_file.ima01,
                     ima02  LIKE ima_file.ima02, 
                     sfbiicd08_b  LIKE sfbi_file.sfbiicd08 
                     END RECORD

   DELETE FROM idw_file WHERE idw01 = g_idu.idu01

   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " ORDER BY item1,item2 "
   PREPARE i500_save_pre   FROM l_sql
   DECLARE i500_save_cs CURSOR FOR i500_save_pre    
   FOREACH  i500_save_cs INTO l_tmp.*
     INITIALIZE l_idw.* TO NULL 
     LET l_idw.idw13 = l_tmp.sel2
     LET l_idw.idw01 = g_idu.idu01
     LET l_idw.idw02 = l_tmp.item1
     LET l_idw.idw03 = l_tmp.item2
     LET l_idw.idw04 = l_tmp.idc05
     LET l_idw.idw05 = l_tmp.idc06
     LET l_idw.idw06 = l_tmp.icf03
     LET l_idw.idw07 = l_tmp.icf05
     LET l_idw.idw08 = l_tmp.qty1
     LET l_idw.idw09 = l_tmp.qty2 
     LET l_idw.idw10 = l_tmp.ima01
     LET l_idw.idw11 = l_tmp.ima02
     LET l_idw.idw12 = l_tmp.sfbiicd08_b
     LET l_idw.idwlegal = g_legal
     LET l_idw.idwplant = g_plant
     INSERT INTO idw_file VALUES(l_idw.*)
   END FOREACH

END FUNCTION

#FUNCTION i500_x() #CHI-D20010
FUNCTION i500_x(p_type)  #CHI-D20010
DEFINE l_flag LIKE type_file.chr1  #CHI-D20010
DEFINE p_type LIKE type_file.chr1  #CHI-D20010

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_idu.idu01) THEN CALL cl_err('',-400,0) RETURN END IF   

   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_idu.iduconf ='X' THEN RETURN END IF
   ELSE
      IF g_idu.iduconf <>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end
 
   BEGIN WORK
   LET g_success='Y'

   OPEN i500_cl USING g_idu.idu01
   IF STATUS THEN
      CALL cl_err("OPEN i500_cl:", STATUS, 1)
      CLOSE i500_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i500_cl INTO g_idu.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_idu.idu01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE i500_cl
      ROLLBACK WORK
      RETURN
   END IF
   IF cl_null(g_idu.idu01) THEN CALL cl_err('',-400,0) RETURN END IF
   #-->確認不可作廢
   IF g_idu.iduconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_idu.iduconf = 'X' THEN  LET l_flag = 'X' ELSE LET l_flag = 'N' END IF #CHI-D20010
#  IF cl_void(0,0,g_idu.iduconf) THEN  #CHI-D20010
   IF cl_void(0,0,l_flag) THEN     #CHI-D20010
        LET g_chr=g_idu.iduconf
#       IF g_idu.iduconf ='N' THEN   #CHI-D20010
        IF p_type = 1 THEN           #CHI-D20010
            LET g_idu.iduconf='X'
        ELSE
            LET g_idu.iduconf='N'
        END IF
        UPDATE idu_file
            SET iduconf=g_idu.iduconf,
                idumodu=g_user,
                idudate=g_today
            WHERE idu01  =g_idu.idu01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","idu_file","","",SQLCA.sqlcode,"","",1) 
            LET g_idu.iduconf=g_chr
        END IF
        DISPLAY BY NAME g_idu.iduconf
   END IF
                CASE g_idu.iduconf
                     WHEN 'Y'   LET g_confirm = 'Y'
                                LET g_void = ''
                     WHEN 'N'   LET g_confirm = 'N'
                                LET g_void = ''
                     WHEN 'X'   LET g_confirm = ''
                                LET g_void = 'Y'
                  OTHERWISE     LET g_confirm = ''
                                LET g_void = ''
                END CASE
                #圖形顯示
                CALL cl_set_field_pic(g_confirm,"","","",g_void,'')

   CLOSE i500_cl
   COMMIT WORK
   CALL cl_flow_notify(g_idu.idu01,'V')
END FUNCTION

FUNCTION i500_icd_undo_confirm(p_sfb01)
   DEFINE p_sfb01 LIKE sfb_file.sfb01
   DEFINE l_pmn01 LIKE pmn_file.pmn01
   DEFINE l_sfp01 LIKE sfp_file.sfp01
   DEFINE l_sfp06 LIKE sfp_file.sfp06
   DEFINE l_o_prog STRING

   LET g_success='Y'
   LET g_success='Y'
   SELECT sfb01 INTO g_sfb01 FROM sfb_file WHERE sfb01 = p_sfb01

   #將相關已存在已過帳發料單,取消過帳
   DECLARE i500_icd_upd_sfp1 CURSOR FOR
    SELECT DISTINCT sfp01,sfp06 FROM sfp_file,sfe_file
     WHERE sfp01=sfe02
       AND sfp04='Y'
       AND sfe01=p_sfb01
   FOREACH i500_icd_upd_sfp1 INTO l_sfp01,l_sfp06
      IF cl_null(l_sfp01) THEN
         CONTINUE FOREACH
      END IF

      LET l_o_prog = g_prog
      CASE l_sfp06
         WHEN "1" LET g_prog='asfi511'
         WHEN "2" LET g_prog='asfi512'
         WHEN "3" LET g_prog='asfi513'
         WHEN "4" LET g_prog='asfi514'
         WHEN "6" LET g_prog='asfi526'
         WHEN "7" LET g_prog='asfi527'
         WHEN "8" LET g_prog='asfi528'
         WHEN "9" LET g_prog='asfi529'
      END CASE

      IF g_success = "Y" THEN
         CALL i501sub_z('1',l_sfp01,NULL,FALSE)
      END IF
      LET g_prog = l_o_prog

   END FOREACH
   IF g_success='N' THEN
      RETURN
   END IF

   LET g_success='Y'
   #將相關已存在已確認發料單,取消確認
   DECLARE i500_icd_upd_sfp2 CURSOR FOR
    SELECT DISTINCT sfp01,sfp06 FROM sfp_file,sfs_file
     WHERE sfp01=sfs01
       AND sfpconf='Y'
       AND sfs03=p_sfb01
   FOREACH i500_icd_upd_sfp2 INTO l_sfp01,l_sfp06
      IF cl_null(l_sfp01) THEN
         CONTINUE FOREACH
      END IF
      CALL i501sub_w(l_sfp01,NULL,FALSE)
   END FOREACH

   IF g_success='N' THEN
      RETURN
   END IF

   LET g_success='Y'
   #將相關已存在未確認發料單,作廢
   DECLARE i500_icd_upd_sfp3 CURSOR FOR
    SELECT DISTINCT sfp01,sfp06 FROM sfp_file,sfs_file
     WHERE sfp01=sfs01
       AND sfpconf='N'
       AND sfs03=p_sfb01
   FOREACH i500_icd_upd_sfp3 INTO l_sfp01,l_sfp06
      IF cl_null(l_sfp01) THEN
         CONTINUE FOREACH
      END IF
      CALL i501sub_x(l_sfp01,NULL,FALSE,1)  #CHI-D20010 add-1
   END FOREACH

   IF g_sfb.sfb04='2' OR   #已發放未列印
      g_sfb.sfb04='3' THEN #已發放已列印
      UPDATE sfb_file SET sfb04='1',sfb87='X',sfb43='0' WHERE sfb01=g_sfb01  
   ELSE
      UPDATE sfb_file SET sfb04='1',sfb87 = 'X',sfb43='0' WHERE sfb01=g_sfb01   
   END IF

   IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   END IF

END FUNCTION

FUNCTION i500_bp2()
   DEFINE   p_ud   LIKE type_file.chr1    

   CALL cl_set_act_visible("cancel", FALSE)
   DISPLAY ARRAY g_idc TO s_idc.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION help         
         CALL cl_show_help()  

      ON ACTION controlg     
         CALL cl_cmdask()    

        ON ACTION CONTROLS

           CALL cl_set_head_visible("","AUTO")
   END DISPLAY
   CALL cl_set_act_visible("cancel", FALSE)

END fUNCTION

FUNCTION i500_g_b()
   DEFINE p_row,p_col  LIKE type_file.num5
   OPEN WINDOW i500_p AT p_row,p_col WITH FORM "aic/42f/aici500_p"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("aici500_p")

   CALL i500_p_b_fill()
   IF g_rec_b3 > 0 THEN
      CALL i500_p_b()
      CALL i500_b_fill('1=1')

      FOR g_i = 1 TO g_rec_b
         CALL i500_ins_bin_temp(g_i)
         CALL i500_upd_qty(g_i)
      END FOR
      CALL i500_b_fill('1=1')

   END IF

   CLOSE WINDOW i500_p

    DISPLAY g_rec_b TO FORMONLY.cn3
    LET g_cnt = 0

END FUNCTION

FUNCTION i500_p_b_fill()
DEFINE l_ogb12    LIKE ogb_file.ogb12,
       l_ogb31    LIKE ogb_file.ogb31,
       l_sumohb12 LIKE ohb_file.ohb12
DEFINE l_wc       STRING
DEFINE l_ecdicd01 LIKE ecd_file.ecdicd01    
DEFINE l_imaicd04 LIKE imaicd_file.imaicd04 
DEFINE l_ecb06    LIKE ecb_file.ecb06    
DEFINE l_case     LIKE ecd_file.ecdicd01 
DEFINE l_sql      STRING
DEFINE l_idv18 LIKE idv_file.idv18    
DEFINE l_idv20 LIKE idv_file.idv20  

    CONSTRUCT BY NAME l_wc ON img01,ima02,img03,img04,img10,img02
    
    
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
      
      ON ACTION locale
         LET g_action_choice = "locale"
           CALL cl_show_fld_cont()              
         EXIT CONSTRUCT
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

      ON ACTION about         
         CALL cl_about()     

      ON ACTION help         
         CALL cl_show_help()  

      ON ACTION controlg     
         CALL cl_cmdask()     

      ON ACTION exit
         LET INT_FLAG = 1
         EXIT CONSTRUCT
      ON ACTION CONTROLP
         IF INFIELD(img01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO img01
            NEXT FIELD img01
         END IF
      ON ACTION qbe_select
         CALL cl_qbe_select()

  END CONSTRUCT
  IF g_action_choice = "locale" THEN
     LET g_action_choice = ""
     CALL cl_dynamic_locale()
  END IF

   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW aici500_p
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      RETURN
   END IF

   LET l_ecdicd01 = ''      
   SELECT ecdicd01 INTO l_ecdicd01 FROM ecd_file
    WHERE ecd01 = g_idu.idu13
      AND ecdacti = 'Y'

   # 若是"6.Turnkey"，須判斷第一個製程是哪一個作業群組，再依照上述CP、AS、DS、FT的規格帶入料號資料
   IF l_ecdicd01 = '6' THEN
      LET l_sql = "SELECT ecb06 FROM ecb_file,ecu_file ",
                  " WHERE ecu01 = ecb01 AND ecu02 = ecb02 ",
                  "   AND ecu10 = 'Y' AND ecu02 = ? ",
                  " ORDER BY ecb03 "
      DECLARE ecb06_cs SCROLL CURSOR FROM l_sql
      OPEN ecb06_cs USING g_idu.idu23
      FETCH FIRST ecb06_cs INTO l_ecb06
      CLOSE ecb06_cs 
      
      # 依取出第一個製程的作業群組，帶出ecdicd01
      SELECT ecdicd01 INTO l_ecdicd01 FROM ecd_file
       WHERE ecd01 = l_ecb06
         AND ecdacti = 'Y'
   END IF
 
   CASE l_ecdicd01
      WHEN '2'
         LET l_imaicd04 = '1'
      WHEN '3'
         LET l_imaicd04 = '2'
      WHEN '4'
         LET l_imaicd04 = '2'
      WHEN '5'
         LET l_imaicd04 = '3'
      OTHERWISE 
         LET l_imaicd04 = ''
   END CASE

   LET g_sql = "SELECT DISTINCT 'N',img01,ima02,img02,img03,img04,img10,0,ima25 ",
               "  FROM img_file,ima_file,imaicd_file ",
               " WHERE img01=ima01 AND img10 > 0 ",
               "   AND ima01=imaicd00",
               "   AND imaicd04 = '",l_imaicd04,"'",
               "   AND ",l_wc CLIPPED,
               " ORDER BY img01,img02,img03,img04 "
   PREPARE i500_p_pb FROM g_sql
   DECLARE i500_p_cs CURSOR WITH HOLD FOR i500_p_pb

    CALL g_img_p.clear()
    LET g_rec_b3= 0
    LET g_cnt_p = 1
    FOREACH i500_p_cs INTO g_img_p[g_cnt_p].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT imgg10 INTO  g_img_p[g_cnt_p].imgg10 FROM imgg_file
           WHERE imgg01=g_img_p[g_cnt_p].img01 AND imgg02=g_img_p[g_cnt_p].img02
             AND imgg03=g_img_p[g_cnt_p].img03 AND imgg04=g_img_p[g_cnt_p].img04

      LET l_idv18 = 0
      LET l_idv20 = 0
      SELECT SUM(idv18),SUM(idv20) 
        INTO l_idv18,l_idv20 
        FROM idu_file,idv_file
       WHERE idu01 = idv01
         AND iduconf = 'N'
         AND idv13 = g_img_p[g_cnt_p].img01
         AND idv14 = g_img_p[g_cnt_p].img02
         AND idv15 = g_img_p[g_cnt_p].img03
         AND idv16 = g_img_p[g_cnt_p].img04
      IF cl_null(l_idv18) THEN LET l_idv18 = 0 END IF
      IF cl_null(l_idv20) THEN LET l_idv20 = 0 END IF

      LET g_img_p[g_cnt_p].img10 = g_img_p[g_cnt_p].img10 - l_idv18
      LET g_img_p[g_cnt_p].imgg10= g_img_p[g_cnt_p].imgg10- l_idv20

      IF g_img_p[g_cnt_p].img10 <= 0 THEN
         CONTINUE FOREACH
      END IF

      LET g_cnt_p = g_cnt_p + 1
      IF g_cnt_p > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
    END FOREACH
    CALL g_img_p.deleteElement(g_cnt_p)

    LET g_rec_b3=g_cnt_p-1               #告訴I.單身筆數
    DISPLAY g_rec_b3 TO FORMONLY.cn2

END FUNCTION

FUNCTION i500_p_b()
DEFINE  l_str           LIKE type_file.chr1000,
        j               LIKE type_file.num5,
        l_cnt           LIKE type_file.num5,
        l_unit          LIKE ogb_file.ogb05,
        i               LIKE type_file.num5,
        l_idv           RECORD LIKE idv_file.*
DEFINE  l_ima906        LIKE ima_file.ima906,
        l_icb05         LIKE icb_file.icb05,
        l_ima907        LIKE ima_file.ima907
DEFINE  p_success1  LIKE type_file.chr1,
        l_ecdicd01  LIKE ecd_file.ecdicd01,
        l_imaicd04  LIKE imaicd_file.imaicd04
DEFINE  t_imaicd04  LIKE imaicd_file.imaicd04   
DEFINE  l_flag      LIKE type_file.chr1        
DEFINE  l_idv18 LIKE idv_file.idv18     
DEFINE  l_idv20 LIKE idv_file.idv20     

   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')

   SELECT ecdicd01 INTO l_ecdicd01 FROM ecd_file WHERE ecd01=g_idu.idu13

   LET l_flag = 'Y'   
   WHILE TRUE
      IF l_flag = 'N' THEN
         CALL i500_p_b_fill()
         LET l_flag = 'Y'
      END IF
    INPUT ARRAY g_img_p WITHOUT DEFAULTS FROM s_img_p.*
          ATTRIBUTE(COUNT=g_rec_b3,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)

        BEFORE ROW
            LET l_ac = ARR_CURR()

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT

       ON ACTION CONTROLZ
          CALL cl_show_req_fields()

       ON ACTION CONTROLG
          CALL cl_cmdask()

       ON ACTION select_all
          LET l_cnt=0
          FOR g_i = 1 TO g_rec_b3   #將所有的設為選擇
              LET g_img_p[g_i].choice='Y'          #設定為選擇
              LET l_cnt=l_cnt+1                   #累加已選筆數
          END FOR

       ON ACTION cancel_all
          FOR g_i = 1 TO g_rec_b3     #將所有的設為選擇
              LET g_img_p[g_i].choice="N"
          END FOR
          LET l_cnt = 0

       ON ACTION ima_detail
          LET g_msg='aimi100_icd ',g_img_p[l_ac].img01
          CALL cl_cmdrun(g_msg)

       # 重新查詢
       ON ACTION reconstruct
          CALL g_img_p.clear() 
          LET l_flag = 'N'
          EXIT INPUT
          
    END INPUT
     IF INT_FLAG THEN LET INT_FLAG =0 EXIT WHILE END IF
     IF l_flag = 'N' THEN CONTINUE WHILE END IF  
    
     #單身項次
     LET j = 0
     SELECT MAX(idv02) INTO j FROM idv_file WHERE idv01=g_idu.idu01
     IF cl_null(j) THEN LET j = 0 END IF
     FOR i=1 TO g_rec_b3
         IF g_img_p[i].choice <> 'Y' THEN
            CONTINUE FOR
         ELSE
            SELECT imaicd04 INTO l_imaicd04 FROM imaicd_file WHERE imaicd00=g_img_p[i].img01 
               CASE WHEN l_ecdicd01 = '4'   #AS
                         IF l_imaicd04 = '4' THEN
                            CALL cl_err(g_img_p[i].img01,'aic-337',1)
                            CONTINUE FOR 
                         END IF
                    WHEN l_ecdicd01 = '2'   #CP
                         IF l_imaicd04 = '3' OR l_imaicd04 = '4' THEN
                            CALL cl_err(g_img_p[i].img01,'aic-337',1)
                            CONTINUE FOR 
                         END IF
               END CASE
         END IF
         LET j = j + 1
         LET l_idv.idv01     = g_idu.idu01
         LET l_idv.idv02     = j 
         LET l_idv.idv09     = 'N'
         LET l_idv.idv04     = g_today
         LET l_idv.idv12 = '1'
         LET l_idv.idv13 = g_img_p[i].img01
         
         #順序為 BOM,替代料
         SELECT MIN(bmb01) INTO  l_idv.idv03 FROM bmb_file
            WHERE bmb03 = l_idv.idv13
         
         #替代料
         IF cl_null(l_idv.idv03) THEN
            SELECT bmb01 INTO  l_idv.idv03 
            FROM (select bmd01,bmd04,bmd05
                        ,bmb01,bmb03,bmb04
                  from bmd_file,bmb_file
                  where bmd01=bmb03
                  and bmd04 = l_idv.idv13
                  and bmdacti='Y'
                  order by bmd01,bmd05 desc) aa         
            where ROWNUM = 1    
         END IF
         
         #改為讀取下階料號表icm_file   
         IF cl_null(l_idv.idv03) THEN
            SELECT icm02 INTO  l_idv.idv03 
            FROM (select icm01,icm02 from icm_file
                  WHERE icm01 = l_idv.idv13
                    and icmacti='Y'
                    order by icmdate desc) aa         
            where ROWNUM = 1    
         END IF
         
         SELECT ima25 INTO l_idv.idv25 FROM ima_file WHERE ima01=l_idv.idv03
         LET l_idv.idv14 = g_img_p[i].img02
         LET l_idv.idv15 = g_img_p[i].img03
         LET l_idv.idv16 = g_img_p[i].img04
         LET l_idv.idv17 = g_img_p[i].ima25
         LET l_idv.idv18 = g_img_p[i].img10
         LET l_idv.idv21 = g_idu.idu13
         LET l_idv.idv22 = g_idu.idu23
         LET l_idv.idv24 = l_idv.idv16
         LET l_idv.idv26 = g_img_p[i].img10
         LET l_idv.idvplant = g_plant
         LET l_idv.idvlegal = g_legal
         
         SELECT MAX(pjb02) INTO l_idv.idv32
           FROM pjb_file
          WHERE pjb01 = l_idv.idv31
            AND pjbacti = 'Y'

         SELECT ima906,ima907 INTO l_ima906,l_ima907 FROM ima_file
              WHERE ima01=g_img_p[i].img01
         IF l_ima906 = '3' THEN
            LET l_idv.idv19 = l_ima907
            SELECT imgg10 INTO l_idv.idv20 FROM imgg_file
                 WHERE imgg01=l_idv.idv13 AND imgg02=l_idv.idv14
                   AND imgg03=l_idv.idv15 AND imgg04=l_idv.idv16

            LET l_idv20 = 0
            SELECT SUM(idv20) 
              INTO l_idv20 
              FROM idu_file,idv_file
             WHERE idu01 = idv01
               AND iduconf = 'N'
               AND idv13 = l_idv.idv13
               AND idv14 = l_idv.idv14
               AND idv15 = l_idv.idv15
               AND idv16 = l_idv.idv16
               AND idv19 = l_idv.idv19
            IF cl_null(l_idv20) THEN LET l_idv20 = 0 END IF
            LET l_idv.idv20 = l_idv.idv20-l_idv20
            LET l_idv.idv26 = g_img_p[i].img10
            LET l_idv.idv28 = g_img_p[i].imgg10
            LET l_idv.idv27 = l_ima907
         END IF
         IF l_imaicd04 = '1' THEN
            SELECT SUM(idc12) INTO l_idv.idv26 FROM idc_file
                 WHERE idc01=l_idv.idv13 AND idc02=l_idv.idv14
                   AND idc03=l_idv.idv15 AND idc04=l_idv.idv16
            SELECT ima25 INTO l_idv.idv27 FROM ima_file WHERE ima01=l_idv.idv13
            LET l_idv.idv28 = g_img_p[i].img10
         END IF

         #發料料號
         LET l_imaicd04 = ''
         SELECT imaicd04 INTO l_imaicd04 FROM imaicd_file
          WHERE imaicd00 = l_idv.idv13 
         #生產料號
         LET t_imaicd04 = ''
         SELECT imaicd04 INTO t_imaicd04 FROM imaicd_file
          WHERE imaicd00 = l_idv.idv03

         IF l_imaicd04='1' THEN
            LET l_icb05 = 0
            SELECT icb05 INTO l_icb05 FROM icb_file WHERE icb01 = l_idv.idv13
            IF cl_null(l_icb05) THEN LET l_icb05 = 0 END IF
         
            CASE
               WHEN t_imaicd04 = '2'
                  LET l_idv.idv26 = l_idv.idv18
                  LET l_idv.idv28 = l_idv.idv18 * l_icb05
         
               WHEN t_imaicd04 = '3' OR t_imaicd04 = '4'
                  LET l_idv.idv26 = l_idv.idv18 * l_icb05
               OTHERWISE EXIT CASE
            END CASE
         END IF
         
         IF l_imaicd04 = '2' THEN
            CASE
               WHEN t_imaicd04 = '2'
                  LET l_idv.idv26 = l_idv.idv18
                  LET l_idv.idv28 = l_idv.idv20
         
               WHEN t_imaicd04 = '3' OR t_imaicd04 = '4'
                  LET l_idv.idv26 = l_idv.idv20
               OTHERWISE EXIT CASE
            END CASE
         END IF
         
         IF l_imaicd04 = '3' THEN
            CASE
               WHEN t_imaicd04 = '3' OR t_imaicd04 = '4'
                  LET l_idv.idv26 = l_idv.idv18
               OTHERWISE EXIT CASE
            END CASE
         END IF

         IF cl_null(l_idv.idv20) THEN LET l_idv.idv20 = 0 END IF 

         # 填入單身
         INSERT INTO idv_file VALUES(l_idv.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","idv_file",l_idv.idv01,"",SQLCA.sqlcode,"","ins idv",1)
            EXIT WHILE
         END IF
     END FOR
     EXIT WHILE
   END WHILE
END FUNCTION

#FUNCTION i500_out1()
#   DEFINE l_task    LIKE type_file.chr1
#   
#   CASE g_idu.idu13
#      WHEN 'CP'     LET l_task = '1'
#      WHEN 'AS'     LET l_task = '2'
#      WHEN 'FT'     LET l_task = '3'
#      OTHERWISE RETURN
#   END CASE
#
#   LET g_cmd = "csfr300",
#               " '",g_today,"'",
#               " '",g_user,"'",
#               " '",g_lang,"'", 
#               " 'Y'",
#               " ' '",
#               " '1'",
#               " '",g_idu.idu01,"'",
#               " '",l_task,"'"
#
#   CALL cl_cmdrun(g_cmd CLIPPED)
#END FUNCTION

#FUN-CA0022
#FUN-CC0077
